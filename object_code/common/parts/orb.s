; ==================================================================================================
; PART_ORB
;
; Variables:
;   var03: Bitset to use with wToggleBlocksState (derived from subid)
; ==================================================================================================
partCode03:
	cp PARTSTATUS_JUST_HIT
	jr nz,@notJustHit

	; Just hit
	ld a,(wToggleBlocksState)
	ld h,d
	ld l,Part.var03
	xor (hl)
	ld (wToggleBlocksState),a
	ld l,Part.oamFlagsBackup
	ld a,(hl)
	and $01
	inc a
	ldi (hl),a
	ld (hl),a
	ld a,SND_SWITCH
	jp playSound

@notJustHit:
	ld e,Part.state
	ld a,(de)
	or a
	ret nz

@state0:
	inc a
	ld (de),a
	call objectMakeTileSolid
	ld h,Part.zh
	ld (hl),$0a

	ld h,d
	ld l,Part.subid
	ldi a,(hl)
	and $07
	ld bc,bitTable
	add c
	ld c,a
	ld a,(bc)
	ld (hl),a ; [var03]

	ld a,(wToggleBlocksState)
	and (hl)
	ld a,$01
	jr z,+
	inc a
+
	ld l,Part.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	jp objectSetVisible82
