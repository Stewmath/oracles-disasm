; ==================================================================================================
; INTERAC_77
; ==================================================================================================
interactionCode77:
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
	call interactionSetAnimation
	ld e,Interaction.subid
	ld a,(de)
	or a
	jp z,objectSetVisible82
	jp objectSetVisible83
@state1:
	ld hl,$cfd3
	ld a,(hl)
	and $80
	jp nz,objectSetInvisible
	call objectSetVisible
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@func_74dd
	ld a,($c486)
	ld b,a
	ld a,$7d
	sub b
	ld e,$4b
	ld (de),a
	ld a,($c487)
	ld b,a
	ld a,$54
	sub b
	ld e,$4d
	ld (de),a
	ret
@func_74dd:
	ld a,($c488)
	ld b,a
	ld a,$e9
	add b
	ld e,$4b
	ld (de),a
	ld a,($c489)
	ld b,a
	ld a,$19
	add b
	ld e,$4d
	ld (de),a
	ret
