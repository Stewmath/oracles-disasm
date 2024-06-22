; See constants/gfxHeaders.s for more info.

gfxHeaderTable:
	.dw gfxHeader00
	.dw gfxHeader01
	.dw gfxHeader02
	.dw gfxHeader03
	.dw gfxHeader04
	.dw gfxHeader05
	.dw gfxHeader06
	.dw gfxHeader07
	.dw gfxHeader08
	.dw gfxHeader09
	.dw gfxHeader0a
	.dw gfxHeader0b
	.dw gfxHeader0c
	.dw gfxHeader0d
	.dw gfxHeader0e
	.dw gfxHeader0f
	.dw gfxHeader10
	.dw gfxHeader11
	.dw gfxHeader12
	.dw gfxHeader13
	.dw gfxHeader14
	.dw gfxHeader15
	.dw gfxHeader16
	.dw gfxHeader17
	.dw gfxHeader18
	.dw gfxHeader19
	.dw gfxHeader1a
	.dw gfxHeader1b
	.dw gfxHeader1c
	.dw gfxHeader1d
	.dw gfxHeader1e
	.dw gfxHeader1f
	.dw gfxHeader20
	.dw gfxHeader21
	.dw gfxHeader22
	.dw gfxHeader23
	.dw gfxHeader24
	.dw gfxHeader25
	.dw gfxHeader26
	.dw gfxHeader27
	.dw gfxHeader28
	.dw gfxHeader29
	.dw gfxHeader2a
	.dw gfxHeader2b
	.dw gfxHeader2c
	.dw gfxHeader2d
	.dw gfxHeader2e
	.dw gfxHeader2f
	.dw gfxHeader30
	.dw gfxHeader31
	.dw gfxHeader32
	.dw gfxHeader33
	.dw gfxHeader34
	.dw gfxHeader35
	.dw gfxHeader36
	.dw gfxHeader37
	.dw gfxHeader38
	.dw gfxHeader39
	.dw gfxHeader3a
	.dw gfxHeader3b
	.dw gfxHeader3c
	.dw gfxHeader3d
	.dw gfxHeader3e
	.dw gfxHeader3f
	.dw gfxHeader40
	.dw gfxHeader41
	.dw gfxHeader42
	.dw gfxHeader43
	.dw gfxHeader44
	.dw gfxHeader45
	.dw gfxHeader46
	.dw gfxHeader47
	.dw gfxHeader48
	.dw gfxHeader49
	.dw gfxHeader4a
	.dw gfxHeader4b
	.dw gfxHeader4c
	.dw gfxHeader4d
	.dw gfxHeader4e
	.dw gfxHeader4f
	.dw gfxHeader50
	.dw gfxHeader51
	.dw gfxHeader52
	.dw gfxHeader53
	.dw gfxHeader54
	.dw gfxHeader55
	.dw gfxHeader56
	.dw gfxHeader57
	.dw gfxHeader58
	.dw gfxHeader59
	.dw gfxHeader5a
	.dw gfxHeader5b
	.dw gfxHeader5c
	.dw gfxHeader5d
	.dw gfxHeader5e
	.dw gfxHeader5f
	.dw gfxHeader60
	.dw gfxHeader61
	.dw gfxHeader62
	.dw gfxHeader63
	.dw gfxHeader64
	.dw gfxHeader65
	.dw gfxHeader66
	.dw gfxHeader67
	.dw gfxHeader68
	.dw gfxHeader69
	.dw gfxHeader6a
	.dw gfxHeader6b
	.dw gfxHeader6c
	.dw gfxHeader6d
	.dw gfxHeader6e
	.dw gfxHeader6f
	.dw gfxHeader70
	.dw gfxHeader71
	.dw gfxHeader72
	.dw gfxHeader73
	.dw gfxHeader74
	.dw gfxHeader75
	.dw gfxHeader76
	.dw gfxHeader77
	.dw gfxHeader78
	.dw gfxHeader79
	.dw gfxHeader7a
	.dw gfxHeader7b
	.dw gfxHeader7c
	.dw gfxHeader7d
	.dw gfxHeader7e
	.dw gfxHeader7f
	.dw gfxHeader80
	.dw gfxHeader81
	.dw gfxHeader82
	.dw gfxHeader83
	.dw gfxHeader84
	.dw gfxHeader85
	.dw gfxHeader86
	.dw gfxHeader87
	.dw gfxHeader88
	.dw gfxHeader89
	.dw gfxHeader8a
	.dw gfxHeader8b
	.dw gfxHeader8c
	.dw gfxHeader8d
	.dw gfxHeader8e
	.dw gfxHeader8f
	.dw gfxHeader90
	.dw gfxHeader91
	.dw gfxHeader92
	.dw gfxHeader93
	.dw gfxHeader94
	.dw gfxHeader95
	.dw gfxHeader96
	.dw gfxHeader97
	.dw gfxHeader98
	.dw gfxHeader99
	.dw gfxHeader9a
	.dw gfxHeader9b
	.dw gfxHeader9c
	.dw gfxHeader9d
	.dw gfxHeader9e
	.dw gfxHeader9f
	.dw gfxHeadera0
	.dw gfxHeadera1
	.dw gfxHeadera2
	.dw gfxHeadera3
	.dw gfxHeadera4
	.dw gfxHeadera5
	.dw gfxHeadera6
	.dw gfxHeadera7
	.dw gfxHeadera8
	.dw gfxHeadera9
	.dw gfxHeaderaa
	.dw gfxHeaderab
	.dw gfxHeaderac
	.dw gfxHeaderad
	.dw gfxHeaderae
	.dw gfxHeaderaf
	.dw gfxHeaderb0
	.dw gfxHeaderb1
	.dw gfxHeaderb2
	.dw gfxHeaderb3
	.dw gfxHeaderb4
	.dw gfxHeaderb5
	.dw gfxHeaderb6
	.dw gfxHeaderb7
	.dw gfxHeaderb8
	.dw gfxHeaderb9
	.dw gfxHeaderba


gfxHeader00:
	m_GfxHeader gfx_dmg_text, $8800, $2f|$80
	m_GfxHeader gfx_dmg_gametitle, $9000, $3d|$80
	m_GfxHeader map_dmg_message, $9800, $23
gfxHeader01:
	m_GfxHeader flg_capcom_nintendo, $9881, $13|$80
	m_GfxHeader map_capcom_nintendo, $9880, $13|$80
	m_GfxHeader gfx_capcom_nintendo, $8800, $4f
gfxHeader02:
	m_GfxHeader spr_titlescreen_sprites, $8380, $3d|$80
	m_GfxHeader gfx_titlescreen_1, $8800, $4f|$80
	m_GfxHeader gfx_titlescreen_2, $8d00, $5f|$80
	m_GfxHeader gfx_titlescreen_3, $9300, $0f|$80
	m_GfxHeader gfx_titlescreen_4, $9400, $3f|$80
	m_GfxHeader gfx_titlescreen_5, $8801, $4f|$80
	m_GfxHeader gfx_titlescreen_6, $8cd1, $05|$80
	m_GfxHeader map_titlescreen, $9800, $23|$80
	m_GfxHeader flg_titlescreen, $9801, $23
gfxHeader03:
	m_GfxHeader gfx_done, $8801, $1f
gfxHeader04:
	; These are invalid, using the incorrect compression mode for their graphics. This used to
	; be the data for the japanese intro graphics.
	m_GfxHeaderForceMode gfx_capcom_nintendo, $9801, $7f|$80, $00
	m_GfxHeaderForceMode gfx_capcom_nintendo, $9800, $7f|$80, $00
	m_GfxHeaderForceMode gfx_capcom_nintendo, $8800, $7f|$80, $00
	m_GfxHeaderForceMode gfx_capcom_nintendo, $9000, $7f|$80, $00
gfxHeader05:
	m_GfxHeader spr_minimap_icons, $8000, $1f|$80
	m_GfxHeader gfx_secret_list_menu, $8700, $2f|$80
	m_GfxHeader map_secret_list_menu, $9c00, $3f|$80
	m_GfxHeader flg_secret_list_menu, $9c01, $3f
gfxHeader06:
	m_GfxHeader gfx_herossecret, $8801, $1f
gfxHeader07:
	m_GfxHeader gfx_error, $8801, $1f
gfxHeader08:
	m_GfxHeader gfx_inventory_hud_1, $8000, $2f|$80
	m_GfxHeader spr_present_past_symbols, $8300, $0f|$80
	m_GfxHeader spr_quest_items_5, $8400, $1f|$80
	m_GfxHeader spr_map_compass_keys_bookofseals, $8600, $1f|$80
	m_GfxHeader gfx_save, $8600, $07|$80
	m_GfxHeader gfx_blank, $8800, $1f|$80
	m_GfxHeader gfx_rings, $8a00, $3f|$80
	m_GfxHeader gfx_inventory_hud_2, $8e00, $1f|$80
	m_GfxHeader spr_item_icons_1_spr, $8001, $1f|$80
	m_GfxHeader spr_item_icons_2, $8201, $1f|$80
	m_GfxHeader spr_item_icons_3, $8401, $1f|$80
	m_GfxHeader spr_essences, $8601, $17|$80
	m_GfxHeader spr_quest_items_1, $8801, $1f|$80
	m_GfxHeader spr_quest_items_2, $8a01, $1f|$80
	m_GfxHeader spr_quest_items_3, $8c01, $1f|$80
	m_GfxHeader spr_quest_items_4, $8e01, $1f|$80
	m_GfxHeader map_inventory_textbar, $d1e4, $05|$80
	m_GfxHeader flg_inventory_textbar, $d5e4, $05|$80
gfxHeader09:
	m_GfxHeader map_inventory_screen_1, $d044, $19|$80
	m_GfxHeader flg_inventory_screen_1, $d444, $19
gfxHeader0a:
	m_GfxHeader map_inventory_screen_2, $d064, $17|$80
	m_GfxHeader flg_inventory_screen_2, $d464, $17
gfxHeader0b:
	m_GfxHeader map_inventory_screen_3, $d044, $19|$80
	m_GfxHeader flg_inventory_screen_3, $d444, $19
gfxHeader0c:
	m_GfxHeader spr_nayru_singing_cutscene, $8000, $4d|$80
	m_GfxHeader gfx_nayru_singing_cutscene_1, $8800, $7f|$80
	m_GfxHeader gfx_nayru_singing_cutscene_2, $9000, $7f|$80
	m_GfxHeader gfx_nayru_singing_cutscene_3, $8801, $31|$80
	m_GfxHeader map_nayru_singing_cutscene, $9800, $23|$80
	m_GfxHeader flg_nayru_singing_cutscene, $9801, $23
gfxHeader0d:
	m_GfxHeader gfx_minimap_tiles_present_1,  $8801,           $6f|$80
	m_GfxHeader gfx_minimap_tiles_common,     $9001,           $5f|$80
	m_GfxHeader gfx_minimap_tiles_present_2,  $9601,           $1f|$80
	m_GfxHeader spr_minimap_icons,            $8000,           $6b|$80
	m_GfxHeader gfx_minimap_tiles_dungeon,    $8800,           $3f|$80
	m_GfxHeaderDestRam map_present_minimap,   w4TileMap,       $23|$80
	m_GfxHeaderDestRam flg_present_minimap,   w4AttributeMap,  $23
gfxHeader0e:
	m_GfxHeader gfx_minimap_tiles_past_1,   $8801,           $5f|$80
	m_GfxHeader gfx_minimap_tiles_common,   $9001,           $5f|$80
	m_GfxHeader gfx_minimap_tiles_past_2,   $9601,           $1f|$80
	m_GfxHeader spr_minimap_icons,          $8000,           $6b|$80
	m_GfxHeader gfx_minimap_tiles_dungeon,  $8800,           $3f|$80
	m_GfxHeaderDestRam map_past_minimap,    w4TileMap,       $23|$80
	m_GfxHeaderDestRam flg_past_minimap,    w4AttributeMap,  $23
gfxHeader0f:
	m_GfxHeader spr_map_compass_keys_bookofseals,  $8000,           $1f|$80
	m_GfxHeader gfx_minimap_tiles_dungeon,         $8800,           $3f|$80
	m_GfxHeaderDestRam map_dungeon_minimap,        w4TileMap,       $23|$80
	m_GfxHeaderDestRam flg_dungeon_minimap,        w4AttributeMap,  $23
gfxHeader10:
	m_GfxHeader gfx_blurb_makupath, $8c00, $27
gfxHeader11:
	m_GfxHeader gfx_blurb_d1, $8c00, $27
gfxHeader12:
	m_GfxHeader gfx_blurb_d2, $8c00, $27
gfxHeader13:
	m_GfxHeader gfx_blurb_d3, $8c00, $27
gfxHeader14:
	m_GfxHeader gfx_blurb_d4, $8c00, $27
gfxHeader15:
	m_GfxHeader gfx_blurb_d5, $8c00, $27
gfxHeader16:
	m_GfxHeader gfx_blurb_d6, $8c00, $27
gfxHeader17:
	m_GfxHeader gfx_blurb_d7, $8c00, $27
gfxHeader18:
	m_GfxHeader gfx_blurb_d8, $8c00, $27
gfxHeader19:
	m_GfxHeader gfx_blurb_blacktowerturret, $8c00, $27
gfxHeader1a:
	m_GfxHeader gfx_blurb_roomofrites, $8c00, $27
gfxHeader1b:
	m_GfxHeader gfx_blurb_heroscave, $8c00, $27
gfxHeader1c:
	m_GfxHeader gfx_blurb_d6, $8c00, $27
gfxHeader1d:
	m_GfxHeader gfx_blurb_makupath, $8c00, $27
gfxHeader1e:
	m_GfxHeader gfx_blurb_makupath, $8c00, $27
gfxHeader1f:
	m_GfxHeader gfx_blurb_makupath, $8c00, $27
gfxHeader20:
	m_GfxHeader gfx_hud, $9000, $1f
gfxHeader21:
	m_GfxHeaderDestRam map_hud_normal, w4StatusBarTileMap,      $03|$80
	m_GfxHeaderDestRam flg_hud_normal, w4StatusBarAttributeMap, $03
gfxHeader22:
	m_GfxHeaderDestRam map_hud_extra_hearts, w4StatusBarTileMap,      $03|$80
	m_GfxHeaderDestRam flg_hud_extra_hearts, w4StatusBarAttributeMap, $03
gfxHeader23:
	m_GfxHeader map_hud_biggoron_sword, $d244, $03|$80
	m_GfxHeader flg_hud_biggoron_sword, $d644, $03|$80
	m_GfxHeader spr_biggoron_sword_icon, $d684, $07
gfxHeader24:
gfxHeader25:
gfxHeader26:
gfxHeader27:
gfxHeader28:
gfxHeader29:
gfxHeader2a:
gfxHeader2b:
	m_GfxHeader spr_link_with_oracle, $8000, $53|$80
	m_GfxHeader gfx_link_with_oracle_1, $8800, $7f|$80
	m_GfxHeader gfx_link_with_oracle_2, $8801, $7f|$80
	m_GfxHeader gfx_link_with_oracle_3, $9001, $31|$80
	m_GfxHeader map_link_with_oracle, $9800, $23|$80
	m_GfxHeader flg_link_with_oracle, $9801, $23|$80
	m_GfxHeader map_link_with_oracle, $d803, $23|$80
	m_GfxHeader flg_link_with_oracle, $dc03, $23
gfxHeader2c:
	m_GfxHeader spr_link_with_oracle_and_twinrova, $8000, $49|$80
	m_GfxHeader gfx_link_with_oracle_and_twinrova_1, $8800, $39|$80
	m_GfxHeader gfx_link_with_oracle_and_twinrova_2, $8801, $7f|$80
	m_GfxHeader gfx_link_with_oracle_and_twinrova_3, $9001, $7f|$80
	m_GfxHeader map_link_with_oracle_and_twinrova_1, $9800, $23|$80
	m_GfxHeader flg_link_with_oracle_and_twinrova_1, $9801, $23|$80
	m_GfxHeader map_link_with_oracle_and_twinrova_1, $d803, $23|$80
	m_GfxHeader flg_link_with_oracle_and_twinrova_1, $dc03, $23|$80
	m_GfxHeader map_link_with_oracle_and_twinrova_2, $d004, $23|$80
	m_GfxHeader flg_link_with_oracle_and_twinrova_2, $d404, $23
gfxHeader2d:
	m_GfxHeader gfx_twinrova_closeup_1, $8800, $7f|$80
	m_GfxHeader gfx_twinrova_closeup_2, $9000, $34|$80
	m_GfxHeader gfx_credits_gametitle, $8801, $69|$80
	m_GfxHeader map_twinrova_closeup, $9800, $23|$80
	m_GfxHeader flg_twinrova_closeup, $9801, $23|$80
	m_GfxHeader map_credits_gametitle, $9c40, $1b|$80
	m_GfxHeader flg_credits_gametitle, $9c41, $1b
gfxHeader2e:
	m_GfxHeader map_black_tower_middle, $99e0, $15|$80
	m_GfxHeader flg_black_tower_middle, $99e1, $15|$80
	m_GfxHeader map_black_tower_middle, $d823, $15|$80
	m_GfxHeader flg_black_tower_middle, $dc23, $15|$80
	; Fall through
gfxHeader2f:
	m_GfxHeader map_black_tower_base, $9b40, $0b|$80
	m_GfxHeader flg_black_tower_base, $9b41, $0b|$80
	m_GfxHeader map_black_tower_base, $d983, $0b|$80
	m_GfxHeader flg_black_tower_base, $dd83, $0b|$80
	m_GfxHeader spr_black_tower_scene, $8001, $4b|$80
	m_GfxHeader gfx_black_tower_scene_1, $8800, $7f|$80
	m_GfxHeader gfx_black_tower_scene_2, $9000, $3f|$80
	m_GfxHeader gfx_black_tower_scene_3, $8801, $7f|$80
	m_GfxHeader gfx_black_tower_scene_4, $9001, $6f
gfxHeader30:
	m_GfxHeader spr_intro_link_mid_frame_1, $d005, $0b
gfxHeader31:
	m_GfxHeader spr_intro_link_mid_frame_2, $d005, $0b
gfxHeader32:
	m_GfxHeader spr_intro_link_mid_frame_3, $d005, $0b
gfxHeader33:
	m_GfxHeader spr_intro_link_mid_frame_4, $d005, $0b
gfxHeader34:
	m_GfxHeader spr_intro_link_mid_frame_5, $d005, $0b
gfxHeader35:
	m_GfxHeader spr_intro_link_close_frame_1, $d005, $1b
gfxHeader36:
	m_GfxHeader spr_intro_link_close_frame_2, $d005, $1d
gfxHeader37:
	m_GfxHeader spr_intro_link_close_frame_3, $d005, $1d
gfxHeader38:
	m_GfxHeader spr_intro_link_close_frame_4, $d005, $19
gfxHeader39:
	m_GfxHeader spr_intro_link_close_frame_5, $d005, $17
gfxHeader3a:
	m_GfxHeader map_unappraised_ring_list, $d004, $1f|$80
	m_GfxHeader flg_unappraised_ring_list, $d404, $1f|$80
	m_GfxHeader gfx_inventory_hud_1, $8000, $2f|$80
	m_GfxHeader gfx_rings, $8a00, $3f|$80
	m_GfxHeader gfx_inventory_hud_2, $8e00, $1f|$80
	m_GfxHeader gfx_hud, $9000, $1f
gfxHeader3b:
	m_GfxHeader map_appraised_ring_list, $d004, $23|$80
	m_GfxHeader flg_appraised_ring_list, $d404, $23|$80
	m_GfxHeader gfx_inventory_hud_1, $8000, $2f|$80
	m_GfxHeader spr_quest_items_5, $8400, $1f|$80
	m_GfxHeader gfx_rings, $8a00, $3f|$80
	m_GfxHeader gfx_inventory_hud_2, $8e00, $1f|$80
	m_GfxHeader gfx_inventory_hud_1, $9000, $2f
gfxHeader3c:
	m_GfxHeader spr_credits_makutree, $8000, $3b|$80
	m_GfxHeader gfx_credits_makutree_1, $8800, $7f|$80
	m_GfxHeader gfx_credits_makutree_2, $9000, $7f|$80
	m_GfxHeader gfx_credits_gametitle, $8801, $69|$80
	m_GfxHeader map_credits_makutree, $9800, $23|$80
	m_GfxHeader flg_credits_makutree, $9801, $23|$80
	m_GfxHeader map_credits_gametitle, $9c40, $1b|$80
	m_GfxHeader flg_credits_gametitle, $9c41, $1b
gfxHeader3d:
	m_GfxHeader gfx_gasha_tree, $d807, $44|$80
	m_GfxHeader spr_grass_tuft, $dc57, $03
gfxHeader3e:
	m_GfxHeader gfx_sand, $dc57, $03
gfxHeader3f:
	m_GfxHeader gfx_dirt, $dc57, $03
gfxHeader40:
	m_GfxHeader gfx_tileset_overworld_standard, $8801, $5f|$80
	m_GfxHeader gfx_tileset_overworld_present, $8e01, $4f|$80
	m_GfxHeader gfx_tileset_lynna_city_1, $9301, $1f|$80
	m_GfxHeader gfx_tileset_lynna_city_2, $9501, $1f|$80
	m_GfxHeader gfx_tileset_lynna_city_3, $9701, $0f
gfxHeader41:
	m_GfxHeader gfx_tileset_overworld_standard, $8801, $5f|$80
	m_GfxHeader gfx_tileset_overworld_past, $8e01, $4f|$80
	m_GfxHeader gfx_tileset_lynna_city_1, $9301, $1f|$80
	m_GfxHeader gfx_tileset_lynna_city_2, $9501, $1f|$80
	m_GfxHeader gfx_tileset_lynna_city_3, $9701, $0f
gfxHeader42:
	m_GfxHeader gfx_tileset_overworld_standard, $8801, $5f|$80
	m_GfxHeader gfx_tileset_underwater_present, $8e01, $4f|$80
	m_GfxHeader gfx_tileset_underwater_common_1, $9301, $1f|$80
	m_GfxHeader gfx_tileset_underwater_common_2, $9501, $1f|$80
	m_GfxHeader gfx_tileset_underwater_common_3, $9701, $0f
gfxHeader43:
	m_GfxHeader gfx_tileset_overworld_standard, $8801, $5f|$80
	m_GfxHeader gfx_tileset_underwater_past, $8e01, $4f|$80
	m_GfxHeader gfx_tileset_underwater_common_1, $9301, $1f|$80
	m_GfxHeader gfx_tileset_underwater_common_2, $9501, $1f|$80
	m_GfxHeader gfx_tileset_underwater_common_3, $9701, $0f
gfxHeader44:
	m_GfxHeader spr_seaweed_cut, $8001, $01
gfxHeader45:
gfxHeader46:
gfxHeader47:
gfxHeader48:
gfxHeader49:
gfxHeader4a:
gfxHeader4b:
gfxHeader4c:
gfxHeader4d:
gfxHeader4e:
gfxHeader4f:
gfxHeader50:
	m_GfxHeader map_wing_dungeon_collapsing_1, $d002, $0b
gfxHeader51:
	m_GfxHeader map_wing_dungeon_collapsing_2, $d002, $0b
gfxHeader52:
	m_GfxHeader map_wing_dungeon_collapsing_3, $d002, $0b
gfxHeader53:
	m_GfxHeader map_wing_dungeon_collapsed, $d002, $0b
gfxHeader54:
gfxHeader55:
gfxHeader56:
gfxHeader57:
gfxHeader58:
gfxHeader59:
gfxHeader5a:
gfxHeader5b:
gfxHeader5c:
gfxHeader5d:
gfxHeader5e:
gfxHeader5f:
gfxHeader60:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_maku_path, $9401, $3f
gfxHeader61:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_spirits_grave, $9401, $25
gfxHeader62:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_wing_dungeon, $9401, $23
gfxHeader63:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_moonlit_grotto, $9401, $21
gfxHeader64:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_skull_dungeon, $9401, $29
gfxHeader65:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_crown_dungeon, $9401, $26
gfxHeader66:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_mermaids_cave, $9401, $2f
gfxHeader67:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_jabu_jabus_belly, $9401, $32
gfxHeader68:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_ancient_tomb, $9401, $3f|$80
	m_GfxHeader gfx_tileset_minecart_track, $90c1, $03
gfxHeader69:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_black_tower_top, $9401, $3f
gfxHeader6a:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_room_of_rites, $9401, $3f
gfxHeader6b:
gfxHeader6c:
gfxHeader6d:
	m_GfxHeader gfx_tileset_sidescroll_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_sidescroll_2, $9001, $7f
gfxHeader6e:
	m_GfxHeader gfx_tileset_black_tower, $8801, $6f
gfxHeader6f:
	m_GfxHeader spr_common_sprites, $d006, $4d
gfxHeader70:
	m_GfxHeader gfx_tileset_maku_tree_common, $8801, $2f|$80
	m_GfxHeader gfx_tileset_maku_tree_bottom, $8b01, $6f
gfxHeader71:
	m_GfxHeader gfx_tileset_maku_tree_common, $8801, $2f|$80
	m_GfxHeader gfx_tileset_maku_tree_top, $8b01, $4f
gfxHeader72:
	m_GfxHeader map_mermaids_cave_wall_retraction, $d002, $23|$80
	m_GfxHeader flg_mermaids_cave_wall_retraction, $d402, $23
gfxHeader73:
	m_GfxHeader map_ancient_tomb_wall_retraction, $d002, $17|$80
	m_GfxHeader flg_ancient_tomb_wall_retraction, $d402, $17
gfxHeader74:
	m_GfxHeader map_jabu_opening_1, $d8e3, $07|$80
	m_GfxHeader flg_jabu_opening_1, $dce3, $07
gfxHeader75:
	m_GfxHeader map_jabu_opening_2, $d8e3, $07|$80
	m_GfxHeader flg_jabu_opening_2, $dce3, $07
gfxHeader76:
gfxHeader77:
gfxHeader78:
gfxHeader79:
gfxHeader7a:
gfxHeader7b:
	m_GfxHeader gfx_tileset_indoors_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_indoors_rafton, $9001, $7f
gfxHeader7c:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_cave_replacement_1, $8801, $0f|$80
	m_GfxHeader gfx_tileset_cave_replacement_2, $8b01, $4f|$80
	m_GfxHeader gfx_tileset_cave_1, $9001, $5f|$80
	m_GfxHeader gfx_tileset_cave_2, $9601, $1f
gfxHeader7d:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_cave_replacement_1, $8801, $0f|$80
	m_GfxHeader gfx_tileset_cave_replacement_2, $8b01, $4f|$80
	m_GfxHeader gfx_tileset_cave_1, $9001, $5f|$80
	m_GfxHeader gfx_tileset_goron_cave, $9601, $1f
gfxHeader7e:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_moblin_fortress, $9401, $3f
gfxHeader7f:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_zora_palace, $9401, $3f|$80
	m_GfxHeader gfx_tileset_zora_palace_replacement_1, $8b01, $03|$80
	m_GfxHeader gfx_tileset_zora_palace_replacement_2, $9181, $07
gfxHeader80:
	m_GfxHeader map_black_tower_stage_3_top, $d004, $0f|$80
	m_GfxHeader flg_black_tower_stage_3_top, $d404, $0f|$80
	m_GfxHeader map_black_tower_stage_3_middle, $9800, $1d|$80
	m_GfxHeader flg_black_tower_stage_3_middle, $9801, $1d
gfxHeader81:
	m_GfxHeader map_black_tower_stage_2, $9840, $19|$80
	m_GfxHeader flg_black_tower_stage_2, $9841, $19
gfxHeader82:
	m_GfxHeader map_black_tower_stage_1, $99c0, $17|$80
	m_GfxHeader flg_black_tower_stage_1, $99c1, $17|$80
	m_GfxHeader map_black_tower_stage_1, $d803, $17|$80
	m_GfxHeader flg_black_tower_stage_1, $dc03, $17
gfxHeader83:
	m_GfxHeader spr_common_sprites, $8001, $4d
gfxHeader84:
	m_GfxHeader map_credits_maku_past_top_rows, $9800, $03|$80
	m_GfxHeader flg_credits_maku_past_top_rows, $9801, $03
gfxHeader85:
	m_GfxHeader map_credits_scene1_top_rows, $9800, $03|$80
	m_GfxHeader flg_credits_scene1_top_rows, $9801, $03
gfxHeader86:
	m_GfxHeader spr_credits_font, $8000, $3b|$80
	m_GfxHeader spr_credits_font_planners, $8400, $21|$80
	m_GfxHeader gfx_credits_image1_1, $8800, $7f|$80
	m_GfxHeader gfx_credits_image1_2, $9000, $58|$80
	m_GfxHeader map_credits_image1, $9800, $23|$80
	m_GfxHeader flg_credits_image1, $9801, $23
gfxHeader87:
	m_GfxHeader map_credits_scene2, $9a00, $03|$80
	m_GfxHeader flg_credits_scene2, $9a01, $03
gfxHeader88:
	m_GfxHeader spr_credits_font, $8000, $3b|$80
	m_GfxHeader spr_credits_font, $d004, $3b|$80
	m_GfxHeader spr_credits_font_nakanowatari, $d404, $13|$80
	m_GfxHeader spr_credits_font, $d803, $3b|$80
	m_GfxHeader spr_credits_font_nakanowatari, $dc03, $13|$80
	m_GfxHeader spr_credits_font_nakanowatari, $8400, $13|$80
	m_GfxHeader spr_credits_font_programmers, $8600, $13|$80
	m_GfxHeader gfx_credits_image2_1, $8800, $7f|$80
	m_GfxHeader gfx_credits_image2_2, $9000, $57|$80
	m_GfxHeader map_credits_image2, $9800, $23|$80
	m_GfxHeader flg_credits_image2, $9801, $23
gfxHeader89:
	m_GfxHeader map_credits_scene3_top_rows, $9800, $03|$80
	m_GfxHeader flg_credits_scene3_top_rows, $9801, $03
gfxHeader8a:
	m_GfxHeader spr_credits_font, $8000, $3b|$80
	m_GfxHeader spr_credits_font, $d004, $3b|$80
	m_GfxHeader spr_credits_font_object_designers, $d404, $1f|$80
	m_GfxHeader spr_credits_font, $d803, $3b|$80
	m_GfxHeader spr_credits_font_object_designers, $dc03, $1f|$80
	m_GfxHeader spr_credits_font_object_designers, $8400, $1f|$80
	m_GfxHeader gfx_credits_image3_1, $8800, $7f|$80
	m_GfxHeader gfx_credits_image3_2, $9000, $5c|$80
	m_GfxHeader map_credits_image3, $9800, $23|$80
	m_GfxHeader flg_credits_image3, $9801, $23
gfxHeader8b:
	m_GfxHeader map_credits_scene4_top_rows, $9a00, $03|$80
	m_GfxHeader flg_credits_scene4_top_rows, $9a01, $03
gfxHeader8c:
	m_GfxHeader spr_credits_font, $8000, $3b|$80
	m_GfxHeader spr_credits_font, $d004, $3b|$80
	m_GfxHeader spr_credits_font_music, $d404, $19|$80
	m_GfxHeader spr_credits_font, $d803, $3b|$80
	m_GfxHeader spr_credits_font_music, $dc03, $19|$80
	m_GfxHeader spr_credits_font_music, $8400, $19|$80
	m_GfxHeader gfx_credits_image4_1, $8800, $7f|$80
	m_GfxHeader gfx_credits_image4_2, $9000, $53|$80
	m_GfxHeader map_credits_image4, $9800, $23|$80
	m_GfxHeader flg_credits_image4, $9801, $23
gfxHeader8d:
	m_GfxHeader gfx_tileset_overworld_standard, $8801, $5f|$80
	m_GfxHeader gfx_tileset_overworld_present, $8e01, $4f|$80
	m_GfxHeader gfx_tileset_credits, $9301, $3f|$80
	m_GfxHeader map_credits_linked_scene1, $9800, $23|$80
	m_GfxHeader flg_credits_linked_scene1, $9801, $23
gfxHeader8e:
	m_GfxHeader spr_credits_font, $8000, $3b|$80
	m_GfxHeader spr_credits_font_planners, $8400, $21|$80
	m_GfxHeader gfx_credits_linked_image1_1, $8800, $7f|$80
	m_GfxHeader gfx_credits_linked_image1_2, $9000, $5f|$80
	m_GfxHeader map_credits_linked_image1, $9800, $23|$80
	m_GfxHeader flg_credits_linked_image1, $9801, $23
gfxHeader8f:
	m_GfxHeader gfx_tileset_overworld_standard, $8801, $5f|$80
	m_GfxHeader gfx_tileset_overworld_present, $8e01, $4f|$80
	m_GfxHeader gfx_tileset_credits, $9301, $3f|$80
	m_GfxHeader map_credits_linked_scene2, $9800, $23|$80
	m_GfxHeader flg_credits_linked_scene2, $9801, $23
gfxHeader90:
	m_GfxHeader spr_credits_font, $8000, $3b|$80
	m_GfxHeader spr_credits_font, $d004, $3b|$80
	m_GfxHeader spr_credits_font_nakanowatari, $d404, $13|$80
	m_GfxHeader spr_credits_font, $d803, $3b|$80
	m_GfxHeader spr_credits_font_nakanowatari, $dc03, $13|$80
	m_GfxHeader spr_credits_font_nakanowatari, $8400, $13|$80
	m_GfxHeader spr_credits_font_programmers, $8600, $13|$80
	m_GfxHeader gfx_credits_linked_image2_1, $8800, $7f|$80
	m_GfxHeader gfx_credits_linked_image2_2, $9000, $5e|$80
	m_GfxHeader map_credits_linked_image2, $9800, $23|$80
	m_GfxHeader flg_credits_linked_image2, $9801, $23
gfxHeader91:
	m_GfxHeader gfx_tileset_overworld_standard, $8801, $5f|$80
	m_GfxHeader gfx_tileset_overworld_present, $8e01, $4f|$80
	m_GfxHeader gfx_tileset_credits, $9301, $3f|$80
	m_GfxHeader map_credits_linked_scene3, $9800, $23|$80
	m_GfxHeader flg_credits_linked_scene3, $9801, $23
gfxHeader92:
	m_GfxHeader spr_credits_font, $8000, $3b|$80
	m_GfxHeader spr_credits_font, $d004, $3b|$80
	m_GfxHeader spr_credits_font_object_designers, $d404, $1f|$80
	m_GfxHeader spr_credits_font, $d803, $3b|$80
	m_GfxHeader spr_credits_font_object_designers, $dc03, $1f|$80
	m_GfxHeader spr_credits_font_object_designers, $8400, $1f|$80
	m_GfxHeader gfx_credits_linked_image3_1, $8800, $7f|$80
	m_GfxHeader gfx_credits_linked_image3_2, $9000, $60|$80
	m_GfxHeader map_credits_linked_image3, $9800, $23|$80
	m_GfxHeader flg_credits_linked_image3, $9801, $23
gfxHeader93:
	m_GfxHeader gfx_tileset_overworld_standard, $8801, $5f|$80
	m_GfxHeader gfx_tileset_overworld_present, $8e01, $4f|$80
	m_GfxHeader gfx_tileset_credits, $9301, $3f|$80
	m_GfxHeader map_credits_linked_scene4, $9800, $23|$80
	m_GfxHeader flg_credits_linked_scene4, $9801, $23
gfxHeader94:
	m_GfxHeader spr_credits_font, $8000, $3b|$80
	m_GfxHeader spr_credits_font, $d004, $3b|$80
	m_GfxHeader spr_credits_font_music, $d404, $19|$80
	m_GfxHeader spr_credits_font, $d803, $3b|$80
	m_GfxHeader spr_credits_font_music, $dc03, $19|$80
	m_GfxHeader spr_credits_font_music, $8400, $19|$80
	m_GfxHeader gfx_credits_linked_image4_1, $8800, $7f|$80
	m_GfxHeader gfx_credits_linked_image4_2, $9000, $4e|$80
	m_GfxHeader map_credits_linked_image4, $9800, $23|$80
	m_GfxHeader flg_credits_linked_image4, $9801, $23
gfxHeader95:
	m_GfxHeader spr_credits_font, $8000, $3b|$80
	m_GfxHeader spr_credits_sprites_1, $8400, $3f|$80
	m_GfxHeader spr_credits_sprites_2, $8001, $73|$80
	m_GfxHeader spr_triforce_sparkle_vineseed_bookofseals, $d004, $1f|$80
	m_GfxHeader gfx_credits_bg_1, $8800, $7f|$80
	m_GfxHeader gfx_credits_bg_2, $9000, $7f|$80
	m_GfxHeader gfx_credits_bg_3, $8801, $7f|$80
	m_GfxHeader map_credits_bg, $9800, $3f|$80
	m_GfxHeader flg_credits_bg, $9801, $3f
gfxHeader96:
	m_GfxHeader gfx_tobecontinued, $8800, $7d|$80
	m_GfxHeader map_tobecontinued, $9800, $23|$80
	m_GfxHeader flg_tobecontinued, $9801, $23
gfxHeader97:
	m_GfxHeader spr_fileselect_decorations, $8200, $13|$80
	m_GfxHeader gfx_hud, $9000, $07|$80
	m_GfxHeader gfx_hud, $9001, $1f|$80
	m_GfxHeader gfx_fileselect, $9201, $5f|$80
	m_GfxHeader gfx_secrettoholodrum, $8801, $1f|$80
	m_GfxHeader map_file_menu_top, $d803, $09|$80
	m_GfxHeader flg_file_menu_top, $dc03, $09|$80
	m_GfxHeader map_secret_for_linked_game, $d8a3, $13|$80
	m_GfxHeader flg_secret_for_linked_game, $dca3, $13|$80
	m_GfxHeader map_save_menu_bottom, $d9e3, $07|$80
	m_GfxHeader flg_save_menu_bottom, $dde3, $07
gfxHeader98:
	m_GfxHeader gfx_credits_theend_1, $8801, $7f|$80
	m_GfxHeader gfx_credits_theend_2, $9001, $43|$80
	m_GfxHeader map_credits_theend, $9800, $23|$80
	m_GfxHeader flg_credits_theend, $9801, $23
gfxHeader99:
	m_GfxHeader gfx_credits_linked_theend_1, $8a01, $5f|$80
	m_GfxHeader gfx_credits_linked_theend_2, $9001, $57|$80
	m_GfxHeader map_credits_linked_theend, $9800, $23|$80
	m_GfxHeader flg_credits_linked_theend, $9801, $23
gfxHeader9a:
	m_GfxHeader spr_credits_linked_waving_goodbye, $8000, $27|$80
	m_GfxHeader gfx_credits_linked_waving_goodbye_1, $8800, $7f|$80
	m_GfxHeader gfx_credits_linked_waving_goodbye_2, $9000, $0f|$80
	m_GfxHeader gfx_credits_linked_waving_goodbye_3, $8801, $7f|$80
	m_GfxHeader gfx_credits_linked_waving_goodbye_4, $9001, $7f|$80
	m_GfxHeader map_credits_linked_waving_goodbye_1, $9800, $3f|$80
	m_GfxHeader flg_credits_linked_waving_goodbye_1, $9801, $3f|$80
	m_GfxHeader map_credits_linked_waving_goodbye_2, $d004, $0b|$80
	m_GfxHeader flg_credits_linked_waving_goodbye_2, $d404, $0b
gfxHeader9b:
	m_GfxHeader spr_intro_link_on_horse_front, $8000, $6f|$80
	m_GfxHeader gfx_intro_link_on_horse_front_bg, $8800, $69|$80
	m_GfxHeader gfx_intro_link_face_shot, $9000, $62|$80
	m_GfxHeader spr_intro_link_on_horse_far, $8001, $6d|$80
	m_GfxHeader spr_intro_link_face_shot_sparkle, $8801, $25|$80
	m_GfxHeader gfx_intro_link_on_horse_far_bg_1, $8c01, $3f|$80
	m_GfxHeader gfx_intro_link_on_horse_far_bg_2, $9001, $1a|$80
	m_GfxHeader map_intro_link_on_horse_far, $9860, $29|$80
	m_GfxHeader flg_intro_link_on_horse_far, $9861, $29|$80
	m_GfxHeader map_intro_link_face_shot, $9b20, $0b|$80
	m_GfxHeader flg_intro_link_face_shot, $9b21, $0b|$80
	m_GfxHeader map_intro_bar, $9c00, $05|$80
	m_GfxHeader flg_intro_bar, $9c01, $05|$80
	m_GfxHeader map_intro_link_on_horse_front_ground, $d803, $09|$80
	m_GfxHeader flg_intro_link_on_horse_front_ground, $dc03, $09|$80
	m_GfxHeader map_intro_bar, $9e60, $05|$80
	m_GfxHeader flg_intro_bar, $9e61, $05|$80
	m_GfxHeader map_intro_link_on_horse_front_bg, $9ec0, $13|$80
	m_GfxHeader flg_intro_link_on_horse_front_bg, $9ec1, $13
gfxHeader9c:
	m_GfxHeader map_link_on_horse_closeup, $9c00, $3f|$80
	m_GfxHeader flg_link_on_horse_closeup, $9c01, $3f|$80
	m_GfxHeader spr_link_on_horse_closeup, $8000, $4d|$80
	m_GfxHeader gfx_link_on_horse_closeup_1, $8800, $7f|$80
	m_GfxHeader gfx_link_on_horse_closeup_2, $9000, $7f|$80
	m_GfxHeader gfx_link_on_horse_closeup_3, $8801, $7f|$80
	m_GfxHeader gfx_link_on_horse_closeup_4, $9001, $2d
gfxHeader9d:
	m_GfxHeader spr_intro_outside_castle_sprites, $8000, $6d|$80
	m_GfxHeader gfx_intro_outside_castle_1, $8800, $7f|$80
	m_GfxHeader gfx_intro_outside_castle_2, $9000, $7f|$80
	m_GfxHeader gfx_intro_outside_castle_3, $8801, $4f|$80
	m_GfxHeader map_intro_outside_castle, $9c00, $23|$80
	m_GfxHeader flg_intro_outside_castle, $9c01, $23
gfxHeader9e:
	m_GfxHeader gfx_tileset_dungeon_standard_1, $8801, $7f|$80
	m_GfxHeader gfx_tileset_dungeon_standard_2, $9001, $3f|$80
	m_GfxHeader gfx_tileset_maku_path, $9401, $3f|$80
	m_GfxHeader gfx_hud, $9000, $07|$80
	m_GfxHeader map_intro_triforce_room, $9800, $3f|$80
	m_GfxHeader flg_intro_triforce_room, $9801, $3f|$80
	m_GfxHeader map_intro_triforce_room, $d803, $3f|$80
	m_GfxHeader flg_intro_triforce_room, $dc03, $3f
gfxHeader9f:
	m_GfxHeader gfx_titlescreen_5, $8800, $4f|$80
	m_GfxHeader gfx_titlescreen_2, $8d00, $5f|$80
	m_GfxHeader gfx_titlescreen_7, $9300, $0f|$80
	m_GfxHeader gfx_titlescreen_4, $9400, $3f|$80
	m_GfxHeader gfx_titlescreen_tree_1, $8801, $7f|$80
	m_GfxHeader gfx_titlescreen_tree_2, $9001, $7f|$80
	m_GfxHeader map_titlescreen_scroll_2, $d004, $29|$80
	m_GfxHeader flg_titlescreen_scroll_2, $d404, $29|$80
	m_GfxHeader map_titlescreen_scroll_1, $9c00, $3f|$80
	m_GfxHeader flg_titlescreen_scroll_1, $9c01, $3f
gfxHeadera0:
	m_GfxHeader spr_link, $8000, $1f|$80 $200
	m_GfxHeader spr_rod_of_seasons, $81a0, $03|$80
	m_GfxHeader gfx_hud, $9000, $1f|$80
	m_GfxHeader gfx_hud, $9001, $1f|$80
	m_GfxHeader spr_fileselect_decorations, $8200, $13|$80
	m_GfxHeader gfx_fileselect, $9201, $5f
gfxHeaderba:
	m_GfxHeader map_file_menu_message_speed, $d244, $07|$80
	m_GfxHeader flg_file_menu_message_speed, $d644, $07|$80
	; Fall through
gfxHeadera1:
	m_GfxHeader spr_din_1, $8001, $05|$80
	m_GfxHeader spr_nayru_1, $8061, $03|$80
	m_GfxHeader gfx_messagespeed, $9200, $1f|$80
	m_GfxHeader gfx_pickafile_2, $8801, $1f|$80
	m_GfxHeader gfx_copy, $8a01, $09|$80
	m_GfxHeader gfx_erase, $8aa1, $09|$80
	; Fall through
gfxHeadera2:
	m_GfxHeader map_file_menu_top, $d004, $09|$80
	m_GfxHeader flg_file_menu_top, $d404, $09|$80
	m_GfxHeader map_file_menu_middle, $d0a4, $13|$80
	m_GfxHeader flg_file_menu_middle, $d4a4, $13|$80
	m_GfxHeader map_file_menu_bottom, $d1e4, $05|$80
	m_GfxHeader flg_file_menu_bottom, $d5e4, $05
gfxHeadera3:
	m_GfxHeader gfx_copywhatwhere, $8801, $1f|$80
	m_GfxHeader gfx_quit_2, $8a01, $09|$80
	m_GfxHeader gfx_copy, $8aa1, $09|$80
	m_GfxHeader map_file_menu_top, $d004, $09|$80
	m_GfxHeader flg_file_menu_top, $d404, $09|$80
	m_GfxHeader map_file_menu_copy, $d0a4, $13|$80
	m_GfxHeader flg_file_menu_copy, $d4a4, $13|$80
	m_GfxHeader map_file_menu_bottom, $d1e4, $05|$80
	m_GfxHeader flg_file_menu_bottom, $d5e4, $05
gfxHeadera4:
	m_GfxHeader gfx_pickafile, $8801, $1f|$80
	m_GfxHeader gfx_quit_2, $8a01, $09|$80
	m_GfxHeader gfx_erase, $8aa1, $09
gfxHeadera5:
	m_GfxHeader gfx_name, $8801, $09|$80
	m_GfxHeader map_name_entry_top, $d004, $09|$80
	m_GfxHeader flg_name_entry_top, $d404, $09|$80
	m_GfxHeader map_name_entry_middle, $d0a4, $13|$80
	m_GfxHeader flg_name_entry_middle, $d4a4, $13|$80
	m_GfxHeader map_name_entry_bottom, $d1e4, $07|$80
	m_GfxHeader flg_name_entry_bottom, $d5e4, $07
gfxHeadera6:
	m_GfxHeader map_file_menu_top, $d004, $09|$80
	m_GfxHeader flg_file_menu_top, $d404, $09|$80
	m_GfxHeader map_save_menu_middle, $d0a4, $13|$80
	m_GfxHeader flg_save_menu_middle, $d4a4, $13|$80
	m_GfxHeader map_save_menu_bottom, $d1e4, $07|$80
	m_GfxHeader flg_save_menu_bottom, $d5e4, $07
gfxHeadera7:
	m_GfxHeader gfx_newfilescreen, $8801, $67
gfxHeadera8:
	m_GfxHeader gfx_savescreen, $8801, $67
gfxHeadera9:
	m_GfxHeader gfx_gameover, $8801, $1f
gfxHeaderaa:
	m_GfxHeader gfx_secret_thatswrong, $8801, $1f
gfxHeaderab:
	m_GfxHeader map_name_entry_top, $d004, $09|$80
	m_GfxHeader flg_name_entry_top, $d404, $09|$80
	m_GfxHeader map_secret_entry_middle, $d0a4, $13|$80
	m_GfxHeader flg_secret_entry_middle, $d4a4, $13|$80
	m_GfxHeader map_secret_entry_bottom, $d1e4, $07|$80
	m_GfxHeader flg_secret_entry_bottom, $d5e4, $07
gfxHeaderac:
	m_GfxHeader map_secret_entry_top, $d004, $09|$80
	m_GfxHeader flg_secret_entry_top, $d404, $09|$80
	m_GfxHeader map_secret_entry_middle, $d0a4, $13|$80
	m_GfxHeader flg_secret_entry_middle, $d4a4, $13|$80
	m_GfxHeader map_secret_entry_bottom, $d1e4, $07|$80
	m_GfxHeader flg_secret_entry_bottom, $d5e4, $07
gfxHeaderad:
	m_GfxHeader map_secret_entry_error, $d144, $03|$80
	m_GfxHeader flg_secret_entry_error, $d544, $03
gfxHeaderae:
	m_GfxHeader gfx_messagespeed, $9200, $1f|$80
	m_GfxHeader gfx_pickafile_2, $8801, $1f|$80
	m_GfxHeader gfx_copy, $8a01, $09|$80
	m_GfxHeader gfx_erase, $8aa1, $09|$80
	m_GfxHeader map_file_menu_top, $d004, $09|$80
	m_GfxHeader flg_file_menu_top, $d404, $09|$80
	m_GfxHeader map_file_menu_middle, $d0a4, $13|$80
	m_GfxHeader flg_file_menu_middle, $d4a4, $13|$80
	m_GfxHeader map_file_menu_bottom, $d1e4, $05|$80
	m_GfxHeader flg_file_menu_bottom, $d5e4, $05|$80
	m_GfxHeader gfx_linking, $8801, $1f|$80
gfxHeaderaf:
	m_GfxHeader gfx_quit, $8a01, $13
gfxHeaderb0:
	m_GfxHeader spr_ganon_1, $8000, $1f|$80
	m_GfxHeader spr_twinrova_sacrifice_1, $8200, $1f|$80
	m_GfxHeader spr_twinrova_sacrifice_2, $8400, $1f|$80
	m_GfxHeader spr_twinrova_sacrifice_3, $8600, $1f|$80
	m_GfxHeader spr_twinrova_sacrifice_4, $8800, $1d
gfxHeaderb1:
	m_GfxHeader spr_ganon_2, $d002, $1d
gfxHeaderb2:
	m_GfxHeader spr_ganon_5, $d002, $1f
gfxHeaderb3:
	m_GfxHeader spr_ganon_6, $d002, $11
gfxHeaderb4:
	m_GfxHeader spr_ganon_7, $d002, $17
gfxHeaderb5:
	m_GfxHeader spr_ganon_8, $d002, $1f
gfxHeaderb6:
	m_GfxHeader spr_ganon_9, $d002, $1f
gfxHeaderb7:
	m_GfxHeader spr_ganon_10, $d002, $1f
gfxHeaderb8:
	m_GfxHeader oth_twinrova_lava_layout, $cf00, $0a
gfxHeaderb9:
	m_GfxHeader oth_twinrova_normal_layout, $cf00, $0a
