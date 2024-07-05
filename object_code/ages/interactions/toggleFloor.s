; ==================================================================================================
; INTERAC_TOGGLE_FLOOR: red/yellow/blue floor tiles that change color when jumped over.
; ==================================================================================================
interactionCode15:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jp nz,@subid01


; Subid 0: this checks Link's position and spawns new instances of subid 1 when needed.
@subid00:
	call interactionDeleteAndRetIfEnabled02
	call checkInteractionState
	jr nz,@initialized

	call interactionIncState

@updateTilePos:
	ld e,Interaction.var30
	ld a,(wActiveTilePos)
	ld (de),a
	ret

@initialized:
	ld a,(wLinkInAir)
	or a
	jr z,@updateTilePos

	; Check that link's position is within 4 pixels of the tile's center on both axes
	ld a,(w1Link.yh)
	add $05
	and $0f
	sub $04
	cp $09
	ret nc
	ld a,(w1Link.xh)
	and $0f
	sub $04
	cp $09
	ret nc

	; Check that Link's tile position has changed
	ld e,Interaction.var30
	ld a,(de)
	ld c,a
	call getLinkTilePosition
	cp c
	ret z

	; Position has changed. Check that the new tile is one of the colored floor tiles.
	ld (de),a
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	sub TILEINDEX_RED_TOGGLE_FLOOR
	cp $03
	ret nc

	; Spawn an instance of this object with subid 1.
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_TOGGLE_FLOOR
	inc l
	ld (hl),$01 ; [subid] = $01
	inc l
	ld (hl),c   ; [var03] = position

	ld l,Interaction.var30
	ld a,(wActiveTilePos)
	ld (hl),a
	ret


; Subid 1: toggles tile at position [var03] when Link lands.
@subid01:
	ld a,(wLinkInAir)
	or a
	ret nz

	; Get position of tile in 'c'.
	ld e,Interaction.var03
	ld a,(de)
	ld c,a

	; var30 contains Link's position from before he jumped; if he's landed on the same
	; spot, don't toggle the block.
	ld e,Interaction.var30
	ld a,(de)
	ld b,a
	call getLinkTilePosition
	cp b
	jp z,interactionDelete

	ld b,>wRoomLayout
	ld a,(bc)
	inc a
	cp TILEINDEX_RED_TOGGLE_FLOOR+3
	jr c,+
	ld a,TILEINDEX_RED_TOGGLE_FLOOR
+
	ldh (<hFF92),a
	call setTile
	ldh a,(<hFF92)
	ld b,a
	call setTileInRoomLayoutBuffer

	ld a,SND_GETSEED
	call playSound

	jp interactionDelete

;;
; @param[out]	a,l	The position of the tile Link's standing on
getLinkTilePosition:
	push bc
	ld a,(w1Link.yh)
	add $05
	and $f0
	ld b,a
	ld a,(w1Link.xh)
	swap a
	and $0f
	or b
	ld l,a
	pop bc
	ret
