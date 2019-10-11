; Some code here is the same as code/seasons/roomGfxChanges.s, but almost all
; room-specific stuff is different, so the codebases are separated.

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
	ld c,$00		; $7a54
	ld hl,gashaSpotRooms		; $7a56
--
	cp (hl)			; $7a59
	jr z,+			; $7a5a
	inc hl			; $7a5c
	inc c			; $7a5d
	jr --			; $7a5e
+
	ld a,c			; $7a60
	ld hl,wGashaSpotsPlantedBitset		; $7a61
	jp checkFlag		; $7a64


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
	.db $05 $2c $30 $7b $90 $ad $cb $d7 ; Subids 0-7
	.db $01 $0a $28 $34 $55 $95 $d0 $ca ; Subids 8-f

;;
; @addr{7a77}
func_02_7a77:
	call checkDungeonUsesToggleBlocks		; $7a77
	ret z			; $7a7a
	ld a,(wToggleBlocksState)		; $7a7b
	or a			; $7a7e
	ld a,UNCMP_GFXH_3d		; $7a7f
	jr z,+			; $7a81
	ld a,UNCMP_GFXH_3f		; $7a83
+
	jp loadUncompressedGfxHeader		; $7a85

;;
; Called from "generateVramTilesWithRoomChanges" in bank 0.
;
; Generally, this function is similar to "applyRoomSpecificTileChanges", except it gets
; called after w3VramTiles has been generated. So, most of the special behaviour here
; involves either modifying w3VramTiles, or modifying wRoomLayout for behavioural changes
; only (not visual changes).
;
; @addr{7a88}
applyRoomSpecificTileChangesAfterGfxLoad:
	ld a,(wActiveRoom)		; $7a88
	ld hl,@tileChangesGroupTable		; $7a8b
	call findRoomSpecificData		; $7a8e
	ret nc			; $7a91
	rst_jumpTable			; $7a92
	.dw _roomTileChangesAfterLoad00
	.dw _roomTileChangesAfterLoad01
	.dw _roomTileChangesAfterLoad02
	.dw _roomTileChangesAfterLoad03
	.dw _roomTileChangesAfterLoad04
	.dw _roomTileChangesAfterLoad05
	.dw _roomTileChangesAfterLoad06
	.dw _roomTileChangesAfterLoad07
	.dw _roomTileChangesAfterLoad08
	.dw _roomTileChangesAfterLoad09
	.dw _roomTileChangesAfterLoad0a

;;
; Unused stub
;
; @addr{7aa9}
@stub:
	ret			; $7aa9

; @addr{7aaa}
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
; $00: D2 present screen; redraws cave after collapsing
; $01: Used on all screens with warp trees; loads their graphics.
; $02: Unused (similar behaviour to $03)
; $03: Tokay scent tree (same as $01 except it checks whether the seedling was planted)
; $04: Used in shops (loads price graphics, sets wInShop to be nonzero)
; $05: King moblin boss room (allows Link to throw bombs up the ledge)
; $06: Maku tree present screen
; $07: D5 entrance (redraws the entrance if it has not been opened)
; $08: Gasha spot (draws the tree or the plant if something has been planted)
; $09: Mermaid statue screen in Lynna City (replaces it with the base for the Link statue)
; $0a: Maku tree past screen

@group0:
	.db $05 $08
	.db $2c $08
	.db $30 $08
	.db $7b $08
	.db $90 $08
	.db $ad $08
	.db $cb $08
	.db $d7 $08
	.db $13 $01
	.db $ac $03
	.db $c1 $01
	.db $83 $00
	.db $38 $06
	.db $0a $07
	.db $67 $09
	.db $00
@group1:
	.db $01 $08
	.db $0a $08
	.db $28 $08
	.db $34 $08
	.db $55 $08
	.db $95 $08
	.db $d0 $08
	.db $ca $08
	.db $08 $01
	.db $25 $01
	.db $2d $01
	.db $80 $01
	.db $c1 $01
	.db $67 $09
	.db $38 $0a
	.db $00
@group2:
	.db $5e $04
	.db $7e $04
	.db $af $05
	.db $00
@group3:
	.db $ed $04
	.db $fe $04
@group4:
@group5:
@group6:
@group7:
	.db $00


;;
; Maku tree past/present: replace all tiles with indices between $80 and $89 (inclusive)
; with tile $f9. (In other words, replace the bottom parts of the Maku tree with shallow
; water tiles.)
;
; Since this code is called after the graphics have been loaded into w3VramTiles, this has
; no visual effect. The only purpose is to make it so that when Link stands on these
; tiles, he gets the "pond" animation at his feet.
;
; @addr{7b04}
_roomTileChangesAfterLoad0a:
	ld hl,wRoomLayout+$79		; $7b04
--
	ld a,(hl)		; $7b07
	sub $80			; $7b08
	cp $0a			; $7b0a
	jr nc,+			; $7b0c
	ld (hl),TILEINDEX_PUDDLE		; $7b0e
+
	dec l			; $7b10
	jr nz,--		; $7b11
	ret			; $7b13

;;
; Lynna city screens with the mermaid statue: when the game is finished, replace the
; mermaid statue tiles with the base for the Link statue. (The statue itself is an object,
; so it's not drawn here.)
;
; @addr{7b14}
_roomTileChangesAfterLoad09:
	ld a,GLOBALFLAG_FINISHEDGAME		; $7b14
	call checkGlobalFlag		; $7b16
	ret z			; $7b19
	ld hl,@tiles		; $7b1a
	jp drawRectangleToVramTiles		; $7b1d

@tiles:
	.dw w3VramTiles+$c9
	.db $03 $02

	.db $e3 $0e $e2 $0e $53 $0d
	.db $53 $0d $63 $0d $63 $0d

;;
; Maku tree present: same behaviour as maku tree past, and also creates a staircase tile
; which leads to the final dungeon when Veran is defeated (and when it's a linked game).
;
; A portal gets put on top of the staircase, so you don't see it.
;
; @addr{7b30}
_roomTileChangesAfterLoad06:
	call _roomTileChangesAfterLoad0a		; $7b30
	call checkIsLinkedGame		; $7b33
	ret z			; $7b36

	; Check a flag in the room Veran is fought in
	ld a,(wGroup4Flags+$fc)		; $7b37
	and $80			; $7b3a
	ret z			; $7b3c

	ld a,TILEINDEX_OVERWORLD_DOWNSTAIRCASE		; $7b3d
	ld (wRoomLayout+$57),a		; $7b3f
	ret			; $7b42

;;
; Crown Dungeon entrance screen: redraw the tiles for the entrance if it has not been
; opened yet.
;
; @addr{7b43}
_roomTileChangesAfterLoad07:
	call getThisRoomFlags		; $7b43
	and $80			; $7b46
	ret nz			; $7b48
	ld hl,@rectToDraw		; $7b49
	jp drawRectangleToVramTiles		; $7b4c

@rectToDraw:
	.dw w3VramTiles+$0c
	.db $04 $06

	.db $26 $0c $27 $0c $26 $0c $27 $0c
	.db $26 $0c $27 $0c $26 $0c $27 $0c
	.db $26 $0c $27 $0c $26 $0c $27 $0c
	.db $26 $0c $5e $0c $4c $0c $4c $2c
	.db $5e $2c $27 $0c $26 $0c $3b $0c
	.db $5c $0c $5c $2c $3b $2c $27 $0c

;;
; This draws one of the 3 frames of Crown Dungeon's "opening" animation after putting in
; the keyhole.
;
; @param	c	Which frame of the animation (0-2)
; @addr{7b83}
drawCrownDungeonOpeningTiles:
	ld a,c			; $7b83
	ld hl,@tileReplacementTable		; $7b84
	rst_addAToHl			; $7b87
	ld a,(hl)		; $7b88
	rst_addAToHl			; $7b89
	jp drawRectangleToVramTiles		; $7b8a

@tileReplacementTable:
	.db @tiles0-CADDR
	.db @tiles1-CADDR
	.db @tiles2-CADDR

@tiles0:
	.dw w3VramTiles+$6c
	.db $01 $06

	.db $4d $0c
	.db $3b $0c
	.db $5c $0c
	.db $5c $2c
	.db $3b $2c
	.db $4d $2c

@tiles1:
	.dw w3VramTiles+$2c
	.db $03 $06

	.db $26 $0c $27 $0c $3f $0c
	.db $3f $2c $26 $0c $27 $0c
	.db $4d $0c $5e $0c $4c $0c
	.db $4c $2c $5e $2c $4d $2c
	.db $5d $0c $3b $0c $5c $0c
	.db $5c $2c $3b $2c $5d $2c

@tiles2:
	.dw w3VramTiles+$0c
	.db $04 $06

	.db $26 $0c $27 $0c $3f $0c $3f $2c
	.db $26 $0c $27 $0c $4d $0c $4e $0c
	.db $4f $0c $4f $2c $4e $2c $4d $2c
	.db $5d $0c $5e $0c $4c $0c $4c $2c
	.db $5e $2c $5d $2c $3a $0c $3b $0c
	.db $5c $0c $5c $2c $3b $2c $3a $2c

;;
; Dungeon 2 present screen: redraw the cave if it's collapsed.
;
; @addr{7bfc}
_roomTileChangesAfterLoad00:
	call getThisRoomFlags		; $7bfc
	and $80			; $7bff
	ret z			; $7c01

;;
; @addr{7c02}
drawCollapsedWingDungeon:
	; Load the tile data for the cave to 2:$d000
	ld a,GFXH_53		; $7c02
	call loadGfxHeader		; $7c04

	ld hl,@tileReplacement		; $7c07
	call copyRectangleFromTmpGfxBuffer		; $7c0a

	ld hl,@layoutReplacement		; $7c0d
	jp copyRectangleToRoomLayoutAndCollisions		; $7c10

@tileReplacement:
	.db $06 $06
	.dw w3VramTiles+$08
	.dw w2TmpGfxBuffer

@layoutReplacement:
	.dw wRoomLayout+$04
	.db $03 $03

	.db $3b $00 $3b $00 $3b $00
	.db $3b $00 $3b $00 $3b $00
	.db $00 $05 $00 $0f $00 $0a

;;
; This is unused in Ages.
;
; @addr{7c2f}
_roomTileChangesAfterLoad02:
	call getThisRoomFlags		; $7c2f
	and $01			; $7c32
	ret z			; $7c34
	jr _roomTileChangesAfterLoad01			; $7c35

;;
; Present tokay island screen with scent tree: draw the tree if room flags are set.
;
; @addr{7c37}
_roomTileChangesAfterLoad03:
	call getThisRoomFlags		; $7c37
	and $80			; $7c3a
	ret z			; $7c3c

;;
; Each screen with a tree on it calls this to load the tree's graphics.
;
; @addr{7c3d}
_roomTileChangesAfterLoad01:
	ld a,(wActiveGroup)		; $7c3d
	ld hl,treeGfxLocationsTable		; $7c40
	rst_addDoubleIndex			; $7c43
	ldi a,(hl)		; $7c44
	ld h,(hl)		; $7c45
	ld l,a			; $7c46
	ld a,(wActiveRoom)		; $7c47
	ld b,a			; $7c4a
--
	ldi a,(hl)		; $7c4b
	or a			; $7c4c
	ret z			; $7c4d
	cp b			; $7c4e
	jr z,+			; $7c4f
	inc hl			; $7c51
	inc hl			; $7c52
	inc hl			; $7c53
	jr --			; $7c54
+
	; Tree found
	ldi a,(hl)		; $7c56
	ld b,a			; $7c57
	ldi a,(hl)		; $7c58
	ld d,(hl)		; $7c59
	ld e,a			; $7c5a
	ld a,b			; $7c5b
	ldh (<hFF93),a	; $7c5c

	; Draw the tile mapping
	ld hl,treeTilesTable		; $7c5e
	rst_addDoubleIndex			; $7c61
	ldi a,(hl)		; $7c62
	ld h,(hl)		; $7c63
	ld l,a			; $7c64
	ld bc,$0304		; $7c65
	call drawRectangleToVramTiles_withParameters		; $7c68

	; Load the graphics
	ldh a,(<hFF93)	; $7c6b
	add TREE_GFXH_07			; $7c6d
	jp loadTreeGfx		; $7c6f

; @addr{7c72}
treeGfxLocationsTable:
	.dw @present
	.dw @past

; Data format:
; b0: Room index
; b1: Tree type
; w2: Start of tree gfx in w3VramTiles to overwrite

@present:
	dbbw $08 $01 w3VramTiles+$086
	dbbw $13 $02 w3VramTiles+$0c8
	dbbw $ac $00 w3VramTiles+$0c6
	dbbw $c1 $02 w3VramTiles+$08a
	.db $00
@past:
	dbbw $08 $01 w3VramTiles+$086
	dbbw $25 $00 w3VramTiles+$0ca
	dbbw $2d $03 w3VramTiles+$10c
	dbbw $80 $03 w3VramTiles+$088
	dbbw $c1 $02 w3VramTiles+$08a
	.db $00


; @addr{7c9c}
treeTilesTable:
	.dw @tree0
	.dw @tree1
	.dw @tree2
	.dw @tree3

@tree0: ; Scent tree
@tree1: ; Pegasus tree (mapping is the same as the scent tree)
	.db $20 $02 $21 $02 $22 $02 $23 $02
	.db $24 $02 $25 $02 $26 $02 $27 $02
	.db $28 $03 $29 $03 $2a $03 $2b $03

@tree2: ; Gale tree
	.db $20 $02 $21 $02 $22 $02 $23 $02
	.db $24 $02 $25 $02 $26 $02 $27 $02
	.db $28 $04 $29 $03 $2a $03 $2b $04

@tree3: ; Mystery tree
	.db $20 $02 $21 $02 $22 $02 $23 $02
	.db $24 $02 $25 $02 $26 $02 $27 $02
	.db $28 $02 $29 $02 $2a $03 $2b $03

;;
; Rooms with gasha spots call this to replace the "soft soil" with tree graphics if
; necessary.
;
; @addr{7cec}
_roomTileChangesAfterLoad08:
	; Return if a gasha seed is not planted in this room.
	ld a,(wActiveRoom)		; $7cec
	call getIndexOfGashaSpotInRoom_body		; $7cef
	ret z			; $7cf2
	; 'c' now contains the gasha spot index.

	ld a,TILEINDEX_SOFT_SOIL		; $7cf3
	call findTileInRoom		; $7cf5
	ret nz			; $7cf8

	ld e,l			; $7cf9
	ld d,>wRoomLayout		; $7cfa

	; Check if at least 20 enemies have been killed
	ld a,c			; $7cfc
	ld hl,wGashaSpotKillCounters		; $7cfd
	rst_addAToHl			; $7d00
	ld a,(hl)		; $7d01
	cp 20			; $7d02
	jr c,+			; $7d04

	; If so, load the tree graphics
	ld a,e			; $7d06
	sub $10			; $7d07
	ld e,a			; $7d09
	ld hl,@treeLayout		; $7d0a
	jr ++			; $7d0d
+
	ld hl,@sproutLayout		; $7d0f
++
	call copyRectangleToRoomLayoutAndCollisions_paramDe		; $7d12

	; Regenerate graphics after modifying wRoomLayout
	jpab generateW3VramTilesAndAttributes		; $7d15

@sproutLayout:
	.db $01 $01
	.db TILEINDEX_SOFT_SOIL_PLANTED $00

@treeLayout:
	.db $02 $02
	.db $4e $0f $4f $0f
	.db $5e $0f $5f $0f

;;
; This is called for the King Moblin boss fight. It replaces the ledge separating you from
; King Moblin with... switch tiles?
;
; Of course, this is after w3VramTiles has been generated, so there is no visual change.
; It seems that this is done to allow Link to throw bombs up the ledge.
;
; @addr{7d2b}
_roomTileChangesAfterLoad05:
	ld hl,wRoomLayout+$33		; $7d2b
	ld a,$0a		; $7d2e
	ldi (hl),a		; $7d30
	ldi (hl),a		; $7d31
	ldi (hl),a		; $7d32
	ldi (hl),a		; $7d33
	ret			; $7d34

;;
; This function is used by "drawRectangleToVramTiles".
; @addr{7d35}
readParametersForRectangleDrawing:
	ldi a,(hl)		; $7d35
	ld e,a			; $7d36
	ldi a,(hl)		; $7d37
	ld d,a			; $7d38
	ldi a,(hl)		; $7d39
	ld b,a			; $7d3a
	ldi a,(hl)		; $7d3b
	ld c,a			; $7d3c
	ret			; $7d3d

;;
; @param	b	# of columns to write before moving to next row
; @param	c	# of rows
; @param	de	Where to write the data (should point to w3VramTiles)
; @param	hl	The address of the data to write to the given address
; @addr{7d3e}
drawRectangleToVramTiles_withParameters:
	ld a,($ff00+R_SVBK)	; $7d3e
	push af			; $7d40
	ld a,:w3VramTiles		; $7d41
	ld ($ff00+R_SVBK),a	; $7d43
	jr drawRectangleToVramTiles@nextRow		; $7d45

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
	ld a,($ff00+R_SVBK)	; $7d47
	push af			; $7d49
	ld a,:w3VramTiles		; $7d4a
	ld ($ff00+R_SVBK),a	; $7d4c
	call readParametersForRectangleDrawing		; $7d4e

@nextRow:
	push bc			; $7d51
--
	ldi a,(hl)		; $7d52
	ld (de),a		; $7d53
	set 2,d			; $7d54
	ldi a,(hl)		; $7d56
	ld (de),a		; $7d57
	res 2,d			; $7d58
	inc de			; $7d5a
	dec c			; $7d5b
	jr nz,--		; $7d5c

	pop bc			; $7d5e
	ld a,$20		; $7d5f
	sub c			; $7d61
	call addAToDe		; $7d62
	dec b			; $7d65
	jr nz,@nextRow		; $7d66

	pop af			; $7d68
	ld ($ff00+R_SVBK),a	; $7d69
	ret			; $7d6b

;;
; @addr{7d6c}
copyRectangleFromTmpGfxBuffer_paramBc:
	ld l,c			; $7d6c
	ld h,b			; $7d6d

;;
; @param	hl	Pointer to data struct:
; 			b0: # of columns
; 			b1: # of rows
; 			b2-b3: Where to write the data (should point somewhere in wram 3)
; 			b4-b5: Where to read data from (should point somewhere in wram 2)
; @addr{7d6e}
copyRectangleFromTmpGfxBuffer:
	ld a,($ff00+R_SVBK)	; $7d6e
	push af			; $7d70

	ldi a,(hl)		; $7d71
	ld b,a			; $7d72
	ldi a,(hl)		; $7d73
	ld c,a			; $7d74
	ldi a,(hl)		; $7d75
	ld e,a			; $7d76
	ldi a,(hl)		; $7d77
	ld d,a			; $7d78
	ldi a,(hl)		; $7d79
	ld h,(hl)		; $7d7a
	ld l,a			; $7d7b

@nextRow:
	push bc			; $7d7c
--
	ld a,:w2TmpGfxBuffer		; $7d7d
	ld ($ff00+R_SVBK),a	; $7d7f
	ldi a,(hl)		; $7d81
	ld b,a			; $7d82
	ld a,:w3VramTiles		; $7d83
	ld ($ff00+R_SVBK),a	; $7d85
	ld a,b			; $7d87
	ld (de),a		; $7d88
	inc de			; $7d89
	dec c			; $7d8a
	jr nz,--		; $7d8b
	pop bc			; $7d8d
	ld a,$20		; $7d8e
	sub c			; $7d90
	call addAToDe		; $7d91
	ld a,$20		; $7d94
	sub c			; $7d96
	rst_addAToHl			; $7d97
	dec b			; $7d98
	jr nz,@nextRow		; $7d99

	pop af			; $7d9b
	ld ($ff00+R_SVBK),a	; $7d9c
	ret			; $7d9e

;;
; @param	hl	Pointer to data struct:
;			b0-b1: Where to write the data (should point to wRoomLayout)
;			b2: # of columns
;			b3: # of rows
;			b4+: Data to write (even bytes go to wRoomLayout, odd bytes go to
;			wRoomCollisions)
; @addr{7d9f}
copyRectangleToRoomLayoutAndCollisions:
	ldi a,(hl)		; $7d9f
	ld e,a			; $7da0
	ldi a,(hl)		; $7da1
	ld d,a			; $7da2

;;
; @param	de	Where to write the data
; @param	hl	Pointer to data struct (same as above method except first 2 bytes)
; @addr{7da3}
copyRectangleToRoomLayoutAndCollisions_paramDe:
	ldi a,(hl)		; $7da3
	ld b,a			; $7da4
	ldi a,(hl)		; $7da5
	ld c,a			; $7da6

@nextRow:
	push bc			; $7da7
--
	ldi a,(hl)		; $7da8
	ld (de),a		; $7da9
	dec d			; $7daa
	ldi a,(hl)		; $7dab
	ld (de),a		; $7dac
	inc d			; $7dad
	inc de			; $7dae
	dec c			; $7daf
	jr nz,--		; $7db0
	pop bc			; $7db2
	ld a,$10		; $7db3
	sub c			; $7db5
	call addAToDe		; $7db6
	dec b			; $7db9
	jr nz,@nextRow		; $7dba
	ret			; $7dbc

;;
; This is called in shops to load "price" graphics and set bit 1 of "wInShop".
; @addr{7dbd}
_roomTileChangesAfterLoad04:
	ld hl,wInShop		; $7dbd
	set 1,(hl)		; $7dc0
	ld a,TREE_GFXH_03		; $7dc2
	jp loadTreeGfx		; $7dc4

;;
; @addr{7dc7}
checkLoadPastSignAndChestGfx:
	ld a,(wDungeonIndex)		; $7dc7
	cp $0f			; $7dca
	ret z			; $7dcc

	ld a,(wAreaFlags)		; $7dcd
	bit AREAFLAG_BIT_PAST,a			; $7dd0
	ret z			; $7dd2

	bit AREAFLAG_BIT_OUTDOORS,a			; $7dd3
	ret nz			; $7dd5

	bit AREAFLAG_BIT_SIDESCROLL,a			; $7dd6
	ret nz			; $7dd8

	and (AREAFLAG_10|AREAFLAG_DUNGEON|AREAFLAG_INDOORS)
	ret z			; $7ddb

	ld a,UNCMP_GFXH_37		; $7ddc
	jp loadUncompressedGfxHeader		; $7dde


rectangleData_02_7de1:
	.db $06 $06
	.dw w3VramTiles+8 w2TmpGfxBuffer
