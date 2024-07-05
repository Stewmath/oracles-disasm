; ==================================================================================================
; INTERAC_FLOOR_COLOR_CHANGER
; ==================================================================================================
interactionCode22:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

; Subid 0: the "controller"; detects when the tile has been changed.
@subid0:
	call checkInteractionState
	jr nz,++

	call objectGetTileAtPosition
	ld e,Interaction.var03
	ld (de),a
	call interactionIncState
++
	; Check if the tile changed color
	call objectGetTileAtPosition
	ld e,Interaction.var03
	ld a,(de)
	cp (hl)
	ret z

	ld a,(hl)
	sub TILEINDEX_RED_TOGGLE_FLOOR
	cp $03
	ret nc

	ld a,(hl)
	ld (de),a
	sub TILEINDEX_RED_TOGGLE_FLOOR
	add TILEINDEX_RED_FLOOR
	ld b,a
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERAC_FLOOR_COLOR_CHANGER
	inc l
	ld (hl),$01 ; [subid] = $01

	; Set var03 to the tile index to convert tiles to
	ld l,Interaction.var03
	ld (hl),b

	jp objectCopyPosition


; Subid 1: performs the updates to all tiles in the room in a random order.
@subid1:
	call checkInteractionState
	jr nz,@@initialized

	call objectGetTileAtPosition
	ld e,Interaction.var30
	ld (de),a
	call interactionIncState

	ld l,Interaction.counter1
	ld (hl),$ff

	; Generate all values from $00-$ff in a random order, and copy those values to
	; wBigBuffer.
	callab roomInitialization.generateRandomBuffer
	ld a,:w4RandomBuffer
	ld ($ff00+R_SVBK),a
	ld hl,w4RandomBuffer
	ld de,wBigBuffer
	ld b,$00
	call copyMemory
	ld a,$01
	ld ($ff00+R_SVBK),a

	ldh a,(<hActiveObject)
	ld d,a

@@initialized:
	call objectGetTileAtPosition
	ld e,Interaction.var30
	ld a,(de)
	cp (hl)
	jp z,++
	ld a,(hl)
	cp TILEINDEX_SOMARIA_BLOCK
	jp nz,interactionDelete
++
	ld a,l
	ldh (<hFF8C),a
	call @convertNextTile
	jr z,@done
	call @convertNextTile
	jr z,@done
	call @convertNextTile
	jr z,@done
	call @convertNextTile
	ret nz
@done:
	call @convertNextTile
	jp interactionDelete

;;
; @param	hFF8C	Position of this object
; @param[out]	zflag	Set if we've converted the last tile
@convertNextTile:
	ld e,Interaction.counter1
	ld a,(de)
	ld hl,wBigBuffer
	rst_addAToHl
	ldh a,(<hFF8C)
	ld c,a
	ld a,(hl) ; Get next position to update in 'a'

	; Check that the position is in-bounds, and is not this object's position
	cp LARGE_ROOM_HEIGHT*16 - 17
	jr nc,@decCounter1
	cp c
	jr z,@decCounter1

	; Position can't be on the screen edge (but it doesn't appear to check the right
	; edge?)
	and $0f
	jr z,@decCounter1
	ld a,(hl)
	and $f0
	jr z,@decCounter1
	cp LARGE_ROOM_HEIGHT*16 - 16
	jr z,@decCounter1

	; Check if this is a tile that should be replaced
	ld a,(hl)
	ld l,a
	ld h,>wRoomLayout
	ld a,(hl)
	sub TILEINDEX_RED_FLOOR
	cp $03
	jr nc,@notColoredFloor

	; Replace the tile
	ld e,Interaction.var03
	ld a,(de)
	ld c,l
	call setTile
@decCounter1:
	jp interactionDecCounter1

@notColoredFloor:
	; If it's not a colored floor, we should at least change the tile "underneath" it
	; in w3RoomLayoutBuffer, in case it's pushable or something.
	ld e,Interaction.var03
	ld a,(de)
	ld b,a
	ld c,l
	call setTileInRoomLayoutBuffer
	jp interactionDecCounter1
