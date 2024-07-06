; ==================================================================================================
; PART_WALL_ARROW_SHOOTER
; ==================================================================================================
partCode25:
	ld e,$c4
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c2
	ld a,(hl)
	swap a
	rrca
	ld l,$c9
	ld (hl),a
+
	call partCommon_decCounter1IfNonzero
	ret nz
	ld e,$c2
	ld a,(de)
	bit 0,a
	ld e,$cd
	ldh a,(<hEnemyTargetX)
	jr z,+
	ld e,$cb
	ldh a,(<hEnemyTargetY)
+
	ld b,a
	ld a,(de)
	sub b
	add $10
	cp $21
	ret nc
	ld e,$c6
	ld a,$21
	ld (de),a
	ld hl,table_6080
	
	ld e,$c2
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	call getFreePartSlot
	ret nz
	ld (hl),PART_ENEMY_ARROW
	inc l
	inc (hl)
	call objectCopyPositionWithOffset
	ld l,$c9
	ld e,l
	ld a,(de)
	ld (hl),a
	ret

table_6080:
	.db $fc $00 ; shooting up
	.db $00 $04 ; shooting right
	.db $04 $00 ; shooting down
	.db $00 $fc ; shooting left
