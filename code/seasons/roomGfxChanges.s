; Some code here is the same as code/ages/roomGfxChanges.s, but almost all room-specific
; stuff is different, so the codebases are separated.

;;
; Get the gasha spot index for the gasha spot in the given room.
;
; NOTE: If there is no gasha spot in that room, the output of this function is unreliable.
;
; @param	a	Room
; @param[out]	c	Gasha spot index
; @param[out]	zflag	z if nothing is planted in the given room.
; @addr{7a54}
getIndexOfGashaSpotInRoom_body:
	ld c,$00		; $66cc
	ld hl,gashaSpotRooms		; $66ce
--
	cp (hl)			; $66d1
	jr z,+			; $66d2
	inc hl			; $66d4
	inc c			; $66d5
	jr --			; $66d6
+
	ld a,c			; $66d8
	ld hl,wGashaSpotsPlantedBitset		; $66d9
	jp checkFlag		; $66dc


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
; @addr{66ef}
applyRoomSpecificTileChangesAfterGfxLoad:
	ld a,(wActiveRoom)		; $66ef
	ld hl,@tileChangesGroupTable		; $66f2
	call findRoomSpecificData		; $66f5
	ret nc			; $66f8
	rst_jumpTable			; $66f9
	.dw _roomTileChangesAfterLoad00
	.dw _roomTileChangesAfterLoad01
	.dw  roomTileChangesAfterLoad02 ; Located in bank 0 / bank 9 for some reason
	.dw _roomTileChangesAfterLoad03
	.dw _roomTileChangesAfterLoad04
	.dw _roomTileChangesAfterLoad05
	.dw _roomTileChangesAfterLoad06
	.dw _roomTileChangesAfterLoad07
	.dw _roomTileChangesAfterLoad08
	.dw _roomTileChangesAfterLoad09
	.dw _roomTileChangesAfterLoad0a
	.dw _roomTileChangesAfterLoad0b
	.dw _roomTileChangesAfterLoad0c
	.dw _roomTileChangesAfterLoad0d
	.dw _roomTileChangesAfterLoad0e
	.dw _roomTileChangesAfterLoad0f

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
; @addr{6776}
_roomTileChangesAfterLoad09:
	ld a,TREE_GFXH_07		; $6776
_label_04_291:
	call loadTreeGfx		; $6778
	ld hl,@rect		; $677b
	jp drawRectangleToVramTiles		; $677e

@rect:
	.dw w3VramTiles+$88
	.db $03 $04
	.db $20 $02 $21 $02 $22 $02
	.db $23 $02 $24 $02 $25 $02
	.db $26 $02 $27 $02 $28 $03
	.db $29 $03 $2a $03 $2b $03

;;
; $0a: Load pegasus tree graphics (spool swamp)
; @addr{679d}
_roomTileChangesAfterLoad0a:
	ld a,TREE_GFXH_08		; $679d
	jr _label_04_291		; $679f

;;
; $0b: Load gale tree graphics (tarm ruins)
; @addr{67a1}
_roomTileChangesAfterLoad0b:
	ld hl,_loadGaleTreeGfx@rect		; $67a1
_loadGaleTreeGfx:
	call drawRectangleToVramTiles		; $67a4
	ld a,TREE_GFXH_09		; $67a7
	jp loadTreeGfx		; $67a9

@rect:
	.dw w3VramTiles+$48
	.db $03 $04
	.db $20 $02 $21 $02 $22 $02
	.db $23 $02 $24 $02 $25 $02
	.db $26 $02 $27 $02 $28 $04
	.db $29 $03 $2a $03 $2b $04

;;
; $0c: Load gale tree graphics (sunken city)
; @addr{67c8}
_roomTileChangesAfterLoad0c:
	ld hl,@rect		; $67c8
	jr _loadGaleTreeGfx		; $67cb

@rect:
	.dw w3VramTiles+$86
	.db $03 $04
	.db $20 $02 $21 $02 $22 $02
	.db $23 $02 $24 $02 $25 $02
	.db $26 $02 $27 $02 $28 $04
	.db $29 $03 $2a $03 $2b $04

;;
; $0d: Load mystery tree graphics (woods of winter)
; @addr{67e9}
_roomTileChangesAfterLoad0d:
	ld a,TREE_GFXH_0a		; $67e9
	call loadTreeGfx		; $67eb
	ld hl,@rect		; $67ee
	jp drawRectangleToVramTiles		; $67f1

@rect:
	.dw w3VramTiles+$88
	.db $03 $04
	.db $20 $02 $21 $02 $22 $02
	.db $23 $02 $24 $02 $25 $02
	.db $26 $02 $27 $02 $28 $02
	.db $29 $02 $2a $03 $2b $02

;;
; $00: Pirate ship bow (at beach)
; @addr{6810}
_roomTileChangesAfterLoad00:
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED		; $6810
	call checkGlobalFlag		; $6812
	ret z			; $6815

	; Load extra tileset graphics
	ld e,OBJGFXH_PIRATE_SHIP_TILES_1 - 1		; $6816
	call loadObjectGfxHeaderToSlot4		; $6818

	; Load new tilemaps
	ld a,GFXH_PIRATE_SHIP_BOW_TILEMAP		; $681b
	call loadGfxHeader		; $681d

	ld hl,@vramTiles		; $6820
	call copyRectangleFromTmpGfxBuffer		; $6823
	ld hl,@vramAttributes		; $6826
	call copyRectangleFromTmpGfxBuffer		; $6829
	ld hl,@roomLayout		; $682c
	jp copyRectangleToRoomLayoutAndCollisions		; $682f

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
; @addr{6874}
_roomTileChangesAfterLoad01:
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED		; $6874
	call checkGlobalFlag		; $6876
	ret z			; $6879

	; Load extra tileset graphics
	ld e,OBJGFXH_PIRATE_SHIP_TILES_1 - 1		; $687a
	call loadObjectGfxHeaderToSlot4		; $687c

	; Load new tilemaps
	ld a,GFXH_PIRATE_SHIP_BODY_TILEMAP		; $687f
	call loadGfxHeader		; $6881

	ld hl,@vramTiles		; $6884
	call copyRectangleFromTmpGfxBuffer		; $6887
	ld hl,@vramAttributes		; $688a
	call copyRectangleFromTmpGfxBuffer		; $688d
	ld hl,@roomLayout		; $6890
	jp copyRectangleToRoomLayoutAndCollisions		; $6893

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
; @addr{68ba}
_roomTileChangesAfterLoad03:
	call getThisRoomFlags		; $68ba
	and $40			; $68bd
	ret nz			; $68bf

	xor a			; $68c0
	ld (wRoomLayout+$14),a		; $68c1
	ld (wRoomLayout+$24),a		; $68c4

	ld a,($ff00+R_SVBK)	; $68c7
	ld c,a			; $68c9
	ldh a,(<hRomBank)	; $68ca
	ld b,a			; $68cc
	push bc			; $68cd

	ld de,_dinsTroupeVramAndCollisions		; $68ce

_loadDinsTroupeTileChanges:
	ld a,:w3VramTiles		; $68d1
	ld ($ff00+R_SVBK),a	; $68d3

@getAddress:
	ld a,(de)		; $68d5
	ld l,a			; $68d6
	inc de			; $68d7
	or a			; $68d8
	jr z,@doneReadingVramTiles	; $68d9
	ld a,(de)		; $68db
	ld h,a			; $68dc
	inc de			; $68dd

@getTilePair:
	ld a,(de)		; $68de
	ld b,a			; $68df
	inc de			; $68e0
	or a			; $68e1
	jr z,@getAddress	; $68e2

	ld a,(de)		; $68e4
	ld c,a			; $68e5
	inc de			; $68e6
	push hl			; $68e7
	ld (hl),b		; $68e8
	set 2,h			; $68e9
	ld (hl),c		; $68eb
	ld a,$20		; $68ec
	rst_addAToHl			; $68ee
	inc b			; $68ef
	ld (hl),c		; $68f0
	res 2,h			; $68f1
	ld (hl),b		; $68f3
	pop hl			; $68f4
	inc hl			; $68f5
	jr @getTilePair		; $68f6

@doneReadingVramTiles:
	ld l,e			; $68f8
	ld h,d			; $68f9
	ld d,>wRoomCollisions		; $68fa
@nextAddress:
	ldi a,(hl)		; $68fc
	or a			; $68fd
	jr z,@done	; $68fe
	ld e,a			; $6900
	ld a,$0f		; $6901
	bit 7,e			; $6903
	jr z,++			; $6905
	res 7,e			; $6907
	ld a,$05		; $6909
++
	ld (de),a		; $690b
	jr @nextAddress		; $690c

@done:
	pop bc			; $690e
	ld a,b			; $690f
	ldh (<hRomBank),a	; $6910
	ld ($2222),a		; $6912
	ld a,c			; $6915
	ld ($ff00+R_SVBK),a	; $6916
	ld a,TREE_GFXH_02		; $6918
	jp loadTreeGfx		; $691a

; Values are written in pairs, vertically. Example: at "w3VramTiles+$0e" the row below it,
; values $36 and $37 are written, both with attribute $24.
_dinsTroupeVramAndCollisions:
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
; @addr{6962}
_roomTileChangesAfterLoad0e:
	ld a,GLOBALFLAG_INTRO_DONE		; $6962
	call checkGlobalFlag		; $6964
	ret nz			; $6967

	ld a,($ff00+R_SVBK)	; $6968
	ld c,a			; $696a
	ldh a,(<hRomBank)	; $696b
	ld b,a			; $696d
	push bc			; $696e
	ld de,@vramTilesAndCollisions		; $696f
	jp _loadDinsTroupeTileChanges		; $6972

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
; @addr{6991}
_roomTileChangesAfterLoad05:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED		; $6991
	call checkGlobalFlag		; $6993
	ret z			; $6996
	ld e,$08		; $6997
	call loadObjectGfxHeaderToSlot4		; $6999
	ld hl,@rect		; $699c
	jp drawRectangleToVramTiles		; $699f

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
; @addr{69d6}
_roomTileChangesAfterLoad06:
	ld a,TREE_GFXH_01		; $69d6
	call loadTreeGfx		; $69d8
	ld hl,@rect		; $69db
	jp drawRectangleToVramTiles		; $69de

@rect:
	.dw w3VramTiles+$4b
	.db $03 $04
	.db $20 $00 $21 $00 $22 $00
	.db $23 $00 $24 $00 $25 $00
	.db $26 $00 $27 $00 $28 $00
	.db $29 $00 $2a $00 $2b $00

;;
; $07: Vasu's shop (draws ring sign)
; @addr{69fd}
_roomTileChangesAfterLoad07:
	ld a,$01		; $69fd
	call loadTreeGfx		; $69ff
	ld hl,_vasuSignRect		; $6a02
	call drawRectangleToVramTiles		; $6a05

	; Fall through (forbid digging up enemies on vasu screen)

;;
; $0f: Maku tree entrance & one screen south: forbid digging up enemies
; @addr{6a08}
_roomTileChangesAfterLoad0f:
	ld a,$01		; $6a08
	ld (wDiggingUpEnemiesForbidden),a		; $6a0a
	ret			; $6a0d


_vasuSignRect:
	.dw w3VramTiles+$ca
	.db $02 $02
	.db $2c $00 $2d $00
	.db $2e $00 $2f $00


;;
; $08: Gasha spot (draws the tree or the plant if something has been planted)
_roomTileChangesAfterLoad08:
	; Return if a gasha seed is not planted in this room.
	ld a,(wActiveRoom)		; $6a1a
	call getIndexOfGashaSpotInRoom_body		; $6a1d
	ret z			; $6a20
	; 'c' now contains the gasha spot index.

	ld a,TILEINDEX_SOFT_SOIL		; $6a21
	call findTileInRoom		; $6a23
	ret nz			; $6a26

	ld e,l			; $6a27
	ld d,>wRoomLayout		; $6a28

	; Check if at least 20 enemies have been killed
	ld a,c			; $6a2a
	ld hl,wGashaSpotKillCounters		; $6a2b
	rst_addAToHl			; $6a2e
	ld a,(hl)		; $6a2f
	cp 20			; $6a30
	jr c,+			; $6a32

	; If so, load the tree graphics
	ld a,e			; $6a34
	sub $10			; $6a35
	ld e,a			; $6a37
	ld hl,@treeLayout		; $6a38
	jr ++			; $6a3b
+
	ld hl,@sproutLayout		; $6a3d
++
	call copyRectangleToRoomLayoutAndCollisions_paramDe		; $6a40

	; Regenerate graphics after modifying wRoomLayout
	jp generateW3VramTilesAndAttributes		; $6a43

@sproutLayout:
	.db $01 $01
	.db TILEINDEX_SOFT_SOIL_PLANTED $00

@treeLayout:
	.db $02 $02
	.db $75 $0f $76 $0f
	.db $85 $0f $86 $0f

;;
; This function is used by "drawRectangleToVramTiles".
; @addr{7d35}
readParametersForRectangleDrawing:
	ldi a,(hl)		; $6a54
	ld e,a			; $6a55
	ldi a,(hl)		; $6a56
	ld d,a			; $6a57
	ldi a,(hl)		; $6a58
	ld b,a			; $6a59
	ldi a,(hl)		; $6a5a
	ld c,a			; $6a5b
	ret			; $6a5c

;;
; Unused in seasons?
;
; @param	b	# of columns to write before moving to next row
; @param	c	# of rows
; @param	de	Where to write the data (should point to w3VramTiles)
; @param	hl	The address of the data to write to the given address
; @addr{7d3e}
drawRectangleToVramTiles_withParameters:
	ld a,($ff00+R_SVBK)	; $6a5d
	push af			; $6a5f
	ld a,:w3VramTiles		; $6a60
	ld ($ff00+R_SVBK),a	; $6a62
	jr drawRectangleToVramTiles@nextRow		; $6a64

;;
; This function takes a data struct in hl which is expected to point to somewhere in
; w3VramTiles. This function is used to rewrite a rectangular area in that buffer.
;
; @param	hl	Pointer to data struct:
; 			b0-b1: Where to write the data (should point to w3VramTiles)
; 			b2: # of columns to write before moving to next row
; 			b3: # of rows
; 			b4+: The data to write to the given address
; @addr{7d47}
drawRectangleToVramTiles:
	ld a,($ff00+R_SVBK)	; $6a66
	push af			; $6a68
	ld a,:w3VramTiles		; $6a69
	ld ($ff00+R_SVBK),a	; $6a6b
	call readParametersForRectangleDrawing		; $6a6d

@nextRow:
	push bc			; $6a70
--
	ldi a,(hl)		; $6a71
	ld (de),a		; $6a72
	set 2,d			; $6a73
	ldi a,(hl)		; $6a75
	ld (de),a		; $6a76
	res 2,d			; $6a77
	inc de			; $6a79
	dec c			; $6a7a
	jr nz,--		; $6a7b
	pop bc			; $6a7d
	ld a,$20		; $6a7e
	sub c			; $6a80
	call addAToDe		; $6a81
	dec b			; $6a84
	jr nz,@nextRow	; $6a85

	pop af			; $6a87
	ld ($ff00+R_SVBK),a	; $6a88
	ret			; $6a8a

;;
; @param	hl	Pointer to data struct:
; 			b0: # of columns
; 			b1: # of rows
; 			b2-b3: Where to write the data (should point somewhere in wram 3)
; 			b4-b5: Where to read data from (should point somewhere in wram 2)
; @addr{7d6e}
copyRectangleFromTmpGfxBuffer:
	ld a,($ff00+R_SVBK)	; $6a8b
	push af			; $6a8d

	ldi a,(hl)		; $6a8e
	ld b,a			; $6a8f
	ldi a,(hl)		; $6a90
	ld c,a			; $6a91
	ldi a,(hl)		; $6a92
	ld e,a			; $6a93
	ldi a,(hl)		; $6a94
	ld d,a			; $6a95
	ldi a,(hl)		; $6a96
	ld h,(hl)		; $6a97
	ld l,a			; $6a98

@nextRow:
	push bc			; $6a99
--
	ld a,:w2TmpGfxBuffer		; $6a9a
	ld ($ff00+R_SVBK),a	; $6a9c
	ldi a,(hl)		; $6a9e
	ld b,a			; $6a9f
	ld a,:w3VramTiles		; $6aa0
	ld ($ff00+R_SVBK),a	; $6aa2
	ld a,b			; $6aa4
	ld (de),a		; $6aa5
	inc de			; $6aa6
	dec c			; $6aa7
	jr nz,--		; $6aa8
	pop bc			; $6aaa
	ld a,$20		; $6aab
	sub c			; $6aad
	call addAToDe		; $6aae
	ld a,$20		; $6ab1
	sub c			; $6ab3
	rst_addAToHl			; $6ab4
	dec b			; $6ab5
	jr nz,@nextRow	; $6ab6

	pop af			; $6ab8
	ld ($ff00+R_SVBK),a	; $6ab9
	ret			; $6abb

;;
; @param	hl	Pointer to data struct:
;			b0-b1: Where to write the data (should point to wRoomLayout)
;			b2: # of columns
;			b3: # of rows
;			b4+: Data to write (even bytes go to wRoomLayout, odd bytes go to
;			wRoomCollisions)
; @addr{7d9f}
copyRectangleToRoomLayoutAndCollisions:
	ldi a,(hl)		; $6abc
	ld e,a			; $6abd
	ldi a,(hl)		; $6abe
	ld d,a			; $6abf

;;
; @param	de	Where to write the data
; @param	hl	Pointer to data struct (same as above method except first 2 bytes)
; @addr{7da3}
copyRectangleToRoomLayoutAndCollisions_paramDe:
	ldi a,(hl)		; $6ac0
	ld b,a			; $6ac1
	ldi a,(hl)		; $6ac2
	ld c,a			; $6ac3

@nextRow:
	push bc			; $6ac4
--
	ldi a,(hl)		; $6ac5
	ld (de),a		; $6ac6
	dec d			; $6ac7
	ldi a,(hl)		; $6ac8
	ld (de),a		; $6ac9
	inc d			; $6aca
	inc de			; $6acb
	dec c			; $6acc
	jr nz,--		; $6acd
	pop bc			; $6acf
	ld a,$10		; $6ad0
	sub c			; $6ad2
	call addAToDe		; $6ad3
	dec b			; $6ad6
	jr nz,@nextRow	; $6ad7
	ret			; $6ad9

;;
; This is called in shops to load "price" graphics and set bit 1 of "wInShop".
_roomTileChangesAfterLoad04:
	ld hl,wInShop		; $6ada
	set 1,(hl)		; $6add
	ld a,TREE_GFXH_03		; $6adf
	jp loadTreeGfx		; $6ae1

