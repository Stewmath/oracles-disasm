;;
; @param[out]	c	$00 if there is no solid object at that position, $01 if there is
; @addr{62c4}
checkSolidObjectAtWarpDestPos:
	ld a,:w2SolidObjectPositions	; $62c4
	ld ($ff00+R_SVBK),a	; $62c6
	ld a,(wWarpDestPos)		; $62c8
	ld hl,w2SolidObjectPositions		; $62cb
	call checkFlag		; $62ce
	ld c,$00		; $62d1
	jr z,+			; $62d3
	inc c			; $62d5
+
	xor a			; $62d6
	ld ($ff00+R_SVBK),a	; $62d7
	ret			; $62d9

;;
; @addr{62da}
clearSolidObjectPositions:
	ld a,:w2SolidObjectPositions	; $62da
	ld ($ff00+R_SVBK),a	; $62dc
	ld b,$10		; $62de
	ld hl,w2SolidObjectPositions	; $62e0
	call clearMemory		; $62e3
	ld ($ff00+R_SVBK),a	; $62e6
	ret			; $62e8

;;
; This is used to check whether Link can time-warp into a position successfully.
;
; @param[out]	c	$00 if the tile is OK to stand on, $01 otherwise.
; @addr{62e9}
checkLinkCanStandOnTile:
	ld a,(w1Link.yh)		; $62e9
	ld b,a			; $62ec
	ld a,(w1Link.xh)		; $62ed
	ld c,a			; $62f0
	callab bank5.checkPositionSurroundedByWalls		; $62f1
	rl b			; $62f9
	jr c,@invalidTile		; $62fb

	call objectGetTileAtPosition		; $62fd
	ld e,(hl)		; $6300
	ld hl,_invalidTimewarpTileList		; $6301
	call lookupKey		; $6304
	jr c,++			; $6307

@validTile:
	ld c,$00		; $6309
	ret			; $630b
++
	or a			; $630c
	ld a,TREASURE_MERMAID_SUIT		; $630d
	call nz,checkTreasureObtained		; $630f
	jr c,@validTile			; $6312

@invalidTile:
	ld c,$01		; $6314
	ret			; $6316

; The tiles listed here are invalid, unless their corresponding value is $01, in which
; case it will be permitted to warp onto them if Link has the mermaid suit.
_invalidTimewarpTileList:
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
