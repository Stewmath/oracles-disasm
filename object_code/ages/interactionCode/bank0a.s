m_section_free Ages_Interactions_BankA NAMESPACE agesInteractionsBank0a

.include "object_code/common/interactionCode/companionSpawner.s"

; ==============================================================================
; INTERACID_ROSA
; ==============================================================================
interactionCode68:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01

@subid00:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	call checkIsLinkedGame
	jp z,interactionDelete

	ld a,(wEssencesObtained)
	bit 2,a
	jp nz,interactionDelete

	call @initGraphicsAndLoadScript
	call objectSetVisiblec2
	call getThisRoomFlags
	bit 6,a
	jr nz,@@alreadyGaveShovel

	; Spawn shovel object
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_MISCELLANEOUS_1
	inc l
	ld (hl),$09
	ld l,Interaction.relatedObj1+1
	ld a,d
	ld (hl),a
	ret

@@alreadyGaveShovel:
	ld hl,mainScripts.rosa_subid00Script_alreadyGaveShovel
	jp interactionSetScript

@@state1:
	call interactionRunScript
	ld a,TREASURE_SHOVEL
	call checkTreasureObtained
	jp c,npcFaceLinkAndAnimate
	jp interactionAnimateAsNpc


@subid01:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	call @loadScriptFromTableAndInitGraphics
	ld l,Interaction.var37
	ld (hl),$04
	call interactionRunScript
@@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate


; Unused
@initGraphicsAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

@initGraphicsAndLoadScript:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jr @loadScriptAndIncState


@loadScriptFromTableAndInitGraphics:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jr @loadScriptFromTableAndIncState

@loadScriptAndIncState:
	call @getScript
	call interactionSetScript
	jp interactionIncState

@loadScriptFromTableAndIncState:
	call @getScript
	inc e
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@getScript:
	ld a,>TX_1c00
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ret

@scriptTable:
	.dw mainScripts.rosa_subid00Script
	.dw @scriptTable2

@scriptTable2:
	.dw mainScripts.rosa_subid01Script


; ==============================================================================
; INTERACID_RAFTON
;
; Variables:
;   var38: "behaviour" (what he does based on the stage in the game)
; ==============================================================================
interactionCode69:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	; Bit 7 of room flags set when Rafton isn't in this room?
	call getThisRoomFlags
	bit 7,a
	jp nz,interactionDelete

	call interactionInitGraphics
	call objectSetVisiblec2
	ld a,>TX_2700
	call interactionSetHighTextIndex

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01

@initSubid00:
	ld a,GLOBALFLAG_RAFTON_CHANGED_ROOMS
	call checkGlobalFlag
	jp nz,interactionDelete
	ld c,$04
	ld a,TREASURE_ISLAND_CHART
	call checkTreasureObtained
	jr c,@setBehaviour

	dec c
	ld a,GLOBALFLAG_GAVE_ROPE_TO_RAFTON
	call checkGlobalFlag
	jr nz,@setBehaviour

	dec c
	ld a,TREASURE_CHEVAL_ROPE
	call checkTreasureObtained
	jr c,@setBehaviour

	dec c
	ld a,(wEssencesObtained)
	bit 1,a
	jr nz,@setBehaviour
	dec c

@setBehaviour:
	ld h,d
	ld l,Interaction.var38
	ld (hl),c
	jr @loadScript


@initSubid01:
	ld a,GLOBALFLAG_RAFTON_CHANGED_ROOMS
	call checkGlobalFlag
	jp z,interactionDelete
	jr @loadScript


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw @runSubid01

@runSubid00:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var38
	ld a,(de)
	cp $04
	jp z,interactionAnimateBasedOnSpeed
	jp interactionAnimateAsNpc

@runSubid01:
	call interactionAnimateAsNpc
	jp interactionRunScript

@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.rafton_subid00Script
	.dw mainScripts.rafton_subid01Script


; ==============================================================================
; INTERACID_CHEVAL
; ==============================================================================
interactionCode6a:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2
	ld a,>TX_2700
	call interactionSetHighTextIndex

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @loadScript

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00

@runSubid00:
	call interactionRunScript
	jp interactionAnimateAsNpc

@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.cheval_subid00Script


; ==============================================================================
; INTERACID_MISCELLANEOUS_1
; ==============================================================================
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
	ld a,INTERACID_NAYRU
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
	ld (hl),PARTID_LIGHTNING
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
	ld (hl),PARTID_SWITCH
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


; ==============================================================================
; INTERACID_FAIRY_HIDING_MINIGAME
; ==============================================================================
interactionCode6c:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw fairyHidingMinigame_subid00
	.dw fairyHidingMinigame_subid01
	.dw fairyHidingMinigame_subid02


; Begins fairy-hiding minigame
fairyHidingMinigame_subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	; Delete self if game shouldn't happen right now
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jp nc,interactionDelete

	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld hl,wTmpcfc0.fairyHideAndSeek.active
	ldi a,(hl)
	or a
	jp z,interactionIncState

	; Minigame already started; spawn in the fairies Link's found.
	ld a,(hl)
	sub $07
	jr nz,@spawn3Fairies

	; Minigame just starting
	ld a,CUTSCENE_FAIRIES_HIDE
	ld (wCutsceneTrigger),a
	ld a,$80
	ld (wMenuDisabled),a
	ld a,DISABLE_COMPANION | DISABLE_LINK
	ld (wDisabledObjects),a
	xor a
	ld (w1Link.direction),a

@spawn3Fairies:
	jp fairyHidingMinigame_spawn3FairiesAndDelete

@state1:
	call fairyHidingMinigame_checkBeginCutscene
	ret nc
	ld a,(wScreenTransitionDirection)
	ld (w1Link.direction),a
	ld a,$01
	ld (wTmpcfc0.fairyHideAndSeek.active),a
	ld hl,mainScripts.fairyHidingMinigame_subid00Script
	jp interactionSetScript

@state2:
	call interactionRunScript
	ret nc
	ld a,CUTSCENE_FAIRIES_HIDE
	ld (wCutsceneTrigger),a
	jp interactionDelete


; Hiding spot for fairy
fairyHidingMinigame_subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call fairyHidingMinigame_checkMinigameActive
	jp nc,interactionDelete

	; [var38] = original tile index
	call objectGetTileAtPosition
	ld e,Interaction.var38
	ld (de),a

	ld e,l
	ld hl,@table
	call lookupKey
	ld e,Interaction.var03
	ld (de),a

	; Delete if already found this fairy
	sub $03
	ld hl,wTmpcfc0.fairyHideAndSeek.foundFairiesBitset
	call checkFlag
	jp nz,interactionDelete

	xor a
	ld (wTmpcfc0.fairyHideAndSeek.cfd2),a
	ld e,Interaction.counter1
	ld a,$0c
	ld (de),a
	jp interactionIncState


; b0: tile position (lookup key)
; b1: value for var03 of fairy to spawn when found (subid is $00)
@table:
	.db $25 $03
	.db $54 $04
	.db $32 $05
	.db $00

@state1:
	; Check if tile changed
	call objectGetTileAtPosition
	ld b,a
	ld e,Interaction.var38
	ld a,(de)
	cp b
	ret z

	call interactionDecCounter1
	ret nz
	call fairyHidingMinigame_checkBeginCutscene
	ret nc
	ld a,$01
	ld (wDisableScreenTransitions),a

; Tile changed; fairy is revealed
@state2:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_FOREST_FAIRY
	ld l,Interaction.var03
	ld e,l
	ld a,(de)
	ld (hl),a
	call objectCreatePuff
	call interactionIncState
	ld hl,mainScripts.fairyHidingMinigame_subid01Script
	jp interactionSetScript

@state3:
	call interactionRunScript
	ret nc

	ld e,Interaction.var03
	ld a,(de)
	sub $03
	ld hl,wTmpcfc0.fairyHideAndSeek.foundFairiesBitset
	call setFlag

	; If found all fairies, warp out
	ld a,(wTmpcfc0.fairyHideAndSeek.foundFairiesBitset)
	cp $07
	jr z,@warpOut

	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld (wDisableScreenTransitions),a
	jr @delete

@warpOut:
	ld hl,@warpDestination
	call setWarpDestVariables
@delete:
	jp interactionDelete

@warpDestination:
	m_HardcodedWarpA ROOM_AGES_082, $00, $64, $03


; Checks for Link leaving the hide-and-seek area
fairyHidingMinigame_subid02:
	ld e,Interaction.state
	ld a,(de)
	or a
	jr z,@state0

@state1:
	call interactionRunScript
	ret nc

	; Clear hide-and-seek-related variables
	ld hl,wTmpcfc0.fairyHideAndSeek.active
	ld b,$10
	call clearMemory
	jp interactionDelete

@state0:
	call fairyHidingMinigame_checkMinigameActive
	jp nc,interactionDelete
	call interactionIncState
	ld hl,mainScripts.fairyHidingMinigame_subid02Script
	jp interactionSetScript

;;
; Spawns the 3 fairies; they should delete themselves if they're not found yet?
fairyHidingMinigame_spawn3FairiesAndDelete:
	ld b,$03

@spawnFairy:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_FOREST_FAIRY
	inc l
	inc (hl)   ; [subid] = $01
	inc l
	dec b
	ld (hl),b  ; [var03] = 0,1,2
	jr nz,@spawnFairy
	jp interactionDelete

;;
; @param[out]	cflag	c if Link is vulnerable (ready to begin cutscene?)
fairyHidingMinigame_checkBeginCutscene:
	call checkLinkVulnerable
	ret nc

	ld a,$80
	ld (wMenuDisabled),a

	ld a,DISABLE_COMPANION | DISABLE_LINK
	ld (wDisabledObjects),a

	call dropLinkHeldItem
	call clearAllParentItems
	call interactionIncState
	scf
	ret

;;
; @param[out]	cflag	c if minigame is active
fairyHidingMinigame_checkMinigameActive:
	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME
	call checkGlobalFlag
	ret nz
	ld a,(wTmpcfc0.fairyHideAndSeek.active)
	rrca
	ret


; ==============================================================================
; INTERACID_POSSESSED_NAYRU
; ==============================================================================
interactionCode6d:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw possessedNayru_subid00
	.dw possessedNayru_ghost
	.dw possessedNayru_ghost


possessedNayru_subid00:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,GLOBALFLAG_BEAT_POSSESSED_NAYRU
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,PALH_85
	call loadPaletteHeader

	ld a,GLOBALFLAG_BEGAN_POSSESSED_NAYRU_FIGHT
	call checkGlobalFlag
	jr nz,@state2

	; Spawn "ghost" veran
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_POSSESSED_NAYRU
	inc l
	ld (hl),$02
	ld l,Interaction.relatedObj1
	ld (hl),Interaction.start
	inc l
	ld (hl),d

	call objectCopyPosition
	call interactionInitGraphics

	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,$0e
	ld (wLinkStateParameter),a

	; Set Link's direction, angle
	ld hl,w1Link.direction
	ld a,(wScreenTransitionDirection)
	ldi (hl),a
	swap a
	rrca
	ld (hl),a

	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call interactionIncState
	call objectSetVisible82
	ld hl,mainScripts.possessedNayru_beginFightScript
	jp interactionSetScript

@state1:
	call interactionRunScript
	ret nc
	call interactionIncState

@state2:
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMYID_VERAN_POSSESSION_BOSS
	call objectCopyPosition
	ld h,d
	ld l,Interaction.state
	ld (hl),$03
	ret

@state3:
	ld a,GLOBALFLAG_BEGAN_POSSESSED_NAYRU_FIGHT
	call setGlobalFlag
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	inc a
	ld (wLoadedTreeGfxIndex),a
	jp interactionDelete


possessedNayru_ghost:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.zh
	ld (hl),-$04
	ret

@state1:
	ld a,Object.var37
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	ret z

	inc (hl)
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_80
	call objectSetVisible81
	ld hl,mainScripts.possessedNayru_veranGhostScript
	jp interactionSetScript

@state2:
	call interactionRunScript
	jp nc,interactionAnimate

	ld a,Object.var37
	call objectGetRelatedObject1Var
	ld (hl),$00
	jp interactionDelete


; ==============================================================================
; INTERACID_NAYRU_SAVED_CUTSCENE
; ==============================================================================
interactionCode6e:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw interaction6e_subid00
	.dw interaction6e_subid01
	.dw interaction6e_subid02
	.dw interaction6e_subid03
	.dw interaction6e_subid04


; Nayru waking up after being freed from possession
interaction6e_subid00:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.yh
	ld (hl),$58
	ld l,Interaction.xh
	ld (hl),$78
	ld l,Interaction.speed
	ld (hl),SPEED_40

	ld l,Interaction.oamFlagsBackup
	ld a,$01
	ldi (hl),a
	ld (hl),a
	ld (wLoadedTreeGfxIndex),a

	ld hl,w1Link.direction
	ld (hl),DIR_UP
	ld l,<w1Link.yh
	ld (hl),$64
	ld l,<w1Link.xh
	ld (hl),$78

	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld b,$10
	call clearMemory
	call setCameraFocusedObjectToLink
	call resetCamera
	ldh a,(<hActiveObject)
	ld d,a
	call fadeinFromWhite
	ld a,$0a
	call interactionSetAnimation
	call objectSetVisible82
	ld hl,mainScripts.interaction6e_subid00Script
	jp interactionSetScript

@state1:
	call interactionRunScript
	jp nc,interactionAnimate
	call interactionIncState
	ld a,$04
	jp fadeoutToWhiteWithDelay

@state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,GLOBALFLAG_BEAT_POSSESSED_NAYRU
	call setGlobalFlag
	ld a,CUTSCENE_NAYRU_WARP_TO_MAKU_TREE
	ld (wCutsceneTrigger),a
	jp interactionDelete


; Queen Ambi
interaction6e_subid01:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.oamFlagsBackup
	ld a,$01
	ldi (hl),a
	ld (hl),a
	call objectSetVisiblec2
	ld hl,mainScripts.interaction6e_subid01Script_part1
	jp interactionSetScript

@state1:
	ld c,$30
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionRunScript
	jr nc,@animate

	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),244

	; Use "direction" variable temporarily as "animation"
	ld l,Interaction.direction
	ld (hl),$05
@animate
	jp interactionAnimate


; Veran circling Ambi (she's turning left and right)
@state2:
	call interactionDecCounter1
	jr z,++

	ld a,(hl)
	cp $c1
	jr nc,@animate
	and $1f
	ret nz

	ld l,Interaction.direction
	ld a,(hl)
	xor $02
	ld (hl),a
	jr @setAnimation
++
	ld l,e
	inc (hl)
	ld a,$06

@setAnimation:
	jp interactionSetAnimation


; Veran in process of possessing Ambi
@state3:
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $07
	jr z,++

	; Shake X position
	ld a,(wFrameCounter)
	rrca
	ret c
	ld e,Interaction.xh
	ld a,(de)
	inc a
	and $01
	add $78
	ld (de),a
	ret
++
	call interactionIncState
	ld l,Interaction.xh
	ld (hl),$78
	ld l,Interaction.oamFlags
	ld a,$06
	ldd (hl),a
	ld (hl),a
	ld hl,mainScripts.interaction6e_subid01Script_part2
	call interactionSetScript

	ld a,SND_LIGHTNING
	call playSound
	ld a,MUS_DISASTER
	call playSound
	ld a,$04
	jp fadeinFromWhiteWithDelay


; Now finished being possessed
@state4:
	ld a,(wPaletteThread_mode)
	or a
	jr nz,++
	ld c,$30
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionRunScript
++
	jp interactionAnimate


; Ghost Veran
interaction6e_subid02:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.speed
	ld (hl),SPEED_200

	ld l,Interaction.angle
	ld (hl),$0e

	ld l,Interaction.counter1
	ld (hl),$48

	ld bc,TX_560c
	call showText

	ld a,SNDCTRL_STOPMUSIC
	call playSound

	jp objectSetVisible81


; Starting to move toward Ambi
@state1:
	ld e,Interaction.counter1
	ld a,(de)
	cp $48
	ld a,SND_BEAM
	call z,playSound
	call interactionDecCounter1
	jr nz,@applySpeedAndAnimate

	ld (hl),$ac

	ld l,Interaction.state
	inc (hl)
	ld l,Interaction.angle
	ld (hl),$16

	; Link moves up, while facing down
	ld hl,w1Link.direction
	ld (hl),DIR_DOWN
	inc l
	ld (hl),ANGLE_UP
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,$04
	ld (wLinkStateParameter),a

	ld a,SND_CIRCLING
	call playSound


; Circling around Ambi
@state2:
	call interactionDecCounter1
	jr z,@beginPossessingAmbi

	ld a,(hl)
	push af
	cp $56
	ld a,SND_CIRCLING
	call z,playSound

	pop af
	rrca
	ld e,Interaction.angle
	jr nc,++
	ld a,(de)
	dec a
	and $1f
	ld (de),a
++
	ld a,$10
	ld bc,$7e78
	call objectSetPositionInCircleArc
	jp interactionAnimate

@beginPossessingAmbi:
	ld (hl),$50

	ld l,e
	inc (hl) ; [state]++

	ld l,Interaction.speed
	ld (hl),SPEED_20
	ld l,Interaction.angle
	ld (hl),ANGLE_DOWN

	ld a,SND_BOSS_DAMAGE
	call playSound


; Moving into Ambi
@state3:
	call interactionDecCounter1
	jr nz,++
	ld a,$07
	ld (wTmpcfc0.genericCutscene.cfd0),a
	ld a,$04
	jp interactionDelete
++
	ld l,Interaction.visible
	ld a,(hl)
	xor $80
	ld (hl),a

@applySpeedAndAnimate:
	call objectApplySpeed
	jp interactionAnimate


; Ralph
interaction6e_subid03:
	ld a,(de)
	or a
	jr z,interaction6e_initRalph

interaction6e_runScriptAndAnimate:
	call interactionRunScript
	jp interactionAnimate

interaction6e_initRalph:
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_200
	call objectSetVisible82
	ld hl,mainScripts.interaction6e_subid03Script
	jp interactionSetScript


; Guards that run into the room
interaction6e_subid04:
	ld a,(de)
	or a
	jr nz,interaction6e_runScriptAndAnimate

	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.speed
	ld (hl),SPEED_180

	ld l,Interaction.yh
	ld (hl),$b0
	ld l,Interaction.xh
	ld (hl),$78
	call objectSetVisible82

	ld e,Interaction.var03
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.interaction6e_guard0Script
	.dw mainScripts.interaction6e_guard1Script
	.dw mainScripts.interaction6e_guard2Script
	.dw mainScripts.interaction6e_guard3Script
	.dw mainScripts.interaction6e_guard4Script
	.dw mainScripts.interaction6e_guard5Script


; ==============================================================================
; INTERACID_WILD_TOKAY_CONTROLLER
;
; Variables:
;   var03: Set to $ff when the game is lost?
;   var38: ?
;   var39: ?
;   var3b: ?
;   var3e/3f: Link's B/A button items, saved
; ==============================================================================
interactionCode70:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	xor a
	ld hl,wTmpcfc0.wildTokay.cfde
	ldi (hl),a
	ld (hl),a
	call interactionIncState
	ld a,(wWildTokayGameLevel)
	ld b,a
	ld a,(wTmpcfc0.wildTokay.inPresent)
	or a
	jr z,+
	ld b,$02
+
	ld a,b
	ld (wTmpcfc0.wildTokay.cfdc),a
	ld bc,@var3bValues
	call addAToBc
	ld a,(bc)
	ld e,Interaction.var3b
	ld (de),a
	jp @getRandomVar39Value

@var3bValues:
	.db $05 $05 $05 $06 $07

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

@substate0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	; Save Link's equipped items
	ld hl,wInventoryB
	ld e,Interaction.var3e
	ldi a,(hl)
	ld (de),a
	ldd a,(hl)
	inc e
	ld (de),a

	ld (hl),ITEMID_NONE
	inc l
	ld (hl),ITEMID_BRACELET

	; Replace tiles to start game
	ld b,$06
	ld hl,@tilesToReplaceOnStart
@@nextTile:
	ldi a,(hl)
	ld c,(hl)
	inc hl
	push bc
	push hl
	call setTile
	pop hl
	pop bc
	dec b
	jr nz,@@nextTile

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),30

	ld hl,w1Link.yh
	ld (hl),$48
	ld l,<w1Link.xh
	ld (hl),$50
	xor a
	ld l,<w1Link.direction
	ld (hl),a

	dec a
	ld (wStatusBarNeedsRefresh),a
	ret

; b0: new tile value
; b1: tile position
@tilesToReplaceOnStart:
	.db $ef $01
	.db $ef $08
	.db $ef $71
	.db $ef $78
	.db $7a $74
	.db $7a $75

@substate1:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),10
	ld a,MUS_MINIGAME
	call playSound
	jp fadeinFromWhite

@substate2:
	call interactionDecCounter1IfPaletteNotFading
	ret nz
	call interactionIncSubstate
	xor a
	ld (wDisabledObjects),a
	ld bc,TX_0a16
	jp showText


; Starting the game
@substate3:
	ld a,(wTextIsActive)
	or a
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),60
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TOKAY_MEAT
	ld a,SND_WHISTLE
	jp playSound


; Playing the game
@substate4:
	ld a,(wTmpcfc0.wildTokay.cfde)
	or a
	jp z,@checkSpawnNextTokay

	ld hl,wDisabledObjects
	ld (hl),DISABLE_LINK
	inc a
	jr z,@@lostGame

@@wonGame:
	ld a,SND_FILLED_HEART_CONTAINER
	call playSound
	jr ++

@@lostGame:
	dec a
	ld e,Interaction.var03
	ld (de),a
	ld a,SND_ERROR
	call playSound
++
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),30
	ret


; Showing text after finishing game
@substate5:
	call interactionDecCounter1
	ret nz

	ld (hl),60
	call interactionIncSubstate

	ld a,(wTmpcfc0.wildTokay.inPresent)
	or a
	ret nz

	ld h,d
	ld l,Interaction.counter1
	ld (hl),20
	ld bc,TX_0a18
	ld l,Interaction.var03
	ld a,(hl)
	add c
	ld c,a
	jp showText

@substate6:
	ld a,(wTmpcfc0.wildTokay.inPresent)
	or a
	jr z,+

	call interactionDecCounter1
	ret nz
	jr ++
+
	call interactionDecCounter1IfTextNotActive
	ret nz
++
	; Restore inventory
	ld hl,wInventoryB
	ld e,Interaction.var3e
	ld a,(de)
	inc e
	ldi (hl),a
	ld a,(de)
	ld (hl),a

	call getThisRoomFlags
	set 6,(hl)
	ld a,$ff
	ld (wActiveMusic),a

	ld hl,@@pastWarpDest
	ld a,(wTmpcfc0.wildTokay.inPresent)
	or a
	jr z,+
	ld hl,@@presentWarpDest
+
	jp setWarpDestVariables

@@pastWarpDest:
	m_HardcodedWarpA ROOM_AGES_2de, $00, $57, $03

@@presentWarpDest:
	m_HardcodedWarpA ROOM_AGES_2e5, $00, $57, $03


@checkSpawnNextTokay:
	call interactionDecCounter1
	ret nz

	ld (hl),60
	ld l,Interaction.var3b
	ld a,(hl)
	or a
	ret z

	ld l,Interaction.var39
	ld a,(hl)
	add a
	ld bc,@data_5898
	call addDoubleIndexToBc

	ld l,Interaction.var38
	ld a,(hl)
	cp $04
	jr z,@decVar3b

	inc (hl)
	call addAToBc
	ld a,(bc)
	or a
	ret z
	ld c,a
	ld l,Interaction.var3b
	ld a,(hl)
	dec a
	jr nz,@loadTokay

	ld l,Interaction.var39
	ld a,(hl)
	ld b,$03
	cp $01
	jr z,++
	cp $06
	jr z,++
	inc b
++
	ld l,Interaction.var38
	ld a,(hl)
	cp b
	jr nz,@loadTokay

	ld hl,wTmpcfc0.wildTokay.cfdf
	ld (hl),b

@loadTokay:
	ld b,c
	call getWildTokayObjectDataIndex
	jp parseGivenObjectData

@decVar3b:
	ld (hl),$00
	ld l,Interaction.var3b
	dec (hl)

;;
@getRandomVar39Value:
	ld hl,wTmpcfc0.wildTokay.cfdc
	ld a,(hl)
	swap a
	ld hl,@table
	rst_addAToHl
	call getRandomNumber
	and $0f
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var39
	ld (de),a
	ret


; Each row corresponds to a value for var39; each column corresponds to a value for var38?
@data_5898:
	.db $01 $00 $00 $02
	.db $02 $00 $01 $00
	.db $02 $01 $00 $01
	.db $01 $00 $02 $02
	.db $01 $01 $02 $02
	.db $02 $02 $01 $01
	.db $02 $03 $01 $00
	.db $01 $03 $02 $02

; Each row is a set of possible values for a particular value of wTmpcfc0.wildTokay.cfdc?
@table:
	.db $00 $00 $00 $01 $01 $01 $02 $02 $02 $03 $03 $03 $04 $04 $05 $05
	.db $00 $00 $01 $01 $01 $02 $02 $02 $03 $03 $03 $04 $04 $04 $05 $06
	.db $00 $01 $01 $02 $02 $03 $03 $04 $04 $04 $05 $05 $06 $06 $06 $07
	.db $01 $02 $03 $03 $04 $04 $04 $05 $05 $05 $05 $00 $00 $06 $07 $07
	.db $03 $04 $04 $04 $05 $05 $05 $05 $05 $02 $01 $00 $06 $07 $07 $07


; ==============================================================================
; INTERACID_COMPANION_SCRIPTS
; ==============================================================================
interactionCode71:
	ld a,(wLinkDeathTrigger)
	or a
	jr z,++
	xor a
	ld (wDisabledObjects),a
	jp interactionDelete
++
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw companionScript_subid00
	.dw companionScript_subid01
	.dw companionScript_subid02
	.dw companionScript_subid03
	.dw companionScript_subid04
	.dw companionScript_subid05
	.dw companionScript_subid06
	.dw companionScript_subid07
	.dw companionScript_subid08
	.dw companionScript_subid09
	.dw companionScript_subid0a
	.dw companionScript_subid0b
	.dw companionScript_subid0c
	.dw companionScript_subid0d


companionScript_subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_subid00_state1

@state0:
	ld a,$01
	ld (de),a
	ld a,(wEssencesObtained)
	bit 1,a
	jp z,companionScript_deleteSelf

	ld a,(wPastRoomFlags+$79)
	bit 6,a
	jp z,companionScript_deleteSelf

	ld a,(wMooshState)
	and $60
	jp nz,companionScript_deleteSelf

	ld a,$01
	ld (wDisableScreenTransitions),a
	ld (wDiggingUpEnemiesForbidden),a
	ld hl,mainScripts.companionScript_subid00Script
	jp interactionSetScript


companionScript_subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw companionScript_genericState0
	.dw companionScript_restrictHigherX

companionScript_subid02:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw companionScript_genericState0
	.dw companionScript_restrictLowerY

companionScript_subid04:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw companionScript_genericState0
	.dw companionScript_restrictHigherY

companionScript_subid05:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw companionScript_genericState0
	.dw companionScript_restrictLowerX


; Delete self if game is completed; otherwise, stay in state 0 until Link mounts the
; companion.
companionScript_genericState0:
	ld a,(wFileIsCompleted)
	or a
	jp nz,companionScript_deleteSelf
	ld a,(wLinkObjectIndex)
	rrca
	ret nc

	ld a,$01
	ld (de),a

	ld a,(w1Companion.id)
	sub SPECIALOBJECTID_RICKY
	ld e,Interaction.var30
	ld (de),a
	add <wRickyState
	ld l,a
	ld h,>wRickyState
	bit 7,(hl)
	jp nz,companionScript_deleteSelf
	ret

companionScript_restrictHigherX:
	call companionScript_cpXToCompanion
	ret c
	inc a
	jr ++

companionScript_restrictLowerX:
	call companionScript_cpXToCompanion
	ret nc
	jr ++

companionScript_restrictLowerY:
	call companionScript_cpYToCompanion
	ret nc
	jr ++

companionScript_restrictHigherY:
	call companionScript_cpYToCompanion
	ret c
	inc a
	jr ++

++
	ld c,a
	ld a,(wLinkObjectIndex)
	rrca
	ret nc

	ld a,c
	ld (hl),a

	ld l,SpecialObject.speed
	ld (hl),SPEED_0

	ld e,Interaction.var30
	ld a,(de)
	ld hl,companionScript_companionBarrierText
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	jp showText

companionScript_cpYToCompanion:
	ld e,Interaction.yh
	ld a,(de)
	ld hl,w1Companion.yh
	cp (hl)
	ret

companionScript_cpXToCompanion:
	ld e,Interaction.xh
	ld a,(de)
	ld hl,w1Companion.xh
	cp (hl)
	ret

; Text to show when you try to pass the "barriers" imposed.
companionScript_companionBarrierText:
	.dw TX_2007 ; Ricky
	.dw TX_2105 ; Dimitri
	.dw TX_2209 ; Moosh


; Companion barrier to Symmetry City, until the tuni nut is restored
companionScript_subid0d:
	ld a,GLOBALFLAG_TUNI_NUT_PLACED
	call checkGlobalFlag
	jp nz,companionScript_deleteSelf

	ld a,(wScrollMode)
	and (SCROLLMODE_08 | SCROLLMODE_04 | SCROLLMODE_02)
	ret nz
	ld hl,w1Companion.enabled
	ldi a,(hl)
	or a
	ret z

	ldi a,(hl)
	cp SPECIALOBJECTID_FIRST_COMPANION
	ret c
	cp SPECIALOBJECTID_LAST_COMPANION+1
	ret nc

	; Check if the companion is roughly at this object's position
.ifndef REGION_JP
	ld l,SpecialObject.xh
	ld e,Interaction.xh
	ld a,(de)
	sub (hl)
	add $05
	cp $0b
	ret nc
.endif
	ld l,SpecialObject.yh
	ld e,Interaction.yh
	ld a,(de)
	cp (hl)
	ret c

	; If so, prevent companion from moving any further up
	inc a
	ld (hl),a
	ld l,SpecialObject.speed
	ld (hl),$00
	ld l,SpecialObject.state
	ldi a,(hl)

	; If it's Dimitri being held, make Link drop him
	cp $02
	jr nz,+
	ld (hl),$03
	call dropLinkHeldItem
+
	ld a,(wAnimalCompanion)
	sub SPECIALOBJECTID_FIRST_COMPANION
	ld hl,@textIndices
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	jp showText

; Text to show as the excuse why they can't go into Symmetry City
@textIndices:
	.dw TX_200a
	.dw TX_2109
	.dw TX_220a


; Ricky script when he loses his gloves
companionScript_subid03:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScript

@state0:
	ld a,$01
	ld (de),a
	ld hl,wRickyState
	ld a,(hl)
	and $20
	jr nz,companionScript_deleteSelf
	ld hl,mainScripts.companionScript_subid03Script
	jp interactionSetScript


; Dimitri script where he's harrassed by tokays
companionScript_subid07:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScript

@state0:
	ld a,(wDimitriState)
	and $20
	jr nz,companionScript_deleteSelf
	ld a,$01
	ld (de),a
	ld hl,mainScripts.companionScript_subid07Script
	jp interactionSetScript


; Dimitri script where he leaves Link after bringing him to the mainland
companionScript_subid06:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScript

@state0:
	; Delete self if dimitri isn't here or the event has happened already
	ld a,(wDimitriState)
	and $40
	jr nz,companionScript_deleteSelf
	ld hl,w1Companion.id
	ld a,(hl)
	cp SPECIALOBJECTID_DIMITRI
	jr nz,companionScript_deleteSelf

	; Return if Dimitri's still in the water
	ld l,SpecialObject.var38
	ld a,(hl)
	or a
	ret nz

	ld a,$01
	ld (de),a

.ifdef ENABLE_US_BUGFIXES
	; This is supposed to prevent a softlock that occurs by doing a screen transition before
	; Dimitri talks. But it doesn't work! Something else resets this back to 0.
	ld (wDisableScreenTransitions),a
.endif

	; Manipulate Dimitri's state to force a dismount
	ld l,SpecialObject.var03
	ld (hl),$02
	inc l
	ld (hl),$0a

	ld hl,mainScripts.companionScript_subid06Script
	jp interactionSetScript

companionScript_deleteSelf:
	jp interactionDelete


; A fairy appears to tell you about the animal companion in the forest
companionScript_subid08:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw companionScript_runScript

@state0:
	; Clear $10 bytes starting at $cfd0
	ld hl,wTmpcfc0.fairyHideAndSeek.active
	ld b,$10
	call clearMemory

	ld a,GLOBALFLAG_CAN_BUY_FLUTE
	call unsetGlobalFlag

	ld l,<wAnimalCompanion
	ld a,(hl)
	or a
	jr nz,+
	ld a,SPECIALOBJECTID_MOOSH
	ld (hl),a
+
	sub SPECIALOBJECTID_FIRST_COMPANION
	add <TX_1123
	ld (wTextSubstitutions),a

	ld a,(wScreenTransitionDirection)
	cp DIR_LEFT
	jr nz,companionScript_deleteSelf

	ld a,GLOBALFLAG_TALKED_TO_HEAD_CARPENTER
	call checkGlobalFlag
	jr z,companionScript_deleteSelf

	call getThisRoomFlags
	bit 6,a
	jr nz,companionScript_deleteSelf
	jp interactionIncState

@state1:
	; Wait for Link to trigger the fairy
	ld a,(w1Link.xh)
	cp $50
	ret nc

	ld a,$81
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	call putLinkOnGround

	ldbc INTERACID_FOREST_FAIRY, $03
	call objectCreateInteraction
	ld l,Interaction.var03
	ld (hl),$0f
	ld hl,mainScripts.companionScript_subid08Script
	call interactionSetScript
	jp interactionIncState


; Companion script where they're found in the fairy forest
companionScript_subid09:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScript

@state0:
	ld a,$01
	ld (de),a

	xor a
	ld (wTmpcfc0.fairyHideAndSeek.cfd2),a

	; Check whether the event is applicable right now
	ld a,GLOBALFLAG_TALKED_TO_HEAD_CARPENTER
	call checkGlobalFlag
	jr z,companionScript_deleteSelf

	ld a,GLOBALFLAG_GOT_FLUTE
	call checkGlobalFlag
	jp nz,companionScript_deleteSelf

	; Put companion index (0-2) in var39
	ld hl,wAnimalCompanion
	ld a,(hl)
	sub SPECIALOBJECTID_FIRST_COMPANION
	ld e,Interaction.var39
	ld (de),a

	ld c,a
	ld hl,@animationWhenNoticingLink
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var38
	ld (de),a

	ld a,c
	add a
	ld hl,@data1
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wTextSubstitutions),a
	call checkIsLinkedGame
	jr z,+
	ldi a,(hl)
+
	ldi a,(hl)
	ld (wTextSubstitutions+1),a
	ld hl,mainScripts.companionScript_subid09Script
	jp interactionSetScript


; b0: first text to show
; b1: text to show after that (unlinked)
; b2: text to show after that (linked)
@data1:
	.db <TX_1133, <TX_1134, <TX_1135, $00
	.db <TX_113a, <TX_113b, <TX_113c, $00
	.db <TX_1141, <TX_1142, <TX_1143, $00

@animationWhenNoticingLink:
	.db $00 ; Ricky
	.db $1e ; Dimitri
	.db $03 ; Moosh


; Script just outside the forest, where you get the flute
companionScript_subid0a:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScript
	.dw companionScript_subid0a_state2
	.dw companionScript_subid0a_state3

@state0:
	ld a,GLOBALFLAG_SAVED_COMPANION_FROM_FOREST
	call checkGlobalFlag
	jp z,companionScript_delete

	ld a,GLOBALFLAG_GOT_FLUTE
	call checkGlobalFlag
	jp nz,companionScript_delete

	ld a,$01
	ld (de),a ; [state] = 1
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld (wTmpcfc0.fairyHideAndSeek.cfd2),a

	ld a,DIR_UP
	ld (w1Link.direction),a

	; Put companion index (0-2) in var39
	ld hl,wAnimalCompanion
	ld a,(hl)
	sub SPECIALOBJECTID_FIRST_COMPANION
	ld e,Interaction.var39
	ld (de),a

	; Determine text to show for this companion
	add a
	ld hl,@textIndices
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wTextSubstitutions+1),a
	call checkIsLinkedGame
	jr z,+
	ldi a,(hl)
+
	ldi a,(hl)
	ld (wTextSubstitutions),a

	; Spawn in the fairies
	ld bc,$1103
@nextFairy:
	push bc
	ldbc INTERACID_FOREST_FAIRY, $04
	call objectCreateInteraction
	pop bc
	ld l,Interaction.var03
	ld (hl),b
	inc b
	dec c
	jr nz,@nextFairy

	ld hl,mainScripts.companionScript_subid0aScript
	jp interactionSetScript


; b0: Second text to show (after giving you the flute)
; b1: First text to show (unlinked)
; b2: First text to show (linked)
@textIndices:
	.db <TX_1139, <TX_1136, <TX_1137, $00 ; Ricky
	.db <TX_1140, <TX_113d, <TX_113e, $00 ; Dimitri
	.db <TX_1147, <TX_1144, <TX_1145, $00 ; Moosh


; Script in first screen of forest, where fairy leads you to the companion
companionScript_subid0b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScript

@state0:
	ld a,(wScreenTransitionDirection)
	cp DIR_DOWN
	jr nz,companionScript_delete
	ld a,GLOBALFLAG_COMPANION_LOST_IN_FOREST
	call checkGlobalFlag
	jr z,companionScript_delete

	ld a,GLOBALFLAG_GOT_FLUTE
	call checkGlobalFlag
	jr nz,companionScript_delete

	ldbc INTERACID_FOREST_FAIRY, $03
	call objectCreateInteraction
	ld l,Interaction.var03
	ld (hl),$14

	ld a,$81
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a

	xor a
	ld (wTmpcfc0.fairyHideAndSeek.cfd2),a

	ld hl,mainScripts.companionScript_subid0bScript
	call interactionSetScript
	jp interactionIncState


; Sets bit 6 of wDimitriState so he disappears from Tokay Island
companionScript_subid0c:
	ld a,(wDimitriState)
	bit 5,a
	jr z,companionScript_delete
	or $40
	ld (wDimitriState),a
	jr companionScript_delete

;;
companionScript_subid00_state1:
	; If var3a is nonzero, make Moosh shake in fear
	ld e,Interaction.var3a
	ld a,(de)
	or a
	jr z,companionScript_runScript

	dec a
	ld (de),a
	and $03
	jr nz,companionScript_runScript
	ld a,(w1Companion.xh)
	xor $02
	ld (w1Companion.xh),a

companionScript_runScript:
	call interactionRunScript
	ret nc
	call setStatusBarNeedsRefreshBit1
companionScript_delete:
	jp interactionDelete


; This is the part which gives Link the flute.
companionScript_subid0a_state2:
	ld a,TREASURE_FLUTE
	call checkTreasureObtained
	ld c,<TX_0038
	jr nc,+
	ld c,<TX_0069
+
	ld e,Interaction.var39 ; Companion index
	ld a,(de)
	add c
	ld c,a
	ld b,>TX_0038
	call showText

	ld a,$01
	ld (wMenuDisabled),a
	call interactionIncState

	; Set wFluteIcon
	ld e,Interaction.var39
	ld a,(de)
	ld c,a
	inc a
	ld (de),a
	ld hl,wFluteIcon
	ld (hl),a

	; Set bit 7 of wRickyState / wDimitriState / wMooshState
	add <wCompanionStates - 1
	ld l,a
	set 7,(hl)

	; Give flute
	ld a,TREASURE_FLUTE
	call giveTreasure
	ld hl,wStatusBarNeedsRefresh
	set 0,(hl)

	; Turn this object into the flute graphic?
	ld e,Interaction.subid
	xor a
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,$0a
	ld (de),a

	; Set this object's palette
	ld e,Interaction.var39
	ld a,(de)
	ld c,a
	and $01
	add a
	xor c
	ld e,Interaction.oamFlags
	ld (de),a

	; Set this object's position
	ld hl,w1Link
	ld bc,$f200
	call objectTakePositionWithOffset

	; Make Link hold it over his head
	ld hl,wLinkForceState
	ld a,LINK_STATE_04
	ldi (hl),a
	ld (hl),$01 ; [wcc50] = $01
	call objectSetVisible80
	jp interactionRunScript


companionScript_subid0a_state3:
	call retIfTextIsActive

	; ??
	ld a,(wLinkObjectIndex)
	and $0f
	add a
	swap a
	ld (wDisabledObjects),a

	; Make flute disappear, wait for script to end
	call objectSetInvisible
	call interactionRunScript
	ret nc

	; Clean up, delete self
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp companionScript_delete


; ==============================================================================
; INTERACID_KING_MOBLIN_DEFEATED
; ==============================================================================
interactionCode72:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2


; Subid 0: King moblin / "parent" for other subids
@subid0:
	ld a,(de)
	or a
	jr z,@subid0State0

@subid0State1:
	call interactionRunScript
	jp nc,interactionAnimate
	call getFreeInteractionSlot
	ret nz

	; Spawn instance of this object with subid 2
	ld (hl),INTERACID_KING_MOBLIN_DEFEATED
	inc l
	ld (hl),$02
	ld l,Interaction.yh
	ld (hl),$68
	jp interactionDelete

@subid0State0:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete

	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp z,interactionDelete

	call setDeathRespawnPoint
	ld a,$80
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	call @spawnSubservientMoblin
	ld (hl),$38
	call @spawnSubservientMoblin
	ld (hl),$78

	ld hl,$cfd0
	ld b,$04
	call clearMemory

	ld a,$02
	call fadeinFromWhiteWithDelay
	ld hl,mainScripts.kingMoblinDefeated_kingScript

@setScriptAndInitStuff:
	call interactionSetScript
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.speed
	ld (hl),SPEED_180
	ld l,Interaction.angle
	ld (hl),ANGLE_DOWN
	jp objectSetVisible82


; Spawn an instance of subid 1, the normal moblins
@spawnSubservientMoblin:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_KING_MOBLIN_DEFEATED
	inc l
	inc (hl)
	ld l,Interaction.yh
	ld (hl),$68
	ld l,Interaction.xh
	ret


; Subid 1: Normal moblin following him
@subid1:
	ld a,(de)
	or a
	jr z,@subid1State0

@runScriptAndAnimate:
	call interactionRunScript
	jp nc,interactionAnimate
	jp interactionDelete

@subid1State0:
	ld hl,mainScripts.kingMoblinDefeated_helperMoblinScript
	jr @setScriptAndInitStuff


; Subid 2: Gorons who approach after he leaves (var03 = index)
@subid2:
	ld a,(de)
	or a
	jr nz,@runScriptAndAnimate

	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_80

	; Load script
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	call objectSetVisible82

	; Load data from table
	ld e,Interaction.var03
	ld a,(de)
	add a
	ld hl,@goronData
	rst_addDoubleIndex
	ld e,Interaction.yh
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.xh
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.angle
	ldi a,(hl)
	ld (de),a
	ld a,(hl)
	call interactionSetAnimation

	; If [var03] == 0, spawn the other gorons
	ld e,Interaction.var03
	ld a,(de)
	or a
	ret nz

	ld b,$01
	call @spawnGoronInstance
	inc b
	call @spawnGoronInstance
	inc b

@spawnGoronInstance:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_KING_MOBLIN_DEFEATED
	inc l
	ld (hl),$02
	inc l
	ld (hl),b
	ret

@scriptTable:
	.dw mainScripts.kingMoblinDefeated_goron0
	.dw mainScripts.kingMoblinDefeated_goron1
	.dw mainScripts.kingMoblinDefeated_goron2
	.dw mainScripts.kingMoblinDefeated_goron3

; b0: Y
; b1: X
; b2: angle
; b3: animation
@goronData:
	.db $88 $38 $00 $04 ; $00 == [var03]
	.db $58 $a8 $18 $07 ; $01
	.db $88 $90 $00 $04 ; $02
	.db $88 $58 $00 $04 ; $03


; ==============================================================================
; INTERACID_GHINI_HARASSING_MOOSH
; ==============================================================================
interactionCode73:
	ld h,d
	ld l,Interaction.subid
	ldi a,(hl)
	or a
	jr nz,@checkState

	inc l
	ld a,(hl)
	or a
	jr z,@checkState

	ld a,(wScrollMode)
	and $0e
	ret nz

@checkState:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	; Delete self if they shouldn't be here right now
	ld a,(wEssencesObtained)
	bit 1,a
	jr z,@delete

	ld a,(wPastRoomFlags+$79)
	bit 6,a
	jr z,@delete

	ld a,(wMooshState)
	and $60
	jr nz,@delete

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.zh
	ld (hl),-2

	; Load script
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp objectSetVisiblec0

@state1:
	call interactionAnimate
	ld e,Interaction.speed
	ld a,(de)
	or a
	jr z,++

	; While the ghini is moving, make them "rotate" in position.
	call objectApplySpeed
	ld e,Interaction.angle
	ld a,(de)
	dec a
	and $1f
	ld (de),a
	cp $18
	jr nz,++

	xor a
	ld e,Interaction.speed
	ld (de),a
++
	call interactionRunScript
	ret nc
@delete:
	jp interactionDelete

@scriptTable:
	.dw mainScripts.ghiniHarassingMoosh_subid00Script
	.dw mainScripts.ghiniHarassingMoosh_subid01Script
	.dw mainScripts.ghiniHarassingMoosh_subid02Script


; ==============================================================================
; INTERACID_RICKYS_GLOVE_SPAWNER
; ==============================================================================
interactionCode74:
	; Delete self if already returned gloves, haven't talked to Ricky, or already got
	; gloves
	ld a,(wRickyState)
	bit 5,a
	jr nz,@delete
	and $01
	jr z,@delete
	ld a,TREASURE_RICKY_GLOVES
	call checkTreasureObtained
	jr c,@delete

	ldbc INTERACID_TREASURE, TREASURE_RICKY_GLOVES
	call objectCreateInteraction
	ret nz
@delete:
	jp interactionDelete


; ==============================================================================
; INTERACID_INTRO_SPRITE
; ==============================================================================
interactionCode75:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState
	call interactionInitGraphics
	call objectSetVisible82
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init
	.dw @subid3Init
	.dw @subid4Init
	.dw @subid5Init
	.dw @subid6Init

@subid0Init:
@subid5Init:
	ret

@subid1Init:
	ld h,d
	ld l,Interaction.counter1
	ld (hl),$05

@initSpeedToScrollLeft:
	ld l,Interaction.angle
	ld (hl),ANGLE_LEFT
	ld l,Interaction.speed
	ld (hl),SPEED_20
	ld bc,$7080
	jp interactionSetPosition

@subid2Init:
	call objectSetVisible83
	ld h,d
	jr @initSpeedToScrollLeft

@subid3Init:
	ld bc,$4c6c
	call interactionSetPosition
	ld l,Interaction.angle
	ld (hl),$19
	ld l,Interaction.speed
	ld (hl),SPEED_40
	ret

@subid4Init:
	ld bc,$1838
	jp interactionSetPosition

@subid6Init:
	ld h,d
	ld l,Interaction.angle
	ld (hl),$1a
	ld l,Interaction.speed
	ld (hl),SPEED_60
	ret

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid0
	.dw @runSubid1
	.dw @runSubid2
	.dw @runSubid3
	.dw interactionAnimate
	.dw @runSubid5
	.dw @runSubid6

@runSubid0:
@runSubid5:
	ld a,(wIntro.cbba)
	or a
	jp z,interactionAnimate
	jp interactionDelete

@runSubid1:
	call checkInteractionSubstate
	jr nz,@updateSpeed

	call interactionAnimate
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	jr z,@updateSpeed

	ld (hl),$00
	ld l,Interaction.counter1
	dec (hl)
	jr nz,@updateSpeed

	ld l,Interaction.substate
	inc (hl)
	ld a,$04
	call interactionSetAnimation

@updateSpeed:
@runSubid2:
	ld hl,wIntro.cbb6
	ld a,(hl)
	or a
	ret z
	jp objectApplySpeed

@runSubid3:
	call interactionAnimate
	ld a,(wIntro.frameCounter)
	and $03
	ret nz
	jp objectApplySpeed

@runSubid6:
	ld a,(wTmpcbba)
	or a
	jp nz,interactionDelete
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call interactionAnimate
	jp objectApplySpeed


; ==============================================================================
; INTERACID_MAKU_GATE_OPENING
; ==============================================================================
interactionCode76:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d
	ld l,Interaction.state
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),30
	ld l,Interaction.subid
	ld a,(hl)
	or a
	ld hl,@frame0And1_subid0
	jr z,+
	ld hl,@frame0And1_subid1
+
	call @loadInterleavedTiles
	ld bc,@frame0_poof
	call @loadPoofs

@shakeScreen:
	ld a,$06
	call setScreenShakeCounter
	ld a,SND_DOORCLOSE
	jp playSound

@state1:
	call interactionDecCounter1
	ret nz
	ld hl,@frame0And1_subid0
	call @loadTiles
	ld bc,@frame1_poof
	call @loadPoofs
	call @shakeScreen
	ld h,d
	ld l,Interaction.state
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),30
	ret

@state2:
	call interactionDecCounter1
	ret nz
	ld hl,@frame2And3
	call @loadInterleavedTiles
	ld bc,@frame2_poof
	call @loadPoofs
	call @shakeScreen

	ld h,d
	ld l,Interaction.state
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),30
	ret

@state3:
	call interactionDecCounter1
	ret nz
	ld hl,@frame2And3
	call @loadTiles
	ld bc,@frame3_poof
	call @loadPoofs
	call @shakeScreen
	call getThisRoomFlags
	set 7,(hl)
	jp interactionDelete

@frame0And1_subid0:
	.db $02
	.db $74 $f9 $8e $03
	.db $75 $f9 $8e $01

@frame0And1_subid1:
	.db $02
	.db $74 $f9 $8c $03
	.db $75 $f9 $8c $01

@frame2And3:
	.db $02
	.db $73 $f9 $8c $03
	.db $76 $f9 $8c $01

@frame0_poof:
	.db $04
	.db $74 $48
	.db $74 $58
	.db $7c $48
	.db $7c $58

@frame1_poof:
	.db $04
	.db $74 $40
	.db $74 $60
	.db $7c $40
	.db $7c $60

@frame2_poof:
	.db $04
	.db $74 $38
	.db $74 $68
	.db $7c $38
	.db $7c $68

@frame3_poof:
	.db $04
	.db $74 $30
	.db $74 $70
	.db $7c $30
	.db $7c $70

;;
; @param	hl	Pointer to data
@loadInterleavedTiles:
	ldi a,(hl)
	ld b,a
@@next:
	ldi a,(hl)
	ldh (<hFF8C),a
	ldi a,(hl)
	ldh (<hFF8F),a
	ldi a,(hl)
	ldh (<hFF8E),a
	ldi a,(hl)
	push hl
	push bc
	call setInterleavedTile
	pop bc
	pop hl
	dec b
	jr nz,@@next
	ret

;;
; @param	hl	Pointer to data
@loadTiles:
	ldi a,(hl)
	ld b,a
@@next:
	ldi a,(hl)
	ld c,a
	ld a,(hl)
	push hl
	push bc
	call setTile
	pop bc
	pop hl
	inc hl
	inc hl
	inc hl
	dec b
	jr nz,@@next
	ret

;;
; @param	hl	Pointer to poof position data
@loadPoofs:
	ld a,(bc)
	inc bc
@@next:
	ldh (<hFF8B),a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	inc bc
	ldh a,(<hFF8B)
	dec a
	jr nz,@@next
	ld a,SND_KILLENEMY
	jp playSound


; ==============================================================================
; INTERACID_SMALL_KEY_ON_ENEMY
; ==============================================================================
interactionCode77:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jp nz,interactionDelete

	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	ldhl FIRST_ENEMY_INDEX, Enemy.id
@nextEnemy:
	ld a,(hl)
	cp b
	jr z,@foundMatch
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1

	; BUG: Original game does "jp c", meaning this only works if the enemy in
	; question is in the first enemy slot.
.ifdef ENABLE_BUGFIXES
	jp nc,interactionDelete
.else
	jp c,interactionDelete
.endif
	jr @nextEnemy

; Found the enemy to attach the key to
@foundMatch:
	dec l
	ld a,l
	ld e,Interaction.relatedObj2
	ld (de),a
	ld a,h
	inc e
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible80
	call interactionIncState

@takeRelatedObj2Position:
	ld a,Object.y
	call objectGetRelatedObject2Var
	jp objectTakePosition

@state1: ; Copies the position of relatedObj2
	ld a,Object.enabled
	call objectGetRelatedObject2Var
	ld a,(hl)
	or a
	jp z,interactionIncState

	call @takeRelatedObj2Position
	ld a,Object.visible
	call objectGetRelatedObject2Var
	ld b,$01
	jp objectFlickerVisibility

@state2: ; relatedObj2 is gone, fall to the ground and create a key
	call objectSetVisible
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ldbc TREASURE_SMALL_KEY,$00
	call createTreasure
	call objectCopyPosition
	jp interactionDelete


; ==============================================================================
; INTERACID_STONE_PANEL
; ==============================================================================
interactionCode7b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw objectPreventLinkFromPassing

@state0:
	ld bc,$0e08
	call objectSetCollideRadii
	call interactionInitGraphics
	call objectSetVisible83
	ld a,PALH_7e
	call loadPaletteHeader
	call getThisRoomFlags
	and $40
	jr nz,@initializeOpenedState

	; Closed
	ld hl,wRoomCollisions+$66
	ld a,$0f
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	jp interactionIncState

@initializeOpenedState:
	ld e,Interaction.state
	ld a,$03
	ld (de),a

	; Move position 10 left or right
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld b,$10
	jr nz,+
	ld b,$f0
+
	ld e,Interaction.xh
	ld a,(de)
	add b
	ld (de),a

	ld e,Interaction.state
	ld a,$03
	ld (de),a

@updateSolidityUponOpening:
	ld hl,wRoomCollisions+$66
	xor a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld l,$46
	ld (hl),$02
	ld l,$56
	ld (hl),$0a
	ld l,$66
	ld (hl),$08
	ld l,$48
	ld (hl),$01
	ld l,$58
	ld (hl),$05
	ld l,$68
	ld (hl),$04
	ret

; Wait for bit 7 of wActiveTriggers to open the panel.
@state1:
	call objectPreventLinkFromPassing
	ld a,(wActiveTriggers)
	bit 7,a
	ret z

	ld a,$81
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld e,Interaction.counter1
	ld a,60
	ld (de),a
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	jp interactionIncState

@state2:
	call objectPreventLinkFromPassing
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0: ; Delay before opening
	call interactionDecCounter1
	ret nz

	ld (hl),$80
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld a,ANGLE_LEFT
	jr z,+
	ld a,ANGLE_RIGHT
+
	ld e,Interaction.angle
	ld (de),a
	ld e,Interaction.speed
	ld a,SPEED_20
	ld (de),a

	ld a,SND_OPENING
	call playSound
	jp interactionIncSubstate

@substate1: ; Currently opening
	ld a,(wFrameCounter)
	rrca
	ret nc
	call objectApplySpeed
	call interactionDecCounter1
	ret nz
	ld (hl),30
	jp interactionIncSubstate

@substate2: ; Done opening
	call interactionDecCounter1
	ret nz

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld hl,wActiveTriggers
	res 7,(hl)
	call getThisRoomFlags
	set 6,(hl)

	call @updateSolidityUponOpening
	ld a,(wActiveMusic)
	call playSound
	jp interactionIncState


; ==============================================================================
; INTERACID_SCREEN_DISTORTION
; ==============================================================================
interactionCode7c:
	call checkInteractionState
	jr z,@state0

@state1:
	ld a,$01
	jp loadBigBufferScrollValues

@state0:
	call interactionSetAlwaysUpdateBit
	call interactionIncState
	ld a,$10
	ld (wGfxRegs2.LYC),a
	ld a,$02
	ldh (<hNextLcdInterruptBehaviour),a
	ld a,SND_WARP_START
	call playSound
	ld a,$ff
	jp initWaveScrollValues


; ==============================================================================
; INTERACID_DECORATION
; ==============================================================================
interactionCode80:
	call checkInteractionState
	jr z,@state0

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw @deleteIfGotRoomItem
	.dw @deleteIfGotRoomItem
	.dw interactionAnimate
	.dw interactionAnimate

@state0:
	call interactionInitGraphics
	call interactionIncState
	call objectSetVisible83
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @stub
	.dw @deleteIfMoblinsKeepDestroyed
	.dw @stub
	.dw @stub
	.dw @deleteIfRoomFlagBit7Unset
	.dw @stub
	.dw @deleteIfRoomFlagBit7Unset
	.dw @deleteIfGotRoomItem
	.dw @deleteIfGotRoomItem
	.dw @stub
	.dw @subid0a

@stub:
	ret

; Subid $01 (moblin's keep flag)
@deleteIfMoblinsKeepDestroyed:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	ret z
	jp interactionDelete

; Subid $04, $06 (scent seedling & tokay eyeball)
@deleteIfRoomFlagBit7Unset:
	call getThisRoomFlags
	bit 7,a
	ret nz
	jp interactionDelete

@deleteIfGotRoomItem:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_ITEM,a
	ret z
	jp interactionDelete

; Fountain "stream": decide which palette to used based on whether this is the "ruined"
; symmetry city or not
@subid0a:
	call objectSetVisible80
	call @isSymmetryCityRoom
	jr c,@isSymmetryCity

@normalPalette:
	ld a,PALH_7d
	jp loadPaletteHeader

@isSymmetryCity:
	ld a,(wActiveGroup)
	or a
	jr nz,@ruinedSymmetryPalette
	call getThisRoomFlags
	and $01
	jr nz,@normalPalette

@ruinedSymmetryPalette:
	ld a,PALH_7c
	jp loadPaletteHeader

@isSymmetryCityRoom:
	ld a,(wActiveRoom)
	ld e,a
	ld hl,@symmetryCityRooms
	jp lookupKey

@symmetryCityRooms:
	.db $12 $00
	.db $13 $00
	.db $14 $00
	.db $00


; ==============================================================================
; INTERACID_TOKAY_SHOP_ITEM
;
; Variables:
;   var38: If nonzero, item can be bought with seeds
;   var39: Number of seeds Link has of the type needed to buy this item
;   var3a: Set if Link has the shovel
;   var3c: The treasure ID of this item (feather/bracelet only)
;   var3d: Set if Link has the shield
; ==============================================================================
interactionCode81:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld a,>TX_0a00
	call interactionSetHighTextIndex
	call interactionSetAlwaysUpdateBit
	ld a,$06
	call objectSetCollideRadius

	ld l,Interaction.subid
	ldi a,(hl)
	ld (hl),a ; [var03] = [subid]
	cp $04
	jr nz,@initializeItem

	; This is the shield; only appears if all other items retrieved. Also, adjust
	; level appropriately.
	ld a,GLOBALFLAG_BOUGHT_BRACELET_FROM_TOKAY
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,(wShieldLevel)
	or a
	jr z,@initializeItem

	; [subid] = [var03] = [wShieldLevel] + [subid] - 1
	ld e,Interaction.subid
	ld c,a
	dec c
	ld a,(de)
	add c
	ld (de),a
	inc e
	ld (de),a

@initializeItem:
	call @checkTransformItem
	jp nz,interactionDelete

	ld hl,mainScripts.tokayShopItemScript
	call interactionSetScript
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
	call interactionSetAlwaysUpdateBit
	jp objectSetVisible82

@initialShopTreasures:
	.db TREASURE_FEATHER, TREASURE_BRACELET

@seedsNeededToBuyItems:
	.db TREASURE_MYSTERY_SEEDS, TREASURE_SCENT_SEEDS, $00, $00,
	.db TREASURE_SCENT_SEEDS, TREASURE_SCENT_SEEDS, TREASURE_SCENT_SEEDS

	; TODO: what is this data? Possibly unused? ($626f)
	.db $28 $76 $6c $76 $b4 $76 $c4 $76

@state1:
	call interactionAnimateAsNpc
	call @checkTransformItem
	call nz,objectSetInvisible
	call interactionRunScript
	ret nc
	xor a
	ld (wDisabledObjects),a
	jp interactionDelete

;;
; This checks whether to replace the feather/bracelet with the shovel, changing the subid
; accordingly and initializing the graphics after doing so.
;
; @param[out]	zflag	nz if item should be deleted?
@checkTransformItem:
	ld h,d
	ld l,Interaction.var38
	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a

	ld e,Interaction.var03
	ld a,(de)
	ld c,a
	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	jr nc,@checkReplaceWithShovel

	; Seed satchel obtained; set var38/var39 based on whether Link can buy the item?

	ld a,c
	ld hl,@seedsNeededToBuyItems
	rst_addAToHl
	ld a,(hl)
	call checkTreasureObtained
	jr nc,@checkReplaceWithShovel

	inc a
	ld e,Interaction.var39
	ld (de),a
	cp $10
	jr c,@checkReplaceWithShovel

	ld e,Interaction.var38
	ld (de),a

@checkReplaceWithShovel:
	ld a,TREASURE_SHOVEL
	call checkTreasureObtained
	jr nc,++
	ld e,Interaction.var3a
	ld a,$01
	ld (de),a
++
	ld a,TREASURE_SHIELD
	call checkTreasureObtained
	jr nc,++
	ld e,Interaction.var3d
	ld a,$01
	ld (de),a
++
	ld a,c
	cp $04
	jr nc,@setSubidAndInitGraphics

	; The item is the feather or the bracelet.

	; If we've bought the item, it should be deleted.
	ld a,c
	ld hl,@boughtItemGlobalflags
	rst_addAToHl
	ld a,(hl)
	call checkGlobalFlag
	ret nz

	; Otherwise, if Link has the item, it should be replaced with the shovel.
	ld a,c
	ld hl,@initialShopTreasures
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var3c
	ld (de),a

	call checkTreasureObtained
	jr nc,@setSubidAndInitGraphics

	; Increment subid by 2, making it a shovel
	inc c
	inc c

@setSubidAndInitGraphics:
	ld e,Interaction.subid
	ld a,c
	ld (de),a
	call interactionInitGraphics
	xor a
	ret

@boughtItemGlobalflags:
	.db GLOBALFLAG_BOUGHT_FEATHER_FROM_TOKAY, GLOBALFLAG_BOUGHT_BRACELET_FROM_TOKAY


; ==============================================================================
; INTERACID_SARCOPHAGUS
; ==============================================================================
interactionCode82:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	bit 7,a
	jp nz,@break

	or a
	jr z,++
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete
++
	call interactionIncState

	ld l,Interaction.collisionRadiusY
	ld (hl),$10
	ld l,Interaction.collisionRadiusX
	ld (hl),$08

	call objectMakeTileSolid
	ld h,>wRoomLayout
	ld (hl),$00
	ld a,l
	sub $10
	ld l,a
	ld (hl),$00
	ld h,>wRoomCollisions
	ld (hl),$0f
	jp objectSetVisible83

; Waiting for Link to grab
@state1:
	ld a,(wBraceletLevel)
	cp $02
	ret c
	jp objectAddToGrabbableObjectBuffer

; Link currently grabbing
@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0_justGrabbed
	.dw @substate1_holding
	.dw @substate2_justReleased
	.dw @break

@substate0_justGrabbed:
	call interactionIncSubstate
	ld l,Interaction.subid
	ld a,(hl)
	or a
	jr z,++

	dec a
	ld a,SND_SOLVEPUZZLE
	call z,playSound
	call getThisRoomFlags
	set 6,(hl)
++
	call objectGetShortPosition
	push af
	call getTileIndexFromRoomLayoutBuffer
	call setTile
	pop af
	sub $10
	call getTileIndexFromRoomLayoutBuffer
	call setTile
	xor a
	ld (wLinkGrabState2),a
	jp objectSetVisiblec1

@substate1_holding:
	ret

@substate2_justReleased:
	ld h,d
	ld l,Interaction.enabled
	res 1,(hl)

	; Wait for it to hit the ground
	ld l,Interaction.zh
	bit 7,(hl)
	ret nz

@break:
	ld h,d
	ld l,Interaction.state
	ld (hl),$03
	ld l,Interaction.counter1
	ld (hl),$02

	ld l,Interaction.oamFlagsBackup
	ld a,$0c
	ldi (hl),a
	ldi (hl),a
	ld (hl),$40 ; [oamTileIndexBase] = $40

	call objectSetVisible83
	xor a
	jp interactionSetAnimation

; Being destroyed
@state3:
	call interactionDecCounter1
	ld a,SND_KILLENEMY
	call z,playSound
	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	jp nz,interactionAnimate
	jp interactionDelete


; ==============================================================================
; INTERACID_BOMB_UPGRADE_FAIRY
; ==============================================================================
interactionCode83:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw bombUpgradeFairy_subid00
	.dw bombUpgradeFairy_subid01
	.dw bombUpgradeFairy_subid02

bombUpgradeFairy_subid00:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,GLOBALFLAG_GOT_BOMB_UPGRADE_FROM_FAIRY
	call checkGlobalFlag
	jp nz,interactionDelete

	call getThisRoomFlags
	bit 0,a
	jp z,interactionDelete

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState

	ld l,Interaction.collisionRadiusY
	inc (hl)
	inc l
	ld (hl),$12

	ld hl,wTextNumberSubstitution
	ld a,(wMaxBombs)
	cp $10
	ld a,$30
	jr z,+
	ld a,$50
+
	ldi (hl),a
	xor a
	ld (hl),a
	ld (wTmpcfc0.bombUpgradeCutscene.state),a
	ld ($cfd0),a
	ret

@state1:
	; Bombs are hardcoded to set this variable to $01 when it falls into water on this
	; screen. Hold execution until that happens.
	ld a,(wTmpcfc0.bombUpgradeCutscene.state)
	dec a
	ret nz

	ld a,(w1Link.zh)
	or a
	ret nz

	; Check that Link's in position
	ldh a,(<hEnemyTargetY)
	sub $41
	cp $06
	ret nc
	ldh a,(<hEnemyTargetX)
	sub $58
	cp $21
	ret nc

	call checkLinkVulnerable
	ret nc

	ldbc INTERACID_PUFF, $02
	call objectCreateInteraction
	ret nz
	ld e,Interaction.relatedObj2
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	call clearAllParentItems
	call dropLinkHeldItem

	xor a
	ld (w1Link.direction),a
	ld (wTmpcfc0.bombUpgradeCutscene.state),a

	ld a,$80
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call setLinkForceStateToState08
	jp interactionIncState

@state2:
	; Wait for signal to spawn in silver and gold bombs?
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z

	call interactionIncState
	ld l,Interaction.yh
	ld (hl),$28

	ldbc INTERACID_SPARKLE, $0e
	call objectCreateInteraction

	call objectSetVisible81
	ld hl,mainScripts.bombUpgradeFairyScript
	call interactionSetScript

	ld b,$00
	call @spawnSubid2Instance

	ld b,$01

@spawnSubid2Instance:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_BOMB_UPGRADE_FAIRY
	inc l
	ld (hl),$02
	inc l
	ld (hl),b
	ret

@state3:
	call interactionAnimate
	ld a,(wTextIsActive)
	or a
	ret nz
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call interactionRunScript
	ret nc

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	inc a
	ld (wTmpcfc0.bombUpgradeCutscene.state),a

	call objectCreatePuff
	jp interactionDelete


; Bombs that surround Link (depending on his answer)
bombUpgradeFairy_subid01:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.var03
	ld a,(hl)
	add a
	add (hl)

	ld hl,@bombPositions
	rst_addAToHl
	ld e,Interaction.yh
	ldh a,(<hEnemyTargetY)
	add (hl)
	ld (de),a
	ld e,Interaction.xh
	inc hl
	ldh a,(<hEnemyTargetX)
	add (hl)
	ld (de),a

	ld e,Interaction.counter1
	inc hl
	ld a,(hl)
	ld (de),a
	ret

@bombPositions:
	.db $00 $f0 $01
	.db $10 $00 $0f
	.db $00 $10 $1e
	.db $f0 $00 $2d

@state1:
	call interactionDecCounter1
	ret nz
	ld l,e
	inc (hl)
	call objectCreatePuff
	jp objectSetVisible82

@state2:
	ld a,($cfd0)
	inc a
	jp z,interactionDelete

	; Flash the bomb between blue and red palettes
	call interactionDecCounter1
	ld a,(hl)
	and $03
	ret nz

	ld l,Interaction.oamFlagsBackup
	ld a,(hl)
	xor $01
	ldi (hl),a
	ld (hl),a
	ret


; Gold/silver bombs
bombUpgradeFairy_subid02:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	ld a,PALH_80
	call loadPaletteHeader
	call interactionIncState

	ld e,Interaction.var03
	ld a,(de)
	or a
	ld b,$5a
	jr z,++
	ld l,Interaction.oamFlagsBackup
	ld a,$06
	ldi (hl),a
	ld (hl),a
	ld b,$76
++
	ld l,Interaction.yh
	ld (hl),$3c
	ld l,Interaction.xh
	ld (hl),b

	ldbc INTERACID_PUFF, $02
	call objectCreateInteraction
	ret nz
	ld e,Interaction.relatedObj2
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

@state1:
	; Wait for the puff to finish, then make self visible
	ld a,Object.animParameter
	call objectGetRelatedObject1Var
	bit 7,(hl)
	ret nz
	call interactionIncState
	jp objectSetVisible82

@state2:
	ld a,($cfd0)
	or a
	ret z
	call objectCreatePuff
	jp interactionDelete


; ==============================================================================
; INTERACID_SPARKLE
; ==============================================================================
interactionCode84:
	call checkInteractionState
	jr nz,@state1

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.state
	inc (hl)
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @highDrawPriority
	.dw @highDrawPriority
	.dw @highDrawPriority
	.dw @initSubid07
	.dw @highDrawPriority
	.dw @initSubid09
	.dw @initSubid0a
	.dw @initSubid0b
	.dw @initSubid0c
	.dw @highDrawPriority
	.dw @highDrawPriority
	.dw @highDrawPriority

@initSubid0a:
	ld h,d
	ld l,Interaction.speed
	ld a,(hl)
	or a
	jr nz,@initSubid00
	ld (hl),$78

@initSubid00:
@initSubid01:
@initSubid09:
	inc e
	ld a,(de)
	or a
	jp nz,objectSetVisible81

@initSubid02:
@initSubid03:
@initSubid07:
@lowDrawPriority:
	jp objectSetVisible82

@highDrawPriority:
	jp objectSetVisible80

@initSubid0b:
	ld h,d
	ld l,Interaction.speedY
	ld (hl),<(-$40)
	inc l
	ld (hl),>(-$40)
	jp objectSetVisible81

@initSubid0c:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Interaction.var38
	ld a,(hl)
	ld (de),a
	jr @lowDrawPriority


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw @runSubid01
	.dw @runSubid02
	.dw @runSubid03
	.dw @runSubid04
	.dw @runSubid05
	.dw @runSubid06
	.dw @runSubid07
	.dw @runSubid08
	.dw @runSubid09
	.dw @runSubid0a
	.dw @runSubid0b
	.dw @runSubid0c
	.dw @runSubid0d
	.dw @runSubid0e
	.dw @runSubid0f

@runSubid02:
@runSubid03:
@runSubid0b:
	call objectApplyComponentSpeed

@runSubid00:
@runSubid01:
@runSubid09:
	ld e,Interaction.animParameter
	ld a,(de)
	cp $ff
	jp z,interactionDelete
	jp interactionAnimate


@runSubid04:
@animateAndFlickerAndDeleteWhenCounter1Zero:
	call interactionDecCounter1
	jp z,interactionDelete

@runSubid08:
@animateAndFlicker:
	call interactionAnimate
	ld a,(wFrameCounter)
@flicker:
	rrca
	jp c,objectSetInvisible
	jp objectSetVisible


@runSubid05:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld bc,$0800
	call objectTakePositionWithOffset
	jr @animateAndFlickerAndDeleteWhenCounter1Zero


@runSubid07:
@runSubid0f:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	call objectTakePosition

@runSubid0e:
	ld a,(wTmpcfc0.bombUpgradeCutscene.state)
	bit 0,a
	jp nz,interactionDelete
	jr @animateAndFlicker


@runSubid06:
	ld a,(wTmpcbb9)
	cp $07
	jp z,interactionDelete

@animateFlickerAndTakeRelatedObj1Position:
	call interactionAnimate
	ld a,Object.yh
	call objectGetRelatedObject1Var
	call objectTakePosition
	ld a,(wIntro.frameCounter)
	jr @flicker


@runSubid0a:
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jp c,interactionAnimate
	jp interactionDelete


@runSubid0c:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Interaction.var38
	ld a,(de)
	cp (hl)
	jp nz,interactionDelete

	call objectTakePosition
	ld a,($cfc0)
	bit 0,a
	jp nz,interactionDelete
	jr @animateAndFlicker


@runSubid0d:
	ld a,(wTmpcbb9)
	cp $06
	jp z,interactionDelete
	jr @animateFlickerAndTakeRelatedObj1Position


; ==============================================================================
; INTERACID_MAKU_FLOWER
; ==============================================================================
interactionCode86:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

; Present maku tree flower
@subid0:
	call checkInteractionState
	jr nz,@subid0State1

@subid0State0:
	call interactionInitGraphics
	call objectSetVisible82
	call interactionSetAlwaysUpdateBit
	call interactionIncState

@subid0State1:
	; Watch var3b of relatedObject1 to set the flower's animation
	ld a,Object.var3b
	call objectGetRelatedObject2Var
	ld a,(hl)
	ld bc,@anims
	call addAToBc
	ld a,(bc)
	cp $01
	jr z,@setAnimA
	ld b,a
	ld l,Interaction.subid
	ld a,(hl)
	cp $04
	jr nz,@setAnimB
	ld b,$03
@setAnimB:
	ld a,b
@setAnimA:
	jp interactionSetAnimation

@anims:
	.db $00 $00 $00 $00 $01


@subid1:
	call checkInteractionState
	jr nz,@subid1State1

@subid1State0:
	call interactionInitGraphics
	call objectSetVisible82
	call interactionSetAlwaysUpdateBit
	call interactionIncState
	ld l,Interaction.zh
	ld (hl),$d4
@subid1State1:
	ld h,d
	ld l,Interaction.zh
	inc (hl)
	jp z,interactionDelete
	ret


; ==============================================================================
; INTERACID_MAKU_TREE
;
; Variables:
;   var3b: Animation
;   var3d: 0 for present maku tree, 1 for past?
;   var3e: "Script mode"; mainly determines animation (see makuTree_subid00Script_body)
;   var3f: Text index to show for (sometimes shows the one after it as well)
; ==============================================================================
interactionCode87:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03
	.dw @subid04
	.dw @subid05
	.dw @subid06

@subid00:
	call checkInteractionState
	jr nz,@runScriptAndAnimate

	xor a
	ld e,Interaction.var3d
	ld (de),a
	call @initSubid00
	call @initializeMakuTree
	jr @runScriptAndAnimate

@subid01:
@subid02:
	call checkInteractionState
	jr nz,@runScriptAndAnimate

	call @initializeMakuTree
	call interactionRunScript
	ld e,Interaction.subid
	ld a,(de)
	dec a
	jr nz,@runScriptAndAnimate

	; Subid 1 only: make Link move right/up to approach the maku tree, starting the
	; "maku tree disappearance" cutscene

	ld a,PALH_8f
	call loadPaletteHeader

	ld hl,@simulatedInput
	ld a,:@simulatedInput
	push de
	call setSimulatedInputAddress
	pop de

	xor a
	ld (w1Link.direction),a
	jr @runScriptAndAnimate

@simulatedInput:
	dwb 60 $00
	dwb 48 BTN_RIGHT
	dwb  4 $00
	dwb 14 BTN_UP
	dwb 60 $00
	.dw $ffff

@runScriptAndAnimate:
	call interactionRunScript
	jp interactionAnimate

@subid03:
	call checkInteractionState
	jr nz,@runScriptAndAnimate

	ld b,$01
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $03
	jr z,+
	call interactionLoadExtraGraphics
	ld b,$00
+
	ld a,b
	call interactionSetAnimation
	call interactionInitGraphics
	call @loadScript
	jp @setVisibleAndSpawnFlower

@subid04:
@subid05:
	call checkInteractionState
	jr nz,@runScriptAndAnimate
	call @initializeMakuTree
	jr @runScriptAndAnimate

@subid06:
	call checkInteractionState
	jr nz,@runScriptAndAnimate

	ld a,GLOBALFLAG_SAW_TWINROVA_BEFORE_ENDGAME
	call checkGlobalFlag
	jp nz,@initializeMakuTree
	ld hl,w1Link.direction
	ld (hl),$00
	call setLinkForceStateToState08
	call @initGraphicsAndIncState
	call @setVisibleAndSpawnFlower

	ld b,$00
	ld hl,mainScripts.makuTree_subid06Script_part1
	ld a,GLOBALFLAG_GOT_MAKU_SEED
	push hl
	call checkGlobalFlag
	pop hl
	jr z,+
	ld b,$04
	ld hl,mainScripts.makuTree_subid06Script_part2
+
	call interactionSetScript
	ld a,>TX_0500
	call interactionSetHighTextIndex
	ld a,b
	call interactionSetAnimation
	jp @runScriptAndAnimate

@initSubid00:
	ld a,(wMakuTreeState)
	rst_jumpTable
	.dw @state00
	.dw @state01
	.dw @state02
	.dw @state03
	.dw @state04
	.dw @state05
	.dw @state06
	.dw @state07
	.dw @state08
	.dw @state09
	.dw @state0a
	.dw @state0b
	.dw @state0c
	.dw @state0d
	.dw @state0e
	.dw @state0f
	.dw @state10

@state00:
	ld a,GLOBALFLAG_0c
	call checkGlobalFlag
	jr nz,@ret
	ld a,$01
	jr @runSubidCode

@state02:
	ld a,$02
	jr @runSubidCode

@state03:
	ldbc $02, <TX_0500
	jr @runSubid0ScriptMode

@state04:
	ldbc $00, <TX_0503
	jr @runSubid0ScriptMode

@state05:
	ldbc $00, <TX_0505
	jr @runSubid0ScriptMode

@state06:
	ldbc $00, <TX_0507
	jr @runSubid0ScriptMode

@state07:
	ldbc $04, <TX_0509
	jr @runSubid0ScriptMode

@state08:
	ldbc $04, <TX_050b
	jr @runSubid0ScriptMode

@state09:
	ldbc $02, <TX_050d
	jr @runSubid0ScriptMode

@state0a:
	ldbc $00, <TX_0510
	jr @runSubid0ScriptMode

@state0b:
	ldbc $05, <TX_0512
	jr @runSubid0ScriptMode

@state0c:
	ldbc $04, <TX_0514
	jr @runSubid0ScriptMode

@state0d:
	ldbc $00, <TX_0516
	jr @runSubid0ScriptMode

@state0e:
	ld a,$06
	jr @runSubidCode

@state0f:
	ldbc $00, <TX_0518
	jr @runSubid0ScriptMode

@state10:
	call checkIsLinkedGame
	jr z,++
	ldbc $00, <TX_051a
	jr @runSubid0ScriptMode
++
	ldbc $01, <TX_051c
	jr @runSubid0ScriptMode

@state01:
	pop af
	jp interactionDelete

@runSubidCode:
	ld e,Interaction.subid
	ld (de),a
	pop af
	jp interactionCode87

@runSubid0ScriptMode:
	ld h,d
	ld l,Interaction.var3e
	ld (hl),b
	inc l
	ld (hl),c
@ret:
	ret


@initializeMakuTree:
	call @initGraphicsAndLoadScript

@setVisibleAndSpawnFlower:
	call objectSetVisible83
	call interactionSetAlwaysUpdateBit
	jp @spawnMakuFlower

@initGraphicsAndIncState:
	call @initGraphics
	jp interactionIncState

@initGraphicsAndLoadScript:
	call @initGraphics
	jr @loadScript

@initGraphics:
	call interactionLoadExtraGraphics
	jp interactionInitGraphics

@loadScript:
	ld a,>TX_0500
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@spawnMakuFlower:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_MAKU_FLOWER
	ld l,Interaction.relatedObj2
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d
	ld e,Interaction.relatedObj1
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	jp objectCopyPosition

@scriptTable:
	.dw mainScripts.makuTree_subid00Script
	.dw mainScripts.makuTree_subid01Script
	.dw mainScripts.makuTree_subid02Script
	.dw mainScripts.makuTree_subid03Script
	.dw mainScripts.makuTree_subid04Script
	.dw mainScripts.makuTree_subid05Script
	.dw mainScripts.makuTree_subid06Script_part3


; ==============================================================================
; INTERACID_MAKU_SPROUT
;
; Variables:
;   var3b: Animation
;   var3d: 0 for present maku tree, 1 for past?
;   var3e: "Script mode"; mainly determines animation (see makuSprout_subid00Script_body)
;   var3f: Text index to show for (sometimes shows the one after it as well)
; ==============================================================================
interactionCode88:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	call checkInteractionState
	jr nz,@subid0State1

	ld a,$01
	ld e,Interaction.var3d
	ld (de),a

	call @initSubid0
	call @initializeMakuSprout

@subid0State1:
	call interactionAnimateAsNpc
	ld e,Interaction.visible
	ld a,(de)
	and $8f
	ld (de),a
	jp interactionRunScript

@subid1:
	call checkInteractionState
	jr nz,@subid1State1
	call @initializeMakuSprout
	call interactionRunScript

@subid1State1:
	jr @subid0State1

@subid2:
	call checkInteractionState
	jr nz,@subid2State1

	call @initializeMakuSprout
	ld a,$01
	jp interactionSetAnimation

@subid2State1:
	call checkInteractionSubstate
	jp nz,interactionAnimate

	ld a,(wTmpcfc0.genericCutscene.state)
	cp $06
	ret nz

	call interactionIncSubstate
	jp objectSetVisible82


@initSubid0:
	ld a,(wMakuTreeState)
	rst_jumpTable
	.dw @state00
	.dw @state01
	.dw @state02
	.dw @state03
	.dw @state04
	.dw @state05
	.dw @state06
	.dw @state07
	.dw @state08
	.dw @state09
	.dw @state0a
	.dw @state0b
	.dw @state0c
	.dw @state0d
	.dw @state0e
	.dw @state0f
	.dw @state10

@state01:
@state02:
	ld a,$01
	jr @runSubidCode

@state03:
@state04:
@state05:
	ldbc $01, <TX_0570
	jr @runSubid0ScriptMode

@state06:
	ldbc $00, <TX_0576
	jr @runSubid0ScriptMode

@state07:
	ldbc $00, <TX_0578
	jr @runSubid0ScriptMode

@state08:
	ldbc $02, <TX_057a
	jr @runSubid0ScriptMode

@state09:
	ldbc $01, <TX_057c
	jr @runSubid0ScriptMode

@state0a:
	ldbc $01, <TX_057e
	jr @runSubid0ScriptMode

@state0b:
	ldbc $00, <TX_0580
	jr @runSubid0ScriptMode

@state0c:
	ldbc $00, <TX_0582
	jr @runSubid0ScriptMode

@state0d:
	ldbc $01, <TX_0584
	jr @runSubid0ScriptMode

@state0e:
	ldbc $01, <TX_0586
	jr @runSubid0ScriptMode

@state0f:
	ldbc $02, <TX_0588
	jr @runSubid0ScriptMode

@state10:
	call checkIsLinkedGame
	jr z,++

	ldbc $00, <TX_058a
	jr @runSubid0ScriptMode
++
	ldbc $01, <TX_058c
	jr @runSubid0ScriptMode

@runSubidCode:
	ld e,Interaction.subid
	ld (de),a
	pop af
	jp interactionCode88

@runSubid0ScriptMode:
	ld h,d
	ld l,Interaction.var3e
	ld (hl),b
	inc l
	ld (hl),c

@state00:
	ret


@initializeMakuSprout:
	call @loadScriptAndInitGraphics
	jp interactionSetAlwaysUpdateBit


@initGraphics: ; unused
	call interactionInitGraphics
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
	ld a,>TX_0500
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.makuSprout_subid00Script
	.dw mainScripts.makuSprout_subid01Script
	.dw mainScripts.stubScript


; ==============================================================================
; INTERACID_REMOTE_MAKU_CUTSCENE
;
; Variables:
;   var3e: Doesn't do anything
;   var3f: Text to show
; ==============================================================================
interactionCode8a:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
@subid1:
	call checkInteractionState
	jr nz,@state1

@state0:
	call returnIfScrollMode01Unset
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.var3d
	ld (de),a
	call @checkConditionsAndSetText
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete

	call @loadScript

@state1:
	call interactionRunScript
	jp c,interactionDelete
	ret

@checkConditionsAndSetText:
	ld e,Interaction.var03
	ld a,(de)
	rst_jumpTable
	.dw @val00
	.dw @val01
	.dw @val02
	.dw @val03
	.dw @val04
	.dw @val05
	.dw @val06
	.dw @val07
	.dw @val08
	.dw @val09
	.dw @val0a
	.dw @val0b

@val00:
	xor a
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b0
	jp @setTextForScript

@val01:
	ldbc $00, <TX_05b1
	jp @setTextForScript

@val02:
	ld a,TREASURE_HARP
	call checkTreasureObtained
	jp nc,@deleteSelfAndReturn
	ldbc $00, <TX_05b2
	jp @setTextForScript

@val03:
	ld a,$01
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b3
	jp @setTextForScript

@val04:
	ld a,$02
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn

	ld hl,wPastRoomFlags+$76
	set 0,(hl)
	call checkIsLinkedGame
	ld a,GLOBALFLAG_CAN_BUY_FLUTE
	call z,setGlobalFlag
	ldbc $00, <TX_05b4
	jp @setTextForScript

@val05:
	ld a,$03
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b5
	jp @setTextForScript

@val06:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b6
	jp @setTextForScript

@val07:
	ld a,$04
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b7
	jp @setTextForScript

@val08:
	ld a,$05
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b8
	jp @setTextForScript

@val09:
	ld a,$06
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b9
	jp @setTextForScript

@val0a:
	ld a,$07
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05ba
	jp @setTextForScript

@val0b:
	ldbc $00, <TX_05bb
	jp @setTextForScript


@deleteSelfAndReturn:
	pop af
	jp interactionDelete

@setTextForScript:
	ld h,d
	ld l,Interaction.var3e
	ld (hl),b
	inc l
	ld (hl),c
	ret

;;
; @param	a	Essence number
@checkEssenceObtained:
	ld hl,wEssencesObtained
	jp checkFlag


@initGraphicsAndIncState: ; Unused
	call interactionInitGraphics
	jp interactionIncState

@initGraphicsAndLoadScript: ; Unused
	call interactionInitGraphics

@loadScript:
	ld a,>TX_0500
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.remoteMakuCutsceneScript
	.dw mainScripts.remoteMakuCutsceneScript


; ==============================================================================
; INTERACID_GORON_ELDER
;
; Variables:
;   var3f: If zero, elder should face Link when he's close?
; ==============================================================================
interactionCode8b:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
@subid1:
	call checkInteractionState
	jr nz,++
	call @loadScriptAndInitGraphics
++
	call interactionRunScript
	jp c,interactionDelete
	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	jp interactionAnimateAsNpc

@subid2:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	jpab agesInteractionsBank08.shootingGalleryNpc


@initGraphics: ; unused
	call interactionInitGraphics
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.goronElderScript_subid00
	.dw mainScripts.goronElderScript_subid01


; ==============================================================================
; INTERACID_TOKAY_MEAT
; ==============================================================================
interactionCode8c:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),30
	ld a,$08
	call objectSetCollideRadius

	ld bc,$3850
	call interactionSetPosition
	ld l,Interaction.zh
	ld (hl),-$40
	ld bc,$0000
	jp objectSetSpeedZ


@state1:
	call objectAddToGrabbableObjectBuffer
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0: ; Starts falling
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jp nz,interactionDecCounter1
	call interactionIncSubstate
	call objectSetVisiblec1
	ld a,SND_FALLINHOLE
	jp playSound

@@substate1: ; Wait for it to land
	ld c,$28
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld a,SND_BOMB_LAND
	jp playSound

@@substate2: ; Sitting on the ground
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; State 2 = grabbed by power bracelet state
@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released

@justGrabbed:
	ld a,d
	ld (wTmpcfc0.wildTokay.activeMeatObject),a
	ld a,e
	ld (wTmpcfc0.wildTokay.activeMeatObject+1),a

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TOKAY_MEAT
	jp interactionIncSubstate

@beingHeld:
	ret

@released:
	ld e,Interaction.zh
	ld a,(de)
	rlca
	ret c

	call dropLinkHeldItem
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),20
	jp objectSetVisible83


@state3: ; Disappearing after being dropped on the ground
	call interactionDecCounter1
	jr nz,+
	jp interactionDelete
+
	ld a,(wFrameCounter)
	and $01
	jp z,objectSetInvisible
	jp objectSetPriorityRelativeToLink


; ==============================================================================
; INTERACID_CLOAKED_TWINROVA
; ==============================================================================
interactionCode8d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2
	ld a,>TX_2800
	call interactionSetHighTextIndex

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid0
	.dw @initSubid1
	.dw @initSubid2

@initSubid0:
	ld a,$03
	call interactionSetAnimation
	ld bc,$4088
	call interactionSetPosition

@initSubid2:
	call @loadScript
	jp objectSetInvisible

@initSubid1:
	ld bc,$4050
	call interactionSetPosition
	ld l,Interaction.counter1
	ld (hl),30
	jp objectSetInvisible


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid0
	.dw @runSubid1
	.dw @runSubid0

@runSubid0:
@runSubid2:
	call interactionRunScript
	jp nc,interactionAnimate

	call objectCreatePuff

	; Subid 2 only: when done the script, create the "real" twinrova objects
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr z,++
	ldbc INTERACID_TWINROVA, $02
	call objectCreateInteraction
++
	jp interactionDelete


; Cutscene after d7; black tower is complete
@runSubid1:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid1Substate0
	.dw @subid1Substate1
	.dw @subid1Substate2
	.dw @subid1Substate3

@subid1Substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),20
	ld a,MUS_DISASTER
	call playSound
	call objectSetVisible
	call fadeinFromBlack
	ld a,$06
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	ld a,$03
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	jp interactionIncSubstate

@subid1Substate1:
	call interactionDecCounter1IfPaletteNotFading
	ret nz
	ld (hl),20
	call interactionIncSubstate
	ld bc,TX_2808
	jp showText

@subid1Substate2:
	call interactionDecCounter1IfTextNotActive
	ret nz
	ld a,SND_LIGHTNING
	call playSound
	ld hl,wGenericCutscene.cbb3
	ld (hl),$00
	ld hl,wGenericCutscene.cbba
	ld (hl),$ff
	jp interactionIncSubstate

@subid1Substate3:
	ld hl,wGenericCutscene.cbb3
	ld b,$02
	call flashScreen
	ret z
	ld a,$02
	ld (wGenericCutscene.cbb8),a
	ld a,CUTSCENE_BLACK_TOWER_EXPLANATION
	ld (wCutsceneTrigger),a
	jp interactionDelete


@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.cloakedTwinrova_subid00Script
	.dw mainScripts.stubScript
	.dw mainScripts.cloakedTwinrova_subid02Script


; ==============================================================================
; INTERACID_OCTOGON_SPLASH
; ==============================================================================
interactionCode8e:
	ld e,Interaction.state
	ld a,(de)
	or a
	jr z,@state0

@state1:
	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	jp nz,interactionAnimate
	jp interactionDelete

@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.direction
	ld a,(hl)
	rrca
	rrca
	call interactionSetAnimation
	jp objectSetVisible81


; ==============================================================================
; INTERACID_TOKAY_CUTSCENE_EMBER_SEED
; ==============================================================================
interactionCode8f:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a
	ld bc,-$100
	call objectSetSpeedZ
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	jp objectSetVisible80

@state1:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	call objectSetInvisible
	ld a,(wTextIsActive)
	or a
	ret z

	ld l,Interaction.state
	inc (hl)
	ret

@state2:
	call retIfTextIsActive
	call interactionIncState

	ld l,Interaction.oamFlagsBackup
	ld a,$0a
	ldi (hl),a
	ldi (hl),a
	ld (hl),$06 ; [oamTileIndexBase] = $06

	ld l,Interaction.counter1
	ld (hl),58
	ld a,$0b
	call interactionSetAnimation
	jp objectSetVisible

@state3:
	call interactionAnimate
	call interactionDecCounter1
	ret nz
	jp interactionDelete


; ==============================================================================
; INTERACID_MISC_PUZZLES
; ==============================================================================
interactionCode90:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw miscPuzzles_subid00
	.dw miscPuzzles_subid01
	.dw miscPuzzles_subid02
	.dw miscPuzzles_subid03
	.dw miscPuzzles_subid04
	.dw miscPuzzles_subid05
	.dw miscPuzzles_subid06
	.dw miscPuzzles_subid07
	.dw miscPuzzles_subid08
	.dw miscPuzzles_subid09
	.dw miscPuzzles_subid0a
	.dw miscPuzzles_subid0b
	.dw miscPuzzles_subid0c
	.dw miscPuzzles_subid0d
	.dw miscPuzzles_subid0e
	.dw miscPuzzles_subid0f
	.dw miscPuzzles_subid10
	.dw miscPuzzles_subid11
	.dw miscPuzzles_subid12
	.dw miscPuzzles_subid13
	.dw miscPuzzles_subid14
	.dw miscPuzzles_subid15
	.dw miscPuzzles_subid16
	.dw miscPuzzles_subid17
	.dw miscPuzzles_subid18
	.dw miscPuzzles_subid19
	.dw miscPuzzles_subid1a
	.dw miscPuzzles_subid1b
	.dw miscPuzzles_subid1c
	.dw miscPuzzles_subid1d
	.dw miscPuzzles_subid1e
	.dw miscPuzzles_subid1f
	.dw miscPuzzles_subid20
	.dw miscPuzzles_subid21


; Boss key puzzle in D6
miscPuzzles_subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

; State 0: initialization
@state0:
	call interactionIncState

; State 1: waiting for a lever to be pulled
@state1:
	; Return if a lever has not been pulled?
	ld hl,wLever1PullDistance
	bit 7,(hl)
	jr nz,+
	inc l
	bit 7,(hl)
	ret z
+
	; Check if the chest has already been opened
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jr nz,@alreadyOpened

	; Go to state 2 (or possibly 3, if this gets called again)
	call interactionIncState

	; Check whether this is the first time pulling the lever
	ld l,Interaction.counter2
	ld a,(hl)
	or a
	jr nz,@checkRng

	; This was the first time pulling the lever; always unsuccessful
	ld (hl),$01
	jr @error

@checkRng:
	; Get a number between 0 and 3.
	call getRandomNumber
	and $03

	; If the number is 0, the chest will appear; go to state 3.
	jp z,interactionIncState

	; If the number is 1-3, make the snakes appear.
@error:
	ld a,SND_ERROR
	call playSound

	ld a,(wActiveTilePos)
	ld (wWarpDestPos),a

	ld hl,wTmpcec0
	ld b,$20
	call clearMemory

	callab roomInitialization.generateRandomBuffer

	; Spawn the snakes?
	ld hl,objectData.objectData78db
	jp parseGivenObjectData

; State 2: lever has been pulled unsuccessfully. Wait for snakes to be killed before
; returning to state 1.
@state2:
	ld a,(wNumEnemies)
	or a
	ret nz

	; Go back to state 1
	ld a,$01
	ld e,Interaction.state
	ld (de),a
	ret

; State 3: lever has been pulled successfully. Make the chest and delete self.
@state3:
	ld a,$01
	ld (wActiveTriggers),a
	jpab agesInteractionsBank08.spawnChestAndDeleteSelf

@alreadyOpened:
	ld a,$01
	ld (wActiveTriggers),a
	jp interactionDelete



; Underwater switch hook puzzle in past d6
miscPuzzles_subid01:
	call interactionDeleteAndRetIfEnabled02
	call miscPuzzles_deleteSelfAndRetIfItemFlagSet

	ld hl,@diamondPositions
	call miscPuzzles_verifyTilesAtPositions
	ret nz
	jpab agesInteractionsBank08.spawnChestAndDeleteSelf

@diamondPositions:
	.db TILEINDEX_SWITCH_DIAMOND
	.db $16 $17 $18
	.db $26 $27 $28
	.db $00



; Spot to put a rolling colored block on in present d6
miscPuzzles_subid02:
	call interactionDeleteAndRetIfEnabled02

	; Check that the tile at this position matches the cube color
	call objectGetTileAtPosition
	sub TILEINDEX_RED_TOGGLE_FLOOR
	ld b,a
	ld a,(wRotatingCubePos)
	cp l
	ret nz
	ld a,(wRotatingCubeColor)
	and $03
	cp b
	ret nz

	; They match.
	ld c,l
	ld a,TILEINDEX_STANDARD_FLOOR
	call setTile
	ld b,>wRoomCollisions
	ld a,$0f
	ld (bc),a
	ld a,SND_SOLVEPUZZLE
	call playSound
	jp interactionDelete



; Chest from solving colored cube puzzle in d6 (related to subid $02)
miscPuzzles_subid03:
	call interactionDeleteAndRetIfEnabled02
	call miscPuzzles_deleteSelfAndRetIfItemFlagSet

	ld hl,@wantedFloorTiles
	call miscPuzzles_verifyTilesAtPositions
	ret nz
	jpab agesInteractionsBank08.spawnChestAndDeleteSelf

@wantedFloorTiles:
	.db TILEINDEX_STANDARD_FLOOR
	.db $37 $65 $69
	.db $00

;;
; @param	hl	Pointer to data. First byte is a tile index; then an arbitrary
;			number of positions in the room where that tile should be; $ff to
;			give a new tile index; $00 to stop.
; @param[out]	zflag	z if all tiles matched as expected.
miscPuzzles_verifyTilesAtPositions:
	ld b,>wRoomLayout
@newTileIndex:
	ldi a,(hl)
	or a
	ret z
	ld e,a
@nextTile:
	ldi a,(hl)
	ld c,a
	or a
	ret z
	inc a
	jr z,@newTileIndex
	ld a,(bc)
	cp e
	ret nz
	jr @nextTile



; Floor changer in present D6, triggered by orb
miscPuzzles_subid04:
	call checkInteractionState
	jr z,@state0

@state1:
	; Check for change in state
	ld a,(wToggleBlocksState)
	ld b,a
	ld e,Interaction.counter2
	ld a,(de)
	cp b
	ret z

	ld a,b
	ld (de),a
	ld a,$ff
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld e,Interaction.counter1
	ld a,(de)
	inc a
	and $01
	ld b,a
	ld (de),a

	ld c,$05
	call @spawnSubid
	ld c,$06
	call @spawnSubid
	callab bank16.loadD6ChangingFloorPatternToBigBuffer
	ret

@spawnSubid:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_MISC_PUZZLES
	inc l
	ld (hl),c
	inc l
	ld (hl),b
	ret

@state0:
	ld a,(wToggleBlocksState)
	ld e,Interaction.counter2
	ld (de),a
	jp interactionIncState


; Helpers for floor changer (subid $04)
miscPuzzles_subid05:
miscPuzzles_subid06:
	ld e,Interaction.substate
	ld a,(de)
	or a
	jr nz,@substate1

@substate0:
	ld e,Interaction.subid
	ld a,(de)
	sub $05
	add a
	ld hl,@data
	rst_addDoubleIndex
	ld b,$04
	ld e,Interaction.var30
	call copyMemory
	jp interactionIncSubstate

; Values for var30-var33
; var30: Start position
; var31: Value to add to position (Y) (alternates direction each column)
; var32: Value to add to position (X)
; var33: Offset in wBigBuffer to read from
@data:
	.db $91 $f0 $01 $00 ; subid 5
	.db $1d $10 $ff $80 ; subid 6

@substate1:
	ld e,Interaction.var33
	ld a,(de)
	ld l,a
	ld h,>wBigBuffer

@nextTile:
	ldi a,(hl)
	or a
	jr z,@deleteSelf
	cp $ff
	jr nz,@setTile

	ld e,Interaction.var32
	ld a,(de)
	ld b,a
	ld e,Interaction.var30
	ld a,(de)
	add b
	ld (de),a
	ld e,Interaction.var31
	ld a,(de)
	cpl
	inc a
	ld (de),a
	call @nextRow
	jr @nextTile

@setTile:
	ldh (<hFF8B),a
	ld e,Interaction.var33
	ld a,l
	ld (de),a
	call @nextRow
	ldh a,(<hFF8B)
	jp setTile

; [var30] += [var31]
@nextRow:
	ld e,Interaction.var31
	ld a,(de)
	ld b,a
	ld e,Interaction.var30
	ld a,(de)
	ld c,a
	add b
	ld (de),a
	ret

@deleteSelf:
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionDelete



; Wall retraction event after lighting torches in past d6
miscPuzzles_subid07:
	call checkInteractionState
	jr z,@state0

@state1:
	call checkLinkVulnerable
	ret nc

	; Check if the number of lit torches has changed.
	call @checkLitTorches
	ld e,Interaction.counter1
	ld a,(de)
	cp b
	ret z

	; It's changed.
	ld a,b
	ld (de),a

	ld e,Interaction.substate
	ld a,(de)
	ld hl,@torchLightOrder
	rst_addAToHl
	ld a,(hl)
	cp b
	jr nz,@litWrongTorch

	ld a,(de)
	cp $03
	jp c,interactionIncSubstate

	; Lit all torches
	ld a, $ff ~ (DISABLE_ITEMS | DISABLE_ALL_BUT_INTERACTIONS)
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,CUTSCENE_WALL_RETRACTION
	ld (wCutsceneTrigger),a

	; Set bit 6 in the present version of this room
	call getThisRoomFlags
	ld l,<ROOM_AGES_525
	set 6,(hl)
	jp interactionDelete

@litWrongTorch:
	xor a
	ld (de),a
	ld e,Interaction.counter1
	ld (de),a
	ld a,SND_ERROR
	call playSound
	ld a,TILEINDEX_UNLIT_TORCH
	ld c,$31
	call setTile
	ld a,TILEINDEX_UNLIT_TORCH
	ld c,$33
	call setTile
	ld a,TILEINDEX_UNLIT_TORCH
	ld c,$35
	call setTile
	ld a,TILEINDEX_UNLIT_TORCH
	ld c,$53
	call setTile
	jr @makeTorchesLightable

@torchLightOrder:
	.db $01 $03 $07 $0f

@state0:
	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete

	call interactionIncState
	call @checkLitTorches
	ld a,b
	ld e,Interaction.counter1
	ld (de),a

@makeTorchesLightable:
	call @makeTorchesUnlightable
	ld hl,objectData.objectData_makeTorchesLightableForD6Room
	jp parseGivenObjectData

;;
@makeTorchesUnlightable:
	ldhl FIRST_PART_INDEX, Part.id
--
	ld a,(hl)
	cp PARTID_LIGHTABLE_TORCH
	call z,@deletePartObject
	inc h
	ld a,h
	cp LAST_PART_INDEX+1
	jr c,--
	ret

@deletePartObject:
	push hl
	dec l
	ld b,$40
	call clearMemory
	pop hl
	ret

;;
; @param[out]	b	Bitset of lit torches (in bits 0-3)
@checkLitTorches:
	ld a,TILEINDEX_LIT_TORCH
	ld b,$00
	ld hl,wRoomLayout+$31
	cp (hl)
	jr nz,+
	set 0,b
+
	ld l,$33
	cp (hl)
	jr nz,+
	set 1,b
+
	ld l,$53
	cp (hl)
	jr nz,+
	set 2,b
+
	ld l,$35
	cp (hl)
	ret nz
	set 3,b
	ret



; Checks to set the "bombable wall open" bit in d6 (north)
miscPuzzles_subid08:
	call interactionDeleteAndRetIfEnabled02
	call getThisRoomFlags
	bit ROOMFLAG_BIT_KEYDOOR_UP,(hl)
	ret z
	ld l,<ROOM_AGES_519
	set ROOMFLAG_BIT_KEYDOOR_UP,(hl)
	jp interactionDelete



; Checks to set the "bombable wall open" bit in d6 (east)
miscPuzzles_subid09:
	call interactionDeleteAndRetIfEnabled02
	call getThisRoomFlags
	bit ROOMFLAG_BIT_KEYDOOR_RIGHT,(hl)
	ret z
	ld l,<ROOM_AGES_526
	set ROOMFLAG_BIT_KEYDOOR_RIGHT,(hl)
	jp interactionDelete



; Jabu-jabu water level controller script, in the room with the 3 buttons
miscPuzzles_subid0a:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,(wActiveTriggers)
	ld e,Interaction.var30
	ld (de),a

	ld a,(wJabuWaterLevel)
	and $f0
	ld (wSwitchState),a
	jp interactionIncState

@state1:
	; Check if a button was pressed
	ld a,(wActiveTriggers)
	ld b,a
	ld e,Interaction.var30
	ld a,(de)
	xor b
	ld c,a
	ld a,b
	ld (de),a

	bit 7,c
	jr nz,@drainWater

	; Ret if none pressed
	and c
	ret z
	ld a,(wSwitchState)
	and c
	ret nz

	ld a,c
	ld hl,wSwitchState
	or (hl)
	ld (hl),a
	and $f0
	ld b,a
	ld hl,wJabuWaterLevel
	ld a,(hl)
	and $03
	inc a
	or b
	ld (hl),a
.ifndef REGION_JP
	ld a,<TX_1209
.endif
	jr @beginCutscene

@drainWater:
	ld a,(wJabuWaterLevel)
	and $07
	ret z
	xor a
	ld (wJabuWaterLevel),a
	ld (wSwitchState),a
.ifndef REGION_JP
	ld a,<TX_1208
.endif

@beginCutscene:
.ifndef REGION_JP
	ld e,Interaction.var31
	ld (de),a
.endif

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld e,Interaction.counter1
	ld a,60
	ld (de),a

	ld a,SNDCTRL_STOPMUSIC
	call playSound
	jp interactionIncState

@state2:
	call interactionDecCounter1
	ret nz

	ld a,$f0
	ld (hl),a
	call setScreenShakeCounter
	ld a,SND_FLOODGATES
	call playSound
	jp interactionIncState

@state3:
	call interactionDecCounter1
	ret nz

	ld l,Interaction.state
	ld (hl),$01
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

.ifdef REGION_JP
	ld bc,TX_1209
.else
	ld b,>TX_1200
	ld l,Interaction.var31
	ld c,(hl)
.endif
	call showText

	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,(wActiveMusic)
	jp playSound



; Ladder spawner in d7 miniboss room
miscPuzzles_subid0b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw miscPuzzles_deleteSelfOrIncStateIfRoomFlag7Set
	.dw @state1
	.dw @state2

@state1:
	ld a,(wNumEnemies)
	or a
	ret nz

	call getThisRoomFlags
	set ROOMFLAG_BIT_80,(hl)
	ld l,<ROOM_AGES_54d
	set ROOMFLAG_BIT_80,(hl)
	ld e,Interaction.counter1
	ld a,$08
	ld (de),a
	jp interactionIncState

@state2:
	call interactionDecCounter1
	ret nz

	; Add the next ladder tile
	ld (hl),$08
	call objectGetTileAtPosition
	ld c,l
	ld a,c
	ldh (<hFF92),a

	ld a,TILEINDEX_SS_LADDER
	call setTile

	ld b,INTERACID_PUFF
	call objectCreateInteractionWithSubid00

	ld e,Interaction.yh
	ld a,(de)
	add $10
	ld (de),a

	ldh a,(<hFF92)
	cp $90
	ret c

	; Restore the entrance on the left side
	ld c,$80
	ld a,TILEINDEX_SS_52
	call setTile
	ld c,$90
	ld a,TILEINDEX_SS_EMPTY
	call setTile

	ld a,SND_SOLVEPUZZLE
	call playSound
	xor a
	ld (wDisableLinkCollisionsAndMenu),a
	jp interactionDelete



; Switch hook puzzle early in d7 for a small key
miscPuzzles_subid0c:
	call interactionDeleteAndRetIfEnabled02
	call miscPuzzles_deleteSelfAndRetIfItemFlagSet

	ld hl,miscPuzzles_subid0c_wantedTiles
	call miscPuzzles_verifyTilesAtPositions
	ret nz

;;
miscPuzzles_dropSmallKeyHere:
	ldbc TREASURE_SMALL_KEY, $01
	call createTreasure
	ret nz
	call objectCopyPosition
	jp interactionDelete

miscPuzzles_subid0c_wantedTiles:
	.db TILEINDEX_SWITCH_DIAMOND
	.db $36 $3a $76 $7a
	.db $00



; Staircase spawner after moving first set of stone panels in d8
miscPuzzles_subid0d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call getThisRoomFlags
	and ROOMFLAG_40
	jp nz,interactionDelete

	ld a,(wNumTorchesLit)
	cp $01
	ret nz
	ld hl,wActiveTriggers
	ld a,(hl)
	cp $07
	ret nz

	ld e,Interaction.counter1
	ld a,30
	ld (de),a
	ld a,$08
	call setScreenShakeCounter
	ld a,SND_DOORCLOSE
	call playSound
	jp interactionIncState

@state1:
	call interactionDecCounter1
	ret nz

	ld hl,wActiveTriggers
	ld a,(hl)
	cp $07
	jr z,++
	ld e,Interaction.state
	xor a
	ld (de),a
	ret
++
	set 7,(hl)
	jp interactionIncState

@state2:
	; Wait for bit 7 of wActiveTriggers to be unset by another object?
	ld a,(wActiveTriggers)
	bit 7,a
	ret nz

	ld a,SND_SOLVEPUZZLE
	call playSound
	ld b,INTERACID_PUFF
	call objectCreateInteractionWithSubid00

	call objectGetTileAtPosition
	ld c,l
	ld a,TILEINDEX_NORTH_STAIRS
	call setTile
	jp interactionDelete



; Staircase spawner after putting in slates in d8
miscPuzzles_subid0e:
	call checkInteractionState
	jp nz,@state1

@state0:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_40,(hl)
	jp nz,interactionDelete

	; Wait for all slates to be put in
	ld a,(hl)
	and ROOMFLAG_01|ROOMFLAG_02|ROOMFLAG_04|ROOMFLAG_08
	cp  ROOMFLAG_01|ROOMFLAG_02|ROOMFLAG_04|ROOMFLAG_08
	ret nz

	ld hl,wActiveTriggers
	set 7,(hl)
	jp interactionIncState

@state1:
	; Wait for another object to unset bit 7 of wActiveTriggers?
	ld a,(wActiveTriggers)
	bit 7,a
	ret nz

	ld a,SND_SOLVEPUZZLE
	call playSound
	ld b,INTERACID_PUFF
	call objectCreateInteractionWithSubid00

	call objectGetTileAtPosition
	ld c,l
	ld a,TILEINDEX_NORTH_STAIRS
	call setTile
	jp interactionDelete



; Octogon boss initialization (in the room just before the boss)
miscPuzzles_subid0f:
	ld hl,wTmpcfc0.octogonBoss.loadedExtraGfx
	xor a
	ldi (hl),a
	ldi (hl),a ; [var03] = 0
	dec a
	ldi (hl),a ; [direction] = $ff
	ld (hl),$28 ; [health]
	inc l
	ld (hl),$28 ; [y]
	inc l
	ld (hl),$78 ; [x]
	inc l
	ld (hl),a ; [var30] = $ff
	jp interactionDelete



; Something at the top of Talus Peaks?
miscPuzzles_subid10:
	ld hl,wTmpcfc0.patchMinigame.fixingSword
	ld b,$08
	call clearMemory
	jp interactionDelete



; D5 keyhole opening
miscPuzzles_subid11:
	call checkInteractionState
	jp nz,interactionRunScript

	call returnIfScrollMode01Unset
	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete

	push de
	call reloadTileMap
	pop de
	ld hl,mainScripts.miscPuzzles_crownDungeonOpeningScript

;;
miscPuzzles_setScriptAndIncState:
	call interactionSetScript
	call interactionSetAlwaysUpdateBit
	jp interactionIncState



; D6 present/past keyhole opening
miscPuzzles_subid12:
	call checkInteractionState
	jp nz,interactionRunScript

	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete
	ld hl,mainScripts.miscPuzzles_mermaidsCaveDungeonOpeningScript
	jr miscPuzzles_setScriptAndIncState



; Eyeglass library keyhole opening
miscPuzzles_subid13:
	call checkInteractionState
	jp nz,interactionRunScript

	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete
	ld hl,mainScripts.miscPuzzles_eyeglassLibraryOpeningScript
	jr miscPuzzles_setScriptAndIncState



; Spot to put a rolling colored block on in Hero's Cave
miscPuzzles_subid14:
	call checkInteractionState
	jp z,miscPuzzles_deleteSelfOrIncStateIfRoomFlag7Set

	; Check that the tile at this position matches the cube color
	call objectGetTileAtPosition
	sub TILEINDEX_RED_TOGGLE_FLOOR
	cp $03
	ret nc
	ld b,a
	ld a,(wRotatingCubePos)
	cp l
	ret nz
	ld a,(wRotatingCubeColor)
	and $03
	cp b
	ret nz

	; They match.
	ld c,l
	ld hl,wActiveTriggers
	ld a,b
	call setFlag

	ld a,$a3
	call setTile

	ld b,>wRoomCollisions
	ld a,$0f
	ld (bc),a
	ld a,SND_CLINK
	jp playSound



; Stairs from solving colored cube puzzle in Hero's Cave (related to subid $14)
miscPuzzles_subid15:
	call checkInteractionState
	jp z,miscPuzzles_deleteSelfOrIncStateIfRoomFlag7Set

	ld a,(wActiveTriggers)
	cp $07
	ret nz

	ld a,SND_SOLVEPUZZLE
	call playSound
	ld a,TILEINDEX_INDOOR_DOWNSTAIRCASE
	ld c,$15
	call setTile
	call getThisRoomFlags
	set ROOMFLAG_BIT_80,(hl)
	jp interactionDelete



; Warps Link out of Hero's Cave upon opening the chest
miscPuzzles_subid16:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw miscPuzzles_deleteSelfOrIncStateIfItemFlagSet
	.dw @state1
	.dw @state2

@state1:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	ret z
	call interactionIncState

@state2:
	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wDisableLinkCollisionsAndMenu),a
	call retIfTextIsActive
	ld hl,@warpDestData
	call setWarpDestVariables
	jp interactionDelete

@warpDestData:
	m_HardcodedWarpA ROOM_AGES_048, $01, $28, $03



; Enables portal in Hero's Cave first room if its other end is active
miscPuzzles_subid17:
	call getThisRoomFlags
	push hl
	ld l,<ROOM_AGES_4c9
	bit ROOMFLAG_BIT_ITEM,(hl)
	pop hl
	jr z,+
	set ROOMFLAG_BIT_ITEM,(hl)
+
	jp interactionDelete



; Drops a key in hero's cave block-pushing puzzle
miscPuzzles_subid18:
	call checkInteractionState
	jp z,miscPuzzles_deleteSelfOrIncStateIfItemFlagSet

	ld hl,wRoomLayout+$95
	ld a,(hl)
	cp TILEINDEX_PUSHABLE_STATUE
	ret nz
	ld l,$5d
	ld a,(hl)
	cp TILEINDEX_PUSHABLE_STATUE
	ret nz
	jp miscPuzzles_dropSmallKeyHere



; Bridge controller in d5 room after the miniboss
miscPuzzles_subid19:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw interactionIncState
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

; Trigger off, waiting for it to be pressed
@state1:
	ld a,(wActiveTriggers)
	rrca
	ret nc
	ld e,Interaction.counter1
	ld a,$08
	ld (de),a
	jp interactionIncState

; Trigger enabled, in the process of extending the bridge
@state2:
	ld a,(wActiveTriggers)
	rrca
	jr nc,@@releasedTrigger
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld hl,wRoomLayout+$55
--
	ld c,l
	ldi a,(hl)
	cp TILEINDEX_BLANK_HOLE
	jr nz,++
	ld a,TILEINDEX_HORIZONTAL_BRIDGE
	call setTileInAllBuffers
	ld a,SND_DOORCLOSE
	jp playSound
++
	ld a,l
	cp $5a
	jr c,--
	jp interactionIncState

@@releasedTrigger:
	call interactionIncState
	inc (hl)
	ret

; Bridge fully extended, waiting for trigger to be released
@state3:
	ld a,(wActiveTriggers)
	rrca
	ret c
	jp interactionIncState

; Trigger released, in the process of retracting the bridge
@state4:
	ld a,(wActiveTriggers)
	rrca
	jr c,@@pressedTrigger
	call interactionDecCounter1
	ret nz

	ld (hl),$08

	ld hl,wRoomLayout+$59
--
	ld c,l
	ldd a,(hl)
	cp TILEINDEX_BLANK_HOLE
	jr z,++

	cp TILEINDEX_SWITCH_DIAMOND
	call z,@createDebris

	ld a,TILEINDEX_BLANK_HOLE
	call setTileInAllBuffers
	ld a,SND_DOORCLOSE
	jp playSound
++
	ld a,l
	cp $55
	jr nc,--

@@pressedTrigger:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret

@createDebris:
	push hl
	push bc
	ld b,INTERACID_ROCKDEBRIS
	call objectCreateInteractionWithSubid00
	pop bc
	pop hl
	ret



; Checks solution to pushblock puzzle in Hero's Cave
miscPuzzles_subid1a:
	call interactionDeleteAndRetIfEnabled02
	call miscPuzzles_deleteSelfAndRetIfItemFlagSet

	ld hl,@wantedTiles
	call miscPuzzles_verifyTilesAtPositions
	ret nz
	jpab agesInteractionsBank08.spawnChestAndDeleteSelf

@wantedTiles:
	.db TILEINDEX_RED_PUSHABLE_BLOCK    $4a $4b $4c $ff
	.db TILEINDEX_YELLOW_PUSHABLE_BLOCK $5a $5c $ff
	.db TILEINDEX_BLUE_PUSHABLE_BLOCK   $6a $6c $00



; Subids $1b-$1d: Spawn gasha seeds at the top of the maku tree at specific times.
; b = essence that must be obtained; c = position to spawn it at.
miscPuzzles_subid1b:
	ldbc $08, $53
	jr ++

miscPuzzles_subid1c:
	ldbc $40, $34
	jr ++

miscPuzzles_subid1d:
	ldbc $20, $34
++
	push bc
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	pop bc
	jr nc,@delete
	and b
	jr z,@delete

	call objectSetShortPosition
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jr nz,@delete

	ld bc,TREASURE_OBJECT_GASHA_SEED_07
	call createTreasure
	call z,objectCopyPosition
@delete:
	jp interactionDelete



; Play "puzzle solved" sound after navigating eyeball puzzle in final dungeon
miscPuzzles_subid1e:
	call returnIfScrollMode01Unset
	ld a,(wScreenTransitionDirection)
	or a
	jp nz,interactionDelete
	ld a,SND_SOLVEPUZZLE
	call playSound
	jp interactionDelete



; Checks if Link gets stuck in the d5 boss key puzzle, resets the room if so
miscPuzzles_subid1f:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw interactionIncState
	.dw @state1
	.dw @state2

@state1:
	call interactionDecCounter1
	ret nz

	ld (hl),30

	; Get Link's short position in 'e'
	ld hl,w1Link.yh
	ldi a,(hl)
	and $f0
	ld b,a
	inc l
	ld a,(hl)
	and $f0
	swap a
	or b
	ld e,a

	push de
	ld hl,@offsetsToCheck
	ld d,$08

@checkNextOffset:
	ldi a,(hl)
	add e
	ld c,a
	ld b,>wRoomCollisions
	ld a,(bc)
	or a
	jr z,@doneCheckingIfTrapped

	; For odd-indexed offsets only (one tile away from Link), check if we're near the
	; screen edge? If so, skip the next check?
	bit 0,d
	jr nz,++

	ld b,>wRoomLayout
	ld a,(bc)
	or a
	jr nz,++
	inc hl
	dec d
++
	dec d
	jr nz,@checkNextOffset

@doneCheckingIfTrapped:
	ld a,d
	pop de
	or a
	ret nz

	; Link is trapped; warp him out
	call checkLinkVulnerable
	ret nc
	ld a,DISABLE_LINK
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld a,SND_ERROR
	call playSound

	ld e,Interaction.counter1
	ld a,60
	ld (de),a
	jp interactionIncState

; Checks if there are solid walls / holes at all of these positions relative to Link
@offsetsToCheck:
	.db $f0 $e0 $01 $02 $10 $20 $ff $fe

@state2:
	call interactionDecCounter1
	ret nz
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld hl,@warpDest
	jp setWarpDestVariables

@warpDest:
	m_HardcodedWarpA ROOM_AGES_49b, $00, $12, $03



; Money in sidescrolling room in Hero's Cave
miscPuzzles_subid20:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jr nz,@delete

	ld bc,TREASURE_OBJECT_RUPEES_16
	call createTreasure
	jp nz,@delete
	call objectCopyPosition
@delete:
	jp interactionDelete



; Creates explosions while screen is fading out; used in some cutscene?
miscPuzzles_subid21:
	call checkInteractionState
	jr z,@state0

	ld a,(wPaletteThread_mode)
	or a
	jp z,interactionDelete

	ld a,(wFrameCounter)
	ld b,a
	and $1f
	ret nz

	ld a,b
	and $70
	swap a
	ld hl,@explosionPositions
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_EXPLOSION
	jp objectCopyPositionWithOffset

@explosionPositions:
	.db $f4 $0c
	.db $04 $fb
	.db $08 $10
	.db $fe $f4
	.db $0c $08
	.db $fc $04
	.db $06 $f8
	.db $f8 $fe

@state0:
	call interactionIncState
	ld a,$04
	jp fadeoutToWhiteWithDelay

;;
miscPuzzles_deleteSelfAndRetIfItemFlagSet:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	ret z
	pop hl
	jp interactionDelete

;;
miscPuzzles_deleteSelfOrIncStateIfItemFlagSet:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jp nz,interactionDelete
	jp interactionIncState

;;
miscPuzzles_deleteSelfOrIncStateIfRoomFlag7Set:
	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete
	jp interactionIncState

;;
; Unused
miscPuzzles_deleteSelfOrIncStateIfRoomFlag6Set:
	call getThisRoomFlags
	and ROOMFLAG_40
	jp nz,interactionDelete
	jp interactionIncState



; ==============================================================================
; INTERACID_FALLING_ROCK
; ==============================================================================
interactionCode92:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw fallingRock_subid00
	.dw fallingRock_subid01
	.dw fallingRock_subid02
	.dw fallingRock_subid03
	.dw fallingRock_subid04
	.dw fallingRock_subid05
	.dw fallingRock_subid06


; Spawner of falling rocks; stops when $cfdf is nonzero. Used when freeing goron elder.
fallingRock_subid00:
	call checkInteractionState
	jr nz,@state1

@state0:
	call interactionIncState
	ld l,Interaction.counter2
	ld (hl),$01
@state1:
	ld a,(wTmpcfc0.goronCutscenes.elder_stopFallingRockSpawner)
	or a
	jp nz,interactionDelete

	call interactionDecCounter2
	ret nz

	ld l,Interaction.counter2
	ld (hl),20
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_FALLING_ROCK
	inc l
	ld (hl),$01
	inc l
	ld e,Interaction.var03
	ld a,(de)
	ld (hl),a
	ret


; Instance of falling rock spawned by subid $00
fallingRock_subid01:
	call checkInteractionState
	jr nz,@state1
	call fallingRock_initGraphicsAndIncState
	call fallingRock_chooseRandomPosition

@state1:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	jr nz,@ret

	; Rock has hit the ground
	call objectReplaceWithAnimationIfOnHazard
	jp c,interactionDelete

	ld a,SND_BREAK_ROCK
	call playSound
	call @spawnDebris
	ld a,$04
	call setScreenShakeCounter
	jp interactionDelete
@ret:
	ret

@spawnDebris:
	call getRandomNumber
	and $03
	ld c,a
	ld b,$00
@next:
	push bc
	ldbc INTERACID_FALLING_ROCK, $02
	call objectCreateInteraction
	pop bc
	ret nz
	ld l,Interaction.counter1
	ld (hl),c
	ld l,Interaction.angle
	ld (hl),b
	inc b
	ld a,b
	cp $04
	jr nz,@next
	ret


; Used by gorons when freeing elder?
fallingRock_subid02:
	call checkInteractionState
	jr nz,@state1

@state0:
	call fallingRock_initGraphicsAndIncState
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr nz,++

	ld l,Interaction.counter1
	ld a,(hl)
	jr @loadAngle
++
	ld l,Interaction.counter1
	ld a,(hl)
	add $04
@loadAngle:
	add a
	add a
	ld l,Interaction.angle
	add (hl)
	ld bc,@angles
	call addAToBc
	ld a,(bc)
	ld (hl),a
	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr nz,@lowSpeed

	ld l,Interaction.speed
	ld (hl),SPEED_180
	ld l,Interaction.speedZ
	ld a,$18
	ldi (hl),a
	ld (hl),$ff
	ret

@lowSpeed:
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.speedZ
	ld a,$1c
	ldi (hl),a
	ld (hl),$ff
	ret

; List of angle values.
; A byte is read from offset: ([counter1] + ([var03] != 0 ? 4 : 0)) * 4 + [angle]
; (These 3 variables should be set by whatever spawned this object)
@angles:
	.db $04 $0c $14 $1c $02 $0a $12 $1a
	.db $04 $0c $14 $1c $06 $0e $16 $1e
	.db $1a $14 $0c $06 $16 $1c $04 $0a

@state1:
	ld a,(wTmpcfc0.goronCutscenes.cfde)
	or a
	jp nz,interactionDelete

fallingRock_updateSpeedAndDeleteWhenLanded:
	ld c,$18
	call objectUpdateSpeedZ_paramC
	jp z,interactionDelete
	jp objectApplySpeed


; A twinkle? angle is a value from 0-3, indicating a diagonal to move in.
fallingRock_subid03:
	call checkInteractionState
	jr nz,fallingRock_subid03_state1

@state0:
	call fallingRock_initGraphicsAndIncState
	call interactionSetAlwaysUpdateBit
fallingRock_initDiagonalAngle:
	ld l,Interaction.angle
	ld a,(hl)
	ld bc,@diagonalAngles
	call addAToBc
	ld a,(bc)
	ld (hl),a
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ret

@diagonalAngles:
	.db $04 $0c $14 $1c

fallingRock_subid03_state1:
	ld e,Interaction.animParameter
	ld a,(de)
	cp $ff
	jp z,interactionDelete
	call interactionAnimate
	jp objectApplySpeed


; Blue/Red rock debris, moving straight on a diagonal? (angle from 0-3)
fallingRock_subid04:
fallingRock_subid05:
	call checkInteractionState
	jr nz,@state1

@state0:
	call fallingRock_initGraphicsAndIncState
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.counter1
	ld (hl),$0c
	jr fallingRock_initDiagonalAngle
@state1:
	call interactionDecCounter1
	jp z,interactionDelete
	call interactionAnimate
	jp objectApplySpeed


; Debris from pickaxe workers?
fallingRock_subid06:
	call checkInteractionState
	jp nz,fallingRock_updateSpeedAndDeleteWhenLanded

@state0:
	call fallingRock_initGraphicsAndIncState
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.var03
	ld a,(hl)
	or $08
	ld l,Interaction.oamFlags
	ld (hl),a
	ld l,Interaction.counter2
	ld a,(hl)
	or a
	jr z,+
	dec a
+
	ld b,a
	ld l,Interaction.visible
	ld a,(hl)
	and $bc
	or b
	ld (hl),a

	ld l,Interaction.angle
	ld a,(hl)
	ld bc,@angles
	call addAToBc
	ld a,(bc)
	ld (hl),a
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld l,Interaction.speedZ
	ld a,$40
	ldi (hl),a
	ld (hl),$ff
	ret

@angles:
	.db $08 $18

;;
fallingRock_initGraphicsAndIncState:
	call interactionInitGraphics
	call objectSetVisiblec1
	jp interactionIncState

;;
; Randomly choose a position from a list of possible positions. var03 determines which
; list it reads from?
fallingRock_chooseRandomPosition:
	ld e,Interaction.var03
	ld a,(de)
	or a
	ld hl,@positionList1
	jr z,++
	ld hl,@positionList2
	ld e,Interaction.oamFlags
	ld a,$04
	ld (de),a
++
	call getRandomNumber
	and $0f
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Interaction.yh
	ld (de),a
	cpl
	inc a
	sub $08
	ld e,Interaction.zh
	ld (de),a
	ldi a,(hl)
	ld e,Interaction.xh
	ld (de),a
	ret

@positionList1:
	.db $50 $18
	.db $60 $18
	.db $70 $18
	.db $48 $20
	.db $50 $28
	.db $70 $28
	.db $40 $38
	.db $60 $38
	.db $6c $38
	.db $78 $38
	.db $50 $48
	.db $70 $48
	.db $48 $50
	.db $50 $58
	.db $60 $58
	.db $70 $58

@positionList2:
	.db $50 $38
	.db $60 $38
	.db $70 $38
	.db $48 $40
	.db $50 $48
	.db $70 $48
	.db $40 $58
	.db $60 $58
	.db $6c $88
	.db $78 $88
	.db $50 $98
	.db $70 $98
	.db $48 $a0
	.db $50 $a8
	.db $60 $a8
	.db $70 $a8


; ==============================================================================
; INTERACID_TWINROVA
;
; Variables:
;   var3a: Index for "loadAngleAndCounterPreset" function
; ==============================================================================
interactionCode93:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw twinrova_state1

@state0:
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	jr nc,@subid2AndUp

@subid0Or1:
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $08
	ret nz
	call twinrova_loadGfx
	jr ++

@subid2AndUp:
	cp $06
	call nz,interactionLoadExtraGraphics
++
	call interactionIncState
	call interactionInitGraphics
	call objectSetVisiblec1
	ld a,>TX_2800
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw twinrova_initSubid00
	.dw twinrova_initOtherHalf
	.dw twinrova_initSubid02
	.dw twinrova_initOtherHalf
	.dw twinrova_initSubid04
	.dw twinrova_initOtherHalf
	.dw twinrova_initSubid06
	.dw twinrova_initOtherHalf

;;
twinrova_loadGfx:
	ld hl,wLoadedObjectGfx+10
	ld b,$03
	ld a,AGES_OBJ_GFXH_2c
--
	ldi (hl),a
	inc a
	ld (hl),$01
	inc l
	dec b
	jr nz,--
	push de
	call reloadObjectGfx
	pop de
	ret

twinrova_initSubid06:
	ld h,d
	ld l,Interaction.var3a
	ld (hl),$00
	call twinrova_loadScript
	ld bc,$4234
	jr twinrova_genericInitialize

twinrova_initSubid02:
	ld h,d
	ld l,Interaction.var3a
	ld (hl),$04
	ld l,Interaction.var38
	ld (hl),$02
	call objectSetInvisible
	ld bc,$3850
	jr twinrova_genericInitialize

twinrova_initSubid04:
	ld h,d
	ld l,Interaction.var38
	ld (hl),$1e

twinrova_initSubid00:
	ld h,d
	ld l,Interaction.var3a
	ld (hl),$00
	ld bc,$f888

twinrova_genericInitialize:
	call interactionSetPosition
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld l,Interaction.speed
	ld (hl),SPEED_200
	ld l,Interaction.zh
	ld (hl),-$08

	; Spawn the other half ([subid]+1)
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERACID_TWINROVA
	inc l
	ld e,l
	ld a,(de)
	inc a
	ld (hl),a
	ld l,Interaction.relatedObj1
	ld (hl),Interaction.start
	inc l
	ld (hl),d
++
	call twinrova_loadAngleAndCounterPreset
	call twinrova_updateDirectionFromAngle
	ld a,SND_BEAM2
	call playSound
	jpab scriptHelp.objectWritePositionTocfd5

;;
twinrova_loadAngleAndCounterPreset:
	ld e,Interaction.var3a
	ld a,(de)
	ld b,a

;;
; Loads preset values for angle and counter1 variables for an interaction. The values it
; loads depends on parameter 'b' (the preset index) and 'Interaction.counter2' (the index
; in the preset to use).
;
; Generally used to make an object move around in circular-ish patterns?
;
; @param	b	Preset to use
; @param[out]	b	Zero if end of data reached; nonzero otherwise.
loadAngleAndCounterPreset:
	ld a,b
	ld hl,presetInteractionAnglesAndCounters
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld e,Interaction.counter2
	ld a,(de)
	rst_addDoubleIndex

	ldi a,(hl)
	ld e,Interaction.angle
	ld (de),a
	ld a,(hl)
	or a
	ld b,a
	ret z

	ld h,d
	ld l,Interaction.counter1
	ldi (hl),a
	inc (hl) ; [counter2]++
	or $01
	ret

;;
twinrova_updateDirectionFromAngle:
	ld e,Interaction.angle
	call convertAngleDeToDirection
	and $03
	ld l,Interaction.direction
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation


; Initialize odd subids (the half of twinrova that just follows along)
twinrova_initOtherHalf:
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.oamFlags
	ld (hl),$01

	; Copy position & stuff from other half, inverted if necessary
	ld a,Object.enabled
	call objectGetRelatedObject1Var

;;
; @param	h	Object to copy visiblility, direction, position from
twinrova_takeInvertedPositionFromObject:
	ld l,Interaction.visible
	ld e,l
	ld a,(hl)
	ld (de),a

	call objectTakePosition
	ld l,Interaction.xh
	ld b,(hl)
	ld a,$50
	sub b
	add $50
	ld e,Interaction.xh
	ld (de),a

	ld l,Interaction.direction
	ld a,(hl)
	ld b,a
	and $01
	jr z,++

	ld a,b
	ld b,$01
	cp $03
	jr z,++
	ld b,$03
++
	ld a,b
	ld h,d
	ld l,Interaction.direction
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation


; This data contains "presets" for an interacton's angle and counter1.
presetInteractionAnglesAndCounters:
	.dw @data0
	.dw @data1
	.dw @data2
	.dw @data3
	.dw @data4
	.dw @data5

; Data format:
;   b0: Value for Interaction.angle
;   b1: Value for Interaction.counter1 (or $00 for end)

@data0: ; Used by Twinrova
	.db $11 $28
	.db $12 $10
	.db $13 $07
	.db $15 $05
	.db $17 $04
	.db $19 $04
	.db $1a $05
	.db $1d $07
	.db $1f $12
	.db $00 $00

@data1:
@data5:
	.db $03 $06
	.db $04 $06
	.db $06 $06
	.db $07 $06
	.db $08 $04
	.db $09 $06
	.db $0a $06
	.db $0c $04
	.db $0e $04
	.db $0f $04
	.db $10 $04
	.db $11 $04
	.db $13 $06
	.db $14 $0c
	.db $15 $30
	.db $00 $00

@data2: ; Ralph spinning his sword in credits cutscene
	.db $1a $12
	.db $1e $12
	.db $02 $12
	.db $06 $12
	.db $0a $12
	.db $0e $12
	.db $12 $12
	.db $16 $12
	.db $16 $12
	.db $12 $12
	.db $0e $12
	.db $0a $12
	.db $04 $12
	.db $02 $12
	.db $1e $10
	.db $1a $04
	.db $00 $00

@data3: ; INTERACID_RAFTWRECK_CUTSCENE_HELPER
	.db $15 $0c
	.db $16 $0c
	.db $17 $12
	.db $18 $14
	.db $19 $14
	.db $1a $20
	.db $00 $00

@data4: ; Used by Twinrova
	.db $0e $03
	.db $0c $03
	.db $0a $03
	.db $08 $03
	.db $06 $03
	.db $04 $03
	.db $02 $03
	.db $00 $03
	.db $1e $06
	.db $1c $06
	.db $1a $06
	.db $18 $06
	.db $16 $06
	.db $14 $06
	.db $12 $06
	.db $0f $08
	.db $00 $00


twinrova_state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw @runOtherHalf
	.dw @runSubid02
	.dw @runOtherHalf
	.dw @runSubid04
	.dw @runOtherHalf
	.dw @runSubid06
	.dw @runOtherHalf

@runSubid00:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid00State0
	.dw @subid00State1
	.dw @subid00State2

@subid00State0:
	callab scriptHelp.objectWritePositionTocfd5
	call interactionAnimate
	call objectApplySpeed
	call interactionDecCounter1
	call z,twinrova_loadAngleAndCounterPreset
	jp nz,twinrova_updateDirectionFromAngle
	call interactionIncSubstate
	jp twinrova_loadScript

@subid00State1:
	call interactionAnimate
	call objectOscillateZ
	call interactionRunScript
	ret nc

	ld a,SND_BEAM2
	call playSound
	callab scriptHelp.objectWritePositionTocfd5
	call interactionIncSubstate
	ld l,Interaction.counter2
	ld (hl),$00
	ld l,Interaction.var3a
	inc (hl)
	jp twinrova_loadAngleAndCounterPreset

@subid00State2:
	callab scriptHelp.objectWritePositionTocfd5
	call interactionAnimate
	call objectApplySpeed
	call interactionDecCounter1
	call z,twinrova_loadAngleAndCounterPreset
	jp nz,twinrova_updateDirectionFromAngle
	ld a,$09
	ld (wTmpcfc0.genericCutscene.cfd0),a
	jp interactionDelete

@runOtherHalf:
	call interactionAnimate
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,interactionDelete
	jp twinrova_takeInvertedPositionFromObject

@runSubid02:
@runSubid04:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid02State0
	.dw @subid00State0
	.dw @subid00State1
	.dw @subid00State2

@subid02State0:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz
	call objectSetVisiblec1
	jp interactionIncSubstate

@runSubid06:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid00State1
	.dw @subid00State2

;;
twinrova_loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.twinrova_subid00Script
	.dw mainScripts.stubScript
	.dw mainScripts.twinrova_subid02Script
	.dw mainScripts.stubScript
	.dw mainScripts.twinrova_subid04Script
	.dw mainScripts.stubScript
	.dw mainScripts.twinrova_subid06Script

;;
; Gets a position stored in $cfd5/$cfd6?
;
; @param[out]	bc	Position
func_0a_7877:
	ld hl,wTmpcfc0.genericCutscene.cfd5
	ld b,(hl)
	inc l
	ld c,(hl)
	ret


; ==============================================================================
; INTERACID_PATCH
;
; Variables:
;   var38: 0 if Link has the broken tuni nut; 1 otherwise (upstairs script)
;   var39: Set by another object (subid 3) when all beetles are killed
; ==============================================================================
interactionCode94:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw patch_subid00
	.dw patch_subid01
	.dw patch_subid02
	.dw patch_subid03
	.dw patch_subid04
	.dw patch_subid05
	.dw patch_subid06
	.dw patch_subid07


; Patch in the upstairs room
patch_subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	; If tuni nut's state is 1, set it back to 0 (put it back in Link's inventory if
	; the tuni nut game failed)
	ld hl,wTuniNutState
	ld a,(hl)
	dec a
	jr nz,+
	ld (hl),a
+
	; Similarly, revert the trade item back to broken sword if failed the minigame
	ld hl,wTradeItem
	ld a,(hl)
	cp TRADEITEM_DOING_PATCH_GAME
	jr nz,+
	ld (hl),TRADEITEM_BROKEN_SWORD
+
	ld a,(wTmpcfc0.patchMinigame.patchDownstairs)
	dec a
	jp z,interactionDelete

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState

	ld l,Interaction.speed
	ld (hl),SPEED_100

	call objectSetVisiblec2
	ld a,GLOBALFLAG_PATCH_REPAIRED_EVERYTHING
	call checkGlobalFlag
	ld hl,mainScripts.patch_upstairsRepairedEverythingScript
	jr nz,@setScript

	ld a,<TX_5813
	ld (wTmpcfc0.patchMinigame.itemNameText),a
	ld a,$01
	ld (wTmpcfc0.patchMinigame.fixingSword),a

	ld a,TREASURE_TRADEITEM
	call checkTreasureObtained
	jr nc,@notRepairingSword
	cp TRADEITEM_BROKEN_SWORD
	jr nz,@notRepairingSword

	ld a,TREASURE_SWORD
	call checkTreasureObtained
	and $01
	ld (wTmpcfc0.patchMinigame.swordLevel),a
	ld hl,mainScripts.patch_upstairsRepairSwordScript
	jr @setScript

@notRepairingSword:
	ld a,<TX_5812
	ld (wTmpcfc0.patchMinigame.itemNameText),a
	xor a
	ld (wTmpcfc0.patchMinigame.fixingSword),a

	; Set var38 to 1 if Link doesn't have the broken tuni nut
	ld a,TREASURE_TUNI_NUT
	call checkTreasureObtained
	ld hl,mainScripts.patch_upstairsRepairTuniNutScript
	jr nc,++
	or a
	jr z,@setScript
++
	ld e,Interaction.var38
	ld a,$01
	ld (de),a
@setScript:
	jp interactionSetScript

@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionRunScript
	jp nc,npcFaceLinkAndAnimate

	; Done the script; now load another script to move downstairs

	call interactionIncState
	ld hl,mainScripts.patch_upstairsMoveToStaircaseScript
	jp interactionSetScript


@state2:
	call interactionRunScript
	jp nc,interactionAnimate

	; Done moving downstairs; restore control to Link
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	inc a
	ld (wTmpcfc0.patchMinigame.patchDownstairs),a
	jp interactionDelete


; Patch in his minigame room
patch_subid01:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@state0:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState
	call objectSetVisiblec2

	ld hl,wTmpcfc0.patchMinigame.patchDownstairs
	ldi a,(hl)
	or a
	jp z,interactionDelete

	ldi a,(hl) ; a = [wTmpcfc0.patchMinigame.wonMinigame]
	or a
	jp nz,@alreadyWonMinigame

	xor a
	ldi (hl),a ; [wTmpcfc0.patchMinigame.gameStarted]
	ldi (hl),a ; [wTmpcfc0.patchMinigame.failedGame]
	ld (hl),a  ; [wTmpcfc0.patchMinigame.screenFadedOut]
	inc a
	ld (wDiggingUpEnemiesForbidden),a
	ld hl,mainScripts.patch_downstairsScript
	jp interactionSetScript

; Waiting for Link to talk to Patch to start the minigame
@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call interactionRunScript
	jp nc,npcFaceLinkAndAnimate

	; Script ended, meaning the minigame will begin now

	ld a,$01
	ld (wTmpcfc0.patchMinigame.gameStarted),a

	ld a,SND_WHISTLE
	call playSound
	ld a,MUS_MINIBOSS
	ld (wActiveMusic),a
	call playSound

	; Spawn subid 3, a "manager" for the beetle enemies.
	ldbc INTERACID_PATCH, $03
	call objectCreateInteraction
	ret nz
	ld l,Interaction.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d

	; Update the tuni nut or trade item state
	ld a,(wTmpcfc0.patchMinigame.fixingSword)
	or a
	ld hl,wTuniNutState
	ld a,$01
	jr z,++
	ld hl,wTradeItem
	ld a,TRADEITEM_DOING_PATCH_GAME
++
	ld (hl),a

	ld a,$06
	call interactionSetAnimation
	call interactionIncState
	ld l,Interaction.var39
	ld (hl),$00
	ld hl,mainScripts.patch_duringMinigameScript
	call interactionSetScript

; The minigame is running; wait for all enemies to be killed?
@state2:
	ld a,(wTmpcfc0.patchMinigame.failedGame)
	or a
	jr z,@gameRunning

	; Failed minigame

.ifdef ENABLE_US_BUGFIXES
	; This code fixes minor bugs with Patch. In the japanese version, it's possible to open the
	; menu and then move around after the minecart hits the tuni nut. Also, dying as the tuni
	; nut gets hit by the minecart causes graphical glitches.
	call checkLinkCollisionsEnabled
	ret nc
	ld a,DISABLE_LINK
	ld (wDisabledObjects),a

	ld e,Interaction.state
.endif

	ld a,$05
	ld (de),a
	dec a
	jp fadeoutToWhiteWithDelay

@gameRunning:
	; Subid 3 sets var39 to nonzero when all beetles are killed; wait for the signal.
	ld e,Interaction.var39
	ld a,(de)
	or a
	jr z,@runScriptAndAnimate

	; Link won the game.
	xor a
	ld (wTmpcfc0.patchMinigame.gameStarted),a
	ld (w1Link.knockbackCounter),a
	call checkLinkVulnerable
	ret nc

	ld a,DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	; Spawn the repaired item
	ld a,(wTmpcfc0.patchMinigame.fixingSword)
	add $06
	ld c,a
	ld b,INTERACID_PATCH
	call objectCreateInteraction
	ret nz
	ld l,Interaction.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d

	call interactionIncState
	ld hl,mainScripts.patch_linkWonMinigameScript
	call interactionSetScript
	ld a,SND_SOLVEPUZZLE_2
	call playSound
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	jp playSound

@runScriptAndAnimate:
	call interactionRunScript
	jp interactionAnimateAsNpc

; Just won the game
@state3:
	ld a,(wPaletteThread_mode)
	or a
	jr nz,+
	ld a,(wTextIsActive)
	or a
	jr z,++
+
	jp interactionAnimate
++
	call interactionRunScript
	jr nc,@faceLinkAndAnimate

	ld a,(wTmpcfc0.patchMinigame.fixingSword)
	or a
	ld a,GLOBALFLAG_PATCH_REPAIRED_EVERYTHING
	call nz,setGlobalFlag

@alreadyWonMinigame:
	ld e,Interaction.state
	ld a,$04
	ld (de),a
	ld hl,mainScripts.patch_downstairsAfterBeatingMinigameScript
	jp interactionSetScript

; NPC after winning the game
@state4:
	call interactionRunScript
@faceLinkAndAnimate:
	jp npcFaceLinkAndAnimate

; Failed the game
@state5:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	; Delete all the enemies
	ldhl FIRST_ENEMY_INDEX, Enemy.id
@nextEnemy:
	ld a,(hl)
	cp ENEMYID_HARMLESS_HARDHAT_BEETLE
	jr nz,++
	push hl
	ld d,h
	ld e,Enemy.start
	call objectDelete_de
	pop hl
++
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	ldh a,(<hActiveObject)
	ld d,a

	; Give back the broken item
	ld a,(wTmpcfc0.patchMinigame.fixingSword)
	or a
	ld hl,wTuniNutState
	jr z,+
	ld hl,wTradeItem
	ld a,TRADEITEM_BROKEN_SWORD
+
	ld (hl),a

	call interactionIncState
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	ld hl,mainScripts.patch_linkFailedMinigameScript
	jp interactionSetScript

@state6:
	call interactionRunScript
	jr nc,@faceLinkAndAnimate
	ld e,Interaction.state
	xor a
	ld (de),a
	jr @faceLinkAndAnimate


; The minecart in Patch's minigame
patch_subid02:
	ld a,(wActiveTriggers)
	ld (wSwitchState),a
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	; Spawn the object that will toggle the minecart track when the button is down
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_SWITCH_TILE_TOGGLER
	inc l
	ld (hl),$01
	ld l,Interaction.yh
	ld (hl),$05
	ld l,Interaction.xh
	ld (hl),$0b

	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.angle
	ld (hl),ANGLE_RIGHT
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld a,$06
	call objectSetCollideRadius
	jp objectSetVisible82

; Wait for game to start
@state1:
	ld a,(wTmpcfc0.patchMinigame.gameStarted)
	or a
	ret z

	; Spawn the broken item sprite (INTERACID_PATCH subid 4 or 5)
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PATCH
	inc l
	ld a,(wTmpcfc0.patchMinigame.fixingSword)
	add $04
	ld (hl),a
	ld l,Interaction.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d
	jp interactionIncState

; Game is running
@state2:
	ld hl,wTmpcfc0.patchMinigame.gameStarted
	ldi a,(hl)
	or a
	jr z,@incState

	; Check if the game is failed; if so, wait for the screen to fade out.
	ldi a,(hl) ; a = [wTmpcfc0.patchMinigame.failedGame]
	or a
	jr z,@gameStillGoing
	ld a,(hl)  ; a = [wTmpcfc0.patchMinigame.screenFadedOut]
	or a
	ret z

	; Reset position
	ld h,d
	ld l,Interaction.yh
	ld (hl),$08
	ld l,Interaction.xh
	ld (hl),$68
@incState:
	jp interactionIncState

@gameStillGoing:
	call objectApplySpeed
	call interactionAnimate

	; Check if it's reached the center of a new tile
	ld h,d
	ld l,Interaction.yh
	ldi a,(hl)
	and $0f
	cp $08
	ret nz
	inc l
	ld a,(hl)
	and $0f
	cp $08
	ret nz

	; Determine the new angle to move in
	call objectGetTileAtPosition
	ld e,a
	ld a,l
	cp $15
	ld a,$08
	jr z,+
	ld hl,@trackTable
	call lookupKey
	ret nc
+
	ld e,Interaction.angle
	ld (de),a
	bit 3,a
	ld a,$07
	jr z,+
	inc a
+
	jp interactionSetAnimation

@trackTable:
	.db TILEINDEX_TRACK_TR, ANGLE_DOWN
	.db TILEINDEX_TRACK_BR, ANGLE_LEFT
	.db TILEINDEX_TRACK_BL, ANGLE_UP
	.db TILEINDEX_TRACK_TL, ANGLE_RIGHT
	.db $00

; Stop moving until the game starts up again
@state3:
	ld a,(wTmpcfc0.patchMinigame.gameStarted)
	or a
	ret nz
	inc a
	ld (de),a
	ret


; Subid 3 = Beetle "manager"; spawns them and check when they're killed.
;
; Variables:
;   counter1: Number of beetles to be killed (starts at 4 or 8)
;   var3a: Set to 1 when another beetle should be spawned
;   var3b: Number of extra beetles spawned so far
patch_subid03:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	callab commonInteractions1.clearFallDownHoleEventBuffer
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),60
	ret

@state1:
	call interactionDecCounter1
	ret nz

	; Determine total number of beetles (4 or 8) and write that to counter1
	ld a,(wTmpcfc0.patchMinigame.fixingSword)
	add a
	add a
	add $04
	ld (hl),a
	call interactionIncState

	ld c,$44
	call @spawnBeetle
	ld c,$4a
	call @spawnBeetle
	ld c,$75
	call @spawnBeetle
	ld c,$78
@spawnBeetle:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,Interaction.yh
	call setShortPosition_paramC
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMYID_HARMLESS_HARDHAT_BEETLE
	ld l,Enemy.yh
	call setShortPosition_paramC
	xor a
	ret

@state2:
	ld a,(wTmpcfc0.patchMinigame.failedGame)
	or a
	jr nz,@delete

	; Check which objects have fallen into holes
	ld hl,wTmpcfc0.fallDownHoleEvent.cfd8+1
	ld b,$04
---
	ldi a,(hl)
	cp ENEMYID_HARMLESS_HARDHAT_BEETLE
	jr nz,@nextFallenObject

	push hl
	call interactionDecCounter1
	jr z,@allBeetlesKilled
	ld a,(hl)
	cp $04
	jr c,++
	ld l,Interaction.var3a
	inc (hl)
++
	pop hl

@nextFallenObject:
	inc l
	dec b
	jr nz,---

	ld e,Interaction.var3a
	ld a,(de)
	or a
	jr z,++

	; Killed one of the first 4 beetles; spawn another.
	ld e,Interaction.var3b
	ld a,(de)
	ld hl,@extraBeetlePositions
	rst_addAToHl
	ld c,(hl)
	call @spawnBeetle
	jr nz,++
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	inc l
	inc (hl)
++
	jpab commonInteractions1.clearFallDownHoleEventBuffer

@allBeetlesKilled:
	; Set parent object's "var39" to indicate that the game's over
	pop hl
	ld a,Object.var39
	call objectGetRelatedObject1Var
	inc (hl)
@delete:
	jp interactionDelete

@extraBeetlePositions:
	.db $4a $57 $75 $78



; Broken tuni nut (4) or sword (5) sprite
patch_subid04:
patch_subid05:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.yh
	ld (hl),$18
	ld l,Interaction.xh
	ld (hl),$78
	ld bc,$0606
	call objectSetCollideRadii
	jp objectSetVisible83

@state1:
	; When a "palette fade" occurs, assume the game's ended (go to state 2)
	ld a,(wPaletteThread_mode)
	or a
	jp nz,interactionIncState

	; Check if relatedObj1 (the minecart) has collided with it
	ld a,Object.start
	call objectGetRelatedObject1Var
	call checkObjectsCollided
	ret nc

	; Collision occured; game failed.
	ld a,$01
	ld (wTmpcfc0.patchMinigame.failedGame),a
	ld b,INTERACID_EXPLOSION
	call objectCreateInteractionWithSubid00
	ret nz
	ld l,Interaction.var03
	inc (hl)
	ld l,Interaction.xh
	ld a,(hl)
	sub $08
	ld (hl),a
	jp interactionIncState

@state2:
	ld a,(wTmpcfc0.patchMinigame.screenFadedOut)
	or a
	ret z
	jp interactionDelete



; Fixed tuni nut (6) or sword (7) sprite
patch_subid06:
patch_subid07:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionDecCounter1
	ret nz
	jp interactionDelete

@state0:
	ld a,(wTmpcfc0.patchMinigame.wonMinigame)
	or a
	ret z

	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),60

	; If this is the L3 sword, need to change the palette & animation
	ld l,Interaction.subid
	ld a,(hl)
	cp $06
	jr z,@getPosition
	ld a,(wTmpcfc0.patchMinigame.swordLevel)
	or a
	jr nz,@getPosition

	ld l,Interaction.oamFlagsBackup
	ld a,$04
	ldi (hl),a
	ld (hl),a
	ld a,$0c
	call interactionSetAnimation

@getPosition:
	; Copy position from relatedObj1 (patch)
	ld a,Object.start
	call objectGetRelatedObject1Var
	ld bc,$f2f8
	call objectTakePositionWithOffset
	jp objectSetVisible81



; ==============================================================================
; INTERACID_BALL
; ==============================================================================
interactionCode95:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_200
	call interactionInitGraphics
	jp objectSetVisible80

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,($cfd3)
	or a
	ret z
	call interactionIncSubstate
	ld b,ANGLE_RIGHT
	dec a
	jr z,+
	ld b,ANGLE_LEFT
+
	ld l,Interaction.angle
	ld (hl),b
	ld l,Interaction.subid
	ld (hl),a
	cp $02
	jr nz,++
	ld bc,$5075
	call interactionHSetPosition
	ld l,Interaction.zh
	ld (hl),-$06
++
	ld bc,-$1c0
	jp objectSetSpeedZ

@substate1:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	; Ball has landed

	ld e,Interaction.subid
	ld a,(de)
	cp $02
	jr z,@subid2

	dec a
	ld bc,$4a3c
	jr z,+
	ld c,$75
+
	xor a
	ld ($cfd3),a
	ld e,Interaction.substate
	ld (de),a
	jp interactionSetPosition

@subid2:
	; [speedZ] = -[speedZ]/2
	ld l,Interaction.speedZ+1
	ldd a,(hl)
	srl a
	ld b,a
	ld a,(hl)
	rra
	cpl
	add $01
	ldi (hl),a
	ld a,b
	cpl
	adc $00
	ldd (hl),a

	; Go to substate 2 (stop doing anything) if the ball's Z speed has gone too low
	ld bc,$ff80
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call compareHlToBc
	ret c
	jp interactionIncSubstate

@substate2:
	ret



; ==============================================================================
; INTERACID_MOBLIN
; ==============================================================================
interactionCode96:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
@subid1:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @initGraphicsAndLoadScript
@state1:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var3f
	ld a,(de)
	or a
	jr nz,+
	call interactionAnimate
+
	jp interactionPushLinkAwayAndUpdateDrawPriority

@initGraphics: ; unused
	call interactionInitGraphics
	jp interactionIncState

@initGraphicsAndLoadScript:
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.moblin_subid00Script
	.dw mainScripts.moblin_subid01Script


; ==============================================================================
; INTERACID_97
; ==============================================================================
interactionCode97:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw interaction97_subid00
	.dw interaction97_subid01

interaction97_subid00:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionDecCounter1
	jp z,interactionDelete

	inc l
	dec (hl) ; [counter2]--
	ret nz
	call getRandomNumber
	and $03
	ld a,$03
	ld (hl),a

	call getRandomNumber_noPreserveVars
	and $1f
	sub $10
	ld c,a
	call getRandomNumber
	and $07
	sub $04
	ld b,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	jp objectCopyPositionWithOffset

@state0:
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),$6a
	inc l
	inc (hl)
	ret


interaction97_subid01:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionDecCounter1
	ret nz
	ld (hl),$12
	inc l
	dec (hl)
	jp z,interactionDelete

	call getRandomNumber_noPreserveVars
	and $03
	add $0c
	ld b,a

@spawnBubble:
	add a
	add b
	ld hl,@positions
	rst_addAToHl
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ld e,(hl)
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_JABU_JABUS_BUBBLES
	inc l
	ld (hl),e
	ld l,Part.yh
	ld (hl),b
	ld l,Part.xh
	ld (hl),c
	ret

@state0:
	call interactionSetAlwaysUpdateBit
	call interactionIncState

	ld l,Interaction.counter1
	ld (hl),30
	inc l
	ld (hl),$04 ; [counter2]

	ld b,$0c
--
	push bc
	ld a,b
	dec b
	dec a
	call @spawnBubble
	pop bc
	dec b
	jr nz,--
	ret

; Data format:
;   b0: Y
;   b1: X
;   b2: Subid for PARTID_JABU_JABUS_BUBBLES
@positions:
	.db $40 $2f $00
	.db $42 $31 $00
	.db $40 $35 $01
	.db $3e $3a $00
	.db $42 $40 $00
	.db $42 $46 $00
	.db $40 $5d $01
	.db $3e $62 $00
	.db $40 $69 $01
	.db $40 $6c $01
	.db $42 $3f $00
	.db $40 $71 $00
	.db $3e $3c $01
	.db $3a $48 $01
	.db $3c $54 $01
	.db $3e $62 $01

.ends
