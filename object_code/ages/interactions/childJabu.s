; ==================================================================================================
; INTERAC_CHILD_JABU
; ==================================================================================================
interactionCodeba:
	call checkInteractionState
	jr nz,@state0

@state1:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState
	ld bc,$0e06
	call objectSetCollideRadii
	ld hl,mainScripts.childJabuScript
	call interactionSetScript
	jp objectSetVisible82

@state0:
	call interactionAnimateAsNpc
	jp interactionRunScript
