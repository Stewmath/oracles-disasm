; ==================================================================================================
; PART_CANDLE_FLAME
; ==================================================================================================
partCode36:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMY_CANDLE
	jp nz,partDelete

	ld b,h
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]
	call objectSetVisible81

@state1:
	; Check parent's speed
	ld h,b
	ld l,Enemy.speed
	ld a,(hl)
	cp SPEED_100
	jr z,@state2

	ld a,$02
	ld (de),a ; [state]

	push bc
	dec a
	call partSetAnimation
	pop bc

@state2:
	ld h,b
	ld l,Enemy.enemyCollisionMode
	ld a,(hl)
	cp ENEMYCOLLISION_PODOBOO
	jp z,partDelete

	call objectTakePosition
	ld e,Part.zh
	ld a,$f3
	ld (de),a
	jp partAnimate
