; Main file for Oracle of Seasons, US version

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
.include "include/musicMacros.s"

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
	.include "code/seasons/cutscenes/endgameCutscenes.s"
	.include "code/seasons/cutscenes/pirateShipDeparting.s"
	.include "code/seasons/cutscenes/volcanoErupting.s"
	.include "code/seasons/cutscenes/linkedGameCutscenes.s"
	.include "code/seasons/cutscenes/introCutscenes.s"


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

.include "data/seasons/uniqueGfxHeaders.s"
.include "data/seasons/uniqueGfxHeaderPointers.s"
.include "build/data/animationGroups.s"

animationGfxHeaders:
	.db $18 $65 $40 $88 $81 $03
	.db $18 $65 $80 $88 $81 $03
	.db $18 $65 $c0 $88 $81 $03
	.db $18 $66 $00 $88 $81 $03
	.db $18 $67 $60 $88 $c1 $01
	.db $18 $67 $a0 $88 $c1 $01
	.db $18 $67 $e0 $88 $c1 $01
	.db $18 $68 $20 $88 $c1 $01
	.db $18 $67 $40 $96 $01 $03
	.db $18 $67 $80 $96 $01 $03
	.db $18 $67 $c0 $96 $01 $03
	.db $18 $68 $00 $96 $01 $03
	.db $18 $67 $40 $88 $c1 $03
	.db $18 $67 $80 $88 $c1 $03
	.db $18 $67 $c0 $88 $c1 $03
	.db $18 $68 $00 $88 $c1 $03
	.db $18 $66 $40 $88 $c1 $03
	.db $18 $66 $80 $88 $c1 $03
	.db $18 $66 $c0 $88 $c1 $03
	.db $18 $67 $00 $88 $c1 $03
	.db $18 $69 $40 $96 $81 $01
	.db $18 $69 $60 $96 $81 $01
	.db $18 $69 $80 $96 $81 $01
	.db $18 $69 $a0 $96 $81 $01
	.db $18 $69 $40 $96 $31 $01
	.db $18 $69 $60 $96 $31 $01
	.db $18 $69 $80 $96 $31 $01
	.db $18 $69 $a0 $96 $31 $01
	.db $18 $68 $40 $88 $c1 $03
	.db $18 $68 $80 $88 $c1 $03
	.db $18 $68 $c0 $88 $c1 $03
	.db $18 $69 $00 $88 $c1 $03
	.db $18 $6c $00 $88 $c1 $03
	.db $18 $6c $40 $88 $c1 $03
	.db $18 $6c $80 $88 $c1 $03
	.db $18 $6c $c0 $88 $c1 $03
	.db $18 $6c $00 $93 $81 $03
	.db $18 $6c $40 $93 $81 $03
	.db $18 $6c $80 $93 $81 $03
	.db $18 $6c $c0 $93 $81 $03
	.db $18 $69 $e0 $88 $a1 $04
	.db $18 $6a $70 $88 $a1 $04
	.db $18 $6b $00 $88 $a1 $04
	.db $18 $6b $90 $88 $a1 $04
	.db $18 $69 $c0 $88 $81 $01
	.db $18 $6a $50 $88 $81 $01
	.db $18 $6a $e0 $88 $81 $01
	.db $18 $6b $70 $88 $81 $01
	.db $18 $69 $c0 $88 $81 $03
	.db $18 $6a $50 $88 $81 $03
	.db $18 $6a $e0 $88 $81 $03
	.db $18 $6b $70 $88 $81 $03
	.db $18 $64 $40 $88 $81 $07
	.db $18 $64 $c0 $88 $81 $07
	.db $18 $64 $00 $90 $91 $00
	.db $18 $64 $10 $90 $91 $00
	.db $18 $64 $20 $90 $91 $00
	.db $18 $64 $30 $90 $91 $00
	.db $18 $71 $80 $8d $81 $06
	.db $18 $72 $80 $8d $81 $06
	.db $18 $73 $80 $8d $81 $06
	.db $18 $74 $80 $8d $81 $06
	.db $18 $71 $f0 $8d $f1 $00
	.db $18 $72 $f0 $8d $f1 $00
	.db $18 $73 $f0 $8d $f1 $00
	.db $18 $74 $f0 $8d $f1 $00
	.db $18 $72 $00 $8f $01 $00
	.db $18 $73 $00 $8f $01 $00
	.db $18 $74 $00 $8f $01 $00
	.db $18 $75 $00 $8f $01 $00
	.db $18 $72 $00 $8f $01 $04
	.db $18 $73 $00 $8f $01 $04
	.db $18 $74 $00 $8f $01 $04
	.db $18 $75 $00 $8f $01 $04
	.db $18 $6d $00 $89 $01 $0a
	.db $18 $6d $b0 $89 $01 $0a
	.db $18 $6e $60 $89 $01 $0a
	.db $18 $6f $10 $89 $01 $0a
	.db $18 $6f $c0 $89 $b1 $00
	.db $18 $6f $d0 $89 $b1 $00
	.db $18 $6f $e0 $89 $b1 $00
	.db $18 $6f $f0 $89 $b1 $00
	.db $18 $70 $00 $89 $c1 $01
	.db $18 $70 $20 $89 $c1 $01
	.db $18 $70 $40 $89 $c1 $01
	.db $18 $70 $60 $89 $c1 $01
	.db $18 $70 $80 $89 $e1 $01
	.db $18 $70 $a0 $89 $e1 $01
	.db $18 $70 $c0 $89 $e1 $01
	.db $18 $70 $e0 $89 $e1 $01
	.db $18 $71 $00 $89 $e1 $01
	.db $18 $71 $20 $89 $e1 $01
	.db $18 $71 $40 $89 $e1 $01
	.db $18 $71 $60 $89 $e1 $01
	.db $18 $75 $80 $8d $01 $0d
	.db $18 $76 $80 $8d $01 $0d
	.db $18 $77 $80 $8d $01 $0d
	.db $18 $78 $80 $8d $01 $0d

.include "build/data/animationData.s"

.include "code/seasons/tileSubstitutions.s"
.include "build/data/singleTileChanges.s"
.include "code/seasons/roomSpecificTileChanges.s"

;;
; Fills a square in wRoomLayout using the data at hl.
; Data format:
; - Top-left position (YX)
; - Height
; - Width
; - Tile value
; @addr{6bb5}
fillRectInRoomLayout:
	ldi a,(hl)		; $669d
	ld e,a			; $669e
	ldi a,(hl)		; $669f
	ld b,a			; $66a0
	ldi a,(hl)		; $66a1
	ld c,a			; $66a2
	ldi a,(hl)		; $66a3
	ld d,a			; $66a4
	ld h,>wRoomLayout	; $66a5
--
	ld a,d			; $66a7
	ld l,e			; $66a8
	push bc			; $66a9
-
	ldi (hl),a		; $66aa
	dec c			; $66ab
	jr nz,-			; $66ac
	ld a,e			; $66ae
	add $10			; $66af
	ld e,a			; $66b1
	pop bc			; $66b2
	dec b			; $66b3
	jr nz,--		; $66b4
	ret			; $66b6

;;
; @param	bc	$0808
; @param	de	$c8f0 - d2 rupee room, $c8f8 - d6 rupee room
; @param	hl	top-left tile of rupees
replaceRupeeRoomRupees:
	ld a,(de)		; $66b7
	inc de			; $66b8
	push bc			; $66b9
-
	rrca			; $66ba
	jr nc,+			; $66bb
	ld (hl),TILEINDEX_STANDARD_FLOOR		; $66bd
+
	inc l			; $66bf
	dec b			; $66c0
	jr nz,-			; $66c1
	ld a,l			; $66c3
	add $08			; $66c4
	ld l,a			; $66c6
	pop bc			; $66c7
	dec c			; $66c8
	jr nz,replaceRupeeRoomRupees	; $66c9
	ret			; $66cb


.include "code/seasons/roomGfxChanges.s"


;;
; @addr{6ae4}
generateW3VramTilesAndAttributes:
	ld a,$03		; $6ae4
	ld ($ff00+$70),a	; $6ae6
	ld hl,$cf00		; $6ae8
	ld de,$d800		; $6aeb
	ld c,$0b		; $6aee
_label_04_317:
	ld b,$10		; $6af0
_label_04_318:
	push bc			; $6af2
	ldi a,(hl)		; $6af3
	push hl			; $6af4
	call setHlToTileMappingDataPlusATimes8		; $6af5
	push de			; $6af8
	call $6b16		; $6af9
	pop de			; $6afc
	set 2,d			; $6afd
	call $6b16		; $6aff
	res 2,d			; $6b02
	ld a,e			; $6b04
	sub $1f			; $6b05
	ld e,a			; $6b07
	pop hl			; $6b08
	pop bc			; $6b09
	dec b			; $6b0a
	jr nz,_label_04_318	; $6b0b
	ld a,$20		; $6b0d
	call addAToDe		; $6b0f
	dec c			; $6b12
	jr nz,_label_04_317	; $6b13
	ret			; $6b15

write4BytesToVramLayout:
	ldi a,(hl)		; $6b16
	ld (de),a		; $6b17
	inc e			; $6b18
	ldi a,(hl)		; $6b19
	ld (de),a		; $6b1a
	ld a,$1f		; $6b1b
	add e			; $6b1d
	ld e,a			; $6b1e
	ldi a,(hl)		; $6b1f
	ld (de),a		; $6b20
	inc e			; $6b21
	ldi a,(hl)		; $6b22
	ld (de),a		; $6b23
	ret			; $6b24
updateChangedTileQueue:
	ld a,($cd00)		; $6b25
	and $0e			; $6b28
	ret nz			; $6b2a
	ld b,$04		; $6b2b
_label_04_319:
	push bc			; $6b2d
	call $6b39		; $6b2e
	pop bc			; $6b31
	dec b			; $6b32
	jr nz,_label_04_319	; $6b33
	xor a			; $6b35
	ld ($ff00+$70),a	; $6b36
	ret			; $6b38

@handleSingleEntry:
	ld a,($ccf5)		; $6b39
	ld b,a			; $6b3c
	ld a,($ccf6)		; $6b3d
	cp b			; $6b40
	ret z			; $6b41
	inc b			; $6b42
	ld a,b			; $6b43
	and $1f			; $6b44
	ld ($ccf5),a		; $6b46
	ld hl,$dac0		; $6b49
	rst_addDoubleIndex			; $6b4c
	ld a,$02		; $6b4d
	ld ($ff00+$70),a	; $6b4f
	ldi a,(hl)		; $6b51
	ld c,(hl)		; $6b52
	ld b,a			; $6b53
	ld a,c			; $6b54
	ldh (<hFF8C),a	; $6b55
	ld a,($ff00+$70)	; $6b57
	push af			; $6b59
	ld a,$03		; $6b5a
	ld ($ff00+$70),a	; $6b5c
	call $6b7c		; $6b5e
	ld a,b			; $6b61
	call setHlToTileMappingDataPlusATimes8		; $6b62
	push hl			; $6b65
	push de			; $6b66
	call $6b16		; $6b67
	pop de			; $6b6a
	ld a,$04		; $6b6b
	add d			; $6b6d
	ld d,a			; $6b6e
	call $6b16		; $6b6f
	ldh a,(<hFF8C)	; $6b72
	pop hl			; $6b74
	call $6c17		; $6b75
	pop af			; $6b78
	ld ($ff00+$70),a	; $6b79
	ret			; $6b7b

getVramSubtileAddressOfTile:
	ld a,c			; $6b7c
	swap a			; $6b7d
	and $0f			; $6b7f
	ld hl,@addresses		; $6b81
	rst_addDoubleIndex			; $6b84
	ldi a,(hl)		; $6b85
	ld h,(hl)		; $6b86
	ld l,a			; $6b87
	ld a,c			; $6b88
	and $0f			; $6b89
	add a			; $6b8b
	rst_addAToHl			; $6b8c
	ld e,l			; $6b8d
	ld d,h			; $6b8e
	ret			; $6b8f

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

loadTilesetData_body:
	call getTempleRemainsSeasonsTilesetData		; $6c6d
	jr c,+			; $6c70
	call getMoblinKeepSeasonsTilesetData		; $6c72
	jr c,+			; $6c75
	ld a,(wActiveGroup)		; $6c77
	ld hl,roomTilesetsGroupTable		; $6c7a
	rst_addDoubleIndex			; $6c7d
	ldi a,(hl)		; $6c7e
	ld h,(hl)		; $6c7f
	ld l,a			; $6c80
	ld a,(wActiveRoom)		; $6c81
	rst_addAToHl			; $6c84
	ld a,(hl)		; $6c85
	and $80			; $6c86
	ldh (<hFF8B),a	; $6c88
	ld a,(hl)		; $6c8a
	and $7f			; $6c8b
	call multiplyABy8		; $6c8d
	ld hl,tilesetData		; $6c90
	add hl,bc		; $6c93
	ld a,(hl)		; $6c94
	inc a			; $6c95
	jr nz,+			; $6c96
	inc hl			; $6c98
	ldi a,(hl)		; $6c99
	ld h,(hl)		; $6c9a
	ld l,a			; $6c9b
	ld a,(wRoomStateModifier)		; $6c9c
	call multiplyABy8		; $6c9f
	add hl,bc		; $6ca2
+
	ldi a,(hl)		; $6ca3
	ld e,a			; $6ca4
	and $0f			; $6ca5
	cp $0f			; $6ca7
	jr nz,+			; $6ca9
	ld a,$ff		; $6cab
+
	ld (wDungeonIndex),a		; $6cad
	ld a,e			; $6cb0
	swap a			; $6cb1
	and $0f			; $6cb3
	ld (wActiveCollisions),a		; $6cb5
	ldi a,(hl)		; $6cb8
	ld (wTilesetFlags),a		; $6cb9
	ld b,$06		; $6cbc
	ld de,$cd20		; $6cbe
-
	ldi a,(hl)		; $6cc1
	ld (de),a		; $6cc2
	inc e			; $6cc3
	dec b			; $6cc4
	jr nz,-			; $6cc5
	ld e,$20		; $6cc7
	ld a,(de)		; $6cc9
	ld b,a			; $6cca
	ldh a,(<hFF8B)	; $6ccb
	or b			; $6ccd
	ld (de),a		; $6cce
	ld a,(wActiveGroup)		; $6ccf
	or a			; $6cd2
	ret nz			; $6cd3
	ld a,(wActiveRoom)		; $6cd4
	cp $96			; $6cd7
	ret nz			; $6cd9
	call getThisRoomFlags		; $6cda
	and $80			; $6cdd
	ret nz			; $6cdf
	ld a,$20		; $6ce0
	ld (wTilesetUniqueGfx),a		; $6ce2
	ret			; $6ce5

getTempleRemainsSeasonsTilesetData:
	ld a,GLOBALFLAG_S_15		; $6ce6
	call checkGlobalFlag		; $6ce8
	ret z			; $6ceb

	call checkIsTempleRemains		; $6cec
	ret nc			; $6cef

	ld a,(wRoomStateModifier)		; $6cf0
	call multiplyABy8		; $6cf3
	ld hl,templeRemainsSeasons		; $6cf6
	add hl,bc		; $6cf9
--
	xor a			; $6cfa
	ldh (<hFF8B),a	; $6cfb
	scf			; $6cfd
	ret			; $6cfe

; @param[out]	cflag	set if active room is temple remains
checkIsTempleRemains:
	ld a,(wActiveGroup)		; $6cff
	or a			; $6d02
	ret nz			; $6d03
	ld a,(wActiveRoom)		; $6d04
	cp $14			; $6d07
	jr c,+			; $6d09
	sub $04			; $6d0b
	cp $30			; $6d0d
	ret nc			; $6d0f
	and $0f			; $6d10
	cp $04			; $6d12
	ret			; $6d14
+
	xor a			; $6d15
	ret			; $6d16

getMoblinKeepSeasonsTilesetData:
	ld a,(wActiveGroup)		; $6d17
	or a			; $6d1a
	ret nz			; $6d1b

	call getMoblinKeepScreenIndex		; $6d1c
	ret nc			; $6d1f

	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED		; $6d20
	call checkGlobalFlag		; $6d22
	ret z			; $6d25

	ld a,(wAnimalCompanion)		; $6d26
	sub $0a			; $6d29
	and $03			; $6d2b
	call multiplyABy8		; $6d2d
	ld hl,moblinKeepSeasons		; $6d30
	add hl,bc		; $6d33
	jr --			; $6d34

;;
; @param[out]	cflag	Set if active room is in Moblin keep
getMoblinKeepScreenIndex:
	ld a,(wActiveRoom)		; $6d36
	ld b,$05		; $6d39
	ld hl,moblinKeepRooms		; $6d3b
-
	cp (hl)			; $6d3e
	jr z,+			; $6d3f
	inc hl			; $6d41
	dec b			; $6d42
	jr nz,-			; $6d43
	xor a			; $6d45
	ret			; $6d46
+
	scf			; $6d47
	ret			; $6d48

moblinKeepRooms:
	.db $5b $5c $6b $6c $7b

	.include "build/data/warpData.s"


.BANK $05 SLOT 1
.ORG 0

 m_section_force "Bank_5" NAMESPACE bank5

	.include "code/bank5.s"
	.include "build/data/tileTypeMappings.s"
	.include "build/data/cliffTilesTable.s"
	.include "code/seasons/subrosiaDanceLink.s"

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


_itemUsageParameterTable:
	.db $00 <wGameKeysPressed       ; ITEMID_NONE
	.db $05 <wGameKeysPressed       ; ITEMID_SHIELD
	.db $03 <wGameKeysJustPressed   ; ITEMID_PUNCH
	.db $23 <wGameKeysJustPressed   ; ITEMID_BOMB
	.db $00 <wGameKeysJustPressed   ; ITEMID_CANE_OF_SOMARIA
	.db $63 <wGameKeysJustPressed   ; ITEMID_SWORD
	.db $02 <wGameKeysJustPressed   ; ITEMID_BOOMERANG
	.db $33 <wGameKeysJustPressed   ; ITEMID_ROD_OF_SEASONS
	.db $53 <wGameKeysJustPressed   ; ITEMID_MAGNET_GLOVES
	.db $00 <wGameKeysJustPressed   ; ITEMID_SWITCH_HOOK_HELPER
	.db $00 <wGameKeysJustPressed   ; ITEMID_SWITCH_HOOK
	.db $00 <wGameKeysJustPressed   ; ITEMID_SWITCH_HOOK_CHAIN
	.db $73 <wGameKeysJustPressed   ; ITEMID_BIGGORON_SWORD
	.db $02 <wGameKeysJustPressed   ; ITEMID_BOMBCHUS
	.db $05 <wGameKeysJustPressed   ; ITEMID_FLUTE
	.db $00 <wGameKeysJustPressed   ; ITEMID_SHOOTER
	.db $00 <wGameKeysJustPressed   ; ITEMID_10
	.db $00 <wGameKeysJustPressed   ; ITEMID_HARP
	.db $00 <wGameKeysJustPressed   ; ITEMID_12
	.db $43 <wGameKeysJustPressed   ; ITEMID_SLINGSHOT
	.db $00 <wGameKeysJustPressed   ; ITEMID_14
	.db $13 <wGameKeysJustPressed   ; ITEMID_SHOVEL
	.db $13 <wGameKeysPressed       ; ITEMID_BRACELET
	.db $01 <wGameKeysJustPressed   ; ITEMID_FEATHER
	.db $00 <wGameKeysJustPressed   ; ITEMID_18
	.db $02 <wGameKeysJustPressed   ; ITEMID_SEED_SATCHEL
	.db $00 <wGameKeysJustPressed   ; ITEMID_DUST
	.db $00 <wGameKeysJustPressed   ; ITEMID_1b
	.db $00 <wGameKeysJustPressed   ; ITEMID_1c
	.db $00 <wGameKeysJustPressed   ; ITEMID_MINECART_COLLISION
	.db $03 <wGameKeysJustPressed   ; ITEMID_FOOLS_ORE
	.db $00 <wGameKeysJustPressed   ; ITEMID_1f


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

	.include "data/seasons/specialObjectAnimationData.s"
	.include "code/seasons/cutscenes/companionCutscenes.s"
	.include "code/seasons/cutscenes/linkCutscenes.s"
	.include "build/data/signText.s"
	.include "build/data/breakableTileCollisionTable.s"

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
	.include "data/seasons/itemAttributes.s"
	.include "data/itemAnimations.s"

.ends


 ; This section can't be superfree, since it must be in the same bank as section
 ; "Enemy_Part_Collisions".
 m_section_free "Bank_7_Data" namespace "bank7"

	.include "data/seasons/enemyActiveCollisions.s"
	.include "data/seasons/partActiveCollisions.s"
	.include "data/seasons/objectCollisionTable.s"

.ends


.BANK $08 SLOT 1
.ORG 0

	.include "code/seasons/interactionCode/bank08.s"

.BANK $09 SLOT 1
.ORG 0

	.include "code/seasons/interactionCode/bank09.s"

.BANK $0a SLOT 1
.ORG 0

	.include "code/seasons/interactionCode/bank0a.s"

.BANK $0b SLOT 1
.ORG 0

	.include "code/scripting.s"
	.include "scripts/seasons/scripts.s"


.BANK $0c SLOT 1
.ORG 0

.section Enemy_Code_Bank0c

	.include "code/enemyCommon.s"
	.include "code/seasons/enemyCode/bank0c.s"
	.include "data/seasons/enemyAnimations.s"

.ends

.BANK $0d SLOT 1
.ORG 0

.section Enemy_Code_Bank0d

	.include "code/enemyCommon.s"
	.include "code/seasons/enemyCode/bank0d.s"

;;
; Called from objectRunMovementScript in bank0. See include/movementscript_commands.s.
;
; @param	hl	Script address
; @addr{6b2d}
objectLoadMovementScript_body:
	ldh a,(<hActiveObjectType)	; $6b2d
	add Object.subid			; $6b2f
	ld e,a			; $6b31
	ld a,(de)		; $6b32
	rst_addDoubleIndex			; $6b33
	ldi a,(hl)		; $6b34
	ld h,(hl)		; $6b35
	ld l,a			; $6b36

	ld a,e			; $6b37
	add Object.speed-Object.subid			; $6b38
	ld e,a			; $6b3a
	ldi a,(hl)		; $6b3b
	ld (de),a		; $6b3c

	ld a,e			; $6b3d
	add Object.direction-Object.speed			; $6b3e
	ld e,a			; $6b40
	ldi a,(hl)		; $6b41
	ld (de),a		; $6b42

	ld a,e			; $6b43
	add Object.var30-Object.direction 			; $6b44
	ld e,a			; $6b46
	ld a,l			; $6b47
	ld (de),a		; $6b48
	inc e			; $6b49
	ld a,h			; $6b4a
	ld (de),a		; $6b4b

;;
; Called from objectRunMovementScript in bank0. See include/movementscript_commands.s.
; @addr{6b4c}
objectRunMovementScript_body:
	ldh a,(<hActiveObjectType)	; $6b4c
	add Object.var30			; $6b4e
	ld e,a			; $6b50
	ld a,(de)		; $6b51
	ld l,a			; $6b52
	inc e			; $6b53
	ld a,(de)		; $6b54
	ld h,a			; $6b55

@nextOp:
	ldi a,(hl)		; $6b56
	push hl			; $6b57
	rst_jumpTable			; $6b58
	.dw @cmd00_jump
	.dw @moveUp
	.dw @moveRight
	.dw @moveDown
	.dw @moveLeft
	.dw @wait
.ifdef ROM_AGES
	.dw @setstate
.endif


@cmd00_jump:
	pop hl			; $6b67
	ldi a,(hl)		; $6b68
	ld h,(hl)		; $6b69
	ld l,a			; $6b6a
	jr @nextOp		; $6b6b


@moveUp:
	pop bc			; $6b6d
	ld h,d			; $6b6e
	ldh a,(<hActiveObjectType)	; $6b6f
	add Object.var32			; $6b71
	ld l,a			; $6b73
	ld a,(bc)		; $6b74
	ld (hl),a		; $6b75

	ld a,l			; $6b76
	add Object.angle-Object.var32			; $6b77
	ld l,a			; $6b79
	ld (hl),ANGLE_UP		; $6b7a

	add Object.state-Object.angle			; $6b7c
	ld l,a			; $6b7e
	ld (hl),$08		; $6b7f
	jr @storePointer		; $6b81


@moveRight:
	pop bc			; $6b83
	ld h,d			; $6b84
	ldh a,(<hActiveObjectType)	; $6b85
	add Object.var33			; $6b87
	ld l,a			; $6b89
	ld a,(bc)		; $6b8a
	ld (hl),a		; $6b8b

	ld a,l			; $6b8c
	add Object.angle-Object.var33			; $6b8d
	ld l,a			; $6b8f
	ld (hl),ANGLE_RIGHT		; $6b90

	add Object.state-Object.angle			; $6b92
	ld l,a			; $6b94
	ld (hl),$09		; $6b95
	jr @storePointer		; $6b97


@moveDown:
	pop bc			; $6b99
	ld h,d			; $6b9a
	ldh a,(<hActiveObjectType)	; $6b9b
	add Object.var32			; $6b9d
	ld l,a			; $6b9f
	ld a,(bc)		; $6ba0
	ld (hl),a		; $6ba1

	ld a,l			; $6ba2
	add Object.angle-Object.var32			; $6ba3
	ld l,a			; $6ba5
	ld (hl),ANGLE_DOWN		; $6ba6

	add Object.state-Object.angle			; $6ba8
	ld l,a			; $6baa
	ld (hl),$0a		; $6bab
	jr @storePointer		; $6bad


@moveLeft:
	pop bc			; $6baf
	ld h,d			; $6bb0
	ldh a,(<hActiveObjectType)	; $6bb1
	add Object.var33			; $6bb3
	ld l,a			; $6bb5
	ld a,(bc)		; $6bb6
	ld (hl),a		; $6bb7

	ld a,l			; $6bb8
	add Object.angle-Object.var33			; $6bb9
	ld l,a			; $6bbb
	ld (hl),ANGLE_LEFT		; $6bbc

	add Object.state-Object.angle			; $6bbe
	ld l,a			; $6bc0
	ld (hl),$0b		; $6bc1
	jr @storePointer		; $6bc3


@wait:
	pop bc			; $6bc5
	ld h,d			; $6bc6
	ldh a,(<hActiveObjectType)	; $6bc7
	add Object.counter1			; $6bc9
	ld l,a			; $6bcb
	ld a,(bc)		; $6bcc
.ifdef ROM_AGES
	ldd (hl),a		; $6bcd

	dec l			; $6bce
	ld (hl),$0c ; [state]
.else
	ld (hl),a		; $7a2d
	ld a,l			; $7a2e
	add $fe			; $7a2f
	ld l,a			; $7a31
	ld (hl),$0c		; $7a32
.endif

@storePointer:
	inc bc			; $6bd1
.ifdef ROM_AGES
	ld a,l			; $6bd2
.endif
	add Object.var30-Object.state			; $6bd3
	ld l,a			; $6bd5
	ld (hl),c		; $6bd6
	inc l			; $6bd7
	ld (hl),b		; $6bd8
	ret			; $6bd9

.ifdef ROM_AGES
@setstate:
	pop bc			; $6bda
	ld h,d			; $6bdb
	ldh a,(<hActiveObjectType)	; $6bdc
	add Object.counter1			; $6bde
	ld l,a			; $6be0
	ld a,(bc)		; $6be1
	ldd (hl),a		; $6be2

	dec l			; $6be3
	inc bc			; $6be4
	ld a,(bc)		; $6be5
	ld (hl),a ; [state]

	jr @storePointer		; $6be7
.endif

; @addr{7a3c}
	.dw unknownData_0d_7a66
	.dw unknownData_0d_7a6f
	.dw unknownData_0d_7a78
	.dw unknownData_0d_7a81
	.dw unknownData_0d_7a8a
	.dw unknownData_0d_7a93
	.dw unknownData_0d_7a9c
	.dw unknownData_0d_7aa5
	.dw unknownData_0d_7aae
	.dw unknownData_0d_7ab7
	.dw unknownData_0d_7ac0
	.dw unknownData_0d_7ac9
	.dw unknownData_0d_7ad6
	.dw unknownData_0d_7ae3
	.dw unknownData_0d_7aec
	.dw unknownData_0d_7af5
	.dw unknownData_0d_7b02
	.dw unknownData_0d_7b0b
	.dw unknownData_0d_7b14
	.dw unknownData_0d_7b1d
	.dw unknownData_0d_7b26

unknownData_0d_7a66:
	.db $14 $00 $02 $6a $04 $4a $00 $68 $7a
unknownData_0d_7a6f:
	.db $14 $00 $04 $96 $02 $b6 $00 $71 $7a
unknownData_0d_7a78:
	.db $14 $00 $01 $28 $03 $58 $00 $7a $7a
unknownData_0d_7a81:
	.db $14 $00 $04 $50 $02 $a0 $00 $83 $7a
unknownData_0d_7a8a:
	.db $14 $00 $04 $50 $02 $80 $00 $8c $7a
unknownData_0d_7a93:
	.db $14 $00 $02 $70 $04 $40 $00 $95 $7a
unknownData_0d_7a9c:
	.db $14 $00 $04 $40 $02 $b0 $00 $9e $7a
unknownData_0d_7aa5:
	.db $14 $00 $01 $68 $03 $98 $00 $a7 $7a
unknownData_0d_7aae:
	.db $14 $02 $01 $38 $03 $88 $00 $b0 $7a
unknownData_0d_7ab7:
	.db $14 $02 $03 $88 $01 $38 $00 $b9 $7a
unknownData_0d_7ac0:
	.db $14 $03 $04 $40 $02 $90 $00 $c2 $7a
unknownData_0d_7ac9:
	.db $14 $00 $02 $88 $03 $68 $04 $78 $01 $28 $00 $cb $7a
unknownData_0d_7ad6:
	.db $14 $00 $04 $a8 $03 $88 $02 $c0 $01 $38 $00 $d8 $7a
unknownData_0d_7ae3:
	.db $14 $00 $02 $60 $04 $30 $00 $e5 $7a
unknownData_0d_7aec:
	.db $14 $00 $02 $a0 $04 $70 $00 $ee $7a
unknownData_0d_7af5:
	.db $14 $01 $03 $88 $05 $1e $01 $68 $05 $1e $00 $f7 $7a
unknownData_0d_7b02:
	.db $14 $02 $03 $88 $01 $68 $00 $04 $7b
unknownData_0d_7b0b:
	.db $14 $02 $03 $88 $01 $48 $00 $0d $7b
unknownData_0d_7b14:
	.db $14 $02 $01 $48 $03 $88 $00 $16 $7b
unknownData_0d_7b1d:
	.db $14 $00 $01 $28 $03 $88 $00 $1f $7b
unknownData_0d_7b26:
	.db $14 $00 $03 $88 $01 $28 $00 $28 $7b

; @addr{7b2f}
	.dw unknownData_0d_7b39
	.dw unknownData_0d_7b46
	.dw unknownData_0d_7b4f
	.dw unknownData_0d_7b58
	.dw unknownData_0d_7b65

unknownData_0d_7b39:
	.db $14 $01 $02 $50 $03 $88 $04 $38 $01 $38 $00 $3b $7b
unknownData_0d_7b46:
	.db $14 $00 $03 $88 $01 $28 $00 $48 $7b
unknownData_0d_7b4f:
	.db $14 $01 $01 $28 $03 $88 $00 $51 $7b
unknownData_0d_7b58:
	.db $14 $01 $01 $28 $02 $80 $03 $88 $04 $40 $00 $5a $7b
unknownData_0d_7b65:
	.db $14 $00 $01 $38 $04 $40 $03 $78 $02 $a0 $00 $67 $7b

.ends

.BANK $0e SLOT 1
.ORG 0

.section Enemy_Code_Bank0e

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "code/seasons/enemyCode/bank0e.s"

.ends

.BANK $0f SLOT 1
.ORG 0

.section Enemy_Code_Bank0f

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "code/seasons/enemyCode/bank0f.s"
	.include "code/seasons/cutscenes/transitionToDragonOnox.s"

	.REPT $87
	.db $0f ; emptyfill
	.ENDR

	.include "code/seasons/interactionCode/bank0f.s"

.ends

.BANK $10 SLOT 1
.ORG 0

	.define PART_BANK $10
	.export PART_BANK

 m_section_force "Part_Code" NAMESPACE "partCode"

	.include "code/partCommon.s"
	.include "code/seasons/partCode.s"

.ends


.BANK $11 SLOT 1
.ORG 0

	.include "code/objectLoading.s"

 m_section_free "Objects_2" namespace "objectData"
	.include "objects/seasons/pointers.s"
	.include "objects/seasons/mainData.s"
	.include "objects/seasons/extraData3.s"
.ends


.BANK $12 SLOT 1
.ORG 0

	.define BASE_OAM_DATA_BANK $12
	.export BASE_OAM_DATA_BANK

	.include "data/seasons/specialObjectOamData.s"
	.include "data/itemOamData.s"
	.include "data/seasons/enemyOamData.s"


.BANK $13 SLOT 1
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

	.include "data/seasons/interactionOamData.s"
	.include "data/seasons/partOamData.s"


.BANK $14 SLOT 1
.ORG 0

	.include "build/data/data_4556.s"
	.include "scripts/seasons/scripts2.s"
	.include "data/seasons/interactionAnimations.s"


.BANK $15 SLOT 1
.ORG 0

.include "code/serialFunctions.s"

	.include "code/seasons/scriptHelper/scriptHlp1.s"
	.include "code/seasons/interactionCode/bank15_1.s"

	.include "code/staticObjects.s"
	.include "build/data/staticDungeonObjects.s"
	.include "build/data/chestData.s"

	.include "build/data/treasureObjectData.s"

	.include "code/seasons/scriptHelper/scriptHlp2.s"
	.include "code/seasons/interactionCode/bank15_2.s"

	.include "data/seasons/partAnimations.s"


.BANK $16 SLOT 1
.ORG 0

	.include "build/data/paletteData.s"
	.include "build/data/tilesetCollisions.s"
	.include "build/data/smallRoomLayoutTables.s"

.BANK $17 SLOT 1
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
.ends

.BANK $18 SLOT 1
.ORG 0

	.include "build/data/largeRoomLayoutTables.s"

	m_GfxDataSimple gfx_animations_1
	m_GfxDataSimple gfx_animations_2
	m_GfxDataSimple gfx_animations_3
	m_GfxDataSimple gfx_063940

	; Compressed graphics file, for some reason doesn't go in gfxDataMain.s.
	m_GfxDataSimple gfx_credits_sprites_2


.BANK $19 SLOT 1
.ORG 0

 m_section_superfree "Tile_mappings"
	.include "build/data/tilesetMappings.s"
.ends


.BANK $1a SLOT 1
.ORG 0
	.include "data/gfxDataBank1a.s"


.BANK $1b SLOT 1
.ORG 0
	.include "data/gfxDataBank1b.s"


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

	; TODO: where does "build/data/largeRoomLayoutTables.s" go?


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
	.include "code/seasons/interactionCode/interactionCode11_body.s"

	.include "build/data/objectGfxHeaders.s"
	.include "build/data/treeGfxHeaders.s"

	.include "build/data/enemyData.s"
	.include "build/data/partData.s"
	.include "build/data/itemData.s"
	.include "build/data/interactionData.s"

	.include "build/data/treasureCollectionBehaviours.s"
	.include "build/data/treasureDisplayData.s"

.ends
