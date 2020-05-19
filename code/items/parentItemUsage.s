;;
; Indirectly calls a few functions. Used for code outside of this bank.
; @param c Index of the function to run
; @addr{4870}
functionCaller:
	ld a,c
	rst_jumpTable
	.dw _clearAllParentItems
	.dw _updateParentItemButtonAssignment_body
	.dw checkUseItems

;;
; Clears all variables related to items being used?
; @addr{4878}
_clearAllParentItems:
	push de
	ld d,>w1ParentItem2
--
	call _clearParentItem
	inc d
	ld a,d
	cp WEAPON_ITEM_INDEX
	jr c,--

	xor a
	ld (wUsingShield),a
	ld (wcc63),a
	ld (wMagnetGloveState),a
	pop de
	ret

;;
; Called from "updateParentItemButtonAssignment" in bank 0.
;
; Updates var03 of a parent item to correspond to the equipped A or B button item. This is
; called after closing a menu (since button assignments may be changed).
;
; @addr{4890}
_updateParentItemButtonAssignment_body:
	ld h,>w1ParentItem2
@itemLoop:
	ld l,Item.enabled
	ldi a,(hl)
	or a
	jr z,+

	; Compare Item.id to the B button item
	ld a,(wInventoryB)
	cp (hl)
	ld a,BTN_B
	jr z,++

	; Compare Item.id to the A button item
	ld a,(wInventoryA)
	cp (hl)
	ld a,BTN_A
	jr z,++
+
	; Doesn't correspond to A or B
	xor a
++
	ld l,Item.var03
	ld (hl),a
	inc h
	ld a,h
	cp WEAPON_ITEM_INDEX
	jr c,@itemLoop
	ret

;;
; Use items if the appropriate buttons are pressed along with other conditions.
;
; @addr{48b3}
checkUseItems:
	xor a
	ld (wUsingShield),a
	ld hl,wSwordDisabledCounter
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
+
	ld hl,wLinkUsingItem1
	ld a,(hl)
	and $0f
	ld (hl),a
	ld a,(wcc63)
	rlca
	jr c,@itemsDisabled

	ld a,(wInShop)
	or a
	jp nz,_checkShopInput

	; Set carry flag if in a spinner or bit 7 of wInAir is set.
	ld a,(wcc95)
	ld b,a
	ld a,(wLinkInAir)
	or b
	rlca
	jr c,@updateParentItems

	ld a,(wccd8)
	ld b,a
	ld a,(wLinkGrabState)
	or b
	jr nz,@updateParentItems

	ld a,(wLinkClimbingVine)
	inc a
	jr z,@updateParentItems

	ld a,(wTilesetFlags)
	bit TILESETFLAG_BIT_SIDESCROLL,a
	jr nz,@sidescroll

.ifdef ROM_AGES
	bit TILESETFLAG_BIT_UNDERWATER,a
	jr z,@normal

	; When underwater, only check the A button
@underwater:
	ldde BTN_A, <wInventoryA
	call _checkItemUsed
	jr @updateParentItems
.endif

	; When in the overworld, only check buttons if not swimming
@normal:
	ld a,(wLinkSwimmingState)
	or a
	jr z,@checkAB
	jr @updateParentItems

	; If swimming in a sidescrolling area, only check the B button?
@sidescroll:
	ld a,(wLinkSwimmingState)
	or a

.ifdef ROM_AGES
	jr z,@checkAB

	ld hl,w1Link.var2f
	bit 7,(hl)
	jr z,@checkB

.else; ROM_SEASONS
	jr nz,@checkB
.endif

@checkAB:
	ldde BTN_A, <wInventoryA
	call _checkItemUsed
@checkB:
	ldde BTN_B, <wInventoryB
	call _checkItemUsed

	; Update all "parent items"
@updateParentItems:
	ld de,w1ParentItem2
@parentItemLoop:
	ld e,Object.enabled
	ld a,(de)
	or a
	call nz,_parentItemUpdate
	inc d
	ld a,d
	cp FIRST_ITEM_INDEX
	jr c,@parentItemLoop

	lda <w1Link
	ldh (<hActiveObjectType),a
	ld d,>w1Link
	ld a,d
	ldh (<hActiveObject),a
	ret

@itemsDisabled:
	cp $ff
	jr nz,@updateParentItems

	; If [wcc63] == $ff, force Link to do a sword spin animation?

	call _clearAllParentItems

	ld hl,w1ParentItem2
	ldde $ff, ITEMID_SWORD
	ld c,$f1
	call _initializeParentItem

	ld a,$80
	ld (wcc63),a
	jr @updateParentItems

;;
; Creates a parent item object if an item is used.
;
; @param	d	Bitmask for button to check
; @param	e	Low byte of inventory item address to check
; @addr{4954}
_checkItemUsed:
	ld h,>wInventoryB
	ld l,e
	ld a,(hl)
	or a
	jr nz,@checkItem

.ifdef ROM_SEASONS
	ld a,(wInBoxingMatch)
	or a
	jr nz,@forcePunch
.endif

	; Nothing equipped; return unless Link is wearing a punching ring
	ld a,(wActiveRing)
	cp EXPERTS_RING
	jr z,@punch
	cp FIST_RING
	ret nz

	; Punch if nothing equipped
@punch:
	ld l,<wInventoryB
	ldi a,(hl)
	or (hl)
	ret nz

@forcePunch:
	ld a,ITEMID_PUNCH

@checkItem:
	; Item IDs $20 and above can't be used directly as items?
	cp NUM_INVENTORY_ITEMS
	ret nc

	ld e,a
	ld hl,_itemUsageParameterTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,a

	; Check if button is pressed (reads wGameKeysPressed or wGameKeysJustPressed)
	ld l,(hl)
	ld h,>wGameKeysPressed
	ld a,(hl)
	and d
	ret z

	call _chooseParentItemSlot
	ret nz

;;
; Initialize a parent item?
;
; @param	c	Upper nibble for Item.enabled
; @param	d	Button pressed
; @param	e	Item.id
; @addr{4980}
_initializeParentItem:
	ld a,c
	and $f0
	inc a
	ld l,Item.enabled
	ldi (hl),a

	; Set Item.id
	ld (hl),e

	; Set Item.var03 to the button pressed
	inc l
	inc l
	ld (hl),d
	ret

;;
; Figure out which parent item slot an item should use (if at all).
;
; @param	c	Byte read from _itemUsageParameterTable
; @param	e	Item.id (returned unmodified)
;
; @param[out]	c	Value for upper nibble of Item.enabled
; @param[out]	hl	Parent item slot to write to
; @param[out]	zflag	Set if valid values for 'c' and 'hl' are returned.
; @addr{498c
_chooseParentItemSlot:
	ld a,c
	and $0f
	rst_jumpTable
	.dw @thing0
	.dw @thing1
	.dw @thing2
	.dw @thing3
	.dw @thing4
	.dw @thing5

;;
; @addr{499c}
@thing4:
	ld a,(w1ParentItem2.enabled)
	or a
	ret nz

;;
; Only one of the item can exist at a time.
;
; @addr{49a1}
@thing2:
	ld hl,w1ParentItem3.id
	ld a,e
	cp (hl)
	jr z,@thing0

	; Check w1ParentItem4.id
	inc h
	cp (hl)
	jr z,@thing0

;;
; @addr{49ac}
@thing1:
	ld hl,w1ParentItem3.enabled
	ld a,(hl)
	or a
	ret z

	; Check w1ParentItem4.enabled
	inc h
	ld a,(hl)
	or a
	ret

;;
; Sword, cane, bombs, shovel, bracelet, feather...
;
; @addr{49b6}
@thing3:
	; If w1ParentItem2 is already in use, continue only if this object's priority is
	; greater than or equal to the other object's.
	ld hl,w1ParentItem2.enabled
	ld a,c
	and $f0
	inc a
	cp (hl)
	jr c,@thing0

	push de
	push bc
	call _clearParentItemH
	pop bc
	pop de
	ld hl,w1ParentItem2
	xor a
	ld (wMagnetGloveState),a
	ld (wcc63),a
	ret

;;
; Used for shield, flute, harp (items that don't create separate objects?)
;
; @addr{49d2}
@thing5:
	ld hl,w1ParentItem5.enabled
	ld a,(hl)
	or a
	ret z

;;
; @addr{49d8}
@thing0:
	or h
	ret


;;
; Check whether link is picking up an item in a shop
;
; @addr{49da}
_checkShopInput:
	ld a,(wLinkGrabState)
	or a
	ret nz

	ld a,(wGameKeysJustPressed)
	and $03
	ret z

	call checkGrabbableObjects
	ret nc

	ld a,$83
	ld (wLinkGrabState),a
	ret

;;
; @param	de	Object to update (e should be $00)
; @addr{49ef}
_parentItemUpdate:
	ld a,e
	ldh (<hActiveObjectType),a
	ld a,d
	ldh (<hActiveObject),a

	; Unset a bit corresponding to the item's index?
	call _itemIndexToBit
	ld hl,wcc95
	cpl
	and (hl)
	ld (hl),a

	; Jump to the item-specific code
	ld e,Item.id
	ld a,(de)
	rst_jumpTable

	.dw _parentItemCode_punch		; ITEMID_NONE
	.dw _parentItemCode_shield		; ITEMID_SHIELD
	.dw _parentItemCode_punch		; ITEMID_PUNCH
	.dw _parentItemCode_bomb		; ITEMID_BOMB
	.dw _parentItemCode_caneOfSomaria	; ITEMID_CANE_OF_SOMARIA
	.dw _parentItemCode_sword		; ITEMID_SWORD
	.dw _parentItemCode_boomerang		; ITEMID_BOOMERANG
	.dw _parentItemCode_rodOfSeasons	; ITEMID_ROD_OF_SEASONS
	.dw _parentItemCode_magnetGloves	; ITEMID_MAGNET_GLOVES
	.dw _clearParentItem			; ITEMID_SWITCH_HOOK_HELPER
	.dw _parentItemCode_switchHook		; ITEMID_SWITCH_HOOK
	.dw _clearParentItem			; ITEMID_SWITCH_HOOK_CHAIN
	.dw _parentItemCode_biggoronSword	; ITEMID_BIGGORON_SWORD
	.dw _parentItemCode_bombchu		; ITEMID_BOMBCHUS
	.dw _parentItemCode_flute		; ITEMID_FLUTE
	.dw _parentItemCode_shooter		; ITEMID_SHOOTER
	.dw _clearParentItem			; ITEMID_10
	.dw _parentItemCode_harp		; ITEMID_HARP
	.dw _clearParentItem			; ITEMID_12
	.dw _parentItemCode_slingshot		; ITEMID_SLINGSHOT
	.dw _clearParentItem			; ITEMID_14
	.dw _parentItemCode_shovel		; ITEMID_SHOVEL
	.dw _parentItemCode_bracelet		; ITEMID_BRACELET
	.dw _parentItemCode_feather		; ITEMID_FEATHER
	.dw _clearParentItem			; ITEMID_18
	.dw _parentItemCode_satchel		; ITEMID_SEED_SATCHEL
	.dw _clearParentItem			; ITEMID_DUST
	.dw _clearParentItem			; ITEMID_1b
	.dw _clearParentItem			; ITEMID_1c
	.dw _clearParentItem			; ITEMID_MINECART_COLLISION
	.dw _parentItemCode_foolsOre		; ITEMID_FOOLS_ORE
	.dw _clearParentItem			; ITEMID_1f

;;
; @addr{4a42}
_clearParentItem:
	call _clearLinkUsingItem1
	call _itemEnableLinkTurning
	call _itemEnableLinkMovement
	ld e,Item.start
	jp objectDelete_de

;;
; @addr{4a50}
_clearParentItemH:
	push de
	ld d,h
	call _clearParentItem
	pop de
	ret
