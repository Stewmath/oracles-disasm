; ==================================================================================================
; PART_GROTTO_CRYSTAL
; ==================================================================================================
partCode24:
	jr z,@normalStatus
	ld a,(wSwitchState)
	ld h,d
	ld l,$c2
	xor (hl)
	ld (wSwitchState),a
	ld l,$e4
	res 7,(hl)
	ld a,$01
	call partSetAnimation
	; sarcophagus when it breaks
	ldbc, INTERAC_SARCOPHAGUS $80
	jp objectCreateInteraction
@normalStatus:
	ld e,$c4
	ld a,(de)
	or a
	ret nz
	inc a
	ld (de),a
	call getThisRoomFlags
	bit 6,(hl)
	jr z,+
	ld h,d
	ld l,$e4
	res 7,(hl)
	ld a,$01
	call partSetAnimation
+
	call objectMakeTileSolid
	ld h,$cf
	ld (hl),$0a
	jp objectSetVisible83
