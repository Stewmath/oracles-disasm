; ==================================================================================================
; INTERAC_PAST_GIRL
; ==================================================================================================
interactionCode38:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2

	ld a,>TX_1a00
	call interactionSetHighTextIndex

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0Init

@subid0Init:
	callab agesInteractionsBank09.getGameProgress_2

	; NPC doesn't exist between beating d2 and saving Nayru
	ld a,b
	cp $01
	jp z,interactionDelete
	cp $02
	jp z,interactionDelete

	ld a,b
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call objectMarkSolidPosition
	jr @state1

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0

@subid0:
	call interactionRunScript
	jp interactionAnimateAsNpc


@scriptTable:
	.dw mainScripts.pastGirlScript_earlyGame
	.dw mainScripts.pastGirlScript_afterNayruSaved
	.dw mainScripts.pastGirlScript_afterNayruSaved
	.dw mainScripts.pastGirlScript_afterNayruSaved
	.dw mainScripts.pastGirlScript_afterd7
	.dw mainScripts.pastGirlScript_afterGotMakuSeed
	.dw mainScripts.pastGirlScript_twinrovaKidnappedZelda
	.dw mainScripts.pastGirlScript_gameFinished
