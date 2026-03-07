; ==================================================================================================
; ENEMY_ROPE
;
; Variables:
;   counter2: Cooldown until rope can charge at Link again
;   var30: Hazards are checked iff bit 7 is set.
; ==================================================================================================
enemyCode10:
	call rope_checkHazardsIfApplicable
	or a
	jr z,@normalStatus

	sub $03
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@normalStatus:
	call ecom_checkScentSeedActive
	jr z,++
	ld e,Enemy.speed
	ld a,SPEED_140
	ld (de),a
++
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_scentSeed
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub


@normalState:
	ld a,b
	rst_jumpTable
	.dw rope_subid00
	.dw rope_subid01
	.dw rope_subid02
	.dw rope_subid03


@state_uninitialized:
	ld e,Enemy.direction
	ld a,$ff
	ld (de),a

	; Subid 1: make speed lower?
	dec b
	ld a,SPEED_60
	jp z,ecom_setSpeedAndState8

	; Enable scent seed effect
	ld h,d
	ld l,Enemy.var3f
	set 4,(hl)

	jp ecom_setSpeedAndState8AndVisible


@state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate1:
@@substate2:
	ret


@@substate3:
	ld e,Enemy.subid
	ld a,(de)
	ld hl,@defaultStates
	rst_addAToHl
	ld b,(hl)
	jp ecom_fallToGroundAndSetState


@state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jr nz,++

	ld e,Enemy.subid
	ld a,(de)
	ld hl,@defaultStates
	rst_addAToHl
	ld e,Enemy.state
	ld a,(hl)
	ld (de),a
	ld e,Enemy.speed
	ld a,SPEED_60
	ld (de),a
	ret
++
	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a
	call rope_updateAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemy
	jp rope_animate


@defaultStates: ; Default states for each subid
	.db $09 $0b $0a $0a


@state_stub:
	ret


; Normal rope.
rope_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw rope_state_moveAround
	.dw rope_state_chargeLink


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.var30
	set 7,(hl)


; Moving around, checking whether to charge Link
rope_state_moveAround:
	ld b,$0a
	call objectCheckCenteredWithLink
	jr nc,++

	ld e,Enemy.counter2
	ld a,(de)
	or a
	jr nz,++

	; Charge at Link
	call ecom_updateCardinalAngleTowardTarget
	call ecom_incState
	ld l,Enemy.speed
	ld (hl),SPEED_140
	jp rope_updateAnimationFromAngle

++
	call ecom_decCounter2
	dec l
	dec (hl) ; [counter1]--
	call nz,ecom_applyVelocityForSideviewEnemyNoHoles
	jp z,rope_changeDirection

rope_callEnemyAnimate:
	jp enemyAnimate


; Charging Link
rope_state_chargeLink:
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp nz,rope_animate

	ld h,d
	ld l,Enemy.state
	dec (hl)

	ld l,Enemy.speed
	ld (hl),SPEED_60
	ld l,Enemy.counter2
	ld (hl),$40
	jp rope_changeDirection


; Rope that falls from the sky.
rope_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw rope_state_moveAround
	.dw rope_state_chargeLink


; Initialization
@state8:
	ld a,$09
	ld (de),a
	call getRandomNumber_noPreserveVars
	ld e,Enemy.counter1
	and $38
	inc a
	ld (de),a
	ret


; Wait a random amount of time before dropping from the sky
@state9:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]++

	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.var30
	set 7,(hl)

	ld l,Enemy.speedZ+1
	inc (hl)

	ld a,SND_FALLINHOLE
	call playSound
	call objectSetVisiblec1

	ld c,$08
	jp ecom_setZAboveScreen


; Currently falling from the sky
@stateA:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	ret nz

	ld l,Enemy.speedZ
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.state
	inc (hl)

	; Enable scent seeds
	ld l,Enemy.var3f
	set 4,(hl)

	call objectSetVisiblec2
	ld a,SND_BOMB_LAND
	call playSound

	call rope_changeDirection
	jr rope_callEnemyAnimate


; Immediately charges Link upon spawning
rope_subid02:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw rope_state_moveAround
	.dw rope_state_chargeLink


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.speed
	ld (hl),SPEED_140
	ld l,Enemy.counter1
	ld (hl),$08
	call ecom_updateCardinalAngleTowardTarget
	jp rope_updateAnimationFromAngle


; Waiting just before charging Link
@state9:
	call ecom_decCounter1
	jr nz,++

	ld l,e
	ld (hl),$0b ; [state] = "charge at Link" state

	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.var30
	set 7,(hl)
++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp enemyAnimate


; Falls and bounces toward Link when it spawns
rope_subid03:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw rope_state_moveAround
	.dw rope_state_chargeLink


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.speedZ
	ld a,$fe
	ldi (hl),a
	ld (hl),$fe

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	ld l,Enemy.angle
	ld a,(w1Link.direction)
	swap a
	rrca
	ld (hl),a

	jp rope_updateAnimationFromAngle


; "Bouncing" toward Link
@state9:
	ld c,$0e
	call objectUpdateSpeedZAndBounce
	jr c,@doneBouncing

	ld a,SND_BOMB_LAND
	call z,playSound

	; Enable collisions if speedZ is positive?
	ld e,Enemy.speedZ+1
	ld a,(de)
	or a
	jr nz,++
	ld h,d
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.var30
	set 7,(hl)
++
	jp ecom_applyVelocityForSideviewEnemyNoHoles

@doneBouncing:
	call ecom_incState
	ld l,Enemy.speed
	ld (hl),SPEED_60

;;
; Chooses random new angle, random value for counter1.
rope_changeDirection:
	ldbc $18,$70
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,b
	ld (de),a
	ld e,Enemy.counter1
	ld a,c
	add $70
	ld (de),a

;;
rope_updateAnimationFromAngle:
	ld h,d
	ld l,Enemy.angle
	ld a,(hl)
	and $0f
	ret z

	ldd a,(hl)
	and $10
	swap a
	xor $01
	cp (hl)
	ret z

	ld (hl),a
	jp enemySetAnimation

;;
rope_animate:
	ld h,d
	ld l,Enemy.animCounter
	ld a,(hl)
	sub $03
	jr nc,+
	xor a
+
	inc a
	ld (hl),a
	jp enemyAnimate

;;
rope_checkHazardsIfApplicable:
	ld h,d
	ld l,Enemy.var30
	bit 7,(hl)
	ret z
	jp ecom_checkHazards
