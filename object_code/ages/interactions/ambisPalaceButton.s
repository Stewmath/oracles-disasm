; ==================================================================================================
; INTERAC_AMBIS_PALACE_BUTTON
; ==================================================================================================
interactionCodebe:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete
	ld a,$02
	call objectSetCollideRadius
	jp interactionIncState

@state1:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	call objectGetTileAtPosition
	ld a,(wActiveTilePos)
	cp l
	ret nz
	ld a,(wLinkInAir)
	or a
	ret nz
	call checkLinkVulnerable
	ret nc

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld e,Interaction.counter1
	ld a,45
	ld (de),a
	call objectGetTileAtPosition
	ld c,l
	ld a,$9e
	call setTile
	ld a,SND_OPENCHEST
	call playSound
	jp interactionIncState

@state2:
	call interactionDecCounter1
	ret nz
	ld a,CUTSCENE_AMBI_PASSAGE_OPEN
	ld (wCutsceneTrigger),a
	ld a,(wActiveRoom)
	ld (wTmpcbbb),a
	ld a,(wActiveTilePos)
	ld (wTmpcbbc),a
	ld e,Interaction.subid
	ld a,(de)
	ld (wTmpcbbd),a
	call fadeoutToWhite
	jp interactionDelete
