; Unique GFX headers function mostly the same as normal gfx headers (data/{game}/gfxHeaders.s), but
; they are used exclusively by tilesets. These are loaded after the main gfx header and may
; overwrite some data from that.
;
; Unlike regular GFX headers, these can be loaded while the gameboy screen is on. In order to fit
; within the vblank period, only one entry is loaded per frame. It seems like the developers adopted
; a maximum of $200 bytes per entry, beyond which graphical corruption would likely occur.
;
; The format of unique GFX headers is identical to that of regular GFX headers, except that the last
; entry may be a palette header (data/{game}/paletteHeaders.s). This functionality is primarily used
; in Seasons.

.define NUM_UNIQUE_GFX_HEADERS $15

uniqueGfxHeadersStart:

m_UniqueGfxHeaderStart $00, UNIQUE_GFXH_NONE

m_UniqueGfxHeaderStart $01, UNIQUE_GFXH_LYNNA_CITY_1
	m_GfxHeader gfx_tileset_lynna_city_1, $9301
	m_GfxHeader gfx_tileset_lynna_city_2, $9501
	m_GfxHeader gfx_tileset_lynna_city_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $02, UNIQUE_GFXH_LYNNA_CITY_2
	m_GfxHeader gfx_tileset_lynna_city_1, $9301
	m_GfxHeader gfx_tileset_lynna_city_2, $9501
	m_GfxHeader gfx_tileset_lynna_city_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $03, UNIQUE_GFXH_YOLL_GRAVEYARD
	m_GfxHeader gfx_tileset_yoll_graveyard_1, $9301
	m_GfxHeader gfx_tileset_yoll_graveyard_2, $9501
	m_GfxHeader gfx_tileset_yoll_graveyard_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $04, UNIQUE_GFXH_BLACK_TOWER_OUTSIDE
	m_GfxHeader gfx_tileset_black_tower_outside_1, $9301
	m_GfxHeader gfx_tileset_black_tower_outside_2, $9501
	m_GfxHeader gfx_tileset_black_tower_outside_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $05, UNIQUE_GFXH_FOREST_OF_TIME
	m_GfxHeader gfx_tileset_forest_of_time_1, $9301
	m_GfxHeader gfx_tileset_forest_of_time_2, $9501
	m_GfxHeader gfx_tileset_forest_of_time_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $06, UNIQUE_GFXH_FAIRY_FOREST
	m_GfxHeader gfx_tileset_fairy_forest_1, $9301
	m_GfxHeader gfx_tileset_fairy_forest_2, $9501
	m_GfxHeader gfx_tileset_fairy_forest_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $07, UNIQUE_GFXH_CRESCENT_ISLAND
	m_GfxHeader gfx_tileset_tokay_island_1, $9301
	m_GfxHeader gfx_tileset_tokay_island_2, $9501
	m_GfxHeader gfx_tileset_tokay_island_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $08, UNIQUE_GFXH_SYMMETRY_CITY_RUINED
	m_GfxHeader gfx_tileset_symmetry_city_ruined_1, $9301
	m_GfxHeader gfx_tileset_symmetry_city_ruined_2, $9501
	m_GfxHeader gfx_tileset_symmetry_city_ruined_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $09, UNIQUE_GFXH_TALUS_PEAKS
	m_GfxHeader gfx_tileset_talus_peaks_1, $9301
	m_GfxHeader gfx_tileset_talus_peaks_2, $9501
	m_GfxHeader gfx_tileset_talus_peaks_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $0a, UNIQUE_GFXH_TALUS_PEAKS_PAST
	m_GfxHeader gfx_tileset_talus_peaks_past_1, $9301
	m_GfxHeader gfx_tileset_talus_peaks_past_2, $9501
	m_GfxHeader gfx_tileset_talus_peaks_past_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $0b, UNIQUE_GFXH_SYMMETRY_CITY_RESTORED
	m_GfxHeader gfx_tileset_symmetry_city_restored_1, $9301
	m_GfxHeader gfx_tileset_symmetry_city_restored_2, $9501
	m_GfxHeader gfx_tileset_symmetry_city_restored_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $0c, UNIQUE_GFXH_ROLLING_RIDGE_PRESENT
	m_GfxHeader gfx_tileset_rolling_ridge_present_1, $9301
	m_GfxHeader gfx_tileset_rolling_ridge_present_2, $9501
	m_GfxHeader gfx_tileset_rolling_ridge_present_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $0d, UNIQUE_GFXH_ROLLING_RIDGE_PAST
	m_GfxHeader gfx_tileset_rolling_ridge_past_1, $9301
	m_GfxHeader gfx_tileset_rolling_ridge_past_2, $9501
	m_GfxHeader gfx_tileset_rolling_ridge_past_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $0e, UNIQUE_GFXH_EYEGLASS_LIBRARY_OUTSIDE
	m_GfxHeader gfx_tileset_eyeglass_library_1, $9301
	m_GfxHeader gfx_tileset_eyeglass_library_2, $9501
	m_GfxHeader gfx_tileset_eyeglass_library_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $0f, UNIQUE_GFXH_SEA_OF_NO_RETURN
	m_GfxHeader gfx_tileset_sea_of_no_return_1, $9301
	m_GfxHeader gfx_tileset_sea_of_no_return_2, $9501
	m_GfxHeader gfx_tileset_sea_of_no_return_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $10, UNIQUE_GFXH_NUUN_HIGHLANDS
	m_GfxHeader gfx_tileset_nuun_highlands_1, $9301
	m_GfxHeader gfx_tileset_nuun_highlands_2, $9501
	m_GfxHeader gfx_tileset_nuun_highlands_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $11, UNIQUE_GFXH_AMBIS_PALACE_OUTSIDE
	m_GfxHeader gfx_tileset_ambis_palace_1, $9301
	m_GfxHeader gfx_tileset_ambis_palace_2, $9501
	m_GfxHeader gfx_tileset_ambis_palace_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $12, UNIQUE_GFXH_JABU_JABU_OUTSIDE
	m_GfxHeader gfx_tileset_jabu_jabu_outside_1, $9301
	m_GfxHeader gfx_tileset_jabu_jabu_outside_2, $9501
	m_GfxHeader gfx_tileset_jabu_jabu_outside_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $13, UNIQUE_GFXH_UNDERWATER
	m_GfxHeader gfx_tileset_underwater_common_1, $9301
	m_GfxHeader gfx_tileset_underwater_common_2, $9501
	m_GfxHeader gfx_tileset_underwater_common_3, $9701
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $14, UNIQUE_GFXH_ANCIENT_TOMB_BOSS
	m_GfxHeaderEnd PALH_TILESET_ANCIENT_TOMB_BOSS


uniqueGfxHeaderTable:
	.repeat NUM_UNIQUE_GFX_HEADERS index COUNT
		.dw uniqueGfxHeader{%.2x{COUNT}}
	.endr
