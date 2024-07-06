; ==================================================================================================
; PART_ENEMY_SWORD
; ==================================================================================================
partCode1d:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jr z,@normalStatus
	cp $8a
	jr z,@normalStatus
	ld a,$2b
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr nz,+
	ld e,$eb
	ld a,(de)
	ld (hl),a
+
	ld e,$ec
	ld a,(de)
	inc l
	ldi (hl),a
	ld e,$ed
	ld a,(de)
	ld (hl),a
@normalStatus:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@func_5261
	ld h,d
	ld l,$e4
	set 7,(hl)
	call @func_5273
	jp nz,partDelete

@func_521a:
	ld l,$8b
	ld b,(hl)
	ld l,$8d
	ld c,(hl)
	ld l,$89
	ld a,(hl)
	add $04
	and $18
	rrca
	ldh (<hFF8B),a
	ld l,$a1
	add (hl)
	add (hl)
	ld hl,@table_524d
	rst_addAToHl
	ld e,$cb
	ldi a,(hl)
	add b
	ld (de),a
	ld e,$cd
	ld a,(hl)
	add c
	ld (de),a
	ldh a,(<hFF8B)
	rrca
	and $02
	ld hl,@table_525d
	rst_addAToHl
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

@table_524d:
	.db $f8 $04
	.db $f6 $04
	.db $04 $07
	.db $04 $09
	.db $07 $fc
	.db $09 $fc
	.db $04 $f9
	.db $04 $f7

@table_525d:
	.db $05 $02
	.db $02 $05

@func_5261:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$fe
	ld (hl),$04
	ld a,$01
	call objectGetRelatedObject1Var
	ld e,$f0
	ld a,(hl)
	ld (de),a
	jr @func_521a

@func_5273:
	ld a,$01
	call objectGetRelatedObject1Var
	ld e,$f0
	ld a,(de)
	cp (hl)
	ret nz
	ld l,$b0
	bit 0,(hl)
	jr nz,+
	ld l,$a9
	ld a,(hl)
	or a
	jr z,+
	ld l,$ae
	ld a,(hl)
	or a
	jr nz,+
	ld l,$bf
	bit 1,(hl)
	ret z
+
	ld e,$e4
	ld a,(de)
	res 7,a
	ld (de),a
	xor a
	ret
