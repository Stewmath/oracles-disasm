; ==================================================================================================
; INTERAC_FARORE
; ==================================================================================================
interactionCode10:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	call interactionInitGraphics

	ld a,>TX_5500
	call interactionSetHighTextIndex

	ld hl,mainScripts.faroreScript
	call interactionSetScript

	ld a,GLOBALFLAG_SECRET_CHEST_WAITING
	call unsetGlobalFlag

	ld a,TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a
	ld a,$02
	ld (wTextboxPosition),a

	jp objectSetVisible82

@state1:
	ld bc,$1406
	call objectSetCollideRadii
	call interactionRunScript
	jp interactionAnimate


.ifdef ROM_SEASONS

; Indirect caller for INTERAC_FARORE_MAKECHEST
interactionCode11_caller:
	jpab bank3f.interactionCode11

.endif
