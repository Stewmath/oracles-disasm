;;
; Generate the buffers at w3VramTiles and w3VramAttributes based on the tiles
; loaded in wRoomLayout.
; @addr{6bf1}
generateW3VramTilesAndAttributes:
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	ld hl,wRoomLayout
	ld de,w3VramTiles
	ld c,$0b
---
	ld b,$10
--
	push bc
	ldi a,(hl)
	push hl
	call setHlToTileMappingDataPlusATimes8
	push de
	call write4BytesToVramLayout
	pop de
	set 2,d
	call write4BytesToVramLayout
	res 2,d
	ld a,e
	sub $1f
	ld e,a
	pop hl
	pop bc
	dec b
	jr nz,--

	ld a,$20
	call addAToDe
	dec c
	jr nz,---
	ret

;;
; Take 4 bytes from hl, write 2 to de, write the next 2 $20 bytes later.
; @addr{6c23}
write4BytesToVramLayout:
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ld a,$1f
	add e
	ld e,a
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ret

;;
; This updates up to 4 entries in w2ChangedTileQueue by writing a command to the vblank
; queue.
;
; @addr{6c32}
updateChangedTileQueue:
	ld a,(wScrollMode)
	and $0e
	ret nz

	; Update up to 4 tiles per frame
	ld b,$04
--
	push bc
	call @handleSingleEntry
	pop bc
	dec b
	jr nz,--

	xor a
	ld ($ff00+R_SVBK),a
	ret

;;
; @addr{6c46}
@handleSingleEntry:
	ld a,(wChangedTileQueueHead)
	ld b,a
	ld a,(wChangedTileQueueTail)
	cp b
	ret z

	inc b
	ld a,b
	and $1f
	ld (wChangedTileQueueHead),a
	ld hl,w2ChangedTileQueue
	rst_addDoubleIndex

	ld a,:w2ChangedTileQueue
	ld ($ff00+R_SVBK),a

	; b = New value of tile
	; c = position of tile
	ldi a,(hl)
	ld c,(hl)
	ld b,a

	ld a,c
	ldh (<hFF8C),a

	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	call getVramSubtileAddressOfTile

	ld a,b
	call setHlToTileMappingDataPlusATimes8
	push hl

	; Write tile data
	push de
	call write4BytesToVramLayout
	pop de

	; Write mapping data
	ld a,$04
	add d
	ld d,a
	call write4BytesToVramLayout

	ldh a,(<hFF8C)
	pop hl
	call queueTileWriteAtVBlank

	pop af
	ld ($ff00+R_SVBK),a
	ret

;;
; @param	c	Tile index
; @param[out]	de	Address of tile c's top-left subtile in w3VramTiles
; @addr{6c89}
getVramSubtileAddressOfTile:
	ld a,c
	swap a
	and $0f
	ld hl,@addresses
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld a,c
	and $0f
	add a
	rst_addAToHl
	ld e,l
	ld d,h
	ret

@addresses:
	.dw w3VramTiles+$000
	.dw w3VramTiles+$040
	.dw w3VramTiles+$080
	.dw w3VramTiles+$0c0
	.dw w3VramTiles+$100
	.dw w3VramTiles+$140
	.dw w3VramTiles+$180
	.dw w3VramTiles+$1c0
	.dw w3VramTiles+$200
	.dw w3VramTiles+$240
	.dw w3VramTiles+$280

;;
; Called from "setInterleavedTile" in bank 0.
;
; Mixes two tiles together by using some subtiles from one, and some subtiles from the
; other. Used for example by shutter doors, which would combine the door and floor tiles
; for the partway-closed part of the animation.
;
; Tile 2 uses its tiles from the same "half" that tile 1 uses. For example, if tile 1 was
; placed on the right side, both tiles would use the right halves of their subtiles.
;
; @param	a	0: Top is tile 2, bottom is tile 1
;			1: Left is tile 1, right is tile 2
;			2: Top is tile 1, bottom is tile 2
;			3: Left is tile 2, right is tile 1
; @param	hFF8C	Position of tile to change
; @param	hFF8F	Tile index 1
; @param	hFF8E	Tile index 2
; @addr{6cb3}
setInterleavedTile_body:
	ldh (<hFF8B),a

	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3TileMappingData
	ld ($ff00+R_SVBK),a

	ldh a,(<hFF8F)
	call setHlToTileMappingDataPlusATimes8
	ld de,$cec8
	ld b,$08
-
	ldi a,(hl)
	ld (de),a
	inc de
	dec b
	jr nz,-

	ldh a,(<hFF8E)
	call setHlToTileMappingDataPlusATimes8
	ld de,$cec8
	ldh a,(<hFF8B)
	bit 0,a
	jr nz,@interleaveDiagonally

	bit 1,a
	jr nz,+

	inc hl
	inc hl
	call @copy2Bytes
	jr ++
+
	inc de
	inc de
	call @copy2Bytes
++
	inc hl
	inc hl
	inc de
	inc de
	call @copy2Bytes
	jr @queueWrite

@copy2Bytes:
	ldi a,(hl)
	ld (de),a
	inc de
	ldi a,(hl)
	ld (de),a
	inc de
	ret

@interleaveDiagonally:
	bit 1,a
	jr nz,+

	inc de
	call @copy2BytesSeparated
	jr ++
+
	inc hl
	call @copy2BytesSeparated
++
	inc hl
	inc de
	call @copy2BytesSeparated
	jr @queueWrite

;;
; @addr{6d0f}
@copy2BytesSeparated:
	ldi a,(hl)
	ld (de),a
	inc de
	inc hl
	inc de
	ldi a,(hl)
	ld (de),a
	inc de
	ret

;;
; @param	hFF8C	The position of the tile to refresh
; @param	$cec8	The data to write for that tile
; @addr{6d18}
@queueWrite:
	ldh a,(<hFF8C)
	ld hl,$cec8
	call queueTileWriteAtVBlank
	pop af
	ld ($ff00+R_SVBK),a
	ret

;;
; Set wram bank to 3 (or wherever hl is pointing to) before calling this.
;
; @param	a	Tile position
; @param	hl	Pointer to 8 bytes of tile data (usually somewhere in
;			w3TileMappingData)
; @addr{6d24}
queueTileWriteAtVBlank:
	push hl
	call @getTilePositionInVram
	add $20
	ld c,a

	; Add a command to the vblank queue.
	ldh a,(<hVBlankFunctionQueueTail)
	ld l,a
	ld h,>wVBlankFunctionQueue
	ld a,(vblankCopyTileFunctionOffset)
	ldi (hl),a
	ld (hl),e
	inc l
	ld (hl),d
	inc l

	ld e,l
	ld d,h
	pop hl
	ld b,$02
--
	; Write 2 bytes to the command
	call @copy2Bytes

	; Then give it the address for the lower half of the tile
	ld a,c
	ld (de),a
	inc e

	; Then write the next 2 bytes
	call @copy2Bytes
	dec b
	jr nz,--

	; Update the tail of the vblank queue
	ld a,e
	ldh (<hVBlankFunctionQueueTail),a
	ret

;;
; @addr{6d4d}
@copy2Bytes:
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ret

;;
; @param	a	Tile position
; @param[out]	a	Same as 'e'
; @param[out]	de	Somewhere in the vram bg map
; @addr{6d54}
@getTilePositionInVram:
	ld e,a
	and $f0
	swap a
	ld d,a
	ld a,e
	and $0f
	add a
	ld e,a
	ld a,(wScreenOffsetX)
	swap a
	add a
	add e
	and $1f
	ld e,a
	ld a,(wScreenOffsetY)
	swap a
	add d
	and $0f
	ld hl,vramBgMapTable
	rst_addDoubleIndex
	ldi a,(hl)
	add e
	ld e,a
	ld d,(hl)
	ret
