; ==================================================================================================
; PART_KING_MOBLINS_CANNONS
; ==================================================================================================
partCode2d:
	jr z,@normalStatus
	ld h,d
	ld l,$f0
	bit 0,(hl)
	jp nz,seasonsFunc_10_67cc
	inc (hl)
	ld l,$e9
	ld (hl),$00
	ld l,$c6
	ld (hl),$41
	jp objectSetInvisible
@normalStatus:
	ld e,$c2
	ld a,(de)
	srl a
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
@subid0:
	ld a,(de)
	or a
	jr nz,@func_6775

@func_6759:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$cb
	res 3,(hl)
	ld l,$cd
	res 3,(hl)
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp nz,partDelete
	ld e,$c2
	ld a,(de)
	call partSetAnimation
	jp objectSetVisible82
@func_6775:
	call partAnimate
	ld e,$e1
	ld a,(de)
	or a
	ret z
	ld bc,$fa13
	dec a
	jr z,func_67a4
	jr func_6797
@subid1:
	ld a,(de)
	or a
	jr z,@func_6759
	call partAnimate
	ld e,$e1
	ld a,(de)
	or a
	ret z
	ld bc,$faed
	dec a
	jr z,func_67a4
func_6797:
	call getFreePartSlot
	ret nz
	ld (hl),PART_KING_MOBLIN_BOMB
	inc l
	inc (hl)
	call objectCopyPositionWithOffset
	jr func_67b7
func_67a4:
	ld (de),a
	ld a,$81
	call playSound
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_PUFF
	ld l,$42
	ld (hl),$80
	jp objectCopyPositionWithOffset
func_67b7:
	ld e,$c2
	ld a,(de)
	bit 1,a
	ld b,$04
	jr z,+
	ld b,$12
+
	call getRandomNumber
	and $06
	add b
	ld l,$c9
	ld (hl),a
	ret

seasonsFunc_10_67cc:
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld a,(hl)
	cp $35
	jr z,func_67f8
	and $0f
	ret nz
	ld a,(hl)
	and $f0
	swap a
	dec a
	ld hl,table_67f0
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_EXPLOSION
	jp objectCopyPositionWithOffset
table_67f0:
	.db $f8 $04 $08 $fe
	.db $fa $f8 $02 $0c
func_67f8:
	ld e,$cb
	ld a,(de)
	sub $08
	and $f0
	ld b,a
	ld e,$cd
	ld a,(de)
	sub $08
	and $f0
	swap a
	or b
	ld c,a
	ld b,$a2
	ld e,$c2
	ld a,(de)
	bit 1,a
	jr z,+
	ld b,$a6
+
	push bc
	ld a,b
	call setTile
	pop bc
	ld a,b
	inc a
	inc c
	jp setTile
