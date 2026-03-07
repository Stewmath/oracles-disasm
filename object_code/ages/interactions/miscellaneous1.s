; ==================================================================================================
; INTERAC_MISCELLANEOUS_1
; ==================================================================================================
interactionCode6b:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw interaction6b_subid00
	.dw interaction6b_subid01
	.dw interaction6b_subid02
	.dw interaction6b_subid03
	.dw interaction6b_subid04
	.dw interaction6b_subid05
	.dw interaction6b_subid06
	.dw interaction6b_subid07
	.dw interaction6b_subid08
	.dw interaction6b_subid09
	.dw interaction6b_subid0a
	.dw interaction6b_subid0b
	.dw interaction6b_subid0c
	.dw interaction6b_subid0d
	.dw interaction6b_subid0e
	.dw interaction6b_subid0f
	.dw interaction6b_subid10
	.dw interaction6b_subid11
	.dw interaction6b_subid12
	.dw interaction6b_subid13
	.dw interaction6b_subid14
	.dw interaction6b_subid15
	.dw interaction6b_subid16


; Handles showing Impa's "Help" text when Link's about to screen transition
interaction6b_subid00:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete
@state1:
	call checkInteractionSubstate
	jr nz,@substate1

@substate0:
	call interaction6b_checkLinkPressedUpAtScreenEdge
	ret z

	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld e,Interaction.counter1
	ld a,30
	ld (de),a
	ld bc,TX_0100
	call showText
	jp interactionIncSubstate

@substate1:
	call @decCounter1IfTextNotActive
	ret nz

	xor a
	ld (wDisabledObjects),a
	push de

	ld hl,@simulatedInput
	ld a,:@simulatedInput
	call setSimulatedInputAddress

	pop de
	call getThisRoomFlags
	set 6,(hl)

	jp interactionDelete

@decCounter1IfTextNotActive:
	ld a,(wTextIsActive)
	or a
	ret nz
	jp interactionDecCounter1

@simulatedInput:
	dwb 8, BTN_UP
	.dw $ffff


; Spawns nayru, ralph, animals before she's possessed
interaction6b_subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld a,GLOBALFLAG_INTRO_DONE
	call checkGlobalFlag
	jr nz,@delete

	ld hl,objectData.nayruAndAnimalsInIntro
	call parseGivenObjectData
	ld a,INTERAC_NAYRU
	ld (wInteractionIDToLoadExtraGfx),a

	push de
	ld a,UNCMP_GFXH_AGES_IMPA_FAINTED
	call loadUncompressedGfxHeader
	pop de

@delete:
	jp interactionDelete

@state1:
	; Never executed (deletes self before running state 1)
	call interactionRunScript
	jp c,interactionDelete
	ret


; Script for cutscene with Ralph outside Ambi's palace, before getting mystery seeds
interaction6b_subid02:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,TREASURE_MYSTERY_SEEDS
	call checkTreasureObtained
	jp c,interactionDelete

@loadScript:
	jp interaction6b_loadScript

@state1:
	call interactionRunScript
	jp c,interactionDelete
	ret


; Seasons troupe member with guitar / tambourine?
interaction6b_subid03:
interaction6b_subid12:
	call checkInteractionState
	jp nz,interactionAnimate

@state0:
	call interaction6b_initGraphicsAndIncState
	jp objectSetVisible82


; Script for cutscene where moblins attack maku sapling
interaction6b_subid04:
	call checkInteractionState
	jr nz,@state1

@state0:
	xor a
	ld (wccd4),a
	call interaction6b_loadScript
@state1:
	call interactionRunScript
	jp c,interactionDelete
	ret


; Cutscene in intro where lightning strikes a guy
interaction6b_subid05:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw interaction6b_subid02@loadScript
	.dw @state1

@state1:
	call checkInteractionSubstate
	jr nz,@substate1

@substate0:
	call interactionRunScript
	ret nc

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$01
	inc l
	ld l,Interaction.counter2
	ld (hl),$00

@substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),20
	inc l
	ld a,(hl)
	cp $04
	jp nz,++

	ld a,$03
	ld (wTmpcfc0.introCutscene.cfd1),a
	jp interactionDelete
++
	inc (hl)
	ld hl,@lightningPositions
	rst_addDoubleIndex
	ld b,(hl)
	inc hl
	ld c,(hl)
	call getFreePartSlot
	ret nz
	ld (hl),PART_LIGHTNING
	inc l
	inc (hl)
	inc l
	inc (hl)
	ld l,Part.yh
	ld (hl),b
	ld l,Part.xh
	ld (hl),c
	ret

@lightningPositions:
	.db $28 $28
	.db $58 $38
	.db $38 $68
	.db $48 $98


; Manages cutscene after beating d3
interaction6b_subid06:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,(wEssencesObtained)
	bit 2,a
	jr z,@delete

	call getThisRoomFlags
	and $40
	jp nz,@delete

	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),90
	ret

@delete:
	jp interactionDelete

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionDecCounter1
	ret nz

	xor a
	ld hl,wGenericCutscene.cbb3
	ld (hl),a
	dec a
	ld hl,wGenericCutscene.cbba
	ld (hl),a
	ld a,SND_LIGHTNING
	call playSound
	jp interactionIncSubstate

@substate1:
	ld hl,wGenericCutscene.cbb3
	ld b,$01
	call flashScreen
	ret z
	call interactionIncSubstate
	jp fadeoutToWhite

@substate2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	push de

	; Load ambi's palace room
	ld bc,$0116
	call disableLcdAndLoadRoom
	call resetCamera

	ld hl,objectData.ambiAndNayruInPostD3Cutscene
	call parseGivenObjectData

	ld a,$02
	call loadGfxRegisterStateIndex
	pop de
	ld a,MUS_DISASTER
	call playSound
	jp fadeinFromWhite


; A seed satchel that slowly falls toward Link. Unused?
interaction6b_subid07:
	call checkInteractionState
	jr nz,@state1

@state0:
	call interaction6b_initGraphicsAndIncState
	ld bc,$0000
	ld hl,w1Link.yh
	call objectTakePositionWithOffset
	ld h,d
	ld l,Interaction.zh
	ld (hl),$a8

@state1:
	ld h,d
	ld l,Interaction.zh
	ldd a,(hl)
	cp $f4
	jp nc,interactionDelete

	ld bc,$0080
	ld a,c
	add (hl)
	ldi (hl),a
	ld a,b
	adc (hl)
	ld (hl),a
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; Part of the cutscene where tokays steal your stuff?
interaction6b_subid08:
	call checkInteractionState
	jr nz,@state1

@state0:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete
	jp interactionIncState

@state1:
	ld a,(wTmpcfc0.genericCutscene.cfd1)
	or a
	jp nz,interactionDelete

	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jp z,playWaveSoundAtRandomIntervals
	dec (hl)
	ret


; Shovel that Rosa gives to you in linked game
interaction6b_subid09:
	call checkInteractionState
	jr nz,@state1

@state0:
	call interaction6b_initGraphicsAndIncState
	ld bc,$3848
	call interactionSetPosition
	jp objectSetVisible80

@state1:
	; If [rosa.var3e] == 0, return; if $ff, delete self.
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld l,Interaction.var3e
	ld a,(hl)
	ld c,a
	or a
	ret z
	inc a
	jp z,interactionDelete

	; If rosa's direction is nonzero, change visibility
	ld l,Interaction.direction
	ld a,(hl)
	or a
	call nz,objectSetVisible83

	; Copy rosa's position, with x-offset [rosa.var3e]
	ld b,$00
	jp objectTakePositionWithOffset


; Flippers, cheval rope, and bomb treasures
interaction6b_subid0a:
interaction6b_subid0b:
interaction6b_subid0c:
	call checkInteractionState
	jr nz,@state1

@state0:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_ITEM,a
	jp nz,interactionDelete
	ld e,Interaction.subid
	ld a,(de)
	sub $0a
	inc e
	ld (de),a
	call interaction6b_initGraphicsAndLoadScript

@state1:
	call interactionRunScript
	jr nc,++
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionDelete
++
	call checkInteractionSubstate
	jp z,interactionAnimateAsNpc
	ret


; Blocks that move over when pulling lever to get flippers
interaction6b_subid0d:
	call checkInteractionState
	jr nz,@state1

@state0:
	call interaction6b_initGraphicsAndIncState
	ld a,PALH_a3
	call loadPaletteHeader

	ld a,$06
	call objectSetCollideRadius

	ld l,Interaction.xh
	ld a,(hl)
	cp $c0
	jr nz,+
	ld l,Interaction.var03
	ld (hl),$01
+
	ld l,Interaction.var3d
	ld (hl),a

@state1:
	ld a,(w1Link.state)
	cp $01
	ret nz

	ld a,(wLever1PullDistance)
	or a
	jr z,@updateXAndDraw

	and $7c
	rrca
	rrca
	ld b,a
	ld e,Interaction.var03
	ld a,(de)
	or a
	ld a,b
	jr nz,@updateXAndDraw

	; For the one on the left, invert direction
	cpl
	inc a
	cp $fe
	call nc,@checkLinkSquished

@updateXAndDraw:
	ld h,d
	ld l,Interaction.var3d
	add (hl)
	ld l,Interaction.xh
	ld (hl),a
	jp interactionAnimateAsNpc

;;
@checkLinkSquished:
	push af
	ld a,(wLinkInAir)
	or a
	jr nz,@ret

	ld a,$08
	ld bc,$38b8
	ld hl,w1Link.yh
	call checkObjectIsCloseToPosition
	jr nc,@ret

	xor a
	ld (wcc50),a
	ld a,LINK_STATE_SQUISHED
	ld (wLinkForceState),a
@ret:
	pop af
	ret


; Stone statue of Link that appears unconditionally
interaction6b_subid0e:
	call checkInteractionState
	jr nz,@state1

@state0: ; Also called by subid $15's state 0
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	ld a,PALH_c7
	jr nz,+
	dec a
+
	call loadPaletteHeader
	call interaction6b_initGraphicsAndIncState
	ld bc,$080a
	call objectSetCollideRadii

	; Check for mermaid statue tile to change appearance if necessary
	call objectGetShortPosition
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	cp $f9
	ld a,$04
	jr nz,+
	inc a
+
	call interactionSetAnimation

@state1: ; Also used as subid $15's state 1
	call interactionAnimateAsNpc
	ld h,d

	; No terrain effects
	ld l,Interaction.visible
	res 6,(hl)
	ret


; Switch that opens path to Nuun Highlands
interaction6b_subid0f:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a

	call getThisRoomFlags
	and $40
	jp nz,interactionDelete

	call getFreePartSlot
	ret nz
	ld (hl),PART_SWITCH
	inc l
	ld (hl),$01
	jp objectCopyPosition

@state1:
	ld a,(wSwitchState)
	or a
	ret z

	; Switch hit; start cutscene
	ld a,$81
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld (wDisableScreenTransitions),a

	call getThisRoomFlags
	set 6,(hl)
	call interactionIncState
	ld hl,mainScripts.interaction6b_bridgeToNuunSimpleScript
	jp interactionSetSimpleScript

@state2:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr z,++
	dec a
	ld (de),a
	ret
++
	ret nz
	call interactionRunSimpleScript
	ret nc

	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld (wDisableScreenTransitions),a
	jp interactionDelete


; Unfinished stone statue of Link in credits cutscene
interaction6b_subid10:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,PALH_c8
	call loadPaletteHeader
	call interaction6b_initGraphicsAndLoadScript
	jp objectSetVisiblec2

@state1:
	ld e,Interaction.substate
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
	call interactionRunScript
	ld a,(wTmpcfc0.genericCutscene.state)
	cp $02
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$20
	ret

@substate1:
	call interactionDecCounter1
	jr nz,++
	ld a,$03
	ld (wTmpcfc0.genericCutscene.state),a
	jp interactionIncSubstate
++
	ld a,(hl)
	and $07
	ret nz
	ld l,Interaction.zh
	dec (hl)
	ret

@substate2:
	call interactionRunScript
	ret nc
	jp interactionIncSubstate

@substate3:
	call interactionAnimateBasedOnSpeed
	call objectApplySpeed
	ld a,(wTmpcfc0.genericCutscene.state)
	cp $06
	ret nz
	call interactionIncSubstate
	ld bc,$4084
	jp interactionSetPosition

@substate4:
	ld a,(wTmpcfc0.genericCutscene.state)
	cp $07
	ret nz
	jp interactionIncSubstate

@substate5:
	ld c,$01
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),30
	call objectSetVisible82
	ld a,$05
	jp interactionSetAnimation

@substate6:
	call interactionDecCounter1
	jr nz,++
	xor a
	ld (wGfxRegs1.SCY),a
	jp interactionIncSubstate
++
	ld a,(hl)
	and $01
	jr nz,+
	ld a,$ff
+
	ld (wGfxRegs1.SCY),a

@substate7:
	ret


; Triggers cutscene after beating Jabu-Jabu
interaction6b_subid11:
	ld a,(wEssencesObtained)
	bit 6,a
	jr z,@delete

	call getThisRoomFlags
	and $40
	jr nz,@delete

	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,CUTSCENE_BLACK_TOWER_COMPLETE
	ld (wCutsceneTrigger),a
@delete:
	jp interactionDelete


; Goron bomb statue (left/right)
interaction6b_subid13:
interaction6b_subid14:
	call checkInteractionState
	jr nz,@state1

@state0:
	call interaction6b_initGraphicsAndIncState

	; Make this position solid
	call objectGetShortPosition
	ld c,a
	ld b,>wRoomLayout
	ld a,$00
	ld (bc),a
	ld b,>wRoomCollisions
	ld a,$0f
	ld (bc),a
@state1:
	jp interactionPushLinkAwayAndUpdateDrawPriority


; Stone statue of Link, as seen in-game
interaction6b_subid15:
	call checkInteractionState
	jp nz,interaction6b_subid0e@state1

@state0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	call objectGetShortPosition
	ld h,>wRoomCollisions
	ld l,a
	ld (hl),$0f
	jp interaction6b_subid0e@state0


; A flame that appears for [counter1] frames.
interaction6b_subid16:
	call checkInteractionState
	jr nz,@state1

@state0:
	call interaction6b_initGraphicsAndIncState
	call objectSetVisible81
	ld a,SND_LIGHTTORCH
	jp playSound

@state1:
	call interactionDecCounter1
	jp z,interactionDelete
	jp interactionAnimate


;;
interaction6b_initGraphicsAndIncState:
	call interactionInitGraphics
	jp interactionIncState

;;
interaction6b_initGraphicsAndLoadScript:
	call interactionInitGraphics

;;
interaction6b_loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,interaction6b_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

;;
; @param[out]	zflag	nz if Link pressed up at screen edge
interaction6b_checkLinkPressedUpAtScreenEdge:
	ld a,(wScrollMode)
	cp $01
	jr nz,+

	ld hl,w1Link.yh
	ld a,(hl)
	cp $07
	jr c,++
+
	xor a
	ret
++
	ld a,(wKeysPressed)
	and BTN_UP
	ret

interaction6b_scriptTable:
	.dw mainScripts.interaction6b_stubScript
	.dw mainScripts.interaction6b_stubScript
	.dw mainScripts.interaction6b_subid02Script
	.dw mainScripts.interaction6b_stubScript
	.dw mainScripts.interaction6b_subid04Script
	.dw mainScripts.interaction6b_subid05Script
	.dw mainScripts.interaction6b_stubScript
	.dw mainScripts.interaction6b_stubScript
	.dw mainScripts.interaction6b_stubScript
	.dw mainScripts.interaction6b_stubScript
	.dw mainScripts.interaction6b_subid0aScript
	.dw mainScripts.interaction6b_subid0aScript
	.dw mainScripts.interaction6b_subid0aScript
	.dw mainScripts.interaction6b_stubScript
	.dw mainScripts.interaction6b_stubScript
	.dw mainScripts.interaction6b_stubScript
	.dw mainScripts.interaction6b_subid10Script
