; ==================================================================================================
; INTERAC_GHINI_HARASSING_MOOSH
; ==================================================================================================
interactionCode73:
	ld h,d
	ld l,Interaction.subid
	ldi a,(hl)
	or a
	jr nz,@checkState

	inc l
	ld a,(hl)
	or a
	jr z,@checkState

	ld a,(wScrollMode)
	and $0e
	ret nz

@checkState:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	; Delete self if they shouldn't be here right now
	ld a,(wEssencesObtained)
	bit 1,a
	jr z,@delete

	ld a,(wPastRoomFlags+$79)
	bit 6,a
	jr z,@delete

	ld a,(wMooshState)
	and $60
	jr nz,@delete

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.zh
	ld (hl),-2

	; Load script
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp objectSetVisiblec0

@state1:
	call interactionAnimate
	ld e,Interaction.speed
	ld a,(de)
	or a
	jr z,++

	; While the ghini is moving, make them "rotate" in position.
	call objectApplySpeed
	ld e,Interaction.angle
	ld a,(de)
	dec a
	and $1f
	ld (de),a
	cp $18
	jr nz,++

	xor a
	ld e,Interaction.speed
	ld (de),a
++
	call interactionRunScript
	ret nc
@delete:
	jp interactionDelete

@scriptTable:
	.dw mainScripts.ghiniHarassingMoosh_subid00Script
	.dw mainScripts.ghiniHarassingMoosh_subid01Script
	.dw mainScripts.ghiniHarassingMoosh_subid02Script
