;;
; Indirectly calls a few functions. Used for code outside of this bank.
; @param c Index of the function to run
; @addr{4870}
functionCaller:
	ld a,c			; $4870
	rst_jumpTable			; $4871
	.dw _clearAllParentItems
	.dw _updateParentItemButtonAssignment_body
	.dw checkUseItems

;;
; Clears all variables related to items being used?
; @addr{4878}
_clearAllParentItems:
	push de			; $4878
	ld d,>w1ParentItem2		; $4879
--
	call _clearParentItem		; $487b
	inc d			; $487e
	ld a,d			; $487f
	cp WEAPON_ITEM_INDEX			; $4880
	jr c,--			; $4882

	xor a			; $4884
	ld (wUsingShield),a		; $4885
	ld (wcc63),a		; $4888
	ld (wMagnetGloveState),a		; $488b
	pop de			; $488e
	ret			; $488f

;;
; Called from "updateParentItemButtonAssignment" in bank 0.
;
; Updates var03 of a parent item to correspond to the equipped A or B button item. This is
; called after closing a menu (since button assignments may be changed).
;
; @addr{4890}
_updateParentItemButtonAssignment_body:
	ld h,>w1ParentItem2		; $4890
@itemLoop:
	ld l,Item.enabled		; $4892
	ldi a,(hl)		; $4894
	or a			; $4895
	jr z,+			; $4896

	; Compare Item.id to the B button item
	ld a,(wInventoryB)		; $4898
	cp (hl)			; $489b
	ld a,BTN_B		; $489c
	jr z,++			; $489e

	; Compare Item.id to the A button item
	ld a,(wInventoryA)		; $48a0
	cp (hl)			; $48a3
	ld a,BTN_A		; $48a4
	jr z,++			; $48a6
+
	; Doesn't correspond to A or B
	xor a			; $48a8
++
	ld l,Item.var03		; $48a9
	ld (hl),a		; $48ab
	inc h			; $48ac
	ld a,h			; $48ad
	cp WEAPON_ITEM_INDEX			; $48ae
	jr c,@itemLoop		; $48b0
	ret			; $48b2

;;
; Use items if the appropriate buttons are pressed along with other conditions.
;
; @addr{48b3}
checkUseItems:
	xor a			; $48b3
	ld (wUsingShield),a		; $48b4
	ld hl,wSwordDisabledCounter		; $48b7
	ld a,(hl)		; $48ba
	or a			; $48bb
	jr z,+			; $48bc
	dec (hl)		; $48be
+
	ld hl,wLinkUsingItem1		; $48bf
	ld a,(hl)		; $48c2
	and $0f			; $48c3
	ld (hl),a		; $48c5
	ld a,(wcc63)		; $48c6
	rlca			; $48c9
	jr c,@itemsDisabled	; $48ca

	ld a,(wInShop)		; $48cc
	or a			; $48cf
	jp nz,_checkShopInput		; $48d0

	; Set carry flag if in a spinner or bit 7 of wInAir is set.
	ld a,(wcc95)		; $48d3
	ld b,a			; $48d6
	ld a,(wLinkInAir)		; $48d7
	or b			; $48da
	rlca			; $48db
	jr c,@updateParentItems	; $48dc

	ld a,(wccd8)		; $48de
	ld b,a			; $48e1
	ld a,(wLinkGrabState)		; $48e2
	or b			; $48e5
	jr nz,@updateParentItems	; $48e6

	ld a,(wLinkClimbingVine)		; $48e8
	inc a			; $48eb
	jr z,@updateParentItems	; $48ec

	ld a,(wAreaFlags)		; $48ee
	bit AREAFLAG_BIT_SIDESCROLL,a			; $48f1
	jr nz,@sidescroll	; $48f3

.ifdef ROM_AGES
	bit AREAFLAG_BIT_UNDERWATER,a			; $48f5
	jr z,@normal		; $48f7

	; When underwater, only check the A button
@underwater:
	ldde BTN_A, <wInventoryA		; $48f9
	call _checkItemUsed		; $48fc
	jr @updateParentItems		; $48ff
.endif

	; When in the overworld, only check buttons if not swimming
@normal:
	ld a,(wLinkSwimmingState)		; $4901
	or a			; $4904
	jr z,@checkAB	; $4905
	jr @updateParentItems		; $4907

	; If swimming in a sidescrolling area, only check the B button?
@sidescroll:
	ld a,(wLinkSwimmingState)		; $4909
	or a			; $490c

.ifdef ROM_AGES
	jr z,@checkAB	; $490d

	ld hl,w1Link.var2f		; $490f
	bit 7,(hl)		; $4912
	jr z,@checkB	; $4914

.else; ROM_SEASONS
	jr nz,@checkB
.endif

@checkAB:
	ldde BTN_A, <wInventoryA		; $4916
	call _checkItemUsed		; $4919
@checkB:
	ldde BTN_B, <wInventoryB		; $491c
	call _checkItemUsed		; $491f

	; Update all "parent items"
@updateParentItems:
	ld de,w1ParentItem2		; $4922
@parentItemLoop:
	ld e,Object.enabled		; $4925
	ld a,(de)		; $4927
	or a			; $4928
	call nz,_parentItemUpdate		; $4929
	inc d			; $492c
	ld a,d			; $492d
	cp FIRST_ITEM_INDEX			; $492e
	jr c,@parentItemLoop		; $4930

	lda <w1Link			; $4932
	ldh (<hActiveObjectType),a	; $4933
	ld d,>w1Link		; $4935
	ld a,d			; $4937
	ldh (<hActiveObject),a	; $4938
	ret			; $493a

@itemsDisabled:
	cp $ff			; $493b
	jr nz,@updateParentItems	; $493d

	; If [wcc63] == $ff, force Link to do a sword spin animation?

	call _clearAllParentItems		; $493f

	ld hl,w1ParentItem2		; $4942
	ldde $ff, ITEMID_SWORD		; $4945
	ld c,$f1		; $4948
	call _initializeParentItem		; $494a

	ld a,$80		; $494d
	ld (wcc63),a		; $494f
	jr @updateParentItems		; $4952

;;
; Creates a parent item object if an item is used.
;
; @param	d	Bitmask for button to check
; @param	e	Low byte of inventory item address to check
; @addr{4954}
_checkItemUsed:
	ld h,>wInventoryB		; $4954
	ld l,e			; $4956
	ld a,(hl)		; $4957
	or a			; $4958
	jr nz,@checkItem	; $4959

.ifdef ROM_SEASONS
	ld a,(wInBoxingMatch)
	or a
	jr nz,@forcePunch
.endif

	; Nothing equipped; return unless Link is wearing a punching ring
	ld a,(wActiveRing)		; $495b
	cp EXPERTS_RING			; $495e
	jr z,@punch		; $4960
	cp FIST_RING			; $4962
	ret nz			; $4964

	; Punch if nothing equipped
@punch:
	ld l,<wInventoryB		; $4965
	ldi a,(hl)		; $4967
	or (hl)			; $4968
	ret nz			; $4969

@forcePunch:
	ld a,ITEMID_PUNCH		; $496a

@checkItem:
	; Item IDs $20 and above can't be used directly as items?
	cp NUM_INVENTORY_ITEMS			; $496c
	ret nc			; $496e

	ld e,a			; $496f
	ld hl,_itemUsageParameterTable		; $4970
	rst_addDoubleIndex			; $4973
	ldi a,(hl)		; $4974
	ld c,a			; $4975

	; Check if button is pressed (reads wGameKeysPressed or wGameKeysJustPressed)
	ld l,(hl)		; $4976
	ld h,>wGameKeysPressed		; $4977
	ld a,(hl)		; $4979
	and d			; $497a
	ret z			; $497b

	call _chooseParentItemSlot		; $497c
	ret nz			; $497f

;;
; Initialize a parent item?
;
; @param	c	Upper nibble for Item.enabled
; @param	d	Button pressed
; @param	e	Item.id
; @addr{4980}
_initializeParentItem:
	ld a,c			; $4980
	and $f0			; $4981
	inc a			; $4983
	ld l,Item.enabled		; $4984
	ldi (hl),a		; $4986

	; Set Item.id
	ld (hl),e		; $4987

	; Set Item.var03 to the button pressed
	inc l			; $4988
	inc l			; $4989
	ld (hl),d		; $498a
	ret			; $498b

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
	ld a,c			; $498c
	and $0f			; $498d
	rst_jumpTable			; $498f
	.dw @thing0
	.dw @thing1
	.dw @thing2
	.dw @thing3
	.dw @thing4
	.dw @thing5

;;
; @addr{499c}
@thing4:
	ld a,(w1ParentItem2.enabled)		; $499c
	or a			; $499f
	ret nz			; $49a0

;;
; Only one of the item can exist at a time.
;
; @addr{49a1}
@thing2:
	ld hl,w1ParentItem3.id		; $49a1
	ld a,e			; $49a4
	cp (hl)			; $49a5
	jr z,@thing0	; $49a6

	; Check w1ParentItem4.id
	inc h			; $49a8
	cp (hl)			; $49a9
	jr z,@thing0	; $49aa

;;
; @addr{49ac}
@thing1:
	ld hl,w1ParentItem3.enabled		; $49ac
	ld a,(hl)		; $49af
	or a			; $49b0
	ret z			; $49b1

	; Check w1ParentItem4.enabled
	inc h			; $49b2
	ld a,(hl)		; $49b3
	or a			; $49b4
	ret			; $49b5

;;
; Sword, cane, bombs, shovel, bracelet, feather...
;
; @addr{49b6}
@thing3:
	; If w1ParentItem2 is already in use, continue only if this object's priority is
	; greater than or equal to the other object's.
	ld hl,w1ParentItem2.enabled		; $49b6
	ld a,c			; $49b9
	and $f0			; $49ba
	inc a			; $49bc
	cp (hl)			; $49bd
	jr c,@thing0	; $49be

	push de			; $49c0
	push bc			; $49c1
	call _clearParentItemH		; $49c2
	pop bc			; $49c5
	pop de			; $49c6
	ld hl,w1ParentItem2		; $49c7
	xor a			; $49ca
	ld (wMagnetGloveState),a		; $49cb
	ld (wcc63),a		; $49ce
	ret			; $49d1

;;
; Used for shield, flute, harp (items that don't create separate objects?)
;
; @addr{49d2}
@thing5:
	ld hl,w1ParentItem5.enabled		; $49d2
	ld a,(hl)		; $49d5
	or a			; $49d6
	ret z			; $49d7

;;
; @addr{49d8}
@thing0:
	or h			; $49d8
	ret			; $49d9


;;
; Check whether link is picking up an item in a shop
;
; @addr{49da}
_checkShopInput:
	ld a,(wLinkGrabState)		; $49da
	or a			; $49dd
	ret nz			; $49de

	ld a,(wGameKeysJustPressed)		; $49df
	and $03			; $49e2
	ret z			; $49e4

	call checkGrabbableObjects		; $49e5
	ret nc			; $49e8

	ld a,$83		; $49e9
	ld (wLinkGrabState),a		; $49eb
	ret			; $49ee

;;
; @param	de	Object to update (e should be $00)
; @addr{49ef}
_parentItemUpdate:
	ld a,e			; $49ef
	ldh (<hActiveObjectType),a	; $49f0
	ld a,d			; $49f2
	ldh (<hActiveObject),a	; $49f3

	; Unset a bit corresponding to the item's index?
	call _itemIndexToBit		; $49f5
	ld hl,wcc95		; $49f8
	cpl			; $49fb
	and (hl)		; $49fc
	ld (hl),a		; $49fd

	; Jump to the item-specific code
	ld e,Item.id		; $49fe
	ld a,(de)		; $4a00
	rst_jumpTable			; $4a01

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
	call _clearLinkUsingItem1		; $4a42
	call _itemEnableLinkTurning		; $4a45
	call _itemEnableLinkMovement		; $4a48
	ld e,Item.start		; $4a4b
	jp objectDelete_de		; $4a4d

;;
; @addr{4a50}
_clearParentItemH:
	push de			; $4a50
	ld d,h			; $4a51
	call _clearParentItem		; $4a52
	pop de			; $4a55
	ret			; $4a56
