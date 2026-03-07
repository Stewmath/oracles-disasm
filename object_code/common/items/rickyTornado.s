;;
; ITEM_RICKY_TORNADO
itemCode2a:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1


; State 0: initialization
@state0:
	call itemIncState
	ld l,Item.speed
	ld (hl),SPEED_300

	ld a,(w1Companion.direction)
	ld c,a
	swap a
	rrca
	ld l,Item.angle
	ld (hl),a

	; Get offset from companion position to spawn at in 'bc'
	ld a,c
	ld hl,@offsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a

	; Copy companion's position
	ld hl,w1Companion.yh
	call objectTakePositionWithOffset

	; Make Z position 2 higher than companion
	sub $02
	ld (de),a

	call itemLoadAttributesAndGraphics
	xor a
	call itemSetAnimation
	jp objectSetVisiblec1

@offsets:
	.db $f0 $00 ; DIR_UP
	.db $00 $0c ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f4 ; DIR_LEFT


; State 1: flying away until it hits something
@state1:
	call objectApplySpeed

	ld a,BREAKABLETILESOURCE_SWORD_L1
	call itemTryToBreakTile

	call objectGetTileCollisions
	and $0f
	cp $0f
	jp z,itemDelete

	jp itemAnimate
