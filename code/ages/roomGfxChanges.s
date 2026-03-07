; Some code here is the same as code/seasons/roomGfxChanges.s, but almost all room-specific stuff is
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
	.db $05 $2c $30 $7b $90 $ad $cb $d7 ; Subids 0-7
	.db $01 $0a $28 $34 $55 $95 $d0 $ca ; Subids 8-f

;;
func_02_7a77:
	call checkDungeonUsesToggleBlocks
	ret z
	ld a,(wToggleBlocksState)
	or a
	ld a,UNCMP_GFXH_AGES_3d
	jr z,+
	ld a,UNCMP_GFXH_AGES_3f
+
	jp loadUncompressedGfxHeader

;;
; Called from "generateVramTilesWithRoomChanges" in bank 0.
;
; Generally, this function is similar to "applyRoomSpecificTileChanges", except it gets
; called after w3VramTiles has been generated. So, most of the special behaviour here
; involves either modifying w3VramTiles, or modifying wRoomLayout for behavioural changes
; only (not visual changes).
;
applyRoomSpecificTileChangesAfterGfxLoad:
	ld a,(wActiveRoom)
	ld hl,@tileChangesGroupTable
	call findRoomSpecificData
	ret nc
	rst_jumpTable
	.dw roomTileChangesAfterLoad00
	.dw roomTileChangesAfterLoad01
	.dw roomTileChangesAfterLoad02
	.dw roomTileChangesAfterLoad03
	.dw roomTileChangesAfterLoad04
	.dw roomTileChangesAfterLoad05
	.dw roomTileChangesAfterLoad06
	.dw roomTileChangesAfterLoad07
	.dw roomTileChangesAfterLoad08
	.dw roomTileChangesAfterLoad09
	.dw roomTileChangesAfterLoad0a

;;
; Unused stub
;
@stub:
	ret

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
roomTileChangesAfterLoad0a:
	ld hl,wRoomLayout+$79
--
	ld a,(hl)
	sub $80
	cp $0a
	jr nc,+
	ld (hl),TILEINDEX_PUDDLE
+
	dec l
	jr nz,--
	ret

;;
; Lynna city screens with the mermaid statue: when the game is finished, replace the
; mermaid statue tiles with the base for the Link statue. (The statue itself is an object,
; so it's not drawn here.)
;
roomTileChangesAfterLoad09:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ret z
	ld hl,@tiles
	jp drawRectangleToVramTiles

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
roomTileChangesAfterLoad06:
	call roomTileChangesAfterLoad0a
	call checkIsLinkedGame
	ret z

	; Check a flag in the room Veran is fought in
	ld a,(wGroup4RoomFlags+$fc)
	and $80
	ret z

	ld a,TILEINDEX_OVERWORLD_DOWNSTAIRCASE
	ld (wRoomLayout+$57),a
	ret

;;
; Crown Dungeon entrance screen: redraw the tiles for the entrance if it has not been
; opened yet.
;
roomTileChangesAfterLoad07:
	call getThisRoomFlags
	and $80
	ret nz
	ld hl,@rectToDraw
	jp drawRectangleToVramTiles

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
drawCrownDungeonOpeningTiles:
	ld a,c
	ld hl,@tileReplacementTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	jp drawRectangleToVramTiles

@tileReplacementTable:
	dbrel @tiles0
	dbrel @tiles1
	dbrel @tiles2

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
roomTileChangesAfterLoad00:
	call getThisRoomFlags
	and $80
	ret z

;;
drawCollapsedWingDungeon:
	; Load the tile data for the cave to 2:$d000
	ld a,GFXH_WING_DUNGEON_COLLAPSED
	call loadGfxHeader

	ld hl,@tileReplacement
	call copyRectangleFromTmpGfxBuffer

	ld hl,@layoutReplacement
	jp copyRectangleToRoomLayoutAndCollisions

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
roomTileChangesAfterLoad02:
	call getThisRoomFlags
	and $01
	ret z
	jr roomTileChangesAfterLoad01

;;
; Present tokay island screen with scent tree: draw the tree if room flags are set.
;
roomTileChangesAfterLoad03:
	call getThisRoomFlags
	and $80
	ret z

;;
; Each screen with a tree on it calls this to load the tree's graphics.
;
roomTileChangesAfterLoad01:
	ld a,(wActiveGroup)
	ld hl,treeGfxLocationsTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wActiveRoom)
	ld b,a
--
	ldi a,(hl)
	or a
	ret z
	cp b
	jr z,+
	inc hl
	inc hl
	inc hl
	jr --
+
	; Tree found
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld a,b
	ldh (<hFF93),a

	; Draw the tile mapping
	ld hl,treeTilesTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld bc,$0304
	call drawRectangleToVramTiles_withParameters

	; Load the graphics
	ldh a,(<hFF93)
	add TREE_GFXH_07
	jp loadTreeGfx

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
	jpab tilesets.generateW3VramTilesAndAttributes

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
roomTileChangesAfterLoad05:
	ld hl,wRoomLayout+$33
	ld a,$0a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ret

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
copyRectangleFromTmpGfxBuffer_paramBc:
	ld l,c
	ld h,b

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

;;
checkLoadPastSignAndChestGfx:
	ld a,(wDungeonIndex)
	cp $0f
	ret z

	ld a,(wTilesetFlags)
	bit TILESETFLAG_BIT_PAST,a
	ret z

	bit TILESETFLAG_BIT_OUTDOORS,a
	ret nz

	bit TILESETFLAG_BIT_SIDESCROLL,a
	ret nz

	and (TILESETFLAG_LARGE_INDOORS|TILESETFLAG_DUNGEON|TILESETFLAG_INDOORS)
	ret z

	ld a,UNCMP_GFXH_AGES_37
	jp loadUncompressedGfxHeader


rectangleData_02_7de1:
	.db $06 $06
	.dw w3VramTiles+8 w2TmpGfxBuffer
