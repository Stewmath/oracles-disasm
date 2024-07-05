; ==================================================================================================
; INTERAC_SYRUP
;
; Variables:
;   var37: Item being bought
;   var38: Set to 1 if Link can't purchase an item (because he has too many of it)
;   var3a: "Return value" from purchase script (if $ff, the purchase failed)
;   var3b: Object index of item that Link is holding
; ==================================================================================================
.ifdef ROM_AGES
interactionCode5f:
	callab commonInteractions2.checkReloadShopItemTiles
.else
interactionCode43:
	call commonInteractions2.checkReloadShopItemTiles
.endif
	call @runState
	jp interactionAnimateAsNpc

@runState:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit

	ld l,Interaction.collisionRadiusY
	ld (hl),$12
	inc l
	ld (hl),$07

	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
.ifdef ROM_SEASONS
	call getThisRoomFlags
	and $40
	ld hl,mainScripts.syrupScript_notTradedMushroomYet
	jr z,+
.endif
	ld hl,mainScripts.syrupScript_spawnShopItems
+
	jr @setScriptAndGotoState2


; State 1: Waiting for Link to talk to her
@state1:
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	ret z

	xor a
	ld (de),a

	ld a,$81
	ld (wDisabledObjects),a

	ld a,(wLinkGrabState)
	or a
	jr z,@talkToSyrupWithoutItem

	; Get the object that Link is holding
	ld a,(w1Link.relatedObj2+1)
	ld h,a
.ifdef ROM_AGES
	ld e,Interaction.var3b
.else
	ld e,Interaction.var3c
.endif
	ld (de),a

	; Assume he's holding an INTERAC_SHOP_ITEM. Subids $07-$0c are for syrup's shop.
	ld l,Interaction.subid
	ld a,(hl)
	push af
	ld b,a
	sub $07

.ifdef ROM_AGES
	ld e,Interaction.var37
.else
	ld e,Interaction.var38
.endif
	ld (de),a

	; Check if Link has the rupees for it
	ld a,b
	ld hl,commonInteractions2.shopItemPrices
	rst_addAToHl
	ld a,(hl)
	call cpRupeeValue
.ifdef ROM_AGES
	ld (wShopHaveEnoughRupees),a
.else
	ld e,Interaction.var39
	ld (de),a
.endif
	ld ($cbad),a

	; Check the item type, see if Link is allowed to buy any more than he already has
	pop af
	cp $07
	jr z,@checkPotion
	cp $09
	jr z,@checkPotion

	cp $0b
	jr z,@checkBombchus

	ld a,(wNumGashaSeeds)
	jr @checkQuantity

@checkBombchus:
	ld a,(wNumBombchus)

@checkQuantity:
	; For bombchus and gasha seeds, amount caps at 99
	cp $99
	ld a,$01
	jr nc,@setCanPurchase
	jr @canPurchase

@checkPotion:
	ld a,TREASURE_POTION
	call checkTreasureObtained
	ld a,$01
	jr c,@setCanPurchase

@canPurchase:
	xor a

@setCanPurchase:
	; Set var38 to 1 if Link can't purchase the item because he has too much of it
.ifdef ROM_AGES
	ld e,Interaction.var38
.else
	ld e,Interaction.var3a
.endif
	ld (de),a

	ld hl,mainScripts.syrupScript_purchaseItem
	jr @setScriptAndGotoState2

@talkToSyrupWithoutItem:
	call commonInteractions2.shopkeeperCheckAllItemsBought
	jr z,@showWelcomeText

	ld hl,mainScripts.syrupScript_showClosedText
	jr @setScriptAndGotoState2

@showWelcomeText:
	ld hl,mainScripts.syrupScript_showWelcomeText

@setScriptAndGotoState2:
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	jp interactionSetScript


; State 2: running a script
@state2:
	call interactionRunScript
	ret nc

	; Script done

	xor a
	ld (wDisabledObjects),a

	; Check response from script (was purchase successful?)
.ifdef ROM_AGES
	ld e,Interaction.var3a
.else
	ld e,Interaction.var3b
.endif
	ld a,(de)
	or a
	jr z,@gotoState1 ; Skip below code if he was holding nothing to begin with

	; If purchase was successful, set the held item (INTERAC_SHOP_ITEM) to state
	; 3 (link obtains it)
	inc a
	ld c,$03
	jr nz,++

	; If purchase was not successful, set the held item to state 4 (return to display
	; area)
	ld c,$04
++
	xor a
	ld (de),a
.ifdef ROM_AGES
	ld e,Interaction.var3b
.else
	ld e,Interaction.var3c
.endif
	ld a,(de)
	ld h,a
	ld l,Interaction.state
	ld (hl),c
	call dropLinkHeldItem

@gotoState1:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret
