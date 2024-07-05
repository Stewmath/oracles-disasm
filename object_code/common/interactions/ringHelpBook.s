; ==================================================================================================
; INTERAC_RING_HELP_BOOK
; ==================================================================================================
interactionCodee5:
	ld a,(wTextIsActive)
	or a
	jr nz,@doneTextFlagSetup

	ld a,$02
	ld (wTextboxPosition),a
	ld a,TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a
@doneTextFlagSetup:

	call @runState
	jp objectSetPriorityRelativeToLink_withTerrainEffects

@runState:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics
	ld a,>TX_3000
	call interactionSetHighTextIndex
	call interactionSetAlwaysUpdateBit
	call interactionIncState
	ld a,$06
	call objectSetCollideRadius

	ld e,Interaction.subid
	ld a,(de)
	ld hl,mainScripts.ringHelpBookSubid0Script
	or a
	jr z,++

	ld e,Interaction.oamFlags
	ld a,(de)
	inc a
	ld (de),a
	ld hl,mainScripts.ringHelpBookSubid1Script
++
	call interactionSetScript
	ld e,Interaction.pressedAButton
	jp objectAddToAButtonSensitiveObjectList

@state1:
	jp interactionRunScript
