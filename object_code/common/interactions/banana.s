; ==================================================================================================
; INTERAC_BANANA
; ==================================================================================================
interactionCodec0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisible80

@state1:
	call interactionAnimate
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld l,SpecialObject.id
	ld a,(hl)
	cp SPECIALOBJECT_MOOSH_CUTSCENE
	jp nz,interactionDelete

	ld e,Interaction.direction
	ld a,(de)
	ld l,SpecialObject.direction
	cp (hl)
	ld a,(hl)
	jr z,@updatePosition

	; Direction changed

	ld (de),a
	push af
	ld hl,@visibleValues
	rst_addAToHl
	ldi a,(hl)
	ld e,Interaction.visible
	ld (de),a
	pop af
	call interactionSetAnimation

	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld l,SpecialObject.direction
	ld a,(hl)

@updatePosition:
	push hl
	ld hl,@xOffsets
	rst_addAToHl
	ld b,$00
	ld c,(hl)
	pop hl
	jp objectTakePositionWithOffset

@visibleValues:
	.db $83 $83 $80 $83

@xOffsets:
	.db $00 $05 $00 $fb
