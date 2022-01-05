 m_section_free chestData NAMESPACE chestData

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
	m_ChestData $49, $51, TREASURE_OBJECT_RUPEES_04
	m_ChestDataRando $51, $49, rando.agesSlot_lynnaCityChest
	m_ChestDataRando $36, $84, rando.agesSlot_fairiesWoodsChest
	m_ChestDataRando $35, $91, rando.agesSlot_fairiesCoastChest
	m_ChestData $25, $d4, TREASURE_OBJECT_RING_23
	m_ChestDataRando $25, $d5, rando.agesSlot_zoraSeasChest
	m_ChestDataRando $12, $63, rando.agesSlot_talusPeaksChest
	.db $ff

chestGroup1Data:
	m_ChestDataRando $43, $6d, rando.agesSlot_seaOfNoReturn
	.db $ff

chestGroup2Data:
	m_ChestData $14, $f7, TREASURE_OBJECT_RING_11
	m_ChestData $16, $f7, TREASURE_OBJECT_GASHA_SEED_01
	m_ChestDataRando $45, $be, rando.agesSlot_underMoblinKeep
	m_ChestDataRando $22, $fc, rando.agesSlot_bombGoronHead
	m_ChestDataRando $15, $ce, rando.agesSlot_tokayBombCave
	m_ChestDataRando $34, $ec, rando.agesSlot_nuunHighlandsCave
	m_ChestDataRando $34, $f4, rando.agesSlot_nuunHighlandsCave
	m_ChestDataRando $18, $4f, rando.agesSlot_fishersIslandCave
	m_ChestDataRando $14, $c0, rando.agesSlot_zoraVillagePresent
	.db $ff

chestGroup3Data:
	m_ChestDataRando $24, $0e, rando.agesSlot_poolInD6Entrance
	m_ChestDataRando $18, $1f, rando.agesSlot_ridgeBushCave
	m_ChestData $35, $e8, TREASURE_OBJECT_NONE_00
	m_ChestDataRando $35, $ff, rando.agesSlot_seaOfStormsPast
	m_ChestDataRando $18, $f9, rando.agesSlot_mayorPlensHouse
	m_ChestDataRando $34, $fd, rando.agesSlot_underCrescentIsland
	.db $ff

chestGroup4Data:
	m_ChestDataRando $57, $08, rando.agesSlot_d0_keyChest
	m_ChestDataRando $5a, $15, rando.agesSlot_d1_oneButtonChest
	m_ChestDataRando $17, $16, rando.agesSlot_d1_twoButtonChest
	m_ChestDataRando $2c, $1a, rando.agesSlot_d1_wideRoom
	m_ChestDataRando $59, $1c, rando.agesSlot_d1_crystalRoom
	m_ChestDataRando $53, $1d, rando.agesSlot_d1_crossroads
	m_ChestDataRando $73, $1f, rando.agesSlot_d1_westTerrace
	m_ChestDataRando $16, $23, rando.agesSlot_d1_potChest
	m_ChestDataRando $12, $25, rando.agesSlot_d1_eastTerrace
	m_ChestDataRando $57, $30, rando.agesSlot_d2_basementChest
	m_ChestDataRando $58, $3e, rando.agesSlot_d2_colorRoom
	m_ChestDataRando $87, $40, rando.agesSlot_d2_bombedTerrace
	m_ChestDataRando $59, $41, rando.agesSlot_d2_moblinPlatform
	m_ChestDataRando $1d, $45, rando.agesSlot_d2_ropeRoom
	m_ChestDataRando $57, $48, rando.agesSlot_d2_ladderChest
	m_ChestDataRando $8c, $4e, rando.agesSlot_d3_bridgeChest
	m_ChestDataRando $28, $50, rando.agesSlot_d3_b1fEast
	m_ChestDataRando $4c, $55, rando.agesSlot_d3_torchChest
	m_ChestDataRando $69, $56, rando.agesSlot_d3_conveyorBeltRoom
	m_ChestDataRando $59, $58, rando.agesSlot_d3_mimicRoom
	m_ChestDataRando $27, $5c, rando.agesSlot_d3_bushBeetleRoom
	m_ChestDataRando $57, $60, rando.agesSlot_d3_crossroads
	m_ChestDataRando $58, $65, rando.agesSlot_d3_polsVoiceChest
	m_ChestDataRando $67, $6f, rando.agesSlot_d4_largeFloorPuzzle
	m_ChestDataRando $54, $74, rando.agesSlot_d4_secondCrystalSwitch
	m_ChestDataRando $39, $7a, rando.agesSlot_d4_lavaPotChest
	m_ChestDataRando $65, $87, rando.agesSlot_d4_smallFloorPuzzle
	m_ChestDataRando $41, $8b, rando.agesSlot_d4_firstChest
	m_ChestDataRando $57, $8f, rando.agesSlot_d4_minecartChest
	m_ChestDataRando $84, $90, rando.agesSlot_d4_cubeChest
	m_ChestDataRando $62, $92, rando.agesSlot_d4_firstCrystalSwitch
	m_ChestDataRando $19, $99, rando.agesSlot_d5_redPegChest
	m_ChestDataRando $54, $9b, rando.agesSlot_d5_owlPuzzle
	m_ChestDataRando $47, $9e, rando.agesSlot_d5_twoStatuePuzzle
	m_ChestDataRando $57, $9f, rando.agesSlot_d5_likeLikeChest
	m_ChestDataRando $57, $a3, rando.agesSlot_d5_darkRoom
	m_ChestDataRando $53, $a5, rando.agesSlot_d5_sixStatuePuzzle
	m_ChestDataRando $8b, $ad, rando.agesSlot_d5_diamondChest
	m_ChestDataRando $57, $ba, rando.agesSlot_d5_eyesChest
	m_ChestDataRando $57, $bc, rando.agesSlot_d5_threeStatuePuzzle
	m_ChestDataRando $17, $be, rando.agesSlot_d5_bluePegChest
	m_ChestData $47, $c1, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $27, $c3, TREASURE_OBJECT_GASHA_SEED_01
	m_ChestData $47, $c4, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $27, $c5, TREASURE_OBJECT_RING_1f
	m_ChestData $47, $c6, TREASURE_OBJECT_GASHA_SEED_01
	m_ChestData $8b, $c7, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $47, $c8, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $8c, $c9, TREASURE_OBJECT_GASHA_SEED_01
	m_ChestData $3b, $ca, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $47, $cb, TREASURE_OBJECT_SMALL_KEY_03
	m_ChestData $66, $cc, TREASURE_OBJECT_RUPEES_08
	m_ChestData $57, $cf, TREASURE_OBJECT_SMALL_KEY_03
	.db $ff

chestGroup5Data:
	m_ChestDataRando $17, $13, rando.agesSlot_d6_present_vireChest
	m_ChestDataRando $25, $14, rando.agesSlot_d6_present_spinnerChest
	m_ChestDataRando $53, $1b, rando.agesSlot_d6_present_ropeChest
	m_ChestDataRando $17, $1c, rando.agesSlot_d6_present_rngChest
	m_ChestDataRando $13, $1d, rando.agesSlot_d6_present_diamondChest
	m_ChestDataRando $13, $1f, rando.agesSlot_d6_present_beamosChest
	m_ChestDataRando $67, $21, rando.agesSlot_d6_present_cubeChest
	m_ChestDataRando $3d, $25, rando.agesSlot_d6_present_channelChest
	m_ChestDataRando $57, $2c, rando.agesSlot_d6_past_diamondChest
	m_ChestDataRando $24, $2e, rando.agesSlot_d6_past_spearChest
	m_ChestDataRando $57, $31, rando.agesSlot_d6_past_ropeChest
	m_ChestDataRando $55, $3c, rando.agesSlot_d6_past_stalfosChest
	m_ChestDataRando $53, $3f, rando.agesSlot_d6_past_colorRoom
	m_ChestDataRando $52, $41, rando.agesSlot_d6_past_poolChest
	m_ChestDataRando $57, $45, rando.agesSlot_d6_past_wizzrobeChest
	m_ChestDataRando $31, $4c, rando.agesSlot_d7_potIslandChest
	m_ChestDataRando $18, $4d, rando.agesSlot_d7_stairwayChest
	m_ChestDataRando $12, $4e, rando.agesSlot_d7_minibossChest
	m_ChestDataRando $28, $53, rando.agesSlot_d7_caneDiamondPuzzle
	m_ChestDataRando $47, $54, rando.agesSlot_d7_crabChest
	m_ChestDataRando $56, $5f, rando.agesSlot_d7_leftWing
	m_ChestDataRando $57, $64, rando.agesSlot_d7_rightWing
	m_ChestDataRando $42, $65, rando.agesSlot_d7_spikeChest
	m_ChestDataRando $27, $6a, rando.agesSlot_d7_hallwayChest
	m_ChestDataRando $57, $6c, rando.agesSlot_d7_postHallwayChest
	m_ChestDataRando $6c, $72, rando.agesSlot_d7_3fTerrace
	m_ChestDataRando $57, $50, rando.agesSlot_d7_boxedChest
	m_ChestDataRando $12, $79, rando.agesSlot_d8_b3fChest
	m_ChestDataRando $16, $7b, rando.agesSlot_d8_mazeChest
	m_ChestDataRando $27, $7c, rando.agesSlot_d8_nwSlateChest
	m_ChestDataRando $27, $7e, rando.agesSlot_d8_neSlateChest
	m_ChestDataRando $1b, $85, rando.agesSlot_d8_ghiniChest
	m_ChestDataRando $27, $92, rando.agesSlot_d8_seSlateChest
	m_ChestDataRando $25, $94, rando.agesSlot_d8_swSlateChest
	m_ChestDataRando $16, $97, rando.agesSlot_d8_b1fNwChest
	m_ChestDataRando $2c, $9f, rando.agesSlot_d8_sarcophagusChest
	m_ChestDataRando $1d, $a3, rando.agesSlot_d8_bladeTrapChest
	m_ChestDataRando $1a, $a4, rando.agesSlot_d8_bluePegChest
	m_ChestDataRando $6d, $a7, rando.agesSlot_d8_1fChest
	m_ChestDataRando $37, $a6, rando.agesSlot_d8_floorPuzzle
	m_ChestDataRando $27, $91, rando.agesSlot_d8_tileRoom
	m_ChestDataRando $15, $b5, rando.agesSlot_dekuForestCaveWest
	m_ChestDataRando $74, $bd, rando.agesSlot_goronsHidingPlace
	m_ChestDataRando $47, $b9, rando.agesSlot_ridgeBaseChest
	m_ChestDataRando $15, $ee, rando.agesSlot_ridgeNECavePresent
	m_ChestDataRando $15, $dd, rando.agesSlot_goronDiamondCave
	m_ChestDataRando $81, $c0, rando.agesSlot_ridgeWestCave
	m_ChestData $24, $c0, TREASURE_OBJECT_RUPEES_04
	m_ChestDataRando $83, $e1, rando.agesSlot_ridgeDiamondsPast
	m_ChestDataRando $22, $e0, rando.agesSlot_ridgeBasePast
	m_ChestDataRando $47, $b3, rando.agesSlot_dekuForestCaveEast
	m_ChestDataRando $57, $cb, rando.agesSlot_ambisPalaceChest
	m_ChestDataRando $43, $c7, rando.agesSlot_zoraNWCave
	m_ChestDataRando $12, $ca, rando.agesSlot_tokayCrystalCave
	m_ChestDataRando $22, $b8, rando.agesSlot_nuunHighlandsCave
	m_ChestDataRando $14, $ac, rando.agesSlot_zoraPalaceChest
	m_ChestDataRando $12, $f7, rando.agesSlot_tokayPotCave
chestGroup6Data:
chestGroup7Data:
	.db $ff

.ends
