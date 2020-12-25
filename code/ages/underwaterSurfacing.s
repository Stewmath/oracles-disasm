;;
; Sets carry (bit 0 of c) if link is allowed to surface
checkLinkCanSurface_isUnderwater:
	ld a,(wActiveGroup)
	ld hl, underWaterSurfaceTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wActiveRoom)
	ld b,a
-
	ldi a,(hl)
	or a
	jr z,+++
	cp b
	jr z,+
	inc hl
	inc hl
	jr -
+
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wTilesetFlags)
	and $01
	jr z, +
	ld b,(hl)
	ld a,b
	and $03
	jr z, ++
	push hl
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	pop hl
	jr z, ++
	bit 0,b
	jr nz, +++
	ld a,$08
	rst_addDoubleIndex
	jr ++
+
	ld a,(wDungeonIndex)
	cp $07
	jr nz, ++
	ld a,(wJabuWaterLevel)
	and $03
	cp $02
	jr nz, ++
	ld a,(wActiveRoom)
	cp $4c
	jr z, +
	cp $4d
	jr nz, ++
+
	ld a,$0b
	rst_addDoubleIndex
++
	ld a,(wActiveTilePos)
	ld b,a
	swap a
	and $0f
	rst_addDoubleIndex
	ld a,b
	and $0f
	xor $0f
	call checkFlag
	jr nz,++++
	scf
	jr ++++
+++
	ld a,(wTilesetFlags)
	and $01
	jr z, ++++
	scf
++++
	rl c
	ret
