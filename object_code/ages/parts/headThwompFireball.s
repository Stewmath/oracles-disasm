; ==================================================================================================
; PART_HEAD_THWOMP_FIREBALL
; ==================================================================================================
partCode39:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$1e
	ld l,$d4
	ld a,$20
	ldi (hl),a
	ld (hl),$fc
	call getRandomNumber_noPreserveVars
	and $10
	add $08
	ld e,$c9
	ld (de),a
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@table_6c66
	rst_addAToHl
	ld e,$d0
	ld a,(hl)
	ld (de),a
	call objectSetVisible82
	ld a,SND_FALLINHOLE
	jp playSound
@table_6c66:
	.db $0f $19 $23 $2d
@state1:
	call objectApplySpeed
	ld h,d
	ld l,$d4
	ld e,$ca
	call add16BitRefs
	dec l
	ld a,(hl)
	add $20
	ldi (hl),a
	ld a,(hl)
	adc $00
	ld (hl),a
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	ld a,(de)
	cp $b0
	jp nc,partDelete
	add $06
	ld b,a
	ld l,$cd
	ld c,(hl)
	call checkTileCollisionAt_allowHoles
	jr nc,@animate
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$db
	ld a,$0b
	ldi (hl),a
	ldi (hl),a
	ld (hl),$26
	ld a,$01
	call partSetAnimation
	ld a,SND_BREAK_ROCK
	jp playSound
@state2:
	ld e,$e1
	ld a,(de)
	bit 7,a
	jp nz,partDelete
	ld hl,@table_6cc0
	rst_addAToHl
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
@animate:
	jp partAnimate
@table_6cc0:
	.db $04 $09
	.db $06 $0b
	.db $09 $0c
	.db $0a $0d
	.db $0b $0e
