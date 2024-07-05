; ==================================================================================================
; PART_ROTATABLE_SEED_THING
; ==================================================================================================
partCode33:
	ld e,$c2
	ld a,(de)
	ld b,a
	and $03
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	
@subid0:
	ld a,(de)
	or a
	jr z,@subid0_state0
@func_64f2:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld e,$f0
	ld a,(de)
	ld (hl),a
	jp @func_657e
@subid0_state0:
	ld c,b
	rlc c
	ld a,$01
	jr nc,+
	ld a,$ff
+
	ld h,d
	ld l,$f1
	ldd (hl),a
	rlc c
	ld a,$3c
	jr nc,+
	add a
+
	ld (hl),a
	ld l,$c6
	ld (hl),a
@func_6515:
	ld a,b
	rrca
	rrca
	and $03
	ld e,$c8
	ld (de),a
	call @func_6588
	call objectMakeTileSolid
	ld h,$cf
	ld (hl),$0a
	call objectSetVisible83
	call getFreePartSlot
	ret nz
	ld (hl),PART_ROTATABLE_SEED_THING
	inc l
	ld (hl),$03
	ld l,$d6
	ld a,$c0
	ldi (hl),a
	ld (hl),d
	ld h,d
	ld l,$c4
	inc (hl)
	ret
	
@subid1:
	ld a,(de)
	jr z,@@state0
	ld h,d
	ld l,$c3
	ld a,(hl)
	ld l,$d8
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	and (hl)
	ret z
	jr @func_64f2
@@state0:
	call @subid0_state0
@func_6551:
	ld e,$c2
	ld a,(de)
	bit 4,a
	ld hl,wToggleBlocksState
	jr z,+
	ld hl,wActiveTriggers
+
	ld e,$d8
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret
	
@subid2:
	ld a,(de)
	or a
	jr z,@subid2_state0
	ld h,d
	ld l,$f2
	ld e,l
	ld b,(hl)
	ld l,$c3
	ld c,(hl)
	ld l,$d8
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(hl)
	and c
	ld c,a
	xor b
	ret z
	ld a,c
	ld (de),a
@func_657e:
	ld h,d
	ld l,$f1
	ld e,$c8
	ld a,(de)
	add (hl)
	and $03
	ld (de),a
@func_6588:
	ld b,a
	ld hl,@table_6598
	rst_addDoubleIndex
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld a,b
	jp partSetAnimation
	
@table_6598:
	.db $06 $04
	.db $04 $04
	.db $04 $06
	.db $04 $04

@subid2_state0:
	ld c,b
	rlc c
	ld a,$01
	jr nc,+
	ld a,$ff
+
	rlc c
	jr nc,+
	add a
+
	ld h,d
	ld l,$f1
	ld (hl),a
	call @func_6515
	call @func_6551
	ld e,$c3
	ld a,(de)
	and (hl)
	ld e,$f2
	ld (de),a
	ret
@subid3:
	ld a,(de)
	or a
	jr z,func_65d5
	ld a,$21
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(hl)
	ld (de),a
	ld l,$e6
	ld e,l
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

func_65d5:
	ld a,$0b
	call objectGetRelatedObject1Var
	ld bc,$0c00
	call objectTakePositionWithOffset
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$cf
	ld (hl),$f2
	ret
