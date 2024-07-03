; ==============================================================================
; ENEMYID_SWORD_DARKNUT
; ==============================================================================
enemyCode48:
.ifdef ROM_AGES
	call ecom_checkHazards
.else
	call ecom_seasonsFunc_4446
.endif
	call @runState
	jp swordDarknut_updateEnemyCollisionMode

@runState:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	call nz,ecom_updateKnockbackAndCheckHazards
	jp swordDarknut_updateEnemyCollisionMode

@dead:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr nz,++
	ld hl,wKilledGoldenEnemies
	set 2,(hl)
++
	pop hl
	jp enemyDie

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw swordDarknut_state_uninitialized
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_switchHook
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_stub
	.dw swordEnemy_state_stub
	.dw swordDarknut_state8
	.dw swordDarknut_state9
	.dw swordDarknut_stateA


swordDarknut_state_uninitialized:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr nz,++
	ld a,(wKilledGoldenEnemies)
	bit 2,a
	jp nz,swordDarknut_delete
++
	jp swordEnemy_state_uninitialized


; Moving slowly in cardinal directions until Link get close.
; Identical to swordEnemy_state8.
swordDarknut_state8:
	call swordDarknut_checkLinkIsClose
	jr c,swordEnemy_beginChasingLink

	call ecom_decCounter1
	jr z,swordEnemy_chooseRandomAngleAndCounter1

	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,swordDarknut_animate

	; Hit a wall
	call ecom_bounceOffWallsAndHoles
	jp nz,ecom_updateAnimationFromAngle

swordDarknut_animate:
	jp enemyAnimate


; Started chasing Link (don't adjust angle until next state).
; Identical to swordEnemy_state9 except for the speed.
swordDarknut_state9:
	call ecom_decCounter1
	ret nz
	ld (hl),$60
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ret


; Chasing Link for [counter1] frames (adjusts angle appropriately).
; Identical to swordEnemy_stateA except for how quickly it turns toward Link.
swordDarknut_stateA:
	call ecom_decCounter1
	jp z,swordEnemy_gotoState8

	ld a,(hl)
	and $01
	jr nz,++
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
	call ecom_updateAnimationFromAngle
++
	call ecom_applyVelocityForSideviewEnemyNoHoles

	; Animate at double speed
	call enemyAnimate
	jr swordDarknut_animate

;;
swordEnemy_beginChasingLink:
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),$10
	call ecom_updateAngleTowardTarget
	jp ecom_updateAnimationFromAngle

;;
swordEnemy_chooseRandomAngleAndCounter1:
	ld bc,$3f07
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.counter1
	ld a,$50
	add b
	ld (de),a

	call @chooseAngle
	jp ecom_updateAnimationFromAngle

@chooseAngle:
	; 1 in 8 chance of moving toward Link
	ld a,c
	or a
	jp z,ecom_updateCardinalAngleTowardTarget
	jp ecom_setRandomCardinalAngle


;;
; @param[out]	cflag	c if Link is within 40 pixels of enemy in both directions (and
;			counter2, the timeout, has reached 0)
swordEnemy_checkLinkIsClose:
	call ecom_decCounter2
	ret nz

	; NOTE: Why does this use hFFB2, then hEnemyTargetX? It's mixing two position
	; variables.
	ld l,Enemy.yh
	ldh a,(<hFFB2)
	sub (hl)
	add $28
	cp $51
	ret nc
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $28
	cp $51
	ret

;;
; This is identical to the above function.
swordDarknut_checkLinkIsClose:
	call ecom_decCounter2
	ret nz

	; NOTE: Why does this use hFFB2, then hEnemyTargetX? It's mixing two position
	; variables.
	ld l,Enemy.yh
	ldh a,(<hFFB2)
	sub (hl)
	add $28
	cp $51
	ret nc
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $28
	cp $51
	ret


;;
; Sets counter2 to the number of frames to wait before chasing Link again. Higher subids
; have lower cooldowns.
swordEnemy_setChaseCooldown:
	ld e,Enemy.subid
	ld a,(de)
	ld bc,@counter2Vals
	call addAToBc
	ld e,Enemy.counter2
	ld a,(bc)
	ld (de),a
	ret

@counter2Vals:
	.db $14 $10 $0c


;;
; Updates enemyCollisionMode based on Link's angle relative to the enemy. In this way,
; Link's sword doesn't damage the enemy if positioned in such a way that their sword
; should block it.
swordEnemy_updateEnemyCollisionMode:
	ld b,$00
	ld e,Enemy.stunCounter
	ld a,(de)
	or a
	jr nz,++

	call swordEnemy_checkIgnoreCollision
	ld a,ENEMYCOLLISION_STALFOS_BLOCKED_WITH_SWORD
	ld b,$00
	jr nz,@setVars
++
	inc b
	ld e,Enemy.id
	ld a,(de)
	cp ENEMYID_SWORD_SHROUDED_STALFOS
	ld a,ENEMYCOLLISION_BURNABLE_ENEMY
	jr nz,@setVars
.ifdef ROM_AGES
	ld a,ENEMYCOLLISION_BURNABLE_ENEMY
.else
	ld a,ENEMYCOLLISION_BURNABLE_UNDEAD
.endif

@setVars:
	ld e,Enemy.enemyCollisionMode
	ld (de),a

	ld e,Enemy.var30
	ld a,b
	ld (de),a
	ret

;;
; Same as above, but with a different enemyCollisionMode for the darknut.
swordDarknut_updateEnemyCollisionMode:
	ld b,$00
	ld e,Enemy.stunCounter
	ld a,(de)
	or a
	jr nz,++

	call swordEnemy_checkIgnoreCollision
	ld a,ENEMYCOLLISION_DARKNUT_BLOCKED_WITH_SWORD
	ld b,$00
	jr nz,@setVars
++
	ld a,ENEMYCOLLISION_DARKNUT
	inc b

@setVars:
	ld e,Enemy.enemyCollisionMode
	ld (de),a

	ld e,Enemy.var30
	ld a,b
	ld (de),a
	ret

;;
; Check whether the angle between Link and the enemy is such that the collision should be
; ignored (due to the sword blocking it)
;
; Knockback is handled by PARTID_ENEMY_SWORD.
;
; @param[out]	zflag	z if sword hits should be ignored
swordEnemy_checkIgnoreCollision:
	ld e,Enemy.knockbackCounter
	ld a,(de)
	or a
	ret nz

	call objectGetAngleTowardEnemyTarget
	ld b,a
	ld e,Enemy.direction
	ld a,(de)
	add a
	ld hl,@angleBits
	rst_addDoubleIndex
	ld a,b
	jp checkFlag

@angleBits:
	.db $3f $00 $00 $00 ; DIR_UP
	.db $00 $3f $00 $00 ; DIR_RIGHT
	.db $00 $00 $3f $00 ; DIR_DOWN
	.db $00 $00 $f8 $01 ; DIR_LEFT


;;
swordDarknut_delete:
	call decNumEnemies
	jp enemyDelete