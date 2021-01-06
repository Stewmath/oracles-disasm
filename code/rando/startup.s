; Called upon starting / resetting the game (from the "init" function).
randoOnStartup:
	ld a,$0a
	ld ($1111),a ; Unlock SRAM

	; Check if SRAM was initialized already or not
	ld de,@romMagicString
	ld hl,sramMagicString
	ld b,4
	call @copyAndCheckEqual
	jr z,@initialized

	xor a
	ld (sramRandoVars),a

@initialized:
	ld a,(sramRandoVars)
	ldh (<hRandoVars),a
	ld b,a
	xor a
	ld ($1111),a ; Lock SRAM
	ld a,b
	and $04
	ret z
	xor a
	jp setMusicVolume


; Copies b bytes from de to hl, setting z iff the dest was already equal to the source.
@copyAndCheckEqual:
	ld c,$00
@loop:
	ld a,(de)
	inc de
	cp (hl)
	jr z,@equal
	ld c,$01
@equal:
	ldi (hl),a
	dec b
	jr nz,@loop
	ld a,c
	or a
	ret


; Magic string must be matched in SRAM or else it's considered uninitialized
@romMagicString:
	.db "RDMZ"
