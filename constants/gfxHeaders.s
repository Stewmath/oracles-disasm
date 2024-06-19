; A "gfx header" is a mapping of one or more graphics or map files to VRAM (or sometimes to WRAM).
; This provides a convenient interface to load a list of graphics and mapping data with a single
; function call.
;
; There are 3 main types of graphics files which gfx headers can load:
;
; - gfx data (png files, "gfx_..." or "spr_...")
; - Tile mapping data (bin files, "map_...")
; - Flag/attribute data (bin files, "flg_..."), usually paired with a "map" file
;
; (Other, miscellaneous types of data are prefixed with "oth_".)
;
; Together these 3 data types contain all the data needed to draw tiles to the gameboy screen,
; except for palette data. Sprites are a bit more complicated, but the tiles used by them can be
; loaded through gfx headers.
;
; There is no technical distinction between how the 3 data types are loaded (aside from png
; conversion to binary in the makefile), but almost all graphical files fall into one of these
; categories. Typically this data is loaded directly into VRAM, but sometimes it can be loaded into
; WRAM instead for further processing.
;
; If this doesn't make sense, you should read some technical documentation on the gameboy's
; graphical hardware (ie. gameboy pandocs).
;
; See data/{game}/gfxHeaders.s for the data corresponding to these definitions.

.ENUM 0
	GFXH_DMG_SCREEN:                  db ; $00
	GFXH_NINTENDO_CAPCOM_SCREEN:                  db ; $01
	GFXH_TITLESCREEN:                  db ; $02
	GFXH_DONE:                  db ; $03
	GFXH_JAPANESE_INTRO_SCREEN:                  db ; $04
	GFXH_SECRET_LIST_MENU:                  db ; $05

.ifdef ROM_AGES
	GFXH_HEROS_SECRET_TEXT:                  db ; $06
.else ;ROM_SEASONS
	; Unused
	GFXH_06 db ; $06
.endif

	GFXH_ERROR_TEXT:                  db ; $07
	GFXH_INVENTORY_SCREEN:                  db ; $08
	GFXH_INVENTORY_SUBSCREEN_1:                  db ; $09
	GFXH_INVENTORY_SUBSCREEN_2:                  db ; $0a
	GFXH_INVENTORY_SUBSCREEN_3:                  db ; $0b

.ifdef ROM_AGES
	GFXH_NAYRU_SINGING_CUTSCENE:                  db ; $0c
	GFXH_OVERWORLD_MAP:                  db ; $0d
	GFXH_PAST_MAP:                  db ; $0e
.else ;ROM_SEASONS
	GFXH_DIN_DANCING_CUTSCENE:                  db ; $0c
	GFXH_OVERWORLD_MAP:                  db ; $0d
	GFXH_SUBROSIA_MAP:                  db ; $0e
.endif

	GFXH_DUNGEON_MAP:                  db ; $0f

	GFXH_DUNGEON_0_BLURB:                  db ; $10
	GFXH_DUNGEON_1_BLURB:                  db ; $11
	GFXH_DUNGEON_2_BLURB:                  db ; $12
	GFXH_DUNGEON_3_BLURB:                  db ; $13
	GFXH_DUNGEON_4_BLURB:                  db ; $14
	GFXH_DUNGEON_5_BLURB:                  db ; $15
	GFXH_DUNGEON_6_BLURB:                  db ; $16
	GFXH_DUNGEON_7_BLURB:                  db ; $17
	GFXH_DUNGEON_8_BLURB:                  db ; $18
	GFXH_DUNGEON_9_BLURB:                  db ; $19
	GFXH_DUNGEON_A_BLURB:                  db ; $1a
	GFXH_DUNGEON_B_BLURB:                  db ; $1b
	GFXH_DUNGEON_C_BLURB:                  db ; $1c
	GFXH_DUNGEON_D_BLURB:                  db ; $1d
	GFXH_DUNGEON_E_BLURB:                  db ; $1e
	GFXH_DUNGEON_F_BLURB:                  db ; $1f

	GFXH_HUD:                 db ; $20
	GFXH_HUD_LAYOUT_NORMAL:                  db ; $21
	GFXH_HUD_LAYOUT_EXTRA_HEARTS:                  db ; $22
	GFXH_HUD_LAYOUT_BIGGORON_SWORD:                  db ; $23

.ifdef ROM_SEASONS
	GFXH_TEMPLEFALL_SCENE1:                  db ; $24
	GFXH_TEMPLEFALL_SCENE2:                  db ; $25
	GFXH_TEMPLEFALL_SCENE3:                  db ; $26
	GFXH_TEMPLEFALL_SCENE4:                  db ; $27
	GFXH_TEMPLEFALL_SCENE5:                  db ; $28
	GFXH_TEMPLEFALL_SCENE6:                  db ; $29
	GFXH_TEMPLEFALL_SCENE7:                  db ; $2a
.else ;ROM_AGES
	; Unused
	GFXH_24:                  db ; $24
	GFXH_25:                  db ; $25
	GFXH_26:                  db ; $26
	GFXH_27:                  db ; $27
	GFXH_28:                  db ; $28
	GFXH_29:                  db ; $29
	GFXH_2a:                  db ; $2a
.endif

	GFXH_LINK_WITH_ORACLE_END_SCENE:                  db ; $2b
	GFXH_LINK_WITH_ORACLE_AND_TWINROVA_END_SCENE:                  db ; $2c
	GFXH_TWINROVA_CLOSEUP:                  db ; $2d

.ifdef ROM_SEASONS
	GFXH_SCENE_INSIDE_ONOX_CASTLE:                  db ; $2e
	GFXH_SCENE_OUTSIDE_ONOX_CASTLE:                  db ; $2f
.else ;ROM_AGES
	GFXH_BLACK_TOWER_MIDDLE: db ; $2e
	GFXH_BLACK_TOWER_BASE: db ; $2f
.endif

	; Only used in seasons, but existing in both games
	GFXH_INTRO_LINK_MID_FRAME_1:                  db ; $30
	GFXH_INTRO_LINK_MID_FRAME_2:                  db ; $31
	GFXH_INTRO_LINK_MID_FRAME_3:                  db ; $32
	GFXH_INTRO_LINK_MID_FRAME_4:                  db ; $33
	GFXH_INTRO_LINK_MID_FRAME_5:                  db ; $34
	GFXH_INTRO_LINK_CLOSE_FRAME_1:                  db ; $35
	GFXH_INTRO_LINK_CLOSE_FRAME_2:                  db ; $36
	GFXH_INTRO_LINK_CLOSE_FRAME_3:                  db ; $37
	GFXH_INTRO_LINK_CLOSE_FRAME_4:                  db ; $38
	GFXH_INTRO_LINK_CLOSE_FRAME_5:                  db ; $39

	GFXH_UNAPPRAISED_RING_LIST:                  db ; $3a
	GFXH_APPRAISED_RING_LIST:                  db ; $3b
	GFXH_SCENE_CREDITS_MAKUTREE:                  db ; $3c

	GFXH_GASHA_TREE_DISAPPEARED:                  db ; $3d
	GFXH_GASHA_TREE_DISAPPEARED_SAND:                  db ; $3e
	GFXH_GASHA_TREE_DISAPPEARED_DIRT:                  db ; $3f

.ifdef ROM_SEASONS
	; Tilesets
	GFXH_40:                  db ; $40
	GFXH_41:                  db ; $41
	GFXH_42:                  db ; $42
	GFXH_43:                  db ; $43
	GFXH_44:                  db ; $44

	; Unused
	GFXH_45:                  db ; $45
	GFXH_46:                  db ; $46
	GFXH_47:                  db ; $47

	; Tilesets
	GFXH_48:                  db ; $48
	GFXH_49:                  db ; $49
	GFXH_4a:                  db ; $4a
	GFXH_4b:                  db ; $4b
	GFXH_4c:                  db ; $4c
	GFXH_4d:                  db ; $4d
	GFXH_4e:                  db ; $4e
	GFXH_4f:                  db ; $4f
	GFXH_50:                  db ; $50

	; For pirate ship cutscenes
	GFXH_PIRATE_SHIP_LEAVING_SUBROSIA_LAYOUT:                  db ; $51
	GFXH_PIRATE_SHIP_LEAVING_DESERT_LAYOUT:                  db ; $52
	GFXH_PIRATE_SHIP_ARRIVING_LAYOUT:                  db ; $53
	GFXH_PIRATE_SHIP_MOVING_EXTRA_TILES:                  db ; $54

	; Loaded when entering the respective screens on the overworld when ship is parked
	GFXH_PIRATE_SHIP_BOW_LAYOUT:    db ;    $55
	GFXH_PIRATE_SHIP_BODY_LAYOUT:   db ;    $56

	; Unused
	GFXH_57:                  db ; $57
	GFXH_58:                  db ; $58
	GFXH_59:                  db ; $59
	GFXH_5a:                  db ; $5a
	GFXH_5b:                  db ; $5b
	GFXH_5c:                  db ; $5c
	GFXH_5d:                  db ; $5d
	GFXH_5e:                  db ; $5e
	GFXH_5f:                  db ; $5f

	; Tilesets
	GFXH_60:                  db ; $60
	GFXH_61:                  db ; $61
	GFXH_62:                  db ; $62
	GFXH_63:                  db ; $63
	GFXH_64:                  db ; $64
	GFXH_65:                  db ; $65
	GFXH_66:                  db ; $66
	GFXH_67:                  db ; $67
	GFXH_68:                  db ; $68
	GFXH_69:                  db ; $69
	GFXH_6a:                  db ; $6a

	; Unused
	GFXH_6b:                  db ; $6b

	; Tilesets
	GFXH_6c:                  db ; $6c
	GFXH_6d:                  db ; $6d

	; Unused
	GFXH_6e:                  db ; $6e
	GFXH_6f:                  db ; $6f

	; Tilesets
	GFXH_70:                  db ; $70
	GFXH_71:                  db ; $71

	; Unused
	GFXH_72:                  db ; $72
	GFXH_73:                  db ; $73
	GFXH_74:                  db ; $74
	GFXH_75:                  db ; $75
	GFXH_76:                  db ; $76
	GFXH_77:                  db ; $77
	GFXH_78:                  db ; $78
	GFXH_79:                  db ; $79
	GFXH_7a:                  db ; $7a
	GFXH_7b:                  db ; $7b

	; Tilesets
	GFXH_7c:                  db ; $7c
	GFXH_7d:                  db ; $7d

	; Unused
	GFXH_7e:                  db ; $7e

	; Tileset
	GFXH_7f:                  db ; $7f

	; Unused
	GFXH_80:                  db ; $80
	GFXH_81:                  db ; $81

	GFXH_TO_BE_CONTINUED:                  db ; $82

.else ;ROM_AGES
	; Tilesets
	GFXH_40:                  db ; $40
	GFXH_41:                  db ; $41
	GFXH_42:                  db ; $42
	GFXH_43:                  db ; $43

	GFXH_SEAWEED_CUT:         db ; $44

	; Unused
	GFXH_45:                  db ; $45
	GFXH_46:                  db ; $46
	GFXH_47:                  db ; $47
	GFXH_48:                  db ; $48
	GFXH_49:                  db ; $49
	GFXH_4a:                  db ; $4a
	GFXH_4b:                  db ; $4b
	GFXH_4c:                  db ; $4c
	GFXH_4d:                  db ; $4d
	GFXH_4e:                  db ; $4e
	GFXH_4f:                  db ; $4f

	GFXH_WING_DUNGEON_COLLAPSING_1:                  db ; $50
	GFXH_WING_DUNGEON_COLLAPSING_2:                  db ; $51
	GFXH_WING_DUNGEON_COLLAPSING_3:                  db ; $52
	GFXH_WING_DUNGEON_COLLAPSED:                  db ; $53

	; Unused
	GFXH_54:                  db ; $54
	GFXH_55:                  db ; $55
	GFXH_56:                  db ; $56
	GFXH_57:                  db ; $57
	GFXH_58:                  db ; $58
	GFXH_59:                  db ; $59
	GFXH_5a:                  db ; $5a
	GFXH_5b:                  db ; $5b
	GFXH_5c:                  db ; $5c
	GFXH_5d:                  db ; $5d
	GFXH_5e:                  db ; $5e
	GFXH_5f:                  db ; $5f

	; Tilesets
	GFXH_60:                  db ; $60
	GFXH_61:                  db ; $61
	GFXH_62:                  db ; $62
	GFXH_63:                  db ; $63
	GFXH_64:                  db ; $64
	GFXH_65:                  db ; $65
	GFXH_66:                  db ; $66
	GFXH_67:                  db ; $67
	GFXH_68:                  db ; $68
	GFXH_69:                  db ; $69
	GFXH_6a:                  db ; $6a

	; Unused
	GFXH_6b:                  db ; $6b
	GFXH_6c:                  db ; $6c

	GFXH_TILESET_SIDESCROLL:                  db ; $6d
	GFXH_TILESET_BLACK_TOWER:                  db ; $6e
	GFXH_COMMON_SPRITES_TO_WRAM:                  db ; $6f
	GFXH_TILESET_MAKU_TREE:                  db ; $70
	GFXH_TILESET_MAKU_TREE_TOP:                  db ; $71

	GFXH_MERMAIDS_CAVE_WALL_RETRACTION:                  db ; $72
	GFXH_ANCIENT_TOMB_WALL_RETRACTION:                  db ; $73
	GFXH_JABU_OPENING_1:                  db ; $74
	GFXH_JABU_OPENING_2:                  db ; $75

	; Unused
	GFXH_76:                  db ; $76
	GFXH_77:                  db ; $77
	GFXH_78:                  db ; $78
	GFXH_79:                  db ; $79
	GFXH_7a:                  db ; $7a

	; Tilesets
	GFXH_TILESET_INDOORS_1:                  db ; $7b
	GFXH_7c:                  db ; $7c
	GFXH_7d:                  db ; $7d
	GFXH_7e:                  db ; $7e
	GFXH_7f:                  db ; $7f

	GFXH_BLACK_TOWER_STAGE_3_LAYOUT:                  db ; $80
	GFXH_BLACK_TOWER_STAGE_2_LAYOUT:                  db ; $81
	GFXH_BLACK_TOWER_STAGE_1_LAYOUT:                  db ; $82
.endif

	GFXH_COMMON_SPRITES:      db ; $83

.ifdef ROM_AGES
	GFXH_CREDITS_SCENE_MAKU_TREE_PAST:                  db ; $84
.else ;ROM_SEASONS
	GFXH_HEROS_SECRET_TEXT:                  db ; $84
.endif

	GFXH_CREDITS_SCENE1:                  db ; $85
	GFXH_CREDITS_IMAGE1:                  db ; $86
	GFXH_CREDITS_SCENE2:                  db ; $87
	GFXH_CREDITS_IMAGE2:                  db ; $88
	GFXH_CREDITS_SCENE3:                  db ; $89
	GFXH_CREDITS_IMAGE3:                  db ; $8a
	GFXH_CREDITS_SCENE4:                  db ; $8b
	GFXH_CREDITS_IMAGE4:                  db ; $8c

	GFXH_CREDITS_LINKED_SCENE1:                  db ; $8d
	GFXH_CREDITS_LINKED_IMAGE1:                  db ; $8e
	GFXH_CREDITS_LINKED_SCENE2:                  db ; $8f
	GFXH_CREDITS_LINKED_IMAGE2:                  db ; $90
	GFXH_CREDITS_LINKED_SCENE3:                  db ; $91
	GFXH_CREDITS_LINKED_IMAGE3:                  db ; $92
	GFXH_CREDITS_LINKED_SCENE4:                  db ; $93
	GFXH_CREDITS_LINKED_IMAGE4:                  db ; $94
	GFXH_CREDITS_SCROLL:                  db ; $95

.ifdef ROM_AGES
	GFXH_TO_BE_CONTINUED:                  db ; $96
.else ;ROM_SEASONS
	GFXH_DRAGON_ONOX:                  db ; $96
.endif

	GFXH_SECRET_FOR_LINKED_GAME:                  db ; $97
	GFXH_CREDITS_THE_END:                  db ; $98
	GFXH_CREDITS_LINKED_THE_END:                  db ; $99
	GFXH_CREDITS_LINKED_WAVING_GOODBYE:                  db ; $9a

	GFXH_INTRO_LINK_RIDING_HORSE:                  db ; $9b
	GFXH_INTRO_LINK_ON_HORSE_CLOSEUP:                  db ; $9c
	GFXH_INTRO_OUTSIDE_CASTLE:                  db ; $9d
	GFXH_INTRO_TEMPLE_SCENE:                  db ; $9e
	GFXH_TITLESCREEN_TREE_SCROLL:                  db ; $9f

	GFXH_FILE_MENU_GFX:                  db ; $a0
	GFXH_FILE_MENU:                  db ; $a1
	GFXH_FILE_MENU_LAYOUT:                  db ; $a2
	GFXH_FILE_MENU_COPY:                  db ; $a3
	GFXH_FILE_MENU_ERASE:                  db ; $a4
	GFXH_NAME_ENTRY:                  db ; $a5
	GFXH_SAVE_MENU_LAYOUT:                  db ; $a6
	GFXH_NEW_FILE_OPTIONS:                  db ; $a7
	GFXH_SAVE_MENU_GFX:                  db ; $a8
	GFXH_GAME_OVER_GFX:                  db ; $a9
	GFXH_SECRET_ENTRY_GFX:                  db ; $aa

	; Unused(?): A smaller version of GFXH_SECRET_ENTRY_LAYOUT, could be more suitable for short
	; 5-letter secrets, but apparently not used.
	GFXH_SECRET_ENTRY_LAYOUT_SMALL:                  db ; $ab

	GFXH_SECRET_ENTRY_LAYOUT:                  db ; $ac
	GFXH_SECRET_ENTRY_ERROR_LAYOUT:                  db ; $ad
	GFXH_GAME_LINK:                  db ; $ae
	GFXH_QUIT_GFX:                  db ; $af
	GFXH_GANON_REVIVAL:                  db ; $b0
	GFXH_GANON_A:                  db ; $b1
	GFXH_GANON_B:                  db ; $b2
	GFXH_GANON_C:                  db ; $b3
	GFXH_GANON_D:                  db ; $b4
	GFXH_GANON_E:                  db ; $b5
	GFXH_GANON_F:                  db ; $b6
	GFXH_GANON_G:                  db ; $b7
	GFXH_TWINROVA_LAVA_LAYOUT:                  db ; $b8
	GFXH_TWINROVA_NORMAL_LAYOUT:                  db ; $b9
	GFXH_FILE_MENU_WITH_MESSAGE_SPEED:                  db ; $ba
.ENDE
