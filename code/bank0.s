.ORGA $0000
; rst_jumpTable
	add a			; $0000
	pop hl			; $0001
	add l			; $0002
	ld l,a			; $0003
	jr nc,+			; $0004
	inc h			; $0006
+
	ldi a,(hl)		; $0007
	ld h,(hl)		; $0008
	ld l,a			; $0009
	jp hl			; $000a

.ORGA $0010
; rst_addAToHl
	add l			; $0010
	ld l,a			; $0011
	ret nc			; $0012
	inc h			; $0013
	ret			; $0014

.ORGA $0018
; rst_addDoubleIndex
	push bc			; $0018
	ld c,a			; $0019
	ld b,$00		; $001a
	add hl,bc		; $001c
	add hl,bc		; $001d
	pop bc			; $001e
	ret			; $001f

.ORGA $0038
; Not used as rst $38
	nop			; $0038
	nop			; $0039
	nop			; $003a
	pop hl			; $003b
	pop de			; $003c
	pop bc			; $003d
	pop af			; $003e
	reti			; $003f

.ORGA $0040
; VBlank interrupt
	push af			; $0040
	push bc			; $0041
	push de			; $0042
	push hl			; $0043
	jp vblankInterrupt

.ORGA $0048
; LCD interrupt
	push af			; $0048
	push hl			; $0049
	jp lcdInterrupt

.ORGA $0050
; Timer interrupt
	ei			; $0050
	push af			; $0051
	push bc			; $0052
	push de			; $0053
	push hl			; $0054
	jp timerInterrupt

.ORGA $0058
; Serial interrupt
	push af			; $0058
	jp serialInterrupt

.ORGA $0060
; Joypad interrupt
	reti			; $0060

; Put the nops here explicitly so the next section can't start until $0068

	nop
	nop
	nop
	nop
	nop
	nop
	nop


.ORGA $0068

.SECTION "Bank 0 Early Functions"

;;
; @param a
; @param de
; @addr{0068}
addAToDe:
	add e			; $0068
	ld e,a			; $0069
	ret nc			; $006a
	inc d			; $006b
	ret			; $006c

;;
; @param a
; @param bc
; @addr{006d}
addAToBc:
	add c			; $006d
	ld c,a			; $006e
	ret nc			; $006f
	inc b			; $0070
	ret			; $0071

;;
; Adds a*2 to de.
; @param a
; @param de
; @addr{0072}
addDoubleIndexToDe:
	push hl			; $0072
	add a			; $0073
	ld l,a			; $0074
	ld a,$00		; $0075
	adc a			; $0077
	ld h,a			; $0078
	add hl,de		; $0079
	ld e,l			; $007a
	ld d,h			; $007b
	pop hl			; $007c
	ret			; $007d

;;
; Adds a*2 to bc.
; @param a
; @param bc
; @addr{007e}
addDoubleIndexToBc:
	push hl			; $007e
	add a			; $007f
	ld l,a			; $0080
	ld a,$00		; $0081
	adc a			; $0083
	ld h,a			; $0084
	add hl,bc		; $0085
	ld c,l			; $0086
	ld b,h			; $0087
	pop hl			; $0088
	ret			; $0089

;;
; Call a function in any bank, from any bank.
; @param e Bank of the function to call
; @param hl Address of the function to call
; @addr{008a}
interBankCall:
	ld a,($ff97)		; $008a
	push af			; $008d
	ld a,e			; $008e
	ld ($ff97),a		; $008f
	ld ($2222),a		; $0092
	call jpHl		; $0095
	pop af			; $0098
	ld ($ff97),a		; $0099
	ld ($2222),a		; $009c
	ret			; $009f

;;
; Jump to hl.
; @param hl Address to jump to.
; @addr{00a0}
jpHl:
	jp hl			; $00a0


; Symbol list for secrets:
;	BDFGHJLM♠♥♦♣#
;	NQRSTWY!●▲■+-
;	bdfghj m$*/:~
;	nqrstwy?%&<=>
;	23456789↑↓←→@
; @addr{00a1}
secretSymbols:
	.asc "BDFGHJLM"
	.db $13 $bd $12 $11 $23
	.asc "NQRSTWY!"
	.db $10 $7e $7f $2b $2d
	.asc "bdfghjm$*/:~"
	.asc "nqrstwy?%&<=>"
	.asc "23456789"
	.db $15 $16 $17 $18 $40

	.db $00 ; Null terminator

; Filler?
	.DB         $00 $00 $00 $00 $00 $ff	; $00e2
	.DB $00 $00 $00 $00 $00 $00 $00 $00	; $00e8
	.DB $00 $00 $00 $00 $00 $00 $00 $00	; $00f0

;;;
bitTable:
	.db $01 $02 $04 $08 $10 $20 $40 $80	; $00f8

; Entry point
	nop			; $0100
	jp begin

.ENDS


; ROM title / manufacturer code
.ORGA $134

.ifdef ROM_SEASONS
	.asc "ZELDA DIN" 0 0
	.asc "AZ7E"
.else ; ROM_AGES
	.asc "ZELDA NAYRU"
	.asc "AZ8E"
.endif


.ORGA $150

.SECTION "Bank 0"

;;
; The game's entrypoint.
; @addr{0150}
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
	jpfrombank0 init


;;
; Get the number of set bits in a.
;
; @param	a	Value to check
; @param[out]	a,b	Number of set bits in 'a'
; @addr{0176}
getNumSetBits:
	ld b,$00		; $0176
-
	add a			; $0178
	jr nc,+
	inc b			; $017b
+
	or a			; $017c
	jr nz,-
	ld a,b			; $017f
	ret			; $0180

;;
; Add a bcd-encoded number to a 16-bit memory address. If it would go above $9999, the
; result is $9999.
;
; @param[in]  bc	Number to add.
; @param[in]  hl	Address to add with and store result into.
; @param[out] cflag	Set if the value would have gone over $9999.
; @addr{0181}
addDecimalToHlRef:
	ld a,(hl)		; $0181
	add c			; $0182
	daa			; $0183
	ldi (hl),a		; $0184
	ld a,(hl)		; $0185
	adc b			; $0186
	daa			; $0187
	ldd (hl),a		; $0188
	ret nc			; $0189
	ld a,$63		; $018a
	ldi (hl),a		; $018c
	ldd (hl),a		; $018d
	ret			; $018e

;;
; Subtract a bcd-encoded number from a 16-bit memory address. If it would go below 0, the
; result is 0.
;
; @param	bc	Value to subtract.
; @param	hl	Address to subtract with and store result into.
; @param[out]	cflag	Set if the value would have gone under $0000.
; @addr{018f}
subDecimalFromHlRef:
	ld a,(hl)		; $018f
	sub c			; $0190
	daa			; $0191
	ldi (hl),a		; $0192
	ld a,(hl)		; $0193
	sbc b			; $0194
	daa			; $0195
	ldd (hl),a		; $0196
	ret nc			; $0197
	xor a			; $0198
	ldi (hl),a		; $0199
	ldd (hl),a		; $019a
	scf			; $019b
	ret			; $019c

;;
; @param	a	Operand 1
; @param	c	Operand 2
; @param[out]	hl	Result
; @trashes{b,e}
; @addr{019d}
multiplyAByC:
	ld e,$08		; $019d
	ld b,$00		; $019f
	ld l,b			; $01a1
	ld h,b			; $01a2
-
	add hl,hl		; $01a3
	add a			; $01a4
	jr nc,+
	add hl,bc		; $01a7
+
	dec e			; $01a8
	jr nz,-
	ret			; $01ab

;;
; Multiply 'a' by $10, store result in bc.
;
; @param	a	Value to multiply
; @param[out]	bc	Result
; @addr{01ac}
multiplyABy16:
	swap a			; $01ac
	ld b,a			; $01ae
	and $f0			; $01af
	ld c,a			; $01b1
	ld a,b			; $01b2
	and $0f			; $01b3
	ld b,a			; $01b5
	ret			; $01b6

;;
; Multiply 'a' by 8, store result in bc.
;
; @param	a	Value to multiply
; @param[out]	bc	Result
; @addr{01b7}
multiplyABy8:
	swap a			; $01b7
	rrca			; $01b9
	ld b,a			; $01ba
	and $f8			; $01bb
	ld c,a			; $01bd
	ld a,b			; $01be
	and $07			; $01bf
	ld b,a			; $01c1
	ret			; $01c2

;;
; Multiply 'a' by 4, store result in bc.
;
; @param	a	Value to multiply
; @param[out]	bc	Result
; @addr{01c3}
multiplyABy4:
	ld b,$00		; $01c3
	add a			; $01c5
	rl b			; $01c6
	add a			; $01c8
	rl b			; $01c9
	ld c,a			; $01cb
	ret			; $01cc

;;
; Convert a signed 8-bit value in 'a' to signed 16-bit value in 'bc'
;
; @param	a	Signed value
; @param[out]	bc	Signed 16-bit value
; @addr{01cd}
s8ToS16:
	ld b,$ff		; $01cd
	bit 7,a			; $01cf
	jr nz,+
	inc b			; $01d3
+
	ld c,a			; $01d4
	ret			; $01d5

;;
; @param[out]	a	$ff if hl < bc, $01 if hl > bc, $00 if equal
; @param[out]	cflag	c if hl < bc, nc otherwise
; @addr{01d6}
compareHlToBc:
	ld a,h			; $01d6
	cp b			; $01d7
	jr c,+
	jr nz,++
	ld a,l			; $01dc
	cp c			; $01dd
	jr c,+
	jr nz,++
	xor a			; $01e2
	ret			; $01e3
+
	ld a,$ff		; $01e4
	ret			; $01e6
++
	ld a,$01		; $01e7
	ret			; $01e9

;;
; This returns the highest set bit in 'a', which in effect is like log base 2.
;
; @param[out]	a	Bit value (0-7) or unchanged if no bits are set
; @param[out]	cflag	c if at least one bit was set (output is valid)
; @addr{01ea}
getHighestSetBit:
	or a			; $01ea
	ret z			; $01eb
	push bc			; $01ec
	ld c,$ff		; $01ed
-
	inc c			; $01ef
	srl a			; $01f0
	jr nz,-
	ld a,c			; $01f4
	pop bc			; $01f5
	scf			; $01f6
	ret			; $01f7

;;
; @param[out]	a	Bit value (0-7) or unchanged if no bits are set
; @param[out]	cflag	c if at least one bit was set (output is valid)
; @addr{01f8}
getLowestSetBit:
	or a			; $01f8
	ret z			; $01f9
	push bc			; $01fa
	ld c,$08		; $01fb
-
	dec c			; $01fd
	add a			; $01fe
	jr nz,-
	ld a,c			; $0201
	pop bc			; $0202
	scf			; $0203
	ret			; $0204

;;
; A "flag" is just a bit in memory. These flag-related functions take a base address
; ('hl'), and check a bit in memory starting at that address ('a').
;
; @param	a	Flag to check
; @param	hl	Start address of flags
; @param[out]	a	AND result
; @param[out]	zflag	Set if the flag is not set.
; @addr{0205}
checkFlag:
	push hl			; $0205
	push bc			; $0206
	call _flagHlpr		; $0207
	and (hl)		; $020a
	pop bc			; $020b
	pop hl			; $020c
	ret			; $020d

;;
; @param	a	Flag to set
; @param	hl	Start address of flags
; @addr{020e}
setFlag:
	push hl			; $020e
	push bc			; $020f
	call _flagHlpr		; $0210
	or (hl)			; $0213
	ld (hl),a		; $0214
	pop bc			; $0215
	pop hl			; $0216
	ret			; $0217

;;
; @param	a	Flag to unset
; @param	hl	Start address of flags
; @addr{0218}
unsetFlag:
	push hl			; $0218
	push bc			; $0219
	call _flagHlpr		; $021a
	cpl			; $021d
	and (hl)		; $021e
	ld (hl),a		; $021f
	pop bc			; $0220
	pop hl			; $0221
	ret			; $0222

;;
; Add (a/8) to hl, set 'a' to a bitmask for the desired bit (a%8)
;
; @addr{0223}
_flagHlpr:
	ld b,a			; $0223
	and $f8			; $0224
	rlca			; $0226
	swap a			; $0227
	ld c,a			; $0229
	ld a,b			; $022a
	ld b,$00		; $022b
	add hl,bc		; $022d
	and $07			; $022e
	ld bc,bitTable		; $0230
	add c			; $0233
	ld c,a			; $0234
	ld a,(bc)		; $0235
	ret			; $0236

;;
; @addr{0237}
decHlRef16WithCap:
	inc hl			; $0237
	ldd a,(hl)		; $0238
	or (hl)			; $0239
	ret z			; $023a
	ld a,(hl)		; $023b
	sub $01			; $023c
	ldi (hl),a		; $023e
	ld a,(hl)		; $023f
	sbc $00			; $0240
	ldd (hl),a		; $0242
	or (hl)			; $0243
	ret			; $0244

;;
; @addr{0245}
incHlRefWithCap:
	inc (hl)		; $0245
	ret nz			; $0246
	ld (hl),$ff		; $0247
	ret			; $0249

;;
; @addr{024a}
incHlRef16WithCap:
	inc (hl)		; $024a
	ret nz			; $024b
	inc hl			; $024c
	inc (hl)		; $024d
	jr z,+
	dec hl			; $0250
	ret			; $0251
+
	push af			; $0252
	ld a,$ff		; $0253
	ldd (hl),a		; $0255
	ld (hl),a		; $0256
	pop af			; $0257
	ret			; $0258

;;
; Convert hex value in a to a bcd-encoded decimal value in bc
;
; @param	a	Hexadecimal number
; @param[out]	bc	bcd-encoded decimal number
; @addr{0259}
hexToDec:
	ld bc,$0000		; $0259
-
	cp 100			; $025c
	jr c,@doneHundreds	; $025e
	sub 100			; $0260
	inc b			; $0262
	jr -

@doneHundreds:
	cp 10			; $0265
	ret c			; $0267
	sub 10			; $0268
	inc c			; $026a
	jr @doneHundreds		; $026b

;;
; Update wKeysPressed, wKeysJustPressed, and wKeysPressedLastFrame.
;
; @trashes{bc,hl}
; @addr{026d}
pollInput:
	ld c,R_P1		; $026d
	ld a,$20		; $026f
	ld ($ff00+c),a		; $0271
	ld a,($ff00+c)		; $0272
	ld a,($ff00+c)		; $0273
	ld a,($ff00+c)		; $0274
	ld b,a			; $0275
	ld a,$10		; $0276
	ld ($ff00+c),a		; $0278
	ld a,b			; $0279
	and $0f			; $027a
	swap a			; $027c
	ld b,a			; $027e
	ld hl,wKeysPressed
	ldd a,(hl)		; $0282
	ldi (hl),a		; $0283
	cpl			; $0284
	ld (hl),a		; $0285
	ld a,($ff00+c)		; $0286
	ld a,($ff00+c)		; $0287
	and $0f			; $0288
	or b			; $028a
	cpl			; $028b
	ld b,(hl)		; $028c
	ldi (hl),a		; $028d
	and b			; $028e
	ld (hl),a		; $028f
	ld a,$30		; $0290
	ld ($ff00+c),a		; $0292
	ret			; $0293

;;
; @addr{0294}
getInputWithAutofire:
	push hl			; $0294
	push bc			; $0295
	ld a,(wKeysPressed)		; $0296
	and $f0			; $0299
	ld b,a			; $029b
	ld hl,wAutoFireKeysPressed
	ld a,(hl)		; $029f
	and b			; $02a0
	ld a,b			; $02a1
	ldi (hl),a		; $02a2
	jr z,+
	inc (hl)		; $02a5
	ld a,(hl)		; $02a6
	cp $28			; $02a7
	jr c,++
	and $1f			; $02ab
	or $80			; $02ad
	ld (hl),a		; $02af
	and $03			; $02b0
	jr nz,++
	ld a,(wKeysPressed)
	jr +++
+
	xor a			; $02b9
	ld (hl),a		; $02ba
++
	ld a,(wKeysJustPressed)		; $02bb
+++
	pop bc			; $02be
	pop hl			; $02bf
	ret			; $02c0

;;
; @addr{02c1}
disableLcd:
	ld a,($ff00+R_LCDC)	; $02c1
	rlca			; $02c3
	ret nc			; $02c4
	push bc			; $02c5
	ld a,($ff00+R_IE)	; $02c6
	ld b,a			; $02c8
	and INT_VBLANK ~ $FF
	ld ($ff00+R_IE),a	; $02cb
-
	ld a,($ff00+R_LY)	; $02cd
	cp $91			; $02cf
	jr c,-
	ld a,$03		; $02d3
	ldh (<hNextLcdInterruptBehaviour),a	; $02d5
	xor a			; $02d7
	ld (wGfxRegsFinal.LCDC),a		; $02d8
	ld (wGfxRegs2.LCDC),a		; $02db
	ld (wGfxRegs1.LCDC),a		; $02de
	ld ($ff00+R_LCDC),a	; $02e1
	ld ($ff00+R_IF),a	; $02e3
	ld a,b			; $02e5
	ld ($ff00+R_IE),a	; $02e6
	pop bc			; $02e8
	ret			; $02e9

;;
; @param	a	Gfx register state index to load
; @addr{02ea}
loadGfxRegisterStateIndex:
	; a *= $06
	ld l,a			; $02ea
	add a			; $02eb
	add l			; $02ec
	add a			; $02ed

	ld hl,gfxRegisterStates
	rst_addDoubleIndex			; $02f1
	ld b,GfxRegsStruct.size*2
	ld de,wGfxRegs1		; $02f4
-
	ldi a,(hl)		; $02f7
	ld (de),a		; $02f8
	inc e			; $02f9
	dec b			; $02fa
	jr nz,-
	ld a,(wGfxRegs1.LCDC)		; $02fd
	ld (wGfxRegsFinal.LCDC),a		; $0300
	ld ($ff00+R_LCDC),a	; $0303
	ret			; $0305

; @addr{0306}
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
; @addr{043e}
getRandomNumber:
	push hl			; $043e
	push bc			; $043f
	ldh a,(<hRng1)	; $0440
	ld l,a			; $0442
	ld c,a			; $0443
	ldh a,(<hRng2)	; $0444
	ld h,a			; $0446
	ld b,a			; $0447
	add hl,hl		; $0448
	add hl,bc		; $0449
	ld a,h			; $044a
	ldh (<hRng2),a	; $044b
	add c			; $044d
	ldh (<hRng1),a	; $044e
	pop bc			; $0450
	pop hl			; $0451
	ret			; $0452

;;
; Same as above, except it doesn't preserve bc and hl. It's a little faster I guess?
;
; @param[out]	a,c	Random number
; @param[out]	hl	Intermediate calculation (sometimes also used as random values?)
; @addr{0453}
getRandomNumber_noPreserveVars:
	ldh a,(<hRng1)	; $0453
	ld l,a			; $0455
	ld c,a			; $0456
	ldh a,(<hRng2)	; $0457
	ld h,a			; $0459
	ld b,a			; $045a
	add hl,hl		; $045b
	add hl,bc		; $045c
	ld a,h			; $045d
	ldh (<hRng2),a	; $045e
	add c			; $0460
	ldh (<hRng1),a	; $0461
	ret			; $0463

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
; @addr{0464}
getRandomIndexFromProbabilityDistribution:
	ld b,$00		; $0464
	call getRandomNumber
-
	sub (hl)		; $0469
	ret c			; $046a
	inc hl			; $046b
	inc b			; $046c
	jr -

;;
; @param	b	# of bytes to clear
; @param	hl	Memory to clear
; @addr{046f}
clearMemory:
	xor a			; $046f

;;
; @param	a	Value to fill memory with
; @param	b	# of bytes to fill
; @param	hl	Memory to fill
; @addr{0470}
fillMemory:
	ldi (hl),a		; $0470
	dec b			; $0471
	jr nz,fillMemory
	ret			; $0474

;;
; @param	bc	# of bytes to clear
; @param	hl	Memory to clear
; @addr{0475}
clearMemoryBc:
	xor a			; $0475

;;
; @param	a	Value to fill memory with
; @param	bc	# of bytes to fill
; @param	hl	Memory to fill
; @addr{0476}
fillMemoryBc:
	ld e,a			; $0476
-
	ld a,e			; $0477
	ldi (hl),a		; $0478
	dec bc			; $0479
	ld a,c			; $047a
	or b			; $047b
	jr nz,-
	ret			; $047e

;;
; @param	b	# of bytes to copy
; @param	de	Source
; @param	hl	Destination
; @addr{047f}
copyMemoryReverse:
	ld a,(de)		; $047f
	ldi (hl),a		; $0480
	inc de			; $0481
	dec b			; $0482
	jr nz,copyMemoryReverse
	ret			; $0485

;;
; @param	b	# of bytes to copy
; @param	de	Destination
; @param	hl	Source
; @addr{0486}
copyMemory:
	ldi a,(hl)		; $0486
	ld (de),a		; $0487
	inc de			; $0488
	dec b			; $0489
	jr nz,copyMemory
	ret			; $048c

;;
; @param	bc	# of bytes to copy
; @param	de	Source
; @param	hl	Destination
; @addr{048d}
copyMemoryBcReverse:
	ld a,(de)		; $048d
	ldi (hl),a		; $048e
	inc de			; $048f
	dec bc			; $0490
	ld a,b			; $0491
	or c			; $0492
	jr nz,copyMemoryBcReverse
	ret			; $0495

;;
; @param	bc	# of bytes to copy
; @param	de	Destination
; @param	hl	Source
; @addr{0496}
copyMemoryBc:
	ldi a,(hl)		; $0496
	ld (de),a		; $0497
	inc de			; $0498
	dec bc			; $0499
	ld a,b			; $049a
	or c			; $049b
	jr nz,copyMemoryBc
	ret			; $049e

;;
; @addr{049f}
clearOam:
	xor a			; $049f
	ldh (<hOamTail),a	; $04a0
	ld h, wOam>>8
	ld b,$e0		; $04a4
-
	ld l,a			; $04a6
	ld (hl),b		; $04a7
	add $04			; $04a8
	cp <wOamEnd			; $04aa
	jr c,-
	ret			; $04ae

;;
; @addr{04af}
clearVram:
	call disableLcd		; $04af
	call clearOam
	ld a,$01		; $04b5
	ld ($ff00+R_VBK),a	; $04b7
	ld hl,$8000		; $04b9
	ld bc,$2000		; $04bc
	call clearMemoryBc		; $04bf
	xor a			; $04c2
	ld ($ff00+R_VBK),a	; $04c3
	ld hl,$8000		; $04c5
	ld bc,$2000		; $04c8
	jr clearMemoryBc

;;
; @addr{04cd}
initializeVramMaps:
	call initializeVramMap1		; $04cd
;;
; @addr{04d0}
initializeVramMap0:
	call disableLcd		; $04d0
	ld a,$01		; $04d3
	ld ($ff00+R_VBK),a	; $04d5
	ld hl,$9800		; $04d7
	ld bc,$0400		; $04da
	ld a,$80		; $04dd
	call fillMemoryBc		; $04df
	xor a			; $04e2
	ld ($ff00+R_VBK),a	; $04e3
	ld hl,$9800		; $04e5
	ld bc,$0400		; $04e8
	jr clearMemoryBc

;;
; @addr{04ed}
initializeVramMap1:
	call disableLcd		; $04ed
	ld a,$01		; $04f0
	ld ($ff00+R_VBK),a	; $04f2
	ld hl,$9c00		; $04f4
	ld bc,$0400		; $04f7
	ld a,$80		; $04fa
	call fillMemoryBc		; $04fc
	xor a			; $04ff
	ld ($ff00+R_VBK),a	; $0500
	ld hl,$9c00		; $0502
	ld bc,$0400		; $0505
	jp clearMemoryBc		; $0508

;;
; @param	a	Palette header to load (see data/[ages|seasons]/paletteHeaders.s)
; @addr{050b}
loadPaletteHeader:
	push de			; $050b
	ld l,a			; $050c
	ld a,($ff00+R_SVBK)	; $050d
	ld c,a			; $050f
	ldh a,(<hRomBank)	; $0510
	ld b,a			; $0512
	push bc			; $0513
	ld a,$02		; $0514
	ld ($ff00+R_SVBK),a	; $0516
	ld a,:paletteHeaderTable
	setrombank		; $051a
	ld a,l			; $051f
	ld hl,paletteHeaderTable
	rst_addDoubleIndex			; $0523
	ldi a,(hl)		; $0524
	ld h,(hl)		; $0525
	ld l,a			; $0526
---
	ld a,:paletteHeaderTable
	setrombank		; $0529

	; b: how many palettes to load
	ld a,(hl)		; $052e
	and $07			; $052f
	inc a			; $0531
	ld b,a			; $0532

	; c: which palette to start on
	ld a,(hl)		; $0533
	rlca			; $0534
	swap a			; $0535
	and $07			; $0537
	ld de,bitTable		; $0539
	add e			; $053c
	ld e,a			; $053d
	ld a,(de)		; $053e
	ld c,a			; $053f

	; Turn b into a bitmask for which palettes to load
	xor a			; $0540
-
	or c			; $0541
	dec b			; $0542
	jr z,+
	rlca			; $0545
	jr -
+
	ld b,a			; $0548

	; Mark palettes as dirty
	ld c,<hDirtyBgPalettes
	bit 6,(hl)		; $054b
	jr z,+
	ld c,<hDirtySprPalettes
+
	ld a,($ff00+c)		; $0551
	or b			; $0552
	ld ($ff00+c),a		; $0553

	; de = destination
	ld a,(hl)		; $0554
	and $78			; $0555
	add w2TilesetBgPalettes&$ff
	ld e,a			; $0559
	ld d, w2TilesetBgPalettes>>8

	; b = number of palettes
	ld a,(hl)		; $055c
	and $07			; $055d
	inc a			; $055f
	ld b,a			; $0560

	; Set carry if there's another palette header to process
	ldi a,(hl)		; $0561
	rlca			; $0562

	; Load pointer to actual palette data into hl
	ldi a,(hl)		; $0563
	ld c,a			; $0564
	ldi a,(hl)		; $0565
	push hl			; $0566
	ld l,c			; $0567
	ld h,a			; $0568

	; Set bank, begin copying
	ld a,:paletteDataStart
	setrombank		; $056b
--
	ld c,$08		; $0570
-
	ldi a,(hl)		; $0572
	ld (de),a		; $0573
	inc e			; $0574
	dec c			; $0575
	jr nz,-
	dec b			; $0578
	jr nz,--
	pop hl			; $057b
	jr c,---

	pop bc			; $057e
	ld a,b			; $057f
	setrombank		; $0580
	ld a,c			; $0585
	ld ($ff00+R_SVBK),a	; $0586
	pop de			; $0588
	ret			; $0589

;;
; Do a DMA transfer next vblank. Note:
;  - Only banks $00-$3f work properly
;  - Destination address must be a multiple of 16
; @param	b	(data size)/16 - 1
; @param	c	src bank
; @param	de	(dest address) | (vram or wram bank)
; @param	hl	src address
; @param[out]	cflag	Set if the lcd is on (data can't be copied immediately)
; @trashes{hl}
; @addr{058a}
queueDmaTransfer:
	ld a,($ff00+R_LCDC)	; $058a
	rlca			; $058c
	jr nc,++

	push de			; $058f
	push hl			; $0590
	ld h,wVBlankFunctionQueue>>8
	ldh a,(<hVBlankFunctionQueueTail)
	ld l,a			; $0595
	ld a,(vblankDmaFunctionOffset)		; $0596
	ldi (hl),a		; $0599
	ld a,c			; $059a
	ldi (hl),a		; $059b
	pop de			; $059c
	ld a,d			; $059d
	ldi (hl),a		; $059e
	ld a,e			; $059f
	ldi (hl),a		; $05a0
	pop de			; $05a1
	ld a,e			; $05a2
	ldi (hl),a		; $05a3
	ld a,d			; $05a4
	ldi (hl),a		; $05a5
	ld a,e			; $05a6
	ldi (hl),a		; $05a7
	ld a,b			; $05a8
	ldi (hl),a		; $05a9
	ld a,l			; $05aa
	ldh (<hVBlankFunctionQueueTail),a	; $05ab
	scf			; $05ad
	ret			; $05ae
++
; If LCD is off, copy data immediately?
	ldh a,(<hRomBank)	; $05af
	push af			; $05b1
	ld a,($ff00+R_SVBK)	; $05b2
	push af			; $05b4
	push de			; $05b5
	push hl			; $05b6
	ld a,c			; $05b7
	ld ($ff00+R_SVBK),a	; $05b8
	setrombank		; $05ba
	pop de			; $05bf
	ld hl, HDMA1
	ld (hl),d		; $05c3
	inc l			; $05c4
	ld (hl),e		; $05c5
	inc l			; $05c6
	pop de			; $05c7
	ld a,e			; $05c8
	ld ($ff00+R_VBK),a	; $05c9
	ld (hl),d		; $05cb
	inc l			; $05cc
	ldi (hl),a		; $05cd
	ld (hl),b		; $05ce
	pop af			; $05cf
	ld ($ff00+R_SVBK),a	; $05d0
	pop af			; $05d2
	setrombank		; $05d3
	xor a			; $05d8
	ret			; $05d9

;;
; @param	a	Uncompressed gfx header index to load
; @trashes{bc,de,hl}
; @addr{05da}
loadUncompressedGfxHeader:
	ld e,a			; $05da
	ld a,($ff00+R_SVBK)	; $05db
	ld c,a			; $05dd
	ldh a,(<hRomBank)	; $05de
	ld b,a			; $05e0
	push bc			; $05e1
	ld a,:uncmpGfxHeaderTable		; $05e2
	setrombank		; $05e4
	ld a,e			; $05e9
	ld hl,uncmpGfxHeaderTable		; $05ea
	rst_addDoubleIndex			; $05ed
	ldi a,(hl)		; $05ee
	ld h,(hl)		; $05ef
	ld l,a			; $05f0
--
	ldi a,(hl)		; $05f1
	ld c,a			; $05f2
	ldi a,(hl)		; $05f3
	ld d,a			; $05f4
	ldi a,(hl)		; $05f5
	ld e,a			; $05f6
	push de			; $05f7
	ldi a,(hl)		; $05f8
	ld d,a			; $05f9
	ldi a,(hl)		; $05fa
	ld e,a			; $05fb
	ld a,(hl)		; $05fc
	and $7f			; $05fd
	ld b,a			; $05ff
	ld a,l			; $0600
	ldh (<hFF90),a	; $0601
	ld a,h			; $0603
	ldh (<hFF91),a	; $0604
	pop hl			; $0606
	call queueDmaTransfer		; $0607
	ld a,:uncmpGfxHeaderTable		; $060a
	setrombank		; $060c
	ldh a,(<hFF90)	; $0611
	ld l,a			; $0613
	ldh a,(<hFF91)	; $0614
	ld h,a			; $0616
	ldi a,(hl)		; $0617
	add a			; $0618
	jr c,--

	pop bc			; $061b
	ld a,b			; $061c
	setrombank		; $061d
	ld a,c			; $0622
	ld ($ff00+R_SVBK),a	; $0623
	ret			; $0625

;;
; @param	a	The index of the gfx header to load
; @addr{0626}
loadGfxHeader:
	ld e,a			; $0626
	ld a,($ff00+R_SVBK)	; $0627
	ld c,a			; $0629
	ldh a,(<hRomBank)	; $062a
	ld b,a			; $062c
	push bc			; $062d
	ld a,:gfxHeaderTable
	setrombank		; $0630
	ld a,e			; $0635
	ld hl,gfxHeaderTable
	rst_addDoubleIndex			; $0639
	ldi a,(hl)		; $063a
	ld h,(hl)		; $063b
	ld l,a			; $063c
--
	ldi a,(hl)		; $063d
	ld c,a			; $063e
	ldi a,(hl)		; $063f
	ld d,a			; $0640
	ldi a,(hl)		; $0641
	ld e,a			; $0642
	push de			; $0643
	ldi a,(hl)		; $0644
	ld d,a			; $0645
	ldi a,(hl)		; $0646
	ld e,a			; $0647
	ld a,(hl)		; $0648
	and $7f			; $0649
	ld b,a			; $064b
	ld a,l			; $064c
	ldh (<hFF90),a	; $064d
	ld a,h			; $064f
	ldh (<hFF91),a	; $0650
	pop hl			; $0652
	call decompressGraphics		; $0653
	ld a,:gfxHeaderTable		; $0656
	setrombank		; $0658
	ldh a,(<hFF90)	; $065d
	ld l,a			; $065f
	ldh a,(<hFF91)	; $0660
	ld h,a			; $0662
	ldi a,(hl)		; $0663
	add a			; $0664
	jr c,--

	pop bc			; $0667
	ld a,b			; $0668
	setrombank		; $0669
	ld a,c			; $066e
	ld ($ff00+R_SVBK),a	; $066f
	ret			; $0671

;;
; Deals with graphics compression
;
; @param	b	Data size (divided by 16, minus 1)
; @param	c	ROM bank (bits 0-5) and compression mode (bits 6-7)
; @param	de	Destination (lower 4 bits = destination bank, either vram or wram)
; @param	hl	Source
; @addr{0672}
decompressGraphics:
	ld a,e			; $0672
	and $0f			; $0673
	ld ($ff00+R_VBK),a	; $0675
	ld ($ff00+R_SVBK),a	; $0677
	xor e			; $0679
	ld e,a			; $067a
	ld a,c			; $067b
	and $3f			; $067c
	setrombank		; $067e
	inc b			; $0683
	ld a,c			; $0684
	and $c0			; $0685
	jp z,func_06e0		; $0687
	cp $c0			; $068a
	jr z,_label_00_059	; $068c
	cp $40			; $068e
	jr z,_label_00_060	; $0690
	ld a,b			; $0692
-
	push af			; $0693
	call func_069c		; $0694
	pop af			; $0697
	dec a			; $0698
	jr nz,-			; $0699
	ret			; $069b

;;
; @addr{069c}
func_069c:
	call readByteSequential		; $069c
	ld c,a			; $069f
	call readByteSequential		; $06a0
	ldh (<hFF8A),a	; $06a3
	or c			; $06a5
	jr nz,_label_00_050	; $06a6
	ld b,$10		; $06a8
_label_00_049:
	call readByteSequential		; $06aa
	ld (de),a		; $06ad
	inc de			; $06ae
	dec b			; $06af
	jr nz,_label_00_049	; $06b0
	ret			; $06b2
_label_00_050:
	call readByteSequential		; $06b3
	ldh (<hFF8B),a	; $06b6
	ld b,$08		; $06b8
_label_00_051:
	rl c			; $06ba
	jr c,_label_00_052	; $06bc
	call readByteSequential		; $06be
	jr _label_00_053		; $06c1
_label_00_052:
	ldh a,(<hFF8B)	; $06c3
_label_00_053:
	ld (de),a		; $06c5
	inc de			; $06c6
	dec b			; $06c7
	jr nz,_label_00_051	; $06c8
	ldh a,(<hFF8A)	; $06ca
	ld c,a			; $06cc
	ld b,$08		; $06cd
_label_00_054:
	rl c			; $06cf
	jr c,_label_00_055	; $06d1
	call readByteSequential		; $06d3
	jr _label_00_056		; $06d6
_label_00_055:
	ldh a,(<hFF8B)	; $06d8
_label_00_056:
	ld (de),a		; $06da
	inc de			; $06db
	dec b			; $06dc
	jr nz,_label_00_054	; $06dd
	ret			; $06df

;;
; @addr{06e0}
func_06e0:
	ld c,$10		; $06e0
-
	call readByteSequential		; $06e2
	ld (de),a		; $06e5
	inc de			; $06e6
	dec c			; $06e7
	jr nz,-
	dec b			; $06ea
	jr nz,func_06e0	; $06eb
	ret			; $06ed

_label_00_059:
	ld a,$ff		; $06ee
	jr _label_00_061		; $06f0
_label_00_060:
	xor a			; $06f2
	ldh (<hFF93),a	; $06f3
_label_00_061:
	ldh (<hFF8E),a	; $06f5
	swap b			; $06f7
	ld a,b			; $06f9
	and $f0			; $06fa
	ld c,a			; $06fc
	xor b			; $06fd
	ld b,a			; $06fe
	ld a,$01		; $06ff
	ldh (<hFF8B),a	; $0701
_label_00_062:
	ldh a,(<hFF8B)	; $0703
	dec a			; $0705
	ldh (<hFF8B),a	; $0706
	jr nz,_label_00_063	; $0708
	ld a,$08		; $070a
	ldh (<hFF8B),a	; $070c
	ldi a,(hl)		; $070e
	ldh (<hFF8A),a	; $070f
	call _adjustHLSequential		; $0711
_label_00_063:
	ldh a,(<hFF8A)	; $0714
	add a			; $0716
	ldh (<hFF8A),a	; $0717
	jr c,_label_00_064	; $0719
	call copyByteSequential		; $071b
	jr nz,_label_00_062	; $071e
	ret			; $0720
_label_00_064:
	ldh a,(<hFF8E)	; $0721
	or a			; $0723
	jr nz,_label_00_065	; $0724
	ld a,(hl)		; $0726
	and $1f			; $0727
	ldh (<hFF92),a	; $0729
	xor (hl)		; $072b
	jr z,_label_00_066	; $072c
	swap a			; $072e
	rrca			; $0730
	inc a			; $0731
	jr _label_00_067		; $0732
_label_00_065:
	ldi a,(hl)		; $0734
	ldh (<hFF92),a	; $0735
	call _adjustHLSequential		; $0737
	ld a,(hl)		; $073a
	and $07			; $073b
	ldh (<hFF93),a	; $073d
	xor (hl)		; $073f
	jr z,_label_00_066	; $0740
	rrca			; $0742
	rrca			; $0743
	rrca			; $0744
	add $02			; $0745
	jr _label_00_067		; $0747
_label_00_066:
	inc hl			; $0749
	call _adjustHLSequential		; $074a
	ld a,(hl)		; $074d
_label_00_067:
	ldh (<hFF8F),a	; $074e
	inc hl			; $0750
	call _adjustHLSequential		; $0751
	push hl			; $0754
	ldh a,(<hFF92)	; $0755
	cpl			; $0757
	ld l,a			; $0758
	ldh a,(<hFF93)	; $0759
	cpl			; $075b
	ld h,a			; $075c
	add hl,de		; $075d
_label_00_068:
	ldi a,(hl)		; $075e
	ld (de),a		; $075f
	inc de			; $0760
	dec bc			; $0761
	ld a,b			; $0762
	or c			; $0763
	jr z,_label_00_069	; $0764
	ldh a,(<hFF8F)	; $0766
	dec a			; $0768
	ldh (<hFF8F),a	; $0769
	jr nz,_label_00_068	; $076b
	pop hl			; $076d
	jr _label_00_062		; $076e
_label_00_069:
	pop hl			; $0770
	ret			; $0771


;;
; Copies a single byte, and checks whether to increment the bank.
; @param	bc	Amount of bytes to read (not enforced here)
; @param	de	Address to write data to
; @param	hl	Address to read data from
; @param[out]	zflag	Set if bc reaches 0.
; @addr{0772}
copyByteSequential:
	ldi a,(hl)		; $0772
	ld (de),a		; $0773
	inc de			; $0774
	dec bc			; $0775

;;
; Adjusts the value of hl and the current loaded bank for various "sequental read"
; functions.
; @param	hl	Address
; @param[out]	zflag	Set if bc is 0.
; @addr{0776}
_adjustHLSequential:
	ld a,h			; $0776
	cp $80			; $0777
	jr nz,+
	ld h,$40		; $077b
	ldh a,(<hRomBank)	; $077d
	inc a			; $077f
	setrombank		; $0780
+
	ld a,b			; $0785
	or c			; $0786
	ret			; $0787

;;
; @param	hl	Address to read from
; @addr{0788}
readByteSequential:
	ldi a,(hl)		; $0788
	bit 7,h			; $0789
	ret z			; $078b
	push af			; $078c
	ld h,$40		; $078d
	ldh a,(<hRomBank)	; $078f
	inc a			; $0791
	setrombank		; $0792
	pop af			; $0797
	ret			; $0798

;;
; @param	a	Tileset to load (tilesets include collision data and tile indices)
; @addr{0799}
loadTileset:
	ld e,a			; $0799
	ld a,($ff00+R_SVBK)	; $079a
	ld c,a			; $079c
	ldh a,(<hRomBank)	; $079d
	ld b,a			; $079f
	push bc			; $07a0

	ld a,:tilesetLayoutTable
	setrombank		; $07a3
	ld a,e			; $07a8
	ld hl,tilesetLayoutTable
	rst_addDoubleIndex			; $07ac
	ldi a,(hl)		; $07ad
	ld h,(hl)		; $07ae
	ld l,a			; $07af
--
	ldi a,(hl)		; $07b0
	push hl			; $07b1
	ld hl,tilesetLayoutDictionaryTable
	rst_addDoubleIndex			; $07b5
	ldi a,(hl)		; $07b6
	ld h,(hl)		; $07b7
	ld l,a			; $07b8
	ldi a,(hl)		; $07b9
	ldh (<hFF8F),a	; $07ba
	ldi a,(hl)		; $07bc
	ldh (<hFF91),a	; $07bd
	ldi a,(hl)		; $07bf
	ldh (<hFF90),a	; $07c0
	pop hl			; $07c2

	; Get source data bank
	ldi a,(hl)		; $07c3
	ldh (<hFF8E),a	; $07c4

	; Load data pointer to stack for later use
	ldi a,(hl)		; $07c6
	ld d,a			; $07c7
	ldi a,(hl)		; $07c8
	ld e,a			; $07c9
	push de			; $07ca

	; Load destination in de
	ldi a,(hl)		; $07cb
	ld d,a			; $07cc
	ldi a,(hl)		; $07cd
	ld e,a			; $07ce

	; Write data size into ff8c
	ldi a,(hl)		; $07cf
	and $7f			; $07d0
	ldh (<hFF8D),a	; $07d2
	ldd a,(hl)		; $07d4
	ldh (<hFF8C),a	; $07d5

	; Store header position into ff92
	ld a,h			; $07d7
	ldh (<hFF93),a	; $07d8
	ld a,l			; $07da
	ldh (<hFF92),a	; $07db

	; Data pointer in hl
	pop hl			; $07dd
	call loadTilesetHlpr		; $07de

	ld a,:tilesetLayoutTable
	setrombank		; $07e3

	; Retrieve header position
	ldh a,(<hFF93)	; $07e8
	ld h,a			; $07ea
	ldh a,(<hFF92)	; $07eb
	ld l,a			; $07ed

	; Check if repeat bit is set
	ldi a,(hl)		; $07ee
	inc hl			; $07ef
	add a			; $07f0
	jr c,--

	pop bc			; $07f3
	ld a,b			; $07f4
	setrombank		; $07f5
	ld a,c			; $07fa
	ld ($ff00+R_SVBK),a	; $07fb
	ret			; $07fd

;;
; @param	hl	pointer to compressed data
; @param	[ff8e]	bank of compressed data
; @addr{07fe}
loadTilesetHlpr:

; Internal variables:
; ff8a: size of chunk to read from dictionary
; ff8b: "key" byte (sorry bad at explaining)

	ld a,e			; $07fe
	and $0f			; $07ff
	ld ($ff00+R_VBK),a	; $0801
	ld ($ff00+R_SVBK),a	; $0803
	xor e			; $0805
	ld e,a			; $0806
----
	ldh a,(<hFF8E)	; $0807
	setrombank		; $0809
	ldi a,(hl)		; $080e
	ldh (<hFF8B),a	; $080f
	ld b,$08		; $0811
---
	ldh a,(<hFF8E)	; $0813
	setrombank		; $0815
	ldh a,(<hFF8B)	; $081a
	rrca			; $081c
	ldh (<hFF8B),a	; $081d
	jr c,++

	ldi a,(hl)		; $0821
	ld (de),a		; $0822
	inc de			; $0823
	call dec16_ff8c		; $0824
	ret z			; $0827
	dec b			; $0828
	jr nz,---
	jr ----
++
	push bc			; $082d
	ldh a,(<hFF8F)	; $082e
	bit 7,a			; $0830
	jr nz,+

	ldi a,(hl)		; $0834
	ld c,a			; $0835
	ldi a,(hl)		; $0836
	ldh (<hFF8A),a	; $0837
	and $0f			; $0839
	ld b,a			; $083b
	ldh a,(<hFF8A)	; $083c
	swap a			; $083e
	and $0f			; $0840
	add $03			; $0842
	ldh (<hFF8A),a	; $0844
	jr ++
+
	ldi a,(hl)		; $0848
	ldh (<hFF8A),a	; $0849
	ldi a,(hl)		; $084b
	ld c,a			; $084c
	ldi a,(hl)		; $084d
	ld b,a			; $084e
++
	push hl			; $084f
	ld hl,hFF90		; $0850
	ldi a,(hl)		; $0853
	ld h,(hl)		; $0854
	ld l,a			; $0855
	add hl,bc		; $0856
	ldh a,(<hFF8A)	; $0857
	ld b,a			; $0859
	ldh a,(<hFF8F)	; $085a
	and $3f			; $085c
	setrombank		; $085e
-
	ldi a,(hl)		; $0863
	ld (de),a		; $0864
	inc de			; $0865
	call dec16_ff8c		; $0866
	jr z,+++
	dec b			; $086b
	jr nz,-

	pop hl			; $086e
	pop bc			; $086f
	dec b			; $0870
	jr nz,---
	jr ----
+++
	pop hl			; $0875
	pop bc			; $0876
	ret			; $0877

;;
; @addr{0878}
dec16_ff8c:
	push hl			; $0878
	ld hl,hFF8C		; $0879
	call decHlRef16WithCap		; $087c
	pop hl			; $087f
	ret			; $0880

;;
; @addr{0881}
enableIntroInputs:
	ldh a,(<hIntroInputsEnabled)	; $0881
	bit 7,a			; $0883
	ret nz			; $0885
	ld a,$01		; $0886
	ldh (<hIntroInputsEnabled),a	; $0888
	ret			; $088a

;;
; @addr{088b}
threadFunc_088b:
	push hl			; $088b
	ld l,a			; $088c
	ld h,>wThreadStateBuffer	; $088d
	set 7,(hl)		; $088f
	pop hl			; $0891
	ret			; $0892

;;
; @addr{0893}
threadFunc_0893:
	push hl			; $0893
	ld l,a			; $0894
	ld h,>wThreadStateBuffer	; $0895
	res 7,(hl)		; $0897
	pop hl			; $0899
	ret			; $089a

;;
; @param	a	Low byte of thread address
; @addr{089b}
threadStop:
	push hl			; $089b
	ld l,a			; $089c
	ld h,>wThreadStateBuffer	; $089d
	ld (hl),$00		; $089f
	pop hl			; $08a1
	ret			; $08a2

;;
; @param	a	Low byte of thread address
; @param[in]	bc	Address where thread should restart
; @addr{08a3}
threadRestart:
	push hl			; $08a3
	push de			; $08a4
	push bc			; $08a5
	ld e,a			; $08a6
	add $04			; $08a7
	ld c,a			; $08a9
	ld d,$00		; $08aa
	ld hl,_initialThreadStates-(<wThreadStateBuffer)	; $08ac
	add hl,de		; $08af
	ld d,>wThreadStateBuffer	; $08b0
	ld b,$08		; $08b2
-
	ldi a,(hl)		; $08b4
	ld (de),a		; $08b5
	inc e			; $08b6
	dec b			; $08b7
	jr nz,-

	ld l,c			; $08ba
	ld h,d			; $08bb
	pop bc			; $08bc
	ld (hl),c		; $08bd
	inc l			; $08be
	ld (hl),b		; $08bf
	pop de			; $08c0
	pop hl			; $08c1
	ret			; $08c2

;;
; @param[in]	bc	Address where thread should restart
; @addr{08c3}
restartThisThread:
	push bc			; $08c3
	ldh a,(<hActiveThread)	; $08c4
	ld e,a			; $08c6
	add $04			; $08c7
	ld c,a			; $08c9
	ld d,$00		; $08ca
	ld hl,_initialThreadStates-(<wThreadStateBuffer)	; $08cc
	add hl,de		; $08cf
	ld d,>wThreadStateBuffer		; $08d0
	ld b,$08		; $08d2
-
	ldi a,(hl)		; $08d4
	ld (de),a		; $08d5
	inc e			; $08d6
	dec b			; $08d7
	jr nz,-

	ld l,c			; $08da
	ld h,d			; $08db
	pop bc			; $08dc
	ld (hl),c		; $08dd
	inc l			; $08de
	ld (hl),b		; $08df
	jr _nextThread		; $08e0

;;
; @addr{08e2}
stubThreadStart:
	ldh a,(<hActiveThread)	; $08e2
	ld l,a			; $08e4
	ld h,>wThreadStateBuffer		; $08e5
	ld (hl),$00		; $08e7
	jr _nextThread		; $08e9

;;
; @addr{08eb}
resumeThreadNextFrameAndSaveBank:
	ld a,$01		; $08eb
	push bc			; $08ed
	ld b,a			; $08ee
	ldh a,(<hRomBank)	; $08ef
	ld c,a			; $08f1
	ld a,b			; $08f2
	call resumeThreadInAFrames		; $08f3
	ld a,c			; $08f6
	setrombank		; $08f7
	pop bc			; $08fc
	ret			; $08fd

;;
; @addr{08fe}
resumeThreadNextFrame:
	ld a,$01		; $08fe
;;
; @param	a	Frames before the active thread will be executed next
; @addr{0900}
resumeThreadInAFrames:
	push hl			; $0900
	push de			; $0901
	push bc			; $0902
	ld b,a			; $0903
	ldh a,(<hActiveThread)	; $0904
	ld l,a			; $0906
	ld h,>wThreadStateBuffer	; $0907

	; Value $01 says to resume in X frames
	ld a,$01		; $0909
	ldi (hl),a		; $090b

	; Number of frames to wait
	ld (hl),b		; $090c
	inc l			; $090d

	; Save stack
	ld (hFF92),sp		; $090e
	ldh a,(<hFF92)	; $0911
	ldi (hl),a		; $0913
	ldh a,(<hFF93)	; $0914
	ld (hl),a		; $0916
;;
; @addr{0917}
_nextThread:
	ld sp,wMainStackTop		; $0917
	ld h,>wThreadStateBuffer	; $091a
	ld a,$01		; $091c
	ld ($ff00+R_SVBK),a	; $091e
	jr _mainLoop_nextThread		; $0920

;;
; Called just after basic initialization
;
; @addr{0922}
startGame:
	; Initialize thread states
	ld sp,wMainStackTop		; $0922
	ld hl,_initialThreadStates
	ld de,wThreadStateBuffer		; $0928
	ld b,NUM_THREADS*8	; $092b
-
	ldi a,(hl)		; $092d
	ld (de),a		; $092e
	inc e			; $092f
	dec b			; $0930
	jr nz,-

;;
; @addr{0933}
_mainLoop:
	call pollInput		; $0933
	ldh a,(<hIntroInputsEnabled)	; $0936
	add a			; $0938
	jr z,+

	ld a,(wKeysPressed)		; $093b
	sub (BTN_A | BTN_B | BTN_START | BTN_SELECT)
	jp z,resetGame		; $0940
+
	ld a,$10		; $0943
	ldh (<hOamTail),a	; $0945
	ld h,>wThreadStateBuffer		; $0947
	ld a,<wThreadStateBuffer		; $0949
	ldh (<hActiveThread),a	; $094b

--
	ld l,a			; $094d
	ld a,(hl)		; $094e

	; (hl) == 1?
	dec a			; $094f
	jr z,_countdownToRunThread	; $0950

	; (hl) == 2?
	dec a			; $0952
	jr z,_initializeThread	; $0953

;;
; @addr{0955}
_mainLoop_nextThread:
	ldh a,(<hActiveThread)	; $0955
	add $08			; $0957
	ldh (<hActiveThread),a	; $0959
	cp <(wThreadStateBuffer+NUM_THREADS*8)
	jr nz,--

	; No threads remaining this frame

	callfrombank0 bank3f.refreshDirtyPalettes	; $095f
	xor a			; $0969
	ld ($ff00+R_SVBK),a	; $096a
	ld hl,$c49e		; $096c
	inc (hl)		; $096f
	ld hl,wGfxRegs1		; $0970
	ld de,wGfxRegsFinal		; $0973
	ld b,GfxRegsStruct.size
-
	ldi a,(hl)		; $0978
	ld (de),a		; $0979
	inc e			; $097a
	dec b			; $097b
	jr nz,-

	; Wait for vblank
	ld hl,wVBlankChecker		; $097e
	ld (hl),$ff		; $0981
-
	halt			; $0983
	nop			; $0984
	bit 7,(hl)		; $0985
	jr nz,-
	jr _mainLoop

;;
; @addr{098b}
_countdownToRunThread:
	inc l			; $098b
	dec (hl)		; $098c
	jr nz,_mainLoop_nextThread	; $098d

	dec l			; $098f
	ld a,$03		; $0990
	ldi (hl),a		; $0992
	inc l			; $0993
	ldi a,(hl)		; $0994
	ld h,(hl)		; $0995
	ld l,a			; $0996
	ld sp,hl		; $0997
	pop bc			; $0998
	pop de			; $0999
	pop hl			; $099a
	ret			; $099b

;;
; @addr{099c}
_initializeThread:
	ld a,$03		; $099c
	ldi (hl),a		; $099e
	inc l			; $099f
	; Put stack value in de
	ldi a,(hl)		; $09a0
	ld e,a			; $09a1
	ldi a,(hl)		; $09a2
	ld d,a			; $09a3
	; Put function address in bc
	ldi a,(hl)		; $09a4
	ld b,(hl)		; $09a5
	ld c,a			; $09a6
	; hl <- de
	ld l,e			; $09a7
	ld h,d			; $09a8
	; Jump to bc with new stack
	ld sp,hl		; $09a9
	push bc			; $09aa
	ret			; $09ab

_initialThreadStates:
	m_ThreadState $02 $00 wThread0StackTop introThreadStart
	m_ThreadState $02 $00 wThread1StackTop stubThreadStart
	m_ThreadState $02 $00 wThread2StackTop stubThreadStart
	m_ThreadState $02 $00 wThread3StackTop paletteFadeThreadStart


; Upper bytes of addresses of flags for each group
; @addr{09cc}
flagLocationGroupTable:
	.db >wPresentRoomFlags >wPastRoomFlags
	.db >wGroup2Flags >wPastRoomFlags
	.db >wGroup4Flags >wGroup5Flags
	.db >wGroup4Flags >wGroup5Flags

;;
; @param	hActiveFileSlot	File index
; @addr{09d4}
initializeFile:
	ld c,$00		; $09d4
	jr ++			; $09d6

;;
; @param	hActiveFileSlot	File index
; @addr{09d8}
saveFile:
	ld c,$01		; $09d8
	jr ++			; $09da

;;
; @param	hActiveFileSlot	File index
; @addr{09dc}
loadFile:
	ld c,$02		; $09dc
	jr ++			; $09de

;;
; @param	hActiveFileSlot	File index
; @addr{09e0}
eraseFile:
	ld c,$03		; $09e0

++
	ldh a,(<hRomBank)	; $09e2
	push af			; $09e4
	callfrombank0 fileManagement.fileManagementFunction		; $09e5
	ld c,a			; $09ef
	pop af			; $09f0
	setrombank		; $09f1
	ld a,c			; $09f6
	ret			; $09f7

;;
; @addr{09f8}
vblankInterrupt:
	ldh a,(<hNextLcdInterruptBehaviour)	; $09f8
	ldh (<hLcdInterruptBehaviour),a	; $09fa
	xor a			; $09fc
	ldh (<hLcdInterruptCounter),a	; $09fd
	ld hl,hFFB7		; $09ff
	set 7,(hl)		; $0a02

	; Copy wram variables to real equivalents
	ld hl,wGfxRegsFinal		; $0a04
	ldi a,(hl)		; $0a07
	ld ($ff00+R_LCDC),a	; $0a08
	ldi a,(hl)		; $0a0a
	ld ($ff00+R_SCY),a	; $0a0b
	ldi a,(hl)		; $0a0d
	ld ($ff00+R_SCX),a	; $0a0e
	ldi a,(hl)		; $0a10
	ld ($ff00+R_WY),a	; $0a11
	ldi a,(hl)		; $0a13
	ld ($ff00+R_WX),a	; $0a14
	ldi a,(hl)		; $0a16
	ld ($ff00+R_LYC),a	; $0a17

	; increment wVBlankChecker
	inc (hl)		; $0a19
	jr nz,++

; The following code will only run when the main loop is explicitly waiting for vblank.

	ld de,wGfxRegs2		; $0a1c
	ld l,<wGfxRegs3
	ld a,(de)		; $0a21
	ldi (hl),a		; $0a22
	inc e			; $0a23
	ld a,(de)		; $0a24
	ldi (hl),a		; $0a25
	inc e			; $0a26
	ld a,(de)		; $0a27
	ldi (hl),a		; $0a28
	inc e			; $0a29
	ld a,(de)		; $0a2a
	ldi (hl),a		; $0a2b
	inc e			; $0a2c
	ld a,(de)		; $0a2d
	ldi (hl),a		; $0a2e
	inc e			; $0a2f
	ld a,(de)		; $0a30
	ldi (hl),a		; $0a31

	ld a,($ff00+R_VBK)	; $0a32
	ld b,a			; $0a34
	ld a,($ff00+R_SVBK)	; $0a35
	ld c,a			; $0a37
	push bc			; $0a38

	ldh a,(<hVBlankFunctionQueueTail)	; $0a39
	or a			; $0a3b
	call nz,runVBlankFunctions		; $0a3c

	call updateDirtyPalettes		; $0a3f

	di			; $0a42
	call hOamFunc		; $0a43

	pop bc			; $0a46
	ld a,c			; $0a47
	ld ($ff00+R_SVBK),a	; $0a48
	ld a,b			; $0a4a
	ld ($ff00+R_VBK),a	; $0a4b

	ld hl,wGfxRegs6.LCDC		; $0a4d
	ldi a,(hl)		; $0a50
	ld (wGfxRegs7.LCDC),a		; $0a51
	ldi a,(hl)		; $0a54
	ld (wGfxRegs7.SCY),a		; $0a55
	ldi a,(hl)		; $0a58
	ld (wGfxRegs7.SCX),a		; $0a59
++
	ld hl,hFFB7		; $0a5c
	res 7,(hl)		; $0a5f
	ldh a,(<hRomBank)	; $0a61
	bit 0,(hl)		; $0a63
	jr z,+
	ldh a,(<hSoundDataBaseBank2)	; $0a67
+
	ld ($2222),a		; $0a69
	pop hl			; $0a6c
	pop de			; $0a6d
	pop bc			; $0a6e
	pop af			; $0a6f
	reti			; $0a70

;;
; @addr{0a71}
runVBlankFunctions:
	ld hl,wVBlankFunctionQueue		; $0a71
--
	ldi a,(hl)		; $0a74
	push hl			; $0a75
	ld c,a			; $0a76
	ld b,$00		; $0a77
	ld hl,vblankFunctionsStart
	add hl,bc		; $0a7c
	jp hl			; $0a7d
;;
; @addr{0a7e}
vblankFunctionRet:
	ldh a,(<hVBlankFunctionQueueTail)	; $0a7e
	cp l			; $0a80
	jr nz,--

	xor a			; $0a83
	ldh (<hVBlankFunctionQueueTail),a	; $0a84
	ret			; $0a86

; Unused?
vblankFunctionOffset0:
	.db vblankFunction0a8e - vblankFunctionsStart	; $0a87

vblankRunBank4FunctionOffset:
	.db vblankRunBank4Function - vblankFunctionsStart	; $0a88

vblankCopyTileFunctionOffset:
	.db vblankCopyTileFunction - vblankFunctionsStart	; $0a89

; Unused?
vblankFunctionOffset3:
	.db vblankFunction0ad9 - vblankFunctionsStart	; $0a8a

vblankFunctionOffset4:
	.db vblankFunction0ad9 - vblankFunctionsStart 	; $0a8b

; Unused?
vblankFunctionOffset5:
	.db vblankFunction0aa8 - vblankFunctionsStart	; $0a8c

vblankDmaFunctionOffset:
	.db vblankDmaFunction - vblankFunctionsStart	; $0a8d


vblankFunctionsStart:

;;
; @addr{0a8e}
vblankFunction0a8e:
	pop hl			; $0a8e
	ldi a,(hl)		; $0a8f
	ld ($ff00+R_VBK),a	; $0a90
	ldi a,(hl)		; $0a92
	ld e,a			; $0a93
	ldi a,(hl)		; $0a94
	ld d,a			; $0a95
	ldi a,(hl)		; $0a96
	ld b,a			; $0a97
-
	ldi a,(hl)		; $0a98
	ld (de),a		; $0a99
	inc de			; $0a9a
	dec b			; $0a9b
	jr nz,-
	jr vblankFunctionRet		; $0a9e

;;
; @addr{0aa0}
vblankRunBank4Function:
	ld a,:vblankRunBank4Function_b04		; $0aa0
	ld ($2222),a		; $0aa2
	jp vblankRunBank4Function_b04		; $0aa5

;;
; @addr{0aa8}
vblankFunction0aa8:
	pop hl			; $0aa8
	ldi a,(hl)		; $0aa9
	ld c,a			; $0aaa
	ldi a,(hl)		; $0aab
	push hl			; $0aac
	ld l,c			; $0aad
	ld h,a			; $0aae
	ld bc,@return		; $0aaf
	push bc			; $0ab2
	jp hl			; $0ab3

@return:
	pop hl			; $0ab4
	jr vblankFunctionRet		; $0ab5

;;
; @addr{0ab7}
vblankCopyTileFunction:
	pop hl			; $0ab7
	ld de,vblankFunctionRet		; $0ab8
	push de			; $0abb

	xor a			; $0abc
	ld ($ff00+R_VBK),a	; $0abd
	ldi a,(hl)		; $0abf
	ld e,a			; $0ac0
	ldi a,(hl)		; $0ac1
	ld d,a			; $0ac2
	ld c,e			; $0ac3
	call @write4Bytes		; $0ac4

	ld e,c			; $0ac7
	ld a,$01		; $0ac8
	ld ($ff00+R_VBK),a	; $0aca

;;
; @param	de	Destination (vram)
; @param	hl	Source
; @addr{0acc}
@write4Bytes:
	; Write 2 bytes
	ldi a,(hl)		; $0acc
	ld (de),a		; $0acd
	inc e			; $0ace
	ldi a,(hl)		; $0acf
	ld (de),a		; $0ad0

	; Get a new value for 'e' (I guess calculating it would be too expensive during
	; vblank)
	ldi a,(hl)		; $0ad1
	ld e,a			; $0ad2

	; Write the next 2 bytes
	ldi a,(hl)		; $0ad3
	ld (de),a		; $0ad4
	inc e			; $0ad5
	ldi a,(hl)		; $0ad6
	ld (de),a		; $0ad7
	ret			; $0ad8

;;
; @addr{0ad9}
vblankFunction0ad9:
	pop hl			; $0ad9
	ldi a,(hl)		; $0ada
	ld ($ff00+R_VBK),a	; $0adb
	ldi a,(hl)		; $0add
	ld e,a			; $0ade
	ldi a,(hl)		; $0adf
	ld d,a			; $0ae0
	ldi a,(hl)		; $0ae1
	ld b,a			; $0ae2
-
	ldi a,(hl)		; $0ae3
	ld (de),a		; $0ae4
	inc de			; $0ae5
	dec b			; $0ae6
	jr nz,-
	jr vblankFunctionRet		; $0ae9

;;
; @addr{0aeb}
vblankDmaFunction:
	pop hl			; $0aeb
	ldi a,(hl)		; $0aec
	ld ($ff00+R_SVBK),a	; $0aed
	ld ($2222),a		; $0aef
	ldi a,(hl)		; $0af2
	ld ($ff00+R_HDMA1),a	; $0af3
	ldi a,(hl)		; $0af5
	ld ($ff00+R_HDMA2),a	; $0af6
	ldi a,(hl)		; $0af8
	ld ($ff00+R_VBK),a	; $0af9
	ldi a,(hl)		; $0afb
	ld ($ff00+R_HDMA3),a	; $0afc
	ldi a,(hl)		; $0afe
	ld ($ff00+R_HDMA4),a	; $0aff
	ldi a,(hl)		; $0b01
	ld ($ff00+R_HDMA5),a	; $0b02
	jp vblankFunctionRet		; $0b04



;;
; Update all palettes marked as dirty.
;
; @addr{0b07}
updateDirtyPalettes:
	ld a,$02		; $0b07
	ld ($ff00+R_SVBK),a	; $0b09

	ldh a,(<hDirtyBgPalettes)	; $0b0b
	ld d,a			; $0b0d
	xor a			; $0b0e
	ldh (<hDirtyBgPalettes),a	; $0b0f
	ld c, R_BGPI
	ld hl, w2BgPalettesBuffer
	call @writePaletteRegs		; $0b16

	ldh a,(<hDirtySprPalettes)	; $0b19
	ld d,a			; $0b1b
	xor a			; $0b1c
	ldh (<hDirtySprPalettes),a	; $0b1d
	ld c, R_OBPI
	ld l, w2SprPalettesBuffer&$ff
;;
; @addr{0b23}
@writePaletteRegs:
	srl d			; $0b23
	jr nc,++

	ld a,l			; $0b27
	or $80			; $0b28
	ld ($ff00+c),a		; $0b2a
	inc c			; $0b2b
	ldi a,(hl)		; $0b2c
	ld ($ff00+c),a		; $0b2d
	ldi a,(hl)		; $0b2e
	ld ($ff00+c),a		; $0b2f
	ldi a,(hl)		; $0b30
	ld ($ff00+c),a		; $0b31
	ldi a,(hl)		; $0b32
	ld ($ff00+c),a		; $0b33
	ldi a,(hl)		; $0b34
	ld ($ff00+c),a		; $0b35
	ldi a,(hl)		; $0b36
	ld ($ff00+c),a		; $0b37
	ldi a,(hl)		; $0b38
	ld ($ff00+c),a		; $0b39
	ldi a,(hl)		; $0b3a
	ld ($ff00+c),a		; $0b3b
	dec c			; $0b3c
	jr @writePaletteRegs	; $0b3d
++
	ret z			; $0b3f
	ld a,l			; $0b40
	add $08			; $0b41
	ld l,a			; $0b43
	jr @writePaletteRegs	; $0b44

;;
; @addr{0b46}
lcdInterrupt:
	ldh a,(<hLcdInterruptBehaviour)	; $0b46
	cp $02			; $0b48
	jr nc,@behaviour2OrHigher

	or a			; $0b4c
	ld a,($ff00+R_LY)	; $0b4d
	ld l,a			; $0b4f
	ld h,>wBigBuffer		; $0b50
	ldi a,(hl)		; $0b52
	jr nz,+

	ld ($ff00+R_SCX),a	; $0b55
	jr ++
+
	ld ($ff00+R_SCY),a	; $0b59
++
	ld a,l			; $0b5b
	cp $90			; $0b5c
	jr nc,+
	ld ($ff00+R_LYC),a	; $0b60
+
	pop hl			; $0b62
	pop af			; $0b63
	reti			; $0b64

@behaviour2OrHigher:
	push bc			; $0b65
	ld c,$03		; $0b66

	; The first time the interrupt triggers, it's always to switch between displaying
	; the status bar at the top of the screen and the actual game.
	ldh a,(<hLcdInterruptCounter)	; $0b68
	or a			; $0b6a
	jr nz,@notStatusBar
	ld hl,wGfxRegs3		; $0b6d
-
	ld a,($ff00+R_STAT)	; $0b70
	and c			; $0b72
	jr nz,-

	ldi a,(hl)		; $0b75
	ld ($ff00+R_LCDC),a	; $0b76
	ldi a,(hl)		; $0b78
	ld ($ff00+R_SCY),a	; $0b79
	ldi a,(hl)		; $0b7b
	ld ($ff00+R_SCX),a	; $0b7c
	ldi a,(hl)		; $0b7e
	ld ($ff00+R_WY),a	; $0b7f
	ldi a,(hl)		; $0b81
	ld ($ff00+R_WX),a	; $0b82
	ldi a,(hl)		; $0b84
	ld ($ff00+R_LYC),a	; $0b85
	ldh a,(<hLcdInterruptBehaviour)	; $0b87
	cp $02			; $0b89
	jr nz,+

	xor a			; $0b8d
	ldh (<hLcdInterruptBehaviour),a	; $0b8e
+
	ld a,$01		; $0b90
	ldh (<hLcdInterruptCounter),a	; $0b92
	jr _lcdInterruptEnd		; $0b94

@notStatusBar:
	ldh a,(<hLcdInterruptBehaviour)	; $0b96
	cp $07			; $0b98
	jr nc,lcdInterrupt_clearLYC	; $0b9a
	rst_jumpTable			; $0b9c
	.dw lcdInterrupt_clearLYC
	.dw lcdInterrupt_clearLYC
	.dw lcdInterrupt_clearLYC
	.dw lcdInterrupt_setLcdcToA7
	.dw lcdInterrupt_clearWXY
	.dw lcdInterrupt_ringMenu
	.dw lcdInterrupt_0bea

;;
; @addr{0bab}
lcdInterrupt_setLcdcToA7:
	ld a,($ff00+R_STAT)	; $0bab
	and c			; $0bad
	jr nz,lcdInterrupt_setLcdcToA7
	ld a,$a7		; $0bb0
	ld ($ff00+R_LCDC),a	; $0bb2
	jr lcdInterrupt_clearLYC		; $0bb4

;;
; Ring menu: LCD interrupt triggers up to two times:
;   * Once on line $47 (list menu) or $57 (appraisal menu), where the textbox starts.
;   * If on the list menu, once more on line $87, where the textbox ends.
;
; @addr{0bb6}
lcdInterrupt_ringMenu:
	ld a,($ff00+R_STAT)	; $0bb6
	and c			; $0bb8
	jr nz,lcdInterrupt_ringMenu		; $0bb9

	ld ($ff00+R_SCX),a ; SCX = 0
	ld a,$87		; $0bbd
	ld ($ff00+R_LCDC),a	; $0bbf

	ldh a,(<hLcdInterruptCounter)	; $0bc1
	dec a			; $0bc3
	jr nz,@afterTextbox

	ld a,(wRingMenu_mode)		; $0bc6
	or a			; $0bc9
	jr z,+
	ld a,$87 ; Trigger LCD interrupt again later on line $87
	ld ($ff00+R_LYC),a	; $0bce
+
	ld a,$02		; $0bd0
	ldh (<hLcdInterruptCounter),a	; $0bd2
	jr _lcdInterruptEnd		; $0bd4

@afterTextbox:
	ld a,$80		; $0bd6
	ld ($ff00+R_SCY),a	; $0bd8
	jr lcdInterrupt_clearWXY		; $0bda

;;
; @addr{0bdc}
lcdInterrupt_clearWXY:
	ld a,$c7		; $0bdc
	ld ($ff00+R_WY),a	; $0bde
	ld ($ff00+R_WX),a	; $0be0

;;
; @addr{0be2}
lcdInterrupt_clearLYC:
	ld a,$c7		; $0be2
	ld ($ff00+R_LYC),a	; $0be4
_lcdInterruptEnd:
	pop bc			; $0be6
	pop hl			; $0be7
	pop af			; $0be8
	reti			; $0be9

;;
; @addr{0bea}
lcdInterrupt_0bea:
	ld a,($ff00+R_STAT)	; $0bea
	and c			; $0bec
	jr nz,lcdInterrupt_0bea	; $0bed
	ld hl,wGfxRegs7.LCDC		; $0bef
	ldi a,(hl)		; $0bf2
	ld ($ff00+R_LCDC),a	; $0bf3
	ldi a,(hl)		; $0bf5
	ld ($ff00+R_SCY),a	; $0bf6
	ldi a,(hl)		; $0bf8
	ld ($ff00+R_SCX),a	; $0bf9
	jr lcdInterrupt_clearLYC		; $0bfb

; Table of functions in bank $04?
; @addr{0bfd}
data_0bfd:
	.dw b4VBlankFunction0
	.dw b4VBlankFunction1
	.dw b4VBlankFunction2
	.dw b4VBlankFunction3
	.dw b4VBlankFunction4
	.dw b4VBlankFunction5
	.dw b4VBlankFunction6
	.dw b4VBlankFunction7
	.dw b4VBlankFunction8
	.dw b4VBlankFunction9
	.dw b4VBlankFunction10
	.dw b4VBlankFunction11
	.dw b4VBlankFunction12
	.dw b4VBlankFunction13
	.dw b4VBlankFunction14
	.dw b4VBlankFunction15
	.dw b4VBlankFunction16
	.dw b4VBlankFunction17
	.dw b4VBlankFunction18
	.dw b4VBlankFunction19
	.dw b4VBlankFunction20
	.dw b4VBlankFunction21
	.dw b4VBlankFunction22
	.dw b4VBlankFunction23
	.dw b4VBlankFunction24
	.dw b4VBlankFunction25
	.dw b4VBlankFunction26
	.dw b4VBlankFunction27
	.dw b4VBlankFunction28
	.dw b4VBlankFunction29
	.dw b4VBlankFunction30
	.dw b4VBlankFunction31

;;
; @addr{0c3d}
serialInterrupt:
	ldh a,(<hSerialInterruptBehaviour)	; $0c3d
	or a			; $0c3f
	jr z,+

	ld a,($ff00+R_SB)	; $0c42
	ldh (<hSerialByte),a	; $0c44
	xor a			; $0c46
	ld ($ff00+R_SB),a	; $0c47
	inc a			; $0c49
	ldh (<hSerialRead),a	; $0c4a
	pop af			; $0c4c
	reti			; $0c4d
+
	ld a,($ff00+R_SB)	; $0c4e
	cp $e1			; $0c50
	jr z,+

	cp $e0			; $0c54
	jr nz,++
+
	ldh (<hSerialInterruptBehaviour),a	; $0c58
	xor a			; $0c5a
	ld ($ff00+R_SB),a	; $0c5b
	pop af			; $0c5d
	reti			; $0c5e
++
	ld a,$e1		; $0c5f
	ld ($ff00+R_SB),a	; $0c61
	ld a,$80		; $0c63
	call writeToSC		; $0c65
	pop af			; $0c68
	reti			; $0c69

;;
; Writes A to SC. Also writes $01 beforehand which might just be to reset any active
; transfers?
;
; @addr{0c6a}
writeToSC:
	push af			; $0c6a
	and $01			; $0c6b
	ld ($ff00+R_SC),a	; $0c6d
	pop af			; $0c6f
	ld ($ff00+R_SC),a	; $0c70
	ret			; $0c72

;;
; @addr{0c73}
serialFunc_0c73:
	xor a			; $0c73
	ldh (<hFFBD),a	; $0c74
	ld a,$e0		; $0c76
	ld ($ff00+R_SB),a	; $0c78
	ld a,$81		; $0c7a
	jr writeToSC		; $0c7c

;;
; @addr{0c7e}
serialFunc_0c7e:
	xor a			; $0c7e
	ldh (<hSerialInterruptBehaviour),a	; $0c7f
	ld ($ff00+R_SB),a	; $0c81
	jr writeToSC		; $0c83

;;
; @addr{0c85}
serialFunc_0c85:
	jpab serialCode.func_44ac		; $0c85

;;
; @addr{0c8d}
serialFunc_0c8d:
	push de			; $0c8d
	callab serialCode.func_4000		; $0c8e
	pop de			; $0c96
	ret			; $0c97

;;
; @param	a	Sound to play
; @addr{0c98}
playSound:
	or a			; $0c98
	ret z			; $0c99

	ld h,a			; $0c9a
	ldh a,(<hFFB7)	; $0c9b
	bit 3,a			; $0c9d
	ret nz			; $0c9f

	ldh a,(<hMusicQueueTail)	; $0ca0
	ld l,a			; $0ca2
	ld a,h			; $0ca3
	ld h,>wMusicQueue		; $0ca4
	ldi (hl),a		; $0ca6
	ld a,l			; $0ca7
	and $af			; $0ca8
	ldh (<hMusicQueueTail),a	; $0caa
	ret			; $0cac

;;
; @param	a	Volume (0-3)
; @addr{0cad}
setMusicVolume:
	or $80			; $0cad
	ldh (<hMusicVolume),a	; $0caf
	ret			; $0cb1

;;
; @addr{0cb2}
restartSound:
	ld bc,b39_stopSound		; $0cb2
	jr _startSound

;;
; @addr{0cb7}
initSound:
	ld bc,b39_initSound		; $0cb7

;;
; @param bc Function to call for initialization
; @addr{0cba}
_startSound:
	push de			; $0cba
	ldh a,(<hRomBank)	; $0cbb
	push af			; $0cbd
	call disableTimer		; $0cbe
	ld a,:b39_initSound		; $0cc1
	ldh (<hSoundDataBaseBank),a	; $0cc3
	ldh (<hSoundDataBaseBank2),a	; $0cc5
	setrombank		; $0cc7
	call jpBc		; $0ccc
	call enableTimer		; $0ccf
	pop af			; $0cd2
	setrombank		; $0cd3
	pop de			; $0cd8
	ret			; $0cd9

;;
; @addr{0cda}
jpBc:
	ld l,c			; $0cda
	ld h,b			; $0cdb
	jp hl			; $0cdc

;;
; @addr{0cdd}
disableTimer:
	ld hl,hFFB7		; $0cdd
	set 0,(hl)		; $0ce0
	xor a			; $0ce2
	ld ($ff00+R_TAC),a	; $0ce3
	ret			; $0ce5

;;
; @addr{0ce6}
enableTimer:
	xor a			; $0ce6
	ld ($ff00+R_TAC),a	; $0ce7
	ld a,<wMusicQueue		; $0ce9
	ldh (<hMusicQueueTail),a	; $0ceb
	ldh (<hMusicQueueHead),a	; $0ced
	ld a,($ff00+R_KEY1)	; $0cef
	rlca			; $0cf1
	ld a,$77		; $0cf2
	jr c,+
	ld a,$bb		; $0cf6
+
	ld hl,TIMA		; $0cf8
	ldi (hl),a		; $0cfb
	ldi (hl),a		; $0cfc
	xor a			; $0cfd
	ld (hl),a		; $0cfe
	set 2,(hl)		; $0cff
	ld hl,hFFB7		; $0d01
	res 0,(hl)		; $0d04
	ret			; $0d06

;;
; @addr{0d07}
timerInterrupt:
	ld hl,hFFB7		; $0d07
	bit 7,(hl)		; $0d0a
	jr nz,@interruptEnd	; $0d0c
	bit 0,(hl)		; $0d0e
	jr nz,@interruptEnd	; $0d10

	set 0,(hl)		; $0d12

	; Increment hFFB8
	inc l			; $0d14
	dec (hl)		; $0d15
	jr nz,+

	ld (hl),$07		; $0d18
	ld a,($ff00+R_TMA)	; $0d1a
	dec a			; $0d1c
	ld ($ff00+R_TIMA),a	; $0d1d
+
	ld a,:b39_updateMusicVolume		; $0d1f
	ld ($2222),a		; $0d21
	ldh a,(<hMusicVolume)	; $0d24
	bit 7,a			; $0d26
	jr z,+

	and $03			; $0d2a
	ldh (<hMusicVolume),a	; $0d2c
	call b39_updateMusicVolume		; $0d2e
+
	ldh a,(<hMusicQueueTail)	; $0d31
	ld b,a			; $0d33
	ldh a,(<hMusicQueueHead)	; $0d34
	cp b			; $0d36
	jr z,++

	ld h,>wMusicQueue		; $0d39
-
	ld l,a			; $0d3b
	ldi a,(hl)		; $0d3c
	push bc			; $0d3d
	push hl			; $0d3e
	call b39_playSound		; $0d3f
	pop hl			; $0d42
	pop bc			; $0d43
	ld a,l			; $0d44
	and $af			; $0d45
	cp b			; $0d47
	jr nz,-

	ldh (<hMusicQueueHead),a	; $0d4a
++
	call b39_updateSound		; $0d4c
	ld hl,hFFB7		; $0d4f
	res 0,(hl)		; $0d52
	ldh a,(<hRomBank)	; $0d54
	ld ($2222),a		; $0d56

@interruptEnd:
	pop hl			; $0d59
	pop de			; $0d5a
	pop bc			; $0d5b
	pop af			; $0d5c
	reti			; $0d5d

;;
; Writes data at hl to oam. First byte of data is how many objects. Each object
; has 4 bytes (y, x, tile, attributes).
;
; ff8b: internal variable (number of objects remaining)
;
; @param	hl	OAM data
; @addr{0d5e}
addSpritesToOam:
	ld bc,$0000		; $0d5e

;;
; @param	bc	Sprite offset
; @param	hl	OAM data
; @addr{0d61}
addSpritesToOam_withOffset:
	ldh a,(<hOamTail)	; $0d61
	cp $a0			; $0d63
	ret nc			; $0d65
	ld e,a			; $0d66
	ld d,>wOam		; $0d67
	ldi a,(hl)		; $0d69
	or a			; $0d6a
	ret z			; $0d6b
@next:
	ldh (<hFF8B),a	; $0d6c
	ldi a,(hl)		; $0d6e
	add b			; $0d6f
	cp $a0			; $0d70
	jr nc,@skip3Bytes	; $0d72
	ld (de),a		; $0d74
	ldi a,(hl)		; $0d75
	add c			; $0d76
	cp $a8			; $0d77
	jr nc,@skip2Bytes	; $0d79
	inc e			; $0d7b
	ld (de),a		; $0d7c
	inc e			; $0d7d
	ldi a,(hl)		; $0d7e
	ld (de),a		; $0d7f
	inc e			; $0d80
	ldi a,(hl)		; $0d81
	ld (de),a		; $0d82
	inc e			; $0d83
	ld a,e			; $0d84
	cp $a0			; $0d85
	jr nc,@end		; $0d87
@decCounter:
	ldh a,(<hFF8B)	; $0d89
	dec a			; $0d8b
	jr nz,@next		; $0d8c
	ld a,e			; $0d8e
@end:
	ldh (<hOamTail),a	; $0d8f
	ret			; $0d91

@skip3Bytes:
	inc hl			; $0d92
@skip2Bytes:
	inc hl			; $0d93
	inc hl			; $0d94
	ld a,$e0		; $0d95
	ld (de),a		; $0d97
	jr @decCounter		; $0d98

;;
; @addr{0d9a}
drawAllSprites:
	ld hl,wc4b6		; $0d9a
	bit 0,(hl)		; $0d9d
	ret nz			; $0d9f

	ld (hl),$ff		; $0da0

;;
; @addr{0da2}
drawAllSpritesUnconditionally:
	ldh a,(<hRomBank)	; $0da2
	push af			; $0da4
	call queueDrawEverything		; $0da5

.ifdef ROM_AGES
	ld a,(wLinkRaisedFloorOffset)		; $0da8
	ld hl,w1Link.yh		; $0dab
	add (hl)		; $0dae
	ld (hl),a		; $0daf
.endif

	ld de,w1Link		; $0db0

	ld b,<w1Link.yh		; $0db3
	ld a,(wTextboxFlags)		; $0db5
	and TEXTBOXFLAG_ALTPALETTE1	; $0db8
	jr z,@loop			; $0dba

	; Draw link object
	call objectQueueDraw		; $0dbc
	jr ++			; $0dbf

	; Draw w1Link, w1Companion, and w1ParentItem2-w1ParentItem5.
@loop:
	call objectQueueDraw		; $0dc1
	inc d			; $0dc4
	ld a,d			; $0dc5
	cp $d6			; $0dc6
	jr c,@loop			; $0dc8
++
	; Update the puddle animation
	ld a,:terrainEffects.puddleAnimationFrames		; $0dca
	setrombank		; $0dcc

	; Every 16 frames, the animation changes
	ld a,(wFrameCounter)		; $0dd1
	add a			; $0dd4
	swap a			; $0dd5
	and $03			; $0dd7
	ld hl,terrainEffects.puddleAnimationFrames		; $0dd9
	rst_addDoubleIndex			; $0ddc

	ldi a,(hl)		; $0ddd
	ld (wPuddleAnimationPointer),a		; $0dde
	ldi a,(hl)		; $0de1
	ld (wPuddleAnimationPointer+1),a		; $0de2

	; Write a "jp" opcode to wRamFunction
	ld hl,wRamFunction		; $0de5
	; Jump
	ld a,$c3		; $0de8
	ldi (hl),a		; $0dea
	; Jump to _getObjectPositionOnScreen
	ld a,<_getObjectPositionOnScreen
	ldi (hl),a		; $0ded
	ld (hl),>_getObjectPositionOnScreen

	ld a,(wScrollMode)		; $0df0
	cp $08			; $0df3
	jr nz,++

	; Or if a screen transition is occuring, jump to _getObjectPositionOnScreen_duringScreenTransition
	ld a,>_getObjectPositionOnScreen_duringScreenTransition
	ldd (hl),a		; $0df9
	ld (hl),<_getObjectPositionOnScreen_duringScreenTransition

	; Load some variables (hFF90-hFF93) for the
	; _getObjectPositionOnScreen_duringScreenTransition function
	xor a			; $0dfc
	ld b,a			; $0dfd
	inc a			; $0dfe
	ldh (<hFF8A),a	; $0dff
	ld a,(wRoomIsLarge)		; $0e01
	or a			; $0e04
	jr z,+
	ld a,$04		; $0e07
+
	ld c,a			; $0e09
	ld a,(wScreenTransitionDirection)		; $0e0a
	add c			; $0e0d
	add a			; $0e0e
	add a			; $0e0f
	ld c,a			; $0e10
	ld hl,data_1058		; $0e11
	add hl,bc		; $0e14
	ldi a,(hl)		; $0e15
	ldh (<hFF90),a	; $0e16
	ldi a,(hl)		; $0e18
	ldh (<hFF91),a	; $0e19
	ldi a,(hl)		; $0e1b
	ldh (<hFF92),a	; $0e1c
	ldi a,(hl)		; $0e1e
	ldh (<hFF93),a	; $0e1f
++

	; Draw all queued objects
	ld hl,wObjectsToDraw	; $0e21
-
	ld a,(hl)		; $0e24
	or a			; $0e25
	call nz,@drawObject		; $0e26
	inc l			; $0e29
	inc l			; $0e2a
	bit 7,l			; $0e2b
	jr z,-

	; Draw pending terrain effects (shadows)
	ld hl,wTerrainEffectsBuffer		; $0e2f
	ldh a,(<hTerrainEffectsBufferUsedSize)	; $0e32
	rrca			; $0e34
	srl a			; $0e35
	ld b,a			; $0e37
	jr z,++
-
	push bc			; $0e3a
	ldi a,(hl)		; $0e3b
	ldh (<hFF8C),a	; $0e3c
	ldi a,(hl)		; $0e3e
	ldh (<hFF8D),a	; $0e3f
	ldi a,(hl)		; $0e41
	push hl			; $0e42
	ld h,(hl)		; $0e43
	ld l,a			; $0e44
	call func_0eda		; $0e45
	pop hl			; $0e48
	inc l			; $0e49
	pop bc			; $0e4a
	dec b			; $0e4b
	jr nz,-
++

	; Clear all unused OAM entries
	ldh a,(<hOamTail)	; $0e4e
	cp $a0			; $0e50
	jr nc,++

	ld h,>wOam		; $0e54
	ld b,$e0		; $0e56
-
	ld l,a			; $0e58
	ld (hl),b		; $0e59
	add $04			; $0e5a
	cp $a0			; $0e5c
	jr c,-
++

.ifdef ROM_AGES
	; Undo link's Y offset for drawing
	ld a,(wLinkRaisedFloorOffset)		; $0e60
	cpl			; $0e63
	inc a			; $0e64
	ld hl,w1Link.yh		; $0e65
	add (hl)		; $0e68
	ld (hl),a		; $0e69
.endif

	pop af			; $0e6a
	setrombank		; $0e6b
	ret			; $0e70

;;
; @param hl Address in wObjectsToDraw.
; @addr{0e71}
@drawObject:
	push hl			; $0e71
	inc l			; $0e72
	ld h,(hl)		; $0e73
	ld l,a			; $0e74
	; hl now points to the object's y-position.

	; This is equivalent to either
	; "call _getObjectPositionOnScreen" or
	; "call _getObjectPositionOnScreen_duringScreenTransition".
	call wRamFunction		; $0e75
	jr nc,@return		; $0e78

	; hl points to Object.oamFlags
	ldi a,(hl)		; $0e7a
	ldh (<hFF8F),a	; $0e7b

	; Object.oamTileIndexBase
	ldi a,(hl)		; $0e7d
	ldh (<hFF8E),a	; $0e7e

	; Object.oamDataAddress
	ldi a,(hl)		; $0e80
	ld h,(hl)		; $0e81
	ld l,a			; $0e82

	; Get address, bank of animation frame data
	ld a,h			; $0e83
	and $c0			; $0e84
	rlca			; $0e86
	rlca			; $0e87
	add BASE_OAM_DATA_BANK			; $0e88
	setrombank		; $0e8a
	set 6,h			; $0e8f
	res 7,h			; $0e91

	; Check how many sprites are to be drawn, load it into c
	ldi a,(hl)		; $0e93
	or a			; $0e94
	jr z,@return		; $0e95

	ld c,a			; $0e97

	; Get first available OAM index, or return if it's full
	ldh a,(<hOamTail)	; $0e98
	ld e,a			; $0e9a
	ld a,<wOamEnd		; $0e9b
	sub e			; $0e9d
	jr z,@return		; $0e9e

	; Set b to the number of available OAM slots, will return if this
	; reaches zero
	rrca			; $0ea0
	rrca			; $0ea1
	ld b,a			; $0ea2

	ld d,>wOam		; $0ea3
	; b = # available slots,
	; c = # sprites to be drawn,
	; de points to OAM,
	; hl points to animation frame data

@nextSprite:
	; Y position
	ldh a,(<hFF8C)	; $0ea5
	add (hl)		; $0ea7
	inc hl			; $0ea8
	cp $a0			; $0ea9
	jr nc,@incHlToNextSprite	; $0eab
	ld (de),a		; $0ead

	; X position
	ldh a,(<hFF8D)	; $0eae
	add (hl)		; $0eb0
	cp $a8			; $0eb1
	jr nc,@incHlToNextSprite	; $0eb3

	inc e			; $0eb5
	ld (de),a		; $0eb6

	; Tile index
	inc hl			; $0eb7
	inc e			; $0eb8
	ldh a,(<hFF8E)	; $0eb9
	add (hl)		; $0ebb
	ld (de),a		; $0ebc

	; Flags
	inc hl			; $0ebd
	inc e			; $0ebe
	ldh a,(<hFF8F)	; $0ebf
	xor (hl)		; $0ec1
	ld (de),a		; $0ec2

	inc hl			; $0ec3
	inc e			; $0ec4
	dec b			; $0ec5
	jr z,@doneDrawing			; $0ec6

	dec c			; $0ec8
	jr nz,@nextSprite	; $0ec9

@doneDrawing:
	ld a,e			; $0ecb
	ldh (<hOamTail),a	; $0ecc
@return:
	pop hl			; $0ece
	ld (hl),$00		; $0ecf
	ret			; $0ed1

@incHlToNextSprite:
	inc hl			; $0ed2
	inc hl			; $0ed3
	inc hl			; $0ed4
	dec c			; $0ed5
	jr nz,@nextSprite	; $0ed6
	jr @doneDrawing		; $0ed8

;;
; This function is similar to @drawObject above, except it simply draws raw OAM
; data which isn't associated with a particular object. It has a rather
; specific purpose, hence the hard-coded bank number.
; @param hl Address of oam data
; @param hFF8C Y-position to draw at
; @param hFF8D X-position to draw at
; @addr{0eda}
func_0eda:
	ld a,:terrainEffects.shadowAnimation		; $0eda
	setrombank		; $0edc

	; Get the end of used OAM, get how many sprites are to be drawn, check
	; if there's enough space
	ldh a,(<hOamTail)	; $0ee1
	ld e,a			; $0ee3
	ldi a,(hl)		; $0ee4
	ld c,a			; $0ee5
	add a			; $0ee6
	add a			; $0ee7
	add e			; $0ee8
	cp <wOamEnd+1			; $0ee9
	jr nc,@end		; $0eeb
	ld d,>wOam		; $0eed

@nextSprite:
	; Y-position
	ldh a,(<hFF8C)	; $0eef
	add (hl)		; $0ef1
	ld (de),a		; $0ef2
	inc hl			; $0ef3
	inc e			; $0ef4

	; X-position
	ldh a,(<hFF8D)	; $0ef5
	add (hl)		; $0ef7
	ld (de),a		; $0ef8
	inc hl			; $0ef9
	inc e			; $0efa

	; Tile index
	ldi a,(hl)		; $0efb
	ld (de),a		; $0efc
	inc e			; $0efd

	; Flags
	ldi a,(hl)		; $0efe
	ld (de),a		; $0eff
	inc e			; $0f00

	dec c			; $0f01
	jr nz,@nextSprite		; $0f02

	ld a,e			; $0f04
	ldh (<hOamTail),a	; $0f05
@end:
	ret			; $0f07

;;
; Draw an object's shadow, or grass / puddle animation as necessary.
; @param	b	Value of hCameraY?
; @param	e	Object's Z position
; @param	hl	Pointer to object
; @param	[hFF8C]	Y-position
; @param	[hFF8D]	X-position
; @addr{0f08}
_drawObjectTerrainEffects:
	ld a,(wTilesetFlags)		; $0f08
	and TILESETFLAG_SIDESCROLL
	ret nz			; $0f0d

	ld a,b			; $0f0e
	cp $97			; $0f0f
	ret nc			; $0f11

	bit 7,e			; $0f12
	jr z,@onGround

@inAir:
	; Return every other frame (creates flickering effect)
	ld a,(wFrameCounter)		; $0f16
	xor h			; $0f19
	rrca			; $0f1a
	ret nc			; $0f1b

	; Add an entry to wTerrainEffectsBuffer to queue a shadow for drawing
	push hl			; $0f1c
	ldh a,(<hTerrainEffectsBufferUsedSize)	; $0f1d
	add <wTerrainEffectsBuffer			; $0f1f
	ld l,a			; $0f21
	ld h,>wTerrainEffectsBuffer		; $0f22
	ldh a,(<hFF8C)		; $0f24
	ldi (hl),a		; $0f26
	ldh a,(<hFF8D)		; $0f27
	ldi (hl),a		; $0f29
	ld a,<terrainEffects.shadowAnimation		; $0f2a
	ldi (hl),a		; $0f2c
	ld a,>terrainEffects.shadowAnimation		; $0f2d
	ldi (hl),a		; $0f2f
	ld a,l			; $0f30
	sub <wTerrainEffectsBuffer			; $0f31
	ldh (<hTerrainEffectsBufferUsedSize),a	; $0f33
	pop hl			; $0f35
	ret			; $0f36

@onGround:
	ld a,(wScrollMode)		; $0f37
	cp $08			; $0f3a
	ret z			; $0f3c
	push hl			; $0f3d
	ld a,l			; $0f3e
	and $c0			; $0f3f
	add $0b			; $0f41
	ld l,a			; $0f43
	ldi a,(hl)		; $0f44
	ld b,a			; $0f45
	add $05			; $0f46
	and $f0			; $0f48
	ld c,a			; $0f4a
	inc l			; $0f4b
	ld l,(hl)		; $0f4c
	ld a,l			; $0f4d
	xor b			; $0f4e
	ld h,a			; $0f4f
	ld a,l			; $0f50
	and $f0			; $0f51
	swap a			; $0f53
	or c			; $0f55
	ld c,a			; $0f56
	ld b,>wRoomLayout		; $0f57
	ld a,(bc)		; $0f59

.ifdef ROM_AGES
	cp TILEINDEX_GRASS			; $0f5a
	jr z,@walkingInGrass
	cp TILEINDEX_PUDDLE			; $0f5e
	jr nz,@end		; $0f60

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
	inc e			; $0f62
	ld hl,wPuddleAnimationPointer		; $0f63
	ldi a,(hl)		; $0f66
	ld h,(hl)		; $0f67
	ld l,a			; $0f68
	jr @grassOrWater

@walkingInGrass:
	bit 2,h			; $0f6b
	ld a,(wGrassAnimationModifier)		; $0f6d
	jr z,+
	add $24			; $0f72
+
	ld c,a			; $0f74
	ld b,$00		; $0f75
	ld hl,terrainEffects.greenGrassAnimationFrame0		; $0f77
	add hl,bc		; $0f7a

@grassOrWater:
	push de			; $0f7b
	call func_0eda		; $0f7c
	pop de			; $0f7f

@end:
	pop hl			; $0f80
	ret			; $0f81

;;
; Get the position where an object should be drawn on-screen, accounting for
; screen scrolling. Clears carry flag if the object is not visible.
; @param[in] hl Pointer to an object's y-position.
; @param[out] hl Pointer to the object's Object.oamFlags variable.
; @param[out] hFF8C Y position to draw the object
; @param[out] hFF8D X position to draw the object
; @addr{0f82}
_getObjectPositionOnScreen:
	ldh a,(<hCameraX)	; $0f82
	ld c,a			; $0f84
	ldh a,(<hCameraY)	; $0f85
	ld b,a			; $0f87

	; Object.yh
	ldi a,(hl)		; $0f88
	sub b			; $0f89
	add $10			; $0f8a
	ldh (<hFF8C),a	; $0f8c
	ld d,a			; $0f8e

	; Object.xh
	inc l			; $0f8f
	ldi a,(hl)		; $0f90
	sub c			; $0f91
--
	ldh (<hFF8D),a	; $0f92

	; Object.zh
	inc l			; $0f94
	ld e,(hl)		; $0f95

	; Return if not visible (bit 7 of Object.visible unset)
	ld a,l			; $0f96
	and $c0			; $0f97
	add Object.visible		; $0f99
	ld l,a			; $0f9b
	ld a,(hl)		; $0f9c
	rlca			; $0f9d
	ret nc			; $0f9e

	; Draw shadows and stuff if bit 6 is set
	rlca			; $0f9f
	call c,_drawObjectTerrainEffects		; $0fa0

	; Account for Z position
	ld a,d			; $0fa3
	add e			; $0fa4
	ldh (<hFF8C),a	; $0fa5

	; Point hl to the Object.oamFlags variable
	ld a,l			; $0fa7
	and $c0			; $0fa8
	add Object.oamFlags		; $0faa
	ld l,a			; $0fac

	scf			; $0fad
	ret			; $0fae

;;
; @addr{0faf}
_label_00_152:
	ldh a,(<hCameraX)	; $0faf
	ld c,a			; $0fb1
	ldh a,(<hCameraY)	; $0fb2
	ld b,a			; $0fb4
	ldi a,(hl)		; $0fb5
	sub b			; $0fb6
	add $10			; $0fb7
	ldh (<hFF8C),a	; $0fb9
	ld d,a			; $0fbb
	inc l			; $0fbc
	ldi a,(hl)		; $0fbd
	sub c			; $0fbe
	jr --

;;
; This function takes the place of "_getObjectPositionOnScreen" during screen
; transitions.
; Clears carry flag if the object shouldn't be drawn for whatever reason.
; @param[in]	hl	Pointer to an object's y-position.
; @param[in]	hFF8A	Bitset on Object.enabled to check (always $01?)
; @param[in]	hFF90-hFF93
; @param[out]	hl	Pointer to the object's Object.oamFlags variable.
; @param[out]	hFF8C	Y position to draw the object
; @param[out]	hFF8D	X position to draw the object
; @addr{0fc1}
_getObjectPositionOnScreen_duringScreenTransition:
	ld d,h			; $0fc1
	ld a,l			; $0fc2
	and $c0			; $0fc3
	ld e,a			; $0fc5
	ld a,(de)		; $0fc6
	and $03			; $0fc7
	cp $03			; $0fc9
	jr z,_label_00_152	; $0fcb

	; Read Object.yh
	ld d,$00		; $0fcd
	ldi a,(hl)		; $0fcf
	add $10			; $0fd0
	ld c,a			; $0fd2
	ld a,d			; $0fd3
	adc a			; $0fd4
	ld b,a			; $0fd5

	; Read Object.xh
	inc l			; $0fd6
	ldi a,(hl)		; $0fd7
	ld e,a			; $0fd8
	push hl			; $0fd9

	; Check Object.enabled is set (hFF8A is always $01 here?)
	ld a,l			; $0fda
	and $c0			; $0fdb
	ld l,a			; $0fdd
	ldh a,(<hFF8A)	; $0fde
	and (hl)		; $0fe0
	jr z,+

	ld hl,hFF90		; $0fe3
	ldi a,(hl)		; $0fe6
	add c			; $0fe7
	ld c,a			; $0fe8
	ldi a,(hl)		; $0fe9
	adc b			; $0fea
	ld b,a			; $0feb
	ldi a,(hl)		; $0fec
	add e			; $0fed
	ld e,a			; $0fee
	ldi a,(hl)		; $0fef
	adc d			; $0ff0
	ld d,a			; $0ff1
+
	ld hl,hCameraY		; $0ff2
	ld a,c			; $0ff5
	sub (hl)		; $0ff6
	ld c,a			; $0ff7
	inc l			; $0ff8
	ld a,b			; $0ff9
	sbc (hl)		; $0ffa
	ld b,a			; $0ffb
	jr z,+

	inc a			; $0ffe
	jr nz,@dontDraw		; $0fff
	ld a,c			; $1001
	cp $e0			; $1002
	jr c,@dontDraw		; $1004
	jr ++
+
	ld a,c			; $1008
	cp $b0			; $1009
	jr nc,@dontDraw		; $100b
++
	; This write seems mostly pointless, although it could be necessary for
	; the call to _drawObjectTerrainEffects? (This gets overwritten later)
	ldh (<hFF8C),a	; $100d

	ld b,a			; $100f
	inc l			; $1010
	ld a,e			; $1011
	sub (hl)		; $1012
	ld e,a			; $1013
	inc l			; $1014
	ld a,d			; $1015
	sbc (hl)		; $1016
	ld d,a			; $1017
	jr z,+

	inc a			; $101a
	jr nz,@dontDraw		; $101b
	ld a,e			; $101d
	cp $e8			; $101e
	jr c,@dontDraw		; $1020
	jr ++
+
	ld a,e			; $1024
	cp $b8			; $1025
	jr nc,@dontDraw		; $1027
++
	ldh (<hFF8D),a	; $1029
	ld d,b			; $102b
	pop hl			; $102c
	inc l			; $102d
	ld e,(hl)		; $102e
	ld a,l			; $102f
	and $c0			; $1030
	add Object.visible			; $1032
	ld l,a			; $1034
	ld a,(hl)		; $1035
	rlca			; $1036
	ret nc			; $1037

	; Draw shadows and stuff if bit 6 is set
	rlca			; $1038
	call c,_drawObjectTerrainEffects		; $1039

	ld a,d			; $103c
	add e			; $103d
	ldh (<hFF8C),a	; $103e
	ld a,l			; $1040
	and $c0			; $1041
	add Object.oamFlags			; $1043
	ld l,a			; $1045
	scf			; $1046
	ret			; $1047

@dontDraw:
	pop hl			; $1048
	ld a,l			; $1049
	and $c0			; $104a
	ld l,a			; $104c
	bit 1,(hl)		; $104d
	jr z,+

	or Object.visible			; $1051
	ld l,a			; $1053
	ld (hl),$00		; $1054
+
	xor a			; $1056
	ret			; $1057

; Something to do with sprite positions during screen transitions. 4 bytes get written to
; hFF90-hFF93, and the values are used in
; _getObjectPositionOnScreen_duringScreenTransition.
; @addr{1058}
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
; @addr{1078}
queueDrawEverything:
	ld hl,hTerrainEffectsBufferUsedSize		; $1078
	xor a			; $107b
	ldi (hl),a		; $107c
	ldi (hl),a		; $107d
	ldi (hl),a		; $107e
	ldi (hl),a		; $107f
	ldi (hl),a		; $1080

	ld de,FIRST_ITEM_INDEX<<8		; $1081
	ld b,Item.yh		; $1084
	call @func		; $1086

	ld de,$d080		; $1089
	ld b,Enemy.yh		; $108c
	call @func		; $108e

	ld de,$d0c0		; $1091
	ld b,Part.yh		; $1094
	call @func		; $1096

	ld de,$d040		; $1099
	ld b,Interaction.yh		; $109c
@func:
	call objectQueueDraw		; $109e
	inc d			; $10a1
	ld a,d			; $10a2
	cp $e0			; $10a3
	jr c,@func
	ret			; $10a7

;;
; @param	b	Low byte of the address of the Object.yh variable
; @param	de	Start address of object to draw
; @addr{10a8}
objectQueueDraw:
	ld a,(de)		; $10a8
	or a			; $10a9
	ret z			; $10aa

	ld a,e			; $10ab
	or Object.visible		; $10ac
	ld l,a			; $10ae
	ld h,d			; $10af
	ld a,(hl)		; $10b0
	bit 7,a			; $10b1
	ret z			; $10b3

	and $03			; $10b4
	ld h,a			; $10b6
	add <hObjectPriority0Counter	; $10b7
	ld c,a			; $10b9
	ld a,($ff00+c)		; $10ba
	cp $10			; $10bb
	ret nc			; $10bd

	; Write the object's address to the appropriate position in
	; wObjectsToDraw, increment the ObjectPriorityCounter.
	inc a			; $10be
	ld ($ff00+c),a		; $10bf
	dec a			; $10c0
	swap h			; $10c1
	add h			; $10c3
	add a			; $10c4
	ld l,a			; $10c5
	ld h,>wObjectsToDraw	; $10c6
	ld a,b			; $10c8
	ldi (hl),a		; $10c9
	ld (hl),d		; $10ca
	ret			; $10cb

;;
; Gets the data for a chest in the current room.
; Defaults to position $00, contents $2800 if a chest is not found.
; @param	bc	Chest contents
; @param	e	Chest position
; @addr{10cc}
getChestData:
	ldh a,(<hRomBank)	; $10cc
	push af			; $10ce
	ld a,:chestData.chestDataGroupTable		; $10cf
	setrombank		; $10d1
	ld a,(wActiveGroup)		; $10d6
	ld hl,chestData.chestDataGroupTable	; $10d9
	rst_addDoubleIndex			; $10dc
	ldi a,(hl)		; $10dd
	ld h,(hl)		; $10de
	ld l,a			; $10df
	ld a,(wActiveRoom)		; $10e0
	ld b,a			; $10e3
-
	ldi a,(hl)		; $10e4
	ld e,a			; $10e5
	inc a			; $10e6
	jr z,@chestNotFound

	ldi a,(hl)		; $10e9
	cp b			; $10ea
	jr z,+

	inc hl			; $10ed
	inc hl			; $10ee
	jr -
+
	ld b,(hl)		; $10f1
	inc hl			; $10f2
	ld c,(hl)		; $10f3
	jr @end

@chestNotFound:
	ld bc,$2800		; $10f6

@end:
	pop af			; $10f9
	setrombank		; $10fa
	ret			; $10ff

;;
; Set Link's death respawn point based on the current room / position variables.
; @addr{1100}
setDeathRespawnPoint:
	ld hl,wDeathRespawnBuffer		; $1100
	ld a,(wActiveGroup)		; $1103
	ldi (hl),a		; $1106
	ld a,(wActiveRoom)		; $1107
	ldi (hl),a		; $110a
	ld a,(wRoomStateModifier)		; $110b
	ldi (hl),a		; $110e
	ld a,(w1Link.direction)		; $110f
	ldi (hl),a		; $1112
	ld a,(w1Link.yh)		; $1113
	ldi (hl),a		; $1116
	ld a,(w1Link.xh)		; $1117
	ldi (hl),a		; $111a
	ld a,(wRememberedCompanionId)		; $111b
	ldi (hl),a		; $111e
	ld a,(wRememberedCompanionGroup)		; $111f
	ldi (hl),a		; $1122
	ld a,(wRememberedCompanionRoom)		; $1123
	ldi (hl),a		; $1126
	ld a,(wLinkObjectIndex)		; $1127
	ldi (hl),a		; $112a
	inc l			; $112b
	ld a,(wRememberedCompanionY)		; $112c
	ldi (hl),a		; $112f
	ld a,(wRememberedCompanionX)		; $1130
	ldi (hl),a		; $1133
	ret			; $1134

;;
; @addr{1135}
func_1135:
	xor a			; $1135
	ld (wDeathRespawnBuffer.rememberedCompanionGroup),a		; $1136
	ret			; $1139

;;
; @addr{113a}
updateLinkLocalRespawnPosition:
	ld a,(wLinkObjectIndex)		; $113a
	ld h,a			; $113d
	ld l,<w1Link.direction
	ld a,(hl)		; $1140
	ld (wLinkLocalRespawnDir),a		; $1141
	ld l,<w1Link.yh
	ld a,(hl)		; $1146
	ld (wLinkLocalRespawnY),a		; $1147
	ld l,<w1Link.xh
	ld a,(hl)		; $114c
	ld (wLinkLocalRespawnX),a		; $114d
	ret			; $1150

;;
; Updates room flags when a tile is broken. For some tiles, this involves setting the room
; flags in more than one room, to mark a door as open on both sides.
;
; @param	a	Tile that was broken
; @addr{1151}
updateRoomFlagsForBrokenTile:
	push af			; $1151
	ld hl,_unknownTileCollisionTable	; $1152
	call lookupCollisionTable		; $1155
	call c,addToGashaMaturity		; $1158

	pop af			; $115b
	ld hl,_tileUpdateRoomFlagsOnBreakTable	; $115c
	call lookupCollisionTable		; $115f
	ret nc			; $1162

	bit 7,a			; $1163
	jp nz,setRoomFlagsForUnlockedKeyDoor		; $1165

	bit 6,a			; $1168
	jp nz,setRoomFlagsForUnlockedKeyDoor_overworldOnly		; $116a

	and $0f			; $116d
	ld bc,bitTable		; $116f
	add c			; $1172
	ld c,a			; $1173
	ld a,(wActiveGroup)		; $1174
	ld hl, flagLocationGroupTable
	rst_addAToHl			; $117a
	ld h,(hl)		; $117b
	ld a,(wActiveRoom)		; $117c
	ld l,a			; $117f
	ld a,(bc)		; $1180
	or (hl)			; $1181
	ld (hl),a		; $1182
	ret			; $1183


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
; @addr{11fc}
setRoomFlagsForUnlockedKeyDoor:
	and $0f			; $11fc
	ld de,_adjacentRoomsData		; $11fe
	call addAToDe		; $1201
	ld a,(wDungeonIndex)		; $1204
	cp $ff			; $1207
	jr z,@notInDungeon

	; Set the flag in the first room
	call getActiveRoomFromDungeonMapPosition		; $120b
	call @setRoomFlag		; $120e

	; Calculate the position of the second room, and set the corresponding flag there
	inc de			; $1211
	ld a,(wDungeonMapPosition)		; $1212
	ld l,a			; $1215
	ld a,(de)		; $1216
	add l			; $1217
	call getRoomInDungeon		; $1218
	inc de			; $121b

@setRoomFlag:
	ld c,a			; $121c
	ld a,(wDungeonFlagsAddressH)		; $121d
	ld b,a			; $1220
	ld a,(de)		; $1221
	ld l,a			; $1222
	ld a,(bc)		; $1223
	or l			; $1224
	ld (bc),a		; $1225
	ret			; $1226

@notInDungeon:
	call getThisRoomFlags		; $1227
	ld a,(de)		; $122a
	or (hl)			; $122b
	ld (hl),a		; $122c
	ret			; $122d

; Data format:
; b0: Room flag to set in first room
; b1: Value to add to wDungeonMapPosition to get the adjacent room
; b2: Room flag to set in second room
; b3: Unused
; @addr{122e}
_adjacentRoomsData:
	.db $01 $f8 $04 $00 ; Key door going up
	.db $02 $01 $08 $00 ; Key door going right
	.db $04 $08 $01 $00 ; Key door going down
	.db $08 $ff $02 $00 ; Key door going left

;;
; This function differs from the above one in that:
; * It only works for the PRESENT OVERWORLD.
; * The above, which CAN work for the overworlds, only sets the flag on the one screen
;   when used on the overworld; the adjacent room doesn't get updated.
; * This only works for rooms connected horizontally, since it uses the table above for
;   dungeons which assumes that vertical rooms are separated by $08 instead of $10.
;
; @param	a	Direction of door (times 4) (upper 4 bits are ignored)
; @addr{123e}
setRoomFlagsForUnlockedKeyDoor_overworldOnly:
	and $0f			; $123e
	ld hl,_adjacentRoomsData		; $1240
	rst_addAToHl			; $1243
	ld a,(wActiveRoom)		; $1244
	ld c,a			; $1247
	ld b,>wGroup2Flags		; $1248
	ld a,(bc)		; $124a
	or (hl)			; $124b
	ld (bc),a		; $124c
	inc hl			; $124d
	ldi a,(hl)		; $124e
	add c			; $124f
	ld c,a			; $1250
	ld a,(bc)		; $1251
	or (hl)			; $1252
	ld (bc),a		; $1253
	ret			; $1254

;;
; Allows link to walk through chests when he's already inside one.
; @addr{1255}
checkAndUpdateLinkOnChest:
	ld a,(wLinkOnChest)		; $1255
	or a			; $1258
	jr nz,++

	ld a,(wActiveTileIndex)		; $125b
	cp TILEINDEX_CHEST
	ret nz			; $1260

	ld a,(wActiveTilePos)		; $1261
	ld (wLinkOnChest),a		; $1264
	ld l,a			; $1267
	ld h,>wRoomCollisions	; $1268
	ld (hl),$00		; $126a
	ret			; $126c
++
	ld c,a			; $126d
	ld a,(wActiveTilePos)		; $126e
	cp c			; $1271
	ret z			; $1272

	ld b,>wRoomLayout
	ld a,(bc)		; $1275
	call retrieveTileCollisionValue		; $1276
	dec b			; $1279
	ld (bc),a		; $127a
	xor a			; $127b
	ld (wLinkOnChest),a		; $127c
	ret			; $127f

;;
; @param[out]	cflag	Set if Link interacted with a tile that should disable some of his
;			code? (Opened a chest, read a sign, opened an overworld keyhole)
; @addr{1280}
interactWithTileBeforeLink:
	ldh a,(<hRomBank)	; $1280
	push af			; $1282
	callfrombank0 bank6.interactWithTileBeforeLink		; $1283
	rl c			; $128d
	pop af			; $128f
	setrombank		; $1290
	srl c			; $1295
	ret			; $1297

;;
; Shows TX_510a ("It's too heavy to move") if it hasn't been shown already.
; @addr{1298}
showInfoTextForRoller:
	ldh a,(<hRomBank)	; $1298
	push af			; $129a
	ld a,:bank6.showInfoTextForTile		; $129b
	setrombank		; $129d
	ld a,$09		; $12a2
	call bank6.showInfoTextForTile		; $12a4
	pop af			; $12a7
	setrombank		; $12a8
	ret			; $12ad

;;
; @addr{12ae}
updateCamera:
	ld a,(wScrollMode)		; $12ae
	and $05			; $12b1
	ret z			; $12b3

	ldh a,(<hRomBank)	; $12b4
	push af			; $12b6
	callfrombank0 bank1.updateCameraPosition		; $12b7
	call          bank1.updateGfxRegs2Scroll		; $12c1
	call          bank1.updateScreenShake		; $12c4
	pop af			; $12c7
	setrombank		; $12c8
	ret			; $12cd

;;
; @addr{12ce}
resetCamera:
	ldh a,(<hRomBank)	; $12ce
	push af			; $12d0
	callfrombank0 bank1.calculateCameraPosition		; $12d1
	call          bank1.updateGfxRegs2Scroll		; $12db
	pop af			; $12de
	setrombank		; $12df
	ret			; $12e4

;;
; @addr{12e5}
setCameraFocusedObject:
	ldh a,(<hActiveObject)	; $12e5
	ld (wCameraFocusedObject),a		; $12e7
	ldh a,(<hActiveObjectType)	; $12ea
	ld (wCameraFocusedObjectType),a		; $12ec
	ret			; $12ef

;;
; @addr{12f0}
setCameraFocusedObjectToLink:
	ld a,(wLinkObjectIndex)		; $12f0
	ld (wCameraFocusedObject),a		; $12f3
	ld a,$00		; $12f6
	ld (wCameraFocusedObjectType),a		; $12f8
	ret			; $12fb

;;
; Reloads tile map for the room from w3VramTiles, w3VramAttributes.
; @addr{12fc}
reloadTileMap:
	ldh a,(<hRomBank)	; $12fc
	push af			; $12fe
	xor a			; $12ff
	ld (wScreenOffsetY),a		; $1300
	ld (wScreenOffsetX),a		; $1303
	ld a,UNCMP_GFXH_10		; $1306
	call loadUncompressedGfxHeader		; $1308
	callfrombank0 bank1.setScreenTransitionState02		; $130b
	call          bank1.updateGfxRegs2Scroll		; $1315
	pop af			; $1318
	setrombank		; $1319
	ret			; $131e

;;
; Called whenever entering an area with a fadein transition.
; @addr{131f}
func_131f:
	xor a			; $131f
	ld (wScreenOffsetY),a		; $1320
	ld (wScreenOffsetX),a		; $1323
	ldh a,(<hRomBank)	; $1326
	push af			; $1328
	callfrombank0 bank1.initializeRoomBoundaryAndLoadAnimations		; $1329
	call          bank1.setScreenTransitionState02		; $1333
	call          loadTilesetAndRoomLayout		; $1336

.ifdef ROM_AGES
	ld a,(wcddf)		; $1339
	or a			; $133c
	jr z,+

	callab func_04_6ed1		; $133f
	callab func_04_6f31		; $1347
	ld a,UNCMP_GFXH_30		; $134f
	call loadUncompressedGfxHeader		; $1351
	jr ++
.endif

+
	call loadRoomCollisions		; $1356
	call generateVramTilesWithRoomChanges		; $1359
	ld a,UNCMP_GFXH_10		; $135c
	call loadUncompressedGfxHeader		; $135e
++
	ld a,(wTilesetPalette)		; $1361
	ld (wLoadedTilesetPalette),a		; $1364
	ld a,(wTilesetUniqueGfx)		; $1367
	ld (wLoadedTilesetUniqueGfx),a		; $136a
	pop af			; $136d
	setrombank		; $136e
	ret			; $1373

;;
; @addr{1374}
loadTilesetAnimation:
	ld a,(wLoadedTilesetAnimation)		; $1374
	ld b,a			; $1377
	ld a,(wTilesetAnimation)		; $1378
	cp b			; $137b
	ret z			; $137c
	ld (wLoadedTilesetAnimation),a		; $137d
	jp loadAnimationData		; $1380

;;
; Seasons-only function
;
; @addr{1383}
func_1383:

.ifdef ROM_SEASONS
	push de			; $1324
	ld ($cc4c),a		; $1325
	ld a,b			; $1328
	ld (wScreenTransitionDirection),a		; $1329
	ld a,($ff00+$70)	; $132c
	ld c,a			; $132e
	ld a,($ff00+$97)	; $132f
	ld b,a			; $1331
	push bc			; $1332
	ld a,$08		; $1333
	ld ($cd00),a		; $1335
	ld a,$03		; $1338
	ld ($cd04),a		; $133a
	xor a			; $133d
	ld ($cd05),a		; $133e
	ld ($cd06),a		; $1341
	ld a,$01		; $1344
	setrombank
	call bank1.func_49c9		; $134b
	call bank1.setObjectsEnabledTo2		; $134e
	call loadScreenMusic		; $1351
	call loadTilesetData		; $1354
	ld a,($cc4c)		; $1357
	ld ($cc4b),a		; $135a
	call loadTilesetAndRoomLayout		; $135d
	call loadRoomCollisions		; $1360
	call generateVramTilesWithRoomChanges		; $1363
	pop bc			; $1366
	ld a,b			; $1367
	ld ($ff00+$97),a	; $1368
	ld ($2222),a		; $136a
	ld a,c			; $136d
	ld ($ff00+$70),a	; $136e
	pop de			; $1370
	ret			; $1371

.else ; ROM_AGES
	ret
.endif

;;
; Loads w2WaveScrollValues to make the screen sway in a sine wave.
;
; @param	a	Amplitude
; @addr{1384}
initWaveScrollValues:
	ldh (<hFF93),a	; $1384
	ld a,($ff00+R_SVBK)	; $1386
	ld c,a			; $1388
	ldh a,(<hRomBank)	; $1389
	ld b,a			; $138b
	push bc			; $138c
	ld a,:bank1.initWaveScrollValues_body		; $138d
	setrombank		; $138f
	ldh a,(<hFF93)	; $1394
	ld c,a			; $1396
	call bank1.initWaveScrollValues_body		; $1397
	pop bc			; $139a
	ld a,b			; $139b
	setrombank		; $139c
	ld a,c			; $13a1
	ld ($ff00+R_SVBK),a	; $13a2
	ret			; $13a4

;;
; Loads wBigBuffer with the values from w2WaveScrollValues (offset based on
; wFrameCounter). The LCD interrupt will read from there when configured properly.
;
; @param	a	Affects the frequency of the wave?
; @addr{13a5}
loadBigBufferScrollValues:
	ldh (<hFF93),a	; $13a5
	ld a,($ff00+R_SVBK)	; $13a7
	ld c,a			; $13a9
	ldh a,(<hRomBank)	; $13aa
	ld b,a			; $13ac
	push bc			; $13ad
	ld a,:bank1.loadBigBufferScrollValues_body		; $13ae
	setrombank		; $13b0
	ldh a,(<hFF93)	; $13b5
	ld b,a			; $13b7
	call bank1.loadBigBufferScrollValues_body		; $13b8
	pop bc			; $13bb
	ld a,b			; $13bc
	setrombank		; $13bd
	ld a,c			; $13c2
	ld ($ff00+R_SVBK),a	; $13c3
	ret			; $13c5

;;
; @param	bc	Pointer to palette data?
; @param	hl	Pointer to palette data?
; @addr{13c6}
func_13c6:
	ldh a,(<hRomBank)	; $13c6
	push af			; $13c8
	ld a,:w2ColorComponentBuffer1		; $13c9
	ld ($ff00+R_SVBK),a	; $13cb
	push de			; $13cd
	push bc			; $13ce
	ld de,w2ColorComponentBuffer1		; $13cf
	call extractColorComponents		; $13d2
	pop hl			; $13d5
	ld de,w2ColorComponentBuffer2		; $13d6
	call extractColorComponents		; $13d9
	pop de			; $13dc
	pop af			; $13dd
	setrombank		; $13de
	xor a			; $13e3
	ld ($ff00+R_SVBK),a	; $13e4
	jp startFadeBetweenTwoPalettes		; $13e6

;;
; This function appears to extract the color components from $30 colors ($c palettes).
; This is probably used for palette fades.
;
; @param	de	Destination to write colors to
; @param	hl	First palette to extract from
; @addr{13e9}
extractColorComponents:
	ldh a,(<hRomBank)	; $13e9
	push af			; $13eb
	ld a,:paletteDataStart	; $13ec
	setrombank		; $13ee
	ld b,$30		; $13f3
--
	ld c,(hl)		; $13f5
	inc hl			; $13f6
	ld a,(hl)		; $13f7
	sla c			; $13f8
	rla			; $13fa
	rl c			; $13fb
	rla			; $13fd
	rl c			; $13fe
	rla			; $1400
	and $1f			; $1401
	ld (de),a		; $1403
	inc e			; $1404
	ldd a,(hl)		; $1405
	rra			; $1406
	rra			; $1407
	and $1f			; $1408
	ld (de),a		; $140a
	inc e			; $140b
	ldi a,(hl)		; $140c
	and $1f			; $140d
	ld (de),a		; $140f
	inc e			; $1410
	inc hl			; $1411
	dec b			; $1412
	jr nz,--

	pop af			; $1415
	setrombank		; $1416
	ret			; $141b

;;
; Similar to setTile, except this won't reload the tile's graphics at vblank.
;
; This is only ever actually used by setTile itself.
;
; @param	a	Value to change tile to
; @param	c	Position of tile to change
; @addr{141c}
setTileWithoutGfxReload:
	ld b,>wRoomLayout	; $141c
	ld (bc),a		; $141e
	call retrieveTileCollisionValue		; $141f
	ld b,>wRoomCollisions
	ld (bc),a		; $1424
	ret			; $1425

;;
; @param	b	New index for tile
; @param	c	Position to change
; @addr{1426}
setTileInRoomLayoutBuffer:
	ld a,($ff00+R_SVBK)	; $1426
	push af			; $1428
	ld a,:w3RoomLayoutBuffer	; $1429
	ld ($ff00+R_SVBK),a	; $142b
	ld a,b			; $142d
	ld b,>w3RoomLayoutBuffer	; $142e
	ld (bc),a		; $1430
	pop af			; $1431
	ld ($ff00+R_SVBK),a	; $1432
	ret			; $1434

;;
; Gets the type of tile at the object's position plus bc (b=y, c=x).
;
; @param	bc	Offset to add to object's position
; @param[out]	a	The tile at position bc
; @param[out]	hl	The tile's address in wRoomLayout
; @addr{1435}
objectGetRelativeTile:
	ldh a,(<hActiveObjectType)	; $1435
	or Object.yh
	ld l,a			; $1439
	ld h,d			; $143a
	ldi a,(hl)		; $143b
	add b			; $143c
	ld b,a			; $143d
	inc l			; $143e
	ldi a,(hl)		; $143f
	add c			; $1440
	ld c,a			; $1441
	jr getTileAtPosition

;;
; Gets the tile index the object is on.
;
; @param[in]	d	Object
; @param[out]	a	The tile at the object's position
; @param[out]	hl	The tile's address in wRoomLayout
; @addr{1444}
objectGetTileAtPosition:
	call objectGetPosition		; $1444
;;
; @param[in]	bc	The position to check (format: YYXX)
; @param[out]	a	The tile at position bc
; @param[out]	hl	The tile's address in wRoomLayout
; @addr{1447}
getTileAtPosition:
	ld a,c			; $1447
	and $f0			; $1448
	swap a			; $144a
	ld l,a			; $144c
	ld a,b			; $144d
	and $f0			; $144e
	or l			; $1450
	ld l,a			; $1451
	ld h,>wRoomLayout
	ld a,(hl)		; $1454
	ret			; $1455

;;
; Returns the direction of a type of tile if it's adjacent to the object, or $ff if that
; tile is not adjacent.
;
; @param	a	Tile to check for adjacency
; @param[out]	a	The direction of the tile relative to the object, or $ff.
; @addr{1456}
objectGetRelativePositionOfTile:
	ldh (<hFF8B),a	; $1456
	call objectGetShortPosition		; $1458
	ld e,a			; $145b
	ld h,>wRoomLayout

	ld a,$f0		; $145e
	call @checkTileAtOffset		; $1460
	ld a,DIR_UP
	ret z			; $1465

	ld a,$01		; $1466
	call @checkTileAtOffset		; $1468
	ld a,DIR_RIGHT
	ret z			; $146d

	ld a,$10		; $146e
	call @checkTileAtOffset		; $1470
	ld a,DIR_DOWN
	ret z			; $1475

	ld a,$ff		; $1476
	call @checkTileAtOffset		; $1478
	ld a,DIR_LEFT
	ret z			; $147d

	ld a,$ff		; $147e
	ret			; $1480

;;
; @param	a	Offset to add to 'e'
; @param	e	Position of object
; @param[out]	zflag	Set if the tile is at that position.
; @addr{1481}
@checkTileAtOffset:
	add e			; $1481
	ld l,a			; $1482
	ldh a,(<hFF8B)	; $1483
	cp (hl)			; $1485
	ret			; $1486

;;
; Seems to return 1 (zero flag unset) if the object is on a solid part of a tile. Accounts
; for quarter tiles.
;
; This will NOT work for collision values $10 and above.
;
; @param[out]	zflag	Set if there is no collision.
; @addr{1487}
objectCheckSimpleCollision:
	ldh a,(<hActiveObjectType)	; $1487
	or Object.yh
	ld l,a			; $148b
	ld h,d			; $148c

	; Load YX into bc, put shortened YX into 'l'.
	ld b,(hl)		; $148d
	inc l			; $148e
	inc l			; $148f
	ld c,(hl)		; $1490
	ld a,b			; $1491
	and $f0			; $1492
	ld l,a			; $1494
	ld a,c			; $1495
	swap a			; $1496
	and $0f			; $1498
	or l			; $149a
	ld l,a			; $149b

	ld h,>wRoomCollisions
	ld a,(hl)		; $149e

	; Set zero flag based on which quarter of the tile the object is on
	bit 3,b			; $149f
	jr nz,+
	rrca			; $14a3
	rrca			; $14a4
+
	bit 3,c			; $14a5
	jr nz,+
	rrca			; $14a9
+
	and $01			; $14aa
	ret			; $14ac

;;
; Get the collision value of the tile the object is on.
;
; @param[out]	a	Collision value
; @param[out]	hl	Address of collision data
; @param[out]	zflag	Set if there is no collision.
; @addr{14ad}
objectGetTileCollisions:
	ldh a,(<hActiveObjectType)	; $14ad
	or Object.yh
	ld l,a			; $14b1
	ld h,d			; $14b2

	; Load YX into bc
	ld b,(hl)		; $14b3
	inc l			; $14b4
	inc l			; $14b5
	ld c,(hl)		; $14b6

;;
; @param	bc	Position
; @param[out]	a	Collision value
; @param[out]	hl	Address of collision data
; @param[out]	zflag	Set if there is no collision.
; @addr{14b7}
getTileCollisionsAtPosition:
	ld a,b			; $14b7
	and $f0			; $14b8
	ld l,a			; $14ba
	ld a,c			; $14bb
	swap a			; $14bc
	and $0f			; $14be
	or l			; $14c0
	ld l,a			; $14c1

	ld h,>wRoomCollisions	; $14c2
	ld a,(hl)		; $14c4
	or a			; $14c5
	ret			; $14c6

;;
; Checks if the object is colliding with a tile.
;
; This accounts for quarter-tiles as well as "special collisions" (collision value $10 or
; higher). Meant for link and items, as it allows passage through holes and lava (enemies
; should be prevented from doing that).
;
; @param[out]	cflag	Set on collision
; @addr{14c7}
objectCheckTileCollision_allowHoles:
	ldh a,(<hActiveObjectType)	; $14c7
	or Object.yh
	ld l,a			; $14cb
	ld h,d			; $14cc

	; Load YX into bc
	ld b,(hl)		; $14cd
	inc l			; $14ce
	inc l			; $14cf
	ld c,(hl)		; $14d0

;;
; Same as above function, but with explicit YX.
;
; @param	bc	YX position to check
; @addr{14d1}
checkTileCollisionAt_allowHoles:
	; Put shortened YX into 'l'
	ld a,b			; $14d1
	and $f0			; $14d2
	ld l,a			; $14d4
	ld a,c			; $14d5
	swap a			; $14d6
	and $0f			; $14d8
	or l			; $14da
	ld l,a			; $14db

;;
; @addr{14dc}
checkTileCollision_allowHoles:
	ld h,>wRoomCollisions	; $14dc
	ld a,(hl)		; $14de

;;
; @param	a	Collision value
; @param	bc	YX position to check
; @addr{14df}
checkGivenCollision_allowHoles:
	cp $10			; $14df
	jr c,_simpleCollision	; $14e1

	ld hl,@specialCollisions		; $14e3
	jr _complexCollision		; $14e6

; See constants/specialCollisionValues.s for what each of these bytes is for.
; ie. The first defined byte is for holes.
@specialCollisions:
	.db %00000000 %11000011 %00000011 %11000000 %00000000 %11000011 %11000011 %00000000
	.db %00000000 %11000011 %00000011 %11000000 %11000000 %11000001 %11111111 %00000000

;;
; Same as above functions, but for enemies that shouldn't be allowed to cross holes or
; water tiles.
;
; @addr{14f8}
objectCheckTileCollision_disallowHoles:
	ldh a,(<hActiveObjectType)	; $14f8
	or Object.yh
	ld l,a			; $14fc
	ld h,d			; $14fd

	; Load YX into bc
	ld b,(hl)		; $14fe
	inc l			; $14ff
	inc l			; $1500
	ld c,(hl)		; $1501

;;
; @param	bc	YX position to check
; @addr{1502}
checkTileCollisionAt_disallowHoles:
	; Put shortened YX into 'l'
	ld a,b			; $1502
	and $f0			; $1503
	ld l,a			; $1505
	ld a,c			; $1506
	swap a			; $1507
	and $0f			; $1509
	or l			; $150b
	ld l,a			; $150c

;;
; @addr{150d}
checkTileCollision_disallowHoles:
	ld h,>wRoomCollisions	; $150d
	ld a,(hl)		; $150f

;;
; @param	a	Collision value
; @addr{1510}
checkGivenCollision_disallowHoles:
	cp $10			; $1510
	jr c,_simpleCollision	; $1512
	ld hl,@specialCollisions
	jr _complexCollision		; $1517

@specialCollisions:
	.db %11111111 %11000011 %00000011 %11000000 %00000000 %11000011 %11000011 %00000000
	.db %00000000 %11000011 %00000011 %11000000 %11000001 %11000001 %11111111 %11111111

;;
; @param	bc	Full position to check
; @param	l	Shortened position (where the tile is)
; @addr{1529}
checkCollisionPosition_disallowSmallBridges:
	ld h,>wRoomCollisions	; $1529
	ld a,(hl)		; $152b
	cp $10			; $152c
	jr c,_simpleCollision	; $152e
	ld hl,@specialCollisions		; $1530
	jr _complexCollision		; $1533

@specialCollisions:
	.db %00000000 %11111111 %00000011 %11000000 %11000011 %11000011 %11000011 %00000000
	.db %00000000 %11111111 %00000011 %11000000 %11000001 %11000001 %11111111 %00000000

; Sets carry flag if the object is not in a wall?
_simpleCollision:
	bit 3,b			; $1545
	jr nz,+
	rrca			; $1549
	rrca			; $154a
+
	bit 3,c			; $154b
	jr nz,+
	rrca			; $154f
+
	rrca			; $1550
	ret			; $1551

; @param	bc	Position
; @param	hl
; @param[out]	cflag	Set on collision?
; @param[out]	zflag	Unset on collision?
_complexCollision:
	push de			; $1552
	and $0f			; $1553
	ld e,a			; $1555
	ld d,$00		; $1556

	add hl,de		; $1558
	ld e,(hl)		; $1559
	cp $08			; $155a
	ld a,b			; $155c
	jr nc,+
	ld a,c			; $155f
+
	rrca			; $1560
	and $07			; $1561
	ld hl,bitTable		; $1563
	add l			; $1566
	ld l,a			; $1567
	ld a,(hl)		; $1568
	and e			; $1569
	pop de			; $156a
	ret z			; $156b
	scf			; $156c
	ret			; $156d

;;
; Get tile collision value from buffer in bank 3, not wRoomCollisions
; @addr{156e}
retrieveTileCollisionValue:
	ld h,>w3TileCollisions	; $156e
	ld l,a			; $1570
	ld a,:w3TileCollisions
	ld ($ff00+R_SVBK),a	; $1573
	ld l,(hl)		; $1575
	xor a			; $1576
	ld ($ff00+R_SVBK),a	; $1577
	ld a,l			; $1579
	ret			; $157a

;;
; Load data into wRoomCollisions based on wRoomLayout and w3TileCollisions
; @addr{157b}
loadRoomCollisions:
	ld a,:w3TileCollisions	; $157b
	ld ($ff00+R_SVBK),a	; $157d
	ld d,>w3TileCollisions
	ld hl,wRoomLayout		; $1581
	ld b,LARGE_ROOM_HEIGHT*$10
-
	ld a,(hl)		; $1586
	ld e,a			; $1587
	ld a,(de)		; $1588
	dec h			; $1589
	ldi (hl),a		; $158a
	inc h			; $158b
	dec b			; $158c
	jr nz,-

	call @blankDataAroundCollisions		; $158f
	xor a			; $1592
	ld ($ff00+R_SVBK),a	; $1593
	ret			; $1595

;;
; Blanks data around the "edges" of wRoomCollisions.
; @addr{1596}
@blankDataAroundCollisions:
	ld hl, wRoomCollisions+$f0		; $1596
	call @blankDataHorizontally		; $1599
	ld hl, wRoomCollisions+$0f		; $159c
	call @blankDataVertically		; $159f
	ld a,(wActiveGroup)		; $15a2
	cp NUM_SMALL_GROUPS
	jr c,+
	ld l,LARGE_ROOM_HEIGHT*$10
	jr @blankDataHorizontally
+
	ld l,SMALL_ROOM_HEIGHT*$10
	call @blankDataHorizontally		; $15af
	ld l,SMALL_ROOM_WIDTH
	jr @blankDataVertically

@blankDataHorizontally:
	ld a,$ff		; $15b6
	ld b,$10		; $15b8
-
	ldi (hl),a		; $15ba
	dec b			; $15bb
	jr nz,-
	ret			; $15be

@blankDataVertically:
	ld b,LARGE_ROOM_HEIGHT
	ld c,$ff		; $15c1
-
	ld (hl),c		; $15c3
	ld a,l			; $15c4
	add $10			; $15c5
	ld l,a			; $15c7
	dec b			; $15c8
	jr nz,-
	ret			; $15cb

;;
; @param	a	Tile to find in the room
; @param[out]	hl	Address of the tile in wRoomLayout (if it was found)
; @param[out]	zflag	z if the tile was found.
; @addr{15cc}
findTileInRoom:
	ld h,>wRoomLayout	; $15cc
	ld l,LARGE_ROOM_HEIGHT*$10+$0f

;;
; @param	a	Value to search for
; @param	hl	Address to start the search at (end when 'l' reaches 0)
; @param[out]	hl	Address of the value (if it was found)
; @param[out]	zflag	z if the value was found.
; @addr{15d0}
backwardsSearch:
	cp (hl)			; $15d0
	ret z			; $15d1
	dec l			; $15d2
	jr nz,backwardsSearch

	cp (hl)			; $15d5
	ret			; $15d6

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
; @addr{15d7}
getTileIndexFromRoomLayoutBuffer:
	ld c,a			; $15d7

;;
; @addr{15d8}
getTileIndexFromRoomLayoutBuffer_paramC:
	ld a,($ff00+R_SVBK)	; $15d8
	push af			; $15da
	ld a,:w3RoomLayoutBuffer	; $15db
	ld ($ff00+R_SVBK),a	; $15dd
	ld b,>w3RoomLayoutBuffer	; $15df
	ld a,(bc)		; $15e1
	ld e,a			; $15e2
	ld a,:w3TileCollisions
	ld ($ff00+R_SVBK),a	; $15e5
	ld l,e			; $15e7
	ld h,>w3TileCollisions
	ld b,(hl)		; $15ea
	pop af			; $15eb
	ld ($ff00+R_SVBK),a	; $15ec
	ld a,b			; $15ee
	cp $10			; $15ef
	jr nc,++

	or a			; $15f3
	jr z,++

	scf			; $15f6
	ld a,e			; $15f7
	ret			; $15f8
++
	ld a,e			; $15f9
	ret			; $15fa

;;
; Load an interaction's graphics and initialize the animation.
; @param[out] c
; @addr{15fb}
interactionInitGraphics:
	ldh a,(<hRomBank)	; $15fb
	push af			; $15fd
	callfrombank0 bank3f.interactionLoadGraphics		; $15fe
	ld c,a			; $1608
	pop af			; $1609
	setrombank		; $160a
	ld a,c			; $160f
	jp interactionSetAnimation		; $1610

;;
; @addr{1613}
func_1613:
	ld a,(wLoadedTreeGfxIndex)		; $1613
	or a			; $1616
	ret z			; $1617
;;
; @addr{1618}
refreshObjectGfx:
	ldh a,(<hRomBank)	; $1618
	push af			; $161a
	callfrombank0 bank3f.refreshObjectGfx_body		; $161b
	xor a			; $1625
	ld (wLoadedTreeGfxIndex),a		; $1626
	pop af			; $1629
	setrombank		; $162a
	ret			; $162f

;;
; @addr{1630}
reloadObjectGfx:
	ldh a,(<hRomBank)	; $1630
	push af			; $1632
	callfrombank0 bank3f.reloadObjectGfx	; $1633
	pop af			; $163d
	setrombank		; $163e
	ret			; $1643

;;
; Forces an object gfx header to be loaded into slot 4 (address 0:8800). Handy way to load
; extra graphics, but uses up object slots. Used by the pirate ship and various things in
; seasons, but apparently unused in ages.
;
; @param	e	Object gfx header (minus 1)
; @addr{1644}
loadObjectGfxHeaderToSlot4:
	ldh a,(<hRomBank)	; $1644
	push af			; $1646
	callfrombank0 bank3f.loadObjectGfxHeaderToSlot4_body		; $1647
	pop af			; $1651
	setrombank		; $1652
	ret			; $1657

;;
; @param	a	Tree gfx index
; @addr{1658}
loadTreeGfx:
	ld e,a			; $1658
	ldh a,(<hRomBank)	; $1659
	push af			; $165b
	callfrombank0 bank3f.loadTreeGfx_body	; $165c
	pop af			; $1666
	setrombank		; $1667
	ret			; $166c

;;
; @param	a	Uncompressed gfx header to load
; @addr{166d}
loadWeaponGfx:
	ld e,a			; $166d
	ldh a,(<hRomBank)	; $166e
	push af			; $1670
	callfrombank0 bank3f.loadWeaponGfx		; $1671
	pop af			; $167b
	setrombank		; $167c
	ret			; $1681

;;
; Loads $20 tiles of gfx data from the 3-byte pointer at hl.
; Ultimate gfx destination is (b<<8).
; Uses DMA, and buffers at 4:dc00 and 4:de00, for safe transfers.
;
; @param	b	High byte of destination to write gfx to (low byte is $00)
; @param	hl	Address to read from to get the index to load
; @addr{1682}
loadObjectGfx:
	ld d,b			; $1682
	ld e,$00		; $1683
	ldi a,(hl)		; $1685
;;
; @param a
; @param de
; @param hl
; @addr{1685}
loadObjectGfx2:
	ld c,a			; $1686
	ldi a,(hl)		; $1687
	ld l,(hl)		; $1688
	and $7f			; $1689
	ld h,a			; $168b

.ifdef ROM_AGES
	ld a,($cc20)		; $168c
	or a			; $168f
	jr nz,@label_00_192	; $1690
.endif

	push de			; $1692
	ld a,(wcc07)		; $1693
	xor $ff			; $1696
	ld (wcc07),a		; $1698
	ld de,w4GfxBuf1 | (:w4GfxBuf1)	; $169b
	jr nz,+			; $169e
	ld de,w4GfxBuf2 | (:w4GfxBuf2)	; $16a0
+
	push de			; $16a3
	ld b,$1f		; $16a4
	call decompressGraphics		; $16a6
	pop hl			; $16a9
	pop de			; $16aa
	ld c,:w4GfxBuf1		; $16ab
	ld a,$01		; $16ad
	ld ($ff00+R_SVBK),a	; $16af
	ld a,$3f		; $16b1
	setrombank		; $16b3
	ld b,$1f		; $16b8
	jp queueDmaTransfer		; $16ba

.ifdef ROM_AGES

@label_00_192:
	ld a,d			; $16bd
	or $d0			; $16be
	ld d,a			; $16c0
	ld a,$05		; $16c1
	add e			; $16c3
	ld e,a			; $16c4
	ld b,$1f		; $16c5
	call decompressGraphics		; $16c7
	ld a,$01		; $16ca
	ld ($ff00+R_SVBK),a	; $16cc
	ld a,$3f		; $16ce
	setrombank		; $16d0
	ret			; $16d5
.endif

;;
; Load graphics for an item (as in, items on the inventory screen)
;
; @param a Item index
; @addr{16d6}
loadTreasureDisplayData:
	ld l,a			; $16d6
	ldh a,(<hRomBank)	; $16d7
	push af			; $16d9
	callfrombank0 bank3f.loadTreasureDisplayData		; $16da
	pop af			; $16e4
	setrombank		; $16e5
	ret			; $16ea

;;
; @param	a
; @param[out]	a,c	Subid for PARTID_ITEM_DROP (see constants/itemDrops.s)
; @param[out]	zflag	z if there is no item drop
; @addr{16eb}
decideItemDrop:
	ld c,a			; $16eb
	ldh a,(<hRomBank)	; $16ec
	push af			; $16ee
	callfrombank0 bank3f.decideItemDrop_body	; $16ef
	pop af			; $16f9
	setrombank		; $16fa
	ld a,c			; $16ff
	cp $ff			; $1700
	ret			; $1702

;;
; Checks whether an item drop of a given type can spawn.
;
; @param	a	Item drop index (see constants/itemDrops.s)
; @param[out]	zflag	z if item cannot spawn (Link doesn't have it)
; @addr{1703}
checkItemDropAvailable:
	ld c,a			; $1703
	ldh a,(<hRomBank)	; $1704
	push af			; $1706
	ld a,:bank3f.checkItemDropAvailable_body		; $1707
	setrombank		; $1709
	ld a,c			; $170e
	call bank3f.checkItemDropAvailable_body		; $170f
	pop af			; $1712
	setrombank		; $1713
	ld a,c			; $1718
	cp $ff			; $1719
	ret			; $171b

;;
; @param	a	Treasure for Link to obtain (see constants/treasure.s)
; @param	c	Parameter (ie. item level, ring index, etc...)
; @param[out]	a	Sound to play on obtaining the treasure (if nonzero)
; @addr{171c}
giveTreasure:
	ld b,a			; $171c
	ldh a,(<hRomBank)	; $171d
	push af			; $171f
	callfrombank0 bank3f.giveTreasure_body		; $1720
	pop af			; $172a
	setrombank		; $172b
	ld a,b			; $1730
	or a			; $1731
	ret			; $1732

;;
; @param	a	Treasure for Link to lose (see constants/treasure.s)
; @addr{1733}
loseTreasure:
	ld b,a			; $1733
	ldh a,(<hRomBank)	; $1734
	push af			; $1736
	callfrombank0 bank3f.loseTreasure_body		; $1737
	pop af			; $1741
	setrombank		; $1742
	ret			; $1747

;;
; @param	a	Item to check for (see constants/treasure.s)
; @param[out]	cflag	Set if you have that item
; @param[out]	a	The value of the treasure's "related variable" (ie. item level)
; @addr{1748}
checkTreasureObtained:
	push hl			; $1748
	ld l,a			; $1749
	or a			; $174a
	jr z,++			; $174b

	ldh a,(<hRomBank)	; $174d
	push af			; $174f
	callfrombank0 bank3f.checkTreasureObtained_body	; $1750
	pop af			; $175a
	setrombank		; $175b
	ld a,l			; $1760
	srl h			; $1761
++
	pop hl			; $1763
	ret			; $1764


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
; @addr{1765}
cpRupeeValue:
	ld hl,wNumRupees		; $1765
++
	call getRupeeValue		; $1768
	ldi a,(hl)		; $176b
	ld h,(hl)		; $176c
	ld l,a			; $176d
	call compareHlToBc		; $176e
	inc a			; $1771
	jr nz,+			; $1772

	inc a			; $1774
	ret			; $1775
+
	xor a			; $1776
	ret			; $1777


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
; @addr{1778}
removeRupeeValue:
	ld hl,wNumRupees		; $1778
++
	call getRupeeValue		; $177b
	jp subDecimalFromHlRef		; $177e

;;
; @param	a	The "type" of rupee you're getting.
; @param[out]	bc	The amount of rupees you get from it
; @addr{1781}
getRupeeValue:
	push hl			; $1781
	cp RUPEEVAL_COUNT-1			; $1782
	jr c,+			; $1784
	ld a,RUPEEVAL_COUNT-1			; $1786
+
	ld hl,@rupeeValues		; $1788
	rst_addDoubleIndex			; $178b
	ldi a,(hl)		; $178c
	ld b,(hl)		; $178d
	ld c,a			; $178e
	pop hl			; $178f
	ret			; $1790

; Each number here corresponds to a value in constants/rupeeValues.s.
; @addr{1791}
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
; @addr{17bb}
decNumActiveSeeds:
	and $07			; $17bb
	ld hl,wNumEmberSeeds		; $17bd
	rst_addAToHl			; $17c0
	jr +				; $17c1

;;
; @addr{17c3}
decNumBombchus:
	ld hl,wNumBombchus		; $17c3
	jr +				; $17c6

;;
; @addr{17c8}
decNumBombs:
	ld hl,wNumBombs		; $17c8
+
	ld a,(hl)		; $17cb
	or a			; $17cc
	ret z			; $17cd

	call setStatusBarNeedsRefreshBit1		; $17ce
	ld a,(hl)		; $17d1
	sub $01			; $17d2
	daa			; $17d4
	ld (hl),a		; $17d5
	or h			; $17d6
	ret			; $17d7

;;
; @addr{17d8}
setStatusBarNeedsRefreshBit1:
	push hl			; $17d8
	ld hl,wStatusBarNeedsRefresh		; $17d9
	set 1,(hl)		; $17dc
	pop hl			; $17de
	ret			; $17df

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
; @addr{17e0}
getRandomRingOfGivenTier:
	ldh a,(<hRomBank)	; $17e0
	push af			; $17e2
	ld a,:bank3f.ringTierTable		; $17e3
	setrombank		; $17e5

	ld b,$01		; $17ea
	ld a,c			; $17ec
	cp $04			; $17ed
	jr z,+			; $17ef
	ld b,$07		; $17f1
+
	ld hl,bank3f.ringTierTable		; $17f3
	rst_addDoubleIndex			; $17f6
	ldi a,(hl)		; $17f7
	ld h,(hl)		; $17f8
	ld l,a			; $17f9

	call getRandomNumber		; $17fa
	and b			; $17fd
	ld c,a			; $17fe
	ld b,$00		; $17ff
	add hl,bc		; $1801
	ld c,(hl)		; $1802

	pop af			; $1803
	setrombank		; $1804

	ld a,TREASURE_RING		; $1809
	ret			; $180b

;;
; Fills the seed satchel with all seed types that Link currently has.
; @addr{180c}
refillSeedSatchel:
	ld e,TREASURE_EMBER_SEEDS		; $180c
--
	ld a,e			; $180e
	call checkTreasureObtained		; $180f
	jr nc,+			; $1812

	ld a,e			; $1814
	ld c,$99		; $1815
	call giveTreasure		; $1817
+
	inc e			; $181a
	ld a,e			; $181b
	cp TREASURE_MYSTERY_SEEDS+1			; $181c
	jr c,--			; $181e
	ret			; $1820

;;
; @param	a	Amount to add to wGashaMaturity
; @addr{1821}
addToGashaMaturity:
	push hl			; $1821
	ld hl,wGashaMaturity		; $1822
	add (hl)		; $1825
	ldi (hl),a		; $1826
	jr nc,+			; $1827

	inc (hl)		; $1829
	jr nz,+			; $182a

	ld a,$ff		; $182c
	ldd (hl),a		; $182e
	ld (hl),a		; $182f
+
	pop hl			; $1830
	ret			; $1831

;;
; @addr{1832}
makeActiveObjectFollowLink:
	ldh a,(<hRomBank)	; $1832
	push af			; $1834
	callfrombank0 bank1.makeActiveObjectFollowLink		; $1835
	pop af			; $183f
	setrombank		; $1840
	ret			; $1845

;;
; @addr{1846}
clearFollowingLinkObject:
	ld hl,wFollowingLinkObjectType		; $1846
	xor a			; $1849
	ldi (hl),a		; $184a
	ld (hl),a		; $184b
	ret			; $184c

;;
; @addr{184d}
stopTextThread:
	xor a			; $184d
	ld (wTextIsActive),a		; $184e
	ld (wTextboxFlags),a		; $1851
	ld a,THREAD_2		; $1854
	jp threadStop		; $1856

;;
; @addr{1859}
retIfTextIsActive:
	ld a,(wTextIsActive)		; $1859
	or a			; $185c
	ret z			; $185d
	pop af			; $185e
	ret			; $185f

;;
; @addr{1860}
showTextOnInventoryMenu:
	ld a,(wTextboxFlags)		; $1860
	set TEXTBOXFLAG_BIT_NOCOLORS,a			; $1863
	ld (wTextboxFlags),a		; $1865
	ld l,$00		; $1868
	ld e,$02		; $186a
	jr _label_00_204		; $186c

;;
; Displays text index bc while not being able to exit the textbox with button presses
;
; @addr{186e}
showTextNonExitable:
	ld l,TEXTBOXFLAG_NONEXITABLE	; $186e
	jr _label_00_203		; $1870

;;
; Displays text index bc
; @addr{1872}
showText:
	ld l,$00		; $1872
_label_00_203:
	ld e,$00		; $1874
_label_00_204:
	ld a,(wTextboxFlags)		; $1876
	or l			; $1879
	ld (wTextboxFlags),a		; $187a
	ld a,b			; $187d
	add $04			; $187e
	ld b,a			; $1880

	ld hl,wTextDisplayMode		; $1881
	ld (hl),e		; $1884
	inc l			; $1885
	ld (hl),c		; $1886
	inc l			; $1887
	ld a,b			; $1888
	ldi (hl),a		; $1889

	; wTextIndexH_backup
	ldi (hl),a		; $188a

	; wSelectedTextOption
	ld (hl),$ff		; $188b
	inc l			; $188d

	; wTextGfxColorIndex
	ld (hl),$02		; $188e
	inc l			; $1890

	; wTextMapAddress
	ld (hl),$98		; $1891

	ld a,$01		; $1893
	ld (wTextIsActive),a		; $1895

	ld bc,textThreadStart		; $1898
	ld a,THREAD_2		; $189b
	jp threadRestart		; $189d

;;
; @addr{18a0}
textThreadStart:
	ld a,(wScrollMode)		; $18a0
	or a			; $18a3
	jr z,@showText		; $18a4

	and $01			; $18a6
	jr nz,@showText		; $18a8

@dontShowText:
	xor a			; $18aa
	ld (wTextIsActive),a		; $18ab
	ld (wTextboxFlags),a		; $18ae
	jp stubThreadStart		; $18b1

@showText:
	callfrombank0 bank3f.initTextbox		; $18b4
-
	callfrombank0 bank3f.updateTextbox		; $18be
	call resumeThreadNextFrame		; $18c8
	jr -			; $18cb

;;
; Can only be called from bank $3f.
;
; @param	[w7TextGfxSource]	Table to use
; @param	a			Character
; @param	bc			Address to write data to
; @addr{18cd}
retrieveTextCharacter:
	push hl			; $18cd
	push de			; $18ce
	push bc			; $18cf
	call multiplyABy16		; $18d0
	ld a,(w7TextGfxSource)		; $18d3
	ld hl,@data		; $18d6
	rst_addDoubleIndex			; $18d9
	ldi a,(hl)		; $18da
	ld h,(hl)		; $18db
	ld l,a			; $18dc
	add hl,bc		; $18dd
	pop bc			; $18de
	ld a,:gfx_font		; $18df
	setrombank		; $18e1
	call @func_18fd		; $18e6

	ld a,BANK_3f		; $18e9
	setrombank		; $18eb

	xor a			; $18f0
	ld (w7TextGfxSource),a		; $18f1
	pop de			; $18f4
	pop hl			; $18f5
	ret			; $18f6

; @addr{18f7}
@data:
	.dw gfx_font_start
	.dw gfx_font_jp
	.dw gfx_font_tradeitems

;;
; @param bc
; @param hl
; @addr{18fd}
@func_18fd:
	ld e,$10		; $18fd

	; gfx_font_start+$140 is the heart character. It's always red?
	ld a,h			; $18ff
	cp >(gfx_font_start+$140)	; $1900
	jr nz,@notHeart		; $1902

	ld a,l			; $1904
	cp <(gfx_font_start+$140)	; $1905
	jr z,@color1		; $1907

@notHeart:
	ld a,(wTextGfxColorIndex)		; $1909
	and $0f			; $190c

	or a			; $190e
	jr z,@color0		; $190f

	dec a			; $1911
	jr z,@color1		; $1912

	dec a			; $1914
	jr z,@color2		; $1915

	; If [wTextGfxColorIndex] == 3, read the tile as 2bpp.
@2bpp:
	ld e,$20		; $1917
-
	ldi a,(hl)		; $1919
	ld (bc),a		; $191a
	inc bc			; $191b
	dec e			; $191c
	jr nz,-			; $191d

	ld a,(wTextGfxColorIndex)		; $191f
	and $f0			; $1922
	swap a			; $1924
	ld (wTextGfxColorIndex),a		; $1926
	ret			; $1929
@color0:
	ldi a,(hl)		; $192a
	ld (bc),a		; $192b
	inc c			; $192c
	ld (bc),a		; $192d
	inc bc			; $192e
	dec e			; $192f
	jr nz,@color0		; $1930
	ret			; $1932
@color1:
	ld a,$ff		; $1933
	ld (bc),a		; $1935
	inc c			; $1936
	ldi a,(hl)		; $1937
	ld (bc),a		; $1938
	inc bc			; $1939
	dec e			; $193a
	jr nz,@color1		; $193b
	ret			; $193d
@color2:
	ldi a,(hl)		; $193e
	ld (bc),a		; $193f
	inc c			; $1940
	ld a,$ff		; $1941
	ld (bc),a		; $1943
	inc bc			; $1944
	dec e			; $1945
	jr nz,@color2		; $1946
	ret			; $1948

;;
; Can only be called from bank $3f. Also assumes RAM bank 7 is loaded.
;
; @addr{1949}
readByteFromW7ActiveBank:
	push bc			; $1949
	ld a,(w7ActiveBank)		; $194a
	setrombank		; $194d
	ld b,(hl)		; $1952

	ld a,BANK_3f		; $1953
	setrombank		; $1955

	ld a,b			; $195a
	pop bc			; $195b
	ret			; $195c

;;
; Assumes RAM bank 7 is loaded.
;
; @addr{195d}
readByteFromW7TextTableBank:
	ldh a,(<hRomBank)	; $195d
	push af			; $195f
	ld a,(w7TextTableBank)		; $1960
	bit 7,h			; $1963
	jr z,+

	res 7,h			; $1967
	set 6,h			; $1969
	inc a			; $196b
+
	setrombank		; $196c
	ldi a,(hl)		; $1971
	ldh (<hFF8B),a	; $1972

	pop af			; $1974
	setrombank		; $1975
	ldh a,(<hFF8B)	; $197a
	ret			; $197c

;;
; @addr{197d}
getThisRoomFlags:
	ld a,(wActiveRoom)		; $197d
getARoomFlags:
	push bc			; $1980
	ld b,a			; $1981
	ld a,(wActiveGroup)		; $1982
	call getRoomFlags		; $1985
	pop bc			; $1988
	ret			; $1989

;;
; @param	a	Group
; @param	b	Room
; @param[out]	a	Room flags
; @param[out]	hl	Address of room flags
; @addr{198a}
getRoomFlags:
	ld hl, flagLocationGroupTable	; $198a
	rst_addAToHl			; $198d
	ld h,(hl)		; $198e
	ld l,b			; $198f
	ld a,(hl)		; $1990
	ret			; $1991

;;
; @param[out]	zflag	z if unlinked
; @addr{1992}
checkIsLinkedGame:
	ld a,(wIsLinkedGame)		; $1992
	or a			; $1995
	ret			; $1996

;;
; @param	hl	Where to copy the values from for wWarpDestVariables
; @addr{1997}
setWarpDestVariables:
	push de			; $1997
	ld de,wWarpDestVariables	; $1998
	ld b,$05		; $199b
	call copyMemory		; $199d
	pop de			; $19a0
	ret			; $19a1

;;
; @addr{19a2}
setInstrumentsDisabledCounterAndScrollMode:
	ld a,$08		; $19a2
	ld (wInstrumentsDisabledCounter),a		; $19a4
	ld a,$01		; $19a7
	ld (wScrollMode),a		; $19a9
	ret			; $19ac

;;
; Clears all physical item objects (not parent items) and clears midair-related variables.
;
; @addr{19ad}
clearAllItemsAndPutLinkOnGround:
	push de			; $19ad
	call clearAllParentItems		; $19ae
	call dropLinkHeldItem		; $19b1

	xor a			; $19b4
	ld (wIsSeedShooterInUse),a		; $19b5

	ldde FIRST_ITEM_INDEX, Item.start		; $19b8

@nextItem:
	ld h,d			; $19bb

.ifdef ROM_AGES
	ld l,Item.id		; $19bc
	ld a,(hl)		; $19be
	cp ITEMID_18			; $19bf
	jr nz,@notSomariaBlock		; $19c1

; Somaria block creation

	ld l,Item.var2f		; $19c3
	set 5,(hl)		; $19c5
	set 4,(hl)		; $19c7
	ld l,Item.visible		; $19c9
	res 7,(hl)		; $19cb
	jr ++			; $19cd
.endif

@notSomariaBlock:
	ld l,e			; $19cf
	ld b,$40		; $19d0
	call clearMemory		; $19d2
++
	inc d			; $19d5
	ld a,d			; $19d6
	cp LAST_ITEM_INDEX+1			; $19d7
	jr c,@nextItem		; $19d9

	pop de			; $19db
	jp putLinkOnGround		; $19dc

;;
; @param	a			Character index
; @param	c			0 to use jp font, 1 to use english font
; @param	de			Where to write the character to
; @param	wFileSelect.fontXor	Value to xor every other byte with
; @addr{19df}
copyTextCharacterGfx:
	push hl			; $19df
	push bc			; $19e0
	ld hl,gfx_font_jp	; $19e1
	bit 0,c			; $19e4
	jr nz,+			; $19e6

	ld hl,gfx_font_start		; $19e8

	; Characters below $0e don't exist (or at least don't represent normal characters)
	cp $0e			; $19eb
	jr nc,+			; $19ed
	ld a,$20		; $19ef
+
	call multiplyABy16		; $19f1
	add hl,bc		; $19f4
	ldh a,(<hRomBank)	; $19f5
	push af			; $19f7
	ld a,:gfx_font		; $19f8
	setrombank		; $19fa
	ld a,(wFileSelect.fontXor)		; $19ff
	ld c,a			; $1a02
	ld b,$10		; $1a03
-
	ldi a,(hl)		; $1a05
	xor c			; $1a06
	ld (de),a		; $1a07
	inc de			; $1a08
	ld (de),a		; $1a09
	inc de			; $1a0a
	dec b			; $1a0b
	jr nz,-			; $1a0c

	pop af			; $1a0e
	setrombank		; $1a0f
	pop bc			; $1a14
	pop hl			; $1a15
	ret			; $1a16

;;
; @addr{1a17}
fileSelectThreadStart:
	ld hl,wTmpcbb3		; $1a17
	ld b,$10		; $1a1a
	call clearMemory		; $1a1c
-
	callfrombank0 bank2.b2_fileSelectScreen	; $1a1f
	call resumeThreadNextFrame		; $1a29
	jr -			; $1a2c

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
; @addr{1a2e}
secretFunctionCaller:
	ldh a,(<hRomBank)	; $1a2e
	push af			; $1a30
	callfrombank0 secretFunctionCaller_body	; $1a31
	pop af			; $1a3b
	setrombank		; $1a3c
	ld a,b			; $1a41
	or a			; $1a42
	ret			; $1a43

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
; @addr{1a44}
openSecretInputMenu:
	ld (wSecretInputType),a		; $1a44
	ld a,$01		; $1a47
	ld (wTextInputResult),a		; $1a49
	ld a,$06		; $1a4c
	jp openMenu		; $1a4e

;;
; @param[out]	zflag	Set if no menu is being displayed.
; @addr{1a51}
updateMenus:
	ld a,($ff00+R_SVBK)	; $1a51
	ld c,a			; $1a53
	ldh a,(<hRomBank)	; $1a54
	ld b,a			; $1a56
	push bc			; $1a57
	callfrombank0 bank2.b2_updateMenus	; $1a58
	pop bc			; $1a62
	ld a,b			; $1a63
	setrombank		; $1a64
	ld a,c			; $1a69
	ld ($ff00+R_SVBK),a	; $1a6a
	ld a,(wOpenedMenuType)		; $1a6c
	or a			; $1a6f
	ret			; $1a70

;;
; If wStatusBarNeedsRefresh is nonzero, this function dma's the status bar graphics to
; vram. It also reloads the item icon's graphics, if bit 0 is set.
;
; @addr{1a71}
checkReloadStatusBarGraphics:
	ld hl,wStatusBarNeedsRefresh		; $1a71
	ld a,(hl)		; $1a74
	or a			; $1a75
	ret z			; $1a76

	ld (hl),$00		; $1a77

	; If bit 0 is unset, just reload the status bar (w4StatusBarTileMap and
	; w4StatusBarAttributeMap); if bit 0 is set, also reload the item graphics
	; (w4ItemIconGfx).
	rrca			; $1a79
	ld a,UNCMP_GFXH_02		; $1a7a
	jr c,+			; $1a7c
	ld a,UNCMP_GFXH_03		; $1a7e
+
	jp loadUncompressedGfxHeader		; $1a80

;;
; Copy $20 bytes from bank b at hl to de.
;
; @param	b	Bank
; @param	de	Destination
; @param	hl	Source
; @addr{1a83}
copy20BytesFromBank:
	ldh a,(<hRomBank)	; $1a83
	push af			; $1a85
	ld a,b			; $1a86
	setrombank		; $1a87
	ld b,$20		; $1a8c
	call copyMemory		; $1a8e
	pop af			; $1a91
	setrombank		; $1a92
	ret			; $1a97

;;
; @addr{1a98}
loadCommonGraphics:
	ld h,$00		; $1a98
	jr +++			; $1a9a

;;
; Jumps to bank2._updateStatusBar.
; @addr{1a9c}
updateStatusBar:
	ld h,$01		; $1a9c
	jr +++			; $1a9e

;;
; @addr{1aa0}
hideStatusBar:
	ld h,$02		; $1aa0
	jr +++		; $1aa2

;;
; @addr{1aa4}
showStatusBar:
	ld h,$03		; $1aa4
	jr +++		; $1aa6

;;
; @addr{1aa8}
saveGraphicsOnEnterMenu:
	ld h,$04		; $1aa8
	jr +++		; $1aaa

;;
; @addr{1aac}
reloadGraphicsOnExitMenu:
	ld h,$05		; $1aac
	jr +++		; $1aae

;;
; @param	a	Type of menu to open (see wOpenedMenuType in wram.s)
; @addr{1ab0}
openMenu:
	ld h,$06		; $1ab0
	jr +++		; $1ab2

;;
; @addr{1ab4}
copyW2TilesetBgPalettesToW4PaletteData:
	ld h,$07		; $1ab4
	jr +++		; $1ab6

;;
; @addr{1ab8}
copyW4PaletteDataToW2TilesetBgPalettes:
	ld h,$08		; $1ab8
+++
	ld l,a			; $1aba
	ld a,($ff00+R_SVBK)	; $1abb
	ld c,a			; $1abd
	ldh a,(<hRomBank)	; $1abe
	ld b,a			; $1ac0
	push bc			; $1ac1
	callfrombank0 bank2.runBank2Function	; $1ac2
	pop bc			; $1acc
	ld a,b			; $1acd
	setrombank		; $1ace
	ld a,c			; $1ad3
	ld ($ff00+R_SVBK),a	; $1ad4
	ret			; $1ad6

;;
; @param[in]	b	Room
; @param[out]	b	Dungeon property byte for the given room (see
;			constants/dungeonRoomProperties.s)
; @addr{1ad7}
getRoomDungeonProperties:
	ldh a,(<hRomBank)	; $1ad7
	push af			; $1ad9
	ld a, :dungeonRoomPropertiesGroupTable
	setrombank		; $1adc
	ld a,(wActiveGroup)		; $1ae1
	and $01			; $1ae4
	ld hl, dungeonRoomPropertiesGroupTable
	rst_addDoubleIndex			; $1ae9
	ldi a,(hl)		; $1aea
	ld h,(hl)		; $1aeb
	ld l,a			; $1aec
	ld a,b			; $1aed
	rst_addAToHl			; $1aee
	ld b,(hl)		; $1aef
	pop af			; $1af0
	setrombank		; $1af1
	ret			; $1af6

;;
; @addr{1af7}
copy8BytesFromRingMapToCec0:
	ldh a,(<hRomBank)	; $1af7
	push af			; $1af9
	ld a,:map_rings		; $1afa
	setrombank		; $1afc
	ld de,wTmpcec0		; $1b01
	ld b,$08		; $1b04
	call copyMemory		; $1b06
	pop af			; $1b09
	setrombank		; $1b0a
	ret			; $1b0f

;;
; Runs game over screen?
;
; @addr{1b10}
thread_1b10:
	ld hl,wTmpcbb3		; $1b10
	ld b,$10		; $1b13
	call clearMemory		; $1b15
	ld a,$01		; $1b18
	ld (wTmpcbb4),a		; $1b1a
-
	callfrombank0 bank2.runSaveAndQuitMenu	; $1b1d
	call resumeThreadNextFrame		; $1b27
	jr -			; $1b2a

;;
; Calling this function allows an interaction to use the "checkabutton" command.
;
; @param	de	Variable to write $01 to when A button is pressed next to object
; @addr{1b2c}
objectAddToAButtonSensitiveObjectList:
	xor a			; $1b2c
	ld (de),a		; $1b2d
	ld hl,wAButtonSensitiveObjectList		; $1b2e
@next:
	ldi a,(hl)		; $1b31
	or (hl)			; $1b32
	jr z,@foundBlankEntry	; $1b33

	inc l			; $1b35
	ld a,l			; $1b36
	cp <wAButtonSensitiveObjectListEnd		; $1b37
	jr c,@next		; $1b39
	ret			; $1b3b
@foundBlankEntry:
	ld a,e			; $1b3c
	ldd (hl),a		; $1b3d
	ld (hl),d		; $1b3e
	scf			; $1b3f
	ret			; $1b40

;;
; @addr{1b41}
objectRemoveFromAButtonSensitiveObjectList:
	push de			; $1b41
	ld a,e			; $1b42
	and $c0			; $1b43
	ld e,a			; $1b45
	ld hl,wAButtonSensitiveObjectList		; $1b46
---
	ldi a,(hl)		; $1b49
	cp d			; $1b4a
	jr nz,@next		; $1b4b

	ld a,(hl)		; $1b4d
	and $c0			; $1b4e
	sub e			; $1b50
	jr nz,@next		; $1b51

	ldd (hl),a		; $1b53
	ldi (hl),a		; $1b54
@next:
	inc l			; $1b55
	ld a,l			; $1b56
	cp <wAButtonSensitiveObjectListEnd		; $1b57
	jr c,---		; $1b59

	pop de			; $1b5b
	ret			; $1b5c

;;
; Checks everything in wAButtonSensitiveObjectList (npcs mostly) and triggers them if the
; A button has been pressed near them.
;
; @param[out]	cflag	Set if Link just pressed A next to the object
; @addr{1b5d}
linkInteractWithAButtonSensitiveObjects:
	ld a,(wGameKeysJustPressed)		; $1b5d
	and BTN_A			; $1b60
	ret z			; $1b62

	; If he's in a shop, he can interact while holding something
	ld a,(wInShop)		; $1b63
	or a			; $1b66
	jr nz,+			; $1b67

	; If he's not in a shop, this should return if he's holding something
	ld a,(wLinkGrabState)		; $1b69
	or a			; $1b6c
	ret nz			; $1b6d
+
	push de			; $1b6e
	ld e,SpecialObject.direction		; $1b6f
	ld a,(de)		; $1b71
	ld hl,@positionOffsets		; $1b72
	rst_addDoubleIndex			; $1b75

	; Store y + offset into [hFF8D]
	ld e,SpecialObject.yh		; $1b76
	ld a,(de)		; $1b78
	add (hl)		; $1b79
	ldh (<hFF8D),a	; $1b7a

	; Store x + offset into [hFF8C]
	inc hl			; $1b7c
	ld e,SpecialObject.xh		; $1b7d
	ld a,(de)		; $1b7f
	add (hl)		; $1b80
	ldh (<hFF8C),a	; $1b81

	; Check all objects in the list
	ld de,wAButtonSensitiveObjectList		; $1b83
---
	; Get the object in hl
	ld a,(de)		; $1b86
	ld h,a			; $1b87
	inc e			; $1b88
	ld a,(de)		; $1b89
	ld l,a			; $1b8a
	or h			; $1b8b
	jr z,+			; $1b8c

	; Check if link is directly in front of the object
	push hl			; $1b8e
	ldh a,(<hFF8D)		; $1b8f
	ld b,a			; $1b91
	ldh a,(<hFF8C)		; $1b92
	ld c,a			; $1b94
	call objectHCheckContainsPoint		; $1b95
	pop hl			; $1b98
	jr nc,+			; $1b99

	; Link is next to the object; only trigger it if the "pressedAButton" variable is
	; not already set.
	bit 0,(hl)		; $1b9b
	jr z,@foundObject			; $1b9d
+
	inc e			; $1b9f
	ld a,e			; $1ba0
	cp <wAButtonSensitiveObjectListEnd			; $1ba1
	jr c,---		; $1ba3

	; No object found
	pop de			; $1ba5
	ret			; $1ba6

@foundObject:
	; Set the object's "pressedAButton" variable.
	set 0,(hl)		; $1ba7

	; For some reason, set Link's invincibility whenever triggering an object?
	ld hl,w1Link.invincibilityCounter		; $1ba9
	ld a,(hl)		; $1bac
	or a			; $1bad
	ld a,$fc		; $1bae
	jr z,++			; $1bb0

	bit 7,(hl)		; $1bb2
	jr nz,@negativeValue			; $1bb4

	; Link's invincibility already has a positive value ($01-$7f), meaning he's
	; flashing red from damage.
	; Make sure he stays invincible for at least 4 more frames?
	ld a,$04		; $1bb6
	cp (hl)			; $1bb8
	jr c,@doneWithInvincibility		; $1bb9
	jr ++			; $1bbb

	; Negative value for invincibility means he isn't flashing red.
	; Again, this makes sure he stays invincible for at least 4 more frames.
@negativeValue:
	cp (hl)			; $1bbd
	jr nc,@doneWithInvincibility		; $1bbe
++
	ld (hl),a		; $1bc0

@doneWithInvincibility:
	; Disable ring transformations for 8 frames? (He can't normally interact with
	; objects while transformed... so what's the point of this?)
	ld a,$08		; $1bc1
	ld (wDisableRingTransformations),a		; $1bc3

	; Disable pushing animation
	ld a,$80		; $1bc6
	ld (wForceLinkPushAnimation),a		; $1bc8

	ld hl,wLinkTurningDisabled		; $1bcb
	set 7,(hl)		; $1bce

	scf			; $1bd0
	pop de			; $1bd1
	ret			; $1bd2

@positionOffsets:
	.db $f6 $00 ; DIR_UP
	.db $00 $0a ; DIR_RIGHT
	.db $0a $00 ; DIR_DOWN
	.db $00 $f6 ; DIR_LEFT

;;
; @addr{1bdb}
objectCheckContainsPoint:
	ld h,d			; $1bdb
	ldh a,(<hActiveObjectType)	; $1bdc
	ld l,a			; $1bde
	jr objectHCheckContainsPoint			; $1bdf

;;
; @addr{1be1}
interactionCheckContainsPoint:
	ld h,d			; $1be1
	ld l,Interaction.start	; $1be2

;;
; Checks if an object contains a given point.
;
; @param	bc	Point to check
; @param	hl	The object to check (not object d as usual)
; @param[out]	cflag	Set if the point is contained in the object's collision box.
; @addr{1be4}
objectHCheckContainsPoint:
	ld a,l			; $1be4
	and $c0			; $1be5
	add Object.yh		; $1be7
	ld l,a			; $1be9
	ldi a,(hl)		; $1bea
	sub b			; $1beb
	jr nc,+			; $1bec
	cpl			; $1bee
	inc a			; $1bef
+
	ld b,a			; $1bf0

	inc l			; $1bf1
	ld a,(hl)		; $1bf2
	sub c			; $1bf3
	jr nc,+			; $1bf4
	cpl			; $1bf6
	inc a			; $1bf7
+
	ld c,a			; $1bf8

	ld a,l			; $1bf9
	add Object.collisionRadiusY-Object.xh			; $1bfa
	ld l,a			; $1bfc

	ld a,b			; $1bfd
	sub (hl)		; $1bfe
	ret nc			; $1bff
	inc l			; $1c00
	ld a,c			; $1c01
	sub (hl)		; $1c02
	ret			; $1c03

;;
; Check if 2 objects have collided.
;
; @param	bc	YX position of object 1
; @param	de	Address of object 1's collisionRadiusY variable
; @param	hl	Address of object 2's collisionRadiusY variable
; @param	ff8e	X position object 2
; @param	ff8f	Y position object 2
; @param[out]	cflag	Set if collision, unset if no collision
; @addr{1c04}
checkObjectsCollidedFromVariables:
	ld a,b			; $1c04
	ldh (<hFF8D),a	; $1c05
	ld a,c			; $1c07
	ldh (<hFF8C),a	; $1c08
	ld a,(de)		; $1c0a
	add (hl)		; $1c0b
	ld b,a			; $1c0c
	ldh a,(<hFF8F)	; $1c0d
	ld c,a			; $1c0f
	ldh a,(<hFF8D)	; $1c10
	sub c			; $1c12
	add b			; $1c13
	sla b			; $1c14
	cp b			; $1c16
	ret nc			; $1c17

	inc e			; $1c18
	inc hl			; $1c19
	ld a,(de)		; $1c1a
	add (hl)		; $1c1b
	ld b,a			; $1c1c
	ldh a,(<hFF8E)	; $1c1d
	ld c,a			; $1c1f
	ldh a,(<hFF8C)	; $1c20
	sub c			; $1c22
	add b			; $1c23
	sla b			; $1c24
	cp b			; $1c26
	ret			; $1c27

;;
; @addr{1c28}
objectCheckCollidedWithLink_notDeadAndNotGrabbing:
	ld a,(wLinkGrabState)		; $1c28
	and $be			; $1c2b
	ret nz			; $1c2d
;;
; @addr{1c2e}
objectCheckCollidedWithLink_notDead:
	ld a,(wLinkDeathTrigger)		; $1c2e
	or a			; $1c31
	ret nz			; $1c32
	jr objectCheckCollidedWithLink		; $1c33

;;
; @addr{1c35}
objectCheckCollidedWithLink_onGround:
	ld a,(wLinkInAir)		; $1c35
	or a			; $1c38
	ret nz			; $1c39
	ld a,(w1Link.zh)		; $1c3a
	or a			; $1c3d
	ret nz			; $1c3e
	jr objectCheckCollidedWithLink_notDead		; $1c3f

;;
; @param[out]	cflag	Set if the object is touching Link.
; @addr{1c41}
objectCheckCollidedWithLink:
	ldh a,(<hActiveObjectType)	; $1c41
	add Object.zh		; $1c43
	ld l,a			; $1c45
	ld h,d			; $1c46

;;
; @param	hl	Address of an object's zh variable
; @addr{1c47}
_checkCollidedWithLink:
	ld a,(wLinkObjectIndex)		; $1c47
	ld b,a			; $1c4a

	; Check if the object is within 7 z-units of link
	ld c,Object.zh		; $1c4b
	ld a,(bc)		; $1c4d
	sub (hl)		; $1c4e
	add $07			; $1c4f
	cp $0e			; $1c51
	ret nc			; $1c53

	; Set l to Object.xh
	dec l			; $1c54
	dec l			; $1c55
---
	ldd a,(hl)		; $1c56
	ldh (<hFF8E),a	; $1c57
	dec l			; $1c59
	ld a,(hl)		; $1c5a
	ldh (<hFF8F),a	; $1c5b
	ld a,l			; $1c5d
	add $1b			; $1c5e
	ld e,a			; $1c60
	ld a,(wLinkObjectIndex)		; $1c61
	ld h,a			; $1c64
	ld l,<w1Link.yh		; $1c65
	ld b,(hl)		; $1c67
	ld l,<w1Link.xh		; $1c68
	ld c,(hl)		; $1c6a
	ld l,<w1Link.collisionRadiusY	; $1c6b
	jr checkObjectsCollidedFromVariables		; $1c6d

;;
; @param[out]	cflag	Set if the object is touching Link.
; @addr{1c6f}
objectCheckCollidedWithLink_ignoreZ:
	ldh a,(<hActiveObjectType)	; $1c6f
	add Object.xh		; $1c71
	ld l,a			; $1c73
	ld h,d			; $1c74
	jr ---			; $1c75

;;
; Unused?
;
; @addr{1c77}
hObjectCheckCollidedWithLink:
	push de			; $1c77
	ld d,h			; $1c78
	ld a,l			; $1c79
	and $c0			; $1c7a
	add Object.zh		; $1c7c
	ld l,a			; $1c7e
	call _checkCollidedWithLink	; $1c7f
	pop de			; $1c82
	ret			; $1c83

;;
; Unused?
;
; @addr{1c84}
func_1c84:
	ld a,(w1ReservedItemC.enabled)		; $1c84
	or a			; $1c87
	ret nz			; $1c88

;;
; @param[out]	cflag	Set on collision
; @addr{1c89}
objectHCheckCollisionWithLink:
	push de			; $1c89
	push hl			; $1c8a
	call _getLinkPositionPlusDirectionOffset		; $1c8b
	pop hl			; $1c8e
	ld a,l			; $1c8f
	and $c0			; $1c90
	call _checkCollisionWithHAndD		; $1c92
	pop de			; $1c95
	ret			; $1c96

;;
; Checks whether link is close enough to a grabbable object to grab it.
; If so, this also sets a few of the object's variables.
; This function is only called after the A button is pressed.
;
; @param	d	Link object?
; @param[out]	cflag	Set on collision
; @addr{1c97}
checkGrabbableObjects:
	; Check that something isn't already being carried around
	ld a,(w1ReservedItemC.enabled)		; $1c97
	or a			; $1c9a
	ret nz			; $1c9b

	push de			; $1c9c

	; This call sets up hFF8E and hFF8F for collision function calls
	call _getLinkPositionPlusDirectionOffset		; $1c9d

	ld hl,wGrabbableObjectBuffer		; $1ca0

@objectLoop:
	inc l			; $1ca3
	bit 7,(hl)		; $1ca4
	jr z,@nextObject	; $1ca6

	push hl			; $1ca8
	dec l			; $1ca9
	ldi a,(hl)		; $1caa
	ld h,(hl)		; $1cab
	call _checkCollisionWithHAndD		; $1cac
	jr c,@collision		; $1caf
	pop hl			; $1cb1
@nextObject:
	inc l			; $1cb2
	ld a,l			; $1cb3
	cp <wGrabbableObjectBufferEnd			; $1cb4
	jr c,@objectLoop	; $1cb6

	pop de			; $1cb8
	xor a			; $1cb9
	ret			; $1cba

	; At this point, hl = the shop object that is grabbed
@collision:
	pop af			; $1cbb

	ld e,Item.relatedObj2+1		; $1cbc
	ld a,h			; $1cbe
	ld (de),a		; $1cbf
	dec e			; $1cc0
	ld a,l			; $1cc1
	and $c0			; $1cc2
	ld (de),a		; $1cc4

	; l = Object.enabled
	ld l,a			; $1cc5
	set 1,(hl)		; $1cc6

	; l = Object.state
	add Object.state-Object.enabled			; $1cc8
	ld l,a			; $1cca
	ld (hl),ENEMYSTATE_GRABBED ; TODO: Better name? it's not just for enemies

	; l = Object.state2
	inc l			; $1ccd
	ld (hl),$00		; $1cce

	pop de			; $1cd0
	scf			; $1cd1
	ret			; $1cd2

;;
; Gets link's position plus 5 pixels in the direction he's facing.
;
; @param[out]	hFF8E	Link X
; @param[out]	hFF8F	Link Y
; @param[out]	hFF91	Link Z (subtracted by 3)
; @addr{1cd3}
_getLinkPositionPlusDirectionOffset:
	ld a,(w1Link.direction)		; $1cd3
	ld hl,@positionOffsets		; $1cd6
	rst_addDoubleIndex			; $1cd9
	ld de,w1Link.yh		; $1cda
	ld a,(de)		; $1cdd
	add (hl)		; $1cde
	ldh (<hFF8F),a	; $1cdf
	inc hl			; $1ce1
	ld e,<w1Link.xh		; $1ce2
	ld a,(de)		; $1ce4
	add (hl)		; $1ce5
	ldh (<hFF8E),a	; $1ce6
	ld e,<w1Link.zh		; $1ce8
	ld a,(de)		; $1cea
	sub $03			; $1ceb
	ldh (<hFF91),a	; $1ced
	ret			; $1cef

; @addr{1cf0}
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
; @addr{1cf8}
_checkCollisionWithHAndD:
	add Object.var2a			; $1cf8
	ld l,a			; $1cfa
	bit 7,(hl)		; $1cfb
	ret nz			; $1cfd

	; Check Z position within 7 pixels
	sub Object.var2a-Object.zh	; $1cfe
	ld l,a			; $1d00
	ldh a,(<hFF91)	; $1d01
	sub (hl)		; $1d03
	add $07			; $1d04
	cp $0e			; $1d06
	ret nc			; $1d08

	; Get Object.yh / Object.xh into bc
	dec l			; $1d09
	dec l			; $1d0a
	ldd a,(hl)		; $1d0b
	dec l			; $1d0c
	ld b,(hl)		; $1d0d
	ld c,a			; $1d0e

	ld a,l			; $1d0f
	add Object.collisionRadiusY-Object.yh		; $1d10
	ld l,a			; $1d12
	ld e,Item.collisionRadiusY		; $1d13
	jp checkObjectsCollidedFromVariables		; $1d15

;;
; Checks link's ID is 0, and checks various other things impeding game control
; (wLinkDeathTrigger, wLinkInAir, and link being in a spinner?)
;
; @param[out]	cflag	Set if any checks fail.
; @addr{1d18}
checkLinkID0AndControlNormal:
	ld a,(w1Link.id)		; $1d18
	or a			; $1d1b
.ifdef ROM_AGES
	jr z,+++		; $1d1c
.else
	jr z,checkLinkVulnerableAndIDZero		; $1d1c
.endif
	xor a			; $1d1e
	ret			; $1d1f

;;
; @addr{1d20}
checkLinkVulnerableAndIDZero:

.ifdef ROM_AGES
	ld a,(w1Link.id)		; $1d20
	or a			; $1d23
	jr z,checkLinkVulnerable			; $1d24
	xor a			; $1d26
	ret			; $1d27
.endif

;;
; Check if link should respond to collisions, perhaps other things?
;
; @param[out]	cflag	Set if link is vulnerable
; @addr{1d28}
checkLinkVulnerable:
	; Check var2a, invincibilityCounter, knockbackCounter
	ld hl,w1Link.var2a		; $1d28
	ldi a,(hl)		; $1d2b
	or (hl)			; $1d2c
	ld l,<w1Link.knockbackCounter		; $1d2d
	or (hl)			; $1d2f
	jr nz,checkLinkCollisionsEnabled@noCarry		; $1d30

;;
; Check if link should respond to collisions, perhaps other things?
;
; @param[out]	cflag
; @addr{1d32}
checkLinkCollisionsEnabled:
	ld a,(w1Link.collisionType)		; $1d32
	rlca			; $1d35
	jr nc,@noCarry		; $1d36

.ifdef ROM_SEASONS
	ld a,(wLinkDeathTrigger)		; $1d38
	or a			; $1d3b
	jr nz,@noCarry		; $1d3c
.endif

	ld a,(wDisableLinkCollisionsAndMenu)		; $1d38
	or a			; $1d3b
	jr nz,@noCarry		; $1d3c

	ld a,(wMenuDisabled)		; $1d3e
	or a			; $1d41
	jr nz,@noCarry		; $1d42

.ifdef ROM_AGES
+++
	ld a,(wLinkDeathTrigger)		; $1d44
	or a			; $1d47
	jr nz,@noCarry		; $1d48
.endif

	; Check if in a spinner
	ld a,(wcc95)		; $1d4a
	rlca			; $1d4d
	jr c,@noCarry		; $1d4e

	ld a,(wLinkInAir)		; $1d50
	rlca			; $1d53
	jr c,@noCarry		; $1d54

	scf			; $1d56
	ret			; $1d57
@noCarry:
	xor a			; $1d58
	ret			; $1d59

;;
; Check if objects d and h have collided.
;
; @param[in]	d	Object 1
; @param[in]	h	Object 2
; @param[out]	cflag	Set if collision, unset if no collision
; @addr{1d5a}
checkObjectsCollided:
	; Everything here is just setting up variables for the jump at the end
	ld a,l			; $1d5a
	and $c0			; $1d5b
	ld l,a			; $1d5d
	push hl			; $1d5e

	ld h,d			; $1d5f
	ldh a,(<hActiveObjectType)	; $1d60
	add Object.yh		; $1d62
	ld l,a			; $1d64
	ldi a,(hl)		; $1d65
	ldh (<hFF8F),a	; $1d66
	inc l			; $1d68
	ld a,(hl)		; $1d69
	ldh (<hFF8E),a	; $1d6a

	ld a,l			; $1d6c
	add Object.collisionRadiusY - Object.xh		; $1d6d
	ld e,a			; $1d6f
	pop hl			; $1d70
	ld a,l			; $1d71
	add Object.yh		; $1d72
	ld l,a			; $1d74
	ld b,(hl)		; $1d75
	inc l			; $1d76
	inc l			; $1d77
	ld c,(hl)		; $1d78
	add Object.collisionRadiusY - Object.yh			; $1d79
	ld l,a			; $1d7b
	jp checkObjectsCollidedFromVariables		; $1d7c

;;
; Prevents Object 2 (usually Link) from passing through Object 1 (usually an npc).
;
; If Object 2 is Link, consider using "objectPreventLinkFromPassing" instead.
;
; @param	d	Object 1 (Npc, minecart)
; @param	h	Object 2 (Link)
; @param[out]	cflag	Set if there's a collision
; @addr{1d7f}
preventObjectHFromPassingObjectD:
	ld a,l			; $1d7f
	and $c0			; $1d80
	ldh (<hFF8B),a	; $1d82

	call checkObjectsCollided		; $1d84
	ret nc			; $1d87
	call @checkCollisionDirection		; $1d88
	jr nc,+			; $1d8b

	; Vertical collision: get the sum of both objects' collisionRadiusY in c
	ld b,Object.yh		; $1d8d
	ldh a,(<hFF8D)	; $1d8f
	ld c,a			; $1d91
	jr ++			; $1d92
+
	; Horizontal collision: get the sum of both objects' collisionRadiusX in c
	ld b,Object.xh		; $1d94
	ldh a,(<hFF8C)	; $1d96
	ld c,a			; $1d98
	jr ++			; $1d99
++
	; Check which direction the objects are relative to each other...
	call @setBothObjectVariables		; $1d9b
	ld a,(de)		; $1d9e
	sub (hl)		; $1d9f
	ld a,c			; $1da0
	jr c,+			; $1da1

	cpl			; $1da3
	inc a			; $1da4
+
	; Now lock object h's position to prevent it from moving any further
	ld b,a			; $1da5
	ld a,(de)		; $1da6
	add b			; $1da7
	ld (hl),a		; $1da8
	scf			; $1da9
	ret			; $1daa

;;
; Checks the direction of a collision. (Doesn't check for the collision itself)
;
; @param[out]	hFF8C	Sum of both objects' collisionRadiusX variables
; @param[out]	hFF8D	Sum of both objects' collisionRadiusY variables
; @param[out]	cflag	Set if the collision was predominantly from a vertical direction
; @addr{1dab}
@checkCollisionDirection:
	ld b,Object.yh		; $1dab
	call @setBothObjectVariables		; $1dad
	ld a,(de)		; $1db0
	sub (hl)		; $1db1
	jr nc,+			; $1db2

	cpl			; $1db4
	inc a			; $1db5
+
	; c will hold the difference in y positions
	ld c,a			; $1db6

	ld b,Object.collisionRadiusY		; $1db7
	call @setBothObjectVariables		; $1db9
	ld a,(de)		; $1dbc
	add (hl)		; $1dbd
	ldh (<hFF8D),a	; $1dbe

	; hFF8F will be >0 if the objects collided vertically
	sub c			; $1dc0
	ldh (<hFF8F),a	; $1dc1

	ld b,Object.xh		; $1dc3
	call @setBothObjectVariables		; $1dc5
	ld a,(de)		; $1dc8
	sub (hl)		; $1dc9
	jr nc,+			; $1dca

	cpl			; $1dcc
	inc a			; $1dcd
+
	; c will hold the difference in x positions
	ld c,a			; $1dce

	ld b,Object.collisionRadiusX		; $1dcf
	call @setBothObjectVariables		; $1dd1
	ld a,(de)		; $1dd4
	add (hl)		; $1dd5
	ldh (<hFF8C),a	; $1dd6
	sub c			; $1dd8

	; Compare horizontal component of collision to vertical component.
	; Will set the carry flag if the collision occurred from a vertical direction.
	ld b,a			; $1dd9
	ldh a,(<hFF8F)	; $1dda
	cp b			; $1ddc
	ret			; $1ddd

;;
; Makes both objects de and hl point to a particular variable.
;
; @param	b	The variable to make both objects point to
; @addr{1dde}
@setBothObjectVariables:
	ldh a,(<hActiveObjectType)	; $1dde
	or b			; $1de0
	ld e,a			; $1de1
	ldh a,(<hFF8B)	; $1de2
	or b			; $1de4
	ld l,a			; $1de5
	ret			; $1de6

;;
; @addr{1de7}
checkEnemyAndPartCollisionsIfTextInactive:
	call retIfTextIsActive		; $1de7
	ldh a,(<hRomBank)	; $1dea
	push af			; $1dec
	callfrombank0 bank7.checkEnemyAndPartCollisions		; $1ded
	pop af			; $1df7
	setrombank		; $1df8
	ret			; $1dfd

;;
; Searches a table at hl where each entry is a pointer for a group.
; This pointer points to data formatted as follows:
; 	room id (byte), value (byte)
; If it finds room id A in the list, it sets the carry flag and returns the value.
; Otherwise, it returns with the carry flag unset.
;
; @param	a	Room index
; @param	hl	Table address
; @addr{1dfe}
findRoomSpecificData:
	ld e,a			; $1dfe
	ld a,(wActiveGroup)		; $1dff
	rst_addDoubleIndex			; $1e02
	ldi a,(hl)		; $1e03
	ld h,(hl)		; $1e04
	ld l,a			; $1e05
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
; @addr{1e06}
lookupKey:
	ldi a,(hl)		; $1e06
	or a			; $1e07
	ret z			; $1e08
	cp e			; $1e09
	ldi a,(hl)		; $1e0a
	jr nz, lookupKey
	scf			; $1e0d
	ret			; $1e0e

;;
; Unused?
;
; @param a
; @addr{1e0f}
findByteInGroupTable:
	ld e,a			; $1e0f
	ld a,(wActiveGroup)		; $1e10
	rst_addDoubleIndex			; $1e13
	ldi a,(hl)		; $1e14
	ld h,(hl)		; $1e15
	ld l,a			; $1e16

;;
; Search through zero-terminated list of bytes at hl, return when one equals e.
;
; @param	e	Value to match
; @param[in]	hl	Start address to search
; @param[out]	cflag	Set if match found
; @addr{1e17}
findByteAtHl:
	ldi a,(hl)		; $1e17
	or a			; $1e18
	ret z			; $1e19

	cp e			; $1e1a
	jr nz,findByteAtHl		; $1e1b

	scf			; $1e1d
	ret			; $1e1e

;;
; @param	a	Tile to lookup
; @param	hl	Table
; @param[out]	cflag	Set on success.
; @addr{1e1f}
lookupCollisionTable:
	ld e,a			; $1e1f

;;
; @param	e	Tile to lookup
; @param	hl	Table
; @param[out]	cflag	Set on success.
; @addr{1e20}
lookupCollisionTable_paramE:
	ld a,(wActiveCollisions)		; $1e20
	rst_addDoubleIndex			; $1e23
	ldi a,(hl)		; $1e24
	ld h,(hl)		; $1e25
	ld l,a			; $1e26
	jr lookupKey		; $1e27

;;
; @param	a	Key
; @param[out]	cflag	Set if match found
; @addr{1e29}
findByteInCollisionTable:
	ld e,a			; $1e29

;;
; @param e
; @addr{1e2a}
findByteInCollisionTable_paramE:
	ld a,(wActiveCollisions)		; $1e2a
	rst_addDoubleIndex			; $1e2d
	ldi a,(hl)		; $1e2e
	ld h,(hl)		; $1e2f
	ld l,a			; $1e30
	jr findByteAtHl		; $1e31

;;
; @addr{1e33}
objectSetVisiblec0:
	ldh a,(<hActiveObjectType)	; $1e33
	add Object.visible			; $1e35
	ld e,a			; $1e37
	ld a,$c0		; $1e38
	ld (de),a		; $1e3a
	ret			; $1e3b
;;
; @addr{1e3c}
objectSetVisiblec1:
	ldh a,(<hActiveObjectType)	; $1e3c
	add Object.visible			; $1e3e
	ld e,a			; $1e40
	ld a,$c1		; $1e41
	ld (de),a		; $1e43
	ret			; $1e44
;;
; @addr{1e45}
objectSetVisiblec2:
	ldh a,(<hActiveObjectType)	; $1e45
	add Object.visible			; $1e47
	ld e,a			; $1e49
	ld a,$c2		; $1e4a
	ld (de),a		; $1e4c
	ret			; $1e4d
;;
; @addr{1e4e}
objectSetVisiblec3:
	ldh a,(<hActiveObjectType)	; $1e4e
	add Object.visible			; $1e50
	ld e,a			; $1e52
	ld a,$c3		; $1e53
	ld (de),a		; $1e55
	ret			; $1e56
;;
; @addr{1e57}
objectSetVisible80:
	ldh a,(<hActiveObjectType)	; $1e57
	add Object.visible			; $1e59
	ld e,a			; $1e5b
	ld a,$80		; $1e5c
	ld (de),a		; $1e5e
	ret			; $1e5f
;;
; @addr{1e60}
objectSetVisible81:
	ldh a,(<hActiveObjectType)	; $1e60
	add Object.visible			; $1e62
	ld e,a			; $1e64
	ld a,$81		; $1e65
	ld (de),a		; $1e67
	ret			; $1e68
;;
; @addr{1e69}
objectSetVisible82:
	ldh a,(<hActiveObjectType)	; $1e69
	add Object.visible			; $1e6b
	ld e,a			; $1e6d
	ld a,$82		; $1e6e
	ld (de),a		; $1e70
	ret			; $1e71
;;
; @addr{1e72}
objectSetVisible83:
	ldh a,(<hActiveObjectType)	; $1e72
	add Object.visible			; $1e74
	ld e,a			; $1e76
	ld a,$83		; $1e77
	ld (de),a		; $1e79
	ret			; $1e7a

;;
; @addr{1e7b}
objectSetInvisible:
	ldh a,(<hActiveObjectType)	; $1e7b
	add Object.visible			; $1e7d
	ld l,a			; $1e7f
	ld h,d			; $1e80
	res 7,(hl)		; $1e81
	ret			; $1e83
;;
; @addr{1e84}
objectSetVisible:
	ldh a,(<hActiveObjectType)	; $1e84
	add Object.visible			; $1e86
	ld l,a			; $1e88
	ld h,d			; $1e89
	set 7,(hl)		; $1e8a
	ret			; $1e8c

;;
; @addr{1e8d}
objectSetReservedBit1:
	ldh a,(<hActiveObjectType)	; $1e8d
	ld l,a			; $1e8f
	ld h,d			; $1e90
	set 1,(hl)		; $1e91
	ret			; $1e93

;;
; @addr{1e94}
objectGetAngleTowardEnemyTarget:
	ldh a,(<hEnemyTargetY)	; $1e94
	ld b,a			; $1e96
	ldh a,(<hEnemyTargetX)	; $1e97
	ld c,a			; $1e99
	jr objectGetRelativeAngle		; $1e9a

;;
; @addr{1e9c}
objectGetAngleTowardLink:
	ld a,(w1Link.yh)		; $1e9c
	ld b,a			; $1e9f
	ld a,(w1Link.xh)		; $1ea0
	ld c,a			; $1ea3
;;
; Get the angle needed to move an object toward a position.
;
; @param	bc	YX position to get the direction toward
; @param	d	Current object
; @param[out]	a	An angle value pointing towards bc
; @addr{1ea4}
objectGetRelativeAngle:

; Internal variables:
;  hFF8E: X
;  hFF8F: Y

	ldh a,(<hActiveObjectType)	; $1ea4
	or Object.yh			; $1ea6
	ld e,a			; $1ea8

;;
; @param	bc	YX position to get the direction toward
; @param	de	Address of an object's Y position
; @addr{1ea9}
getRelativeAngle:
	ld a,(de)		; $1ea9
	ldh (<hFF8F),a	; $1eaa
	inc e			; $1eac
	inc e			; $1ead
	ld a,(de)		; $1eae
	ldh (<hFF8E),a	; $1eaf
;;
; @param	bc	YX position to get the direction toward
; @param	d	Current object
; @param	hFF8E	X position of object
; @param	hFF8F	Y position of object
; @addr{1eb1}
objectGetRelativeAngleWithTempVars:
	ld e,$08		; $1eb1
	ld a,b			; $1eb3
	add e			; $1eb4
	ld b,a			; $1eb5
	ld a,c			; $1eb6
	add e			; $1eb7
	ld c,a			; $1eb8
	ld e,$00		; $1eb9
	ldh a,(<hFF8F)	; $1ebb
	add $08			; $1ebd
	sub b			; $1ebf
	jr nc,+			; $1ec0

	cpl			; $1ec2
	inc a			; $1ec3
	ld e,$04		; $1ec4
+
	ld h,a			; $1ec6
	ldh a,(<hFF8E)	; $1ec7
	add $08			; $1ec9
	sub c			; $1ecb
	jr nc,+			; $1ecc

	cpl			; $1ece
	inc a			; $1ecf
	inc e			; $1ed0
	inc e			; $1ed1
+
	cp h			; $1ed2
	jr nc,+			; $1ed3

	inc e			; $1ed5
	ld l,a			; $1ed6
	ld a,h			; $1ed7
	ld h,l			; $1ed8
+
	ld c,e			; $1ed9
	ld b,$00		; $1eda
	srl a			; $1edc
	srl a			; $1ede
	srl a			; $1ee0
	add a			; $1ee2
	ld l,a			; $1ee3
	cp h			; $1ee4
	jr nc,++		; $1ee5

	inc b			; $1ee7
	add l			; $1ee8
	cp h			; $1ee9
	jr nc,++		; $1eea

	inc b			; $1eec
	add l			; $1eed
	cp h			; $1eee
	jr nc,++		; $1eef

	inc b			; $1ef1
	add l			; $1ef2
	cp h			; $1ef3
	jr nc,++		; $1ef4
	inc b			; $1ef6
++
	ld a,c			; $1ef7
	add a			; $1ef8
	add a			; $1ef9
	add a			; $1efa
	add b			; $1efb
	ld c,a			; $1efc
	ld b,$00		; $1efd
	ld hl,pushDirectionData	; $1eff
	add hl,bc		; $1f02
	ld a,(hl)		; $1f03
	ret			; $1f04

; @addr{1f05}
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
; @addr{1f45}
objectUpdateSpeedZ:
	ld c,a			; $1f45
;;
; @param	c	Z Acceleration (gravity)
; @param[out]	hl	Object.speedZ variable
; @param[out]	zflag	Set if resulting position is below or on the ground
; @addr{1f46}
objectUpdateSpeedZ_paramC:
	ldh a,(<hActiveObjectType)	; $1f46
	add Object.z			; $1f48
	ld e,a			; $1f4a
	add Object.speedZ - Object.z			; $1f4b
	ld l,a			; $1f4d
	ld h,d			; $1f4e
	call add16BitRefs		; $1f4f
	bit 7,a			; $1f52
	jr z,@belowGround

; Above ground
	dec l			; $1f56
	ld a,c			; $1f57
	add (hl)		; $1f58
	ldi (hl),a		; $1f59
	ld a,$00		; $1f5a
	adc (hl)		; $1f5c
	ld (hl),a		; $1f5d
	or d			; $1f5e
	ret			; $1f5f

; Can't be below ground, set z position to 0
@belowGround:
	xor a			; $1f60
	ld (de),a		; $1f61
	dec e			; $1f62
	ld (de),a		; $1f63
	xor a			; $1f64
	ret			; $1f65

;;
; Updates an object's speedZ in a way that works with sidescrolling areas. This assumes
; that the object's width has a particular value (8 pixels?), but its height can be
; specified with the 'b' parameter.
;
; @param	a	Gravity (amount to add to Object.speedZ)
; @param[out]	cflag	Set if the object has landed.
; @param[out]	hl	Object.speedZ+1
; @addr{1f66}
objectUpdateSpeedZ_sidescroll:
	ld b,$06		; $1f66

;;
; @param	a	Gravity (amount to add to Object.speedZ)
; @param	b	Y offset for collision check
; @param[out]	cflag	Set if the object has landed.
; @param[out]	hl	Object.speedZ+1
; @addr{1f68}
objectUpdateSpeedZ_sidescroll_givenYOffset:
	ldh (<hFF8B),a	; $1f68
	ldh a,(<hActiveObjectType)	; $1f6a
	add Object.speedZ+1			; $1f6c
	ld l,a			; $1f6e
	ld h,d			; $1f6f
	bit 7,(hl)		; $1f70
	jr nz,@notLanded	; $1f72

; speedZ is positive; return with carry flag set if the object collides with a tile.

	; Set b to object's y position (plus offset)
	add Object.yh-(Object.speedZ+1)			; $1f74
	ld l,a			; $1f76
	ldi a,(hl)		; $1f77
	add b			; $1f78
	ld b,a			; $1f79

	; hl = Object.xh
	inc l			; $1f7a
	ld a,(hl)		; $1f7b

	; Check left side of object (assumes 8 pixel width?)
	sub $04			; $1f7c
	ld c,a			; $1f7e
	call checkTileCollisionAt_allowHoles		; $1f7f
	ret c			; $1f82

	; Check right side of object (assumes 8 pixel width?)
	ld a,c			; $1f83
	add $07			; $1f84
	ld c,a			; $1f86
	call checkTileCollisionAt_allowHoles		; $1f87
	ret c			; $1f8a

@notLanded:
	; Add speedZ to y position
	ldh a,(<hActiveObjectType)	; $1f8b
	add Object.y			; $1f8d
	ld e,a			; $1f8f
	add Object.speedZ-Object.y			; $1f90
	ld l,a			; $1f92
	ld h,d			; $1f93
	call add16BitRefs		; $1f94

	; Apply gravity (increase speedZ by amount passed to function)
	dec l			; $1f97
	ldh a,(<hFF8B)	; $1f98
	add (hl)		; $1f9a
	ldi (hl),a		; $1f9b
	ld a,$00		; $1f9c
	adc (hl)		; $1f9e
	ld (hl),a		; $1f9f

	; Clear carry flag
	or d			; $1fa0
	ret			; $1fa1

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
; @addr{1fa2}
objectCheckLinkWithinDistance:
	ldh a,(<hActiveObjectType)	; $1fa2

	; Get the difference between the object's and link's y positions
	add Object.yh			; $1fa4
	ld l,a			; $1fa6
	ld h,d			; $1fa7
	ld e,$04		; $1fa8
	ld a,(w1Link.yh)		; $1faa
	sub (hl)		; $1fad
	jr nc,+			; $1fae
	cpl			; $1fb0
	inc a			; $1fb1
	ld e,$00		; $1fb2
+
	ld b,a			; $1fb4
	ld a,c			; $1fb5
	sub b			; $1fb6
	ccf			; $1fb7
	ret nc			; $1fb8

	; Get the difference between the object's and link's x positions
	ld c,a			; $1fb9
	inc l			; $1fba
	inc l			; $1fbb
	set 5,e			; $1fbc
	ld a,(w1Link.xh)		; $1fbe
	sub (hl)		; $1fc1
	jr nc,+			; $1fc2

	cpl			; $1fc4
	inc a			; $1fc5
	set 6,e			; $1fc6
+
	cp c			; $1fc8
	ret nc			; $1fc9
	cp b			; $1fca
	jr c,+			; $1fcb
	swap e			; $1fcd
+
	ld a,e			; $1fcf
	and $06			; $1fd0
	scf			; $1fd2
	ret			; $1fd3

;;
; Increments or decrements an object's angle by one unit toward the given value.
;
; @param	a	Angle value to move toward
; @addr{1fd4}
objectNudgeAngleTowards:
	ld c,a			; $1fd4
	ldh a,(<hActiveObjectType)	; $1fd5
	add Object.angle			; $1fd7
	ld e,a			; $1fd9
	ld a,(de)		; $1fda
	ld b,a			; $1fdb

	sub c			; $1fdc
	jr z,++			; $1fdd

	and $1f			; $1fdf
	cp $10			; $1fe1
	jr nc,+			; $1fe3

	dec b			; $1fe5
	jr ++			; $1fe6
+
	inc b			; $1fe8
++
	ld a,b			; $1fe9
	and $1f			; $1fea
	ld (de),a		; $1fec
	ret			; $1fed

;;
; Checks if link is centered within 'b' pixels compared to another object (horizontally or
; vertically).
;
; @param	b	Distance threshold
; @param	d	Object to compare with
; @param[out]	cflag	Set if link is centered within the threshold given.
; @addr{1fee}
objectCheckCenteredWithLink:
	ld c,b			; $1fee
	sla c			; $1fef
	inc c			; $1ff1

	; Check Y
	ld h,d			; $1ff2
	ldh a,(<hActiveObjectType)	; $1ff3
	add Object.yh			; $1ff5
	ld l,a			; $1ff7
	ld a,(w1Link.yh)		; $1ff8
	sub (hl)		; $1ffb
	add b			; $1ffc
	cp c			; $1ffd
	ret c			; $1ffe

	; Check X
	inc l			; $1fff
	inc l			; $2000
	ld a,(w1Link.xh)		; $2001
	sub (hl)		; $2004
	add b			; $2005
	cp c			; $2006
	ret			; $2007

;;
; This function reads Object.speed differently than most places (ie. objectApplySpeed). It
; adds variables $10-$11 to Object.y as a 16-bit value, and $12-$13 to Object.x.
;
; @addr{2008}
objectApplyComponentSpeed:
	ldh a,(<hActiveObjectType)	; $2008
	add Object.y			; $200a
	ld l,a			; $200c
	add Object.speed-Object.y			; $200d
	ld e,a			; $200f
	ld h,d			; $2010
	call @addSpeedComponent		; $2011
	inc e			; $2014

;;
; @addr{2015}
@addSpeedComponent:
	ld a,(de)		; $2015
	add (hl)		; $2016
	ldi (hl),a		; $2017
	inc e			; $2018
	ld a,(de)		; $2019
	adc (hl)		; $201a
	ldi (hl),a		; $201b
	ret			; $201c

;;
; Uses the object's speed and angle variables to update its position.
;
; @param[out]	a	New value of object.xh
; @addr{201d}
objectApplySpeed:
	ld h,d			; $201d
	ldh a,(<hActiveObjectType)	; $201e
	add Object.angle		; $2020
	ld e,a			; $2022
	ld l,a			; $2023
	ld c,(hl)		; $2024
	add Object.speed-Object.angle		; $2025
	ld l,a			; $2027
	ld b,(hl)		; $2028

;;
; @param	b	speed value
; @param	c	angle value
; @param	de	Address of an object's angle variable (will only read/write the
;			Y and X values which follow that, not the angle itself).
; @param[out]	a	New value of object.xh
; @addr{2029}
objectApplyGivenSpeed:
	call getPositionOffsetForVelocity		; $2029
	ret z			; $202c

	; Add to Object.y
	inc e			; $202d
	ld a,(de)		; $202e
	add (hl)		; $202f
	ld (de),a		; $2030
	inc e			; $2031
	inc l			; $2032
	ld a,(de)		; $2033
	adc (hl)		; $2034
	ld (de),a		; $2035

	; Add to Object.x
	inc e			; $2036
	inc l			; $2037
	ld a,(de)		; $2038
	add (hl)		; $2039
	ld (de),a		; $203a
	inc e			; $203b
	inc l			; $203c
	ld a,(de)		; $203d
	adc (hl)		; $203e
	ld (de),a		; $203f
	ret			; $2040

;;
; Takes a speed and an angle, and calculates the values to add to an object's y and
; x positions.
;
; @param	b	speed (should be a multiple of 5)
; @param	c	angle (value from $00-$1f)
; @param[out]	hl	Pointer to 4 bytes of data to be added to Y and X positions.
;			It always points to wTmpcec0.
; @param[out]	zflag	Set if the speed / angle was invalid (or speed is zero)
; @addr{2041}
getPositionOffsetForVelocity:
	bit 7,c			; $2041
	jr nz,@invalid		; $2043

	swap b			; $2045
	jr z,@invalid		; $2047

	ld a,b			; $2049
	ld hl,objectSpeedTable-$50		; $204a
	sla c			; $204d
	ld b,$00		; $204f
	add hl,bc		; $2051

	ld b,a			; $2052
	and $f0			; $2053
	ld c,a			; $2055
	ld a,b			; $2056
	and $0f			; $2057
	ld b,a			; $2059
	add hl,bc		; $205a
	ldh a,(<hRomBank)	; $205b
	push af			; $205d
	ld a,:objectSpeedTable		; $205e
	setrombank		; $2060

	; Get Y values
	ld bc,wTmpcec0		; $2065
	ldi a,(hl)		; $2068
	ld (bc),a		; $2069
	inc c			; $206a
	ldi a,(hl)		; $206b
	ld (bc),a		; $206c

	; Get X values
	inc c			; $206d
	ld a,$0e		; $206e
	rst_addAToHl			; $2070

	ldi a,(hl)		; $2071
	ld (bc),a		; $2072
	inc c			; $2073
	ldi a,(hl)		; $2074
	ld (bc),a		; $2075

	pop af			; $2076
	setrombank		; $2077

	ld hl,wTmpcec0		; $207c
	or h			; $207f
	ret			; $2080

@invalid:
	ld hl,wTmpcec0+3		; $2081
	xor a			; $2084
	ldd (hl),a		; $2085
	ldd (hl),a		; $2086
	ldd (hl),a		; $2087
	ld (hl),a		; $2088
	ret			; $2089

;;
; @param[out]	bc	Object's position
; @addr{208a}
objectGetPosition:
	ldh a,(<hActiveObjectType)	; $208a
	add Object.yh		; $208c
	ld e,a			; $208e
	ld a,(de)		; $208f
	ld b,a			; $2090
	inc e			; $2091
	inc e			; $2092
	ld a,(de)		; $2093
	ld c,a			; $2094
	ret			; $2095

;;
; @param[out]	a	Object's position (short form)
; @addr{2096}
objectGetShortPosition:
	ldh a,(<hActiveObjectType)	; $2096
	add Object.yh		; $2098
	ld e,a			; $209a
;;
; @addr{209b}
getShortPositionFromDE:
	ld a,(de)		; $209b
--
	and $f0			; $209c
	ld b,a			; $209e
	inc e			; $209f
	inc e			; $20a0
	ld a,(de)		; $20a1
	swap a			; $20a2
	and $0f			; $20a4
	or b			; $20a6
	ret			; $20a7

;;
; @param	a	Value to add to the object's Y position before calculating
; @param[out]	a	Object's position (short form)
; @addr{20a8}
objectGetShortPosition_withYOffset:
	ld b,a			; $20a8
	ldh a,(<hActiveObjectType)	; $20a9
	add Object.yh			; $20ab
	ld e,a			; $20ad
	ld a,(de)		; $20ae
	add b			; $20af
	jr --			; $20b0

;;
; Writes $0f to the collision value of the tile the object is standing on.
;
; @addr{20b2}
objectMakeTileSolid:
	call objectGetTileCollisions		; $20b2
	ld (hl),$0f		; $20b5
	ret			; $20b7

;;
; @param	a	Short-form position
; @param	hl	Address to write to (usually an Object.yh)
; @addr{20b8}
setShortPosition:
	ld c,a			; $20b8
;;
; @param	c	Short-form position
; @param	hl	Address to write to (usually an Object.yh)
; @addr{20b9}
setShortPosition_paramC:
	push bc			; $20b9
	call convertShortToLongPosition_paramC		; $20ba
	ld (hl),b		; $20bd
	inc l			; $20be
	inc l			; $20bf
	ld (hl),c		; $20c0
	pop bc			; $20c1
	ret			; $20c2

;;
; Set an object's position.
;
; @param	c	Short-form position
; @addr{20c3}
objectSetShortPosition:
	ld h,d			; $20c3
	ldh a,(<hActiveObjectType)	; $20c4
	add Object.yh		; $20c6
	ld l,a			; $20c8
	jr setShortPosition_paramC		; $20c9

;;
; @param	a	Short-form position (YX)
; @param[out]	bc	Long-form position (YYXX)
; @addr{20cb}
convertShortToLongPosition:
	ld c,a			; $20cb
;;
; @param	c	Short-form position (YX)
; @param[out]	bc	Long-form position (YYXX)
; @addr{20cc}
convertShortToLongPosition_paramC:
	ld a,c			; $20cc
	and $f0			; $20cd
	or $08			; $20cf
	ld b,a			; $20d1
	ld a,c			; $20d2
	swap a			; $20d3
	and $f0			; $20d5
	or $08			; $20d7
	ld c,a			; $20d9
	ret			; $20da

;;
; @addr{20db}
objectCenterOnTile:
	ldh a,(<hActiveObjectType)	; $20db
	add Object.y		; $20dd
	ld l,a			; $20df
	ld h,d			; $20e0

;;
; Adjust 16-bit coordinates to the center of a tile.
;
; @param	hl
; @addr{20e1}
centerCoordinatesOnTile:
	; Center Y
	xor a			; $20e1
	ldi (hl),a		; $20e2
	ld a,(hl)		; $20e3
	and $f0			; $20e4
	or $08			; $20e6
	ldi (hl),a		; $20e8

	; Center X
	xor a			; $20e9
	ldi (hl),a		; $20ea
	ld a,(hl)		; $20eb
	and $f0			; $20ec
	or $08			; $20ee
	ld (hl),a		; $20f0
	ret			; $20f1

;;
; Checks to see if a certain number of part slots are available.
;
; @param	b	Number of part slots to check for
; @param[out]	zflag	Set if there are at least 'b' part slots available.
; @addr{20f2}
checkBPartSlotsAvailable:
	ldhl FIRST_PART_INDEX, Part.enabled		; $20f2
	jr checkBEnemySlotsAvailable@nextSlot

;;
; @addr{20f7}
checkBEnemySlotsAvailable:
	ldhl FIRST_ENEMY_INDEX, Enemy.enabled		; $20f7

@nextSlot:
	call @checkSlotAvailable		; $20fa
	jr c,@nextSlot
	ret nz			; $20ff
	dec b			; $2100
	jr nz,@nextSlot
	ret			; $2103

;;
; @addr{2104}
@checkSlotAvailable:
	ld a,(hl)		; $2104
	inc h			; $2105
	or a			; $2106
	ret z			; $2107
	ld a,h			; $2108
	cp $e0			; $2109
	ret c			; $210b
	or h			; $210c
	ret			; $210d

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
; @addr{210e}
objectSetPositionInCircleArc:
	push bc			; $210e
	ld h,d			; $210f
	ld l,e			; $2110
	ld c,(hl)		; $2111
	ld b,SPEED_100		; $2112
	call getScaledPositionOffsetForVelocity		; $2114
	pop bc			; $2117

	; Add Y offset
	ldh a,(<hActiveObjectType)	; $2118
	add Object.yh		; $211a
	ld e,a			; $211c
	ld a,(wTmpcec0+1)		; $211d
	add b			; $2120
	ld (de),a		; $2121

	; Add X offset
	inc e			; $2122
	inc e			; $2123
	ld a,(wTmpcec0+3)		; $2124
	add c			; $2127
	ld (de),a		; $2128
	ret			; $2129

;;
; This appears to multiply a position offset by a certain amount.
;
; @param	a		Amount to multiply the resulting position offsets by
; @param	b		Speed
; @param	c		Angle
; @param[out]	wTmpcec0	The scaled values are stored here (4 bytes total).
; @param[out]	hl		wTmpcec0+3
; @addr{212a}
getScaledPositionOffsetForVelocity:
	ldh (<hFF8B),a	; $212a
	call getPositionOffsetForVelocity		; $212c

	call @scaleComponent		; $212f
	inc l			; $2132

;;
; @param	hl	Address of position offset to scale
; @param	hFF8B	Amount to scale the position offsets by
; @addr{2133}
@scaleComponent:
	push hl			; $2133
	ldi a,(hl)		; $2134
	ld c,a			; $2135
	ld b,(hl)		; $2136

	; Multiply 'bc' by [hFF8B], storing the result in 'hl'?
	ld e,$08		; $2137
	ld hl,$0000		; $2139
	ldh a,(<hFF8B)	; $213c
--
	add hl,hl		; $213e
	rlca			; $213f
	jr nc,+			; $2140
	add hl,bc		; $2142
+
	dec e			; $2143
	jr nz,--		; $2144

	; Store the scaled values
	ld a,l			; $2146
	ld b,h			; $2147
	pop hl			; $2148
	ldi (hl),a		; $2149
	ld (hl),b		; $214a
	ret			; $214b

;;
; Set's an object's "component speed" (separate x/y speed variables) via the given speed
; & angle values.
;
; @param	a	Amount to multiply speed by
; @param	b	Speed
; @param	c	Angle
; @addr{214c}
objectSetComponentSpeedByScaledVelocity:
	call getScaledPositionOffsetForVelocity		; $214c

	ldh a,(<hActiveObjectType)	; $214f
	or Object.speedX+1			; $2151

	; X speed
	ld e,a			; $2153
	ldd a,(hl)		; $2154
	ld (de),a		; $2155
	dec e			; $2156
	ldd a,(hl)		; $2157
	ld (de),a		; $2158

	; Y speed
	dec e			; $2159
	ldd a,(hl)		; $215a
	ld (de),a		; $215b
	dec e			; $215c
	ld a,(hl)		; $215d
	ld (de),a		; $215e
	ret			; $215f

;;
; Gets the address of a variable in relatedObj1.
;
; @param	a	Which variable to get for relatedObj1
; @param[out]	hl	Address of the variable
; @addr{2160}
objectGetRelatedObject1Var:
	ld l,Object.relatedObj1		; $2160
	jr ++

;;
; @addr{2164}
objectGetRelatedObject2Var:
	ld l,Object.relatedObj2		; $2164
++
	ld h,a			; $2166
	ldh a,(<hActiveObjectType)	; $2167
	add l			; $2169
	ld e,a			; $216a
	ld a,(de)		; $216b
	add h			; $216c
	ld l,a			; $216d
	inc e			; $216e
	ld a,(de)		; $216f
	ld h,a			; $2170
	ret			; $2171

;;
; Returns a Z position such that the object would be immediately above the screen if
; assigned this value.
;
; @param[out]	a	Z position
; @addr{2172}
objectGetZAboveScreen:
	ldh a,(<hActiveObjectType)	; $2172
	add Object.yh		; $2174
	ld e,a			; $2176
	ld a,(de)		; $2177
	ld b,a			; $2178
	ldh a,(<hCameraY)	; $2179
	sub b			; $217b
	sub $08			; $217c
	cp $80			; $217e
	ret nc			; $2180

	ld a,$80		; $2181
	ret			; $2183

;;
; Checks if the object is within the screen. Note the screen size may be smaller than the
; room size (in dungeons).
;
; Seems to give leeway of 8 pixels in either direction, unless that's somehow part of the
; calculation. (Is it expecting 16x16-size objects?)
;
; @param[out]	cflag	Set if the object is within the screen boundary
; @addr{2184}
objectCheckWithinScreenBoundary:
	ldh a,(<hCameraY)	; $2184
	ld b,a			; $2186
	ldh a,(<hCameraX)	; $2187
	ld c,a			; $2189
	ldh a,(<hActiveObjectType)	; $218a
	add Object.yh			; $218c
	ld e,a			; $218e
	ld a,(de)		; $218f
	sub b			; $2190
	add $07			; $2191
	cp $90-1			; $2193
	ret nc			; $2195

	inc e			; $2196
	inc e			; $2197
	ld a,(de)		; $2198
	sub c			; $2199
	add $07			; $219a
	cp $b0-1			; $219c
	ret			; $219e

;;
; @param[out]	cflag	Set if the object is within the room boundary
; @addr{219f}
objectCheckWithinRoomBoundary:
	ldh a,(<hActiveObjectType)	; $219f
	add Object.yh			; $21a1
	ld e,a			; $21a3
	ld hl,wRoomEdgeY		; $21a4
	ld a,(de)		; $21a7
	cp (hl)			; $21a8
	ret nc			; $21a9

	inc e			; $21aa
	inc e			; $21ab
	inc l			; $21ac
	ld a,(de)		; $21ad
	cp (hl)			; $21ae
	ret			; $21af

;;
; Deletes the object (clears its memory), then replaces its ID with the new value.
;
; The new object keeps its former yh, xh, zh, and enabled values.
;
; @param	bc	New object ID
; @addr{21b0}
objectReplaceWithID:
	ld h,d			; $21b0
	push bc			; $21b1

	; Store Object.enabled, Y position
	ldh a,(<hActiveObjectType)	; $21b2
	ld l,a			; $21b4
	ld b,(hl)		; $21b5
	add Object.yh			; $21b6
	ld l,a			; $21b8
	ld c,(hl)		; $21b9
	push bc			; $21ba

	; Store X, Z
	inc l			; $21bb
	inc l			; $21bc
	ld b,(hl)		; $21bd
	inc l			; $21be
	inc l			; $21bf
	ld c,(hl)		; $21c0
	push bc			; $21c1

	; Delete object
	call objectDelete_useActiveObjectType		; $21c2

	; Restore X/Y/Z positions
	pop bc			; $21c5
	ld h,d			; $21c6
	ldh a,(<hActiveObjectType)	; $21c7
	add Object.zh			; $21c9
	ld l,a			; $21cb
	ld (hl),c		; $21cc
	dec l			; $21cd
	dec l			; $21ce
	ld (hl),b		; $21cf
	pop bc			; $21d0
	dec l			; $21d1
	dec l			; $21d2
	ld (hl),c		; $21d3

	; Restore Object.enabled (only first 2 bits?)
	ldh a,(<hActiveObjectType)	; $21d4
	ld l,a			; $21d6
	ld a,b			; $21d7
	and $03			; $21d8
	ldi (hl),a		; $21da

	; Set Object.id, subid
	pop bc			; $21db
	ld (hl),b		; $21dc
	inc l			; $21dd
	ld (hl),c		; $21de
	ret			; $21df

;;
; @addr{21e0}
objectDelete_useActiveObjectType:
	ldh a,(<hActiveObjectType)	; $21e0
	ld e,a			; $21e2

;;
; @addr{21e3}
objectDelete_de:
	ld a,e			; $21e3
	and $c0			; $21e4
	ld e,a			; $21e6
	ld l,a			; $21e7
	ld h,d			; $21e8
	ld b,$10		; $21e9
	xor a			; $21eb
--
	ldi (hl),a		; $21ec
	ldi (hl),a		; $21ed
	ldi (hl),a		; $21ee
	ldi (hl),a		; $21ef
	dec b			; $21f0
	jr nz,--		; $21f1
	jp objectRemoveFromAButtonSensitiveObjectList		; $21f3

;;
; Check if Link is over a pit (water, hole, or lava). If he's riding dimitri, this check
; always comes up false.
;
; Note: this overwrites the current hActiveObject.
;
; @param[out]	a	$01 if water, $02 if hole, $04 if lava
; @param[out]	cflag	Set if Link is on one of the above tiles.
; @addr{21f6}
checkLinkIsOverHazard:
	ld a,(wLinkObjectIndex)		; $21f6
	ld d,a			; $21f9
	ldh (<hActiveObject),a	; $21fa
	xor a			; $21fc
	ldh (<hActiveObjectType),a	; $21fd

	ld e,SpecialObject.id		; $21ff
	ld a,(de)		; $2201
	sub SPECIALOBJECTID_DIMITRI			; $2202
	ret z			; $2204

	push bc			; $2205
	push hl			; $2206
	call objectCheckIsOverHazard		; $2207
	pop hl			; $220a
	pop bc			; $220b
	ret			; $220c

;;
; Check if an object is on water, lava, or a hole. Same as the below function, except if
; the object is in midair, it doesn't count.
;
; @param[out]	a	$01 if water, $02 if hole, $04 if lava
; @param[out]	cflag	Set if the object is on one of these tiles.
; @addr{220d}
objectCheckIsOnHazard:
	ldh a,(<hActiveObjectType)	; $220d
	add Object.zh			; $220f
	ld e,a			; $2211
	ld a,(de)		; $2212
	and $80			; $2213
	ret nz			; $2215
;;
; Check if an object is over water, lava, or a hole.
;
; @param[out]	a	$01 if water, $02 if hole, $04 if lava
; @param[out]	cflag	Set if the object is on one of these tiles.
; @addr{2216}
objectCheckIsOverHazard:
	ld bc,$0500		; $2216
	call objectGetRelativeTile		; $2219
.ifdef ROM_AGES
	ld (wObjectTileIndex),a		; $221c
.endif
	ld hl,hazardCollisionTable	; $221f
	jp lookupCollisionTable		; $2222

;;
; If the object is over a pit, this replaces it with an appropriate animation.
;
; @param[out]	cflag	Set if the object was on a pit.
; @addr{2225}
objectReplaceWithAnimationIfOnHazard:
	call objectCheckIsOnHazard		; $2225
	ret nc			; $2228

	rrca			; $2229
	jr c,objectReplaceWithSplash		; $222a

	rrca			; $222c
	jr c,objectReplaceWithFallingDownHoleInteraction		; $222d

	ld b,INTERACID_LAVASPLASH		; $222f
	jr objectReplaceWithSplash@create			; $2231

;;
; @addr{2233}
objectReplaceWithFallingDownHoleInteraction:
	call objectCreateFallingDownHoleInteraction		; $2233
	jr objectReplaceWithSplash@delete			; $2236

;;
; @addr{2238}
objectReplaceWithSplash:
	ld b,INTERACID_SPLASH		; $2238
@create:
	call objectCreateInteractionWithSubid00		; $223a
@delete:
	call objectDelete_useActiveObjectType		; $223d
	scf			; $2240
	ret			; $2241

;;
; Copies xyz position of object d to object h.
;
; @param[out]	de	Object d's 'zh' variable
; @param[out]	hl	Object h's 'speed' variable (one past 'zh')
; @addr{2242}
objectCopyPosition:
	ldh a,(<hActiveObjectType)	; $2242
	add Object.yh		; $2244
	ld e,a			; $2246
;;
; Copies the xyz position at address de to object h.
;
; @addr{2247}
objectCopyPosition_rawAddress:
	ld a,l			; $2247
	and $c0			; $2248
	add Object.yh		; $224a
	ld l,a			; $224c
	ld a,(de)		; $224d
	ldi (hl),a		; $224e
	inc e			; $224f
	inc e			; $2250
	inc l			; $2251
	ld a,(de)		; $2252
	ldi (hl),a		; $2253
	inc e			; $2254
	inc e			; $2255
	inc l			; $2256
	ld a,(de)		; $2257
	ldi (hl),a		; $2258
	ret			; $2259

;;
; Copies xyz position of object d to object h and adds an offset.
;
; @param	bc	YX offset
; @addr{225a}
objectCopyPositionWithOffset:
	ldh a,(<hActiveObjectType)	; $225a
	add Object.yh		; $225c
	ld e,a			; $225e
	ld a,l			; $225f
	and $c0			; $2260
	add Object.yh		; $2262
	ld l,a			; $2264

	ld a,(de)		; $2265
	add b			; $2266
	ldi (hl),a		; $2267

	inc e			; $2268
	inc e			; $2269
	inc l			; $226a
	ld a,(de)		; $226b
	add c			; $226c
	ldi (hl),a		; $226d
	inc e			; $226e
	inc e			; $226f
	inc l			; $2270

	ld a,(de)		; $2271
	ldi (hl),a		; $2272
	ret			; $2273

;;
; Object 'd' takes the xyz position of object 'h'.
;
; @addr{2274}
objectTakePosition:
	ld bc,$0000		; $2274
;;
; Object 'd' takes the xyz position of object 'h', plus an offset.
;
; @param	b	Y offset
; @param	c	X offset
; @param[out]	a	Z position
; @param[out]	de	Address of this object's zh variable
; @param[out]	hl	Address of object h's zh variable
; @addr{2277}
objectTakePositionWithOffset:
	ldh a,(<hActiveObjectType)	; $2277
	add Object.yh			; $2279
	ld e,a			; $227b
	ld a,l			; $227c
	and $c0			; $227d
	add Object.yh			; $227f
	ld l,a			; $2281

	ldi a,(hl)		; $2282
	add b			; $2283
	ld (de),a		; $2284

	inc e			; $2285
	inc e			; $2286
	inc l			; $2287
	ldi a,(hl)		; $2288
	add c			; $2289
	ld (de),a		; $228a

	inc e			; $228b
	inc e			; $228c
	inc l			; $228d
	ld a,(hl)		; $228e
	ld (de),a		; $228f
	ret			; $2290

;;
; Changes a tile, and creates a "falling down hole" interaction.
;
; @param	a	Value to change the tile to
; @param	c	Position of tile to change, and where to put the interaction
; @addr{2291}
breakCrackedFloor:
	push bc			; $2291
	call setTile		; $2292
	pop bc			; $2295

	ld a,SND_RUMBLE		; $2296
	call playSound		; $2298

	call getFreeInteractionSlot		; $229b
	ret nz			; $229e
	ld (hl),INTERACID_FALLDOWNHOLE		; $229f

	; Disable interaction's sound effect
	inc l			; $22a1
	ld (hl),$80		; $22a2

	ld l,Interaction.yh		; $22a4
	jp setShortPosition_paramC		; $22a6

;;
; @param[out]	cflag	Set if the tile at the object's position is water (even shallow
;			water)
; @addr{22a9}
objectCheckTileAtPositionIsWater:
	call objectGetTileAtPosition		; $22a9
	sub TILEINDEX_PUDDLE			; $22ac
	cp TILERANGE_WATER			; $22ae
	ret			; $22b0

;;
; This function is used by zoras, presumably to check which positions they can spawn at.
;
; @param	bc	Position of tile
; @param[out]	cflag	Set if the tile at that position is water (even shallow water)
; @addr{22b1}
checkTileAtPositionIsWater:
	call getTileAtPosition		; $22b1
	sub TILEINDEX_PUDDLE			; $22b4
	cp TILERANGE_WATER			; $22b6
	ret			; $22b8

;;
; @param	c	An item ID to search for
; @param[out]	hl	Address of the id variable for the first item with ID 'c'
; @param[out]	zflag	Set on success
; @addr{22b9}
findItemWithID:
	ld h,FIRST_ITEM_INDEX		; $22b9
---
	ld l,Item.id		; $22bb
	ld a,(hl)		; $22bd
	cp c			; $22be
	ret z			; $22bf
;;
; @param	c	An item ID to search for
; @param	h	The index before the first item to check
; @param[out]	zflag	Set on success
; @addr{22c0}
findItemWithID_startingAfterH:
	inc h			; $22c0
	ld a,h			; $22c1
	cp $e0			; $22c2
	jr c,---		; $22c4
	or h			; $22c6
	ret			; $22c7

;;
; Searches for an object with the given ID of the same type as the current active object.
;
; @param	c	An object ID to search for
; @param[out]	hl	Address of the id variable for the first object with ID 'c'
; @param[out]	zflag	Set on success
; @addr{22c8}
objectFindSameTypeObjectWithID:
	ldh a,(<hActiveObject)	; $22c8
	and $f0			; $22ca
	ld h,a			; $22cc

	; l = Object.id
	ldh a,(<hActiveObjectType)	; $22cd
	inc a			; $22cf
	ld l,a			; $22d0
--
	ld a,(hl)		; $22d1
	cp c			; $22d2
	ret z			; $22d3
func_228f:
	inc h			; $22d4
	ld a,h			; $22d5
	cp $e0			; $22d6
	jr c,--			; $22d8
	or h			; $22da
	ret			; $22db

;;
; Sets object's priority based on y, z relative to link?
;
; @addr{22dc}
objectSetPriorityRelativeToLink:
	ld c,$80		; $22dc
	jr +			; $22de

;;
; Sets object's priority based on y, z relative to link?
;
; Also sets bit 6 of visible (unlike above) which enables terrain effects (ie. pond
; puddle)
;
; @param[out]	b	Value written to Object.visible
; @param[out]	de	Address of Object.visible
; @addr{22e0}
objectSetPriorityRelativeToLink_withTerrainEffects:
	ld c,$c0		; $22e0
+
	call @getPriority		; $22e2
	ldh a,(<hActiveObjectType)	; $22e5
	add Object.visible			; $22e7
	ld e,a			; $22e9
	ld a,c			; $22ea
	or b			; $22eb
	ld (de),a		; $22ec
	ret			; $22ed

;;
; Gets priority based on height relative to link?
;
; @param	d	Object
; @param[out]	b	Priority
; @addr{22ee}
@getPriority:
	ldh a,(<hActiveObjectType)	; $22ee
	add Object.zh			; $22f0
	ld e,a			; $22f2
	ld a,(de)		; $22f3
	; return if Z position is between 1 and 16
	dec a			; $22f4
	ld b,$03		; $22f5
	cp $10			; $22f7
	ret c			; $22f9

	dec b			; $22fa
	ld a,e			; $22fb
	add Object.yh-Object.zh			; $22fc
	ld e,a			; $22fe
	ld a,(de)		; $22ff
	ld e,a			; $2300

	ld a,(wLinkObjectIndex)		; $2301
	ld h,a			; $2304
	ld l,<w1Link.yh		; $2305
	ld a,(hl)		; $2307
	add $0b			; $2308

	; cp (w1Link.yh+$0b) to Object.yh
	cp e			; $230a
	ret nc			; $230b

	; decrement b if Object.y < w1Link.yh+$0b
	dec b			; $230c
	ret			; $230d

;;
; Pushes Link away from the object if they collide.
;
; This provides "light" collision for moving objects, allowing Link to still walk through
; them with some resistance.
;
; @param[out]	cflag	Set if the object collided with Link
; @addr{230e}
objectPushLinkAwayOnCollision:
	ld a,(wLinkObjectIndex)		; $230e
	ld h,a			; $2311
	ld l,SpecialObject.enabled		; $2312
	call checkObjectsCollided		; $2314
	ret nc			; $2317

	; They've collided; calculate the angle to push Link back at
	call objectGetAngleTowardEnemyTarget		; $2318
	ld c,a			; $231b
	ld b,SPEED_100		; $231c

;;
; @param	b	Speed
; @param	c	Angle
; @addr{231e}
updateLinkPositionGivenVelocity:
	ldh a,(<hRomBank)	; $231e
	push af			; $2320
	ld a,:bank5.specialObjectUpdatePositionGivenVelocity		; $2321
	setrombank		; $2323

	; Update Link's position
	push de			; $2328
	ld a,(wLinkObjectIndex)		; $2329
	ld d,a			; $232c
	ld e,SpecialObject.enabled		; $232d
	call bank5.specialObjectUpdatePositionGivenVelocity		; $232f
	pop de			; $2332

	pop af			; $2333
	setrombank		; $2334
	scf			; $2339
	ret			; $233a

;;
; Sets the object's oam variables to mimic a background tile. Also copies the
; corresponding background palette to sprite palette 6.
;
; The object will still need to load the correct animation.
;
; @param	a	Tile index
; @addr{233b}
objectMimicBgTile:
	; Get top-left flag value in 'b', top-left tile index in 'c'
	call getTileMappingData		; $233b

	; Set oamFlagsBackup & oamFlags to $0e
	ld h,d			; $233e
	ldh a,(<hActiveObjectType)	; $233f
	add Object.oamFlagsBackup			; $2341
	ld l,a			; $2343
	ld a,$0e		; $2344
	ldi (hl),a		; $2346
	ldi (hl),a		; $2347

	; Set Object.oamTileIndexBase to the value returned from the function call above
	ld (hl),c		; $2348

	; bc = w2TilesetBgPalettes + (palette index) * 8
	ld a,b			; $2349
	and $07			; $234a
	swap a			; $234c
	rrca			; $234e
	ld bc,w2TilesetBgPalettes		; $234f
	call addAToBc		; $2352

	ld a,($ff00+R_SVBK)	; $2355
	push af			; $2357
	ld a,:w2TilesetBgPalettes		; $2358
	ld ($ff00+R_SVBK),a	; $235a

	; Copy the background palette to sprite palette 6
	ld hl,w2TilesetSprPalettes+6*8		; $235c
	ld e,$08		; $235f
--
	ld a,(bc)		; $2361
	ldi (hl),a		; $2362
	inc c			; $2363
	dec e			; $2364
	jr nz,--		; $2365

	; Slate sprite palette 6 for reloading
	ld hl,hDirtySprPalettes		; $2367
	set 6,(hl)		; $236a

	pop af			; $236c
	ld ($ff00+R_SVBK),a	; $236d
	ret			; $236f

;;
; @param	c	Gravity
; @param[out]	cflag	c if the object will no longer bounce (speedZ is sufficiently low).
; @param[out]	zflag	z if the object touched the ground
; @addr{2370}
objectUpdateSpeedZAndBounce:
	call objectUpdateSpeedZ_paramC		; $2370
	ret nz			; $2373

;;
; Inverts an object's Z speed and halves it. Used for bombs when bouncing on the ground.
;
; Once it reaches a speed of less than 1 pixel per frame downwards, it stops.
;
; @param[out]	cflag	c if the object will no longer bounce (speedZ is sufficiently low).
; @param[out]	zflag	z if the object touched the ground
; @addr{2374}
objectNegateAndHalveSpeedZ:
	ld h,d			; $2374
	ldh a,(<hActiveObjectType)	; $2375
	or Object.speedZ			; $2377
	ld l,a			; $2379

	; Get -speedZ/2 in bc
	ldi a,(hl)		; $237a
	cpl			; $237b
	ld c,a			; $237c
	ld a,(hl)		; $237d
	cpl			; $237e
	ld b,a			; $237f

	inc bc			; $2380
	sra b			; $2381
	rr c			; $2383

	; Return if bc > $ff80 (original speed is less than 1 pixel per frame downward)
	ld hl,$ff80		; $2385
	call compareHlToBc		; $2388
	inc a			; $238b
	scf			; $238c
	ret z			; $238d

	ldh a,(<hActiveObjectType)	; $238e
	or Object.speedZ			; $2390
	ld e,a			; $2392

	; Store new speedZ
	ld a,c			; $2393
	ld (de),a		; $2394
	inc e			; $2395
	ld a,b			; $2396
	ld (de),a		; $2397

	; Set carry flag on return if speed is zero
	or c			; $2398
	scf			; $2399
	ret z			; $239a

	xor a			; $239b
	ret			; $239c

;;
; @param	bc	speedZ
; @addr{239d}
objectSetSpeedZ:
	ldh a,(<hActiveObjectType)	; $239d
	add Object.speedZ			; $239f
	ld l,a			; $23a1
	ld h,d			; $23a2
	ld (hl),c		; $23a3
	inc l			; $23a4
	ld (hl),b		; $23a5
	ret			; $23a6

;;
; Adds a 16-bit variable located at hl to a 16-bit variable at de
;
; @param	de	Address to add and write result to
; @param	hl	Address of value to add
; @param[out]	a	High byte of result
; @addr{23a7}
add16BitRefs:
	ld a,(de)		; $23a7
	add (hl)		; $23a8
	ld (de),a		; $23a9
	inc e			; $23aa
	inc hl			; $23ab
	ld a,(de)		; $23ac
	adc (hl)		; $23ad
	ld (de),a		; $23ae
	ret			; $23af

;;
; @param	a	The ring to check for.
; @param[out]	zflag	Set if the currently equipped ring equals 'a'.
; @addr{23b0}
cpActiveRing:
	push hl			; $23b0
	ld hl,wActiveRing		; $23b1
	cp (hl)			; $23b4
	pop hl			; $23b5
	ret			; $23b6

;;
; @addr{23b7}
disableActiveRing:
	push hl			; $23b7
	ld hl,wActiveRing		; $23b8
	set 6,(hl)		; $23bb
	pop hl			; $23bd
	ret			; $23be

;;
; @addr{23bf}
enableActiveRing:
	push hl			; $23bf
	ld hl,wActiveRing		; $23c0
	ld a,(hl)		; $23c3
	cp $ff			; $23c4
	jr z,+			; $23c6
	res 6,(hl)		; $23c8
+
	pop hl			; $23ca
	ret			; $23cb

;;
; @addr{23cc}
interactionDecCounter1:
	ld h,d			; $23cc
	ld l,Interaction.counter1		; $23cd
	dec (hl)		; $23cf
	ret			; $23d0
;;
; @addr{23d1}
interactionDecCounter2:
	ld h,d			; $23d1
	ld l,Interaction.counter2		; $23d2
	dec (hl)		; $23d4
	ret			; $23d5
;;
; @addr{23d6}
itemDecCounter1:
	ld h,d			; $23d6
	ld l,Item.counter1		; $23d7
	dec (hl)		; $23d9
	ret			; $23da
;;
; @addr{23db}
itemDecCounter2:
	ld h,d			; $23db
	ld l,Item.counter2		; $23dc
	dec (hl)		; $23de
	ret			; $23df
;;
; @addr{23e0}
interactionIncState:
	ld h,d			; $23e0
	ld l,Interaction.state		; $23e1
	inc (hl)		; $23e3
	ret			; $23e4
;;
; @addr{23e5}
interactionIncState2:
	ld h,d			; $23e5
	ld l,Interaction.state2		; $23e6
	inc (hl)		; $23e8
	ret			; $23e9
;;
; @addr{23ea}
itemIncState:
	ld h,d			; $23ea
	ld l,Item.state		; $23eb
	inc (hl)		; $23ed
	ret			; $23ee
;;
; @addr{23ef}
itemIncState2:
	ld h,d			; $23ef
	ld l,$05		; $23f0
	inc (hl)		; $23f2
	ret			; $23f3
;;
; Unused?
; @addr{23f4}
cpInteractionState:
	ld h,d			; $23f4
	ld l,Interaction.state		; $23f5
	cp (hl)			; $23f7
	ret			; $23f8
;;
; Unused?
; @addr{23f9}
cpInteractionState2:
	ld h,d			; $23f9
	ld l,Interaction.state2		; $23fa
	cp (hl)			; $23fc
	ret			; $23fd
;;
; @addr{23fe}
checkInteractionState:
	ld e,Interaction.state		; $23fe
	ld a,(de)		; $2400
	or a			; $2401
	ret			; $2402
;;
; @addr{2403}
checkInteractionState2:
	ld e,Interaction.state2		; $2403
	ld a,(de)		; $2405
	or a			; $2406
	ret			; $2407


; Lists the water, hole, and lava tiles for each collision mode.
;
; @addr{2408}
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
; @addr{2461}
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
; @addr{2481}
angleTable:
	.db $00 $00 $00 $01 $01 $01 $02 $02
	.db $02 $02 $02 $03 $03 $03 $04 $04
	.db $04 $04 $04 $05 $05 $05 $06 $06
	.db $06 $06 $06 $07 $07 $07 $00 $00

;;
; Set an object's X and Y collide radii to 'a'.
;
; @param	a	Collision radius
; @addr{24a1}
objectSetCollideRadius:
	push bc			; $24a1
	ld b,a			; $24a2
	ld c,a			; $24a3
	call objectSetCollideRadii		; $24a4
	pop bc			; $24a7
	ret			; $24a8

;;
; Set an object's YX collide radii to bc.
;
; @param	b	Collide radius Y
; @param	c	Collide radius X
; @addr{24a9}
objectSetCollideRadii:
	ldh a,(<hActiveObjectType)	; $24a9
	add Object.collisionRadiusY	; $24ab
	ld l,a			; $24ad
	ld h,d			; $24ae
	ld (hl),b		; $24af
	inc l			; $24b0
	ld (hl),c		; $24b1
	ret			; $24b2

;;
; @addr{24b3}
decNumEnemies:
	ld hl,wNumEnemies		; $24b3
	ld a,(hl)		; $24b6
	or a			; $24b7
	ret z			; $24b8
	dec (hl)		; $24b9
	ret			; $24ba

;;
; @addr{24bb}
setScreenShakeCounter:
	ld hl,wScreenShakeCounterY		; $24bb
	ldi (hl),a		; $24be
	ld (hl),a		; $24bf
	ret			; $24c0

;;
; @addr{24c1}
objectCreatePuff:
	ld b,INTERACID_PUFF		; $24c1

;;
; @param	b	High byte of interaction
; @addr{24c3}
objectCreateInteractionWithSubid00:
	ld c,$00		; $24c3

;;
; Create an interaction at the current object's position.
;
; @param	bc	Interaction ID
; @param	d	The object to get the position from
; @param[out]	a	0
; @param[out]	hl	The new interaction's 'speed' variable (one past 'zh')
; @param[out]	zflag	nz if there wasn't a free slot for the interaction
; @addr{24c5}
objectCreateInteraction:
	call getFreeInteractionSlot		; $24c5
	ret nz			; $24c8
	ld (hl),b		; $24c9
	inc l			; $24ca
	ld (hl),c		; $24cb
	call objectCopyPosition		; $24cc
	xor a			; $24cf
	ret			; $24d0

;;
; @addr{24d1}
objectCreateFallingDownHoleInteraction:
	call getFreeInteractionSlot		; $24d1
	ret nz			; $24d4

	ld (hl),INTERACID_FALLDOWNHOLE		; $24d5

	; Store object type in Interaction.counter1
	ld l,Interaction.counter1		; $24d7
	ldh a,(<hActiveObjectType)	; $24d9
	ldi (hl),a		; $24db

	; Store Object.id in Interaction.counter2
	add Object.id			; $24dc
	ld e,a			; $24de
	ld a,(de)		; $24df
	ld (hl),a		; $24e0

	call objectCopyPosition		; $24e1
	xor a			; $24e4
	ret			; $24e5

.ifdef ROM_AGES

;;
; Makes the object invisible if (wFrameCounter&b) == 0.
;
; b=1 will flicker every frame, creating a sort of transparency.
;
; @param	b	Value to AND with [wFrameCounter].
; @addr{24e6}
objectFlickerVisibility:
	ld a,(wFrameCounter)		; $24e6
	and b			; $24e9
	jp z,objectSetInvisible		; $24ea
	jp objectSetVisible		; $24ed

;;
; Sets a bit in w2SolidObjectPositions based on the object's current position. Prevents
; you from timewarping on top of an npc.
;
; @addr{24f0}
objectMarkSolidPosition:
	call objectGetShortPosition		; $24f0
	ld b,a			; $24f3
	ld a,:w2SolidObjectPositions		; $24f4
	ld ($ff00+R_SVBK),a	; $24f6
	ld a,b			; $24f8
	ld hl,w2SolidObjectPositions		; $24f9
	call setFlag		; $24fc
	ld a,$00		; $24ff
	ld ($ff00+R_SVBK),a	; $2501
	ret			; $2503

;;
; @addr{2504}
objectUnmarkSolidPosition:
	call objectGetShortPosition		; $2504
	ld b,a			; $2507
	ld a,:w2SolidObjectPositions		; $2508
	ld ($ff00+R_SVBK),a	; $250a
	ld a,b			; $250c
	ld hl,w2SolidObjectPositions		; $250d
	call unsetFlag		; $2510
	ld a,$00		; $2513
	ld ($ff00+R_SVBK),a	; $2515
	ret			; $2517

.endif

;;
; @addr{2518}
_interactionActuallyRunScript:
	ldh a,(<hRomBank)	; $2518
	push af			; $251a
	ld a,:runScriptCommand	; $251b
	setrombank		; $251d
--
	ld a,(hl)		; $2522
	or a			; $2523
	jr z,++			; $2524

	call runScriptCommand	; $2526
	jr c,--			; $2529

	pop af			; $252b
	setrombank		; $252c
	xor a			; $2531
	ret			; $2532
++
	pop af			; $2533
	setrombank		; $2534
	scf			; $2539
	ret			; $253a

;;
; @addr{253b}
interactionSetHighTextIndex:
	ld e,Interaction.textID+1	; $253b
	ld (de),a		; $253d
	ld e,Interaction.useTextID	; $253e
	set 7,a			; $2540
	ld (de),a		; $2542
	ret			; $2543

;;
; Sets the interaction's script to hl, also resets Interaction.counter variables.
;
; @param	hl	The address of the script
; @param[out]	a	0 (this is assumed by INTERACID_MAMAMU_DOG due to an apparent bug...)
; @addr{2544}
interactionSetScript:
	ld e,Interaction.scriptPtr		; $2544
	ld a,l			; $2546
	ld (de),a		; $2547
	inc e			; $2548
	ld a,h			; $2549
	ld (de),a		; $254a
	ld h,d			; $254b
	ld l,Interaction.counter1	; $254c
	xor a			; $254e
	ldi (hl),a		; $254f
	ldi (hl),a		; $2550
	ret			; $2551

;;
; @param[out]	cflag	Set when the script ends (ran a "scriptend" command)
; @addr{2552}
interactionRunScript:
	ld a,(wLinkDeathTrigger)		; $2552
	or a			; $2555
	ret nz			; $2556

	ld a,(wTextIsActive)		; $2557
	add a			; $255a
	jr c,+			; $255b
	ret nz			; $255d
+
	; Wait for counter1 to reach 0
	ld h,d			; $255e
	ld l,Interaction.counter1	; $255f
	ld a,(hl)		; $2561
	or a			; $2562
	jr z,+			; $2563
	dec (hl)		; $2565
	ret nz			; $2566
+
	; Wait for counter2 to reach 0
	ld l,Interaction.counter2	; $2567
	ld a,(hl)		; $2569
	or a			; $256a
	jr z,+			; $256b

	; If counter2 is nonzero, still update the object's position?
	dec (hl)		; $256d
	call nz,objectApplySpeed		; $256e
	xor a			; $2571
	ret			; $2572
+
	ld h,d			; $2573
	ld l,Interaction.scriptPtr	; $2574
	ldi a,(hl)		; $2576
	ld h,(hl)		; $2577
	ld l,a			; $2578
	call _interactionActuallyRunScript		; $2579
	jr c,+			; $257c

	call _interactionSaveScriptAddress		; $257e
	xor a			; $2581
	ret			; $2582
+
	call _interactionSaveScriptAddress		; $2583
	scf			; $2586
	ret			; $2587

;;
; @param	hl	Script address
; @addr{2588}
_interactionSaveScriptAddress:
	ld e,Interaction.scriptPtr	; $2588
	ld a,l			; $258a
	ld (de),a		; $258b
	inc e			; $258c
	ld a,h			; $258d
	ld (de),a		; $258e
	ret			; $258f

;;
; @addr{2590}
scriptCmd_asmCall:
	pop hl			; $2590
	call _scriptFunc_setupAsmCall		; $2591
	jr ++			; $2594

;;
; @addr{2596}
scriptCmd_asmCallWithParam:
	pop hl			; $2596
	call _scriptFunc_setupAsmCall		; $2597
	ldi a,(hl)		; $259a
	ld e,a			; $259b
++
	ldh a,(<hRomBank)	; $259c
	push af			; $259e
	ld a,d			; $259f
	setrombank		; $25a0
	push hl			; $25a5
	ld hl,_scriptCmd_asmRetFunc		; $25a6
	push hl			; $25a9
	ldh a,(<hActiveObject)	; $25aa
	ld d,a			; $25ac
	ld h,b			; $25ad
	ld l,c			; $25ae
	ld a,e			; $25af
	jp hl			; $25b0

;;
; @addr{25b1}
_scriptCmd_asmRetFunc:
	pop hl			; $25b1
	pop af			; $25b2
	setrombank		; $25b3
	ldh a,(<hActiveObject)	; $25b8
	ld d,a			; $25ba
	scf			; $25bb
	ret			; $25bc

;;
; @addr{25bd}
_scriptFunc_setupAsmCall:
	inc hl			; $25bd
	ld d,$15		; $25be
	ldi a,(hl)		; $25c0
	ld c,a			; $25c1
	ldi a,(hl)		; $25c2
	ld b,a			; $25c3
	ret			; $25c4


.ifdef ROM_AGES

; Looks like the management of script addresses differs between games?

;;
; Same as scriptFunc_jump but sets the carry flag.
;
; @param	hl	Current address of script, whose contents point to the address to
;			jump to
; @addr{25c5}
scriptFunc_jump_scf:
	call scriptFunc_jump		; $25c5
	scf			; $25c8
	ret			; $25c9

;;
; A script can call this to jump to the address at (hl). This can also handle
; relative jumps in scripts loaded in wBigBuffer, but only within those $100
; bytes.
;
; @param	hl	Current address of script, whose contents point to the address to
;			jump to
; @addr{25ca}
scriptFunc_jump:
	ld a,h			; $25ca
	cp $80			; $25cb
	jr c,++			; $25cd

	ldh a,(<hScriptAddressL)	; $25cf
	ld c,a			; $25d1
	ldh a,(<hScriptAddressH)	; $25d2
	ld b,a			; $25d4
	ldi a,(hl)		; $25d5
	sub c			; $25d6
	ld e,a			; $25d7
	ldd a,(hl)		; $25d8
	sbc b			; $25d9
	or a			; $25da
	jr nz,++		; $25db

	ld l,e			; $25dd
	ld h,>wBigBuffer		; $25de
	ret			; $25e0
++
	ldi a,(hl)		; $25e1
	ld h,(hl)		; $25e2
	ld l,a			; $25e3
	ldh a,(<hActiveObject)	; $25e4
	ld d,a			; $25e6
	xor a			; $25e7
	ret			; $25e8

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
; @addr{25e9}
scriptFunc_add3ToHl_scf:
	scf			; $25e9
;;
; @addr{25ea}
scriptFunc_add3ToHl:
	inc hl			; $25ea
	inc hl			; $25eb
	inc hl			; $25ec
	ret			; $25ed

;;
; @addr{25ee}
scriptCmd_loadScript:
	pop hl			; $25ee
	inc hl			; $25ef
	ldi a,(hl)		; $25f0
	ld e,a			; $25f1
	ldi a,(hl)		; $25f2
	ld c,a			; $25f3
.ifdef ROM_AGES
	ldh (<hScriptAddressL),a	; $25f4
.endif
	ldi a,(hl)		; $25f6
	ld b,a			; $25f7
.ifdef ROM_AGES
	ldh (<hScriptAddressH),a	; $25f8
.endif
	ldh a,(<hRomBank)	; $25fa
	push af			; $25fc
	ld a,e			; $25fd
	setrombank		; $25fe
	ld h,b			; $2603
	ld l,c			; $2604
	ld de,wBigBuffer		; $2605
	ld b,$00		; $2608
	call copyMemory		; $260a
	pop af			; $260d
	setrombank		; $260e
	ldh a,(<hActiveObject)	; $2613
	ld d,a			; $2615
	ld hl,wBigBuffer		; $2616
	scf			; $2619
	ret			; $261a

;;
; @addr{261b}
interactionAnimate:
	ld h,d			; $261b
	ld l,Interaction.animCounter	; $261c
	dec (hl)		; $261e
	ret nz			; $261f

	ldh a,(<hRomBank)	; $2620
	push af			; $2622
	ld a,:interactionAnimationTable		; $2623
	setrombank		; $2625
	ld l,Interaction.animPointer	; $262a
	jr _interactionNextAnimationFrame		; $262c

;;
; @param	a	Animation index
; @addr{262e}
interactionSetAnimation:
	add a			; $262e
	ld c,a			; $262f
	ld b,$00		; $2630
	ldh a,(<hRomBank)	; $2632
	push af			; $2634
	ld a,:interactionAnimationTable		; $2635
	setrombank		; $2637
	ld e,Interaction.id		; $263c
	ld a,(de)		; $263e
	ld hl,interactionAnimationTable		; $263f
	rst_addDoubleIndex			; $2642
	ldi a,(hl)		; $2643
	ld h,(hl)		; $2644
	ld l,a			; $2645
	add hl,bc		; $2646

;;
; @addr{2647}
_interactionNextAnimationFrame:
	ldi a,(hl)		; $2647
	ld h,(hl)		; $2648
	ld l,a			; $2649

	; Byte 0: how many frames to hold it (or $ff to loop)
	ldi a,(hl)		; $264a
	cp $ff			; $264b
	jr nz,++		; $264d

	; If $ff, animation loops
	ld b,a			; $264f
	ld c,(hl)		; $2650
	add hl,bc		; $2651
	ldi a,(hl)		; $2652
++
	ld e,Interaction.animCounter	; $2653
	ld (de),a		; $2655

	; Byte 1: frame index (store in bc for now)
	ldi a,(hl)		; $2656
	ld c,a			; $2657
	ld b,$00		; $2658

	; Interaction.animParameter
	inc e			; $265a
	; Byte 2: general-purpose information on animation state? No specific
	; purpose? Some interactions use this to delete themselves when their
	; animation finishes.
	ldi a,(hl)		; $265b
	ld (de),a		; $265c

	; Interaction.animPointer
	inc e			; $265d
	; Save the current position in the animation
	ld a,l			; $265e
	ld (de),a		; $265f
	inc e			; $2660
	ld a,h			; $2661
	ld (de),a		; $2662

	ld e,Interaction.id		; $2663
	ld a,(de)		; $2665
	ld hl,interactionOamDataTable		; $2666
	rst_addDoubleIndex			; $2669
	ldi a,(hl)		; $266a
	ld h,(hl)		; $266b
	ld l,a			; $266c
	add hl,bc		; $266d

	; Set the address of the oam data
	ld e,Interaction.oamDataAddress		; $266e
	ldi a,(hl)		; $2670
	ld (de),a		; $2671
	inc e			; $2672
	ldi a,(hl)		; $2673
	and $3f			; $2674
	or $40			; $2676
	ld (de),a		; $2678

	pop af			; $2679
	setrombank		; $267a
	ret			; $267f

;;
; Stops Link from passing through the object.
;
; Used for minecarts, other things?
;
; Also prevents Dimitri from passing through npcs when thrown.
;
; @param[out]	cflag	Set if there's a collision with Link
; @addr{2680}
objectPreventLinkFromPassing:
	ld a,(wLinkCanPassNpcs)		; $2680
	or a			; $2683
	ret nz			; $2684

	ld l,a			; $2685
	ld a,(wLinkObjectIndex)		; $2686
	ld h,a			; $2689
	call preventObjectHFromPassingObjectD		; $268a
	push af			; $268d

	; If Dimitri is active, we can't let him pass either while being thrown.
	ld hl,w1Companion.id		; $268e
	ld a,(hl)		; $2691
	cp SPECIALOBJECTID_DIMITRI			; $2692
	jr nz,@end		; $2694

	ld l,<w1Companion.state		; $2696
	ld a,(hl)		; $2698
	cp $02			; $2699
	jr nz,@end		; $269b

	call preventObjectHFromPassingObjectD		; $269d
	jr nc,@end		; $26a0

	ld a,$01		; $26a2
	ld (wDimitriHitNpc),a		; $26a4
@end:
	pop af			; $26a7
	ret			; $26a8

;;
; @addr{26a9}
npcFaceLinkAndAnimate:
	ld e,Interaction.knockbackAngle		; $26a9
	ld a,$01		; $26ab
	ld (de),a		; $26ad

	; Wait for this counter to reach 0 before changing directions again
	ld e,Interaction.invincibilityCounter		; $26ae
	ld a,(de)		; $26b0
	or a			; $26b1
	jr nz,+++		; $26b2

	; Face towards Link if within a certain distance, otherwise face down
	ld c,$28		; $26b4
	call objectCheckLinkWithinDistance		; $26b6
	jr c,++			; $26b9
	ld l,Interaction.knockbackAngle		; $26bb
	dec (hl)		; $26bd
	ld a,DIR_DOWN*2		; $26be
++
	; Convert direction value to angle
	ld b,a			; $26c0
	add a			; $26c1
	add a			; $26c2
	ld h,d			; $26c3
	ld l,Interaction.angle		; $26c4
	cp (hl)			; $26c6
	jr z,interactionAnimateAsNpc	; $26c7

	ld (hl),a		; $26c9

	; Set animation
	srl b			; $26ca
.ifdef ROM_AGES
	ld e,Interaction.var37		; $26cc
	ld a,(de)		; $26ce
	add b			; $26cf
.else
	call seasonsFunc_2678
	ld a,b
.endif
	call interactionSetAnimation		; $26d0

	; Don't change directions again for another 30 frames
	ld e,Interaction.invincibilityCounter		; $26d3
	ld a,30		; $26d5
+++
	dec a			; $26d7
	ld (de),a		; $26d8
	jr interactionAnimateAsNpc		; $26d9


.ifdef ROM_SEASONS
;;
seasonsFunc_2678:
	ld e,Interaction.id		; $2678
	ld a,(de)		; $267a
	sub $24			; $267b
	cp $24			; $267d
	ret nc			; $267f
	ld e,Interaction.var37		; $2680
	ld a,(de)		; $2682
	add b			; $2683
	ld b,a			; $2684
	ret			; $2685
.endif

;;
; Update animations, push Link away, update draw priority relative to Link, and enable
; "terrain effects" (puddles on water, etc).
; @addr{26db}
interactionAnimateAsNpc:
	call interactionAnimate		; $26db

;;
; @addr{26de}
interactionPushLinkAwayAndUpdateDrawPriority:
	call objectPreventLinkFromPassing		; $26de
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $26e1

;;
; Return if screen scrolling is disabled?
;
; @addr{26e4}
returnIfScrollMode01Unset:
	ld a,(wScrollMode)		; $26e4
	and SCROLLMODE_01	; $26e7
	ret nz			; $26e9
	pop hl			; $26ea
	ret			; $26eb

;;
; Deletes the interaction and returns from the caller if [Interaction.enabled]&3 == 2.
;
; @addr{26ec}
interactionDeleteAndRetIfEnabled02:
	ld e,Interaction.enabled		; $26ec
	ld a,(de)		; $26ee
	and $03			; $26ef
	cp $02			; $26f1
	ret nz			; $26f3
	pop hl			; $26f4
	jp interactionDelete		; $26f5

;;
; Converts the angle value at 'de' to a direction value. Diagonals get rounded to the
; closest cardinal direction.
;
; @param	de	Address of an "angle" value
; @param[out]	a	Corresponding "direction" value
; @addr{26f8}
convertAngleDeToDirection:
	ld a,(de)		; $26f8

;;
; Converts given angle value to a direction value. Diagonals get rounded to the closest
; cardinal direction.
;
; @param	a	Angle value
; @param[out]	a	Corresponding "direction" value
; @addr{26f9}
convertAngleToDirection:
	add $04			; $26f9
	add a			; $26fb
	swap a			; $26fc
	and $03			; $26fe
	ret			; $2700

;;
; Sets bit 7 of Interaction.enabled, indicating that the interaction should update even
; when scrolling, when textboxes are up, and when bit 1 of wActiveObjects is set.
; @addr{2701}
interactionSetAlwaysUpdateBit:
	ld h,d			; $2701
	ld l,Interaction.enabled	; $2702
	set 7,(hl)		; $2704
	ret			; $2706

;;
; Checks if link is centered within 4 pixels of the given object, among other things. This
; is used for minecarts to check whether he's in position to get on, although it may also
; be used for other things.
;
; @param[out]	cflag	Set if centered correctly (and various other checks pass)
; @addr{2707}
objectCheckLinkPushingAgainstCenter:
	ld a,(w1Link.id)		; $2707
	or a			; $270a
	ret nz			; $270b

	; Check a directional button is pressed?
	ld a,(wLinkAngle)		; $270c
	cp $ff			; $270f
	ret z			; $2711

	; Return if A or B is pressed
	ld a,(wGameKeysPressed)		; $2712
	and BTN_A|BTN_B			; $2715
	ret nz			; $2717

	ld b,$04		; $2718
	jp objectCheckCenteredWithLink		; $271a

;;
; Checks whether the tile adjacent to the interaction (based on its current "angle" value)
; is solid or not.
;
; @param[out]	zflag	Set if the adjacent tile is not solid.
; @addr{271d}
interactionCheckAdjacentTileIsSolid:
	ld e,Interaction.angle		; $271d
	ld a,(de)		; $271f
	call convertAngleDeToDirection		; $2720
	jr ++			; $2723

;;
; Unused?
;
; @addr{2725}
interactionCheckAdjacentTileIsSolid_viaDirection:
	ld e,Interaction.direction		; $2725
	ld a,(de)		; $2727
	sra a			; $2728
++
	ld hl,@dirOffsets		; $272a
	rst_addAToHl			; $272d
	call objectGetShortPosition		; $272e
	add (hl)		; $2731
	ld h,>wRoomCollisions		; $2732
	ld l,a			; $2734
	ld a,(hl)		; $2735
	or a			; $2736
	ret			; $2737

; @addr{2738}
@dirOffsets:
	.db $f0 $01 $10 $ff



.ifdef ROM_AGES

;;
; @param[out]	zflag	z when counter1 reaches 0 (and text is inactive)
; @addr{273c}
interactionDecCounter1IfTextNotActive:
	ld a,(wTextIsActive)		; $273c
	or a			; $273f
	ret nz			; $2740
	jp interactionDecCounter1		; $2741

;;
; @addr{2744}
interactionDecCounter1IfPaletteNotFading:
	ld a,(wPaletteThread_mode)		; $2744
	or a			; $2747
	ret nz			; $2748
	jp interactionDecCounter1		; $2749

;;
; Unused?
;
; @addr{274c}
interactionAnimate4Times:
	call interactionAnimate		; $274c

;;
; @addr{274f}
interactionAnimate3Times:
	call interactionAnimate		; $274f

;;
; @addr{2752}
interactionAnimate2Times:
	call interactionAnimate		; $2752
	jp interactionAnimate		; $2755

;;
; Updates an interaction's animation based on its speed. The faster it is, the faster the
; animation goes.
;
; If counter2 is nonzero, it updates the animation at the slowest speed.
;
; @addr{2758}
interactionAnimateBasedOnSpeed:
	call interactionAnimate		; $2758
	ld e,Interaction.counter2		; $275b
	ld a,(de)		; $275d
	or a			; $275e
	ret z			; $275f

	ld e,Interaction.speed		; $2760
	ld a,(de)		; $2762
	cp SPEED_100			; $2763
	ret c			; $2765

	cp SPEED_200			; $2766
	jp c,interactionAnimate		; $2768

	cp SPEED_300			; $276b
	jp c,interactionAnimate2Times		; $276d
	jp interactionAnimate3Times		; $2770

;;
; @param	bc	Position
; @addr{2773}
interactionSetPosition:
	ld h,d			; $2773

;;
; @param	bc	Position
; @addr{2774}
interactionHSetPosition:
	ld l,Interaction.yh	; $2774
	ld (hl),b		; $2776
	ld l,Interaction.xh
	ld (hl),c		; $2779
	ret			; $277a

;;
; Unused?
;
; @addr{277b}
interactionUnsetAlwaysUpdateBit:
	ld h,d			; $277b
	ld l,Interaction.enabled		; $277c
	res 7,(hl)		; $277e
	ret			; $2780

;;
; @addr{2781}
interactionLoadExtraGraphics:
	ld e,Interaction.id		; $2781
	ld a,(de)		; $2783
	ld (wInteractionIDToLoadExtraGfx),a		; $2784

	; Why... what does this accomplish, other than possibly trashing tree graphics?
	ld (wLoadedTreeGfxIndex),a		; $2787

	ret			; $278a

;;
; Unused?
;
; @addr{278b}
interactionFunc_278b:
	ld l,Interaction.scriptPtr		; $278b
	ld (hl),c		; $278d
	inc l			; $278e
	ld (hl),b		; $278f
	ret			; $2790

;;
; This isn't used with standard scripts; see the function below.
;
; @param[out]	hl	Value of Interaction.scriptPtr
; @addr{2791}
interactionGetMiniScript:
	ld h,d			; $2791
	ld l,Interaction.scriptPtr		; $2792
	ldi a,(hl)		; $2794
	ld h,(hl)		; $2795
	ld l,a			; $2796
	ret			; $2797

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
; @addr{2798}
interactionSetMiniScript:
	ld e,Interaction.scriptPtr		; $2798
	ld a,l			; $279a
	ld (de),a		; $279b
	inc e			; $279c
	ld a,h			; $279d
	ld (de),a		; $279e
	ret			; $279f

.endif


;;
; Oscillates an object's Z position up and down? (used by Maple)
;
; @addr{27a0}
objectOscillateZ:
	ldh a,(<hRomBank)	; $27a0
	push af			; $27a2
.ifdef ROM_AGES
	callfrombank0 interactionBank09.objectOscillateZ_body		; $27a3
.else
	callfrombank0 objectOscillateZ_body		; $27a3
.endif
	pop af			; $27ad
	setrombank		; $27ae
	ret			; $27b3

;;
; @param	b	Ring to give (overrides the treasure subid?)
; @param	c	var03 for TREASURE_RING (determines if it's in a chest or not,
;			how it spawns in, etc). This should usually be $00?
; @param[out]	zflag	Set if the treasure was given successfully.
; @addr{27b4}
giveRingToLink:
	call createRingTreasure		; $27b4
	ret nz			; $27b7
	push de			; $27b8
	ld de,w1Link.yh		; $27b9
	call objectCopyPosition_rawAddress		; $27bc
	pop de			; $27bf
	xor a			; $27c0
	ret			; $27c1

;;
; Creates a "ring" treasure. Doesn't set X/Y coordinates.
;
; @param	b	Ring to give (overrides the treasure subid?)
; @param	c	Subid for TREASURE_RING (determines if it's in a chest or not,
;			how it spawns in, etc)
; @param[out]	zflag	Set if the treasure was created successfully.
; @addr{27c2}
createRingTreasure:
	call getFreeInteractionSlot		; $27c2
	ret nz			; $27c5
	ld (hl),INTERACID_TREASURE		; $27c6
	inc l			; $27c8
	ld (hl),TREASURE_RING		; $27c9
	inc l			; $27cb
	ld (hl),c		; $27cc
	ld l,Interaction.var38		; $27cd
	set 6,b			; $27cf
	ld (hl),b		; $27d1
	xor a			; $27d2
	ret			; $27d3

;;
; Creates a "treasure" interaction (INTERACID_TREASURE). Doesn't initialize X/Y.
;
; @param	bc	Treasure to create (b = main id, c = subid)
; @param[out]	zflag	Set if the treasure was created successfully.
; @addr{27d4}
createTreasure:
	call getFreeInteractionSlot		; $27d4
	ret nz			; $27d7
	ld (hl),INTERACID_TREASURE		; $27d8
	inc l			; $27da
	ld (hl),b		; $27db
	inc l			; $27dc
	ld (hl),c		; $27dd
	xor a			; $27de
	ret			; $27df

;;
; Creates an "exclamation mark" interaction, complete with sound effect. Its position is
; at an offset from the current object.
;
; @param	a	How long to show the exclamation mark for (0 or $ff for
;                       indefinitely).
; @param	bc	Offset from the object to create the exclamation mark at.
; @param	d	The object to use for the base position of the exclamation mark.
; @addr{27e0}
objectCreateExclamationMark:
	ldh (<hFF8B),a	; $27e0
	ldh a,(<hRomBank)	; $27e2
	push af			; $27e4
.ifdef ROM_AGES
	ld a,:interactionBank0b.objectCreateExclamationMark_body		; $27e5
.else
	ld a,:objectCreateExclamationMark_body		; $27e5
.endif
	setrombank		; $27e7
	ldh a,(<hFF8B)	; $27ec
.ifdef ROM_AGES
	call interactionBank0b.objectCreateExclamationMark_body		; $27ee
.else
	call objectCreateExclamationMark_body		; $27ee
.endif
	pop af			; $27f1
	setrombank		; $27f2
	ret			; $27f7

;;
; Creates a floating "Z" letter like someone is snoring.
;
; Unused? (probably used in Seasons for talon)
;
; @param	a	0 to float left, nonzero to float right
; @param	bc	Offset relative to object
; @addr{27f8}
objectCreateFloatingSnore:
	ldh (<hFF8B),a	; $27f8
	ld a,$00		; $27fa
	jr ++			; $27fc

;;
; @param	a	0 to float left, nonzero to float right
; @param	bc	Offset relative to object
; @addr{27fe}
objectCreateFloatingMusicNote:
	ldh (<hFF8B),a	; $27fe
	ld a,$01		; $2800
++
	ldh (<hFF8D),a	; $2802
	ldh a,(<hRomBank)	; $2804
	push af			; $2806
.ifdef ROM_AGES
	callfrombank0 interactionBank0b.objectCreateFloatingImage		; $2807
.else
	callfrombank0 objectCreateFloatingImage		; $2807
.endif
	pop af			; $2811
	setrombank		; $2812
	ret			; $2817

;;
; @addr{2818}
enemyAnimate:
	ld h,d			; $2818
	ld l,Enemy.animCounter		; $2819
	dec (hl)		; $281b
	ret nz			; $281c

	ldh a,(<hRomBank)	; $281d
	push af			; $281f
	ld a,:enemyAnimationTable		; $2820
	setrombank		; $2822
	ld l,Enemy.animPointer		; $2827
	jr _enemyNextAnimationFrame		; $2829

;;
; @param a Animation index
;
; @addr{282b}
enemySetAnimation:
	add a			; $282b
	ld c,a			; $282c
	ld b,$00		; $282d
	ldh a,(<hRomBank)	; $282f
	push af			; $2831
	ld a,:enemyAnimationTable		; $2832
	setrombank		; $2834
	ld e,Enemy.id		; $2839
	ld a,(de)		; $283b
	ld hl,enemyAnimationTable		; $283c
	rst_addDoubleIndex			; $283f
	ldi a,(hl)		; $2840
	ld h,(hl)		; $2841
	ld l,a			; $2842
	add hl,bc		; $2843

;;
; @addr{2844}
_enemyNextAnimationFrame:
	ldi a,(hl)		; $2844
	ld h,(hl)		; $2845
	ld l,a			; $2846

	; Byte 0: how many frames to hold it (or $ff to loop)
	ldi a,(hl)		; $2847
	cp $ff			; $2848
	jr nz,++			; $284a

	; If $ff, animation loops
	ld b,a			; $284c
	ld c,(hl)		; $284d
	add hl,bc		; $284e
	ldi a,(hl)		; $284f
++
	ld e,Enemy.animCounter		; $2850
	ld (de),a		; $2852

	; Byte 1: frame index (store in bc for now)
	ldi a,(hl)		; $2853
	ld c,a			; $2854
	ld b,$00		; $2855

	; Enemy.animParameter
	inc e			; $2857
	ldi a,(hl)		; $2858
	ld (de),a		; $2859

	; Enemy.animPointer
	inc e			; $285a
	; Save the current position in the animation
	ld a,l			; $285b
	ld (de),a		; $285c
	inc e			; $285d
	ld a,h			; $285e
	ld (de),a		; $285f

	ld e,Enemy.id		; $2860
	ld a,(de)		; $2862
	ld hl,enemyOamDataTable		; $2863
	rst_addDoubleIndex			; $2866
	ldi a,(hl)		; $2867
	ld h,(hl)		; $2868
	ld l,a			; $2869
	add hl,bc		; $286a

	; Set the address of the oam data
	ld e,Enemy.oamDataAddress		; $286b
	ldi a,(hl)		; $286d
	ld (de),a		; $286e
	inc e			; $286f
	ldi a,(hl)		; $2870
	and $3f			; $2871
	ld (de),a		; $2873

	pop af			; $2874
	setrombank		; $2875
	ret			; $287a

;;
; See the below functions.
;
; @addr{287b}
enemyDie_uncounted_withoutItemDrop:
	ld b,$80		; $287b
	jr ++		; $287d

;;
; Like enemyDie, but there is no random item drop.
;
; @addr{287f}
enemyDie_withoutItemDrop:
	ld b,$81		; $287f
	jr ++		; $2881

;;
; Like enemyDie, but wNumEnemies is not decremented. Other kill counters are incremented
; as normal.
;
; @addr{2883}
enemyDie_uncounted:
	ld b,$00		; $2883
	jr ++		; $2885

;;
; Kills an enemy in a puff of smoke. wNumEnemies will be decremented, and there will be
; a random item drop (depending on the enemy id?)
;
; @addr{2887}
enemyDie:
	ld b,$01		; $2887
++
	call @enemyCreateDeathPuff		; $2889
	bit 0,b			; $288c
	call nz,markEnemyAsKilledInRoom		; $288e

	; Update wTotalEnemiesKilled if 1000 have not yet been killed
	ld a,GLOBALFLAG_1000_ENEMIES_KILLED		; $2891
	call checkGlobalFlag		; $2893
	jr nz,++		; $2896

	ld l,<wTotalEnemiesKilled		; $2898
	call incHlRef16WithCap		; $289a
	ldi a,(hl)		; $289d
	ld h,(hl)		; $289e
	ld l,a			; $289f
	ld bc,1000		; $28a0
	call compareHlToBc		; $28a3
	rlca			; $28a6
	ld a,GLOBALFLAG_1000_ENEMIES_KILLED		; $28a7
	call nc,setGlobalFlag		; $28a9
++
	; Update maple kill counter
	ld hl,wMapleKillCounter		; $28ac
	call incHlRefWithCap		; $28af

	; Update all gasha kill counters
	ld a,GASHA_RING		; $28b2
	call cpActiveRing		; $28b4
	ld a,$ff		; $28b7
	jr z,+			; $28b9
	xor a			; $28bb
+
	ld l,<wGashaSpotKillCounters		; $28bc
	ld c,NUM_GASHA_SPOTS		; $28be
--
	; Increment [hl] once, or twice if gasha ring is equipped
	rlca			; $28c0
	call c,incHlRefWithCap		; $28c1
	call incHlRefWithCap		; $28c4
	inc l			; $28c7
	dec c			; $28c8
	jr nz,--		; $28c9

	; Increment some counter
	ld a,$03		; $28cb
	call addToGashaMaturity		; $28cd

	jp enemyDelete		; $28d0

;;
; @param	b	Bit 0 set if wNumEnemies should be decremented,
;			Bit 7 set if there should be an item drop.
; @addr{28d3}
@enemyCreateDeathPuff:
	; Kill instantly instead of in a puff of smoke if bit 7 of var3f is set
	ld e,Enemy.var3f		; $28d3
	ld a,(de)		; $28d5
	rlca			; $28d6
	jp c,decNumEnemies		; $28d7

	call getFreePartSlot		; $28da
	ret nz			; $28dd

	; [Part.enabled] = [Enemy.enabled & 3]
	ld e,Enemy.enabled		; $28de
	ld a,(de)		; $28e0
	and $03			; $28e1
	dec l			; $28e3
	ldi (hl),a		; $28e4

	; Part.id
	ld (hl),PARTID_ENEMY_DESTROYED		; $28e5

	; [Part.subid] = [Enemy.id]
	inc l			; $28e7
	ld e,Enemy.id		; $28e8
	ld a,(de)		; $28ea
	ld (hl),a		; $28eb

	ld l,Part.knockbackCounter		; $28ec
	ld e,Enemy.knockbackCounter		; $28ee
	ld a,(de)		; $28f0
	ld (hl),a		; $28f1

	call objectCopyPosition		; $28f2

	; Use counter2 to tell the part whether to decrement wNumEnemies, and whether to
	; drop a random item.
	ld l,Part.counter2		; $28f5
	ld (hl),b		; $28f7

	ld a,SND_KILLENEMY		; $28f8
	jp playSound		; $28fa

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
; @addr{28fd}
enemyStandardUpdate:
	ld h,d			; $28fd
	ld l,Enemy.state	; $28fe
	ld a,(hl)		; $2900
	or a			; $2901
	jr z,@uninitialized	; $2902

	ld l,Enemy.var2a		; $2904
	bit 7,(hl)		; $2906
	jr nz,@ret04		; $2908

	ld e,Enemy.knockbackCounter		; $290a
	ld a,(de)		; $290c
	and $7f			; $290d
	jr nz,@knockback	; $290f

	; Enemy.health
	dec l			; $2911
	ld a,(hl)		; $2912
	or a			; $2913
	jr z,@healthZero	; $2914

	; Enemy.stunCounter
	inc e			; $2916
	ld a,(de)		; $2917
	or a			; $2918
	jr nz,@stunned		; $2919

@ret00:
	ld c,$00		; $291b
	ret			; $291d

@uninitialized:
	callab bank3f.enemyLoadGraphicsAndProperties		; $291e
	call getRandomNumber_noPreserveVars		; $2926
	ld e,Enemy.var3d		; $2929
	ld (de),a		; $292b
	inc e			; $292c
	ld a,$01		; $292d
	ld (de),a		; $292f
	jr @ret00		; $2930

@ret04:
	ld c,$04		; $2932
	ret			; $2934

@knockback:
	ld l,e			; $2935
	dec (hl)		; $2936
	ld c,$05		; $2937
	ret			; $2939

@healthZero:
	ld l,Enemy.var3f		; $293a
	bit 1,(hl)		; $293c
	jr nz,@ret00		; $293e
	ld c,$03		; $2940
	ret			; $2942

@stunned:
	ld a,(wFrameCounter)		; $2943
	rrca			; $2946
	jr nc,++		; $2947

	; Decrement Enemy.stunCounter
	ld l,e			; $2949
	dec (hl)		; $294a

	; With 30 frames before being unstunned, make the enemy shake back and forth
	ld a,(hl)		; $294b
	cp 30			; $294c
	jr nc,++		; $294e
	rrca			; $2950
	jr nc,++		; $2951

	ld l,Enemy.xh		; $2953
	ld a,(hl)		; $2955
	xor $01			; $2956
	ld (hl),a		; $2958
++
	; Have the enemy fall down to the ground and bounce

	ld l,Enemy.state		; $2959
	ld a,(hl)		; $295b
	cp $08			; $295c
	jr c,@reachedGround	; $295e

	ld l,Enemy.zh		; $2960
	ld a,(hl)		; $2962
	dec a			; $2963
	cp $08			; $2964
	jr c,@reachedGround	; $2966

	ld c,$20		; $2968
	call objectUpdateSpeedZAndBounce		; $296a
	jr nc,@ret02		; $296d

	ld h,d			; $296f

@reachedGround:
	ld l,Enemy.speedZ		; $2970
	xor a			; $2972
	ldi (hl),a		; $2973
	ld (hl),a		; $2974

@ret02:
	ld c,$02		; $2975
	ret			; $2977

;;
; @addr{2978}
partAnimate:
	ld h,d			; $2978
	ld l,Part.animCounter		; $2979
	dec (hl)		; $297b
	ret nz			; $297c
	ld a,:partAnimationTable		; $297d
	setrombank		; $297f
	ld l,Part.animPointer		; $2984
	jr _partNextAnimationFrame		; $2986

;;
; @addr{2988}
partSetAnimation:
	add a			; $2988
	ld c,a			; $2989
	ld b,$00		; $298a
	ld a,:partAnimationTable		; $298c
	setrombank		; $298e
	ld e,$c1		; $2993
	ld a,(de)		; $2995
	ld hl,partAnimationTable		; $2996
	rst_addDoubleIndex			; $2999
	ldi a,(hl)		; $299a
	ld h,(hl)		; $299b
	ld l,a			; $299c
	add hl,bc		; $299d

;;
; Note: this sets the ROM bank to $11 before returning.
;
; @addr{299e}
_partNextAnimationFrame:
	ldi a,(hl)		; $299e
	ld h,(hl)		; $299f
	ld l,a			; $29a0

	; Byte 0: how many frames to hold it (or $ff to loop)
	ldi a,(hl)		; $29a1
	cp $ff			; $29a2
	jr nz,+			; $29a4

	; If $ff, animation loops
	ld b,a			; $29a6
	ld c,(hl)		; $29a7
	add hl,bc		; $29a8
	ldi a,(hl)		; $29a9
+
	ld e,Part.animCounter		; $29aa
	ld (de),a		; $29ac

	; Byte 1: frame index (store in bc for now)
	ldi a,(hl)		; $29ad
	ld c,a			; $29ae
	ld b,$00		; $29af

	; Item.animParameter
	inc e			; $29b1
	ldi a,(hl)		; $29b2
	ld (de),a		; $29b3

	; Item.animPointer
	inc e			; $29b4
	; Save the current position in the animation
	ld a,l			; $29b5
	ld (de),a		; $29b6
	inc e			; $29b7
	ld a,h			; $29b8
	ld (de),a		; $29b9

	ld e,Part.id		; $29ba
	ld a,(de)		; $29bc
	ld hl,partOamDataTable		; $29bd
	rst_addDoubleIndex			; $29c0
	ldi a,(hl)		; $29c1
	ld h,(hl)		; $29c2
	ld l,a			; $29c3
	add hl,bc		; $29c4

	; Set the address of the oam data
	ld e,Part.oamDataAddress		; $29c5
	ldi a,(hl)		; $29c7
	ld (de),a		; $29c8
	inc e			; $29c9
	ldi a,(hl)		; $29ca
	and $3f			; $29cb
	or $40			; $29cd
	ld (de),a		; $29cf

	ld a,PART_BANK		; $29d0
	setrombank		; $29d2
	ret			; $29d7

;;
; Creates an energy swirl going towards the given point.
;
; @param	bc	Center of the swirl
; @param	a	Duration of swirl ($ff and $00 are infinite?)
; @addr{29d8}
createEnergySwirlGoingIn:
	ld l,a			; $29d8
	ldh a,(<hRomBank)	; $29d9
	push af			; $29db
	callfrombank0 partCode.createEnergySwirlGoingIn_body		; $29f1
	pop af			; $29e6
	setrombank		; $29e7
	ret			; $29ec

;;
; Creates an energy swirl going away from the given point.
;
; @param	bc	Center of the swirl
; @param	a	Duration of swirl ($ff and $00 are infinite?)
; @addr{29ed}
createEnergySwirlGoingOut:
	ld l,a			; $29ed
	ldh a,(<hRomBank)	; $29ee
	push af			; $29f0
	callfrombank0 partCode.createEnergySwirlGoingOut_body		; $29f1
	pop af			; $29fb
	setrombank		; $29fc
	ret			; $2a01

;;
; Reads wLinkAngle, and returns in 'a' the value that would correspond to the direction
; buttons for moving in that direction.
;
; Why not read directly from wGameKeysPressed? Well, there may be scenarios where it
; doesn't match up with what you want, such as when Link's movement is reversed in the
; final fight.
;
; @param[out]	a	Direction buttons that correspond to wLinkAngle
; @addr{2a02}
convertLinkAngleToDirectionButtons:
	ld a,(wLinkAngle)		; $2a02
	add a			; $2a05
	jr c,+			; $2a06

	add a			; $2a08
	swap a			; $2a09
	push hl			; $2a0b
	ld hl,@data		; $2a0c
	rst_addAToHl			; $2a0f
	ld a,(hl)		; $2a10
	pop hl			; $2a11
	ret			; $2a12
+
	xor a			; $2a13
	ret			; $2a14

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
; @addr{2a1d}
setSimulatedInputAddress:
	ld de,wSimulatedInputBank		; $2a1d
	ld (de),a		; $2a20
	inc e			; $2a21
	ld a,l			; $2a22
	ld (de),a		; $2a23
	inc e			; $2a24
	ld a,h			; $2a25
	ld (de),a		; $2a26

	; [wSimulatedInputCounter] = 0
	ld e,<(wSimulatedInputCounter+1)		; $2a27
	xor a			; $2a29
	ld (de),a		; $2a2a
	dec e			; $2a2b
	ld (de),a		; $2a2c

	; [wUseSimulatedInput] = 1
	dec e			; $2a2d
	inc a			; $2a2e
	ld (de),a		; $2a2f

	jp clearPegasusSeedCounter		; $2a30

;;
; Returns preset input values. Used for cutscenes (ie. the intro).
;
; @param[out]	a	Value to be written to wGameKeysPressed
; @addr{2a33}
getSimulatedInput:
	ld a,(wPaletteThread_mode)		; $2a33
	or a			; $2a36
	ret nz			; $2a37

	ld a,(wUseSimulatedInput)		; $2a38
	rlca			; $2a3b
	jr c,@returnInput	; $2a3c

	ld hl,wSimulatedInputCounter		; $2a3e
	call decHlRef16WithCap		; $2a41
	jr nz,@returnInput	; $2a44

	ldh a,(<hRomBank)	; $2a46
	push af			; $2a48
	ld hl,wSimulatedInputBank		; $2a49
	ldi a,(hl)		; $2a4c
	setrombank		; $2a4d
	ldi a,(hl)		; $2a52
	ld h,(hl)		; $2a53
	ld l,a			; $2a54

	ldi a,(hl)		; $2a55
	ld (wSimulatedInputCounter),a		; $2a56
	ldi a,(hl)		; $2a59
	ld (wSimulatedInputCounter+1),a		; $2a5a

	; If the counter (frames to wait) was $8000 or greater, stop reading inputs.
	bit 7,a			; $2a5d
	jr z,+			; $2a5f

	ld a,$ff		; $2a61
	ld (wUseSimulatedInput),a		; $2a63
	jr ++			; $2a66
+
	ldi a,(hl)		; $2a68
	ld (wSimulatedInputValue),a		; $2a69
++
	pop af			; $2a6c
	setrombank		; $2a6d

	ld a,l			; $2a72
	ld (wSimulatedInputAddressL),a		; $2a73
	ld a,h			; $2a76
	ld (wSimulatedInputAddressH),a		; $2a77

@returnInput:
	ld a,(wSimulatedInputValue)		; $2a7a
	ret			; $2a7d

;;
; Sets Item.state to 'a', and Item.state2 to 0.
;
; @param	a	Value for Item.state
; @addr{2a7e}
itemSetState:
	ld h,d			; $2a7e
	ld l,Item.state		; $2a7f
	ldi (hl),a		; $2a81
	ld (hl),$00		; $2a82
	ret			; $2a84

;;
; @addr{2a85}
clearPegasusSeedCounter:
	ld hl,wPegasusSeedCounter		; $2a85
	xor a			; $2a88
	ldi (hl),a		; $2a89
	ld (hl),a		; $2a8a
	ret			; $2a8b

;;
; Resets some Link variables - primarily his Z position - and resets his animation?
;
; @addr{2a8c}
putLinkOnGround:
	; Return if Link is riding something
	ld a,(wLinkObjectIndex)		; $2a8c
	rrca			; $2a8f
	ret c			; $2a90

	push de			; $2a91

	; Put Link on the ground
	xor a			; $2a92
	ld (wLinkInAir),a		; $2a93
	ld hl,w1Link.speedZ		; $2a96
	ldi (hl),a		; $2a99
	ldi (hl),a		; $2a9a
	ld l,<w1Link.z		; $2a9b
	ldi (hl),a		; $2a9d
	ldi (hl),a		; $2a9e

	ld l,<w1Link.id		; $2a9f
	ld a,(hl)		; $2aa1
	or a			; $2aa2
	jr nz,@end		; $2aa3

	ld d,h			; $2aa5
	ld a,LINK_ANIM_MODE_WALK		; $2aa6
	call specialObjectSetAnimation		; $2aa8
@end:
	pop de			; $2aab
	ret			; $2aac

;;
; Sets wLinkForceState to LINK_STATE_08.
;
; @addr{2aad}
setLinkForceStateToState08:
	xor a			; $2aad

;;
; Sets wLinkForceState to LINK_STATE_08, and wcc50 to the given value.
;
; @param	a	Value for wcc50
; @addr{2aae}
setLinkForceStateToState08_withParam:
	push hl			; $2aae

	; Clear wcc50, it seems to be used differently based on the state
	ld hl,wcc50		; $2aaf
	ldd (hl),a		; $2ab2

	; Set wLinkForceState
	ld (hl),LINK_STATE_08		; $2ab3
	pop hl			; $2ab5
	ret			; $2ab6

;;
; Reads w1Link.damageToApply and applies that to his health.
;
; Parameter 'd' does not need to be passed as the Link object.
;
; @addr{2ab7}
linkApplyDamage:
	push de			; $2ab7
	ldh a,(<hRomBank)	; $2ab8
	push af			; $2aba
	ld d,>w1Link		; $2abb
	callfrombank0 bank5.linkApplyDamage_b5		; $2abd
	pop af			; $2ac7
	setrombank		; $2ac8
	pop de			; $2acd
	ret			; $2ace

;;
; This will force Link's ID to change next time "updateSpecialObjects" is called. Also
; clears subid, var03, state, and state2.
;
; @param	a	Link ID value (see constants/specialObjectTypes.s)
; @addr{2acf}
setLinkIDOverride:
	or $80			; $2acf
	ld (wLinkIDOverride),a		; $2ad1
	ld hl,w1Link.subid		; $2ad4
	jr ++			; $2ad7

;;
; Sets link's ID and clears w1Link.subid, var03, state, state2.
;
; @param	a	New value for w1Link.id
; @addr{2ad9}
setLinkID:
	ld hl,w1Link.id		; $2ad9
	ldi (hl),a		; $2adc
++
	xor a			; $2add
	ldi (hl),a		; $2ade
	ldi (hl),a		; $2adf
	ldi (hl),a		; $2ae0
	ldi (hl),a		; $2ae1
	ret			; $2ae2

;;
; Sends Link back to his spawn point for the room. Also damages him maybe?
;
; @addr{2ae3}
respawnLink:
	ld a,LINK_STATE_RESPAWNING		; $2ae3
	ld (wLinkForceState),a		; $2ae5
	ld a,$02		; $2ae8
	ld (wLinkStateParameter),a		; $2aea
	or d			; $2aed
	ret			; $2aee

;;
; @param	d	Special object index (link or companion)
; @addr{2aef}
specialObjectAnimate:
	ld h,d			; $2aef
	ld l,SpecialObject.animCounter	; $2af0
	dec (hl)		; $2af2
	ret nz			; $2af3

	ldh a,(<hRomBank)	; $2af4
	push af			; $2af6
	ld a,:bank6.specialObjectNextAnimationFrame		; $2af7
	setrombank		; $2af9
	ld l,SpecialObject.animPointer		; $2afe
	call bank6.specialObjectNextAnimationFrame		; $2b00
	pop af			; $2b03
	setrombank		; $2b04
	ret			; $2b09

;;
; @param	a	Animation (see constants/linkAnimations.s)
; @param	d	Special object index
; @addr{2b0a}
specialObjectSetAnimation:
	ld e,SpecialObject.animMode		; $2b0a
	ld (de),a		; $2b0c
	add a			; $2b0d
	ld c,a			; $2b0e
	ld b,$00		; $2b0f
	ldh a,(<hRomBank)	; $2b11
	push af			; $2b13
	callfrombank0 bank6.specialObjectSetAnimation_body		; $2b14
	pop af			; $2b1e
	setrombank		; $2b1f
	ret			; $2b24

;;
; @addr{2b25}
loadLinkAndCompanionAnimationFrame:
	ldh a,(<hRomBank)	; $2b25
	push af			; $2b27
	callfrombank0 bank6.loadLinkAndCompanionAnimationFrame_body		; $2b28
	pop af			; $2b32
	setrombank		; $2b33
	ret			; $2b38

;;
; Check if link is pushing against a wall. This is checked to set his animation as well as
; whether he should do a sword poke.
;
; @param[out]	cflag	Set if link is pushing against a wall.
; @addr{2b39}
checkLinkPushingAgainstWall:
	push hl			; $2b39
	ld a,(w1Link.direction)		; $2b3a
	ld hl,@collisionDirections		; $2b3d
	rst_addDoubleIndex			; $2b40

	; Check that he's facing a wall
	ld a,(w1Link.adjacentWallsBitset)		; $2b41
	and (hl)		; $2b44
	cp (hl)			; $2b45
	jr nz,++		; $2b46

	; Check that he's trying to move towards the wall
	inc hl			; $2b48
	ld a,(wGameKeysPressed)		; $2b49
	and (hl)		; $2b4c
	jr z,++			; $2b4d

	pop hl			; $2b4f
	scf			; $2b50
	ret			; $2b51
++
	pop hl			; $2b52
	xor a			; $2b53
	ret			; $2b54

; @addr{2b55}
@collisionDirections:
	.db $c0 $40
	.db $03 $10
	.db $30 $80
	.db $0c $20

;;
; Updates w1Companion.direction based on wLinkAngle.
;
; @param[out]	cflag	Set if direction changed.
; @addr{2b5d}
updateCompanionDirectionFromAngle:
	push bc			; $2b5d
	push hl			; $2b5e
	ld hl,w1Companion.direction		; $2b5f
	jr ++			; $2b62

;;
; Updates w1Link.direction based on wLinkAngle.
;
; @param[out]	cflag	Set if direction changed.
; @addr{2b64}
updateLinkDirectionFromAngle:
	push bc			; $2b64
	push hl			; $2b65
	ld hl,w1Link.direction		; $2b66
++
	ld b,(hl)		; $2b69
	ld a,(wLinkAngle)		; $2b6a
	cp $ff			; $2b6d
	jr z,@end		; $2b6f

	; Reduce the angle to the 8 directions you can move in
	and $1c			; $2b71
	rrca			; $2b73
	rrca			; $2b74

	; Check for diagonal movement
	rra			; $2b75
	jr nc,++		; $2b76

	; If diagonal, check whether the current direction makes up one of the components
	; of the diagonal; if so, don't modify it.
	ld c,a			; $2b78
	sub b			; $2b79
	inc a			; $2b7a
	and $02			; $2b7b
	jr z,@end		; $2b7d
	ld a,c			; $2b7f
++
	cp (hl)			; $2b80
	jr z,@end		; $2b81
	ld (hl),a		; $2b83
	ld b,a			; $2b84
	scf			; $2b85
@end:
	ld a,b			; $2b86
	pop hl			; $2b87
	pop bc			; $2b88
	ret			; $2b89

;;
; @addr{2b8a}
specialObjectSetCoordinatesToRespawnYX:
	ld h,d			; $2b8a
	ld l,SpecialObject.direction		; $2b8b
	ld a,(wLinkLocalRespawnDir)		; $2b8d
	ldi (hl),a		; $2b90

	; SpecialObject.angle = $ff
	ld a,$ff		; $2b91
	ldi (hl),a		; $2b93

	ld (wLinkPathIndex),a		; $2b94

	; Copy respawn coordinates to y/x
	ld l,SpecialObject.yh		; $2b97
	ld a,(wLinkLocalRespawnY)		; $2b99
	ldi (hl),a		; $2b9c
	inc l			; $2b9d
	ld a,(wLinkLocalRespawnX)		; $2b9e
	ldi (hl),a		; $2ba1

	; Set z position to 0
	xor a			; $2ba2
	ldi (hl),a		; $2ba3
	ldi (hl),a		; $2ba4

	ld l,SpecialObject.knockbackCounter		; $2ba5
	ld (hl),a		; $2ba7
	ret			; $2ba8

;;
; Clear variables related to link's invincibility, knockback, etc.
; @addr{2ba9}
resetLinkInvincibility:
	ld hl,w1Link.oamFlagsBackup		; $2ba9
	ldi a,(hl)		; $2bac
	ld (hl),a		; $2bad

	; Clear collisionType, damageToApply
	ld l,<w1Link.collisionType		; $2bae
	xor a			; $2bb0
	ldi (hl),a		; $2bb1
	ldi (hl),a		; $2bb2

	ld l,<w1Link.damage		; $2bb3
	ldi (hl),a		; $2bb5

	; Clear:
	; var2a
	; invincibilityCounter
	; knockbackAngle
	; knockbackCounter
	; stunCounter
	inc l			; $2bb6
	ldi (hl),a		; $2bb7
	ldi (hl),a		; $2bb8
	ldi (hl),a		; $2bb9
	ldi (hl),a		; $2bba
	ldi (hl),a		; $2bbb
	ret			; $2bbc

;;
; Decrements wPegasusSeedCounter. This decrements it twice unless the Pegasus Ring is
; equipped, which doubles their duration.
;
; @param[out]	zflag	Set if wPegasusSeedCounter is zero.
; @addr{2bbd}
decPegasusSeedCounter:
	ld hl,wPegasusSeedCounter+1	; $2bbd
	res 7,(hl)		; $2bc0
	dec l			; $2bc2
	ld b,$00		; $2bc3
	ld c,$07		; $2bc5
	ld a,PEGASUS_RING		; $2bc7
	call cpActiveRing		; $2bc9
	jr z,+			; $2bcc

	ld c,$0f		; $2bce
	call decHlRef16WithCap		; $2bd0
	ret z			; $2bd3
	ld a,(hl)		; $2bd4
	and c			; $2bd5
	jr nz,+			; $2bd6
	ld b,$80		; $2bd8
+
	call decHlRef16WithCap		; $2bda
	ret z			; $2bdd
	ldi a,(hl)		; $2bde
	and c			; $2bdf
	jr nz,+			; $2be0
	ld b,$80		; $2be2
+
	; Set bit 15 of wPegasusSeedCounter when dust should be created at Link's feet
	ld a,(hl)		; $2be4
	or b			; $2be5
	ldd (hl),a		; $2be6
	ret			; $2be7

;;
; @param[out]	a	The high byte of wPegasusSeedCounter
; @param[out]	zflag	Set if wPegasusSeedCounter is zero
; @addr{2be8}
checkPegasusSeedCounter:
	ld hl,wPegasusSeedCounter		; $2be8
	ldi a,(hl)		; $2beb
	or (hl)			; $2bec
	ldd a,(hl)		; $2bed
	ret			; $2bee

;;
; Try to break a tile at the given item's position.
;
; @param	a	The type of collision (see constants/breakableTileSources.s)
; @param[out]	cflag	Set if the tile was broken (or can be broken)
; @addr{2bef}
itemTryToBreakTile:
	ld h,d			; $2bef
	ld l,Item.yh		; $2bf0
	ld b,(hl)		; $2bf2
	ld l,Item.xh		; $2bf3
	ld c,(hl)		; $2bf5
;;
; See bank6.tryToBreakTile for a better description.
;
; @param	a	The type of collision (see constants/breakableTileSources.s)
;			If bit 7 is set, it will only check if the tile is breakable; it
;			won't actually break it.
; @param	bc	The YYXX position
; @param[out]	cflag	Set if the tile was broken (or can be broken)
; @addr{2bf6}
tryToBreakTile:
	ldh (<hFF8F),a	; $2bf6
	ldh a,(<hRomBank)	; $2bf8
	push af			; $2bfa
	callfrombank0 bank6.tryToBreakTile_body		; $2bfb
	rl e			; $2c05
	pop af			; $2c07
	setrombank		; $2c08
	rr e			; $2c0d
	ret			; $2c0f

;;
; Calls bank6._clearAllParentItems.
; @addr{2c10}
clearAllParentItems:
	ld c,$00		; $2c10
	jr ++			; $2c12

;;
; Calls bank6._updateParentItemButtonAssignment_body.
;
; Updates var03 of a parent item to correspond to the equipped A or B button item. This is
; called after closing a menu (since button assignments may be changed).
;
; @addr{2c14}
updateParentItemButtonAssignment:
	ld c,$01		; $2c14
	jr ++			; $2c16

;;
; Calls bank6.checkUseItems, which checks the A and B buttons and creates corresponding
; item objects if necessary.
;
; @addr{2c18}
checkUseItems:
	ld c,$02		; $2c18
++
	ldh a,(<hRomBank)	; $2c1a
	push af			; $2c1c
	callfrombank0 bank6.functionCaller		; $2c1d
	pop af			; $2c27
	setrombank		; $2c28
	ret			; $2c2d

;;
; @addr{2c2e}
objectAddToGrabbableObjectBuffer:
	ld hl,wGrabbableObjectBuffer		; $2c2e
--
	inc l			; $2c31
	bit 7,(hl)		; $2c32
	jr z,++			; $2c34

	inc l			; $2c36
	ld a,l			; $2c37
	cp <wGrabbableObjectBufferEnd			; $2c38
	jr c,--			; $2c3a
	ret			; $2c3c
++
	ld a,d			; $2c3d
	ldd (hl),a		; $2c3e
	ldh a,(<hActiveObjectType)	; $2c3f
	ld (hl),a		; $2c41
	ret			; $2c42

;;
; Drops an item being held by Link?
;
; @addr{2c43}
dropLinkHeldItem:
	ld a,(wInShop)		; $2c43
	or a			; $2c46
	jr nz,@end		; $2c47

	; Check that 2 <= [wLinkGrabState]&7 < 4
	ld a,(wLinkGrabState)		; $2c49
	and $07			; $2c4c
	sub $02			; $2c4e
	cp $02			; $2c50
	jr nc,@end		; $2c52

	; Get the object Link is holding in hl
	ld hl,w1Link.relatedObj2		; $2c54
	ldi a,(hl)		; $2c57
	ld h,(hl)		; $2c58
	add Object.state			; $2c59
	ld l,a			; $2c5b

	; Check Object.state
	ldi a,(hl)		; $2c5c
	cp $02			; $2c5d
	jr nz,@end		; $2c5f

	; Write $03 to Object.state2 (means it's no longer being held?)
	ld a,$03		; $2c61
	ld (hl),a		; $2c63

	ld a,l			; $2c64
	add Object.angle-Object.state2			; $2c65
	ld l,a			; $2c67
	ld (hl),$ff		; $2c68
@end:
	xor a			; $2c6a
	ld (wLinkGrabState),a		; $2c6b
	ld (wLinkGrabState2),a		; $2c6e
	ret			; $2c71

;;
; Clears var3f for w1ParentItem2-5. Relates to the animation link does as he uses the
; item?
;
; @addr{2c72}
clearVar3fForParentItems:
	ld hl,w1ParentItem2.var3f		; $2c72
--
	ld (hl),$00		; $2c75
	inc h			; $2c77
	ld a,h			; $2c78
	cp WEAPON_ITEM_INDEX			; $2c79
	jr c,--			; $2c7b
	ret			; $2c7d

;;
; Creates a spash at Link's position. Whether it's normal water or lava depends on the
; wLinkSwimmingState variable.
;
; @param	d	Link object
; @addr{2c7e}
linkCreateSplash:
	ld b,INTERACID_SPLASH		; $2c7e

	; Check if in lava; if so, set b to INTERACID_LAVASPLASH.
	ld a,(wLinkSwimmingState)		; $2c80
	bit 6,a			; $2c83
	jr z,+			; $2c85
	inc b			; $2c87
+
	ld a,(wTilesetFlags)		; $2c88
	and TILESETFLAG_SIDESCROLL			; $2c8b
	jp z,objectCreateInteractionWithSubid00		; $2c8d

	; If in a sidescrolling area, create the interaction at an offset to Link's
	; position.
	call getFreeInteractionSlot		; $2c90
	ret nz			; $2c93
	ld (hl),b		; $2c94
	ld bc,$fd00		; $2c95
	jp objectCopyPositionWithOffset		; $2c98

;;
; @addr{2c9b}
clearVariousLinkVariables:
	xor a			; $2c9b
	ld (w1Link.var36),a		; $2c9c
	ld (w1Link.speed),a		; $2c9f
	ld (w1Link.var3e),a		; $2ca2
	ld (w1Link.var12),a		; $2ca5
	dec a			; $2ca8
	ld (w1Link.angle),a		; $2ca9
	ret			; $2cac

;;
; LINK_STATE_SPINNING_FROM_GALE
;
; Not sure why this is in bank 0 instead of bank 5.
;
; @addr{2cad}
linkState07:
	ld e,SpecialObject.state2		; $2cad
	ld a,(de)		; $2caf
	rst_jumpTable			; $2cb0
.dw @substate0
.dw specialObjectAnimate
.dw @substate2


; Initialization (just touched a gale seed)
@substate0:
	; Cancel item usage
	call bank5.linkCancelAllItemUsageAndClearAdjacentWallsBitset		; $2cb7

	call itemIncState2		; $2cba

	xor a			; $2cbd
	ld l,SpecialObject.collisionType		; $2cbe
	ld (hl),a		; $2cc0

	call clearVariousLinkVariables		; $2cc1

	ld a,$80		; $2cc4
	ld (wLinkInAir),a		; $2cc6
	ld a,LINK_ANIM_MODE_GALE		; $2cc9
	jp specialObjectSetAnimation		; $2ccb

; Falling down after cancelling from the gale seed menu
@substate2:
	xor a			; $2cce
	ld (wLinkInAir),a		; $2ccf
	ld a,TRANSITION_DEST_FALL		; $2cd2
	ld (wWarpTransition),a		; $2cd4

	ld e,SpecialObject.yh		; $2cd7
	ld a,(de)		; $2cd9
	add $04			; $2cda
	ld (de),a		; $2cdc

	ld a,LINK_STATE_WARPING		; $2cdd
	jp bank5.linkSetState		; $2cdf

;;
; @addr{2ce2}
itemDelete:
	ld h,d			; $2ce2
	ld l,Item.start		; $2ce3
	ld b,$10		; $2ce5
	xor a			; $2ce7
--
	ldi (hl),a		; $2ce8
	ldi (hl),a		; $2ce9
	ldi (hl),a		; $2cea
	ldi (hl),a		; $2ceb
	dec b			; $2cec
	jr nz,--		; $2ced
	ret			; $2cef

;;
; Updates an item's angle based on its direction.
;
; @param[out]	hl	Item.direction
; @addr{2cf0}
itemUpdateAngle:
	ld h,d			; $2cf0
	ld l,Item.direction		; $2cf1
	ldi a,(hl)		; $2cf3
	swap a			; $2cf4
	rrca			; $2cf6
	ldd (hl),a		; $2cf7
	ret			; $2cf8

;;
; @param[out]	zflag	nz on failure.
; @addr{2cf9}
getFreeItemSlot:
	ldhl FIRST_DYNAMIC_ITEM_INDEX, Item.start		; $2cf9
-
	ld a,(hl)		; $2cfc
	or a			; $2cfd
	ret z			; $2cfe

	inc h			; $2cff
	ld a,h			; $2d00
	cp LAST_DYNAMIC_ITEM_INDEX+1			; $2d01
	jr c,-

	or h			; $2d05
	ret			; $2d06

;;
; @addr{2d07}
introThreadStart:
	ld hl,wIntro.frameCounter		; $2d07
	inc (hl)		; $2d0a
	callfrombank0 runIntro	; $2d0b
	call resumeThreadNextFrame		; $2d15
	jr introThreadStart		; $2d18

;;
; This runs everything after the "nintendo/capcom" logo and before the titlescreen.
; @addr{2d1a}
intro_cinematic:
	ldh a,(<hRomBank)	; $2d1a
	push af			; $2d1c

	callfrombank0 runIntroCinematic		; $2d1d
	callfrombank0 bank5.updateSpecialObjects		; $2d27
	call          loadLinkAndCompanionAnimationFrame		; $2d31
	callfrombank0 updateAnimations
	call          updateInteractionsAndDrawAllSprites		; $2d3e

	pop af			; $2d41
	setrombank		; $2d42
	ret			; $2d47

;;
; Relates to the movement of the triforce pieces in the intro?
;
; @param	b
; @param[out]	b
; @addr{2d48}
func_2d48:
	ldh a,(<hRomBank)	; $2d48
	push af			; $2d4a

.ifdef ROM_AGES
	ld a,:bank3f.data_5951		; $2d4b
.else
	ld a,:data_5951		; $2d4b
.endif
	setrombank		; $2d4d
	ld a,b			; $2d52
.ifdef ROM_AGES
	ld hl,bank3f.data_5951		; $2d53
.else
	ld hl,data_5951		; $2d53
.endif
	rst_addAToHl			; $2d56
	ld b,(hl)		; $2d57

	pop af			; $2d58
	setrombank		; $2d59
	ret			; $2d5e

;;
; wram bank 1 loaded on return.
; @addr{2d5f}
clearFadingPalettes:
	ldh a,(<hRomBank)	; $2d5f
	push af			; $2d61
	callfrombank0 clearFadingPalettes_body		; $2d62
	pop af			; $2d6c
	setrombank		; $2d6d
	ret			; $2d72

;;
; This function causes the screen to flash white. Based on parameter 'b', which acts as
; the "index" if the data to use, this will read through the predefined data to see on
; what frames it should turn the screen white, and on what frames it should restore the
; screen to normal.
;
; @param	b	Index of "screen flashing" data
; @param	hl	Counter to use (should start at 0?)
; @param[out]	zflag	nz if the flashing is complete (all data has been read).
; @addr{2d73}
flashScreen:
	ldh a,(<hRomBank)	; $2d73
	push af			; $2d75
	callfrombank0 flashScreen_body		; $2d76
	ld b,$01		; $2d80
	jr nz,+			; $2d82
	dec b			; $2d84
+
	pop af			; $2d85
	setrombank		; $2d86
	ld a,b			; $2d8b
	or a			; $2d8c
	ret			; $2d8d

;;
; SpecialObject code for IDs $0f-$12
;
; @addr{2d8e}
specialObjectCode_companionCutscene:
	ldh a,(<hRomBank)	; $2d8e
	push af			; $2d90
	callfrombank0 bank6.specialObjectCode_companionCutscene		; $2d91
	pop af			; $2d9b
	setrombank		; $2d9c
	ret			; $2da1

;;
; @addr{2da2}
specialObjectCode_linkInCutscene:

.ifdef ROM_SEASONS

	ldh a,(<hRomBank)
	push af
	callfrombank0 bank6.specialObjectCode_linkInCutscene
	pop af
	setrombank
	ret

.else ; ROM_AGES
	jpab bank6.specialObjectCode_linkInCutscene		; $2da2
.endif

;;
; Load dungeon layout if currently in a dungeon.
;
; @addr{2daa}
loadDungeonLayout:
	ld a,(wTilesetFlags)		; $2daa
	and TILESETFLAG_DUNGEON		; $2dad
	ret z			; $2daf

	ldh a,(<hRomBank)	; $2db0
	push af			; $2db2
	callfrombank0 bank1.loadDungeonLayout_b01	; $2db3
	pop af			; $2dbd
	setrombank		; $2dbe
	ret			; $2dc3

;;
; @addr{2dc4}
initializeDungeonStuff:
	xor a			; $2dc4
	ld (wToggleBlocksState),a		; $2dc5
	ld (wSwitchState),a		; $2dc8
	ld (wSpinnerState),a		; $2dcb
	jp loadStaticObjects		; $2dce

;;
; @addr{2dd1}
setVisitedRoomFlag:
	call getThisRoomFlags		; $2dd1
	set ROOMFLAG_BIT_VISITED, (hl)		; $2dd4
	ret			; $2dd6

;;
; Sets wDungeonRoomProperties to this room's dungeon flag value, also returns
; value in a
;
; @param[out]	a	Dungeon properties
; @addr{2dd7}
getThisRoomDungeonProperties:
	ldh a,(<hRomBank)	; $2dd7
	push af			; $2dd9
	ld a, :dungeonRoomPropertiesGroupTable
	setrombank		; $2ddc
	ld a,(wActiveGroup)		; $2de1
	sub $04			; $2de4
	and $01			; $2de6
	ld hl, dungeonRoomPropertiesGroupTable
	rst_addDoubleIndex			; $2deb
	ldi a,(hl)		; $2dec
	ld h,(hl)		; $2ded
	ld l,a			; $2dee
	ld a,(wActiveRoom)		; $2def
	ld b,$00		; $2df2
	ld c,a			; $2df4
	add hl,bc		; $2df5
	ld a,(hl)		; $2df6
	ld (wDungeonRoomProperties),a		; $2df7
	pop af			; $2dfa
	setrombank		; $2dfb
	ret			; $2e00

;;
; Get the address of the dungeon layout in RAM in hl (wram bank 2)
;
; @addr{2e01}
getDungeonLayoutAddress:
	push bc			; $2e01
	push de			; $2e02
	ld a,(wDungeonFloor)		; $2e03
	ld c,$40		; $2e06
	call multiplyAByC		; $2e08
	ld bc, w2DungeonLayout
	add hl,bc		; $2e0e
	pop de			; $2e0f
	pop bc			; $2e10
	ret			; $2e11

;;
; Get the current room index.
;
; @param[out]	a	Current room index
; @addr{2e12}
getActiveRoomFromDungeonMapPosition:
	ld a,(wDungeonMapPosition)		; $2e12

;;
; Get the room at minimap position A on the current floor.
;
; @param	a	Minimap position
; @param[out]	a,l	Room at that position
; @addr{2e15}
getRoomInDungeon:
	ldh (<hFF8B),a	; $2e15
	ld a, :w2DungeonLayout
	ld ($ff00+R_SVBK),a	; $2e19
	call getDungeonLayoutAddress		; $2e1b
	ldh a,(<hFF8B)	; $2e1e
	rst_addAToHl			; $2e20
	ld l,(hl)		; $2e21
	xor a			; $2e22
	ld ($ff00+R_SVBK),a	; $2e23
	ld a,l			; $2e25
	ret			; $2e26


.ifdef ROM_SEASONS
	.include "code/code_3035.s"
.endif


;;
; @addr{2e27}
getFreeEnemySlot:
	call getFreeEnemySlot_uncounted		; $2e27
	ret nz			; $2e2a
	ld a,(wNumEnemies)		; $2e2b
	inc a			; $2e2e
	ld (wNumEnemies),a		; $2e2f
	xor a			; $2e32
	ret			; $2e33

;;
; @addr{2e34}
getFreeEnemySlot_uncounted:
	ldhl FIRST_ENEMY_INDEX, Enemy.start		; $2e34
--
	ld a,(hl)		; $2e37
	or a			; $2e38
	jr z,+
	inc h			; $2e3b
	ld a,h			; $2e3c
	cp LAST_ENEMY_INDEX+1			; $2e3d
	jr c,--
	or h			; $2e41
	ret			; $2e42
+
	inc a			; $2e43
	ldi (hl),a		; $2e44
	xor a			; $2e45
	ret			; $2e46

;;
; @addr{2e47}
enemyDelete:
	ld e,Enemy.enabled		; $2e47
	call objectRemoveFromAButtonSensitiveObjectList		; $2e49
	ld l,e			; $2e4c
	ld h,d			; $2e4d
	ld b,$10		; $2e4e
	xor a			; $2e50
-
	ldi (hl),a		; $2e51
	ldi (hl),a		; $2e52
	ldi (hl),a		; $2e53
	ldi (hl),a		; $2e54
	dec b			; $2e55
	jr nz,-
	ret			; $2e58

;;
; Deletes the enemy (clears its memory), then replaces its ID with the new value.
;
; The new object keeps its former yh, xh, zh, and enabled values.
;
; Mostly equivalent to the "objectReplaceWithID" function, but only for enemies.
;
; @param	bc	New enemy ID
; @addr{2e59}
enemyReplaceWithID:
	ld h,d			; $2e59
	push bc			; $2e5a

	; Store Enemy.enabled, Y position
	ld l,Enemy.enabled		; $2e5b
	ld b,(hl)		; $2e5d
	ld l,Enemy.yh		; $2e5e
	ld c,(hl)		; $2e60
	push bc			; $2e61

	; Store X, Z
	ld l,Enemy.xh		; $2e62
	ld b,(hl)		; $2e64
	ld l,Enemy.zh		; $2e65
	ld c,(hl)		; $2e67
	push bc			; $2e68

	; Delete enemy
	call enemyDelete		; $2e69

	; Restore X/Y/Z positions
	pop bc			; $2e6c
	ld l,Enemy.zh		; $2e6d
	ld (hl),c		; $2e6f
	ld l,Enemy.xh		; $2e70
	ld (hl),b		; $2e72
	pop bc			; $2e73
	ld l,Enemy.yh		; $2e74
	ld (hl),c		; $2e76

	; Restore Enemy.enabled (not all bits?)
	ld l,Enemy.enabled		; $2e77
	ld a,b			; $2e79
	and $73			; $2e7a
	ldi (hl),a		; $2e7c

	; Set Enemy.id, subid
	pop bc			; $2e7d
	ld (hl),b		; $2e7e
	inc l			; $2e7f
	ld (hl),c		; $2e80
	ret			; $2e81

;;
; Update all enemies with 'state' variables equal to 0.
;
; @addr{2e82}
_updateEnemiesIfStateIsZero:
	ld a,Enemy.start		; $2e82
	ldh (<hActiveObjectType),a	; $2e84
	ld d,FIRST_ENEMY_INDEX	; $2e86
	ld a,d			; $2e88
--
	ldh (<hActiveObject),a	; $2e89
	ld h,d			; $2e8b
	ld l,Enemy.enabled		; $2e8c
	ld a,(hl)		; $2e8e
	or a			; $2e8f
	jr z,@next		; $2e90

	ld l,Enemy.state	; $2e92
	ldi a,(hl)		; $2e94
	or (hl)			; $2e95
	call z,updateEnemy		; $2e96
	ld e,Enemy.oamFlagsBackup		; $2e99
	ld a,(de)		; $2e9b
	inc e			; $2e9c
	ld (de),a		; $2e9d
@next:
	inc d			; $2e9e
	ld a,d			; $2e9f
	cp $e0			; $2ea0
	jr c,--			; $2ea2
	ret			; $2ea4

;;
; Update all enemies by calling their enemy-specific code and doing other common enemy
; stuff.
;
; @addr{2ea5}
updateEnemies:
	ld a,(wScrollMode)		; $2ea5
	and $0e			; $2ea8
	jr nz,_updateEnemiesIfStateIsZero	; $2eaa

	ld a,(wTextIsActive)		; $2eac
	or a			; $2eaf
	jr nz,_updateEnemiesIfStateIsZero	; $2eb0

	ld a,(wDisabledObjects)		; $2eb2
	and $84			; $2eb5
	jr nz,_updateEnemiesIfStateIsZero	; $2eb7

	ld a,(wPaletteThread_mode)		; $2eb9
	or a			; $2ebc
	jr nz,_updateEnemiesIfStateIsZero	; $2ebd

	ld a,Enemy.start	; $2ebf
	ldh (<hActiveObjectType),a	; $2ec1
	ld d,FIRST_ENEMY_INDEX	; $2ec3
	ld a,d			; $2ec5
--
	ldh (<hActiveObject),a	; $2ec6

	ld e,Enemy.enabled	; $2ec8
	ld a,(de)		; $2eca
	or a			; $2ecb
	jr z,@next		; $2ecc

	call updateEnemy		; $2ece

	; Reset bit 7 of var2a to indicate that, if any collision has occurred, it's no
	; longer the first frame of the collision.
	ld h,d			; $2ed1
	ld l,Enemy.var2a		; $2ed2
	res 7,(hl)		; $2ed4

	; Increment/decrement invincibilityCounter if applicable, update palette
	inc l			; $2ed6
	ld a,(hl) ; a = [enemy.invincibilityCounter]
	or a			; $2ed8
	jr z,@label_00_349	; $2ed9

	rlca			; $2edb
	jr c,@label_00_348	; $2edc

	dec (hl)		; $2ede
	jr z,@label_00_349	; $2edf

	ld a,(wFrameCounter)		; $2ee1
	bit 2,a			; $2ee4
	jr nz,@label_00_349	; $2ee6

	ld b,$05		; $2ee8
	ld l,Enemy.oamFlagsBackup		; $2eea
	ldi a,(hl)		; $2eec
	and $07			; $2eed
	cp b			; $2eef
	jr nz,+			; $2ef0
	ld b,$02		; $2ef2
+
	ld a,(hl)		; $2ef4
	and $f8			; $2ef5
	or b			; $2ef7
	ld (hl),a		; $2ef8
	jr @next		; $2ef9

@label_00_348:
	inc (hl)		; $2efb
@label_00_349:
	ld l,Enemy.oamFlagsBackup		; $2efc
	ldi a,(hl)		; $2efe
	ld (hl),a		; $2eff
@next:
	inc d			; $2f00
	ld a,d			; $2f01
	cp LAST_ENEMY_INDEX+1			; $2f02
	jr c,--			; $2f04
	ret			; $2f06

;;
; @param	d	Enemy to update
; @addr{2f07}
updateEnemy:
	call enemyStandardUpdate		; $2f07
	ld e,Enemy.id		; $2f0a
	ld a,(de)		; $2f0c

.ifdef ROM_AGES
	; Calculate bank number in 'b'
	ld b,$0f		; $2f0d
	cp $70			; $2f0f
	jr nc,++			; $2f11
	dec b			; $2f13
	cp $30			; $2f14
	jr nc,++			; $2f16
	dec b			; $2f18
	cp $08			; $2f19
	jr nc,++			; $2f1b
	ld b,$10		; $2f1d

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
	add a			; $2f1f
	add <enemyCodeTable	; $2f20
	ld l,a			; $2f22
	ld a,$00		; $2f23
	adc >enemyCodeTable	; $2f25
	ld h,a			; $2f27

	ldi a,(hl)		; $2f28
	ld h,(hl)		; $2f29
	ld l,a			; $2f2a
.ifdef ROM_AGES
	ld a,b			; $2f2b
	setrombank		; $2f2c
.endif
	ld a,c			; $2f31
	or a			; $2f32
	jp hl			; $2f33

.include "data/enemyCodeTable.s"


.ifdef ROM_AGES
	.include "code/code_3035.s"
.endif


;;
; Called when loading a room.
;
; Note: ages doesn't save the bank number properly when something calls this, so it only
; works when called from bank 1 (same bank as "checkLoadPirateShip").
;
; @addr{30fe}
initializeRoom:

.ifdef ROM_AGES
	callab bank1.clearSolidObjectPositions		; $30fe

	ld a,(wSentBackByStrangeForce)		; $3106
	dec a			; $3109
	jr nz,+			; $310a

	ld b,INTERACID_SCREEN_DISTORTION		; $310c
	jp objectCreateInteractionWithSubid00		; $310e
+
	callab roomInitialization.calculateRoomStateModifier		; $3111
	call   refreshObjectGfx		; $3119
	callab roomSpecificCode.runRoomSpecificCode
	callab roomInitialization.createSeaEffectsPartIfApplicable		; $3124
	callab bank1.checkLoadPirateShip		; $312c

	ldh a,(<hRomBank)	; $3134
	push af			; $3136
	ld a,:roomInitialization.checkAndSpawnMaple		; $3137
	setrombank		; $3139

	call checkSpawnTimeportalInteraction		; $313e

	ld a,(wcc05)		; $3141
	bit 2,a			; $3144
	call nz,roomInitialization.loadRememberedCompanion		; $3146

	ld a,(wcc05)		; $3149
	bit 3,a			; $314c
	call nz,roomInitialization.checkAndSpawnMaple		; $314e

	ld a,:objectData.parseObjectData
	setrombank		; $3153
	ld a,(wcc05)		; $3158
	bit 0,a			; $315b
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

	callfrombank0 staticObjects.parseStaticObjects	; $3160

	pop af			; $316a
	setrombank		; $316b
	ret			; $3170


;;
; @param	hl	Address of interaction data to parse
; @addr{3171}
parseGivenObjectData:
	ldh a,(<hRomBank)	; $3171
	push af			; $3173
	ld a, :objectData.parseGivenObjectData
	setrombank		; $3176
	push de			; $317b
	ld d,h			; $317c
	ld e,l			; $317d
	call objectData.parseGivenObjectData		; $317e
	pop de			; $3181
	pop af			; $3182
	setrombank		; $3183
	ret			; $3188

;;
; Checks if there are any "static objects" in the room to load.
;
; @addr{3189}
loadStaticObjects:
	ldh a,(<hRomBank)	; $3189
	push af			; $318b
	ld a,:staticObjects.loadStaticObjects_body	; $318c
	setrombank		; $318e
	push de			; $3193
	call staticObjects.loadStaticObjects_body		; $3194
	pop de			; $3197
	pop af			; $3198
	setrombank		; $3199
	ret			; $319e

;;
; @addr{319f}
clearStaticObjects:
	ld hl,wStaticObjects		; $319f
	ld b,_sizeof_wStaticObjects	; $31a2
	jp clearMemory		; $31a4

;;
; Search wStaticObjects to find a slot (8 bytes) which is unused.
;
; @param[out]	hl	Address of free slot (if successful)
; @param[out]	zflag	Set on success
; @addr{31a7}
findFreeStaticObjectSlot:
	ld hl,wStaticObjects		; $31a7
.ifdef ROM_AGES
	ld b,$08		; $31aa
.endif
--
	ld a,(hl)		; $31ac
	or a			; $31ad
	ret z			; $31ae

	ld a,$08		; $31af
	add l			; $31b1
	ld l,a			; $31b2
.ifdef ROM_AGES
	dec b			; $31b3
.endif
	jr nz,--		; $31b4

	or h			; $31b6
	ret			; $31b7

;;
; Deletes the object which the relatedObj1 variable points to, assuming it points to
; a "static" object (stored in wStaticObjects).
;
; @addr{31b8}
objectDeleteRelatedObj1AsStaticObject:
	ldh a,(<hActiveObjectType)	; $31b8
	add Object.relatedObj1			; $31ba
	ld l,a			; $31bc
	ld h,d			; $31bd
	ldi a,(hl)		; $31be
	ld h,(hl)		; $31bf
	ld e,l			; $31c0
	ld l,a			; $31c1
	or h			; $31c2
	ret z			; $31c3

	; de still points to relatedObj1; clear it
	xor a			; $31c4
	ld (de),a		; $31c5
	dec e			; $31c6
	ld (de),a		; $31c7

	; Delete the related object (only 8 bytes since it's a static object)
	ld e,$08		; $31c8
--
	ldi (hl),a		; $31ca
	dec e			; $31cb
	jr nz,--		; $31cc
	ret			; $31ce

;;
; Saves an object to a "static object" slot, which persists between rooms.
;
; @param	a	Static object type (see constants/staticObjectTypes.s)
; @param	d	Object
; @param	hl	Address in wStaticObjects
; @addr{31cf}
objectSaveAsStaticObject:
	ld (hl),a		; $31cf
	ldh a,(<hActiveObjectType)	; $31d0
	add Object.relatedObj1			; $31d2
	ld e,a			; $31d4

	ld a,l			; $31d5
	ld (de),a		; $31d6
	inc e			; $31d7
	ld a,h			; $31d8
	ld (de),a		; $31d9

	ld a,(wActiveRoom)		; $31da
	inc hl			; $31dd
	ldi (hl),a		; $31de

	; Store Object.id
	ldh a,(<hActiveObjectType)	; $31df
	inc a			; $31e1
	ld e,a			; $31e2
	ld a,(de)		; $31e3
	ldi (hl),a		; $31e4

	; Store Object.subid
	inc e			; $31e5
	ld a,(de)		; $31e6
	ldi (hl),a		; $31e7

	; Store y,x
	ld a,e			; $31e8
	add Object.yh-Object.subid			; $31e9
	ld e,a			; $31eb
	ld a,(de)		; $31ec
	ldi (hl),a		; $31ed
	inc e			; $31ee
	inc e			; $31ef
	ld a,(de)		; $31f0
	ldi (hl),a		; $31f1
	ret			; $31f2

;;
; @param	a	Global flag to check (see constants/globalFlags.s)
; @addr{31f3}
checkGlobalFlag:
	ld hl,wGlobalFlags		; $31f3
	jp checkFlag		; $31f6

;;
; @param	a	Global flag to set
; @addr{31f9}
setGlobalFlag:
	ld hl,wGlobalFlags		; $31f9
	jp setFlag		; $31fc

;;
; @param	a	Global flag to unset
; @addr{31ff}
unsetGlobalFlag:
	ld hl,wGlobalFlags		; $31ff
	jp unsetFlag		; $3202


;;
; Calls bank2._clearEnemiesKilledList.
;
; @addr{3205}
clearEnemiesKilledList:
	ld h,$00		; $3205
	.ifdef ROM_AGES
	jr ++		; $3207
	.else
	jp ++
	.endif

;;
; Calls bank2._addRoomToEnemiesKilledList.
;
; @addr{3209}
addRoomToEnemiesKilledList:
	ld h,$01		; $3209
	.ifdef ROM_AGES
	jr ++		; $320b
	.else
	jp ++
	.endif

;;
; Marks an enemy as killed so it doesn't respawn for a bit.
; Calls bank2._markEnemyAsKilledInRoom.
;
; @addr{320d}
markEnemyAsKilledInRoom:
	ld h,$02		; $320d
	.ifdef ROM_AGES
	jr ++		; $320f
	.else
	jp ++
	.endif

;;
; Calls bank2._stub_02_77f4. (Unused)
;
; @addr{3211}
func_3211:
	ld h,$03		; $3211
	.ifdef ROM_AGES
	jr ++		; $3213
	.else
	jp ++
	.endif

;;
; Places the numbers $00-$ff into w4RandomBuffer in a random order.
; Calls bank2.generateRandomBuffer.
;
; @addr{3215}
generateRandomBuffer:
	ld h,$04		; $3215
	.ifdef ROM_AGES
	jr ++		; $3217
	.else
	jp ++
	.endif

;;
; Get a random position for an enemy and store it in wEnemyPlacement.enemyPos.
; Calls bank2._getRandomPositionForEnemy.
;
; @param	hFF8B	"Flags" (set when placing an enemy in the editor)
; @addr{3219}
getRandomPositionForEnemy:
	ld h,$05		; $3219
	.ifdef ROM_AGES
	jr ++		; $321b
	.else
	jp ++
	.endif


.ifdef ROM_AGES

;;
; Calls bank2._checkSpawnTimeportalInteraction.
;
; @addr{321d}
checkSpawnTimeportalInteraction:
	ld h,$06		; $321d

.endif

++
	ld l,a			; $321f
	ldh a,(<hRomBank)	; $3220
	push af			; $3222
	callfrombank0 roomInitialization.functionCaller		; $3223
	rl c			; $322d
	pop af			; $322f
	setrombank		; $3230
	srl c			; $3235
	ret			; $3237

;;
; @addr{3238}
clearPaletteFadeVariablesAndRefreshPalettes:
	ld a,$ff		; $3238
	ldh (<hDirtyBgPalettes),a	; $323a
	ldh (<hDirtySprPalettes),a	; $323c
;;
; @addr{323e}
clearPaletteFadeVariables:
	xor a			; $323e
	ld (wPaletteThread_mode),a		; $323f
	ld (wPaletteThread_fadeOffset),a		; $3242
	ldh (<hBgPaletteSources),a	; $3245
	ldh (<hSprPaletteSources),a	; $3247
	ld (wPaletteThread_updateRate),a		; $3249
	ld (wLockBG7Color3ToBlack),a		; $324c
	ld hl,wDirtyFadeBgPalettes		; $324f
	ldi (hl),a		; $3252
	ldi (hl),a		; $3253
	ldi (hl),a		; $3254
	ld (hl),a		; $3255
	ret			; $3256

;;
; @param	a	Amount to divide the speed of the fadeout by
; @addr{3257}
fadeoutToWhiteWithDelay:
	call setPaletteThreadDelay		; $3257
	ld a,$09		; $325a
	ld (wPaletteThread_mode),a		; $325c
	ld a,$01		; $325f
	jr ++			; $3261

;;
; @addr{3263}
fastFadeoutToWhite:
	ld a,$01		; $3263
	ld (wPaletteThread_mode),a		; $3265
	ld a,$03		; $3268
	jr ++			; $326a
;;
; @addr{326c}
fadeoutToWhite:
	ld a,$01		; $326c
	ld (wPaletteThread_mode),a		; $326e
	ld a,$01		; $3271
++
	ld (wPaletteThread_speed),a		; $3273
	xor a			; $3276
	ld (wPaletteThread_fadeOffset),a		; $3277

;;
; Configure all palettes to update from w2FadingBg/SprPalettes, and mark the palettes as
; dirty.
; @addr{327a}
makeAllPaletteUseFading:
	ld a,$ff		; $327a
	ld hl,wDirtyFadeBgPalettes		; $327c
	ldi (hl),a		; $327f
	ldi (hl),a		; $3280
	ldi (hl),a		; $3281
	ld (hl),a		; $3282
	ret			; $3283

;;
; @param	a	Amount to divide the speed of the fadein by
; @addr{3284}
fadeinFromWhiteWithDelay:
	call setPaletteThreadDelay		; $3284
	ld a,$0a		; $3287
	ld (wPaletteThread_mode),a		; $3289
	ld a,$01		; $328c
	jr ++			; $328e

;;
; @addr{3290}
fastFadeinFromWhite:
	ld a,$02		; $3290
	ld (wPaletteThread_mode),a		; $3292
	ld a,$03		; $3295
	jr ++			; $3297

;;
; @addr{3299}
fadeinFromWhite:
	ld a,$02		; $3299
	ld (wPaletteThread_mode),a		; $329b
	ld a,$01		; $329e
++
	ld (wPaletteThread_speed),a		; $32a0
	ld a,$20		; $32a3
	ld (wPaletteThread_fadeOffset),a		; $32a5
	jp makeAllPaletteUseFading		; $32a8

;;
; @param	a	Amount to divide the speed of the fadeout by
; @addr{32ab}
fadeoutToBlackWithDelay:
	call setPaletteThreadDelay		; $32ab
	ld a,$0b		; $32ae
	ld (wPaletteThread_mode),a		; $32b0
	ld a,$01		; $32b3
	jr ++			; $32b5

;;
; @addr{32b7}
fastFadeoutToBlack:
	ld a,$03		; $32b7
	ld (wPaletteThread_mode),a		; $32b9
	ld a,$03		; $32bc
	jr ++			; $32be

;;
; @addr{32c0}
fadeoutToBlack:
	ld a,$03		; $32c0
	ld (wPaletteThread_mode),a		; $32c2
	ld a,$01		; $32c5
++
	ld (wPaletteThread_speed),a		; $32c7
	xor a			; $32ca
	ld (wPaletteThread_fadeOffset),a		; $32cb
	jp makeAllPaletteUseFading		; $32ce

;;
; @param	a	Amount to divide the speed of the fadein by
; @addr{32d1}
fadeinFromBlackWithDelay:
	call setPaletteThreadDelay		; $32d1
	ld a,$0c		; $32d4
	ld (wPaletteThread_mode),a		; $32d6
	ld a,$01		; $32d9
	jr ++			; $32db

;;
; @addr{32dd}
fastFadeinFromBlack:
	ld a,$04		; $32dd
	ld (wPaletteThread_mode),a		; $32df
	ld a,$03		; $32e2
	jr ++			; $32e4

;;
; @addr{32e6}
fadeinFromBlack:
	ld a,$04		; $32e6
	ld (wPaletteThread_mode),a		; $32e8
	ld a,$01		; $32eb
++
	ld (wPaletteThread_speed),a		; $32ed
	ld a,$e0		; $32f0
	ld (wPaletteThread_fadeOffset),a		; $32f2
	jp makeAllPaletteUseFading		; $32f5



.ifdef ROM_AGES

; Room darkening-related code was slightly rewritten in Ages, compared to Seasons?

;;
; Darkens a room half as much as "darkenRoomLightly".
; @addr{32f8}
darkenRoomLightly:
	ld b,$f7		; $32f8
	jr _darkenRoomHelper		; $32fa

;;
; Unused?
;
; @param	a	How much to slow down palette thread
; @addr{32fc}
func_32fc:
	call setPaletteThreadDelay		; $32fc
	ld a,$0d		; $32ff
	ld b,$f0		; $3301
	ld (wPaletteThread_mode),a		; $3303
	ld a,$01		; $3306
	jr _setDarkeningVariables		; $3308

;;

; @param	a	Speed of darkening
; @addr{330a}
darkenRoomWithSpeed:
	ld b,$f0		; $330a
	call _setDarkeningVariables		; $330c
	ld a,$05		; $330f
	ld (wPaletteThread_mode),a		; $3311
	ret			; $3314


;;
; Darkens a room twice as much as "darkenRoomLightly".
; @addr{3315}
darkenRoom:
	ld b,$f0		; $3315

;;
; @param	b	Amount to darken
; @addr{3317}
_darkenRoomHelper:
	ld a,$05		; $3317
	ld (wPaletteThread_mode),a		; $3319
	ld a,$01		; $331c


;;
; @param	a	Speed of darkening
; @param	b	Amount to darken
; @addr{331e}
_setDarkeningVariables:
	ld (wPaletteThread_speed),a		; $331e
	ld a,(wPaletteThread_parameter)		; $3321
	ld (wPaletteThread_fadeOffset),a		; $3324
	ld a,b			; $3327
	ld (wPaletteThread_parameter),a		; $3328

	; Mark BG palettes 2-7 as needing refresh
	ld a,$fc		; $332b
	ld hl,wDirtyFadeBgPalettes		; $332d
	ldi (hl),a		; $3330
	ld (hl),$00		; $3331
	inc l			; $3333
	ldi (hl),a ; [wFadeBgPaletteSources] = $fc
	ld (hl),$00		; $3335
	ret			; $3337

;;
; @addr{3338}
brightenRoomLightly:
	ld b,$f7		; $3338
	ld a,$01		; $333a
	jr _brightenRoomHelper			; $333c

;;
; Unused?
;
; @param	a
; @addr{333e}
func_333e:
	call setPaletteThreadDelay		; $333e
	ld a,$0e		; $3341
	ld b,$00		; $3343
	ld (wPaletteThread_mode),a		; $3345
	ld a,$01		; $3348
	jr _setDarkeningVariables		; $334a

;;
; @param	a	Speed of brightening
; @addr{334c}
brightenRoomWithSpeed:
	ld b,$00		; $334c
	jr _brightenRoomHelper			; $334e

;;
; @addr{3350}
brightenRoom:
	ld b,$00		; $3350
	ld a,$01		; $3352

;;
; @param	a	Speed of brightening
; @param	b	Amount to brighten
; @addr{3354}
_brightenRoomHelper:
	call _setDarkeningVariables		; $3354
	ld a,$06		; $3357
	ld (wPaletteThread_mode),a		; $3359
	ret			; $335c


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
; @addr{335d}
fastFadeinFromWhiteToRoom:
	call fastFadeinFromWhite		; $335d
	ld a,$1e		; $3360
	ld (wPaletteThread_fadeOffset),a		; $3362
--
	ld a,$07		; $3365
	ld (wPaletteThread_mode),a		; $3367
	ret			; $336a

;;
; @addr{336b}
fadeinFromWhiteToRoom:
	call fadeinFromWhite		; $336b
	jr --			; $336e

;;
; Fades between the palettes in w2ColorComponentBuffer1 and w2ColorComponentBuffer2. The
; colors in these palettes apply to the palettes BG2-7.
;
; @addr{3370}
startFadeBetweenTwoPalettes:
	ld a,$08		; $3370
	ld (wPaletteThread_mode),a		; $3372
	ld a,$20		; $3375
	ld (wPaletteThread_fadeOffset),a		; $3377
	ret			; $337a

;;
; @param	a	A value which acts to slow down certain palette fades the higher
;			it is. (Acts like division.)
; @addr{337b}
setPaletteThreadDelay:
	ld (wPaletteThread_counterRefill),a		; $337b
	ld a,$01		; $337e
	ld (wPaletteThread_counter),a		; $3380
	ret			; $3383

;;
; @addr{3384}
paletteFadeThreadStart:
	ld a,:w2TilesetBgPalettes	; $3384
	ld ($ff00+R_SVBK),a	; $3386

	callfrombank0 bank1.paletteFadeHandler	; $3388
	call          bank1.checkLockBG7Color3ToBlack		; $3392

	; Resume this thread in [wPaletteThread_updateRate] frames.
	ld a,(wPaletteThread_updateRate)		; $3395
	or a			; $3398
	jr nz,+			; $3399
	inc a			; $339b
+
	call resumeThreadInAFrames		; $339c
	jr paletteFadeThreadStart		; $339f


;;
; This thread runs all of the interesting, in-game stuff.
;
; @addr{33a1}
mainThreadStart:
	call restartSound		; $33a1
	call stopTextThread		; $33a4

@mainThread:
	; Increment wPlaytimeCounter, the 4-byte counter
	ld hl,wPlaytimeCounter		; $33a7
	inc (hl)		; $33aa
	ldi a,(hl)		; $33ab
	ld (wFrameCounter),a		; $33ac
	jr nz,++
	inc (hl)		; $33b1
	jr nz,++
	inc l			; $33b4
	inc (hl)		; $33b5
	jr nz,++
	inc l			; $33b8
	inc (hl)		; $33b9
++
	callfrombank0 bank1.runGameLogic	; $33ba
	call          drawAllSprites		; $33c4
	call          checkReloadStatusBarGraphics		; $33c7
	call          resumeThreadNextFrame		; $33ca

	jr           @mainThread



.ifdef ROM_SEASONS

updateAnimationsAfterCutscene:
	ldh a,(<hRomBank)
	push af
	callfrombank0 updateAnimations
	pop af
	setrombank
	ret
.endif

;;
; Sets wActiveMusic2 to the appropriate value, and sets wLoadingRoomPack (for present/past
; overworlds only)
;
; @addr{33cf}
loadScreenMusic:
	ldh a,(<hRomBank)	; $33cf
	push af			; $33d1
	ld a,:groupMusicPointerTable
	setrombank		; $33d4

	ld a,(wActiveGroup)		; $33d9
	ld hl,groupMusicPointerTable
	rst_addDoubleIndex			; $33df
	ldi a,(hl)		; $33e0
	ld h,(hl)		; $33e1
	ld l,a			; $33e2
	ld a,(wActiveRoom)		; $33e3
	rst_addAToHl			; $33e6
	ldi a,(hl)		; $33e7
	ld (wActiveMusic2),a		; $33e8

.ifdef ROM_AGES
	ld a,(wActiveGroup)		; $33eb
	cp $02			; $33ee
	jr nc,++

	ld b,a			; $33f2
	ld a,(wActiveRoom)		; $33f3
	ld c,a			; $33f6
	ld hl,roomPackData		; $33f7
	add hl,bc		; $33fa
	ldi a,(hl)		; $33fb
	ld (wLoadingRoomPack),a		; $33fc
++
	pop af			; $33ff
	setrombank		; $3400
	ret			; $3405

.else; ROM_SEASONS

	ld a,(wActiveGroup)
	or a
	jr nz,++

	ld a,(wActiveRoom)
	ld hl,roomPackData
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
	ldh a,(<hRomBank)	; $32be
	push af			; $32c0
	callfrombank0 applyWarpDest_b04		; $32c1

.ifdef ROM_SEASONS
	callfrombank0 $01 $578d		; $32cb
.endif

	pop af			; $32d5
	setrombank		; $32d6
	ret			; $32db


;;
; - Calls loadScreenMusic
; - Copies wActiveRoom to wLoadingRoom
; - Copies wLoadingRoomPack to wRoomPack (for group 0 only)
;
; @addr{341a}
loadScreenMusicAndSetRoomPack:
	call loadScreenMusic		; $341a
	ld a,(wActiveRoom)		; $341d
	ld (wLoadingRoom),a		; $3420
	ld a,(wActiveGroup)		; $3423
	or a			; $3426
	ret nz			; $3427

	ld a,(wLoadingRoomPack)		; $3428
.ifdef ROM_AGES
	and $7f			; $342b
.endif
	ld (wRoomPack),a		; $342d
	ret			; $3430

;;
; @addr{3431}
dismountCompanionAndSetRememberedPositionToScreenCenter:
	ldh a,(<hRomBank)	; $3431
	push af			; $3433
	ld a,:bank5.companionDismount		; $3434
	setrombank		; $3436

	ld de,w1Companion		; $343b
	ld a,e			; $343e
	ldh (<hActiveObjectType),a	; $343f
	ld a,d			; $3441
	ldh (<hActiveObject),a	; $3442

	call bank5.companionDismount		; $3444
	call bank5.saveLinkLocalRespawnAndCompanionPosition		; $3447

	; After saving the companion's position, overwrite it with values for the center
	; of the screen?
	ld a,$38		; $344a
	ld (wRememberedCompanionY),a		; $344c
	ld a,$50		; $344f
	ld (wRememberedCompanionX),a		; $3451

	pop af			; $3454
	setrombank		; $3455
	ret			; $345a

.ifdef ROM_SEASONS

seasonsFunc_331b:
	ldh a,(<hRomBank)	; $331b
	push af			; $331d
	callfrombank0 seasonsFunc_0f_6f75
	pop af			; $3328
	setrombank
	ret			; $332e

seasonsFunc_332f:
	ldh a,(<hRomBank)	; $332f
	push af			; $3331
	ld a,$0f		; $3332
	setrombank
	call seasonsFunc_0f_704d		; $3339
	call seasonsFunc_0f_7182		; $333c
	pop af			; $333f
	setrombank
	ret			; $3345

flameOfDestructionsCutsceneCaller:
	ldh a,(<hRomBank)	; $3346
	push af			; $3348
	callfrombank0 flameOfDestructionCutsceneBody
	pop af			; $3353
	setrombank
	ret			; $3359

zeldaAndVillagersCutsceneCaller:
	ldh a,(<hRomBank)	; $335a
	push af			; $335c
	callfrombank0 zeldaAndVillagersCutsceneBody
	pop af			; $3367
	setrombank
	ret			; $336d

zeldaKidnappedCutsceneCaller:
	ldh a,(<hRomBank)	; $336e
	push af			; $3370
	callfrombank0 zeldaKidnappedCutsceneBody
	pop af			; $337b
	setrombank
	ret			; $3381

.endif

;;
; TODO: give this a better name
;
; @addr{345b}
updateAllObjects:
	ldh a,(<hRomBank)	; $345b
	push af			; $345d
	callfrombank0 bank5.updateSpecialObjects		; $3465
	callfrombank0 itemCode.updateItems		; $346f
	call          setEnemyTargetToLinkPosition		; $3472
	callfrombank0 updateEnemies		; $347c
	callfrombank0 partCode.updateParts		; $3486
	callfrombank0 updateInteractions		; $3490
	callfrombank0 bank1.func_4000		; $349a

	; Call func_410d if Link is riding something
	ld a,:bank5.func_410d		; $349d
	setrombank		; $349f
	ld a,(wLinkObjectIndex)		; $34a4
	rrca			; $34a7
	call c,bank5.func_410d		; $34a8

	ld a,:bank6.updateGrabbedObjectPosition		; $34ab
	setrombank		; $34ad
	ld a,(wLinkGrabState)		; $34b2
	rlca			; $34b5
	call c,bank6.updateGrabbedObjectPosition		; $34b6

	call loadLinkAndCompanionAnimationFrame		; $34b9

	callfrombank0 itemCode.updateItemsPost		; $34c3
	callfrombank0 bank1.checkUpdateFollowingLinkObject		; $34cd
	callfrombank0 updateCamera		; $34d7
	callfrombank0 updateChangedTileQueue		; $34e1
	callfrombank0 updateAnimations		; $34eb

	xor a			; $34ee
	ld (wc4b6),a		; $34ef
	pop af			; $34f2
	setrombank		; $34f3
	ret			; $34f8

;;
; @addr{34f9}
updateSpecialObjectsAndInteractions:
	ldh a,(<hRomBank)	; $34f9
	push af			; $34fb
	callfrombank0 bank5.updateSpecialObjects		; $34fc
	callfrombank0 updateInteractions	; $350d
	call          loadLinkAndCompanionAnimationFrame		; $3510
	xor a			; $3513
	ld (wc4b6),a		; $3514
	pop af			; $3517
	setrombank		; $3518
	ret			; $351d

;;
; @addr{351e}
updateInteractionsAndDrawAllSprites:
	ldh a,(<hRomBank)	; $351e
	push af			; $3520
	callfrombank0 updateInteractions		; $3528
	call drawAllSprites		; $352b
	xor a			; $352e
	ld (wc4b6),a		; $352f
	pop af			; $3532
	setrombank		; $3533
	ret			; $3538

;;
; Similar to updateAllObjects but calls a bit less
;
; @addr{3539}
func_3539:
	ldh a,(<hRomBank)	; $3539
	push af			; $353b
	callfrombank0 bank5.updateSpecialObjects		; $353c
.ifdef ROM_AGES
	callfrombank0 itemCode.updateItems		; $3546
	callfrombank0 updateEnemies		; $3557
	callfrombank0 partCode.updateParts		; $355a
	callfrombank0 updateInteractions		; $356b
	callfrombank0 itemCode.updateItemsPost		; $356e
.else
	callfrombank0 updateEnemies		; $3557
	callfrombank0 updateInteractions		; $356b
.endif
	callfrombank0 loadLinkAndCompanionAnimationFrame		; $3578
	callfrombank0 updateAnimations
	xor a			; $358c
	ld (wc4b6),a		; $358d
	pop af			; $3590
	setrombank		; $3591
	ret			; $3596

.ifdef ROM_SEASONS

;;
seasonsFunc_34a0:
	ld a,($ff00+$97)	; $34a0
	push af			; $34a2
	callfrombank0 $05 $4000		; $34a3
	callfrombank0 $07 $485a		; $34ad
	callfrombank0 updateEnemies		; $34b7
	callfrombank0 $10 $61dc		; $34c1
	callfrombank0 updateInteractions		; $34cb
	callfrombank0 $0f $7159		; $34d5

	ld a,$06		; $34df
	setrombank		; $34e1
	ld a,($cc75)		; $34e6
	rlca			; $34e9
	call c,$5429		; $34ea

	call loadLinkAndCompanionAnimationFrame		; $34ed
	callfrombank0 $07 $4902		; $34f0
	callfrombank0 $0f $7182		; $34fa
	callfrombank0 $04 $6b25		; $3504

	xor a			; $350e
	ld ($c4b6),a		; $350f

	pop af			; $3512
	setrombank		; $3513
	ret			; $3518

.endif

;;
; @addr{3597}
clearWramBank1:
	xor a			; $3597
	ld ($ff00+R_SVBK),a	; $3598
	ld hl,$d000		; $359a
	ld bc,$1000		; $359d
	jp clearMemoryBc		; $35a0

;;
; Clear $30 bytes of ram related to information about the current screen, as
; well as clearing wram bank 1.
; @addr{35a3}
clearScreenVariablesAndWramBank1:
	call clearWramBank1		; $35a3
;;
; @addr{35a6}
clearScreenVariables:
	ld hl,wScreenVariables	; $35a6
	ld b,wScreenVariables.size	; $35a9
	call clearMemory		; $35ab
	ld a,$ff		; $35ae
	ld (wLoadedTilesetUniqueGfx),a		; $35b0
	ld (wLoadedTilesetLayout),a		; $35b3
	ld (wLoadedTilesetAnimation),a		; $35b6
	ret			; $35b9

;;
; @addr{35ba}
clearLinkObject:
	ld hl,w1Link		; $35ba
	ld b,$40		; $35bd
	jp clearMemory		; $35bf

;;
; @addr{35c2}
clearReservedInteraction0:
	ld hl,w1ReservedInteraction0		; $35c2
	ld b,$40		; $35c5
	call clearMemory		; $35c7

;;
; Unused?
;
; @addr{35ca}
clearReservedInteraction1:
	ld hl,w1ReservedInteraction1		; $35ca
	ld b,$40		; $35cd
	jp clearMemory		; $35cf

;;
; Clear all interactions except wReservedInteraction0 and wReservedInteraction1.
;
; @addr{35d2}
clearDynamicInteractions:
	ldde FIRST_DYNAMIC_INTERACTION_INDEX, Interaction.start	; $35d2
--
	ld h,d			; $35d5
.ifdef ROM_AGES
	ld l,e			; $35d6
.else
	ld l,Interaction.start
.endif
	ld b,$40		; $35d7
	call clearMemory		; $35d9
	inc d			; $35dc
	ld a,d			; $35dd
	cp $e0			; $35de
	jr c,--			; $35e0
	ret			; $35e2

;;
; @addr{35e3}
clearItems:
	ldde FIRST_ITEM_INDEX, Item.start	; $35e3
--
	ld h,d			; $35e6
.ifdef ROM_AGES
	ld l,e			; $35e7
.else
	ld l,Item.start
.endif
	ld b,$40		; $35e8
	call clearMemory		; $35ea
	inc d			; $35ed
	ld a,d			; $35ee
	cp $e0			; $35ef
	jr c,--			; $35f1
	ret			; $35f3

;;
; @addr{35f4}
clearEnemies:
	ldde FIRST_ENEMY_INDEX, Enemy.start	; $35f4
--
	ld h,d			; $35f7
.ifdef ROM_AGES
	ld l,e			; $35f8
.else
	ld l,Enemy.start
.endif
	ld b,$40		; $35f9
	call clearMemory		; $35fb
	inc d			; $35fe
	ld a,d			; $35ff
	cp $e0			; $3600
	jr c,--			; $3602
	ret			; $3604

;;
; @addr{3605}
clearParts:
	ldde FIRST_PART_INDEX, Part.start		; $3605
--
	ld h,d			; $3608
.ifdef ROM_AGES
	ld l,e			; $3609
.else
	ld l,Part.start
.endif
	ld b,$40		; $360a
	call clearMemory		; $360c
	inc d			; $360f
	ld a,d			; $3610
	cp $e0			; $3611
	jr c,--			; $3613
	ret			; $3615

;;
; @addr{3616}
setEnemyTargetToLinkPosition:
	ld a,(wLinkObjectIndex)		; $3616
	ld h,a			; $3619
	ld l,<w1Link.yh		; $361a
	ldi a,(hl)		; $361c
	ldh (<hEnemyTargetY),a	; $361d
	inc l			; $361f
	ld a,(hl)		; $3620
	ldh (<hEnemyTargetX),a	; $3621
	ld a,(wScentSeedActive)		; $3623
	or a			; $3626
	ret nz			; $3627

	ld l,<w1Link.yh		; $3628
	ldi a,(hl)		; $362a
	ldh (<hFFB2),a	; $362b
	inc l			; $362d
	ld a,(hl)		; $362e
	ldh (<hFFB3),a	; $362f
	ret			; $3631

;;
; @addr{3632}
getEntryFromObjectTable2:

.ifdef ROM_AGES
	ldh a,(<hRomBank)	; $3632
	push af			; $3634
	ld a, :objectData.objectTable2
	setrombank		; $3637
	ld a,b			; $363c
	ld hl, objectData.objectTable2
	rst_addDoubleIndex			; $3640
	ldi a,(hl)		; $3641
	ld h,(hl)		; $3642
	ld l,a			; $3643
	pop af			; $3644
	setrombank		; $3645
	ret			; $364a

.else ; ROM_SEASONS

seasonsFunc_35b8:
	ld a,($ff00+$97)	; $35b8
	push af			; $35ba
	callfrombank0 $03 $72ff
	pop af			; $35c5
	ld ($ff00+$97),a	; $35c6
	ld ($2222),a		; $35c8
	ret			; $35cb

.endif


.ifdef ROM_AGES

;;
; Check if a dungeon uses those toggle blocks with the orbs.
;
; @param[out]	z	Set if the dungeon does not use toggle blocks.
; @addr{364b}
checkDungeonUsesToggleBlocks:
	ld a,(wDungeonIndex)		; $364b
	cp $ff			; $364e
	ret z			; $3650

	ld hl,dungeonsUsingToggleBlocks		; $3651
	jp checkFlag		; $3654

	.include "data/dungeonsUsingToggleBlocks.s"

.else ; ROM_SEASONS
seasonsFunc_35cc:
	ld a,($ff00+$70)	; $35cc
	ld c,a			; $35ce
	ld a,($ff00+$97)	; $35cf
	ld b,a			; $35d1
	push bc			; $35d2
	ld a,$02		; $35d3
	ld ($ff00+$70),a	; $35d5
	callfrombank0 bank1.paletteThread_calculateFadingPalettes
	pop bc			; $35e1
	ld a,b			; $35e2
	ld ($ff00+$97),a	; $35e3
	ld ($2222),a		; $35e5
	ld a,c			; $35e8
	ld ($ff00+$70),a	; $35e9
	ret			; $35eb

func_35ec:
	ld a,($ff00+$97)	; $35ec
	push af			; $35ee
	callfrombank0 $01 $565d
	pop af			; $35f9
	setrombank
	ret			; $35ff

.endif

;;
; Load data into wAnimationState, wAnimationPointerX, etc.
;
; @param	a	Value of wTilesetAnimation
; @addr{3659}
loadAnimationData:
	ld b,a			; $3659
	ldh a,(<hRomBank)	; $365a
	push af			; $365c
	ld a,:animationGroupTable
	setrombank		; $365f
	ld a,b			; $3664
	ld hl,animationGroupTable		; $3665
	rst_addDoubleIndex			; $3668
	ldi a,(hl)		; $3669
	ld h,(hl)		; $366a
	ld l,a			; $366b
	ldi a,(hl)		; $366c
	ld (wAnimationState),a		; $366d
	push de			; $3670
	ld de,wAnimationCounter1		; $3671
	call @helper		; $3674
	ld de,wAnimationCounter2		; $3677
	call @helper		; $367a
	ld de,wAnimationCounter3		; $367d
	call @helper		; $3680
	ld de,wAnimationCounter4		; $3683
	call @helper		; $3686
	pop de			; $3689
	pop af			; $368a
	setrombank		; $368b
	xor a			; $3690
	ld (wAnimationQueueHead),a		; $3691
	ld (wAnimationQueueTail),a		; $3694
	ret			; $3697

;;
; @addr{3698}
@helper:
	push hl			; $3698
	ldi a,(hl)		; $3699
	ld h,(hl)		; $369a
	ld l,a			; $369b
	ldi a,(hl)		; $369c
	ld (de),a		; $369d
	inc de			; $369e
	ld a,l			; $369f
	ld (de),a		; $36a0
	inc de			; $36a1
	ld a,h			; $36a2
	ld (de),a		; $36a3
	pop hl			; $36a4
	inc hl			; $36a5
	inc hl			; $36a6
	ret			; $36a7


.ifdef ROM_SEASONS

roomTileChangesAfterLoad02:
	ld a,($ff00+$97)	; $364f
	push af			; $3651
	callfrombank0 roomTileChangesAfterLoad02_body
	pop af			; $365c
	ld ($ff00+$97),a	; $365d
	ld ($2222),a		; $365f
	ret			; $3662

.endif

;;
; See the comments for roomGfxChanges.getIndexOfGashaSpotInRoom_body.
;
; @param	a	Room
; @param[out]	c	Bit 7 set if something is planted in the given room.
;			(This is the value of the 'f' register after the function call.)
; @addr{36a8}
getIndexOfGashaSpotInRoom:
	ld c,a			; $36a8
	ldh a,(<hRomBank)	; $36a9
	push af			; $36ab

	ld a,:roomGfxChanges.getIndexOfGashaSpotInRoom_body		; $36ac
	setrombank		; $36ae
	ld a,c			; $36b3
	call roomGfxChanges.getIndexOfGashaSpotInRoom_body		; $36b4

	push af			; $36b7
	pop bc			; $36b8
	pop af			; $36b9
	setrombank		; $36ba
	ret			; $36bf


.ifdef ROM_AGES

;;
; The name is a bit of a guess.
;
; Returns 2 if an event is triggered in part of the forest (map $90?), 1 if the maku
; tree has spoken to you outside d3, 0 otherwise.
;
; @param[out]	a	Black tower progress (0-2)
; @param[out]	zflag	z if black tower is still in early stages (npcs hanging around)
; @addr{36c0}
getBlackTowerProgress:
	push bc			; $36c0
	ld c,$02		; $36c1
	ld a,(wPresentRoomFlags+$90)		; $36c3
	bit ROOMFLAG_BIT_40,a			; $36c6
	jr nz,++		; $36c8

	dec c			; $36ca
	ld a,(wPresentRoomFlags+$ba)		; $36cb
	bit ROOMFLAG_BIT_40,a			; $36ce
	jr nz,++		; $36d0

	dec c			; $36d2
++
	ld a,c			; $36d3
	pop bc			; $36d4
	ret			; $36d5

.endif

; A table of addresses in vram. The index is a row (of 16 pixels), and the corresponding
; value is the address of the start of that row.
; @addr{36d6}
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
; @addr{36f6}
func_36f6:
	and $03			; $36f6
	ld (wRoomStateModifier),a		; $36f8
	ld a,b			; $36fb
	ld (wActiveGroup),a		; $36fc
	ld a,c			; $36ff
	ld (wActiveRoom),a		; $3700
	call loadScreenMusicAndSetRoomPack		; $3703
	call loadTilesetData		; $3706
	call loadTilesetGraphics		; $3709
	call loadTilesetAndRoomLayout		; $370c
	jp generateVramTilesWithRoomChanges		; $370f

;;
; Loads the tileset (assumes wTilesetLayout is already set to the desired value).
;
; End result: w3TileMappingData is loaded with the tile indices and attributes for all
; tiles in the tileset.
;
; @addr{3712}
loadTilesetLayout:
	ld a,(wTilesetLayout)		; $3712
	call loadTileset		; $3715
	ld a,:tileMappingTable
	setrombank		; $371a

	ld a,:w3TileMappingData
	ld ($ff00+R_SVBK),a	; $3721
	ld hl,w3TileMappingIndices
	ld de,w3TileMappingData
	ld b,$00		; $3729
-
	push bc			; $372b
	call @helper		; $372c
	pop bc			; $372f
	dec b			; $3730
	jr nz,-

.ifdef ROM_SEASONS
	xor a
	ld ($ff00+R_SVBK),a
	ret

.else ; ROM_AGES
	jpab setPastCliffPalettesToRed		; $3733
.endif

;;
; @addr{373b}
@helper:
	; bc = tile mapping index
	ldi a,(hl)		; $373b
	ld c,a			; $373c
	ldi a,(hl)		; $373d
	ld b,a			; $373e

	; Get address of pointers to tile indices / attributes
	push hl			; $373f
	ld hl, tileMappingTable
	add hl,bc		; $3743
	add hl,bc		; $3744
	add hl,bc		; $3745

	; Load tile indices
	ldi a,(hl)		; $3746
	ld c,a			; $3747
	ld a,(hl)		; $3748
	swap a			; $3749
	and $0f			; $374b
	ld b,a			; $374d
	push hl			; $374e
	ld hl,tileMappingIndexDataPointer
	ldi a,(hl)		; $3752
	ld h,(hl)		; $3753
	ld l,a			; $3754
	add hl,bc		; $3755
	add hl,bc		; $3756
	add hl,bc		; $3757
	add hl,bc		; $3758
	ld b,$04		; $3759
	call copyMemory		; $375b

	; Load tile attributes
	pop hl			; $375e
	ldi a,(hl)		; $375f
	and $0f			; $3760
	ld b,a			; $3762
	ld c,(hl)		; $3763
	ld hl,tileMappingAttributeDataPointer
	ldi a,(hl)		; $3767
	ld h,(hl)		; $3768
	ld l,a			; $3769
	add hl,bc		; $376a
	add hl,bc		; $376b
	add hl,bc		; $376c
	add hl,bc		; $376d
	ld b,$04		; $376e
	call copyMemory		; $3770

	pop hl			; $3773
	ret			; $3774


;;
; Loads the address of unique header gfx (a&$7f) into wUniqueGfxHeaderAddress.
;
; @param	a	Unique gfx header (see constants/uniqueGfxHeaders.s).
;			Bit 7 is ignored.
; @addr{3775}
loadUniqueGfxHeader:
	and $7f			; $3775
	ld b,a			; $3777
	ldh a,(<hRomBank)	; $3778
	push af			; $377a
	ld a,:uniqueGfxHeaderTable	; $377b
	setrombank		; $377d
	ld a,b			; $3782
	ld hl,uniqueGfxHeaderTable		; $3783
	rst_addDoubleIndex			; $3786
	ldi a,(hl)		; $3787
	ld (wUniqueGfxHeaderAddress),a		; $3788
	ld a,(hl)		; $378b
	ld (wUniqueGfxHeaderAddress+1),a		; $378c
	pop af			; $378f
	setrombank		; $3790
	ret			; $3795

;;
; Load all graphics based on wTileset variables.
;
; @addr{3796}
loadTilesetGraphics:
	ldh a,(<hRomBank)	; $3796
	push af			; $3798

	ld a,(wTilesetGfx)		; $3799
	call loadGfxHeader		; $379c
	ld a,(wTilesetPalette)		; $379f
	call loadPaletteHeader		; $37a2

	call          loadTilesetUniqueGfx		; $37a5
	callfrombank0 initializeAnimations	; $37a8

.ifdef ROM_AGES
	callab        roomGfxChanges.func_02_7a77		; $37b2
	callab        roomGfxChanges.checkLoadPastSignAndChestGfx		; $37ba
.endif

	ld a,(wTilesetUniqueGfx)		; $37c2
	ld (wLoadedTilesetUniqueGfx),a		; $37c5
	ld a,(wTilesetPalette)		; $37c8
	ld (wLoadedTilesetPalette),a		; $37cb
	ld a,(wTilesetAnimation)		; $37ce
	ld (wLoadedTilesetAnimation),a		; $37d1

	pop af			; $37d4
	setrombank		; $37d5
	ret			; $37da

;;
; Loads one entry from the gfx header if [wTilesetUniqueGfx] != [wLoadedTilesetUniqueGfx].
;
; This should be called repeatedly (once per frame, to avoid overloading vblank) until all
; entries in the header are read.
;
; @param	wUniqueGfxHeaderAddress	Where to read the header from (will be updated)
; @param[out]	cflag			Set if there are more entries to load.
; @addr{37db}
updateTilesetUniqueGfx:
	ld a,(wTilesetUniqueGfx)		; $37db
	or a			; $37de
	ret z			; $37df

	ld b,a			; $37e0
	ld a,(wLoadedTilesetUniqueGfx)		; $37e1
	cp b			; $37e4
	ret z			; $37e5

	ldh a,(<hRomBank)	; $37e6
	push af			; $37e8

	ld hl,wUniqueGfxHeaderAddress		; $37e9
	ldi a,(hl)		; $37ec
	ld h,(hl)		; $37ed
	ld l,a			; $37ee
	ld a,:uniqueGfxHeadersStart
	setrombank		; $37f1
	call loadUniqueGfxHeaderEntry		; $37f6
	ld c,a			; $37f9
	ld a,l			; $37fa
	ld (wUniqueGfxHeaderAddress),a		; $37fb
	ld a,h			; $37fe
	ld (wUniqueGfxHeaderAddress+1),a		; $37ff

	pop af			; $3802
	setrombank		; $3803
	ld a,c			; $3808
	add a			; $3809
	ret			; $380a

;;
; Load just the first entry of a unique gfx header?
;
; Unused?
;
; @param	a	Unique gfx header index
; @addr{380b}
uniqueGfxFunc_380b:
	ld b,a			; $380b
	ldh a,(<hRomBank)	; $380c
	push af			; $380e

	ld a,:uniqueGfxHeadersStart
	setrombank		; $3811
	ld a,b			; $3816
	ld hl,uniqueGfxHeaderTable		; $3817
	rst_addDoubleIndex			; $381a
	ldi a,(hl)		; $381b
	ld h,(hl)		; $381c
	ld l,a			; $381d
	call loadUniqueGfxHeaderEntry		; $381e

	pop af			; $3821
	setrombank		; $3822
	ret			; $3827

;;
; @addr{3828}
loadTilesetUniqueGfx:
	ld a,:uniqueGfxHeaderTable	; $3828
	setrombank		; $382a
	ld a,(wTilesetUniqueGfx)		; $382f
	and $7f			; $3832
	ret z			; $3834

	ld hl,uniqueGfxHeaderTable		; $3835
	rst_addDoubleIndex			; $3838
	ldi a,(hl)		; $3839
	ld h,(hl)		; $383a
	ld l,a			; $383b
-
	call loadUniqueGfxHeaderEntry		; $383c
	add a			; $383f
	jr c,-
	ret			; $3842

;;
; Loads a single gfx header entry at hl. This should be called multiple times until all
; entries are read.
;
; If the first byte (bank+mode) is zero, it loads a palette instead.
;
; @param[out]	a	Last byte of the entry (bit 7 set if there's another entry)
; @addr{3843}
loadUniqueGfxHeaderEntry:
	ldi a,(hl)		; $3843
	or a			; $3844
	jr z,@loadPaletteIndex

	ld c,a			; $3847
	ldh (<hFF8C),a	; $3848
	ldi a,(hl)		; $384a
	ld b,a			; $384b
	ldi a,(hl)		; $384c
	ld c,a			; $384d
	ldi a,(hl)		; $384e
	ld d,a			; $384f
	ldi a,(hl)		; $3850
	ld e,a			; $3851
	ld a,(hl)		; $3852
	and $7f			; $3853
	ldh (<hFF8D),a	; $3855
	push hl			; $3857
	push de			; $3858
	ld l,c			; $3859
	ld h,b			; $385a
	ld b,a			; $385b
	ldh a,(<hFF8C)	; $385c
	ld c,a			; $385e
	ld de,$d807		; $385f
	call decompressGraphics		; $3862
	pop de			; $3865
	ld hl,$d800		; $3866
	ld c,$07		; $3869
	ldh a,(<hFF8D)	; $386b
	ld b,a			; $386d
	call queueDmaTransfer		; $386e
	pop hl			; $3871
	ld a,$00		; $3872
	ld ($ff00+R_SVBK),a	; $3874
	ld a,:uniqueGfxHeaderTable	; $3876
	setrombank		; $3878
	ldi a,(hl)		; $387d
	ret			; $387e

@loadPaletteIndex:
	push hl			; $387f
	ld a,(hl)		; $3880
	and $7f			; $3881
	call loadPaletteHeader		; $3883
	pop hl			; $3886
	ldi a,(hl)		; $3887
	ret			; $3888

;;
; @addr{3889}
loadTilesetData:
	ldh a,(<hRomBank)	; $3889
	push af			; $388b

	callfrombank0 loadTilesetData_body
	callab        bank2.updateTilesetFlagsForIndoorRoomInAltWorld		; $3896

	pop af			; $389e
	setrombank		; $389f
	ret			; $38a4

;;
; @addr{38a5}
loadTilesetAndRoomLayout:
	ldh a,(<hRomBank)	; $38a5
	push af			; $38a7

	; Reload tileset if necessary
	ld a,(wLoadedTilesetLayout)		; $38a8
	ld b,a			; $38ab
	ld a,(wTilesetLayout)		; $38ac
	cp b			; $38af
	ld (wLoadedTilesetLayout),a		; $38b0
	call nz,loadTilesetLayout		; $38b3

.ifdef ROM_SEASONS
	call seasonsFunc_3870
.endif
	; Load the room layout and apply any dynamic changes necessary
	call          loadRoomLayout		; $38b6

	callfrombank0 applyAllTileSubstitutions		; $38b9

	; Copy wRoomLayout to w3RoomLayoutBuffer
	ld a,:w3RoomLayoutBuffer		; $38c3
	ld ($ff00+R_SVBK),a	; $38c5
	ld hl,w3RoomLayoutBuffer		; $38c7
	ld de,wRoomLayout		; $38ca
	ld b,_sizeof_wRoomLayout		; $38cd
	call copyMemoryReverse		; $38cf

	xor a			; $38d2
	ld ($ff00+R_SVBK),a	; $38d3
	pop af			; $38d5
	setrombank		; $38d6
	ret			; $38db

.ifdef ROM_SEASONS

seasonsFunc_3870:
	ld a,GLOBALFLAG_S_15		; $3870
	call checkGlobalFlag		; $3872
	ret z			; $3875
	callfrombank0 $04 $6cff		; $3876
	ret nc			; $3880
	ld a,($cc4e)		; $3881
	ld hl,@data		; $3884
	rst $10			; $3887
	ld a,($cc4c)		; $3888
	add (hl)		; $388b
	ld ($cc4b),a		; $388c
	ret			; $388f

@data:
	.db $bc $c0 $c4 $c8

.endif


;;
; Load room layout into wRoomLayout using the relevant RAM addresses (wTilesetLayoutGroup,
; wLoadingRoom, etc)
;
; @addr{38dc}
loadRoomLayout:
	ld hl,wRoomLayout		; $38dc
	ld b,(LARGE_ROOM_HEIGHT+1)*16		; $38df
	call clearMemory		; $38e1
	ld a,:roomLayoutGroupTable
	setrombank		; $38e6
	ld a,(wTilesetLayoutGroup)		; $38eb
	add a			; $38ee
	add a			; $38ef
	ld hl,roomLayoutGroupTable
	rst_addDoubleIndex			; $38f3
	ldi a,(hl)		; $38f4
	ld b,a			; $38f5
	ldi a,(hl)		; $38f6
	ldh (<hFF8D),a	; $38f7
	ldi a,(hl)		; $38f9
	ldh (<hFF8E),a	; $38fa
	ldi a,(hl)		; $38fc
	ldh (<hFF8F),a	; $38fd
	ldi a,(hl)		; $38ff
	ldh (<hFF8C),a	; $3900
	ldi a,(hl)		; $3902
	ld h,(hl)		; $3903
	ld l,a			; $3904
	ldh a,(<hFF8C)	; $3905
	setrombank		; $3907
	push hl			; $390c
	ld a,b			; $390d
	rst_jumpTable			; $390e
	.dw @loadLargeRoomLayout
	.dw @loadSmallRoomLayout

;;
; @addr{3913}
@loadLargeRoomLayoutHlpr:
	ld d,b			; $3913
	ld a,b			; $3914
	and $0f			; $3915
	ld b,a			; $3917

	; Get relative offset in hl
	ldh a,(<hFF8F)	; $3918
	ld h,a			; $391a
	ldh a,(<hFF8E)	; $391b
	ld l,a			; $391d

	add hl,bc		; $391e
	ld a,d			; $391f
	swap a			; $3920
	and $0f			; $3922
	add $03			; $3924
	ld b,a			; $3926
	ret			; $3927

;;
; @addr{3928}
@loadLargeRoomLayout:
	ldh a,(<hFF8F)	; $3928
	ld h,a			; $392a
	ldh a,(<hFF8E)	; $392b
	ld l,a			; $392d
	ld bc,$1000		; $392e
	add hl,bc		; $3931
	ldh a,(<hFF8D)	; $3932
	setrombank		; $3934

	ld a,(wLoadingRoom)		; $3939
	rst_addDoubleIndex			; $393c
	ldi a,(hl)		; $393d
	ld h,(hl)		; $393e
	ld l,a			; $393f

	pop bc			; $3940
	add hl,bc		; $3941
	ld bc,-$200		; $3942
	add hl,bc		; $3945
	call @loadLayoutData		; $3946
	ld de,wRoomLayout		; $3949
@next8:
	ldi a,(hl)		; $394c
	ld b,$08		; $394d
@next:
	rrca			; $394f
	ldh (<hFF8B),a	; $3950
	jr c,+
	ldi a,(hl)		; $3954
	ld (de),a		; $3955
	inc e			; $3956
	ld a,e			; $3957
	cp LARGE_ROOM_HEIGHT*16			; $3958
	ret z			; $395a
--
	ldh a,(<hFF8B)	; $395b
	dec b			; $395d
	jr nz,@next
	jr @next8
+
	push bc			; $3962
	ldi a,(hl)		; $3963
	ld c,a			; $3964
	ldi a,(hl)		; $3965
	ld b,a			; $3966
	push hl			; $3967
	call @loadLargeRoomLayoutHlpr		; $3968
	ld d,>wRoomLayout		; $396b
	ldh a,(<hFF8D) ; Relative offset bank number
	setrombank		; $396f
-
	ldi a,(hl)		; $3974
	ld (de),a		; $3975
	inc e			; $3976
	ld a,e			; $3977
	cp LARGE_ROOM_HEIGHT*16			; $3978
	jr z,+
	dec b			; $397c
	jr nz,-
	pop hl			; $397f
	pop bc			; $3980
	jr --
+
	pop hl			; $3983
	pop bc			; $3984
	ret			; $3985

;;
; @addr{3986}
@loadSmallRoomLayout:
	ldh a,(<hFF8D)	; $3986
	setrombank		; $3988
	ldh a,(<hFF8E)	; $398d
	ld l,a			; $398f
	ldh a,(<hFF8F)	; $3990
	ld h,a			; $3992
	ld a,(wLoadingRoom)		; $3993
	rst_addDoubleIndex			; $3996

	; Get relative offset of layout data in hl
	ldi a,(hl)		; $3997
	ld c,a			; $3998
	ld a,(hl)		; $3999
	ld e,a			; $399a
	and $3f			; $399b
	ld b,a			; $399d

	; Add relative offset with base offset
	pop hl			; $399e
	add hl,bc		; $399f
	call @loadLayoutData		; $39a0

	; Upper bits of relative offset specify compression
	bit 7,e			; $39a3
	jr nz,@decompressLayoutMode2	; $39a5
	bit 6,e			; $39a7
	jr nz,@decompressLayoutMode1

	; Uncompressed; just copy to wRoomLayout unmodified
	ld de,wRoomLayout		; $39ab
	ldbc SMALL_ROOM_WIDTH, SMALL_ROOM_HEIGHT		; $39ae
--
	push bc			; $39b1
-
	ldi a,(hl)		; $39b2
	ld (de),a		; $39b3
	inc e			; $39b4
	dec b			; $39b5
	jr nz,-

	ld a,e			; $39b8
	add $10-SMALL_ROOM_WIDTH			; $39b9
	ld e,a			; $39bb
	pop bc			; $39bc
	dec c			; $39bd
	jr nz,--
	ret			; $39c0

;;
; @addr{39c1}
@decompressLayoutMode2:
	ld de,wRoomLayout		; $39c1
	ld a,(SMALL_ROOM_WIDTH*SMALL_ROOM_HEIGHT)/16		; $39c4
-
	push af			; $39c6
	call @decompressLayoutMode2Helper		; $39c7
	pop af			; $39ca
	dec a			; $39cb
	jr nz,-
	ret			; $39ce

;;
; Decompresses layout to wRoomLayout.
;
; Format: word where each bit means "repeat" or "don't repeat"; byte to repeat; remaining data
;
; @addr{39cf}
@decompressLayoutMode2Helper:
	ldi a,(hl)		; $39cf
	ld c,a			; $39d0
	ldi a,(hl)		; $39d1
	ldh (<hFF8A),a	; $39d2
	or c			; $39d4
	ld b,$10		; $39d5
	jr z,@layoutCopyBytes	; $39d7
	ldi a,(hl)		; $39d9
	ldh (<hFF8B),a	; $39da
	call @decompressLayoutHelper		; $39dc
	ldh a,(<hFF8A)	; $39df
	ld c,a			; $39e1
	jr @decompressLayoutHelper		; $39e2

;;
; @addr{39e7}
@decompressLayoutMode1:
	ld de,wRoomLayout
	ld a,(SMALL_ROOM_WIDTH*SMALL_ROOM_HEIGHT)/8		; $39e7
-
	push af			; $39e9
	call @decompressLayoutMode1Helper		; $39ea
	pop af			; $39ed
	dec a			; $39ee
	jr nz,-
	ret			; $39f1

;;
; @addr{39f2}
@decompressLayoutMode1Helper:
	ldi a,(hl)		; $39f2
	ld c,a			; $39f3
	or a			; $39f4
	ld b,$08		; $39f5
	jr z,@layoutCopyBytes	; $39f7
	ldi a,(hl)		; $39f9
	ldh (<hFF8B),a	; $39fa
	jr @decompressLayoutHelper		; $39fc

;;
; Copy b bytes to wRoomLayout, while keeping de in bounds
;
; @addr{39fe}
@layoutCopyBytes:
	ldi a,(hl)		; $39fe
	ld (de),a		; $39ff
	inc e			; $3a00
	call @checkDeNextLayoutRow		; $3a01
	dec b			; $3a04
	jr nz,@layoutCopyBytes	; $3a05
	ret			; $3a07

;;
; @addr{3a08}
@checkDeNextLayoutRow:
	ld a,e			; $3a08
	and $0f			; $3a09
	cp SMALL_ROOM_WIDTH			; $3a0b
	ret c			; $3a0d
	ld a,$10-SMALL_ROOM_WIDTH		; $3a0e
	add e			; $3a10
	ld e,a			; $3a11
	ret			; $3a12

;;
; @addr{3a13}
@decompressLayoutHelper:
	ld b,$08		; $3a13
--
	srl c			; $3a15
	jr c,+
	ldi a,(hl)		; $3a19
	jr ++
+
	ldh a,(<hFF8B)	; $3a1c
++
	ld (de),a		; $3a1e
	inc e			; $3a1f
	call @checkDeNextLayoutRow		; $3a20
	dec b			; $3a23
	jr nz,--
	ret			; $3a26

;;
; Load the compressed layout data into wRoomCollisions (temporarily)
; @addr{3a27}
@loadLayoutData:
	push de			; $3a27
	ldh a,(<hFF8C)	; $3a28
.ifdef ROM_AGES
	ld e,a			; $3a2a
.endif
-
	bit 7,h			; $3a2b
	jr z,+
	ld a,h			; $3a2f
.ifdef ROM_AGES
	sub $40			; $3a30
.else
	xor $c0
.endif
	ld h,a			; $3a32

.ifdef ROM_SEASONS
	ldh a,(<hFF8C)
	inc a
	ldh (<hFF8C),a
.else
	inc e			; $3a33
	jr -
+
	ld a,e			; $3a36
.endif
+
	setrombank		; $3a37
	ld b,LARGE_ROOM_HEIGHT*16		; $3a3c
	ld de,wRoomCollisions		; $3a3e
-
	call readByteSequential		; $3a41
	ld (de),a		; $3a44
	inc e			; $3a45
	dec b			; $3a46
	jr nz,-

	ld hl,wRoomCollisions		; $3a49
	pop de			; $3a4c
	ret			; $3a4d


;;
; Generates w3VramTiles and w3VramAttributes, and calls the function for room-specific
; changes to them.
;
; @addr{3a4e}
generateVramTilesWithRoomChanges:
	ld a,($ff00+R_SVBK)	; $3a4e
	ld c,a			; $3a50
	ldh a,(<hRomBank)	; $3a51
	ld b,a			; $3a53
	push bc			; $3a54

	callfrombank0 generateW3VramTilesAndAttributes		; $3a55
.ifdef ROM_AGES
	callab        roomGfxChanges.applyRoomSpecificTileChangesAfterGfxLoad		; $3a5f
.else
	call        roomGfxChanges.applyRoomSpecificTileChangesAfterGfxLoad		; $3a5f
.endif

	pop bc			; $3a67
	ld a,b			; $3a68
	setrombank		; $3a69
	ld a,c			; $3a6e
	ld ($ff00+R_SVBK),a	; $3a6f
	ret			; $3a71

;;
; Gets the mapping data for a tile (the values to form the 2x2 tile).
;
; Tile indices go to $cec0-$cec3, and flag values go to $cec4-$cec7.
;
; @param	a	Tile to get mapping data for
; @param[out]	b	Top-left flag value
; @param[out]	c	Top-left tile index
; @addr{3a72}
getTileMappingData:
	ld c,a			; $3a72
	ld a,($ff00+R_SVBK)	; $3a73
	push af			; $3a75

	ld a,:w3TileMappingData		; $3a76
	ld ($ff00+R_SVBK),a	; $3a78

	ld a,c			; $3a7a
	call setHlToTileMappingDataPlusATimes8		; $3a7b

	push de			; $3a7e
	ld de,wTmpcec0		; $3a7f
	ld b,$08		; $3a82

.ifdef ROM_AGES
	call copyMemory		; $3a84
.else
--
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,--
.endif

	pop de			; $3a87
	ld a,($cec4)		; $3a88
	ld b,a			; $3a8b
	ld a,(wTmpcec0)		; $3a8c
	ld c,a			; $3a8f
	pop af			; $3a90
	ld ($ff00+R_SVBK),a	; $3a91
	ret			; $3a93

;;
; @addr{3a94}
setHlToTileMappingDataPlusATimes8:
	call multiplyABy8		; $3a94
	ld hl,w3TileMappingData		; $3a97
	add hl,bc		; $3a9a
	ret			; $3a9b

;;
; Sets tile 'c' to the value of 'a'.
;
; @param	a	New tile index
; @param	c	Position of tile to change (returned intact)
; @param[out]	zflag	Set on failure (w2ChangedTileQueue is full)
; @addr{3a9c}
setTile:
	ld b,a			; $3a9c
	ld a,(wChangedTileQueueTail)		; $3a9d
	inc a			; $3aa0
	and $1f			; $3aa1
	ld e,a			; $3aa3

	; Return if w2ChangedTileQueue is full
	ld a,(wChangedTileQueueHead)		; $3aa4
	cp e			; $3aa7
	ret z			; $3aa8

	; Tail of the queue gets incremented
	ld a,e			; $3aa9
	ld (wChangedTileQueueTail),a		; $3aaa

	ld a,($ff00+R_SVBK)	; $3aad
	push af			; $3aaf
	ld a,:w2ChangedTileQueue		; $3ab0
	ld ($ff00+R_SVBK),a	; $3ab2

	; Populate the new entry for the queue
	ld a,e			; $3ab4
	add a			; $3ab5
	ld hl,w2ChangedTileQueue		; $3ab6
	rst_addAToHl			; $3ab9
	ld (hl),b		; $3aba
	inc l			; $3abb
	ld (hl),c		; $3abc

	; This will update wRoomLayout and wRoomCollisions
	ld a,b			; $3abd
	call setTileWithoutGfxReload		; $3abe

	pop af			; $3ac1
	ld ($ff00+R_SVBK),a	; $3ac2
	or h			; $3ac4
	ret			; $3ac5


.ifdef ROM_AGES
;;
; Calls "setTile" and "setTileInRoomLayoutBuffer".
;
; @param	a	New tile index
; @param	c	Position of tile to change
; @addr{3ac6}
setTileInAllBuffers:
	ld e,a			; $3ac6
	ld b,a			; $3ac7
	call setTileInRoomLayoutBuffer		; $3ac8
	ld a,e			; $3acb
	jp setTile		; $3acc
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
; @addr{3acf}
setInterleavedTile:
	push de			; $3acf
	ld e,a			; $3ad0
	ld a,($ff00+R_SVBK)	; $3ad1
	ld c,a			; $3ad3
	ldh a,(<hRomBank)	; $3ad4
	ld b,a			; $3ad6
	push bc			; $3ad7

	ld a,:setInterleavedTile_body		; $3ad8
	setrombank		; $3ada
	ld a,e			; $3adf
	call setInterleavedTile_body		; $3ae0

	pop bc			; $3ae3
	ld a,b			; $3ae4
	setrombank		; $3ae5
	ld a,c			; $3aea
	ld ($ff00+R_SVBK),a	; $3aeb
	pop de			; $3aed
	ret			; $3aee

.ifdef ROM_SEASONS

seasonsFunc_3a9c:
	ld b,a			; $3a9c
	ld a,($cc49)		; $3a9d
	or a			; $3aa0
	ret nz			; $3aa1
	ld a,($cc4d)		; $3aa2
	cp $f1			; $3aa5
	ret nc			; $3aa7
	ld a,b			; $3aa8
	ld ($cc4e),a		; $3aa9
	ld a,$02		; $3aac
	ld ($cc68),a		; $3aae
	ret			; $3ab1

checkRoomPackAfterWarp:
	ld a,($ff00+$97)	; $3ab2
	push af			; $3ab4
	callfrombank0 bank1.checkRoomPackAfterWarp_body		; $3abc
	pop af			; $3abf
	ld ($ff00+$97),a	; $3ac0
	ld ($2222),a		; $3ac2
	ret			; $3ac5

.endif

;;
; @param[out]	hl	Address of a free interaction slot (on the id byte)
; @param[out]	zflag	Set if a free slot was found
; @addr{3aef}
getFreeInteractionSlot:
	ld hl,FIRST_DYNAMIC_INTERACTION_INDEX<<8 | $40		; $3aef
--
	ld a,(hl)		; $3af2
	or a			; $3af3
	jr z,++

	inc h			; $3af6
	ld a,h			; $3af7
	cp $e0			; $3af8
	jr c,--

	or h			; $3afc
	ret			; $3afd
++
	inc (hl)		; $3afe
	inc l			; $3aff
	xor a			; $3b00
	ret			; $3b01



.ifdef ROM_AGES
;;
; @addr{3b02}
interactionDeleteAndUnmarkSolidPosition:
	call objectUnmarkSolidPosition		; $3b02
.endif

;;
; @addr{3b05}
interactionDelete:
	ld h,d			; $3b05
	ld l,Interaction.start		; $3b06
	ld b,$10		; $3b08
	xor a			; $3b0a
-
	ldi (hl),a		; $3b0b
	ldi (hl),a		; $3b0c
	ldi (hl),a		; $3b0d
	ldi (hl),a		; $3b0e
	dec b			; $3b0f
	jr nz,-
	ret			; $3b12

;;
; @addr{3b13}
_updateInteractionsIfStateIsZero:
	ld a,Interaction.start		; $3b13
	ldh (<hActiveObjectType),a	; $3b15
	ld a,FIRST_INTERACTION_INDEX		; $3b17
--
	ldh (<hActiveObject),a	; $3b19
	ld d,a			; $3b1b
	ld e,Interaction.enabled		; $3b1c
	ld a,(de)		; $3b1e
	or a			; $3b1f
	jr z,@next		; $3b20

	rlca			; $3b22
	jr c,+			; $3b23

	ld e,Interaction.state	; $3b25
	ld a,(de)		; $3b27
	or a			; $3b28
	jr nz,@next		; $3b29
+
	call updateInteraction		; $3b2b
@next:
	ldh a,(<hActiveObject)	; $3b2e
	inc a			; $3b30
	cp LAST_INTERACTION_INDEX+1			; $3b31
	jr c,--			; $3b33
	ret			; $3b35

;;
; @addr{3b36}
updateInteractions:
	ld a,(wScrollMode)		; $3b36
	cp $08			; $3b39
	jr z,_updateInteractionsIfStateIsZero		; $3b3b

	ld a,(wDisabledObjects)		; $3b3d
	and $02			; $3b40
	jr nz,_updateInteractionsIfStateIsZero		; $3b42

	ld a,(wTextIsActive)		; $3b44
	or a			; $3b47
	jr nz,_updateInteractionsIfStateIsZero		; $3b48

	ld a,Interaction.start		; $3b4a
	ldh (<hActiveObjectType),a	; $3b4c
	ld a,FIRST_INTERACTION_INDEX		; $3b4e
@next:
	ldh (<hActiveObject),a	; $3b50
	ld d,a			; $3b52
	ld e,Interaction.enabled		; $3b53
	ld a,(de)		; $3b55
	or a			; $3b56
	call nz,updateInteraction		; $3b57
	ldh a,(<hActiveObject)	; $3b5a
	inc a			; $3b5c
	cp LAST_INTERACTION_INDEX+1			; $3b5d
	jr c,@next		; $3b5f
	ret			; $3b61

;;
; Run once per frame for each interaction.
;
; @param	d	Interaction to update
; @addr{3b62}
updateInteraction:
	ld e,Interaction.id		; $3b62
	ld a,(de)		; $3b64

.ifdef ROM_AGES
	; Get the bank number in 'b'
	ld b,$08		; $3b65
	cp $3e			; $3b67
	jr c,@cnt		; $3b69
	inc b			; $3b6b
	cp $67			; $3b6c
	jr c,@cnt		; $3b6e
	inc b			; $3b70
	cp $98			; $3b71
	jr c,@cnt		; $3b73
	inc b			; $3b75
	cp $dc			; $3b76
	jr c,@cnt		; $3b78
	ld b,$10		; $3b7a

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
	ld a,b			; $3b7c
	setrombank		; $3b7d
	ld a,(de)		; $3b82
	ld hl,interactionCodeTable	; $3b83
	rst_addDoubleIndex			; $3b86
	ldi a,(hl)		; $3b87
	ld h,(hl)		; $3b88
	ld l,a			; $3b89
	jp hl			; $3b8a

.include "data/interactionCodeTable.s"

.ifdef ROM_SEASONS

seasonsFunc_3d30:
	ld a,(wFrameCounter)		; $3d30
	and $3f			; $3d33
	ret nz			; $3d35
	ld b,$fa		; $3d36
	ld c,$fc		; $3d38
	jp objectCreateFloatingSnore		; $3d3a

seasonsFunc_3d3d:
	ldh a,(<hRomBank)	; $3d3d
	push af			; $3d3f
	callfrombank0 $0a $7a7b		; $3d40
	push af			; $3d4a
	pop bc			; $3d4b
	pop af			; $3d4c
	setrombank		; $3d4d
	ret			; $3d52

.else ; ROM_AGES

;;
; Checks that an object is within [hFF8B] pixels of a position on both axes.
;
; @param	bc	Target position
; @param	hl	Object's Y position
; @param	hFF8B	Range we must be within on each axis
; @param[out]	cflag	c if the object is within [hFF8B] pixels of the position
; @addr{3d59}
checkObjectIsCloseToPosition:
	ldh (<hFF8B),a	; $3d59
	ldh a,(<hRomBank)	; $3d5b
	push af			; $3d5d

	callfrombank0 interactionBank08.checkObjectIsCloseToPosition		; $3d5e
	ld b,$00		; $3d68
	jr nc,+			; $3d6a
	inc b			; $3d6c
+
	pop af			; $3d6d
	setrombank		; $3d6e

	ld a,b			; $3d73
	or a			; $3d74
	ret z			; $3d75
	scf			; $3d76
	ret			; $3d77

;;
; Contains some preset data for checking whether certain interactions should exist at
; certain points in the game?
;
; @param	a	Index of preset data to check
; @param	b	Return value from "getGameProgress_1" or "getGameProgress_2"?
; @param	c	Subid "base"
; @param[out]	zflag	Set if the npc should exist
; @addr{3d78}
checkNpcShouldExistAtGameStage:
	ldh (<hFF8B),a	; $3d78
	ldh a,(<hRomBank)	; $3d7a
	push af			; $3d7c
	ld a,:interactionBank09.checkNpcShouldExistAtGameStage_body		; $3d7d
	setrombank		; $3d7f
	ldh a,(<hFF8B)	; $3d84
	call interactionBank09.checkNpcShouldExistAtGameStage_body		; $3d86
	ld c,$00		; $3d89
	jr z,+			; $3d8b
	inc c			; $3d8d
+
	pop af			; $3d8e
	setrombank		; $3d8f
	ld a,c			; $3d94
	or a			; $3d95
	ret			; $3d96

; @addr{3d97}
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
;
; @addr{3da0}
interactionSetSimpleScript:
	ld e,Interaction.scriptPtr		; $3da0
	ld a,l			; $3da2
	ld (de),a		; $3da3
	inc e			; $3da4
	ld a,h			; $3da5
	ld (de),a		; $3da6
	ret			; $3da7

;;
; @param[out]	cflag	Set if the script has ended.
; @addr{3da8}
interactionRunSimpleScript:
	ldh a,(<hRomBank)	; $3da8
	push af			; $3daa
	ld a,SIMPLE_SCRIPT_BANK		; $3dab
	setrombank		; $3dad

	ld h,d			; $3db2
	ld l,Interaction.scriptPtr		; $3db3
	ldi a,(hl)		; $3db5
	ld h,(hl)		; $3db6
	ld l,a			; $3db7
--
	ld a,(hl)		; $3db8
	or a			; $3db9
	jr z,@scriptEnd			; $3dba
	call @runCommand		; $3dbc
	jr c,--			; $3dbf

	call interactionSetSimpleScript		; $3dc1
	pop af			; $3dc4
	setrombank		; $3dc5
	xor a			; $3dca
	ret			; $3dcb

@scriptEnd:
	pop af			; $3dcc
	setrombank		; $3dcd
	scf			; $3dd2
	ret			; $3dd3

;;
; @addr{3dd4}
@runCommand:
	ldi a,(hl)		; $3dd4
	push hl			; $3dd5
	rst_jumpTable			; $3dd6
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
;
; @addr{3de1}
@command0:
	pop hl			; $3de1
	ret			; $3de2

;;
; Set counter1
;
; @addr{3de3}
@command1:
	pop hl			; $3de3
	ldi a,(hl)		; $3de4
	ld e,Interaction.counter1		; $3de5
	ld (de),a		; $3de7
	xor a			; $3de8
	ret			; $3de9

;;
; Call playSound
;
; @addr{3dea}
@command2:
	pop hl			; $3dea
	ldi a,(hl)		; $3deb
	push hl			; $3dec
	call playSound		; $3ded
	pop hl			; $3df0
	ret			; $3df1

;;
; Call setTile
;
; @addr{3df2}
@command3:
	pop hl			; $3df2
	ldi a,(hl)		; $3df3
	ld c,a			; $3df4
	ldi a,(hl)		; $3df5
	push hl			; $3df6
	call setTile		; $3df7
	pop hl			; $3dfa
	scf			; $3dfb
	ret			; $3dfc

;;
; Call setInterleavedTile
;
; @addr{3dfd}
@command4:
	pop hl			; $3dfd
	ldi a,(hl)		; $3dfe
	ldh (<hFF8C),a	; $3dff
	ldi a,(hl)		; $3e01
	ldh (<hFF8F),a	; $3e02
	ldi a,(hl)		; $3e04
	ldh (<hFF8E),a	; $3e05
	ldi a,(hl)		; $3e07
	push hl			; $3e08
	call setInterleavedTile		; $3e09
	pop hl			; $3e0c
	scf			; $3e0d
	ret			; $3e0e


.ifdef ROM_SEASONS

@command5:
	pop hl			; $3dca
	ldi a,(hl)		; $3dcb
	ld b,a			; $3dcc
	ldi a,(hl)		; $3dcd
	ld c,a			; $3dce
	ldi a,(hl)		; $3dcf
	ld ($ff00+$8b),a	; $3dd0
	push hl			; $3dd2
--
	push bc			; $3dd3
	ld a,($ff00+$8b)	; $3dd4
	call setTile		; $3dd6
	pop bc			; $3dd9
	inc c			; $3dda
	dec b			; $3ddb
	jr nz,--		; $3ddc
	pop hl			; $3dde
	scf			; $3ddf
	ret			; $3de0

@command7:
	pop hl			; $3de1
	ldi a,(hl)		; $3de2
	ld b,a			; $3de3
	ldi a,(hl)		; $3de4
	ld ($ff00+$8c),a	; $3de5
	ldi a,(hl)		; $3de7
	ld ($ff00+$8e),a	; $3de8
	ldi a,(hl)		; $3dea
	ld ($ff00+$8d),a	; $3deb
	push hl			; $3ded
--
	push bc			; $3dee
	ld b,$cf		; $3def
	ld a,($ff00+$8c)	; $3df1
	ld c,a			; $3df3
	ld a,(bc)		; $3df4
	ld ($ff00+$8f),a	; $3df5
	ld a,($ff00+$8d)	; $3df7
	call setInterleavedTile		; $3df9
	ld hl,$ff8c		; $3dfc
	inc (hl)		; $3dff
	pop bc			; $3e00
	dec b			; $3e01
	jr nz,--		; $3e02
	pop hl			; $3e04
	scf			; $3e05

@command6:
@command8:
	ret			; $3e06

.endif


.ifdef ROM_AGES

;;
; Gets object data for tokays in the wild tokay game.
;
; @param	b	Index (0/1: Tokay on left; 2: tokay on right; 3: both sides)
; @param[out]	hl	Address of object data
; @addr{3e0f}
getWildTokayObjectDataIndex:
	ldh a,(<hRomBank)	; $3e0f
	push af			; $3e11
	ld a,:objectData.wildTokayObjectTable
	setrombank		; $3e14
	ld a,b			; $3e19
	ld hl,objectData.wildTokayObjectTable
	rst_addDoubleIndex			; $3e1d
	ldi a,(hl)		; $3e1e
	ld h,(hl)		; $3e1f
	ld l,a			; $3e20
	pop af			; $3e21
	setrombank		; $3e22
	ret			; $3e27

;;
; Create a sparkle at the current object's position.
;
; @addr{3e28}
objectCreateSparkle:
	call getFreeInteractionSlot		; $3e28
	ret nz			; $3e2b
	ld (hl),INTERACID_SPARKLE		; $3e2c
	inc l			; $3e2e
	ld (hl),$00		; $3e2f
	jp objectCopyPositionWithOffset		; $3e31

;;
; Create a sparkle at the current object's position that moves up briefly.
;
; Unused?
;
; @addr{3e34}
objectCreateSparkleMovingUp:
	call getFreeInteractionSlot		; $3e34
	ret nz			; $3e37
	ld (hl),INTERACID_SPARKLE		; $3e38
	inc l			; $3e3a
	ld (hl),$02		; $3e3b
	ld l,$50		; $3e3d
	ld (hl),$80		; $3e3f
	inc l			; $3e41
	ld (hl),$ff		; $3e42
	jp objectCopyPositionWithOffset		; $3e44

;;
; Create a red and blue decorative orb.
;
; Unused?
;
; @addr{3e47}
objectCreateRedBlueOrb:
	call getFreeInteractionSlot		; $3e47
	ret nz			; $3e4a
	ld (hl),INTERACID_SPARKLE		; $3e4b
	inc l			; $3e4d
	ld (hl),$04		; $3e4e
	jp objectCopyPositionWithOffset		; $3e50

;;
; @addr{3e53}
incMakuTreeState:
	ld a,(wMakuTreeState)		; $3e53
	inc a			; $3e56
	cp $11			; $3e57
	jr c,+			; $3e59
	ld a,$10		; $3e5b
+
	ld (wMakuTreeState),a		; $3e5d
	ret			; $3e60

;;
; Sets w1Link.direction, as well as w1Companion.direction if Link is riding something.
;
; @addr{3e61}
setLinkDirection:
	ld b,a			; $3e61
	ld a,(wLinkObjectIndex)		; $3e62
	ld h,a			; $3e65
	ld l,SpecialObject.direction		; $3e66
	ld (hl),b		; $3e68
	ld h,>w1Link		; $3e69
	ld (hl),b		; $3e6b
	ret			; $3e6c

.else ; ROM_SEASONS

seasonsFunc_3e07:
	ld a,($ff00+$97)	; $3e07
	push af			; $3e09
	callfrombank0 $08 $57db		; $3e0a
	ld c,$01		; $3e14
	jr c,+			; $3e16
	dec c			; $3e18
+
	pop af			; $3e19
	setrombank		; $3e1a
	ret			; $3e1f

seasonsFunc_3e20:
	ld a,($ff00+$97)	; $3e20
	push af			; $3e22
	callfrombank0 $09 $7d8b		; $3e23
	callfrombank0 $15 $60fc		; $3e2d
	pop af			; $3e37
	setrombank		; $3e38
	ret			; $3e3d

seasonsFunc_3e3e:
	ld a,($ff00+$97)	; $3e3e
	push af			; $3e40
	callfrombank0 $08 $5874		; $3e41
	pop af			; $3e4b
	setrombank		; $3e4c
	ret			; $3e51

seasonsFunc_3e52:
	ld a,($ff00+$97)	; $3e52
	push af			; $3e54
	callfrombank0 $0a $69d4 		; $3e55
	ld a,$01		; $3e5f
	call $69e7		; $3e61
	call $6a0a		; $3e64
	pop af			; $3e67
	setrombank		; $3e68
	ret			; $3e6d

.endif ; ROM_SEASONS


;;
; Used during the end credits. Seems to load the credit text into OAM.
;
; @addr{3e6d}
interactionFunc_3e6d:
	push de			; $3e6d
	ld l,Interaction.var03		; $3e6e
	ld e,(hl)		; $3e70

	ldh a,(<hRomBank)	; $3e71
	push af			; $3e73
.ifdef ROM_AGES
	ld a,:bank16.data_4556		; $3e74
.else
	ld a,:data_4556		; $3e74
.endif
	setrombank		; $3e76

	ld a,e			; $3e7b
.ifdef ROM_AGES
	ld hl,bank16.data_4556		; $3e7c
.else
	ld hl,data_4556		; $3e7c
.endif
	rst_addDoubleIndex			; $3e7f
	ldi a,(hl)		; $3e80
	ld h,(hl)		; $3e81
	ld l,a			; $3e82
	call addSpritesToOam_withOffset		; $3e83
	pop af			; $3e86
	setrombank		; $3e87
	pop de			; $3e8c
	ret			; $3e8d


.ifdef ROM_SEASONS

seasonsFunc_3e8f:
	ld a,($ff00+$97)	; $3e8f
	push af			; $3e91
	ld a,$04		; $3e92
	setrombank
	ld hl,$7655		; $3e99
	ld a,(hl)		; $3e9c
	ld ($cc64),a		; $3e9d
	pop af			; $3ea0
	setrombank		; $3ea1
	ret			; $3ea6

.endif

;;
; @param[out]	hl	Address of part slot ("id" byte)
; @param[out]	zflag	nz if no free slot was available
; @addr{3e8e}
getFreePartSlot:
	ldhl FIRST_PART_INDEX, Part.start		; $3e8e
--
	ld a,(hl)		; $3e91
	or a			; $3e92
	jr z,++
	inc h			; $3e95
	ld a,h			; $3e96
	cp LAST_PART_INDEX+1			; $3e97
	jr c,--
	or h			; $3e9b
	ret			; $3e9c
++
	inc a			; $3e9d
	ldi (hl),a		; $3e9e
	xor a			; $3e9f
	ret			; $3ea0

;;
; @addr{3ea1}
partDelete:
	ld h,d			; $3ea1
	ld l,Part.start		; $3ea2
	ld b,$10		; $3ea4
	xor a			; $3ea6
-
	ldi (hl),a		; $3ea7
	ldi (hl),a		; $3ea8
	ldi (hl),a		; $3ea9
	ldi (hl),a		; $3eaa
	dec b			; $3eab
	jr nz,-
	ret			; $3eae


.ifdef ROM_AGES

;;
; @param[out]	cflag
; @addr{3eaf}
checkLinkCanSurface:
	ld a,(wTilesetFlags)		; $3eaf
	and TILESETFLAG_UNDERWATER			; $3eb2
	ret z			; $3eb4
	callab checkLinkCanSurface_isUnderwater
	srl c			; $3ebd
	ret			; $3ebf

;;
; Copy $100 bytes from a specified bank.
;
; This DOES NOT set the bank back to its previous value, so it's not very useful.
;
; In fact, it's unused.
;
; @param	c	ROM Bank to copy from
; @param	d	High byte of address to copy to
; @param	e	WRAM Bank
; @param	hl	Address to copy from
; @addr{3ec0}
copy256BytesFromBank:
	ld a,e			; $3ec0
	ld ($ff00+R_SVBK),a	; $3ec1
	ld a,c			; $3ec3
	setrombank		; $3ec4
	ld e,$00		; $3ec9
	ld b,$00		; $3ecb
	jp copyMemory		; $3ecd

;;
; @addr{3ed0}
func_3ed0:
	ldh a,(<hRomBank)	; $3ed0
	push af			; $3ed2
	callfrombank0 func_03_7841		; $3ed3
	pop af			; $3edd
	setrombank		; $3ede
	ret			; $3ee3

;;
; @addr{3ee4}
func_3ee4:
	ldh a,(<hRomBank)	; $3ee4
	push af			; $3ee6
	callfrombank0 func_03_7849		; $3ee7
	pop af			; $3ef1
	setrombank		; $3ef2
	ret			; $3ef7

.endif


.ENDS
