; ==================================================================================================
; PART_DONKEY_KONG_FLAME
; ==================================================================================================
partCode2c:
	jp nz,partDelete
	ld a,($cfd0)
	or a
	jr z,+
	call objectCreatePuff
	jp partDelete
+
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld h,d
	ld l,e
	inc (hl)

	ld l,Part.speed
	ld (hl),$1e

	ld e,Part.subid
	ld a,(de)
	swap a
	add $08
	ld l,Part.angle
	ld (hl),a

	bit 4,a
	jr z,+
	ld l,$cb
	ld (hl),$fe
	call getRandomNumber_noPreserveVars
	and $07
	ld hl,table_629f
	rst_addAToHl
	ld a,(hl)
	ld hl,@table_61aa
	rst_addAToHl
	ld e,$cd
	ld a,(hl)
	ld (de),a
	ld a,$01
	call partSetAnimation
+
	jp objectSetVisible82
@table_61aa:
	; xh vals, 3/8 chance of $b8, 5/8 chance of $d8
	.db $d8 $b8
@state1:
	ld a,$20
	call objectUpdateSpeedZ_sidescroll
	jr nc,@animate
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$f1
	ld (hl),$04
	ld l,$d4
	xor a
	ldi (hl),a
	ld (hl),a
	jr @animate
@state2:
	ld h,d
	ld l,$f1
	dec (hl)
	jr nz,@animate
	ld (hl),$04
	ld l,e
	inc (hl)
	inc l
	ld (hl),$00
@animate:
	jp partAnimate
@state3:
	ld e,$c5
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
@substate0:
	call func_6248
	call func_6270
	ret c
	ld h,d
	ld l,$c4
	inc (hl)
	ret
@substate1:
	ld bc,$1000
	call objectGetRelativeTile
	cp $19
	jp z,func_6248
	ld h,d
	ld l,$c5
	dec (hl)
	ld l,$c6
	xor a
	ld (hl),a
	ld l,$d4
	ldi (hl),a
	ld (hl),a
	jr @substate0
@state4:
	ld e,$cb
	ld a,(de)
	cp $b0
	jp nc,partDelete
	call func_6248
	call func_6270
	ret nc
	ld h,d
	ld l,$c4
	ld (hl),$02
	xor a
	ld l,$d4
	ldi (hl),a
	ld (hl),a
	ld l,$c6
	ld (hl),a

	ld e,Part.subid
	ld a,(de)
	swap a
	rrca
	inc l
	add (hl)
	inc (hl)
	ld bc,table_6238
	call addAToBc
	ld l,$c9
	ld a,(bc)
	ldd (hl),a
	and $10
	swap a
	cp (hl)
	ret z
	ld (hl),a
	jp partSetAnimation
table_6238:
	; angle vals
	.db $08 $18 $18 $08 $08 $ff $ff $ff
	.db $18 $18 $08 $08 $18 $18 $18 $18

func_6248:
	call objectGetShortPosition
	cp $91
	jr nz,func_6256
	pop hl
	call objectCreatePuff
	jp partDelete
func_6256:
	call partCommon_getTileCollisionInFront
	jr nz,func_6261
	call objectApplySpeed
	jp partAnimate
func_6261:
	ld e,$c9
	ld a,(de)
	xor $10
	ld (de),a
	ld e,$c8
	ld a,(de)
	xor $01
	ld (de),a
	jp partSetAnimation
func_6270:
	ld a,$20
	call objectUpdateSpeedZ_sidescroll
	ret c
	ld a,(hl)
	cp $02
	jr c,+
	ld (hl),$02
	dec l
	ld (hl),$00
+
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$10
	ld bc,$1000
	call objectGetRelativeTile
	sub $19
	or a
	ret nz
	call getRandomNumber
	and $07
	ld hl,table_629f
	rst_addAToHl
	ld e,$c5
	ld a,(hl)
	ld (de),a
	rrca
	ret
table_629f:
	.db $00 $00 $01 $00
	.db $01 $00 $01 $00
