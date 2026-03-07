; ==================================================================================================
; INTERAC_MUSTACHE_MAN
; ==================================================================================================
interactionCode42:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
	call checkInteractionState
	jr nz,@@initialized

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	call @initGraphicsAndScript
@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc

@subid1:
	call checkInteractionState
	jr nz,@@initialized

	ld e,Interaction.var32
	ld a,$02
	ld (de),a
	call @initGraphicsAndScript

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc

; Unused
@func_52e8:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

@initGraphicsAndScript:
	call interactionInitGraphics
	call objectMarkSolidPosition

	ld a,>TX_0f00
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
	.dw mainScripts.mustacheManScript
	.dw mainScripts.genericNpcScript
