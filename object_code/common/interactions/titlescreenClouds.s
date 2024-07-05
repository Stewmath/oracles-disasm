; ==================================================================================================
; INTERAC_TITLESCREEN_CLOUDS
; ==================================================================================================
interactionCoded2:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@positions
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld h,d
	ld l,Interaction.var37
	ld (hl),a
	ld l,Interaction.yh
	ldi (hl),a
	inc l
	ld (hl),b

	ld l,Interaction.angle
	ld (hl),ANGLE_DOWN
	ld l,Interaction.speed
	ld (hl),SPEED_20
	ret

@positions:
	.db $bf $7c ; 0 == [subid]
	.db $bf $2a ; 1
	.db $9f $94 ; 2
	.db $a3 $10 ; 3


@state1:
	ld a,(wGfxRegs1.SCY)
	ld b,a
	ld e,Interaction.var37
	ld a,(de)
	sub b
	inc e
	ld e,Interaction.yh
	ld (de),a

	call checkInteractionSubstate
	jr nz,@substate1

@substate0:
	ld a,(wGfxRegs1.SCY)
	cp $e0
	ret nz
	call interactionIncSubstate
	call objectSetVisible82

@substate1:
	ld a,(wGfxRegs1.SCY)
	cp $88
	ret z

;;
; This is used by INTERAC_TITLESCREEN_CLOUDS and INTERAC_INTRO_BIRD.
; @param[out]	a	X position
introObject_applySpeed:
	ld h,d
	ld l,Interaction.angle
	ld c,(hl)
	ld l,Interaction.speed
	ld b,(hl)
	call getPositionOffsetForVelocity
	ret z

	ld e,Interaction.var36
	ld a,(de)
	add (hl)
	ld (de),a
	inc e
	inc l
	ld a,(de)
	adc (hl)
	ld (de),a

	ld e,Interaction.x
	inc l
	ld a,(de)
	add (hl)
	ld (de),a
	inc e
	inc l
	ld a,(de)
	adc (hl)
	ld (de),a
	ret
