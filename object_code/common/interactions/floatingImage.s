; ==================================================================================================
; INTERAC_FLOATING_IMAGE
; ==================================================================================================
interactionCodea0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	call interactionSetAlwaysUpdateBit
	call interactionInitGraphics

	; Set 'b' to the angle to veer off toward (left or right, depending on var03)
	ld h,d
	ld b,$03
	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr nz,+
	ld b,$1d
+
	ld l,Interaction.angle
	ld (hl),b
	ld l,Interaction.speed
	ld (hl),SPEED_60

	; Delete after 70 frames
	ld l,Interaction.counter1
	ld (hl),70

	jp objectSetVisible80

@state1:
	; Check whether it's a snore or a music note (but the behaviour is the same)
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,+
+
	; Delete after 70 frames
	call interactionDecCounter1
	jp z,interactionDelete

	call objectApplySpeed
	ld e,Interaction.var30
	ld (de),a

	; Update x position every 8 frames based on wFrameCounter
	ld a,(wFrameCounter)
	and $07
	ret nz

	push de
	ld h,d
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld de,@xOffsets
	call addAToDe
	ld a,(de)
	ld l,Interaction.var30
	add (hl)
	ld l,Interaction.xh
	ld (hl),a
	pop de
	ret

@xOffsets:
	.db $ff $fe $ff $00
	.db $01 $02 $01 $00
