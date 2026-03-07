; ==================================================================================================
; INTERAC_DINS_CRYSTAL_FADING
; ==================================================================================================
interactionCodea6:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,$42
	ld a,(hl)
	add a
	add a
	add a
	add $04
	; angles are $04, $0c, $14, $1c
	ld l,Interaction.angle
	ld (hl),a
	ld l,$50
	ld (hl),$64
	ld l,$46
	ld (hl),$08
	jp objectSetVisible81
@state1:
	ld e,$45
	ld a,(de)
	or a
	jr nz,@substate1
	call interactionDecCounter1
	jr nz,@applySpeedTwice
	call interactionIncSubstate
	ld l,$46
	ld (hl),$14
@applySpeedTwice:
	call objectApplySpeed
	jp objectApplySpeed
@substate1:
	call interactionDecCounter1
	jp z,interactionDelete
	ld a,(wFrameCounter)
	xor d
	rrca
	ld l,$5a
	set 7,(hl)
	jr nc,@applySpeedTwice
	res 7,(hl)
	jr @applySpeedTwice
