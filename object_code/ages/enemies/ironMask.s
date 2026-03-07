; ==================================================================================================
; ENEMY_IRON_MASK
; ==================================================================================================
enemyCode1c:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr c,@commonState
	bit 0,b
	jp z,ironMask_subid00
	jp ironMask_subid01

@commonState:
	rst_jumpTable
	.dw ironMask_state_uninitialized
	.dw ironMask_state_stub
	.dw ironMask_state_stub
	.dw ironMask_state_switchHook
	.dw ironMask_state_stub
	.dw ecom_blownByGaleSeedState
	.dw ironMask_state_stub
	.dw ironMask_state_stub


ironMask_state_uninitialized:
	ld a,SPEED_80
	call ecom_setSpeedAndState8AndVisible

	ld l,Enemy.counter1
	inc (hl)

	bit 0,b
	ret z

	; Subid 1 only
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_UNMASKED_IRON_MASK
	ld l,Enemy.knockbackCounter
	ld (hl),$10
	ld l,Enemy.invincibilityCounter
	ld (hl),$e8
	ld a,$04
	jp enemySetAnimation


ironMask_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

; Using switch hook may cause this enemy's mask to be removed.
@substate0:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr nz,@dontRemoveMask

	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_UNMASKED_IRON_MASK
	jr z,@dontRemoveMask

	ld b,ENEMY_IRON_MASK
	call ecom_spawnUncountedEnemyWithSubid01
	jr nz,@dontRemoveMask

	; Transfer "index" from enabled byte to new enemy
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	ld l,Enemy.knockbackAngle
	ld e,l
	ld a,(de)
	ld (hl),a
	call objectCopyPosition

	ld a,$05
	call enemySetAnimation

	ld a,SND_BOMB_LAND
	call playSound

	ld a,60
	jr ++

@dontRemoveMask:
	ld a,16
++
	ld e,Enemy.counter1
	ld (de),a
	jp ecom_incSubstate

@substate1:
@substate2:
	ret

@substate3:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jp nz,ecom_fallToGroundAndSetState8

	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_IRON_MASK
	jp nz,ecom_fallToGroundAndSetState8

	ld b,$0a
	call ecom_fallToGroundAndSetState

	ld l,Enemy.collisionType
	res 7,(hl)
	ret


ironMask_state_stub:
	ret


; Iron mask with mask on
ironMask_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA


; Standing in place
@state8:
	call ecom_decCounter1
	jp nz,ironMask_updateCollisionsFromLinkRelativeAngle
	ld l,e
	inc (hl) ; [state]
	call ironMask_chooseRandomAngleAndCounter1

; Moving in some direction for [counter1] frames
@state9:
	call ecom_decCounter1
	jr nz,++
	ld l,e
	dec (hl) ; [state]
	call ironMask_chooseAmountOfTimeToStand
++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	call ironMask_updateCollisionsFromLinkRelativeAngle
	jp enemyAnimate

; This enemy has turned into the mask that was removed; will delete self after [counter1]
; frames.
@stateA:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	jp enemyDelete


; Iron mask without mask on
ironMask_subid01:
	call ecom_decCounter1
	call z,ironMask_chooseRandomAngleAndCounter1
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp enemyAnimate


;;
; Modifies this object's enemyCollisionMode based on if Link is directly behind the iron
; mask or not.
ironMask_updateCollisionsFromLinkRelativeAngle:
	call objectGetAngleTowardEnemyTarget
	ld h,d
	ld l,Enemy.angle
	sub (hl)
	and $1f
	sub $0c
	cp $09
	ld l,Enemy.enemyCollisionMode
	jr c,++
	ld (hl),ENEMYCOLLISION_IRON_MASK
	ret
++
	ld (hl),ENEMYCOLLISION_UNMASKED_IRON_MASK
	ret


;;
ironMask_chooseRandomAngleAndCounter1:
	ld bc,$0703
	call ecom_randomBitwiseAndBCE
	ld a,b
	ld hl,@counter1Vals
	rst_addAToHl

	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a

	ld e,Enemy.subid
	ld a,(de)
	or a
	jp nz,ecom_setRandomCardinalAngle

	; Subid 0 only: 1 in 4 chance of turning directly toward Link, otherwise just
	; choose a random angle
	call @chooseAngle
	swap a
	rlca
	ld h,d
	ld l,Enemy.direction
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

@chooseAngle:
	ld a,c
	or a
	jp z,ecom_updateCardinalAngleTowardTarget
	jp ecom_setRandomCardinalAngle

@counter1Vals:
	.db 25, 30, 35, 40, 45, 50, 55, 60

;;
ironMask_chooseAmountOfTimeToStand:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret

@counter1Vals:
	.db 15, 30, 45, 60
