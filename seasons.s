; Main file for Oracle of Seasons, US version

.include "include/constants.s"
.include "include/rominfo.s"
.include "include/emptyfill.s"
.include "include/structs.s"
.include "include/wram.s"
.include "include/hram.s"
.include "include/macros.s"
.include "include/script_commands.s"
.include "include/simplescript_commands.s"
.include "include/movementscript_commands.s"

.include "objects/macros.s"
.include "include/gfxDataMacros.s"
.include "include/musicMacros.s"

.include {"{BUILD_DIR}/textDefines.s"}


.BANK $00 SLOT 0
.ORG 0

	.include "code/bank0.s"


.BANK $01 SLOT 1
.ORG 0

	.include "code/bank1.s"


.BANK $02 SLOT 1
.ORG 0

	.include "code/bank2.s"


.BANK $03 SLOT 1
.ORG 0

	.include "code/bank3.s"

	; Note: There appears to be exactly one function call (in seasons) that performs a call from
	; this section to code in the "bank3.s" include above. For this reason we can't make this
	; section "superfree".
	 m_section_free Bank_3_Cutscenes NAMESPACE bank3Cutscenes
		.include "code/bank3Cutscenes.s"
		.include "code/seasons/cutscenes/endgameCutscenes.s"
		.include "code/seasons/cutscenes/pirateShipDeparting.s"
		.include "code/seasons/cutscenes/volcanoErupting.s"
		.include "code/seasons/cutscenes/linkedGameCutscenes.s"
		.include "code/seasons/cutscenes/introCutscenes.s"
	.ends


.BANK $04 SLOT 1
.ORG 0

	.include "code/bank4.s"

	 m_section_superfree RoomPacksAndMusicAssignments NAMESPACE bank4Data1
		; These 2 includes must be in the same bank
		.include {"{GAME_DATA_DIR}/roomPacks.s"}
		.include {"{GAME_DATA_DIR}/musicAssignments.s"}
	.ends

	 m_section_superfree RoomLayouts NAMESPACE roomLayouts
		.include {"{GAME_DATA_DIR}/roomLayoutGroupTable.s"}
	.ends

	; Must be in the same bank as "Tileset_Loading_2".
	 m_section_free Tileset_Loading_1 NAMESPACE tilesets
		.include {"{GAME_DATA_DIR}/tilesets.s"}
		.include {"{GAME_DATA_DIR}/tilesetAssignments.s"}
	.ends

	 m_section_free animationAndUniqueGfxData NAMESPACE animationAndUniqueGfxData
		.include "code/animations.s"

		.include {"{GAME_DATA_DIR}/uniqueGfxHeaders.s"}
		.include {"{GAME_DATA_DIR}/uniqueGfxHeaderPointers.s"}
		.include {"{GAME_DATA_DIR}/animationGroups.s"}
		.include {"{GAME_DATA_DIR}/animationGfxHeaders.s"}
		.include {"{GAME_DATA_DIR}/animationData.s"}
	.ends

	 m_section_free roomTileChanges NAMESPACE roomTileChanges
		.include "code/seasons/tileSubstitutions.s"
		.include {"{GAME_DATA_DIR}/singleTileChanges.s"}
		.include "code/seasons/roomSpecificTileChanges.s"
	.ends

	; The 2 sections to follow must be in the same bank. (Namespaces only differ because the
	; roomGfxChanges file is in a different bank in Ages.)
	 m_section_free roomGfxChanges NAMESPACE roomGfxChanges
		.include "code/seasons/roomGfxChanges.s"
	.ends
	 m_section_free Tileset_Loading_2 NAMESPACE tilesets
		.include "code/loadTilesToRam.s"
		.include "code/seasons/loadTilesetData.s"
	.ends

	; Must be in same bank as "code/bank4.s"
	 m_section_free Warp_Data NAMESPACE bank4
		.include {"{GAME_DATA_DIR}/warpData.s"}
	.ends


.BANK $05 SLOT 1
.ORG 0

	 m_section_free Bank_5 NAMESPACE bank5
		.include "code/bank5.s"

		.include {"{GAME_DATA_DIR}/tileTypeMappings.s"}
		.include {"{GAME_DATA_DIR}/cliffTilesTable.s"}

		.include "code/seasons/subrosiaDanceLink.s"
	.ends

.BANK $06 SLOT 1
.ORG 0

 m_section_free Bank_6 NAMESPACE bank6

	.include "code/interactableTiles.s"
	.include "code/specialObjectAnimationsAndDamage.s"
	.include "code/breakableTiles.s"

	.include "code/items/parentItemUsage.s"

	.include "code/items/shieldParent.s"
	.include "code/items/otherSwordsParent.s"
	.include "code/items/switchHookParent.s"
	.include "code/items/caneOfSomariaParent.s"
	.include "code/items/swordParent.s"
	.include "code/items/harpFluteParent.s"
	.include "code/items/seedsParent.s"
	.include "code/items/shovelParent.s"
	.include "code/items/boomerangParent.s"
	.include "code/items/bombsBraceletParent.s"
	.include "code/items/featherParent.s"
	.include "code/items/magnetGloveParent.s"

	.include "code/items/parentItemCommon.s"
	.include {"{GAME_DATA_DIR}/itemUsageTables.s"}

	.include "object_code/common/specialObjects/minecart.s"

	.include {"{GAME_DATA_DIR}/specialObjectAnimationData.s"}
	.include "code/seasons/cutscenes/companionCutscenes.s"
	.include "code/seasons/cutscenes/linkCutscenes.s"
	.include {"{GAME_DATA_DIR}/signText.s"}
	.include {"{GAME_DATA_DIR}/breakableTileCollisionTable.s"}

.ends


.BANK $07 SLOT 1
.ORG 0

	 m_section_superfree File_Management namespace fileManagement
		.include "code/fileManagement.s"
	.ends

	 ; This section can't be superfree, since it must be in the same bank as section
	 ; "Bank_7_Data".
	 m_section_free Enemy_Part_Collisions namespace bank7
		.include "code/collisionEffects.s"
	.ends

	 m_section_superfree Item_Code namespace itemCode
		.include "code/updateItems.s"

		.include {"{GAME_DATA_DIR}/itemConveyorTilesTable.s"}
		.include {"{GAME_DATA_DIR}/itemPassableCliffTilesTable.s"}
		.include {"{GAME_DATA_DIR}/itemPassableTilesTable.s"}
		.include "code/itemCodes.s"
		.include {"{GAME_DATA_DIR}/itemAttributes.s"}
		.include "data/itemAnimations.s"
	.ends

	 ; This section can't be superfree, since it must be in the same bank as section
	 ; "Enemy_Part_Collisions".
	 m_section_free Bank_7_Data namespace bank7
		.include {"{GAME_DATA_DIR}/enemyActiveCollisions.s"}
		.include {"{GAME_DATA_DIR}/partActiveCollisions.s"}
		.include {"{GAME_DATA_DIR}/objectCollisionTable.s"}
	.ends


.BANK $08 SLOT 1
.ORG 0

	.include "object_code/common/interactionCode/group1.s"
        .include "object_code/common/interactionCode/group2.s"
	.include "object_code/seasons/interactionCode/bank08.s"


.BANK $09 SLOT 1
.ORG 0

	.include "object_code/common/interactionCode/treasure.s"
        .include "object_code/common/interactionCode/group3.s"
	.include "object_code/seasons/interactionCode/bank09.s"


.BANK $0a SLOT 1
.ORG 0

	.include "object_code/common/interactionCode/group4.s"
        .include "object_code/common/interactionCode/group5.s"
	.include "object_code/seasons/interactionCode/bank0a.s"


.BANK $0b SLOT 1
.ORG 0

	 m_section_free Scripts namespace mainScripts
		.include "code/scripting.s"
		.include "scripts/seasons/scripts.s"
	.ends


.BANK $0c SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0c NAMESPACE bank0c

	.include "code/enemyCommon.s"
	.include "object_code/common/enemyCode/group1.s"
	.include "object_code/seasons/enemyCode/bank0c.s"
.ends

m_section_superfree Enemy_Animations
	.include {"{GAME_DATA_DIR}/enemyAnimations.s"}
.ends

.BANK $0d SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0d NAMESPACE bank0d

	.include "code/enemyCommon.s"
	.include "object_code/common/enemyCode/group2.s"

        .include {"{GAME_DATA_DIR}/orbMovementScript.s"}

	.include "object_code/seasons/enemyCode/bank0d.s"

	.include "code/objectMovementScript.s"
	.include {"{GAME_DATA_DIR}/movingSidescrollPlatform.s"}

.ends


.BANK $0e SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0e NAMESPACE bank0e

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "object_code/seasons/enemyCode/bank0e.s"

.ends

.BANK $0f SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0f NAMESPACE bank0f

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "object_code/common/enemyCode/group3.s"
	.include "object_code/seasons/enemyCode/bank0f.s"
	.include "code/seasons/cutscenes/transitionToDragonOnox.s"

.ends

.ifdef BUILD_VANILLA
	.REPT $87
	.db $0f ; emptyfill (TODO: replace this with ORGA, update md5 for emptyfill-0)
	.ENDR
.endif

	.include "object_code/common/interactionCode/group6.s"
	.include "object_code/seasons/interactionCode/bank0f.s"

.BANK $10 SLOT 1
.ORG 0

	.define PART_BANK $10
	.export PART_BANK

 m_section_free Part_Code NAMESPACE partCode

	.include "code/partCommon.s"
	.include "object_code/common/partCode.s" ; Note: closes and opens a new section (seasons only)
        .include "data/partCodeTable.s"
	.include "object_code/seasons/partCode.s"

.ends


.BANK $11 SLOT 1
.ORG 0

	.include "code/objectLoading.s"

 m_section_free Objects_2 namespace objectData
	.include "objects/seasons/pointers.s"
	.include "objects/seasons/mainData.s"
	.include "objects/seasons/extraData3.s"
.ends


.BANK $12 SLOT 1
.ORG 0

	.define BASE_OAM_DATA_BANK $12
	.export BASE_OAM_DATA_BANK

	.include {"{GAME_DATA_DIR}/specialObjectOamData.s"}
	.include "data/itemOamData.s"
	.include {"{GAME_DATA_DIR}/enemyOamData.s"}


.BANK $13 SLOT 1
.ORG 0

 m_section_superfree Terrain_Effects NAMESPACE terrainEffects
	.include "data/terrainEffects.s"
.ends

	.include {"{GAME_DATA_DIR}/interactionOamData.s"}
	.include {"{GAME_DATA_DIR}/partOamData.s"}


.BANK $14 SLOT 1
.ORG 0

	.include {"{GAME_DATA_DIR}/data_4556.s"}

	; TODO: "SIMPLE_SCRIPT_BANK" define should be tied to this section somehow
	 m_section_free Scripts2 NAMESPACE scripts2
		.include "scripts/seasons/scripts2.s"
	.ends

	.include {"{GAME_DATA_DIR}/interactionAnimations.s"}


.BANK $15 SLOT 1
.ORG 0

	.include "code/serialFunctions.s"

	.include "scripts/common/scriptHelper.s"

	.include "object_code/common/interactionCode/group7.s"
	.include "object_code/common/interactionCode/group8.s"


oamData_15_4da3:
	.db $1a
	.db $40 $d0 $00 $02
	.db $50 $e8 $02 $02
	.db $f8 $50 $08 $06
	.db $f8 $58 $0a $06
	.db $f8 $60 $0c $06
	.db $f8 $68 $0e $06
	.db $40 $10 $10 $07
	.db $50 $18 $12 $07
	.db $50 $28 $14 $07
	.db $50 $30 $16 $07
	.db $50 $38 $1e $00
	.db $40 $20 $18 $07
	.db $38 $28 $1a $07
	.db $28 $2b $1c $07
	.db $40 $38 $20 $07
	.db $30 $38 $22 $00
	.db $30 $30 $24 $07
	.db $10 $28 $26 $01
	.db $10 $30 $28 $01
	.db $10 $38 $2a $01
	.db $10 $40 $2c $01
	.db $00 $40 $2e $01
	.db $2b $02 $30 $02
	.db $30 $50 $32 $00
	.db $30 $58 $34 $00
	.db $1d $55 $36 $00


oamData_15_4e0c:
	.db $0a
	.db $46 $4a $88 $03
	.db $46 $52 $8a $03
	.db $49 $4c $80 $02
	.db $49 $54 $82 $02
	.db $47 $42 $84 $03
	.db $47 $4a $86 $03
	.db $39 $4e $90 $03
	.db $43 $59 $8c $03
	.db $39 $46 $8e $03
	.db $3b $3c $92 $03


	.include "code/staticObjects.s"
	.include {"{GAME_DATA_DIR}/staticDungeonObjects.s"}
	.include {"{GAME_DATA_DIR}/chestData.s"}
	.include {"{GAME_DATA_DIR}/treasureObjectData.s"}

	m_section_free Bank_15_3 NAMESPACE scriptHelp
		.include "scripts/seasons/scriptHelper.s"
	.ends

	.include "object_code/seasons/interactionCode/bank15.s"

	.include {"{GAME_DATA_DIR}/partAnimations.s"}


.BANK $16 SLOT 1
.ORG 0

	.include {"{GAME_DATA_DIR}/paletteData.s"}
	.include {"{GAME_DATA_DIR}/tilesetCollisions.s"}
	.include {"{GAME_DATA_DIR}/smallRoomLayoutTables.s"}


.BANK $17 SLOT 1
.ORG 0

 m_section_free Tile_Mappings

	tileMappingIndexDataPointer:
		.dw tileMappingIndexData
	tileMappingAttributeDataPointer:
		.dw tileMappingAttributeData

	tileMappingTable:
		.incbin {"{BUILD_DIR}/tileset_layouts/tileMappingTable.bin"}
	tileMappingIndexData:
		.incbin {"{BUILD_DIR}/tileset_layouts/tileMappingIndexData.bin"}
	tileMappingAttributeData:
		.incbin {"{BUILD_DIR}/tileset_layouts/tileMappingAttributeData.bin"}
.ends

.BANK $18 SLOT 1
.ORG 0

	.include {"{GAME_DATA_DIR}/largeRoomLayoutTables.s"}

	m_GfxDataSimple gfx_animations_1
	m_GfxDataSimple gfx_animations_2
	m_GfxDataSimple gfx_animations_3
	m_GfxDataSimple gfx_063940

	; Compressed graphics file, for some reason doesn't go in gfxDataMain.s.
	m_GfxDataSimple spr_credits_sprites_2


.BANK $19 SLOT 1
.ORG 0

 m_section_superfree Tile_mappings
	.include {"{GAME_DATA_DIR}/tilesetMappings.s"}
.ends


.BANK $1a SLOT 1
.ORG 0
	.include "data/gfxDataBank1a.s"


.BANK $1b SLOT 1
.ORG 0
	.include "data/gfxDataBank1b.s"


.BANK $1c SLOT 1
.ORG 0
	; The first $e characters of gfx_font are blank, so they aren't
	; included in the rom. In order to get the offsets correct, use
	; gfx_font_start as the label instead of gfx_font.

	.define gfx_font_start gfx_font-$e0
	.export gfx_font_start

	m_GfxDataSimple gfx_font_jp ; $70000
	m_GfxDataSimple gfx_font_tradeitems ; $70600
	m_GfxDataSimple gfx_font $e0 ; $70800
	m_GfxDataSimple gfx_font_heartpiece ; $71720

	m_GfxDataSimple map_rings ; $717a0

	; "${BUILD_DIR}/textData.s" will determine where this data starts.
	;   Ages:    1d:4000
	;   Seasons: 1c:5c00

	.include {"{BUILD_DIR}/textData.s"}

	.REDEFINE DATA_ADDR TEXT_END_ADDR
	.REDEFINE DATA_BANK TEXT_END_BANK

	.include {"{GAME_DATA_DIR}/roomLayoutData.s"}
	.include {"{GAME_DATA_DIR}/gfxDataMain.s"}

.BANK $3f SLOT 1
.ORG 0

 m_section_free Bank3f NAMESPACE bank3f

.define BANK_3f $3f

	.include "code/loadGraphics.s"
	.include "code/treasureAndDrops.s"
	.include "code/textbox.s"
	.include "object_code/common/interactionCode/faroreMakeChest.s"

	.include {"{GAME_DATA_DIR}/objectGfxHeaders.s"}
	.include {"{GAME_DATA_DIR}/treeGfxHeaders.s"}

	.include {"{GAME_DATA_DIR}/enemyData.s"}
	.include {"{GAME_DATA_DIR}/partData.s"}
	.include {"{GAME_DATA_DIR}/itemData.s"}
	.include {"{GAME_DATA_DIR}/interactionData.s"}

	.include {"{GAME_DATA_DIR}/treasureCollectionBehaviours.s"}
	.include {"{GAME_DATA_DIR}/treasureDisplayData.s"}

.ends
