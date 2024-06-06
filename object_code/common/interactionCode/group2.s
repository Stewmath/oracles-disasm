 m_section_free Interaction_Code_Group2 NAMESPACE commonInteractions2

;;
; Reloads the tiles for "price" on the item selection area when necessary.
checkReloadShopItemTiles:
	ld a,(wScrollMode)
	cp $02
	ret z

	ld hl,wInShop
	bit 2,(hl)
	ret z

	res 2,(hl)
	push de
	ld a,UNCMP_GFXH_11
	call loadUncompressedGfxHeader
	pop de
	ret


; ==============================================================================
; INTERACID_SHOPKEEPER
;
; Variables:
;   var37: Index of item that Link is holding (the item's "subid")
;   var38: Nonzero if the item can't be sold (ie. Link already has a shield)
;   var39: Which chest is the correct one in the chest minigame (0 or 1)
;   var3a: "Return value" from purchase script (if $ff, the purchase failed)
;   var3b: Object index of item that Link is holding
;   var3c: The current round in the chest minigame.
;   var3f: If nonzero, this is the tier of the ring Link is buying.
; ==============================================================================
interactionCode46:
	call checkReloadShopItemTiles
	call @runState
	jp interactionAnimateAsNpc

@runState:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw shopkeeperState0
	.dw shopkeeperState1
	.dw shopkeeperState2
	.dw shopkeeperState3
	.dw shopkeeperState4
	.dw shopkeeperState5
	.dw shopkeeperState6

shopkeeperState0:
	ld a,$01
	ld (de),a

	; Set this guy to always be active even when textboxes are up
	ld e,Interaction.enabled
	ld a,(de)
	or $80
	ld (de),a

	ld a,$80
	ld (wcca2),a

	call interactionInitGraphics

	ld e,Interaction.angle
	ld a,$04
	ld (de),a
	ld bc,$0614
	call objectSetCollideRadii

	ld l,Interaction.subid
	ld a,(hl)
	cp $01
	jr nz,++

	; Set bit 7 of subid if the chest game should be run
	ld a,(wBoughtShopItems1)
	and $0f
	cp $0f
	jr nz,++
	set 7,(hl)
++
.ifdef ROM_AGES
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld a,$03
	call z,interactionSetAnimation
.else
	ld a,$53
	call checkTreasureObtained
	jr nc,+
	ld e,$7e
	ld a,$01
	ld (de),a
+
.endif

	ld a,>TX_0e00
	call interactionSetHighTextIndex
	ld e,Interaction.pressedAButton
	jp objectAddToAButtonSensitiveObjectList


; State 1: waiting for Link to do something
shopkeeperState1:
	call retIfTextIsActive

	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	jr nz,@pressedA

.ifdef ROM_SEASONS
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,+
	ld e,Interaction.var3d
	ld a,(de)
	or a
	jr nz,+
	ld bc,$3008
	call objectSetCollideRadii
	call objectCheckCollidedWithLink
	jr nc,+
	ld e,Interaction.state
	ld a,$03
	ld (de),a
	ret
+
.endif

	; Check Link's position to see if he's trying to steal something
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld hl,w1Link.xh
	jr nz,+

.ifdef ROM_SEASONS
	ld e,Interaction.xh
	ld a,(de)
	cp (hl)
	jr nc,@goToState6
.endif

+
	ld l,<w1Link.yh
	ld e,Interaction.subid
	ld a,(de)
	and $01
	ld c,$69
	ld b,(hl)
	ld a,$69
	jr z,+
	ld b,$27
	ld c,(hl)
	ld a,$27
+
	ld l,a
	ld a,c
	cp b
	jr nc,@setNormalCollisionRadii
	ld a,(wLinkGrabState)
	or a
	jr z,@setNormalCollisionRadii

	; He's trying to steal something, stop him!
	ld a,$81
	ld (wDisabledObjects),a
	ld a,l
	ld hl,w1Link.yh
	ld (hl),a

	ld bc,$0606
	call objectSetCollideRadii

	ld e,Interaction.subid
	ld a,(de)
	ld hl,shopkeeperTheftPreventionScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp shopkeeperLoadScript

@setNormalCollisionRadii:
	ld bc,$0614
	jp objectSetCollideRadii

@pressedA:
	xor a
	ld (de),a
	call objectRemoveFromAButtonSensitiveObjectList
	call shopkeeperTurnToFaceLink

	ld a,$81
	ld (wDisabledObjects),a

	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ret

.ifdef ROM_SEASONS
@goToState6:
	ld a,$06
	call objectSetCollideRadius
	ld l,Interaction.state
	ld (hl),$06
	ld l,Interaction.var3d
	ld (hl),d
	ret
.endif


; State 6: ?
shopkeeperState6:
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	jr nz,@pressedA

	ld hl,w1Link.xh
	ld e,Interaction.xh
	ld a,(de)
	cp (hl)
	ret nc
	jp shopkeeperGotoState1

@pressedA:
	xor a
	ld (de),a
	call objectRemoveFromAButtonSensitiveObjectList

	ld a,$81
	ld (wDisabledObjects),a

	ld e,Interaction.state
	ld a,$02
	ld (de),a
	jp shopkeeperTurnToFaceLink


; State 2: talking to Link (this code still runs even while text is up)
shopkeeperState2:
	ld e,Interaction.subid
	ld a,(de)
	and $80
	jr nz,shopkeeperPromptChestGame

.ifdef ROM_SEASONS
	ld a,TREASURE_SWORD
	call checkTreasureObtained
	ld hl,mainScripts.shopkeeperScript_notOpenYet
	jr nc,shopkeeperLoadScript
.endif

	ld a,(wLinkGrabState)
	or a
	jr z,@holdingNothing

	; Check what Link is holding
	ld a,(w1Link.relatedObj2+1)
	ld h,a
	ld e,Interaction.var3b
	ld (de),a

	ld l,Interaction.subid
	ld a,(hl)
	ld e,Interaction.var37
	ld (de),a

	call shopkeeperGetItemPrice

	ld e,Interaction.var37
	ld a,(de)
	call shopkeeperCheckLinkHasItemAlready
	ld hl,mainScripts.shopkeeperScript_purchaseItem
	jp shopkeeperLoadScript

@holdingNothing:
	call shopkeeperCheckAllItemsBought
	jr nz,shopkeeperLoadScript

	ld e,Interaction.subid
	ld a,(de)
	cp $02
	ld hl,mainScripts.shopkeeperScript_lynnaShopWelcome
	jr nz,shopkeeperLoadScript
	ld hl,mainScripts.shopkeeperScript_advanceShopWelcome


shopkeeperLoadScript:
	ld e,Interaction.state
	ld a,$04
	ld (de),a
	jp interactionSetScript


shopkeeperPromptChestGame:
	ld a,$0c
	call shopkeeperGetItemPrice
	ld hl,mainScripts.shopkeeperChestGameScript
	jr shopkeeperLoadScript


; State 3: Seasons - block Link access
shopkeeperState3:
.ifdef ROM_SEASONS
	ld hl,mainScripts.shopkeeperScript_blockLinkAccess
	jp shopkeeperLoadScript
.endif


; State 4: Running a script (prompting whether to buy, playing chest game, etc...)
shopkeeperState4:
	ld e,Interaction.subid
	ld a,(de)
	and $80
	ld a,$0c
	call nz,shopkeeperGetItemPrice
	call interactionRunScript
	ret nc

	; Script over

	xor a
	ld (wDisabledObjects),a

	ld e,Interaction.var3f
	ld a,(de)
	or a
	jr z,@notRing

	ld c,a
	xor a
	ld (de),a
	call getRandomRingOfGivenTier
	ld b,c
	ld c,$00
	call giveRingToLink

	ld a,$01
	ld (wDisabledObjects),a
	jr shopkeeperGotoState1

@notRing:
	; Check var3a to see what the response from the script was (purchase succeeded or
	; failed?)
	ld e,Interaction.var3a
	ld a,(de)
	or a
	jr z,shopkeeperGotoState1

	; Set the item to state 4 to put it back (purchase failed)
	inc a
	ld c,$04
	jr z,@setItemState

	; Set the item to state 3 to obtain it
	ld c,$03
	ld a,$81
	ld (wDisabledObjects),a

@setItemState:
	xor a
	ld (de),a ; [var3a] = 0

	; Set the held item's state to 'c'.
	ld e,Interaction.var3b
	ld a,(de)
	ld h,a
	ld l,Interaction.state
	ld (hl),c
	call dropLinkHeldItem


shopkeeperGotoState1:
	ld e,Interaction.state
	ld a,$01
	ld (de),a

.ifdef ROM_AGES
	ld bc,$0614
	call objectSetCollideRadii

	ld e,Interaction.subid
	ld a,(de)
	or a
	ld a,$03
	jr z,+
.else
	ld hl,w1Link.xh
	ld e,Interaction.xh
	ld a,(de)
	cp (hl)
	jr nc,+

	ld bc,$0614
	call objectSetCollideRadii

	jr ++
+
	ld a,$06
	call objectSetCollideRadius
++
.endif
	ld a,$01
+
	call interactionSetAnimation
	ld e,Interaction.pressedAButton
	jp objectAddToAButtonSensitiveObjectList


; Playing the chest-choosing minigame. The script tends to change the state.
; It jumps to state 5, substate 0 after relinquishing control for Link to pick a chest.
; It jumps to state 5, substate 2 after relinquishing control for Link to pick a chest.
shopkeeperState5:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,$01
	ld (de),a

	; Decide which chest is the correct one
	call getRandomNumber
	and $01
	ld e,Interaction.var39
	ld (de),a

	call shopkeeperCloseOpenedChest
	xor a
	ld (wcca2),a
	ld e,Interaction.var3f
	ld (de),a
	ret

@substate1:
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	jr z,++

	; Talked to shopkeep
	xor a
	ld (de),a
	ld hl,mainScripts.shopkeeperScript_talkDuringChestGame
	jp shopkeeperLoadScript
++
	; Check if Link's opened a chest
	ld a,(wcca2)
	or a
	ret z

	ld e,Interaction.substate
	xor a
	ld (de),a

	ld a,TILEINDEX_CHEST
	call findTileInRoom
	ld a,(wcca2)
	sub l
	rlca
	xor $01
	and $01
	ld h,d
	ld l,Interaction.var39
	xor (hl)

	ld l,Interaction.var3c
	jr nz,@correctChest

	; Wrong chest
	ld (hl),a
	ld hl,mainScripts.shopkeeperScript_openedWrongChest
	jp shopkeeperLoadScript

@correctChest:
	; Increment round (var3c)
	add (hl)
	ld (hl),a

	; Spawn a rupee "treasure" that doesn't actually give you anything?
	call getFreeInteractionSlot
	ld (hl),INTERACID_TREASURE
	ld l,Interaction.subid
	ld (hl),TREASURE_RUPEES
	inc l
	ld (hl),$08
	ld l,Interaction.var31
	ld (hl),$03
	ld l,Interaction.var39
	ld (hl),$01

	; Determine position for rupee treasure
	ld e,Interaction.var39
	ld a,(de)
	ld bc,shopkeeperChestXPositions
	call addAToBc
	ld l,Interaction.yh
	ld (hl),$20
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a

	ld hl,mainScripts.shopkeeperScript_openedCorrectChest
	jp shopkeeperLoadScript

@substate2:
	; Close the chest that the shopkeeper is facing toward.
	ld e,Interaction.angle
	ld a,(de)
	swap a
	and $01
	ld h,d
	ld l,Interaction.var39
	xor (hl)
	jr nz,@substate3

	call shopkeeperCloseOpenedChest
	ld e,Interaction.substate
	ld a,$03
	ld (de),a

@substate3:
	call interactionRunScript
	ret nc

	ld e,Interaction.substate
	xor a
	ld (de),a

;;
; @param	a	Item index?
shopkeeperGetItemPrice:
	ld hl,shopItemPrices
	rst_addAToHl
	ld a,(hl)
	call cpRupeeValue
	ld (wShopHaveEnoughRupees),a
	ld ($cbad),a
	ld hl,wTextNumberSubstitution
	ld (hl),c
	inc l
	ld (hl),b
	ret

;;
shopkeeperCloseOpenedChest:
	ld a,(wcca2)
	bit 7,a
	ld c,a
	ld a,TILEINDEX_CHEST
	jp z,setTile
	ret

;;
; Sets var38 to nonzero if Link already has this item, or already has the maximum amount
; he can carry.
;
; @param	a	Item index
shopkeeperCheckLinkHasItemAlready:
	ld b,a
	xor a
	ld e,Interaction.var38
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.var38
	or a
	ret nz

	ld h,>wc600Block
	ld a,b
	cp $13
	ret z

	cp $03
	jr z,@shield
	cp $11
	jr z,@shield
	cp $12
	jr z,@shield

	cp $0d
	jr z,@flute

	ld l,<wNumBombs
	cp $04
	jr z,+

	ld l,<wLinkHealth
+
	ldi a,(hl)
	cp (hl)
	ret nz

@cantSell:
	ld a,$01
	ld (de),a
	ret

@shield:
	ld a,TREASURE_SHIELD
	jr @checkObtained

@flute:
	ld a,TREASURE_FLUTE

@checkObtained:
	call checkTreasureObtained
	ld e,Interaction.var38
	ret nc
	jr @cantSell

;;
; @param[out]	hl	Script to run if no shop items exist
; @param[out]	zflag	Set if at least one shop item exists
shopkeeperCheckAllItemsBought:
	ldhl FIRST_DYNAMIC_INTERACTION_INDEX, Interaction.enabled
---
	ld l,Interaction.enabled
	ldi a,(hl)
	or a
	jr z,@next
	ld a,(hl)
	cp INTERACID_SHOP_ITEM
	ret z
@next:
	inc h
	ld a,h
	cp LAST_INTERACTION_INDEX+1
	jr c,---

	ld hl,mainScripts.shopkeeperScript_boughtEverything
	or d
	ret

shopkeeperTurnToFaceLink:
	call objectGetAngleTowardLink
	ld e,Interaction.angle
	ld (de),a
	call convertAngleDeToDirection
	dec e
	ld (de),a
	jp interactionSetAnimation


shopkeeperTheftPreventionScriptTable:
.ifdef ROM_AGES
	.dw mainScripts.shopkeeperSubid0Script_stopLink
.else
	.dw mainScripts.shopkeeperSubid2Script_stopLink
.endif
	.dw mainScripts.shopkeeperSubid1Script_stopLink
	.dw mainScripts.shopkeeperSubid2Script_stopLink


; X positions of the chests in the chest minigame (used for spawning rupee "prizes")
shopkeeperChestXPositions:
	.db $78, $58


; ==============================================================================
; INTERACID_SHOP_ITEM
;
; Variables:
;   var30/31: Y/X position where the item rests in the selection area
; ==============================================================================
interactionCode47:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw shopItemState0
	.dw objectAddToGrabbableObjectBuffer
	.dw shopItemState2
	.dw shopItemState3
	.dw shopItemState4
	.dw shopItemState5


shopItemState0:
	; Check that we're actually in a shop
	ld a,(wInShop)
	and $02
	ret z

	ld a,$01
	ld (de),a

.ifdef ROM_AGES
	; If this is the ring box upgrade, check whether to change it to the L3 box
	ld e,Interaction.subid
	ld a,(de)
	cp $00
	jr nz,++

	ld a,TREASURE_RING_BOX
	call checkTreasureObtained
	jr nc,++

	ld a,(wRingBoxLevel)
	dec a
	jr z,++
	ld a,$14
	ld (de),a
++
	; If this is 10 bombs, delete self if Link doesn't have bombs
	ld a,(de)
	cp $04
	jr nz,++
	ld a,TREASURE_BOMBS
	call checkTreasureObtained
	jp nc,shopItemPopStackAndDeleteSelf
	jr @checkFlutePurchasable
++
.else
	ld a,TREASURE_SWORD
	call checkTreasureObtained
	jp nc,shopItemPopStackAndDeleteSelf
	ld e,Interaction.subid
	ld a,(de)
.endif

	; If this is the shield, check whether to replace it with a gasha seed (linked)
	cp $03
	jr nz,@checkFlutePurchasable
	call checkIsLinkedGame
	jr z,@checkFlutePurchasable

	; Replace with gasha seed
	ld a,$13
	ld (de),a

@checkFlutePurchasable:
	; Decide whether the flute is purchasable (update bit 3 of wBoughtShopItems2)
	ld a,TREASURE_FLUTE
	call checkTreasureObtained
	jr c,@fluteNotPurchasable

.ifdef ROM_AGES
	ld a,GLOBALFLAG_CAN_BUY_FLUTE
	call checkGlobalFlag
	jr z,@fluteNotPurchasable
.else
	ld a,(wRickyState)
	bit 5,a
	jr nz,@fluteNotPurchasable
	ld a,(wEssencesObtained)
	bit 1,a
	jr z,@fluteNotPurchasable
	call checkIsLinkedGame
	jr nz,@fluteNotPurchasable
.endif

	; Flute purchasable
	ld c,$08
	jr ++

@fluteNotPurchasable:
	ld c,$00
++
	ld a,(wBoughtShopItems2)
	and $f7
	or c
	ld (wBoughtShopItems2),a

	; Update bits in wBoughtShopItems2 based on if Link has bombchus?
	ld a,TREASURE_BOMBCHUS
	call checkTreasureObtained
	ld c,$10
	jr c,+
	ld c,$20
+
	ld a,(wBoughtShopItems2)
	and $cf
	or c
	ld (wBoughtShopItems2),a

	; Check whether the item can be sold by reading from "shopItemReplacementTable".
	; This checks for particular bits in memory to see if an item is purchasable. If
	; it's not, it may be replaced with a different item.
@checkReplaceItem:
	ld e,Interaction.subid
	ld a,(de)
	add a
	ld hl,shopItemReplacementTable
	rst_addDoubleIndex

	; Check the bit in memory stating if the item should be replaced with another
	ldi a,(hl)
	ld c,a
	ld b,>wc600Block
	ld a,(bc)
	and (hl)
	jr z,@itemOK

	; The item should be replaced. Check if the next byte is a valid item index.
	inc hl
	ldi a,(hl)
	bit 7,a
	jr nz,shopItemPopStackAndDeleteSelf

	; Try this item. Need to run the above checks again.
	ld (de),a
	ld e,Interaction.xh
	ld a,(de)
	add (hl)
	ld (de),a
	jr @checkReplaceItem

@itemOK:
	call interactionInitGraphics
	ld a,$07
	call objectSetCollideRadius

	ld l,Interaction.var30
	ld e,Interaction.yh
	ld a,(de)
	ldi (hl),a
	ld e,Interaction.xh
	ld a,(de)
	ldi (hl),a

	call objectSetVisible83
	jr shopItemUpdateRupeeDisplay

shopItemState5:
	call retIfTextIsActive
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a


;;
; The fact that this pops the stack means that it will return one level higher than it's
; supposed to? This ultimately isn't a big deal, it just means that other interactions
; won't be updated until next frame, but it's probably unintentional...
shopItemPopStackAndDeleteSelf:
	pop af
	jp interactionDelete


; State 2: item picked up by Link
shopItemState2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld a,$01
	ld (de),a

	; Item should be fully lifted instantly
	ld a,$08
	ld (wLinkGrabState2),a

	call objectSetVisible80
	jr shopItemClearRupeeDisplay

@substate1:
	call shopItemCheckGrabbed
	ret nz

	; Fall through to state 4 if Link pressed the button near the selection area


; State 4: Return to selection area
shopItemState4:
	; Set Y/X to selection area
	ld h,d
	ld e,Interaction.yh
	ld l,Interaction.var30
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.xh
	ld a,(hl)
	ld (de),a

	ld l,Interaction.zh
	ld (hl),$00

	ld l,Interaction.state
	ld (hl),$01

	call shopItemUpdateRupeeDisplay
	call objectSetVisible83
	jp dropLinkHeldItem

;;
; Clears the tiles in w3VramLayout corresponding to item price, and sets bit 2 of wInShop
; in order to request a tilemap update.
;
shopItemClearRupeeDisplay:
	call shopItemGetTilesForRupeeDisplay
	ret nc

	; Replace the tiles generated by above function call with spaces
	push hl
	ld a,$03
	rst_addAToHl
	ld a,$20
	ldi (hl),a
	inc l
	ldi (hl),a
	inc l
	ldi (hl),a
	pop hl
	jr ++

;;
; Updates the tiles in w3VramLayout corresponding to item price, and sets bit 2 of wInShop
; in order to request a tilemap update.
;
shopItemUpdateRupeeDisplay:
	call shopItemGetTilesForRupeeDisplay
	ret nc
++
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	push de
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld b,a

@nextTile:
	ldi a,(hl)
	ld (de),a
	set 2,d
	ldi a,(hl)
	ld (de),a
	res 2,d
	inc de
	dec b
	jr nz,@nextTile

	pop de
	pop af
	ld ($ff00+R_SVBK),a
	ld hl,wInShop
	set 2,(hl)
	ret


; State 3: Link obtains the item (he just bought it, the shopkeeper set the state to this)
shopItemState3:
	; Take rupees
	ld e,Interaction.subid
	ld a,(de)
	ld hl,shopItemPrices
	rst_addAToHl
	ldi a,(hl)
	call removeRupeeValue

	; Determine what the treasure is, give it to him
	ld e,Interaction.subid
	ld a,(de)
	ld hl,shopItemTreasureToGive
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	cp $00
	jr nz,+
	call getRandomRingOfGivenTier
+
	call giveTreasure

.ifdef ROM_SEASONS
	ld e,Interaction.subid
	ld a,(de)
	or a
	call z,refillSeedSatchel
.endif

	ld e,Interaction.state
	ld a,$05
	ld (de),a

	ld a,LINK_STATE_04
	ld (wLinkForceState),a
	ld a,$01
	ld (wcc50),a

	; Show text for the item
	ld e,Interaction.subid
	ld a,(de)
	ld hl,shopItemTextTable
	rst_addAToHl
	ld a,(hl)
	ld c,a
	or a
	ld b,>TX_0000
	jp nz,showText
	ret

;;
; Gets the tiles to replace in the rupee display.
;
; @param[out]	hl	Pointer to tile data (always at wTmpcec0). Data format:
;			* Destination in w3VramTiles to write to (word)
;			* Number of tiles to write (byte)
;			* For each tile:
;				* Tile index (byte)
;				* Tile attribute (byte
; @param[out]	cflag	nc if nothing to do?
shopItemGetTilesForRupeeDisplay:
	ld e,Interaction.subid
	ld a,(de)
	ld c,a
	ld hl,@itemPricePositions
	rst_addDoubleIndex
	ldi a,(hl)
	cp $ff
	ret z

	push de
	ld e,a
	ld d,(hl)

	ld a,c
	ld hl,shopItemPrices
	rst_addAToHl
	ld a,(hl)
	call getRupeeValue

	ld hl,wTmpcec0
	ld (hl),e
	inc l
	ld (hl),d
	inc l

.ifdef ROM_AGES
	ld e,$06 ; Attribute value to use
.else
	ld e,$03 ; Attribute value to use
.endif
	ld d,$30 ; Tile index "base" (digit 0 is tile $30)
	ld a,$02 ; Number of tiles to write
	ldi (hl),a
	ld a,b
	or a
	jr z,+

	; If this is a 3 digit number, go back, increment the size, and draw the first
	; digit.
	dec l
	inc (hl)
	inc l
	call @drawDigit
+
	ld a,c
	swap a
	call @drawDigit

	ld a,c
	call @drawDigit

	ld hl,wTmpcec0
	pop de
	scf
	ret

@drawDigit:
	and $0f
	add d
	ldi (hl),a
	ld (hl),e
	inc l
	ret

@itemPricePositions:
	.dw w3VramTiles+$66
	.dw w3VramTiles+$6f
	.dw w3VramTiles+$6a
	.dw w3VramTiles+$6c
	.dw w3VramTiles+$69
	.dw w3VramTiles+$6e
	.dw w3VramTiles+$6a
	.dw w3VramTiles+$68
	.dw w3VramTiles+$6d
	.dw w3VramTiles+$6b
	.dw w3VramTiles+$6f
	.dw w3VramTiles+$67
	.dw $ffff
	.dw w3VramTiles+$6f
	.dw w3VramTiles+$67
	.dw w3VramTiles+$6b
	.dw w3VramTiles+$6f
	.dw w3VramTiles+$6c
	.dw w3VramTiles+$6c
	.dw w3VramTiles+$6c
.ifdef ROM_AGES
	.dw w3VramTiles+$66
	.dw w3VramTiles+$6e
.endif

shopItemPrices:
	/* $00 */ .db RUPEEVAL_300
	/* $01 */ .db RUPEEVAL_010
	/* $02 */ .db RUPEEVAL_300
	/* $03 */ .db RUPEEVAL_030
	/* $04 */ .db RUPEEVAL_020
.ifdef ROM_AGES
	/* $05 */ .db RUPEEVAL_300
.else
	/* $05 */ .db RUPEEVAL_200
.endif
	/* $06 */ .db RUPEEVAL_500
	/* $07 */ .db RUPEEVAL_300
	/* $08 */ .db RUPEEVAL_300
	/* $09 */ .db RUPEEVAL_300
	/* $0a */ .db RUPEEVAL_300
	/* $0b */ .db RUPEEVAL_100
	/* $0c */ .db RUPEEVAL_010
	/* $0d */ .db RUPEEVAL_150
	/* $0e */ .db RUPEEVAL_100
	/* $0f */ .db RUPEEVAL_100
	/* $10 */ .db RUPEEVAL_100
	/* $11 */ .db RUPEEVAL_050
	/* $12 */ .db RUPEEVAL_080
	/* $13 */ .db RUPEEVAL_030
.ifdef ROM_AGES
	/* $14 */ .db RUPEEVAL_300
	/* $15 */ .db RUPEEVAL_500
.endif

;;
; @param[out]	zflag	z if Link should grab or release the item
shopItemCheckGrabbed:
	ld a,(wGameKeysJustPressed)
	and (BTN_A|BTN_B)
	jr z,@dontGrab

	; Check Link's close enough to the selection area (horizontally)
	ld e,Interaction.var31
	ld a,(de)
	sub $0d
	ld b,a
	add $1a
	ld hl,w1Link.xh
	cp (hl)
	jr c,@dontGrab

	ld a,b
	cp (hl)
	jr nc,@dontGrab

	; Check Link's close enough to the selection area (vertically)
	ld l,<w1Link.yh
	ld a,(hl)
	cp $3d
	jr nc,@dontGrab

	; Check that Link's facing the selection area (DIR_UP)
	ld l,<w1Link.direction
	ld a,(hl)
	or a
	ret

@dontGrab:
	or d
	ret


; These are the treasures that Link receives when he buys a shop item.
;   b0: Treasure index to give (if $00, it's a random ring)
;   b1: Treasure parameter (if it's random ring, this is the tier of the ring)
shopItemTreasureToGive:
.ifdef ROM_AGES
	/* $00 */ .db  TREASURE_RING_BOX      $02
.else
	/* $00 */ .db  TREASURE_SEED_SATCHEL  $01
.endif
	/* $01 */ .db  TREASURE_HEART_REFILL  $0c
	/* $02 */ .db  TREASURE_GASHA_SEED    $01
	/* $03 */ .db  TREASURE_SHIELD        $01
	/* $04 */ .db  TREASURE_BOMBS         $10
.ifdef ROM_AGES
	/* $05 */ .db  $00                    $03
.else
	/* $05 */ .db  TREASURE_TREASURE_MAP  $01
.endif
	/* $06 */ .db  TREASURE_GASHA_SEED    $01
	/* $07 */ .db  TREASURE_POTION        $01
	/* $08 */ .db  TREASURE_GASHA_SEED    $01
	/* $09 */ .db  TREASURE_POTION        $01
	/* $0a */ .db  TREASURE_GASHA_SEED    $01
	/* $0b */ .db  TREASURE_BOMBCHUS      $05
	/* $0c */ .db  $00                    $00
.ifdef ROM_AGES
	/* $0d */ .db  TREASURE_FLUTE         SPECIALOBJECTID_DIMITRI
	/* $0e */ .db  TREASURE_GASHA_SEED    $01
	/* $0f */ .db  TREASURE_RING          GBA_TIME_RING
.else
	/* $0d */ .db  TREASURE_FLUTE         SPECIALOBJECTID_MOOSH
	/* $0e */ .db  TREASURE_GASHA_SEED    $01
	/* $0f */ .db  TREASURE_RING          GBA_NATURE_RING
.endif
	/* $10 */ .db  $00                    $01
	/* $11 */ .db  TREASURE_SHIELD        $02
	/* $12 */ .db  TREASURE_SHIELD        $03
	/* $13 */ .db  TREASURE_GASHA_SEED    $01
.ifdef ROM_AGES
	/* $14 */ .db  TREASURE_RING_BOX      $03
	/* $15 */ .db  TREASURE_HEART_PIECE   $01
.endif


; This lists conditions where a shop item may be replaced with something else.
;   b0: Low byte of an address in $c6xx block
;   b1: Bitmask to check at that address. If result is 0, the item can be sold.
;       If the result is nonzero, a different item is sold instead based on b2.
;   b2: Item to sell if the first one is unavailable (or $ff to sell nothing)
;   b3: Value to add to x position if the first item was sold out
shopItemReplacementTable:
	/* $00 */ .db <wBoughtShopItems1  $01 $ff $00
	/* $01 */ .db <wBoughtShopItems2  $08 $0d $04
	/* $02 */ .db <wBoughtShopItems1  $02 $06 $00
	/* $03 */ .db <wShieldLevel       $02 $11 $00
	/* $04 */ .db <wBoughtShopItems1  $00 $ff $00
	/* $05 */ .db <wBoughtShopItems1  $08 $ff $00
	/* $06 */ .db <wBoughtShopItems1  $04 $ff $00
	/* $07 */ .db <wBoughtShopItems2  $10 $09 $18
	/* $08 */ .db <wBoughtShopItems2  $10 $0a $10
	/* $09 */ .db <wBoughtShopItems1  $00 $ff $00
	/* $0a */ .db <wBoughtShopItems1  $40 $ff $00
	/* $0b */ .db <wBoughtShopItems2  $20 $ff $00
	/* $0c */ .db <wBoughtShopItems1  $00 $ff $00
	/* $0d */ .db <wBoughtShopItems2  $00 $ff $00
	/* $0e */ .db <wBoughtShopItems2  $01 $ff $00
	/* $0f */ .db <wBoughtShopItems2  $02 $ff $00
	/* $10 */ .db <wBoughtShopItems2  $04 $ff $00
	/* $11 */ .db <wShieldLevel       $01 $12 $00
	/* $12 */ .db <wShieldLevel       $00 $ff $00
	/* $13 */ .db <wBoughtShopItems1  $20 $03 $00
.ifdef ROM_AGES
	/* $14 */ .db <wBoughtShopItems1  $01 $ff $00
	/* $15 */ .db <wBoughtShopItems2  $40 $05 $00
.endif


; Text to show upon buying a shop item (or $00 for no text)
shopItemTextTable:
.ifdef ROM_AGES
	/* $00 */ .db <TX_0058
.else
	/* $00 */ .db <TX_0046
.endif
	/* $01 */ .db <TX_004c
	/* $02 */ .db <TX_004b
	/* $03 */ .db <TX_001f
	/* $04 */ .db <TX_004d
.ifdef ROM_AGES
	/* $05 */ .db <TX_0054
.else
	/* $05 */ .db <TX_006c
.endif
	/* $06 */ .db <TX_004b
	/* $07 */ .db <TX_006d
	/* $08 */ .db <TX_004b
	/* $09 */ .db <TX_006d
	/* $0a */ .db <TX_004b
	/* $0b */ .db <TX_0032
	/* $0c */ .db $00
	/* $0d */ .db <TX_003b
	/* $0e */ .db <TX_004b
	/* $0f */ .db <TX_0054
	/* $10 */ .db <TX_0054
	/* $11 */ .db <TX_0020
	/* $12 */ .db <TX_0021
	/* $13 */ .db <TX_004b
.ifdef ROM_AGES
	/* $14 */ .db <TX_0059
	/* $15 */ .db <TX_0017
.endif


; ==============================================================================
; INTERACID_INTRO_SPRITES_1
; ==============================================================================
interactionCode4a:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw introSpritesState1

@state0:
	call introSpriteIncStateAndLoadGraphics
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw introSpriteIncStateAndLoadGraphics
	.dw introSpriteIncStateAndLoadGraphics
	.dw @initSubid07
	.dw objectSetVisible82
	.dw @initSubid09
	.dw @initSubid0a


; Triforce pieces
@initSubid00:
@initSubid01:
@initSubid02:
	call getFreeInteractionSlot
	jr nz,++

	; Create the "glow" behind the triforce
	ld (hl),INTERACID_INTRO_SPRITES_1
	inc l
	ld (hl),$04
	inc l
	ld e,Interaction.subid
	ld a,(de)
	inc a
	ld (hl),a
	call introSpriteSetChildRelatedObject1ToSelf
++
	jp objectSetVisible82

@initSubid03:
@initSubid07:
@initSubid0a:
	ld e,Interaction.var03
	ld a,(de)
	add a
	add a
	ld h,d
	ld l,Interaction.animCounter
	add (hl)
	ld (hl),a

	call interactionSetAlwaysUpdateBit
	call introSpriteFunc_461a
	jp objectSetVisible80

@initSubid09:
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@data
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Interaction.yh
	ld (de),a
	inc e
	inc e
	ld a,(hl)
	ld (de),a
	ld b,$03
--
	call getFreeInteractionSlot
	jr nz,++

	ld (hl),INTERACID_INTRO_SPRITES_1
	inc l
	ld (hl),$0a
	inc l
	ld (hl),b
	dec (hl)
	call introSpriteSetChildRelatedObject1ToSelf
	dec b
	jr nz,--
++
	jp objectSetVisible82

@data:
	.db $40 $78
	.db $40 $48
	.db $18 $60

@initSubid04:
	call objectSetVisible83
	xor $80
	ld (de),a
	ret

;;
introSpriteIncStateAndLoadGraphics:
	ld h,d
	ld l,Interaction.state
	inc (hl)
	jp interactionInitGraphics

;;
; Sets up X and Y positions with some slight random variance?
introSpriteFunc_461a:
	call objectGetRelatedObject1Var
	call objectTakePosition
	push bc
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@data_4660
	cp $03
	jr z,@label_09_043
	cp $0a
	jr z,@label_09_043

	ld hl,@data_4666
	ld e,Interaction.counter2
	ld a,(de)
	inc a
	ld (de),a
	and $03
	ld c,a
	add a
	add c
	rst_addDoubleIndex

@label_09_043:
	ld e,Interaction.var03
	ld a,(de)
	rst_addDoubleIndex

	ldi a,(hl)
	call @addRandomVariance
	ld b,a
	ld e,Interaction.yh
	ld a,(de)
	add b
	ld (de),a

	ld a,(hl)
	call @addRandomVariance
	ld h,d
	ld l,Interaction.xh
	add (hl)
	ld (hl),a
	pop bc
	ret

; Adds a random value between -2 and +1 to the given number.
@addRandomVariance:
	ld b,a
	call getRandomNumber
	and $03
	sub $02
	add b
	ret

@data_4660:
	.db $fc $fc
	.db $07 $ff
	.db $ff $06

@data_4666:
	.db $f4 $f4
	.db $0e $fe
	.db $fa $09

	.db $fb $f0
	.db $09 $ff
	.db $04 $0e

	.db $06 $f8
	.db $f4 $08
	.db $0a $07

	.db $0b $fa
	.db $f4 $00
	.db $03 $0a


;;
introSpritesState1:
	ld e,Interaction.subid
	ld a,(de)
	cp $05
	jr nc,++

	; For subids 0-4 (triforce objects): watch for signal to delete self
	ld a,(wIntro.triforceState)
	cp $04
	jp z,interactionDelete
++
	ld a,(de)
	rst_jumpTable
	.dw introSpriteTriforceSubid
	.dw introSpriteTriforceSubid
	.dw introSpriteTriforceSubid
	.dw introSpriteRunTriforceGlowSubid
	.dw introSpriteRunSubid04
	.dw introSpriteRunSubid05
	.dw introSpriteRunSubid06
	.dw introSpriteRunSubid07
	.dw introSpriteRunSubid08
	.dw interactionAnimate
	.dw introSpriteRunTriforceGlowSubid


; Triforce pieces
introSpriteTriforceSubid:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw interactionAnimate

@substate0:
	ld a,(wIntro.triforceState)
	cp $01
	jp nz,interactionAnimate

	ld b,$00
	ld e,Interaction.subid
	ld a,(de)
	cp $01
	jr z,+
	ld b,$0a
+
	call func_2d48
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),b

@substate1:
	call interactionDecCounter1
	jp nz,interactionAnimate

	ld l,Interaction.subid
	ld a,(hl)
	cp $01
	jr nz,@centerTriforcePiece
	ld l,Interaction.angle
	ld (hl),$00
	ld l,Interaction.speed
	ld (hl),SPEED_20
	ld b,$01
	jr @label_09_048

@centerTriforcePiece:
	or a
	ld a,$18
	jr z,+
	ld a,$08
+
	ld l,Interaction.angle
	ld (hl),a
	ld l,Interaction.speed
	ld (hl),SPEED_20
	ld b,$0b

@label_09_048:
	call func_2d48
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),b

@substate2:
	call interactionDecCounter1
	jr nz,++

	ld b,$02
	call func_2d48
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),b
++
	call objectApplySpeed
	jp interactionAnimate

@substate3:
	call interactionDecCounter1
	jp nz,interactionAnimate

	ld b,$03
	call func_2d48
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),b

	ld e,Interaction.subid
	ld a,(de)
	cp $01
	jr z,+

	jp interactionIncSubstate
+
	ld a,SND_ENERGYTHING
	jp playSound

@substate4:
	call interactionAnimate
	call interactionDecCounter1
	ret nz

	call interactionIncSubstate
	ld a,$02
	ld (wIntro.triforceState),a

	ld a,SND_AQUAMENTUS_HOVER
	jp playSound


introSpriteRunSubid07:
	call objectSetVisible
	ld e,Interaction.var03
	ld a,(de)
	and $01
	ld b,a
	ld a,(wIntro.frameCounter)
	and $01
	xor b
	call z,objectSetInvisible

introSpriteRunTriforceGlowSubid:
	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	call z,introSpriteFunc_461a
	jp interactionAnimate

introSpriteRunSubid04:
introSpriteRunSubid05:
introSpriteRunSubid06:
	call interactionAnimate

	ld a,Object.start
	call objectGetRelatedObject1Var
	call objectTakePosition
	ld e,Interaction.var03
	ld a,(de)
	ld h,d
	ld l,Interaction.animCounter
	cp (hl)
	ld l,Interaction.visible
	jr nz,++

	set 7,(hl)
	ret
++
	res 7,(hl)
	ret


; Extra tree branches in intro
introSpriteRunSubid08:
	ld a,(wGfxRegs1.SCY)
	or a
	jp z,interactionDelete

	ld b,a
	ld e,Interaction.y
	ld a,(de)
	sub b
	inc e
	ld (de),a
	ret

;;
; Sets relatedObj1 of object 'h' to object 'd' (self).
introSpriteSetChildRelatedObject1ToSelf:
	ld l,Interaction.relatedObj1
	ld (hl),Interaction.start
	inc l
	ld (hl),d
	ret


; ==============================================================================
; INTERACID_SEASONS_FAIRY
; ==============================================================================
interactionCode50:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

@state0:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call interactionSetAlwaysUpdateBit

	ld l,Interaction.substate
	ld (hl),$01
	ld l,Interaction.counter1
	ld (hl),$01
	ld l,Interaction.zh
	ld (hl),$00

	ld a,MUS_FAIRY_FOUNTAIN
	ld (wActiveMusic),a
	jp playSound

@@substate1:
	call interactionDecCounter1
	ret nz

	ld l,Interaction.substate
	ld (hl),$02
	ld l,Interaction.counter1
	ld (hl),$10
	jr @createPuff

@@substate2:
	call interactionDecCounter1
	ret nz

	call interactionInitGraphics
	call objectSetVisible80

	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	ld l,Interaction.substate
	ld (hl),$00

	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr nz,++

	ld l,Interaction.counter1
	ld (hl),120
	call @createSparkle0
	jp @updateAnimation
++
	ld l,Interaction.counter1
	ld (hl),60
	call @createSparkle1
	jp @updateAnimation


@createPuff:
	jp objectCreatePuff

@createSparkle0:
	ld bc,$8400
	jr @createInteraction

@createSparkle1:
	ldbc INTERACID_SPARKLE,$07
	call objectCreateInteraction
	ld e,Interaction.counter1
	ld a,(de)
	ld l,e
	ld (hl),a
	ret

@createSparkle2:
	ldbc INTERACID_SPARKLE,$01

@createInteraction:
	jp objectCreateInteraction


@state1:
	call objectOscillateZ_body
	call interactionDecCounter1
	jr z,++

	call @updateAnimation
	ld a,(wFrameCounter)
	rrca
	jp nc,objectSetInvisible
	jp objectSetVisible
++
	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr z,++

	ld l,Interaction.state
	ld (hl),$05
	ld hl,$cfc0
	set 1,(hl)
	call objectSetVisible
	jr @updateAnimation
++
	ld l,Interaction.state
	inc (hl)
	ld l,Interaction.zh
	ld (hl),$00
	ld l,Interaction.var3a
	ld (hl),$30

	ld l,Interaction.angle
	ld (hl),$00
	ld l,Interaction.speed
	ld (hl),SPEED_80

	call objectSetVisible
	ld a,SND_CHARGE_SWORD
	call playSound

@state2:
	call objectApplySpeed

	ld h,d
	ld l,Interaction.yh
	ld a,(hl)
	cp $10
	jr nc,@updateAnimation

	ld l,Interaction.state
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),$04
	ld l,Interaction.var3b
	ld (hl),$00

	ld a,(w1Link.yh)
	ld l,Interaction.yh
	ld (hl),a
	ld a,(w1Link.xh)
	ld l,Interaction.xh
	ld (hl),a

	call @func_48eb

@state3:
	call @checkLinkIsClose
	jr c,++

	call @func_48d0
	call @func_48f9
	ld a,(de)
	ld e,Interaction.var3b
	call objectSetPositionInCircleArc
	call @func_4907
	ld a,(wFrameCounter)
	and $07
	call z,@createSparkle2
	jr @updateAnimation
++
	ld l,Interaction.state
	inc (hl)
	ld hl,$cfc0
	set 1,(hl)

@updateAnimation:
	jp interactionAnimate

@state4:
	call objectOscillateZ_body
	ld a,($cfc0)
	cp $07
	jp z,interactionDelete
	jr @updateAnimation

@state5:
	call objectOscillateZ_body
	ld a,($cfc0)
	cp $07
	jr nz,@updateAnimation
	call @createPuff
	jp interactionDelete

;;
@func_48d0:
	ld l,Interaction.yh
	ld e,Interaction.var38
	ld a,(de)
	ldi (hl),a
	inc l
	inc e
	ld a,(de)
	ld (hl),a
	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	call objectApplySpeed

;;
@func_48eb:
	ld h,d
	ld l,Interaction.yh
	ld e,Interaction.var38
	ldi a,(hl)
	ld (de),a
	ld b,a
	inc l
	inc e
	ld a,(hl)
	ld (de),a
	ld c,a
	ret

;;
@func_48f9:
	ld e,Interaction.var3a
	ld a,(de)
	or a
	ret z
	call interactionDecCounter1
	ret nz

	ld (hl),$04

	ld l,e
	dec (hl)
	ret

;;
@func_4907:
	ld a,(wFrameCounter)
	rrca
	ret nc

	ld e,Interaction.var3b
	ld a,(de)
	inc a
	and $1f
	ld (de),a
	ret

;;
; @param[out]	cflag	Set if Link is close to this object
@checkLinkIsClose:
	ld h,d
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	add $f0
	sub (hl)
	add $04
	cp $09
	ret nc
	ld l,Interaction.xh
	ld a,(w1Link.xh)
	sub (hl)
	add $02
	cp $05
	ret


;;
; When called once per frame, the object's Z positon will gently oscillate up and down.
;
objectOscillateZ_body:
	ld a,(wFrameCounter)
	and $07
	ret nz

	ld a,(wFrameCounter)
	and $38
	swap a
	rlca

	ld hl,@zOffsets
	rst_addAToHl
.ifdef ROM_AGES
	ldh a,(<hActiveObjectType)
	add Object.zh
	ld e,a
	ld a,(de)
	add (hl)
.else
	ld e,Interaction.zh
	ld a,(hl)
.endif
	ld (de),a
	ret

@zOffsets:
	.db $ff $fe $ff $00
	.db $01 $02 $01 $00


; ==============================================================================
; INTERACID_EXPLOSION
; ==============================================================================
interactionCode56:
	call checkInteractionState
	jr z,@state0

@state1:
	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	jp nz,interactionAnimate
	jp interactionDelete

@state0:
	inc a
	ld (de),a
	call interactionInitGraphics
	ld a,SND_EXPLOSION
	call playSound
	ld e,Interaction.var03
	ld a,(de)
	rrca
	jp c,objectSetVisible81
	jp objectSetVisible82

.ends
