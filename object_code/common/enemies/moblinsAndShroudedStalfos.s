; ==================================================================================================
; ENEMY_ARROW_MOBLIN
; ENEMY_MASKED_MOBLIN
; ENEMY_ARROW_SHROUDED_STALFOS
;
; These enemies and ENEMY_ARROW_DARKNUT share some code.
; ==================================================================================================
enemyCode0c:
enemyCode20:
enemyCode22:
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
	set 1,(hl)
++
	jp enemyDie

@normalStatus:
	call ecom_checkScentSeedActive
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw moblin_state_uninitialized
	.dw moblin_state_stub
	.dw moblin_state_stub
	.dw moblin_state_switchHook
	.dw moblin_state_scentSeed
	.dw ecom_blownByGaleSeedState
	.dw moblin_state_stub
	.dw moblin_state_stub
	.dw moblin_state_8
	.dw moblin_state_9


moblin_state_uninitialized:
	; Enable chasing scent seeds
	ld h,d
	ld l,Enemy.var3f
	set 4,(hl)

	ld l,Enemy.subid
	bit 1,(hl)
	jr z,++
	ld a,(wKilledGoldenEnemies)
	bit 1,a
	jp nz,enemyDelete
++
	jp arrowDarknut_state_uninitialized


moblin_state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jp z,arrowDarknut_setState8WithRandomAngleAndCounter

	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a
	call ecom_updateAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemy
	jp enemyAnimate


; Also used by darknuts
moblin_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw ecom_fallToGroundAndSetState8

@substate1:
@substate2:
	ret


moblin_state_stub:
	ret


; Also darknut state 8 (moving in some direction)
moblin_state_8:
	call ecom_decCounter1
	jr z,+
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,++
+
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$08
++
	jp enemyAnimate


; Standing until counter1 reaches 0 and a new direction is decided on.
moblin_state_9:
	call ecom_decCounter1
	ret nz
	call ecom_setRandomCardinalAngle
	call arrowDarknut_setState8WithRandomAngleAndCounter
	jr arrowDarknut_fireArrowEveryOtherTime
