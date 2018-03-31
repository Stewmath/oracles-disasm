gfxDataBank1a:
	m_GfxDataSimple gfx_link			; $068000
	m_GfxDataSimple gfx_dungeon_sprites		; $06a2e0
	m_GfxDataSimple gfx_subrosian			; $06a4e0
	m_GfxDataSimple gfx_link_retro			; $06a6e0
	m_GfxDataSimple gfx_octorok_leever_tektite_zora	; $06a7e0
	m_GfxDataSimple gfx_moblin			; $06a9e0
	m_GfxDataSimple gfx_ballandchain_likelike	; $06ab40
	m_GfxDataSimple gfx_link_baby			; $06aca0
	m_GfxDataSimple gfx_boomerang			; $06ada0
	m_GfxDataSimple gfx_swords			; $06ade0
	m_GfxDataSimple gfx_rod_of_seasons		; $06af60

.ifdef ROM_AGES
	m_GfxDataSimple gfx_cane_of_somaria		; $06b000
	m_GfxDataSimple gfx_switch_hook			; $06b0a0
	m_GfxDataSimple gfx_seed_shooter		; $06b160

	m_GfxDataSimple gfx_animations_1		; $06b200

.else ; ROM_SEASONS

	m_GfxDataSimple gfx_slingshot
	m_GfxDataSimple gfx_magnet_gloves
.endif
