; ==================================================================================================
; INTERAC_OVERWORLD_KEY_SPRITE
; ==================================================================================================
interactionCode18:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionIncState
	ld bc,-$200
	call objectSetSpeedZ
	call interactionSetAlwaysUpdateBit
	call interactionInitGraphics
	jp objectSetVisible80

@state1:
	; Decrease speedZ, wait for it to stop moving up
	ld c,$28
	call objectUpdateSpeedZ_paramC
	ld e,Interaction.speedZ+1
	ld a,(de)
	bit 7,a
	ret nz

	ld e,Interaction.counter1
	ld a,$3c
	ld (de),a
	jp interactionIncState

@state2:
	call interactionDecCounter1
	ret nz
	jp interactionDelete
