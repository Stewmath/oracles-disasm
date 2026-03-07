; ==================================================================================================
; ENEMY_TEKTITE
;
; Variables:
;   var30: Gravity
;   var31: Minimum value for counter1 (lower value = more frequent jumping)
; ==================================================================================================
enemyCode30:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_stub
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB


@state_uninitialized:
	; Subid 1 has lower value for var31, meaning more frequent jumps.
	ld h,d
	ld l,Enemy.subid
	bit 0,(hl)
	ld l,Enemy.var31
	ld (hl),90
	jr z,+
	ld (hl),45
+
	call getRandomNumber_noPreserveVars
	and $7f
	inc a
	ld e,Enemy.counter1
	ld (de),a
	ld a,SPEED_140
	jp ecom_setSpeedAndState8AndVisible


@state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret

@substate3:
	ld b,$08
	call ecom_fallToGroundAndSetState
	ret nz
	jp @gotoState8


@state_stub:
	ret


; Standing in place for [counter1] frames
@state8:
	call ecom_decCounter1
	jr nz,@animate

	; Set [counter1] to how long the crouch will last
	call getRandomNumber_noPreserveVars
	and $7f
	call ecom_incState
	ld l,Enemy.var31
	add (hl)
	ld l,Enemy.counter1
	ldi (hl),a
	ld (hl),$18
	ld a,$01
	jp enemySetAnimation
@animate:
	jp enemyAnimate


; Crouching before a leap
@state9:
	call ecom_decCounter2
	ret nz
	ld l,e
	inc (hl)
	ld a,$02
	jp enemySetAnimation


; About to start a leap
@stateA:
	ld a,$0b
	ld (de),a ; [state]

	call getRandomNumber_noPreserveVars
	and $07
	ld hl,@smallLeap
	jr nz,+
	ld hl,@bigLeap
+
	ld e,Enemy.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	; Gravity
	ld e,Enemy.var30
	ldi a,(hl)
	ld (de),a

	call ecom_updateAngleTowardTarget
	ld a,SND_ENEMY_JUMP
	call playSound
	jp objectSetVisiblec1


; speedZ, gravity
@smallLeap:
	dwb $feaa, $0e
@bigLeap:
	dwb $fe80, $0c


; Leaping
@stateB:
	call ecom_bounceOffScreenBoundary
	ld e,Enemy.var30
	ld a,(de)
	ld c,a
	call objectUpdateSpeedZ_paramC
	jp nz,ecom_applyVelocityForSideviewEnemy

;;
@gotoState8:
	call getRandomNumber_noPreserveVars
	and $7f
	ld h,d
	ld l,Enemy.var31
	add (hl)
	ld l,Enemy.counter1
	ld (hl),a
	ld l,Enemy.state
	ld (hl),$08
	xor a
	call enemySetAnimation
	jp objectSetVisiblec2
