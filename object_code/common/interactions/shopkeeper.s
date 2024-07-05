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


; ==================================================================================================
; INTERAC_SHOPKEEPER
;
; Variables:
;   var37: Index of item that Link is holding (the item's "subid")
;   var38: Nonzero if the item can't be sold (ie. Link already has a shield)
;   var39: Which chest is the correct one in the chest minigame (0 or 1)
;   var3a: "Return value" from purchase script (if $ff, the purchase failed)
;   var3b: Object index of item that Link is holding
;   var3c: The current round in the chest minigame.
;   var3f: If nonzero, this is the tier of the ring Link is buying.
; ==================================================================================================
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
	ld (hl),INTERAC_TREASURE
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
	cp INTERAC_SHOP_ITEM
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
