; ==================================================================================================
; INTERAC_cf
; ==================================================================================================
interactionCodecf:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@positions
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Interaction.yh
	ld (de),a
	inc e
	inc e
	ld a,(hl)
	ld (de),a
	jp objectSetVisible82

@positions:
	.db $18 $5c ; 0 == [subid]
	.db $40 $40 ; 1
	.db $38 $88 ; 2

@state1:
	jp interactionAnimate
