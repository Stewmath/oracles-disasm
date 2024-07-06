; ==================================================================================================
; INTERAC_FICKLE_OLD_MAN
; ==================================================================================================
interactionCode80:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld b,$07
	call checkIfHoronVillageNPCShouldBeSeen
	ld a,c
	or a
	jp z,interactionDelete
	ld e,Interaction.subid
	ld a,b
	ld (de),a
	ld hl,@table_7717
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp objectSetVisible82
@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc
@table_7717:
	.dw mainScripts.fickleOldManScript_text1
	.dw mainScripts.fickleOldManScript_text1
	.dw mainScripts.fickleOldManScript_text2
	.dw mainScripts.fickleOldManScript_text2
	.dw mainScripts.fickleOldManScript_text3
	.dw mainScripts.fickleOldManScript_text4
	.dw mainScripts.fickleOldManScript_text4
	.dw mainScripts.fickleOldManScript_text4
	.dw mainScripts.fickleOldManScript_text5
	.dw mainScripts.fickleOldManScript_text2
	.dw mainScripts.fickleOldManScript_text6
