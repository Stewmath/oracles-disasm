; ==================================================================================================
; INTERAC_LINKED_CUTSCENE
; ==================================================================================================
interactionCodeb3:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
	call checkIsLinkedGame
	jp nz,interactionDelete
	ld a,GLOBALFLAG_WITCHES_1_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	jr @postCutscene

@subid1:
	call checkIsLinkedGame
	jp nz,interactionDelete
	ld a,GLOBALFLAG_WITCHES_2_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDelete
	jr @postCutscene

@subid2:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	jr @postCutscene

@subid3:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDelete
	jr @postCutscene

@subid4:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,GLOBALFLAG_FLAMES_OF_DESTRUCTION_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete

@postCutscene:
	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	ld hl,$cfc0
	ld (hl),$00
	ld a,>TX_5000
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

@state1:
	call interactionRunScript
	jp c,interactionDelete
	ret

@scriptTable:
	.dw mainScripts.linkedCutsceneScript_witches1
	.dw mainScripts.linkedCutsceneScript_witches2
	.dw mainScripts.linkedCutsceneScript_zeldaVillagers
	.dw mainScripts.linkedCutsceneScript_zeldaKidnapped
	.dw mainScripts.linkedCutsceneScript_flamesOfDestruction
