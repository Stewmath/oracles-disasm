; TODO: Finish labelling these
;
; Naming conventions:
; - PALH_TILESET: Palettes used by tilesets, should load bg palettes 2-7.
;                 May also load a sprite palette or two (ie. PALH_TILESET_BIGGORON)
; - PALH_BG:      Loads bg palettes only (not used for tilesets)
; - PALH_SPR:     Loads sprite palettes only
; - PALH:         If none of the above, could load both sprite & bg palettes (or not yet categorized)

.define NUM_PALETTE_HEADERS $cb

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
	m_PaletteHeaderBg  0, 1, paletteData5960
	m_PaletteHeaderSpr 0, 1, paletteData5960
	m_PaletteHeaderEnd

m_PaletteHeaderStart $03, PALH_03
	m_PaletteHeaderBg  0, 8, paletteData4018
	m_PaletteHeaderSpr 0, 8, paletteData4058
	m_PaletteHeaderEnd

m_PaletteHeaderStart $04, PALH_04
	m_PaletteHeaderBg  0, 4, paletteData4648
	m_PaletteHeaderEnd

m_PaletteHeaderStart $05, PALH_05
	m_PaletteHeaderBg  0, 1, paletteData48e0
	m_PaletteHeaderBg  2, 5, paletteData5878
	m_PaletteHeaderSpr 0, 4, standardSpritePaletteData
	m_PaletteHeaderSpr 4, 3, paletteData5858
	m_PaletteHeaderEnd

m_PaletteHeaderStart $06, PALH_06
	m_PaletteHeaderBg  0, 1, paletteData48e0
	m_PaletteHeaderBg  2, 5, paletteData58a0
	m_PaletteHeaderSpr 0, 4, standardSpritePaletteData
	m_PaletteHeaderSpr 4, 3, paletteData5858
	m_PaletteHeaderEnd

m_PaletteHeaderStart $07, PALH_07
	m_PaletteHeaderBg  0, 8, paletteData4098
	m_PaletteHeaderSpr 0, 8, paletteData4138
	m_PaletteHeaderEnd

m_PaletteHeaderStart $08, PALH_08
	m_PaletteHeaderBg  0, 8, paletteData40d8
	m_PaletteHeaderSpr 0, 8, paletteData4138
	m_PaletteHeaderEnd

m_PaletteHeaderStart $09, PALH_09
	m_PaletteHeaderBg  2, 4, paletteData4118
	m_PaletteHeaderSpr 0, 6, standardSpritePaletteData
	m_PaletteHeaderEnd

m_PaletteHeaderStart $0a, PALH_0a
	m_PaletteHeaderBg  0, 2, paletteData48e0
	m_PaletteHeaderBg  2, 6, standardSpritePaletteData
	m_PaletteHeaderSpr 0, 6, standardSpritePaletteData
	m_PaletteHeaderEnd

m_PaletteHeaderStart $0b, PALH_0b
	m_PaletteHeaderSpr 0, 4, standardSpritePaletteData
	m_PaletteHeaderSpr 2, 1, paletteData43f0
	m_PaletteHeaderSpr 4, 3, paletteData47a8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $0c, PALH_0c
	m_PaletteHeaderBg  0, 8, paletteData49b0
	m_PaletteHeaderSpr 0, 8, paletteData49f0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $0d, PALH_0d
	m_PaletteHeaderBg  1, 1, paletteData4928
	m_PaletteHeaderEnd

m_PaletteHeaderStart $0e, PALH_0e
	m_PaletteHeaderBg  1, 1, paletteData4920
	m_PaletteHeaderEnd

m_PaletteHeaderStart $0f, PALH_0f
	m_PaletteHeaderBg  0, 1, paletteData48e0
	m_PaletteHeaderSpr 0, 6, standardSpritePaletteData
	m_PaletteHeaderEnd

m_PaletteHeaderStart $10, PALH_TILESET_LYNNA_CITY
	m_PaletteHeaderBg  2, 6, paletteData4a30
	m_PaletteHeaderEnd

m_PaletteHeaderStart $11, PALH_TILESET_LYNNA_VILLAGE
	m_PaletteHeaderBg  2, 6, paletteData4a60
	m_PaletteHeaderEnd

m_PaletteHeaderStart $12, PALH_TILESET_FAIRIES_FOREST
	m_PaletteHeaderBg  2, 6, paletteData4bb0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $13, PALH_TILESET_DEKU_FOREST
	m_PaletteHeaderBg  2, 6, paletteData4be0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $14, PALH_TILESET_CRESCENT_ISLAND_PRESENT
	m_PaletteHeaderBg  2, 6, paletteData4c10
	m_PaletteHeaderEnd

m_PaletteHeaderStart $15, PALH_TILESET_CRESCENT_ISLAND_PAST
	m_PaletteHeaderBg  2, 6, paletteData4c40
	m_PaletteHeaderEnd

m_PaletteHeaderStart $16, PALH_TILESET_SYMMETRY_CITY_RUINED
	m_PaletteHeaderBg  2, 6, paletteData4c70
	m_PaletteHeaderEnd

m_PaletteHeaderStart $17, PALH_TILESET_SYMMETRY_CITY_PAST
	m_PaletteHeaderBg  2, 6, paletteData4ca0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $18, PALH_TILESET_ROLLING_RIDGE_PRESENT
	m_PaletteHeaderBg  2, 6, paletteData4d90
	m_PaletteHeaderEnd

m_PaletteHeaderStart $19, PALH_19
	m_PaletteHeaderBg  2, 6, paletteData4d90
	m_PaletteHeaderEnd

m_PaletteHeaderStart $1a, PALH_1a

m_PaletteHeaderStart $1b, PALH_TILESET_ROLLING_RIDGE_PAST
	m_PaletteHeaderBg  2, 6, paletteData4dc0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $1c, PALH_TILESET_EYEGLASS_LIBRARY_OUTSIDE_PRESENT
	m_PaletteHeaderBg  2, 6, paletteData4df0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $1d, PALH_TILESET_EYEGLASS_LIBRARY_OUTSIDE_PAST
	m_PaletteHeaderBg  2, 6, paletteData4e20
	m_PaletteHeaderEnd

m_PaletteHeaderStart $1e, PALH_1e

m_PaletteHeaderStart $1f, PALH_TILESET_SEA_OF_NO_RETURN
	m_PaletteHeaderBg  2, 6, paletteData4e50
	m_PaletteHeaderEnd

m_PaletteHeaderStart $20, PALH_20
	m_PaletteHeaderBg  2, 6, paletteData4a30
	m_PaletteHeaderEnd

m_PaletteHeaderStart $21, PALH_21
	m_PaletteHeaderBg  2, 6, paletteData4a30
	m_PaletteHeaderEnd

m_PaletteHeaderStart $22, PALH_TILESET_YOLL_GRAVEYARD
	m_PaletteHeaderBg  2, 6, paletteData4a90
	m_PaletteHeaderEnd

m_PaletteHeaderStart $23, PALH_TILESET_YOLL_GRAVEYARD_ALTERNATE
	m_PaletteHeaderBg  2, 6, paletteData4a90
	m_PaletteHeaderEnd

m_PaletteHeaderStart $24, PALH_TILESET_BLACK_TOWER_OUTSIDE_PRESENT
	m_PaletteHeaderBg  2, 6, paletteData4ac0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $25, PALH_TILESET_BLACK_TOWER_OUTSIDE_PAST
	m_PaletteHeaderBg  2, 6, paletteData4af0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $26, PALH_TILESET_NUUN_HIGHLANDS
	m_PaletteHeaderBg  2, 6, paletteData4f10
	m_PaletteHeaderEnd

m_PaletteHeaderStart $27, PALH_TILESET_AMBIS_PALACE_OUTSIDE
	m_PaletteHeaderBg  2, 6, paletteData4f40
	m_PaletteHeaderEnd

m_PaletteHeaderStart $28, PALH_TILESET_TALUS_PEAKS_PRESENT
	m_PaletteHeaderBg  2, 6, paletteData4cd0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $29, PALH_TILESET_TALUS_PEAKS_PAST
	m_PaletteHeaderBg  2, 6, paletteData4d00
	m_PaletteHeaderEnd

m_PaletteHeaderStart $2a, PALH_TILESET_TALUS_PEAKS_PAST_ALTERNATE
	m_PaletteHeaderBg  2, 6, paletteData4d30
	m_PaletteHeaderEnd

m_PaletteHeaderStart $2b, PALH_TILESET_UNDERWATER_PRESENT
	m_PaletteHeaderBg  2, 6, paletteData4eb0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $2c, PALH_TILESET_UNDERWATER_PAST
	m_PaletteHeaderBg  2, 6, paletteData4ee0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $2d, PALH_TILESET_FOREST_OF_TIME
	m_PaletteHeaderBg  2, 6, paletteData4b20
	m_PaletteHeaderEnd

m_PaletteHeaderStart $2e, PALH_TILESET_SYMMETRY_CITY_RESTORED
	m_PaletteHeaderBg  2, 6, paletteData4d60
	m_PaletteHeaderEnd

m_PaletteHeaderStart $2f, PALH_TILESET_MERMAIDS_CAVE_PAST_ENTRANCE
	m_PaletteHeaderBg  2, 6, paletteData4b80
	m_PaletteHeaderEnd

m_PaletteHeaderStart $30, PALH_TILESET_MAKU_TREE
	m_PaletteHeaderBg  2, 6, paletteData4f70
	m_PaletteHeaderEnd

m_PaletteHeaderStart $31, PALH_TILESET_MAKU_TREE_TOP
	m_PaletteHeaderBg  2, 6, paletteData4fa0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $32, PALH_TILESET_JABU_JABU_OUTSIDE
	m_PaletteHeaderBg  2, 6, paletteData4e80
	m_PaletteHeaderEnd

m_PaletteHeaderStart $33, PALH_TILESET_OVERWORLD_PAST_ALTERNATE
	m_PaletteHeaderBg  2, 6, paletteData4b50
	m_PaletteHeaderEnd

; Color for seaweed being cut underwater
m_PaletteHeaderStart $34, PALH_SEAWEED_CUT
	m_PaletteHeaderSpr 6, 1, paletteData5950
	m_PaletteHeaderEnd


m_PaletteHeaderStart $35, PALH_35

m_PaletteHeaderStart $36, PALH_36

m_PaletteHeaderStart $37, PALH_37

m_PaletteHeaderStart $38, PALH_38

m_PaletteHeaderStart $39, PALH_39

m_PaletteHeaderStart $3a, PALH_3a

m_PaletteHeaderStart $3b, PALH_3b

m_PaletteHeaderStart $3c, PALH_3c

m_PaletteHeaderStart $3d, PALH_3d

m_PaletteHeaderStart $3e, PALH_3e

m_PaletteHeaderStart $3f, PALH_3f

m_PaletteHeaderStart $40, PALH_TILESET_MAKU_PATH_PRESENT
	m_PaletteHeaderBg  2, 6, paletteData5000
	m_PaletteHeaderEnd

m_PaletteHeaderStart $41, PALH_TILESET_SPIRITS_GRAVE
	m_PaletteHeaderBg  2, 6, paletteData5060
	m_PaletteHeaderEnd

m_PaletteHeaderStart $42, PALH_TILESET_WING_DUNGEON
	m_PaletteHeaderBg  2, 6, paletteData5090
	m_PaletteHeaderEnd

m_PaletteHeaderStart $43, PALH_TILESET_MOONLIT_GROTTO
	m_PaletteHeaderBg  2, 6, paletteData50c0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $44, PALH_TILESET_SKULL_DUNGEON
	m_PaletteHeaderBg  2, 6, paletteData50f0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $45, PALH_TILESET_CROWN_DUNGEON
	m_PaletteHeaderBg  2, 6, paletteData5120
	m_PaletteHeaderEnd

m_PaletteHeaderStart $46, PALH_TILESET_MERMAIDS_CAVE_PRESENT
	m_PaletteHeaderBg  2, 6, paletteData5150
	m_PaletteHeaderEnd

m_PaletteHeaderStart $47, PALH_TILESET_JABU_JABUS_BELLY
	m_PaletteHeaderBg  2, 6, paletteData51e0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $48, PALH_TILESET_ANCIENT_TOMB
	m_PaletteHeaderBg  2, 6, paletteData5240
	m_PaletteHeaderEnd

m_PaletteHeaderStart $49, PALH_TILESET_BLACK_TOWER_TOP
	m_PaletteHeaderBg  2, 6, paletteData5300
	m_PaletteHeaderEnd

m_PaletteHeaderStart $4a, PALH_TILESET_ROOM_OF_RITES
	m_PaletteHeaderBg  2, 6, paletteData5360
	m_PaletteHeaderEnd

m_PaletteHeaderStart $4b, PALH_TILESET_HEROS_CAVE
	m_PaletteHeaderBg  2, 6, paletteData53f0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $4c, PALH_TILESET_MERMAIDS_CAVE_PAST
	m_PaletteHeaderBg  2, 6, paletteData5180
	m_PaletteHeaderEnd

m_PaletteHeaderStart $4d, PALH_TILESET_MAKU_PATH_PAST
	m_PaletteHeaderBg  2, 6, paletteData5030
	m_PaletteHeaderEnd

m_PaletteHeaderStart $4e, PALH_4e
	m_PaletteHeaderBg  2, 6, paletteData5000
	m_PaletteHeaderEnd

m_PaletteHeaderStart $4f, PALH_4f
	m_PaletteHeaderBg  2, 6, paletteData5000
	m_PaletteHeaderEnd

m_PaletteHeaderStart $50, PALH_TILESET_SIDESCROLL_MERMAIDS_CAVE_PRESENT
	m_PaletteHeaderBg  2, 6, paletteData5480
	m_PaletteHeaderEnd

m_PaletteHeaderStart $51, PALH_TILESET_SIDESCROLL_SPIRITS_GRAVE
	m_PaletteHeaderBg  2, 6, paletteData54b0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $52, PALH_TILESET_SIDESCROLL
	m_PaletteHeaderBg  2, 6, paletteData5480
	m_PaletteHeaderEnd

m_PaletteHeaderStart $53, PALH_TILESET_SIDESCROLL_SKULL_DUNGEON_CROWN_DUNGEON
	m_PaletteHeaderBg  2, 6, paletteData54e0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $54, PALH_TILESET_SIDESCROLL_JABU_JABUS_BELLY
	m_PaletteHeaderBg  2, 6, paletteData5510
	m_PaletteHeaderEnd

m_PaletteHeaderStart $55, PALH_TILESET_SIDESCROLL_ANCIENT_TOMB
	m_PaletteHeaderBg  2, 6, paletteData5540
	m_PaletteHeaderEnd

m_PaletteHeaderStart $56, PALH_TILESET_SIDESCROLL_MERMAIDS_CAVE_PAST
	m_PaletteHeaderBg  2, 6, paletteData5570
	m_PaletteHeaderEnd

m_PaletteHeaderStart $57, PALH_TILESET_SIDESCROLL_B
	m_PaletteHeaderBg  2, 6, paletteData55a0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $58, PALH_TILESET_SIDESCROLL_C
	m_PaletteHeaderBg  2, 6, paletteData55d0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $59, PALH_BLACK_TOWER_TOP_WITH_BUSHES
	m_PaletteHeaderBg  2, 6, paletteData5330
	m_PaletteHeaderEnd

m_PaletteHeaderStart $5a, PALH_5a

m_PaletteHeaderStart $5b, PALH_5b

m_PaletteHeaderStart $5c, PALH_5c

m_PaletteHeaderStart $5d, PALH_5d

m_PaletteHeaderStart $5e, PALH_5e

m_PaletteHeaderStart $5f, PALH_5f

m_PaletteHeaderStart $60, PALH_TILESET_BLACK_TOWER
	m_PaletteHeaderBg  2, 6, paletteData4fd0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $61, PALH_TILESET_MERMAIDS_CAVE_PAST_UNDERWATER
	m_PaletteHeaderBg  2, 6, paletteData51b0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $62, PALH_TILESET_JABU_JABUS_BELLY_UNDERWATER
	m_PaletteHeaderBg  2, 6, paletteData5210
	m_PaletteHeaderEnd

m_PaletteHeaderStart $63, PALH_TILESET_ANCIENT_TOMB_BOSS
	m_PaletteHeaderBg  2, 6, paletteData52a0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $64, PALH_TILESET_ANCIENT_TOMB_UNDERWATER
	m_PaletteHeaderBg  2, 6, paletteData52d0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $65, PALH_TILESET_HEROS_CAVE_UNDERWATER
	m_PaletteHeaderBg  2, 6, paletteData5450
	m_PaletteHeaderEnd

m_PaletteHeaderStart $66, PALH_TILESET_HEROS_CAVE_WITH_BUSHES
	m_PaletteHeaderBg  2, 6, paletteData5420
	m_PaletteHeaderEnd

m_PaletteHeaderStart $67, PALH_TILESET_ROOM_OF_RITES_ICE
	m_PaletteHeaderBg  2, 6, paletteData5360
	m_PaletteHeaderBg  6, 1, paletteData49a8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $68, PALH_68

m_PaletteHeaderStart $69, PALH_69

m_PaletteHeaderStart $6a, PALH_6a

m_PaletteHeaderStart $6b, PALH_6b

m_PaletteHeaderStart $6c, PALH_6c

m_PaletteHeaderStart $6d, PALH_6d

m_PaletteHeaderStart $6e, PALH_6e

m_PaletteHeaderStart $6f, PALH_6f

m_PaletteHeaderStart $70, PALH_TILESET_INDOORS_PRESENT
	m_PaletteHeaderBg  2, 6, paletteData5600
	m_PaletteHeaderEnd

m_PaletteHeaderStart $71, PALH_TILESET_OLD_MAN_CAVE_PRESENT
	m_PaletteHeaderBg  2, 6, paletteData5630
	m_PaletteHeaderEnd

m_PaletteHeaderStart $72, PALH_TILESET_INDOORS_PAST
	m_PaletteHeaderBg  2, 6, paletteData5690
	m_PaletteHeaderEnd

m_PaletteHeaderStart $73, PALH_TILESET_CAVE
	m_PaletteHeaderBg  2, 6, paletteData56c0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $74, PALH_TILESET_AMBIS_PALACE
	m_PaletteHeaderBg  2, 6, paletteData5720
	m_PaletteHeaderEnd

m_PaletteHeaderStart $75, PALH_TILESET_MOBLIN_FORTRESS
	m_PaletteHeaderBg  2, 6, paletteData5750
	m_PaletteHeaderEnd

m_PaletteHeaderStart $76, PALH_TILESET_ZORA_PALACE
	m_PaletteHeaderBg  2, 6, paletteData5780
	m_PaletteHeaderEnd

m_PaletteHeaderStart $77, PALH_TILESET_MAKU_TREE_INSIDE
	m_PaletteHeaderBg  2, 6, paletteData5660
	m_PaletteHeaderEnd

m_PaletteHeaderStart $78, PALH_TILESET_ROLLING_RIDGE_CAVE_PRESENT
	m_PaletteHeaderBg  2, 6, paletteData56f0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $79, PALH_TILESET_UNDERWATER_CAVE
	m_PaletteHeaderBg  2, 6, paletteData57b0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $7a, PALH_7a

m_PaletteHeaderStart $7b, PALH_7b

m_PaletteHeaderStart $7c, PALH_7c
	m_PaletteHeaderSpr 6, 1, paletteData5948
	m_PaletteHeaderEnd

m_PaletteHeaderStart $7d, PALH_7d
	m_PaletteHeaderSpr 6, 1, paletteData5940
	m_PaletteHeaderEnd

m_PaletteHeaderStart $7e, PALH_7e
	m_PaletteHeaderSpr 6, 1, paletteData5918
	m_PaletteHeaderEnd

m_PaletteHeaderStart $7f, PALH_SPR_LINK_STONE
	m_PaletteHeaderSpr 7, 1, paletteData4938
	m_PaletteHeaderEnd

m_PaletteHeaderStart $80, PALH_80
	m_PaletteHeaderSpr 6, 1, paletteData46a8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $81, PALH_81
	m_PaletteHeaderSpr 6, 1, paletteData4958
	m_PaletteHeaderEnd

m_PaletteHeaderStart $82, PALH_82
	m_PaletteHeaderSpr 6, 1, paletteData4998
	m_PaletteHeaderEnd

m_PaletteHeaderStart $83, PALH_83
	m_PaletteHeaderSpr 6, 1, paletteData4968
	m_PaletteHeaderEnd

m_PaletteHeaderStart $84, PALH_84
	m_PaletteHeaderSpr 6, 1, paletteData4970
	m_PaletteHeaderEnd

m_PaletteHeaderStart $85, PALH_85
	m_PaletteHeaderSpr 6, 1, paletteData49a0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $86, PALH_86
	m_PaletteHeaderSpr 6, 1, $deb0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $87, PALH_87
	m_PaletteHeaderSpr 6, 2, paletteData4978
	m_PaletteHeaderEnd

m_PaletteHeaderStart $88, PALH_88
	m_PaletteHeaderSpr 6, 1, paletteData4960
	m_PaletteHeaderEnd

m_PaletteHeaderStart $89, PALH_89
	m_PaletteHeaderSpr 6, 1, paletteData5908
	m_PaletteHeaderSpr 7, 1, paletteData5910
	m_PaletteHeaderEnd

m_PaletteHeaderStart $8a, PALH_8a
	m_PaletteHeaderSpr 7, 1, paletteData4978
	m_PaletteHeaderEnd

m_PaletteHeaderStart $8b, PALH_8b
	m_PaletteHeaderSpr 6, 1, paletteData4988
	m_PaletteHeaderBg  7, 1, paletteData5390
	m_PaletteHeaderEnd

m_PaletteHeaderStart $8c, PALH_8c
	m_PaletteHeaderSpr 6, 1, paletteData4990
	m_PaletteHeaderEnd

m_PaletteHeaderStart $8d, PALH_8d
	m_PaletteHeaderSpr 6, 1, paletteData4948
	m_PaletteHeaderEnd

m_PaletteHeaderStart $8e, PALH_8e
	m_PaletteHeaderBg  2, 6, paletteData5360
	m_PaletteHeaderBg  6, 1, paletteData49a8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $8f, PALH_8f
	m_PaletteHeaderBg  2, 6, paletteData4500
	m_PaletteHeaderEnd

m_PaletteHeaderStart $90, PALH_90
	m_PaletteHeaderBg  1, 7, paletteData41e0
	m_PaletteHeaderSpr 2, 6, paletteData4180
	m_PaletteHeaderEnd

m_PaletteHeaderStart $91, PALH_91
	m_PaletteHeaderBg  0, 1, paletteData48e0
	m_PaletteHeaderBg  2, 6, paletteData43f8
	m_PaletteHeaderSpr 0, 6, standardSpritePaletteData
	m_PaletteHeaderSpr 6, 1, paletteData43f0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $92, PALH_92
	m_PaletteHeaderBg  0, 8, paletteData4298
	m_PaletteHeaderSpr 0, 8, paletteData4358
	m_PaletteHeaderEnd

m_PaletteHeaderStart $93, PALH_93
	m_PaletteHeaderBg  0, 8, paletteData42d8
	m_PaletteHeaderSpr 0, 8, paletteData4398
	m_PaletteHeaderEnd

m_PaletteHeaderStart $94, PALH_94
	m_PaletteHeaderBg  0, 8, paletteData4318
	m_PaletteHeaderSpr 2, 3, paletteData43d8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $95, PALH_95
	m_PaletteHeaderBg  0, 8, paletteData4430
	m_PaletteHeaderSpr 0, 7, paletteData4470
	m_PaletteHeaderEnd

m_PaletteHeaderStart $96, PALH_96
	m_PaletteHeaderBg  1, 7, paletteData4218
	m_PaletteHeaderEnd

m_PaletteHeaderStart $97, PALH_97
	m_PaletteHeaderSpr 6, 2, paletteData44d8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $98, PALH_98
	m_PaletteHeaderSpr 6, 1, paletteData4428
	m_PaletteHeaderEnd

m_PaletteHeaderStart $99, PALH_99
	m_PaletteHeaderBg  2, 6, paletteData44a8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $9a, PALH_9a
	m_PaletteHeaderBg  2, 4, paletteData4530
	m_PaletteHeaderEnd

m_PaletteHeaderStart $9b, PALH_9b
	m_PaletteHeaderBg  0, 7, paletteData4250
	m_PaletteHeaderSpr 0, 2, paletteData4288
	m_PaletteHeaderEnd

m_PaletteHeaderStart $9c, PALH_9c
	m_PaletteHeaderBg  0, 4, paletteData4648
	m_PaletteHeaderEnd

m_PaletteHeaderStart $9d, PALH_9d
	m_PaletteHeaderBg  1, 7, paletteData4590
	m_PaletteHeaderSpr 0, 8, paletteData4600
	m_PaletteHeaderEnd

m_PaletteHeaderStart $9e, PALH_9e
	m_PaletteHeaderBg  1, 7, paletteData45c8
	m_PaletteHeaderSpr 1, 1, paletteData4640
	m_PaletteHeaderEnd

m_PaletteHeaderStart $9f, PALH_9f
	m_PaletteHeaderBg  0, 8, paletteData47f0
	m_PaletteHeaderSpr 0, 8, paletteData4830
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a0, PALH_a0
	m_PaletteHeaderBg  0, 5, paletteData4770
	m_PaletteHeaderSpr 0, 2, paletteData4798
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a1, PALH_a1
	m_PaletteHeaderBg  0, 4, paletteData46c0
	m_PaletteHeaderSpr 0, 2, paletteData46e0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a2, PALH_a2
	m_PaletteHeaderSpr 6, 1, paletteData44e8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a3, PALH_a3
	m_PaletteHeaderSpr 6, 1, paletteData5958
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a4, PALH_a4
	m_PaletteHeaderSpr 6, 2, paletteData41b0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a5, PALH_a5
	m_PaletteHeaderSpr 6, 2, paletteData41c0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a6, PALH_a6
	m_PaletteHeaderSpr 6, 2, paletteData41d0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a7, PALH_a7
.ifndef REGION_JP
	m_PaletteHeaderBg  0, 6, paletteData48b0
	m_PaletteHeaderSpr 0, 6, paletteData48b0
	m_PaletteHeaderEnd
.endif

m_PaletteHeaderStart $a8, PALH_SECRET_LIST_MENU
	m_PaletteHeaderBg  2, 4, paletteData58c8
	m_PaletteHeaderSpr 0, 8, paletteData4138
	m_PaletteHeaderEnd

m_PaletteHeaderStart $a9, PALH_a9
	m_PaletteHeaderBg  2, 6, paletteData47c0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $aa, PALH_aa
	m_PaletteHeaderBg  0, 6, paletteData4870
	m_PaletteHeaderSpr 4, 4, paletteData4890
	m_PaletteHeaderEnd

m_PaletteHeaderStart $ab, PALH_ab
	m_PaletteHeaderSpr 7, 1, paletteData4178
	m_PaletteHeaderEnd

m_PaletteHeaderStart $ac, PALH_ac
	m_PaletteHeaderSpr 6, 2, paletteData58f0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $ad, PALH_ad
	m_PaletteHeaderSpr 6, 2, paletteData44e8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $ae, PALH_ae
	m_PaletteHeaderBg  0, 8, paletteData4730
	m_PaletteHeaderEnd

m_PaletteHeaderStart $af, PALH_af
	m_PaletteHeaderSpr 7, 1, paletteData5900
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b0, PALH_b0

m_PaletteHeaderStart $b1, PALH_b1
	m_PaletteHeaderBg  7, 1, paletteData5390
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b2, PALH_b2
	m_PaletteHeaderBg  7, 1, paletteData5398
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b3, PALH_b3
	m_PaletteHeaderBg  7, 1, paletteData53a0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b4, PALH_b4
	m_PaletteHeaderBg  7, 1, paletteData53a8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b5, PALH_b5
	m_PaletteHeaderBg  7, 1, paletteData53b0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b6, PALH_b6
	m_PaletteHeaderBg  7, 1, paletteData53b8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b7, PALH_b7
	m_PaletteHeaderBg  7, 1, paletteData53c0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b8, PALH_b8
	m_PaletteHeaderBg  7, 1, paletteData53c8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $b9, PALH_b9
	m_PaletteHeaderBg  7, 1, paletteData53d0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $ba, PALH_ba
	m_PaletteHeaderBg  7, 1, paletteData53d8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $bb, PALH_bb
	m_PaletteHeaderBg  7, 1, paletteData53e0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $bc, PALH_bc
	m_PaletteHeaderBg  7, 1, paletteData53e8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $bd, PALH_bd
	m_PaletteHeaderBg  1, 1, paletteData4930
	m_PaletteHeaderEnd

m_PaletteHeaderStart $be, PALH_be
	m_PaletteHeaderSpr 6, 1, paletteData4950
	m_PaletteHeaderEnd

m_PaletteHeaderStart $bf, PALH_bf
	m_PaletteHeaderSpr 6, 1, paletteData4940
	m_PaletteHeaderEnd

m_PaletteHeaderStart $c0, PALH_c0
	m_PaletteHeaderSpr 7, 1, paletteData5920
	m_PaletteHeaderEnd

m_PaletteHeaderStart $c1, PALH_c1
	m_PaletteHeaderSpr 7, 1, paletteData5928
	m_PaletteHeaderEnd

m_PaletteHeaderStart $c2, PALH_c2
	m_PaletteHeaderSpr 7, 1, paletteData5930
	m_PaletteHeaderEnd

m_PaletteHeaderStart $c3, PALH_c3
	m_PaletteHeaderBg  1, 7, paletteData57e0
	m_PaletteHeaderSpr 0, 8, paletteData5818
	m_PaletteHeaderEnd

m_PaletteHeaderStart $c4, PALH_c4
	m_PaletteHeaderBg  2, 4, paletteData4550
	m_PaletteHeaderEnd

m_PaletteHeaderStart $c5, PALH_c5
	m_PaletteHeaderBg  2, 4, paletteData4570
	m_PaletteHeaderEnd

m_PaletteHeaderStart $c6, PALH_c6
	m_PaletteHeaderSpr 6, 1, paletteData44f8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $c7, PALH_c7
	m_PaletteHeaderSpr 6, 1, paletteData44f0
	m_PaletteHeaderEnd

m_PaletteHeaderStart $c8, PALH_c8
	m_PaletteHeaderSpr 6, 1, paletteData44f0
	m_PaletteHeaderSpr 7, 1, paletteData44e8
	m_PaletteHeaderEnd

m_PaletteHeaderStart $c9, PALH_c9
	m_PaletteHeaderBg  0, 8, paletteData4668
	m_PaletteHeaderSpr 0, 8, paletteData4668
	m_PaletteHeaderEnd

m_PaletteHeaderStart $ca, PALH_ca
	m_PaletteHeaderBg  0, 8, paletteData46f0
	m_PaletteHeaderEnd
