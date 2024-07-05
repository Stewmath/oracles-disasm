; ==================================================================================================
; INTERAC_JEWEL
; ==================================================================================================
interactionCode92:
	call checkInteractionState
	ret nz

@state0:
	inc a
	ld (de),a ; [state] = 1

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@xPositions
	rst_addAToHl
	ld a,(hl)
	ld h,d
	ld l,Interaction.xh
	ld (hl),a

	ld l,Interaction.yh
	ld (hl),$2c
	call interactionInitGraphics
	jp objectSetVisible83

@xPositions:
	.db $24 $34 $6c $7c
