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
	ld hl,table_6661
	jr func_6649


; ==================================================================================================
; PART_CANNON_ARROW_SHOOTER
; ==================================================================================================
partCode2c:
	ld e,$c4
	ld a,(de)
	or a
	jr nz,label_10_270
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c2
	ld a,(hl)
	ld b,a
	swap a
	rrca
	ld l,$c9
	ld (hl),a
	ld a,b
	call partSetAnimation
	call getRandomNumber_noPreserveVars
	and $30
	ld e,$c6
	ld (de),a
	call objectMakeTileSolid
	jp objectSetVisible82
label_10_270:
	ldh a,(<hCameraY)
	add $80
	ld b,a
	ld e,$cb
	ld a,(de)
	cp b
	ret nc
	ldh a,(<hCameraX)
	add $a0
	ld b,a
	ld e,$cd
	ld a,(de)
	cp b
	ret nc
	call partCommon_decCounter1IfNonzero
	ret nz
	call getRandomNumber_noPreserveVars
	and $60
	add $20
	ld e,$c6
	ld (de),a
	ld hl,table_6669

func_6649:
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

table_6661:
	.db $fc $00 ; shooting up
	.db $00 $04 ; shooting right
	.db $04 $00 ; shooting down
	.db $00 $fc ; shooting left

table_6669:
	.db $f8 $00
	.db $00 $08
	.db $08 $00
	.db $00 $f8
