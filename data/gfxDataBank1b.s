; Ricky, dimitri, moosh, maple graphics must be in the bank after gfx_link (or
; the same bank).

	m_GfxDataSimple gfx_ricky		; $06c000
	m_GfxDataSimple gfx_dimitri		; $06d220
	m_GfxDataSimple gfx_moosh		; $06de20
	m_GfxDataSimple gfx_maple		; $06ea20

.ifdef ROM_AGES
	m_GfxDataSimple gfx_raft		; $06f620
	m_GfxDataSimple gfx_impa_fainted	; $06f6a0

	m_GfxDataSimple gfx_animations_2	; $06f6e0

.else; ROM_SEASONS

	m_GfxDataSimple gfx_item_icons_1
	m_GfxDataSimple gfx_item_icons_2
	m_GfxDataSimple gfx_item_icons_3

	m_GfxDataSimple gfx_key_orechunk
.endif
