; ==================================================================================================
; INTERAC_MAYORS_HOUSE_UNLINKED_GIRL
; ==================================================================================================
interactionCodec2:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld hl,mainScripts.mayorsHouseGirlScript
	call interactionSetScript
	jp interactionAnimateAsNpc
@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc
