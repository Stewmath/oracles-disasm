; ==================================================================================================
; INTERAC_MISC_MAN
; ==================================================================================================
interactionCode41:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero

@subid0:
	call checkInteractionState
	jr nz,++
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete
	call @initGraphicsIncStateAndLoadScript
++
	call interactionRunScript
	jp npcFaceLinkAndAnimate

@subidNonzero:
	call checkInteractionState
	jr nz,@@initialized

	ld a,$01
	ld e,Interaction.oamFlags
	ld (de),a

	callab getGameProgress_1
	ld e,Interaction.subid
	ld a,(de)
	dec a
	cp b
	jp nz,interactionDelete

	ld hl,@scriptTable+2
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld a,>TX_2600
	call interactionSetHighTextIndex
	call @initGraphicsAndIncState

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc

@initGraphicsAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

;;
@initGraphicsIncStateAndLoadScript:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,>TX_2600
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
	.dw mainScripts.manOutsideD2Script
	.dw mainScripts.lynnaManScript_befored3
	.dw mainScripts.lynnaManScript_afterd3
	.dw mainScripts.lynnaManScript_afterNayruSaved
	.dw mainScripts.lynnaManScript_afterd7
	.dw mainScripts.lynnaManScript_afterGotMakuSeed
	.dw mainScripts.lynnaManScript_postGame
