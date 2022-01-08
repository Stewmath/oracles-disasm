; Main file for Oracle of Ages, US version

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

.include "build/textDefines.s"


.BANK $00 SLOT 0
.ORG 0

	.include "code/bank0.s"


.BANK $01 SLOT 1
.ORG 0

	.include "code/bank1.s"

	.include "code/ages/garbage/bank01End.s"


.BANK $02 SLOT 1
.ORG 0

	.include "code/bank2.s"
	.include "code/roomInitialization.s"

	 m_section_free roomGfxChanges NAMESPACE roomGfxChanges
		.include "code/ages/roomGfxChanges.s"
	.ends

	.include "code/ages/garbage/bank02End.s"


.BANK $03 SLOT 1
.ORG 0

	.include "code/bank3.s"

	; This section could probably be made superfree in Ages, but this isn't the case in Seasons,
	; so let's just play it safe and leave it as "free".
	 m_section_free Bank_3_Cutscenes NAMESPACE bank3Cutscenes
		.include "code/bank3Cutscenes.s"
		.include "code/ages/cutscenes/endgameCutscenes.s"
		.include "code/ages/cutscenes/miscCutscenes.s"
	.ends

	.include "code/ages/garbage/bank03End.s"

.BANK $04 SLOT 1
.ORG 0

	.include "code/bank4.s"

	 m_section_superfree RoomPacksAndMusicAssignments NAMESPACE bank4Data1
		; These 2 includes must be in the same bank
		.include "build/data/roomPacks.s"
		.include "build/data/musicAssignments.s"
	.ends

	 m_section_superfree RoomLayouts NAMESPACE roomLayouts
		.include "build/data/roomLayoutGroupTable.s"
	.ends

	; Must be in the same bank as "Tileset_Loading_2".
	 m_section_free Tileset_Loading_1 NAMESPACE tilesets
		.include "build/data/tilesets.s"
		.include "build/data/tilesetAssignments.s"
	.ends

	 m_section_free animationAndUniqueGfxData NAMESPACE animationAndUniqueGfxData
		.include "code/animations.s"

		.include "build/data/uniqueGfxHeaders.s"
		.include "build/data/uniqueGfxHeaderPointers.s"
		.include "build/data/animationGroups.s"
		.include "build/data/animationGfxHeaders.s"
		.include "build/data/animationData.s"
	.ends

	 m_section_free roomTileChanges NAMESPACE roomTileChanges
		.include "code/ages/tileSubstitutions.s"
		.include "build/data/singleTileChanges.s"
		.include "code/ages/roomSpecificTileChanges.s"
	.ends

	 m_section_free Tileset_Loading_2 NAMESPACE tilesets
		.include "code/loadTilesToRam.s"
		.include "code/ages/loadTilesetData.s"
	.ends

		; Must be in same bank as "code/bank4.s"
	 m_section_free Warp_Data NAMESPACE bank4
		.include "build/data/warpData.s"
	.ends

	.include "code/ages/garbage/bank04End.s"


.BANK $05 SLOT 1
.ORG 0

	 m_section_free Bank_5 NAMESPACE bank5
		.include "code/bank5.s"

		.include "build/data/tileTypeMappings.s"
		.include "build/data/cliffTilesTable.s"

		.include "code/ages/garbage/bank05End.s"
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
	.include "build/data/itemUsageTables.s"

	.include "object_code/common/specialObjects/minecart.s"
	.include "object_code/common/specialObjects/raft.s"

	.include "build/data/specialObjectAnimationData.s"
	.include "code/ages/cutscenes/companionCutscenes.s"
	.include "code/ages/cutscenes/linkCutscenes.s"
	.include "build/data/signText.s"
	.include "build/data/breakableTileCollisionTable.s"

;;
specialObjectLoadAnimationFrameToBuffer:
	ld hl,w1Companion.visible
	bit 7,(hl)
	ret z

	ld l,<w1Companion.var32
	ld a,(hl)
	call getSpecialObjectGraphicsFrame
	ret z

	ld a,l
	and $f0
	ld l,a
	ld de,w6SpecialObjectGfxBuffer|(:w6SpecialObjectGfxBuffer)
	jp copy256BytesFromBank


	.include "code/ages/garbage/bank06End.s"

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

		.include "build/data/itemConveyorTilesTable.s"
		.include "build/data/itemPassableCliffTilesTable.s"
		.include "build/data/itemPassableTilesTable.s"
		.include "code/itemCodes.s"
		.include "build/data/itemAttributes.s"
		.include "data/itemAnimations.s"
	.ends

	 ; This section can't be superfree, since it must be in the same bank as section
	 ; "Enemy_Part_Collisions".
	 m_section_free Bank_7_Data namespace bank7
		.include "build/data/enemyActiveCollisions.s"
		.include "build/data/partActiveCollisions.s"
		.include "build/data/objectCollisionTable.s"

		.include "code/ages/garbage/bank07End.s"
	.ends


.BANK $08 SLOT 1
.ORG 0

	.include "object_code/common/interactionCode/group1.s"
	.include "object_code/ages/interactionCode/bank08.s"


.BANK $09 SLOT 1
.ORG 0

	.include "object_code/common/interactionCode/group2.s"
        .include "object_code/common/interactionCode/treasure.s"
	.include "object_code/ages/interactionCode/bank09.s"


.BANK $0a SLOT 1
.ORG 0


	.include "object_code/common/interactionCode/group3.s"
        .include "object_code/common/interactionCode/group4.s"
	.include "object_code/ages/interactionCode/bank0a.s"


.BANK $0b SLOT 1
.ORG 0


	.include "object_code/common/interactionCode/group5.s"
        .include "object_code/common/interactionCode/group6.s"
        .include "object_code/common/interactionCode/group7.s"
	.include "object_code/ages/interactionCode/bank0b.s"

	.include "code/ages/garbage/bank0bEnd.s"


.BANK $0c SLOT 1
.ORG 0

	; TODO: "SIMPLE_SCRIPT_BANK" define should be tied to this section somehow
	 m_section_free Scripts namespace mainScripts
		.include "code/scripting.s"
		.include "scripts/ages/scripts.s"
	.ends


.BANK $0d SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0d NAMESPACE bank0d

	.include "code/enemyCommon.s"
	.include "object_code/common/enemyCode/group1.s"
	.include "object_code/ages/enemyCode/bank0d.s"

.ends

 m_section_superfree Enemy_Animations
	.include "build/data/enemyAnimations.s"
.ends


.BANK $0e SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0e NAMESPACE bank0e

	.include "code/enemyCommon.s"
	.include "object_code/common/enemyCode/group2.s"

        .include "build/data/orbMovementScript.s"
        .include "code/objectMovementScript.s"

	.include "object_code/ages/enemyCode/bank0e.s"
	.include "build/data/movingSidescrollPlatform.s"

	.include "code/ages/garbage/bank0eEnd.s"

.ends

.BANK $0f SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0f NAMESPACE bank0f

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "object_code/ages/enemyCode/bank0f.s"

.ends

.BANK $10 SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank10 NAMESPACE bank10

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "object_code/common/enemyCode/group3.s"
	.include "object_code/ages/enemyCode/bank10.s"

.ends


.ifdef BUILD_VANILLA
.ifdef REGION_JP
	; 3 garbage bytes, which round out the data following this to start at $6e00
	.db $be $28 $1e
.else
	; Some blank space here ($6e1f-$6eff)
	.ORGA $6f00
.endif
.endif

	.include "object_code/common/interactionCode/group8.s"
	.include "code/ages/cutscenes/bank10.s"
	.include "object_code/ages/interactionCode/bank10.s"


.BANK $11 SLOT 1
.ORG 0

	.define PART_BANK $11
	.export PART_BANK

 m_section_free Bank_11 NAMESPACE partCode

	.include "code/partCommon.s"
	.include "object_code/common/partCode.s"
        .include "data/partCodeTable.s"
	.include "object_code/ages/partCode.s"
	.include "code/ages/garbage/bank11End.s"

.ends


.BANK $12 SLOT 1
.ORG 0

	.include "code/objectLoading.s"

 m_section_superfree Room_Code namespace roomSpecificCode

	.include "code/ages/roomSpecificCode.s"

.ends

 m_section_free Objects_2 namespace objectData

	.include "objects/ages/mainData.s"
	.include "objects/ages/extraData3.s"

.ends

 m_section_superfree Underwater_Surface_Data namespace underwaterSurfacing

	.include "code/ages/underwaterSurfacing.s"
	.include "data/ages/underwaterSurfaceData.s"

.ENDS

 m_section_free Objects_3 namespace objectData

	.include "objects/ages/extraData4.s"

.ends


.BANK $13 SLOT 1
.ORG 0

	.define BASE_OAM_DATA_BANK $13
	.export BASE_OAM_DATA_BANK

	.include "build/data/specialObjectOamData.s"
	.include "data/itemOamData.s"
	.include "build/data/enemyOamData.s"


.BANK $14 SLOT 1
.ORG 0

 m_section_superfree Terrain_Effects NAMESPACE terrainEffects
	.include "data/terrainEffects.s"
.ends

	.include "build/data/interactionOamData.s"
	.include "build/data/partOamData.s"


.BANK $15 SLOT 1
.ORG 0

	.include "scripts/common/scriptHelper.s"

	 m_section_free Object_Pointers namespace objectData

	;;
	getObjectDataAddress:
		ld a,(wActiveGroup)
		ld hl,objectDataGroupTable
		rst_addDoubleIndex
		ldi a,(hl)
		ld h,(hl)
		ld l,a
		ld a,(wActiveRoom)
		ld e,a
		ld d,$00
		add hl,de
		add hl,de
		ldi a,(hl)
		ld d,(hl)
		ld e,a
		ret


		.include "objects/ages/pointers.s"

	.ENDS

	 m_section_free Bank_15_3 NAMESPACE scriptHelp
		.include "scripts/ages/scriptHelper.s"
	.ends


.BANK $16 SLOT 1
.ORG 0

	.include "code/serialFunctions.s"
	.include "code/loadTreasureData.s"

	 m_section_free Bank16 NAMESPACE bank16
		.include "build/data/data_4556.s"
		.include "build/data/endgameCutsceneOamData.s"
	.ends


	.include "code/staticObjects.s"
	.include "build/data/staticDungeonObjects.s"
	.include "build/data/chestData.s"
	.include "build/data/treasureObjectData.s"

 m_section_free Bank16_2 NAMESPACE bank16

;;
; Used in the room in present Mermaid's Cave with the changing floor
;
; @param	b	Floor state (0/1)
loadD6ChangingFloorPatternToBigBuffer:
	ld a,b
	add a
	ld hl,@changingFloorData
	rst_addDoubleIndex
	push hl
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld b,$41
	ld hl,wBigBuffer
	call copyMemoryReverse

	pop hl
	inc hl
	inc hl
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld b,$41
	ld hl,wBigBuffer+$80
	call copyMemoryReverse

	ldh a,(<hActiveObject)
	ld d,a
	ret

@changingFloorData:
	.dw @tiles0_bottomHalf
	.dw @tiles0_topHalf

	.dw @tiles1
	.dw @tiles1

@tiles0_bottomHalf:
	.db $a0 $a0 $a0 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4
	.db $00

@tiles0_topHalf:
	.db $a0 $a0 $a0 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $a0 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $a0 $f4 $f4 $f4 $f4 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $a0 $ff
	.db $a0 $a0 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $ff
	.db $f4 $f4 $f4 $f4
	.db $00

@tiles1:
	.db $a0 $a0 $f4 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $a0 $a0 $f4 $f4 $f4 $f4 $f4 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $a0 $a0 $a0 $f4 $f4 $a0 $ff
	.db $a0 $a0 $f4 $a0
	.db $00

.ends

	.include "build/data/interactionAnimations.s"
	.include "build/data/partAnimations.s"


.BANK $17 SLOT 1
.ORG 0

	.include "build/data/paletteData.s"
	.include "build/data/tilesetCollisions.s"
	.include "build/data/smallRoomLayoutTables.s"

	.include "code/ages/garbage/bank17End.s"


.BANK $18 SLOT 1
.ORG 0

 m_section_free Tile_Mappings

	tileMappingIndexDataPointer:
		.dw tileMappingIndexData
	tileMappingAttributeDataPointer:
		.dw tileMappingAttributeData

	tileMappingTable:
		.incbin "build/tileset_layouts/tileMappingTable.bin"
	tileMappingIndexData:
		.incbin "build/tileset_layouts/tileMappingIndexData.bin"
	tileMappingAttributeData:
		.incbin "build/tileset_layouts/tileMappingAttributeData.bin"

.ifdef ROM_AGES
	.include "code/ages/garbage/bank18End.s"
.endif

.ends


.BANK $19 SLOT 1
.ORG 0

 m_section_free Gfx_19_1 ALIGN $10
	.include "build/data/gfxDataBank19_1.s"
.ends

 m_section_superfree Tile_mappings
	.include "build/data/tilesetMappings.s"
.ends

 m_section_free Gfx_19_2 ALIGN $10
	.include "build/data/gfxDataBank19_2.s"
.ends


.BANK $1a SLOT 1
.ORG 0


 m_section_free Gfx_1a ALIGN $20
	.include "data/gfxDataBank1a.s"
.ends


.BANK $1b SLOT 1
.ORG 0

 m_section_free Gfx_1b ALIGN $20
	.include "data/gfxDataBank1b.s"
.ends


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

	.include "build/data/largeRoomLayoutTables.s" ; $719c0
	.include "code/ages/garbage/bank1cEnd.s"

	; "build/textData.s" will determine where this data starts.
	;   Ages:    1d:4000
	;   Seasons: 1c:5c00

	.include "build/textData.s"

	.REDEFINE DATA_ADDR TEXT_END_ADDR
	.REDEFINE DATA_BANK TEXT_END_BANK

	.include "build/data/roomLayoutData.s"
	.include "build/data/gfxDataMain.s"



.BANK $3f SLOT 1
.ORG 0

 m_section_free Bank3f NAMESPACE bank3f

.define BANK_3f $3f

.include "code/loadGraphics.s"
.include "code/treasureAndDrops.s"
.include "code/textbox.s"

data_5951:
	.db $3c $b4 $3c $50 $78 $b4 $3c $3c
	.db $3c $70 $78 $78


; In Seasons these sprites are located elsewhere

titlescreenMakuSeedSprite:
	.db $13
	.db $48 $90 $62 $06
	.db $42 $8e $68 $06
	.db $51 $7a $56 $04
	.db $50 $82 $74 $04
	.db $58 $7a $6a $07
	.db $58 $82 $6c $07
	.db $58 $8a $6e $07
	.db $54 $8a $54 $03
	.db $54 $82 $52 $03
	.db $54 $7a $50 $03
	.db $64 $7a $70 $03
	.db $64 $82 $72 $03
	.db $64 $8a $70 $23
	.db $40 $86 $66 $06
	.db $40 $7f $64 $06
	.db $41 $70 $60 $06
	.db $55 $76 $5a $06
	.db $44 $68 $5e $26
	.db $74 $00 $46 $02

titlescreenPressStartSprites:
	.db $0a
	.db $80 $2c $38 $00
	.db $80 $34 $3a $00
	.db $80 $3c $3c $00
	.db $80 $44 $3e $00
	.db $80 $4c $3e $00
	.db $80 $5c $3e $00
	.db $80 $64 $40 $00
	.db $80 $6c $42 $00
	.db $80 $74 $3a $00
	.db $80 $7c $40 $00

; Sprites used on the closeup shot of Link on the horse in the intro
linkOnHorseCloseupSprites_2:
	.db $26
	.db $80 $80 $40 $06
	.db $80 $50 $42 $00
	.db $80 $58 $44 $00
	.db $68 $40 $46 $06
	.db $b8 $3d $20 $02
	.db $b8 $45 $22 $02
	.db $b8 $4d $24 $02
	.db $b8 $55 $26 $02
	.db $b8 $5d $28 $02
	.db $90 $28 $2c $02
	.db $90 $30 $2e $02
	.db $80 $30 $2a $02
	.db $20 $78 $48 $05
	.db $58 $68 $00 $02
	.db $58 $70 $02 $02
	.db $68 $68 $04 $02
	.db $48 $70 $06 $02
	.db $5a $40 $08 $01
	.db $5a $48 $0a $01
	.db $5a $50 $0c $01
	.db $38 $88 $0e $04
	.db $30 $78 $10 $04
	.db $30 $80 $12 $04
	.db $40 $80 $14 $04
	.db $50 $76 $16 $04
	.db $50 $7e $18 $04
	.db $41 $62 $1a $03
	.db $80 $28 $1c $02
	.db $a8 $59 $1e $02
	.db $98 $20 $30 $02
	.db $98 $28 $32 $02
	.db $8c $38 $34 $07
	.db $a8 $41 $36 $02
	.db $a8 $49 $38 $02
	.db $a8 $51 $3a $02
	.db $90 $40 $3e $07
	.db $8a $5c $4a $00
	.db $8a $64 $4c $00

; Sprites used to touch up the appearance of the temple in the intro (the scene where
; Link's on a cliff with his horse)
introTempleSprites:
	.db $05
	.db $30 $28 $48 $02
	.db $30 $30 $4a $02
	.db $18 $38 $4c $03
	.db $10 $40 $4e $03
	.db $18 $48 $50 $03


; Used in intro (ages only)
linkOnHorseFacingCameraSprite:
	.db $02
	.db $70 $08 $58 $02
	.db $70 $10 $5a $02



.include "build/data/objectGfxHeaders.s"
.include "build/data/treeGfxHeaders.s"

.include "build/data/enemyData.s"
.include "build/data/partData.s"
.include "build/data/itemData.s"
.include "build/data/interactionData.s"

.include "build/data/treasureCollectionBehaviours.s"
.include "build/data/treasureDisplayData.s"

oamData_714c:
	.db $10
	.db $c8 $38 $2e $0e
	.db $c8 $40 $30 $0e
	.db $c8 $48 $32 $0e
	.db $c8 $60 $34 $0f
	.db $c8 $68 $36 $0f
	.db $c8 $70 $38 $0f
	.db $d8 $78 $06 $2e
	.db $e8 $80 $00 $0d
	.db $e8 $78 $08 $0e
	.db $e0 $90 $00 $0d
	.db $d8 $a0 $00 $0d
	.db $e8 $30 $04 $0e
	.db $d8 $30 $06 $0e
	.db $f8 $28 $02 $0e
	.db $f0 $18 $00 $2d
	.db $e8 $08 $00 $2d

oamData_718d:
	.db $10
	.db $a8 $38 $12 $0a
	.db $b8 $38 $0e $0f
	.db $c8 $38 $0a $0f
	.db $a8 $70 $14 $0a
	.db $b8 $70 $10 $0a
	.db $c8 $70 $0c $0f
	.db $e8 $80 $00 $0d
	.db $d8 $78 $06 $2e
	.db $e8 $78 $08 $0e
	.db $e0 $90 $00 $0d
	.db $d8 $a0 $00 $0d
	.db $f8 $28 $02 $0e
	.db $f0 $18 $00 $2d
	.db $e8 $08 $00 $2d
	.db $d8 $30 $06 $0e
	.db $e8 $30 $08 $2e

oamData_71ce:
	.db $0a
	.db $50 $40 $40 $0b
	.db $50 $48 $42 $0b
	.db $50 $50 $44 $0b
	.db $50 $58 $46 $0b
	.db $50 $60 $48 $0b
	.db $50 $68 $4a $0b
	.db $70 $70 $3c $0c
	.db $60 $70 $3e $2c
	.db $70 $38 $3a $0c
	.db $60 $38 $3e $0c

oamData_71f7:
	.db $0a
	.db $10 $40 $22 $08
	.db $10 $68 $22 $28
	.db $60 $38 $16 $0c
	.db $70 $38 $1a $0c
	.db $60 $70 $18 $0c
	.db $70 $70 $1a $2c
	.db $40 $40 $1c $08
	.db $40 $68 $1e $08
	.db $50 $40 $20 $08
	.db $50 $68 $20 $28

oamData_7220:
	.db $0a
	.db $e0 $48 $24 $0b
	.db $e0 $60 $24 $2b
	.db $e0 $50 $26 $0b
	.db $e0 $58 $26 $2b
	.db $f0 $48 $28 $0b
	.db $f0 $60 $28 $2b
	.db $00 $48 $2a $0b
	.db $00 $60 $2a $2b
	.db $f8 $50 $2c $0b
	.db $f8 $58 $2c $2b

oamData_7249:
	.db $27
	.db $38 $38 $00 $01
	.db $38 $58 $02 $00
	.db $30 $48 $04 $00
	.db $30 $50 $06 $00
	.db $40 $48 $08 $00
	.db $58 $38 $0a $00
	.db $50 $40 $0c $02
	.db $50 $48 $0e $04
	.db $58 $50 $10 $03
	.db $60 $57 $12 $03
	.db $60 $5f $14 $03
	.db $60 $30 $16 $00
	.db $72 $38 $18 $00
	.db $70 $30 $1a $03
	.db $88 $28 $1c $00
	.db $3b $9a $1e $04
	.db $4b $9a $20 $04
	.db $58 $90 $22 $05
	.db $58 $98 $24 $05
	.db $22 $a0 $26 $06
	.db $22 $a8 $28 $06
	.db $32 $a0 $2a $06
	.db $32 $a8 $2c $06
	.db $12 $a0 $2e $06
	.db $12 $a8 $30 $06
	.db $12 $b0 $32 $06
	.db $6c $b0 $34 $03
	.db $70 $c0 $36 $01
	.db $80 $c0 $38 $05
	.db $90 $58 $3a $03
	.db $30 $90 $3c $00
	.db $90 $c0 $3e $05
	.db $90 $78 $40 $05
	.db $80 $70 $42 $05
	.db $80 $78 $44 $05
	.db $80 $88 $46 $05
	.db $90 $80 $48 $05
	.db $48 $50 $4a $02
	.db $60 $40 $4c $00


.include "object_code/ages/interactionCode/bank3f.s"

.include "code/ages/garbage/bank3fEnd.s"

.ends
