; ==================================================================================================
; PART_43
; ==================================================================================================
partCode43:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
@subid0:
	ld a,(de)
	or a
	jr z,@func_724b
	call partAnimate
	call partCommon_decCounter1IfNonzero
	jp nz,objectApplyComponentSpeed
	ld b,$06
-
	ld a,b
	dec a
	ld hl,@table_7245
	rst_addAToHl
	ld c,(hl)
	call @func_7236
	dec b
	jr nz,-
	call objectCreatePuff
	jp partDelete
@func_7236:
	call getFreePartSlot
	ret nz
	ld (hl),PART_43
	inc l
	ld (hl),$03
	ld l,$c9
	ld (hl),c
	jp objectCopyPosition
@table_7245:
	.db $03 $08 $0d
	.db $13 $18 $1d

@func_724b:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$dd
	ld (hl),$06
	dec l
	ld a,$0a
	ldd (hl),a
	ld (hl),a
	ld l,$cb
	ld a,(hl)
	add $06
	ld (hl),a
	ld l,$e6
	ld a,$05
	ldi (hl),a
	ld (hl),a
	ld l,$c6
	ld (hl),$0c
	ld l,$c9
	ld (hl),$10
	ld b,$50
	jr @subid1@func_729a
@subid1:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$04
	ld l,$e4
	res 7,(hl)
	ld l,$dd
	ld (hl),$06
	dec l
	ld a,$0a
	ldd (hl),a
	ld (hl),a
	ret
@@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$b4
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld b,$3c
@@func_729a:
	call func_733d
	call objectSetVisible81
	ld a,$72
	jp playSound
@@state2:
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	jp partAnimate
@subid2:
	ld a,(de)
	or a
	jr z,@func_72be

@seasonsFunc_10_72b2:
	call partCommon_checkOutOfBounds
	jp z,partDelete
	call objectApplyComponentSpeed
	jp partAnimate
@func_72be:
	ld b,$02
	call checkBPartSlotsAvailable
	ret nz
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$dd
	ld (hl),$06
	dec l
	ld a,$0a
	ldd (hl),a
	ld (hl),a
	ld l,$c9
	ld (hl),$10
	ld l,$cb
	ld a,(hl)
	add $06
	ld (hl),a
	ld b,$3c
	call @subid1@func_729a
	ld bc,$0213
	call @func_72e9
	ld bc,$030d
@func_72e9:
	call getFreePartSlot
	ld (hl),PART_43
	inc l
	ld (hl),$04
	inc l
	ld (hl),b
	ld l,$c9
	ld (hl),c
	jp objectCopyPosition
@subid3:
	ld a,(de)
	or a
	jr z,+
	call objectApplyComponentSpeed
	ld c,$12
	call objectUpdateSpeedZ_paramC
	jp nz,partAnimate
	jp partDelete
+
	ld bc,$ff20
	call objectSetSpeedZ
	ld l,e
	inc (hl)
	ld l,$e6
	ld (hl),$05
	inc l
	ld (hl),$02
	ld b,$3c
	call func_733d
	call objectSetVisible82
	ld a,$01
	jp partSetAnimation
@subid4:
	ld a,(de)
	or a
	jp nz,@seasonsFunc_10_72b2
	ld h,d
	ld l,e
	inc (hl)
	ld b,$3c
	call func_733d
	call objectSetVisible82
	ld e,$c3
	ld a,(de)
	jp partSetAnimation
func_733d:
	ld e,$c9
	ld a,(de)
	ld c,a
	call getPositionOffsetForVelocity
	ld e,$d0
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ret
