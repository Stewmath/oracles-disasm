; ==================================================================================================
; PART_SMALL_FAIRY
; ==================================================================================================
partCode28:
	jr z,@normalStatus
	cp $02
	jp z,@collected
	ld e,$c4
	ld a,$02
	ld (de),a
@normalStatus:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$cf
	ld (hl),$fa
	ld l,$f1
	ld e,$cb
	ld a,(de)
	ldi (hl),a
	ld e,$cd
	ld a,(de)
	ld (hl),a
	jp objectSetVisiblec2

@state1:
	call partCommon_decCounter1IfNonzero
	jr z,+
	call func_56cd
	jp c,objectApplySpeed
+
	call getRandomNumber_noPreserveVars
	and $3e
	add $08
	ld e,$c6
	ld (de),a
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@table_5666
	rst_addAToHl
	ld e,$d0
	ld a,(hl)
	ld (de),a
	call getRandomNumber_noPreserveVars
	and $1e
	ld h,d
	ld l,$c9
	ld (hl),a
	jp func_56b6

@table_5666:
	.db $0a
	.db $14
	.db $1e
	.db $28

@state2:
	ld e,$c5
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$cf
	ld (hl),$00
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld e,$f0
	ld (de),a
	call objectSetVisible80
+
	call objectCheckCollidedWithLink
	jp c,@collected
	ld a,$00
	call objectGetRelatedObject1Var
	ldi a,(hl)
	or a
	jr z,+
	ld e,$f0
	ld a,(de)
	cp (hl)
	jp z,objectTakePosition
+
	jp partDelete

@collected:
	ld a,$26
	call cpActiveRing
	ld c,$18
	jr z,+
	ld a,$25
	call cpActiveRing
	jr nz,++
+
	ld c,$30
++
	ld a,$29
	call giveTreasure
	jp partDelete

func_56b6:
	ld e,$c9
	ld a,(de)
	and $0f
	ret z
	ld a,(de)
	cp $10
	ld a,$00
	jr nc,+
	inc a
+
	ld h,d
	ld l,$c8
	cp (hl)
	ret z
	ld (hl),a
	jp partSetAnimation

func_56cd:
	ld e,$c9
	ld a,(de)
	and $07
	ld a,(de)
	jr z,+
	and $18
	add $04
+
	and $1c
	rrca
	ld hl,table_56f5
	rst_addAToHl
	ld e,$cb
	ld a,(de)
	add (hl)
	ld b,a
	ld e,$cd
	inc hl
	ld a,(de)
	add (hl)
	sub $38
	cp $80
	ret nc
	ld a,b
	sub $18
	cp $50
	ret

table_56f5:
	.db $fc $00 $fc $04
	.db $00 $04 $04 $04
	.db $04 $00 $04 $fc
	.db $00 $fc $fc $fc
