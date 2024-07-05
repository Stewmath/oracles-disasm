; ==================================================================================================
; ENEMY_LYNEL
;
; Variables:
;   var30: Determines probability that the Lynel turns toward Link whenever it turns (less
;          bits set = more likely).
; ==================================================================================================
enemyCode0d:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@dead:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr nz,++
	ld hl,wKilledGoldenEnemies
	set 3,(hl)
++
	jp enemyDie

@normalStatus:
	call ecom_checkScentSeedActive
	jr z,++
	ld e,Enemy.speed
	ld a,SPEED_100
	ld (de),a
++
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_scentSeed
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_08
	.dw @state_09
	.dw @state_0a


@state_uninitialized:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr nz,++
	ld hl,wKilledGoldenEnemies
	bit 3,(hl)
	jp nz,enemyDelete
++
	ld e,Enemy.subid
	ld a,(de)
	ld hl,@var30Vals
	rst_addAToHl
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a

	call objectSetVisiblec2
	call getRandomNumber_noPreserveVars
	and $30
	ld c,a
	ld h,d

	; Enable scent seed effect
	ld l,Enemy.var3f
	set 4,(hl)

	ld l,Enemy.state
	jp @changeDirection

@var30Vals:
	.db $07 $03 $01


@state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jp z,@gotoState8
	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a
	ld b,$04
	call @updateAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemy
	jp enemyAnimate

@state_stub:
	ret


; Choose whether to walk around some more, or fire a projectile.
@state_08:
	ld e,Enemy.var30
	ld a,(de)
	ld b,a
	ld c,$30
	call ecom_randomBitwiseAndBCE
	or b
	ld h,d
	ld l,Enemy.state
	jr z,@prepareProjectile

@changeDirection:
	ld (hl),$09 ; [state] = $09
	ld l,Enemy.counter1
	ld a,$30
	add c
	ld (hl),a
	jr @updateAngleAndSpeed

@prepareProjectile:
	ld (hl),$0a ; [state] = $0a
	ld l,Enemy.counter1
	ld (hl),$08
	call ecom_updateCardinalAngleTowardTarget
	jp ecom_updateAnimationFromAngle


; Moving until counter1 reaches 0, then return to state 8
@state_09:
	call ecom_decCounter1
	jr z,@gotoState8
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr z,@updateAngleAndSpeed
@animate:
	jp enemyAnimate


; Standing for a moment before firing projectile
@state_0a:
	call ecom_decCounter1
	jr nz,@animate
	ld b,PART_LYNEL_BEAM
	call ecom_spawnProjectile
	jr nz,@gotoState8

	call getRandomNumber_noPreserveVars
	and $30
	add $30
	ld e,Enemy.counter1
	ld (de),a

	ld h,d
	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.state
	ld (hl),$09
	jr @animate

@gotoState8:
	ld e,Enemy.state
	ld a,$08
	ld (de),a
	jr @animate

;;
; The lynel turns, and if Link is in its sights, it charges.
@updateAngleAndSpeed:
	call @chooseNewAngle
	ld b,$0e
	call objectCheckCenteredWithLink
	jr nc,++

	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	ld h,d
	ld l,Enemy.angle
	cp (hl)
	ld a,SPEED_100
	ld b,$04
	jr z,+++
++
	ld a,SPEED_80
	ld b,$00
+++
	ld l,Enemy.speed
	ld (hl),a

;;
; @param	b	0 if walking, 4 if running (value to add to animation)
@updateAnimationFromAngle:
	ld h,d
	ld l,Enemy.angle
	ldd a,(hl)
	swap a
	rlca
	add b
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
; Chooses a new angle; var30 sets the probability that it will turn to face Link instead
; of just a random direction.
@chooseNewAngle:
	call getRandomNumber_noPreserveVars
	ld h,d
	ld l,Enemy.var30
	and (hl)
	jp nz,ecom_setRandomCardinalAngle
	jp ecom_updateCardinalAngleTowardTarget
