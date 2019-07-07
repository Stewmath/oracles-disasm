itemCode1f:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a

	; Collisions enabled after several frames
	ld a,10
	ld e,Item.counter1
	ld (de),a

	call _itemLoadAttributesAndGraphics

	; Offset based on facing direction
	ld hl,@offsets
	call _applyOffsetTableHL

	call objectSetVisible80
	xor a
	call itemSetAnimation
	ret

@offsets:
	.db -12, 0, 0
	.db 0, 12, 0
	.db 12, 0, 0
	.db 0, -12, 0

@state1:
	call itemDecCounter1
	jr nz,@state2

	ld h,d
	ld e,Item.state
	inc (hl)

	ld l,Item.collisionType
	set 7,(hl)

	; Check for collision with bush.
	call objectGetTileAtPosition
	ld hl,@bushCollisions
	call lookupCollisionTable
	jr nc,@state2

	ld a,BREAKABLETILESOURCE_0c
	call itemTryToBreakTile
	jr nc,@state2

	; Collision with bush
	call objectCenterOnTile
	ld e,Item.zh
	xor a
	ld (de),a
	ld b,INTERACID_PUFF
	call objectCreateInteractionWithSubid00
	jp itemDelete


@state2:
	ld e,Item.animParameter
	ld a,(de)
	and $80
	jp nz,itemDelete

	call _itemUpdateDamageToApply
	jr nz,@collisionWithEnemy

	ld a,$0a
	call objectUpdateSpeedZ

@animate:
	jp itemAnimate

@collisionWithEnemy:
	ld a,SND_LIGHTTORCH
	call playSound
	jp itemDelete


@bushCollisions:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0: ; Outdoors
	.db $c4 $00 ; Bushes
	.db $c5 $00
	.db $c6 $00
	.db $c7 $00
	.db $e5 $00
	.db $d8 $00 ; Flowers
	.db $d9 $00
	.db $da $00
	.db $00

@collisions1:
@collisions2:
@collisions5:
	.db $00

@collisions3:
@collisions4:
	.db $20 $00 ; Bushes
	.db $21 $00
	.db $22 $00
	.db $23 $00
	.db $00
