 m_section_free Bank_3 NAMESPACE bank3

;;
; This is the first thing the game jumps to on startup.
init:
	di
	xor a
	ld ($ff00+R_IF),a
	ld ($ff00+R_IE),a
	ld ($ff00+R_STAT),a
	ld ($ff00+R_TAC),a
	ld ($ff00+R_SC),a
	xor a
	ld ($1111),a

	call disableLcd

	ldh a,(<hGameboyType)
	or a
	jr z,+

	; Initialize CGB registers
	xor a
	ld ($ff00+R_RP),a
	ld ($ff00+R_SVBK),a
	ld ($ff00+R_VBK),a
	call setCpuToDoubleSpeed
+
	ld hl,hActiveFileSlot
	ld b,hramEnd-hActiveFileSlot
	call clearMemory

	; Clear all memory after the stacks
	ld hl,wThread3StackTop
	ld bc,$dfff-wThread3StackTop
	call clearMemoryBc

	call clearVram

	; Copy DMA function to hram
	ld hl,oamDmaFunction
	ld de,hOamFunc
	ld b,oamDmaFunctionEnd-oamDmaFunction
	call copyMemory

	; Initialize DMG palettes
	ld a,%11100100
	ld ($ff00+R_BGP),a
	ld ($ff00+R_OBP0),a
	ld a,%01101100
	ld ($ff00+R_OBP1),a

	call initSound

	ld a,$c7
	ld ($ff00+R_LYC),a
	ld a,$40
	ld ($ff00+R_STAT),a

	xor a
	ld ($ff00+R_IF),a
	ld a,$0f
	ld ($ff00+R_IE),a

	callab bank3f.initGbaModePaletteData
	ei
	callab bank2.checkDisplayDmgModeScreen

	jp startGame

;;
setCpuToDoubleSpeed:
	ld a,($ff00+R_KEY1)
	rlca
	ret c

	xor a
	ld ($ff00+R_IF),a
	ld ($ff00+R_IE),a
	ld a,$01
	ld ($ff00+R_KEY1),a
	ld a,$30
	ld ($ff00+R_P1),a
	stop
	nop
-
	ld a,($ff00+R_KEY1)
	rlca
	jr nc,-

	xor a
	ld ($ff00+R_P1),a
	ld ($ff00+R_IF),a
	ld ($ff00+R_IE),a
	ret

;;
; This is copied to RAM and run from there.
oamDmaFunction:
	ld a,>wOam
	ld ($ff00+R_DMA),a
	ld a,$28
-
	dec a
	jr nz,-
	ret
oamDmaFunctionEnd:


; Speed table for objects.
;
; It's organized in a sort of complicated way which allows it to reuse certain sin and cos
; values for certain angles, ie. an angle of $08 (right) uses the same values for its
; Y speed as angle $00 (up) does for its X speed. Due to this, there is an extra .dwsin
; line at the end of each repetition which is used for angle $18-$1f's X positions only.
objectSpeedTable:
	.define TMP_SPEED $20

	.rept 24
		; Calculate 8 sin/cos values per line at increments of 11.25 degrees
		.dwsin 090 7 11.25 (-TMP_SPEED) 0 ; $00 <- angle
		.dwcos 090 7 11.25 (-TMP_SPEED) 0 ; $08
		.dwsin 270 7 11.25 (-TMP_SPEED) 0 ; $10
		.dwcos 270 7 11.25 (-TMP_SPEED) 0 ; $18
		.dwsin 090 7 11.25 (-TMP_SPEED) 0

		.redefine TMP_SPEED TMP_SPEED+$20
	.endr

	.undefine TMP_SPEED

;;
; Calculates the game-transfer secret's text?
generateGameTransferSecret:
	ld hl,wFileIsLinkedGame
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	push bc

	; When generating a game-transfer secret: if this file is either linked or
	; a hero's file, mark the secret as a "hero's secret"; otherwise, it's just
	; linked? (so basically, only the secret from the first game is marked as
	; linked...)
	or b
	ldd (hl),a
	xor $01
	or b
	ld (hl),a

	ldbc $00,$00
	call secretFunctionCaller_body

	pop bc
	ld hl,wFileIsLinkedGame
	ld (hl),c
	inc l
	ld (hl),b
	ret

;;
; Calls a secret-related function based on parameter 'b':
;
; 0: Generate a secret
; 1: Unpack a secret in ascii form (input and output are both in wTmpcec0)
; 2: Verify that the gameID of an unpacked secret is valid
; 3: Generate a gameID for the current file
; 4: Loads the data associated with an unpacked secret (ie. for game-transfer secret, this
;    loads the player name, animal companion, etc. from the secret data).
;
; @param	b	Function to call
; @param	c	Secret type
; @param[out]	zflag	Generally set on success
secretFunctionCaller_body:
	push de
	ld a,($ff00+R_SVBK)
	push af
	ld a,TEXT_BANK
	ld ($ff00+R_SVBK),a

	call @jumpTable

	pop af
	ld ($ff00+R_SVBK),a
	pop de
	ret

@jumpTable:
	ld a,b
	rst_jumpTable
	.dw generateSecret
	.dw unpackSecret
	.dw verifyUnpackedSecretGameID
	.dw generateGameIDIfNeeded
	.dw loadUnpackedSecretData


;;
; Generates a secret. If this is one of the 5-letter secrets, then wShortSecretIndex
; should be set to the corresponding secret's index (?) before calling this.
;
; @param	c	Value for wSecretType
generateSecret:
	ld hl,w7SecretText1
	ld b,$40
	call clearMemory

	call andCWith3
	call generateGameIDIfNeeded

	call @determineXorCipher
	ld hl,wSecretXorCipherIndex
	ldi (hl),a
	ld (hl),c ; hl = wSecretType

	ld a,$04 ; Encode the gameID
	call encodeSecretData
	; Encode everything else (c is unmodified from before)
	call encodeSecretData_paramC

	; Calculate checksum (4 bits) and insert it at the end
	ld b,$04
	xor a
	call insertBitsIntoSecretGenerationBuffer
	call getSecretBufferChecksum
	ld hl,w7SecretGenerationBuffer+19
	or (hl)
	ld (hl),a

	call shiftSecretBufferContentsToFront
	call runXorCipherOnSecretBuffer
	jp convertSecretBufferToText

;;
; Decides which xor cipher to use based on GameID (and, for 5-letter secrets, based on
; which secret it is).
;
; @param	c
; @param[out]	a	Which xor cipher to use (from 0-7)
@determineXorCipher:
	push bc
	ld hl,wGameID
	ldi a,(hl)
	add (hl)
	ld b,a
	ld a,c
	cp $03
	ld a,b
	jr nz,@ret

	ld l,<wShortSecretIndex
	ld a,(hl)
	swap a
	and $0f
	add b
	ld b,a
	ld a,(hl)
	and $01
	rlca
	rlca
	xor b
@ret:
	and $07
	pop bc
	ret

;;
; @param	c	Secret type to encode (0-4)
encodeSecretData_paramC:
	ld a,c

;;
; Encodes data into a secret by shifting in the required bits.
;
; @param	a	Secret type to encode (0-4)
encodeSecretData:
	push bc
	ld hl,secretDataToEncodeTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ldi a,(hl)
	ld c,a
--
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld b,a
	ld d,>wc600Block
	ld a,(de)
	call insertBitsIntoSecretGenerationBuffer
	dec c
	jr nz,--
	pop bc
	ret

;;
; Encodes the given bits into w7SecretGenerationBuffer.
;
; It works by shifting each individual bit in, starting from the end of the buffer. If
; anything overflows it will be lost.
;
; @param	a	Byte to encode
; @param	b	Number of bits to encode
insertBitsIntoSecretGenerationBuffer:
	push hl
	push bc
	ld c,a
---
	ld hl,w7SecretGenerationBuffer+19
	ld e,20
	srl c
--
	ld a,(hl)
	rla
	ldd (hl),a
	rla
	rla
	dec e
	jr nz,--
	dec b
	jr nz,---

	; Iterate through all characters to remove anything in the upper 2 bits
	ld hl,w7SecretGenerationBuffer
	ldde $3f,20
--
	ld a,(hl)
	and d
	ldi (hl),a
	dec e
	jr nz,--

	pop bc
	pop hl
	ret

;;
; Unpacks a secret's data to wTmpcec0. (each entry in "secretDataToEncodeTable" gets
; a separate byte in the output.)
;
; Input (the secret in ascii) and output (the unpacked data) are both in wTmpcec0.
;
; @param	c	Secret type
; @param[out]	b	$00 if secret was valid, $01 otherwise
unpackSecret:
	ld hl,w7SecretText1
	ld b,$40
	call clearMemory
	call andCWith3
	call loadSecretBufferFromText
	jr c,@fail

	call runXorCipherOnSecretBuffer

	; Retrieve checksum in 'e', then remove the checksum bits from the secret buffer
	call getNumCharactersForSecretType
	ld hl,w7SecretGenerationBuffer-1
	rst_addAToHl
	ld a,(hl)
	and $0f
	ld e,a
	xor (hl)
	ld (hl),a

	call getSecretBufferChecksum
	cp e
	jr nz,@fail

	call @unpackSecretData

	; Check the value of "wSecretType" stored in the secret, make sure it's correct
	ld a,(wTmpcec0+1)
	cp c
	jr nz,@fail

	ld b,$00
	ret
@fail:
	ld b,$01
	ret

;;
@unpackSecretData:
	ld de,wTmpcec0
	ld a,$04 ; Unpack gameID, etc
	call @unpack

	ld a,c ; Unpack the meat of the data

;;
; @param	a	Secret type
; @param	de	Address to write the extracted data to
@unpack:
	ld hl,secretDataToEncodeTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ldi a,(hl)
	ld b,a
@@nextEntry:
	inc hl
	ldi a,(hl)
	call @readBits
	ld (de),a
	inc de
	dec b
	jr nz,@@nextEntry
	ret

;;
; @param	a	Number of bits to read from the start of w7SecretGenerationBuffer
; @param[out]	a	The value of the bits retrieved
@readBits:
	push bc
	push de
	push hl
	ld b,a
	ld c,a
	ld d,$00
---
	; Rotate the entire buffer left one bit
	ld hl,w7SecretGenerationBuffer+19
	ld e,20
--
	rl (hl)
	ld a,(hl)
	rla
	rla
	dec hl
	dec e
	jr nz,--

	rr d ; Rotate leftmost bit into d
	dec b
	jr nz,---

	; Result is now in the upper bits of 'd'. We still need to shift it into the lower
	; bits.
	ld a,$08
	sub c
	ld b,a
	ld a,d
	jr z,@@end
--
	rrca
	dec b
	jr nz,--
@@end:
	pop hl
	pop de
	pop bc
	ret

;;
; Loads the data associated with an unpacked secret (ie. for game-transfer secrets, copies
; over player name, animal companion, game type, etc.)
;
loadUnpackedSecretData:
	call andCWith3
	rst_jumpTable
	.dw @type0
	.dw @type1
	.dw @type2
	.dw @type3

@type0: ; Game-transfer secret
@type1:
	ld hl,secretDataToEncodeTable@entry0
	ldi a,(hl)
	ld b,a
	ld de,wTmpcec0+4 ; Start from +4 to skip the "header"
--
	ld a,(de)
	push de
	ld e,(hl)
	ld d,>wc600Block
	ld (de),a
	pop de
	inc de
	inc hl
	inc hl
	dec b
	jr nz,--

	; Copy the secret's game ID
	ld hl,wGameID
	ld a,(wTmpcec0+2)
	ldi (hl),a
	ld a,(wTmpcec0+3)
	ld (hl),a

@type3: ; 5-letter secret
	ret

@type2: ; Ring secret
	ld hl,secretDataToEncodeTable@entry2+1
	ld b,$08
	ld de,wTmpcec0+4 ; Start from +4 to skip the "header"
--
	ldi a,(hl)
	push hl
	ld l,a
	ld h,>wc600Block
	ld a,(de)
	or (hl)
	ld (hl),a
	pop hl
	inc de
	inc hl
	dec b
	jr nz,--
	ret

;;
verifyUnpackedSecretGameID:
	; Get the gameID of an unpacked secret
	ld hl,wTmpcec0+2
	ldi a,(hl)
	ld d,(hl)
	ld e,a

	; If the GameID is zero, accept the secret.
	; This means that any secret encoded with GameID 0 works on EVERY file, regardless
	; of that file's game ID. Was this intentional?
	or d
	jr z,@success

	; If nonzero, check that it matches this game's gameID
	ld hl,wGameID
	ldi a,(hl)
	cp e
	jr nz,@fail
	ldi a,(hl)
	cp d
	jr z,@success
@fail:
	ld b,$01
	ret
@success:
	ld b,$00
	ret

;;
; Generates a gameID if one hasn't been calculated yet.
generateGameIDIfNeeded:
	ld hl,wGameID
	ldi a,(hl)
	or (hl)
	ret nz

	; Base the ID on wPlaytimeCounter (which should be pseudo-random).
	ld l,<wPlaytimeCounter+1
	ldd a,(hl)
	and $7f
	ld b,a
	ld a,(hl)
	jr nz,+
--
	; The GameID can't be 0, so read from R_DIV until we get a nonzero value.
	or a
	jr nz,+
	ld a,($ff00+R_DIV)
	jr --
+
	ld l,<wGameID
	ldi (hl),a
	ld (hl),b
	ret

;;
; Copies the data from w7SecretGenerationBuffer to w7SecretText1. The former consists of
; "raw bytes", while the latter is ascii.
;
convertSecretBufferToText:
	ld a,c
	ld hl,@secretSpacingData
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	ld de,w7SecretGenerationBuffer
	ld hl,w7SecretText1
@nextGroup:
	ld a,(bc)
	and $0f
	ret z

	push bc
	ld b,a
@nextSymbol:
	ld a,(de)
	push hl
	ld hl,secretSymbols
	rst_addAToHl
	ld a,(hl)
	pop hl
	ldi (hl),a
	inc de
	dec b
	jr nz,@nextSymbol

	pop bc
	ld a,(bc)
	and $f0
	ldi (hl),a
	inc bc
	jr @nextGroup


; For each secret type, this data tells the above function how to format it (in groups of
; X characters followed by a gap character).
@secretSpacingData:
	.dw @entry0
	.dw @entry1
	.dw @entry2
	.dw @entry3

; Upper digit: character to print after the X characters are copied
; Lower digit: number of characters to copy (0 to stop)

@entry0:
@entry1:
	.db $25 $05 $25 $05 $00
@entry2:
	.db $25 $05 $25 $00
@entry3:
	.db $05 $00


;;
; Loads w7SecretGenerationBuffer based on a secret in ASCII format.
;
; @param	wTmpcec0	Buffer with the secret in text format
; @param[out]	cflag		Set if there's a problem with the secret (invalid char)
loadSecretBufferFromText:
	call getNumCharactersForSecretType
	ld hl,wTmpcec0
	ld de,w7SecretGenerationBuffer
--
	ldi a,(hl)
	call @textCharacterToByte
	ret c
	ld (de),a
	inc de
	dec b
	jr nz,--
	ret

;;
; @param	a	Ascii symbol
; @param[out]	a	Byte corresponding to value
; @param[out]	cflag	Set if there's no byte corresponding to it
@textCharacterToByte:
	push hl
	push bc
	ld hl,secretSymbols
	ldbc $40,$00
--
	cp (hl)
	jr z,@end
	inc hl
	inc c
	dec b
	jr nz,--
	scf
@end:
	ld a,c
	pop bc
	pop hl
	ret

;;
; This xors all bytes in w7SecretGenerationBuffer with the corresponding cipher
; (determined by the first 3 bits in the secret buffer).
;
runXorCipherOnSecretBuffer:
	call getNumCharactersForSecretType

	; Determine cipher ID from the first 3 bits of the secret (corresponds to
	; wSecretXorCipherIndex)
	ld a,(w7SecretGenerationBuffer)
	and $38
	rrca
	ld de,secretXorCipher
	call addAToDe

	ld hl,w7SecretGenerationBuffer
	ld a,(de)

	; For the first byte only, don't xor the upper bits so that the cipher ID remains
	; intact.
	and $07
--
	xor (hl)
	ldi (hl),a
	inc de
	ld a,(de)
	dec b
	jr nz,--
	ret

;;
; @param[out]	a	The last 4 bits of the sum of all bytes in w7SecretGenerationBuffer
getSecretBufferChecksum:
	ld hl,w7SecretGenerationBuffer
	ld b,20
	xor a
--
	add (hl)
	inc hl
	dec b
	jr nz,--
	and $0f
	ret

;;
; For smaller secrets (length < 20), this shifts the contents of the secret to the front
; of the buffer.
;
; @param	c	Secret type
shiftSecretBufferContentsToFront:
	call getNumCharactersForSecretType
	ld a,20
	sub b
	ret z

	ld de,w7SecretGenerationBuffer
	ld h,d
	ld l,e
	rst_addAToHl
--
	ldi a,(hl)
	ld (de),a
	inc de
	dec b
	jr nz,--
	ret

;;
andCWith3:
	ld a,c
	and $03
	ld c,a
	ret


; This lists the data that a particular secret type must encode.
secretDataToEncodeTable:
	.dw @entry0
	.dw @entry1
	.dw @entry2
	.dw @entry3
	.dw @header

; Data format:
;   b0: the byte to encode (somewhere in the $c6XX region)
;   b1: the number of bits from that byte to encode

@header: ; Prefixed to every secret type
	.db $04
	.db <wSecretXorCipherIndex	$03
	.db <wSecretType		$02
	.db <wGameID			$08
	.db <wGameID+1			$07

	; Totals to 20 bits

@entry0: ; "Game transfer" secret
@entry1:
	.db $11                     ; Bit number:
	.db <wFileIsHeroGame	$01 ; 20
	.db <wWhichGame		$01 ; 21
	.db <wLinkName		$08 ; 22
	.db <wKidName		$08 ; 30
	.db <wLinkName+1	$08 ; 38
	.db <wKidName+1		$08 ; 46
	.db <wChildStatus	$06 ; 54
	.db <wLinkName+2	$08 ; 60
	.db <wKidName+2		$08 ; 68
	.db <wObtainedRingBox	$01 ; 76
	.db <wLinkName+3	$08 ; 77
	.db <wAnimalCompanion	$04 ; 85
	.db <wLinkName+4	$08 ; 89
	.db <wKidName+3		$08 ; 97
	.db <wFileIsLinkedGame	$01 ; 105
	.db <wKidName+4		$08 ; 106
	.db <wLinkName+5	$02 ; 114 (This is always 00)

	; Totals to 96 bits
	; (plus 20 from header, plus 4 for checksum = 120 bits = 20 6-bit characters)

@entry2: ; Ring secret
	.db $09
	.db <wRingsObtained+1 $08
	.db <wRingsObtained+5 $08
	.db <wRingsObtained+7 $08
	.db <wRingsObtained+3 $08
	.db <wRingsObtained+0 $08
	.db <wRingsObtained+4 $08
	.db <wRingsObtained+2 $08
	.db <wRingsObtained+6 $08
	.db <wLinkName+5 $02 ; This is always 0

	; Totals to 66 bits

@entry3: ; Normal secret
	.db $01
	.db <wShortSecretIndex $06

;;
; @param	c	Secret type
; @param[out]	a,b	Number of characters in secret
getNumCharactersForSecretType:
	ld a,c
	ld hl,@lengths
	rst_addAToHl
	ld a,(hl)
	ld b,a
	ret

@lengths:
	.db 20 20 15 5

; The xor cipher works by starting at position [wSecretXorCipherIndex]*4 in this dataset
; and subsequently xoring every byte in the secret with the proceeding values.
; (The bits corresponding to the cipher index in the secret are not xored, though, so that
; it can be deciphered properly.)
secretXorCipher:

.ifdef REGION_JP
	.db $31 $09 $29 $3b $18 $3c $17 $33
	.db $35 $01 $0b $0a $30 $21 $2d $25
	.db $20 $3a $2f $1e $39 $19 $2a $06
	.db $04 $15 $23 $2e $32 $28 $13 $34
	.db $10 $0d $3f $1a $37 $0f $3e $36
	.db $38 $02 $16 $3d $2c $0e $1b $12

	; TODO: what is this? Is the cipher in the japanese version just unnecessarily longer?
	.db $63 $65 $67 $30 $68 $71 $31 $6b
	.db $75 $77 $6e $ae $32 $6f $6d $61
	.db $72 $7f $7d $6c $62 $64 $86 $78
	.db $33 $7b $6a $9c $66 $7a $8b $83
	.db $69 $79 $84 $85 $7c $88 $74 $73
	.db $35 $36 $37 $8c $ad $82 $81 $87
	.db $70 $7e $60 $8d $a0 $89 $38 $9b
	.db $a5 $80 $ac $39 $34 $aa $97 $a1
.else
	.db $15 $23 $2e $04 $0d $3f $1a $10
	.db $3a $2f $1e $20 $0f $3e $36 $37
	.db $09 $29 $3b $31 $02 $16 $3d $38
	.db $28 $13 $34 $32 $01 $0b $0a $35
	.db $0e $1b $12 $2c $21 $2d $25 $30
	.db $19 $2a $06 $39 $3c $17 $33 $18
.endif

.ends
