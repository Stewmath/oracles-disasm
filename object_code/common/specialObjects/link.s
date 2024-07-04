;;
; Update the link object.
;
; @param	d	Link object
specialObjectCode_link:
	ld e,<w1Link.state
	ld a,(de)
	rst_jumpTable
	.dw linkState00
	.dw linkState01
	.dw linkState02
	.dw linkState03
	.dw linkState04
	.dw linkState05
	.dw linkState06
	.dw linkState07
	.dw linkState08
	.dw linkState09
	.dw linkState0a
	.dw linkState0b
	.dw linkState0c
	.dw linkState0d
	.dw linkState0e
	.dw linkState0f
	.dw linkState10
	.dw linkState11
	.dw linkState12
	.dw linkState13
	.dw linkState14

;;
; LINK_STATE_00
linkState00:
	call clearAllParentItems
	call specialObjectSetOamVariables
	ld a,LINK_ANIM_MODE_WALK
	call specialObjectSetAnimation

	; Enable collisions?
	ld h,d
	ld l,SpecialObject.collisionType
	ld a,$80
	ldi (hl),a

	; Set collisionRadiusY,X
	inc l
	ld a,$06
	ldi (hl),a
	ldi (hl),a

	; A non-dead default health?
	ld l,SpecialObject.health
	ld (hl),$01

	; Do a series of checks to see whether Link spawned in an invalid position.

	ld a,(wLinkForceState)
	cp LINK_STATE_WARPING
	jr z,+

	ld a,(wDisableRingTransformations)
	or a
	jr nz,+

	; Check if he's in a solid wall
	call objectGetTileCollisions
	cp $0f
	jr nz,+

	; If he's in a wall, move Link to wLastAnimalMountPointY/X?
	ld hl,wLastAnimalMountPointY
	ldi a,(hl)
	ld e,<w1Link.yh
	ld (de),a
	ld a,(hl)
	ld e,<w1Link.xh
	ld (de),a
+
	call objectSetVisiblec1
	call checkLinkForceState
	jp initLinkStateAndAnimateStanding

;;
; LINK_STATE_WARPING
linkState0a:
	ld a,(wWarpTransition)
	and $0f
	rst_jumpTable
	.dw warpTransition0
	.dw warpTransition1
	.dw warpTransition2
	.dw warpTransition3
	.dw warpTransition4
	.dw warpTransition5
	.dw warpTransition6
.ifdef ROM_AGES
	.dw warpTransitionA
.else
	.dw warpTransition7
.endif
	.dw warpTransition8
	.dw warpTransition9
	.dw warpTransitionA
	.dw warpTransitionB
	.dw warpTransitionC
	.dw warpTransitionA
	.dw warpTransitionE
	.dw warpTransitionF

;;
; TRANSITION_DEST_BASIC
warpTransition0:
	call warpTransition_setLinkFacingDir
;;
; TRANSITION_DEST_UNKNOWN_A
warpTransitionA:
	jp initLinkStateAndAnimateStanding

;;
; TRANSITION_DEST_X_SHIFTED
; Shifts Link's X position left 8, but otherwise behaves like Transition 1
warpTransitionE:
	call objectCenterOnTile
	ld a,(hl)
	and $f0
	ld (hl),a

;;
; TRANSITION_DEST_SET_RESPAWN
; Behaves like transition 0, but saves link's deathwarp point
warpTransition1:
	call warpTransition_setLinkFacingDir

;;
warpUpdateRespawnPoint:
	ld a,(wActiveGroup)
	cp FIRST_SIDESCROLL_GROUP ; Don't update respawn point in sidescrolling rooms?
	jr nc,warpTransition0
	call setDeathRespawnPoint
	call updateLinkLocalRespawnPosition
	jp initLinkStateAndAnimateStanding

;;
; TRANSITION_DEST_UNKNOWN_C
; Behaves like transition 0, but sets link's facing direction in a way I don't understand
warpTransitionC:
	ld a,(wcc50)
	and $03
	ld e,<w1Link.direction
	ld (de),a
	jp initLinkStateAndAnimateStanding

;;
warpTransition_setLinkFacingDir:
	call objectGetTileAtPosition
	ld hl,facingDirAfterWarpTable
	call lookupCollisionTable
	jr c,+
	ld a,DIR_DOWN
+
	ld e,<w1Link.direction
	ld (de),a
	ret

.include {"{GAME_DATA_DIR}/tile_properties/facingDirAfterWarp.s"}

;;
; TRANSITION_SRC_FADEOUT
; Screen fades out.
warpTransition2:
	ld a,$03
	ld (wWarpTransition2),a
	ld a,SND_ENTERCAVE
	jp playSound

;;
; TRANSITION_DEST_ENTERSCREEN
; TRANSITION_SRC_LEAVESCREEN
; Used by both sources and destinations for transitions where link walks off the screen (or comes in
; from off the screen). It saves link's deathwarp point.
warpTransition3:
	ld e,<w1Link.warpVar1
	ld a,(de)
	or a
	jr nz,@eachFrame

	; Initialization stuff
	ld h,d
	ld l,e
	inc (hl)
	ld l,<w1Link.warpVar2
	ld (hl),$10

	; Set link speed, up or down
	ld a,(wWarpTransition)
	and $40
	swap a
	rrca
	ld bc,@directionTable
	call addAToBc
	ld l,<w1Link.direction
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld a,(bc)
	ld (hl),a

	call updateLinkSpeed_standard
	call animateLinkStanding
	ld a,(wWarpTransition)
	rlca
	jr c,@destInit

	ld a,SND_ENTERCAVE
	jp playSound

@directionTable:
	.db $00 $00
	.db $02 $10

@eachFrame:
	ld a,(wScrollMode)
	and $0a
	ret nz

	ld a,$00
	ld (wScrollMode),a
	call specialObjectAnimate
	call itemDecCounter1
	jp nz,specialObjectUpdatePosition

	; Counter has reached zero
	ld a,$01
	ld (wScrollMode),a
	xor a
	ld (wMenuDisabled),a

	; Update respawn point if this is a destination
	ld a,(wWarpTransition)
	bit 7,a
	jp nz,warpUpdateRespawnPoint

	swap a
	and $03
	ld (wWarpTransition2),a
	ret

@destInit:
	ld h,d
	ld a,(wWarpDestPos)
	cp $ff
	jr z,@enterFromMiddleBottom

	cp $f0
	jr nc,@enterFromBottom

	ld l,<w1Link.yh
	call setShortPosition
	ld l,<w1Link.warpVar2
	ld (hl),$1c
	jp initLinkStateAndAnimateStanding

@enterFromMiddleBottom:
	ld a,$01
	ld (wMenuDisabled),a
	ld l,<w1Link.warpVar2
	ld (hl),$1c
	ld a,(wWarpTransition)
	and $40
	swap a
	ld b,a
	ld a,(wActiveGroup)
	and NUM_SMALL_GROUPS
	rrca
	or b
	ld bc,@linkPosTable
	call addAToBc
	ld l,<w1Link.yh
	ld a,(bc)
	ldi (hl),a
	inc bc
	inc l
	ld a,(bc)
	ld (hl),a
	ret

@enterFromBottom:
	call @enterFromMiddleBottom
	ld a,(wWarpDestPos)
	swap a
	and $f0
	ld b,a

	; Add +8 to link's X position if in a large room
	ld a,(wActiveGroup)
	and NUM_SMALL_GROUPS
	jr z,+
	rlca
+
	or b
	ld l,<w1Link.xh
	ld (hl),a
	ret

@linkPosTable:
	.db $80 $50 ; small room, enter from bottom
	.db $b0 $78 ; large room, enter from bottom
	.db $f0 $50 ; small room, enter from top
	.db $f0 $78 ; large room, enter from top

;;
; TRANSITION_DEST_DONT_SET_RESPAWN
; TRANSITION_SRC_INSTANT
warpTransition4:
	ld a,(wWarpTransition)
	rlca
	jp c,warpTransition0

	ld a,$01
	ld (wWarpTransition2),a
	ld a,SND_ENTERCAVE
	jp playSound

;;
; TRANSITION_DEST_FALL
; Link falls into the screen
warpTransition5:
	ld e,<w1Link.warpVar1
	ld a,(de)
	rst_jumpTable
	.dw warpTransition5_00
	.dw warpTransition5_01
	.dw warpTransition5_02

warpTransition5_00:
	ld a,$01
	ld (de),a
	ld bc,$0020
	call objectSetSpeedZ
	call objectGetZAboveScreen
	ld l,<w1Link.zh
	ld (hl),a
	ld l,<w1Link.yh
	ld a,(hl)
	sub $04
	ld (hl),a
	ld l,<w1Link.direction
	ld (hl),DIR_DOWN
	ld a,LINK_ANIM_MODE_FALL
	jp specialObjectSetAnimation

warpTransition5_01:
	call specialObjectAnimate
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	; BUG(?): the "objectGetTileAtPosition" function call was removed in Ages, but this seems to
	; have been a mistake, since the value of the "a" register from that call is needed for the
	; "lookupCollisionTable" function call below.
	; Despite this, there don't seem to be any particular problems when using this transition
	; type in Ages, but it may look a bit weird if used on top of a water tile.

.ifdef ROM_SEASONS
	call objectGetTileAtPosition
	cp TILEINDEX_TRAMPOLINE
	jr z,@trampoline
.else; ROM_AGES
.ifdef ENABLE_BUGFIXES
	call objectGetTileAtPosition
.endif
.endif

	; If he didn't fall into a hazard, make link "collapse" when he lands.
	ld hl,hazardCollisionTable
	call lookupCollisionTable
	jp nc,warpTransition7@linkCollapsed
	jp initLinkStateAndAnimateStanding

.ifdef ROM_SEASONS
@trampoline:
	ld a,(wActiveGroup)
	and $06
	cp $04
	jp nz,warpTransition7@linkCollapsed
	; group 4/5
	jp bounceLinkOffTrampolineAfterFalling
.endif


.ifdef ROM_SEASONS

; TRANSITION_DEST_FROM_TRAMPOLINE
; Jumped in from a trampoline.
warpTransition6:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw warpTransition6_00
	.dw warpTransition6_01

warpTransition6_00:
	ld a,$01
	ld (de),a

	ld a,(wcc50)
	bit 7,a
	jr z,+
	rrca
	and $0f
	ld (wcc50),a
	ld a,LINK_STATE_BOUNCING_ON_TRAMPOLINE
	jp linkSetState
+
	ld bc,-$300
	call objectSetSpeedZ
	ld l,SpecialObject.counter1
	ld (hl),120
	ld l,SpecialObject.yh
	ld a,(hl)
	sub $04
	ld (hl),a
	ld a,LINK_ANIM_MODE_FALL
	call specialObjectSetAnimation

warpTransition6_01:
	ld c,$18
	call objectUpdateSpeedZ_paramC
	jr z,@hitGround
	call specialObjectAnimate
	call specialObjectUpdateAdjacentWallsBitset
	ld e,SpecialObject.speed
	ld a,SPEED_80
	ld (de),a
	ld a,(wLinkAngle)
	ld e,SpecialObject.angle
	ld (de),a
	call updateLinkDirectionFromAngle
	jp specialObjectUpdatePosition

@hitGround:
	call objectGetTileAtPosition
	cp TILEINDEX_TRAMPOLINE
	jp z,bounceLinkOffTrampolineAfterFalling
	jp initLinkStateAndAnimateStanding
.endif


;;
; TRANSITION_DEST_FALL_INTO_HOLLYS_HOUSE
; Only used in Seasons.
warpTransition7:
	ld e,<w1Link.warpVar1
	ld a,(de)
	rst_jumpTable
	.dw @warpVar0
	.dw @warpVar1
	.dw @warpVar2
	.dw @warpVar3

@warpVar0:
	ld a,$01
	ld (de),a

	ld h,d
	ld l,<w1Link.direction
	ld (hl),DIR_DOWN
	inc l
	ld (hl),$10
	ld l,<w1Link.speed
	ld (hl),SPEED_100

	ld l,<w1Link.visible
	res 7,(hl)

	ld l,<w1Link.warpVar2
	ld (hl),120

	ld a,LINK_ANIM_MODE_FALL
	call specialObjectSetAnimation

	ld a,SND_LINK_FALL
	jp playSound

@warpVar1:
	call itemDecCounter1
	ret nz

	ld l,<w1Link.warpVar1
	inc (hl)
	ld l,<w1Link.visible
	set 7,(hl)
	ld l,<w1Link.warpVar2
	ld (hl),$30
	ld a,$10
	call setScreenShakeCounter
	ld a,SND_SCENT_SEED
	jp playSound

;;
@warpVar2:
	call specialObjectAnimate
	call itemDecCounter1
	jp nz,specialObjectUpdatePosition
;;
@linkCollapsed:
	call itemIncSubstate
	ld l,<w1Link.warpVar2
	ld (hl),$1e
	ld a,LINK_ANIM_MODE_COLLAPSED
	call specialObjectSetAnimation
	ld a,SND_SPLASH
	jp playSound

;;
@warpVar3:
	call setDeathRespawnPoint

warpTransition5_02:
	call itemDecCounter1
	ret nz
	jp initLinkStateAndAnimateStanding

;;
linkIncrementDirectionOnOddFrames:
	ld a,(wFrameCounter)
	rrca
	ret nc

;;
linkIncrementDirection:
	ld e,<w1Link.direction
	ld a,(de)
	inc a
	and $03
	ld (de),a
	ret

;;
; TRANSITION_SRC_SUBROSIA
; A subrosian warp portal.
warpTransition8:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7

@substate0:
	ld a,$01
	ld (de),a
	ld a,$ff
	ld (wDisabledObjects),a
	ld a,$80
	ld (wMenuDisabled),a
	ld a,CUTSCENE_S_15
	ld (wCutsceneTrigger),a

	ld bc,$ff60
	call objectSetSpeedZ

	ld l,SpecialObject.counter1
	ld (hl),$30

	call linkCancelAllItemUsage
	call restartSound

	ld a,SND_FADEOUT
	call playSound
	jp objectCenterOnTile

@substate1:
	ld c,$02
	call objectUpdateSpeedZ_paramC
	ld a,(wFrameCounter)
	and $03
	jr nz,+
	ld hl,wTmpcbbc
	inc (hl)
+
	ld a,(wFrameCounter)
	and $03
	call z,linkIncrementDirection
	call itemDecCounter1
	ret nz
	jp itemIncSubstate

@substate2:
	ld c,$02
	call objectUpdateSpeedZ_paramC
	call linkIncrementDirectionOnOddFrames

	ld h,d
	ld l,SpecialObject.speedZ+1
	bit 7,(hl)
	ret nz

	ld l,SpecialObject.counter1
	ld (hl),$28

	ld a,$02
	call fadeoutToWhiteWithDelay

	jp itemIncSubstate

@substate3:
	call linkIncrementDirectionOnOddFrames
	call itemDecCounter1
	ret nz
	ld hl,wTmpcbb3
	inc (hl)
	jp itemIncSubstate

@substate4:
	call linkIncrementDirectionOnOddFrames
	ld a,(wCutsceneState)
	cp $02
	ret nz
	call itemIncSubstate
	ld l,SpecialObject.counter1
	ld (hl),$28
	ret

@substate5:
	ld c,$02
	call objectUpdateSpeedZ_paramC
	call linkIncrementDirectionOnOddFrames
	call itemDecCounter1
	ret nz
	jp itemIncSubstate

@substate6:
	ld c,$02
	call objectUpdateSpeedZ_paramC
	ld a,(wFrameCounter)
	and $03
	ret nz

	call linkIncrementDirection
	ld hl,wTmpcbbc
	dec (hl)
	ret nz

	ld hl,wTmpcbb3
	inc (hl)
	jp itemIncSubstate

@substate7:
	ld a,(wDisabledObjects)
	and $81
	jr z,+

	ld a,(wFrameCounter)
	and $07
	ret nz
	jp linkIncrementDirection
+
	ld e,SpecialObject.direction
	ld a,(de)
	cp $02
	jp nz,linkIncrementDirection
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	call setDeathRespawnPoint
	call updateLinkLocalRespawnPosition
	call resetLinkInvincibility
	jp initLinkStateAndAnimateStanding

;;
; TRANSITION_SRC_FALL
; Fall out of the screen (like into a hole).
warpTransition9:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	call itemIncSubstate

	ld l,SpecialObject.yh
	ld a,$08
	add (hl)
	ld (hl),a

	call objectCenterOnTile
	call clearAllParentItems

	ld a,LINK_ANIM_MODE_FALLINHOLE
	call specialObjectSetAnimation

	ld a,SND_LINK_FALL
	jp playSound

@substate1:
	ld e,SpecialObject.animParameter
	ld a,(de)
	inc a
	jp nz,specialObjectAnimate

	ld a,$03
	ld (wWarpTransition2),a
	ret

;;
; TRANSITION_DEST_SLOWFALL
; Transition used in the beginning of the game. Updates respawn point.
warpTransitionB:
	ld e,<w1Link.warpVar1
	ld a,(de)
	rst_jumpTable
	.dw @warpVar0
	.dw @warpVar1
	.dw @warpVar2

@warpVar0:
	call itemIncSubstate

	call objectGetZAboveScreen
	ld l,<w1Link.zh
	ld (hl),a

	ld l,<w1Link.direction
	ld (hl),DIR_DOWN

	ld a,LINK_ANIM_MODE_FALL
	jp specialObjectSetAnimation

@warpVar1:
	call specialObjectAnimate
	ld c,$0c
	call objectUpdateSpeedZ_paramC
	ret nz

	; Done falling. Set Link's initial state depending on the game.

.ifdef ROM_AGES
	call itemIncSubstate
	call animateLinkStanding
	ld a,SND_SPLASH
	jp playSound
.else
	xor a
	ld (wDisabledObjects),a
	ld a,SPECIALOBJECT_LINK_CUTSCENE
	call setLinkIDOverride
	ld l,SpecialObject.subid
	ld (hl),$02
	ret
.endif

@warpVar2:
	ld a,(wDisabledObjects)
	and $81
	ret nz

	call objectSetVisiblec2
	jp initLinkStateAndAnimateStanding


;;
; TRANSITION_DEST_INVISIBLE
; Link does not appear.
warpTransitionF:
	call checkLinkForceState
	jp objectSetInvisible


.ifdef ROM_AGES

;;
; TRANSITION_DEST_TIMEWARP
; Warp in and create a portal. Doesn't update respawn. Ages only.
warpTransition6:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7

;;
@flickerVisibilityAndDecCounter1:
	ld b,$03
	call objectFlickerVisibility
	jp itemDecCounter1

;;
@createDestinationTimewarpAnimation:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_TIMEWARP
	inc l
	inc (hl)

	; [Interaction.var03] = [wcc50]
	ld a,(wcc50)
	inc l
	ld (hl),a
	ret

;;
; This function should center Link if it detects that he's warped into a 2-tile-wide
; doorway.
; Except, it doesn't work. There's a typo.
@centerLinkOnDoorway:
	call objectGetTileAtPosition
	push hl

	; BUG: This should be "ld e,a" instead of "ld a,e".
	ld a,e

	ld hl,@doorTiles
	call findByteAtHl
	pop hl
	ret nc

	push hl
	dec l
	ld e,(hl)
	ld hl,@doorTiles
	call findByteAtHl
	pop hl
	jr nc,+

	ld e,SpecialObject.xh
	ld a,(de)
	and $f0
	ld (de),a
	ret
+
	inc l
	ld e,(hl)
	ld hl,@doorTiles
	call findByteAtHl
	ret nc

	ld e,SpecialObject.xh
	ld a,(de)
	add $08
	ld (de),a
	ld hl,wEnteredWarpPosition
	inc (hl)
	ret

; List of tile indices that are "door tiles" which initiate warps.
@doorTiles:
	.db $dc $dd $de $df $ed $ee $ef
	.db $00


; Initialization
@substate0:
	call itemIncSubstate

	ld l,SpecialObject.counter1
	ld (hl),$1e
	ld l,SpecialObject.direction
	ld (hl),DIR_DOWN

	ld a,d
	ld (wLinkCanPassNpcs),a
	ld (wMenuDisabled),a

	call @centerLinkOnDoorway
	jp objectSetInvisible


; Waiting for palette to fade in and counter1 to reach 0
@substate1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call itemDecCounter1
	ret nz

; Create the timewarp animation, and go to substate 4 if Link is obstructed from warping
; in, otherwise go to substate 2.

	ld (hl),$10
	call @createDestinationTimewarpAnimation

	ld a,(wSentBackByStrangeForce)
	dec a
	jr z,@warpFailed

	callab bank1.checkLinkCanStandOnTile
	srl c
	jr c,@warpFailed

	callab bank1.checkSolidObjectAtWarpDestPos
	srl c
	jr c,@warpFailed

	jp itemIncSubstate

	; Link will be returned to the time he came from.
@warpFailed:
	ld e,SpecialObject.substate
	ld a,$04
	ld (de),a
	ret


; Waiting several frames before making Link visible and playing the sound effect
@substate2:
	call itemDecCounter1
	ret nz

	ld (hl),$1e

@makeLinkVisibleAndPlaySound:
	ld a,SND_TIMEWARP_COMPLETED
	call playSound
	call objectSetVisiblec0
	jp itemIncSubstate


@substate3:
	call @flickerVisibilityAndDecCounter1
	ret nz

; Warp is completed; create a time portal if necessary, restore control to Link

	; Check if a time portal should be created
	ld a,(wLinkTimeWarpTile)
	or a
	jr nz,++

	; Create a time portal
	ld hl,wPortalGroup
	ld a,(wActiveGroup)
	ldi (hl),a
	ld a,(wActiveRoom)
	ldi (hl),a
	ld a,(wWarpDestPos)
	ld (hl),a
	ld c,a
	call getFreeInteractionSlot
	jr nz,++

	ld (hl),INTERAC_TIMEPORTAL
	ld l,Interaction.yh
	call setShortPosition_paramC
++
	; Check whether to show the "Sent back by strange force" text.
	ld a,(wSentBackByStrangeForce)
	or a
	jr z,+
	ld bc,TX_5112
	call showText
+
	; Restore everything to normal, give control back to Link.
	xor a
	ld (wLinkTimeWarpTile),a
	ld (wWarpTransition),a
	ld (wLinkCanPassNpcs),a
	ld (wMenuDisabled),a
	ld (wSentBackByStrangeForce),a
	ld (wcddf),a
	ld (wcde0),a

	ld e,SpecialObject.invincibilityCounter
	ld a,$88
	ld (de),a

	call updateLinkLocalRespawnPosition
	call objectSetVisiblec2
	jp initLinkStateAndAnimateStanding


; Substates 4-7: Warp failed, Link will be sent back to the time he came from

@substate4:
	call itemDecCounter1
	ret nz

	ld (hl),$78
	jr @makeLinkVisibleAndPlaySound

@substate5:
	call @flickerVisibilityAndDecCounter1
	ret nz

	ld (hl),$10
	call @createDestinationTimewarpAnimation
	jp itemIncSubstate

@substate6:
	call @flickerVisibilityAndDecCounter1
	ret nz

	ld (hl),$14
	call objectSetInvisible
	jp itemIncSubstate

@substate7:
	call itemDecCounter1
	ret nz

; Initiate another warp sending Link back to the time he came from

	call objectGetTileAtPosition
	ld c,l

	ld hl,wWarpDestGroup
	ld a,(wActiveGroup)
	xor $01
	or $80
	ldi (hl),a

	; wWarpDestRoom
	ld a,(wActiveRoom)
	ldi (hl),a

	; wWarpTransition
	ld a,TRANSITION_DEST_TIMEWARP
	ldi (hl),a

	; wWarpDestPos
	ld a,c
	ldi (hl),a

	inc a
	ld (wLinkTimeWarpTile),a
	ld (wcddf),a

	; wWarpTransition2
	ld a,$03
	ld (hl),a

	xor a
	ld (wScrollMode),a

	ld hl,wSentBackByStrangeForce
	ld a,(hl)
	or a
	jr z,+
	inc (hl)
+
	ld a,(wLinkStateParameter)
	bit 4,a
	jr nz,+
	call getThisRoomFlags
	res 4,(hl)
+
	ld a,SND_TIMEWARP_COMPLETED
	call playSound

	ld de,w1Link
	jp objectDelete_de
.endif

;;
; LINK_STATE_08
linkState08:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	; Go to substate 1
	ld a,$01
	ld (de),a

	ld hl,wcc50
	ld a,(hl)
	ld (hl),$00
	or a
	ret nz

	call linkCancelAllItemUsageAndClearAdjacentWallsBitset
	ld a,LINK_ANIM_MODE_WALK
	jp specialObjectSetAnimation

@substate1:
	call checkLinkForceState

	ld hl,wcc50
	ld a,(hl)
	or a
	jr z,+
	ld (hl),$00
	call specialObjectSetAnimation
+
	ld a,(wcc63)
	or a
	call nz,checkUseItems

	ld a,(wDisabledObjects)
	or a
	ret nz

	jp initLinkStateAndAnimateStanding

;;
linkCancelAllItemUsageAndClearAdjacentWallsBitset:
	ld e,SpecialObject.adjacentWallsBitset
	xor a
	ld (de),a
;;
; Drop any held items, cancels usage of sword, etc?
linkCancelAllItemUsage:
	call dropLinkHeldItem
	jp clearAllParentItems

;;
; LINK_STATE_0e
linkState0e:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call itemIncSubstate
	ld e,SpecialObject.var37
	ld a,(wActiveRoom)
	ld (de),a

@substate1:
	call objectCheckWithinScreenBoundary
	ret c
	call itemIncSubstate
	call objectSetInvisible

@substate2:
	ld h,d
	ld l,SpecialObject.var37
	ld a,(wActiveRoom)
	cp (hl)
	ret nz

	call objectCheckWithinScreenBoundary
	ret nc

	ld e,SpecialObject.substate
	ld a,$01
	ld (de),a
	jp objectSetVisiblec2

.ifdef ROM_AGES
;;
; LINK_STATE_TOSSED_BY_GUARDS
linkState0f:
	ld a,(wTextIsActive)
	or a
	ret nz

	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call itemIncSubstate

	; [SpecialObject.counter1] = $14
	inc l
	ld (hl),$14

	ld l,SpecialObject.angle
	ld (hl),$10
	ld l,SpecialObject.yh
	ld (hl),$38
	ld l,SpecialObject.xh
	ld (hl),$50
	ld l,SpecialObject.speed
	ld (hl),SPEED_100

	ld l,SpecialObject.speedZ
	ld a,$80
	ldi (hl),a
	ld (hl),$fe

	ld a,LINK_ANIM_MODE_COLLAPSED
	call specialObjectSetAnimation

	jp objectSetVisiblec2

@substate1:
	call objectApplySpeed

	ld c,$20
	call objectUpdateSpeedZAndBounce
	ret nc ; Return if Link can still bounce

	jp itemIncSubstate

@substate2:
	call itemDecCounter1
	ret nz
	jp initLinkStateAndAnimateStanding
.endif

;;
; LINK_STATE_FORCE_MOVEMENT
linkState0b:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld a,$01
	ld (de),a

	ld e,SpecialObject.counter1
	ld a,(wLinkStateParameter)
	ld (de),a

	call clearPegasusSeedCounter
	call linkCancelAllItemUsageAndClearAdjacentWallsBitset
	call updateLinkSpeed_standard

	ld a,LINK_ANIM_MODE_WALK
	call specialObjectSetAnimation

@substate1:
	call specialObjectAnimate
	call itemDecCounter1
	ld l,SpecialObject.adjacentWallsBitset
	ld (hl),$00
	jp nz,specialObjectUpdatePosition

	; When counter1 reaches 0, go back to LINK_STATE_NORMAL.
	jp initLinkStateAndAnimateStanding


;;
; LINK_STATE_04
linkState04:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	; Go to substate 1
	ld a,$01
	ld (de),a

	call linkCancelAllItemUsage

	ld e,SpecialObject.animMode
	ld a,(de)
	ld (wcc52),a

	ld a,(wcc50)
	and $0f
	add $0e
	jp specialObjectSetAnimation

@substate1:
	call retIfTextIsActive
	ld a,(wcc50)
	rlca
	jr c,+

	ld a,(wDisabledObjects)
	and $81
	ret nz
+
	ld e,SpecialObject.state
	ld a,LINK_STATE_NORMAL
	ld (de),a
	ld a,(wcc52)
	jp specialObjectSetAnimation

;;
setLinkStateToDead:
	ld a,LINK_STATE_DYING
	call linkSetState
;;
; LINK_STATE_DYING
linkState03:
	xor a
	ld (wLinkHealth),a
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

; Link just started dying (initialization)
@substate0:
	call specialObjectUpdateAdjacentWallsBitset

	ld e,SpecialObject.knockbackCounter
	ld a,(de)
	or a
	jp nz,linkUpdateKnockback

	ld h,d
	ld l,SpecialObject.substate
	inc (hl)

	ld l,SpecialObject.counter1
	ld (hl),$04

	call linkCancelAllItemUsage

	ld a,LINK_ANIM_MODE_SPIN
	call specialObjectSetAnimation
	ld a,SND_LINK_DEAD
	jp playSound

; Link is in the process of dying (spinning around)
@substate1:
	call resetLinkInvincibility
	call specialObjectAnimate

	ld h,d
	ld l,SpecialObject.animParameter
	ld a,(hl)
	add a
	jr nz,@triggerGameOver
	ret nc

; When animParameter is $80 or above, change link's animation to "unconscious"
	ld l,SpecialObject.counter1
	dec (hl)
	ret nz
	ld a,LINK_ANIM_MODE_COLLAPSED
	jp specialObjectSetAnimation

@triggerGameOver:
	ld a,$ff
	ld (wGameOverScreenTrigger),a
	ret

;;
; LINK_STATE_RESPAWNING
;
; This state behaves differently depending on wLinkStateParameter:
;  0: Fall down a hole
;  1: Fall down a hole without centering Link on the tile
;  2: Respawn instantly
;  3: Fall down a hole, different behaviour?
;  4: Drown
linkState02:
	ld a,$ff
	ld (wGameKeysPressed),a

	; Disable the push animation
	ld a,$80
	ld (wForceLinkPushAnimation),a

	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

; Initialization
@substate0:
	call linkCancelAllItemUsage

	ld a,(wLinkStateParameter)
	rst_jumpTable
	.dw @parameter_fallDownHole
	.dw @parameter_fallDownHoleWithoutCentering
	.dw @respawn
	.dw @parameter_3
	.dw @parameter_drown

@parameter_drown:
	ld e,SpecialObject.substate
	ld a,$05
	ld (de),a
	ld a,LINK_ANIM_MODE_DROWN
	jp specialObjectSetAnimation

@parameter_fallDownHole:
	call objectCenterOnTile

@parameter_fallDownHoleWithoutCentering:
	call itemIncSubstate
	jr ++

@parameter_3:
	ld e,SpecialObject.substate
	ld a,$04
	ld (de),a
++
	; Disable collisions
	ld h,d
	ld l,SpecialObject.collisionType
	res 7,(hl)

	; Do the "fall in hole" animation
	ld a,LINK_ANIM_MODE_FALLINHOLE
	call specialObjectSetAnimation
	ld a,SND_LINK_FALL
	jp playSound


; Doing a "falling down hole" animation, waiting for it to finish
@substate1:
	; Wait for the animation to finish
	ld h,d
	ld l,SpecialObject.animParameter
	bit 7,(hl)
	jp z,specialObjectAnimate

	ld a,(wActiveTileType)
	cp TILETYPE_WARPHOLE
	jr nz,@respawn

.ifdef ROM_AGES
	; Check if the current room is the moblin keep with the crumbling floors
	ld a,(wActiveGroup)
	cp >ROOM_AGES_29f
	jr nz,+
	ld a,(wActiveRoom)
	cp <ROOM_AGES_29f
	jr nz,+

	jpab bank1.warpToMoblinKeepUnderground
+
.else
	; start CUTSCENE_S_ONOX_FINAL_FORM
	ld a,(wDungeonIndex)
	cp $09
	jr nz,+
	ld a,CUTSCENE_S_ONOX_FINAL_FORM
	ld (wCutsceneTrigger),a
	ret
+
.endif
	; This function call will only work in dungeons.
	jpab bank1.initiateFallDownHoleWarp

@respawn:
	call specialObjectSetCoordinatesToRespawnYX
	ld l,SpecialObject.substate
	ld a,$02
	ldi (hl),a

	; [SpecialObject.counter1] = $02
	ld (hl),a

	call specialObjectTryToBreakTile_source05

	; Set wEnteredWarpPosition, which prevents Link from instantly activating a warp
	; tile if he respawns on one.
	call objectGetTileAtPosition
	ld a,l
	ld (wEnteredWarpPosition),a

	jp objectSetInvisible


; Waiting for counter1 to reach 0 before having Link reappear.
@substate2:
	ld h,d
	ld l,SpecialObject.counter1

	; Check if the screen is scrolling?
	ld a,(wScrollMode)
	and $80
	jr z,+
	ld (hl),$04
	ret
+
	dec (hl)
	ret nz

	; Counter has reached 0; make Link reappear, apply damage

	xor a
	ld (wLinkInAir),a
	ld (wLinkSwimmingState),a

	ld a,GOLD_LUCK_RING
	call cpActiveRing
	ld a,$fc
	jr nz,+
	sra a
+
	call itemIncSubstate

	ld l,SpecialObject.damageToApply
	ld (hl),a
	ld l,SpecialObject.invincibilityCounter
	ld (hl),$3c

	ld l,SpecialObject.counter1
	ld (hl),$10

	call linkApplyDamage
	call objectSetVisiblec1
	call specialObjectUpdateAdjacentWallsBitset
	jp animateLinkStanding


; Waiting for counter1 to reach 0 before switching back to LINK_STATE_NORMAL.
@substate3:
	call itemDecCounter1
	ret nz

	; Enable collisions
	ld l,SpecialObject.collisionType
	set 7,(hl)

	jp initLinkStateAndAnimateStanding


@substate4:
	ld h,d
	ld l,SpecialObject.animParameter
	bit 7,(hl)
	jp z,specialObjectAnimate
	call objectSetInvisible
	jp checkLinkForceState


; Drowning instead of falling into a hole
@substate5:
	ld e,SpecialObject.animParameter
	ld a,(de)
	rlca
	jp nc,specialObjectAnimate
	jr @respawn

.ifdef ROM_AGES
;;
; Makes Link surface from an underwater area if he's pressed B.
checkForUnderwaterTransition:
	ld a,(wDisableScreenTransitions)
	or a
	ret nz
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	ret z
	ld a,(wGameKeysJustPressed)
	and BTN_B
	ret z

	ld a,(wActiveTilePos)
	ld l,a
	ld h,>wRoomLayout
	ld a,(hl)
	ld hl,tileTypesTable
	call lookupCollisionTable

	; Don't allow surfacing on whirlpools
	cp TILETYPE_WHIRLPOOL
	ret z

	; Move down instead of up when over a "warp hole" (only used in jabu-jabu?)
	cp TILETYPE_WARPHOLE
	jr z,@levelDown

	; Return if Link can't surface here
	call checkLinkCanSurface
	ret nc

	; Return from the caller (linkState01)
	pop af

	ld a,(wTilesetFlags)
	and TILESETFLAG_DUNGEON
	jr nz,@dungeon

	; Not in a dungeon

	; Set 'c' to the value to add to wActiveGroup.
	; Set 'a' to the room index to end up in.
	ld c,$fe
	ld a,(wActiveRoom)
	jr @initializeWarp

@dungeon:
	; Increment the floor you're on, get the new room index
	ld a,(wDungeonFloor)
	inc a
	ld (wDungeonFloor),a
	call getActiveRoomFromDungeonMapPosition
	ld c,$00
	jr @initializeWarp

	; Go down a level instead of up one
@levelDown:
	; Return from caller
	pop af

	ld a,(wTilesetFlags)
	and TILESETFLAG_DUNGEON
	jr nz,+

	; Not in a dungeon: add 2 to wActiveGroup.
	ld c,$02
	ld a,(wActiveRoom)
	jr @initializeWarp
+
	; In a dungeon: decrement the floor you're on, get the new room index
	ld a,(wDungeonFloor)
	dec a
	ld (wDungeonFloor),a
	call getActiveRoomFromDungeonMapPosition
	ld c,$00
	jr @initializeWarp

@initializeWarp:
	ld (wWarpDestRoom),a

	ld a,(wActiveGroup)
	add c
	or $80
	ld (wWarpDestGroup),a

	ld a,(wActiveTilePos)
	ld (wWarpDestPos),a

	ld a,$00
	ld (wWarpTransition),a

	ld a,$03
	ld (wWarpTransition2),a
	ret
.endif

.ifdef ROM_SEASONS
; Bouncing from trampoline, hitting the ceiling,
; or setting warp to floor above
linkState09:
	call retIfTextIsActive
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

@substate0:
	call clearAllParentItems
	xor a
	ld (wScrollMode),a
	ld (wUsingShield),a
	ld bc,-$400
	call objectSetSpeedZ
	ld l,SpecialObject.counter1
	ld (hl),$0a
	ld a,(wcc50)
	rrca
	ld a,$01
	jr nc,+
	inc a
+
	ld l,SpecialObject.substate
	ld (hl),a
	ld a,$81
	ld (wLinkInAir),a
	ret

@substate1:
	call @seasonsFunc_05_5043
	ret c
	ld a,(wDungeonFloor)
	inc a
	ld (wDungeonFloor),a
	call getActiveRoomFromDungeonMapPosition
	ld (wWarpDestRoom),a
	call objectGetShortPosition
	ld (wWarpDestPos),a
	ld a,(wActiveGroup)
	or $80
	ld (wWarpDestGroup),a
	ld a,$06
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a
	ret
@substate2:
	call @seasonsFunc_05_5043
	ret c
	ld a,$01
	ld (wScrollMode),a
	ld l,SpecialObject.substate
	inc (hl)
	ld l,SpecialObject.counter1
	ld (hl),$1e
	ld a,$08
	call setScreenShakeCounter
	ld a,LINK_ANIM_MODE_COLLAPSED
	jp specialObjectSetAnimation

@seasonsFunc_05_5043:
	ld c,$0c
	call objectUpdateSpeedZ_paramC
	call specialObjectAnimate
	ld h,d
	ld l,SpecialObject.counter1
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	jr nz,+
	ld a,LINK_ANIM_MODE_FALL
	call specialObjectSetAnimation
+
	call objectGetZAboveScreen
	ld h,d
	ld l,SpecialObject.zh
	cp (hl)
	ret

@substate3:
	call itemDecCounter1
	ret nz
	dec l
	inc (hl)
	ld bc,-$100
	jp objectSetSpeedZ

@substate4:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call objectGetTileAtPosition
	cp $07
	jr z,bounceLinkOffTrampolineAfterFalling
	ld h,d
	ld l,SpecialObject.substate
	inc (hl)
	; SpecialObject.counter1
	inc l
	ld (hl),$1e
	ld a,LINK_ANIM_MODE_COLLAPSED
	call specialObjectSetAnimation

@substate5:
	call itemDecCounter1
	ret nz
-
	xor a
	ld (wLinkInAir),a
	jp initLinkStateAndAnimateStanding

@substate6:
	call specialObjectAnimate
	call specialObjectUpdateAdjacentWallsBitset
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,specialObjectUpdatePosition
	call updateLinkLocalRespawnPosition
	jr -

bounceLinkOffTrampolineAfterFalling:
	call objectGetShortPosition
	ld c,a
	ld b,$02
-
	ld a,b
	ld hl,@offsets
	rst_addAToHl
	ld a,c
	add (hl)
	ld h,>wRoomCollisions
	ld l,a
	ld a,(hl)
	or a
	jr z,+
	ld a,b
	inc a
	and $03
	ld b,a
	jr -
+
	ld h,d
	ld l,SpecialObject.direction
	ld (hl),b
	ld a,b
	swap a
	rrca
	inc l
	ld (hl),a
	ld l,SpecialObject.zh
	ld (hl),$ff
	ld bc,-$300
	call objectSetSpeedZ
	ld l,SpecialObject.speed
	ld (hl),$14
	ld l,SpecialObject.state
	ld (hl),$09
	inc l
	ld (hl),$06
	ld a,LINK_ANIM_MODE_FALL
	jp specialObjectSetAnimation

@offsets:
	.db $f0 $01 $10 $ff
.endif

;;
; LINK_STATE_GRABBED_BY_WALLMASTER
linkState0c:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	; Go to substate 1
	ld a,$01
	ld (de),a

	ld (wWarpsDisabled),a

	xor a
	ld e,SpecialObject.collisionType
	ld (de),a

	ld a,$00
	ld (wScrollMode),a

	call linkCancelAllItemUsage

	ld a,SND_BOSS_DEAD
	jp playSound


; The wallmaster writes [w1Link.substate] = 2 when Link is fully dragged off-screen.
@substate2:
	xor a
	ld (wWarpsDisabled),a

	ld hl,wWarpDestGroup
	ld a,(wActiveGroup)
	or $80
	ldi (hl),a

	; wWarpDestRoom
	ld a,(wDungeonWallmasterDestRoom)
	ldi (hl),a

	; wWarpDestTransition
	ld a,TRANSITION_DEST_FALL
	ldi (hl),a

	; wWarpDestPos
	ld a,$87
	ldi (hl),a

	; wWarpDestTransition2
	ld (hl),$03

; Substate 1: waiting for the wallmaster to increment w1Link.substate.
@substate1:
	ret

;;
; LINK_STATE_STONE
; Only used in Seasons for the Medusa boss
linkState13:
	ld a,$80
	ld (wForceLinkPushAnimation),a

	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	call itemIncSubstate

	; [SpecialObject.counter1] = $b4
	inc l
	ld (hl),$b4

	ld l,SpecialObject.oamFlagsBackup
	ld a,$0f
	ldi (hl),a
	ld (hl),a

	ld a,PALH_SPR_LINK_STONE
	call loadPaletteHeader

	xor a
	ld (wcc50),a
	ret


; This is used by both linkState13 and linkState14.
; Waits for counter1 to reach 0, then restores Link to normal.
@substate1:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ld a,(wcc50)
	or a
	jr z,+

	call updateLinkDirectionFromAngle

	ld l,SpecialObject.var2a
	ld a,(hl)
	or a
	jr nz,@restoreToNormal
+
	; Restore Link to normal more quickly when pressing any button.
	ld c,$01
	ld a,(wGameKeysJustPressed)
	or a
	jr z,+
	ld c,$04
+
	ld l,SpecialObject.counter1
	ld a,(hl)
	sub c
	ld (hl),a
	ret nc

@restoreToNormal:
	ld l,SpecialObject.oamFlagsBackup
	ld a,$08
	ldi (hl),a
	ld (hl),a

	ld l,SpecialObject.knockbackCounter
	ld (hl),$00

	xor a
	ld (wLinkForceState),a
	jp initLinkStateAndAnimateStanding

;;
; LINK_STATE_COLLAPSED
linkState14:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw linkState13@substate1

@substate0:
	call itemIncSubstate

	ld l,SpecialObject.counter1
	ld (hl),$f0
	call linkCancelAllItemUsage

	ld a,(wcc50)
	or a
	ld a,LINK_ANIM_MODE_COLLAPSED
	jr z,+
	ld a,LINK_ANIM_MODE_WALK
+
	jp specialObjectSetAnimation

;;
; LINK_STATE_GRABBED
; Grabbed by Like-like, Gohma, Veran spider form?
linkState0d:
	ld a,$80
	ld (wcc92),a
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw updateLinkDamageTaken
	.dw @substate2
	.dw @substate3
	.dw @substate4

; Initialization
@substate0:
	ld a,$01
	ld (de),a
	ld (wWarpsDisabled),a

	ld e,SpecialObject.animMode
	xor a
	ld (de),a

	jp linkCancelAllItemUsage

; Link has been released, now he's about to fly downwards
@substate2:
	ld a,$03
	ld (de),a

	ld h,d
	ld l,SpecialObject.counter1
	ld (hl),$1e

.ifdef ROM_AGES
	ld l,SpecialObject.speedZ
	ld a,$20
	ldi (hl),a
	ld (hl),$fe

	; Face up
	ld l,SpecialObject.direction
	xor a
	ldi (hl),a

	; [SpecialObject.angle] = $10 (move down)
	ld (hl),$10
.else
	ld a,$e8
	ld l,SpecialObject.zh
	ld (hl),a
	ld l,SpecialObject.yh
	cpl
	inc a
	add (hl)
	ld (hl),a
	xor a
	ld l,SpecialObject.speedZ
	ldi (hl),a
	ldi (hl),a
	ld l,SpecialObject.direction
	ldi (hl),a
	; angle
	ld (hl),$0c
.endif

	ld l,SpecialObject.speed
	ld (hl),SPEED_180
	ld a,LINK_ANIM_MODE_GALE
	jp specialObjectSetAnimation

; Continue moving downwards until counter1 reaches 0
@substate3:
	call itemDecCounter1
	jr z,++

	ld c,$20
	call objectUpdateSpeedZ_paramC
	call specialObjectUpdateAdjacentWallsBitset
	call specialObjectUpdatePosition
	jp specialObjectAnimate


; Link is released without anything special.
; ENEMY_LIKE_LIKE sends Link to this state directly upon release.
@substate4:
	ld h,d
	ld l,SpecialObject.invincibilityCounter
	ld (hl),$94
++
	xor a
	ld (wWarpsDisabled),a
	jp initLinkStateAndAnimateStanding

;;
; LINK_STATE_SLEEPING
linkState05:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Just touched the bed
@substate0:
	call itemIncSubstate

	ld l,SpecialObject.speed
	ld (hl),SPEED_80

	; Set destination position (var37 / var38)
.ifdef ROM_AGES
	ld l,$18
.else
	ld l,$13
.endif
	ld a,$02
	call specialObjectSetVar37AndVar38

	ld bc,-$180
	call objectSetSpeedZ

	ld a,$81
	ld (wLinkInAir),a

	ld a,LINK_ANIM_MODE_SLEEPING
	jp specialObjectSetAnimation

; Jumping into the bed
@substate1:
	call specialObjectAnimate
	call specialObjectSetAngleRelativeToVar38
	call objectApplySpeed

	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call itemIncSubstate
	jp specialObjectSetPositionToVar38IfSet

; Sleeping; do various things depending on "animParameter".
@substate2:
	call specialObjectAnimate
	ld h,d
	ld l,SpecialObject.animParameter
	ld a,(hl)
	ld (hl),$00
	rst_jumpTable
	.dw @animParameter0
	.dw @animParameter1
	.dw @animParameter2
	.dw @animParameter3
	.dw @animParameter4

@animParameter1:
	call darkenRoomLightly
	ld a,$06
	ld (wPaletteThread_updateRate),a
	ret

@animParameter2:
	ld hl,wLinkMaxHealth
	ldd a,(hl)
	ld (hl),a

@animParameter0:
	ret

@animParameter3:
	jp brightenRoom

@animParameter4:
	ld bc,-$180
	call objectSetSpeedZ

	ld l,SpecialObject.direction
.ifdef ROM_AGES
	ld (hl),DIR_LEFT
.else
	ld (hl),DIR_RIGHT
.endif

	; [SpecialObject.angle] = $18
	inc l
.ifdef ROM_AGES
	ld (hl),$18
.else
	ld (hl),$08
.endif

	ld l,SpecialObject.speed
	ld (hl),SPEED_80

	ld a,$81
	ld (wLinkInAir),a
	jp initLinkStateAndAnimateStanding

;;
; LINK_STATE_06
; Moves Link up until he's no longer in a solid wall?
linkState06:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	; Go to substate 1
	ld a,$01
	ld (de),a

	ld h,d
	ld l,SpecialObject.counter1
	ld (hl),$08
	ld l,SpecialObject.speed
	ld (hl),SPEED_200

	; Set angle to "up"
	ld l,SpecialObject.angle
	ld (hl),$00

	ld a,$81
	ld (wLinkInAir),a
	ld a,SND_JUMP
	call playSound

@substate1:
	call specialObjectUpdatePositionWithoutTileEdgeAdjust
	call itemDecCounter1
	ret nz

	; Go to substate 2
	ld l,SpecialObject.substate
	inc (hl)

	ld l,SpecialObject.direction
	ld (hl),$00
	ld a,LINK_ANIM_MODE_FALL
	call specialObjectSetAnimation

@substate2:
	call specialObjectAnimate
	ld a,(wScrollMode)
	and $01
	ret z

	call objectCheckTileCollision_allowHoles
	jp c,specialObjectUpdatePositionWithoutTileEdgeAdjust

	ld bc,-$200
	call objectSetSpeedZ

	; Go to substate 3
	ld l,SpecialObject.substate
	inc (hl)

	ld l,SpecialObject.speed
	ld (hl),SPEED_40
	ld a,LINK_ANIM_MODE_JUMP
	call specialObjectSetAnimation

@substate3:
	call specialObjectAnimate
	call specialObjectUpdateAdjacentWallsBitset
	call specialObjectUpdatePosition
	ld c,$18
	call objectUpdateSpeedZ_paramC
	ret nz

	xor a
	ld (wLinkInAir),a
	ld (wWarpsDisabled),a
	jp initLinkStateAndAnimateStanding

.ifdef ROM_AGES
;;
; LINK_STATE_AMBI_POSSESSED_CUTSCENE
; This state is used during the cutscene in the black tower where Ambi gets un-possessed.
linkState09:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5


; Initialization
@substate0:
	call itemIncSubstate

; Backing up to the right

	ld l,SpecialObject.speed
	ld (hl),SPEED_100
	ld l,SpecialObject.direction
	ld (hl),DIR_LEFT

	; [SpecialObject.angle] = $08
	inc l
	ld (hl),$08

	ld l,SpecialObject.counter1
	ld (hl),$0c

@substate1:
	call itemDecCounter1
	jr nz,@animate

; Moving back left

	ld (hl),$0c

	; Go to substate 2
	ld l,e
	inc (hl)

	ld l,SpecialObject.angle
	ld (hl),$18

@substate2:
	call itemDecCounter1
	jr nz,@animate

; Looking down

	ld (hl),$32

	; Go to substate 3
	ld l,e
	inc (hl)

	ld l,SpecialObject.direction
	ld (hl),DIR_DOWN

@substate3:
	call itemDecCounter1
	ret nz

; Looking up with an exclamation mark

	; Go to substate 4
	ld l,e
	inc (hl)

	ld l,SpecialObject.direction
	ld (hl),DIR_UP

	; [SpecialObject.angle] = $10
	inc l
	ld (hl),$10

	ld l,SpecialObject.counter1
	ld a,$1e
	ld (hl),a

	ld bc,$f4f8
	jp objectCreateExclamationMark

@substate4:
	call itemDecCounter1
	ret nz

; Jumping away

	; Go to substate 5
	ld l,e
	inc (hl)

	ld bc,-$180
	call objectSetSpeedZ

	ld a,LINK_ANIM_MODE_JUMP
	call specialObjectSetAnimation
	ld a,SND_JUMP
	jp playSound

@substate5:
	ld c,$18
	call objectUpdateSpeedZ_paramC
	jr nz,@animate

	; a is 0 at this point
	ld l,SpecialObject.substate
	ldd (hl),a
	ld (hl),SpecialObject.direction
	ret

@animate:
	call specialObjectAnimate
	jp specialObjectUpdatePositionWithoutTileEdgeAdjust

.else

linkState0f:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$10
	xor a
	ld l,SpecialObject.direction
	ldi (hl),a
	; SpecialObject.angle
	ld (hl),a
	call linkCancelAllItemUsageAndClearAdjacentWallsBitset
	ld a,$01
	ld (wDisableLinkCollisionsAndMenu),a
	ld a,LINK_ANIM_MODE_WALK
	call specialObjectSetAnimation

@substate1:
	call itemDecCounter1
	jr nz,@updateObject
	ld (hl),$5a
	; SpecialObject.substate
	dec l
	inc (hl)
	ld l,SpecialObject.speed
	ld (hl),$14
@updateObject:
	call specialObjectAnimate
	jp specialObjectUpdatePositionWithoutTileEdgeAdjust

@substate2:
	ld h,d
	ld l,SpecialObject.counter1
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret
+
	ld h,d
	ld l,SpecialObject.yh
	ld a,(hl)
	cp $74
	jr nc,@updateObject
	ld l,SpecialObject.substate
	inc (hl)
	inc l
	; SpecialObject.direction
	ld (hl),$60
	ld l,SpecialObject.speed
	ld (hl),$28

@substate3:
	call itemDecCounter1
	jr z,++
	ld a,(hl)
	sub $19
	jr c,+
	cp $32
	ret nc
	and $0f
	ret nz
	ld a,(hl)
	swap a
	and $01
	add a
	inc a
	ld l,SpecialObject.direction
	ld (hl),a
	ret
+
	inc a
	ret nz
	ld l,SpecialObject.direction
	ld (hl),$00
	; SpecialObject.angle
	inc l
	ld (hl),$10
	ld a,$18
	ld bc,$f4f8
	call objectCreateExclamationMark
	ld a,SND_CLINK
	jp playSound
++
	ld l,e
	inc (hl)
	ld bc,-$180
	call objectSetSpeedZ
	ld a,LINK_ANIM_MODE_JUMP
	call specialObjectSetAnimation
	ld a,SND_JUMP
	call playSound
@substate4:
	ld c,$18
	call objectUpdateSpeedZ_paramC
	jr nz,@updateObject
	ld l,SpecialObject.substate
	inc (hl)
	; SpecialObject.counter1
	inc l
	ld (hl),$f0
	ld a,LINK_ANIM_MODE_WALK
	call specialObjectSetAnimation
@substate5:
	ld a,(wFrameCounter)
	rrca
	ret nc
	call itemDecCounter1
	ret nz
	xor a
	ld (wDisableLinkCollisionsAndMenu),a
	jp initLinkStateAndAnimateStanding

linkState10:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01
	ld (de),a
	call linkCancelAllItemUsage
	call resetLinkInvincibility
	ld l,SpecialObject.speed
	ld (hl),$14
	ld l,SpecialObject.direction
	ld (hl),$00
	; SpecialObject.angle
	inc l
	ld (hl),DIR_UP
	jp animateLinkStanding

@substate1:
	call specialObjectAnimate
	ld h,d
	ld a,(wFrameCounter)
	and $07
	jr nz,+
	ld l,SpecialObject.speed
	ld a,(hl)
	sub $05
	jr z,+
	ld (hl),a
+
	ld a,($cbb3)
	cp $02
	jp nz,specialObjectUpdatePosition
	ld a,(wCutsceneState)
	dec a
	jp nz,initLinkStateAndAnimateStanding
	ld l,SpecialObject.substate
	inc (hl)
	; SpecialObject.counter1
	inc l
	ld (hl),$20
	ld l,SpecialObject.angle
	ld (hl),$10
	ld l,SpecialObject.speed
	ld (hl),$50

@substate2:
	call specialObjectAnimate
	call itemDecCounter1
	jp nz,specialObjectUpdatePosition
	ld hl,$cbb3
	inc (hl)
	ld a,$02
	call fadeoutToWhiteWithDelay
	jp initLinkStateAndAnimateStanding
.endif

;;
; LINK_STATE_SQUISHED
linkState11:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01
	ld (de),a

	call linkCancelAllItemUsage

	xor a
	ld e,SpecialObject.collisionType
	ld (de),a

	ld a,SND_DAMAGE_ENEMY
	call playSound

	; Check whether to do the horizontal or vertical squish animation
	ld a,(wcc50)
	and $7f
	ld a,LINK_ANIM_MODE_SQUISHX
	jr z,+
	inc a
+
	call specialObjectSetAnimation

@substate1:
	call specialObjectAnimate

	; Wait for the animation to finish
	ld e,SpecialObject.animParameter
	ld a,(de)
	inc a
	ret nz

	call itemIncSubstate
	ld l,SpecialObject.counter1
	ld (hl),$14

@substate2:
	call specialObjectAnimate

	; Invisible every other frame
	ld a,(wFrameCounter)
	rrca
	jp c,objectSetInvisible

	call objectSetVisible
	call itemDecCounter1
	ret nz

	ld a,(wcc50)
	bit 7,a
	jr nz,+

	call respawnLink
	jr checkLinkForceState
+
	ld a,LINK_STATE_DYING
	ld (wLinkForceState),a
	jr checkLinkForceState

;;
; Checks wLinkForceState, and sets Link's state to that value if it's nonzero.
; This also returns from the function that called it if his state changed.
checkLinkForceState:
	ld hl,wLinkForceState
	ld a,(hl)
	or a
	ret z

	ld (hl),$00
	pop hl

;;
; Sets w1Link.state to the given value, and w1Link.substate to $00.
; For some reason, this also runs the code for the state immediately if it's
; LINK_STATE_WARPING, LINK_STATE_GRABBED_BY_WALLMASTER, or LINK_STATE_GRABBED.
;
; @param	a	New value for w1Link.state
; @param	d	Link object
linkSetState:
	ld h,d
	ld l,SpecialObject.state
	ldi (hl),a
	ld (hl),$00
	cp LINK_STATE_WARPING
	jr z,+

	cp LINK_STATE_GRABBED_BY_WALLMASTER
	jr z,+

	cp LINK_STATE_GRABBED
	ret nz
+
	jp specialObjectCode_link

;;
; LINK_STATE_NORMAL
; LINK_STATE_10
linkState01:
.ifdef ROM_AGES
linkState10:
.endif
	; This should prevent Link from ever doing his pushing animation.
	; Under normal circumstances, this should be overwritten with $00 later, allowing
	; him to do his pushing animation when necessary.
	ld a,$80
	ld (wForceLinkPushAnimation),a

	; For some reason, Link can't do anything while the palette is changing
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wScrollMode)
	and $0e
	ret nz

	call updateLinkDamageTaken
	ld a,(wLinkDeathTrigger)
	or a
	jp nz,setLinkStateToDead

	; This will return if [wLinkForceState] != 0
	call checkLinkForceState

	call retIfTextIsActive

	ld a,(wDisabledObjects)
	and $81
	ret nz

	call decPegasusSeedCounter

	ld a,(w1Companion.id)
	cp SPECIALOBJECT_MINECART
	jr z,++
.ifdef ROM_AGES
	cp SPECIALOBJECT_RAFT
	jr z,++
.endif

	; Return if Link is riding an animal?
	ld a,(wLinkObjectIndex)
	rrca
	ret c

	ld a,(wLinkPlayingInstrument)
	ld b,a
	ld a,(wLinkInAir)
	or b
	jr nz,++

	ld e,SpecialObject.knockbackCounter
	ld a,(de)
	or a
	jr nz,++

	; Return if Link interacts with an object
	call linkInteractWithAButtonSensitiveObjects
	ret c

	; Deal with push blocks, chests, signs, etc. and return if he opened a chest, read
	; a sign, or opened an overworld keyhole?
	call interactWithTileBeforeLink
	ret c
++
	xor a
	ld (wForceLinkPushAnimation),a
	ld (wLinkPlayingInstrument),a

	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jp nz,linkState01_sidescroll

	; The rest of this code is only run in non-sidescrolling areas.

	; Apply stuff like breakable floors, holes, conveyors, etc.
	call linkApplyTileTypes

	; Let Link move around if a chest spawned on top of him
	call checkAndUpdateLinkOnChest

	; Check whether Link pressed A or B to use an item
	call checkUseItems

	ld a,(wLinkPlayingInstrument)
	or a
	ret nz

	call specialObjectUpdateAdjacentWallsBitset
	call linkUpdateKnockback

	; Jump if drowning
	ld a,(wLinkSwimmingState)
	and $40
	jr nz,++

	ld a,(wMagnetGloveState)
	bit 6,a
	jr nz,++

	ld a,(wLinkInAir)
	or a
	jr nz,++

	ld a,(wLinkGrabState)
	ld c,a
	ld a,(wLinkImmobilized)
	or c
	jr nz,++

	call checkLinkPushingAgainstBed
.ifdef ROM_SEASONS
	call checkLinkPushingAgainstTreeStump
.endif
	call checkLinkJumpingOffCliff
++
	call linkUpdateInAir
	ld a,(wLinkInAir)
	or a
	jr z,@notInAir

	; Link is in the air, either jumping or going down a ledge.

	bit 7,a
	jr nz,+

	ld e,SpecialObject.speedZ+1
	ld a,(de)
	bit 7,a
	call z,linkUpdateVelocity
+
	ld hl,wcc95
	res 4,(hl)
	call specialObjectSetAngleRelativeToVar38
	call specialObjectUpdatePosition
	jp specialObjectAnimate

@notInAir:
	ld a,(wMagnetGloveState)
	bit 6,a
	jp nz,animateLinkStanding

	ld e,SpecialObject.knockbackCounter
	ld a,(de)
	or a
	jp nz,func_5631

	ld h,d
	ld l,SpecialObject.collisionType
	set 7,(hl)

	ld a,(wLinkSwimmingState)
	or a
	jp nz,linkUpdateSwimming

	call objectSetVisiblec1
	ld a,(wLinkObjectIndex)
	rrca
.ifdef  ROM_AGES
	jr nc,+


	; This is odd. The "jr z" line below will never jump since 'a' will never be 0.
	; A "cp" opcode instead of "or" would make a lot more sense. Is this a typo?
	; The only difference this makes is that, when on a raft, Link can change
	; directions while swinging his sword / using other items.

	ld a,(w1Companion.id)
	or SPECIALOBJECT_RAFT
	jr z,@updateDirectionIfNotUsingItem
	jr @updateDirection
+
	; This will return if a transition occurs (pressed B in an underwater area).
	call checkForUnderwaterTransition
.else
	jr c,@updateDirection
.endif
	; Check whether Link is wearing a transformation ring or is a baby
	callab bank6.getTransformedLinkID
	ld a,b
	or a
	jp nz,setLinkIDOverride

.ifdef ROM_AGES
	; Handle movement

	; Check if Link is underwater?
	ld h,d
	ld l,SpecialObject.var2f
	bit 7,(hl)
	jr z,+

	; Do mermaid-suit-based movement
	call linkUpdateVelocity@mermaidSuit
	jr ++
+
.endif
	; Check if bits 0-3 of wLinkGrabState == 1 or 2.
	; (Link is grabbing or lifting something. This cancels ice physics.)
	ld a,(wLinkGrabState)
	and $0f
	dec a
	cp $02
	jr c,@normalMovement

	ld hl,wIsTileSlippery
	bit 6,(hl)
	jr z,@normalMovement

	; Slippery tile movement?
	ld c,$88
	call updateLinkSpeed_withParam
	call linkUpdateVelocity
++
	ld a,(wLinkAngle)
	rlca
	ld c,$02
	jr c,@updateMovement
	jr @walking

@normalMovement:
	ld a,(wcc95)
	ld b,a

	ld e,SpecialObject.angle
	ld a,(wLinkAngle)
	ld (de),a

	; Set cflag if in a spinner or wLinkAngle is set. (The latter case just means he
	; isn't moving.)
	or b
	rlca

	ld c,$00
	jr c,@updateMovement

	ld c,$01
	ld a,(wLinkImmobilized)
	or a
	jr nz,@updateMovement

	call updateLinkSpeed_standard

@walking:
	ld c,$07

@updateMovement:
	; The value of 'c' here determines whether Link should move, what his animation
	; should be, and whether the heart ring should apply. See the linkUpdateMovement
	; function for details.
	call linkUpdateMovement

@updateDirectionIfNotUsingItem:
	ld a,(wLinkTurningDisabled)
	or a
	ret nz

@updateDirection:
	jp updateLinkDirectionFromAngle

;;
linkResetSpeed:
	ld e,SpecialObject.speed
	xor a
	ld (de),a
	ret

;;
; Does something with Link's knockback when on a slippery tile?
func_5631:
	ld hl,wIsTileSlippery
	bit 6,(hl)
	ret z
	ld e,SpecialObject.knockbackAngle
	ld a,(de)
	ld e,SpecialObject.angle
	ld (de),a
	ret

;;
; Called once per frame that Link is moving.
;
; @param	a		Bits 0,1 set if Link's y,x offsets should be added to the
;				counter, respectively.
; @param	wTmpcec0	Offsets of Link's movement, to be added to wHeartRingCounter.
updateHeartRingCounter:
	ld e,a
	ld a,(wActiveRing)

	; b = number of steps (divided by $100, in pixels) until you get a heart refill.
	; c = number of quarter hearts to refill (times 4).

	ldbc $02,$08
	cp HEART_RING_L1
	jr z,@heartRingEquipped

	cp HEART_RING_L2
	jr nz,@clearCounter
	ldbc $03,$10

@heartRingEquipped:
	ld a,e
	or c
	ld c,a
	push de

	; Add Link's y position offset
	ld de,wTmpcec0+1
	ld hl,wHeartRingCounter
	srl c
	call c,@addOffsetsToCounter

	; Add Link's x position offset
	ld e,<wTmpcec0+3
	ld l,<wHeartRingCounter
	srl c
	call c,@addOffsetsToCounter

	; Check if the counter is high enough for a refill
	pop de
	ld a,(wHeartRingCounter+2)
	cp b
	ret c

	; Give hearts if health isn't full already
	ld hl,wLinkHealth
	ldi a,(hl)
	cp (hl)
	ld a,TREASURE_HEART_REFILL
	call c,giveTreasure

@clearCounter:
	ld hl,wHeartRingCounter
	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ret

;;
; Adds the position offsets at 'de' to the counter at 'hl'.
@addOffsetsToCounter:
	ld a,(de)
	dec e
	rlca
	jr nc,+

	; If moving in a negative direction, negate the offsets so they're positive again
	ld a,(de)
	cpl
	adc (hl)
	ldi (hl),a
	inc e
	ld a,(de)
	cpl
	jr ++
+
	ld a,(de)
	add (hl)
	ldi (hl),a
	inc e
	ld a,(de)
++
	adc (hl)
	ldi (hl),a
	ret nc
	inc (hl)
	ret

;;
; This is called from linkState01 if [wLinkSwimmingState] != 0.
; Only for non-sidescrolling areas. (See also linkUpdateSwimming_sidescroll.)
linkUpdateSwimming:
	ld a,(wLinkSwimmingState)
	and $0f

	ld hl,wcc95
	res 4,(hl)

	rst_jumpTable
	.dw initLinkState
	.dw overworldSwimmingState1
	.dw overworldSwimmingState2
	.dw overworldSwimmingState3
	.dw linkUpdateDrowning

;;
; Just entered the water
overworldSwimmingState1:
	call linkCancelAllItemUsage
	call linkSetSwimmingSpeed

.ifdef ROM_AGES
	; Set counter1 to the number of frames to stay in swimmingState2.
	; This is just a period of time during which Link's speed is locked immediately
	; after entering the water.
	ld l,SpecialObject.var2f
	bit 6,(hl)
.endif

	ld l,SpecialObject.counter1
	ld (hl),$0a

.ifdef ROM_AGES
	jr z,+
	ld (hl),$02
+
.endif

	ld a,(wLinkSwimmingState)
	bit 6,a
	jr nz,@drownWithLessInvincibility

.ifdef ROM_AGES
	call checkSwimmingOverSeawater
	jr z,@drown
.endif

	ld a,TREASURE_FLIPPERS
	call checkTreasureObtained
	ld b,LINK_ANIM_MODE_SWIM
	jr c,@splashAndSetAnimation

@drown:
	ld c,$88
	jr +

@drownWithLessInvincibility:
	ld c,$78
+
	ld a,LINK_STATE_RESPAWNING
	ld (wLinkForceState),a
	ld a,$04
	ld (wLinkStateParameter),a
	ld a,$80
	ld (wcc92),a

	ld h,d
	ld l,SpecialObject.invincibilityCounter
	ld (hl),c
	ld l,SpecialObject.collisionType
	res 7,(hl)

	ld a,SND_DAMAGE_LINK
	call playSound

	ld b,LINK_ANIM_MODE_DROWN

@splashAndSetAnimation:
	ld hl,wLinkSwimmingState
	ld a,(hl)
	and $f0
	or $02
	ld (hl),a
	ld a,b
	call specialObjectSetAnimation
	jp linkCreateSplash

;;
; This is called from linkUpdateSwimming_sidescroll.
forceDrownLink:
	ld hl,wLinkSwimmingState
	set 6,(hl)
	jr overworldSwimmingState1@drownWithLessInvincibility

.ifdef ROM_AGES
;;
; @param[out]	zflag	Set if swimming over seawater (and you have the mermaid suit)
checkSwimmingOverSeawater:
	ld a,(w1Link.var2f)
	bit 6,a
	ret nz
	ld a,(wActiveTileType)
	sub TILETYPE_SEAWATER
	ret
.endif

;;
; State 2: speed is locked for a few frames after entering the water
overworldSwimmingState2:
	call itemDecCounter1
	jp nz,specialObjectUpdatePosition

	ld hl,wLinkSwimmingState
	inc (hl)

;;
; State 3: the normal state when swimming
overworldSwimmingState3:
.ifdef ROM_AGES
	call checkSwimmingOverSeawater
	jr z,overworldSwimmingState1@drown
.endif

	call linkUpdateDiving

	; Set Link's visibility layer to normal
	call objectSetVisiblec1

	; Enable Link's collisions
	ld h,d
	ld l,SpecialObject.collisionType
	set 7,(hl)

	; Check if Link is diving
	ld a,(wLinkSwimmingState)
	rlca
	jr nc,+

	; If he's diving, disable Link's collisions
	res 7,(hl)
	; Draw him behind other sprites
	call objectSetVisiblec3
+
	call updateLinkDirectionFromAngle

.ifdef ROM_AGES
	; Check whether the flippers or the mermaid suit are in use
	ld h,d
	ld l,SpecialObject.var2f
	bit 6,(hl)
	jr z,+

	; Mermaid suit movement
	call linkUpdateVelocity@mermaidSuit
	jp specialObjectUpdatePosition
+
.endif
	; Flippers movement
	call linkUpdateFlippersSpeed
	call func_5933
	jp specialObjectUpdatePosition


;;
; Deals with Link drowning
linkUpdateDrowning:
	ld a,$80
	ld (wcc92),a

	call specialObjectAnimate

	ld h,d
	xor a
	ld l,SpecialObject.collisionType
	ld (hl),a

	ld l,SpecialObject.animParameter
	bit 7,(hl)
	ret z

	ld (wLinkSwimmingState),a

	; Set link's state to LINK_STATE_RESPAWNING; but, set
	; wLinkStateParameter to $02 to trigger only the respawning code, and not
	; anything else.
	ld a,$02
	ld (wLinkStateParameter),a
	ld a,LINK_STATE_RESPAWNING
	jp linkSetState

;;
; Sets Link's speed, speedTmp, var12, and var35 variables.
linkSetSwimmingSpeed:
	ld a,SWIMMERS_RING
	call cpActiveRing
	ld a,SPEED_e0
	jr z,+
	ld a,SPEED_80
+
	; Set speed, speedTmp to specified value
	ld h,d
	ld l,SpecialObject.speed
	ldi (hl),a
	ldi (hl),a

	; [SpecialObject.var12] = $03
	inc l
	ld a,$03
	ld (hl),a

	ld l,SpecialObject.var35
	ld (hl),$00
	ret

;;
; Sets the speedTmp variable in the same way as the above function, but doesn't touch any
; other variables.
linkSetSwimmingSpeedTmp:
	ld a,SWIMMERS_RING
	call cpActiveRing
	ld a,SPEED_e0
	jr z,+
	ld a,SPEED_80
+
	ld e,SpecialObject.speedTmp
	ld (de),a
	ret

;;
; @param[out]	a	The angle Link should move in?
linkUpdateFlippersSpeed:
	ld e,SpecialObject.var35
	ld a,(de)
	rst_jumpTable
	.dw @flippersState0
	.dw @flippersState1
	.dw @flippersState2

; Swimming with flippers; waiting for Link to press A, if he will at all
@flippersState0:
	ld a,(wGameKeysJustPressed)
	and BTN_A
	jr nz,@pressedA

	call linkSetSwimmingSpeedTmp
	ld a,(wLinkAngle)
	ret

@pressedA:
	; Go to next state
	ld a,$01
	ld (de),a

	ld a,$08
--
	push af
	ld e,SpecialObject.direction
	ld a,(de)
	add a
	add a
	add a
	call func_5933
	pop af
	dec a
	jr nz,--

	ld e,SpecialObject.counter1
	ld a,$0d
	ld (de),a
	ld a,SND_LINK_SWIM
	call playSound


; Accerelating
@flippersState1:
	ldbc $01,$05
	jr ++


; Decelerating
@flippersState2:
	; b: Next state to go to (minus 1)
	; c: Value to add to speedTmp
	ldbc $ff,-5
++
	call itemDecCounter1
	jr z,@nextState

	ld a,(hl)
	and $03
	jr z,@accelerate
	jr @returnDirection

@nextState:
	ld l,SpecialObject.var35
	inc b
	ld (hl),b
	jr nz,+

	call linkSetSwimmingSpeed
	jr @returnDirection
+
	ld l,SpecialObject.counter1
	ld a,$0c
	ld (hl),a

	; Accelerate, or decelerate depending on 'c'.
@accelerate:
	ld l,SpecialObject.speedTmp
	ld a,(hl)
	add c
	bit 7,a
	jr z,+
	xor a
+
	ld (hl),a

	; Return an angle value based on Link's direction?
@returnDirection:
	ld a,(wLinkAngle)
	bit 7,a
	ret z

	ld e,SpecialObject.direction
	ld a,(de)
	swap a
	rrca
	ret

;;
linkUpdateDiving:
	call specialObjectAnimate
	ld hl,wLinkSwimmingState
.ifdef ROM_AGES
	bit 7,(hl)
	jr z,@checkInput

	ld a,(wDisableScreenTransitions)
	or a
	jr nz,@checkInput

	ld a,(wActiveTilePos)
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	cp TILEINDEX_DEEP_WATER
	jp z,checkForUnderwaterTransition@levelDown
.endif

@checkInput:
	ld a,(wGameKeysJustPressed)
	bit BTN_BIT_B,a
	jr nz,@pressedB

	ld a,ZORA_RING
	call cpActiveRing
	ret z

	ld e,SpecialObject.counter2
	ld a,(de)
	dec a
	ld (de),a
	jr z,@surface
	ret

@pressedB:
	bit 7,(hl)
	jr z,@dive

@surface:
	res 7,(hl)
	ld a,LINK_ANIM_MODE_SWIM
	jp specialObjectSetAnimation

@dive:
	set 7,(hl)

	ld e,SpecialObject.counter2
	ld a,$78
	ld (de),a

	call linkCreateSplash
	ld a,LINK_ANIM_MODE_DIVE
	jp specialObjectSetAnimation

;;
linkUpdateSwimming_sidescroll:
	ld a,(wLinkSwimmingState)
	and $0f
	jr z,@swimmingState0

	ld hl,wcc95
	res 4,(hl)

	rst_jumpTable
	.dw @swimmingState0
	.dw @swimmingState1
	.dw @swimmingState2
	.dw linkUpdateDrowning

; Not swimming
@swimmingState0:
	jp initLinkState


; Just entered the water
@swimmingState1:
	call linkCancelAllItemUsage

	ld hl,wLinkSwimmingState
	inc (hl)

	call linkSetSwimmingSpeed
	call objectSetVisiblec1

	ld a,TREASURE_FLIPPERS
	call checkTreasureObtained
	jr nc,@drown

.ifdef ROM_AGES
	ld hl,w1Link.var2f
	bit 6,(hl)
	ld a,LINK_ANIM_MODE_SWIM_2D
	jr z,++

	set 7,(hl)
	ld a,LINK_ANIM_MODE_MERMAID
	jr ++
.else
	ld a,LINK_ANIM_MODE_SWIM_2D
	jr ++
.endif


@drown:
	ld a,$03
	ld (wLinkSwimmingState),a
	ld a,LINK_ANIM_MODE_DROWN
++
	jp specialObjectSetAnimation


; Link remains in this state until he exits the water
@swimmingState2:
	xor a
	ld (wLinkInAir),a

	ld h,d
	ld l,SpecialObject.collisionType
	set 7,(hl)
	ld a,(wLinkImmobilized)
	or a
	jr nz,+++

	; Jump if Link isn't moving ([w1LinkAngle] == $ff)
	ld l,SpecialObject.direction
	ld a,(wLinkAngle)
	add a
	jr c,+

	; Jump if Link's angle is going directly up or directly down (so, don't modify his
	; current facing direction)
	ld c,a
	and $18
	jr z,+

	; Set Link's facing direction based on his angle
	ld a,c
	swap a
	and $03
	ld (hl),a
+
	; Ensure that he's facing either left or right (not up or down)
	set 0,(hl)

.ifdef ROM_AGES
	; Jump if Link does not have the mermaid suit (only flippers)
	ld l,SpecialObject.var2f
	bit 6,(hl)
	jr z,+

	; Mermaid suit movement
	call linkUpdateVelocity@mermaidSuit
	jr ++
+
.endif
	; Flippers movement
	call linkUpdateFlippersSpeed
	call func_5933
++
	call specialObjectUpdatePosition
+++
	; When counter2 goes below 0, create a bubble
	ld h,d
	ld l,SpecialObject.counter2
	dec (hl)
	bit 7,(hl)
	jr z,+

	; Wait between 50-81 frames before creating the next bubble
	call getRandomNumber
	and $1f
	add 50
	ld (hl),a

	ld b,INTERAC_BUBBLE
	call objectCreateInteractionWithSubid00
+
	jp specialObjectAnimate

;;
; Updates speed and angle for things like ice, jumping, underwater? (Things where he
; accelerates and decelerates)
linkUpdateVelocity:
.ifdef ROM_AGES
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	jr z,@label_05_159

@mermaidSuit:
	ld c,$98
	call updateLinkSpeed_withParam
	ld a,(wActiveRing)
	cp SWIMMERS_RING
	jr nz,+

	ld e,SpecialObject.speedTmp
	ld a,SPEED_160
	ld (de),a
+
	ld h,d
	ld a,(wLinkImmobilized)
	or a
	jr nz,+

	ld a,(wGameKeysJustPressed)
	and (BTN_UP | BTN_RIGHT | BTN_DOWN | BTN_LEFT)
	jr nz,@directionButtonPressed
+
	ld l,SpecialObject.var3e
	dec (hl)
	bit 7,(hl)
	jr z,++

	ld a,$ff
	ld (hl),a
	jr func_5933

@directionButtonPressed:
	ld a,SND_SPLASH
	call playSound
	ld h,d
	ld l,SpecialObject.var3e
	ld (hl),$04
++
	ld l,SpecialObject.var12
	ld (hl),$14
.endif

@label_05_159:
	ld a,(wLinkAngle)

;;
; @param a
func_5933:
	ld e,a
	ld h,d
	ld l,SpecialObject.angle
	bit 7,(hl)
	jr z,+

	ld (hl),e
	ret
+
	bit 7,a
	jr nz,@label_05_162
	sub (hl)
	add $04
	and $1f
	cp $09
	jr c,@label_05_164
	sub $10
	cp $09
	jr c,@label_05_163
	ld bc,$0100
	bit 7,a
	jr nz,@label_05_165
	ld b,$ff
	jr @label_05_165
@label_05_162:
	ld bc,$00fb
	ld a,(wLinkInAir)
	or a
	jr z,@label_05_165
	ld c,b
	jr @label_05_165
@label_05_163:
	ld bc,$01fb
	cp $03
	jr c,@label_05_165
	ld b,$ff
	cp $06
	jr nc,@label_05_165
	ld a,e
	xor $10
	ld (hl),a
	ld b,$00
	jr @label_05_165
@label_05_164:
	ld bc,$ff05
	cp $03
	jr c,@label_05_165
	ld b,$01
	cp $06
	jr nc,@label_05_165
	ld a,e
	ld (hl),a
	ld b,$00
@label_05_165:
	ld l,SpecialObject.var12
	inc (hl)
	ldi a,(hl)
	cp (hl)
	ret c

	; Set SpecialObject.speedTmp to $00
	dec l
	ld (hl),$00

	ld l,SpecialObject.angle
	ld a,(hl)
	add b
	and $1f
	ld (hl),a
	ld l,SpecialObject.speedTmp
	ldd a,(hl)
	ld b,a
	ld a,(hl)
	add c
	jr z,++
	bit 7,a
	jr nz,++

	cp b
	jr c,+
	ld a,b
+
	ld (hl),a
	ret
++
	ld l,SpecialObject.speed
	xor a
	ldi (hl),a
	inc l
	ld (hl),l
	dec a
	ld l,SpecialObject.angle
	ld (hl),a
	ret

;;
; linkState01 code, only for sidescrolling areas.
linkState01_sidescroll:
	call sidescrollUpdateActiveTile
	ld a,(wActiveTileType)
	bit TILETYPE_SS_BIT_WATER,a
	jr z,@notInWater

.ifdef ROM_AGES
	; In water

	ld h,d
	ld l,SpecialObject.var2f
	bit 6,(hl)
	jr z,+
	set 7,(hl)
+
.endif
	; If link was in water last frame, don't create a splash
	ld a,(wLinkSwimmingState)
	or a
	jr nz,++

	; Otherwise, he's just entering the water; create a splash
	inc a
	ld (wLinkSwimmingState),a
	call linkCreateSplash
	jr ++

@notInWater:
	; Set WLinkSwimmingState to $00, and jump if he wasn't in water last frame
	ld hl,wLinkSwimmingState
	ld a,(hl)
	ld (hl),$00
	or a
	jr z,++

	; He was in water last frame.

	; Skip the below code if he surfaced from an underwater ladder tile.
	ld a,(wLastActiveTileType)
	cp (TILETYPE_SS_LADDER | TILETYPE_SS_WATER)
	jr z,++

	; Make him "hop out" of the water.

	ld a,$02
	ld (wLinkInAir),a
	call linkCreateSplash

	ld bc,-$1a0
	call objectSetSpeedZ

	ld a,(wLinkAngle)
	ld l,SpecialObject.angle
	ld (hl),a

++
	call checkUseItems

	ld a,(wLinkPlayingInstrument)
	or a
	ret nz

	call specialObjectUpdateAdjacentWallsBitset
	call linkUpdateKnockback

	ld a,(wLinkSwimmingState)
	or a
	jp nz,linkUpdateSwimming_sidescroll

	ld a,(wMagnetGloveState)
	bit 6,a
	jp z,+

	xor a
	ld (wLinkInAir),a
	jp animateLinkStanding
+
	call linkUpdateInAir_sidescroll
	ret z

	ld e,SpecialObject.knockbackCounter
	ld a,(de)
	or a
	ret nz

	ld a,(wActiveTileIndex)
	cp TILEINDEX_SS_SPIKE
	call z,dealSpikeDamageToLink

	ld a,(wForceIcePhysics)
	or a
	jr z,+

	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $30
	jr nz,@onIce
+
	ld a,(wLastActiveTileType)
	cp TILETYPE_SS_ICE
	jr nz,@notOnIce

@onIce:
	ld a,SNOWSHOE_RING
	call cpActiveRing
	jr z,@notOnIce

	ld c,$88
	call updateLinkSpeed_withParam

	ld a,$06
	ld (wForceIcePhysics),a

	call linkUpdateVelocity

	ld c,$02
	ld a,(wLinkAngle)
	rlca
	jr c,++
	jr +

@notOnIce:
	xor a
	ld (wForceIcePhysics),a
	ld c,a
	ld a,(wLinkAngle)
	ld e,SpecialObject.angle
	ld (de),a
	rlca
	jr c,++

	call updateLinkSpeed_standard

	; Parameter for linkUpdateMovement (update his animation only; don't update his
	; position)
	ld c,$01

	ld a,(wLinkImmobilized)
	or a
	jr nz,++
+
	; Parameter for linkUpdateMovement (update everything, including his position)
	ld c,$07
++
	; When not in the water or in other tiles with particular effects, adjust Link's
	; angle so that he moves purely horizontally.
	ld hl,wActiveTileType
	ldi a,(hl)
	or (hl)
	and $ff~TILETYPE_SS_ICE
	call z,linkAdjustAngleInSidescrollingArea

	call linkUpdateMovement

	; The following checks are for whether to cap Link's y position so he doesn't go
	; above a certain point.

	ld e,SpecialObject.angle
	ld a,(de)
	add $04
	and $1f
	cp $09
	jr nc,++

	; Allow him to move up if the tile he's in has any special properties?
	ld hl,wActiveTileType
	ldi a,(hl)
	or a
	jr nz,++

	; Allow him to move up if the tile he's standing on is NOT the top of a ladder?
	ld a,(hl)
	cp (TILETYPE_SS_LADDER | TILETYPE_SS_LADDER_TOP)
	jr nz,++

	; Check if Link's y position within the tile is lower than 9
	ld e,SpecialObject.yh
	ld a,(de)
	and $0f
	cp $09
	jr nc,++

	; If it's lower than 9, set it back to 9
	ld a,(de)
	and $f0
	add $09
	ld (de),a

++
	; Don't climb a ladder if Link is touching the ground
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $30
	jr nz,+

	ld a,(wActiveTileType)
	bit TILETYPE_SS_BIT_LADDER,a
	jr z,+

	; Climbing a ladder
	ld a,$01
	ld (wLinkClimbingVine),a
+
	ld a,(wLinkTurningDisabled)
	or a
	ret nz
	jp updateLinkDirectionFromAngle

;;
; Updates Link's animation and position based on his current speed and angle variables,
; among other things.
; @param c Bit 0: Set if Link's animation should be "walking" instead of "standing".
;          Bit 1: Set if Link's position should be updated based on his speed and angle.
;          Bit 2: Set if the heart ring's regeneration should be applied (if he moves).
linkUpdateMovement:
	ld a,c

	; Check whether to animate him "standing" or "walking"
	rrca
	push af
	jr c,+
	call animateLinkStanding
	jr ++
+
	call animateLinkWalking
++
	pop af

	; Check whether to update his position
	rrca
	jr nc,++

	push af
	call specialObjectUpdatePosition
	jr z,+

	ld c,a
	pop af

	; Check whether to update the heart ring counter
	rrca
	ret nc

	ld a,c
	jp updateHeartRingCounter
+
	pop af
++
	jp linkResetSpeed

;;
; Only for top-down sections. (See also linkUpdateInAir_sidescroll.)
linkUpdateInAir:
	ld a,(wLinkInAir)
	and $0f
	rst_jumpTable
	.dw @notInAir
	.dw @startedJump
	.dw @inAir

@notInAir:
	; Ensure that bit 1 of wLinkInAir is set if Link's z position is < 0.
	ld h,d
	ld l,SpecialObject.zh
	bit 7,(hl)
	ret z

	ld a,$02
	ld (wLinkInAir),a
	jr ++

@startedJump:
	ld hl,wLinkInAir
	inc (hl)
	bit 7,(hl)
	jr nz,+

	ld hl,wIsTileSlippery
	bit 6,(hl)
	jr nz,+

	ld l,<wActiveTileType
	ld (hl),TILETYPE_NORMAL
	call updateLinkSpeed_standard

	ld a,(wLinkAngle)
	ld e,SpecialObject.angle
	ld (de),a
+
	ld a,SND_JUMP
	call playSound
++
	; Set jumping animation if he's not holding anything or using an item
	ld a,(wLinkGrabState)
	ld c,a
	ld a,(wLinkTurningDisabled)
	or c
	ld a,LINK_ANIM_MODE_JUMP
	call z,specialObjectSetAnimation

@inAir:
	xor a
	ld e,SpecialObject.var12
	ld (de),a
	inc e
	ld (de),a

	; If bit 7 of wLinkInAir is set, allow him to pass through walls (needed for
	; moving through cliff tiles?)
	ld hl,wLinkInAir
	bit 7,(hl)
	jr z,+
	ld e,SpecialObject.adjacentWallsBitset
	ld (de),a
+
	; Set 'c' to the gravity value. Reduce if bit 5 of wLinkInAir is set?
	bit 5,(hl)
	ld c,$20
	jr z,+
	ld c,$0a
+
	call objectUpdateSpeedZ_paramC

	ld l,SpecialObject.speedZ+1
	jr z,@landed

	; Still in the air

	; Return if speedZ is negative
	ld a,(hl)
	bit 7,a
	ret nz

	; Return if speedZ < $0300
	cp $03
	ret c

	; Cap speedZ to $0300
	ld (hl),$03
	dec l
	ld (hl),$00
	ret

@landed:
	; Set speedZ and wLinkInAir to 0
	xor a
	ldd (hl),a
	ld (hl),a
	ld (wLinkInAir),a

	ld e,SpecialObject.var36
	ld (de),a

	call animateLinkStanding
	call specialObjectSetPositionToVar38IfSet
	call linkApplyTileTypes

	; Check if wActiveTileType is TILETYPE_HOLE or TILETYPE_WARPHOLE
	ld a,(wActiveTileType)
	dec a
	cp TILETYPE_WARPHOLE
	jr nc,+

	; If it's a hole tile, initialize this
	ld a,$04
	ld (wStandingOnTileCounter),a
+
	ld a,SND_LAND
	call playSound
	call specialObjectUpdateAdjacentWallsBitset
	jp initLinkState

;;
; @param[out]	zflag	If set, linkState01_sidescroll will return prematurely.
linkUpdateInAir_sidescroll:
	ld a,(wLinkInAir)
	and $0f
	rst_jumpTable
	.dw @notInAir
	.dw @jumping
	.dw @inAir

@notInAir:
	ld a,(wLinkRidingObject)
	or a
	ret nz

	; Return if Link is on solid ground
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $30
	ret nz

	; Return if Link's current tile, or the one he's standing on, is a ladder.
	ld hl,wActiveTileType
	ldi a,(hl)
	or (hl)
	bit TILETYPE_SS_BIT_LADDER,a
	ret nz

	; Link is in the air.
	ld h,d
	ld l,SpecialObject.speedZ
	xor a
	ldi (hl),a
	ldi (hl),a
	jr +

@jumping:
	ld a,SND_JUMP
	call playSound
+
	ld a,(wLinkGrabState)
	ld c,a
	ld a,(wLinkTurningDisabled)
	or c
	ld a,LINK_ANIM_MODE_JUMP
	call z,specialObjectSetAnimation

	ld a,$02
	ld (wLinkInAir),a
	call updateLinkSpeed_standard

@inAir:
	ld h,d
	ld l,SpecialObject.speedZ+1
	bit 7,(hl)
	jr z,@positiveSpeedZ

	; If speedZ is negative, check if he hits the ceiling
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $c0
	jr nz,@applyGravity
	jr @applySpeedZ

@positiveSpeedZ:
	ld a,(wLinkRidingObject)
	or a
	jp nz,@playingInstrument

	; Check if Link is on solid ground
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $30
	jp nz,@landedOnGround

	; Check if Link presses up on a ladder; this will put him back into a ground state
	ld a,(wActiveTileType)
	bit TILETYPE_SS_BIT_LADDER,a
	jr z,+

	ld a,(wGameKeysPressed)
	and BTN_UP
	jp nz,@landed
+
	ld e,SpecialObject.yh
	ld a,(de)
	bit 3,a
	jr z,+

	ld a,(wLastActiveTileType)
	cp (TILETYPE_SS_LADDER | TILETYPE_SS_LADDER_TOP)
	jr z,@landedOnGround
+
	ld hl,wActiveTileType
	ldi a,(hl)
	cp TILETYPE_SS_LAVA
	jp z,forceDrownLink

	; Check if he's ended up in a hole
	cp TILETYPE_SS_HOLE
	jr nz,++

	; Check the tile below link? (In this case, since wLastActiveTileType is the tile
	; 8 pixels below him, this will probably be the same as wActiveTile, UNTIL he
	; reaches the center of the tile. At which time, if the tile beneath has
	; a tileType of $00, Link will respawn.
	ld a,(hl)
	or a
	jr nz,++

	; Damage Link and respawn him.
	ld a,SND_DAMAGE_LINK
	call playSound
	jp respawnLink

++
	call linkUpdateVelocity

@applySpeedZ:
	; Apply speedZ to Y position
	ld l,SpecialObject.y
	ld e,SpecialObject.speedZ
	ld a,(de)
	add (hl)
	ldi (hl),a
	inc e
	ld a,(de)
	adc (hl)
	ldi (hl),a

@applyGravity:
	; Set 'c' to the gravity value (value to add to speedZ).
	ld c,$24
	ld a,(wLinkInAir)
	bit 5,a
	jr z,+
	ld c,$0e
+
	ld l,SpecialObject.speedZ
	ld a,(hl)
	add c
	ldi (hl),a
	ld a,(hl)
	adc $00
	ldd (hl),a

	; Cap Link's speedZ to $0300
	bit 7,a
	jr nz,+
	cp $03
	jr c,+
	xor a
	ldi (hl),a
	ld (hl),$03
+
	call specialObjectUpdateAdjacentWallsBitset

	; Check (again) whether Link has reached the ground.
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $30
	jr nz,@landedOnGround

	; Adjusts Link's angle so he doesn't move (on his own) on the y axis.
	; This is confusing since he has a Z speed, which gets applied to the Y axis. All
	; this does is prevent Link's movement from affecting the Y axis; it still allows
	; his Z speed to be applied.
	; Disabling this would give him some control over the height of his jumps.
	call linkAdjustAngleInSidescrollingArea

	call specialObjectUpdatePosition
	call specialObjectAnimate

	; Check if Link's reached the bottom boundary of the room?
	ld e,SpecialObject.yh
	ld a,(de)
	cp $a9
	jr c,@notLanded
.ifdef ROM_AGES
	jr @landedOnGround
.else
	ld a,(wActiveTileType)
	cp TILETYPE_SS_LADDER
	jr nz,@notLanded
	ld a,$80 | DIR_DOWN
	ld (wScreenTransitionDirection),a
.endif

@notLanded:
	xor a
	ret

@landedOnGround:
	; Lock his y position to the 9th pixel on that tile.
	ld e,SpecialObject.yh
	ld a,(de)
	and $f8
	add $01
	ld (de),a

@landed:
	xor a
	ld e,SpecialObject.speedZ
	ld (de),a
	inc e
	ld (de),a

	ld (wLinkInAir),a

	; Check if he landed on a spike
	ld a,(wActiveTileIndex)
	cp TILEINDEX_SS_SPIKE
	call z,dealSpikeDamageToLink

	ld a,SND_LAND
	call playSound
	call animateLinkStanding
	xor a
	ret

@playingInstrument:
	ld e,SpecialObject.var12
	xor a
	ld (de),a

	; Write $ff to the variable that you just wrote $00 to? OK, game.
	ld a,$ff
	ld (de),a

	ld e,SpecialObject.angle
	ld (de),a
	jr @landed

;;
; Sets link's state to LINK_STATE_NORMAL, sets var35 to $00
initLinkState:
	ld h,d
	ld l,<w1Link.state
	ld (hl),LINK_STATE_NORMAL
	inc l
	ld (hl),$00
	ld l,<w1Link.var35
	ld (hl),$00
	ret

;;
; Called after most types of warps
initLinkStateAndAnimateStanding:
	call initLinkState
	ld l,<w1Link.visible
	set 7,(hl)
;;
animateLinkStanding:
	ld e,<w1Link.animMode
	ld a,(de)
	cp LINK_ANIM_MODE_WALK
	jr nz,+

	call checkPegasusSeedCounter
	jr nz,animateLinkWalking
+
	; If not using pegasus seeds, set animMode to 0. At the end of the function, this
	; will be changed back to LINK_ANIM_MODE_WALK; this will simply cause the
	; animation to be reset, resulting in him staying on the animation's first frame.
	xor a
	ld (de),a

;;
animateLinkWalking:
	call checkPegasusSeedCounter
	jr z,++

	rlca
	jr nc,++

	; This has to do with the little puffs appearing at link's feet
	ld hl,w1ReservedItemF
	ld a,$03
	ldi (hl),a
	ld (hl),ITEM_DUST
	inc l
	inc (hl)

	ld a,SND_LAND
	call playSound
++
	ld h,d
	ld a,$10
	ld l,<w1Link.animMode
	cp (hl)
	jp nz,specialObjectSetAnimation
	jp specialObjectAnimate

;;
updateLinkSpeed_standard:
	ld c,$00

;;
; @param	c	Bit 7 set if speed shouldn't be modified?
updateLinkSpeed_withParam:
	ld e,<w1Link.var36
	ld a,(de)
	cp c
	jr z,++

	ld a,c
	ld (de),a
	and $7f
	ld hl,@data
	rst_addAToHl

	ld e,<w1Link.speed
	ldi a,(hl)
	or a
	jr z,+

	ld (de),a
+
	xor a
	ld e,<w1Link.var12
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
++
	; 'b' will be added to the index for the below table, depending on whether Link is
	; slowed down by grass, stairs, etc.
	ld b,$02
	; 'e' will be added to the index in the same way as 'b'. It will be $04 if Link is
	; using pegasus seeds.
	ld e,$00

	; Don't apply pegasus seed modifier when on a hole?
	ld a,(wActiveTileType)
	cp TILETYPE_HOLE
	jr z,++
	cp TILETYPE_WARPHOLE
	jr z,++

	; Grass: b = $02
	cp TILETYPE_GRASS
	jr z,+
	inc b

	; Stairs / vines: b = $03
	cp TILETYPE_STAIRS
	jr z,+
	cp TILETYPE_VINES
	jr z,+

	; Standard movement: b = $04
	inc b
+
	call checkPegasusSeedCounter
	jr z,++

	ld e,$03
++
	ld a,e
	add b
	add c
	and $7f
	ld hl,@data
	rst_addAToHl
	ld a,(hl)
	ld h,d
	ld l,<w1Link.speedTmp
	ldd (hl),a
	bit 7,c
	ret nz
	ld (hl),a
	ret

@data:
	.db $28 $00 $1e $14 $28 $2d $1e $3c
	.db $00 $06 $28 $28 $28 $3c $3c $3c
	.db $14 $03 $1e $14 $28 $2d $1e $3c
.ifdef ROM_AGES
	.db $00 $05 $2d $2d $2d $2d $2d $2d
.endif

;;
; Updates Link's speed and updates his position if he's experiencing knockback.
linkUpdateKnockback:
	ld e,SpecialObject.state
	ld a,(de)
	cp LINK_STATE_RESPAWNING
	jr z,@cancelKnockback

	ld a,(wLinkInAir)
	rlca
	jr c,@cancelKnockback

	; Set c to the amount to decrement knockback by.
	; $01 normally, $02 if in the air?
	ld c,$01
	or a
	jr z,+
	inc c
+
	ld h,d
	ld l,SpecialObject.knockbackCounter
	ld a,(hl)
	or a
	ret z

	; Decrement knockback
	sub c
	jr c,@cancelKnockback
	ld (hl),a

	; Adjust link's knockback angle if necessary when sidescrolling
	ld l,SpecialObject.knockbackAngle
	call linkAdjustGivenAngleInSidescrollingArea

	; Get speed and knockback angle (de = w1Link.knockbackAngle)
	ld a,(de)
	ld c,a
	ld b,SPEED_140

	ld hl,wcc95
	res 5,(hl)

	jp specialObjectUpdatePositionGivenVelocity

@cancelKnockback:
	ld e,SpecialObject.knockbackCounter
	xor a
	ld (de),a
	ret

;;
; Updates a special object's position without allowing it to "slide off" tiles when they
; are approached from the side.
specialObjectUpdatePositionWithoutTileEdgeAdjust:
	ld e,SpecialObject.speed
	ld a,(de)
	ld b,a
	ld e,SpecialObject.angle
	ld a,(de)
	jr +

;;
specialObjectUpdatePosition:
	ld e,SpecialObject.speed
	ld a,(de)
	ld b,a
	ld e,SpecialObject.angle
	ld a,(de)
	ld c,a

;;
; Updates position, accounting for solid walls.
;
; @param	b	Speed
; @param	c	Angle
; @param[out]	a	Bits 0, 1 set if his y, x positions changed, respectively.
; @param[out]	c	Same as a.
; @param[out]	zflag	Set if the object did not move at all.
specialObjectUpdatePositionGivenVelocity:
	bit 7,c
	jr nz,++++

	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	ld e,a
	call @tileEdgeAdjust
	jr nz,++
+
	ld c,a
	ld e,$00
++
	; Depending on the angle, change 'e' to hold the bits that should be checked for
	; collision in adjacentWallsBitset. If the angle is facing up, then only the 'up'
	; bits will be set.
	ld a,c
	ld hl,@bitsToCheck
	rst_addAToHl
	ld a,e
	and (hl)
	ld e,a

	; Get 4 bytes at hl determining the offsets Link should move for speed 'b' and
	; angle 'c'.
	call getPositionOffsetForVelocity

	ld c,$00

	; Don't apply vertical speed if there is a wall.
	ld b,e
	ld a,b
	and $f0
	jr nz,++

	; Don't run the below code if the vertical offset is zero.
	ldi a,(hl)
	or (hl)
	jr z,++

	; Add values at hl to y position
	dec l
	ld e,SpecialObject.y
	ld a,(de)
	add (hl)
	ld (de),a
	inc e
	inc l
	ld a,(de)
	adc (hl)
	ld (de),a

	; Set bit 0 of c
	inc c
++
	; Don't apply horizontal speed if there is a wall.
	ld a,b
	and $0f
	jr nz,++

	; Don't run the below code if the horizontal offset is zero.
	ld l,<(wTmpcec0+3)
	ldd a,(hl)
	or (hl)
	jr z,++

	; Add values at hl to x position
	ld e,SpecialObject.x
	ld a,(de)
	add (hl)
	ld (de),a
	inc l
	inc e
	ld a,(de)
	adc (hl)
	ld (de),a

	set 1,c
++
	ld a,c
	or a
	ret
++++
	xor a
	ld c,a
	ret

; Takes an angle as an index.
; Each value tells which bits in adjacentWallsBitset to check for collision for that
; angle. Ie. when moving up, only check collisions above Link, not below.
@bitsToCheck:
	.db $cf $c3 $c3 $c3 $c3 $c3 $c3 $c3
	.db $f3 $33 $33 $33 $33 $33 $33 $33
	.db $3f $3c $3c $3c $3c $3c $3c $3c
	.db $fc $cc $cc $cc $cc $cc $cc $cc

;;
; Converts Link's angle such that he "slides off" a tile when walking towards the edge.
; @param c Angle
; @param e adjacentWallsBitset
; @param[out] a New angle value
; @param[out] zflag Set if a value has been returned in 'a'.
@tileEdgeAdjust:
	ld a,c
	ld hl,slideAngleTable
	rst_addAToHl
	ld a,(hl)
	and $03
	ret nz

	ld a,(hl)
	rlca
	jr c,@bit7
	rlca
	jr c,@bit6
	rlca
	jr c,@bit5

	ld a,e
	and $cc
	cp $04
	ld a,$00
	ret z

	ld a,e
	and $3c
	cp $08
	ld a,$10
	ret
@bit5:
	ld a,e
	and $c3
	cp $01
	ld a,$00
	ret z
	ld a,e
	and $33
	cp $02
	ld a,$10
	ret
@bit7:
	ld a,e
	and $c3
	cp $80
	ld a,$08
	ret z
	ld a,e
	and $cc
	cp $40
	ld a,$18
	ret
@bit6:
	ld a,e
	and $33
	cp $20
	ld a,$08
	ret z
	ld a,e
	and $3c
	cp $10
	ld a,$18
	ret

;;
; Updates SpecialObject.adjacentWallsBitset (always for link?) which determines which ways
; he can move.
specialObjectUpdateAdjacentWallsBitset:
	ld e,SpecialObject.adjacentWallsBitset
	xor a
	ld (de),a

	; Return if Link is riding a companion, minecart
	ld a,(wLinkObjectIndex)
	rrca
	ret c

.ifdef ROM_SEASONS
	ld a,(wActiveTileType)
	sub TILETYPE_STUMP
	jr nz,+
	dec a
	jr +++
+
.endif

	ld h,d
	ld l,SpecialObject.yh
	ld b,(hl)
	ld l,SpecialObject.xh
	ld c,(hl)
	call calculateAdjacentWallsBitset

.ifdef ROM_AGES
	ld b,a
	ld hl,@data-1
--
	inc hl
	ldi a,(hl)
	or a
	jr z,++
	cp b
	jr nz,--

	ld a,(hl)
	ldh (<hFF8B),a
	ld e,SpecialObject.adjacentWallsBitset
	ld (de),a
	ret
++
	ld a,b
	ld e,SpecialObject.adjacentWallsBitset
	ld (de),a
	ret

@data:
	.db $db $c3
	.db $ee $cc
	.db $00
.else
+++
	ld e,SpecialObject.adjacentWallsBitset
	ld (de),a
	ret
.endif

;;
; This function only really works with Link.
;
; @param	bc	Position to check
; @param[out]	b	Bit 7 set if the position is surrounded by a wall on all sides?
checkPositionSurroundedByWalls:
	call calculateAdjacentWallsBitset
--
	ld b,$80
	cp $ff
	ret z

	rra
	rl b
	rra
	rl b
	jr nz,--
	ret

;;
; This function is likely meant for Link only, due to its use of "wLinkRaisedFloorOffset".
;
; @param	bc	YX position.
; @param[out]	a	Bitset of adjacent walls.
; @param[out]	hFF8B	Same as 'a'.
calculateAdjacentWallsBitset:
	ld a,$01
	ldh (<hFF8B),a

	ld hl,@overworldOffsets
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr z,@loop
	ld hl,@sidescrollOffsets

; Loop 8 times
@loop:
	ldi a,(hl)
	add b
	ld b,a
	ldi a,(hl)
	add c
	ld c,a
	push hl

.ifdef ROM_AGES
	ld a,(wLinkRaisedFloorOffset)
	or a
	jr z,+

	call @checkTileCollisionAt_allowRaisedFl
	jr ++
+
.endif
	call checkTileCollisionAt_allowHoles
++
	pop hl
	ldh a,(<hFF8B)
	rla
	ldh (<hFF8B),a
	jr nc,@loop
	ret

; List of YX offsets from Link's position to check for collision at.
; For each offset where there is a collision, the corresponding bit of 'a' will be set.
@overworldOffsets:
	.db -3, -3
	.db  0,  5
	.db 10, -5
	.db  0,  5
	.db -7, -7
	.db  5,  0
	.db -5,  9
	.db  5,  0

@sidescrollOffsets:
	.db -3, -3
	.db  0,  5
	.db 10, -5
	.db  0,  5
	.db -7, -7
	.db  5,  0
	.db -5,  9
	.db  5,  0

.ifdef ROM_AGES
;;
; This may be identical to "checkTileCollisionAt_allowHoles", except that unlike that,
; this does not consider raised floors to have collision?
; @param bc YX position to check for collision
; @param[out] cflag Set on collision
@checkTileCollisionAt_allowRaisedFl:
	ld a,b
	and $f0
	ld l,a
	ld a,c
	swap a
	and $0f
	or l
	ld l,a
	ld h,>wRoomCollisions
	ld a,(hl)
	cp $10
	jr c,@simpleCollision

; Complex collision

	and $0f
	ld hl,@specialCollisions
	rst_addAToHl
	ld e,(hl)
	cp $08
	ld a,b
	jr nc,+
	ld a,c
+
	rrca
	and $07
	ld hl,bitTable
	add l
	ld l,a
	ld a,(hl)
	and e
	ret z
	scf
	ret

@specialCollisions:
	.db %00000000 %11000011 %00000011 %11000000 %00000000 %11000011 %11000011 %00000000
	.db %00000000 %11000011 %00000011 %11000000 %11000000 %11000001 %00000000 %00000000


@simpleCollision:
	bit 3,b
	jr nz,+
	rrca
	rrca
+
	bit 3,c
	jr nz,+
	rrca
+
	rrca
	ret
.endif

;;
; Unused?
clearLinkImmobilizedBit4:
	push hl
	ld hl,wLinkImmobilized
	res 4,(hl)
	pop hl
	ret

;;
setLinkImmobilizedBit4:
	push hl
	ld hl,wLinkImmobilized
	set 4,(hl)
	pop hl
	ret

;;
; Adjusts Link's position to suck him into the center of a tile, and sets his state to
; LINK_STATE_FALLING when he reaches the center.
linkPullIntoHole:
	xor a
	ld e,SpecialObject.knockbackCounter
	ld (de),a

	ld h,d
	ld l,SpecialObject.state
	ld a,(hl)
	cp LINK_STATE_RESPAWNING
	ret z

	; Allow partial control of Link's position for the first 16 frames he's over the
	; hole.
	ld a,(wStandingOnTileCounter)
	cp $10
	call nc,setLinkImmobilizedBit4

	; Depending on the frame counter, move horizontally, vertically, or not at all.
	and $03
	jr z,@moveVertical
	dec a
	jr z,@moveHorizontal
	ret

@moveVertical:
	ld l,SpecialObject.yh
	ld a,(hl)
	add $05
	and $f0
	add $08
	sub (hl)
	jr c,@decPosition
	jr @incPosition

@moveHorizontal:
	ld l,SpecialObject.xh
	ld a,(hl)
	and $f0
	add $08
	sub (hl)
	jr c,@decPosition

@incPosition:
	ld a,(hl)
	inc a
	jr +

@decPosition:
	ld a,(hl)
	dec a
+
	ld (hl),a

	; Check that Link is within 3 pixels of the vertical center
	ld l,SpecialObject.yh
	ldi a,(hl)
	and $0f
	sub $07
	cp $03
	ret nc

	; Check that Link is within 3 pixels of the horizontal center
	inc l
	ldi a,(hl)
	and $0f
	sub $07
	cp $03
	ret nc

	; Link has reached the center of the tile, now he'll start falling

	call clearAllParentItems

	ld e,SpecialObject.knockbackCounter
	xor a
	ld (de),a
	ld (wLinkStateParameter),a

	; Change Link's state to the falling state
	ld e,SpecialObject.id
	ld a,(de)
	or a
	ld a,LINK_STATE_RESPAWNING
	jp z,linkSetState

	; If link's ID isn't zero, set his state indirectly...?
	ld (wLinkForceState),a
	ret

;;
; Checks if Link is pushing against the bed in Nayru's house. If so, set Link's state to
; LINK_STATE_SLEEPING.
; The only bed that this works for is the one in Nayru's house.
checkLinkPushingAgainstBed:
	ld hl,wInformativeTextsShown
	bit 1,(hl)
	ret nz

	ld a,(wActiveGroup)
	cp $03
	ret nz

	; Check link is in the room with the bed, and is next to it
.ifdef ROM_AGES
	ldbc <ROOM_AGES_39e, $17
	ld l,DIR_RIGHT
.else
	ldbc <ROOM_SEASONS_382, $14
	ld l,DIR_LEFT
.endif
	ld a,(wActiveRoom)
	cp b
	ret nz

	ld a,(wActiveTilePos)
	cp c
	ret nz

	ld e,SpecialObject.direction
	ld a,(de)
	cp l
	ret nz

	call checkLinkPushingAgainstWall
	ret z

	; Increment counter, wait until it's been 90 frames
	ld hl,wLinkPushingAgainstBedCounter
	inc (hl)
	ld a,(hl)
	cp 90
	ret c

	pop hl
	ld hl,wInformativeTextsShown
	set 1,(hl)
	ld a,LINK_STATE_SLEEPING
	jp linkSetState

.ifdef ROM_SEASONS
;;
; Pushing against tree stump
checkLinkPushingAgainstTreeStump:
	ld a,(wActiveTileType)
	cp TILETYPE_STUMP
	jp z,seasonsFunc_05_5ed3

	ld a,(wActiveGroup)
	or a
	ret nz

	ld a,(wLinkAngle)
	and $e7
	ret nz
	call checkLinkPushingAgainstWall
	ret nc
	ld e,SpecialObject.direction
	ld a,(de)
	ld hl,@relativeTile
	rst_addDoubleIndex

	ldi a,(hl)
	ld b,a
	ld c,(hl)
	call objectGetRelativeTile
	cp $20
	ret nz
	ld a,$01
	call specialObjectSetVar37AndVar38

	ld e,SpecialObject.direction
	ld a,(de)
	ld l,a
	add a
	add l
	ld hl,@speedValues
	rst_addAToHl

	ld e,SpecialObject.speed
	ldi a,(hl)
	ld (de),a
	inc e
	ld (de),a
	ld e,SpecialObject.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	ld a,$81
	ld (wLinkInAir),a
	jp linkCancelAllItemUsage

@relativeTile:
	.db $f4 $00 ; DIR_UP
	.db $00 $07 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT

@speedValues:
	dbw $23 $fe40
	dbw $14 $fe60
	dbw $0f $fe40
	dbw $14 $fe60


seasonsFunc_05_5ed3:
	ld a,(wLinkAngle)
	ld c,a
	and $e7
	jr nz,++

	ld a,c
	add a
	swap a
	ld hl,@relativeTile

	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld h,d
	ld l,SpecialObject.yh
	add (hl)
	ld b,a
	ld l,SpecialObject.xh
	ld a,(hl)
	add c
	ld c,a
	call checkTileCollisionAt_allowHoles
	jr c,++

	ld a,(wLinkAngle)
	ld e,SpecialObject.angle
	ld (de),a
	add a
	swap a
	ld c,a
	add a
	add c
	ld hl,@speedValues
	rst_addAToHl
	ld a,(wLinkTurningDisabled)
	or a
	jr nz,+
	ld e,SpecialObject.direction
	ld a,c
	ld (de),a
+
	ld e,SpecialObject.speed
	ldi a,(hl)
	ld (de),a
	; SpecialObject.speedTmp
	inc e
	ld (de),a
	ld e,SpecialObject.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	call clearVar37AndVar38
	ld a,$81
	ld (wLinkInAir),a
	xor a
	ret
++
	or d
	ret

@relativeTile:
	.db $fb $00
	.db $00 $09
	.db $1b $00
	.db $00 $f6

@speedValues:
	dbw $0f $fe60
	dbw $14 $fe60
	dbw $1e $fe40
	dbw $14 $fe60
.endif

clearVar37AndVar38:
	xor a
	ld e,SpecialObject.var37
	ld (de),a
	inc e
	ld (de),a
	ret

;;
; @param	a	Value for var37
; @param	l	Value for var38 (a position value)
specialObjectSetVar37AndVar38:
	ld e,SpecialObject.var37
	ld (de),a
	inc e
	ld a,l
	ld (de),a

;;
; Sets an object's angle to face the position in var37/var38?
specialObjectSetAngleRelativeToVar38:
	ld e,SpecialObject.var37
	ld a,(de)
	or a
	ret z

	ld hl,data_6012-2
	rst_addDoubleIndex

	inc e
	ld a,(de)
	ld c,a
	and $f0
	add (hl)
	ld b,a
	inc hl
	ld a,c
	and $0f
	swap a
	add (hl)
	ld c,a

	call objectGetRelativeAngle
	ld e,SpecialObject.angle
	ld (de),a
	ret

data_6012:
	.db $02 $08
	.db $0c $08

;;
; Warps link somewhere based on var37 and var38?
specialObjectSetPositionToVar38IfSet:
	ld e,SpecialObject.var37
	ld a,(de)
	or a
	ret z

	ld hl,data_6012-2
	rst_addDoubleIndex

	; de = SpecialObject.var38
	inc e
	ld a,(de)
	ld c,a
	and $f0
	add (hl)
	ld e,SpecialObject.yh
	ld (de),a

	inc hl
	ld a,c
	and $0f
	swap a
	add (hl)
	ld e,SpecialObject.xh
	ld (de),a
	jr clearVar37AndVar38

;;
; Checks if Link touches a cliff tile, and starts the jumping-off-cliff code if so.
checkLinkJumpingOffCliff:
.ifdef ROM_SEASONS
	ld a,(wActiveTileType)
	cp TILETYPE_STUMP
	ret z
.endif

	; Return if Link is not moving in a cardinal direction?
	ld a,(wLinkAngle)
	ld c,a
	and $e7
	ret nz

	ld h,d
	ld l,SpecialObject.angle
	xor c
	cp (hl)
	ret nz

	; Check that Link is facing towards a solid wall
	add a
	swap a
	ld c,a
	add a
	add a
	add c
	ld hl,@wallDirections
	rst_addAToHl
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and (hl)
	cp (hl)
	ret nz

	; Check 2 offsets from Link's position to ensure that both of them are cliff
	; tiles.
	call @checkCliffTile
	ret nc
	call @checkCliffTile
	ret nc

	; If the above checks passed, start making Link jump off the cliff.

	ld a,$81
	ld (wLinkInAir),a
	ld bc,-$1c0
	call objectSetSpeedZ
	ld l,SpecialObject.knockbackCounter
	ld (hl),$00

.ifdef ROM_SEASONS
	ldh a,(<hFF8B)
	cp $05
	jr z,@setSpeed140
	cp $06
	jr z,@setSpeed140
.endif

	; Return from caller (don't execute any more "linkState01" code)
	pop hl

	ld a,LINK_STATE_JUMPING_DOWN_LEDGE
	call linkSetState
	jr linkState12

;;
; Unused?
@setSpeed140:
	ld l,SpecialObject.speed
	ld (hl),SPEED_140
	ret

;;
; @param[out] cflag
@checkCliffTile:
	inc hl
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	push hl
	call objectGetRelativeTile
	ldh (<hFF8B),a
	ld hl,cliffTilesTable
	call lookupCollisionTable
	pop hl
	ret nc

	ld c,a
	ld e,SpecialObject.angle
	ld a,(de)
	cp c
	scf
	ret z

	xor a
	ret

; Data format:
; b0: bits that must be set in w1Link.adjacentWallsBitset for that direction
; b1-b2, b3-b4: Each of these pairs of bytes is a relative offset from Link's position to
; check whether the tile there is a cliff tile. Both resulting positions must be valid.
@wallDirections:
	.db $c0 $fc $fd $fc $02 ; DIR_UP
	.db $03 $00 $04 $05 $04 ; DIR_RIGHT
	.db $30 $08 $fd $08 $02 ; DIR_DOWN
	.db $0c $00 $fb $05 $fb ; DIR_LEFT

;;
; LINK_STATE_JUMPING_DOWN_LEDGE
linkState12:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call itemIncSubstate

.ifdef ROM_AGES
	; Set jumping animation if not underwater
	ld l,SpecialObject.var2f
	bit 7,(hl)
	jr nz,++
.endif

	ld a,(wLinkGrabState)
	ld c,a
	ld a,(wLinkTurningDisabled)
	or c
	ld a,LINK_ANIM_MODE_JUMP
	call z,specialObjectSetAnimation
++
	ld a,SND_JUMP
	call playSound

	call @getLengthOfCliff
	jr z,@willTransition

	ld hl,@cliffSpeedTable - 1
	rst_addAToHl
	ld a,(hl)
	ld e,SpecialObject.speed
	ld (de),a
	ret

; A screen transition will occur by jumping off this cliff. Only works properly for cliffs
; facing down.
@willTransition:
	ld a,(wScreenTransitionBoundaryY)
	ld b,a
	ld h,d
	ld l,SpecialObject.yh
	ld a,(hl)
	sub b
	ld (hl),b

	ld l,SpecialObject.zh
	ld (hl),a

	; Disable terrain effects (shadow)
	ld l,SpecialObject.visible
	res 6,(hl)

	ld l,SpecialObject.substate
	ld (hl),$02

	xor a
	ld l,SpecialObject.speed
	ld (hl),a
	ld l,SpecialObject.speedZ
	ldi (hl),a
	ld (hl),$ff

	; [wDisableScreenTransitions] = $01
	inc a
	ld (wDisableScreenTransitions),a

	ld l,SpecialObject.var2f
	set 0,(hl)
	ret


; The index to this table is the length of a cliff in tiles; the value is the speed
; required to pass through the cliff.
@cliffSpeedTable:
	.db           SPEED_080 SPEED_0a0 SPEED_0e0
	.db SPEED_120 SPEED_160 SPEED_1a0 SPEED_200
	.db SPEED_240 SPEED_280 SPEED_2c0 SPEED_300


; In the process of falling down the cliff (will land in-bounds).
@substate1:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,specialObjectAnimate

; Link has landed on the ground

	; If a screen transition happened, update respawn position
	ld h,d
	ld l,SpecialObject.var2f
	bit 0,(hl)
	res 0,(hl)
	call nz,updateLinkLocalRespawnPosition

	call specialObjectTryToBreakTile_source05

.ifdef ROM_SEASONS
	ld a,(wActiveGroup)
	or a
	jr nz,+
	ld bc,$0500
	call objectGetRelativeTile
	cp $20
	jr nz,+
	call objectCenterOnTile
	ld l,SpecialObject.yh
	ld a,(hl)
	sub $06
	ld (hl),a
+
.endif

	xor a
	ld (wLinkInAir),a
	ld (wLinkSwimmingState),a

	ld a,SND_LAND
	call playSound

	call specialObjectUpdateAdjacentWallsBitset
	jp initLinkStateAndAnimateStanding


; In the process of falling down the cliff (a screen transition will occur).
@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,specialObjectAnimate

	; Initiate screen transition
	ld a,$82
	ld (wScreenTransitionDirection),a
	ld e,SpecialObject.substate
	ld a,$03
	ld (de),a
	ret

; In the process of falling down the cliff, after a screen transition happened.
@substate3:
	; Wait for transition to finish
	ld a,(wScrollMode)
	cp $01
	ret nz

	call @getLengthOfCliff

	; Set his y position to the position he'll land at, and set his z position to the
	; equivalent height needed to appear to not have moved.
	ld h,d
	ld l,SpecialObject.yh
	ld a,(hl)
	sub b
	ld (hl),b
	ld l,SpecialObject.zh
	ld (hl),a

	; Re-enable terrain effects (shadow)
	ld l,SpecialObject.visible
	set 6,(hl)

	; Go to substate 1 to complete the fall.
	ld l,SpecialObject.substate
	ld (hl),$01
	ret

;;
; Calculates the number of cliff tiles Link will need to pass through.
;
; @param[out]	a	Number of cliff tiles that Link must pass through
; @param[out]	bc	Position of the tile that will be landed on
; @param[out]	zflag	Set if there will be a screen transition before hitting the ground
@getLengthOfCliff:
	; Get Link's position in bc
	ld h,d
	ld l,SpecialObject.yh
	ldi a,(hl)
	add $05
	ld b,a
	inc l
	ld c,(hl)

	; Determine direction he's moving in based on angle
	ld l,SpecialObject.angle
	ld a,(hl)
	add a
	swap a
	and $03
	ld hl,@offsets
	rst_addDoubleIndex

	ldi a,(hl)
	ldh (<hFF8D),a ; [hFF8D] = y-offset to add to get the next tile's position
	ld a,(hl)
	ldh (<hFF8C),a ; [hFF8C] = x-offset to add to get the next tile's position
	ld a,$01
	ldh (<hFF8B),a ; [hFF8B] = how many tiles away the one we're checking is

@nextTile:
	; Get next tile's position
	ldh a,(<hFF8D)
	add b
	ld b,a
	ldh a,(<hFF8C)
	add c
	ld c,a

	call checkTileCollisionAt_allowHoles
	jr nc,@noCollision

	; If this tile is breakable, we can land here
	ld a, $80 | BREAKABLETILESOURCE_LANDED
	call tryToBreakTile
	jr c,@landHere

	; Even if it's solid and unbreakable, check if it's an exception (raisable floor)
	ldh a,(<hFF92)
	ld hl,landableTileFromCliffExceptions
	call findByteInCollisionTable
	jr c,@landHere

	; Try the next tile
	ldh a,(<hFF8B)
	inc a
	ldh (<hFF8B),a
	jr @nextTile

@noCollision:
	; Check if we've gone out of bounds (tile index $00)
	call getTileAtPosition
	or a
	ret z

@landHere:
	ldh a,(<hFF8B)
	cp $0b
	jr c,+
	ld a,$0b
+
	or a
	ret

@offsets:
	.db $f8 $00 ; DIR_UP
	.db $00 $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT

.include {"{GAME_DATA_DIR}/tile_properties/landableTilesFromCliffs.s"}
