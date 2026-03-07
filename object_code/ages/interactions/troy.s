; ==================================================================================================
; INTERAC_TROY
; ==================================================================================================
interactionCodeca:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1


@subid0:
	call checkInteractionState
	jr nz,@state1

	; State 0
	call @initialize
	ld a,(wScreenTransitionDirection)
	or a
	jr nz,@state1
	ld (wTmpcfc0.targetCarts.beganGameWithTroy),a

@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc


@subid1:
	call checkInteractionState
	jr nz,@state1

	; State 0
	jp @initialize


; Unused
@func_7781:
	call interactionInitGraphics
	jp interactionIncState


@initialize:
	call interactionInitGraphics
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
	.dw mainScripts.troySubid0Script
	.dw mainScripts.troySubid1Script
