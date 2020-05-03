; Main file for Oracle of Ages, US version

.include "include/rominfo.s"
.include "include/emptyfill.s"
.include "include/constants.s"
.include "include/structs.s"
.include "include/wram.s"
.include "include/hram.s"
.include "include/macros.s"
.include "include/script_commands.s"
.include "include/simplescript_commands.s"
.include "include/movementscript_commands.s"

.include "objects/macros.s"
.include "include/gfxDataMacros.s"

.include "build/textDefines.s"


.BANK $00 SLOT 0
.ORG 0

	.include "code/bank0.s"

.BANK $01 SLOT 1
.ORG 0

	.include "code/bank1.s"


.BANK $02 SLOT 1
.ORG 0

	.include "code/bank2.s"


.BANK $03 SLOT 1
.ORG 0

	.include "code/bank3.s"
	.include "code/ages/cutscenes/miscCutscenes.s"

	.include "code/ages/garbage/bank03End.s"

.BANK $04 SLOT 1
.ORG 0

.include "code/bank4.s"


; These 2 includes must be in the same bank
.include "build/data/roomPacks.s"
.include "build/data/musicAssignments.s"

.include "build/data/roomLayoutGroupTable.s"
.include "build/data/tilesets.s"
.include "build/data/tilesetAssignments.s"

.include "code/animations.s"

.include "build/data/uniqueGfxHeaders.s"
.include "build/data/uniqueGfxHeaderPointers.s"
.include "build/data/animationGroups.s"
.include "build/data/animationGfxHeaders.s"
.include "build/data/animationData.s"

.include "code/ages/tileSubstitutions.s"
.include "build/data/singleTileChanges.s"
.include "code/ages/roomSpecificTileChanges.s"

;;
; Unused?
; @addr{6ba8}
func_04_6ba8:
	ld d,>wRoomLayout		; $6ba8
	ldi a,(hl)		; $6baa
	ld c,a			; $6bab
--
	ldi a,(hl)		; $6bac
	cp $ff			; $6bad
	ret z			; $6baf

	ld e,a			; $6bb0
	ld a,c			; $6bb1
	ld (de),a		; $6bb2
	jr --			; $6bb3

;;
; Fills a square in wRoomLayout using the data at hl.
; Data format:
; - Top-left position (YX)
; - Height
; - Width
; - Tile value
; @addr{6bb5}
fillRectInRoomLayout:
	ldi a,(hl)		; $6bb5
	ld e,a			; $6bb6
	ldi a,(hl)		; $6bb7
	ld b,a			; $6bb8
	ldi a,(hl)		; $6bb9
	ld c,a			; $6bba
	ldi a,(hl)		; $6bbb
	ld d,a			; $6bbc
	ld h,>wRoomLayout		; $6bbd
--
	ld a,d			; $6bbf
	ld l,e			; $6bc0
	push bc			; $6bc1
-
	ldi (hl),a		; $6bc2
	dec c			; $6bc3
	jr nz,-			; $6bc4

	ld a,e			; $6bc6
	add $10			; $6bc7
	ld e,a			; $6bc9
	pop bc			; $6bca
	dec b			; $6bcb
	jr nz,--		; $6bcc
	ret			; $6bce

;;
; Like fillRect, but reads a series of bytes for the tile values instead of
; just one.
; @addr{6bcf}
drawRectInRoomLayout:
	ld a,(de)		; $6bcf
	inc de			; $6bd0
	ld h,>wRoomLayout		; $6bd1
	ld l,a			; $6bd3
	ldh (<hFF8B),a	; $6bd4
	ld a,(de)		; $6bd6
	inc de			; $6bd7
	ld c,a			; $6bd8
	ld a,(de)		; $6bd9
	inc de			; $6bda
	ldh (<hFF8D),a	; $6bdb
---
	ldh a,(<hFF8D)	; $6bdd
	ld b,a			; $6bdf
--
	ld a,(de)		; $6be0
	inc de			; $6be1
	ldi (hl),a		; $6be2
	dec b			; $6be3
	jr nz,--		; $6be4

	ldh a,(<hFF8B)	; $6be6
	add $10			; $6be8
	ldh (<hFF8B),a	; $6bea
	ld l,a			; $6bec
	dec c			; $6bed
	jr nz,---		; $6bee
	ret			; $6bf0

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

;;
; Called from loadTilesetData in bank 0.
;
; @addr{6d7a}
loadTilesetData_body:
	call getAdjustedRoomGroup		; $6d7a
	ld hl,roomTilesetsGroupTable
	rst_addDoubleIndex			; $6d80
	ldi a,(hl)		; $6d81
	ld h,(hl)		; $6d82
	ld l,a			; $6d83
	ld a,(wActiveRoom)		; $6d84
	rst_addAToHl			; $6d87
	ld a,(hl)		; $6d88
	ldh (<hFF8D),a	; $6d89
	call @func_6d94		; $6d8b
	call func_6de7		; $6d8e
	ret nc			; $6d91
	ldh a,(<hFF8D)	; $6d92
@func_6d94:
	and $80			; $6d94
	ldh (<hFF8B),a	; $6d96
	ldh a,(<hFF8D)	; $6d98
	and $7f			; $6d9a
	call multiplyABy8		; $6d9c
	ld hl,tilesetData
	add hl,bc		; $6da2
	ldi a,(hl)		; $6da3
	ld e,a			; $6da4
	ldi a,(hl)		; $6da5
	ld (wTilesetFlags),a		; $6da6
	bit TILESETFLAG_BIT_DUNGEON,a			; $6da9
	jr z,+

	ld a,e			; $6dad
	and $0f			; $6dae
	ld (wDungeonIndex),a		; $6db0
	jr ++
+
	ld a,$ff		; $6db5
	ld (wDungeonIndex),a		; $6db7
++
	ld a,e			; $6dba
	swap a			; $6dbb
	and $07			; $6dbd
	ld (wActiveCollisions),a		; $6dbf

	ld b,$06		; $6dc2
	ld de,wTilesetUniqueGfx		; $6dc4
@copyloop:
	ldi a,(hl)		; $6dc7
	ld (de),a		; $6dc8
	inc e			; $6dc9
	dec b			; $6dca
	jr nz,@copyloop

	ld e,wTilesetUniqueGfx&$ff
	ld a,(de)		; $6dcf
	ld b,a			; $6dd0
	ldh a,(<hFF8B)	; $6dd1
	or b			; $6dd3
	ld (de),a		; $6dd4
	ret			; $6dd5

;;
; Returns the group to load the room layout from, accounting for bit 0 of the room flag
; which tells it to use the underwater group
;
; @param[out]	a,b	The corrected group number
; @addr{6dd6}
getAdjustedRoomGroup:
	ld a,(wActiveGroup)		; $6dd6
	ld b,a			; $6dd9
	cp $02			; $6dda
	ret nc			; $6ddc
	call getThisRoomFlags		; $6ddd
	rrca			; $6de0
	jr nc,+
	set 1,b			; $6de3
+
	ld a,b			; $6de5
	ret			; $6de6

;;
; Modifies hFF8D to indicate changes to a room (ie. jabu flooding)?
; @addr{6de7}
func_6de7:
	call @func_04_6e0d		; $6de7
	ret c			; $6dea

	call @checkJabuFlooded		; $6deb
	ret c			; $6dee

	ld a,(wActiveGroup)		; $6def
	or a			; $6df2
	jr nz,@xor		; $6df3

	ld a,(wLoadingRoomPack)		; $6df5
	cp $7f			; $6df8
	jr nz,@xor		; $6dfa

	ld a,(wAnimalCompanion)		; $6dfc
	sub SPECIALOBJECTID_RICKY			; $6dff
	jr z,@xor		; $6e01

	ld b,a			; $6e03
	ldh a,(<hFF8D)	; $6e04
	add b			; $6e06
	ldh (<hFF8D),a	; $6e07
	scf			; $6e09
	ret			; $6e0a
@xor:
	xor a			; $6e0b
	ret			; $6e0c

;;
; @addr{6e0d}
@func_04_6e0d:
	ld a,(wActiveGroup)		; $6e0d
	or a			; $6e10
	ret nz			; $6e11

	ld a,(wActiveRoom)		; $6e12
	cp $38			; $6e15
	jr nz,+			; $6e17

	ld a,($c848)		; $6e19
	and $01			; $6e1c
	ret z			; $6e1e

	ld hl,hFF8D		; $6e1f
	inc (hl)		; $6e22
	inc (hl)		; $6e23
	scf			; $6e24
	ret			; $6e25
+
	xor a			; $6e26
	ret			; $6e27

;;
; @param[out]	cflag	Set if the current room is flooded in jabu-jabu?
; @addr{6e28}
@checkJabuFlooded:

.ifdef ROM_AGES
	ld a,(wDungeonIndex)		; $6e28
	cp $07			; $6e2b
	jr nz,++		; $6e2d

	ld a,(wTilesetFlags)		; $6e2f
	and TILESETFLAG_SIDESCROLL			; $6e32
	jr nz,++		; $6e34

	ld a,$11		; $6e36
	ld (wDungeonFirstLayout),a		; $6e38
	callab bank1.findActiveRoomInDungeonLayoutWithPointlessBankSwitch		; $6e3b
	ld a,(wJabuWaterLevel)		; $6e43
	and $07			; $6e46
	ld hl,@data		; $6e48
	rst_addAToHl			; $6e4b
	ld a,(wDungeonFloor)		; $6e4c
	ld bc,bitTable		; $6e4f
	add c			; $6e52
	ld c,a			; $6e53
	ld a,(bc)		; $6e54
	and (hl)		; $6e55
	ret z			; $6e56

	ldh a,(<hFF8D)	; $6e57
	inc a			; $6e59
	ldh (<hFF8D),a	; $6e5a
	scf			; $6e5c
	ret			; $6e5d
++
	xor a			; $6e5e
	ret			; $6e5f

; @addr{6e60}
@data:
	.db $00 $01 $03

.endif

;;
; Ages only: For tiles 0x40-0x7f, in the past, replace blue palettes (6) with red palettes (0). This
; is done so that tilesets can reuse attribute data for both the past and present tilesets.
;
; This is annoying so it's disabled in the hack-base branch, which separates all tileset data
; anyway.
;
; @addr{6e63}
setPastCliffPalettesToRed:
	ld a,(wActiveCollisions)		; $6e63
	or a			; $6e66
	jr nz,@done		; $6e68

	ld a,(wTilesetFlags)		; $6e6a
	and TILESETFLAG_PAST			; $6e6d
	jr z,@done		; $6e6e

	ld a,(wActiveRoom)		; $6e70
	cp <ROOM_AGES_138			; $6e73
	ret z			; $6e75

	; Replace all attributes that have palette "6" with palette "0"
	ld a,:w3TileMappingData		; $6e76
	ld ($ff00+R_SVBK),a	; $6e78
	ld hl,w3TileMappingData + $204		; $6e7a
	ld d,$06		; $6e7d
---
	ld b,$04		; $6e7f
--
	ld a,(hl)		; $6e81
	and $07			; $6e82
	cp d			; $6e84
	jr nz,+			; $6e85

	ld a,(hl)		; $6e87
	and $f8			; $6e88
	ld (hl),a		; $6e8a
+
	inc hl			; $6e8b
	dec b			; $6e8c
	jr nz,--		; $6e8d

	ld a,$04		; $6e8f
	rst_addAToHl			; $6e91
	ld a,h			; $6e92
	cp $d4			; $6e93
	jr c,---		; $6e95
@done:
	xor a			; $6e97
	ld ($ff00+R_SVBK),a	; $6e98
	ret			; $6e9a

;;
; @addr{6e9b}
func_04_6e9b:
	ld a,$02		; $6e9b
	ld ($ff00+R_SVBK),a	; $6e9d
	ld hl,wRoomLayout		; $6e9f
	ld de,$d000		; $6ea2
	ld b,$c0		; $6ea5
	call copyMemory		; $6ea7
	ld hl,wRoomCollisions		; $6eaa
	ld de,$d100		; $6ead
	ld b,$c0		; $6eb0
	call copyMemory		; $6eb2
	ld hl,$df00		; $6eb5
	ld de,$d200		; $6eb8
	ld b,$c0		; $6ebb
--
	ld a,$03		; $6ebd
	ld ($ff00+R_SVBK),a	; $6ebf
	ldi a,(hl)		; $6ec1
	ld c,a			; $6ec2
	ld a,$02		; $6ec3
	ld ($ff00+R_SVBK),a	; $6ec5
	ld a,c			; $6ec7
	ld (de),a		; $6ec8
	inc de			; $6ec9
	dec b			; $6eca
	jr nz,--		; $6ecb

	xor a			; $6ecd
	ld ($ff00+R_SVBK),a	; $6ece
	ret			; $6ed0

;;
; @addr{6ed1}
func_04_6ed1:
	ld a,$02		; $6ed1
	ld ($ff00+R_SVBK),a	; $6ed3
	ld hl,wRoomLayout		; $6ed5
	ld de,$d000		; $6ed8
	ld b,$c0		; $6edb
	call copyMemoryReverse		; $6edd
	ld hl,wRoomCollisions		; $6ee0
	ld de,$d100		; $6ee3
	ld b,$c0		; $6ee6
	call copyMemoryReverse		; $6ee8
	ld hl,$df00		; $6eeb
	ld de,$d200		; $6eee
	ld b,$c0		; $6ef1
--
	ld a,$02		; $6ef3
	ld ($ff00+R_SVBK),a	; $6ef5
	ld a,(de)		; $6ef7
	inc de			; $6ef8
	ld c,a			; $6ef9
	ld a,$03		; $6efa
	ld ($ff00+R_SVBK),a	; $6efc
	ld a,c			; $6efe
	ldi (hl),a		; $6eff
	dec b			; $6f00
	jr nz,--		; $6f01

	xor a			; $6f03
	ld ($ff00+R_SVBK),a	; $6f04
	ret			; $6f06

;;
; @addr{6f07}
func_04_6f07:
	ld hl,$d800		; $6f07
	ld de,$dc00		; $6f0a
	ld bc,$0200		; $6f0d
	call @locFunc		; $6f10
	ld hl,$dc00		; $6f13
	ld de,$de00		; $6f16
	ld bc,$0200		; $6f19
@locFunc:
	ld a,$03		; $6f1c
	ld ($ff00+R_SVBK),a	; $6f1e
	ldi a,(hl)		; $6f20
	ldh (<hFF8B),a	; $6f21
	ld a,$06		; $6f23
	ld ($ff00+R_SVBK),a	; $6f25
	ldh a,(<hFF8B)	; $6f27
	ld (de),a		; $6f29
	inc de			; $6f2a
	dec bc			; $6f2b
	ld a,b			; $6f2c
	or c			; $6f2d
	jr nz,@locFunc		; $6f2e
	ret			; $6f30

;;
; @addr{6f31}
func_04_6f31:
	ld hl,$dc00		; $6f31
	ld de,$d800		; $6f34
	ld bc,$0200		; $6f37
	call @locFunc		; $6f3a
	ld hl,$de00		; $6f3d
	ld de,$dc00		; $6f40
	ld bc,$0200		; $6f43
@locFunc:
	ld a,$06		; $6f46
	ld ($ff00+R_SVBK),a	; $6f48
	ldi a,(hl)		; $6f4a
	ldh (<hFF8B),a	; $6f4b
	ld a,$03		; $6f4d
	ld ($ff00+R_SVBK),a	; $6f4f
	ldh a,(<hFF8B)	; $6f51
	ld (de),a		; $6f53
	inc de			; $6f54
	dec bc			; $6f55
	ld a,b			; $6f56
	or c			; $6f57
	jr nz,@locFunc	; $6f58
	ret			; $6f5a

; .ORGA $6f5b

.include "build/data/warpData.s"


.include "code/ages/garbage/bank04End.s"


.BANK $05 SLOT 1
.ORG 0

 m_section_force "Bank_5" NAMESPACE bank5

.include "code/bank5.s"
.include "build/data/tileTypeMappings.s"
.include "build/data/cliffTilesTable.s"

.include "code/ages/garbage/bank05End.s"

.ends


.BANK $06 SLOT 1
.ORG 0


 m_section_superfree "Bank_6" NAMESPACE bank6

	.include "code/interactableTiles.s"
	.include "code/specialObjectAnimationsAndDamage.s"
	.include "code/breakableTiles.s"

	.include "code/items/parentItemUsage.s"

	.include "code/items/shieldParent.s"
	.include "code/items/otherSwordsParent.s"
	.include "code/items/switchHookParent.s"
	.include "code/items/caneOfSomariaParent.s"
	.include "code/items/swordParent.s"
	.include "code/items/harpFluteParent.s"
	.include "code/items/seedsParent.s"
	.include "code/items/shovelParent.s"
	.include "code/items/boomerangParent.s"
	.include "code/items/bombsBraceletParent.s"
	.include "code/items/featherParent.s"
	.include "code/items/magnetGloveParent.s"

	.include "code/items/parentItemCommon.s"


; Following table affects how an item can be used (ie. how it interacts with other items
; being used).
;
; Data format:
;  b0: bits 4-7: Priority (higher value = higher precedence)
;                Gets written to high nibble of Item.enabled
;      bits 0-3: Determines what "parent item" slot to use when the button is pressed.
;                0: Item is unusable.
;                1: Uses w1ParentItem3 or 4.
;                2: Uses w1ParentItem3 or 4, but only one instance of the item may exist
;                   at once. (boomerang, seed satchel)
;                3: Uses w1ParentItem2. If an object is already there, it gets
;                   overwritten if this object's priority is high enough.
;                   (sword, cane, bombs, etc)
;                4: Same as 2, but the item can't be used if w1ParentItem2 is in use (Link
;                   is holding a sword or something)
;                5: Uses w1ParentItem5 (only if not already in use). (shield, flute, harp)
;                6-7: invalid
;  b1: Byte to check input against when the item is first used
;
; @addr{55be}
_itemUsageParameterTable:
	.db $00 <wGameKeysPressed	; ITEMID_NONE
	.db $05 <wGameKeysPressed	; ITEMID_SHIELD
	.db $03 <wGameKeysJustPressed	; ITEMID_PUNCH
	.db $23 <wGameKeysJustPressed	; ITEMID_BOMB
	.db $03 <wGameKeysJustPressed	; ITEMID_CANE_OF_SOMARIA
	.db $63 <wGameKeysJustPressed	; ITEMID_SWORD
	.db $02 <wGameKeysJustPressed	; ITEMID_BOOMERANG
	.db $00 <wGameKeysJustPressed	; ITEMID_ROD_OF_SEASONS
	.db $00 <wGameKeysJustPressed	; ITEMID_MAGNET_GLOVES
	.db $00 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK_HELPER
	.db $73 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK
	.db $00 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK_CHAIN
	.db $73 <wGameKeysJustPressed	; ITEMID_BIGGORON_SWORD
	.db $02 <wGameKeysJustPressed	; ITEMID_BOMBCHUS
	.db $05 <wGameKeysJustPressed	; ITEMID_FLUTE
	.db $43 <wGameKeysJustPressed	; ITEMID_SHOOTER
	.db $00 <wGameKeysJustPressed	; ITEMID_10
	.db $05 <wGameKeysJustPressed	; ITEMID_HARP
	.db $00 <wGameKeysJustPressed	; ITEMID_12
	.db $00 <wGameKeysJustPressed	; ITEMID_SLINGSHOT
	.db $00 <wGameKeysJustPressed	; ITEMID_14
	.db $13 <wGameKeysJustPressed	; ITEMID_SHOVEL
	.db $13 <wGameKeysPressed	; ITEMID_BRACELET
	.db $01 <wGameKeysJustPressed	; ITEMID_FEATHER
	.db $00 <wGameKeysJustPressed	; ITEMID_18
	.db $02 <wGameKeysJustPressed	; ITEMID_SEED_SATCHEL
	.db $00 <wGameKeysJustPressed	; ITEMID_DUST
	.db $00 <wGameKeysJustPressed	; ITEMID_1b
	.db $00 <wGameKeysJustPressed	; ITEMID_1c
	.db $00 <wGameKeysJustPressed	; ITEMID_MINECART_COLLISION
	.db $00 <wGameKeysJustPressed	; ITEMID_FOOLS_ORE
	.db $00 <wGameKeysJustPressed	; ITEMID_1f



; Data format:
;  b0: bit 7:    If set, the corresponding bit in wLinkUsingItem1 will be set.
;      bits 4-6: Value for bits 0-2 of Item.var3f
;      bits 0-3: Determines parent item's relatedObj2?
;                A value of $6 refers to w1WeaponItem.
;  b1: Animation to set Link to? (see constants/linkAnimations.s)
;
; @addr{55fe}
_linkItemAnimationTable:
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_NONE
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_SHIELD
	.db $d6  LINK_ANIM_MODE_21	; ITEMID_PUNCH
	.db $30  LINK_ANIM_MODE_LIFT	; ITEMID_BOMB
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_CANE_OF_SOMARIA
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_SWORD
	.db $b0  LINK_ANIM_MODE_21	; ITEMID_BOOMERANG
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_ROD_OF_SEASONS
	.db $60  LINK_ANIM_MODE_NONE	; ITEMID_MAGNET_GLOVES
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_HELPER
	.db $f6  LINK_ANIM_MODE_21	; ITEMID_SWITCH_HOOK
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_CHAIN
	.db $f6  LINK_ANIM_MODE_23	; ITEMID_BIGGORON_SWORD
	.db $30  LINK_ANIM_MODE_21	; ITEMID_BOMBCHUS
	.db $70  LINK_ANIM_MODE_FLUTE	; ITEMID_FLUTE
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SHOOTER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_10
	.db $70  LINK_ANIM_MODE_HARP_2	; ITEMID_HARP
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_12
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SLINGSHOT
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_14
	.db $b0  LINK_ANIM_MODE_DIG_2	; ITEMID_SHOVEL
	.db $40  LINK_ANIM_MODE_LIFT_3	; ITEMID_BRACELET
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_FEATHER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_18
	.db $a0  LINK_ANIM_MODE_21	; ITEMID_SEED_SATCHEL
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_DUST
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1b
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1c
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_MINECART_COLLISION
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_FOOLS_ORE
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1f

	.include "code/specialObjects/minecart.s"
	.include "code/specialObjects/raft.s"

	.include "build/data/specialObjectAnimationData.s"
	.include "code/ages/cutscenes/companionCutscenes.s"
	.include "code/ages/cutscenes/linkCutscenes.s"
	.include "build/data/signText.s"
	.include "build/data/breakableTileCollisionTable.s"

;;
; @addr{79dc}
specialObjectLoadAnimationFrameToBuffer:
	ld hl,w1Companion.visible		; $79dc
	bit 7,(hl)		; $79df
	ret z			; $79e1

	ld l,<w1Companion.var32		; $79e2
	ld a,(hl)		; $79e4
	call _getSpecialObjectGraphicsFrame		; $79e5
	ret z			; $79e8

	ld a,l			; $79e9
	and $f0			; $79ea
	ld l,a			; $79ec
	ld de,w6SpecialObjectGfxBuffer|(:w6SpecialObjectGfxBuffer)		; $79ed
	jp copy256BytesFromBank		; $79f0


	.include "code/ages/garbage/bank06End.s"

.ends

.BANK $07 SLOT 1
.ORG 0

.include "code/fileManagement.s"

 ; This section can't be superfree, since it must be in the same bank as section
 ; "Bank_7_Data".
 m_section_free "Enemy_Part_Collisions" namespace "bank7"
	.include "code/collisionEffects.s"
.ends


 m_section_superfree "Item_Code" namespace "itemCode"
.include "code/updateItems.s"

	.include "build/data/itemConveyorTilesTable.s"
	.include "build/data/itemPassableCliffTilesTable.s"
	.include "build/data/itemPassableTilesTable.s"
	.include "code/itemCodes.s"
	.include "build/data/itemAttributes.s"
	.include "data/itemAnimations.s"
.ends


 ; This section can't be superfree, since it must be in the same bank as section
 ; "Enemy_Part_Collisions".
 m_section_free "Bank_7_Data" namespace "bank7"

	.include "build/data/enemyActiveCollisions.s"
	.include "build/data/partActiveCollisions.s"
	.include "build/data/objectCollisionTable.s"

	.include "code/ages/garbage/bank07End.s"

.ends


.BANK $08 SLOT 1
.ORG 0


 m_section_force Interaction_Code_Bank08 NAMESPACE interactionBank08

	.include "code/ages/interactionCode/bank08.s"

.ends


.BANK $09 SLOT 1
.ORG 0

 m_section_force Interaction_Code_Bank09 NAMESPACE interactionBank09

	.include "code/ages/interactionCode/bank09.s"

.ends


.BANK $0a SLOT 1
.ORG 0


 m_section_force Interaction_Code_Bank0a NAMESPACE interactionBank0a

	.include "code/ages/interactionCode/bank0a.s"

.ends


.BANK $0b SLOT 1
.ORG 0


 m_section_force Interaction_Code_Bank0b NAMESPACE interactionBank0b

	.include "code/ages/interactionCode/bank0b.s"

	.include "code/ages/garbage/bank0bEnd.s"

.ends


.BANK $0c SLOT 1
.ORG 0

	.include "code/scripting.s"
	.include "scripts/ages/scripts.s"


.BANK $0d SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0d NAMESPACE bank0d

	.include "code/enemyCommon.s"
	.include "code/ages/enemyCode/bank0d.s"

.ends

 m_section_superfree Enemy_Animations
	.include "build/data/enemyAnimations.s"
.ends


.BANK $0e SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0e NAMESPACE bank0e

	.include "code/enemyCommon.s"
	.include "code/ages/enemyCode/bank0e.s"
	.include "build/data/movingSidescrollPlatform.s"

	.include "code/ages/garbage/bank0eEnd.s"

.ends

.BANK $0f SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0f NAMESPACE bank0f

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "code/ages/enemyCode/bank0f.s"

.ends

.BANK $10 SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank10 NAMESPACE bank10

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "code/ages/enemyCode/bank10.s"

.ends


; Some blank space here ($6e1f-$6eff)

.ORGA $6f00

 m_section_force Interaction_Code_Bank10 NAMESPACE interactionBank10

	.include "code/ages/interactionCode/bank10.s"

.ends


.BANK $11 SLOT 1
.ORG 0

	.define PART_BANK $11
	.export PART_BANK

 m_section_force "Bank_11" NAMESPACE "partCode"

	.include "code/partCommon.s"
	.include "code/ages/partCode.s"

	.include "code/ages/garbage/bank11End.s"

.ends


.BANK $12 SLOT 1
.ORG 0

	.include "code/objectLoading.s"

 m_section_superfree "Room_Code" namespace "roomSpecificCode"

	.include "code/ages/roomSpecificCode.s"

.ends

 m_section_free "Objects_2" namespace "objectData"

	.include "objects/ages/mainData.s"
	.include "objects/ages/extraData3.s"

.ends

 m_section_superfree "Underwater Surface Data"

	.include "code/ages/underwaterSurface.s"

.ENDS

 m_section_free "Objects_3" namespace "objectData"

	.include "objects/ages/extraData4.s"

.ends


.BANK $13 SLOT 1
.ORG 0

	.define BASE_OAM_DATA_BANK $13
	.export BASE_OAM_DATA_BANK

	.include "build/data/specialObjectOamData.s"
	.include "data/itemOamData.s"
	.include "build/data/enemyOamData.s"

.BANK $14 SLOT 1
.ORG 0

 m_section_superfree "Terrain_Effects" NAMESPACE "terrainEffects"

; @addr{4000}
shadowAnimation:
	.db $01
	.db $13 $04 $20 $08

; @addr{4005}
greenGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $08
	.db $11 $07 $24 $08

; @addr{400e}
blueGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $09
	.db $11 $07 $24 $09

; @addr{4017}
_puddleAnimationFrame0:
	.db $02
	.db $16 $03 $22 $08
	.db $16 $05 $22 $28

; @addr{4020}
orangeGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $0b
	.db $11 $07 $24 $0b

; @addr{4029}
greenGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $28
	.db $11 $07 $24 $28

; @addr{4032}
blueGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $29
	.db $11 $07 $24 $29

; @addr{403b}
_puddleAnimationFrame1:
	.db $02
	.db $16 $02 $22 $08
	.db $16 $06 $22 $28

; @addr{4044}
orangeGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $2b
	.db $11 $07 $24 $2b

; @addr{404d}
_puddleAnimationFrame2:
	.db $02
	.db $17 $01 $22 $08
	.db $17 $07 $22 $28

; @addr{4056}
_puddleAnimationFrame3:
	.db $02
	.db $18 $00 $22 $08
	.db $18 $08 $22 $28

; @addr{405f}
puddleAnimationFrames:
	.dw _puddleAnimationFrame0
	.dw _puddleAnimationFrame1
	.dw _puddleAnimationFrame2
	.dw _puddleAnimationFrame3

.ends

.include "build/data/interactionOamData.s"
.include "build/data/partOamData.s"


.BANK $15 SLOT 1
.ORG 0

.include "code/ages/scriptHelper/scriptHlp1.s"

 m_section_free "Object_Pointers" namespace "objectData"

;;
; @addr{4315}
getObjectDataAddress:
	ld a,(wActiveGroup)		; $4315
	ld hl,objectDataGroupTable
	rst_addDoubleIndex			; $431b
	ldi a,(hl)		; $431c
	ld h,(hl)		; $431d
	ld l,a			; $431e
	ld a,(wActiveRoom)		; $431f
	ld e,a			; $4322
	ld d,$00		; $4323
	add hl,de		; $4325
	add hl,de		; $4326
	ldi a,(hl)		; $4327
	ld d,(hl)		; $4328
	ld e,a			; $4329
	ret			; $432a


	.include "objects/ages/pointers.s"

.ENDS

.include "code/ages/scriptHelper/scriptHlp2.s"


.BANK $16 SLOT 1
.ORG 0

.include "code/serialFunctions.s"

 m_section_force Bank16 NAMESPACE bank16

;;
; @param	d	Interaction index (should be of type INTERACID_TREASURE)
; @addr{451e}
interactionLoadTreasureData:
	ld e,Interaction.subid	; $451e
	ld a,(de)		; $4520
	ld e,Interaction.var30		; $4521
	ld (de),a		; $4523
	ld hl,treasureObjectData		; $4524
--
	call multiplyABy4		; $4527
	add hl,bc		; $452a
	bit 7,(hl)		; $452b
	jr z,+			; $452d

	inc hl			; $452f
	ldi a,(hl)		; $4530
	ld h,(hl)		; $4531
	ld l,a			; $4532
	ld e,Interaction.var03		; $4533
	ld a,(de)		; $4535
	jr --			; $4536
+
	; var31 = spawn mode
	ldi a,(hl)		; $4538
	ld b,a			; $4539
	swap a			; $453a
	and $07			; $453c
	ld e,Interaction.var31		; $453e
	ld (de),a		; $4540

	; var32 = collect mode
	ld a,b			; $4541
	and $07			; $4542
	inc e			; $4544
	ld (de),a		; $4545

	; var33 = ?
	ld a,b			; $4546
	and $08			; $4547
	inc e			; $4549
	ld (de),a		; $454a

	; var34 = parameter (value of 'c' for "giveTreasure")
	ldi a,(hl)		; $454b
	inc e			; $454c
	ld (de),a		; $454d

	; var35 = low text ID
	ldi a,(hl)		; $454e
	inc e			; $454f
	ld (de),a		; $4550

	; subid = graphics to use
	ldi a,(hl)		; $4551
	ld e,Interaction.subid		; $4552
	ld (de),a		; $4554
	ret			; $4555


.include "build/data/data_4556.s"

; Used in CUTSCENE_BLACK_TOWER_ESCAPE
; @addr{4d05}
oamData_4d05:
	.db $26
	.db $e0 $10 $02 $01
	.db $e0 $18 $04 $01
	.db $e0 $20 $06 $01
	.db $e0 $28 $08 $01
	.db $f0 $08 $14 $01
	.db $f0 $10 $16 $01
	.db $f0 $18 $18 $01
	.db $f0 $20 $1a $01
	.db $f0 $28 $1c $01
	.db $00 $08 $28 $01
	.db $00 $10 $2a $01
	.db $00 $18 $2c $01
	.db $00 $20 $2e $01
	.db $00 $28 $30 $01
	.db $10 $08 $3a $01
	.db $10 $10 $3c $01
	.db $10 $18 $3e $01
	.db $10 $20 $40 $01
	.db $10 $28 $42 $01
	.db $20 $08 $00 $01
	.db $20 $10 $0a $01
	.db $20 $18 $0c $01
	.db $20 $20 $0e $01
	.db $20 $28 $10 $01
	.db $30 $08 $1e $01
	.db $30 $10 $20 $01
	.db $30 $18 $22 $01
	.db $30 $20 $24 $01
	.db $30 $28 $26 $01
	.db $40 $08 $32 $01
	.db $40 $10 $34 $01
	.db $40 $18 $36 $01
	.db $50 $08 $44 $01
	.db $50 $10 $46 $01
	.db $50 $18 $48 $01
	.db $40 $20 $38 $01
	.db $60 $08 $00 $01
	.db $60 $10 $12 $01

; Used by CUTSCENE_BLACK_TOWER_ESCAPE
; @addr{4d9e}
oamData_4d9e:
	.db $26
	.db $e0 $f8 $02 $21
	.db $e0 $f0 $04 $21
	.db $e0 $e8 $06 $21
	.db $e0 $e0 $08 $21
	.db $f0 $00 $14 $21
	.db $f0 $f8 $16 $21
	.db $f0 $f0 $18 $21
	.db $f0 $e8 $1a $21
	.db $f0 $e0 $1c $21
	.db $00 $00 $28 $21
	.db $00 $f8 $2a $21
	.db $00 $f0 $2c $21
	.db $00 $e8 $2e $21
	.db $00 $e0 $30 $21
	.db $10 $00 $3a $21
	.db $10 $f8 $3c $21
	.db $10 $f0 $3e $21
	.db $10 $e8 $40 $21
	.db $10 $e0 $42 $21
	.db $20 $00 $00 $21
	.db $20 $f8 $0a $21
	.db $20 $f0 $0c $21
	.db $20 $e8 $0e $21
	.db $20 $e0 $10 $21
	.db $30 $00 $1e $21
	.db $30 $f8 $20 $21
	.db $30 $f0 $22 $21
	.db $30 $e8 $24 $21
	.db $30 $e0 $26 $21
	.db $40 $00 $32 $21
	.db $40 $f8 $34 $21
	.db $40 $f0 $36 $21
	.db $50 $00 $44 $21
	.db $50 $f8 $46 $21
	.db $50 $f0 $48 $21
	.db $40 $e8 $38 $21
	.db $60 $00 $00 $21
	.db $60 $f8 $12 $21

; @addr{4e37}
_oamData_4e37:
	.db $28
	.db $44 $21 $00 $00
	.db $44 $29 $02 $00
	.db $54 $29 $04 $00
	.db $34 $1b $06 $00
	.db $50 $d9 $08 $00
	.db $08 $e0 $0a $00
	.db $30 $d8 $0c $01
	.db $20 $d1 $0e $00
	.db $fb $ee $10 $02
	.db $fb $f6 $12 $02
	.db $0b $e6 $14 $02
	.db $0b $ee $16 $02
	.db $1b $e6 $18 $02
	.db $1b $ee $1a $02
	.db $00 $48 $1c $01
	.db $58 $40 $1e $00
	.db $10 $58 $22 $01
	.db $00 $50 $20 $01
	.db $38 $50 $24 $01
	.db $28 $50 $26 $03
	.db $28 $58 $28 $03
	.db $16 $4a $2a $04
	.db $16 $52 $2c $04
	.db $e8 $d0 $2e $01
	.db $f8 $d0 $30 $04
	.db $f8 $d8 $32 $04
	.db $00 $da $34 $02
	.db $e8 $e5 $36 $01
	.db $20 $0f $38 $04
	.db $20 $20 $3a $04
	.db $db $38 $40 $07
	.db $db $40 $42 $07
	.db $e8 $35 $44 $07
	.db $e8 $3d $46 $07
	.db $fc $30 $48 $07
	.db $f8 $38 $4a $07
	.db $00 $40 $4c $07
	.db $18 $38 $4e $07
	.db $10 $40 $50 $07
	.db $20 $40 $52 $07

; @addr{4ed8}
_oamData_4ed8:
	.db $12
	.db $10 $08 $00 $0c
	.db $10 $10 $02 $0c
	.db $10 $18 $04 $0c
	.db $20 $08 $0c $0c
	.db $20 $10 $0e $0c
	.db $20 $18 $10 $0c
	.db $31 $23 $06 $0d
	.db $31 $2b $08 $0d
	.db $31 $3b $06 $2d
	.db $31 $33 $08 $2d
	.db $41 $23 $06 $4d
	.db $41 $2b $08 $4d
	.db $41 $3b $06 $6d
	.db $41 $33 $08 $6d
	.db $2c $1d $0a $0d
	.db $2c $25 $0a $2d
	.db $4c $3a $0a $0d
	.db $4c $42 $0a $2d

; @addr{4f21}
_oamData_4f21:
	.db $0d
	.db $38 $d3 $02 $03
	.db $32 $f8 $0c $01
	.db $f8 $d8 $10 $07
	.db $f8 $e0 $12 $07
	.db $f8 $e8 $14 $07
	.db $f7 $f7 $16 $07
	.db $22 $f8 $1a $03
	.db $1a $00 $1c $03
	.db $11 $e2 $1e $00
	.db $11 $ea $20 $00
	.db $01 $ea $22 $00
	.db $11 $f2 $26 $00
	.db $01 $f2 $24 $00

; @addr{4f56}
_oamData_4f56:
	.db $07
	.db $60 $f8 $00 $02
	.db $48 $d3 $04 $03
	.db $40 $e0 $06 $07
	.db $40 $e8 $08 $07
	.db $40 $f0 $0a $07
	.db $42 $f8 $0e $01
	.db $68 $e0 $18 $02

; @addr{4f73}
_oamData_4f73:
	.db $1e
	.db $e8 $e8 $00 $06
	.db $e8 $f0 $02 $06
	.db $f8 $e0 $04 $06
	.db $00 $d8 $06 $06
	.db $08 $e8 $08 $06
	.db $08 $f0 $0a $06
	.db $f8 $f6 $0c $06
	.db $10 $e0 $0e $06
	.db $18 $e8 $10 $07
	.db $18 $da $12 $04
	.db $18 $e2 $14 $04
	.db $08 $d0 $16 $06
	.db $40 $d8 $18 $06
	.db $30 $f8 $1a $04
	.db $28 $d3 $1c $00
	.db $f0 $f8 $1e $00
	.db $48 $f8 $20 $04
	.db $36 $f5 $22 $04
	.db $58 $00 $24 $05
	.db $3b $18 $26 $05
	.db $3b $20 $28 $05
	.db $38 $3c $2a $03
	.db $14 $38 $2c $05
	.db $28 $48 $2e $00
	.db $30 $51 $30 $00
	.db $30 $60 $32 $00
	.db $28 $68 $34 $04
	.db $f8 $40 $36 $00
	.db $00 $48 $38 $00
	.db $00 $50 $3a $05

; @addr{4fec}
_oamData_4fec:
	.db $0a
	.db $48 $4d $88 $05
	.db $48 $55 $8a $05
	.db $47 $45 $84 $03
	.db $47 $4d $86 $03
	.db $39 $4e $90 $03
	.db $43 $59 $8c $03
	.db $39 $46 $8e $03
	.db $3b $3c $92 $03
	.db $49 $4c $80 $02
	.db $49 $54 $82 $02

.ends


.include "code/staticObjects.s"
.include "build/data/staticDungeonObjects.s"
.include "build/data/chestData.s"

 m_section_force Bank16_2 NAMESPACE bank16

.include "build/data/treasureObjectData.s"

;;
; Used in the room in present Mermaid's Cave with the changing floor
;
; @param	b	Floor state (0/1)
; @addr{5766}
loadD6ChangingFloorPatternToBigBuffer:
	ld a,b			; $5766
	add a			; $5767
	ld hl,@changingFloorData		; $5768
	rst_addDoubleIndex			; $576b
	push hl			; $576c
	ldi a,(hl)		; $576d
	ld d,(hl)		; $576e
	ld e,a			; $576f
	ld b,$41		; $5770
	ld hl,wBigBuffer		; $5772
	call copyMemoryReverse		; $5775

	pop hl			; $5778
	inc hl			; $5779
	inc hl			; $577a
	ldi a,(hl)		; $577b
	ld d,(hl)		; $577c
	ld e,a			; $577d
	ld b,$41		; $577e
	ld hl,wBigBuffer+$80		; $5780
	call copyMemoryReverse		; $5783

	ldh a,(<hActiveObject)	; $5786
	ld d,a			; $5788
	ret			; $5789

@changingFloorData:
	.dw @tiles0_bottomHalf
	.dw @tiles0_topHalf

	.dw @tiles1
	.dw @tiles1

@tiles0_bottomHalf:
	.db $a0 $a0 $a0 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4
	.db $00

@tiles0_topHalf:
	.db $a0 $a0 $a0 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $a0 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $a0 $f4 $f4 $f4 $f4 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $a0 $ff
	.db $a0 $a0 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $ff
	.db $f4 $f4 $f4 $f4
	.db $00

@tiles1:
	.db $a0 $a0 $f4 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $a0 $a0 $f4 $f4 $f4 $f4 $f4 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $a0 $a0 $a0 $f4 $f4 $a0 $ff
	.db $a0 $a0 $f4 $a0
	.db $00

.ends

.include "build/data/interactionAnimations.s"
.include "build/data/partAnimations.s"

.BANK $17 SLOT 1 ; Seasons: should be bank $16
.ORG 0

	.include "build/data/paletteData.s"
	.include "build/data/tilesetCollisions.s"
	.include "build/data/smallRoomLayoutTables.s"

.ifdef ROM_AGES
	.include "code/ages/garbage/bank17End.s"
.endif

.BANK $18 SLOT 1 ; Seasons: should be bank $17
.ORG 0

 m_section_superfree Tile_Mappings

	tileMappingIndexDataPointer:
		.dw tileMappingIndexData
	tileMappingAttributeDataPointer:
		.dw tileMappingAttributeData

	tileMappingTable:
		.incbin "build/tileset_layouts/tileMappingTable.bin"
	tileMappingIndexData:
		.incbin "build/tileset_layouts/tileMappingIndexData.bin"
	tileMappingAttributeData:
		.incbin "build/tileset_layouts/tileMappingAttributeData.bin"

.ifdef ROM_AGES
	.include "code/ages/garbage/bank18End.s"
.endif

.ends


.BANK $19 SLOT 1
.ORG 0

 m_section_superfree "Gfx_19_1" ALIGN $10
	.include "data/ages/gfxDataBank19_1.s"
.ends

 m_section_superfree "Tile_mappings"
	.include "build/data/tilesetMappings.s"
.ends

 m_section_superfree "Gfx_19_2" ALIGN $10
	.include "data/ages/gfxDataBank19_2.s"
.ends


.BANK $1a SLOT 1
.ORG 0


 m_section_free "Gfx_1a" ALIGN $20
	.include "data/gfxDataBank1a.s"
.ends


.BANK $1b SLOT 1
.ORG 0

 m_section_free "Gfx_1b" ALIGN $20
	.include "data/gfxDataBank1b.s"
.ends


.BANK $1c SLOT 1
.ORG 0

	; The first $e characters of gfx_font are blank, so they aren't
	; included in the rom. In order to get the offsets correct, use
	; gfx_font_start as the label instead of gfx_font.

	.define gfx_font_start gfx_font-$e0
	.export gfx_font_start

	m_GfxDataSimple gfx_font_jp ; $70000
	m_GfxDataSimple gfx_font_tradeitems ; $70600
	m_GfxDataSimple gfx_font $e0 ; $70800
	m_GfxDataSimple gfx_font_heartpiece ; $71720

	m_GfxDataSimple map_rings ; $717a0

	.include "build/data/largeRoomLayoutTables.s" ; $719c0

.ifdef ROM_AGES
	.include "code/ages/garbage/bank1cEnd.s"
.endif

; "build/textData.s" will determine where this data starts.
;   Ages:    1d:4000
;   Seasons: 1c:5c00

	.include "build/textData.s"

	.REDEFINE DATA_ADDR TEXT_END_ADDR
	.REDEFINE DATA_BANK TEXT_END_BANK

	.include "build/data/roomLayoutData.s"
	.include "build/data/gfxDataMain.s"



.BANK $3f SLOT 1
.ORG 0

 m_section_force Bank3f NAMESPACE bank3f

.define BANK_3f $3f

.include "code/loadGraphics.s"
.include "code/treasureAndDrops.s"
.include "code/textbox.s"

; @addr{5951}
data_5951:
	.db $3c $b4 $3c $50 $78 $b4 $3c $3c
	.db $3c $70 $78 $78

.ifdef ROM_AGES

; In Seasons these sprites are located elsewhere

titlescreenMakuSeedSprite:
	.db $13
	.db $48 $90 $62 $06
	.db $42 $8e $68 $06
	.db $51 $7a $56 $04
	.db $50 $82 $74 $04
	.db $58 $7a $6a $07
	.db $58 $82 $6c $07
	.db $58 $8a $6e $07
	.db $54 $8a $54 $03
	.db $54 $82 $52 $03
	.db $54 $7a $50 $03
	.db $64 $7a $70 $03
	.db $64 $82 $72 $03
	.db $64 $8a $70 $23
	.db $40 $86 $66 $06
	.db $40 $7f $64 $06
	.db $41 $70 $60 $06
	.db $55 $76 $5a $06
	.db $44 $68 $5e $26
	.db $74 $00 $46 $02

titlescreenPressStartSprites:
	.db $0a
	.db $80 $2c $38 $00
	.db $80 $34 $3a $00
	.db $80 $3c $3c $00
	.db $80 $44 $3e $00
	.db $80 $4c $3e $00
	.db $80 $5c $3e $00
	.db $80 $64 $40 $00
	.db $80 $6c $42 $00
	.db $80 $74 $3a $00
	.db $80 $7c $40 $00

; Sprites used on the closeup shot of Link on the horse in the intro
linkOnHorseCloseupSprites_2:
	.db $26
	.db $80 $80 $40 $06
	.db $80 $50 $42 $00
	.db $80 $58 $44 $00
	.db $68 $40 $46 $06
	.db $b8 $3d $20 $02
	.db $b8 $45 $22 $02
	.db $b8 $4d $24 $02
	.db $b8 $55 $26 $02
	.db $b8 $5d $28 $02
	.db $90 $28 $2c $02
	.db $90 $30 $2e $02
	.db $80 $30 $2a $02
	.db $20 $78 $48 $05
	.db $58 $68 $00 $02
	.db $58 $70 $02 $02
	.db $68 $68 $04 $02
	.db $48 $70 $06 $02
	.db $5a $40 $08 $01
	.db $5a $48 $0a $01
	.db $5a $50 $0c $01
	.db $38 $88 $0e $04
	.db $30 $78 $10 $04
	.db $30 $80 $12 $04
	.db $40 $80 $14 $04
	.db $50 $76 $16 $04
	.db $50 $7e $18 $04
	.db $41 $62 $1a $03
	.db $80 $28 $1c $02
	.db $a8 $59 $1e $02
	.db $98 $20 $30 $02
	.db $98 $28 $32 $02
	.db $8c $38 $34 $07
	.db $a8 $41 $36 $02
	.db $a8 $49 $38 $02
	.db $a8 $51 $3a $02
	.db $90 $40 $3e $07
	.db $8a $5c $4a $00
	.db $8a $64 $4c $00

; Sprites used to touch up the appearance of the temple in the intro (the scene where
; Link's on a cliff with his horse)
introTempleSprites:
	.db $05
	.db $30 $28 $48 $02
	.db $30 $30 $4a $02
	.db $18 $38 $4c $03
	.db $10 $40 $4e $03
	.db $18 $48 $50 $03


; Used in intro (ages only)
linkOnHorseFacingCameraSprite:
	.db $02
	.db $70 $08 $58 $02
	.db $70 $10 $5a $02

.endif ; ROM_AGES


.include "build/data/objectGfxHeaders.s"
.include "build/data/treeGfxHeaders.s"

.include "build/data/enemyData.s"
.include "build/data/partData.s"
.include "build/data/itemData.s"
.include "build/data/interactionData.s"

.include "build/data/treasureCollectionBehaviours.s"
.include "build/data/treasureDisplayData.s"

; @addr{714c}
oamData_714c:
	.db $10
	.db $c8 $38 $2e $0e
	.db $c8 $40 $30 $0e
	.db $c8 $48 $32 $0e
	.db $c8 $60 $34 $0f
	.db $c8 $68 $36 $0f
	.db $c8 $70 $38 $0f
	.db $d8 $78 $06 $2e
	.db $e8 $80 $00 $0d
	.db $e8 $78 $08 $0e
	.db $e0 $90 $00 $0d
	.db $d8 $a0 $00 $0d
	.db $e8 $30 $04 $0e
	.db $d8 $30 $06 $0e
	.db $f8 $28 $02 $0e
	.db $f0 $18 $00 $2d
	.db $e8 $08 $00 $2d

; @addr{718d}
oamData_718d:
	.db $10
	.db $a8 $38 $12 $0a
	.db $b8 $38 $0e $0f
	.db $c8 $38 $0a $0f
	.db $a8 $70 $14 $0a
	.db $b8 $70 $10 $0a
	.db $c8 $70 $0c $0f
	.db $e8 $80 $00 $0d
	.db $d8 $78 $06 $2e
	.db $e8 $78 $08 $0e
	.db $e0 $90 $00 $0d
	.db $d8 $a0 $00 $0d
	.db $f8 $28 $02 $0e
	.db $f0 $18 $00 $2d
	.db $e8 $08 $00 $2d
	.db $d8 $30 $06 $0e
	.db $e8 $30 $08 $2e

; @addr{71ce}
oamData_71ce:
	.db $0a
	.db $50 $40 $40 $0b
	.db $50 $48 $42 $0b
	.db $50 $50 $44 $0b
	.db $50 $58 $46 $0b
	.db $50 $60 $48 $0b
	.db $50 $68 $4a $0b
	.db $70 $70 $3c $0c
	.db $60 $70 $3e $2c
	.db $70 $38 $3a $0c
	.db $60 $38 $3e $0c

; @addr{71f7}
oamData_71f7:
	.db $0a
	.db $10 $40 $22 $08
	.db $10 $68 $22 $28
	.db $60 $38 $16 $0c
	.db $70 $38 $1a $0c
	.db $60 $70 $18 $0c
	.db $70 $70 $1a $2c
	.db $40 $40 $1c $08
	.db $40 $68 $1e $08
	.db $50 $40 $20 $08
	.db $50 $68 $20 $28

; @addr{7220}
oamData_7220:
	.db $0a
	.db $e0 $48 $24 $0b
	.db $e0 $60 $24 $2b
	.db $e0 $50 $26 $0b
	.db $e0 $58 $26 $2b
	.db $f0 $48 $28 $0b
	.db $f0 $60 $28 $2b
	.db $00 $48 $2a $0b
	.db $00 $60 $2a $2b
	.db $f8 $50 $2c $0b
	.db $f8 $58 $2c $2b

; @addr{7249}
oamData_7249:
	.db $27
	.db $38 $38 $00 $01
	.db $38 $58 $02 $00
	.db $30 $48 $04 $00
	.db $30 $50 $06 $00
	.db $40 $48 $08 $00
	.db $58 $38 $0a $00
	.db $50 $40 $0c $02
	.db $50 $48 $0e $04
	.db $58 $50 $10 $03
	.db $60 $57 $12 $03
	.db $60 $5f $14 $03
	.db $60 $30 $16 $00
	.db $72 $38 $18 $00
	.db $70 $30 $1a $03
	.db $88 $28 $1c $00
	.db $3b $9a $1e $04
	.db $4b $9a $20 $04
	.db $58 $90 $22 $05
	.db $58 $98 $24 $05
	.db $22 $a0 $26 $06
	.db $22 $a8 $28 $06
	.db $32 $a0 $2a $06
	.db $32 $a8 $2c $06
	.db $12 $a0 $2e $06
	.db $12 $a8 $30 $06
	.db $12 $b0 $32 $06
	.db $6c $b0 $34 $03
	.db $70 $c0 $36 $01
	.db $80 $c0 $38 $05
	.db $90 $58 $3a $03
	.db $30 $90 $3c $00
	.db $90 $c0 $3e $05
	.db $90 $78 $40 $05
	.db $80 $70 $42 $05
	.db $80 $78 $44 $05
	.db $80 $88 $46 $05
	.db $90 $80 $48 $05
	.db $48 $50 $4a $02
	.db $60 $40 $4c $00


.include "code/ages/interactionCode/bank3f.s"

.include "code/ages/garbage/bank3fEnd.s"

.ends
