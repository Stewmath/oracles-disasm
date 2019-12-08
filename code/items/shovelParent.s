;;
; ITEMID_SHOVEL ($15)
; @addr{4f9f}
_parentItemCode_shovel:
	ld e,Item.state		; $4f9f
	ld a,(de)		; $4fa1
	rst_jumpTable			; $4fa2

	.dw @state0
	.dw @state1

@state0:
	call _checkLinkOnGround		; $4fa7
	jp nz,_clearParentItem		; $4faa
	jp _parentItemLoadAnimationAndIncState		; $4fad

@state1:
	call _specialObjectAnimate		; $4fb0
	ld e,Item.animParameter		; $4fb3
	ld a,(de)		; $4fb5
	bit 7,a			; $4fb6
	jp nz,_clearParentItem		; $4fb8

	; When [animParameter] == 1, create the child item
	dec a			; $4fbb
	ret nz			; $4fbc

	ld (de),a		; $4fbd
	call itemCreateChildIfDoesntExistAlready		; $4fbe

	; Calculate Y/X position to give to child item
	push hl			; $4fc1
	ld l,Item.direction		; $4fc2
	ld a,(hl)		; $4fc4
	ld hl,@offsets		; $4fc5
	rst_addDoubleIndex			; $4fc8
	ldi a,(hl)		; $4fc9
	ld c,(hl)		; $4fca
	pop hl			; $4fcb
	ld l,Item.yh		; $4fcc
	add (hl)		; $4fce
	ldi (hl),a		; $4fcf
	inc l			; $4fd0
	ld a,(hl)		; $4fd1
	add c			; $4fd2
	ldi (hl),a		; $4fd3
	ret			; $4fd4

@offsets:
	.db $f8 $00 ; DIR_UP
	.db $04 $06 ; DIR_RIGHT
	.db $07 $00 ; DIR_DOWN
	.db $04 $f9 ; DIR_LEFT
