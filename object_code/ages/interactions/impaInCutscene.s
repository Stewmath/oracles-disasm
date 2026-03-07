; ==================================================================================================
; INTERAC_IMPA_IN_CUTSCENE
;
; Variables:
;   var3b: For subid 1, saves impa's "oamTileIndexBase" so it can be restored after Impa
;          gets up (she references a different sprite sheet for her "collapsed" sprite)
; ==================================================================================================
interactionCode31:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw impaState1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2
	call @initSubid
	ld e,Interaction.enabled
	ld a,(de)
	or a
	jp nz,objectMarkSolidPosition
	ret

@initSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @init0
	.dw @init1
	.dw @init2
	.dw @init3
	.dw @init4
	.dw @init5
	.dw @loadScript
	.dw @init7
	.dw @init8
	.dw @init9
	.dw @initA

@init0:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete

	; Load a custom palette and use it for possessed impa
	ld a,PALH_97
	call loadPaletteHeader
	ld e,Interaction.oamFlags
	ld a,$07
	ld (de),a

	ld hl,objectData.impaOctoroks
	call parseGivenObjectData

	ld a,LINK_STATE_08
	call setLinkIDOverride
	ld l,<w1Link.subid
	ld (hl),$01
	jr @loadScript

@init1:
	ld h,d
	ld l,Interaction.oamTileIndexBase
	ld a,(hl)
	ld l,Interaction.var3b
	ld (hl),a

	call impaLoadCollapsedGraphic

@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,impaScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@init2:
	ld h,d
	ld l,Interaction.counter1
	ld (hl),$1e
	jp objectSetVisible82

@init7:
	; Delete self if Zelda hasn't been kidnapped by vire yet, or she's been rescued
	; already, or this isn't a linked game
	ld a,(wEssencesObtained)
	bit 2,a
	jp z,interactionDelete
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED
	call checkGlobalFlag
	ld a,$09
	jr z,@setAnimationAndLoadScript

	ld e,Interaction.xh
	ld a,$38
	ld (de),a

	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	ld a,$02
	jr z,@setAnimationAndLoadScript

	ld a,$48
	ld (de),a ; [xh] = $48
	ld e,Interaction.yh
	ld a,$58
	ld (de),a ; [yh] = $58

	ld a,$81
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld a,$00
	ld (wScrollMode),a
	ld hl,$cfd0
	ld b,$10
	call clearMemory

	ldbc INTERAC_ZELDA, $06
	call objectCreateInteraction
	ld l,Interaction.yh
	ld (hl),$8c
	ld l,Interaction.xh
	ld (hl),$50

	ld a,$02
	jr @setAnimationAndLoadScript

@init3:
	ld a,$03

@setAnimationAndLoadScript:
	call interactionSetAnimation
	call objectSetVisible82
	jr @loadScript

@init4:
	call checkIsLinkedGame
	jp nz,interactionDelete
	xor a
	ld ($cfc0),a

@preBlackTowerCutscene:
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDelete
	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	jp nz,interactionDelete
	jp @loadScript

@init5:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,$03
	call interactionSetAnimation
	jr @preBlackTowerCutscene

@initA:
	ld a,$02
	jp interactionSetAnimation

@init9:
	call checkIsLinkedGame
	jp z,interactionDelete

@init8:
	ld a,$03
	call interactionSetAnimation
	call @loadScript

impaState1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw impaSubid0
	.dw impaSubid1
	.dw impaSubid2
	.dw impaAnimateAndRunScript
	.dw impaSubid4
	.dw impaSubid5
	.dw impaAnimateAndRunScript
	.dw impaSubid7
	.dw impaSubid8
	.dw impaSubid9
	.dw interactionAnimate

;;
; Possessed Impa.
;
; Variables:
;   var37-var3a: Last frame's Y, X, and Direction values. Used for checking whether to
;                update Impa's animation (update if any one has changed).
impaSubid0:
	ld e,Interaction.substate
	ld a,(de)
	cp $0e
	jr nc,+

	ld hl,wActiveMusic
	ld a,MUS_FAIRY_FOUNTAIN
	cp (hl)
	jr z,+

	ld a,(wActiveRoom)
	cp $39
	jr z,+
	cp $49
	jr z,+

	ld a,MUS_FAIRY_FOUNTAIN
	ld (hl),a
	call playSound
	ld a,$03
	call setMusicVolume

	ld e,Interaction.substate
+
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
	.dw @substate8
	.dw @substate9
	.dw @substateA
	.dw @substateB
	.dw @substateC
	.dw @substateD
	.dw @substateE
	.dw @substateF
	.dw impaRet


; Running a script until Impa joins Link
@substate0:
	call impaAnimateAndRunScript
	ret nc

; When the script has finished, make Impa follow Link and go to substate 1

	xor a
	ld (wUseSimulatedInput),a
	call setLinkIDOverride
	ld l,<w1Link.direction
	ld (hl),DIR_UP

@beginFollowingLink:
	call interactionIncSubstate
	call makeActiveObjectFollowLink
	call interactionSetAlwaysUpdateBit
	call objectSetReservedBit1

	ld l,Interaction.var37
	ld e,Interaction.yh
	ld a,(de)
	ldi (hl),a
	ld e,Interaction.xh
	ld a,(de)
	ldi (hl),a
	ld e,Interaction.direction
	ld a,(w1Link.direction)
	ld (de),a
	ld (hl),$00

	call interactionSetAnimation
	call objectSetVisiblec3
	jp objectSetPriorityRelativeToLink_withTerrainEffects

; Impa following Link (before stone is pushed)
@substate1:
	call objectSetPriorityRelativeToLink_withTerrainEffects
	call impaCheckApproachedStone
	jr nc,@updateAnimationWhileFollowingLink

; Link has approached the stone; trigger cutscene.

	ld a,LINK_STATE_08
	call setLinkIDOverride
	ld l,<w1Link.subid
	ld (hl),$02

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$1e
	ld l,Interaction.enabled
	res 7,(hl)

	ld a,SND_CLINK
	call playSound

	ld bc,-$1c0
	call objectSetSpeedZ
	call clearFollowingLinkObject
	call @setAngleTowardStone
	call convertAngleDeToDirection
	jp interactionSetAnimation

@updateAnimationWhileFollowingLink:
	; Nothing to do here except check whether to update the animation. (It must update
	; if her position or direction has changed.)
	call impaUpdateAnimationIfDirectionChanged
	ld h,d
	ld l,Interaction.yh
	ld a,(hl)
	ld b,a
	ld l,Interaction.var37
	cp (hl)
	jr nz,++

	ld l,Interaction.xh
	ld a,(hl)
	ld c,a
	ld l,Interaction.var38
	cp (hl)
	ret z
++
	ld l,Interaction.var37
	ld (hl),b
	inc l
	ld (hl),c
	call interactionAnimate
	jp interactionAnimate

;;
@setAngleTowardStone:
	ldbc $38,$38
	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	ret

; Jumping after spotting stone
@substate2:
	call impaAnimateAndDecCounter1
	ret nz

	; Wait until she lands
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$0a
	ret

@substate3:
	call impaAnimateAndDecCounter1
	ret nz

	ld (hl),$14

	ld bc,TX_0104
	call showText
	jp interactionIncSubstate

@substate4:
	call interactionDecCounter1IfTextNotActive
	ret nz

	ld l,Interaction.speed
	ld (hl),SPEED_300
	jp interactionIncSubstate

; Moving toward stone
@substate5:
	call interactionAnimate3Times
	call objectApplySpeed
	call @setAngleTowardStone

	ld a,$02
	ldh (<hFF8B),a
	ldbc $38,$38
	ld h,d
	ld l,Interaction.yh
	call checkObjectIsCloseToPosition
	ret nc

; Reached the stone

	ld h,d
	call interactionIncSubstate
	ld a,$38
	ld l,Interaction.yh
	ldi (hl),a
	inc l
	ld (hl),a
	ld l,Interaction.counter1
	ld (hl),$1e
	xor a
	jp interactionSetAnimation

@substate6:
	call impaAnimateAndDecCounter1
	ret nz

	; Start a jump
	ld (hl),$1e
	ld bc,-$180
	call objectSetSpeedZ
	jp interactionIncSubstate

; Jumping in front of stone
@substate7:
	call impaAnimateAndDecCounter1
	ret nz

	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$0a
	ret

@substate8:
	call interactionDecCounter1
	ret nz

	ld (hl),$1e
	call interactionIncSubstate
	ld bc,TX_0105
	jp showText

@substate9:
	call interactionDecCounter1IfTextNotActive
	ret nz

	ld hl,$cfd0
	ld (hl),$02
	ld hl,mainScripts.impaScript_moveAwayFromRock
	call interactionSetScript
	jp interactionIncSubstate

; Moving away from rock (the previously loaded script handles this)
@substateA:
	call impaAnimateAndRunScript
	ret nc

; Done moving away; return control to Link

	xor a
	call setLinkIDOverride
	ld l,<w1Link.direction
	ld (hl),DIR_UP
	ld hl,mainScripts.impaScript_waitForRockToBeMoved
	call interactionSetScript
	jp interactionIncSubstate

; Waiting for Link to start pushing the rock
@substateB:
	call interactionAnimateAsNpc
	call interactionRunScript
	call impaPreventLinkFromLeavingStoneScreen
	ld a,($cfd0)
	cp $06
	ret nz

; The rock has started moving.

	ld hl,mainScripts.impaScript_rockJustMoved
	call interactionSetScript
	jp interactionIncSubstate

@substateC:
	call impaAnimateAndRunScript
	ret nc
	xor a
	call setLinkIDOverride
	ld l,<w1Link.direction
	ld (hl),DIR_DOWN
	jp @beginFollowingLink

; Following Link, waiting for signal to begin the part of the cutscene where she reveals
; she's evil
@substateD:
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld a,($cfd0)
	cp $09
	jp nz,@updateAnimationWhileFollowingLink

	; Start the next part of the cutscene
	call interactionIncSubstate
	call clearFollowingLinkObject
	ldbc $68,$38
	call interactionSetPosition
	ld hl,mainScripts.impaScript_revealPossession
	jp interactionSetScript

@substateE:
	call impaAnimateAndRunScript
	ret nc

; Impa has just moved into the corner, Veran will now come out.

	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld a,$05
	call interactionSetAnimation

	ld b,INTERAC_GHOST_VERAN
	call objectCreateInteractionWithSubid00

	ld a,SND_BOSS_DEAD
	call playSound
	jp objectSetVisiblec2

@substateF:
	call interactionAnimate
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	ret nz
	call interactionIncSubstate

;;
; Changes impa's "oamTileIndexBase" to reference her "collapsed" graphic, which is not in
; her normal sprite sheet.
impaLoadCollapsedGraphic:
	ld l,Interaction.oamFlags
	ld (hl),$0a
	ld l,Interaction.oamTileIndexBase
	ld (hl),$60

impaRet:
	ret


;;
; Impa talking to you after Nayru is kidnapped
impaSubid1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw impaSubid1Substate2

@substate0:
	ld a,($cfd0)
	cp $20
	jp nz,interactionAnimate

	call interactionIncSubstate
	ld e,Interaction.xh
	ld a,(de)
	ld l,Interaction.var3d
	ld (hl),a
	ld l,Interaction.counter1
	ld (hl),$3c
	ret

@substate1:
	call interactionDecCounter1
	jr nz,interactionOscillateXRandomly
	jp interactionIncSubstate

;;
; Uses var3d as the interaction's "base" position, and randomly shifts this position left
; by one or not at all.
interactionOscillateXRandomly:
	call getRandomNumber
	and $01
	sub $01
	ld h,d
	ld l,Interaction.var3d
	add (hl)
	ld l,Interaction.xh
	ld (hl),a
	ret

impaSubid1Substate2:
	call interactionRunScript
	jp c,interactionDelete
	ld e,Interaction.counter2
	ld a,(de)
	or a
	jp nz,interactionAnimate2Times
	jp interactionAnimate

;;
; Impa in the credits cutscene
impaSubid2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw impaAnimateAndRunScript
	.dw impaSubid2Substate4
	.dw impaSubid2Substate5
	.dw impaSubid2Substate6
	.dw impaSubid2Substate7

@substate0:
	call interactionDecCounter1IfPaletteNotFading
	ret nz
	ld (hl),$3c
	call interactionIncSubstate
	ld a,$50
	ld bc,$6050
	jp createEnergySwirlGoingIn

@substate1:
	call interactionDecCounter1
	ret nz
	ld hl,wTmpcbb3
	xor a
	ld (hl),a
	dec a
	ld (wTmpcbba),a
	jp interactionIncSubstate

@substate2:
	ld hl,wTmpcbb3
	ld b,$02
	call flashScreen
	ret z

	call interactionIncSubstate
	call interactionCode31@loadScript
	ld a,$01
	ld ($cfc0),a
	jp fadeinFromWhite

;;
impaAnimateAndRunScript:
	call interactionAnimateBasedOnSpeed
	jp interactionRunScript


impaSubid2Substate4:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$02

impaSetVisibleAndJump:
	call objectSetVisiblec2
	ld bc,-$180
	jp objectSetSpeedZ

impaSubid2Substate5:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionDecCounter1
	jr nz,impaSetVisibleAndJump

	call objectSetVisible82
	ld h,d
	ld l,Interaction.var38
	ld (hl),$10
	jp interactionIncSubstate

impaSubid2Substate6:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz

	ld (hl),$10

	ld l,Interaction.counter2
	ld a,(hl)
	inc (hl)
	cp $02
	jr z,@nextState
	or a
	ld a,$03
	jr z,+
	xor $02
+
	ld l,Interaction.substate
	dec (hl)
	dec (hl)
	jp interactionSetAnimation

@nextState:
	ld (hl),$00
	ld a,$02
	ld ($cfc0),a
	jp interactionIncSubstate

impaSubid2Substate7:
	call impaAnimateAndRunScript
	ld a,($cfc0)
	cp $03
	ret c
	jpab scriptHelp.turnToFaceSomething

;;
; Impa tells you about Ralph's heritage (unlinked)
impaSubid4:
	call checkInteractionSubstate
	jr nz,@substate1

@substate0:
	; Wait for Link to move a certain distance down
	ld hl,w1Link.yh
	ldi a,(hl)
	cp $60
	ret c

	ld l,<w1Link.zh
	bit 7,(hl)
	ret nz
	call checkLinkCollisionsEnabled
	ret nc

	call resetLinkInvincibility
	call setLinkForceStateToState08
	inc a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionIncSubstate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionRunScript
	jp c,interactionDelete
	call interactionAnimateBasedOnSpeed
	ld e,Interaction.var38
	ld a,(de)
	rst_jumpTable
	.dw @thing0
	.dw @thing1
	.dw @thing2
	.dw @thing3
	.dw @thing4

@thing0:
	ld a,($cfc0)
	rrca
	ret nc
	ld e,Interaction.var39
	ld a,$10
	ld (de),a
	jr @incVar38

; Move Link horizontally toward Impa
@thing1:
	ld h,d
	ld l,Interaction.var39
	dec (hl)
	ret nz

	ld a,(w1Link.xh)
	sub $50
	ld b,a
	add $02
	cp $05
	jr c,@incVar38

	ld a,b
	bit 7,a
	ld b,$18
	jr z,+

	ld b,$08
	cpl
	inc a
+
	ld (wLinkStateParameter),a
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a

	ld hl,w1Link.angle
	ld a,b
	ldd (hl),a
	swap a
	rlca
	ld (hl),a

@incVar38:
	ld h,d
	ld l,Interaction.var38
	inc (hl)
	ret

; Move Link vertically toward Impa
@thing2:
	ld a,(w1Link.state)
	cp LINK_STATE_FORCE_MOVEMENT
	ret z

	ld a,(w1Link.yh)
	sub $48
	ld (wLinkStateParameter),a
	xor a
	ld hl,w1Link.direction
	ldi (hl),a
	ld (hl),a
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	jp @incVar38

@thing3:
	ld a,(w1Link.state)
	cp LINK_STATE_FORCE_MOVEMENT
	ret z
	call setLinkForceStateToState08
	jp @incVar38

@thing4:
	ret

;;
; Like above (explaining ralph's heritage), but for linked game
impaSubid5:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionRunScript
	jr nc,++

	; Script over
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call setGlobalFlag
	jp interactionDelete
++
	call interactionAnimateBasedOnSpeed
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,($cfd0)
	cp $04
	ret nz

	ld a,$29
	ld (wLinkStateParameter),a
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,$10
	ld (w1Link.angle),a
	jp interactionIncSubstate

@substate1:
	ld a,(w1Link.state)
	cp LINK_STATE_FORCE_MOVEMENT
	ret z
	call setLinkForceStateToState08
	jp interactionIncSubstate

@substate2:
	ret

;;
; Impa tells you that zelda's been kidnapped by Vire
impaSubid7:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp c,interactionDelete

	ld a,GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED
	call checkGlobalFlag
	jp z,interactionAnimateAsNpc

	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jp nz,interactionAnimate
	jp npcFaceLinkAndAnimate

;;
impaSubid8:
	call impaAnimateAndRunScript
	jp c,interactionDelete
	ret

;;
; Impa tells you that Zelda's been kidnapped by Twinrova
impaSubid9:
	ld e,Interaction.var38
	ld a,(de)
	or a
	jr z,++
	callab scriptHelp.objectWritePositionTocfd5
++
	jp impaAnimateAndRunScript

;;
; Checks that an object is within [hFF8B] pixels of a position on both axes.
;
; @param	bc	Target position
; @param	hl	Object's Y position
; @param	hFF8B	Range we must be within on each axis
; @param[out]	cflag	c if the object is within [hFF8B] pixels of the position
checkObjectIsCloseToPosition:
	push hl
	call @checkComponent
	pop hl
	ret nc

	inc l
	inc l
	ld b,c

;;
; @param	b	Position
; @param	hl	Object position component
; @param	hFF8B
; @param[out]	cflag	Set if we're within [hFF8B] pixels of 'b'.
@checkComponent:
	ld a,b
	sub (hl)
	ld hl,hFF8B
	ld b,(hl)
	add b
	ldh (<hFF8D),a

	ld a,b
	add a
	ld b,a
	inc b
	ldh a,(<hFF8D)
	cp b
	ret

;;
impaUpdateAnimationIfDirectionChanged:
	ld h,d
	ld l,Interaction.direction
	ld a,(hl)
	ld l,Interaction.var39
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation

;;
; @param[out]	cflag	c if Link has approached the stone to trigger Impa's reaction
impaCheckApproachedStone:
	ld a,(wActiveRoom)
	cp $59
	jr nz,@notClose

	ld a,(wScrollMode)
	and $01
	ret z

	ld hl,w1Link.yh
	ldi a,(hl)
	cp $58
	jr nc,@notClose
	inc l
	ld a,(hl)
	cp $78
	ret
@notClose:
	xor a
	ret

;;
; @param[out]	zflag	z if counter1 has reached 0.
impaAnimateAndDecCounter1:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	ret z
	dec (hl)
	call interactionAnimate
	or $01
	ret

;;
; Shows text if Link tries to leave the screen with the stone.
impaPreventLinkFromLeavingStoneScreen:
	ld hl,w1Link.yh
	ld a,(hl)
	ld b,$76
	cp b
	jr c,++
	ld a,(wKeysPressed)
	and BTN_DOWN
	jr nz,@showText
++
	ld l,<w1Link.xh
	ld a,(hl)
	ld b,$96
	cp b
	ret c
	ld a,(wKeysPressed)
	and BTN_RIGHT
	ret z
@showText:
	ld (hl),b
	ld bc,TX_010a
	jp showText

impaScriptTable:
	.dw mainScripts.impaScript0
	.dw mainScripts.impaScript1
	.dw mainScripts.impaScript2
	.dw mainScripts.impaScript3
	.dw mainScripts.impaScript4
	.dw mainScripts.impaScript5
	.dw mainScripts.impaScript6
	.dw mainScripts.impaScript7
	.dw mainScripts.impaScript8
	.dw mainScripts.impaScript9
