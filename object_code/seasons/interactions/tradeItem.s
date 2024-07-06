; ==================================================================================================
; INTERAC_TRADE_ITEM
; ==================================================================================================
interactionCode5d:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics
	ld a,$06
	call objectSetCollideRadius
	ld l,$44
	inc (hl)
	jp objectSetVisiblec0
@state1:
	ld e,$42
	ld a,(de)
	ld hl,$cfde
	call checkFlag
	jp nz,interactionDelete
	jp objectPreventLinkFromPassing
