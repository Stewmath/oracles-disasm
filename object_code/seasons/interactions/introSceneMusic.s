; ==================================================================================================
; INTERAC_INTRO_SCENE_MUSIC
; ==================================================================================================
interactionCode85:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	; room where Din dances
	ld a,<ROOM_SEASONS_098
	call getARoomFlags
	and $40
	jp nz,interactionDelete
	ld hl,$cfd7
	ld a,(hl)
	or a
	ret nz
	inc a
	ld (hl),a
	ld ($cc02),a
	ld a,MUS_CARNIVAL
	call playSound
@state1:
	ld a,($d00d)
	cp $70
	ld a,$01
	jr c,+
	inc a
+
	ld h,d
	ld l,$77
	cp (hl)
	ret z
	ld (hl),a
	jp setMusicVolume
