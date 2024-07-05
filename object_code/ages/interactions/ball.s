; ==================================================================================================
; INTERAC_BALL
; ==================================================================================================
interactionCode95:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_200
	call interactionInitGraphics
	jp objectSetVisible80

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,($cfd3)
	or a
	ret z
	call interactionIncSubstate
	ld b,ANGLE_RIGHT
	dec a
	jr z,+
	ld b,ANGLE_LEFT
+
	ld l,Interaction.angle
	ld (hl),b
	ld l,Interaction.subid
	ld (hl),a
	cp $02
	jr nz,++
	ld bc,$5075
	call interactionHSetPosition
	ld l,Interaction.zh
	ld (hl),-$06
++
	ld bc,-$1c0
	jp objectSetSpeedZ

@substate1:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	; Ball has landed

	ld e,Interaction.subid
	ld a,(de)
	cp $02
	jr z,@subid2

	dec a
	ld bc,$4a3c
	jr z,+
	ld c,$75
+
	xor a
	ld ($cfd3),a
	ld e,Interaction.substate
	ld (de),a
	jp interactionSetPosition

@subid2:
	; [speedZ] = -[speedZ]/2
	ld l,Interaction.speedZ+1
	ldd a,(hl)
	srl a
	ld b,a
	ld a,(hl)
	rra
	cpl
	add $01
	ldi (hl),a
	ld a,b
	cpl
	adc $00
	ldd (hl),a

	; Go to substate 2 (stop doing anything) if the ball's Z speed has gone too low
	ld bc,$ff80
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call compareHlToBc
	ret c
	jp interactionIncSubstate

@substate2:
	ret
