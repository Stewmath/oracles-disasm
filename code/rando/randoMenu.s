.SECTION Rando_Menu NAMESPACE randoMenu SUPERFREE

; ================================================================================
; Rando menu (MENU_RANDO), opened by pressing select twice
; ================================================================================

.ifdef ROM_AGES
	; Destination for "warp to start" option
	.define HOME_WARP_ROOM $08a
	.define HOME_WARP_POS  $34
.else
	.define HOME_WARP_ROOM $0a7
	.define HOME_WARP_POS  $54
.endif

runRandoMenu:
	xor a
	ldh (<R_SVBK),a
	call @runState
	jp randoMenu_drawSprites

@runState:
	ld a,(wSaveQuitMenu.state)
	rst_jumpTable
	.dw randoMenu_state0
	.dw randoMenu_state1
	.dw randoMenu_state2


; State 0: initialization (loading graphics, setting music, etc)
randoMenu_state0:
	call disableLcd
	call stopTextThread

	ld a,GFXH_a0
	call loadGfxHeader
	ld a,GFXH_a6
	call loadGfxHeader
	ld a,GFXH_a8
	call loadGfxHeader

	ld hl,@optionText
	ld de,$8800
	ld b,$00
	call loadTextGfx

	ld a,:w4TileMap
	ldh (R_SVBK),a

	; Clear out the part of the tilemap showing the normal save&quit menu options
	ld hl,w4TileMap + $e4
	ldbc 8,12
	ld a,$02
	ld e,$0a ; Bank 1, palette 2
	call @fillTilemapRect

	; Draw text for the options
	ld hl,w4TileMap + $0e4
	ld a,$80
	ld b,13
	ld c,$06
	call @drawOptionText
	ld hl,w4TileMap + $144
	ld a,$9a
	ld b,13
	ld c,$06
	call @drawOptionText

	ld a,2
	call setMusicVolume
	ld a,PALH_05
	call loadPaletteHeader

	; Copy w4TileMap to vram
	ld a,UNCMP_GFXH_08
	call loadUncompressedGfxHeader

	call fastFadeinFromWhite

	ld a,$01
	ld (wSaveQuitMenu.state),a

	ld a,$05
	jp loadGfxRegisterStateIndex

@optionText:
	.db "Dungeon Items"
	.db "Warp To Start"
	.db 0


;;
; Draws the tilemap for one of the options.
;
; @param	a	Tile index for first character
; @param	b	Number of characters
; @param	c	Attributes
; @param	hl	Address in w4TileMap
@drawOptionText:
	ld d,h
	ld e,l
	push af
	ld a,32
	rst_addAToHl
	pop af

	push bc
	push de
	push hl

	; Tiles
@loop:
	ld (de),a
	inc de
	inc a
	ldi (hl),a
	inc a
	dec b
	jr nz,@loop

	; Attributes
	pop hl
	pop de
	pop bc
	set 2,h
	set 2,d
	ld a,c
@loop2:
	ld (de),a
	inc de
	ldi (hl),a
	dec b
	jr nz,@loop2
	ret

;;
; Fills a rectangle in w4TileMap.
;
; @param	a	Tile value
; @param	e	Attribute value
; @param	bc	Rows/Columns
; @param	hl	Address in w4TileMap
@fillTilemapRect:
	push af
	ld a,32
	sub c
	ldh (<hFF8B),a
	pop af
	set 2,h

@nextRow:
	ld d,c
---
	ld (hl),e
	res 2,h
	ldi (hl),a
	set 2,h
	dec d
	jr nz,---
	ld d,a
	ldh a,(<hFF8B)
	rst_addAToHl
	ld a,d
	dec b
	jr nz,@nextRow
	ret


; Waiting for input
randoMenu_state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wKeysJustPressed)
	ld c,$ff
	bit BTN_BIT_UP,a
	jr nz,@upOrDown
	ld c,$01
	bit BTN_BIT_DOWN,a
	jr nz,@upOrDown

	bit BTN_BIT_B,a
	jr nz,@bPressed

	and (BTN_START|BTN_A)
	ret z

	; A pressed
	ld a,(wSaveQuitMenu.cursorIndex)
	or a
	call nz,saveFile ; Save for options 2 and 3

	ld a,$02
	ld (wSaveQuitMenu.state),a
	ld a,$1e
	ld (wSaveQuitMenu.delayCounter),a

	ld a,SND_SELECTITEM
	jp playSound

@upOrDown:
	ld hl,wSaveQuitMenu.cursorIndex
	ld a,(hl)
	add c
	cp $02
	ret nc
	ld (hl),a
	ld a,SND_MENU_MOVE
	jp playSound

@bPressed:
	jpab bank2.closeMenu


; Selected an option
randoMenu_state2:
	ld a,(wSaveQuitMenu.cursorIndex)
	or a
	jr z,@toDungeonMenu

	; Selected "warp home" option
	ld a,$80 | (HOME_WARP_ROOM >> 8)
	ld (wWarpDestGroup),a
	ld a,HOME_WARP_ROOM & $ff
	ld (wWarpDestRoom),a
	ld a,HOME_WARP_POS
	ld (wWarpDestPos),a
	ld a,TRANSITION_DEST_FALL
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a

	ld a,$03
	call setMusicVolume
	call fadeoutToWhite

	; Static dungeon objects normally don't get cleared by this warp type, so do it here
	call clearStaticObjects

	; Don't allow bringing companions or rafts while warping.
	; This is a pretty hackish solution. You can see link "detach" from the animal companion for
	; 1 frame if you're moving as the warp begins.
	ld a,>w1Link
	ld (wLinkObjectIndex),a

	jpab bank2.closeMenu

@toDungeonMenu:
	ld a,MENU_RANDO_DUNGEONS
	ld (wOpenedMenuType),a
	ld hl,wMenuUnionStart
	ld b,wMenuUnionEnd - wMenuUnionStart
	jp clearMemory


randoMenu_drawSprites:
	callab bank2.fileSelect_redrawDecorationsAndSetWramBank4

	; Flicker acorn if applicable
	ld a,(wSaveQuitMenu.delayCounter)
	and $04
	ret nz

	ld c,a ; c = 0
	ld a,(wSaveQuitMenu.cursorIndex)
	ld b,a
	add a
	add b
	swap a
	rrca
	ld b,a
	ld hl,@acornSprite
	jp addSpritesToOam_withOffset

@acornSprite:
	.db $01
	.db $4a $20 $28 $04



; ================================================================================
; Dungeon item menu (MENU_RANDO_DUNGEON)
; ================================================================================

; Constants for MENU_RANDO_DUNGEON
.define NUM_PAGES 3
.define PAGE_DATA_SIZE 4
.define PAGE_SCROLL_SPEED 8


runRandoDungeonsMenu:
	xor a
	ldh (<R_SVBK),a
	call @runState
	jp randoDungeonsMenu_drawSprites

@runState:
	ld a,(wRandoMenu.state)
	rst_jumpTable
	.dw randoDungeonsMenu_state0
	.dw randoDungeonsMenu_state1
	.dw randoDungeonsMenu_state2

randoDungeonsMenu_state0:
	call disableLcd

	ld a,GFXH_RANDO_DUNGEON_MENU
	call loadGfxHeader

.ifdef ROM_AGES
	; Load the "pres/past" text tiles for d6. Text gfx can't be loaded easily with "gfx
	; header" data unless a totally new graphic is created for it, so this is loaded manually.
	ld hl,@presPastText
	ld de,$9701
	ld b,$ff
	call loadTextGfx
.endif

	ld a,2
	call setMusicVolume
	ld a,PALH_09 ; Same as dungeon map screen
	call loadPaletteHeader

	xor a
	ld (wRandoMenu.pageIndex),a
	call randoDungeonsMenu_loadPageTileMap

	; Load w4TileMap, w4AttributeMap to VRAM (9c00)
	ld a,UNCMP_GFXH_08
	call loadUncompressedGfxHeader

	call fastFadeinFromWhite

	ld a,$01
	ld (wRandoMenu.state),a

	ld a,$05
	call loadGfxRegisterStateIndex

	; Enable window, set window tilemap to 9800
	ld a,%10101111
	ld (wGfxRegs1.LCDC),a
	ld a,$07
	ld (wGfxRegs1.WINX),a
	ret

@presPastText:
	.asc "PresPast", 0


;;
; @param	b	XOR to apply to the text gfx
; @param	de	VRAM address to write to (using DMA)
; @param	hl	Text (null-terminated)
loadTextGfx:
	push de
	ld a,b
	ldh (<hFF8B),a
	xor a
	ld (wFileSelect.fontXor),a

	ld a,:w7d800
	ldh (R_SVBK),a

	ld de,w7d800
	ld bc,$0000
@loop:
	ldi a,(hl)
	or a
	jr z,@doneLoop
	inc b
	call copyTextCharacterGfx
	jr @loop

@doneLoop:
	; Need to xor the tile data so that it plays nice with our palettes
	ld a,b ; # of characters copied
	push af
	ld c,32 ; 1 8x16 tile = 32 bytes
	call multiplyAByC
	ld b,h
	ld c,l
	ld hl,w7d800 ; dest
	ldh a,(<hFF8B)
	ld d,a ; xor
	call @xorMemory

	; Queue the tile data with DMA
	pop af ; # characters
	add a
	dec a
	ld b,a
	pop de
	ld c,:w7d800
	ld hl,w7d800
	jp queueDmaTransfer

@xorMemory:
	ld a,(hl)
	xor d
	ldi (hl),a
	dec bc
	ld a,b
	or c
	jr nz,@xorMemory
	ret


; Waiting for input
randoDungeonsMenu_state1:
	ld a,(wKeysJustPressed)
	ld b,a
	and BTN_B | BTN_START
	jr z,+
	jpab bank2.closeMenu
+
	bit BTN_BIT_UP,b
	jr nz,@upPressed
	ld a,b
	and BTN_DOWN | BTN_SELECT
	jr nz,@downPressed
	ret

@upPressed:
	; Swap window & bg layer tilemaps
	ld a,%11100111
	ld (wGfxRegs1.LCDC),a

	xor a
	ld (wGfxRegs1.WINY),a
	ld a,144
	ld (wGfxRegs1.SCY),a

	ld a,-PAGE_SCROLL_SPEED
	ld (wRandoMenu.scrollSpeed),a

	ld a,(wRandoMenu.pageIndex)
	ld b,a
	or a
	ld a,NUM_PAGES-1
	jr z,+
	ld a,b
	dec a
+
	jr @beginScroll

@downPressed:
	ld a,144
	ld (wGfxRegs1.WINY),a

	ld a,PAGE_SCROLL_SPEED
	ld (wRandoMenu.scrollSpeed),a

	ld a,(wRandoMenu.pageIndex)
	inc a
	cp NUM_PAGES
	jr nz,+
	xor a
+

@beginScroll:
	ld (wRandoMenu.nextPageIndex),a

	; Load page layout to VRAM (9800) for window layer
	call randoDungeonsMenu_loadPageTileMap
	ld a,UNCMP_GFXH_12
	call loadUncompressedGfxHeader

	xor a
	ld (wRandoMenu.scrollOffset),a

	ld hl,wRandoMenu.state
	inc (hl)

	ld a,SND_OPENMENU
	jp playSound


; Scrolling between pages
randoDungeonsMenu_state2:
	ld a,(wRandoMenu.scrollSpeed)
	ld e,a

	ld hl,wRandoMenu.scrollOffset
	ld a,e
	add (hl)
	ld (hl),a
	ld hl,wGfxRegs1.SCY
	ld a,e
	add (hl)
	ld (hl),a
	ld hl,wGfxRegs1.WINY
	ld a,(hl)
	sub e
	ld (hl),a
	cp 144
	ret c

	; Done scrolling
	ld a,(wRandoMenu.nextPageIndex)
	ld (wRandoMenu.pageIndex),a

	; Load page layout to VRAM (9c00) for bg layer
	call randoDungeonsMenu_loadPageTileMap
	ld a,UNCMP_GFXH_08
	call loadUncompressedGfxHeader

	; Hide window layer
	ld a,$c7
	ld (wGfxRegs1.WINY),a

	; Reset window & BG layer tilemaps
	ld a,%10101111
	ld (wGfxRegs1.LCDC),a

	; Reset scroll
	xor a
	ld (wGfxRegs1.SCY),a
	ld (wRandoMenu.scrollOffset),a

	inc a ; a = 1
	ld (wRandoMenu.state),a
	ret


;;
; Draw keys, maps, compasses for all displayed dungeons
randoDungeonsMenu_drawSprites:
	call clearOam
	ld a,(wRandoMenu.pageIndex)
	ld bc,$0000
	call @drawPageSprites

	; If scrolling, draw next page's sprites
	ld a,(wRandoMenu.state)
	cp 2
	ret nz

	; Determine vertical offset for next page
	ld a,(wRandoMenu.scrollSpeed)
	and $80
	ld bc,144
	jr z,+
	ld bc,-144
+
	ld a,(wRandoMenu.nextPageIndex)

@drawPageSprites:
	ld hl,randoDungeonsMenu_pageList
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

@loop:
	ld a,(hl)
	cp $ff
	ret z

	ldh (<hFF8C),a
	push hl
	push bc
	call @drawDungeonSprites
	pop bc
	pop hl
	ld a,PAGE_DATA_SIZE
	rst_addAToHl
	jr @loop

; @param	bc	Vertical offset
; @param	hFF8C	Dungeon index
@drawDungeonSprites:
	ldh a,(<hFF8C)
	ld hl,@dungeonSpriteOffsets
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

	; Using 16-bit arithmetic to calculate y-offset so that we can prevent sprites from looping
	ld a,(hl)
	call addAToBc
	ld a,(wRandoMenu.scrollSpeed)
	and $80
	jr nz,+
	; There's no "subAFromBc" function so...
	ld a,(wRandoMenu.scrollOffset)
	ld d,a
	ld a,c
	sub d
	ld c,a
	ld a,b
	sbc 0
	ld b,a
	jr ++
+
	ld a,(wRandoMenu.scrollOffset)
	cpl
	inc a
	call addAToBc
++
	; Don't draw the sprite if it would have looped around
	ld a,b
	or a
	ret nz
	ld a,c
	cp 200
	ret nc

	ld b,c ; final y-position
	inc hl
	ld c,(hl) ; x-position

	; Map
	ldh a,(<hFF8C)
	ld hl,wDungeonMaps
	call checkFlag
	jr z,@doneMap
	ld hl,@mapOamData
	call addSpritesToOam_withOffset
@doneMap:
	; Compass
	ldh a,(<hFF8C)
	ld hl,wDungeonCompasses
	call checkFlag
	jr z,@doneCompass
	ld hl,@compassOamData
	call addSpritesToOam_withOffset
@doneCompass:
	; Boss Key
	ldh a,(<hFF8C)
	ld hl,wDungeonBossKeys
	call checkFlag
	jr z,@doneBossKey
	ld hl,@bossKeyOamData
	call addSpritesToOam_withOffset
@doneBossKey:
	; Small Key
	ldh a,(<hFF8C)
	ld hl,wDungeonSmallKeys
	rst_addAToHl
	ld a,(hl)
	or a
	jr z,@doneSmallKey
	ld hl,@smallKeyOamData
	call addSpritesToOam_withOffset
@doneSmallKey:
	ret


@mapOamData:
	.db $02
	.db $f0 $08 $00 $03
	.db $f0 $10 $02 $03

@compassOamData:
	.db $02
	.db $f0 $18 $04 $01
	.db $f0 $20 $06 $01

@bossKeyOamData:
	.db $02
	.db $00 $08 $08 $05
	.db $00 $10 $0a $05

@smallKeyOamData:
	.db $01
	.db $00 $18 $0c $05

@dungeonSpriteOffsets:
	.db @top    - CADDR ; hero's cave (seasons)
	.db @middle - CADDR ; d1
	.db @bottom - CADDR ; d2
	.db @top    - CADDR ; d3
	.db @middle - CADDR ; d4
	.db @bottom - CADDR ; d5
	.db @top    - CADDR ; d6 (present in ages)
	.db @middle - CADDR ; d7
	.db @bottom - CADDR ; d8
.ifdef ROM_AGES
	.db $00
	.db $00
	.db $00
	.db @topRight - CADDR ; d6 past
	.db @top      - CADDR ; maku path (past)
.endif

@top:
	.db $30 $48

@middle:
	.db $58 $48

@bottom:
	.db $80 $48

.ifdef ROM_AGES
@topRight:
	.db $30 $70
.endif

;;
; Load the tilemap for the dungeon blurbs for a page of the rando dungeon menu. Writes to w4TileMap.
; Must be copied to VRAM later (either to the tilemap at 9800 or at 9c00).
;
; @param	a	Page index
randoDungeonsMenu_loadPageTileMap:
	push af

	ld a,:w4TileMap
	ldh (R_SVBK),a

	ld a,$91
	ld bc,$240
	ld hl,w4TileMap
	call fillMemoryBc

	ld a,$03
	ld bc,$240
	ld hl,w4AttributeMap
	call fillMemoryBc

	; Left column
	ld a,$75
	ld hl,w4TileMap
	call @fillColumn
	ld a,$24 ; X-flip, palette 4
	ld hl,w4AttributeMap
	call @fillColumn

	; Right column
	ld a,$75
	ld hl,w4TileMap + 19
	call @fillColumn
	ld a,$04 ; palette 4
	ld hl,w4AttributeMap + 19
	call @fillColumn

.ifdef ROM_AGES
	; D6 special case: Load tilemap for "past/present" tiles
	pop af
	push af
	cp 2
	jr nz,@notD6Page
	ld de,@presentPastTileMap1
	ld hl,w4TileMap + $09
	call @loadPresentPastTilemap
	ld de,@presentPastTileMap2
	ld hl,w4TileMap + $29
	call @loadPresentPastTilemap

@notD6Page:
.endif

	pop af ; a = page index
	ld hl,randoDungeonsMenu_pageList
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

@loop:
	ld a,(hl)
	cp $ff
	ret z
	push hl
	inc hl
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,b
	and $fe

	bit 0,b ; Bank 0 or 1
	ld e,$03
	jr z,+
	ld e,$0b
+
	call randoDungeonsMenu_drawBlurbAt
	pop hl
	push hl
	call @drawKeyCount
	pop hl
	ld a,PAGE_DATA_SIZE
	rst_addAToHl
	jr @loop

@drawKeyCount:
	ldi a,(hl) ; dungeon index
	ld b,a
	ld de,wDungeonSmallKeys
	call addAToDe
	ld a,(de)
	or a
	ret z
	add $60 ; Number "0" tile index
	ld d,a

	inc hl
	ldi a,(hl)
	ld h,(hl) ; tilemap location for dungeon name blurb
	ld l,a

.ifdef ROM_AGES
	; Special case for d6 past
	ld a,b ; dungeon index
	cp $0c
	jr nz,++
	ld a,$91
	jr @gotKeyCountOffset
++
.endif
	ld a,$8c ; Position of small key count tile (relative to top-left blurb tile)

@gotKeyCountOffset:
	rst_addAToHl
	ld (hl),d
	dec hl
	ld (hl),$6a ; "x"
	ret

; @param	a	Value
; @param	hl	Column start
@fillColumn:
	ld d,a
	ld e,32
	ld b,18
---
	ld (hl),d
	ld a,e
	rst_addAToHl
	dec b
	jr nz,---
	ret


.ifdef ROM_AGES

; @param	de	Tilemap data
; @param	hl	Where to write it to
@loadPresentPastTilemap:
	ld a,(de)
	or a
	ret z
	ld (hl),a
	set 2,h
	ld (hl),$0b ; Attributes (bank 1, palette 3)
	res 2,h
	inc hl
	inc de
	jr @loadPresentPastTilemap

@presentPastTileMap1:
	.db $70 $72 $74 $76 $b4 $78 $7a $7c $7e $00

@presentPastTileMap2:
	.db $71 $73 $75 $77 $b4 $79 $7b $7d $7f $00

.endif



; Data format: dbbw <dungeon_index>, <tile_index>, <tilemap_address>
randoDungeonsMenu_pageList:
	.db @page0 - CADDR
	.db @page1 - CADDR
	.db @page2 - CADDR

@page0:
.ifdef ROM_SEASONS
	dbbw $00, $80, w4TileMap + $021 ; hero's cave
.else
	dbbw $0d, $80, w4TileMap + $021 ; maku path
.endif
	dbbw $01, $a8, w4TileMap + $0c1
	dbbw $02, $d0, w4TileMap + $161
	.db $ff

@page1:
	dbbw $03, $f8, w4TileMap + $021
	dbbw $04, $20, w4TileMap + $0c1
	dbbw $05, $81, w4TileMap + $161
	.db $ff

@page2:
	dbbw $06, $a9, w4TileMap + $021
.ifdef ROM_AGES
	dbbw $0c, $a9, w4TileMap + $021 ; mermaid's cave past
.endif
	dbbw $07, $d1, w4TileMap + $0c1
	dbbw $08, $f9, w4TileMap + $161
	.db $ff

;;
; @param	a	Base tile index of blurb
; @param	e	Flags
; @param	hl	Tilemap location to draw blurb at
randoDungeonsMenu_drawBlurbAt:
	ld c,3
	call @drawRows
	sub $28
	ld c,2
	jp @drawRows

; c: # rows
@drawRows:
	ld b,8
--
	ld (hl),a
	set 2,h
	ld (hl),e
	res 2,h
	inc hl
	inc a
	dec b
	jr nz,--

	ld b,a
	ld a,32 - 8
	rst_addAToHl
	ld a,b
	add 8
	dec c
	jr nz,@drawRows
	ret

.ENDS
