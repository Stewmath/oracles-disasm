; ==================================================================================================
; INTERAC_TOKAY_SHOP_ITEM
;
; Variables:
;   var38: If nonzero, item can be bought with seeds
;   var39: Number of seeds Link has of the type needed to buy this item
;   var3a: Set if Link has the shovel
;   var3c: The treasure ID of this item (feather/bracelet only)
;   var3d: Set if Link has the shield
; ==================================================================================================
interactionCode81:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld a,>TX_0a00
	call interactionSetHighTextIndex
	call interactionSetAlwaysUpdateBit
	ld a,$06
	call objectSetCollideRadius

	ld l,Interaction.subid
	ldi a,(hl)
	ld (hl),a ; [var03] = [subid]
	cp $04
	jr nz,@initializeItem

	; This is the shield; only appears if all other items retrieved. Also, adjust
	; level appropriately.
	ld a,GLOBALFLAG_BOUGHT_BRACELET_FROM_TOKAY
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,(wShieldLevel)
	or a
	jr z,@initializeItem

	; [subid] = [var03] = [wShieldLevel] + [subid] - 1
	ld e,Interaction.subid
	ld c,a
	dec c
	ld a,(de)
	add c
	ld (de),a
	inc e
	ld (de),a

@initializeItem:
	call @checkTransformItem
	jp nz,interactionDelete

	ld hl,mainScripts.tokayShopItemScript
	call interactionSetScript
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
	call interactionSetAlwaysUpdateBit
	jp objectSetVisible82

@initialShopTreasures:
	.db TREASURE_FEATHER, TREASURE_BRACELET

@seedsNeededToBuyItems:
	.db TREASURE_MYSTERY_SEEDS, TREASURE_SCENT_SEEDS, $00, $00,
	.db TREASURE_SCENT_SEEDS, TREASURE_SCENT_SEEDS, TREASURE_SCENT_SEEDS

	; TODO: what is this data? Possibly unused? ($626f)
	.db $28 $76 $6c $76 $b4 $76 $c4 $76

@state1:
	call interactionAnimateAsNpc
	call @checkTransformItem
	call nz,objectSetInvisible
	call interactionRunScript
	ret nc
	xor a
	ld (wDisabledObjects),a
	jp interactionDelete

;;
; This checks whether to replace the feather/bracelet with the shovel, changing the subid
; accordingly and initializing the graphics after doing so.
;
; @param[out]	zflag	nz if item should be deleted?
@checkTransformItem:
	ld h,d
	ld l,Interaction.var38
	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a

	ld e,Interaction.var03
	ld a,(de)
	ld c,a
	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	jr nc,@checkReplaceWithShovel

	; Seed satchel obtained; set var38/var39 based on whether Link can buy the item?

	ld a,c
	ld hl,@seedsNeededToBuyItems
	rst_addAToHl
	ld a,(hl)
	call checkTreasureObtained
	jr nc,@checkReplaceWithShovel

	inc a
	ld e,Interaction.var39
	ld (de),a
	cp $10
	jr c,@checkReplaceWithShovel

	ld e,Interaction.var38
	ld (de),a

@checkReplaceWithShovel:
	ld a,TREASURE_SHOVEL
	call checkTreasureObtained
	jr nc,++
	ld e,Interaction.var3a
	ld a,$01
	ld (de),a
++
	ld a,TREASURE_SHIELD
	call checkTreasureObtained
	jr nc,++
	ld e,Interaction.var3d
	ld a,$01
	ld (de),a
++
	ld a,c
	cp $04
	jr nc,@setSubidAndInitGraphics

	; The item is the feather or the bracelet.

	; If we've bought the item, it should be deleted.
	ld a,c
	ld hl,@boughtItemGlobalflags
	rst_addAToHl
	ld a,(hl)
	call checkGlobalFlag
	ret nz

	; Otherwise, if Link has the item, it should be replaced with the shovel.
	ld a,c
	ld hl,@initialShopTreasures
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var3c
	ld (de),a

	call checkTreasureObtained
	jr nc,@setSubidAndInitGraphics

	; Increment subid by 2, making it a shovel
	inc c
	inc c

@setSubidAndInitGraphics:
	ld e,Interaction.subid
	ld a,c
	ld (de),a
	call interactionInitGraphics
	xor a
	ret

@boughtItemGlobalflags:
	.db GLOBALFLAG_BOUGHT_FEATHER_FROM_TOKAY, GLOBALFLAG_BOUGHT_BRACELET_FROM_TOKAY
