.ifdef BUILD_VANILLA

; Garbage functions appear to follow (corrupted repeats of the above functions).

;;
func_7ca7:
	jr -$30
	call $2118
	jp $2422

;;
func_7caf:
	ld c,$20
	call $1f83
	ret nz

	ld a,$77
	call $0cb1
	ld e,$46
	ld a,$5a
	ld (de),a
	ld a,$5b
	call $0cb1
	jp $2422

;;
func_7cc7:
	call $2409
	ret nz
	call $33a2
	jp $2422

;;
func_7cd1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$29
	call $324b
	ld a,$4c
	call $1761
	call $7cf8
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld hl,$cfc0
	set 0,(hl)
	ld a,(wActiveMusic)
	call $0cb1
	jp $7bf2

;;
func_7cf8:
	ld hl,$c702
	call $7d00
	ld l,$12
	set 0,(hl)
	inc l
	set 0,(hl)
	inc l
	set 0,(hl)
	inc l
	ret

.endif