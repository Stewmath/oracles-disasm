; ==================================================================================================
; INTERAC_ba
; ==================================================================================================
interactionCodeba:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw interactionCodebb@subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
@subid1:
@subid2:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	call func_7867
	ld l,$43
	ld a,(hl)
	call interactionSetAnimation
@@state1:
	call interactionRunScript
	jp func_7886
@subid3:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	call func_7867
@@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp func_7886
