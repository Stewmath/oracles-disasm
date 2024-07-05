; ==================================================================================================
; INTERAC_HUMAN_VERAN
; ==================================================================================================
interactionCodebb:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState
	call interactionInitGraphics
	ld hl,mainScripts.humanVeranScript
	call interactionSetScript
	jp objectSetVisible82

@state1:
	ld a,Object.visible
	call objectGetRelatedObject1Var
	ld a,(hl)
	xor $80
	ld e,l
	ld (de),a
	call interactionRunScript
	ret nc
	jp interactionDelete
