; ==================================================================================================
; INTERAC_PLAY_NAYRU_MUSIC
; ==================================================================================================
interactionCode2f:
	ld a,GLOBALFLAG_INTRO_DONE
	call checkGlobalFlag
	jp nz,interactionDelete
	ld hl,wActiveMusic
	ld a,MUS_NAYRU
	cp (hl)
	jr z,+

	ld (hl),a
	call playSound
+
	ld a,$02
	call setMusicVolume
	jp interactionDelete
