; ==================================================================================================
; PART_3b
; ==================================================================================================
partCode3b:
	ld e,$c4
	ld a,(de)
	or a
	jr nz,+
	inc a
	ld (de),a
+
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $7e
	jp nz,partDelete
	ld l,$a4
	ld a,(hl)
	and $80
	ld b,a
	ld e,$e4
	ld a,(de)
	and $7f
	or b
	ld (de),a
	ld l,$b7
	bit 2,(hl)
	jr z,+
	res 7,a
	ld (de),a
+
	ld l,$8b
	ld b,(hl)
	ld l,$8d
	ld c,(hl)
	ld l,$88
	ld a,(hl)
	cp $04
	jr c,+
	sub $04
	add a
	inc a
+
	add a
	ld hl,seasonsTable_10_6c5b
	rst_addDoubleIndex
	ld e,$cb
	ldi a,(hl)
	add b
	ld (de),a
	ld e,$cd
	ldi a,(hl)
	add c
	ld (de),a
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	xor a
	ret
seasonsTable_10_6c5b:
	.db $f8 $06
	.db $06 $02
	.db $02 $0c
	.db $02 $06
	.db $09 $fa
	.db $06 $02
	.db $02 $f4
	.db $02 $06
