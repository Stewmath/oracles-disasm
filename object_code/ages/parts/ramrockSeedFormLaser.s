; ==================================================================================================
; PART_RAMROCK_SEED_FORM_LASER
; ==================================================================================================
partCode34:
	ld e,Part.state
	ld a,(de)
	cp $03
	; moving towards you in state3
	jr nc,+
	ld a,Object.xh
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld e,Part.xh
	ld (de),a
+
	ld e,Part.counter2
	ld a,(de)
	dec a
	ld (de),a
	and $03
	; pulsate between red and blue
	jr nz,+
	ld e,Part.oamFlags
	ld a,(de)
	xor $01
	ld (de),a
+
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw partDelete
@state0:
	ld a,$01
	ld (de),a

	ld h,d
	ld l,Part.speed
	ld (hl),SPEED_2c0
	ld l,Part.angle
	ld (hl),ANGLE_DOWN

	; counter1 - $07, counter2 - $03
	ld l,Part.counter1
	ld a,$07
	ldi (hl),a
	ld (hl),$03
	call objectSetVisible80

@state1:
	ld e,Part.var03
	ld a,(de)
	or a
	jr z,+
	call partCommon_decCounter1IfNonzero
	jp nz,objectApplySpeed
+
	ld e,Part.var03
	ld a,(de)
	cp $06
	jr z,+
	call getFreePartSlot
	ret nz

	; spawn self with var03+1
	ld (hl),PART_RAMROCK_SEED_FORM_LASER
	inc l
	ld (hl),$0e
	ld l,e
	ld a,(de)
	inc a
	ld (hl),a

	ld e,Part.relatedObj1
	ld l,e
	ld a,Part
	ldi (hl),a
	ld a,d
	ld (hl),a
	call objectCopyPosition
+
	ld e,Part.state
	ld a,$02
	ld (de),a

@state2:
	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0e
	ret z

	ld e,Part.state
	ld a,$03
	ld (de),a

	ld e,$c6
	ld a,$07
	ld (de),a

@state3:
	ld e,Part.var03
	ld a,(de)
	cp $06
	jp z,partDelete
	call partCommon_decCounter1IfNonzero
	jp nz,objectApplySpeed
	ld e,$c2
	ld (de),a

	ld e,Part.state
	ld a,$04
	ld (de),a
	ret
