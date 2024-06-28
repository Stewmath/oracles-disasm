; Unique GFX headers function mostly the same as normal gfx headers (data/{game}/gfxHeaders.s), but
; they are used exclusively by tilesets. These are loaded after the main gfx header and may
; overwrite some data from that.
;
; The only technical difference from regular gfx headers is that the last entry may be a palette
; header (data/{game}/paletteHeaders.s). This functionality is primarily used in Seasons.

.define NUM_UNIQUE_GFX_HEADERS $15

uniqueGfxHeadersStart:

; HACK-BASE: All data removed for expanded tilesets patch.
; TODO: Fix "uniqueGfxHeader14" reference if necessary

m_UniqueGfxHeaderStart $00, UNIQUE_GFXH_NONE
m_UniqueGfxHeaderStart $01, UNIQUE_GFXH_LYNNA_CITY_1
m_UniqueGfxHeaderStart $02, UNIQUE_GFXH_LYNNA_CITY_2
m_UniqueGfxHeaderStart $03, UNIQUE_GFXH_YOLL_GRAVEYARD
m_UniqueGfxHeaderStart $04, UNIQUE_GFXH_BLACK_TOWER_OUTSIDE
m_UniqueGfxHeaderStart $05, UNIQUE_GFXH_FOREST_OF_TIME
m_UniqueGfxHeaderStart $06, UNIQUE_GFXH_FAIRY_FOREST
m_UniqueGfxHeaderStart $07, UNIQUE_GFXH_CRESCENT_ISLAND
m_UniqueGfxHeaderStart $08, UNIQUE_GFXH_SYMMETRY_CITY_RUINED
m_UniqueGfxHeaderStart $09, UNIQUE_GFXH_TALUS_PEAKS
m_UniqueGfxHeaderStart $0a, UNIQUE_GFXH_TALUS_PEAKS_PAST
m_UniqueGfxHeaderStart $0b, UNIQUE_GFXH_SYMMETRY_CITY_RESTORED
m_UniqueGfxHeaderStart $0c, UNIQUE_GFXH_ROLLING_RIDGE_PRESENT
m_UniqueGfxHeaderStart $0d, UNIQUE_GFXH_ROLLING_RIDGE_PAST
m_UniqueGfxHeaderStart $0e, UNIQUE_GFXH_EYEGLASS_LIBRARY_OUTSIDE
m_UniqueGfxHeaderStart $0f, UNIQUE_GFXH_SEA_OF_NO_RETURN
m_UniqueGfxHeaderStart $10, UNIQUE_GFXH_NUUN_HIGHLANDS
m_UniqueGfxHeaderStart $11, UNIQUE_GFXH_AMBIS_PALACE_OUTSIDE
m_UniqueGfxHeaderStart $12, UNIQUE_GFXH_JABU_JABU_OUTSIDE
m_UniqueGfxHeaderStart $13, UNIQUE_GFXH_UNDERWATER

m_UniqueGfxHeaderStart $14, UNIQUE_GFXH_ANCIENT_TOMB_BOSS
	m_GfxHeaderEnd PALH_TILESET_ANCIENT_TOMB_BOSS


uniqueGfxHeaderTable:
	.repeat NUM_UNIQUE_GFX_HEADERS index COUNT
		.dw uniqueGfxHeader{%.2x{COUNT}}
	.endr
