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

.ifdef ROM_AGES
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
.else
	ld a,TREASURE_SWORD		; $4ada
	call checkTreasureObtained		; $4adc
	jp nc,_shopItemPopStackAndDeleteSelf		; $4adf
	ld e,Interaction.subid		; $4ae2
	ld a,(de)		; $4ae4
.endif

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

.ifdef ROM_AGES
	ld a,GLOBALFLAG_CAN_BUY_FLUTE		; $432e
	call checkGlobalFlag		; $4330
	jr z,@fluteNotPurchasable	; $4333
.else
	ld a,(wRickyState)		; $4af8
	bit 5,a			; $4afb
	jr nz,@fluteNotPurchasable	; $4afd
	ld a,(wEssencesObtained)		; $4aff
	bit 1,a			; $4b02
	jr z,@fluteNotPurchasable	; $4b04
	call checkIsLinkedGame		; $4b06
	jr nz,@fluteNotPurchasable	; $4b09
.endif

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

.ifdef ROM_SEASONS
	ld e,Interaction.subid		; $4bfe
	ld a,(de)		; $4c00
	or a			; $4c01
	call z,refillSeedSatchel		; $4c02
.endif

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

.ifdef ROM_AGES
	ld e,$06 ; Attribute value to use
.else
	ld e,$03 ; Attribute value to use
.endif
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
.ifdef ROM_AGES
	.dw w3VramTiles+$66
	.dw w3VramTiles+$6e
.endif

_shopItemPrices:
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
.ifdef ROM_AGES
	/* $14 */ .db <wBoughtShopItems1  $01 $ff $00
	/* $15 */ .db <wBoughtShopItems2  $40 $05 $00
.endif


; Text to show upon buying a shop item (or $00 for no text)
_shopItemTextTable:
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
; INTERACID_SEASONS_FAIRY
; ==============================================================================
interactionCode50:
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
.ifdef ROM_AGES
	ldh a,(<hActiveObjectType)	; $493f
	add Object.zh			; $4941
	ld e,a			; $4943
	ld a,(de)		; $4944
	add (hl)		; $4945
.else
	ld e,Interaction.zh		; $5108
	ld a,(hl)		; $510a
.endif
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
