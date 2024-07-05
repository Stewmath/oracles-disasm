; ==================================================================================================
; INTERAC_ROSA
; ==================================================================================================
interactionCode68:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01

@subid00:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	call checkIsLinkedGame
	jp z,interactionDelete

	ld a,(wEssencesObtained)
	bit 2,a
	jp nz,interactionDelete

	call @initGraphicsAndLoadScript
	call objectSetVisiblec2
	call getThisRoomFlags
	bit 6,a
	jr nz,@@alreadyGaveShovel

	; Spawn shovel object
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_MISCELLANEOUS_1
	inc l
	ld (hl),$09
	ld l,Interaction.relatedObj1+1
	ld a,d
	ld (hl),a
	ret

@@alreadyGaveShovel:
	ld hl,mainScripts.rosa_subid00Script_alreadyGaveShovel
	jp interactionSetScript

@@state1:
	call interactionRunScript
	ld a,TREASURE_SHOVEL
	call checkTreasureObtained
	jp c,npcFaceLinkAndAnimate
	jp interactionAnimateAsNpc


@subid01:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	call @loadScriptFromTableAndInitGraphics
	ld l,Interaction.var37
	ld (hl),$04
	call interactionRunScript
@@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate


; Unused
@initGraphicsAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

@initGraphicsAndLoadScript:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jr @loadScriptAndIncState


@loadScriptFromTableAndInitGraphics:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jr @loadScriptFromTableAndIncState

@loadScriptAndIncState:
	call @getScript
	call interactionSetScript
	jp interactionIncState

@loadScriptFromTableAndIncState:
	call @getScript
	inc e
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@getScript:
	ld a,>TX_1c00
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ret

@scriptTable:
	.dw mainScripts.rosa_subid00Script
	.dw @scriptTable2

@scriptTable2:
	.dw mainScripts.rosa_subid01Script
