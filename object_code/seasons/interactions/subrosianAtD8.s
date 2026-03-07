; ==================================================================================================
; INTERAC_SUBROSIAN_AT_VOLCANO
; ==================================================================================================
interactionCode55:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw subrosianAtD8_subid0
	.dw subrosianAtD8_subid1

subrosianAtD8_subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call subrosianAtD8_getNumEssences
	cp $07
	jp c,interactionDelete

	call interactionInitGraphics
	ld hl,mainScripts.subrosianAtD8Script
	call interactionSetScript

	ld a,$06
	call objectSetCollideRadius

	ld l,Interaction.counter1
	ld (hl),60
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList

	call getThisRoomFlags
	and $40
	ld a,$02
	jr nz,+
	dec a
+
	ld e,Interaction.state
	ld (de),a
	jp objectSetVisiblec2

; Waiting for Link to throw bomb in
@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	call interactionAnimate
	call objectPreventLinkFromPassing
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	jr nz,++

	call interactionDecCounter1
	ret nz
	ld l,Interaction.substate
	inc (hl)
	call objectSetVisiblec2
	ld hl,mainScripts.subrosianAtD8Script_tossItemIntoHole
	jp interactionSetScript
++
	xor a
	ld (de),a
	ld bc,TX_3c00
	jp showText

@substate1:
	call objectPreventLinkFromPassing
	call interactionAnimate
	call interactionRunScript
	ret nc

	ld h,d
	ld l,Interaction.counter1
	ld (hl),60
	ld l,Interaction.substate
	dec (hl)
	ret

@state2:
	ld c,$60
	call objectUpdateSpeedZ_paramC
	jr nz,++
	ld bc,-$200
	call objectSetSpeedZ
++
	call objectPreventLinkFromPassing
	call interactionAnimate
	call objectSetPriorityRelativeToLink_withTerrainEffects
	jp interactionRunScript


subrosianAtD8_subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call subrosianAtD8_getNumEssences
	cp $07
	jp c,interactionDelete

	call getThisRoomFlags
	and $40
	jp nz,interactionDelete

	ld a,(wLinkPlayingInstrument)
	or a
	ret nz
	ld a,(wTmpcfc0.genericCutscene.state)
	or a
	ret z
	call checkLinkVulnerable
	ret nc

	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld (wDisableScreenTransitions),a
	ld a,90
	call setScreenShakeCounter

	ld e,Interaction.state
	ld a,$01
	ld (de),a

	ld a,SNDCTRL_MEDIUM_FADEOUT
	jp playSound

@state1:
	ld a,(wScreenShakeCounterY)
	or a
	ret nz

	call getThisRoomFlags
	set 6,(hl)
	ld a,CUTSCENE_S_VOLCANO_ERUPTING
	ld (wCutsceneTrigger),a
	call fadeoutToWhite
	jp interactionDelete

;;
subrosianAtD8_getNumEssences:
	ld a,(wEssencesObtained)
	jp getNumSetBits
