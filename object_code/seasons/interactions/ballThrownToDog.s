; ==================================================================================================
; INTERAC_BALL_THROWN_TO_DOG
; ==================================================================================================
interactionCode83:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	ld h,d
	call @func_7aea
	ld l,$50
	ld (hl),$3c
	ld l,$49
	ld (hl),$18
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERAC_HORON_DOG
	ld l,$57
	ld (hl),d
	ld bc,$00f4
	call objectCopyPositionWithOffset
	ld l,$4d
	ld a,(hl)
	ld l,$76
	ld (hl),a
+
	call interactionInitGraphics
	jp objectSetVisible82
@func_7aea:
	ld l,$4e
	ld (hl),$ff
	inc l
	ld (hl),$fc
	ret
@state1:
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld h,d
	ld l,$5a
	res 6,(hl)
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@susbtate0
	.dw @@susbtate1
	.dw @@susbtate2
@@susbtate0:
	ld a,($cceb)
	cp $01
	ret nz
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,table_7b59
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,$54
	ld (de),a
	ld a,(hl)
	inc e
	ld (de),a
	jp interactionIncSubstate
@@susbtate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	ld l,$55
	ldd a,(hl)
	srl a
	ld b,a
	ld a,(hl)
	rra
	cpl
	add $01
	ldi (hl),a
	ld a,b
	cpl
	adc $00
	ldd (hl),a
	ld bc,$ffa0
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call compareHlToBc
	ret c
	jp interactionIncSubstate
@@susbtate2:
	ld a,($cceb)
	cp $02
	ret nz
	xor a
	ld (de),a
	ld h,d
	ld l,$76
	ld e,$4b
	ldi a,(hl)
	ld (de),a
	inc e
	inc e
	ld a,(hl)
	ld (de),a
	jp @func_7aea
table_7b59:
	; speedZ
	.dw $fee0
	.dw $fe80
	.dw $fe20
	.dw $fdc0
