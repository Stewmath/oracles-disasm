; ==================================================================================================
; ENEMY_WALL_FLAME_SHOOTER
; ==================================================================================================
enemyCode5c:
	dec a
	ret z
	dec a
	ret z
	ld e,$84
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$8f
	ld (hl),$fe
	ld l,$82
	bit 0,(hl)
	ret z
	ld l,$87
	ld (hl),$08
	ret

@state1:
	call ecom_decCounter2
	ret nz
	ld (hl),$10
	call getFreePartSlot
	ret nz
	ld (hl),PART_WALL_FLAME_SHOOTERS_FLAMES
	ld bc,$0600
	jp objectCopyPositionWithOffset
