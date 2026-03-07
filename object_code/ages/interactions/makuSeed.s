; ==================================================================================================
; INTERAC_MAKU_SEED
;
; Variables:
;   var38: ?
; ==================================================================================================
interactionCodea6:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState
	ld a,PALH_ab
	call loadPaletteHeader
	call interactionInitGraphics

	ld hl,w1Link.yh
	ld b,(hl)
	ld l,<w1Link.xh
	ld c,(hl)
	call interactionSetPosition
	ld l,Interaction.zh
	ld (hl),$8b

	ld a,(wFrameCounter)
	cpl
	inc a
	ld e,Interaction.var38
	ld (de),a
	call objectSetVisible82
	call @createSparkle

@state1:
	ld h,d
	ld l,Interaction.zh
	ldd a,(hl)
	cp $f3
	jr c,++
	ld a,$01
	ld (wTmpcfc0.genericCutscene.state),a
	jp interactionDelete
++
	ld bc,$0080
	ld a,c
	add (hl) ; [zh]
	ldi (hl),a
	ld a,b
	adc (hl)
	ld (hl),a

	ld a,(wFrameCounter)
	ld l,Interaction.var38
	add (hl)
	and $3f
	ld a,SND_MAGIC_POWDER
	call z,playSound
	ret

;;
; Unused function?
@func_5d87:
	ldbc INTERAC_SPARKLE,$0b
	call objectCreateInteraction
	ret nz
	ld l,Interaction.counter1
	ld (hl),$c2
	call objectCopyPosition

	call getRandomNumber
	and $07
	add a
	ld bc,@offsets
	call addAToBc
	ld a,(bc)
	ld l,Interaction.yh
	add (hl)
	ld (hl),a
	inc bc
	ld a,(bc)
	ld l,Interaction.xh
	add (hl)
	ld (hl),a
	ret

@offsets:
	.db $10 $02
	.db $10 $fe
	.db $08 $05
	.db $08 $fb
	.db $0c $08
	.db $0c $f8
	.db $06 $0b
	.db $06 $f5

;;
@createSparkle:
	ldbc INTERAC_SPARKLE,$0f
	call objectCreateInteraction
	ret nz
	ld l,Interaction.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d
	ret
