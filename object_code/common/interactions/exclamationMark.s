; ==================================================================================================
; INTERAC_EXCLAMATION_MARK
; ==================================================================================================
interactionCode9f:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld h,d

	; Always update, even when textboxes are up
	ld l,Interaction.enabled
	set 7,(hl)

	call interactionInitGraphics
	jp objectSetVisible80

@state1:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	inc a
	jp z,interactionAnimate
	dec (hl)
	jp nz,interactionAnimate
	jp interactionDelete

;;
; Called from "objectCreateExclamationMark" in bank 0.
; Creates an "exclamation mark" interaction, complete with sound effect.
;
; @param	a	How long to show the exclamation mark for (0 or $ff for
;                       indefinitely).
; @param	bc	Offset from the object to create the exclamation mark at.
; @param	d	The object to use for the base position of the exclamation mark.
objectCreateExclamationMark_body:
	ldh (<hFF8B),a
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERAC_EXCLAMATION_MARK
	ld l,Interaction.counter1
	ldh a,(<hFF8B)
	ld (hl),a
	call objectCopyPositionWithOffset

	push hl
	ld a,SND_CLINK
	call playSound
	pop hl
	ret

;;
; Create an interaction with id $a0 (INTERAC_FLOATING_IMAGE). Its position will be
; placed at the current object's position + bc.
;
; @param	bc	Offset relative to object to place the interaction at
; @param	hFF8D	Interaction.subid (0 for snore, 1 for music note)
; @param	hFF8B	Interaction.var03 (0 to float left, 1 to float right)
objectCreateFloatingImage:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_FLOATING_IMAGE
	inc l
	ldh a,(<hFF8D)
	ldi (hl),a
	ldh a,(<hFF8B)
	ld (hl),a
	jp objectCopyPositionWithOffset
