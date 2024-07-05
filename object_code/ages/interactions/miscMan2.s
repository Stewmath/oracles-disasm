; ==================================================================================================
; INTERAC_MISC_MAN_2
; ==================================================================================================
interactionCode44:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

; NPC giving hint about what ambi wants
@subid0:
	call checkInteractionState
	jr nz,@@initialized

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	call @initGraphicsIncStateAndLoadScript

@@initialized:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc


; NPC in start-of-game cutscene who turns into an old man
@subid1:
	call checkInteractionState
	jr nz,+
	call @initGraphicsIncStateAndLoadScript
+
	call interactionRunScript
	jp interactionAnimateBasedOnSpeed


; Bearded NPC in Lynna City
@subid2:
@subid3:
	call checkInteractionState
	jr nz,@@initialized

	call getGameProgress_1
	ld c,$02
	ld a,$06
	call checkNpcShouldExistAtGameStage_body
	jp nz,interactionDelete

	ld a,b
	ld hl,lynnaMan2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call @initGraphicsAndIncState

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc


; Bearded hobo in the past, outside shooting gallery
@subid4:
	call checkInteractionState
	jr nz,@@initialized
	call getGameProgress_2
	ld a,b
	cp $03
	jp z,interactionDelete

	cp $06
	jr nz,++

	ld bc,$5878
	call interactionSetPosition
	ld a,$06
++
	ld hl,pastHoboScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call @initGraphicsAndIncState

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc


@initGraphicsAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@initGraphicsIncStateAndLoadScript:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld e,Interaction.subid
	ld a,(de)
	ld hl,miscMan2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

;;
; @param[out]	b	$00 before beating d3;
;			$01 if beat d3
;			$02 if saved Nayru;
;			$03 if beat d7;
;			$04 if got the maku seed (saw twinrova cutscene);
;			$05 if game finished (unlinked only)
getGameProgress_1:
	ld b,$05
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ret nz

	dec b
	ld a,GLOBALFLAG_SAW_TWINROVA_BEFORE_ENDGAME
	call checkGlobalFlag
	ret nz

	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr nc,@noEssences

	call getHighestSetBit
	ld c,a
	ld b,$03
	cp $06
	ret nc

	dec b
	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	ret nz

	dec b
	ld a,c
	cp $02
	ret nc

@noEssences:
	ld b,$00
	ret

;;
; @param[out]	b	$00 before beating d2;
;			$01 if beat d2;
;			$02 if beat d4;
;			$03 if saved nayru;
;			$04 if beat d7;
;			$05 if got the maku seed (saw twinrova cutscene);
;			$06 if beat veran but not twinrova (linked only);
;			$07 if game finished (unlinked only)
getGameProgress_2:
	ld b,$07
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ret nz

	dec b
	call checkIsLinkedGame
	jr z,+
	ld hl,wGroup4RoomFlags+$fc
	bit 7,(hl)
	ret nz
+
	dec b
	ld a,GLOBALFLAG_SAW_TWINROVA_BEFORE_ENDGAME
	call checkGlobalFlag
	ret nz

	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr nc,@noEssences

	call getHighestSetBit
	ld c,a
	ld b,$04
	cp $06
	ret nc

	dec b
	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	ret nz

	dec b
	ld a,c
	cp $03
	ret nc
	dec b
	ld a,c
	cp $01
	ret nc

@noEssences:
	ld b,$00
	ret


;;
unusedFunc5598:
	ld a,b
	ld hl,lynnaMan2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

;;
; Contains some preset data for checking whether certain interactions should exist at
; certain points in the game?
;
; @param	a	(0-8)
; @param	b	Return value from "getGameProgress_1"?
; @param	c	Subid "base"
; @param[out]	zflag	Set if the npc should exist
checkNpcShouldExistAtGameStage_body:
	ld hl,@table
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld e,Interaction.subid
	ld a,(de)
	sub c
	rst_addDoubleIndex

	ldi a,(hl)
	ld h,(hl)
	ld l,a
--
	ldi a,(hl)
	cp b
	ret z
	inc a
	jr z,+
	jr --
+
	or $01
	ret

@table:
	.dw @data0
	.dw @data1
	.dw @data2
	.dw @data3
	.dw @data4
	.dw @data5
	.dw @data6

@data0: ; INTERAC_FEMALE_VILLAGER subids 1-2
	.dw @@subid1
	.dw @@subid2
@@subid1:
	.db $00 $01 $02 $ff
@@subid2:
	.db $03 $04 $05 $ff


@data1: ; INTERAC_FEMALE_VILLAGER subids 3-4
	.dw @@subid3
	.dw @@subid4
@@subid3:
	.db $00 $02 $03 $04 $05 $06 $07 $ff
@@subid4:
	.db $01 $ff


@data2: ; INTERAC_FEMALE_VILLAGER subid 5
	.dw @@subid5
@@subid5:
	.db $00 $01 $02 $03 $05 $06 $ff


@data3: ; INTERAC_MALE_VILLAGER subids 4-5
	.dw @@subid4
	.dw @@subid5
@@subid4:
	.db $00 $01 $05 $ff
@@subid5:
	.db $04 $ff


@data4: ; INTERAC_MALE_VILLAGER subids 6-7
	.dw @@subid6
	.dw @@subid7

@@subid6:
	.db $00 $01 $02 $ff
@@subid7:
	.db $03 $04 $05 $06 $07 $ff


@data5: ; INTERAC_PAST_GUY subids 1-2
	.dw @@subid1
	.dw @@subid2

@@subid1:
	.db $01 $02 $ff
@@subid2:
	.db $03 $04 $07 $ff


@data6: ; INTERAC_MISC_MAN_2 subids 2-3
	.dw @@subid2
	.dw @@subid3
@@subid2:
	.db $00 $01 $02 $ff
@@subid3:
	.db $03 $04 $05 $ff



miscMan2ScriptTable:
	.dw mainScripts.pastHobo2Script
	.dw mainScripts.npcTurnedToOldManCutsceneScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript

lynnaMan2ScriptTable:
	.dw mainScripts.lynnaMan2Script_befored3
	.dw mainScripts.lynnaMan2Script_afterd3
	.dw mainScripts.lynnaMan2Script_afterNayruSaved
	.dw mainScripts.lynnaMan2Script_afterd7
	.dw mainScripts.lynnaMan2Script_afterGotMakuSeed
	.dw mainScripts.lynnaMan2Script_postGame

pastHoboScriptTable:
	.dw mainScripts.pastHoboScript_befored2
	.dw mainScripts.pastHoboScript_afterd2
	.dw mainScripts.pastHoboScript_afterd4
	.dw mainScripts.pastHoboScript_afterSavedNayru
	.dw mainScripts.pastHoboScript_afterSavedNayru
	.dw mainScripts.pastHoboScript_afterGotMakuSeed
	.dw mainScripts.pastHoboScript_twinrovaKidnappedZelda
	.dw mainScripts.pastHoboScript_postGame
