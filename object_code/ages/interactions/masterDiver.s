; ==================================================================================================
; INTERAC_MASTER_DIVER
;
; Variables:
;   var3f: Secret index (for "linkedGameNpcScript")
; ==================================================================================================
interactionCodecd:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @initialize
	ld l,Interaction.var3f
	ld (hl),DIVER_SECRET & $0f
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	call interactionRunScript

@state1:
	call interactionRunScript
	jp c,interactionDeleteAndUnmarkSolidPosition
	jp interactionAnimateAsNpc

@initialize:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

;;
; Unused
@func_7840:
	call interactionInitGraphics
	call objectMarkSolidPosition
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
	; Apparently this is empty
