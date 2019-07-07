itemCode1f:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	call _itemLoadAttributesAndGraphics

	ld hl,@offsets
	call _applyOffsetTableHL

	call objectSetVisible80
	xor a
	call itemSetAnimation
	ret

@offsets:
	.db -10, 0, 0
	.db 0, 10, 0
	.db 10, 0, 0
	.db 0, -10, 0

@state1:
	ld e,Item.animParameter
	ld a,(de)
	and $80
	jp nz,itemDelete

	call _itemUpdateDamageToApply
	jr nz,@collisionWithEnemy

	jp itemAnimate

@collisionWithEnemy:
	ld a,SND_LIGHTTORCH
	call playSound
	jp itemDelete
