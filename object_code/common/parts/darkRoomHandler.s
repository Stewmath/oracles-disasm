; ==================================================================================================
; PART_DARK_ROOM_HANDLER
;
; Variables:
;   counter1: Number of lightable torches in the room
;   counter2: Number of torches currently lit (last time it checked)
; ==================================================================================================
partCode08:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wScrollMode)
	and $01
	ret z

	ld e,Part.state
	ld a,(de)
	or a
	call z,@state0

@state1:
	ld h,d
	ld l,Part.counter2
	ld b,(hl)
	ld a,(wNumTorchesLit)
	cp (hl)
	ret z

	; No torches lit?
	ldd (hl),a ; [counter2]
	or a
	jp z,darkenRoom

	; All torches lit?
	cp (hl) ; [counter1]
	jp z,brightenRoom

	ld a,(wPaletteThread_parameter)
	cp $f7
	ret z

	; Check if # of lit torches increased or decreased
	ld a,(wNumTorchesLit)
	cp b
	jp nc,brightenRoomLightly
	jp darkenRoomLightly

;;
; @param	l	Position of an unlit torch
; @param[out]	c	Incremented
@spawnLightableTorch:
	push hl
	push bc
	ld c,l
	call getFreePartSlot
	jr nz,+++
	ld (hl),PART_LIGHTABLE_TORCH
	inc l
	ld e,l
	ld a,(de)
	ld (hl),a ; [child.subid] = [this.subid]

	; Set length of time the torch can remain lit
	ld e,Part.yh
	ld a,(de)
	and $f0
	ld l,a
	ld e,Part.xh
	ld a,(de)
	and $f0
	swap a
	or l
	ld l,Part.counter2
	ld (hl),a

	ld l,Part.yh
	call setShortPosition_paramC
+++
	pop bc
	pop hl
	inc c
	ret

@state0:
	inc a
	ld (de),a ; [state] = 1

	ld e,Part.counter1
	ld a,(de)
	ld c,a

	; Search for lightable torches
	ld hl,wRoomLayout
	ld b,LARGE_ROOM_HEIGHT << 4
--
	ld a,(hl)
	cp TILEINDEX_UNLIT_TORCH
	call z,@spawnLightableTorch
	inc l
	dec b
	jr nz,--

	ld e,Part.counter1
	ld a,c
	ld (de),a
	call objectGetShortPosition
	ld e,Part.yh
	ld (de),a
	ret
