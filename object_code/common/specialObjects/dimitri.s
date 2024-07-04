; var38: nonzero if Dimitri is in water?
specialObjectCode_dimitri:
	call companionRetIfInactive
	call companionFunc_47d8
	call @runState
	xor a
	ld (wDimitriHitNpc),a
	jp companionCheckEnableTerrainEffects

; Note: expects that h=d (call to companionFunc_47d8 does this)
@runState:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw dimitriState0
	.dw dimitriState1
	.dw dimitriState2
	.dw dimitriState3
	.dw dimitriState4
	.dw dimitriState5
	.dw dimitriState6
	.dw dimitriState7
	.dw dimitriState8
	.dw dimitriState9
	.dw dimitriStateA
	.dw dimitriStateB
	.dw dimitriStateC
	.dw dimitriStateD

;;
; State 0: initialization, deciding which state to go to
dimitriState0:
	call companionCheckCanSpawn

	ld a,DIR_DOWN
	ld l,SpecialObject.direction
	ldi (hl),a
	ld (hl),a ; [counter2] = $02

	ld a,(wDimitriState)
.ifdef ROM_AGES
	bit 7,a
	jr nz,@setAnimation
	bit 6,a
	jr nz,+
	and $20
	jr nz,@setAnimation
+
	ld a,GLOBALFLAG_SAVED_COMPANION_FROM_FOREST
	call checkGlobalFlag
	ld h,d
	ld c,$24
	jr z,+
	ld c,$1e
+
	ld l,SpecialObject.state
	ld (hl),$0a

	ld e,SpecialObject.var3d
	call objectAddToAButtonSensitiveObjectList

	ld a,c
.else
	and $80
	jr nz,@setAnimation
	ld l,SpecialObject.state
	ld (hl),$0a
	ld e,SpecialObject.var3d
	call objectAddToAButtonSensitiveObjectList
	ld a,$24
.endif

	ld e,SpecialObject.var3f
	ld (de),a
	call specialObjectSetAnimation

	ld bc,$0408
	call objectSetCollideRadii
	jr @setVisible

@setAnimation:
	ld c,$1c
	call companionSetAnimation
@setVisible:
	jp objectSetVisible81

;;
; State 1: waiting for Link to mount
dimitriState1:
	call companionSetPriorityRelativeToLink
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	; Is dimitri in a hole?
	call companionCheckHazards
	jr nc,@onLand
	cp $02
	ret z

	; No, he must be in water
	call dimitriAddWaterfallResistance
	ld a,$04
	call dimitriFunc_756d
	jr ++

@onLand:
	ld e,SpecialObject.var38
	ld a,(de)
	or a
	jr z,++
	xor a
	ld (de),a
	ld c,$1c
	call companionSetAnimation
++
	ld a,$06
	call objectSetCollideRadius

	ld e,SpecialObject.var3b
	ld a,(de)
	or a
	jp nz,dimitriGotoState1IfLinkFarAway

	ld c,$09
	call objectCheckLinkWithinDistance
	jp nc,dimitriCheckAddToGrabbableObjectBuffer
	jp companionTryToMount

;;
; State 2: curled into a ball (being held or thrown).
;
; The substates are generally controlled by power bracelet code (see "itemCode16").
;
dimitriState2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw dimitriState2Substate0
	.dw dimitriState2Substate1
	.dw dimitriState2Substate2
	.dw dimitriState2Substate3

;;
; Substate 0: just grabbed
dimitriState2Substate0:
	ld a,$40
	ld (wLinkGrabState2),a
	call itemIncSubstate
	xor a
	ld (wDisableWarpTiles),a

	ld l,SpecialObject.var38
	ld (hl),a
	ld l,SpecialObject.var3f
	ld (hl),$ff

	call objectSetVisiblec0

	ld a,$02
	ld hl,wCompanionTutorialTextShown
	call setFlag

	ld c,$18
	jp companionSetAnimation

;;
; Substate 1: being lifted, carried
dimitriState2Substate1:
	xor a
	ld (w1Link.knockbackCounter),a
	ld a,(wActiveTileType)
	cp TILETYPE_CRACKED_ICE
	jr nz,+
	ld a,$20
	ld (wStandingOnTileCounter),a
+
	ld a,(wLinkClimbingVine)
	or a
	jr nz,@releaseDimitri

	ld a,(w1Link.angle)
	bit 7,a
	jr nz,@update

	ld e,SpecialObject.angle
	ld (de),a

	ld a,(w1Link.direction)
	dec e
	ld (de),a ; [direction] = [w1Link.direction]

	call dimitriCheckCanBeHeldInDirection
	jr nz,@update

@releaseDimitri:
	ld h,d
	ld l,SpecialObject.enabled
	res 1,(hl)
	ld l,SpecialObject.var3b
	ld (hl),$01
	jp dropLinkHeldItem

@update:
	; Check whether to prevent Link from throwing dimitri (write nonzero to wcc67)
	call companionCalculateAdjacentWallsBitset
	call specialObjectCheckMovingTowardWall
	ret z
	ld (wcc67),a
	ret

;;
; Substate 2: dimitri released, falling to ground
dimitriState2Substate2:
	ld h,d
	ld l,SpecialObject.enabled
	res 1,(hl)

	call companionCheckHazards
	jr nc,@noHazard

	; Return if he's on a hole
	cp $02
	ret z
	jr @onHazard

@noHazard:
	ld h,d
	ld l,SpecialObject.var3f
	ld a,(hl)
	cp $ff
	jr nz,++

	; Set Link's current position as the spot to return to if Dimitri lands in water
	xor a
	ld (hl),a
	ld l,SpecialObject.var39
	ld a,(w1Link.yh)
	ldi (hl),a
	ld a,(w1Link.xh)
	ld (hl),a
++

; Check whether Dimitri should stop moving when thrown. Involves screen boundary checks.

	ld a,(wDimitriHitNpc)
	or a
	jr nz,@stopMovement

	call companionCalculateAdjacentWallsBitset
	call specialObjectCheckMovingTowardWall
	jr nz,@stopMovement

	ld c,$00
	ld h,d
	ld l,SpecialObject.yh
	ld a,(hl)
	cp $08
	jr nc,++
	ld (hl),$10
	inc c
	jr @checkX
++
	ld a,(wActiveGroup)
	or a
	ld a,(hl)
	jr nz,@largeRoomYCheck
@smallRoomYCheck:
	cp SMALL_ROOM_HEIGHT*16-6
	jr c,@checkX
	ld (hl), SMALL_ROOM_HEIGHT*16-6
	inc c
	jr @checkX
@largeRoomYCheck:
	cp LARGE_ROOM_HEIGHT*16-8
	jr c,@checkX
	ld (hl), LARGE_ROOM_HEIGHT*16-8
	inc c
	jr @checkX

@checkX:
	ld l,SpecialObject.xh
	ld a,(hl)
	cp $04
	jr nc,++
	ld (hl),$04
	inc c
	jr @doneBoundsCheck
++
	ld a,(wActiveGroup)
	or a
	ld a,(hl)
	jr nz,@largeRoomXCheck
@smallRoomXCheck:
	cp SMALL_ROOM_WIDTH*16-5
	jr c,@doneBoundsCheck
	ld (hl), SMALL_ROOM_WIDTH*16-5
	inc c
	jr @doneBoundsCheck
@largeRoomXCheck:
	cp LARGE_ROOM_WIDTH*16-17
	jr c,@doneBoundsCheck
	ld (hl), LARGE_ROOM_WIDTH*16-17
	inc c

@doneBoundsCheck:
	ld a,c
	or a
	jr z,@checkOnHazard

@stopMovement:
	ld a,SPEED_0
	ld (w1ReservedItemC.speed),a

@checkOnHazard:
	call objectCheckIsOnHazard
	cp $01
	ret nz

@onHazard:
	ld h,d
	ld l,SpecialObject.state
	ld (hl),$0b
	ld l,SpecialObject.var38
	ld (hl),$04

	; Calculate angle toward Link?
	ld l,SpecialObject.var39
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call objectGetRelativeAngle
	and $18
	ld e,SpecialObject.angle
	ld (de),a

	; Calculate direction based on angle
	add a
	swap a
	and $03
	dec e
	ld (de),a ; [direction] = a

	ld c,$00
	jp companionSetAnimation

;;
; Substate 3: landed on ground for good
dimitriState2Substate3:
	ld h,d
	ld l,SpecialObject.enabled
	res 1,(hl)

	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz
	call companionTryToBreakTileFromMoving
	call companionCheckHazards
	jr nc,@gotoState1

	; If on a hole, return (stay in this state?)
	cp $02
	ret z

	; If in water, go to state 1, but with alternate value for var38?
	ld a,$04
	jp dimitriFunc_756d

@gotoState1:
	xor a

;;
; @param	a	Value for var38
dimitriFunc_756d:
	ld h,d
	ld l,SpecialObject.var38
	ld (hl),a

	ld l,SpecialObject.state
	ld a,$01
	ldi (hl),a
	ld (hl),$00 ; [substate] = 0

	ld c,$1c
	jp companionSetAnimation

;;
; State 3: Link is jumping up to mount Dimitri
dimitriState3:
	call companionCheckMountingComplete
	ret nz
	call companionFinalizeMounting
	ld c,$00
	jp companionSetAnimation

;;
; State 4: Dimitri's falling into a hazard (hole/water)
dimitriState4:
	call companionDragToCenterOfHole
	ret nz
	call companionDecCounter1
	jr nz,@animate

	inc (hl)
	ld a,SND_LINK_FALL
	call playSound
	ld a,$25
	jp specialObjectSetAnimation

@animate:
	call companionAnimateDrowningOrFallingThenRespawn
	ret nc
	ld c,$00
	jp companionUpdateDirectionAndSetAnimation

;;
; State 5: Link riding dimitri.
dimitriState5:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	ld a,(wForceCompanionDismount)
	or a
	jr nz,++
	ld a,(wGameKeysJustPressed)
	bit BTN_BIT_A,a
	jr nz,dimitriGotoEatingState
	bit BTN_BIT_B,a
++
	jp nz,companionGotoDismountState

	ld a,(wLinkAngle)
	bit 7,a
	jr nz,dimitriUpdateMovement@checkHazards

	; Check if angle changed, update direction if so
	ld hl,w1Companion.angle
	cp (hl)
	ld (hl),a
	ld c,$00
	jp nz,companionUpdateDirectionAndAnimate

	; Return if he should hop down a cliff (state changed in function call)
	call companionCheckHopDownCliff
	ret z

;;
dimitriUpdateMovement:
	; Play sound effect when animation indicates to do so
	ld h,d
	ld l,SpecialObject.animParameter
	ld a,(hl)
	rlca
	ld a,SND_LINK_SWIM
	call c,playSound

	; Determine speed
	ld l,SpecialObject.var38
	ld a,(hl)
	or a
	ld a,SPEED_c0
	jr z,+
	ld a,SPEED_100
+
	ld l,SpecialObject.speed
	ld (hl),a
	call companionUpdateMovement
	call specialObjectAnimate

@checkHazards:
	call companionCheckHazards
	ld h,d
	jr nc,@setNotInWater

	; Return if the hazard is a hole
	cp $02
	ret z

	; If it's water, stay in state 5 (he can swim).
	ld l,SpecialObject.state
	ld (hl),$05

.ifdef ROM_AGES
	ld a,(wLinkForceState)
	cp LINK_STATE_RESPAWNING
	jr nz,++
	xor a
	ld (wLinkForceState),a
	jp companionGotoHazardHandlingState
++
.endif

	call dimitriAddWaterfallResistance
	ld b,$04
	jr @setWaterStatus

@setNotInWater:
	ld b,$00

@setWaterStatus:
	; Set var38 to value of "b", update animation if it changed
	ld l,SpecialObject.var38
	ld a,(hl)
	cp b
	ld (hl),b
	ld c,$00
	jp nz,companionUpdateDirectionAndSetAnimation

;;
dimitriState9:
	ret

;;
dimitriGotoEatingState:
	ld h,d
	ld l,SpecialObject.state
	ld a,$08
	ldi (hl),a
	xor a
	ldi (hl),a ; [substate] = 0
	ld (hl),a  ; [counter1] = 0

	ld l,SpecialObject.var35
	ld (hl),a

	; Calculate angle based on direction
	ld l,SpecialObject.direction
	ldi a,(hl)
	swap a
	rrca
	ld (hl),a

	ld a,$01
	ld (wLinkInAir),a
	ld l,SpecialObject.speed
	ld (hl),SPEED_c0
	ld c,$08
	call companionSetAnimation
	ldbc ITEM_DIMITRI_MOUTH, $00
	call companionCreateWeaponItem

	ld a,SND_DIMITRI
	jp playSound

;;
; State 6: Link has dismounted; he can't remount until he moves a certain distance away,
; then comes back.
dimitriState6:
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
	ld c,$1c
	jp companionSetAnimation

@substate1:
	ld a,(wLinkInAir)
	or a
	ret nz
	jp itemIncSubstate

@substate2:
	call dimitriCheckAddToGrabbableObjectBuffer

;;
dimitriGotoState1IfLinkFarAway:
	; Return if Link is too close
	ld c,$09
	call objectCheckLinkWithinDistance
	ret c

;;
; @param[out]	a	0
; @param[out]	de	var3b
dimitriGotoState1:
	ld e,SpecialObject.state
	ld a,$01
	ld (de),a
	inc e
	xor a
	ld (de),a ; [substate] = 0
	ld e,SpecialObject.var3b
	ld (de),a
	ret

;;
; State 7: jumping down a cliff
dimitriState7:
	call companionDecCounter1ToJumpDownCliff
	ret c
	call companionCalculateAdjacentWallsBitset
	call specialObjectCheckMovingAwayFromWall

	ld l,SpecialObject.counter2
	jr z,+
	ld (hl),a
	ret
+
	ld a,(hl)
	or a
	ret z
	jp dimitriLandOnGroundAndGotoState5

;;
; State 8: Attempting to eat something
dimitriState8:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Substate 0: Moving forward for the bite
@substate0:
	call specialObjectAnimate
	call objectApplySpeed
	ld e,SpecialObject.animParameter
	ld a,(de)
	rlca
	ret nc

	; Initialize stuff for substate 1 (moving back)

	call itemIncSubstate

	; Calculate angle based on the reverse of the current direction
	ld l,SpecialObject.direction
	ldi a,(hl)
	xor $02
	swap a
	rrca
	ld (hl),a

	ld l,SpecialObject.counter1
	ld (hl),$0c
	ld c,$00
	jp companionSetAnimation

; Substate 1: moving back
@substate1:
	call specialObjectAnimate
	call objectApplySpeed
	call companionDecCounter1IfNonzero
	ret nz

	; Done moving back

	ld (hl),$14

	; Fix angle to be consistent with direction
	ld l,SpecialObject.direction
	ldi a,(hl)
	swap a
	rrca
	ld (hl),a

	; Check if he swallowed something; if so, go to substate 2, otherwise resume
	; normal movement.
	ld l,SpecialObject.var35
	ld a,(hl)
	or a
	jp z,dimitriLandOnGroundAndGotoState5
	call itemIncSubstate
	ld c,$10
	jp companionSetAnimation

; Substate 2: swallowing something
@substate2:
	call specialObjectAnimate
	call companionDecCounter1IfNonzero
	ret nz
	jr dimitriLandOnGroundAndGotoState5

;;
; State B: swimming back to land after being thrown into water
dimitriStateB:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	call dimitriUpdateMovement

	; Set state to $01 if he's out of the water; stay in $0b otherwise
	ld h,d
	ld l,SpecialObject.var38
	ld a,(hl)
	or a
	ld l,SpecialObject.state
	ld (hl),$0b
	ret nz
	ld (hl),$01
	ret

;;
; State C: Dimitri entering screen from flute call
dimitriStateC:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw @parameter0
	.dw @parameter1

; substate 0: dimitri just spawned?
@parameter0:
	call companionInitializeOnEnteringScreen
	ld (hl),$3c ; [counter2] = $3c

	ld a,SND_DIMITRI
	call playSound
	ld c,$00
	jp companionSetAnimation

; substate 1: walking in
@parameter1:
	call dimitriUpdateMovement
	ld e,SpecialObject.state
	ld a,$0c
	ld (de),a

	ld hl,dimitriTileOffsets
	call companionRetIfNotFinishedWalkingIn

	; Done walking into screen; jump to state 0
	ld e,SpecialObject.var03
	xor a
	ld (de),a
	jp dimitriState0

;;
; State D: ? (set to this by INTERAC_CARPENTER subid $ff?)
dimitriStateD:
	ld e,SpecialObject.var3c
	ld a,(de)
	or a
	jr nz,++

	call dimitriGotoState1
	inc a
	ld (de),a ; [var3b] = 1

	ld hl,w1Companion.enabled
	res 1,(hl)
	ld c,$1c
	jp companionSetAnimation
++
	ld e,SpecialObject.state
	ld a,$05
	ld (de),a

;;
dimitriLandOnGroundAndGotoState5:
	xor a
	ld (wLinkInAir),a
	ld c,$00
	jp companionSetAnimationAndGotoState5

.ifdef ROM_AGES
;;
; State A: cutscene-related stuff
dimitriStateA:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw dimitriStateASubstate0
	.dw dimitriStateASubstate1
	.dw dimitriStateASubstate2
	.dw dimitriStateASubstate3
	.dw dimitriStateASubstate4

;;
; Force mounting Dimitri?
dimitriStateASubstate0:
	ld e,SpecialObject.var3d
	ld a,(de)
	or a
	jr z,+
	ld a,$81
	ld (wDisabledObjects),a
+
	call companionSetAnimationToVar3f
	call companionPreventLinkFromPassing_noExtraChecks
	call specialObjectAnimate

	ld e,SpecialObject.visible
	ld a,$c7
	ld (de),a

	ld a,(wDimitriState)
	and $80
	ret z

	ld e,SpecialObject.visible
	ld a,$c1
	ld (de),a

	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
	ld c,$1c
	call companionSetAnimation
	jp companionForceMount

;;
; Force mounting dimitri?
dimitriStateASubstate1:
	ld e,SpecialObject.var3d
	call objectRemoveFromAButtonSensitiveObjectList
	ld c,$1c
	call companionSetAnimation
	jp companionForceMount

;;
; Dimitri begins parting upon reaching mainland?
dimitriStateASubstate3:
	ld e,SpecialObject.direction
	ld a,DIR_RIGHT
	ld (de),a
	inc e
	ld a,$08
	ld (de),a ; [angle] = $08

	ld c,$00
	call companionSetAnimation
	ld e,SpecialObject.var03
	ld a,$04
	ld (de),a

	ld a,SND_DIMITRI
	jp playSound

;;
; Dimitri moving until he goes off-screen
dimitriStateASubstate4:
	call dimitriUpdateMovement

	ld e,SpecialObject.state
	ld a,$0a
	ld (de),a

	call objectCheckWithinScreenBoundary
	ret c

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld (wUseSimulatedInput),a
	jp itemDelete

;;
; Force dismount Dimitri
dimitriStateASubstate2:
	ld a,(wLinkObjectIndex)
	cp >w1Companion
	ret nz
	call companionDismountAndSavePosition
	xor a
	ld (wRememberedCompanionId),a
	ret
.else
dimitriStateA:
	call companionSetAnimationToVar3f
	call companionPreventLinkFromPassing_noExtraChecks
	call specialObjectAnimate
	ld e,SpecialObject.visible
	ld a,$c7
	ld (de),a
	ld a,(wDimitriState)
	and $80
	ret z

	ld e,SpecialObject.visible
	ld a,$c1
	ld (de),a
	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
	ld c,$1c
	call companionSetAnimation
	jp companionForceMount
.endif

;;
dimitriCheckAddToGrabbableObjectBuffer:
	ld a,(wLinkClimbingVine)
	or a
	ret nz
	ld a,(w1Link.direction)
	call dimitriCheckCanBeHeldInDirection
	ret z

	; Check the collisions at Link's position
	ld hl,w1Link.yh
	ld b,(hl)
	ld l,<w1Link.xh
	ld c,(hl)
	call getTileCollisionsAtPosition

	; Disallow cave entrances (top half solid)?
	cp $0c
	jr z,@ret

	; Disallow if Link's on a fully solid tile?
	cp $0f
	jr z,@ret

	cp SPECIALCOLLISION_VERTICAL_BRIDGE
	jr z,@ret
	cp SPECIALCOLLISION_HORIZONTAL_BRIDGE
	call nz,objectAddToGrabbableObjectBuffer
@ret:
	ret

;;
; Checks the tiles in front of Dimitri to see if he can be held?
; (if moving diagonally, it checks both directions, and fails if one is impassable).
;
; This seems to disallow holding him on small bridges and cave entrances.
;
; @param	a	Direction that Link/Dimitri's moving toward
; @param[out]	zflag	Set if one of the tiles in front are not passable.
dimitriCheckCanBeHeldInDirection:
	call @checkTile
	ret z

	ld hl,w1Link.angle
	ldd a,(hl)
	bit 7,a
	ret nz
	bit 2,a
	jr nz,@diagonalMovement

	or d
	ret

@diagonalMovement:
	; Calculate the other direction being moved in
	add a
	ld b,a
	ldi a,(hl) ; a = [direction]
	swap a
	srl a
	xor b
	add a
	swap a
	and $03

;;
; @param	a	Direction
; @param[out]	zflag	Set if the tile in that direction is not ok for holding dimitri?
@checkTile:
	ld hl,dimitriTileOffsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call objectGetRelativeTile

	cp TILEINDEX_VINE_BOTTOM
	ret z
	cp TILEINDEX_VINE_MIDDLE
	ret z
	cp TILEINDEX_VINE_TOP
	ret z

	; Only disallow tiles where the top half is solid? (cave entrances?
	ld h,>wRoomCollisions
	ld a,(hl)
	cp $0c
	ret z

	cp SPECIALCOLLISION_VERTICAL_BRIDGE
	ret z
	cp SPECIALCOLLISION_HORIZONTAL_BRIDGE
	ret

;;
; Moves Dimitri down if he's on a waterfall
dimitriAddWaterfallResistance:
	call objectGetTileAtPosition
	ld h,d
	cp TILEINDEX_WATERFALL
	jr z,+
	cp TILEINDEX_WATERFALL_BOTTOM
	ret nz
+
	; Move y-position down the waterfall (acts as resistance)
	ld l,SpecialObject.y
	ld a,(hl)
	add $c0
	ldi (hl),a
	ld a,(hl)
	adc $00
	ld (hl),a

	; Check if we should start a screen transition based on downward waterfall
	; movement
	ld a,(wScreenTransitionBoundaryY)
	cp (hl)
	ret nc
	ld a,$82
	ld (wScreenTransitionDirection),a
	ret

dimitriTileOffsets:
	.db $f8 $00 ; DIR_UP
	.db $00 $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT
