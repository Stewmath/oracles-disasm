; ==================================================================================================
; INTERAC_ZELDA_APPROACH_TRIGGER
; ==================================================================================================
interactionCodeda:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete
	ld a,PALH_ac
	jp loadPaletteHeader

@state1:
	call checkLinkVulnerable
	ret nc
	ld a,(wScrollMode)
	and SCROLLMODE_08 | SCROLLMODE_04 | SCROLLMODE_02
	ret nz

	ld hl,w1Link.yh
	ld e,Interaction.yh
	ld a,(de)
	cp (hl)
	ret c

	ld l,<w1Link.xh
	ld e,Interaction.xh
	ld a,(de)
	sub (hl)
	jr nc,+
	cpl
	inc a
+
	cp $09
	ret nc

	; Link has approached, start the cutscene
	ld a,CUTSCENE_WARP_TO_TWINROVA_FIGHT
	ld (wCutsceneTrigger),a
	ld (wMenuDisabled),a

	; Make the flames invisible
	ldhl FIRST_DYNAMIC_INTERACTION_INDEX, Interaction.enabled
--
	ld l,Interaction.enabled
	ldi a,(hl)
	or a
	jr z,++
	ldi a,(hl)
	cp INTERAC_TWINROVA_FLAME
	jr nz,++
	ld l,Interaction.visible
	res 7,(hl)
++
	inc h
	ld a,h
	cp LAST_INTERACTION_INDEX+1
	jr c,--
	jp interactionDelete
