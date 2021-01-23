gfxDataBank1a:
	m_GfxDataSimple spr_link			; $068000
	m_GfxDataSimple spr_dungeon_sprites		; $06a2e0
	m_GfxDataSimple spr_subrosian			; $06a4e0
	m_GfxDataSimple spr_link_retro			; $06a6e0
	m_GfxDataSimple spr_octorok_leever_tektite_zora	; $06a7e0
	m_GfxDataSimple spr_moblin			; $06a9e0
	m_GfxDataSimple spr_ballandchain_likelike	; $06ab40
	m_GfxDataSimple spr_link_baby			; $06aca0
	m_GfxDataSimple spr_boomerang			; $06ada0
	m_GfxDataSimple spr_swords			; $06ade0
	m_GfxDataSimple spr_rod_of_seasons		; $06af60
	m_GfxDataSimple spr_hyperslingshot_inventory

.ifdef ROM_AGES
	m_GfxDataSimple spr_cane_of_somaria		; $06b000
	m_GfxDataSimple spr_switch_hook			; $06b0a0
	m_GfxDataSimple spr_seed_shooter		; $06b160

	m_GfxDataSimple gfx_animations_1		; $06b200

.else ; ROM_SEASONS

	m_GfxDataSimple spr_slingshot
	m_GfxDataSimple spr_magnet_gloves
	m_GfxDataSimple spr_cane_of_somaria
.endif
