m_section_free Ages_Interactions_Bank9 NAMESPACE agesInteractionsBank09

; ==============================================================================
; INTERACID_GHOST_VERAN
; ==============================================================================
interactionCode3e:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible83
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init

@subid0Init:
	ld e,Interaction.counter1
	ld a,Interaction.var38
	ld (de),a
	jp interactionSetAlwaysUpdateBit

@subid1Init:
	ld h,d
	ld l,Interaction.angle
	ld (hl),$10
	ld l,Interaction.speed
	ld (hl),SPEED_c0
	ld hl,mainScripts.ghostVeranSubid1Script
	call interactionSetScript
	call interactionSetAlwaysUpdateBit
	jp objectSetVisible81

@subid2Init:
	ld e,Interaction.speed
	ld a,SPEED_200
	ld (de),a
	ld a,SND_BEAM
	jp playSound


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw runVeranGhostSubid0
	.dw runVeranGhostSubid1
	.dw runVeranGhostSubid2


; Cutscene at start of game (unpossessing Impa)
runVeranGhostSubid0:
	ld e,Interaction.var39
	ld a,(de)
	or a
	call z,interactionAnimate
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
	.dw @substate8

@substate0:
	call interactionDecCounter1
	jr nz,++

	; Appear out of Impa
	ld (hl),$5a
	ld l,Interaction.angle
	ld (hl),$00
	ld l,Interaction.speed
	ld (hl),$0a
	call interactionIncSubstate
	ld a,MUS_ROOM_OF_RITES
	call playSound
	jp objectSetVisible80
++
	ld a,(wFrameCounter)
	rrca
	jp nc,objectSetVisible83
	jp objectSetVisible80

@substate1:
	call interactionDecCounter1
	jp nz,objectApplySpeed
	call interactionIncSubstate
	ld hl,mainScripts.ghostVeranSubid0Script_part1
	jp interactionSetScript

@substate2:
	ld a,($cfd1)
	or a
	jr z,++

	ldbc INTERACID_HUMAN_VERAN, $00
	call objectCreateInteraction
	ret nz

	ld l,Interaction.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d
---
	call interactionIncSubstate
	ld l,Interaction.var38
	ld (hl),$78
	ld l,Interaction.var39
	inc (hl)
	xor a
	call interactionSetAnimation
	ld a,SND_TELEPORT
	jp playSound
++
	call objectGetPosition
	ld hl,$cfd5
	ld (hl),b
	inc l
	ld e,Interaction.var3d
	ld a,c
	ld (de),a
	ld (hl),a
	jp interactionRunScript

@substate3:
@substate5:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ld b,$01
	jp nz,objectFlickerVisibility

	ld l,Interaction.var39
	dec (hl)
	call interactionIncSubstate
	ld a,(hl)
	cp $04
	jp nz,objectSetVisible
	call objectSetInvisible
	ld a,SND_SWORD_OBTAINED
	jp playSound

@substate4:
	ld a,($cfd1)
	cp $02
	ret nz
	jr ---

@substate6:
	ld a,($cfd0)
	cp $12
	jr nz,+
	ld bc,$0302
	call @rumbleAndRandomizeX
	jr ++
+
	call objectGetPosition
	ld hl,$cfd5
	ld (hl),b
	inc l
	ld e,Interaction.var3d
	ld a,c
	ld (de),a
	ld (hl),a
++
	call interactionRunScript
	ret nc
	call objectSetInvisible
	jp interactionIncSubstate

;;
@rumbleAndRandomizeX:
	ld a,(wFrameCounter)
	and $0f
	ld a,SND_RUMBLE2
	call z,playSound
	call getRandomNumber
	and b
	sub c
	ld h,d
	ld l,Interaction.var3d
	add (hl)
	ld l,Interaction.xh
	ld (hl),a
	ret

@substate7:
	ld a,($cfd0)
	cp $17
	ret nz

	call interactionIncSubstate
	ld hl,mainScripts.ghostVeranSubid1Script_part2
	call interactionSetScript
	call objectSetVisible80

@substate8:
	call interactionRunScript
	ret nc
	jp interactionDelete


; Cutscene just before fighting possessed Ambi
runVeranGhostSubid1:
	ld a,(wTextIsActive)
	or a
	jr nz,+
	call interactionRunScript
	jp c,interactionDelete
+
	jp interactionAnimate


; Cutscene just after fighting possessed Ambi
runVeranGhostSubid2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld bc,$5878
	ld e,Interaction.yh
	ld a,(de)
	ldh (<hFF8F),a
	ld e,Interaction.xh
	ld a,(de)
	ldh (<hFF8E),a
	sub c
	inc a
	cp $03
	jr nc,++

	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	jr nc,++

	call interactionIncSubstate
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c
	ld l,Interaction.counter1
	ld (hl),$3c
	jr @animate
++
	call objectGetRelativeAngleWithTempVars
	ld e,Interaction.angle
	ld (de),a
	call objectApplySpeed

@animate:
	jp interactionAnimate

@substate1:
	call interactionDecCounter1
	jr nz,@animate
	ld l,e
	inc (hl)
	ld bc,TX_560e
	jp showText

@substate2:
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMYID_VERAN_FAIRY
	call objectCopyPosition
	ld e,Interaction.relatedObj2
	ld a,Enemy.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$3d
	ret

@substate3:
	call interactionDecCounter1
	jr z,++

	ld a,Object.visible
	call objectGetRelatedObject2Var
	bit 7,(hl)
	jp z,objectSetVisible82
	jp objectSetInvisible
++
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	jp interactionDelete


; ==============================================================================
; INTERACID_BOY_2
; ==============================================================================
interactionCode3f:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3

@subid0:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete

	call @initializeGraphicsAndScript
@@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate


@subid1:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	callab getGameProgress_1
	ld a,b
	cp $03
	jp nz,interactionDelete
	call @initializeGraphicsAndScript
@@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate


@subid2:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete
	call @initGraphicsAndIncState

	ld l,Interaction.var3d
	ld e,Interaction.xh
	ld a,(de)
	ld (hl),a

	jp objectSetVisiblec2

@@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call interactionAnimate
	ld a,($cfd1)
	cp $01
	ret nz
	call interactionIncSubstate
	jpab agesInteractionsBank08.startJump

@@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	call @initializeScript
	dec (hl)
	ret

@@substate2:
	jpab agesInteractionsBank08.boyRunSubid03


@subid3:
	call checkInteractionState
	jr z,@@state0

@@state1:
	jpab agesInteractionsBank08.boyRunSubid09

@@state0:
	call @initGraphicsAndIncState
	ld l,Interaction.counter1
	ld (hl),$78
	ld l,Interaction.oamFlags
	ld (hl),$02
	jp objectSetVisiblec1

@initGraphicsAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@initializeGraphicsAndScript:
	call interactionInitGraphics
	call objectMarkSolidPosition

@initializeScript:
	ld a,>TX_2900
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
	.dw mainScripts.boy2Subid0Script
	.dw mainScripts.boy2Subid1Script
	.dw mainScripts.boy2Subid2Script
	.dw mainScripts.stubScript


; ==============================================================================
; INTERACID_SOLDIER
; ==============================================================================
interactionCode40:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw soldierSubid00
	.dw soldierSubid01
	.dw soldierSubid02
	.dw soldierSubid03
	.dw soldierSubid04
	.dw soldierSubid05
	.dw soldierSubid06
	.dw soldierSubid07
	.dw soldierSubid08
	.dw soldierSubid09
	.dw soldierSubid0a
	.dw soldierSubid0b
	.dw soldierSubid0c
	.dw soldierSubid0d

soldierSubid00:
soldierSubid01:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	ld e,Interaction.var03
	ld a,(de)
	jr nz,label_09_090
	or a
	jp nz,interactionDelete
	jr soldierSubid0c

label_09_090:
	or a
	jp z,interactionDelete


soldierSubid0c:
	call checkInteractionState
	jr nz,label_09_092
	call soldierInitGraphicsAndLoadScript
label_09_092:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate


; Palace guards
soldierSubid02:
soldierSubid09:
	call checkInteractionState
	jr nz,label_09_093
	call soldierCheckBeatD6
	jp nc,interactionDelete
	call soldierInitGraphicsAndLoadScript
	call objectSetVisible82
label_09_093:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	call soldierUpdateAnimationAndRunScript
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld a,GLOBALFLAG_10
	call checkGlobalFlag
	jr z,label_09_094
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	ret z
label_09_094:
	jp objectPreventLinkFromPassing


soldierSubid03:
	call checkInteractionState
	jr nz,label_09_095
	call soldierCheckBeatD6
	jp nc,interactionDelete
	call soldierInitGraphicsAndLoadScript
	jp objectSetVisible82
label_09_095:
	call interactionRunScript
	jp interactionAnimate


; Guard who gives bombs to Link
soldierSubid04:
	call checkInteractionState
	jr nz,@state1

@state0:
	call soldierCheckBeatD6
	jp nc,interactionDelete
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete

	call soldierInitGraphicsAndLoadScript
	ld e,Interaction.oamFlags
	ld a,$03
	ld (de),a
	jp objectSetVisiblec2

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw soldierSubid04Substate0
	.dw soldierSubid04Substate1
	.dw soldierSubid04Substate2
	.dw soldierSubid04Substate3
	.dw soldierSubid04Substate4

soldierSubid04Substate0:
	ld a,($cfd1)
	cp $06
	jr nz,soldierUpdateAnimationAndRunScript

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),30
	xor a
	jp interactionSetAnimation

soldierUpdateAnimationAndRunScript:
	call interactionAnimateBasedOnSpeed
	jp interactionRunScript

soldierSubid04Substate1:
	call interactionAnimate
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld bc,$fe40
	call objectSetSpeedZ
	ld a,SND_JUMP
	jp playSound

soldierSubid04Substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$08
	ld a,$02
	jp interactionSetAnimation

soldierSubid04Substate3:
	call interactionDecCounter1
	ret nz
	ld l,Interaction.angle
	ld (hl),$10
	ld l,Interaction.speed
	ld (hl),SPEED_200
	jp interactionIncSubstate

soldierSubid04Substate4:
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	jp interactionAnimateBasedOnSpeed


; Guard escorting Link in intermediate screens (just moves straight up)
soldierSubid05:
	call checkInteractionState
	jr nz,@state1

@state0:
	call soldierCheckBeatD6
	jp nc,interactionDelete

	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete

	call soldierInitGraphicsAndLoadScript
	xor a
	call interactionSetAnimation
	ld hl,w1Link.xh
	ld (hl),$50
	jp objectSetVisible82

@state1:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	call objectGetTileAtPosition
	cp TILEINDEX_STAIRS
	ld a,SPEED_100
	jr nz,+
	ld a,SPEED_a0
+
	ld e,Interaction.speed
	ld (de),a
	call interactionRunScript
	jp interactionAnimate2Times


; Guard in cutscene who takes mystery seeds from Link
soldierSubid06:
	call checkInteractionState
	jr nz,@state1

	call soldierCheckBeatD6
	jp nc,interactionDelete
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete

	call soldierInitGraphicsAndLoadScript
	xor a
	call interactionSetAnimation
	jp objectSetVisible82

@state1:
	call checkInteractionSubstate
	jr nz,@substate1

@substate0:
	ld a,(w1Link.yh)
	cp $68
	jr nz,@substate1

	xor a
	ld (wUseSimulatedInput),a
	inc a
	ld (wDisabledObjects),a
	call interactionIncSubstate

@substate1:
	jp soldierUpdateAnimationAndRunScript


; Guard just after Link is escorted out of the palace
soldierSubid07:
	call checkInteractionState
	jr nz,@state1

@state0:
	call soldierCheckBeatD6
	jp nc,interactionDelete
	call soldierInitGraphicsAndLoadScript
	jp objectSetVisible82

@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc


; Used in a cutscene? (doesn't do anything)
soldierSubid08:
	call checkInteractionState
	jr nz,@state1

@state0:
	call soldierInitGraphics
	ld l,Interaction.oamFlags
	ld (hl),$03
	jp objectSetVisible82

@state1:
	callab scriptHelp.turnToFaceSomething
	jp interactionAnimate


; Red soldier that brings you to Ambi (escorts you from deku forest)
soldierSubid0a:
	call checkInteractionState
	jr nz,@state1

@state0:
	call soldierInitGraphicsAndLoadScript
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld bc,$68f0
	jp interactionSetPosition

@state1:
	call soldierUpdateAnimationAndRunScript
	ret nc
	ld hl,wcc05
	set 1,(hl)
	ld hl,@warpDest
	jp setWarpDestVariables

@warpDest:
	m_HardcodedWarpA ROOM_AGES_146, $00, $34, $03


; Red soldier that brings you to Ambi (just standing there after taking you)
soldierSubid0b:
	call checkInteractionState
	jp nz,interactionAnimate

@state0:
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,TREASURE_MYSTERY_SEEDS
	call checkTreasureObtained
	jp nc,interactionDelete

	call soldierInitGraphics
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld a,$01
	call interactionSetAnimation
	jp objectSetVisible82


; Friendly soldier after finishing game. var03 is soldier index.
soldierSubid0d:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete

	call soldierInitGraphicsAndLoadScript
	ld e,Interaction.var03
	ld a,(de)
	ld l,Interaction.oamFlags
	ld (hl),$01
	cp $07
	jr c,+
	inc (hl)
+
	ld bc,@behaviours
	call addAToBc
	ld a,(bc)
	ld l,Interaction.var3b
	ld (hl),a
	call interactionRunScript
	jr @state1

@behaviours:
	.db $01 $02 $00 $00 $00 $00 $00 $03
	.db $00 $00 $00 $00 $00 $00 $00 $00

@state1:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var3b
	ld a,(de)
	or a
	jr nz,++
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate
++
	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate

	call interactionAnimateBasedOnSpeed
	jp interactionPushLinkAwayAndUpdateDrawPriority


soldierInitGraphics:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


soldierInitGraphicsAndLoadScript:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld e,Interaction.subid
	ld a,(de)
	ld hl,soldierScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState


linkEnterPalaceSimulatedInput:
	dwb $7fff BTN_UP
	.dw $ffff

linkExitPalaceSimulatedInput
	dwb 30    $00
	dwb 40    BTN_DOWN
	dwb $7fff $00
	.dw $ffff

;;
; @param[out]	cflag	nc if dungeon 6 is beaten (can enter the palace)
soldierCheckBeatD6:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr nc,++
	call getHighestSetBit
	cp $05
	ret
++
	scf
	ret

soldierScriptTable:
	.dw mainScripts.soldierSubid00Script
	.dw mainScripts.soldierSubid01Script
	.dw mainScripts.soldierSubid02Script
	.dw mainScripts.soldierSubid03Script
	.dw mainScripts.soldierSubid04Script
	.dw mainScripts.soldierSubid05Script
	.dw mainScripts.soldierSubid06Script
	.dw mainScripts.soldierSubid07Script
	.dw mainScripts.stubScript
	.dw mainScripts.soldierSubid09Script
	.dw mainScripts.soldierSubid0aScript
	.dw mainScripts.stubScript
	.dw mainScripts.soldierSubid0cScript
	.dw mainScripts.soldierSubid0dScript

; ==============================================================================
; INTERACID_MISC_MAN
; ==============================================================================
interactionCode41:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero

@subid0:
	call checkInteractionState
	jr nz,++
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete
	call @initGraphicsIncStateAndLoadScript
++
	call interactionRunScript
	jp npcFaceLinkAndAnimate

@subidNonzero:
	call checkInteractionState
	jr nz,@@initialized

	ld a,$01
	ld e,Interaction.oamFlags
	ld (de),a

	callab getGameProgress_1
	ld e,Interaction.subid
	ld a,(de)
	dec a
	cp b
	jp nz,interactionDelete

	ld hl,@scriptTable+2
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld a,>TX_2600
	call interactionSetHighTextIndex
	call @initGraphicsAndIncState

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc

@initGraphicsAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

;;
@initGraphicsIncStateAndLoadScript:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,>TX_2600
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
	.dw mainScripts.manOutsideD2Script
	.dw mainScripts.lynnaManScript_befored3
	.dw mainScripts.lynnaManScript_afterd3
	.dw mainScripts.lynnaManScript_afterNayruSaved
	.dw mainScripts.lynnaManScript_afterd7
	.dw mainScripts.lynnaManScript_afterGotMakuSeed
	.dw mainScripts.lynnaManScript_postGame


; ==============================================================================
; INTERACID_MUSTACHE_MAN
; ==============================================================================
interactionCode42:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
	call checkInteractionState
	jr nz,@@initialized

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	call @initGraphicsAndScript
@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc

@subid1:
	call checkInteractionState
	jr nz,@@initialized

	ld e,Interaction.var32
	ld a,$02
	ld (de),a
	call @initGraphicsAndScript

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc

; Unused
@func_52e8:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

@initGraphicsAndScript:
	call interactionInitGraphics
	call objectMarkSolidPosition

	ld a,>TX_0f00
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
	.dw mainScripts.mustacheManScript
	.dw mainScripts.genericNpcScript


; ==============================================================================
; INTERACID_PAST_GUY
; ==============================================================================
interactionCode43:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7

; Guy who wants to find something Ambi desires
@subid0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	ld e,Interaction.var03
	ld a,(de)
	jr nz,+
	or a
	jp nz,interactionDelete
	jr ++
+
	or a
	jp z,interactionDelete
++
	call checkInteractionState
	jr nz,+
	call @initGraphicsIncStateAndLoadScript
+
	call interactionRunScript
	jp interactionAnimateAsNpc

@subid1:
@subid2:
	call checkInteractionState
	jr nz,@label_09_117

	callab getGameProgress_2
	ld c,$01
	ld a,$05
	call checkNpcShouldExistAtGameStage
	jp nz,interactionDelete

	ld a,b
	ld hl,@subid1And2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld a,>TX_1700
	call interactionSetHighTextIndex
	call @initGraphicsAndIncState
	ld a,$03
	ld e,Interaction.oamFlags
	ld (de),a

@label_09_117:
	call interactionRunScript
	jp interactionAnimateAsNpc


; Guy in a cutscene (turning to stone?)
@subid3:
	call checkInteractionState
	jr nz,+
	call @initGraphicsIncStateAndLoadScript
	jp objectSetVisiblec2
+
	call interactionRunScript
	ld a,($cfd1)
	cp $02
	jp c,interactionAnimate
	ret


; Guy in a cutscene (stuck as stone?)
@subid4:
	call checkInteractionState
	ret nz

	call @initGraphicsAndIncState
	ld l,Interaction.oamFlags
	ld (hl),$06
	jp objectSetVisible82


; Guy in a cutscene (being restored from stone?)
@subid5:
	call checkInteractionState
	jr nz,@@initialized

	call @initGraphicsIncStateAndLoadScript
	ld l,Interaction.oamFlags
	ld (hl),$06
	jp objectSetVisiblec2

@@initialized:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,($cfd1)
	cp $01
	ret nz
	jpab agesInteractionsBank08.setCounter1To120AndPlaySoundEffectAndIncSubstate

@@substate1:
	call interactionDecCounter1
	jr z,+
	jpab agesInteractionsBank08.childFlickerBetweenStone
+
	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$02

	ld l,Interaction.counter1
	ld (hl),$a4
	inc l
	ld (hl),$01
	ret

@@substate2:
	call interactionAnimate
	ld l,Interaction.counter1
	call decHlRef16WithCap
	ret nz
	ld a,$ff
	ld ($cfdf),a
	ret


; Guy watching family play catch (or is stone)
@subid6:
	call checkInteractionState
	jr nz,@initialized
	ld hl,wGroup4Flags+$fc
	bit 7,(hl)
	jr nz,@@initAndLoadScript

	ld a,(wEssencesObtained)
	bit 6,a
	jr z,@@initAndLoadScript

	; He's stone, set the palette accordingly.
	call @initGraphicsAndIncState
	ld l,Interaction.oamFlags
	ld (hl),$06
	ld l,Interaction.var03
	inc (hl)

	ld a,$06
	call objectSetCollideRadius
	jr @initialized

@@initAndLoadScript:
	call @initGraphicsIncStateAndLoadScript

@initialized:
	ld e,Interaction.var03
	ld a,(de)
	or a
	jp nz,interactionPushLinkAwayAndUpdateDrawPriority
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc

@subid7:
	call checkInteractionState
	jp z,+
	ret
+
	call @initGraphicsAndIncState
	ld l,Interaction.oamFlags
	ld (hl),$06
	jp objectSetVisiblec2

@initGraphicsAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@initGraphicsIncStateAndLoadScript:
	call interactionInitGraphics
	call objectMarkSolidPosition

	ld a,>TX_1700
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
	.dw mainScripts.pastGuySubid0Script
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.pastGuySubid3Script
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.pastGuySubid6Script

@subid1And2ScriptTable:
	.dw mainScripts.pastGuySubid1And2Script_befored4
	.dw mainScripts.pastGuySubid1And2Script_befored4
	.dw mainScripts.pastGuySubid1And2Script_afterd4
	.dw mainScripts.pastGuySubid1And2Script_afterNayruSaved
	.dw mainScripts.pastGuySubid1And2Script_afterd7
	.dw mainScripts.pastGuySubid1And2Script_afterGotMakuSeed
	.dw mainScripts.pastGuySubid1And2Script_afterGotMakuSeed
	.dw mainScripts.pastGuySubid1And2Script_afterGotMakuSeed


; ==============================================================================
; INTERACID_MISC_MAN_2
; ==============================================================================
interactionCode44:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

; NPC giving hint about what ambi wants
@subid0:
	call checkInteractionState
	jr nz,@@initialized

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	call @initGraphicsIncStateAndLoadScript

@@initialized:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc


; NPC in start-of-game cutscene who turns into an old man
@subid1:
	call checkInteractionState
	jr nz,+
	call @initGraphicsIncStateAndLoadScript
+
	call interactionRunScript
	jp interactionAnimateBasedOnSpeed


; Bearded NPC in Lynna City
@subid2:
@subid3:
	call checkInteractionState
	jr nz,@@initialized

	call getGameProgress_1
	ld c,$02
	ld a,$06
	call checkNpcShouldExistAtGameStage_body
	jp nz,interactionDelete

	ld a,b
	ld hl,lynnaMan2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call @initGraphicsAndIncState

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc


; Bearded hobo in the past, outside shooting gallery
@subid4:
	call checkInteractionState
	jr nz,@@initialized
	call getGameProgress_2
	ld a,b
	cp $03
	jp z,interactionDelete

	cp $06
	jr nz,++

	ld bc,$5878
	call interactionSetPosition
	ld a,$06
++
	ld hl,pastHoboScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call @initGraphicsAndIncState

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc


@initGraphicsAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@initGraphicsIncStateAndLoadScript:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld e,Interaction.subid
	ld a,(de)
	ld hl,miscMan2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

;;
; @param[out]	b	$00 before beating d3;
;			$01 if beat d3
;			$02 if saved Nayru;
;			$03 if beat d7;
;			$04 if got the maku seed (saw twinrova cutscene);
;			$05 if game finished (unlinked only)
getGameProgress_1:
	ld b,$05
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ret nz

	dec b
	ld a,GLOBALFLAG_SAW_TWINROVA_BEFORE_ENDGAME
	call checkGlobalFlag
	ret nz

	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr nc,@noEssences

	call getHighestSetBit
	ld c,a
	ld b,$03
	cp $06
	ret nc

	dec b
	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	ret nz

	dec b
	ld a,c
	cp $02
	ret nc

@noEssences:
	ld b,$00
	ret

;;
; @param[out]	b	$00 before beating d2;
;			$01 if beat d2;
;			$02 if beat d4;
;			$03 if saved nayru;
;			$04 if beat d7;
;			$05 if got the maku seed (saw twinrova cutscene);
;			$06 if beat veran but not twinrova (linked only);
;			$07 if game finished (unlinked only)
getGameProgress_2:
	ld b,$07
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ret nz

	dec b
	call checkIsLinkedGame
	jr z,+
	ld hl,wGroup4Flags+$fc
	bit 7,(hl)
	ret nz
+
	dec b
	ld a,GLOBALFLAG_SAW_TWINROVA_BEFORE_ENDGAME
	call checkGlobalFlag
	ret nz

	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr nc,@noEssences

	call getHighestSetBit
	ld c,a
	ld b,$04
	cp $06
	ret nc

	dec b
	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	ret nz

	dec b
	ld a,c
	cp $03
	ret nc
	dec b
	ld a,c
	cp $01
	ret nc

@noEssences:
	ld b,$00
	ret


;;
unusedFunc5598:
	ld a,b
	ld hl,lynnaMan2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

;;
; Contains some preset data for checking whether certain interactions should exist at
; certain points in the game?
;
; @param	a	(0-8)
; @param	b	Return value from "getGameProgress_1"?
; @param	c	Subid "base"
; @param[out]	zflag	Set if the npc should exist
checkNpcShouldExistAtGameStage_body:
	ld hl,@table
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld e,Interaction.subid
	ld a,(de)
	sub c
	rst_addDoubleIndex

	ldi a,(hl)
	ld h,(hl)
	ld l,a
--
	ldi a,(hl)
	cp b
	ret z
	inc a
	jr z,+
	jr --
+
	or $01
	ret

@table:
	.dw @data0
	.dw @data1
	.dw @data2
	.dw @data3
	.dw @data4
	.dw @data5
	.dw @data6

@data0: ; INTERACID_FEMALE_VILLAGER subids 1-2
	.dw @@subid1
	.dw @@subid2
@@subid1:
	.db $00 $01 $02 $ff
@@subid2:
	.db $03 $04 $05 $ff


@data1: ; INTERACID_FEMALE_VILLAGER subids 3-4
	.dw @@subid3
	.dw @@subid4
@@subid3:
	.db $00 $02 $03 $04 $05 $06 $07 $ff
@@subid4:
	.db $01 $ff


@data2: ; INTERACID_FEMALE_VILLAGER subid 5
	.dw @@subid5
@@subid5:
	.db $00 $01 $02 $03 $05 $06 $ff


@data3: ; INTERACID_VILLAGER subids 4-5
	.dw @@subid4
	.dw @@subid5
@@subid4:
	.db $00 $01 $05 $ff
@@subid5:
	.db $04 $ff


@data4: ; INTERACID_VILLAGER subids 6-7
	.dw @@subid6
	.dw @@subid7

@@subid6:
	.db $00 $01 $02 $ff
@@subid7:
	.db $03 $04 $05 $06 $07 $ff


@data5: ; INTERACID_PAST_GUY subids 1-2
	.dw @@subid1
	.dw @@subid2

@@subid1:
	.db $01 $02 $ff
@@subid2:
	.db $03 $04 $07 $ff


@data6: ; INTERACID_MISC_MAN_2 subids 2-3
	.dw @@subid2
	.dw @@subid3
@@subid2:
	.db $00 $01 $02 $ff
@@subid3:
	.db $03 $04 $05 $ff



miscMan2ScriptTable:
	.dw mainScripts.pastHobo2Script
	.dw mainScripts.npcTurnedToOldManCutsceneScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript

lynnaMan2ScriptTable:
	.dw mainScripts.lynnaMan2Script_befored3
	.dw mainScripts.lynnaMan2Script_afterd3
	.dw mainScripts.lynnaMan2Script_afterNayruSaved
	.dw mainScripts.lynnaMan2Script_afterd7
	.dw mainScripts.lynnaMan2Script_afterGotMakuSeed
	.dw mainScripts.lynnaMan2Script_postGame

pastHoboScriptTable:
	.dw mainScripts.pastHoboScript_befored2
	.dw mainScripts.pastHoboScript_afterd2
	.dw mainScripts.pastHoboScript_afterd4
	.dw mainScripts.pastHoboScript_afterSavedNayru
	.dw mainScripts.pastHoboScript_afterSavedNayru
	.dw mainScripts.pastHoboScript_afterGotMakuSeed
	.dw mainScripts.pastHoboScript_twinrovaKidnappedZelda
	.dw mainScripts.pastHoboScript_postGame


; ==============================================================================
; INTERACID_PAST_OLD_LADY
; ==============================================================================
interactionCode45:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1


; Lady whose husband was sent to work on black tower
@subid0:
	call checkInteractionState
	jr nz,@@initialized

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	call @initGraphicsTextAndScript

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc


@subid1:
	call checkInteractionState
	jr nz,@@initialized

	callab getGameProgress_2
	ld a,b
	cp $04
	jp nc,interactionDelete

	ld hl,@subid1ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld a,>TX_1800
	call interactionSetHighTextIndex
	call @initGraphicsAndIncState

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc


@initGraphicsAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@initGraphicsTextAndScript:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,>TX_1800
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
	.dw mainScripts.pastOldLadySubid0Script
	.dw mainScripts.stubScript

@subid1ScriptTable:
	.dw mainScripts.pastOldLadySubid1Script_befored2
	.dw mainScripts.pastOldLadySubid1Script_afterd2
	.dw mainScripts.pastOldLadySubid1Script_afterd4
	.dw mainScripts.pastOldLadySubid1Script_afterSavedNayru


; ==============================================================================
; INTERACID_TOKAY
; ==============================================================================
interactionCode48:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw tokayState1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2

	ld a,>TX_0a00
	call interactionSetHighTextIndex

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
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @initSubid06
	.dw @initSubid07
	.dw @initSubid08
	.dw @initSubid09
	.dw @initSubid0a
	.dw @initSubid0b
	.dw @initSubid0c
	.dw @initSubid0d
	.dw @initSubid0e
	.dw @initSubid0f
	.dw @initSubid10
	.dw @initSubid11
	.dw @initSubid12
	.dw @initSubid13
	.dw @initSubid14
	.dw @initSubid15
	.dw @initSubid16
	.dw @initSubid17
	.dw @initSubid18
	.dw @initSubid19
	.dw @initSubid1a
	.dw @initSubid1b
	.dw @initSubid1c
	.dw @initSubid1d
	.dw @initSubid1e
	.dw @initSubid1f


; Subid $00-$04: Tokays who rob Link

@initSubid00:
@initSubid03:
	ld a,$01
	jr @initLinkRobberyTokay

@initSubid01:
@initSubid04:
	ld a,$03
	jr @initLinkRobberyTokay

@initSubid02:
	call getThisRoomFlags
	bit 6,a
	jp nz,@deleteSelf

	xor a
	call interactionSetAnimation
	call tokayLoadScript

	; Set the Link object to run the cutscene where he gets mugged
	ld a,SPECIALOBJECTID_LINK_CUTSCENE
	call setLinkIDOverride
	ld l,<w1Link.subid
	ld (hl),$07

	ld e,Interaction.var38
	ld a,$46
	ld (de),a

	ld a,SNDCTRL_STOPMUSIC
	jp playSound

@initLinkRobberyTokay:
	call interactionSetAnimation
	call getThisRoomFlags
	bit 6,a
	jp nz,@deleteSelf
	jp tokayLoadScript


; NPC holding shield upgrade
@initSubid1d:
	call tokayLoadScript
	call getThisRoomFlags
	bit 6,a
	ld a,$02
	jp nz,interactionSetAnimation

	; Set up an "accessory" object (the shield he's holding)
	ld b,$14
	ld a,(wShieldLevel)
	cp $02
	jr c,+
	ld b,$15
+
	ld a,b
	ld e,Interaction.var03
	ld (de),a
	call getFreeInteractionSlot
	ret nz

	inc l
	ld (hl),b ; [subid] = b (graphic for the accessory)
	dec l
	call tokayInitAccessory

	ld a,$06
	jp interactionSetAnimation


; Past NPC holding shovel
@initSubid07:
	call checkIsLinkedGame
	jp nz,interactionDelete

; Past NPC holding something (sword, harp, etc)
@initSubid06:
@initSubid08:
@initSubid09:
@initSubid0a:
	call tokayLoadScript

	; Set var03 to the item being held
	ld h,d
	ld l,Interaction.subid
	ld a,(hl)
	sub $06
	ld bc,tokayIslandStolenItems
	call addAToBc
	ld a,(bc)
	ld l,Interaction.var03
	ld (hl),a

	; Check if the item has been retrieved already
	ld c,$00
	call getThisRoomFlags
	bit 6,a
	jr z,@@endLoop

	; Check if Link is still missing any items.
	inc c
	ld b,$09
@@nextItem:
	ld a,b
	dec a

	ld hl,tokayIslandStolenItems
	rst_addAToHl
	ld a,(hl)
	cp TREASURE_SHIELD
	jr z,+

	call checkTreasureObtained
	jp nc,@@endLoop
+
	dec b
	jr nz,@@nextItem
	inc c

@@endLoop:
	; var3c gets set to:
	; * 0 if Link hasn't retrieved this tokay's item yet;
	; * 1 if Link has retrieved the item, but others are still missing;
	; * 2 if Link has retrieved all of his items from the tokays.
	ld a,c
	ld e,Interaction.var3c
	ld (de),a
	or a
	jr nz,@@retrievedItem

; Link has not retrieved this tokay's item yet.

	ld a,$06
	call interactionSetAnimation

	ld e,Interaction.subid
	ld a,(de)
	ld b,<TX_0a0a

	; Shovel NPC says something a bit different
	cp $07
	jr z,+
	ld b,<TX_0a0b
+
	ld h,d
	ld l,Interaction.textID
	ld (hl),b
	sub $06
	ld b,a
	jp tokayInitHeldItem

@@retrievedItem:
	ld a,$02
	jp interactionSetAnimation


; Past NPC looking after scent seedling
@initSubid11:
	call getThisRoomFlags
	bit 7,a
	jr z,@initSubid0e

	; Seedling has been planted
	ld e,Interaction.xh
	ld a,(de)
	add $10
	ld (de),a
	call objectMarkSolidPosition
	jr @initSubid0e


; Present NPC who talks to you after climbing down vine
@initSubid1e:
	call objectMakeTileSolid
	ld h,>wRoomLayout
	ld (hl),$00
	jr @initSubid0e


; Subid $0f-$10: Tokays who try to eat Dimitri
@initSubid0f:
	ld a,$01
	jr ++

@initSubid10:
	xor a
++
	call interactionSetAnimation

	ld hl,wDimitriState
	bit 1,(hl)
	jr nz,@deleteSelf

	ld l,<wEssencesObtained
	bit 2,(hl)
	jr z,@deleteSelf

	ld e,Interaction.speed
	ld a,SPEED_200
	ld (de),a
	; Fall through


; Shopkeeper (trades items)
@initSubid0e:
	ld a,$06
	call objectSetCollideRadius
	; Fall through


; NPC who trades meat for stink bag
@initSubid05:
	call interactionSetAlwaysUpdateBit
	call tokayLoadScript
	jp tokayState1


@deleteSelf:
	jp interactionDelete


; Linked game cutscene where tokay runs away from Rosa
@initSubid0b:
	call checkIsLinkedGame
	jp z,interactionDelete

	ld a,TREASURE_SHOVEL
	call checkTreasureObtained
	jp c,interactionDelete

	call getThisRoomFlags
	bit 7,a
	jp nz,interactionDelete

	ld a,$01
	ld (wDiggingUpEnemiesForbidden),a
	jp tokayLoadScript


; Participant in Wild Tokay game
@initSubid0c:
	; If this is the last tokay, make it red
	ld h,d
	ld a,(wTmpcfc0.wildTokay.cfdf)
	or a
	jr z,+
	ld l,Interaction.oamFlags
	ld (hl),$02
+
	ld l,Interaction.angle
	ld (hl),$10
	ld l,Interaction.counter2
	inc (hl)

	ld l,Interaction.xh
	ld a,(hl)
	cp $88
	jr z,+

	; Direction variable functions to determine what side he's on?
	; 0 for right side, 1 for left side?
	ld l,Interaction.direction
	inc (hl)
+
	ld a,(wWildTokayGameLevel)
	ld hl,@speedTable
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.speed
	ld (de),a
	ret

@speedTable:
	.db SPEED_80
	.db SPEED_80
	.db SPEED_80
	.db SPEED_a0
	.db SPEED_a0


; Past NPC in charge of wild tokay game
@initSubid0d:
	call getThisRoomFlags
	bit 6,a
	jr z,@@gameNotActive

	ld a,$81
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld hl,w1Link.yh
	ld (hl),$48
	ld l,<w1Link.xh
	ld (hl),$50
	xor a
	ld l,<w1Link.direction
	ld (hl),a

@@gameNotActive:
	ld h,d
	ld l,Interaction.oamFlags
	ld (hl),$03
	jp tokayLoadScript


; Generic NPCs
@initSubid12:
@initSubid13:
@initSubid14:
@initSubid15:
@initSubid16:
@initSubid17:
@initSubid18:
	ld e,Interaction.subid
	ld a,(de)
	sub $12
	ld hl,@textIndices
	rst_addAToHl
	ld e,Interaction.textID
	ld a,(hl)
	ld (de),a
	jp tokayLoadScript

@textIndices:
	.db <TX_0a64 ; Subid $12
	.db <TX_0a65 ; Subid $13
	.db <TX_0a66 ; Subid $14
	.db <TX_0a60 ; Subid $15
	.db <TX_0a61 ; Subid $16
	.db <TX_0a62 ; Subid $17
	.db <TX_0a63 ; Subid $18


; Present NPC in charge of the wild tokay museum
@initSubid19:
	call @initSubid0d
	jp tokayLoadScript


; Subid $1a-$ac: Tokay "statues" in the wild tokay museum

@initSubid1a:
	ld e,Interaction.oamFlags
	ld a,$02
	ld (de),a
	ld e,Interaction.animCounter
	ld a,$01
	ld (de),a
	jp interactionAnimate

@initSubid1c:
	ld a,$09
	call interactionSetAnimation
	call tokayInitMeatAccessory

@initSubid1b:
	ret


; Past NPC standing on cliff at north shore
@initSubid1f:
	ld e,Interaction.textID
	ld a,<TX_0a6c
	ld (de),a
	jp tokayLoadScript




tokayState1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw tokayRunSubid00
	.dw tokayRunSubid01
	.dw tokayRunSubid02
	.dw tokayRunSubid03
	.dw tokayRunSubid04
	.dw tokayRunSubid05
	.dw tokayRunSubid06
	.dw tokayRunSubid07
	.dw tokayRunSubid08
	.dw tokayRunSubid09
	.dw tokayRunSubid0a
	.dw tokayRunSubid0b
	.dw tokayRunSubid0c
	.dw tokayRunSubid0d
	.dw tokayRunSubid0e
	.dw tokayRunSubid0f
	.dw tokayRunSubid10
	.dw tokayRunSubid11
	.dw tokayRunSubid12
	.dw tokayRunSubid13
	.dw tokayRunSubid14
	.dw tokayRunSubid15
	.dw tokayRunSubid16
	.dw tokayRunSubid17
	.dw tokayRunSubid18
	.dw tokayRunSubid19
	.dw tokayRunSubid1a
	.dw tokayRunSubid1b
	.dw tokayRunSubid1c
	.dw tokayRunSubid1d
	.dw tokayRunSubid1e
	.dw tokayRunSubid1f


; Tokays in cutscene who steal your stuff
tokayRunSubid00:
tokayRunSubid01:
tokayRunSubid02:
tokayRunSubid03:
tokayRunSubid04:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw tokayThiefSubstate0
	.dw tokayThiefSubstate1
	.dw tokayThiefSubstate2
	.dw tokayThiefSubstate3
	.dw tokayThiefSubstate4
	.dw tokayThiefSubstate5
	.dw tokayThiefSubstate6


; Substate 0: In the process of removing items from Link's inventory
tokayThiefSubstate0:
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	call z,tokayThief_countdownToStealNextItem

	ld e,Interaction.var39
	ld a,(de)
	or a
	call z,interactionAnimateBasedOnSpeed
	call interactionRunScript
	ret nc

; Script finished; the tokay will now raise the item over its head.

	ld a,$05
	call interactionSetAnimation
	call interactionIncSubstate
	ld l,Interaction.subid
	ld a,(hl)
	ld b,a

	; Only one of them plays the sound effect
	or a
	jr nz,+
	ld a,SND_GETITEM
	call playSound
	ld h,d
+
	ld l,Interaction.counter1
	ld (hl),$5a

;;
; Sets up the graphics for the item that the tokay is holding (ie. shovel, sword)
;
; @param	b	Held item index (0-4)
tokayInitHeldItem:
	call getFreeInteractionSlot
	ret nz
	inc l
	ld a,b
	ld bc,tokayItemGraphics
	call addAToBc
	ld a,(bc)
	ldd (hl),a

;;
; @param	hl	Pointer to an object which will be set to type
;			INTERACID_ACCESSORY.
tokayInitAccessory:
	ld (hl),INTERACID_ACCESSORY
	ld l,Interaction.relatedObj1
	ld (hl),Interaction.enabled
	inc l
	ld (hl),d
	ret

tokayItemGraphics:
	.db $10 $1b $68 $31 $20


;;
; This function counts down a timer in var38, and removes the next item from Link's
; inventory once it hits zero. The next item index to steal is var3a.
tokayThief_countdownToStealNextItem:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz

	ld (hl),$0a
	ld l,Interaction.var3a
	ld a,(hl)
	cp $09
	ret z

	inc (hl)
	ld hl,tokayIslandStolenItems
	rst_addAToHl
	ld a,(hl)

	cp TREASURE_SEED_SATCHEL
	jr nz,+
	call loseTreasure
	ld a,TREASURE_EMBER_SEEDS
	call loseTreasure
	ld a,TREASURE_MYSTERY_SEEDS
+
	call loseTreasure
	ld a,SND_UNKNOWN5
	jp playSound


tokayThiefSubstate1:
	call interactionDecCounter1
	ret nz

	; Set how long to wait before jumping based on subid
	ld l,Interaction.subid
	ld a,(hl)
	swap a
	add $14
	ld l,Interaction.counter1
	ld (hl),a

	jp interactionIncSubstate


tokayThiefSubstate2:
	call interactionAnimate3Times
	call interactionDecCounter1
	ret nz

	; Jump away
	ld l,Interaction.angle
	ld (hl),$06
	ld l,Interaction.speed
	ld (hl),SPEED_280

tokayThief_jump:
	call interactionIncSubstate

	ld bc,-$1c0
	call objectSetSpeedZ

	ld a,$05
	call specialObjectSetAnimation
	ld e,Interaction.animCounter
	ld a,$01
	ld (de),a
	call specialObjectAnimate

	ld a,SND_JUMP
	jp playSound


tokayThiefSubstate3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$06
	ld a,$05
	jp interactionSetAnimation


tokayThiefSubstate4:
	call interactionDecCounter1
	ret nz
	jr tokayThief_jump


; Wait for tokay to exit screen
tokayThiefSubstate5:
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jr c,@updateSpeedZ

	ld e,Interaction.subid
	ld a,(de)
	cp $03
	jr nz,@delete

	; Only the tokay with subid $03 goes to state 6
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$3c
	ret

@delete:
	jp interactionDelete

@updateSpeedZ:
	ld c,$20
	jp objectUpdateSpeedZ_paramC


; Wait for a bit before restoring control to Link
tokayThiefSubstate6:
	call interactionDecCounter1
	ret nz

	xor a
	ld (wDisabledObjects),a
	ld (wUseSimulatedInput),a
	ld (wMenuDisabled),a
	call getThisRoomFlags
	set 6,(hl)

	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound

	call setDeathRespawnPoint
	jp interactionDelete



; NPC who trades meat for stink bag
tokayRunSubid05:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate

	call tokayRunStinkBagCutscene
	call interactionAnimate
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; NPC holding something (ie. shovel, harp, shield upgrade).
tokayRunSubid06:
tokayRunSubid07:
tokayRunSubid08:
tokayRunSubid09:
tokayRunSubid0a:
tokayRunSubid1d:
	call interactionRunScript
	ld e,Interaction.var3b
	ld a,(de)
	or a
	jp z,interactionAnimateAsNpc
	jp npcFaceLinkAndAnimate


; Linked game cutscene where tokay runs away from Rosa
tokayRunSubid0b:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateBasedOnSpeed


; Participant in Wild Tokay game
tokayRunSubid0c:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw wildTokayParticipantSubstate0
	.dw wildTokayParticipantSubstate1
	.dw wildTokayParticipantSubstate2


wildTokayParticipantSubstate0:
	call wildTokayParticipant_checkGrabMeat

wildTokayParticipantSubstate2:
	call objectApplySpeed
	ld e,Interaction.yh
	ld a,(de)
	add $08
	cp $90
	jp c,interactionAnimateBasedOnSpeed

; Tokay has just left the screen

	; Is he holding meat?
	ld e,Interaction.var3c
	ld a,(de)
	or a
	jr nz,+

	; If so, set failure flag?
	ld a,$ff
	ld ($cfde),a
	jr @delete
+
	; Delete "meat" accessory
	ld e,Interaction.relatedObj2+1
	ld a,(de)
	push de
	ld d,a
	call objectDelete_de

	; If this is the last tokay (colored red), mark "success" condition in $cfde
	pop de
	ld e,Interaction.oamFlags
	ld a,(de)
	cp $02
	jr nz,@delete

	ld a,$01
	ld ($cfde),a
@delete:
	jp interactionDelete

;;
wildTokayParticipant_checkGrabMeat:
	; Check that Link's throwing an item
	ld a,(w1ReservedItemC.enabled)
	or a
	ret z
	ld a,(wLinkGrabState)
	or a
	ret nz

	; Check if the meat has collided with self
	ld a,$0a
	ld hl,w1ReservedItemC.yh
	ld b,(hl)
	ld l,Item.xh
	ld c,(hl)
	ld h,d
	ld l,Interaction.yh
	call checkObjectIsCloseToPosition
	ret nc

	call interactionIncSubstate
	ld l,Interaction.var3c
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),$06

	ld a,$07
	ld l,Interaction.direction
	add (hl)
	call interactionSetAnimation
	push de

	; Delete thrown meat
	ld de,w1ReservedItemC.enabled
	call objectDelete_de

	; Delete something?
	ld hl,$cfda
	ldi a,(hl)
	ld e,(hl)
	ld d,a
	call objectDelete_de

	pop de
	ld a,SND_OPENCHEST
	call playSound
	; Fall through

;;
; Creates a graphic of "held meat" for a tokay.
tokayInitMeatAccessory:
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERACID_ACCESSORY
	inc l
	ld (hl),$73
	inc l
	inc (hl)

	ld l,Interaction.relatedObj1
	ld (hl),Interaction.enabled
	inc l
	ld (hl),d

	ld e,Interaction.relatedObj2+1
	ld a,h
	ld (de),a
	ret


wildTokayParticipantSubstate1:
	call interactionDecCounter1
	ret nz
	jp interactionIncSubstate



; Past and present NPCs in charge of wild tokay game
tokayRunSubid0d:
tokayRunSubid19:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

; Not running game
@substate0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call interactionRunScript
	jp nc,interactionAnimateAsNpc

; Script ended; that means the game should begin.

	; Create meat spawner?
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_WILD_TOKAY_CONTROLLER
	call interactionIncSubstate
	ld a,SNDCTRL_MEDIUM_FADEOUT
	call playSound
	jp fadeoutToWhite

; Beginning game (will delete self when the game is initialized)
@substate1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	push de
	call clearAllItemsAndPutLinkOnGround
	pop de
	ld e,Interaction.subid
	ld a,(de)

	; Check if in present or past
	cp $19
	jr nz,++
	ld a,$01
	ld ($cfc0),a
++
	jp interactionDelete


; Subids $0f-$10: Tokays who try to eat Dimitri
tokayRunSubid0f:
	ld a,(wScrollMode)
	and $0e
	ret nz

tokayRunSubid10:
	ld a,(w1Companion.var3e)
	and $04
	jr nz,++
	; Fall through


; Shopkeeper, and past NPC looking after scent seedling
tokayRunSubid0e:
tokayRunSubid11:
	call interactionAnimateAsNpc
++
	call interactionRunScript
	ret nc
	jp interactionDelete


; Present NPC who talks to you after climbing down vine
tokayRunSubid1e:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	call interactionAnimateAsNpc
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionRunScript

	ld c,$18
	call objectCheckLinkWithinDistance
	ret nc

	ld e,Interaction.var31
	ld (de),a
	jp interactionRunScript


; Subids $12-$18 and $1f: Generic NPCs
tokayRunSubid12:
tokayRunSubid13:
tokayRunSubid14:
tokayRunSubid15:
tokayRunSubid16:
tokayRunSubid17:
tokayRunSubid18:
tokayRunSubid1f:
	call interactionRunScript
	jp npcFaceLinkAndAnimate


; Subids $1a-$1c: Tokay "statues" in the wild tokay museum
tokayRunSubid1a:
tokayRunSubid1b:
tokayRunSubid1c:
	ld a,(wTmpcfc0.wildTokay.inPresent)
	or a
	ret z
	jp interactionDelete


;;
; Cutscene where tokay smells stink bag and jumps around like a madman.
;
; On return, var3e will be 0 if he's currently at his starting position, otherwise it will
; be 1.
tokayRunStinkBagCutscene:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_300

@beginNextJump:
	ld h,d
	ld l,Interaction.yh
	ld a,(hl)
	ld l,Interaction.var39
	ld (hl),a

	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var3a
	ld (hl),a

	ld h,d
	ld l,Interaction.substate
	ld (hl),$01
	ld l,Interaction.var3e
	ld (hl),$01

	call @initJumpVariables

	ld a,SND_JUMP
	jp playSound

; Set angle, speedZ, and var3c (gravity) for the next jump.
@initJumpVariables:
	ld h,d
	ld l,Interaction.var3b
	ld a,(hl)
	add a
	ld bc,@jumpPaths
	call addDoubleIndexToBc

	ld a,(bc)
	inc bc
	ld l,Interaction.angle
	ld (hl),a
	ld a,(bc)
	inc bc
	ld l,Interaction.speedZ
	ldi (hl),a
	ld a,(bc)
	inc bc
	ld (hl),a
	ld a,(bc)
	ld l,Interaction.var3c
	ld (hl),a
	ret

; Data format:
;   byte: angle
;   word: speedZ
;   byte: var3c (gravity)
@jumpPaths:
	dbwb $18, -$800, -$08
	dbwb $0a, -$c00, -$08
	dbwb $02, -$800, -$08
	dbwb $14, -$c00, -$08
	dbwb $06, -$e00, -$08
	dbwb $18, -$a00, -$08

@substate1:
	; Apply gravity and update speed
	ld e,Interaction.var3c
	ld a,(de)
	ld c,a
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed

	call interactionIncSubstate
	ld l,Interaction.var3b
	ld a,(hl)
	cp $05
	ret nz

	; He's completed one loop. Restore y/x to precise values to prevent "drifting" off
	; course?
	ld l,Interaction.y
	ld (hl),$00
	inc l
	ld (hl),$28
	ld l,Interaction.x
	ld (hl),$00
	inc l
	ld (hl),$48

	ld l,Interaction.var3e
	ld (hl),$00
	ret

@substate2:
	; Increment "jump index", and loop back to 0 when appropriate.
	ld h,d
	ld l,Interaction.var3b
	inc (hl)
	ld a,(hl)
	cp $06
	jr c,+
	ld (hl),$00
+
	jp @beginNextJump

;;
tokayLoadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,tokayScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

tokayScriptTable:
	/* $00 */ .dw mainScripts.tokayThiefScript
	/* $01 */ .dw mainScripts.tokayThiefScript
	/* $02 */ .dw mainScripts.tokayMainThiefScript
	/* $03 */ .dw mainScripts.tokayThiefScript
	/* $04 */ .dw mainScripts.tokayThiefScript
	/* $05 */ .dw mainScripts.tokayCookScript
	/* $06 */ .dw mainScripts.tokayHoldingItemScript
	/* $07 */ .dw mainScripts.tokayHoldingItemScript
	/* $08 */ .dw mainScripts.tokayHoldingItemScript
	/* $09 */ .dw mainScripts.tokayHoldingItemScript
	/* $0a */ .dw mainScripts.tokayHoldingItemScript
	/* $0b */ .dw mainScripts.tokayRunningFromRosaScript
	/* $0c */ .dw mainScripts.stubScript
	/* $0d */ .dw mainScripts.tokayGameManagerScript_past
	/* $0e */ .dw mainScripts.tokayShopkeeperScript
	/* $0f */ .dw mainScripts.tokayWithDimitri1Script
	/* $10 */ .dw mainScripts.tokayWithDimitri2Script
	/* $11 */ .dw mainScripts.tokayAtSeedlingPlotScript
	/* $12 */ .dw mainScripts.genericNpcScript
	/* $13 */ .dw mainScripts.genericNpcScript
	/* $14 */ .dw mainScripts.genericNpcScript
	/* $15 */ .dw mainScripts.genericNpcScript
	/* $16 */ .dw mainScripts.genericNpcScript
	/* $17 */ .dw mainScripts.genericNpcScript
	/* $18 */ .dw mainScripts.genericNpcScript
	/* $19 */ .dw mainScripts.tokayGameManagerScript_present
	/* $1a */ .dw $0000
	/* $1b */ .dw $0000
	/* $1c */ .dw $0000
	/* $1d */ .dw mainScripts.tokayWithShieldUpgradeScript
	/* $1e */ .dw mainScripts.tokayExplainingVinesScript
	/* $1f */ .dw mainScripts.genericNpcScript



; ==============================================================================
; INTERACID_FOREST_FAIRY
; ==============================================================================
interactionCode49:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw forestFairy_subid00
	.dw forestFairy_subid01
	.dw forestFairy_subid02
	.dw forestFairy_subid03
	.dw forestFairy_subid04
	.dw forestFairy_subid05
	.dw forestFairy_subid06
	.dw forestFairy_subid07
	.dw forestFairy_subid08
	.dw forestFairy_subid09
	.dw forestFairy_subid0a
	.dw forestFairy_subid0b
	.dw forestFairy_subid0c
	.dw forestFairy_subid0d
	.dw forestFairy_subid0e
	.dw forestFairy_subid0f
	.dw forestFairy_subid10

forestFairy_subid00:
	ld a,(de)
	rst_jumpTable
	.dw forestFairy_subid00State0
	.dw forestFairy_subid00State1
	.dw forestFairy_subid00State2
	.dw forestFairy_subid00State3
	.dw forestFairy_deleteSelf


forestFairy_subid00State0:
forestFairy_subid03State0:
forestFairy_subid04State0:
	call interactionInitGraphics
	call forestFairy_initCollisionRadiusAndSetZAndIncState
	ld l,Interaction.speed
	ld (hl),SPEED_200
	ld l,Interaction.var3a
	ld (hl),$5a

forestFairy_loadMovementPreset:
	ld e,Interaction.var03
	ld a,(de)
	add a
	ld hl,@data
	rst_addDoubleIndex

	ld e,Interaction.yh
	ld a,(hl)
	and $f8
	ld (de),a
	ld e,Interaction.angle
	ldi a,(hl)
	and $07
	add a
	add a
	ld (de),a

	ld e,Interaction.xh
	ld a,(hl)
	and $f8
	ld (de),a
	ld e,Interaction.counter1
	ldi a,(hl)
	and $07
	inc a
	ld (de),a
	inc e
	ld (de),a

	ld e,Interaction.var38
	ld a,(hl)
	and $f8
	ld (de),a
	ld e,Interaction.direction
	ldi a,(hl)
	and $01
	ld (de),a

	ld e,Interaction.var39
	ld a,(hl)
	and $f8
	ld (de),a
	ld e,Interaction.oamFlags
	ld a,(hl)
	and $07
	ld (de),a
	dec e
	ld (de),a

	ld e,Interaction.direction
	ld a,(de)
	jp interactionSetAnimation


; Each row is data for a corresponding value of "var03".
; Data format:
;   b0: angle (bits 0-2, multiplied by 4) and y-position (bits 3-7)
;   b1: counter1/2 (bits 0-2, plus one) and x-position (bits 3-7)
;   b2: direction (bit 0) and var38 (bits 3-7)
;   b3: oamFlags (bits 0-2) and var39 (bits 3-7)
@data:
	.db $38 $6b $48 $39
	.db $29 $3b $49 $6a
	.db $5d $53 $39 $53
	.db $2e $5a $48 $51
	.db $5d $4a $49 $52
	.db $39 $2a $49 $53
	.db $4c $3c $00 $49
	.db $48 $6c $39 $8a
	.db $3a $54 $59 $03
	.db $4c $54 $00 $a1
	.db $49 $55 $91 $62
	.db $4a $53 $01 $03
	.db $4c $a4 $28 $59
	.db $60 $ac $59 $4a
	.db $03 $7c $39 $2b
	.db $97 $53 $61 $41
	.db $84 $53 $91 $81
	.db $4e $5b $89 $11
	.db $3a $7b $28 $aa
	.db $5a $7b $88 $a3
	.db $36 $ab $21 $69
	.db $86 $53 $91 $39


forestFairy_subid00State1:
	ld h,d
	ld l,Interaction.var38
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,Interaction.yh
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	sub c
	add $04
	cp $09
	jr nc,@label_09_161

	ldh a,(<hFF8F)
	sub b
	add $04
	cp $09
	jr nc,@label_09_161

	ld e,Interaction.subid
	ld a,(de)
	cp $03
	jr nc,@label_09_160

	ld (hl),c
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.state
	inc (hl)

@label_09_160:
	ld hl,wTmpcfc0.fairyHideAndSeek.cfd2
	inc (hl)
	scf
	ret

@label_09_161:
	ld l,Interaction.var3a
	dec (hl)
	ld a,(hl)
	jr nz,@label_09_163

	ld (hl),$5a
	ld l,Interaction.counter2
	srl (hl)
	jr nc,@label_09_164

	inc (hl)
@label_09_163:
	and $07
	jr nz,@label_09_164

	push bc
	ldbc INTERACID_SPARKLE, $02
	call objectCreateInteraction
	pop bc

@label_09_164:
	call interactionDecCounter1
	jr nz,forestFairy_updateMovement

	inc l
	ldd a,(hl)
	ld (hl),a
	call objectGetRelativeAngleWithTempVars
	call objectNudgeAngleTowards

forestFairy_updateMovement:
	call objectApplySpeed
	ld a,(wFrameCounter)
	and $1f
	ld a,SND_MAGIC_POWDER
	call z,playSound

forestFairy_animate:
	call interactionAnimate
	or d
	ret


forestFairy_subid00State2:
	ld a,(wTmpcfc0.fairyHideAndSeek.cfd2)
	or a
	jr nz,forestFairy_animate

	ld e,Interaction.var03
	ld a,(de)
	cp $06
	jr nc,@createPuffAndDelete

	add $06
	ld (de),a
	call interactionIncState
	jp forestFairy_loadMovementPreset

@createPuffAndDelete:
	call objectCreatePuff
	jr forestFairy_deleteSelf

forestFairy_subid00State3:
	call forestFairy_subid00State1
	jr c,forestFairy_deleteSelf
	ld e,Interaction.yh
	ld a,(de)
	cp $80
	jr nc,++

	ld e,Interaction.xh
	ld a,(de)
	cp $a0
	ret c
++
	ld hl,wTmpcfc0.fairyHideAndSeek.cfd2
	inc (hl)

forestFairy_deleteSelf:
	jp interactionDelete


forestFairy_subid01:
	ld a,(de)
	or a
	jr z,@stateZero

	ld a,($cfd0)
	or a
	jp z,interactionDelete

	ld hl,w1Link
	call preventObjectHFromPassingObjectD
	call interactionAnimate
	jp interactionRunScript

@stateZero:
	ld e,Interaction.var03
	ld a,(de)
	ld hl,$cfd1
	call checkFlag
	jp z,interactionDelete

	ld a,($cfd1)
	call getNumSetBits
	dec a
	ld hl,forestFairyDiscoveredScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	call interactionInitGraphics

	; Set color based on index
	ld e,Interaction.var03
	ld a,(de)
	ld b,a
	inc a
	ld e,Interaction.oamFlags
	ld (de),a
	dec e
	ld (de),a

	ld a,b
	ld hl,forestFairy_discoveredPositions
	rst_addDoubleIndex
	ld e,Interaction.yh
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.xh
	ld a,(hl)
	ld (de),a
	ld a,b
	or a
	jr z,+
	ld a,$01
+
	call interactionSetAnimation

forestFairy_initCollisionRadiusAndSetZAndIncState:
	call interactionIncState
	ld l,Interaction.collisionRadiusY
	ld a,$04
	ldi (hl),a
	ld (hl),a
	ld l,Interaction.zh
	ld (hl),$fc
	jp objectSetVisiblec1


; Scripts used for fairy NPCs after being discovered
forestFairyDiscoveredScriptTable:
	.dw mainScripts.forestFairyScript_firstDiscovered
	.dw mainScripts.forestFairyScript_secondDiscovered
	.dw mainScripts.stubScript

forestFairy_discoveredPositions:
	.db $48 $38
	.db $48 $68
	.db $28 $50


forestFairy_subid02:
	jp interactionDelete

forestFairy_subid03:
	ld a,(de)
	rst_jumpTable
	.dw forestFairy_subid03State0
	.dw forestFairy_subid03State1
	.dw forestFairy_subid03State2
	.dw forestFairy_subid03State3
	.dw forestFairy_subid00State3

forestFairy_subid04:
	ld a,(de)
	rst_jumpTable
	.dw forestFairy_subid04State0
	.dw forestFairy_subid04State1
	.dw forestFairy_subid00State3

forestFairy_subid03State1:
	call forestFairy_subid00State1
	ret nc
	call interactionIncState
	ld a,$02
	ld l,Interaction.counter1
	ldi (hl),a
	ldi (hl),a
	ld l,Interaction.var3b
	ld (hl),$20
	ret

forestFairy_subid03State2:
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	ld a,(hl)
	and $07
	jr nz,++

	push bc
	ldbc INTERACID_SPARKLE, $02
	call objectCreateInteraction
	pop bc
++
	call interactionDecCounter2
	jr nz,@updateMovement

	dec l
	ldi a,(hl)
	ldi (hl),a

	; [direction]++ (wrapping $20 to $00)
	inc l
	ld a,(hl)
	inc a
	and $1f
	ld (hl),a

	ld l,Interaction.var3b
	dec (hl)
	jr nz,@updateMovement

	ld l,e
	inc (hl)
	ld hl,wTmpcfc0.fairyHideAndSeek.cfd2
	inc (hl)
	ret

@updateMovement:
	jp forestFairy_updateMovement

forestFairy_subid03State3:
	ld a,(wTmpcfc0.fairyHideAndSeek.cfd2)
	or a
	jp nz,forestFairy_animate

	call interactionIncState
	ld l,Interaction.var03
	inc (hl)
	ld l,Interaction.yh
	ldi a,(hl)
	inc l
	ld c,(hl)
	ld b,a
	push bc
	call forestFairy_loadMovementPreset
	pop bc
	ld h,d
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c
	ret

forestFairy_subid04State1:
	ld a,(wTmpcfc0.fairyHideAndSeek.cfd2)
	or a
	jp nz,forestFairy_animate
	call interactionIncState
	jp forestFairy_loadMovementPreset


; Generic NPC (between completing the maze and entering jabu)
forestFairy_subid05:
forestFairy_subid06:
forestFairy_subid07:
	call checkInteractionState
	jr nz,forestFairy_standardUpdate

	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,GLOBALFLAG_FOREST_UNSCRAMBLED
	call checkGlobalFlag
	jp z,interactionDelete

	; Check if jabu-jabu is opened?
	ld a,(wPresentRoomFlags+$90)
	bit 6,a
	jp nz,interactionDelete

	ld e,Interaction.subid
	ld a,(de)
	sub $05
	ld hl,forestFairy_subid5To7NpcData
	rst_addDoubleIndex

;;
; @param	hl	Pointer to 2 bytes (see example data below)
forestFairy_initNpcFromData:
	push hl
	call interactionInitGraphics
	pop hl

	ld e,Interaction.textID
	ldi a,(hl)
	ld (de),a

	ld e,Interaction.oamFlagsBackup
	ld a,(hl)
	and $0f
	ld (de),a
	inc e
	ld (de),a

	ld a,(hl)
	and $f0
	swap a
	call interactionSetAnimation

	call objectMarkSolidPosition
	call interactionIncState
	ld l,Interaction.zh
	ld (hl),$fc

	ld l,Interaction.textID+1
	ld (hl),>TX_1100
	ld hl,mainScripts.forestFairyScript_genericNpc
	call interactionSetScript
	jp objectSetVisiblec1


; Index is [subid]-5 (for subids $05-$07).
;  b0: Low byte of textID
;  b1: oamFlags (bits 0-3), animation index (bits 4-7)
forestFairy_subid5To7NpcData:
	.db <TX_110d, $01
	.db <TX_1110, $12
	.db <TX_1113, $13

forestFairy_standardUpdate:
	call interactionRunScript
	call interactionAnimate
	jp objectPreventLinkFromPassing


; Generic NPC (between jabu and finishing the game)
forestFairy_subid08:
forestFairy_subid09:
forestFairy_subid0a:
	call checkInteractionState
	jr nz,forestFairy_standardUpdate

	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,GLOBALFLAG_FOREST_UNSCRAMBLED
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,(wPresentRoomFlags+$90)
	bit 6,a
	jp z,interactionDelete

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld e,Interaction.subid
	ld a,(de)
	sub $08
	ld hl,@npcData
	rst_addDoubleIndex
	jp forestFairy_initNpcFromData

; Index is [subid]-8 (for subids $08-$0a).
;  b0: Low byte of textID
;  b1: oamFlags (bits 0-3), animation index (bits 4-7)
@npcData:
	.db <TX_110e, $01
	.db <TX_1111, $12
	.db <TX_1114, $13


; NPC in unlinked game who takes a secret
forestFairy_subid0b:
	call checkInteractionState
	jr nz,forestFairy_standardUpdate

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete

	call interactionInitGraphics
	call objectMarkSolidPosition
	call interactionIncState
	ld l,Interaction.zh
	ld (hl),$fc

	ld l,Interaction.oamFlags
	ld a,$01
	ldd (hl),a
	ld (hl),a
	ld hl,mainScripts.forestFairyScript_heartContainerSecret
	call interactionSetScript
	jp objectSetVisiblec1


; Generic NPC (after beating game)
forestFairy_subid0c:
forestFairy_subid0d:
	call checkInteractionState
forestFairy_standardUpdate_2:
	jr nz,forestFairy_standardUpdate

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete

	ld e,Interaction.subid
	ld a,(de)
	sub $0c
	ld hl,@npcData
	rst_addDoubleIndex
	jp forestFairy_initNpcFromData

; Index is [subid]-$0c (for subids $0c-$0d).
;  b0: Low byte of textID
;  b1: oamFlags (bits 0-3), animation index (bits 4-7)
@npcData:
	.db <TX_1112, $12
	.db <TX_1115, $13


; Generic NPC (while looking for companion trapped in woods)
forestFairy_subid0e:
forestFairy_subid0f:
forestFairy_subid10:
	call checkInteractionState
	jr nz,forestFairy_standardUpdate_2

	ld a,GLOBALFLAG_GOT_FLUTE
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_FOREST_UNSCRAMBLED
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_COMPANION_LOST_IN_FOREST
	call checkGlobalFlag
	jp z,interactionDelete

	ld e,Interaction.subid
	ld a,(de)
	sub $0e
	ld hl,@npcData
	rst_addDoubleIndex
	jp forestFairy_initNpcFromData

; Index is [subid]-$0e (for subids $0e-$10).
;  b0: Low byte of textID
;  b1: oamFlags (bits 0-3), animation index (bits 4-7)
@npcData:
	.db <TX_1127, $01
	.db <TX_1128, $12
	.db <TX_1129, $13


; ==============================================================================
; INTERACID_RABBIT
; ==============================================================================
interactionCode4b:
	jpab bank3f.interactionCode4b_body


; ==============================================================================
; INTERACID_BIRD
; ==============================================================================
interactionCode4c:
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
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04


; Listening to Nayru at the start of the game
@initSubid00:
	call bird_hop
	ld hl,mainScripts.birdScript_listeningToNayruGameStart
	jp interactionSetScript


; Bird with Impa when Zelda gets kidnapped
@initSubid04:
	ld a,(wEssencesObtained)
	bit 2,a
	jp z,interactionDelete

	call checkIsLinkedGame
	jp z,interactionDelete

	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA
	call checkGlobalFlag
	jp nz,interactionDelete

	ld hl,mainScripts.birdScript_zeldaKidnapped
	call interactionSetScript
	call interactionSetAlwaysUpdateBit

	ld a,GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED
	call checkGlobalFlag
	jr z,@setAnimation0AndJump

	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jr z,@impaNotMoved

	; Have talked to impa; adjust position
	ld e,Interaction.yh
	ld a,$58
	ld (de),a
	jr @setAnimation0AndJump

@impaNotMoved:
	ld e,Interaction.xh
	ld a,$68
	ld (de),a
	jr @setAnimation0AndJump


; Different colored birds that do nothing but hop? Used in a cutscene?
@initSubid01:
@initSubid02:
@initSubid03:
	; [oamFlags] = [subid]
	ld a,(de)
	ld e,Interaction.oamFlags
	ld (de),a

@setAnimation0AndJump:
	xor a
	call interactionSetAnimation
	jp bird_hop


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw bird_runSubid0
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw bird_runSubid4


; Listening to Nayru at the start of the game
bird_runSubid0:
	call interactionAnimateAsNpc
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfd0)
	cp $0e
	jr nz,++

	call interactionIncSubstate
	ld a,$01
	jp interactionSetAnimation
++
	ld e,Interaction.var37
	ld a,(de)
	or a
	call nz,bird_updateGravityAndHopWhenHitGround
	jp interactionRunScript

@substate1:
	ld a,($cfd0)
	cp $10
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$1e
	call bird_hop
	ld a,$02
	jp interactionSetAnimation

@substate2:
	call interactionDecCounter1
	jr nz,bird_updateGravityAndHopWhenHitGround

	; Begin running away
	call interactionIncSubstate
	ld l,Interaction.zh
	ld (hl),$00
	ld l,Interaction.angle
	ld (hl),$01
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld bc,-$100
	call objectSetSpeedZ
	ld a,$03
	jp interactionSetAnimation

@substate3:
	; Delete self when off-screen
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete

	xor a
	call objectUpdateSpeedZ
	jp objectApplySpeed


; Bird with Impa when Zelda gets kidnapped
bird_runSubid4:
	call interactionAnimateAsNpc
	call bird_updateGravityAndHopWhenHitGround
	call interactionRunScript
	jp c,interactionDelete

	; Check whether to move the bird over (to make way to Link)
	ld a,GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED
	call checkGlobalFlag
	ret z

	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	ret nz

	; Increase x position until it reaches $68
	ld e,Interaction.xh
	ld a,(de)
	cp $68
	ret z

	inc a
	ld (de),a
	ret

bird_updateGravityAndHopWhenHitGround:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d

bird_hop:
	ld bc,-$c0
	jp objectSetSpeedZ


; ==============================================================================
; INTERACID_AMBI
; ==============================================================================
interactionCode4d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw ambi_state1

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
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @initSubid06
	.dw @initSubid07
	.dw ambi_loadScript
	.dw ambi_ret
	.dw @initSubid0a


; Cutscene after escaping black tower
@initSubid01:
	ld a,($cfd0)
	cp $0b
	jp nz,ambi_loadScript
	call checkIsLinkedGame
	ret nz
	ld hl,mainScripts.ambiSubid01Script_part2
	jp interactionSetScript


; Cutscene where Ambi does evil stuff atop black tower (after d7)
@initSubid03:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete


; Same cutscene as subid $03, but second part
@initSubid04:
	callab agesInteractionsBank08.nayruState0@init0e
	jp ambi_loadScript


; Cutscene where you give mystery seeds to Ambi
@initSubid00:
	call soldierCheckBeatD6
	jp nc,interactionDelete


; Credits cutscene where Ambi observes construction of Link statue
@initSubid02:
	jp ambi_loadScript


; Cutscene where Ralph confronts Ambi
@initSubid05:
	; Call some of nayru's code to load possessed palette
	callab agesInteractionsBank08.nayruState0@init0e

	call objectSetVisiblec3
	jp ambi_loadScript


; Cutscene just before fighting possessed Ambi
@initSubid06:
	call getThisRoomFlags
	bit 7,a
	jp nz,interactionDelete

	; Load possessed palette and use it
	ld a,PALH_85
	call loadPaletteHeader
	ld h,d
	ld l,Interaction.oamFlags
	ld a,$06
	ldd (hl),a
	ld (hl),a

	ld a,$01
	ld (wNumEnemies),a

	; Create "ghost veran" object above Ambi
	call getFreeInteractionSlot
	jr z,++

	ld e,Interaction.state
	xor a
	ld (de),a
	ret
++
	ld (hl),INTERACID_GHOST_VERAN
	inc l
	inc (hl)
	ld bc,$f000
	call objectCopyPositionWithOffset

	ld a,SNDCTRL_STOPMUSIC
	call playSound

	; Set Link's direction & angle to "up"
	ld hl,w1Link.direction
	xor a
	ldi (hl),a
	ld (hl),a

	ld (wDisableLinkCollisionsAndMenu),a
	ld ($cfc0),a
	dec a
	ld (wActiveMusic),a

	ld hl,$cc93
	set 7,(hl)

	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,$16
	ld (wLinkStateParameter),a


; Cutscene where Ambi regains control of herself
@initSubid07:
	jp ambi_loadScript

@initSubid0a:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld hl,wGroup4Flags+$fc
	bit 7,(hl)
	jp z,interactionDelete
	jp ambi_loadScript

ambi_state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw ambi_updateAnimationAndRunScript
	.dw ambi_runSubid01
	.dw ambi_runSubid02
	.dw ambi_runSubid03
	.dw ambi_runSubid04
	.dw ambi_runSubid05
	.dw ambi_runSubid06
	.dw ambi_runSubid07
	.dw ambi_runSubid08
	.dw interactionAnimate
	.dw ambi_runSubid0a

ambi_updateAnimationAndRunScript:
	call interactionAnimate
	jp interactionRunScript


; Cutscene after escaping black tower
ambi_runSubid01:
	call checkIsLinkedGame
	jr z,@updateSubstate
	ld a,($cfd0)
	cp $0b
	jp c,@updateSubstate

	call interactionAnimate
	jpab scriptHelp.turnToFaceSomething

@updateSubstate:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw ambi_updateAnimationAndRunScript

@substate0:
	ld a,($cfd0)
	cp $0e
	jr nz,ambi_updateAnimationAndRunScript

	callab agesInteractionsBank08.startJump
	jp interactionIncSubstate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	ld l,Interaction.var3e
	inc (hl)

ambi_ret:
	ret


; Credits cutscene where Ambi observes construction of Link statue
ambi_runSubid02:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw interactionAnimateBasedOnSpeed

@substate0:
	call ambi_updateAnimationAndRunScript
	ret nc
	jp interactionIncSubstate

@substate1:
	call interactionAnimateBasedOnSpeed
	call objectApplySpeed
	ld a,($cfc0)
	cp $06
	ret nz
	call interactionIncSubstate
	ld bc,$5040
	jp interactionSetPosition


; Cutscene where Ambi does evil stuff atop black tower (after d7)
ambi_runSubid03:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @updateAnimationAndRunScript

@substate0:
	ld a,($cfc0)
	cp $01
	jr nz,@updateAnimationAndRunScript

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),SPEED_80

	call getFreePartSlot
	ret nz
	ld (hl),PARTID_LIGHTNING
	inc l
	inc (hl) ; [subid] = $01
	inc l
	inc (hl) ; [var03] = $01
	jp objectCopyPosition

@updateAnimationAndRunScript:
	call interactionAnimateBasedOnSpeed
	jp interactionRunScript

@substate1:
	call interactionDecCounter1
	ret nz
	xor a
	ld (wTmpcbb3),a
	dec a
	ld (wTmpcbba),a
	jp interactionIncSubstate

@substate2:
	ld hl,wTmpcbb3
	ld b,$02
	call flashScreen
	ret z

	call interactionIncSubstate
	ldbc INTERACID_SPARKLE,$08
	call objectCreateInteraction
	ld a,$02
	jp fadeinFromWhiteWithDelay

@substate3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$02
	ld ($cfc0),a
	jp interactionIncSubstate


; Same cutscene as subid $03 (black tower after d7), but second part
ambi_runSubid04:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw interactionAnimate

@substate0:
	call ambi_updateAnimationAndRunScript
	ret nc
	xor a
	ld (wTmpcbb3),a
	dec a
	ld (wTmpcbba),a
	jp interactionIncSubstate

@substate1:
	ld hl,wTmpcbb3
	ld b,$02
	call flashScreen
	ret z
	ld a,$03
	ld ($cfc0),a
	jp interactionIncSubstate

ambi_runSubid05:
	call interactionRunScript
	jp c,interactionDelete
	ld a,($cfc0)
	bit 1,a
	jp z,interactionAnimate
	ret

; Unused?
@data:
	.db $82 $90 $00 $55 $03


; $06: Cutscene just before fighting possessed Ambi
; $07: Cutscene where Ambi regains control of herself
ambi_runSubid06:
ambi_runSubid07:
	call interactionRunScript
	jp nc,interactionAnimate
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	jp interactionDelete


; Cutscene after d3 where you're told Ambi's tower will soon be complete
ambi_runSubid08:
	call ambi_updateAnimationAndRunScript
	ret nc

	ld a,$01
	ld ($cbb8),a
	ld a,CUTSCENE_BLACK_TOWER_EXPLANATION
	ld (wCutsceneTrigger),a
	jp interactionDelete


; NPC after Zelda is kidnapped
ambi_runSubid0a:
	call npcFaceLinkAndAnimate
	jp interactionRunScript


ambi_loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.ambiSubid00Script
	.dw mainScripts.ambiSubid01Script_part1
	.dw mainScripts.ambiSubid02Script
	.dw mainScripts.ambiSubid03Script
	.dw mainScripts.ambiSubid04Script
	.dw mainScripts.ambiSubid05Script
	.dw mainScripts.ambiSubid06Script
	.dw mainScripts.ambiSubid07Script
	.dw mainScripts.ambiSubid08Script
	.dw mainScripts.stubScript
	.dw mainScripts.ambiSubid0aScript


; ==============================================================================
; INTERACID_SUBROSIAN
; ==============================================================================
interactionCode4e:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw subrosian_subid00
	.dw subrosian_subid01
	.dw subrosian_subid02
	.dw subrosian_subid03
	.dw subrosian_subid04


; Subrosian in lynna village (linked only)
subrosian_subid00:
	call checkInteractionState
	jr nz,@state1

@state0:
	call interactionIncState
	call interactionInitGraphics
	call objectSetVisiblec2
	ld a,>TX_1c00
	call interactionSetHighTextIndex

	call checkIsLinkedGame
	jp z,interactionDeleteAndUnmarkSolidPosition

	callab getGameProgress_2
	ld a,b
	cp $05
	ld hl,mainScripts.subrosianInVillageScript_afterGotMakuSeed
	jr z,@setScript
	cp $07
	jp nz,interactionDeleteAndUnmarkSolidPosition

	ld hl,mainScripts.subrosianInVillageScript_postGame

@setScript:
	call interactionSetScript

@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

subrosian_subid01:
	; Borrow goron code?
	jpab goronSubid01


; Subrosian in goron dancing game (var03 is 0 or 1 for green or red npcs)
subrosian_subid02:
	call checkInteractionState
	jr nz,@state1

@state0:
	call subrosian_initSubid02
	call interactionRunScript
@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate


; Linked game NPC telling you the subrosian secret (for bombchus)
subrosian_subid03:
	call checkInteractionState
	jr nz,subrosian_subid04@state1

@state0:
	call subrosian_initGraphicsAndIncState
	ld a,$02
	jr subrosian_subid04@initSecretTellingNpc


; Linked game NPC telling you the smith secret (for shield upgrade)
subrosian_subid04:
	call checkInteractionState
	jr nz,@state1

@state0:
	call subrosian_initGraphicsAndIncState
	ld a,$04

@initSecretTellingNpc:
	ld e,Interaction.var3f
	ld (de),a
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	call interactionRunScript
@state1:
	call interactionRunScript
	jp c,interactionDeleteAndUnmarkSolidPosition
	jp npcFaceLinkAndAnimate

;;
subrosian_initGraphicsAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

;;
subrosian_unused_63ec:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jr subrosian_loadScript


;;
subrosian_initSubid02:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jr subrosian_loadScriptIndex

;;
; Load a script based just on the subid.
subrosian_loadScript:
	call subrosian_getScriptPtr
	call interactionSetScript
	jp interactionIncState

;;
; Load a script based on the subid and var03.
subrosian_loadScriptIndex:
	call subrosian_getScriptPtr
	inc e
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

;;
; @param[out]	hl	Pointer read from scriptTable (either points to a script or to
;			a table of scripts)
subrosian_getScriptPtr:
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
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw @subid02Scripts

@subid02Scripts:
	.dw mainScripts.subrosianAtGoronDanceScript_greenNpc
	.dw mainScripts.subrosianAtGoronDanceScript_redNpc


; ==============================================================================
; INTERACID_IMPA_NPC
; ==============================================================================
interactionCode4f:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw impaNpc_subid00
	.dw impaNpc_subid01
	.dw impaNpc_subid02
	.dw impaNpc_subid03

impaNpc_subid00:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionRunScript
	ld e,Interaction.var03
	ld a,(de)
	dec a
	jr z,@animate

	cp $09
	call nz,impaNpc_faceLinkIfClose
@animate:
	jp interactionAnimateAsNpc

@state0:
	; Set the tile leading to nayru's basement to behave like stairs
	ld hl,wRoomLayout+$22
	ld (hl),TILEINDEX_INDOOR_DOWNSTAIRCASE

	call getImpaNpcState
	bit 7,b
	jp nz,interactionDelete

	call checkIsLinkedGame
	jr z,+
	ld a,$09
+
	add b
	call impaNpc_determineTextAndPositionInHouse

;;
; @param	hl	Script address
impaNpc_setScriptAndInitialize:
	call interactionSetScript
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.textID+1
	ld (hl),>TX_0100

	call objectMarkSolidPosition

	ld e,Interaction.var38
	ld a,(de)
	call interactionSetAnimation

	jp objectSetVisiblec2

;;
; Sets low byte of textID and returns a script address to use.
;
; May delete itself, then pop the return address from the stack to return from caller...
;
; @param	a	Index of "behaviour" ($00-$08 for unlinked, $09-$11 for linked)
; @param[out]	hl	Script address
impaNpc_determineTextAndPositionInHouse:
	ld e,Interaction.var03
	ld (de),a
	rst_jumpTable
	.dw @val00
	.dw @val01
	.dw @val02
	.dw @val03
	.dw @val04
	.dw @val05
	.dw @delete
	.dw @delete
	.dw @delete
	.dw @val09
	.dw @val0a
	.dw @val0b
	.dw @delete
	.dw @val0d
	.dw @val0e
	.dw @delete
	.dw @delete
	.dw @delete

@delete:
	pop hl
	jp interactionDelete

@val00:
@val09:
	ld bc,$3838
	ld a,<TX_0120
	jr @setTextAndPosition

@val01:
@val0a:
	ld bc,$4828
	ld a,<TX_0121
	call @setTextAndPosition
	ld (de),a
	ld hl,mainScripts.impaNpcScript_lookingAtPassage
	ret

@val02:
@val03:
@val04:
@val0b:
	ld bc,$2868
	ld a,<TX_0122
	jr @setTextAndPosition

@val0d:
	ld bc,$2868
	ld a,<TX_012c
	jr @setTextAndPosition

@val05:
@val0e:
	ld bc,$2868
	ld a,<TX_0123

@setTextAndPosition:
	ld e,Interaction.textID
	ld (de),a
	ld e,Interaction.yh
	ld a,b
	ld (de),a
	ld e,$4d
	ld a,c
	ld (de),a

	; var38 is the direction to face
	ld e,Interaction.var38
	ld a,$02
	ld (de),a

	ld hl,mainScripts.genericNpcScript
	xor a
	ret


; Impa in past (after telling you about Ralph's heritage)
impaNpc_subid01:
	call checkInteractionState
	jr nz,impaNpc_runScriptAndFaceLink
	call getImpaNpcState
	ld a,b
	cp $07
	jp nz,interactionDelete

	call checkIsLinkedGame
	ld a,<TX_012b
	jr z,impaNpc_setTextIndexAndLoadGenericNpcScript
	ld a,<TX_012e


;;
; @param	a	Low byte of text index (high byte is $01)
impaNpc_setTextIndexAndLoadGenericNpcScript:
	ld e,Interaction.textID
	ld (de),a

	; var38 is the direction to face
	ld e,Interaction.var38
	ld a,$02
	ld (de),a

	ld hl,mainScripts.genericNpcScript
	jp impaNpc_setScriptAndInitialize


; Impa after Zelda's been kidnapped
impaNpc_subid02:
	call checkInteractionState
	jr nz,impaNpc_runScriptAndFaceLink

@state0:
	call getImpaNpcState
	ld a,b
	cp $08
	jp nz,interactionDelete
	ld a,<TX_012f
	jr impaNpc_setTextIndexAndLoadGenericNpcScript


impaNpc_runScriptAndFaceLink:
	call interactionRunScript
	call impaNpc_faceLinkIfClose
	jp interactionAnimateAsNpc


; Impa after getting the maku seed
impaNpc_subid03:
	call checkInteractionState
	jr nz,impaNpc_runScriptAndFaceLink

	call getImpaNpcState
	ld a,b
	cp $06
	jp nz,interactionDelete

	ld a,<TX_0123
	jr impaNpc_setTextIndexAndLoadGenericNpcScript

;;
impaNpc_faceLinkIfClose:
	ld c,$28
	call objectCheckLinkWithinDistance
	jr nc,@noChange

	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	swap a
	rlca
	jr @updateDirection

@noChange:
	ld e,Interaction.var38
	ld a,(de)
@updateDirection:
	ld h,d
	ld l,Interaction.direction
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation

;;
; Returns something in 'b':
; * $00 before d2 breaks down;
; * $01 after d2 breaks down;
; * $02 after obtaining harp;
; * $03 after beating d3;
; * $04 after saving Zelda from vire;
; * $05 after saving Nayru;
; * $06 after getting maku seed;
; * $07 after cutscene where Impa tells you about Ralph's heritage;
; * $08 after flame of despair is lit (beat Veran in a linked game);
; * $ff after finishing game
;
; @param[out]	b	Return value
getImpaNpcState:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ld b,$ff
	ret nz
	inc b
	ld a,(wPresentRoomFlags+$83)
	rlca
	ret nc

	ld a,TREASURE_HARP
	call checkTreasureObtained
	ld b,$01
	ret nc

	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	jr nz,@savedNayru

	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA
	call checkGlobalFlag
	ld b,$04
	ret nz

	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	bit 2,a
	ld b,$02
	ret z
	inc b
	ret

@savedNayru:
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	ld b,$05
	ret nc

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	ld b,$06
	ret z

	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT
	call checkGlobalFlag
	ld b,$07
	ret z
	inc b
	ret


; ==============================================================================
; INTERACID_DUMBBELL_MAN
; ==============================================================================
interactionCode51:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @initialize
	call interactionSetAlwaysUpdateBit

@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc
	call interactionInitGraphics
	jp interactionIncState

@initialize:
	call interactionInitGraphics
	ld a,>TX_0b00
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
	.dw mainScripts.dumbbellManScript


; ==============================================================================
; INTERACID_OLD_MAN
; ==============================================================================
interactionCode52:
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

; Old man who takes a secret to give you the shield (same spot as subid $02)
@runSubid00:
	call checkInteractionState
	jr nz,@@state1


@@state0:
	call @loadScriptAndInitGraphics
@@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate


; Old man who gives you book of seals
@runSubid01:
	call checkInteractionState
	call z,@loadScriptAndInitGraphics
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc


; Old man guarding fairy powder in past (same spot as subid $00)
@runSubid02:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	call @loadScriptAndInitGraphics

@@state1:
	call interactionAnimateAsNpc
	call interactionRunScript
	ret nc
	ld a,SND_TELEPORT
	call playSound
	ld hl,@warpDest
	jp setWarpDestVariables

@warpDest:
	m_HardcodedWarpA ROOM_AGES_5ec, $00, $17, $03


; Generic NPCs in the past library
@runSubid03:
@runSubid04:
@runSubid05:
@runSubid06:
	call checkInteractionState
	jr z,@@state0

@@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc

@@state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.textID+1
	ld (hl),>TX_3300

	ld l,Interaction.collisionRadiusX
	ld (hl),$06
	ld l,Interaction.direction
	dec (hl)

	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld b,$00
	jr z,+
	inc b
+
	ld e,Interaction.subid
	ld a,(de)
	sub $03
	ld c,a
	add a
	add b
	ld hl,@textIndices
	rst_addAToHl
	ld e,Interaction.textID
	ld a,(hl)
	ld (de),a

	ld a,c
	add a
	add c
	ld hl,@baseVariables
	rst_addAToHl
	ld e,Interaction.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.oamFlagsBackup
	ldi a,(hl)
	ld (de),a
	inc e
	ld (de),a
	ld e,Interaction.var38
	ld a,(hl)
	ld (de),a
	call interactionSetAnimation
	call objectSetVisiblec2

	ld hl,mainScripts.oldManScript_generic
	jp interactionSetScript


; b0: collisionRadiusY
; b1: oamFlagsBackup
; b2: animation (can be thought of as direction to face?)
@baseVariables:
	.db $12 $02 $02
	.db $06 $00 $00
	.db $06 $00 $00
	.db $06 $01 $02

; The first and second columns are the text to show before and after the water pollution
; is fixed, respectively.
@textIndices:
	.db <TX_3300, <TX_3301
	.db <TX_3302, <TX_3303
	.db <TX_3304, <TX_3305
	.db <TX_3306, <TX_3307

@func_669d: ; Unused?
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
	.dw mainScripts.oldManScript_givesShieldUpgrade
	.dw mainScripts.oldManScript_givesBookOfSeals
	.dw mainScripts.oldManScript_givesFairyPowder


; ==============================================================================
; INTERACID_MAMAMU_YAN
; ==============================================================================
interactionCode53:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @initGraphicsLoadScriptAndIncState

@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate


@initGraphicsAncIncState: ; Unused?
	call interactionInitGraphics
	jp interactionIncState


@initGraphicsLoadScriptAndIncState:
	call interactionInitGraphics
	ld a,>TX_0b00
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
	.dw mainScripts.mamamuYanScript


; ==============================================================================
; INTERACID_MAMAMU_DOG
;
; Variables (for subid $01):
;   var3a: Target position index
;   var3b: Highest valid value for "var3a" (before looping?)
;   var3c/3d: Address of "position data" to get target position from
;   var3e: Used as a counter in script
;   var3f: Animation index
; ==============================================================================
interactionCode54:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw dog_subid00
	.dw dog_subid01

; Dog in mamamu's house
dog_subid00:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jr z,@dontDelete

	ld a,GLOBALFLAG_RETURNED_DOG
	call checkGlobalFlag
	jp nz,@dontDelete

	call getThisRoomFlags
	bit 5,(hl)
	jp nz,interactionDelete

@dontDelete:
	call dog_initGraphicsLoadScriptAndIncState
	ld h,d
	ld l,Interaction.angle
	ld (hl),$18
	ld l,Interaction.speed
	ld (hl),SPEED_100

	ld a,$02
	ld l,Interaction.var3f
	ld (hl),a
	call interactionSetAnimation
@state1:
	call interactionRunScript
	jp c,interactionDelete
	call interactionAnimate
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; Dog outside that Link needs to find for a "sidequest"
dog_subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,GLOBALFLAG_RETURNED_DOG
	call checkGlobalFlag
	jp nz,interactionDelete
	ld hl,wPresentRoomFlags+$e7
	bit 7,(hl)
	jp z,interactionDelete

	; Check if the dog's location corresponds to this object; if not, delete self.
	ld a,(wMamamuDogLocation)
	ld h,d
	ld l,Interaction.var03
	cp (hl)
	jp nz,interactionDelete

	call dog_initGraphicsLoadScriptAndIncState
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld l,Interaction.direction
	ld (hl),$ff

	; a==0 here, which is important. It was set to 0 by the call to
	; "interactionSetScript", and wasn't changed after that...
	; It's probably supposed to equal "var03" here. Bug?
	call dog_setTargetPositionIndex

	ld hl,wMamamuDogLocation
@tryAgain:
	call getRandomNumber
	and $03
	cp (hl)
	jr z,@tryAgain
	ld (hl),a

@state1:
	call dog_moveTowardTargetPosition
	call dog_checkCloseToTargetPosition
	call c,dog_incTargetPositionIndex
	jr c,@delete

	call dog_moveTowardTargetPosition
	call dog_updateDirection
	call dog_checkCloseToTargetPosition
	call c,dog_incTargetPositionIndex
	jr c,@delete

	callab scriptHelp.mamamuDog_updateSpeedZ
	call interactionAnimate
	call objectSetPriorityRelativeToLink_withTerrainEffects
	jp objectAddToGrabbableObjectBuffer

@delete:
	jp interactionDelete


; State 2: grabbed by Link (will cause Link to warp to mamamu's house)
@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

; Just grabbed
@substate0:
	xor a
	ld (wLinkGrabState2),a
	inc a
	ld (de),a
	ld a,GLOBALFLAG_RETURNED_DOG
	call setGlobalFlag
	ld a,$81
	ld (wMenuDisabled),a
	ld (wDisableScreenTransitions),a
	jp objectSetVisiblec1

; Being lifted
@substate1:
	ld e,Interaction.var39
	ld a,(de)
	rst_jumpTable
	.dw @@minorState0
	.dw @@minorState1
	.dw @@minorState2

@@minorState0:
	ld a,(wLinkGrabState)
	cp $83
	ret nz

	ld a,$81
	ld (wDisabledObjects),a
	ld a,$80
	ld (wMenuDisabled),a
	ld h,d
	ld l,Interaction.var39
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),40

@@minorState1:
	call interactionDecCounter1
	ret nz

	ld h,d
	ld l,Interaction.var39
	inc (hl)
	ld bc,TX_007f
	jp showText

@@minorState2:
	ld a,(wTextIsActive)
	or a
	ret nz
	ld hl,@warpDest
	call setWarpDestVariables
	ld a,SND_TELEPORT
	jp playSound

@warpDest:
	m_HardcodedWarpA ROOM_AGES_2e7, $00, $25, $83

@substate2:
	ret

@substate3:
	jp objectSetVisiblec2


@initGraphicsAndIncState: ; Unused?
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


dog_initGraphicsLoadScriptAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld e,Interaction.subid
	ld a,(de)
	ld hl,dog_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

;;
dog_moveTowardTargetPosition:
	ld h,d
	ld l,Interaction.var3a
	ld a,(hl)
	add a
	ld b,a

	ld e,Interaction.var3d
	ld a,(de)
	ld l,a
	ld e,Interaction.var3c
	ld a,(de)
	ld h,a
	ld a,b
	rst_addAToHl
	ld b,(hl)
	inc hl
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	jp objectApplySpeed

;;
; @param[out]	cflag	Set if close to target position
dog_checkCloseToTargetPosition:
	call dog_getTargetPositionAddress
	ld l,Interaction.yh
	ld a,(bc)
	sub (hl)
	add $01
	cp $05
	ret nc
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	sub (hl)
	add $01
	cp $05
	ret

;;
; Update direction based on angle.
dog_updateDirection:
	ld h,d
	ld l,Interaction.angle
	ld a,(hl)
	swap a
	and $01
	xor $01
	ld l,Interaction.direction
	cp (hl)
	ret z
	ld (hl),a
	add $02
	jp interactionSetAnimation

;;
; @param[out]	cflag	Set if the position index "looped" (dog went off-screen)
dog_incTargetPositionIndex:
	call dog_snapToTargetPosition
	ld h,d
	ld l,Interaction.var3b
	ld a,(hl)
	ld l,Interaction.var3a
	inc (hl)

	; Check whether to loop back around
	cp (hl)
	ret nc
	ld (hl),$00
	scf
	ret

;;
dog_snapToTargetPosition:
	call dog_getTargetPositionAddress
	ld l,Interaction.y
	xor a
	ldi (hl),a
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.x
	xor a
	ldi (hl),a
	ld a,(bc)
	ld (hl),a
	ret

;;
; @param[out]	bc	Address of target position (2 bytes, Y and X)
dog_getTargetPositionAddress:
	ld e,Interaction.var3d
	ld a,(de)
	ld c,a
	ld e,Interaction.var3c
	ld a,(de)
	ld b,a
	ld h,d
	ld l,Interaction.var3a
	ld a,(hl)
	call addDoubleIndexToBc
	ret

;;
; This function is supposed to return the address of a "position list" for a map; however,
; due to an apparent issue with the caller, the data for the first map is always used.
;
; @param	a	Index of data to read (0-3 for corresponding maps)
dog_setTargetPositionIndex:
	ld hl,@dogPositionLists
	rst_addDoubleIndex
	ld e,Interaction.var3d
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.var3c
	ldi a,(hl)
	ld (de),a

	ld e,Interaction.var3b
	ld a,$06
	ld (de),a
	ret

@dogPositionLists:
	.dw @map0
	.dw @map1
	.dw @map2
	.dw @map3

@map0:
	.db $68 $68
	.db $48 $48
	.db $68 $18
	.db $68 $48
	.db $48 $28
	.db $68 $58
	.db $48 $00
@map1:
	.db $38 $78
	.db $68 $28
	.db $68 $88
	.db $68 $38
	.db $28 $68
	.db $58 $48
	.db $48 $b0
@map2:
	.db $68 $28
	.db $48 $08
	.db $58 $58
	.db $28 $18
	.db $18 $68
	.db $48 $38
	.db $00 $68
@map3:
	.db $18 $38
	.db $68 $78
	.db $68 $28
	.db $38 $78
	.db $38 $38
	.db $58 $68
	.db $58 $00


dog_scriptTable:
	.dw mainScripts.dogInMamamusHouseScript


; ==============================================================================
; INTERACID_POSTMAN
; ==============================================================================
interactionCode55:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @loadScriptAndInitGraphics
@state1:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	call interactionAnimateBasedOnSpeed
	jp objectSetPriorityRelativeToLink_withTerrainEffects

@unusedFunc_690b:
	call interactionInitGraphics
	jp interactionIncState

@loadScriptAndInitGraphics:
	call interactionInitGraphics
	ld a,>TX_0b00
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
	.dw mainScripts.postmanScript


; ==============================================================================
; INTERACID_PICKAXE_WORKER
; ==============================================================================
interactionCode57:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03

; Subid 0: Worker below Maku Tree screen in past
; Subid 3: Worker in black tower.
@subid00:
@subid03:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	call @loadScriptAndInitGraphics
	call interactionSetAlwaysUpdateBit

@@state1:
	call interactionRunScript
	jp c,interactionDelete

	call interactionAnimateAsNpc
	ld e,Interaction.animParameter
	ld a,(de)
	or a
	ret z

	; animParameter is nonzero; just struck the ground.
	ld a,SND_CLINK
	call playSound
	ld a,(wScrollMode)
	and $01
	ret z
	ld a,$03
	jp @createDirtChips


; Credits cutscene guy making Link statue?
@subid01:
	call checkInteractionState
	jr nz,@subid1State1

@subid1And2State0:
	ld e,Interaction.subid
	ld a,(de)
	dec a
	ld a,$0c
	jr z,+
	ld a,$f4
+
	ld e,Interaction.var38
	ld (de),a
	call @loadScriptAndInitGraphics

@subid1State1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid1And2Substate0
	.dw @subid1Substate1
	.dw @subid1Substate2
	.dw @subid1Substate3
	.dw @updateAnimationAndRunScript


@subid1And2Substate0:
	ld a,($cfc0)
	cp $01
	jr nz,@label_09_221

	call interactionIncSubstate
	ld l,Interaction.subid
	ld a,(hl)
	dec a
	ld hl,@subid1And2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@label_09_221:
	call interactionAnimateBasedOnSpeed
	call interactionRunScript
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	jr z,@doneSpawningObjects

	; Spawn in some objects when pickaxe hits statue?
	ld (hl),$00
	ld b,$04
@nextObject:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_EXPLOSION_WITH_DEBRIS
	inc l
	ld (hl),$02
	inc l
	ld (hl),b
	ld e,Interaction.visible
	ld a,(de)
	ld l,Interaction.var38
	ld (hl),a
	push bc
	ld e,Interaction.var38
	ld a,(de)
	ld b,$00
	ld c,a
	call objectCopyPositionWithOffset
	pop bc
	dec b
	jr nz,@nextObject

@doneSpawningObjects:
	ld l,Interaction.yh
	ld a,(hl)
	cp $50
	jp nc,objectSetVisiblec1
	jp objectSetVisiblec3

@subid1Substate1:
	call @updateAnimationAndRunScript
	ret nc
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),210
	ret

@updateAnimationAndRunScript:
	ld e,Interaction.var3f
	ld a,(de)
	or a
	call z,interactionAnimateBasedOnSpeed
	jp interactionRunScript

@subid1Substate2:
	call interactionAnimateBasedOnSpeed
	call objectApplySpeed
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	jp fadeoutToWhite

@subid1Substate3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call interactionIncSubstate
	ld a,$06
	ld ($cfc0),a
	call disableLcd
	push de

	; Force-reload maku tree screen?
	ld bc,ROOM_AGES_138
	ld a,$00
	call forceLoadRoom

	ld a,UNCMP_GFXH_2d
	call loadUncompressedGfxHeader
	ld a,PALH_TILESET_MAKU_TREE
	call loadPaletteHeader
	ld a,GFXH_CREDITS_SCENE_MAKU_TREE_PAST
	call loadGfxHeader

	ld a,$ff
	ld (wTilesetAnimation),a
	ld a,$04
	call loadGfxRegisterStateIndex

	pop de
	ld bc,$427e
	call interactionSetPosition
	ld a,$02
	ld hl,@subid1And2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp fadeinFromWhite


; Credits cutscene guy making Link statue?
@subid02:
	call checkInteractionState
	jr nz,++
	jp @subid1And2State0
++
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid1And2Substate0
	.dw @subid2Substate1
	.dw @subid2Substate2
	.dw @updateAnimationAndRunScript

@subid2Substate1:
	call @updateAnimationAndRunScript
	ret nc
	call interactionIncSubstate

@subid2Substate2:
	call interactionAnimateBasedOnSpeed
	call objectApplySpeed
	ld a,($cfc0)
	cp $06
	ret nz
	call interactionIncSubstate
	ld bc,$388a
	call interactionSetPosition
	ld a,$03
	ld hl,@subid1And2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript


@unusedFunc_6a80:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,>TX_1b00
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

;;
; Create the debris that comes out when the pickaxe hits the ground.
@createDirtChips:
	ld c,a
	ld b,$02

; b = number of objects to create
; c = var03
@next:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_FALLING_ROCK
	inc l
	ld (hl),$06 ; [new.subid] = $06
	inc l
	ld (hl),c   ; [new.var03] = c

	ld e,Interaction.visible
	ld a,(de)
	and $03
	ld l,Interaction.counter2
	ld (hl),a
	ld l,Interaction.angle
	ld (hl),b
	dec (hl)

	push bc
	call objectCopyPosition
	pop bc

	; [new.yh] = [this.yh]+4
	ld l,Interaction.yh
	ld a,(hl)
	add $04

	; [new.xh] = [this.xh]-$0e if [this.animParameter] == $01, otherwise [this.xh]+$0e
	ld (hl),a
	ld e,Interaction.animParameter
	ld a,(de)
	cp $01
	ld l,Interaction.xh
	ld a,(hl)
	jr z,+
	add $0e*2
+
	sub $0e
	ld (hl),a

	dec b
	jr nz,@next
	ret


@scriptTable:
	.dw mainScripts.pickaxeWorkerSubid00Script
	.dw mainScripts.pickaxeWorkerSubid01Script_part1
	.dw mainScripts.pickaxeWorkerSubid02Script_part1
	.dw mainScripts.pickaxeWorkerSubid03Script

@subid1And2ScriptTable:
	.dw mainScripts.pickaxeWorkerSubid01Script_part2
	.dw mainScripts.pickaxeWorkerSubid02Script_part2
	.dw mainScripts.pickaxeWorkerSubid01Script_part3
	.dw mainScripts.pickaxeWorkerSubid02Script_part3


; ==============================================================================
; INTERACID_HARDHAT_WORKER
; ==============================================================================
interactionCode58:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03


; NPC who gives you the shovel. If var03 is nonzero, he's just a generic guy.
@subid00:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	call @loadScriptAndInitGraphics
	call interactionSetAlwaysUpdateBit
	ld a,$04
	call interactionSetAnimation
@@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc


; Generic NPC.
@subid01:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	call @loadScriptAndInitGraphics
	call interactionRunScript
	call interactionRunScript
@@state1:
	call interactionRunScript
	jp c,interactionDeleteAndUnmarkSolidPosition
	jp npcFaceLinkAndAnimate


; NPC who guards the entrance to the black tower.
@subid02:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	ld a,(wEssencesObtained)
	bit 3,a
	jp nz,interactionDelete
	call getThisRoomFlags
	bit 7,a
	jr z,+
	ld bc,$3858
	call interactionSetPosition
+
	call @loadScriptAndInitGraphics
@@state1:
	call interactionRunScript
	ld e,Interaction.var38
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	jp interactionAnimateAsNpc


@subid03:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	call @loadScriptAndInitGraphics
	call interactionRunScript
@@state1:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	call interactionAnimateBasedOnSpeed
	jp interactionPushLinkAwayAndUpdateDrawPriority


@unusedFunc_6b70:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,>TX_1000
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
	.dw mainScripts.hardhatWorkerSubid00Script
	.dw mainScripts.hardhatWorkerSubid01Script
	.dw mainScripts.hardhatWorkerSubid02Script
	.dw mainScripts.hardhatWorkerSubid03Script


; ==============================================================================
; INTERACID_POE
;
; var3e: Animations don't update when nonzero. (Used when disappearing.)
; var3f: If nonzero, doesn't face toward Link.
; ==============================================================================
interactionCode59:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld e,Interaction.var03
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02


; (Note, these are labelled as subid, but they're really based on var03.)
; First encounter with poe.
@initSubid00:
	; Delete self if already talked (either in overworld on in tomb)
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete
	ld hl,wPresentRoomFlags+$2e
	bit 6,(hl)
	jp nz,interactionDelete

	jr @init


; Final encounter with poe where you get the clock
@initSubid02:
	; Delete self if already got item, or haven't talked yet in either overworld or
	; tomb
	call getThisRoomFlags
	bit ROOMFLAG_BIT_ITEM,(hl)
	jp nz,interactionDelete
	bit 6,(hl)
	jp z,interactionDelete
	ld hl,wPresentRoomFlags+$2e
	bit 6,(hl)
	jp z,interactionDelete

	jr @init


; Poe in his tomb
@initSubid01:
	; Delete self if haven't talked in overworld, or have talked in tomb.
	ld hl,wPresentRoomFlags+$7c
	bit 6,(hl)
	jp z,interactionDelete
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete

@init:
	call @loadScriptAndInitGraphics
@state1:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var3e
	ld a,(de)
	or a
	ret nz
	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	call interactionAnimate
	jp objectSetPriorityRelativeToLink_withTerrainEffects


@unusedFunc_6bff:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
	call objectMarkSolidPosition
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
	.dw mainScripts.poeScript


; ==============================================================================
; INTERACID_OLD_ZORA
; ==============================================================================
interactionCode5a:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @loadScriptAndInitGraphics
	call interactionSetAlwaysUpdateBit
@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc

@unusedFunc_6c34:
	call interactionInitGraphics
	jp interactionIncState

@loadScriptAndInitGraphics:
	call interactionInitGraphics
	ld a,>TX_0b00
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
	.dw mainScripts.oldZoraScript


; ==============================================================================
; INTERACID_TOILET_HAND
; ==============================================================================
interactionCode5b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call @loadScriptAndInitGraphics
	call interactionSetAlwaysUpdateBit
	callab commonInteractions1.clearFallDownHoleEventBuffer


; Normal script is running; waiting for Link to talk or for something to fall into a hole.
@state1:
	call @respondToObjectInHole
	jr c,@droppedSomethingIntoHole

	call interactionRunScript
	ld h,d
	ld l,Interaction.visible
	bit 7,(hl)
	ret z
	jp interactionAnimateAsNpc

@droppedSomethingIntoHole:
	ld hl,mainScripts.toiletHandScript_reactToObjectInHole
	call interactionSetScript
	jp interactionIncState


; Running the "object fell in a hole" script; returns to state 1 when that's done.
@state2:
	ld a,(wTextIsActive)
	or a
	ret nz

	call interactionRunScript
	jr c,@scriptEnded

	ld h,d
	ld l,Interaction.visible
	bit 7,(hl)
	ret z
	call interactionAnimateAsNpc
	jp interactionAnimate

@scriptEnded:
	call @loadScript
	callab commonInteractions1.clearFallDownHoleEventBuffer
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret


@unusedFunc_6c0d:
	call interactionInitGraphics
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	call interactionIncState

@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

;;
; Reads from the "object fallen in hole" buffer at $cfd8 to decide on a reaction. Sets
; var38 to an index based on which item it was to be used in a script later.
;
; @param[out]	cflag	c if there is a defined reaction to the object that fell in the
;                       hole (and something did indeed fall in).
@respondToObjectInHole:
	ld a,(wTextIsActive)
	or a
	ret nz

	ld a,($cfd8)
	inc a
	ld e,a
	ld hl,@objectTypeTable
	call lookupKey
	ret nc

	ld hl,@objectReactionTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,($cfd9)
	ld e,a
	call lookupKey
	ret nc
	ld e,Interaction.var38
	ld (de),a
	ret

@objectTypeTable:
	.db Item.id,        $00
	.db Interaction.id, $01
	.db $00

@objectReactionTable:
	.dw @items
	.dw @interactions

; First byte is the object ID to detect; second is an index that the script will use later
; (gets written to var38).
@items:
	.db ITEMID_BOMB,          $00
	.db ITEMID_BOMBCHUS,      $01
	.db ITEMID_18,            $02
	.db ITEMID_EMBER_SEED,    $03
	.db ITEMID_SCENT_SEED,    $04
	.db ITEMID_GALE_SEED,     $05
	.db ITEMID_MYSTERY_SEED,  $06
	.db ITEMID_BRACELET,      $07
	.db $00

@interactions:
	.db INTERACID_PUSHBLOCK,  $07
	.db $00

@scriptTable:
	.dw mainScripts.toiletHandScript


; ==============================================================================
; INTERACID_MASK_SALESMAN
; ==============================================================================
interactionCode5c:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @loadScriptAndInitGraphics
	call interactionSetAlwaysUpdateBit
@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc
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
	.dw mainScripts.maskSalesmanScript


; ==============================================================================
; INTERACID_BEAR
; ==============================================================================
interactionCode5d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw bear_state0
	.dw bear_state1


bear_state0:
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
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02

@initSubid00:
	; If you've talked to the bear already, shift him down 16 pixels
	call getThisRoomFlags
	bit 7,a
	jr nz,++

	ld e,Interaction.yh
	ld a,(de)
	add $10
	ld (de),a
++
	ld hl,mainScripts.bearSubid00Script_part1
	jp interactionSetScript

@initSubid01:
	ret

@initSubid02:
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr nz,@var03IsNonzero

	; var03 is $00.

	ld a,GLOBALFLAG_INTRO_DONE
	call checkGlobalFlag
	jp z,interactionDelete

	; Spawn animal buddies
	ld hl,objectData.animalsWaitingForNayru
	call parseGivenObjectData

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,GLOBALFLAG_MAKU_TREE_SAVED
	call checkGlobalFlag
	jp z,interactionDelete

	; Text changes after saving Nayru
	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	ld a,$00
	jp z,+
	inc a
+
	jr ++

@var03IsNonzero:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,$02
++
	call @chooseTextID
	ld hl,mainScripts.bearSubid02Script
	jp interactionSetScript

@chooseTextID:
	ld hl,@textIDs
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.textID
	ld (de),a
	ld a,>TX_5700
	inc e
	ld (de),a
	ret

@textIDs:
	.db <TX_5712
	.db <TX_5713
	.db <TX_5714


bear_state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw interactionAnimate
	.dw @runSubid02


; Bear listening to Nayru at start of game.
@runSubid00:
	call interactionAnimateAsNpc
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	call interactionRunScript

	; Wait for Link to get close enough to trigger the cutscene
	ld hl,w1Link.xh
	ld a,(hl)
	cp $60
	ret c
	ld l,<w1Link.yh
	ld a,(hl)
	cp $3e
	ret nc

	; Put Link into the cutscene state
	ld a,SPECIALOBJECTID_LINK_CUTSCENE
	call setLinkIDOverride
	ld l,<w1Link.subid
	ld (hl),$03

	ld hl,mainScripts.bearSubid00Script_part2
	call interactionSetScript
	call interactionIncSubstate

@substate1:
	call interactionRunScript
	ld a,($cfd0)
	cp $0e
	ret nz
	call interactionIncSubstate
	ld a,$02
	jp interactionSetAnimation

@substate2:
	call interactionAnimate
	ld a,($cfd0)
	cp $10
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),40
	ret

@substate3:
	call interactionDecCounter1
	jp nz,interactionAnimate
	call interactionIncSubstate
	ld l,Interaction.angle
	ld (hl),$02
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld a,$01
	jp interactionSetAnimation

@substate4:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	call objectApplySpeed
	jp interactionAnimate


@runSubid02:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc


; ==============================================================================
; INTERACID_SWORD
; ==============================================================================
interactionCode5e:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	; var37 holds last animation (set $ff to force update)
	ld a,$ff
	ld e,Interaction.var37

	ld (de),a
	call interactionInitGraphics

@state1:
	; Invisible by default
	call objectSetInvisible

	; If [relatedObj1.enabled] & ([this.var3f]+1) == 0, delete self
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld l,Interaction.var3f
	ld a,(hl)
	inc a
	ld l,Interaction.enabled
	and (hl)
	jp z,interactionDelete

	; Set visible if bit 7 of [relatedObj1.animParameter] is set
	ld l,Interaction.animParameter
	ld a,(hl)
	ld b,a
	and $80
	ret z

	; Animation number = [relatedObj1.animParameter]&0x7f
	ld a,b
	and $7f
	push hl
	ld h,d
	ld l,Interaction.var37
	cp (hl)
	jr z,+
	ld (hl),a
	call interactionSetAnimation
+
	pop hl
	call objectTakePosition
	jp objectSetVisible83


; ==============================================================================
; INTERACID_SYRUP
;
; Variables:
;   var37: Item being bought
;   var38: Set to 1 if Link can't purchase an item (because he has too many of it)
;   var3a: "Return value" from purchase script (if $ff, the purchase failed)
;   var3b: Object index of item that Link is holding
; ==============================================================================
interactionCode5f:
.ifdef ROM_AGES
	callab commonInteractions2.checkReloadShopItemTiles
.else
	call commonInteractions2.checkReloadShopItemTiles
.endif
	call @runState
	jp interactionAnimateAsNpc

@runState:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit

	ld l,Interaction.collisionRadiusY
	ld (hl),$12
	inc l
	ld (hl),$07

	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
.ifdef ROM_SEASONS
	call getThisRoomFlags
	and $40
	ld hl,mainScripts.syrupScript_notTradedMushroomYet
	jr z,+
.endif
	ld hl,mainScripts.syrupScript_spawnShopItems
+
	jr @setScriptAndGotoState2


; State 1: Waiting for Link to talk to her
@state1:
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	ret z

	xor a
	ld (de),a

	ld a,$81
	ld (wDisabledObjects),a

	ld a,(wLinkGrabState)
	or a
	jr z,@talkToSyrupWithoutItem

	; Get the object that Link is holding
	ld a,(w1Link.relatedObj2+1)
	ld h,a
.ifdef ROM_AGES
	ld e,Interaction.var3b
.else
	ld e,Interaction.var3c
.endif
	ld (de),a

	; Assume he's holding an INTERACID_SHOP_ITEM. Subids $07-$0c are for syrup's shop.
	ld l,Interaction.subid
	ld a,(hl)
	push af
	ld b,a
	sub $07

.ifdef ROM_AGES
	ld e,Interaction.var37
.else
	ld e,Interaction.var38
.endif
	ld (de),a

	; Check if Link has the rupees for it
	ld a,b
	ld hl,commonInteractions2.shopItemPrices
	rst_addAToHl
	ld a,(hl)
	call cpRupeeValue
.ifdef ROM_AGES
	ld (wShopHaveEnoughRupees),a
.else
	ld e,Interaction.var39
	ld (de),a
.endif
	ld ($cbad),a

	; Check the item type, see if Link is allowed to buy any more than he already has
	pop af
	cp $07
	jr z,@checkPotion
	cp $09
	jr z,@checkPotion

	cp $0b
	jr z,@checkBombchus

	ld a,(wNumGashaSeeds)
	jr @checkQuantity

@checkBombchus:
	ld a,(wNumBombchus)

@checkQuantity:
	; For bombchus and gasha seeds, amount caps at 99
	cp $99
	ld a,$01
	jr nc,@setCanPurchase
	jr @canPurchase

@checkPotion:
	ld a,TREASURE_POTION
	call checkTreasureObtained
	ld a,$01
	jr c,@setCanPurchase

@canPurchase:
	xor a

@setCanPurchase:
	; Set var38 to 1 if Link can't purchase the item because he has too much of it
.ifdef ROM_AGES
	ld e,Interaction.var38
.else
	ld e,Interaction.var3a
.endif
	ld (de),a

	ld hl,mainScripts.syrupScript_purchaseItem
	jr @setScriptAndGotoState2

@talkToSyrupWithoutItem:
	call commonInteractions2.shopkeeperCheckAllItemsBought
	jr z,@showWelcomeText

	ld hl,mainScripts.syrupScript_showClosedText
	jr @setScriptAndGotoState2

@showWelcomeText:
	ld hl,mainScripts.syrupScript_showWelcomeText

@setScriptAndGotoState2:
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	jp interactionSetScript


; State 2: running a script
@state2:
	call interactionRunScript
	ret nc

	; Script done

	xor a
	ld (wDisabledObjects),a

	; Check response from script (was purchase successful?)
.ifdef ROM_AGES
	ld e,Interaction.var3a
.else
	ld e,Interaction.var3b
.endif
	ld a,(de)
	or a
	jr z,@gotoState1 ; Skip below code if he was holding nothing to begin with

	; If purchase was successful, set the held item (INTERACID_SHOP_ITEM) to state
	; 3 (link obtains it)
	inc a
	ld c,$03
	jr nz,++

	; If purchase was not successful, set the held item to state 4 (return to display
	; area)
	ld c,$04
++
	xor a
	ld (de),a
.ifdef ROM_AGES
	ld e,Interaction.var3b
.else
	ld e,Interaction.var3c
.endif
	ld a,(de)
	ld h,a
	ld l,Interaction.state
	ld (hl),c
	call dropLinkHeldItem

@gotoState1:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret


; ==============================================================================
; INTERACID_LEVER
;
; subid:    Bit 7 set if this is the "child" object (the part that links the lever base to
;           the part Link is pulling); otherwise, bit 0 set if the lever is pulled upward.
; var03:    Nonzero if the "child" lever (part that extends) has already been created?
; var30:    Y position at which lever is fully retracted.
; var31:    Number of units to pull the lever before it's fully pulled.
; var32/33: Address of something in wram (wLever1PullDistance or wLever2PullDistance)
; var34:    Y offset of Link relative to lever when he's pulling it
; var35:    Nonzero if lever was pulled last frame.
; ==============================================================================
interactionCode61:
	ld e,Interaction.subid
	ld a,(de)
	rlca
	ld e,Interaction.state
	jp c,@updateLeverConnectionObject

	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call interactionInitGraphics
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr nz,@label_09_254

	; Create new INTERACID_LEVER, and set their relatedObj1's to each other.
	; This new "child" object will just be the graphic for the "extending" part.
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_LEVER
	ld l,Interaction.relatedObj1
	ld e,l
	ld a,Interaction.enabled
	ld (de),a
	ldi (hl),a
	inc e
	ld (hl),d
	ld a,h
	ld (de),a

	; Jump if new object's slot >= this object's slot
	cp d
	jr nc,@label_09_253

	; Swap the subids of the two objects to ensure that the "parent" has a lower slot
	; number?
	ld l,Interaction.subid
	ld e,l
	ld a,(de)
	ldi (hl),a ; [new.subid] = [this.subid]

	ld a,$80
	ld (de),a ; [this.subid] = $80
	inc (hl)  ; [new.var03] = $01

	jp objectCopyPosition

@label_09_253:
	ld l,Interaction.subid
	ld (hl),$80

@label_09_254:
	call interactionIncState

	; After above function call, h = d.
	ld l,Interaction.collisionRadiusY
	ld (hl),$05
	inc l
	ld (hl),$01

	; [var30] = [yh]
	ld l,Interaction.yh
	ld a,(hl)
	ld e,Interaction.var30
	ld (de),a

	; [var31] = y-offset of lever when fully extended.
	ld l,Interaction.subid
	ld a,(hl)
	and $30
	swap a
	ld bc,@leverLengths
	call addAToBc
	inc e
	ld a,(bc)
	ld (de),a

	; [var32/var33] = address of wLever1PullDistance or wLever2PullDistance
	ld bc,wLever1PullDistance
	bit 6,(hl) ; Check bit 6 of subid
	jr z,+
	inc bc
+
	inc e
	ld a,c
	ld (de),a
	inc e
	ld a,b
	ld (de),a

	; [subid] &= $01 (only indicates direction of lever now)
	ld a,(hl)
	and $01
	ld (hl),a

	; [var34] = Y offset of Link relative to lever when he's pulling it
	ld a,$0c
	jr z,+
	ld a,$f3
+
	inc e
	ld (de),a
	ld a,(hl)
	call interactionSetAnimation
	jp objectSetVisible83


; Which byte is read from here depends on bits 4-5 of subid.
@leverLengths:
	.db $08 $10 $20 $40


; Waiting for Link to grab
@state1:
	call objectPushLinkAwayOnCollision

	; Get the rough "direction value" toward link (rounded to a cardinal direction)
	call objectGetAngleTowardEnemyTarget
	add $14
	and $18
	swap a
	rlca
	ld c,a

	; Check that this direction matches the valid pulling direction and Link's facing
	; direction
	ld e,Interaction.subid
	ld a,(de)
	add a
	cp c
	ret nz
	ld a,(w1Link.direction)
	cp c
	ret nz

	; Allow to be grabbed
	jp objectAddToGrabbableObjectBuffer


; State 2: Link is grabbing this.
@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld a,$80
	ld (wLinkGrabState2),a

	; Calculate Link's y and x positions
	ld l,Interaction.xh
	ld a,(hl)
	ld (w1Link.xh),a
	ld l,Interaction.var34
	ld a,(hl)
	ld l,Interaction.yh
	add (hl)
	ld (w1Link.yh),a
	xor a
	dec l
	ld (hl),a
	ld (w1Link.y),a

	ld b,SPEED_40
	inc a
	jr @setSpeedAndAngle

@substate1:
	; Check animParameter of the "parent item" for the power bracelet?
	ld a,(w1ParentItem2.animParameter)
	or a
	jr nz,++
	ld e,Interaction.var35
	ld (de),a
	ret
++
	call @checkLeverFullyExtended
	ret nc

	; Not fully extended yet. Set Link's speed/angle to this lever's speed/angle
	ld l,Interaction.angle
	ld c,(hl)
	ld l,Interaction.speed
	ld b,(hl)
	call updateLinkPositionGivenVelocity

	; Update Lever's position based on Link's position.
	ld a,(w1Link.yh)
	ld h,d
	ld l,Interaction.var34
	sub (hl)
	ld l,Interaction.yh
	ld (hl),a

	; Take difference from lever's "base" position to get the number of pixels it's
	; been pulled.
	ld l,Interaction.var30
	sub (hl)
	call @updatePullOffset

	; Return if lever position hasn't changed.
	cp b
	ret z

	; Play moveblock sound if lever was not pulled last frame, and it is not fully
	; pulled.
	ld h,d
	ld l,Interaction.var35
	bit 0,(hl)
	ret nz
	inc (hl)
	bit 7,b
	ret nz

	ld a,SND_MOVEBLOCK
	jp playSound


; Lever just released?
@substate2:
@substate3:
	call interactionIncState
	ld l,Interaction.enabled
	res 1,(hl)
	ld b,SPEED_40
	xor a

@setSpeedAndAngle:
	ld l,Interaction.speed
	ld (hl),b

	; Calculate angle using subid (which has direction information)
	ld l,Interaction.subid
	xor (hl)
	swap a
	ld l,Interaction.angle
	ld (hl),a
	ret


; Lever retracting back to original position by itself.
@state3:
	call objectApplySpeed

	; Update lever pull offset
	ld e,Interaction.yh
	ld a,(de)
	ld b,a
	ld e,Interaction.var30
	ld a,(de)
	sub b
	call @updatePullOffset
	call @checkLeverFullyRetracted
	jr c,@makeGrabbable

	; Lever fully retracted.
	ld l,Interaction.state
	ld (hl),$01
	ld b,SPEED_40
	ld a,$01
	call @setSpeedAndAngle

@makeGrabbable:
	; State 1 doesn't do anything except make the lever grabbable, so just reuse it.
	jp @state1


; This part is almost entirely separate from the lever code above; this is a separate
; object that graphically connects the lever's base with the part Link is holding.
@updateLeverConnectionObject:
	ld a,(de)
	or a
	jr nz,@@state1

@@state0:
	call interactionInitGraphics
	call interactionIncState
	call objectSetVisible83

	; Copy parent's x position
	ld a,Object.xh
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(hl)
	ld (de),a

@@state1:
	; b = [relatedObj1.subid]*5 (either 0 or 5 as a base for the table below)
	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld a,(hl)
	add a
	add a
	add (hl)
	ld b,a

	; a = (number of pixels pulled)/16
	ld l,Interaction.yh
	ld a,(hl)
	ld l,Interaction.var30
	sub (hl)
	jr nc,+
	cpl
	inc a
+
	swap a
	and $07
	push af

	; Get Y offset for animation.
	add b
	ld bc,@animationYOffsets
	call addAToBc
	ld a,(bc)
	add (hl)
	ld e,Interaction.yh
	ld (de),a

	; Set animation. Animation $02 is just a 16-pixel high lever connection, and
	; animations $03-$06 each add another 16-pixel high connection to the chain.
	pop af
	add $02
	jp interactionSetAnimation

@animationYOffsets:
	.db $00 $08 $10 $18 $20 ; Lever facing down
	.db $00 $f8 $f0 $e8 $e0 ; Lever facing up

;;
; If the lever is fully extended, this also caps its position to the max value.
;
; @param[out]	cflag	nc if fully extended.
@checkLeverFullyExtended:
	ld e,Interaction.var31
	ld a,(de)
	ld h,d

	ld l,Interaction.subid
	bit 0,(hl)
	jr z,@posComparison

	cpl
	inc a

@negComparison:
	ld l,Interaction.var30
	add (hl)
	ld l,Interaction.yh
	cp (hl)
	ret c
	ld (hl),a
	ret

;;
; If the lever is fully retracted, this also caps its position to 0.
;
; @param[out]	cflag	nc if fully retracted.
@checkLeverFullyRetracted:
	xor a
	ld h,d
	ld l,Interaction.subid
	bit 0,(hl)
	jr z,@negComparison

@posComparison:
	ld l,Interaction.var30
	add (hl)
	ld b,a
	ld l,Interaction.yh
	ld a,(hl)
	cp b
	ret c
	ld (hl),b
	ret

;;
; @param	a	Offset of lever from its base (Value to write to
;			wLever1/2PullDistance before possible negation)
; @param	cflag	Set if lever is facing up
; @param[out]	a	Old value of pull distance
; @param[out]	b	New value of pull distance
@updatePullOffset:
	jr nc,++
	cpl
	inc a
++
	ld h,d
	ld l,Interaction.var31
	cp (hl)
	jr nz,++

	; Pulled lever all the way?
	ld h,a
	push hl
	ld a,SND_OPENCHEST
	call playSound

	; Set bit 7 of pull distance when fully pulled
	pop hl
	ld a,h
	or $80
	ld h,d
++
	; Read address in var32/var33; set new value to 'b' and return old value as 'a'.
	ld b,a
	inc l
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(hl)
	ld (hl),b
	ret


; ==============================================================================
; INTERACID_MAKU_CONFETTI
;
; This object uses component speed (instead of using one byte for speed value, two words
; are used, for Y/X speeds respectively).
;
; Variables:
;   var03:    If nonzero, this is an index for the confetti which determines position,
;             acceleration values? (If zero, this is the "spawner" for subsequent
;             confetti.)
;
; Variables for "spawner" / "parent" (var03 == 0, uses state 1):
;   counter1: Number of pieces of confetti spawned so far
;   var37:    Counter until next piece of confetti spawns
;
; Variables for actual pieces of confetti (var03 != 0, uses state 2):
;   var3a:    Counter until another sparkle is created
;   var3c/3d: Y acceleration?
;   var3e/3f: X acceleration?
; ==============================================================================
interactionCode62:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw makuConfetti_subid0
	.dw makuConfetti_subid1


; Subid 0: Flowers (in the present)
makuConfetti_subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr nz,+

	; var03 is zero; next state is state 1.
	jp @setDelayUntilNextConfettiSpawns
+
	; a *= 3 (assume hl still points to a's source)
	add a
	add (hl)

	; Set Y-pos, X-pos, Y-accel (var3c), X-accel (var3e)
	ld hl,@initialPositionsAndAccelerations-6
	rst_addDoubleIndex
	ld e,Interaction.yh
	ldh a,(<hCameraY)
	add (hl)
	inc hl
	ld (de),a
	inc e
	inc e
	ldh a,(<hCameraX)
	add (hl)
	inc hl
	ld (de),a
	ld e,Interaction.var3c
	call @copyAccelerationComponent
	call @copyAccelerationComponent

	; Increment state again; next state is state 2.
	ld h,d
	ld l,Interaction.state
	inc (hl)

	ld l,Interaction.var3a
	ld (hl),$10

	ld l,Interaction.direction
	ld (hl),$00
	call interactionInitGraphics
	jp objectSetVisible80


@copyAccelerationComponent:
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ret


; Data format:
;   b0: Y position
;   b1: X position
;   w2: Y-acceleration (var3c)
;   w3: X-acceleration (var3e)
@initialPositionsAndAccelerations:
	dbbww $e8, $38, $0018, $0018 ; $01 == [var03]
	dbbww $e8, $60, $0018, $0018 ; $02
	dbbww $e8, $10, $0010, $0010 ; $03
	dbbww $e8, $50, $0014, $0014 ; $04
	dbbww $e8, $20, $0018, $0018 ; $05


; State 1: this is the "spawner" for confetti, not actually drawn itself.
@state1:
	ld h,d
	ld l,Interaction.var37
	dec (hl)
	ret nz
	ld (hl),$01

	; Spawn a piece of confetti
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_MAKU_CONFETTI

	; [new.var03] = ++[this.counter1]
	ld e,Interaction.counter1
	ld a,(de)
	inc a
	ld (de),a
	ld l,Interaction.var03
	ld (hl),a

	; [new.counter2] = 180 (counter until it makes magic powder noise)
	ld l,Interaction.counter2
	ld (hl),180

	ld a,SND_MAGIC_POWDER
	call playSound

	; Delete self if 5 pieces of confetti have been spawned
	ld e,Interaction.counter1
	ld a,(de)
	cp $05
	jp z,interactionDelete

@setDelayUntilNextConfettiSpawns:
	ld e,Interaction.counter1
	ld a,(de)
	ld hl,@spawnDelayValues
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var37
	ld (de),a
	ret

@spawnDelayValues:
	.db $01 $32 $14 $1e $28 $1e


; State 2: This is an individual piece of confetti, falling down the screen.
@state2:
	; Play magic powder sound every 3 seconds
	call interactionDecCounter2
	jr nz,++
	ld (hl),180
	ld a,SND_MAGIC_POWDER
	call playSound
++
	; Make a sparkle every $18 frames
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	jr nz,++
	ld (hl),$18
	call @makeSparkle
++
	; Update Y/X position and speed
	ld hl,@yOffset
	ld e,Interaction.y
	call add16BitRefs
	call makuConfetti_updateSpeedY
	call makuConfetti_updateSpeedX
	call objectApplyComponentSpeed

	; Delete when off-screen
	ld e,Interaction.yh
	ld a,(de)
	cp $88
	jp c,++
	cp $d8
	jp c,interactionDelete
++
	; Invert Y acceleration when speedY > $100.
	ld h,d
	ld l,Interaction.speedY
	ld c,(hl)
	inc l
	ld b,(hl)
	bit 7,(hl)
	jr z,+
	call @negateBC
+
	ld hl,$0100
	call compareHlToBc
	cp $01
	jr z,+
	ld e,Interaction.var3c
	call @negateWordAtDE
+
	; Invert X acceleration when speedX > $200.
	ld h,d
	ld l,Interaction.speedX
	ld c,(hl)
	inc l
	ld b,(hl)
	bit 7,(hl)
	jr z,+
	call @negateBC
+
	ld hl,$0200
	call compareHlToBc
	cp $01
	jr z,+
	ld e,Interaction.var3e
	call @negateWordAtDE
+
	; Check whether to invert the animation direction (speed switches from positive to
	; negative or vice-versa).
	ld h,d
	ld l,Interaction.speedX+1
	bit 7,(hl)
	ld l,Interaction.direction
	ld a,(hl)
	jr z,+
	or a
	ret nz
	jr ++
+
	or a
	ret z
++
	xor $01
	ld (hl),a
	jp interactionSetAnimation


; Value added to y position each frame, in addition to speedY?
@yOffset:
	.dw $00c0

;;
; @param	bc	Speed
; @param[out]	bc	Inverted speed
@negateBC:
	xor a
	ld a,c
	cpl
	add $01
	ld c,a
	ld a,b
	cpl
	adc $00
	ld b,a
	ret

;;
; @param	de	Address of value to invert
@negateWordAtDE:
	xor a
	ld a,(de)
	cpl
	add $01
	ld (de),a
	inc e
	ld a,(de)
	cpl
	adc $00
	ld (de),a
	ret

@makeSparkle:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_SPARKLE
	inc l
	ld (hl),$02
	jp objectCopyPosition



; Subid 1: In the past.
makuConfetti_subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr nz,+

	; var03 is zero; next state is state 1.
	ld l,Interaction.counter2
	ld (hl),$0a
	jp @setDelayUntilNextConfettiSpawns
+
	dec a
	cp $06
	jr c,+
	sub $06
+
	ld hl,@initialPositions
	rst_addDoubleIndex

	; Set Y-pos, X-pos.
	ld e,Interaction.yh
	ldh a,(<hCameraY)
	add (hl)
	inc hl
	ld (de),a
	inc e
	inc e
	ldh a,(<hCameraX)
	add (hl)
	inc hl
	ld (de),a

	; Initialize speedY, speedX
	ld h,d
	ld l,Interaction.speedY
	ld b,$80
	ld c,$fd
	call @setSpeedComponent
	ld b,$00
	ld c,$04
	call @setSpeedComponent

	; Initialize speedZ; this is actually used as X acceleration.
	ld b,$f0
	ld c,$ff
	call @setSpeedComponent

	; Increment state again; next state is state 2.
	ld l,Interaction.state
	inc (hl)

	call interactionInitGraphics
	jp objectSetVisible80

@setSpeedComponent:
	ld (hl),b
	inc l
	ld (hl),c
	inc l
	ret

; Data format:
;   b0: Y position
;   b1: X position
@initialPositions:
	.db $80 $10 ; $01,$07 == [var03]
	.db $60 $00 ; $02,$08
	.db $80 $18 ; $03,$09
	.db $80 $48 ; $04,$0a
	.db $50 $00 ; $05,$0b
	.db $80 $10 ; $06,$0c


; State 1: this is the "spawner" for confetti, not actually drawn itself.
@state1:
	call interactionDecCounter2
	jr nz,+
	ld (hl),45
	ld a,SND_MAKU_TREE_PAST
	call playSound
+
	ld h,d
	ld l,Interaction.var37
	dec (hl)
	ret nz

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_MAKU_CONFETTI
	inc l
	ld (hl),$01 ; [new.subid] = $02

	; [new.var03] = ++[this.counter1]
	ld e,Interaction.counter1
	ld a,(de)
	inc a
	ld (de),a
	ld l,Interaction.var03
	ld (hl),a

	; Delete self if 12 pieces of confetti have been spawned
	cp 12
	jp z,interactionDelete

@setDelayUntilNextConfettiSpawns:
	ld e,Interaction.counter1
	ld a,(de)
	ld hl,@spawnDelayValues
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var37
	ld (de),a
	ret

@spawnDelayValues:
	.db $01 $32 $1e $0f $0f $0f $0f $0f
	.db $0f $0f $0f $14


; State 2: This is an individual piece of confetti, falling down the screen.
@state2:
	call makuConfetti_updateSpeedXUsingSpeedZ
	ld e,Interaction.speedX+1
	ld a,(de)
	bit 7,a
	jp nz,interactionDelete
	jp objectApplyComponentSpeed

makuConfetti_updateSpeedY:
	ld e,Interaction.speedY
	ld l,Interaction.var3c
	jr makuConfetti_add16BitRefs

makuConfetti_updateSpeedX:
	ld e,Interaction.speedX
	ld l,Interaction.var3e
	jr makuConfetti_add16BitRefs

makuConfetti_updateSpeedYUsingSpeedZ: ; Unused
	ld e,Interaction.speedY
	ld l,Interaction.speedZ
	jr makuConfetti_add16BitRefs

; Use speedZ as acceleration for speedX (since speedZ isn't used for anything else)
makuConfetti_updateSpeedXUsingSpeedZ:
	ld e,Interaction.speedX
	ld l,Interaction.speedZ

makuConfetti_add16BitRefs
	ld h,d
	call add16BitRefs
	ret


; ==============================================================================
; INTERACID_ACCESSORY
; ==============================================================================
interactionCode63:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

@state1:
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld l,Interaction.enabled
	ld a,(hl)
	or a
	jr z,@delete

	ld l,Interaction.var3b
	ld a,(hl)
	or a
	jr nz,@delete

	ld l,Interaction.visible
	bit 7,(hl)
	jp z,objectSetInvisible

	call objectSetVisible80
	ld bc,$f400
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr z,@takePositionWithOffset

	ld l,Interaction.animParameter
	ld a,(hl)
	push hl
	add a
	ld hl,@data
	rst_addDoubleIndex
	ld b,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld a,(hl)
	ld e,Interaction.visible
	ld (de),a
	inc hl

	; Set animation if it's changed
	ld e,Interaction.var3c
	ld a,(de)
	cp (hl)
	jr z,++
	ld a,(hl)
	ld (de),a
	push bc
	call interactionSetAnimation
	pop bc
++
	pop hl

@takePositionWithOffset:
	jp objectTakePositionWithOffset

@delete:
	jp interactionDelete


; Each row in this table is a set of values for one value of "relatedObj1.animParameter".
; This is only used when var03 is nonzero.
;
; Data format:
;   b0: Y offset
;   b1: X offset
;   b2: value for Interaction.visible
;   b3: Animation index
@data:
	.db $00 $f3 $80 $03
	.db $f3 $00 $80 $03
	.db $00 $0d $80 $03
	.db $f4 $ff $80 $03
	.db $f4 $00 $80 $03
	.db $f5 $00 $83 $03
	.db $f5 $00 $83 $0a
	.db $02 $04 $80 $00
	.db $02 $05 $80 $00


; ==============================================================================
; INTERACID_RAFTWRECK_CUTSCENE_HELPER
; ==============================================================================
interactionCode64:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05

@initSubid00:
@initSubid01:
@initSubid02:
	call interactionInitGraphics
	call objectSetVisible82

@loadAngleAndCounterPreset:
	ld b,$03
	callab agesInteractionsBank0a.loadAngleAndCounterPreset
	ld a,b
	or a
	ret

@initSubid03:
@initSubid04:
@initSubid05:
	ret

;;
; Reads from a table, gets a position, sets counter1, ...?
;
; @param	counter2	Index from table to read
; @param	hl		Table to read from
; @param[out]	bc		Position for a new object?
; @param[out]	e		Subid for a new object?
@func_73fd:
	ld e,Interaction.counter2
	ld a,(de)
	add a
	rst_addDoubleIndex
	ld b,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld a,(hl)
	ld h,d
	ld l,Interaction.counter1
	ld (hl),a
	ret

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

@runSubid00:
@runSubid01:
@runSubid02:
	call interactionAnimate
	call objectApplySpeed
	cp $f0
	jp nc,interactionDelete
	call interactionDecCounter1
	call z,@loadAngleAndCounterPreset
	jp z,interactionDelete
	ret

@runSubid03:
@runSubid04:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret
+
	ld hl,@subid3Objects
	ld e,Interaction.subid
	ld a,(de)
	cp $03
	jr z,+
	ld hl,@subid4Objects
+
	call @func_73fd

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_RAFTWRECK_CUTSCENE_HELPER
	inc l
	ld (hl),e
	inc l
	ld e,Interaction.counter2
	ld a,(de)
	ld (hl),a
	ld e,Interaction.subid
	ld a,(de)
	cp $03
	ld a,SPEED_200
	jr z,+
	ld a,SPEED_300
+
	ld l,Interaction.speed
	ld (hl),a
	call interactionHSetPosition

	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jp z,interactionDelete
	inc l
	inc (hl)
	ret


; Tables of objects to spawn for the "wind" parts of the cutscene.
;   b0: Y position
;   b1: X position
;   b2: subID of this interaction type to spawn
;   b3: counter1
@subid3Objects:
	.db $00 $b8 $00 $14
	.db $10 $a8 $00 $14
	.db $40 $a8 $00 $14
	.db $48 $b8 $01 $14
	.db $20 $a8 $00 $00

@subid4Objects:
	.db $20 $b8 $00 $10
	.db $40 $a8 $00 $14
	.db $10 $b0 $01 $10
	.db $48 $b8 $00 $14
	.db $08 $b0 $01 $10
	.db $50 $a8 $00 $14
	.db $f0 $b0 $00 $10
	.db $08 $b8 $02 $10
	.db $48 $b8 $00 $14
	.db $08 $b0 $01 $10
	.db $50 $a8 $00 $14
	.db $18 $b0 $01 $10
	.db $38 $b8 $02 $10
	.db $58 $a8 $00 $14
	.db $28 $b0 $01 $10
	.db $00 $a8 $00 $00

@runSubid05:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret
+
	ld hl,@subid5Objects
	call @func_73fd

	; Create lightning
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_LIGHTNING
	inc l
	ld (hl),e
	inc l
	inc (hl)
	ld l,Part.yh
	ld (hl),b
	ld l,Part.xh
	ld (hl),c

	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,+
	inc l
	inc (hl)
	ret
+
	; Signal to INTERACID_RAFTWRECK_CUTSCENE that the cutscene is done
	ld a,$03
	ld (wTmpcfc0.genericCutscene.state),a
	jp interactionDelete


; Tables of lightning objects to spawn in the final part of the cutscene.
;   b0: Y position
;   b1: X position
;   b2: subID of this interaction type to spawn
;   b3: counter1
@subid5Objects:
	.db $28 $28 $01 $28
	.db $58 $38 $01 $5a
	.db $40 $50 $01 $00


; ==============================================================================
; INTERACID_COMEDIAN
;
; Variables: (these are only used in scripts / bank 15 functions))
;   var37: base animation index ($00 for no mustache, $04 for mustache)
;   var3e: animation index (to be added to var37)
; ==============================================================================
interactionCode65:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @loadScriptAndInitGraphics
	call interactionRunScript
	call interactionRunScript
	jp interactionAnimateAsNpc

@state1:
	call interactionRunScript
	jp c,interactionDelete
	callab scriptHelp.comedian_turnToFaceLink
	jp interactionAnimateAsNpc


@unusedFunc_7528:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,>TX_0b00
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
	.dw mainScripts.comedianScript


; ==============================================================================
; INTERACID_GORON
;
; Variables:
;   var3f: Nonzero when "napping" (link is far away)
; ==============================================================================
interactionCode66:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw goronSubid00
	.dw goronSubid01
	.dw goronSubid02
	.dw goronSubid03
	.dw goronSubid04
	.dw goronSubid05
	.dw goronSubid06
	.dw goronSubid07
	.dw goronSubid08
	.dw goronSubid09
	.dw goronSubid0a
	.dw goronSubid0b
	.dw goronSubid0c
	.dw goronSubid0d
	.dw goronSubid0e
	.dw goronSubid0f
.ifndef REGION_JP
	.dw goronSubid10
.endif


; Graceful goron
goronSubid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4


; State 0: Initialization
@state0:
	call goron_initGraphicsAndIncState

	; Set palette (red/blue for past/present)
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	ld a,$01
	jr z,+
	ld a,$02
+
	ld e,Interaction.oamFlags
	ld (de),a

	; Load goron or subrosian dancers
	ld hl,objectData.goronDancers
	call checkIsLinkedGame
	jr z,@loadDancers
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	jr z,@loadDancers
	ld hl,objectData.subrosianDancers
@loadDancers:
	call parseGivenObjectData

	ld b,wTmpcfc0.goronDance.dataEnd - wTmpcfc0.goronDance
	ld hl,wTmpcfc0.goronDance
	call clearMemory

	ld a,$02
	ld (wTmpcfc0.goronDance.danceAnimation),a

	xor a
	ld hl,goronDanceScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript


; State 1: waiting for script to end as a signal to start the dance minigame
@state1:
	call interactionRunScript
	jp c,@scriptDone
	jp npcFaceLinkAndAnimate

@scriptDone:
	; Dance begins when script ends
	ld b,$0a
	callab agesInteractionsBank08.shootingGallery_initializeGameRounds

	ld a,DIR_DOWN
	ld (wTmpcfc0.goronDance.danceAnimation),a
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),30


; State 2: demonstrating dance sequence
@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state2Substate0
	.dw @state2Substate1
	.dw @state2Substate2
	.dw @state2Substate3
	.dw @state2Substate4

; Waiting to begin round
@state2Substate0:
	call interactionDecCounter1
	jp nz,@pushLinkAway

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),90
	ld a,SND_WHISTLE
	call playSound
	call goronDance_initNextRound

@state2Substate1:
	call interactionDecCounter1
	jp nz,@pushLinkAway
	call interactionIncSubstate
	jr @nextMove


; Waiting until doing the next "beat" of the dance
@state2Substate2:
	call interactionDecCounter1
	jr nz,@pushLinkAway

	call goronDance_incBeat
@nextMove:
	call goronDance_getNextMove
	jr nz,@finishedDemonstration

	call goronDance_updateConsecutiveBPressCounter
	call goronDance_updateGracefulGoronAnimation
	jr z,@jump

	call goronDance_playMoveSound
	ld h,d
	ld l,Interaction.counter1
	ld (hl),20

@pushLinkAway:
	jp interactionPushLinkAwayAndUpdateDrawPriority

@jump:
	; Jump after 5 consecutive B presses
	ld h,d
	ld l,Interaction.substate
	ld (hl),$03

	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.speedZ
	ld (hl),<(-$200)
	inc hl
	ld (hl),>(-$200)

	ld l,Interaction.counter1
	ld (hl),20
	ld a,SND_GORON_DANCE_B
	call playSound
	jp interactionPushLinkAwayAndUpdateDrawPriority


@finishedDemonstration:
	ld h,d
	ld l,Interaction.substate
	ld (hl),$04
	ld l,Interaction.counter1
	ld (hl),60
	ld a,DIR_DOWN
	call interactionSetAnimation
	jr @pushLinkAway


; Waiting to land if he jumped
@state2Substate3:
	call interactionDecCounter1
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,@@landed

	ld h,d
	ld l,Interaction.speedZ+1
	ldd a,(hl)
	or (hl)
	jr nz,@pushLinkAway

	ld a,DIR_DOWN
	ld (wTmpcfc0.goronDance.danceAnimation),a
	call interactionSetAnimation
	jr @pushLinkAway

@@landed:
	ld h,d
	ld l,Interaction.substate
	ld (hl),$02
	jp @state2Substate2


; Counting down until going to state 3 (where Link replicates the dance)
@state2Substate4:
	call interactionDecCounter1
	jr nz,@pushLinkAway
	call interactionIncState
	ld l,Interaction.substate
	ld (hl),$00
	jr @pushLinkAway


; State 3: Link playing back dance sequence
@state3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state3Substate0
	.dw @state3Substate1
	.dw @state3Substate2
	.dw @state3Substate3
	.dw @state3Substate4

@state3Substate0:
	call interactionIncSubstate
	call goronDance_clearDanceVariables
	ld a,SND_WHISTLE
	call playSound

	ld a,DIR_DOWN
	ld (wTmpcfc0.goronDance.danceAnimation),a

	call goronDance_turnLinkToDirection
	jp @pushLinkAway

@state3Substate1:
	call goronDance_updateFrameCounter
	call goronDance_checkLinkInput
	jp @pushLinkAway

@state3Substate2:
	call goronDance_updateFrameCounter
	ld a,(wTmpcfc0.goronDance.linkJumping)
	or a
	jp nz,@pushLinkAway

	ld h,d
	ld l,Interaction.substate
	dec (hl)
	jp @pushLinkAway

@state3Substate3:
	call interactionDecCounter1
	jp nz,@pushLinkAway
	ld a,(wTmpcfc0.goronDance.roundIndex)
	cp $08
	jr z,@endDanceAndUpdateNpc

@nextRoundAndUpdateNpc:
	call @nextRound
	jp @pushLinkAway

@endDanceAndUpdateNpc:
	call @endDance
	jp @pushLinkAway


; Messed up?
@state3Substate4:
	ld e,Interaction.var3f
	ld a,(de)
	rst_jumpTable
	.dw @@initializeScript
	.dw @@runScript

@@initializeScript:
	call interactionDecCounter1
	jp nz,@pushLinkAway
	ld a,$01
	ld (wTmpcfc0.goronDance.cfd9),a
	ld hl,wTmpcfc0.goronDance.roundIndex
	inc (hl)
	ld hl,wTmpcfc0.goronDance.numFailedRounds
	inc (hl)
	ld a,(hl)
	cp $03
	jr z,++

	ld a,(wTmpcfc0.goronDance.roundIndex)
	cp $08
	jr z,@endDanceAndUpdateNpc
++
	ld h,d
	ld l,Interaction.var3f
	inc (hl)
	ld a,$01
	ld hl,goronDanceScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

@@runScript:
	call interactionRunScript
	jp nc,@pushLinkAway
	jp @nextRoundAndUpdateNpc

@nextRound:
	; Go to state 2 (begin next round)
	ld h,d
	ld l,Interaction.state
	ld (hl),$02
	inc l
	ld (hl),$00
	ld l,Interaction.counter1
	ld (hl),30
	jr @resetDanceAnimationToDown

@endDance:
	; Go to state 4 (finished the whole minigame)
	ld h,d
	ld l,Interaction.state
	ld (hl),$04
	inc l
	ld (hl),$00
	ld l,Interaction.counter1
	ld (hl),60

@resetDanceAnimationToDown:
	xor a
	ld (wTmpcfc0.goronDance.linkStartedDance),a
	ld a,DIR_DOWN
	ld (wTmpcfc0.goronDance.danceAnimation),a
	jp goronDance_turnLinkToDirection


; State 4: dance ended successfully
@state4:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state4Substate0
	.dw @state4Substate1

@state4Substate0:
	call interactionIncSubstate
	xor a
	ld (wTmpcfc0.goronDance.linkStartedDance),a

	; Run script to give prize
	ld a,$02
	ld hl,goronDanceScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

@state4Substate1:
	call interactionRunScript
	jp nc,@pushLinkAway
	jp @pushLinkAway



; Goron support dancer. Code also used by subrosian subid $01?
goronSubid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	call goron_loadScript

@faceDown:
	ld a,DIR_DOWN
	call interactionSetAnimation


; State 1: just running the script
@state1:
	ld a,(wTmpcfc0.goronDance.linkStartedDance)
	or a
	jr nz,@gotoState2
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate

@gotoState2:
	call interactionIncState
	jr @updateAnimation


; State 2: doing whatever animation the dance dictates
@state2:
	ld a,(wTmpcfc0.goronDance.linkStartedDance)
	or a
	jr z,@gotoState1

@updateAnimation:
	; Copy Link's z position (for when he jumps)
	ld hl,w1Link.z
	ld e,Interaction.z
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	; Set animation based on whatever Link or the graceful goron is doing
	ld a,(wTmpcfc0.goronDance.danceAnimation)
	call interactionSetAnimation
	jp goronSubid00@pushLinkAway

@gotoState1:
	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	jp @faceDown


; A "fake" goron object that manages jumping in the dancing minigame?
goronSubid02:
	call checkInteractionState
	jr nz,@state1

@state0:
	call objectSetInvisible
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.speedZ
	ld (hl),<(-$200)
	inc hl
	ld (hl),>(-$200)

	ld l,Interaction.counter1
	ld (hl),20

	ld hl,w1Link.yh
	call objectTakePosition

	ld a,DIR_UP
	ld (wTmpcfc0.goronDance.danceAnimation),a
	call goronDance_turnLinkToDirection

	ld a,SND_GORON_DANCE_B
	call playSound

@state1:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,@landed

	ld hl,w1Link.yh
	call objectCopyPosition
	ld h,d
	ld l,Interaction.speedZ+1
	ldd a,(hl)
	or (hl)
	ret nz

	ld a,DIR_DOWN
	jp goronDance_turnLinkToDirection

@landed:
	ld hl,w1Link.yh
	call objectCopyPosition
	xor a
	ld (wTmpcfc0.goronDance.linkJumping),a
	jp interactionDelete


; Subid $03: Cutscene where goron appears after beating d5; the guy who digs a new tunnel.
; Subid $04: Goron pacing back and forth, worried about elder.
goronSubid03:
goronSubid04:
	call checkInteractionState
	jr nz,@state1

@state0:
	call goron_loadScriptAndInitGraphics
	call interactionRunScript
@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc


; An NPC in the past cave near the elder? var03 ranges from 0-5.
goronSubid05:
	call checkInteractionState
	jr nz,@state1

@state0:
	call goron_loadScriptFromTableAndInitGraphics
	call interactionRunScript
@state1:
	jr goron_runScriptAndDeleteWhenFinished


; NPC trying to break the elder out of the rock.
goronSubid06:
	call checkInteractionState
	jr nz,@state1

@state0:
	call goron_loadScriptFromTableAndInitGraphics
	ld l,Interaction.var3e
	ld (hl),$0a
	ld e,Interaction.var03
	ld a,(de)

.ifdef REGION_JP
	cp $01
	jr nz,++
.else
	or a
	jr nz,+
	ld (wTmpcfc0.goronCutscenes.elderVar_cfdd),a
	jr ++
+
.endif

	ld b,wTmpcfc0.goronCutscenes.dataEnd - wTmpcfc0.goronCutscenes
	ld hl,wTmpcfc0.goronCutscenes
	call clearMemory
++
	call interactionRunScript
@state1:
	jr goron_runScriptAndDeleteWhenFinished


; Various NPCs...
goronSubid07:
goronSubid08:
goronSubid0a:
goronSubid0c:
goronSubid0d:
goronSubid0e:
goronSubid10:
	call checkInteractionState
	jr nz,goron_runScriptAndDeleteWhenFinished

	; State 0 (Initialize)
	call goron_loadScriptAndInitGraphics
	call interactionRunScript

goron_runScriptAndDeleteWhenFinished:
	call interactionRunScript
	jp c,interactionDelete

goron_faceLinkAndAnimateIfNotNapping:
	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	jp interactionAnimateAsNpc


; Target carts gorons; var03 = 0 or 1 for gorons on left and right.
goronSubid09:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr nz,@rightGuy

@leftGuy:
	call goron_loadScriptFromTableAndInitGraphics
	xor a
	ld (wTmpcfc0.targetCarts.cfdf),a
	ld (wTmpcfc0.targetCarts.beginGameTrigger),a

	; Reload crystals in first room if the game is in progress
	call getThisRoomFlags
	bit 7,(hl)
	jr z,++
	callab scriptHelp.goron_targetCarts_reloadCrystalsInFirstRoom
++
	call interactionRunScript
	jr @state1

@rightGuy:
	call goron_loadScriptFromTableAndInitGraphics
	call interactionRunScript
	jr @state1

@state1:
	jr goron_runScriptAndDeleteWhenFinished


; Goron running the big bang game
goronSubid0b:
	call checkInteractionState
	jr nz,@state1

@state0:
	call goron_loadScriptFromTableAndInitGraphics
	call interactionRunScript
@state1:
	call interactionRunScript
	jp c,interactionDelete
	ld e,Interaction.var3e
	ld a,(de)
	or a
	ret nz
	jr goron_faceLinkAndAnimateIfNotNapping


; Linked NPC telling you the biggoron secret.
goronSubid0f:
	call checkInteractionState
	jr nz,@state1

@state0:
	call goron_initGraphicsAndIncState
	ld l,Interaction.var3f
	ld (hl),$08
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	call interactionRunScript
@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate

;;
goronDance_updateFrameCounter:
	ld a,(wTmpcfc0.goronDance.linkStartedDance)
	or a
	ret z
	ld hl,wTmpcfc0.goronDance.frameCounter
	jp incHlRef16WithCap

;;
goronDance_initNextRound:
	ld a,(wTmpcfc0.goronDance.remainingRounds)
	or a
	jr z,goronDance_clearDanceVariables
	callab agesInteractionsBank08.shootingGallery_getNextTargetLayout

;;
goronDance_clearDanceVariables:
	xor a
	ld (wTmpcfc0.goronDance.linkJumping),a
	ld (wTmpcfc0.goronDance.linkStartedDance),a
	ld (wTmpcfc0.goronDance.frameCounter),a
	ld (wTmpcfc0.goronDance.frameCounter+1),a
	ld (wTmpcfc0.goronDance.currentMove),a
	ld (wTmpcfc0.goronDance.consecutiveBPressCounter),a
	ld (wTmpcfc0.goronDance.cfd9),a
	ld (wTmpcfc0.goronDance.beat),a
	ret

;;
; Waits for input from Link, checks for round failure conditions, updates link and goron
; animations when input is good, etc.
goronDance_checkLinkInput:
	call goronDance_getNextMove
	cp $00
	jr z,@rest

	call goronDance_checkTooLateToInput
	jr z,@tooLate

	ld a,(wGameKeysJustPressed)
	and (BTN_A | BTN_B)
	ret z

	ld b,a
	ld (wTmpcfc0.goronDance.linkStartedDance),a
	ld a,(wTmpcfc0.goronDance.currentMove)
	cp b
	jr nz,@wrongMove

	; Check if too early
	call goronDance_checkInputNotTooEarlyOrLate
	jr z,@madeMistake
	jp @doDanceMove

@rest:
	call goronDance_checkExactInputTimePassed
	jr z,@doDanceMove
	ld a,(wGameKeysJustPressed)
	and $03
	jr nz,@wrongMove
	ret

@tooLate:
	ld a,$01
	ld (wTmpcfc0.goronDance.failureType),a
	jr @madeMistake

@wrongMove:
	ld a,$02
	ld (wTmpcfc0.goronDance.failureType),a

@madeMistake:
	ld h,d
	ld l,Interaction.substate
	ld (hl),$04
	ld l,Interaction.var3f
	ld (hl),$00
	ld l,Interaction.counter1
	ld (hl),30

	ld a,SND_ERROR
	call playSound

	ld a,LINK_ANIM_MODE_COLLAPSED
	ld (wcc50),a

	call checkIsLinkedGame
	jr z,@gorons
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	jr z,@gorons

@subrosians:
	ld a,$02
	ld (wTmpcfc0.goronDance.danceAnimation),a
	ret
@gorons:
	ld a,$04
	ld (wTmpcfc0.goronDance.danceAnimation),a
	ret

@doDanceMove:
	call goronDance_updateConsecutiveBPressCounter
	call goronDance_updateLinkAndBackupDancerAnimation
	jr z,@jump

	call goronDance_playMoveSound
	call goronDance_incBeat
	call goronDance_getNextMove
	jr nz,@roundFinished
	ret

@jump:
	call goronDance_incBeat
	call goronDance_getNextMove
	call getFreeInteractionSlot
	ret nz

	; Spawn a goron with subid $02? (A "fake" object that manages a jump?)
	ld (hl),INTERACID_GORON
	inc l
	ld (hl),$02
	ld a,$01
	ld (wTmpcfc0.goronDance.linkJumping),a
	jp interactionIncSubstate

@roundFinished:
	xor a
	ld (wTmpcfc0.goronDance.cfd9),a
	ld hl,wTmpcfc0.goronDance.roundIndex
	inc (hl)

	ld h,d
	ld l,Interaction.substate
	ld (hl),$03
	ld l,Interaction.counter1
	ld (hl),30
	ret

;;
; @param[out]	zflag	z if too early or too late
goronDance_checkInputNotTooEarlyOrLate:
	call goronDance_getCurrentAndNeededFrameCounts

	; Add 8 to hl, 8 to bc (the "expected" moment to press the button?)
	ld a,$08
	rst_addAToHl
	ld a,$08
	call addAToBc

	; Subtract 8 from hl (check earliest possible frame?)
	push bc
	ld b,$ff
	ld c,$f8
	add hl,bc
	pop bc

	call compareHlToBc
	cp $01
	jr z,@tooEarly

	; Add $10 to hl (check latest possible frame?)
	ld a,$10
	rst_addAToHl
	call compareHlToBc
	cp $ff
	jr z,@tooLate
	ret

@tooEarly:
	ld a,$00
	ld (wTmpcfc0.goronDance.failureType),a
	ret

@tooLate:
	ld a,$01
	ld (wTmpcfc0.goronDance.failureType),a
	ret

;;
; @param[out]	zflag	z the window for input this beat has passed.
goronDance_checkTooLateToInput:
	call goronDance_getCurrentAndNeededFrameCounts
	ld a,$08
	rst_addAToHl
	jr ++

;;
; @param[out]	zflag	z if the exact expected time for the input has passed.
goronDance_checkExactInputTimePassed:
	call goronDance_getCurrentAndNeededFrameCounts
++
	call compareHlToBc
	cp $ff
	ret

;;
; @param[out]	bc	Current frame count
; @param[out]	hl	Needed frame count? (First OK frame to press button?)
goronDance_getCurrentAndNeededFrameCounts:
	; hl = [wTmpcfc0.goronDance.beat] * 20
	ld a,(wTmpcfc0.goronDance.beat)
	push af
	call multiplyABy4
	ld l,c
	ld h,b
	pop af
	call multiplyABy16
	add hl,bc

	ld a,(wTmpcfc0.goronDance.frameCounter)
	ld c,a
	ld a,(wTmpcfc0.goronDance.frameCounter+1)
	ld b,a
	ret

;;
goronDance_playMoveSound:
	ld a,(wTmpcfc0.goronDance.currentMove)
	bit 7,a
	ret nz
	cp $00
	ret z

	cp $02
	jr z,++
	ld a,SND_DING
	jp playSound
++
	ld a,SND_GORON_DANCE_B
	jp playSound

;;
goronDance_incBeat:
	ld hl,wTmpcfc0.goronDance.beat
	inc (hl)
	ret

;;
; Get the next dance move, based on "danceLevel", "dancePattern", and "beat".
;
; @param[out]	zflag	nz if the data ran out.
goronDance_getNextMove:
	ld a,(wTmpcfc0.goronDance.danceLevel)
	ld hl,goronDance_sequenceData
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wTmpcfc0.goronDance.dancePattern)
	swap a
	ld b,a
	ld a,(wTmpcfc0.goronDance.beat)
	add b
	rst_addAToHl
	ld a,(hl)
	ld (wTmpcfc0.goronDance.currentMove),a
	bit 7,a
	ret

;;
goronDance_updateConsecutiveBPressCounter:
	ld hl,wTmpcfc0.goronDance.consecutiveBPressCounter
	ld a,(wTmpcfc0.goronDance.currentMove)
	cp $02
	jr z,+
	ld (hl),$00
	ret
+
	inc (hl)
	ret

;;
; @param[out]	zflag	z if Link and dancers should jump
goronDance_updateLinkAndBackupDancerAnimation:
	call goronDance_updateBackupDancerAnimation
	ld a,(wTmpcfc0.goronDance.currentMove)
	cp $01
	jr nz,@bButton

@aButton:
	ld a,LINK_ANIM_MODE_DANCELEFT
	ld (wcc50),a
	or d
	ret

@bButton:
	ld a,(wTmpcfc0.goronDance.consecutiveBPressCounter)
	ld hl,goronDance_linkBButtonAnimations
	rst_addAToHl

	; Should they jump?
	ld a,(hl)
	cp $50
	ret z

	cp $04
	jr nz,goronDance_turnLinkToDirection

	ld a,LINK_ANIM_MODE_GETITEM1HAND
	ld (wcc50),a
	or d
	ret

;;
; @param	a	Direction
goronDance_turnLinkToDirection:
	ld hl,w1Link.direction
	ld (hl),a
	ld a,LINK_ANIM_MODE_WALK
	ld (wcc50),a
	or d
	ret


; Link's direction values for consecutive B presses.
; $04 marks a particular animation, and $50 marks that he should jump.
goronDance_linkBButtonAnimations:
	.db $02 $03 $01 $04 $03 $50


;;
; @param[out]	zflag	z if they should jump
goronDance_updateBackupDancerAnimation:
	call checkIsLinkedGame
	jr z,@gorons
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	jr z,@gorons

@subrosians:
	ld a,(wTmpcfc0.goronDance.currentMove)
	cp $01
	jr nz,@subrosianBButton

	; A button
	ld a,$06
	jr @setDanceAnimation

@subrosianBButton:
	ld a,(wTmpcfc0.goronDance.consecutiveBPressCounter)
	ld hl,goronDance_subrosianBAnimations
	rst_addAToHl
	ld a,(hl)
	cp $50
	ret z
	ld (wTmpcfc0.goronDance.danceAnimation),a
	ret

@gorons:
	ld a,(wTmpcfc0.goronDance.currentMove)
	cp $01
	jr nz,@goronBButton

	; A button
	ld a,$06
	jr @setDanceAnimation

@goronBButton:
	ld a,(wTmpcfc0.goronDance.consecutiveBPressCounter)
	ld hl,goronDance_goronBAnimations
	rst_addAToHl
	ld a,(hl)
	cp $50
	ret z

@setDanceAnimation:
	ld (wTmpcfc0.goronDance.danceAnimation),a
	ret

goronDance_goronBAnimations:
	.db $02 $03 $04 $01 $00 $50

goronDance_subrosianBAnimations:
	.db $02 $03 $01 $03 $00 $50


;;
; @param[out]	zflag	z if the graceful goron should jump (5 consecutive B presses)
goronDance_updateGracefulGoronAnimation:
	ld a,(wTmpcfc0.goronDance.currentMove)
	cp $01
	jr nz,@bButton

	; A button
	ld a,$06
	jr @setAnimation

@bButton:
	ld a,(wTmpcfc0.goronDance.consecutiveBPressCounter)
	ld hl,goronDance_goronBAnimations
	rst_addAToHl
	ld a,(hl)
	cp $50
	ret z

@setAnimation:
	call interactionSetAnimation
	or d
	ret


; This holds the patterns for the various levels of the goron dance.
goronDance_sequenceData:
	.dw @platinum
	.dw @gold
	.dw @silver
	.dw @bronze

; Each row represents one possible dance pattern.
;   $00 means "rest";
;   $01 means "A";
;   $02 means "B";
;   $ff means "End".

@platinum:
	.db $02 $02 $02 $01 $00 $00 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $01 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $00 $02 $02 $01 $00 $02 $00 $01 $00 $01 $ff $00 $00
	.db $02 $00 $02 $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $00 $02 $01 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $00 $02 $02 $02 $00 $02 $02 $02 $02 $02 $01 $01 $ff
	.db $02 $02 $02 $01 $00 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $00 $01 $00 $02 $01 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $01 $00 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $02 $01 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00

@gold:
	.db $02 $01 $02 $00 $00 $02 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $01 $00 $02 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $00 $02 $01 $02 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $02 $00 $02 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $00 $02 $01 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $02 $00 $02 $01 $02 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $00 $02 $02 $02 $00 $02 $02 $02 $01 $02 $02 $01 $ff
	.db $02 $02 $01 $00 $02 $01 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $00 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00

@silver:
	.db $02 $02 $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $00 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $00 $02 $01 $02 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $02 $01 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00

@bronze:
	.db $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $00 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $00 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $02 $01 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $02 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00

;;
goron_initGraphicsAndIncState:
	call goron_initGraphics
	jp interactionIncState

;;
goron_loadScriptAndInitGraphics:
	call goron_initGraphics
	jr goron_loadScript

;;
goron_loadScriptFromTableAndInitGraphics:
	call goron_initGraphics
	jr goron_loadScriptFromTable

;;
goron_initGraphics:
	call interactionLoadExtraGraphics
	jp interactionInitGraphics

;;
goron_loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,goron_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

;;
; Load a script based on both subid and var03.
goron_loadScriptFromTable:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,goron_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	inc e
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

goron_scriptTable:
	.dw mainScripts.stubScript
	.dw mainScripts.goron_subid01Script
	.dw mainScripts.stubScript
	.dw mainScripts.goron_subid03Script
	.dw mainScripts.goron_subid04Script
	.dw @subid05ScriptTable
	.dw @subid06ScriptTable
	.dw mainScripts.goron_subid07Script
	.dw mainScripts.goron_subid08Script
	.dw @subid09ScriptTable
	.dw mainScripts.goron_subid0aScript
	.dw @subid0bScriptTable
	.dw mainScripts.goron_subid0cScript
	.dw mainScripts.goron_subid0dScript
	.dw mainScripts.goron_subid0eScript
.ifndef REGION_JP
	.dw mainScripts.stubScript
	.dw mainScripts.goron_subid10Script
.endif

@subid05ScriptTable:
	.dw mainScripts.goron_subid05Script_A
	.dw mainScripts.goron_subid05Script_A
	.dw mainScripts.goron_subid05Script_A
	.dw mainScripts.goron_subid05Script_B
	.dw mainScripts.goron_subid05Script_B
	.dw mainScripts.goron_subid05Script_B

@subid06ScriptTable:
	.dw mainScripts.goron_subid06Script_A
	.dw mainScripts.goron_subid06Script_B

@subid09ScriptTable:
	.dw mainScripts.goron_subid09Script_A
	.dw mainScripts.goron_subid09Script_B

@subid0bScriptTable:
	.dw mainScripts.goron_subid0bScript
	.dw mainScripts.goron_subid0bScript


goronDanceScriptTable:
	.dw mainScripts.goron_subid00Script
	.dw mainScripts.goronDanceScript_failedRound
	.dw mainScripts.goronDanceScript_givePrize

.ends
