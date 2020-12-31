 m_section_free "chestData" NAMESPACE chestData

; m_ChestData macro takes 3 parameters:
;   1: Y/X position of chest (byte); an opened chest tile will be placed here when the room is
;      loaded, if ROOMFLAG_ITEM has been set in that room.
;   2: Low byte of room index
;   3: Treasure object to get from the chest (see "data/{game}/treasureObjectData.s")
.macro m_ChestData
	.IF \1 == $ff
		; $ff is the "end of data" marker so we can't have that
		.PRINTT "ERROR: Chest Y/X position can't be $ff!\n"
		.FAIL
	.ENDIF
	.db \1 \2
	dwbe \3
.endm


; RANDO: Chest whose contents refer to an item slot
.macro m_ChestDataRando
	.db \1 \2
	dwbe \3 | $8000
.endm


chestDataGroupTable:
	.dw chestGroup0Data
	.dw chestGroup1Data
	.dw chestGroup2Data
	.dw chestGroup3Data
	.dw chestGroup4Data
	.dw chestGroup5Data
	.dw chestGroup6Data
	.dw chestGroup7Data

chestGroup0Data:
	m_ChestDataRando $11, $f5, rando.seasonsSlot_horonVillageSWChest
	m_ChestDataRando $58, $f9, rando.seasonsSlot_horonVillageSEChest
	m_ChestDataRando $11, $8e, rando.seasonsSlot_chestOnTopOfD2
	m_ChestDataRando $45, $f4, rando.seasonsSlot_blackBeastsChest
	m_ChestDataRando $15, $5b, rando.seasonsSlot_moblinKeep
	m_ChestDataRando $33, $b8, rando.seasonsSlot_eyeglassLakeAcrossBridge
	m_ChestDataRando $11, $e3, rando.seasonsSlot_westernCoastBeachChest
	m_ChestDataRando $18, $ff, rando.seasonsSlot_samasaDesertChest
	.db $ff

chestGroup1Data:
	m_ChestData $11, $41, TREASURE_OBJECT_BLUE_ORE_00
	m_ChestData $22, $58, TREASURE_OBJECT_RED_ORE_00
	.db $ff

chestGroup2Data:
chestGroup3Data:
	m_ChestData $34, $9b, TREASURE_OBJECT_GASHA_SEED_01
	m_ChestDataRando $13, $88, rando.seasonsSlot_westernCoastInHouse
	.db $ff

chestGroup4Data:
	m_ChestDataRando $5b, $03, rando.seasonsSlot_d0KeyChest
	m_ChestDataRando $5d, $05, rando.seasonsSlot_d0RupeeChest
	m_ChestData $27, $06, TREASURE_OBJECT_SWORD_00
	m_ChestDataRando $11, $0d, rando.seasonsSlot_d1_blockPushingRoom
	m_ChestDataRando $3b, $0f, rando.seasonsSlot_d1_leverRoom
	m_ChestDataRando, $67, $10, rando.seasonsSlot_d1_railwayChest
	m_ChestDataRando $2c, $11, rando.seasonsSlot_d1_buttonChest
	m_ChestDataRando $57, $14, rando.seasonsSlot_d1_goriyaChest
	m_ChestDataRando $23, $17, rando.seasonsSlot_d1_floormasterRoom
	m_ChestDataRando $57, $19, rando.seasonsSlot_d1_stalfosChest
	m_ChestDataRando $7b, $1f, rando.seasonsSlot_d2_rollerChest
	m_ChestDataRando $6d, $24, rando.seasonsSlot_d2_terraceChest
	m_ChestDataRando $5b, $2a, rando.seasonsSlot_d2_moblinChest
	m_ChestDataRando $27, $2b, rando.seasonsSlot_d2_potChest
	m_ChestDataRando $57, $2d, rando.seasonsSlot_d2_spiralChest
	m_ChestDataRando $44, $31, rando.seasonsSlot_d2_bladeChest
	m_ChestDataRando $57, $36, rando.seasonsSlot_d2_ropeChest
	m_ChestDataRando $42, $38, rando.seasonsSlot_d2_leftFromEntrance
	m_ChestDataRando $18, $41, rando.seasonsSlot_d3_waterRoom
	m_ChestDataRando $28, $46, rando.seasonsSlot_d3_giantBladeRoom
	m_ChestDataRando $86, $44, rando.seasonsSlot_d3_quicksandTerrace
	m_ChestDataRando $68, $4c, rando.seasonsSlot_d3_rollerChest
	m_ChestDataRando $57, $4d, rando.seasonsSlot_d3_trampolineChest
	m_ChestDataRando $29, $4f, rando.seasonsSlot_d3_zolChest
	m_ChestDataRando $54, $51, rando.seasonsSlot_d3_bombedWallChest
	m_ChestDataRando $57, $50, rando.seasonsSlot_d3_mimicChest
	m_ChestDataRando $55, $54, rando.seasonsSlot_d3_moldormChest
	m_ChestDataRando $22, $63, rando.seasonsSlot_d4_terrace
	m_ChestDataRando $95, $64, rando.seasonsSlot_d4_torchChest
	m_ChestDataRando $54, $69, rando.seasonsSlot_d4_mazeChest
	m_ChestDataRando $59, $6d, rando.seasonsSlot_d4_darkRoom
	m_ChestDataRando $2c, $73, rando.seasonsSlot_d4_crackedFloorRoom
	m_ChestDataRando $88, $7f, rando.seasonsSlot_d4_northOfEntrance
	m_ChestDataRando $57, $83, rando.seasonsSlot_d4_waterRingRoom
	m_ChestDataRando $57, $8f, rando.seasonsSlot_d5_gibdoZolChest
	m_ChestDataRando $25, $89, rando.seasonsSlot_d5_magnetBallChest
	m_ChestDataRando $11, $97, rando.seasonsSlot_d5_terraceChest
	m_ChestDataRando $46, $99, rando.seasonsSlot_d5_cartChest
	m_ChestDataRando $57, $9d, rando.seasonsSlot_d5_spiralChest
	m_ChestDataRando $42, $9f, rando.seasonsSlot_d5_spinnerChest
	m_ChestDataRando $34, $a3, rando.seasonsSlot_d5_leftChest
	m_ChestDataRando $7b, $a5, rando.seasonsSlot_d5_stalfosChest
	m_ChestData $11, $ad, TREASURE_OBJECT_COMPASS_02
	m_ChestData $1d, $af, TREASURE_OBJECT_RUPEES_02
	m_ChestData $71, $b0, TREASURE_OBJECT_MAP_02
	m_ChestData $5c, $b3, TREASURE_OBJECT_RUPEES_01
	m_ChestData $53, $bf, TREASURE_OBJECT_BOMBS_00
	m_ChestData $75, $c1, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $21, $c2, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $57, $c3, TREASURE_OBJECT_RUPEES_01
	m_ChestData $66, $c4, TREASURE_OBJECT_BOSS_KEY_03
	m_ChestData $5d, $d0, TREASURE_OBJECT_BOOMERANG_00
	m_ChestDataRando $57, $e0, rando.seasonsSlot_caveSouthOfMrsRuul
	m_ChestDataRando $25, $e1, rando.seasonsSlot_caveNorthOfD1
	m_ChestDataRando $7d, $f7, rando.seasonsSlot_easternSuburbsOnCliff
	m_ChestDataRando $57, $fa, rando.seasonsSlot_spoolSwampCave
	m_ChestDataRando $57, $fb, rando.seasonsSlot_dryEyeglassLakeWestCave
	m_ChestData $57, $f1, TREASURE_OBJECT_GASHA_SEED_01
	.db $ff

chestGroup5Data:
	m_ChestData $87, $43, TREASURE_OBJECT_RUPEES_00
	m_ChestData $47, $44, TREASURE_OBJECT_FEATHER_00
	m_ChestData $61, $47, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $57, $48, TREASURE_OBJECT_BOSS_KEY_03
	m_ChestData $3b, $52, TREASURE_OBJECT_COMPASS_02
	m_ChestData $46, $54, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $57, $58, TREASURE_OBJECT_MAP_02
	m_ChestData $2b, $5a, TREASURE_OBJECT_RING_0e
	m_ChestData $75, $6a, TREASURE_OBJECT_BOMBS_00
	m_ChestData $5c, $6b, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $74, $70, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $47, $7d, TREASURE_OBJECT_RING_06
	m_ChestData $43, $80, TREASURE_OBJECT_BOSS_KEY_03
	m_ChestData $73, $8a, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $3b, $8b, TREASURE_OBJECT_COMPASS_02
	m_ChestData $33, $8c, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $34, $8d, TREASURE_OBJECT_SLINGSHOT_00
	m_ChestData $87, $8e, TREASURE_OBJECT_MAP_02
	m_ChestData $11, $2c, TREASURE_OBJECT_RUPEES_03
	m_ChestData $6c, $31, TREASURE_OBJECT_GASHA_SEED_01
	m_ChestData $77, $2f, TREASURE_OBJECT_GASHA_SEED_01
	m_ChestData $62, $29, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $1d, $28, TREASURE_OBJECT_GASHA_SEED_01
	m_ChestData $38, $24, TREASURE_OBJECT_GASHA_SEED_01
	m_ChestData $27, $34, TREASURE_OBJECT_RING_0f
	m_ChestDataRando $19, $b3, rando.seasonsSlot_caveOutsideD2
	m_ChestDataRando $2b, $b4, rando.seasonsSlot_woodsOfWinter1stCave
	m_ChestDataRando $16, $b5, rando.seasonsSlot_sunkenCitySummerCave
	m_ChestDataRando $1c, $bc, rando.seasonsSlot_masterDiversChallenge
	m_ChestDataRando $22, $bd, rando.seasonsSlot_chestInMasterDiversCave
	m_ChestDataRando $45, $c0, rando.seasonsSlot_dryEyeglassLakeEastCave
	m_ChestData $47, $c6, TREASURE_OBJECT_GASHA_SEED_01
	m_ChestDataRando $1d, $c8, rando.seasonsSlot_chestInGoronMountain
	m_ChestDataRando $4a, $b6, rando.seasonsSlot_mtCuccoTalonsCave
	m_ChestDataRando $5c, $0e, rando.seasonsSlot_natzuRegionAcrossWater
	m_ChestDataRando $32, $12, rando.seasonsSlot_woodsOfWinter2ndCave
chestGroup6Data:
chestGroup7Data:
	.db $ff

.ends
