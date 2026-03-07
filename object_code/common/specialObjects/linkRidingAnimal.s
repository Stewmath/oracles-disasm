specialObjectCode_linkRidingAnimal:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call dropLinkHeldItem
	call clearAllParentItems
	call specialObjectSetOamVariables

	ld h,d
	ld l,SpecialObject.state
	inc (hl)
	ld l,SpecialObject.collisionType
	ld a, $80 | ITEMCOLLISION_LINK
	ldi (hl),a

	inc l
	ld a,$06
	ldi (hl),a ; [collisionRadiusY] = $06
	ldi (hl),a ; [collisionRadiusX] = $06
	call @readCompanionAnimParameter
	jp objectSetVisiblec1

	; Unused code? (Revert back to ordinary Link code)
	lda SPECIALOBJECT_LINK
	call setLinkIDOverride
	ld b,INTERAC_GREENPOOF
	jp objectCreateInteractionWithSubid00

@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call updateLinkDamageTaken

	call retIfTextIsActive
	ld a,(wScrollMode)
	and $0e
	ret nz

	ld a,(wDisabledObjects)
	rlca
	ret c
	call linkUpdateKnockback

;;
; Copies companion's animParameter & $3f to var31.
@readCompanionAnimParameter:
	ld hl,w1Companion.animParameter
	ld a,(hl)
	and $3f
	ld e,SpecialObject.var31
	ld (de),a
	ret
