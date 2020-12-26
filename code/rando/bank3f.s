; gfx-related stuff here. Namespace "bank3f".

;;
; Overrides the sprite data loaded for certain interactions. This is mostly used for "non-item"
; interactions that depict items, like the ones in shops.
;
; @param	hl	Pointer to interactionData (may be modified)
checkLoadCustomSprite:
	push af
	push bc
	push hl
	ld e,Interaction.id
	ld a,(de)
	ld b,a
	inc e
	ld a,(de) ; subid
	ld c,a
	ld e,$02
	ld hl,customSpriteLookupTable
	call searchDoubleKey
	jr nc,@done

	ldi a,(hl)
	ld c,a
	ld b,(hl)
	pop hl
	call lookupItemSprite
	pop bc
	pop af
	ret

@done:
	pop hl
	pop bc
	pop af
	ret


;;
; @param	bc	Treasure object ID to get graphics for
; @param[out]	hl	Address of sprite data (pointing somewhere in "data/{game}/interactionData.s")
lookupItemSprite:
	callab treasureData.getTreasureDataSprite
	ld a,e
	ld hl,interaction60SubidData
	add a
	rst_addAToHl
	ld a,e
	rst_addAToHl
	ret


; Format:
; - Interaction ID
; - SubID
; - Treasure object ID to use for gfx (little-endian word)
customSpriteLookupTable:
	dbbw INTERACID_HEROS_CAVE_SWORD_CHEST, $00, RANDO_SEASONS_ITEM_D0_SWORD
	.db $ff


; Format: Interaction ID; subID; jump address.
; These functions *must* pop af as the last instruction before returning.
customSpriteJumpTable:
;	dbbw $47, $00, setMembersShop1Sprite
;	dbbw $47, $02, setMembersShop2Sprite
;	dbbw $47, $05, setMembersShop3Sprite
;	dbbw $47, $0d, setShopSprite
;	dbbw $59, $00, setPedestalSprite
;	dbbw $6e, $00, setStolenFeatherSprite
;	dbbw $81, $00, setMarket1Sprite
;	dbbw $81, $04, setMarket2Sprite
;	dbbw $81, $0d, setMarket5Sprite
;	dbbw $e6, $02, setTempleOfSeasonsSprite
	.db $ff


