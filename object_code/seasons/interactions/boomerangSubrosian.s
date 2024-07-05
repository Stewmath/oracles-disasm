; ==================================================================================================
; INTERAC_BOOMERANG_SUBROSIAN
; ==================================================================================================
interactionCodec8:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,$28
	ld e,$78
	ld (de),a
	call interactionInitGraphics
	call objectGetTileAtPosition
	ld (hl),$00
	ld hl,mainScripts.boomerangSubrosianScript
	call interactionSetScript
	call @func_78cc
@state1:
	call interactionRunScript
	call interactionPushLinkAwayAndUpdateDrawPriority
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
@substate0:
	ld h,d
	ld l,$78
	dec (hl)
	ret nz
	call interactionIncSubstate
	ld b,INTERAC_BOOMERANG
	call objectCreateInteractionWithSubid00
	jr nz,+
	ld l,$56
	ld (hl),e
	inc l
	ld (hl),d
+
	ld h,d
	ld l,$77
	ld (hl),$01
@func_78cc:
	ld l,$60
	ld (hl),$01
	jp interactionAnimate
@substate1:
	ld e,$77
	ld a,(de)
	or a
	ret nz
	ld h,d
	ld l,$45
	dec (hl)
	call @func_78cc
	call getRandomNumber_noPreserveVars
	and $3f
	add $3c
	ld e,$78
	ld (de),a
	ret
