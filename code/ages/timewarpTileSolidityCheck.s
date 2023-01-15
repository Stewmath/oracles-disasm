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

	; RANDO: Also disallow regular water tiles, if you don't have flippers.
	ld a,TREASURE_FLIPPERS
	call checkTreasureObtained
	jr c,+
	ld hl,invalidTimewarpTileListNoFlippers
+
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

; The tiles listed here are invalid, unless their corresponding value is $01, in which
; case it will be permitted to warp onto them if Link has the mermaid suit.
invalidTimewarpTileList:
	.db $f3 $00 ; Hole
	.db $fe $00 ; Waterfall
	.db $ff $00 ; Waterfall
	.db $e4 $00
	.db $e5 $00
	.db $e6 $00
	.db $e7 $00
	.db $e8 $00
	.db $e9 $00 ; Whirlpool
	.db $fc $01 ; Deep water
	.db $00


; RANDO: Same as above but also disallows normal water tiles
invalidTimewarpTileListNoFlippers:
	.db $f3 $00
	.db $fe $00
	.db $ff $00
	.db $e4 $00
	.db $e5 $00
	.db $e6 $00
	.db $e7 $00
	.db $e8 $00
	.db $e9 $00
	.db $fc $01
	.db $fa $00
	.db $e0 $00
	.db $e1 $00
	.db $e2 $00
	.db $e3 $00
	.db $00
