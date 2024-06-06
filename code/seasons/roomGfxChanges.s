; Some code here is the same as code/ages/roomGfxChanges.s, but almost all room-specific stuff is
; different, so the codebases are separated.

;;
; Get the gasha spot index for the gasha spot in the given room.
;
; NOTE: If there is no gasha spot in that room, the output of this function is unreliable.
;
; @param	a	Room
; @param[out]	c	Gasha spot index
; @param[out]	zflag	z if nothing is planted in the given room.
getIndexOfGashaSpotInRoom_body:
	ld c,$00
	ld hl,gashaSpotRooms
--
	cp (hl)
	jr z,+
	inc hl
	inc c
	jr --
+
	ld a,c
	ld hl,wGashaSpotsPlantedBitset
	jp checkFlag


; This is a list of room IDs (the low bytes only) where gasha spots are located.
;
; If this is not set correctly, the gasha tree may not appear after planting the seed
; (although it's possible that the nut will still be there, floating in midair?)
;
; In order to prevent the above scenario, it will also be necessary to adjust the
; "applyRoomSpecificTileChangesAfterGfxLoad" function such that these rooms load the gasha
; tree graphics.
;
; Note: since this doesn't track the group numbers, it won't work properly if there are
; gasha spots on the same map in the past/present.
; ie. You can't have a gasha spot on both maps $050 and $150.

gashaSpotRooms:
	.db $1f $22 $38 $3b $44 $3f $75 $80 ; Subids 0-7
	.db $89 $95 $a6 $ac $c0 $ef $f0 $c8 ; Subids 8-f

;;
applyRoomSpecificTileChangesAfterGfxLoad:
	ld a,(wActiveRoom)
	ld hl,@tileChangesGroupTable
	call findRoomSpecificData
	ret nc
	rst_jumpTable
	.dw roomTileChangesAfterLoad00
	.dw roomTileChangesAfterLoad01
	.dw  roomTileChangesAfterLoad02 ; Located in bank 0 / bank 9 for some reason
	.dw roomTileChangesAfterLoad03
	.dw roomTileChangesAfterLoad04
	.dw roomTileChangesAfterLoad05
	.dw roomTileChangesAfterLoad06
	.dw roomTileChangesAfterLoad07
	.dw roomTileChangesAfterLoad08
	.dw roomTileChangesAfterLoad09
	.dw roomTileChangesAfterLoad0a
	.dw roomTileChangesAfterLoad0b
	.dw roomTileChangesAfterLoad0c
	.dw roomTileChangesAfterLoad0d
	.dw roomTileChangesAfterLoad0e
	.dw roomTileChangesAfterLoad0f

@tileChangesGroupTable:
	.dw @group0
	.dw @group1
	.dw @group2
	.dw @group3
	.dw @group4
	.dw @group5
	.dw @group6
	.dw @group7

; Values:
; $00: Pirate ship bow (at beach)
; $01: Pirate ship middle (at beach)
; $02: D6 wall-closing rooms
; $03: Din's troupe screen
; $04: Used in shops (loads price graphics, sets wInShop to be nonzero)
; $05: King Moblin's house (not moblin's keey)
; $06: Blaino's gym (draws gloves on roof)
; $07: Vasu's shop (draws ring sign)
; $08: Gasha spot (draws the tree or the plant if something has been planted)
; $09: Load scent tree graphics (north horon)
; $0a: Load pegasus tree graphics (spool swamp)
; $0b: Load gale tree graphics (tarm ruins)
; $0c: Load gale tree graphics (sunken city)
; $0d: Load mystery tree graphics (woods of winter)
; $0e: West of din's troupe: create wagon
; $0f: Maku tree entrance & one screen south: forbid digging up enemies

@group0:
	.db $98 $03
	.db $78 $06
	.db $e8 $07
	.db $e2 $00
	.db $f2 $01
	.db $1f $08
	.db $22 $08
	.db $38 $08
	.db $3b $08
	.db $44 $08
	.db $3f $08
	.db $75 $08
	.db $80 $08
	.db $89 $08
	.db $95 $08
	.db $a6 $08
	.db $ac $08
	.db $c0 $08
	.db $ef $08
	.db $f0 $08
	.db $c8 $08
	.db $67 $09
	.db $72 $0a
	.db $10 $0b
	.db $5f $0c
	.db $9e $0d
	.db $97 $0e
	.db $d9 $0f
	.db $e9 $0f
	.db $00
@group1:
@group2:
@group3:
	.db $9c $04
	.db $a6 $04
	.db $b0 $04
	.db $af $04
	.db $aa $05
	.db $00
@group4:
	.db $c5 $02
	.db $c6 $02
	.db $00
@group5:
@group6:
@group7:
	.db $00


;;
; $09: Load scent tree graphics (north horon)
roomTileChangesAfterLoad09:
	ld a,TREE_GFXH_07
label_04_291:
	call loadTreeGfx
	ld hl,@rect
	jp drawRectangleToVramTiles

@rect:
	.dw w3VramTiles+$88
	.db $03 $04
	.db $20 $02 $21 $02 $22 $02
	.db $23 $02 $24 $02 $25 $02
	.db $26 $02 $27 $02 $28 $03
	.db $29 $03 $2a $03 $2b $03

;;
; $0a: Load pegasus tree graphics (spool swamp)
roomTileChangesAfterLoad0a:
	ld a,TREE_GFXH_08
	jr label_04_291

;;
; $0b: Load gale tree graphics (tarm ruins)
roomTileChangesAfterLoad0b:
	ld hl,loadGaleTreeGfx@rect
loadGaleTreeGfx:
	call drawRectangleToVramTiles
	ld a,TREE_GFXH_09
	jp loadTreeGfx

@rect:
	.dw w3VramTiles+$48
	.db $03 $04
	.db $20 $02 $21 $02 $22 $02
	.db $23 $02 $24 $02 $25 $02
	.db $26 $02 $27 $02 $28 $04
	.db $29 $03 $2a $03 $2b $04

;;
; $0c: Load gale tree graphics (sunken city)
roomTileChangesAfterLoad0c:
	ld hl,@rect
	jr loadGaleTreeGfx

@rect:
	.dw w3VramTiles+$86
	.db $03 $04
	.db $20 $02 $21 $02 $22 $02
	.db $23 $02 $24 $02 $25 $02
	.db $26 $02 $27 $02 $28 $04
	.db $29 $03 $2a $03 $2b $04

;;
; $0d: Load mystery tree graphics (woods of winter)
roomTileChangesAfterLoad0d:
	ld a,TREE_GFXH_0a
	call loadTreeGfx
	ld hl,@rect
	jp drawRectangleToVramTiles

@rect:
	.dw w3VramTiles+$88
	.db $03 $04
	.db $20 $02 $21 $02 $22 $02
	.db $23 $02 $24 $02 $25 $02
	.db $26 $02 $27 $02 $28 $02
	.db $29 $02 $2a $03 $2b $02

;;
; $00: Pirate ship bow (at beach)
roomTileChangesAfterLoad00:
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	call checkGlobalFlag
	ret z

	; Load extra tileset graphics
	ld e,OBJ_GFXH_PIRATE_SHIP_TILES_1 - 1
	call loadObjectGfxHeaderToSlot4

	; Load new tilemaps
	ld a,GFXH_PIRATE_SHIP_BOW_TILEMAP
	call loadGfxHeader

	ld hl,@vramTiles
	call copyRectangleFromTmpGfxBuffer
	ld hl,@vramAttributes
	call copyRectangleFromTmpGfxBuffer
	ld hl,@roomLayout
	jp copyRectangleToRoomLayoutAndCollisions

@vramTiles:
	.db $0a $0a
	.dw w3VramTiles+$c8
	.dw w2TmpGfxBuffer

@vramAttributes:
	.db $0a $0a
	.dw w3VramAttributes+$c8
	.dw w2TmpGfxBuffer+$400

@roomLayout:
	.dw wRoomLayout+$34
	.db $05 05
	.db $af $00 $af $00 $00 $00 $af $00 $af $00
	.db $af $00 $00 $00 $00 $00 $00 $00 $af $00
	.db $fb $07 $00 $0e $00 $0c $00 $0d $fb $0b
	.db $00 $0e $00 $0f $e7 $00 $00 $00 $00 $0d
	.db $00 $0a $00 $00 $00 $00 $00 $00 $00 $05 

;;
; $01: Pirate ship middle (at beach)
roomTileChangesAfterLoad01:
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	call checkGlobalFlag
	ret z

	; Load extra tileset graphics
	ld e,OBJ_GFXH_PIRATE_SHIP_TILES_1 - 1
	call loadObjectGfxHeaderToSlot4

	; Load new tilemaps
	ld a,GFXH_PIRATE_SHIP_BODY_TILEMAP
	call loadGfxHeader

	ld hl,@vramTiles
	call copyRectangleFromTmpGfxBuffer
	ld hl,@vramAttributes
	call copyRectangleFromTmpGfxBuffer
	ld hl,@roomLayout
	jp copyRectangleToRoomLayoutAndCollisions

@vramTiles:
	.db $14 $0a
	.dw w3VramTiles+$08
	.dw w2TmpGfxBuffer+$140

@vramAttributes:
	.db $14 $0a
	.dw w3VramAttributes+$08
	.dw w2TmpGfxBuffer+$540

@roomLayout:
	.dw wRoomLayout+$04
	.db $02 $05
	.db $00 $0a $00 $00
	.db $00 $00 $00 $00
	.db $00 $05 $00 $00
	.db $00 $00 $00 $00
	.db $00 $00 $00 $00

;;
; $03: Din's troupe screen: Draw tents and stuff if they should be there.
roomTileChangesAfterLoad03:
	call getThisRoomFlags
	and $40
	ret nz

	xor a
	ld (wRoomLayout+$14),a
	ld (wRoomLayout+$24),a

	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc

	ld de,dinsTroupeVramAndCollisions

loadDinsTroupeTileChanges:
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a

@getAddress:
	ld a,(de)
	ld l,a
	inc de
	or a
	jr z,@doneReadingVramTiles
	ld a,(de)
	ld h,a
	inc de

@getTilePair:
	ld a,(de)
	ld b,a
	inc de
	or a
	jr z,@getAddress

	ld a,(de)
	ld c,a
	inc de
	push hl
	ld (hl),b
	set 2,h
	ld (hl),c
	ld a,$20
	rst_addAToHl
	inc b
	ld (hl),c
	res 2,h
	ld (hl),b
	pop hl
	inc hl
	jr @getTilePair

@doneReadingVramTiles:
	ld l,e
	ld h,d
	ld d,>wRoomCollisions
@nextAddress:
	ldi a,(hl)
	or a
	jr z,@done
	ld e,a
	ld a,$0f
	bit 7,e
	jr z,++
	res 7,e
	ld a,$05
++
	ld (de),a
	jr @nextAddress

@done:
	pop bc
	ld a,b
	setrombank
	ld a,c
	ld ($ff00+R_SVBK),a
	ld a,TREE_GFXH_02
	jp loadTreeGfx

; Values are written in pairs, vertically. Example: at "w3VramTiles+$0e" the row below it,
; values $36 and $37 are written, both with attribute $24.
dinsTroupeVramAndCollisions:
	.dw w3VramTiles+$0e
	.db $36 $24
	.db $34 $24
	.db $32 $04
	.db $00
	.dw w3VramTiles+$50
	.db $34 $04
	.db $36 $04
	.db $00
	.dw w3VramTiles+$10a
	.db $30 $04
	.db $30 $24
	.db $00
	.dw w3VramTiles+$18b
	.db $32 $04
	.db $20 $04
	.db $22 $04
	.db $24 $04
	.db $26 $04
	.db $00
	.dw w3VramTiles+$1ca
	.db $32 $04
	.db $00
	.dw w3VramTiles+$1cc
	.db $28 $05
	.db $2a $05
	.db $2c $05
	.db $2e $05
	.db $34 $04
	.db $36 $04
	.db $00
	.db $00

	; Each following byte is the low byte for an address in wRoomCollisions which
	; should be set to solid. If bit 7 is set, the collision is $05 instead (partial
	; solidity).

	.db $07 $08 $18 $45 $e5 $66 $67 $75 $76 $77 $78
	.db $00


;;
; $0e: West of din's troupe: create wagon
roomTileChangesAfterLoad0e:
	ld a,GLOBALFLAG_INTRO_DONE
	call checkGlobalFlag
	ret nz

	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc
	ld de,@vramTilesAndCollisions
	jp loadDinsTroupeTileChanges

; Same format as data above
@vramTilesAndCollisions:
	.dw w3VramTiles+$14a
	.db $20 $04
	.db $22 $04
	.db $24 $04
	.db $26 $04
	.db $00
	.dw w3VramTiles+$18a
	.db $28 $05
	.db $2a $05
	.db $2c $05
	.db $2e $05
	.db $00
	.db $00

	.db $55 $56 $65 $66
	.db $00

;;
; $05: King Moblin's house (not moblin's keep)
roomTileChangesAfterLoad05:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	ret z
	ld e,$08
	call loadObjectGfxHeaderToSlot4
	ld hl,@rect
	jp drawRectangleToVramTiles

@rect:
	.dw w3VramTiles+$4c
	.db $04 $06
	.db $42 $0c $88 $06 $81 $06 $81 $26
	.db $88 $26 $43 $0c $52 $0c $82 $06
	.db $89 $06 $89 $06 $82 $26 $53 $0c
	.db $86 $06 $83 $06 $89 $06 $89 $06
	.db $83 $26 $86 $26 $87 $06 $84 $06
	.db $85 $06 $85 $26 $84 $26 $87 $26

;;
; $06: Blaino's gym (draws gloves on roof)
roomTileChangesAfterLoad06:
	ld a,TREE_GFXH_01
	call loadTreeGfx
	ld hl,@rect
	jp drawRectangleToVramTiles

@rect:
	.dw w3VramTiles+$4b
	.db $03 $04
	.db $20 $00 $21 $00 $22 $00
	.db $23 $00 $24 $00 $25 $00
	.db $26 $00 $27 $00 $28 $00
	.db $29 $00 $2a $00 $2b $00

;;
; $07: Vasu's shop (draws ring sign)
roomTileChangesAfterLoad07:
	ld a,$01
	call loadTreeGfx
	ld hl,vasuSignRect
	call drawRectangleToVramTiles

	; Fall through (forbid digging up enemies on vasu screen)

;;
; $0f: Maku tree entrance & one screen south: forbid digging up enemies
roomTileChangesAfterLoad0f:
	ld a,$01
	ld (wDiggingUpEnemiesForbidden),a
	ret


vasuSignRect:
	.dw w3VramTiles+$ca
	.db $02 $02
	.db $2c $00 $2d $00
	.db $2e $00 $2f $00


;;
; $08: Gasha spot (draws the tree or the plant if something has been planted)
roomTileChangesAfterLoad08:
	; Return if a gasha seed is not planted in this room.
	ld a,(wActiveRoom)
	call getIndexOfGashaSpotInRoom_body
	ret z
	; 'c' now contains the gasha spot index.

	ld a,TILEINDEX_SOFT_SOIL
	call findTileInRoom
	ret nz

	ld e,l
	ld d,>wRoomLayout

	; Check if at least 20 enemies have been killed
	ld a,c
	ld hl,wGashaSpotKillCounters
	rst_addAToHl
	ld a,(hl)
	cp 20
	jr c,+

	; If so, load the tree graphics
	ld a,e
	sub $10
	ld e,a
	ld hl,@treeLayout
	jr ++
+
	ld hl,@sproutLayout
++
	call copyRectangleToRoomLayoutAndCollisions_paramDe

	; Regenerate graphics after modifying wRoomLayout
	jp tilesets.generateW3VramTilesAndAttributes

@sproutLayout:
	.db $01 $01
	.db TILEINDEX_SOFT_SOIL_PLANTED $00

@treeLayout:
	.db $02 $02
	.db $75 $0f $76 $0f
	.db $85 $0f $86 $0f

;;
; This function is used by "drawRectangleToVramTiles".
readParametersForRectangleDrawing:
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ret

;;
; Unused in seasons?
;
; @param	b	# of columns to write before moving to next row
; @param	c	# of rows
; @param	de	Where to write the data (should point to w3VramTiles)
; @param	hl	The address of the data to write to the given address
drawRectangleToVramTiles_withParameters:
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	jr drawRectangleToVramTiles@nextRow

;;
; This function takes a data struct in hl which is expected to point to somewhere in
; w3VramTiles. This function is used to rewrite a rectangular area in that buffer.
;
; @param	hl	Pointer to data struct:
; 			b0-b1: Where to write the data (should point to w3VramTiles)
; 			b2: # of columns to write before moving to next row
; 			b3: # of rows
; 			b4+: The data to write to the given address
drawRectangleToVramTiles:
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	call readParametersForRectangleDrawing

@nextRow:
	push bc
--
	ldi a,(hl)
	ld (de),a
	set 2,d
	ldi a,(hl)
	ld (de),a
	res 2,d
	inc de
	dec c
	jr nz,--
	pop bc
	ld a,$20
	sub c
	call addAToDe
	dec b
	jr nz,@nextRow

	pop af
	ld ($ff00+R_SVBK),a
	ret

;;
; @param	hl	Pointer to data struct:
; 			b0: # of columns
; 			b1: # of rows
; 			b2-b3: Where to write the data (should point somewhere in wram 3)
; 			b4-b5: Where to read data from (should point somewhere in wram 2)
copyRectangleFromTmpGfxBuffer:
	ld a,($ff00+R_SVBK)
	push af

	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld h,(hl)
	ld l,a

@nextRow:
	push bc
--
	ld a,:w2TmpGfxBuffer
	ld ($ff00+R_SVBK),a
	ldi a,(hl)
	ld b,a
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	ld a,b
	ld (de),a
	inc de
	dec c
	jr nz,--
	pop bc
	ld a,$20
	sub c
	call addAToDe
	ld a,$20
	sub c
	rst_addAToHl
	dec b
	jr nz,@nextRow

	pop af
	ld ($ff00+R_SVBK),a
	ret

;;
; @param	hl	Pointer to data struct:
;			b0-b1: Where to write the data (should point to wRoomLayout)
;			b2: # of columns
;			b3: # of rows
;			b4+: Data to write (even bytes go to wRoomLayout, odd bytes go to
;			wRoomCollisions)
copyRectangleToRoomLayoutAndCollisions:
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld d,a

;;
; @param	de	Where to write the data
; @param	hl	Pointer to data struct (same as above method except first 2 bytes)
copyRectangleToRoomLayoutAndCollisions_paramDe:
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a

@nextRow:
	push bc
--
	ldi a,(hl)
	ld (de),a
	dec d
	ldi a,(hl)
	ld (de),a
	inc d
	inc de
	dec c
	jr nz,--
	pop bc
	ld a,$10
	sub c
	call addAToDe
	dec b
	jr nz,@nextRow
	ret

;;
; This is called in shops to load "price" graphics and set bit 1 of "wInShop".
roomTileChangesAfterLoad04:
	ld hl,wInShop
	set 1,(hl)
	ld a,TREE_GFXH_03
	jp loadTreeGfx
