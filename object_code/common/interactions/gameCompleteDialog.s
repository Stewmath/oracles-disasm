; ==================================================================================================
; INTERAC_GAME_COMPLETE_DIALOG
; ==================================================================================================
interactionCoded1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interactionRunScript

@state0:
	ld a,$01
	ld (de),a
	ld c,a
	callab bank1.loadDeathRespawnBufferPreset
	ld hl,mainScripts.gameCompleteDialogScript
	jp interactionSetScript
