; See data/ages/gfxHeaders.s for more info.

.define NUM_GFX_HEADERS $bb

gfxHeaderTable:
	.repeat NUM_GFX_HEADERS index COUNT
		.dw gfxHeader{%.2x{COUNT}}
	.endr


m_GfxHeaderStart $00, GFXH_DMG_SCREEN
	m_GfxHeader gfx_dmg_text, $8800
	m_GfxHeader gfx_dmg_gametitle, $9000
	m_GfxHeader map_dmg_message, $9800
	m_GfxHeaderEnd

m_GfxHeaderStart $01, GFXH_NINTENDO_CAPCOM_SCREEN
	m_GfxHeader flg_capcom_nintendo, $9881
	m_GfxHeader map_capcom_nintendo, $9880
	m_GfxHeader gfx_capcom_nintendo, $8800
	m_GfxHeaderEnd

m_GfxHeaderStart $02, GFXH_TITLESCREEN
	m_GfxHeader spr_titlescreen_sprites, $8380
	m_GfxHeader gfx_titlescreen_1, $8800
	m_GfxHeader gfx_titlescreen_2, $8d00
	m_GfxHeader gfx_titlescreen_3, $9300
	m_GfxHeader gfx_titlescreen_4, $9400
	m_GfxHeader gfx_titlescreen_5, $8801
	m_GfxHeader gfx_titlescreen_6, $8cd1
	m_GfxHeader map_titlescreen, $9800
	m_GfxHeader flg_titlescreen, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $03, GFXH_DONE
	m_GfxHeader gfx_done, $8801
	m_GfxHeaderEnd

m_GfxHeaderStart $04, GFXH_JAPANESE_INTRO_SCREEN
	m_GfxHeader flg_jp_intro_screen_1, $9801
	m_GfxHeader map_jp_intro_screen_1, $9800
	m_GfxHeader gfx_jp_intro_screen_1, $8800
	m_GfxHeader gfx_jp_intro_screen_2, $9000
	m_GfxHeaderEnd

m_GfxHeaderStart $05, GFXH_SECRET_LIST_MENU
	m_GfxHeader spr_minimap_icons, $8000, $20
	m_GfxHeader gfx_secret_list_menu, $8700
	m_GfxHeader map_secret_list_menu, $9c00
	m_GfxHeader flg_secret_list_menu, $9c01
	m_GfxHeaderEnd

m_GfxHeaderStart $06, GFXH_06

m_GfxHeaderStart $07, GFXH_ERROR_TEXT
	m_GfxHeader gfx_error, $8801
	m_GfxHeaderEnd

m_GfxHeaderStart $08, GFXH_INVENTORY_SCREEN
	m_GfxHeader gfx_inventory_hud_1, $8000
	m_GfxHeader spr_season_symbols, $8200
	m_GfxHeader spr_quest_items_5, $8400
	m_GfxHeader spr_map_compass_keys, $8600
	m_GfxHeader gfx_save, $8600
	m_GfxHeader gfx_blank, $8800
	m_GfxHeader gfx_rings, $8a00
	m_GfxHeader gfx_inventory_hud_2, $8e00
	m_GfxHeader spr_item_icons_1_spr, $8001
	m_GfxHeader spr_item_icons_2, $8201
	m_GfxHeader spr_item_icons_3, $8401
	m_GfxHeader spr_essences, $8601
	m_GfxHeader spr_quest_items_1, $8801
	m_GfxHeader spr_quest_items_2, $8a01
	m_GfxHeader spr_quest_items_3, $8c01
	m_GfxHeader spr_quest_items_4, $8e01
	m_GfxHeader map_inventory_textbar, w4TileMap+$1e0
	m_GfxHeader flg_inventory_textbar, w4AttributeMap+$1e0
	; Fall through
m_GfxHeaderStart $09, GFXH_INVENTORY_SUBSCREEN_1
	m_GfxHeader map_inventory_screen_1, w4TileMap+$040
	m_GfxHeader flg_inventory_screen_1, w4AttributeMap+$040
	m_GfxHeaderEnd

m_GfxHeaderStart $0a, GFXH_INVENTORY_SUBSCREEN_2
	m_GfxHeader map_inventory_screen_2, w4TileMap+$060
	m_GfxHeader flg_inventory_screen_2, w4AttributeMap+$060
	m_GfxHeaderEnd

m_GfxHeaderStart $0b, GFXH_INVENTORY_SUBSCREEN_3
	m_GfxHeader map_inventory_screen_3, w4TileMap+$040
	m_GfxHeader flg_inventory_screen_3, w4AttributeMap+$040
	m_GfxHeaderEnd

m_GfxHeaderStart $0c, GFXH_DIN_DANCING_CUTSCENE
	m_GfxHeader spr_din_dance_cutscene, $8000
	m_GfxHeader gfx_din_dance_cutscene_1, $8800
	m_GfxHeader gfx_din_dance_cutscene_2, $9000
	m_GfxHeader gfx_din_dance_cutscene_3, $8801
	m_GfxHeader map_din_dance_cutscene, $9800
	m_GfxHeader flg_din_dance_cutscene, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $0d, GFXH_OVERWORLD_MAP
	m_GfxHeader gfx_minimap_tiles_holodrum_1, $8801
	m_GfxHeader gfx_minimap_tiles_holodrum_2, $9001
	m_GfxHeader spr_minimap_icons, $8000
	m_GfxHeader gfx_minimap_tiles_dungeon, $8800
	m_GfxHeader map_holodrum_minimap, w4TileMap
	m_GfxHeader flg_holodrum_minimap, w4AttributeMap
	m_GfxHeaderEnd

m_GfxHeaderStart $0e, GFXH_SUBROSIA_MAP
	m_GfxHeader gfx_minimap_tiles_subrosia, $9001
	m_GfxHeader spr_minimap_icons, $8000
	m_GfxHeader gfx_minimap_tiles_dungeon, $8800
	m_GfxHeader map_subrosia_minimap, w4TileMap
	m_GfxHeader flg_subrosia_minimap, w4AttributeMap
	m_GfxHeaderEnd

m_GfxHeaderStart $0f, GFXH_DUNGEON_MAP
	m_GfxHeader spr_map_compass_keys, $8000
	m_GfxHeader gfx_minimap_tiles_dungeon, $8800
	m_GfxHeader map_dungeon_minimap, w4TileMap
	m_GfxHeader flg_dungeon_minimap, w4AttributeMap
	m_GfxHeaderEnd

m_GfxHeaderStart $10, GFXH_DUNGEON_0_BLURB
	m_GfxHeader gfx_blurb_heroscave, $8c00
	m_GfxHeaderEnd

m_GfxHeaderStart $11, GFXH_DUNGEON_1_BLURB
	m_GfxHeader gfx_blurb_d1, $8c00
	m_GfxHeaderEnd

m_GfxHeaderStart $12, GFXH_DUNGEON_2_BLURB
	m_GfxHeader gfx_blurb_d2, $8c00
	m_GfxHeaderEnd

m_GfxHeaderStart $13, GFXH_DUNGEON_3_BLURB
	m_GfxHeader gfx_blurb_d3, $8c00
	m_GfxHeaderEnd

m_GfxHeaderStart $14, GFXH_DUNGEON_4_BLURB
	m_GfxHeader gfx_blurb_d4, $8c00
	m_GfxHeaderEnd

m_GfxHeaderStart $15, GFXH_DUNGEON_5_BLURB
	m_GfxHeader gfx_blurb_d5, $8c00
	m_GfxHeaderEnd

m_GfxHeaderStart $16, GFXH_DUNGEON_6_BLURB
	m_GfxHeader gfx_blurb_d6, $8c00
	m_GfxHeaderEnd

m_GfxHeaderStart $17, GFXH_DUNGEON_7_BLURB
	m_GfxHeader gfx_blurb_d7, $8c00
	m_GfxHeaderEnd

m_GfxHeaderStart $18, GFXH_DUNGEON_8_BLURB
	m_GfxHeader gfx_blurb_d8, $8c00
	m_GfxHeaderEnd

m_GfxHeaderStart $19, GFXH_DUNGEON_9_BLURB
	m_GfxHeader gfx_blurb_onoxcastle, $8c00
	m_GfxHeaderEnd

m_GfxHeaderStart $1a, GFXH_DUNGEON_A_BLURB
	m_GfxHeader gfx_blurb_roomofrites, $8c00
	m_GfxHeaderEnd

m_GfxHeaderStart $1b, GFXH_DUNGEON_B_BLURB
	m_GfxHeader gfx_blurb_heroscave, $8c00
	m_GfxHeaderEnd

m_GfxHeaderStart $1c, GFXH_DUNGEON_C_BLURB
m_GfxHeaderStart $1d, GFXH_DUNGEON_D_BLURB
m_GfxHeaderStart $1e, GFXH_DUNGEON_E_BLURB
m_GfxHeaderStart $1f, GFXH_DUNGEON_F_BLURB

m_GfxHeaderStart $20, GFXH_HUD
	m_GfxHeader gfx_hud, $9000
	m_GfxHeaderEnd

m_GfxHeaderStart $21, GFXH_HUD_LAYOUT_NORMAL
	m_GfxHeader map_hud_normal, w4StatusBarTileMap
	m_GfxHeader flg_hud_normal, w4StatusBarAttributeMap
	m_GfxHeaderEnd

m_GfxHeaderStart $22, GFXH_HUD_LAYOUT_EXTRA_HEARTS
	m_GfxHeader map_hud_extra_hearts, w4StatusBarTileMap
	m_GfxHeader flg_hud_extra_hearts, w4StatusBarAttributeMap
	m_GfxHeaderEnd

m_GfxHeaderStart $23, GFXH_HUD_LAYOUT_BIGGORON_SWORD
	m_GfxHeader map_hud_biggoron_sword, w4TileMap+$240
	m_GfxHeader flg_hud_biggoron_sword, w4AttributeMap+$240
	m_GfxHeader spr_biggoron_sword_icon, w4ItemIconGfx
	m_GfxHeaderEnd

m_GfxHeaderStart $24, GFXH_TEMPLEFALL_SCENE1
	m_GfxHeader spr_templefall, $8000
	m_GfxHeader gfx_templefall_background_1, $8801
	m_GfxHeader gfx_templefall_background_2, $9001
	m_GfxHeader map_templefall_main_scene_1, $9800
	m_GfxHeader flg_templefall_main_scene_1, $9801
	m_GfxHeader gfx_temple_of_seasons, $8800
	m_GfxHeader map_templefall_main_scene_2, $9c00
	m_GfxHeader flg_templefall_main_scene_2, $9c01
	m_GfxHeaderEnd

m_GfxHeaderStart $25, GFXH_TEMPLEFALL_SCENE2
	m_GfxHeader gfx_tileset_subrosia_1, $9001
	m_GfxHeader gfx_tileset_temple_of_seasons_outside_1, $9301
	m_GfxHeader gfx_tileset_temple_of_seasons_outside_2, $9601
	m_GfxHeader gfx_tileset_temple_of_seasons_outside_3, $8801
	m_GfxHeader gfx_tileset_temple_of_seasons_outside_4, $8c01
	m_GfxHeader map_templefall_scene2, $9800
	m_GfxHeader flg_templefall_scene2, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $26, GFXH_TEMPLEFALL_SCENE3
	m_GfxHeader map_templefall_scene3, $9800
	m_GfxHeader flg_templefall_scene3, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $27, GFXH_TEMPLEFALL_SCENE4
	m_GfxHeader map_templefall_scene4, $9800
	m_GfxHeader flg_templefall_scene4, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $28, GFXH_TEMPLEFALL_SCENE5
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_summer_standard, $9201
	m_GfxHeader gfx_tileset_horon_village, $9601
	m_GfxHeader map_templefall_scene5, $9800
	m_GfxHeader flg_templefall_scene5, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $29, GFXH_TEMPLEFALL_SCENE6
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_winter_standard, $9201
	m_GfxHeader gfx_tileset_horon_village, $9601
	m_GfxHeader gfx_tileset_winter_tree_replacement, $9701
	m_GfxHeader map_templefall_scene6, $9800
	m_GfxHeader flg_templefall_scene6, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $2a, GFXH_TEMPLEFALL_SCENE7
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_autumn_standard, $9201
	m_GfxHeader gfx_tileset_clock_house, $9601
	m_GfxHeader map_templefall_scene7, $9a00
	m_GfxHeader flg_templefall_scene7, $9a01
	m_GfxHeaderEnd

m_GfxHeaderStart $2b, GFXH_LINK_WITH_ORACLE_END_SCENE
	m_GfxHeader spr_link_with_oracle, $8000
	m_GfxHeader gfx_link_with_oracle_1, $8800
	m_GfxHeader gfx_link_with_oracle_2, $8801
	m_GfxHeader gfx_link_with_oracle_3, $9001
	m_GfxHeader map_link_with_oracle, $9800
	m_GfxHeader flg_link_with_oracle, $9801
	m_GfxHeader map_link_with_oracle, w3VramTiles
	m_GfxHeader flg_link_with_oracle, w3VramAttributes
	m_GfxHeaderEnd

m_GfxHeaderStart $2c, GFXH_LINK_WITH_ORACLE_AND_TWINROVA_END_SCENE
	m_GfxHeader spr_link_with_oracle_and_twinrova, $8000
	m_GfxHeader gfx_link_with_oracle_and_twinrova_1, $8800
	m_GfxHeader gfx_link_with_oracle_and_twinrova_2, $8801
	m_GfxHeader gfx_link_with_oracle_and_twinrova_3, $9001
	m_GfxHeader map_link_with_oracle_and_twinrova_1, $9800
	m_GfxHeader flg_link_with_oracle_and_twinrova_1, $9801
	m_GfxHeader map_link_with_oracle_and_twinrova_1, w3VramTiles
	m_GfxHeader flg_link_with_oracle_and_twinrova_1, w3VramAttributes
	m_GfxHeader map_link_with_oracle_and_twinrova_2, w4TileMap
	m_GfxHeader flg_link_with_oracle_and_twinrova_2, w4AttributeMap
	m_GfxHeaderEnd

m_GfxHeaderStart $2d, GFXH_TWINROVA_CLOSEUP
	m_GfxHeader gfx_twinrova_closeup_1, $8800
	m_GfxHeader gfx_twinrova_closeup_2, $9000
	m_GfxHeader gfx_credits_gametitle, $8801
	m_GfxHeader map_twinrova_closeup, $9800
	m_GfxHeader flg_twinrova_closeup, $9801
	m_GfxHeader map_credits_gametitle, $9c40
	m_GfxHeader flg_credits_gametitle, $9c41
	m_GfxHeaderEnd

m_GfxHeaderStart $2e, GFXH_SCENE_INSIDE_ONOX_CASTLE
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_snakes_remains, $9401
	m_GfxHeader map_inside_onox_castle, $9800
	m_GfxHeader flg_inside_onox_castle, $9801
	m_GfxHeader map_inside_onox_castle, w3VramTiles
	m_GfxHeader flg_inside_onox_castle, w3VramAttributes
	m_GfxHeaderEnd

m_GfxHeaderStart $2f, GFXH_SCENE_OUTSIDE_ONOX_CASTLE
	m_GfxHeader gfx_tileset_onox_castle_outside_2, $8e01
	m_GfxHeader gfx_tileset_overworld_standard_1, $9001
	m_GfxHeader gfx_tileset_overworld_standard_2, $8801
	m_GfxHeader gfx_tileset_onox_castle_outside_1, $8a01
	m_GfxHeader map_outside_onox_castle, $9800
	m_GfxHeader flg_outside_onox_castle, $9801
	m_GfxHeader map_outside_onox_castle, w3VramTiles
	m_GfxHeader flg_outside_onox_castle, w3VramAttributes
	m_GfxHeaderEnd

m_GfxHeaderStart $30, GFXH_INTRO_LINK_MID_FRAME_1
	m_GfxHeader spr_intro_link_mid_frame_1, w5NameEntryCharacterGfx
	m_GfxHeaderEnd

m_GfxHeaderStart $31, GFXH_INTRO_LINK_MID_FRAME_2
	m_GfxHeader spr_intro_link_mid_frame_2, w5NameEntryCharacterGfx
	m_GfxHeaderEnd

m_GfxHeaderStart $32, GFXH_INTRO_LINK_MID_FRAME_3
	m_GfxHeader spr_intro_link_mid_frame_3, w5NameEntryCharacterGfx
	m_GfxHeaderEnd

m_GfxHeaderStart $33, GFXH_INTRO_LINK_MID_FRAME_4
	m_GfxHeader spr_intro_link_mid_frame_4, w5NameEntryCharacterGfx
	m_GfxHeaderEnd

m_GfxHeaderStart $34, GFXH_INTRO_LINK_MID_FRAME_5
	m_GfxHeader spr_intro_link_mid_frame_5, w5NameEntryCharacterGfx
	m_GfxHeaderEnd

m_GfxHeaderStart $35, GFXH_INTRO_LINK_CLOSE_FRAME_1
	m_GfxHeader spr_intro_link_close_frame_1, w5NameEntryCharacterGfx
	m_GfxHeaderEnd

m_GfxHeaderStart $36, GFXH_INTRO_LINK_CLOSE_FRAME_2
	m_GfxHeader spr_intro_link_close_frame_2, w5NameEntryCharacterGfx
	m_GfxHeaderEnd

m_GfxHeaderStart $37, GFXH_INTRO_LINK_CLOSE_FRAME_3
	m_GfxHeader spr_intro_link_close_frame_3, w5NameEntryCharacterGfx
	m_GfxHeaderEnd

m_GfxHeaderStart $38, GFXH_INTRO_LINK_CLOSE_FRAME_4
	m_GfxHeader spr_intro_link_close_frame_4, w5NameEntryCharacterGfx
	m_GfxHeaderEnd

m_GfxHeaderStart $39, GFXH_INTRO_LINK_CLOSE_FRAME_5
	m_GfxHeader spr_intro_link_close_frame_5, w5NameEntryCharacterGfx
	m_GfxHeaderEnd

m_GfxHeaderStart $3a, GFXH_UNAPPRAISED_RING_LIST
	m_GfxHeader map_unappraised_ring_list, w4TileMap
	m_GfxHeader flg_unappraised_ring_list, w4AttributeMap
	m_GfxHeader gfx_inventory_hud_1, $8000
	m_GfxHeader gfx_rings, $8a00
	m_GfxHeader gfx_inventory_hud_2, $8e00
	m_GfxHeaderEnd

m_GfxHeaderStart $3b, GFXH_APPRAISED_RING_LIST
	m_GfxHeader map_appraised_ring_list, w4TileMap
	m_GfxHeader flg_appraised_ring_list, w4AttributeMap
	m_GfxHeader gfx_inventory_hud_1, $8000
	m_GfxHeader spr_quest_items_5, $8400
	m_GfxHeader gfx_rings, $8a00
	m_GfxHeader gfx_inventory_hud_2, $8e00
	m_GfxHeader gfx_inventory_hud_1, $9000
	m_GfxHeaderEnd

m_GfxHeaderStart $3c, GFXH_SCENE_CREDITS_MAKUTREE
	m_GfxHeader spr_credits_makutree, $8000
	m_GfxHeader gfx_credits_makutree_1, $8800
	m_GfxHeader gfx_credits_makutree_2, $9000
	m_GfxHeader gfx_credits_gametitle, $8801
	m_GfxHeader map_credits_makutree, $9800
	m_GfxHeader flg_credits_makutree, $9801
	m_GfxHeader map_credits_gametitle, $9c40
	m_GfxHeader flg_credits_gametitle, $9c41
	m_GfxHeaderEnd

m_GfxHeaderStart $3d, GFXH_GASHA_TREE_DISAPPEARED
	m_GfxHeader gfx_gasha_tree, w7d800
	m_GfxHeader spr_grass_tuft, w7d800+$450
	m_GfxHeaderEnd

m_GfxHeaderStart $3e, GFXH_GASHA_TREE_DISAPPEARED_SAND
	m_GfxHeader gfx_sand, w7d800+$450
	m_GfxHeaderEnd

m_GfxHeaderStart $3f, GFXH_GASHA_TREE_DISAPPEARED_DIRT
	m_GfxHeader gfx_dirt, w7d800+$450
	m_GfxHeaderEnd

m_GfxHeaderStart $40, GFXH_TILESET_OVERWORLD_SPRING
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_spring_standard, $9201
	m_GfxHeader gfx_tileset_horon_village, $9601
	m_GfxHeaderEnd

m_GfxHeaderStart $41, GFXH_TILESET_OVERWORLD_SUMMER
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_summer_standard, $9201
	m_GfxHeader gfx_tileset_horon_village, $9601
	m_GfxHeaderEnd

m_GfxHeaderStart $42, GFXH_TILESET_OVERWORLD_AUTUMN
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_autumn_standard, $9201
	m_GfxHeader gfx_tileset_horon_village, $9601
	m_GfxHeaderEnd

m_GfxHeaderStart $43, GFXH_TILESET_OVERWORLD_WINTER
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_winter_standard, $9201
	m_GfxHeader gfx_tileset_winter_tree_replacement, $8f01
	m_GfxHeader gfx_tileset_horon_village, $9601
	m_GfxHeaderEnd

m_GfxHeaderStart $44, GFXH_TILESET_BIGGORON
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_winter_standard, $9201
	m_GfxHeader gfx_tileset_winter_tree_replacement, $8f01
	m_GfxHeader gfx_tileset_biggoron, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $45, GFXH_45
m_GfxHeaderStart $46, GFXH_46
m_GfxHeaderStart $47, GFXH_47

m_GfxHeaderStart $48, GFXH_TILESET_CASTLE_SPRING
	m_GfxHeader gfx_tileset_castle_1, $8801
	m_GfxHeader gfx_tileset_castle_2, $9001
	m_GfxHeader gfx_tileset_castle_spring, $9201
	m_GfxHeader gfx_tileset_temple_remains, $9601
	m_GfxHeaderEnd

m_GfxHeaderStart $49, GFXH_TILESET_CASTLE_SUMMER
	m_GfxHeader gfx_tileset_castle_1, $8801
	m_GfxHeader gfx_tileset_castle_2, $9001
	m_GfxHeader gfx_tileset_castle_summer, $9201
	m_GfxHeader gfx_tileset_temple_remains, $9601
	m_GfxHeaderEnd

m_GfxHeaderStart $4a, GFXH_TILESET_CASTLE_AUTUMN
	m_GfxHeader gfx_tileset_castle_1, $8801
	m_GfxHeader gfx_tileset_castle_2, $9001
	m_GfxHeader gfx_tileset_castle_autumn, $9201
	m_GfxHeader gfx_tileset_temple_remains, $9601
	m_GfxHeaderEnd

m_GfxHeaderStart $4b, GFXH_TILESET_CASTLE_WINTER
	m_GfxHeader gfx_tileset_castle_1, $8801
	m_GfxHeader gfx_tileset_castle_2, $9001
	m_GfxHeader gfx_tileset_castle_winter, $9201
	m_GfxHeader gfx_tileset_castle_winter_tree_replacement, $8f01
	m_GfxHeader gfx_tileset_temple_remains, $9601
	m_GfxHeaderEnd

m_GfxHeaderStart $4c, GFXH_TILESET_NATZU_PRAIRIE
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_natzu_prairie, $9301
	m_GfxHeader gfx_tileset_natzu, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $4d, GFXH_TILESET_NATZU_RIVER
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_natzu_river, $9301
	m_GfxHeader gfx_tileset_natzu, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $4e, GFXH_TILESET_NATZU_WASTELAND
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_natzu_wasteland, $9301
	m_GfxHeader gfx_tileset_natzu, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $4f, GFXH_TILESET_TARM_RUINS_PEDESTAL
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_summer_standard, $9201
	m_GfxHeader gfx_tileset_tarm_ruins_pedestal, $9601
	m_GfxHeaderEnd

m_GfxHeaderStart $50, GFXH_TILESET_SUBROSIA
	m_GfxHeader gfx_tileset_subrosia_1, $8801
	m_GfxHeader gfx_tileset_subrosia_2, $8b01
	m_GfxHeader gfx_tileset_subrosia_3, $8e01
	m_GfxHeader gfx_tileset_subrosia_4, $9001
	m_GfxHeader gfx_tileset_subrosia_5, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $51, GFXH_PIRATE_SHIP_LEAVING_SUBROSIA_LAYOUT
	m_GfxHeader map_pirate_ship_leaving_subrosia, w2TmpGfxBuffer
	m_GfxHeader flg_pirate_ship_leaving_subrosia, w2TmpAttrBuffer
	m_GfxHeaderEnd

m_GfxHeaderStart $52, GFXH_PIRATE_SHIP_LEAVING_DESERT_LAYOUT
	m_GfxHeader map_pirate_ship_leaving_desert, $9c00
	m_GfxHeader flg_pirate_ship_leaving_desert, $9c01
	m_GfxHeaderEnd

m_GfxHeaderStart $53, GFXH_PIRATE_SHIP_ARRIVING_LAYOUT
	m_GfxHeader map_pirate_ship_body, $9c00
	m_GfxHeader flg_pirate_ship_body, $9c01
	; Fall through

; Loaded when entering the southern shore screen with the ship body
m_GfxHeaderStart $56, GFXH_PIRATE_SHIP_BODY_LAYOUT
	m_GfxHeader map_pirate_ship_body, w2TmpGfxBuffer
	m_GfxHeader flg_pirate_ship_body, w2TmpAttrBuffer
	m_GfxHeaderEnd

m_GfxHeaderStart $54, GFXH_PIRATE_SHIP_MOVING_EXTRA_TILES
	m_GfxHeader gfx_tileset_pirate_ship_moving_extra_tiles, w2PirateShipBgTiles
	m_GfxHeaderEnd

; Loaded when entering the southern shore screen with the ship bow
m_GfxHeaderStart $55, GFXH_PIRATE_SHIP_BOW_LAYOUT
	m_GfxHeader map_pirate_ship_bow, w2TmpGfxBuffer
	m_GfxHeader flg_pirate_ship_bow, w2TmpAttrBuffer
	m_GfxHeaderEnd

m_GfxHeaderStart $57, GFXH_57
m_GfxHeaderStart $58, GFXH_58
m_GfxHeaderStart $59, GFXH_59
m_GfxHeaderStart $5a, GFXH_5a
m_GfxHeaderStart $5b, GFXH_5b
m_GfxHeaderStart $5c, GFXH_5c
m_GfxHeaderStart $5d, GFXH_5d
m_GfxHeaderStart $5e, GFXH_5e
m_GfxHeaderStart $5f, GFXH_5f

m_GfxHeaderStart $60, GFXH_TILESET_HEROS_CAVE
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_heros_cave, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $61, GFXH_TILESET_GNARLED_ROOT_DUNGEON
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_gnarled_root_dungeon, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $62, GFXH_TILESET_SNAKES_REMAINS
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_snakes_remains, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $63, GFXH_TILESET_POISON_MOTHS_LAIR
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_poison_moths_lair, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $64, GFXH_TILESET_DANCING_DRAGON_DUNGEON
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_dancing_dragon_dungeon, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $65, GFXH_TILESET_UNICORNS_CAVE
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_unicorns_cave, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $66, GFXH_TILESET_ANCIENT_RUINS
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_tarm_ruins, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $67, GFXH_TILESET_EXPLORERS_CRYPT
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_explorers_crypt, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $68, GFXH_TILESET_SWORD_AND_SHIELD_MAZE_ICE
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_sword_and_shield_maze_ice, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $69, GFXH_TILESET_ONOX_CASTLE
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_onox_castle, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $6a, GFXH_TILESET_ROOM_OF_RITES
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_room_of_rites, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $6b, GFXH_6b

m_GfxHeaderStart $6c, GFXH_TILESET_SWORD_AND_SHIELD_MAZE_FIRE
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_sword_and_shield_maze_fire, $9401
	m_GfxHeaderEnd

m_GfxHeaderStart $6d, GFXH_TILESET_SIDESCROLL
	m_GfxHeader gfx_tileset_sidescroll_1, $8801
	m_GfxHeader gfx_tileset_sidescroll_2, $9001
	m_GfxHeaderEnd

m_GfxHeaderStart $6e, GFXH_6e
m_GfxHeaderStart $6f, GFXH_6f

m_GfxHeaderStart $70, GFXH_TILESET_MAKU_TREE
	m_GfxHeader gfx_tileset_maku_tree_background, $8801
	m_GfxHeader gfx_tileset_maku_tree_1, $8c41
	m_GfxHeaderEnd

m_GfxHeaderStart $71, GFXH_TILESET_MAKU_TREE_SMALL
	m_GfxHeader gfx_tileset_maku_tree_background, $8801
	m_GfxHeader gfx_tileset_maku_tree_small_1, $8b01
	m_GfxHeader gfx_tileset_maku_tree_small_2, $9301
	m_GfxHeaderEnd

m_GfxHeaderStart $72, GFXH_72
m_GfxHeaderStart $73, GFXH_73
m_GfxHeaderStart $74, GFXH_74
m_GfxHeaderStart $75, GFXH_75
m_GfxHeaderStart $76, GFXH_76
m_GfxHeaderStart $77, GFXH_77
m_GfxHeaderStart $78, GFXH_78
m_GfxHeaderStart $79, GFXH_79
m_GfxHeaderStart $7a, GFXH_7a
m_GfxHeaderStart $7b, GFXH_7b

m_GfxHeaderStart $7c, GFXH_TILESET_INDOORS
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $20
	m_GfxHeader gfx_tileset_indoors_1, $8a01
	m_GfxHeader gfx_tileset_indoors_2, $9001
	m_GfxHeader gfx_tileset_vases, $8861
	m_GfxHeaderEnd

m_GfxHeaderStart $7d, GFXH_TILESET_CAVE
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $20
	m_GfxHeader gfx_tileset_cave_1, $8a01
	m_GfxHeader gfx_tileset_cave_2, $9001
	m_GfxHeader gfx_tileset_cave_replacement, $8861
	m_GfxHeaderEnd

m_GfxHeaderStart $7e, GFXH_7e

m_GfxHeaderStart $7f, GFXH_TILESET_SUBROSIA_INDOORS
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $20
	m_GfxHeader gfx_tileset_subrosia_indoors_1, $8a01
	m_GfxHeader gfx_tileset_subrosia_indoors_2, $9001
	m_GfxHeader gfx_tileset_subrosia_indoors_replacement, $8861
	m_GfxHeaderEnd

m_GfxHeaderStart $80, GFXH_80
m_GfxHeaderStart $81, GFXH_81

m_GfxHeaderStart $82, GFXH_TO_BE_CONTINUED
	m_GfxHeader gfx_tobecontinued, $8800
	m_GfxHeader map_tobecontinued, $9800
	m_GfxHeader flg_tobecontinued, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $83, GFXH_COMMON_SPRITES
	m_GfxHeader spr_common_sprites, $8001
	m_GfxHeaderEnd

m_GfxHeaderStart $84, GFXH_HEROS_SECRET_TEXT
	m_GfxHeader gfx_herossecret, $8801
	m_GfxHeaderEnd

m_GfxHeaderStart $85, GFXH_CREDITS_SCENE1
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_spring_standard, $9201
	m_GfxHeader gfx_tileset_horon_village, $9601
	m_GfxHeader map_credits_scene1_top_rows, $9a00
	m_GfxHeader flg_credits_scene1_top_rows, $9a01
	m_GfxHeaderEnd

m_GfxHeaderStart $86, GFXH_CREDITS_IMAGE1
	m_GfxHeader spr_credits_font, $8000
	m_GfxHeader spr_credits_font_planners, $8400
	m_GfxHeader gfx_credits_image1_1, $8800
	m_GfxHeader gfx_credits_image1_2, $9000
	m_GfxHeader map_credits_image1, $9800
	m_GfxHeader flg_credits_image1, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $87, GFXH_CREDITS_SCENE2
	m_GfxHeader gfx_tileset_maku_tree_background, $8801
	m_GfxHeader gfx_tileset_maku_tree_1, $8c41
	m_GfxHeader map_credits_scene2, $9800
	m_GfxHeader flg_credits_scene2, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $88, GFXH_CREDITS_IMAGE2
	m_GfxHeader spr_credits_font, $8000
	m_GfxHeader spr_credits_font, w4TileMap
	m_GfxHeader spr_credits_font_nakanowatari, w4AttributeMap
	m_GfxHeader spr_credits_font, w3VramTiles
	m_GfxHeader spr_credits_font_nakanowatari, w3VramAttributes
	m_GfxHeader spr_credits_font_nakanowatari, $8400
	m_GfxHeader spr_credits_font_programmers, $8600
	m_GfxHeader gfx_credits_image2_1, $8800
	m_GfxHeader gfx_credits_image2_2, $9000
	m_GfxHeader map_credits_image2, $9800
	m_GfxHeader flg_credits_image2, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $89, GFXH_CREDITS_SCENE3
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_spring_standard, $9201
	m_GfxHeader gfx_tileset_clock_house, $9601
	m_GfxHeader map_credits_scene3_top_rows, $9800
	m_GfxHeader flg_credits_scene3_top_rows, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $8a, GFXH_CREDITS_IMAGE3
	m_GfxHeader spr_credits_font, $8000
	m_GfxHeader spr_credits_font, w4TileMap
	m_GfxHeader spr_credits_font_object_designers, w4AttributeMap
	m_GfxHeader spr_credits_font, w3VramTiles
	m_GfxHeader spr_credits_font_object_designers, w3VramAttributes
	m_GfxHeader spr_credits_font_object_designers, $8400
	m_GfxHeader gfx_credits_image3_1, $8800
	m_GfxHeader gfx_credits_image3_2, $9000
	m_GfxHeader map_credits_image3, $9800
	m_GfxHeader flg_credits_image3, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $8b, GFXH_CREDITS_SCENE4
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_spring_standard, $9201
	m_GfxHeader gfx_tileset_horon_village, $9601
	m_GfxHeader map_credits_scene4_top_rows, $9800
	m_GfxHeader flg_credits_scene4_top_rows, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $8c, GFXH_CREDITS_IMAGE4
	m_GfxHeader spr_credits_font, $8000
	m_GfxHeader spr_credits_font, w4TileMap
	m_GfxHeader spr_credits_font_music, w4AttributeMap
	m_GfxHeader spr_credits_font, w3VramTiles
	m_GfxHeader spr_credits_font_music, w3VramAttributes
	m_GfxHeader spr_credits_font_music, $8400
	m_GfxHeader gfx_credits_image4_1, $8800
	m_GfxHeader gfx_credits_image4_2, $9000
	m_GfxHeader map_credits_image4, $9800
	m_GfxHeader flg_credits_image4, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $8d, GFXH_CREDITS_LINKED_SCENE1
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_spring_standard, $9201
	m_GfxHeader gfx_tileset_horon_village, $9601
	m_GfxHeader map_credits_linked_scene1, $9800
	m_GfxHeader flg_credits_linked_scene1, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $8e, GFXH_CREDITS_LINKED_IMAGE1
	m_GfxHeader spr_credits_font, $8000
	m_GfxHeader spr_credits_font_planners, $8400
	m_GfxHeader gfx_credits_linked_image2_1, $8800
	m_GfxHeader gfx_credits_linked_image2_2, $9000
	m_GfxHeader map_credits_linked_image2, $9800
	m_GfxHeader flg_credits_linked_image2, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $8f, GFXH_CREDITS_LINKED_SCENE2
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_spring_standard, $9201
	m_GfxHeader gfx_tileset_horon_village, $9601
	m_GfxHeader map_credits_linked_scene2, $9800
	m_GfxHeader flg_credits_linked_scene2, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $90, GFXH_CREDITS_LINKED_IMAGE2
	m_GfxHeader spr_credits_font, $8000
	m_GfxHeader spr_credits_font, w4TileMap
	m_GfxHeader spr_credits_font_nakanowatari, w4AttributeMap
	m_GfxHeader spr_credits_font, w3VramTiles
	m_GfxHeader spr_credits_font_nakanowatari, w3VramAttributes
	m_GfxHeader spr_credits_font_nakanowatari, $8400
	m_GfxHeader spr_credits_font_programmers, $8600
	m_GfxHeader gfx_credits_linked_image1_1, $8800
	m_GfxHeader gfx_credits_linked_image1_2, $9000, $61
	m_GfxHeader map_credits_linked_image1, $9800
	m_GfxHeader flg_credits_linked_image1, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $91, GFXH_CREDITS_LINKED_SCENE3
	m_GfxHeader gfx_tileset_overworld_standard_1, $8801
	m_GfxHeader gfx_tileset_overworld_standard_2, $9001
	m_GfxHeader gfx_tileset_spring_standard, $9201
	m_GfxHeader gfx_tileset_clock_house, $9601
	m_GfxHeader map_credits_linked_scene3, $9800
	m_GfxHeader flg_credits_linked_scene3, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $92, GFXH_CREDITS_LINKED_IMAGE3
	m_GfxHeader spr_credits_font, $8000
	m_GfxHeader spr_credits_font, w4TileMap
	m_GfxHeader spr_credits_font_object_designers, w4AttributeMap
	m_GfxHeader spr_credits_font, w3VramTiles
	m_GfxHeader spr_credits_font_object_designers, w3VramAttributes
	m_GfxHeader spr_credits_font_object_designers, $8400
	m_GfxHeader gfx_credits_linked_image3_1, $8800
	m_GfxHeader gfx_credits_linked_image3_2, $9000
	m_GfxHeader map_credits_linked_image3, $9800
	m_GfxHeader flg_credits_linked_image3, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $93, GFXH_CREDITS_LINKED_SCENE4
	m_GfxHeader gfx_tileset_maku_tree_background, $8801
	m_GfxHeader gfx_tileset_maku_tree_small_1, $8b01
	m_GfxHeader gfx_tileset_maku_tree_small_2, $9301
	m_GfxHeader map_credits_linked_scene4, $9800
	m_GfxHeader flg_credits_linked_scene4, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $94, GFXH_CREDITS_LINKED_IMAGE4
	m_GfxHeader spr_credits_font, $8000
	m_GfxHeader spr_credits_font, w4TileMap
	m_GfxHeader spr_credits_font_music, w4AttributeMap
	m_GfxHeader spr_credits_font, w3VramTiles
	m_GfxHeader spr_credits_font_music, w3VramAttributes
	m_GfxHeader spr_credits_font_music, $8400
	m_GfxHeader gfx_credits_linked_image4_1, $8800
	m_GfxHeader gfx_credits_linked_image4_2, $9000
	m_GfxHeader map_credits_linked_image4, $9800
	m_GfxHeader flg_credits_linked_image4, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $95, GFXH_CREDITS_SCROLL
	m_GfxHeader spr_credits_font, $8000
	m_GfxHeader spr_credits_sprites_1, $8400
	m_GfxHeader spr_credits_sprites_2, $8001
	m_GfxHeader spr_triforce_sparkle, w4TileMap
	m_GfxHeader gfx_credits_bg_1, $8800
	m_GfxHeader gfx_credits_bg_2, $9000
	m_GfxHeader gfx_credits_bg_3, $8801
	m_GfxHeader map_credits_bg, $9800
	m_GfxHeader flg_credits_bg, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $96, GFXH_DRAGON_ONOX
	m_GfxHeader gfx_dragononox_1, $8801
	m_GfxHeader gfx_dragononox_2, $9001
	m_GfxHeader map_dragononox_1, w6DragonOnoxTileMap1
	m_GfxHeader flg_dragononox_1, w6DragonOnoxTileAttr1
	m_GfxHeader map_dragononox_2, w6DragonOnoxTileMap2
	m_GfxHeader flg_dragononox_2, w6DragonOnoxTileAttr2
	m_GfxHeaderEnd

m_GfxHeaderStart $97, GFXH_SECRET_FOR_LINKED_GAME
	m_GfxHeader spr_fileselect_decorations, $8200
	m_GfxHeader gfx_hud, $9000, $08
	m_GfxHeader gfx_hud, $9001
	m_GfxHeader gfx_fileselect, $9201
	m_GfxHeader gfx_secrettolabrynna, $8801
	m_GfxHeader map_file_menu_top, w3VramTiles
	m_GfxHeader flg_file_menu_top, w3VramAttributes
	m_GfxHeader map_secret_for_linked_game, w3VramTiles+$0a0
	m_GfxHeader flg_secret_for_linked_game, w3VramAttributes+$0a0
	m_GfxHeader map_save_menu_bottom, w3VramTiles+$1e0
	m_GfxHeader flg_save_menu_bottom, w3VramAttributes+$1e0
	m_GfxHeaderEnd

m_GfxHeaderStart $98, GFXH_CREDITS_THE_END
	m_GfxHeader gfx_credits_theend_1, $8801
	m_GfxHeader gfx_credits_theend_2, $9001
	m_GfxHeader map_credits_theend, $9800
	m_GfxHeader flg_credits_theend, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $99, GFXH_CREDITS_LINKED_THE_END
	m_GfxHeader gfx_credits_linked_theend_1, $8a01
	m_GfxHeader gfx_credits_linked_theend_2, $9001
	m_GfxHeader map_credits_linked_theend, $9800
	m_GfxHeader flg_credits_linked_theend, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $9a, GFXH_CREDITS_LINKED_WAVING_GOODBYE
	m_GfxHeader spr_credits_linked_waving_goodbye, $8000
	m_GfxHeader gfx_credits_linked_waving_goodbye_1, $8800
	m_GfxHeader gfx_credits_linked_waving_goodbye_2, $9000
	m_GfxHeader gfx_credits_linked_waving_goodbye_3, $8801
	m_GfxHeader gfx_credits_linked_waving_goodbye_4, $9001
	m_GfxHeader map_credits_linked_waving_goodbye_1, $9800
	m_GfxHeader flg_credits_linked_waving_goodbye_1, $9801
	m_GfxHeader map_credits_linked_waving_goodbye_2, w4TileMap
	m_GfxHeader flg_credits_linked_waving_goodbye_2, w4AttributeMap
	m_GfxHeaderEnd

m_GfxHeaderStart $9b, GFXH_INTRO_LINK_RIDING_HORSE
	m_GfxHeader spr_intro_horse_close, $8000
	m_GfxHeader spr_intro_horse_mid, $8001
	m_GfxHeader gfx_intro_link_riding_horse_1, $8800
	m_GfxHeader gfx_intro_link_riding_horse_2, $9000
	m_GfxHeader map_intro_link_riding_horse_1, $9900
	m_GfxHeader flg_intro_link_riding_horse_1, $9901
	m_GfxHeader spr_intro_link_riding_horse, $8801
	m_GfxHeader gfx_intro_link_riding_horse_3, $9001
	m_GfxHeader map_intro_link_riding_horse_2, $9c60
	m_GfxHeader flg_intro_link_riding_horse_2, $9c61
	m_GfxHeader map_intro_bar, $9800
	m_GfxHeader flg_intro_bar, $9801
	m_GfxHeaderEnd

m_GfxHeaderStart $9c, GFXH_INTRO_LINK_ON_HORSE_CLOSEUP
	m_GfxHeader map_link_on_horse_closeup, $9c00
	m_GfxHeader flg_link_on_horse_closeup, $9c01
	m_GfxHeader spr_link_on_horse_closeup, $8000
	m_GfxHeader gfx_link_on_horse_closeup_1, $8800
	m_GfxHeader gfx_link_on_horse_closeup_2, $9000
	m_GfxHeader gfx_link_on_horse_closeup_3, $8801
	m_GfxHeader gfx_link_on_horse_closeup_4, $9001
	m_GfxHeaderEnd

m_GfxHeaderStart $9d, GFXH_INTRO_OUTSIDE_CASTLE
	m_GfxHeader spr_intro_outside_castle_sprites, $8000
	m_GfxHeader gfx_intro_outside_castle_1, $8800
	m_GfxHeader gfx_intro_outside_castle_2, $9000
	m_GfxHeader gfx_intro_outside_castle_3, $8801
	m_GfxHeader map_intro_outside_castle, $9c00
	m_GfxHeader flg_intro_outside_castle, $9c01
	m_GfxHeaderEnd

m_GfxHeaderStart $9e, GFXH_INTRO_TEMPLE_SCENE
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001
	m_GfxHeader gfx_tileset_tarm_ruins, $9401
	m_GfxHeader gfx_hud, $9000, $08
	m_GfxHeader map_intro_triforce_room, $9800
	m_GfxHeader flg_intro_triforce_room, $9801
	m_GfxHeader map_intro_triforce_room, w3VramTiles
	m_GfxHeader flg_intro_triforce_room, w3VramAttributes
	m_GfxHeaderEnd

m_GfxHeaderStart $9f, GFXH_TITLESCREEN_TREE_SCROLL
	m_GfxHeader gfx_titlescreen_5, $8800
	m_GfxHeader gfx_titlescreen_2, $8d00
	m_GfxHeader gfx_titlescreen_7, $9300
	m_GfxHeader gfx_titlescreen_4, $9400
	m_GfxHeader gfx_titlescreen_tree_1, $8801
	m_GfxHeader gfx_titlescreen_tree_2, $9001
	m_GfxHeader map_titlescreen_scroll_2, w4TileMap
	m_GfxHeader flg_titlescreen_scroll_2, w4AttributeMap
	m_GfxHeader map_titlescreen_scroll_1, $9c00
	m_GfxHeader flg_titlescreen_scroll_1, $9c01
	m_GfxHeaderEnd

m_GfxHeaderStart $a0, GFXH_FILE_MENU_GFX
	m_GfxHeader spr_link, $8000, $20, $200
	m_GfxHeader spr_rod_of_seasons, $81a0, $04
	m_GfxHeader gfx_hud, $9000
	m_GfxHeader gfx_hud, $9001
	m_GfxHeader spr_fileselect_decorations, $8200
	m_GfxHeader gfx_fileselect, $9201
	m_GfxHeaderEnd

m_GfxHeaderStart $ba, GFXH_FILE_MENU_WITH_MESSAGE_SPEED
	m_GfxHeader map_file_menu_message_speed, w4TileMap+$240
	m_GfxHeader flg_file_menu_message_speed, w4AttributeMap+$240
	; Fall through
m_GfxHeaderStart $a1, GFXH_FILE_MENU
	m_GfxHeader spr_din_1, $8001, $06
	m_GfxHeader spr_nayru, $8061, $04
	m_GfxHeader gfx_messagespeed, $9200
	m_GfxHeader gfx_pickafile_2, $8801
	m_GfxHeader gfx_copy, $8a01
	m_GfxHeader gfx_erase, $8aa1
	; Fall through
m_GfxHeaderStart $a2, GFXH_FILE_MENU_LAYOUT
	m_GfxHeader map_file_menu_top, w4TileMap
	m_GfxHeader flg_file_menu_top, w4AttributeMap
	m_GfxHeader map_file_menu_middle, w4TileMap+$0a0
	m_GfxHeader flg_file_menu_middle, w4AttributeMap+$0a0
	m_GfxHeader map_file_menu_bottom, w4TileMap+$1e0
	m_GfxHeader flg_file_menu_bottom, w4AttributeMap+$1e0
	m_GfxHeaderEnd

m_GfxHeaderStart $a3, GFXH_FILE_MENU_COPY
	m_GfxHeader gfx_copywhatwhere, $8801
	m_GfxHeader gfx_quit_2, $8a01
	m_GfxHeader gfx_copy, $8aa1
	m_GfxHeader map_file_menu_top, w4TileMap
	m_GfxHeader flg_file_menu_top, w4AttributeMap
	m_GfxHeader map_file_menu_copy, w4TileMap+$0a0
	m_GfxHeader flg_file_menu_copy, w4AttributeMap+$0a0
	m_GfxHeader map_file_menu_bottom, w4TileMap+$1e0
	m_GfxHeader flg_file_menu_bottom, w4AttributeMap+$1e0
	m_GfxHeaderEnd

m_GfxHeaderStart $a4, GFXH_FILE_MENU_ERASE
	m_GfxHeader gfx_pickafile, $8801
	m_GfxHeader gfx_quit_2, $8a01
	m_GfxHeader gfx_erase, $8aa1
	m_GfxHeaderEnd

m_GfxHeaderStart $a5, GFXH_NAME_ENTRY
	m_GfxHeader gfx_name, $8801
	m_GfxHeader map_name_entry_top, w4TileMap
	m_GfxHeader flg_name_entry_top, w4AttributeMap
	m_GfxHeader map_name_entry_middle, w4TileMap+$0a0
	m_GfxHeader flg_name_entry_middle, w4AttributeMap+$0a0
	m_GfxHeader map_name_entry_bottom, w4TileMap+$1e0
	m_GfxHeader flg_name_entry_bottom, w4AttributeMap+$1e0
	m_GfxHeaderEnd

m_GfxHeaderStart $a6, GFXH_SAVE_MENU_LAYOUT
	m_GfxHeader map_file_menu_top, w4TileMap
	m_GfxHeader flg_file_menu_top, w4AttributeMap
	m_GfxHeader map_save_menu_middle, w4TileMap+$0a0
	m_GfxHeader flg_save_menu_middle, w4AttributeMap+$0a0
	m_GfxHeader map_save_menu_bottom, w4TileMap+$1e0
	m_GfxHeader flg_save_menu_bottom, w4AttributeMap+$1e0
	m_GfxHeaderEnd

m_GfxHeaderStart $a7, GFXH_NEW_FILE_OPTIONS
	m_GfxHeader gfx_newfilescreen, $8801
	m_GfxHeaderEnd

m_GfxHeaderStart $a8, GFXH_SAVE_MENU_GFX
	m_GfxHeader gfx_savescreen, $8801
	m_GfxHeaderEnd

m_GfxHeaderStart $a9, GFXH_GAME_OVER_GFX
	m_GfxHeader gfx_gameover, $8801
	m_GfxHeaderEnd

m_GfxHeaderStart $aa, GFXH_SECRET_ENTRY_GFX
	m_GfxHeader gfx_secret_thatswrong, $8801
	m_GfxHeaderEnd

; Unused(?): A smaller version of GFXH_SECRET_ENTRY_LAYOUT, could be more suitable for short
; 5-letter secrets, but apparently not used.
m_GfxHeaderStart $ab, GFXH_SECRET_ENTRY_LAYOUT_SMALL
	m_GfxHeader map_name_entry_top, w4TileMap
	m_GfxHeader flg_name_entry_top, w4AttributeMap
	m_GfxHeader map_secret_entry_middle, w4TileMap+$0a0
	m_GfxHeader flg_secret_entry_middle, w4AttributeMap+$0a0
	m_GfxHeader map_secret_entry_bottom, w4TileMap+$1e0
	m_GfxHeader flg_secret_entry_bottom, w4AttributeMap+$1e0
	m_GfxHeaderEnd

m_GfxHeaderStart $ac, GFXH_SECRET_ENTRY_LAYOUT
	m_GfxHeader map_secret_entry_top, w4TileMap
	m_GfxHeader flg_secret_entry_top, w4AttributeMap
	m_GfxHeader map_secret_entry_middle, w4TileMap+$0a0
	m_GfxHeader flg_secret_entry_middle, w4AttributeMap+$0a0
	m_GfxHeader map_secret_entry_bottom, w4TileMap+$1e0
	m_GfxHeader flg_secret_entry_bottom, w4AttributeMap+$1e0
	m_GfxHeaderEnd

m_GfxHeaderStart $ad, GFXH_SECRET_ENTRY_ERROR_LAYOUT
	m_GfxHeader map_secret_entry_error, w4TileMap+$140
	m_GfxHeader flg_secret_entry_error, w4AttributeMap+$140
	m_GfxHeaderEnd

m_GfxHeaderStart $ae, GFXH_GAME_LINK
	m_GfxHeader gfx_messagespeed, $9200
	m_GfxHeader gfx_pickafile_2, $8801
	m_GfxHeader gfx_copy, $8a01
	m_GfxHeader gfx_erase, $8aa1
	m_GfxHeader map_file_menu_top, w4TileMap
	m_GfxHeader flg_file_menu_top, w4AttributeMap
	m_GfxHeader map_file_menu_middle, w4TileMap+$0a0
	m_GfxHeader flg_file_menu_middle, w4AttributeMap+$0a0
	m_GfxHeader map_file_menu_bottom, w4TileMap+$1e0
	m_GfxHeader flg_file_menu_bottom, w4AttributeMap+$1e0
	m_GfxHeader gfx_linking, $8801
	; Fall through
m_GfxHeaderStart $af, GFXH_QUIT_GFX
	m_GfxHeader gfx_quit, $8a01
	m_GfxHeaderEnd

m_GfxHeaderStart $b0, GFXH_GANON_REVIVAL
	m_GfxHeader spr_ganon_1, $8000
	m_GfxHeader spr_twinrova_sacrifice_1, $8200
	m_GfxHeader spr_twinrova_sacrifice_2, $8400
	m_GfxHeader spr_twinrova_sacrifice_3, $8600
	m_GfxHeader spr_twinrova_sacrifice_4, $8800
	m_GfxHeaderEnd

m_GfxHeaderStart $b1, GFXH_GANON_A
	m_GfxHeader spr_ganon_2, w2TmpGfxBuffer
	m_GfxHeaderEnd

m_GfxHeaderStart $b2, GFXH_GANON_B
	m_GfxHeader spr_ganon_5, w2TmpGfxBuffer
	m_GfxHeaderEnd

m_GfxHeaderStart $b3, GFXH_GANON_C
	m_GfxHeader spr_ganon_6, w2TmpGfxBuffer
	m_GfxHeaderEnd

m_GfxHeaderStart $b4, GFXH_GANON_D
	m_GfxHeader spr_ganon_7, w2TmpGfxBuffer
	m_GfxHeaderEnd

m_GfxHeaderStart $b5, GFXH_GANON_E
	m_GfxHeader spr_ganon_8, w2TmpGfxBuffer
	m_GfxHeaderEnd

m_GfxHeaderStart $b6, GFXH_GANON_F
	m_GfxHeader spr_ganon_9, w2TmpGfxBuffer
	m_GfxHeaderEnd

m_GfxHeaderStart $b7, GFXH_GANON_G
	m_GfxHeader spr_ganon_10, w2TmpGfxBuffer
	m_GfxHeaderEnd

m_GfxHeaderStart $b8, GFXH_TWINROVA_LAVA_LAYOUT
	m_GfxHeader oth_twinrova_lava_layout, $cf00
	m_GfxHeaderEnd

m_GfxHeaderStart $b9, GFXH_TWINROVA_NORMAL_LAYOUT
	m_GfxHeader oth_twinrova_normal_layout, $cf00
	m_GfxHeaderEnd
