; ==================================================================================================
; INTERAC_PAST_OLD_LADY
; ==================================================================================================
interactionCode45:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1


; Lady whose husband was sent to work on black tower
@subid0:
	call checkInteractionState
	jr nz,@@initialized

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	call @initGraphicsTextAndScript

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc


@subid1:
	call checkInteractionState
	jr nz,@@initialized

	callab getGameProgress_2
	ld a,b
	cp $04
	jp nc,interactionDelete

	ld hl,@subid1ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld a,>TX_1800
	call interactionSetHighTextIndex
	call @initGraphicsAndIncState

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc


@initGraphicsAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@initGraphicsTextAndScript:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,>TX_1800
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState


@scriptTable:
	.dw mainScripts.pastOldLadySubid0Script
	.dw mainScripts.stubScript

@subid1ScriptTable:
	.dw mainScripts.pastOldLadySubid1Script_befored2
	.dw mainScripts.pastOldLadySubid1Script_afterd2
	.dw mainScripts.pastOldLadySubid1Script_afterd4
	.dw mainScripts.pastOldLadySubid1Script_afterSavedNayru
