; ==================================================================================================
; PART_BURIED_MOLDORM
; ==================================================================================================
partCode2b:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $9a
	ret nz
	ld hl,$cfc0
	set 0,(hl)
	jp partDelete
@normalStatus:
	ld e,$c4
	ld a,(de)
	or a
	ret nz
	inc a
	ld (de),a
	ld h,d
	ld l,$e7
	ld (hl),$12
	ld l,$ff
	set 5,(hl)
	ret
