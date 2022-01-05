; This file is included by "code/rando/rando.s" which puts it in the "rando" namespace.

;;
; This is called by the "giveTreasure" function just after giving the treasure.
;
; @param	b	Treasure
; @param	c	Parameter
randoGiveTreasureHook:
	call satchelRefillSeeds
	call giveInitialSeeds
	call activateFlute
.ifdef ROM_AGES
	call handleD6BossKeys
.endif
	ret

;;
; Have seed satchel inherently refill all seeds.
satchelRefillSeeds:
	ld a,b
	cp TREASURE_SEED_SATCHEL
	ret nz

	push bc
	call refillSeedSatchel
	pop bc
	ret

;;
; Satchel, slingshot, and shooter give seeds of the same type as the starting tree.
giveInitialSeeds:
	ld a,b
	cp TREASURE_SEED_SATCHEL
	jr z,++
	cp TREASURE_SLINGSHOT
	jr z,++
	cp TREASURE_SHOOTER
	ret nz
++
	push bc
	ld a,(randovar_initialSeedType)
	add TREASURE_EMBER_SEEDS
	ld c,$20
	call giveTreasure
	pop bc
	ret

;;
; Sets flute icon and animal flags based on flute param.
activateFlute:
	ld a,b
	cp a,TREASURE_FLUTE
	ret nz

	ld e,<wFluteIcon
	ld a,c
	sub $0a ; get animal index item parameter
	ld (de),a

	add <wCompanionStates - 1
	ld h,>wCompanionStates
	ld l,a ; hl = flags for relevant animal

.ifdef ROM_SEASONS
	cp <wMooshState
	jr nz,@notMoosh

	set 5,(hl)
	jr @done

@notMoosh:
	set 7,(hl)

@done:
	ret

.else ; ROM_AGES
	; Set bits for the companion's state (wRickyState / wDimitriState / wMooshState):
	; - 7: You have their flute
	; - 6: They disappear from their designated "event" area (ie. ricky helping with tingle)
	; - 1/0: Animal-dependant?
	ld (hl),$c3
	ret
.endif


.ifdef ROM_AGES

;;
; Getting the D6 Past boss key also gives you the D6 Present boss key. Only matters for the display
; on the map screen.
handleD6BossKeys:
	ld a,b
	cp TREASURE_BOSS_KEY
	ret nz
	ld a,c
	cp $0c
	ret nz

	push bc
	ld a,TREASURE_BOSS_KEY
	ld c,$06
	call giveTreasure
	pop bc
	ret

.endif


; ================================================================================
; Below here are callbacks from "data/rando/itemSlots.s". "onItemObtained" is called just after
; "giveTreasure", and "isItemObtained" is called to check whether to play compass chimes.
; ================================================================================

itemSlotCallbacksStart:

.ifdef ROM_SEASONS

seasonsSlotCallbackTable_makuTree:
	.dw @onItemObtained
	.dw @isItemObtained
@onItemObtained:
	ld a,RANDO_MAKU_TREE_FLAG
	jp setRandoItemFlag
@isItemObtained:
	ld a,RANDO_MAKU_TREE_FLAG
	jp checkRandoItemFlag


seasonsSlotCallbackTable_shop150Rupees:
	.dw @onItemObtained
	.dw @isItemObtained
@onItemObtained:
	ld a,RANDO_SHOP_FLUTE_FLAG
	jp setRandoItemFlag
@isItemObtained:
	ld a,RANDO_SHOP_FLUTE_FLAG
	jp checkRandoItemFlag


seasonsSlotCallbackTable_membersShop1:
	.dw $0000
	.dw @isItemObtained
@isItemObtained:
	ld a,(wBoughtShopItems1)
	rrca
	ret


seasonsSlotCallbackTable_membersShop2:
	.dw $0000
	.dw @isItemObtained
@isItemObtained:
	ld a,(wBoughtShopItems1)
	rrca
	rrca
	ret


seasonsSlotCallbackTable_membersShop3:
	.dw $0000
	.dw @isItemObtained
@isItemObtained:
	ld a,(wBoughtShopItems1)
	swap a
	rlca
	ret


seasonsSlotCallbackTable_masterDiversReward:
	.dw @onItemObtained
	.dw @isItemObtained
@onItemObtained:
	ld a,RANDO_MASTER_DIVERS_REWARD_FLAG
	jp setRandoItemFlag
@isItemObtained:
	ld a,RANDO_MASTER_DIVERS_REWARD_FLAG
	jp checkRandoItemFlag


seasonsSlotCallbackTable_subrosiaSeaside:
	.dw @onItemObtained
	.dw @isItemObtained
@onItemObtained:
	ld a,GLOBALFLAG_STAR_ORE_FOUND
	jp setGlobalFlag
@isItemObtained:
	ld a,GLOBALFLAG_STAR_ORE_FOUND
	call checkGlobalFlag
	jr nz,@have

	; Because this is only used for compasses, pretend we have it already if this is not the
	; screen where the star ore spawns.
	call @findStarOreObject
	jr nz,@dontHave
	ld a,(wActiveRoom)
	ld l,Interaction.var30
	cp (hl)
	jr z,@dontHave
@have:
	scf
	ret
@dontHave:
	xor a
	ret

@findStarOreObject:
	ld h,FIRST_INTERACTION_INDEX
	ld l,Interaction.id
@loop:
	ld a,INTERACID_ROSA
	cp (hl)
	jr nz,@next
	inc l
	ld a,$02
	cp (hl) ; subid
	ret z
	dec l
@next:
	inc h
	ld a,h
	cp LAST_INTERACTION_INDEX+1
	jr c,@loop
	or h
	ret


seasonsSlotCallbackTable_subrosiaMarket1stItem:
	.dw @onItemObtained
	.dw @isItemObtained
@onItemObtained:
	; This used to be done automatically when you get the ribbon, but obviously the treasure you
	; get might not be the ribbon
	ld a,TREASURE_STAR_ORE
	jp loseTreasure
@isItemObtained:
	ld a,(wBoughtSubrosianShopItems)
	rrca
	ret


seasonsSlotCallbackTable_subrosiaMarket2ndItem:
	.dw $0000
	.dw @isItemObtained
@isItemObtained:
	ld a,(wBoughtSubrosianShopItems)
	rrca
	rrca
	ret


seasonsSlotCallbackTable_subrosiaMarket5thItem:
	.dw @onItemObtained
	.dw @isItemObtained
@onItemObtained:
	ld a,RANDO_SUBROSIA_MARKET_5_FLAG
	jp setRandoItemFlag
@isItemObtained:
	ld a,RANDO_SUBROSIA_MARKET_5_FLAG
	jp checkRandoItemFlag


.else ; ROM_AGES


agesSlotCallbackTable_balloonGuysGift:
	.dw @onItemObtained
	.dw @isItemObtained
@onItemObtained:
	ld a,RANDO_ISLAND_CHART_FLAG
	jp setRandoItemFlag
@isItemObtained:
	ld a,RANDO_ISLAND_CHART_FLAG
	jp checkRandoItemFlag


agesSlotCallbackTable_balloonGuysUpgrade:
	.dw $0000
	.dw @isItemObtained
@isItemObtained:
	ld a,GLOBALFLAG_GOT_SATCHEL_UPGRADE
	call checkGlobalFlag
	ret z
	scf
	ret


agesSlotCallbackTable_shop150Rupees:
	.dw @onItemObtained
	.dw @isItemObtained
@onItemObtained:
	ld a,RANDO_SHOP_FLUTE_FLAG
	jp setRandoItemFlag
@isItemObtained:
	ld a,RANDO_SHOP_FLUTE_FLAG
	jp checkRandoItemFlag


agesSlotCallbackTable_kingZora:
	.dw @onItemObtained
	.dw @isItemObtained
@onItemObtained:
	ld a,RANDO_KING_ZORA_FLAG
	jp setRandoItemFlag
@isItemObtained:
	ld a,RANDO_KING_ZORA_FLAG
	jp checkRandoItemFlag


agesSlotCallbackTable_symmetryCityBrother:
	.dw @onItemObtained
	.dw @isItemObtained
@onItemObtained:
	ld a,RANDO_SYMMETRY_BROTHER_FLAG
	jp setRandoItemFlag
@isItemObtained:
	ld a,RANDO_SYMMETRY_BROTHER_FLAG
	jp checkRandoItemFlag


agesSlotCallbackTable_firstGoronDance:
	.dw @onItemObtained
	.dw @isItemObtained
@onItemObtained:
	ld a,RANDO_FIRST_GORON_DANCE_FLAG
	jp setRandoItemFlag
@isItemObtained:
	ld a,RANDO_FIRST_GORON_DANCE_FLAG
	jp checkRandoItemFlag


agesSlotCallbackTable_goronDanceWithLetter:
	.dw @onItemObtained
	.dw @isItemObtained
@onItemObtained:
	ld a,RANDO_GORON_DANCE_WITH_LETTER_FLAG
	jp setRandoItemFlag
@isItemObtained:
	ld a,RANDO_GORON_DANCE_WITH_LETTER_FLAG
	jp checkRandoItemFlag


agesSlotCallbackTable_tradeLavaJuice:
	.dw $0000
	.dw @isItemObtained
@isItemObtained:
	call getThisRoomFlags
	and $40
	ret z
	scf
	ret


agesSlotCallbackTable_targetCarts2:
	.dw @onItemObtained
	.dw @isItemObtained
@onItemObtained:
	call getThisRoomFlags
	ld a,(hl)
	or $40
	ld (hl),a
	ret
@isItemObtained:
	call getThisRoomFlags
	and $40
	ret z
	scf
	ret


agesSlotCallbackTable_rescueNayru:
	.dw $0000
	.dw @isItemObtained
@isItemObtained:
	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	ret z
	scf
	ret

.endif ; ROM_AGES
