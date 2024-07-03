;;
; @param[out]	c	$00 if there is no solid object at that position, $01 if there is
checkSolidObjectAtWarpDestPos:
	ld a,:w2SolidObjectPositions
	ld ($ff00+R_SVBK),a
	ld a,(wWarpDestPos)
	ld hl,w2SolidObjectPositions
	call checkFlag
	ld c,$00
	jr z,+
	inc c
+
	xor a
	ld ($ff00+R_SVBK),a
	ret

;;
clearSolidObjectPositions:
	ld a,:w2SolidObjectPositions
	ld ($ff00+R_SVBK),a
	ld b,$10
	ld hl,w2SolidObjectPositions
	call clearMemory
	ld ($ff00+R_SVBK),a
	ret

;;
; This is used to check whether Link can time-warp into a position successfully.
;
; @param[out]	c	$00 if the tile is OK to stand on, $01 otherwise.
checkLinkCanStandOnTile:
	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	callab bank5.checkPositionSurroundedByWalls
	rl b
	jr c,@invalidTile

	call objectGetTileAtPosition
	ld e,(hl)
	ld hl,invalidTimewarpTileList
	call lookupKey
	jr c,++

@validTile:
	ld c,$00
	ret
++
	or a
	ld a,TREASURE_MERMAID_SUIT
	call nz,checkTreasureObtained
	jr c,@validTile

@invalidTile:
	ld c,$01
	ret

.include {"{GAME_DATA_DIR}/tile_properties/timewarpInvalidTiles.s"}
