;;
; @addr{4000}
initGbaModePaletteData:
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w2GbaModePaletteData
	ld ($ff00+R_SVBK),a

	ld hl,_gbaModePaletteData
	ld de,w2GbaModePaletteData
	ld b,$80
	call copyMemory

	pop af
	ld ($ff00+R_SVBK),a
	ret

;;
; Redraw dirty palettes
; @addr{4016}
refreshDirtyPalettes:
	ld a,$02
	ld ($ff00+R_SVBK),a

	ldh a,(<hDirtyBgPalettes)
	ld d,a
	ldh a,(<hBgPaletteSources)
	ld e,a
	ld l,<w2TilesetBgPalettes
	call @refresh

	ldh a,(<hDirtySprPalettes)
	ld d,a
	ldh a,(<hSprPaletteSources)
	ld e,a
	ld l,<w2TilesetSprPalettes
;;
; @param d Bitset of dirty palettes
; @param e Bitset of where to get the palettes from
; @param l $80 for background, $c0 for sprites
; @addr{402d}
@refresh:
	ld a,d
	or a
	ret z

	srl d
	jr nc,@nextPalette

	ld h,>w2TilesetBgPalettes
	srl e
	jr nc,+

	; h = >w2FadingBgPalettes (or equivalently, >w2FadingSprPalettes)
	inc h
+
	ldh a,(<hGameboyType)
	inc a
	jr nz,@gbcMode

@gbaMode:
	call @gbaBrightenPalette
	call @gbaBrightenPalette
	call @gbaBrightenPalette
	call @gbaBrightenPalette
	jr @refresh

@gbcMode:
	push de
	ld b,>w2BgPalettesBuffer
	ld c,l
	res 7,c
	ld e,$08
-
	ldi a,(hl)
	ld (bc),a
	inc c
	dec e
	jr nz,-

	pop de
	jr @refresh

@nextPalette:
	ld a,l
	add $08
	ld l,a
	srl e
	jr @refresh

;;
; @addr{4067}
@gbaBrightenPalette:
	ldi a,(hl)
	ld c,a
	and $e0
	ld b,a
	ld a,(hl)
	and $03
	or b
	swap a
	ld b,a
	ldd a,(hl)
	and $7c
	rrca
	rrca
	push hl
	ld hl,w2GbaModePaletteData+$60
	rst_addAToHl
	ld a,b
	ld b,(hl)
	ld hl,w2GbaModePaletteData+$21
	rst_addAToHl
	ldd a,(hl)
	or b
	ld b,a
	ld a,c
	and $1f
	ld c,(hl)
	ld hl,w2GbaModePaletteData
	rst_addAToHl
	ld a,(hl)
	or c
	pop hl
	ld c,h
	res 7,l
	ld h,$df
	ldi (hl),a
	ld a,b
	ldi (hl),a
	set 7,l
	ld h,c
	ret

; @addr{409d}
_gbaModePaletteData:
	.db $00 $05 $07 $08 $0a $0b $0c $0e
	.db $10 $11 $12 $13 $14 $15 $16 $17
	.db $18 $19 $1a $1b $1b $1c $1c $1d
	.db $1d $1e $1e $1e $1f $1f $1f $1f
	.db $00 $00 $a0 $00 $e0 $00 $00 $01
	.db $40 $01 $60 $01 $80 $01 $c0 $01
	.db $00 $02 $20 $02 $40 $02 $60 $02
	.db $80 $02 $a0 $02 $c0 $02 $e0 $02
	.db $00 $03 $20 $03 $40 $03 $60 $03
	.db $60 $03 $80 $03 $80 $03 $a0 $03
	.db $a0 $03 $c0 $03 $c0 $03 $c0 $03
	.db $e0 $03 $e0 $03 $e0 $03 $e0 $03
	.db $00 $14 $1c $20 $28 $2c $30 $38
	.db $40 $44 $48 $4c $50 $54 $58 $5c
	.db $60 $64 $68 $6c $6c $70 $70 $74
	.db $74 $78 $78 $78 $7c $7c $7c $7c

;;
; @addr{411d}
_resumeThreadNextFrameIfLcdIsOn:
	ld a,($ff00+R_LCDC)
	rlca
	ret nc

	call resumeThreadNextFrameAndSaveBank
	ret

;;
; Goes through wLoadedObjectGfx, and reloads each entry. This is called when closing
; the inventory screen and things like that.
; @addr{4125}
reloadObjectGfx:
	ld a,(wLoadedItemGraphic1)
	or a
	call nz,loadUncompressedGfxHeader

	ld a,(wLoadedItemGraphic2)
	or a
	call nz,loadUncompressedGfxHeader
agesFunc_3f_4133:
	ld hl,wLoadedObjectGfx
--
	ldi a,(hl)
	ld e,a
	ld d,(hl)
	dec l
	or a
	jr z,+

	call _insertIndexIntoLoadedObjectGfx
	call _resumeThreadNextFrameIfLcdIsOn
+
	inc l
	ld (hl),d
	inc l
	ld a,l
	cp <wLoadedObjectGfxEnd
	jr c,--

	; Also reload the tree graphics

	ld hl,wLoadedTreeGfxActive
	ld e,(hl)
	ld (hl),$00
	jp loadTreeGfx_body

;;
; @addr{4154}
refreshObjectGfx_body:
	call _markAllLoadedObjectGfxUnused

	; Re-check which object gfx indices are in use by checking all objects of
	; all types.

	; Check enemies
	ld d,FIRST_ENEMY_INDEX
@nextEnemy:
	call _enemyGetObjectGfxIndex
	call _markLoadedObjectGfxUsed
	inc d
	ld a,d
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	; Check parts
	ld d,FIRST_PART_INDEX
@nextPart:
	call _partGetObjectGfxIndex
	call _markLoadedObjectGfxUsed
	inc d
	ld a,d
	cp LAST_PART_INDEX+1
	jr c,@nextPart

	; Check interactions
	ld d,FIRST_INTERACTION_INDEX
@nextInteraction:
	call _interactionGetObjectGfxIndex
	call _markLoadedObjectGfxUsed
	inc d
	ld a,d
	cp LAST_INTERACTION_INDEX+1
	jr c,@nextInteraction

	; Check items
	ld d,FIRST_ITEM_INDEX
@nextItem:
	call _itemGetObjectGfxIndex
	call _markLoadedObjectGfxUsed
	inc d
	ld a,d
	cp LAST_ITEM_INDEX+1
	jr c,@nextItem

; Now check whether to load extra gfx for an interaction or enemy.

	ld a,(wEnemyIDToLoadExtraGfx)
	or a
	jr z,+

	call _getObjectGfxIndexForEnemy
	jr ++
+
	ld hl,wInteractionIDToLoadExtraGfx
	ldi a,(hl)
	or a
	ret z
	ld e,(hl)
	ld (hl),$00
	call _getDataForInteraction
	ld a,(hl)
++
	call _addIndexToLoadedObjectGfx
	call _resumeThreadNextFrameIfLcdIsOn
	ld a,e
	call _findIndexInLoadedObjectGfx
	ld a,l
	sub <wLoadedObjectGfx
	srl a

@nextExtraGfxIndex:
	inc a
	and $07
	ld b,a
	ld hl,wLoadedObjectGfx+1
	rst_addDoubleIndex

	; Remember old values, they may need to be moved to another spot
	ldd a,(hl)
	ld d,a
	ld c,(hl)
	inc e

	; Load the next gfx index
	call _insertIndexIntoLoadedObjectGfx

	; If there was something here before, reload it into another slot
	ld a,d
	or a
	jr z,+
	ld a,c
	push de
	call _addIndexToLoadedObjectGfx
	pop de
+
	call _updateTileIndexBaseForAllObjects

	; Check if bit 7 in the second parameter of objectGfxHeaderTable is set (indicating
	; the end of the data)
	ld d,$00
	ld hl,objectGfxHeaderTable+1
	add hl,de
	add hl,de
	add hl,de
	bit 7,(hl)
	ld a,b
	jr z,@nextExtraGfxIndex

	ld (wLoadedObjectGfxIndex),a
	xor a
	ld (wEnemyIDToLoadExtraGfx),a
	ld (wInteractionIDToLoadExtraGfx),a
	jp _incLoadedObjectGfxIndex

;;
; Forces an object gfx header to be loaded into slot 4 (address 0:8800). Handy way to load
; extra graphics, but uses up object slots. Used by the pirate ship and various things in
; seasons, but apparently unused in ages.
;
; @param	e	Object gfx header (minus 1)
; @addr{41ec}
loadObjectGfxHeaderToSlot4_body:
	push de
	call refreshObjectGfx_body
	pop de
	ld a,$03
	jr refreshObjectGfx_body@nextExtraGfxIndex

;;
; @param	e	Tree gfx index
; @addr{41f5}
loadTreeGfx_body:
	ld hl,wLoadedTreeGfxActive
	ld a,e
	cp (hl)
	ret z

	call _insertIndexIntoLoadedObjectGfx
	jp _resumeThreadNextFrameIfLcdIsOn

;;
; @addr{4201}
_updateTileIndexBaseForAllObjects:
	push bc
	push de
	push hl

	; Enemies
	ld a,Enemy.enabled
	ldh (<hActiveObjectType),a
	ld d,FIRST_ENEMY_INDEX
@nextEnemy:
	call _enemyGetObjectGfxIndex
	call @updateTileIndexBase
	inc d
	ld a,d
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	; Parts
	ld a,Part.enabled
	ldh (<hActiveObjectType),a
	ld d,FIRST_PART_INDEX
@nextPart:
	call _partGetObjectGfxIndex
	call @updateTileIndexBase
	inc d
	ld a,d
	cp LAST_PART_INDEX+1
	jr c,@nextPart

	; Interactions
	ld a,Interaction.enabled
	ldh (<hActiveObjectType),a
	ld d,FIRST_DYNAMIC_INTERACTION_INDEX
@nextInteraction:
	call _interactionGetObjectGfxIndex
	call @updateTileIndexBase
	inc d
	ld a,d
	cp LAST_INTERACTION_INDEX+1
	jr c,@nextInteraction

	; Items
	ld a,Item.enabled
	ldh (<hActiveObjectType),a
	ld d,FIRST_ITEM_INDEX
@nextItem:
	call _itemGetObjectGfxIndex
	call @updateTileIndexBase
	inc d
	ld a,d
	cp LAST_ITEM_INDEX+1
	jr c,@nextItem

	call drawAllSpritesUnconditionally
	call _resumeThreadNextFrameIfLcdIsOn
	pop hl
	pop de
	pop bc
	ret

;;
; Updates the oamTileIndexBase for an object (after graphics may have changed places).
;
; @param	a	Object gfx index
; @param	d	Object index
; @addr{4256}
@updateTileIndexBase:
	or a
	ret z

	call _findIndexInLoadedObjectGfx
	ldh a,(<hActiveObjectType)
	ld e,a
	ld a,(de)
	or a
	ret z

	; If sprite uses vram bank 1, don't readjust oamTileIndexBase
	ld a,e
	add Object.oamFlags
	ld e,a
	ld a,(de)
	bit 3,a
	ret nz

	; e = Object.oamTileIndexBase
	inc e
	ld a,(de)
	and $1f
	add c
	ld (de),a
	ret

;;
; Finds the given object gfx index in wLoadedObjectGfx and marks it as in use, or
; sets the carry flag if it's not found.
;
; @param	a	Object gfx index
; @param[out]	c
; @param[out]	hl	Address where gfx is loaded (if it is loaded)
; @param[out]	cflag	nc if index is loaded
; @addr{4270}
_findIndexInLoadedObjectGfx:
	or a
	ret z

	ld hl,wLoadedObjectGfx
	ld b,$08
	ld c,a
--
	ldi a,(hl)
	cp c
	jr z,+

	inc l
	dec b
	jr nz,--

	ld c,$01
	scf
	ret
+
	ld (hl),$01
	dec l
	ld a,l
	sub <wLoadedObjectGfx
	swap a
	ld c,a
	ret

;;
; Gets the first unused entry of wLoadedObjectGfx it finds?
; @param[out]	c	Relative position in wLoadedObjectGfx which is free
; @param[out]	hl
; @param[out]	cflag	Set on failure.
; @addr{428e}
_findUnusedIndexInLoadedObjectGfx:
	ld b,$08
--
	call _getAddressOfLoadedObjectGfxIndex
	inc l
	ldd a,(hl)
	or a
	jr z,+

	call _incLoadedObjectGfxIndex
	dec b
	jr nz,--

	ld c,$01
	scf
	ret
+
	ld a,l
	sub <wLoadedObjectGfx
	swap a
	ld c,a
	ret

;;
; @addr{42a9}
_incLoadedObjectGfxIndex:
	ld a,(wLoadedObjectGfxIndex)
	inc a
	and $07
	ld (wLoadedObjectGfxIndex),a
	ret

;;
; Gets an address in wLoadedObjectGfx based on wLoadedObjectGfxIndex.
; @addr{42b3}
_getAddressOfLoadedObjectGfxIndex:
	ld a,(wLoadedObjectGfxIndex)
	ld hl,wLoadedObjectGfx
	rst_addDoubleIndex
	ret

;;
; Adds the given index into wLoadedObjectGfx if it's not in there already.
;
; @param	a	Object gfx index
; @param[out]	a	Relative position where it's placed in wLoadedObjectGfx
; @param[out]	cflag	Set if graphics were queued to be loaded and lcd is
;			currently on
; @addr{42bb}
_addIndexToLoadedObjectGfx:
	or a
	ret z

	push hl
	push bc
	ld e,a
	call _findIndexInLoadedObjectGfx
	jr nc,+

	call _findUnusedIndexInLoadedObjectGfx
	call nc,_insertIndexIntoLoadedObjectGfx
+
	ld a,c
	pop bc
	pop hl
	ret

;;
; Adds index "e" into the wLoadedObjectGfx buffer at the specified position, or into
; wLoadedTreeGfx if that's what hl is pointing to.
;
; Also performs the actual loading of the gfx, and removes any duplicates in
; the list.
;
; @param	e	Object gfx index
; @param	hl	Address in wLoadedObjectGfx?
; @addr{42cf}
_insertIndexIntoLoadedObjectGfx:
	ld a,l
	cp <wLoadedTreeGfxActive
	jr nc,++

	; First, remove any references to it if it's already loaded (to prevent
	; redundancy)
	push hl
	ld hl,wLoadedObjectGfx
-
	ldi a,(hl)
	cp e
	jr nz,+

	xor a
	ldd (hl),a
	ldi (hl),a
+
	inc l
	ld a,l
	cp <wLoadedObjectGfxEnd
	jr c,-

	pop hl
++
	push bc
	push de
	push hl
	ld (hl),e
	inc l
	ld (hl),$01
	dec l
	ld a,l
	cp <wLoadedTreeGfxActive
	jr c,@object

@tree:
	ld b,$92
	ld hl,treeGfxHeaderTable
	jr ++

@object:
	sub <wLoadedObjectGfx
	or $80
	ld b,a
	ld hl,objectGfxHeaderTable
++
	ld d,$00
	add hl,de
	add hl,de
	add hl,de
	call loadObjectGfx
	pop hl
	pop de
	pop bc
	ret

;;
; Mark a particular object gfx index as used. This doesn't insert the index into
; wLoadedObjectGfx if it's not found, though.
; @param a Object gfx index to mark as used
; @addr{430e}
_markLoadedObjectGfxUsed:
	or a
	ret z

	push bc
	push hl
	ld hl,wLoadedObjectGfx
	ld c,a
-
	ldi a,(hl)
	cp c
	jr z,@found

	inc l
	ld a,l
	cp <wLoadedObjectGfxEnd
	jr c,-

	jr @end

@found:
	ld (hl),$01
@end:
	pop hl
	pop bc
	ret

;;
; Sets the 2nd byte of every entry in the wLoadedObjectGfx buffer to $00,
; indicating that they are not being used.
; @addr{4327}
_markAllLoadedObjectGfxUnused:
	push bc
	push hl
	ld hl,wLoadedObjectGfx
	ld b,$08
	xor a
-
	inc l
	ldi (hl),a
	dec b
	jr nz,-

	pop hl
	pop bc
	ret

;;
; Get an enemy's gfx index, as well as a pointer to the rest of its data.
; @param[out]	a	Object gfx index
; @param[out]	hl	Pointer to 3 more bytes of enemy data
; @addr{4337}
_enemyGetObjectGfxIndex:
	ld e,Enemy.id
	ld a,(de)

;;
; @param	a	Enemy ID
; @addr{433a}
_getObjectGfxIndexForEnemy:
	push bc
	add a
	ld c,a
	ld b,$00
	ld hl,enemyData
	add hl,bc
	add hl,bc
	pop bc
	ldi a,(hl)
	ret

;;
; @param[out]	a	Object gfx index
; @param[out]	hl	Pointer to 7 more bytes of part data
; @addr{4347}
_partGetObjectGfxIndex:
	push bc
	ld e,Part.id
	ld a,(de)
	call multiplyABy8
	ld hl,partData
	add hl,bc
	pop bc
	ldi a,(hl)
	ret

;;
; @addr{4355}
_interactionGetObjectGfxIndex:
	push bc
	call _interactionGetData
	pop bc
	ldi a,(hl)
	ret

;;
; @addr{435c}
_itemGetObjectGfxIndex:
	ld e,Item.id
	ld a,(de)

	; a *= 3
	ld l,a
	add a
	add l

	ld hl,itemData
	rst_addAToHl
	ldi a,(hl)
	ret

;;
; Loading an enemy?
; @addr{4368}
enemyLoadGraphicsAndProperties:
	call _enemyGetObjectGfxIndex
	call _addIndexToLoadedObjectGfx
	ld c,a
	call c,_resumeThreadNextFrameIfLcdIsOn
	ld e,Enemy.id
	ld a,(de)
	ld e,Enemy.collisionType
	bit 7,(hl)
	jr z,+
	set 7,a
+
	ld (de),a

	; e = Enemy.enemyCollisionMode
	inc e
	ldi a,(hl)
	and $7f
	ld (de),a
	bit 7,(hl)
	jr z,+

	; If bit 7 is set, read the next 2 bytes as the address of a table.
	; Each entry in the table is for a particular subID. hl will be set to
	; [the table's start address] + (subID*2), or the first entry without
	; bit 7 set, whichever comes first.
	ldi a,(hl)
	and $7f
	ld l,(hl)
	ld h,a
	ld e,Enemy.subid
	ld a,(de)
	ld b,a
	ld e,$00
-
	bit 7,(hl)
	jr z,+

	ld a,e
	cp b
	jr z,+

	inc hl
	inc hl
	inc e
	jr -
+
	ldi a,(hl)
	push hl
	add a
	ld hl,extraEnemyData
	rst_addDoubleIndex
	ld e,$a6
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	pop hl
	ld a,(hl)
	and $0f
	add a
	add c
	ld e,Enemy.oamTileIndexBase
	ld (de),a
	ld a,(hl)
	swap a
	and $0f
	dec e
	ld (de),a
	dec e
	ld (de),a
	xor a
	jp enemySetAnimation

;;
; Loading a part?
; @addr{43c9}
partLoadGraphicsAndProperties:
	call _partGetObjectGfxIndex
	call _addIndexToLoadedObjectGfx
	ld c,a
	call c,_resumeThreadNextFrameIfLcdIsOn
	ld e,Part.id
	ld a,(de)
	bit 7,(hl)
	jr z,+
	set 7,a
+
	ld e,Part.collisionType
	ld (de),a

	; e = Part.enemyCollisionMode
	inc e
	ldi a,(hl)
	and $7f
	ld (de),a

	; e = Part.collisionRadiusY
	inc e
	ld a,(hl)
	swap a
	and $0f
	ld (de),a

	; e = Part.collisionRadiusX
	inc e
	ldi a,(hl)
	and $0f
	ld (de),a

	; e = Part.damage
	inc e
	ldi a,(hl)
	ld (de),a

	; e = Part.health
	inc e
	ldi a,(hl)
	ld (de),a

	ld e,Part.oamTileIndexBase
	ldi a,(hl)
	add c
	ld (de),a

	; e = Part.oamFlags
	dec e
	ldi a,(hl)
	ld (de),a

	; Also write to Part.oamFlagsBackup
	dec e
	ld (de),a

	xor a
	jp partSetAnimation

;;
; Load the object gfx index for an interaction, and get the values for the
; Interaction.oam variables.
;
; @param	d	Interaction index
; @param[out]	a	Initial animation index to use
; @addr{4404}
interactionLoadGraphics:
	call _interactionGetObjectGfxIndex
	call _addIndexToLoadedObjectGfx
	ld c,a

	; If LCD is on and graphics are queued, wait until they're loaded
	call c,_resumeThreadNextFrameIfLcdIsOn

	; Calculate Interaction.oamTileIndexBase, which is the offset to add to
	; the tile index of all sprites in its animation. "c" currently
	; contains the offset where the graphics are loaded.
	ldi a,(hl)
	and $7f
	add c
	ld e,Interaction.oamTileIndexBase
	ld (de),a

	; Write palette into Interaction.oamFlags
	ld a,(hl)
	swap a
	and $0f
	dec e
	ld (de),a

	; Also write it into Interaction.oamFlagsBackup
	dec e
	ld (de),a

	; Return the animation index to start on
	ld a,(hl)
	and $0f
	ret

;;
; Same as above function, but for items.
; @param d Item index
; @addr{4422}
itemLoadGraphics:
	call _itemGetObjectGfxIndex
	call _addIndexToLoadedObjectGfx
	ld c,a

	; If LCD is on and graphics are queued, wait until they're loaded
	call c,_resumeThreadNextFrameIfLcdIsOn

	; Calculate Item.oamTileIndexBase
	ldi a,(hl)
	add c
	ld e,Item.oamTileIndexBase
	ld (de),a

	; Write palette / flags into Item.oamFlags
	ld a,(hl)
	dec e
	ld (de),a

	; Also write it into Item.oamFlagsBackup
	dec e
	ld (de),a
	ret

;;
; @addr{4437}
_interactionGetData:
	ld h,d
	ld l,Interaction.id
	ldi a,(hl)
	ld e,(hl)

;;
; @param	a	Interaction ID
; @param	e	Interaction subID
; @addr{443c}
_getDataForInteraction:
	ld c,a
	ld b,$00
	ld hl,interactionData+1
	add hl,bc
	add hl,bc
	add hl,bc
	ldd a,(hl)
	rlca
	ret nc

	ldi a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	ld c,$03

	; a = subID
	ld a,e
	or a
	ret z
-
	inc hl
	bit 7,(hl)
	dec hl
	ret nz

	add hl,bc
	dec a
	jr nz,-
	ret

;;
; @param e Uncompressed gfx header to load
; @addr{445b}
loadWeaponGfx:
	ld hl,wLoadedItemGraphic1
	ld a,e
	cp UNCMP_GFXH_1a
	jr nc,+
	inc l
+
	cp (hl)
	ret z

	ld (hl),a
	push de
	call loadUncompressedGfxHeader
	pop de
	ret
