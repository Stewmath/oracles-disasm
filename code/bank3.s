;;
; This is the first thing the game jumps to on startup.
; @addr{4000}
init:
	di			; $4000
	xor a			; $4001
	ld ($ff00+R_IF),a	; $4002
	ld ($ff00+R_IE),a	; $4004
	ld ($ff00+R_STAT),a	; $4006
	ld ($ff00+R_TAC),a	; $4008
	ld ($ff00+R_SC),a	; $400a
	xor a			; $400c
	ld ($1111),a		; $400d

	call disableLcd		; $4010

	ldh a,(<hGameboyType)	; $4013
	or a			; $4015
	jr z,+			; $4016

	; Initialize CGB registers
	xor a			; $4018
	ld ($ff00+R_RP),a	; $4019
	ld ($ff00+R_SVBK),a	; $401b
	ld ($ff00+R_VBK),a	; $401d
	call _setCpuToDoubleSpeed		; $401f
+
	ld hl,hActiveFileSlot		; $4022
.ifdef ROM_AGES
	ld b,hramEnd-hActiveFileSlot		; $4025
.else
	; hFFBE and hFFBF not cleared in seasons
	ld b,hramEnd-hActiveFileSlot-2		; $4025
.endif
	call clearMemory		; $4027

	; Clear all memory after the stacks
	ld hl,wThread3StackTop		; $402a
	ld bc,$dfff-wThread3StackTop		; $402d
	call clearMemoryBc		; $4030

	call clearVram		; $4033

	; Copy DMA function to hram
	ld hl,_oamDmaFunction		; $4036
	ld de,hOamFunc		; $4039
	ld b,_oamDmaFunctionEnd-_oamDmaFunction		; $403c
	call copyMemory		; $403e

	; Initialize DMG palettes
	ld a,%11100100		; $4041
	ld ($ff00+R_BGP),a	; $4043
	ld ($ff00+R_OBP0),a	; $4045
	ld a,%01101100		; $4047
	ld ($ff00+R_OBP1),a	; $4049

	call initSound		; $404b

	ld a,$c7		; $404e
	ld ($ff00+R_LYC),a	; $4050
	ld a,$40		; $4052
	ld ($ff00+R_STAT),a	; $4054

	xor a			; $4056
	ld ($ff00+R_IF),a	; $4057
	ld a,$0f		; $4059
	ld ($ff00+R_IE),a	; $405b

	callab bank3f.initGbaModePaletteData		; $405d
	ei			; $4065
	callab bank2.checkDisplayDmgModeScreen		; $4066

	jp startGame		; $406e

;;
; @addr{4071}
_setCpuToDoubleSpeed:
	ld a,($ff00+R_KEY1)	; $4071
	rlca			; $4073
	ret c			; $4074

	xor a			; $4075
	ld ($ff00+R_IF),a	; $4076
	ld ($ff00+R_IE),a	; $4078
	ld a,$01		; $407a
	ld ($ff00+R_KEY1),a	; $407c
	ld a,$30		; $407e
	ld ($ff00+R_P1),a	; $4080
	stop			; $4082
	nop			; $4083
-
	ld a,($ff00+R_KEY1)	; $4084
	rlca			; $4086
	jr nc,-			; $4087

	xor a			; $4089
	ld ($ff00+R_P1),a	; $408a
	ld ($ff00+R_IF),a	; $408c
	ld ($ff00+R_IE),a	; $408e
	ret			; $4090

;;
; This is copied to RAM and run from there.
; @addr{4091}
_oamDmaFunction:
	ld a,>wOam		; $4091
	ld ($ff00+R_DMA),a	; $4093
	ld a,$28		; $4095
-
	dec a			; $4097
	jr nz,-			; $4098
	ret			; $409a
_oamDmaFunctionEnd:


; Speed table for objects.
;
; It's organized in a sort of complicated way which allows it to reuse certain sin and cos
; values for certain angles, ie. an angle of $08 (right) uses the same values for its
; Y speed as angle $00 (up) does for its X speed. Due to this, there is an extra .dwsin
; line at the end of each repetition which is used for angle $18-$1f's X positions only.
;
; @addr{409b}
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
; @addr{481b}
generateGameTransferSecret:
	ld hl,wFileIsLinkedGame		; $481b
	ldi a,(hl)		; $481e
	ld b,(hl)		; $481f
	ld c,a			; $4820
	push bc			; $4821

	; When generating a game-transfer secret: if this file is either linked or
	; a hero's file, mark the secret as a "hero's secret"; otherwise, it's just
	; linked? (so basically, only the secret from the first game is marked as
	; linked...)
	or b			; $4822
	ldd (hl),a		; $4823
	xor $01			; $4824
	or b			; $4826
	ld (hl),a		; $4827

	ldbc $00,$00		; $4828
	call secretFunctionCaller_body		; $482b

	pop bc			; $482e
	ld hl,wFileIsLinkedGame		; $482f
	ld (hl),c		; $4832
	inc l			; $4833
	ld (hl),b		; $4834
	ret			; $4835

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
; @addr{4836}
secretFunctionCaller_body:
	push de			; $4836
	ld a,($ff00+R_SVBK)	; $4837
	push af			; $4839
	ld a,TEXT_BANK		; $483a
	ld ($ff00+R_SVBK),a	; $483c

	call @jumpTable		; $483e

	pop af			; $4841
	ld ($ff00+R_SVBK),a	; $4842
	pop de			; $4844
	ret			; $4845

@jumpTable:
	ld a,b			; $4846
	rst_jumpTable			; $4847
	.dw _generateSecret
	.dw _unpackSecret
	.dw _verifyUnpackedSecretGameID
	.dw _generateGameIDIfNeeded
	.dw _loadUnpackedSecretData


;;
; Generates a secret. If this is one of the 5-letter secrets, then wShortSecretIndex
; should be set to the corresponding secret's index (?) before calling this.
;
; @param	c	Value for wSecretType
; @addr{4852}
_generateSecret:
	ld hl,w7SecretText1		; $4852
	ld b,$40		; $4855
	call clearMemory		; $4857

	call _andCWith3		; $485a
	call _generateGameIDIfNeeded		; $485d

	call @determineXorCipher		; $4860
	ld hl,wSecretXorCipherIndex		; $4863
	ldi (hl),a		; $4866
	ld (hl),c ; hl = wSecretType

	ld a,$04 ; Encode the gameID
	call _encodeSecretData		; $486a
	; Encode everything else (c is unmodified from before)
	call _encodeSecretData_paramC		; $486d

	; Calculate checksum (4 bits) and insert it at the end
	ld b,$04		; $4870
	xor a			; $4872
	call _insertBitsIntoSecretGenerationBuffer		; $4873
	call _getSecretBufferChecksum		; $4876
	ld hl,w7SecretGenerationBuffer+19		; $4879
	or (hl)			; $487c
	ld (hl),a		; $487d

	call _shiftSecretBufferContentsToFront		; $487e
	call _runXorCipherOnSecretBuffer		; $4881
	jp _convertSecretBufferToText		; $4884

;;
; Decides which xor cipher to use based on GameID (and, for 5-letter secrets, based on
; which secret it is).
;
; @param	c
; @param[out]	a	Which xor cipher to use (from 0-7)
; @addr{4887}
@determineXorCipher:
	push bc			; $4887
	ld hl,wGameID		; $4888
	ldi a,(hl)		; $488b
	add (hl)
	ld b,a			; $488d
	ld a,c			; $488e
	cp $03			; $488f
	ld a,b			; $4891
	jr nz,@ret		; $4892

	ld l,<wShortSecretIndex		; $4894
	ld a,(hl)		; $4896
	swap a			; $4897
	and $0f			; $4899
	add b			; $489b
	ld b,a			; $489c
	ld a,(hl)		; $489d
	and $01			; $489e
	rlca			; $48a0
	rlca			; $48a1
	xor b			; $48a2
@ret:
	and $07			; $48a3
	pop bc			; $48a5
	ret			; $48a6

;;
; @param	c	Secret type to encode (0-4)
; @addr{48a7}
_encodeSecretData_paramC:
	ld a,c			; $48a7

;;
; Encodes data into a secret by shifting in the required bits.
;
; @param	a	Secret type to encode (0-4)
; @addr{48a8}
_encodeSecretData:
	push bc			; $48a8
	ld hl,_secretDataToEncodeTable		; $48a9
	rst_addDoubleIndex			; $48ac
	ldi a,(hl)		; $48ad
	ld h,(hl)		; $48ae
	ld l,a			; $48af

	ldi a,(hl)		; $48b0
	ld c,a			; $48b1
--
	ldi a,(hl)		; $48b2
	ld e,a			; $48b3
	ldi a,(hl)		; $48b4
	ld b,a			; $48b5
	ld d,>wc600Block		; $48b6
	ld a,(de)		; $48b8
	call _insertBitsIntoSecretGenerationBuffer		; $48b9
	dec c			; $48bc
	jr nz,--		; $48bd
	pop bc			; $48bf
	ret			; $48c0

;;
; Encodes the given bits into w7SecretGenerationBuffer.
;
; It works by shifting each individual bit in, starting from the end of the buffer. If
; anything overflows it will be lost.
;
; @param	a	Byte to encode
; @param	b	Number of bits to encode
; @addr{48c1}
_insertBitsIntoSecretGenerationBuffer:
	push hl			; $48c1
	push bc			; $48c2
	ld c,a			; $48c3
---
	ld hl,w7SecretGenerationBuffer+19		; $48c4
	ld e,20			; $48c7
	srl c			; $48c9
--
	ld a,(hl)		; $48cb
	rla			; $48cc
	ldd (hl),a		; $48cd
	rla			; $48ce
	rla			; $48cf
	dec e			; $48d0
	jr nz,--		; $48d1
	dec b			; $48d3
	jr nz,---		; $48d4

	; Iterate through all characters to remove anything in the upper 2 bits
	ld hl,w7SecretGenerationBuffer		; $48d6
	ldde $3f,20		; $48d9
--
	ld a,(hl)		; $48dc
	and d			; $48dd
	ldi (hl),a		; $48de
	dec e			; $48df
	jr nz,--		; $48e0

	pop bc			; $48e2
	pop hl			; $48e3
	ret			; $48e4

;;
; Unpacks a secret's data to wTmpcec0. (each entry in "_secretDataToEncodeTable" gets
; a separate byte in the output.)
;
; Input (the secret in ascii) and output (the unpacked data) are both in wTmpcec0.
;
; @param	c	Secret type
; @param[out]	b	$00 if secret was valid, $01 otherwise
; @addr{48e5}
_unpackSecret:
	ld hl,w7SecretText1		; $48e5
	ld b,$40		; $48e8
	call clearMemory		; $48ea
	call _andCWith3		; $48ed
	call _loadSecretBufferFromText		; $48f0
	jr c,@fail			; $48f3

	call _runXorCipherOnSecretBuffer		; $48f5

	; Retrieve checksum in 'e', then remove the checksum bits from the secret buffer
	call _getNumCharactersForSecretType		; $48f8
	ld hl,w7SecretGenerationBuffer-1		; $48fb
	rst_addAToHl			; $48fe
	ld a,(hl)		; $48ff
	and $0f			; $4900
	ld e,a			; $4902
	xor (hl)		; $4903
	ld (hl),a		; $4904

	call _getSecretBufferChecksum		; $4905
	cp e			; $4908
	jr nz,@fail	; $4909

	call @unpackSecretData		; $490b

	; Check the value of "wSecretType" stored in the secret, make sure it's correct
	ld a,(wTmpcec0+1)		; $490e
	cp c			; $4911
	jr nz,@fail	; $4912

	ld b,$00		; $4914
	ret			; $4916
@fail:
	ld b,$01		; $4917
	ret			; $4919

;;
; @addr{491a}
@unpackSecretData:
	ld de,wTmpcec0		; $491a
	ld a,$04 ; Unpack gameID, etc
	call @unpack		; $491f

	ld a,c ; Unpack the meat of the data

;;
; @param	a	Secret type
; @param	de	Address to write the extracted data to
; @addr{4923}
@unpack:
	ld hl,_secretDataToEncodeTable		; $4923
	rst_addDoubleIndex			; $4926
	ldi a,(hl)		; $4927
	ld h,(hl)		; $4928
	ld l,a			; $4929

	ldi a,(hl)		; $492a
	ld b,a			; $492b
@@nextEntry:
	inc hl			; $492c
	ldi a,(hl)		; $492d
	call @readBits		; $492e
	ld (de),a		; $4931
	inc de			; $4932
	dec b			; $4933
	jr nz,@@nextEntry		; $4934
	ret			; $4936

;;
; @param	a	Number of bits to read from the start of w7SecretGenerationBuffer
; @param[out]	a	The value of the bits retrieved
; @addr{4937}
@readBits:
	push bc			; $4937
	push de			; $4938
	push hl			; $4939
	ld b,a			; $493a
	ld c,a			; $493b
	ld d,$00		; $493c
---
	; Rotate the entire buffer left one bit
	ld hl,w7SecretGenerationBuffer+19		; $493e
	ld e,20			; $4941
--
	rl (hl)			; $4943
	ld a,(hl)		; $4945
	rla			; $4946
	rla			; $4947
	dec hl			; $4948
	dec e			; $4949
	jr nz,--		; $494a

	rr d ; Rotate leftmost bit into d
	dec b			; $494e
	jr nz,---		; $494f

	; Result is now in the upper bits of 'd'. We still need to shift it into the lower
	; bits.
	ld a,$08		; $4951
	sub c			; $4953
	ld b,a			; $4954
	ld a,d			; $4955
	jr z,@@end		; $4956
--
	rrca			; $4958
	dec b			; $4959
	jr nz,--		; $495a
@@end:
	pop hl			; $495c
	pop de			; $495d
	pop bc			; $495e
	ret			; $495f

;;
; Loads the data associated with an unpacked secret (ie. for game-transfer secrets, copies
; over player name, animal companion, game type, etc.)
;
; @addr{4960}
_loadUnpackedSecretData:
	call _andCWith3		; $4960
	rst_jumpTable			; $4963
	.dw @type0
	.dw @type1
	.dw @type2
	.dw @type3

@type0: ; Game-transfer secret
@type1:
	ld hl,_secretDataToEncodeTable@entry0		; $496c
	ldi a,(hl)		; $496f
	ld b,a			; $4970
	ld de,wTmpcec0+4 ; Start from +4 to skip the "header"
--
	ld a,(de)		; $4974
	push de			; $4975
	ld e,(hl)		; $4976
	ld d,>wc600Block		; $4977
	ld (de),a		; $4979
	pop de			; $497a
	inc de			; $497b
	inc hl			; $497c
	inc hl			; $497d
	dec b			; $497e
	jr nz,--		; $497f

	; Copy the secret's game ID
	ld hl,wGameID		; $4981
	ld a,(wTmpcec0+2)		; $4984
	ldi (hl),a		; $4987
	ld a,(wTmpcec0+3)		; $4988
	ld (hl),a		; $498b

@type3: ; 5-letter secret
	ret			; $498c

@type2: ; Ring secret
	ld hl,_secretDataToEncodeTable@entry2+1		; $498d
	ld b,$08		; $4990
	ld de,wTmpcec0+4 ; Start from +4 to skip the "header"
--
	ldi a,(hl)		; $4995
	push hl			; $4996
	ld l,a			; $4997
	ld h,>wc600Block		; $4998
	ld a,(de)		; $499a
	or (hl)			; $499b
	ld (hl),a		; $499c
	pop hl			; $499d
	inc de			; $499e
	inc hl			; $499f
	dec b			; $49a0
	jr nz,--		; $49a1
	ret			; $49a3

;;
; @addr{49a4}
_verifyUnpackedSecretGameID:
	; Get the gameID of an unpacked secret
	ld hl,wTmpcec0+2		; $49a4
	ldi a,(hl)		; $49a7
	ld d,(hl)		; $49a8
	ld e,a			; $49a9

	; If the GameID is zero, accept the secret.
	; This means that any secret encoded with GameID 0 works on EVERY file, regardless
	; of that file's game ID. Was this intentional?
	or d			; $49aa
	jr z,@success		; $49ab

	; If nonzero, check that it matches this game's gameID
	ld hl,wGameID		; $49ad
	ldi a,(hl)		; $49b0
	cp e			; $49b1
	jr nz,@fail		; $49b2
	ldi a,(hl)		; $49b4
	cp d			; $49b5
	jr z,@success		; $49b6
@fail:
	ld b,$01		; $49b8
	ret			; $49ba
@success:
	ld b,$00		; $49bb
	ret			; $49bd

;;
; Generates a gameID if one hasn't been calculated yet.
; @addr{49be}
_generateGameIDIfNeeded:
	ld hl,wGameID		; $49be
	ldi a,(hl)		; $49c1
	or (hl)			; $49c2
	ret nz			; $49c3

	; Base the ID on wPlaytimeCounter (which should be pseudo-random).
	ld l,<wPlaytimeCounter+1		; $49c4
	ldd a,(hl)		; $49c6
	and $7f			; $49c7
	ld b,a			; $49c9
	ld a,(hl)		; $49ca
	jr nz,+			; $49cb
--
	; The GameID can't be 0, so read from R_DIV until we get a nonzero value.
	or a			; $49cd
	jr nz,+			; $49ce
	ld a,($ff00+R_DIV)	; $49d0
	jr --			; $49d2
+
	ld l,<wGameID		; $49d4
	ldi (hl),a		; $49d6
	ld (hl),b		; $49d7
	ret			; $49d8

;;
; Copies the data from w7SecretGenerationBuffer to w7SecretText1. The former consists of
; "raw bytes", while the latter is ascii.
;
; @addr{49d9}
_convertSecretBufferToText:
	ld a,c			; $49d9
	ld hl,@secretSpacingData		; $49da
	rst_addDoubleIndex			; $49dd
	ldi a,(hl)		; $49de
	ld b,(hl)		; $49df
	ld c,a			; $49e0
	ld de,w7SecretGenerationBuffer		; $49e1
	ld hl,w7SecretText1		; $49e4
@nextGroup:
	ld a,(bc)		; $49e7
	and $0f			; $49e8
	ret z			; $49ea

	push bc			; $49eb
	ld b,a			; $49ec
@nextSymbol:
	ld a,(de)		; $49ed
	push hl			; $49ee
	ld hl,secretSymbols		; $49ef
	rst_addAToHl			; $49f2
	ld a,(hl)		; $49f3
	pop hl			; $49f4
	ldi (hl),a		; $49f5
	inc de			; $49f6
	dec b			; $49f7
	jr nz,@nextSymbol	; $49f8

	pop bc			; $49fa
	ld a,(bc)		; $49fb
	and $f0			; $49fc
	ldi (hl),a		; $49fe
	inc bc			; $49ff
	jr @nextGroup		; $4a00


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
; @addr{4a15}
_loadSecretBufferFromText:
	call _getNumCharactersForSecretType		; $4a15
	ld hl,wTmpcec0		; $4a18
	ld de,w7SecretGenerationBuffer		; $4a1b
--
	ldi a,(hl)		; $4a1e
	call @textCharacterToByte		; $4a1f
	ret c			; $4a22
	ld (de),a		; $4a23
	inc de			; $4a24
	dec b			; $4a25
	jr nz,--		; $4a26
	ret			; $4a28

;;
; @param	a	Ascii symbol
; @param[out]	a	Byte corresponding to value
; @param[out]	cflag	Set if there's no byte corresponding to it
; @addr{4a29}
@textCharacterToByte:
	push hl			; $4a29
	push bc			; $4a2a
	ld hl,secretSymbols		; $4a2b
	ldbc $40,$00		; $4a2e
--
	cp (hl)			; $4a31
	jr z,@end		; $4a32
	inc hl			; $4a34
	inc c			; $4a35
	dec b			; $4a36
	jr nz,--		; $4a37
	scf			; $4a39
@end:
	ld a,c			; $4a3a
	pop bc			; $4a3b
	pop hl			; $4a3c
	ret			; $4a3d

;;
; This xors all bytes in w7SecretGenerationBuffer with the corresponding cipher
; (determined by the first 3 bits in the secret buffer).
;
; @addr{4a3e}
_runXorCipherOnSecretBuffer:
	call _getNumCharactersForSecretType		; $4a3e

	; Determine cipher ID from the first 3 bits of the secret (corresponds to
	; wSecretXorCipherIndex)
	ld a,(w7SecretGenerationBuffer)		; $4a41
	and $38			; $4a44
	rrca			; $4a46
	ld de,_secretXorCipher		; $4a47
	call addAToDe		; $4a4a

	ld hl,w7SecretGenerationBuffer		; $4a4d
	ld a,(de)		; $4a50

	; For the first byte only, don't xor the upper bits so that the cipher ID remains
	; intact.
	and $07
--
	xor (hl)		; $4a53
	ldi (hl),a		; $4a54
	inc de			; $4a55
	ld a,(de)		; $4a56
	dec b			; $4a57
	jr nz,--		; $4a58
	ret			; $4a5a

;;
; @param[out]	a	The last 4 bits of the sum of all bytes in w7SecretGenerationBuffer
; @addr{4a5b}
_getSecretBufferChecksum:
	ld hl,w7SecretGenerationBuffer		; $4a5b
	ld b,20			; $4a5e
	xor a			; $4a60
--
	add (hl)		; $4a61
	inc hl			; $4a62
	dec b			; $4a63
	jr nz,--		; $4a64
	and $0f			; $4a66
	ret			; $4a68

;;
; For smaller secrets (length < 20), this shifts the contents of the secret to the front
; of the buffer.
;
; @param	c	Secret type
; @addr{4a69}
_shiftSecretBufferContentsToFront:
	call _getNumCharactersForSecretType		; $4a69
	ld a,20		; $4a6c
	sub b			; $4a6e
	ret z			; $4a6f

	ld de,w7SecretGenerationBuffer		; $4a70
	ld h,d			; $4a73
	ld l,e			; $4a74
	rst_addAToHl			; $4a75
--
	ldi a,(hl)		; $4a76
	ld (de),a		; $4a77
	inc de			; $4a78
	dec b			; $4a79
	jr nz,--		; $4a7a
	ret			; $4a7c

;;
; @addr{4a7d}
_andCWith3:
	ld a,c			; $4a7d
	and $03			; $4a7e
	ld c,a			; $4a80
	ret			; $4a81


; This lists the data that a particular secret type must encode.
_secretDataToEncodeTable:
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
; @addr{4ace}
_getNumCharactersForSecretType:
	ld a,c			; $4ace
	ld hl,@lengths		; $4acf
	rst_addAToHl			; $4ad2
	ld a,(hl)		; $4ad3
	ld b,a			; $4ad4
	ret			; $4ad5

@lengths:
	.db 20 20 15 5

; The xor cipher works by starting at position [wSecretXorCipherIndex]*4 in this dataset
; and subsequently xoring every byte in the secret with the proceeding values.
; (The bits corresponding to the cipher index in the secret are not xored, though, so that
; it can be deciphered properly.)
_secretXorCipher:
	.db $15 $23 $2e $04 $0d $3f $1a $10
	.db $3a $2f $1e $20 $0f $3e $36 $37
	.db $09 $29 $3b $31 $02 $16 $3d $38
	.db $28 $13 $34 $32 $01 $0b $0a $35
	.db $0e $1b $12 $2c $21 $2d $25 $30
	.db $19 $2a $06 $39 $3c $17 $33 $18


;;
; Used for CUTSCENE_FLAMES_FLICKERING and CUTSCENE_TWINROVA_SACRIFICE.
;
; @addr{4b0a}
twinrovaCutsceneCaller:
	ld a,c			; $4b0a
	rst_jumpTable			; $4b0b
	.dw _cutscene18_body
	.dw _cutscene19_body

;;
; @addr{4b10}
_incCutsceneState:
	ld hl,wCutsceneState		; $4b10
	inc (hl)		; $4b13
	ret			; $4b14

;;
; Unused
; @addr{4b15}
unused_incTmpcbb3:
	ld hl,wTmpcbb3		; $4b15
	inc (hl)		; $4b18
	ret			; $4b19

;;
; @addr{4b1a}
_decTmpcbb4:
	ld hl,wTmpcbb4		; $4b1a
	dec (hl)		; $4b1d
	ret			; $4b1e

;;
; @addr{4b1f}
_setScreenShakeCounterTo255:
	ld a,$ff		; $4b1f
	jp setScreenShakeCounter		; $4b21

;;
; State 0: screen fadeout
; @addr{4b24}
_twinrovaCutscene_state0:
	ld a,$04		; $4b24
	call fadeoutToWhiteWithDelay		; $4b26
	ld hl,wTmpcbb3		; $4b29
	ld b,$10		; $4b2c
	call clearMemory		; $4b2e
	jr _incCutsceneState		; $4b31

;;
; State 1: fading out, then initialize fadein to zelda sacrifice room
; @addr{4b33}
_twinrovaCutscene_state1:
	ld a,(wPaletteThread_mode)		; $4b33
	or a			; $4b36
	ret nz			; $4b37

	call _incCutsceneState		; $4b38

.ifdef ROM_AGES
	ld a,$f1 ; Room with zelda and torches
.else
	ld a,$9a ; Room with zelda and torches
.endif
	ld (wActiveRoom),a		; $4b3d
	call _twinrovaCutscene_fadeinToRoom		; $4b40

	call refreshObjectGfx		; $4b43

	ld hl,w1Link.yh		; $4b46
	ld (hl),$38		; $4b49
	inc l			; $4b4b
	inc l			; $4b4c
	ld (hl),$78		; $4b4d

	call resetCamera		; $4b4f

	ld hl,objectData.objectData4022
	call parseGivenObjectData		; $4b55

.ifdef ROM_AGES
	ld a,PALH_ac		; $4b58
.else
	ld a,SEASONS_PALH_ac		; $4b58
.endif
	call loadPaletteHeader		; $4b5a

	ld a,$01		; $4b5d
	ld (wScrollMode),a		; $4b5f

	call loadCommonGraphics		; $4b62

	ld a,$04		; $4b65
	call fadeinFromWhiteWithDelay		; $4b67
	ld a,$02		; $4b6a
	jp loadGfxRegisterStateIndex		; $4b6c

;;
; @addr{4b6f}
_twinrovaCutscene_fadeinToRoom:
	call disableLcd		; $4b6f
	call clearScreenVariablesAndWramBank1		; $4b72
	call loadScreenMusicAndSetRoomPack		; $4b75
	call loadTilesetData		; $4b78
	call loadTilesetGraphics		; $4b7b
	jp func_131f		; $4b7e

;;
; CUTSCENE_FLAMES_FLICKERING
; @addr{4b81}
_cutscene18_body:
	ld a,(wCutsceneState)		; $4b81
	rst_jumpTable			; $4b84
	.dw _twinrovaCutscene_state0
	.dw _twinrovaCutscene_state1
	.dw _twinrovaCutscene_state2
	.dw _twinrovaCutscene_state3
	.dw _cutscene18_state4
	.dw _cutscene18_state5

;;
; State 2: waiting for fadein to finish
; @addr{4b91}
_twinrovaCutscene_state2:
	ld a,(wPaletteThread_mode)		; $4b91
	or a			; $4b94
	ret nz			; $4b95
	ld a,$01		; $4b96
	ld (wTmpcbb4),a		; $4b98
	jp _incCutsceneState		; $4b9b

;;
; State 3: initializes stuff for state 4
; @addr{4b9e}
_twinrovaCutscene_state3:
	call _decTmpcbb4		; $4b9e
	ret nz			; $4ba1

	ld (hl),180 ; Wait in state 4 for 180 frames

	call _twinrovaCutscene_deleteAllInteractionsExceptFlames		; $4ba4
	call _twinrovaCutscene_loadAngryFlames		; $4ba7
	ld a,SND_OPENING		; $4baa
	call playSound		; $4bac
	jp _incCutsceneState		; $4baf

;;
; State 4: screen shaking, flames flickering with zelda on pedestal
; @addr{4bb2}
_cutscene18_state4:
	call _setScreenShakeCounterTo255		; $4bb2
	ld a,(wFrameCounter)		; $4bb5
	and $3f			; $4bb8
	jr nz,+			; $4bba
	ld a,SND_OPENING		; $4bbc
	call playSound		; $4bbe
+
	call _decTmpcbb4		; $4bc1
	ret nz			; $4bc4

	; Fadeout
	ld a,$04		; $4bc5
	call fadeoutToWhiteWithDelay		; $4bc7

	jp _incCutsceneState		; $4bca

;;
; State 5: fading out again. When done, it fades in to the next room, and the cutscene's
; over.
; @addr{4bcd}
_cutscene18_state5:
	call _setScreenShakeCounterTo255		; $4bcd
	ld a,(wPaletteThread_mode)		; $4bd0
	or a			; $4bd3
	ret nz			; $4bd4

	; Load twinrova fight room, start a fadein, then exit cutscene
.ifdef ROM_AGES
	ld a,$f5		; $4bd5
.else
	ld a,$9e		; $4bd5
.endif
	ld (wActiveRoom),a		; $4bd7
	call _twinrovaCutscene_fadeinToRoom		; $4bda

	call getFreeEnemySlot		; $4bdd
	ld (hl),ENEMYID_TWINROVA		; $4be0
	ld l,Enemy.var03		; $4be2
	set 7,(hl)		; $4be4

	ld hl,w1Link.enabled		; $4be6
	ld (hl),$03		; $4be9
	ld l,<w1Link.yh		; $4beb
	ld (hl),$78		; $4bed
	inc l			; $4bef
	inc l			; $4bf0
	ld (hl),$78		; $4bf1

	call resetCamera		; $4bf3
	ld a,$01		; $4bf6
	ld (wCutsceneIndex),a		; $4bf8
	ld a,$01		; $4bfb
	ld (wScrollMode),a		; $4bfd
	call loadCommonGraphics		; $4c00

	ld a,$02		; $4c03
	call fadeinFromWhiteWithDelay		; $4c05
	ld a,$02		; $4c08
	jp loadGfxRegisterStateIndex		; $4c0a

;;
; @addr{4c0d}
_twinrovaCutscene_deleteAllInteractionsExceptFlames:
	ldhl FIRST_DYNAMIC_INTERACTION_INDEX, Interaction.start		; $4c0d
@next:
	ld l,Interaction.start		; $4c10
	ldi a,(hl)		; $4c12
	or a			; $4c13
	jr z,+			; $4c14
	ldi a,(hl)		; $4c16
.ifdef ROM_AGES
	cp INTERACID_TWINROVA_FLAME			; $4c17
.else
	cp INTERACID_TWINROVA_IN_CUTSCENE			; $4c17
.endif
	call z,@delete		; $4c19
+
	inc h			; $4c1c
	ld a,h			; $4c1d
	cp $e0			; $4c1e
	jr c,@next		; $4c20
	ret			; $4c22

@delete:
	dec l			; $4c23
	ld b,$40		; $4c24
	jp clearMemory		; $4c26

;;
; Loads the "angry-looking" version of the flames.
; @addr{4c29}
_twinrovaCutscene_loadAngryFlames:
.ifdef ROM_AGES
	ld a,PALH_af		; $4c29
.else
	ld a,SEASONS_PALH_af		; $4c29
.endif
	call loadPaletteHeader		; $4c2b
	ld hl,objectData.objectData402f		; $4c2e
	jp parseGivenObjectData		; $4c31

;;
; CUTSCENE_TWINROVA_SACRIFICE
; @addr{4c34}
_cutscene19_body:
	ld a,(wCutsceneState)		; $4c34
	rst_jumpTable			; $4c37
	.dw _twinrovaCutscene_state0
	.dw _twinrovaCutscene_state1
	.dw _twinrovaCutscene_state2
	.dw _twinrovaCutscene_state3
	.dw _cutscene19_state4
	.dw _cutscene19_state5
	.dw _cutscene19_state6
	.dw _cutscene19_state7
	.dw _cutscene19_state8
	.dw _cutscene19_state9

;;
; After fading in to zelda on the pedestal, this shows the "angry flames" and waits for
; 3 seconds before striking the first flame with lightning.
; @addr{4c4c}
_cutscene19_state4:
	call _decTmpcbb4		; $4c4c
	ret nz			; $4c4f

	ld (hl),20		; $4c50
	ld bc,$1878		; $4c52
_cutscene19_strikeFlameWithLightning:
	call _twinrovaCutscene_createLightningStrike		; $4c55
	jp _incCutsceneState		; $4c58

;;
; State 5: wait before striking the 2nd flame with lightning.
; @addr{4c5b}
_cutscene19_state5:
	call _decTmpcbb4		; $4c5b
	ret nz			; $4c5e

	ld (hl),20		; $4c5f
	ld bc,$48a8		; $4c61
	jr _cutscene19_strikeFlameWithLightning		; $4c64

;;
; State 6: wait before striking the 3rd flame with lightning.
; @addr{4c66}
_cutscene19_state6:
	call _decTmpcbb4		; $4c66
	ret nz			; $4c69

	ld (hl),40		; $4c6a
	ld bc,$4848		; $4c6c
	jr _cutscene19_strikeFlameWithLightning		; $4c6f

;;
; State 7: wait before shaking screen around
; @addr{4c71}
_cutscene19_state7:
	call _decTmpcbb4		; $4c71
	ret nz			; $4c74

	ld (hl),120		; $4c75
	ld a,SND_BOSS_DEAD		; $4c77
	call playSound		; $4c79
	jp _incCutsceneState		; $4c7c

;;
; State 8: shake the screen and repeatedly flash the screen white
; @addr{4c7f}
_cutscene19_state8:
	call _setScreenShakeCounterTo255		; $4c7f
	ld a,(wFrameCounter)		; $4c82
	and $07			; $4c85
	call z,fastFadeinFromWhite		; $4c87
	call _decTmpcbb4		; $4c8a
	ret nz			; $4c8d

	ld a,$04		; $4c8e
	call fadeoutToWhiteWithDelay		; $4c90
	ld a,SND_FADEOUT		; $4c93
	call playSound		; $4c95
	jp _incCutsceneState		; $4c98

;;
; State 9: wait before fading back to twinrova. Cutscene ends here.
; @addr{4c9b}
_cutscene19_state9:
	call _setScreenShakeCounterTo255		; $4c9b
	ld a,(wPaletteThread_mode)		; $4c9e
	or a			; $4ca1
	ret nz			; $4ca2

	call clearScreenVariablesAndWramBank1		; $4ca3
	ld a,CUTSCENE_INGAME		; $4ca6
	ld (wCutsceneIndex),a		; $4ca8
	ld a,$01		; $4cab
	ld (wScrollMode),a		; $4cad

	call getFreeEnemySlot		; $4cb0
	ld (hl),ENEMYID_GANON		; $4cb3

	ld a,SNDCTRL_STOPMUSIC		; $4cb5
	jp playSound		; $4cb7

;;
; @param	bc	Position to strike
; @addr{4cba}
_twinrovaCutscene_createLightningStrike:
	call getFreePartSlot		; $4cba
	ret nz			; $4cbd
	ld (hl),PARTID_LIGHTNING		; $4cbe
	inc l			; $4cc0
	inc (hl)		; $4cc1
	ld l,Part.yh		; $4cc2
	ld (hl),b		; $4cc4
	inc l			; $4cc5
	inc l			; $4cc6
	ld (hl),c		; $4cc7
	ret			; $4cc8

;;
; This function is part of the main loop until the player reaches the file select screen.
; @addr{4cc9}
runIntro:
	ldh a,(<hSerialInterruptBehaviour)	; $4cc9
	or a			; $4ccb
	jr z,+			; $4ccc

	call serialFunc_0c8d		; $4cce
	ld a,$09		; $4cd1
	ld (wTmpcbb4),a		; $4cd3
	jr @nextStage			; $4cd6
+
	call serialFunc_0c85		; $4cd8
	ld a,$03		; $4cdb
	ldh (<hFFBE),a	; $4cdd
	xor a			; $4cdf
	ldh (<hFFBF),a	; $4ce0
	ld a,(wKeysJustPressed)		; $4ce2
	and BTN_START		; $4ce5
	jr z,_intro_runStage		; $4ce7

@nextStage:
	ldh a,(<hIntroInputsEnabled)	; $4ce9
	add a			; $4ceb
	jr z,_intro_runStage		; $4cec

	ld a,(wIntroStage)		; $4cee
	cp $03			; $4cf1
	jr nz,_intro_gotoTitlescreen	; $4cf3

;;
; @addr{4cf5}
_intro_runStage:
	ld a,(wIntroStage)		; $4cf5
	rst_jumpTable			; $4cf8
	.dw _intro_uninitialized
	.dw _intro_capcomScreen
	.dw intro_cinematic
	.dw _intro_titlescreen
	.dw _intro_restart

;;
; Advance the intro to the next stage (eg. cinematic -> titlescreen)
; @addr{4d03}
_intro_gotoTitlescreen:
	call clearPaletteFadeVariables		; $4d03
	call _cutscene_clearObjects		; $4d06
	ld hl,wIntroVar		; $4d09
	xor a			; $4d0c
	ldd (hl),a		; $4d0d
	ldh (<hCameraY),a	; $4d0e
	ld (wTmpcbb6),a		; $4d10
	ld (hl),$03 ; hl = wIntroStage
	dec a			; $4d15
	ld (wTilesetAnimation),a		; $4d16
	jr _intro_runStage	; $4d19

;;
; @addr{4d1b}
_intro_restart:
	xor a			; $4d1b
	ld (wIntroStage),a		; $4d1c
	ld (wIntroVar),a		; $4d1f
	ret			; $4d22

;;
; @addr{4d23}
_intro_gotoNextStage:
	call enableIntroInputs		; $4d23
	call clearDynamicInteractions		; $4d26
	ld hl,wIntroStage		; $4d29
	inc (hl)		; $4d2c
	inc l			; $4d2d
	ld (hl),$00 ; [wIntroVar] = 0
	jp clearPaletteFadeVariables		; $4d30

;;
; @addr{4d33}
_intro_incState:
	ld hl,wIntroVar		; $4d33
	inc (hl)		; $4d36
	ret			; $4d37

;;
; @addr{4d38}
_intro_uninitialized:
	ld hl,wIntroStage		; $4d38
	inc (hl)		; $4d3b


;;
; @addr{4d3c}
_intro_capcomScreen:
	ld a,(wIntroVar)		; $4d3c
	rst_jumpTable			; $4d3f
	.dw @state0
	.dw @state1
	.dw @state2

;;
; @addr{4d46}
@state0:
	call restartSound		; $4d46

	call clearVram		; $4d49
	ld a,$01		; $4d4c
	call loadGfxHeader		; $4d4e
	ld a,PALH_01		; $4d51
	call loadPaletteHeader		; $4d53

	ld hl,wTmpcbb3		; $4d56
	ld (hl),208		; $4d59
	inc hl			; $4d5b
	ld (hl),$00 ; [wTmpcbb4] = 0

	call _intro_incState		; $4d5e
	call fadeinFromWhite		; $4d61
	xor a			; $4d64
	jp loadGfxRegisterStateIndex		; $4d65

;;
; Fading in, waiting
; @addr{4d68}
@state1:
	ld hl,wTmpcbb3		; $4d68
	call decHlRef16WithCap		; $4d6b
	ret nz			; $4d6e

	call _intro_incState		; $4d6f
	jp fadeoutToWhite		; $4d72

;;
; Fading out
; @addr{4d75}
@state2:
	ld a,(wPaletteThread_mode)		; $4d75
	or a			; $4d78
	ret nz			; $4d79

	xor a			; $4d7a
	ld hl,wIntroStage		; $4d7b
	ld (hl),$02		; $4d7e
	inc l			; $4d80
	ld (hl),a ; [wIntroVar] = 0
	ld (wIntro.cinematicState),a		; $4d82
	jp enableIntroInputs		; $4d85

;;
; @addr{4d88}
_intro_titlescreen:
	call getRandomNumber_noPreserveVars		; $4d88
	call @runState		; $4d8b
	call clearOam		; $4d8e

.ifdef ROM_AGES
	ld hl,bank3f.titlescreenMakuSeedSprite		; $4d91
	ld e,:bank3f.titlescreenMakuSeedSprite		; $4d94
	call addSpritesFromBankToOam		; $4d96

	ld a,(wTmpcbb3)		; $4d99
	and $20			; $4d9c
	ret nz			; $4d9e
	ld hl,bank3f.titlescreenPressStartSprites		; $4d9f
	ld e,:bank3f.titlescreenPressStartSprites		; $4da2
	jp addSpritesFromBankToOam		; $4da4

.else; ROM_SEASONS

	ld hl,titlescreenMakuSeedSprite
	call addSpritesToOam

	ld a,(wTmpcbb3)
	and $20
	ret nz
	ld hl,titlescreenPressStartSprites
	jp addSpritesToOam
.endif

;;
; @addr{4da7}
@runState:
	ld a,(wIntroVar)		; $4da7
	rst_jumpTable			; $4daa
	.dw _intro_titlescreen_state0
	.dw _intro_titlescreen_state1
	.dw _intro_titlescreen_state2
	.dw _intro_titlescreen_state3

;;
; @addr{4db3}
_intro_titlescreen_state0:
	call restartSound		; $4db3

	; Stop any irrelevant threads.
	ld a,THREAD_1		; $4db6
	call threadStop		; $4db8
	call stopTextThread		; $4dbb

	call disableLcd		; $4dbe
	ld a,GFXH_02		; $4dc1
	call loadGfxHeader		; $4dc3
	ld a,PALH_03		; $4dc6
	call loadPaletteHeader		; $4dc8

	; cbb3-cbb4 used as a 2-byte counter until automatically exiting
	ld hl,wTmpcbb3		; $4dcb
	ld a,$60		; $4dce
	ldi (hl),a		; $4dd0
	ld a,$09		; $4dd1
	ldi (hl),a ; [wTmpcbb4] = $09

	call _intro_incState		; $4dd4

	ld a,MUS_TITLESCREEN		; $4dd7
	call playSound		; $4dd9

	ld a,$04		; $4ddc
	jp loadGfxRegisterStateIndex		; $4dde

;;
; State 1: waiting for player to press start
; @addr{4de1}
_intro_titlescreen_state1:
	ld a,(wKeysJustPressed)		; $4de1
	and BTN_START			; $4de4
	jr nz,@pressedStart	; $4de6

	; Check to automatically exit the titlescreen
	ld hl,wTmpcbb3		; $4de8
	call decHlRef16WithCap		; $4deb
	ret nz			; $4dee
	ld a,$02		; $4def
	jr @gotoState		; $4df1

@pressedStart:
	ld a,SND_SELECTITEM		; $4df3
	call playSound		; $4df5
	call serialFunc_0c7e		; $4df8
	ld a,$03		; $4dfb
@gotoState:
	ld (wIntroVar),a		; $4dfd
	ld a,SNDCTRL_FAST_FADEOUT		; $4e00
	call playSound		; $4e02
	jp fadeoutToWhite		; $4e05

;;
; State 2: fading out to replay intro cinematic
; @addr{4e08}
_intro_titlescreen_state2:
	ld a,(wPaletteThread_mode)		; $4e08
	or a			; $4e0b
	ret nz			; $4e0c
	jp _intro_gotoNextStage		; $4e0d

;;
; State 3: fading out to go to file select
; @addr{4e10}
_intro_titlescreen_state3:
	ld a,(wPaletteThread_mode)		; $4e10
	or a			; $4e13
	ret nz			; $4e14

	; Initialize file select thread, stop this thread
	ld a,THREAD_1		; $4e15
	ld bc,fileSelectThreadStart		; $4e17
	call threadRestart		; $4e1a
	jp stubThreadStart		; $4e1d

.ifdef ROM_SEASONS

; In Ages these sprites are located elsewhere

titlescreenMakuSeedSprite:
	.db $12
	.db $51 $7a $56 $04
	.db $50 $82 $74 $04
	.db $58 $7a $6a $07
	.db $58 $82 $6c $07
	.db $58 $8a $6e $07
	.db $48 $90 $62 $06
	.db $44 $8d $68 $06
	.db $54 $8a $54 $03
	.db $54 $82 $52 $03
	.db $54 $7a $50 $03
	.db $40 $85 $66 $06
	.db $40 $7f $64 $06
	.db $41 $70 $60 $06
	.db $54 $76 $5a $06
	.db $44 $68 $5e $26
	.db $64 $7a $70 $03
	.db $64 $82 $72 $03
	.db $64 $8a $70 $23

titlescreenPressStartSprites:
	.db $0a
	.db $80 $2c $38 $00
	.db $80 $34 $3a $00
	.db $80 $3c $3c $00
	.db $80 $44 $3e $00
	.db $80 $4c $3e $00
	.db $80 $5c $3e $00
	.db $80 $64 $40 $00
	.db $80 $6c $42 $00
	.db $80 $74 $3a $00
	.db $80 $7c $40 $00

.endif

;;
; @addr{4e20}
runIntroCinematic:
	ld a,(wIntro.cinematicState)
	rst_jumpTable			; $4e23
	.dw _introCinematic_ridingHorse
	.dw _introCinematic_inTemple
	.dw _introCinematic_preTitlescreen

.ifdef ROM_AGES

;;
; Covers intro sections after the capcom screen and before the temple scene.
; @addr{4e2a}
_introCinematic_ridingHorse:
	ld a,(wIntroVar)		; $4e2a
	rst_jumpTable			; $4e2d
	.dw _introCinematic_ridingHorse_state0
	.dw _introCinematic_ridingHorse_state1
	.dw _introCinematic_ridingHorse_state2
	.dw _introCinematic_ridingHorse_state3
	.dw _introCinematic_ridingHorse_state4
	.dw _introCinematic_ridingHorse_state5
	.dw _introCinematic_ridingHorse_state6
	.dw _introCinematic_ridingHorse_state7
	.dw _introCinematic_ridingHorse_state8
	.dw _introCinematic_ridingHorse_state9
	.dw _introCinematic_ridingHorse_state10

;;
; State 0: initialization
; @addr{4e44}
_introCinematic_ridingHorse_state0:
	call disableLcd		; $4e44
	ld hl,wOamEnd		; $4e47
	ld bc,$d000-wOamEnd	; $4e4a
	call clearMemoryBc		; $4e4d

	ld a,:w4TileMap		; $4e50
	ld ($ff00+R_SVBK),a	; $4e52
	ld hl,w4TileMap		; $4e54
	ld bc,$0120		; $4e57
	call clearMemoryBc		; $4e5a

	ld hl,w4AttributeMap		; $4e5d
	ld bc,$0120		; $4e60
	call clearMemoryBc		; $4e63
	ld a,$01		; $4e66
	ld ($ff00+R_SVBK),a	; $4e68

	call clearOam		; $4e6a
	ld a,<wOam+$10		; $4e6d
	ldh (<hOamTail),a	; $4e6f

	ld a,GFXH_9b		; $4e71
	call loadGfxHeader		; $4e73
.ifdef ROM_AGES
	ld a,PALH_90		; $4e76
.else
	ld a,SEASONS_PALH_90		; $4e76
.endif
	call loadPaletteHeader		; $4e78

	; Use cbb3-cbb4 as a 2-byte counter; wait for 0x15e=350 frames
	ld hl,wTmpcbb3		; $4e7b
	ld (hl),$5e		; $4e7e
	inc hl			; $4e80
	ld (hl),$01		; $4e81

	ld a,$20		; $4e83
	ld ($cbb8),a		; $4e85
	ld a,$10		; $4e88
	ld (wTmpcbb9),a		; $4e8a
	ld a,$22		; $4e8d
	ld (wTmpcbb6),a		; $4e8f
	xor a			; $4e92
	ld (wTmpcbba),a		; $4e93

	ld a,MUS_INTRO_1		; $4e96
	call playSound		; $4e98

	ld a,$0b		; $4e9b
	call fadeinFromWhiteWithDelay		; $4e9d

	; The "bars" at the top and bottom need to be black
	ld hl,wLockBG7Color3ToBlack		; $4ea0
	ld (hl),$01		; $4ea3

	; Load Link and Bird objects
	ld hl,objectData.objectData4037		; $4ea5
	call parseGivenObjectData		; $4ea8

	ld a,$17		; $4eab
	call loadGfxRegisterStateIndex		; $4ead

	ld a,(wGfxRegs2.LCDC)		; $4eb0
	ld (wGfxRegs6.LCDC),a		; $4eb3
	xor a			; $4eb6
	ldh (<hCameraX),a	; $4eb7
	jp _intro_incState		; $4eb9

;;
; State 1: fading into the sunset
; @addr{4ebc}
_introCinematic_ridingHorse_state1:
	call _introCinematic_moveBlackBarsIn		; $4ebc
	ld hl,wTmpcbb3		; $4ebf
	call decHlRef16WithCap		; $4ec2
	ret nz			; $4ec5

	ld (hl),$06		; $4ec6
	call clearPaletteFadeVariablesAndRefreshPalettes		; $4ec8
	ld a,$06		; $4ecb
	ldh (<hNextLcdInterruptBehaviour),a	; $4ecd
	jp _intro_incState		; $4ecf

;;
; State 2: scrolling down to reveal Link on horse
; @addr{4ed2}
_introCinematic_ridingHorse_state2:
	call _introCinematic_ridingHorse_updateScrollingGround		; $4ed2
	call decCbb3		; $4ed5
	ret nz			; $4ed8

	; Set counter to 6 frames (so screen scrolls down once every 6 frames)
	ld (hl),$06		; $4ed9

	ld hl,wGfxRegs2.SCY		; $4edb
	inc (hl)		; $4ede
	ld a,(hl)		; $4edf
	ldh (<hCameraY),a ; Must set CameraY for sprites to scroll correctly

	; Go to next state once we scroll this far down
	cp $48			; $4ee2
	ret nz			; $4ee4
	ld a,126		; $4ee5
	ld (wTmpcbb3),a		; $4ee7
	jp _intro_incState		; $4eea

;;
; Decrements the SCX value for the scrolling ground, and recalculates the value of LYC to
; use for producing the scrolling effect for the ground.
; @addr{4eed}
_introCinematic_ridingHorse_updateScrollingGround:
	ld a,$a8		; $4eed
	ld hl,wGfxRegs2.SCY		; $4eef
	sub (hl)		; $4ef2
	cp $78			; $4ef3
	jr c,+			; $4ef5
	ld a,$c7		; $4ef7
+
	ld (wGfxRegs2.LYC),a		; $4ef9
	ld a,(hl)		; $4efc
	ld hl,wGfxRegs6.SCY		; $4efd
	ldi (hl),a ; SCY should not change at hblank, so copy the value

	ld a,(wIntro.frameCounter) ; Only decrement SCX every other frame
	and $01			; $4f04
	ret nz			; $4f06
	dec (hl) ; hl = wGfxRegs6.SCX
	ret			; $4f08

;;
; State 3: camera has scrolled all the way down; not doing anything for a bit
; @addr{4f09}
_introCinematic_ridingHorse_state3:
	call _introCinematic_ridingHorse_updateScrollingGround		; $4f09
	call decCbb3		; $4f0c
	ret nz			; $4f0f

	; Initialize stuff for state 4

	ld (hl),$20		; $4f10
	inc hl			; $4f12
	ld (hl),$01		; $4f13

.ifdef ROM_AGES
	ld a,PALH_96		; $4f15
.else
	ld a,SEASONS_PALH_96		; $4f15
.endif
	call loadPaletteHeader		; $4f17
	ld a,UNCMP_GFXH_38		; $4f1a
	call loadUncompressedGfxHeader		; $4f1c

	ld a,$18		; $4f1f
	ld (wTmpcbba),a		; $4f21
	call loadGfxRegisterStateIndex		; $4f24

	xor a			; $4f27
	ldh (<hCameraY),a	; $4f28
	ld (wTmpcbbc),a		; $4f2a

	ldbc INTERACID_INTRO_SPRITE, $03		; $4f2d
	call _createInteraction		; $4f30

	ld a,$0d		; $4f33
	ld (wTmpcbb6),a		; $4f35
	ld a,$3c		; $4f38
	ld (wTmpcbbb),a		; $4f3a
	ld a,$03		; $4f3d
	ldh (<hNextLcdInterruptBehaviour),a	; $4f3f
	jp _intro_incState		; $4f41

;;
; State 4: Link riding horse toward camera
; @addr{4f44}
_introCinematic_ridingHorse_state4:
	call @drawLinkOnHorseAndScrollScreen		; $4f44
	ld hl,wTmpcbb3		; $4f47
	call decHlRef16WithCap		; $4f4a
	ret nz			; $4f4d

	ld a,UNCMP_GFXH_36		; $4f4e
	call loadUncompressedGfxHeader		; $4f50

	; After calling "loadUncompressedGfxHeader", hl points to rom. They almost
	; certainly didn't intend to write there. They probably intended for hl to point
	; to wTmpcbb3, and set the counter for the next state?
	; It makes no difference, though, since the next state doesn't use wTmpcbb3.
	ld (hl),90		; $4f53

	ld a,PALH_9b		; $4f55
	call loadPaletteHeader		; $4f57
	call clearDynamicInteractions		; $4f5a
	call clearOam		; $4f5d
	ld a,$19		; $4f60
	call loadGfxRegisterStateIndex		; $4f62

	ld a,$48		; $4f65
	ld (wGfxRegs1.LYC),a		; $4f67
	ld (wGfxRegs2.WINY),a		; $4f6a
	jp _intro_incState		; $4f6d

;;
; @addr{4f70}
@drawLinkOnHorseAndScrollScreen:
	ld hl,bank3f.linkOnHorseFacingCameraSprite		; $4f70
	ld e,:bank3f.linkOnHorseFacingCameraSprite		; $4f73
	call addSpritesFromBankToOam		; $4f75

	; Scroll the top, cloudy layer right every 32 frames
	ld a,(wIntro.frameCounter)		; $4f78
	and $1f			; $4f7b
	jr nz,+			; $4f7d
	ld hl,wGfxRegs1.SCX		; $4f7f
	dec (hl)		; $4f82
+
	; Scroll the mountain layer right every 6 frames
	ld hl,wTmpcbb6		; $4f83
	dec (hl)		; $4f86
	jr nz,+			; $4f87
	ld (hl),$0d		; $4f89
	ld hl,wGfxRegs2.SCX		; $4f8b
	dec (hl)		; $4f8e
+
	; Change link's palette every 60 frames to gradually get lighter
	ld hl,wTmpcbbb		; $4f8f
	dec (hl)		; $4f92
	ret nz			; $4f93
	ld (hl),60		; $4f94
	inc hl			; $4f96
	ld a,(hl)		; $4f97
	cp $03			; $4f98
	ret z			; $4f9a

	inc (hl)		; $4f9b
	ld hl,@linkPalettes		; $4f9c
	rst_addAToHl			; $4f9f
	ld a,(hl)		; $4fa0
	jp loadPaletteHeader		; $4fa1

@linkPalettes:
	.db PALH_a4
	.db PALH_a5
	.db PALH_a6

;;
; State 5: closeup of Link's face; face is moving left
; @addr{4fa7}
_introCinematic_ridingHorse_state5:
	call _introCinematic_moveBlackBarsOut		; $4fa7
	ld hl,wGfxRegs2.SCX		; $4faa
	ld a,(hl)		; $4fad
	add $08			; $4fae
	ld (hl),a		; $4fb0
	cp $60			; $4fb1
	ret c			; $4fb3

	ld (hl),$60		; $4fb4
	call _intro_incState		; $4fb6

	ld hl,wTmpcbb3		; $4fb9
	ld (hl),24 ; Linger for another 24 frames

	ldbc INTERACID_INTRO_SPRITE, $04		; $4fbe
	jp _createInteraction		; $4fc1

;;
; State 6: closeup of Link's face; screen staying still for a moment
; @addr{4fc4}
_introCinematic_ridingHorse_state6:
	ld hl,wTmpcbb3		; $4fc4
	call decHlRef16WithCap		; $4fc7
	ret nz			; $4fca

	call disableLcd		; $4fcb
.ifdef ROM_AGES
	ld a,PALH_92		;$4fce
.else
	ld a,SEASONS_PALH_92	;$4fce
.endif
	call loadPaletteHeader		; $4fd0
	ld a,GFXH_9c		; $4fd3
	call loadGfxHeader		; $4fd5
	call clearDynamicInteractions		; $4fd8
	ld a,$0a		; $4fdb
	call loadGfxRegisterStateIndex		; $4fdd
	jp _intro_incState		; $4fe0


.else; ROM_SEASONS

;;
; Covers intro sections after the capcom screen and before the temple scene.
; @addr{4e2a}
_introCinematic_ridingHorse:
	ld a,(wIntroVar)
	rst_jumpTable

	.dw _introCinematic_ridingHorse_state0 ; First 3 states in Seasons are unique
	.dw _introCinematic_ridingHorse_state1
	.dw _introCinematic_ridingHorse_state2

	.dw _introCinematic_ridingHorse_state7 ; Last 4 are the same as in Ages
	.dw _introCinematic_ridingHorse_state8
	.dw _introCinematic_ridingHorse_state9
	.dw _introCinematic_ridingHorse_state10

;;
; State 0: initialization
_introCinematic_ridingHorse_state0:
	call disableLcd
	ld hl,wOamEnd
	ld bc,$d000-wOamEnd
	call clearMemoryBc

	ld a,$10
	ldh (<hOamTail),a
	ld a,GFXH_9b
	call loadGfxHeader
.ifdef ROM_AGES
	ld a,PALH_90		; $4e76
.else
	ld a,SEASONS_PALH_90		; $4e76
.endif
	call loadPaletteHeader

	; Use cbb3-cbb4 as a 2-byte counter; wait for 0x37e=894 frames
	ld hl,$cbb3
	ld (hl),$7e
	inc hl
	ld (hl),$03

	ld a,$20
	ld ($cbb8),a
	ld a,$10
	ld (wTmpcbb9),a
	ld a,$22
	ld (wTmpcbb6),a
	ld a,$01
	ld (wTmpcbba),a

	ld a,$08
	call loadGfxRegisterStateIndex

	ld a,MUS_INTRO_1
	call playSound

	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERACID_INTRO_SPRITE
	inc l
	ld (hl),$00
++
	ld a,$14
	call fadeinFromWhiteWithDelay
	ld hl,wLockBG7Color3ToBlack
	ld (hl),$01
	jp _intro_incState

;;
; State 1: screen fading in as Link rides closer
_introCinematic_ridingHorse_state1:
	call _introCinematic_moveBlackBarsIn
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	ret nz

	call clearPaletteFadeVariablesAndRefreshPalettes
.ifdef ROM_AGES
	ld a,PALH_96
.else
	ld a,SEASONS_PALH_96
.endif
	call loadPaletteHeader
	ld a,$0c
	call loadGfxRegisterStateIndex
.ifdef ROM_AGES
	ld a,(wGfxRegs1.LYC)
.else
	ld a,(wGfxRegs2.SCY)
.endif
	ld (wTmpcbbb),a
	ld a,(wGfxRegs2.SCX)
	ld (wTmpcbbc),a
	call _introCinematic_ridingHorse_drawLinkOnHorseCloseupSprites_1
	ld hl,wTmpcbb3
	ld (hl),$58
	inc hl
	ld (hl),$01
	jp _intro_incState

;;
; State 2: Image of Link bobbing up and down on horse
_introCinematic_ridingHorse_state2:
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	jr nz,++

	call disableLcd
.ifdef ROM_AGES
	ld a,PALH_92
.else
	ld a,SEASONS_PALH_92
.endif
	call loadPaletteHeader
	ld a,GFXH_9c
	call loadGfxHeader
	ld a,$0a
	call loadGfxRegisterStateIndex
	call _intro_incState
	jr _introCinematic_ridingHorse_drawLinkOnHorseCloseupSprites_2
++
	call _seasonsFunc_03_5367

	; Fall through

;;
; Draw the sprites that complement the image of Link on the horse (the 1st image)
_introCinematic_ridingHorse_drawLinkOnHorseCloseupSprites_1:
	ld hl,wGfxRegs2.SCY
	ldi a,(hl)
	cpl
	inc a
	ld b,a
	ld a,(hl)
	cpl
	inc a
	ld c,a
	xor a
	ldh (<hOamTail),a
	ld hl,linkOnHorseCloseupSprites_1
	jp addSpritesToOam_withOffset

.endif; ROM_SEASONS

;;
; State 7 (3 in seasons): scrolling up on the link+horse shot
; @addr{4fe3}
_introCinematic_ridingHorse_state7:
	ld hl,wGfxRegs1.SCY		; $4fe3
	dec (hl)		; $4fe6
	jr nz,_introCinematic_ridingHorse_drawLinkOnHorseCloseupSprites_2

	ld a,204 ; Linger on this shot for another 204 frames
	ld (wTmpcbb6),a		; $4feb
	call _intro_incState		; $4fee

;;
; Draw the sprites that complement the image of Link on the horse (the 2nd image in
; seasons; the only such image in ages)
; @addr{4ff1}
_introCinematic_ridingHorse_drawLinkOnHorseCloseupSprites_2:
	; Calculate offset for sprites
	ld a,(wGfxRegs1.SCY)		; $4ff1
	cpl			; $4ff4
	inc a			; $4ff5
	ld b,a			; $4ff6
	xor a			; $4ff7
	ldh (<hOamTail),a	; $4ff8
	ld c,a			; $4ffa

.ifdef ROM_AGES
	ld hl,bank3f.linkOnHorseCloseupSprites_2		; $4ffb
	ld e,:bank3f.linkOnHorseCloseupSprites_2		; $4ffe
	jp addSpritesFromBankToOam_withOffset		; $5000

.else; ROM_SEASONS

	ld hl,linkOnHorseCloseupSprites_2
	jp addSpritesToOam_withOffset
.endif

;;
; State 8 (4 in seasons): lingering on the link+horse shot
; @addr{5003}
_introCinematic_ridingHorse_state8:
	ld hl,wTmpcbb6		; $5003
	dec (hl)		; $5006
	jr nz,_introCinematic_ridingHorse_drawLinkOnHorseCloseupSprites_2	; $5007

.ifdef ROM_AGES
	ld a,PALH_93		; $5009
.else
	ld a,SEASONS_PALH_93		; $5009
.endif
	call loadPaletteHeader		; $500b
	call disableLcd		; $500e
	call clearOam		; $5011
	ld a,$10		; $5014
	ldh (<hOamTail),a	; $5016
	ld a,GFXH_9d		; $5018
	call loadGfxHeader		; $501a

	; Screen should be shifted a pixel every 5 frames next state
	ld a,$05		; $501d
	ld (wTmpcbbb),a		; $501f

	; Wait for $0190=400 frames in the next state
	ld hl,wTmpcbb3		; $5022
	ld (hl),$90		; $5025
	inc hl			; $5027
	ld (hl),$01		; $5028

	; How long to scroll the screen in the next state
	ld a,$b4		; $502a
	ld (wTmpcbb6),a		; $502c

	call clearPaletteFadeVariablesAndRefreshPalettes		; $502f
	ld a,$0b		; $5032
	call loadGfxRegisterStateIndex		; $5034
	call _introCinematic_ridingHorse_drawTempleSprites		; $5037

	; Create 2 interactions of type INTERACID_INTRO_SPRITE with subid's 2 and 1.
	; (These are the horse and cliff sprites.)
	ld b,$02		; $503a
--
	call getFreeInteractionSlot		; $503c
	jr nz,++		; $503f
	ld (hl),INTERACID_INTRO_SPRITE		; $5041
	inc l			; $5043
	ld (hl),b		; $5044
	dec b			; $5045
	jr nz,--		; $5046
++
	jp _intro_incState		; $5048

;;
; State 9 (5 in seasons): showing Link on a cliff overlooking the temple
; @addr{504b}
_introCinematic_ridingHorse_state9:
	ld hl,wTmpcbb3		; $504b
	call decHlRef16WithCap		; $504e
	jr nz,+			; $5051
	call fadeoutToWhite		; $5053
	call _intro_incState		; $5056
	jr _introCinematic_ridingHorse_drawTempleSprites		; $5059
+
	ld hl,wTmpcbb6		; $505b
	ld a,(hl)		; $505e
	or a			; $505f
	jr z,_introCinematic_ridingHorse_drawTempleSprites	; $5060

	; Check if the screen is done moving
	dec (hl)		; $5062
	ld a,(wGfxRegs1.SCX)		; $5063
	or a			; $5066
	jr z,_introCinematic_ridingHorse_drawTempleSprites	; $5067

	; Shift screen once every 5 frames
	ld hl,wTmpcbbb		; $5069
	dec (hl)		; $506c
	jr nz,_introCinematic_ridingHorse_drawTempleSprites	; $506d
	ld (hl),$05		; $506f
	ld hl,wGfxRegs1.SCX		; $5071
	dec (hl)		; $5074

;;
; In the scene overlooking the temple, a few sprites are used to touch up the appearance
; of the temple, even though it's mostly drawn on the background.
; @addr{5075}
_introCinematic_ridingHorse_drawTempleSprites:
	xor a			; $5075
	ldh (<hOamTail),a	; $5076
	ld b,a			; $5078
	ld a,(wGfxRegs1.SCX)		; $5079
	cpl			; $507c
	inc a			; $507d
	ld c,a			; $507e

.ifdef ROM_AGES
	ld hl,bank3f.introTempleSprites		; $507f
	ld e,:bank3f.introTempleSprites		; $5082
	jp addSpritesFromBankToOam_withOffset		; $5084

.else; ROM_SEASONS

	ld hl,introTempleSprites
	jp addSpritesToOam_withOffset
.endif

;;
; State 10 (6 in seasons): fading out, then proceed to next cinematic state (temple)
; @addr{5087}
_introCinematic_ridingHorse_state10:
	ld a,(wPaletteThread_mode)		; $5087
	or a			; $508a
	jr nz,_introCinematic_ridingHorse_drawTempleSprites	; $508b

	call clearDynamicInteractions		; $508d
	jr _incIntroCinematicState		; $5090

;;
; @param[out]	zflag	nz if there's no more scrolling to be done
; @addr{5092}
_introCinematic_preTitlescreen_updateScrollingTree:
	ld hl,wTmpcbb6		; $5092
	dec (hl)		; $5095
	ret nz			; $5096

	ld a,(wTmpcbba)		; $5097
	ld (wTmpcbb6),a		; $509a
	ld hl,wGfxRegs1.SCY		; $509d
	dec (hl)		; $50a0
	ld a,(hl)		; $50a1
	cp $88			; $50a2
	ret z			; $50a4

	cp $10			; $50a5
	jr nz,@label_03_063	; $50a7

	ld a,UNCMP_GFXH_0d		; $50a9
	call loadUncompressedGfxHeader		; $50ab
	ld b,$04		; $50ae
--
	call getFreeInteractionSlot		; $50b0
	jr nz,@ret		; $50b3
	ld (hl),INTERACID_TITLESCREEN_CLOUDS		; $50b5
	inc l			; $50b7
	dec b			; $50b8
	ld (hl),b		; $50b9
	jr nz,--		; $50ba
	jr @ret			; $50bc

@label_03_063:
	cp $b0			; $50be
	jr nz,@ret		; $50c0
	ld a,UNCMP_GFXH_2a		; $50c2
	call loadUncompressedGfxHeader		; $50c4
@ret:
	or $01			; $50c7
	ret			; $50c9

;;
; @addr{50ca}
_incIntroCinematicState:
	ld hl,wIntro.cinematicState		; $50ca
	inc (hl)		; $50cd
	xor a			; $50ce
	ld (wIntroVar),a		; $50cf
	ret			; $50d2

;;
; @addr{50d3}
_introCinematic_inTemple:
	ld a,(wIntroVar)		; $50d3
	rst_jumpTable			; $50d6
	.dw _introCinematic_inTemple_state0
	.dw _introCinematic_inTemple_state1
.ifdef ROM_SEASONS
	.dw _introCinematic_inTemple_state1.5 ; Seasons has a pointless extra state
.endif
	.dw _introCinematic_inTemple_state2
	.dw _introCinematic_inTemple_state3
	.dw _introCinematic_inTemple_state4
	.dw _introCinematic_inTemple_state5
	.dw _introCinematic_inTemple_state6
	.dw _introCinematic_inTemple_state7
	.dw _introCinematic_inTemple_state8
	.dw _introCinematic_inTemple_state9
	.dw _introCinematic_inTemple_state10

;;
; State 0: Load the room
; @addr{50ed}
_introCinematic_inTemple_state0:
	call disableLcd		; $50ed
	call clearOam		; $50f0
	ld a,$10		; $50f3
	ldh (<hOamTail),a	; $50f5

	ld a,GFXH_9e		; $50f7
	call loadGfxHeader		; $50f9
.ifdef ROM_AGES
	ld a,PALH_91		; $50fc
.else
	ld a,SEASONS_PALH_91		; $50fc
.endif
	call loadPaletteHeader		; $50fe

	ld a,$09		; $5101
	call loadGfxRegisterStateIndex		; $5103

	ld a,(wGfxRegs1.SCY)		; $5106
	ldh (<hCameraY),a	; $5109

.ifdef ROM_AGES
	ld a,$10		; $510b
.else
	ld a,$18		; $510b
.endif
	ld (wTilesetAnimation),a		; $510d
	call loadAnimationData		; $5110

	ld a,$01		; $5113
	ld (wScrollMode),a		; $5115

	ld a,SPECIALOBJECTID_LINK_CUTSCENE		; $5118
	call setLinkID		; $511a
	ld l,<w1Link.enabled		; $511d
	ld (hl),$01		; $511f

	ld l,<w1Link.yh		; $5121
	ld a,(wGfxRegs1.SCY)		; $5123
	add $60			; $5126
	ld (hl),a		; $5128
	ld l,<w1Link.xh		; $5129
	ld (hl),$50		; $512b

.ifdef ROM_AGES
	ld hl,interactionBank10.templeIntro_simulatedInput		; $512d
	ld a,:interactionBank10.templeIntro_simulatedInput		; $5130
.else
	ld hl,templeIntro_simulatedInput		; $512d
        ld a,:templeIntro_simulatedInput		; $5130
.endif
	call setSimulatedInputAddress		; $5132

	; Spawn the 3 pieces of triforce
	ld b,$03		; $5135
	ld c,$30		; $5137
@nextTriforce:
	call getFreeInteractionSlot		; $5139
	jr nz,@doneSpawningTriforce	; $513c
	ld (hl),INTERACID_INTRO_SPRITES_1		; $513e
	inc l			; $5140
	ld a,b			; $5141
	dec a			; $5142
	ld (hl),a		; $5143

	ld l,Interaction.yh		; $5144
	ld (hl),$19		; $5146
	ld a,c			; $5148
	ld l,Interaction.xh		; $5149
	ld (hl),a		; $514b
	add $20			; $514c
	ld c,a			; $514e
	ld a,c			; $514f
	dec b			; $5150
	jr nz,@nextTriforce	; $5151

@doneSpawningTriforce:
	ld hl,wMenuDisabled		; $5153
	ld (hl),$01		; $5156
	call fadeinFromWhite		; $5158
	xor a			; $515b
	ld (wTmpcbb9),a		; $515c
	jp _intro_incState		; $515f

;;
; State 1: walking up to triforce
; @addr{5162}
_introCinematic_inTemple_state1:
	ld a,(wPaletteThread_mode)		; $5162
	or a			; $5165
	ret nz			; $5166

.ifdef ROM_SEASONS

	; Seasons has a pointless extra state; the devs removed this in Ages.
	jp _intro_incState

_introCinematic_inTemple_state1.5:

.endif

	; Check if simulated input is done (bit 7 set)
	ld a,(wUseSimulatedInput)		; $5167
	rlca			; $516a
	jp nc,_introCinematic_inTemple_updateCamera		; $516b
	xor a			; $516e
	ld (wUseSimulatedInput),a		; $516f
	call _introCinematic_inTemple_updateCamera		; $5172
	jp _intro_incState		; $5175

;;
; State 2: waiting for cutscene objects to do their thing (nothing to be done here)
; @addr{5178}
_introCinematic_inTemple_state2:
	; The "link cutscene object" will write to wIntro.triforceState eventually
	ld a,(wIntro.triforceState)		; $5178
	cp $03			; $517b
	ret nz			; $517d

	call fadeoutToWhite		; $517e
	jp _intro_incState		; $5181

;;
; State 3: screen fading out temporarily
; @addr{5184}
_introCinematic_inTemple_state3:
	ld a,(wPaletteThread_mode)		; $5184
	or a			; $5187
	ret nz			; $5188

	; Initialize variables needed to make the screen "wavy"
	ld a,$01		; $5189
	ld (wGfxRegs1.LYC),a		; $518b
	inc a			; $518e
	ld (wGfxRegs2.LYC),a		; $518f
	ld a,$00		; $5192
	ldh (<hNextLcdInterruptBehaviour),a	; $5194
	ld a,$20		; $5196
	call initWaveScrollValues		; $5198
	call fadeinFromWhite		; $519b
	call _intro_incState		; $519e

	; Fall through

;;
; @addr{51a1}
_introCinematic_inTemple_updateWave:
	ld hl,wFrameCounter		; $51a1
	inc (hl)		; $51a4
	ld a,$02		; $51a5
	jp loadBigBufferScrollValues		; $51a7

;;
; State 4: screen fading back in
; @addr{51aa}
_introCinematic_inTemple_state4:
	call _introCinematic_inTemple_updateWave		; $51aa
	ld a,(wPaletteThread_mode)		; $51ad
	or a			; $51b0
	ret nz			; $51b1
	ld hl,wTmpcbb6		; $51b2
	ld (hl),120		; $51b5
	jp _intro_incState		; $51b7

;;
; State 5: waving the screen around
; @addr{51ba}
_introCinematic_inTemple_state5:
	call _introCinematic_inTemple_updateWave		; $51ba
	ld hl,wTmpcbb6		; $51bd
	dec (hl)		; $51c0
	ret nz			; $51c1

	; a=0 here
	ld (wTmpcbb6),a		; $51c2
	dec a			; $51c5
	ld (wTmpcbba),a		; $51c6

	call _intro_incState		; $51c9

	; Fall through

;;
; State 6: this is the instant where Link "falls"?
; @addr{51cc}
_introCinematic_inTemple_state6:
	call _introCinematic_inTemple_updateWave		; $51cc
	ld hl,wTmpcbb6		; $51cf
	ld b,$00		; $51d2
	call flashScreen_body		; $51d4
	ret z			; $51d7

	call clearPaletteFadeVariablesAndRefreshPalettes		; $51d8
	ld a,$06		; $51db
	ld (wTmpcbb9),a		; $51dd
	ld a,SND_FAIRYCUTSCENE		; $51e0
	call playSound		; $51e2
	jp _intro_incState		; $51e5

;;
; State 7: link is in the process of falling
; @addr{51e8}
_introCinematic_inTemple_state7:
	call _introCinematic_inTemple_updateWave		; $51e8
	ld a,(wTmpcbb9)		; $51eb
	cp $07			; $51ee
	ret nz			; $51f0

	; Finished falling; delete Link
	call clearLinkObject		; $51f1
	ld b,$08		; $51f4
	call func_2d48		; $51f6
	ld a,b			; $51f9
	ld (wTmpcbb6),a		; $51fa
	jp _intro_incState		; $51fd

;;
; State 8: waiting?
; @addr{5200}
_introCinematic_inTemple_state8:
	call _introCinematic_inTemple_updateWave		; $5200
	ld hl,wTmpcbb6		; $5203
	dec (hl)		; $5206
	ret nz			; $5207
	ld (hl),$3c		; $5208
	jp _intro_incState		; $520a

;;
; State 9: waiting?
; @addr{520d}
_introCinematic_inTemple_state9:
	call _introCinematic_inTemple_updateWave		; $520d
	ld hl,wTmpcbb6		; $5210
	dec (hl)		; $5213
	ret nz			; $5214
	ld a,SND_FADEOUT		; $5215
	call playSound		; $5217
	call fadeoutToWhite		; $521a
	jp _intro_incState		; $521d

;;
; State 10: screen fading out, then moves on to the next cinematic state
; @addr{5220}
_introCinematic_inTemple_state10:
	call _introCinematic_inTemple_updateWave		; $5220
	ld a,(wPaletteThread_mode)		; $5223
	or a			; $5226
	ret nz			; $5227
	call clearDynamicInteractions		; $5228
	jp _incIntroCinematicState		; $522b

;;
; This function causes the screen to flash white. Based on parameter 'b', which acts as
; the "index" if the data to use, this will read through the predefined data to see on
; what frames it should turn the screen white, and on what frames it should restore the
; screen to normal.
;
; @param	b	Index of "screen flashing" data
; @param	hl	Counter to use (should start at 0?)
; @param[out]	zflag	nz if the flashing is complete (all data has been read).
; @addr{522e}
flashScreen_body:
	ld a,b			; $522e
	inc (hl)		; $522f
	ld b,(hl)		; $5230
	ld hl,_screenFlashingData		; $5231
	rst_addDoubleIndex			; $5234
	ldi a,(hl)		; $5235
	ld h,(hl)		; $5236
	ld l,a			; $5237
	ld c,$00		; $5238
--
	ld a,(hl)		; $523a
	bit 7,a			; $523b
	ret nz			; $523d
	cp b			; $523e
	jr nc,+			; $523f

	inc hl			; $5241
	inc c			; $5242
	jr --			; $5243
+
	; Check if the index has changed from last time?
	ld a,c			; $5245
	and $01			; $5246
	ld c,a			; $5248
	ld a,(wTmpcbba)		; $5249
	cp c			; $524c
	ret z			; $524d
	ld a,c			; $524e
	ld (wTmpcbba),a		; $524f

	or a			; $5252
	jr z,clearFadingPalettes_body	; $5253
	call clearPaletteFadeVariablesAndRefreshPalettes		; $5255
	xor a			; $5258
	ret			; $5259

;;
; Clears w2FadingBgPalettes, w2FadingSprPalettes (fills contents with $ff), and marks all
; palettes as needing refresh?
; @addr{525a}
clearFadingPalettes_body:
	ld a,:w2FadingBgPalettes		; $525a
	ld ($ff00+R_SVBK),a	; $525c
	ld b,$80		; $525e
	ld hl,w2FadingBgPalettes		; $5260
	ld a,$ff		; $5263
	call fillMemory		; $5265

	ld a,$ff		; $5268
	ldh (<hSprPaletteSources),a	; $526a
	ldh (<hBgPaletteSources),a	; $526c
	ldh (<hDirtySprPalettes),a	; $526e
	ldh (<hDirtyBgPalettes),a	; $5270
	xor a			; $5272
	ld ($ff00+R_SVBK),a	; $5273
	ret			; $5275

.ifdef ROM_AGES

	_screenFlashingData:
		.dw @data0
		.dw @data1
		.dw @data2
		.dw @data3
		.dw @data4
		.dw @data5

	; Data format:
	;  Even bytes are the frame numbers on which to turn the screen white; odd bytes
	;  are when to restore it to normal? $ff signals end of data.

	; Used by "raftwreck" cutscene before tokay island (INTERACID_RAFTWRECK_CUTSCENE)
	@data1:
		.db $02 $04 $06 $08 $0a $0c $ff

	@data0:
		.db $02 $04 $06 $0c $0e $ff

	; Used by ambi subid $03 (cutscene atop black tower after d7)
	@data2:
		.db $02 $04 $06 $08 $0a $0c $0e $ff

	@data3:
		.db $01 $05 $06 $0a $0b $0f $11 $15
		.db $16 $1a $1c $20 $22 $26 $28 $ff
	@data4:
		.db $03 $05 $07 $0a $0c $10 $12 $17
		.db $19 $ff
	@data5:
		.db $01 $02 $04 $06 $08 $0a $0c $ff

.else; ROM_SEASONS

	_screenFlashingData:
		.dw @data0
		.dw @data1
		.dw @data2
		.dw @data3
		.dw @data4

		.db $03 ; ???

	@data1:
		.db $02 $04 $06 $08 $0c $0e $10 $ff
	@data0:
		.db $02 $04 $06 $0c $0e $ff
	@data2:
		.db $02 $04 $06 $08 $0a $0c $0e $ff
	@data3:
		.db $01 $05 $06 $0a $0b $0f $11 $15
		.db $16 $1a $1c $20 $22 $26 $28 $ff
	@data4:
		.db $01 $02 $04 $06 $08 $0a $0c $ff

.endif


;;
; @addr{52b9}
_introCinematic_preTitlescreen:
	ld a,(wIntroVar)		; $52b9
	rst_jumpTable			; $52bc
	.dw _introCinematic_preTitlescreen_state0
	.dw _introCinematic_preTitlescreen_state1
	.dw _introCinematic_preTitlescreen_state2
	.dw _introCinematic_preTitlescreen_state3

;;
; State 0: load tree graphics
; @addr{52c5}
_introCinematic_preTitlescreen_state0:
	call disableLcd		; $52c5

	ld a,$ff		; $52c8
	ld (wTilesetAnimation),a		; $52ca
	ld a,GFXH_9f		; $52cd
	call loadGfxHeader		; $52cf
.ifdef ROM_AGES
	ld a,PALH_94		; $52d2
.else
	ld a,SEASONS_PALH_94		; $52d2
.endif
	call loadPaletteHeader		; $52d4
	call refreshObjectGfx		; $52d7
	ld a,$0a		; $52da
	call loadGfxRegisterStateIndex		; $52dc

	; Create the "tree branches" object
	call getFreeInteractionSlot		; $52df
	jr nz,++		; $52e2
	ld (hl),INTERACID_INTRO_SPRITES_1		; $52e4
	inc l			; $52e6
	ld (hl),$08		; $52e7
	ld l,Interaction.y		; $52e9
	ld a,$60		; $52eb
	ldi (hl),a		; $52ed
	ldi (hl),a		; $52ee
	ld a,$3d		; $52ef
	inc l			; $52f1
	ldi (hl),a		; $52f2
++

	; Spawn birds
	ld b,$08		; $52f3
--
	call getFreeInteractionSlot		; $52f5
	jr nz,++		; $52f8
	ld (hl),INTERACID_INTRO_BIRD		; $52fa
	inc l			; $52fc
	dec b			; $52fd
	ld (hl),b		; $52fe
	jr nz,--		; $52ff
++
	ld a,$03		; $5301
	ld (wTmpcbba),a		; $5303
	ld (wTmpcbb6),a		; $5306
	call fadeinFromWhite		; $5309
	xor a			; $530c
	ldh (<hCameraY),a	; $530d

	ld a,MUS_INTRO_2		; $530f
	call playSound		; $5311

	jp _intro_incState		; $5314

;;
; State 1: scrolling up the tree
; @addr{5317}
_introCinematic_preTitlescreen_state1:
	call _introCinematic_preTitlescreen_updateScrollingTree		; $5317
	ret nz			; $531a

	; Initialize stuff for state 2.

	call _intro_incState		; $531b
	ld hl,wTmpcbb3		; $531e
	ld (hl),$02		; $5321
	inc hl			; $5323
	xor a			; $5324
	ld (hl),a		; $5325

	; wTmpcbb6 = counter until the sound effect should be played
	ld hl,wTmpcbb6		; $5326
	ld (hl),$10		; $5329

	inc a			; $532b
	ld (wGfxRegs1.LYC),a		; $532c
	inc a			; $532f
	ld (wGfxRegs2.LYC),a		; $5330
	ld a,$01		; $5333
	ldh (<hNextLcdInterruptBehaviour),a	; $5335

	; wBigBuffer will contain separate scrollY values for each line on the screen, in
	; order to produce the effect introducing the title.
	; Initialize it with normal values for scrollY for now.
	ld a,(wGfxRegs1.SCY)		; $5337
	ld b,$90		; $533a
	ld hl,wBigBuffer		; $533c
--
	ldi (hl),a		; $533f
	dec b			; $5340
	jr nz,--		; $5341

	ld a,$01		; $5343

	; Fall through

;;
; Updates the effect where the title comes into view.
;
; @param	a	Number of pixels of the title to show (divided by two)
; @addr{5345}
_introCinematic_preTitlescreen_updateScrollForTitle:
	ld b,a			; $5345

	; Calculate c=$18/b (the amount that the title needs to be shrunk)
	xor a			; $5346
	ld c,a			; $5347
--
	inc c			; $5348
	add b			; $5349
	cp $18			; $534a
	jr z,+			; $534c
	ret nc ; Should never return if given a valid parameter
	jr --			; $534f
+
	; Calculate SCY values for the top half of the title
	push bc			; $5351
	ld a,$38 ; vertical center of title
	sub b			; $5354
	ld h,>wBigBuffer		; $5355
	ld l,a			; $5357
	xor a			; $5358
--
	push af			; $5359
	sub l			; $535a
	add $58 ; SCY value that would be needed to draw the title at top of screen
	ldi (hl),a		; $535d
	pop af			; $535e
	add c			; $535f
	dec b			; $5360
	jr nz,--		; $5361

	; Calculate SCY values for the bottom half of the title
	pop bc			; $5363
	ld a,$37		; $5364
	add b			; $5366
	ld l,a			; $5367
	ld a,$2f		; $5368
--
	push af			; $536a
	sub l			; $536b
	add $58 ; SCY value that would be needed to draw the title at top of screen
	ldd (hl),a		; $536e
	pop af			; $536f
	sub c			; $5370
	dec b			; $5371
	jr nz,--		; $5372
	ret			; $5374

;;
; State 2: game title coming into view
; @addr{5375}
_introCinematic_preTitlescreen_state2:
	; Check whether to play the sound effect
	ld hl,wTmpcbb6		; $5375
	ld a,(hl)		; $5378
	or a			; $5379
	jr z,+			; $537a
	dec a			; $537c
	ld (hl),a		; $537d
	ld a,SND_SWORD_OBTAINED		; $537e
	call z,playSound		; $5380
+
	; Only update every other frame?
	ld a,(wIntro.frameCounter)		; $5383
	and $01			; $5386
	ld hl,wTmpcbb4		; $5388
	ret nz			; $538b

	ld a,(hl)		; $538c
	cp $08			; $538d
	jr nc,@titleDone	; $538f
	inc a			; $5391
	ld (hl),a		; $5392
	ld hl,_introCinematic_preTitlescreen_titleSizeData		; $5393
	rst_addAToHl			; $5396
	ld a,(hl)		; $5397
	jp _introCinematic_preTitlescreen_updateScrollForTitle		; $5398

@titleDone:
	xor a			; $539b
	ld (wTmpcbb6),a		; $539c
	dec a			; $539f
	ld (wTmpcbba),a		; $53a0
	jp _intro_incState		; $53a3

;;
; State 3: title fully in view; wait a bit, then go to the titlescreen.
; @addr{53a6}
_introCinematic_preTitlescreen_state3:
	ld hl,wTmpcbb6		; $53a6
	ld b,$01		; $53a9
	call flashScreen_body		; $53ab
	ret z			; $53ae
	jp _intro_gotoTitlescreen		; $53af

; Each byte is the number of pixels of the title to show on a particular frame, divided by
; two.
_introCinematic_preTitlescreen_titleSizeData:
	.db $01 $02 $03 $04 $06 $08 $0c $18

;;
; Updates camera position based on link's Y position.
; @addr{53ba}
_introCinematic_inTemple_updateCamera:
	ld a,(wGfxRegs1.SCY)		; $53ba
	ld b,a			; $53bd
	ld de,w1Link.yh		; $53be
	ld a,(de)		; $53c1
	sub b			; $53c2
	sub $40			; $53c3
	ld b,a			; $53c5
	ld a,(wGfxRegs1.SCY)		; $53c6
	add b			; $53c9
	cp $70			; $53ca
	ret nc			; $53cc
	ld (wGfxRegs1.SCY),a		; $53cd
	ldh (<hCameraY),a	; $53d0
	ret			; $53d2

;;
; Moves the black bars in the intro cinematic in by 2 pixels, until it covers 24 pixels on
; each end.
; @addr{53d3}
_introCinematic_moveBlackBarsIn:
	ld hl,wGfxRegs1.LYC		; $53d3
	inc (hl)		; $53d6
	inc (hl)		; $53d7
	ld a,(hl)		; $53d8
	cp $17			; $53d9
	jr c,+			; $53db
	ld (hl),$17		; $53dd
+
	ld hl,wGfxRegs2.WINY		; $53df
	dec (hl)		; $53e2
	dec (hl)		; $53e3
	ld a,(hl)		; $53e4
	cp $90-$18			; $53e5
	ret nc			; $53e7
	ld (hl),$90-$18		; $53e8
	ret			; $53ea


.ifdef ROM_AGES

;;
; Moves the black bars out until a certain area in the center of the screen is visible.
; Used for the closeup of Link's face.
; @addr{53eb}
_introCinematic_moveBlackBarsOut:
	ld hl,wGfxRegs1.LYC		; $53eb
	dec (hl)		; $53ee
	dec (hl)		; $53ef
	ld a,(hl)		; $53f0
	cp $2f			; $53f1
	jr nc,+			; $53f3
	ld (hl),$2f		; $53f5
+
	ld hl,wGfxRegs2.WINY		; $53f7
	inc (hl)		; $53fa
	inc (hl)		; $53fb
	ld a,(hl)		; $53fc
	cp $90-$30			; $53fd
	ret c			; $53ff
	ld (hl),$90-$30		; $5400
	ret			; $5402

.else; ROM_SEASONS

;;
; @addr{5367}
_seasonsFunc_03_5367:
	call @func
	ld bc,$0506
	jr nz,+
	ld bc,$0000
+
	ld hl,wTmpcbbb
	ldi a,(hl)
	add b
	ld (wGfxRegs2.SCY),a
	ld a,(hl)
	add c
	ld (wGfxRegs2.SCX),a
	ret

;;
; @param[out]	zflag
@func:
	ld a,($cbb6)
	dec a
	jr nz,++
	ld a,($cbba)
	xor $01
	ld ($cbba),a
	ld a,$05
	jr z,++
	ld a,$22
++
	ld ($cbb6),a
	ld a,($cbba)
	or a
	ret

.endif ; ROM_SEASONS


;;
; @addr{5403}
_cutscene_clearObjects:
	call clearDynamicInteractions		; $5403
	call clearLinkObject		; $5406
	jp refreshObjectGfx		; $5409


.ifdef ROM_AGES

;;
; @param	bc	ID of interaction to create
; @addr{540c}
_createInteraction:
	call getFreeInteractionSlot		; $540c
	ret nz			; $540f
	ld (hl),b		; $5410
	inc l			; $5411
	ld (hl),c		; $5412
	ret			; $5413

.endif


.ifdef ROM_SEASONS

; In Ages these sprites are located elsewhere

; Sprites used on the closeup shot of Link on the horse in the intro
linkOnHorseCloseupSprites_2:
	.db $26
	.db $80 $80 $40 $06
	.db $80 $50 $42 $00
	.db $80 $58 $44 $00
	.db $68 $40 $46 $06
	.db $b8 $3d $20 $02
	.db $b8 $45 $22 $02
	.db $b8 $4d $24 $02
	.db $b8 $55 $26 $02
	.db $b8 $5d $28 $02
	.db $90 $28 $2c $02
	.db $90 $30 $2e $02
	.db $80 $30 $2a $02
	.db $20 $78 $48 $05
	.db $58 $68 $00 $02
	.db $58 $70 $02 $02
	.db $68 $68 $04 $02
	.db $48 $70 $06 $02
	.db $5a $40 $08 $01
	.db $5a $48 $0a $01
	.db $5a $50 $0c $01
	.db $38 $88 $0e $04
	.db $30 $78 $10 $04
	.db $30 $80 $12 $04
	.db $40 $80 $14 $04
	.db $50 $76 $16 $04
	.db $50 $7e $18 $04
	.db $41 $62 $1a $03
	.db $80 $28 $1c $02
	.db $a8 $59 $1e $02
	.db $98 $20 $30 $02
	.db $98 $28 $32 $02
	.db $8c $38 $34 $07
	.db $a8 $41 $36 $02
	.db $a8 $49 $38 $02
	.db $a8 $51 $3a $02
	.db $90 $40 $3e $07
	.db $8a $5c $4a $00
	.db $8a $64 $4c $00

linkOnHorseCloseupSprites_1:
	.db $15
	.db $28 $78 $9c $08
	.db $20 $58 $80 $08
	.db $20 $60 $82 $08
	.db $20 $68 $84 $0a
	.db $20 $70 $d0 $09
	.db $20 $70 $86 $0d
	.db $20 $78 $88 $09
	.db $20 $80 $8a $09
	.db $30 $58 $90 $0c
	.db $30 $80 $9e $09
	.db $4e $60 $94 $0c
	.db $58 $68 $96 $0c
	.db $68 $78 $98 $09
	.db $60 $80 $9a $0a
	.db $20 $88 $8c $09
	.db $20 $90 $8e $09
	.db $40 $72 $92 $0e
	.db $42 $62 $a0 $0e
	.db $70 $30 $b4 $0f
	.db $70 $38 $b6 $0f
	.db $78 $68 $b8 $0c

; Sprites used to touch up the appearance of the temple in the intro (the scene where
; Link's on a cliff with his horse)
introTempleSprites:
	.db $05
	.db $30 $28 $48 $02
	.db $30 $30 $4a $02
	.db $18 $38 $4c $03
	.db $10 $40 $4e $03
	.db $18 $48 $50 $03

templeIntro_simulatedInput:
	dwb   45  $00
	dwb   16  BTN_UP
	dwb   48  $00
	dwb   32  BTN_UP
	dwb   24  $00
	dwb   32  BTN_UP
	dwb   48  $00
	dwb   34  BTN_UP
	dwb  112  $00
	dwb    5  BTN_UP
	dwb   32  $00
	dwb    5  BTN_UP
	dwb   36  $00
	dwb    5  BTN_UP
	dwb   36  $00
	dwb    5  BTN_UP
	dwb   36  $00
	dwb   12  BTN_UP
	.dw $ffff

data_5951:
	.db $3c $b4 $3c $50 $78 $b4 $3c $3c
	.db $3c $70 $78 $78

.endif; ROM_SEASONS

;;
; Called from endgameCutsceneHandler in bank 0.
;
; @param	e
; @addr{5414}
endgameCutsceneHandler_body:
	ld hl,wCutsceneState		; $5414
	bit 0,(hl)		; $5417
	jr nz,+	; $5419
	inc (hl)		; $541b
	ld hl,wTmpcbb3		; $541c
	ld b,$10		; $541f
	call clearMemory		; $5421
+
	ld a,e			; $5424
	rst_jumpTable			; $5425
.ifdef ROM_AGES
	.dw _endgameCutsceneHandler_09
	.dw _endgameCutsceneHandler_0a
	.dw _endgameCutsceneHandler_0f
	.dw _endgameCutsceneHandler_20
.else
	.dw $551f
	.dw $5e7f
	.dw $5bad
.endif

;;
; @addr{542e}
_clearFadingPalettes:
	; Clear w2FadingBgPalettes and w2FadingSprPalettes
	ld a,:w2FadingBgPalettes		; $542e
	ld ($ff00+R_SVBK),a	; $5430
	ld hl,w2FadingBgPalettes		; $5432
	ld b,$80		; $5435
	call clearMemory		; $5437

	xor a			; $543a
	ld ($ff00+R_SVBK),a	; $543b
	dec a			; $543d
	ldh (<hSprPaletteSources),a	; $543e
	ldh (<hDirtySprPalettes),a	; $5440
	ld a,$fd		; $5442
	ldh (<hBgPaletteSources),a	; $5444
	ldh (<hDirtyBgPalettes),a	; $5446
	ret			; $5448
