; See data/ages/paletteHeaders.s for documentation.
; TODO: Finish labelling these
;
; Naming conventions:
; - PALH_TILESET: Palettes used by tilesets, should load bg palettes 2-7.
;                 May also load a sprite palette or two (ie. PALH_TILESET_BIGGORON)
; - PALH_BG:      Loads bg palettes only (not used for tilesets)
; - PALH_SPR:     Loads sprite palettes only
; - PALH:         If none of the above, could load both sprite & bg palettes (or not yet categorized)

.define NUM_PALETTE_HEADERS $be

paletteHeaderTable:
	.repeat NUM_PALETTE_HEADERS index COUNT
		.dw paletteHeader{%.2x{COUNT}}
	.endr


m_PaletteHeaderStart $00, PALH_00
	m_PaletteHeaderBg  0, 1, paletteData4000
	m_PaletteHeaderEnd

m_PaletteHeaderStart $01, PALH_01
	m_PaletteHeaderBg  0, 2, paletteData4008
	m_PaletteHeaderEnd

m_PaletteHeaderStart $02, PALH_02
	m_PaletteHeaderBg  0, 1, paletteData5e50
	m_PaletteHeaderSpr 0, 1, paletteData5e50
	m_PaletteHeaderEnd

m_PaletteHeaderStart $03, PALH_03
	m_PaletteHeaderBg  0, 8, paletteData4018
	m_PaletteHeaderSpr 0, 8, paletteData4058
	m_PaletteHeaderEnd

m_PaletteHeaderStart $04, PALH_04
	m_PaletteHeaderBg  0, 4, paletteData45b0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $05, PALH_05
	m_PaletteHeaderBg  0, 1, paletteData4830
	m_PaletteHeaderBg  2, 5, paletteData5db8
	m_PaletteHeaderSpr 0, 4, standardSpritePaletteData
	m_PaletteHeaderSpr 4, 3, paletteData5d98
	m_PaletteHeaderEnd

m_PaletteHeaderStart $06, PALH_06
	m_PaletteHeaderBg  0, 1, paletteData4830
	m_PaletteHeaderBg  2, 5, paletteData5de0
	m_PaletteHeaderSpr 0, 4, standardSpritePaletteData
	m_PaletteHeaderSpr 4, 3, paletteData5d98
	m_PaletteHeaderEnd

m_PaletteHeaderStart $07, PALH_07
	m_PaletteHeaderBg  0, 8, paletteData4098
	m_PaletteHeaderSpr 0, 8, paletteData40d8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $08, PALH_08
	m_PaletteHeaderBg  0, 8, paletteData4118
	m_PaletteHeaderSpr 0, 8, paletteData4158
	m_PaletteHeaderEnd

m_PaletteHeaderStart $09, PALH_09
	m_PaletteHeaderBg  2, 4, paletteData4198
	m_PaletteHeaderSpr 0, 6, standardSpritePaletteData
	m_PaletteHeaderEnd

m_PaletteHeaderStart $0a, PALH_0a
	m_PaletteHeaderBg  0, 2, paletteData4830
	m_PaletteHeaderBg  2, 6, standardSpritePaletteData
	m_PaletteHeaderSpr 0, 6, standardSpritePaletteData
	m_PaletteHeaderSpr 7, 1, paletteData5e48
	m_PaletteHeaderEnd

m_PaletteHeaderStart $0b, PALH_0b
	m_PaletteHeaderSpr 0, 4, standardSpritePaletteData
	m_PaletteHeaderSpr 2, 1, paletteData4468
	m_PaletteHeaderSpr 4, 3, paletteData46f8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $0c, PALH_0c
	m_PaletteHeaderBg  0, 8, paletteData4930
	m_PaletteHeaderSpr 0, 8, paletteData4970
	m_PaletteHeaderEnd

m_PaletteHeaderStart $0d, PALH_0d
	m_PaletteHeaderBg  1, 1, paletteData4878
	m_PaletteHeaderEnd

m_PaletteHeaderStart $0e, PALH_0e
	m_PaletteHeaderBg  1, 1, paletteData4870
	m_PaletteHeaderEnd

m_PaletteHeaderStart $0f, PALH_0f
	m_PaletteHeaderBg  0, 1, paletteData4830
	m_PaletteHeaderSpr 0, 6, standardSpritePaletteData
	m_PaletteHeaderEnd

m_PaletteHeaderStart $10, PALH_TILESET_OVERWORLD_SPRING_A
	m_PaletteHeaderBg  2, 6, paletteData49b0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $11, PALH_TILESET_OVERWORLD_SUMMER_A
	m_PaletteHeaderBg  2, 6, paletteData49e0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $12, PALH_TILESET_OVERWORLD_AUTUMN_A
	m_PaletteHeaderBg  2, 6, paletteData4a10
	m_PaletteHeaderEnd

m_PaletteHeaderStart $13, PALH_TILESET_OVERWORLD_WINTER_A
	m_PaletteHeaderBg  2, 6, paletteData4a40
	m_PaletteHeaderEnd

m_PaletteHeaderStart $14, PALH_TILESET_OVERWORLD_SPRING_B
	m_PaletteHeaderBg  2, 6, paletteData4a70
	m_PaletteHeaderEnd

m_PaletteHeaderStart $15, PALH_TILESET_OVERWORLD_SUMMER_B
	m_PaletteHeaderBg  2, 6, paletteData4aa0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $16, PALH_TILESET_OVERWORLD_AUTUMN_B
	m_PaletteHeaderBg  2, 6, paletteData4ad0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $17, PALH_TILESET_OVERWORLD_WINTER_B
	m_PaletteHeaderBg  2, 6, paletteData4b00
	m_PaletteHeaderEnd

m_PaletteHeaderStart $18, PALH_TILESET_OVERWORLD_SPRING_C
	m_PaletteHeaderBg  2, 6, paletteData4b30
	m_PaletteHeaderEnd

m_PaletteHeaderStart $19, PALH_TILESET_OVERWORLD_SUMMER_C
	m_PaletteHeaderBg  2, 6, paletteData4b60
	m_PaletteHeaderEnd

m_PaletteHeaderStart $1a, PALH_TILESET_OVERWORLD_AUTUMN_C
	m_PaletteHeaderBg  2, 6, paletteData4b90
	m_PaletteHeaderEnd

m_PaletteHeaderStart $1b, PALH_TILESET_OVERWORLD_WINTER_C
	m_PaletteHeaderBg  2, 6, paletteData4bc0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $1c, PALH_TILESET_SUNKEN_CITY_UNUSED_SPRING
	m_PaletteHeaderBg  2, 6, paletteData4bf0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $1d, PALH_TILESET_SUNKEN_CITY_UNUSED_SUMMER
	m_PaletteHeaderBg  2, 6, paletteData4c20
	m_PaletteHeaderEnd

m_PaletteHeaderStart $1e, PALH_TILESET_SUNKEN_CITY_UNUSED_AUTUMN
	m_PaletteHeaderBg  2, 6, paletteData4c50
	m_PaletteHeaderEnd

m_PaletteHeaderStart $1f, PALH_TILESET_SUNKEN_CITY_UNUSED_WINTER
	m_PaletteHeaderBg  2, 6, paletteData4c80
	m_PaletteHeaderEnd

m_PaletteHeaderStart $20, PALH_TILESET_OVERWORLD_SPRING_D
	m_PaletteHeaderBg  2, 6, paletteData4cb0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $21, PALH_TILESET_OVERWORLD_SUMMER_D
	m_PaletteHeaderBg  2, 6, paletteData4ce0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $22, PALH_TILESET_OVERWORLD_AUTUMN_D
	m_PaletteHeaderBg  2, 6, paletteData4d10
	m_PaletteHeaderEnd

m_PaletteHeaderStart $23, PALH_TILESET_OVERWORLD_WINTER_D
	m_PaletteHeaderBg  2, 6, paletteData4d40
	m_PaletteHeaderEnd

m_PaletteHeaderStart $24, PALH_TILESET_TARM_RUINS_SPRING
	m_PaletteHeaderBg  2, 6, paletteData4da0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $25, PALH_TILESET_TARM_RUINS_SUMMER
	m_PaletteHeaderBg  2, 6, paletteData4dd0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $26, PALH_TILESET_TARM_RUINS_AUTUMN
	m_PaletteHeaderBg  2, 6, paletteData4e00
	m_PaletteHeaderEnd

m_PaletteHeaderStart $27, PALH_TILESET_TARM_RUINS_WINTER
	m_PaletteHeaderBg  2, 6, paletteData4e30
	m_PaletteHeaderEnd

m_PaletteHeaderStart $28, PALH_TILESET_ANCIENT_RUINS_ENTRANCE_SPRING
	m_PaletteHeaderBg  2, 6, paletteData4e60
	m_PaletteHeaderEnd

m_PaletteHeaderStart $29, PALH_TILESET_ANCIENT_RUINS_ENTRANCE_SUMMER
	m_PaletteHeaderBg  2, 6, paletteData4e90
	m_PaletteHeaderEnd

m_PaletteHeaderStart $2a, PALH_TILESET_ANCIENT_RUINS_ENTRANCE_AUTUMN
	m_PaletteHeaderBg  2, 6, paletteData4ec0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $2b, PALH_TILESET_ANCIENT_RUINS_ENTRANCE_WINTER
	m_PaletteHeaderBg  2, 6, paletteData4ef0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $2c, PALH_TILESET_GRAVEYARD_SPRING
	m_PaletteHeaderBg  2, 6, paletteData4f20
	m_PaletteHeaderEnd

m_PaletteHeaderStart $2d, PALH_TILESET_GRAVEYARD_SUMMER
	m_PaletteHeaderBg  2, 6, paletteData4f50
	m_PaletteHeaderEnd

m_PaletteHeaderStart $2e, PALH_TILESET_GRAVEYARD_AUTUMN
	m_PaletteHeaderBg  2, 6, paletteData4f80
	m_PaletteHeaderEnd

m_PaletteHeaderStart $2f, PALH_TILESET_GRAVEYARD_WINTER
	m_PaletteHeaderBg  2, 6, paletteData4fb0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $30, PALH_TILESET_TEMPLE_REMAINS_SPRING_A
	m_PaletteHeaderBg  2, 6, paletteData4fe0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $31, PALH_TILESET_TEMPLE_REMAINS_SUMMER_A
	m_PaletteHeaderBg  2, 6, paletteData5010
	m_PaletteHeaderEnd

m_PaletteHeaderStart $32, PALH_TILESET_TEMPLE_REMAINS_AUTUMN_A
	m_PaletteHeaderBg  2, 6, paletteData5040
	m_PaletteHeaderEnd

m_PaletteHeaderStart $33, PALH_TILESET_TEMPLE_REMAINS_WINTER_A
	m_PaletteHeaderBg  2, 6, paletteData5070
	m_PaletteHeaderEnd

m_PaletteHeaderStart $34, PALH_TILESET_TEMPLE_REMAINS_SPRING_B
	m_PaletteHeaderBg  2, 6, paletteData50a0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $35, PALH_TILESET_TEMPLE_REMAINS_SUMMER_B
	m_PaletteHeaderBg  2, 6, paletteData50d0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $36, PALH_TILESET_TEMPLE_REMAINS_AUTUMN_B
	m_PaletteHeaderBg  2, 6, paletteData5100
	m_PaletteHeaderEnd

m_PaletteHeaderStart $37, PALH_TILESET_TEMPLE_REMAINS_WINTER_B
	m_PaletteHeaderBg  2, 6, paletteData5130
	m_PaletteHeaderEnd

m_PaletteHeaderStart $38, PALH_TILESET_ONOX_CASTLE_OUTSIDE_SPRING
	m_PaletteHeaderBg  2, 6, paletteData5160
	m_PaletteHeaderEnd

m_PaletteHeaderStart $39, PALH_TILESET_ONOX_CASTLE_OUTSIDE_SUMMER
	m_PaletteHeaderBg  2, 6, paletteData5190
	m_PaletteHeaderEnd

m_PaletteHeaderStart $3a, PALH_TILESET_ONOX_CASTLE_OUTSIDE_AUTUMN
	m_PaletteHeaderBg  2, 6, paletteData51c0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $3b, PALH_TILESET_ONOX_CASTLE_OUTSIDE_WINTER
	m_PaletteHeaderBg  2, 6, paletteData51f0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $3c, PALH_TILESET_SIDESCROLL_HEROS_CAVE
	m_PaletteHeaderBg  2, 6, paletteData59d0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $3d, PALH_TILESET_SIDESCROLL_GNARLED_ROOT_DUNGEON
	m_PaletteHeaderBg  2, 6, paletteData5a00
	m_PaletteHeaderEnd

m_PaletteHeaderStart $3e, PALH_TILESET_SIDESCROLL_POISON_MOTHS_LAIR
	m_PaletteHeaderBg  2, 6, paletteData5a60
	m_PaletteHeaderEnd

m_PaletteHeaderStart $3f, PALH_SECRET_LIST_MENU
	m_PaletteHeaderBg  2, 4, paletteData5e08
	m_PaletteHeaderSpr 0, 8, paletteData41b8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $40, PALH_TILESET_HEROS_CAVE
	m_PaletteHeaderBg  2, 6, paletteData5460
	m_PaletteHeaderEnd

m_PaletteHeaderStart $41, PALH_TILESET_GNARLED_ROOT_DUNGEON
	m_PaletteHeaderBg  2, 6, paletteData5490
	m_PaletteHeaderEnd

m_PaletteHeaderStart $42, PALH_TILESET_SNAKES_REMAINS
	m_PaletteHeaderBg  2, 6, paletteData54c0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $43, PALH_TILESET_POISON_MOTHS_LAIR
	m_PaletteHeaderBg  2, 6, paletteData54f0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $44, PALH_TILESET_DANCING_DRAGON_DUNGEON
	m_PaletteHeaderBg  2, 6, paletteData5520
	m_PaletteHeaderEnd

m_PaletteHeaderStart $45, PALH_TILESET_UNICORNS_CAVE
	m_PaletteHeaderBg  2, 6, paletteData5550
	m_PaletteHeaderEnd

m_PaletteHeaderStart $46, PALH_TILESET_ANCIENT_RUINS
	m_PaletteHeaderBg  2, 6, paletteData5580
	m_PaletteHeaderEnd

m_PaletteHeaderStart $47, PALH_TILESET_EXPLORERS_CRYPT_A
	m_PaletteHeaderBg  2, 6, paletteData55b0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $48, PALH_TILESET_SWORD_AND_SHIELD_MAZE_ICE
	m_PaletteHeaderBg  2, 6, paletteData5610
	m_PaletteHeaderEnd

m_PaletteHeaderStart $49, PALH_TILESET_ONOX_CASTLE
	m_PaletteHeaderBg  2, 6, paletteData56a0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $4a, PALH_TILESET_ROOM_OF_RITES
	m_PaletteHeaderBg  2, 6, paletteData56d0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $4b, PALH_4b

m_PaletteHeaderStart $4c, PALH_4c

m_PaletteHeaderStart $4d, PALH_TILESET_EXPLORERS_CRYPT_B
	m_PaletteHeaderBg  2, 6, paletteData55e0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $4e, PALH_TILESET_SWORD_AND_SHIELD_MAZE_FIRE
	m_PaletteHeaderBg  2, 6, paletteData5640
	m_PaletteHeaderEnd

m_PaletteHeaderStart $4f, PALH_TILESET_SWORD_AND_SHIELD_MAZE_FIRE_MINIBOSS
	m_PaletteHeaderBg  2, 6, paletteData5670
	m_PaletteHeaderEnd

m_PaletteHeaderStart $50, PALH_TILESET_MAKU_TREE
	m_PaletteHeaderBg  2, 6, paletteData5c10
	m_PaletteHeaderEnd

m_PaletteHeaderStart $51, PALH_TILESET_MAKU_TREE_SMALL
	m_PaletteHeaderBg  2, 6, paletteData5c40
	m_PaletteHeaderEnd

m_PaletteHeaderStart $52, PALH_SPR_MAKU_TREE
	m_PaletteHeaderSpr 6, 1, paletteData5c70
	m_PaletteHeaderEnd

m_PaletteHeaderStart $53, PALH_53

m_PaletteHeaderStart $54, PALH_TILESET_BIGGORON
	m_PaletteHeaderBg  2, 6, paletteData4d70
	m_PaletteHeaderSpr 6, 1, paletteData5c88
	m_PaletteHeaderEnd

m_PaletteHeaderStart $55, PALH_SPR_ANCIENT_RUINS_ENTRANCE
	m_PaletteHeaderSpr 6, 1, paletteData5c80
	m_PaletteHeaderEnd

m_PaletteHeaderStart $56, PALH_TILESET_TARM_RUINS_PEDESTAL
	m_PaletteHeaderBg  2, 6, paletteData4dd0
	m_PaletteHeaderSpr 6, 1, paletteData5c90
	m_PaletteHeaderEnd

m_PaletteHeaderStart $57, PALH_57
	m_PaletteHeaderSpr 6, 1, $dea0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $58, PALH_TILESET_SUBROSIA_TEMPLE_OUTSIDE_WEST
	m_PaletteHeaderBg  2, 6, paletteData5310
	m_PaletteHeaderEnd

m_PaletteHeaderStart $59, PALH_TILESET_SUBROSIA_TEMPLE_OUTSIDE_EAST
	m_PaletteHeaderBg  2, 6, paletteData52e0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $5a, PALH_TILESET_SUBROSIA_A
	m_PaletteHeaderBg  2, 6, paletteData5340
	m_PaletteHeaderEnd

m_PaletteHeaderStart $5b, PALH_TILESET_SUBROSIA_B
	m_PaletteHeaderBg  2, 6, paletteData5370
	m_PaletteHeaderEnd

m_PaletteHeaderStart $5c, PALH_TILESET_SUBROSIAN_SMITHY_OUTSIDE
	m_PaletteHeaderBg  2, 6, paletteData53a0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $5d, PALH_TILESET_SUBROSIA_C
	m_PaletteHeaderBg  2, 6, paletteData53d0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $5e, PALH_TILESET_SUBROSIA_BEACH
	m_PaletteHeaderBg  2, 6, paletteData5400
	m_PaletteHeaderEnd

m_PaletteHeaderStart $5f, PALH_TILESET_SUBROSIA_TEMPLE_VARIANT_UNUSED
	m_PaletteHeaderBg  2, 6, paletteData5430
	m_PaletteHeaderEnd

m_PaletteHeaderStart $60, PALH_TILESET_TEMPLE_SPRING
	m_PaletteHeaderBg  2, 6, paletteData5ca8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $61, PALH_TILESET_TEMPLE_SUMMER
	m_PaletteHeaderBg  2, 6, paletteData5cd8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $62, PALH_TILESET_TEMPLE_AUTUMN
	m_PaletteHeaderBg  2, 6, paletteData5d08
	m_PaletteHeaderEnd

m_PaletteHeaderStart $63, PALH_TILESET_TEMPLE_WINTER
	m_PaletteHeaderBg  2, 6, paletteData5d38
	m_PaletteHeaderEnd

m_PaletteHeaderStart $64, PALH_TILESET_NATZU_PRAIRIE
	m_PaletteHeaderBg  2, 6, paletteData5250
	m_PaletteHeaderEnd

m_PaletteHeaderStart $65, PALH_TILESET_NATZU_RIVER
	m_PaletteHeaderBg  2, 6, paletteData5280
	m_PaletteHeaderEnd

m_PaletteHeaderStart $66, PALH_TILESET_NATZU_WASTELAND
	m_PaletteHeaderBg  2, 6, paletteData52b0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $67, PALH_67

m_PaletteHeaderStart $68, PALH_TILESET_SIDESCROLL_SNAKES_REMAINS
	m_PaletteHeaderBg  2, 6, paletteData5a30
	m_PaletteHeaderEnd

m_PaletteHeaderStart $69, PALH_TILESET_SIDESCROLL_DANCING_DRAGON_DUNGEON
	m_PaletteHeaderBg  2, 6, paletteData5a90
	m_PaletteHeaderEnd

m_PaletteHeaderStart $6a, PALH_TILESET_SIDESCROLL_UNICORNS_CAVE
	m_PaletteHeaderBg  2, 6, paletteData5ac0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $6b, PALH_TILESET_SIDESCROLL_SWORD_AND_SHIELD_MAZE_ICE
	m_PaletteHeaderBg  2, 6, paletteData5af0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $6c, PALH_TILESET_SIDESCROLL_SWORD_AND_SHIELD_MAZE_FIRE
	m_PaletteHeaderBg  2, 6, paletteData5b20
	m_PaletteHeaderEnd

m_PaletteHeaderStart $6d, PALH_TILESET_SIDESCROLL_UNUSED
	m_PaletteHeaderBg  2, 6, paletteData5b80
	m_PaletteHeaderEnd

m_PaletteHeaderStart $6e, PALH_TILESET_SIDESCROLL_UNDERWATER
	m_PaletteHeaderBg  2, 6, paletteData5bb0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $6f, PALH_TILESET_SIDESCROLL_SUBROSIA
	m_PaletteHeaderBg  2, 6, paletteData5be0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $70, PALH_TILESET_INDOORS_A
	m_PaletteHeaderBg  2, 6, paletteData5760
	m_PaletteHeaderEnd

m_PaletteHeaderStart $71, PALH_TILESET_INDOORS_B
	m_PaletteHeaderBg  2, 6, paletteData5790
	m_PaletteHeaderEnd

m_PaletteHeaderStart $72, PALH_TILESET_SUBROSIA_FURNACE
	m_PaletteHeaderBg  2, 6, paletteData57c0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $73, PALH_TILESET_OLD_MAN_CAVE
	m_PaletteHeaderBg  2, 6, paletteData57f0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $74, PALH_TILESET_MOBLIN_HOUSE
	m_PaletteHeaderBg  2, 6, paletteData5d68
	m_PaletteHeaderEnd

m_PaletteHeaderStart $75, PALH_TILESET_SUBROSIA_BOOMERANG_ROOM
	m_PaletteHeaderBg  2, 6, paletteData5820
	m_PaletteHeaderEnd

m_PaletteHeaderStart $76, PALH_TILESET_VASE_HOUSE
	m_PaletteHeaderBg  2, 6, paletteData5850
	m_PaletteHeaderEnd

m_PaletteHeaderStart $77, PALH_TILESET_CAVE
	m_PaletteHeaderBg  2, 6, paletteData5880
	m_PaletteHeaderEnd

m_PaletteHeaderStart $78, PALH_TILESET_SUBROSIA_CAVE
	m_PaletteHeaderBg  2, 6, paletteData58b0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $79, PALH_TILESET_MAKU_TREE_INSIDE
	m_PaletteHeaderBg  2, 6, paletteData58e0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $7a, PALH_TILESET_MOBLIN_KEEP
	m_PaletteHeaderBg  2, 6, paletteData5910
	m_PaletteHeaderEnd

m_PaletteHeaderStart $7b, PALH_TILESET_TEMPLE_OF_SEASONS
	m_PaletteHeaderBg  2, 6, paletteData5940
	m_PaletteHeaderEnd

m_PaletteHeaderStart $7c, PALH_TILESET_SUBROSIA_INDOORS
	m_PaletteHeaderBg  2, 6, paletteData5970
	m_PaletteHeaderEnd

m_PaletteHeaderStart $7d, PALH_7d
	m_PaletteHeaderBg  2, 6, paletteData59a0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $7e, PALH_7e

m_PaletteHeaderStart $7f, PALH_SPR_LINK_STONE
	m_PaletteHeaderSpr 7, 1, paletteData4888
	m_PaletteHeaderEnd

m_PaletteHeaderStart $80, PALH_SPR_AQUAMENTUS
	m_PaletteHeaderSpr 6, 1, paletteData4890
	m_PaletteHeaderEnd

m_PaletteHeaderStart $81, PALH_SEASONS_81
	m_PaletteHeaderSpr 6, 1, paletteData4898
	m_PaletteHeaderEnd

m_PaletteHeaderStart $82, PALH_SEASONS_82
	m_PaletteHeaderSpr 6, 1, paletteData48a0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $83, PALH_SEASONS_83

m_PaletteHeaderStart $84, PALH_SEASONS_84
	m_PaletteHeaderSpr 6, 1, paletteData48a8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $85, PALH_SEASONS_85
	m_PaletteHeaderSpr 6, 1, paletteData48b0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $86, PALH_SEASONS_86
	m_PaletteHeaderSpr 6, 1, $deb0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $87, PALH_SEASONS_87
	m_PaletteHeaderSpr 6, 1, paletteData48b8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $88, PALH_SEASONS_88
	m_PaletteHeaderSpr 6, 1, paletteData48c0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $89, PALH_SEASONS_89
	m_PaletteHeaderSpr 6, 1, paletteData48c8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $8a, PALH_SEASONS_8a
	m_PaletteHeaderSpr 6, 1, paletteData48d0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $8b, PALH_SEASONS_8b
	m_PaletteHeaderSpr 6, 1, paletteData48d8
	m_PaletteHeaderBg  7, 1, paletteData5700
	m_PaletteHeaderEnd

m_PaletteHeaderStart $8c, PALH_SEASONS_8c
	m_PaletteHeaderSpr 6, 1, paletteData48e0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $8d, PALH_BG_DRAGON_ONOX
	m_PaletteHeaderBg  0, 8, paletteData48e8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $8e, PALH_TILESET_ROOM_OF_RITES_ICE
	m_PaletteHeaderBg  2, 6, paletteData56d0
	m_PaletteHeaderBg  6, 1, paletteData4928
	m_PaletteHeaderEnd

m_PaletteHeaderStart $8f, PALH_SEASONS_8f
	m_PaletteHeaderBg  0, 6, paletteData4800
	m_PaletteHeaderSpr 0, 6, paletteData4800
	m_PaletteHeaderEnd

m_PaletteHeaderStart $90, PALH_SEASONS_90
	m_PaletteHeaderBg  0, 8, paletteData41f8
	m_PaletteHeaderSpr 0, 8, paletteData4238
	m_PaletteHeaderEnd

m_PaletteHeaderStart $91, PALH_SEASONS_91
	m_PaletteHeaderBg  0, 1, paletteData4830
	m_PaletteHeaderBg  2, 6, paletteData56a0
	m_PaletteHeaderSpr 0, 6, standardSpritePaletteData
	m_PaletteHeaderSpr 6, 1, paletteData4468
	m_PaletteHeaderEnd

m_PaletteHeaderStart $92, PALH_SEASONS_92
	m_PaletteHeaderBg  0, 8, paletteData4278
	m_PaletteHeaderSpr 0, 8, paletteData4378
	m_PaletteHeaderEnd

m_PaletteHeaderStart $93, PALH_SEASONS_93
	m_PaletteHeaderBg  0, 8, paletteData42b8
	m_PaletteHeaderSpr 0, 8, paletteData43b8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $94, PALH_SEASONS_94
	m_PaletteHeaderBg  0, 8, paletteData4338
	m_PaletteHeaderSpr 2, 3, paletteData43f8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $95, PALH_SEASONS_95
	m_PaletteHeaderBg  0, 8, paletteData4470
	m_PaletteHeaderSpr 0, 7, paletteData44b0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $96, PALH_SEASONS_96
	m_PaletteHeaderBg  0, 8, paletteData42f8
	m_PaletteHeaderSpr 0, 8, paletteData42f8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $97, PALH_SEASONS_97
	m_PaletteHeaderBg  2, 6, paletteData54c0
	m_PaletteHeaderSpr 6, 1, paletteData48c8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $98, PALH_SEASONS_98
	m_PaletteHeaderBg  1, 7, paletteData4410
	m_PaletteHeaderSpr 1, 4, paletteData4448
	m_PaletteHeaderEnd

m_PaletteHeaderStart $99, PALH_SEASONS_99
	m_PaletteHeaderBg  5, 2, paletteData5220
	m_PaletteHeaderBg  3, 1, paletteData5230
	m_PaletteHeaderEnd

m_PaletteHeaderStart $9a, PALH_SEASONS_9a
	m_PaletteHeaderBg  5, 2, paletteData5238
	m_PaletteHeaderBg  3, 1, paletteData5248
	m_PaletteHeaderSpr 7, 1, paletteData5ca0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $9b, PALH_SEASONS_9b
	m_PaletteHeaderSpr 6, 1, paletteData5c78
	m_PaletteHeaderEnd

m_PaletteHeaderStart $9c, PALH_SEASONS_9c
	m_PaletteHeaderBg  0, 4, paletteData45b0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $9d, PALH_SEASONS_9d
	m_PaletteHeaderBg  1, 7, paletteData4508
	m_PaletteHeaderSpr 1, 6, paletteData4578
	m_PaletteHeaderEnd

m_PaletteHeaderStart $9e, PALH_SEASONS_9e
	m_PaletteHeaderBg  1, 7, paletteData4540
	m_PaletteHeaderSpr 1, 1, paletteData45a8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $9f, PALH_SEASONS_9f
	m_PaletteHeaderBg  0, 8, paletteData4740
	m_PaletteHeaderSpr 0, 8, paletteData4780
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a0, PALH_SEASONS_a0
	m_PaletteHeaderBg  0, 5, paletteData46c0
	m_PaletteHeaderSpr 0, 2, paletteData46e8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a1, PALH_SEASONS_a1
	m_PaletteHeaderBg  0, 4, paletteData4620
	m_PaletteHeaderSpr 0, 2, paletteData4640
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a2, PALH_SEASONS_a2
	m_PaletteHeaderBg  0, 4, paletteData4620
	m_PaletteHeaderSpr 0, 2, paletteData4650
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a3, PALH_SEASONS_a3
	m_PaletteHeaderBg  0, 4, paletteData4620
	m_PaletteHeaderSpr 0, 2, paletteData4660
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a4, PALH_SEASONS_a4
	m_PaletteHeaderBg  0, 4, paletteData4620
	m_PaletteHeaderSpr 0, 2, paletteData4670
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a5, PALH_SEASONS_a5
	m_PaletteHeaderBg  0, 4, paletteData4620
	m_PaletteHeaderSpr 0, 2, paletteData4640
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a6, PALH_SEASONS_a6
	m_PaletteHeaderBg  0, 4, paletteData4620
	m_PaletteHeaderSpr 0, 2, paletteData4650
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a7, PALH_SEASONS_a7
	m_PaletteHeaderBg  0, 4, paletteData4620
	m_PaletteHeaderSpr 0, 2, paletteData4660
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a8, PALH_SEASONS_a8
	m_PaletteHeaderBg  0, 4, paletteData4620
	m_PaletteHeaderSpr 0, 2, paletteData4670
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a9, PALH_SEASONS_a9
	m_PaletteHeaderBg  2, 6, paletteData4710
	m_PaletteHeaderEnd

m_PaletteHeaderStart $aa, PALH_SEASONS_aa
	m_PaletteHeaderBg  0, 6, paletteData47c0
	m_PaletteHeaderSpr 4, 4, paletteData47e0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $ab, PALH_SEASONS_ab
	m_PaletteHeaderSpr 7, 1, paletteData5e48
	m_PaletteHeaderEnd

m_PaletteHeaderStart $ac, PALH_ac
	m_PaletteHeaderSpr 6, 2, paletteData5e30
	m_PaletteHeaderEnd

m_PaletteHeaderStart $ad, PALH_SEASONS_ad
	m_PaletteHeaderBg  0, 8, paletteData45d0
	m_PaletteHeaderSpr 0, 8, paletteData45d0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $ae, PALH_SEASONS_ae
	m_PaletteHeaderBg  0, 8, paletteData4680
	m_PaletteHeaderEnd

m_PaletteHeaderStart $af, PALH_SEASONS_af
	m_PaletteHeaderSpr 7, 1, paletteData5e40
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b0, PALH_SEASONS_b0
	m_PaletteHeaderSpr 6, 1, paletteData5e28
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b1, PALH_SEASONS_b1
	m_PaletteHeaderBg  7, 1, paletteData5700
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b2, PALH_SEASONS_b2
	m_PaletteHeaderBg  7, 1, paletteData5708
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b3, PALH_SEASONS_b3
	m_PaletteHeaderBg  7, 1, paletteData5710
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b4, PALH_SEASONS_b4
	m_PaletteHeaderBg  7, 1, paletteData5718
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b5, PALH_SEASONS_b5
	m_PaletteHeaderBg  7, 1, paletteData5720
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b6, PALH_SEASONS_b6
	m_PaletteHeaderBg  7, 1, paletteData5728
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b7, PALH_SEASONS_b7
	m_PaletteHeaderBg  7, 1, paletteData5730
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b8, PALH_SEASONS_b8
	m_PaletteHeaderBg  7, 1, paletteData5738
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b9, PALH_SEASONS_b9
	m_PaletteHeaderBg  7, 1, paletteData5740
	m_PaletteHeaderEnd

m_PaletteHeaderStart $ba, PALH_SEASONS_ba
	m_PaletteHeaderBg  7, 1, paletteData5748
	m_PaletteHeaderEnd

m_PaletteHeaderStart $bb, PALH_SEASONS_bb
	m_PaletteHeaderBg  7, 1, paletteData5750
	m_PaletteHeaderEnd

m_PaletteHeaderStart $bc, PALH_SEASONS_bc
	m_PaletteHeaderBg  7, 1, paletteData5758
	m_PaletteHeaderEnd

m_PaletteHeaderStart $bd, PALH_SEASONS_bd
	m_PaletteHeaderBg  1, 1, paletteData4880
	m_PaletteHeaderEnd
