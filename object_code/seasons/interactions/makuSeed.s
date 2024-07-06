; ==================================================================================================
; INTERAC_MAKU_SEED
; ==================================================================================================
interactionCode93:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
	call checkInteractionState
	ret nz
	call @func_5298
	call objectSetVisible80
	ld a,(wc6e5)
	ld b,$04
	cp $06
	jr z,+
	cp $07
	jp nz,interactionDelete
	ld a,$01
	call interactionSetAnimation
	ld b,$08
+
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_SPARKLE
	inc l
	ld (hl),$04
	call objectCopyPosition
	ld l,Interaction.yh
	ld a,(hl)
	add b
	ld (hl),a
	ret

@func_5298:
	ld a,$ab
	call loadPaletteHeader
	call interactionInitGraphics
	jp interactionIncState

@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call @func_5298
	ld l,$4b
	ld (hl),$65
	ld l,$4d
	ld (hl),$50
	ld l,$4f
	ld (hl),$8b
	ld a,$02
	call interactionSetAnimation
	ld a,(wFrameCounter)
	cpl
	inc a
	ld e,$78
	ld (de),a
	call @func_5338

@state1:
	ld h,d
	ld l,$4f
	ldd a,(hl)
	cp $ed
	jp nc,interactionDelete
	ld bc,$0080
	ld a,c
	add (hl)
	ldi (hl),a
	ld a,b
	adc (hl)
	ld (hl),a
	ld a,(wFrameCounter)
	ld l,$78
	add (hl)
	push af
	and $0f
	call z,@func_52f3
	pop af
	and $3f
	ld a,$83
	call z,playSound
	jp objectSetPriorityRelativeToLink_withTerrainEffects

@func_52f3:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_SPARKLE
	inc l
	ld (hl),$03
	ld e,$4b
	ld l,$4b
	ld a,(de)
	ldi (hl),a
	inc e
	inc e
	inc l
	ld a,(de)
	ldi (hl),a
	ld e,$4f
	ld l,$4b
	call objectApplyComponentSpeed@addSpeedComponent
	call getRandomNumber
	and $07
	add a
	push de
	ld de,@table_5328
	call addAToDe
	ld a,(de)
	ld l,Interaction.yh
	add (hl)
	ld (hl),a
	inc de
	ld a,(de)
	ld l,Interaction.xh
	add (hl)
	ld (hl),a
	pop de
	ret

@table_5328:
	.db $10 $02
	.db $10 $fe
	.db $08 $05
	.db $08 $fb
	.db $0c $08
	.db $0c $f8
	.db $06 $0b
	.db $06 $f5

@func_5338:
	ldbc INTERAC_SPARKLE $08
	call objectCreateInteraction
	ret nz
	ld l,Interaction.relatedObj1
	ld a,$40
	ldi (hl),a
	ld (hl),d
	ret
