; ==================================================================================================
; INTERAC_VERAN_CUTSCENE_FACE
; ==================================================================================================
interactionCode2d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld a,PALH_87
	call loadPaletteHeader
	ld hl,mainScripts.veranFaceCutsceneScript
	call interactionSetScript

@state2:
	ret

@state1:
	call interactionAnimate
	call interactionRunScript
	ret nc
	ld hl,@warpDestVariables
	call setWarpDestVariables
	xor a
	ld (wcc50),a
	jp interactionIncState

@warpDestVariables:
	m_HardcodedWarpA ROOM_AGES_4d4, $0c, $67, $03
