; ==================================================================================================
; INTERAC_LOST_WOODS_DEKU_SCRUB
; ==================================================================================================
interactionCode5b:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics
	ld a,$86
	call loadPaletteHeader
	call interactionSetAlwaysUpdateBit
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld h,d
	ld l,$44
	ld (hl),$01
	ld l,$49
	ld (hl),$04
	ld hl,mainScripts.lostWoodsDekuScrubScript
	call interactionSetScript
@state1:
	call interactionRunScript
	call @func_7f55
	jp interactionAnimateAsNpc
@func_7f55:
	ld e,$79
	ld a,(de)
	rst_jumpTable
	.dw @@var39_00
	.dw @@var39_01
@@var39_00:
	ld h,d
	ld l,$77
	ld a,(hl)
	cp $04
	ret nz
	ld l,$79
	ld (hl),$01
	ld a,$3d
	jp playSound
@@var39_01:
	ret
