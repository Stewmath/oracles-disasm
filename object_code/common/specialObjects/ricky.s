specialObjectCode_ricky:
	call companionRetIfInactive
	call companionFunc_47d8
	call @runState
	jp companionCheckEnableTerrainEffects

@runState:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw rickyState0
	.dw rickyState1
	.dw rickyState2
	.dw rickyState3
	.dw rickyState4
	.dw rickyState5
	.dw rickyState6
	.dw rickyState7
	.dw rickyState8
	.dw rickyState9
	.dw rickyStateA
	.dw rickyStateB
	.dw rickyStateC

;;
; State 0: initialization
rickyState0:
rickyStateB:
	call companionCheckCanSpawn ; This may return

	ld a,$06
	call objectSetCollideRadius

	ld a,DIR_DOWN
	ld l,SpecialObject.direction
	ldi (hl),a
	ld (hl),a ; [angle] = $02

	ld l,SpecialObject.var39
	ld (hl),$10
	ld a,(wRickyState)

.ifdef ROM_AGES
	bit 7,a
	jr nz,@setAnimation17

	ld c,$17
	bit 6,a
	jr nz,@canTalkToRicky

	and $20
	jr nz,@setAnimation17

	ld c,$00
.else
	and $80
	jr nz,@setAnimation17
.endif

@canTalkToRicky:
	; Ricky not ridable yet, can press A to talk to him
	ld l,SpecialObject.state
	ld (hl),$0a
	ld e,SpecialObject.var3d
	call objectAddToAButtonSensitiveObjectList
.ifdef ROM_AGES
	ld a,c
.else
	ld a,$00
.endif
	jr @setAnimation

@setAnimation17:
	ld a,$17

@setAnimation:
	call specialObjectSetAnimation
	jp objectSetVisiblec1

;;
; State 1: waiting for Link to mount
rickyState1:
	call specialObjectAnimate
	call companionSetPriorityRelativeToLink

	ld c,$09
	call objectCheckLinkWithinDistance
	jr nc,@didntMount

	call companionTryToMount
	ret z

@didntMount:
	; Make Ricky hop every once in a while
	ld e,SpecialObject.animParameter
	ld a,(de)
	and $c0
	jr z,rickyCheckHazards
	rlca
	ld c,$40
	jp nc,objectUpdateSpeedZ_paramC
	ld bc,$ff00
	call objectSetSpeedZ

;;
rickyCheckHazards:
	call companionCheckHazards
	jp c,rickyFunc_70cc

;;
rickyState9:
	ret

;;
; State 2: Jumping up a cliff
rickyState2:
	call companionDecCounter1
	jr z,++
	dec (hl)
	ret nz
	ld a,SND_RICKY
	call playSound
++
	ld c,$40
	call objectUpdateSpeedZ_paramC
	call specialObjectAnimate
	call objectApplySpeed

	call companionCalculateAdjacentWallsBitset

	; Check whether Ricky's passed through any walls?
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $0f
	ld e,SpecialObject.counter2
	jr z,+
	ld (de),a
	ret
+
	ld a,(de)
	or a
	ret z
	jp rickyStopUntilLandedOnGround

;;
; State 3: Link is currently jumping up to mount Ricky
rickyState3:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	call companionCheckMountingComplete
	ret nz

	call companionFinalizeMounting
	ld a,SND_RICKY
	call playSound
	ld c,$20
	jp companionSetAnimation

;;
; State 4: Ricky falling into a hazard (hole/water)
rickyState4:
	ld e,SpecialObject.var37
	ld a,(de)
	cp $0e ; Is this water?
	jr z,++

	; For any other value of var37, assume it's a hole ($0d).
	ld a,$0d
	ld (de),a
	call companionDragToCenterOfHole
	ret nz
++
	call companionDecCounter1
	jr nz,@animate

	inc (hl)
	ld e,SpecialObject.var37
	ld a,(de)
	call specialObjectSetAnimation

	ld e,SpecialObject.var37
	ld a,(de)
	cp $0e ; Is this water?
	jr z,@animate
	ld a,SND_LINK_FALL
	jp playSound

@animate:
	call companionAnimateDrowningOrFallingThenRespawn
	ret nc

	; Decide animation depending whether Link is riding Ricky
	ld c,$01
	ld a,(wLinkObjectIndex)
	rrca
	jr nc,+
	ld c,$05
+
	jp companionUpdateDirectionAndSetAnimation

;;
; State 5: Link riding Ricky.
;
; (Note: this may be called from state C?)
;
rickyState5:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw rickyState5Substate0
	.dw rickyState5Substate1
	.dw rickyState5Substate2
	.dw rickyState5Substate3

;;
; Substate 0: moving (not hopping)
rickyState5Substate0:
	ld a,(wForceCompanionDismount)
	or a
	jr nz,++

	ld a,(wGameKeysJustPressed)
	bit BTN_BIT_A,a
	jp nz,rickyStartPunch

	bit BTN_BIT_B,a
++
	jp nz,companionGotoDismountState

	; Copy Link's angle (calculated from input buttons) to companion's angle
	ld h,d
	ld a,(wLinkAngle)
	ld l,SpecialObject.angle
	ld (hl),a

	; If not moving, set var39 to $10 (counter until Ricky hops)
	rlca
	ld l,SpecialObject.var39
	jr nc,@moving
	ld a,$10
	ld (hl),a

	ld c,$20
	call companionSetAnimation
	jp rickyCheckHazards

@moving:
	; Check if the "jump countdown" has reached zero
	ld l,SpecialObject.var39
	ld a,(hl)
	or a
	jr z,@tryToJump

	dec (hl) ; [var39]-=1

	ld l,SpecialObject.speed
	ld (hl),SPEED_c0

	ld c,$20
	call companionUpdateDirectionAndAnimate
	call rickyCheckForHoleInFront
	jp z,rickyBeginJumpOverHole

	call companionCheckHopDownCliff
	jr nz,+
	jp rickySetJumpSpeed
+
	call rickyCheckHopUpCliff
	jr nz,+
	jp rickySetJumpSpeed_andcc91
+
	call companionUpdateMovement
	jp rickyCheckHazards

; "Jump timer" has reached zero; make him jump (either from movement, over a hole, or up
; or down a cliff).
@tryToJump:
	ld h,d
	ld l,SpecialObject.angle
	ldd a,(hl)
	add a
	swap a
	and $03
	ldi (hl),a
	call rickySetJumpSpeed_andcc91

	; If he's moving left or right, skip the up/down cliff checks
	ld l,SpecialObject.angle
	ld a,(hl)
	bit 2,a
	jr nz,@jump

	call companionCheckHopDownCliff
	jr nz,++
	ld (wDisableScreenTransitions),a
	ld c,$0f
	jp companionSetAnimation
++
	call rickyCheckHopUpCliff
	ld c,$0f
	jp z,companionSetAnimation

@jump:
	; If there's a hole in front, try to jump over it
	ld e,SpecialObject.substate
	ld a,$02
	ld (de),a
	call rickyCheckForHoleInFront
	jp z,rickyBeginJumpOverHole

	; Otherwise, just do a normal hop
	ld bc,-$180
	call objectSetSpeedZ
	ld l,SpecialObject.substate
	ld (hl),$01
	ld l,SpecialObject.counter1
	ld (hl),$08
	ld l,SpecialObject.speed
	ld (hl),SPEED_200
	ld c,$19
	call companionSetAnimation

	call getRandomNumber
	and $0f
	ld a,SND_JUMP
	jr nz,+
	ld a,SND_RICKY
+
	jp playSound

;;
; Checks for holes for Ricky to jump over. Stores the tile 2 spaces away in var36.
;
; @param[out]	a	The tile directly in front of Ricky
; @param[out]	var36	The tile 2 spaces in front of Ricky
; @param[out]	zflag	Set if the tile in front of Ricky is a hole
rickyCheckForHoleInFront:
	; Make sure we're not moving diagonally
	ld a,(wLinkAngle)
	and $04
	ret nz

	ld e,SpecialObject.direction
	ld a,(de)
	ld hl,rickyHoleCheckOffsets
	rst_addDoubleIndex

	; Set b = y-position 2 tiles away, [hFF90] = y-position one tile away
	ld e,SpecialObject.yh
	ld a,(de)
	add (hl)
	ldh (<hFF90),a
	add (hl)
	ld b,a

	; Set c = x-position 2 tiles away, [hFF91] = x-position one tile away
	inc hl
	ld e,SpecialObject.xh
	ld a,(de)
	add (hl)
	ldh (<hFF91),a
	add (hl)
	ld c,a

	; Store in var36 the index of the tile 2 spaces away
	call getTileAtPosition
	ld a,l
	ld e,SpecialObject.var36
	ld (de),a

	ldh a,(<hFF90)
	ld b,a
	ldh a,(<hFF91)
	ld c,a
	call getTileAtPosition
	ld h,>wRoomLayout
	ld a,(hl)
	cp TILEINDEX_HOLE
	ret z
	cp TILEINDEX_FD
	ret

;;
; Substate 1: hopping during normal movement
rickyState5Substate1:
	dec e
	ld a,(de) ; Check [state]
	cp $05
	jr nz,@doneInputParsing

	ld a,(wGameKeysJustPressed)
	bit BTN_BIT_A,a
	jp nz,rickyStartPunch

	; Check if we're attempting to move
	ld a,(wLinkAngle)
	bit 7,a
	jr nz,@doneInputParsing

	; Update direction based on wLinkAngle
	ld hl,w1Companion.direction
	ld b,a
	add a
	swap a
	and $03
	ldi (hl),a

	; Check if angle changed (and if animation needs updating)
	ld a,b
	cp (hl)
	ld (hl),a
	ld c,$19
	call nz,companionSetAnimation

@doneInputParsing:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,@landed

	ld a,(wLinkObjectIndex)
	rra
	jr nc,++		; Check if Link's riding?
	ld a,(wLinkAngle)
	and $04
	jr nz,@updateMovement
++
	; If Ricky's facing a hole, don't move into it
	ld hl,rickyHoleCheckOffsets
	call specialObjectGetRelativeTileWithDirectionTable
	ld a,b
	cp TILEINDEX_HOLE
	ret z
	cp TILEINDEX_FD
	ret z

@updateMovement:
	jp companionUpdateMovement

@landed:
	call specialObjectAnimate
	call companionDecCounter1IfNonzero
	ret nz
	jp rickyStopUntilLandedOnGround

;;
; Substate 2: jumping over a hole
rickyState5Substate2:
	call companionDecCounter1
	jr z,++
	dec (hl)
	ret nz
	ld a,SND_RICKY
	call playSound
++
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jp z,rickyStopUntilLandedOnGround

	call specialObjectAnimate
	call companionUpdateMovement
	call specialObjectCheckMovingTowardWall
	jp nz,rickyStopUntilLandedOnGround
	ret

;;
; Substate 3: just landed on the ground (or waiting to land on the ground?)
rickyState5Substate3:
	; If he hasn't landed yet, do nothing until he does
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	call rickyBreakTilesOnLanding

	; Return to state 5, substate 0 (normal movement)
	xor a
	ld e,SpecialObject.substate
	ld (de),a

	jp rickyCheckHazards2

;;
; State 8: punching (substate 0) or charging tornado (substate 1)
rickyState8:
	ld e,$05
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

; Substate 0: punching
@substate0:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,@onGround

	call companionUpdateMovement
	jr ++

@onGround:
	call companionTryToBreakTileFromMoving
	call rickyCheckHazards
++
	; Wait for the animation to signal something (play sound effect or start tornado
	; charging)
	call specialObjectAnimate
	ld e,SpecialObject.animParameter
	ld a,(de)
	and $c0
	ret z

	rlca
	jr c,@startTornadoCharge

	ld a,SND_UNKNOWN5
	jp playSound

@startTornadoCharge:
	; Return if in midair
	ld e,SpecialObject.zh
	ld a,(de)
	or a
	ret nz

	; Check if let go of the button
	ld a,(wGameKeysPressed)
	and BTN_A
	jp z,rickyStopUntilLandedOnGround

	; Start tornado charging
	call itemIncSubstate
	ld c,$13
	call companionSetAnimation
	call companionCheckHazards
	ret nc
	jp rickyFunc_70cc

; Substate 1: charging tornado
@substate1:
	; Update facing direction
	ld a,(wLinkAngle)
	bit 7,a
	jr nz,++
	ld hl,w1Companion.angle
	cp (hl)
	ld (hl),a
	ld c,$13
	call nz,companionUpdateDirectionAndAnimate
++
	call specialObjectAnimate
	ld a,(wGameKeysPressed)
	and BTN_A
	jr z,@releasedAButton

	; Check if fully charged
	ld e,SpecialObject.var35
	ld a,(de)
	cp $1e
	jr nz,@continueCharging

	call companionTryToBreakTileFromMoving
	call rickyCheckHazards
	ld c,$04
	jp companionFlashFromChargingAnimation

@continueCharging:
	inc a
	ld (de),a ; [var35]++
	cp $1e
	ret nz
	ld a,SND_CHARGE_SWORD
	jp playSound

@releasedAButton:
	; Reset palette to normal
	ld hl,w1Link.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a

	ld e,SpecialObject.var35
	ld a,(de)
	cp $1e
	jr nz,@notCharged

	ldbc ITEM_RICKY_TORNADO, $00
	call companionCreateItem

	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SND_SWORDSPIN
	call playSound

	jr rickyStartPunch

@notCharged:
	ld c,$05
	jp companionSetAnimationAndGotoState5

;;
rickyStartPunch:
	ldbc ITEM_28, $00
	call companionCreateWeaponItem
	ret nz
	ld h,d
	ld l,SpecialObject.state
	ld a,$08
	ldi (hl),a
	xor a
	ld (hl),a ; [substate] = 0

	inc a
	ld l,SpecialObject.var35
	ld (hl),a
	ld c,$09
	call companionSetAnimation
	ld a,SND_SWORDSLASH
	jp playSound

;;
; State 6: Link has dismounted; he can't remount until he moves a certain distance away,
; then comes back.
rickyState6:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz
	call itemIncSubstate
	call companionDismountAndSavePosition
	ld a,$17
	jp specialObjectSetAnimation

@substate1:
	ld a,(wLinkInAir)
	or a
	ret nz
	jp itemIncSubstate

; Waiting for Link to get a certain distance away before allowing him to mount again
@substate2:
	call companionSetPriorityRelativeToLink

	ld c,$09
	call objectCheckLinkWithinDistance
	jp c,rickyCheckHazards

	; Link is far enough away; allow him to remount when he approaches again.
	ld e,SpecialObject.substate
	xor a
	ld (de),a ; [substate] = 0
	dec e
	inc a
	ld (de),a ; [state] = 1
	ret

;;
; State 7: Jumping down a cliff
rickyState7:
	call companionDecCounter1ToJumpDownCliff
	ret c

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

;;
; Sets ricky to state 5, substate 3 (do nothing until he lands, then continue normal
; movement)
rickyStopUntilLandedOnGround:
	ld a,(wLinkObjectIndex)
	rrca
	jr nc,+
	xor a
	ld (wLinkInAir),a
	ld (wDisableScreenTransitions),a
+
	ld a,$05
	ld e,SpecialObject.state
	ld (de),a
	ld a,$03
	ld e,SpecialObject.substate
	ld (de),a

	; If Ricky's close to the screen edge, set the "jump delay counter" back to $10 so
	; that he'll stay on the ground long enough for a screen transition to happen
	call rickyCheckAtScreenEdge
	jr z,rickyCheckHazards2
	ld e,SpecialObject.var39
	ld a,$10
	ld (de),a

;;
rickyCheckHazards2:
	call companionCheckHazards
	ld c,$20
	jp nc,companionSetAnimation

;;
; @param	a	Hazard type landed on
rickyFunc_70cc:
	ld c,$0e
	cp $01 ; Landed on water?
	jr z,+
	ld c,$0d
+
	ld h,d
	ld l,SpecialObject.var37
	ld (hl),c
	ld l,SpecialObject.counter1
	ld (hl),$00
	ret

;;
; State A: various cutscene-related things? Behaviour is controlled by "var03" instead of
; "substate".
rickyStateA:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw rickyStateASubstate0
	.dw rickyStateASubstate1
	.dw rickyStateASubstate2
	.dw rickyStateASubstate3
	.dw rickyStateASubstate4
	.dw rickyStateASubstate5
	.dw rickyStateASubstate6
	.dw rickyStateASubstate7
.ifdef ROM_SEASONS
	.dw rickyStateASubstate8
	.dw rickyStateASubstate9
	.dw rickyStateASubstateA
	.dw rickyStateASubstateB
	.dw rickyStateASubstateC
.endif

;;
; Standing around doing nothing?
rickyStateASubstate0:
	call companionPreventLinkFromPassing_noExtraChecks
	call companionSetPriorityRelativeToLink
	call specialObjectAnimate
	ld e,$21
	ld a,(de)
	rlca
	ld c,$40
	jp nc,objectUpdateSpeedZ_paramC
	ld bc,-$100
	jp objectSetSpeedZ

;;
; Force Link to mount
rickyStateASubstate1:
	ld e,SpecialObject.var3d
	call objectRemoveFromAButtonSensitiveObjectList
	jp companionForceMount

.ifdef ROM_AGES
;;
; Ricky leaving upon meeting Tingle (part 1: print text)
rickyStateASubstate2:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	ld bc,TX_2006
	call showText

	ld hl,w1Link.yh
	ld e,SpecialObject.yh
	ld a,(de)
	cp (hl)
	ld a,$02
	jr c,+
	ld a,$00
+
	ld e,SpecialObject.direction
	ld (de),a
	ld a,$03
	ld e,SpecialObject.var3f
	ld (de),a
	call specialObjectSetAnimation
	call rickyIncVar03
	jr rickySetJumpSpeedForCutscene
.else
rickyStateASubstate2:
	ld a,$01
	ld (wDisabledObjects),a
	ld a,DIR_UP
	ld e,SpecialObject.direction
	ld (de),a
	ld a,$05
	ld e,SpecialObject.var3f
	ld (de),a
	call rickyIncVar03
.endif

;;
rickySetJumpSpeedForCutsceneAndSetAngle:
	ld b,$30
	ld c,$58
	call objectGetRelativeAngle
	and $1c
	ld e,SpecialObject.angle
	ld (de),a

;;
rickySetJumpSpeedForCutscene:
	ld bc,-$180
	call objectSetSpeedZ
	ld l,SpecialObject.substate
	ld (hl),$01
	ld l,SpecialObject.speed
	ld (hl),SPEED_200
	ld l,SpecialObject.counter1
	ld (hl),$08
	ret

.ifdef ROM_AGES
;;
; Ricky leaving upon meeting Tingle (part 5: punching the air)
rickyStateASubstate6:
	; Wait for animation to give signals to play sound, start moving away.
	call specialObjectAnimate
	ld e,SpecialObject.animParameter
	ld a,(de)
	or a
	ld a,SND_RICKY
	jp z,playSound

	ld a,(de)
	rlca
	ret nc

	; Start moving away
	call rickySetJumpSpeedForCutsceneAndSetAngle
	ld e,SpecialObject.angle
	ld a,$10
	ld (de),a

	ld c,$05
	call companionSetAnimation
	jp rickyIncVar03

;;
; Ricky leaving upon meeting Tingle (part 2: start moving toward cliff)
rickyStateASubstate3:
	call retIfTextIsActive

	; Move down-left
	ld a,$14
	ld e,SpecialObject.angle
	ld (de),a

	; Face down
	dec e
	ld a,$02
	ld (de),a

	ld c,$05
	call companionSetAnimation
	jp rickyIncVar03

;;
; Ricky leaving upon meeting Tingle (part 4: jumping down cliff)
rickyStateASubstate5:
	call specialObjectAnimate
	call objectApplySpeed
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	; Reached bottom of cliff
	ld a,$18
	call specialObjectSetAnimation
	jp rickyIncVar03

;;
; Ricky leaving upon meeting Tingle (part 3: moving toward cliff, or...
;                                    part 6: moving toward screen edge)
rickyStateASubstate4:
rickyStateASubstate7:
	call companionSetAnimationToVar3f
	call rickyWaitUntilJumpDone
	ret nz

	; Ricky has just touched the ground, and is ready to do another hop.

	; Check if moving toward a wall on the left
	ld a,$18
	ld e,SpecialObject.angle
	ld (de),a
	call specialObjectCheckMovingTowardWall
	jr z,@hop

	; Check if moving toward a wall below
	ld a,$10
	ld e,SpecialObject.angle
	ld (de),a
	call specialObjectCheckMovingTowardWall
	jr z,@hop

	; He's against the cliff; proceed to next state (jumping down cliff).
	call rickySetJumpSpeed
	ld a,SND_JUMP
	call playSound
	jp rickyIncVar03

@hop:
	call objectCheckWithinScreenBoundary
	jr nc,@leftScreen

	; Moving toward cliff, or screen edge? Set angle accordingly.
	ld e,SpecialObject.var03
	ld a,(de)
	cp $07
	ld a,$10
	jr z,+
	ld a,$14
+
	ld e,SpecialObject.angle
	ld (de),a
	jp rickySetJumpSpeedForCutscene

@leftScreen:
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld (wDeathRespawnBuffer.rememberedCompanionId),a
	call itemDelete
	ld hl,wRickyState
	set 6,(hl)
	jp saveLinkLocalRespawnAndCompanionPosition
.else

rickyStateASubstate7:
	call companionSetAnimationToVar3f
	call specialObjectAnimate
	ld e,SpecialObject.animParameter
	ld a,(de)
	or a
	ld a,SND_RICKY
	jp z,playSound
	ld a,(de)
	rlca
	ret nc
	call rickySetJumpSpeedForCutsceneAndSetAngle
	ld e,SpecialObject.angle
	ld a,$10
	ld (de),a
	ret
rickyStateASubstate3:
	call companionSetAnimationToVar3f
	ld e,SpecialObject.var3e
	ld a,(de)
	and $01
	ret nz
	call rickyWaitUntilJumpDone
	ret nz
	ld e,SpecialObject.yh
	ld a,(de)
	cp $38
	jr nc,rickySetJumpSpeedForCutsceneAndSetAngle
	ld e,SpecialObject.var3e
	ld a,(de)
	or $01
	ld (de),a
	ret
rickyStateASubstate4:
	call companionSetAnimationToVar3f
	ld e,SpecialObject.var3e
	ld a,(de)
	bit 1,a
	ret nz
	or $02
	ld (de),a
	jp companionDismount
rickyStateASubstate5:
	call rickySetJumpSpeedForCutsceneAndSetAngle
	ld e,SpecialObject.angle
	ld a,$10
	ld (de),a
	ret
rickyStateASubstate6:
rickyStateASubstate8:
	call companionSetAnimationToVar3f
	call rickyWaitUntilJumpDone
	ret nz
	call objectCheckWithinScreenBoundary
	jr nc,++
	ld e,SpecialObject.yh
	ld a,(de)
	cp $60
	jr c,+
	ld e,SpecialObject.var3e
	ld a,(de)
	or SpecialObject.state
	ld (de),a
+
	call rickySetJumpSpeedForCutsceneAndSetAngle
	ld e,SpecialObject.angle
	ld a,$10
	ld (de),a
	ret
++
	ld a,$01
	ld (wLinkForceState),a
	xor a
	ld (wDisabledObjects),a
	call itemDelete
	jp saveLinkLocalRespawnAndCompanionPosition
rickyStateASubstate9:
	ld a,$80
	ld (wMenuDisabled),a
	ld a,$01
	ld e,SpecialObject.direction
	ld (de),a
	call rickyIncVar03
	ld c,$20
	call companionSetAnimation
-
	ld bc,$4070
	call objectGetRelativeAngle
	and $1c
	ld e,SpecialObject.angle
	ld (de),a
	ret
rickyStateASubstateA:
	call specialObjectAnimate
	call companionUpdateMovement
	ld e,SpecialObject.xh
	ld a,(de)
	cp $38
	jr c,-
	ld bc,TX_2004
	call showText
.endif

;;
rickyIncVar03:
	ld e,SpecialObject.var03
	ld a,(de)
	inc a
	ld (de),a
	ret

;;
; Seasons-only
rickyStateASubstateB:
	call retIfTextIsActive
	call companionDismount

	ld a,$18
	ld (w1Link.angle),a
	ld (wLinkAngle),a

	ld a,SPEED_140
	ld (w1Link.speed),a

	ld h,d
	ld l,SpecialObject.angle
	ld a,$18
	ldd (hl),a

	ld a,DIR_LEFT
	ldd (hl),a ; [direction] = DIR_LEFT
	ld a,$1e
	ld (hl),a ; [counter2] = $1e

	ld a,$24
	call specialObjectSetAnimation
	jr rickyIncVar03

;;
; Seasons-only
rickyStateASubstateC:
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
	ld a,DIR_RIGHT
	jr nc,++
+
	ld a,DIR_LEFT
++
	ld l,SpecialObject.direction
	ld (hl),a
	ld e,SpecialObject.counter2
	ld a,(de)
	or a
	jr z,@moveCompanion
	dec a
	ld (de),a
	ret

@moveCompanion:
	call specialObjectAnimate
	call companionUpdateMovement
	call objectCheckWithinScreenBoundary
	ret c
	xor a
	ld (wRememberedCompanionId),a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp itemDelete

;;
; @param[out]	zflag	Set if Ricky's on the ground and counter1 has reached 0.
rickyWaitUntilJumpDone:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,@onGround

	call companionUpdateMovement
	or d
	ret

@onGround:
	ld c,$05
	call companionSetAnimation
	jp companionDecCounter1IfNonzero

;;
; State $0c: Ricky entering screen from flute call
rickyStateC:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw @parameter0
	.dw @parameter1

@parameter0:
	call companionInitializeOnEnteringScreen
	ld (hl),$02
	call rickySetJumpSpeedForCutscene
	ld a,SND_RICKY
	call playSound
	ld c,$01
	jp companionSetAnimation

@parameter1:
	call rickyState5

	; Return if falling into a hazard
	ld e,SpecialObject.state
	ld a,(de)
	cp $04
	ret z

	ld a,$0c
	ld (de),a ; [state] = $0c
	inc e
	ld a,(de) ; a = [substate]
	cp $03
	ret nz

	call rickyBreakTilesOnLanding
	ld hl,rickyHoleCheckOffsets
	call specialObjectGetRelativeTileWithDirectionTable
	or a
	jr nz,@initializeRicky
	call itemDecCounter2
	jr z,@initializeRicky
	call rickySetJumpSpeedForCutscene
	ld c,$01
	jp companionSetAnimation

; Make Ricky stop moving in, start waiting in place
@initializeRicky:
	ld e,SpecialObject.var03
	xor a
	ld (de),a
	jp rickyState0


;;
; @param[out]	zflag	Set if Ricky should hop up a cliff
rickyCheckHopUpCliff:
	; Check that Ricky's facing a wall above him
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $c0
	cp $c0
	ret nz

	; Check that we're trying to move up
	ld a,(wLinkAngle)
	cp $00
	ret nz

	; Ricky can jump up to two tiles above him where the collision value equals $03
	; (only the bottom half of the tile is solid).

; Check that the tiles on ricky's left and right sides one tile up are clear
@tryOneTileUp:
	ld hl,@cliffOffset_oneUp_right
	call specialObjectGetRelativeTileFromHl
	cp $03
	jr z,+
	ld a,b
	cp TILEINDEX_VINE_TOP
	jr nz,@tryTwoTilesUp
+
	ld hl,@cliffOffset_oneUp_left
	call specialObjectGetRelativeTileFromHl
	cp $03
	jr z,@canJumpUpCliff
	ld a,b
	cp TILEINDEX_VINE_TOP
	jr z,@canJumpUpCliff

; Check that the tiles on ricky's left and right sides two tiles up are clear
@tryTwoTilesUp:
	ld hl,@cliffOffset_twoUp_right
	call specialObjectGetRelativeTileFromHl
	cp $03
	jr z,+
	ld a,b
	cp TILEINDEX_VINE_TOP
	ret nz
+
	ld hl,@cliffOffset_twoUp_left
	call specialObjectGetRelativeTileFromHl
	cp $03
	jr z,@canJumpUpCliff
	ld a,b
	cp TILEINDEX_VINE_TOP
	ret nz

@canJumpUpCliff:
	; State 2 handles jumping up a cliff
	ld e,SpecialObject.state
	ld a,$02
	ld (de),a
	inc e
	xor a
	ld (de),a ; [substate] = 0

	ld e,SpecialObject.counter2
	ld (de),a
	ret

; Offsets for the cliff tile that Ricky will be hopping up to

@cliffOffset_oneUp_right:
	.db $f8 $06
@cliffOffset_oneUp_left:
	.db $f8 $fa
@cliffOffset_twoUp_right:
	.db $e8 $06
@cliffOffset_twoUp_left:
	.db $e8 $fa


;;
rickyBreakTilesOnLanding:
	ld hl,@offsets
@next:
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	or b
	ret z
	push hl
	ld a,(w1Companion.yh)
	add b
	ld b,a
	ld a,(w1Companion.xh)
	add c
	ld c,a
	ld a,BREAKABLETILESOURCE_RICKY_LANDED
	call tryToBreakTile
	pop hl
	jr @next

; Each row is a Y/X offset at which to attempt to break a tile when Ricky lands.
@offsets:
	.db $04 $00
	.db $04 $06
	.db $fe $00
	.db $04 $fa
	.db $00 $00


;;
; Seems to set variables for ricky's jump speed, etc, but the jump may still be cancelled
; after this?
rickyBeginJumpOverHole:
	ld a,$01
	ld (wLinkInAir),a

;;
rickySetJumpSpeed_andcc91:
	ld a,$01
	ld (wDisableScreenTransitions),a

;;
; Sets up Ricky's speed for long jumps across holes and cliffs.
rickySetJumpSpeed:
	ld bc,-$300
	call objectSetSpeedZ
	ld l,SpecialObject.counter1
	ld (hl),$08
	ld l,SpecialObject.speed
	ld (hl),SPEED_140
	ld c,$0f
	call companionSetAnimation
	ld h,d
	ret

;;
; @param[out]	zflag	Set if Ricky's close to the screen edge
rickyCheckAtScreenEdge:
	ld h,d
	ld l,SpecialObject.yh
	ld a,$06
	cp (hl)
	jr nc,@outsideScreen

	ld a,(wScreenTransitionBoundaryY)
	dec a
	cp (hl)
	jr c,@outsideScreen

	ld l,SpecialObject.xh
	ld a,$06
	cp (hl)
	jr nc,@outsideScreen

	ld a,(wScreenTransitionBoundaryX)
	dec a
	cp (hl)
	jr c,@outsideScreen

	xor a
	ret

@outsideScreen:
	or d
	ret

; Offsets relative to Ricky's position to check for holes to jump over
rickyHoleCheckOffsets:
	.db $f8 $00
	.db $05 $08
	.db $08 $00
	.db $05 $f8
