; ==================================================================================================
; INTERAC_TOKAY_CUTSCENE_EMBER_SEED
; ==================================================================================================
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
