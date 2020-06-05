enemyCode1c:
	call _ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,_ecom_updateKnockbackAndCheckHazards

	ld e,Enemy.state
	ld a,(de)
	cp $0a
	ret c
	ld e,Enemy.var2a
	ld a,(de)
	cp $80
	ret nz
	jp enemyDelete

@normalStatus:
	call _ecom_getSubidAndCpStateTo08
	jr c,@commonState
	bit 0,b
	jp z,_ironMask_subid00
	jp _ironMask_subid01

@commonState:
	rst_jumpTable
	.dw _ironMask_state_uninitialized
	.dw _ironMask_state_stub
	.dw _ironMask_state_stub
	.dw _ironMask_state_switchHook
	.dw _ironMask_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _ironMask_state_stub
	.dw _ironMask_state_stub


_ironMask_state_uninitialized:
	ld a,SPEED_80
	call _ecom_setSpeedAndState8AndVisible

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


_ironMask_state_switchHook:
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

	ld b,ENEMYID_IRON_MASK
	call _ecom_spawnUncountedEnemyWithSubid01
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
	jp _ecom_incState2

@substate1:
@substate2:
	ret

@substate3:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jp nz,_ecom_fallToGroundAndSetState8

	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_IRON_MASK
	jp nz,_ecom_fallToGroundAndSetState8

	ld b,$0a
	call _ecom_fallToGroundAndSetState

	ld l,Enemy.collisionType
	res 7,(hl)
	ret


_ironMask_state_stub:
	ret


; Iron mask with mask on
_ironMask_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


; Standing in place
@state8:
	call _ironMask_magnetGloveCheck
	call _ecom_decCounter1
	jp nz,_ironMask_updateCollisionsFromLinkRelativeAngle
	ld l,Enemy.state
	inc (hl) ; [state]
	call _ironMask_chooseRandomAngleAndCounter1

; Moving in some direction for [counter1] frames
@state9:
	call _ironMask_magnetGloveCheck
	call _ecom_decCounter1
	jr nz,++
	ld l,Enemy.state
	dec (hl) ; [state]
	call _ironMask_chooseAmountOfTimeToStand
++
	call _ecom_applyVelocityForSideviewEnemyNoHoles
	call _ironMask_updateCollisionsFromLinkRelativeAngle
	jp enemyAnimate

; This enemy has turned into the mask that was removed; will delete self after [counter1]
; frames.
@stateA:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),$50
	ld l,Enemy.enemyCollisionMode
	ld (hl),$05
	ld a,$05
	call enemySetAnimation
	call objectSetVisible82

@stateB:
	ld a,(wMagnetGloveState)
	or a
	jr z,+
	call _ecom_updateAngleTowardTarget
	jp objectApplySpeed
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),$1e

@stateC:
	call _ecom_decCounter1
	jp nz,_ecom_flickerVisibility
	jp enemyDelete


; Iron mask without mask on
_ironMask_subid01:
	call _ecom_decCounter1
	call z,_ironMask_chooseRandomAngleAndCounter1
	call _ecom_applyVelocityForSideviewEnemyNoHoles
	jp enemyAnimate


;;
; Modifies this object's enemyCollisionMode based on if Link is directly behind the iron
; mask or not.
_ironMask_updateCollisionsFromLinkRelativeAngle:
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
_ironMask_chooseRandomAngleAndCounter1:
	ld bc,$0703
	call _ecom_randomBitwiseAndBCE
	ld a,b
	ld hl,@counter1Vals
	rst_addAToHl

	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a

	ld e,Enemy.subid
	ld a,(de)
	or a
	jp nz,_ecom_setRandomCardinalAngle

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
	jp z,_ecom_updateCardinalAngleTowardTarget
	jp _ecom_setRandomCardinalAngle

@counter1Vals:
	.db 25 30 35 40 45 50 55 60

;;
_ironMask_chooseAmountOfTimeToStand:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret

@counter1Vals:
	.db 15 30 45 60

_ironMask_magnetGloveCheck:
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
	ld (hl),$50
	ld a,$04
	call enemySetAnimation
	ld b,ENEMYID_IRON_MASK
	call _ecom_spawnUncountedEnemyWithSubid01
	ret nz
	jp objectCopyPosition
