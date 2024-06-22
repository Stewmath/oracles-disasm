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
	.db $0f, $01, $01, GFXH_TILESET_OVERWORLD_PRESENT, PALH_10, $00, $00, $00 ; 0x00
	.db $0f, $01, $03, GFXH_TILESET_OVERWORLD_PRESENT, PALH_22, $01, $00, $01 ; 0x01
	.db $0f, $01, $04, GFXH_TILESET_OVERWORLD_PRESENT, PALH_24, $02, $00, $01 ; 0x02
	.db $0f, $01, $05, GFXH_TILESET_OVERWORLD_PRESENT, PALH_2d, $14, $00, $01 ; 0x03
	.db $0f, $01, $06, GFXH_TILESET_OVERWORLD_PRESENT, PALH_12, $03, $00, $03 ; 0x04
	.db $0f, $01, $07, GFXH_TILESET_OVERWORLD_PRESENT, PALH_14, $04, $00, $01 ; 0x05
	.db $0f, $01, $08, GFXH_TILESET_OVERWORLD_PRESENT, PALH_16, $05, $00, $04 ; 0x06
	.db $0f, $01, $0b, GFXH_TILESET_OVERWORLD_PRESENT, PALH_2e, $19, $01, $01 ; 0x07
	.db $0f, $01, $09, GFXH_TILESET_OVERWORLD_PRESENT, PALH_28, $06, $00, $01 ; 0x08
	.db $0f, $01, $09, GFXH_TILESET_OVERWORLD_PRESENT, PALH_28, $06, $01, $01 ; 0x09
	.db $0f, $01, $0c, GFXH_TILESET_OVERWORLD_PRESENT, PALH_18, $08, $00, $01 ; 0x0a
	.db $0f, $01, $0c, GFXH_TILESET_OVERWORLD_PRESENT, PALH_18, $08, $01, $01 ; 0x0b
	.db $0f, $01, $0e, GFXH_TILESET_OVERWORLD_PRESENT, PALH_1c, $0a, $00, $03 ; 0x0c
	.db $0f, $01, $10, GFXH_TILESET_OVERWORLD_PRESENT, PALH_26, $0d, $00, $06 ; 0x0d
	.db $0f, $01, $10, GFXH_TILESET_OVERWORLD_PRESENT, PALH_26, $0d, $01, $06 ; 0x0e
	.db $0f, $01, $10, GFXH_TILESET_OVERWORLD_PRESENT, PALH_26, $0d, $03, $06 ; 0x0f
	.db $0f, $81, $02, GFXH_TILESET_OVERWORLD_PAST, PALH_11, $0f, $02, $00 ; 0x10
	.db $0f, $81, $02, GFXH_TILESET_OVERWORLD_PAST, PALH_11, $0f, $03, $00 ; 0x11
	.db $0f, $81, $02, GFXH_TILESET_OVERWORLD_PAST, PALH_2f, $0f, $02, $00 ; 0x12
	.db $0f, $81, $03, GFXH_TILESET_OVERWORLD_PAST, PALH_23, $01, $02, $01 ; 0x13
	.db $0f, $81, $04, GFXH_TILESET_OVERWORLD_PAST, PALH_25, $02, $02, $01 ; 0x14
	.db $0f, $81, $04, GFXH_TILESET_OVERWORLD_PAST, PALH_25, $02, $03, $01 ; 0x15
	.db $0f, $81, $05, GFXH_TILESET_OVERWORLD_PAST, PALH_33, $14, $02, $01 ; 0x16
	.db $0f, $81, $06, GFXH_TILESET_OVERWORLD_PAST, PALH_13, $03, $02, $03 ; 0x17
	.db $0f, $81, $07, GFXH_TILESET_OVERWORLD_PAST, PALH_15, $04, $02, $01 ; 0x18
	.db $0f, $81, $08, GFXH_TILESET_OVERWORLD_PAST, PALH_17, $05, $02, $04 ; 0x19
	.db $0f, $81, $09, GFXH_TILESET_OVERWORLD_PAST, PALH_29, $06, $02, $01 ; 0x1a
	.db $0f, $81, $09, GFXH_TILESET_OVERWORLD_PAST, PALH_29, $06, $03, $01 ; 0x1b
	.db $0f, $91, $09, GFXH_TILESET_OVERWORLD_PAST, PALH_29, $06, $02, $01 ; 0x1c
	.db $0f, $81, $0a, GFXH_TILESET_OVERWORLD_PAST, PALH_2a, $07, $02, $01 ; 0x1d
	.db $0f, $81, $0d, GFXH_TILESET_OVERWORLD_PAST, PALH_1b, $09, $02, $02 ; 0x1e
	.db $0f, $81, $0e, GFXH_TILESET_OVERWORLD_PAST, PALH_1d, $0a, $02, $03 ; 0x1f
	.db $0f, $81, $0f, GFXH_TILESET_OVERWORLD_PAST, PALH_1f, $0b, $02, $05 ; 0x20
	.db $0f, $81, $11, GFXH_TILESET_OVERWORLD_PAST, PALH_27, $0e, $02, $01 ; 0x21
	.db $0f, $02, $00, GFXH_TILESET_MAKU_TREE, PALH_30, $11, $00, $07 ; 0x22
	.db $0f, $02, $00, GFXH_TILESET_MAKU_TREE, PALH_30, $11, $01, $07 ; 0x23
	.db $0f, $02, $00, GFXH_TILESET_MAKU_TREE, PALH_30, $11, $03, $07 ; 0x24
	.db $0f, $02, $00, GFXH_TILESET_MAKU_TREE_TOP, PALH_31, $12, $00, $ff ; 0x25
	.db $0f, $82, $00, GFXH_TILESET_MAKU_TREE, PALH_30, $11, $02, $07 ; 0x26
	.db $af, $18, $00, GFXH_TILESET_BLACK_TOWER, PALH_60, $13, $04, $ff ; 0x27
	.db $1f, $04, $00, GFXH_TILESET_INDOORS, PALH_70, $15, $01, $10 ; 0x28
	.db $1f, $04, $00, GFXH_TILESET_INDOORS, PALH_71, $15, $01, $10 ; 0x29
	.db $1f, $84, $00, GFXH_TILESET_INDOORS, PALH_72, $15, $01, $10 ; 0x2a
	.db $1f, $04, $00, GFXH_TILESET_INDOORS, PALH_70, $15, $03, $10 ; 0x2b
	.db $1f, $04, $00, GFXH_TILESET_INDOORS, PALH_72, $15, $03, $10 ; 0x2c
	.db $1f, $04, $00, GFXH_TILESET_CAVE, PALH_73, $16, $01, $10 ; 0x2d
	.db $1f, $04, $00, GFXH_TILESET_CAVE, PALH_73, $16, $03, $10 ; 0x2e
	.db $1f, $04, $00, GFXH_TILESET_GORON_CAVE, PALH_73, $16, $03, $10 ; 0x2f
	.db $1f, $04, $00, GFXH_TILESET_MOBLIN_FORTRESS, PALH_75, $17, $01, $10 ; 0x30
	.db $1f, $44, $00, GFXH_TILESET_ZORA_PALACE, PALH_76, $18, $03, $10 ; 0x31
	.db $1f, $44, $00, GFXH_TILESET_ZORA_PALACE, PALH_79, $18, $01, $10 ; 0x32
	.db $1f, $44, $00, GFXH_TILESET_ZORA_PALACE, PALH_79, $18, $03, $10 ; 0x33
	.db $20, $08, $00, GFXH_TILESET_MAKU_PATH, PALH_40, $20, $04, $10 ; 0x34
	.db $2d, $88, $00, GFXH_TILESET_MAKU_PATH, PALH_4d, $20, $04, $10 ; 0x35
	.db $21, $08, $00, GFXH_TILESET_SPIRITS_GRAVE, PALH_41, $21, $04, $10 ; 0x36
	.db $22, $88, $00, GFXH_TILESET_WING_DUNGEON, PALH_42, $22, $04, $10 ; 0x37
	.db $23, $08, $00, GFXH_TILESET_MOONLIT_GROTTO, PALH_43, $23, $04, $10 ; 0x38
	.db $24, $08, $00, GFXH_TILESET_SKULL_DUNGEON, PALH_44, $24, $04, $10 ; 0x39
	.db $25, $08, $00, GFXH_TILESET_CROWN_DUNGEON, PALH_45, $25, $04, $10 ; 0x3a
	.db $26, $08, $00, GFXH_TILESET_MERMAIDS_CAVE, PALH_46, $26, $05, $10 ; 0x3b
	.db $2c, $88, $00, GFXH_TILESET_MERMAIDS_CAVE, PALH_4c, $26, $05, $10 ; 0x3c
	.db $2c, $c8, $00, GFXH_TILESET_MERMAIDS_CAVE, PALH_61, $26, $05, $13 ; 0x3d
	.db $27, $08, $00, GFXH_TILESET_JABU_JABUS_BELLY, PALH_47, $27, $05, $15 ; 0x3e
	.db $27, $48, $00, GFXH_TILESET_JABU_JABUS_BELLY, PALH_62, $27, $05, $15 ; 0x3f
	.db $28, $88, $00, GFXH_TILESET_ANCIENT_TOMB, PALH_48, $28, $05, $10 ; 0x40
	.db $28, $88, $14, GFXH_TILESET_ANCIENT_TOMB, PALH_63, $28, $05, $10 ; 0x41
	.db $28, $c8, $00, GFXH_TILESET_ANCIENT_TOMB, PALH_64, $28, $05, $13 ; 0x42
	.db $2f, $90, $00, GFXH_TILESET_BLACK_TOWER_TOP, PALH_49, $29, $04, $10 ; 0x43
	.db $2f, $90, $00, GFXH_TILESET_BLACK_TOWER_TOP, PALH_59, $29, $04, $10 ; 0x44
	.db $af, $98, $00, GFXH_TILESET_BLACK_TOWER_TOP, PALH_49, $29, $04, $14 ; 0x45
	.db $2a, $08, $00, GFXH_TILESET_ROOM_OF_RITES, PALH_4a, $2a, $05, $10 ; 0x46
	.db $2a, $08, $00, GFXH_TILESET_ROOM_OF_RITES, PALH_67, $2a, $05, $10 ; 0x47
	.db $2b, $08, $00, GFXH_TILESET_MAKU_PATH, PALH_4b, $20, $04, $10 ; 0x48
	.db $2b, $08, $00, GFXH_TILESET_MAKU_PATH, PALH_66, $20, $04, $10 ; 0x49
	.db $2b, $48, $00, GFXH_TILESET_MAKU_PATH, PALH_65, $20, $04, $11 ; 0x4a
	.db $3d, $a8, $00, GFXH_TILESET_SIDESCROLL, PALH_52, $32, $04, $ff ; 0x4b
	.db $31, $28, $00, GFXH_TILESET_SIDESCROLL, PALH_51, $32, $04, $12 ; 0x4c
	.db $32, $28, $00, GFXH_TILESET_SIDESCROLL, PALH_52, $32, $04, $12 ; 0x4d
	.db $34, $28, $00, GFXH_TILESET_SIDESCROLL, PALH_53, $32, $04, $12 ; 0x4e
	.db $35, $28, $00, GFXH_TILESET_SIDESCROLL, PALH_53, $32, $04, $12 ; 0x4f
	.db $36, $28, $00, GFXH_TILESET_SIDESCROLL, PALH_50, $32, $05, $12 ; 0x50
	.db $3c, $a8, $00, GFXH_TILESET_SIDESCROLL, PALH_56, $32, $05, $12 ; 0x51
	.db $37, $a8, $00, GFXH_TILESET_SIDESCROLL, PALH_54, $32, $05, $12 ; 0x52
	.db $38, $a8, $00, GFXH_TILESET_SIDESCROLL, PALH_55, $32, $05, $12 ; 0x53
	.db $3b, $28, $00, GFXH_TILESET_SIDESCROLL, PALH_52, $32, $04, $ff ; 0x54
	.db $2e, $18, $00, GFXH_TILESET_INDOORS, PALH_70, $15, $05, $10 ; 0x55
	.db $2f, $10, $00, GFXH_TILESET_INDOORS, PALH_70, $15, $05, $10 ; 0x56
	.db $2f, $12, $00, GFXH_TILESET_INDOORS, PALH_77, $15, $05, $10 ; 0x57
	.db $2e, $18, $00, GFXH_TILESET_CAVE, PALH_73, $16, $05, $10 ; 0x58
	.db $2f, $10, $00, GFXH_TILESET_CAVE, PALH_73, $16, $05, $10 ; 0x59
	.db $2e, $18, $00, GFXH_TILESET_MOBLIN_FORTRESS, PALH_74, $17, $05, $10 ; 0x5a
	.db $2f, $50, $00, GFXH_TILESET_ZORA_PALACE, PALH_76, $18, $05, $10 ; 0x5b
	.db $3f, $30, $00, GFXH_TILESET_SIDESCROLL, PALH_57, $32, $05, $12 ; 0x5c
	.db $3f, $30, $00, GFXH_TILESET_SIDESCROLL, PALH_58, $32, $05, $12 ; 0x5d
	.db $3e, $38, $00, GFXH_TILESET_SIDESCROLL, PALH_57, $32, $05, $12 ; 0x5e
	.db $4f, $41, $13, GFXH_TILESET_UNDERWATER_PRESENT, PALH_2b, $10, $01, $08 ; 0x5f
	.db $4f, $c1, $00, GFXH_TILESET_UNDERWATER_PAST, PALH_2c, $10, $03, $08 ; 0x60
	.db $4f, $d1, $13, GFXH_TILESET_UNDERWATER_PRESENT, PALH_2c, $10, $03, $08 ; 0x61
	.db $4f, $41, $12, GFXH_TILESET_UNDERWATER_PRESENT, PALH_32, $1a, $01, $08 ; 0x62
	.db $1f, $04, $00, GFXH_TILESET_CAVE, PALH_78, $16, $01, $10 ; 0x63
	.db $1f, $04, $00, GFXH_TILESET_CAVE, PALH_78, $16, $03, $10 ; 0x64
	.db $2e, $18, $00, GFXH_TILESET_CAVE, PALH_78, $16, $05, $10 ; 0x65
	.db $1f, $04, $00, GFXH_TILESET_GORON_CAVE, PALH_73, $16, $02, $10 ; 0x66
