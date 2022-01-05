; This is in the "rando" namespace.
;
; The data in this file will be modified by the randomizer. (It should not modify the collect mode,
; only the treasure object.)
;
; Data Format:
;   dwbe <Treasure Object Index>
;   .db <Collect Mode>
;   dwbe <Room Index>
;   .dw <Pointer to callback table, or $0000>
;
; The "callback table", if nonzero, has the following data:
;
;   .dw OnItemObtained (Pointer to function to run when obtaining the item)
;   .dw IsItemObtained (Pointer to function that determines if the item has been obtained)
;
; Either of those 2 pointers can also be null. "IsItemObtained" returns with the carry flag set if
; the item is obtained. If it is null, then the item is considered obtained if ROOMFLAG_ITEM is set
; in that room (this works in 90% of cases). Currently this is only used for compasses. (The
; subrosian seaside check, in particular, is built on the assumption that it's for compasses only.)
;
; Misc notes:
; - COLLECT_MODE_FALL will be changed to COLLECT_MODE_FALL_KEY if the item in the slot is a small
;   key (uses "TREASURE_GRAB_MODE_NO_CHANGE"). Also, the key won't have its text shown. This is
;   done in the disassembly code ("modifyTreasureInteraction" function).
; - COLLECT_MODE_CHEST becomes COLLECT_MODE_CHEST_MAP_OR_COMPASS if the contents are a map or
;   compass. Also done in the "modifyTreasureInteraction" function.
; - There must not be any extra data between slots. The data is both referenced directly by label,
;   and searched through like an array, depending on the context (hence the "slotsStart" and
;   "slotsEnd" labels).
; - Remember to update the ITEM_SLOT_SIZE constant if the structure of this data is changed.


.ifdef ROM_SEASONS

slotsStart:

; ==============================================================================
; Horon Village
; ==============================================================================

seasonsSlot_makuTree:
	dwbe TREASURE_OBJECT_GNARLED_KEY_00
	.db  COLLECT_MODE_FALL
	dwbe $020b
	.dw  seasonsSlotCallbackTable_makuTree

seasonsSlot_horonVillageSWChest:
	dwbe TREASURE_OBJECT_RUPEES_03
	.db  COLLECT_MODE_CHEST
	dwbe $00f5
	.dw  $0000

seasonsSlot_horonVillageSEChest:
	dwbe TREASURE_OBJECT_RUPEES_03
	.db  COLLECT_MODE_CHEST
	dwbe $00f9
	.dw  $0000

seasonsSlot_shop150Rupees:
	dwbe TREASURE_OBJECT_FLUTE_00
	.db  $00
	dwbe $03a6
	.dw  seasonsSlotCallbackTable_shop150Rupees

seasonsSlot_membersShop1:
	dwbe TREASURE_OBJECT_SEED_SATCHEL_00
	.db  $00
	dwbe $03b0
	.dw  seasonsSlotCallbackTable_membersShop1

seasonsSlot_membersShop2:
	dwbe TREASURE_OBJECT_GASHA_SEED_00
	.db  $00
	dwbe $03b0
	.dw  seasonsSlotCallbackTable_membersShop2

seasonsSlot_membersShop3:
	dwbe TREASURE_OBJECT_TREASURE_MAP_00
	.db  $00
	dwbe $03b0
	.dw  seasonsSlotCallbackTable_membersShop3

; ==============================================================================
; Western Coast
; ==============================================================================

seasonsSlot_blackBeastsChest:
	dwbe TREASURE_OBJECT_X_SHAPED_JEWEL_00
	.db  COLLECT_MODE_CHEST
	dwbe $00f4
	.dw  $0000

seasonsSlot_westernCoastBeachChest:
	dwbe TREASURE_OBJECT_RING_07
	.db  COLLECT_MODE_CHEST
	dwbe $00e3
	.dw  $0000

seasonsSlot_westernCoastInHouse:
	dwbe TREASURE_OBJECT_BOMBS_00
	.db  COLLECT_MODE_CHEST
	dwbe $0388
	.dw  $0000

; ==============================================================================
; Eastern Suburbs / Woods of Winter
; ==============================================================================

seasonsSlot_woodsOfWinter1stCave:
	dwbe TREASURE_OBJECT_RUPEES_04
	.db  COLLECT_MODE_CHEST
	dwbe $05b4
	.dw  $0000

seasonsSlot_woodsOfWinter2ndCave:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $0512
	.dw  $0000

seasonsSlot_hollysHouse:
	dwbe TREASURE_OBJECT_SHOVEL_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $03a3
	.dw  $0000

seasonsSlot_chestOnTopOfD2:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $008e
	.dw  $0000

seasonsSlot_caveOutsideD2:
	dwbe TREASURE_OBJECT_RING_05
	.db  COLLECT_MODE_CHEST
	dwbe $05b3
	.dw  $0000

seasonsSlot_easternSuburbsOnCliff:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $04f7
	.dw  $0000

; ==============================================================================
; Samasa Desert
; ==============================================================================

seasonsSlot_samasaDesertPit:
	dwbe TREASURE_OBJECT_PIRATES_BELL_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $05d2
	.dw  $0000

seasonsSlot_samasaDesertChest:
	dwbe TREASURE_OBJECT_RING_08
	.db  COLLECT_MODE_CHEST
	dwbe $00ff
	.dw  $0000

; ==============================================================================
; North Horon / Horon Plain
; ==============================================================================

seasonsSlot_eyeglassLakeAcrossBridge:
	dwbe TREASURE_OBJECT_GASHA_SEED_00
	.db  COLLECT_MODE_CHEST
	dwbe $00b8
	.dw  $0000

seasonsSlot_oldManInTreehouse:
	dwbe TREASURE_OBJECT_ROUND_JEWEL_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $0394
	.dw  $0000

seasonsSlot_caveSouthOfMrsRuul:
	dwbe TREASURE_OBJECT_RING_09
	.db  COLLECT_MODE_CHEST
	dwbe $04e0
	.dw  $0000

seasonsSlot_blainoPrize:
	dwbe TREASURE_OBJECT_RICKY_GLOVES_00
	.db  COLLECT_MODE_PICKUP_1HAND
	dwbe $03b4
	.dw  $0000

seasonsSlot_caveNorthOfD1:
	dwbe TREASURE_OBJECT_RING_0a
	.db  COLLECT_MODE_CHEST
	dwbe $04e1
	.dw  $0000

seasonsSlot_dryEyeglassLakeWestCave:
	dwbe TREASURE_OBJECT_RUPEES_06
	.db  COLLECT_MODE_CHEST
	dwbe $04fb
	.dw  $0000

seasonsSlot_dryEyeglassLakeEastCave:
	dwbe TREASURE_OBJECT_HEART_PIECE_01
	.db  COLLECT_MODE_CHEST
	dwbe $05c0
	.dw  $0000

; ==============================================================================
; Natzu
; ==============================================================================

seasonsSlot_natzuRegionAcrossWater:
	dwbe TREASURE_OBJECT_RUPEES_05
	.db  COLLECT_MODE_CHEST
	dwbe $050e
	.dw  $0000

seasonsSlot_moblinKeep:
	dwbe TREASURE_OBJECT_HEART_PIECE_01
	.db  COLLECT_MODE_CHEST
	dwbe $005b
	.dw  $0000

; ==============================================================================
; Spool Swamp
; ==============================================================================

seasonsSlot_floodgateKeepersHouse:
	dwbe TREASURE_OBJECT_FLOODGATE_KEY_00
	.db  COLLECT_MODE_PICKUP_1HAND
	dwbe $03b5
	.dw  $0000

seasonsSlot_spoolSwampCave:
	dwbe TREASURE_OBJECT_SQUARE_JEWEL_00
	.db  COLLECT_MODE_CHEST
	dwbe $04fa
	.dw  $0000

; ==============================================================================
; Sunken City
; ==============================================================================

seasonsSlot_sunkenCitySummerCave:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $05b5
	.dw  $0000

seasonsSlot_masterDiversChallenge:
	dwbe TREASURE_OBJECT_MASTERS_PLAQUE_00
	.db  COLLECT_MODE_CHEST
	dwbe $05bc
	.dw  $0000

seasonsSlot_chestInMasterDiversCave:
	dwbe TREASURE_OBJECT_RUPEES_05
	.db  COLLECT_MODE_CHEST
	dwbe $05bd
	.dw  $0000

seasonsSlot_masterDiversReward:
	dwbe TREASURE_OBJECT_FLIPPERS_00
	.db  COLLECT_MODE_PICKUP_2HAND_NOFLAG
	dwbe $05bd
	.dw  seasonsSlotCallbackTable_masterDiversReward

; ==============================================================================
; Mount Cucco / Goron Mountain
; ==============================================================================

seasonsSlot_springBananaTree:
	dwbe TREASURE_OBJECT_SPRING_BANANA_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $000f
	.dw  $0000

seasonsSlot_mtCuccoPlatformCave:
	dwbe TREASURE_OBJECT_RING_11
	.db  COLLECT_MODE_FALL
	dwbe $05bb
	.dw  $0000

seasonsSlot_mtCuccoTalonsCave:
	dwbe TREASURE_OBJECT_RING_10
	.db  COLLECT_MODE_CHEST
	dwbe $05b6
	.dw  $0000

seasonsSlot_divingSpotOutsideD4:
	dwbe TREASURE_OBJECT_PYRAMID_JEWEL_00
	.db  COLLECT_MODE_PICKUP_NOANIM
	dwbe $07e5
	.dw  $0000

seasonsSlot_goronMountainAcrossPits:
	dwbe TREASURE_OBJECT_DRAGON_KEY_00
	.db  COLLECT_MODE_PICKUP_1HAND
	dwbe $001a
	.dw  $0000

seasonsSlot_chestInGoronMountain:
	dwbe TREASURE_OBJECT_RING_0b
	.db  COLLECT_MODE_CHEST
	dwbe $05c8
	.dw  $0000

; ==============================================================================
; Lost Woods / Tarm Ruins
; ==============================================================================

seasonsSlot_lostWoods:
	dwbe TREASURE_OBJECT_SWORD_00
	.db  COLLECT_MODE_PICKUP_1HAND
	dwbe $00c9
	.dw  $0000

seasonsSlot_tarmRuinsUnderTree:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $039b
	.dw  $0000

; ==============================================================================
; Subrosia
; ==============================================================================

seasonsSlot_subrosianDanceHall:
	dwbe TREASURE_OBJECT_BOOMERANG_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $0395
	.dw  $0000

seasonsSlot_templeOfSeasons:
	dwbe TREASURE_OBJECT_ROD_OF_SEASONS_01
	.db  $00
	dwbe $03ac
	.dw  $0000

seasonsSlot_towerOfWinter:
	dwbe TREASURE_OBJECT_ROD_OF_SEASONS_05
	.db  COLLECT_MODE_PICKUP_1HAND
	dwbe $05f2
	.dw  $0000

seasonsSlot_towerOfSummer:
	dwbe TREASURE_OBJECT_ROD_OF_SEASONS_03
	.db  COLLECT_MODE_PICKUP_1HAND
	dwbe $05f8
	.dw  $0000

seasonsSlot_towerOfAutumn:
	dwbe TREASURE_OBJECT_ROD_OF_SEASONS_04
	.db  COLLECT_MODE_PICKUP_1HAND
	dwbe $05fb
	.dw  $0000

seasonsSlot_towerOfSpring:
	dwbe TREASURE_OBJECT_ROD_OF_SEASONS_02
	.db  COLLECT_MODE_PICKUP_1HAND
	dwbe $05f5
	.dw  $0000

seasonsSlot_subrosiaSeaside:
	dwbe TREASURE_OBJECT_STAR_ORE_00
	.db  COLLECT_MODE_DIG
	dwbe $0166
	.dw  seasonsSlotCallbackTable_subrosiaSeaside

seasonsSlot_subrosiaMarket1stItem:
	dwbe TREASURE_OBJECT_RIBBON_00
	.db  $00
	dwbe $03a0
	.dw  seasonsSlotCallbackTable_subrosiaMarket1stItem

seasonsSlot_subrosiaMarket2ndItem:
	dwbe TREASURE_OBJECT_HEART_PIECE_03
	.db  $00
	dwbe $03a0
	.dw  seasonsSlotCallbackTable_subrosiaMarket2ndItem

seasonsSlot_subrosiaMarket5thItem:
	dwbe TREASURE_OBJECT_MEMBERS_CARD_00
	.db  $00
	dwbe $03a0
	.dw  seasonsSlotCallbackTable_subrosiaMarket5thItem

seasonsSlot_subrosiaOpenCave:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $04f1
	.dw  $0000

seasonsSlot_subrosiaLockedCave:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $05c6
	.dw  $0000

seasonsSlot_subrosianWildsChest:
	dwbe TREASURE_OBJECT_BLUE_ORE_00
	.db  COLLECT_MODE_CHEST
	dwbe $0141
	.dw  $0000

seasonsSlot_subrosiaVillageChest:
	dwbe TREASURE_OBJECT_RED_ORE_00
	.db  COLLECT_MODE_CHEST
	dwbe $0158
	.dw  $0000

seasonsSlot_greatFurnace:
	dwbe TREASURE_OBJECT_HARD_ORE_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $038e
	.dw  $0000

seasonsSlot_subrosianSmithy:
	dwbe TREASURE_OBJECT_SHIELD_01
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $0397
	.dw  $0000

; ==============================================================================
; D0
; ==============================================================================

seasonsSlot_d0KeyChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_00
	.db  COLLECT_MODE_CHEST
	dwbe $0403
	.dw  $0000

seasonsSlot_d0SwordChest:
	dwbe TREASURE_OBJECT_SWORD_00
	.db  $00
	dwbe $0406
	.dw  $0000

seasonsSlot_d0RupeeChest:
	dwbe TREASURE_OBJECT_RUPEES_04
	.db  COLLECT_MODE_CHEST
	dwbe $0405
	.dw  $0000

; ==============================================================================
; D1
; ==============================================================================

seasonsSlot_d1_stalfosDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_01
	.db  COLLECT_MODE_FALL
	dwbe $041b
	.dw  $0000

seasonsSlot_d1_stalfosChest:
	dwbe TREASURE_OBJECT_MAP_01
	.db  COLLECT_MODE_CHEST
	dwbe $0419
	.dw  $0000

seasonsSlot_d1_blockPushingRoom:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $040d
	.dw  $0000

seasonsSlot_d1_leverRoom:
	dwbe TREASURE_OBJECT_COMPASS_01
	.db  COLLECT_MODE_CHEST
	dwbe $040f
	.dw  $0000

seasonsSlot_d1_railwayChest:
	dwbe TREASURE_OBJECT_BOMBS_00
	.db  COLLECT_MODE_CHEST
	dwbe $0410
	.dw  $0000

seasonsSlot_d1_buttonChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_01
	.db  COLLECT_MODE_CHEST
	dwbe $0411
	.dw  $0000

seasonsSlot_d1_basement:
	dwbe TREASURE_OBJECT_SEED_SATCHEL_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $0609
	.dw  $0000

seasonsSlot_d1_goriyaChest:
	dwbe TREASURE_OBJECT_BOSS_KEY_01
	.db  COLLECT_MODE_CHEST
	dwbe $0414
	.dw  $0000

seasonsSlot_d1_floormasterRoom:
	dwbe TREASURE_OBJECT_RING_04
	.db  COLLECT_MODE_CHEST
	dwbe $0417
	.dw  $0000

seasonsSlot_d1_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $0412
	.dw  $0000

; ==============================================================================
; D2
; ==============================================================================

seasonsSlot_d2_leftFromEntrance:
	dwbe TREASURE_OBJECT_RUPEES_01
	.db  COLLECT_MODE_CHEST
	dwbe $0438
	.dw  $0000

seasonsSlot_d2_ropeDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_02
	.db  COLLECT_MODE_FALL
	dwbe $0434
	.dw  $0000

seasonsSlot_d2_ropeChest:
	dwbe TREASURE_OBJECT_COMPASS_02
	.db  COLLECT_MODE_CHEST
	dwbe $0436
	.dw  $0000

seasonsSlot_d2_moblinChest:
	dwbe TREASURE_OBJECT_BRACELET_00
	.db  COLLECT_MODE_CHEST
	dwbe $042a
	.dw  $0000

seasonsSlot_d2_potChest:
	dwbe TREASURE_OBJECT_MAP_02
	.db  COLLECT_MODE_CHEST
	dwbe $042b
	.dw  $0000

seasonsSlot_d2_bladeChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_02
	.db  COLLECT_MODE_CHEST
	dwbe $0431
	.dw  $0000

seasonsSlot_d2_spiralChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_02
	.db  COLLECT_MODE_CHEST
	dwbe $042d
	.dw  $0000

seasonsSlot_d2_rollerChest:
	dwbe TREASURE_OBJECT_RUPEES_02
	.db  COLLECT_MODE_CHEST
	dwbe $041f
	.dw  $0000

seasonsSlot_d2_terraceChest:
	dwbe TREASURE_OBJECT_BOSS_KEY_02
	.db  COLLECT_MODE_CHEST
	dwbe $0424
	.dw  $0000

seasonsSlot_d2_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $0429
	.dw  $0000

; ==============================================================================
; D3
; ==============================================================================

seasonsSlot_d3_rollerChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_03
	.db  COLLECT_MODE_CHEST
	dwbe $044c
	.dw  $0000

seasonsSlot_d3_moldormChest:
	dwbe TREASURE_OBJECT_BOMBS_00
	.db  COLLECT_MODE_CHEST
	dwbe $0454
	.dw  $0000

seasonsSlot_d3_bombedWallChest:
	dwbe TREASURE_OBJECT_MAP_03
	.db  COLLECT_MODE_CHEST
	dwbe $0451
	.dw  $0000

seasonsSlot_d3_mimicChest:
	dwbe TREASURE_OBJECT_FEATHER_00
	.db  COLLECT_MODE_CHEST
	dwbe $0450
	.dw  $0000

seasonsSlot_d3_trampolineChest:
	dwbe TREASURE_OBJECT_COMPASS_03
	.db  COLLECT_MODE_CHEST
	dwbe $044d
	.dw  $0000

seasonsSlot_d3_zolChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_03
	.db  COLLECT_MODE_CHEST
	dwbe $044f
	.dw  $0000

seasonsSlot_d3_waterRoom:
	dwbe TREASURE_OBJECT_RUPEES_04
	.db  COLLECT_MODE_CHEST
	dwbe $0441
	.dw  $0000

seasonsSlot_d3_quicksandTerrace:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $0444
	.dw  $0000

seasonsSlot_d3_giantBladeRoom:
	dwbe TREASURE_OBJECT_BOSS_KEY_03
	.db  COLLECT_MODE_CHEST
	dwbe $0446
	.dw  $0000

seasonsSlot_d3_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $0453
	.dw  $0000

; ==============================================================================
; D4
; ==============================================================================

seasonsSlot_d4_northOfEntrance:
	dwbe TREASURE_OBJECT_BOMBS_00
	.db  COLLECT_MODE_CHEST
	dwbe $047f
	.dw  $0000

seasonsSlot_d4_potPuzzle:
	dwbe TREASURE_OBJECT_SMALL_KEY_04
	.db  COLLECT_MODE_FALL
	dwbe $047b
	.dw  $0000

seasonsSlot_d4_mazeChest:
	dwbe TREASURE_OBJECT_MAP_04
	.db  COLLECT_MODE_CHEST
	dwbe $0469
	.dw  $0000

seasonsSlot_d4_darkRoom:
	dwbe TREASURE_OBJECT_SMALL_KEY_04
	.db  COLLECT_MODE_CHEST
	dwbe $046d
	.dw  $0000

seasonsSlot_d4_waterRingRoom:
	dwbe TREASURE_OBJECT_COMPASS_04
	.db  COLLECT_MODE_CHEST
	dwbe $0483
	.dw  $0000

seasonsSlot_d4_pool:
	dwbe TREASURE_OBJECT_SMALL_KEY_04
	.db  COLLECT_MODE_FALL
	dwbe $0475
	.dw  $0000

seasonsSlot_d4_terrace:
	dwbe TREASURE_OBJECT_SMALL_KEY_04
	.db  COLLECT_MODE_CHEST
	dwbe $0463
	.dw  $0000

seasonsSlot_d4_crackedFloorRoom:
	dwbe TREASURE_OBJECT_SLINGSHOT_00
	.db  COLLECT_MODE_CHEST
	dwbe $0473
	.dw  $0000

seasonsSlot_d4_torchChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_04
	.db  COLLECT_MODE_CHEST
	dwbe $0464
	.dw  $0000

seasonsSlot_d4_diveSpot:
	dwbe TREASURE_OBJECT_BOSS_KEY_04
	.db  COLLECT_MODE_DIVE
	dwbe $046c
	.dw  $0000

seasonsSlot_d4_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $045f
	.dw  $0000

; ==============================================================================
; D5
; ==============================================================================

seasonsSlot_d5_leftChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_05
	.db  COLLECT_MODE_CHEST
	dwbe $04a3
	.dw  $0000

seasonsSlot_d5_spiralChest:
	dwbe TREASURE_OBJECT_COMPASS_05
	.db  COLLECT_MODE_CHEST
	dwbe $049d
	.dw  $0000

seasonsSlot_d5_terraceChest:
	dwbe TREASURE_OBJECT_RUPEES_06
	.db  COLLECT_MODE_CHEST
	dwbe $0497
	.dw  $0000

seasonsSlot_d5_armosChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_05
	.db  COLLECT_MODE_CHEST
	dwbe $0491
	.dw  $0000

seasonsSlot_d5_spinnerChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_05
	.db  COLLECT_MODE_CHEST
	dwbe $049f
	.dw  $0000

seasonsSlot_d5_cartChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_05
	.db  COLLECT_MODE_CHEST
	dwbe $0499
	.dw  $0000

seasonsSlot_d5_stalfosChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_05
	.db  COLLECT_MODE_CHEST
	dwbe $04a5
	.dw  $0000

seasonsSlot_d5_gibdoZolChest:
	dwbe TREASURE_OBJECT_MAP_05
	.db  COLLECT_MODE_CHEST
	dwbe $048f
	.dw  $0000

seasonsSlot_d5_magnetBallChest:
	dwbe TREASURE_OBJECT_MAGNET_GLOVES_00
	.db  COLLECT_MODE_CHEST
	dwbe $0489
	.dw  $0000

seasonsSlot_d5_basement:
	dwbe TREASURE_OBJECT_BOSS_KEY_05
	.db  COLLECT_MODE_PICKUP_1HAND ; NOTE: Original "poofed" in, but that's not really right
	dwbe $068b
	.dw  $0000

seasonsSlot_d5_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $048c
	.dw  $0000

; ==============================================================================
; D6
; ==============================================================================

seasonsSlot_d6_1fEast:
	dwbe TREASURE_OBJECT_RUPEES_01
	.db  COLLECT_MODE_CHEST
	dwbe $04b3
	.dw  $0000

seasonsSlot_d6_1fTerrace:
	dwbe TREASURE_OBJECT_MAP_06
	.db  COLLECT_MODE_CHEST
	dwbe $04b0
	.dw  $0000

seasonsSlot_d6_crystalTrapRoom:
	dwbe TREASURE_OBJECT_RUPEES_02
	.db  COLLECT_MODE_CHEST
	dwbe $04af
	.dw  $0000

seasonsSlot_d6_magnetBallDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_06
	.db  COLLECT_MODE_FALL
	dwbe $04ab
	.dw  $0000

seasonsSlot_d6_beamosRoom:
	dwbe TREASURE_OBJECT_COMPASS_06
	.db  COLLECT_MODE_CHEST
	dwbe $04ad
	.dw  $0000

seasonsSlot_d6_2fGibdoChest:
	dwbe TREASURE_OBJECT_BOMBS_00
	.db  COLLECT_MODE_CHEST
	dwbe $04bf
	.dw  $0000

seasonsSlot_d6_2fArmosChest:
	dwbe TREASURE_OBJECT_RUPEES_01
	.db  COLLECT_MODE_CHEST
	dwbe $04c3
	.dw  $0000

seasonsSlot_d6_armosHall:
	dwbe TREASURE_OBJECT_BOOMERANG_00
	.db  COLLECT_MODE_CHEST
	dwbe $04d0
	.dw  $0000

seasonsSlot_d6_spinnerNorth:
	dwbe TREASURE_OBJECT_SMALL_KEY_06
	.db  COLLECT_MODE_CHEST
	dwbe $04c2
	.dw  $0000

seasonsSlot_d6_escapeRoom:
	dwbe TREASURE_OBJECT_BOSS_KEY_06
	.db  COLLECT_MODE_CHEST
	dwbe $04c4
	.dw  $0000

seasonsSlot_d6_vireChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_06
	.db  COLLECT_MODE_CHEST
	dwbe $04c1
	.dw  $0000

seasonsSlot_d6_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $04d5
	.dw  $0000

; ==============================================================================
; D7
; ==============================================================================

seasonsSlot_d7_bombedWallChest:
	dwbe TREASURE_OBJECT_COMPASS_07
	.db  COLLECT_MODE_CHEST
	dwbe $0552
	.dw  $0000

seasonsSlot_d7_wizzrobeChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_07
	.db  COLLECT_MODE_CHEST
	dwbe $0554
	.dw  $0000

seasonsSlot_d7_rightOfEntrance:
	dwbe TREASURE_OBJECT_RING_0e
	.db  COLLECT_MODE_CHEST
	dwbe $055a
	.dw  $0000

seasonsSlot_d7_zolButton:
	dwbe TREASURE_OBJECT_SMALL_KEY_07
	.db  COLLECT_MODE_FALL
	dwbe $0545
	.dw  $0000

seasonsSlot_d7_armosPuzzle:
	dwbe TREASURE_OBJECT_SMALL_KEY_07
	.db  COLLECT_MODE_FALL
	dwbe $0535
	.dw  $0000

seasonsSlot_d7_magunesuChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_07
	.db  COLLECT_MODE_CHEST
	dwbe $0547
	.dw  $0000

seasonsSlot_d7_quicksandChest:
	dwbe TREASURE_OBJECT_MAP_07
	.db  COLLECT_MODE_CHEST
	dwbe $0558
	.dw  $0000

seasonsSlot_d7_spikeChest:
	dwbe TREASURE_OBJECT_FEATHER_00
	.db  COLLECT_MODE_CHEST
	dwbe $0544
	.dw  $0000

seasonsSlot_d7_mazeChest:
	dwbe TREASURE_OBJECT_RUPEES_00
	.db  COLLECT_MODE_CHEST
	dwbe $0543
	.dw  $0000

seasonsSlot_d7_b2fDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_07
	.db  COLLECT_MODE_FALL
	dwbe $053d
	.dw  $0000

seasonsSlot_d7_stalfosChest:
	dwbe TREASURE_OBJECT_BOSS_KEY_07
	.db  COLLECT_MODE_CHEST
	dwbe $0548
	.dw  $0000

seasonsSlot_d7_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $0550
	.dw  $0000

; ==============================================================================
; D8
; ==============================================================================

seasonsSlot_d8_eyeDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_08
	.db  COLLECT_MODE_FALL
	dwbe $0582
	.dw  $0000

seasonsSlot_d8_threeEyesChest:
	dwbe TREASURE_OBJECT_RING_06
	.db  COLLECT_MODE_CHEST
	dwbe $057d
	.dw  $0000

seasonsSlot_d8_hardhatDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_08
	.db  COLLECT_MODE_FALL
	dwbe $0575
	.dw  $0000

seasonsSlot_d8_spikeRoom:
	dwbe TREASURE_OBJECT_COMPASS_08
	.db  COLLECT_MODE_CHEST
	dwbe $058b
	.dw  $0000

seasonsSlot_d8_armosChest:
	dwbe TREASURE_OBJECT_SLINGSHOT_00
	.db  COLLECT_MODE_CHEST
	dwbe $058d
	.dw  $0000

seasonsSlot_d8_magnetBallRoom:
	dwbe TREASURE_OBJECT_MAP_08
	.db  COLLECT_MODE_CHEST
	dwbe $058e
	.dw  $0000

seasonsSlot_d8_spinnerChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_08
	.db  COLLECT_MODE_CHEST
	dwbe $0570
	.dw  $0000

seasonsSlot_d8_darknutChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_08
	.db  COLLECT_MODE_CHEST
	dwbe $058c
	.dw  $0000

seasonsSlot_d8_polsVoiceChest:
	dwbe TREASURE_OBJECT_BOSS_KEY_08
	.db  COLLECT_MODE_CHEST
	dwbe $0580
	.dw  $0000

seasonsSlot_d8_ghostArmosDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_08
	.db  COLLECT_MODE_FALL
	dwbe $057f
	.dw  $0000

seasonsSlot_d8_seLavaChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_08
	.db  COLLECT_MODE_CHEST
	dwbe $056b
	.dw  $0000

seasonsSlot_d8_swLavaChest:
	dwbe TREASURE_OBJECT_BOMBS_00
	.db  COLLECT_MODE_CHEST
	dwbe $056a
	.dw  $0000

seasonsSlot_d8_sparkChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_08
	.db  COLLECT_MODE_CHEST
	dwbe $058a
	.dw  $0000

seasonsSlot_d8_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $0564
	.dw  $0000

; ==============================================================================
; Linked Hero's Cave (UNUSED for rando, but here to fix small keys; not complete)
; ==============================================================================

seasonsSlot_herosCave_holeRoomDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_0b
	.db  COLLECT_MODE_FALL
	dwbe $0532
	.dw  $0000

seasonsSlot_herosCave_torchChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_0b
	.db  COLLECT_MODE_CHEST
	dwbe $0529
	.dw  $0000

seasonsSlot_herosCave_waterRoomDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_0b
	.db  COLLECT_MODE_FALL
	dwbe $052a
	.dw  $0000

seasonsSlot_herosCave_enemyButtonRoom:
	dwbe TREASURE_OBJECT_SMALL_KEY_0b
	.db  COLLECT_MODE_FALL
	dwbe $0522
	.dw  $0000

seasonsSlot_herosCave_orbAcrossPits:
	dwbe TREASURE_OBJECT_SMALL_KEY_0b
	.db  COLLECT_MODE_FALL
	dwbe $0523
	.dw  $0000


slotsEnd:


.else ; ROM_AGES


slotsStart:

; ==============================================================================
; Forest of Time & Southern Shore
; ==============================================================================

agesSlot_startingItem:
	dwbe TREASURE_OBJECT_SWORD_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $0039
	.dw  $0000

agesSlot_nayrusHouse:
	dwbe TREASURE_OBJECT_TUNE_OF_ECHOES_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $03ae
	.dw  $0000

agesSlot_balloonGuysGift:
	dwbe TREASURE_OBJECT_ISLAND_CHART_00
	.db  COLLECT_MODE_PICKUP_2HAND_NOFLAG
	dwbe $0079
	.dw  agesSlotCallbackTable_balloonGuysGift

agesSlot_balloonGuysUpgrade:
	dwbe TREASURE_OBJECT_SEED_SATCHEL_00
	.db  COLLECT_MODE_PICKUP_2HAND_NOFLAG
	dwbe $0079
	.dw  agesSlotCallbackTable_balloonGuysUpgrade

agesSlot_southShoreDirt:
	dwbe TREASURE_OBJECT_RICKY_GLOVES_00
	.db  COLLECT_MODE_DIG
	dwbe $0098
	.dw  $0000

; ==============================================================================
; Lynna City / Village
; ==============================================================================

agesSlot_makuTree:
	dwbe TREASURE_OBJECT_SEED_SATCHEL_00
	.db  COLLECT_MODE_FALL
	dwbe $0038
	.dw  $0000

agesSlot_shop150Rupees:
	dwbe TREASURE_OBJECT_FLUTE_00
	.db  $00
	dwbe $025e
	.dw  agesSlotCallbackTable_shop150Rupees

agesSlot_mayorPlensHouse:
	dwbe TREASURE_OBJECT_RING_20
	.db  COLLECT_MODE_CHEST
	dwbe $03f9
	.dw  $0000

agesSlot_lynnaCityChest:
	dwbe TREASURE_OBJECT_RUPEES_04
	.db  COLLECT_MODE_CHEST
	dwbe $0049
	.dw  $0000

agesSlot_blackTowerWorker:
	dwbe TREASURE_OBJECT_SHOVEL_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $04e1
	.dw  $0000

; ==============================================================================
; Yoll Graveyard
; ==============================================================================

agesSlot_graveUnderTree:
	dwbe TREASURE_OBJECT_GRAVEYARD_KEY_00
	.db  COLLECT_MODE_FALL
	dwbe $05ed
	.dw  $0000

agesSlot_graveyardPoe:
	dwbe TREASURE_OBJECT_TRADEITEM_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $007c
	.dw  $0000

agesSlot_chevalsTest:
	dwbe TREASURE_OBJECT_FLIPPERS_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $05bf
	.dw  $0000

agesSlot_chevalsInvention:
	dwbe TREASURE_OBJECT_CHEVAL_ROPE_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $05b6
	.dw  $0000

; ==============================================================================
; Fairies' Woods & Deku Forest
; ==============================================================================

agesSlot_fairiesWoodsChest:
	dwbe TREASURE_OBJECT_RUPEES_05
	.db  COLLECT_MODE_CHEST
	dwbe $0084
	.dw  $0000

agesSlot_dekuForestSoldier:
	dwbe TREASURE_OBJECT_BOMBS_02
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $0181
	.dw  $0000

agesSlot_dekuForestCaveWest:
	dwbe TREASURE_OBJECT_RUPEES_04
	.db  COLLECT_MODE_CHEST
	dwbe $05b5
	.dw  $0000

agesSlot_dekuForestCaveEast:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $05b3
	.dw  $0000

; ==============================================================================
; Symmetry City, Nuun, Talus Peaks
; ==============================================================================

agesSlot_symmetryCityBrother:
	dwbe TREASURE_OBJECT_TUNI_NUT_00
	.db  COLLECT_MODE_PICKUP_2HAND_NOFLAG
	dwbe $036e
	.dw  agesSlotCallbackTable_symmetryCityBrother

agesSlot_nuunHighlandsCave:
	dwbe TREASURE_OBJECT_RING_19
	.db  COLLECT_MODE_CHEST
	dwbe $02f4
	.dw  $0000

agesSlot_tokkeysComposition:
	dwbe TREASURE_OBJECT_TUNE_OF_ECHOES_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $038f
	.dw  $0000

agesSlot_talusPeaksChest:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $0063
	.dw  $0000

; ==============================================================================
; Rolling Ridge West (D6 area)
; ==============================================================================

agesSlot_defeatGreatMoblin:
	dwbe TREASURE_OBJECT_BOMB_FLOWER_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $0009
	.dw  $0000

agesSlot_underMoblinKeep:
	dwbe TREASURE_OBJECT_RING_17
	.db  COLLECT_MODE_CHEST
	dwbe $02be
	.dw  $0000

agesSlot_ridgeBaseChest:
	dwbe TREASURE_OBJECT_RUPEES_05
	.db  COLLECT_MODE_CHEST
	dwbe $05b9
	.dw  $0000

agesSlot_goronsHidingPlace:
	dwbe TREASURE_OBJECT_RING_16
	.db  COLLECT_MODE_CHEST
	dwbe $05bd
	.dw  $0000

agesSlot_ridgeWestCave:
	dwbe TREASURE_OBJECT_RUPEES_04
	.db  COLLECT_MODE_CHEST
	dwbe $05c0
	.dw  $0000

agesSlot_goronElder:
	dwbe TREASURE_OBJECT_CROWN_KEY_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $05c3
	.dw  $0000

; ==============================================================================
; Rolling Ridge East (D6 area)
; ==============================================================================

agesSlot_ridgeNECavePresent:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $05ee
	.dw  $0000

agesSlot_bombGoronHead:
	dwbe TREASURE_OBJECT_RUPEES_06
	.db  COLLECT_MODE_CHEST
	dwbe $02fc
	.dw  $0000

agesSlot_poolInD6Entrance:
	dwbe TREASURE_OBJECT_RING_26
	.db  COLLECT_MODE_CHEST
	dwbe $030e
	.dw  $0000

agesSlot_ridgeBasePast:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $05e0
	.dw  $0000

agesSlot_ridgeDiamondsPast:
	dwbe TREASURE_OBJECT_RUPEES_05
	.db  COLLECT_MODE_CHEST
	dwbe $05e1
	.dw  $0000

agesSlot_firstGoronDance:
	dwbe TREASURE_OBJECT_BROTHER_EMBLEM_00
	.db  COLLECT_MODE_PICKUP_2HAND_NOFLAG
	dwbe $02ed
	.dw  agesSlotCallbackTable_firstGoronDance

agesSlot_goronDanceWithLetter:
	dwbe TREASURE_OBJECT_MERMAID_KEY_00
	.db  COLLECT_MODE_PICKUP_2HAND_NOFLAG
	dwbe $02ef
	.dw  agesSlotCallbackTable_goronDanceWithLetter

agesSlot_tradeRockBrisket:
	dwbe TREASURE_OBJECT_ROCK_BRISKET_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $02fd
	.dw  $0000

agesSlot_tradeGoronVase:
	dwbe TREASURE_OBJECT_GORONADE_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $02ff
	.dw  $0000

agesSlot_goronDiamondCave:
	dwbe TREASURE_OBJECT_BOMBS_00
	.db  COLLECT_MODE_CHEST
	dwbe $05dd
	.dw  $0000

agesSlot_tradeLavaJuice:
	dwbe TREASURE_OBJECT_GORON_LETTER_00
	.db  COLLECT_MODE_PICKUP_2HAND_NOFLAG
	dwbe $031f
	.dw  agesSlotCallbackTable_tradeLavaJuice

agesSlot_ridgeBushCave:
	dwbe TREASURE_OBJECT_RUPEES_06
	.db  COLLECT_MODE_CHEST
	dwbe $031f
	.dw  $0000

agesSlot_targetCarts1:
	dwbe TREASURE_OBJECT_ROCK_BRISKET_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $05d8
	.dw  $0000

agesSlot_targetCarts2:
	dwbe TREASURE_OBJECT_BOOMERANG_00
	.db  COLLECT_MODE_PICKUP_2HAND_NOFLAG
	dwbe $05d8
	.dw  agesSlotCallbackTable_targetCarts2

agesSlot_goronShootingGallery:
	dwbe TREASURE_OBJECT_LAVA_JUICE_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $03e7
	.dw  $0000

agesSlot_bigBangGame:
	dwbe TREASURE_OBJECT_OLD_MERMAID_KEY_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $033e
	.dw  $0000

; ==============================================================================
; Zora Seas Present
; ==============================================================================

agesSlot_fairiesCoastChest:
	dwbe TREASURE_OBJECT_RING_21
	.db  COLLECT_MODE_CHEST
	dwbe $0091
	.dw  $0000

agesSlot_kingZora:
	dwbe TREASURE_OBJECT_LIBRARY_KEY_00
	.db  COLLECT_MODE_PICKUP_2HAND_NOFLAG
	dwbe $05ab
	.dw  agesSlotCallbackTable_kingZora

agesSlot_zoraPalaceChest:
	dwbe TREASURE_OBJECT_RUPEES_08
	.db  COLLECT_MODE_CHEST
	dwbe $05ac
	.dw  $0000

agesSlot_zoraNWCave:
	dwbe TREASURE_OBJECT_RING_1a
	.db  COLLECT_MODE_CHEST
	dwbe $05c7
	.dw  $0000

agesSlot_zoraVillagePresent:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $02c0
	.dw  $0000

agesSlot_zoraSeasChest:
	dwbe TREASURE_OBJECT_RING_25
	.db  COLLECT_MODE_CHEST
	dwbe $00d5
	.dw  $0000

agesSlot_zorasReward:
	dwbe TREASURE_OBJECT_ZORA_SCALE_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $02a0
	.dw  $0000

agesSlot_libraryPresent:
	dwbe TREASURE_OBJECT_BOOK_OF_SEALS_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $05c8
	.dw  $0000

; ==============================================================================
; Zora Seas & Sea of Storms Past
; ==============================================================================

agesSlot_libraryPast:
	dwbe TREASURE_OBJECT_FAIRY_POWDER_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $05e4
	.dw $0000

agesSlot_seaOfStormsPast:
	dwbe TREASURE_OBJECT_RING_1e
	.db  COLLECT_MODE_CHEST
	dwbe $03ff
	.dw $0000

agesSlot_fishersIslandCave:
	dwbe TREASURE_OBJECT_RING_22
	.db  COLLECT_MODE_CHEST
	dwbe $024f
	.dw $0000

agesSlot_piratianCaptain:
	dwbe TREASURE_OBJECT_TOKAY_EYEBALL_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $05f8
	.dw $0000

; ==============================================================================
; Crescent Island & Sea of No Return
; ==============================================================================

agesSlot_seaOfNoReturn:
	dwbe TREASURE_OBJECT_RING_27
	.db  COLLECT_MODE_CHEST
	dwbe $016d
	.dw  $0000

agesSlot_wildTokayGame:
	dwbe TREASURE_OBJECT_SCENT_SEEDLING_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $02de
	.dw  $0000

agesSlot_tokayPotCave:
	dwbe TREASURE_OBJECT_RING_1b
	.db  COLLECT_MODE_CHEST
	dwbe $05f7
	.dw  $0000

agesSlot_tokayBombCave:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $02ce
	.dw  $0000

agesSlot_tokayCrystalCave:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $05ca
	.dw  $0000

agesSlot_hiddenTokayCave:
	dwbe TREASURE_OBJECT_SHIELD_01
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $05e9
	.dw  $0000

agesSlot_underCrescentIsland:
	dwbe TREASURE_OBJECT_HEART_PIECE_01
	.db  COLLECT_MODE_CHEST
	dwbe $03fd
	.dw  $0000

; ==============================================================================
; Ambi's Palace
; ==============================================================================

agesSlot_ambisPalaceChest:
	dwbe TREASURE_OBJECT_RING_1c
	.db  COLLECT_MODE_CHEST
	dwbe $05cb
	.dw  $0000

agesSlot_rescueNayru:
	dwbe TREASURE_OBJECT_TUNE_OF_ECHOES_00
	.db  COLLECT_MODE_PICKUP_2HAND_NOFLAG
	dwbe $0038
	.dw  agesSlotCallbackTable_rescueNayru

; ==============================================================================
; Maku Path
; ==============================================================================

agesSlot_d0_keyChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_0d
	.db  COLLECT_MODE_CHEST
	dwbe $0408
	.dw  $0000

agesSlot_d0_basement:
	dwbe TREASURE_OBJECT_RUPEES_0c
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $0605
	.dw  $0000

; ==============================================================================
; D1
; ==============================================================================

agesSlot_d1_oneButtonChest:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $0415
	.dw  $0000

agesSlot_d1_twoButtonChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_01
	.db  COLLECT_MODE_CHEST
	dwbe $0416
	.dw  $0000

agesSlot_d1_wideRoom:
	dwbe TREASURE_OBJECT_SMALL_KEY_01
	.db  COLLECT_MODE_CHEST
	dwbe $041a
	.dw  $0000

agesSlot_d1_crystalRoom:
	dwbe TREASURE_OBJECT_RING_0e
	.db  COLLECT_MODE_CHEST
	dwbe $041c
	.dw  $0000

agesSlot_d1_crossroads:
	dwbe TREASURE_OBJECT_COMPASS_01
	.db  COLLECT_MODE_CHEST
	dwbe $041d
	.dw  $0000

agesSlot_d1_westTerrace:
	dwbe TREASURE_OBJECT_RING_04
	.db  COLLECT_MODE_CHEST
	dwbe $041f
	.dw  $0000

agesSlot_d1_potChest:
	dwbe TREASURE_OBJECT_BOSS_KEY_01
	.db  COLLECT_MODE_CHEST
	dwbe $0423
	.dw  $0000

agesSlot_d1_eastTerrace:
	dwbe TREASURE_OBJECT_MAP_01
	.db  COLLECT_MODE_CHEST
	dwbe $0425
	.dw  $0000

agesSlot_d1_ghiniDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_01
	.db  COLLECT_MODE_FALL
	dwbe $041e
	.dw  $0000

agesSlot_d1_basement:
	dwbe TREASURE_OBJECT_BRACELET_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $0610
	.dw  $0000

agesSlot_d1_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $0413
	.dw  $0000

; ==============================================================================
; D2
; ==============================================================================

agesSlot_d2_basementChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_02
	.db  COLLECT_MODE_CHEST
	dwbe $0430
	.dw  $0000

agesSlot_d2_colorRoom:
	dwbe TREASURE_OBJECT_BOSS_KEY_02
	.db  COLLECT_MODE_CHEST
	dwbe $043e
	.dw  $0000

agesSlot_d2_bombedTerrace:
	dwbe TREASURE_OBJECT_MAP_02
	.db  COLLECT_MODE_CHEST
	dwbe $0440
	.dw  $0000

agesSlot_d2_moblinPlatform:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $0441
	.dw  $0000

agesSlot_d2_ropeRoom:
	dwbe TREASURE_OBJECT_COMPASS_02
	.db  COLLECT_MODE_CHEST
	dwbe $0445
	.dw  $0000

agesSlot_d2_ladderChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_02
	.db  COLLECT_MODE_CHEST
	dwbe $0448
	.dw  $0000

agesSlot_d2_basementDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_02
	.db  COLLECT_MODE_FALL
	dwbe $042e
	.dw  $0000

agesSlot_d2_moblinDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_02
	.db  COLLECT_MODE_FALL
	dwbe $0439
	.dw  $0000

agesSlot_d2_statuePuzzle:
	dwbe TREASURE_OBJECT_SMALL_KEY_02
	.db  COLLECT_MODE_FALL
	dwbe $0442
	.dw  $0000

agesSlot_d2_thwompShelf:
	dwbe TREASURE_OBJECT_RUPEES_0c
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $0627
	.dw  $0000

agesSlot_d2_thwompTunnel:
	dwbe TREASURE_OBJECT_FEATHER_00
	.db  COLLECT_MODE_PICKUP_2HAND
	dwbe $0628
	.dw  $0000

agesSlot_d2_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $062b
	.dw  $0000

; ==============================================================================
; D3
; ==============================================================================

agesSlot_d3_bridgeChest:
	dwbe TREASURE_OBJECT_RUPEES_03
	.db  COLLECT_MODE_CHEST
	dwbe $044e
	.dw  $0000

agesSlot_d3_b1fEast:
	dwbe TREASURE_OBJECT_BOSS_KEY_03
	.db  COLLECT_MODE_CHEST
	dwbe $0450
	.dw  $0000

agesSlot_d3_torchChest:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $0455
	.dw  $0000

agesSlot_d3_conveyorBeltRoom:
	dwbe TREASURE_OBJECT_COMPASS_03
	.db  COLLECT_MODE_CHEST
	dwbe $0456
	.dw  $0000

agesSlot_d3_mimicRoom:
	dwbe TREASURE_OBJECT_SHOOTER_00
	.db  COLLECT_MODE_CHEST
	dwbe $0458
	.dw  $0000

agesSlot_d3_bushBeetleRoom:
	dwbe TREASURE_OBJECT_RUPEES_04
	.db  COLLECT_MODE_CHEST
	dwbe $045c
	.dw  $0000

agesSlot_d3_crossroads:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $0460
	.dw  $0000

agesSlot_d3_polsVoiceChest:
	dwbe TREASURE_OBJECT_MAP_03
	.db  COLLECT_MODE_CHEST
	dwbe $0465
	.dw  $0000

agesSlot_d3_moldormDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_03
	.db  COLLECT_MODE_FALL
	dwbe $044b
	.dw  $0000

agesSlot_d3_armosDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_03
	.db  COLLECT_MODE_FALL
	dwbe $045e
	.dw  $0000

agesSlot_d3_statueDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_03
	.db  COLLECT_MODE_FALL
	dwbe $0461
	.dw  $0000

agesSlot_d3_sixBlockDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_03
	.db  COLLECT_MODE_FALL
	dwbe $0464
	.dw  $0000

agesSlot_d3_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $044a
	.dw  $0000

; ==============================================================================
; D4
; ==============================================================================

agesSlot_d4_largeFloorPuzzle:
	dwbe TREASURE_OBJECT_SMALL_KEY_04
	.db  COLLECT_MODE_CHEST
	dwbe $046f
	.dw  $0000

agesSlot_d4_secondCrystalSwitch:
	dwbe TREASURE_OBJECT_SMALL_KEY_04
	.db  COLLECT_MODE_CHEST
	dwbe $0474
	.dw  $0000

agesSlot_d4_lavaPotChest:
	dwbe TREASURE_OBJECT_BOSS_KEY_04
	.db  COLLECT_MODE_CHEST
	dwbe $047a
	.dw  $0000

agesSlot_d4_smallFloorPuzzle:
	dwbe TREASURE_OBJECT_SWITCH_HOOK_00
	.db  COLLECT_MODE_CHEST
	dwbe $0487
	.dw  $0000

agesSlot_d4_firstChest:
	dwbe TREASURE_OBJECT_COMPASS_04
	.db  COLLECT_MODE_CHEST
	dwbe $048b
	.dw  $0000

agesSlot_d4_minecartChest:
	dwbe TREASURE_OBJECT_MAP_04
	.db  COLLECT_MODE_CHEST
	dwbe $048f
	.dw  $0000

agesSlot_d4_cubeChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_04
	.db  COLLECT_MODE_CHEST
	dwbe $0490
	.dw  $0000

agesSlot_d4_firstCrystalSwitch:
	dwbe TREASURE_OBJECT_SMALL_KEY_04
	.db  COLLECT_MODE_CHEST
	dwbe $0492
	.dw  $0000

agesSlot_d4_colorTileDrop:
	dwbe TREASURE_OBJECT_SMALL_KEY_04
	.db  COLLECT_MODE_FALL
	dwbe $047b
	.dw  $0000

agesSlot_d4_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $046b
	.dw  $0000

; ==============================================================================
; D5
; ==============================================================================

agesSlot_d5_redPegChest:
	dwbe TREASURE_OBJECT_RUPEES_05
	.db  COLLECT_MODE_CHEST
	dwbe $0499
	.dw  $0000

agesSlot_d5_owlPuzzle:
	dwbe TREASURE_OBJECT_BOSS_KEY_05
	.db  COLLECT_MODE_CHEST
	dwbe $049b
	.dw  $0000

agesSlot_d5_twoStatuePuzzle:
	dwbe TREASURE_OBJECT_SMALL_KEY_05
	.db  COLLECT_MODE_CHEST
	dwbe $049e
	.dw  $0000

agesSlot_d5_likeLikeChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_05
	.db  COLLECT_MODE_CHEST
	dwbe $049f
	.dw  $0000

agesSlot_d5_darkRoom:
	dwbe TREASURE_OBJECT_SMALL_KEY_05
	.db  COLLECT_MODE_CHEST
	dwbe $04a3
	.dw  $0000

agesSlot_d5_sixStatuePuzzle:
	dwbe TREASURE_OBJECT_CANE_OF_SOMARIA_00
	.db  COLLECT_MODE_CHEST
	dwbe $04a5
	.dw  $0000

agesSlot_d5_diamondChest:
	dwbe TREASURE_OBJECT_COMPASS_05
	.db  COLLECT_MODE_CHEST
	dwbe $04ad
	.dw  $0000

agesSlot_d5_eyesChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_05
	.db  COLLECT_MODE_CHEST
	dwbe $04ba
	.dw  $0000

agesSlot_d5_threeStatuePuzzle:
	dwbe TREASURE_OBJECT_SMALL_KEY_05
	.db  COLLECT_MODE_CHEST
	dwbe $04bc
	.dw  $0000

agesSlot_d5_bluePegChest:
	dwbe TREASURE_OBJECT_MAP_05
	.db  COLLECT_MODE_CHEST
	dwbe $04be
	.dw  $0000

agesSlot_d5_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $04bf
	.dw  $0000

; ==============================================================================
; D6 Present
; ==============================================================================

agesSlot_d6_present_vireChest:
	dwbe TREASURE_OBJECT_FLIPPERS_00
	.db  COLLECT_MODE_CHEST
	dwbe $0513
	.dw  $0000

agesSlot_d6_present_spinnerChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_06
	.db  COLLECT_MODE_CHEST
	dwbe $0514
	.dw  $0000

agesSlot_d6_present_ropeChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_06
	.db  COLLECT_MODE_CHEST
	dwbe $051b
	.dw  $0000

agesSlot_d6_present_rngChest:
	dwbe TREASURE_OBJECT_BOSS_KEY_0c
	.db  COLLECT_MODE_CHEST
	dwbe $051c
	.dw  $0000

agesSlot_d6_present_diamondChest:
	dwbe TREASURE_OBJECT_MAP_06
	.db  COLLECT_MODE_CHEST
	dwbe $051d
	.dw  $0000

agesSlot_d6_present_beamosChest:
	dwbe TREASURE_OBJECT_RUPEES_02
	.db  COLLECT_MODE_CHEST
	dwbe $051f
	.dw  $0000

agesSlot_d6_present_cubeChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_06
	.db  COLLECT_MODE_CHEST
	dwbe $0521
	.dw  $0000

agesSlot_d6_present_channelChest:
	dwbe TREASURE_OBJECT_COMPASS_06
	.db  COLLECT_MODE_CHEST
	dwbe $0525
	.dw  $0000

; ==============================================================================
; D6 Past
; ==============================================================================

agesSlot_d6_past_diamondChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_0c
	.db  COLLECT_MODE_CHEST
	dwbe $052c
	.dw  $0000

agesSlot_d6_past_spearChest:
	dwbe TREASURE_OBJECT_RUPEES_04
	.db  COLLECT_MODE_CHEST
	dwbe $052e
	.dw  $0000

agesSlot_d6_past_ropeChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_0c
	.db  COLLECT_MODE_CHEST
	dwbe $0531
	.dw  $0000

agesSlot_d6_past_stalfosChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_0c
	.db  COLLECT_MODE_CHEST
	dwbe $053c
	.dw  $0000

agesSlot_d6_past_colorRoom:
	dwbe TREASURE_OBJECT_COMPASS_0c
	.db  COLLECT_MODE_CHEST
	dwbe $053f
	.dw  $0000

agesSlot_d6_past_poolChest:
	dwbe TREASURE_OBJECT_MAP_0c
	.db  COLLECT_MODE_CHEST
	dwbe $0541
	.dw  $0000

agesSlot_d6_past_wizzrobeChest:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $0545
	.dw  $0000

agesSlot_d6_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $0536
	.dw  $0000

; ==============================================================================
; D7
; ==============================================================================

agesSlot_d7_potIslandChest:
	dwbe TREASURE_OBJECT_RING_28
	.db  COLLECT_MODE_CHEST
	dwbe $054c
	.dw  $0000

agesSlot_d7_stairwayChest:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $054d
	.dw  $0000

agesSlot_d7_minibossChest:
	dwbe TREASURE_OBJECT_SWITCH_HOOK_00
	.db  COLLECT_MODE_CHEST
	dwbe $054e
	.dw  $0000

agesSlot_d7_caneDiamondPuzzle:
	dwbe TREASURE_OBJECT_SMALL_KEY_07
	.db  COLLECT_MODE_CHEST
	dwbe $0553
	.dw  $0000

agesSlot_d7_crabChest:
	dwbe TREASURE_OBJECT_COMPASS_07
	.db  COLLECT_MODE_CHEST
	dwbe $0554
	.dw  $0000

agesSlot_d7_leftWing:
	dwbe TREASURE_OBJECT_SMALL_KEY_07
	.db  COLLECT_MODE_CHEST
	dwbe $055f
	.dw  $0000

agesSlot_d7_rightWing:
	dwbe TREASURE_OBJECT_SMALL_KEY_07
	.db  COLLECT_MODE_CHEST
	dwbe $0564
	.dw  $0000

agesSlot_d7_spikeChest:
	dwbe TREASURE_OBJECT_MAP_07
	.db  COLLECT_MODE_CHEST
	dwbe $0565
	.dw  $0000

agesSlot_d7_hallwayChest:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $056a
	.dw  $0000

agesSlot_d7_postHallwayChest:
	dwbe TREASURE_OBJECT_BOSS_KEY_07
	.db  COLLECT_MODE_CHEST
	dwbe $056c
	.dw  $0000

agesSlot_d7_3fTerrace:
	dwbe TREASURE_OBJECT_SMALL_KEY_07
	.db  COLLECT_MODE_CHEST
	dwbe $0572
	.dw  $0000

agesSlot_d7_boxedChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_07
	.db  COLLECT_MODE_CHEST
	dwbe $0550
	.dw  $0000

agesSlot_d7_flowerRoom:
	dwbe TREASURE_OBJECT_SMALL_KEY_07
	.db  COLLECT_MODE_FALL
	dwbe $054b
	.dw  $0000

agesSlot_d7_diamondPuzzle:
	dwbe TREASURE_OBJECT_SMALL_KEY_07
	.db  COLLECT_MODE_FALL
	dwbe $0555
	.dw  $0000

agesSlot_d7_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $0562
	.dw  $0000

; ==============================================================================
; D8
; ==============================================================================

agesSlot_d8_b3fChest:
	dwbe TREASURE_OBJECT_BOSS_KEY_08
	.db  COLLECT_MODE_CHEST
	dwbe $0579
	.dw  $0000

agesSlot_d8_mazeChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_08
	.db  COLLECT_MODE_CHEST
	dwbe $057b
	.dw  $0000

agesSlot_d8_nwSlateChest:
	dwbe TREASURE_OBJECT_SLATE_00
	.db  COLLECT_MODE_CHEST
	dwbe $057c
	.dw  $0000

agesSlot_d8_neSlateChest:
	dwbe TREASURE_OBJECT_SLATE_00
	.db  COLLECT_MODE_CHEST
	dwbe $057e
	.dw  $0000

agesSlot_d8_ghiniChest:
	dwbe TREASURE_OBJECT_MAP_08
	.db  COLLECT_MODE_CHEST
	dwbe $0585
	.dw  $0000

agesSlot_d8_seSlateChest:
	dwbe TREASURE_OBJECT_SLATE_00
	.db  COLLECT_MODE_CHEST
	dwbe $0592
	.dw  $0000

agesSlot_d8_swSlateChest:
	dwbe TREASURE_OBJECT_SLATE_00
	.db  COLLECT_MODE_CHEST
	dwbe $0594
	.dw  $0000

agesSlot_d8_b1fNwChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_08
	.db  COLLECT_MODE_CHEST
	dwbe $0597
	.dw  $0000

agesSlot_d8_sarcophagusChest:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $059f
	.dw  $0000

agesSlot_d8_bladeTrapChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_08
	.db  COLLECT_MODE_CHEST
	dwbe $05a3
	.dw  $0000

agesSlot_d8_bluePegChest:
	dwbe TREASURE_OBJECT_COMPASS_08
	.db  COLLECT_MODE_CHEST
	dwbe $05a4
	.dw  $0000

agesSlot_d8_1fChest:
	dwbe TREASURE_OBJECT_SMALL_KEY_08
	.db  COLLECT_MODE_CHEST
	dwbe $05a7
	.dw  $0000

agesSlot_d8_floorPuzzle:
	dwbe TREASURE_OBJECT_BRACELET_00
	.db  COLLECT_MODE_CHEST
	dwbe $05a6
	.dw  $0000

agesSlot_d8_tileRoom:
	dwbe TREASURE_OBJECT_GASHA_SEED_01
	.db  COLLECT_MODE_CHEST
	dwbe $0591
	.dw  $0000

agesSlot_d8_stalfos:
	dwbe TREASURE_OBJECT_SMALL_KEY_08
	.db  COLLECT_MODE_PICKUP_1HAND
	dwbe $0598
	.dw  $0000

agesSlot_d8_boss:
	dwbe TREASURE_OBJECT_HEART_CONTAINER_00
	.db  COLLECT_MODE_POOF
	dwbe $0578
	.dw  $0000


slotsEnd:

.endif
