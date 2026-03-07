; ==================================================================================================
; INTERAC_MOBLIN
; ==================================================================================================
interactionCode96:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
@subid1:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @initGraphicsAndLoadScript
@state1:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var3f
	ld a,(de)
	or a
	jr nz,+
	call interactionAnimate
+
	jp interactionPushLinkAwayAndUpdateDrawPriority

@initGraphics: ; unused
	call interactionInitGraphics
	jp interactionIncState

@initGraphicsAndLoadScript:
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.moblin_subid00Script
	.dw mainScripts.moblin_subid01Script
