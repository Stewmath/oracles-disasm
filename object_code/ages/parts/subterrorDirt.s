; ==================================================================================================
; PART_SUBTERROR_DIRT
; ==================================================================================================
partCode32:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,SND_DIG
	call playSound
@state1:
	call partAnimate
	ld e,$e1
	ld a,(de)
	ld e,$da
	ld (de),a
	or a
	ret nz
	jp partDelete
