; ==================================================================================================
; INTERAC_8e
; ==================================================================================================
interactionCode8e:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisible81
@state1:
	call interactionAnimate
	call objectGetRelatedObject1Var
	ld l,$76
	ld a,(hl)
	or a
	jp z,@func_4f4c
	xor a
	ld (hl),a
	call interactionSetAnimation
@func_4f4c:
	call objectSetVisible
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	jp nz,objectSetInvisible
	ret
