; ==================================================================================================
; PART_GANON_TRIDENT
; ==================================================================================================
partCode50:
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0e
	jp z,partDelete
	push hl
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a
	pop hl
	call objectTakePosition
	ld l,$b2
	ld a,(hl)
	or a
	jr z,+
	ld a,$01
+
	jp partSetAnimation

@state1:
	call partAnimate
	ld e,$e1
	ld a,(de)
	inc a
	jr nz,func_5b2b
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$e6
	ld a,$07
	ldi (hl),a
	ld (hl),a
	call objectSetInvisible

@state2:
	pop hl
	inc l
	ld a,(hl)
	or a
	jp z,partDelete
	ld bc,$2000
	jp objectTakePositionWithOffset

func_5b2b:
	ld h,d
	ld l,e
	bit 7,(hl)
	jr z, +
	res 7,(hl)
	call objectSetVisible82
	ld a,SND_BIGSWORD
	call playSound
	ld h,d
	ld l,$e1
+
	ld a,(hl)
	ld hl,table_5b5b
	rst_addAToHl
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	pop hl
	ld l,$b2
	ld a,(hl)
	or a
	jr z,+
	ld a,c
	cpl
	inc a
	ld c,a
+
	jp objectTakePositionWithOffset

table_5b5b:
	.db $07 $07 $d8 $f1
	.db $0b $07 $e7 $1a
	.db $20 $0c $f7 $19
