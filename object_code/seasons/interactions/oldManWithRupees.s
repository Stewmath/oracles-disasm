; ==================================================================================================
; INTERAC_OLD_MAN_WITH_RUPEES
; ==================================================================================================
interactionCode99:
	call checkInteractionState
	jr nz,@state1
	inc a
	ld (de),a
	call interactionInitGraphics
	ld a,>TX_1f00
	call interactionSetHighTextIndex
	ld e,$42
	ld a,(de)
	ld hl,table_587b
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld h,d
	ld l,$4b
	ld (hl),$38
	ld l,$4d
	ld (hl),$80
@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate
table_587b:
	.dw mainScripts.oldManScript_givesRupees
	.dw mainScripts.oldManScript_givesRupees
	.dw mainScripts.oldManScript_givesRupees
	.dw mainScripts.oldManScript_givesRupees
	.dw mainScripts.oldManScript_givesRupees
	.dw mainScripts.oldManScript_takesRupees
	.dw mainScripts.oldManScript_takesRupees
	.dw mainScripts.oldManScript_takesRupees
