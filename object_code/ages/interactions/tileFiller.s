; ==================================================================================================
; INTERAC_TILE_FILLER
; ==================================================================================================
interactionCode25:
	call returnIfScrollMode01Unset
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	call objectGetTileAtPosition
	ld c,l
	ld a,TILEINDEX_YELLOW_FLOOR
	call setTile

	ld a,c
	ld e,Interaction.var30
	ld (de),a

	call getFreeInteractionSlot
	jr nz,@state1
	ld (hl),INTERAC_PUFF
	ld l,Interaction.yh
	call setShortPosition_paramC

@state1:
	; Check if Link's position has changed
	callab getLinkTilePosition
	ld e,Interaction.var30
	ld a,(de)
	cp l
	ret z

	; Check that the position changed by exactly one tile horizontally or vertically
	ld b,a
	ld a,l
	add $f0
	cp b
	jr z,@updateFloor
	ld a,l
	inc a
	cp b
	jr z,@updateFloor
	ld a,l
	add $10
	cp b
	jr z,@updateFloor
	ld a,l
	dec a
	cp b
	ret nz

@updateFloor:
	ld h,>wRoomLayout
	ld a,(hl)
	cp TILEINDEX_BLUE_FLOOR
	ret nz

	ld a,l
	ldh (<hFF8B),a
	ld e,Interaction.var30
	ld (de),a

	; Update the tile at the old position
	ld c,b
	ld a,TILEINDEX_RED_FLOOR
	call setTile

	; Update the tile at the new position
	ldh a,(<hFF8B)
	ld c,a
	ld a,TILEINDEX_YELLOW_FLOOR
	call setTile

	ld a,SND_GETSEED
	jp playSound
