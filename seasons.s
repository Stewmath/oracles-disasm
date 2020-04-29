; Main file for Oracle of Seasons, US version

.include "include/rominfo.s"
.include "include/emptyfill.s"
.include "include/constants.s"
.include "include/structs.s"
.include "include/wram.s"
.include "include/hram.s"
.include "include/macros.s"
.include "include/script_commands.s"
.include "include/simplescript_commands.s"
.include "include/movementscript_commands.s"

.include "objects/macros.s"
.include "include/gfxDataMacros.s"
.include "include/musicMacros.s"

.include "build/textDefines.s"


.BANK $00 SLOT 0
.ORG 0

	.include "code/bank0.s"

.BANK $01 SLOT 1
.ORG 0

	.include "code/bank1.s"


.BANK $02 SLOT 1
.ORG 0

	.include "code/bank2.s"


.BANK $03 SLOT 1
.ORG 0

.include "code/bank3.s"
.include "code/seasons/cutscenes/endgameCutscenes.s"
.include "code/seasons/cutscenes/pirateShipDeparting.s"
.include "code/seasons/cutscenes/volcanoErupting.s"
.include "code/seasons/cutscenes/linkedGameCutscenes.s"
.include "code/seasons/cutscenes/introCutscenes.s"

.BANK $04 SLOT 1
.ORG 0

.include "code/bank4.s"


; These 2 includes must be in the same bank
.include "build/data/roomPacks.s"
.include "build/data/musicAssignments.s"


; Format:
; First byte indicates whether it's a dungeon or not (and consequently what compression it uses)
; 3 byte pointer to a table containing relative offsets for room data for each sector on the map
; 3 byte pointer to the base offset of the actual layout data
roomLayoutGroupTable: ; $4c4c
	.db $01
	3BytePointer roomLayoutGroup0Table
	3BytePointer room0000
	.db $00

	.db $01
	3BytePointer roomLayoutGroup1Table
	3BytePointer room0100
	.db $00

	.db $01
	3BytePointer roomLayoutGroup2Table
	3BytePointer room0200
	.db $00

	.db $01
	3BytePointer roomLayoutGroup3Table
	3BytePointer room0300
	.db $00

	.db $01
	3BytePointer roomLayoutGroup4Table
	3BytePointer room0400
	.db $00

	.db $00
	3BytePointer roomLayoutGroup5Table
	3BytePointer room0500
	.db $00

	.db $00
	3BytePointer roomLayoutGroup6Table
	3BytePointer room0600
	.db $00

.include "build/data/tilesets.s"
.include "build/data/tilesetAssignments.s"

initializeAnimations:
	ld a,($cd25)		; $574c
	cp $ff			; $574f
	ret z			; $5751
	call loadAnimationData		; $5752
	call $579a		; $5755
_label_04_183:
	call $5773		; $5758
	jr nz,_label_04_183	; $575b
	ret			; $575d
updateAnimations:
	ld hl,$cd30		; $575e
	res 6,(hl)		; $5761
	ld a,($cd25)		; $5763
	inc a			; $5766
	ret z			; $5767
	ld a,($cd00)		; $5768
	and $01			; $576b
	ret z			; $576d
	call $5773		; $576e
	jr _label_04_184		; $5771
	ld a,($ccfa)		; $5773
	ld b,a			; $5776
	ld a,($ccfb)		; $5777
	cp b			; $577a
	ret z			; $577b
	inc b			; $577c
	ld a,b			; $577d
	and $1f			; $577e
	ld ($ccfa),a		; $5780
	ld hl,$db90		; $5783
	rst_addAToHl			; $5786
	ld a,$02		; $5787
	ld ($ff00+$70),a	; $5789
	ld b,(hl)		; $578b
	xor a			; $578c
	ld ($ff00+$70),a	; $578d
	ld a,b			; $578f
	call $580f		; $5790
	ld hl,$cd30		; $5793
	set 6,(hl)		; $5796
	or h			; $5798
	ret			; $5799
_label_04_184:
	ld hl,$cd31		; $579a
	ld a,($cd30)		; $579d
	bit 0,a			; $57a0
	call nz,$57cf		; $57a2
	ld hl,$cd34		; $57a5
	ld a,($cd30)		; $57a8
	bit 1,a			; $57ab
	call nz,$57cf		; $57ad
	ld hl,$cd37		; $57b0
	ld a,($cd30)		; $57b3
	bit 2,a			; $57b6
	call nz,$57cf		; $57b8
	ld hl,$cd3a		; $57bb
	ld a,($cd30)		; $57be
	bit 3,a			; $57c1
	call nz,$57cf		; $57c3
	ld a,($cd30)		; $57c6
	and $7f			; $57c9
	ld ($cd30),a		; $57cb
	ret			; $57ce
	ld a,($cd30)		; $57cf
	bit 7,a			; $57d2
	jr nz,_label_04_185	; $57d4
	dec (hl)		; $57d6
	ret nz			; $57d7
_label_04_185:
	push hl			; $57d8
	inc hl			; $57d9
	ldi a,(hl)		; $57da
	ld h,(hl)		; $57db
	ld l,a			; $57dc
	ld e,(hl)		; $57dd
	inc hl			; $57de
	ldi a,(hl)		; $57df
	cp $ff			; $57e0
	jr nz,_label_04_186	; $57e2
	ld b,a			; $57e4
	ld c,(hl)		; $57e5
	add hl,bc		; $57e6
	ldi a,(hl)		; $57e7
_label_04_186:
	ld c,l			; $57e8
	ld b,h			; $57e9
	pop hl			; $57ea
	ldi (hl),a		; $57eb
	ld (hl),c		; $57ec
	inc hl			; $57ed
	ld (hl),b		; $57ee
	ld b,e			; $57ef
	ld a,($ccfb)		; $57f0
	inc a			; $57f3
	and $1f			; $57f4
	ld e,a			; $57f6
	ld a,($ccfa)		; $57f7
	cp e			; $57fa
	ret z			; $57fb
	ld a,e			; $57fc
	ld ($ccfb),a		; $57fd
	ld a,$02		; $5800
	ld ($ff00+$70),a	; $5802
	ld a,e			; $5804
	ld hl,$db90		; $5805
	rst_addAToHl			; $5808
	ld (hl),b		; $5809
	xor a			; $580a
	ld ($ff00+$70),a	; $580b
	or h			; $580d
	ret			; $580e
	ld c,$06		; $580f
	call multiplyAByC		; $5811
	ld bc,$5a48		; $5814
	add hl,bc		; $5817
	ldi a,(hl)		; $5818
	ld c,a			; $5819
	ldi a,(hl)		; $581a
	ld d,a			; $581b
	ldi a,(hl)		; $581c
	ld e,a			; $581d
	push de			; $581e
	ldi a,(hl)		; $581f
	ld d,a			; $5820
	ldi a,(hl)		; $5821
	ld e,a			; $5822
	ld b,(hl)		; $5823
	pop hl			; $5824
	jp queueDmaTransfer		; $5825


	.include "data/seasons/uniqueGfxHeaders.s"
	.include "data/seasons/uniqueGfxHeaderPointers.s"

animationGroupTable:
	and $59			; $59b0
.DB $eb				; $59b2
	ld e,c			; $59b3
	ld a,($ff00+$59)	; $59b4
	push af			; $59b6
	ld e,c			; $59b7
_label_04_188:
	ld hl,sp+$59		; $59b8
_label_04_189:
	rst $38			; $59ba
	ld e,c			; $59bb
	inc b			; $59bc
	ld e,d			; $59bd
	and $59			; $59be
	ld c,$5a		; $59c0
	inc de			; $59c2
	ld e,d			; $59c3
	ld d,$5a		; $59c4
	dec e			; $59c6
	ld e,d			; $59c7
	jr nz,_label_04_190	; $59c8
	inc hl			; $59ca
	ld e,d			; $59cb
	ld h,$5a		; $59cc
	and $59			; $59ce
	add hl,hl		; $59d0
	ld e,d			; $59d1
	ld l,$5a		; $59d2
	and $59			; $59d4
	and $59			; $59d6
	and $59			; $59d8
	and $59			; $59da
	and $59			; $59dc
	and $59			; $59de
	inc sp			; $59e0
	ld e,d			; $59e1
	inc a			; $59e2
	ld e,d			; $59e3
	ld b,l			; $59e4
	ld e,d			; $59e5
	add e			; $59e6
	sub h			; $59e7
	ld e,h			; $59e8
	sbc (hl)		; $59e9
	ld e,h			; $59ea
	add e			; $59eb
	sub h			; $59ec
	ld e,h			; $59ed
.DB $e4				; $59ee
	ld e,h			; $59ef
	add e			; $59f0
	sub h			; $59f1
	ld e,h			; $59f2
	xor b			; $59f3
	ld e,h			; $59f4
	add c			; $59f5
	sub h			; $59f6
	ld e,h			; $59f7
	add a			; $59f8
	sub h			; $59f9
	ld e,h			; $59fa
	add $5c			; $59fb
	jp c,$835c		; $59fd
	sub h			; $5a00
	ld e,h			; $5a01
	jp c,$875c		; $5a02
	sub h			; $5a05
	ld e,h			; $5a06
	ret nc			; $5a07
	ld e,h			; $5a08
	cp h			; $5a09
	ld e,h			; $5a0a
	add c			; $5a0b
	sub h			; $5a0c
	ld e,h			; $5a0d
	add e			; $5a0e
	ld hl,sp+$5c		; $5a0f
	ld (bc),a		; $5a11
	ld e,l			; $5a12
	add c			; $5a13
	inc c			; $5a14
	ld e,l			; $5a15
	add a			; $5a16
	sub h			; $5a17
	ld e,h			; $5a18
	xor b			; $5a19
	ld e,h			; $5a1a
	xor $5c			; $5a1b
	add c			; $5a1d
	ld d,$5d		; $5a1e
	add c			; $5a20
	ld a,(de)		; $5a21
	ld e,l			; $5a22
	add c			; $5a23
_label_04_190:
	ld e,$5d		; $5a24
	add c			; $5a26
	inc h			; $5a27
	ld e,l			; $5a28
	add e			; $5a29
	ld l,$5d		; $5a2a
	jr c,_label_04_191	; $5a2c
	add e			; $5a2e
	ld l,$5d		; $5a2f
	ld c,d			; $5a31
	ld e,l			; $5a32
	adc a			; $5a33
	ld e,(hl)		; $5a34
	ld e,l			; $5a35
	ld l,b			; $5a36
	ld e,l			; $5a37
	ld (hl),d		; $5a38
	ld e,l			; $5a39
	add b			; $5a3a
	ld e,l			; $5a3b
	adc a			; $5a3c
	ld e,(hl)		; $5a3d
	ld e,l			; $5a3e
	ld l,b			; $5a3f
	ld e,l			; $5a40
	ld (hl),d		; $5a41
	ld e,l			; $5a42
	adc d			; $5a43
	ld e,l			; $5a44
	add c			; $5a45
	ld d,h			; $5a46
	ld e,l			; $5a47
	jr $65			; $5a48
	ld b,b			; $5a4a
	adc b			; $5a4b
	add c			; $5a4c
	inc bc			; $5a4d
	jr $65			; $5a4e
	add b			; $5a50
	adc b			; $5a51
	add c			; $5a52
	inc bc			; $5a53
	jr $65			; $5a54
	ret nz			; $5a56
	adc b			; $5a57
	add c			; $5a58
	inc bc			; $5a59
	jr _label_04_192		; $5a5a
	nop			; $5a5c
	adc b			; $5a5d
	add c			; $5a5e
	inc bc			; $5a5f
	jr _label_04_193		; $5a60
	ld h,b			; $5a62
	adc b			; $5a63
	pop bc			; $5a64
	ld bc,$6718		; $5a65
	and b			; $5a68
	adc b			; $5a69
	pop bc			; $5a6a
	ld bc,$6718		; $5a6b
	ld ($ff00+$88),a	; $5a6e
	pop bc			; $5a70
	ld bc,$6818		; $5a71
	jr nz,-$78		; $5a74
	pop bc			; $5a76
	ld bc,$6718		; $5a77
	ld b,b			; $5a7a
	sub (hl)		; $5a7b
	ld bc,$1803		; $5a7c
	ld h,a			; $5a7f
	add b			; $5a80
	sub (hl)		; $5a81
	ld bc,$1803		; $5a82
	ld h,a			; $5a85
	ret nz			; $5a86
	sub (hl)		; $5a87
	ld bc,$1803		; $5a88
_label_04_191:
	ld l,b			; $5a8b
	nop			; $5a8c
	sub (hl)		; $5a8d
	ld bc,$1803		; $5a8e
	ld h,a			; $5a91
	ld b,b			; $5a92
	adc b			; $5a93
	pop bc			; $5a94
	inc bc			; $5a95
	jr _label_04_194		; $5a96
	add b			; $5a98
	adc b			; $5a99
	pop bc			; $5a9a
	inc bc			; $5a9b
	jr _label_04_195		; $5a9c
	ret nz			; $5a9e
	adc b			; $5a9f
	pop bc			; $5aa0
	inc bc			; $5aa1
	jr _label_04_196		; $5aa2
	nop			; $5aa4
	adc b			; $5aa5
	pop bc			; $5aa6
	inc bc			; $5aa7
	jr _label_04_197		; $5aa8
	ld b,b			; $5aaa
	adc b			; $5aab
	pop bc			; $5aac
	inc bc			; $5aad
	jr _label_04_198		; $5aae
	add b			; $5ab0
	adc b			; $5ab1
	pop bc			; $5ab2
	inc bc			; $5ab3
	jr _label_04_199		; $5ab4
	ret nz			; $5ab6
	adc b			; $5ab7
	pop bc			; $5ab8
	inc bc			; $5ab9
	jr _label_04_200		; $5aba
	nop			; $5abc
	adc b			; $5abd
	pop bc			; $5abe
	inc bc			; $5abf
	jr _label_04_201		; $5ac0
_label_04_192:
	ld b,b			; $5ac2
	sub (hl)		; $5ac3
	add c			; $5ac4
	ld bc,$6918		; $5ac5
	ld h,b			; $5ac8
_label_04_193:
	sub (hl)		; $5ac9
	add c			; $5aca
	ld bc,$6918		; $5acb
	add b			; $5ace
	sub (hl)		; $5acf
	add c			; $5ad0
	ld bc,$6918		; $5ad1
	and b			; $5ad4
	sub (hl)		; $5ad5
	add c			; $5ad6
	ld bc,$6918		; $5ad7
	ld b,b			; $5ada
	sub (hl)		; $5adb
	ld sp,$1801		; $5adc
	ld l,c			; $5adf
	ld h,b			; $5ae0
	sub (hl)		; $5ae1
	ld sp,$1801		; $5ae2
	ld l,c			; $5ae5
	add b			; $5ae6
	sub (hl)		; $5ae7
	ld sp,$1801		; $5ae8
	ld l,c			; $5aeb
	and b			; $5aec
	sub (hl)		; $5aed
	ld sp,$1801		; $5aee
	ld l,b			; $5af1
	ld b,b			; $5af2
	adc b			; $5af3
	pop bc			; $5af4
	inc bc			; $5af5
	jr _label_04_204		; $5af6
	add b			; $5af8
	adc b			; $5af9
	pop bc			; $5afa
	inc bc			; $5afb
	jr _label_04_205		; $5afc
	ret nz			; $5afe
_label_04_194:
	adc b			; $5aff
	pop bc			; $5b00
	inc bc			; $5b01
	jr _label_04_206		; $5b02
	nop			; $5b04
_label_04_195:
	adc b			; $5b05
	pop bc			; $5b06
	inc bc			; $5b07
	jr _label_04_207		; $5b08
	nop			; $5b0a
	adc b			; $5b0b
_label_04_196:
	pop bc			; $5b0c
	inc bc			; $5b0d
	jr _label_04_208		; $5b0e
_label_04_197:
	ld b,b			; $5b10
	adc b			; $5b11
	pop bc			; $5b12
	inc bc			; $5b13
	jr _label_04_209		; $5b14
_label_04_198:
	add b			; $5b16
	adc b			; $5b17
	pop bc			; $5b18
	inc bc			; $5b19
	jr _label_04_210		; $5b1a
_label_04_199:
	ret nz			; $5b1c
	adc b			; $5b1d
	pop bc			; $5b1e
	inc bc			; $5b1f
	jr _label_04_211		; $5b20
	nop			; $5b22
_label_04_200:
	sub e			; $5b23
	add c			; $5b24
	inc bc			; $5b25
	jr _label_04_212		; $5b26
	ld b,b			; $5b28
	sub e			; $5b29
	add c			; $5b2a
_label_04_201:
	inc bc			; $5b2b
_label_04_202:
	jr _label_04_213		; $5b2c
	add b			; $5b2e
	sub e			; $5b2f
	add c			; $5b30
	inc bc			; $5b31
_label_04_203:
	jr _label_04_214		; $5b32
	ret nz			; $5b34
	sub e			; $5b35
	add c			; $5b36
	inc bc			; $5b37
	jr _label_04_215		; $5b38
	ld ($ff00+$88),a	; $5b3a
	and c			; $5b3c
	inc b			; $5b3d
	jr $6a			; $5b3e
	ld (hl),b		; $5b40
	adc b			; $5b41
	and c			; $5b42
	inc b			; $5b43
	jr _label_04_216		; $5b44
	nop			; $5b46
	adc b			; $5b47
	and c			; $5b48
	inc b			; $5b49
	jr _label_04_217		; $5b4a
	sub b			; $5b4c
	adc b			; $5b4d
	and c			; $5b4e
	inc b			; $5b4f
	jr _label_04_218		; $5b50
	ret nz			; $5b52
	adc b			; $5b53
	add c			; $5b54
	ld bc,$6a18		; $5b55
	ld d,b			; $5b58
	adc b			; $5b59
	add c			; $5b5a
	ld bc,$6a18		; $5b5b
	ld ($ff00+$88),a	; $5b5e
_label_04_204:
	add c			; $5b60
	ld bc,$6b18		; $5b61
	ld (hl),b		; $5b64
	adc b			; $5b65
_label_04_205:
	add c			; $5b66
	ld bc,$6918		; $5b67
	ret nz			; $5b6a
	adc b			; $5b6b
	add c			; $5b6c
_label_04_206:
	inc bc			; $5b6d
	jr $6a			; $5b6e
	ld d,b			; $5b70
	adc b			; $5b71
	add c			; $5b72
	inc bc			; $5b73
	jr $6a			; $5b74
_label_04_207:
	ld ($ff00+$88),a	; $5b76
	add c			; $5b78
	inc bc			; $5b79
	jr _label_04_220		; $5b7a
_label_04_208:
	ld (hl),b		; $5b7c
	adc b			; $5b7d
	add c			; $5b7e
	inc bc			; $5b7f
	jr $64			; $5b80
_label_04_209:
	ld b,b			; $5b82
	adc b			; $5b83
	add c			; $5b84
	rlca			; $5b85
	jr $64			; $5b86
_label_04_210:
	ret nz			; $5b88
	adc b			; $5b89
	add c			; $5b8a
	rlca			; $5b8b
	jr $64			; $5b8c
_label_04_211:
	nop			; $5b8e
	sub b			; $5b8f
	sub c			; $5b90
	nop			; $5b91
	jr $64			; $5b92
_label_04_212:
	stop			; $5b94
	sub b			; $5b95
	sub c			; $5b96
	nop			; $5b97
	jr $64			; $5b98
_label_04_213:
	jr nz,_label_04_202	; $5b9a
	sub c			; $5b9c
	nop			; $5b9d
	jr $64			; $5b9e
_label_04_214:
	jr nc,_label_04_203	; $5ba0
	sub c			; $5ba2
_label_04_215:
	nop			; $5ba3
	jr _label_04_221		; $5ba4
	add b			; $5ba6
	adc l			; $5ba7
	add c			; $5ba8
	ld b,$18		; $5ba9
	ld (hl),d		; $5bab
	add b			; $5bac
	adc l			; $5bad
	add c			; $5bae
	ld b,$18		; $5baf
_label_04_216:
	ld (hl),e		; $5bb1
	add b			; $5bb2
	adc l			; $5bb3
	add c			; $5bb4
	ld b,$18		; $5bb5
_label_04_217:
	ld (hl),h		; $5bb7
	add b			; $5bb8
	adc l			; $5bb9
	add c			; $5bba
_label_04_218:
	ld b,$18		; $5bbb
	ld (hl),c		; $5bbd
	ldh a,(<hFF8D)	; $5bbe
	pop af			; $5bc0
	nop			; $5bc1
	jr _label_04_222		; $5bc2
	ldh a,(<hFF8D)	; $5bc4
	pop af			; $5bc6
_label_04_219:
	nop			; $5bc7
	jr $73			; $5bc8
	ldh a,(<hFF8D)	; $5bca
	pop af			; $5bcc
	nop			; $5bcd
	jr _label_04_223		; $5bce
	ldh a,(<hFF8D)	; $5bd0
	pop af			; $5bd2
	nop			; $5bd3
	jr _label_04_224		; $5bd4
	nop			; $5bd6
	adc a			; $5bd7
	ld bc,$1800		; $5bd8
	ld (hl),e		; $5bdb
	nop			; $5bdc
	adc a			; $5bdd
	ld bc,$1800		; $5bde
	ld (hl),h		; $5be1
	nop			; $5be2
	adc a			; $5be3
	ld bc,$1800		; $5be4
_label_04_220:
	ld (hl),l		; $5be7
	nop			; $5be8
	adc a			; $5be9
	ld bc,$1800		; $5bea
	ld (hl),d		; $5bed
	nop			; $5bee
	adc a			; $5bef
	ld bc,$1804		; $5bf0
	ld (hl),e		; $5bf3
	nop			; $5bf4
	adc a			; $5bf5
	ld bc,$1804		; $5bf6
	ld (hl),h		; $5bf9
	nop			; $5bfa
	adc a			; $5bfb
	ld bc,$1804		; $5bfc
	ld (hl),l		; $5bff
	nop			; $5c00
	adc a			; $5c01
	ld bc,$1804		; $5c02
	ld l,l			; $5c05
	nop			; $5c06
	adc c			; $5c07
	ld bc,$180a		; $5c08
	ld l,l			; $5c0b
	or b			; $5c0c
	adc c			; $5c0d
	ld bc,$180a		; $5c0e
	ld l,(hl)		; $5c11
	ld h,b			; $5c12
	adc c			; $5c13
	ld bc,$180a		; $5c14
_label_04_221:
	ld l,a			; $5c17
	stop			; $5c18
	adc c			; $5c19
	ld bc,$180a		; $5c1a
	ld l,a			; $5c1d
	ret nz			; $5c1e
	adc c			; $5c1f
	or c			; $5c20
	nop			; $5c21
	jr $6f			; $5c22
	ret nc			; $5c24
	adc c			; $5c25
	or c			; $5c26
	nop			; $5c27
	jr $6f			; $5c28
	ld ($ff00+$89),a	; $5c2a
	or c			; $5c2c
	nop			; $5c2d
	jr _label_04_225		; $5c2e
	ld a,($ff00+$89)	; $5c30
	or c			; $5c32
	nop			; $5c33
	jr _label_04_226		; $5c34
_label_04_222:
	nop			; $5c36
	adc c			; $5c37
	pop bc			; $5c38
	ld bc,$7018		; $5c39
	jr nz,_label_04_219	; $5c3c
	pop bc			; $5c3e
	ld bc,$7018		; $5c3f
	ld b,b			; $5c42
	adc c			; $5c43
_label_04_223:
	pop bc			; $5c44
	ld bc,$7018		; $5c45
_label_04_224:
	ld h,b			; $5c48
	adc c			; $5c49
	pop bc			; $5c4a
	ld bc,$7018		; $5c4b
	add b			; $5c4e
	adc c			; $5c4f
	pop hl			; $5c50
	ld bc,$7018		; $5c51
	and b			; $5c54
	adc c			; $5c55
	pop hl			; $5c56
	ld bc,$7018		; $5c57
	ret nz			; $5c5a
	adc c			; $5c5b
	pop hl			; $5c5c
	ld bc,$7018		; $5c5d
	ld ($ff00+$89),a	; $5c60
	pop hl			; $5c62
	ld bc,$7118		; $5c63
	nop			; $5c66
	adc c			; $5c67
	pop hl			; $5c68
	ld bc,$7118		; $5c69
	jr nz,-$77		; $5c6c
	pop hl			; $5c6e
	ld bc,$7118		; $5c6f
	ld b,b			; $5c72
	adc c			; $5c73
	pop hl			; $5c74
	ld bc,$7118		; $5c75
	ld h,b			; $5c78
	adc c			; $5c79
	pop hl			; $5c7a
	ld bc,$7518		; $5c7b
	add b			; $5c7e
	adc l			; $5c7f
	ld bc,$180d		; $5c80
	halt			; $5c83
	add b			; $5c84
	adc l			; $5c85
	ld bc,$180d		; $5c86
	ld (hl),a		; $5c89
	add b			; $5c8a
	adc l			; $5c8b
	ld bc,$180d		; $5c8c
	ld a,b			; $5c8f
	add b			; $5c90
	adc l			; $5c91
	ld bc,$0f0d		; $5c92
	nop			; $5c95
	rrca			; $5c96
	ld bc,$020f		; $5c97
	rrca			; $5c9a
	inc bc			; $5c9b
	rst $38			; $5c9c
	rst $30			; $5c9d
	rrca			; $5c9e
_label_04_225:
	inc b			; $5c9f
	rrca			; $5ca0
	dec b			; $5ca1
	rrca			; $5ca2
	ld b,$0f		; $5ca3
	rlca			; $5ca5
_label_04_226:
	rst $38			; $5ca6
	rst $30			; $5ca7
	ld ($0810),sp		; $5ca8
	ld de,$1208		; $5cab
	ld ($ff13),sp		; $5cae
	rst $30			; $5cb1
	rrca			; $5cb2
	inc d			; $5cb3
	rrca			; $5cb4
	dec d			; $5cb5
	rrca			; $5cb6
	ld d,$0f		; $5cb7
	rla			; $5cb9
	rst $38			; $5cba
	rst $30			; $5cbb
	rrca			; $5cbc
	jr _label_04_227		; $5cbd
	add hl,de		; $5cbf
	rrca			; $5cc0
	ld a,(de)		; $5cc1
	rrca			; $5cc2
	dec de			; $5cc3
	rst $38			; $5cc4
	rst $30			; $5cc5
	rrca			; $5cc6
	.db $08 $0f $09 ; $5cc7
	rrca			; $5cca
	ld a,(bc)		; $5ccb
	rrca			; $5ccc
	dec bc			; $5ccd
_label_04_227:
	rst $38			; $5cce
	rst $30			; $5ccf
	rrca			; $5cd0
	inc c			; $5cd1
	rrca			; $5cd2
	dec c			; $5cd3
	rrca			; $5cd4
	ld c,$0f		; $5cd5
	rrca			; $5cd7
	rst $38			; $5cd8
	rst $30			; $5cd9
	inc b			; $5cda
	inc e			; $5cdb
	inc b			; $5cdc
	dec e			; $5cdd
	inc b			; $5cde
	ld e,$04		; $5cdf
	rra			; $5ce1
	rst $38			; $5ce2
	rst $30			; $5ce3
	ld b,$20		; $5ce4
	ld b,$21		; $5ce6
	ld b,$22		; $5ce8
	ld b,$23		; $5cea
	rst $38			; $5cec
	rst $30			; $5ced
	ld b,$24		; $5cee
	ld b,$25		; $5cf0
	ld b,$26		; $5cf2
	ld b,$27		; $5cf4
	rst $38			; $5cf6
	rst $30			; $5cf7
	rrca			; $5cf8
	jr z,_label_04_228	; $5cf9
	add hl,hl		; $5cfb
	rrca			; $5cfc
	ldi a,(hl)		; $5cfd
	rrca			; $5cfe
	dec hl			; $5cff
	rst $38			; $5d00
	rst $30			; $5d01
	ld ($082c),sp		; $5d02
	dec l			; $5d05
	ld ($082e),sp		; $5d06
	cpl			; $5d09
_label_04_228:
	rst $38			; $5d0a
	rst $30			; $5d0b
	rrca			; $5d0c
	jr nc,_label_04_229	; $5d0d
	ld sp,$320f		; $5d0f
	rrca			; $5d12
	inc sp			; $5d13
	rst $38			; $5d14
	rst $30			; $5d15
	rrca			; $5d16
	inc (hl)		; $5d17
	rst $38			; $5d18
.DB $fd				; $5d19
	rrca			; $5d1a
	dec (hl)		; $5d1b
	rst $38			; $5d1c
.DB $fd				; $5d1d
_label_04_229:
	rrca			; $5d1e
	inc (hl)		; $5d1f
	rrca			; $5d20
	dec (hl)		; $5d21
	rst $38			; $5d22
	ei			; $5d23
	ld (bc),a		; $5d24
	ld (hl),$02		; $5d25
	scf			; $5d27
	ld (bc),a		; $5d28
	jr c,_label_04_230	; $5d29
	add hl,sp		; $5d2b
	rst $38			; $5d2c
_label_04_230:
	rst $30			; $5d2d
	rrca			; $5d2e
	ldd a,(hl)		; $5d2f
	rrca			; $5d30
	dec sp			; $5d31
	rrca			; $5d32
	inc a			; $5d33
	rrca			; $5d34
	dec a			; $5d35
	rst $38			; $5d36
	rst $30			; $5d37
	inc b			; $5d38
	ld a,$04		; $5d39
	ld b,d			; $5d3b
	inc b			; $5d3c
	ccf			; $5d3d
	inc b			; $5d3e
	ld b,e			; $5d3f
	inc b			; $5d40
	ld b,b			; $5d41
	inc b			; $5d42
	ld b,h			; $5d43
	inc b			; $5d44
	ld b,c			; $5d45
	inc b			; $5d46
	ld b,l			; $5d47
	rst $38			; $5d48
	rst $28			; $5d49
	rrca			; $5d4a
	ld b,(hl)		; $5d4b
	rrca			; $5d4c
	ld b,a			; $5d4d
	rrca			; $5d4e
	ld c,b			; $5d4f
	rrca			; $5d50
	ld c,c			; $5d51
	rst $38			; $5d52
	rst $30			; $5d53
	ld e,$5e		; $5d54
	ld e,$5f		; $5d56
	ld e,$60		; $5d58
	ld e,$61		; $5d5a
	rst $38			; $5d5c
	rst $30			; $5d5d
	rrca			; $5d5e
	ld c,d			; $5d5f
	rrca			; $5d60
	ld c,e			; $5d61
	rrca			; $5d62
	ld c,h			; $5d63
	rrca			; $5d64
	ld c,l			; $5d65
	rst $38			; $5d66
	rst $30			; $5d67
	ld ($084e),sp		; $5d68
	ld c,a			; $5d6b
	ld ($0850),sp		; $5d6c
	ld d,c			; $5d6f
	rst $38			; $5d70
	rst $30			; $5d71
	rrca			; $5d72
	ld d,d			; $5d73
	rrca			; $5d74
	ld d,e			; $5d75
	rrca			; $5d76
	ld d,h			; $5d77
	rrca			; $5d78
	ld d,l			; $5d79
	rrca			; $5d7a
	ld d,h			; $5d7b
	rrca			; $5d7c
	ld d,e			; $5d7d
	rst $38			; $5d7e
	di			; $5d7f
	rrca			; $5d80
	ld d,(hl)		; $5d81
	rrca			; $5d82
	ld d,a			; $5d83
	rrca			; $5d84
	ld e,b			; $5d85
	rrca			; $5d86
	ld e,c			; $5d87
	rst $38			; $5d88
	rst $30			; $5d89
	rrca			; $5d8a
	ld e,d			; $5d8b
	rrca			; $5d8c
	ld e,e			; $5d8d
	rrca			; $5d8e
	ld e,h			; $5d8f
	rrca			; $5d90
	ld e,l			; $5d91
	rst $38			; $5d92
	rst $30			; $5d93
applyAllTileSubstitutions:
	call $5fda		; $5d94
	call $5de8		; $5d97
	call $5f53		; $5d9a
	ld a,($cc49)		; $5d9d
	cp $02			; $5da0
	jr z,_label_04_232	; $5da2
	cp $04			; $5da4
	jr nc,_label_04_231	; $5da6
	call $5dbc		; $5da8
	jp $60ab		; $5dab
_label_04_231:
	call $5ebd		; $5dae
	call $5f62		; $5db1
	jp $60ab		; $5db4
_label_04_232:
	ld e,$03		; $5db7
	jp loadObjectGfxHeaderToSlot4		; $5db9
	ld a,($c63a)		; $5dbc
	cp $01			; $5dbf
	ret nz			; $5dc1
	ld e,$06		; $5dc2
	jp loadObjectGfxHeaderToSlot4		; $5dc4
_label_04_233:
	ld a,(de)		; $5dc7
	or a			; $5dc8
	ret z			; $5dc9
	ld b,a			; $5dca
	inc de			; $5dcb
	ld a,(de)		; $5dcc
	inc de			; $5dcd
	call findTileInRoom		; $5dce
	jr nz,_label_04_233	; $5dd1
	ld (hl),b		; $5dd3
	ld c,a			; $5dd4
	ld a,l			; $5dd5
	or a			; $5dd6
	jr z,_label_04_233	; $5dd7
_label_04_234:
	dec l			; $5dd9
	ld a,c			; $5dda
	call backwardsSearch		; $5ddb
	jr nz,_label_04_233	; $5dde
	ld (hl),b		; $5de0
	ld c,a			; $5de1
	ld a,l			; $5de2
	or a			; $5de3
	jr z,_label_04_233	; $5de4
	jr _label_04_234		; $5de6
	call getThisRoomFlags		; $5de8
	ldh (<hFF8B),a	; $5deb
	ld hl,$5e26		; $5ded
	bit 0,a			; $5df0
	call nz,$5e1b		; $5df2
	ld hl,$5e36		; $5df5
	ldh a,(<hFF8B)	; $5df8
	bit 1,a			; $5dfa
	call nz,$5e1b		; $5dfc
	ld hl,$5e46		; $5dff
	ldh a,(<hFF8B)	; $5e02
	bit 2,a			; $5e04
	call nz,$5e1b		; $5e06
	ld hl,$5e56		; $5e09
	ldh a,(<hFF8B)	; $5e0c
	bit 3,a			; $5e0e
	call nz,$5e1b		; $5e10
	ld hl,$5e66		; $5e13
	ldh a,(<hFF8B)	; $5e16
	bit 7,a			; $5e18
	ret z			; $5e1a
	ld a,($cc49)		; $5e1b
	rst_addDoubleIndex			; $5e1e
	ldi a,(hl)		; $5e1f
	ld h,(hl)		; $5e20
	ld l,a			; $5e21
	ld e,l			; $5e22
	ld d,h			; $5e23
	jr _label_04_233		; $5e24
	halt			; $5e26
	ld e,(hl)		; $5e27
	halt			; $5e28
	ld e,(hl)		; $5e29
	halt			; $5e2a
	ld e,(hl)		; $5e2b
	ld (hl),a		; $5e2c
	ld e,(hl)		; $5e2d
	ld (hl),a		; $5e2e
	ld e,(hl)		; $5e2f
	ld (hl),a		; $5e30
	ld e,(hl)		; $5e31
	add b			; $5e32
	ld e,(hl)		; $5e33
	add b			; $5e34
	ld e,(hl)		; $5e35
	add c			; $5e36
	ld e,(hl)		; $5e37
	add c			; $5e38
	ld e,(hl)		; $5e39
	add c			; $5e3a
	ld e,(hl)		; $5e3b
	add d			; $5e3c
	ld e,(hl)		; $5e3d
	add d			; $5e3e
	ld e,(hl)		; $5e3f
	add d			; $5e40
	ld e,(hl)		; $5e41
	adc d			; $5e42
	ld e,(hl)		; $5e43
	adc d			; $5e44
	ld e,(hl)		; $5e45
	adc e			; $5e46
	ld e,(hl)		; $5e47
	adc e			; $5e48
	ld e,(hl)		; $5e49
	adc e			; $5e4a
	ld e,(hl)		; $5e4b
	adc h			; $5e4c
	ld e,(hl)		; $5e4d
	adc h			; $5e4e
	ld e,(hl)		; $5e4f
	adc h			; $5e50
	ld e,(hl)		; $5e51
	sub h			; $5e52
	ld e,(hl)		; $5e53
	sub h			; $5e54
	ld e,(hl)		; $5e55
	sub l			; $5e56
	ld e,(hl)		; $5e57
	sub l			; $5e58
	ld e,(hl)		; $5e59
	sub l			; $5e5a
	ld e,(hl)		; $5e5b
	sub (hl)		; $5e5c
	ld e,(hl)		; $5e5d
	sub (hl)		; $5e5e
	ld e,(hl)		; $5e5f
	sub (hl)		; $5e60
	ld e,(hl)		; $5e61
	sbc (hl)		; $5e62
	ld e,(hl)		; $5e63
	sbc (hl)		; $5e64
	ld e,(hl)		; $5e65
	sbc a			; $5e66
	ld e,(hl)		; $5e67
	xor l			; $5e68
	ld e,(hl)		; $5e69
	xor (hl)		; $5e6a
	ld e,(hl)		; $5e6b
	xor a			; $5e6c
	ld e,(hl)		; $5e6d
	or b			; $5e6e
	ld e,(hl)		; $5e6f
	or b			; $5e70
	ld e,(hl)		; $5e71
	cp h			; $5e72
	ld e,(hl)		; $5e73
	cp h			; $5e74
	ld e,(hl)		; $5e75
	nop			; $5e76
	inc (hl)		; $5e77
	jr nc,_label_04_235	; $5e78
	jr c,-$60		; $5e7a
	ld (hl),b		; $5e7c
	and b			; $5e7d
	ld (hl),h		; $5e7e
	nop			; $5e7f
	nop			; $5e80
	nop			; $5e81
	dec (hl)		; $5e82
	ld sp,$3935		; $5e83
	and b			; $5e86
	ld (hl),c		; $5e87
	and b			; $5e88
	ld (hl),l		; $5e89
	nop			; $5e8a
	nop			; $5e8b
	ld (hl),$32		; $5e8c
	ld (hl),$3a		; $5e8e
	and b			; $5e90
	ld (hl),d		; $5e91
	and b			; $5e92
	halt			; $5e93
	nop			; $5e94
	nop			; $5e95
	scf			; $5e96
	inc sp			; $5e97
	scf			; $5e98
	dec sp			; $5e99
	and b			; $5e9a
	ld (hl),e		; $5e9b
	and b			; $5e9c
	ld (hl),a		; $5e9d
	nop			; $5e9e
	rst $20			; $5e9f
	pop bc			; $5ea0
	ld ($ff00+$c6),a	; $5ea1
	ld ($ff00+$c2),a	; $5ea3
	ld ($ff00+$e3),a	; $5ea5
	and $c5			; $5ea7
	rst $20			; $5ea9
	set 5,b			; $5eaa
	ld ($ff00+c),a		; $5eac
	nop			; $5ead
_label_04_235:
	nop			; $5eae
	nop			; $5eaf
	and b			; $5eb0
	ld e,$44		; $5eb1
	ld b,d			; $5eb3
	ld b,l			; $5eb4
	ld b,e			; $5eb5
	ld b,(hl)		; $5eb6
	ld b,b			; $5eb7
	ld b,a			; $5eb8
	ld b,c			; $5eb9
	ld b,l			; $5eba
	adc l			; $5ebb
	nop			; $5ebc
	ld a,($cc55)		; $5ebd
	inc a			; $5ec0
	ret z			; $5ec1
	ld bc,$cfae		; $5ec2
_label_04_236:
	ld a,(bc)		; $5ec5
	push bc			; $5ec6
	sub $78			; $5ec7
	cp $08			; $5ec9
	call c,$5ed3		; $5ecb
	pop bc			; $5ece
	dec c			; $5ecf
	jr nz,_label_04_236	; $5ed0
	ret			; $5ed2
	ld de,$5f43		; $5ed3
	call addDoubleIndexToDe		; $5ed6
	ld a,(de)		; $5ed9
	ldh (<hFF8B),a	; $5eda
	inc de			; $5edc
	ld a,(de)		; $5edd
	ld e,a			; $5ede
	ld a,($cd00)		; $5edf
	and $08			; $5ee2
	jr z,_label_04_242	; $5ee4
	ld a,($cc48)		; $5ee6
	ld h,a			; $5ee9
	ld a,($cd02)		; $5eea
	xor $02			; $5eed
	ld d,a			; $5eef
	ld a,e			; $5ef0
	and $03			; $5ef1
	cp d			; $5ef3
	ret nz			; $5ef4
	ld a,($cd02)		; $5ef5
	bit 0,a			; $5ef8
	jr nz,_label_04_238	; $5efa
	and $02			; $5efc
	ld l,$0d		; $5efe
	ld a,(hl)		; $5f00
	jr nz,_label_04_237	; $5f01
	and $f0			; $5f03
	swap a			; $5f05
	or $a0			; $5f07
	jr _label_04_240		; $5f09
_label_04_237:
	and $f0			; $5f0b
	swap a			; $5f0d
	jr _label_04_240		; $5f0f
_label_04_238:
	and $02			; $5f11
	ld l,$0b		; $5f13
	ld a,(hl)		; $5f15
	jr nz,_label_04_239	; $5f16
	and $f0			; $5f18
	jr _label_04_240		; $5f1a
_label_04_239:
	and $f0			; $5f1c
	or $0e			; $5f1e
_label_04_240:
	cp c			; $5f20
	jr nz,_label_04_242	; $5f21
	push bc			; $5f23
	ld c,a			; $5f24
	ld a,(bc)		; $5f25
	sub $78			; $5f26
	cp $08			; $5f28
	jr nc,_label_04_241	; $5f2a
	ldh a,(<hFF8B)	; $5f2c
	ld (bc),a		; $5f2e
_label_04_241:
	pop bc			; $5f2f
_label_04_242:
	ld a,e			; $5f30
	bit 7,a			; $5f31
	ret nz			; $5f33
	and $7f			; $5f34
	ld e,a			; $5f36
	call getFreeInteractionSlot		; $5f37
	ret nz			; $5f3a
	ld (hl),$1e		; $5f3b
	inc l			; $5f3d
	ld (hl),e		; $5f3e
	ld l,$4b		; $5f3f
	ld (hl),c		; $5f41
	ret			; $5f42
	and b			; $5f43
	add b			; $5f44
	and b			; $5f45
	add c			; $5f46
	and b			; $5f47
	add d			; $5f48
	and b			; $5f49
	add e			; $5f4a
	ld e,(hl)		; $5f4b
	inc c			; $5f4c
	ld e,l			; $5f4d
	dec c			; $5f4e
	ld e,(hl)		; $5f4f
	ld c,$5d		; $5f50
	rrca			; $5f52
	call getThisRoomFlags		; $5f53
	bit 5,a			; $5f56
	ret z			; $5f58
	call getChestData		; $5f59
	ld d,$cf		; $5f5c
	ld a,$f0		; $5f5e
	ld (de),a		; $5f60
	ret			; $5f61
	ld hl,$5f90		; $5f62
	ld a,($cc49)		; $5f65
	sub $04			; $5f68
	jr z,_label_04_243	; $5f6a
	dec a			; $5f6c
	ret nz			; $5f6d
	ld hl,$5fd1		; $5f6e
_label_04_243:
	ld a,($cc4c)		; $5f71
	ld b,a			; $5f74
	ld a,($cc32)		; $5f75
	ld c,a			; $5f78
	ld d,$cf		; $5f79
_label_04_244:
	ldi a,(hl)		; $5f7b
	or a			; $5f7c
	ret z			; $5f7d
	cp b			; $5f7e
	jr nz,_label_04_245	; $5f7f
	ldi a,(hl)		; $5f81
	and c			; $5f82
	jr z,_label_04_246	; $5f83
	ldi a,(hl)		; $5f85
	ld e,(hl)		; $5f86
	inc hl			; $5f87
	ld (de),a		; $5f88
	jr _label_04_244		; $5f89
_label_04_245:
	inc hl			; $5f8b
_label_04_246:
	inc hl			; $5f8c
	inc hl			; $5f8d
	jr _label_04_244		; $5f8e
	rrca			; $5f90
	ld bc,$330b		; $5f91
	rrca			; $5f94
	ld bc,$745a		; $5f95
	ld l,a			; $5f98
	ld bc,$8c0b		; $5f99
	ld l,a			; $5f9c
	ld bc,$295c		; $5f9d
	ld (hl),b		; $5fa0
	ld (bc),a		; $5fa1
	dec bc			; $5fa2
	jr z,_label_04_249	; $5fa3
	ld (bc),a		; $5fa5
	ld e,e			; $5fa6
	ld d,d			; $5fa7
	ld (hl),b		; $5fa8
	inc b			; $5fa9
	dec bc			; $5faa
	ld e,c			; $5fab
	ld (hl),b		; $5fac
	inc b			; $5fad
	ld e,e			; $5fae
	add h			; $5faf
	halt			; $5fb0
	ld ($170b),sp		; $5fb1
	halt			; $5fb4
	ld ($255d),sp		; $5fb5
	ld a,(hl)		; $5fb8
	stop			; $5fb9
	dec bc			; $5fba
	ld d,(hl)		; $5fbb
	ld a,(hl)		; $5fbc
	stop			; $5fbd
	ld e,h			; $5fbe
	ld h,(hl)		; $5fbf
	and b			; $5fc0
	ld bc,$445e		; $5fc1
	and b			; $5fc4
	ld (bc),a		; $5fc5
	ld e,(hl)		; $5fc6
	scf			; $5fc7
	and b			; $5fc8
	ld bc,$830b		; $5fc9
	and b			; $5fcc
	ld (bc),a		; $5fcd
	dec bc			; $5fce
	ld a,b			; $5fcf
	nop			; $5fd0
	ld a,(hl)		; $5fd1
	ld bc,$2b5c		; $5fd2
	ld a,(hl)		; $5fd5
	ld bc,$780b		; $5fd6
	nop			; $5fd9
	ld a,($cc4c)		; $5fda
	ld b,a			; $5fdd
	call getThisRoomFlags		; $5fde
	ld c,a			; $5fe1
	ld d,$cf		; $5fe2
	ld a,($cc49)		; $5fe4
	ld hl,$6005		; $5fe7
	rst_addDoubleIndex			; $5fea
	ldi a,(hl)		; $5feb
	ld h,(hl)		; $5fec
	ld l,a			; $5fed
_label_04_247:
	ldi a,(hl)		; $5fee
	cp b			; $5fef
	jr nz,_label_04_248	; $5ff0
	ld a,(hl)		; $5ff2
	and c			; $5ff3
	jr z,_label_04_248	; $5ff4
	inc hl			; $5ff6
	ldi a,(hl)		; $5ff7
	ld e,a			; $5ff8
	ldi a,(hl)		; $5ff9
	ld (de),a		; $5ffa
	jr _label_04_247		; $5ffb
_label_04_248:
	ld a,(hl)		; $5ffd
	or a			; $5ffe
	ret z			; $5fff
	inc hl			; $6000
	inc hl			; $6001
	inc hl			; $6002
	jr _label_04_247		; $6003
	dec d			; $6005
	ld h,b			; $6006
	ccf			; $6007
	ld h,b			; $6008
	ld (hl),l		; $6009
	ld h,b			; $600a
	ld (hl),l		; $600b
	ld h,b			; $600c
	ld (hl),l		; $600d
	ld h,b			; $600e
	add e			; $600f
	ld h,b			; $6010
	xor c			; $6011
	ld h,b			; $6012
	xor c			; $6013
	ld h,b			; $6014
_label_04_249:
	sbc d			; $6015
	ld b,b			; $6016
	inc sp			; $6017
	push bc			; $6018
	ld d,d			; $6019
	ld b,b			; $601a
	ld (bc),a		; $601b
	ret nc			; $601c
	ld d,d			; $601d
	ld b,b			; $601e
	ld bc,$526b		; $601f
	ld b,b			; $6022
	inc bc			; $6023
	ld b,l			; $6024
	jp hl			; $6025
	ld bc,$0448		; $6026
	jp hl			; $6029
	ld (bc),a		; $602a
	ld e,b			; $602b
	inc b			; $602c
	ld bc,$6680		; $602d
	inc b			; $6030
	ld bc,$6580		; $6031
	sbc h			; $6034
	ld bc,$6640		; $6035
	inc b			; $6038
	ld bc,$6740		; $6039
	sbc h			; $603c
	nop			; $603d
	nop			; $603e
	ld a,(bc)		; $603f
	add b			; $6040
	ldd (hl),a		; $6041
	pop hl			; $6042
	ld a,(bc)		; $6043
	add b			; $6044
	inc sp			; $6045
	pop hl			; $6046
	ld a,(bc)		; $6047
	add b			; $6048
	inc (hl)		; $6049
	pop hl			; $604a
	ld ($5340),sp		; $604b
	add sp,$12		; $604e
	ld b,b			; $6050
	ld e,b			; $6051
	add sp,$35		; $6052
	ld b,b			; $6054
	ld b,(hl)		; $6055
	add sp,$13		; $6056
	ld bc,$0425		; $6058
	ld b,d			; $605b
	ld bc,$0657		; $605c
	ld b,h			; $605f
	ld bc,$0656		; $6060
	ld c,b			; $6063
	ld bc,$0435		; $6064
	ld d,l			; $6067
	ld bc,fillMemoryBc		; $6068
	ld d,l			; $606b
	ld (bc),a		; $606c
	ld h,d			; $606d
	inc b			; $606e
	ld l,c			; $606f
	jr nz,_label_04_250	; $6070
	pop hl			; $6072
	nop			; $6073
	nop			; $6074
	add hl,sp		; $6075
	add b			; $6076
	rlca			; $6077
	and b			; $6078
	add hl,sp		; $6079
	add b			; $607a
	inc h			; $607b
	add hl,bc		; $607c
	add hl,sp		; $607d
	add b			; $607e
	ldi a,(hl)		; $607f
	add hl,bc		; $6080
	nop			; $6081
	nop			; $6082
	ld a,($ff00+$40)	; $6083
	ld (hl),a		; $6085
	ld l,d			; $6086
	cp h			; $6087
	jr nz,_label_04_251	; $6088
	ld d,e			; $608a
	ld a,$80		; $608b
	ld e,h			; $608d
	dec b			; $608e
	ld (hl),e		; $608f
	add b			; $6090
	ld b,l			; $6091
	and b			; $6092
	ld (hl),e		; $6093
	add b			; $6094
	inc (hl)		; $6095
	ld h,$99		; $6096
	add b			; $6098
	sbc l			; $6099
_label_04_250:
	ld b,h			; $609a
	sbc d			; $609b
	add b			; $609c
	ld h,(hl)		; $609d
	ld b,l			; $609e
	sbc (hl)		; $609f
	add b			; $60a0
	sbc l			; $60a1
	ld b,h			; $60a2
	daa			; $60a3
	add b			; $60a4
	ld d,a			; $60a5
	ld c,a			; $60a6
	nop			; $60a7
	nop			; $60a8
	nop			; $60a9
	nop			; $60aa
	ld a,($cc4c)		; $60ab
	ld hl,$6114		; $60ae
	call findRoomSpecificData		; $60b1
_label_04_251:
	ret nc			; $60b4
	rst_jumpTable			; $60b5
	sub l			; $60b6
	ld h,c			; $60b7
	sbc a			; $60b8
	ld h,c			; $60b9
	dec d			; $60ba
	ld h,d			; $60bb
	jr nc,_label_04_252	; $60bc
	ld d,b			; $60be
	ld h,d			; $60bf
	ld hl,$6862		; $60c0
	ld h,d			; $60c3
	ld e,h			; $60c4
	ld h,d			; $60c5
	adc c			; $60c6
	ld h,c			; $60c7
	ld (hl),a		; $60c8
	ld h,d			; $60c9
	or c			; $60ca
	ld h,e			; $60cb
	ld ($ff00+$62),a	; $60cc
	add h			; $60ce
	ld h,e			; $60cf
	or c			; $60d0
	ld h,e			; $60d1
	or c			; $60d2
	ld h,e			; $60d3
	sub $63			; $60d4
	ld a,($ff00+c)		; $60d6
	ld h,e			; $60d7
	cp $63			; $60d8
	ld a,(bc)		; $60da
	ld h,h			; $60db
	dec l			; $60dc
	ld h,h			; $60dd
	ld c,c			; $60de
	ld h,h			; $60df
	ld e,e			; $60e0
	ld h,h			; $60e1
	ld l,l			; $60e2
	ld h,h			; $60e3
	adc c			; $60e4
	ld h,h			; $60e5
	or d			; $60e6
	ld h,h			; $60e7
	jp nz,$fb64		; $60e8
	ld h,h			; $60eb
	inc b			; $60ec
	ld h,l			; $60ed
	ld hl,$2b64		; $60ee
	ld h,(hl)		; $60f1
	or h			; $60f2
	ld h,c			; $60f3
	di			; $60f4
	ld h,c			; $60f5
	ld d,$65		; $60f6
	ld e,(hl)		; $60f8
	ld h,l			; $60f9
	adc c			; $60fa
	ld h,l			; $60fb
	and a			; $60fc
	ld h,l			; $60fd
	or l			; $60fe
	ld h,l			; $60ff
	jp $d265		; $6100
	ld h,c			; $6103
	ei			; $6104
	ld h,l			; $6105
	rlca			; $6106
	ld h,(hl)		; $6107
	add $61			; $6108
	ld (hl),e		; $610a
	ld h,(hl)		; $610b
	ldd a,(hl)		; $610c
	ld h,(hl)		; $610d
	dec c			; $610e
	ld h,l			; $610f
	ld a,($ff00+c)		; $6110
	ld h,h			; $6111
	jp hl			; $6112
	ld h,h			; $6113
	inc h			; $6114
	ld h,c			; $6115
	ld d,c			; $6116
	ld h,c			; $6117
	ld e,b			; $6118
	ld h,c			; $6119
	ld e,b			; $611a
	ld h,c			; $611b
	ld h,c			; $611c
	ld h,c			; $611d
	ld l,(hl)		; $611e
	ld h,c			; $611f
_label_04_252:
	add a			; $6120
	ld h,c			; $6121
	add a			; $6122
	ld h,c			; $6123
	push bc			; $6124
	nop			; $6125
	reti			; $6126
	ld bc,$1054		; $6127
	ld a,a			; $612a
	ld de,$1262		; $612b
	ld h,b			; $612e
	inc de			; $612f
	ld h,c			; $6130
	inc d			; $6131
	ld (hl),b		; $6132
	dec d			; $6133
	ld (hl),c		; $6134
	ld d,$81		; $6135
	rla			; $6137
	dec c			; $6138
	jr _label_04_253		; $6139
	add hl,de		; $613b
	ld h,e			; $613c
	ld e,$e4		; $613d
	ld h,$f4		; $613f
	rra			; $6141
	ld l,a			; $6142
	jr nz,_label_04_254	; $6143
	ld hl,$22fc		; $6145
	xor $25			; $6148
	ld d,(hl)		; $614a
	jr z,_label_04_255	; $614b
	dec e			; $614d
	or $08			; $614e
	nop			; $6150
	dec (hl)		; $6151
	daa			; $6152
	ld h,h			; $6153
	inc hl			; $6154
	ld (hl),h		; $6155
	inc h			; $6156
	nop			; $6157
_label_04_253:
	and h			; $6158
	add hl,hl		; $6159
	xor e			; $615a
	ldi a,(hl)		; $615b
	or b			; $615c
	inc bc			; $615d
	or l			; $615e
	inc e			; $615f
	nop			; $6160
	ld h,c			; $6161
	ld l,$78		; $6162
	ld (bc),a		; $6164
	ld l,$04		; $6165
	ld h,h			; $6167
	dec b			; $6168
	adc c			; $6169
	ld b,$bb		; $616a
	rlca			; $616c
	nop			; $616d
	dec sp			; $616e
	dec l			; $616f
	ld h,l			; $6170
	add hl,bc		; $6171
	ld h,(hl)		; $6172
	ld a,(bc)		; $6173
	ld h,a			; $6174
	dec bc			; $6175
	ld l,b			; $6176
	inc c			; $6177
	ld l,d			; $6178
	dec c			; $6179
	ld l,e			; $617a
	ld c,$86		; $617b
	rrca			; $617d
	ld a,d			; $617e
	ld a,(de)		; $617f
	ld a,b			; $6180
	dec de			; $6181
	adc (hl)		; $6182
	inc l			; $6183
	sbc (hl)		; $6184
	dec hl			; $6185
	nop			; $6186
_label_04_254:
	nop			; $6187
	ret			; $6188
	ld a,$28		; $6189
	call checkGlobalFlag		; $618b
	ret z			; $618e
	ld hl,$cf33		; $618f
	ld (hl),$f2		; $6192
	ret			; $6194
	ldh a,(<hGameboyType)	; $6195
	rlca			; $6197
_label_04_255:
	ret nc			; $6198
	ld hl,$cf14		; $6199
	ld (hl),$ea		; $619c
	ret			; $619e
	call getThisRoomFlags		; $619f
	bit 7,(hl)		; $61a2
	ret z			; $61a4
	ld hl,$cf14		; $61a5
	ld a,$bf		; $61a8
	ldi (hl),a		; $61aa
	ld (hl),a		; $61ab
	ld l,$24		; $61ac
	ld a,$a9		; $61ae
	ldi (hl),a		; $61b0
	inc a			; $61b1
	ld (hl),a		; $61b2
	ret			; $61b3
	call getThisRoomFlags		; $61b4
	bit 7,(hl)		; $61b7
	ret z			; $61b9
	ld hl,$cf14		; $61ba
	ld a,$ad		; $61bd
	ldi (hl),a		; $61bf
	ld (hl),a		; $61c0
	ld l,$24		; $61c1
	ldi (hl),a		; $61c3
	ld (hl),a		; $61c4
	ret			; $61c5
	call getThisRoomFlags		; $61c6
	and $40			; $61c9
	ret z			; $61cb
	ld hl,$cf36		; $61cc
	ld (hl),$09		; $61cf
	ret			; $61d1
	call getThisRoomFlags		; $61d2
	and $40			; $61d5
	jr z,_label_04_256	; $61d7
	ld hl,$cf77		; $61d9
	ld (hl),$a1		; $61dc
	ret			; $61de
_label_04_256:
	ld hl,$61ee		; $61df
	ld d,$cf		; $61e2
_label_04_257:
	ldi a,(hl)		; $61e4
	or a			; $61e5
	ret z			; $61e6
	ld e,a			; $61e7
	ldi a,(hl)		; $61e8
	ld (de),a		; $61e9
	inc e			; $61ea
	ld (de),a		; $61eb
	jr _label_04_257		; $61ec
	ld h,l			; $61ee
.DB $fd				; $61ef
	ld (hl),l		; $61f0
.DB $fd				; $61f1
	nop			; $61f2
	call getThisRoomFlags		; $61f3
	bit 6,(hl)		; $61f6
	ret z			; $61f8
	bit 5,(hl)		; $61f9
	jr nz,_label_04_258	; $61fb
	ld hl,$cf45		; $61fd
	ld (hl),$f1		; $6200
_label_04_258:
	ld hl,$cf22		; $6202
	ld (hl),$0f		; $6205
	inc l			; $6207
	ld (hl),$11		; $6208
	ld l,$32		; $620a
	ld (hl),$11		; $620c
	inc l			; $620e
	ld (hl),$0f		; $620f
	inc l			; $6211
	ld (hl),$11		; $6212
	ret			; $6214
	call getThisRoomFlags		; $6215
	bit 7,(hl)		; $6218
	ret nz			; $621a
	ld hl,$cf39		; $621b
	ld (hl),$b0		; $621e
	ret			; $6220
	call getThisRoomFlags		; $6221
	bit 7,(hl)		; $6224
	ret z			; $6226
	ld de,$622d		; $6227
	jp $5dc7		; $622a
	add hl,bc		; $622d
	ld ($fa00),sp		; $622e
	ccf			; $6231
	add $e6			; $6232
	rrca			; $6234
	cp $0f			; $6235
	ret nz			; $6237
	ld hl,$624c		; $6238
	call $669d		; $623b
	ld a,$f1		; $623e
	ld hl,$cf25		; $6240
	ld (hl),a		; $6243
	ld l,$27		; $6244
	ld (hl),a		; $6246
	ld l,$32		; $6247
	ld (hl),$a0		; $6249
	ret			; $624b
	inc de			; $624c
	inc bc			; $624d
	ld b,$a0		; $624e
	ld hl,$cf23		; $6250
	ld bc,$0808		; $6253
	ld de,$c8f0		; $6256
	jp $66b7		; $6259
	ld hl,$cf34		; $625c
	ld bc,$0808		; $625f
	ld de,$c8f8		; $6262
	jp $66b7		; $6265
	call getThisRoomFlags		; $6268
	bit 5,(hl)		; $626b
	ret z			; $626d
	ld de,$6274		; $626e
	jp $5dc7		; $6271
	ld a,($ff00+$25)	; $6274
	nop			; $6276
	call getThisRoomFlags		; $6277
	bit 6,(hl)		; $627a
	jr z,_label_04_259	; $627c
	call $63cb		; $627e
	ld hl,$6294		; $6281
	call $6690		; $6284
_label_04_259:
	call getThisRoomFlags		; $6287
	inc l			; $628a
	bit 6,(hl)		; $628b
	ret z			; $628d
	ld hl,$62c8		; $628e
	jp $6690		; $6291
	rst_addAToHl			; $6294
	ld de,$1817		; $6295
	ld hl,$2827		; $6298
	ld sp,$4137		; $629b
	ld b,d			; $629e
	ld b,e			; $629f
	ld b,h			; $62a0
	ld b,l			; $62a1
	ld b,(hl)		; $62a2
	ld b,a			; $62a3
	ld d,c			; $62a4
	ld d,d			; $62a5
	ld d,e			; $62a6
	ld d,l			; $62a7
	ld h,c			; $62a8
	ld h,d			; $62a9
	ld h,h			; $62aa
	ld h,(hl)		; $62ab
	ld h,a			; $62ac
	ld l,b			; $62ad
	ld (hl),c		; $62ae
	ld (hl),d		; $62af
	ld (hl),e		; $62b0
	ld (hl),h		; $62b1
	ld (hl),l		; $62b2
	halt			; $62b3
	ld (hl),a		; $62b4
	add c			; $62b5
	add d			; $62b6
	add e			; $62b7
	add h			; $62b8
	add l			; $62b9
	add (hl)		; $62ba
	add a			; $62bb
	sub c			; $62bc
	sub d			; $62bd
	sub h			; $62be
	sub l			; $62bf
	sub (hl)		; $62c0
	and c			; $62c1
	and d			; $62c2
	and e			; $62c3
	and h			; $62c4
	and l			; $62c5
	and (hl)		; $62c6
	rst $38			; $62c7
	rst_addAToHl			; $62c8
	ld l,l			; $62c9
	ld l,(hl)		; $62ca
	ld a,h			; $62cb
	ld a,l			; $62cc
	ld a,(hl)		; $62cd
	adc d			; $62ce
	adc e			; $62cf
	adc h			; $62d0
	adc l			; $62d1
	adc (hl)		; $62d2
	sbc c			; $62d3
	sbc d			; $62d4
	sbc e			; $62d5
	sbc h			; $62d6
	sbc l			; $62d7
	sbc (hl)		; $62d8
	xor c			; $62d9
	xor d			; $62da
	xor e			; $62db
	xor h			; $62dc
	xor l			; $62dd
	xor (hl)		; $62de
	rst $38			; $62df
	ld a,$65		; $62e0
	call getARoomFlags		; $62e2
	bit 6,(hl)		; $62e5
	jr z,_label_04_260	; $62e7
	ld hl,$630c		; $62e9
	call $6690		; $62ec
_label_04_260:
	ld a,$66		; $62ef
	call getARoomFlags		; $62f1
	bit 6,(hl)		; $62f4
	jr z,_label_04_261	; $62f6
	ld hl,$632d		; $62f8
	call $6690		; $62fb
_label_04_261:
	ld a,$6a		; $62fe
	call getARoomFlags		; $6300
	bit 6,(hl)		; $6303
	ret z			; $6305
	ld hl,$6340		; $6306
	jp $6690		; $6309
	rst_addAToHl			; $630c
	ld bc,$0302		; $630d
	inc b			; $6310
	dec b			; $6311
	ld b,$11		; $6312
	ld (de),a		; $6314
	inc de			; $6315
	inc d			; $6316
	dec d			; $6317
	ld d,$21		; $6318
	ldi (hl),a		; $631a
	inc hl			; $631b
	ld sp,$3332		; $631c
	ld b,c			; $631f
	ld b,d			; $6320
	ld b,e			; $6321
	ld d,c			; $6322
	ld d,d			; $6323
	ld d,e			; $6324
	ld h,c			; $6325
	ld h,d			; $6326
	ld h,e			; $6327
	ld h,h			; $6328
	ld (hl),c		; $6329
	ld (hl),d		; $632a
	ld (hl),e		; $632b
	rst $38			; $632c
	rst_addAToHl			; $632d
	add hl,bc		; $632e
	ld a,(bc)		; $632f
	dec bc			; $6330
	inc c			; $6331
	dec c			; $6332
	ld c,$19		; $6333
	ld a,(de)		; $6335
	dec de			; $6336
	inc e			; $6337
	dec e			; $6338
	ld e,$2a		; $6339
	dec hl			; $633b
	dec l			; $633c
	ld l,$3e		; $633d
	rst $38			; $633f
	rst_addAToHl			; $6340
	dec h			; $6341
	ld h,$27		; $6342
	dec (hl)		; $6344
	ld (hl),$37		; $6345
	jr c,_label_04_262	; $6347
	ld b,l			; $6349
	ld b,(hl)		; $634a
	ld b,a			; $634b
	ld c,b			; $634c
	ld c,c			; $634d
	ld d,l			; $634e
	ld d,(hl)		; $634f
	ld d,a			; $6350
	ld e,b			; $6351
	ld e,c			; $6352
	ld h,(hl)		; $6353
	ld h,a			; $6354
	ld l,b			; $6355
	ld l,c			; $6356
	ld l,d			; $6357
	ld (hl),l		; $6358
	halt			; $6359
	ld (hl),a		; $635a
	ld a,b			; $635b
	ld a,c			; $635c
	ld a,d			; $635d
	add c			; $635e
	add d			; $635f
	add e			; $6360
	add h			; $6361
	add l			; $6362
	add (hl)		; $6363
	add a			; $6364
	adc b			; $6365
	adc c			; $6366
	adc d			; $6367
	adc e			; $6368
	sub c			; $6369
	sub d			; $636a
	sub e			; $636b
	sub h			; $636c
	sub l			; $636d
	sub (hl)		; $636e
	sub a			; $636f
	sbc b			; $6370
	sbc c			; $6371
	sbc d			; $6372
	sbc e			; $6373
	sbc h			; $6374
	sbc l			; $6375
	and c			; $6376
	and d			; $6377
	and e			; $6378
	and h			; $6379
	and l			; $637a
	and (hl)		; $637b
	and a			; $637c
	xor b			; $637d
	xor c			; $637e
	xor d			; $637f
	xor e			; $6380
	xor h			; $6381
_label_04_262:
	xor l			; $6382
	rst $38			; $6383
	ld a,$66		; $6384
	call getARoomFlags		; $6386
	bit 6,(hl)		; $6389
	jr z,_label_04_263	; $638b
	ld hl,$cf00		; $638d
	ld b,$70		; $6390
	call $63a2		; $6392
_label_04_263:
	ld a,$6b		; $6395
	call getARoomFlags		; $6397
	bit 6,(hl)		; $639a
	ret z			; $639c
	ld hl,$cf70		; $639d
	ld b,$00		; $63a0
_label_04_264:
	ld a,(hl)		; $63a2
	sub $61			; $63a3
	cp $05			; $63a5
	jr nc,_label_04_265	; $63a7
	ld (hl),$d7		; $63a9
_label_04_265:
	inc l			; $63ab
	ld a,l			; $63ac
	cp b			; $63ad
	jr nz,_label_04_264	; $63ae
	ret			; $63b0
	call getThisRoomFlags		; $63b1
	bit 6,(hl)		; $63b4
	ret z			; $63b6
	call $63cb		; $63b7
	ld de,$63c0		; $63ba
	jp $5dc7		; $63bd
	rst_addAToHl			; $63c0
	ld h,c			; $63c1
	rst_addAToHl			; $63c2
	ld h,d			; $63c3
	rst_addAToHl			; $63c4
	ld h,e			; $63c5
	rst_addAToHl			; $63c6
	ld h,h			; $63c7
	rst_addAToHl			; $63c8
	ld h,l			; $63c9
	nop			; $63ca
	ld de,$63d1		; $63cb
	jp $5dc7		; $63ce
	push de			; $63d1
	call nc,$67d7		; $63d2
	nop			; $63d5
	call getThisRoomFlags		; $63d6
	bit 7,(hl)		; $63d9
	ret z			; $63db
	ld de,$63ef		; $63dc
	call $5dc7		; $63df
	ld hl,$cf4d		; $63e2
	ld a,$2f		; $63e5
	ld (hl),a		; $63e7
	ld l,$5d		; $63e8
	ld (hl),a		; $63ea
	ld l,$6d		; $63eb
	ld (hl),a		; $63ed
	ret			; $63ee
	adc h			; $63ef
	cpl			; $63f0
	nop			; $63f1
	ld a,($c643)		; $63f2
	bit 6,a			; $63f5
	ret z			; $63f7
	ld hl,$cf34		; $63f8
	ld (hl),$f2		; $63fb
	ret			; $63fd
	ld a,($cc4e)		; $63fe
	cp $03			; $6401
	ret nz			; $6403
	ld hl,$cf47		; $6404
	ld (hl),$ea		; $6407
	ret			; $6409
	ld h,$c8		; $640a
	ld l,$b5		; $640c
	bit 6,(hl)		; $640e
	ret nz			; $6410
	ld hl,$641d		; $6411
	call $669d		; $6414
	ld hl,$cf27		; $6417
	ld (hl),$fd		; $641a
	ret			; $641c
	ld h,$02		; $641d
	inc bc			; $641f
	ld a,($56cd)		; $6420
	add hl,de		; $6423
	bit 6,(hl)		; $6424
	ret nz			; $6426
	ld hl,$cf37		; $6427
	ld (hl),$fa		; $642a
	ret			; $642c
	ld a,$81		; $642d
	call getARoomFlags		; $642f
	bit 7,(hl)		; $6432
	ret nz			; $6434
	ld hl,$6441		; $6435
	call $669d		; $6438
	ld hl,$6445		; $643b
	jp $669d		; $643e
	inc h			; $6441
	ld b,$03		; $6442
.DB $fd				; $6444
	ld b,a			; $6445
	inc b			; $6446
	inc bc			; $6447
.DB $fd				; $6448
	ld a,$81		; $6449
	call getARoomFlags		; $644b
	bit 7,(hl)		; $644e
	ret nz			; $6450
	ld hl,$6457		; $6451
	jp $669d		; $6454
	ld b,b			; $6457
	inc b			; $6458
	rlca			; $6459
.DB $fd				; $645a
	ld a,$81		; $645b
	call getARoomFlags		; $645d
	bit 7,(hl)		; $6460
	ret nz			; $6462
	ld hl,$6469		; $6463
	jp $669d		; $6466
	inc b			; $6469
	inc b			; $646a
	ld b,$fd		; $646b
	ld a,$81		; $646d
	call getARoomFlags		; $646f
	bit 7,(hl)		; $6472
	ret nz			; $6474
	ld hl,$6481		; $6475
	call $669d		; $6478
	ld hl,$6485		; $647b
	jp $669d		; $647e
	nop			; $6481
	inc b			; $6482
	rlca			; $6483
.DB $fd				; $6484
	ld b,h			; $6485
	inc b			; $6486
	inc bc			; $6487
.DB $fd				; $6488
	call getThisRoomFlags		; $6489
	bit 7,(hl)		; $648c
	jr nz,_label_04_266	; $648e
	ld hl,$64a6		; $6490
	jp $669d		; $6493
_label_04_266:
	ld hl,$64ae		; $6496
	ld a,($cc4e)		; $6499
	cp $03			; $649c
	jr z,_label_04_267	; $649e
	ld hl,$64aa		; $64a0
_label_04_267:
	jp $669d		; $64a3
	inc b			; $64a6
	ld bc,$fd03		; $64a7
	inc d			; $64aa
	ld bc,$fa03		; $64ab
	inc d			; $64ae
	ld bc,$dc03		; $64af
	call getThisRoomFlags		; $64b2
	bit 7,(hl)		; $64b5
	ret nz			; $64b7
	ld hl,$64be		; $64b8
	jp $669d		; $64bb
	ld h,d			; $64be
	ld (bc),a		; $64bf
	inc bc			; $64c0
	rst $38			; $64c1
	call getThisRoomFlags		; $64c2
	bit 7,(hl)		; $64c5
	ret nz			; $64c7
	ld hl,$64d9		; $64c8
	call $669d		; $64cb
	ld l,$13		; $64ce
	ld a,$fe		; $64d0
	ld (hl),a		; $64d2
	ld l,$22		; $64d3
	ldi (hl),a		; $64d5
	ldi (hl),a		; $64d6
	ld (hl),a		; $64d7
	ret			; $64d8
	ld (bc),a		; $64d9
	inc bc			; $64da
	inc bc			; $64db
	rst $38			; $64dc
	ret			; $64dd
_label_04_268:
	call getThisRoomFlags		; $64de
	bit 7,(hl)		; $64e1
	ret z			; $64e3
	ld h,b			; $64e4
	ld l,c			; $64e5
	jp $669d		; $64e6
	ld bc,$64ee		; $64e9
	jr _label_04_268		; $64ec
	ld e,c			; $64ee
	ld bc,$6d03		; $64ef
	ld bc,$64f7		; $64f2
	jr _label_04_268		; $64f5
	ld (hl),a		; $64f7
	ld bc,$6d04		; $64f8
	ld bc,$6500		; $64fb
	jr _label_04_268		; $64fe
	inc a			; $6500
	ld b,$01		; $6501
	ld l,d			; $6503
	ld bc,$6509		; $6504
	jr _label_04_268		; $6507
	add d			; $6509
	ld bc,$6d07		; $650a
	ld bc,$6512		; $650d
	jr _label_04_268		; $6510
	dec de			; $6512
	rlca			; $6513
	ld bc,$cd6a		; $6514
	ld d,(hl)		; $6517
	add hl,de		; $6518
	and $c0			; $6519
	ret z			; $651b
	ld de,$6555		; $651c
	ld a,$12		; $651f
	call checkGlobalFlag		; $6521
	jr nz,_label_04_270	; $6524
	ld a,($cc69)		; $6526
	bit 1,a			; $6529
	jr nz,_label_04_269	; $652b
	ld de,$654c		; $652d
	jr _label_04_270		; $6530
_label_04_269:
	ld a,$12		; $6532
	call setGlobalFlag		; $6534
_label_04_270:
	ld hl,$cf36		; $6537
	ld b,$03		; $653a
_label_04_271:
	ld c,$03		; $653c
_label_04_272:
	ld a,(de)		; $653e
	inc de			; $653f
	ldi (hl),a		; $6540
	dec c			; $6541
	jr nz,_label_04_272	; $6542
	ld a,$0d		; $6544
	add l			; $6546
	ld l,a			; $6547
	dec b			; $6548
	jr nz,_label_04_271	; $6549
	ret			; $654b
.DB $fd				; $654c
.DB $fd				; $654d
.DB $fc				; $654e
	ei			; $654f
.DB $fd				; $6550
.DB $fc				; $6551
.DB $fd				; $6552
	ei			; $6553
.DB $fd				; $6554
	xor b			; $6555
.DB $eb				; $6556
	and l			; $6557
	or e			; $6558
	or h			; $6559
	or l			; $655a
	and e			; $655b
	xor $a4			; $655c
	ld hl,$cf44		; $655e
	ld (hl),$9c		; $6561
	call getThisRoomFlags		; $6563
	and $80			; $6566
	jr z,_label_04_273	; $6568
	ld hl,$cf55		; $656a
	ld (hl),$bc		; $656d
	jr _label_04_274		; $656f
_label_04_273:
	ld hl,$cf54		; $6571
	ld (hl),$d6		; $6574
_label_04_274:
	call getThisRoomFlags		; $6576
	and $40			; $6579
	jr z,_label_04_275	; $657b
	ld hl,$cf65		; $657d
	ld (hl),$bc		; $6580
	ret			; $6582
_label_04_275:
	ld hl,$cf64		; $6583
	ld (hl),$d6		; $6586
	ret			; $6588
	call getThisRoomFlags		; $6589
	bit 7,(hl)		; $658c
	ret z			; $658e
	ld hl,$cf03		; $658f
	ld a,$af		; $6592
	ldi (hl),a		; $6594
	ldi (hl),a		; $6595
	ldi (hl),a		; $6596
	ld (hl),a		; $6597
	ld a,$0d		; $6598
	rst_addAToHl			; $659a
	ld a,$af		; $659b
	ldi (hl),a		; $659d
	ldi (hl),a		; $659e
	ldi (hl),a		; $659f
	ld (hl),a		; $65a0
	ret			; $65a1
	ld a,$17		; $65a2
	jp checkGlobalFlag		; $65a4
	call $65a2		; $65a7
	ret z			; $65aa
	ld hl,$65b1		; $65ab
	jp $669d		; $65ae
	ld b,h			; $65b1
	inc b			; $65b2
	dec b			; $65b3
	rrca			; $65b4
	call $65a2		; $65b5
	ret z			; $65b8
	ld hl,$65bf		; $65b9
	jp $669d		; $65bc
	inc b			; $65bf
	inc b			; $65c0
	dec b			; $65c1
	rrca			; $65c2
	call $65a2		; $65c3
	ret z			; $65c6
	ld hl,$65e2		; $65c7
	ld de,$cf23		; $65ca
	ld bc,$0505		; $65cd
_label_04_276:
	push de			; $65d0
	push bc			; $65d1
_label_04_277:
	ldi a,(hl)		; $65d2
	ld (de),a		; $65d3
	inc e			; $65d4
	dec b			; $65d5
	jr nz,_label_04_277	; $65d6
	pop bc			; $65d8
	pop de			; $65d9
	ld a,e			; $65da
	add $10			; $65db
	ld e,a			; $65dd
	dec c			; $65de
	jr nz,_label_04_276	; $65df
	ret			; $65e1
	xor a			; $65e2
	xor a			; $65e3
	xor a			; $65e4
	xor a			; $65e5
	xor a			; $65e6
	xor l			; $65e7
	xor l			; $65e8
	xor (hl)		; $65e9
	xor (hl)		; $65ea
	xor a			; $65eb
	xor l			; $65ec
	xor l			; $65ed
	xor (hl)		; $65ee
	xor (hl)		; $65ef
	xor a			; $65f0
	cp l			; $65f1
	cp l			; $65f2
	cp (hl)			; $65f3
	cp (hl)			; $65f4
	xor a			; $65f5
	cp l			; $65f6
	cp l			; $65f7
	cp (hl)			; $65f8
	cp (hl)			; $65f9
	xor a			; $65fa
	ld a,($c9f9)		; $65fb
	and $04			; $65fe
	ret z			; $6600
	ld hl,$cf43		; $6601
	ld (hl),$e8		; $6604
	ret			; $6606
	xor a			; $6607
	ld ($cc32),a		; $6608
	ld a,($c610)		; $660b
	cp $0c			; $660e
	ret z			; $6610
	call getThisRoomFlags		; $6611
	and $40			; $6614
	jr nz,_label_04_278	; $6616
	ld a,$fd		; $6618
	ld hl,$cf43		; $661a
	ldi (hl),a		; $661d
	ld (hl),a		; $661e
	ld hl,$cf53		; $661f
	ldi (hl),a		; $6622
	ld (hl),a		; $6623
	ret			; $6624
_label_04_278:
	ld a,$b0		; $6625
	ld ($cf66),a		; $6627
	ret			; $662a
	ld a,$16		; $662b
	call checkGlobalFlag		; $662d
	ret z			; $6630
	ld hl,$cf73		; $6631
	ld a,$40		; $6634
	ldi (hl),a		; $6636
	ldi (hl),a		; $6637
	ld (hl),a		; $6638
	ret			; $6639
	ld a,($ccc4)		; $663a
	or a			; $663d
	ret z			; $663e
	dec a			; $663f
	jr z,_label_04_281	; $6640
	dec a			; $6642
	jr z,_label_04_280	; $6643
	dec a			; $6645
	jr z,_label_04_279	; $6646
	xor a			; $6648
	ld ($ccc4),a		; $6649
	ld hl,$6652		; $664c
	jp $669d		; $664f
	nop			; $6652
	dec bc			; $6653
	rrca			; $6654
	xor d			; $6655
_label_04_279:
	ld ($ccc4),a		; $6656
	ld a,$b9		; $6659
	jp loadGfxHeader		; $665b
_label_04_280:
	ld ($ccc4),a		; $665e
	ld hl,$6667		; $6661
	jp $669d		; $6664
	ld de,$0d09		; $6667
	adc h			; $666a
_label_04_281:
	ld ($ccc4),a		; $666b
	ld a,$b8		; $666e
	jp loadGfxHeader		; $6670
	call getThisRoomFlags		; $6673
	and $40			; $6676
	ret z			; $6678
	ld hl,$cf14		; $6679
	ld a,$6d		; $667c
	ldi (hl),a		; $667e
	ldi (hl),a		; $667f
	ld (hl),a		; $6680
	ld a,$6a		; $6681
	ld l,$47		; $6683
	ld (hl),a		; $6685
	ld l,$37		; $6686
	ld (hl),a		; $6688
	ld l,$27		; $6689
	ld (hl),a		; $668b
	ld l,$17		; $668c
	ld (hl),a		; $668e
	ret			; $668f
	ld d,$cf		; $6690
	ldi a,(hl)		; $6692
	ld c,a			; $6693
_label_04_282:
	ldi a,(hl)		; $6694
	cp $ff			; $6695
	ret z			; $6697
	ld e,a			; $6698
	ld a,c			; $6699
	ld (de),a		; $669a
	jr _label_04_282		; $669b
	ldi a,(hl)		; $669d
	ld e,a			; $669e
	ldi a,(hl)		; $669f
	ld b,a			; $66a0
	ldi a,(hl)		; $66a1
	ld c,a			; $66a2
	ldi a,(hl)		; $66a3
	ld d,a			; $66a4
	ld h,$cf		; $66a5
_label_04_283:
	ld a,d			; $66a7
	ld l,e			; $66a8
	push bc			; $66a9
_label_04_284:
	ldi (hl),a		; $66aa
	dec c			; $66ab
	jr nz,_label_04_284	; $66ac
	ld a,e			; $66ae
	add $10			; $66af
	ld e,a			; $66b1
	pop bc			; $66b2
	dec b			; $66b3
	jr nz,_label_04_283	; $66b4
	ret			; $66b6
_label_04_285:
	ld a,(de)		; $66b7
	inc de			; $66b8
	push bc			; $66b9
_label_04_286:
	rrca			; $66ba
	jr nc,_label_04_287	; $66bb
	ld (hl),$a0		; $66bd
_label_04_287:
	inc l			; $66bf
	dec b			; $66c0
	jr nz,_label_04_286	; $66c1
	ld a,l			; $66c3
	add $08			; $66c4
	ld l,a			; $66c6
	pop bc			; $66c7
	dec c			; $66c8
	jr nz,_label_04_285	; $66c9
	ret			; $66cb


.include "code/seasons/roomGfxChanges.s"


;;
; @addr{6ae4}
generateW3VramTilesAndAttributes:
	ld a,$03		; $6ae4
	ld ($ff00+$70),a	; $6ae6
	ld hl,$cf00		; $6ae8
	ld de,$d800		; $6aeb
	ld c,$0b		; $6aee
_label_04_317:
	ld b,$10		; $6af0
_label_04_318:
	push bc			; $6af2
	ldi a,(hl)		; $6af3
	push hl			; $6af4
	call setHlToTileMappingDataPlusATimes8		; $6af5
	push de			; $6af8
	call $6b16		; $6af9
	pop de			; $6afc
	set 2,d			; $6afd
	call $6b16		; $6aff
	res 2,d			; $6b02
	ld a,e			; $6b04
	sub $1f			; $6b05
	ld e,a			; $6b07
	pop hl			; $6b08
	pop bc			; $6b09
	dec b			; $6b0a
	jr nz,_label_04_318	; $6b0b
	ld a,$20		; $6b0d
	call addAToDe		; $6b0f
	dec c			; $6b12
	jr nz,_label_04_317	; $6b13
	ret			; $6b15
	ldi a,(hl)		; $6b16
	ld (de),a		; $6b17
	inc e			; $6b18
	ldi a,(hl)		; $6b19
	ld (de),a		; $6b1a
	ld a,$1f		; $6b1b
	add e			; $6b1d
	ld e,a			; $6b1e
	ldi a,(hl)		; $6b1f
	ld (de),a		; $6b20
	inc e			; $6b21
	ldi a,(hl)		; $6b22
	ld (de),a		; $6b23
	ret			; $6b24
updateChangedTileQueue:
	ld a,($cd00)		; $6b25
	and $0e			; $6b28
	ret nz			; $6b2a
	ld b,$04		; $6b2b
_label_04_319:
	push bc			; $6b2d
	call $6b39		; $6b2e
	pop bc			; $6b31
	dec b			; $6b32
	jr nz,_label_04_319	; $6b33
	xor a			; $6b35
	ld ($ff00+$70),a	; $6b36
	ret			; $6b38
	ld a,($ccf5)		; $6b39
	ld b,a			; $6b3c
	ld a,($ccf6)		; $6b3d
	cp b			; $6b40
	ret z			; $6b41
	inc b			; $6b42
	ld a,b			; $6b43
	and $1f			; $6b44
	ld ($ccf5),a		; $6b46
	ld hl,$dac0		; $6b49
	rst_addDoubleIndex			; $6b4c
	ld a,$02		; $6b4d
	ld ($ff00+$70),a	; $6b4f
	ldi a,(hl)		; $6b51
	ld c,(hl)		; $6b52
	ld b,a			; $6b53
	ld a,c			; $6b54
	ldh (<hFF8C),a	; $6b55
	ld a,($ff00+$70)	; $6b57
	push af			; $6b59
	ld a,$03		; $6b5a
	ld ($ff00+$70),a	; $6b5c
	call $6b7c		; $6b5e
	ld a,b			; $6b61
	call setHlToTileMappingDataPlusATimes8		; $6b62
	push hl			; $6b65
	push de			; $6b66
	call $6b16		; $6b67
	pop de			; $6b6a
	ld a,$04		; $6b6b
	add d			; $6b6d
	ld d,a			; $6b6e
	call $6b16		; $6b6f
	ldh a,(<hFF8C)	; $6b72
	pop hl			; $6b74
	call $6c17		; $6b75
	pop af			; $6b78
	ld ($ff00+$70),a	; $6b79
	ret			; $6b7b
	ld a,c			; $6b7c
	swap a			; $6b7d
	and $0f			; $6b7f
	ld hl,$6b90		; $6b81
	rst_addDoubleIndex			; $6b84
	ldi a,(hl)		; $6b85
	ld h,(hl)		; $6b86
	ld l,a			; $6b87
	ld a,c			; $6b88
	and $0f			; $6b89
	add a			; $6b8b
	rst_addAToHl			; $6b8c
	ld e,l			; $6b8d
	ld d,h			; $6b8e
	ret			; $6b8f
	nop			; $6b90
	ret c			; $6b91
	ld b,b			; $6b92
	ret c			; $6b93
	add b			; $6b94
	ret c			; $6b95
	ret nz			; $6b96
	ret c			; $6b97
	nop			; $6b98
	reti			; $6b99
	ld b,b			; $6b9a
	reti			; $6b9b
	add b			; $6b9c
	reti			; $6b9d
	ret nz			; $6b9e
	reti			; $6b9f
	nop			; $6ba0
	jp c,$da40		; $6ba1
	add b			; $6ba4
	.db $da ; $6ba5
setInterleavedTile_body:
	ld ($ff00+$8b),a ; $6ba6
	ld a,($ff00+$70)	; $6ba8
	push af			; $6baa
	ld a,$03		; $6bab
	ld ($ff00+$70),a	; $6bad
	ldh a,(<hFF8F)	; $6baf
	call setHlToTileMappingDataPlusATimes8		; $6bb1
	ld de,$cec8		; $6bb4
	ld b,$08		; $6bb7
_label_04_320:
	ldi a,(hl)		; $6bb9
	ld (de),a		; $6bba
	inc de			; $6bbb
	dec b			; $6bbc
	jr nz,_label_04_320	; $6bbd
	ldh a,(<hFF8E)	; $6bbf
	call setHlToTileMappingDataPlusATimes8		; $6bc1
	ld de,$cec8		; $6bc4
	ldh a,(<hFF8B)	; $6bc7
	bit 0,a			; $6bc9
	jr nz,_label_04_323	; $6bcb
	bit 1,a			; $6bcd
	jr nz,_label_04_321	; $6bcf
	inc hl			; $6bd1
	inc hl			; $6bd2
	call $6be6		; $6bd3
	jr _label_04_322		; $6bd6
_label_04_321:
	inc de			; $6bd8
	inc de			; $6bd9
	call $6be6		; $6bda
_label_04_322:
	inc hl			; $6bdd
	inc hl			; $6bde
	inc de			; $6bdf
	inc de			; $6be0
	call $6be6		; $6be1
	jr _label_04_326		; $6be4
	ldi a,(hl)		; $6be6
	ld (de),a		; $6be7
	inc de			; $6be8
	ldi a,(hl)		; $6be9
	ld (de),a		; $6bea
	inc de			; $6beb
	ret			; $6bec
_label_04_323:
	bit 1,a			; $6bed
	jr nz,_label_04_324	; $6bef
	inc de			; $6bf1
	call $6c02		; $6bf2
	jr _label_04_325		; $6bf5
_label_04_324:
	inc hl			; $6bf7
	call $6c02		; $6bf8
_label_04_325:
	inc hl			; $6bfb
	inc de			; $6bfc
	call $6c02		; $6bfd
	jr _label_04_326		; $6c00
	ldi a,(hl)		; $6c02
	ld (de),a		; $6c03
	inc de			; $6c04
	inc hl			; $6c05
	inc de			; $6c06
	ldi a,(hl)		; $6c07
	ld (de),a		; $6c08
	inc de			; $6c09
	ret			; $6c0a
_label_04_326:
	ldh a,(<hFF8C)	; $6c0b
	ld hl,$cec8		; $6c0d
	call $6c17		; $6c10
	pop af			; $6c13
	ld ($ff00+$70),a	; $6c14
	ret			; $6c16
	push hl			; $6c17
	call $6c47		; $6c18
	add $20			; $6c1b
	ld c,a			; $6c1d
	ldh a,(<hVBlankFunctionQueueTail)	; $6c1e
	ld l,a			; $6c20
	ld h,$c4		; $6c21
	ld a,(vblankCopyTileFunctionOffset)		; $6c23
	ldi (hl),a		; $6c26
	ld (hl),e		; $6c27
	inc l			; $6c28
	ld (hl),d		; $6c29
	inc l			; $6c2a
	ld e,l			; $6c2b
	ld d,h			; $6c2c
	pop hl			; $6c2d
	ld b,$02		; $6c2e
_label_04_327:
	call $6c40		; $6c30
	ld a,c			; $6c33
	ld (de),a		; $6c34
	inc e			; $6c35
	call $6c40		; $6c36
	dec b			; $6c39
	jr nz,_label_04_327	; $6c3a
	ld a,e			; $6c3c
	ldh (<hVBlankFunctionQueueTail),a	; $6c3d
	ret			; $6c3f
	ldi a,(hl)		; $6c40
	ld (de),a		; $6c41
	inc e			; $6c42
	ldi a,(hl)		; $6c43
	ld (de),a		; $6c44
	inc e			; $6c45
	ret			; $6c46
	ld e,a			; $6c47
	and $f0			; $6c48
	swap a			; $6c4a
	ld d,a			; $6c4c
	ld a,e			; $6c4d
	and $0f			; $6c4e
	add a			; $6c50
	ld e,a			; $6c51
	ld a,($cd09)		; $6c52
	swap a			; $6c55
	add a			; $6c57
	add e			; $6c58
	and $1f			; $6c59
	ld e,a			; $6c5b
	ld a,($cd08)		; $6c5c
	swap a			; $6c5f
	add d			; $6c61
	and $0f			; $6c62
	ld hl,vramBgMapTable		; $6c64
	rst_addDoubleIndex			; $6c67
	ldi a,(hl)		; $6c68
	add e			; $6c69
	ld e,a			; $6c6a
	ld d,(hl)		; $6c6b
	ret			; $6c6c
loadTilesetData_body:
	call seasonsFunc_04_6ce6		; $6c6d
	jr c,_label_04_328	; $6c70
	call $6d17		; $6c72
	jr c,_label_04_328	; $6c75
	ld a,($cc49)		; $6c77
	ld hl,$533c		; $6c7a
	rst_addDoubleIndex			; $6c7d
	ldi a,(hl)		; $6c7e
	ld h,(hl)		; $6c7f
	ld l,a			; $6c80
	ld a,($cc4c)		; $6c81
	rst_addAToHl			; $6c84
	ld a,(hl)		; $6c85
	and $80			; $6c86
	ldh (<hFF8B),a	; $6c88
	ld a,(hl)		; $6c8a
	and $7f			; $6c8b
	call multiplyABy8		; $6c8d
	ld hl,$4c84		; $6c90
	add hl,bc		; $6c93
	ld a,(hl)		; $6c94
	inc a			; $6c95
	jr nz,_label_04_328	; $6c96
	inc hl			; $6c98
	ldi a,(hl)		; $6c99
	ld h,(hl)		; $6c9a
	ld l,a			; $6c9b
	ld a,($cc4e)		; $6c9c
	call multiplyABy8		; $6c9f
	add hl,bc		; $6ca2
_label_04_328:
	ldi a,(hl)		; $6ca3
	ld e,a			; $6ca4
	and $0f			; $6ca5
	cp $0f			; $6ca7
	jr nz,_label_04_329	; $6ca9
	ld a,$ff		; $6cab
_label_04_329:
	ld ($cc55),a		; $6cad
	ld a,e			; $6cb0
	swap a			; $6cb1
	and $0f			; $6cb3
	ld ($cc4f),a		; $6cb5
	ldi a,(hl)		; $6cb8
	ld ($cc50),a		; $6cb9
	ld b,$06		; $6cbc
	ld de,$cd20		; $6cbe
_label_04_330:
	ldi a,(hl)		; $6cc1
	ld (de),a		; $6cc2
	inc e			; $6cc3
	dec b			; $6cc4
	jr nz,_label_04_330	; $6cc5
	ld e,$20		; $6cc7
	ld a,(de)		; $6cc9
	ld b,a			; $6cca
	ldh a,(<hFF8B)	; $6ccb
	or b			; $6ccd
	ld (de),a		; $6cce
	ld a,($cc49)		; $6ccf
	or a			; $6cd2
	ret nz			; $6cd3
	ld a,($cc4c)		; $6cd4
	cp $96			; $6cd7
	ret nz			; $6cd9
	call getThisRoomFlags		; $6cda
	and $80			; $6cdd
	ret nz			; $6cdf
	ld a,$20		; $6ce0
	ld ($cd20),a		; $6ce2
	ret			; $6ce5

seasonsFunc_04_6ce6:
	ld a,GLOBALFLAG_S_15		; $6ce6
	call checkGlobalFlag		; $6ce8
	ret z			; $6ceb

	call seasonsFunc_04_6cff		; $6cec
	ret nc			; $6cef

	ld a,(wRoomStateModifier)		; $6cf0
	call multiplyABy8		; $6cf3
	ld hl,seasonsFunc_04_6ce6Seasons		; $6cf6
	add hl,bc		; $6cf9
--
	xor a			; $6cfa
	ldh (<hFF8B),a	; $6cfb
	scf			; $6cfd
	ret			; $6cfe

seasonsFunc_04_6cff:
	ld a,(wActiveGroup)		; $6cff
	or a			; $6d02
	ret nz			; $6d03
	ld a,(wActiveRoom)		; $6d04
	cp $14			; $6d07
	jr c,+			; $6d09
	sub $04			; $6d0b
	cp $30			; $6d0d
	ret nc			; $6d0f
	and $0f			; $6d10
	cp $04			; $6d12
	ret			; $6d14
+
	xor a			; $6d15
	ret			; $6d16

getMoblinKeepSeasons:
	ld a,(wActiveGroup)		; $6d17
	or a			; $6d1a
	ret nz			; $6d1b

	call getMoblinKeepScreenIndex		; $6d1c
	ret nc			; $6d1f

	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED		; $6d20
	call checkGlobalFlag		; $6d22
	ret z			; $6d25

	ld a,(wAnimalCompanion)		; $6d26
	sub $0a			; $6d29
	and $03			; $6d2b
	call multiplyABy8		; $6d2d
	ld hl,moblinKeepSeasons		; $6d30
	add hl,bc		; $6d33
	jr --			; $6d34

;;
; @param[out]	b	5 if on 1st room of Moblin Keep, decreasing by 1 for subsequent rooms
; @param[out]	cflag	Set if active room is in Moblin keep
getMoblinKeepScreenIndex:
	ld a,(wActiveRoom)		; $6d36
	ld b,$05		; $6d39
	ld hl,moblinKeepRooms		; $6d3b
-
	cp (hl)			; $6d3e
	jr z,+			; $6d3f
	inc hl			; $6d41
	dec b			; $6d42
	jr nz,-			; $6d43
	xor a			; $6d45
	ret			; $6d46
+
	scf			; $6d47
	ret			; $6d48

moblinKeepRooms:
	.db $5b $5c $6b $6c $7b

	.include "build/data/warpData.s"


.BANK $05 SLOT 1
.ORG 0

 m_section_force "Bank_5" NAMESPACE bank5

.include "code/bank5.s"
.include "build/data/tileTypeMappings.s"
.include "build/data/cliffTilesTable.s"
.include "code/seasons/subrosiaDanceLink.s"

.ends

.BANK $06 SLOT 1
.ORG 0

 m_section_superfree "Bank_6" NAMESPACE bank6

	.include "code/interactableTiles.s"
	.include "code/specialObjectAnimationsAndDamage.s"
	.include "code/breakableTiles.s"

	.include "code/items/parentItemUsage.s"

	.include "code/items/shieldParent.s"
	.include "code/items/otherSwordsParent.s"
	.include "code/items/switchHookParent.s"
	.include "code/items/caneOfSomariaParent.s"
	.include "code/items/swordParent.s"
	.include "code/items/harpFluteParent.s"
	.include "code/items/seedsParent.s"
	.include "code/items/shovelParent.s"
	.include "code/items/boomerangParent.s"
	.include "code/items/bombsBraceletParent.s"
	.include "code/items/featherParent.s"
	.include "code/items/magnetGloveParent.s"

	.include "code/items/parentItemCommon.s"


_itemUsageParameterTable:
	.db $00 <wGameKeysPressed       ; ITEMID_NONE
	.db $05 <wGameKeysPressed       ; ITEMID_SHIELD
	.db $03 <wGameKeysJustPressed   ; ITEMID_PUNCH
	.db $23 <wGameKeysJustPressed   ; ITEMID_BOMB
	.db $00 <wGameKeysJustPressed   ; ITEMID_CANE_OF_SOMARIA
	.db $63 <wGameKeysJustPressed   ; ITEMID_SWORD
	.db $02 <wGameKeysJustPressed   ; ITEMID_BOOMERANG
	.db $33 <wGameKeysJustPressed   ; ITEMID_ROD_OF_SEASONS
	.db $53 <wGameKeysJustPressed   ; ITEMID_MAGNET_GLOVES
	.db $00 <wGameKeysJustPressed   ; ITEMID_SWITCH_HOOK_HELPER
	.db $00 <wGameKeysJustPressed   ; ITEMID_SWITCH_HOOK
	.db $00 <wGameKeysJustPressed   ; ITEMID_SWITCH_HOOK_CHAIN
	.db $73 <wGameKeysJustPressed   ; ITEMID_BIGGORON_SWORD
	.db $02 <wGameKeysJustPressed   ; ITEMID_BOMBCHUS
	.db $05 <wGameKeysJustPressed   ; ITEMID_FLUTE
	.db $00 <wGameKeysJustPressed   ; ITEMID_SHOOTER
	.db $00 <wGameKeysJustPressed   ; ITEMID_10
	.db $00 <wGameKeysJustPressed   ; ITEMID_HARP
	.db $00 <wGameKeysJustPressed   ; ITEMID_12
	.db $43 <wGameKeysJustPressed   ; ITEMID_SLINGSHOT
	.db $00 <wGameKeysJustPressed   ; ITEMID_14
	.db $13 <wGameKeysJustPressed   ; ITEMID_SHOVEL
	.db $13 <wGameKeysPressed       ; ITEMID_BRACELET
	.db $01 <wGameKeysJustPressed   ; ITEMID_FEATHER
	.db $00 <wGameKeysJustPressed   ; ITEMID_18
	.db $02 <wGameKeysJustPressed   ; ITEMID_SEED_SATCHEL
	.db $00 <wGameKeysJustPressed   ; ITEMID_DUST
	.db $00 <wGameKeysJustPressed   ; ITEMID_1b
	.db $00 <wGameKeysJustPressed   ; ITEMID_1c
	.db $00 <wGameKeysJustPressed   ; ITEMID_MINECART_COLLISION
	.db $03 <wGameKeysJustPressed   ; ITEMID_FOOLS_ORE
	.db $00 <wGameKeysJustPressed   ; ITEMID_1f


_linkItemAnimationTable:
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_NONE
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_SHIELD
	.db $d6  LINK_ANIM_MODE_21	; ITEMID_PUNCH
	.db $30  LINK_ANIM_MODE_LIFT	; ITEMID_BOMB
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_CANE_OF_SOMARIA
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_SWORD
	.db $b0  LINK_ANIM_MODE_21	; ITEMID_BOOMERANG
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_ROD_OF_SEASONS
	.db $60  LINK_ANIM_MODE_NONE	; ITEMID_MAGNET_GLOVES
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_HELPER
	.db $f6  LINK_ANIM_MODE_21	; ITEMID_SWITCH_HOOK
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_CHAIN
	.db $f6  LINK_ANIM_MODE_23	; ITEMID_BIGGORON_SWORD
	.db $30  LINK_ANIM_MODE_21	; ITEMID_BOMBCHUS
	.db $70  LINK_ANIM_MODE_FLUTE	; ITEMID_FLUTE
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SHOOTER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_10
	.db $70  LINK_ANIM_MODE_HARP_2	; ITEMID_HARP
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_12
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SLINGSHOT
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_14
	.db $b0  LINK_ANIM_MODE_DIG_2	; ITEMID_SHOVEL
	.db $40  LINK_ANIM_MODE_LIFT_3	; ITEMID_BRACELET
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_FEATHER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_18
	.db $a0  LINK_ANIM_MODE_21	; ITEMID_SEED_SATCHEL
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_DUST
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1b
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1c
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_MINECART_COLLISION
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_FOOLS_ORE
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1f

specialObjectCode_minecart:
	call $5727		; $5588
	ld e,$04		; $558b
	ld a,(de)		; $558d
	rst_jumpTable			; $558e
	sub e			; $558f
	ld d,l			; $5590
	cp a			; $5591
	ld d,l			; $5592
	ld a,$01		; $5593
	ld (de),a		; $5595
	ld hl,$41b5		; $5596
	ld e,$05		; $5599
	call interBankCall		; $559b
	ld h,d			; $559e
	ld l,$10		; $559f
	ld (hl),$28		; $55a1
	ld l,$08		; $55a3
	ld a,(hl)		; $55a5
	call specialObjectSetAnimation		; $55a6
	ld a,d			; $55a9
	ld ($cc48),a		; $55aa
	call setCameraFocusedObjectToLink		; $55ad
	call clearVar3fForParentItems		; $55b0
	call clearPegasusSeedCounter		; $55b3
	ld hl,$d00e		; $55b6
	xor a			; $55b9
	ldi (hl),a		; $55ba
	ldi (hl),a		; $55bb
	jp objectSetVisiblec2		; $55bc
	ld a,($c4ab)		; $55bf
	or a			; $55c2
	ret nz			; $55c3
	call retIfTextIsActive		; $55c4
	ld a,($cd00)		; $55c7
	and $0e			; $55ca
	ret nz			; $55cc
	ld a,($cca4)		; $55cd
	and $81			; $55d0
	ret nz			; $55d2
	ld hl,$d024		; $55d3
	res 7,(hl)		; $55d6
	xor a			; $55d8
	ld l,$2d		; $55d9
	ldi (hl),a		; $55db
	ld h,d			; $55dc
	ld l,$0b		; $55dd
	ldi a,(hl)		; $55df
	ld b,a			; $55e0
	and $0f			; $55e1
	cp $08			; $55e3
	jr nz,_label_06_159	; $55e5
	inc l			; $55e7
	ldi a,(hl)		; $55e8
	ld c,a			; $55e9
	and $0f			; $55ea
	cp $08			; $55ec
	jr nz,_label_06_159	; $55ee
	call $5656		; $55f0
	jr c,_label_06_161	; $55f3
	ld h,d			; $55f5
	ld l,$08		; $55f6
	ldi a,(hl)		; $55f8
	swap a			; $55f9
	rrca			; $55fb
	cp (hl)			; $55fc
	jr z,_label_06_159	; $55fd
	ldd (hl),a		; $55ff
	ld a,(hl)		; $5600
	call specialObjectSetAnimation		; $5601
_label_06_159:
	ld h,d			; $5604
	ld l,$35		; $5605
	dec (hl)		; $5607
	bit 7,(hl)		; $5608
	jr z,_label_06_160	; $560a
	ld (hl),$1a		; $560c
	ld a,$80		; $560e
	call playSound		; $5610
_label_06_160:
	call objectApplySpeed		; $5613
	jp specialObjectAnimate		; $5616
_label_06_161:
	ld e,$04		; $5619
	ld a,$02		; $561b
	ld (de),a		; $561d
	call clearVar3fForParentItems		; $561e
	ld a,$81		; $5621
	ld ($cc77),a		; $5623
	ld hl,$d009		; $5626
	ld e,$09		; $5629
	ld a,(de)		; $562b
	ld (hl),a		; $562c
	ld l,$0b		; $562d
	ld a,(hl)		; $562f
	add $06			; $5630
	ld (hl),a		; $5632
	ld l,$0f		; $5633
	ld (hl),$fa		; $5635
	ld l,$10		; $5637
	ld (hl),$14		; $5639
	ld l,$14		; $563b
	ld (hl),$40		; $563d
	inc l			; $563f
	ld (hl),$fe		; $5640
	ld l,$1a		; $5642
	set 6,(hl)		; $5644
	ld a,$d0		; $5646
	ld ($cc48),a		; $5648
	call setCameraFocusedObjectToLink		; $564b
	ld b,$16		; $564e
	call objectCreateInteractionWithSubid00		; $5650
	jp objectDelete_useActiveObjectType		; $5653
	call getTileAtPosition		; $5656
	ld e,a			; $5659
	ld c,l			; $565a
	ld h,d			; $565b
	ld l,$08		; $565c
	ld a,(hl)		; $565e
	swap a			; $565f
	ld hl,$56cd		; $5661
	rst_addAToHl			; $5664
_label_06_162:
	ldi a,(hl)		; $5665
	or a			; $5666
	jr z,_label_06_167	; $5667
	cp e			; $5669
	jr z,_label_06_163	; $566a
	ld a,$04		; $566c
	rst_addAToHl			; $566e
	jr _label_06_162		; $566f
_label_06_163:
	ldi a,(hl)		; $5671
	add c			; $5672
	ld c,a			; $5673
	ldh (<hFF8B),a	; $5674
	ld b,$ce		; $5676
	ld a,(bc)		; $5678
	cp $ff			; $5679
	ret z			; $567b
	ld b,$cf		; $567c
	ld a,(bc)		; $567e
	cp $5f			; $567f
	jr z,_label_06_165	; $5681
	ld c,a			; $5683
	ld b,$03		; $5684
_label_06_164:
	ldi a,(hl)		; $5686
	cp c			; $5687
	jr z,_label_06_166	; $5688
	dec b			; $568a
	jr nz,_label_06_164	; $568b
	jr _label_06_167		; $568d
_label_06_165:
	scf			; $568f
	ret			; $5690
_label_06_166:
	ld a,e			; $5691
	sub $59			; $5692
	cp $06			; $5694
	jr c,_label_06_168	; $5696
_label_06_167:
	ld a,$06		; $5698
_label_06_168:
	ld e,$08		; $569a
	rst_jumpTable			; $569c
	xor e			; $569d
	ld d,(hl)		; $569e
	xor e			; $569f
	ld d,(hl)		; $56a0
	or b			; $56a1
	ld d,(hl)		; $56a2
	or b			; $56a3
	ld d,(hl)		; $56a4
	or l			; $56a5
	ld d,(hl)		; $56a6
	cp h			; $56a7
	ld d,(hl)		; $56a8
	pop bc			; $56a9
	ld d,(hl)		; $56aa
	ld a,(de)		; $56ab
	xor $01			; $56ac
	ld (de),a		; $56ae
	ret			; $56af
	ld a,(de)		; $56b0
	xor $03			; $56b1
	ld (de),a		; $56b3
	ret			; $56b4
	ld a,(de)		; $56b5
	and $02			; $56b6
	or $01			; $56b8
	ld (de),a		; $56ba
	ret			; $56bb
	ld a,(de)		; $56bc
	and $02			; $56bd
	ld (de),a		; $56bf
	ret			; $56c0
	call $570d		; $56c1
	jr nc,_label_06_169	; $56c4
	xor a			; $56c6
	ret			; $56c7
_label_06_169:
	ld a,(de)		; $56c8
	xor $02			; $56c9
	ld (de),a		; $56cb
	ret			; $56cc
	ld e,(hl)		; $56cd
	ld a,($ff00+$5e)	; $56ce
	ld e,c			; $56d0
	ld e,h			; $56d1
	ld e,c			; $56d2
	ld bc,$5a5d		; $56d3
	ld e,h			; $56d6
	ld e,h			; $56d7
	rst $38			; $56d8
	ld e,l			; $56d9
	ld e,e			; $56da
	ld e,c			; $56db
	nop			; $56dc
	ld e,l			; $56dd
	ld bc,$5a5d		; $56de
	ld e,h			; $56e1
	ld e,d			; $56e2
	ld a,($ff00+$5e)	; $56e3
	ld e,c			; $56e5
	ld e,h			; $56e6
	ld e,h			; $56e7
	stop			; $56e8
	ld e,(hl)		; $56e9
	ld e,e			; $56ea
	ld e,d			; $56eb
	nop			; $56ec
	ld e,(hl)		; $56ed
	stop			; $56ee
	ld e,(hl)		; $56ef
	ld e,d			; $56f0
	ld e,e			; $56f1
	ld e,d			; $56f2
	rst $38			; $56f3
	ld e,l			; $56f4
	ld e,e			; $56f5
	ld e,c			; $56f6
	ld e,e			; $56f7
	ld bc,$5a5d		; $56f8
	ld e,h			; $56fb
	nop			; $56fc
	ld e,l			; $56fd
	rst $38			; $56fe
	ld e,l			; $56ff
	ld e,e			; $5700
	ld e,c			; $5701
	ld e,e			; $5702
	ld a,($ff00+$5e)	; $5703
	ld e,h			; $5705
	ld e,c			; $5706
	ld e,c			; $5707
	stop			; $5708
	ld e,(hl)		; $5709
	ld e,d			; $570a
	ld e,e			; $570b
	nop			; $570c
	ld a,c			; $570d
	sub $7c			; $570e
	cp $04			; $5710
	ret nc			; $5712
	add $0c			; $5713
	add a			; $5715
	ld b,a			; $5716
	call getFreeInteractionSlot		; $5717
	ret nz			; $571a
	ld (hl),$1e		; $571b
	ld l,$49		; $571d
	ld (hl),b		; $571f
	ld l,$4b		; $5720
	ldh a,(<hFF8B)	; $5722
	ld (hl),a		; $5724
	scf			; $5725
	ret			; $5726
	ld e,$36		; $5727
	ld a,(de)		; $5729
	or a			; $572a
	ret nz			; $572b
	call getFreeItemSlot		; $572c
	ret nz			; $572f
	ld e,$36		; $5730
	ld a,$01		; $5732
	ld (de),a		; $5734
	ldi (hl),a		; $5735
	ld (hl),$1d		; $5736
	ret			; $5738


	.include "data/seasons/specialObjectAnimationData.s"

specialObjectCode_companionCutscene:
	ld hl,$d101		; $69c9
	ld a,(hl)		; $69cc
	sub $0f			; $69cd
	rst_jumpTable			; $69cf
	ret c			; $69d0
	ld l,c			; $69d1
	ld a,(bc)		; $69d2
	ld l,h			; $69d3
	ld h,h			; $69d4
	ld l,e			; $69d5
.DB $f4				; $69d6
	ld l,h			; $69d7
	ld e,$04		; $69d8
	ld a,(de)		; $69da
	ld a,(de)		; $69db
	rst_jumpTable			; $69dc
	pop hl			; $69dd
	ld l,c			; $69de
	dec d			; $69df
	ld l,d			; $69e0
	call $6a07		; $69e1
	ld h,d			; $69e4
	ld l,$02		; $69e5
	ld a,(hl)		; $69e7
	or a			; $69e8
	jr z,_label_06_220	; $69e9
	ld l,$10		; $69eb
	ld (hl),$50		; $69ed
	ld l,$09		; $69ef
	ld (hl),$08		; $69f1
	ld bc,$fe00		; $69f3
	call objectSetSpeedZ		; $69f6
	ld a,$02		; $69f9
	jp specialObjectSetAnimation		; $69fb
_label_06_220:
	xor a			; $69fe
	ld ($cbb5),a		; $69ff
	ld a,$1e		; $6a02
	jp specialObjectSetAnimation		; $6a04
	ld a,$01		; $6a07
_label_06_221:
	ld (de),a		; $6a09
	ld hl,$41b5		; $6a0a
	ld e,$05		; $6a0d
	call interBankCall		; $6a0f
	jp objectSetVisiblec0		; $6a12
	ld e,$02		; $6a15
	ld a,(de)		; $6a17
	rst_jumpTable			; $6a18
	dec e			; $6a19
	ld l,d			; $6a1a
	ld h,l			; $6a1b
	ld l,d			; $6a1c
	ld e,$05		; $6a1d
	ld a,(de)		; $6a1f
	rst_jumpTable			; $6a20
	dec h			; $6a21
	ld l,d			; $6a22
	ld b,h			; $6a23
	ld l,d			; $6a24
	call specialObjectAnimate		; $6a25
	ld h,d			; $6a28
	ld l,$21		; $6a29
	ld a,(hl)		; $6a2b
	or a			; $6a2c
	jr z,_label_06_222	; $6a2d
	ld a,$01		; $6a2f
	ld ($cbb5),a		; $6a31
	ld l,$05		; $6a34
	inc (hl)		; $6a36
_label_06_222:
	ld c,$20		; $6a37
	call objectUpdateSpeedZ_paramC		; $6a39
	ret nz			; $6a3c
	ld h,d			; $6a3d
	ld bc,$ff20		; $6a3e
	jp objectSetSpeedZ		; $6a41
	call specialObjectAnimate		; $6a44
	ld h,d			; $6a47
	ld l,$21		; $6a48
	ld a,(hl)		; $6a4a
	or a			; $6a4b
	ret z			; $6a4c
	ld (hl),$00		; $6a4d
	inc a			; $6a4f
	jr z,_label_06_223	; $6a50
	call getFreeInteractionSlot		; $6a52
	ret nz			; $6a55
	ld (hl),$07		; $6a56
	ld bc,$f812		; $6a58
	jp objectCopyPositionWithOffset		; $6a5b
_label_06_223:
	ld l,$05		; $6a5e
	ld (hl),$00		; $6a60
	jp $69fe		; $6a62
	ld e,$05		; $6a65
	ld a,(de)		; $6a67
	rst_jumpTable			; $6a68
	ld a,a			; $6a69
	ld l,d			; $6a6a
	add d			; $6a6b
	ld l,d			; $6a6c
	or h			; $6a6d
	ld l,d			; $6a6e
	cp l			; $6a6f
	ld l,d			; $6a70
	jp z,$dd6a		; $6a71
	ld l,d			; $6a74
	ld ($126a),a		; $6a75
	ld l,e			; $6a78
	inc h			; $6a79
	ld l,e			; $6a7a
	add hl,sp		; $6a7b
	ld l,e			; $6a7c
	ld e,d			; $6a7d
	ld l,e			; $6a7e
	ld l,$05		; $6a7f
	inc (hl)		; $6a81
	call objectApplySpeed		; $6a82
	ld e,$0d		; $6a85
	ld a,(de)		; $6a87
	bit 7,a			; $6a88
	jr nz,_label_06_224	; $6a8a
	ld hl,$d00d		; $6a8c
	ld b,(hl)		; $6a8f
	add $18			; $6a90
	cp b			; $6a92
	jr c,_label_06_224	; $6a93
	call itemIncState2		; $6a95
	inc (hl)		; $6a98
	inc l			; $6a99
	ld (hl),$3c		; $6a9a
	ld l,$0e		; $6a9c
	xor a			; $6a9e
	ldi (hl),a		; $6a9f
	ld (hl),a		; $6aa0
	jp specialObjectAnimate		; $6aa1
_label_06_224:
	ld c,$40		; $6aa4
	call objectUpdateSpeedZ_paramC		; $6aa6
	ret nz			; $6aa9
	call itemIncState2		; $6aaa
	ld l,$06		; $6aad
	ld (hl),$08		; $6aaf
	jp specialObjectAnimate		; $6ab1
	call itemDecCounter1		; $6ab4
	ret nz			; $6ab7
	dec l			; $6ab8
	dec (hl)		; $6ab9
	jp $69f3		; $6aba
	call itemDecCounter1		; $6abd
	ret nz			; $6ac0
	ld (hl),$5a		; $6ac1
	dec l			; $6ac3
	inc (hl)		; $6ac4
	ld a,$14		; $6ac5
	jp specialObjectSetAnimation		; $6ac7
	call specialObjectAnimate		; $6aca
	call itemDecCounter1		; $6acd
	ret nz			; $6ad0
	ld (hl),$0c		; $6ad1
	dec l			; $6ad3
	inc (hl)		; $6ad4
	ld a,$1f		; $6ad5
	call specialObjectSetAnimation		; $6ad7
	jp $6a52		; $6ada
	call itemDecCounter1		; $6add
	ret nz			; $6ae0
	ld (hl),$3c		; $6ae1
	dec l			; $6ae3
	inc (hl)		; $6ae4
	ld a,$1e		; $6ae5
	jp specialObjectSetAnimation		; $6ae7
	call itemDecCounter1		; $6aea
	ret nz			; $6aed
	ld (hl),$1e		; $6aee
	dec l			; $6af0
	inc (hl)		; $6af1
	ld hl,$c6c5		; $6af2
	ld (hl),$ff		; $6af5
	ld a,$81		; $6af7
	ld ($cc77),a		; $6af9
	ld hl,$d010		; $6afc
	ld (hl),$14		; $6aff
	ld l,$14		; $6b01
	ld (hl),$00		; $6b03
	inc l			; $6b05
	ld (hl),$fe		; $6b06
	ld a,$18		; $6b08
	ld ($d009),a		; $6b0a
	ld a,$53		; $6b0d
	jp playSound		; $6b0f
	call itemDecCounter1		; $6b12
	ret nz			; $6b15
	ld (hl),$14		; $6b16
	dec l			; $6b18
	inc (hl)		; $6b19
	xor a			; $6b1a
	ld hl,$d01a		; $6b1b
	ld (hl),a		; $6b1e
	inc a			; $6b1f
	ld ($cca4),a		; $6b20
	ret			; $6b23
	call itemDecCounter1		; $6b24
	ret nz			; $6b27
	dec l			; $6b28
	inc (hl)		; $6b29
	ld l,$09		; $6b2a
	ld (hl),$18		; $6b2c
	ld a,$1c		; $6b2e
	call specialObjectSetAnimation		; $6b30
	ld bc,$fe00		; $6b33
	jp objectSetSpeedZ		; $6b36
	call objectApplySpeed		; $6b39
	ld e,$0d		; $6b3c
	ld a,(de)		; $6b3e
	sub $10			; $6b3f
	rlca			; $6b41
	jr nc,_label_06_225	; $6b42
	ld hl,$cfdf		; $6b44
	ld (hl),$01		; $6b47
	ret			; $6b49
_label_06_225:
	ld c,$40		; $6b4a
	call objectUpdateSpeedZ_paramC		; $6b4c
	ret nz			; $6b4f
	call itemIncState2		; $6b50
	ld l,$06		; $6b53
	ld (hl),$08		; $6b55
	jp specialObjectAnimate		; $6b57
	call itemDecCounter1		; $6b5a
	ret nz			; $6b5d
	ld l,$05		; $6b5e
	dec (hl)		; $6b60
	jp $6b2e		; $6b61
	ld e,$04		; $6b64
	ld a,(de)		; $6b66
	rst_jumpTable			; $6b67
	ld l,h			; $6b68
	ld l,e			; $6b69
	sub (hl)		; $6b6a
	ld l,e			; $6b6b
	call $6a07		; $6b6c
	ld h,d			; $6b6f
	ld l,$06		; $6b70
	ld (hl),$5a		; $6b72
	ld l,$10		; $6b74
	ld (hl),$37		; $6b76
	ld l,$36		; $6b78
	ld (hl),$05		; $6b7a
	ld l,$09		; $6b7c
	ld (hl),$10		; $6b7e
	ld l,$0e		; $6b80
	ld (hl),$ff		; $6b82
	inc l			; $6b84
	ld (hl),$e0		; $6b85
	call getFreeInteractionSlot		; $6b87
	jr nz,_label_06_226	; $6b8a
	ld (hl),$c0		; $6b8c
	ld l,$57		; $6b8e
	ld (hl),d		; $6b90
_label_06_226:
	ld a,$07		; $6b91
	jp specialObjectSetAnimation		; $6b93
	ld e,$05		; $6b96
	ld a,(de)		; $6b98
	or a			; $6b99
	jr z,_label_06_227	; $6b9a
	call specialObjectAnimate		; $6b9c
	call objectApplySpeed		; $6b9f
_label_06_227:
	ld e,$05		; $6ba2
	ld a,(de)		; $6ba4
	rst_jumpTable			; $6ba5
	or b			; $6ba6
	ld l,e			; $6ba7
	cp d			; $6ba8
	ld l,e			; $6ba9
	add $6b			; $6baa
	sbc $6b			; $6bac
	xor $6b			; $6bae
	call itemDecCounter1		; $6bb0
	ret nz			; $6bb3
	ld (hl),$48		; $6bb4
	ld l,$05		; $6bb6
	inc (hl)		; $6bb8
	ret			; $6bb9
	call itemDecCounter1		; $6bba
	ret nz			; $6bbd
	ld (hl),$06		; $6bbe
	ld l,$05		; $6bc0
	inc (hl)		; $6bc2
	jp $6d89		; $6bc3
	ld h,d			; $6bc6
	ld l,$09		; $6bc7
	ld a,(hl)		; $6bc9
	cp $10			; $6bca
	jr z,_label_06_228	; $6bcc
	ld l,$05		; $6bce
	inc (hl)		; $6bd0
	ret			; $6bd1
_label_06_228:
	ld l,$06		; $6bd2
	dec (hl)		; $6bd4
	ret nz			; $6bd5
	call $6da0		; $6bd6
	ld (hl),$06		; $6bd9
	jp $6d89		; $6bdb
	ld h,d			; $6bde
	ld l,$09		; $6bdf
	ld a,(hl)		; $6be1
	cp $10			; $6be2
	jr nz,_label_06_228	; $6be4
	ld l,$05		; $6be6
	inc (hl)		; $6be8
	ld a,$07		; $6be9
	jp specialObjectSetAnimation		; $6beb
	ld e,$0b		; $6bee
	ld a,(de)		; $6bf0
	cp $b0			; $6bf1
	ret c			; $6bf3
	ld hl,$d101		; $6bf4
	ld b,$3f		; $6bf7
	call clearMemory		; $6bf9
	ld hl,$d101		; $6bfc
	ld (hl),$10		; $6bff
	ld l,$0b		; $6c01
	ld (hl),$e8		; $6c03
	inc l			; $6c05
	inc l			; $6c06
	ld (hl),$28		; $6c07
	ret			; $6c09
	ld e,$04		; $6c0a
	ld a,(de)		; $6c0c
	rst_jumpTable			; $6c0d
	ld (de),a		; $6c0e
	ld l,h			; $6c0f
	ld h,$6c		; $6c10
	call $6a07		; $6c12
	ld h,d			; $6c15
	ld l,$10		; $6c16
	ld (hl),$28		; $6c18
	ld l,$0e		; $6c1a
	ld (hl),$e0		; $6c1c
	inc l			; $6c1e
	ld (hl),$ff		; $6c1f
	ld a,$19		; $6c21
	jp specialObjectSetAnimation		; $6c23
	ld e,$05		; $6c26
	ld a,(de)		; $6c28
	rst_jumpTable			; $6c29
	jr c,$6c		; $6c2a
	ld h,h			; $6c2c
	ld l,h			; $6c2d
	add a			; $6c2e
	ld l,h			; $6c2f
	sub a			; $6c30
	ld l,h			; $6c31
	and e			; $6c32
	ld l,h			; $6c33
	cp d			; $6c34
	ld l,h			; $6c35
	add $6c			; $6c36
	ld h,d			; $6c38
	ld l,$05		; $6c39
	inc (hl)		; $6c3b
	ld l,$07		; $6c3c
	ld a,(hl)		; $6c3e
	cp $02			; $6c3f
	jr nz,_label_06_229	; $6c41
	push af			; $6c43
	ld a,$1a		; $6c44
	call specialObjectSetAnimation		; $6c46
	pop af			; $6c49
_label_06_229:
	ld b,a			; $6c4a
	add a			; $6c4b
	add b			; $6c4c
	ld hl,$6c5b		; $6c4d
	rst_addAToHl			; $6c50
	ldi a,(hl)		; $6c51
	ld e,$09		; $6c52
	ld (de),a		; $6c54
	ld c,(hl)		; $6c55
	inc hl			; $6c56
	ld b,(hl)		; $6c57
	jp objectSetSpeedZ		; $6c58
	inc c			; $6c5b
	ld b,b			; $6c5c
.DB $fd				; $6c5d
	inc c			; $6c5e
	and b			; $6c5f
.DB $fd				; $6c60
	inc de			; $6c61
	add b			; $6c62
	cp $cd			; $6c63
	ld (hl),$2a		; $6c65
	call objectApplySpeed		; $6c67
	ld c,$18		; $6c6a
	call objectUpdateSpeedZ_paramC		; $6c6c
	ret nz			; $6c6f
	ld h,d			; $6c70
	ld l,$07		; $6c71
	inc (hl)		; $6c73
	ld a,(hl)		; $6c74
	ld l,$05		; $6c75
	cp $03			; $6c77
	jr z,_label_06_230	; $6c79
	dec (hl)		; $6c7b
	ld l,$06		; $6c7c
	ld (hl),$08		; $6c7e
	ret			; $6c80
_label_06_230:
	inc (hl)		; $6c81
	ld l,$06		; $6c82
	ld (hl),$06		; $6c84
	ret			; $6c86
	call itemDecCounter1		; $6c87
	ret nz			; $6c8a
	ld l,$05		; $6c8b
	inc (hl)		; $6c8d
	ld l,$06		; $6c8e
	ld (hl),$14		; $6c90
	ld a,$27		; $6c92
	jp specialObjectSetAnimation		; $6c94
	call itemDecCounter1		; $6c97
	ret nz			; $6c9a
	ld l,$05		; $6c9b
	inc (hl)		; $6c9d
	ld l,$06		; $6c9e
	ld (hl),$78		; $6ca0
	ret			; $6ca2
	call specialObjectAnimate		; $6ca3
	call itemDecCounter1		; $6ca6
	ret nz			; $6ca9
	ld l,$05		; $6caa
	inc (hl)		; $6cac
	ld l,$06		; $6cad
	ld (hl),$3c		; $6caf
	ld l,$09		; $6cb1
	ld (hl),$0b		; $6cb3
	ld l,$10		; $6cb5
	ld (hl),$14		; $6cb7
	ret			; $6cb9
	call itemDecCounter1		; $6cba
	ret nz			; $6cbd
	ld l,$05		; $6cbe
	inc (hl)		; $6cc0
	ld a,$26		; $6cc1
	jp specialObjectSetAnimation		; $6cc3
	call specialObjectAnimate		; $6cc6
	call objectApplySpeed		; $6cc9
	ld e,$0d		; $6ccc
	ld a,(de)		; $6cce
	cp $78			; $6ccf
	jr nz,_label_06_231	; $6cd1
	ld a,$05		; $6cd3
	jp specialObjectSetAnimation		; $6cd5
_label_06_231:
	cp $b0			; $6cd8
	ret c			; $6cda
	ld hl,$d101		; $6cdb
	ld b,$3f		; $6cde
	call clearMemory		; $6ce0
	ld hl,$d101		; $6ce3
	ld (hl),$0f		; $6ce6
	inc l			; $6ce8
	ld (hl),$01		; $6ce9
	ld l,$0b		; $6ceb
	ld (hl),$48		; $6ced
	inc l			; $6cef
	inc l			; $6cf0
	ld (hl),$d8		; $6cf1
	ret			; $6cf3
	ld e,$04		; $6cf4
	ld a,(de)		; $6cf6
	ld a,(de)		; $6cf7
	rst_jumpTable			; $6cf8
.DB $fd				; $6cf9
	ld l,h			; $6cfa
	inc h			; $6cfb
	ld l,l			; $6cfc
	call $6a07		; $6cfd
	ld h,d			; $6d00
	ld l,$10		; $6d01
	ld (hl),$32		; $6d03
	ld l,$36		; $6d05
	ld (hl),$04		; $6d07
	ld l,$02		; $6d09
	ld a,(hl)		; $6d0b
	or a			; $6d0c
	ld a,$f0		; $6d0d
	jr z,_label_06_232	; $6d0f
	ld a,d			; $6d11
	ld ($cc48),a		; $6d12
	ld a,$d0		; $6d15
_label_06_232:
	ld l,$0f		; $6d17
	ld (hl),a		; $6d19
	ld l,$09		; $6d1a
	ld (hl),$18		; $6d1c
	ld l,$02		; $6d1e
	ld a,(hl)		; $6d20
	jp $6d78		; $6d21
	ld e,$02		; $6d24
	ld a,(de)		; $6d26
	rst_jumpTable			; $6d27
	ld d,d			; $6d28
	ld l,l			; $6d29
	inc l			; $6d2a
	ld l,l			; $6d2b
	ld e,$05		; $6d2c
	ld a,(de)		; $6d2e
	rst_jumpTable			; $6d2f
	ld (hl),$6d		; $6d30
	ld h,d			; $6d32
	ld l,l			; $6d33
	ld (hl),a		; $6d34
	ld l,l			; $6d35
	ld a,($cfc0)		; $6d36
	or a			; $6d39
	jr z,_label_06_233	; $6d3a
	call itemIncState2		; $6d3c
	ld bc,$ff00		; $6d3f
	call objectSetSpeedZ		; $6d42
	ld l,$09		; $6d45
	ld (hl),$0e		; $6d47
	ld l,$10		; $6d49
	ld (hl),$14		; $6d4b
	ld a,$1b		; $6d4d
	jp specialObjectSetAnimation		; $6d4f
_label_06_233:
	ld h,d			; $6d52
	ld l,$02		; $6d53
	ld a,(hl)		; $6d55
	ld l,$06		; $6d56
	dec (hl)		; $6d58
	call z,$6d78		; $6d59
	call objectApplySpeed		; $6d5c
	jp specialObjectAnimate		; $6d5f
	call objectApplySpeed		; $6d62
	ld c,$20		; $6d65
	call objectUpdateSpeedZAndBounce		; $6d67
	jp nc,$6d74		; $6d6a
	call itemIncState2		; $6d6d
	ld l,$20		; $6d70
	ld (hl),$01		; $6d72
	jp specialObjectAnimate		; $6d74
	ret			; $6d77
	ld hl,$6da8		; $6d78
	rst_addDoubleIndex			; $6d7b
	ldi a,(hl)		; $6d7c
	ld h,(hl)		; $6d7d
	ld l,a			; $6d7e
	call $6da0		; $6d7f
	ld b,a			; $6d82
	rst_addAToHl			; $6d83
	ld a,(hl)		; $6d84
	ld e,$06		; $6d85
	ld (de),a		; $6d87
	ld a,b			; $6d88
	sub $04			; $6d89
	and $07			; $6d8b
	ret nz			; $6d8d
	ld e,$09		; $6d8e
	call convertAngleDeToDirection		; $6d90
	dec a			; $6d93
	and $03			; $6d94
	ld h,d			; $6d96
	ld l,$08		; $6d97
	ld (hl),a		; $6d99
	ld l,$36		; $6d9a
	add (hl)		; $6d9c
	jp specialObjectSetAnimation		; $6d9d
	ld e,$09		; $6da0
	ld a,(de)		; $6da2
	dec a			; $6da3
	and $1f			; $6da4
	ld (de),a		; $6da6
	ret			; $6da7
	xor h			; $6da8
	ld l,l			; $6da9
	call z,$066d		; $6daa
	ld b,$06		; $6dad
	ld b,$07		; $6daf
	ld ($0a09),sp		; $6db1
	dec bc			; $6db4
	ld a,(bc)		; $6db5
	add hl,bc		; $6db6
	ld ($0607),sp		; $6db7
	ld b,$06		; $6dba
	ld b,$06		; $6dbc
	ld b,$06		; $6dbe
	rlca			; $6dc0
	ld ($0a09),sp		; $6dc1
	dec bc			; $6dc4
	ld a,(bc)		; $6dc5
	add hl,bc		; $6dc6
	ld ($0607),sp		; $6dc7
	ld b,$06		; $6dca
	ld (bc),a		; $6dcc
	ld (bc),a		; $6dcd
	ld (bc),a		; $6dce
	ld (bc),a		; $6dcf
	inc b			; $6dd0
	ld b,$08		; $6dd1
	ld a,(bc)		; $6dd3
	dec c			; $6dd4
	ld a,(bc)		; $6dd5
	ld ($0406),sp		; $6dd6
	ld (bc),a		; $6dd9
	ld (bc),a		; $6dda
	ld (bc),a		; $6ddb
	ld (bc),a		; $6ddc
	ld (bc),a		; $6ddd
	ld (bc),a		; $6dde
	ld (bc),a		; $6ddf
	inc b			; $6de0
	ld b,$08		; $6de1
	ld a,(bc)		; $6de3
	dec c			; $6de4
	ld a,(bc)		; $6de5
	ld ($0406),sp		; $6de6
	ld (bc),a		; $6de9
	ld (bc),a		; $6dea
	ld (bc),a		; $6deb
specialObjectCode_linkInCutscene:
	ld e,$02		; $6dec
	ld a,(de)		; $6dee
	rst_jumpTable			; $6def
	ld b,$6e		; $6df0
	ld de,$096f		; $6df2
	ld (hl),c		; $6df5
	or b			; $6df6
	ld (hl),c		; $6df7
	inc c			; $6df8
	ld (hl),d		; $6df9
	sbc a			; $6dfa
	ld (hl),d		; $6dfb
.DB $eb				; $6dfc
	ld (hl),d		; $6dfd
	ld (hl),e		; $6dfe
	ld (hl),e		; $6dff
	adc a			; $6e00
	ld (hl),e		; $6e01
	or l			; $6e02
	ld (hl),e		; $6e03
	ld d,d			; $6e04
	ld (hl),h		; $6e05
	ld e,$04		; $6e06
	ld a,(de)		; $6e08
	rst_jumpTable			; $6e09
	ld c,$6e		; $6e0a
	jr _label_06_236		; $6e0c
	call $7381		; $6e0e
	call objectSetVisible81		; $6e11
	xor a			; $6e14
	call specialObjectSetAnimation		; $6e15
	ld e,$05		; $6e18
	ld a,(de)		; $6e1a
	rst_jumpTable			; $6e1b
	ldi a,(hl)		; $6e1c
	ld l,(hl)		; $6e1d
	ld d,(hl)		; $6e1e
	ld l,(hl)		; $6e1f
	ld l,l			; $6e20
	ld l,(hl)		; $6e21
	add e			; $6e22
	ld l,(hl)		; $6e23
	sbc e			; $6e24
	ld l,(hl)		; $6e25
	xor c			; $6e26
	ld l,(hl)		; $6e27
	ld hl,sp+$6e		; $6e28
	ld a,($cc47)		; $6e2a
	rlca			; $6e2d
	ld a,$00		; $6e2e
	jp c,specialObjectSetAnimation		; $6e30
	ld h,d			; $6e33
	ld l,$0b		; $6e34
	ld a,($cc45)		; $6e36
	bit 7,a			; $6e39
	jr z,_label_06_234	; $6e3b
	inc (hl)		; $6e3d
_label_06_234:
	bit 6,a			; $6e3e
	jr z,_label_06_235	; $6e40
	dec (hl)		; $6e42
_label_06_235:
	ld a,(hl)		; $6e43
	cp $40			; $6e44
	jp nc,specialObjectAnimate		; $6e46
	ld a,$01		; $6e49
	ld ($cbb9),a		; $6e4b
	ld a,$77		; $6e4e
	call playSound		; $6e50
	jp itemIncState2		; $6e53
	ld a,($cbb9)		; $6e56
	cp $02			; $6e59
	ret nz			; $6e5b
	call itemIncState2		; $6e5c
	ld b,$04		; $6e5f
	call func_2d48		; $6e61
	ld a,b			; $6e64
	ld e,$06		; $6e65
	ld (de),a		; $6e67
	ld a,$04		; $6e68
	jp specialObjectSetAnimation		; $6e6a
	call itemDecCounter1		; $6e6d
	jp nz,specialObjectAnimate		; $6e70
	ld l,$10		; $6e73
	ld (hl),$05		; $6e75
	ld b,$05		; $6e77
	call func_2d48		; $6e79
_label_06_236:
	ld a,b			; $6e7c
	ld e,$06		; $6e7d
	ld (de),a		; $6e7f
	jp itemIncState2		; $6e80
	call itemDecCounter1		; $6e83
	jp nz,$6e95		; $6e86
	call itemIncState2		; $6e89
	ld b,$07		; $6e8c
	call func_2d48		; $6e8e
	ld a,b			; $6e91
	ld e,$06		; $6e92
	ld (de),a		; $6e94
	ld hl,$6ee0		; $6e95
	jp $6ec9		; $6e98
	call itemDecCounter1		; $6e9b
	jp nz,$6ec6		; $6e9e
	ld a,$03		; $6ea1
	ld ($cbb9),a		; $6ea3
	call itemIncState2		; $6ea6
	ld a,($cbb9)		; $6ea9
	cp $06			; $6eac
	jr nz,_label_06_238	; $6eae
	ld bc,$8406		; $6eb0
	call objectCreateInteraction		; $6eb3
	jr nz,_label_06_237	; $6eb6
	ld l,$56		; $6eb8
	ld a,$00		; $6eba
	ldi (hl),a		; $6ebc
	ld (hl),d		; $6ebd
_label_06_237:
	call itemIncState2		; $6ebe
	ld a,$05		; $6ec1
	jp specialObjectSetAnimation		; $6ec3
_label_06_238:
	ld hl,$6ee8		; $6ec6
	ld a,($cbb7)		; $6ec9
	ld b,a			; $6ecc
	and $07			; $6ecd
	jr nz,_label_06_239	; $6ecf
	ld a,b			; $6ed1
	and $38			; $6ed2
	swap a			; $6ed4
	rlca			; $6ed6
	rst_addAToHl			; $6ed7
	ld e,$0f		; $6ed8
	ld a,(de)		; $6eda
	add (hl)		; $6edb
	ld (de),a		; $6edc
_label_06_239:
	jp specialObjectAnimate		; $6edd
	rst $38			; $6ee0
	cp $fe			; $6ee1
	rst $38			; $6ee3
	nop			; $6ee4
	ld bc,$0001		; $6ee5
	rst $38			; $6ee8
	rst $38			; $6ee9
	rst $38			; $6eea
	nop			; $6eeb
	ld bc,$0101		; $6eec
	nop			; $6eef
	ld (bc),a		; $6ef0
	inc bc			; $6ef1
	inc b			; $6ef2
	inc bc			; $6ef3
	ld (bc),a		; $6ef4
	nop			; $6ef5
	rst $38			; $6ef6
	nop			; $6ef7
	ld e,$21		; $6ef8
	ld a,(de)		; $6efa
	inc a			; $6efb
	jr nz,_label_06_240	; $6efc
	ld a,$07		; $6efe
	ld ($cbb9),a		; $6f00
	ret			; $6f03
_label_06_240:
	call specialObjectAnimate		; $6f04
	ld a,($cbb7)		; $6f07
	rrca			; $6f0a
	jp nc,objectSetInvisible		; $6f0b
	jp objectSetVisible		; $6f0e
	ld e,$04		; $6f11
	ld a,(de)		; $6f13
	rst_jumpTable			; $6f14
	add hl,de		; $6f15
	ld l,a			; $6f16
	inc e			; $6f17
	ld l,a			; $6f18
	jp $7381		; $6f19
	ld e,$05		; $6f1c
	ld a,(de)		; $6f1e
	rst_jumpTable			; $6f1f
	ld c,h			; $6f20
	ld l,a			; $6f21
	ld a,e			; $6f22
	ld l,a			; $6f23
	adc l			; $6f24
	ld l,a			; $6f25
	and b			; $6f26
	ld l,a			; $6f27
	or (hl)			; $6f28
	ld l,a			; $6f29
	rst_jumpTable			; $6f2a
	ld l,a			; $6f2b
	call nc,$e16f		; $6f2c
	ld l,a			; $6f2f
	or $6f			; $6f30
	rst $38			; $6f32
	ld l,a			; $6f33
	inc de			; $6f34
	ld (hl),b		; $6f35
	rra			; $6f36
	ld (hl),b		; $6f37
	ldd (hl),a		; $6f38
	ld (hl),b		; $6f39
	ld h,c			; $6f3a
	ld (hl),b		; $6f3b
	halt			; $6f3c
	ld (hl),b		; $6f3d
	add d			; $6f3e
	ld (hl),b		; $6f3f
	and b			; $6f40
	ld (hl),b		; $6f41
	or a			; $6f42
	ld (hl),b		; $6f43
	ret z			; $6f44
	ld (hl),b		; $6f45
	push de			; $6f46
	ld (hl),b		; $6f47
.DB $f4				; $6f48
	ld (hl),b		; $6f49
	ld h,b			; $6f4a
	ld (hl),b		; $6f4b
	ld a,($cfd0)		; $6f4c
	or a			; $6f4f
	ret nz			; $6f50
	call itemIncState2		; $6f51
	ld l,$06		; $6f54
	ld (hl),$aa		; $6f56
	ld l,$0b		; $6f58
	ld a,$30		; $6f5a
	ldi (hl),a		; $6f5c
	inc l			; $6f5d
	ld a,$50		; $6f5e
	ld (hl),a		; $6f60
	ld l,$19		; $6f61
	ld h,(hl)		; $6f63
	ld l,$4b		; $6f64
	ld a,$30		; $6f66
	ldi (hl),a		; $6f68
	inc l			; $6f69
	ld a,$60		; $6f6a
	ld (hl),a		; $6f6c
	ld e,$08		; $6f6d
	xor a			; $6f6f
	ld (de),a		; $6f70
_label_06_241:
	ld a,$07		; $6f71
	call specialObjectSetAnimation		; $6f73
	ld a,$08		; $6f76
	jp $71a4		; $6f78
	call itemDecCounter1		; $6f7b
	jr nz,_label_06_242	; $6f7e
	ld (hl),$1e		; $6f80
	call itemIncState2		; $6f82
	jr _label_06_241		; $6f85
_label_06_242:
	call specialObjectAnimate		; $6f87
	jp $719a		; $6f8a
	call itemDecCounter1		; $6f8d
	ret nz			; $6f90
	ld (hl),$28		; $6f91
	ld a,$10		; $6f93
	call specialObjectSetAnimation		; $6f95
	ld a,$0d		; $6f98
	call $71a4		; $6f9a
	jp itemIncState2		; $6f9d
	call itemDecCounter1		; $6fa0
	ret nz			; $6fa3
	ld (hl),$3c		; $6fa4
	call itemIncState2		; $6fa6
	ld bc,$0c17		; $6fa9
	call checkIsLinkedGame		; $6fac
	jr z,_label_06_243	; $6faf
	ld c,$18		; $6fb1
_label_06_243:
	jp showText		; $6fb3
	ld a,($cba0)		; $6fb6
	or a			; $6fb9
	ret nz			; $6fba
	call itemDecCounter1		; $6fbb
	ret nz			; $6fbe
	ld (hl),$96		; $6fbf
	call $6f71		; $6fc1
	jp itemIncState2		; $6fc4
	call itemDecCounter1		; $6fc7
	jr nz,_label_06_242	; $6fca
	ld a,$02		; $6fcc
	ld ($cfd0),a		; $6fce
	jp itemIncState2		; $6fd1
	ld a,($cfd0)		; $6fd4
	cp $03			; $6fd7
	jr nz,_label_06_242	; $6fd9
	call $6f71		; $6fdb
	jp itemIncState2		; $6fde
	ld a,($cfd0)		; $6fe1
	cp $04			; $6fe4
	ret nz			; $6fe6
	call itemIncState2		; $6fe7
	ld l,$06		; $6fea
	ld (hl),$5a		; $6fec
	ld l,$08		; $6fee
	ld (hl),$03		; $6ff0
	xor a			; $6ff2
	jp specialObjectSetAnimation		; $6ff3
	call itemDecCounter1		; $6ff6
	ret nz			; $6ff9
	ld (hl),$12		; $6ffa
	jp itemIncState2		; $6ffc
	call itemDecCounter1		; $6fff
	jr nz,_label_06_244	; $7002
	ld (hl),$46		; $7004
	xor a			; $7006
	call specialObjectSetAnimation		; $7007
	jp itemIncState2		; $700a
_label_06_244:
	ld l,$0d		; $700d
	dec (hl)		; $700f
	jp specialObjectAnimate		; $7010
	call itemDecCounter1		; $7013
	ret nz			; $7016
	ld hl,$cfd0		; $7017
	ld (hl),$05		; $701a
	jp itemIncState2		; $701c
	ld hl,$cfd1		; $701f
	bit 6,(hl)		; $7022
	ret z			; $7024
	ld a,$14		; $7025
	ld e,$06		; $7027
	ld (de),a		; $7029
	ld e,$0d		; $702a
	ld a,(de)		; $702c
	dec e			; $702d
	ld (de),a		; $702e
	jp itemIncState2		; $702f
	call itemDecCounter1		; $7032
	jr nz,_label_06_245	; $7035
	ld h,d			; $7037
	ld l,$10		; $7038
	ld (hl),$50		; $703a
	ld l,$09		; $703c
	ld (hl),$0e		; $703e
	ld l,$0d		; $7040
	ld (hl),$40		; $7042
	ld a,$08		; $7044
	call specialObjectSetAnimation		; $7046
	ld bc,$fe80		; $7049
	call objectSetSpeedZ		; $704c
	jp itemIncState2		; $704f
_label_06_245:
	call getRandomNumber		; $7052
	and $0f			; $7055
	sub $08			; $7057
	ld b,a			; $7059
	ld e,$0c		; $705a
	ld a,(de)		; $705c
	inc e			; $705d
	add b			; $705e
	ld (de),a		; $705f
	ret			; $7060
	call objectApplySpeed		; $7061
	ld c,$20		; $7064
	call objectUpdateSpeedZ_paramC		; $7066
	ret nz			; $7069
	call itemIncState2		; $706a
	ld l,$06		; $706d
	ld (hl),$28		; $706f
	ld a,$14		; $7071
	jp specialObjectSetAnimation		; $7073
	call itemDecCounter1		; $7076
	ret nz			; $7079
	ld a,$07		; $707a
	ld ($cfd0),a		; $707c
	jp itemIncState2		; $707f
	ld a,($cfd0)		; $7082
	cp $09			; $7085
	ret nz			; $7087
	call itemIncState2		; $7088
	ld l,$14		; $708b
	ld (hl),$f0		; $708d
	inc l			; $708f
	ld (hl),$fd		; $7090
	ld l,$08		; $7092
	ld (hl),$02		; $7094
	ld a,$0a		; $7096
	call specialObjectSetAnimation		; $7098
	ld a,$53		; $709b
	jp playSound		; $709d
	call specialObjectAnimate		; $70a0
	ld c,$20		; $70a3
	call objectUpdateSpeedZ_paramC		; $70a5
	ret nz			; $70a8
	call itemIncState2		; $70a9
	ld l,$06		; $70ac
	ld (hl),$1e		; $70ae
	xor a			; $70b0
	ld l,$08		; $70b1
	ld (hl),a		; $70b3
	jp specialObjectSetAnimation		; $70b4
	call itemDecCounter1		; $70b7
	ret nz			; $70ba
	ld (hl),$19		; $70bb
	ld l,$10		; $70bd
	ld (hl),$50		; $70bf
	ld l,$09		; $70c1
	ld (hl),$02		; $70c3
	jp itemIncState2		; $70c5
	call specialObjectAnimate		; $70c8
	call objectApplySpeed		; $70cb
	call itemDecCounter1		; $70ce
	ret nz			; $70d1
	jp $7025		; $70d2
	call itemDecCounter1		; $70d5
	jp nz,$7052		; $70d8
	ld e,$10		; $70db
	ld a,$78		; $70dd
	ld (de),a		; $70df
	ld e,$09		; $70e0
	ld a,$19		; $70e2
	ld (de),a		; $70e4
	ld e,$08		; $70e5
	xor a			; $70e7
	ld (de),a		; $70e8
	ld ($cd00),a		; $70e9
	ld a,$08		; $70ec
	call specialObjectSetAnimation		; $70ee
	jp itemIncState2		; $70f1
	call specialObjectAnimate		; $70f4
	call objectApplySpeed		; $70f7
	call objectApplySpeed		; $70fa
	call objectCheckWithinScreenBoundary		; $70fd
	ret c			; $7100
	ld a,$0a		; $7101
	ld ($cfd0),a		; $7103
	jp itemIncState2		; $7106
	ld e,$04		; $7109
	ld a,(de)		; $710b
	rst_jumpTable			; $710c
	ld de,$1971		; $710d
	ld (hl),c		; $7110
	call $7381		; $7111
	ld a,$09		; $7114
	call specialObjectSetAnimation		; $7116
	ld e,$05		; $7119
	ld a,(de)		; $711b
	rst_jumpTable			; $711c
	dec h			; $711d
	ld (hl),c		; $711e
	ld c,h			; $711f
	ld (hl),c		; $7120
	ld e,b			; $7121
	ld (hl),c		; $7122
	ld l,l			; $7123
	ld (hl),c		; $7124
	ld hl,$cfd0		; $7125
	ld a,(hl)		; $7128
	cp $01			; $7129
	ret nz			; $712b
	call specialObjectAnimate		; $712c
	ld e,$21		; $712f
	ld a,(de)		; $7131
	inc a			; $7132
	ret nz			; $7133
	call itemIncState2		; $7134
	ld l,$14		; $7137
	ld (hl),$f0		; $7139
	inc l			; $713b
	ld (hl),$fd		; $713c
	ld l,$08		; $713e
	ld (hl),$02		; $7140
	ld a,$0a		; $7142
	call specialObjectSetAnimation		; $7144
	ld a,$53		; $7147
	call playSound		; $7149
	call $7178		; $714c
	ret nz			; $714f
	call itemIncState2		; $7150
	ld l,$06		; $7153
	ld (hl),$1e		; $7155
	ret			; $7157
	call itemDecCounter1		; $7158
	ret nz			; $715b
	ld hl,$cfd0		; $715c
	ld (hl),$02		; $715f
	call itemIncState2		; $7161
	ld l,$08		; $7164
	ld (hl),$03		; $7166
	ld a,$00		; $7168
	jp specialObjectSetAnimation		; $716a
	ld a,($cfd0)		; $716d
	cp $03			; $7170
	ret nz			; $7172
	ld a,$00		; $7173
	jp setLinkIDOverride		; $7175
	call specialObjectAnimate		; $7178
	ld c,$20		; $717b
	call objectUpdateSpeedZ_paramC		; $717d
	jr z,_label_06_246	; $7180
	ld h,d			; $7182
	ld l,$15		; $7183
	ld a,(hl)		; $7185
	bit 7,a			; $7186
	ret nz			; $7188
	cp $03			; $7189
	ret c			; $718b
	ld l,$14		; $718c
	xor a			; $718e
	ldi (hl),a		; $718f
	ld a,$03		; $7190
	ld (hl),a		; $7192
	or a			; $7193
	ret			; $7194
_label_06_246:
	ld a,$00		; $7195
	jp specialObjectSetAnimation		; $7197
	push de			; $719a
	ld e,$19		; $719b
	ld a,(de)		; $719d
	ld d,a			; $719e
	call interactionAnimate		; $719f
	pop de			; $71a2
	ret			; $71a3
	ld b,a			; $71a4
	push de			; $71a5
	ld e,$19		; $71a6
	ld a,(de)		; $71a8
	ld d,a			; $71a9
	ld a,b			; $71aa
	call interactionSetAnimation		; $71ab
	pop de			; $71ae
	ret			; $71af
	ld e,$04		; $71b0
	ld a,(de)		; $71b2
	rst_jumpTable			; $71b3
	cp b			; $71b4
	ld (hl),c		; $71b5
	call nz,$cd71		; $71b6
	add c			; $71b9
	ld (hl),e		; $71ba
	ld l,$06		; $71bb
	ld (hl),$a8		; $71bd
	ld a,$0c		; $71bf
	jp specialObjectSetAnimation		; $71c1
	ld e,$05		; $71c4
	ld a,(de)		; $71c6
	rst_jumpTable			; $71c7
	ret nc			; $71c8
	ld (hl),c		; $71c9
	and $71			; $71ca
.DB $f4				; $71cc
	ld (hl),c		; $71cd
	ld (bc),a		; $71ce
	ld (hl),d		; $71cf
	call itemDecCounter1		; $71d0
	jr nz,_label_06_247	; $71d3
	ld a,$80		; $71d5
	ld ($cfc0),a		; $71d7
	call itemIncState2		; $71da
	ld bc,$ff00		; $71dd
	call objectSetSpeedZ		; $71e0
_label_06_247:
	jp specialObjectAnimate		; $71e3
	ld c,$20		; $71e6
	call objectUpdateSpeedZ_paramC		; $71e8
	ret nz			; $71eb
	call itemIncState2		; $71ec
	ld l,$06		; $71ef
	ld (hl),$0a		; $71f1
	ret			; $71f3
	call itemDecCounter1		; $71f4
	ret nz			; $71f7
	ld (hl),$78		; $71f8
	call itemIncState2		; $71fa
	ld a,$0c		; $71fd
	jp specialObjectSetAnimation		; $71ff
	call itemDecCounter1		; $7202
	ret nz			; $7205
	ld a,$01		; $7206
	ld ($cfdf),a		; $7208
	ret			; $720b
	ld e,$04		; $720c
	ld a,(de)		; $720e
	rst_jumpTable			; $720f
	inc d			; $7210
	ld (hl),d		; $7211
	jr z,_label_06_248	; $7212
	call $7381		; $7214
	ld l,$09		; $7217
	ld (hl),$00		; $7219
	ld l,$10		; $721b
	ld (hl),$28		; $721d
	ld l,$06		; $721f
	ld (hl),$80		; $7221
	ld a,$00		; $7223
	jp specialObjectSetAnimation		; $7225
	ld e,$05		; $7228
	ld a,(de)		; $722a
	rst_jumpTable			; $722b
	jr c,$72		; $722c
	ld c,h			; $722e
	ld (hl),d		; $722f
	ld e,d			; $7230
	ld (hl),d		; $7231
	ld h,(hl)		; $7232
	ld (hl),d		; $7233
	ld a,(hl)		; $7234
	ld (hl),d		; $7235
	sub e			; $7236
	ld (hl),d		; $7237
	ld a,($c4ab)		; $7238
	or a			; $723b
	ret nz			; $723c
	call specialObjectAnimate		; $723d
	call objectApplySpeed		; $7240
	call itemDecCounter1		; $7243
	ret nz			; $7246
	ld (hl),$06		; $7247
	jp itemIncState2		; $7249
	call itemDecCounter1		; $724c
	ret nz			; $724f
	ld (hl),$78		; $7250
	call itemIncState2		; $7252
	ld a,$03		; $7255
	jp specialObjectSetAnimation		; $7257
	call itemDecCounter1		; $725a
	ret nz			; $725d
	ld hl,$cfc0		; $725e
	ld (hl),$01		; $7261
	jp itemIncState2		; $7263
	ld a,($cfc0)		; $7266
	cp $02			; $7269
	ret nz			; $726b
	call itemIncState2		; $726c
	ld l,$09		; $726f
	ld (hl),$10		; $7271
	ld bc,$ff00		; $7273
	call objectSetSpeedZ		; $7276
	ld a,$0d		; $7279
	jp specialObjectSetAnimation		; $727b
	call objectApplySpeed		; $727e
	ld c,$20		; $7281
	call objectUpdateSpeedZ_paramC		; $7283
_label_06_248:
	ret nz			; $7286
	call itemIncState2		; $7287
	ld l,$06		; $728a
	ld (hl),$78		; $728c
	ld l,$20		; $728e
	ld (hl),$01		; $7290
	ret			; $7292
	call itemDecCounter1		; $7293
	jp nz,specialObjectAnimate		; $7296
	ld hl,$cfdf		; $7299
	ld (hl),$01		; $729c
	ret			; $729e
	ld e,$04		; $729f
	ld a,(de)		; $72a1
	rst_jumpTable			; $72a2
	and a			; $72a3
	ld (hl),d		; $72a4
	or e			; $72a5
	ld (hl),d		; $72a6
	call $7381		; $72a7
	ld l,$06		; $72aa
	ld (hl),$f0		; $72ac
	ld a,$03		; $72ae
	jp specialObjectSetAnimation		; $72b0
	ld e,$05		; $72b3
	ld a,(de)		; $72b5
	rst_jumpTable			; $72b6
	cp e			; $72b7
	ld (hl),d		; $72b8
	pop hl			; $72b9
	ld (hl),d		; $72ba
	ld a,($c4ab)		; $72bb
	or a			; $72be
	ret nz			; $72bf
	call itemDecCounter1		; $72c0
	ret nz			; $72c3
	ld l,$06		; $72c4
	ld (hl),$3c		; $72c6
	call itemIncState2		; $72c8
	ld hl,$cfc0		; $72cb
	ld (hl),$01		; $72ce
	ld bc,$f804		; $72d0
	ld a,$ff		; $72d3
	call objectCreateExclamationMark		; $72d5
	ld l,$42		; $72d8
	ld (hl),$01		; $72da
	ld a,$0e		; $72dc
	jp specialObjectSetAnimation		; $72de
	call itemDecCounter1		; $72e1
	ret nz			; $72e4
	ld hl,$cfdf		; $72e5
	ld (hl),$01		; $72e8
	ret			; $72ea
	ld e,$04		; $72eb
	ld a,(de)		; $72ed
	rst_jumpTable			; $72ee
	di			; $72ef
	ld (hl),d		; $72f0
	rrca			; $72f1
	ld (hl),e		; $72f2
	call $7381		; $72f3
	call objectSetInvisible		; $72f6
	call $7305		; $72f9
	ld a,$0b		; $72fc
	jr nz,_label_06_249	; $72fe
	ld a,$0f		; $7300
_label_06_249:
	jp specialObjectSetAnimation		; $7302
	ld hl,$c680		; $7305
	ld a,$01		; $7308
	cp (hl)			; $730a
	ret z			; $730b
	inc l			; $730c
	cp (hl)			; $730d
	ret			; $730e
	ld e,$05		; $730f
	ld a,(de)		; $7311
	rst_jumpTable			; $7312
	dec de			; $7313
	ld (hl),e		; $7314
	daa			; $7315
	ld (hl),e		; $7316
	dec sp			; $7317
	ld (hl),e		; $7318
	ld h,e			; $7319
	ld (hl),e		; $731a
	ld a,($cfc0)		; $731b
	cp $01			; $731e
	ret nz			; $7320
	call itemIncState2		; $7321
	jp objectSetVisible		; $7324
	ld a,($cfc0)		; $7327
	cp $07			; $732a
	ret nz			; $732c
	call itemIncState2		; $732d
	call $7305		; $7330
	ld a,$10		; $7333
	jr nz,_label_06_250	; $7335
	inc a			; $7337
_label_06_250:
	jp specialObjectSetAnimation		; $7338
	ld a,($cfc0)		; $733b
	cp $08			; $733e
	ret nz			; $7340
	call itemIncState2		; $7341
	ld l,$06		; $7344
	ld (hl),$68		; $7346
	inc l			; $7348
	ld (hl),$01		; $7349
	ld b,$02		; $734b
_label_06_251:
	call getFreeInteractionSlot		; $734d
	jr nz,_label_06_252	; $7350
	ld (hl),$b7		; $7352
	inc l			; $7354
	ld a,b			; $7355
	dec a			; $7356
	ld (hl),a		; $7357
	call objectCopyPosition		; $7358
	dec b			; $735b
	jr nz,_label_06_251	; $735c
_label_06_252:
	ld a,$12		; $735e
	jp specialObjectSetAnimation		; $7360
	call specialObjectAnimate		; $7363
	ld h,d			; $7366
	ld l,$06		; $7367
	call decHlRef16WithCap		; $7369
	ret nz			; $736c
	ld hl,$cfc0		; $736d
	ld (hl),$09		; $7370
	ret			; $7372
	ld e,$04		; $7373
	ld a,(de)		; $7375
	rst_jumpTable			; $7376
	ld a,e			; $7377
	ld (hl),e		; $7378
	ld ($cd72),a		; $7379
	add c			; $737c
	ld (hl),e		; $737d
	jp $72d0		; $737e
	ld hl,$41b5		; $7381
	ld e,$05		; $7384
	call interBankCall		; $7386
	call objectSetVisiblec1		; $7389
	jp itemIncState		; $738c
	ld e,$04		; $738f
	ld a,(de)		; $7391
	rst_jumpTable			; $7392
	sub a			; $7393
	ld (hl),e		; $7394
	and e			; $7395
	ld (hl),e		; $7396
	call $7381		; $7397
	ld l,$10		; $739a
	ld (hl),$28		; $739c
	ld a,$00		; $739e
	call specialObjectSetAnimation		; $73a0
	call specialObjectAnimate		; $73a3
	call $74ee		; $73a6
	call $7520		; $73a9
	call $7501		; $73ac
	ret nc			; $73af
	ld a,$00		; $73b0
	jp setLinkIDOverride		; $73b2
	ld e,$04		; $73b5
	ld a,(de)		; $73b7
	rst_jumpTable			; $73b8
	cp l			; $73b9
	ld (hl),e		; $73ba
	jp z,$cd73		; $73bb
	add c			; $73be
	ld (hl),e		; $73bf
	push de			; $73c0
	call clearItems		; $73c1
	pop de			; $73c4
	ld a,$13		; $73c5
	jp specialObjectSetAnimation		; $73c7
	ld e,$05		; $73ca
	ld a,(de)		; $73cc
	rst_jumpTable			; $73cd
	call c,$f173		; $73ce
	ld (hl),e		; $73d1
.DB $fc				; $73d2
	ld (hl),e		; $73d3
	ld d,$74		; $73d4
	dec l			; $73d6
	ld (hl),h		; $73d7
	dec sp			; $73d8
	ld (hl),h		; $73d9
	ld d,c			; $73da
	ld (hl),h		; $73db
	ld a,($cfd1)		; $73dc
	or a			; $73df
	ret z			; $73e0
	call itemIncState2		; $73e1
	ld l,$06		; $73e4
	ld (hl),$28		; $73e6
	ld l,$10		; $73e8
	ld (hl),$05		; $73ea
	ld l,$09		; $73ec
	ld (hl),$10		; $73ee
	ret			; $73f0
	call itemDecCounter1		; $73f1
	jp nz,objectApplySpeed		; $73f4
	ld (hl),$19		; $73f7
	jp itemIncState2		; $73f9
	call itemDecCounter1		; $73fc
	ret nz			; $73ff
	call itemIncState2		; $7400
	ld l,$10		; $7403
	ld (hl),$78		; $7405
	ld l,$09		; $7407
	xor a			; $7409
	ld (hl),a		; $740a
	ld l,$0f		; $740b
	ld (hl),$fa		; $740d
_label_06_253:
	ld l,$20		; $740f
	ld (hl),$01		; $7411
	jp specialObjectAnimate		; $7413
	call objectApplySpeed		; $7416
	ld e,$0b		; $7419
	ld a,(de)		; $741b
	cp $10			; $741c
	ret nc			; $741e
	ld a,$82		; $741f
	call playSound		; $7421
	call itemIncState2		; $7424
	ld l,$06		; $7427
	ld (hl),$1e		; $7429
	jr _label_06_253		; $742b
	call itemDecCounter1		; $742d
	jr nz,_label_06_254	; $7430
	call itemIncState2		; $7432
	ld bc,$ff40		; $7435
	jp objectSetSpeedZ		; $7438
	ld c,$10		; $743b
	call objectUpdateSpeedZ_paramC		; $743d
	ret nz			; $7440
	call itemIncState2		; $7441
	jr _label_06_253		; $7444
_label_06_254:
	ld a,(wFrameCounter)		; $7446
	and $03			; $7449
	ret nz			; $744b
	ld a,$04		; $744c
	ld ($cd18),a		; $744e
	ret			; $7451
	ld e,$04		; $7452
	ld a,(de)		; $7454
	rst_jumpTable			; $7455
	ld e,d			; $7456
	ld (hl),h		; $7457
	add (hl)		; $7458
	ld (hl),h		; $7459
	call $7381		; $745a
	call objectSetVisible81		; $745d
	ld l,$06		; $7460
	ld (hl),$2c		; $7462
	inc hl			; $7464
	ld (hl),$01		; $7465
	ld l,$0b		; $7467
	ld (hl),$d0		; $7469
	ld l,$0d		; $746b
	ld (hl),$50		; $746d
	ld a,$08		; $746f
	call specialObjectSetAnimation		; $7471
	xor a			; $7474
	ld ($cbb9),a		; $7475
	ld bc,$8409		; $7478
	call objectCreateInteraction		; $747b
	jr nz,_label_06_255	; $747e
	ld l,$56		; $7480
	ld a,$00		; $7482
	ldi (hl),a		; $7484
	ld (hl),d		; $7485
_label_06_255:
	ld a,(wFrameCounter)		; $7486
	ld ($cbb7),a		; $7489
	ld e,$05		; $748c
	ld a,(de)		; $748e
	rst_jumpTable			; $748f
	sbc b			; $7490
	ld (hl),h		; $7491
	and a			; $7492
	ld (hl),h		; $7493
	or a			; $7494
	ld (hl),h		; $7495
	rst $8			; $7496
	ld (hl),h		; $7497
	call $74e8		; $7498
	ld hl,$d006		; $749b
	call decHlRef16WithCap		; $749e
	ret nz			; $74a1
	ld (hl),$3c		; $74a2
	jp itemIncState2		; $74a4
	call $74e8		; $74a7
	call itemDecCounter1		; $74aa
	ret nz			; $74ad
	call itemIncState2		; $74ae
	ld bc,$0c16		; $74b1
	jp showText		; $74b4
	ld hl,$6ee8		; $74b7
	call $6ec9		; $74ba
	ld a,($cba0)		; $74bd
	or a			; $74c0
	ret nz			; $74c1
	ld a,$06		; $74c2
	ld ($cbb9),a		; $74c4
	ld a,$91		; $74c7
	call playSound		; $74c9
	jp $6eb0		; $74cc
	ld e,$21		; $74cf
	ld a,(de)		; $74d1
	inc a			; $74d2
	jr nz,_label_06_256	; $74d3
	ld a,$07		; $74d5
	ld ($cbb9),a		; $74d7
	ret			; $74da
_label_06_256:
	call specialObjectAnimate		; $74db
	ld a,(wFrameCounter)		; $74de
	rrca			; $74e1
	jp nc,objectSetInvisible		; $74e2
	jp objectSetVisible		; $74e5
	ld hl,$6ef0		; $74e8
	jp $6ec9		; $74eb
	ld e,$03		; $74ee
	ld a,(de)		; $74f0
	ld hl,$751e		; $74f1
	rst_addDoubleIndex			; $74f4
	ld b,(hl)		; $74f5
	inc hl			; $74f6
	ld c,(hl)		; $74f7
	call objectGetRelativeAngle		; $74f8
	ld e,$09		; $74fb
	ld (de),a		; $74fd
	jp objectApplySpeed		; $74fe
	ld e,$03		; $7501
	ld a,(de)		; $7503
	ld bc,$751e		; $7504
	call addDoubleIndexToBc		; $7507
	ld h,d			; $750a
	ld l,$0b		; $750b
	ld a,(bc)		; $750d
	sub (hl)		; $750e
	add $01			; $750f
	cp $03			; $7511
	ret nc			; $7513
	inc bc			; $7514
	ld l,$0d		; $7515
	ld a,(bc)		; $7517
	sub (hl)		; $7518
	add $01			; $7519
	cp $03			; $751b
	ret			; $751d
	ld c,b			; $751e
	ld d,b			; $751f
	ld a,(wFrameCounter)		; $7520
	and $07			; $7523
	ret nz			; $7525
	ld e,$09		; $7526
	ld a,(de)		; $7528
	ld hl,$7532		; $7529
	rst_addAToHl			; $752c
	ld a,(hl)		; $752d
	ld e,$08		; $752e
	ld (de),a		; $7530
	ret			; $7531
	nop			; $7532
	nop			; $7533
	ld bc,$0101		; $7534
	ld bc,$0101		; $7537
	ld bc,$0101		; $753a
	ld bc,$0101		; $753d
	ld bc,$0202		; $7540
	ld (bc),a		; $7543
	inc bc			; $7544
	inc bc			; $7545
	inc bc			; $7546
	inc bc			; $7547
	inc bc			; $7548
	inc bc			; $7549
	inc bc			; $754a
	inc bc			; $754b
	inc bc			; $754c
	inc bc			; $754d
	inc bc			; $754e
	inc bc			; $754f
	inc bc			; $7550
	nop			; $7551

	.include "build/data/signText.s"

_breakableTileCollisionTable:
	.dw _breakableTileCollision0
	.dw _breakableTileCollision1
	.dw _breakableTileCollision2
	.dw _breakableTileCollision3
	.dw _breakableTileCollision4
	.dw _breakableTileCollision5

_breakableTileCollision0:
_breakableTileCollision2:
	.db $f8 $00
	.db $f2 $0d
	.db $c4 $01
	.db $c5 $02
	.db $c6 $03
	.db $c7 $04
	.db $e5 $05
	.db $d8 $06
	.db $c3 $06
	.db $c8 $07
	.db $c9 $08
	.db $c0 $09
	.db $c1 $0a
	.db $c2 $0b
	.db $e2 $0c
	.db $d9 $0e
	.db $da $0f
	.db $db $10
	.db $ca $11
	.db $cb $12
	.db $d7 $13
	.db $e3 $15
	.db $01 $14
	.db $04 $14
	.db $05 $14
	.db $06 $14
	.db $07 $14
	.db $08 $14
	.db $09 $14
	.db $0a $14
	.db $0b $14
	.db $0c $14
	.db $0d $14
	.db $0e $14
	.db $0f $14
	.db $11 $14
	.db $12 $14
	.db $13 $14
	.db $14 $14
	.db $15 $14
	.db $16 $14
	.db $17 $14
	.db $18 $14
	.db $19 $14
	.db $1a $14
	.db $1b $14
	.db $1c $14
	.db $1d $14
	.db $1e $14
	.db $4d $14
	.db $4e $14
	.db $5d $14
	.db $5e $14
	.db $5f $14
	.db $6d $14
	.db $6e $14
	.db $6f $14
	.db $af $14
	.db $bf $14
	.db $00
_breakableTileCollision1:
	.db $f8 $00
	.db $f9 $00
	.db $f2 $0d
	.db $e9 $09
	.db $01 $17
	.db $04 $17
	.db $05 $17
	.db $06 $17
	.db $07 $17
	.db $08 $17
	.db $09 $17
	.db $0a $17
	.db $0b $17
	.db $0c $17
	.db $0d $17
	.db $0e $17
	.db $0f $17
	.db $11 $17
	.db $12 $17
	.db $13 $17
	.db $14 $17
	.db $15 $17
	.db $16 $17
	.db $17 $17
	.db $18 $17
	.db $19 $17
	.db $1a $17
	.db $1b $17
	.db $1c $17
	.db $1d $17
	.db $1e $17
	.db $1f $17
	.db $20 $17
	.db $21 $17
	.db $22 $17
	.db $23 $17
	.db $24 $17
	.db $25 $17
	.db $26 $17
	.db $27 $17
	.db $28 $17
	.db $29 $17
	.db $2a $17
	.db $2b $17
	.db $2c $17
	.db $2d $17
	.db $2e $17
	.db $b8 $18
	.db $b9 $18
	.db $bb $17
	.db $bc $17
	.db $bd $17
	.db $be $17
	.db $bf $17
	.db $2f $16
	.db $00
_breakableTileCollision3:
_breakableTileCollision4:
	.db $f8 $2d
	.db $20 $19
	.db $21 $1a
	.db $22 $1b
	.db $23 $1c
	.db $ef $2e
	.db $11 $1d
	.db $12 $1e
	.db $10 $1f
	.db $13 $20
	.db $1f $21
	.db $30 $22
	.db $31 $23
	.db $32 $24
	.db $33 $25
	.db $38 $26
	.db $39 $27
	.db $3a $28
	.db $3b $29
	.db $16 $2a
	.db $15 $2b
	.db $2b $2c
	.db $2a $2c
	.db $00
_breakableTileCollision5:
	.db $12 $2f
	.db $00

; See ages for documentation on this macro
.macro m_BreakableTileData
	.if \3 > $f
	.fail
	.endif
	.if \4 > $f
	.fail
	.endif

	.db \1 \2
	.db \3 | (\4<<4)
	.db \5 \6
.endm

; @addr{76e4}
_breakableTileModes:
	m_BreakableTileData %10010110 %00110000 %0010 $1 $10 $04 ; $00
	m_BreakableTileData %10110111 %10110001 %0110 $1 $00 $04 ; $01
	m_BreakableTileData %10110111 %10110001 %0110 $0 $c0 $e6 ; $02
	m_BreakableTileData %10110111 %10110001 %0110 $0 $c0 $e0 ; $03
	m_BreakableTileData %10110111 %10110001 %0110 $0 $00 $f3 ; $04
	m_BreakableTileData %10110111 %10110001 %0110 $0 $00 $04 ; $05
	m_BreakableTileData %10110110 %10110001 %0110 $4 $01 $04 ; $06
	m_BreakableTileData %11110110 %00110000 %0010 $3 $00 $04 ; $07
	m_BreakableTileData %11110110 %00110000 %1011 $0 $00 $f3 ; $08
	m_BreakableTileData %00100001 %00000000 %0000 $4 $06 $04 ; $09
	m_BreakableTileData %00100001 %00000000 %0000 $0 $c6 $e7 ; $0a
	m_BreakableTileData %00100001 %00000000 %0000 $0 $c6 $e0 ; $0b
	m_BreakableTileData %00110000 %10000000 %0000 $0 $c6 $e8 ; $0c
	m_BreakableTileData %10101101 %00010001 %0000 $7 $0c $04 ; $0d
	m_BreakableTileData %01000000 %10000000 %0111 $4 $19 $04 ; $0e
	m_BreakableTileData %01000000 %10000000 %0111 $0 $19 $f3 ; $0f
	m_BreakableTileData %01110000 %00000000 %1011 $0 $1f $fd ; $10
	m_BreakableTileData %00000000 %00010000 %0000 $7 $1f $04 ; $11
	m_BreakableTileData %00000000 %00010000 %0000 $0 $df $e7 ; $12
	m_BreakableTileData %10000001 %00000000 %0100 $8 $1f $04 ; $13
	m_BreakableTileData %01000000 %00000000 %0000 $9 $0a $e1 ; $14
	m_BreakableTileData %01000000 %00000000 %0000 $0 $ca $e0 ; $15
	m_BreakableTileData %01000000 %00000000 %0000 $0 $0a $e1 ; $16
	m_BreakableTileData %01000000 %00000000 %0000 $a $0a $e1 ; $17
	m_BreakableTileData %01000000 %00000000 %0000 $b $0a $e1 ; $18
	m_BreakableTileData %10110111 %00110001 %0100 $1 $00 $a0 ; $19
	m_BreakableTileData %10110111 %00110001 %0100 $0 $00 $a0 ; $1a
	m_BreakableTileData %10110111 %00110001 %0100 $0 $40 $45 ; $1b
	m_BreakableTileData %10110111 %00110001 %0100 $0 $00 $f3 ; $1c
	m_BreakableTileData %00100101 %00000001 %0000 $0 $06 $a0 ; $1d
	m_BreakableTileData %00100101 %00000001 %0000 $0 $46 $45 ; $1e
	m_BreakableTileData %00100101 %00000001 %0000 $2 $06 $a0 ; $1f
	m_BreakableTileData %00100101 %00000001 %0000 $0 $46 $0d ; $20
	m_BreakableTileData %00110000 %00000000 %0000 $0 $06 $a0 ; $21
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $34 ; $22
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $35 ; $23
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $36 ; $24
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $37 ; $25
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $34 ; $26
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $35 ; $27
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $36 ; $28
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $37 ; $29
	m_BreakableTileData %00111111 %00000000 %0000 $0 $06 $a0 ; $2a
	m_BreakableTileData %00100001 %00000000 %0000 $4 $06 $4c ; $2b
	m_BreakableTileData %00000110 %00000000 %0000 $0 $07 $00 ; $2c
	m_BreakableTileData %10010110 %00110000 %0010 $0 $10 $ef ; $2d
	m_BreakableTileData %01000000 %00000000 %0000 $c $0a $4c ; $2e
	m_BreakableTileData %00110000 %00000000 %0000 $0 $06 $01 ; $2f
.ends


.BANK $07 SLOT 1
.ORG 0

.include "code/fileManagement.s"

 ; This section can't be superfree, since it must be in the same bank as section
 ; "Bank_7_Data".
 m_section_free "Enemy_Part_Collisions" namespace "bank7"
	.include "code/collisionEffects.s"
.ends


 m_section_superfree "Item_Code" namespace "itemCode"
.include "code/updateItems.s"

	.include "build/data/itemConveyorTilesTable.s"
	.include "build/data/itemPassableCliffTilesTable.s"
	.include "build/data/itemPassableTilesTable.s"
	.include "code/itemCodes.s"
	.include "data/seasons/itemAttributes.s"
	.include "data/itemAnimations.s"
.ends


 ; This section can't be superfree, since it must be in the same bank as section
 ; "Enemy_Part_Collisions".
 m_section_free "Bank_7_Data" namespace "bank7"

	.include "data/seasons/enemyActiveCollisions.s"
	.include "data/seasons/partActiveCollisions.s"
	.include "data/seasons/objectCollisionTable.s"

.ends


.BANK $08 SLOT 1
.ORG 0

.include "code/seasons/interactionCode/bank08.s"

.BANK $09 SLOT 1
.ORG 0

.include "code/seasons/interactionCode/bank09.s"

.BANK $0a SLOT 1
.ORG 0

.include "code/seasons/interactionCode/bank0a.s"

.BANK $0b SLOT 1
.ORG 0

	.include "code/scripting.s"
	.include "scripts/seasons/scripts.s"


.BANK $0c SLOT 1
.ORG 0

.section Enemy_Code_Bank0c

	.include "code/enemyCommon.s"
	.include "code/seasons/enemyCode/bank0c.s"
	.include "data/seasons/enemyAnimations.s"

.ends

.BANK $0d SLOT 1
.ORG 0

.section Enemy_Code_Bank0d

	.include "code/enemyCommon.s"
	.include "code/seasons/enemyCode/bank0d.s"

objectLoadMovementScript_body:
	ldh a,(<hActiveObjectType)	; $798f
	add $02			; $7991
	ld e,a			; $7993
	ld a,(de)		; $7994
	rst_addDoubleIndex			; $7995
	ldi a,(hl)		; $7996
	ld h,(hl)		; $7997
	ld l,a			; $7998
	ld a,e			; $7999
	add $0e			; $799a
	ld e,a			; $799c
	ldi a,(hl)		; $799d
	ld (de),a		; $799e
	ld a,e			; $799f
	add $f8			; $79a0
	ld e,a			; $79a2
	ldi a,(hl)		; $79a3
	ld (de),a		; $79a4
	ld a,e			; $79a5
	add $28			; $79a6
	ld e,a			; $79a8
	ld a,l			; $79a9
	ld (de),a		; $79aa
	inc e			; $79ab
	ld a,h			; $79ac
	ld (de),a		; $79ad
objectRunMovementScript_body:
	ldh a,(<hActiveObjectType)	; $79ae
	add $30			; $79b0
	ld e,a			; $79b2
	ld a,(de)		; $79b3
	ld l,a			; $79b4
	inc e			; $79b5
	ld a,(de)		; $79b6
	ld h,a			; $79b7
_label_0d_350:
	ldi a,(hl)		; $79b8
	push hl			; $79b9
	rst_jumpTable			; $79ba
	rst_jumpTable			; $79bb
	ld a,c			; $79bc
	call $e379		; $79bd
	ld a,c			; $79c0
	ld sp,hl		; $79c1
	ld a,c			; $79c2
	rrca			; $79c3
	ld a,d			; $79c4
	dec h			; $79c5
	ld a,d			; $79c6
	pop hl			; $79c7
	ldi a,(hl)		; $79c8
	ld h,(hl)		; $79c9
	ld l,a			; $79ca
	jr _label_0d_350		; $79cb
	pop bc			; $79cd
	ld h,d			; $79ce
	ldh a,(<hActiveObjectType)	; $79cf
	add $32			; $79d1
	ld l,a			; $79d3
	ld a,(bc)		; $79d4
	ld (hl),a		; $79d5
	ld a,l			; $79d6
	add $d7			; $79d7
	ld l,a			; $79d9
	ld (hl),$00		; $79da
	add $fb			; $79dc
	ld l,a			; $79de
	ld (hl),$08		; $79df
	jr _label_0d_351		; $79e1
	pop bc			; $79e3
	ld h,d			; $79e4
	ldh a,(<hActiveObjectType)	; $79e5
	add $33			; $79e7
	ld l,a			; $79e9
	ld a,(bc)		; $79ea
	ld (hl),a		; $79eb
	ld a,l			; $79ec
	add $d6			; $79ed
	ld l,a			; $79ef
	ld (hl),$08		; $79f0
	add $fb			; $79f2
	ld l,a			; $79f4
	ld (hl),$09		; $79f5
	jr _label_0d_351		; $79f7
	pop bc			; $79f9
	ld h,d			; $79fa
	ldh a,(<hActiveObjectType)	; $79fb
	add $32			; $79fd
	ld l,a			; $79ff
	ld a,(bc)		; $7a00
	ld (hl),a		; $7a01
	ld a,l			; $7a02
	add $d7			; $7a03
	ld l,a			; $7a05
	ld (hl),$10		; $7a06
	add $fb			; $7a08
	ld l,a			; $7a0a
	ld (hl),$0a		; $7a0b
	jr _label_0d_351		; $7a0d
	pop bc			; $7a0f
	ld h,d			; $7a10
	ldh a,(<hActiveObjectType)	; $7a11
	add $33			; $7a13
	ld l,a			; $7a15
	ld a,(bc)		; $7a16
	ld (hl),a		; $7a17
	ld a,l			; $7a18
	add $d6			; $7a19
	ld l,a			; $7a1b
	ld (hl),$18		; $7a1c
	add $fb			; $7a1e
	ld l,a			; $7a20
	ld (hl),$0b		; $7a21
	jr _label_0d_351		; $7a23
	pop bc			; $7a25
	ld h,d			; $7a26
	ldh a,(<hActiveObjectType)	; $7a27
	add $06			; $7a29
	ld l,a			; $7a2b
	ld a,(bc)		; $7a2c
	ld (hl),a		; $7a2d
	ld a,l			; $7a2e
	add $fe			; $7a2f
	ld l,a			; $7a31
	ld (hl),$0c		; $7a32
_label_0d_351:
	inc bc			; $7a34
	add $2c			; $7a35
	ld l,a			; $7a37
	ld (hl),c		; $7a38
	inc l			; $7a39
	ld (hl),b		; $7a3a
	ret			; $7a3b
	ld h,(hl)		; $7a3c
	ld a,d			; $7a3d
	ld l,a			; $7a3e
	ld a,d			; $7a3f
	ld a,b			; $7a40
	ld a,d			; $7a41
	add c			; $7a42
	ld a,d			; $7a43
	adc d			; $7a44
	ld a,d			; $7a45
	sub e			; $7a46
	ld a,d			; $7a47
	sbc h			; $7a48
	ld a,d			; $7a49
	and l			; $7a4a
	ld a,d			; $7a4b
	xor (hl)		; $7a4c
	ld a,d			; $7a4d
	or a			; $7a4e
	ld a,d			; $7a4f
	ret nz			; $7a50
	ld a,d			; $7a51
	ret			; $7a52
	ld a,d			; $7a53
	sub $7a			; $7a54
.DB $e3				; $7a56
	ld a,d			; $7a57
.DB $ec				; $7a58
	ld a,d			; $7a59
	push af			; $7a5a
	ld a,d			; $7a5b
	ld (bc),a		; $7a5c
	ld a,e			; $7a5d
	dec bc			; $7a5e
	ld a,e			; $7a5f
	inc d			; $7a60
	ld a,e			; $7a61
	dec e			; $7a62
	ld a,e			; $7a63
	ld h,$7b		; $7a64
	inc d			; $7a66
	nop			; $7a67
	ld (bc),a		; $7a68
	ld l,d			; $7a69
	inc b			; $7a6a
	ld c,d			; $7a6b
	nop			; $7a6c
	ld l,b			; $7a6d
	ld a,d			; $7a6e
	inc d			; $7a6f
	nop			; $7a70
	inc b			; $7a71
	sub (hl)		; $7a72
	ld (bc),a		; $7a73
	or (hl)			; $7a74
	nop			; $7a75
	ld (hl),c		; $7a76
	ld a,d			; $7a77
	inc d			; $7a78
	nop			; $7a79
	ld bc,$0328		; $7a7a
	ld e,b			; $7a7d
	nop			; $7a7e
	ld a,d			; $7a7f
	ld a,d			; $7a80
	inc d			; $7a81
	nop			; $7a82
	inc b			; $7a83
	ld d,b			; $7a84
	ld (bc),a		; $7a85
	and b			; $7a86
	nop			; $7a87
	add e			; $7a88
	ld a,d			; $7a89
	inc d			; $7a8a
	nop			; $7a8b
	inc b			; $7a8c
	ld d,b			; $7a8d
	ld (bc),a		; $7a8e
	add b			; $7a8f
	nop			; $7a90
	adc h			; $7a91
	ld a,d			; $7a92
	inc d			; $7a93
	nop			; $7a94
	ld (bc),a		; $7a95
	ld (hl),b		; $7a96
	inc b			; $7a97
	ld b,b			; $7a98
	nop			; $7a99
	sub l			; $7a9a
	ld a,d			; $7a9b
	inc d			; $7a9c
	nop			; $7a9d
	inc b			; $7a9e
	ld b,b			; $7a9f
	ld (bc),a		; $7aa0
	or b			; $7aa1
	nop			; $7aa2
	sbc (hl)		; $7aa3
	ld a,d			; $7aa4
	inc d			; $7aa5
	nop			; $7aa6
	ld bc,$0368		; $7aa7
	sbc b			; $7aaa
	nop			; $7aab
	and a			; $7aac
	ld a,d			; $7aad
	inc d			; $7aae
	ld (bc),a		; $7aaf
	ld bc,$0338		; $7ab0
	adc b			; $7ab3
	nop			; $7ab4
	or b			; $7ab5
	ld a,d			; $7ab6
	inc d			; $7ab7
	ld (bc),a		; $7ab8
	inc bc			; $7ab9
	adc b			; $7aba
	ld bc,$0038		; $7abb
	cp c			; $7abe
	ld a,d			; $7abf
	inc d			; $7ac0
	inc bc			; $7ac1
	inc b			; $7ac2
	ld b,b			; $7ac3
	ld (bc),a		; $7ac4
	sub b			; $7ac5
	nop			; $7ac6
	jp nz,$147a		; $7ac7
	nop			; $7aca
	ld (bc),a		; $7acb
	adc b			; $7acc
	inc bc			; $7acd
	ld l,b			; $7ace
	inc b			; $7acf
	ld a,b			; $7ad0
	ld bc,$0028		; $7ad1
	bit 7,d			; $7ad4
	inc d			; $7ad6
	nop			; $7ad7
	inc b			; $7ad8
	xor b			; $7ad9
	inc bc			; $7ada
	adc b			; $7adb
	ld (bc),a		; $7adc
	ret nz			; $7add
	ld bc,$0038		; $7ade
	ret c			; $7ae1
	ld a,d			; $7ae2
	inc d			; $7ae3
	nop			; $7ae4
	ld (bc),a		; $7ae5
	ld h,b			; $7ae6
	inc b			; $7ae7
	jr nc,_label_0d_352	; $7ae8
_label_0d_352:
	push hl			; $7aea
	ld a,d			; $7aeb
	inc d			; $7aec
	nop			; $7aed
	ld (bc),a		; $7aee
	and b			; $7aef
	inc b			; $7af0
	ld (hl),b		; $7af1
	nop			; $7af2
	xor $7a			; $7af3
	inc d			; $7af5
	ld bc,$8803		; $7af6
	dec b			; $7af9
	ld e,$01		; $7afa
	ld l,b			; $7afc
	dec b			; $7afd
	ld e,$00		; $7afe
	rst $30			; $7b00
	ld a,d			; $7b01
	inc d			; $7b02
	ld (bc),a		; $7b03
	inc bc			; $7b04
	adc b			; $7b05
	ld bc,addAToDe		; $7b06
	inc b			; $7b09
	ld a,e			; $7b0a
	inc d			; $7b0b
	ld (bc),a		; $7b0c
	inc bc			; $7b0d
	adc b			; $7b0e
	ld bc,$0048		; $7b0f
	dec c			; $7b12
	ld a,e			; $7b13
	inc d			; $7b14
	ld (bc),a		; $7b15
	ld bc,$0348		; $7b16
	adc b			; $7b19
	nop			; $7b1a
	ld d,$7b		; $7b1b
	inc d			; $7b1d
	nop			; $7b1e
	ld bc,$0328		; $7b1f
	adc b			; $7b22
	nop			; $7b23
	rra			; $7b24
	ld a,e			; $7b25
	inc d			; $7b26
	nop			; $7b27
	inc bc			; $7b28
	adc b			; $7b29
	ld bc,$0028		; $7b2a
	.db $28 $7b 
	add hl,sp		; $7b2f
	ld a,e			; $7b30
	ld b,(hl)		; $7b31
	ld a,e			; $7b32
	ld c,a			; $7b33
	ld a,e			; $7b34
	ld e,b			; $7b35
	ld a,e			; $7b36
	ld h,l			; $7b37
	ld a,e			; $7b38
	inc d			; $7b39
	ld bc,$5002		; $7b3a
	inc bc			; $7b3d
	adc b			; $7b3e
	inc b			; $7b3f
	jr c,$01		; $7b40
	jr c,_label_0d_353	; $7b42
_label_0d_353:
	dec sp			; $7b44
	ld a,e			; $7b45
	inc d			; $7b46
	nop			; $7b47
	inc bc			; $7b48
	adc b			; $7b49
	ld bc,$0028		; $7b4a
	ld c,b			; $7b4d
	ld a,e			; $7b4e
	inc d			; $7b4f
	ld bc,$2801		; $7b50
	inc bc			; $7b53
	adc b			; $7b54
	nop			; $7b55
	ld d,c			; $7b56
	ld a,e			; $7b57
	inc d			; $7b58
	ld bc,$2801		; $7b59
	ld (bc),a		; $7b5c
	add b			; $7b5d
	inc bc			; $7b5e
	adc b			; $7b5f
	inc b			; $7b60
	ld b,b			; $7b61
	nop			; $7b62
	ld e,d			; $7b63
	ld a,e			; $7b64
	inc d			; $7b65
	nop			; $7b66
	ld bc,$0438		; $7b67
	ld b,b			; $7b6a
	inc bc			; $7b6b
	ld a,b			; $7b6c
	ld (bc),a		; $7b6d
	and b			; $7b6e
	nop			; $7b6f
	ld h,a			; $7b70
	ld a,e			; $7b71

.ends

.BANK $0e SLOT 1
.ORG 0

.section Enemy_Code_Bank0e

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "code/seasons/enemyCode/bank0e.s"

.ends

.BANK $0f SLOT 1
.ORG 0

.section Enemy_Code_Bank0f

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "code/seasons/enemyCode/bank0f.s"
	.include "code/seasons/cutscenes/transitionToDragonOnox.s"

	.REPT $87
	.db $0f ; emptyfill
	.ENDR

	.include "code/seasons/interactionCode/bank0f.s"

.ends

.BANK $10 SLOT 1
.ORG 0

	.define PART_BANK $10
	.export PART_BANK

 m_section_force "Part_Code" NAMESPACE "partCode"

	.include "code/partCommon.s"
	.include "code/seasons/partCode.s"

.ends


.BANK $11 SLOT 1
.ORG 0

	.include "code/objectLoading.s"

 m_section_free "Objects_2" namespace "objectData"
	.include "objects/seasons/pointers.s"
	.include "objects/seasons/mainData.s"
	.include "objects/seasons/extraData3.s"
.ends


.BANK $12 SLOT 1
.ORG 0

	.define BASE_OAM_DATA_BANK $12
	.export BASE_OAM_DATA_BANK

	.include "data/seasons/specialObjectOamData.s"
	.include "data/itemOamData.s"
	.include "data/seasons/enemyOamData.s"


.BANK $13 SLOT 1
.ORG 0

 m_section_superfree "Terrain_Effects" NAMESPACE "terrainEffects"

; @addr{4000}
shadowAnimation:
	.db $01
	.db $13 $04 $20 $08

; @addr{4005}
greenGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $08
	.db $11 $07 $24 $08

; @addr{400e}
blueGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $09
	.db $11 $07 $24 $09

; @addr{4017}
_puddleAnimationFrame0:
	.db $02
	.db $16 $03 $22 $08
	.db $16 $05 $22 $28

; @addr{4020}
orangeGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $0b
	.db $11 $07 $24 $0b

; @addr{4029}
greenGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $28
	.db $11 $07 $24 $28

; @addr{4032}
blueGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $29
	.db $11 $07 $24 $29

; @addr{403b}
_puddleAnimationFrame1:
	.db $02
	.db $16 $02 $22 $08
	.db $16 $06 $22 $28

; @addr{4044}
orangeGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $2b
	.db $11 $07 $24 $2b

; @addr{404d}
_puddleAnimationFrame2:
	.db $02
	.db $17 $01 $22 $08
	.db $17 $07 $22 $28

; @addr{4056}
_puddleAnimationFrame3:
	.db $02
	.db $18 $00 $22 $08
	.db $18 $08 $22 $28

; @addr{405f}
puddleAnimationFrames:
	.dw _puddleAnimationFrame0
	.dw _puddleAnimationFrame1
	.dw _puddleAnimationFrame2
	.dw _puddleAnimationFrame3
.ends

	.include "data/seasons/interactionOamData.s"
	.include "data/seasons/partOamData.s"


.BANK $14 SLOT 1
.ORG 0

.include "build/data/data_4556.s"

	push af
.DB $e3
	sub (hl)		; $4772
	sbc b			; $4773
	ld a,(bc)		; $4774
	nop			; $4775
.DB $e3				; $4776
	rst $8			; $4777
	rst_addAToHl			; $4778
	jr nc,-$1d	; $4779
	ld (hl),d		; $477b
	rst $20			; $477c
	ld b,(hl)		; $477d
	ld ($30d7),sp		; $477e
.DB $e3				; $4781
	ld (hl),d		; $4782
	rst $20			; $4783
	ld c,b			; $4784
	ld ($d0e0),sp		; $4785
	ld sp,$30d7		; $4788
.DB $e3				; $478b
	ld (hl),d		; $478c
	rst $20			; $478d
	ld l,b			; $478e
	ld ($d4e0),sp		; $478f
	ld sp,$30d7		; $4792
.DB $e3				; $4795
	ld (hl),d		; $4796
	rst $20			; $4797
	ld h,(hl)		; $4798
	ld ($30d7),sp		; $4799
.DB $e3				; $479c
	adc l			; $479d
	ld ($ff00+$6d),a	; $479e
	ld d,l			; $47a0
	nop			; $47a1
	push af			; $47a2
.DB $e3				; $47a3
	sub (hl)		; $47a4
	sbc b			; $47a5
	ld a,(bc)		; $47a6
	nop			; $47a7
.DB $e3				; $47a8
	rst $8			; $47a9
	rst_addAToHl			; $47aa
	jr nc,-$1d		; $47ab
	ld (hl),d		; $47ad
	rst $20			; $47ae
	dec (hl)		; $47af
	ld ($30d7),sp		; $47b0
.DB $e3				; $47b3
	ld (hl),d		; $47b4
	rst $20			; $47b5
	add hl,sp		; $47b6
	ld ($d0e0),sp		; $47b7
	ld sp,$30d7		; $47ba
.DB $e3				; $47bd
	ld (hl),d		; $47be
	rst $20			; $47bf
	ld a,c			; $47c0
	ld ($d4e0),sp		; $47c1
	ld sp,$30d7		; $47c4
.DB $e3				; $47c7
	ld (hl),d		; $47c8
	rst $20			; $47c9
	ld (hl),l		; $47ca
	ld ($30d7),sp		; $47cb
.DB $e3				; $47ce
	adc l			; $47cf
	ld ($ff00+$6d),a	; $47d0
	ld d,l			; $47d2
	nop			; $47d3
	adc $d5			; $47d4
	xor c			; $47d6
	call z,$e302		; $47d7
	sub (hl)		; $47da
_label_14_049:
	ld hl,sp-$7b		; $47db
	ld a,(hl)		; $47dd
	nop			; $47de
	ld c,b			; $47df
	ret z			; $47e0
	or $98			; $47e1
	ld a,(bc)		; $47e3
	ld bc,$d2f6		; $47e4
	or c			; $47e7
	ld b,b			; $47e8
	cp c			; $47e9
	nop			; $47ea
	adc $d5			; $47eb
	xor c			; $47ed
	call z,$e304		; $47ee
	sub (hl)		; $47f1
	ld hl,sp-$7b		; $47f2
	halt			; $47f4
	nop			; $47f5
	ld e,b			; $47f6
	ld a,b			; $47f7
	or $98			; $47f8
	ld a,(bc)		; $47fa
	inc bc			; $47fb
	or $d2			; $47fc
_label_14_050:
	or c			; $47fe
	ld b,b			; $47ff
	nop			; $4800
	add h			; $4801
	ld e,$13		; $4802
	jr nc,_label_14_051	; $4804
_label_14_051:
	add h			; $4806
	dec b			; $4807
	nop			; $4808
	jr _label_14_052		; $4809
.DB $f4				; $480b
	rst $20			; $480c
	inc d			; $480d
	and b			; $480e
	add h			; $480f
	dec b			; $4810
	nop			; $4811
	jr c,_label_14_053	; $4812
.DB $f4				; $4814
	rst $20			; $4815
	inc (hl)		; $4816
	and b			; $4817
	add h			; $4818
	dec b			; $4819
	nop			; $481a
	jr z,$48		; $481b
.DB $f4				; $481d
	rst $20			; $481e
	inc h			; $481f
	and b			; $4820
	add h			; $4821
	dec b			; $4822
	nop			; $4823
	ld c,b			; $4824
	ld c,b			; $4825
.DB $f4				; $4826
	rst $20			; $4827
	ld b,h			; $4828
	and b			; $4829
	add h			; $482a
	ld h,l			; $482b
	nop			; $482c
	nop			; $482d
	nop			; $482e
	nop			; $482f
	adc $8d			; $4830
	ld ($d020),sp		; $4832
	cp l			; $4835
.DB $e4				; $4836
	dec c			; $4837
	sbc b			; $4838
	nop			; $4839
	or $98			; $483a
	ld bc,$98f6		; $483c
	ld (bc),a		; $483f
	or $98			; $4840
	inc bc			; $4842
.DB $e4				; $4843
	rst $38			; $4844
	or c			; $4845
	ld b,b			; $4846
	cp (hl)			; $4847
	nop			; $4848
	adc $d5			; $4849
	inc b			; $484b
	ret nc			; $484c
	ld bc,$d5f3		; $484d
	ld sp,$01cc		; $4850
_label_14_052:
	adc b			; $4853
	ld a,b			; $4854
	ld a,b			; $4855
	rst_addAToHl			; $4856
	inc c			; $4857
	ld ($ff00+c),a		; $4858
	ld a,($ff00+c)		; $4859
	add sp,$6a		; $485a
_label_14_053:
.DB $e3				; $485c
	ld c,l			; $485d
	or c			; $485e
	ld b,b			; $485f
	nop			; $4860
	adc $8e			; $4861
	ld e,h			; $4863
	ld bc,$ebc0		; $4864
	ld d,(hl)		; $4867
	and b			; $4868
	ld ($ff00+$cb),a	; $4869
	ld e,b			; $486b
	adc h			; $486c
_label_14_054:
	ld l,b			; $486d
	and d			; $486e
	ld ($ff00+$fa),a	; $486f
	dec e			; $4871
	adc e			; $4872
	jr z,_label_14_050	; $4873
	ld ($dce0),sp		; $4875
	ld e,b			; $4878
	and e			; $4879
	adc a			; $487a
	ld bc,$0380		; $487b
	ret nc			; $487e
	add b			; $487f
	ld (bc),a		; $4880
	ld ($ff00+$eb),a	; $4881
	ld e,b			; $4883
	or $ac			; $4884
	adc a			; $4886
_label_14_055:
	inc bc			; $4887
	adc e			; $4888
	ld d,b			; $4889
	adc c			; $488a
	jr _label_14_054		; $488b
	ld l,b			; $488d
	ld e,c			; $488e
	pop af			; $488f
	ldh (<hSerialRead),a	; $4890
	ld e,b			; $4892
	sbc b			; $4893
	nop			; $4894
	ld (hl),$be		; $4895
.DB $e4				; $4897
	rst $38			; $4898
	nop			; $4899
	or l			; $489a
	rrca			; $489b
	ret c			; $489c
	ld b,l			; $489d
	adc (hl)		; $489e
	ld e,h			; $489f
	ld (bc),a		; $48a0
	ret nz			; $48a1
.DB $eb				; $48a2
	ld d,(hl)		; $48a3
	adc a			; $48a4
	ld (bc),a		; $48a5
	cp d			; $48a6
	ld hl,sp-$6b		; $48a7
	nop			; $48a9
.DB $fd				; $48aa
	sbc b			; $48ab
	jr z,_label_14_057	; $48ac
_label_14_056:
	xor b			; $48ae
_label_14_057:
	and c			; $48af
	adc a			; $48b0
	inc bc			; $48b1
	adc h			; $48b2
_label_14_058:
	ld b,b			; $48b3
	nop			; $48b4
	pop hl			; $48b5
	pop de			; $48b6
	ld h,e			; $48b7
	ld (bc),a		; $48b8
_label_14_059:
	or $98			; $48b9
	jr nz,_label_14_058	; $48bb
	sbc b			; $48bd
	ld hl,$98f6		; $48be
	jr z,_label_14_059	; $48c1
	sbc b			; $48c3
	ldi (hl),a		; $48c4
	or $98			; $48c5
	add hl,hl		; $48c7
	or $98			; $48c8
	inc hl			; $48ca
	ld ($ff00+$1e),a	; $48cb
	ld e,$8b		; $48cd
	inc d			; $48cf
	xor $09			; $48d0
	or $98			; $48d2
	ldi a,(hl)		; $48d4
	xor d			; $48d5
	or $98			; $48d6
	inc h			; $48d8
	or $5d			; $48d9
	ld (hl),$9e		; $48db
	cp b			; $48dd
	sbc b			; $48de
	inc c			; $48df
	or $8e			; $48e0
	ld a,h			; $48e2
	ld bc,$508b		; $48e3
.DB $ec				; $48e6
	dec d			; $48e7
	pop af			; $48e8
	adc a			; $48e9
	nop			; $48ea
	adc c			; $48eb
	ld ($098c),sp		; $48ec
	pop af			; $48ef
	ret nz			; $48f0
	ld e,c			; $48f1
	ld e,(hl)		; $48f2
	ret nz			; $48f3
	ld e,c			; $48f4
	ld e,(hl)		; $48f5
	adc a			; $48f6
	nop			; $48f7
	adc c			; $48f8
	jr _label_14_055		; $48f9
	add hl,bc		; $48fb
	pop af			; $48fc
	ret nz			; $48fd
	ld e,c			; $48fe
	ld e,(hl)		; $48ff
	adc a			; $4900
	nop			; $4901
	adc c			; $4902
	jr -$74			; $4903
	add hl,bc		; $4905
	pop af			; $4906
	ret nz			; $4907
	ld e,c			; $4908
	ld e,(hl)		; $4909
	ret nz			; $490a
	ld e,c			; $490b
	ld e,(hl)		; $490c
	adc a			; $490d
	nop			; $490e
	adc c			; $490f
	ld ($198c),sp		; $4910
	pop af			; $4913
	ret nz			; $4914
	ld e,c			; $4915
	ld e,(hl)		; $4916
	ret nz			; $4917
	ld e,c			; $4918
	ld e,(hl)		; $4919
	ret nz			; $491a
	ld e,c			; $491b
_label_14_060:
	ld e,(hl)		; $491c
	adc a			; $491d
	nop			; $491e
	adc c			; $491f
	jr _label_14_056		; $4920
	ld de,$eef1		; $4922
	dec d			; $4925
	adc (hl)		; $4926
	ld a,h			; $4927
	nop			; $4928
	or $98			; $4929
	dec c			; $492b
	or $b9			; $492c
	ld e,(hl)		; $492e
	ld d,b			; $492f
	cp l			; $4930
	ld ($ff00+$67),a	; $4931
	ld e,d			; $4933
	sub c			; $4934
	xor d			; $4935
	call z,$f801		; $4936
	ld ($ff00+$21),a	; $4939
_label_14_061:
	ld e,d			; $493b
	and b			; $493c
	ret nz			; $493d
	ld a,(bc)		; $493e
_label_14_062:
	ld e,a			; $493f
	or $98			; $4940
	dec h			; $4942
	or $a9			; $4943
	adc (hl)		; $4945
	ld a,h			; $4946
	ld bc,$1ee0		; $4947
	ld e,$8b		; $494a
	jr z,_label_14_061	; $494c
	ld b,c			; $494e
	pop af			; $494f
	adc e			; $4950
	jr z,_label_14_062	; $4951
	rra			; $4953
	ret nz			; $4954
	ld bc,$e05f		; $4955
	ld h,c			; $4958
	ld e,d			; $4959
	and d			; $495a
	ld ($ff00+$45),a	; $495b
	ld e,d			; $495d
	cp c			; $495e
.DB $d3				; $495f
	rlca			; $4960
	jp $b8cb		; $4961
	push af			; $4964
	ld ($ff00+$5b),a	; $4965
	ld e,d			; $4967
	sub c			; $4968
	jp $00cb		; $4969
	ld hl,sp-$46		; $496c
	sub c			; $496e
	inc b			; $496f
	call z,$000c		; $4970
	ld ($ff00+$39),a	; $4973
	ld e,$d5		; $4975
	ret nz			; $4977
	rst $8			; $4978
	ld bc,$42e0		; $4979
	ld e,$d5		; $497c
	ret nz			; $497e
	rst $8			; $497f
	ld b,$8f		; $4980
	inc bc			; $4982
	ld a,($ff00+c)		; $4983
	sub c			; $4984
	ret nz			; $4985
	rst $8			; $4986
	rlca			; $4987
	sbc b			; $4988
	dec a			; $4989
	inc c			; $498a
	di			; $498b
	adc a			; $498c
	rlca			; $498d
_label_14_063:
	adc c			; $498e
	jr _label_14_060		; $498f
	dec b			; $4991
	adc h			; $4992
	ld e,$91		; $4993
	ret nz			; $4995
	rst $8			; $4996
	ld ($f800),sp		; $4997
	adc b			; $499a
	jr _label_14_065		; $499b
	adc e			; $499d
_label_14_064:
	jr z,_label_14_063	; $499e
	ld de,$edf1		; $49a0
	add hl,sp		; $49a3
	pop af			; $49a4
	xor $11			; $49a5
	pop af			; $49a7
	sbc b			; $49a8
	ld d,b			; $49a9
	dec c			; $49aa
	or $84			; $49ab
	cp d			; $49ad
	ld bc,$1818		; $49ae
	and b			; $49b1
	adc h			; $49b2
	ld d,c			; $49b3
	xor c			; $49b4
_label_14_065:
	nop			; $49b5
	adc a			; $49b6
	ld (bc),a		; $49b7
	and (hl)		; $49b8
	adc a			; $49b9
	inc bc			; $49ba
.DB $f4				; $49bb
	adc a			; $49bc
	ld bc,$8ff4		; $49bd
	ld (bc),a		; $49c0
	and l			; $49c1
	ld ($ff00+$c8),a	; $49c2
	ld e,d			; $49c4
.DB $e3				; $49c5
	ld d,b			; $49c6
	nop			; $49c7
	adc a			; $49c8
	inc bc			; $49c9
	ei			; $49ca
	adc e			; $49cb
_label_14_066:
	inc d			; $49cc
_label_14_067:
	adc c			; $49cd
	jr -$74			; $49ce
	ret nz			; $49d0
	ld a,($008f)		; $49d1
	rst_addAToHl			; $49d4
	sub (hl)		; $49d5
	sub c			; $49d6
	rst_addDoubleIndex			; $49d7
	rst $8			; $49d8
	ld bc,$bd00		; $49d9
	add h			; $49dc
	ld e,l			; $49dd
	rlca			; $49de
	ld l,b			; $49df
	ld e,b			; $49e0
	adc (hl)		; $49e1
	ld a,c			; $49e2
	nop			; $49e3
.DB $e3				; $49e4
	ld l,c			; $49e5
	adc a			; $49e6
	inc b			; $49e7
	rst $30			; $49e8
	sub c			; $49e9
	sbc $cf			; $49ea
	add b			; $49ec
	adc a			; $49ed
	ld (bc),a		; $49ee
	sbc b			; $49ef
	dec sp			; $49f0
	sub c			; $49f1
	rst_addDoubleIndex			; $49f2
	rst $8			; $49f3
	ld bc,$41de		; $49f4
	ld ($40b1),sp		; $49f7
	ld ($ff00+$d1),a	; $49fa
	ld e,d			; $49fc
_label_14_068:
	or $8e			; $49fd
	ld a,d			; $49ff
	ld bc,$508b		; $4a00
	adc c			; $4a03
	ld ($118c),sp		; $4a04
	adc a			; $4a07
	ld bc,$1089		; $4a08
	adc h			; $4a0b
	add hl,hl		; $4a0c
	cp (hl)			; $4a0d
	nop			; $4a0e
	adc b			; $4a0f
	ld (hl),b		; $4a10
	jr _label_14_064		; $4a11
	ld d,b			; $4a13
.DB $e4				; $4a14
	ld hl,$89fa		; $4a15
	ld ($118c),sp		; $4a18
	sub d			; $4a1b
	pop de			; $4a1c
	rst $8			; $4a1d
	stop			; $4a1e
	push af			; $4a1f
	adc h			; $4a20
	dec c			; $4a21
	rst $30			; $4a22
	adc c			; $4a23
	nop			; $4a24
	adc h			; $4a25
	ld ($d192),sp		; $4a26
	rst $8			; $4a29
	ld (bc),a		; $4a2a
	rst $30			; $4a2b
	adc c			; $4a2c
	ld ($138c),sp		; $4a2d
	sub d			; $4a30
	pop de			; $4a31
	rst $8			; $4a32
	ld ($89f7),sp		; $4a33
	nop			; $4a36
	adc h			; $4a37
	ld a,(bc)		; $4a38
	sub d			; $4a39
	pop de			; $4a3a
	rst $8			; $4a3b
	inc b			; $4a3c
	rst $30			; $4a3d
	adc c			; $4a3e
	jr _label_14_067		; $4a3f
	jr nc,_label_14_066	; $4a41
	nop			; $4a43
	adc h			; $4a44
	dec c			; $4a45
	sub d			; $4a46
	pop de			; $4a47
	rst $8			; $4a48
	ld bc,$8900		; $4a49
	ld ($148c),sp		; $4a4c
	sub d			; $4a4f
	pop de			; $4a50
	rst $8			; $4a51
	ld b,b			; $4a52
	push de			; $4a53
	ret nc			; $4a54
	rst $8			; $4a55
	rlca			; $4a56
	adc h			; $4a57
	ld d,$92		; $4a58
	pop de			; $4a5a
	rst $8			; $4a5b
	add b			; $4a5c
	push de			; $4a5d
	ret nc			; $4a5e
	rst $8			; $4a5f
	ld a,(bc)		; $4a60
	ld sp,hl		; $4a61
	adc c			; $4a62
	nop			; $4a63
	adc h			; $4a64
	jr z,-$6f		; $4a65
	ret nc			; $4a67
	rst $8			; $4a68
	dec bc			; $4a69
	or c			; $4a6a
	add b			; $4a6b
	nop			; $4a6c
	adc b			; $4a6d
	ld ($ff00+$80),a	; $4a6e
	or $8b			; $4a70
	jr z,_label_14_068	; $4a72
	nop			; $4a74
	adc a			; $4a75
	ld (bc),a		; $4a76
	adc h			; $4a77
	ld e,b			; $4a78
	adc a			; $4a79
	ld bc,$98f8		; $4a7a
	ld e,$00		; $4a7d
	di			; $4a7f
	sbc b			; $4a80
	ld e,$02		; $4a81
	di			; $4a83
	sbc b			; $4a84
	ld e,$03		; $4a85
	di			; $4a87
	sbc b			; $4a88
	ld e,$04		; $4a89
	di			; $4a8b
	sub c			; $4a8c
	ret nc			; $4a8d
	rst $8			; $4a8e
	dec bc			; $4a8f
	nop			; $4a90
	adc b			; $4a91
	nop			; $4a92
	ld h,b			; $4a93
	adc e			; $4a94
	inc d			; $4a95
	adc c			; $4a96
	stop			; $4a97
	adc h			; $4a98
	add b			; $4a99
	adc a			; $4a9a
	stop			; $4a9b
	ld hl,sp-$68		; $4a9c
	rla			; $4a9e
	ld a,(de)		; $4a9f
	ld hl,sp-$57		; $4aa0
	nop			; $4aa2
	or (hl)			; $4aa3
	ld e,b			; $4aa4
	pop hl			; $4aa5
	push af			; $4aa6
	ld e,d			; $4aa7
	dec c			; $4aa8
	sbc b			; $4aa9
	ld d,l			; $4aaa
	pop hl			; $4aab
	push af			; $4aac
	ld e,d			; $4aad
	dec bc			; $4aae
	ld ($ff00+$44),a	; $4aaf
	ld sp,$f8d1		; $4ab1
	ld ($ff00+$71),a	; $4ab4
	ld sp,$e1d1		; $4ab6
	push af			; $4ab9
	ld e,d			; $4aba
	dec c			; $4abb
	sbc b			; $4abc
	ld d,a			; $4abd
	pop hl			; $4abe
	push af			; $4abf
	ld e,d			; $4ac0
	dec bc			; $4ac1
	ld ($ff00+$0c),a	; $4ac2
	ld e,e			; $4ac4
	or $e0			; $4ac5
	adc l			; $4ac7
	ld h,h			; $4ac8
	di			; $4ac9
.DB $e3				; $4aca
	or h			; $4acb
	ld ($ff00+$44),a	; $4acc
	ld sp,$e3f5		; $4ace
	or h			; $4ad1
	ld ($ff00+$44),a	; $4ad2
	ld sp,$e3f5		; $4ad4
	or h			; $4ad7
	ld ($ff00+$44),a	; $4ad8
	ld sp,$f5d1		; $4ada
	pop hl			; $4add
	ld e,h			; $4ade
	ld sp,$d104		; $4adf
	sbc $0c			; $4ae2
	nop			; $4ae4
	ld hl,sp-$4a		; $4ae5
	ld h,d			; $4ae7
	ld h,d			; $4ae8
	ld b,h			; $4ae9
	cp e			; $4aea
	cp d			; $4aeb
	add b			; $4aec
	rst $38			; $4aed
	sbc b			; $4aee
	ldi a,(hl)		; $4aef
	ld (bc),a		; $4af0
.DB $e4				; $4af1
	ldh a,(<hFF8B)	; $4af2
	jr z,-$13		; $4af4
	ld de,$21ec		; $4af6
	rst $30			; $4af9
	ld ($ff00+$59),a	; $4afa
	ld e,e			; $4afc
	rst $30			; $4afd
	ld ($ff00+$5d),a	; $4afe
	ld e,e			; $4b00
	ld hl,sp-$6a		; $4b01
	stop			; $4b03
	ldh (<hFF8F),a	; $4b04
	ld e,e			; $4b06
	ld ($ff00+$2d),a	; $4b07
_label_14_069:
	ld e,e			; $4b09
	xor $11			; $4b0a
	or $91			; $4b0c
	ld ($00d0),sp		; $4b0e
	ld hl,sp-$68		; $4b11
	ldi a,(hl)		; $4b13
	inc bc			; $4b14
.DB $e4				; $4b15
	ld sp,$7dd7		; $4b16
	add b			; $4b19
	inc bc			; $4b1a
	ret nz			; $4b1b
	or c			; $4b1c
	ld h,d			; $4b1d
	ret nz			; $4b1e
	or c			; $4b1f
	ld h,d			; $4b20
	rst_addAToHl			; $4b21
	add $c0			; $4b22
	or c			; $4b24
	ld h,d			; $4b25
	ret nz			; $4b26
	or c			; $4b27
	ld h,d			; $4b28
_label_14_070:
	ld ($ff00+$64),a	; $4b29
	ld e,e			; $4b2b
.DB $e3				; $4b2c
	ld a,c			; $4b2d
	or $e0			; $4b2e
	or b			; $4b30
	ld e,e			; $4b31
	ld ($ff00+$73),a	; $4b32
	ld e,e			; $4b34
_label_14_071:
.DB $e4				; $4b35
	ld a,($ff00+$f8)	; $4b36
.DB $e3				; $4b38
	ld c,l			; $4b39
	xor e			; $4b3a
	xor a			; $4b3b
	ld hl,sp-$68		; $4b3c
	ldi a,(hl)		; $4b3e
	inc b			; $4b3f
	add b			; $4b40
_label_14_072:
	ld bc,$1096		; $4b41
.DB $e4				; $4b44
	rst $38			; $4b45
	or c			; $4b46
	ld b,b			; $4b47
	cp (hl)			; $4b48
	sub a			; $4b49
	ldi a,(hl)		; $4b4a
	dec b			; $4b4b
	sbc b			; $4b4c
_label_14_073:
	daa			; $4b4d
	ld ($1be0),sp		; $4b4e
	ld e,e			; $4b51
	adc a			; $4b52
	nop			; $4b53
	ld hl,sp-$7c		; $4b54
	ld l,a			; $4b56
_label_14_074:
	ld bc,$3838		; $4b57
.DB $e3				; $4b5a
	ld l,h			; $4b5b
.DB $f4				; $4b5c
	add b			; $4b5d
	rst $38			; $4b5e
	adc e			; $4b5f
	ld d,b			; $4b60
	xor $11			; $4b61
.DB $ed				; $4b63
	add hl,de		; $4b64
.DB $f4				; $4b65
	sub (hl)		; $4b66
	jr _label_14_069		; $4b67
	ld ($ff00+$25),a	; $4b69
	ld e,e			; $4b6b
	sub c			; $4b6c
	ld ($00d0),sp		; $4b6d
_label_14_075:
	rst $28			; $4b70
	add hl,de		; $4b71
.DB $ec				; $4b72
	add hl,de		; $4b73
	push af			; $4b74
	sub (hl)		; $4b75
	ld ($96f5),sp		; $4b76
	jr _label_14_075		; $4b79
	xor c			; $4b7b
	ldh a,(<hGameboyType)	; $4b7c
	stop			; $4b7e
	sbc b			; $4b7f
	daa			; $4b80
	add hl,bc		; $4b81
	xor d			; $4b82
	adc h			; $4b83
	ld sp,$0891		; $4b84
	ret nc			; $4b87
	ld (bc),a		; $4b88
	cp (hl)			; $4b89
	ld ($ff00+$d5),a	; $4b8a
	ld e,e			; $4b8c
	nop			; $4b8d
	or $98			; $4b8e
	ld hl,$7f8e		; $4b90
	ld bc,$508b		; $4b93
	rst $28			; $4b96
	ld de,$6ee3		; $4b97
	adc e			; $4b9a
	jr z,_label_14_070	; $4b9b
	ld de,$508b		; $4b9d
	adc h			; $4ba0
	add hl,bc		; $4ba1
.DB $ec				; $4ba2
	dec d			; $4ba3
.DB $e3				; $4ba4
	ret nc			; $4ba5
	adc c			; $4ba6
	jr _label_14_071		; $4ba7
	dec b			; $4ba9
.DB $e3				; $4baa
	ret nc			; $4bab
	adc c			; $4bac
	ld ($098c),sp		; $4bad
.DB $e3				; $4bb0
	ret nc			; $4bb1
	adc c			; $4bb2
	jr _label_14_072		; $4bb3
	add hl,bc		; $4bb5
.DB $e3				; $4bb6
	ret nc			; $4bb7
	adc c			; $4bb8
	ld ($098c),sp		; $4bb9
.DB $e3				; $4bbc
	ret nc			; $4bbd
	adc c			; $4bbe
	jr _label_14_073		; $4bbf
	dec b			; $4bc1
	xor $15			; $4bc2
.DB $ed				; $4bc4
	add hl,bc		; $4bc5
.DB $e3				; $4bc6
	ld l,(hl)		; $4bc7
	adc e			; $4bc8
	jr z,_label_14_074	; $4bc9
	ld de,$508b		; $4bcb
	adc h			; $4bce
	ld de,$008f		; $4bcf
	sbc b			; $4bd2
	ldi (hl),a		; $4bd3
	adc a			; $4bd4
	ld (bc),a		; $4bd5
	sbc b			; $4bd6
	inc hl			; $4bd7
	cp l			; $4bd8
	sbc $41			; $4bd9
	inc b			; $4bdb
	or c			; $4bdc
	ld b,b			; $4bdd
	adc (hl)		; $4bde
	ld a,a			; $4bdf
	nop			; $4be0
	cp (hl)			; $4be1
	ld h,l			; $4be2
	ld l,h			; $4be3
	sbc b			; $4be4
	ld bc,$b102		; $4be5
	add b			; $4be8
	cp b			; $4be9
	sub c			; $4bea
	ld ($03d0),sp		; $4beb
	add b			; $4bee
	rst $38			; $4bef
	adc e			; $4bf0
	ld d,b			; $4bf1
	rst $28			; $4bf2
	ld hl,$1096		; $4bf3
	or $8b			; $4bf6
	jr z,-$20		; $4bf8
	ld b,l			; $4bfa
	ld e,l			; $4bfb
	adc h			; $4bfc
	ld a,(bc)		; $4bfd
	adc a			; $4bfe
	inc b			; $4bff
	or $8f			; $4c00
	ld (bc),a		; $4c02
	add b			; $4c03
	rst $38			; $4c04
	nop			; $4c05
	sub c			; $4c06
	rst_addDoubleIndex			; $4c07
	rst $8			; $4c08
	nop			; $4c09
	add h			; $4c0a
	ld l,d			; $4c0b
	inc bc			; $4c0c
	nop			; $4c0d
	nop			; $4c0e
	adc a			; $4c0f
	dec b			; $4c10
	sub c			; $4c11
	rst_addDoubleIndex			; $4c12
	rst $8			; $4c13
	ld bc,$98f2		; $4c14
	ld bc,$8f05		; $4c17
	dec b			; $4c1a
.DB $e3				; $4c1b
	jp z,$20e0		; $4c1c
	ld e,l			; $4c1f
	push de			; $4c20
	pop de			; $4c21
	rst $8			; $4c22
	nop			; $4c23
	rst_addAToHl			; $4c24
	ldd (hl),a		; $4c25
	adc a			; $4c26
	ld b,$91		; $4c27
	rst_addDoubleIndex			; $4c29
	rst $8			; $4c2a
	ld (bc),a		; $4c2b
	ld a,($ff00+c)		; $4c2c
	sbc b			; $4c2d
	ld bc,$8f06		; $4c2e
	ld b,$e3		; $4c31
	set 4,b			; $4c33
	add hl,hl		; $4c35
	ld e,l			; $4c36
	push de			; $4c37
	pop de			; $4c38
	rst $8			; $4c39
	nop			; $4c3a
	rst_addAToHl			; $4c3b
	ldd (hl),a		; $4c3c
	adc a			; $4c3d
	inc b			; $4c3e
	sub c			; $4c3f
	rst_addDoubleIndex			; $4c40
	rst $8			; $4c41
	inc bc			; $4c42
	ld a,($ff00+c)		; $4c43
	sbc b			; $4c44
	ld bc,$8f07		; $4c45
	inc b			; $4c48
.DB $e3				; $4c49
	call $32e0		; $4c4a
	ld e,l			; $4c4d
	push de			; $4c4e
	pop de			; $4c4f
	rst $8			; $4c50
	nop			; $4c51
	rst_addAToHl			; $4c52
	ldd (hl),a		; $4c53
	sub c			; $4c54
	rst_addDoubleIndex			; $4c55
	rst $8			; $4c56
	rst $38			; $4c57
	adc a			; $4c58
	ld bc,$0198		; $4c59
	ld (multiplyABy4),sp		; $4c5c
	ld b,c			; $4c5f
	ld h,(hl)		; $4c60
	sbc b			; $4c61
	ld bc,$d509		; $4c62
	and b			; $4c65
	rlc b			; $4c66
	ld h,(hl)		; $4c68
	dec sp			; $4c69
	ld bc,$021e		; $4c6a
	ld (hl),b		; $4c6d
	inc b			; $4c6e
	inc d			; $4c6f
.DB $fd				; $4c70
	and b			; $4c71
	ld (bc),a		; $4c72
	inc b			; $4c73
	dec d			; $4c74
.DB $fd				; $4c75
	and b			; $4c76
	ld (bc),a		; $4c77
	inc b			; $4c78
	ld d,$fd		; $4c79
	and b			; $4c7b
	ld (bc),a		; $4c7c
	ld bc,$021e		; $4c7d
	ld (hl),b		; $4c80
	dec b			; $4c81
	inc bc			; $4c82
	inc d			; $4c83
.DB $fd				; $4c84
	ld bc,$021e		; $4c85
	jp nz,$0307		; $4c88
	inc b			; $4c8b
	cp $00			; $4c8c
	ld bc,$050f		; $4c8e
	inc bc			; $4c91
	inc b			; $4c92
	cp $01			; $4c93
	rrca			; $4c95
	rlca			; $4c96
	inc bc			; $4c97
	inc d			; $4c98
	cp $00			; $4c99
	dec b			; $4c9b
	inc bc			; $4c9c
	inc b			; $4c9d
	rst $38			; $4c9e
	ld bc,$050f		; $4c9f
	inc bc			; $4ca2
	inc d			; $4ca3
	cp $01			; $4ca4
	rrca			; $4ca6
	rlca			; $4ca7
	inc bc			; $4ca8
	inc h			; $4ca9
	cp $00			; $4caa
	dec b			; $4cac
	inc bc			; $4cad
	inc d			; $4cae
	rst $38			; $4caf
	ld bc,$050f		; $4cb0
	inc bc			; $4cb3
	inc h			; $4cb4
	cp $01			; $4cb5
	rrca			; $4cb7
	rlca			; $4cb8
	inc bc			; $4cb9
	inc (hl)		; $4cba
	cp $00			; $4cbb
	dec b			; $4cbd
	inc bc			; $4cbe
	inc h			; $4cbf
	rst $38			; $4cc0
	ld bc,$050f		; $4cc1
	inc bc			; $4cc4
	inc (hl)		; $4cc5
	cp $01			; $4cc6
	rrca			; $4cc8
	rlca			; $4cc9
	inc bc			; $4cca
	ld b,h			; $4ccb
	cp $00			; $4ccc
	dec b			; $4cce
	inc bc			; $4ccf
	inc (hl)		; $4cd0
	rst $38			; $4cd1
	ld bc,$050f		; $4cd2
	inc bc			; $4cd5
	ld b,h			; $4cd6
	cp $01			; $4cd7
	rrca			; $4cd9
	rlca			; $4cda
	inc bc			; $4cdb
	ld d,h			; $4cdc
	cp $00			; $4cdd
	dec b			; $4cdf
	inc bc			; $4ce0
	ld b,h			; $4ce1
	rst $38			; $4ce2
	ld bc,$050f		; $4ce3
	inc bc			; $4ce6
	ld d,h			; $4ce7
	cp $01			; $4ce8
	rrca			; $4cea
	rlca			; $4ceb
	inc bc			; $4cec
	ld h,h			; $4ced
	cp $00			; $4cee
	dec b			; $4cf0
	inc bc			; $4cf1
	ld d,h			; $4cf2
	rst $38			; $4cf3
	ld bc,$050f		; $4cf4
	inc bc			; $4cf7
	ld h,h			; $4cf8
	cp $01			; $4cf9
	rrca			; $4cfb
	rlca			; $4cfc
	inc bc			; $4cfd
	ld (hl),h		; $4cfe
	cp $00			; $4cff
	dec b			; $4d01
	inc bc			; $4d02
	ld h,h			; $4d03
	rst $38			; $4d04
	ld bc,$050f		; $4d05
	inc bc			; $4d08
	ld (hl),h		; $4d09
	cp $01			; $4d0a
	rrca			; $4d0c
	dec b			; $4d0d
	inc bc			; $4d0e
	ld (hl),h		; $4d0f
	rst $38			; $4d10
	ld bc,$013c		; $4d11
	rrca			; $4d14
	rlca			; $4d15
	inc bc			; $4d16
	inc b			; $4d17
	ld a,($0100)		; $4d18
	rrca			; $4d1b
	dec b			; $4d1c
	inc bc			; $4d1d
	inc b			; $4d1e
	ld a,($0f01)		; $4d1f
	rlca			; $4d22
	inc bc			; $4d23
	inc d			; $4d24
	ld a,($0100)		; $4d25
	rrca			; $4d28
	dec b			; $4d29
	inc bc			; $4d2a
	inc d			; $4d2b
	ld a,($0f01)		; $4d2c
	rlca			; $4d2f
	inc bc			; $4d30
	inc h			; $4d31
	ld a,($0100)		; $4d32
	rrca			; $4d35
	dec b			; $4d36
	inc bc			; $4d37
	inc h			; $4d38
	ld a,($0f01)		; $4d39
	rlca			; $4d3c
	inc bc			; $4d3d
	inc (hl)		; $4d3e
	ld a,($0100)		; $4d3f
	rrca			; $4d42
	dec b			; $4d43
	inc bc			; $4d44
	inc (hl)		; $4d45
	ld a,($0f01)		; $4d46
	rlca			; $4d49
	inc bc			; $4d4a
	ld b,h			; $4d4b
	ld a,($0100)		; $4d4c
	rrca			; $4d4f
	dec b			; $4d50
	inc bc			; $4d51
	ld b,h			; $4d52
	ld a,($0f01)		; $4d53
	rlca			; $4d56
	inc bc			; $4d57
	ld d,h			; $4d58
	ld a,($0100)		; $4d59
	rrca			; $4d5c
	dec b			; $4d5d
	inc bc			; $4d5e
	ld d,h			; $4d5f
	ld a,($0f01)		; $4d60
	rlca			; $4d63
	inc bc			; $4d64
	ld h,h			; $4d65
	ld a,($0100)		; $4d66
	rrca			; $4d69
	dec b			; $4d6a
	inc bc			; $4d6b
	ld h,h			; $4d6c
	ld a,($0f01)		; $4d6d
	rlca			; $4d70
	inc bc			; $4d71
	ld (hl),h		; $4d72
	ld a,($0100)		; $4d73
	rrca			; $4d76
	dec b			; $4d77
	inc bc			; $4d78
	ld (hl),h		; $4d79
	ld a,($b401)		; $4d7a
	ld (bc),a		; $4d7d
	pop af			; $4d7e
	nop			; $4d7f
	ld (bc),a		; $4d80
	jp nz,$1401		; $4d81
	inc b			; $4d84
	ld h,d			; $4d85
	ld b,l			; $4d86
	rst $38			; $4d87
	ld (bc),a		; $4d88
	inc b			; $4d89
	ld h,e			; $4d8a
	ld d,h			; $4d8b
	rst $38			; $4d8c
	ld (bc),a		; $4d8d
	inc b			; $4d8e
	ld h,h			; $4d8f
	ld b,(hl)		; $4d90
	rst $38			; $4d91
	ld (bc),a		; $4d92
	ld bc,$0314		; $4d93
	ld h,d			; $4d96
	ld b,l			; $4d97
	inc bc			; $4d98
	ld h,e			; $4d99
	ld d,h			; $4d9a
	inc bc			; $4d9b
	ld h,h			; $4d9c
	ld b,(hl)		; $4d9d
	ld bc,$0414		; $4d9e
	ld (hl),d		; $4da1
	ld b,l			; $4da2
	rst $38			; $4da3
	ld (bc),a		; $4da4
	inc b			; $4da5
	ld (hl),e		; $4da6
	ld d,h			; $4da7
	rst $38			; $4da8
	ld (bc),a		; $4da9
	inc b			; $4daa
	ld (hl),h		; $4dab
	ld b,(hl)		; $4dac
	rst $38			; $4dad
	ld (bc),a		; $4dae
	ld bc,$0314		; $4daf
	ld (hl),d		; $4db2
	ld b,l			; $4db3
	inc bc			; $4db4
	ld (hl),e		; $4db5
	ld d,h			; $4db6
	inc bc			; $4db7
	ld (hl),h		; $4db8
	ld b,(hl)		; $4db9
	ld bc,$000a		; $4dba
	inc b			; $4dbd
	ld (bc),a		; $4dbe
	or (hl)			; $4dbf
	rst $38			; $4dc0
	ld (bc),a		; $4dc1
	inc b			; $4dc2
	inc bc			; $4dc3
	or a			; $4dc4
	rst $38			; $4dc5
	ld (bc),a		; $4dc6
	inc b			; $4dc7
	inc b			; $4dc8
	cp b			; $4dc9
	rst $38			; $4dca
	ld (bc),a		; $4dcb
	ld bc,$0314		; $4dcc
	ld (bc),a		; $4dcf
	or (hl)			; $4dd0
	inc bc			; $4dd1
	inc bc			; $4dd2
	or a			; $4dd3
	inc bc			; $4dd4
	inc b			; $4dd5
	cp b			; $4dd6
	ld bc,$0414		; $4dd7
	ld (de),a		; $4dda
	ld l,e			; $4ddb
	rst $38			; $4ddc
	ld (bc),a		; $4ddd
	inc b			; $4dde
	inc de			; $4ddf
	xor $ff			; $4de0
	ld (bc),a		; $4de2
	inc b			; $4de3
	inc d			; $4de4
	ld l,e			; $4de5
	rst $38			; $4de6
	ld (bc),a		; $4de7
	ld bc,$0314		; $4de8
	ld (de),a		; $4deb
	ld l,e			; $4dec
	inc bc			; $4ded
	inc de			; $4dee
	xor $03			; $4def
	inc d			; $4df1
	ld l,e			; $4df2
	ld bc,$0414		; $4df3
	ldi (hl),a		; $4df6
	ld l,e			; $4df7
	rst $38			; $4df8
	ld (bc),a		; $4df9
	inc b			; $4dfa
	inc hl			; $4dfb
	call z,$02ff		; $4dfc
	inc b			; $4dff
	inc h			; $4e00
	ld l,e			; $4e01
	rst $38			; $4e02
	ld (bc),a		; $4e03
	ld bc,$0314		; $4e04
	ldi (hl),a		; $4e07
	ld l,e			; $4e08
	inc bc			; $4e09
	inc hl			; $4e0a
	call z,$2403		; $4e0b
	ld l,e			; $4e0e
	ld bc,$003c		; $4e0f
	ld bc,$0228		; $4e12
	ld (hl),b		; $4e15
	inc b			; $4e16
	ld b,e			; $4e17
.DB $fd				; $4e18
	dec l			; $4e19
	inc bc			; $4e1a
	inc b			; $4e1b
	ld b,h			; $4e1c
.DB $fd				; $4e1d
	dec l			; $4e1e
	ld bc,$5304		; $4e1f
.DB $fd				; $4e22
	ld l,$03		; $4e23
	inc b			; $4e25
	ld d,h			; $4e26
.DB $fd				; $4e27
	ld l,$01		; $4e28
	ld bc,$0228		; $4e2a
	ld (hl),b		; $4e2d
	inc bc			; $4e2e
	ld b,e			; $4e2f
	dec l			; $4e30
	inc bc			; $4e31
	ld b,h			; $4e32
_label_14_076:
	dec l			; $4e33
	inc bc			; $4e34
	ld d,e			; $4e35
	ld l,$03		; $4e36
	ld d,h			; $4e38
	ld l,$01		; $4e39
	jr z,_label_14_078	; $4e3b
	ld c,l			; $4e3d
_label_14_077:
	nop			; $4e3e
_label_14_078:
	adc b			; $4e3f
	ld c,b			; $4e40
	or b			; $4e41
	or c			; $4e42
	ld b,b			; $4e43
	ld hl,sp-$7f		; $4e44
	inc bc			; $4e46
	adc e			; $4e47
	ld d,b			; $4e48
	rst $28			; $4e49
_label_14_079:
	add hl,sp		; $4e4a
.DB $ec				; $4e4b
	add hl,de		; $4e4c
	add c			; $4e4d
	ld (bc),a		; $4e4e
	adc a			; $4e4f
	ld (bc),a		; $4e50
_label_14_080:
	sbc b			; $4e51
_label_14_081:
	ld h,$00		; $4e52
	ld h,a			; $4e54
	inc hl			; $4e55
	adc e			; $4e56
	ld d,b			; $4e57
	adc a			; $4e58
	ld (bc),a		; $4e59
	add c			; $4e5a
	ld (bc),a		; $4e5b
_label_14_082:
	ld hl,sp-$68		; $4e5c
	ld h,$02		; $4e5e
	ld h,a			; $4e60
	inc hl			; $4e61
.DB $ec				; $4e62
_label_14_083:
	jr nz,_label_14_081	; $4e63
	stop			; $4e65
	ret nz			; $4e66
	add b			; $4e67
	ld h,a			; $4e68
	xor $30			; $4e69
_label_14_084:
	rst $28			; $4e6b
	ld b,b			; $4e6c
	ret nz			; $4e6d
	sub (hl)		; $4e6e
_label_14_085:
	ld h,a			; $4e6f
.DB $ec				; $4e70
	jr nc,_label_14_076	; $4e71
	ld (hl),l		; $4e73
	ld h,a			; $4e74
.DB $ec				; $4e75
	ld b,h			; $4e76
	xor b			; $4e77
	nop			; $4e78
.DB $ec				; $4e79
	jr nz,_label_14_084	; $4e7a
	jr nc,_label_14_077	; $4e7c
_label_14_086:
	sub (hl)		; $4e7e
	ld h,a			; $4e7f
	xor $30			; $4e80
	ret nz			; $4e82
	adc e			; $4e83
	ld h,a			; $4e84
.DB $ed				; $4e85
_label_14_087:
	ld b,b			; $4e86
.DB $ec				; $4e87
	jr nc,_label_14_079	; $4e88
	ld (hl),l		; $4e8a
	ld h,a			; $4e8b
.DB $ec				; $4e8c
_label_14_088:
	jr nc,_label_14_086	; $4e8d
	jr nc,_label_14_080	; $4e8f
	sub (hl)		; $4e91
	ld h,a			; $4e92
.DB $ec				; $4e93
_label_14_089:
	inc h			; $4e94
	xor b			; $4e95
	nop			; $4e96
.DB $ec				; $4e97
	stop			; $4e98
.DB $ed				; $4e99
	jr nc,_label_14_082	; $4e9a
	add b			; $4e9c
	ld h,a			; $4e9d
	xor $30			; $4e9e
	rst $28			; $4ea0
	jr nc,_label_14_083	; $4ea1
	sub (hl)		; $4ea3
	ld h,a			; $4ea4
	rst $28			; $4ea5
	jr nc,_label_14_089	; $4ea6
	ld d,b			; $4ea8
	ret nz			; $4ea9
	ld (hl),l		; $4eaa
_label_14_090:
	ld h,a			; $4eab
.DB $ed				; $4eac
	jr nc,_label_14_085	; $4ead
	add b			; $4eaf
	ld h,a			; $4eb0
	xor $10			; $4eb1
_label_14_091:
.DB $ed				; $4eb3
	ld b,b			; $4eb4
	ret nz			; $4eb5
	add b			; $4eb6
_label_14_092:
	ld h,a			; $4eb7
.DB $ec				; $4eb8
	jr nc,-$40		; $4eb9
	ld (hl),l		; $4ebb
	ld h,a			; $4ebc
.DB $ec				; $4ebd
	inc d			; $4ebe
_label_14_093:
	xor b			; $4ebf
	nop			; $4ec0
.DB $ec				; $4ec1
	jr nc,_label_14_091	; $4ec2
	jr nc,_label_14_087	; $4ec4
	sub (hl)		; $4ec6
	ld h,a			; $4ec7
	xor $50			; $4ec8
.DB $ed				; $4eca
	jr nc,_label_14_088	; $4ecb
	add b			; $4ecd
	ld h,a			; $4ece
.DB $ec				; $4ecf
	jr nc,_label_14_093	; $4ed0
	jr nc,_label_14_089	; $4ed2
	add b			; $4ed4
	ld h,a			; $4ed5
	xor $30			; $4ed6
_label_14_094:
	rst $28			; $4ed8
	jr nc,-$40		; $4ed9
	sub (hl)		; $4edb
	ld h,a			; $4edc
.DB $ec				; $4edd
	ld d,b			; $4ede
	ret nz			; $4edf
	ld (hl),l		; $4ee0
	ld h,a			; $4ee1
.DB $ec				; $4ee2
	inc (hl)		; $4ee3
	xor b			; $4ee4
	nop			; $4ee5
.DB $ec				; $4ee6
	jr nz,_label_14_094	; $4ee7
	jr nc,_label_14_090	; $4ee9
	sub (hl)		; $4eeb
	ld h,a			; $4eec
	xor $30			; $4eed
.DB $ed				; $4eef
	ld b,b			; $4ef0
	ret nz			; $4ef1
_label_14_095:
	add b			; $4ef2
	ld h,a			; $4ef3
.DB $ec				; $4ef4
	jr nc,_label_14_092	; $4ef5
	ld (hl),l		; $4ef7
	ld h,a			; $4ef8
	rst $28			; $4ef9
	ld b,b			; $4efa
	ret nz			; $4efb
	sub (hl)		; $4efc
	ld h,a			; $4efd
	rst $28			; $4efe
	inc (hl)		; $4eff
	ld h,a			; $4f00
	ld l,c			; $4f01
.DB $ec				; $4f02
	jr nz,_label_14_095	; $4f03
	stop			; $4f05
	ret nz			; $4f06
	add b			; $4f07
	ld h,a			; $4f08
	xor $30			; $4f09
	rst $28			; $4f0b
	ld b,b			; $4f0c
	ret nz			; $4f0d
	sub (hl)		; $4f0e
	ld h,a			; $4f0f
.DB $ec				; $4f10
	ld b,b			; $4f11
	xor $10			; $4f12
	ret nz			; $4f14
	sub (hl)		; $4f15
	ld h,a			; $4f16
	rst $28			; $4f17
	inc (hl)		; $4f18
_label_14_096:
	ld h,a			; $4f19
	ld l,c			; $4f1a
	or $ed			; $4f1b
	inc d			; $4f1d
	or $c0			; $4f1e
	ld (hl),l		; $4f20
	ld h,a			; $4f21
	rst $28			; $4f22
	inc d			; $4f23
_label_14_097:
	xor b			; $4f24
	nop			; $4f25
	cp l			; $4f26
_label_14_098:
.DB $e4				; $4f27
	rst $38			; $4f28
.DB $e3				; $4f29
	ld c,l			; $4f2a
_label_14_099:
	ldh (<hIntroInputsEnabled),a	; $4f2b
	ld e,l			; $4f2d
	add c			; $4f2e
	inc bc			; $4f2f
_label_14_100:
	adc e			; $4f30
	jr z,-$6a		; $4f31
	jr _label_14_099		; $4f33
	rst $28			; $4f35
	jr nz,_label_14_097	; $4f36
	jr nz,-$71		; $4f38
	ld (bc),a		; $4f3a
	or $e3			; $4f3b
	adc l			; $4f3d
	add sp,-$3b		; $4f3e
	or c			; $4f40
	ld b,b			; $4f41
	cp (hl)			; $4f42
	nop			; $4f43
	add c			; $4f44
	ld (bc),a		; $4f45
	cp b			; $4f46
	adc e			; $4f47
	ld d,b			; $4f48
	sub (hl)		; $4f49
	stop			; $4f4a
	sbc b			; $4f4b
	ld h,$01		; $4f4c
	add c			; $4f4e
	dec b			; $4f4f
	nop			; $4f50
	xor $40			; $4f51
	ret nz			; $4f53
	dec bc			; $4f54
	ld l,d			; $4f55
_label_14_101:
.DB $ed				; $4f56
	jr nc,_label_14_096	; $4f57
	jr nz,$6a		; $4f59
	xor $18			; $4f5b
	ret nz			; $4f5d
	dec bc			; $4f5e
	ld l,d			; $4f5f
	xor $20			; $4f60
	xor c			; $4f62
_label_14_102:
	nop			; $4f63
.DB $ec				; $4f64
	jr nz,_label_14_098	; $4f65
	cp $69			; $4f67
.DB $ed				; $4f69
	jr nc,-$12		; $4f6a
	stop			; $4f6c
.DB $ed				; $4f6d
	jr nc,_label_14_100	; $4f6e
	jr nz,_label_14_116	; $4f70
	rst $28			; $4f72
	jr nc,_label_14_102	; $4f73
	jr nz,-$11		; $4f75
_label_14_103:
	jr nc,-$40		; $4f77
	inc de			; $4f79
	ld l,d			; $4f7a
	xor $40			; $4f7b
	xor c			; $4f7d
_label_14_104:
	nop			; $4f7e
	adc b			; $4f7f
_label_14_105:
	jr z,-$78		; $4f80
_label_14_106:
	ld ($ff00+$4e),a	; $4f82
	ld e,(hl)		; $4f84
	sub (hl)		; $4f85
	jr _label_14_105		; $4f86
	rst $28			; $4f88
	stop			; $4f89
_label_14_107:
	xor $20			; $4f8a
	ret nz			; $4f8c
_label_14_108:
	dec bc			; $4f8d
	ld l,d			; $4f8e
	xor $10			; $4f8f
_label_14_109:
	rst $28			; $4f91
	jr nc,_label_14_106	; $4f92
	jr nz,_label_14_101	; $4f94
	dec bc			; $4f96
	ld l,d			; $4f97
	rst $28			; $4f98
	jr nc,-$14		; $4f99
	jr nc,_label_14_107	; $4f9b
	jr nz,-$14		; $4f9d
	jr nc,-$40		; $4f9f
_label_14_110:
	cp $69			; $4fa1
_label_14_111:
.DB $ed				; $4fa3
	stop			; $4fa4
	xor $80			; $4fa5
	xor c			; $4fa7
_label_14_112:
	nop			; $4fa8
	adc b			; $4fa9
	ld a,b			; $4faa
	jr c,_label_14_108	; $4fab
	ld c,(hl)		; $4fad
	ld e,(hl)		; $4fae
	sub (hl)		; $4faf
	ld ($edf8),sp		; $4fb0
	jr nc,_label_14_110	; $4fb3
_label_14_113:
	jr nz,_label_14_103	; $4fb5
	cp $69			; $4fb7
	rst $28			; $4fb9
	jr nz,_label_14_112	; $4fba
	jr nc,_label_14_104	; $4fbc
	cp $69			; $4fbe
	ld sp,hl		; $4fc0
.DB $ed				; $4fc1
	jr nc,-$12		; $4fc2
	jr nc,_label_14_113	; $4fc4
	stop			; $4fc6
	xor $40			; $4fc7
	xor c			; $4fc9
	nop			; $4fca
	adc b			; $4fcb
_label_14_114:
	jr c,_label_14_101	; $4fcc
	ld ($ff00+$4e),a	; $4fce
	ld e,(hl)		; $4fd0
	sub (hl)		; $4fd1
	jr _label_14_114		; $4fd2
	rst $28			; $4fd4
	ld d,b			; $4fd5
	sub (hl)		; $4fd6
_label_14_115:
	ld ($96f8),sp		; $4fd7
	jr _label_14_115		; $4fda
_label_14_116:
	rst $28			; $4fdc
	stop			; $4fdd
.DB $ec				; $4fde
_label_14_117:
	stop			; $4fdf
	rst $28			; $4fe0
	jr nz,_label_14_111	; $4fe1
	inc de			; $4fe3
	ld l,d			; $4fe4
	rst $28			; $4fe5
	jr nz,_label_14_109	; $4fe6
	nop			; $4fe8
_label_14_118:
	adc b			; $4fe9
_label_14_119:
	jr c,_label_14_124	; $4fea
	ld ($ff00+$4e),a	; $4fec
	ld e,(hl)		; $4fee
	sub (hl)		; $4fef
	jr _label_14_119		; $4ff0
	rst $28			; $4ff2
_label_14_120:
	stop			; $4ff3
	ret nz			; $4ff4
_label_14_121:
	inc de			; $4ff5
_label_14_122:
	ld l,d			; $4ff6
_label_14_123:
.DB $ec				; $4ff7
	jr nz,_label_14_118	; $4ff8
	stop			; $4ffa
	ret nz			; $4ffb
	inc de			; $4ffc
	ld l,d			; $4ffd
.DB $ed				; $4ffe
	jr nz,-$14		; $4fff
	stop			; $5001
.DB $ed				; $5002
	jr nc,_label_14_120	; $5003
	jr nc,_label_14_122	; $5005
	jr nc,_label_14_121	; $5007
	stop			; $5009
	rst $28			; $500a
	jr nz,-$40		; $500b
	inc de			; $500d
	ld l,d			; $500e
	rst $28			; $500f
	jr nz,-$57		; $5010
	nop			; $5012
	adc b			; $5013
_label_14_124:
	jr c,_label_14_135	; $5014
	ld ($ff00+$4e),a	; $5016
	ld e,(hl)		; $5018
	sub (hl)		; $5019
_label_14_125:
	nop			; $501a
_label_14_126:
	ld hl,sp-$14		; $501b
	jr nz,_label_14_117	; $501d
	cp $69			; $501f
	ei			; $5021
.DB $ed				; $5022
	ld b,b			; $5023
	ret nz			; $5024
	jr nz,_label_14_140	; $5025
	ld hl,sp-$12		; $5027
	jr nz,_label_14_125	; $5029
	jr nz,_label_14_126	; $502b
	stop			; $502d
	ret nz			; $502e
	dec bc			; $502f
	ld l,d			; $5030
_label_14_127:
	rst $28			; $5031
	ld d,b			; $5032
_label_14_128:
	ret nz			; $5033
_label_14_129:
	inc de			; $5034
	ld l,d			; $5035
_label_14_130:
.DB $ec				; $5036
	ld h,b			; $5037
_label_14_131:
	xor c			; $5038
_label_14_132:
	nop			; $5039
	adc b			; $503a
	ld ($e018),sp		; $503b
	ld c,(hl)		; $503e
	ld e,(hl)		; $503f
	sub (hl)		; $5040
	stop			; $5041
	ld hl,sp-$12		; $5042
	jr nc,_label_14_128	; $5044
	jr nz,_label_14_129	; $5046
	jr nz,_label_14_132	; $5048
	jr nz,_label_14_131	; $504a
	jr nz,_label_14_123	; $504c
	nop			; $504e
	adc b			; $504f
	ld ($e038),sp		; $5050
	ld c,(hl)		; $5053
	ld e,(hl)		; $5054
	sub (hl)		; $5055
	ld ($edf8),sp		; $5056
	ld b,b			; $5059
_label_14_133:
	xor $60			; $505a
	ret nz			; $505c
_label_14_134:
	dec bc			; $505d
_label_14_135:
	ld l,d			; $505e
	rst $28			; $505f
	ld h,b			; $5060
	ret nz			; $5061
	inc de			; $5062
_label_14_136:
	ld l,d			; $5063
.DB $ec				; $5064
	ld h,b			; $5065
	ret nz			; $5066
	cp $69			; $5067
.DB $ec				; $5069
	jr nz,-$57		; $506a
	nop			; $506c
	adc b			; $506d
_label_14_137:
	ld ($e088),sp		; $506e
	ld c,(hl)		; $5071
	ld e,(hl)		; $5072
	sub (hl)		; $5073
	jr _label_14_137		; $5074
	xor $60			; $5076
	ret nz			; $5078
_label_14_138:
	dec bc			; $5079
	ld l,d			; $507a
	rst $28			; $507b
	ld (hl),b		; $507c
	ret nz			; $507d
	inc de			; $507e
	ld l,d			; $507f
.DB $ec				; $5080
	ld h,b			; $5081
	ret nz			; $5082
	cp $69			; $5083
.DB $ec				; $5085
	jr nz,_label_14_127	; $5086
	nop			; $5088
	adc b			; $5089
	jr _label_14_124		; $508a
_label_14_139:
	ld ($ff00+$4e),a	; $508c
	ld e,(hl)		; $508e
	sub (hl)		; $508f
	stop			; $5090
_label_14_140:
	ld hl,sp-$12		; $5091
	ld h,b			; $5093
	ret nz			; $5094
	dec bc			; $5095
_label_14_141:
	ld l,d			; $5096
	rst $28			; $5097
	jr nc,_label_14_133	; $5098
	inc de			; $509a
	ld l,d			; $509b
.DB $ec				; $509c
	jr nc,_label_14_139	; $509d
	stop			; $509f
.DB $ec				; $50a0
	jr nc,_label_14_136	; $50a1
	cp $69			; $50a3
.DB $ed				; $50a5
_label_14_142:
	jr nz,_label_14_141	; $50a6
	add b			; $50a8
	xor c			; $50a9
	nop			; $50aa
	adc b			; $50ab
	jr _label_14_130		; $50ac
	ld ($ff00+$4e),a	; $50ae
	ld e,(hl)		; $50b0
	sub (hl)		; $50b1
	stop			; $50b2
	ld hl,sp-$12		; $50b3
_label_14_143:
	jr nc,_label_14_142	; $50b5
	jr nc,_label_14_138	; $50b7
	inc de			; $50b9
	ld l,d			; $50ba
	xor $30			; $50bb
	ret nz			; $50bd
	dec bc			; $50be
	ld l,d			; $50bf
.DB $ed				; $50c0
	jr nc,-$14		; $50c1
	jr nc,-$11		; $50c3
	jr nc,_label_14_143	; $50c5
	ld d,b			; $50c7
	xor c			; $50c8
	nop			; $50c9
	adc b			; $50ca
	ld c,b			; $50cb
	jr c,_label_14_134	; $50cc
	inc bc			; $50ce
	and b			; $50cf
	xor $50			; $50d0
	nop			; $50d2
	adc $a0			; $50d3
	sub c			; $50d5
	xor e			; $50d6
	call z,$f801		; $50d7
.DB $e3				; $50da
	ld c,l			; $50db
	ld hl,sp-$1d		; $50dc
	ld (hl),e		; $50de
	pop hl			; $50df
	or h			; $50e0
	ld h,c			; $50e1
	inc b			; $50e2
	di			; $50e3
.DB $e3				; $50e4
	ld (hl),e		; $50e5
	pop hl			; $50e6
	or h			; $50e7
	ld h,c			; $50e8
	dec b			; $50e9
	pop hl			; $50ea
	or h			; $50eb
	ld h,c			; $50ec
	inc bc			; $50ed
	di			; $50ee
.DB $e3				; $50ef
	ld (hl),e		; $50f0
	pop hl			; $50f1
	or h			; $50f2
	ld h,c			; $50f3
	ld bc,$b4e1		; $50f4
	ld h,c			; $50f7
	rlca			; $50f8
	di			; $50f9
.DB $e3				; $50fa
	ld (hl),e		; $50fb
	pop hl			; $50fc
	or h			; $50fd
	ld h,c			; $50fe
	nop			; $50ff
	pop hl			; $5100
	or h			; $5101
	ld h,c			; $5102
	ld ($e3f3),sp		; $5103
	ld (hl),e		; $5106
	pop hl			; $5107
	or h			; $5108
	ld h,c			; $5109
	ld (bc),a		; $510a
	pop hl			; $510b
	or h			; $510c
	ld h,c			; $510d
	ld b,$f3		; $510e
.DB $e3				; $5110
	ld (hl),e		; $5111
	pop hl			; $5112
	or h			; $5113
	ld h,c			; $5114
	ld bc,$b4e1		; $5115
	ld h,c			; $5118
	dec b			; $5119
	pop hl			; $511a
	or h			; $511b
	ld h,c			; $511c
	inc bc			; $511d
	pop hl			; $511e
	or h			; $511f
	ld h,c			; $5120
	rlca			; $5121
	di			; $5122
.DB $e3				; $5123
	ld (hl),e		; $5124
	pop hl			; $5125
	or h			; $5126
	ld h,c			; $5127
	inc b			; $5128
	pop hl			; $5129
	or h			; $512a
	ld h,c			; $512b
	nop			; $512c
	pop hl			; $512d
	or h			; $512e
	ld h,c			; $512f
	ld (bc),a		; $5130
	pop hl			; $5131
	or h			; $5132
	ld h,c			; $5133
	ld b,$e1		; $5134
	or h			; $5136
	ld h,c			; $5137
	ld ($22e7),sp		; $5138
	rrca			; $513b
	rst $20			; $513c
	inc hl			; $513d
	ld de,$32e7		; $513e
	ld de,$33e7		; $5141
_label_14_144:
	rrca			; $5144
	rst $20			; $5145
	inc (hl)		; $5146
	ld de,$e3f4		; $5147
	ld (hl),e		; $514a
	pop hl			; $514b
	or h			; $514c
	ld h,c			; $514d
	ld bc,$b4e1		; $514e
	ld h,c			; $5151
	dec b			; $5152
	pop hl			; $5153
	or h			; $5154
	ld h,c			; $5155
	inc bc			; $5156
	pop hl			; $5157
	or h			; $5158
	ld h,c			; $5159
	rlca			; $515a
	rst_addAToHl			; $515b
	ld b,$e3		; $515c
	ld h,a			; $515e
_label_14_145:
	sub c			; $515f
	ret nz			; $5160
	rst $8			; $5161
	nop			; $5162
	ld ($ff00+$dc),a	; $5163
	ld h,c			; $5165
.DB $e3				; $5166
	ld (hl),e		; $5167
	pop hl			; $5168
	or h			; $5169
	ld h,c			; $516a
	inc b			; $516b
	pop hl			; $516c
	or h			; $516d
	ld h,c			; $516e
_label_14_146:
	nop			; $516f
	pop hl			; $5170
	or h			; $5171
	ld h,c			; $5172
	ld (bc),a		; $5173
	pop hl			; $5174
	or h			; $5175
	ld h,c			; $5176
	ld b,$e1		; $5177
	or h			; $5179
	ld h,c			; $517a
	ld ($2de4),sp		; $517b
	sub c			; $517e
	xor e			; $517f
	call z,$a000		; $5180
.DB $e3				; $5183
	ld c,l			; $5184
.DB $e4				; $5185
	rst $38			; $5186
	ld ($ff00+c),a		; $5187
	push af			; $5188
	cp e			; $5189
_label_14_147:
	add sp,-$0f		; $518a
	or c			; $518c
	ld b,b			; $518d
	cp h			; $518e
	nop			; $518f
	adc (hl)		; $5190
	ld (hl),a		; $5191
	ld bc,$508b		; $5192
	rst $20			; $5195
	ld d,$a2		; $5196
	rst $20			; $5198
	rla			; $5199
	and d			; $519a
	rst $20			; $519b
	jr -$5e			; $519c
	rst $20			; $519e
	ld h,$a2		; $519f
	rst $20			; $51a1
	daa			; $51a2
_label_14_148:
	and d			; $51a3
_label_14_149:
	rst $20			; $51a4
	jr z,-$5e		; $51a5
	ld ($ff00+$eb),a	; $51a7
	ld h,c			; $51a9
	rst_addAToHl			; $51aa
	ld d,b			; $51ab
	sbc b			; $51ac
	jr c,_label_14_150	; $51ad
	adc (hl)		; $51af
	ld (hl),a		; $51b0
	nop			; $51b1
	adc c			; $51b2
_label_14_150:
	jr _label_14_144		; $51b3
	ld (bc),a		; $51b5
	adc h			; $51b6
	ld d,$d7		; $51b7
	ld b,$89		; $51b9
	stop			; $51bb
	adc a			; $51bc
	ld bc,objectDeleteRelatedObj1AsStaticObject		; $51bd
	sub c			; $51c0
	pop de			; $51c1
	rst $8			; $51c2
	ld bc,$fb00		; $51c3
	adc e			; $51c6
	jr z,_label_14_145	; $51c7
	stop			; $51c9
	adc h			; $51ca
	jr nz,_label_14_149	; $51cb
	ld b,$96		; $51cd
	ld ($408c),sp		; $51cf
	rst_addAToHl			; $51d2
	ld b,$96		; $51d3
	stop			; $51d5
	adc h			; $51d6
	inc d			; $51d7
	or $98			; $51d8
	dec b			; $51da
	nop			; $51db
	adc (hl)		; $51dc
	ld c,a			; $51dd
	nop			; $51de
	or $96			; $51df
	jr _label_14_146		; $51e1
	stop			; $51e3
	di			; $51e4
	sub (hl)		; $51e5
	stop			; $51e6
	adc h			; $51e7
	ld e,b			; $51e8
	cp (hl)			; $51e9
_label_14_151:
	adc (hl)		; $51ea
	ld e,d			; $51eb
	nop			; $51ec
	or (hl)			; $51ed
	ldi (hl),a		; $51ee
	nop			; $51ef
	ld hl,sp-$75		; $51f0
	jr z,_label_14_147	; $51f2
	stop			; $51f4
_label_14_152:
	adc h			; $51f5
	ld a,(bc)		; $51f6
	sub c			; $51f7
	ret nz			; $51f8
	rst $8			; $51f9
	ld bc,$1b8c		; $51fa
	rst_addAToHl			; $51fd
	ld b,$91		; $51fe
	ret nz			; $5200
	rst $8			; $5201
	ld (bc),a		; $5202
	rst_addAToHl			; $5203
	ld l,(hl)		; $5204
	sub c			; $5205
	rst_addDoubleIndex			; $5206
	rst $8			; $5207
	ld bc,$8b00		; $5208
	jr z,_label_14_148	; $520b
	nop			; $520d
	adc h			; $520e
	add b			; $520f
	rst_addAToHl			; $5210
	ld b,$96		; $5211
	jr _label_14_151		; $5213
	ret nz			; $5215
	rst $8			; $5216
	ld (bc),a		; $5217
	adc a			; $5218
	rlca			; $5219
	nop			; $521a
	push de			; $521b
	rrca			; $521c
	ret nc			; $521d
	nop			; $521e
	ld a,($148b)		; $521f
	xor $3c			; $5222
	di			; $5224
	adc (hl)		; $5225
	ld a,b			; $5226
	add b			; $5227
	pop hl			; $5228
.DB $d3				; $5229
	ld h,d			; $522a
	ld e,$f7		; $522b
	ret nz			; $522d
	ld a,(bc)		; $522e
	ld e,a			; $522f
	rst_addAToHl			; $5230
	ld b,$8e		; $5231
	ld a,b			; $5233
	ld bc,$288b		; $5234
	xor $13			; $5237
	adc (hl)		; $5239
	ld a,b			; $523a
	add b			; $523b
	di			; $523c
	adc (hl)		; $523d
	ld a,b			; $523e
	ld bc,$b6f8		; $523f
	jr nc,_label_14_152	; $5242
	ld b,b			; $5244
	nop			; $5245
	cp l			; $5246
	sub c			; $5247
	xor e			; $5248
	call z,$f601		; $5249
.DB $e4				; $524c
	dec l			; $524d
	or $98			; $524e
	dec b			; $5250
	inc b			; $5251
	or $91			; $5252
	ret nz			; $5254
	rst $8			; $5255
	ld bc,$3ed7		; $5256
	sbc b			; $5259
	dec b			; $525a
	dec b			; $525b
	ldh (<hFF8E),a	; $525c
	inc c			; $525e
	or $91			; $525f
	ret nz			; $5261
	rst $8			; $5262
	ld (bc),a		; $5263
	rst_addAToHl			; $5264
	add b			; $5265
.DB $e3				; $5266
	ret z			; $5267
	rst $30			; $5268
	sub c			; $5269
	ret nz			; $526a
	rst $8			; $526b
	inc bc			; $526c
	rst_addAToHl			; $526d
	ld (bc),a		; $526e
.DB $e4				; $526f
	dec l			; $5270
	cp (hl)			; $5271
	jp nc,$bdf6		; $5272
	ldh (<hFF8E),a	; $5275
	inc c			; $5277
	push af			; $5278
.DB $e3				; $5279
	ret z			; $527a
	push af			; $527b
.DB $e3				; $527c
	ret z			; $527d
	push af			; $527e
.DB $e3				; $527f
	ret z			; $5280
	or $91			; $5281
	ret nz			; $5283
	rst $8			; $5284
	inc b			; $5285
	ld ($ff00+$c7),a	; $5286
	ld h,e			; $5288
	push de			; $5289
	ld bc,$00d0		; $528a
	or $e1			; $528d
	pop de			; $528f
	ld h,e			; $5290
	nop			; $5291
.DB $e4				; $5292
	add hl,sp		; $5293
	sub c			; $5294
	ret nz			; $5295
	rst $8			; $5296
	dec b			; $5297
	rst_addAToHl			; $5298
	ld b,d			; $5299
	sbc b			; $529a
	dec b			; $529b
	ld b,$91		; $529c
	ret nz			; $529e
	rst $8			; $529f
	ld b,$d7		; $52a0
	inc h			; $52a2
	sub c			; $52a3
	ret nz			; $52a4
	rst $8			; $52a5
	rlca			; $52a6
	push af			; $52a7
	pop hl			; $52a8
	pop de			; $52a9
	ld h,e			; $52aa
	inc bc			; $52ab
	rst_addAToHl			; $52ac
	ld b,(hl)		; $52ad
	sbc b			; $52ae
	dec b			; $52af
	rlca			; $52b0
	ld ($ff00+$d8),a	; $52b1
	ld h,e			; $52b3
	sub c			; $52b4
	ret nz			; $52b5
	rst $8			; $52b6
	ld ($91f7),sp		; $52b7
	ret nz			; $52ba
	rst $8			; $52bb
	add hl,bc		; $52bc
	pop hl			; $52bd
	pop de			; $52be
	ld h,e			; $52bf
	ld (bc),a		; $52c0
	rst_addAToHl			; $52c1
	ldd (hl),a		; $52c2
	sbc b			; $52c3
	dec b			; $52c4
	ld ($c091),sp		; $52c5
	rst $8			; $52c8
	ld a,(bc)		; $52c9
	or $98			; $52ca
	dec b			; $52cc
	add hl,bc		; $52cd
	di			; $52ce
	pop hl			; $52cf
	pop bc			; $52d0
	ld h,e			; $52d1
	dec h			; $52d2
	or $98			; $52d3
	dec b			; $52d5
	ld a,(bc)		; $52d6
	or $91			; $52d7
	ret nz			; $52d9
	rst $8			; $52da
	dec bc			; $52db
	rst_addAToHl			; $52dc
	ld b,b			; $52dd
.DB $e4				; $52de
	rst $38			; $52df
	or (hl)			; $52e0
	inc hl			; $52e1
	sub c			; $52e2
	xor e			; $52e3
	call z,$be00		; $52e4
	nop			; $52e7
	adc b			; $52e8
	ld b,b			; $52e9
	ld d,b			; $52ea
	adc l			; $52eb
	ld (bc),a		; $52ec
	inc b			; $52ed
	ret nc			; $52ee
	cp l			; $52ef
	ld ($ff00+$39),a	; $52f0
	ld (hl),c		; $52f2
	rst_addAToHl			; $52f3
	add d			; $52f4
.DB $e3				; $52f5
	or h			; $52f6
	ld ($ff00+$44),a	; $52f7
	ld sp,$e3f5		; $52f9
	or h			; $52fc
	ld ($ff00+$44),a	; $52fd
	ld sp,$e3f5		; $52ff
	or h			; $5302
	ld ($ff00+$44),a	; $5303
	ld sp,$f5d1		; $5305
	add h			; $5308
	and $02			; $5309

	.db $38 $50 $e1 $5c $31 $04 $d1 $d3
	.db $00 $eb $cc $e1 $30 $71 $02 $f7
	.db $98 $08 $10 $e4 $fb $f9 $e4 $ff
	.db $be $00


	.include "data/seasons/interactionAnimations.s"


.BANK $15 SLOT 1
.ORG 0

.include "code/serialFunctions.s"


	ld a,($cca2)		; $451e
	inc a			; $4521
	jr nz,_label_15_040	; $4522
	xor a			; $4524
_label_15_038:
	ld e,$7f		; $4525
_label_15_039:
	ld (de),a		; $4527
	ret			; $4528
_label_15_040:
	ld a,($cca3)		; $4529
	swap a			; $452c
	and $03			; $452e
	rst_jumpTable			; $4530
	add hl,sp		; $4531
	ld b,l			; $4532
	ld b,c			; $4533
	ld b,l			; $4534
	dec a			; $4535
	ld b,l			; $4536
	add hl,sp		; $4537
	ld b,l			; $4538
	ld a,$04		; $4539
	jr _label_15_038		; $453b
	ld a,$03		; $453d
	jr _label_15_038		; $453f
	ld a,($cca3)		; $4541
	and $0f			; $4544
	add $6e			; $4546
	ld b,a			; $4548
	call checkGlobalFlag		; $4549
	ld a,$02		; $454c
	jr nz,_label_15_038	; $454e
	ld a,b			; $4550
	sub $0a			; $4551
	call checkGlobalFlag		; $4553
	ld a,$01		; $4556
	jr nz,_label_15_038	; $4558
	ld a,$05		; $455a
	jr _label_15_038		; $455c
	ld a,($cca3)		; $455e
	and $0f			; $4561
	add $0f			; $4563
	ld c,a			; $4565
	ld b,$55		; $4566
	jp showText		; $4568
	call getFreeInteractionSlot		; $456b
	ret nz			; $456e
	ld (hl),$d9		; $456f
	inc l			; $4571
	ld a,($cca3)		; $4572
	and $0f			; $4575
	ld (hl),a		; $4577
	ld l,$4b		; $4578
	ld c,$75		; $457a
	jp setShortPosition_paramC		; $457c
	ld hl,$481b		; $457f
	ld e,$03		; $4582
	jp interBankCall		; $4584
	call objectGetShortPosition		; $4587
	ld c,a			; $458a
	ld a,($cc3d)		; $458b
	and $f0			; $458e
	ld b,a			; $4590
	ld a,($cc3e)		; $4591
	and $f0			; $4594
	swap a			; $4596
	or b			; $4598
	cp c			; $4599
	ret nz			; $459a
	ld e,$49		; $459b
	ld a,(de)		; $459d
	rrca			; $459e
	and $03			; $459f
	ld hl,$45ba		; $45a1
	rst_addAToHl			; $45a4
	ld a,(hl)		; $45a5
	add c			; $45a6
	ld c,a			; $45a7
	and $f0			; $45a8
	or $08			; $45aa
	ld ($cc3d),a		; $45ac
	ld a,c			; $45af
	swap a			; $45b0
	and $f0			; $45b2
	or $08			; $45b4
	ld ($cc3e),a		; $45b6
	ret			; $45b9
	stop			; $45ba
	rst $38			; $45bb
	ld a,($ff00+$01)	; $45bc
	ld e,$7d		; $45be
	ld a,(de)		; $45c0
	ld b,a			; $45c1
	ld a,($ccba)		; $45c2
	and b			; $45c5
	jr z,_label_15_041	; $45c6
	call $45de		; $45c8
	ld a,$01		; $45cb
	jr z,_label_15_042	; $45cd
	xor a			; $45cf
	jr _label_15_042		; $45d0
_label_15_041:
	call $45f6		; $45d2
	ld a,$02		; $45d5
	jr z,_label_15_042	; $45d7
	xor a			; $45d9
_label_15_042:
	ld ($cfc1),a		; $45da
	ret			; $45dd
	ld e,$49		; $45de
	ld a,(de)		; $45e0
	sub $10			; $45e1
	srl a			; $45e3
	ld hl,$45f2		; $45e5
	rst_addAToHl			; $45e8
	ld e,$7e		; $45e9
	ld a,(de)		; $45eb
	ld c,a			; $45ec
	ld b,$cf		; $45ed
	ld a,(bc)		; $45ef
	cp (hl)			; $45f0
	ret			; $45f1
	ld a,b			; $45f2
	ld a,c			; $45f3
	ld a,d			; $45f4
	ld a,e			; $45f5
	ld e,$7e		; $45f6
	ld a,(de)		; $45f8
	ld c,a			; $45f9
	ld b,$ce		; $45fa
	ld a,(bc)		; $45fc
	or a			; $45fd
	ret			; $45fe
	xor a			; $45ff
	ld ($cfc1),a		; $4600
	ld a,($cc48)		; $4603
	rrca			; $4606
	ret nc			; $4607
	call objectCheckCollidedWithLink_ignoreZ		; $4608
	ret nc			; $460b
	ld a,$01		; $460c
	ld ($cfc1),a		; $460e
	ret			; $4611
	ld e,$7e		; $4612
	ld a,(de)		; $4614
	ld c,a			; $4615
	ld b,$cf		; $4616
	ld a,(bc)		; $4618
	cp $5d			; $4619
	ld b,$01		; $461b
	jr z,_label_15_043	; $461d
	cp $5e			; $461f
	jr z,_label_15_043	; $4621
	dec b			; $4623
_label_15_043:
	ld a,b			; $4624
	ld ($cfc1),a		; $4625
	ret			; $4628
	ld a,($cca9)		; $4629
	ld b,a			; $462c
	ld e,$50		; $462d
	ld a,(de)		; $462f
	cp b			; $4630
	ld a,$01		; $4631
	jr z,_label_15_044	; $4633
	dec a			; $4635
_label_15_044:
	ld ($cec0),a		; $4636
	ret			; $4639
	ld a,$04		; $463a
	jp removeRupeeValue		; $463c


interactionLoadTreasureData:
	ld e,$42		; $463f
	ld a,(de)		; $4641
	ld e,$70		; $4642
	ld (de),a		; $4644
	ld hl,treasureObjectData		; $4645
_label_15_045:
	call multiplyABy4		; $4648
	add hl,bc		; $464b
	bit 7,(hl)		; $464c
	jr z,_label_15_046	; $464e
	inc hl			; $4650
	ldi a,(hl)		; $4651
	ld h,(hl)		; $4652
	ld l,a			; $4653
	ld e,$43		; $4654
	ld a,(de)		; $4656
	jr _label_15_045		; $4657
_label_15_046:
	ldi a,(hl)		; $4659
	ld b,a			; $465a
	swap a			; $465b
	and $07			; $465d
	ld e,$71		; $465f
	ld (de),a		; $4661
	ld a,b			; $4662
	and $07			; $4663
	inc e			; $4665
	ld (de),a		; $4666
	ld a,b			; $4667
	and $08			; $4668
	inc e			; $466a
	ld (de),a		; $466b
	ldi a,(hl)		; $466c
	inc e			; $466d
	ld (de),a		; $466e
	ldi a,(hl)		; $466f
	inc e			; $4670
	ld (de),a		; $4671
	ldi a,(hl)		; $4672
	ld e,$42		; $4673
	ld (de),a		; $4675
	ret			; $4676
	call getFreePartSlot		; $4677
	ret nz			; $467a
	ld (hl),$04		; $467b
	jp objectCopyPosition		; $467d
	ld a,($cc55)		; $4680
	ld b,a			; $4683
	inc a			; $4684
	jr nz,_label_15_047	; $4685
	ld hl,$471d		; $4687
	jr _label_15_048		; $468a
_label_15_047:
	ld a,b			; $468c
	ld hl,$4723		; $468d
	rst_addDoubleIndex			; $4690
	ldi a,(hl)		; $4691
	ld h,(hl)		; $4692
	ld l,a			; $4693
_label_15_048:
	ld e,$72		; $4694
	ld a,(de)		; $4696
	rst_addDoubleIndex			; $4697
	ldi a,(hl)		; $4698
	ld h,(hl)		; $4699
	ld l,a			; $469a
	jr _label_15_053		; $469b
	ld e,$58		; $469d
	ld a,(de)		; $469f
	ld l,a			; $46a0
	inc e			; $46a1
	ld a,(de)		; $46a2
	ld h,a			; $46a3
_label_15_049:
	ldi a,(hl)		; $46a4
	push hl			; $46a5
	rst_jumpTable			; $46a6
	cp a			; $46a7
	ld b,(hl)		; $46a8
	jp z,$d646		; $46a9
	ld b,(hl)		; $46ac
.DB $dd				; $46ad
	ld b,(hl)		; $46ae
.DB $e4				; $46af
	ld b,(hl)		; $46b0
.DB $ec				; $46b1
	ld b,(hl)		; $46b2
	cp a			; $46b3
	ld b,(hl)		; $46b4
	cp a			; $46b5
	ld b,(hl)		; $46b6
	ld (bc),a		; $46b7
	ld b,a			; $46b8
	ld b,$47		; $46b9
	ld a,(bc)		; $46bb
	ld b,a			; $46bc
	ld c,$47		; $46bd
	pop hl			; $46bf
	ldi a,(hl)		; $46c0
	ld e,$46		; $46c1
	ld (de),a		; $46c3
	ld e,$45		; $46c4
	xor a			; $46c6
	ld (de),a		; $46c7
	jr _label_15_053		; $46c8
_label_15_050:
	pop hl			; $46ca
	ldi a,(hl)		; $46cb
	ld e,$46		; $46cc
	ld (de),a		; $46ce
	ld e,$45		; $46cf
	ld a,$01		; $46d1
	ld (de),a		; $46d3
	jr _label_15_053		; $46d4
	pop hl			; $46d6
	ldi a,(hl)		; $46d7
	ld e,$49		; $46d8
	ld (de),a		; $46da
	jr _label_15_049		; $46db
	pop hl			; $46dd
	ldi a,(hl)		; $46de
	ld e,$50		; $46df
	ld (de),a		; $46e1
	jr _label_15_049		; $46e2
	pop hl			; $46e4
	ld a,(hl)		; $46e5
	call s8ToS16		; $46e6
	add hl,bc		; $46e9
	jr _label_15_049		; $46ea
	pop hl			; $46ec
	ld a,($ccb0)		; $46ed
	cp d			; $46f0
	jr nz,_label_15_051	; $46f1
	inc hl			; $46f3
	jr _label_15_049		; $46f4
_label_15_051:
	dec hl			; $46f6
	ld a,$01		; $46f7
	ld e,$46		; $46f9
	ld (de),a		; $46fb
	xor a			; $46fc
	ld e,$45		; $46fd
	ld (de),a		; $46ff
	jr _label_15_053		; $4700
	ld a,$00		; $4702
	jr _label_15_052		; $4704
	ld a,$08		; $4706
	jr _label_15_052		; $4708
	ld a,$10		; $470a
	jr _label_15_052		; $470c
	ld a,$18		; $470e
_label_15_052:
	ld e,$49		; $4710
	ld (de),a		; $4712
	jr _label_15_050		; $4713
_label_15_053:
	ld e,$58		; $4715
	ld a,l			; $4717
	ld (de),a		; $4718
	inc e			; $4719
	ld a,h			; $471a
	ld (de),a		; $471b
	ret			; $471c
.DB $d3				; $471d
	ld c,b			; $471e
.DB $ed				; $471f
	ld c,b			; $4720
	rst $30			; $4721
	ld c,b			; $4722
	dec (hl)		; $4723
	ld b,a			; $4724
	dec (hl)		; $4725
	ld b,a			; $4726
	dec (hl)		; $4727
	ld b,a			; $4728
	and c			; $4729
	ld b,a			; $472a
	ret			; $472b
	ld b,a			; $472c
	dec (hl)		; $472d
	ld b,a			; $472e
	rst $20			; $472f
	ld b,a			; $4730
	ld b,c			; $4731
	ld c,b			; $4732
	or a			; $4733
	ld c,b			; $4734
	ld b,e			; $4735
	ld b,a			; $4736
	ld d,c			; $4737
	ld b,a			; $4738
	ld e,a			; $4739
	ld b,a			; $473a
	ld l,l			; $473b
	ld b,a			; $473c
	ld a,l			; $473d
	ld b,a			; $473e
	adc c			; $473f
	ld b,a			; $4740
	sub l			; $4741
	ld b,a			; $4742
	nop			; $4743
	stop			; $4744
	dec bc			; $4745
	ld b,b			; $4746
	nop			; $4747
	stop			; $4748
	add hl,bc		; $4749
	and b			; $474a
	nop			; $474b
	stop			; $474c
	dec bc			; $474d
	and b			; $474e
	inc b			; $474f
	rst $30			; $4750
	nop			; $4751
	stop			; $4752
	ld ($0040),sp		; $4753
	stop			; $4756
	ld a,(bc)		; $4757
	and b			; $4758
	nop			; $4759
	stop			; $475a
	ld ($04a0),sp		; $475b
	rst $30			; $475e
	nop			; $475f
	stop			; $4760
	add hl,bc		; $4761
	ld b,b			; $4762
	nop			; $4763
	stop			; $4764
	dec bc			; $4765
	and b			; $4766
	nop			; $4767
	stop			; $4768
	add hl,bc		; $4769
	and b			; $476a
	inc b			; $476b
	rst $30			; $476c
	inc bc			; $476d
	jr z,_label_15_054	; $476e
_label_15_054:
	jr nz,_label_15_055	; $4770
	ld b,b			; $4772
	nop			; $4773
	jr nz,_label_15_056	; $4774
	ld d,b			; $4776
	nop			; $4777
	jr nz,_label_15_057	; $4778
	ld d,b			; $477a
	inc b			; $477b
	rst $30			; $477c
_label_15_055:
	add hl,bc		; $477d
	ret nz			; $477e
_label_15_056:
	nop			; $477f
	stop			; $4780
	dec bc			; $4781
	ld ($ff00+$00),a	; $4782
	stop			; $4784
_label_15_057:
	add hl,bc		; $4785
	ld ($ff00+$04),a	; $4786
	rst $30			; $4788
	dec bc			; $4789
	ld d,b			; $478a
	nop			; $478b
	stop			; $478c
	add hl,bc		; $478d
	ld ($ff00+$00),a	; $478e
	stop			; $4790
	dec bc			; $4791
	ld ($ff00+$04),a	; $4792
	rst $30			; $4794
	add hl,bc		; $4795
	ld d,b			; $4796
	nop			; $4797
	stop			; $4798
	dec bc			; $4799
	ld ($ff00+$00),a	; $479a
	stop			; $479c
	add hl,bc		; $479d
	ld ($ff00+$04),a	; $479e
	rst $30			; $47a0
	and a			; $47a1
	ld b,a			; $47a2
	or e			; $47a3
	ld b,a			; $47a4
	cp a			; $47a5
	ld b,a			; $47a6
	add hl,bc		; $47a7
	ld b,b			; $47a8
	nop			; $47a9
	jr nz,$0b		; $47aa
	add b			; $47ac
	nop			; $47ad
	jr nz,_label_15_058	; $47ae
	add b			; $47b0
	inc b			; $47b1
	rst $30			; $47b2
	ld a,(bc)		; $47b3
	ld h,b			; $47b4
	nop			; $47b5
	ld ($c008),sp		; $47b6
_label_15_058:
	nop			; $47b9
	ld ($c00a),sp		; $47ba
	inc b			; $47bd
	rst $30			; $47be
	dec bc			; $47bf
	ld h,b			; $47c0
	nop			; $47c1
	jr nz,_label_15_060	; $47c2
	ld h,b			; $47c4
	nop			; $47c5
	jr nz,_label_15_059	; $47c6
	rst $30			; $47c8
	bit 0,a			; $47c9
	inc bc			; $47cb
_label_15_059:
	ld d,b			; $47cc
_label_15_060:
	nop			; $47cd
	inc a			; $47ce
	dec bc			; $47cf
	jr nc,_label_15_061	; $47d0
	jr c,_label_15_063	; $47d2
	jr z,_label_15_064	; $47d4
	jr c,$09		; $47d6
	jr z,_label_15_065	; $47d8
_label_15_061:
	jr c,_label_15_066	; $47da
	jr z,_label_15_062	; $47dc
_label_15_062:
	inc a			; $47de
_label_15_063:
	ld a,(bc)		; $47df
_label_15_064:
	jr _label_15_067		; $47e0
_label_15_065:
	ld ($200a),sp		; $47e2
_label_15_066:
	inc b			; $47e5
	rst $20			; $47e6
	ei			; $47e7
	ld b,a			; $47e8
	dec b			; $47e9
	ld c,b			; $47ea
_label_15_067:
	rrca			; $47eb
	ld c,b			; $47ec
	rrca			; $47ed
	ld c,b			; $47ee
	add hl,de		; $47ef
	ld c,b			; $47f0
	inc hl			; $47f1
	ld c,b			; $47f2
	dec l			; $47f3
	ld c,b			; $47f4
	dec l			; $47f5
	ld c,b			; $47f6
	scf			; $47f7
	ld c,b			; $47f8
	dec sp			; $47f9
	ld c,b			; $47fa
	add hl,bc		; $47fb
	ld h,b			; $47fc
	nop			; $47fd
	stop			; $47fe
	dec bc			; $47ff
	ld h,b			; $4800
	nop			; $4801
	stop			; $4802
	inc b			; $4803
	rst $30			; $4804
	ld a,(bc)		; $4805
	add b			; $4806
	nop			; $4807
	stop			; $4808
	ld ($0080),sp		; $4809
	stop			; $480c
	inc b			; $480d
	rst $30			; $480e
	ld ($0020),sp		; $480f
	stop			; $4812
	ld a,(bc)		; $4813
	jr nz,_label_15_068	; $4814
_label_15_068:
	stop			; $4816
	inc b			; $4817
	rst $30			; $4818
	ld (jpHl),sp		; $4819
	stop			; $481c
	ld a,(bc)		; $481d
	and b			; $481e
	nop			; $481f
	stop			; $4820
	inc b			; $4821
	rst $30			; $4822
	ld ($00c0),sp		; $4823
	stop			; $4826
	ld a,(bc)		; $4827
	ret nz			; $4828
	nop			; $4829
	stop			; $482a
	inc b			; $482b
	rst $30			; $482c
	dec bc			; $482d
	ld h,b			; $482e
	nop			; $482f
	stop			; $4830
	add hl,bc		; $4831
	ld h,b			; $4832
	nop			; $4833
	stop			; $4834
	inc b			; $4835
	rst $30			; $4836
	ld a,(bc)		; $4837
	ld ($ff00+$00),a	; $4838
	stop			; $483a
	ld ($00e0),sp		; $483b
	stop			; $483e
	inc b			; $483f
	rst $30			; $4840
	ld c,l			; $4841
	ld c,b			; $4842
	ld (hl),c		; $4843
	ld c,b			; $4844
	ld a,e			; $4845
	ld c,b			; $4846
	adc a			; $4847
	ld c,b			; $4848
	sbc e			; $4849
	ld c,b			; $484a
	xor l			; $484b
	ld c,b			; $484c
	inc bc			; $484d
	ld d,b			; $484e
	nop			; $484f
	inc a			; $4850
	ld a,(bc)		; $4851
	jr nz,$0b		; $4852
	ld c,b			; $4854
	ld ($0920),sp		; $4855
	jr _label_15_069		; $4858
	ld ($1809),sp		; $485a
	ld ($0018),sp		; $485d
	jr z,_label_15_070	; $4860
	jr $0b			; $4862
_label_15_069:
	jr $08			; $4864
	ld (makeActiveObjectFollowLink),sp		; $4866
	ld a,(bc)		; $4869
	jr nz,_label_15_071	; $486a
_label_15_070:
	ld c,b			; $486c
	ld ($0420),sp		; $486d
	rst_addDoubleIndex			; $4870
	nop			; $4871
	ld ($8009),sp		; $4872
_label_15_071:
	nop			; $4875
	ld ($800b),sp		; $4876
	inc b			; $4879
	rst $30			; $487a
	inc bc			; $487b
	ld d,b			; $487c
	nop			; $487d
	ld ($380b),sp		; $487e
	nop			; $4881
	ld ($3008),sp		; $4882
	nop			; $4885
	ld ($3809),sp		; $4886
	nop			; $4889
	ld ($300a),sp		; $488a
	inc b			; $488d
	rst $28			; $488e
	ld a,(bc)		; $488f
	ld h,b			; $4890
	nop			; $4891
	ld ($8008),sp		; $4892
	nop			; $4895
	ld ($800a),sp		; $4896
	inc b			; $4899
	rst $30			; $489a
	nop			; $489b
	ld ($a00b),sp		; $489c
	nop			; $489f
	ld ($a008),sp		; $48a0
	nop			; $48a3
	ld ($a009),sp		; $48a4
	nop			; $48a7
	ld ($a00a),sp		; $48a8
	inc b			; $48ab
	rst $28			; $48ac
	nop			; $48ad
	ld ($8008),sp		; $48ae
	nop			; $48b1
	ld ($800a),sp		; $48b2
	inc b			; $48b5
	rst $30			; $48b6
	cp a			; $48b7
	ld c,b			; $48b8
	ret			; $48b9
	ld c,b			; $48ba
	cp a			; $48bb
	ld c,b			; $48bc
	ret			; $48bd
	ld c,b			; $48be
	add hl,bc		; $48bf
	ld ($ff00+$00),a	; $48c0
	stop			; $48c2
	dec bc			; $48c3
	ld ($ff00+$00),a	; $48c4
	stop			; $48c6
	inc b			; $48c7
	rst $30			; $48c8
	dec bc			; $48c9
	ld ($ff00+$00),a	; $48ca
	stop			; $48cc
	add hl,bc		; $48cd
	ld ($ff00+$00),a	; $48ce
	stop			; $48d0
	inc b			; $48d1
	rst $30			; $48d2
	inc bc			; $48d3
	ld d,b			; $48d4
	nop			; $48d5
	inc a			; $48d6
	dec bc			; $48d7
	inc e			; $48d8
	nop			; $48d9
	rrca			; $48da
	ld ($0030),sp		; $48db
	rrca			; $48de
	add hl,bc		; $48df
	jr c,_label_15_072	; $48e0
_label_15_072:
	rrca			; $48e2
	ld a,(bc)		; $48e3
	jr nc,_label_15_073	; $48e4
_label_15_073:
	rrca			; $48e6
	dec bc			; $48e7
	inc e			; $48e8
	nop			; $48e9
	inc a			; $48ea
	inc b			; $48eb
	jp hl			; $48ec
	nop			; $48ed
	ld ($4009),sp		; $48ee
	nop			; $48f1
	ld ($400b),sp		; $48f2
	inc b			; $48f5
	rst $30			; $48f6
	nop			; $48f7
	ld ($400b),sp		; $48f8
	nop			; $48fb
	ld ($4009),sp		; $48fc
	inc b			; $48ff
	rst $30			; $4900
	call objectGetPosition		; $4901
	ld a,$ff		; $4904
	jp createEnergySwirlGoingIn		; $4906
	ld a,$01		; $4909
	ld ($cd2d),a		; $490b
	ret			; $490e
	call getFreeInteractionSlot		; $490f
	ld bc,$2c00		; $4912
	ld (hl),$60		; $4915
	inc l			; $4917
	ld (hl),b		; $4918
	inc l			; $4919
	ld (hl),c		; $491a
	ld l,$4b		; $491b
	ld a,($d00b)		; $491d
	ldi (hl),a		; $4920
	inc l			; $4921
	ld a,($d00d)		; $4922
	ld (hl),a		; $4925
	ret			; $4926
	ld ($cbd3),a		; $4927
	ld a,$01		; $492a
	ld ($cca4),a		; $492c
	ld a,$04		; $492f
	jp openMenu		; $4931
	ld a,$02		; $4934
	jp openSecretInputMenu		; $4936
	ld a,$31		; $4939
	call setGlobalFlag		; $493b
	ld bc,$0002		; $493e
	jp secretFunctionCaller		; $4941
	ld e,$44		; $4944
	ld a,$05		; $4946
	ld (de),a		; $4948
	xor a			; $4949
	inc e			; $494a
	ld (de),a		; $494b
	ld b,$03		; $494c
	call secretFunctionCaller		; $494e
	call serialFunc_0c85		; $4951
	ld a,($cba5)		; $4954
	ld e,$79		; $4957
	ld (de),a		; $4959
	ld bc,$300e		; $495a
	or a			; $495d
	jr z,_label_15_074	; $495e
	ld e,$45		; $4960
	ld a,$03		; $4962
	ld (de),a		; $4964
	ld bc,$3028		; $4965
_label_15_074:
	jp showText		; $4968
	ld a,$00		; $496b
	call $498d		; $496d
	jr nz,_label_15_076	; $4970
	ld a,$01		; $4972
	call $498d		; $4974
	jr nz,_label_15_076	; $4977
	ld a,$02		; $4979
	call $498d		; $497b
	jr nz,_label_15_076	; $497e
	ld a,$03		; $4980
_label_15_075:
	ld e,$7b		; $4982
	ld (de),a		; $4984
	ret			; $4985
_label_15_076:
	ld e,$7a		; $4986
	ld (de),a		; $4988
	sub $34			; $4989
	jr _label_15_075		; $498b
	ld c,a			; $498d
	call checkGlobalFlag		; $498e
	jr z,_label_15_077	; $4991
	ld a,c			; $4993
	add $04			; $4994
	ld c,a			; $4996
	call checkGlobalFlag		; $4997
	jr nz,_label_15_077	; $499a
	ld a,c			; $499c
	call setGlobalFlag		; $499d
	ld a,c			; $49a0
	add $30			; $49a1
	ret			; $49a3
_label_15_077:
	xor a			; $49a4
	ret			; $49a5
	ld a,$00		; $49a6
	jr _label_15_078		; $49a8
	ld a,$38		; $49aa
	jr _label_15_078		; $49ac
	ld e,$7a		; $49ae
	ld a,(de)		; $49b0
_label_15_078:
	ld b,a			; $49b1
	ld c,$00		; $49b2
	jp giveRingToLink		; $49b4
	xor a			; $49b7
	ld ($c63e),a		; $49b8
	inc a			; $49bb
	ld ($c614),a		; $49bc
	ld a,$28		; $49bf
	jp setGlobalFlag		; $49c1

	.include "code/seasons/interactionCode/bank15.s"
	.include "data/seasons/partAnimations.s"


.BANK $16 SLOT 1
.ORG 0

	.include "build/data/paletteData.s"
	.include "build/data/tilesetCollisions.s"
	.include "build/data/smallRoomLayoutTables.s"

.BANK $17 SLOT 1
.ORG 0

 m_section_superfree Tile_Mappings

	tileMappingIndexDataPointer:
		.dw tileMappingIndexData
	tileMappingAttributeDataPointer:
		.dw tileMappingAttributeData

	tileMappingTable:
		.incbin "build/tileset_layouts/tileMappingTable.bin"
	tileMappingIndexData:
		.incbin "build/tileset_layouts/tileMappingIndexData.bin"
	tileMappingAttributeData:
		.incbin "build/tileset_layouts/tileMappingAttributeData.bin"
.ends

.BANK $18 SLOT 1
.ORG 0

	.include "build/data/largeRoomLayoutTables.s"

	m_GfxDataSimple gfx_animations_1
	m_GfxDataSimple gfx_animations_2
	m_GfxDataSimple gfx_animations_3
	m_GfxDataSimple gfx_063940

	; Compressed graphics file, for some reason doesn't go in gfxDataMain.s.
	m_GfxDataSimple gfx_credits_sprites_2


.BANK $19 SLOT 1
.ORG 0

 m_section_superfree "Tile_mappings"
	.include "build/data/tilesetMappings.s"
.ends


.BANK $1a SLOT 1
.ORG 0
	.include "data/gfxDataBank1a.s"


.BANK $1b SLOT 1
.ORG 0
	.include "data/gfxDataBank1b.s"


.BANK $1c SLOT 1
.ORG 0
	; The first $e characters of gfx_font are blank, so they aren't
	; included in the rom. In order to get the offsets correct, use
	; gfx_font_start as the label instead of gfx_font.

	.define gfx_font_start gfx_font-$e0
	.export gfx_font_start

	m_GfxDataSimple gfx_font_jp ; $70000
	m_GfxDataSimple gfx_font_tradeitems ; $70600
	m_GfxDataSimple gfx_font $e0 ; $70800
	m_GfxDataSimple gfx_font_heartpiece ; $71720

	m_GfxDataSimple map_rings ; $717a0

	; TODO: where does "build/data/largeRoomLayoutTables.s" go?


	; "build/textData.s" will determine where this data starts.
	;   Ages:    1d:4000
	;   Seasons: 1c:5c00

	.include "build/textData.s"

	.REDEFINE DATA_ADDR TEXT_END_ADDR
	.REDEFINE DATA_BANK TEXT_END_BANK

	.include "build/data/roomLayoutData.s"
	.include "build/data/gfxDataMain.s"

.BANK $3f SLOT 1
.ORG 0

 m_section_force Bank3f NAMESPACE bank3f

.define BANK_3f $3f

.include "code/loadGraphics.s"
.include "code/treasureAndDrops.s"
.include "code/textbox.s"
.include "code/seasons/interactionCode/interactionCode11_body.s"

.include "build/data/objectGfxHeaders.s"
.include "build/data/treeGfxHeaders.s"

.include "build/data/enemyData.s"
.include "build/data/partData.s"
.include "build/data/itemData.s"
.include "build/data/interactionData.s"

.include "build/data/treasureCollectionBehaviours.s"
.include "build/data/treasureDisplayData.s"

.ends
