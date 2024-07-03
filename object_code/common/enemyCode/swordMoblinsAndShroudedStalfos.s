; ==============================================================================
; ENEMY_SWORD_MOBLIN
; ENEMY_SWORD_SHROUDED_STALFOS
; ENEMY_SWORD_MASKED_MOBLIN
;
; Shares some code with ENEMY_SWORD_DARKNUT.
;
; Variables:
;   var30: Nonzero if enemyCollisionMode was changed to ignore sword damage (due to the
;          enemy's sword blocking it)
; ==============================================================================
enemyCode3d:
enemyCode49:
enemyCode4a:
	call ecom_checkHazards
	call @runState
	jp swordEnemy_updateEnemyCollisionMode

@runState:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret
@dead:
	pop hl
	jp enemyDie

@normalStatus:
	call ecom_checkScentSeedActive
	jr z,++
	ld e,Enemy.speed
	ld a,SPEED_a0
	ld (de),a
++
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw swordEnemy_state_uninitialized
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_switchHook
	.dw swordEnemy_state_scentSeed
	.dw ecom_blownByGaleSeedState
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_stub
	.dw swordEnemy_state8
	.dw swordEnemy_state9
	.dw swordEnemy_stateA


swordEnemy_state_uninitialized:
	ld b,PART_ENEMY_SWORD
	call ecom_spawnProjectile
	ret nz

	call ecom_setRandomCardinalAngle
	call ecom_updateAnimationFromAngle

	ld a,SPEED_80
	call ecom_setSpeedAndState8AndVisible

	ld l,Enemy.counter1
	inc (hl)

	; Enable scent seeds
	ld l,Enemy.var3f
	set 4,(hl)

	jp swordEnemy_setChaseCooldown


swordEnemy_state_switchHook:
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
	ld b,$09
	call ecom_fallToGroundAndSetState
	ld l,Enemy.counter1
	ld (hl),$10
	ret


swordEnemy_state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	ld h,d
	jp z,swordEnemy_gotoState8
	call ecom_updateAngleToScentSeed
	call ecom_updateAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemy
	call enemyAnimate
	jr swordEnemy_animate


swordEnemy_state_stub:
	ret


; Moving slowly in cardinal directions until Link get close.
swordEnemy_state8:
	call swordEnemy_checkLinkIsClose
	jp c,swordEnemy_beginChasingLink

	call ecom_decCounter1
	jp z,swordEnemy_chooseRandomAngleAndCounter1

	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,swordEnemy_animate

	; Hit a wall
	call ecom_bounceOffWallsAndHoles
	jp nz,ecom_updateAnimationFromAngle

swordEnemy_animate:
	jp enemyAnimate


; Started chasing Link (don't adjust angle until next state).
swordEnemy_state9:
	call ecom_decCounter1
	ret nz
	ld (hl),$60
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.speed
	ld (hl),SPEED_a0
	ret


; Chasing Link for [counter1] frames (adjusts angle appropriately).
swordEnemy_stateA:
	call ecom_decCounter1
	jp z,swordEnemy_gotoState8

	ld a,(hl)
	and $03
	jr nz,++
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
	call ecom_updateAnimationFromAngle
++
	call ecom_applyVelocityForSideviewEnemyNoHoles

	; Animate at double speed
	call enemyAnimate
	jr swordEnemy_animate


;;
; Reverts to state 8; wandering around in cardinal directions
swordEnemy_gotoState8:
	ld l,e
	ld (hl),$08 ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_80
	ld l,Enemy.angle
	ld a,(hl)
	add $04
	and $18
	ld (hl),a

	call ecom_updateAnimationFromAngle
	call swordEnemy_setChaseCooldown
	jr swordEnemy_animate
