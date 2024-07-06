; ==================================================================================================
; PART_WALL_FLAME_SHOOTERS_FLAMES
; ==================================================================================================
partCode26:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	res 7,a
	cp $03
	jp nc,seasonsFunc_10_670c
@normalStatus:
	call func_66e7
	jp c,seasonsFunc_10_670c
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
	ld l,$d0
	ld (hl),$46
	ld l,$c6
	ld (hl),$16
	ld l,$c9
	ld (hl),$10
	ld a,$73
	call playSound
	jp objectSetVisible82
@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld (hl),$10
	ld l,e
	inc (hl)
	jr $26
+
	ld a,(hl)
	rrca
	jr nc,@func_66bd
	ld l,$d0
	ld a,(hl)
	cp $78
	jr z,@func_66bd
	add $05
	ld (hl),a
@func_66bd:
	call objectApplySpeed
	call partAnimate
	ld e,$e1
	ld a,(de)
	ld hl,@table_66d2
	rst_addAToHl
	ld e,$e6
	ld a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret
@table_66d2:
	.db $02 $04 $06
@state2:
	call partCode.partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld a,(hl)
	rrca
	jr nc,@func_66bd
	ld l,$d0
	ld a,(hl)
	sub $0a
	ld (hl),a
	jr @func_66bd

func_66e7:
	ld e,$e6
	ld a,(de)
	add $09
	ld b,a
	ld e,$e7
	ld a,(de)
	add $09
	ld c,a
	ld hl,$dd0b
	ld e,$cb
	ld a,(de)
	sub (hl)
	add b
	sla b
	inc b
	cp b
	ret nc
	ld l,$0d
	ld e,$cd
	ld a,(de)
	sub (hl)
	add c
	sla c
	inc c
	cp c
	ret

seasonsFunc_10_670c:
	call objectCreatePuff
	jp partDelete
