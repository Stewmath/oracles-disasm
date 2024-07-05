; ==================================================================================================
; INTERAC_USED_ROD_OF_SEASONS
; ==================================================================================================
interactionCode15:
	ld a,(wMenuDisabled)
	ld b,a
	ld a,(wLinkDeathTrigger)
	or b
	jr nz,+
	ld a,(wActiveGroup)
	or a
	jr nz,+
	ld hl,wObtainedSeasons
	ld a,(hl)
	add a
	jr z,+
	ld a,(wRoomStateModifier)
-
	inc a
	and $03
	ld b,a
	call checkFlag
	ld a,b
	jr z,-
	call setSeason
	ld a,SND_ENERGYTHING
	call playSound
	ld a,$02
	ld (wPaletteThread_updateRate),a
+
	jp interactionDelete
