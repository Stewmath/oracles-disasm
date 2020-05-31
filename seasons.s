; Main file for Oracle of Seasons, US version

.include "include/rominfo.s"
.include "include/emptyfill.s"
.include "include/constants.s"
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

.include "build/textDefines.s"


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
	.include "code/seasons/cutscenes/endgameCutscenes.s"
	.include "code/seasons/cutscenes/pirateShipDeparting.s"
	.include "code/seasons/cutscenes/volcanoErupting.s"
	.include "code/seasons/cutscenes/linkedGameCutscenes.s"
	.include "code/seasons/cutscenes/introCutscenes.s"


.BANK $04 SLOT 1
.ORG 0

	.include "code/bank4.s"

	; These 2 includes must be in the same bank
	.include "build/data/roomPacks.s"
	.include "build/data/musicAssignments.s"
	.include "build/data/roomLayoutGroupTable.s"
	.include "build/data/tilesets.s"
	.include "build/data/tilesetAssignments.s"

	.include "code/animations.s"

	.include "data/seasons/uniqueGfxHeaders.s"
	.include "data/seasons/uniqueGfxHeaderPointers.s"
	.include "build/data/animationGroups.s"

	.include "build/data/animationGfxHeaders.s"

	.include "build/data/animationData.s"

	.include "code/seasons/tileSubstitutions.s"
	.include "build/data/singleTileChanges.s"
	.include "code/seasons/roomSpecificTileChanges.s"

;;
; Fills a square in wRoomLayout using the data at hl.
; Data format:
; - Top-left position (YX)
; - Height
; - Width
; - Tile value
fillRectInRoomLayout:
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld d,a
	ld h,>wRoomLayout
--
	ld a,d
	ld l,e
	push bc
-
	ldi (hl),a
	dec c
	jr nz,-
	ld a,e
	add $10
	ld e,a
	pop bc
	dec b
	jr nz,--
	ret

;;
; @param	bc	$0808
; @param	de	$c8f0 - d2 rupee room, $c8f8 - d6 rupee room
; @param	hl	top-left tile of rupees
replaceRupeeRoomRupees:
	ld a,(de)
	inc de
	push bc
-
	rrca
	jr nc,+
	ld (hl),TILEINDEX_STANDARD_FLOOR
+
	inc l
	dec b
	jr nz,-
	ld a,l
	add $08
	ld l,a
	pop bc
	dec c
	jr nz,replaceRupeeRoomRupees
	ret


.include "code/seasons/roomGfxChanges.s"
.include "code/loadTilesToRam.s"


loadTilesetData_body:
	call getTempleRemainsSeasonsTilesetData
	jr c,+
	call getMoblinKeepSeasonsTilesetData
	jr c,+
	ld a,(wActiveGroup)

	ld hl,roomTilesetsGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wActiveRoom)
	rst_addAToHl
	ld a,(hl)
	and $80
	ldh (<hFF8B),a
	ld a,(hl)

	and $7f
	call multiplyABy8
	ld hl,tilesetData
	add hl,bc

	ld a,(hl)
	inc a
	jr nz,+
	inc hl
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wRoomStateModifier)
	call multiplyABy8
	add hl,bc
+
	ldi a,(hl)
	ld e,a
	and $0f
	cp $0f
	jr nz,+
	ld a,$ff
+
	ld (wDungeonIndex),a
	ld a,e
	swap a
	and $0f
	ld (wActiveCollisions),a

	ldi a,(hl)
	ld (wTilesetFlags),a

	ld b,$06
	ld de,wTilesetUniqueGfx
@copyloop:
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,@copyloop

	ld e,wTilesetUniqueGfx&$ff
	ld a,(de)
	ld b,a
	ldh a,(<hFF8B)
	or b
	ld (de),a

	ld a,(wActiveGroup)
	or a
	ret nz
	ld a,(wActiveRoom)
	cp <ROOM_SEASONS_096
	ret nz
	call getThisRoomFlags
	and $80
	ret nz
	ld a,$20
	ld (wTilesetUniqueGfx),a
	ret

getTempleRemainsSeasonsTilesetData:
	ld a,GLOBALFLAG_TEMPLE_REMAINS_FILLED_WITH_LAVA
	call checkGlobalFlag
	ret z

	call checkIsTempleRemains
	ret nc

	ld a,(wRoomStateModifier)
	call multiplyABy8
	ld hl,templeRemainsSeasons
	add hl,bc
--
	xor a
	ldh (<hFF8B),a
	scf
	ret

; @param[out]	cflag	set if active room is temple remains
checkIsTempleRemains:
	ld a,(wActiveGroup)
	or a
	ret nz
	ld a,(wActiveRoom)
	cp $14
	jr c,+
	sub $04
	cp $30
	ret nc
	and $0f
	cp $04
	ret
+
	xor a
	ret

getMoblinKeepSeasonsTilesetData:
	ld a,(wActiveGroup)
	or a
	ret nz

	call getMoblinKeepScreenIndex
	ret nc

	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	ret z

	ld a,(wAnimalCompanion)
	sub $0a
	and $03
	call multiplyABy8
	ld hl,moblinKeepSeasons
	add hl,bc
	jr --

;;
; @param[out]	cflag	Set if active room is in Moblin keep
getMoblinKeepScreenIndex:
	ld a,(wActiveRoom)
	ld b,$05
	ld hl,moblinKeepRooms
-
	cp (hl)
	jr z,+
	inc hl
	dec b
	jr nz,-
	xor a
	ret
+
	scf
	ret

moblinKeepRooms:
	.db $5b $5c $6b $6c $7b

	.include "build/data/warpData.s"


.BANK $05 SLOT 1
.ORG 0

 m_section_force "Bank_5" NAMESPACE bank5

	.include "code/bank5.s"
	.include "build/data/tileTypeMappings.s"
	.include "build/data/cliffTilesTable.s"
	.include "code/seasons/subrosiaDanceLink.s"

.ends

.BANK $06 SLOT 1
.ORG 0

 m_section_superfree "Bank_6" NAMESPACE bank6

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


_itemUsageParameterTable:
	.db $00 <wGameKeysPressed       ; ITEMID_NONE
	.db $05 <wGameKeysPressed       ; ITEMID_SHIELD
	.db $03 <wGameKeysJustPressed   ; ITEMID_PUNCH
	.db $23 <wGameKeysJustPressed   ; ITEMID_BOMB
	.db $03 <wGameKeysJustPressed   ; ITEMID_CANE_OF_SOMARIA
	.db $63 <wGameKeysJustPressed   ; ITEMID_SWORD
	.db $02 <wGameKeysJustPressed   ; ITEMID_BOOMERANG
	.db $33 <wGameKeysJustPressed   ; ITEMID_ROD_OF_SEASONS
	.db $53 <wGameKeysJustPressed   ; ITEMID_MAGNET_GLOVES
	.db $00 <wGameKeysJustPressed   ; ITEMID_SWITCH_HOOK_HELPER
	.db $73 <wGameKeysJustPressed   ; ITEMID_SWITCH_HOOK
	.db $00 <wGameKeysJustPressed   ; ITEMID_SWITCH_HOOK_CHAIN
	.db $73 <wGameKeysJustPressed   ; ITEMID_BIGGORON_SWORD
	.db $02 <wGameKeysJustPressed   ; ITEMID_BOMBCHUS
	.db $05 <wGameKeysJustPressed   ; ITEMID_FLUTE
	.db $43 <wGameKeysJustPressed   ; ITEMID_SHOOTER
	.db $00 <wGameKeysJustPressed   ; ITEMID_10
	.db $00 <wGameKeysJustPressed   ; ITEMID_HARP
	.db $00 <wGameKeysJustPressed   ; ITEMID_12
	.db $43 <wGameKeysJustPressed   ; ITEMID_SLINGSHOT
	.db $00 <wGameKeysJustPressed   ; ITEMID_14
	.db $13 <wGameKeysJustPressed   ; ITEMID_SHOVEL
	.db $13 <wGameKeysPressed       ; ITEMID_BRACELET
	.db $01 <wGameKeysJustPressed   ; ITEMID_FEATHER
	.db $00 <wGameKeysJustPressed   ; ITEMID_18
	.db $02 <wGameKeysJustPressed   ; ITEMID_SEED_SATCHEL
	.db $00 <wGameKeysJustPressed   ; ITEMID_DUST
	.db $00 <wGameKeysJustPressed   ; ITEMID_1b
	.db $00 <wGameKeysJustPressed   ; ITEMID_1c
	.db $00 <wGameKeysJustPressed   ; ITEMID_MINECART_COLLISION
	.db $03 <wGameKeysJustPressed   ; ITEMID_FOOLS_ORE
	.db $00 <wGameKeysJustPressed   ; ITEMID_1f


_linkItemAnimationTable:
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_NONE
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_SHIELD
	.db $d6  LINK_ANIM_MODE_21	; ITEMID_PUNCH
	.db $30  LINK_ANIM_MODE_LIFT	; ITEMID_BOMB
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_CANE_OF_SOMARIA
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_SWORD
	.db $b0  LINK_ANIM_MODE_21	; ITEMID_BOOMERANG
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_ROD_OF_SEASONS
	.db $60  LINK_ANIM_MODE_NONE	; ITEMID_MAGNET_GLOVES
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_HELPER
	.db $f6  LINK_ANIM_MODE_21	; ITEMID_SWITCH_HOOK
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_CHAIN
	.db $f6  LINK_ANIM_MODE_23	; ITEMID_BIGGORON_SWORD
	.db $30  LINK_ANIM_MODE_21	; ITEMID_BOMBCHUS
	.db $70  LINK_ANIM_MODE_FLUTE	; ITEMID_FLUTE
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SHOOTER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_10
	.db $70  LINK_ANIM_MODE_HARP_2	; ITEMID_HARP
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_12
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SLINGSHOT
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_14
	.db $b0  LINK_ANIM_MODE_DIG_2	; ITEMID_SHOVEL
	.db $40  LINK_ANIM_MODE_LIFT_3	; ITEMID_BRACELET
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_FEATHER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_18
	.db $a0  LINK_ANIM_MODE_21	; ITEMID_SEED_SATCHEL
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_DUST
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1b
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1c
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_MINECART_COLLISION
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_FOOLS_ORE
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1f

	.include "object_code/common/specialObjects/minecart.s"
	.include "object_code/common/specialObjects/raft.s"

	.include "data/seasons/specialObjectAnimationData.s"
	.include "code/seasons/cutscenes/companionCutscenes.s"
	.include "code/seasons/cutscenes/linkCutscenes.s"
	.include "build/data/signText.s"
	.include "build/data/breakableTileCollisionTable.s"

.ends


.BANK $07 SLOT 1
.ORG 0

.include "code/fileManagement.s"

 ; This section can't be superfree, since it must be in the same bank as section
 ; "Bank_7_Data".
 m_section_free "Enemy_Part_Collisions" namespace "bank7"

	.include "code/collisionEffects.s"

.ends


 m_section_superfree "Item_Code" namespace "itemCode"

	.include "code/updateItems.s"
	.include "build/data/itemConveyorTilesTable.s"
	.include "build/data/itemPassableCliffTilesTable.s"
	.include "build/data/itemPassableTilesTable.s"
	.include "code/itemCodes.s"
	.include "data/seasons/itemAttributes.s"
	.include "data/itemAnimations.s"

.ends


 ; This section can't be superfree, since it must be in the same bank as section
 ; "Enemy_Part_Collisions".
 m_section_free "Bank_7_Data" namespace "bank7"

	.include "data/seasons/enemyActiveCollisions.s"
	.include "data/seasons/partActiveCollisions.s"

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

	.include "object_code/common/interactionCode/group5.s"
        .include "object_code/common/interactionCode/group6.s"
	.include "object_code/seasons/interactionCode/bank0a.s"

.BANK $0b SLOT 1
.ORG 0

	.include "code/scripting.s"
	.include "scripts/seasons/scripts.s"


.BANK $0c SLOT 1
.ORG 0

.section Enemy_Code_Bank0c

	.include "code/enemyCommon.s"
	.include "object_code/common/enemyCode/group1.s"
	.include "object_code/seasons/enemyCode/bank0c.s"
	.include "data/seasons/enemyAnimations.s"

.ends

.BANK $0d SLOT 1
.ORG 0

.section Enemy_Code_Bank0d

	.include "code/enemyCommon.s"
	.include "object_code/common/enemyCode/group2.s"

        .include "build/data/orbMovementScript.s"

	.include "object_code/seasons/enemyCode/bank0d.s"

	.include "code/objectMovementScript.s"
	.include "build/data/movingSidescrollPlatform.s"

.ends

.BANK $0e SLOT 1
.ORG 0

.section Enemy_Code_Bank0e

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "object_code/seasons/enemyCode/bank0e.s"

.ends

.BANK $0f SLOT 1
.ORG 0

.section Enemy_Code_Bank0f

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "object_code/common/enemyCode/group3.s"
	.include "object_code/seasons/enemyCode/bank0f.s"
	.include "code/seasons/cutscenes/transitionToDragonOnox.s"

	.REPT $87
	.db $0f ; emptyfill
	.ENDR

	.include "object_code/common/interactionCode/group7.s"
	.include "object_code/seasons/interactionCode/bank0f.s"

.ends

.BANK $10 SLOT 1
.ORG 0

	.define PART_BANK $10
	.export PART_BANK

 m_section_force "Part_Code" NAMESPACE "partCode"

	.include "code/partCommon.s"
	.include "object_code/common/partCode.s"
        .include "data/partCodeTable.s"
	.include "object_code/seasons/partCode.s"

.ends


.BANK $11 SLOT 1
.ORG 0

	.include "code/objectLoading.s"

 m_section_free "Objects_2" namespace "objectData"
	.include "objects/seasons/pointers.s"
	.include "objects/seasons/mainData.s"
	.include "objects/seasons/extraData3.s"
.ends


.BANK $12 SLOT 1
.ORG 0

	.define BASE_OAM_DATA_BANK $12
	.export BASE_OAM_DATA_BANK

	.include "data/seasons/specialObjectOamData.s"
	.include "data/itemOamData.s"
	.include "data/seasons/enemyOamData.s"


.BANK $13 SLOT 1
.ORG 0

 m_section_superfree "Terrain_Effects" NAMESPACE "terrainEffects"
	.include "data/terrainEffects.s"
.ends

	.include "data/seasons/interactionOamData.s"
	.include "data/seasons/partOamData.s"


.BANK $14 SLOT 1
.ORG 0

	.include "build/data/data_4556.s"
	.include "scripts/seasons/scripts2.s"
	.include "data/seasons/interactionAnimations.s"


.BANK $15 SLOT 1
.ORG 0

.include "code/serialFunctions.s"

	.include "scripts/common/scriptHelper.s"
	.include "object_code/common/interactionCode/group4.s"
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
	.include "build/data/staticDungeonObjects.s"
	.include "build/data/chestData.s"

	.include "build/data/treasureObjectData.s"

	.include "scripts/seasons/scriptHelper.s"
	.include "object_code/seasons/interactionCode/bank15.s"

	.include "data/seasons/partAnimations.s"


.BANK $16 SLOT 1
.ORG 0

	.include "build/data/paletteData.s"
	.include "build/data/tilesetCollisions.s"
	.include "build/data/smallRoomLayoutTables.s"

.BANK $17 SLOT 1
.ORG 0

 m_section_superfree Tile_Mappings

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
.ends

.BANK $18 SLOT 1
.ORG 0

	.include "build/data/largeRoomLayoutTables.s"

	m_GfxDataSimple gfx_animations_1
	m_GfxDataSimple gfx_animations_2
	m_GfxDataSimple gfx_animations_3
	m_GfxDataSimple gfx_063940

	; Compressed graphics file, for some reason doesn't go in gfxDataMain.s.
	m_GfxDataSimple spr_credits_sprites_2


.BANK $19 SLOT 1
.ORG 0

 m_section_superfree "Tile_mappings"
	.include "build/data/tilesetMappings.s"
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

	; TODO: where does "build/data/largeRoomLayoutTables.s" go?


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

 m_section_force Bank3f NAMESPACE bank3f

.define BANK_3f $3f

	.include "code/loadGraphics.s"
	.include "code/treasureAndDrops.s"
	.include "code/textbox.s"
	.include "object_code/common/interactionCode/faroreMakeChest.s"

	.include "build/data/objectGfxHeaders.s"
	.include "build/data/treeGfxHeaders.s"

	.include "build/data/enemyData.s"
	.include "build/data/partData.s"
	.include "build/data/itemData.s"
	.include "build/data/interactionData.s"

	.include "build/data/treasureCollectionBehaviours.s"
	.include "build/data/treasureDisplayData.s"

sounda1Start:
; @addr{ebada}
sounda1Channel2:
	duty $02
	vol $d
	env $1 $00
	cmdf8 $00
	note $30 $04
	vol $c
	note $34 $04
	vol $d
	note $38 $04
	vibrato $51
	env $1 $01
	vol $b
	note $3c $14
	cmdff
.ends

.BANK $42 SLOT 1
.ORG 0

 m_section_superfree "Bank_1_Data_2"

	.include "build/data/paletteHeaders.s"
	.include "build/data/uncmpGfxHeaders.s"
	.include "build/data/gfxHeaders.s"
	.include "build/data/tilesetHeaders.s"

.ends