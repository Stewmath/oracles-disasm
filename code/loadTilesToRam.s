;;
; Generate the buffers at w3VramTiles and w3VramAttributes based on the tiles
; loaded in wRoomLayout.
; @addr{6bf1}
generateW3VramTilesAndAttributes:
	ld a,:w3VramTiles		; $6bf1
	ld ($ff00+R_SVBK),a	; $6bf3
	ld hl,wRoomLayout		; $6bf5
	ld de,w3VramTiles		; $6bf8
	ld c,$0b		; $6bfb
---
	ld b,$10		; $6bfd
--
	push bc			; $6bff
	ldi a,(hl)		; $6c00
	push hl			; $6c01
	call setHlToTileMappingDataPlusATimes8		; $6c02
	push de			; $6c05
	call write4BytesToVramLayout		; $6c06
	pop de			; $6c09
	set 2,d			; $6c0a
	call write4BytesToVramLayout		; $6c0c
	res 2,d			; $6c0f
	ld a,e			; $6c11
	sub $1f			; $6c12
	ld e,a			; $6c14
	pop hl			; $6c15
	pop bc			; $6c16
	dec b			; $6c17
	jr nz,--		; $6c18

	ld a,$20		; $6c1a
	call addAToDe		; $6c1c
	dec c			; $6c1f
	jr nz,---		; $6c20
	ret			; $6c22

;;
; Take 4 bytes from hl, write 2 to de, write the next 2 $20 bytes later.
; @addr{6c23}
write4BytesToVramLayout:
	ldi a,(hl)		; $6c23
	ld (de),a		; $6c24
	inc e			; $6c25
	ldi a,(hl)		; $6c26
	ld (de),a		; $6c27
	ld a,$1f		; $6c28
	add e			; $6c2a
	ld e,a			; $6c2b
	ldi a,(hl)		; $6c2c
	ld (de),a		; $6c2d
	inc e			; $6c2e
	ldi a,(hl)		; $6c2f
	ld (de),a		; $6c30
	ret			; $6c31

;;
; This updates up to 4 entries in w2ChangedTileQueue by writing a command to the vblank
; queue.
;
; @addr{6c32}
updateChangedTileQueue:
	ld a,(wScrollMode)		; $6c32
	and $0e			; $6c35
	ret nz			; $6c37

	; Update up to 4 tiles per frame
	ld b,$04		; $6c38
--
	push bc			; $6c3a
	call @handleSingleEntry		; $6c3b
	pop bc			; $6c3e
	dec b			; $6c3f
	jr nz,--		; $6c40

	xor a			; $6c42
	ld ($ff00+R_SVBK),a	; $6c43
	ret			; $6c45

;;
; @addr{6c46}
@handleSingleEntry:
	ld a,(wChangedTileQueueHead)		; $6c46
	ld b,a			; $6c49
	ld a,(wChangedTileQueueTail)		; $6c4a
	cp b			; $6c4d
	ret z			; $6c4e

	inc b			; $6c4f
	ld a,b			; $6c50
	and $1f			; $6c51
	ld (wChangedTileQueueHead),a		; $6c53
	ld hl,w2ChangedTileQueue		; $6c56
	rst_addDoubleIndex			; $6c59

	ld a,:w2ChangedTileQueue		; $6c5a
	ld ($ff00+R_SVBK),a	; $6c5c

	; b = New value of tile
	; c = position of tile
	ldi a,(hl)		; $6c5e
	ld c,(hl)		; $6c5f
	ld b,a			; $6c60

	ld a,c			; $6c61
	ldh (<hFF8C),a	; $6c62

	ld a,($ff00+R_SVBK)	; $6c64
	push af			; $6c66
	ld a,:w3VramTiles		; $6c67
	ld ($ff00+R_SVBK),a	; $6c69
	call getVramSubtileAddressOfTile		; $6c6b

	ld a,b			; $6c6e
	call setHlToTileMappingDataPlusATimes8		; $6c6f
	push hl			; $6c72

	; Write tile data
	push de			; $6c73
	call write4BytesToVramLayout		; $6c74
	pop de			; $6c77

	; Write mapping data
	ld a,$04		; $6c78
	add d			; $6c7a
	ld d,a			; $6c7b
	call write4BytesToVramLayout		; $6c7c

	ldh a,(<hFF8C)	; $6c7f
	pop hl			; $6c81
	call queueTileWriteAtVBlank		; $6c82

	pop af			; $6c85
	ld ($ff00+R_SVBK),a	; $6c86
	ret			; $6c88

;;
; @param	c	Tile index
; @param[out]	de	Address of tile c's top-left subtile in w3VramTiles
; @addr{6c89}
getVramSubtileAddressOfTile:
	ld a,c			; $6c89
	swap a			; $6c8a
	and $0f			; $6c8c
	ld hl,@addresses	; $6c8e
	rst_addDoubleIndex			; $6c91
	ldi a,(hl)		; $6c92
	ld h,(hl)		; $6c93
	ld l,a			; $6c94

	ld a,c			; $6c95
	and $0f			; $6c96
	add a			; $6c98
	rst_addAToHl			; $6c99
	ld e,l			; $6c9a
	ld d,h			; $6c9b
	ret			; $6c9c

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
	ldh (<hFF8B),a	; $6cb3

	ld a,($ff00+R_SVBK)	; $6cb5
	push af			; $6cb7
	ld a,:w3TileMappingData		; $6cb8
	ld ($ff00+R_SVBK),a	; $6cba

	ldh a,(<hFF8F)	; $6cbc
	call setHlToTileMappingDataPlusATimes8		; $6cbe
	ld de,$cec8		; $6cc1
	ld b,$08		; $6cc4
-
	ldi a,(hl)		; $6cc6
	ld (de),a		; $6cc7
	inc de			; $6cc8
	dec b			; $6cc9
	jr nz,-			; $6cca

	ldh a,(<hFF8E)	; $6ccc
	call setHlToTileMappingDataPlusATimes8		; $6cce
	ld de,$cec8		; $6cd1
	ldh a,(<hFF8B)	; $6cd4
	bit 0,a			; $6cd6
	jr nz,@interleaveDiagonally		; $6cd8

	bit 1,a			; $6cda
	jr nz,+			; $6cdc

	inc hl			; $6cde
	inc hl			; $6cdf
	call @copy2Bytes		; $6ce0
	jr ++			; $6ce3
+
	inc de			; $6ce5
	inc de			; $6ce6
	call @copy2Bytes		; $6ce7
++
	inc hl			; $6cea
	inc hl			; $6ceb
	inc de			; $6cec
	inc de			; $6ced
	call @copy2Bytes		; $6cee
	jr @queueWrite			; $6cf1

@copy2Bytes:
	ldi a,(hl)		; $6cf3
	ld (de),a		; $6cf4
	inc de			; $6cf5
	ldi a,(hl)		; $6cf6
	ld (de),a		; $6cf7
	inc de			; $6cf8
	ret			; $6cf9

@interleaveDiagonally:
	bit 1,a			; $6cfa
	jr nz,+			; $6cfc

	inc de			; $6cfe
	call @copy2BytesSeparated		; $6cff
	jr ++			; $6d02
+
	inc hl			; $6d04
	call @copy2BytesSeparated		; $6d05
++
	inc hl			; $6d08
	inc de			; $6d09
	call @copy2BytesSeparated		; $6d0a
	jr @queueWrite			; $6d0d

;;
; @addr{6d0f}
@copy2BytesSeparated:
	ldi a,(hl)		; $6d0f
	ld (de),a		; $6d10
	inc de			; $6d11
	inc hl			; $6d12
	inc de			; $6d13
	ldi a,(hl)		; $6d14
	ld (de),a		; $6d15
	inc de			; $6d16
	ret			; $6d17

;;
; @param	hFF8C	The position of the tile to refresh
; @param	$cec8	The data to write for that tile
; @addr{6d18}
@queueWrite:
	ldh a,(<hFF8C)	; $6d18
	ld hl,$cec8		; $6d1a
	call queueTileWriteAtVBlank		; $6d1d
	pop af			; $6d20
	ld ($ff00+R_SVBK),a	; $6d21
	ret			; $6d23

;;
; Set wram bank to 3 (or wherever hl is pointing to) before calling this.
;
; @param	a	Tile position
; @param	hl	Pointer to 8 bytes of tile data (usually somewhere in
;			w3TileMappingData)
; @addr{6d24}
queueTileWriteAtVBlank:
	push hl			; $6d24
	call @getTilePositionInVram		; $6d25
	add $20			; $6d28
	ld c,a			; $6d2a

	; Add a command to the vblank queue.
	ldh a,(<hVBlankFunctionQueueTail)	; $6d2b
	ld l,a			; $6d2d
	ld h,>wVBlankFunctionQueue
	ld a,(vblankCopyTileFunctionOffset)		; $6d30
	ldi (hl),a		; $6d33
	ld (hl),e		; $6d34
	inc l			; $6d35
	ld (hl),d		; $6d36
	inc l			; $6d37

	ld e,l			; $6d38
	ld d,h			; $6d39
	pop hl			; $6d3a
	ld b,$02		; $6d3b
--
	; Write 2 bytes to the command
	call @copy2Bytes		; $6d3d

	; Then give it the address for the lower half of the tile
	ld a,c			; $6d40
	ld (de),a		; $6d41
	inc e			; $6d42

	; Then write the next 2 bytes
	call @copy2Bytes		; $6d43
	dec b			; $6d46
	jr nz,--		; $6d47

	; Update the tail of the vblank queue
	ld a,e			; $6d49
	ldh (<hVBlankFunctionQueueTail),a	; $6d4a
	ret			; $6d4c

;;
; @addr{6d4d}
@copy2Bytes:
	ldi a,(hl)		; $6d4d
	ld (de),a		; $6d4e
	inc e			; $6d4f
	ldi a,(hl)		; $6d50
	ld (de),a		; $6d51
	inc e			; $6d52
	ret			; $6d53

;;
; @param	a	Tile position
; @param[out]	a	Same as 'e'
; @param[out]	de	Somewhere in the vram bg map
; @addr{6d54}
@getTilePositionInVram:
	ld e,a			; $6d54
	and $f0			; $6d55
	swap a			; $6d57
	ld d,a			; $6d59
	ld a,e			; $6d5a
	and $0f			; $6d5b
	add a			; $6d5d
	ld e,a			; $6d5e
	ld a,(wScreenOffsetX)		; $6d5f
	swap a			; $6d62
	add a			; $6d64
	add e			; $6d65
	and $1f			; $6d66
	ld e,a			; $6d68
	ld a,(wScreenOffsetY)		; $6d69
	swap a			; $6d6c
	add d			; $6d6e
	and $0f			; $6d6f
	ld hl,vramBgMapTable		; $6d71
	rst_addDoubleIndex			; $6d74
	ldi a,(hl)		; $6d75
	add e			; $6d76
	ld e,a			; $6d77
	ld d,(hl)		; $6d78
	ret			; $6d79
