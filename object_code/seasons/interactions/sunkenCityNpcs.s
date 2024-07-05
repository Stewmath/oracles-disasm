; ==================================================================================================
; INTERAC_FLOODED_HOUSE_GIRL
; INTERAC_MASTER_DIVERS_WIFE
; INTERAC_MASTER_DIVER
; ==================================================================================================
interactionCode8a:
interactionCode8b:
interactionCode8d:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	ld e,$41
	ld a,(de)
	cp INTERAC_MASTER_DIVER
	jr nz,+
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jp nc,interactionDelete
	call getHighestSetBit
	cp $02
	jp c,interactionDelete
	; master diver - at least 3rd essence gotten
+
	call getSunkenCityNPCVisibleSubId_caller
	ld e,$42
	ld a,(de)
	cp b
	jp nz,interactionDelete
	cp $01
	jr nz,@npcShouldAppear
	; 4th essence gotten
	ld e,$41
	ld a,(de)
	cp INTERAC_MASTER_DIVERS_WIFE
	jr nz,@npcShouldAppear
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	ld b,<ROOM_SEASONS_05d
	jr nz,@wifeShouldAppear
	ld b,<ROOM_SEASONS_1b6
@wifeShouldAppear:
	ld a,(wActiveRoom)
	cp b
	jp nz,interactionDelete
@npcShouldAppear:
	call interactionInitGraphics
	ld e,$49
	ld a,$04
	ld (de),a
	ld e,$41
	ld a,(de)
	ld hl,@floodedHouseGirlScripts
	cp INTERAC_FLOODED_HOUSE_GIRL
	jr z,@setScript
	ld hl,@masterDiversWifeScripts
	cp INTERAC_MASTER_DIVERS_WIFE
	jr z,@setScript
	ld hl,@masterDiverScripts
@setScript:
	ld e,$42
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc

@floodedHouseGirlScripts:
	.dw mainScripts.floodedHouseGirlScript_text1
	.dw mainScripts.floodedHouseGirlScript_text2
	.dw mainScripts.floodedHouseGirlScript_text3
	.dw mainScripts.floodedHouseGirlScript_text4
	.dw mainScripts.floodedHouseGirlScript_text5

@masterDiversWifeScripts:
	.dw mainScripts.masterDiversWifeScript_text1
	.dw mainScripts.masterDiversWifeScript_text2
	.dw mainScripts.masterDiversWifeScript_text3
	.dw mainScripts.masterDiversWifeScript_text4
	.dw mainScripts.masterDiversWifeScript_text5

@masterDiverScripts:
	.dw mainScripts.masterDiverScript_text1
	.dw mainScripts.masterDiverScript_text2
	.dw mainScripts.masterDiverScript_text3
	.dw mainScripts.masterDiverScript_text4
	.dw mainScripts.masterDiverScript_text5
