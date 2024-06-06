;;
; ITEMID_SHOVEL ($15)
parentItemCode_shovel:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1

@state0:
	call checkLinkOnGround
	jp nz,clearParentItem
	jp parentItemLoadAnimationAndIncState

@state1:
	call specialObjectAnimate_optimized
	ld e,Item.animParameter
	ld a,(de)
	bit 7,a
	jp nz,clearParentItem

	; When [animParameter] == 1, create the child item
	dec a
	ret nz

	ld (de),a
	call itemCreateChildIfDoesntExistAlready

	; Calculate Y/X position to give to child item
	push hl
	ld l,Item.direction
	ld a,(hl)
	ld hl,@offsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	pop hl
	ld l,Item.yh
	add (hl)
	ldi (hl),a
	inc l
	ld a,(hl)
	add c
	ldi (hl),a
	ret

@offsets:
	.db $f8 $00 ; DIR_UP
	.db $04 $06 ; DIR_RIGHT
	.db $07 $00 ; DIR_DOWN
	.db $04 $f9 ; DIR_LEFT
