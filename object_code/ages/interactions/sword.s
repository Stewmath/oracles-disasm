; ==================================================================================================
; INTERAC_SWORD
; ==================================================================================================
interactionCode5e:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	; var37 holds last animation (set $ff to force update)
	ld a,$ff
	ld e,Interaction.var37

	ld (de),a
	call interactionInitGraphics

@state1:
	; Invisible by default
	call objectSetInvisible

	; If [relatedObj1.enabled] & ([this.var3f]+1) == 0, delete self
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld l,Interaction.var3f
	ld a,(hl)
	inc a
	ld l,Interaction.enabled
	and (hl)
	jp z,interactionDelete

	; Set visible if bit 7 of [relatedObj1.animParameter] is set
	ld l,Interaction.animParameter
	ld a,(hl)
	ld b,a
	and $80
	ret z

	; Animation number = [relatedObj1.animParameter]&0x7f
	ld a,b
	and $7f
	push hl
	ld h,d
	ld l,Interaction.var37
	cp (hl)
	jr z,+
	ld (hl),a
	call interactionSetAnimation
+
	pop hl
	call objectTakePosition
	jp objectSetVisible83
