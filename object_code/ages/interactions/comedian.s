; ==================================================================================================
; INTERAC_COMEDIAN
;
; Variables: (these are only used in scripts / bank 15 functions))
;   var37: base animation index ($00 for no mustache, $04 for mustache)
;   var3e: animation index (to be added to var37)
; ==================================================================================================
interactionCode65:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @loadScriptAndInitGraphics
	call interactionRunScript
	call interactionRunScript
	jp interactionAnimateAsNpc

@state1:
	call interactionRunScript
	jp c,interactionDelete
	callab scriptHelp.comedian_turnToFaceLink
	jp interactionAnimateAsNpc


@unusedFunc_7528:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,>TX_0b00
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
	.dw mainScripts.comedianScript
