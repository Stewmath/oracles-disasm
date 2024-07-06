; ==================================================================================================
; INTERAC_74
; ==================================================================================================
interactionCode74:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7
	.dw @subid8
	.dw @subid9
	.dw @subidA
	.dw @subidB
	.dw @subidC
@subid0:
@subid1:
@subid3:
@subid5:
@subid8:
@subid9:
	call @func_7283
	jr nz,@func_7218
@func_7208:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ld a,$57
	call loadPaletteHeader
	call interactionInitGraphics
	jp objectSetVisible80
@func_7218:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@table_7229
	rst_addAToHl
	ld a,($cbbf)
	add (hl)
	ld e,$4b
	ld (de),a
	jp interactionAnimate
@table_7229:
	.db $e8 $58 $00 $e0
	.db $00 $10 $00 $00
	.db $10 $10
@subid2:
	call @func_7283
	ret nz
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	call checkGlobalFlag
	jp nz,interactionDelete
	call @func_725b
	jr @func_7208
@subid4:
@subid7:
	call @func_7283
	jp nz,interactionAnimate
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	call checkGlobalFlag
	jp z,interactionDelete
	call @func_7208
	ld e,Interaction.subid
	ld a,(de)
	cp $04
	ret nz
@func_725b:
	ld bc,$30e8
	ld e,$0a
	call @func_7268
	ld bc,$3018
	ld e,$0b
@func_7268:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_74
	inc l
	ld (hl),e
	ld e,$4b
	ld a,(de)
	add b
	ld l,e
	ld (hl),a
	ld e,$4d
	ld a,(de)
	add c
	ld l,e
	ld (hl),a
	ret
@subid6:
@subidA:
@subidB:
	call @func_7283
	ret nz
	jr @func_7208
@func_7283:
	ld e,Interaction.state
	ld a,(de)
	or a
	ret
@subidC:
	call @func_7283
	jp nz,interactionAnimate
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp nz,interactionDelete
	jp @func_7208
