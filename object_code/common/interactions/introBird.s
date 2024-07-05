; ==================================================================================================
; INTERAC_INTRO_BIRD
; ==================================================================================================
interactionCoded3:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	; counter2: How long the bird should remain (it will respawn if it goes off-screen
	; before counter2 reaches 0)
	ld h,d
	ld l,Interaction.counter2
	ld (hl),45

	; Determine direction to move in based on subid
	ld l,Interaction.subid
	ld a,(hl)
	ld b,$00
	ld c,$1a
	cp $04
	jr c,+
	inc b
	ld c,$06
+
	ld l,Interaction.angle
	ld (hl),c
	ld l,Interaction.speed
	ld (hl),SPEED_140

	push af
	ld a,b
	call interactionSetAnimation

	pop af

@initializePositionAndCounter1:
	ld b,a
	add a
	add b
	ld hl,@birdPositionsAndAppearanceDelays
	rst_addAToHl
	ldi a,(hl)
	ld b,(hl)
	inc l
	ld c,(hl)
	ld h,d
	ld l,Interaction.var37
	ld (hl),a
	ld l,Interaction.yh
	ldi (hl),a
	inc l
	ld (hl),b
	ld l,Interaction.counter1
	ld (hl),c
	ret

@state1:
	; Update Y
	ld a,(wGfxRegs1.SCY)
	ld b,a
	ld e,Interaction.var37
	ld a,(de)
	sub b
	inc e
	ld e,Interaction.yh
	ld (de),a

	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,(wGfxRegs1.SCY)
	cp $10
	ret nz
	jp interactionIncSubstate

@substate1:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	jp objectSetVisible82

@substate2:
	ld e,Interaction.counter2
	ld a,(de)
	or a
	jr z,+
	dec a
	ld (de),a
+
	call interactionAnimate
	call introObject_applySpeed
	cp $b0
	ret c

	; Bird is off-screen; check whether to "reset" the bird or just delete it.
	ld h,d
	ld l,Interaction.counter2
	ld a,(hl)
	or a
	jp z,interactionDelete

	ld l,Interaction.substate
	dec (hl)
	ld l,Interaction.subid
	ld a,(hl)
	call @initializePositionAndCounter1

	; Set counter1 (the delay before reappearing) randomly
	call getRandomNumber_noPreserveVars
	and $0f
	ld h,d
	ld l,Interaction.counter1
	ld (hl),a
	jp objectSetInvisible


; Data format:
;   b0: Y
;   b1: X
;   b2: counter1 (delay before appearing)
@birdPositionsAndAppearanceDelays:
	.db $4c $18 $01 ; 0 == [subid]
	.db $58 $20 $10 ; 1
	.db $5a $30 $14 ; 2
	.db $50 $28 $16 ; 3
	.db $50 $74 $04 ; 4
	.db $4c $84 $0a ; 5
	.db $5c $8c $12 ; 6
	.db $58 $7c $17 ; 7
