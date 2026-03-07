; ==================================================================================================
; PART_FALLING_FIRE
; ==================================================================================================
partCode23:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	ld a,(de)
	or a
	jr z,@func_54f6
	call partCommon_decCounter1IfNonzero
	ret nz
.ifdef ROM_AGES
	ld (hl),$78
.else
	ld (hl),$3c
.endif
	jr ++
@func_54f6:
	inc a
	ld (de),a
	ret

@subid1:
	ld a,(de)
	or a
	jr z,@func_54f6
	call partCommon_decCounter1IfNonzero
	ret nz
	call func_553f
++
	call getFreePartSlot
	ret nz
	ld (hl),PART_FALLING_FIRE
	inc l
	ld (hl),$02
	ld l,$f0
	ld e,l
	ld a,(de)
	ld (hl),a
	jp objectCopyPosition

@subid2:
	ld a,(de)
	or a
	jr z,func_5535
	ld h,d
	ld l,$cb
	ld a,(hl)
	cp $b0
	jp nc,partDelete
	ld l,$d0
	ld e,$ca
	call add16BitRefs
	dec l
	ld a,(hl)
	add $10
	ldi (hl),a
	ld a,(hl)
	adc $00
	ld (hl),a
	jp partAnimate

func_5535:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	jp objectSetVisible81

func_553f:
	ld e,$87
	ld a,(de)
	inc a
	and $03
	ld (de),a
	ld hl,table_554f
	rst_addAToHl
	ld e,$c6
	ld a,(hl)
	ld (de),a
	ret

table_554f:
.ifdef ROM_AGES
	.db $78 $78
.else
	.db $3c $3c
.endif
	.db $1e $1e
