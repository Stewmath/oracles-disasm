; ==================================================================================================
; ENEMY_BUTTERFLY
; ==================================================================================================
enemyCode37:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
.ifdef ROM_SEASONS
	; spring-only
	ld a,(wRoomStateModifier)
	or a
	jp nz,enemyDelete
.endif
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_40
	call ecom_setRandomAngle

	jp objectSetVisible81

@state1:
	ld bc,$1f1f
	call ecom_randomBitwiseAndBCE
	or b
	jr nz,++
	ld h,d
	ld l,Enemy.angle
	ld (hl),c
++
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary
	jp enemyAnimate
