; ==================================================================================================
; ENEMY_BABY_CUCCO
; ==================================================================================================
enemyCode33:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw babyCucco_state_uninitialized
	.dw babyCucco_state_stub
	.dw babyCucco_state_grabbed
	.dw babyCucco_state_stub
	.dw babyCucco_state_stub
	.dw babyCucco_state_stub
	.dw babyCucco_state_stub
	.dw babyCucco_state_stub
	.dw babyCucco_state8
	.dw babyCucco_state9


babyCucco_state_uninitialized:
	ld a,SPEED_40
	jp ecom_setSpeedAndState8AndVisible


babyCucco_state_grabbed:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @landed

@justGrabbed:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.collisionType
	res 7,(hl)

	xor a
	ld (wLinkGrabState2),a

	ld a,(w1Link.direction)
	srl a
	xor $01
	ld l,Enemy.direction
	ld (hl),a
	call enemySetAnimation

	jp objectSetVisiblec1

@beingHeld:
	ld h,d
	ld l,Enemy.direction
	ld a,(w1Link.direction)
	srl a
	xor $01
	cp (hl)
	jr z,@released
	ld (hl),a
	jp enemySetAnimation

@released:
	ld e,Enemy.yh
	ld a,(de)
	cp SMALL_ROOM_HEIGHT<<4
	jr nc,@delete

	ld e,Enemy.xh
	ld a,(de)
	cp SMALL_ROOM_WIDTH<<4
	jp c,enemyAnimate
@delete:
	jp enemyDelete

@landed:
	ld h,d
	ld l,Enemy.state
	ld (hl),$08
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.direction
	ld (hl),$ff
	jp objectSetVisiblec2


babyCucco_state_stub:
	ret


babyCucco_state8:
	call objectAddToGrabbableObjectBuffer
	call objectSetPriorityRelativeToLink_withTerrainEffects

	call ecom_updateAngleTowardTarget
	call babyCucco_updateAnimationFromAngle

	ld c,$10
	call objectCheckLinkWithinDistance
	jr nc,@moveCloserToLink

	; If near Link, 1 in 64 chance of hopping (per frame)
	call getRandomNumber_noPreserveVars
	and $3f
	ret nz

	call ecom_incState
	ld l,Enemy.speedZ
	ld a,<($ff40)
	ldi (hl),a
	ld (hl),>($ff40)
	ret

@moveCloserToLink:
	call ecom_applyVelocityForSideviewEnemyNoHoles

babyCucco_animate:
	jp enemyAnimate


; Hopping
babyCucco_state9:
	ld c,$12
	call objectUpdateSpeedZ_paramC
	jr nz,babyCucco_animate

	ld l,Enemy.state
	dec (hl)
	ret


;;
babyCucco_updateAnimationFromAngle:
	ld e,Enemy.angle
	ld a,(de)
	cp $10
	ld a,$01
	jr c,+
	xor a
+
	ld h,d
	ld l,Enemy.direction
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation
