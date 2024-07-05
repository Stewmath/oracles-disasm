; ==================================================================================================
; INTERAC_BIGGORON
; ==================================================================================================
interactionCode52:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call objectSetVisible82
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld hl,mainScripts.biggoronScript
	jp interactionSetScript
@state1:
	call interactionAnimate
	jp interactionRunScript
