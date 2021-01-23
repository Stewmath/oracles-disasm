; Ricky, dimitri, moosh, maple graphics must be in the bank after spr_link (or
; the same bank).

	m_GfxDataSimple spr_ricky		; $06c000
	m_GfxDataSimple spr_dimitri		; $06d220
	m_GfxDataSimple spr_moosh		; $06de20
	m_GfxDataSimple spr_maple		; $06ea20

	m_GfxDataSimple gfx_partial_hearts

.ifdef ROM_AGES
	m_GfxDataSimple spr_raft		; $06f620
	m_GfxDataSimple spr_impa_fainted	; $06f6a0

	m_GfxDataSimple gfx_animations_2	; $06f6e0

	m_GfxDataSimple gfx_key

.else; ROM_SEASONS

	m_GfxDataSimple spr_item_icons_1
	m_GfxDataSimple spr_item_icons_2
	m_GfxDataSimple spr_item_icons_3

	m_GfxDataSimple gfx_key_orechunk
.endif
