; ==================================================================================================
; PART_TRIFORCE_STONE
; Stone blocking path to Nayru at the start of the game (only after being moved)
; ==================================================================================================
partCode5a:
	ld e,Part.state
	ld a,(de)
	or a
	ret nz

	inc a
	ld (de),a

	call getThisRoomFlags
	and $c0
	jp z,partDelete

	and $40
	ld a,$28
	jr nz,+
	ld a,$48
+
	ld e,Part.xh
	ld (de),a
	call objectMakeTileSolid
	ld h,>wRoomLayout
	ld (hl),$00
	ld a,PALH_98
	call loadPaletteHeader
	jp objectSetVisible83
