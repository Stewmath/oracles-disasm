; Data format:
;   b0: bits 4-7: Value for wActiveCollisions variable.
;                 Affects most collision properties other than basic solidity.
;       bits 0-3: Value for wDungeonIndex ($f = no dungeon)
;   b1: Flags (see constants/tilesetFlags.s)
;   b2: Unique GFX index (see data/{game}/uniqueGfxHeaders.s)
;   b3: Main GFX index (see data/{game}/gfxHeaders.s)
;   b4: Palette index (see data/{game}/paletteHeaders.s)
;   b5: Tile mapping/collision data index (see data/{game}/tilesetMappings.s)
;   b6: Layout group (will load room layout from rooms/.../roomXXYY.bin,
;       where XX = layout group, YY = room index for current overworld)
;   b7: Animation data index (see data/{game}/animationGroups.s)

tilesetData:
	; 0x00
	.db $0f, $01
	.db UNIQUE_GFXH_LYNNA_CITY_1
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_10
	.db $00, $00, $00

	; 0x01
	.db $0f, $01
	.db UNIQUE_GFXH_YOLL_GRAVEYARD
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_22
	.db $01, $00, $01

	; 0x02
	.db $0f, $01
	.db UNIQUE_GFXH_BLACK_TOWER_OUTSIDE
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_24
	.db $02, $00, $01

	; 0x03
	.db $0f, $01
	.db UNIQUE_GFXH_FOREST_OF_TIME
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_2d
	.db $14, $00, $01

	; 0x04
	.db $0f, $01
	.db UNIQUE_GFXH_FAIRY_FOREST
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_12
	.db $03, $00, $03

	; 0x05
	.db $0f, $01
	.db UNIQUE_GFXH_TOKAY_ISLAND
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_14
	.db $04, $00, $01

	; 0x06
	.db $0f, $01
	.db UNIQUE_GFXH_SYMMETRY_CITY_RUINED
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_16
	.db $05, $00, $04

	; 0x07
	.db $0f, $01
	.db UNIQUE_GFXH_SYMMETRY_CITY_RESTORED
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_2e
	.db $19, $01, $01

	; 0x08
	.db $0f, $01
	.db UNIQUE_GFXH_TALUS_PEAKS
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_28
	.db $06, $00, $01

	; 0x09
	.db $0f, $01
	.db UNIQUE_GFXH_TALUS_PEAKS
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_28
	.db $06, $01, $01

	; 0x0a
	.db $0f, $01
	.db UNIQUE_GFXH_ROLLING_RIDGE_PRESENT
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_18
	.db $08, $00, $01

	; 0x0b
	.db $0f, $01
	.db UNIQUE_GFXH_ROLLING_RIDGE_PRESENT
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_18
	.db $08, $01, $01

	; 0x0c
	.db $0f, $01
	.db UNIQUE_GFXH_EYEGLASS_LIBRARY
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_1c
	.db $0a, $00, $03

	; 0x0d
	.db $0f, $01
	.db UNIQUE_GFXH_NUUN_HIGHLANDS
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_26
	.db $0d, $00, $06

	; 0x0e
	.db $0f, $01
	.db UNIQUE_GFXH_NUUN_HIGHLANDS
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_26
	.db $0d, $01, $06

	; 0x0f
	.db $0f, $01
	.db UNIQUE_GFXH_NUUN_HIGHLANDS
	.db GFXH_TILESET_OVERWORLD_PRESENT
	.db PALH_26
	.db $0d, $03, $06

	; 0x10
	.db $0f, $81
	.db UNIQUE_GFXH_LYNNA_CITY_2
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_11
	.db $0f, $02, $00

	; 0x11
	.db $0f, $81
	.db UNIQUE_GFXH_LYNNA_CITY_2
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_11
	.db $0f, $03, $00

	; 0x12
	.db $0f, $81
	.db UNIQUE_GFXH_LYNNA_CITY_2
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_2f
	.db $0f, $02, $00

	; 0x13
	.db $0f, $81
	.db UNIQUE_GFXH_YOLL_GRAVEYARD
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_23
	.db $01, $02, $01

	; 0x14
	.db $0f, $81
	.db UNIQUE_GFXH_BLACK_TOWER_OUTSIDE
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_25
	.db $02, $02, $01

	; 0x15
	.db $0f, $81
	.db UNIQUE_GFXH_BLACK_TOWER_OUTSIDE
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_25
	.db $02, $03, $01

	; 0x16
	.db $0f, $81
	.db UNIQUE_GFXH_FOREST_OF_TIME
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_33
	.db $14, $02, $01

	; 0x17
	.db $0f, $81
	.db UNIQUE_GFXH_FAIRY_FOREST
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_13
	.db $03, $02, $03

	; 0x18
	.db $0f, $81
	.db UNIQUE_GFXH_TOKAY_ISLAND
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_15
	.db $04, $02, $01

	; 0x19
	.db $0f, $81
	.db UNIQUE_GFXH_SYMMETRY_CITY_RUINED
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_17
	.db $05, $02, $04

	; 0x1a
	.db $0f, $81
	.db UNIQUE_GFXH_TALUS_PEAKS
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_29
	.db $06, $02, $01

	; 0x1b
	.db $0f, $81
	.db UNIQUE_GFXH_TALUS_PEAKS
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_29
	.db $06, $03, $01

	; 0x1c
	.db $0f, $91
	.db UNIQUE_GFXH_TALUS_PEAKS
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_29
	.db $06, $02, $01

	; 0x1d
	.db $0f, $81
	.db UNIQUE_GFXH_TALUS_PEAKS_PAST
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_2a
	.db $07, $02, $01

	; 0x1e
	.db $0f, $81
	.db UNIQUE_GFXH_ROLLING_RIDGE_PAST
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_1b
	.db $09, $02, $02

	; 0x1f
	.db $0f, $81
	.db UNIQUE_GFXH_EYEGLASS_LIBRARY
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_1d
	.db $0a, $02, $03

	; 0x20
	.db $0f, $81
	.db UNIQUE_GFXH_SEA_OF_NO_RETURN
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_1f
	.db $0b, $02, $05

	; 0x21
	.db $0f, $81
	.db UNIQUE_GFXH_AMBIS_PALACE
	.db GFXH_TILESET_OVERWORLD_PAST
	.db PALH_27
	.db $0e, $02, $01

	; 0x22
	.db $0f, $02
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MAKU_TREE
	.db PALH_30
	.db $11, $00, $07

	; 0x23
	.db $0f, $02
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MAKU_TREE
	.db PALH_30
	.db $11, $01, $07

	; 0x24
	.db $0f, $02
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MAKU_TREE
	.db PALH_30
	.db $11, $03, $07

	; 0x25
	.db $0f, $02
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MAKU_TREE_TOP
	.db PALH_31
	.db $12, $00, $ff

	; 0x26
	.db $0f, $82
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MAKU_TREE
	.db PALH_30
	.db $11, $02, $07

	; 0x27
	.db $af, $18
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_BLACK_TOWER
	.db PALH_60
	.db $13, $04, $ff

	; 0x28
	.db $1f, $04
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_INDOORS
	.db PALH_70
	.db $15, $01, $10

	; 0x29
	.db $1f, $04
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_INDOORS
	.db PALH_71
	.db $15, $01, $10

	; 0x2a
	.db $1f, $84
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_INDOORS
	.db PALH_72
	.db $15, $01, $10

	; 0x2b
	.db $1f, $04
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_INDOORS
	.db PALH_70
	.db $15, $03, $10

	; 0x2c
	.db $1f, $04
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_INDOORS
	.db PALH_72
	.db $15, $03, $10

	; 0x2d
	.db $1f, $04
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_CAVE
	.db PALH_73
	.db $16, $01, $10

	; 0x2e
	.db $1f, $04
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_CAVE
	.db PALH_73
	.db $16, $03, $10

	; 0x2f
	.db $1f, $04
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_GORON_CAVE
	.db PALH_73
	.db $16, $03, $10

	; 0x30
	.db $1f, $04
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MOBLIN_FORTRESS
	.db PALH_75
	.db $17, $01, $10

	; 0x31
	.db $1f, $44
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_ZORA_PALACE
	.db PALH_76
	.db $18, $03, $10

	; 0x32
	.db $1f, $44
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_ZORA_PALACE
	.db PALH_79
	.db $18, $01, $10

	; 0x33
	.db $1f, $44
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_ZORA_PALACE
	.db PALH_79
	.db $18, $03, $10

	; 0x34
	.db $20, $08
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MAKU_PATH
	.db PALH_40
	.db $20, $04, $10

	; 0x35
	.db $2d, $88
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MAKU_PATH
	.db PALH_4d
	.db $20, $04, $10

	; 0x36
	.db $21, $08
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SPIRITS_GRAVE
	.db PALH_41
	.db $21, $04, $10

	; 0x37
	.db $22, $88
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_WING_DUNGEON
	.db PALH_42
	.db $22, $04, $10

	; 0x38
	.db $23, $08
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MOONLIT_GROTTO
	.db PALH_43
	.db $23, $04, $10

	; 0x39
	.db $24, $08
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SKULL_DUNGEON
	.db PALH_44
	.db $24, $04, $10

	; 0x3a
	.db $25, $08
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_CROWN_DUNGEON
	.db PALH_45
	.db $25, $04, $10

	; 0x3b
	.db $26, $08
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MERMAIDS_CAVE
	.db PALH_46
	.db $26, $05, $10

	; 0x3c
	.db $2c, $88
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MERMAIDS_CAVE
	.db PALH_4c
	.db $26, $05, $10

	; 0x3d
	.db $2c, $c8
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MERMAIDS_CAVE
	.db PALH_61
	.db $26, $05, $13

	; 0x3e
	.db $27, $08
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_JABU_JABUS_BELLY
	.db PALH_47
	.db $27, $05, $15

	; 0x3f
	.db $27, $48
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_JABU_JABUS_BELLY
	.db PALH_62
	.db $27, $05, $15

	; 0x40
	.db $28, $88
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_ANCIENT_TOMB
	.db PALH_48
	.db $28, $05, $10

	; 0x41
	.db $28, $88
	.db UNIQUE_GFXH_14
	.db GFXH_TILESET_ANCIENT_TOMB
	.db PALH_63
	.db $28, $05, $10

	; 0x42
	.db $28, $c8
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_ANCIENT_TOMB
	.db PALH_64
	.db $28, $05, $13

	; 0x43
	.db $2f, $90
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_BLACK_TOWER_TOP
	.db PALH_49
	.db $29, $04, $10

	; 0x44
	.db $2f, $90
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_BLACK_TOWER_TOP
	.db PALH_59
	.db $29, $04, $10

	; 0x45
	.db $af, $98
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_BLACK_TOWER_TOP
	.db PALH_49
	.db $29, $04, $14

	; 0x46
	.db $2a, $08
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_ROOM_OF_RITES
	.db PALH_4a
	.db $2a, $05, $10

	; 0x47
	.db $2a, $08
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_ROOM_OF_RITES
	.db PALH_67
	.db $2a, $05, $10

	; 0x48
	.db $2b, $08
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MAKU_PATH
	.db PALH_4b
	.db $20, $04, $10

	; 0x49
	.db $2b, $08
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MAKU_PATH
	.db PALH_66
	.db $20, $04, $10

	; 0x4a
	.db $2b, $48
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MAKU_PATH
	.db PALH_65
	.db $20, $04, $11

	; 0x4b
	.db $3d, $a8
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SIDESCROLL
	.db PALH_52
	.db $32, $04, $ff

	; 0x4c
	.db $31, $28
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SIDESCROLL
	.db PALH_51
	.db $32, $04, $12

	; 0x4d
	.db $32, $28
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SIDESCROLL
	.db PALH_52
	.db $32, $04, $12

	; 0x4e
	.db $34, $28
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SIDESCROLL
	.db PALH_53
	.db $32, $04, $12

	; 0x4f
	.db $35, $28
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SIDESCROLL
	.db PALH_53
	.db $32, $04, $12

	; 0x50
	.db $36, $28
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SIDESCROLL
	.db PALH_50
	.db $32, $05, $12

	; 0x51
	.db $3c, $a8
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SIDESCROLL
	.db PALH_56
	.db $32, $05, $12

	; 0x52
	.db $37, $a8
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SIDESCROLL
	.db PALH_54
	.db $32, $05, $12

	; 0x53
	.db $38, $a8
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SIDESCROLL
	.db PALH_55
	.db $32, $05, $12

	; 0x54
	.db $3b, $28
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SIDESCROLL
	.db PALH_52
	.db $32, $04, $ff

	; 0x55
	.db $2e, $18
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_INDOORS
	.db PALH_70
	.db $15, $05, $10

	; 0x56
	.db $2f, $10
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_INDOORS
	.db PALH_70
	.db $15, $05, $10

	; 0x57
	.db $2f, $12
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_INDOORS
	.db PALH_77
	.db $15, $05, $10

	; 0x58
	.db $2e, $18
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_CAVE
	.db PALH_73
	.db $16, $05, $10

	; 0x59
	.db $2f, $10
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_CAVE
	.db PALH_73
	.db $16, $05, $10

	; 0x5a
	.db $2e, $18
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_MOBLIN_FORTRESS
	.db PALH_74
	.db $17, $05, $10

	; 0x5b
	.db $2f, $50
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_ZORA_PALACE
	.db PALH_76
	.db $18, $05, $10

	; 0x5c
	.db $3f, $30
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SIDESCROLL
	.db PALH_57
	.db $32, $05, $12

	; 0x5d
	.db $3f, $30
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SIDESCROLL
	.db PALH_58
	.db $32, $05, $12

	; 0x5e
	.db $3e, $38
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_SIDESCROLL
	.db PALH_57
	.db $32, $05, $12

	; 0x5f
	.db $4f, $41
	.db UNIQUE_GFXH_UNDERWATER
	.db GFXH_TILESET_UNDERWATER_PRESENT
	.db PALH_2b
	.db $10, $01, $08

	; 0x60
	.db $4f, $c1
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_UNDERWATER_PAST
	.db PALH_2c
	.db $10, $03, $08

	; 0x61
	.db $4f, $d1
	.db UNIQUE_GFXH_UNDERWATER
	.db GFXH_TILESET_UNDERWATER_PRESENT
	.db PALH_2c
	.db $10, $03, $08

	; 0x62
	.db $4f, $41
	.db UNIQUE_GFXH_JABU_JABU_OUTSIDE
	.db GFXH_TILESET_UNDERWATER_PRESENT
	.db PALH_32
	.db $1a, $01, $08

	; 0x63
	.db $1f, $04
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_CAVE
	.db PALH_78
	.db $16, $01, $10

	; 0x64
	.db $1f, $04
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_CAVE
	.db PALH_78
	.db $16, $03, $10

	; 0x65
	.db $2e, $18
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_CAVE
	.db PALH_78
	.db $16, $05, $10

	; 0x66
	.db $1f, $04
	.db UNIQUE_GFXH_NONE
	.db GFXH_TILESET_GORON_CAVE
	.db PALH_73
	.db $16, $02, $10
