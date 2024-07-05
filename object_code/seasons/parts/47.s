; ==================================================================================================
; PART_47
; ==================================================================================================
partCode47:
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
	ld b,$04
	call checkBPartSlotsAvailable
	ret nz
	ld b,$04
	ld e,$d7
	ld a,(de)
	ld c,a
	call @func_7566
	ld (hl),$80
	ld c,h
	dec b
-
	call @func_7566
	ld (hl),$c0
	dec b
	jr nz,-
	ld a,$19
	call objectGetRelatedObject1Var
	ld (hl),c
	jp partDelete

@func_7566:
	call getFreePartSlot
	ld (hl),PART_47
	inc l
	ld a,$05
	sub b
	ld (hl),a
	call objectCopyPosition
	ld l,$d7
	ld (hl),c
	dec l
	ret

@subid1:
	ld b,$02
	call @func_777f
	ld l,$a9
	ld a,(hl)
	or a
	ld e,$c4
	jr z,+
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	.dw @@state5
	.dw @@state6
	.dw @@state7
	.dw @@state8
+
	ld a,(de)
	cp $08
	ret z
	ld h,d
	ld l,$e4
	res 7,(hl)
	ld l,$da
	ld a,(hl)
	xor $80
	ld (hl),a
	ret

@@state0:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
	.dw @@@substate4

@@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d4
	ld a,$20
	ldi (hl),a
	ld (hl),$ff
	ld l,$c9
	ld (hl),$10
	ld l,$d0
	ld (hl),$78
	ld l,$cb
	ld a,$18
	ldi (hl),a
	inc l
	ld (hl),$78
	ld l,$f0
	ldi (hl),a
	ld (hl),$78
	jp objectSetVisible82

@@@substate1:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	jr z,+
	call objectApplySpeed
	ld e,$cb
	ld a,(de)
	sub $18
	ld e,$f3
	ld (de),a
	ret
+
	ld l,$c5
	inc (hl)
	inc l
	ld a,$3c
	ld (hl),a
	call setScreenShakeCounter
	ld a,$6f
	call playSound
	jp @func_776f

@@@substate2:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld l,$d0
	ld a,$80
	ldi (hl),a
	ld (hl),$ff
	ret

@@@substate3:
	call objectApplyComponentSpeed
	ld e,$cb
	ld a,(de)
	cp $18
	ret nc
	ld e,$c5
	ld a,$04
	ld (de),a
	jp objectSetInvisible

@@@substate4:
	ret

@@state1:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld l,$c9
	ld (hl),$12
	ld l,$d4
	ld a,$00
	ldi (hl),a
	ld (hl),$fe
	call objectSetVisible82

@@state2:
	ld h,d
	ld l,$c9
	ld a,(hl)
	cp $1e
	jr nz,@@state3
	ld l,e
	inc (hl)
	call objectSetVisible81

@@state3:
	ld a,(wFrameCounter)
	and $0f
	ld a,$a4
	call z,playSound
	ld e,$c9
	ld a,(de)
	inc a
	and $1f
	ld (de),a
	and $0f
	ld hl,@table_775f
	rst_addAToHl
	ld e,$f3
	ld a,(hl)
	ld (de),a
	ld bc,$e605
-
	ld a,$0b
	call objectGetRelatedObject1Var
	ldi a,(hl)
	add b
	ld b,a
	ld e,$f0
	ld (de),a
	inc l
	ld a,(hl)
	add c
	ld c,a
	inc e
	ld (de),a
	ld e,$f3
	ld a,(de)
	ld e,$c9
	jp objectSetPositionInCircleArc

@@state4:
	ld a,(wFrameCounter)
	and $07
	ld a,$a4
	call z,playSound
	ld e,$c9
	ld a,(de)
	inc a
	and $1f
	ld (de),a
	ld bc,$e009
	jr -

@@state5:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld (hl),$02
	ld l,$c9
	inc (hl)
	ld a,(hl)
	cp $15
	jr z,++
	ld c,a
	ld b,$5a
	ld a,$03
	call objectSetComponentSpeedByScaledVelocity
+
	jp objectApplyComponentSpeed
++
	ld l,e
	inc (hl)
	ld l,$c6
	ld a,$3c
	ld (hl),a
	ld l,$e8
	ld (hl),$fc
	call setScreenShakeCounter
	call @func_776f
	ld a,$6f
	jp playSound

@@state6:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$1e
	ret

@@state7:
	ld h,d
	ld l,$f0
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,$cb
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	cp c
	jr nz,+
	ldh a,(<hFF8F)
	cp b
	jr nz,+
	ld l,e
	inc (hl)
	ld l,$e4
	res 7,(hl)
	jp objectSetInvisible
+
	call objectGetRelativeAngleWithTempVars
	ld e,$c9
	ld (de),a
	jp objectApplySpeed

@@state8:
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0a
	ret nz
	ld e,$c4
	ld a,$01
	ld (de),a
	ret

@subid2:
	ld a,(de)
	or a
	jr z,@func_7726
	ld b,$47
	call @func_777f
	call @func_778b
	ld a,e
	add a
	add e
	add b
	ld e,$cb
	ld (de),a
	ld a,l
	add a
	add l
	add c
	ld e,$cd
	ld (de),a

@func_7719:
	ld a,$1a
	call objectGetRelatedObject1Var
	bit 7,(hl)
	jp nz,objectSetVisible82
	jp objectSetInvisible

@func_7726:
	inc a
	ld (de),a
	call partSetAnimation
	jr @func_7719

@subid3:
	ld a,(de)
	or a
	jr z,@func_7726
	ld b,$47
	call @func_777f
	call @func_778b
	ld a,e
	add a
	add b
	ld e,$cb
	ld (de),a
	ld a,l
	add a
	add c
	ld e,$cd
	ld (de),a
	jr @func_7719

@subid4:
	ld a,(de)
	or a
	jr z,@func_7726
	ld b,$47
	call @func_777f
	call @func_778b
	ld a,e
	add b
	ld e,$cb
	ld (de),a
	ld a,l
	add c
	ld e,$cd
	ld (de),a
	jr @func_7719

@table_775f:
	.db $10 $11 $12 $14 $16 $1a $1e $22
	.db $28 $22 $1e $1a $16 $14 $12 $11

@func_776f:
	call getFreePartSlot
	ret nz
	ld (hl),PART_48
	inc l
	ld (hl),$02
	ld l,$d6
	ld a,$c0
	ldi (hl),a
	ld (hl),d
	ret

@func_777f:
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp b
	ret z
	pop hl
	jp partDelete

@func_778b:
	ld a,$30
	call objectGetRelatedObject1Var
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,$cb
	ldi a,(hl)
	sub b
	sra a
	sra a
	ld e,a
	inc l
	ld a,(hl)
	sub c
	sra a
	sra a
	ld l,a
	ret
