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

	ld e,Enemy.subid
	ld a,(de)
	or a
	ret z
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret nz
	jp enemyDelete

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,+

@commonState:
	rst_jumpTable
	.dw ironMask_state_uninitialized
	.dw ironMask_state_stub
	.dw ironMask_state_stub
	.dw ironMask_state_stub
	.dw ironMask_state_stub
	.dw ecom_blownByGaleSeedState
	.dw ironMask_state_stub
	.dw ironMask_state_stub

+
	ld a,b
	rst_jumpTable
	.dw ironMask_subid00
	.dw ironMask_subid01

ironMask_state_uninitialized:
	bit 0,b
	jp nz,ecom_setSpeedAndState8
	ld a,$14
	call ecom_setSpeedAndState8AndVisible
	ld l,Enemy.counter1
	inc (hl)
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
	call ironMask_magnetGloveCheck
	call ecom_decCounter1
	jp nz,ironMask_updateCollisionsFromLinkRelativeAngle
	ld l,Enemy.state
	inc (hl)
	call ironMask_chooseRandomAngleAndCounter1

; Moving in some direction for [counter1] frames
@state9:
	call ironMask_magnetGloveCheck
	call ecom_decCounter1
	jr nz,+
	ld l,Enemy.state
	dec (hl)
	call ironMask_chooseAmountOfTimeToStand
+
	call ecom_applyVelocityForSideviewEnemyNoHoles
	call ironMask_updateCollisionsFromLinkRelativeAngle
	jp enemyAnimate

; Maskless
@stateA:
	call ecom_decCounter1
	call z,ironMask_chooseRandomAngleAndCounter1
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp enemyAnimate


; Detached "mask"
ironMask_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA

@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_200
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_IRON_MASK_DETACHED
	ld a,$05
	call enemySetAnimation
	call objectSetVisible82

@state9:
	ld a,(wMagnetGloveState)
	or a
	jr z,+
	call ecom_updateAngleTowardTarget
	jp objectApplySpeed
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),30

@stateA:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	jp enemyDelete


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

	ld e,Enemy.state
	ld a,(de)
	cp $0a
	jp z,ecom_setRandomCardinalAngle

	; 1 in 4 chance of turning directly toward Link, otherwise just choose a random angle
	call @chooseAngle
	swap a
	rlca
	ld h,d
	ld l,Enemy.var31
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


ironMask_magnetGloveCheck:
	ld a,(wMagnetGloveState)
	or a
	jr z,+
	ld c,$40
	call objectCheckLinkWithinDistance
	jr nc,+
	rrca
	xor $02
	ld b,a
	ld a,(w1Link.direction)
	cp b
	jr z,++
+
	ld e,Enemy.var32
	ld a,$3c
	ld (de),a
	ret
++
	pop hl
	ld h,d
	ld l,Enemy.var32
	dec (hl)
	jr z,++
	ld a,(hl)
	and $03
	sub $01
	jr nc,+
	cpl
	inc a
+
	dec a
	bit 0,b
	jr z,+
	ld l,Enemy.xh
	add (hl)
	ld (hl),a
	ret
+
	ld l,Enemy.yh
	add (hl)
	ld (hl),a
	ret
++
	ld l,Enemy.state
	ld (hl),$0a
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_UNMASKED_IRON_MASK
	ld a,$04
	call enemySetAnimation
	ld b,ENEMY_IRON_MASK
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz
	jp objectCopyPosition
	jr z,+
	sub $03
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockback
	ret
+
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @enemyDelete
	.dw @ret
	.dw @ret
	.dw @ret
	.dw @ret
	.dw @ret
	.dw @ret
	.dw @ret

@enemyDelete:
	jp enemyDelete

@ret:
	ret

	; left over
	jp enemyDelete
