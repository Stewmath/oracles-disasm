; ==================================================================================================
; INTERAC_97
; ==================================================================================================
interactionCode97:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw interaction97_subid00
	.dw interaction97_subid01

interaction97_subid00:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionDecCounter1
	jp z,interactionDelete

	inc l
	dec (hl) ; [counter2]--
	ret nz
	call getRandomNumber
	and $03
	ld a,$03
	ld (hl),a

	call getRandomNumber_noPreserveVars
	and $1f
	sub $10
	ld c,a
	call getRandomNumber
	and $07
	sub $04
	ld b,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_PUFF
	jp objectCopyPositionWithOffset

@state0:
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),$6a
	inc l
	inc (hl)
	ret


interaction97_subid01:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionDecCounter1
	ret nz
	ld (hl),$12
	inc l
	dec (hl)
	jp z,interactionDelete

	call getRandomNumber_noPreserveVars
	and $03
	add $0c
	ld b,a

@spawnBubble:
	add a
	add b
	ld hl,@positions
	rst_addAToHl
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ld e,(hl)
	call getFreePartSlot
	ret nz
	ld (hl),PART_JABU_JABUS_BUBBLES
	inc l
	ld (hl),e
	ld l,Part.yh
	ld (hl),b
	ld l,Part.xh
	ld (hl),c
	ret

@state0:
	call interactionSetAlwaysUpdateBit
	call interactionIncState

	ld l,Interaction.counter1
	ld (hl),30
	inc l
	ld (hl),$04 ; [counter2]

	ld b,$0c
--
	push bc
	ld a,b
	dec b
	dec a
	call @spawnBubble
	pop bc
	dec b
	jr nz,--
	ret

; Data format:
;   b0: Y
;   b1: X
;   b2: Subid for PART_JABU_JABUS_BUBBLES
@positions:
	.db $40 $2f $00
	.db $42 $31 $00
	.db $40 $35 $01
	.db $3e $3a $00
	.db $42 $40 $00
	.db $42 $46 $00
	.db $40 $5d $01
	.db $3e $62 $00
	.db $40 $69 $01
	.db $40 $6c $01
	.db $42 $3f $00
	.db $40 $71 $00
	.db $3e $3c $01
	.db $3a $48 $01
	.db $3c $54 $01
	.db $3e $62 $01
