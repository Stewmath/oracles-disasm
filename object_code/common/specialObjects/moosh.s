specialObjectCode_moosh:
	call companionRetIfInactive
	call companionFunc_47d8
	call @runState
	jp companionCheckEnableTerrainEffects

@runState:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw mooshState0
	.dw mooshState1
	.dw mooshState2
	.dw mooshState3
	.dw mooshState4
	.dw mooshState5
	.dw mooshState6
	.dw mooshState7
	.dw mooshState8
	.dw mooshState9
	.dw mooshStateA
	.dw mooshStateB
	.dw mooshStateC

;;
; State 0: initialization
mooshState0:
	call companionCheckCanSpawn
	ld a,$06
	call objectSetCollideRadius

	ld a,DIR_DOWN
	ld l,SpecialObject.direction
	ldi (hl),a
	ldi (hl),a ; [angle] = $02

	ld hl,wMooshState
	ld a,$80
	and (hl)
	jr nz,@setAnimation

.ifdef ROM_AGES
	; Check for the screen with the bridge near the forest?
	ld a,(wActiveRoom)
	cp $54
	jr z,@gotoCutsceneStateA

	ld a,$20
	and (hl)
	jr z,@gotoCutsceneStateA
	ld a,$40
	and (hl)
	jr nz,@gotoCutsceneStateA

	; Check for the room where Moosh leaves after obtaining cheval's rope
	ld a,TREASURE_CHEVAL_ROPE
	call checkTreasureObtained
	jr nc,@setAnimation
	ld a,(wActiveRoom)
	cp $6b
	jr nz,@setAnimation
.else
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECT_MOOSH
	jr nz,@gotoCutsceneStateA

	ld a,$20
	and (hl)
	jr z,+

	ld a,(wActiveRoom)
	; mt cucco
	cp $2f
	jr z,@gotoCutsceneStateA
	jr @setAnimation
+
	ld a,(wActiveRoom)
	; spool swamp
	cp $90
	jr nz,@setAnimation
.endif

@gotoCutsceneStateA:
	ld e,SpecialObject.state
	ld a,$0a
	ld (de),a
	jp mooshStateA

@setAnimation:
	ld c,$01
	call companionSetAnimation
	jp objectSetVisiblec1

;;
; State 1: waiting for Link to mount
mooshState1:
	call companionSetPriorityRelativeToLink
	call specialObjectAnimate

	ld c,$09
	call objectCheckLinkWithinDistance
	jp c,companionTryToMount

;;
mooshCheckHazards:
	call companionCheckHazards
	ret nc
	jr mooshSetVar37ForHazard

;;
; State 3: Link is currently jumping up to mount Moosh
mooshState3:
	call companionCheckMountingComplete
	ret nz
	call companionFinalizeMounting
	ld c,$13
	jp companionSetAnimation

;;
; State 4: Moosh falling into a hazard (hole/water)
mooshState4:
	ld h,d
	ld l,SpecialObject.collisionType
	set 7,(hl)

	; Check if the hazard is water
	ld l,SpecialObject.var37
	ld a,(hl)
	cp $0d
	jr z,++

	; No, it's a hole
	ld a,$0e
	ld (hl),a
	call companionDragToCenterOfHole
	ret nz
++
	call companionDecCounter1
	jr nz,@animate

	; Set falling/drowning animation, play falling sound if appropriate
	dec (hl)
	ld l,SpecialObject.var37
	ld a,(hl)
	call specialObjectSetAnimation

	ld e,SpecialObject.var37
	ld a,(de)
	cp $0d ; Is this water?
	jr z,@animate

	ld a,SND_LINK_FALL
	jp playSound

@animate:
	call companionAnimateDrowningOrFallingThenRespawn
	ret nc
	ld c,$13
	ld a,(wLinkObjectIndex)
	rrca
	jr c,+
	ld c,$01
+
	jp companionUpdateDirectionAndSetAnimation

;;
mooshTryToBreakTileFromMovingAndCheckHazards:
	call companionTryToBreakTileFromMoving
	call companionCheckHazards
	ld c,$13
	jp nc,companionUpdateDirectionAndAnimate

;;
mooshSetVar37ForHazard:
	dec a
	ld c,$0d
	jr z,+
	ld c,$0e
+
	ld e,SpecialObject.var37
	ld a,c
	ld (de),a
	ld e,SpecialObject.counter1
	xor a
	ld (de),a
	ret

;;
; State 5: Link riding Moosh.
mooshState5:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	call companionCheckHazards
	jr c,mooshSetVar37ForHazard

	ld a,(wForceCompanionDismount)
	or a
	jr nz,++
	ld a,(wGameKeysJustPressed)
	bit BTN_BIT_A,a
	jr nz,mooshPressedAButton
	bit BTN_BIT_B,a
++
	jp nz,companionGotoDismountState

	; Return if not attempting to move
	ld a,(wLinkAngle)
	bit 7,a
	ret nz

	; Update angle, and animation if the angle changed
	ld hl,w1Companion.angle
	cp (hl)
	ld (hl),a
	ld c,$13
	jp nz,companionUpdateDirectionAndAnimate

	call companionCheckHopDownCliff
	ret z

	ld e,SpecialObject.speed
	ld a,SPEED_100
	ld (de),a
	call companionUpdateMovement

	jr mooshTryToBreakTileFromMovingAndCheckHazards

;;
mooshLandOnGroundAndGotoState5:
	xor a
	ld (wLinkInAir),a
	ld c,$13
	jp companionSetAnimationAndGotoState5

;;
mooshPressedAButton:
	ld a,$08
	ld e,SpecialObject.state
	ld (de),a
	inc e
	xor a
	ld (de),a
	ld a,SND_JUMP
	call playSound

;;
mooshState2:
mooshState9:
mooshStateB:
	ret

;;
; State 8: floating in air, possibly performing buttstomp
mooshState8:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw mooshState8Substate0
	.dw mooshState8Substate1
	.dw mooshState8Substate2
	.dw mooshState8Substate3
	.dw mooshState8Substate4
	.dw mooshState8Substate5

;;
; Substate 0: just pressed A button
mooshState8Substate0:
	ld a,$01
	ld (de),a ; [substate] = 1

	ld bc,-$140
	call objectSetSpeedZ
	ld l,SpecialObject.speed
	ld (hl),SPEED_100

	ld l,SpecialObject.var39
	ld a,$04
	ldi (hl),a
	xor a
	ldi (hl),a ; [var3a] = 0
	ldi (hl),a ; [var3b] = 0

	ld c,$09
	jp companionSetAnimation

;;
; Substate 1: floating in air
mooshState8Substate1:
	; Check if over water
	call objectCheckIsOverHazard
	cp $01
	jr nz,@notOverWater

; He's over water; go to substate 5.

	ld bc,$0000
	call objectSetSpeedZ

	ld l,SpecialObject.substate
	ld (hl),$05

	ld b,INTERAC_EXCLAMATION_MARK
	call objectCreateInteractionWithSubid00

	; Subtract new interaction's zh by $20 (should be above moosh)
	dec l
	ld a,(hl)
	sub $20
	ld (hl),a

	ld l,Interaction.counter1
	ld e,SpecialObject.counter1
	ld a,$3c
	ld (hl),a ; [Interaction.counter1] = $3c
	ld (de),a ; [Moosh.counter1] = $3c
	ret

@notOverWater:
	ld a,(wLinkAngle)
	bit 7,a
	jr nz,+
	ld hl,w1Companion.angle
	cp (hl)
	ld (hl),a
	call companionUpdateMovement
+
	ld e,SpecialObject.speedZ+1
	ld a,(de)
	rlca
	jr c,@movingUp

; Moosh is moving down (speedZ is positive or 0).

	; Increment var3b once for every frame A is held (or set to 0 if A is released).
	ld e,SpecialObject.var3b
	ld a,(wGameKeysPressed)
	and BTN_A
	jr z,+
	ld a,(de)
	inc a
+
	ld (de),a

	; Start charging stomp after A is held for 10 frames
	cp $0a
	jr nc,@gotoSubstate2

	; If pressed A, flutter in the air.
	ld a,(wGameKeysJustPressed)
	bit BTN_BIT_A,a
	jr z,@label_05_444

	; Don't allow him to flutter more than 16 times.
	ld e,SpecialObject.var3a
	ld a,(de)
	cp $10
	jr z,@label_05_444

	; [var3a] += 1 (counter for number of times he's fluttered)
	inc a
	ld (de),a

	; [var39] += 8 (ignore gravity for 8 more frames)
	dec e
	ld a,(de)
	add $08
	ld (de),a

	ld e,SpecialObject.animCounter
	ld a,$01
	ld (de),a
	call specialObjectAnimate
	ld a,SND_JUMP
	call playSound

@label_05_444:
	ld e,SpecialObject.var39
	ld a,(de)
	or a
	jr z,@updateMovement

	; [var39] -= 1
	dec a
	ld (de),a

	ld e,SpecialObject.animCounter
	ld a,$0f
	ld (de),a
	ld c,$09
	jp companionUpdateDirectionAndAnimate

@movingUp:
	ld c,$09
	call companionUpdateDirectionAndAnimate

@updateMovement:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	call companionTryToBreakTileFromMoving
	call mooshLandOnGroundAndGotoState5
	jp mooshTryToBreakTileFromMovingAndCheckHazards

@gotoSubstate2:
	jp itemIncSubstate

;;
; Substate 2: charging buttstomp
mooshState8Substate2:
	call specialObjectAnimate

	ld a,(wGameKeysPressed)
	bit BTN_BIT_A,a
	jr z,@gotoNextSubstate

	ld e,SpecialObject.var3b
	ld a,(de)
	cp 40
	jr c,+
	ld c,$02
	call companionFlashFromChargingAnimation
+
	ld e,SpecialObject.var3b
	ld a,(de)
	inc a
	ld (de),a

	; Check if it's finished charging
	cp 40
	ret c
	ld a,SND_CHARGE_SWORD
	jp z,playSound

	; Reset bit 7 on w1Link.collisionType and w1Companion.collisionType (disable
	; collisions?)
	ld hl,w1Link.collisionType
	res 7,(hl)
	inc h
	res 7,(hl)

	; Force the buttstomp to release after 120 frames of charging
	ld e,SpecialObject.var3b
	ld a,(de)
	cp 120
	ret nz

@gotoNextSubstate:
	ld hl,w1Link.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a ; [w1Link.oamFlags] = [w1Link.oamFlagsBackup]

	call itemIncSubstate
	ld c,$17

	; Set buttstomp animation if he's charged up enough
	ld e,SpecialObject.var3b
	ld a,(de)
	cp 40
	ret c
	jp companionSetAnimation

;;
; Substate 3: falling to ground with buttstomp attack (or cancelling buttstomp)
mooshState8Substate3:
	ld c,$80
	call objectUpdateSpeedZ_paramC
	ret nz

; Reached the ground

	ld e,SpecialObject.var3b
	ld a,(de)
	cp 40
	jr nc,+

	; Buttstomp not charged; just land on the ground
	call mooshLandOnGroundAndGotoState5
	jp mooshTryToBreakTileFromMovingAndCheckHazards
+
	; Buttstomp charged; unleash the attack
	call companionCheckHazards
	jp c,mooshSetVar37ForHazard

	call itemIncSubstate

	ld a,$0f
	ld (wScreenShakeCounterY),a

	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SND_SCENT_SEED
	call playSound

	ld a,$05
	ld hl,wCompanionTutorialTextShown
	call setFlag

	ldbc ITEM_28, $00
	jp companionCreateWeaponItem

;;
; Substate 4: sitting on the ground briefly after buttstomp attack
mooshState8Substate4:
	call specialObjectAnimate
	ld e,SpecialObject.animParameter
	ld a,(de)
	rlca
	ret nc

	; Set bit 7 on w1Link.collisionType and w1Companion.collisionType (enable
	; collisions?)
	ld hl,w1Link.collisionType
	set 7,(hl)
	inc h
	set 7,(hl)

	jp mooshLandOnGroundAndGotoState5

;;
; Substate 5: Moosh is over water, in the process of falling down.
mooshState8Substate5:
	call companionDecCounter1IfNonzero
	jr z,+
	jp specialObjectAnimate
+
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	call mooshLandOnGroundAndGotoState5
	jp mooshTryToBreakTileFromMovingAndCheckHazards

;;
; State 6: Link has dismounted; he can't remount until he moves a certain distance away,
; then comes back.
mooshState6:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01
	ld (de),a
	call companionDismountAndSavePosition
	ld c,$01
	jp companionSetAnimation

@substate1:
	ld a,(wLinkInAir)
	or a
	ret nz
	jp itemIncSubstate

@substate2:
	ld c,$09
	call objectCheckLinkWithinDistance
	jp c,mooshCheckHazards

	ld e,SpecialObject.substate
	xor a
	ld (de),a
	dec e
	ld a,$01
	ld (de),a ; [state] = $01 (waiting for Link to mount)
	ret

;;
; State 7: jumping down a cliff
mooshState7:
	call companionDecCounter1ToJumpDownCliff
	jr nc,+
	ret nz
	ld c,$09
	jp companionSetAnimation
+
	call companionCalculateAdjacentWallsBitset
	call specialObjectCheckMovingAwayFromWall
	ld e,$07
	jr z,+
	ld (de),a
	ret
+
	ld a,(de)
	or a
	ret z
	jp mooshLandOnGroundAndGotoState5

;;
; State C: Moosh entering from a flute call
mooshStateC:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	call companionInitializeOnEnteringScreen
	ld (hl),$3c ; [counter2] = $3c
	ld a,SND_MOOSH
	call playSound
	ld c,$0f
	jp companionSetAnimation

@substate1:
	call specialObjectAnimate

	ld e,SpecialObject.speed
	ld a,SPEED_c0
	ld (de),a

	call companionUpdateMovement
	ld hl,@mooshDirectionOffsets
	call companionRetIfNotFinishedWalkingIn
	ld e,SpecialObject.var03
	xor a
	ld (de),a
	jp mooshState0

@mooshDirectionOffsets:
	.db $f8 $00 ; DIR_UP
	.db $00 $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT


.ifdef ROM_AGES
;;
; State A: cutscene stuff
mooshStateA:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw @mooshStateASubstate0
	.dw mooshStateASubstate1
	.dw @mooshStateASubstate2
	.dw mooshStateASubstate3
	.dw mooshStateASubstate4
	.dw mooshStateASubstate5
	.dw mooshStateASubstate6

;;
@mooshStateASubstate0:
	ld a,$01 ; [var03] = $01
	ld (de),a

	ld hl,wMooshState
	ld a,$20
	and (hl)
	jr z,@label_05_454

	ld a,$40
	and (hl)
	jr z,@label_05_456

;;
@mooshStateASubstate2:
	ld a,$01
	ld (de),a ; [var03] = $01

	ld e,SpecialObject.var3d
	call objectAddToAButtonSensitiveObjectList

@label_05_454:
	ld a,GLOBALFLAG_SAVED_COMPANION_FROM_FOREST
	call checkGlobalFlag
	ld a,$00
	jr z,+
	ld a,$03
+
	ld e,SpecialObject.var3f
	ld (de),a
	call specialObjectSetAnimation
	jp objectSetVisiblec3

@label_05_456:
	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a

	ld a,$04
	ld (de),a ; [var03] = $04

	ld a,$01
	call specialObjectSetAnimation
	jp objectSetVisiblec3

;;
mooshStateASubstate1:
	ld e,SpecialObject.var3d
	ld a,(de)
	or a
	jr z,+
	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
+
	call companionSetAnimationToVar3f
	call mooshUpdateAsNpc
	ld a,(wMooshState)
	and $80
	ret z
	jr +

;;
mooshStateASubstate3:
	call companionSetAnimationToVar3f
	call mooshUpdateAsNpc
	ld a,(wMooshState)
	and $20
	ret z
	ld a,$ff
	ld (wStatusBarNeedsRefresh),a

+
	ld e,SpecialObject.var3d
	xor a
	ld (de),a
	call objectRemoveFromAButtonSensitiveObjectList

	ld c,$01
	call companionSetAnimation
	jp companionForceMount

;;
mooshStateASubstate4:
	call mooshIncVar03
	ld bc,TX_2208
	jp showText

;;
mooshStateASubstate5:
	call retIfTextIsActive

	ld bc,-$140
	call objectSetSpeedZ
	ld l,SpecialObject.angle
	ld (hl),$10
	ld l,SpecialObject.speed
	ld (hl),SPEED_100

	ld a,$0b
	call specialObjectSetAnimation

	jp mooshIncVar03

;;
mooshStateASubstate6:
	call specialObjectAnimate

	ld e,SpecialObject.speedZ+1
	ld a,(de)
	or a
	ld c,$10
	jp nz,objectUpdateSpeedZ_paramC

	call objectApplySpeed
	ld e,SpecialObject.yh
	ld a,(de)
	cp $f0
	ret c

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld (wRememberedCompanionId),a

	ld hl,wMooshState
	set 6,(hl)
	jp itemDelete
.else
mooshStateA:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw mooshStateASubstate0
	.dw mooshStateASubstate1
	.dw mooshStateASubstate2
	.dw mooshStateASubstate3
	.dw mooshStateASubstate4
	.dw mooshStateASubstate5
	.dw mooshStateASubstate6
	.dw mooshStateASubstate7
	.dw mooshStateASubstate8
	.dw mooshStateASubstate9
	.dw mooshStateASubstateA
	.dw mooshStateASubstateB
	.dw mooshStateASubstateC

mooshStateASubstate0:
	ld a,$01
	ld (de),a

	ld a,(wAnimalCompanion)
	cp SPECIALOBJECT_MOOSH
	jr nz,+
	ld a,(wMooshState)
	and $20
	jr nz,+
	ld a,$02
	ld (de),a
	ld c,$01
	call companionSetAnimation
	jr ++
+
	ld a,$00
	ld e,SpecialObject.var3f
	ld (de),a
	call specialObjectSetAnimation
++
	call objectSetVisiblec3
	ld e,SpecialObject.var3d
	jp objectAddToAButtonSensitiveObjectList

mooshStateASubstate1:
mooshStateASubstate7:
	call companionSetAnimationToVar3f
	call mooshUpdateAsNpc
	ld a,(wMooshState)
	and $80
	jr z,+
	jr ++
+
	ld e,SpecialObject.var3d
	ld a,(de)
	or a
	ret z
	ld a,$81
	ld (wDisabledObjects),a
	ret

mooshStateASubstate2:
	ld e,SpecialObject.invincibilityCounter
	ld a,(de)
	or a
	ret z
	dec a
	ld (de),a
	ld h,d
	jp updateLinkInvincibilityCounter@func_4244

mooshStateASubstate3:
	call companionSetAnimationToVar3f
	call specialObjectAnimate
	call companionDecCounter1IfNonzero
	ret nz
	ld c,$10
	jp objectUpdateSpeedZ_paramC

mooshStateASubstate4:
	call companionSetAnimationToVar3f
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	ld e,SpecialObject.var3e
	ld a,(de)
	or $40
	ld (de),a
	jp specialObjectAnimate

mooshStateASubstate5:
mooshStateASubstate6:
	call companionSetAnimationToVar3f
	call mooshUpdateAsNpc
	ld a,(wMooshState)
	and $20
	ret z
	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
++
	ld e,SpecialObject.var3d
	xor a
	ld (de),a
	call objectRemoveFromAButtonSensitiveObjectList
	ld c,$01
	call companionSetAnimation
	jp companionForceMount

mooshStateASubstate8:
	call companionSetAnimationToVar3f
	ld e,SpecialObject.var3e
	xor a
	ld (de),a
	ld c,$10
	jp objectUpdateSpeedZ_paramC

mooshFunc_05_7aff:
	ld b,$40
	ld c,$70
	call objectGetRelativeAngle
	and $1c
	ld e,SpecialObject.angle
	ld (de),a
	ret

mooshStateASubstate9:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	call specialObjectAnimate
	call companionUpdateMovement
	ld e,SpecialObject.xh
	ld a,(de)
	cp $38
	jr c,mooshFunc_05_7aff
	ld a,$01
	ld e,SpecialObject.var3e
	ld (de),a
	jp mooshIncVar03

mooshStateASubstateA:
	call companionSetAnimationToVar3f
	ld e,SpecialObject.var3e
	ld a,(de)
	and $02
	ret z
	ld bc,TX_220f
	call showText
	jp mooshIncVar03

mooshStateASubstateB:
	call retIfTextIsActive
	call companionDismount
	ld a,$18
	ld (w1Link.angle),a
	ld (wLinkAngle),a
	ld a,$32
	ld (w1Link.speed),a
	ld bc,-$140
	call objectSetSpeedZ
	ld l,SpecialObject.angle
	ld (hl),$18
	ld l,SpecialObject.counter1
	ld (hl),$1e
	ld c,$0c
	call companionSetAnimation
	jp mooshIncVar03

mooshStateASubstateC:
	call specialObjectAnimate
	ld e,$15
	ld a,(de)
	or a
	ld c,$10
	call nz,objectUpdateSpeedZ_paramC
	ld a,(wLinkInAir)
	or a
	ret nz
	call setLinkForceStateToState08
	ld hl,w1Link.xh
	ld e,SpecialObject.xh
	ld a,(de)
	bit 7,a
	jr nz,+
	cp (hl)
	ld a,$01
	jr nc,++
+
	ld a,DIR_LEFT
++
	ld l,SpecialObject.direction
	ld (hl),a
	call companionDecCounter1IfNonzero
	ret nz
	call companionUpdateMovement
	call objectCheckWithinScreenBoundary
	ret c
	xor a
	ld (wRememberedCompanionId),a
	ld (wMenuDisabled),a
	jp itemDelete
.endif

;;
; Prevents Link from passing Moosh, calls animate.
mooshUpdateAsNpc:
	call companionPreventLinkFromPassing_noExtraChecks
	call specialObjectAnimate
	jp companionSetPriorityRelativeToLink

;;
mooshIncVar03:
	ld e,SpecialObject.var03
	ld a,(de)
	inc a
	ld (de),a
	ret
