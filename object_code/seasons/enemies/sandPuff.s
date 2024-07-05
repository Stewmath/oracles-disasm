; ==================================================================================================
; ENEMY_SAND_PUFF
; ==================================================================================================
enemyCode5b:
	ld e,$84
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw enemyAnimate

@state0:
	ld a,$01
	ld (de),a
	call getRandomNumber
	and $07
	inc a
	ld e,$86
	ld (de),a
	ld a,$b0
	jp loadPaletteHeader

@state1:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	jp objectSetVisible83
