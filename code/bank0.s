.ORGA $0000
; rst_jumpTable
	add a
	pop hl
	add l
	ld l,a
	jr nc,+
	inc h
+
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp hl

.ORGA $0010
; rst_addAToHl
	add l
	ld l,a
	ret nc
	inc h
	ret

.ORGA $0018
; rst_addDoubleIndex
	push bc
	ld c,a
	ld b,$00
	add hl,bc
	add hl,bc
	pop bc
	ret

.ORGA $0038
; Not used as rst $38
	nop
	nop
	nop
	pop hl
	pop de
	pop bc
	pop af
	reti

.ORGA $0040
; VBlank interrupt
	push af
	push bc
	push de
	push hl
	jp vblankInterrupt

.ORGA $0048
; LCD interrupt
	push af
	push hl
	jp lcdInterrupt

.ORGA $0050
; Timer interrupt
	ei
	push af
	push bc
	push de
	push hl
	jp timerInterrupt

.ORGA $0058
; Serial interrupt
	push af
	jp serialInterrupt

.ORGA $0060
; Joypad interrupt
	reti

; Put the nops here explicitly so the next section can't start until $0068

	nop
	nop
	nop
	nop
	nop
	nop
	nop


.ORGA $0068

.SECTION Bank_0_Early_Functions

;;
; @param a
; @param de
addAToDe:
	add e
	ld e,a
	ret nc
	inc d
	ret

;;
; @param a
; @param bc
addAToBc:
	add c
	ld c,a
	ret nc
	inc b
	ret

;;
; Adds a*2 to de.
; @param a
; @param de
addDoubleIndexToDe:
	push hl
	add a
	ld l,a
	ld a,$00
	adc a
	ld h,a
	add hl,de
	ld e,l
	ld d,h
	pop hl
	ret

;;
; Adds a*2 to bc.
; @param a
; @param bc
addDoubleIndexToBc:
	push hl
	add a
	ld l,a
	ld a,$00
	adc a
	ld h,a
	add hl,bc
	ld c,l
	ld b,h
	pop hl
	ret

;;
; Call a function in any bank, from any bank.
; @param e Bank of the function to call
; @param hl Address of the function to call
interBankCall:
	ld a,($ff97)
	push af
	ld a,e
	ld ($ff97),a
	ld ($2222),a
	call jpHl
	pop af
	ld ($ff97),a
	ld ($2222),a
	ret

;;
; Jump to hl.
; @param hl Address to jump to.
jpHl:
	jp hl


secretSymbols: ; TODO
.ifndef REGION_JP

; Symbol list for secrets:
;	BDFGHJLM♠♥♦♣#
;	NQRSTWY!●▲■+-
;	bdfghj m$*/:~
;	nqrstwy?%&<=>
;	23456789↑↓←→@
	.asc "BDFGHJLM"
	.db $13 $bd $12 $11 $23
	.asc "NQRSTWY!"
	.db $10 $7e $7f $2b $2d
	.asc "bdfghjm$*/:~"
	.asc "nqrstwy?%&<=>"
	.asc "23456789"
	.db $15 $16 $17 $18 $40

	.db $00 ; Null terminator
.endif

.ENDS


; ???
.ifdef REGION_JP
	.ORGA $e1
.else
	.ORGA $e7
.endif
	.db $ff


.ORGA $00f8

;;
; Table used to convert a bit number (0-7) to a bitmask ($00-$80).
;
; This needs to be aligned such that the high byte of the address stays constant. Best to just
; leave it under an .ORGA.
bitTable:
	.db $01 $02 $04 $08 $10 $20 $40 $80


.ORGA $0100
	; Entry point
	nop
	jp begin


; ROM title / manufacturer code
.ORGA $134

.ifdef ROM_SEASONS
	.asc "ZELDA DIN" 0 0

	.ifdef REGION_JP
		.ASC "AZ7J"
	.else
		.asc "AZ7E"
	.endif
.else ; ROM_AGES
	.asc "ZELDA NAYRU"

	.ifdef REGION_JP
		.ASC "AZ8J"
	.else
		.asc "AZ8E"
	.endif
.endif


.ORGA $150

.SECTION Bank_0

;;
; The game's entrypoint.
begin:
	nop
	di
	cp $11
	ld a,$00
	jr nz,+

	; Check GBA Mode
	inc a
	bit 0,b
	jr z,+
	ld a,$ff
+
	ldh (<hGameboyType),a
	ld a,$37
	ldh (<hRng1),a
	ld a,$0d
	ldh (<hRng2),a
resetGame:
	ld sp,wMainStackTop
	jpfrombank0 bank3.init


;;
; Get the number of set bits in a.
;
; @param	a	Value to check
; @param[out]	a,b	Number of set bits in 'a'
getNumSetBits:
	ld b,$00
-
	add a
	jr nc,+
	inc b
+
	or a
	jr nz,-
	ld a,b
	ret

;;
; Add a bcd-encoded number to a 16-bit memory address. If it would go above $9999, the
; result is $9999.
;
; @param[in]  bc	Number to add.
; @param[in]  hl	Address to add with and store result into.
; @param[out] cflag	Set if the value would have gone over $9999.
addDecimalToHlRef:
	ld a,(hl)
	add c
	daa
	ldi (hl),a
	ld a,(hl)
	adc b
	daa
	ldd (hl),a
	ret nc
	ld a,$63
	ldi (hl),a
	ldd (hl),a
	ret

;;
; Subtract a bcd-encoded number from a 16-bit memory address. If it would go below 0, the
; result is 0.
;
; @param	bc	Value to subtract.
; @param	hl	Address to subtract with and store result into.
; @param[out]	cflag	Set if the value would have gone under $0000.
subDecimalFromHlRef:
	ld a,(hl)
	sub c
	daa
	ldi (hl),a
	ld a,(hl)
	sbc b
	daa
	ldd (hl),a
	ret nc
	xor a
	ldi (hl),a
	ldd (hl),a
	scf
	ret

;;
; @param	a	Operand 1
; @param	c	Operand 2
; @param[out]	hl	Result
; @trashes{b,e}
multiplyAByC:
	ld e,$08
	ld b,$00
	ld l,b
	ld h,b
-
	add hl,hl
	add a
	jr nc,+
	add hl,bc
+
	dec e
	jr nz,-
	ret

;;
; Multiply 'a' by $10, store result in bc.
;
; @param	a	Value to multiply
; @param[out]	bc	Result
multiplyABy16:
	swap a
	ld b,a
	and $f0
	ld c,a
	ld a,b
	and $0f
	ld b,a
	ret

;;
; Multiply 'a' by 8, store result in bc.
;
; @param	a	Value to multiply
; @param[out]	bc	Result
multiplyABy8:
	swap a
	rrca
	ld b,a
	and $f8
	ld c,a
	ld a,b
	and $07
	ld b,a
	ret

;;
; Multiply 'a' by 4, store result in bc.
;
; @param	a	Value to multiply
; @param[out]	bc	Result
multiplyABy4:
	ld b,$00
	add a
	rl b
	add a
	rl b
	ld c,a
	ret

;;
; Convert a signed 8-bit value in 'a' to signed 16-bit value in 'bc'
;
; @param	a	Signed value
; @param[out]	bc	Signed 16-bit value
s8ToS16:
	ld b,$ff
	bit 7,a
	jr nz,+
	inc b
+
	ld c,a
	ret

;;
; @param[out]	a	$ff if hl < bc, $01 if hl > bc, $00 if equal
; @param[out]	cflag	c if hl < bc, nc otherwise
compareHlToBc:
	ld a,h
	cp b
	jr c,+
	jr nz,++
	ld a,l
	cp c
	jr c,+
	jr nz,++
	xor a
	ret
+
	ld a,$ff
	ret
++
	ld a,$01
	ret

;;
; This returns the highest set bit in 'a', which in effect is like log base 2.
;
; @param[out]	a	Bit value (0-7) or unchanged if no bits are set
; @param[out]	cflag	c if at least one bit was set (output is valid)
getHighestSetBit:
	or a
	ret z
	push bc
	ld c,$ff
-
	inc c
	srl a
	jr nz,-
	ld a,c
	pop bc
	scf
	ret

;;
; @param[out]	a	Bit value (0-7) or unchanged if no bits are set
; @param[out]	cflag	c if at least one bit was set (output is valid)
getLowestSetBit:
	or a
	ret z
	push bc
	ld c,$08
-
	dec c
	add a
	jr nz,-
	ld a,c
	pop bc
	scf
	ret

;;
; A "flag" is just a bit in memory. These flag-related functions take a base address
; ('hl'), and check a bit in memory starting at that address ('a').
;
; @param	a	Flag to check
; @param	hl	Start address of flags
; @param[out]	a	AND result
; @param[out]	zflag	Set if the flag is not set.
checkFlag:
	push hl
	push bc
	call _flagHlpr
	and (hl)
	pop bc
	pop hl
	ret

;;
; @param	a	Flag to set
; @param	hl	Start address of flags
setFlag:
	push hl
	push bc
	call _flagHlpr
	or (hl)
	ld (hl),a
	pop bc
	pop hl
	ret

;;
; @param	a	Flag to unset
; @param	hl	Start address of flags
unsetFlag:
	push hl
	push bc
	call _flagHlpr
	cpl
	and (hl)
	ld (hl),a
	pop bc
	pop hl
	ret

;;
; Add (a/8) to hl, set 'a' to a bitmask for the desired bit (a%8)
_flagHlpr:
	ld b,a
	and $f8
	rlca
	swap a
	ld c,a
	ld a,b
	ld b,$00
	add hl,bc
	and $07
	ld bc,bitTable
	add c
	ld c,a
	ld a,(bc)
	ret

;;
decHlRef16WithCap:
	inc hl
	ldd a,(hl)
	or (hl)
	ret z
	ld a,(hl)
	sub $01
	ldi (hl),a
	ld a,(hl)
	sbc $00
	ldd (hl),a
	or (hl)
	ret

;;
incHlRefWithCap:
	inc (hl)
	ret nz
	ld (hl),$ff
	ret

;;
incHlRef16WithCap:
	inc (hl)
	ret nz
	inc hl
	inc (hl)
	jr z,+
	dec hl
	ret
+
	push af
	ld a,$ff
	ldd (hl),a
	ld (hl),a
	pop af
	ret

;;
; Convert hex value in a to a bcd-encoded decimal value in bc
;
; @param	a	Hexadecimal number
; @param[out]	bc	bcd-encoded decimal number
hexToDec:
	ld bc,$0000
-
	cp 100
	jr c,@doneHundreds
	sub 100
	inc b
	jr -

@doneHundreds:
	cp 10
	ret c
	sub 10
	inc c
	jr @doneHundreds

;;
; Update wKeysPressed, wKeysJustPressed, and wKeysPressedLastFrame.
;
; @trashes{bc,hl}
pollInput:
	ld c,R_P1
	ld a,$20
	ld ($ff00+c),a
	ld a,($ff00+c)
	ld a,($ff00+c)
	ld a,($ff00+c)
	ld b,a
	ld a,$10
	ld ($ff00+c),a
	ld a,b
	and $0f
	swap a
	ld b,a
	ld hl,wKeysPressed
	ldd a,(hl)
	ldi (hl),a
	cpl
	ld (hl),a
	ld a,($ff00+c)
	ld a,($ff00+c)
	and $0f
	or b
	cpl
	ld b,(hl)
	ldi (hl),a
	and b
	ld (hl),a
	ld a,$30
	ld ($ff00+c),a
	ret

;;
getInputWithAutofire:
	push hl
	push bc
	ld a,(wKeysPressed)
	and $f0
	ld b,a
	ld hl,wAutoFireKeysPressed
	ld a,(hl)
	and b
	ld a,b
	ldi (hl),a
	jr z,+
	inc (hl)
	ld a,(hl)
	cp $28
	jr c,++
	and $1f
	or $80
	ld (hl),a
	and $03
	jr nz,++
	ld a,(wKeysPressed)
	jr +++
+
	xor a
	ld (hl),a
++
	ld a,(wKeysJustPressed)
+++
	pop bc
	pop hl
	ret

;;
disableLcd:
	ld a,($ff00+R_LCDC)
	rlca
	ret nc
	push bc
	ld a,($ff00+R_IE)
	ld b,a
	and INT_VBLANK ~ $FF
	ld ($ff00+R_IE),a
-
	ld a,($ff00+R_LY)
	cp $91
	jr c,-
	ld a,$03
	ldh (<hNextLcdInterruptBehaviour),a
	xor a
	ld (wGfxRegsFinal.LCDC),a
	ld (wGfxRegs2.LCDC),a
	ld (wGfxRegs1.LCDC),a
	ld ($ff00+R_LCDC),a
	ld ($ff00+R_IF),a
	ld a,b
	ld ($ff00+R_IE),a
	pop bc
	ret

;;
; @param	a	Gfx register state index to load
loadGfxRegisterStateIndex:
	; a *= $06
	ld l,a
	add a
	add l
	add a

	ld hl,gfxRegisterStates
	rst_addDoubleIndex
	ld b,GfxRegsStruct.size*2
	ld de,wGfxRegs1
-
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,-
	ld a,(wGfxRegs1.LCDC)
	ld (wGfxRegsFinal.LCDC),a
	ld ($ff00+R_LCDC),a
	ret

gfxRegisterStates:
	.db $c3 $00 $00 $c7 $c7 $c7 ; 0x00: DMG mode screen, capcom intro, ...
	.db $c3 $00 $00 $c7 $c7 $c7

	.db $c7 $00 $00 $c7 $c7 $c7 ; 0x01
	.db $00 $00 $00 $c7 $c7 $c7

	.db $ef $f0 $00 $8f $8f $0f ; 0x02: Post-d3 cutscene, twinrova/ganon fight, CUTSCENE_BLACK_TOWER_ESCAPE
	.db $e7 $00 $00 $c7 $c7 $c7

	.db $ef $f0 $00 $10 $c7 $0f ; 0x03
	.db $f7 $f0 $00 $10 $c7 $75

	.db $c7 $00 $00 $c7 $c7 $c7 ; 0x04: titlescreen
	.db $00 $00 $00 $c7 $c7 $c7

	.db $cf $00 $00 $c7 $c7 $c7 ; 0x05
	.db $00 $00 $00 $c7 $c7 $c7

	.db $a7 $00 $b0 $c7 $c7 $1f ; 0x06
	.db $8f $00 $00 $c7 $c7 $c7

	.db $c7 $00 $00 $c7 $c7 $c7 ; 0x07: map screens (both overworld and dungeon)?
	.db $00 $00 $00 $c7 $c7 $c7

	.db $a7 $00 $00 $90 $07 $00 ; 0x08
	.db $a7 $40 $00 $90 $07 $c7

	.db $c7 $70 $00 $c7 $c7 $c7 ; 0x09: temple in intro
	.db $c7 $00 $00 $c7 $c7 $c7

	.db $cf $70 $00 $c7 $c7 $c7 ; 0x0a: scrolling up the tree in the intro
	.db $cf $00 $00 $c7 $c7 $c7

	.db $cf $00 $20 $c7 $c7 $c7 ; 0x0b
	.db $cf $00 $00 $c7 $c7 $c7

	.db $a7 $00 $00 $78 $07 $27 ; 0x0c
	.db $af $f0 $00 $78 $07 $c7

	.db $c7 $10 $30 $c7 $c7 $c7 ; 0x0d
	.db $c7 $00 $00 $c7 $c7 $c7

	.db $e7 $01 $00 $4c $4c $c7 ; 0x0e
	.db $c7 $00 $00 $c7 $c7 $c7

	.db $af $f0 $00 $10 $07 $17 ; 0x0f: ring appraisal menu
	.db $f7 $f0 $00 $10 $c7 $57

	.db $b7 $f0 $00 $10 $07 $1f ; 0x10: ring list menu
	.db $f7 $f0 $00 $10 $c7 $47

	.db $ef $f0 $00 $8f $8f $0f ; 0x11
	.db $e7 $00 $00 $40 $57 $c7

	.db $ef $f0 $00 $8f $8f $0f ; 0x12
	.db $e7 $00 $00 $90 $47 $c7

	.db $e7 $00 $28 $c7 $c7 $c7 ; 0x13
	.db $e7 $00 $28 $c7 $c7 $c7

	.db $ef $f0 $00 $8f $8f $00 ; 0x14
	.db $e7 $00 $00 $c7 $c7 $c7

	.db $e7 $00 $00 $c7 $c7 $c7 ; 0x15
	.db $e7 $00 $00 $c7 $c7 $c7

	.db $ff $30 $00 $60 $07 $18 ; 0x16: farore's secret list
	.db $ff $30 $00 $60 $07 $c7

.ifdef ROM_AGES
	.db $ef $00 $00 $90 $07 $00 ; 0x17: intro cinematic screen 1
	.db $e7 $00 $00 $90 $07 $c7

	.db $ef $98 $00 $68 $07 $40 ; 0x18
	.db $ef $98 $00 $68 $07 $c7

	.db $ef $00 $00 $90 $07 $30 ; 0x19
	.db $e7 $98 $00 $60 $07 $c7
.endif


;;
; @param[out]	a	Random number
getRandomNumber:
	push hl
	push bc
	ldh a,(<hRng1)
	ld l,a
	ld c,a
	ldh a,(<hRng2)
	ld h,a
	ld b,a
	add hl,hl
	add hl,bc
	ld a,h
	ldh (<hRng2),a
	add c
	ldh (<hRng1),a
	pop bc
	pop hl
	ret

;;
; Same as above, except it doesn't preserve bc and hl. It's a little faster I guess?
;
; @param[out]	a,c	Random number
; @param[out]	hl	Intermediate calculation (sometimes also used as random values?)
getRandomNumber_noPreserveVars:
	ldh a,(<hRng1)
	ld l,a
	ld c,a
	ldh a,(<hRng2)
	ld h,a
	ld b,a
	add hl,hl
	add hl,bc
	ld a,h
	ldh (<hRng2),a
	add c
	ldh (<hRng1),a
	ret

;;
; Reads a probability distribution from hl, and returns (in 'b') an index from the
; distribution.
;
; The sum of all values in the distribution should equal $100. Higher values have a higher
; weighting for the corresponding index, meaning it's more likely that those values will
; be picked.
;
; @param	hl	Probability distribution
; @param[out]	b	The index chosen from the distribution
getRandomIndexFromProbabilityDistribution:
	ld b,$00
	call getRandomNumber
-
	sub (hl)
	ret c
	inc hl
	inc b
	jr -

;;
; @param	b	# of bytes to clear
; @param	hl	Memory to clear
clearMemory:
	xor a

;;
; @param	a	Value to fill memory with
; @param	b	# of bytes to fill
; @param	hl	Memory to fill
fillMemory:
	ldi (hl),a
	dec b
	jr nz,fillMemory
	ret

;;
; @param	bc	# of bytes to clear
; @param	hl	Memory to clear
clearMemoryBc:
	xor a

;;
; @param	a	Value to fill memory with
; @param	bc	# of bytes to fill
; @param	hl	Memory to fill
fillMemoryBc:
	ld e,a
-
	ld a,e
	ldi (hl),a
	dec bc
	ld a,c
	or b
	jr nz,-
	ret

;;
; @param	b	# of bytes to copy
; @param	de	Source
; @param	hl	Destination
copyMemoryReverse:
	ld a,(de)
	ldi (hl),a
	inc de
	dec b
	jr nz,copyMemoryReverse
	ret

;;
; @param	b	# of bytes to copy
; @param	de	Destination
; @param	hl	Source
copyMemory:
	ldi a,(hl)
	ld (de),a
	inc de
	dec b
	jr nz,copyMemory
	ret

;;
; @param	bc	# of bytes to copy
; @param	de	Source
; @param	hl	Destination
copyMemoryBcReverse:
	ld a,(de)
	ldi (hl),a
	inc de
	dec bc
	ld a,b
	or c
	jr nz,copyMemoryBcReverse
	ret

;;
; @param	bc	# of bytes to copy
; @param	de	Destination
; @param	hl	Source
copyMemoryBc:
	ldi a,(hl)
	ld (de),a
	inc de
	dec bc
	ld a,b
	or c
	jr nz,copyMemoryBc
	ret

;;
clearOam:
	xor a
	ldh (<hOamTail),a
	ld h, wOam>>8
	ld b,$e0
-
	ld l,a
	ld (hl),b
	add $04
	cp <wOamEnd
	jr c,-
	ret

;;
clearVram:
	call disableLcd
	call clearOam
	ld a,$01
	ld ($ff00+R_VBK),a
	ld hl,$8000
	ld bc,$2000
	call clearMemoryBc
	xor a
	ld ($ff00+R_VBK),a
	ld hl,$8000
	ld bc,$2000
	jr clearMemoryBc

;;
initializeVramMaps:
	call initializeVramMap1
;;
initializeVramMap0:
	call disableLcd
	ld a,$01
	ld ($ff00+R_VBK),a
	ld hl,$9800
	ld bc,$0400
	ld a,$80
	call fillMemoryBc
	xor a
	ld ($ff00+R_VBK),a
	ld hl,$9800
	ld bc,$0400
	jr clearMemoryBc

;;
initializeVramMap1:
	call disableLcd
	ld a,$01
	ld ($ff00+R_VBK),a
	ld hl,$9c00
	ld bc,$0400
	ld a,$80
	call fillMemoryBc
	xor a
	ld ($ff00+R_VBK),a
	ld hl,$9c00
	ld bc,$0400
	jp clearMemoryBc

;;
; @param	a	Palette header to load (see data/[ages|seasons]/paletteHeaders.s)
loadPaletteHeader:
	push de
	ld l,a
	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld a,:bank1Moveable.paletteHeaderTable
	setrombank
	ld a,l
	ld hl,bank1Moveable.paletteHeaderTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
---
	ld a,:bank1Moveable.paletteHeaderTable
	setrombank

	; b: how many palettes to load
	ld a,(hl)
	and $07
	inc a
	ld b,a

	; c: which palette to start on
	ld a,(hl)
	rlca
	swap a
	and $07
	ld de,bitTable
	add e
	ld e,a
	ld a,(de)
	ld c,a

	; Turn b into a bitmask for which palettes to load
	xor a
-
	or c
	dec b
	jr z,+
	rlca
	jr -
+
	ld b,a

	; Mark palettes as dirty
	ld c,<hDirtyBgPalettes
	bit 6,(hl)
	jr z,+
	ld c,<hDirtySprPalettes
+
	ld a,($ff00+c)
	or b
	ld ($ff00+c),a

	; de = destination
	ld a,(hl)
	and $78
	add w2TilesetBgPalettes&$ff
	ld e,a
	ld d, w2TilesetBgPalettes>>8

	; b = number of palettes
	ld a,(hl)
	and $07
	inc a
	ld b,a

	; Set carry if there's another palette header to process
	ldi a,(hl)
	rlca

	; Load pointer to actual palette data into hl
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	push hl
	ld l,c
	ld h,a

	; Set bank, begin copying
	ld a,:paletteDataStart
	setrombank
--
	ld c,$08
-
	ldi a,(hl)
	ld (de),a
	inc e
	dec c
	jr nz,-
	dec b
	jr nz,--
	pop hl
	jr c,---

	pop bc
	ld a,b
	setrombank
	ld a,c
	ld ($ff00+R_SVBK),a
	pop de
	ret

;;
; Do a DMA transfer next vblank. Note:
;  - Only banks $00-$3f work properly
;  - Destination address must be a multiple of 16
;
; @param	b	(data size)/16 - 1
; @param	c	src bank
; @param	de	(dest address) | (vram or wram bank)
; @param	hl	src address
; @param[out]	cflag	Set if the lcd is on (data can't be copied immediately)
; @trashes{hl}
queueDmaTransfer:
	ld a,($ff00+R_LCDC)
	rlca
	jr nc,++

	push de
	push hl
	ld h,wVBlankFunctionQueue>>8
	ldh a,(<hVBlankFunctionQueueTail)
	ld l,a
	ld a,(vblankDmaFunctionOffset)
	ldi (hl),a
	ld a,c
	ldi (hl),a
	pop de
	ld a,d
	ldi (hl),a
	ld a,e
	ldi (hl),a
	pop de
	ld a,e
	ldi (hl),a
	ld a,d
	ldi (hl),a
	ld a,e
	ldi (hl),a
	ld a,b
	ldi (hl),a
	ld a,l
	ldh (<hVBlankFunctionQueueTail),a
	scf
	ret
++
; If LCD is off, copy data immediately?
	ldh a,(<hRomBank)
	push af
	ld a,($ff00+R_SVBK)
	push af
	push de
	push hl
	ld a,c
	ld ($ff00+R_SVBK),a
	setrombank
	pop de
	ld hl, HDMA1
	ld (hl),d
	inc l
	ld (hl),e
	inc l
	pop de
	ld a,e
	ld ($ff00+R_VBK),a
	ld (hl),d
	inc l
	ldi (hl),a
	ld (hl),b
	pop af
	ld ($ff00+R_SVBK),a
	pop af
	setrombank
	xor a
	ret

;;
; @param	a	Uncompressed gfx header index to load
; @trashes{bc,de,hl}
loadUncompressedGfxHeader:
	ld e,a
	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc
	ld a,:bank1Moveable.uncmpGfxHeaderTable
	setrombank
	ld a,e
	ld hl,bank1Moveable.uncmpGfxHeaderTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
--
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld e,a
	push de
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld e,a
	ld a,(hl)
	and $7f
	ld b,a
	ld a,l
	ldh (<hFF90),a
	ld a,h
	ldh (<hFF91),a
	pop hl
	call queueDmaTransfer
	ld a,:bank1Moveable.uncmpGfxHeaderTable
	setrombank
	ldh a,(<hFF90)
	ld l,a
	ldh a,(<hFF91)
	ld h,a
	ldi a,(hl)
	add a
	jr c,--

	pop bc
	ld a,b
	setrombank
	ld a,c
	ld ($ff00+R_SVBK),a
	ret

;;
; @param	a	The index of the gfx header to load
loadGfxHeader:
	ld e,a
	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc
	ld a,:bank1Moveable.gfxHeaderTable
	setrombank
	ld a,e
	ld hl,bank1Moveable.gfxHeaderTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
--
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld e,a
	push de
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld e,a
	ld a,(hl)
	and $7f
	ld b,a
	ld a,l
	ldh (<hFF90),a
	ld a,h
	ldh (<hFF91),a
	pop hl
	call decompressGraphics
	ld a,:bank1Moveable.gfxHeaderTable
	setrombank
	ldh a,(<hFF90)
	ld l,a
	ldh a,(<hFF91)
	ld h,a
	ldi a,(hl)
	add a
	jr c,--

	pop bc
	ld a,b
	setrombank
	ld a,c
	ld ($ff00+R_SVBK),a
	ret

;;
; Deals with graphics compression
;
; @param	b	Data size (divided by 16, minus 1)
; @param	c	ROM bank (bits 0-5) and compression mode (bits 6-7)
; @param	de	Destination (lower 4 bits = destination bank, either vram or wram)
; @param	hl	Source
decompressGraphics:
	ld a,e
	and $0f
	ld ($ff00+R_VBK),a
	ld ($ff00+R_SVBK),a
	xor e
	ld e,a
	ld a,c
	and $3f
	setrombank
	inc b
	ld a,c
	and $c0
	jp z,func_06e0
	cp $c0
	jr z,_label_00_059
	cp $40
	jr z,_label_00_060
	ld a,b
-
	push af
	call func_069c
	pop af
	dec a
	jr nz,-
	ret

;;
func_069c:
	call readByteSequential
	ld c,a
	call readByteSequential
	ldh (<hFF8A),a
	or c
	jr nz,_label_00_050
	ld b,$10
_label_00_049:
	call readByteSequential
	ld (de),a
	inc de
	dec b
	jr nz,_label_00_049
	ret
_label_00_050:
	call readByteSequential
	ldh (<hFF8B),a
	ld b,$08
_label_00_051:
	rl c
	jr c,_label_00_052
	call readByteSequential
	jr _label_00_053
_label_00_052:
	ldh a,(<hFF8B)
_label_00_053:
	ld (de),a
	inc de
	dec b
	jr nz,_label_00_051
	ldh a,(<hFF8A)
	ld c,a
	ld b,$08
_label_00_054:
	rl c
	jr c,_label_00_055
	call readByteSequential
	jr _label_00_056
_label_00_055:
	ldh a,(<hFF8B)
_label_00_056:
	ld (de),a
	inc de
	dec b
	jr nz,_label_00_054
	ret

;;
func_06e0:
	ld c,$10
-
	call readByteSequential
	ld (de),a
	inc de
	dec c
	jr nz,-
	dec b
	jr nz,func_06e0
	ret

_label_00_059:
	ld a,$ff
	jr _label_00_061
_label_00_060:
	xor a
	ldh (<hFF93),a
_label_00_061:
	ldh (<hFF8E),a
	swap b
	ld a,b
	and $f0
	ld c,a
	xor b
	ld b,a
	ld a,$01
	ldh (<hFF8B),a
_label_00_062:
	ldh a,(<hFF8B)
	dec a
	ldh (<hFF8B),a
	jr nz,_label_00_063
	ld a,$08
	ldh (<hFF8B),a
	ldi a,(hl)
	ldh (<hFF8A),a
	call _adjustHLSequential
_label_00_063:
	ldh a,(<hFF8A)
	add a
	ldh (<hFF8A),a
	jr c,_label_00_064
	call copyByteSequential
	jr nz,_label_00_062
	ret
_label_00_064:
	ldh a,(<hFF8E)
	or a
	jr nz,_label_00_065
	ld a,(hl)
	and $1f
	ldh (<hFF92),a
	xor (hl)
	jr z,_label_00_066
	swap a
	rrca
	inc a
	jr _label_00_067
_label_00_065:
	ldi a,(hl)
	ldh (<hFF92),a
	call _adjustHLSequential
	ld a,(hl)
	and $07
	ldh (<hFF93),a
	xor (hl)
	jr z,_label_00_066
	rrca
	rrca
	rrca
	add $02
	jr _label_00_067
_label_00_066:
	inc hl
	call _adjustHLSequential
	ld a,(hl)
_label_00_067:
	ldh (<hFF8F),a
	inc hl
	call _adjustHLSequential
	push hl
	ldh a,(<hFF92)
	cpl
	ld l,a
	ldh a,(<hFF93)
	cpl
	ld h,a
	add hl,de
_label_00_068:
	ldi a,(hl)
	ld (de),a
	inc de
	dec bc
	ld a,b
	or c
	jr z,_label_00_069
	ldh a,(<hFF8F)
	dec a
	ldh (<hFF8F),a
	jr nz,_label_00_068
	pop hl
	jr _label_00_062
_label_00_069:
	pop hl
	ret


;;
; Copies a single byte, and checks whether to increment the bank.
;
; @param	bc	Amount of bytes to read (not enforced here)
; @param	de	Address to write data to
; @param	hl	Address to read data from
; @param[out]	zflag	Set if bc reaches 0.
copyByteSequential:
	ldi a,(hl)
	ld (de),a
	inc de
	dec bc

;;
; Adjusts the value of hl and the current loaded bank for various "sequental read"
; functions.
;
; @param	hl	Address
; @param[out]	zflag	Set if bc is 0.
_adjustHLSequential:
	ld a,h
	cp $80
	jr nz,+
	ld h,$40
	ldh a,(<hRomBank)
	inc a
	setrombank
+
	ld a,b
	or c
	ret

;;
; @param	hl	Address to read from
readByteSequential:
	ldi a,(hl)
	bit 7,h
	ret z
	push af
	ld h,$40
	ldh a,(<hRomBank)
	inc a
	setrombank
	pop af
	ret

;;
; @param	a	Tileset to load (tilesets include collision data and tile indices)
loadTileset:
	ld e,a
	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc

	ld a,:bank1Moveable.tilesetLayoutTable
	setrombank
	ld a,e
	ld hl,bank1Moveable.tilesetLayoutTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
--
	ldi a,(hl)
	push hl
	ld hl,bank1Moveable.tilesetLayoutDictionaryTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldi a,(hl)
	ldh (<hFF8F),a
	ldi a,(hl)
	ldh (<hFF91),a
	ldi a,(hl)
	ldh (<hFF90),a
	pop hl

	; Get source data bank
	ldi a,(hl)
	ldh (<hFF8E),a

	; Load data pointer to stack for later use
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld e,a
	push de

	; Load destination in de
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld e,a

	; Write data size into ff8c
	ldi a,(hl)
	and $7f
	ldh (<hFF8D),a
	ldd a,(hl)
	ldh (<hFF8C),a

	; Store header position into ff92
	ld a,h
	ldh (<hFF93),a
	ld a,l
	ldh (<hFF92),a

	; Data pointer in hl
	pop hl
	call loadTilesetHlpr

	ld a,:bank1Moveable.tilesetLayoutTable
	setrombank

	; Retrieve header position
	ldh a,(<hFF93)
	ld h,a
	ldh a,(<hFF92)
	ld l,a

	; Check if repeat bit is set
	ldi a,(hl)
	inc hl
	add a
	jr c,--

	pop bc
	ld a,b
	setrombank
	ld a,c
	ld ($ff00+R_SVBK),a
	ret

;;
; @param	hl	pointer to compressed data
; @param	[ff8e]	bank of compressed data
loadTilesetHlpr:

; Internal variables:
; ff8a: size of chunk to read from dictionary
; ff8b: "key" byte (sorry bad at explaining)

	ld a,e
	and $0f
	ld ($ff00+R_VBK),a
	ld ($ff00+R_SVBK),a
	xor e
	ld e,a
----
	ldh a,(<hFF8E)
	setrombank
	ldi a,(hl)
	ldh (<hFF8B),a
	ld b,$08
---
	ldh a,(<hFF8E)
	setrombank
	ldh a,(<hFF8B)
	rrca
	ldh (<hFF8B),a
	jr c,++

	ldi a,(hl)
	ld (de),a
	inc de
	call dec16_ff8c
	ret z
	dec b
	jr nz,---
	jr ----
++
	push bc
	ldh a,(<hFF8F)
	bit 7,a
	jr nz,+

	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ldh (<hFF8A),a
	and $0f
	ld b,a
	ldh a,(<hFF8A)
	swap a
	and $0f
	add $03
	ldh (<hFF8A),a
	jr ++
+
	ldi a,(hl)
	ldh (<hFF8A),a
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld b,a
++
	push hl
	ld hl,hFF90
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc
	ldh a,(<hFF8A)
	ld b,a
	ldh a,(<hFF8F)
	and $3f
	setrombank
-
	ldi a,(hl)
	ld (de),a
	inc de
	call dec16_ff8c
	jr z,+++
	dec b
	jr nz,-

	pop hl
	pop bc
	dec b
	jr nz,---
	jr ----
+++
	pop hl
	pop bc
	ret

;;
dec16_ff8c:
	push hl
	ld hl,hFF8C
	call decHlRef16WithCap
	pop hl
	ret

;;
enableIntroInputs:
	ldh a,(<hIntroInputsEnabled)
	bit 7,a
	ret nz
	ld a,$01
	ldh (<hIntroInputsEnabled),a
	ret

;;
threadFunc_088b:
	push hl
	ld l,a
	ld h,>wThreadStateBuffer
	set 7,(hl)
	pop hl
	ret

;;
threadFunc_0893:
	push hl
	ld l,a
	ld h,>wThreadStateBuffer
	res 7,(hl)
	pop hl
	ret

;;
; @param	a	Low byte of thread address
threadStop:
	push hl
	ld l,a
	ld h,>wThreadStateBuffer
	ld (hl),$00
	pop hl
	ret

;;
; @param	a	Low byte of thread address
; @param[in]	bc	Address where thread should restart
threadRestart:
	push hl
	push de
	push bc
	ld e,a
	add $04
	ld c,a
	ld d,$00
	ld hl,_initialThreadStates-(<wThreadStateBuffer)
	add hl,de
	ld d,>wThreadStateBuffer
	ld b,$08
-
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,-

	ld l,c
	ld h,d
	pop bc
	ld (hl),c
	inc l
	ld (hl),b
	pop de
	pop hl
	ret

;;
; @param[in]	bc	Address where thread should restart
restartThisThread:
	push bc
	ldh a,(<hActiveThread)
	ld e,a
	add $04
	ld c,a
	ld d,$00
	ld hl,_initialThreadStates-(<wThreadStateBuffer)
	add hl,de
	ld d,>wThreadStateBuffer
	ld b,$08
-
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,-

	ld l,c
	ld h,d
	pop bc
	ld (hl),c
	inc l
	ld (hl),b
	jr _nextThread

;;
stubThreadStart:
	ldh a,(<hActiveThread)
	ld l,a
	ld h,>wThreadStateBuffer
	ld (hl),$00
	jr _nextThread

;;
resumeThreadNextFrameAndSaveBank:
	ld a,$01
	push bc
	ld b,a
	ldh a,(<hRomBank)
	ld c,a
	ld a,b
	call resumeThreadInAFrames
	ld a,c
	setrombank
	pop bc
	ret

;;
resumeThreadNextFrame:
	ld a,$01

;;
; @param	a	Frames before the active thread will be executed next
resumeThreadInAFrames:
	push hl
	push de
	push bc
	ld b,a
	ldh a,(<hActiveThread)
	ld l,a
	ld h,>wThreadStateBuffer

	; Value $01 says to resume in X frames
	ld a,$01
	ldi (hl),a

	; Number of frames to wait
	ld (hl),b
	inc l

	; Save stack
	ld (hFF92),sp
	ldh a,(<hFF92)
	ldi (hl),a
	ldh a,(<hFF93)
	ld (hl),a
;;
_nextThread:
	ld sp,wMainStackTop
	ld h,>wThreadStateBuffer
	ld a,$01
	ld ($ff00+R_SVBK),a
	jr _mainLoop_nextThread

;;
; Called just after basic initialization
startGame:
	; Initialize thread states
	ld sp,wMainStackTop
	ld hl,_initialThreadStates
	ld de,wThreadStateBuffer
	ld b,NUM_THREADS*8
-
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,-

;;
_mainLoop:
	call pollInput
	ldh a,(<hIntroInputsEnabled)
	add a
	jr z,+

	ld a,(wKeysPressed)
	sub (BTN_A | BTN_B | BTN_START | BTN_SELECT)
	jp z,resetGame
+
	ld a,$10
	ldh (<hOamTail),a
	ld h,>wThreadStateBuffer
	ld a,<wThreadStateBuffer
	ldh (<hActiveThread),a

--
	ld l,a
	ld a,(hl)

	; (hl) == 1?
	dec a
	jr z,_countdownToRunThread

	; (hl) == 2?
	dec a
	jr z,_initializeThread

;;
_mainLoop_nextThread:
	ldh a,(<hActiveThread)
	add $08
	ldh (<hActiveThread),a
	cp <(wThreadStateBuffer+NUM_THREADS*8)
	jr nz,--

	; No threads remaining this frame

	callfrombank0 bank3f.refreshDirtyPalettes
	xor a
	ld ($ff00+R_SVBK),a
	ld hl,$c49e
	inc (hl)
	ld hl,wGfxRegs1
	ld de,wGfxRegsFinal
	ld b,GfxRegsStruct.size
-
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,-

	; Wait for vblank
	ld hl,wVBlankChecker
	ld (hl),$ff
-
	halt
	nop
	bit 7,(hl)
	jr nz,-
	jr _mainLoop

;;
_countdownToRunThread:
	inc l
	dec (hl)
	jr nz,_mainLoop_nextThread

	dec l
	ld a,$03
	ldi (hl),a
	inc l
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld sp,hl
	pop bc
	pop de
	pop hl
	ret

;;
_initializeThread:
	ld a,$03
	ldi (hl),a
	inc l
	; Put stack value in de
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld d,a
	; Put function address in bc
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	; hl <- de
	ld l,e
	ld h,d
	; Jump to bc with new stack
	ld sp,hl
	push bc
	ret

_initialThreadStates:
	m_ThreadState $02 $00 wThread0StackTop introThreadStart
	m_ThreadState $02 $00 wThread1StackTop stubThreadStart
	m_ThreadState $02 $00 wThread2StackTop stubThreadStart
	m_ThreadState $02 $00 wThread3StackTop paletteFadeThreadStart


; Upper bytes of addresses of flags for each group
flagLocationGroupTable:
	.db >wPresentRoomFlags >wPastRoomFlags
	.db >wGroup2Flags >wPastRoomFlags
	.db >wGroup4Flags >wGroup5Flags
	.db >wGroup4Flags >wGroup5Flags

;;
; @param	hActiveFileSlot	File index
initializeFile:
	ld c,$00
	jr ++

;;
; @param	hActiveFileSlot	File index
saveFile:
	ld c,$01
	jr ++

;;
; @param	hActiveFileSlot	File index
loadFile:
	ld c,$02
	jr ++

;;
; @param	hActiveFileSlot	File index
eraseFile:
	ld c,$03

++
	ldh a,(<hRomBank)
	push af
	callfrombank0 fileManagement.fileManagementFunction
	ld c,a
	pop af
	setrombank
	ld a,c
	ret

;;
vblankInterrupt:
	ldh a,(<hNextLcdInterruptBehaviour)
	ldh (<hLcdInterruptBehaviour),a
	xor a
	ldh (<hLcdInterruptCounter),a
	ld hl,hFFB7
	set 7,(hl)

	; Copy wram variables to real equivalents
	ld hl,wGfxRegsFinal
	ldi a,(hl)
	ld ($ff00+R_LCDC),a
	ldi a,(hl)
	ld ($ff00+R_SCY),a
	ldi a,(hl)
	ld ($ff00+R_SCX),a
	ldi a,(hl)
	ld ($ff00+R_WY),a
	ldi a,(hl)
	ld ($ff00+R_WX),a
	ldi a,(hl)
	ld ($ff00+R_LYC),a

	; increment wVBlankChecker
	inc (hl)
	jr nz,++

; The following code will only run when the main loop is explicitly waiting for vblank.

	ld de,wGfxRegs2
	ld l,<wGfxRegs3
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ldi (hl),a

	ld a,($ff00+R_VBK)
	ld b,a
	ld a,($ff00+R_SVBK)
	ld c,a
	push bc

	ldh a,(<hVBlankFunctionQueueTail)
	or a
	call nz,runVBlankFunctions

	call updateDirtyPalettes

	di
	call hOamFunc

	pop bc
	ld a,c
	ld ($ff00+R_SVBK),a
	ld a,b
	ld ($ff00+R_VBK),a

	ld hl,wGfxRegs6.LCDC
	ldi a,(hl)
	ld (wGfxRegs7.LCDC),a
	ldi a,(hl)
	ld (wGfxRegs7.SCY),a
	ldi a,(hl)
	ld (wGfxRegs7.SCX),a
++
	ld hl,hFFB7
	res 7,(hl)
	ldh a,(<hRomBank)
	bit 0,(hl)
	jr z,+
	ldh a,(<hSoundDataBaseBank2)
+
	ld ($2222),a
	pop hl
	pop de
	pop bc
	pop af
	reti

;;
runVBlankFunctions:
	ld hl,wVBlankFunctionQueue
--
	ldi a,(hl)
	push hl
	ld c,a
	ld b,$00
	ld hl,vblankFunctionsStart
	add hl,bc
	jp hl
;;
vblankFunctionRet:
	ldh a,(<hVBlankFunctionQueueTail)
	cp l
	jr nz,--

	xor a
	ldh (<hVBlankFunctionQueueTail),a
	ret

; Unused?
vblankFunctionOffset0:
	.db vblankFunction0a8e - vblankFunctionsStart

vblankRunBank4FunctionOffset:
	.db vblankRunBank4Function - vblankFunctionsStart

vblankCopyTileFunctionOffset:
	.db vblankCopyTileFunction - vblankFunctionsStart

; Unused?
vblankFunctionOffset3:
	.db vblankFunction0ad9 - vblankFunctionsStart

vblankFunctionOffset4:
	.db vblankFunction0ad9 - vblankFunctionsStart 

; Unused?
vblankFunctionOffset5:
	.db vblankFunction0aa8 - vblankFunctionsStart

vblankDmaFunctionOffset:
	.db vblankDmaFunction - vblankFunctionsStart


vblankFunctionsStart:

;;
vblankFunction0a8e:
	pop hl
	ldi a,(hl)
	ld ($ff00+R_VBK),a
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld b,a
-
	ldi a,(hl)
	ld (de),a
	inc de
	dec b
	jr nz,-
	jr vblankFunctionRet

;;
vblankRunBank4Function:
	ld a,:bank4.vblankRunBank4Function_b04
	ld ($2222),a
	jp bank4.vblankRunBank4Function_b04

;;
vblankFunction0aa8:
	pop hl
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	push hl
	ld l,c
	ld h,a
	ld bc,@return
	push bc
	jp hl

@return:
	pop hl
	jr vblankFunctionRet

;;
vblankCopyTileFunction:
	pop hl
	ld de,vblankFunctionRet
	push de

	xor a
	ld ($ff00+R_VBK),a
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld d,a
	ld c,e
	call @write4Bytes

	ld e,c
	ld a,$01
	ld ($ff00+R_VBK),a

;;
; @param	de	Destination (vram)
; @param	hl	Source
@write4Bytes:
	; Write 2 bytes
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	; Get a new value for 'e' (I guess calculating it would be too expensive during
	; vblank)
	ldi a,(hl)
	ld e,a

	; Write the next 2 bytes
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ret

;;
vblankFunction0ad9:
	pop hl
	ldi a,(hl)
	ld ($ff00+R_VBK),a
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld b,a
-
	ldi a,(hl)
	ld (de),a
	inc de
	dec b
	jr nz,-
	jr vblankFunctionRet

;;
vblankDmaFunction:
	pop hl
	ldi a,(hl)
	ld ($ff00+R_SVBK),a
	ld ($2222),a
	ldi a,(hl)
	ld ($ff00+R_HDMA1),a
	ldi a,(hl)
	ld ($ff00+R_HDMA2),a
	ldi a,(hl)
	ld ($ff00+R_VBK),a
	ldi a,(hl)
	ld ($ff00+R_HDMA3),a
	ldi a,(hl)
	ld ($ff00+R_HDMA4),a
	ldi a,(hl)
	ld ($ff00+R_HDMA5),a
	jp vblankFunctionRet



;;
; Update all palettes marked as dirty.
updateDirtyPalettes:
	ld a,$02
	ld ($ff00+R_SVBK),a

	ldh a,(<hDirtyBgPalettes)
	ld d,a
	xor a
	ldh (<hDirtyBgPalettes),a
	ld c, R_BGPI
	ld hl, w2BgPalettesBuffer
	call @writePaletteRegs

	ldh a,(<hDirtySprPalettes)
	ld d,a
	xor a
	ldh (<hDirtySprPalettes),a
	ld c, R_OBPI
	ld l, w2SprPalettesBuffer&$ff
;;
@writePaletteRegs:
	srl d
	jr nc,++

	ld a,l
	or $80
	ld ($ff00+c),a
	inc c
	ldi a,(hl)
	ld ($ff00+c),a
	ldi a,(hl)
	ld ($ff00+c),a
	ldi a,(hl)
	ld ($ff00+c),a
	ldi a,(hl)
	ld ($ff00+c),a
	ldi a,(hl)
	ld ($ff00+c),a
	ldi a,(hl)
	ld ($ff00+c),a
	ldi a,(hl)
	ld ($ff00+c),a
	ldi a,(hl)
	ld ($ff00+c),a
	dec c
	jr @writePaletteRegs
++
	ret z
	ld a,l
	add $08
	ld l,a
	jr @writePaletteRegs

;;
lcdInterrupt:
	ldh a,(<hLcdInterruptBehaviour)
	cp $02
	jr nc,@behaviour2OrHigher

	or a
	ld a,($ff00+R_LY)
	ld l,a
	ld h,>wBigBuffer
	ldi a,(hl)
	jr nz,+

	ld ($ff00+R_SCX),a
	jr ++
+
	ld ($ff00+R_SCY),a
++
	ld a,l
	cp $90
	jr nc,+
	ld ($ff00+R_LYC),a
+
	pop hl
	pop af
	reti

@behaviour2OrHigher:
	push bc
	ld c,$03

	; The first time the interrupt triggers, it's always to switch between displaying
	; the status bar at the top of the screen and the actual game.
	ldh a,(<hLcdInterruptCounter)
	or a
	jr nz,@notStatusBar
	ld hl,wGfxRegs3
-
	ld a,($ff00+R_STAT)
	and c
	jr nz,-

	ldi a,(hl)
	ld ($ff00+R_LCDC),a
	ldi a,(hl)
	ld ($ff00+R_SCY),a
	ldi a,(hl)
	ld ($ff00+R_SCX),a
	ldi a,(hl)
	ld ($ff00+R_WY),a
	ldi a,(hl)
	ld ($ff00+R_WX),a
	ldi a,(hl)
	ld ($ff00+R_LYC),a
	ldh a,(<hLcdInterruptBehaviour)
	cp $02
	jr nz,+

	xor a
	ldh (<hLcdInterruptBehaviour),a
+
	ld a,$01
	ldh (<hLcdInterruptCounter),a
	jr _lcdInterruptEnd

@notStatusBar:
	ldh a,(<hLcdInterruptBehaviour)
	cp $07
	jr nc,lcdInterrupt_clearLYC
	rst_jumpTable
	.dw lcdInterrupt_clearLYC
	.dw lcdInterrupt_clearLYC
	.dw lcdInterrupt_clearLYC
	.dw lcdInterrupt_setLcdcToA7
	.dw lcdInterrupt_clearWXY
	.dw lcdInterrupt_ringMenu
	.dw lcdInterrupt_0bea

;;
lcdInterrupt_setLcdcToA7:
	ld a,($ff00+R_STAT)
	and c
	jr nz,lcdInterrupt_setLcdcToA7
	ld a,$a7
	ld ($ff00+R_LCDC),a
	jr lcdInterrupt_clearLYC

;;
; Ring menu: LCD interrupt triggers up to two times:
;   * Once on line $47 (list menu) or $57 (appraisal menu), where the textbox starts.
;   * If on the list menu, once more on line $87, where the textbox ends.
lcdInterrupt_ringMenu:
	ld a,($ff00+R_STAT)
	and c
	jr nz,lcdInterrupt_ringMenu

	ld ($ff00+R_SCX),a ; SCX = 0
	ld a,$87
	ld ($ff00+R_LCDC),a

	ldh a,(<hLcdInterruptCounter)
	dec a
	jr nz,@afterTextbox

	ld a,(wRingMenu_mode)
	or a
	jr z,+
	ld a,$87 ; Trigger LCD interrupt again later on line $87
	ld ($ff00+R_LYC),a
+
	ld a,$02
	ldh (<hLcdInterruptCounter),a
	jr _lcdInterruptEnd

@afterTextbox:
	ld a,$80
	ld ($ff00+R_SCY),a
	jr lcdInterrupt_clearWXY

;;
lcdInterrupt_clearWXY:
	ld a,$c7
	ld ($ff00+R_WY),a
	ld ($ff00+R_WX),a

;;
lcdInterrupt_clearLYC:
	ld a,$c7
	ld ($ff00+R_LYC),a
_lcdInterruptEnd:
	pop bc
	pop hl
	pop af
	reti

;;
lcdInterrupt_0bea:
	ld a,($ff00+R_STAT)
	and c
	jr nz,lcdInterrupt_0bea
	ld hl,wGfxRegs7.LCDC
	ldi a,(hl)
	ld ($ff00+R_LCDC),a
	ldi a,(hl)
	ld ($ff00+R_SCY),a
	ldi a,(hl)
	ld ($ff00+R_SCX),a
	jr lcdInterrupt_clearLYC

; Table of functions in bank $04?
data_0bfd:
	.dw bank4.b4VBlankFunction0
	.dw bank4.b4VBlankFunction1
	.dw bank4.b4VBlankFunction2
	.dw bank4.b4VBlankFunction3
	.dw bank4.b4VBlankFunction4
	.dw bank4.b4VBlankFunction5
	.dw bank4.b4VBlankFunction6
	.dw bank4.b4VBlankFunction7
	.dw bank4.b4VBlankFunction8
	.dw bank4.b4VBlankFunction9
	.dw bank4.b4VBlankFunction10
	.dw bank4.b4VBlankFunction11
	.dw bank4.b4VBlankFunction12
	.dw bank4.b4VBlankFunction13
	.dw bank4.b4VBlankFunction14
	.dw bank4.b4VBlankFunction15
	.dw bank4.b4VBlankFunction16
	.dw bank4.b4VBlankFunction17
	.dw bank4.b4VBlankFunction18
	.dw bank4.b4VBlankFunction19
	.dw bank4.b4VBlankFunction20
	.dw bank4.b4VBlankFunction21
	.dw bank4.b4VBlankFunction22
	.dw bank4.b4VBlankFunction23
	.dw bank4.b4VBlankFunction24
	.dw bank4.b4VBlankFunction25
	.dw bank4.b4VBlankFunction26
	.dw bank4.b4VBlankFunction27
	.dw bank4.b4VBlankFunction28
	.dw bank4.b4VBlankFunction29
	.dw bank4.b4VBlankFunction30
	.dw bank4.b4VBlankFunction31


;;
serialInterrupt:
	ldh a,(<hSerialInterruptBehaviour)
	or a
	jr z,@internalClock

@externalClock:
	ld a,($ff00+R_SB)
	ldh (<hSerialByte),a
	xor a
	ld ($ff00+R_SB),a
	inc a
	ldh (<hReceivedSerialByte),a
	pop af
	reti

@internalClock:
	; If received $d0 or $d1 ($e0 or $e1 for US region), switch to external clock
	ld a,($ff00+R_SB)
	cp $d1 + SERIAL_UPPER_NIBBLE
	jr z,+

	cp $d0 + SERIAL_UPPER_NIBBLE
	jr nz,++
+
	ldh (<hSerialInterruptBehaviour),a
	xor a
	ld ($ff00+R_SB),a
	pop af
	reti
++
	ld a,$d1 + SERIAL_UPPER_NIBBLE
	ld ($ff00+R_SB),a
	ld a,$80
	call writeToSC
	pop af
	reti

;;
; Writes A to SC. Also writes $00 or $01 beforehand which might just be to reset any active
; transfers?
writeToSC:
	push af
	and $01
	ld ($ff00+R_SC),a
	pop af
	ld ($ff00+R_SC),a
	ret

;;
serialFunc_0c73:
	xor a
	ldh (<hFFBD),a
	ld a,$d0 + SERIAL_UPPER_NIBBLE
	ld ($ff00+R_SB),a
	ld a,$81
	jr writeToSC

;;
disableSerialPort:
	xor a
	ldh (<hSerialInterruptBehaviour),a
	ld ($ff00+R_SB),a
	jr writeToSC

;;
serialFunc_0c85:
	jpab serialCode.func_44ac

;;
serialFunc_0c8d:
	push de
	callab serialCode.func_4000
	pop de
	ret

;;
; @param	a	Sound to play
playSound:
	or a
	ret z

	ld h,a
	ldh a,(<hFFB7)
	bit 3,a
	ret nz

	ldh a,(<hMusicQueueTail)
	ld l,a
	ld a,h
	ld h,>wMusicQueue
	ldi (hl),a
	ld a,l
	and $af
	ldh (<hMusicQueueTail),a
	ret

;;
; @param	a	Volume (0-3)
setMusicVolume:
	or $80
	ldh (<hMusicVolume),a
	ret

;;
restartSound:
	ld bc,audio.b39_stopSound
	jr _startSound

;;
initSound:
	ld bc,audio.b39_initSound

;;
; @param bc Function to call for initialization
_startSound:
	push de
	ldh a,(<hRomBank)
	push af
	call disableTimer
	ld a,:audio.b39_initSound
	ldh (<hSoundDataBaseBank),a
	ldh (<hSoundDataBaseBank2),a
	setrombank
	call jpBc
	call enableTimer
	pop af
	setrombank
	pop de
	ret

;;
jpBc:
	ld l,c
	ld h,b
	jp hl

;;
disableTimer:
	ld hl,hFFB7
	set 0,(hl)
	xor a
	ld ($ff00+R_TAC),a
	ret

;;
enableTimer:
	xor a
	ld ($ff00+R_TAC),a
	ld a,<wMusicQueue
	ldh (<hMusicQueueTail),a
	ldh (<hMusicQueueHead),a
	ld a,($ff00+R_KEY1)
	rlca
	ld a,$77
	jr c,+
	ld a,$bb
+
	ld hl,TIMA
	ldi (hl),a
	ldi (hl),a
	xor a
	ld (hl),a
	set 2,(hl)
	ld hl,hFFB7
	res 0,(hl)
	ret

;;
timerInterrupt:
	ld hl,hFFB7
	bit 7,(hl)
	jr nz,@interruptEnd
	bit 0,(hl)
	jr nz,@interruptEnd

	set 0,(hl)

	; Increment hFFB8
	inc l
	dec (hl)
	jr nz,+

	ld (hl),$07
	ld a,($ff00+R_TMA)
	dec a
	ld ($ff00+R_TIMA),a
+
	ld a,:audio.b39_updateMusicVolume
	ld ($2222),a
	ldh a,(<hMusicVolume)
	bit 7,a
	jr z,+

	and $03
	ldh (<hMusicVolume),a
	call audio.b39_updateMusicVolume
+
	ldh a,(<hMusicQueueTail)
	ld b,a
	ldh a,(<hMusicQueueHead)
	cp b
	jr z,++

	ld h,>wMusicQueue
-
	ld l,a
	ldi a,(hl)
	push bc
	push hl
	call audio.b39_playSound
	pop hl
	pop bc
	ld a,l
	and $af
	cp b
	jr nz,-

	ldh (<hMusicQueueHead),a
++
	call audio.b39_updateSound
	ld hl,hFFB7
	res 0,(hl)
	ldh a,(<hRomBank)
	ld ($2222),a

@interruptEnd:
	pop hl
	pop de
	pop bc
	pop af
	reti

;;
; Writes data at hl to oam. First byte of data is how many objects. Each object
; has 4 bytes (y, x, tile, attributes).
;
; ff8b: internal variable (number of objects remaining)
;
; @param	hl	OAM data
addSpritesToOam:
	ld bc,$0000

;;
; @param	bc	Sprite offset
; @param	hl	OAM data
addSpritesToOam_withOffset:
	ldh a,(<hOamTail)
	cp $a0
	ret nc
	ld e,a
	ld d,>wOam
	ldi a,(hl)
	or a
	ret z
@next:
	ldh (<hFF8B),a
	ldi a,(hl)
	add b
	cp $a0
	jr nc,@skip3Bytes
	ld (de),a
	ldi a,(hl)
	add c
	cp $a8
	jr nc,@skip2Bytes
	inc e
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,e
	cp $a0
	jr nc,@end
@decCounter:
	ldh a,(<hFF8B)
	dec a
	jr nz,@next
	ld a,e
@end:
	ldh (<hOamTail),a
	ret

@skip3Bytes:
	inc hl
@skip2Bytes:
	inc hl
	inc hl
	ld a,$e0
	ld (de),a
	jr @decCounter

;;
drawAllSprites:
	ld hl,wc4b6
	bit 0,(hl)
	ret nz

	ld (hl),$ff

;;
drawAllSpritesUnconditionally:
	ldh a,(<hRomBank)
	push af
	call queueDrawEverything

.ifdef ROM_AGES
	ld a,(wLinkRaisedFloorOffset)
	ld hl,w1Link.yh
	add (hl)
	ld (hl),a
.endif

	ld de,w1Link

	ld b,<w1Link.yh
	ld a,(wTextboxFlags)
	and TEXTBOXFLAG_ALTPALETTE1
	jr z,@loop

	; Draw link object
	call objectQueueDraw
	jr ++

	; Draw w1Link, w1Companion, and w1ParentItem2-w1ParentItem5.
@loop:
	call objectQueueDraw
	inc d
	ld a,d
	cp $d6
	jr c,@loop
++
	; Update the puddle animation
	ld a,:terrainEffects.puddleAnimationFrames
	setrombank

	; Every 16 frames, the animation changes
	ld a,(wFrameCounter)
	add a
	swap a
	and $03
	ld hl,terrainEffects.puddleAnimationFrames
	rst_addDoubleIndex

	ldi a,(hl)
	ld (wPuddleAnimationPointer),a
	ldi a,(hl)
	ld (wPuddleAnimationPointer+1),a

	; Write a "jp" opcode to wRamFunction
	ld hl,wRamFunction
	; Jump
	ld a,$c3
	ldi (hl),a
	; Jump to _getObjectPositionOnScreen
	ld a,<_getObjectPositionOnScreen
	ldi (hl),a
	ld (hl),>_getObjectPositionOnScreen

	ld a,(wScrollMode)
	cp $08
	jr nz,++

	; Or if a screen transition is occuring, jump to _getObjectPositionOnScreen_duringScreenTransition
	ld a,>_getObjectPositionOnScreen_duringScreenTransition
	ldd (hl),a
	ld (hl),<_getObjectPositionOnScreen_duringScreenTransition

	; Load some variables (hFF90-hFF93) for the
	; _getObjectPositionOnScreen_duringScreenTransition function
	xor a
	ld b,a
	inc a
	ldh (<hFF8A),a
	ld a,(wRoomIsLarge)
	or a
	jr z,+
	ld a,$04
+
	ld c,a
	ld a,(wScreenTransitionDirection)
	add c
	add a
	add a
	ld c,a
	ld hl,data_1058
	add hl,bc
	ldi a,(hl)
	ldh (<hFF90),a
	ldi a,(hl)
	ldh (<hFF91),a
	ldi a,(hl)
	ldh (<hFF92),a
	ldi a,(hl)
	ldh (<hFF93),a
++

	; Draw all queued objects
	ld hl,wObjectsToDraw
-
	ld a,(hl)
	or a
	call nz,@drawObject
	inc l
	inc l
	bit 7,l
	jr z,-

	; Draw pending terrain effects (shadows)
	ld hl,wTerrainEffectsBuffer
	ldh a,(<hTerrainEffectsBufferUsedSize)
	rrca
	srl a
	ld b,a
	jr z,++
-
	push bc
	ldi a,(hl)
	ldh (<hFF8C),a
	ldi a,(hl)
	ldh (<hFF8D),a
	ldi a,(hl)
	push hl
	ld h,(hl)
	ld l,a
	call func_0eda
	pop hl
	inc l
	pop bc
	dec b
	jr nz,-
++

	; Clear all unused OAM entries
	ldh a,(<hOamTail)
	cp $a0
	jr nc,++

	ld h,>wOam
	ld b,$e0
-
	ld l,a
	ld (hl),b
	add $04
	cp $a0
	jr c,-
++

.ifdef ROM_AGES
	; Undo link's Y offset for drawing
	ld a,(wLinkRaisedFloorOffset)
	cpl
	inc a
	ld hl,w1Link.yh
	add (hl)
	ld (hl),a
.endif

	pop af
	setrombank
	ret

;;
; @param hl Address in wObjectsToDraw.
@drawObject:
	push hl
	inc l
	ld h,(hl)
	ld l,a
	; hl now points to the object's y-position.

	; This is equivalent to either
	; "call _getObjectPositionOnScreen" or
	; "call _getObjectPositionOnScreen_duringScreenTransition".
	call wRamFunction
	jr nc,@return

	; hl points to Object.oamFlags
	ldi a,(hl)
	ldh (<hFF8F),a

	; Object.oamTileIndexBase
	ldi a,(hl)
	ldh (<hFF8E),a

	; Object.oamDataAddress
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	; Get address, bank of animation frame data
	ld a,h
	and $c0
	rlca
	rlca
	add BASE_OAM_DATA_BANK
	setrombank
	set 6,h
	res 7,h

	; Check how many sprites are to be drawn, load it into c
	ldi a,(hl)
	or a
	jr z,@return

	ld c,a

	; Get first available OAM index, or return if it's full
	ldh a,(<hOamTail)
	ld e,a
	ld a,<wOamEnd
	sub e
	jr z,@return

	; Set b to the number of available OAM slots, will return if this
	; reaches zero
	rrca
	rrca
	ld b,a

	ld d,>wOam
	; b = # available slots,
	; c = # sprites to be drawn,
	; de points to OAM,
	; hl points to animation frame data

@nextSprite:
	; Y position
	ldh a,(<hFF8C)
	add (hl)
	inc hl
	cp $a0
	jr nc,@incHlToNextSprite
	ld (de),a

	; X position
	ldh a,(<hFF8D)
	add (hl)
	cp $a8
	jr nc,@incHlToNextSprite

	inc e
	ld (de),a

	; Tile index
	inc hl
	inc e
	ldh a,(<hFF8E)
	add (hl)
	ld (de),a

	; Flags
	inc hl
	inc e
	ldh a,(<hFF8F)
	xor (hl)
	ld (de),a

	inc hl
	inc e
	dec b
	jr z,@doneDrawing

	dec c
	jr nz,@nextSprite

@doneDrawing:
	ld a,e
	ldh (<hOamTail),a
@return:
	pop hl
	ld (hl),$00
	ret

@incHlToNextSprite:
	inc hl
	inc hl
	inc hl
	dec c
	jr nz,@nextSprite
	jr @doneDrawing

;;
; This function is similar to @drawObject above, except it simply draws raw OAM
; data which isn't associated with a particular object. It has a rather
; specific purpose, hence the hard-coded bank number.
; @param hl Address of oam data
; @param hFF8C Y-position to draw at
; @param hFF8D X-position to draw at
func_0eda:
	ld a,:terrainEffects.shadowAnimation
	setrombank

	; Get the end of used OAM, get how many sprites are to be drawn, check
	; if there's enough space
	ldh a,(<hOamTail)
	ld e,a
	ldi a,(hl)
	ld c,a
	add a
	add a
	add e
	cp <wOamEnd+1
	jr nc,@end
	ld d,>wOam

@nextSprite:
	; Y-position
	ldh a,(<hFF8C)
	add (hl)
	ld (de),a
	inc hl
	inc e

	; X-position
	ldh a,(<hFF8D)
	add (hl)
	ld (de),a
	inc hl
	inc e

	; Tile index
	ldi a,(hl)
	ld (de),a
	inc e

	; Flags
	ldi a,(hl)
	ld (de),a
	inc e

	dec c
	jr nz,@nextSprite

	ld a,e
	ldh (<hOamTail),a
@end:
	ret

;;
; Draw an object's shadow, or grass / puddle animation as necessary.
; @param	b	Value of hCameraY?
; @param	e	Object's Z position
; @param	hl	Pointer to object
; @param	[hFF8C]	Y-position
; @param	[hFF8D]	X-position
_drawObjectTerrainEffects:
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	ret nz

	ld a,b
	cp $97
	ret nc

	bit 7,e
	jr z,@onGround

@inAir:
	; Return every other frame (creates flickering effect)
	ld a,(wFrameCounter)
	xor h
	rrca
	ret nc

	; Add an entry to wTerrainEffectsBuffer to queue a shadow for drawing
	push hl
	ldh a,(<hTerrainEffectsBufferUsedSize)
	add <wTerrainEffectsBuffer
	ld l,a
	ld h,>wTerrainEffectsBuffer
	ldh a,(<hFF8C)
	ldi (hl),a
	ldh a,(<hFF8D)
	ldi (hl),a
	ld a,<terrainEffects.shadowAnimation
	ldi (hl),a
	ld a,>terrainEffects.shadowAnimation
	ldi (hl),a
	ld a,l
	sub <wTerrainEffectsBuffer
	ldh (<hTerrainEffectsBufferUsedSize),a
	pop hl
	ret

@onGround:
	ld a,(wScrollMode)
	cp $08
	ret z
	push hl
	ld a,l
	and $c0
	add $0b
	ld l,a
	ldi a,(hl)
	ld b,a
	add $05
	and $f0
	ld c,a
	inc l
	ld l,(hl)
	ld a,l
	xor b
	ld h,a
	ld a,l
	and $f0
	swap a
	or c
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)

.ifdef ROM_AGES
	cp TILEINDEX_GRASS
	jr z,@walkingInGrass
	cp TILEINDEX_PUDDLE
	jr nz,@end

.else ; ROM_SEASONS
	; Seasons has multiple grass and shallow water tiles, so this checks ranges
	; instead of exact values
	cp TILEINDEX_GRASS
	jr c,@end
	cp TILEINDEX_WATER
	jr nc,@end
	cp TILEINDEX_PUDDLE
	jr c,@walkingInGrass
.endif

@walkingInPuddle:
	inc e
	ld hl,wPuddleAnimationPointer
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jr @grassOrWater

@walkingInGrass:
	bit 2,h
	ld a,(wGrassAnimationModifier)
	jr z,+
	add $24
+
	ld c,a
	ld b,$00
	ld hl,terrainEffects.greenGrassAnimationFrame0
	add hl,bc

@grassOrWater:
	push de
	call func_0eda
	pop de

@end:
	pop hl
	ret

;;
; Get the position where an object should be drawn on-screen, accounting for
; screen scrolling. Clears carry flag if the object is not visible.
;
; @param	hl	Pointer to an object's y-position.
; @param[out]	hl	Pointer to the object's Object.oamFlags variable.
; @param[out]	hFF8C	Y position to draw the object
; @param[out]	hFF8D	X position to draw the object
; @param[out]	cflag	nc if the object is not visible
_getObjectPositionOnScreen:
	ldh a,(<hCameraX)
	ld c,a
	ldh a,(<hCameraY)
	ld b,a

	; Object.yh
	ldi a,(hl)
	sub b
	add $10
	ldh (<hFF8C),a
	ld d,a

	; Object.xh
	inc l
	ldi a,(hl)
	sub c
--
	ldh (<hFF8D),a

	; Object.zh
	inc l
	ld e,(hl)

	; Return if not visible (bit 7 of Object.visible unset)
	ld a,l
	and $c0
	add Object.visible
	ld l,a
	ld a,(hl)
	rlca
	ret nc

	; Draw shadows and stuff if bit 6 is set
	rlca
	call c,_drawObjectTerrainEffects

	; Account for Z position
	ld a,d
	add e
	ldh (<hFF8C),a

	; Point hl to the Object.oamFlags variable
	ld a,l
	and $c0
	add Object.oamFlags
	ld l,a

	scf
	ret

;;
_label_00_152:
	ldh a,(<hCameraX)
	ld c,a
	ldh a,(<hCameraY)
	ld b,a
	ldi a,(hl)
	sub b
	add $10
	ldh (<hFF8C),a
	ld d,a
	inc l
	ldi a,(hl)
	sub c
	jr --

;;
; This function takes the place of "_getObjectPositionOnScreen" during screen
; transitions.
;
; Clears carry flag if the object shouldn't be drawn for whatever reason.
;
; @param	hl	Pointer to an object's y-position.
; @param	hFF8A	Bitset on Object.enabled to check (always $01?)
; @param	hFF90-hFF93
; @param[out]	hl	Pointer to the object's Object.oamFlags variable.
; @param[out]	hFF8C	Y position to draw the object
; @param[out]	hFF8D	X position to draw the object
; @param[out]	cflag	nc if object shouldn't be drawn
_getObjectPositionOnScreen_duringScreenTransition:
	ld d,h
	ld a,l
	and $c0
	ld e,a
	ld a,(de)
	and $03
	cp $03
	jr z,_label_00_152

	; Read Object.yh
	ld d,$00
	ldi a,(hl)
	add $10
	ld c,a
	ld a,d
	adc a
	ld b,a

	; Read Object.xh
	inc l
	ldi a,(hl)
	ld e,a
	push hl

	; Check Object.enabled is set (hFF8A is always $01 here?)
	ld a,l
	and $c0
	ld l,a
	ldh a,(<hFF8A)
	and (hl)
	jr z,+

	ld hl,hFF90
	ldi a,(hl)
	add c
	ld c,a
	ldi a,(hl)
	adc b
	ld b,a
	ldi a,(hl)
	add e
	ld e,a
	ldi a,(hl)
	adc d
	ld d,a
+
	ld hl,hCameraY
	ld a,c
	sub (hl)
	ld c,a
	inc l
	ld a,b
	sbc (hl)
	ld b,a
	jr z,+

	inc a
	jr nz,@dontDraw
	ld a,c
	cp $e0
	jr c,@dontDraw
	jr ++
+
	ld a,c
	cp $b0
	jr nc,@dontDraw
++
	; This write seems mostly pointless, although it could be necessary for
	; the call to _drawObjectTerrainEffects? (This gets overwritten later)
	ldh (<hFF8C),a

	ld b,a
	inc l
	ld a,e
	sub (hl)
	ld e,a
	inc l
	ld a,d
	sbc (hl)
	ld d,a
	jr z,+

	inc a
	jr nz,@dontDraw
	ld a,e
	cp $e8
	jr c,@dontDraw
	jr ++
+
	ld a,e
	cp $b8
	jr nc,@dontDraw
++
	ldh (<hFF8D),a
	ld d,b
	pop hl
	inc l
	ld e,(hl)
	ld a,l
	and $c0
	add Object.visible
	ld l,a
	ld a,(hl)
	rlca
	ret nc

	; Draw shadows and stuff if bit 6 is set
	rlca
	call c,_drawObjectTerrainEffects

	ld a,d
	add e
	ldh (<hFF8C),a
	ld a,l
	and $c0
	add Object.oamFlags
	ld l,a
	scf
	ret

@dontDraw:
	pop hl
	ld a,l
	and $c0
	ld l,a
	bit 1,(hl)
	jr z,+

	or Object.visible
	ld l,a
	ld (hl),$00
+
	xor a
	ret

; Something to do with sprite positions during screen transitions. 4 bytes get written to
; hFF90-hFF93, and the values are used in _getObjectPositionOnScreen_duringScreenTransition.
data_1058:
	; Small rooms
	.db $80 $ff $00 $00 ; scrolling up
	.db $00 $00 $a0 $00 ; scrolling right
	.db $80 $00 $00 $00 ; scrolling down
	.db $00 $00 $60 $ff ; scrolling left
	; Large rooms
	.db $50 $ff $00 $00 ; scrolling up
	.db $00 $00 $f0 $00 ; scrolling right
	.db $b0 $00 $00 $00 ; scrolling down
	.db $00 $00 $10 $ff ; scrolling left

;;
; Call objectQueueDraw on everything, except $d0-$d5 objects at $00-$3f (Link, Companion,
; and "ParentItems").
queueDrawEverything:
	ld hl,hTerrainEffectsBufferUsedSize
	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a

	ld de,FIRST_ITEM_INDEX<<8
	ld b,Item.yh
	call @func

	ld de,$d080
	ld b,Enemy.yh
	call @func

	ld de,$d0c0
	ld b,Part.yh
	call @func

	ld de,$d040
	ld b,Interaction.yh
@func:
	call objectQueueDraw
	inc d
	ld a,d
	cp $e0
	jr c,@func
	ret

;;
; @param	b	Low byte of the address of the Object.yh variable
; @param	de	Start address of object to draw
objectQueueDraw:
	ld a,(de)
	or a
	ret z

	ld a,e
	or Object.visible
	ld l,a
	ld h,d
	ld a,(hl)
	bit 7,a
	ret z

	and $03
	ld h,a
	add <hObjectPriority0Counter
	ld c,a
	ld a,($ff00+c)
	cp $10
	ret nc

	; Write the object's address to the appropriate position in
	; wObjectsToDraw, increment the ObjectPriorityCounter.
	inc a
	ld ($ff00+c),a
	dec a
	swap h
	add h
	add a
	ld l,a
	ld h,>wObjectsToDraw
	ld a,b
	ldi (hl),a
	ld (hl),d
	ret

;;
; Gets the data for a chest in the current room.
; Defaults to position $00, contents $2800 if a chest is not found.
;
; @param	bc	Chest contents
; @param	e	Chest position
getChestData:
	ldh a,(<hRomBank)
	push af
	ld a,:chestData.chestDataGroupTable
	setrombank
	ld a,(wActiveGroup)
	ld hl,chestData.chestDataGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wActiveRoom)
	ld b,a
-
	ldi a,(hl)
	ld e,a
	inc a
	jr z,@chestNotFound

	ldi a,(hl)
	cp b
	jr z,+

	inc hl
	inc hl
	jr -
+
	ld b,(hl)
	inc hl
	ld c,(hl)
	jr @end

@chestNotFound:
	ld bc,$2800

@end:
	pop af
	setrombank
	ret

;;
; Set Link's death respawn point based on the current room / position variables.
setDeathRespawnPoint:
	ld hl,wDeathRespawnBuffer
	ld a,(wActiveGroup)
	ldi (hl),a
	ld a,(wActiveRoom)
	ldi (hl),a
	ld a,(wRoomStateModifier)
	ldi (hl),a
	ld a,(w1Link.direction)
	ldi (hl),a
	ld a,(w1Link.yh)
	ldi (hl),a
	ld a,(w1Link.xh)
	ldi (hl),a
	ld a,(wRememberedCompanionId)
	ldi (hl),a
	ld a,(wRememberedCompanionGroup)
	ldi (hl),a
	ld a,(wRememberedCompanionRoom)
	ldi (hl),a
	ld a,(wLinkObjectIndex)
	ldi (hl),a
	inc l
	ld a,(wRememberedCompanionY)
	ldi (hl),a
	ld a,(wRememberedCompanionX)
	ldi (hl),a
	ret

;;
func_1135:
	xor a
	ld (wDeathRespawnBuffer.rememberedCompanionGroup),a
	ret

;;
updateLinkLocalRespawnPosition:
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,<w1Link.direction
	ld a,(hl)
	ld (wLinkLocalRespawnDir),a
	ld l,<w1Link.yh
	ld a,(hl)
	ld (wLinkLocalRespawnY),a
	ld l,<w1Link.xh
	ld a,(hl)
	ld (wLinkLocalRespawnX),a
	ret

;;
; Updates room flags when a tile is broken. For some tiles, this involves setting the room
; flags in more than one room, to mark a door as open on both sides.
;
; @param	a	Tile that was broken
updateRoomFlagsForBrokenTile:
	push af
	ld hl,_unknownTileCollisionTable
	call lookupCollisionTable
	call c,addToGashaMaturity

	pop af
	ld hl,_tileUpdateRoomFlagsOnBreakTable
	call lookupCollisionTable
	ret nc

	bit 7,a
	jp nz,setRoomFlagsForUnlockedKeyDoor

	bit 6,a
	jp nz,setRoomFlagsForUnlockedKeyDoor_overworldOnly

	and $0f
	ld bc,bitTable
	add c
	ld c,a
	ld a,(wActiveGroup)
	ld hl, flagLocationGroupTable
	rst_addAToHl
	ld h,(hl)
	ld a,(wActiveRoom)
	ld l,a
	ld a,(bc)
	or (hl)
	ld (hl),a
	ret


; This is a list of tiles that will cause certain room flag bits to be set when destroyed.
; (In order for this to work, the corresponding bit in the "_breakableTileModes" table
; must be set so that it calls the above function.)
_tileUpdateRoomFlagsOnBreakTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

; Data format:
; b0: tile index
; b1: bit 7:    Set if it's a door linked between two rooms in a dungeon (will update the
;               room flags in both rooms)
;     bit 6:    Set if it's a door linked between two rooms in the overworld
;     bits 0-3: If bit 6 or 7 is set, this is the "direction" of the room link (times 4).
;               If bits 6 and 7 aren't set, this is the bit to set in the room flags (ie.
;               value of 2 will set bit 2).

.ifdef ROM_AGES

@collisions0:
@collisions4:
	.db $c6 $07
	.db $c7 $07
	.db $c9 $07
	.db $c1 $07
	.db $c2 $07
	.db $c4 $07
	.db $cb $07
	.db $d1 $07
	.db $cf $07
	.db $00
@collisions1:
	.db $30 $00
	.db $31 $44
	.db $32 $02
	.db $33 $4c
	.db $00
@collisions2:
@collisions5:
	.db $30 $80
	.db $31 $84
	.db $32 $88
	.db $33 $8c
	.db $38 $80
	.db $39 $84
	.db $3a $88
	.db $3b $8c
	.db $68 $84
	.db $69 $8c
@collisions3:
	.db $00


.else ; ROM_SEASONS


@collisions0:
	.db $c6 $07
	.db $c1 $07
	.db $c2 $07
	.db $e3 $07
@collisions1:
	.db $e2 $07
	.db $cb $07
	.db $c5 $07
@collisions2:
	.db $00

@collisions3:
	.db $30 $00
	.db $31 $44
	.db $32 $02
	.db $33 $4c
	.db $00

@collisions4:
	.db $30 $80
	.db $31 $84
	.db $32 $88
	.db $33 $8c
	.db $38 $80
	.db $39 $84
	.db $3a $88
	.db $3b $8c
@collisions5:
	.db $00

.endif


; Seems to list some breakable tiles similar to the table above?
_unknownTileCollisionTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

; Data format:
; b0: tile index
; b1: amount to add to wGashaMaturity?

.ifdef ROM_AGES

@collisions0:
@collisions4:
	.db $c7 50
	.db $c2 50
	.db $cb 50
	.db $d1 50
	.db $cf 30
	.db $c6 30
	.db $c4 30
	.db $c9 30
	.db $00
@collisions1:
	.db $30 100
	.db $31 100
	.db $32 100
	.db $33 100
	.db $00
@collisions2:
@collisions5:
	.db $30 50
	.db $31 50
	.db $32 50
	.db $33 50
	.db $38 100
	.db $39 100
	.db $3a 100
	.db $3b 100
	.db $68 50
	.db $69 50
@collisions3:
	.db $00


.else ; ROM_SEASONS


@collisions0:
	.db $c6 $32
	.db $c2 $32
	.db $e3 $32
@collisions1:
	.db $e2 $32
	.db $cb $1e
	.db $c5 $1e
@collisions2:
	.db $00

@collisions3:
	.db $30 $64
	.db $31 $64
	.db $32 $64
	.db $33 $64
	.db $00

@collisions4:
	.db $30 $32
	.db $31 $32
	.db $32 $32
	.db $33 $32
	.db $38 $64
	.db $39 $64
	.db $3a $64
	.db $3b $64
@collisions5:
	.db $00

.endif


;;
; Marks a key door as unlocked by writing to the room flags, and checks for the adjacent
; room to unlock the other side of the door as well.
;
; @param	a	Direction of door (times 4) (upper 4 bits are ignored)
setRoomFlagsForUnlockedKeyDoor:
	and $0f
	ld de,_adjacentRoomsData
	call addAToDe
	ld a,(wDungeonIndex)
	cp $ff
	jr z,@notInDungeon

	; Set the flag in the first room
	call getActiveRoomFromDungeonMapPosition
	call @setRoomFlag

	; Calculate the position of the second room, and set the corresponding flag there
	inc de
	ld a,(wDungeonMapPosition)
	ld l,a
	ld a,(de)
	add l
	call getRoomInDungeon
	inc de

@setRoomFlag:
	ld c,a
	ld a,(wDungeonFlagsAddressH)
	ld b,a
	ld a,(de)
	ld l,a
	ld a,(bc)
	or l
	ld (bc),a
	ret

@notInDungeon:
	call getThisRoomFlags
	ld a,(de)
	or (hl)
	ld (hl),a
	ret

; Data format:
; b0: Room flag to set in first room
; b1: Value to add to wDungeonMapPosition to get the adjacent room
; b2: Room flag to set in second room
; b3: Unused
_adjacentRoomsData:
	.db $01 $f8 $04 $00 ; Key door going up
	.db $02 $01 $08 $00 ; Key door going right
	.db $04 $08 $01 $00 ; Key door going down
	.db $08 $ff $02 $00 ; Key door going left

;;
; This function differs from the above one in that:
; * It only works for the PRESENT OVERWORLD (ages) or INDOOR ROOMS in group 2 (seasons).
; * The above, which CAN work for the overworlds, only sets the flag on the one screen
;   when used on the overworld; the adjacent room doesn't get updated.
; * This only works for rooms connected horizontally, since it uses the table above for
;   dungeons which assumes that vertical rooms are separated by $08 instead of $10.
;
; @param	a	Direction of door (times 4) (upper 4 bits are ignored)
setRoomFlagsForUnlockedKeyDoor_overworldOnly:
	and $0f
	ld hl,_adjacentRoomsData
	rst_addAToHl
	ld a,(wActiveRoom)
	ld c,a
	ld b,>wGroup2Flags
	ld a,(bc)
	or (hl)
	ld (bc),a
	inc hl
	ldi a,(hl)
	add c
	ld c,a
	ld a,(bc)
	or (hl)
	ld (bc),a
	ret

;;
; Allows link to walk through chests when he's already inside one.
checkAndUpdateLinkOnChest:
	ld a,(wLinkOnChest)
	or a
	jr nz,++

	ld a,(wActiveTileIndex)
	cp TILEINDEX_CHEST
	ret nz

	ld a,(wActiveTilePos)
	ld (wLinkOnChest),a
	ld l,a
	ld h,>wRoomCollisions
	ld (hl),$00
	ret
++
	ld c,a
	ld a,(wActiveTilePos)
	cp c
	ret z

	ld b,>wRoomLayout
	ld a,(bc)
	call retrieveTileCollisionValue
	dec b
	ld (bc),a
	xor a
	ld (wLinkOnChest),a
	ret

;;
; @param[out]	cflag	Set if Link interacted with a tile that should disable some of his
;			code? (Opened a chest, read a sign, opened an overworld keyhole)
interactWithTileBeforeLink:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank6.interactWithTileBeforeLink
	rl c
	pop af
	setrombank
	srl c
	ret

;;
; Shows TX_510a ("It's too heavy to move") if it hasn't been shown already.
showInfoTextForRoller:
	ldh a,(<hRomBank)
	push af
	ld a,:bank6.showInfoTextForTile
	setrombank
	ld a,$09
	call bank6.showInfoTextForTile
	pop af
	setrombank
	ret

;;
updateCamera:
	ld a,(wScrollMode)
	and $05
	ret z

	ldh a,(<hRomBank)
	push af
	callfrombank0 bank1.updateCameraPosition
	call          bank1.updateGfxRegs2Scroll
	call          bank1.updateScreenShake
	pop af
	setrombank
	ret

;;
resetCamera:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank1.calculateCameraPosition
	call          bank1.updateGfxRegs2Scroll
	pop af
	setrombank
	ret

;;
setCameraFocusedObject:
	ldh a,(<hActiveObject)
	ld (wCameraFocusedObject),a
	ldh a,(<hActiveObjectType)
	ld (wCameraFocusedObjectType),a
	ret

;;
setCameraFocusedObjectToLink:
	ld a,(wLinkObjectIndex)
	ld (wCameraFocusedObject),a
	ld a,$00
	ld (wCameraFocusedObjectType),a
	ret

;;
; Reloads tile map for the room from w3VramTiles, w3VramAttributes.
reloadTileMap:
	ldh a,(<hRomBank)
	push af
	xor a
	ld (wScreenOffsetY),a
	ld (wScreenOffsetX),a
	ld a,UNCMP_GFXH_10
	call loadUncompressedGfxHeader
	callfrombank0 bank1.setScreenTransitionState02
	call          bank1.updateGfxRegs2Scroll
	pop af
	setrombank
	ret

;;
; Called whenever entering an area with a fadein transition.
func_131f:
	xor a
	ld (wScreenOffsetY),a
	ld (wScreenOffsetX),a
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank1.initializeRoomBoundaryAndLoadAnimations
	call          bank1.setScreenTransitionState02
	call          loadTilesetAndRoomLayout

.ifdef ROM_AGES
	ld a,(wcddf)
	or a
	jr z,+

	callab tilesets.func_04_6ed1
	callab tilesets.func_04_6f31
	ld a,UNCMP_GFXH_30
	call loadUncompressedGfxHeader
	jr ++
.endif

+
	call loadRoomCollisions
	call generateVramTilesWithRoomChanges
	ld a,UNCMP_GFXH_10
	call loadUncompressedGfxHeader
++
	ld a,(wTilesetPalette)
	ld (wLoadedTilesetPalette),a
	ld a,(wTilesetUniqueGfx)
	ld (wLoadedTilesetUniqueGfx),a
	pop af
	setrombank
	ret

;;
loadTilesetAnimation:
	ld a,(wLoadedTilesetAnimation)
	ld b,a
	ld a,(wTilesetAnimation)
	cp b
	ret z
	ld (wLoadedTilesetAnimation),a
	jp loadAnimationData

;;
; Seasons-only function
; Called when displaying D4 entrance after water shuts off in screen above
func_1383:

.ifdef ROM_SEASONS
	push de
	ld (wActiveRoom),a
	ld a,b
	ld (wScreenTransitionDirection),a
	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc
	ld a,$08
	ld ($cd00),a
	ld a,$03
	ld ($cd04),a
	xor a
	ld ($cd05),a
	ld ($cd06),a
	ld a,$01
	setrombank
	call bank1.func_49c9
	call bank1.setObjectsEnabledTo2
	call loadScreenMusic
	call loadTilesetData
	ld a,(wActiveRoom)
	ld (wLoadingRoom),a
	call loadTilesetAndRoomLayout
	call loadRoomCollisions
	call generateVramTilesWithRoomChanges
	pop bc
	ld a,b
	setrombank
	ld a,c
	ld ($ff00+R_SVBK),a
	pop de
	ret

.else ; ROM_AGES
	ret
.endif

;;
; Loads w2WaveScrollValues to make the screen sway in a sine wave.
;
; @param	a	Amplitude
initWaveScrollValues:
	ldh (<hFF93),a
	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc
	ld a,:bank1.initWaveScrollValues_body
	setrombank
	ldh a,(<hFF93)
	ld c,a
	call bank1.initWaveScrollValues_body
	pop bc
	ld a,b
	setrombank
	ld a,c
	ld ($ff00+R_SVBK),a
	ret

;;
; Loads wBigBuffer with the values from w2WaveScrollValues (offset based on
; wFrameCounter). The LCD interrupt will read from there when configured properly.
;
; @param	a	Affects the frequency of the wave?
loadBigBufferScrollValues:
	ldh (<hFF93),a
	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc
	ld a,:bank1.loadBigBufferScrollValues_body
	setrombank
	ldh a,(<hFF93)
	ld b,a
	call bank1.loadBigBufferScrollValues_body
	pop bc
	ld a,b
	setrombank
	ld a,c
	ld ($ff00+R_SVBK),a
	ret

;;
; @param	bc	Pointer to palette data?
; @param	hl	Pointer to palette data?
func_13c6:
	ldh a,(<hRomBank)
	push af
	ld a,:w2ColorComponentBuffer1
	ld ($ff00+R_SVBK),a
	push de
	push bc
	ld de,w2ColorComponentBuffer1
	call extractColorComponents
	pop hl
	ld de,w2ColorComponentBuffer2
	call extractColorComponents
	pop de
	pop af
	setrombank
	xor a
	ld ($ff00+R_SVBK),a
	jp startFadeBetweenTwoPalettes

;;
; This function appears to extract the color components from $30 colors ($c palettes).
; This is probably used for palette fades.
;
; @param	de	Destination to write colors to
; @param	hl	First palette to extract from
extractColorComponents:
	ldh a,(<hRomBank)
	push af
	ld a,:paletteDataStart
	setrombank
	ld b,$30
--
	ld c,(hl)
	inc hl
	ld a,(hl)
	sla c
	rla
	rl c
	rla
	rl c
	rla
	and $1f
	ld (de),a
	inc e
	ldd a,(hl)
	rra
	rra
	and $1f
	ld (de),a
	inc e
	ldi a,(hl)
	and $1f
	ld (de),a
	inc e
	inc hl
	dec b
	jr nz,--

	pop af
	setrombank
	ret

;;
; Similar to setTile, except this won't reload the tile's graphics at vblank.
;
; This is only ever actually used by setTile itself.
;
; @param	a	Value to change tile to
; @param	c	Position of tile to change
setTileWithoutGfxReload:
	ld b,>wRoomLayout
	ld (bc),a
	call retrieveTileCollisionValue
	ld b,>wRoomCollisions
	ld (bc),a
	ret

;;
; @param	b	New index for tile
; @param	c	Position to change
setTileInRoomLayoutBuffer:
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3RoomLayoutBuffer
	ld ($ff00+R_SVBK),a
	ld a,b
	ld b,>w3RoomLayoutBuffer
	ld (bc),a
	pop af
	ld ($ff00+R_SVBK),a
	ret

;;
; Gets the type of tile at the object's position plus bc (b=y, c=x).
;
; @param	bc	Offset to add to object's position
; @param[out]	a	The tile at position bc
; @param[out]	hl	The tile's address in wRoomLayout
objectGetRelativeTile:
	ldh a,(<hActiveObjectType)
	or Object.yh
	ld l,a
	ld h,d
	ldi a,(hl)
	add b
	ld b,a
	inc l
	ldi a,(hl)
	add c
	ld c,a
	jr getTileAtPosition

;;
; Gets the tile index the object is on.
;
; @param[in]	d	Object
; @param[out]	a	The tile at the object's position
; @param[out]	hl	The tile's address in wRoomLayout
objectGetTileAtPosition:
	call objectGetPosition
;;
; @param[in]	bc	The position to check (format: YYXX)
; @param[out]	a	The tile at position bc
; @param[out]	hl	The tile's address in wRoomLayout
getTileAtPosition:
	ld a,c
	and $f0
	swap a
	ld l,a
	ld a,b
	and $f0
	or l
	ld l,a
	ld h,>wRoomLayout
	ld a,(hl)
	ret

;;
; Returns the direction of a type of tile if it's adjacent to the object, or $ff if that
; tile is not adjacent.
;
; @param	a	Tile to check for adjacency
; @param[out]	a	The direction of the tile relative to the object, or $ff.
objectGetRelativePositionOfTile:
	ldh (<hFF8B),a
	call objectGetShortPosition
	ld e,a
	ld h,>wRoomLayout

	ld a,$f0
	call @checkTileAtOffset
	ld a,DIR_UP
	ret z

	ld a,$01
	call @checkTileAtOffset
	ld a,DIR_RIGHT
	ret z

	ld a,$10
	call @checkTileAtOffset
	ld a,DIR_DOWN
	ret z

	ld a,$ff
	call @checkTileAtOffset
	ld a,DIR_LEFT
	ret z

	ld a,$ff
	ret

;;
; @param	a	Offset to add to 'e'
; @param	e	Position of object
; @param[out]	zflag	Set if the tile is at that position.
@checkTileAtOffset:
	add e
	ld l,a
	ldh a,(<hFF8B)
	cp (hl)
	ret

;;
; Seems to return 1 (zero flag unset) if the object is on a solid part of a tile. Accounts
; for quarter tiles.
;
; This will NOT work for collision values $10 and above.
;
; @param[out]	zflag	Set if there is no collision.
objectCheckSimpleCollision:
	ldh a,(<hActiveObjectType)
	or Object.yh
	ld l,a
	ld h,d

	; Load YX into bc, put shortened YX into 'l'.
	ld b,(hl)
	inc l
	inc l
	ld c,(hl)
	ld a,b
	and $f0
	ld l,a
	ld a,c
	swap a
	and $0f
	or l
	ld l,a

	ld h,>wRoomCollisions
	ld a,(hl)

	; Set zero flag based on which quarter of the tile the object is on
	bit 3,b
	jr nz,+
	rrca
	rrca
+
	bit 3,c
	jr nz,+
	rrca
+
	and $01
	ret

;;
; Get the collision value of the tile the object is on.
;
; @param[out]	a	Collision value
; @param[out]	hl	Address of collision data
; @param[out]	zflag	Set if there is no collision.
objectGetTileCollisions:
	ldh a,(<hActiveObjectType)
	or Object.yh
	ld l,a
	ld h,d

	; Load YX into bc
	ld b,(hl)
	inc l
	inc l
	ld c,(hl)

;;
; @param	bc	Position
; @param[out]	a	Collision value
; @param[out]	hl	Address of collision data
; @param[out]	zflag	Set if there is no collision.
getTileCollisionsAtPosition:
	ld a,b
	and $f0
	ld l,a
	ld a,c
	swap a
	and $0f
	or l
	ld l,a

	ld h,>wRoomCollisions
	ld a,(hl)
	or a
	ret

;;
; Checks if the object is colliding with a tile.
;
; This accounts for quarter-tiles as well as "special collisions" (collision value $10 or
; higher). Meant for link and items, as it allows passage through holes and lava (enemies
; should be prevented from doing that).
;
; @param[out]	cflag	Set on collision
objectCheckTileCollision_allowHoles:
	ldh a,(<hActiveObjectType)
	or Object.yh
	ld l,a
	ld h,d

	; Load YX into bc
	ld b,(hl)
	inc l
	inc l
	ld c,(hl)

;;
; Same as above function, but with explicit YX.
;
; @param	bc	YX position to check
checkTileCollisionAt_allowHoles:
	; Put shortened YX into 'l'
	ld a,b
	and $f0
	ld l,a
	ld a,c
	swap a
	and $0f
	or l
	ld l,a

;;
checkTileCollision_allowHoles:
	ld h,>wRoomCollisions
	ld a,(hl)

;;
; @param	a	Collision value
; @param	bc	YX position to check
checkGivenCollision_allowHoles:
	cp $10
	jr c,_simpleCollision

	ld hl,@specialCollisions
	jr _complexCollision

; See constants/specialCollisionValues.s for what each of these bytes is for.
; ie. The first defined byte is for holes.
@specialCollisions:
	.db %00000000 %11000011 %00000011 %11000000 %00000000 %11000011 %11000011 %00000000
	.db %00000000 %11000011 %00000011 %11000000 %11000000 %11000001 %11111111 %00000000

;;
; Same as above functions, but for enemies that shouldn't be allowed to cross holes or
; water tiles.
;
objectCheckTileCollision_disallowHoles:
	ldh a,(<hActiveObjectType)
	or Object.yh
	ld l,a
	ld h,d

	; Load YX into bc
	ld b,(hl)
	inc l
	inc l
	ld c,(hl)

;;
; @param	bc	YX position to check
checkTileCollisionAt_disallowHoles:
	; Put shortened YX into 'l'
	ld a,b
	and $f0
	ld l,a
	ld a,c
	swap a
	and $0f
	or l
	ld l,a

;;
checkTileCollision_disallowHoles:
	ld h,>wRoomCollisions
	ld a,(hl)

;;
; @param	a	Collision value
checkGivenCollision_disallowHoles:
	cp $10
	jr c,_simpleCollision
	ld hl,@specialCollisions
	jr _complexCollision

@specialCollisions:
	.db %11111111 %11000011 %00000011 %11000000 %00000000 %11000011 %11000011 %00000000
	.db %00000000 %11000011 %00000011 %11000000 %11000001 %11000001 %11111111 %11111111

;;
; @param	bc	Full position to check
; @param	l	Shortened position (where the tile is)
checkCollisionPosition_disallowSmallBridges:
	ld h,>wRoomCollisions
	ld a,(hl)
	cp $10
	jr c,_simpleCollision
	ld hl,@specialCollisions
	jr _complexCollision

@specialCollisions:
	.db %00000000 %11111111 %00000011 %11000000 %11000011 %11000011 %11000011 %00000000
	.db %00000000 %11111111 %00000011 %11000000 %11000001 %11000001 %11111111 %00000000

; Sets carry flag if the object is not in a wall?
_simpleCollision:
	bit 3,b
	jr nz,+
	rrca
	rrca
+
	bit 3,c
	jr nz,+
	rrca
+
	rrca
	ret

; @param	bc	Position
; @param	hl
; @param[out]	cflag	Set on collision?
; @param[out]	zflag	Unset on collision?
_complexCollision:
	push de
	and $0f
	ld e,a
	ld d,$00

	add hl,de
	ld e,(hl)
	cp $08
	ld a,b
	jr nc,+
	ld a,c
+
	rrca
	and $07
	ld hl,bitTable
	add l
	ld l,a
	ld a,(hl)
	and e
	pop de
	ret z
	scf
	ret

;;
; Get tile collision value from buffer in bank 3, not wRoomCollisions
retrieveTileCollisionValue:
	ld h,>w3TileCollisions
	ld l,a
	ld a,:w3TileCollisions
	ld ($ff00+R_SVBK),a
	ld l,(hl)
	xor a
	ld ($ff00+R_SVBK),a
	ld a,l
	ret

;;
; Load data into wRoomCollisions based on wRoomLayout and w3TileCollisions
loadRoomCollisions:
	ld a,:w3TileCollisions
	ld ($ff00+R_SVBK),a
	ld d,>w3TileCollisions
	ld hl,wRoomLayout
	ld b,LARGE_ROOM_HEIGHT*$10
-
	ld a,(hl)
	ld e,a
	ld a,(de)
	dec h
	ldi (hl),a
	inc h
	dec b
	jr nz,-

	call @blankDataAroundCollisions
	xor a
	ld ($ff00+R_SVBK),a
	ret

;;
; Blanks data around the "edges" of wRoomCollisions.
@blankDataAroundCollisions:
	ld hl, wRoomCollisions+$f0
	call @blankDataHorizontally
	ld hl, wRoomCollisions+$0f
	call @blankDataVertically
	ld a,(wActiveGroup)
	cp NUM_SMALL_GROUPS
	jr c,+
	ld l,LARGE_ROOM_HEIGHT*$10
	jr @blankDataHorizontally
+
	ld l,SMALL_ROOM_HEIGHT*$10
	call @blankDataHorizontally
	ld l,SMALL_ROOM_WIDTH
	jr @blankDataVertically

@blankDataHorizontally:
	ld a,$ff
	ld b,$10
-
	ldi (hl),a
	dec b
	jr nz,-
	ret

@blankDataVertically:
	ld b,LARGE_ROOM_HEIGHT
	ld c,$ff
-
	ld (hl),c
	ld a,l
	add $10
	ld l,a
	dec b
	jr nz,-
	ret

;;
; @param	a	Tile to find in the room
; @param[out]	hl	Address of the tile in wRoomLayout (if it was found)
; @param[out]	zflag	z if the tile was found.
findTileInRoom:
	ld h,>wRoomLayout
	ld l,LARGE_ROOM_HEIGHT*$10+$0f

;;
; @param	a	Value to search for
; @param	hl	Address to start the search at (end when 'l' reaches 0)
; @param[out]	hl	Address of the value (if it was found)
; @param[out]	zflag	z if the value was found.
backwardsSearch:
	cp (hl)
	ret z
	dec l
	jr nz,backwardsSearch

	cp (hl)
	ret

;;
; Gets the collision data for the tile at c based on w3RoomLayoutBuffer (so, the original
; room layout?)
;
; @param[in]	a	Position of tile
; @param[out]	a	Tile value from w3RoomLayoutBuffer
; @param[out]	b	The tile's collision value
; @param[out]	c	Position of tile (passed in as A)
; @param[out]	cflag	Set carry flag if the tile's collision value is between $1 and $f
;			(at least partially solid)
getTileIndexFromRoomLayoutBuffer:
	ld c,a

;;
getTileIndexFromRoomLayoutBuffer_paramC:
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3RoomLayoutBuffer
	ld ($ff00+R_SVBK),a
	ld b,>w3RoomLayoutBuffer
	ld a,(bc)
	ld e,a
	ld a,:w3TileCollisions
	ld ($ff00+R_SVBK),a
	ld l,e
	ld h,>w3TileCollisions
	ld b,(hl)
	pop af
	ld ($ff00+R_SVBK),a
	ld a,b
	cp $10
	jr nc,++

	or a
	jr z,++

	scf
	ld a,e
	ret
++
	ld a,e
	ret

;;
; Load an interaction's graphics and initialize the animation.
; @param[out] c
interactionInitGraphics:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3f.interactionLoadGraphics
	ld c,a
	pop af
	setrombank
	ld a,c
	jp interactionSetAnimation

;;
func_1613:
	ld a,(wLoadedTreeGfxIndex)
	or a
	ret z
;;
refreshObjectGfx:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3f.refreshObjectGfx_body
	xor a
	ld (wLoadedTreeGfxIndex),a
	pop af
	setrombank
	ret

;;
reloadObjectGfx:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3f.reloadObjectGfx
	pop af
	setrombank
	ret

;;
; Forces an object gfx header to be loaded into slot 4 (address 0:8800). Handy way to load
; extra graphics, but uses up object slots. Used by the pirate ship and various things in
; seasons, but apparently unused in ages.
;
; @param	e	Object gfx header (minus 1)
loadObjectGfxHeaderToSlot4:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3f.loadObjectGfxHeaderToSlot4_body
	pop af
	setrombank
	ret

;;
; @param	a	Tree gfx index
loadTreeGfx:
	ld e,a
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3f.loadTreeGfx_body
	pop af
	setrombank
	ret

;;
; @param	a	Uncompressed gfx header to load
loadWeaponGfx:
	ld e,a
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3f.loadWeaponGfx
	pop af
	setrombank
	ret

;;
; Loads $20 tiles of gfx data from the 3-byte pointer at hl.
; Ultimate gfx destination is (b<<8).
; Uses DMA, and buffers at 4:dc00 and 4:de00, for safe transfers.
;
; @param	b	High byte of destination to write gfx to (low byte is $00)
; @param	hl	Address to read from to get the index to load
loadObjectGfx:
	ld d,b
	ld e,$00
	ldi a,(hl)
;;
; @param a
; @param de
; @param hl
loadObjectGfx2:
	ld c,a
	ldi a,(hl)
	ld l,(hl)
	and $7f
	ld h,a

.ifdef ROM_AGES
	ld a,($cc20)
	or a
	jr nz,@label_00_192
.endif

	push de
	ld a,(wcc07)
	xor $ff
	ld (wcc07),a
	ld de,w4GfxBuf1 | (:w4GfxBuf1)
	jr nz,+
	ld de,w4GfxBuf2 | (:w4GfxBuf2)
+
	push de
	ld b,$1f
	call decompressGraphics
	pop hl
	pop de
	ld c,:w4GfxBuf1
	ld a,$01
	ld ($ff00+R_SVBK),a
	ld a,$3f
	setrombank
	ld b,$1f
	jp queueDmaTransfer

.ifdef ROM_AGES

@label_00_192:
	ld a,d
	or $d0
	ld d,a
	ld a,$05
	add e
	ld e,a
	ld b,$1f
	call decompressGraphics
	ld a,$01
	ld ($ff00+R_SVBK),a
	ld a,$3f
	setrombank
	ret
.endif

;;
; Load graphics for an item (as in, items on the inventory screen)
;
; @param a Item index
loadTreasureDisplayData:
	ld l,a
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3f.loadTreasureDisplayData
	pop af
	setrombank
	ret

;;
; @param	a
; @param[out]	a,c	Subid for PARTID_ITEM_DROP (see constants/itemDrops.s)
; @param[out]	zflag	z if there is no item drop
decideItemDrop:
	ld c,a
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3f.decideItemDrop_body
	pop af
	setrombank
	ld a,c
	cp $ff
	ret

;;
; Checks whether an item drop of a given type can spawn.
;
; @param	a	Item drop index (see constants/itemDrops.s)
; @param[out]	zflag	z if item cannot spawn (Link doesn't have it)
checkItemDropAvailable:
	ld c,a
	ldh a,(<hRomBank)
	push af
	ld a,:bank3f.checkItemDropAvailable_body
	setrombank
	ld a,c
	call bank3f.checkItemDropAvailable_body
	pop af
	setrombank
	ld a,c
	cp $ff
	ret

;;
; @param	a	Treasure for Link to obtain (see constants/treasure.s)
; @param	c	Parameter (ie. item level, ring index, etc...)
; @param[out]	a	Sound to play on obtaining the treasure (if nonzero)
giveTreasure:
	ld b,a
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3f.giveTreasure_body
	pop af
	setrombank
	ld a,b
	or a
	ret

;;
; @param	a	Treasure for Link to lose (see constants/treasure.s)
loseTreasure:
	ld b,a
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3f.loseTreasure_body
	pop af
	setrombank
	ret

;;
; @param	a	Item to check for (see constants/treasure.s)
; @param[out]	cflag	Set if you have that item
; @param[out]	a	The value of the treasure's "related variable" (ie. item level)
checkTreasureObtained:
	push hl
	ld l,a
	or a
	jr z,++

	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3f.checkTreasureObtained_body
	pop af
	setrombank
	ld a,l
	srl h
++
	pop hl
	ret


.ifdef ROM_SEASONS
;;
; Same as below but for ore chunks.
cpOreChunkValue:
	ld hl,wNumOreChunks
	jr ++
.endif

;;
; Compares the current total rupee count with a value from the "getRupee" function.
;
; @param	a	Rupee type to compare with
; @param[out]	a	0 if Link has at least that many rupees, 1 otherwise
; @param[out]	zflag	Set if Link has that many rupees
cpRupeeValue:
	ld hl,wNumRupees
++
	call getRupeeValue
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call compareHlToBc
	inc a
	jr nz,+

	inc a
	ret
+
	xor a
	ret


.ifdef ROM_SEASONS
;;
removeOreChunkValue:
	ld hl,wNumOreChunks
	jr ++
.endif

;;
; Remove the value of a kind of rupee from your wallet.
;
; @param	a	The type of rupee to lose (not the value)
removeRupeeValue:
	ld hl,wNumRupees
++
	call getRupeeValue
	jp subDecimalFromHlRef

;;
; @param	a	The "type" of rupee you're getting.
; @param[out]	bc	The amount of rupees you get from it
getRupeeValue:
	push hl
	cp RUPEEVAL_COUNT-1
	jr c,+
	ld a,RUPEEVAL_COUNT-1
+
	ld hl,@rupeeValues
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	pop hl
	ret

; Each number here corresponds to a value in constants/rupeeValues.s.
@rupeeValues:
	.dw $0000 ; $00
	.dw $0001 ; $01
	.dw $0002 ; $02
	.dw $0005 ; $03
	.dw $0010 ; $04
	.dw $0020 ; $05
	.dw $0040 ; $06
	.dw $0030 ; $07
	.dw $0060 ; $08
	.dw $0070 ; $09
	.dw $0025 ; $0a
	.dw $0050 ; $0b
	.dw $0100 ; $0c
	.dw $0200 ; $0d
	.dw $0400 ; $0e
	.dw $0150 ; $0f
	.dw $0300 ; $10
	.dw $0500 ; $11
	.dw $0900 ; $12
	.dw $0080 ; $13
	.dw $0999 ; $14

;;
; @param	a	Seed type to decrement
decNumActiveSeeds:
	and $07
	ld hl,wNumEmberSeeds
	rst_addAToHl
	jr +

;;
decNumBombchus:
	ld hl,wNumBombchus
	jr +

;;
decNumBombs:
	ld hl,wNumBombs
+
	ld a,(hl)
	or a
	ret z

	call setStatusBarNeedsRefreshBit1
	ld a,(hl)
	sub $01
	daa
	ld (hl),a
	or h
	ret

;;
setStatusBarNeedsRefreshBit1:
	push hl
	ld hl,wStatusBarNeedsRefresh
	set 1,(hl)
	pop hl
	ret

;;
; Gets a random ring of the given tier ('c').
;
; The tier numbers are a bit different than in TourianTourist's guide (tiers 0-3 / 1-4 are
; reversed).
;
; @param	c	Ring tier
; @param[out]	a	TREASURE_RING (to be passed to "giveTreasure")
; @param[out]	c	Randomly chosen ring from the given tier (to be passed to
;			"giveTreasure")
getRandomRingOfGivenTier:
	ldh a,(<hRomBank)
	push af
	ld a,:bank3f.ringTierTable
	setrombank

	ld b,$01
	ld a,c
	cp $04
	jr z,+
	ld b,$07
+
	ld hl,bank3f.ringTierTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	call getRandomNumber
	and b
	ld c,a
	ld b,$00
	add hl,bc
	ld c,(hl)

	pop af
	setrombank

	ld a,TREASURE_RING
	ret

;;
; Fills the seed satchel with all seed types that Link currently has.
refillSeedSatchel:
	ld e,TREASURE_EMBER_SEEDS
--
	ld a,e
	call checkTreasureObtained
	jr nc,+

	ld a,e
	ld c,$99
	call giveTreasure
+
	inc e
	ld a,e
	cp TREASURE_MYSTERY_SEEDS+1
	jr c,--
	ret

;;
; @param	a	Amount to add to wGashaMaturity
addToGashaMaturity:
	push hl
	ld hl,wGashaMaturity
	add (hl)
	ldi (hl),a
	jr nc,+

	inc (hl)
	jr nz,+

	ld a,$ff
	ldd (hl),a
	ld (hl),a
+
	pop hl
	ret

;;
makeActiveObjectFollowLink:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank1.makeActiveObjectFollowLink
	pop af
	setrombank
	ret

;;
clearFollowingLinkObject:
	ld hl,wFollowingLinkObjectType
	xor a
	ldi (hl),a
	ld (hl),a
	ret

;;
stopTextThread:
	xor a
	ld (wTextIsActive),a
	ld (wTextboxFlags),a
	ld a,THREAD_2
	jp threadStop

;;
retIfTextIsActive:
	ld a,(wTextIsActive)
	or a
	ret z
	pop af
	ret

;;
showTextOnInventoryMenu:
	ld a,(wTextboxFlags)
	set TEXTBOXFLAG_BIT_NOCOLORS,a
	ld (wTextboxFlags),a
	ld l,$00
	ld e,$02
	jr _label_00_204

;;
; Displays text index bc while not being able to exit the textbox with button presses
showTextNonExitable:
	ld l,TEXTBOXFLAG_NONEXITABLE
	jr _label_00_203

;;
; Displays text index bc
showText:
	ld l,$00
_label_00_203:
	ld e,$00
_label_00_204:
	ld a,(wTextboxFlags)
	or l
	ld (wTextboxFlags),a
	ld a,b
	add $04
	ld b,a

	ld hl,wTextDisplayMode
	ld (hl),e
	inc l
	ld (hl),c
	inc l
	ld a,b
	ldi (hl),a

	; wTextIndexH_backup
	ldi (hl),a

	; wSelectedTextOption
	ld (hl),$ff
	inc l

	; wTextGfxColorIndex
	ld (hl),$02
	inc l

	; wTextMapAddress
	ld (hl),$98

	ld a,$01
	ld (wTextIsActive),a

	ld bc,textThreadStart
	ld a,THREAD_2
	jp threadRestart

;;
textThreadStart:
	ld a,(wScrollMode)
	or a
	jr z,@showText

	and $01
	jr nz,@showText

@dontShowText:
	xor a
	ld (wTextIsActive),a
	ld (wTextboxFlags),a
	jp stubThreadStart

@showText:
	callfrombank0 bank3f.initTextbox
-
	callfrombank0 bank3f.updateTextbox
	call resumeThreadNextFrame
	jr -

;;
; Can only be called from bank $3f. See also "copyTextCharacterGfx" which is similar but is used by
; file select code instead of textbox code.
;
; @param	[w7TextGfxSource]	Table to use
; @param	a			Character
; @param	bc			Address to write data to
retrieveTextCharacter:
	push hl
	push de
	push bc
	call multiplyABy16
	ld a,(w7TextGfxSource)
	ld hl,@data
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc
	pop bc
	ld a,:gfx_font
	setrombank
	call @func_18fd

	ld a,BANK_3f
	setrombank

	xor a
	ld (w7TextGfxSource),a
	pop de
	pop hl
	ret

@data:
	.dw gfx_font_start
	.dw gfx_font_jp
	.dw gfx_font_tradeitems

;;
; @param bc
; @param hl
@func_18fd:
	ld e,$10

	; gfx_font_start+$140 is the heart character. It's always red.
	ld a,h
	cp >(gfx_font_start+$140)
	jr nz,@notHeart

	ld a,l
	cp <(gfx_font_start+$140)
	jr z,@color1

@notHeart:
	ld a,(wTextGfxColorIndex)
	and $0f

	or a
	jr z,@color0

	dec a
	jr z,@color1

	dec a
	jr z,@color2

	; If [wTextGfxColorIndex] == 3, read the tile as 2bpp.
@2bpp:
	ld e,$20
-
	ldi a,(hl)
	ld (bc),a
	inc bc
	dec e
	jr nz,-

	ld a,(wTextGfxColorIndex)
	and $f0
	swap a
	ld (wTextGfxColorIndex),a
	ret
@color0:
	ldi a,(hl)
	ld (bc),a
	inc c
	ld (bc),a
	inc bc
	dec e
	jr nz,@color0
	ret
@color1:
	ld a,$ff
	ld (bc),a
	inc c
	ldi a,(hl)
	ld (bc),a
	inc bc
	dec e
	jr nz,@color1
	ret
@color2:
	ldi a,(hl)
	ld (bc),a
	inc c
	ld a,$ff
	ld (bc),a
	inc bc
	dec e
	jr nz,@color2
	ret

;;
; Can only be called from bank $3f. Also assumes RAM bank 7 is loaded.
readByteFromW7ActiveBank:
	push bc
	ld a,(w7ActiveBank)
	setrombank
	ld b,(hl)

	ld a,BANK_3f
	setrombank

	ld a,b
	pop bc
	ret

;;
; Assumes RAM bank 7 is loaded.
readByteFromW7TextTableBank:
	ldh a,(<hRomBank)
	push af

.ifdef REGION_JP
	ld a,:textTableENG
.else
	ld a,(w7TextTableBank)
.endif

	bit 7,h
	jr z,+

	res 7,h
	set 6,h
	inc a
+
	setrombank
	ldi a,(hl)
	ldh (<hFF8B),a

	pop af
	setrombank
	ldh a,(<hFF8B)
	ret

;;
getThisRoomFlags:
	ld a,(wActiveRoom)
getARoomFlags:
	push bc
	ld b,a
	ld a,(wActiveGroup)
	call getRoomFlags
	pop bc
	ret

;;
; @param	a	Group
; @param	b	Room
; @param[out]	a	Room flags
; @param[out]	hl	Address of room flags
getRoomFlags:
	ld hl, flagLocationGroupTable
	rst_addAToHl
	ld h,(hl)
	ld l,b
	ld a,(hl)
	ret

;;
; @param[out]	zflag	z if unlinked
checkIsLinkedGame:
	ld a,(wIsLinkedGame)
	or a
	ret

;;
; @param	hl	Where to copy the values from for wWarpDestVariables
setWarpDestVariables:
	push de
	ld de,wWarpDestVariables
	ld b,$05
	call copyMemory
	pop de
	ret

;;
setInstrumentsDisabledCounterAndScrollMode:
	ld a,$08
	ld (wInstrumentsDisabledCounter),a
	ld a,$01
	ld (wScrollMode),a
	ret

;;
; Clears all physical item objects (not parent items) and clears midair-related variables.
clearAllItemsAndPutLinkOnGround:
	push de
	call clearAllParentItems
	call dropLinkHeldItem

	xor a
	ld (wIsSeedShooterInUse),a

	ldde FIRST_ITEM_INDEX, Item.start

@nextItem:
	ld h,d

.ifdef ROM_AGES
	ld l,Item.id
	ld a,(hl)
	cp ITEMID_18
	jr nz,@notSomariaBlock

; Somaria block creation

	ld l,Item.var2f
	set 5,(hl)
	set 4,(hl)
	ld l,Item.visible
	res 7,(hl)
	jr ++
.endif

@notSomariaBlock:
	ld l,e
	ld b,$40
	call clearMemory
++
	inc d
	ld a,d
	cp LAST_ITEM_INDEX+1
	jr c,@nextItem

	pop de
	jp putLinkOnGround

;;
; See also "retrieveTextCharacter" which is similar.
;
; @param	a			Character index
; @param	c			0 to use jp font, 1 to use english font
; @param	de			Where to write the character to
; @param	wFileSelect.fontXor	Value to xor every other byte with
copyTextCharacterGfx:
	push hl
	push bc
	ld hl,gfx_font_jp
	bit 0,c
	jr nz,+

	ld hl,gfx_font_start

	; Characters below $0e don't exist (or at least don't represent normal characters)
	cp $0e
	jr nc,+
	ld a,$20
+
	call multiplyABy16
	add hl,bc
	ldh a,(<hRomBank)
	push af
	ld a,:gfx_font
	setrombank
	ld a,(wFileSelect.fontXor)
	ld c,a
	ld b,$10
-
	ldi a,(hl)
	xor c
	ld (de),a
	inc de
	ld (de),a
	inc de
	dec b
	jr nz,-

	pop af
	setrombank
	pop bc
	pop hl
	ret

;;
fileSelectThreadStart:
	ld hl,wTmpcbb3
	ld b,$10
	call clearMemory
-
	callfrombank0 bank2.b2_fileSelectScreen
	call resumeThreadNextFrame
	jr -

;;
; Calls a secret-related function based on parameter 'b' (see also the enum below):
;
; 0: Generate a secret
; 1: Unpack a secret in ascii form (input and output are both in wTmpcec0)
; 2: Verify that the gameID of an unpacked secret is valid
; 3: Generate a gameID for the current file
; 4: Loads the data associated with an unpacked secret (ie. for game-transfer secret, this
;    loads the player name, animal companion, etc. from the secret data).
;
; @param	b	Index of function to call
; @param	c	Secret type (in most cases)
; @param[out]	zflag	Generally set on success
secretFunctionCaller:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3.secretFunctionCaller_body
	pop af
	setrombank
	ld a,b
	or a
	ret

.enum 0
	SECRETFUNC_GENERATE_SECRET	db ; 0
	SECRETFUNC_UNPACK_SECRET	db ; 1
	SECRETFUNC_VERIFY_SECRET_GAMEID	db ; 2
	SECRETFUNC_GENERATE_GAMEID	db ; 3
	SECRETFUNC_LOAD_UNPACKED_SECRET	db ; 4
.ende


;;
; Opens a secret input menu.
;
; @param	a	Secret type (0 = 20-char, 2 = 15-char, $80-$ff = 5-char?)
openSecretInputMenu:
	ld (wSecretInputType),a
	ld a,$01
	ld (wTextInputResult),a
	ld a,$06
	jp openMenu

;;
; @param[out]	zflag	Set if no menu is being displayed.
updateMenus:
	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc
	callfrombank0 bank2.b2_updateMenus
	pop bc
	ld a,b
	setrombank
	ld a,c
	ld ($ff00+R_SVBK),a
	ld a,(wOpenedMenuType)
	or a
	ret

;;
; If wStatusBarNeedsRefresh is nonzero, this function dma's the status bar graphics to
; vram. It also reloads the item icon's graphics, if bit 0 is set.
checkReloadStatusBarGraphics:
	ld hl,wStatusBarNeedsRefresh
	ld a,(hl)
	or a
	ret z

	ld (hl),$00

	; If bit 0 is unset, just reload the status bar (w4StatusBarTileMap and
	; w4StatusBarAttributeMap); if bit 0 is set, also reload the item graphics
	; (w4ItemIconGfx).
	rrca
	ld a,UNCMP_GFXH_02
	jr c,+
	ld a,UNCMP_GFXH_03
+
	jp loadUncompressedGfxHeader

;;
; Copy $20 bytes from bank b at hl to de.
;
; @param	b	Bank
; @param	de	Destination
; @param	hl	Source
copy20BytesFromBank:
	ldh a,(<hRomBank)
	push af
	ld a,b
	setrombank
	ld b,$20
	call copyMemory
	pop af
	setrombank
	ret

;;
loadCommonGraphics:
	ld h,$00
	jr +++

;;
; Jumps to bank2._updateStatusBar.
updateStatusBar:
	ld h,$01
	jr +++

;;
hideStatusBar:
	ld h,$02
	jr +++

;;
showStatusBar:
	ld h,$03
	jr +++

;;
saveGraphicsOnEnterMenu:
	ld h,$04
	jr +++

;;
reloadGraphicsOnExitMenu:
	ld h,$05
	jr +++

;;
; @param	a	Type of menu to open (see wOpenedMenuType in wram.s)
openMenu:
	ld h,$06
	jr +++

;;
copyW2TilesetBgPalettesToW4PaletteData:
	ld h,$07
	jr +++

;;
copyW4PaletteDataToW2TilesetBgPalettes:
	ld h,$08
+++
	ld l,a
	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc
	callfrombank0 bank2.runBank2Function
	pop bc
	ld a,b
	setrombank
	ld a,c
	ld ($ff00+R_SVBK),a
	ret

;;
; @param[in]	b	Room
; @param[out]	b	Dungeon property byte for the given room (see
;			constants/dungeonRoomProperties.s)
getRoomDungeonProperties:
	ldh a,(<hRomBank)
	push af
	ld a, :bank1.dungeonRoomPropertiesGroupTable
	setrombank
	ld a,(wActiveGroup)
	and $01
	ld hl, bank1.dungeonRoomPropertiesGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,b
	rst_addAToHl
	ld b,(hl)
	pop af
	setrombank
	ret

;;
copy8BytesFromRingMapToCec0:
	ldh a,(<hRomBank)
	push af
	ld a,:map_rings
	setrombank
	ld de,wTmpcec0
	ld b,$08
	call copyMemory
	pop af
	setrombank
	ret

;;
; Runs game over screen?
thread_1b10:
	ld hl,wTmpcbb3
	ld b,$10
	call clearMemory
	ld a,$01
	ld (wTmpcbb4),a
-
	callfrombank0 bank2.runSaveAndQuitMenu
	call resumeThreadNextFrame
	jr -

;;
; Calling this function allows an interaction to use the "checkabutton" command.
;
; @param	de	Variable to write $01 to when A button is pressed next to object
objectAddToAButtonSensitiveObjectList:
	xor a
	ld (de),a
	ld hl,wAButtonSensitiveObjectList
@next:
	ldi a,(hl)
	or (hl)
	jr z,@foundBlankEntry

	inc l
	ld a,l
	cp <wAButtonSensitiveObjectListEnd
	jr c,@next
	ret
@foundBlankEntry:
	ld a,e
	ldd (hl),a
	ld (hl),d
	scf
	ret

;;
objectRemoveFromAButtonSensitiveObjectList:
	push de
	ld a,e
	and $c0
	ld e,a
	ld hl,wAButtonSensitiveObjectList
---
	ldi a,(hl)
	cp d
	jr nz,@next

	ld a,(hl)
	and $c0
	sub e
	jr nz,@next

	ldd (hl),a
	ldi (hl),a
@next:
	inc l
	ld a,l
	cp <wAButtonSensitiveObjectListEnd
	jr c,---

	pop de
	ret

;;
; Checks everything in wAButtonSensitiveObjectList (npcs mostly) and triggers them if the
; A button has been pressed near them.
;
; @param[out]	cflag	Set if Link just pressed A next to the object
linkInteractWithAButtonSensitiveObjects:
	ld a,(wGameKeysJustPressed)
	and BTN_A
	ret z

	; If he's in a shop, he can interact while holding something
	ld a,(wInShop)
	or a
	jr nz,+

	; If he's not in a shop, this should return if he's holding something
	ld a,(wLinkGrabState)
	or a
	ret nz
+
	push de
	ld e,SpecialObject.direction
	ld a,(de)
	ld hl,@positionOffsets
	rst_addDoubleIndex

	; Store y + offset into [hFF8D]
	ld e,SpecialObject.yh
	ld a,(de)
	add (hl)
	ldh (<hFF8D),a

	; Store x + offset into [hFF8C]
	inc hl
	ld e,SpecialObject.xh
	ld a,(de)
	add (hl)
	ldh (<hFF8C),a

	; Check all objects in the list
	ld de,wAButtonSensitiveObjectList
---
	; Get the object in hl
	ld a,(de)
	ld h,a
	inc e
	ld a,(de)
	ld l,a
	or h
	jr z,+

	; Check if link is directly in front of the object
	push hl
	ldh a,(<hFF8D)
	ld b,a
	ldh a,(<hFF8C)
	ld c,a
	call objectHCheckContainsPoint
	pop hl
	jr nc,+

	; Link is next to the object; only trigger it if the "pressedAButton" variable is
	; not already set.
	bit 0,(hl)
	jr z,@foundObject
+
	inc e
	ld a,e
	cp <wAButtonSensitiveObjectListEnd
	jr c,---

	; No object found
	pop de
	ret

@foundObject:
	; Set the object's "pressedAButton" variable.
	set 0,(hl)

	; For some reason, set Link's invincibility whenever triggering an object?
	ld hl,w1Link.invincibilityCounter
	ld a,(hl)
	or a
	ld a,$fc
	jr z,++

	bit 7,(hl)
	jr nz,@negativeValue

	; Link's invincibility already has a positive value ($01-$7f), meaning he's
	; flashing red from damage.
	; Make sure he stays invincible for at least 4 more frames?
	ld a,$04
	cp (hl)
	jr c,@doneWithInvincibility
	jr ++

	; Negative value for invincibility means he isn't flashing red.
	; Again, this makes sure he stays invincible for at least 4 more frames.
@negativeValue:
	cp (hl)
	jr nc,@doneWithInvincibility
++
	ld (hl),a

@doneWithInvincibility:
	; Disable ring transformations for 8 frames? (He can't normally interact with
	; objects while transformed... so what's the point of this?)
	ld a,$08
	ld (wDisableRingTransformations),a

	; Disable pushing animation
	ld a,$80
	ld (wForceLinkPushAnimation),a

	ld hl,wLinkTurningDisabled
	set 7,(hl)

	scf
	pop de
	ret

@positionOffsets:
	.db $f6 $00 ; DIR_UP
	.db $00 $0a ; DIR_RIGHT
	.db $0a $00 ; DIR_DOWN
	.db $00 $f6 ; DIR_LEFT

;;
objectCheckContainsPoint:
	ld h,d
	ldh a,(<hActiveObjectType)
	ld l,a
	jr objectHCheckContainsPoint

;;
interactionCheckContainsPoint:
	ld h,d
	ld l,Interaction.start

;;
; Checks if an object contains a given point.
;
; @param	bc	Point to check
; @param	hl	The object to check (not object d as usual)
; @param[out]	cflag	Set if the point is contained in the object's collision box.
objectHCheckContainsPoint:
	ld a,l
	and $c0
	add Object.yh
	ld l,a
	ldi a,(hl)
	sub b
	jr nc,+
	cpl
	inc a
+
	ld b,a

	inc l
	ld a,(hl)
	sub c
	jr nc,+
	cpl
	inc a
+
	ld c,a

	ld a,l
	add Object.collisionRadiusY-Object.xh
	ld l,a

	ld a,b
	sub (hl)
	ret nc
	inc l
	ld a,c
	sub (hl)
	ret

;;
; Check if 2 objects have collided.
;
; @param	bc	YX position of object 1
; @param	de	Address of object 1's collisionRadiusY variable
; @param	hl	Address of object 2's collisionRadiusY variable
; @param	ff8e	X position object 2
; @param	ff8f	Y position object 2
; @param[out]	cflag	Set if collision, unset if no collision
checkObjectsCollidedFromVariables:
	ld a,b
	ldh (<hFF8D),a
	ld a,c
	ldh (<hFF8C),a
	ld a,(de)
	add (hl)
	ld b,a
	ldh a,(<hFF8F)
	ld c,a
	ldh a,(<hFF8D)
	sub c
	add b
	sla b
	cp b
	ret nc

	inc e
	inc hl
	ld a,(de)
	add (hl)
	ld b,a
	ldh a,(<hFF8E)
	ld c,a
	ldh a,(<hFF8C)
	sub c
	add b
	sla b
	cp b
	ret

;;
objectCheckCollidedWithLink_notDeadAndNotGrabbing:
	ld a,(wLinkGrabState)
	and $be
	ret nz
;;
objectCheckCollidedWithLink_notDead:
	ld a,(wLinkDeathTrigger)
	or a
	ret nz
	jr objectCheckCollidedWithLink

;;
objectCheckCollidedWithLink_onGround:
	ld a,(wLinkInAir)
	or a
	ret nz
	ld a,(w1Link.zh)
	or a
	ret nz
	jr objectCheckCollidedWithLink_notDead

;;
; @param[out]	cflag	Set if the object is touching Link.
objectCheckCollidedWithLink:
	ldh a,(<hActiveObjectType)
	add Object.zh
	ld l,a
	ld h,d

;;
; @param	hl	Address of an object's zh variable
_checkCollidedWithLink:
	ld a,(wLinkObjectIndex)
	ld b,a

	; Check if the object is within 7 z-units of link
	ld c,Object.zh
	ld a,(bc)
	sub (hl)
	add $07
	cp $0e
	ret nc

	; Set l to Object.xh
	dec l
	dec l
---
	ldd a,(hl)
	ldh (<hFF8E),a
	dec l
	ld a,(hl)
	ldh (<hFF8F),a
	ld a,l
	add $1b
	ld e,a
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,<w1Link.yh
	ld b,(hl)
	ld l,<w1Link.xh
	ld c,(hl)
	ld l,<w1Link.collisionRadiusY
	jr checkObjectsCollidedFromVariables

;;
; @param[out]	cflag	Set if the object is touching Link.
objectCheckCollidedWithLink_ignoreZ:
	ldh a,(<hActiveObjectType)
	add Object.xh
	ld l,a
	ld h,d
	jr ---

;;
; Unused?
hObjectCheckCollidedWithLink:
	push de
	ld d,h
	ld a,l
	and $c0
	add Object.zh
	ld l,a
	call _checkCollidedWithLink
	pop de
	ret

;;
; Unused?
func_1c84:
	ld a,(w1ReservedItemC.enabled)
	or a
	ret nz

;;
; @param[out]	cflag	Set on collision
objectHCheckCollisionWithLink:
	push de
	push hl
	call _getLinkPositionPlusDirectionOffset
	pop hl
	ld a,l
	and $c0
	call _checkCollisionWithHAndD
	pop de
	ret

;;
; Checks whether link is close enough to a grabbable object to grab it.
; If so, this also sets a few of the object's variables.
; This function is only called after the A button is pressed.
;
; @param	d	Link object?
; @param[out]	cflag	Set on collision
checkGrabbableObjects:
	; Check that something isn't already being carried around
	ld a,(w1ReservedItemC.enabled)
	or a
	ret nz

	push de

	; This call sets up hFF8E and hFF8F for collision function calls
	call _getLinkPositionPlusDirectionOffset

	ld hl,wGrabbableObjectBuffer

@objectLoop:
	inc l
	bit 7,(hl)
	jr z,@nextObject

	push hl
	dec l
	ldi a,(hl)
	ld h,(hl)
	call _checkCollisionWithHAndD
	jr c,@collision
	pop hl
@nextObject:
	inc l
	ld a,l
	cp <wGrabbableObjectBufferEnd
	jr c,@objectLoop

	pop de
	xor a
	ret

	; At this point, hl = the shop object that is grabbed
@collision:
	pop af

	ld e,Item.relatedObj2+1
	ld a,h
	ld (de),a
	dec e
	ld a,l
	and $c0
	ld (de),a

	; l = Object.enabled
	ld l,a
	set 1,(hl)

	; l = Object.state
	add Object.state-Object.enabled
	ld l,a
	ld (hl),ENEMYSTATE_GRABBED ; TODO: Better name? it's not just for enemies

	; l = Object.substate
	inc l
	ld (hl),$00

	pop de
	scf
	ret

;;
; Gets link's position plus 5 pixels in the direction he's facing.
;
; @param[out]	hFF8E	Link X
; @param[out]	hFF8F	Link Y
; @param[out]	hFF91	Link Z (subtracted by 3)
_getLinkPositionPlusDirectionOffset:
	ld a,(w1Link.direction)
	ld hl,@positionOffsets
	rst_addDoubleIndex
	ld de,w1Link.yh
	ld a,(de)
	add (hl)
	ldh (<hFF8F),a
	inc hl
	ld e,<w1Link.xh
	ld a,(de)
	add (hl)
	ldh (<hFF8E),a
	ld e,<w1Link.zh
	ld a,(de)
	sub $03
	ldh (<hFF91),a
	ret

@positionOffsets:
	.dw $00fa ; DIR_UP
	.dw $0500 ; DIR_RIGHT
	.dw $0005 ; DIR_DOWN
	.dw $fa00 ; DIR_LEFT

;;
; @param	a	Object.start variable for object h
; @param	d	Link/Item object
; @param	h	Any object
; @param	[hFF8E]	Object d's x position
; @param	[hFF8F]	Object d's y position
; @param[out]	cflag	Set if collision, unset if no collision
_checkCollisionWithHAndD:
	add Object.var2a
	ld l,a
	bit 7,(hl)
	ret nz

	; Check Z position within 7 pixels
	sub Object.var2a-Object.zh
	ld l,a
	ldh a,(<hFF91)
	sub (hl)
	add $07
	cp $0e
	ret nc

	; Get Object.yh / Object.xh into bc
	dec l
	dec l
	ldd a,(hl)
	dec l
	ld b,(hl)
	ld c,a

	ld a,l
	add Object.collisionRadiusY-Object.yh
	ld l,a
	ld e,Item.collisionRadiusY
	jp checkObjectsCollidedFromVariables

;;
; Checks link's ID is 0, and checks various other things impeding game control
; (wLinkDeathTrigger, wLinkInAir, and link being in a spinner?)
;
; @param[out]	cflag	Set if any checks fail.
checkLinkID0AndControlNormal:
	ld a,(w1Link.id)
	or a
.ifdef ROM_AGES
	jr z,+++
.else
	jr z,checkLinkVulnerableAndIDZero
.endif
	xor a
	ret

;;
checkLinkVulnerableAndIDZero:

.ifdef ROM_AGES
	ld a,(w1Link.id)
	or a
	jr z,checkLinkVulnerable
	xor a
	ret
.endif

;;
; Check if link should respond to collisions, perhaps other things?
;
; @param[out]	cflag	Set if link is vulnerable
checkLinkVulnerable:
	; Check var2a, invincibilityCounter, knockbackCounter
	ld hl,w1Link.var2a
	ldi a,(hl)
	or (hl)
	ld l,<w1Link.knockbackCounter
	or (hl)
	jr nz,checkLinkCollisionsEnabled@noCarry

;;
; Check if link should respond to collisions, perhaps other things?
;
; @param[out]	cflag
checkLinkCollisionsEnabled:
	ld a,(w1Link.collisionType)
	rlca
	jr nc,@noCarry

.ifdef ROM_SEASONS
	ld a,(wLinkDeathTrigger)
	or a
	jr nz,@noCarry
.endif

	ld a,(wDisableLinkCollisionsAndMenu)
	or a
	jr nz,@noCarry

	ld a,(wMenuDisabled)
	or a
	jr nz,@noCarry

.ifdef ROM_AGES
+++
	ld a,(wLinkDeathTrigger)
	or a
	jr nz,@noCarry
.endif

	; Check if in a spinner
	ld a,(wcc95)
	rlca
	jr c,@noCarry

	ld a,(wLinkInAir)
	rlca
	jr c,@noCarry

	scf
	ret
@noCarry:
	xor a
	ret

;;
; Check if objects d and h have collided.
;
; @param[in]	d	Object 1
; @param[in]	h	Object 2
; @param[out]	cflag	Set if collision, unset if no collision
checkObjectsCollided:
	; Everything here is just setting up variables for the jump at the end
	ld a,l
	and $c0
	ld l,a
	push hl

	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.yh
	ld l,a
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a

	ld a,l
	add Object.collisionRadiusY - Object.xh
	ld e,a
	pop hl
	ld a,l
	add Object.yh
	ld l,a
	ld b,(hl)
	inc l
	inc l
	ld c,(hl)
	add Object.collisionRadiusY - Object.yh
	ld l,a
	jp checkObjectsCollidedFromVariables

;;
; Prevents Object 2 (usually Link) from passing through Object 1 (usually an npc).
;
; If Object 2 is Link, consider using "objectPreventLinkFromPassing" instead.
;
; @param	d	Object 1 (Npc, minecart)
; @param	h	Object 2 (Link)
; @param[out]	cflag	Set if there's a collision
preventObjectHFromPassingObjectD:
	ld a,l
	and $c0
	ldh (<hFF8B),a

	call checkObjectsCollided
	ret nc
	call @checkCollisionDirection
	jr nc,+

	; Vertical collision: get the sum of both objects' collisionRadiusY in c
	ld b,Object.yh
	ldh a,(<hFF8D)
	ld c,a
	jr ++
+
	; Horizontal collision: get the sum of both objects' collisionRadiusX in c
	ld b,Object.xh
	ldh a,(<hFF8C)
	ld c,a
	jr ++
++
	; Check which direction the objects are relative to each other...
	call @setBothObjectVariables
	ld a,(de)
	sub (hl)
	ld a,c
	jr c,+

	cpl
	inc a
+
	; Now lock object h's position to prevent it from moving any further
	ld b,a
	ld a,(de)
	add b
	ld (hl),a
	scf
	ret

;;
; Checks the direction of a collision. (Doesn't check for the collision itself)
;
; @param[out]	hFF8C	Sum of both objects' collisionRadiusX variables
; @param[out]	hFF8D	Sum of both objects' collisionRadiusY variables
; @param[out]	cflag	Set if the collision was predominantly from a vertical direction
@checkCollisionDirection:
	ld b,Object.yh
	call @setBothObjectVariables
	ld a,(de)
	sub (hl)
	jr nc,+

	cpl
	inc a
+
	; c will hold the difference in y positions
	ld c,a

	ld b,Object.collisionRadiusY
	call @setBothObjectVariables
	ld a,(de)
	add (hl)
	ldh (<hFF8D),a

	; hFF8F will be >0 if the objects collided vertically
	sub c
	ldh (<hFF8F),a

	ld b,Object.xh
	call @setBothObjectVariables
	ld a,(de)
	sub (hl)
	jr nc,+

	cpl
	inc a
+
	; c will hold the difference in x positions
	ld c,a

	ld b,Object.collisionRadiusX
	call @setBothObjectVariables
	ld a,(de)
	add (hl)
	ldh (<hFF8C),a
	sub c

	; Compare horizontal component of collision to vertical component.
	; Will set the carry flag if the collision occurred from a vertical direction.
	ld b,a
	ldh a,(<hFF8F)
	cp b
	ret

;;
; Makes both objects de and hl point to a particular variable.
;
; @param	b	The variable to make both objects point to
@setBothObjectVariables:
	ldh a,(<hActiveObjectType)
	or b
	ld e,a
	ldh a,(<hFF8B)
	or b
	ld l,a
	ret

;;
checkEnemyAndPartCollisionsIfTextInactive:
	call retIfTextIsActive
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank7.checkEnemyAndPartCollisions
	pop af
	setrombank
	ret

;;
; Searches a table at hl where each entry is a pointer for a group.
; This pointer points to data formatted as follows:
; 	room id (byte), value (byte)
; If it finds room id A in the list, it sets the carry flag and returns the value.
; Otherwise, it returns with the carry flag unset.
;
; @param	a	Room index
; @param	hl	Table address
; @param[out]	a	The value associated with the room
; @param[out]	cflag	c if the room existed in the table
findRoomSpecificData:
	ld e,a
	ld a,(wActiveGroup)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
;;
; Returns the "value" of a "key" E. hl points to a "dictionary" structure with
; the following format:
; 	key (byte), value (byte)
;
; The "dictionary" ends when the key equals zero.
;
; @param	e	Key to check for in table
; @param	hl	Table address
; @param[out]	a	The "value" associated with the key.
; @param[out]	cflag	Set on success (the key is in the table).
lookupKey:
	ldi a,(hl)
	or a
	ret z
	cp e
	ldi a,(hl)
	jr nz, lookupKey
	scf
	ret

;;
; Unused?
;
; @param a
findByteInGroupTable:
	ld e,a
	ld a,(wActiveGroup)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

;;
; Search through zero-terminated list of bytes at hl, return when one equals e.
;
; @param	e	Value to match
; @param[in]	hl	Start address to search
; @param[out]	cflag	Set if match found
findByteAtHl:
	ldi a,(hl)
	or a
	ret z

	cp e
	jr nz,findByteAtHl

	scf
	ret

;;
; @param	a	Tile to lookup
; @param	hl	Table
; @param[out]	cflag	Set on success.
lookupCollisionTable:
	ld e,a

;;
; @param	e	Tile to lookup
; @param	hl	Table
; @param[out]	cflag	Set on success.
lookupCollisionTable_paramE:
	ld a,(wActiveCollisions)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jr lookupKey

;;
; @param	a	Key
; @param[out]	cflag	Set if match found
findByteInCollisionTable:
	ld e,a

;;
; @param e
findByteInCollisionTable_paramE:
	ld a,(wActiveCollisions)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jr findByteAtHl

;;
objectSetVisiblec0:
	ldh a,(<hActiveObjectType)
	add Object.visible
	ld e,a
	ld a,$c0
	ld (de),a
	ret
;;
objectSetVisiblec1:
	ldh a,(<hActiveObjectType)
	add Object.visible
	ld e,a
	ld a,$c1
	ld (de),a
	ret
;;
objectSetVisiblec2:
	ldh a,(<hActiveObjectType)
	add Object.visible
	ld e,a
	ld a,$c2
	ld (de),a
	ret
;;
objectSetVisiblec3:
	ldh a,(<hActiveObjectType)
	add Object.visible
	ld e,a
	ld a,$c3
	ld (de),a
	ret
;;
objectSetVisible80:
	ldh a,(<hActiveObjectType)
	add Object.visible
	ld e,a
	ld a,$80
	ld (de),a
	ret
;;
objectSetVisible81:
	ldh a,(<hActiveObjectType)
	add Object.visible
	ld e,a
	ld a,$81
	ld (de),a
	ret
;;
objectSetVisible82:
	ldh a,(<hActiveObjectType)
	add Object.visible
	ld e,a
	ld a,$82
	ld (de),a
	ret
;;
objectSetVisible83:
	ldh a,(<hActiveObjectType)
	add Object.visible
	ld e,a
	ld a,$83
	ld (de),a
	ret

;;
objectSetInvisible:
	ldh a,(<hActiveObjectType)
	add Object.visible
	ld l,a
	ld h,d
	res 7,(hl)
	ret
;;
objectSetVisible:
	ldh a,(<hActiveObjectType)
	add Object.visible
	ld l,a
	ld h,d
	set 7,(hl)
	ret

;;
objectSetReservedBit1:
	ldh a,(<hActiveObjectType)
	ld l,a
	ld h,d
	set 1,(hl)
	ret

;;
objectGetAngleTowardEnemyTarget:
	ldh a,(<hEnemyTargetY)
	ld b,a
	ldh a,(<hEnemyTargetX)
	ld c,a
	jr objectGetRelativeAngle

;;
objectGetAngleTowardLink:
	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
;;
; Get the angle needed to move an object toward a position.
;
; @param	bc	YX position to get the direction toward
; @param	d	Current object
; @param[out]	a	An angle value pointing towards bc
objectGetRelativeAngle:

; Internal variables:
;  hFF8E: X
;  hFF8F: Y

	ldh a,(<hActiveObjectType)
	or Object.yh
	ld e,a

;;
; @param	bc	YX position to get the direction toward
; @param	de	Address of an object's Y position
getRelativeAngle:
	ld a,(de)
	ldh (<hFF8F),a
	inc e
	inc e
	ld a,(de)
	ldh (<hFF8E),a
;;
; @param	bc	YX position to get the direction toward
; @param	d	Current object
; @param	hFF8E	X position of object
; @param	hFF8F	Y position of object
objectGetRelativeAngleWithTempVars:
	ld e,$08
	ld a,b
	add e
	ld b,a
	ld a,c
	add e
	ld c,a
	ld e,$00
	ldh a,(<hFF8F)
	add $08
	sub b
	jr nc,+

	cpl
	inc a
	ld e,$04
+
	ld h,a
	ldh a,(<hFF8E)
	add $08
	sub c
	jr nc,+

	cpl
	inc a
	inc e
	inc e
+
	cp h
	jr nc,+

	inc e
	ld l,a
	ld a,h
	ld h,l
+
	ld c,e
	ld b,$00
	srl a
	srl a
	srl a
	add a
	ld l,a
	cp h
	jr nc,++

	inc b
	add l
	cp h
	jr nc,++

	inc b
	add l
	cp h
	jr nc,++

	inc b
	add l
	cp h
	jr nc,++
	inc b
++
	ld a,c
	add a
	add a
	add a
	add b
	ld c,a
	ld b,$00
	ld hl,pushDirectionData
	add hl,bc
	ld a,(hl)
	ret

pushDirectionData:
	.db $18 $19 $1a $1b $1c $00 $00 $00
	.db $00 $1f $1e $1d $1c $00 $00 $00
	.db $08 $07 $06 $05 $04 $00 $00 $00
	.db $00 $01 $02 $03 $04 $00 $00 $00
	.db $18 $17 $16 $15 $14 $00 $00 $00
	.db $10 $11 $12 $13 $14 $00 $00 $00
	.db $08 $09 $0a $0b $0c $00 $00 $00
	.db $10 $0f $0e $0d $0c $00 $00 $00

;;
; @param	a	Z Acceleration (gravity)
; @param[out]	hl	Object.speedZ variable
; @param[out]	zflag	Set if resulting position is below or on the ground
objectUpdateSpeedZ:
	ld c,a
;;
; @param	c	Z Acceleration (gravity)
; @param[out]	hl	Object.speedZ variable
; @param[out]	zflag	Set if resulting position is below or on the ground
objectUpdateSpeedZ_paramC:
	ldh a,(<hActiveObjectType)
	add Object.z
	ld e,a
	add Object.speedZ - Object.z
	ld l,a
	ld h,d
	call add16BitRefs
	bit 7,a
	jr z,@belowGround

; Above ground
	dec l
	ld a,c
	add (hl)
	ldi (hl),a
	ld a,$00
	adc (hl)
	ld (hl),a
	or d
	ret

; Can't be below ground, set z position to 0
@belowGround:
	xor a
	ld (de),a
	dec e
	ld (de),a
	xor a
	ret

;;
; Updates an object's speedZ in a way that works with sidescrolling areas. This assumes
; that the object's width has a particular value (8 pixels?), but its height can be
; specified with the 'b' parameter.
;
; @param	a	Gravity (amount to add to Object.speedZ)
; @param[out]	cflag	Set if the object has landed.
; @param[out]	hl	Object.speedZ+1
objectUpdateSpeedZ_sidescroll:
	ld b,$06

;;
; @param	a	Gravity (amount to add to Object.speedZ)
; @param	b	Y offset for collision check
; @param[out]	cflag	Set if the object has landed.
; @param[out]	hl	Object.speedZ+1
objectUpdateSpeedZ_sidescroll_givenYOffset:
	ldh (<hFF8B),a
	ldh a,(<hActiveObjectType)
	add Object.speedZ+1
	ld l,a
	ld h,d
	bit 7,(hl)
	jr nz,@notLanded

; speedZ is positive; return with carry flag set if the object collides with a tile.

	; Set b to object's y position (plus offset)
	add Object.yh-(Object.speedZ+1)
	ld l,a
	ldi a,(hl)
	add b
	ld b,a

	; hl = Object.xh
	inc l
	ld a,(hl)

	; Check left side of object (assumes 8 pixel width?)
	sub $04
	ld c,a
	call checkTileCollisionAt_allowHoles
	ret c

	; Check right side of object (assumes 8 pixel width?)
	ld a,c
	add $07
	ld c,a
	call checkTileCollisionAt_allowHoles
	ret c

@notLanded:
	; Add speedZ to y position
	ldh a,(<hActiveObjectType)
	add Object.y
	ld e,a
	add Object.speedZ-Object.y
	ld l,a
	ld h,d
	call add16BitRefs

	; Apply gravity (increase speedZ by amount passed to function)
	dec l
	ldh a,(<hFF8B)
	add (hl)
	ldi (hl),a
	ld a,$00
	adc (hl)
	ld (hl),a

	; Clear carry flag
	or d
	ret

;;
; Checks if Link is within the distance given to the object (valid area is a square).
;
; Returns the direction Link is in relative to the object, in a slightly different format
; than normal?
;
; @param	c	How close Link should be to the object
; @param[out]	a	Direction Link is in relative to the object? (divide by 2 to get
;			a standard direction value)
; @param[out]	cflag	c if Link is within the specified distance. If unset, 'a' won't
;			be calculated properly.
objectCheckLinkWithinDistance:
	ldh a,(<hActiveObjectType)

	; Get the difference between the object's and link's y positions
	add Object.yh
	ld l,a
	ld h,d
	ld e,$04
	ld a,(w1Link.yh)
	sub (hl)
	jr nc,+
	cpl
	inc a
	ld e,$00
+
	ld b,a
	ld a,c
	sub b
	ccf
	ret nc

	; Get the difference between the object's and link's x positions
	ld c,a
	inc l
	inc l
	set 5,e
	ld a,(w1Link.xh)
	sub (hl)
	jr nc,+

	cpl
	inc a
	set 6,e
+
	cp c
	ret nc
	cp b
	jr c,+
	swap e
+
	ld a,e
	and $06
	scf
	ret

;;
; Increments or decrements an object's angle by one unit toward the given value.
;
; @param	a	Angle value to move toward
objectNudgeAngleTowards:
	ld c,a
	ldh a,(<hActiveObjectType)
	add Object.angle
	ld e,a
	ld a,(de)
	ld b,a

	sub c
	jr z,++

	and $1f
	cp $10
	jr nc,+

	dec b
	jr ++
+
	inc b
++
	ld a,b
	and $1f
	ld (de),a
	ret

;;
; Checks if link is centered within 'b' pixels compared to another object (horizontally or
; vertically).
;
; @param	b	Distance threshold
; @param	d	Object to compare with
; @param[out]	cflag	Set if link is centered within the threshold given.
objectCheckCenteredWithLink:
	ld c,b
	sla c
	inc c

	; Check Y
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.yh
	ld l,a
	ld a,(w1Link.yh)
	sub (hl)
	add b
	cp c
	ret c

	; Check X
	inc l
	inc l
	ld a,(w1Link.xh)
	sub (hl)
	add b
	cp c
	ret

;;
; This function reads Object.speed differently than most places (ie. objectApplySpeed). It
; adds variables $10-$11 to Object.y as a 16-bit value, and $12-$13 to Object.x.
;
objectApplyComponentSpeed:
	ldh a,(<hActiveObjectType)
	add Object.y
	ld l,a
	add Object.speed-Object.y
	ld e,a
	ld h,d
	call @addSpeedComponent
	inc e

;;
@addSpeedComponent:
	ld a,(de)
	add (hl)
	ldi (hl),a
	inc e
	ld a,(de)
	adc (hl)
	ldi (hl),a
	ret

;;
; Uses the object's speed and angle variables to update its position.
;
; @param[out]	a	New value of object.xh
objectApplySpeed:
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.angle
	ld e,a
	ld l,a
	ld c,(hl)
	add Object.speed-Object.angle
	ld l,a
	ld b,(hl)

;;
; @param	b	speed value
; @param	c	angle value
; @param	de	Address of an object's angle variable (will only read/write the
;			Y and X values which follow that, not the angle itself).
; @param[out]	a	New value of object.xh
objectApplyGivenSpeed:
	call getPositionOffsetForVelocity
	ret z

	; Add to Object.y
	inc e
	ld a,(de)
	add (hl)
	ld (de),a
	inc e
	inc l
	ld a,(de)
	adc (hl)
	ld (de),a

	; Add to Object.x
	inc e
	inc l
	ld a,(de)
	add (hl)
	ld (de),a
	inc e
	inc l
	ld a,(de)
	adc (hl)
	ld (de),a
	ret

;;
; Takes a speed and an angle, and calculates the values to add to an object's y and
; x positions.
;
; @param	b	speed (should be a multiple of 5)
; @param	c	angle (value from $00-$1f)
; @param[out]	hl	Pointer to 4 bytes of data to be added to Y and X positions.
;			It always points to wTmpcec0.
; @param[out]	zflag	Set if the speed / angle was invalid (or speed is zero)
getPositionOffsetForVelocity:
	bit 7,c
	jr nz,@invalid

	swap b
	jr z,@invalid

	ld a,b
	ld hl,bank3.objectSpeedTable-$50
	sla c
	ld b,$00
	add hl,bc

	ld b,a
	and $f0
	ld c,a
	ld a,b
	and $0f
	ld b,a
	add hl,bc
	ldh a,(<hRomBank)
	push af
	ld a,:bank3.objectSpeedTable
	setrombank

	; Get Y values
	ld bc,wTmpcec0
	ldi a,(hl)
	ld (bc),a
	inc c
	ldi a,(hl)
	ld (bc),a

	; Get X values
	inc c
	ld a,$0e
	rst_addAToHl

	ldi a,(hl)
	ld (bc),a
	inc c
	ldi a,(hl)
	ld (bc),a

	pop af
	setrombank

	ld hl,wTmpcec0
	or h
	ret

@invalid:
	ld hl,wTmpcec0+3
	xor a
	ldd (hl),a
	ldd (hl),a
	ldd (hl),a
	ld (hl),a
	ret

;;
; @param[out]	bc	Object's position
objectGetPosition:
	ldh a,(<hActiveObjectType)
	add Object.yh
	ld e,a
	ld a,(de)
	ld b,a
	inc e
	inc e
	ld a,(de)
	ld c,a
	ret

;;
; @param[out]	a	Object's position (short form)
objectGetShortPosition:
	ldh a,(<hActiveObjectType)
	add Object.yh
	ld e,a
;;
getShortPositionFromDE:
	ld a,(de)
--
	and $f0
	ld b,a
	inc e
	inc e
	ld a,(de)
	swap a
	and $0f
	or b
	ret

;;
; @param	a	Value to add to the object's Y position before calculating
; @param[out]	a	Object's position (short form)
objectGetShortPosition_withYOffset:
	ld b,a
	ldh a,(<hActiveObjectType)
	add Object.yh
	ld e,a
	ld a,(de)
	add b
	jr --

;;
; Writes $0f to the collision value of the tile the object is standing on.
;
objectMakeTileSolid:
	call objectGetTileCollisions
	ld (hl),$0f
	ret

;;
; @param	a	Short-form position
; @param	hl	Address to write to (usually an Object.yh)
setShortPosition:
	ld c,a
;;
; @param	c	Short-form position
; @param	hl	Address to write to (usually an Object.yh)
setShortPosition_paramC:
	push bc
	call convertShortToLongPosition_paramC
	ld (hl),b
	inc l
	inc l
	ld (hl),c
	pop bc
	ret

;;
; Set an object's position.
;
; @param	c	Short-form position
objectSetShortPosition:
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.yh
	ld l,a
	jr setShortPosition_paramC

;;
; @param	a	Short-form position (YX)
; @param[out]	bc	Long-form position (YYXX)
convertShortToLongPosition:
	ld c,a
;;
; @param	c	Short-form position (YX)
; @param[out]	bc	Long-form position (YYXX)
convertShortToLongPosition_paramC:
	ld a,c
	and $f0
	or $08
	ld b,a
	ld a,c
	swap a
	and $f0
	or $08
	ld c,a
	ret

;;
objectCenterOnTile:
	ldh a,(<hActiveObjectType)
	add Object.y
	ld l,a
	ld h,d

;;
; Adjust 16-bit coordinates to the center of a tile.
;
; @param	hl
centerCoordinatesOnTile:
	; Center Y
	xor a
	ldi (hl),a
	ld a,(hl)
	and $f0
	or $08
	ldi (hl),a

	; Center X
	xor a
	ldi (hl),a
	ld a,(hl)
	and $f0
	or $08
	ld (hl),a
	ret

;;
; Checks to see if a certain number of part slots are available.
;
; @param	b	Number of part slots to check for
; @param[out]	zflag	Set if there are at least 'b' part slots available.
checkBPartSlotsAvailable:
	ldhl FIRST_PART_INDEX, Part.enabled
	jr checkBEnemySlotsAvailable@nextSlot

;;
checkBEnemySlotsAvailable:
	ldhl FIRST_ENEMY_INDEX, Enemy.enabled

@nextSlot:
	call @checkSlotAvailable
	jr c,@nextSlot
	ret nz
	dec b
	jr nz,@nextSlot
	ret

;;
@checkSlotAvailable:
	ld a,(hl)
	inc h
	or a
	ret z
	ld a,h
	cp $e0
	ret c
	or h
	ret

;;
; Places an object 'a' units away from a specified position, where one unit is one pixel,
; or the equivalent of one pixel for diagonal angles. Useful for placing an object along
; the perimeter of a circle.
;
; Used, for instance, by the sparkles after telling a secret to Farore. "bc" is the
; position of the chest (the center of the circle), "a" is how far away they are from the
; chest, and "de" points to their current angle from the chest.
;
; @param	a	Distance away from bc to put the object
; @param	bc	Relative offset ("center of the circle")
; @param	de	Pointer to the object's angle value
; @param[out]	de	Object.xh
objectSetPositionInCircleArc:
	push bc
	ld h,d
	ld l,e
	ld c,(hl)
	ld b,SPEED_100
	call getScaledPositionOffsetForVelocity
	pop bc

	; Add Y offset
	ldh a,(<hActiveObjectType)
	add Object.yh
	ld e,a
	ld a,(wTmpcec0+1)
	add b
	ld (de),a

	; Add X offset
	inc e
	inc e
	ld a,(wTmpcec0+3)
	add c
	ld (de),a
	ret

;;
; This appears to multiply a position offset by a certain amount.
;
; @param	a		Amount to multiply the resulting position offsets by
; @param	b		Speed
; @param	c		Angle
; @param[out]	wTmpcec0	The scaled values are stored here (4 bytes total).
; @param[out]	hl		wTmpcec0+3
getScaledPositionOffsetForVelocity:
	ldh (<hFF8B),a
	call getPositionOffsetForVelocity

	call @scaleComponent
	inc l

;;
; @param	hl	Address of position offset to scale
; @param	hFF8B	Amount to scale the position offsets by
@scaleComponent:
	push hl
	ldi a,(hl)
	ld c,a
	ld b,(hl)

	; Multiply 'bc' by [hFF8B], storing the result in 'hl'?
	ld e,$08
	ld hl,$0000
	ldh a,(<hFF8B)
--
	add hl,hl
	rlca
	jr nc,+
	add hl,bc
+
	dec e
	jr nz,--

	; Store the scaled values
	ld a,l
	ld b,h
	pop hl
	ldi (hl),a
	ld (hl),b
	ret

;;
; Set's an object's "component speed" (separate x/y speed variables) via the given speed
; & angle values.
;
; @param	a	Amount to multiply speed by
; @param	b	Speed
; @param	c	Angle
objectSetComponentSpeedByScaledVelocity:
	call getScaledPositionOffsetForVelocity

	ldh a,(<hActiveObjectType)
	or Object.speedX+1

	; X speed
	ld e,a
	ldd a,(hl)
	ld (de),a
	dec e
	ldd a,(hl)
	ld (de),a

	; Y speed
	dec e
	ldd a,(hl)
	ld (de),a
	dec e
	ld a,(hl)
	ld (de),a
	ret

;;
; Gets the address of a variable in relatedObj1.
;
; @param	a	Which variable to get for relatedObj1
; @param[out]	hl	Address of the variable
objectGetRelatedObject1Var:
	ld l,Object.relatedObj1
	jr ++

;;
objectGetRelatedObject2Var:
	ld l,Object.relatedObj2
++
	ld h,a
	ldh a,(<hActiveObjectType)
	add l
	ld e,a
	ld a,(de)
	add h
	ld l,a
	inc e
	ld a,(de)
	ld h,a
	ret

;;
; Returns a Z position such that the object would be immediately above the screen if
; assigned this value.
;
; @param[out]	a	Z position
objectGetZAboveScreen:
	ldh a,(<hActiveObjectType)
	add Object.yh
	ld e,a
	ld a,(de)
	ld b,a
	ldh a,(<hCameraY)
	sub b
	sub $08
	cp $80
	ret nc

	ld a,$80
	ret

;;
; Checks if the object is within the screen. Note the screen size may be smaller than the
; room size (in dungeons).
;
; Seems to give leeway of 8 pixels in either direction, unless that's somehow part of the
; calculation. (Is it expecting 16x16-size objects?)
;
; @param[out]	cflag	Set if the object is within the screen boundary
objectCheckWithinScreenBoundary:
	ldh a,(<hCameraY)
	ld b,a
	ldh a,(<hCameraX)
	ld c,a
	ldh a,(<hActiveObjectType)
	add Object.yh
	ld e,a
	ld a,(de)
	sub b
	add $07
	cp $90-1
	ret nc

	inc e
	inc e
	ld a,(de)
	sub c
	add $07
	cp $b0-1
	ret

;;
; @param[out]	cflag	Set if the object is within the room boundary
objectCheckWithinRoomBoundary:
	ldh a,(<hActiveObjectType)
	add Object.yh
	ld e,a
	ld hl,wRoomEdgeY
	ld a,(de)
	cp (hl)
	ret nc

	inc e
	inc e
	inc l
	ld a,(de)
	cp (hl)
	ret

;;
; Deletes the object (clears its memory), then replaces its ID with the new value.
;
; The new object keeps its former yh, xh, zh, and enabled values.
;
; @param	bc	New object ID
objectReplaceWithID:
	ld h,d
	push bc

	; Store Object.enabled, Y position
	ldh a,(<hActiveObjectType)
	ld l,a
	ld b,(hl)
	add Object.yh
	ld l,a
	ld c,(hl)
	push bc

	; Store X, Z
	inc l
	inc l
	ld b,(hl)
	inc l
	inc l
	ld c,(hl)
	push bc

	; Delete object
	call objectDelete_useActiveObjectType

	; Restore X/Y/Z positions
	pop bc
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.zh
	ld l,a
	ld (hl),c
	dec l
	dec l
	ld (hl),b
	pop bc
	dec l
	dec l
	ld (hl),c

	; Restore Object.enabled (only first 2 bits?)
	ldh a,(<hActiveObjectType)
	ld l,a
	ld a,b
	and $03
	ldi (hl),a

	; Set Object.id, subid
	pop bc
	ld (hl),b
	inc l
	ld (hl),c
	ret

;;
objectDelete_useActiveObjectType:
	ldh a,(<hActiveObjectType)
	ld e,a

;;
objectDelete_de:
	ld a,e
	and $c0
	ld e,a
	ld l,a
	ld h,d
	ld b,$10
	xor a
--
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	dec b
	jr nz,--
	jp objectRemoveFromAButtonSensitiveObjectList

;;
; Check if Link is over a pit (water, hole, or lava). If he's riding dimitri, this check
; always comes up false.
;
; Note: this overwrites the current hActiveObject.
;
; @param[out]	a	$01 if water, $02 if hole, $04 if lava
; @param[out]	cflag	Set if Link is on one of the above tiles.
checkLinkIsOverHazard:
	ld a,(wLinkObjectIndex)
	ld d,a
	ldh (<hActiveObject),a
	xor a
	ldh (<hActiveObjectType),a

	ld e,SpecialObject.id
	ld a,(de)
	sub SPECIALOBJECTID_DIMITRI
	ret z

	push bc
	push hl
	call objectCheckIsOverHazard
	pop hl
	pop bc
	ret

;;
; Check if an object is on water, lava, or a hole. Same as the below function, except if
; the object is in midair, it doesn't count.
;
; @param[out]	a	$01 if water, $02 if hole, $04 if lava
; @param[out]	cflag	Set if the object is on one of these tiles.
objectCheckIsOnHazard:
	ldh a,(<hActiveObjectType)
	add Object.zh
	ld e,a
	ld a,(de)
	and $80
	ret nz
;;
; Check if an object is over water, lava, or a hole.
;
; @param[out]	a	$01 if water, $02 if hole, $04 if lava
; @param[out]	cflag	Set if the object is on one of these tiles.
objectCheckIsOverHazard:
	ld bc,$0500
	call objectGetRelativeTile
.ifdef ROM_AGES
	ld (wObjectTileIndex),a
.endif
	ld hl,hazardCollisionTable
	jp lookupCollisionTable

;;
; If the object is over a pit, this replaces it with an appropriate animation.
;
; @param[out]	cflag	Set if the object was on a pit.
objectReplaceWithAnimationIfOnHazard:
	call objectCheckIsOnHazard
	ret nc

	rrca
	jr c,objectReplaceWithSplash

	rrca
	jr c,objectReplaceWithFallingDownHoleInteraction

	ld b,INTERACID_LAVASPLASH
	jr objectReplaceWithSplash@create

;;
objectReplaceWithFallingDownHoleInteraction:
	call objectCreateFallingDownHoleInteraction
	jr objectReplaceWithSplash@delete

;;
objectReplaceWithSplash:
	ld b,INTERACID_SPLASH
@create:
	call objectCreateInteractionWithSubid00
@delete:
	call objectDelete_useActiveObjectType
	scf
	ret

;;
; Copies xyz position of object d to object h.
;
; @param[out]	de	Object d's 'zh' variable
; @param[out]	hl	Object h's 'speed' variable (one past 'zh')
objectCopyPosition:
	ldh a,(<hActiveObjectType)
	add Object.yh
	ld e,a

;;
; Copies the xyz position at address de to object h.
objectCopyPosition_rawAddress:
	ld a,l
	and $c0
	add Object.yh
	ld l,a
	ld a,(de)
	ldi (hl),a
	inc e
	inc e
	inc l
	ld a,(de)
	ldi (hl),a
	inc e
	inc e
	inc l
	ld a,(de)
	ldi (hl),a
	ret

;;
; Copies xyz position of object d to object h and adds an offset.
;
; @param	bc	YX offset
objectCopyPositionWithOffset:
	ldh a,(<hActiveObjectType)
	add Object.yh
	ld e,a
	ld a,l
	and $c0
	add Object.yh
	ld l,a

	ld a,(de)
	add b
	ldi (hl),a

	inc e
	inc e
	inc l
	ld a,(de)
	add c
	ldi (hl),a
	inc e
	inc e
	inc l

	ld a,(de)
	ldi (hl),a
	ret

;;
; Object 'd' takes the xyz position of object 'h'.
;
objectTakePosition:
	ld bc,$0000
;;
; Object 'd' takes the xyz position of object 'h', plus an offset.
;
; @param	b	Y offset
; @param	c	X offset
; @param[out]	a	Z position
; @param[out]	de	Address of this object's zh variable
; @param[out]	hl	Address of object h's zh variable
objectTakePositionWithOffset:
	ldh a,(<hActiveObjectType)
	add Object.yh
	ld e,a
	ld a,l
	and $c0
	add Object.yh
	ld l,a

	ldi a,(hl)
	add b
	ld (de),a

	inc e
	inc e
	inc l
	ldi a,(hl)
	add c
	ld (de),a

	inc e
	inc e
	inc l
	ld a,(hl)
	ld (de),a
	ret

;;
; Changes a tile, and creates a "falling down hole" interaction.
;
; @param	a	Value to change the tile to
; @param	c	Position of tile to change, and where to put the interaction
breakCrackedFloor:
	push bc
	call setTile
	pop bc

	ld a,SND_RUMBLE
	call playSound

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_FALLDOWNHOLE

	; Disable interaction's sound effect
	inc l
	ld (hl),$80

	ld l,Interaction.yh
	jp setShortPosition_paramC

;;
; @param[out]	cflag	Set if the tile at the object's position is water (even shallow
;			water)
objectCheckTileAtPositionIsWater:
	call objectGetTileAtPosition
	sub TILEINDEX_PUDDLE
	cp TILERANGE_WATER
	ret

;;
; This function is used by zoras, presumably to check which positions they can spawn at.
;
; @param	bc	Position of tile
; @param[out]	cflag	Set if the tile at that position is water (even shallow water)
checkTileAtPositionIsWater:
	call getTileAtPosition
	sub TILEINDEX_PUDDLE
	cp TILERANGE_WATER
	ret

;;
; @param	c	An item ID to search for
; @param[out]	hl	Address of the id variable for the first item with ID 'c'
; @param[out]	zflag	Set on success
findItemWithID:
	ld h,FIRST_ITEM_INDEX
---
	ld l,Item.id
	ld a,(hl)
	cp c
	ret z
;;
; @param	c	An item ID to search for
; @param	h	The index before the first item to check
; @param[out]	zflag	Set on success
findItemWithID_startingAfterH:
	inc h
	ld a,h
	cp $e0
	jr c,---
	or h
	ret

;;
; Searches for an object with the given ID of the same type as the current active object.
;
; @param	c	An object ID to search for
; @param[out]	hl	Address of the id variable for the first object with ID 'c'
; @param[out]	zflag	Set on success
objectFindSameTypeObjectWithID:
	ldh a,(<hActiveObject)
	and $f0
	ld h,a

	; l = Object.id
	ldh a,(<hActiveObjectType)
	inc a
	ld l,a
--
	ld a,(hl)
	cp c
	ret z
func_228f:
	inc h
	ld a,h
	cp $e0
	jr c,--
	or h
	ret

;;
; Sets object's priority based on y, z relative to link?
;
objectSetPriorityRelativeToLink:
	ld c,$80
	jr +

;;
; Sets object's priority based on y, z relative to link?
;
; Also sets bit 6 of visible (unlike above) which enables terrain effects (ie. pond
; puddle)
;
; @param[out]	b	Value written to Object.visible
; @param[out]	de	Address of Object.visible
objectSetPriorityRelativeToLink_withTerrainEffects:
	ld c,$c0
+
	call @getPriority
	ldh a,(<hActiveObjectType)
	add Object.visible
	ld e,a
	ld a,c
	or b
	ld (de),a
	ret

;;
; Gets priority based on height relative to link?
;
; @param	d	Object
; @param[out]	b	Priority
@getPriority:
	ldh a,(<hActiveObjectType)
	add Object.zh
	ld e,a
	ld a,(de)
	; return if Z position is between 1 and 16
	dec a
	ld b,$03
	cp $10
	ret c

	dec b
	ld a,e
	add Object.yh-Object.zh
	ld e,a
	ld a,(de)
	ld e,a

	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,<w1Link.yh
	ld a,(hl)
	add $0b

	; cp (w1Link.yh+$0b) to Object.yh
	cp e
	ret nc

	; decrement b if Object.y < w1Link.yh+$0b
	dec b
	ret

;;
; Pushes Link away from the object if they collide.
;
; This provides "light" collision for moving objects, allowing Link to still walk through
; them with some resistance.
;
; @param[out]	cflag	Set if the object collided with Link
objectPushLinkAwayOnCollision:
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.enabled
	call checkObjectsCollided
	ret nc

	; They've collided; calculate the angle to push Link back at
	call objectGetAngleTowardEnemyTarget
	ld c,a
	ld b,SPEED_100

;;
; @param	b	Speed
; @param	c	Angle
updateLinkPositionGivenVelocity:
	ldh a,(<hRomBank)
	push af
	ld a,:bank5.specialObjectUpdatePositionGivenVelocity
	setrombank

	; Update Link's position
	push de
	ld a,(wLinkObjectIndex)
	ld d,a
	ld e,SpecialObject.enabled
	call bank5.specialObjectUpdatePositionGivenVelocity
	pop de

	pop af
	setrombank
	scf
	ret

;;
; Sets the object's oam variables to mimic a background tile. Also copies the
; corresponding background palette to sprite palette 6.
;
; The object will still need to load the correct animation.
;
; @param	a	Tile index
objectMimicBgTile:
	; Get top-left flag value in 'b', top-left tile index in 'c'
	call getTileMappingData

	; Set oamFlagsBackup & oamFlags to $0e
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.oamFlagsBackup
	ld l,a
	ld a,$0e
	ldi (hl),a
	ldi (hl),a

	; Set Object.oamTileIndexBase to the value returned from the function call above
	ld (hl),c

	; bc = w2TilesetBgPalettes + (palette index) * 8
	ld a,b
	and $07
	swap a
	rrca
	ld bc,w2TilesetBgPalettes
	call addAToBc

	ld a,($ff00+R_SVBK)
	push af
	ld a,:w2TilesetBgPalettes
	ld ($ff00+R_SVBK),a

	; Copy the background palette to sprite palette 6
	ld hl,w2TilesetSprPalettes+6*8
	ld e,$08
--
	ld a,(bc)
	ldi (hl),a
	inc c
	dec e
	jr nz,--

	; Slate sprite palette 6 for reloading
	ld hl,hDirtySprPalettes
	set 6,(hl)

	pop af
	ld ($ff00+R_SVBK),a
	ret

;;
; @param	c	Gravity
; @param[out]	cflag	c if the object will no longer bounce (speedZ is sufficiently low).
; @param[out]	zflag	z if the object touched the ground
objectUpdateSpeedZAndBounce:
	call objectUpdateSpeedZ_paramC
	ret nz

;;
; Inverts an object's Z speed and halves it. Used for bombs when bouncing on the ground.
;
; Once it reaches a speed of less than 1 pixel per frame downwards, it stops.
;
; @param[out]	cflag	c if the object will no longer bounce (speedZ is sufficiently low).
; @param[out]	zflag	z if the object touched the ground
objectNegateAndHalveSpeedZ:
	ld h,d
	ldh a,(<hActiveObjectType)
	or Object.speedZ
	ld l,a

	; Get -speedZ/2 in bc
	ldi a,(hl)
	cpl
	ld c,a
	ld a,(hl)
	cpl
	ld b,a

	inc bc
	sra b
	rr c

	; Return if bc > $ff80 (original speed is less than 1 pixel per frame downward)
	ld hl,$ff80
	call compareHlToBc
	inc a
	scf
	ret z

	ldh a,(<hActiveObjectType)
	or Object.speedZ
	ld e,a

	; Store new speedZ
	ld a,c
	ld (de),a
	inc e
	ld a,b
	ld (de),a

	; Set carry flag on return if speed is zero
	or c
	scf
	ret z

	xor a
	ret

;;
; @param	bc	speedZ
objectSetSpeedZ:
	ldh a,(<hActiveObjectType)
	add Object.speedZ
	ld l,a
	ld h,d
	ld (hl),c
	inc l
	ld (hl),b
	ret

;;
; Adds a 16-bit variable located at hl to a 16-bit variable at de
;
; @param	de	Address to add and write result to
; @param	hl	Address of value to add
; @param[out]	a	High byte of result
add16BitRefs:
	ld a,(de)
	add (hl)
	ld (de),a
	inc e
	inc hl
	ld a,(de)
	adc (hl)
	ld (de),a
	ret

;;
; @param	a	The ring to check for.
; @param[out]	zflag	Set if the currently equipped ring equals 'a'.
cpActiveRing:
	push hl
	ld hl,wActiveRing
	cp (hl)
	pop hl
	ret

;;
disableActiveRing:
	push hl
	ld hl,wActiveRing
	set 6,(hl)
	pop hl
	ret

;;
enableActiveRing:
	push hl
	ld hl,wActiveRing
	ld a,(hl)
	cp $ff
	jr z,+
	res 6,(hl)
+
	pop hl
	ret

;;
interactionDecCounter1:
	ld h,d
	ld l,Interaction.counter1
	dec (hl)
	ret
;;
interactionDecCounter2:
	ld h,d
	ld l,Interaction.counter2
	dec (hl)
	ret
;;
itemDecCounter1:
	ld h,d
	ld l,Item.counter1
	dec (hl)
	ret
;;
itemDecCounter2:
	ld h,d
	ld l,Item.counter2
	dec (hl)
	ret
;;
interactionIncState:
	ld h,d
	ld l,Interaction.state
	inc (hl)
	ret
;;
interactionIncSubstate:
	ld h,d
	ld l,Interaction.substate
	inc (hl)
	ret
;;
itemIncState:
	ld h,d
	ld l,Item.state
	inc (hl)
	ret
;;
itemIncSubstate:
	ld h,d
	ld l,Item.substate
	inc (hl)
	ret
;;
; Unused?
cpInteractionState:
	ld h,d
	ld l,Interaction.state
	cp (hl)
	ret
;;
; Unused?
cpInteractionSubstate:
	ld h,d
	ld l,Interaction.substate
	cp (hl)
	ret
;;
checkInteractionState:
	ld e,Interaction.state
	ld a,(de)
	or a
	ret
;;
checkInteractionSubstate:
	ld e,Interaction.substate
	ld a,(de)
	or a
	ret


; Lists the water, hole, and lava tiles for each collision mode.
;
hazardCollisionTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

.ifdef ROM_AGES

@collisions0:
@collisions4:
	.db $fa $01
	.db $fc $01
	.db $fe $01
	.db $ff $01
	.db $e0 $01
	.db $e1 $01
	.db $e2 $01
	.db $e3 $01
	.db $f3 $02
	.db $e4 $04
	.db $e5 $04
	.db $e6 $04
	.db $e7 $04
	.db $e8 $04
	.db $e9 $01
	.db $00

@collisions1:
@collisions2:
@collisions5:
	.db $fa $01
	.db $fc $01
	.db $f3 $02
	.db $f4 $02
	.db $f5 $02
	.db $f6 $02
	.db $f7 $02
	.db $61 $04
	.db $62 $04
	.db $63 $04
	.db $64 $04
	.db $65 $04
	.db $48 $02
	.db $49 $02
	.db $4a $02
	.db $4b $02
	.db $00

@collisions3:
	.db $1a $01
	.db $1b $01
	.db $1c $01
	.db $1d $01
	.db $1e $01
	.db $1f $01
	.db $00

.else ; ROM_SEASONS

@collisions0:
	.db $f3 $02
	.db $fd $01
	.db $fe $01
	.db $ff $01
	.db $d1 $01
	.db $d2 $01
	.db $d3 $01
	.db $d4 $01
	.db $7b $04
	.db $7c $04
	.db $7d $04
	.db $7e $04
	.db $7f $04
	.db $00

@collisions1:
	.db $f3 $02
	.db $f4 $02
	.db $7b $04
	.db $7c $04
	.db $7d $04
	.db $7e $04
	.db $7f $04
	.db $c0 $04
	.db $c1 $04
	.db $c2 $04
	.db $c3 $04
	.db $c4 $04
	.db $c5 $04
	.db $c6 $04
	.db $c7 $04
	.db $c8 $04
	.db $c9 $04
	.db $ca $04
	.db $cb $04
	.db $cc $04
	.db $cd $04
	.db $ce $04
	.db $cf $04
@collisions2:
	.db $00

@collisions3:
@collisions4:
	.db $f3 $02
	.db $f4 $02
	.db $f5 $02
	.db $f6 $02
	.db $f7 $02
	.db $48 $02
	.db $49 $02
	.db $4a $02
	.db $4b $02
	.db $d0 $42
	.db $61 $04
	.db $62 $04
	.db $63 $04
	.db $64 $04
	.db $65 $04
	.db $fd $01
	.db $00

@collisions5:
	.db $0c $04
	.db $0d $04
	.db $0e $04
	.db $1a $01
	.db $1b $01
	.db $1c $01
	.db $1d $01
	.db $1e $01
	.db $1f $01
	.db $00

.endif

; Takes an angle as an index.
;
; Used in bank6.specialObjectUpdatePosition. Has something to do with how Link "slides off" tiles
; when he approaches them from the side.
;
slideAngleTable:
	.db $80 $80 $01 $02 $02 $02 $03 $24
	.db $24 $24 $05 $06 $06 $06 $07 $48
	.db $48 $48 $09 $0a $0a $0a $0b $1c
	.db $1c $1c $0d $0e $0e $0e $0f $80

; Takes an angle as an index.
;
; Used in bank6._checkTileIsPassableFromDirection for the specific purpose of determining
; whether an item can pass through a cliff facing a certain direction. Odd values can pass
; through 2 directions, whereas even values can only pass through the direction
; corresponding to the value divided by 2 (see constants/directions.s).
;
angleTable:
	.db $00 $00 $00 $01 $01 $01 $02 $02
	.db $02 $02 $02 $03 $03 $03 $04 $04
	.db $04 $04 $04 $05 $05 $05 $06 $06
	.db $06 $06 $06 $07 $07 $07 $00 $00

;;
; Set an object's X and Y collide radii to 'a'.
;
; @param	a	Collision radius
objectSetCollideRadius:
	push bc
	ld b,a
	ld c,a
	call objectSetCollideRadii
	pop bc
	ret

;;
; Set an object's YX collide radii to bc.
;
; @param	b	Collide radius Y
; @param	c	Collide radius X
objectSetCollideRadii:
	ldh a,(<hActiveObjectType)
	add Object.collisionRadiusY
	ld l,a
	ld h,d
	ld (hl),b
	inc l
	ld (hl),c
	ret

;;
decNumEnemies:
	ld hl,wNumEnemies
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret

;;
setScreenShakeCounter:
	ld hl,wScreenShakeCounterY
	ldi (hl),a
	ld (hl),a
	ret

;;
objectCreatePuff:
	ld b,INTERACID_PUFF

;;
; @param	b	High byte of interaction
objectCreateInteractionWithSubid00:
	ld c,$00

;;
; Create an interaction at the current object's position.
;
; @param	bc	Interaction ID
; @param	d	The object to get the position from
; @param[out]	a	0
; @param[out]	hl	The new interaction's 'speed' variable (one past 'zh')
; @param[out]	zflag	nz if there wasn't a free slot for the interaction
objectCreateInteraction:
	call getFreeInteractionSlot
	ret nz
	ld (hl),b
	inc l
	ld (hl),c
	call objectCopyPosition
	xor a
	ret

;;
objectCreateFallingDownHoleInteraction:
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERACID_FALLDOWNHOLE

	; Store object type in Interaction.counter1
	ld l,Interaction.counter1
	ldh a,(<hActiveObjectType)
	ldi (hl),a

	; Store Object.id in Interaction.counter2
	add Object.id
	ld e,a
	ld a,(de)
	ld (hl),a

	call objectCopyPosition
	xor a
	ret

.ifdef ROM_AGES

;;
; Makes the object invisible if (wFrameCounter&b) == 0.
;
; b=1 will flicker every frame, creating a sort of transparency.
;
; @param	b	Value to AND with [wFrameCounter].
objectFlickerVisibility:
	ld a,(wFrameCounter)
	and b
	jp z,objectSetInvisible
	jp objectSetVisible

;;
; Sets a bit in w2SolidObjectPositions based on the object's current position. Prevents
; you from timewarping on top of an npc.
;
objectMarkSolidPosition:
	call objectGetShortPosition
	ld b,a
	ld a,:w2SolidObjectPositions
	ld ($ff00+R_SVBK),a
	ld a,b
	ld hl,w2SolidObjectPositions
	call setFlag
	ld a,$00
	ld ($ff00+R_SVBK),a
	ret

;;
objectUnmarkSolidPosition:
	call objectGetShortPosition
	ld b,a
	ld a,:w2SolidObjectPositions
	ld ($ff00+R_SVBK),a
	ld a,b
	ld hl,w2SolidObjectPositions
	call unsetFlag
	ld a,$00
	ld ($ff00+R_SVBK),a
	ret

.endif

;;
_interactionActuallyRunScript:
	ldh a,(<hRomBank)
	push af
	ld a,:mainScripts.runScriptCommand
	setrombank
--
	ld a,(hl)
	or a
	jr z,++

	call mainScripts.runScriptCommand
	jr c,--

	pop af
	setrombank
	xor a
	ret
++
	pop af
	setrombank
	scf
	ret

;;
interactionSetHighTextIndex:
	ld e,Interaction.textID+1
	ld (de),a
	ld e,Interaction.useTextID
	set 7,a
	ld (de),a
	ret

;;
; Sets the interaction's script to hl, also resets Interaction.counter variables.
;
; @param	hl	The address of the script
; @param[out]	a	0 (this is assumed by INTERACID_MAMAMU_DOG due to an apparent bug...)
interactionSetScript:
	ld e,Interaction.scriptPtr
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld h,d
	ld l,Interaction.counter1
	xor a
	ldi (hl),a
	ldi (hl),a
	ret

;;
; @param[out]	cflag	Set when the script ends (ran a "scriptend" command)
interactionRunScript:
	ld a,(wLinkDeathTrigger)
	or a
	ret nz

	ld a,(wTextIsActive)
	add a
	jr c,+
	ret nz
+
	; Wait for counter1 to reach 0
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret nz
+
	; Wait for counter2 to reach 0
	ld l,Interaction.counter2
	ld a,(hl)
	or a
	jr z,+

	; If counter2 is nonzero, still update the object's position?
	dec (hl)
	call nz,objectApplySpeed
	xor a
	ret
+
	ld h,d
	ld l,Interaction.scriptPtr
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call _interactionActuallyRunScript
	jr c,+

	call _interactionSaveScriptAddress
	xor a
	ret
+
	call _interactionSaveScriptAddress
	scf
	ret

;;
; @param	hl	Script address
_interactionSaveScriptAddress:
	ld e,Interaction.scriptPtr
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

;;
scriptCmd_asmCall:
	pop hl
	call _scriptFunc_setupAsmCall
	jr ++

;;
scriptCmd_asmCallWithParam:
	pop hl
	call _scriptFunc_setupAsmCall
	ldi a,(hl)
	ld e,a
++
	ldh a,(<hRomBank)
	push af
	ld a,d
	setrombank
	push hl
	ld hl,_scriptCmd_asmRetFunc
	push hl
	ldh a,(<hActiveObject)
	ld d,a
	ld h,b
	ld l,c
	ld a,e
	jp hl

;;
_scriptCmd_asmRetFunc:
	pop hl
	pop af
	setrombank
	ldh a,(<hActiveObject)
	ld d,a
	scf
	ret

;;
_scriptFunc_setupAsmCall:
	inc hl
	ld d,$15
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld b,a
	ret


.ifdef ROM_AGES

; Looks like the management of script addresses differs between games?

;;
; Same as scriptFunc_jump but sets the carry flag.
;
; @param	hl	Current address of script, whose contents point to the address to
;			jump to
scriptFunc_jump_scf:
	call scriptFunc_jump
	scf
	ret

;;
; A script can call this to jump to the address at (hl). This can also handle
; relative jumps in scripts loaded in wBigBuffer, but only within those $100
; bytes.
;
; @param	hl	Current address of script, whose contents point to the address to
;			jump to
scriptFunc_jump:
	ld a,h
	cp $80
	jr c,++

	ldh a,(<hScriptAddressL)
	ld c,a
	ldh a,(<hScriptAddressH)
	ld b,a
	ldi a,(hl)
	sub c
	ld e,a
	ldd a,(hl)
	sbc b
	or a
	jr nz,++

	ld l,e
	ld h,>wBigBuffer
	ret
++
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldh a,(<hActiveObject)
	ld d,a
	xor a
	ret

.else ; ROM_SEASONS

;;
scriptFunc_jump_scf:
	scf
	jr ++

;;
scriptFunc_jump:
	xor a
++
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldh a,(<hActiveObject)
	ld d,a
	ret

.endif

;;
scriptFunc_add3ToHl_scf:
	scf
;;
scriptFunc_add3ToHl:
	inc hl
	inc hl
	inc hl
	ret

;;
scriptCmd_loadScript:
	pop hl
	inc hl
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld c,a
.ifdef ROM_AGES
	ldh (<hScriptAddressL),a
.endif
	ldi a,(hl)
	ld b,a
.ifdef ROM_AGES
	ldh (<hScriptAddressH),a
.endif
	ldh a,(<hRomBank)
	push af
	ld a,e
	setrombank
	ld h,b
	ld l,c
	ld de,wBigBuffer
	ld b,$00
	call copyMemory
	pop af
	setrombank
	ldh a,(<hActiveObject)
	ld d,a
	ld hl,wBigBuffer
	scf
	ret

;;
interactionAnimate:
	ld h,d
	ld l,Interaction.animCounter
	dec (hl)
	ret nz

	ldh a,(<hRomBank)
	push af
	ld a,:interactionAnimationTable
	setrombank
	ld l,Interaction.animPointer
	jr _interactionNextAnimationFrame

;;
; @param	a	Animation index
interactionSetAnimation:
	add a
	ld c,a
	ld b,$00
	ldh a,(<hRomBank)
	push af
	ld a,:interactionAnimationTable
	setrombank
	ld e,Interaction.id
	ld a,(de)
	ld hl,interactionAnimationTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc

;;
_interactionNextAnimationFrame:
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	; Byte 0: how many frames to hold it (or $ff to loop)
	ldi a,(hl)
	cp $ff
	jr nz,++

	; If $ff, animation loops
	ld b,a
	ld c,(hl)
	add hl,bc
	ldi a,(hl)
++
	ld e,Interaction.animCounter
	ld (de),a

	; Byte 1: frame index (store in bc for now)
	ldi a,(hl)
	ld c,a
	ld b,$00

	; Interaction.animParameter
	inc e
	; Byte 2: general-purpose information on animation state? No specific
	; purpose? Some interactions use this to delete themselves when their
	; animation finishes.
	ldi a,(hl)
	ld (de),a

	; Interaction.animPointer
	inc e
	; Save the current position in the animation
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld e,Interaction.id
	ld a,(de)
	ld hl,interactionOamDataTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc

	; Set the address of the oam data
	ld e,Interaction.oamDataAddress
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	and $3f
	or $40
	ld (de),a

	pop af
	setrombank
	ret

;;
; Stops Link from passing through the object.
;
; Used for minecarts, other things?
;
; Also prevents Dimitri from passing through npcs when thrown.
;
; @param[out]	cflag	Set if there's a collision with Link
objectPreventLinkFromPassing:
	ld a,(wLinkCanPassNpcs)
	or a
	ret nz

	ld l,a
	ld a,(wLinkObjectIndex)
	ld h,a
	call preventObjectHFromPassingObjectD
	push af

	; If Dimitri is active, we can't let him pass either while being thrown.
	ld hl,w1Companion.id
	ld a,(hl)
	cp SPECIALOBJECTID_DIMITRI
	jr nz,@end

	ld l,<w1Companion.state
	ld a,(hl)
	cp $02
	jr nz,@end

	call preventObjectHFromPassingObjectD
	jr nc,@end

	ld a,$01
	ld (wDimitriHitNpc),a
@end:
	pop af
	ret

;;
npcFaceLinkAndAnimate:
	ld e,Interaction.knockbackAngle
	ld a,$01
	ld (de),a

	; Wait for this counter to reach 0 before changing directions again
	ld e,Interaction.invincibilityCounter
	ld a,(de)
	or a
	jr nz,+++

	; Face towards Link if within a certain distance, otherwise face down
	ld c,$28
	call objectCheckLinkWithinDistance
	jr c,++
	ld l,Interaction.knockbackAngle
	dec (hl)
	ld a,DIR_DOWN*2
++
	; Convert direction value to angle
	ld b,a
	add a
	add a
	ld h,d
	ld l,Interaction.angle
	cp (hl)
	jr z,interactionAnimateAsNpc

	ld (hl),a

	; Set animation
	srl b
.ifdef ROM_AGES
	ld e,Interaction.var37
	ld a,(de)
	add b
.else
	call seasonsFunc_2678
	ld a,b
.endif
	call interactionSetAnimation

	; Don't change directions again for another 30 frames
	ld e,Interaction.invincibilityCounter
	ld a,30
+++
	dec a
	ld (de),a
	jr interactionAnimateAsNpc


.ifdef ROM_SEASONS
;;
seasonsFunc_2678:
	ld e,Interaction.id
	ld a,(de)
	sub $24
	cp $24
	ret nc
	ld e,Interaction.var37
	ld a,(de)
	add b
	ld b,a
	ret
.endif

;;
; Update animations, push Link away, update draw priority relative to Link, and enable
; "terrain effects" (puddles on water, etc).
interactionAnimateAsNpc:
	call interactionAnimate

;;
interactionPushLinkAwayAndUpdateDrawPriority:
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects

;;
; Return if screen scrolling is disabled?
;
returnIfScrollMode01Unset:
	ld a,(wScrollMode)
	and SCROLLMODE_01
	ret nz
	pop hl
	ret

;;
; Deletes the interaction and returns from the caller if [Interaction.enabled]&3 == 2.
;
interactionDeleteAndRetIfEnabled02:
	ld e,Interaction.enabled
	ld a,(de)
	and $03
	cp $02
	ret nz
	pop hl
	jp interactionDelete

;;
; Converts the angle value at 'de' to a direction value. Diagonals get rounded to the
; closest cardinal direction.
;
; @param	de	Address of an "angle" value
; @param[out]	a	Corresponding "direction" value
convertAngleDeToDirection:
	ld a,(de)

;;
; Converts given angle value to a direction value. Diagonals get rounded to the closest
; cardinal direction.
;
; @param	a	Angle value
; @param[out]	a	Corresponding "direction" value
convertAngleToDirection:
	add $04
	add a
	swap a
	and $03
	ret

;;
; Sets bit 7 of Interaction.enabled, indicating that the interaction should update even
; when scrolling, when textboxes are up, and when bit 1 of wActiveObjects is set.
interactionSetAlwaysUpdateBit:
	ld h,d
	ld l,Interaction.enabled
	set 7,(hl)
	ret

;;
; Checks if link is centered within 4 pixels of the given object, among other things. This
; is used for minecarts to check whether he's in position to get on, although it may also
; be used for other things.
;
; @param[out]	cflag	Set if centered correctly (and various other checks pass)
objectCheckLinkPushingAgainstCenter:
	ld a,(w1Link.id)
	or a
	ret nz

	; Check a directional button is pressed?
	ld a,(wLinkAngle)
	cp $ff
	ret z

	; Return if A or B is pressed
	ld a,(wGameKeysPressed)
	and BTN_A|BTN_B
	ret nz

	ld b,$04
	jp objectCheckCenteredWithLink

;;
; Checks whether the tile adjacent to the interaction (based on its current "angle" value)
; is solid or not.
;
; @param[out]	zflag	Set if the adjacent tile is not solid.
interactionCheckAdjacentTileIsSolid:
	ld e,Interaction.angle
	ld a,(de)
	call convertAngleDeToDirection
	jr ++

;;
; Unused?
;
interactionCheckAdjacentTileIsSolid_viaDirection:
	ld e,Interaction.direction
	ld a,(de)
	sra a
++
	ld hl,@dirOffsets
	rst_addAToHl
	call objectGetShortPosition
	add (hl)
	ld h,>wRoomCollisions
	ld l,a
	ld a,(hl)
	or a
	ret

@dirOffsets:
	.db $f0 $01 $10 $ff



.ifdef ROM_AGES

;;
; @param[out]	zflag	z when counter1 reaches 0 (and text is inactive)
interactionDecCounter1IfTextNotActive:
	ld a,(wTextIsActive)
	or a
	ret nz
	jp interactionDecCounter1

;;
interactionDecCounter1IfPaletteNotFading:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	jp interactionDecCounter1

;;
; Unused?
;
interactionAnimate4Times:
	call interactionAnimate

;;
interactionAnimate3Times:
	call interactionAnimate

;;
interactionAnimate2Times:
	call interactionAnimate
	jp interactionAnimate

;;
; Updates an interaction's animation based on its speed. The faster it is, the faster the
; animation goes.
;
; If counter2 is nonzero, it updates the animation at the slowest speed.
;
interactionAnimateBasedOnSpeed:
	call interactionAnimate
	ld e,Interaction.counter2
	ld a,(de)
	or a
	ret z

	ld e,Interaction.speed
	ld a,(de)
	cp SPEED_100
	ret c

	cp SPEED_200
	jp c,interactionAnimate

	cp SPEED_300
	jp c,interactionAnimate2Times
	jp interactionAnimate3Times

;;
; @param	bc	Position
interactionSetPosition:
	ld h,d

;;
; @param	bc	Position
interactionHSetPosition:
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c
	ret

;;
; Unused?
;
interactionUnsetAlwaysUpdateBit:
	ld h,d
	ld l,Interaction.enabled
	res 7,(hl)
	ret

;;
interactionLoadExtraGraphics:
	ld e,Interaction.id
	ld a,(de)
	ld (wInteractionIDToLoadExtraGfx),a

	; Why... what does this accomplish, other than possibly trashing tree graphics?
	ld (wLoadedTreeGfxIndex),a

	ret

;;
; Unused?
;
interactionFunc_278b:
	ld l,Interaction.scriptPtr
	ld (hl),c
	inc l
	ld (hl),b
	ret

;;
; This isn't used with standard scripts; see the function below.
;
; @param[out]	hl	Value of Interaction.scriptPtr
interactionGetMiniScript:
	ld h,d
	ld l,Interaction.scriptPtr
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ret

;;
; This function seems to be used when interactions code their own, simplistic scripting
; formats. It doesn't seem use standard scripting functions. That said, the contents of
; this function are mostly the same as "interactionSetScript".
;
; Not to be confused with "interactionSetSimpleScript" and related functions later on,
; which is also a very simplistic scripting alternative, but the implementation is defined
; in bank 0 instead of by the "user".
;
; @param	hl	Address of script (it gets written to Interaction.scriptPtr)
interactionSetMiniScript:
	ld e,Interaction.scriptPtr
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

.endif


;;
; Oscillates an object's Z position up and down? (used by Maple)
;
objectOscillateZ:
	ldh a,(<hRomBank)
	push af
	callfrombank0 commonInteractions2.objectOscillateZ_body
	pop af
	setrombank
	ret

;;
; @param	b	Ring to give (overrides the treasure subid?)
; @param	c	var03 for TREASURE_RING (determines if it's in a chest or not,
;			how it spawns in, etc). This should usually be $00?
; @param[out]	zflag	Set if the treasure was given successfully.
giveRingToLink:
	call createRingTreasure
	ret nz
	push de
	ld de,w1Link.yh
	call objectCopyPosition_rawAddress
	pop de
	xor a
	ret

;;
; Creates a "ring" treasure. Doesn't set X/Y coordinates.
;
; @param	b	Ring to give (overrides the treasure subid?)
; @param	c	Subid for TREASURE_RING (determines if it's in a chest or not,
;			how it spawns in, etc)
; @param[out]	zflag	Set if the treasure was created successfully.
createRingTreasure:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),TREASURE_RING
	inc l
	ld (hl),c
	ld l,Interaction.var38
	set 6,b
	ld (hl),b
	xor a
	ret

;;
; Creates a "treasure" interaction (INTERACID_TREASURE). Doesn't initialize X/Y.
;
; @param	bc	Treasure to create (b = main id, c = subid)
; @param[out]	zflag	Set if the treasure was created successfully.
createTreasure:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	xor a
	ret

;;
; Creates an "exclamation mark" interaction, complete with sound effect. Its position is
; at an offset from the current object.
;
; @param	a	How long to show the exclamation mark for (0 or $ff for
;                       indefinitely).
; @param	bc	Offset from the object to create the exclamation mark at.
; @param	d	The object to use for the base position of the exclamation mark.
objectCreateExclamationMark:
	ldh (<hFF8B),a
	ldh a,(<hRomBank)
	push af
	ld a,:commonInteractions5.objectCreateExclamationMark_body
	setrombank
	ldh a,(<hFF8B)
	call commonInteractions5.objectCreateExclamationMark_body
	pop af
	setrombank
	ret

;;
; Creates a floating "Z" letter like someone is snoring.
;
; Unused? (probably used in Seasons for talon)
;
; @param	a	0 to float left, nonzero to float right
; @param	bc	Offset relative to object
objectCreateFloatingSnore:
	ldh (<hFF8B),a
	ld a,$00
	jr ++

;;
; @param	a	0 to float left, nonzero to float right
; @param	bc	Offset relative to object
objectCreateFloatingMusicNote:
	ldh (<hFF8B),a
	ld a,$01
++
	ldh (<hFF8D),a
	ldh a,(<hRomBank)
	push af
	callfrombank0 commonInteractions5.objectCreateFloatingImage
	pop af
	setrombank
	ret

;;
enemyAnimate:
	ld h,d
	ld l,Enemy.animCounter
	dec (hl)
	ret nz

	ldh a,(<hRomBank)
	push af
	ld a,:enemyAnimationTable
	setrombank
	ld l,Enemy.animPointer
	jr _enemyNextAnimationFrame

;;
; @param a Animation index
;
enemySetAnimation:
	add a
	ld c,a
	ld b,$00
	ldh a,(<hRomBank)
	push af
	ld a,:enemyAnimationTable
	setrombank
	ld e,Enemy.id
	ld a,(de)
	ld hl,enemyAnimationTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc

;;
_enemyNextAnimationFrame:
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	; Byte 0: how many frames to hold it (or $ff to loop)
	ldi a,(hl)
	cp $ff
	jr nz,++

	; If $ff, animation loops
	ld b,a
	ld c,(hl)
	add hl,bc
	ldi a,(hl)
++
	ld e,Enemy.animCounter
	ld (de),a

	; Byte 1: frame index (store in bc for now)
	ldi a,(hl)
	ld c,a
	ld b,$00

	; Enemy.animParameter
	inc e
	ldi a,(hl)
	ld (de),a

	; Enemy.animPointer
	inc e
	; Save the current position in the animation
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld e,Enemy.id
	ld a,(de)
	ld hl,enemyOamDataTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc

	; Set the address of the oam data
	ld e,Enemy.oamDataAddress
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	and $3f
	ld (de),a

	pop af
	setrombank
	ret

;;
; See the below functions.
;
enemyDie_uncounted_withoutItemDrop:
	ld b,$80
	jr ++

;;
; Like enemyDie, but there is no random item drop.
;
enemyDie_withoutItemDrop:
	ld b,$81
	jr ++

;;
; Like enemyDie, but wNumEnemies is not decremented. Other kill counters are incremented
; as normal.
;
enemyDie_uncounted:
	ld b,$00
	jr ++

;;
; Kills an enemy in a puff of smoke. wNumEnemies will be decremented, and there will be
; a random item drop (depending on the enemy id?)
;
enemyDie:
	ld b,$01
++
	call @enemyCreateDeathPuff
	bit 0,b
	call nz,markEnemyAsKilledInRoom

	; Update wTotalEnemiesKilled if 1000 have not yet been killed
	ld a,GLOBALFLAG_1000_ENEMIES_KILLED
	call checkGlobalFlag
	jr nz,++

	ld l,<wTotalEnemiesKilled
	call incHlRef16WithCap
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld bc,1000
	call compareHlToBc
	rlca
	ld a,GLOBALFLAG_1000_ENEMIES_KILLED
	call nc,setGlobalFlag
++
	; Update maple kill counter
	ld hl,wMapleKillCounter
	call incHlRefWithCap

	; Update all gasha kill counters
	ld a,GASHA_RING
	call cpActiveRing
	ld a,$ff
	jr z,+
	xor a
+
	ld l,<wGashaSpotKillCounters
	ld c,NUM_GASHA_SPOTS
--
	; Increment [hl] once, or twice if gasha ring is equipped
	rlca
	call c,incHlRefWithCap
	call incHlRefWithCap
	inc l
	dec c
	jr nz,--

	; Increment some counter
	ld a,$03
	call addToGashaMaturity

	jp enemyDelete

;;
; @param	b	Bit 0 set if wNumEnemies should be decremented,
;			Bit 7 set if there should be an item drop.
@enemyCreateDeathPuff:
	; Kill instantly instead of in a puff of smoke if bit 7 of var3f is set
	ld e,Enemy.var3f
	ld a,(de)
	rlca
	jp c,decNumEnemies

	call getFreePartSlot
	ret nz

	; [Part.enabled] = [Enemy.enabled & 3]
	ld e,Enemy.enabled
	ld a,(de)
	and $03
	dec l
	ldi (hl),a

	; Part.id
	ld (hl),PARTID_ENEMY_DESTROYED

	; [Part.subid] = [Enemy.id]
	inc l
	ld e,Enemy.id
	ld a,(de)
	ld (hl),a

	ld l,Part.knockbackCounter
	ld e,Enemy.knockbackCounter
	ld a,(de)
	ld (hl),a

	call objectCopyPosition

	; Use counter2 to tell the part whether to decrement wNumEnemies, and whether to
	; drop a random item.
	ld l,Part.counter2
	ld (hl),b

	ld a,SND_KILLENEMY
	jp playSound

;;
; This function is called for every enemy before calling their regular code.
;
; Knockback and stun counters are updated, and various values are returned in 'c' based on
; the enemy's current status.
;
; The returned value of 'c' from here is moved to 'a' before the enemy-specific code is
; called, so that code can check the return value of this function.
;
; @param[out]	c	"Enemy status" (see constants/enemyStates.s).
;			$00 normally
;			$02 if stunned
;			$03 if health is 0
;			$04 if something hit the enemy?
;			$05 if the enemy is experiencing knockback
enemyStandardUpdate:
	ld h,d
	ld l,Enemy.state
	ld a,(hl)
	or a
	jr z,@uninitialized

	ld l,Enemy.var2a
	bit 7,(hl)
	jr nz,@ret04

	ld e,Enemy.knockbackCounter
	ld a,(de)
	and $7f
	jr nz,@knockback

	; Enemy.health
	dec l
	ld a,(hl)
	or a
	jr z,@healthZero

	; Enemy.stunCounter
	inc e
	ld a,(de)
	or a
	jr nz,@stunned

@ret00:
	ld c,$00
	ret

@uninitialized:
	callab bank3f.enemyLoadGraphicsAndProperties
	call getRandomNumber_noPreserveVars
	ld e,Enemy.var3d
	ld (de),a
	inc e
	ld a,$01
	ld (de),a
	jr @ret00

@ret04:
	ld c,$04
	ret

@knockback:
	ld l,e
	dec (hl)
	ld c,$05
	ret

@healthZero:
	ld l,Enemy.var3f
	bit 1,(hl)
	jr nz,@ret00
	ld c,$03
	ret

@stunned:
	ld a,(wFrameCounter)
	rrca
	jr nc,++

	; Decrement Enemy.stunCounter
	ld l,e
	dec (hl)

	; With 30 frames before being unstunned, make the enemy shake back and forth
	ld a,(hl)
	cp 30
	jr nc,++
	rrca
	jr nc,++

	ld l,Enemy.xh
	ld a,(hl)
	xor $01
	ld (hl),a
++
	; Have the enemy fall down to the ground and bounce

	ld l,Enemy.state
	ld a,(hl)
	cp $08
	jr c,@reachedGround

	ld l,Enemy.zh
	ld a,(hl)
	dec a
	cp $08
	jr c,@reachedGround

	ld c,$20
	call objectUpdateSpeedZAndBounce
	jr nc,@ret02

	ld h,d

@reachedGround:
	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a

@ret02:
	ld c,$02
	ret

;;
partAnimate:
	ld h,d
	ld l,Part.animCounter
	dec (hl)
	ret nz
	ld a,:partAnimationTable
	setrombank
	ld l,Part.animPointer
	jr _partNextAnimationFrame

;;
partSetAnimation:
	add a
	ld c,a
	ld b,$00
	ld a,:partAnimationTable
	setrombank
	ld e,$c1
	ld a,(de)
	ld hl,partAnimationTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc

;;
; Note: this sets the ROM bank to $11 before returning.
;
_partNextAnimationFrame:
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	; Byte 0: how many frames to hold it (or $ff to loop)
	ldi a,(hl)
	cp $ff
	jr nz,+

	; If $ff, animation loops
	ld b,a
	ld c,(hl)
	add hl,bc
	ldi a,(hl)
+
	ld e,Part.animCounter
	ld (de),a

	; Byte 1: frame index (store in bc for now)
	ldi a,(hl)
	ld c,a
	ld b,$00

	; Item.animParameter
	inc e
	ldi a,(hl)
	ld (de),a

	; Item.animPointer
	inc e
	; Save the current position in the animation
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld e,Part.id
	ld a,(de)
	ld hl,partOamDataTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc

	; Set the address of the oam data
	ld e,Part.oamDataAddress
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	and $3f
	or $40
	ld (de),a

	ld a,PART_BANK
	setrombank
	ret

;;
; Creates an energy swirl going towards the given point.
;
; @param	bc	Center of the swirl
; @param	a	Duration of swirl ($ff and $00 are infinite?)
createEnergySwirlGoingIn:
	ld l,a
	ldh a,(<hRomBank)
	push af
	callfrombank0 partCode.createEnergySwirlGoingIn_body
	pop af
	setrombank
	ret

;;
; Creates an energy swirl going away from the given point.
;
; @param	bc	Center of the swirl
; @param	a	Duration of swirl ($ff and $00 are infinite?)
createEnergySwirlGoingOut:
	ld l,a
	ldh a,(<hRomBank)
	push af
	callfrombank0 partCode.createEnergySwirlGoingOut_body
	pop af
	setrombank
	ret

;;
; Reads wLinkAngle, and returns in 'a' the value that would correspond to the direction
; buttons for moving in that direction.
;
; Why not read directly from wGameKeysPressed? Well, there may be scenarios where it
; doesn't match up with what you want, such as when Link's movement is reversed in the
; final fight.
;
; @param[out]	a	Direction buttons that correspond to wLinkAngle
convertLinkAngleToDirectionButtons:
	ld a,(wLinkAngle)
	add a
	jr c,+

	add a
	swap a
	push hl
	ld hl,@data
	rst_addAToHl
	ld a,(hl)
	pop hl
	ret
+
	xor a
	ret

@data:
	.db BTN_UP
	.db BTN_UP|BTN_RIGHT
	.db BTN_RIGHT
	.db BTN_DOWN|BTN_RIGHT
	.db BTN_DOWN
	.db BTN_DOWN|BTN_LEFT
	.db BTN_LEFT
	.db BTN_UP|BTN_LEFT

;;
; Sets wSimulatedInputAddress/Bank to the given values, and initializes everything to
; start reading from there.
;
; @param	a 	Simulated input bank
; @param	hl	Simulated input address
setSimulatedInputAddress:
	ld de,wSimulatedInputBank
	ld (de),a
	inc e
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	; [wSimulatedInputCounter] = 0
	ld e,<(wSimulatedInputCounter+1)
	xor a
	ld (de),a
	dec e
	ld (de),a

	; [wUseSimulatedInput] = 1
	dec e
	inc a
	ld (de),a

	jp clearPegasusSeedCounter

;;
; Returns preset input values. Used for cutscenes (ie. the intro).
;
; @param[out]	a	Value to be written to wGameKeysPressed
getSimulatedInput:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wUseSimulatedInput)
	rlca
	jr c,@returnInput

	ld hl,wSimulatedInputCounter
	call decHlRef16WithCap
	jr nz,@returnInput

	ldh a,(<hRomBank)
	push af
	ld hl,wSimulatedInputBank
	ldi a,(hl)
	setrombank
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ldi a,(hl)
	ld (wSimulatedInputCounter),a
	ldi a,(hl)
	ld (wSimulatedInputCounter+1),a

	; If the counter (frames to wait) was $8000 or greater, stop reading inputs.
	bit 7,a
	jr z,+

	ld a,$ff
	ld (wUseSimulatedInput),a
	jr ++
+
	ldi a,(hl)
	ld (wSimulatedInputValue),a
++
	pop af
	setrombank

	ld a,l
	ld (wSimulatedInputAddressL),a
	ld a,h
	ld (wSimulatedInputAddressH),a

@returnInput:
	ld a,(wSimulatedInputValue)
	ret

;;
; Sets Item.state to 'a', and Item.substate to 0.
;
; @param	a	Value for Item.state
itemSetState:
	ld h,d
	ld l,Item.state
	ldi (hl),a
	ld (hl),$00
	ret

;;
clearPegasusSeedCounter:
	ld hl,wPegasusSeedCounter
	xor a
	ldi (hl),a
	ld (hl),a
	ret

;;
; Resets some Link variables - primarily his Z position - and resets his animation?
putLinkOnGround:
	; Return if Link is riding something
	ld a,(wLinkObjectIndex)
	rrca
	ret c

	push de

	; Put Link on the ground
	xor a
	ld (wLinkInAir),a
	ld hl,w1Link.speedZ
	ldi (hl),a
	ldi (hl),a
	ld l,<w1Link.z
	ldi (hl),a
	ldi (hl),a

	ld l,<w1Link.id
	ld a,(hl)
	or a
	jr nz,@end

	ld d,h
	ld a,LINK_ANIM_MODE_WALK
	call specialObjectSetAnimation
@end:
	pop de
	ret

;;
; Sets wLinkForceState to LINK_STATE_08.
setLinkForceStateToState08:
	xor a

;;
; Sets wLinkForceState to LINK_STATE_08, and wcc50 to the given value.
;
; @param	a	Value for wcc50
setLinkForceStateToState08_withParam:
	push hl

	; Clear wcc50, it seems to be used differently based on the state
	ld hl,wcc50
	ldd (hl),a

	; Set wLinkForceState
	ld (hl),LINK_STATE_08
	pop hl
	ret

;;
; Reads w1Link.damageToApply and applies that to his health.
;
; Parameter 'd' does not need to be passed as the Link object.
linkApplyDamage:
	push de
	ldh a,(<hRomBank)
	push af
	ld d,>w1Link
	callfrombank0 bank5.linkApplyDamage_b5
	pop af
	setrombank
	pop de
	ret

;;
; This will force Link's ID to change next time "updateSpecialObjects" is called. Also
; clears subid, var03, state, and substate.
;
; @param	a	Link ID value (see constants/specialObjectTypes.s)
setLinkIDOverride:
	or $80
	ld (wLinkIDOverride),a
	ld hl,w1Link.subid
	jr ++

;;
; Sets link's ID and clears w1Link.subid, var03, state, substate.
;
; @param	a	New value for w1Link.id
setLinkID:
	ld hl,w1Link.id
	ldi (hl),a
++
	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ret

;;
; Sends Link back to his spawn point for the room. Also damages him maybe?
;
respawnLink:
	ld a,LINK_STATE_RESPAWNING
	ld (wLinkForceState),a
	ld a,$02
	ld (wLinkStateParameter),a
	or d
	ret

;;
; @param	d	Special object index (link or companion)
specialObjectAnimate:
	ld h,d
	ld l,SpecialObject.animCounter
	dec (hl)
	ret nz

	ldh a,(<hRomBank)
	push af
	ld a,:bank6.specialObjectNextAnimationFrame
	setrombank
	ld l,SpecialObject.animPointer
	call bank6.specialObjectNextAnimationFrame
	pop af
	setrombank
	ret

;;
; @param	a	Animation (see constants/linkAnimations.s)
; @param	d	Special object index
specialObjectSetAnimation:
	ld e,SpecialObject.animMode
	ld (de),a
	add a
	ld c,a
	ld b,$00
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank6.specialObjectSetAnimation_body
	pop af
	setrombank
	ret

;;
loadLinkAndCompanionAnimationFrame:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank6.loadLinkAndCompanionAnimationFrame_body
	pop af
	setrombank
	ret

;;
; Check if link is pushing against a wall. This is checked to set his animation as well as
; whether he should do a sword poke.
;
; @param[out]	cflag	Set if link is pushing against a wall.
checkLinkPushingAgainstWall:
	push hl
	ld a,(w1Link.direction)
	ld hl,@collisionDirections
	rst_addDoubleIndex

	; Check that he's facing a wall
	ld a,(w1Link.adjacentWallsBitset)
	and (hl)
	cp (hl)
	jr nz,++

	; Check that he's trying to move towards the wall
	inc hl
	ld a,(wGameKeysPressed)
	and (hl)
	jr z,++

	pop hl
	scf
	ret
++
	pop hl
	xor a
	ret

@collisionDirections:
	.db $c0 $40
	.db $03 $10
	.db $30 $80
	.db $0c $20

;;
; Updates w1Companion.direction based on wLinkAngle.
;
; @param[out]	cflag	Set if direction changed.
updateCompanionDirectionFromAngle:
	push bc
	push hl
	ld hl,w1Companion.direction
	jr ++

;;
; Updates w1Link.direction based on wLinkAngle.
;
; @param[out]	cflag	Set if direction changed.
updateLinkDirectionFromAngle:
	push bc
	push hl
	ld hl,w1Link.direction
++
	ld b,(hl)
	ld a,(wLinkAngle)
	cp $ff
	jr z,@end

	; Reduce the angle to the 8 directions you can move in
	and $1c
	rrca
	rrca

	; Check for diagonal movement
	rra
	jr nc,++

	; If diagonal, check whether the current direction makes up one of the components
	; of the diagonal; if so, don't modify it.
	ld c,a
	sub b
	inc a
	and $02
	jr z,@end
	ld a,c
++
	cp (hl)
	jr z,@end
	ld (hl),a
	ld b,a
	scf
@end:
	ld a,b
	pop hl
	pop bc
	ret

;;
specialObjectSetCoordinatesToRespawnYX:
	ld h,d
	ld l,SpecialObject.direction
	ld a,(wLinkLocalRespawnDir)
	ldi (hl),a

	; SpecialObject.angle = $ff
	ld a,$ff
	ldi (hl),a

	ld (wLinkPathIndex),a

	; Copy respawn coordinates to y/x
	ld l,SpecialObject.yh
	ld a,(wLinkLocalRespawnY)
	ldi (hl),a
	inc l
	ld a,(wLinkLocalRespawnX)
	ldi (hl),a

	; Set z position to 0
	xor a
	ldi (hl),a
	ldi (hl),a

	ld l,SpecialObject.knockbackCounter
	ld (hl),a
	ret

;;
; Clear variables related to link's invincibility, knockback, etc.
resetLinkInvincibility:
	ld hl,w1Link.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a

	; Clear collisionType, damageToApply
	ld l,<w1Link.collisionType
	xor a
	ldi (hl),a
	ldi (hl),a

	ld l,<w1Link.damage
	ldi (hl),a

	; Clear:
	; var2a
	; invincibilityCounter
	; knockbackAngle
	; knockbackCounter
	; stunCounter
	inc l
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ret

;;
; Decrements wPegasusSeedCounter. This decrements it twice unless the Pegasus Ring is
; equipped, which doubles their duration.
;
; @param[out]	zflag	Set if wPegasusSeedCounter is zero.
decPegasusSeedCounter:
	ld hl,wPegasusSeedCounter+1
	res 7,(hl)
	dec l
	ld b,$00
	ld c,$07
	ld a,PEGASUS_RING
	call cpActiveRing
	jr z,+

	ld c,$0f
	call decHlRef16WithCap
	ret z
	ld a,(hl)
	and c
	jr nz,+
	ld b,$80
+
	call decHlRef16WithCap
	ret z
	ldi a,(hl)
	and c
	jr nz,+
	ld b,$80
+
	; Set bit 15 of wPegasusSeedCounter when dust should be created at Link's feet
	ld a,(hl)
	or b
	ldd (hl),a
	ret

;;
; @param[out]	a	The high byte of wPegasusSeedCounter
; @param[out]	zflag	Set if wPegasusSeedCounter is zero
checkPegasusSeedCounter:
	ld hl,wPegasusSeedCounter
	ldi a,(hl)
	or (hl)
	ldd a,(hl)
	ret

;;
; Try to break a tile at the given item's position.
;
; @param	a	The type of collision (see constants/breakableTileSources.s)
; @param[out]	cflag	Set if the tile was broken (or can be broken)
itemTryToBreakTile:
	ld h,d
	ld l,Item.yh
	ld b,(hl)
	ld l,Item.xh
	ld c,(hl)
;;
; See bank6.tryToBreakTile for a better description.
;
; @param	a	The type of collision (see constants/breakableTileSources.s)
;			If bit 7 is set, it will only check if the tile is breakable; it
;			won't actually break it.
; @param	bc	The YYXX position
; @param[out]	cflag	Set if the tile was broken (or can be broken)
tryToBreakTile:
	ldh (<hFF8F),a
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank6.tryToBreakTile_body
	rl e
	pop af
	setrombank
	rr e
	ret

;;
; Calls bank6._clearAllParentItems.
clearAllParentItems:
	ld c,$00
	jr ++

;;
; Calls bank6._updateParentItemButtonAssignment_body.
;
; Updates var03 of a parent item to correspond to the equipped A or B button item. This is
; called after closing a menu (since button assignments may be changed).
;
updateParentItemButtonAssignment:
	ld c,$01
	jr ++

;;
; Calls bank6.checkUseItems, which checks the A and B buttons and creates corresponding
; item objects if necessary.
;
checkUseItems:
	ld c,$02
++
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank6.functionCaller
	pop af
	setrombank
	ret

;;
objectAddToGrabbableObjectBuffer:
	ld hl,wGrabbableObjectBuffer
--
	inc l
	bit 7,(hl)
	jr z,++

	inc l
	ld a,l
	cp <wGrabbableObjectBufferEnd
	jr c,--
	ret
++
	ld a,d
	ldd (hl),a
	ldh a,(<hActiveObjectType)
	ld (hl),a
	ret

;;
; Drops an item being held by Link?
;
dropLinkHeldItem:
	ld a,(wInShop)
	or a
	jr nz,@end

	; Check that 2 <= [wLinkGrabState]&7 < 4
	ld a,(wLinkGrabState)
	and $07
	sub $02
	cp $02
	jr nc,@end

	; Get the object Link is holding in hl
	ld hl,w1Link.relatedObj2
	ldi a,(hl)
	ld h,(hl)
	add Object.state
	ld l,a

	; Check Object.state
	ldi a,(hl)
	cp $02
	jr nz,@end

	; Write $03 to Object.substate (means it's no longer being held?)
	ld a,$03
	ld (hl),a

	ld a,l
	add Object.angle-Object.substate
	ld l,a
	ld (hl),$ff
@end:
	xor a
	ld (wLinkGrabState),a
	ld (wLinkGrabState2),a
	ret

;;
; Clears var3f for w1ParentItem2-5. Relates to the animation link does as he uses the
; item?
;
clearVar3fForParentItems:
	ld hl,w1ParentItem2.var3f
--
	ld (hl),$00
	inc h
	ld a,h
	cp WEAPON_ITEM_INDEX
	jr c,--
	ret

;;
; Creates a spash at Link's position. Whether it's normal water or lava depends on the
; wLinkSwimmingState variable.
;
; @param	d	Link object
linkCreateSplash:
	ld b,INTERACID_SPLASH

	; Check if in lava; if so, set b to INTERACID_LAVASPLASH.
	ld a,(wLinkSwimmingState)
	bit 6,a
	jr z,+
	inc b
+
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jp z,objectCreateInteractionWithSubid00

	; If in a sidescrolling area, create the interaction at an offset to Link's
	; position.
	call getFreeInteractionSlot
	ret nz
	ld (hl),b
	ld bc,$fd00
	jp objectCopyPositionWithOffset

;;
clearVariousLinkVariables:
	xor a
	ld (w1Link.var36),a
	ld (w1Link.speed),a
	ld (w1Link.var3e),a
	ld (w1Link.var12),a
	dec a
	ld (w1Link.angle),a
	ret

;;
; LINK_STATE_SPINNING_FROM_GALE
;
; Not sure why this is in bank 0 instead of bank 5.
;
linkState07:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw specialObjectAnimate
	.dw @substate2


; Initialization (just touched a gale seed)
@substate0:
	; Cancel item usage
	call bank5.linkCancelAllItemUsageAndClearAdjacentWallsBitset

	call itemIncSubstate

	xor a
	ld l,SpecialObject.collisionType
	ld (hl),a

	call clearVariousLinkVariables

	ld a,$80
	ld (wLinkInAir),a
	ld a,LINK_ANIM_MODE_GALE
	jp specialObjectSetAnimation

; Falling down after cancelling from the gale seed menu
@substate2:
	xor a
	ld (wLinkInAir),a
	ld a,TRANSITION_DEST_FALL
	ld (wWarpTransition),a

	ld e,SpecialObject.yh
	ld a,(de)
	add $04
	ld (de),a

	ld a,LINK_STATE_WARPING
	jp bank5.linkSetState

;;
itemDelete:
	ld h,d
	ld l,Item.start
	ld b,$10
	xor a
--
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	dec b
	jr nz,--
	ret

;;
; Updates an item's angle based on its direction.
;
; @param[out]	hl	Item.direction
itemUpdateAngle:
	ld h,d
	ld l,Item.direction
	ldi a,(hl)
	swap a
	rrca
	ldd (hl),a
	ret

;;
; @param[out]	zflag	nz on failure.
getFreeItemSlot:
	ldhl FIRST_DYNAMIC_ITEM_INDEX, Item.start
-
	ld a,(hl)
	or a
	ret z

	inc h
	ld a,h
	cp LAST_DYNAMIC_ITEM_INDEX+1
	jr c,-

	or h
	ret

;;
introThreadStart:
	ld hl,wIntro.frameCounter
	inc (hl)
	callfrombank0 bank3Cutscenes.runIntro
	call resumeThreadNextFrame
	jr introThreadStart

;;
; This runs everything after the "nintendo/capcom" logo and before the titlescreen.
intro_cinematic:
	ldh a,(<hRomBank)
	push af

	callfrombank0 bank3Cutscenes.runIntroCinematic
	callfrombank0 bank5.updateSpecialObjects
	call          loadLinkAndCompanionAnimationFrame
	callfrombank0 animationAndUniqueGfxData.updateAnimations
	call          updateInteractionsAndDrawAllSprites

	pop af
	setrombank
	ret

;;
; Relates to the movement of the triforce pieces in the intro?
;
; @param	b
; @param[out]	b
func_2d48:
	ldh a,(<hRomBank)
	push af

.ifdef ROM_AGES
	ld a,:bank3f.data_5951
.else
	ld a,:bank3Cutscenes.data_5951
.endif
	setrombank
	ld a,b
.ifdef ROM_AGES
	ld hl,bank3f.data_5951
.else
	ld hl,bank3Cutscenes.data_5951
.endif
	rst_addAToHl
	ld b,(hl)

	pop af
	setrombank
	ret

;;
; wram bank 1 loaded on return.
clearFadingPalettes:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3Cutscenes.clearFadingPalettes_body
	pop af
	setrombank
	ret

;;
; This function causes the screen to flash white. Based on parameter 'b', which acts as
; the "index" of the data to use, this will read through the predefined data to see on
; what frames it should turn the screen white, and on what frames it should restore the
; screen to normal.
;
; @param	b	Index of "screen flashing" data
; @param	hl	Counter to use (should start at 0?)
; @param[out]	zflag	nz if the flashing is complete (all data has been read).
flashScreen:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3Cutscenes.flashScreen_body
	ld b,$01
	jr nz,+
	dec b
+
	pop af
	setrombank
	ld a,b
	or a
	ret

;;
; SpecialObject code for IDs $0f-$12
specialObjectCode_companionCutscene:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank6.specialObjectCode_companionCutscene
	pop af
	setrombank
	ret

;;
specialObjectCode_linkInCutscene:

.ifdef ROM_SEASONS

	ldh a,(<hRomBank)
	push af
	callfrombank0 bank6.specialObjectCode_linkInCutscene
	pop af
	setrombank
	ret

.else ; ROM_AGES
	jpab bank6.specialObjectCode_linkInCutscene
.endif

;;
; Load dungeon layout if currently in a dungeon.
loadDungeonLayout:
	ld a,(wTilesetFlags)
	and TILESETFLAG_DUNGEON
	ret z

	ldh a,(<hRomBank)
	push af
	callfrombank0 bank1.loadDungeonLayout_b01
	pop af
	setrombank
	ret

;;
initializeDungeonStuff:
	xor a
	ld (wToggleBlocksState),a
	ld (wSwitchState),a
	ld (wSpinnerState),a
	jp loadStaticObjects

;;
setVisitedRoomFlag:
	call getThisRoomFlags
	set ROOMFLAG_BIT_VISITED, (hl)
	ret

;;
; Sets wDungeonRoomProperties to this room's dungeon flag value, also returns
; value in a
;
; @param[out]	a	Dungeon properties
getThisRoomDungeonProperties:
	ldh a,(<hRomBank)
	push af
	ld a, :bank1.dungeonRoomPropertiesGroupTable
	setrombank
	ld a,(wActiveGroup)
	sub $04
	and $01
	ld hl, bank1.dungeonRoomPropertiesGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wActiveRoom)
	ld b,$00
	ld c,a
	add hl,bc
	ld a,(hl)
	ld (wDungeonRoomProperties),a
	pop af
	setrombank
	ret

;;
; Get the address of the dungeon layout in RAM in hl (wram bank 2)
;
getDungeonLayoutAddress:
	push bc
	push de
	ld a,(wDungeonFloor)
	ld c,$40
	call multiplyAByC
	ld bc, w2DungeonLayout
	add hl,bc
	pop de
	pop bc
	ret

;;
; Get the current room index.
;
; @param[out]	a	Current room index
getActiveRoomFromDungeonMapPosition:
	ld a,(wDungeonMapPosition)

;;
; Get the room at minimap position A on the current floor.
;
; @param	a	Minimap position
; @param[out]	a,l	Room at that position
getRoomInDungeon:
	ldh (<hFF8B),a
	ld a, :w2DungeonLayout
	ld ($ff00+R_SVBK),a
	call getDungeonLayoutAddress
	ldh a,(<hFF8B)
	rst_addAToHl
	ld l,(hl)
	xor a
	ld ($ff00+R_SVBK),a
	ld a,l
	ret


.ifdef ROM_SEASONS
	.include "code/code_3035.s"
.endif


;;
getFreeEnemySlot:
	call getFreeEnemySlot_uncounted
	ret nz
	ld a,(wNumEnemies)
	inc a
	ld (wNumEnemies),a
	xor a
	ret

;;
getFreeEnemySlot_uncounted:
	ldhl FIRST_ENEMY_INDEX, Enemy.start
--
	ld a,(hl)
	or a
	jr z,+
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,--
	or h
	ret
+
	inc a
	ldi (hl),a
	xor a
	ret

;;
enemyDelete:
	ld e,Enemy.enabled
	call objectRemoveFromAButtonSensitiveObjectList
	ld l,e
	ld h,d
	ld b,$10
	xor a
-
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	dec b
	jr nz,-
	ret

;;
; Deletes the enemy (clears its memory), then replaces its ID with the new value.
;
; The new object keeps its former yh, xh, zh, and enabled values.
;
; Mostly equivalent to the "objectReplaceWithID" function, but only for enemies.
;
; @param	bc	New enemy ID
enemyReplaceWithID:
	ld h,d
	push bc

	; Store Enemy.enabled, Y position
	ld l,Enemy.enabled
	ld b,(hl)
	ld l,Enemy.yh
	ld c,(hl)
	push bc

	; Store X, Z
	ld l,Enemy.xh
	ld b,(hl)
	ld l,Enemy.zh
	ld c,(hl)
	push bc

	; Delete enemy
	call enemyDelete

	; Restore X/Y/Z positions
	pop bc
	ld l,Enemy.zh
	ld (hl),c
	ld l,Enemy.xh
	ld (hl),b
	pop bc
	ld l,Enemy.yh
	ld (hl),c

	; Restore Enemy.enabled (not all bits?)
	ld l,Enemy.enabled
	ld a,b
	and $73
	ldi (hl),a

	; Set Enemy.id, subid
	pop bc
	ld (hl),b
	inc l
	ld (hl),c
	ret

;;
; Update all enemies with 'state' variables equal to 0.
_updateEnemiesIfStateIsZero:
	ld a,Enemy.start
	ldh (<hActiveObjectType),a
	ld d,FIRST_ENEMY_INDEX
	ld a,d
--
	ldh (<hActiveObject),a
	ld h,d
	ld l,Enemy.enabled
	ld a,(hl)
	or a
	jr z,@next

	ld l,Enemy.state
	ldi a,(hl)
	or (hl)
	call z,updateEnemy
	ld e,Enemy.oamFlagsBackup
	ld a,(de)
	inc e
	ld (de),a
@next:
	inc d
	ld a,d
	cp LAST_ENEMY_INDEX+1
	jr c,--
	ret

;;
; Update all enemies by calling their enemy-specific code and doing other common enemy
; stuff.
;
updateEnemies:
	ld a,(wScrollMode)
	and $0e
	jr nz,_updateEnemiesIfStateIsZero

	ld a,(wTextIsActive)
	or a
	jr nz,_updateEnemiesIfStateIsZero

	ld a,(wDisabledObjects)
	and $84
	jr nz,_updateEnemiesIfStateIsZero

	ld a,(wPaletteThread_mode)
	or a
	jr nz,_updateEnemiesIfStateIsZero

	ld a,Enemy.start
	ldh (<hActiveObjectType),a
	ld d,FIRST_ENEMY_INDEX
	ld a,d
--
	ldh (<hActiveObject),a

	ld e,Enemy.enabled
	ld a,(de)
	or a
	jr z,@next

	call updateEnemy

	; Reset bit 7 of var2a to indicate that, if any collision has occurred, it's no
	; longer the first frame of the collision.
	ld h,d
	ld l,Enemy.var2a
	res 7,(hl)

	; Increment/decrement invincibilityCounter if applicable, update palette
	inc l
	ld a,(hl) ; a = [enemy.invincibilityCounter]
	or a
	jr z,@label_00_349

	rlca
	jr c,@label_00_348

	dec (hl)
	jr z,@label_00_349

	ld a,(wFrameCounter)
	bit 2,a
	jr nz,@label_00_349

	ld b,$05
	ld l,Enemy.oamFlagsBackup
	ldi a,(hl)
	and $07
	cp b
	jr nz,+
	ld b,$02
+
	ld a,(hl)
	and $f8
	or b
	ld (hl),a
	jr @next

@label_00_348:
	inc (hl)
@label_00_349:
	ld l,Enemy.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a
@next:
	inc d
	ld a,d
	cp LAST_ENEMY_INDEX+1
	jr c,--
	ret

;;
; @param	d	Enemy to update
updateEnemy:
	call enemyStandardUpdate
	ld e,Enemy.id
	ld a,(de)

.ifdef ROM_AGES
	; Calculate bank number in 'b'
	ld b,$0f
	cp $70
	jr nc,++
	dec b
	cp $30
	jr nc,++
	dec b
	cp $08
	jr nc,++
	ld b,$10

.else ; ROM_SEASONS

	ld b,$0f
	cp $08
	jr c,+
	dec b
	cp $70
	jr nc,+
	dec b
	cp $30
	jr nc,+
	dec b
+
	; Seasons sets the rom bank here instead of later, for no particular reason...?
	ld e,a
	ld a,b
	setrombank
	ld a,e
.endif

++
	; hl = enemyCodeTable + a*2
	add a
	add <enemyCodeTable
	ld l,a
	ld a,$00
	adc >enemyCodeTable
	ld h,a

	ldi a,(hl)
	ld h,(hl)
	ld l,a
.ifdef ROM_AGES
	ld a,b
	setrombank
.endif
	ld a,c
	or a
	jp hl

.include "data/enemyCodeTable.s"


.ifdef ROM_AGES
	.include "code/code_3035.s"
.endif


;;
; Called when loading a room.
;
; Note: ages doesn't save the bank number properly when something calls this, so it only
; works when called from bank 1 (same bank as "checkLoadPirateShip").
initializeRoom:

.ifdef ROM_AGES
	callab bank1.clearSolidObjectPositions

	ld a,(wSentBackByStrangeForce)
	dec a
	jr nz,+

	ld b,INTERACID_SCREEN_DISTORTION
	jp objectCreateInteractionWithSubid00
+
	callab roomInitialization.calculateRoomStateModifier
	call   refreshObjectGfx
	callab roomSpecificCode.runRoomSpecificCode
	callab roomInitialization.createSeaEffectsPartIfApplicable
	callab bank1.checkLoadPirateShip

	ldh a,(<hRomBank)
	push af
	ld a,:roomInitialization.checkAndSpawnMaple
	setrombank

	call checkSpawnTimeportalInteraction

	ld a,(wcc05)
	bit 2,a
	call nz,roomInitialization.loadRememberedCompanion

	ld a,(wcc05)
	bit 3,a
	call nz,roomInitialization.checkAndSpawnMaple

	ld a,:objectData.parseObjectData
	setrombank
	ld a,(wcc05)
	bit 0,a
	call nz,objectData.parseObjectData

.else ; ROM_SEASONS
	call          refreshObjectGfx

	ldh a,(<hRomBank)
	push af

	callfrombank0 roomInitialization.loadRememberedCompanion
	call          roomInitialization.checkAndSpawnMaple
	call          roomInitialization.updateRosaDateStatus
	callfrombank0 objectData.parseObjectData
.endif

	callfrombank0 staticObjects.parseStaticObjects

	pop af
	setrombank
	ret


;;
; @param	hl	Address of interaction data to parse
parseGivenObjectData:
	ldh a,(<hRomBank)
	push af
	ld a, :objectData.parseGivenObjectData
	setrombank
	push de
	ld d,h
	ld e,l
	call objectData.parseGivenObjectData
	pop de
	pop af
	setrombank
	ret

;;
; Checks if there are any "static objects" in the room to load.
loadStaticObjects:
	ldh a,(<hRomBank)
	push af
	ld a,:staticObjects.loadStaticObjects_body
	setrombank
	push de
	call staticObjects.loadStaticObjects_body
	pop de
	pop af
	setrombank
	ret

;;
clearStaticObjects:
	ld hl,wStaticObjects
	ld b,_sizeof_wStaticObjects
	jp clearMemory

;;
; Search wStaticObjects to find a slot (8 bytes) which is unused.
;
; @param[out]	hl	Address of free slot (if successful)
; @param[out]	zflag	Set on success
findFreeStaticObjectSlot:
	ld hl,wStaticObjects
.ifdef ROM_AGES
	ld b,$08
.endif
--
	ld a,(hl)
	or a
	ret z

	ld a,$08
	add l
	ld l,a
.ifdef ROM_AGES
	dec b
.endif
	jr nz,--

	or h
	ret

;;
; Deletes the object which the relatedObj1 variable points to, assuming it points to
; a "static" object (stored in wStaticObjects).
objectDeleteRelatedObj1AsStaticObject:
	ldh a,(<hActiveObjectType)
	add Object.relatedObj1
	ld l,a
	ld h,d
	ldi a,(hl)
	ld h,(hl)
	ld e,l
	ld l,a
	or h
	ret z

	; de still points to relatedObj1; clear it
	xor a
	ld (de),a
	dec e
	ld (de),a

	; Delete the related object (only 8 bytes since it's a static object)
	ld e,$08
--
	ldi (hl),a
	dec e
	jr nz,--
	ret

;;
; Saves an object to a "static object" slot, which persists between rooms.
;
; @param	a	Static object type (see constants/staticObjectTypes.s)
; @param	d	Object
; @param	hl	Address in wStaticObjects
objectSaveAsStaticObject:
	ld (hl),a
	ldh a,(<hActiveObjectType)
	add Object.relatedObj1
	ld e,a

	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld a,(wActiveRoom)
	inc hl
	ldi (hl),a

	; Store Object.id
	ldh a,(<hActiveObjectType)
	inc a
	ld e,a
	ld a,(de)
	ldi (hl),a

	; Store Object.subid
	inc e
	ld a,(de)
	ldi (hl),a

	; Store y,x
	ld a,e
	add Object.yh-Object.subid
	ld e,a
	ld a,(de)
	ldi (hl),a
	inc e
	inc e
	ld a,(de)
	ldi (hl),a
	ret

;;
; @param	a	Global flag to check (see constants/globalFlags.s)
checkGlobalFlag:
	ld hl,wGlobalFlags
	jp checkFlag

;;
; @param	a	Global flag to set
setGlobalFlag:
	ld hl,wGlobalFlags
	jp setFlag

;;
; @param	a	Global flag to unset
unsetGlobalFlag:
	ld hl,wGlobalFlags
	jp unsetFlag


;;
; Calls bank2._clearEnemiesKilledList.
;
clearEnemiesKilledList:
	ld h,$00
	.ifdef ROM_AGES
	jr ++
	.else
	jp ++
	.endif

;;
; Calls bank2._addRoomToEnemiesKilledList.
;
addRoomToEnemiesKilledList:
	ld h,$01
	.ifdef ROM_AGES
	jr ++
	.else
	jp ++
	.endif

;;
; Marks an enemy as killed so it doesn't respawn for a bit.
; Calls bank2._markEnemyAsKilledInRoom.
;
markEnemyAsKilledInRoom:
	ld h,$02
	.ifdef ROM_AGES
	jr ++
	.else
	jp ++
	.endif

;;
; Calls bank2._stub_02_77f4. (Unused)
;
func_3211:
	ld h,$03
	.ifdef ROM_AGES
	jr ++
	.else
	jp ++
	.endif

;;
; Places the numbers $00-$ff into w4RandomBuffer in a random order.
; Calls bank2.generateRandomBuffer.
;
generateRandomBuffer:
	ld h,$04
	.ifdef ROM_AGES
	jr ++
	.else
	jp ++
	.endif

;;
; Get a random position for an enemy and store it in wEnemyPlacement.enemyPos.
; Calls bank2._getRandomPositionForEnemy.
;
; @param	hFF8B	"Flags" (set when placing an enemy in the editor)
getRandomPositionForEnemy:
	ld h,$05
	.ifdef ROM_AGES
	jr ++
	.else
	jp ++
	.endif


.ifdef ROM_AGES

;;
; Calls bank2._checkSpawnTimeportalInteraction.
;
checkSpawnTimeportalInteraction:
	ld h,$06

.endif

++
	ld l,a
	ldh a,(<hRomBank)
	push af
	callfrombank0 roomInitialization.functionCaller
	rl c
	pop af
	setrombank
	srl c
	ret

;;
clearPaletteFadeVariablesAndRefreshPalettes:
	ld a,$ff
	ldh (<hDirtyBgPalettes),a
	ldh (<hDirtySprPalettes),a
;;
clearPaletteFadeVariables:
	xor a
	ld (wPaletteThread_mode),a
	ld (wPaletteThread_fadeOffset),a
	ldh (<hBgPaletteSources),a
	ldh (<hSprPaletteSources),a
	ld (wPaletteThread_updateRate),a
	ld (wLockBG7Color3ToBlack),a
	ld hl,wDirtyFadeBgPalettes
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ret

;;
; @param	a	Amount to divide the speed of the fadeout by
fadeoutToWhiteWithDelay:
	call setPaletteThreadDelay
	ld a,$09
	ld (wPaletteThread_mode),a
	ld a,$01
	jr ++

;;
fastFadeoutToWhite:
	ld a,$01
	ld (wPaletteThread_mode),a
	ld a,$03
	jr ++
;;
fadeoutToWhite:
	ld a,$01
	ld (wPaletteThread_mode),a
	ld a,$01
++
	ld (wPaletteThread_speed),a
	xor a
	ld (wPaletteThread_fadeOffset),a

;;
; Configure all palettes to update from w2FadingBg/SprPalettes, and mark the palettes as
; dirty.
makeAllPaletteUseFading:
	ld a,$ff
	ld hl,wDirtyFadeBgPalettes
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ret

;;
; @param	a	Amount to divide the speed of the fadein by
fadeinFromWhiteWithDelay:
	call setPaletteThreadDelay
	ld a,$0a
	ld (wPaletteThread_mode),a
	ld a,$01
	jr ++

;;
fastFadeinFromWhite:
	ld a,$02
	ld (wPaletteThread_mode),a
	ld a,$03
	jr ++

;;
fadeinFromWhite:
	ld a,$02
	ld (wPaletteThread_mode),a
	ld a,$01
++
	ld (wPaletteThread_speed),a
	ld a,$20
	ld (wPaletteThread_fadeOffset),a
	jp makeAllPaletteUseFading

;;
; @param	a	Amount to divide the speed of the fadeout by
fadeoutToBlackWithDelay:
	call setPaletteThreadDelay
	ld a,$0b
	ld (wPaletteThread_mode),a
	ld a,$01
	jr ++

;;
fastFadeoutToBlack:
	ld a,$03
	ld (wPaletteThread_mode),a
	ld a,$03
	jr ++

;;
fadeoutToBlack:
	ld a,$03
	ld (wPaletteThread_mode),a
	ld a,$01
++
	ld (wPaletteThread_speed),a
	xor a
	ld (wPaletteThread_fadeOffset),a
	jp makeAllPaletteUseFading

;;
; @param	a	Amount to divide the speed of the fadein by
fadeinFromBlackWithDelay:
	call setPaletteThreadDelay
	ld a,$0c
	ld (wPaletteThread_mode),a
	ld a,$01
	jr ++

;;
fastFadeinFromBlack:
	ld a,$04
	ld (wPaletteThread_mode),a
	ld a,$03
	jr ++

;;
fadeinFromBlack:
	ld a,$04
	ld (wPaletteThread_mode),a
	ld a,$01
++
	ld (wPaletteThread_speed),a
	ld a,$e0
	ld (wPaletteThread_fadeOffset),a
	jp makeAllPaletteUseFading



.ifdef ROM_AGES

; Room darkening-related code was slightly rewritten in Ages, compared to Seasons?

;;
; Darkens a room half as much as "darkenRoomLightly".
darkenRoomLightly:
	ld b,$f7
	jr _darkenRoomHelper

;;
; Unused?
;
; @param	a	How much to slow down palette thread
func_32fc:
	call setPaletteThreadDelay
	ld a,$0d
	ld b,$f0
	ld (wPaletteThread_mode),a
	ld a,$01
	jr _setDarkeningVariables

;;
; @param	a	Speed of darkening
darkenRoomWithSpeed:
	ld b,$f0
	call _setDarkeningVariables
	ld a,$05
	ld (wPaletteThread_mode),a
	ret


;;
; Darkens a room twice as much as "darkenRoomLightly".
darkenRoom:
	ld b,$f0

;;
; @param	b	Amount to darken
_darkenRoomHelper:
	ld a,$05
	ld (wPaletteThread_mode),a
	ld a,$01


;;
; @param	a	Speed of darkening
; @param	b	Amount to darken
_setDarkeningVariables:
	ld (wPaletteThread_speed),a
	ld a,(wPaletteThread_parameter)
	ld (wPaletteThread_fadeOffset),a
	ld a,b
	ld (wPaletteThread_parameter),a

	; Mark BG palettes 2-7 as needing refresh
	ld a,$fc
	ld hl,wDirtyFadeBgPalettes
	ldi (hl),a
	ld (hl),$00
	inc l
	ldi (hl),a ; [wFadeBgPaletteSources] = $fc
	ld (hl),$00
	ret

;;
brightenRoomLightly:
	ld b,$f7
	ld a,$01
	jr _brightenRoomHelper

;;
; Unused?
;
; @param	a
func_333e:
	call setPaletteThreadDelay
	ld a,$0e
	ld b,$00
	ld (wPaletteThread_mode),a
	ld a,$01
	jr _setDarkeningVariables

;;
; @param	a	Speed of brightening
brightenRoomWithSpeed:
	ld b,$00
	jr _brightenRoomHelper

;;
brightenRoom:
	ld b,$00
	ld a,$01

;;
; @param	a	Speed of brightening
; @param	b	Amount to brighten
_brightenRoomHelper:
	call _setDarkeningVariables
	ld a,$06
	ld (wPaletteThread_mode),a
	ret


.else; ROM_SEASONS

;;
darkenRoomLightly:
	ld b,$f7
	jr _darkenRoomHelper

;;
darkenRoom:
	ld b,$f0

;;
_darkenRoomHelper:
	ld a,$05
	ld (wPaletteThread_mode),a
_label_331c:
	ld a,(wPaletteThread_parameter)


;;
; @param	a	Start of darkening
; @param	b	Amount to darken
_setDarkeningVariables:
	ld (wPaletteThread_fadeOffset),a
	ld a,b
	ld (wPaletteThread_parameter),a
	ld a,$01
	ld (wPaletteThread_speed),a
	ld a,$fc
	ld hl,wDirtyFadeBgPalettes
	ldi (hl),a
	ld (hl),$00
	inc l
	ldi (hl),a
	ld (hl),$00
	ret

;;
brightenRoomLightly:
	ld b,$f7
	jr ++

;;
brightenRoom:
	ld b,$00
++
	ld a,$06
	ld (wPaletteThread_mode),a
	jr _label_331c


.endif; ROM_SEASONS



;;
; Almost identical to "fastFadeinFromWhite", but uses palette fade mode 7 which checks if
; a room should be dark? (wPaletteThread_parameter should be set accordingly?)
;
; Also uses a value of $1e instead of $20 for initial fadeOffset; maybe because it's
; a multiple of 3, which is the value for wPaletteThread_speed?
;
fastFadeinFromWhiteToRoom:
	call fastFadeinFromWhite
	ld a,$1e
	ld (wPaletteThread_fadeOffset),a
--
	ld a,$07
	ld (wPaletteThread_mode),a
	ret

;;
fadeinFromWhiteToRoom:
	call fadeinFromWhite
	jr --

;;
; Fades between the palettes in w2ColorComponentBuffer1 and w2ColorComponentBuffer2. The
; colors in these palettes apply to the palettes BG2-7.
;
startFadeBetweenTwoPalettes:
	ld a,$08
	ld (wPaletteThread_mode),a
	ld a,$20
	ld (wPaletteThread_fadeOffset),a
	ret

;;
; @param	a	A value which acts to slow down certain palette fades the higher
;			it is. (Acts like division.)
setPaletteThreadDelay:
	ld (wPaletteThread_counterRefill),a
	ld a,$01
	ld (wPaletteThread_counter),a
	ret

;;
paletteFadeThreadStart:
	ld a,:w2TilesetBgPalettes
	ld ($ff00+R_SVBK),a

	callfrombank0 bank1.paletteFadeHandler
	call          bank1.checkLockBG7Color3ToBlack

	; Resume this thread in [wPaletteThread_updateRate] frames.
	ld a,(wPaletteThread_updateRate)
	or a
	jr nz,+
	inc a
+
	call resumeThreadInAFrames
	jr paletteFadeThreadStart


;;
; This thread runs all of the interesting, in-game stuff.
;
mainThreadStart:
	call restartSound
	call stopTextThread

@mainThread:
	; Increment wPlaytimeCounter, the 4-byte counter
	ld hl,wPlaytimeCounter
	inc (hl)
	ldi a,(hl)
	ld (wFrameCounter),a
	jr nz,++
	inc (hl)
	jr nz,++
	inc l
	inc (hl)
	jr nz,++
	inc l
	inc (hl)
++
	callfrombank0 bank1.runGameLogic
	call          drawAllSprites
	call          checkReloadStatusBarGraphics
	call          resumeThreadNextFrame

	jr           @mainThread



.ifdef ROM_SEASONS

updateAnimationsAfterCutscene:
	ldh a,(<hRomBank)
	push af
	callfrombank0 animationAndUniqueGfxData.updateAnimations
	pop af
	setrombank
	ret
.endif

;;
; Sets wActiveMusic2 to the appropriate value, and sets wLoadingRoomPack (for present/past
; overworlds only)
loadScreenMusic:
	ldh a,(<hRomBank)
	push af
	ld a,:bank4Data1.musicAssignmentGroupTable
	setrombank

	ld a,(wActiveGroup)
	ld hl,bank4Data1.musicAssignmentGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wActiveRoom)
	rst_addAToHl
	ldi a,(hl)
	ld (wActiveMusic2),a

.ifdef ROM_AGES
	ld a,(wActiveGroup)
	cp $02
	jr nc,++

	ld b,a
	ld a,(wActiveRoom)
	ld c,a
	ld hl,bank4Data1.roomPackData
	add hl,bc
	ldi a,(hl)
	ld (wLoadingRoomPack),a
++
	pop af
	setrombank
	ret

.else; ROM_SEASONS

	ld a,(wActiveGroup)
	or a
	jr nz,++

	ld a,(wActiveRoom)
	ld hl,bank4Data1.roomPackData
	rst $10
	ldi a,(hl)
	ld (wLoadingRoomPack),a
++
	pop af
	setrombank
	ret
.endif


;;
applyWarpDest:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank4.applyWarpDest_b04

.ifdef ROM_SEASONS
	callfrombank0 bank1.checkUpdateDungeonMinimap
.endif

	pop af
	setrombank
	ret


;;
; - Calls loadScreenMusic
; - Copies wActiveRoom to wLoadingRoom
; - Copies wLoadingRoomPack to wRoomPack (for group 0 only)
loadScreenMusicAndSetRoomPack:
	call loadScreenMusic
	ld a,(wActiveRoom)
	ld (wLoadingRoom),a
	ld a,(wActiveGroup)
	or a
	ret nz

	ld a,(wLoadingRoomPack)
.ifdef ROM_AGES
	and $7f
.endif
	ld (wRoomPack),a
	ret

;;
dismountCompanionAndSetRememberedPositionToScreenCenter:
	ldh a,(<hRomBank)
	push af
	ld a,:bank5.companionDismount
	setrombank

	ld de,w1Companion
	ld a,e
	ldh (<hActiveObjectType),a
	ld a,d
	ldh (<hActiveObject),a

	call bank5.companionDismount
	call bank5.saveLinkLocalRespawnAndCompanionPosition

	; After saving the companion's position, overwrite it with values for the center
	; of the screen?
	ld a,$38
	ld (wRememberedCompanionY),a
	ld a,$50
	ld (wRememberedCompanionX),a

	pop af
	setrombank
	ret

.ifdef ROM_SEASONS

seasonsFunc_331b:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank0f.seasonsFunc_0f_6f75
	pop af
	setrombank
	ret

seasonsFunc_332f:
	ldh a,(<hRomBank)
	push af
	ld a,$0f
	setrombank
	call bank0f.seasonsFunc_0f_704d
	call bank0f.seasonsFunc_0f_7182
	pop af
	setrombank
	ret

flameOfDestructionsCutsceneCaller:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3Cutscenes.flameOfDestructionCutsceneBody
	pop af
	setrombank
	ret

zeldaAndVillagersCutsceneCaller:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3Cutscenes.zeldaAndVillagersCutsceneBody
	pop af
	setrombank
	ret

zeldaKidnappedCutsceneCaller:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3Cutscenes.zeldaKidnappedCutsceneBody
	pop af
	setrombank
	ret

.endif

;;
; TODO: give this a better name
updateAllObjects:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank5.updateSpecialObjects
	callfrombank0 itemCode.updateItems
	call          setEnemyTargetToLinkPosition
	callfrombank0 updateEnemies
	callfrombank0 partCode.updateParts
	callfrombank0 updateInteractions
	callfrombank0 bank1.func_4000

	; Call func_410d if Link is riding something
	ld a,:bank5.func_410d
	setrombank
	ld a,(wLinkObjectIndex)
	rrca
	call c,bank5.func_410d

	ld a,:bank6.updateGrabbedObjectPosition
	setrombank
	ld a,(wLinkGrabState)
	rlca
	call c,bank6.updateGrabbedObjectPosition

	call loadLinkAndCompanionAnimationFrame

	callfrombank0 itemCode.updateItemsPost
	callfrombank0 bank1.checkUpdateFollowingLinkObject
	callfrombank0 updateCamera
	callfrombank0 tilesets.updateChangedTileQueue
	callfrombank0 animationAndUniqueGfxData.updateAnimations

	xor a
	ld (wc4b6),a
	pop af
	setrombank
	ret

;;
updateSpecialObjectsAndInteractions:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank5.updateSpecialObjects
	callfrombank0 updateInteractions
	call          loadLinkAndCompanionAnimationFrame
	xor a
	ld (wc4b6),a
	pop af
	setrombank
	ret

;;
updateInteractionsAndDrawAllSprites:
	ldh a,(<hRomBank)
	push af
	callfrombank0 updateInteractions
	call drawAllSprites
	xor a
	ld (wc4b6),a
	pop af
	setrombank
	ret

;;
; Similar to updateAllObjects but calls a bit less
func_3539:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank5.updateSpecialObjects
.ifdef ROM_AGES
	callfrombank0 itemCode.updateItems
	callfrombank0 updateEnemies
	callfrombank0 partCode.updateParts
	callfrombank0 updateInteractions
	callfrombank0 itemCode.updateItemsPost
.else
	callfrombank0 updateEnemies
	callfrombank0 updateInteractions
.endif
	callfrombank0 loadLinkAndCompanionAnimationFrame
	callfrombank0 animationAndUniqueGfxData.updateAnimations
	xor a
	ld (wc4b6),a
	pop af
	setrombank
	ret

.ifdef ROM_SEASONS

;;
seasonsFunc_34a0:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank5.updateSpecialObjects
	callfrombank0 itemCode.updateItems
	callfrombank0 updateEnemies
	callfrombank0 partCode.updateParts
	callfrombank0 updateInteractions
	callfrombank0 bank0f.seasonsFunc_0f_7159

	ld a,:bank6.updateGrabbedObjectPosition
	setrombank
	ld a,(wLinkGrabState)
	rlca
	call c,bank6.updateGrabbedObjectPosition

	call loadLinkAndCompanionAnimationFrame
	callfrombank0 itemCode.updateItemsPost
	callfrombank0 bank0f.seasonsFunc_0f_7182
	callfrombank0 tilesets.updateChangedTileQueue

	xor a
	ld (wc4b6),a

	pop af
	setrombank
	ret

.endif

;;
clearWramBank1:
	xor a
	ld ($ff00+R_SVBK),a
	ld hl,$d000
	ld bc,$1000
	jp clearMemoryBc

;;
; Clear $30 bytes of ram related to information about the current screen, as
; well as clearing wram bank 1.
clearScreenVariablesAndWramBank1:
	call clearWramBank1
;;
clearScreenVariables:
	ld hl,wScreenVariables
	ld b,wScreenVariables.size
	call clearMemory
	ld a,$ff
	ld (wLoadedTilesetUniqueGfx),a
	ld (wLoadedTilesetLayout),a
	ld (wLoadedTilesetAnimation),a
	ret

;;
clearLinkObject:
	ld hl,w1Link
	ld b,$40
	jp clearMemory

;;
clearReservedInteraction0:
	ld hl,w1ReservedInteraction0
	ld b,$40
	call clearMemory

;;
; Unused?
clearReservedInteraction1:
	ld hl,w1ReservedInteraction1
	ld b,$40
	jp clearMemory

;;
; Clear all interactions except wReservedInteraction0 and wReservedInteraction1.
;
clearDynamicInteractions:
	ldde FIRST_DYNAMIC_INTERACTION_INDEX, Interaction.start
--
	ld h,d
.ifdef AGES_ENGINE
	ld l,e
.else
	ld l,Interaction.start
.endif
	ld b,$40
	call clearMemory
	inc d
	ld a,d
	cp $e0
	jr c,--
	ret

;;
clearItems:
	ldde FIRST_ITEM_INDEX, Item.start
--
	ld h,d
.ifdef AGES_ENGINE
	ld l,e
.else
	ld l,Item.start
.endif
	ld b,$40
	call clearMemory
	inc d
	ld a,d
	cp $e0
	jr c,--
	ret

;;
clearEnemies:
	ldde FIRST_ENEMY_INDEX, Enemy.start
--
	ld h,d
.ifdef AGES_ENGINE
	ld l,e
.else
	ld l,Enemy.start
.endif
	ld b,$40
	call clearMemory
	inc d
	ld a,d
	cp $e0
	jr c,--
	ret

;;
clearParts:
	ldde FIRST_PART_INDEX, Part.start
--
	ld h,d
.ifdef AGES_ENGINE
	ld l,e
.else
	ld l,Part.start
.endif
	ld b,$40
	call clearMemory
	inc d
	ld a,d
	cp $e0
	jr c,--
	ret

;;
setEnemyTargetToLinkPosition:
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,<w1Link.yh
	ldi a,(hl)
	ldh (<hEnemyTargetY),a
	inc l
	ld a,(hl)
	ldh (<hEnemyTargetX),a
	ld a,(wScentSeedActive)
	or a
	ret nz

	ld l,<w1Link.yh
	ldi a,(hl)
	ldh (<hFFB2),a
	inc l
	ld a,(hl)
	ldh (<hFFB3),a
	ret

.ifdef ROM_AGES

;;
getEntryFromObjectTable2:
	ldh a,(<hRomBank)
	push af
	ld a, :objectData.objectTable2
	setrombank
	ld a,b
	ld hl, objectData.objectTable2
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	pop af
	setrombank
	ret

.else ; ROM_SEASONS

;;
multiIntroCutsceneCaller:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3Cutscenes.multiIntroCutsceneHandler
	pop af
	setrombank
	ret


.endif


.ifdef ROM_AGES

;;
; Check if a dungeon uses those toggle blocks with the orbs.
;
; @param[out]	z	Set if the dungeon does not use toggle blocks.
checkDungeonUsesToggleBlocks:
	ld a,(wDungeonIndex)
	cp $ff
	ret z

	ld hl,dungeonsUsingToggleBlocks
	jp checkFlag

	.include "data/dungeonsUsingToggleBlocks.s"

.else ; ROM_SEASONS
seasonsFunc_35cc:
	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc
	ld a,$02
	ld ($ff00+R_SVBK),a
	callfrombank0 bank1.paletteThread_calculateFadingPalettes
	pop bc
	ld a,b
	setrombank
	ld a,c
	ld ($ff00+R_SVBK),a
	ret

func_35ec:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank1.paletteFadeHandler08@seasonsFunc_01_5816
	pop af
	setrombank
	ret

.endif

;;
; Load data into wAnimationState, wAnimationPointerX, etc.
;
; @param	a	Value of wTilesetAnimation
loadAnimationData:
	ld b,a
	ldh a,(<hRomBank)
	push af
	ld a,:animationAndUniqueGfxData.animationGroupTable
	setrombank
	ld a,b
	ld hl,animationAndUniqueGfxData.animationGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldi a,(hl)
	ld (wAnimationState),a
	push de
	ld de,wAnimationCounter1
	call @helper
	ld de,wAnimationCounter2
	call @helper
	ld de,wAnimationCounter3
	call @helper
	ld de,wAnimationCounter4
	call @helper
	pop de
	pop af
	setrombank
	xor a
	ld (wAnimationQueueHead),a
	ld (wAnimationQueueTail),a
	ret

;;
@helper:
	push hl
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldi a,(hl)
	ld (de),a
	inc de
	ld a,l
	ld (de),a
	inc de
	ld a,h
	ld (de),a
	pop hl
	inc hl
	inc hl
	ret


.ifdef ROM_SEASONS

roomTileChangesAfterLoad02:
	ldh a,(<hRomBank)
	push af
	callfrombank0 seasonsInteractionsBank09.roomTileChangesAfterLoad02_body
	pop af
	setrombank
	ret

.endif

;;
; See the comments for roomGfxChanges.getIndexOfGashaSpotInRoom_body.
;
; @param	a	Room
; @param[out]	c	Bit 7 set if something is planted in the given room.
;			(This is the value of the 'f' register after the function call.)
getIndexOfGashaSpotInRoom:
	ld c,a
	ldh a,(<hRomBank)
	push af

	ld a,:roomGfxChanges.getIndexOfGashaSpotInRoom_body
	setrombank
	ld a,c
	call roomGfxChanges.getIndexOfGashaSpotInRoom_body

	push af
	pop bc
	pop af
	setrombank
	ret


.ifdef ROM_AGES

;;
; The name is a bit of a guess.
;
; Returns 2 if an event is triggered in part of the forest (map $90?), 1 if the maku
; tree has spoken to you outside d3, 0 otherwise.
;
; @param[out]	a	Black tower progress (0-2)
; @param[out]	zflag	z if black tower is still in early stages (npcs hanging around)
getBlackTowerProgress:
	push bc
	ld c,$02
	ld a,(wPresentRoomFlags+$90)
	bit ROOMFLAG_BIT_40,a
	jr nz,++

	dec c
	ld a,(wPresentRoomFlags+$ba)
	bit ROOMFLAG_BIT_40,a
	jr nz,++

	dec c
++
	ld a,c
	pop bc
	ret

.endif

; A table of addresses in vram. The index is a row (of 16 pixels), and the corresponding
; value is the address of the start of that row.
vramBgMapTable:
	.dw $9800 $9840 $9880 $98c0
	.dw $9900 $9940 $9980 $99c0
	.dw $9a00 $9a40 $9a80 $9ac0
	.dw $9b00 $9b40 $9b80 $9bc0

;;
; Force-load a room?
;
; @param	a	Value for wRoomStateModifier (only lower 2 bits are used)
; @param	b	Value for wActiveGroup
; @param	c	Value for wActiveRoom
func_36f6:
	and $03
	ld (wRoomStateModifier),a
	ld a,b
	ld (wActiveGroup),a
	ld a,c
	ld (wActiveRoom),a
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics
	call loadTilesetAndRoomLayout
	jp generateVramTilesWithRoomChanges

;;
; Loads the tileset (assumes wTilesetLayout is already set to the desired value).
;
; End result: w3TileMappingData is loaded with the tile indices and attributes for all
; tiles in the tileset.
loadTilesetLayout:
	ld a,(wTilesetLayout)
	call loadTileset
	ld a,:tileMappingTable
	setrombank

	ld a,:w3TileMappingData
	ld ($ff00+R_SVBK),a
	ld hl,w3TileMappingIndices
	ld de,w3TileMappingData
	ld b,$00
-
	push bc
	call @helper
	pop bc
	dec b
	jr nz,-

.ifdef ROM_SEASONS
	xor a
	ld ($ff00+R_SVBK),a
	ret

.else ; ROM_AGES
	jpab tilesets.setPastCliffPalettesToRed
.endif

;;
@helper:
	; bc = tile mapping index
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld b,a

	; Get address of pointers to tile indices / attributes
	push hl
	ld hl, tileMappingTable
	add hl,bc
	add hl,bc
	add hl,bc

	; Load tile indices
	ldi a,(hl)
	ld c,a
	ld a,(hl)
	swap a
	and $0f
	ld b,a
	push hl
	ld hl,tileMappingIndexDataPointer
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc
	add hl,bc
	add hl,bc
	add hl,bc
	ld b,$04
	call copyMemory

	; Load tile attributes
	pop hl
	ldi a,(hl)
	and $0f
	ld b,a
	ld c,(hl)
	ld hl,tileMappingAttributeDataPointer
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc
	add hl,bc
	add hl,bc
	add hl,bc
	ld b,$04
	call copyMemory

	pop hl
	ret


;;
; Loads the address of unique header gfx (a&$7f) into wUniqueGfxHeaderAddress.
;
; @param	a	Unique gfx header (see constants/uniqueGfxHeaders.s).
;			Bit 7 is ignored.
loadUniqueGfxHeader:
	and $7f
	ld b,a
	ldh a,(<hRomBank)
	push af
	ld a,:animationAndUniqueGfxData.uniqueGfxHeaderTable
	setrombank
	ld a,b
	ld hl,animationAndUniqueGfxData.uniqueGfxHeaderTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wUniqueGfxHeaderAddress),a
	ld a,(hl)
	ld (wUniqueGfxHeaderAddress+1),a
	pop af
	setrombank
	ret

;;
; Load all graphics based on wTileset variables.
;
loadTilesetGraphics:
	ldh a,(<hRomBank)
	push af

	ld a,(wTilesetGfx)
	call loadGfxHeader
	ld a,(wTilesetPalette)
	call loadPaletteHeader

	call          loadTilesetUniqueGfx
	callfrombank0 animationAndUniqueGfxData.initializeAnimations

.ifdef ROM_AGES
	callab        roomGfxChanges.func_02_7a77
	callab        roomGfxChanges.checkLoadPastSignAndChestGfx
.endif

	ld a,(wTilesetUniqueGfx)
	ld (wLoadedTilesetUniqueGfx),a
	ld a,(wTilesetPalette)
	ld (wLoadedTilesetPalette),a
	ld a,(wTilesetAnimation)
	ld (wLoadedTilesetAnimation),a

	pop af
	setrombank
	ret

;;
; Loads one entry from the gfx header if [wTilesetUniqueGfx] != [wLoadedTilesetUniqueGfx].
;
; This should be called repeatedly (once per frame, to avoid overloading vblank) until all
; entries in the header are read.
;
; @param	wUniqueGfxHeaderAddress	Where to read the header from (will be updated)
; @param[out]	cflag			Set if there are more entries to load.
updateTilesetUniqueGfx:
	ld a,(wTilesetUniqueGfx)
	or a
	ret z

	ld b,a
	ld a,(wLoadedTilesetUniqueGfx)
	cp b
	ret z

	ldh a,(<hRomBank)
	push af

	ld hl,wUniqueGfxHeaderAddress
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,:animationAndUniqueGfxData.uniqueGfxHeadersStart
	setrombank
	call loadUniqueGfxHeaderEntry
	ld c,a
	ld a,l
	ld (wUniqueGfxHeaderAddress),a
	ld a,h
	ld (wUniqueGfxHeaderAddress+1),a

	pop af
	setrombank
	ld a,c
	add a
	ret

;;
; Load just the first entry of a unique gfx header?
;
; @param	a	Unique gfx header index
uniqueGfxFunc_380b:
	ld b,a
	ldh a,(<hRomBank)
	push af

	ld a,:animationAndUniqueGfxData.uniqueGfxHeadersStart
	setrombank
	ld a,b
	ld hl,animationAndUniqueGfxData.uniqueGfxHeaderTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call loadUniqueGfxHeaderEntry

	pop af
	setrombank
	ret

;;
loadTilesetUniqueGfx:
	ld a,:animationAndUniqueGfxData.uniqueGfxHeaderTable
	setrombank
	ld a,(wTilesetUniqueGfx)
	and $7f
	ret z

	ld hl,animationAndUniqueGfxData.uniqueGfxHeaderTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
-
	call loadUniqueGfxHeaderEntry
	add a
	jr c,-
	ret

;;
; Loads a single gfx header entry at hl. This should be called multiple times until all
; entries are read.
;
; If the first byte (bank+mode) is zero, it loads a palette instead.
;
; @param[out]	a	Last byte of the entry (bit 7 set if there's another entry)
loadUniqueGfxHeaderEntry:
	ldi a,(hl)
	or a
	jr z,@loadPaletteIndex

	ld c,a
	ldh (<hFF8C),a
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld e,a
	ld a,(hl)
	and $7f
	ldh (<hFF8D),a
	push hl
	push de
	ld l,c
	ld h,b
	ld b,a
	ldh a,(<hFF8C)
	ld c,a
	ld de, w7d800 | :w7d800
	call decompressGraphics
	pop de
	ld hl,w7d800
	ld c,:w7d800
	ldh a,(<hFF8D)
	ld b,a
	call queueDmaTransfer
	pop hl
	ld a,$00
	ld ($ff00+R_SVBK),a
	ld a,:animationAndUniqueGfxData.uniqueGfxHeaderTable
	setrombank
	ldi a,(hl)
	ret

@loadPaletteIndex:
	push hl
	ld a,(hl)
	and $7f
	call loadPaletteHeader
	pop hl
	ldi a,(hl)
	ret

;;
loadTilesetData:
	ldh a,(<hRomBank)
	push af

	callfrombank0 tilesets.loadTilesetData_body
	callab        bank2.updateTilesetFlagsForIndoorRoomInAltWorld

	pop af
	setrombank
	ret

;;
loadTilesetAndRoomLayout:
	ldh a,(<hRomBank)
	push af

	; Reload tileset if necessary
	ld a,(wLoadedTilesetLayout)
	ld b,a
	ld a,(wTilesetLayout)
	cp b
	ld (wLoadedTilesetLayout),a
	call nz,loadTilesetLayout

.ifdef ROM_SEASONS
	call seasonsFunc_3870
.endif
	; Load the room layout and apply any dynamic changes necessary
	call          loadRoomLayout

	callfrombank0 roomTileChanges.applyAllTileSubstitutions

	; Copy wRoomLayout to w3RoomLayoutBuffer
	ld a,:w3RoomLayoutBuffer
	ld ($ff00+R_SVBK),a
	ld hl,w3RoomLayoutBuffer
	ld de,wRoomLayout
	ld b,_sizeof_wRoomLayout
	call copyMemoryReverse

	xor a
	ld ($ff00+R_SVBK),a
	pop af
	setrombank
	ret

.ifdef ROM_SEASONS

seasonsFunc_3870:
	ld a,GLOBALFLAG_TEMPLE_REMAINS_FILLED_WITH_LAVA
	call checkGlobalFlag
	ret z

	callfrombank0 tilesets.checkIsTempleRemains
	ret nc
	ld a,(wRoomStateModifier)
	ld hl,@data
	rst_addAToHl
	ld a,(wActiveRoom)
	add (hl)
	ld (wLoadingRoom),a
	ret

@data:
	.db $bc $c0 $c4 $c8

.endif


;;
; Load room layout into wRoomLayout using the relevant RAM addresses (wTilesetLayoutGroup,
; wLoadingRoom, etc)
loadRoomLayout:
	ld hl,wRoomLayout
	ld b,(LARGE_ROOM_HEIGHT+1)*16
	call clearMemory
	ld a,:roomLayouts.roomLayoutGroupTable
	setrombank
	ld a,(wTilesetLayoutGroup)
	add a
	add a
	ld hl,roomLayouts.roomLayoutGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ldh (<hFF8D),a
	ldi a,(hl)
	ldh (<hFF8E),a
	ldi a,(hl)
	ldh (<hFF8F),a
	ldi a,(hl)
	ldh (<hFF8C),a
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldh a,(<hFF8C)
	setrombank
	push hl
	ld a,b
	rst_jumpTable
	.dw @loadLargeRoomLayout
	.dw @loadSmallRoomLayout

;;
@loadLargeRoomLayoutHlpr:
	ld d,b
	ld a,b
	and $0f
	ld b,a

	; Get relative offset in hl
	ldh a,(<hFF8F)
	ld h,a
	ldh a,(<hFF8E)
	ld l,a

	add hl,bc
	ld a,d
	swap a
	and $0f
	add $03
	ld b,a
	ret

;;
@loadLargeRoomLayout:
	ldh a,(<hFF8F)
	ld h,a
	ldh a,(<hFF8E)
	ld l,a
	ld bc,$1000
	add hl,bc
	ldh a,(<hFF8D)
	setrombank

	ld a,(wLoadingRoom)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	pop bc
	add hl,bc
	ld bc,-$200
	add hl,bc
	call @loadLayoutData
	ld de,wRoomLayout
@next8:
	ldi a,(hl)
	ld b,$08
@next:
	rrca
	ldh (<hFF8B),a
	jr c,+
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,e
	cp LARGE_ROOM_HEIGHT*16
	ret z
--
	ldh a,(<hFF8B)
	dec b
	jr nz,@next
	jr @next8
+
	push bc
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld b,a
	push hl
	call @loadLargeRoomLayoutHlpr
	ld d,>wRoomLayout
	ldh a,(<hFF8D) ; Relative offset bank number
	setrombank
-
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,e
	cp LARGE_ROOM_HEIGHT*16
	jr z,+
	dec b
	jr nz,-
	pop hl
	pop bc
	jr --
+
	pop hl
	pop bc
	ret

;;
@loadSmallRoomLayout:
	ldh a,(<hFF8D)
	setrombank
	ldh a,(<hFF8E)
	ld l,a
	ldh a,(<hFF8F)
	ld h,a
	ld a,(wLoadingRoom)
	rst_addDoubleIndex

	; Get relative offset of layout data in hl
	ldi a,(hl)
	ld c,a
	ld a,(hl)
	ld e,a
	and $3f
	ld b,a

	; Add relative offset with base offset
	pop hl
	add hl,bc
	call @loadLayoutData

	; Upper bits of relative offset specify compression
	bit 7,e
	jr nz,@decompressLayoutMode2
	bit 6,e
	jr nz,@decompressLayoutMode1

	; Uncompressed; just copy to wRoomLayout unmodified
	ld de,wRoomLayout
	ldbc SMALL_ROOM_WIDTH, SMALL_ROOM_HEIGHT
--
	push bc
-
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,-

	ld a,e
	add $10-SMALL_ROOM_WIDTH
	ld e,a
	pop bc
	dec c
	jr nz,--
	ret

;;
@decompressLayoutMode2:
	ld de,wRoomLayout
	ld a,(SMALL_ROOM_WIDTH*SMALL_ROOM_HEIGHT)/16
-
	push af
	call @decompressLayoutMode2Helper
	pop af
	dec a
	jr nz,-
	ret

;;
; Decompresses layout to wRoomLayout.
;
; Format: word where each bit means "repeat" or "don't repeat"; byte to repeat; remaining data
;
@decompressLayoutMode2Helper:
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ldh (<hFF8A),a
	or c
	ld b,$10
	jr z,@layoutCopyBytes
	ldi a,(hl)
	ldh (<hFF8B),a
	call @decompressLayoutHelper
	ldh a,(<hFF8A)
	ld c,a
	jr @decompressLayoutHelper

;;
@decompressLayoutMode1:
	ld de,wRoomLayout
	ld a,(SMALL_ROOM_WIDTH*SMALL_ROOM_HEIGHT)/8
-
	push af
	call @decompressLayoutMode1Helper
	pop af
	dec a
	jr nz,-
	ret

;;
@decompressLayoutMode1Helper:
	ldi a,(hl)
	ld c,a
	or a
	ld b,$08
	jr z,@layoutCopyBytes
	ldi a,(hl)
	ldh (<hFF8B),a
	jr @decompressLayoutHelper

;;
; Copy b bytes to wRoomLayout, while keeping de in bounds
;
@layoutCopyBytes:
	ldi a,(hl)
	ld (de),a
	inc e
	call @checkDeNextLayoutRow
	dec b
	jr nz,@layoutCopyBytes
	ret

;;
@checkDeNextLayoutRow:
	ld a,e
	and $0f
	cp SMALL_ROOM_WIDTH
	ret c
	ld a,$10-SMALL_ROOM_WIDTH
	add e
	ld e,a
	ret

;;
@decompressLayoutHelper:
	ld b,$08
--
	srl c
	jr c,+
	ldi a,(hl)
	jr ++
+
	ldh a,(<hFF8B)
++
	ld (de),a
	inc e
	call @checkDeNextLayoutRow
	dec b
	jr nz,--
	ret

;;
; Load the compressed layout data into wRoomCollisions (temporarily)
@loadLayoutData:
	push de
	ldh a,(<hFF8C)
.ifdef ROM_AGES
	ld e,a
.endif
-
	bit 7,h
	jr z,+
	ld a,h
.ifdef ROM_AGES
	sub $40
.else
	xor $c0
.endif
	ld h,a

.ifdef ROM_SEASONS
	ldh a,(<hFF8C)
	inc a
	ldh (<hFF8C),a
.else
	inc e
	jr -
+
	ld a,e
.endif
+
	setrombank
	ld b,LARGE_ROOM_HEIGHT*16
	ld de,wRoomCollisions
-
	call readByteSequential
	ld (de),a
	inc e
	dec b
	jr nz,-

	ld hl,wRoomCollisions
	pop de
	ret


;;
; Generates w3VramTiles and w3VramAttributes, and calls the function for room-specific
; changes to them.
;
generateVramTilesWithRoomChanges:
	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc

	callfrombank0 tilesets.generateW3VramTilesAndAttributes
.ifdef ROM_AGES
	callab        roomGfxChanges.applyRoomSpecificTileChangesAfterGfxLoad
.else
	call          roomGfxChanges.applyRoomSpecificTileChangesAfterGfxLoad
.endif

	pop bc
	ld a,b
	setrombank
	ld a,c
	ld ($ff00+R_SVBK),a
	ret

;;
; Gets the mapping data for a tile (the values to form the 2x2 tile).
;
; Tile indices go to $cec0-$cec3, and flag values go to $cec4-$cec7.
;
; @param	a	Tile to get mapping data for
; @param[out]	b	Top-left flag value
; @param[out]	c	Top-left tile index
getTileMappingData:
	ld c,a
	ld a,($ff00+R_SVBK)
	push af

	ld a,:w3TileMappingData
	ld ($ff00+R_SVBK),a

	ld a,c
	call setHlToTileMappingDataPlusATimes8

	push de
	ld de,wTmpcec0
	ld b,$08

.ifdef ROM_AGES
	call copyMemory
.else
--
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,--
.endif

	pop de
	ld a,($cec4)
	ld b,a
	ld a,(wTmpcec0)
	ld c,a
	pop af
	ld ($ff00+R_SVBK),a
	ret

;;
setHlToTileMappingDataPlusATimes8:
	call multiplyABy8
	ld hl,w3TileMappingData
	add hl,bc
	ret

;;
; Sets tile 'c' to the value of 'a'.
;
; @param	a	New tile index
; @param	c	Position of tile to change (returned intact)
; @param[out]	zflag	Set on failure (w2ChangedTileQueue is full)
setTile:
	ld b,a
	ld a,(wChangedTileQueueTail)
	inc a
	and $1f
	ld e,a

	; Return if w2ChangedTileQueue is full
	ld a,(wChangedTileQueueHead)
	cp e
	ret z

	; Tail of the queue gets incremented
	ld a,e
	ld (wChangedTileQueueTail),a

	ld a,($ff00+R_SVBK)
	push af
	ld a,:w2ChangedTileQueue
	ld ($ff00+R_SVBK),a

	; Populate the new entry for the queue
	ld a,e
	add a
	ld hl,w2ChangedTileQueue
	rst_addAToHl
	ld (hl),b
	inc l
	ld (hl),c

	; This will update wRoomLayout and wRoomCollisions
	ld a,b
	call setTileWithoutGfxReload

	pop af
	ld ($ff00+R_SVBK),a
	or h
	ret


.ifdef ROM_AGES
;;
; Calls "setTile" and "setTileInRoomLayoutBuffer".
;
; @param	a	New tile index
; @param	c	Position of tile to change
setTileInAllBuffers:
	ld e,a
	ld b,a
	call setTileInRoomLayoutBuffer
	ld a,e
	jp setTile
.endif

;;
; Mixes two tiles together by using some subtiles from one, and some subtiles from the
; other. Used for example by shutter doors, which would combine the door and floor tiles
; for the partway-closed part of the animation.
;
; Tile 2 uses its tiles from the same "half" that tile 1 uses. For example, if tile 1 was
; placed on the right side, both tiles would use the right halves of their subtiles.
;
; @param	a	0: Top is tile 2, bottom is tile 1
;			1: Left is tile 1, right is tile 2
;			2: Top is tile 1, bottom is tile 2
;			3: Left is tile 2, right is tile 1
; @param	hFF8C	Position of tile to change
; @param	hFF8F	Tile index 1
; @param	hFF8E	Tile index 2
setInterleavedTile:
	push de
	ld e,a
	ld a,($ff00+R_SVBK)
	ld c,a
	ldh a,(<hRomBank)
	ld b,a
	push bc

	ld a,:tilesets.setInterleavedTile_body
	setrombank
	ld a,e
	call tilesets.setInterleavedTile_body

	pop bc
	ld a,b
	setrombank
	ld a,c
	ld ($ff00+R_SVBK),a
	pop de
	ret

.ifdef ROM_SEASONS

setSeason:
	ld b,a
	ld a,(wActiveGroup)
	or a
	ret nz

	ld a,(wRoomPack)
	cp $f1
	ret nc

	; Not Natzu
	ld a,b
	ld (wRoomStateModifier),a
	ld a,$02
	ld (wcc4c),a
	ret

checkRoomPackAfterWarp:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank1.checkRoomPackAfterWarp_body
	pop af
	setrombank
	ret

.endif

;;
; @param[out]	hl	Address of a free interaction slot (on the id byte)
; @param[out]	zflag	Set if a free slot was found
getFreeInteractionSlot:
	ld hl,(FIRST_DYNAMIC_INTERACTION_INDEX<<8) | $40
--
	ld a,(hl)
	or a
	jr z,++

	inc h
	ld a,h
	cp $e0
	jr c,--

	or h
	ret
++
	inc (hl)
	inc l
	xor a
	ret



.ifdef ROM_AGES
;;
interactionDeleteAndUnmarkSolidPosition:
	call objectUnmarkSolidPosition
.endif

;;
interactionDelete:
	ld h,d
	ld l,Interaction.start
	ld b,$10
	xor a
-
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	dec b
	jr nz,-
	ret

;;
_updateInteractionsIfStateIsZero:
	ld a,Interaction.start
	ldh (<hActiveObjectType),a
	ld a,FIRST_INTERACTION_INDEX
--
	ldh (<hActiveObject),a
	ld d,a
	ld e,Interaction.enabled
	ld a,(de)
	or a
	jr z,@next

	rlca
	jr c,+

	ld e,Interaction.state
	ld a,(de)
	or a
	jr nz,@next
+
	call updateInteraction
@next:
	ldh a,(<hActiveObject)
	inc a
	cp LAST_INTERACTION_INDEX+1
	jr c,--
	ret

;;
updateInteractions:
	ld a,(wScrollMode)
	cp $08
	jr z,_updateInteractionsIfStateIsZero

	ld a,(wDisabledObjects)
	and $02
	jr nz,_updateInteractionsIfStateIsZero

	ld a,(wTextIsActive)
	or a
	jr nz,_updateInteractionsIfStateIsZero

	ld a,Interaction.start
	ldh (<hActiveObjectType),a
	ld a,FIRST_INTERACTION_INDEX
@next:
	ldh (<hActiveObject),a
	ld d,a
	ld e,Interaction.enabled
	ld a,(de)
	or a
	call nz,updateInteraction
	ldh a,(<hActiveObject)
	inc a
	cp LAST_INTERACTION_INDEX+1
	jr c,@next
	ret

;;
; Run once per frame for each interaction.
;
; @param	d	Interaction to update
updateInteraction:
	ld e,Interaction.id
	ld a,(de)

.ifdef ROM_AGES
	; Get the bank number in 'b'
	ld b,$08
	cp $3e
	jr c,@cnt
	inc b
	cp $67
	jr c,@cnt
	inc b
	cp $98
	jr c,@cnt
	inc b
	cp $dc
	jr c,@cnt
	ld b,$10

.else ; ROM_SEASONS

	ld b,$08
	cp $5e
	jr c,@cnt
	inc b
	cp $89
	jr c,@cnt
	inc b
	cp $c8
	jr c,@cnt
	ld b,$0f
	cp $d8
	jr c,@cnt
	ld b,$15
.endif

@cnt:
	ld a,b
	setrombank
	ld a,(de)
	ld hl,interactionCodeTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp hl

.include "data/interactionCodeTable.s"

.ifdef ROM_SEASONS

createSokraSnore:
	ld a,(wFrameCounter)
	and $3f
	ret nz
	ld b,$fa
	ld c,$fc
	jp objectCreateFloatingSnore

checkGotMakuSeedDidNotSeeZeldaKidnapped:
	ldh a,(<hRomBank)
	push af
	callfrombank0 seasonsInteractionsBank0a.checkGotMakuSeedDidNotSeeZeldaKidnapped_body
	push af
	pop bc
	pop af
	setrombank
	ret

.else ; ROM_AGES

;;
; Checks that an object is within [hFF8B] pixels of a position on both axes.
;
; @param	bc	Target position
; @param	hl	Object's Y position
; @param	hFF8B	Range we must be within on each axis
; @param[out]	cflag	c if the object is within [hFF8B] pixels of the position
checkObjectIsCloseToPosition:
	ldh (<hFF8B),a
	ldh a,(<hRomBank)
	push af

	callfrombank0 agesInteractionsBank08.checkObjectIsCloseToPosition
	ld b,$00
	jr nc,+
	inc b
+
	pop af
	setrombank

	ld a,b
	or a
	ret z
	scf
	ret

;;
; Contains some preset data for checking whether certain interactions should exist at
; certain points in the game?
;
; @param	a	Index of preset data to check
; @param	b	Return value from "getGameProgress_1" or "getGameProgress_2"?
; @param	c	Subid "base"
; @param[out]	zflag	Set if the npc should exist
checkNpcShouldExistAtGameStage:
	ldh (<hFF8B),a
	ldh a,(<hRomBank)
	push af
	ld a,:agesInteractionsBank09.checkNpcShouldExistAtGameStage_body
	setrombank
	ldh a,(<hFF8B)
	call agesInteractionsBank09.checkNpcShouldExistAtGameStage_body
	ld c,$00
	jr z,+
	inc c
+
	pop af
	setrombank
	ld a,c
	or a
	ret

tokayIslandStolenItems:
	.db TREASURE_SWORD
	.db TREASURE_SHOVEL
	.db TREASURE_HARP
	.db TREASURE_FLIPPERS
	.db TREASURE_SEED_SATCHEL
	.db TREASURE_SHIELD
	.db TREASURE_BOMBS
	.db TREASURE_BRACELET
	.db TREASURE_FEATHER

.endif

;;
; This function is identical to "interactionSetMiniScript", but is used in different
; contexts. See "include/simplescript_commands.s".
interactionSetSimpleScript:
	ld e,Interaction.scriptPtr
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

;;
; @param[out]	cflag	Set if the script has ended.
interactionRunSimpleScript:
	ldh a,(<hRomBank)
	push af
	ld a,SIMPLE_SCRIPT_BANK
	setrombank

	ld h,d
	ld l,Interaction.scriptPtr
	ldi a,(hl)
	ld h,(hl)
	ld l,a
--
	ld a,(hl)
	or a
	jr z,@scriptEnd
	call @runCommand
	jr c,--

	call interactionSetSimpleScript
	pop af
	setrombank
	xor a
	ret

@scriptEnd:
	pop af
	setrombank
	scf
	ret

;;
@runCommand:
	ldi a,(hl)
	push hl
	rst_jumpTable
	.dw @command0
	.dw @command1
	.dw @command2
	.dw @command3
	.dw @command4
.ifdef ROM_SEASONS
	.dw @command5
	.dw @command6
	.dw @command7
	.dw @command8
.endif

;;
; This doesn't get executed, value $00 is checked for above.
@command0:
	pop hl
	ret

;;
; Set counter1
@command1:
	pop hl
	ldi a,(hl)
	ld e,Interaction.counter1
	ld (de),a
	xor a
	ret

;;
; Call playSound
@command2:
	pop hl
	ldi a,(hl)
	push hl
	call playSound
	pop hl
	ret

;;
; Call setTile
@command3:
	pop hl
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	push hl
	call setTile
	pop hl
	scf
	ret

;;
; Call setInterleavedTile
@command4:
	pop hl
	ldi a,(hl)
	ldh (<hFF8C),a
	ldi a,(hl)
	ldh (<hFF8F),a
	ldi a,(hl)
	ldh (<hFF8E),a
	ldi a,(hl)
	push hl
	call setInterleavedTile
	pop hl
	scf
	ret


.ifdef ROM_SEASONS

@command5:
	pop hl
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ldh (<hFF8B),a
	push hl
--
	push bc
	ldh a,(<hFF8B)
	call setTile
	pop bc
	inc c
	dec b
	jr nz,--
	pop hl
	scf
	ret

@command7:
	pop hl
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ldh (<hFF8C),a
	ldi a,(hl)
	ldh (<hFF8E),a
	ldi a,(hl)
	ldh (<hFF8D),a
	push hl
--
	push bc
	ld b,>wRoomLayout
	ldh a,(<hFF8C)
	ld c,a
	ld a,(bc)
	ldh (<hFF8F),a
	ldh a,(<hFF8D)
	call setInterleavedTile
	ld hl,$ff8c
	inc (hl)
	pop bc
	dec b
	jr nz,--
	pop hl
	scf

@command6:
@command8:
	ret

.endif


.ifdef ROM_AGES

;;
; Gets object data for tokays in the wild tokay game.
;
; @param	b	Index (0/1: Tokay on left; 2: tokay on right; 3: both sides)
; @param[out]	hl	Address of object data
getWildTokayObjectDataIndex:
	ldh a,(<hRomBank)
	push af
	ld a,:objectData.wildTokayObjectTable
	setrombank
	ld a,b
	ld hl,objectData.wildTokayObjectTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	pop af
	setrombank
	ret

;;
; Create a sparkle at the current object's position.
objectCreateSparkle:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_SPARKLE
	inc l
	ld (hl),$00
	jp objectCopyPositionWithOffset

;;
; Create a sparkle at the current object's position that moves up briefly.
;
; Unused?
objectCreateSparkleMovingUp:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_SPARKLE
	inc l
	ld (hl),$02
	ld l,Interaction.speedY
	ld (hl),$80
	inc l
	ld (hl),$ff
	jp objectCopyPositionWithOffset

;;
; Create a red and blue decorative orb.
;
; Unused?
objectCreateRedBlueOrb:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_SPARKLE
	inc l
	ld (hl),$04
	jp objectCopyPositionWithOffset

;;
incMakuTreeState:
	ld a,(wMakuTreeState)
	inc a
	cp $11
	jr c,+
	ld a,$10
+
	ld (wMakuTreeState),a
	ret

;;
; Sets w1Link.direction, as well as w1Companion.direction if Link is riding something.
setLinkDirection:
	ld b,a
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.direction
	ld (hl),b
	ld h,>w1Link
	ld (hl),b
	ret

.else ; ROM_SEASONS

;;
; @param	b	index into _conditionalHoronNPCLookupTable
; @param[out]	c	$01 if NPC should be seen, otherwise $00
checkIfHoronVillageNPCShouldBeSeen:
	ldh a,(<hRomBank)
	push af
	callfrombank0 seasonsInteractionsBank08.checkHoronVillageNPCShouldBeSeen_body@main
	ld c,$01
	jr c,+
	dec c
+
	pop af
	setrombank
	ret

;;
; When Maku tree speaks from other screens?
setMakuTreeStageAndMapText:
	ldh a,(<hRomBank)
	push af
	callfrombank0 seasonsInteractionsBank09.makuTree_setAppropriateStage
	callfrombank0 scriptHelp.makuTree_setMapTextBasedOnStage
	pop af
	setrombank
	ret

;;
; @param[out]	b	the subid that fickle Sunken City NPCs will be visible with
getSunkenCityNPCVisibleSubId_caller:
	ldh a,(<hRomBank)
	push af
	callfrombank0 seasonsInteractionsBank08.getSunkenCityNPCVisibleSubId@main
	pop af
	setrombank
	ret

;;
setUpCharactersAfterMoblinKeepDestroyed:
	ldh a,(<hRomBank)
	push af
	callfrombank0 seasonsInteractionsBank0a.moblinKeepScene_setLinkDirectionAndPositionAfterDestroyed 
	ld a,$01
	call seasonsInteractionsBank0a.moblinKeepScene_spawnKingMoblin
	call seasonsInteractionsBank0a.moblinKeepScene_spawn2MoblinsAfterKeepDestroyed
	pop af
	setrombank
	ret

.endif ; ROM_SEASONS


;;
; Used during the end credits. Seems to load the credit text into OAM.
interactionFunc_3e6d:
	push de
	ld l,Interaction.var03
	ld e,(hl)

	ldh a,(<hRomBank)
	push af
.ifdef ROM_AGES
	ld a,:bank16.data_4556
.else
	ld a,:data_4556
.endif
	setrombank

	ld a,e
.ifdef ROM_AGES
	ld hl,bank16.data_4556
.else
	ld hl,data_4556
.endif
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call addSpritesToOam_withOffset
	pop af
	setrombank
	pop de
	ret


.ifdef ROM_SEASONS

getLinkedHerosCaveSideEntranceRoom:
	ldh a,(<hRomBank)
	push af
	ld a,:(bank4.warpSource7653+2)
	setrombank
	ld hl,bank4.warpSource7653+2
	ld a,(hl)
	; ROOM_SEASONS_552
	ld (wWarpDestRoom),a
	pop af
	setrombank
	ret

.endif

;;
; @param[out]	hl	Address of part slot ("id" byte)
; @param[out]	zflag	nz if no free slot was available
getFreePartSlot:
	ldhl FIRST_PART_INDEX, Part.start
--
	ld a,(hl)
	or a
	jr z,++
	inc h
	ld a,h
	cp LAST_PART_INDEX+1
	jr c,--
	or h
	ret
++
	inc a
	ldi (hl),a
	xor a
	ret

;;
partDelete:
	ld h,d
	ld l,Part.start
	ld b,$10
	xor a
-
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	dec b
	jr nz,-
	ret


.ifdef ROM_AGES

;;
; @param[out]	cflag
checkLinkCanSurface:
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	ret z
	callab underwaterSurfacing.checkLinkCanSurface_isUnderwater
	srl c
	ret

;;
; Copy $100 bytes from a specified bank.
;
; This DOES NOT set the bank back to its previous value, so it's not very useful.
;
; @param	c	ROM Bank to copy from
; @param	d	High byte of address to copy to
; @param	e	WRAM Bank
; @param	hl	Address to copy from
copy256BytesFromBank:
	ld a,e
	ld ($ff00+R_SVBK),a
	ld a,c
	setrombank
	ld e,$00
	ld b,$00
	jp copyMemory

;;
func_3ed0:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3Cutscenes.func_03_7841
	pop af
	setrombank
	ret

;;
func_3ee4:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3Cutscenes.func_03_7849
	pop af
	setrombank
	ret

.endif


.ENDS
