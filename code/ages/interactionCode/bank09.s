;;
; Reloads the tiles for "price" on the item selection area when necessary.
; @addr{4000}
checkReloadShopItemTiles:
	ld a,(wScrollMode)		; $4000
	cp $02			; $4003
	ret z			; $4005

	ld hl,wInShop		; $4006
	bit 2,(hl)		; $4009
	ret z			; $400b

	res 2,(hl)		; $400c
	push de			; $400e
	ld a,UNCMP_GFXH_11		; $400f
	call loadUncompressedGfxHeader		; $4011
	pop de			; $4014
	ret			; $4015


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
	call checkReloadShopItemTiles		; $4016
	call @runState		; $4019
	jp interactionAnimateAsNpc		; $401c

@runState:
	ld e,Interaction.state		; $401f
	ld a,(de)		; $4021
	rst_jumpTable			; $4022
	.dw _shopkeeperState0
	.dw _shopkeeperState1
	.dw _shopkeeperState2
	.dw _shopkeeperState3
	.dw _shopkeeperState4
	.dw _shopkeeperState5
	.dw _shopkeeperState6

_shopkeeperState0:
	ld a,$01		; $4031
	ld (de),a		; $4033

	; Set this guy to always be active even when textboxes are up
	ld e,Interaction.enabled		; $4034
	ld a,(de)		; $4036
	or $80			; $4037
	ld (de),a		; $4039

	ld a,$80		; $403a
	ld (wcca2),a		; $403c

	call interactionInitGraphics		; $403f

	ld e,Interaction.angle		; $4042
	ld a,$04		; $4044
	ld (de),a		; $4046
	ld bc,$0614		; $4047
	call objectSetCollideRadii		; $404a

	ld l,Interaction.subid		; $404d
	ld a,(hl)		; $404f
	cp $01			; $4050
	jr nz,++		; $4052

	; Set bit 7 of subid if the chest game should be run
	ld a,(wBoughtShopItems1)		; $4054
	and $0f			; $4057
	cp $0f			; $4059
	jr nz,++		; $405b
	set 7,(hl)		; $405d
++
.ifdef ROM_AGES
	ld e,Interaction.subid		; $405f
	ld a,(de)		; $4061
	or a			; $4062
	ld a,$03		; $4063
	call z,interactionSetAnimation		; $4065
.else
	ld a,$53		; $47f9
	call checkTreasureObtained		; $47fb
	jr nc,+			; $47fe
	ld e,$7e		; $4800
	ld a,$01		; $4802
	ld (de),a		; $4804
+
.endif

	ld a,>TX_0e00		; $4068
	call interactionSetHighTextIndex		; $406a
	ld e,Interaction.pressedAButton		; $406d
	jp objectAddToAButtonSensitiveObjectList		; $406f


; State 1: waiting for Link to do something
_shopkeeperState1:
	call retIfTextIsActive		; $4072

	ld e,Interaction.pressedAButton		; $4075
	ld a,(de)		; $4077
	or a			; $4078
	jr nz,@pressedA	; $4079

.ifdef ROM_SEASONS
	ld e,Interaction.subid		; $4818
	ld a,(de)		; $481a
	or a			; $481b
	jr nz,+			; $481c
	ld e,Interaction.var3d		; $481e
	ld a,(de)		; $4820
	or a			; $4821
	jr nz,+			; $4822
	ld bc,$3008		; $4824
	call objectSetCollideRadii		; $4827
	call objectCheckCollidedWithLink		; $482a
	jr nc,+			; $482d
	ld e,Interaction.state		; $482f
	ld a,$03		; $4831
	ld (de),a		; $4833
	ret			; $4834
+
.endif

	; Check Link's position to see if he's trying to steal something
	ld e,Interaction.subid		; $407b
	ld a,(de)		; $407d
	or a			; $407e
	ld hl,w1Link.xh		; $407f
	jr nz,+			; $4082

.ifdef ROM_SEASONS
	ld e,Interaction.xh		; $483e
	ld a,(de)		; $4840
	cp (hl)			; $4841
	jr nc,@goToState6	; $4842
.endif

+
	ld l,<w1Link.yh		; $4084
	ld e,Interaction.subid		; $4086
	ld a,(de)		; $4088
	and $01			; $4089
	ld c,$69		; $408b
	ld b,(hl)		; $408d
	ld a,$69		; $408e
	jr z,+			; $4090
	ld b,$27		; $4092
	ld c,(hl)		; $4094
	ld a,$27		; $4095
+
	ld l,a			; $4097
	ld a,c			; $4098
	cp b			; $4099
	jr nc,@setNormalCollisionRadii	; $409a
	ld a,(wLinkGrabState)		; $409c
	or a			; $409f
	jr z,@setNormalCollisionRadii	; $40a0

	; He's trying to steal something, stop him!
	ld a,$81		; $40a2
	ld (wDisabledObjects),a		; $40a4
	ld a,l			; $40a7
	ld hl,w1Link.yh		; $40a8
	ld (hl),a		; $40ab

	ld bc,$0606		; $40ac
	call objectSetCollideRadii		; $40af

	ld e,Interaction.subid		; $40b2
	ld a,(de)		; $40b4
	ld hl,_shopkeeperTheftPreventionScriptTable		; $40b5
	rst_addDoubleIndex			; $40b8
	ldi a,(hl)		; $40b9
	ld h,(hl)		; $40ba
	ld l,a			; $40bb
	jp _shopkeeperLoadScript		; $40bc

@setNormalCollisionRadii:
	ld bc,$0614		; $40bf
	jp objectSetCollideRadii		; $40c2

@pressedA:
	xor a			; $40c5
	ld (de),a		; $40c6
	call objectRemoveFromAButtonSensitiveObjectList		; $40c7
	call _shopkeeperTurnToFaceLink		; $40ca

	ld a,$81		; $40cd
	ld (wDisabledObjects),a		; $40cf

	ld e,Interaction.state		; $40d2
	ld a,$02		; $40d4
	ld (de),a		; $40d6
	ret			; $40d7

.ifdef ROM_SEASONS
@goToState6:
	ld a,$06		; $4898
	call objectSetCollideRadius		; $489a
	ld l,Interaction.state		; $489d
	ld (hl),$06		; $489f
	ld l,Interaction.var3d		; $48a1
	ld (hl),d		; $48a3
	ret			; $48a4
.endif


; State 6: ?
_shopkeeperState6:
	ld e,Interaction.pressedAButton		; $40d8
	ld a,(de)		; $40da
	or a			; $40db
	jr nz,@pressedA		; $40dc

	ld hl,w1Link.xh		; $40de
	ld e,Interaction.xh		; $40e1
	ld a,(de)		; $40e3
	cp (hl)			; $40e4
	ret nc			; $40e5
	jp _shopkeeperGotoState1		; $40e6

@pressedA:
	xor a			; $40e9
	ld (de),a		; $40ea
	call objectRemoveFromAButtonSensitiveObjectList		; $40eb

	ld a,$81		; $40ee
	ld (wDisabledObjects),a		; $40f0

	ld e,Interaction.state		; $40f3
	ld a,$02		; $40f5
	ld (de),a		; $40f7
	jp _shopkeeperTurnToFaceLink		; $40f8


; State 2: talking to Link (this code still runs even while text is up)
_shopkeeperState2:
	ld e,Interaction.subid		; $40fb
	ld a,(de)		; $40fd
	and $80			; $40fe
	jr nz,_shopkeeperPromptChestGame	; $4100

.ifdef ROM_SEASONS
	ld a,TREASURE_SWORD		; $48cf
	call checkTreasureObtained		; $48d1
	ld hl,shopkeeperScript_notOpenYet		; $48d4
	jr nc,_shopkeeperLoadScript	; $48d7
.endif

	ld a,(wLinkGrabState)		; $4102
	or a			; $4105
	jr z,@holdingNothing	; $4106

	; Check what Link is holding
	ld a,(w1Link.relatedObj2+1)		; $4108
	ld h,a			; $410b
	ld e,Interaction.var3b		; $410c
	ld (de),a		; $410e

	ld l,Interaction.subid		; $410f
	ld a,(hl)		; $4111
	ld e,Interaction.var37		; $4112
	ld (de),a		; $4114

	call _shopkeeperGetItemPrice		; $4115

	ld e,Interaction.var37		; $4118
	ld a,(de)		; $411a
	call _shopkeeperCheckLinkHasItemAlready		; $411b
	ld hl,shopkeeperScript_purchaseItem		; $411e
	jp _shopkeeperLoadScript		; $4121

@holdingNothing:
	call _shopkeeperCheckAllItemsBought		; $4124
	jr nz,_shopkeeperLoadScript	; $4127

	ld e,Interaction.subid		; $4129
	ld a,(de)		; $412b
	cp $02			; $412c
	ld hl,shopkeeperScript_lynnaShopWelcome		; $412e
	jr nz,_shopkeeperLoadScript	; $4131
	ld hl,shopkeeperScript_advanceShopWelcome		; $4133


_shopkeeperLoadScript:
	ld e,Interaction.state		; $4136
	ld a,$04		; $4138
	ld (de),a		; $413a
	jp interactionSetScript		; $413b


_shopkeeperPromptChestGame:
	ld a,$0c		; $413e
	call _shopkeeperGetItemPrice		; $4140
	ld hl,shopkeeperChestGameScript		; $4143
	jr _shopkeeperLoadScript		; $4146


; State 3: Seasons - block Link access
_shopkeeperState3:
.ifdef ROM_SEASONS
	ld hl,shopkeeperScript_blockLinkAccess		; $491f
	jp _shopkeeperLoadScript		; $4922
.endif


; State 4: Running a script (prompting whether to buy, playing chest game, etc...)
_shopkeeperState4:
	ld e,Interaction.subid		; $4148
	ld a,(de)		; $414a
	and $80			; $414b
	ld a,$0c		; $414d
	call nz,_shopkeeperGetItemPrice		; $414f
	call interactionRunScript		; $4152
	ret nc			; $4155

	; Script over

	xor a			; $4156
	ld (wDisabledObjects),a		; $4157

	ld e,Interaction.var3f		; $415a
	ld a,(de)		; $415c
	or a			; $415d
	jr z,@notRing	; $415e

	ld c,a			; $4160
	xor a			; $4161
	ld (de),a		; $4162
	call getRandomRingOfGivenTier		; $4163
	ld b,c			; $4166
	ld c,$00		; $4167
	call giveRingToLink		; $4169

	ld a,$01		; $416c
	ld (wDisabledObjects),a		; $416e
	jr _shopkeeperGotoState1		; $4171

@notRing:
	; Check var3a to see what the response from the script was (purchase succeeded or
	; failed?)
	ld e,Interaction.var3a		; $4173
	ld a,(de)		; $4175
	or a			; $4176
	jr z,_shopkeeperGotoState1	; $4177

	; Set the item to state 4 to put it back (purchase failed)
	inc a			; $4179
	ld c,$04		; $417a
	jr z,@setItemState	; $417c

	; Set the item to state 3 to obtain it
	ld c,$03		; $417e
	ld a,$81		; $4180
	ld (wDisabledObjects),a		; $4182

@setItemState:
	xor a			; $4185
	ld (de),a ; [var3a] = 0

	; Set the held item's state to 'c'.
	ld e,Interaction.var3b		; $4187
	ld a,(de)		; $4189
	ld h,a			; $418a
	ld l,Interaction.state		; $418b
	ld (hl),c		; $418d
	call dropLinkHeldItem		; $418e


_shopkeeperGotoState1:
	ld e,Interaction.state		; $4191
	ld a,$01		; $4193
	ld (de),a		; $4195

.ifdef ROM_AGES
	ld bc,$0614		; $4196
	call objectSetCollideRadii		; $4199

	ld e,Interaction.subid		; $419c
	ld a,(de)		; $419e
	or a			; $419f
	ld a,$03		; $41a0
	jr z,+			; $41a2
.else
	ld hl,w1Link.xh		; $4973
	ld e,Interaction.xh		; $4976
	ld a,(de)		; $4978
	cp (hl)			; $4979
	jr nc,+			; $497a

	ld bc,$0614		; $497c
	call objectSetCollideRadii		; $497f

	jr ++			; $4982
+
	ld a,$06		; $4984
	call objectSetCollideRadius		; $4986
++
.endif
	ld a,$01		; $41a4
+
	call interactionSetAnimation		; $41a6
	ld e,Interaction.pressedAButton		; $41a9
	jp objectAddToAButtonSensitiveObjectList		; $41ab


; Playing the chest-choosing minigame. The script tends to change the state.
; It jumps to state 5, substate 0 after relinquishing control for Link to pick a chest.
; It jumps to state 5, substate 2 after relinquishing control for Link to pick a chest.
_shopkeeperState5:
	ld e,Interaction.state2		; $41ae
	ld a,(de)		; $41b0
	rst_jumpTable			; $41b1
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,$01		; $41ba
	ld (de),a		; $41bc

	; Decide which chest is the correct one
	call getRandomNumber		; $41bd
	and $01			; $41c0
	ld e,Interaction.var39		; $41c2
	ld (de),a		; $41c4

	call _shopkeeperCloseOpenedChest		; $41c5
	xor a			; $41c8
	ld (wcca2),a		; $41c9
	ld e,Interaction.var3f		; $41cc
	ld (de),a		; $41ce
	ret			; $41cf

@substate1:
	ld e,Interaction.pressedAButton		; $41d0
	ld a,(de)		; $41d2
	or a			; $41d3
	jr z,++			; $41d4

	; Talked to shopkeep
	xor a			; $41d6
	ld (de),a		; $41d7
	ld hl,shopkeeperScript_talkDuringChestGame		; $41d8
	jp _shopkeeperLoadScript		; $41db
++
	; Check if Link's opened a chest
	ld a,(wcca2)		; $41de
	or a			; $41e1
	ret z			; $41e2

	ld e,Interaction.state2		; $41e3
	xor a			; $41e5
	ld (de),a		; $41e6

	ld a,TILEINDEX_CHEST		; $41e7
	call findTileInRoom		; $41e9
	ld a,(wcca2)		; $41ec
	sub l			; $41ef
	rlca			; $41f0
	xor $01			; $41f1
	and $01			; $41f3
	ld h,d			; $41f5
	ld l,Interaction.var39		; $41f6
	xor (hl)		; $41f8

	ld l,Interaction.var3c		; $41f9
	jr nz,@correctChest	; $41fb

	; Wrong chest
	ld (hl),a		; $41fd
	ld hl,shopkeeperScript_openedWrongChest		; $41fe
	jp _shopkeeperLoadScript		; $4201

@correctChest:
	; Increment round (var3c)
	add (hl)		; $4204
	ld (hl),a		; $4205

	; Spawn a rupee "treasure" that doesn't actually give you anything?
	call getFreeInteractionSlot		; $4206
	ld (hl),INTERACID_TREASURE		; $4209
	ld l,Interaction.subid		; $420b
	ld (hl),TREASURE_RUPEES		; $420d
	inc l			; $420f
	ld (hl),$08		; $4210
	ld l,Interaction.var31		; $4212
	ld (hl),$03		; $4214
	ld l,Interaction.var39		; $4216
	ld (hl),$01		; $4218

	; Determine position for rupee treasure
	ld e,Interaction.var39		; $421a
	ld a,(de)		; $421c
	ld bc,_shopkeeperChestXPositions		; $421d
	call addAToBc		; $4220
	ld l,Interaction.yh		; $4223
	ld (hl),$20		; $4225
	ld l,Interaction.xh		; $4227
	ld a,(bc)		; $4229
	ld (hl),a		; $422a

	ld hl,shopkeeperScript_openedCorrectChest		; $422b
	jp _shopkeeperLoadScript		; $422e

@substate2:
	; Close the chest that the shopkeeper is facing toward.
	ld e,Interaction.angle		; $4231
	ld a,(de)		; $4233
	swap a			; $4234
	and $01			; $4236
	ld h,d			; $4238
	ld l,Interaction.var39		; $4239
	xor (hl)		; $423b
	jr nz,@substate3	; $423c

	call _shopkeeperCloseOpenedChest		; $423e
	ld e,Interaction.state2		; $4241
	ld a,$03		; $4243
	ld (de),a		; $4245

@substate3:
	call interactionRunScript		; $4246
	ret nc			; $4249

	ld e,Interaction.state2		; $424a
	xor a			; $424c
	ld (de),a		; $424d

;;
; @param	a	Item index?
; @addr{424e}
_shopkeeperGetItemPrice:
	ld hl,_shopItemPrices		; $424e
	rst_addAToHl			; $4251
	ld a,(hl)		; $4252
	call cpRupeeValue		; $4253
	ld (wShopHaveEnoughRupees),a		; $4256
	ld ($cbad),a		; $4259
	ld hl,wTextNumberSubstitution		; $425c
	ld (hl),c		; $425f
	inc l			; $4260
	ld (hl),b		; $4261
	ret			; $4262

;;
; @addr{4263}
_shopkeeperCloseOpenedChest:
	ld a,(wcca2)		; $4263
	bit 7,a			; $4266
	ld c,a			; $4268
	ld a,TILEINDEX_CHEST		; $4269
	jp z,setTile		; $426b
	ret			; $426e

;;
; Sets var38 to nonzero if Link already has this item, or already has the maximum amount
; he can carry.
;
; @param	a	Item index
; @addr{426f}
_shopkeeperCheckLinkHasItemAlready:
	ld b,a			; $426f
	xor a			; $4270
	ld e,Interaction.var38		; $4271
	ld (de),a		; $4273
	ld e,Interaction.subid		; $4274
	ld a,(de)		; $4276
	ld e,Interaction.var38		; $4277
	or a			; $4279
	ret nz			; $427a

	ld h,>wc600Block		; $427b
	ld a,b			; $427d
	cp $13			; $427e
	ret z			; $4280

	cp $03			; $4281
	jr z,@shield	; $4283
	cp $11			; $4285
	jr z,@shield	; $4287
	cp $12			; $4289
	jr z,@shield	; $428b

	cp $0d			; $428d
	jr z,@flute	; $428f

	ld l,<wNumBombs		; $4291
	cp $04			; $4293
	jr z,+			; $4295

	ld l,<wLinkHealth		; $4297
+
	ldi a,(hl)		; $4299
	cp (hl)			; $429a
	ret nz			; $429b

@cantSell:
	ld a,$01		; $429c
	ld (de),a		; $429e
	ret			; $429f

@shield:
	ld a,TREASURE_SHIELD		; $42a0
	jr @checkObtained		; $42a2

@flute:
	ld a,TREASURE_FLUTE		; $42a4

@checkObtained:
	call checkTreasureObtained		; $42a6
	ld e,Interaction.var38		; $42a9
	ret nc			; $42ab
	jr @cantSell		; $42ac

;;
; @param[out]	hl	Script to run if no shop items exist
; @param[out]	zflag	Set if at least one shop item exists
; @addr{42ae}
_shopkeeperCheckAllItemsBought:
	ldhl FIRST_DYNAMIC_INTERACTION_INDEX, Interaction.enabled		; $42ae
---
	ld l,Interaction.enabled		; $42b1
	ldi a,(hl)		; $42b3
	or a			; $42b4
	jr z,@next		; $42b5
	ld a,(hl)		; $42b7
	cp INTERACID_SHOP_ITEM			; $42b8
	ret z			; $42ba
@next:
	inc h			; $42bb
	ld a,h			; $42bc
	cp LAST_INTERACTION_INDEX+1			; $42bd
	jr c,---		; $42bf

	ld hl,shopkeeperScript_boughtEverything		; $42c1
	or d			; $42c4
	ret			; $42c5

_shopkeeperTurnToFaceLink:
	call objectGetAngleTowardLink		; $42c6
	ld e,Interaction.angle		; $42c9
	ld (de),a		; $42cb
	call convertAngleDeToDirection		; $42cc
	dec e			; $42cf
	ld (de),a		; $42d0
	jp interactionSetAnimation		; $42d1


_shopkeeperTheftPreventionScriptTable:
.ifdef ROM_AGES
	.dw shopkeeperSubid0Script_stopLink
.else
	.dw shopkeeperSubid2Script_stopLink
.endif
	.dw shopkeeperSubid1Script_stopLink
	.dw shopkeeperSubid2Script_stopLink


; X positions of the chests in the chest minigame (used for spawning rupee "prizes")
_shopkeeperChestXPositions:
	.db $78, $58


; ==============================================================================
; INTERACID_SHOP_ITEM
;
; Variables:
;   var30/31: Y/X position where the item rests in the selection area
; ==============================================================================
interactionCode47:
	ld e,Interaction.state		; $42dc
	ld a,(de)		; $42de
	rst_jumpTable			; $42df
	.dw _shopItemState0
	.dw objectAddToGrabbableObjectBuffer
	.dw _shopItemState2
	.dw _shopItemState3
	.dw _shopItemState4
	.dw _shopItemState5


_shopItemState0:
	; Check that we're actually in a shop
	ld a,(wInShop)		; $42ec
	and $02			; $42ef
	ret z			; $42f1

	ld a,$01		; $42f2
	ld (de),a		; $42f4

	; If this is the ring box upgrade, check whether to change it to the L3 box
	ld e,Interaction.subid		; $42f5
	ld a,(de)		; $42f7
	cp $00			; $42f8
	jr nz,++		; $42fa

	ld a,TREASURE_RING_BOX		; $42fc
	call checkTreasureObtained		; $42fe
	jr nc,++		; $4301

	ld a,(wRingBoxLevel)		; $4303
	dec a			; $4306
	jr z,++		; $4307
	ld a,$14		; $4309
	ld (de),a		; $430b
++
	; If this is 10 bombs, delete self if Link doesn't have bombs
	ld a,(de)		; $430c
	cp $04			; $430d
	jr nz,++		; $430f
	ld a,TREASURE_BOMBS		; $4311
	call checkTreasureObtained		; $4313
	jp nc,_shopItemPopStackAndDeleteSelf		; $4316
	jr @checkFlutePurchasable		; $4319
++
	; If this is the shield, check whether to replace it with a gasha seed (linked)
	cp $03			; $431b
	jr nz,@checkFlutePurchasable	; $431d
	call checkIsLinkedGame		; $431f
	jr z,@checkFlutePurchasable	; $4322

	; Replace with gasha seed
	ld a,$13		; $4324
	ld (de),a		; $4326

@checkFlutePurchasable:
	; Decide whether the flute is purchasable (update bit 3 of wBoughtShopItems2)
	ld a,TREASURE_FLUTE		; $4327
	call checkTreasureObtained		; $4329
	jr c,@fluteNotPurchasable	; $432c

	ld a,GLOBALFLAG_CAN_BUY_FLUTE		; $432e
	call checkGlobalFlag		; $4330
	jr z,@fluteNotPurchasable	; $4333

	; Flute purchasable
	ld c,$08		; $4335
	jr ++			; $4337

@fluteNotPurchasable:
	ld c,$00		; $4339
++
	ld a,(wBoughtShopItems2)		; $433b
	and $f7			; $433e
	or c			; $4340
	ld (wBoughtShopItems2),a		; $4341

	; Update bits in wBoughtShopItems2 based on if Link has bombchus?
	ld a,TREASURE_BOMBCHUS		; $4344
	call checkTreasureObtained		; $4346
	ld c,$10		; $4349
	jr c,+			; $434b
	ld c,$20		; $434d
+
	ld a,(wBoughtShopItems2)		; $434f
	and $cf			; $4352
	or c			; $4354
	ld (wBoughtShopItems2),a		; $4355

	; Check whether the item can be sold by reading from "_shopItemReplacementTable".
	; This checks for particular bits in memory to see if an item is purchasable. If
	; it's not, it may be replaced with a different item.
@checkReplaceItem:
	ld e,Interaction.subid		; $4358
	ld a,(de)		; $435a
	add a			; $435b
	ld hl,_shopItemReplacementTable		; $435c
	rst_addDoubleIndex			; $435f

	; Check the bit in memory stating if the item should be replaced with another
	ldi a,(hl)		; $4360
	ld c,a			; $4361
	ld b,>wc600Block		; $4362
	ld a,(bc)		; $4364
	and (hl)		; $4365
	jr z,@itemOK		; $4366

	; The item should be replaced. Check if the next byte is a valid item index.
	inc hl			; $4368
	ldi a,(hl)		; $4369
	bit 7,a			; $436a
	jr nz,_shopItemPopStackAndDeleteSelf	; $436c

	; Try this item. Need to run the above checks again.
	ld (de),a		; $436e
	ld e,Interaction.xh		; $436f
	ld a,(de)		; $4371
	add (hl)		; $4372
	ld (de),a		; $4373
	jr @checkReplaceItem		; $4374

@itemOK:
	call interactionInitGraphics		; $4376
	ld a,$07		; $4379
	call objectSetCollideRadius		; $437b

	ld l,Interaction.var30		; $437e
	ld e,Interaction.yh		; $4380
	ld a,(de)		; $4382
	ldi (hl),a		; $4383
	ld e,Interaction.xh		; $4384
	ld a,(de)		; $4386
	ldi (hl),a		; $4387

	call objectSetVisible83		; $4388
	jr _shopItemUpdateRupeeDisplay		; $438b

_shopItemState5:
	call retIfTextIsActive		; $438d
	xor a			; $4390
	ld (wDisabledObjects),a		; $4391
	ld (wMenuDisabled),a		; $4394


;;
; The fact that this pops the stack means that it will return one level higher than it's
; supposed to? This ultimately isn't a big deal, it just means that other interactions
; won't be updated until next frame, but it's probably unintentional...
; @addr{4397}
_shopItemPopStackAndDeleteSelf:
	pop af			; $4397
	jp interactionDelete		; $4398


; State 2: item picked up by Link
_shopItemState2:
	ld e,Interaction.state2		; $439b
	ld a,(de)		; $439d
	rst_jumpTable			; $439e
	.dw @substate0
	.dw @substate1

@substate0:
	ld a,$01		; $43a3
	ld (de),a		; $43a5

	; Item should be fully lifted instantly
	ld a,$08		; $43a6
	ld (wLinkGrabState2),a		; $43a8

	call objectSetVisible80		; $43ab
	jr _shopItemClearRupeeDisplay		; $43ae

@substate1:
	call _shopItemCheckGrabbed		; $43b0
	ret nz			; $43b3

	; Fall through to state 4 if Link pressed the button near the selection area


; State 4: Return to selection area
_shopItemState4:
	; Set Y/X to selection area
	ld h,d			; $43b4
	ld e,Interaction.yh		; $43b5
	ld l,Interaction.var30		; $43b7
	ldi a,(hl)		; $43b9
	ld (de),a		; $43ba
	ld e,Interaction.xh		; $43bb
	ld a,(hl)		; $43bd
	ld (de),a		; $43be

	ld l,Interaction.zh		; $43bf
	ld (hl),$00		; $43c1

	ld l,Interaction.state		; $43c3
	ld (hl),$01		; $43c5

	call _shopItemUpdateRupeeDisplay		; $43c7
	call objectSetVisible83		; $43ca
	jp dropLinkHeldItem		; $43cd

;;
; Clears the tiles in w3VramLayout corresponding to item price, and sets bit 2 of wInShop
; in order to request a tilemap update.
;
; @addr{43d0}
_shopItemClearRupeeDisplay:
	call _shopItemGetTilesForRupeeDisplay		; $43d0
	ret nc			; $43d3

	; Replace the tiles generated by above function call with spaces
	push hl			; $43d4
	ld a,$03		; $43d5
	rst_addAToHl			; $43d7
	ld a,$20		; $43d8
	ldi (hl),a		; $43da
	inc l			; $43db
	ldi (hl),a		; $43dc
	inc l			; $43dd
	ldi (hl),a		; $43de
	pop hl			; $43df
	jr ++		; $43e0

;;
; Updates the tiles in w3VramLayout corresponding to item price, and sets bit 2 of wInShop
; in order to request a tilemap update.
;
; @addr{43e2}
_shopItemUpdateRupeeDisplay:
	call _shopItemGetTilesForRupeeDisplay		; $43e2
	ret nc			; $43e5
++
	ld a,($ff00+R_SVBK)	; $43e6
	push af			; $43e8
	ld a,:w3VramTiles		; $43e9
	ld ($ff00+R_SVBK),a	; $43eb
	push de			; $43ed
	ldi a,(hl)		; $43ee
	ld e,a			; $43ef
	ldi a,(hl)		; $43f0
	ld d,a			; $43f1
	ldi a,(hl)		; $43f2
	ld b,a			; $43f3

@nextTile:
	ldi a,(hl)		; $43f4
	ld (de),a		; $43f5
	set 2,d			; $43f6
	ldi a,(hl)		; $43f8
	ld (de),a		; $43f9
	res 2,d			; $43fa
	inc de			; $43fc
	dec b			; $43fd
	jr nz,@nextTile	; $43fe

	pop de			; $4400
	pop af			; $4401
	ld ($ff00+R_SVBK),a	; $4402
	ld hl,wInShop		; $4404
	set 2,(hl)		; $4407
	ret			; $4409


; State 3: Link obtains the item (he just bought it, the shopkeeper set the state to this)
_shopItemState3:
	; Take rupees
	ld e,Interaction.subid		; $440a
	ld a,(de)		; $440c
	ld hl,_shopItemPrices		; $440d
	rst_addAToHl			; $4410
	ldi a,(hl)		; $4411
	call removeRupeeValue		; $4412

	; Determine what the treasure is, give it to him
	ld e,Interaction.subid		; $4415
	ld a,(de)		; $4417
	ld hl,shopItemTreasureToGive		; $4418
	rst_addDoubleIndex			; $441b
	ldi a,(hl)		; $441c
	ld c,(hl)		; $441d
	cp $00			; $441e
	jr nz,+			; $4420
	call getRandomRingOfGivenTier		; $4422
+
	call giveTreasure		; $4425

	ld e,Interaction.state		; $4428
	ld a,$05		; $442a
	ld (de),a		; $442c

	ld a,LINK_STATE_04		; $442d
	ld (wLinkForceState),a		; $442f
	ld a,$01		; $4432
	ld (wcc50),a		; $4434

	; Show text for the item
	ld e,Interaction.subid		; $4437
	ld a,(de)		; $4439
	ld hl,_shopItemTextTable		; $443a
	rst_addAToHl			; $443d
	ld a,(hl)		; $443e
	ld c,a			; $443f
	or a			; $4440
	ld b,>TX_0000		; $4441
	jp nz,showText		; $4443
	ret			; $4446

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
; @addr{4447}
_shopItemGetTilesForRupeeDisplay:
	ld e,Interaction.subid		; $4447
	ld a,(de)		; $4449
	ld c,a			; $444a
	ld hl,@itemPricePositions		; $444b
	rst_addDoubleIndex			; $444e
	ldi a,(hl)		; $444f
	cp $ff			; $4450
	ret z			; $4452

	push de			; $4453
	ld e,a			; $4454
	ld d,(hl)		; $4455

	ld a,c			; $4456
	ld hl,_shopItemPrices		; $4457
	rst_addAToHl			; $445a
	ld a,(hl)		; $445b
	call getRupeeValue		; $445c

	ld hl,wTmpcec0		; $445f
	ld (hl),e		; $4462
	inc l			; $4463
	ld (hl),d		; $4464
	inc l			; $4465

	ld e,$06 ; Attribute value to use
	ld d,$30 ; Tile index "base" (digit 0 is tile $30)
	ld a,$02 ; Number of tiles to write
	ldi (hl),a		; $446c
	ld a,b			; $446d
	or a			; $446e
	jr z,+			; $446f

	; If this is a 3 digit number, go back, increment the size, and draw the first
	; digit.
	dec l			; $4471
	inc (hl)		; $4472
	inc l			; $4473
	call @drawDigit		; $4474
+
	ld a,c			; $4477
	swap a			; $4478
	call @drawDigit		; $447a

	ld a,c			; $447d
	call @drawDigit		; $447e

	ld hl,wTmpcec0		; $4481
	pop de			; $4484
	scf			; $4485
	ret			; $4486

@drawDigit:
	and $0f			; $4487
	add d			; $4489
	ldi (hl),a		; $448a
	ld (hl),e		; $448b
	inc l			; $448c
	ret			; $448d

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
	.dw w3VramTiles+$66
	.dw w3VramTiles+$6e

_shopItemPrices:
	/* $00 */ .db RUPEEVAL_300
	/* $01 */ .db RUPEEVAL_010
	/* $02 */ .db RUPEEVAL_300
	/* $03 */ .db RUPEEVAL_030
	/* $04 */ .db RUPEEVAL_020
	/* $05 */ .db RUPEEVAL_300
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
	/* $14 */ .db RUPEEVAL_300
	/* $15 */ .db RUPEEVAL_500

;;
; @param[out]	zflag	z if Link should grab or release the item
; @addr{44d0}
_shopItemCheckGrabbed:
	ld a,(wGameKeysJustPressed)		; $44d0
	and (BTN_A|BTN_B)			; $44d3
	jr z,@dontGrab		; $44d5

	; Check Link's close enough to the selection area (horizontally)
	ld e,Interaction.var31		; $44d7
	ld a,(de)		; $44d9
	sub $0d			; $44da
	ld b,a			; $44dc
	add $1a			; $44dd
	ld hl,w1Link.xh		; $44df
	cp (hl)			; $44e2
	jr c,@dontGrab		; $44e3

	ld a,b			; $44e5
	cp (hl)			; $44e6
	jr nc,@dontGrab		; $44e7

	; Check Link's close enough to the selection area (vertically)
	ld l,<w1Link.yh		; $44e9
	ld a,(hl)		; $44eb
	cp $3d			; $44ec
	jr nc,@dontGrab		; $44ee

	; Check that Link's facing the selection area (DIR_UP)
	ld l,<w1Link.direction		; $44f0
	ld a,(hl)		; $44f2
	or a			; $44f3
	ret			; $44f4

@dontGrab:
	or d			; $44f5
	ret			; $44f6


; These are the treasures that Link receives when he buys a shop item.
;   b0: Treasure index to give (if $00, it's a random ring)
;   b1: Treasure parameter (if it's random ring, this is the tier of the ring)
shopItemTreasureToGive:
	/* $00 */ .db  TREASURE_RING_BOX      $02
	/* $01 */ .db  TREASURE_HEART_REFILL  $0c
	/* $02 */ .db  TREASURE_GASHA_SEED    $01
	/* $03 */ .db  TREASURE_SHIELD        $01
	/* $04 */ .db  TREASURE_BOMBS         $10
	/* $05 */ .db  $00                    $03
	/* $06 */ .db  TREASURE_GASHA_SEED    $01
	/* $07 */ .db  TREASURE_POTION        $01
	/* $08 */ .db  TREASURE_GASHA_SEED    $01
	/* $09 */ .db  TREASURE_POTION        $01
	/* $0a */ .db  TREASURE_GASHA_SEED    $01
	/* $0b */ .db  TREASURE_BOMBCHUS      $05
	/* $0c */ .db  $00                    $00
	/* $0d */ .db  TREASURE_FLUTE         SPECIALOBJECTID_DIMITRI
	/* $0e */ .db  TREASURE_GASHA_SEED    $01
	/* $0f */ .db  TREASURE_RING          GBA_TIME_RING
	/* $10 */ .db  $00                    $01
	/* $11 */ .db  TREASURE_SHIELD        $02
	/* $12 */ .db  TREASURE_SHIELD        $03
	/* $13 */ .db  TREASURE_GASHA_SEED    $01
	/* $14 */ .db  TREASURE_RING_BOX      $03
	/* $15 */ .db  TREASURE_HEART_PIECE   $01


; This lists conditions where a shop item may be replaced with something else.
;   b0: Low byte of an address in $c6xx block
;   b1: Bitmask to check at that address. If result is 0, the item can be sold.
;       If the result is nonzero, a different item is sold instead based on b2.
;   b2: Item to sell if the first one is unavailable (or $ff to sell nothing)
;   b3: Value to add to x position if the first item was sold out
_shopItemReplacementTable:
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
	/* $14 */ .db <wBoughtShopItems1  $01 $ff $00
	/* $15 */ .db <wBoughtShopItems2  $40 $05 $00


; Text to show upon buying a shop item (or $00 for no text)
_shopItemTextTable:
	/* $00 */ .db <TX_0058
	/* $01 */ .db <TX_004c
	/* $02 */ .db <TX_004b
	/* $03 */ .db <TX_001f
	/* $04 */ .db <TX_004d
	/* $05 */ .db <TX_0054
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
	/* $14 */ .db <TX_0059
	/* $15 */ .db <TX_0017


; ==============================================================================
; INTERACID_INTRO_SPRITES_1
; ==============================================================================
interactionCode4a:
	ld e,Interaction.state		; $4591
	ld a,(de)		; $4593
	rst_jumpTable			; $4594
	.dw @state0
	.dw _introSpritesState1

@state0:
	call _introSpriteIncStateAndLoadGraphics		; $4599
	ld e,$42		; $459c
	ld a,(de)		; $459e
	rst_jumpTable			; $459f
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw _introSpriteIncStateAndLoadGraphics
	.dw _introSpriteIncStateAndLoadGraphics
	.dw @initSubid07
	.dw objectSetVisible82
	.dw @initSubid09
	.dw @initSubid0a


; Triforce pieces
@initSubid00:
@initSubid01:
@initSubid02:
	call getFreeInteractionSlot		; $45b6
	jr nz,++		; $45b9

	; Create the "glow" behind the triforce
	ld (hl),INTERACID_INTRO_SPRITES_1		; $45bb
	inc l			; $45bd
	ld (hl),$04		; $45be
	inc l			; $45c0
	ld e,Interaction.subid		; $45c1
	ld a,(de)		; $45c3
	inc a			; $45c4
	ld (hl),a		; $45c5
	call _introSpriteSetChildRelatedObject1ToSelf		; $45c6
++
	jp objectSetVisible82		; $45c9

@initSubid03:
@initSubid07:
@initSubid0a:
	ld e,Interaction.var03		; $45cc
	ld a,(de)		; $45ce
	add a			; $45cf
	add a			; $45d0
	ld h,d			; $45d1
	ld l,Interaction.animCounter		; $45d2
	add (hl)		; $45d4
	ld (hl),a		; $45d5

	call interactionSetAlwaysUpdateBit		; $45d6
	call _introSpriteFunc_461a		; $45d9
	jp objectSetVisible80		; $45dc

@initSubid09:
	ld e,Interaction.var03		; $45df
	ld a,(de)		; $45e1
	ld hl,@data		; $45e2
	rst_addDoubleIndex			; $45e5
	ldi a,(hl)		; $45e6
	ld e,Interaction.yh		; $45e7
	ld (de),a		; $45e9
	inc e			; $45ea
	inc e			; $45eb
	ld a,(hl)		; $45ec
	ld (de),a		; $45ed
	ld b,$03		; $45ee
--
	call getFreeInteractionSlot		; $45f0
	jr nz,++		; $45f3

	ld (hl),INTERACID_INTRO_SPRITES_1		; $45f5
	inc l			; $45f7
	ld (hl),$0a		; $45f8
	inc l			; $45fa
	ld (hl),b		; $45fb
	dec (hl)		; $45fc
	call _introSpriteSetChildRelatedObject1ToSelf		; $45fd
	dec b			; $4600
	jr nz,--		; $4601
++
	jp objectSetVisible82		; $4603

@data:
	.db $40 $78
	.db $40 $48
	.db $18 $60

@initSubid04:
	call objectSetVisible83		; $460c
	xor $80			; $460f
	ld (de),a		; $4611
	ret			; $4612

;;
; @addr{4613}
_introSpriteIncStateAndLoadGraphics:
	ld h,d			; $4613
	ld l,Interaction.state		; $4614
	inc (hl)		; $4616
	jp interactionInitGraphics		; $4617

;;
; Sets up X and Y positions with some slight random variance?
; @addr{461a}
_introSpriteFunc_461a:
	call objectGetRelatedObject1Var		; $461a
	call objectTakePosition		; $461d
	push bc			; $4620
	ld e,Interaction.subid		; $4621
	ld a,(de)		; $4623
	ld hl,@data_4660		; $4624
	cp $03			; $4627
	jr z,@label_09_043	; $4629
	cp $0a			; $462b
	jr z,@label_09_043	; $462d

	ld hl,@data_4666		; $462f
	ld e,Interaction.counter2		; $4632
	ld a,(de)		; $4634
	inc a			; $4635
	ld (de),a		; $4636
	and $03			; $4637
	ld c,a			; $4639
	add a			; $463a
	add c			; $463b
	rst_addDoubleIndex			; $463c

@label_09_043:
	ld e,Interaction.var03		; $463d
	ld a,(de)		; $463f
	rst_addDoubleIndex			; $4640

	ldi a,(hl)		; $4641
	call @addRandomVariance		; $4642
	ld b,a			; $4645
	ld e,Interaction.yh		; $4646
	ld a,(de)		; $4648
	add b			; $4649
	ld (de),a		; $464a

	ld a,(hl)		; $464b
	call @addRandomVariance		; $464c
	ld h,d			; $464f
	ld l,Interaction.xh		; $4650
	add (hl)		; $4652
	ld (hl),a		; $4653
	pop bc			; $4654
	ret			; $4655

; Adds a random value between -2 and +1 to the given number.
@addRandomVariance:
	ld b,a			; $4656
	call getRandomNumber		; $4657
	and $03			; $465a
	sub $02			; $465c
	add b			; $465e
	ret			; $465f

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
; @addr{467e}
_introSpritesState1:
	ld e,Interaction.subid		; $467e
	ld a,(de)		; $4680
	cp $05			; $4681
	jr nc,++		; $4683

	; For subids 0-4 (triforce objects): watch for signal to delete self
	ld a,(wIntro.triforceState)		; $4685
	cp $04			; $4688
	jp z,interactionDelete		; $468a
++
	ld a,(de)		; $468d
	rst_jumpTable			; $468e
	.dw _introSpriteTriforceSubid
	.dw _introSpriteTriforceSubid
	.dw _introSpriteTriforceSubid
	.dw _introSpriteRunTriforceGlowSubid
	.dw _introSpriteRunSubid04
	.dw _introSpriteRunSubid05
	.dw _introSpriteRunSubid06
	.dw _introSpriteRunSubid07
	.dw _introSpriteRunSubid08
	.dw interactionAnimate
	.dw _introSpriteRunTriforceGlowSubid


; Triforce pieces
_introSpriteTriforceSubid:
	ld e,Interaction.state2		; $46a5
	ld a,(de)		; $46a7
	rst_jumpTable			; $46a8
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw interactionAnimate

@substate0:
	ld a,(wIntro.triforceState)		; $46b5
	cp $01			; $46b8
	jp nz,interactionAnimate	; $46ba

	ld b,$00		; $46bd
	ld e,Interaction.subid		; $46bf
	ld a,(de)		; $46c1
	cp $01			; $46c2
	jr z,+			; $46c4
	ld b,$0a		; $46c6
+
	call func_2d48		; $46c8
	call interactionIncState2		; $46cb
	ld l,Interaction.counter1		; $46ce
	ld (hl),b		; $46d0

@substate1:
	call interactionDecCounter1		; $46d1
	jp nz,interactionAnimate		; $46d4

	ld l,Interaction.subid		; $46d7
	ld a,(hl)		; $46d9
	cp $01			; $46da
	jr nz,@centerTriforcePiece	; $46dc
	ld l,Interaction.angle		; $46de
	ld (hl),$00		; $46e0
	ld l,Interaction.speed		; $46e2
	ld (hl),SPEED_20		; $46e4
	ld b,$01		; $46e6
	jr @label_09_048		; $46e8

@centerTriforcePiece:
	or a			; $46ea
	ld a,$18		; $46eb
	jr z,+			; $46ed
	ld a,$08		; $46ef
+
	ld l,Interaction.angle		; $46f1
	ld (hl),a		; $46f3
	ld l,Interaction.speed		; $46f4
	ld (hl),SPEED_20		; $46f6
	ld b,$0b		; $46f8

@label_09_048:
	call func_2d48		; $46fa
	call interactionIncState2		; $46fd
	ld l,Interaction.counter1		; $4700
	ld (hl),b		; $4702

@substate2:
	call interactionDecCounter1		; $4703
	jr nz,++		; $4706

	ld b,$02		; $4708
	call func_2d48		; $470a
	call interactionIncState2		; $470d
	ld l,Interaction.counter1		; $4710
	ld (hl),b		; $4712
++
	call objectApplySpeed		; $4713
	jp interactionAnimate		; $4716

@substate3:
	call interactionDecCounter1		; $4719
	jp nz,interactionAnimate		; $471c

	ld b,$03		; $471f
	call func_2d48		; $4721
	call interactionIncState2		; $4724
	ld l,Interaction.counter1		; $4727
	ld (hl),b		; $4729

	ld e,Interaction.subid		; $472a
	ld a,(de)		; $472c
	cp $01			; $472d
	jr z,+			; $472f

	jp interactionIncState2		; $4731
+
	ld a,SND_ENERGYTHING		; $4734
	jp playSound		; $4736

@substate4:
	call interactionAnimate		; $4739
	call interactionDecCounter1		; $473c
	ret nz			; $473f

	call interactionIncState2		; $4740
	ld a,$02		; $4743
	ld (wIntro.triforceState),a		; $4745

	ld a,SND_AQUAMENTUS_HOVER		; $4748
	jp playSound		; $474a


_introSpriteRunSubid07:
	call objectSetVisible		; $474d
	ld e,Interaction.var03		; $4750
	ld a,(de)		; $4752
	and $01			; $4753
	ld b,a			; $4755
	ld a,(wIntro.frameCounter)		; $4756
	and $01			; $4759
	xor b			; $475b
	call z,objectSetInvisible		; $475c

_introSpriteRunTriforceGlowSubid:
	ld e,Interaction.animParameter		; $475f
	ld a,(de)		; $4761
	inc a			; $4762
	call z,_introSpriteFunc_461a		; $4763
	jp interactionAnimate		; $4766

_introSpriteRunSubid04:
_introSpriteRunSubid05:
_introSpriteRunSubid06:
	call interactionAnimate		; $4769

	ld a,Object.start		; $476c
	call objectGetRelatedObject1Var		; $476e
	call objectTakePosition		; $4771
	ld e,Interaction.var03		; $4774
	ld a,(de)		; $4776
	ld h,d			; $4777
	ld l,Interaction.animCounter		; $4778
	cp (hl)			; $477a
	ld l,Interaction.visible		; $477b
	jr nz,++		; $477d

	set 7,(hl)		; $477f
	ret			; $4781
++
	res 7,(hl)		; $4782
	ret			; $4784


; Extra tree branches in intro
_introSpriteRunSubid08:
	ld a,(wGfxRegs1.SCY)		; $4785
	or a			; $4788
	jp z,interactionDelete		; $4789

	ld b,a			; $478c
	ld e,Interaction.y		; $478d
	ld a,(de)		; $478f
	sub b			; $4790
	inc e			; $4791
	ld (de),a		; $4792
	ret			; $4793

;;
; Sets relatedObj1 of object 'h' to object 'd' (self).
; @addr{4794}
_introSpriteSetChildRelatedObject1ToSelf:
	ld l,Interaction.relatedObj1		; $4794
	ld (hl),Interaction.start		; $4796
	inc l			; $4798
	ld (hl),d		; $4799
	ret			; $479a


; ==============================================================================
; Unused, unreferenced "Fairy" interaction from Seasons that resides in each of the season
; temples
; ==============================================================================
unusedInteraction:
	ld e,Interaction.state		; $479b
	ld a,(de)		; $479d
	rst_jumpTable			; $479e
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

@state0:
	ld e,Interaction.state2		; $47ab
	ld a,(de)		; $47ad
	rst_jumpTable			; $47ae
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call interactionSetAlwaysUpdateBit		; $47b5

	ld l,Interaction.state2		; $47b8
	ld (hl),$01		; $47ba
	ld l,Interaction.counter1		; $47bc
	ld (hl),$01		; $47be
	ld l,Interaction.zh		; $47c0
	ld (hl),$00		; $47c2

	ld a,MUS_FAIRY		; $47c4
	ld (wActiveMusic),a		; $47c6
	jp playSound		; $47c9

@@substate1:
	call interactionDecCounter1		; $47cc
	ret nz			; $47cf

	ld l,Interaction.state2		; $47d0
	ld (hl),$02		; $47d2
	ld l,Interaction.counter1		; $47d4
	ld (hl),$10		; $47d6
	jr @createPuff		; $47d8

@@substate2:
	call interactionDecCounter1		; $47da
	ret nz			; $47dd

	call interactionInitGraphics		; $47de
	call objectSetVisible80		; $47e1

	ld h,d			; $47e4
	ld l,Interaction.state		; $47e5
	ld (hl),$01		; $47e7
	ld l,Interaction.state2		; $47e9
	ld (hl),$00		; $47eb

	ld l,Interaction.var03		; $47ed
	ld a,(hl)		; $47ef
	or a			; $47f0
	jr nz,++		; $47f1

	ld l,Interaction.counter1		; $47f3
	ld (hl),120		; $47f5
	call @createSparkle0		; $47f7
	jp @updateAnimation		; $47fa
++
	ld l,Interaction.counter1		; $47fd
	ld (hl),60		; $47ff
	call @createSparkle1		; $4801
	jp @updateAnimation		; $4804


@createPuff:
	jp objectCreatePuff		; $4807

@createSparkle0:
	ld bc,$8400		; $480a
	jr @createInteraction		; $480d

@createSparkle1:
	ldbc INTERACID_SPARKLE,$07		; $480f
	call objectCreateInteraction		; $4812
	ld e,Interaction.counter1		; $4815
	ld a,(de)		; $4817
	ld l,e			; $4818
	ld (hl),a		; $4819
	ret			; $481a

@createSparkle2:
	ldbc INTERACID_SPARKLE,$01		; $481b

@createInteraction:
	jp objectCreateInteraction		; $481e


@state1:
	call objectOscillateZ_body		; $4821
	call interactionDecCounter1		; $4824
	jr z,++			; $4827

	call @updateAnimation		; $4829
	ld a,(wFrameCounter)		; $482c
	rrca			; $482f
	jp nc,objectSetInvisible		; $4830
	jp objectSetVisible		; $4833
++
	ld l,Interaction.var03		; $4836
	ld a,(hl)		; $4838
	or a			; $4839
	jr z,++			; $483a

	ld l,Interaction.state		; $483c
	ld (hl),$05		; $483e
	ld hl,$cfc0		; $4840
	set 1,(hl)		; $4843
	call objectSetVisible		; $4845
	jr @updateAnimation		; $4848
++
	ld l,Interaction.state		; $484a
	inc (hl)		; $484c
	ld l,Interaction.zh		; $484d
	ld (hl),$00		; $484f
	ld l,Interaction.var3a		; $4851
	ld (hl),$30		; $4853

	ld l,Interaction.angle		; $4855
	ld (hl),$00		; $4857
	ld l,Interaction.speed		; $4859
	ld (hl),SPEED_80		; $485b

	call objectSetVisible		; $485d
	ld a,SND_CHARGE_SWORD		; $4860
	call playSound		; $4862

@state2:
	call objectApplySpeed		; $4865

	ld h,d			; $4868
	ld l,Interaction.yh		; $4869
	ld a,(hl)		; $486b
	cp $10			; $486c
	jr nc,@updateAnimation	; $486e

	ld l,Interaction.state		; $4870
	inc (hl)		; $4872
	ld l,Interaction.counter1		; $4873
	ld (hl),$04		; $4875
	ld l,Interaction.var3b		; $4877
	ld (hl),$00		; $4879

	ld a,(w1Link.yh)		; $487b
	ld l,Interaction.yh		; $487e
	ld (hl),a		; $4880
	ld a,(w1Link.xh)		; $4881
	ld l,Interaction.xh		; $4884
	ld (hl),a		; $4886

	call @func_48eb		; $4887

@state3:
	call @checkLinkIsClose		; $488a
	jr c,++			; $488d

	call @func_48d0		; $488f
	call @func_48f9		; $4892
	ld a,(de)		; $4895
	ld e,Interaction.var3b		; $4896
	call objectSetPositionInCircleArc		; $4898
	call @func_4907		; $489b
	ld a,(wFrameCounter)		; $489e
	and $07			; $48a1
	call z,@createSparkle2		; $48a3
	jr @updateAnimation		; $48a6
++
	ld l,Interaction.state		; $48a8
	inc (hl)		; $48aa
	ld hl,$cfc0		; $48ab
	set 1,(hl)		; $48ae

@updateAnimation:
	jp interactionAnimate		; $48b0

@state4:
	call objectOscillateZ_body		; $48b3
	ld a,($cfc0)		; $48b6
	cp $07			; $48b9
	jp z,interactionDelete		; $48bb
	jr @updateAnimation		; $48be

@state5:
	call objectOscillateZ_body		; $48c0
	ld a,($cfc0)		; $48c3
	cp $07			; $48c6
	jr nz,@updateAnimation	; $48c8
	call @createPuff		; $48ca
	jp interactionDelete		; $48cd

;;
; @addr{48d0}
@func_48d0:
	ld l,Interaction.yh		; $48d0
	ld e,Interaction.var38		; $48d2
	ld a,(de)		; $48d4
	ldi (hl),a		; $48d5
	inc l			; $48d6
	inc e			; $48d7
	ld a,(de)		; $48d8
	ld (hl),a		; $48d9
	ld a,(w1Link.yh)		; $48da
	ld b,a			; $48dd
	ld a,(w1Link.xh)		; $48de
	ld c,a			; $48e1
	call objectGetRelativeAngle		; $48e2
	ld e,Interaction.angle		; $48e5
	ld (de),a		; $48e7
	call objectApplySpeed		; $48e8

;;
; @addr{48eb}
@func_48eb:
	ld h,d			; $48eb
	ld l,Interaction.yh		; $48ec
	ld e,Interaction.var38		; $48ee
	ldi a,(hl)		; $48f0
	ld (de),a		; $48f1
	ld b,a			; $48f2
	inc l			; $48f3
	inc e			; $48f4
	ld a,(hl)		; $48f5
	ld (de),a		; $48f6
	ld c,a			; $48f7
	ret			; $48f8

;;
; @addr{48f9}
@func_48f9:
	ld e,Interaction.var3a		; $48f9
	ld a,(de)		; $48fb
	or a			; $48fc
	ret z			; $48fd
	call interactionDecCounter1		; $48fe
	ret nz			; $4901

	ld (hl),$04		; $4902

	ld l,e			; $4904
	dec (hl)		; $4905
	ret			; $4906

;;
; @addr{4907}
@func_4907:
	ld a,(wFrameCounter)		; $4907
	rrca			; $490a
	ret nc			; $490b

	ld e,Interaction.var3b		; $490c
	ld a,(de)		; $490e
	inc a			; $490f
	and $1f			; $4910
	ld (de),a		; $4912
	ret			; $4913

;;
; @param[out]	cflag	Set if Link is close to this object
; @addr{4914}
@checkLinkIsClose:
	ld h,d			; $4914
	ld l,Interaction.yh		; $4915
	ld a,(w1Link.yh)		; $4917
	add $f0			; $491a
	sub (hl)		; $491c
	add $04			; $491d
	cp $09			; $491f
	ret nc			; $4921
	ld l,Interaction.xh		; $4922
	ld a,(w1Link.xh)		; $4924
	sub (hl)		; $4927
	add $02			; $4928
	cp $05			; $492a
	ret			; $492c


;;
; When called once per frame, the object's Z positon will gently oscillate up and down.
;
; @addr{492d}
objectOscillateZ_body:
	ld a,(wFrameCounter)		; $492d
	and $07			; $4930
	ret nz			; $4932

	ld a,(wFrameCounter)		; $4933
	and $38			; $4936
	swap a			; $4938
	rlca			; $493a

	ld hl,@zOffsets		; $493b
	rst_addAToHl			; $493e
	ldh a,(<hActiveObjectType)	; $493f
	add Object.zh			; $4941
	ld e,a			; $4943
	ld a,(de)		; $4944
	add (hl)		; $4945
	ld (de),a		; $4946
	ret			; $4947

@zOffsets:
	.db $ff $fe $ff $00
	.db $01 $02 $01 $00


; ==============================================================================
; INTERACID_EXPLOSION
; ==============================================================================
interactionCode56:
	call checkInteractionState		; $4950
	jr z,@state0	; $4953

@state1:
	ld e,Interaction.animParameter		; $4955
	ld a,(de)		; $4957
	inc a			; $4958
	jp nz,interactionAnimate		; $4959
	jp interactionDelete		; $495c

@state0:
	inc a			; $495f
	ld (de),a		; $4960
	call interactionInitGraphics		; $4961
	ld a,SND_EXPLOSION		; $4964
	call playSound		; $4966
	ld e,Interaction.var03		; $4969
	ld a,(de)		; $496b
	rrca			; $496c
	jp c,objectSetVisible81		; $496d
	jp objectSetVisible82		; $4970


; ==============================================================================
; INTERACID_TREASURE
;
; State $04 is used as a way to delete a treasure? (Bomb flower cutscene with goron elder
; sets the bomb flower to state 4 to delete it.)
;
; Variables:
;   subid: overwritten by call to "interactionLoadTreasureData" to correspond to a certain
;          graphic.
;   var30: former value of subid (treasure index)
;
;   var31-var35 based on data from "treasureObjectData.s":
;     var31: spawn mode
;     var32: collect mode
;     var33: a boolean?
;     var34: parameter (value of 'c' for "giveTreasure" function)
;     var35: low text ID
;   var39: If set, this is part of the chest minigame? Gets written to "wDisabledObjects"?
; ==============================================================================
interactionCode60:
	ld e,Interaction.state		; $4973
	ld a,(de)		; $4975
	rst_jumpTable			; $4976
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw interactionDelete

@state0:
	ld a,$01		; $4981
	ld (de),a		; $4983
	callab bank16.interactionLoadTreasureData		; $4984
	ld a,$06		; $498c
	call objectSetCollideRadius		; $498e

	; Check whether to overwrite the "parameter" for the treasure?
	ld l,Interaction.var38		; $4991
	ld a,(hl)		; $4993
	or a			; $4994
	jr z,+			; $4995
	cp $ff			; $4997
	jr z,+			; $4999
	ld l,Interaction.var34		; $499b
	ld (hl),a		; $499d
+
	call interactionInitGraphics		; $499e

	ld e,Interaction.var31		; $49a1
	ld a,(de)		; $49a3
	or a			; $49a4
	ret nz			; $49a5
	jp objectSetVisiblec2		; $49a6


; State 1: spawning in; goes to state 2 when finished spawning.
@state1:
	ld e,Interaction.var31		; $49a9
	ld a,(de)		; $49ab
	rst_jumpTable			; $49ac
	.dw @spawnMode0
	.dw @spawnMode1
	.dw @spawnMode2
	.dw @spawnMode3
	.dw @spawnMode4
	.dw @spawnMode5
	.dw @spawnMode6

; Spawns instantly
@spawnMode0:
	ld h,d			; $49bb
	ld l,Interaction.state		; $49bc
	ld (hl),$02		; $49be
	inc l			; $49c0
	ld (hl),$00		; $49c1
	call @checkLinkTouched		; $49c3
	jp c,@gotoState3		; $49c6
	jp objectSetVisiblec2		; $49c9

; Appears with a poof
@spawnMode1:
	ld e,Interaction.state2		; $49cc
	ld a,(de)		; $49ce
	or a			; $49cf
	jr nz,++		; $49d0

	ld a,$01		; $49d2
	ld (de),a		; $49d4
	ld e,Interaction.counter1		; $49d5
	ld a,$1e		; $49d7
	ld (de),a		; $49d9
	call objectCreatePuff		; $49da
	ret nz			; $49dd
++
	call interactionDecCounter1		; $49de
	ret nz			; $49e1
	jr @spawnMode0			; $49e2

; Falls from top of screen
@spawnMode2:
	ld e,Interaction.state2		; $49e4
	ld a,(de)		; $49e6
	rst_jumpTable			; $49e7
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,$01		; $49ee
	ld (de),a		; $49f0
	ld h,d			; $49f1
	ld l,Interaction.counter1		; $49f2
	ld (hl),$28		; $49f4
	ld a,SND_SOLVEPUZZLE	; $49f6
	jp playSound		; $49f8

@@substate1:
	call interactionDecCounter1		; $49fb
	ret nz			; $49fe
	ld (hl),$02		; $49ff
	inc l			; $4a01
	ld (hl),$02		; $4a02

	ld l,Interaction.state2		; $4a04
	inc (hl)		; $4a06

	call objectGetZAboveScreen		; $4a07
	ld h,d			; $4a0a
	ld l,Interaction.zh		; $4a0b
	ld (hl),a		; $4a0d

	call objectSetVisiblec0		; $4a0e
	jp @setVisibleIfWithinScreenBoundary		; $4a11

@@substate2:
	call @checkLinkTouched		; $4a14
	jr c,@gotoState3		; $4a17
	call @setVisibleIfWithinScreenBoundary		; $4a19
	ld c,$10		; $4a1c
	call objectUpdateSpeedZ_paramC		; $4a1e
	ret nz			; $4a21
	call objectCheckIsOnHazard		; $4a22
	jr nc,+			; $4a25

	dec a			; $4a27
	jr z,@landedOnWater		; $4a28
	jp objectReplaceWithFallingDownHoleInteraction		; $4a2a
+
	ld a,SND_DROPESSENCE		; $4a2d
	call playSound		; $4a2f
	call interactionDecCounter1		; $4a32
	jr z,@gotoState2			; $4a35

	ld bc,$ff56		; $4a37
	jp objectSetSpeedZ		; $4a3a

@gotoState2:
	call objectSetVisible		; $4a3d
	call objectSetVisiblec2		; $4a40
	ld a,$02		; $4a43
	jr @gotoStateAndAlwaysUpdate			; $4a45

@setVisibleIfWithinScreenBoundary:
	call objectCheckWithinScreenBoundary		; $4a47
	jp nc,objectSetInvisible		; $4a4a
	jp objectSetVisible		; $4a4d

@gotoState3:
	call @giveTreasure		; $4a50
	ld a,$03		; $4a53

@gotoStateAndAlwaysUpdate:
	ld h,d			; $4a55
	ld l,Interaction.state		; $4a56
	ldi (hl),a		; $4a58
	xor a			; $4a59
	ld (hl),a		; $4a5a

	ld l,Interaction.z		; $4a5b
	ldi (hl),a		; $4a5d
	ld (hl),a		; $4a5e

	jp interactionSetAlwaysUpdateBit		; $4a5f

; If the treasure fell into the water, "reset" this object to state 0, increment var03.
@landedOnWater:
	ld h,d			; $4a62
	ld l,Interaction.var30		; $4a63
	ld a,(hl)		; $4a65
	ld l,Interaction.subid		; $4a66
	ldi (hl),a		; $4a68

	inc (hl) ; [var03]++ (use the subsequent entry in treasureObjectData)

	; Clear state
	inc l			; $4a6a
	xor a			; $4a6b
	ldi (hl),a		; $4a6c
	ld (hl),a		; $4a6d

	ld l,Interaction.visible		; $4a6e
	res 7,(hl)		; $4a70
	ld b,INTERACID_SPLASH		; $4a72
	jp objectCreateInteractionWithSubid00		; $4a74


; Spawns from a chest
@spawnMode3:
	ld a,$80		; $4a77
	ld (wForceLinkPushAnimation),a		; $4a79
	ld e,Interaction.state2		; $4a7c
	ld a,(de)		; $4a7e
	rst_jumpTable			; $4a7f
	.dw @m3State0
	.dw @m3State1
	.dw @m3State2

@m3State0:
	ld a,$01		; $4a86
	ld (de),a		; $4a88
	ld (wDisableLinkCollisionsAndMenu),a		; $4a89
	call interactionSetAlwaysUpdateBit		; $4a8c

	; Angle is already $00 (up), so don't need to set it
	ld l,Interaction.speed		; $4a8f
	ld (hl),SPEED_40		; $4a91

	ld l,Interaction.counter1		; $4a93
	ld (hl),$20		; $4a95
	jp objectSetVisible80		; $4a97

@m3State1:
	; Move up
	call objectApplySpeed		; $4a9a
	call interactionDecCounter1		; $4a9d
	ret nz			; $4aa0

	; Finished moving up
	ld l,Interaction.state2		; $4aa1
	inc (hl)		; $4aa3
	ld l,Interaction.var39		; $4aa4
	ld a,(hl)		; $4aa6
	or a			; $4aa7
	call z,@giveTreasure		; $4aa8
	ld a,SND_GETITEM	; $4aab
	call playSound		; $4aad

	; Wait for player to close text
@m3State2:
	ld a,(wTextIsActive)		; $4ab0
	and $7f			; $4ab3
	ret nz			; $4ab5

	xor a			; $4ab6
	ld (wDisableLinkCollisionsAndMenu),a		; $4ab7
	ld e,Interaction.var39		; $4aba
	ld a,(de)		; $4abc
	ld (wDisabledObjects),a		; $4abd
	jp interactionDelete		; $4ac0


; Appears at Link's position after a short delay
@spawnMode6:
	ld e,Interaction.state2		; $4ac3
	ld a,(de)		; $4ac5
	rst_jumpTable			; $4ac6
	.dw @m6State0
	.dw @m6State1
	.dw @m6State2

@m6State0:
	ld a,$01		; $4acd
	ld (de),a		; $4acf
	ld (wDisableLinkCollisionsAndMenu),a		; $4ad0
	call interactionSetAlwaysUpdateBit		; $4ad3
	ld l,Interaction.counter1		; $4ad6
	ld (hl),$0f		; $4ad8
@m6State1:
	call interactionDecCounter1		; $4ada
	ret nz			; $4add

	; Delay done, give treasure to Link

	call interactionIncState2		; $4ade
	call objectSetVisible80		; $4ae1
	call @giveTreasure		; $4ae4
	ldbc $81,$00		; $4ae7
	call @setLinkAnimationAndDeleteIfTextClosed		; $4aea
	ld a,SND_GETITEM	; $4aed
	jp playSound		; $4aef

@m6State2:
	ld a,(wTextIsActive)		; $4af2
	and $7f			; $4af5
	ret nz			; $4af7
	xor a			; $4af8
	ld (wDisableLinkCollisionsAndMenu),a		; $4af9
	ld (wDisabledObjects),a		; $4afc
	jp interactionDelete		; $4aff


; Item that's underwater, must dive to get it (only used in seasons dungeon 4)
@spawnMode4:
	call @checkLinkTouched		; $4b02
	ret nc			; $4b05
	ld a,(wLinkSwimmingState)		; $4b06
	bit 7,a			; $4b09
	ret z			; $4b0b
	call objectSetVisible82		; $4b0c
	call @giveTreasure		; $4b0f
	ld a,SND_GETITEM		; $4b12
	call playSound		; $4b14
	ld a,$03		; $4b17
	jp @gotoStateAndAlwaysUpdate		; $4b19


; Item that falls to Link's position when [wccaa]=$ff?
@spawnMode5:
	ld e,Interaction.state2		; $4b1c
	ld a,(de)		; $4b1e
	rst_jumpTable			; $4b1f
	.dw @m5State0
	.dw @m5State1
	.dw @m5State2

@m5State0:
	ld a,$01		; $4b26
	ld (de),a		; $4b28
	call objectGetShortPosition		; $4b29
	ld (wccaa),a		; $4b2c
	ret			; $4b2f

@m5State1:
	ld a,(wScrollMode)		; $4b30
	and $0c			; $4b33
	jp nz,interactionDelete		; $4b35

	ld a,(wccaa)		; $4b38
	inc a			; $4b3b
	ret nz			; $4b3c

	ld bc,$ff00		; $4b3d
	call objectSetSpeedZ		; $4b40
	ld l,Interaction.state2		; $4b43
	inc (hl)		; $4b45
	ld a,(w1Link.direction)		; $4b46
	swap a			; $4b49
	rrca			; $4b4b
	ld l,$49		; $4b4c
	ld (hl),a		; $4b4e
	ld l,$50		; $4b4f
	ld (hl),$14		; $4b51
	jp objectSetVisiblec2		; $4b53

@m5State2:
	call objectCheckTileCollision_allowHoles		; $4b56
	call nc,objectApplySpeed		; $4b59
	ld c,$10		; $4b5c
	call objectUpdateSpeedZAndBounce		; $4b5e
	ret nz			; $4b61
	push af			; $4b62
	call objectReplaceWithAnimationIfOnHazard		; $4b63
	pop bc			; $4b66
	jp c,interactionDelete		; $4b67

	ld a,SND_DROPESSENCE		; $4b6a
	call playSound		; $4b6c
	bit 4,c			; $4b6f
	ret z			; $4b71
	jp @gotoState2		; $4b72


; State 2: done spawning, waiting for Link to grab it
@state2:
	call returnIfScrollMode01Unset		; $4b75
	call @checkLinkTouched		; $4b78
	ret nc			; $4b7b
	jp @gotoState3		; $4b7c


; State 3: Link just grabbed it
@state3:
	ld e,Interaction.var32		; $4b7f
	ld a,(de)		; $4b81
	rst_jumpTable			; $4b82
	.dw interactionDelete
	.dw @grabMode1
	.dw @grabMode2
	.dw @grabMode3
	.dw @grabMode1
	.dw @grabMode2

; Hold over head with 1 hand
@grabMode1:
	ldbc $80,$fc		; $4b8f
	jr +			; $4b92

; Hold over head with 2 hands
@grabMode2:
	ldbc $81,$00		; $4b94
+
	ld e,Interaction.state2		; $4b97
	ld a,(de)		; $4b99
	or a			; $4b9a
	jr nz,++		; $4b9b

	inc a			; $4b9d
	ld (de),a		; $4b9e

;;
; @param	b	Animation to do (0 = 1-hand grab, 1 = 2-hand grab)
; @param	c	x-offset to put item relative to Link
; @addr{4b9f}
@setLinkAnimationAndDeleteIfTextClosed:
	ld a,LINK_STATE_04		; $4b9f
	ld (wLinkForceState),a		; $4ba1
	ld a,b			; $4ba4
	ld (wcc50),a		; $4ba5
	ld hl,wDisabledObjects		; $4ba8
	set 0,(hl)		; $4bab
	ld hl,w1Link		; $4bad
	ld b,$f2		; $4bb0
	call objectTakePositionWithOffset		; $4bb2
	call objectSetVisible80		; $4bb5
	ld a,SND_GETITEM		; $4bb8
	call playSound		; $4bba
++
	call retIfTextIsActive		; $4bbd
	ld hl,wDisabledObjects		; $4bc0
	res 0,(hl)		; $4bc3
	ld a,$0f		; $4bc5
	ld (wInstrumentsDisabledCounter),a		; $4bc7
	jp interactionDelete		; $4bca


; Performs a spin slash upon obtaining the item
@grabMode3:
	ld a,Interaction.var38		; $4bcd
	ld (wInstrumentsDisabledCounter),a		; $4bcf
	ld e,Interaction.state2		; $4bd2
	ld a,(de)		; $4bd4
	rst_jumpTable			; $4bd5
	.dw @gm3State0
	.dw @gm3State1
	.dw @gm3State2
	.dw @gm3State3

@gm3State0:
	ld a,$01		; $4bde
	ld (de),a		; $4be0
	inc e			; $4be1

	ld a,$04		; $4be2
	ld (de),a ; [counter1] = $04

	ld a,$81		; $4be5
	ld (wDisabledObjects),a		; $4be7
	ld a,$ff		; $4bea
	call setLinkForceStateToState08_withParam		; $4bec
	ld hl,wLinkForceState		; $4bef
	jp objectSetInvisible		; $4bf2

@gm3State1:
	call interactionDecCounter1		; $4bf5
	ret nz			; $4bf8

	ld l,Interaction.state2		; $4bf9
	inc (hl)		; $4bfb

	; Forces spinslash animation
	ld a,$ff		; $4bfc
	ld (wcc63),a		; $4bfe
	ret			; $4c01

@gm3State2:
	; Wait for spin to finish
	ld a,(wcc63)		; $4c02
	or a			; $4c05
	ret nz			; $4c06

	ld a,LINK_ANIM_MODE_GETITEM1HAND		; $4c07
	ld (wcc50),a		; $4c09

	; Calculate x/y position just above Link
	ld e,Interaction.yh		; $4c0c
	ld a,(w1Link.yh)		; $4c0e
	sub $0e			; $4c11
	ld (de),a		; $4c13
	ld e,Interaction.xh		; $4c14
	ld a,(w1Link.xh)		; $4c16
	sub $04			; $4c19
	ld (de),a		; $4c1b

	call objectSetVisible		; $4c1c
	call objectSetVisible80		; $4c1f
	call interactionIncState2		; $4c22
	ld a,SND_SWORD_OBTAINED		; $4c25
	jp playSound		; $4c27

@gm3State3:
	ld a,(wDisabledObjects)		; $4c2a
	or a			; $4c2d
	ret nz			; $4c2e
	jp interactionDelete		; $4c2f

@giveTreasure:
	ld e,Interaction.var34		; $4c32
	ld a,(de)		; $4c34
	ld c,a			; $4c35
	ld e,Interaction.var30		; $4c36
	ld a,(de)		; $4c38
	ld b,a			; $4c39

	; If this is ore chunks, double the value if wearing an appropriate ring?
	cp TREASURE_ORE_CHUNKS			; $4c3a
	jr nz,++		; $4c3c

	ld a,GOLD_JOY_RING		; $4c3e
	call cpActiveRing		; $4c40
	jr z,+			; $4c43

	ld a,GREEN_JOY_RING		; $4c45
	call cpActiveRing		; $4c47
	jr nz,++		; $4c4a
+
	inc c			; $4c4c
++
	ld a,b			; $4c4d
	call giveTreasure		; $4c4e
	ld b,a			; $4c51

	ld e,Interaction.var32		; $4c52
	ld a,(de)		; $4c54
	cp $03			; $4c55
	jr z,+			; $4c57

	ld a,b			; $4c59
	call playSound		; $4c5a
+
	ld e,Interaction.var35		; $4c5d
	ld a,(de)		; $4c5f
	cp $ff			; $4c60
	jr z,++			; $4c62

	ld c,a			; $4c64
	ld b,>TX_0000		; $4c65
	call showText		; $4c67

	; Determine textbox position (after showText call...?)
	ldh a,(<hCameraY)	; $4c6a
	ld b,a			; $4c6c
	ld a,(w1Link.yh)		; $4c6d
	sub b			; $4c70
	sub $10			; $4c71
	cp $48			; $4c73
	ld a,$02		; $4c75
	jr c,+			; $4c77
	xor a			; $4c79
+
	ld (wTextboxPosition),a		; $4c7a
++
	ld e,Interaction.var33		; $4c7d
	ld a,(de)		; $4c7f
	or a			; $4c80
	ret z			; $4c81

	; Mark item as obtained
	call getThisRoomFlags		; $4c82
	set ROOMFLAG_BIT_ITEM,(hl)		; $4c85
	ret			; $4c87

;;
; @param[out]	cflag	Set if Link's touched this object so he should collect it
; @addr{4c88}
@checkLinkTouched:
	ld a,(wLinkForceState)		; $4c88
	or a			; $4c8b
	ret nz			; $4c8c

	ld a,(wLinkPlayingInstrument)		; $4c8d
	or a			; $4c90
	ret nz			; $4c91

	ld a,(w1Link.state)		; $4c92
	cp LINK_STATE_NORMAL			; $4c95
	jr z,+			; $4c97
	cp LINK_STATE_08			; $4c99
	jr nz,++		; $4c9b
+
	ld a,(wLinkObjectIndex)		; $4c9d
	rrca			; $4ca0
	jr c,++			; $4ca1

	; Check if Link's touched this
	ld e,Interaction.var2a		; $4ca3
	ld a,(de)		; $4ca5
	or a			; $4ca6
	jp z,objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $4ca7
	scf			; $4caa
	ret			; $4cab
++
	xor a			; $4cac
	ret			; $4cad


; ==============================================================================
; INTERACID_GHOST_VERAN
; ==============================================================================
interactionCode3e:
	ld e,Interaction.state		; $4cae
	ld a,(de)		; $4cb0
	rst_jumpTable			; $4cb1
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4cb6
	ld (de),a		; $4cb8
	call interactionInitGraphics		; $4cb9
	call objectSetVisible83		; $4cbc
	ld e,Interaction.subid	; $4cbf
	ld a,(de)		; $4cc1
	rst_jumpTable			; $4cc2
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init

@subid0Init:
	ld e,Interaction.counter1	; $4cc9
	ld a,Interaction.var38		; $4ccb
	ld (de),a		; $4ccd
	jp interactionSetAlwaysUpdateBit		; $4cce

@subid1Init:
	ld h,d			; $4cd1
	ld l,Interaction.angle		; $4cd2
	ld (hl),$10		; $4cd4
	ld l,Interaction.speed		; $4cd6
	ld (hl),SPEED_c0		; $4cd8
	ld hl,ghostVeranSubid1Script		; $4cda
	call interactionSetScript		; $4cdd
	call interactionSetAlwaysUpdateBit		; $4ce0
	jp objectSetVisible81		; $4ce3

@subid2Init:
	ld e,Interaction.speed		; $4ce6
	ld a,SPEED_200		; $4ce8
	ld (de),a		; $4cea
	ld a,SND_BEAM		; $4ceb
	jp playSound		; $4ced


@state1:
	ld e,Interaction.subid	; $4cf0
	ld a,(de)		; $4cf2
	rst_jumpTable			; $4cf3
	.dw _runVeranGhostSubid0
	.dw _runVeranGhostSubid1
	.dw _runVeranGhostSubid2


; Cutscene at start of game (unpossessing Impa)
_runVeranGhostSubid0:
	ld e,Interaction.var39		; $4cfa
	ld a,(de)		; $4cfc
	or a			; $4cfd
	call z,interactionAnimate		; $4cfe
	ld e,Interaction.state2		; $4d01
	ld a,(de)		; $4d03
	rst_jumpTable			; $4d04
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8

@substate0:
	call interactionDecCounter1		; $4d17
	jr nz,++		; $4d1a

	; Appear out of Impa
	ld (hl),$5a		; $4d1c
	ld l,Interaction.angle	; $4d1e
	ld (hl),$00		; $4d20
	ld l,Interaction.speed	; $4d22
	ld (hl),$0a		; $4d24
	call interactionIncState2		; $4d26
	ld a,MUS_ROOM_OF_RITES		; $4d29
	call playSound		; $4d2b
	jp objectSetVisible80		; $4d2e
++
	ld a,(wFrameCounter)		; $4d31
	rrca			; $4d34
	jp nc,objectSetVisible83		; $4d35
	jp objectSetVisible80		; $4d38

@substate1:
	call interactionDecCounter1		; $4d3b
	jp nz,objectApplySpeed		; $4d3e
	call interactionIncState2		; $4d41
	ld hl,ghostVeranSubid0Script_part1		; $4d44
	jp interactionSetScript		; $4d47

@substate2:
	ld a,($cfd1)		; $4d4a
	or a			; $4d4d
	jr z,++			; $4d4e

	ldbc INTERACID_HUMAN_VERAN, $00	; $4d50
	call objectCreateInteraction		; $4d53
	ret nz			; $4d56

	ld l,Interaction.relatedObj1		; $4d57
	ld a,Interaction.start	; $4d59
	ldi (hl),a		; $4d5b
	ld (hl),d		; $4d5c
---
	call interactionIncState2		; $4d5d
	ld l,Interaction.var38		; $4d60
	ld (hl),$78		; $4d62
	ld l,Interaction.var39		; $4d64
	inc (hl)		; $4d66
	xor a			; $4d67
	call interactionSetAnimation		; $4d68
	ld a,SND_TELEPORT	; $4d6b
	jp playSound		; $4d6d
++
	call objectGetPosition		; $4d70
	ld hl,$cfd5		; $4d73
	ld (hl),b		; $4d76
	inc l			; $4d77
	ld e,Interaction.var3d		; $4d78
	ld a,c			; $4d7a
	ld (de),a		; $4d7b
	ld (hl),a		; $4d7c
	jp interactionRunScript		; $4d7d

@substate3:
@substate5:
	ld h,d			; $4d80
	ld l,Interaction.var38		; $4d81
	dec (hl)		; $4d83
	ld b,$01		; $4d84
	jp nz,objectFlickerVisibility		; $4d86

	ld l,Interaction.var39		; $4d89
	dec (hl)		; $4d8b
	call interactionIncState2		; $4d8c
	ld a,(hl)		; $4d8f
	cp $04			; $4d90
	jp nz,objectSetVisible		; $4d92
	call objectSetInvisible		; $4d95
	ld a,SND_SWORD_OBTAINED		; $4d98
	jp playSound		; $4d9a

@substate4:
	ld a,($cfd1)		; $4d9d
	cp $02			; $4da0
	ret nz			; $4da2
	jr ---			; $4da3

@substate6:
	ld a,($cfd0)		; $4da5
	cp $12			; $4da8
	jr nz,+			; $4daa
	ld bc,$0302		; $4dac
	call @rumbleAndRandomizeX		; $4daf
	jr ++			; $4db2
+
	call objectGetPosition		; $4db4
	ld hl,$cfd5		; $4db7
	ld (hl),b		; $4dba
	inc l			; $4dbb
	ld e,Interaction.var3d		; $4dbc
	ld a,c			; $4dbe
	ld (de),a		; $4dbf
	ld (hl),a		; $4dc0
++
	call interactionRunScript		; $4dc1
	ret nc			; $4dc4
	call objectSetInvisible		; $4dc5
	jp interactionIncState2		; $4dc8

;;
; @addr{4dcb}
@rumbleAndRandomizeX:
	ld a,(wFrameCounter)		; $4dcb
	and $0f			; $4dce
	ld a,SND_RUMBLE2	; $4dd0
	call z,playSound		; $4dd2
	call getRandomNumber		; $4dd5
	and b			; $4dd8
	sub c			; $4dd9
	ld h,d			; $4dda
	ld l,Interaction.var3d		; $4ddb
	add (hl)		; $4ddd
	ld l,Interaction.xh		; $4dde
	ld (hl),a		; $4de0
	ret			; $4de1

@substate7:
	ld a,($cfd0)		; $4de2
	cp $17			; $4de5
	ret nz			; $4de7

	call interactionIncState2		; $4de8
	ld hl,ghostVeranSubid1Script_part2		; $4deb
	call interactionSetScript		; $4dee
	call objectSetVisible80		; $4df1

@substate8:
	call interactionRunScript		; $4df4
	ret nc			; $4df7
	jp interactionDelete		; $4df8


; Cutscene just before fighting possessed Ambi
_runVeranGhostSubid1:
	ld a,(wTextIsActive)		; $4dfb
	or a			; $4dfe
	jr nz,+			; $4dff
	call interactionRunScript		; $4e01
	jp c,interactionDelete		; $4e04
+
	jp interactionAnimate		; $4e07


; Cutscene just after fighting possessed Ambi
_runVeranGhostSubid2:
	ld e,Interaction.state2		; $4e0a
	ld a,(de)		; $4e0c
	rst_jumpTable			; $4e0d
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld bc,$5878		; $4e16
	ld e,Interaction.yh		; $4e19
	ld a,(de)		; $4e1b
	ldh (<hFF8F),a	; $4e1c
	ld e,Interaction.xh		; $4e1e
	ld a,(de)		; $4e20
	ldh (<hFF8E),a	; $4e21
	sub c			; $4e23
	inc a			; $4e24
	cp $03			; $4e25
	jr nc,++		; $4e27

	ldh a,(<hFF8F)	; $4e29
	sub b			; $4e2b
	inc a			; $4e2c
	cp $03			; $4e2d
	jr nc,++		; $4e2f

	call interactionIncState2		; $4e31
	ld l,Interaction.yh		; $4e34
	ld (hl),b		; $4e36
	ld l,Interaction.xh		; $4e37
	ld (hl),c		; $4e39
	ld l,Interaction.counter1	; $4e3a
	ld (hl),$3c		; $4e3c
	jr @animate		; $4e3e
++
	call objectGetRelativeAngleWithTempVars		; $4e40
	ld e,Interaction.angle	; $4e43
	ld (de),a		; $4e45
	call objectApplySpeed		; $4e46

@animate:
	jp interactionAnimate		; $4e49

@substate1:
	call interactionDecCounter1		; $4e4c
	jr nz,@animate	; $4e4f
	ld l,e			; $4e51
	inc (hl)		; $4e52
	ld bc,TX_560e		; $4e53
	jp showText		; $4e56

@substate2:
	call getFreeEnemySlot		; $4e59
	ret nz			; $4e5c
	ld (hl),ENEMYID_VERAN_FAIRY		; $4e5d
	call objectCopyPosition		; $4e5f
	ld e,Interaction.relatedObj2		; $4e62
	ld a,Enemy.start		; $4e64
	ld (de),a		; $4e66
	inc e			; $4e67
	ld a,h			; $4e68
	ld (de),a		; $4e69
	call interactionIncState2		; $4e6a
	ld l,Interaction.counter1		; $4e6d
	ld (hl),$3d		; $4e6f
	ret			; $4e71

@substate3:
	call interactionDecCounter1		; $4e72
	jr z,++			; $4e75

	ld a,Object.visible		; $4e77
	call objectGetRelatedObject2Var		; $4e79
	bit 7,(hl)		; $4e7c
	jp z,objectSetVisible82		; $4e7e
	jp objectSetInvisible		; $4e81
++
	ld a,$01		; $4e84
	ld (wLoadedTreeGfxIndex),a		; $4e86
	jp interactionDelete		; $4e89


; ==============================================================================
; INTERACID_BOY_2
; ==============================================================================
interactionCode3f:
	ld e,Interaction.subid		; $4e8c
	ld a,(de)		; $4e8e
	rst_jumpTable			; $4e8f
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3

@subid0:
	call checkInteractionState		; $4e98
	jr nz,@@state1		; $4e9b

@@state0:
	ld a,GLOBALFLAG_FINISHEDGAME		; $4e9d
	call checkGlobalFlag		; $4e9f
	jp nz,interactionDelete		; $4ea2
	ld a,GLOBALFLAG_0b		; $4ea5
	call checkGlobalFlag		; $4ea7
	jp nz,interactionDelete		; $4eaa

	call @initializeGraphicsAndScript		; $4ead
@@state1:
	call interactionRunScript		; $4eb0
	jp npcFaceLinkAndAnimate		; $4eb3


@subid1:
	call checkInteractionState		; $4eb6
	jr nz,@@state1		; $4eb9

@@state0:
	callab getGameProgress_1		; $4ebb
	ld a,b			; $4ec3
	cp $03			; $4ec4
	jp nz,interactionDelete		; $4ec6
	call @initializeGraphicsAndScript		; $4ec9
@@state1:
	call interactionRunScript		; $4ecc
	jp npcFaceLinkAndAnimate		; $4ecf


@subid2:
	call checkInteractionState		; $4ed2
	jr nz,@@state1		; $4ed5

@@state0:
	call getThisRoomFlags		; $4ed7
	bit 6,a			; $4eda
	jp nz,interactionDelete		; $4edc
	call @initGraphicsAndIncState		; $4edf

	ld l,Interaction.var3d		; $4ee2
	ld e,Interaction.xh		; $4ee4
	ld a,(de)		; $4ee6
	ld (hl),a		; $4ee7

	jp objectSetVisiblec2		; $4ee8

@@state1:
	ld e,Interaction.state2		; $4eeb
	ld a,(de)		; $4eed
	rst_jumpTable			; $4eee
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call interactionAnimate		; $4ef5
	ld a,($cfd1)		; $4ef8
	cp $01			; $4efb
	ret nz			; $4efd
	call interactionIncState2		; $4efe
	jpab interactionBank08.startJump		; $4f01

@@substate1:
	ld c,$20		; $4f09
	call objectUpdateSpeedZ_paramC		; $4f0b
	ret nz			; $4f0e
	call interactionIncState2		; $4f0f
	call @initializeScript		; $4f12
	dec (hl)		; $4f15
	ret			; $4f16

@@substate2:
	jpab interactionBank08.boyRunSubid03		; $4f17


@subid3:
	call checkInteractionState		; $4f1f
	jr z,@@state0			; $4f22

@@state1:
	jpab interactionBank08.boyRunSubid09		; $4f24

@@state0:
	call @initGraphicsAndIncState		; $4f2c
	ld l,Interaction.counter1		; $4f2f
	ld (hl),$78		; $4f31
	ld l,Interaction.oamFlags		; $4f33
	ld (hl),$02		; $4f35
	jp objectSetVisiblec1		; $4f37

@initGraphicsAndIncState:
	call interactionInitGraphics		; $4f3a
	call objectMarkSolidPosition		; $4f3d
	jp interactionIncState		; $4f40


@initializeGraphicsAndScript:
	call interactionInitGraphics		; $4f43
	call objectMarkSolidPosition		; $4f46

@initializeScript:
	ld a,>TX_2900		; $4f49
	call interactionSetHighTextIndex		; $4f4b

	ld e,Interaction.subid		; $4f4e
	ld a,(de)		; $4f50
	ld hl,@scriptTable		; $4f51
	rst_addDoubleIndex			; $4f54
	ldi a,(hl)		; $4f55
	ld h,(hl)		; $4f56
	ld l,a			; $4f57
	call interactionSetScript		; $4f58
	jp interactionIncState		; $4f5b

@scriptTable:
	.dw boy2Subid0Script
	.dw boy2Subid1Script
	.dw boy2Subid2Script
	.dw stubScript


; ==============================================================================
; INTERACID_SOLDIER
; ==============================================================================
interactionCode40:
	ld e,Interaction.subid		; $4f66
	ld a,(de)		; $4f68
	rst_jumpTable			; $4f69
	.dw _soldierSubid00
	.dw _soldierSubid01
	.dw _soldierSubid02
	.dw _soldierSubid03
	.dw _soldierSubid04
	.dw _soldierSubid05
	.dw _soldierSubid06
	.dw _soldierSubid07
	.dw _soldierSubid08
	.dw _soldierSubid09
	.dw _soldierSubid0a
	.dw _soldierSubid0b
	.dw _soldierSubid0c
	.dw _soldierSubid0d

_soldierSubid00:
_soldierSubid01:
	ld a,GLOBALFLAG_FINISHEDGAME		; $4f86
	call checkGlobalFlag		; $4f88
	jp nz,interactionDelete		; $4f8b

	ld a,GLOBALFLAG_0b		; $4f8e
	call checkGlobalFlag		; $4f90
	ld e,Interaction.var03		; $4f93
	ld a,(de)		; $4f95
	jr nz,_label_09_090	; $4f96
	or a			; $4f98
	jp nz,interactionDelete		; $4f99
	jr _soldierSubid0c		; $4f9c

_label_09_090:
	or a			; $4f9e
	jp z,interactionDelete		; $4f9f


_soldierSubid0c:
	call checkInteractionState		; $4fa2
	jr nz,_label_09_092	; $4fa5
	call _soldierInitGraphicsAndLoadScript		; $4fa7
_label_09_092:
	call interactionRunScript		; $4faa
	jp c,interactionDelete		; $4fad
	jp npcFaceLinkAndAnimate		; $4fb0


; Palace guards
_soldierSubid02:
_soldierSubid09:
	call checkInteractionState		; $4fb3
	jr nz,_label_09_093	; $4fb6
	call _soldierCheckBeatD6		; $4fb8
	jp nc,interactionDelete		; $4fbb
	call _soldierInitGraphicsAndLoadScript		; $4fbe
	call objectSetVisible82		; $4fc1
_label_09_093:
	call objectCheckWithinScreenBoundary		; $4fc4
	jp nc,interactionDelete		; $4fc7
	call _soldierUpdateAnimationAndRunScript		; $4fca
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $4fcd
	ld a,GLOBALFLAG_10		; $4fd0
	call checkGlobalFlag		; $4fd2
	jr z,_label_09_094	; $4fd5
	ld a,GLOBALFLAG_0b		; $4fd7
	call checkGlobalFlag		; $4fd9
	ret z			; $4fdc
_label_09_094:
	jp objectPreventLinkFromPassing		; $4fdd


_soldierSubid03:
	call checkInteractionState		; $4fe0
	jr nz,_label_09_095	; $4fe3
	call _soldierCheckBeatD6		; $4fe5
	jp nc,interactionDelete		; $4fe8
	call _soldierInitGraphicsAndLoadScript		; $4feb
	jp objectSetVisible82		; $4fee
_label_09_095:
	call interactionRunScript		; $4ff1
	jp interactionAnimate		; $4ff4


; Guard who gives bombs to Link
_soldierSubid04:
	call checkInteractionState		; $4ff7
	jr nz,@state1	; $4ffa

@state0:
	call _soldierCheckBeatD6		; $4ffc
	jp nc,interactionDelete		; $4fff
	ld a,GLOBALFLAG_0b		; $5002
	call checkGlobalFlag		; $5004
	jp nz,interactionDelete		; $5007

	call _soldierInitGraphicsAndLoadScript		; $500a
	ld e,Interaction.oamFlags		; $500d
	ld a,$03		; $500f
	ld (de),a		; $5011
	jp objectSetVisiblec2		; $5012

@state1:
	ld e,Interaction.state2		; $5015
	ld a,(de)		; $5017
	rst_jumpTable			; $5018
	.dw _soldierSubid04Substate0
	.dw _soldierSubid04Substate1
	.dw _soldierSubid04Substate2
	.dw _soldierSubid04Substate3
	.dw _soldierSubid04Substate4

_soldierSubid04Substate0:
	ld a,($cfd1)		; $5023
	cp $06			; $5026
	jr nz,_soldierUpdateAnimationAndRunScript	; $5028

	call interactionIncState2		; $502a
	ld l,Interaction.counter1		; $502d
	ld (hl),30		; $502f
	xor a			; $5031
	jp interactionSetAnimation		; $5032

_soldierUpdateAnimationAndRunScript:
	call interactionAnimateBasedOnSpeed		; $5035
	jp interactionRunScript		; $5038

_soldierSubid04Substate1:
	call interactionAnimate		; $503b
	call interactionDecCounter1		; $503e
	ret nz			; $5041
	call interactionIncState2		; $5042
	ld bc,$fe40		; $5045
	call objectSetSpeedZ		; $5048
	ld a,SND_JUMP		; $504b
	jp playSound		; $504d

_soldierSubid04Substate2:
	ld c,$20		; $5050
	call objectUpdateSpeedZ_paramC		; $5052
	ret nz			; $5055
	call interactionIncState2		; $5056
	ld l,Interaction.counter1		; $5059
	ld (hl),$08		; $505b
	ld a,$02		; $505d
	jp interactionSetAnimation		; $505f

_soldierSubid04Substate3:
	call interactionDecCounter1		; $5062
	ret nz			; $5065
	ld l,Interaction.angle		; $5066
	ld (hl),$10		; $5068
	ld l,Interaction.speed		; $506a
	ld (hl),SPEED_200		; $506c
	jp interactionIncState2		; $506e

_soldierSubid04Substate4:
	call objectApplySpeed		; $5071
	call objectCheckWithinScreenBoundary		; $5074
	jp nc,interactionDelete		; $5077
	jp interactionAnimateBasedOnSpeed		; $507a


; Guard escorting Link in intermediate screens (just moves straight up)
_soldierSubid05:
	call checkInteractionState		; $507d
	jr nz,@state1	; $5080

@state0:
	call _soldierCheckBeatD6		; $5082
	jp nc,interactionDelete		; $5085

	ld a,GLOBALFLAG_0b		; $5088
	call checkGlobalFlag		; $508a
	jp nz,interactionDelete		; $508d

	call _soldierInitGraphicsAndLoadScript		; $5090
	xor a			; $5093
	call interactionSetAnimation		; $5094
	ld hl,w1Link.xh		; $5097
	ld (hl),$50		; $509a
	jp objectSetVisible82		; $509c

@state1:
	call objectCheckWithinScreenBoundary		; $509f
	jp nc,interactionDelete		; $50a2
	call objectGetTileAtPosition		; $50a5
	cp TILEINDEX_STAIRS			; $50a8
	ld a,SPEED_100		; $50aa
	jr nz,+			; $50ac
	ld a,SPEED_a0		; $50ae
+
	ld e,Interaction.speed		; $50b0
	ld (de),a		; $50b2
	call interactionRunScript		; $50b3
	jp interactionAnimate2Times		; $50b6


; Guard in cutscene who takes mystery seeds from Link
_soldierSubid06:
	call checkInteractionState		; $50b9
	jr nz,@state1	; $50bc

	call _soldierCheckBeatD6		; $50be
	jp nc,interactionDelete		; $50c1
	ld a,GLOBALFLAG_0b		; $50c4
	call checkGlobalFlag		; $50c6
	jp nz,interactionDelete		; $50c9

	call _soldierInitGraphicsAndLoadScript		; $50cc
	xor a			; $50cf
	call interactionSetAnimation		; $50d0
	jp objectSetVisible82		; $50d3

@state1:
	call checkInteractionState2		; $50d6
	jr nz,@substate1	; $50d9

@substate0:
	ld a,(w1Link.yh)		; $50db
	cp $68			; $50de
	jr nz,@substate1	; $50e0

	xor a			; $50e2
	ld (wUseSimulatedInput),a		; $50e3
	inc a			; $50e6
	ld (wDisabledObjects),a		; $50e7
	call interactionIncState2		; $50ea

@substate1:
	jp _soldierUpdateAnimationAndRunScript		; $50ed


; Guard just after Link is escorted out of the palace
_soldierSubid07:
	call checkInteractionState		; $50f0
	jr nz,@state1	; $50f3

@state0:
	call _soldierCheckBeatD6		; $50f5
	jp nc,interactionDelete		; $50f8
	call _soldierInitGraphicsAndLoadScript		; $50fb
	jp objectSetVisible82		; $50fe

@state1:
	call interactionRunScript		; $5101
	jp interactionAnimateAsNpc		; $5104


; Used in a cutscene? (doesn't do anything)
_soldierSubid08:
	call checkInteractionState		; $5107
	jr nz,@state1		; $510a

@state0:
	call _soldierInitGraphics		; $510c
	ld l,Interaction.oamFlags		; $510f
	ld (hl),$03		; $5111
	jp objectSetVisible82		; $5113

@state1:
	callab scriptHlp.turnToFaceSomething		; $5116
	jp interactionAnimate		; $511e


; Red soldier that brings you to Ambi (escorts you from deku forest)
_soldierSubid0a:
	call checkInteractionState		; $5121
	jr nz,@state1		; $5124

@state0:
	call _soldierInitGraphicsAndLoadScript		; $5126
	ld l,Interaction.oamFlags		; $5129
	ld (hl),$02		; $512b
	ld bc,$68f0		; $512d
	jp interactionSetPosition		; $5130

@state1:
	call _soldierUpdateAnimationAndRunScript		; $5133
	ret nc			; $5136
	ld hl,wcc05		; $5137
	set 1,(hl)		; $513a
	ld hl,@warpDest		; $513c
	jp setWarpDestVariables		; $513f

@warpDest:
	m_HardcodedWarpA ROOM_AGES_146, $00, $34, $03


; Red soldier that brings you to Ambi (just standing there after taking you)
_soldierSubid0b:
	call checkInteractionState		; $5147
	jp nz,interactionAnimate		; $514a

@state0:
	ld a,GLOBALFLAG_0b		; $514d
	call checkGlobalFlag		; $514f
	jp nz,interactionDelete		; $5152

	ld a,TREASURE_MYSTERY_SEEDS		; $5155
	call checkTreasureObtained		; $5157
	jp nc,interactionDelete		; $515a

	call _soldierInitGraphics		; $515d
	ld l,Interaction.oamFlags		; $5160
	ld (hl),$02		; $5162
	ld a,$01		; $5164
	call interactionSetAnimation		; $5166
	jp objectSetVisible82		; $5169


; Friendly soldier after finishing game. var03 is soldier index.
_soldierSubid0d:
	call checkInteractionState		; $516c
	jr nz,@state1		; $516f

@state0:
	ld a,GLOBALFLAG_FINISHEDGAME		; $5171
	call checkGlobalFlag		; $5173
	jp z,interactionDelete		; $5176

	call _soldierInitGraphicsAndLoadScript		; $5179
	ld e,Interaction.var03		; $517c
	ld a,(de)		; $517e
	ld l,Interaction.oamFlags		; $517f
	ld (hl),$01		; $5181
	cp $07			; $5183
	jr c,+			; $5185
	inc (hl)		; $5187
+
	ld bc,@behaviours		; $5188
	call addAToBc		; $518b
	ld a,(bc)		; $518e
	ld l,Interaction.var3b		; $518f
	ld (hl),a		; $5191
	call interactionRunScript		; $5192
	jr @state1		; $5195

@behaviours:
	.db $01 $02 $00 $00 $00 $00 $00 $03
	.db $00 $00 $00 $00 $00 $00 $00 $00

@state1:
	call interactionRunScript		; $51a7
	jp c,interactionDelete		; $51aa

	ld e,Interaction.var3b		; $51ad
	ld a,(de)		; $51af
	or a			; $51b0
	jr nz,++		; $51b1
	call interactionRunScript		; $51b3
	jp c,interactionDelete		; $51b6
	jp npcFaceLinkAndAnimate		; $51b9
++
	ld e,Interaction.var3f		; $51bc
	ld a,(de)		; $51be
	or a			; $51bf
	jp z,npcFaceLinkAndAnimate		; $51c0

	call interactionAnimateBasedOnSpeed		; $51c3
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $51c6


_soldierInitGraphics:
	call interactionInitGraphics		; $51c9
	call objectMarkSolidPosition		; $51cc
	jp interactionIncState		; $51cf


_soldierInitGraphicsAndLoadScript:
	call interactionInitGraphics		; $51d2
	call objectMarkSolidPosition		; $51d5
	ld e,Interaction.subid		; $51d8
	ld a,(de)		; $51da
	ld hl,_soldierScriptTable		; $51db
	rst_addDoubleIndex			; $51de
	ldi a,(hl)		; $51df
	ld h,(hl)		; $51e0
	ld l,a			; $51e1
	call interactionSetScript		; $51e2
	jp interactionIncState		; $51e5


linkEnterPalaceSimulatedInput:
	dwb $7fff BTN_UP
	.dw $ffff

linkExitPalaceSimulatedInput
	dwb 30    $00
	dwb 40    BTN_DOWN
	dwb $7fff $00
	.dw $ffff

;;
; @param[out]	cflag	nc if dungeon 6 is beaten (can enter the palace)
; @addr{51f8}
_soldierCheckBeatD6:
	ld a,TREASURE_ESSENCE		; $51f8
	call checkTreasureObtained		; $51fa
	jr nc,++		; $51fd
	call getHighestSetBit		; $51ff
	cp $05			; $5202
	ret			; $5204
++
	scf			; $5205
	ret			; $5206

; @addr{5207}
_soldierScriptTable:
	.dw soldierSubid00Script
	.dw soldierSubid01Script
	.dw soldierSubid02Script
	.dw soldierSubid03Script
	.dw soldierSubid04Script
	.dw soldierSubid05Script
	.dw soldierSubid06Script
	.dw soldierSubid07Script
	.dw stubScript
	.dw soldierSubid09Script
	.dw soldierSubid0aScript
	.dw stubScript
	.dw soldierSubid0cScript
	.dw soldierSubid0dScript

; ==============================================================================
; INTERACID_MISC_MAN
; ==============================================================================
interactionCode41:
	ld e,Interaction.subid		; $5223
	ld a,(de)		; $5225
	rst_jumpTable			; $5226
	.dw @subid0
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero

@subid0:
	call checkInteractionState		; $5235
	jr nz,++		; $5238
	ld a,GLOBALFLAG_FINISHEDGAME		; $523a
	call checkGlobalFlag		; $523c
	jp nz,interactionDelete		; $523f
	ld a,GLOBALFLAG_0b		; $5242
	call checkGlobalFlag		; $5244
	jp nz,interactionDelete		; $5247
	call @initGraphicsIncStateAndLoadScript		; $524a
++
	call interactionRunScript		; $524d
	jp npcFaceLinkAndAnimate		; $5250

@subidNonzero:
	call checkInteractionState		; $5253
	jr nz,@@initialized	; $5256

	ld a,$01		; $5258
	ld e,Interaction.oamFlags		; $525a
	ld (de),a		; $525c

	callab getGameProgress_1		; $525d
	ld e,Interaction.subid		; $5265
	ld a,(de)		; $5267
	dec a			; $5268
	cp b			; $5269
	jp nz,interactionDelete		; $526a

	ld hl,@scriptTable+2		; $526d
	rst_addDoubleIndex			; $5270
	ldi a,(hl)		; $5271
	ld h,(hl)		; $5272
	ld l,a			; $5273
	call interactionSetScript		; $5274

	ld a,>TX_2600		; $5277
	call interactionSetHighTextIndex		; $5279
	call @initGraphicsAndIncState		; $527c

@@initialized:
	call interactionRunScript		; $527f
	jp interactionAnimateAsNpc		; $5282

@initGraphicsAndIncState:
	call interactionInitGraphics		; $5285
	call objectMarkSolidPosition		; $5288
	jp interactionIncState		; $528b

;;
; @addr{528e}
@initGraphicsIncStateAndLoadScript:
	call interactionInitGraphics		; $528e
	call objectMarkSolidPosition		; $5291
	ld a,>TX_2600		; $5294
	call interactionSetHighTextIndex		; $5296
	ld e,Interaction.subid		; $5299
	ld a,(de)		; $529b
	ld hl,@scriptTable		; $529c
	rst_addDoubleIndex			; $529f
	ldi a,(hl)		; $52a0
	ld h,(hl)		; $52a1
	ld l,a			; $52a2
	call interactionSetScript		; $52a3
	jp interactionIncState		; $52a6

; @addr{52a9}
@scriptTable:
	.dw manOutsideD2Script
	.dw lynnaManScript_befored3
	.dw lynnaManScript_afterd3
	.dw lynnaManScript_afterNayruSaved
	.dw lynnaManScript_afterd7
	.dw lynnaManScript_afterGotMakuSeed
	.dw lynnaManScript_postGame


; ==============================================================================
; INTERACID_MUSTACHE_MAN
; ==============================================================================
interactionCode42:
	ld e,Interaction.subid		; $52b7
	ld a,(de)		; $52b9
	rst_jumpTable			; $52ba
	.dw @subid0
	.dw @subid1

@subid0:
	call checkInteractionState		; $52bf
	jr nz,@@initialized	; $52c2

	ld a,GLOBALFLAG_FINISHEDGAME		; $52c4
	call checkGlobalFlag		; $52c6
	jp nz,interactionDelete		; $52c9
	call @initGraphicsAndScript		; $52cc
@@initialized:
	call interactionRunScript		; $52cf
	jp interactionAnimateAsNpc		; $52d2

@subid1:
	call checkInteractionState		; $52d5
	jr nz,@@initialized	; $52d8

	ld e,Interaction.var32		; $52da
	ld a,$02		; $52dc
	ld (de),a		; $52de
	call @initGraphicsAndScript		; $52df

@@initialized:
	call interactionRunScript		; $52e2
	jp interactionAnimateAsNpc		; $52e5

; Unused
@func_52e8:
	call interactionInitGraphics		; $52e8
	call objectMarkSolidPosition		; $52eb
	jp interactionIncState		; $52ee

@initGraphicsAndScript:
	call interactionInitGraphics		; $52f1
	call objectMarkSolidPosition		; $52f4

	ld a,>TX_0f00		; $52f7
	call interactionSetHighTextIndex		; $52f9

	ld e,Interaction.subid		; $52fc
	ld a,(de)		; $52fe
	ld hl,@scriptTable		; $52ff
	rst_addDoubleIndex			; $5302
	ldi a,(hl)		; $5303
	ld h,(hl)		; $5304
	ld l,a			; $5305
	call interactionSetScript		; $5306
	jp interactionIncState		; $5309

@scriptTable:
	.dw mustacheManScript
	.dw genericNpcScript


; ==============================================================================
; INTERACID_PAST_GUY
; ==============================================================================
interactionCode43:
	ld e,Interaction.subid		; $5310
	ld a,(de)		; $5312
	rst_jumpTable			; $5313
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7

; Guy who wants to find something Ambi desires
@subid0:
	ld a,GLOBALFLAG_FINISHEDGAME		; $5324
	call checkGlobalFlag		; $5326
	jp nz,interactionDelete		; $5329

	ld a,GLOBALFLAG_0b		; $532c
	call checkGlobalFlag		; $532e
	ld e,Interaction.var03		; $5331
	ld a,(de)		; $5333
	jr nz,+			; $5334
	or a			; $5336
	jp nz,interactionDelete		; $5337
	jr ++			; $533a
+
	or a			; $533c
	jp z,interactionDelete		; $533d
++
	call checkInteractionState		; $5340
	jr nz,+			; $5343
	call @initGraphicsIncStateAndLoadScript		; $5345
+
	call interactionRunScript		; $5348
	jp interactionAnimateAsNpc		; $534b

@subid1:
@subid2:
	call checkInteractionState		; $534e
	jr nz,@label_09_117	; $5351

	callab getGameProgress_2		; $5353
	ld c,$01		; $535b
	ld a,$05		; $535d
	call checkNpcShouldExistAtGameStage		; $535f
	jp nz,interactionDelete		; $5362

	ld a,b			; $5365
	ld hl,@subid1And2ScriptTable		; $5366
	rst_addDoubleIndex			; $5369
	ldi a,(hl)		; $536a
	ld h,(hl)		; $536b
	ld l,a			; $536c
	call interactionSetScript		; $536d

	ld a,>TX_1700		; $5370
	call interactionSetHighTextIndex		; $5372
	call @initGraphicsAndIncState		; $5375
	ld a,$03		; $5378
	ld e,Interaction.oamFlags		; $537a
	ld (de),a		; $537c

@label_09_117:
	call interactionRunScript		; $537d
	jp interactionAnimateAsNpc		; $5380


; Guy in a cutscene (turning to stone?)
@subid3:
	call checkInteractionState		; $5383
	jr nz,+			; $5386
	call @initGraphicsIncStateAndLoadScript		; $5388
	jp objectSetVisiblec2		; $538b
+
	call interactionRunScript		; $538e
	ld a,($cfd1)		; $5391
	cp $02			; $5394
	jp c,interactionAnimate		; $5396
	ret			; $5399


; Guy in a cutscene (stuck as stone?)
@subid4:
	call checkInteractionState		; $539a
	ret nz			; $539d

	call @initGraphicsAndIncState		; $539e
	ld l,Interaction.oamFlags		; $53a1
	ld (hl),$06		; $53a3
	jp objectSetVisible82		; $53a5


; Guy in a cutscene (being restored from stone?)
@subid5:
	call checkInteractionState		; $53a8
	jr nz,@@initialized	; $53ab

	call @initGraphicsIncStateAndLoadScript		; $53ad
	ld l,Interaction.oamFlags		; $53b0
	ld (hl),$06		; $53b2
	jp objectSetVisiblec2		; $53b4

@@initialized:
	ld e,Interaction.state2		; $53b7
	ld a,(de)		; $53b9
	rst_jumpTable			; $53ba
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,($cfd1)		; $53c1
	cp $01			; $53c4
	ret nz			; $53c6
	jpab interactionBank08.setCounter1To120AndPlaySoundEffectAndIncState2		; $53c7

@@substate1:
	call interactionDecCounter1		; $53cf
	jr z,+			; $53d2
	jpab interactionBank08.childFlickerBetweenStone		; $53d4
+
	call interactionIncState2		; $53dc
	ld l,Interaction.oamFlags		; $53df
	ld (hl),$02		; $53e1

	ld l,Interaction.counter1		; $53e3
	ld (hl),$a4		; $53e5
	inc l			; $53e7
	ld (hl),$01		; $53e8
	ret			; $53ea

@@substate2:
	call interactionAnimate		; $53eb
	ld l,Interaction.counter1		; $53ee
	call decHlRef16WithCap		; $53f0
	ret nz			; $53f3
	ld a,$ff		; $53f4
	ld ($cfdf),a		; $53f6
	ret			; $53f9


; Guy watching family play catch (or is stone)
@subid6:
	call checkInteractionState		; $53fa
	jr nz,@initialized	; $53fd
	ld hl,wGroup4Flags+$fc		; $53ff
	bit 7,(hl)		; $5402
	jr nz,@@initAndLoadScript	; $5404

	ld a,(wEssencesObtained)		; $5406
	bit 6,a			; $5409
	jr z,@@initAndLoadScript	; $540b

	; He's stone, set the palette accordingly.
	call @initGraphicsAndIncState		; $540d
	ld l,Interaction.oamFlags		; $5410
	ld (hl),$06		; $5412
	ld l,Interaction.var03		; $5414
	inc (hl)		; $5416

	ld a,$06		; $5417
	call objectSetCollideRadius		; $5419
	jr @initialized		; $541c

@@initAndLoadScript:
	call @initGraphicsIncStateAndLoadScript		; $541e

@initialized:
	ld e,Interaction.var03		; $5421
	ld a,(de)		; $5423
	or a			; $5424
	jp nz,interactionPushLinkAwayAndUpdateDrawPriority		; $5425
	call interactionRunScript		; $5428
	jp c,interactionDelete		; $542b
	jp interactionAnimateAsNpc		; $542e

@subid7:
	call checkInteractionState		; $5431
	jp z,+		; $5434
	ret			; $5437
+
	call @initGraphicsAndIncState		; $5438
	ld l,Interaction.oamFlags		; $543b
	ld (hl),$06		; $543d
	jp objectSetVisiblec2		; $543f

@initGraphicsAndIncState:
	call interactionInitGraphics		; $5442
	call objectMarkSolidPosition		; $5445
	jp interactionIncState		; $5448


@initGraphicsIncStateAndLoadScript:
	call interactionInitGraphics		; $544b
	call objectMarkSolidPosition		; $544e

	ld a,>TX_1700		; $5451
	call interactionSetHighTextIndex		; $5453

	ld e,Interaction.subid		; $5456
	ld a,(de)		; $5458
	ld hl,@scriptTable		; $5459
	rst_addDoubleIndex			; $545c
	ldi a,(hl)		; $545d
	ld h,(hl)		; $545e
	ld l,a			; $545f
	call interactionSetScript		; $5460
	jp interactionIncState		; $5463

; @addr{5466}
@scriptTable:
	.dw pastGuySubid0Script
	.dw stubScript
	.dw stubScript
	.dw pastGuySubid3Script
	.dw stubScript
	.dw stubScript
	.dw pastGuySubid6Script

; @addr{5474}
@subid1And2ScriptTable:
	.dw pastGuySubid1And2Script_befored4
	.dw pastGuySubid1And2Script_befored4
	.dw pastGuySubid1And2Script_afterd4
	.dw pastGuySubid1And2Script_afterNayruSaved
	.dw pastGuySubid1And2Script_afterd7
	.dw pastGuySubid1And2Script_afterGotMakuSeed
	.dw pastGuySubid1And2Script_afterGotMakuSeed
	.dw pastGuySubid1And2Script_afterGotMakuSeed


; ==============================================================================
; INTERACID_MISC_MAN_2
; ==============================================================================
interactionCode44:
	ld e,Interaction.subid		; $5484
	ld a,(de)		; $5486
	rst_jumpTable			; $5487
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

; NPC giving hint about what ambi wants
@subid0:
	call checkInteractionState		; $5492
	jr nz,@@initialized	; $5495

	ld a,GLOBALFLAG_FINISHEDGAME		; $5497
	call checkGlobalFlag		; $5499
	jp nz,interactionDelete		; $549c
	call @initGraphicsIncStateAndLoadScript		; $549f

@@initialized:
	call interactionRunScript		; $54a2
	jp c,interactionDelete		; $54a5
	jp interactionAnimateAsNpc		; $54a8


; NPC in start-of-game cutscene who turns into an old man
@subid1:
	call checkInteractionState		; $54ab
	jr nz,+			; $54ae
	call @initGraphicsIncStateAndLoadScript		; $54b0
+
	call interactionRunScript		; $54b3
	jp interactionAnimateBasedOnSpeed		; $54b6


; Bearded NPC in Lynna City
@subid2:
@subid3:
	call checkInteractionState		; $54b9
	jr nz,@@initialized	; $54bc

	call getGameProgress_1		; $54be
	ld c,$02		; $54c1
	ld a,$06		; $54c3
	call checkNpcShouldExistAtGameStage_body		; $54c5
	jp nz,interactionDelete		; $54c8

	ld a,b			; $54cb
	ld hl,lynnaMan2ScriptTable		; $54cc
	rst_addDoubleIndex			; $54cf
	ldi a,(hl)		; $54d0
	ld h,(hl)		; $54d1
	ld l,a			; $54d2
	call interactionSetScript		; $54d3
	call @initGraphicsAndIncState		; $54d6

@@initialized:
	call interactionRunScript		; $54d9
	jp interactionAnimateAsNpc		; $54dc


; Bearded hobo in the past, outside shooting gallery
@subid4:
	call checkInteractionState		; $54df
	jr nz,@@initialized	; $54e2
	call getGameProgress_2		; $54e4
	ld a,b			; $54e7
	cp $03			; $54e8
	jp z,interactionDelete		; $54ea

	cp $06			; $54ed
	jr nz,++		; $54ef

	ld bc,$5878		; $54f1
	call interactionSetPosition		; $54f4
	ld a,$06		; $54f7
++
	ld hl,pastHoboScriptTable		; $54f9
	rst_addDoubleIndex			; $54fc
	ldi a,(hl)		; $54fd
	ld h,(hl)		; $54fe
	ld l,a			; $54ff
	call interactionSetScript		; $5500
	call @initGraphicsAndIncState		; $5503

@@initialized:
	call interactionRunScript		; $5506
	jp interactionAnimateAsNpc		; $5509


@initGraphicsAndIncState:
	call interactionInitGraphics		; $550c
	call objectMarkSolidPosition		; $550f
	jp interactionIncState		; $5512


@initGraphicsIncStateAndLoadScript:
	call interactionInitGraphics		; $5515
	call objectMarkSolidPosition		; $5518
	ld e,Interaction.subid		; $551b
	ld a,(de)		; $551d
	ld hl,miscMan2ScriptTable		; $551e
	rst_addDoubleIndex			; $5521
	ldi a,(hl)		; $5522
	ld h,(hl)		; $5523
	ld l,a			; $5524
	call interactionSetScript		; $5525
	jp interactionIncState		; $5528

;;
; @param[out]	b	$00 before beating d3;
;			$01 if beat d3
;			$02 if saved Nayru;
;			$03 if beat d7;
;			$04 if got the maku seed (saw twinrova cutscene);
;			$05 if game finished (unlinked only)
; @addr{552b}
getGameProgress_1:
	ld b,$05		; $552b
	ld a,GLOBALFLAG_FINISHEDGAME		; $552d
	call checkGlobalFlag		; $552f
	ret nz			; $5532

	dec b			; $5533
	ld a,GLOBALFLAG_SAW_TWINROVA_BEFORE_ENDGAME		; $5534
	call checkGlobalFlag		; $5536
	ret nz			; $5539

	ld a,TREASURE_ESSENCE		; $553a
	call checkTreasureObtained		; $553c
	jr nc,@noEssences	; $553f

	call getHighestSetBit		; $5541
	ld c,a			; $5544
	ld b,$03		; $5545
	cp $06			; $5547
	ret nc			; $5549

	dec b			; $554a
	ld a,GLOBALFLAG_SAVED_NAYRU		; $554b
	call checkGlobalFlag		; $554d
	ret nz			; $5550

	dec b			; $5551
	ld a,c			; $5552
	cp $02			; $5553
	ret nc			; $5555

@noEssences:
	ld b,$00		; $5556
	ret			; $5558

;;
; @param[out]	b	$00 before beating d2;
;			$01 if beat d2;
;			$02 if beat d4;
;			$03 if saved nayru;
;			$04 if beat d7;
;			$05 if got the maku seed (saw twinrova cutscene);
;			$06 if beat veran but not twinrova (linked only);
;			$07 if game finished (unlinked only)
; @addr{5559}
getGameProgress_2:
	ld b,$07		; $5559
	ld a,GLOBALFLAG_FINISHEDGAME		; $555b
	call checkGlobalFlag		; $555d
	ret nz			; $5560

	dec b			; $5561
	call checkIsLinkedGame		; $5562
	jr z,+			; $5565
	ld hl,wGroup4Flags+$fc		; $5567
	bit 7,(hl)		; $556a
	ret nz			; $556c
+
	dec b			; $556d
	ld a,GLOBALFLAG_SAW_TWINROVA_BEFORE_ENDGAME		; $556e
	call checkGlobalFlag		; $5570
	ret nz			; $5573

	ld a,TREASURE_ESSENCE		; $5574
	call checkTreasureObtained		; $5576
	jr nc,@noEssences	; $5579

	call getHighestSetBit		; $557b
	ld c,a			; $557e
	ld b,$04		; $557f
	cp $06			; $5581
	ret nc			; $5583

	dec b			; $5584
	ld a,GLOBALFLAG_SAVED_NAYRU		; $5585
	call checkGlobalFlag		; $5587
	ret nz			; $558a

	dec b			; $558b
	ld a,c			; $558c
	cp $03			; $558d
	ret nc			; $558f
	dec b			; $5590
	ld a,c			; $5591
	cp $01			; $5592
	ret nc			; $5594

@noEssences:
	ld b,$00		; $5595
	ret			; $5597


;;
; @addr{5598}
_unusedFunc5598:
	ld a,b			; $5598
	ld hl,lynnaMan2ScriptTable		; $5599
	rst_addDoubleIndex			; $559c
	ldi a,(hl)		; $559d
	ld h,(hl)		; $559e
	ld l,a			; $559f
	call interactionSetScript		; $55a0
	jp interactionIncState		; $55a3

;;
; Contains some preset data for checking whether certain interactions should exist at
; certain points in the game?
;
; @param	a	(0-8)
; @param	b	Return value from "getGameProgress_1"?
; @param	c	Subid "base"
; @param[out]	zflag	Set if the npc should exist
; @addr{55a6}
checkNpcShouldExistAtGameStage_body:
	ld hl,@table		; $55a6
	rst_addDoubleIndex			; $55a9
	ldi a,(hl)		; $55aa
	ld h,(hl)		; $55ab
	ld l,a			; $55ac

	ld e,Interaction.subid		; $55ad
	ld a,(de)		; $55af
	sub c			; $55b0
	rst_addDoubleIndex			; $55b1

	ldi a,(hl)		; $55b2
	ld h,(hl)		; $55b3
	ld l,a			; $55b4
--
	ldi a,(hl)		; $55b5
	cp b			; $55b6
	ret z			; $55b7
	inc a			; $55b8
	jr z,+			; $55b9
	jr --			; $55bb
+
	or $01			; $55bd
	ret			; $55bf

@table:
	.dw @data0
	.dw @data1
	.dw @data2
	.dw @data3
	.dw @data4
	.dw @data5
	.dw @data6

@data0: ; INTERACID_FEMALE_VILLAGER subids 1-2
	.dw @@subid1
	.dw @@subid2
@@subid1:
	.db $00 $01 $02 $ff
@@subid2:
	.db $03 $04 $05 $ff


@data1: ; INTERACID_FEMALE_VILLAGER subids 3-4
	.dw @@subid3
	.dw @@subid4
@@subid3:
	.db $00 $02 $03 $04 $05 $06 $07 $ff
@@subid4:
	.db $01 $ff


@data2: ; INTERACID_FEMALE_VILLAGER subid 5
	.dw @@subid5
@@subid5:
	.db $00 $01 $02 $03 $05 $06 $ff


@data3: ; INTERACID_VILLAGER subids 4-5
	.dw @@subid4
	.dw @@subid5
@@subid4:
	.db $00 $01 $05 $ff
@@subid5:
	.db $04 $ff


@data4: ; INTERACID_VILLAGER subids 6-7
	.dw @@subid6
	.dw @@subid7

@@subid6:
	.db $00 $01 $02 $ff
@@subid7:
	.db $03 $04 $05 $06 $07 $ff


@data5: ; INTERACID_PAST_GUY subids 1-2
	.dw @@subid1
	.dw @@subid2

@@subid1:
	.db $01 $02 $ff
@@subid2:
	.db $03 $04 $07 $ff


@data6: ; INTERACID_MISC_MAN_2 subids 2-3
	.dw @@subid2
	.dw @@subid3
@@subid2:
	.db $00 $01 $02 $ff
@@subid3:
	.db $03 $04 $05 $ff



miscMan2ScriptTable:
	.dw pastHobo2Script
	.dw npcTurnedToOldManCutsceneScript
	.dw stubScript
	.dw stubScript
	.dw stubScript

lynnaMan2ScriptTable:
	.dw lynnaMan2Script_befored3
	.dw lynnaMan2Script_afterd3
	.dw lynnaMan2Script_afterNayruSaved
	.dw lynnaMan2Script_afterd7
	.dw lynnaMan2Script_afterGotMakuSeed
	.dw lynnaMan2Script_postGame

pastHoboScriptTable:
	.dw pastHoboScript_befored2
	.dw pastHoboScript_afterd2
	.dw pastHoboScript_afterd4
	.dw pastHoboScript_afterSavedNayru
	.dw pastHoboScript_afterSavedNayru
	.dw pastHoboScript_afterGotMakuSeed
	.dw pastHoboScript_twinrovaKidnappedZelda
	.dw pastHoboScript_postGame


; ==============================================================================
; INTERACID_PAST_OLD_LADY
; ==============================================================================
interactionCode45:
	ld e,Interaction.subid		; $5646
	ld a,(de)		; $5648
	rst_jumpTable			; $5649
	.dw @subid0
	.dw @subid1


; Lady whose husband was sent to work on black tower
@subid0:
	call checkInteractionState		; $564e
	jr nz,@@initialized	; $5651

	ld a,GLOBALFLAG_FINISHEDGAME		; $5653
	call checkGlobalFlag		; $5655
	jp nz,interactionDelete		; $5658
	call @initGraphicsTextAndScript		; $565b

@@initialized:
	call interactionRunScript		; $565e
	jp interactionAnimateAsNpc		; $5661


@subid1:
	call checkInteractionState		; $5664
	jr nz,@@initialized			; $5667

	callab getGameProgress_2		; $5669
	ld a,b			; $5671
	cp $04			; $5672
	jp nc,interactionDelete		; $5674

	ld hl,@subid1ScriptTable		; $5677
	rst_addDoubleIndex			; $567a
	ldi a,(hl)		; $567b
	ld h,(hl)		; $567c
	ld l,a			; $567d
	call interactionSetScript		; $567e

	ld a,>TX_1800		; $5681
	call interactionSetHighTextIndex		; $5683
	call @initGraphicsAndIncState		; $5686

@@initialized:
	call interactionRunScript		; $5689
	jp interactionAnimateAsNpc		; $568c


@initGraphicsAndIncState:
	call interactionInitGraphics		; $568f
	call objectMarkSolidPosition		; $5692
	jp interactionIncState		; $5695


@initGraphicsTextAndScript:
	call interactionInitGraphics		; $5698
	call objectMarkSolidPosition		; $569b
	ld a,>TX_1800		; $569e
	call interactionSetHighTextIndex		; $56a0
	ld e,Interaction.subid		; $56a3
	ld a,(de)		; $56a5
	ld hl,@scriptTable		; $56a6
	rst_addDoubleIndex			; $56a9
	ldi a,(hl)		; $56aa
	ld h,(hl)		; $56ab
	ld l,a			; $56ac
	call interactionSetScript		; $56ad
	jp interactionIncState		; $56b0


@scriptTable:
	.dw pastOldLadySubid0Script
	.dw stubScript

@subid1ScriptTable:
	.dw pastOldLadySubid1Script_befored2
	.dw pastOldLadySubid1Script_afterd2
	.dw pastOldLadySubid1Script_afterd4
	.dw pastOldLadySubid1Script_afterSavedNayru


; ==============================================================================
; INTERACID_TOKAY
; ==============================================================================
interactionCode48:
	ld e,Interaction.state		; $56bf
	ld a,(de)		; $56c1
	rst_jumpTable			; $56c2
	.dw @state0
	.dw _tokayState1

@state0:
	ld a,$01		; $56c7
	ld (de),a		; $56c9
	call interactionInitGraphics		; $56ca
	call objectSetVisiblec2		; $56cd

	ld a,>TX_0a00		; $56d0
	call interactionSetHighTextIndex		; $56d2

	call @initSubid		; $56d5

	ld e,Interaction.enabled		; $56d8
	ld a,(de)		; $56da
	or a			; $56db
	jp nz,objectMarkSolidPosition		; $56dc
	ret			; $56df

@initSubid:
	ld e,Interaction.subid		; $56e0
	ld a,(de)		; $56e2
	rst_jumpTable			; $56e3
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @initSubid06
	.dw @initSubid07
	.dw @initSubid08
	.dw @initSubid09
	.dw @initSubid0a
	.dw @initSubid0b
	.dw @initSubid0c
	.dw @initSubid0d
	.dw @initSubid0e
	.dw @initSubid0f
	.dw @initSubid10
	.dw @initSubid11
	.dw @initSubid12
	.dw @initSubid13
	.dw @initSubid14
	.dw @initSubid15
	.dw @initSubid16
	.dw @initSubid17
	.dw @initSubid18
	.dw @initSubid19
	.dw @initSubid1a
	.dw @initSubid1b
	.dw @initSubid1c
	.dw @initSubid1d
	.dw @initSubid1e
	.dw @initSubid1f


; Subid $00-$04: Tokays who rob Link

@initSubid00:
@initSubid03:
	ld a,$01		; $5724
	jr @initLinkRobberyTokay		; $5726

@initSubid01:
@initSubid04:
	ld a,$03		; $5728
	jr @initLinkRobberyTokay		; $572a

@initSubid02:
	call getThisRoomFlags		; $572c
	bit 6,a			; $572f
	jp nz,@deleteSelf		; $5731

	xor a			; $5734
	call interactionSetAnimation		; $5735
	call _tokayLoadScript		; $5738

	; Set the Link object to run the cutscene where he gets mugged
	ld a,SPECIALOBJECTID_LINK_CUTSCENE		; $573b
	call setLinkIDOverride		; $573d
	ld l,<w1Link.subid		; $5740
	ld (hl),$07		; $5742

	ld e,Interaction.var38		; $5744
	ld a,$46		; $5746
	ld (de),a		; $5748

	ld a,SNDCTRL_STOPMUSIC		; $5749
	jp playSound		; $574b

@initLinkRobberyTokay:
	call interactionSetAnimation		; $574e
	call getThisRoomFlags		; $5751
	bit 6,a			; $5754
	jp nz,@deleteSelf		; $5756
	jp _tokayLoadScript		; $5759


; NPC holding shield upgrade
@initSubid1d:
	call _tokayLoadScript		; $575c
	call getThisRoomFlags		; $575f
	bit 6,a			; $5762
	ld a,$02		; $5764
	jp nz,interactionSetAnimation		; $5766

	; Set up an "accessory" object (the shield he's holding)
	ld b,$14		; $5769
	ld a,(wShieldLevel)		; $576b
	cp $02			; $576e
	jr c,+			; $5770
	ld b,$15		; $5772
+
	ld a,b			; $5774
	ld e,Interaction.var03		; $5775
	ld (de),a		; $5777
	call getFreeInteractionSlot		; $5778
	ret nz			; $577b

	inc l			; $577c
	ld (hl),b ; [subid] = b (graphic for the accessory)
	dec l			; $577e
	call _tokayInitAccessory		; $577f

	ld a,$06		; $5782
	jp interactionSetAnimation		; $5784


; Past NPC holding shovel
@initSubid07:
	call checkIsLinkedGame		; $5787
	jp nz,interactionDelete		; $578a

; Past NPC holding something (sword, harp, etc)
@initSubid06:
@initSubid08:
@initSubid09:
@initSubid0a:
	call _tokayLoadScript		; $578d

	; Set var03 to the item being held
	ld h,d			; $5790
	ld l,Interaction.subid		; $5791
	ld a,(hl)		; $5793
	sub $06			; $5794
	ld bc,tokayIslandStolenItems		; $5796
	call addAToBc		; $5799
	ld a,(bc)		; $579c
	ld l,Interaction.var03		; $579d
	ld (hl),a		; $579f

	; Check if the item has been retrieved already
	ld c,$00		; $57a0
	call getThisRoomFlags		; $57a2
	bit 6,a			; $57a5
	jr z,@@endLoop			; $57a7

	; Check if Link is still missing any items.
	inc c			; $57a9
	ld b,$09		; $57aa
@@nextItem:
	ld a,b			; $57ac
	dec a			; $57ad

	ld hl,tokayIslandStolenItems		; $57ae
	rst_addAToHl			; $57b1
	ld a,(hl)		; $57b2
	cp TREASURE_SHIELD			; $57b3
	jr z,+			; $57b5

	call checkTreasureObtained		; $57b7
	jp nc,@@endLoop		; $57ba
+
	dec b			; $57bd
	jr nz,@@nextItem	; $57be
	inc c			; $57c0

@@endLoop:
	; var3c gets set to:
	; * 0 if Link hasn't retrieved this tokay's item yet;
	; * 1 if Link has retrieved the item, but others are still missing;
	; * 2 if Link has retrieved all of his items from the tokays.
	ld a,c			; $57c1
	ld e,Interaction.var3c		; $57c2
	ld (de),a		; $57c4
	or a			; $57c5
	jr nz,@@retrievedItem	; $57c6

; Link has not retrieved this tokay's item yet.

	ld a,$06		; $57c8
	call interactionSetAnimation		; $57ca

	ld e,Interaction.subid		; $57cd
	ld a,(de)		; $57cf
	ld b,<TX_0a0a		; $57d0

	; Shovel NPC says something a bit different
	cp $07			; $57d2
	jr z,+			; $57d4
	ld b,<TX_0a0b		; $57d6
+
	ld h,d			; $57d8
	ld l,Interaction.textID		; $57d9
	ld (hl),b		; $57db
	sub $06			; $57dc
	ld b,a			; $57de
	jp _tokayInitHeldItem		; $57df

@@retrievedItem:
	ld a,$02		; $57e2
	jp interactionSetAnimation		; $57e4


; Past NPC looking after scent seedling
@initSubid11:
	call getThisRoomFlags		; $57e7
	bit 7,a			; $57ea
	jr z,@initSubid0e	; $57ec

	; Seedling has been planted
	ld e,Interaction.xh		; $57ee
	ld a,(de)		; $57f0
	add $10			; $57f1
	ld (de),a		; $57f3
	call objectMarkSolidPosition		; $57f4
	jr @initSubid0e		; $57f7


; Present NPC who talks to you after climbing down vine
@initSubid1e:
	call objectMakeTileSolid		; $57f9
	ld h,>wRoomLayout		; $57fc
	ld (hl),$00		; $57fe
	jr @initSubid0e		; $5800


; Subid $0f-$10: Tokays who try to eat Dimitri
@initSubid0f:
	ld a,$01		; $5802
	jr ++			; $5804

@initSubid10:
	xor a			; $5806
++
	call interactionSetAnimation		; $5807

	ld hl,wDimitriState		; $580a
	bit 1,(hl)		; $580d
	jr nz,@deleteSelf	; $580f

	ld l,<wEssencesObtained		; $5811
	bit 2,(hl)		; $5813
	jr z,@deleteSelf	; $5815

	ld e,Interaction.speed		; $5817
	ld a,SPEED_200		; $5819
	ld (de),a		; $581b
	; Fall through


; Shopkeeper (trades items)
@initSubid0e:
	ld a,$06		; $581c
	call objectSetCollideRadius		; $581e
	; Fall through


; NPC who trades meat for stink bag
@initSubid05:
	call interactionSetAlwaysUpdateBit		; $5821
	call _tokayLoadScript		; $5824
	jp _tokayState1		; $5827


@deleteSelf:
	jp interactionDelete		; $582a


; Linked game cutscene where tokay runs away from Rosa
@initSubid0b:
	call checkIsLinkedGame		; $582d
	jp z,interactionDelete		; $5830

	ld a,TREASURE_SHOVEL		; $5833
	call checkTreasureObtained		; $5835
	jp c,interactionDelete		; $5838

	call getThisRoomFlags		; $583b
	bit 7,a			; $583e
	jp nz,interactionDelete		; $5840

	ld a,$01		; $5843
	ld (wDiggingUpEnemiesForbidden),a		; $5845
	jp _tokayLoadScript		; $5848


; Participant in Wild Tokay game
@initSubid0c:
	; If this is the last tokay, make it red
	ld h,d			; $584b
	ld a,(wTmpcfc0.wildTokay.cfdf)		; $584c
	or a			; $584f
	jr z,+			; $5850
	ld l,Interaction.oamFlags		; $5852
	ld (hl),$02		; $5854
+
	ld l,Interaction.angle		; $5856
	ld (hl),$10		; $5858
	ld l,Interaction.counter2		; $585a
	inc (hl)		; $585c

	ld l,Interaction.xh		; $585d
	ld a,(hl)		; $585f
	cp $88			; $5860
	jr z,+			; $5862

	; Direction variable functions to determine what side he's on?
	; 0 for right side, 1 for left side?
	ld l,Interaction.direction		; $5864
	inc (hl)		; $5866
+
	ld a,(wWildTokayGameLevel)		; $5867
	ld hl,@speedTable		; $586a
	rst_addAToHl			; $586d
	ld a,(hl)		; $586e
	ld e,Interaction.speed		; $586f
	ld (de),a		; $5871
	ret			; $5872

@speedTable:
	.db SPEED_80
	.db SPEED_80
	.db SPEED_80
	.db SPEED_a0
	.db SPEED_a0


; Past NPC in charge of wild tokay game
@initSubid0d:
	call getThisRoomFlags		; $5878
	bit 6,a			; $587b
	jr z,@@gameNotActive	; $587d

	ld a,$81		; $587f
	ld (wDisabledObjects),a		; $5881
	ld (wMenuDisabled),a		; $5884
	ld hl,w1Link.yh		; $5887
	ld (hl),$48		; $588a
	ld l,<w1Link.xh		; $588c
	ld (hl),$50		; $588e
	xor a			; $5890
	ld l,<w1Link.direction		; $5891
	ld (hl),a		; $5893

@@gameNotActive:
	ld h,d			; $5894
	ld l,Interaction.oamFlags		; $5895
	ld (hl),$03		; $5897
	jp _tokayLoadScript		; $5899


; Generic NPCs
@initSubid12:
@initSubid13:
@initSubid14:
@initSubid15:
@initSubid16:
@initSubid17:
@initSubid18:
	ld e,Interaction.subid		; $589c
	ld a,(de)		; $589e
	sub $12			; $589f
	ld hl,@textIndices		; $58a1
	rst_addAToHl			; $58a4
	ld e,Interaction.textID		; $58a5
	ld a,(hl)		; $58a7
	ld (de),a		; $58a8
	jp _tokayLoadScript		; $58a9

@textIndices:
	.db <TX_0a64 ; Subid $12
	.db <TX_0a65 ; Subid $13
	.db <TX_0a66 ; Subid $14
	.db <TX_0a60 ; Subid $15
	.db <TX_0a61 ; Subid $16
	.db <TX_0a62 ; Subid $17
	.db <TX_0a63 ; Subid $18


; Present NPC in charge of the wild tokay museum
@initSubid19:
	call @initSubid0d		; $58b3
	jp _tokayLoadScript		; $58b6


; Subid $1a-$ac: Tokay "statues" in the wild tokay museum

@initSubid1a:
	ld e,Interaction.oamFlags		; $58b9
	ld a,$02		; $58bb
	ld (de),a		; $58bd
	ld e,Interaction.animCounter		; $58be
	ld a,$01		; $58c0
	ld (de),a		; $58c2
	jp interactionAnimate		; $58c3

@initSubid1c:
	ld a,$09		; $58c6
	call interactionSetAnimation		; $58c8
	call _tokayInitMeatAccessory		; $58cb

@initSubid1b:
	ret			; $58ce


; Past NPC standing on cliff at north shore
@initSubid1f:
	ld e,Interaction.textID		; $58cf
	ld a,<TX_0a6c		; $58d1
	ld (de),a		; $58d3
	jp _tokayLoadScript		; $58d4




_tokayState1:
	ld e,Interaction.subid		; $58d7
	ld a,(de)		; $58d9
	rst_jumpTable			; $58da
	.dw _tokayRunSubid00
	.dw _tokayRunSubid01
	.dw _tokayRunSubid02
	.dw _tokayRunSubid03
	.dw _tokayRunSubid04
	.dw _tokayRunSubid05
	.dw _tokayRunSubid06
	.dw _tokayRunSubid07
	.dw _tokayRunSubid08
	.dw _tokayRunSubid09
	.dw _tokayRunSubid0a
	.dw _tokayRunSubid0b
	.dw _tokayRunSubid0c
	.dw _tokayRunSubid0d
	.dw _tokayRunSubid0e
	.dw _tokayRunSubid0f
	.dw _tokayRunSubid10
	.dw _tokayRunSubid11
	.dw _tokayRunSubid12
	.dw _tokayRunSubid13
	.dw _tokayRunSubid14
	.dw _tokayRunSubid15
	.dw _tokayRunSubid16
	.dw _tokayRunSubid17
	.dw _tokayRunSubid18
	.dw _tokayRunSubid19
	.dw _tokayRunSubid1a
	.dw _tokayRunSubid1b
	.dw _tokayRunSubid1c
	.dw _tokayRunSubid1d
	.dw _tokayRunSubid1e
	.dw _tokayRunSubid1f


; Tokays in cutscene who steal your stuff
_tokayRunSubid00:
_tokayRunSubid01:
_tokayRunSubid02:
_tokayRunSubid03:
_tokayRunSubid04:
	ld e,Interaction.state2		; $591b
	ld a,(de)		; $591d
	rst_jumpTable			; $591e
	.dw _tokayThiefSubstate0
	.dw _tokayThiefSubstate1
	.dw _tokayThiefSubstate2
	.dw _tokayThiefSubstate3
	.dw _tokayThiefSubstate4
	.dw _tokayThiefSubstate5
	.dw _tokayThiefSubstate6


; Substate 0: In the process of removing items from Link's inventory
_tokayThiefSubstate0:
	ld e,Interaction.subid		; $592d
	ld a,(de)		; $592f
	cp $02			; $5930
	call z,_tokayThief_countdownToStealNextItem		; $5932

	ld e,Interaction.var39		; $5935
	ld a,(de)		; $5937
	or a			; $5938
	call z,interactionAnimateBasedOnSpeed		; $5939
	call interactionRunScript		; $593c
	ret nc			; $593f

; Script finished; the tokay will now raise the item over its head.

	ld a,$05		; $5940
	call interactionSetAnimation		; $5942
	call interactionIncState2		; $5945
	ld l,Interaction.subid		; $5948
	ld a,(hl)		; $594a
	ld b,a			; $594b

	; Only one of them plays the sound effect
	or a			; $594c
	jr nz,+			; $594d
	ld a,SND_GETITEM		; $594f
	call playSound		; $5951
	ld h,d			; $5954
+
	ld l,Interaction.counter1		; $5955
	ld (hl),$5a		; $5957

;;
; Sets up the graphics for the item that the tokay is holding (ie. shovel, sword)
;
; @param	b	Held item index (0-4)
; @addr{5959}
_tokayInitHeldItem:
	call getFreeInteractionSlot		; $5959
	ret nz			; $595c
	inc l			; $595d
	ld a,b			; $595e
	ld bc,_tokayItemGraphics		; $595f
	call addAToBc		; $5962
	ld a,(bc)		; $5965
	ldd (hl),a		; $5966

;;
; @param	hl	Pointer to an object which will be set to type
;			INTERACID_ACCESSORY.
; @addr{5967}
_tokayInitAccessory:
	ld (hl),INTERACID_ACCESSORY		; $5967
	ld l,Interaction.relatedObj1		; $5969
	ld (hl),Interaction.enabled		; $596b
	inc l			; $596d
	ld (hl),d		; $596e
	ret			; $596f

_tokayItemGraphics:
	.db $10 $1b $68 $31 $20


;;
; This function counts down a timer in var38, and removes the next item from Link's
; inventory once it hits zero. The next item index to steal is var3a.
; @addr{5975}
_tokayThief_countdownToStealNextItem:
	ld h,d			; $5975
	ld l,Interaction.var38		; $5976
	dec (hl)		; $5978
	ret nz			; $5979

	ld (hl),$0a		; $597a
	ld l,Interaction.var3a		; $597c
	ld a,(hl)		; $597e
	cp $09			; $597f
	ret z			; $5981

	inc (hl)		; $5982
	ld hl,tokayIslandStolenItems		; $5983
	rst_addAToHl			; $5986
	ld a,(hl)		; $5987

	cp TREASURE_SEED_SATCHEL			; $5988
	jr nz,+			; $598a
	call loseTreasure		; $598c
	ld a,TREASURE_EMBER_SEEDS		; $598f
	call loseTreasure		; $5991
	ld a,TREASURE_MYSTERY_SEEDS		; $5994
+
	call loseTreasure		; $5996
	ld a,SND_UNKNOWN5		; $5999
	jp playSound		; $599b


_tokayThiefSubstate1:
	call interactionDecCounter1		; $599e
	ret nz			; $59a1

	; Set how long to wait before jumping based on subid
	ld l,Interaction.subid		; $59a2
	ld a,(hl)		; $59a4
	swap a			; $59a5
	add $14			; $59a7
	ld l,Interaction.counter1		; $59a9
	ld (hl),a		; $59ab

	jp interactionIncState2		; $59ac


_tokayThiefSubstate2:
	call interactionAnimate3Times		; $59af
	call interactionDecCounter1		; $59b2
	ret nz			; $59b5

	; Jump away
	ld l,Interaction.angle		; $59b6
	ld (hl),$06		; $59b8
	ld l,Interaction.speed		; $59ba
	ld (hl),SPEED_280		; $59bc

_tokayThief_jump:
	call interactionIncState2		; $59be

	ld bc,-$1c0		; $59c1
	call objectSetSpeedZ		; $59c4

	ld a,$05		; $59c7
	call specialObjectSetAnimation		; $59c9
	ld e,Interaction.animCounter		; $59cc
	ld a,$01		; $59ce
	ld (de),a		; $59d0
	call specialObjectAnimate		; $59d1

	ld a,SND_JUMP		; $59d4
	jp playSound		; $59d6


_tokayThiefSubstate3:
	ld c,$20		; $59d9
	call objectUpdateSpeedZ_paramC		; $59db
	jp nz,objectApplySpeed		; $59de

	call interactionIncState2		; $59e1
	ld l,Interaction.counter1		; $59e4
	ld (hl),$06		; $59e6
	ld a,$05		; $59e8
	jp interactionSetAnimation		; $59ea


_tokayThiefSubstate4:
	call interactionDecCounter1		; $59ed
	ret nz			; $59f0
	jr _tokayThief_jump		; $59f1


; Wait for tokay to exit screen
_tokayThiefSubstate5:
	call objectApplySpeed		; $59f3
	call objectCheckWithinScreenBoundary		; $59f6
	jr c,@updateSpeedZ	; $59f9

	ld e,Interaction.subid		; $59fb
	ld a,(de)		; $59fd
	cp $03			; $59fe
	jr nz,@delete	; $5a00

	; Only the tokay with subid $03 goes to state 6
	call interactionIncState2		; $5a02
	ld l,Interaction.counter1		; $5a05
	ld (hl),$3c		; $5a07
	ret			; $5a09

@delete:
	jp interactionDelete		; $5a0a

@updateSpeedZ:
	ld c,$20		; $5a0d
	jp objectUpdateSpeedZ_paramC		; $5a0f


; Wait for a bit before restoring control to Link
_tokayThiefSubstate6:
	call interactionDecCounter1		; $5a12
	ret nz			; $5a15

	xor a			; $5a16
	ld (wDisabledObjects),a		; $5a17
	ld (wUseSimulatedInput),a		; $5a1a
	ld (wMenuDisabled),a		; $5a1d
	call getThisRoomFlags		; $5a20
	set 6,(hl)		; $5a23

	ld a,(wActiveMusic2)		; $5a25
	ld (wActiveMusic),a		; $5a28
	call playSound		; $5a2b

	call setDeathRespawnPoint		; $5a2e
	jp interactionDelete		; $5a31



; NPC who trades meat for stink bag
_tokayRunSubid05:
	call interactionRunScript		; $5a34
	jp c,interactionDelete		; $5a37

	ld e,Interaction.var3f		; $5a3a
	ld a,(de)		; $5a3c
	or a			; $5a3d
	jp z,npcFaceLinkAndAnimate		; $5a3e

	call _tokayRunStinkBagCutscene		; $5a41
	call interactionAnimate		; $5a44
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $5a47


; NPC holding something (ie. shovel, harp, shield upgrade).
_tokayRunSubid06:
_tokayRunSubid07:
_tokayRunSubid08:
_tokayRunSubid09:
_tokayRunSubid0a:
_tokayRunSubid1d:
	call interactionRunScript		; $5a4a
	ld e,Interaction.var3b		; $5a4d
	ld a,(de)		; $5a4f
	or a			; $5a50
	jp z,interactionAnimateAsNpc		; $5a51
	jp npcFaceLinkAndAnimate		; $5a54


; Linked game cutscene where tokay runs away from Rosa
_tokayRunSubid0b:
	call interactionRunScript		; $5a57
	jp c,interactionDelete		; $5a5a
	jp interactionAnimateBasedOnSpeed		; $5a5d


; Participant in Wild Tokay game
_tokayRunSubid0c:
	ld e,Interaction.state2		; $5a60
	ld a,(de)		; $5a62
	rst_jumpTable			; $5a63
	.dw _wildTokayParticipantSubstate0
	.dw _wildTokayParticipantSubstate1
	.dw _wildTokayParticipantSubstate2


_wildTokayParticipantSubstate0:
	call _wildTokayParticipant_checkGrabMeat		; $5a6a

_wildTokayParticipantSubstate2:
	call objectApplySpeed		; $5a6d
	ld e,Interaction.yh		; $5a70
	ld a,(de)		; $5a72
	add $08			; $5a73
	cp $90			; $5a75
	jp c,interactionAnimateBasedOnSpeed		; $5a77

; Tokay has just left the screen

	; Is he holding meat?
	ld e,Interaction.var3c		; $5a7a
	ld a,(de)		; $5a7c
	or a			; $5a7d
	jr nz,+			; $5a7e

	; If so, set failure flag?
	ld a,$ff		; $5a80
	ld ($cfde),a		; $5a82
	jr @delete		; $5a85
+
	; Delete "meat" accessory
	ld e,Interaction.relatedObj2+1		; $5a87
	ld a,(de)		; $5a89
	push de			; $5a8a
	ld d,a			; $5a8b
	call objectDelete_de		; $5a8c

	; If this is the last tokay (colored red), mark "success" condition in $cfde
	pop de			; $5a8f
	ld e,Interaction.oamFlags		; $5a90
	ld a,(de)		; $5a92
	cp $02			; $5a93
	jr nz,@delete	; $5a95

	ld a,$01		; $5a97
	ld ($cfde),a		; $5a99
@delete:
	jp interactionDelete		; $5a9c

;;
; @addr{5aa9}
_wildTokayParticipant_checkGrabMeat:
	; Check that Link's throwing an item
	ld a,(w1ReservedItemC.enabled)		; $5a9f
	or a			; $5aa2
	ret z			; $5aa3
	ld a,(wLinkGrabState)		; $5aa4
	or a			; $5aa7
	ret nz			; $5aa8

	; Check if the meat has collided with self
	ld a,$0a		; $5aa9
	ld hl,w1ReservedItemC.yh		; $5aab
	ld b,(hl)		; $5aae
	ld l,Item.xh		; $5aaf
	ld c,(hl)		; $5ab1
	ld h,d			; $5ab2
	ld l,Interaction.yh		; $5ab3
	call checkObjectIsCloseToPosition		; $5ab5
	ret nc			; $5ab8

	call interactionIncState2		; $5ab9
	ld l,Interaction.var3c		; $5abc
	inc (hl)		; $5abe
	ld l,Interaction.counter1		; $5abf
	ld (hl),$06		; $5ac1

	ld a,$07		; $5ac3
	ld l,Interaction.direction		; $5ac5
	add (hl)		; $5ac7
	call interactionSetAnimation		; $5ac8
	push de			; $5acb

	; Delete thrown meat
	ld de,w1ReservedItemC.enabled		; $5acc
	call objectDelete_de		; $5acf

	; Delete something?
	ld hl,$cfda		; $5ad2
	ldi a,(hl)		; $5ad5
	ld e,(hl)		; $5ad6
	ld d,a			; $5ad7
	call objectDelete_de		; $5ad8

	pop de			; $5adb
	ld a,SND_OPENCHEST		; $5adc
	call playSound		; $5ade
	; Fall through

;;
; Creates a graphic of "held meat" for a tokay.
; @addr{5ae1}
_tokayInitMeatAccessory:
	call getFreeInteractionSlot		; $5ae1
	ret nz			; $5ae4

	ld (hl),INTERACID_ACCESSORY		; $5ae5
	inc l			; $5ae7
	ld (hl),$73		; $5ae8
	inc l			; $5aea
	inc (hl)		; $5aeb

	ld l,Interaction.relatedObj1		; $5aec
	ld (hl),Interaction.enabled		; $5aee
	inc l			; $5af0
	ld (hl),d		; $5af1

	ld e,Interaction.relatedObj2+1		; $5af2
	ld a,h			; $5af4
	ld (de),a		; $5af5
	ret			; $5af6


_wildTokayParticipantSubstate1:
	call interactionDecCounter1		; $5af7
	ret nz			; $5afa
	jp interactionIncState2		; $5afb



; Past and present NPCs in charge of wild tokay game
_tokayRunSubid0d:
_tokayRunSubid19:
	ld e,Interaction.state2		; $5afe
	ld a,(de)		; $5b00
	rst_jumpTable			; $5b01
	.dw @substate0
	.dw @substate1

; Not running game
@substate0:
	ld a,(wPaletteThread_mode)		; $5b06
	or a			; $5b09
	ret nz			; $5b0a

	call interactionRunScript		; $5b0b
	jp nc,interactionAnimateAsNpc		; $5b0e

; Script ended; that means the game should begin.

	; Create meat spawner?
	call getFreeInteractionSlot		; $5b11
	ret nz			; $5b14
	ld (hl),INTERACID_WILD_TOKAY_CONTROLLER		; $5b15
	call interactionIncState2		; $5b17
	ld a,SNDCTRL_MEDIUM_FADEOUT		; $5b1a
	call playSound		; $5b1c
	jp fadeoutToWhite		; $5b1f

; Beginning game (will delete self when the game is initialized)
@substate1:
	ld a,(wPaletteThread_mode)		; $5b22
	or a			; $5b25
	ret nz			; $5b26

	push de			; $5b27
	call clearAllItemsAndPutLinkOnGround		; $5b28
	pop de			; $5b2b
	ld e,Interaction.subid		; $5b2c
	ld a,(de)		; $5b2e

	; Check if in present or past
	cp $19			; $5b2f
	jr nz,++		; $5b31
	ld a,$01		; $5b33
	ld ($cfc0),a		; $5b35
++
	jp interactionDelete		; $5b38


; Subids $0f-$10: Tokays who try to eat Dimitri
_tokayRunSubid0f:
	ld a,(wScrollMode)		; $5b3b
	and $0e			; $5b3e
	ret nz			; $5b40

_tokayRunSubid10:
	ld a,(w1Companion.var3e)		; $5b41
	and $04			; $5b44
	jr nz,++			; $5b46
	; Fall through


; Shopkeeper, and past NPC looking after scent seedling
_tokayRunSubid0e:
_tokayRunSubid11:
	call interactionAnimateAsNpc		; $5b48
++
	call interactionRunScript		; $5b4b
	ret nc			; $5b4e
	jp interactionDelete		; $5b4f


; Present NPC who talks to you after climbing down vine
_tokayRunSubid1e:
	ld c,$10		; $5b52
	call objectUpdateSpeedZ_paramC		; $5b54
	call interactionAnimateAsNpc		; $5b57
	call getThisRoomFlags		; $5b5a
	bit 6,a			; $5b5d
	jp nz,interactionRunScript		; $5b5f

	ld c,$18		; $5b62
	call objectCheckLinkWithinDistance		; $5b64
	ret nc			; $5b67

	ld e,Interaction.var31		; $5b68
	ld (de),a		; $5b6a
	jp interactionRunScript		; $5b6b


; Subids $12-$18 and $1f: Generic NPCs
_tokayRunSubid12:
_tokayRunSubid13:
_tokayRunSubid14:
_tokayRunSubid15:
_tokayRunSubid16:
_tokayRunSubid17:
_tokayRunSubid18:
_tokayRunSubid1f:
	call interactionRunScript		; $5b6e
	jp npcFaceLinkAndAnimate		; $5b71


; Subids $1a-$1c: Tokay "statues" in the wild tokay museum
_tokayRunSubid1a:
_tokayRunSubid1b:
_tokayRunSubid1c:
	ld a,(wTmpcfc0.wildTokay.inPresent)		; $5b74
	or a			; $5b77
	ret z			; $5b78
	jp interactionDelete		; $5b79


;;
; Cutscene where tokay smells stink bag and jumps around like a madman.
;
; On return, var3e will be 0 if he's currently at his starting position, otherwise it will
; be 1.
; @addr{5b7c}
_tokayRunStinkBagCutscene:
	ld e,Interaction.state2		; $5b7c
	ld a,(de)		; $5b7e
	rst_jumpTable			; $5b7f
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d			; $5b86
	ld l,Interaction.speed		; $5b87
	ld (hl),SPEED_300		; $5b89

@beginNextJump:
	ld h,d			; $5b8b
	ld l,Interaction.yh		; $5b8c
	ld a,(hl)		; $5b8e
	ld l,Interaction.var39		; $5b8f
	ld (hl),a		; $5b91

	ld l,Interaction.xh		; $5b92
	ld a,(hl)		; $5b94
	ld l,Interaction.var3a		; $5b95
	ld (hl),a		; $5b97

	ld h,d			; $5b98
	ld l,Interaction.state2		; $5b99
	ld (hl),$01		; $5b9b
	ld l,Interaction.var3e		; $5b9d
	ld (hl),$01		; $5b9f

	call @initJumpVariables		; $5ba1

	ld a,SND_JUMP		; $5ba4
	jp playSound		; $5ba6

; Set angle, speedZ, and var3c (gravity) for the next jump.
@initJumpVariables:
	ld h,d			; $5ba9
	ld l,Interaction.var3b		; $5baa
	ld a,(hl)		; $5bac
	add a			; $5bad
	ld bc,@jumpPaths		; $5bae
	call addDoubleIndexToBc		; $5bb1

	ld a,(bc)		; $5bb4
	inc bc			; $5bb5
	ld l,Interaction.angle		; $5bb6
	ld (hl),a		; $5bb8
	ld a,(bc)		; $5bb9
	inc bc			; $5bba
	ld l,Interaction.speedZ		; $5bbb
	ldi (hl),a		; $5bbd
	ld a,(bc)		; $5bbe
	inc bc			; $5bbf
	ld (hl),a		; $5bc0
	ld a,(bc)		; $5bc1
	ld l,Interaction.var3c		; $5bc2
	ld (hl),a		; $5bc4
	ret			; $5bc5

; Data format:
;   byte: angle
;   word: speedZ
;   byte: var3c (gravity)
@jumpPaths:
	dbwb $18, -$800, -$08
	dbwb $0a, -$c00, -$08
	dbwb $02, -$800, -$08
	dbwb $14, -$c00, -$08
	dbwb $06, -$e00, -$08
	dbwb $18, -$a00, -$08

@substate1:
	; Apply gravity and update speed
	ld e,Interaction.var3c		; $5bde
	ld a,(de)		; $5be0
	ld c,a			; $5be1
	call objectUpdateSpeedZ_paramC		; $5be2
	jp nz,objectApplySpeed		; $5be5

	call interactionIncState2		; $5be8
	ld l,Interaction.var3b		; $5beb
	ld a,(hl)		; $5bed
	cp $05			; $5bee
	ret nz			; $5bf0

	; He's completed one loop. Restore y/x to precise values to prevent "drifting" off
	; course?
	ld l,Interaction.y		; $5bf1
	ld (hl),$00		; $5bf3
	inc l			; $5bf5
	ld (hl),$28		; $5bf6
	ld l,Interaction.x		; $5bf8
	ld (hl),$00		; $5bfa
	inc l			; $5bfc
	ld (hl),$48		; $5bfd

	ld l,Interaction.var3e		; $5bff
	ld (hl),$00		; $5c01
	ret			; $5c03

@substate2:
	; Increment "jump index", and loop back to 0 when appropriate.
	ld h,d			; $5c04
	ld l,Interaction.var3b		; $5c05
	inc (hl)		; $5c07
	ld a,(hl)		; $5c08
	cp $06			; $5c09
	jr c,+			; $5c0b
	ld (hl),$00		; $5c0d
+
	jp @beginNextJump		; $5c0f

;;
; @addr{5c12}
_tokayLoadScript:
	ld e,Interaction.subid		; $5c12
	ld a,(de)		; $5c14
	ld hl,tokayScriptTable		; $5c15
	rst_addDoubleIndex			; $5c18
	ldi a,(hl)		; $5c19
	ld h,(hl)		; $5c1a
	ld l,a			; $5c1b
	jp interactionSetScript		; $5c1c

tokayScriptTable:
	/* $00 */ .dw tokayThiefScript
	/* $01 */ .dw tokayThiefScript
	/* $02 */ .dw tokayMainThiefScript
	/* $03 */ .dw tokayThiefScript
	/* $04 */ .dw tokayThiefScript
	/* $05 */ .dw tokayCookScript
	/* $06 */ .dw tokayHoldingItemScript
	/* $07 */ .dw tokayHoldingItemScript
	/* $08 */ .dw tokayHoldingItemScript
	/* $09 */ .dw tokayHoldingItemScript
	/* $0a */ .dw tokayHoldingItemScript
	/* $0b */ .dw tokayRunningFromRosaScript
	/* $0c */ .dw stubScript
	/* $0d */ .dw tokayGameManagerScript_past
	/* $0e */ .dw tokayShopkeeperScript
	/* $0f */ .dw tokayWithDimitri1Script
	/* $10 */ .dw tokayWithDimitri2Script
	/* $11 */ .dw tokayAtSeedlingPlotScript
	/* $12 */ .dw genericNpcScript
	/* $13 */ .dw genericNpcScript
	/* $14 */ .dw genericNpcScript
	/* $15 */ .dw genericNpcScript
	/* $16 */ .dw genericNpcScript
	/* $17 */ .dw genericNpcScript
	/* $18 */ .dw genericNpcScript
	/* $19 */ .dw tokayGameManagerScript_present
	/* $1a */ .dw $0000
	/* $1b */ .dw $0000
	/* $1c */ .dw $0000
	/* $1d */ .dw tokayWithShieldUpgradeScript
	/* $1e */ .dw tokayExplainingVinesScript
	/* $1f */ .dw genericNpcScript



; ==============================================================================
; INTERACID_FOREST_FAIRY
; ==============================================================================
interactionCode49:
	ld e,Interaction.subid		; $5c5f
	ld a,(de)		; $5c61
	ld e,Interaction.state		; $5c62
	rst_jumpTable			; $5c64
	.dw _forestFairy_subid00
	.dw _forestFairy_subid01
	.dw _forestFairy_subid02
	.dw _forestFairy_subid03
	.dw _forestFairy_subid04
	.dw _forestFairy_subid05
	.dw _forestFairy_subid06
	.dw _forestFairy_subid07
	.dw _forestFairy_subid08
	.dw _forestFairy_subid09
	.dw _forestFairy_subid0a
	.dw _forestFairy_subid0b
	.dw _forestFairy_subid0c
	.dw _forestFairy_subid0d
	.dw _forestFairy_subid0e
	.dw _forestFairy_subid0f
	.dw _forestFairy_subid10

_forestFairy_subid00:
	ld a,(de)		; $5c87
	rst_jumpTable			; $5c88
	.dw _forestFairy_subid00State0
	.dw _forestFairy_subid00State1
	.dw _forestFairy_subid00State2
	.dw _forestFairy_subid00State3
	.dw _forestFairy_deleteSelf


_forestFairy_subid00State0:
_forestFairy_subid03State0:
_forestFairy_subid04State0:
	call interactionInitGraphics		; $5c93
	call _forestFairy_initCollisionRadiusAndSetZAndIncState		; $5c96
	ld l,Interaction.speed		; $5c99
	ld (hl),SPEED_200		; $5c9b
	ld l,Interaction.var3a		; $5c9d
	ld (hl),$5a		; $5c9f

_forestFairy_loadMovementPreset:
	ld e,Interaction.var03		; $5ca1
	ld a,(de)		; $5ca3
	add a			; $5ca4
	ld hl,@data		; $5ca5
	rst_addDoubleIndex			; $5ca8

	ld e,Interaction.yh		; $5ca9
	ld a,(hl)		; $5cab
	and $f8			; $5cac
	ld (de),a		; $5cae
	ld e,Interaction.angle		; $5caf
	ldi a,(hl)		; $5cb1
	and $07			; $5cb2
	add a			; $5cb4
	add a			; $5cb5
	ld (de),a		; $5cb6

	ld e,Interaction.xh		; $5cb7
	ld a,(hl)		; $5cb9
	and $f8			; $5cba
	ld (de),a		; $5cbc
	ld e,Interaction.counter1		; $5cbd
	ldi a,(hl)		; $5cbf
	and $07			; $5cc0
	inc a			; $5cc2
	ld (de),a		; $5cc3
	inc e			; $5cc4
	ld (de),a		; $5cc5

	ld e,Interaction.var38		; $5cc6
	ld a,(hl)		; $5cc8
	and $f8			; $5cc9
	ld (de),a		; $5ccb
	ld e,Interaction.direction		; $5ccc
	ldi a,(hl)		; $5cce
	and $01			; $5ccf
	ld (de),a		; $5cd1

	ld e,Interaction.var39		; $5cd2
	ld a,(hl)		; $5cd4
	and $f8			; $5cd5
	ld (de),a		; $5cd7
	ld e,Interaction.oamFlags		; $5cd8
	ld a,(hl)		; $5cda
	and $07			; $5cdb
	ld (de),a		; $5cdd
	dec e			; $5cde
	ld (de),a		; $5cdf

	ld e,Interaction.direction		; $5ce0
	ld a,(de)		; $5ce2
	jp interactionSetAnimation		; $5ce3


; Each row is data for a corresponding value of "var03".
; Data format:
;   b0: angle (bits 0-2, multiplied by 4) and y-position (bits 3-7)
;   b1: counter1/2 (bits 0-2, plus one) and x-position (bits 3-7)
;   b2: direction (bit 0) and var38 (bits 3-7)
;   b3: oamFlags (bits 0-2) and var39 (bits 3-7)
@data:
	.db $38 $6b $48 $39
	.db $29 $3b $49 $6a
	.db $5d $53 $39 $53
	.db $2e $5a $48 $51
	.db $5d $4a $49 $52
	.db $39 $2a $49 $53
	.db $4c $3c $00 $49
	.db $48 $6c $39 $8a
	.db $3a $54 $59 $03
	.db $4c $54 $00 $a1
	.db $49 $55 $91 $62
	.db $4a $53 $01 $03
	.db $4c $a4 $28 $59
	.db $60 $ac $59 $4a
	.db $03 $7c $39 $2b
	.db $97 $53 $61 $41
	.db $84 $53 $91 $81
	.db $4e $5b $89 $11
	.db $3a $7b $28 $aa
	.db $5a $7b $88 $a3
	.db $36 $ab $21 $69
	.db $86 $53 $91 $39


_forestFairy_subid00State1:
	ld h,d			; $5d3e
	ld l,Interaction.var38		; $5d3f
	ld b,(hl)		; $5d41
	inc l			; $5d42
	ld c,(hl)		; $5d43
	ld l,Interaction.yh		; $5d44
	ldi a,(hl)		; $5d46
	ldh (<hFF8F),a	; $5d47
	inc l			; $5d49
	ld a,(hl)		; $5d4a
	ldh (<hFF8E),a	; $5d4b
	sub c			; $5d4d
	add $04			; $5d4e
	cp $09			; $5d50
	jr nc,@label_09_161	; $5d52

	ldh a,(<hFF8F)	; $5d54
	sub b			; $5d56
	add $04			; $5d57
	cp $09			; $5d59
	jr nc,@label_09_161	; $5d5b

	ld e,Interaction.subid		; $5d5d
	ld a,(de)		; $5d5f
	cp $03			; $5d60
	jr nc,@label_09_160	; $5d62

	ld (hl),c		; $5d64
	ld l,Interaction.yh		; $5d65
	ld (hl),b		; $5d67
	ld l,Interaction.state		; $5d68
	inc (hl)		; $5d6a

@label_09_160:
	ld hl,wTmpcfc0.fairyHideAndSeek.cfd2		; $5d6b
	inc (hl)		; $5d6e
	scf			; $5d6f
	ret			; $5d70

@label_09_161:
	ld l,Interaction.var3a		; $5d71
	dec (hl)		; $5d73
	ld a,(hl)		; $5d74
	jr nz,@label_09_163	; $5d75

	ld (hl),$5a		; $5d77
	ld l,Interaction.counter2		; $5d79
	srl (hl)		; $5d7b
	jr nc,@label_09_164	; $5d7d

	inc (hl)		; $5d7f
@label_09_163:
	and $07			; $5d80
	jr nz,@label_09_164	; $5d82

	push bc			; $5d84
	ldbc INTERACID_SPARKLE, $02		; $5d85
	call objectCreateInteraction		; $5d88
	pop bc			; $5d8b

@label_09_164:
	call interactionDecCounter1		; $5d8c
	jr nz,_forestFairy_updateMovement	; $5d8f

	inc l			; $5d91
	ldd a,(hl)		; $5d92
	ld (hl),a		; $5d93
	call objectGetRelativeAngleWithTempVars		; $5d94
	call objectNudgeAngleTowards		; $5d97

_forestFairy_updateMovement:
	call objectApplySpeed		; $5d9a
	ld a,(wFrameCounter)		; $5d9d
	and $1f			; $5da0
	ld a,SND_MAGIC_POWDER		; $5da2
	call z,playSound		; $5da4

_forestFairy_animate:
	call interactionAnimate		; $5da7
	or d			; $5daa
	ret			; $5dab


_forestFairy_subid00State2:
	ld a,(wTmpcfc0.fairyHideAndSeek.cfd2)		; $5dac
	or a			; $5daf
	jr nz,_forestFairy_animate	; $5db0

	ld e,Interaction.var03		; $5db2
	ld a,(de)		; $5db4
	cp $06			; $5db5
	jr nc,@createPuffAndDelete	; $5db7

	add $06			; $5db9
	ld (de),a		; $5dbb
	call interactionIncState		; $5dbc
	jp _forestFairy_loadMovementPreset		; $5dbf

@createPuffAndDelete:
	call objectCreatePuff		; $5dc2
	jr _forestFairy_deleteSelf		; $5dc5

_forestFairy_subid00State3:
	call _forestFairy_subid00State1		; $5dc7
	jr c,_forestFairy_deleteSelf	; $5dca
	ld e,Interaction.yh		; $5dcc
	ld a,(de)		; $5dce
	cp $80			; $5dcf
	jr nc,++		; $5dd1

	ld e,Interaction.xh		; $5dd3
	ld a,(de)		; $5dd5
	cp $a0			; $5dd6
	ret c			; $5dd8
++
	ld hl,wTmpcfc0.fairyHideAndSeek.cfd2		; $5dd9
	inc (hl)		; $5ddc

_forestFairy_deleteSelf:
	jp interactionDelete		; $5ddd


_forestFairy_subid01:
	ld a,(de)		; $5de0
	or a			; $5de1
	jr z,@stateZero	; $5de2

	ld a,($cfd0)		; $5de4
	or a			; $5de7
	jp z,interactionDelete		; $5de8

	ld hl,w1Link		; $5deb
	call preventObjectHFromPassingObjectD		; $5dee
	call interactionAnimate		; $5df1
	jp interactionRunScript		; $5df4

@stateZero:
	ld e,Interaction.var03		; $5df7
	ld a,(de)		; $5df9
	ld hl,$cfd1		; $5dfa
	call checkFlag		; $5dfd
	jp z,interactionDelete		; $5e00

	ld a,($cfd1)		; $5e03
	call getNumSetBits		; $5e06
	dec a			; $5e09
	ld hl,_forestFairyDiscoveredScriptTable		; $5e0a
	rst_addDoubleIndex			; $5e0d
	ldi a,(hl)		; $5e0e
	ld h,(hl)		; $5e0f
	ld l,a			; $5e10
	call interactionSetScript		; $5e11

	call interactionInitGraphics		; $5e14

	; Set color based on index
	ld e,Interaction.var03		; $5e17
	ld a,(de)		; $5e19
	ld b,a			; $5e1a
	inc a			; $5e1b
	ld e,Interaction.oamFlags		; $5e1c
	ld (de),a		; $5e1e
	dec e			; $5e1f
	ld (de),a		; $5e20

	ld a,b			; $5e21
	ld hl,_forestFairy_discoveredPositions		; $5e22
	rst_addDoubleIndex			; $5e25
	ld e,Interaction.yh		; $5e26
	ldi a,(hl)		; $5e28
	ld (de),a		; $5e29
	ld e,Interaction.xh		; $5e2a
	ld a,(hl)		; $5e2c
	ld (de),a		; $5e2d
	ld a,b			; $5e2e
	or a			; $5e2f
	jr z,+			; $5e30
	ld a,$01		; $5e32
+
	call interactionSetAnimation		; $5e34

_forestFairy_initCollisionRadiusAndSetZAndIncState:
	call interactionIncState		; $5e37
	ld l,Interaction.collisionRadiusY		; $5e3a
	ld a,$04		; $5e3c
	ldi (hl),a		; $5e3e
	ld (hl),a		; $5e3f
	ld l,Interaction.zh		; $5e40
	ld (hl),$fc		; $5e42
	jp objectSetVisiblec1		; $5e44


; Scripts used for fairy NPCs after being discovered
_forestFairyDiscoveredScriptTable:
	.dw forestFairyScript_firstDiscovered
	.dw forestFairyScript_secondDiscovered
	.dw stubScript

_forestFairy_discoveredPositions:
	.db $48 $38
	.db $48 $68
	.db $28 $50


_forestFairy_subid02:
	jp interactionDelete		; $5e53

_forestFairy_subid03:
	ld a,(de)		; $5e56
	rst_jumpTable			; $5e57
	.dw _forestFairy_subid03State0
	.dw _forestFairy_subid03State1
	.dw _forestFairy_subid03State2
	.dw _forestFairy_subid03State3
	.dw _forestFairy_subid00State3

_forestFairy_subid04:
	ld a,(de)		; $5e62
	rst_jumpTable			; $5e63
	.dw _forestFairy_subid04State0
	.dw _forestFairy_subid04State1
	.dw _forestFairy_subid00State3

_forestFairy_subid03State1:
	call _forestFairy_subid00State1		; $5e6a
	ret nc			; $5e6d
	call interactionIncState		; $5e6e
	ld a,$02		; $5e71
	ld l,Interaction.counter1		; $5e73
	ldi (hl),a		; $5e75
	ldi (hl),a		; $5e76
	ld l,Interaction.var3b		; $5e77
	ld (hl),$20		; $5e79
	ret			; $5e7b

_forestFairy_subid03State2:
	ld h,d			; $5e7c
	ld l,Interaction.var3a		; $5e7d
	dec (hl)		; $5e7f
	ld a,(hl)		; $5e80
	and $07			; $5e81
	jr nz,++		; $5e83

	push bc			; $5e85
	ldbc INTERACID_SPARKLE, $02		; $5e86
	call objectCreateInteraction		; $5e89
	pop bc			; $5e8c
++
	call interactionDecCounter2		; $5e8d
	jr nz,@updateMovement	; $5e90

	dec l			; $5e92
	ldi a,(hl)		; $5e93
	ldi (hl),a		; $5e94

	; [direction]++ (wrapping $20 to $00)
	inc l			; $5e95
	ld a,(hl)		; $5e96
	inc a			; $5e97
	and $1f			; $5e98
	ld (hl),a		; $5e9a

	ld l,Interaction.var3b		; $5e9b
	dec (hl)		; $5e9d
	jr nz,@updateMovement	; $5e9e

	ld l,e			; $5ea0
	inc (hl)		; $5ea1
	ld hl,wTmpcfc0.fairyHideAndSeek.cfd2		; $5ea2
	inc (hl)		; $5ea5
	ret			; $5ea6

@updateMovement:
	jp _forestFairy_updateMovement		; $5ea7

_forestFairy_subid03State3:
	ld a,(wTmpcfc0.fairyHideAndSeek.cfd2)		; $5eaa
	or a			; $5ead
	jp nz,_forestFairy_animate		; $5eae

	call interactionIncState		; $5eb1
	ld l,Interaction.var03		; $5eb4
	inc (hl)		; $5eb6
	ld l,Interaction.yh		; $5eb7
	ldi a,(hl)		; $5eb9
	inc l			; $5eba
	ld c,(hl)		; $5ebb
	ld b,a			; $5ebc
	push bc			; $5ebd
	call _forestFairy_loadMovementPreset		; $5ebe
	pop bc			; $5ec1
	ld h,d			; $5ec2
	ld l,Interaction.yh		; $5ec3
	ld (hl),b		; $5ec5
	ld l,Interaction.xh		; $5ec6
	ld (hl),c		; $5ec8
	ret			; $5ec9

_forestFairy_subid04State1:
	ld a,(wTmpcfc0.fairyHideAndSeek.cfd2)		; $5eca
	or a			; $5ecd
	jp nz,_forestFairy_animate		; $5ece
	call interactionIncState		; $5ed1
	jp _forestFairy_loadMovementPreset		; $5ed4


; Generic NPC (between completing the maze and entering jabu)
_forestFairy_subid05:
_forestFairy_subid06:
_forestFairy_subid07:
	call checkInteractionState		; $5ed7
	jr nz,_forestFairy_standardUpdate	; $5eda

	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME		; $5edc
	call checkGlobalFlag		; $5ede
	jp z,interactionDelete		; $5ee1

	ld a,GLOBALFLAG_FOREST_UNSCRAMBLED		; $5ee4
	call checkGlobalFlag		; $5ee6
	jp z,interactionDelete		; $5ee9

	; Check if jabu-jabu is opened?
	ld a,(wPresentRoomFlags+$90)		; $5eec
	bit 6,a			; $5eef
	jp nz,interactionDelete		; $5ef1

	ld e,Interaction.subid		; $5ef4
	ld a,(de)		; $5ef6
	sub $05			; $5ef7
	ld hl,_forestFairy_subid5To7NpcData		; $5ef9
	rst_addDoubleIndex			; $5efc

;;
; @param	hl	Pointer to 2 bytes (see example data below)
; @addr{5efd}
_forestFairy_initNpcFromData:
	push hl			; $5efd
	call interactionInitGraphics		; $5efe
	pop hl			; $5f01

	ld e,Interaction.textID		; $5f02
	ldi a,(hl)		; $5f04
	ld (de),a		; $5f05

	ld e,Interaction.oamFlagsBackup		; $5f06
	ld a,(hl)		; $5f08
	and $0f			; $5f09
	ld (de),a		; $5f0b
	inc e			; $5f0c
	ld (de),a		; $5f0d

	ld a,(hl)		; $5f0e
	and $f0			; $5f0f
	swap a			; $5f11
	call interactionSetAnimation		; $5f13

	call objectMarkSolidPosition		; $5f16
	call interactionIncState		; $5f19
	ld l,Interaction.zh		; $5f1c
	ld (hl),$fc		; $5f1e

	ld l,Interaction.textID+1		; $5f20
	ld (hl),>TX_1100		; $5f22
	ld hl,forestFairyScript_genericNpc		; $5f24
	call interactionSetScript		; $5f27
	jp objectSetVisiblec1		; $5f2a


; Index is [subid]-5 (for subids $05-$07).
;  b0: Low byte of textID
;  b1: oamFlags (bits 0-3), animation index (bits 4-7)
_forestFairy_subid5To7NpcData:
	.db <TX_110d, $01
	.db <TX_1110, $12
	.db <TX_1113, $13

_forestFairy_standardUpdate:
	call interactionRunScript		; $5f33
	call interactionAnimate		; $5f36
	jp objectPreventLinkFromPassing		; $5f39


; Generic NPC (between jabu and finishing the game)
_forestFairy_subid08:
_forestFairy_subid09:
_forestFairy_subid0a:
	call checkInteractionState		; $5f3c
	jr nz,_forestFairy_standardUpdate	; $5f3f

	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME		; $5f41
	call checkGlobalFlag		; $5f43
	jp z,interactionDelete		; $5f46

	ld a,GLOBALFLAG_FOREST_UNSCRAMBLED		; $5f49
	call checkGlobalFlag		; $5f4b
	jp z,interactionDelete		; $5f4e

	ld a,(wPresentRoomFlags+$90)		; $5f51
	bit 6,a			; $5f54
	jp z,interactionDelete		; $5f56

	ld a,GLOBALFLAG_FINISHEDGAME		; $5f59
	call checkGlobalFlag		; $5f5b
	jp nz,interactionDelete		; $5f5e

	ld e,Interaction.subid		; $5f61
	ld a,(de)		; $5f63
	sub $08			; $5f64
	ld hl,@npcData		; $5f66
	rst_addDoubleIndex			; $5f69
	jp _forestFairy_initNpcFromData		; $5f6a

; Index is [subid]-8 (for subids $08-$0a).
;  b0: Low byte of textID
;  b1: oamFlags (bits 0-3), animation index (bits 4-7)
@npcData:
	.db <TX_110e, $01
	.db <TX_1111, $12
	.db <TX_1114, $13


; NPC in unlinked game who takes a secret
_forestFairy_subid0b:
	call checkInteractionState		; $5f73
	jr nz,_forestFairy_standardUpdate	; $5f76

	ld a,GLOBALFLAG_FINISHEDGAME		; $5f78
	call checkGlobalFlag		; $5f7a
	jp z,interactionDelete		; $5f7d

	call interactionInitGraphics		; $5f80
	call objectMarkSolidPosition		; $5f83
	call interactionIncState		; $5f86
	ld l,Interaction.zh		; $5f89
	ld (hl),$fc		; $5f8b

	ld l,Interaction.oamFlags		; $5f8d
	ld a,$01		; $5f8f
	ldd (hl),a		; $5f91
	ld (hl),a		; $5f92
	ld hl,forestFairyScript_heartContainerSecret		; $5f93
	call interactionSetScript		; $5f96
	jp objectSetVisiblec1		; $5f99


; Generic NPC (after beating game)
_forestFairy_subid0c:
_forestFairy_subid0d:
	call checkInteractionState		; $5f9c
_forestFairy_standardUpdate_2:
	jr nz,_forestFairy_standardUpdate	; $5f9f

	ld a,GLOBALFLAG_FINISHEDGAME		; $5fa1
	call checkGlobalFlag		; $5fa3
	jp z,interactionDelete		; $5fa6

	ld e,Interaction.subid		; $5fa9
	ld a,(de)		; $5fab
	sub $0c			; $5fac
	ld hl,@npcData		; $5fae
	rst_addDoubleIndex			; $5fb1
	jp _forestFairy_initNpcFromData		; $5fb2

; Index is [subid]-$0c (for subids $0c-$0d).
;  b0: Low byte of textID
;  b1: oamFlags (bits 0-3), animation index (bits 4-7)
@npcData:
	.db <TX_1112, $12
	.db <TX_1115, $13


; Generic NPC (while looking for companion trapped in woods)
_forestFairy_subid0e:
_forestFairy_subid0f:
_forestFairy_subid10:
	call checkInteractionState		; $5fb9
	jr nz,_forestFairy_standardUpdate_2	; $5fbc

	ld a,GLOBALFLAG_GOT_FLUTE		; $5fbe
	call checkGlobalFlag		; $5fc0
	jp nz,interactionDelete		; $5fc3

	ld a,GLOBALFLAG_FOREST_UNSCRAMBLED		; $5fc6
	call checkGlobalFlag		; $5fc8
	jp nz,interactionDelete		; $5fcb

	ld a,GLOBALFLAG_COMPANION_LOST_IN_FOREST		; $5fce
	call checkGlobalFlag		; $5fd0
	jp z,interactionDelete		; $5fd3

	ld e,Interaction.subid		; $5fd6
	ld a,(de)		; $5fd8
	sub $0e			; $5fd9
	ld hl,@npcData		; $5fdb
	rst_addDoubleIndex			; $5fde
	jp _forestFairy_initNpcFromData		; $5fdf

; Index is [subid]-$0e (for subids $0e-$10).
;  b0: Low byte of textID
;  b1: oamFlags (bits 0-3), animation index (bits 4-7)
@npcData:
	.db <TX_1127, $01
	.db <TX_1128, $12
	.db <TX_1129, $13


; ==============================================================================
; INTERACID_RABBIT
; ==============================================================================
interactionCode4b:
	jpab bank3f.interactionCode4b_body		; $5fe8


; ==============================================================================
; INTERACID_BIRD
; ==============================================================================
interactionCode4c:
	ld e,Interaction.state		; $5ff0
	ld a,(de)		; $5ff2
	rst_jumpTable			; $5ff3
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $5ff8
	ld (de),a		; $5ffa
	call interactionInitGraphics		; $5ffb
	call objectSetVisiblec2		; $5ffe
	call @initSubid		; $6001
	ld e,Interaction.enabled		; $6004
	ld a,(de)		; $6006
	or a			; $6007
	jp nz,objectMarkSolidPosition		; $6008
	ret			; $600b

@initSubid:
	ld e,Interaction.subid		; $600c
	ld a,(de)		; $600e
	rst_jumpTable			; $600f
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04


; Listening to Nayru at the start of the game
@initSubid00:
	call _bird_hop		; $601a
	ld hl,birdScript_listeningToNayruGameStart		; $601d
	jp interactionSetScript		; $6020


; Bird with Impa when Zelda gets kidnapped
@initSubid04:
	ld a,(wEssencesObtained)		; $6023
	bit 2,a			; $6026
	jp z,interactionDelete		; $6028

	call checkIsLinkedGame		; $602b
	jp z,interactionDelete		; $602e

	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA		; $6031
	call checkGlobalFlag		; $6033
	jp nz,interactionDelete		; $6036

	ld hl,birdScript_zeldaKidnapped		; $6039
	call interactionSetScript		; $603c
	call interactionSetAlwaysUpdateBit		; $603f

	ld a,GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED		; $6042
	call checkGlobalFlag		; $6044
	jr z,@setAnimation0AndJump	; $6047

	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE		; $6049
	call checkGlobalFlag		; $604b
	jr z,@impaNotMoved	; $604e

	; Have talked to impa; adjust position
	ld e,Interaction.yh		; $6050
	ld a,$58		; $6052
	ld (de),a		; $6054
	jr @setAnimation0AndJump		; $6055

@impaNotMoved:
	ld e,Interaction.xh		; $6057
	ld a,$68		; $6059
	ld (de),a		; $605b
	jr @setAnimation0AndJump		; $605c


; Different colored birds that do nothing but hop? Used in a cutscene?
@initSubid01:
@initSubid02:
@initSubid03:
	; [oamFlags] = [subid]
	ld a,(de)		; $605e
	ld e,Interaction.oamFlags		; $605f
	ld (de),a		; $6061

@setAnimation0AndJump:
	xor a			; $6062
	call interactionSetAnimation		; $6063
	jp _bird_hop		; $6066


@state1:
	ld e,Interaction.subid		; $6069
	ld a,(de)		; $606b
	rst_jumpTable			; $606c
	.dw _bird_runSubid0
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw _bird_runSubid4


; Listening to Nayru at the start of the game
_bird_runSubid0:
	call interactionAnimateAsNpc		; $6077
	ld e,Interaction.state2		; $607a
	ld a,(de)		; $607c
	rst_jumpTable			; $607d
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfd0)		; $6086
	cp $0e			; $6089
	jr nz,++		; $608b

	call interactionIncState2		; $608d
	ld a,$01		; $6090
	jp interactionSetAnimation		; $6092
++
	ld e,Interaction.var37		; $6095
	ld a,(de)		; $6097
	or a			; $6098
	call nz,_bird_updateGravityAndHopWhenHitGround		; $6099
	jp interactionRunScript		; $609c

@substate1:
	ld a,($cfd0)		; $609f
	cp $10			; $60a2
	ret nz			; $60a4

	call interactionIncState2		; $60a5
	ld l,Interaction.counter1		; $60a8
	ld (hl),$1e		; $60aa
	call _bird_hop		; $60ac
	ld a,$02		; $60af
	jp interactionSetAnimation		; $60b1

@substate2:
	call interactionDecCounter1		; $60b4
	jr nz,_bird_updateGravityAndHopWhenHitGround	; $60b7

	; Begin running away
	call interactionIncState2		; $60b9
	ld l,Interaction.zh		; $60bc
	ld (hl),$00		; $60be
	ld l,Interaction.angle		; $60c0
	ld (hl),$01		; $60c2
	ld l,Interaction.speed		; $60c4
	ld (hl),SPEED_100		; $60c6
	ld bc,-$100		; $60c8
	call objectSetSpeedZ		; $60cb
	ld a,$03		; $60ce
	jp interactionSetAnimation		; $60d0

@substate3:
	; Delete self when off-screen
	call objectCheckWithinScreenBoundary		; $60d3
	jp nc,interactionDelete		; $60d6

	xor a			; $60d9
	call objectUpdateSpeedZ		; $60da
	jp objectApplySpeed		; $60dd


; Bird with Impa when Zelda gets kidnapped
_bird_runSubid4:
	call interactionAnimateAsNpc		; $60e0
	call _bird_updateGravityAndHopWhenHitGround		; $60e3
	call interactionRunScript		; $60e6
	jp c,interactionDelete		; $60e9

	; Check whether to move the bird over (to make way to Link)
	ld a,GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED		; $60ec
	call checkGlobalFlag		; $60ee
	ret z			; $60f1

	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE		; $60f2
	call checkGlobalFlag		; $60f4
	ret nz			; $60f7

	; Increase x position until it reaches $68
	ld e,Interaction.xh		; $60f8
	ld a,(de)		; $60fa
	cp $68			; $60fb
	ret z			; $60fd

	inc a			; $60fe
	ld (de),a		; $60ff
	ret			; $6100

_bird_updateGravityAndHopWhenHitGround:
	ld c,$20		; $6101
	call objectUpdateSpeedZ_paramC		; $6103
	ret nz			; $6106
	ld h,d			; $6107

_bird_hop:
	ld bc,-$c0		; $6108
	jp objectSetSpeedZ		; $610b


; ==============================================================================
; INTERACID_AMBI
; ==============================================================================
interactionCode4d:
	ld e,Interaction.state		; $610e
	ld a,(de)		; $6110
	rst_jumpTable			; $6111
	.dw @state0
	.dw _ambi_state1

@state0:
	ld a,$01		; $6116
	ld (de),a		; $6118
	call interactionInitGraphics		; $6119
	call objectSetVisiblec2		; $611c
	call @initSubid		; $611f
	ld e,Interaction.enabled		; $6122
	ld a,(de)		; $6124
	or a			; $6125
	jp nz,objectMarkSolidPosition		; $6126
	ret			; $6129

@initSubid:
	ld e,Interaction.subid		; $612a
	ld a,(de)		; $612c
	rst_jumpTable			; $612d
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @initSubid06
	.dw @initSubid07
	.dw _ambi_loadScript
	.dw _ambi_ret
	.dw @initSubid0a


; Cutscene after escaping black tower
@initSubid01:
	ld a,($cfd0)		; $6144
	cp $0b			; $6147
	jp nz,_ambi_loadScript		; $6149
	call checkIsLinkedGame		; $614c
	ret nz			; $614f
	ld hl,ambiSubid01Script_part2		; $6150
	jp interactionSetScript		; $6153


; Cutscene where Ambi does evil stuff atop black tower (after d7)
@initSubid03:
	call getThisRoomFlags		; $6156
	bit 6,a			; $6159
	jp nz,interactionDelete		; $615b


; Same cutscene as subid $03, but second part
@initSubid04:
	callab interactionBank08.nayruState0@init0e		; $615e
	jp _ambi_loadScript		; $6166


; Cutscene where you give mystery seeds to Ambi
@initSubid00:
	call _soldierCheckBeatD6		; $6169
	jp nc,interactionDelete		; $616c


; Credits cutscene where Ambi observes construction of Link statue
@initSubid02:
	jp _ambi_loadScript		; $616f


; Cutscene where Ralph confronts Ambi
@initSubid05:
	; Call some of nayru's code to load possessed palette
	callab interactionBank08.nayruState0@init0e		; $6172

	call objectSetVisiblec3		; $617a
	jp _ambi_loadScript		; $617d


; Cutscene just before fighting possessed Ambi
@initSubid06:
	call getThisRoomFlags		; $6180
	bit 7,a			; $6183
	jp nz,interactionDelete		; $6185

	; Load possessed palette and use it
	ld a,PALH_85		; $6188
	call loadPaletteHeader		; $618a
	ld h,d			; $618d
	ld l,Interaction.oamFlags		; $618e
	ld a,$06		; $6190
	ldd (hl),a		; $6192
	ld (hl),a		; $6193

	ld a,$01		; $6194
	ld (wNumEnemies),a		; $6196

	; Create "ghost veran" object above Ambi
	call getFreeInteractionSlot		; $6199
	jr z,++			; $619c

	ld e,Interaction.state		; $619e
	xor a			; $61a0
	ld (de),a		; $61a1
	ret			; $61a2
++
	ld (hl),INTERACID_GHOST_VERAN		; $61a3
	inc l			; $61a5
	inc (hl)		; $61a6
	ld bc,$f000		; $61a7
	call objectCopyPositionWithOffset		; $61aa

	ld a,SNDCTRL_STOPMUSIC		; $61ad
	call playSound		; $61af

	; Set Link's direction & angle to "up"
	ld hl,w1Link.direction		; $61b2
	xor a			; $61b5
	ldi (hl),a		; $61b6
	ld (hl),a		; $61b7

	ld (wDisableLinkCollisionsAndMenu),a		; $61b8
	ld ($cfc0),a		; $61bb
	dec a			; $61be
	ld (wActiveMusic),a		; $61bf

	ld hl,$cc93		; $61c2
	set 7,(hl)		; $61c5

	ld a,LINK_STATE_FORCE_MOVEMENT		; $61c7
	ld (wLinkForceState),a		; $61c9
	ld a,$16		; $61cc
	ld (wLinkStateParameter),a		; $61ce


; Cutscene where Ambi regains control of herself
@initSubid07:
	jp _ambi_loadScript		; $61d1

@initSubid0a:
	call checkIsLinkedGame		; $61d4
	jp z,interactionDelete		; $61d7
	ld hl,wGroup4Flags+$fc		; $61da
	bit 7,(hl)		; $61dd
	jp z,interactionDelete		; $61df
	jp _ambi_loadScript		; $61e2

_ambi_state1:
	ld e,Interaction.subid		; $61e5
	ld a,(de)		; $61e7
	rst_jumpTable			; $61e8
	.dw _ambi_updateAnimationAndRunScript
	.dw _ambi_runSubid01
	.dw _ambi_runSubid02
	.dw _ambi_runSubid03
	.dw _ambi_runSubid04
	.dw _ambi_runSubid05
	.dw _ambi_runSubid06
	.dw _ambi_runSubid07
	.dw _ambi_runSubid08
	.dw interactionAnimate
	.dw _ambi_runSubid0a

_ambi_updateAnimationAndRunScript:
	call interactionAnimate		; $61ff
	jp interactionRunScript		; $6202


; Cutscene after escaping black tower
_ambi_runSubid01:
	call checkIsLinkedGame		; $6205
	jr z,@updateSubstate	; $6208
	ld a,($cfd0)		; $620a
	cp $0b			; $620d
	jp c,@updateSubstate		; $620f

	call interactionAnimate		; $6212
	jpab scriptHlp.turnToFaceSomething		; $6215

@updateSubstate:
	ld e,Interaction.state2		; $621d
	ld a,(de)		; $621f
	rst_jumpTable			; $6220
	.dw @substate0
	.dw @substate1
	.dw _ambi_updateAnimationAndRunScript

@substate0:
	ld a,($cfd0)		; $6227
	cp $0e			; $622a
	jr nz,_ambi_updateAnimationAndRunScript	; $622c

	callab interactionBank08.startJump		; $622e
	jp interactionIncState2		; $6236

@substate1:
	ld c,$20		; $6239
	call objectUpdateSpeedZ_paramC		; $623b
	ret nz			; $623e

	call interactionIncState2		; $623f
	ld l,Interaction.var3e		; $6242
	inc (hl)		; $6244

_ambi_ret:
	ret			; $6245


; Credits cutscene where Ambi observes construction of Link statue
_ambi_runSubid02:
	ld e,Interaction.state2		; $6246
	ld a,(de)		; $6248
	rst_jumpTable			; $6249
	.dw @substate0
	.dw @substate1
	.dw interactionAnimateBasedOnSpeed

@substate0:
	call _ambi_updateAnimationAndRunScript		; $6250
	ret nc			; $6253
	jp interactionIncState2		; $6254

@substate1:
	call interactionAnimateBasedOnSpeed		; $6257
	call objectApplySpeed		; $625a
	ld a,($cfc0)		; $625d
	cp $06			; $6260
	ret nz			; $6262
	call interactionIncState2		; $6263
	ld bc,$5040		; $6266
	jp interactionSetPosition		; $6269


; Cutscene where Ambi does evil stuff atop black tower (after d7)
_ambi_runSubid03:
	ld e,Interaction.state2		; $626c
	ld a,(de)		; $626e
	rst_jumpTable			; $626f
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @updateAnimationAndRunScript

@substate0:
	ld a,($cfc0)		; $627a
	cp $01			; $627d
	jr nz,@updateAnimationAndRunScript	; $627f

	call interactionIncState2		; $6281
	ld l,Interaction.counter1		; $6284
	ld (hl),SPEED_80		; $6286

	call getFreePartSlot		; $6288
	ret nz			; $628b
	ld (hl),PARTID_LIGHTNING		; $628c
	inc l			; $628e
	inc (hl) ; [subid] = $01
	inc l			; $6290
	inc (hl) ; [var03] = $01
	jp objectCopyPosition		; $6292

@updateAnimationAndRunScript:
	call interactionAnimateBasedOnSpeed		; $6295
	jp interactionRunScript		; $6298

@substate1:
	call interactionDecCounter1		; $629b
	ret nz			; $629e
	xor a			; $629f
	ld (wTmpcbb3),a		; $62a0
	dec a			; $62a3
	ld (wTmpcbba),a		; $62a4
	jp interactionIncState2		; $62a7

@substate2:
	ld hl,wTmpcbb3		; $62aa
	ld b,$02		; $62ad
	call flashScreen		; $62af
	ret z			; $62b2

	call interactionIncState2		; $62b3
	ldbc INTERACID_SPARKLE,$08		; $62b6
	call objectCreateInteraction		; $62b9
	ld a,$02		; $62bc
	jp fadeinFromWhiteWithDelay		; $62be

@substate3:
	ld a,(wPaletteThread_mode)		; $62c1
	or a			; $62c4
	ret nz			; $62c5
	ld a,$02		; $62c6
	ld ($cfc0),a		; $62c8
	jp interactionIncState2		; $62cb


; Same cutscene as subid $03 (black tower after d7), but second part
_ambi_runSubid04:
	ld e,Interaction.state2		; $62ce
	ld a,(de)		; $62d0
	rst_jumpTable			; $62d1
	.dw @substate0
	.dw @substate1
	.dw interactionAnimate

@substate0:
	call _ambi_updateAnimationAndRunScript		; $62d8
	ret nc			; $62db
	xor a			; $62dc
	ld (wTmpcbb3),a		; $62dd
	dec a			; $62e0
	ld (wTmpcbba),a		; $62e1
	jp interactionIncState2		; $62e4

@substate1:
	ld hl,wTmpcbb3		; $62e7
	ld b,$02		; $62ea
	call flashScreen		; $62ec
	ret z			; $62ef
	ld a,$03		; $62f0
	ld ($cfc0),a		; $62f2
	jp interactionIncState2		; $62f5

_ambi_runSubid05:
	call interactionRunScript		; $62f8
	jp c,interactionDelete		; $62fb
	ld a,($cfc0)		; $62fe
	bit 1,a			; $6301
	jp z,interactionAnimate		; $6303
	ret			; $6306

; Unused?
@data:
	.db $82 $90 $00 $55 $03


; $06: Cutscene just before fighting possessed Ambi
; $07: Cutscene where Ambi regains control of herself
_ambi_runSubid06:
_ambi_runSubid07:
	call interactionRunScript		; $630c
	jp nc,interactionAnimate		; $630f
	ld a,$01		; $6312
	ld (wLoadedTreeGfxIndex),a		; $6314
	jp interactionDelete		; $6317


; Cutscene after d3 where you're told Ambi's tower will soon be complete
_ambi_runSubid08:
	call _ambi_updateAnimationAndRunScript		; $631a
	ret nc			; $631d

	ld a,$01		; $631e
	ld ($cbb8),a		; $6320
	ld a,CUTSCENE_BLACK_TOWER_EXPLANATION		; $6323
	ld (wCutsceneTrigger),a		; $6325
	jp interactionDelete		; $6328


; NPC after Zelda is kidnapped
_ambi_runSubid0a:
	call npcFaceLinkAndAnimate		; $632b
	jp interactionRunScript		; $632e


_ambi_loadScript:
	ld e,Interaction.subid		; $6331
	ld a,(de)		; $6333
	ld hl,@scriptTable		; $6334
	rst_addDoubleIndex			; $6337
	ldi a,(hl)		; $6338
	ld h,(hl)		; $6339
	ld l,a			; $633a
	jp interactionSetScript		; $633b

@scriptTable:
	.dw ambiSubid00Script
	.dw ambiSubid01Script_part1
	.dw ambiSubid02Script
	.dw ambiSubid03Script
	.dw ambiSubid04Script
	.dw ambiSubid05Script
	.dw ambiSubid06Script
	.dw ambiSubid07Script
	.dw ambiSubid08Script
	.dw stubScript
	.dw ambiSubid0aScript


; ==============================================================================
; INTERACID_SUBROSIAN
; ==============================================================================
interactionCode4e:
	ld e,Interaction.subid		; $6354
	ld a,(de)		; $6356
	rst_jumpTable			; $6357
	.dw _subrosian_subid00
	.dw _subrosian_subid01
	.dw _subrosian_subid02
	.dw _subrosian_subid03
	.dw _subrosian_subid04


; Subrosian in lynna village (linked only)
_subrosian_subid00:
	call checkInteractionState		; $6362
	jr nz,@state1	; $6365

@state0:
	call interactionIncState		; $6367
	call interactionInitGraphics		; $636a
	call objectSetVisiblec2		; $636d
	ld a,>TX_1c00		; $6370
	call interactionSetHighTextIndex		; $6372

	call checkIsLinkedGame		; $6375
	jp z,interactionDeleteAndUnmarkSolidPosition		; $6378

	callab getGameProgress_2		; $637b
	ld a,b			; $6383
	cp $05			; $6384
	ld hl,subrosianInVillageScript_afterGotMakuSeed		; $6386
	jr z,@setScript	; $6389
	cp $07			; $638b
	jp nz,interactionDeleteAndUnmarkSolidPosition		; $638d

	ld hl,subrosianInVillageScript_postGame		; $6390

@setScript:
	call interactionSetScript		; $6393

@state1:
	call interactionRunScript		; $6396
	jp npcFaceLinkAndAnimate		; $6399

_subrosian_subid01:
	; Borrow goron code?
	jpab _goronSubid01		; $639c


; Subrosian in goron dancing game (var03 is 0 or 1 for green or red npcs)
_subrosian_subid02:
	call checkInteractionState		; $63a4
	jr nz,@state1	; $63a7

@state0:
	call _subrosian_initSubid02		; $63a9
	call interactionRunScript		; $63ac
@state1:
	call interactionRunScript		; $63af
	jp c,interactionDelete		; $63b2
	jp npcFaceLinkAndAnimate		; $63b5


; Linked game NPC telling you the subrosian secret (for bombchus)
_subrosian_subid03:
	call checkInteractionState		; $63b8
	jr nz,_subrosian_subid04@state1	; $63bb

@state0:
	call _subrosian_initGraphicsAndIncState		; $63bd
	ld a,$02		; $63c0
	jr _subrosian_subid04@initSecretTellingNpc		; $63c2


; Linked game NPC telling you the smith secret (for shield upgrade)
_subrosian_subid04:
	call checkInteractionState		; $63c4
	jr nz,@state1	; $63c7

@state0:
	call _subrosian_initGraphicsAndIncState		; $63c9
	ld a,$04		; $63cc

@initSecretTellingNpc:
	ld e,Interaction.var3f		; $63ce
	ld (de),a		; $63d0
	ld hl,linkedGameNpcScript		; $63d1
	call interactionSetScript		; $63d4
	call interactionRunScript		; $63d7
@state1:
	call interactionRunScript		; $63da
	jp c,interactionDeleteAndUnmarkSolidPosition		; $63dd
	jp npcFaceLinkAndAnimate		; $63e0

;;
; @addr{63e3}
_subrosian_initGraphicsAndIncState:
	call interactionInitGraphics		; $63e3
	call objectMarkSolidPosition		; $63e6
	jp interactionIncState		; $63e9

;;
; @addr{63ec}
_subrosian_unused_63ec:
	call interactionInitGraphics		; $63ec
	call objectMarkSolidPosition		; $63ef
	jr _subrosian_loadScript		; $63f2


;;
; @addr{63f4}
_subrosian_initSubid02:
	call interactionInitGraphics		; $63f4
	call objectMarkSolidPosition		; $63f7
	jr _subrosian_loadScriptIndex			; $63fa

;;
; Load a script based just on the subid.
; @addr{63fc}
_subrosian_loadScript:
	call _subrosian_getScriptPtr		; $63fc
	call interactionSetScript		; $63ff
	jp interactionIncState		; $6402

;;
; Load a script based on the subid and var03.
; @addr{6405}
_subrosian_loadScriptIndex:
	call _subrosian_getScriptPtr		; $6405
	inc e			; $6408
	ld a,(de)		; $6409
	rst_addDoubleIndex			; $640a
	ldi a,(hl)		; $640b
	ld h,(hl)		; $640c
	ld l,a			; $640d
	call interactionSetScript		; $640e
	jp interactionIncState		; $6411

;;
; @param[out]	hl	Pointer read from scriptTable (either points to a script or to
;			a table of scripts)
; @addr{6414}
_subrosian_getScriptPtr:
	ld a,>TX_1c00		; $6414
	call interactionSetHighTextIndex		; $6416
	ld e,Interaction.subid		; $6419
	ld a,(de)		; $641b
	ld hl,@scriptTable		; $641c
	rst_addDoubleIndex			; $641f
	ldi a,(hl)		; $6420
	ld h,(hl)		; $6421
	ld l,a			; $6422
	ret			; $6423

; @addr{6424}
@scriptTable:
	.dw stubScript
	.dw stubScript
	.dw @subid02Scripts

@subid02Scripts:
	.dw subrosianAtGoronDanceScript_greenNpc
	.dw subrosianAtGoronDanceScript_redNpc


; ==============================================================================
; INTERACID_IMPA_NPC
; ==============================================================================
interactionCode4f:
	ld e,Interaction.subid		; $642e
	ld a,(de)		; $6430
	rst_jumpTable			; $6431
	.dw _impaNpc_subid00
	.dw _impaNpc_subid01
	.dw _impaNpc_subid02
	.dw _impaNpc_subid03

_impaNpc_subid00:
	call checkInteractionState		; $643a
	jr z,@state0	; $643d

@state1:
	call interactionRunScript		; $643f
	ld e,Interaction.var03		; $6442
	ld a,(de)		; $6444
	dec a			; $6445
	jr z,@animate	; $6446

	cp $09			; $6448
	call nz,_impaNpc_faceLinkIfClose		; $644a
@animate:
	jp interactionAnimateAsNpc		; $644d

@state0:
	; Set the tile leading to nayru's basement to behave like stairs
	ld hl,wRoomLayout+$22		; $6450
	ld (hl),TILEINDEX_INDOOR_DOWNSTAIRCASE		; $6453

	call _getImpaNpcState		; $6455
	bit 7,b			; $6458
	jp nz,interactionDelete		; $645a

	call checkIsLinkedGame		; $645d
	jr z,+			; $6460
	ld a,$09		; $6462
+
	add b			; $6464
	call _impaNpc_determineTextAndPositionInHouse		; $6465

;;
; @param	hl	Script address
; @addr{6468}
_impaNpc_setScriptAndInitialize:
	call interactionSetScript		; $6468
	call interactionInitGraphics		; $646b
	call interactionIncState		; $646e
	ld l,Interaction.textID+1		; $6471
	ld (hl),>TX_0100		; $6473

	call objectMarkSolidPosition		; $6475

	ld e,Interaction.var38		; $6478
	ld a,(de)		; $647a
	call interactionSetAnimation		; $647b

	jp objectSetVisiblec2		; $647e

;;
; Sets low byte of textID and returns a script address to use.
;
; May delete itself, then pop the return address from the stack to return from caller...
;
; @param	a	Index of "behaviour" ($00-$08 for unlinked, $09-$11 for linked)
; @param[out]	hl	Script address
; @addr{6481}
_impaNpc_determineTextAndPositionInHouse:
	ld e,Interaction.var03		; $6481
	ld (de),a		; $6483
	rst_jumpTable			; $6484
	.dw @val00
	.dw @val01
	.dw @val02
	.dw @val03
	.dw @val04
	.dw @val05
	.dw @delete
	.dw @delete
	.dw @delete
	.dw @val09
	.dw @val0a
	.dw @val0b
	.dw @delete
	.dw @val0d
	.dw @val0e
	.dw @delete
	.dw @delete
	.dw @delete

@delete:
	pop hl			; $64a9
	jp interactionDelete		; $64aa

@val00:
@val09:
	ld bc,$3838		; $64ad
	ld a,<TX_0120		; $64b0
	jr @setTextAndPosition		; $64b2

@val01:
@val0a:
	ld bc,$4828		; $64b4
	ld a,<TX_0121		; $64b7
	call @setTextAndPosition		; $64b9
	ld (de),a		; $64bc
	ld hl,impaNpcScript_lookingAtPassage		; $64bd
	ret			; $64c0

@val02:
@val03:
@val04:
@val0b:
	ld bc,$2868		; $64c1
	ld a,<TX_0122		; $64c4
	jr @setTextAndPosition		; $64c6

@val0d:
	ld bc,$2868		; $64c8
	ld a,<TX_012c		; $64cb
	jr @setTextAndPosition		; $64cd

@val05:
@val0e:
	ld bc,$2868		; $64cf
	ld a,<TX_0123		; $64d2

@setTextAndPosition:
	ld e,Interaction.textID		; $64d4
	ld (de),a		; $64d6
	ld e,Interaction.yh		; $64d7
	ld a,b			; $64d9
	ld (de),a		; $64da
	ld e,$4d		; $64db
	ld a,c			; $64dd
	ld (de),a		; $64de

	; var38 is the direction to face
	ld e,Interaction.var38		; $64df
	ld a,$02		; $64e1
	ld (de),a		; $64e3

	ld hl,genericNpcScript		; $64e4
	xor a			; $64e7
	ret			; $64e8


; Impa in past (after telling you about Ralph's heritage)
_impaNpc_subid01:
	call checkInteractionState		; $64e9
	jr nz,_impaNpc_runScriptAndFaceLink	; $64ec
	call _getImpaNpcState		; $64ee
	ld a,b			; $64f1
	cp $07			; $64f2
	jp nz,interactionDelete		; $64f4

	call checkIsLinkedGame		; $64f7
	ld a,<TX_012b		; $64fa
	jr z,_impaNpc_setTextIndexAndLoadGenericNpcScript			; $64fc
	ld a,<TX_012e		; $64fe


;;
; @param	a	Low byte of text index (high byte is $01)
_impaNpc_setTextIndexAndLoadGenericNpcScript:
	ld e,Interaction.textID		; $6500
	ld (de),a		; $6502

	; var38 is the direction to face
	ld e,Interaction.var38		; $6503
	ld a,$02		; $6505
	ld (de),a		; $6507

	ld hl,genericNpcScript		; $6508
	jp _impaNpc_setScriptAndInitialize		; $650b


; Impa after Zelda's been kidnapped
_impaNpc_subid02:
	call checkInteractionState		; $650e
	jr nz,_impaNpc_runScriptAndFaceLink	; $6511

@state0:
	call _getImpaNpcState		; $6513
	ld a,b			; $6516
	cp $08			; $6517
	jp nz,interactionDelete		; $6519
	ld a,<TX_012f		; $651c
	jr _impaNpc_setTextIndexAndLoadGenericNpcScript		; $651e


_impaNpc_runScriptAndFaceLink:
	call interactionRunScript		; $6520
	call _impaNpc_faceLinkIfClose		; $6523
	jp interactionAnimateAsNpc		; $6526


; Impa after getting the maku seed
_impaNpc_subid03:
	call checkInteractionState		; $6529
	jr nz,_impaNpc_runScriptAndFaceLink	; $652c

	call _getImpaNpcState		; $652e
	ld a,b			; $6531
	cp $06			; $6532
	jp nz,interactionDelete		; $6534

	ld a,<TX_0123		; $6537
	jr _impaNpc_setTextIndexAndLoadGenericNpcScript		; $6539

;;
; @addr{653b}
_impaNpc_faceLinkIfClose:
	ld c,$28		; $653b
	call objectCheckLinkWithinDistance		; $653d
	jr nc,@noChange	; $6540

	call objectGetAngleTowardEnemyTarget		; $6542
	add $04			; $6545
	and $18			; $6547
	swap a			; $6549
	rlca			; $654b
	jr @updateDirection		; $654c

@noChange:
	ld e,Interaction.var38		; $654e
	ld a,(de)		; $6550
@updateDirection:
	ld h,d			; $6551
	ld l,Interaction.direction		; $6552
	cp (hl)			; $6554
	ret z			; $6555
	ld (hl),a		; $6556
	jp interactionSetAnimation		; $6557

;;
; Returns something in 'b':
; * $00 before d2 breaks down;
; * $01 after d2 breaks down;
; * $02 after obtaining harp;
; * $03 after beating d3;
; * $04 after saving Zelda from vire;
; * $05 after saving Nayru;
; * $06 after getting maku seed;
; * $07 after cutscene where Impa tells you about Ralph's heritage;
; * $08 after flame of despair is lit (beat Veran in a linked game);
; * $ff after finishing game
;
; @param[out]	b	Return value
; @addr{655a}
_getImpaNpcState:
	ld a,GLOBALFLAG_FINISHEDGAME		; $655a
	call checkGlobalFlag		; $655c
	ld b,$ff		; $655f
	ret nz			; $6561
	inc b			; $6562
	ld a,(wPresentRoomFlags+$83)		; $6563
	rlca			; $6566
	ret nc			; $6567

	ld a,TREASURE_HARP		; $6568
	call checkTreasureObtained		; $656a
	ld b,$01		; $656d
	ret nc			; $656f

	ld a,GLOBALFLAG_SAVED_NAYRU		; $6570
	call checkGlobalFlag		; $6572
	jr nz,@savedNayru	; $6575

	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA		; $6577
	call checkGlobalFlag		; $6579
	ld b,$04		; $657c
	ret nz			; $657e

	ld a,TREASURE_ESSENCE		; $657f
	call checkTreasureObtained		; $6581
	bit 2,a			; $6584
	ld b,$02		; $6586
	ret z			; $6588
	inc b			; $6589
	ret			; $658a

@savedNayru:
	ld a,TREASURE_MAKU_SEED		; $658b
	call checkTreasureObtained		; $658d
	ld b,$05		; $6590
	ret nc			; $6592

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE		; $6593
	call checkGlobalFlag		; $6595
	ld b,$06		; $6598
	ret z			; $659a

	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT		; $659b
	call checkGlobalFlag		; $659d
	ld b,$07		; $65a0
	ret z			; $65a2
	inc b			; $65a3
	ret			; $65a4


; ==============================================================================
; INTERACID_DUMBBELL_MAN
; ==============================================================================
interactionCode51:
	call checkInteractionState		; $65a5
	jr nz,@state1		; $65a8

@state0:
	call @initialize		; $65aa
	call interactionSetAlwaysUpdateBit		; $65ad

@state1:
	call interactionRunScript		; $65b0
	jp c,interactionDelete		; $65b3
	jp interactionAnimateAsNpc		; $65b6
	call interactionInitGraphics		; $65b9
	jp interactionIncState		; $65bc

@initialize:
	call interactionInitGraphics		; $65bf
	ld a,>TX_0b00		; $65c2
	call interactionSetHighTextIndex		; $65c4
	ld e,Interaction.subid		; $65c7
	ld a,(de)		; $65c9
	ld hl,@scriptTable		; $65ca
	rst_addDoubleIndex			; $65cd
	ldi a,(hl)		; $65ce
	ld h,(hl)		; $65cf
	ld l,a			; $65d0
	call interactionSetScript		; $65d1
	jp interactionIncState		; $65d4

@scriptTable:
	.dw dumbbellManScript


; ==============================================================================
; INTERACID_OLD_MAN
; ==============================================================================
interactionCode52:
	ld e,Interaction.subid		; $65d9
	ld a,(de)		; $65db
	rst_jumpTable			; $65dc
	.dw @runSubid00
	.dw @runSubid01
	.dw @runSubid02
	.dw @runSubid03
	.dw @runSubid04
	.dw @runSubid05
	.dw @runSubid06

; Old man who takes a secret to give you the shield (same spot as subid $02)
@runSubid00:
	call checkInteractionState		; $65eb
	jr nz,@@state1	; $65ee


@@state0:
	call @loadScriptAndInitGraphics		; $65f0
@@state1:
	call interactionRunScript		; $65f3
	jp c,interactionDelete		; $65f6
	jp npcFaceLinkAndAnimate		; $65f9


; Old man who gives you book of seals
@runSubid01:
	call checkInteractionState		; $65fc
	call z,@loadScriptAndInitGraphics		; $65ff
	call interactionRunScript		; $6602
	jp c,interactionDelete		; $6605
	jp interactionAnimateAsNpc		; $6608


; Old man guarding fairy powder in past (same spot as subid $00)
@runSubid02:
	call checkInteractionState		; $660b
	jr nz,@@state1		; $660e

@@state0:
	ld a,GLOBALFLAG_FINISHEDGAME		; $6610
	call checkGlobalFlag		; $6612
	jp nz,interactionDelete		; $6615
	call @loadScriptAndInitGraphics		; $6618

@@state1:
	call interactionAnimateAsNpc		; $661b
	call interactionRunScript		; $661e
	ret nc			; $6621
	ld a,SND_TELEPORT		; $6622
	call playSound		; $6624
	ld hl,@warpDest		; $6627
	jp setWarpDestVariables		; $662a

@warpDest:
	m_HardcodedWarpA ROOM_AGES_5ec, $00, $17, $03


; Generic NPCs in the past library
@runSubid03:
@runSubid04:
@runSubid05:
@runSubid06:
	call checkInteractionState		; $6632
	jr z,@@state0		; $6635

@@state1:
	call interactionRunScript		; $6637
	jp interactionAnimateAsNpc		; $663a

@@state0:
	call interactionInitGraphics		; $663d
	call interactionIncState		; $6640

	ld l,Interaction.textID+1		; $6643
	ld (hl),>TX_3300		; $6645

	ld l,Interaction.collisionRadiusX		; $6647
	ld (hl),$06		; $6649
	ld l,Interaction.direction		; $664b
	dec (hl)		; $664d

	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $664e
	call checkGlobalFlag		; $6650
	ld b,$00		; $6653
	jr z,+			; $6655
	inc b			; $6657
+
	ld e,Interaction.subid		; $6658
	ld a,(de)		; $665a
	sub $03			; $665b
	ld c,a			; $665d
	add a			; $665e
	add b			; $665f
	ld hl,@textIndices		; $6660
	rst_addAToHl			; $6663
	ld e,Interaction.textID		; $6664
	ld a,(hl)		; $6666
	ld (de),a		; $6667

	ld a,c			; $6668
	add a			; $6669
	add c			; $666a
	ld hl,@baseVariables		; $666b
	rst_addAToHl			; $666e
	ld e,Interaction.collisionRadiusY		; $666f
	ldi a,(hl)		; $6671
	ld (de),a		; $6672
	ld e,Interaction.oamFlagsBackup		; $6673
	ldi a,(hl)		; $6675
	ld (de),a		; $6676
	inc e			; $6677
	ld (de),a		; $6678
	ld e,Interaction.var38		; $6679
	ld a,(hl)		; $667b
	ld (de),a		; $667c
	call interactionSetAnimation		; $667d
	call objectSetVisiblec2		; $6680

	ld hl,oldManScript_generic		; $6683
	jp interactionSetScript		; $6686


; b0: collisionRadiusY
; b1: oamFlagsBackup
; b2: animation (can be thought of as direction to face?)
@baseVariables:
	.db $12 $02 $02
	.db $06 $00 $00
	.db $06 $00 $00
	.db $06 $01 $02

; The first and second columns are the text to show before and after the water pollution
; is fixed, respectively.
@textIndices:
	.db <TX_3300, <TX_3301
	.db <TX_3302, <TX_3303
	.db <TX_3304, <TX_3305
	.db <TX_3306, <TX_3307

@func_669d: ; Unused?
	call interactionInitGraphics		; $669d
	jp interactionIncState		; $66a0

@loadScriptAndInitGraphics:
	call interactionInitGraphics		; $66a3
	ld e,Interaction.subid		; $66a6
	ld a,(de)		; $66a8
	ld hl,@scriptTable		; $66a9
	rst_addDoubleIndex			; $66ac
	ldi a,(hl)		; $66ad
	ld h,(hl)		; $66ae
	ld l,a			; $66af
	call interactionSetScript		; $66b0
	jp interactionIncState		; $66b3

@scriptTable:
	.dw oldManScript_givesShieldUpgrade
	.dw oldManScript_givesBookOfSeals
	.dw oldManScript_givesFairyPowder


; ==============================================================================
; INTERACID_MAMAMU_YAN
; ==============================================================================
interactionCode53:
	call checkInteractionState		; $66bc
	jr nz,@state1		; $66bf

@state0:
	call @initGraphicsLoadScriptAndIncState		; $66c1

@state1:
	call interactionRunScript		; $66c4
	jp c,interactionDelete		; $66c7
	jp npcFaceLinkAndAnimate		; $66ca


@initGraphicsAncIncState: ; Unused?
	call interactionInitGraphics		; $66cd
	jp interactionIncState		; $66d0


@initGraphicsLoadScriptAndIncState:
	call interactionInitGraphics		; $66d3
	ld a,>TX_0b00		; $66d6
	call interactionSetHighTextIndex		; $66d8
	ld e,Interaction.subid		; $66db
	ld a,(de)		; $66dd
	ld hl,@scriptTable		; $66de
	rst_addDoubleIndex			; $66e1
	ldi a,(hl)		; $66e2
	ld h,(hl)		; $66e3
	ld l,a			; $66e4
	call interactionSetScript		; $66e5
	jp interactionIncState		; $66e8

@scriptTable:
	.dw mamamuYanScript


; ==============================================================================
; INTERACID_MAMAMU_DOG
;
; Variables (for subid $01):
;   var3a: Target position index
;   var3b: Highest valid value for "var3a" (before looping?)
;   var3c/3d: Address of "position data" to get target position from
;   var3e: Used as a counter in script
;   var3f: Animation index
; ==============================================================================
interactionCode54:
	ld e,Interaction.subid		; $66ed
	ld a,(de)		; $66ef
	rst_jumpTable			; $66f0
	.dw _dog_subid00
	.dw _dog_subid01

; Dog in mamamu's house
_dog_subid00:
	call checkInteractionState		; $66f5
	jr nz,@state1	; $66f8

@state0:
	ld a,GLOBALFLAG_FINISHEDGAME		; $66fa
	call checkGlobalFlag		; $66fc
	jr z,@dontDelete	; $66ff

	ld a,GLOBALFLAG_RETURNED_DOG		; $6701
	call checkGlobalFlag		; $6703
	jp nz,@dontDelete		; $6706

	call getThisRoomFlags		; $6709
	bit 5,(hl)		; $670c
	jp nz,interactionDelete		; $670e

@dontDelete:
	call _dog_initGraphicsLoadScriptAndIncState		; $6711
	ld h,d			; $6714
	ld l,Interaction.angle		; $6715
	ld (hl),$18		; $6717
	ld l,Interaction.speed		; $6719
	ld (hl),SPEED_100		; $671b

	ld a,$02		; $671d
	ld l,Interaction.var3f		; $671f
	ld (hl),a		; $6721
	call interactionSetAnimation		; $6722
@state1:
	call interactionRunScript		; $6725
	jp c,interactionDelete		; $6728
	call interactionAnimate		; $672b
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $672e


; Dog outside that Link needs to find for a "sidequest"
_dog_subid01:
	ld e,Interaction.state		; $6731
	ld a,(de)		; $6733
	rst_jumpTable			; $6734
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,GLOBALFLAG_RETURNED_DOG		; $673b
	call checkGlobalFlag		; $673d
	jp nz,interactionDelete		; $6740
	ld hl,wPresentRoomFlags+$e7		; $6743
	bit 7,(hl)		; $6746
	jp z,interactionDelete		; $6748

	; Check if the dog's location corresponds to this object; if not, delete self.
	ld a,(wMamamuDogLocation)		; $674b
	ld h,d			; $674e
	ld l,Interaction.var03		; $674f
	cp (hl)			; $6751
	jp nz,interactionDelete		; $6752

	call _dog_initGraphicsLoadScriptAndIncState		; $6755
	ld l,Interaction.speed		; $6758
	ld (hl),SPEED_80		; $675a
	ld l,Interaction.direction		; $675c
	ld (hl),$ff		; $675e

	; a==0 here, which is important. It was set to 0 by the call to
	; "interactionSetScript", and wasn't changed after that...
	; It's probably supposed to equal "var03" here. Bug?
	call _dog_setTargetPositionIndex		; $6760

	ld hl,wMamamuDogLocation		; $6763
@tryAgain:
	call getRandomNumber		; $6766
	and $03			; $6769
	cp (hl)			; $676b
	jr z,@tryAgain		; $676c
	ld (hl),a		; $676e

@state1:
	call _dog_moveTowardTargetPosition		; $676f
	call _dog_checkCloseToTargetPosition		; $6772
	call c,_dog_incTargetPositionIndex		; $6775
	jr c,@delete	; $6778

	call _dog_moveTowardTargetPosition		; $677a
	call _dog_updateDirection		; $677d
	call _dog_checkCloseToTargetPosition		; $6780
	call c,_dog_incTargetPositionIndex		; $6783
	jr c,@delete	; $6786

	callab scriptHlp.mamamuDog_updateSpeedZ		; $6788
	call interactionAnimate		; $6790
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $6793
	jp objectAddToGrabbableObjectBuffer		; $6796

@delete:
	jp interactionDelete		; $6799


; State 2: grabbed by Link (will cause Link to warp to mamamu's house)
@state2:
	inc e			; $679c
	ld a,(de)		; $679d
	rst_jumpTable			; $679e
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

; Just grabbed
@substate0:
	xor a			; $67a7
	ld (wLinkGrabState2),a		; $67a8
	inc a			; $67ab
	ld (de),a		; $67ac
	ld a,GLOBALFLAG_RETURNED_DOG		; $67ad
	call setGlobalFlag		; $67af
	ld a,$81		; $67b2
	ld (wMenuDisabled),a		; $67b4
	ld (wDisableScreenTransitions),a		; $67b7
	jp objectSetVisiblec1		; $67ba

; Being lifted
@substate1:
	ld e,Interaction.var39		; $67bd
	ld a,(de)		; $67bf
	rst_jumpTable			; $67c0
	.dw @@minorState0
	.dw @@minorState1
	.dw @@minorState2

@@minorState0:
	ld a,(wLinkGrabState)		; $67c7
	cp $83			; $67ca
	ret nz			; $67cc

	ld a,$81		; $67cd
	ld (wDisabledObjects),a		; $67cf
	ld a,$80		; $67d2
	ld (wMenuDisabled),a		; $67d4
	ld h,d			; $67d7
	ld l,Interaction.var39		; $67d8
	inc (hl)		; $67da
	ld l,Interaction.counter1		; $67db
	ld (hl),40		; $67dd

@@minorState1:
	call interactionDecCounter1		; $67df
	ret nz			; $67e2

	ld h,d			; $67e3
	ld l,Interaction.var39		; $67e4
	inc (hl)		; $67e6
	ld bc,TX_007f		; $67e7
	jp showText		; $67ea

@@minorState2:
	ld a,(wTextIsActive)		; $67ed
	or a			; $67f0
	ret nz			; $67f1
	ld hl,@warpDest		; $67f2
	call setWarpDestVariables		; $67f5
	ld a,SND_TELEPORT		; $67f8
	jp playSound		; $67fa

@warpDest:
	m_HardcodedWarpA ROOM_AGES_2e7, $00, $25, $83

@substate2:
	ret			; $6802

@substate3:
	jp objectSetVisiblec2		; $6803


@initGraphicsAndIncState: ; Unused?
	call interactionInitGraphics		; $6806
	call objectMarkSolidPosition		; $6809
	jp interactionIncState		; $680c


_dog_initGraphicsLoadScriptAndIncState:
	call interactionInitGraphics		; $680f
	call objectMarkSolidPosition		; $6812
	ld e,Interaction.subid		; $6815
	ld a,(de)		; $6817
	ld hl,_dog_scriptTable		; $6818
	rst_addDoubleIndex			; $681b
	ldi a,(hl)		; $681c
	ld h,(hl)		; $681d
	ld l,a			; $681e
	call interactionSetScript		; $681f
	jp interactionIncState		; $6822

;;
; @addr{6825}
_dog_moveTowardTargetPosition:
	ld h,d			; $6825
	ld l,Interaction.var3a		; $6826
	ld a,(hl)		; $6828
	add a			; $6829
	ld b,a			; $682a

	ld e,Interaction.var3d		; $682b
	ld a,(de)		; $682d
	ld l,a			; $682e
	ld e,Interaction.var3c		; $682f
	ld a,(de)		; $6831
	ld h,a			; $6832
	ld a,b			; $6833
	rst_addAToHl			; $6834
	ld b,(hl)		; $6835
	inc hl			; $6836
	ld c,(hl)		; $6837
	call objectGetRelativeAngle		; $6838
	ld e,Interaction.angle		; $683b
	ld (de),a		; $683d
	jp objectApplySpeed		; $683e

;;
; @param[out]	cflag	Set if close to target position
; @addr{6841}
_dog_checkCloseToTargetPosition:
	call _dog_getTargetPositionAddress		; $6841
	ld l,Interaction.yh		; $6844
	ld a,(bc)		; $6846
	sub (hl)		; $6847
	add $01			; $6848
	cp $05			; $684a
	ret nc			; $684c
	inc bc			; $684d
	ld l,Interaction.xh		; $684e
	ld a,(bc)		; $6850
	sub (hl)		; $6851
	add $01			; $6852
	cp $05			; $6854
	ret			; $6856

;;
; Update direction based on angle.
; @addr{6857}
_dog_updateDirection:
	ld h,d			; $6857
	ld l,Interaction.angle		; $6858
	ld a,(hl)		; $685a
	swap a			; $685b
	and $01			; $685d
	xor $01			; $685f
	ld l,Interaction.direction		; $6861
	cp (hl)			; $6863
	ret z			; $6864
	ld (hl),a		; $6865
	add $02			; $6866
	jp interactionSetAnimation		; $6868

;;
; @param[out]	cflag	Set if the position index "looped" (dog went off-screen)
; @addr{686b}
_dog_incTargetPositionIndex:
	call _dog_snapToTargetPosition		; $686b
	ld h,d			; $686e
	ld l,Interaction.var3b		; $686f
	ld a,(hl)		; $6871
	ld l,Interaction.var3a		; $6872
	inc (hl)		; $6874

	; Check whether to loop back around
	cp (hl)			; $6875
	ret nc			; $6876
	ld (hl),$00		; $6877
	scf			; $6879
	ret			; $687a

;;
; @addr{687b}
_dog_snapToTargetPosition:
	call _dog_getTargetPositionAddress		; $687b
	ld l,Interaction.y		; $687e
	xor a			; $6880
	ldi (hl),a		; $6881
	ld a,(bc)		; $6882
	ld (hl),a		; $6883
	inc bc			; $6884
	ld l,Interaction.x		; $6885
	xor a			; $6887
	ldi (hl),a		; $6888
	ld a,(bc)		; $6889
	ld (hl),a		; $688a
	ret			; $688b

;;
; @param[out]	bc	Address of target position (2 bytes, Y and X)
; @addr{688c}
_dog_getTargetPositionAddress:
	ld e,Interaction.var3d		; $688c
	ld a,(de)		; $688e
	ld c,a			; $688f
	ld e,Interaction.var3c		; $6890
	ld a,(de)		; $6892
	ld b,a			; $6893
	ld h,d			; $6894
	ld l,Interaction.var3a		; $6895
	ld a,(hl)		; $6897
	call addDoubleIndexToBc		; $6898
	ret			; $689b

;;
; This function is supposed to return the address of a "position list" for a map; however,
; due to an apparent issue with the caller, the data for the first map is always used.
;
; @param	a	Index of data to read (0-3 for corresponding maps)
; @addr{689c}
_dog_setTargetPositionIndex:
	ld hl,@dogPositionLists		; $689c
	rst_addDoubleIndex			; $689f
	ld e,Interaction.var3d		; $68a0
	ldi a,(hl)		; $68a2
	ld (de),a		; $68a3
	ld e,Interaction.var3c		; $68a4
	ldi a,(hl)		; $68a6
	ld (de),a		; $68a7

	ld e,Interaction.var3b		; $68a8
	ld a,$06		; $68aa
	ld (de),a		; $68ac
	ret			; $68ad

@dogPositionLists:
	.dw @map0
	.dw @map1
	.dw @map2
	.dw @map3

@map0:
	.db $68 $68
	.db $48 $48
	.db $68 $18
	.db $68 $48
	.db $48 $28
	.db $68 $58
	.db $48 $00
@map1:
	.db $38 $78
	.db $68 $28
	.db $68 $88
	.db $68 $38
	.db $28 $68
	.db $58 $48
	.db $48 $b0
@map2:
	.db $68 $28
	.db $48 $08
	.db $58 $58
	.db $28 $18
	.db $18 $68
	.db $48 $38
	.db $00 $68
@map3:
	.db $18 $38
	.db $68 $78
	.db $68 $28
	.db $38 $78
	.db $38 $38
	.db $58 $68
	.db $58 $00


_dog_scriptTable:
	.dw dogInMamamusHouseScript


; ==============================================================================
; INTERACID_POSTMAN
; ==============================================================================
interactionCode55:
	call checkInteractionState		; $68f0
	jr nz,@state1		; $68f3

@state0:
	call @loadScriptAndInitGraphics		; $68f5
@state1:
	call interactionRunScript		; $68f8
	jp c,interactionDelete		; $68fb

	ld e,Interaction.var3f		; $68fe
	ld a,(de)		; $6900
	or a			; $6901
	jp z,npcFaceLinkAndAnimate		; $6902
	call interactionAnimateBasedOnSpeed		; $6905
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6908

@unusedFunc_690b:
	call interactionInitGraphics		; $690b
	jp interactionIncState		; $690e

@loadScriptAndInitGraphics:
	call interactionInitGraphics		; $6911
	ld a,>TX_0b00		; $6914
	call interactionSetHighTextIndex		; $6916

	ld e,Interaction.subid		; $6919
	ld a,(de)		; $691b
	ld hl,@scriptTable		; $691c
	rst_addDoubleIndex			; $691f
	ldi a,(hl)		; $6920
	ld h,(hl)		; $6921
	ld l,a			; $6922
	call interactionSetScript		; $6923

	jp interactionIncState		; $6926

@scriptTable:
	.dw postmanScript


; ==============================================================================
; INTERACID_PICKAXE_WORKER
; ==============================================================================
interactionCode57:
	ld e,Interaction.subid		; $692b
	ld a,(de)		; $692d
	rst_jumpTable			; $692e
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03

; Subid 0: Worker below Maku Tree screen in past
; Subid 3: Worker in black tower.
@subid00:
@subid03:
	call checkInteractionState		; $6937
	jr nz,@@state1		; $693a

@@state0:
	call @loadScriptAndInitGraphics		; $693c
	call interactionSetAlwaysUpdateBit		; $693f

@@state1:
	call interactionRunScript		; $6942
	jp c,interactionDelete		; $6945

	call interactionAnimateAsNpc		; $6948
	ld e,Interaction.animParameter		; $694b
	ld a,(de)		; $694d
	or a			; $694e
	ret z			; $694f

	; animParameter is nonzero; just struck the ground.
	ld a,SND_CLINK		; $6950
	call playSound		; $6952
	ld a,(wScrollMode)		; $6955
	and $01			; $6958
	ret z			; $695a
	ld a,$03		; $695b
	jp @createDirtChips		; $695d


; Credits cutscene guy making Link statue?
@subid01:
	call checkInteractionState		; $6960
	jr nz,@subid1State1		; $6963

@subid1And2State0:
	ld e,Interaction.subid		; $6965
	ld a,(de)		; $6967
	dec a			; $6968
	ld a,$0c		; $6969
	jr z,+			; $696b
	ld a,$f4		; $696d
+
	ld e,Interaction.var38		; $696f
	ld (de),a		; $6971
	call @loadScriptAndInitGraphics		; $6972

@subid1State1:
	ld e,Interaction.state2		; $6975
	ld a,(de)		; $6977
	rst_jumpTable			; $6978
	.dw @subid1And2Substate0
	.dw @subid1Substate1
	.dw @subid1Substate2
	.dw @subid1Substate3
	.dw @updateAnimationAndRunScript


@subid1And2Substate0:
	ld a,($cfc0)		; $6983
	cp $01			; $6986
	jr nz,@label_09_221	; $6988

	call interactionIncState2		; $698a
	ld l,Interaction.subid		; $698d
	ld a,(hl)		; $698f
	dec a			; $6990
	ld hl,@subid1And2ScriptTable		; $6991
	rst_addDoubleIndex			; $6994
	ldi a,(hl)		; $6995
	ld h,(hl)		; $6996
	ld l,a			; $6997
	jp interactionSetScript		; $6998

@label_09_221:
	call interactionAnimateBasedOnSpeed		; $699b
	call interactionRunScript		; $699e
	ld h,d			; $69a1
	ld l,Interaction.animParameter		; $69a2
	ld a,(hl)		; $69a4
	or a			; $69a5
	jr z,@doneSpawningObjects			; $69a6

	; Spawn in some objects when pickaxe hits statue?
	ld (hl),$00		; $69a8
	ld b,$04		; $69aa
@nextObject:
	call getFreeInteractionSlot		; $69ac
	ret nz			; $69af
	ld (hl),INTERACID_EXPLOSION_WITH_DEBRIS		; $69b0
	inc l			; $69b2
	ld (hl),$02		; $69b3
	inc l			; $69b5
	ld (hl),b		; $69b6
	ld e,Interaction.visible		; $69b7
	ld a,(de)		; $69b9
	ld l,Interaction.var38		; $69ba
	ld (hl),a		; $69bc
	push bc			; $69bd
	ld e,Interaction.var38		; $69be
	ld a,(de)		; $69c0
	ld b,$00		; $69c1
	ld c,a			; $69c3
	call objectCopyPositionWithOffset		; $69c4
	pop bc			; $69c7
	dec b			; $69c8
	jr nz,@nextObject	; $69c9

@doneSpawningObjects:
	ld l,Interaction.yh		; $69cb
	ld a,(hl)		; $69cd
	cp $50			; $69ce
	jp nc,objectSetVisiblec1		; $69d0
	jp objectSetVisiblec3		; $69d3

@subid1Substate1:
	call @updateAnimationAndRunScript		; $69d6
	ret nc			; $69d9
	call interactionIncState2		; $69da
	ld l,Interaction.counter1		; $69dd
	ld (hl),210		; $69df
	ret			; $69e1

@updateAnimationAndRunScript:
	ld e,Interaction.var3f		; $69e2
	ld a,(de)		; $69e4
	or a			; $69e5
	call z,interactionAnimateBasedOnSpeed		; $69e6
	jp interactionRunScript		; $69e9

@subid1Substate2:
	call interactionAnimateBasedOnSpeed		; $69ec
	call objectApplySpeed		; $69ef
	call interactionDecCounter1		; $69f2
	ret nz			; $69f5
	call interactionIncState2		; $69f6
	jp fadeoutToWhite		; $69f9

@subid1Substate3:
	ld a,(wPaletteThread_mode)		; $69fc
	or a			; $69ff
	ret nz			; $6a00

	call interactionIncState2		; $6a01
	ld a,$06		; $6a04
	ld ($cfc0),a		; $6a06
	call disableLcd		; $6a09
	push de			; $6a0c

	; Force-reload maku tree screen?
	ld bc,$0138		; $6a0d
	ld a,$00		; $6a10
	call func_36f6		; $6a12

	ld a,UNCMP_GFXH_2d		; $6a15
	call loadUncompressedGfxHeader		; $6a17
	ld a,PALH_30		; $6a1a
	call loadPaletteHeader		; $6a1c
	ld a,GFXH_84		; $6a1f
	call loadGfxHeader		; $6a21

	ld a,$ff		; $6a24
	ld (wTilesetAnimation),a		; $6a26
	ld a,$04		; $6a29
	call loadGfxRegisterStateIndex		; $6a2b

	pop de			; $6a2e
	ld bc,$427e		; $6a2f
	call interactionSetPosition		; $6a32
	ld a,$02		; $6a35
	ld hl,@subid1And2ScriptTable		; $6a37
	rst_addDoubleIndex			; $6a3a
	ldi a,(hl)		; $6a3b
	ld h,(hl)		; $6a3c
	ld l,a			; $6a3d
	call interactionSetScript		; $6a3e
	jp fadeinFromWhite		; $6a41


; Credits cutscene guy making Link statue?
@subid02:
	call checkInteractionState		; $6a44
	jr nz,++		; $6a47
	jp @subid1And2State0		; $6a49
++
	ld e,Interaction.state2		; $6a4c
	ld a,(de)		; $6a4e
	rst_jumpTable			; $6a4f
	.dw @subid1And2Substate0
	.dw @subid2Substate1
	.dw @subid2Substate2
	.dw @updateAnimationAndRunScript

@subid2Substate1:
	call @updateAnimationAndRunScript		; $6a58
	ret nc			; $6a5b
	call interactionIncState2		; $6a5c

@subid2Substate2:
	call interactionAnimateBasedOnSpeed		; $6a5f
	call objectApplySpeed		; $6a62
	ld a,($cfc0)		; $6a65
	cp $06			; $6a68
	ret nz			; $6a6a
	call interactionIncState2		; $6a6b
	ld bc,$388a		; $6a6e
	call interactionSetPosition		; $6a71
	ld a,$03		; $6a74
	ld hl,@subid1And2ScriptTable		; $6a76
	rst_addDoubleIndex			; $6a79
	ldi a,(hl)		; $6a7a
	ld h,(hl)		; $6a7b
	ld l,a			; $6a7c
	jp interactionSetScript		; $6a7d


@unusedFunc_6a80:
	call interactionInitGraphics		; $6a80
	call objectMarkSolidPosition		; $6a83
	jp interactionIncState		; $6a86


@loadScriptAndInitGraphics:
	call interactionInitGraphics		; $6a89
	call objectMarkSolidPosition		; $6a8c
	ld a,>TX_1b00		; $6a8f
	call interactionSetHighTextIndex		; $6a91
	ld e,Interaction.subid		; $6a94
	ld a,(de)		; $6a96
	ld hl,@scriptTable		; $6a97
	rst_addDoubleIndex			; $6a9a
	ldi a,(hl)		; $6a9b
	ld h,(hl)		; $6a9c
	ld l,a			; $6a9d
	call interactionSetScript		; $6a9e
	jp interactionIncState		; $6aa1

;;
; Create the debris that comes out when the pickaxe hits the ground.
; @addr{6aa4}
@createDirtChips:
	ld c,a			; $6aa4
	ld b,$02		; $6aa5

; b = number of objects to create
; c = var03
@next:
	call getFreeInteractionSlot		; $6aa7
	ret nz			; $6aaa
	ld (hl),INTERACID_FALLING_ROCK		; $6aab
	inc l			; $6aad
	ld (hl),$06 ; [new.subid] = $06
	inc l			; $6ab0
	ld (hl),c   ; [new.var03] = c

	ld e,Interaction.visible		; $6ab2
	ld a,(de)		; $6ab4
	and $03			; $6ab5
	ld l,Interaction.counter2		; $6ab7
	ld (hl),a		; $6ab9
	ld l,Interaction.angle		; $6aba
	ld (hl),b		; $6abc
	dec (hl)		; $6abd

	push bc			; $6abe
	call objectCopyPosition		; $6abf
	pop bc			; $6ac2

	; [new.yh] = [this.yh]+4
	ld l,Interaction.yh		; $6ac3
	ld a,(hl)		; $6ac5
	add $04			; $6ac6

	; [new.xh] = [this.xh]-$0e if [this.animParameter] == $01, otherwise [this.xh]+$0e
	ld (hl),a		; $6ac8
	ld e,Interaction.animParameter		; $6ac9
	ld a,(de)		; $6acb
	cp $01			; $6acc
	ld l,Interaction.xh		; $6ace
	ld a,(hl)		; $6ad0
	jr z,+			; $6ad1
	add $0e*2			; $6ad3
+
	sub $0e			; $6ad5
	ld (hl),a		; $6ad7

	dec b			; $6ad8
	jr nz,@next	; $6ad9
	ret			; $6adb


@scriptTable:
	.dw pickaxeWorkerSubid00Script
	.dw pickaxeWorkerSubid01Script_part1
	.dw pickaxeWorkerSubid02Script_part1
	.dw pickaxeWorkerSubid03Script

@subid1And2ScriptTable:
	.dw pickaxeWorkerSubid01Script_part2
	.dw pickaxeWorkerSubid02Script_part2
	.dw pickaxeWorkerSubid01Script_part3
	.dw pickaxeWorkerSubid02Script_part3


; ==============================================================================
; INTERACID_HARDHAT_WORKER
; ==============================================================================
interactionCode58:
	ld e,Interaction.subid		; $6aec
	ld a,(de)		; $6aee
	rst_jumpTable			; $6aef
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03


; NPC who gives you the shovel. If var03 is nonzero, he's just a generic guy.
@subid00:
	call checkInteractionState		; $6af8
	jr nz,@@state1	; $6afb

@@state0:
	call @loadScriptAndInitGraphics		; $6afd
	call interactionSetAlwaysUpdateBit		; $6b00
	ld a,$04		; $6b03
	call interactionSetAnimation		; $6b05
@@state1:
	call interactionRunScript		; $6b08
	jp c,interactionDelete		; $6b0b
	jp interactionAnimateAsNpc		; $6b0e


; Generic NPC.
@subid01:
	call checkInteractionState		; $6b11
	jr nz,@@state1		; $6b14

@@state0:
	call @loadScriptAndInitGraphics		; $6b16
	call interactionRunScript		; $6b19
	call interactionRunScript		; $6b1c
@@state1:
	call interactionRunScript		; $6b1f
	jp c,interactionDeleteAndUnmarkSolidPosition		; $6b22
	jp npcFaceLinkAndAnimate		; $6b25


; NPC who guards the entrance to the black tower.
@subid02:
	call checkInteractionState		; $6b28
	jr nz,@@state1	; $6b2b

@@state0:
	ld a,(wEssencesObtained)		; $6b2d
	bit 3,a			; $6b30
	jp nz,interactionDelete		; $6b32
	call getThisRoomFlags		; $6b35
	bit 7,a			; $6b38
	jr z,+			; $6b3a
	ld bc,$3858		; $6b3c
	call interactionSetPosition		; $6b3f
+
	call @loadScriptAndInitGraphics		; $6b42
@@state1:
	call interactionRunScript		; $6b45
	ld e,Interaction.var38		; $6b48
	ld a,(de)		; $6b4a
	or a			; $6b4b
	jp z,npcFaceLinkAndAnimate		; $6b4c
	jp interactionAnimateAsNpc		; $6b4f


@subid03:
	call checkInteractionState		; $6b52
	jr nz,@@state1		; $6b55

@@state0:
	call @loadScriptAndInitGraphics		; $6b57
	call interactionRunScript		; $6b5a
@@state1:
	call interactionRunScript		; $6b5d
	jp c,interactionDelete		; $6b60

	ld e,Interaction.var3f		; $6b63
	ld a,(de)		; $6b65
	or a			; $6b66
	jp z,npcFaceLinkAndAnimate		; $6b67
	call interactionAnimateBasedOnSpeed		; $6b6a
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $6b6d


@unusedFunc_6b70:
	call interactionInitGraphics		; $6b70
	call objectMarkSolidPosition		; $6b73
	jp interactionIncState		; $6b76


@loadScriptAndInitGraphics:
	call interactionInitGraphics		; $6b79
	call objectMarkSolidPosition		; $6b7c
	ld a,>TX_1000		; $6b7f
	call interactionSetHighTextIndex		; $6b81
	ld e,Interaction.subid		; $6b84
	ld a,(de)		; $6b86
	ld hl,@scriptTable		; $6b87
	rst_addDoubleIndex			; $6b8a
	ldi a,(hl)		; $6b8b
	ld h,(hl)		; $6b8c
	ld l,a			; $6b8d
	call interactionSetScript		; $6b8e
	jp interactionIncState		; $6b91

@scriptTable:
	.dw hardhatWorkerSubid00Script
	.dw hardhatWorkerSubid01Script
	.dw hardhatWorkerSubid02Script
	.dw hardhatWorkerSubid03Script


; ==============================================================================
; INTERACID_POE
;
; var3e: Animations don't update when nonzero. (Used when disappearing.)
; var3f: If nonzero, doesn't face toward Link.
; ==============================================================================
interactionCode59:
	call checkInteractionState		; $6b9c
	jr nz,@state1	; $6b9f

@state0:
	ld e,Interaction.var03		; $6ba1
	ld a,(de)		; $6ba3
	rst_jumpTable			; $6ba4
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02


; (Note, these are labelled as subid, but they're really based on var03.)
; First encounter with poe.
@initSubid00:
	; Delete self if already talked (either in overworld on in tomb)
	call getThisRoomFlags		; $6bab
	bit 6,(hl)		; $6bae
	jp nz,interactionDelete		; $6bb0
	ld hl,wPresentRoomFlags+$2e		; $6bb3
	bit 6,(hl)		; $6bb6
	jp nz,interactionDelete		; $6bb8

	jr @init		; $6bbb


; Final encounter with poe where you get the clock
@initSubid02:
	; Delete self if already got item, or haven't talked yet in either overworld or
	; tomb
	call getThisRoomFlags		; $6bbd
	bit ROOMFLAG_BIT_ITEM,(hl)		; $6bc0
	jp nz,interactionDelete		; $6bc2
	bit 6,(hl)		; $6bc5
	jp z,interactionDelete		; $6bc7
	ld hl,wPresentRoomFlags+$2e		; $6bca
	bit 6,(hl)		; $6bcd
	jp z,interactionDelete		; $6bcf

	jr @init		; $6bd2


; Poe in his tomb
@initSubid01:
	; Delete self if haven't talked in overworld, or have talked in tomb.
	ld hl,wPresentRoomFlags+$7c		; $6bd4
	bit 6,(hl)		; $6bd7
	jp z,interactionDelete		; $6bd9
	call getThisRoomFlags		; $6bdc
	bit 6,(hl)		; $6bdf
	jp nz,interactionDelete		; $6be1

@init:
	call @loadScriptAndInitGraphics		; $6be4
@state1:
	call interactionRunScript		; $6be7
	jp c,interactionDelete		; $6bea

	ld e,Interaction.var3e		; $6bed
	ld a,(de)		; $6bef
	or a			; $6bf0
	ret nz			; $6bf1
	ld e,Interaction.var3f		; $6bf2
	ld a,(de)		; $6bf4
	or a			; $6bf5
	jp z,npcFaceLinkAndAnimate		; $6bf6
	call interactionAnimate		; $6bf9
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6bfc


@unusedFunc_6bff:
	call interactionInitGraphics		; $6bff
	call objectMarkSolidPosition		; $6c02
	jp interactionIncState		; $6c05


@loadScriptAndInitGraphics:
	call interactionInitGraphics		; $6c08
	call objectMarkSolidPosition		; $6c0b
	ld e,Interaction.subid		; $6c0e
	ld a,(de)		; $6c10
	ld hl,@scriptTable		; $6c11
	rst_addDoubleIndex			; $6c14
	ldi a,(hl)		; $6c15
	ld h,(hl)		; $6c16
	ld l,a			; $6c17
	call interactionSetScript		; $6c18
	jp interactionIncState		; $6c1b

@scriptTable:
	.dw poeScript


; ==============================================================================
; INTERACID_OLD_ZORA
; ==============================================================================
interactionCode5a:
	call checkInteractionState		; $6c20
	jr nz,@state1	; $6c23

@state0:
	call @loadScriptAndInitGraphics		; $6c25
	call interactionSetAlwaysUpdateBit		; $6c28
@state1:
	call interactionRunScript		; $6c2b
	jp c,interactionDelete		; $6c2e
	jp interactionAnimateAsNpc		; $6c31

@unusedFunc_6c34:
	call interactionInitGraphics		; $6c34
	jp interactionIncState		; $6c37

@loadScriptAndInitGraphics:
	call interactionInitGraphics		; $6c3a
	ld a,>TX_0b00		; $6c3d
	call interactionSetHighTextIndex		; $6c3f
	ld e,Interaction.subid		; $6c42
	ld a,(de)		; $6c44
	ld hl,@scriptTable		; $6c45
	rst_addDoubleIndex			; $6c48
	ldi a,(hl)		; $6c49
	ld h,(hl)		; $6c4a
	ld l,a			; $6c4b
	call interactionSetScript		; $6c4c
	jp interactionIncState		; $6c4f

@scriptTable:
	.dw oldZoraScript


; ==============================================================================
; INTERACID_TOILET_HAND
; ==============================================================================
interactionCode5b:
	ld e,Interaction.state		; $6c54
	ld a,(de)		; $6c56
	rst_jumpTable			; $6c57
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call @loadScriptAndInitGraphics		; $6c5e
	call interactionSetAlwaysUpdateBit		; $6c61
	callab interactionBank08.clearFallDownHoleEventBuffer		; $6c64


; Normal script is running; waiting for Link to talk or for something to fall into a hole.
@state1:
	call @respondToObjectInHole		; $6c6c
	jr c,@droppedSomethingIntoHole			; $6c6f

	call interactionRunScript		; $6c71
	ld h,d			; $6c74
	ld l,Interaction.visible		; $6c75
	bit 7,(hl)		; $6c77
	ret z			; $6c79
	jp interactionAnimateAsNpc		; $6c7a

@droppedSomethingIntoHole:
	ld hl,toiletHandScript_reactToObjectInHole		; $6c7d
	call interactionSetScript		; $6c80
	jp interactionIncState		; $6c83


; Running the "object fell in a hole" script; returns to state 1 when that's done.
@state2:
	ld a,(wTextIsActive)		; $6c86
	or a			; $6c89
	ret nz			; $6c8a

	call interactionRunScript		; $6c8b
	jr c,@scriptEnded			; $6c8e

	ld h,d			; $6c90
	ld l,Interaction.visible		; $6c91
	bit 7,(hl)		; $6c93
	ret z			; $6c95
	call interactionAnimateAsNpc		; $6c96
	jp interactionAnimate		; $6c99

@scriptEnded:
	call @loadScript		; $6c9c
	callab interactionBank08.clearFallDownHoleEventBuffer		; $6c9f
	ld e,Interaction.state		; $6ca7
	ld a,$01		; $6ca9
	ld (de),a		; $6cab
	ret			; $6cac


@unusedFunc_6c0d:
	call interactionInitGraphics		; $6cad
	jp interactionIncState		; $6cb0


@loadScriptAndInitGraphics:
	call interactionInitGraphics		; $6cb3
	ld a,>TX_0b00		; $6cb6
	call interactionSetHighTextIndex		; $6cb8
	call interactionIncState		; $6cbb

@loadScript:
	ld e,Interaction.subid		; $6cbe
	ld a,(de)		; $6cc0
	ld hl,@scriptTable		; $6cc1
	rst_addDoubleIndex			; $6cc4
	ldi a,(hl)		; $6cc5
	ld h,(hl)		; $6cc6
	ld l,a			; $6cc7
	jp interactionSetScript		; $6cc8

;;
; Reads from the "object fallen in hole" buffer at $cfd8 to decide on a reaction. Sets
; var38 to an index based on which item it was to be used in a script later.
;
; @param[out]	cflag	c if there is a defined reaction to the object that fell in the
;                       hole (and something did indeed fall in).
; @addr{6ccb}
@respondToObjectInHole:
	ld a,(wTextIsActive)		; $6ccb
	or a			; $6cce
	ret nz			; $6ccf

	ld a,($cfd8)		; $6cd0
	inc a			; $6cd3
	ld e,a			; $6cd4
	ld hl,@objectTypeTable		; $6cd5
	call lookupKey		; $6cd8
	ret nc			; $6cdb

	ld hl,@objectReactionTable		; $6cdc
	rst_addDoubleIndex			; $6cdf
	ldi a,(hl)		; $6ce0
	ld h,(hl)		; $6ce1
	ld l,a			; $6ce2
	ld a,($cfd9)		; $6ce3
	ld e,a			; $6ce6
	call lookupKey		; $6ce7
	ret nc			; $6cea
	ld e,Interaction.var38		; $6ceb
	ld (de),a		; $6ced
	ret			; $6cee

@objectTypeTable:
	.db Item.id,        $00
	.db Interaction.id, $01
	.db $00

@objectReactionTable:
	.dw @items
	.dw @interactions

; First byte is the object ID to detect; second is an index that the script will use later
; (gets written to var38).
@items:
	.db ITEMID_BOMB,          $00
	.db ITEMID_BOMBCHUS,      $01
	.db ITEMID_18,            $02
	.db ITEMID_EMBER_SEED,    $03
	.db ITEMID_SCENT_SEED,    $04
	.db ITEMID_GALE_SEED,     $05
	.db ITEMID_MYSTERY_SEED,  $06
	.db ITEMID_BRACELET,      $07
	.db $00

@interactions:
	.db INTERACID_PUSHBLOCK,  $07
	.db $00

@scriptTable:
	.dw toiletHandScript


; ==============================================================================
; INTERACID_MASK_SALESMAN
; ==============================================================================
interactionCode5c:
	call checkInteractionState		; $6d0e
	jr nz,@state1	; $6d11

@state0:
	call @loadScriptAndInitGraphics		; $6d13
	call interactionSetAlwaysUpdateBit		; $6d16
@state1:
	call interactionRunScript		; $6d19
	jp c,interactionDelete		; $6d1c
	jp interactionAnimateAsNpc		; $6d1f
	call interactionInitGraphics		; $6d22
	jp interactionIncState		; $6d25

@loadScriptAndInitGraphics:
	call interactionInitGraphics		; $6d28
	ld e,Interaction.subid		; $6d2b
	ld a,(de)		; $6d2d
	ld hl,@scriptTable		; $6d2e
	rst_addDoubleIndex			; $6d31
	ldi a,(hl)		; $6d32
	ld h,(hl)		; $6d33
	ld l,a			; $6d34
	call interactionSetScript		; $6d35
	jp interactionIncState		; $6d38

@scriptTable:
	.dw maskSalesmanScript


; ==============================================================================
; INTERACID_BEAR
; ==============================================================================
interactionCode5d:
	ld e,Interaction.state		; $6d3d
	ld a,(de)		; $6d3f
	rst_jumpTable			; $6d40
	.dw _bear_state0
	.dw _bear_state1


_bear_state0:
	ld a,$01		; $6d45
	ld (de),a		; $6d47
	call interactionInitGraphics		; $6d48
	call objectSetVisiblec2		; $6d4b
	call @initSubid		; $6d4e
	ld e,Interaction.enabled		; $6d51
	ld a,(de)		; $6d53
	or a			; $6d54
	jp nz,objectMarkSolidPosition		; $6d55
	ret			; $6d58

@initSubid:
	ld e,Interaction.subid		; $6d59
	ld a,(de)		; $6d5b
	rst_jumpTable			; $6d5c
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02

@initSubid00:
	; If you've talked to the bear already, shift him down 16 pixels
	call getThisRoomFlags		; $6d63
	bit 7,a			; $6d66
	jr nz,++		; $6d68

	ld e,Interaction.yh		; $6d6a
	ld a,(de)		; $6d6c
	add $10			; $6d6d
	ld (de),a		; $6d6f
++
	ld hl,bearSubid00Script_part1		; $6d70
	jp interactionSetScript		; $6d73

@initSubid01:
	ret			; $6d76

@initSubid02:
	ld e,Interaction.var03		; $6d77
	ld a,(de)		; $6d79
	or a			; $6d7a
	jr nz,@var03IsNonzero	; $6d7b

	; var03 is $00.

	ld a,GLOBALFLAG_INTRO_DONE		; $6d7d
	call checkGlobalFlag		; $6d7f
	jp z,interactionDelete		; $6d82

	; Spawn animal buddies
	ld hl,objectData.animalsWaitingForNayru		; $6d85
	call parseGivenObjectData		; $6d88

	ld a,GLOBALFLAG_FINISHEDGAME		; $6d8b
	call checkGlobalFlag		; $6d8d
	jp nz,interactionDelete		; $6d90
	ld a,GLOBALFLAG_MAKU_TREE_SAVED		; $6d93
	call checkGlobalFlag		; $6d95
	jp z,interactionDelete		; $6d98

	; Text changes after saving Nayru
	ld a,GLOBALFLAG_SAVED_NAYRU		; $6d9b
	call checkGlobalFlag		; $6d9d
	ld a,$00		; $6da0
	jp z,+			; $6da2
	inc a			; $6da5
+
	jr ++		; $6da6

@var03IsNonzero:
	ld a,GLOBALFLAG_FINISHEDGAME		; $6da8
	call checkGlobalFlag		; $6daa
	jp z,interactionDelete		; $6dad
	ld a,$02		; $6db0
++
	call @chooseTextID		; $6db2
	ld hl,bearSubid02Script		; $6db5
	jp interactionSetScript		; $6db8

@chooseTextID:
	ld hl,@textIDs		; $6dbb
	rst_addAToHl			; $6dbe
	ld a,(hl)		; $6dbf
	ld e,Interaction.textID		; $6dc0
	ld (de),a		; $6dc2
	ld a,>TX_5700		; $6dc3
	inc e			; $6dc5
	ld (de),a		; $6dc6
	ret			; $6dc7

@textIDs:
	.db <TX_5712
	.db <TX_5713
	.db <TX_5714


_bear_state1:
	ld e,Interaction.subid		; $6dcb
	ld a,(de)		; $6dcd
	rst_jumpTable			; $6dce
	.dw @runSubid00
	.dw interactionAnimate
	.dw @runSubid02


; Bear listening to Nayru at start of game.
@runSubid00:
	call interactionAnimateAsNpc		; $6dd5
	ld e,Interaction.state2		; $6dd8
	ld a,(de)		; $6dda
	rst_jumpTable			; $6ddb
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	call interactionRunScript		; $6de6

	; Wait for Link to get close enough to trigger the cutscene
	ld hl,w1Link.xh		; $6de9
	ld a,(hl)		; $6dec
	cp $60			; $6ded
	ret c			; $6def
	ld l,<w1Link.yh		; $6df0
	ld a,(hl)		; $6df2
	cp $3e			; $6df3
	ret nc			; $6df5

	; Put Link into the cutscene state
	ld a,SPECIALOBJECTID_LINK_CUTSCENE		; $6df6
	call setLinkIDOverride		; $6df8
	ld l,<w1Link.subid		; $6dfb
	ld (hl),$03		; $6dfd

	ld hl,bearSubid00Script_part2		; $6dff
	call interactionSetScript		; $6e02
	call interactionIncState2		; $6e05

@substate1:
	call interactionRunScript		; $6e08
	ld a,($cfd0)		; $6e0b
	cp $0e			; $6e0e
	ret nz			; $6e10
	call interactionIncState2		; $6e11
	ld a,$02		; $6e14
	jp interactionSetAnimation		; $6e16

@substate2:
	call interactionAnimate		; $6e19
	ld a,($cfd0)		; $6e1c
	cp $10			; $6e1f
	ret nz			; $6e21
	call interactionIncState2		; $6e22
	ld l,Interaction.counter1		; $6e25
	ld (hl),40		; $6e27
	ret			; $6e29

@substate3:
	call interactionDecCounter1		; $6e2a
	jp nz,interactionAnimate		; $6e2d
	call interactionIncState2		; $6e30
	ld l,Interaction.angle		; $6e33
	ld (hl),$02		; $6e35
	ld l,Interaction.speed		; $6e37
	ld (hl),SPEED_100		; $6e39
	ld a,$01		; $6e3b
	jp interactionSetAnimation		; $6e3d

@substate4:
	call objectCheckWithinScreenBoundary		; $6e40
	jp nc,interactionDelete		; $6e43
	call objectApplySpeed		; $6e46
	jp interactionAnimate		; $6e49


@runSubid02:
	call interactionRunScript		; $6e4c
	jp c,interactionDelete		; $6e4f
	jp interactionAnimateAsNpc		; $6e52


; ==============================================================================
; INTERACID_SWORD
; ==============================================================================
interactionCode5e:
	ld e,Interaction.state		; $6e55
	ld a,(de)		; $6e57
	rst_jumpTable			; $6e58
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $6e5d
	ld (de),a		; $6e5f

	; var37 holds last animation (set $ff to force update)
	ld a,$ff		; $6e60
	ld e,Interaction.var37		; $6e62

	ld (de),a		; $6e64
	call interactionInitGraphics		; $6e65

@state1:
	; Invisible by default
	call objectSetInvisible		; $6e68

	; If [relatedObj1.enabled] & ([this.var3f]+1) == 0, delete self
	ld a,Object.enabled		; $6e6b
	call objectGetRelatedObject1Var		; $6e6d
	ld l,Interaction.var3f		; $6e70
	ld a,(hl)		; $6e72
	inc a			; $6e73
	ld l,Interaction.enabled		; $6e74
	and (hl)		; $6e76
	jp z,interactionDelete		; $6e77

	; Set visible if bit 7 of [relatedObj1.animParameter] is set
	ld l,Interaction.animParameter		; $6e7a
	ld a,(hl)		; $6e7c
	ld b,a			; $6e7d
	and $80			; $6e7e
	ret z			; $6e80

	; Animation number = [relatedObj1.animParameter]&0x7f
	ld a,b			; $6e81
	and $7f			; $6e82
	push hl			; $6e84
	ld h,d			; $6e85
	ld l,Interaction.var37		; $6e86
	cp (hl)			; $6e88
	jr z,+			; $6e89
	ld (hl),a		; $6e8b
	call interactionSetAnimation		; $6e8c
+
	pop hl			; $6e8f
	call objectTakePosition		; $6e90
	jp objectSetVisible83		; $6e93


; ==============================================================================
; INTERACID_SYRUP
;
; Variables:
;   var38: Set to 1 if Link can't purchase an item (because he has too many of it)
;   var3a: "Return value" from purchase script (if $ff, the purchase failed)
;   var3b: Object index of item that Link is holding
; ==============================================================================
interactionCode5f:
	callab checkReloadShopItemTiles		; $6e96
	call @runState		; $6e9e
	jp interactionAnimateAsNpc		; $6ea1

@runState:
	ld e,Interaction.state		; $6ea4
	ld a,(de)		; $6ea6
	rst_jumpTable			; $6ea7
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $6eae
	ld (de),a		; $6eb0

	call interactionInitGraphics		; $6eb1
	call interactionSetAlwaysUpdateBit		; $6eb4

	ld l,Interaction.collisionRadiusY		; $6eb7
	ld (hl),$12		; $6eb9
	inc l			; $6ebb
	ld (hl),$07		; $6ebc

	ld e,Interaction.pressedAButton		; $6ebe
	call objectAddToAButtonSensitiveObjectList		; $6ec0
	ld hl,syrupScript_spawnShopItems		; $6ec3
	jr @setScriptAndGotoState2		; $6ec6


; State 1: Waiting for Link to talk to her
@state1:
	ld e,Interaction.pressedAButton		; $6ec8
	ld a,(de)		; $6eca
	or a			; $6ecb
	ret z			; $6ecc

	xor a			; $6ecd
	ld (de),a		; $6ece

	ld a,$81		; $6ecf
	ld (wDisabledObjects),a		; $6ed1

	ld a,(wLinkGrabState)		; $6ed4
	or a			; $6ed7
	jr z,@talkToSyrupWithoutItem	; $6ed8

	; Get the object that Link is holding
	ld a,(w1Link.relatedObj2+1)		; $6eda
	ld h,a			; $6edd
	ld e,Interaction.var3b		; $6ede
	ld (de),a		; $6ee0

	; Assume he's holding an INTERACID_SHOP_ITEM. Subids $07-$0c are for syrup's shop.
	ld l,Interaction.subid		; $6ee1
	ld a,(hl)		; $6ee3
	push af			; $6ee4
	ld b,a			; $6ee5
	sub $07			; $6ee6

	ld e,Interaction.var37		; $6ee8
	ld (de),a		; $6eea

	; Check if Link has the rupees for it
	ld a,b			; $6eeb
	ld hl,_shopItemPrices		; $6eec
	rst_addAToHl			; $6eef
	ld a,(hl)		; $6ef0
	call cpRupeeValue		; $6ef1
	ld (wShopHaveEnoughRupees),a		; $6ef4
	ld ($cbad),a		; $6ef7

	; Check the item type, see if Link is allowed to buy any more than he already has
	pop af			; $6efa
	cp $07			; $6efb
	jr z,@checkPotion	; $6efd
	cp $09			; $6eff
	jr z,@checkPotion	; $6f01

	cp $0b			; $6f03
	jr z,@checkBombchus	; $6f05

	ld a,(wNumGashaSeeds)		; $6f07
	jr @checkQuantity		; $6f0a

@checkBombchus:
	ld a,(wNumBombchus)		; $6f0c

@checkQuantity:
	; For bombchus and gasha seeds, amount caps at 99
	cp $99			; $6f0f
	ld a,$01		; $6f11
	jr nc,@setCanPurchase	; $6f13
	jr @canPurchase		; $6f15

@checkPotion:
	ld a,TREASURE_POTION		; $6f17
	call checkTreasureObtained		; $6f19
	ld a,$01		; $6f1c
	jr c,@setCanPurchase	; $6f1e

@canPurchase:
	xor a			; $6f20

@setCanPurchase:
	; Set var38 to 1 if Link can't purchase the item because he has too much of it
	ld e,Interaction.var38		; $6f21
	ld (de),a		; $6f23

	ld hl,syrupScript_purchaseItem		; $6f24
	jr @setScriptAndGotoState2		; $6f27

@talkToSyrupWithoutItem:
	call _shopkeeperCheckAllItemsBought		; $6f29
	jr z,@showWelcomeText	; $6f2c

	ld hl,syrupScript_showClosedText		; $6f2e
	jr @setScriptAndGotoState2		; $6f31

@showWelcomeText:
	ld hl,syrupScript_showWelcomeText		; $6f33

@setScriptAndGotoState2:
	ld e,Interaction.state		; $6f36
	ld a,$02		; $6f38
	ld (de),a		; $6f3a
	jp interactionSetScript		; $6f3b


; State 2: running a script
@state2:
	call interactionRunScript		; $6f3e
	ret nc			; $6f41

	; Script done

	xor a			; $6f42
	ld (wDisabledObjects),a		; $6f43

	; Check response from script (was purchase successful?)
	ld e,Interaction.var3a		; $6f46
	ld a,(de)		; $6f48
	or a			; $6f49
	jr z,@gotoState1 ; Skip below code if he was holding nothing to begin with

	; If purchase was successful, set the held item (INTERACID_SHOP_ITEM) to state
	; 3 (link obtains it)
	inc a			; $6f4c
	ld c,$03		; $6f4d
	jr nz,++		; $6f4f

	; If purchase was not successful, set the held item to state 4 (return to display
	; area)
	ld c,$04		; $6f51
++
	xor a			; $6f53
	ld (de),a		; $6f54
	ld e,Interaction.var3b		; $6f55
	ld a,(de)		; $6f57
	ld h,a			; $6f58
	ld l,Interaction.state		; $6f59
	ld (hl),c		; $6f5b
	call dropLinkHeldItem		; $6f5c

@gotoState1:
	ld e,Interaction.state		; $6f5f
	ld a,$01		; $6f61
	ld (de),a		; $6f63
	ret			; $6f64


; ==============================================================================
; INTERACID_LEVER
;
; subid:    Bit 7 set if this is the "child" object (the part that links the lever base to
;           the part Link is pulling); otherwise, bit 0 set if the lever is pulled upward.
; var03:    Nonzero if the "child" lever (part that extends) has already been created?
; var30:    Y position at which lever is fully retracted.
; var31:    Number of units to pull the lever before it's fully pulled.
; var32/33: Address of something in wram (wLever1PullDistance or wLever2PullDistance)
; var34:    Y offset of Link relative to lever when he's pulling it
; var35:    Nonzero if lever was pulled last frame.
; ==============================================================================
interactionCode61:
	ld e,Interaction.subid		; $6f65
	ld a,(de)		; $6f67
	rlca			; $6f68
	ld e,Interaction.state		; $6f69
	jp c,@updateLeverConnectionObject		; $6f6b

	ld a,(de)		; $6f6e
	rst_jumpTable			; $6f6f
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call interactionInitGraphics		; $6f78
	ld e,Interaction.var03		; $6f7b
	ld a,(de)		; $6f7d
	or a			; $6f7e
	jr nz,@label_09_254	; $6f7f

	; Create new INTERACID_LEVER, and set their relatedObj1's to each other.
	; This new "child" object will just be the graphic for the "extending" part.
	call getFreeInteractionSlot		; $6f81
	ret nz			; $6f84
	ld (hl),INTERACID_LEVER		; $6f85
	ld l,Interaction.relatedObj1		; $6f87
	ld e,l			; $6f89
	ld a,Interaction.enabled		; $6f8a
	ld (de),a		; $6f8c
	ldi (hl),a		; $6f8d
	inc e			; $6f8e
	ld (hl),d		; $6f8f
	ld a,h			; $6f90
	ld (de),a		; $6f91

	; Jump if new object's slot >= this object's slot
	cp d			; $6f92
	jr nc,@label_09_253	; $6f93

	; Swap the subids of the two objects to ensure that the "parent" has a lower slot
	; number?
	ld l,Interaction.subid		; $6f95
	ld e,l			; $6f97
	ld a,(de)		; $6f98
	ldi (hl),a ; [new.subid] = [this.subid]

	ld a,$80		; $6f9a
	ld (de),a ; [this.subid] = $80
	inc (hl)  ; [new.var03] = $01

	jp objectCopyPosition		; $6f9e

@label_09_253:
	ld l,Interaction.subid		; $6fa1
	ld (hl),$80		; $6fa3

@label_09_254:
	call interactionIncState		; $6fa5

	; After above function call, h = d.
	ld l,Interaction.collisionRadiusY		; $6fa8
	ld (hl),$05		; $6faa
	inc l			; $6fac
	ld (hl),$01		; $6fad

	; [var30] = [yh]
	ld l,Interaction.yh		; $6faf
	ld a,(hl)		; $6fb1
	ld e,Interaction.var30		; $6fb2
	ld (de),a		; $6fb4

	; [var31] = y-offset of lever when fully extended.
	ld l,Interaction.subid		; $6fb5
	ld a,(hl)		; $6fb7
	and $30			; $6fb8
	swap a			; $6fba
	ld bc,@leverLengths		; $6fbc
	call addAToBc		; $6fbf
	inc e			; $6fc2
	ld a,(bc)		; $6fc3
	ld (de),a		; $6fc4

	; [var32/var33] = address of wLever1PullDistance or wLever2PullDistance
	ld bc,wLever1PullDistance		; $6fc5
	bit 6,(hl) ; Check bit 6 of subid
	jr z,+			; $6fca
	inc bc			; $6fcc
+
	inc e			; $6fcd
	ld a,c			; $6fce
	ld (de),a		; $6fcf
	inc e			; $6fd0
	ld a,b			; $6fd1
	ld (de),a		; $6fd2

	; [subid] &= $01 (only indicates direction of lever now)
	ld a,(hl)		; $6fd3
	and $01			; $6fd4
	ld (hl),a		; $6fd6

	; [var34] = Y offset of Link relative to lever when he's pulling it
	ld a,$0c		; $6fd7
	jr z,+			; $6fd9
	ld a,$f3		; $6fdb
+
	inc e			; $6fdd
	ld (de),a		; $6fde
	ld a,(hl)		; $6fdf
	call interactionSetAnimation		; $6fe0
	jp objectSetVisible83		; $6fe3


; Which byte is read from here depends on bits 4-5 of subid.
@leverLengths:
	.db $08 $10 $20 $40


; Waiting for Link to grab
@state1:
	call objectPushLinkAwayOnCollision		; $6fea

	; Get the rough "direction value" toward link (rounded to a cardinal direction)
	call objectGetAngleTowardEnemyTarget		; $6fed
	add $14			; $6ff0
	and $18			; $6ff2
	swap a			; $6ff4
	rlca			; $6ff6
	ld c,a			; $6ff7

	; Check that this direction matches the valid pulling direction and Link's facing
	; direction
	ld e,Interaction.subid		; $6ff8
	ld a,(de)		; $6ffa
	add a			; $6ffb
	cp c			; $6ffc
	ret nz			; $6ffd
	ld a,(w1Link.direction)		; $6ffe
	cp c			; $7001
	ret nz			; $7002

	; Allow to be grabbed
	jp objectAddToGrabbableObjectBuffer		; $7003


; State 2: Link is grabbing this.
@state2:
	inc e			; $7006
	ld a,(de)		; $7007
	rst_jumpTable			; $7008
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d			; $7011
	ld l,e			; $7012
	inc (hl)		; $7013
	ld a,$80		; $7014
	ld (wLinkGrabState2),a		; $7016

	; Calculate Link's y and x positions
	ld l,Interaction.xh		; $7019
	ld a,(hl)		; $701b
	ld (w1Link.xh),a		; $701c
	ld l,Interaction.var34		; $701f
	ld a,(hl)		; $7021
	ld l,Interaction.yh		; $7022
	add (hl)		; $7024
	ld (w1Link.yh),a		; $7025
	xor a			; $7028
	dec l			; $7029
	ld (hl),a		; $702a
	ld (w1Link.y),a		; $702b

	ld b,SPEED_40		; $702e
	inc a			; $7030
	jr @setSpeedAndAngle		; $7031

@substate1:
	; Check animParameter of the "parent item" for the power bracelet?
	ld a,(w1ParentItem2.animParameter)		; $7033
	or a			; $7036
	jr nz,++		; $7037
	ld e,Interaction.var35		; $7039
	ld (de),a		; $703b
	ret			; $703c
++
	call @checkLeverFullyExtended		; $703d
	ret nc			; $7040

	; Not fully extended yet. Set Link's speed/angle to this lever's speed/angle
	ld l,Interaction.angle		; $7041
	ld c,(hl)		; $7043
	ld l,Interaction.speed		; $7044
	ld b,(hl)		; $7046
	call updateLinkPositionGivenVelocity		; $7047

	; Update Lever's position based on Link's position.
	ld a,(w1Link.yh)		; $704a
	ld h,d			; $704d
	ld l,Interaction.var34		; $704e
	sub (hl)		; $7050
	ld l,Interaction.yh		; $7051
	ld (hl),a		; $7053

	; Take difference from lever's "base" position to get the number of pixels it's
	; been pulled.
	ld l,Interaction.var30		; $7054
	sub (hl)		; $7056
	call @updatePullOffset		; $7057

	; Return if lever position hasn't changed.
	cp b			; $705a
	ret z			; $705b

	; Play moveblock sound if lever was not pulled last frame, and it is not fully
	; pulled.
	ld h,d			; $705c
	ld l,Interaction.var35		; $705d
	bit 0,(hl)		; $705f
	ret nz			; $7061
	inc (hl)		; $7062
	bit 7,b			; $7063
	ret nz			; $7065

	ld a,SND_MOVEBLOCK		; $7066
	jp playSound		; $7068


; Lever just released?
@substate2:
@substate3:
	call interactionIncState		; $706b
	ld l,Interaction.enabled		; $706e
	res 1,(hl)		; $7070
	ld b,SPEED_40		; $7072
	xor a			; $7074

@setSpeedAndAngle:
	ld l,Interaction.speed		; $7075
	ld (hl),b		; $7077

	; Calculate angle using subid (which has direction information)
	ld l,Interaction.subid		; $7078
	xor (hl)		; $707a
	swap a			; $707b
	ld l,Interaction.angle		; $707d
	ld (hl),a		; $707f
	ret			; $7080


; Lever retracting back to original position by itself.
@state3:
	call objectApplySpeed		; $7081

	; Update lever pull offset
	ld e,Interaction.yh		; $7084
	ld a,(de)		; $7086
	ld b,a			; $7087
	ld e,Interaction.var30		; $7088
	ld a,(de)		; $708a
	sub b			; $708b
	call @updatePullOffset		; $708c
	call @checkLeverFullyRetracted		; $708f
	jr c,@makeGrabbable	; $7092

	; Lever fully retracted.
	ld l,Interaction.state		; $7094
	ld (hl),$01		; $7096
	ld b,SPEED_40		; $7098
	ld a,$01		; $709a
	call @setSpeedAndAngle		; $709c

@makeGrabbable:
	; State 1 doesn't do anything except make the lever grabbable, so just reuse it.
	jp @state1		; $709f


; This part is almost entirely separate from the lever code above; this is a separate
; object that graphically connects the lever's base with the part Link is holding.
@updateLeverConnectionObject:
	ld a,(de)		; $70a2
	or a			; $70a3
	jr nz,@@state1	; $70a4

@@state0:
	call interactionInitGraphics		; $70a6
	call interactionIncState		; $70a9
	call objectSetVisible83		; $70ac

	; Copy parent's x position
	ld a,Object.xh		; $70af
	call objectGetRelatedObject1Var		; $70b1
	ld e,l			; $70b4
	ld a,(hl)		; $70b5
	ld (de),a		; $70b6

@@state1:
	; b = [relatedObj1.subid]*5 (either 0 or 5 as a base for the table below)
	ld a,Object.subid		; $70b7
	call objectGetRelatedObject1Var		; $70b9
	ld a,(hl)		; $70bc
	add a			; $70bd
	add a			; $70be
	add (hl)		; $70bf
	ld b,a			; $70c0

	; a = (number of pixels pulled)/16
	ld l,Interaction.yh		; $70c1
	ld a,(hl)		; $70c3
	ld l,Interaction.var30		; $70c4
	sub (hl)		; $70c6
	jr nc,+			; $70c7
	cpl			; $70c9
	inc a			; $70ca
+
	swap a			; $70cb
	and $07			; $70cd
	push af			; $70cf

	; Get Y offset for animation.
	add b			; $70d0
	ld bc,@animationYOffsets		; $70d1
	call addAToBc		; $70d4
	ld a,(bc)		; $70d7
	add (hl)		; $70d8
	ld e,Interaction.yh		; $70d9
	ld (de),a		; $70db

	; Set animation. Animation $02 is just a 16-pixel high lever connection, and
	; animations $03-$06 each add another 16-pixel high connection to the chain.
	pop af			; $70dc
	add $02			; $70dd
	jp interactionSetAnimation		; $70df

@animationYOffsets:
	.db $00 $08 $10 $18 $20 ; Lever facing down
	.db $00 $f8 $f0 $e8 $e0 ; Lever facing up

;;
; If the lever is fully extended, this also caps its position to the max value.
;
; @param[out]	cflag	nc if fully extended.
; @addr{70ec}
@checkLeverFullyExtended:
	ld e,Interaction.var31		; $70ec
	ld a,(de)		; $70ee
	ld h,d			; $70ef

	ld l,Interaction.subid		; $70f0
	bit 0,(hl)		; $70f2
	jr z,@posComparison			; $70f4

	cpl			; $70f6
	inc a			; $70f7

@negComparison:
	ld l,Interaction.var30		; $70f8
	add (hl)		; $70fa
	ld l,Interaction.yh		; $70fb
	cp (hl)			; $70fd
	ret c			; $70fe
	ld (hl),a		; $70ff
	ret			; $7100

;;
; If the lever is fully retracted, this also caps its position to 0.
;
; @param[out]	cflag	nc if fully retracted.
; @addr{7101}
@checkLeverFullyRetracted:
	xor a			; $7101
	ld h,d			; $7102
	ld l,Interaction.subid		; $7103
	bit 0,(hl)		; $7105
	jr z,@negComparison		; $7107

@posComparison:
	ld l,Interaction.var30		; $7109
	add (hl)		; $710b
	ld b,a			; $710c
	ld l,Interaction.yh		; $710d
	ld a,(hl)		; $710f
	cp b			; $7110
	ret c			; $7111
	ld (hl),b		; $7112
	ret			; $7113

;;
; @param	a	Offset of lever from its base (Value to write to
;			wLever1/2PullDistance before possible negation)
; @param	cflag	Set if lever is facing up
; @param[out]	a	Old value of pull distance
; @param[out]	b	New value of pull distance
; @addr{7114}
@updatePullOffset:
	jr nc,++		; $7114
	cpl			; $7116
	inc a			; $7117
++
	ld h,d			; $7118
	ld l,Interaction.var31		; $7119
	cp (hl)			; $711b
	jr nz,++		; $711c

	; Pulled lever all the way?
	ld h,a			; $711e
	push hl			; $711f
	ld a,SND_OPENCHEST		; $7120
	call playSound		; $7122

	; Set bit 7 of pull distance when fully pulled
	pop hl			; $7125
	ld a,h			; $7126
	or $80			; $7127
	ld h,d			; $7129
++
	; Read address in var32/var33; set new value to 'b' and return old value as 'a'.
	ld b,a			; $712a
	inc l			; $712b
	ldi a,(hl)		; $712c
	ld h,(hl)		; $712d
	ld l,a			; $712e
	ld a,(hl)		; $712f
	ld (hl),b		; $7130
	ret			; $7131


; ==============================================================================
; INTERACID_MAKU_CONFETTI
;
; This object uses component speed (instead of using one byte for speed value, two words
; are used, for Y/X speeds respectively).
;
; Variables:
;   var03:    If nonzero, this is an index for the confetti which determines position,
;             acceleration values? (If zero, this is the "spawner" for subsequent
;             confetti.)
;
; Variables for "spawner" / "parent" (var03 == 0, uses state 1):
;   counter1: Number of pieces of confetti spawned so far
;   var37:    Counter until next piece of confetti spawns
;
; Variables for actual pieces of confetti (var03 != 0, uses state 2):
;   var3a:    Counter until another sparkle is created
;   var3c/3d: Y acceleration?
;   var3e/3f: X acceleration?
; ==============================================================================
interactionCode62:
	ld e,Interaction.subid		; $7132
	ld a,(de)		; $7134
	rst_jumpTable			; $7135
	.dw _makuConfetti_subid0
	.dw _makuConfetti_subid1


; Subid 0: Flowers (in the present)
_makuConfetti_subid0:
	ld e,Interaction.state		; $713a
	ld a,(de)		; $713c
	rst_jumpTable			; $713d
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d			; $7144
	ld l,e			; $7145
	inc (hl)		; $7146
	ld l,Interaction.var03		; $7147
	ld a,(hl)		; $7149
	or a			; $714a
	jr nz,+			; $714b

	; var03 is zero; next state is state 1.
	jp @setDelayUntilNextConfettiSpawns		; $714d
+
	; a *= 3 (assume hl still points to a's source)
	add a			; $7150
	add (hl)		; $7151

	; Set Y-pos, X-pos, Y-accel (var3c), X-accel (var3e)
	ld hl,@initialPositionsAndAccelerations-6		; $7152
	rst_addDoubleIndex			; $7155
	ld e,Interaction.yh		; $7156
	ldh a,(<hCameraY)	; $7158
	add (hl)		; $715a
	inc hl			; $715b
	ld (de),a		; $715c
	inc e			; $715d
	inc e			; $715e
	ldh a,(<hCameraX)	; $715f
	add (hl)		; $7161
	inc hl			; $7162
	ld (de),a		; $7163
	ld e,Interaction.var3c		; $7164
	call @copyAccelerationComponent		; $7166
	call @copyAccelerationComponent		; $7169

	; Increment state again; next state is state 2.
	ld h,d			; $716c
	ld l,Interaction.state		; $716d
	inc (hl)		; $716f

	ld l,Interaction.var3a		; $7170
	ld (hl),$10		; $7172

	ld l,Interaction.direction		; $7174
	ld (hl),$00		; $7176
	call interactionInitGraphics		; $7178
	jp objectSetVisible80		; $717b


@copyAccelerationComponent:
	ldi a,(hl)		; $717e
	ld (de),a		; $717f
	inc e			; $7180
	ldi a,(hl)		; $7181
	ld (de),a		; $7182
	inc e			; $7183
	ret			; $7184


; Data format:
;   b0: Y position
;   b1: X position
;   w2: Y-acceleration (var3c)
;   w3: X-acceleration (var3e)
@initialPositionsAndAccelerations:
	dbbww $e8, $38, $0018, $0018 ; $01 == [var03]
	dbbww $e8, $60, $0018, $0018 ; $02
	dbbww $e8, $10, $0010, $0010 ; $03
	dbbww $e8, $50, $0014, $0014 ; $04
	dbbww $e8, $20, $0018, $0018 ; $05


; State 1: this is the "spawner" for confetti, not actually drawn itself.
@state1:
	ld h,d			; $71a3
	ld l,Interaction.var37		; $71a4
	dec (hl)		; $71a6
	ret nz			; $71a7
	ld (hl),$01		; $71a8

	; Spawn a piece of confetti
	call getFreeInteractionSlot		; $71aa
	ret nz			; $71ad
	ld (hl),INTERACID_MAKU_CONFETTI		; $71ae

	; [new.var03] = ++[this.counter1]
	ld e,Interaction.counter1		; $71b0
	ld a,(de)		; $71b2
	inc a			; $71b3
	ld (de),a		; $71b4
	ld l,Interaction.var03		; $71b5
	ld (hl),a		; $71b7

	; [new.counter2] = 180 (counter until it makes magic powder noise)
	ld l,Interaction.counter2		; $71b8
	ld (hl),180		; $71ba

	ld a,SND_MAGIC_POWDER		; $71bc
	call playSound		; $71be

	; Delete self if 5 pieces of confetti have been spawned
	ld e,Interaction.counter1		; $71c1
	ld a,(de)		; $71c3
	cp $05			; $71c4
	jp z,interactionDelete		; $71c6

@setDelayUntilNextConfettiSpawns:
	ld e,Interaction.counter1		; $71c9
	ld a,(de)		; $71cb
	ld hl,@spawnDelayValues		; $71cc
	rst_addAToHl			; $71cf
	ld a,(hl)		; $71d0
	ld e,Interaction.var37		; $71d1
	ld (de),a		; $71d3
	ret			; $71d4

@spawnDelayValues:
	.db $01 $32 $14 $1e $28 $1e


; State 2: This is an individual piece of confetti, falling down the screen.
@state2:
	; Play magic powder sound every 3 seconds
	call interactionDecCounter2		; $71db
	jr nz,++		; $71de
	ld (hl),180		; $71e0
	ld a,SND_MAGIC_POWDER		; $71e2
	call playSound		; $71e4
++
	; Make a sparkle every $18 frames
	ld h,d			; $71e7
	ld l,Interaction.var3a		; $71e8
	dec (hl)		; $71ea
	jr nz,++			; $71eb
	ld (hl),$18		; $71ed
	call @makeSparkle		; $71ef
++
	; Update Y/X position and speed
	ld hl,@yOffset		; $71f2
	ld e,Interaction.y		; $71f5
	call add16BitRefs		; $71f7
	call _makuConfetti_updateSpeedY		; $71fa
	call _makuConfetti_updateSpeedX		; $71fd
	call objectApplyComponentSpeed		; $7200

	; Delete when off-screen
	ld e,Interaction.yh		; $7203
	ld a,(de)		; $7205
	cp $88			; $7206
	jp c,++			; $7208
	cp $d8			; $720b
	jp c,interactionDelete		; $720d
++
	; Invert Y acceleration when speedY > $100.
	ld h,d			; $7210
	ld l,Interaction.speedY		; $7211
	ld c,(hl)		; $7213
	inc l			; $7214
	ld b,(hl)		; $7215
	bit 7,(hl)		; $7216
	jr z,+			; $7218
	call @negateBC		; $721a
+
	ld hl,$0100		; $721d
	call compareHlToBc		; $7220
	cp $01			; $7223
	jr z,+			; $7225
	ld e,Interaction.var3c		; $7227
	call @negateWordAtDE		; $7229
+
	; Invert X acceleration when speedX > $200.
	ld h,d			; $722c
	ld l,Interaction.speedX		; $722d
	ld c,(hl)		; $722f
	inc l			; $7230
	ld b,(hl)		; $7231
	bit 7,(hl)		; $7232
	jr z,+			; $7234
	call @negateBC		; $7236
+
	ld hl,$0200		; $7239
	call compareHlToBc		; $723c
	cp $01			; $723f
	jr z,+			; $7241
	ld e,Interaction.var3e		; $7243
	call @negateWordAtDE		; $7245
+
	; Check whether to invert the animation direction (speed switches from positive to
	; negative or vice-versa).
	ld h,d			; $7248
	ld l,Interaction.speedX+1		; $7249
	bit 7,(hl)		; $724b
	ld l,Interaction.direction		; $724d
	ld a,(hl)		; $724f
	jr z,+			; $7250
	or a			; $7252
	ret nz			; $7253
	jr ++			; $7254
+
	or a			; $7256
	ret z			; $7257
++
	xor $01			; $7258
	ld (hl),a		; $725a
	jp interactionSetAnimation		; $725b


; Value added to y position each frame, in addition to speedY?
@yOffset:
	.dw $00c0

;;
; @param	bc	Speed
; @param[out]	bc	Inverted speed
; @addr{7260}
@negateBC:
	xor a			; $7260
	ld a,c			; $7261
	cpl			; $7262
	add $01			; $7263
	ld c,a			; $7265
	ld a,b			; $7266
	cpl			; $7267
	adc $00			; $7268
	ld b,a			; $726a
	ret			; $726b

;;
; @param	de	Address of value to invert
; @addr{726c}
@negateWordAtDE:
	xor a			; $726c
	ld a,(de)		; $726d
	cpl			; $726e
	add $01			; $726f
	ld (de),a		; $7271
	inc e			; $7272
	ld a,(de)		; $7273
	cpl			; $7274
	adc $00			; $7275
	ld (de),a		; $7277
	ret			; $7278

@makeSparkle:
	call getFreeInteractionSlot		; $7279
	ret nz			; $727c
	ld (hl),INTERACID_SPARKLE		; $727d
	inc l			; $727f
	ld (hl),$02		; $7280
	jp objectCopyPosition		; $7282



; Subid 1: In the past.
_makuConfetti_subid1:
	ld e,Interaction.state		; $7285
	ld a,(de)		; $7287
	rst_jumpTable			; $7288
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d			; $728f
	ld l,e			; $7290
	inc (hl)		; $7291
	ld l,Interaction.var03		; $7292
	ld a,(hl)		; $7294
	or a			; $7295
	jr nz,+			; $7296

	; var03 is zero; next state is state 1.
	ld l,Interaction.counter2		; $7298
	ld (hl),$0a		; $729a
	jp @setDelayUntilNextConfettiSpawns		; $729c
+
	dec a			; $729f
	cp $06			; $72a0
	jr c,+			; $72a2
	sub $06			; $72a4
+
	ld hl,@initialPositions		; $72a6
	rst_addDoubleIndex			; $72a9

	; Set Y-pos, X-pos.
	ld e,Interaction.yh		; $72aa
	ldh a,(<hCameraY)	; $72ac
	add (hl)		; $72ae
	inc hl			; $72af
	ld (de),a		; $72b0
	inc e			; $72b1
	inc e			; $72b2
	ldh a,(<hCameraX)	; $72b3
	add (hl)		; $72b5
	inc hl			; $72b6
	ld (de),a		; $72b7

	; Initialize speedY, speedX
	ld h,d			; $72b8
	ld l,Interaction.speedY		; $72b9
	ld b,$80		; $72bb
	ld c,$fd		; $72bd
	call @setSpeedComponent		; $72bf
	ld b,$00		; $72c2
	ld c,$04		; $72c4
	call @setSpeedComponent		; $72c6

	; Initialize speedZ; this is actually used as X acceleration.
	ld b,$f0		; $72c9
	ld c,$ff		; $72cb
	call @setSpeedComponent		; $72cd

	; Increment state again; next state is state 2.
	ld l,Interaction.state		; $72d0
	inc (hl)		; $72d2

	call interactionInitGraphics		; $72d3
	jp objectSetVisible80		; $72d6

@setSpeedComponent:
	ld (hl),b		; $72d9
	inc l			; $72da
	ld (hl),c		; $72db
	inc l			; $72dc
	ret			; $72dd

; Data format:
;   b0: Y position
;   b1: X position
@initialPositions:
	.db $80 $10 ; $01,$07 == [var03]
	.db $60 $00 ; $02,$08
	.db $80 $18 ; $03,$09
	.db $80 $48 ; $04,$0a
	.db $50 $00 ; $05,$0b
	.db $80 $10 ; $06,$0c


; State 1: this is the "spawner" for confetti, not actually drawn itself.
@state1:
	call interactionDecCounter2		; $72ea
	jr nz,+			; $72ed
	ld (hl),45		; $72ef
	ld a,SND_MAKU_TREE_PAST		; $72f1
	call playSound		; $72f3
+
	ld h,d			; $72f6
	ld l,Interaction.var37		; $72f7
	dec (hl)		; $72f9
	ret nz			; $72fa

	call getFreeInteractionSlot		; $72fb
	ret nz			; $72fe
	ld (hl),INTERACID_MAKU_CONFETTI		; $72ff
	inc l			; $7301
	ld (hl),$01 ; [new.subid] = $02

	; [new.var03] = ++[this.counter1]
	ld e,Interaction.counter1		; $7304
	ld a,(de)		; $7306
	inc a			; $7307
	ld (de),a		; $7308
	ld l,Interaction.var03		; $7309
	ld (hl),a		; $730b

	; Delete self if 12 pieces of confetti have been spawned
	cp 12			; $730c
	jp z,interactionDelete		; $730e

@setDelayUntilNextConfettiSpawns:
	ld e,Interaction.counter1		; $7311
	ld a,(de)		; $7313
	ld hl,@spawnDelayValues		; $7314
	rst_addAToHl			; $7317
	ld a,(hl)		; $7318
	ld e,Interaction.var37		; $7319
	ld (de),a		; $731b
	ret			; $731c

@spawnDelayValues:
	.db $01 $32 $1e $0f $0f $0f $0f $0f
	.db $0f $0f $0f $14


; State 2: This is an individual piece of confetti, falling down the screen.
@state2:
	call _makuConfetti_updateSpeedXUsingSpeedZ		; $7329
	ld e,Interaction.speedX+1		; $732c
	ld a,(de)		; $732e
	bit 7,a			; $732f
	jp nz,interactionDelete		; $7331
	jp objectApplyComponentSpeed		; $7334

_makuConfetti_updateSpeedY:
	ld e,Interaction.speedY		; $7337
	ld l,Interaction.var3c		; $7339
	jr _makuConfetti_add16BitRefs			; $733b

_makuConfetti_updateSpeedX:
	ld e,Interaction.speedX		; $733d
	ld l,Interaction.var3e		; $733f
	jr _makuConfetti_add16BitRefs			; $7341

_makuConfetti_updateSpeedYUsingSpeedZ: ; Unused
	ld e,Interaction.speedY		; $7343
	ld l,Interaction.speedZ		; $7345
	jr _makuConfetti_add16BitRefs			; $7347

; Use speedZ as acceleration for speedX (since speedZ isn't used for anything else)
_makuConfetti_updateSpeedXUsingSpeedZ:
	ld e,Interaction.speedX		; $7349
	ld l,Interaction.speedZ		; $734b

_makuConfetti_add16BitRefs
	ld h,d			; $734d
	call add16BitRefs		; $734e
	ret			; $7351


; ==============================================================================
; INTERACID_ACCESSORY
; ==============================================================================
interactionCode63:
	ld e,Interaction.state		; $7352
	ld a,(de)		; $7354
	rst_jumpTable			; $7355
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $735a
	ld (de),a		; $735c
	call interactionInitGraphics		; $735d

@state1:
	ld a,Object.enabled		; $7360
	call objectGetRelatedObject1Var		; $7362
	ld l,Interaction.enabled		; $7365
	ld a,(hl)		; $7367
	or a			; $7368
	jr z,@delete	; $7369

	ld l,Interaction.var3b		; $736b
	ld a,(hl)		; $736d
	or a			; $736e
	jr nz,@delete	; $736f

	ld l,Interaction.visible		; $7371
	bit 7,(hl)		; $7373
	jp z,objectSetInvisible		; $7375

	call objectSetVisible80		; $7378
	ld bc,$f400		; $737b
	ld e,Interaction.var03		; $737e
	ld a,(de)		; $7380
	or a			; $7381
	jr z,@takePositionWithOffset	; $7382

	ld l,Interaction.animParameter		; $7384
	ld a,(hl)		; $7386
	push hl			; $7387
	add a			; $7388
	ld hl,@data		; $7389
	rst_addDoubleIndex			; $738c
	ld b,(hl)		; $738d
	inc hl			; $738e
	ld c,(hl)		; $738f
	inc hl			; $7390
	ld a,(hl)		; $7391
	ld e,Interaction.visible		; $7392
	ld (de),a		; $7394
	inc hl			; $7395

	; Set animation if it's changed
	ld e,Interaction.var3c		; $7396
	ld a,(de)		; $7398
	cp (hl)			; $7399
	jr z,++			; $739a
	ld a,(hl)		; $739c
	ld (de),a		; $739d
	push bc			; $739e
	call interactionSetAnimation		; $739f
	pop bc			; $73a2
++
	pop hl			; $73a3

@takePositionWithOffset:
	jp objectTakePositionWithOffset		; $73a4

@delete:
	jp interactionDelete		; $73a7


; Each row in this table is a set of values for one value of "relatedObj1.animParameter".
; This is only used when var03 is nonzero.
;
; Data format:
;   b0: Y offset
;   b1: X offset
;   b2: value for Interaction.visible
;   b3: Animation index
@data:
	.db $00 $f3 $80 $03
	.db $f3 $00 $80 $03
	.db $00 $0d $80 $03
	.db $f4 $ff $80 $03
	.db $f4 $00 $80 $03
	.db $f5 $00 $83 $03
	.db $f5 $00 $83 $0a
	.db $02 $04 $80 $00
	.db $02 $05 $80 $00


; ==============================================================================
; INTERACID_RAFTWRECK_CUTSCENE_HELPER
; ==============================================================================
interactionCode64:
	ld e,Interaction.state		; $73ce
	ld a,(de)		; $73d0
	rst_jumpTable			; $73d1
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState		; $73d6
	ld e,Interaction.subid		; $73d9
	ld a,(de)		; $73db
	rst_jumpTable			; $73dc
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05

@initSubid00:
@initSubid01:
@initSubid02:
	call interactionInitGraphics		; $73e9
	call objectSetVisible82		; $73ec

@loadAngleAndCounterPreset:
	ld b,$03		; $73ef
	callab interactionBank0a.loadAngleAndCounterPreset		; $73f1
	ld a,b			; $73f9
	or a			; $73fa
	ret			; $73fb

@initSubid03:
@initSubid04:
@initSubid05:
	ret			; $73fc

;;
; Reads from a table, gets a position, sets counter1, ...?
;
; @param	counter2	Index from table to read
; @param	hl		Table to read from
; @param[out]	bc		Position for a new object?
; @param[out]	e		Subid for a new object?
@func_73fd:
	ld e,Interaction.counter2		; $73fd
	ld a,(de)		; $73ff
	add a			; $7400
	rst_addDoubleIndex			; $7401
	ld b,(hl)		; $7402
	inc hl			; $7403
	ld c,(hl)		; $7404
	inc hl			; $7405
	ld e,(hl)		; $7406
	inc hl			; $7407
	ld a,(hl)		; $7408
	ld h,d			; $7409
	ld l,Interaction.counter1		; $740a
	ld (hl),a		; $740c
	ret			; $740d

@state1:
	ld e,Interaction.subid		; $740e
	ld a,(de)		; $7410
	rst_jumpTable			; $7411
	.dw @runSubid00
	.dw @runSubid01
	.dw @runSubid02
	.dw @runSubid03
	.dw @runSubid04
	.dw @runSubid05

@runSubid00:
@runSubid01:
@runSubid02:
	call interactionAnimate		; $741e
	call objectApplySpeed		; $7421
	cp $f0			; $7424
	jp nc,interactionDelete		; $7426
	call interactionDecCounter1		; $7429
	call z,@loadAngleAndCounterPreset		; $742c
	jp z,interactionDelete		; $742f
	ret			; $7432

@runSubid03:
@runSubid04:
	ld h,d			; $7433
	ld l,Interaction.counter1		; $7434
	ld a,(hl)		; $7436
	or a			; $7437
	jr z,+			; $7438
	dec (hl)		; $743a
	ret			; $743b
+
	ld hl,@subid3Objects		; $743c
	ld e,Interaction.subid		; $743f
	ld a,(de)		; $7441
	cp $03			; $7442
	jr z,+			; $7444
	ld hl,@subid4Objects		; $7446
+
	call @func_73fd		; $7449

	call getFreeInteractionSlot		; $744c
	ret nz			; $744f
	ld (hl),INTERACID_RAFTWRECK_CUTSCENE_HELPER		; $7450
	inc l			; $7452
	ld (hl),e		; $7453
	inc l			; $7454
	ld e,Interaction.counter2		; $7455
	ld a,(de)		; $7457
	ld (hl),a		; $7458
	ld e,Interaction.subid		; $7459
	ld a,(de)		; $745b
	cp $03			; $745c
	ld a,SPEED_200		; $745e
	jr z,+			; $7460
	ld a,SPEED_300		; $7462
+
	ld l,Interaction.speed		; $7464
	ld (hl),a		; $7466
	call interactionHSetPosition		; $7467

	ld h,d			; $746a
	ld l,Interaction.counter1		; $746b
	ld a,(hl)		; $746d
	or a			; $746e
	jp z,interactionDelete		; $746f
	inc l			; $7472
	inc (hl)		; $7473
	ret			; $7474


; Tables of objects to spawn for the "wind" parts of the cutscene.
;   b0: Y position
;   b1: X position
;   b2: subID of this interaction type to spawn
;   b3: counter1
@subid3Objects:
	.db $00 $b8 $00 $14
	.db $10 $a8 $00 $14
	.db $40 $a8 $00 $14
	.db $48 $b8 $01 $14
	.db $20 $a8 $00 $00

@subid4Objects:
	.db $20 $b8 $00 $10
	.db $40 $a8 $00 $14
	.db $10 $b0 $01 $10
	.db $48 $b8 $00 $14
	.db $08 $b0 $01 $10
	.db $50 $a8 $00 $14
	.db $f0 $b0 $00 $10
	.db $08 $b8 $02 $10
	.db $48 $b8 $00 $14
	.db $08 $b0 $01 $10
	.db $50 $a8 $00 $14
	.db $18 $b0 $01 $10
	.db $38 $b8 $02 $10
	.db $58 $a8 $00 $14
	.db $28 $b0 $01 $10
	.db $00 $a8 $00 $00

@runSubid05:
	ld h,d			; $74c9
	ld l,Interaction.counter1		; $74ca
	ld a,(hl)		; $74cc
	or a			; $74cd
	jr z,+			; $74ce
	dec (hl)		; $74d0
	ret			; $74d1
+
	ld hl,@subid5Objects		; $74d2
	call @func_73fd		; $74d5

	; Create lightning
	call getFreePartSlot		; $74d8
	ret nz			; $74db
	ld (hl),PARTID_LIGHTNING		; $74dc
	inc l			; $74de
	ld (hl),e		; $74df
	inc l			; $74e0
	inc (hl)		; $74e1
	ld l,Part.yh		; $74e2
	ld (hl),b		; $74e4
	ld l,Part.xh		; $74e5
	ld (hl),c		; $74e7

	ld h,d			; $74e8
	ld l,Interaction.counter1		; $74e9
	ld a,(hl)		; $74eb
	or a			; $74ec
	jr z,+			; $74ed
	inc l			; $74ef
	inc (hl)		; $74f0
	ret			; $74f1
+
	; Signal to INTERACID_RAFTWRECK_CUTSCENE that the cutscene is done
	ld a,$03		; $74f2
	ld (wTmpcfc0.genericCutscene.state),a		; $74f4
	jp interactionDelete		; $74f7


; Tables of lightning objects to spawn in the final part of the cutscene.
;   b0: Y position
;   b1: X position
;   b2: subID of this interaction type to spawn
;   b3: counter1
@subid5Objects:
	.db $28 $28 $01 $28
	.db $58 $38 $01 $5a
	.db $40 $50 $01 $00


; ==============================================================================
; INTERACID_COMEDIAN
;
; Variables: (these are only used in scripts / bank 15 functions))
;   var37: base animation index ($00 for no mustache, $04 for mustache)
;   var3e: animation index (to be added to var37)
; ==============================================================================
interactionCode65:
	call checkInteractionState		; $7506
	jr nz,@state1	; $7509

@state0:
	call @loadScriptAndInitGraphics		; $750b
	call interactionRunScript		; $750e
	call interactionRunScript		; $7511
	jp interactionAnimateAsNpc		; $7514

@state1:
	call interactionRunScript		; $7517
	jp c,interactionDelete		; $751a
	callab scriptHlp.comedian_turnToFaceLink		; $751d
	jp interactionAnimateAsNpc		; $7525


@unusedFunc_7528:
	call interactionInitGraphics		; $7528
	call objectMarkSolidPosition		; $752b
	jp interactionIncState		; $752e


@loadScriptAndInitGraphics:
	call interactionInitGraphics		; $7531
	call objectMarkSolidPosition		; $7534
	ld a,>TX_0b00		; $7537
	call interactionSetHighTextIndex		; $7539
	ld e,Interaction.subid		; $753c
	ld a,(de)		; $753e
	ld hl,@scriptTable		; $753f
	rst_addDoubleIndex			; $7542
	ldi a,(hl)		; $7543
	ld h,(hl)		; $7544
	ld l,a			; $7545
	call interactionSetScript		; $7546
	jp interactionIncState		; $7549

@scriptTable:
	.dw comedianScript


; ==============================================================================
; INTERACID_GORON
;
; Variables:
;   var3f: Nonzero when "napping" (link is far away)
; ==============================================================================
interactionCode66:
	ld e,Interaction.subid		; $754e
	ld a,(de)		; $7550
	rst_jumpTable			; $7551
	.dw _goronSubid00
	.dw _goronSubid01
	.dw _goronSubid02
	.dw _goronSubid03
	.dw _goronSubid04
	.dw _goronSubid05
	.dw _goronSubid06
	.dw _goronSubid07
	.dw _goronSubid08
	.dw _goronSubid09
	.dw _goronSubid0a
	.dw _goronSubid0b
	.dw _goronSubid0c
	.dw _goronSubid0d
	.dw _goronSubid0e
	.dw _goronSubid0f
	.dw _goronSubid10


; Graceful goron
_goronSubid00:
	ld e,Interaction.state		; $7574
	ld a,(de)		; $7576
	rst_jumpTable			; $7577
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4


; State 0: Initialization
@state0:
	call _goron_initGraphicsAndIncState		; $7582

	; Set palette (red/blue for past/present)
	ld a,(wTilesetFlags)		; $7585
	and TILESETFLAG_PAST			; $7588
	ld a,$01		; $758a
	jr z,+			; $758c
	ld a,$02		; $758e
+
	ld e,Interaction.oamFlags		; $7590
	ld (de),a		; $7592

	; Load goron or subrosian dancers
	ld hl,objectData.goronDancers		; $7593
	call checkIsLinkedGame		; $7596
	jr z,@loadDancers	; $7599
	ld a,(wTilesetFlags)		; $759b
	and TILESETFLAG_PAST			; $759e
	jr z,@loadDancers	; $75a0
	ld hl,objectData.subrosianDancers		; $75a2
@loadDancers:
	call parseGivenObjectData		; $75a5

	ld b,wTmpcfc0.goronDance.dataEnd - wTmpcfc0.goronDance		; $75a8
	ld hl,wTmpcfc0.goronDance		; $75aa
	call clearMemory		; $75ad

	ld a,$02		; $75b0
	ld (wTmpcfc0.goronDance.danceAnimation),a		; $75b2

	xor a			; $75b5
	ld hl,goronDanceScriptTable		; $75b6
	rst_addDoubleIndex			; $75b9
	ldi a,(hl)		; $75ba
	ld h,(hl)		; $75bb
	ld l,a			; $75bc
	call interactionSetScript		; $75bd


; State 1: waiting for script to end as a signal to start the dance minigame
@state1:
	call interactionRunScript		; $75c0
	jp c,@scriptDone		; $75c3
	jp npcFaceLinkAndAnimate		; $75c6

@scriptDone:
	; Dance begins when script ends
	ld b,$0a		; $75c9
	callab interactionBank08.shootingGallery_initializeGameRounds		; $75cb

	ld a,DIR_DOWN		; $75d3
	ld (wTmpcfc0.goronDance.danceAnimation),a		; $75d5
	call interactionIncState		; $75d8
	ld l,Interaction.counter1		; $75db
	ld (hl),30		; $75dd


; State 2: demonstrating dance sequence
@state2:
	ld e,Interaction.state2		; $75df
	ld a,(de)		; $75e1
	rst_jumpTable			; $75e2
	.dw @state2Substate0
	.dw @state2Substate1
	.dw @state2Substate2
	.dw @state2Substate3
	.dw @state2Substate4

; Waiting to begin round
@state2Substate0:
	call interactionDecCounter1		; $75ed
	jp nz,@pushLinkAway		; $75f0

	call interactionIncState2		; $75f3
	ld l,Interaction.counter1		; $75f6
	ld (hl),90		; $75f8
	ld a,SND_WHISTLE		; $75fa
	call playSound		; $75fc
	call _goronDance_initNextRound		; $75ff

@state2Substate1:
	call interactionDecCounter1		; $7602
	jp nz,@pushLinkAway		; $7605
	call interactionIncState2		; $7608
	jr @nextMove		; $760b


; Waiting until doing the next "beat" of the dance
@state2Substate2:
	call interactionDecCounter1		; $760d
	jr nz,@pushLinkAway	; $7610

	call _goronDance_incBeat		; $7612
@nextMove:
	call _goronDance_getNextMove		; $7615
	jr nz,@finishedDemonstration	; $7618

	call _goronDance_updateConsecutiveBPressCounter		; $761a
	call _goronDance_updateGracefulGoronAnimation		; $761d
	jr z,@jump	; $7620

	call _goronDance_playMoveSound		; $7622
	ld h,d			; $7625
	ld l,Interaction.counter1		; $7626
	ld (hl),20		; $7628

@pushLinkAway:
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $762a

@jump:
	; Jump after 5 consecutive B presses
	ld h,d			; $762d
	ld l,Interaction.state2		; $762e
	ld (hl),$03		; $7630

	ld l,Interaction.speed		; $7632
	ld (hl),SPEED_100		; $7634
	ld l,Interaction.speedZ		; $7636
	ld (hl),<(-$200)		; $7638
	inc hl			; $763a
	ld (hl),>(-$200)		; $763b

	ld l,Interaction.counter1		; $763d
	ld (hl),20		; $763f
	ld a,SND_GORON_DANCE_B		; $7641
	call playSound		; $7643
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $7646


@finishedDemonstration:
	ld h,d			; $7649
	ld l,Interaction.state2		; $764a
	ld (hl),$04		; $764c
	ld l,Interaction.counter1		; $764e
	ld (hl),60		; $7650
	ld a,DIR_DOWN		; $7652
	call interactionSetAnimation		; $7654
	jr @pushLinkAway		; $7657


; Waiting to land if he jumped
@state2Substate3:
	call interactionDecCounter1		; $7659
	ld c,$40		; $765c
	call objectUpdateSpeedZ_paramC		; $765e
	jr z,@@landed	; $7661

	ld h,d			; $7663
	ld l,Interaction.speedZ+1		; $7664
	ldd a,(hl)		; $7666
	or (hl)			; $7667
	jr nz,@pushLinkAway	; $7668

	ld a,DIR_DOWN		; $766a
	ld (wTmpcfc0.goronDance.danceAnimation),a		; $766c
	call interactionSetAnimation		; $766f
	jr @pushLinkAway		; $7672

@@landed:
	ld h,d			; $7674
	ld l,Interaction.state2		; $7675
	ld (hl),$02		; $7677
	jp @state2Substate2		; $7679


; Counting down until going to state 3 (where Link replicates the dance)
@state2Substate4:
	call interactionDecCounter1		; $767c
	jr nz,@pushLinkAway	; $767f
	call interactionIncState		; $7681
	ld l,Interaction.state2		; $7684
	ld (hl),$00		; $7686
	jr @pushLinkAway		; $7688


; State 3: Link playing back dance sequence
@state3:
	ld e,Interaction.state2		; $768a
	ld a,(de)		; $768c
	rst_jumpTable			; $768d
	.dw @state3Substate0
	.dw @state3Substate1
	.dw @state3Substate2
	.dw @state3Substate3
	.dw @state3Substate4

@state3Substate0:
	call interactionIncState2		; $7698
	call _goronDance_clearDanceVariables		; $769b
	ld a,SND_WHISTLE		; $769e
	call playSound		; $76a0

	ld a,DIR_DOWN		; $76a3
	ld (wTmpcfc0.goronDance.danceAnimation),a		; $76a5

	call _goronDance_turnLinkToDirection		; $76a8
	jp @pushLinkAway		; $76ab

@state3Substate1:
	call _goronDance_updateFrameCounter		; $76ae
	call _goronDance_checkLinkInput		; $76b1
	jp @pushLinkAway		; $76b4

@state3Substate2:
	call _goronDance_updateFrameCounter		; $76b7
	ld a,(wTmpcfc0.goronDance.linkJumping)		; $76ba
	or a			; $76bd
	jp nz,@pushLinkAway		; $76be

	ld h,d			; $76c1
	ld l,Interaction.state2		; $76c2
	dec (hl)		; $76c4
	jp @pushLinkAway		; $76c5

@state3Substate3:
	call interactionDecCounter1		; $76c8
	jp nz,@pushLinkAway		; $76cb
	ld a,(wTmpcfc0.goronDance.roundIndex)		; $76ce
	cp $08			; $76d1
	jr z,@endDanceAndUpdateNpc	; $76d3

@nextRoundAndUpdateNpc:
	call @nextRound		; $76d5
	jp @pushLinkAway		; $76d8

@endDanceAndUpdateNpc:
	call @endDance		; $76db
	jp @pushLinkAway		; $76de


; Messed up?
@state3Substate4:
	ld e,Interaction.var3f		; $76e1
	ld a,(de)		; $76e3
	rst_jumpTable			; $76e4
	.dw @@initializeScript
	.dw @@runScript

@@initializeScript:
	call interactionDecCounter1		; $76e9
	jp nz,@pushLinkAway		; $76ec
	ld a,$01		; $76ef
	ld (wTmpcfc0.goronDance.cfd9),a		; $76f1
	ld hl,wTmpcfc0.goronDance.roundIndex		; $76f4
	inc (hl)		; $76f7
	ld hl,wTmpcfc0.goronDance.numFailedRounds		; $76f8
	inc (hl)		; $76fb
	ld a,(hl)		; $76fc
	cp $03			; $76fd
	jr z,++			; $76ff

	ld a,(wTmpcfc0.goronDance.roundIndex)		; $7701
	cp $08			; $7704
	jr z,@endDanceAndUpdateNpc	; $7706
++
	ld h,d			; $7708
	ld l,Interaction.var3f		; $7709
	inc (hl)		; $770b
	ld a,$01		; $770c
	ld hl,goronDanceScriptTable		; $770e
	rst_addDoubleIndex			; $7711
	ldi a,(hl)		; $7712
	ld h,(hl)		; $7713
	ld l,a			; $7714
	call interactionSetScript		; $7715

@@runScript:
	call interactionRunScript		; $7718
	jp nc,@pushLinkAway		; $771b
	jp @nextRoundAndUpdateNpc		; $771e

@nextRound:
	; Go to state 2 (begin next round)
	ld h,d			; $7721
	ld l,Interaction.state		; $7722
	ld (hl),$02		; $7724
	inc l			; $7726
	ld (hl),$00		; $7727
	ld l,Interaction.counter1		; $7729
	ld (hl),30		; $772b
	jr @resetDanceAnimationToDown		; $772d

@endDance:
	; Go to state 4 (finished the whole minigame)
	ld h,d			; $772f
	ld l,Interaction.state		; $7730
	ld (hl),$04		; $7732
	inc l			; $7734
	ld (hl),$00		; $7735
	ld l,Interaction.counter1		; $7737
	ld (hl),60		; $7739

@resetDanceAnimationToDown:
	xor a			; $773b
	ld (wTmpcfc0.goronDance.linkStartedDance),a		; $773c
	ld a,DIR_DOWN		; $773f
	ld (wTmpcfc0.goronDance.danceAnimation),a		; $7741
	jp _goronDance_turnLinkToDirection		; $7744


; State 4: dance ended successfully
@state4:
	ld e,Interaction.state2		; $7747
	ld a,(de)		; $7749
	rst_jumpTable			; $774a
	.dw @state4Substate0
	.dw @state4Substate1

@state4Substate0:
	call interactionIncState2		; $774f
	xor a			; $7752
	ld (wTmpcfc0.goronDance.linkStartedDance),a		; $7753

	; Run script to give prize
	ld a,$02		; $7756
	ld hl,goronDanceScriptTable		; $7758
	rst_addDoubleIndex			; $775b
	ldi a,(hl)		; $775c
	ld h,(hl)		; $775d
	ld l,a			; $775e
	call interactionSetScript		; $775f

@state4Substate1:
	call interactionRunScript		; $7762
	jp nc,@pushLinkAway		; $7765
	jp @pushLinkAway		; $7768



; Goron support dancer. Code also used by subrosian subid $01?
_goronSubid01:
	ld e,Interaction.state		; $776b
	ld a,(de)		; $776d
	rst_jumpTable			; $776e
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics		; $7775
	call _goron_loadScript		; $7778

@faceDown:
	ld a,DIR_DOWN		; $777b
	call interactionSetAnimation		; $777d


; State 1: just running the script
@state1:
	ld a,(wTmpcfc0.goronDance.linkStartedDance)		; $7780
	or a			; $7783
	jr nz,@gotoState2	; $7784
	call interactionRunScript		; $7786
	jp c,interactionDelete		; $7789
	jp npcFaceLinkAndAnimate		; $778c

@gotoState2:
	call interactionIncState		; $778f
	jr @updateAnimation		; $7792


; State 2: doing whatever animation the dance dictates
@state2:
	ld a,(wTmpcfc0.goronDance.linkStartedDance)		; $7794
	or a			; $7797
	jr z,@gotoState1	; $7798

@updateAnimation:
	; Copy Link's z position (for when he jumps)
	ld hl,w1Link.z		; $779a
	ld e,Interaction.z		; $779d
	ldi a,(hl)		; $779f
	ld (de),a		; $77a0
	inc e			; $77a1
	ld a,(hl)		; $77a2
	ld (de),a		; $77a3

	; Set animation based on whatever Link or the graceful goron is doing
	ld a,(wTmpcfc0.goronDance.danceAnimation)		; $77a4
	call interactionSetAnimation		; $77a7
	jp _goronSubid00@pushLinkAway		; $77aa

@gotoState1:
	ld h,d			; $77ad
	ld l,Interaction.state		; $77ae
	ld (hl),$01		; $77b0
	jp @faceDown		; $77b2


; A "fake" goron object that manages jumping in the dancing minigame?
_goronSubid02:
	call checkInteractionState		; $77b5
	jr nz,@state1	; $77b8

@state0:
	call objectSetInvisible		; $77ba
	call interactionIncState		; $77bd
	ld l,Interaction.speed		; $77c0
	ld (hl),SPEED_100		; $77c2
	ld l,Interaction.speedZ		; $77c4
	ld (hl),<(-$200)		; $77c6
	inc hl			; $77c8
	ld (hl),>(-$200)		; $77c9

	ld l,Interaction.counter1		; $77cb
	ld (hl),20		; $77cd

	ld hl,w1Link.yh		; $77cf
	call objectTakePosition		; $77d2

	ld a,DIR_UP		; $77d5
	ld (wTmpcfc0.goronDance.danceAnimation),a		; $77d7
	call _goronDance_turnLinkToDirection		; $77da

	ld a,SND_GORON_DANCE_B		; $77dd
	call playSound		; $77df

@state1:
	ld c,$40		; $77e2
	call objectUpdateSpeedZ_paramC		; $77e4
	jr z,@landed	; $77e7

	ld hl,w1Link.yh		; $77e9
	call objectCopyPosition		; $77ec
	ld h,d			; $77ef
	ld l,Interaction.speedZ+1		; $77f0
	ldd a,(hl)		; $77f2
	or (hl)			; $77f3
	ret nz			; $77f4

	ld a,DIR_DOWN		; $77f5
	jp _goronDance_turnLinkToDirection		; $77f7

@landed:
	ld hl,w1Link.yh		; $77fa
	call objectCopyPosition		; $77fd
	xor a			; $7800
	ld (wTmpcfc0.goronDance.linkJumping),a		; $7801
	jp interactionDelete		; $7804


; Subid $03: Cutscene where goron appears after beating d5; the guy who digs a new tunnel.
; Subid $04: Goron pacing back and forth, worried about elder.
_goronSubid03:
_goronSubid04:
	call checkInteractionState		; $7807
	jr nz,@state1	; $780a

@state0:
	call _goron_loadScriptAndInitGraphics		; $780c
	call interactionRunScript		; $780f
@state1:
	call interactionRunScript		; $7812
	jp c,interactionDelete		; $7815
	jp interactionAnimateAsNpc		; $7818


; An NPC in the past cave near the elder? var03 ranges from 0-5.
_goronSubid05:
	call checkInteractionState		; $781b
	jr nz,@state1	; $781e

@state0:
	call _goron_loadScriptFromTableAndInitGraphics		; $7820
	call interactionRunScript		; $7823
@state1:
	jr _goron_runScriptAndDeleteWhenFinished		; $7826


; NPC trying to break the elder out of the rock.
_goronSubid06:
	call checkInteractionState		; $7828
	jr nz,@state1	; $782b

@state0:
	call _goron_loadScriptFromTableAndInitGraphics		; $782d
	ld l,Interaction.var3e		; $7830
	ld (hl),$0a		; $7832
	ld e,Interaction.var03		; $7834
	ld a,(de)		; $7836
	or a			; $7837
	jr nz,+			; $7838
	ld (wTmpcfc0.goronCutscenes.elderVar_cfdd),a		; $783a
	jr ++		; $783d
+
	ld b,wTmpcfc0.goronCutscenes.dataEnd - wTmpcfc0.goronCutscenes		; $783f
	ld hl,wTmpcfc0.bigBangGame		; $7841
	call clearMemory		; $7844
++
	call interactionRunScript		; $7847
@state1:
	jr _goron_runScriptAndDeleteWhenFinished		; $784a


; Various NPCs...
_goronSubid07:
_goronSubid08:
_goronSubid0a:
_goronSubid0c:
_goronSubid0d:
_goronSubid0e:
_goronSubid10:
	call checkInteractionState		; $784c
	jr nz,_goron_runScriptAndDeleteWhenFinished	; $784f

	; State 0 (Initialize)
	call _goron_loadScriptAndInitGraphics		; $7851
	call interactionRunScript		; $7854

_goron_runScriptAndDeleteWhenFinished:
	call interactionRunScript		; $7857
	jp c,interactionDelete		; $785a

_goron_faceLinkAndAnimateIfNotNapping:
	ld e,Interaction.var3f		; $785d
	ld a,(de)		; $785f
	or a			; $7860
	jp z,npcFaceLinkAndAnimate		; $7861
	jp interactionAnimateAsNpc		; $7864


; Target carts gorons; var03 = 0 or 1 for gorons on left and right.
_goronSubid09:
	call checkInteractionState		; $7867
	jr nz,@state1	; $786a

@state0:
	ld e,Interaction.var03		; $786c
	ld a,(de)		; $786e
	or a			; $786f
	jr nz,@rightGuy	; $7870

@leftGuy:
	call _goron_loadScriptFromTableAndInitGraphics		; $7872
	xor a			; $7875
	ld (wTmpcfc0.targetCarts.cfdf),a		; $7876
	ld (wTmpcfc0.targetCarts.beginGameTrigger),a		; $7879

	; Reload crystals in first room if the game is in progress
	call getThisRoomFlags		; $787c
	bit 7,(hl)		; $787f
	jr z,++			; $7881
	callab scriptHlp.goron_targetCarts_reloadCrystalsInFirstRoom		; $7883
++
	call interactionRunScript		; $788b
	jr @state1		; $788e

@rightGuy:
	call _goron_loadScriptFromTableAndInitGraphics		; $7890
	call interactionRunScript		; $7893
	jr @state1		; $7896

@state1:
	jr _goron_runScriptAndDeleteWhenFinished		; $7898


; Goron running the big bang game
_goronSubid0b:
	call checkInteractionState		; $789a
	jr nz,@state1	; $789d

@state0:
	call _goron_loadScriptFromTableAndInitGraphics		; $789f
	call interactionRunScript		; $78a2
@state1:
	call interactionRunScript		; $78a5
	jp c,interactionDelete		; $78a8
	ld e,Interaction.var3e		; $78ab
	ld a,(de)		; $78ad
	or a			; $78ae
	ret nz			; $78af
	jr _goron_faceLinkAndAnimateIfNotNapping		; $78b0


; Linked NPC telling you the biggoron secret.
_goronSubid0f:
	call checkInteractionState		; $78b2
	jr nz,@state1	; $78b5

@state0:
	call _goron_initGraphicsAndIncState		; $78b7
	ld l,Interaction.var3f		; $78ba
	ld (hl),$08		; $78bc
	ld hl,linkedGameNpcScript		; $78be
	call interactionSetScript		; $78c1
	call interactionRunScript		; $78c4
@state1:
	call interactionRunScript		; $78c7
	jp c,interactionDelete		; $78ca
	jp npcFaceLinkAndAnimate		; $78cd

;;
; @addr{78d0}
_goronDance_updateFrameCounter:
	ld a,(wTmpcfc0.goronDance.linkStartedDance)		; $78d0
	or a			; $78d3
	ret z			; $78d4
	ld hl,wTmpcfc0.goronDance.frameCounter		; $78d5
	jp incHlRef16WithCap		; $78d8

;;
; @addr{78db}
_goronDance_initNextRound:
	ld a,(wTmpcfc0.goronDance.remainingRounds)		; $78db
	or a			; $78de
	jr z,_goronDance_clearDanceVariables			; $78df
	callab interactionBank08.shootingGallery_getNextTargetLayout		; $78e1

;;
; @addr{78e9}
_goronDance_clearDanceVariables:
	xor a			; $78e9
	ld (wTmpcfc0.goronDance.linkJumping),a		; $78ea
	ld (wTmpcfc0.goronDance.linkStartedDance),a		; $78ed
	ld (wTmpcfc0.goronDance.frameCounter),a		; $78f0
	ld (wTmpcfc0.goronDance.frameCounter+1),a		; $78f3
	ld (wTmpcfc0.goronDance.currentMove),a		; $78f6
	ld (wTmpcfc0.goronDance.consecutiveBPressCounter),a		; $78f9
	ld (wTmpcfc0.goronDance.cfd9),a		; $78fc
	ld (wTmpcfc0.goronDance.beat),a		; $78ff
	ret			; $7902

;;
; Waits for input from Link, checks for round failure conditions, updates link and goron
; animations when input is good, etc.
; @addr{7903}
_goronDance_checkLinkInput:
	call _goronDance_getNextMove		; $7903
	cp $00			; $7906
	jr z,@rest	; $7908

	call _goronDance_checkTooLateToInput		; $790a
	jr z,@tooLate	; $790d

	ld a,(wGameKeysJustPressed)		; $790f
	and (BTN_A | BTN_B)			; $7912
	ret z			; $7914

	ld b,a			; $7915
	ld (wTmpcfc0.goronDance.linkStartedDance),a		; $7916
	ld a,(wTmpcfc0.goronDance.currentMove)		; $7919
	cp b			; $791c
	jr nz,@wrongMove	; $791d

	; Check if too early
	call _goronDance_checkInputNotTooEarlyOrLate		; $791f
	jr z,@madeMistake	; $7922
	jp @doDanceMove		; $7924

@rest:
	call _goronDance_checkExactInputTimePassed		; $7927
	jr z,@doDanceMove	; $792a
	ld a,(wGameKeysJustPressed)		; $792c
	and $03			; $792f
	jr nz,@wrongMove	; $7931
	ret			; $7933

@tooLate:
	ld a,$01		; $7934
	ld (wTmpcfc0.goronDance.failureType),a		; $7936
	jr @madeMistake		; $7939

@wrongMove:
	ld a,$02		; $793b
	ld (wTmpcfc0.goronDance.failureType),a		; $793d

@madeMistake:
	ld h,d			; $7940
	ld l,Interaction.state2		; $7941
	ld (hl),$04		; $7943
	ld l,Interaction.var3f		; $7945
	ld (hl),$00		; $7947
	ld l,Interaction.counter1		; $7949
	ld (hl),30		; $794b

	ld a,SND_ERROR		; $794d
	call playSound		; $794f

	ld a,LINK_ANIM_MODE_COLLAPSED		; $7952
	ld (wcc50),a		; $7954

	call checkIsLinkedGame		; $7957
	jr z,@gorons	; $795a
	ld a,(wTilesetFlags)		; $795c
	and TILESETFLAG_PAST			; $795f
	jr z,@gorons	; $7961

@subrosians:
	ld a,$02		; $7963
	ld (wTmpcfc0.goronDance.danceAnimation),a		; $7965
	ret			; $7968
@gorons:
	ld a,$04		; $7969
	ld (wTmpcfc0.goronDance.danceAnimation),a		; $796b
	ret			; $796e

@doDanceMove:
	call _goronDance_updateConsecutiveBPressCounter		; $796f
	call _goronDance_updateLinkAndBackupDancerAnimation		; $7972
	jr z,@jump	; $7975

	call _goronDance_playMoveSound		; $7977
	call _goronDance_incBeat		; $797a
	call _goronDance_getNextMove		; $797d
	jr nz,@roundFinished	; $7980
	ret			; $7982

@jump:
	call _goronDance_incBeat		; $7983
	call _goronDance_getNextMove		; $7986
	call getFreeInteractionSlot		; $7989
	ret nz			; $798c

	; Spawn a goron with subid $02? (A "fake" object that manages a jump?)
	ld (hl),INTERACID_GORON		; $798d
	inc l			; $798f
	ld (hl),$02		; $7990
	ld a,$01		; $7992
	ld (wTmpcfc0.goronDance.linkJumping),a		; $7994
	jp interactionIncState2		; $7997

@roundFinished:
	xor a			; $799a
	ld (wTmpcfc0.goronDance.cfd9),a		; $799b
	ld hl,wTmpcfc0.goronDance.roundIndex		; $799e
	inc (hl)		; $79a1

	ld h,d			; $79a2
	ld l,Interaction.state2		; $79a3
	ld (hl),$03		; $79a5
	ld l,Interaction.counter1		; $79a7
	ld (hl),30		; $79a9
	ret			; $79ab

;;
; @param[out]	zflag	z if too early or too late
; @addr{79ac}
_goronDance_checkInputNotTooEarlyOrLate:
	call _goronDance_getCurrentAndNeededFrameCounts		; $79ac

	; Add 8 to hl, 8 to bc (the "expected" moment to press the button?)
	ld a,$08		; $79af
	rst_addAToHl			; $79b1
	ld a,$08		; $79b2
	call addAToBc		; $79b4

	; Subtract 8 from hl (check earliest possible frame?)
	push bc			; $79b7
	ld b,$ff		; $79b8
	ld c,$f8		; $79ba
	add hl,bc		; $79bc
	pop bc			; $79bd

	call compareHlToBc		; $79be
	cp $01			; $79c1
	jr z,@tooEarly	; $79c3

	; Add $10 to hl (check latest possible frame?)
	ld a,$10		; $79c5
	rst_addAToHl			; $79c7
	call compareHlToBc		; $79c8
	cp $ff			; $79cb
	jr z,@tooLate	; $79cd
	ret			; $79cf

@tooEarly:
	ld a,$00		; $79d0
	ld (wTmpcfc0.goronDance.failureType),a		; $79d2
	ret			; $79d5

@tooLate:
	ld a,$01		; $79d6
	ld (wTmpcfc0.goronDance.failureType),a		; $79d8
	ret			; $79db

;;
; @param[out]	zflag	z the window for input this beat has passed.
; @addr{79dc}
_goronDance_checkTooLateToInput:
	call _goronDance_getCurrentAndNeededFrameCounts		; $79dc
	ld a,$08		; $79df
	rst_addAToHl			; $79e1
	jr ++			; $79e2

;;
; @param[out]	zflag	z if the exact expected time for the input has passed.
; @addr{79e4}
_goronDance_checkExactInputTimePassed:
	call _goronDance_getCurrentAndNeededFrameCounts		; $79e4
++
	call compareHlToBc		; $79e7
	cp $ff			; $79ea
	ret			; $79ec

;;
; @param[out]	bc	Current frame count
; @param[out]	hl	Needed frame count? (First OK frame to press button?)
; @addr{79ed}
_goronDance_getCurrentAndNeededFrameCounts:
	; hl = [wTmpcfc0.goronDance.beat] * 20
	ld a,(wTmpcfc0.goronDance.beat)		; $79ed
	push af			; $79f0
	call multiplyABy4		; $79f1
	ld l,c			; $79f4
	ld h,b			; $79f5
	pop af			; $79f6
	call multiplyABy16		; $79f7
	add hl,bc		; $79fa

	ld a,(wTmpcfc0.goronDance.frameCounter)		; $79fb
	ld c,a			; $79fe
	ld a,(wTmpcfc0.goronDance.frameCounter+1)		; $79ff
	ld b,a			; $7a02
	ret			; $7a03

;;
; @addr{7a04}
_goronDance_playMoveSound:
	ld a,(wTmpcfc0.goronDance.currentMove)		; $7a04
	bit 7,a			; $7a07
	ret nz			; $7a09
	cp $00			; $7a0a
	ret z			; $7a0c

	cp $02			; $7a0d
	jr z,++			; $7a0f
	ld a,SND_DING		; $7a11
	jp playSound		; $7a13
++
	ld a,SND_GORON_DANCE_B		; $7a16
	jp playSound		; $7a18

;;
; @addr{7a1b}
_goronDance_incBeat:
	ld hl,wTmpcfc0.goronDance.beat		; $7a1b
	inc (hl)		; $7a1e
	ret			; $7a1f

;;
; Get the next dance move, based on "danceLevel", "dancePattern", and "beat".
;
; @param[out]	zflag	nz if the data ran out.
; @addr{7a20}
_goronDance_getNextMove:
	ld a,(wTmpcfc0.goronDance.danceLevel)		; $7a20
	ld hl,_goronDance_sequenceData		; $7a23
	rst_addDoubleIndex			; $7a26
	ldi a,(hl)		; $7a27
	ld h,(hl)		; $7a28
	ld l,a			; $7a29
	ld a,(wTmpcfc0.goronDance.dancePattern)		; $7a2a
	swap a			; $7a2d
	ld b,a			; $7a2f
	ld a,(wTmpcfc0.goronDance.beat)		; $7a30
	add b			; $7a33
	rst_addAToHl			; $7a34
	ld a,(hl)		; $7a35
	ld (wTmpcfc0.goronDance.currentMove),a		; $7a36
	bit 7,a			; $7a39
	ret			; $7a3b

;;
; @addr{7a3c}
_goronDance_updateConsecutiveBPressCounter:
	ld hl,wTmpcfc0.goronDance.consecutiveBPressCounter		; $7a3c
	ld a,(wTmpcfc0.goronDance.currentMove)		; $7a3f
	cp $02			; $7a42
	jr z,+			; $7a44
	ld (hl),$00		; $7a46
	ret			; $7a48
+
	inc (hl)		; $7a49
	ret			; $7a4a

;;
; @param[out]	zflag	z if Link and dancers should jump
; @addr{7a4b}
_goronDance_updateLinkAndBackupDancerAnimation:
	call _goronDance_updateBackupDancerAnimation		; $7a4b
	ld a,(wTmpcfc0.goronDance.currentMove)		; $7a4e
	cp $01			; $7a51
	jr nz,@bButton	; $7a53

@aButton:
	ld a,LINK_ANIM_MODE_DANCELEFT		; $7a55
	ld (wcc50),a		; $7a57
	or d			; $7a5a
	ret			; $7a5b

@bButton:
	ld a,(wTmpcfc0.goronDance.consecutiveBPressCounter)		; $7a5c
	ld hl,_goronDance_linkBButtonAnimations		; $7a5f
	rst_addAToHl			; $7a62

	; Should they jump?
	ld a,(hl)		; $7a63
	cp $50			; $7a64
	ret z			; $7a66

	cp $04			; $7a67
	jr nz,_goronDance_turnLinkToDirection	; $7a69

	ld a,LINK_ANIM_MODE_GETITEM1HAND		; $7a6b
	ld (wcc50),a		; $7a6d
	or d			; $7a70
	ret			; $7a71

;;
; @param	a	Direction
; @addr{7a72}
_goronDance_turnLinkToDirection:
	ld hl,w1Link.direction		; $7a72
	ld (hl),a		; $7a75
	ld a,LINK_ANIM_MODE_WALK		; $7a76
	ld (wcc50),a		; $7a78
	or d			; $7a7b
	ret			; $7a7c


; Link's direction values for consecutive B presses.
; $04 marks a particular animation, and $50 marks that he should jump.
_goronDance_linkBButtonAnimations:
	.db $02 $03 $01 $04 $03 $50


;;
; @param[out]	zflag	z if they should jump
; @addr{7a83}
_goronDance_updateBackupDancerAnimation:
	call checkIsLinkedGame		; $7a83
	jr z,@gorons	; $7a86
	ld a,(wTilesetFlags)		; $7a88
	and TILESETFLAG_PAST			; $7a8b
	jr z,@gorons	; $7a8d

@subrosians:
	ld a,(wTmpcfc0.goronDance.currentMove)		; $7a8f
	cp $01			; $7a92
	jr nz,@subrosianBButton	; $7a94

	; A button
	ld a,$06		; $7a96
	jr @setDanceAnimation		; $7a98

@subrosianBButton:
	ld a,(wTmpcfc0.goronDance.consecutiveBPressCounter)		; $7a9a
	ld hl,_goronDance_subrosianBAnimations		; $7a9d
	rst_addAToHl			; $7aa0
	ld a,(hl)		; $7aa1
	cp $50			; $7aa2
	ret z			; $7aa4
	ld (wTmpcfc0.goronDance.danceAnimation),a		; $7aa5
	ret			; $7aa8

@gorons:
	ld a,(wTmpcfc0.goronDance.currentMove)		; $7aa9
	cp $01			; $7aac
	jr nz,@goronBButton	; $7aae

	; A button
	ld a,$06		; $7ab0
	jr @setDanceAnimation		; $7ab2

@goronBButton:
	ld a,(wTmpcfc0.goronDance.consecutiveBPressCounter)		; $7ab4
	ld hl,_goronDance_goronBAnimations		; $7ab7
	rst_addAToHl			; $7aba
	ld a,(hl)		; $7abb
	cp $50			; $7abc
	ret z			; $7abe

@setDanceAnimation:
	ld (wTmpcfc0.goronDance.danceAnimation),a		; $7abf
	ret			; $7ac2

_goronDance_goronBAnimations:
	.db $02 $03 $04 $01 $00 $50

_goronDance_subrosianBAnimations:
	.db $02 $03 $01 $03 $00 $50


;;
; @param[out]	zflag	z if the graceful goron should jump (5 consecutive B presses)
; @addr{7acf}
_goronDance_updateGracefulGoronAnimation:
	ld a,(wTmpcfc0.goronDance.currentMove)		; $7acf
	cp $01			; $7ad2
	jr nz,@bButton	; $7ad4

	; A button
	ld a,$06		; $7ad6
	jr @setAnimation		; $7ad8

@bButton:
	ld a,(wTmpcfc0.goronDance.consecutiveBPressCounter)		; $7ada
	ld hl,_goronDance_goronBAnimations		; $7add
	rst_addAToHl			; $7ae0
	ld a,(hl)		; $7ae1
	cp $50			; $7ae2
	ret z			; $7ae4

@setAnimation:
	call interactionSetAnimation		; $7ae5
	or d			; $7ae8
	ret			; $7ae9


; This holds the patterns for the various levels of the goron dance.
_goronDance_sequenceData:
	.dw @platinum
	.dw @gold
	.dw @silver
	.dw @bronze

; Each row represents one possible dance pattern.
;   $00 means "rest";
;   $01 means "A";
;   $02 means "B";
;   $ff means "End".

@platinum:
	.db $02 $02 $02 $01 $00 $00 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $01 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $00 $02 $02 $01 $00 $02 $00 $01 $00 $01 $ff $00 $00
	.db $02 $00 $02 $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $00 $02 $01 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $00 $02 $02 $02 $00 $02 $02 $02 $02 $02 $01 $01 $ff
	.db $02 $02 $02 $01 $00 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $00 $01 $00 $02 $01 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $01 $00 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $02 $01 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00

@gold:
	.db $02 $01 $02 $00 $00 $02 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $01 $00 $02 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $00 $02 $01 $02 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $02 $00 $02 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $00 $02 $01 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $02 $00 $02 $01 $02 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $00 $02 $02 $02 $00 $02 $02 $02 $01 $02 $02 $01 $ff
	.db $02 $02 $01 $00 $02 $01 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $00 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00

@silver:
	.db $02 $02 $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $00 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $00 $02 $01 $02 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $02 $01 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00

@bronze:
	.db $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $00 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $00 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $02 $01 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $02 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00

;;
; @addr{7d72}
_goron_initGraphicsAndIncState:
	call _goron_initGraphics		; $7d72
	jp interactionIncState		; $7d75

;;
; @addr{7d78}
_goron_loadScriptAndInitGraphics:
	call _goron_initGraphics		; $7d78
	jr _goron_loadScript		; $7d7b

;;
; @addr{7d7d}
_goron_loadScriptFromTableAndInitGraphics:
	call _goron_initGraphics		; $7d7d
	jr _goron_loadScriptFromTable		; $7d80

;;
; @addr{7d82}
_goron_initGraphics:
	call interactionLoadExtraGraphics		; $7d82
	jp interactionInitGraphics		; $7d85

;;
; @addr{7d88}
_goron_loadScript:
	ld e,Interaction.subid		; $7d88
	ld a,(de)		; $7d8a
	ld hl,_goron_scriptTable		; $7d8b
	rst_addDoubleIndex			; $7d8e
	ldi a,(hl)		; $7d8f
	ld h,(hl)		; $7d90
	ld l,a			; $7d91
	call interactionSetScript		; $7d92
	jp interactionIncState		; $7d95

;;
; Load a script based on both subid and var03.
; @addr{7d98}
_goron_loadScriptFromTable:
	ld e,Interaction.subid		; $7d98
	ld a,(de)		; $7d9a
	ld hl,_goron_scriptTable		; $7d9b
	rst_addDoubleIndex			; $7d9e
	ldi a,(hl)		; $7d9f
	ld h,(hl)		; $7da0
	ld l,a			; $7da1
	inc e			; $7da2
	ld a,(de)		; $7da3
	rst_addDoubleIndex			; $7da4
	ldi a,(hl)		; $7da5
	ld h,(hl)		; $7da6
	ld l,a			; $7da7
	call interactionSetScript		; $7da8
	jp interactionIncState		; $7dab

; @addr{7dae}
_goron_scriptTable:
	.dw stubScript
	.dw goron_subid01Script
	.dw stubScript
	.dw goron_subid03Script
	.dw goron_subid04Script
	.dw @subid05ScriptTable
	.dw @subid06ScriptTable
	.dw goron_subid07Script
	.dw goron_subid08Script
	.dw @subid09ScriptTable
	.dw goron_subid0aScript
	.dw @subid0bScriptTable
	.dw goron_subid0cScript
	.dw goron_subid0dScript
	.dw goron_subid0eScript
	.dw stubScript
	.dw goron_subid10Script

@subid05ScriptTable:
	.dw goron_subid05Script_A
	.dw goron_subid05Script_A
	.dw goron_subid05Script_A
	.dw goron_subid05Script_B
	.dw goron_subid05Script_B
	.dw goron_subid05Script_B

@subid06ScriptTable:
	.dw goron_subid06Script_A
	.dw goron_subid06Script_B

@subid09ScriptTable:
	.dw goron_subid09Script_A
	.dw goron_subid09Script_B

@subid0bScriptTable:
	.dw goron_subid0bScript
	.dw goron_subid0bScript


; @addr{7de8}
goronDanceScriptTable:
	.dw goron_subid00Script
	.dw goronDanceScript_failedRound
	.dw goronDanceScript_givePrize
