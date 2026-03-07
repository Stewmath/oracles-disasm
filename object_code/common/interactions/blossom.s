; ==================================================================================================
; INTERAC_BLOSSOM
; ==================================================================================================
interactionCode2b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics
	ld a,>TX_4400
	call interactionSetHighTextIndex
	call interactionIncState

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initAnimation0
	.dw @initAnimation0
	.dw @initAnimation4
	.dw @initAnimation0
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4

@initAnimation0:
	ld a,$00
	call interactionSetAnimation
	jp @updateCollisionAndVisibility

@initAnimation4:
	ld a,$04
	call interactionSetAnimation
	jp @updateCollisionAndVisibility

@state1:
	call interactionRunScript
	jp @updateAnimation

@updateAnimation:
	call interactionAnimate

@updateCollisionAndVisibility:
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects

@scriptTable:
	.dw mainScripts.blossomScript0
	.dw mainScripts.blossomScript1
	.dw mainScripts.blossomScript2
	.dw mainScripts.blossomScript3
	.dw mainScripts.blossomScript4
	.dw mainScripts.blossomScript5
	.dw mainScripts.blossomScript6
	.dw mainScripts.blossomScript7
	.dw mainScripts.blossomScript8
	.dw mainScripts.blossomScript9
