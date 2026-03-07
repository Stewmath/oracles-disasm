; ==================================================================================================
; INTERAC_KING_ZORA
; ==================================================================================================
interactionCode9c:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2


; Present King Zora
@subid0:
	ld a,(de)
	or a
	jr z,@subid0State0

@state1:
	call interactionRunScript
	jp interactionAnimate

@subid0State0:
	ld a,GLOBALFLAG_KING_ZORA_CURED
	call checkGlobalFlag
	jp z,interactionDelete
	call @choosePresentKingZoraScript

@setScriptAndInit:
	call interactionSetScript
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState
	ld a,$0a
	call objectSetCollideRadius
	jp objectSetVisible82


; Past King Zora
@subid1:
	ld a,(de)
	or a
	jr nz,@state1

	call @choosePastKingZoraScript
	jr @setScriptAndInit


; Potion sprite
@subid2:
	ld a,(de)
	or a
	jr z,@subid2State0

@subid2State1:
	call interactionDecCounter1
	ret nz
	jp interactionDelete

@subid2State0:
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),$24
	jp objectSetVisible81


@choosePresentKingZoraScript:
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	jr z,@@pollutionNotFixed

	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	bit 6,a
	jr z,@@justCleanedWater

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ld hl,mainScripts.kingZoraScript_present_afterD7
	ret z

	ld a,TREASURE_SWORD
	call checkTreasureObtained
	and $01
	ld e,Interaction.var03
	ld (de),a
	ld hl,mainScripts.kingZoraScript_present_postGame
	ret

@@pollutionNotFixed:
	ld a,TREASURE_LIBRARY_KEY
	call checkTreasureObtained
	ld hl,mainScripts.kingZoraScript_present_acceptedTask
	ret c

	call getThisRoomFlags
	bit 6,(hl)
	ld hl,mainScripts.kingZoraScript_present_firstTime
	ret z
	ld hl,mainScripts.kingZoraScript_present_giveKey
	ret

@@justCleanedWater:
	ld a,GLOBALFLAG_GOT_PERMISSION_TO_ENTER_JABU
	call checkGlobalFlag
	ld hl,mainScripts.kingZoraScript_present_justCleanedWater
	ret z
	ld hl,mainScripts.kingZoraScript_present_cleanedWater
	ret

@choosePastKingZoraScript:
	ld a,GLOBALFLAG_KING_ZORA_CURED
	call checkGlobalFlag
	jr z,@@notCured

	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld hl,mainScripts.kingZoraScript_past_justCured
	ret z

	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	bit 6,a
	ld hl,mainScripts.kingZoraScript_past_cleanedWater
	ret z
	ld hl,mainScripts.kingZoraScript_past_afterD7
	ret

@@notCured:
	ld a,TREASURE_POTION
	call checkTreasureObtained
	ld hl,mainScripts.kingZoraScript_past_dontHavePotion
	ret nc
	ld hl,mainScripts.kingZoraScript_past_havePotion
	ret
