; ==================================================================================================
; INTERAC_aa
; ==================================================================================================
interactionCodeaa:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	ld e,$42
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp objectSetVisible82
@state1:
	call interactionAnimate
	jp interactionRunScript
@scriptTable:
	.dw mainScripts.script769f
	.dw mainScripts.script76ad
	.dw mainScripts.script76b7
	.dw mainScripts.script76dc
