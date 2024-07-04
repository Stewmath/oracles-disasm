; The only reason this gets its own file is because it moves around between Ages and Seasons.

m_section_free LoadTreasureData NAMESPACE treasureData

;;
; @param	d	Interaction index (should be of type INTERAC_TREASURE)
interactionLoadTreasureData:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.var30
	ld (de),a
	ld hl,treasureObjectData
--
	call multiplyABy4
	add hl,bc
	bit 7,(hl)
	jr z,+

	inc hl
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,Interaction.var03
	ld a,(de)
	jr --
+
	; var31 = spawn mode
	ldi a,(hl)
	ld b,a
	swap a
	and $07
	ld e,Interaction.var31
	ld (de),a

	; var32 = collect mode
	ld a,b
	and $07
	inc e
	ld (de),a

	; var33 = set "ROOMFLAG_ITEM" flag if nonzero
	ld a,b
	and $08
	inc e
	ld (de),a

	; var34 = parameter (value of 'c' for "giveTreasure")
	ldi a,(hl)
	inc e
	ld (de),a

	; var35 = low text ID
	ldi a,(hl)
	inc e
	ld (de),a

	; subid = graphics to use
	ldi a,(hl)
	ld e,Interaction.subid
	ld (de),a
	ret

.ends
