; ==================================================================================================
; INTERAC_EXPLOSION_WITH_DEBRIS
; ==================================================================================================
interactionCode99:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible81
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02

@initSubid00:
	inc e
	ld a,(de) ; [var03]
	or a
	ret z

	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@subid0Positions
	rst_addDoubleIndex
	call getRandomNumber
	and $07
	sub $03
	add (hl)
	ld b,a
	inc hl
	call getRandomNumber
	and $07
	sub $03
	add (hl)
	ld c,a
	jp interactionSetPosition

@initSubid02:
	ld e,Interaction.var38
	ld a,(de)
	res 6,a
	ld e,Interaction.visible
	ld (de),a

@initSubid01:
	; Determine angle based on var03 with a small random element
	call getRandomNumber_noPreserveVars
	and $03
	add $02
	ld c,a
	ld h,d
	ld l,Interaction.var03
	ld a,(hl)
	add a
	add a
	add a
	add c
	and $1f
	ld l,Interaction.angle
	ld (hl),a

	; Set speed randomly
	call getRandomNumber
	and $03
	ld bc,@subid1And2Speeds
	call addAToBc
	ld a,(bc)
	ld l,Interaction.speed
	ld (hl),a
	ld l,Interaction.speedZ
	ld (hl),<(-$180)
	inc l
	ld (hl),>(-$180)
	ret

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid0
	.dw @runSubid1Or2
	.dw @runSubid1Or2

@runSubid0:
	call interactionAnimate
	ld e,Interaction.animParameter
	ld a,(de)
	or a
	ret z
	inc a
	jp z,interactionDelete

	xor a
	ld (de),a
	ldh (<hFF8B),a
	ldh (<hFF8D),a
	ldh (<hFF8C),a

	; Spawn 4 pieces of debris
	ld b,$04
--
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_EXPLOSION_WITH_DEBRIS
	inc l
	inc (hl)
	inc l
	ld (hl),b
	call objectCopyPosition
	dec b
	jr nz,--
	ret

@subid1And2Speeds:
	.db SPEED_180
	.db SPEED_1c0
	.db SPEED_200
	.db SPEED_240

@runSubid1Or2:
	call objectApplySpeed
	ld c,$28
	call objectUpdateSpeedZ_paramC
	jp z,interactionDelete
	ret

; One of these positions is picked at random
@subid0Positions:
	.db $48 $48
	.db $48 $58
	.db $58 $48
	.db $58 $58
