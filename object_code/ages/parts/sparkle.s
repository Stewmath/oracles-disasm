; ==================================================================================================
; PART_SPARKLE
; ==================================================================================================
partCode26:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	call partCommon_decCounter1IfNonzero
	jr nz,@counter1NonZero
	inc l
	ldd a,(hl)
	ld (hl),a
	ld l,$f0
	ld a,(hl)
	cpl
	add $01
	ldi (hl),a
	ld a,(hl)
	cpl
	adc $00
	ld (hl),a
@counter1NonZero:
	ld e,Part.xh
	ld a,(de)
	ld b,a
	dec e
	ld a,(de)
	ld c,a
	ld l,$d2
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld e,$f0
	ld a,(de)
	ld c,a
	inc e
	ld a,(de)
	ld b,a
	ld e,$d3
	ld a,(de)
	ld h,a
	dec e
	ld a,(de)
	ld l,a
	add hl,bc
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld h,d
	ld l,$ce
	ld e,$d4
	ld a,(de)
	add (hl)
	ldi (hl),a
	ld a,(hl)
	adc $00
	jp z,partDelete
	ld (hl),a
	cp $e8
	jr c,@animate
	ld l,$da
	ld a,(hl)
	xor $80
	ld (hl),a
@animate:
	jp partAnimate
@state0:
	ld h,d
	ld l,e
	inc (hl)
	call objectGetZAboveScreen
	ld l,$cf
	ld (hl),a
	ld e,$c3
	ld a,(de)
	or a
	jr z,@var03_00
	ld (hl),$f0
@var03_00:
	call getRandomNumber_noPreserveVars
	and $0c
	ld hl,table_6114
	rst_addAToHl
	ld e,Part.var30
	ldi a,(hl)
	ld (de),a

	; Part.var31
	inc e
	ldi a,(hl)
	ld (de),a

	ld e,Part.speedZ
	ldi a,(hl)
	ld (de),a

	ld e,Part.counter1
	ld a,(hl)
	ld (de),a

	inc e
	dec a
	add a
	ld (de),a
	jp objectSetVisible81
table_6114:
	.db $fa $ff $56 $0c
	.db $f7 $ff $54 $0a
	.db $f2 $ff $5c $0e
	.db $f5 $ff $58 $10
