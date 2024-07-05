; ==================================================================================================
; INTERAC_PAST_GUY
; ==================================================================================================
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
	ld hl,wGroup4RoomFlags+$fc
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
