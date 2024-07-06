; ==================================================================================================
; INTERAC_LINK_SHIP
; ==================================================================================================
interactionCoded4:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld h,d
	ld l,Interaction.subid
	ld a,(hl)
	ld b,a
	and $0f
	ld (hl),a

	ld a,b
	swap a
	and $0f
	add a
	add a
	ld l,Interaction.counter1
	ld (hl),a

	call interactionInitGraphics
	jp objectSetVisible82

@state1:
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	ret z

	call interactionDecCounter1
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@seagull

@ship:
	; Update the "bobbing" of the ship using the Z position (every 32 frames)
	ld a,(wFrameCounter)
	ld b,a
	and $1f
	ret nz

	ld a,b
	and $e0
	swap a
	rrca
	ld hl,@zPositions
	rst_addAToHl
	ld e,Interaction.zh
	ld a,(hl)
	ld (de),a
	ret

@zPositions:
	.db $00 $ff $ff $00 $00 $01 $01 $00


@seagull:
	; Similarly update the "bobbing" of the seagull, but more frequently
	ld a,(hl) ; [counter1]
	and $07
	ret nz

	ld a,(hl)
	and $38
	swap a
	rlca
	ld hl,@zPositions
	rst_addAToHl
	ld e,Interaction.zh
	ld a,(hl)
	ld (de),a
	ret
