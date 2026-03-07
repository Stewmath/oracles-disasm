; ==================================================================================================
; INTERAC_PUSHBLOCK_TRIGGER
; ==================================================================================================
interactionCode13:
	call interactionDeleteAndRetIfEnabled02
	call returnIfScrollMode01Unset
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d
	ld l,Interaction.state
	ld (hl),$01

	call objectGetShortPosition
	ld l,Interaction.var18
	ld (hl),a

	; Replace the block at this position with TILEINDEX_PUSHABLE_BLOCK; save the old
	; value for the tile there into var19.
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	inc l
	ld (hl),a ; [var19] = tile at position
	ld a,TILEINDEX_PUSHABLE_BLOCK
	ld (bc),a

	ld hl,wNumEnemies
	inc (hl)
	ret

; Waiting for wNumEnemies to equal subid
@state1:
	ld a,(wNumEnemies)
	ld b,a
	ld e,Interaction.subid
	ld a,(de)
	cp b
	ret c

	ld e,Interaction.state
	ld a,$02
	ld (de),a

	ld e,Interaction.var18
	ld a,(de)
	ld c,a
	inc e
	ld a,(de)
	ld b,>wRoomLayout
	ld (bc),a
	ret

; Waiting for block to be pushed
@state2:
	ld e,Interaction.var18
	ld a,(de)
	ld l,a
	inc e
	ld a,(de)
	ld h,>wRoomLayout
	cp (hl)
	ret z

; Tile index changed; that must mean the block was pushed.

	ld e,Interaction.state
	ld a,$03
	ld (de),a
	ld e,Interaction.counter1
	ld a,$1e
	ld (de),a
	ret

@state3:
	call interactionDecCounter1
	ret nz
	xor a
	ld (wNumEnemies),a
	jp interactionDelete
