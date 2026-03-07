; ==================================================================================================
; ENEMY_BOOMERANG_MOBLIN
; ==================================================================================================
enemyCode0a:
	call ecom_checkHazards
	jr z,@normalStatus

	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@dead:
	ld e,Enemy.relatedObj2+1
	ld a,(de)
	or a
	jr z,++
	ld h,a
	ld l,Part.relatedObj1+1
	ld (hl),$ff
++
	jp enemyDie

@normalStatus:
	call ecom_checkScentSeedActive
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_scentSeed
	.dw ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state_8
	.dw @state_9
	.dw @state_a


@state_uninitialized:
	ld a,SPEED_80
	call ecom_setSpeedAndState8AndVisible
	ld l,Enemy.var3f
	set 4,(hl)
	jp @gotoState8WithRandomAngleAndCounter


@state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jp z,@gotoState8WithRandomAngleAndCounter

	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a

	call ecom_updateAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemy
	jp enemyAnimate


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
	ld b,$0a
	jp ecom_fallToGroundAndSetState

@state_stub:
	ret


; Moving until counter1 reaches 0
@state_8:
	call ecom_decCounter1
	jr z,++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,@animate
++
	ld e,Enemy.state
	ld a,$09
	ld (de),a
@animate:
	jp enemyAnimate


; Shoot a boomerang if Link is in that general direction; otherwise go back to state 8.
@state_9:
	call @gotoState8WithRandomAngleAndCounter
	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	swap a
	rlca
	ld h,d
	ld l,Enemy.direction
	cp (hl)
	ret nz

	; Spawn projectile
	ld b,PART_MOBLIN_BOOMERANG
	call ecom_spawnProjectile
	ret nz
	ld h,d
	ld l,Enemy.state
	ld (hl),$0a
	ret


; Waiting for boomerang to return
@state_a:
	ld e,Enemy.relatedObj2+1
	ld a,(de)
	or a
	jr nz,@animate

@gotoState8WithRandomAngleAndCounter:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counterVals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ld e,Enemy.state
	ld a,$08
	ld (de),a
	call ecom_setRandomCardinalAngle
	jp ecom_updateAnimationFromAngle

@counterVals:
	.db $30 $40 $50 $60
