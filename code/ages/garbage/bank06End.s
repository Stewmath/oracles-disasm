.ifdef BUILD_VANILLA

; Garbage data/code

	m_BreakableTileData %00000000 %00010000 %0000 $0 $df $37 ; $2f
	m_BreakableTileData %00110000 %00000000 %0000 $0 $06 $01 ; $30
	m_BreakableTileData %00100101 %00000001 %0000 $0 $06 $01 ; $31
	m_BreakableTileData %00111110 %10000000 %1011 $0 $1f $00 ; $32


_fake_specialObjectLoadAnimationFrameToBuffer:
	ld hl,w1Companion.visible		; $7a07
	bit 7,(hl)		; $7a0a
	ret z			; $7a0c

	ld l,<w1Companion.var32		; $7a0d
	ld a,(hl)		; $7a0f
	call $4524		; $7a10
	ret z			; $7a13

	ld a,l			; $7a14
	and $f0			; $7a15
	ld l,a			; $7a17
	ld de,w6SpecialObjectGfxBuffer|(:w6SpecialObjectGfxBuffer)		; $7a18
	jp $3f17		; $7a1b


	ld a,(hl)		; $7a1e
	ret z			; $7a1f

	ld l,<w1Companion.var32		; $7a20
	ld a,(hl)		; $7a22
	call $4524		; $7a23
	ret z			; $7a26

	ld a,l			; $7a27
	and $f0			; $7a28
	ld l,a			; $7a2a
	ld de,w6SpecialObjectGfxBuffer|(:w6SpecialObjectGfxBuffer)		; $7a2b
	jp $3f31		; $7a2e

.endif