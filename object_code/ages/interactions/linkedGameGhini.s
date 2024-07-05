; ==================================================================================================
; INTERAC_LINKED_GAME_GHINI
;
; Variables:
;   var3f: Secret index (for "linkedGameNpcScript")
; ==================================================================================================
interactionCodecb:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @initialize
	ld h,d
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld l,Interaction.var3f
	ld (hl),GRAVEYARD_SECRET & $0f
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript

@state1:
	call interactionRunScript
	jp c,interactionDeleteAndUnmarkSolidPosition
	jp interactionAnimateAsNpc

@initialize:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

; Unused
@func_77c7:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,>TX_4d00
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
	.dw mainScripts.linkedGameNpcScript
