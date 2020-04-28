interactionCoded9:
	ld e,$44		; $49c4
	ld a,(de)		; $49c6
	rst_jumpTable			; $49c7
	adc $49			; $49c8
	dec e			; $49ca
	ld c,d			; $49cb
	adc c			; $49cc
	ld c,d			; $49cd
	ld a,$01		; $49ce
	ld ($cc17),a		; $49d0
	ld e,$42		; $49d3
	ld a,(de)		; $49d5
	ld b,a			; $49d6
	add $6e			; $49d7
	call checkGlobalFlag		; $49d9
	jr z,_label_15_079	; $49dc
	ld bc,$550c		; $49de
	call showText		; $49e1
	ld a,$02		; $49e4
	ld ($cfc0),a		; $49e6
	jp interactionDelete		; $49e9
_label_15_079:
	ld a,b			; $49ec
	ld hl,$49fc		; $49ed
	call checkFlag		; $49f0
	ld a,$02		; $49f3
	jr nz,_label_15_080	; $49f5
	dec a			; $49f7
_label_15_080:
	ld e,$44		; $49f8
	ld (de),a		; $49fa
	ret			; $49fb
	or c			; $49fc
	ld (bc),a		; $49fd
	ld e,$42		; $49fe
	ld a,(de)		; $4a00
	ld hl,$4a09		; $4a01
	rst_addDoubleIndex			; $4a04
	ld b,(hl)		; $4a05
	inc l			; $4a06
	ld c,(hl)		; $4a07
	ret			; $4a08
	dec b			; $4a09
	nop			; $4a0a
	ldi a,(hl)		; $4a0b
	ld bc,$010d		; $4a0c
	dec l			; $4a0f
	inc c			; $4a10
	ld bc,$6101		; $4a11
	ld (bc),a		; $4a14
	dec l			; $4a15
	dec c			; $4a16
	ld h,d			; $4a17
	inc bc			; $4a18
	inc c			; $4a19
	ld bc,$042c		; $4a1a
	ld e,$45		; $4a1d
	ld a,(de)		; $4a1f
	rst_jumpTable			; $4a20
	dec hl			; $4a21
	ld c,d			; $4a22
	ld b,d			; $4a23
	ld c,d			; $4a24
	ld c,a			; $4a25
	ld c,d			; $4a26
	ld h,(hl)		; $4a27
	ld c,d			; $4a28
	halt			; $4a29
	ld c,d			; $4a2a
	ld a,$01		; $4a2b
	ld (de),a		; $4a2d
	xor a			; $4a2e
	ld ($ccbc),a		; $4a2f
	call $49fe		; $4a32
	ld a,b			; $4a35
	ld ($ccbd),a		; $4a36
	ld a,c			; $4a39
	ld ($ccbe),a		; $4a3a
	ld b,$11		; $4a3d
	jp objectCreateInteractionWithSubid00		; $4a3f
	ld a,($cfc0)		; $4a42
	or a			; $4a45
	ret z			; $4a46
	ld e,$46		; $4a47
	ld a,$3c		; $4a49
	ld (de),a		; $4a4b
	jp interactionIncState2		; $4a4c
	call interactionDecCounter1		; $4a4f
	ret nz			; $4a52
	ld a,$2c		; $4a53
	call setGlobalFlag		; $4a55
	ld a,$02		; $4a58
	ld ($cfc0),a		; $4a5a
	ld bc,$5509		; $4a5d
	call showText		; $4a60
	jp interactionIncState2		; $4a63
	ld a,($ccbc)		; $4a66
	or a			; $4a69
	ret z			; $4a6a
	call $4b9f		; $4a6b
	ld e,$46		; $4a6e
	ld a,$1e		; $4a70
	ld (de),a		; $4a72
	jp interactionIncState2		; $4a73
	call interactionDecCounter1		; $4a76
	ret nz			; $4a79
	call objectCreatePuff		; $4a7a
	call objectGetShortPosition		; $4a7d
	ld c,a			; $4a80
	ld a,$ac		; $4a81
	call setTile		; $4a83
	jp interactionDelete		; $4a86
	ld e,$45		; $4a89
	ld a,(de)		; $4a8b
	rst_jumpTable			; $4a8c
	sbc a			; $4a8d
	ld c,d			; $4a8e
	xor h			; $4a8f
	ld c,d			; $4a90
	jp $d94a		; $4a91
	ld c,d			; $4a94
	reti			; $4a95
	ld c,d			; $4a96
	ld ($f54a),a		; $4a97
	ld c,d			; $4a9a
	ld e,d			; $4a9b
	ld c,e			; $4a9c
	sub d			; $4a9d
	ld c,e			; $4a9e
	call interactionIncState2		; $4a9f
	ld l,$46		; $4aa2
	ld (hl),$1e		; $4aa4
	ld hl,$d000		; $4aa6
	jp objectTakePosition		; $4aa9
	call interactionDecCounter1		; $4aac
	ret nz			; $4aaf
	ld (hl),$3c		; $4ab0
	call getFreeInteractionSlot		; $4ab2
	ret nz			; $4ab5
	ld (hl),$84		; $4ab6
	ld l,$4b		; $4ab8
	ld (hl),$28		; $4aba
	ld l,$4d		; $4abc
	ld (hl),$58		; $4abe
	jp interactionIncState2		; $4ac0
	call interactionDecCounter1		; $4ac3
	ret nz			; $4ac6
	ld (hl),$14		; $4ac7
	ld a,($d00b)		; $4ac9
	ld b,a			; $4acc
	ld a,($d00d)		; $4acd
	ld c,a			; $4ad0
	ld a,$78		; $4ad1
	call createEnergySwirlGoingIn		; $4ad3
	jp interactionIncState2		; $4ad6
	call interactionDecCounter1		; $4ad9
	ret nz			; $4adc
	ld (hl),$14		; $4add
	call fadeinFromWhite		; $4adf
_label_15_081:
	ld a,$b4		; $4ae2
	call playSound		; $4ae4
	jp interactionIncState2		; $4ae7
	call interactionDecCounter1		; $4aea
	ret nz			; $4aed
	ld a,$02		; $4aee
	call fadeinFromWhiteWithDelay		; $4af0
	jr _label_15_081		; $4af3
	ld a,($c4ab)		; $4af5
	or a			; $4af8
	ret nz			; $4af9
	call $49fe		; $4afa
	ld a,c			; $4afd
	rst_jumpTable			; $4afe
	inc hl			; $4aff
	ld c,e			; $4b00
	jr z,_label_15_084	; $4b01
	inc sp			; $4b03
	ld c,e			; $4b04
	ld b,h			; $4b05
	ld c,e			; $4b06
	add hl,bc		; $4b07
	ld c,e			; $4b08
	ld a,($c6c6)		; $4b09
	and $03			; $4b0c
	ld hl,$4b17		; $4b0e
	rst_addAToHl			; $4b11
	ld c,(hl)		; $4b12
	ld b,$2c		; $4b13
	jr _label_15_085		; $4b15
	inc bc			; $4b17
	inc bc			; $4b18
	inc b			; $4b19
	inc b			; $4b1a
	inc bc			; $4b1b
	ld bc,$0103		; $4b1c
	dec b			; $4b1f
	ld (bc),a		; $4b20
	dec b			; $4b21
	ld (bc),a		; $4b22
	ld a,($c6ac)		; $4b23
	jr _label_15_082		; $4b26
	ld a,($c6a9)		; $4b28
_label_15_082:
	ld hl,$4b1b		; $4b2b
	rst_addDoubleIndex			; $4b2e
	inc hl			; $4b2f
	ld a,(hl)		; $4b30
	jr _label_15_083		; $4b31
	ld bc,$6100		; $4b33
	call $4b4f		; $4b36
	ld hl,$c6ab		; $4b39
	ld a,(hl)		; $4b3c
	add $20			; $4b3d
	ldd (hl),a		; $4b3f
	ld (hl),a		; $4b40
	jp setStatusBarNeedsRefreshBit1		; $4b41
	ld a,($c6ae)		; $4b44
	ld bc,$1901		; $4b47
	jr _label_15_085		; $4b4a
_label_15_083:
	and $03			; $4b4c
_label_15_084:
	ld c,a			; $4b4e
_label_15_085:
	call $4b98		; $4b4f
	ld e,$46		; $4b52
	ld a,$1e		; $4b54
	ld (de),a		; $4b56
	jp interactionIncState2		; $4b57
	call retIfTextIsActive		; $4b5a
	call interactionDecCounter1		; $4b5d
	ret nz			; $4b60
	ld e,$42		; $4b61
	ld a,(de)		; $4b63
	cp $07			; $4b64
	jr z,_label_15_086	; $4b66
	or a			; $4b68
	jr nz,_label_15_087	; $4b69
	ld a,($c6ac)		; $4b6b
	add $02			; $4b6e
	ld c,a			; $4b70
	ld b,$05		; $4b71
	call $4b98		; $4b73
	call interactionIncState2		; $4b76
	ld l,$46		; $4b79
	ld (hl),$5a		; $4b7b
	ret			; $4b7d
_label_15_086:
	call refillSeedSatchel		; $4b7e
_label_15_087:
	ld a,$02		; $4b81
	ld ($cfc0),a		; $4b83
	ld bc,$5509		; $4b86
	call showText		; $4b89
	call $4b9f		; $4b8c
	jp interactionDelete		; $4b8f
	call interactionDecCounter1		; $4b92
	ret nz			; $4b95
	jr _label_15_087		; $4b96
	call createTreasure		; $4b98
	ret nz			; $4b9b
	jp objectCopyPosition		; $4b9c
	ld e,$42		; $4b9f
	ld a,(de)		; $4ba1
	add $6e			; $4ba2
	call setGlobalFlag		; $4ba4
	ld a,$2c		; $4ba7
	jp unsetGlobalFlag		; $4ba9

interactionCodeda:
	ld e,$44		; $4bac
	ld a,(de)		; $4bae
	rst_jumpTable			; $4baf
	or h			; $4bb0
	ld c,e			; $4bb1
	call nz,$3e4b		; $4bb2
	ld bc,$cd12		; $4bb5
	ld d,(hl)		; $4bb8
	add hl,de		; $4bb9
	and $80			; $4bba
	jp nz,interactionDelete		; $4bbc
	ld a,$ac		; $4bbf
	jp loadPaletteHeader		; $4bc1
	call checkLinkVulnerable		; $4bc4
	ret nc			; $4bc7
	ld a,($cd00)		; $4bc8
	and $0e			; $4bcb
	ret nz			; $4bcd
	ld hl,$d00b		; $4bce
	ld e,$4b		; $4bd1
	ld a,(de)		; $4bd3
	cp (hl)			; $4bd4
	ret c			; $4bd5
	ld l,$0d		; $4bd6
	ld e,$4d		; $4bd8
	ld a,(de)		; $4bda
	sub (hl)		; $4bdb
	jr nc,_label_15_088	; $4bdc
	cpl			; $4bde
	inc a			; $4bdf
_label_15_088:
	cp $09			; $4be0
	ret nc			; $4be2
	ld a,$17		; $4be3
	ld ($cc04),a		; $4be5
	ld ($cc02),a		; $4be8
	ld hl,$d240		; $4beb
_label_15_089:
	ld l,$40		; $4bee
	ldi a,(hl)		; $4bf0
	or a			; $4bf1
	jr z,_label_15_090	; $4bf2
	ldi a,(hl)		; $4bf4
	cp $b0			; $4bf5
	jr nz,_label_15_090	; $4bf7
	ld l,$5a		; $4bf9
	res 7,(hl)		; $4bfb
_label_15_090:
	inc h			; $4bfd
	ld a,h			; $4bfe
	cp $e0			; $4bff
	jr c,_label_15_089	; $4c01
	jp interactionDelete		; $4c03

interactionCodee0:
	ld e,$44		; $4c06
	ld a,(de)		; $4c08
	rst_jumpTable			; $4c09
	ld (de),a		; $4c0a
	ld c,h			; $4c0b
	ldd (hl),a		; $4c0c
	ld c,h			; $4c0d
	ld b,e			; $4c0e
	ld c,h			; $4c0f
	ld c,(hl)		; $4c10
	ld c,h			; $4c11
	ld a,$01		; $4c12
	ld (de),a		; $4c14
	ld a,($cc61)		; $4c15
	inc a			; $4c18
	jr z,_label_15_091	; $4c19
	ld a,($cc4e)		; $4c1b
_label_15_091:
	ld e,$42		; $4c1e
	ld (de),a		; $4c20
	call interactionInitGraphics		; $4c21
	call interactionSetAlwaysUpdateBit		; $4c24
	ld l,$4b		; $4c27
	ld (hl),$0a		; $4c29
	ld l,$4d		; $4c2b
	ld (hl),$b0		; $4c2d
	jp objectSetVisible80		; $4c2f
	ld h,d			; $4c32
	ld l,$4d		; $4c33
	ld a,(hl)		; $4c35
	sub $04			; $4c36
	ld (hl),a		; $4c38
	cp $10			; $4c39
	ret nz			; $4c3b
	ld l,e			; $4c3c
	inc (hl)		; $4c3d
	ld l,$46		; $4c3e
	ld (hl),$28		; $4c40
	ret			; $4c42
	call interactionDecCounter1		; $4c43
	ret nz			; $4c46
	ld l,e			; $4c47
	inc (hl)		; $4c48
	ld l,$46		; $4c49
	ld (hl),$06		; $4c4b
	ret			; $4c4d
	ld h,d			; $4c4e
	ld l,$4d		; $4c4f
	ld a,(hl)		; $4c51
	sub $06			; $4c52
	ld (hl),a		; $4c54
	ld l,$46		; $4c55
	dec (hl)		; $4c57
	ret nz			; $4c58
	jp interactionDelete		; $4c59

interactionCodee2:
	ld e,$42		; $4c5c
	ld a,(de)		; $4c5e
	rst_jumpTable			; $4c5f
	ld l,d			; $4c60
	ld c,h			; $4c61
	push de			; $4c62
	ld c,h			; $4c63
	add h			; $4c64
	ld c,h			; $4c65
.DB $fc				; $4c66
	ld c,h			; $4c67
	jr $4d			; $4c68
	call checkInteractionState		; $4c6a
	jr z,_label_15_092	; $4c6d
	ld a,($cd00)		; $4c6f
	and $01			; $4c72
	ret z			; $4c74
	call $4cb9		; $4c75
	jp interactionSetAnimation		; $4c78
_label_15_092:
	ld a,$01		; $4c7b
	ld (de),a		; $4c7d
	call interactionInitGraphics		; $4c7e
	jp objectSetVisible83		; $4c81
	call checkInteractionState		; $4c84
	jr z,_label_15_092	; $4c87
	ld a,($cd00)		; $4c89
	and $01			; $4c8c
	ret z			; $4c8e
	call $4cb6		; $4c8f
	ld hl,$4ca6		; $4c92
	rst_addDoubleIndex			; $4c95
	ld e,$4b		; $4c96
	ld a,(de)		; $4c98
	and $f0			; $4c99
	or (hl)			; $4c9b
	ld (de),a		; $4c9c
	inc hl			; $4c9d
	ld e,$4d		; $4c9e
	ld a,(de)		; $4ca0
	and $f0			; $4ca1
	or (hl)			; $4ca3
	ld (de),a		; $4ca4
	ret			; $4ca5
	dec b			; $4ca6
	ld ($0905),sp		; $4ca7
	ld b,$09		; $4caa
	rlca			; $4cac
	add hl,bc		; $4cad
	rlca			; $4cae
	ld ($0707),sp		; $4caf
	ld b,$07		; $4cb2
	dec b			; $4cb4
	rlca			; $4cb5
	call objectCenterOnTile		; $4cb6
	call objectGetAngleTowardLink		; $4cb9
	ld b,a			; $4cbc
	and $07			; $4cbd
	jr z,_label_15_093	; $4cbf
	cp $01			; $4cc1
	jr z,_label_15_093	; $4cc3
	cp $07			; $4cc5
	jr z,_label_15_093	; $4cc7
	ld a,b			; $4cc9
	and $fc			; $4cca
	or $04			; $4ccc
	ld b,a			; $4cce
_label_15_093:
	ld a,b			; $4ccf
	rrca			; $4cd0
	rrca			; $4cd1
	and $07			; $4cd2
	ret			; $4cd4
	ld e,$02		; $4cd5
_label_15_094:
	ld bc,$cfae		; $4cd7
_label_15_095:
	ld a,(bc)		; $4cda
	cp $ee			; $4cdb
	call z,$4ce6		; $4cdd
	dec c			; $4ce0
	jr nz,_label_15_095	; $4ce1
	jp interactionDelete		; $4ce3
	call getFreeInteractionSlot		; $4ce6
	ret nz			; $4ce9
	ld (hl),$e2		; $4cea
	inc l			; $4cec
	ld (hl),e		; $4ced
	push bc			; $4cee
	call convertShortToLongPosition_paramC		; $4cef
	ld l,$4b		; $4cf2
	dec b			; $4cf4
	dec b			; $4cf5
	ld (hl),b		; $4cf6
	inc l			; $4cf7
	inc l			; $4cf8
	ld (hl),c		; $4cf9
	pop bc			; $4cfa
	ret			; $4cfb
	call returnIfScrollMode01Unset		; $4cfc
	ld a,($cc53)		; $4cff
	cp $06			; $4d02
	ld a,$00		; $4d04
	jr nc,_label_15_097	; $4d06
_label_15_096:
	call getRandomNumber		; $4d08
	and $03			; $4d0b
	cp $02			; $4d0d
	jr z,_label_15_096	; $4d0f
_label_15_097:
	ld ($ccbf),a		; $4d11
	ld e,$04		; $4d14
	jr _label_15_094		; $4d16
	ld e,$44		; $4d18
	ld a,(de)		; $4d1a
	rst_jumpTable			; $4d1b
	ld a,e			; $4d1c
	ld c,h			; $4d1d
	ldi (hl),a		; $4d1e
	ld c,l			; $4d1f
	jr nc,$1e		; $4d20
	call checkInteractionState2		; $4d22
	jr z,_label_15_100	; $4d25
	call interactionDecCounter1		; $4d27
	jr nz,_label_15_099	; $4d2a
	call interactionIncState		; $4d2c
	ld a,($ccbf)		; $4d2f
	ld b,a			; $4d32
_label_15_098:
	ld hl,wFrameCounter		; $4d33
	inc (hl)		; $4d36
	ld a,(hl)		; $4d37
	and $03			; $4d38
	cp b			; $4d3a
	jr z,_label_15_098	; $4d3b
	add a			; $4d3d
	jp $4c92		; $4d3e
_label_15_099:
	ld a,(wFrameCounter)		; $4d41
	and $03			; $4d44
	ret nz			; $4d46
	call getRandomNumber		; $4d47
	and $07			; $4d4a
	jp $4c92		; $4d4c
_label_15_100:
	ld a,$3c		; $4d4f
	ld (de),a		; $4d51
	ld e,$46		; $4d52
	ld (de),a		; $4d54
	ret			; $4d55

interactionCodee5:
	ld a,($cba0)		; $4d56
	or a			; $4d59
	jr nz,_label_15_101	; $4d5a
	ld a,$02		; $4d5c
	ld ($cbac),a		; $4d5e
	ld a,$08		; $4d61
	ld ($cbae),a		; $4d63
_label_15_101:
	call $4d6c		; $4d66
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $4d69
	ld e,$44		; $4d6c
	ld a,(de)		; $4d6e
	rst_jumpTable			; $4d6f
	ld (hl),h		; $4d70
	ld c,l			; $4d71
	and b			; $4d72
	ld c,l			; $4d73
	call interactionInitGraphics		; $4d74
	ld a,$30		; $4d77
	call interactionSetHighTextIndex		; $4d79
	call interactionSetAlwaysUpdateBit		; $4d7c
	call interactionIncState		; $4d7f
	ld a,$06		; $4d82
	call objectSetCollideRadius		; $4d84
	ld e,$42		; $4d87
	ld a,(de)		; $4d89
	ld hl,$4b48		; $4d8a
	or a			; $4d8d
	jr z,_label_15_102	; $4d8e
	ld e,$5c		; $4d90
	ld a,(de)		; $4d92
	inc a			; $4d93
	ld (de),a		; $4d94
	ld hl,$4b39		; $4d95
_label_15_102:
	call interactionSetScript		; $4d98
	ld e,$71		; $4d9b
	jp objectAddToAButtonSensitiveObjectList		; $4d9d
	jp interactionRunScript		; $4da0
	ld a,(de)		; $4da3
	ld b,b			; $4da4
	ret nc			; $4da5
	nop			; $4da6
	ld (bc),a		; $4da7
	ld d,b			; $4da8
	add sp,$02		; $4da9
	ld (bc),a		; $4dab
	ld hl,sp+$50		; $4dac
	ld ($f806),sp		; $4dae
	ld e,b			; $4db1
	ld a,(bc)		; $4db2
	ld b,$f8		; $4db3
	ld h,b			; $4db5
	inc c			; $4db6
	ld b,$f8		; $4db7
	ld l,b			; $4db9
	ld c,$06		; $4dba
	ld b,b			; $4dbc
	stop			; $4dbd
	stop			; $4dbe
	rlca			; $4dbf
	ld d,b			; $4dc0
	jr $12			; $4dc1
	rlca			; $4dc3
	ld d,b			; $4dc4
	jr z,_label_15_103	; $4dc5
	rlca			; $4dc7
	ld d,b			; $4dc8
	jr nc,$16		; $4dc9
	rlca			; $4dcb
	ld d,b			; $4dcc
	jr c,$1e		; $4dcd
	nop			; $4dcf
	ld b,b			; $4dd0
	jr nz,_label_15_104	; $4dd1
	rlca			; $4dd3
	jr c,_label_15_106	; $4dd4
	ld a,(de)		; $4dd6
	rlca			; $4dd7
	jr z,$2b		; $4dd8
	inc e			; $4dda
_label_15_103:
	rlca			; $4ddb
	ld b,b			; $4ddc
	jr c,$20		; $4ddd
	rlca			; $4ddf
	jr nc,_label_15_110	; $4de0
	ldi (hl),a		; $4de2
	nop			; $4de3
	jr nc,_label_15_109	; $4de4
	inc h			; $4de6
	rlca			; $4de7
	stop			; $4de8
	jr z,_label_15_108	; $4de9
_label_15_104:
	ld bc,$3010		; $4deb
	jr z,_label_15_105	; $4dee
	stop			; $4df0
_label_15_105:
	jr c,_label_15_111	; $4df1
	ld bc,$4010		; $4df3
	inc l			; $4df6
	ld bc,$4000		; $4df7
	ld l,$01		; $4dfa
	dec hl			; $4dfc
	ld (bc),a		; $4dfd
_label_15_106:
	jr nc,_label_15_107	; $4dfe
	jr nc,$50	; $4e00
_label_15_107:
	ldd (hl),a		; $4e02
	nop			; $4e03
	jr nc,$58	; $4e04
	inc (hl)		; $4e06
	nop			; $4e07
	dec e			; $4e08
	ld d,l			; $4e09
	ld (hl),$00		; $4e0a
	ld a,(bc)		; $4e0c
	ld b,(hl)		; $4e0d
	ld c,d			; $4e0e
	adc b			; $4e0f
	inc bc			; $4e10
_label_15_108:
	ld b,(hl)		; $4e11
	ld d,d			; $4e12
	adc d			; $4e13
	inc bc			; $4e14
	ld c,c			; $4e15
_label_15_109:
	ld c,h			; $4e16
	add b			; $4e17
	ld (bc),a		; $4e18
	ld c,c			; $4e19
_label_15_110:
	ld d,h			; $4e1a
	add d			; $4e1b
	ld (bc),a		; $4e1c
_label_15_111:
	ld b,a			; $4e1d
	ld b,d			; $4e1e
	add h			; $4e1f
	inc bc			; $4e20
	ld b,a			; $4e21
	ld c,d			; $4e22
	add (hl)		; $4e23
	inc bc			; $4e24
	add hl,sp		; $4e25
	ld c,(hl)		; $4e26
	sub b			; $4e27
	inc bc			; $4e28
	ld b,e			; $4e29
	ld e,c			; $4e2a
	adc h			; $4e2b
	inc bc			; $4e2c
	add hl,sp		; $4e2d
	ld b,(hl)		; $4e2e
	adc (hl)		; $4e2f
	inc bc			; $4e30
	dec sp			; $4e31
	inc a			; $4e32
	sub d			; $4e33
	inc bc			; $4e34

	.include "code/staticObjects.s"
	.include "build/data/staticDungeonObjects.s"
	.include "build/data/chestData.s"

	.include "build/data/treasureObjectData.s"

	ld bc,$0072		; $5481
	jp $5500		; $5484
	xor a			; $5487
	ld ($ccba),a		; $5488
	ld l,$84		; $548b
	ld h,$cf		; $548d
	ldi a,(hl)		; $548f
	cp $2c			; $5490
	ret nz			; $5492
	ldi a,(hl)		; $5493
	cp $2c			; $5494
	ret nz			; $5496
	ldi a,(hl)		; $5497
	cp $2c			; $5498
	ret nz			; $549a
	ldi a,(hl)		; $549b
	cp $2d			; $549c
	ret nz			; $549e
	ldi a,(hl)		; $549f
	cp $2d			; $54a0
	ret nz			; $54a2
	ldi a,(hl)		; $54a3
	cp $2d			; $54a4
	ret nz			; $54a6
	ld a,$01		; $54a7
	ld ($ccba),a		; $54a9
	ret			; $54ac
	call getThisRoomFlags		; $54ad
	set 7,(hl)		; $54b0
	ld a,$4d		; $54b2
	jp playSound		; $54b4
	call getFreePartSlot		; $54b7
	ret nz			; $54ba
	ld (hl),$0c		; $54bb
	ld l,$c7		; $54bd
	ld (hl),b		; $54bf
	ld l,$c9		; $54c0
	ld (hl),c		; $54c2
	ld l,$cb		; $54c3
	ld (hl),e		; $54c5
	ret			; $54c6
	call $54ad		; $54c7
	ld bc,$0601		; $54ca
	ld e,$59		; $54cd
	jp $54b7		; $54cf
	ld a,$4d		; $54d2
	call playSound		; $54d4
	ld bc,$0801		; $54d7
	ld e,$77		; $54da
	jp $54b7		; $54dc
	call $54ad		; $54df
	ld bc,$0c02		; $54e2
	ld e,$3c		; $54e5
	jp $54b7		; $54e7
	call $54ad		; $54ea
	ld bc,$0e00		; $54ed
	ld e,$7b		; $54f0
	jp $54b7		; $54f2
	call $54ad		; $54f5
	ld bc,$0e03		; $54f8
	ld e,$88		; $54fb
	jp $54b7		; $54fd
	call getFreePartSlot		; $5500
	ret nz			; $5503
	ld (hl),$0a		; $5504
	inc l			; $5506
	ld (hl),b		; $5507
	ld l,$cb		; $5508
	ld (hl),c		; $550a
	ret			; $550b
	ld a,$01		; $550c
	ld ($ccbf),a		; $550e
	ret			; $5511
	ld a,($cc59)		; $5512
	ld b,a			; $5515
	ld c,$53		; $5516
	ld a,(bc)		; $5518
	bit 7,a			; $5519
	ret z			; $551b
	call getFreeInteractionSlot		; $551c
	ld (hl),$1e		; $551f
	ld l,$49		; $5521
	ld (hl),$10		; $5523
	ld l,$4b		; $5525
	ld (hl),$07		; $5527
	ret			; $5529
	ld e,$49		; $552a
	ld a,(de)		; $552c
	ld l,a			; $552d
	jr _label_15_189		; $552e
	ld l,$d4		; $5530
	jr _label_15_189		; $5532
	ld l,$d3		; $5534
_label_15_189:
	ld a,($cc59)		; $5536
	ld h,a			; $5539
	set 7,(hl)		; $553a
	ret			; $553c
	ld b,$00		; $553d
	ld a,($ccba)		; $553f
	or a			; $5542
	jr z,_label_15_190	; $5543
	ld a,(wFrameCounter)		; $5545
	and $01			; $5548
	inc a			; $554a
	ld b,a			; $554b
_label_15_190:
	ld a,b			; $554c
	ld ($cfc1),a		; $554d
	ret			; $5550
	call getFreePartSlot		; $5551
	ret nz			; $5554
	ld (hl),$0a		; $5555
	inc l			; $5557
	ld (hl),$04		; $5558
	ld bc,$0603		; $555a
	ld e,$14		; $555d
	jp $54b7		; $555f
	xor a			; $5562
	ld ($cfd0),a		; $5563
	call getThisRoomFlags		; $5566
	inc hl			; $5569
	res 5,(hl)		; $556a
	ret			; $556c
	ld hl,$5573		; $556d
	jp setWarpDestVariables		; $5570
	add l			; $5573
	ld e,e			; $5574
	nop			; $5575
	ld d,a			; $5576
	inc bc			; $5577
	call getRandomNumber		; $5578
	and $07			; $557b
	ld hl,$55a3		; $557d
	rst_addAToHl			; $5580
	ld l,(hl)		; $5581
	ld h,$cf		; $5582
	ld (hl),$25		; $5584
	ld a,$03		; $5586
	ld ($ff00+$70),a	; $5588
	ld h,$df		; $558a
	ld (hl),$25		; $558c
	xor a			; $558e
	ld ($ff00+$70),a	; $558f
	call getFreeEnemySlot		; $5591
	ret nz			; $5594
	ld (hl),$1d		; $5595
	inc l			; $5597
	ld (hl),$00		; $5598
	ld l,$8b		; $559a
	ld (hl),$27		; $559c
	ld l,$8d		; $559e
	ld (hl),$a0		; $55a0
	ret			; $55a2
	ld (hl),$38		; $55a3
	ld b,l			; $55a5
	ld c,c			; $55a6
	ld h,l			; $55a7
	ld l,c			; $55a8
	halt			; $55a9
	ld a,b			; $55aa
	call objectGetTileAtPosition		; $55ab
	cp $a3			; $55ae
	ret z			; $55b0
	ld c,l			; $55b1
	ld a,$a3		; $55b2
	call setTile		; $55b4
	jr _label_15_191		; $55b7
	call objectGetTileAtPosition		; $55b9
	cp $f1			; $55bc
	ret z			; $55be
	cp $f0			; $55bf
	ret z			; $55c1
	ld c,l			; $55c2
	ld a,$f1		; $55c3
	call setTile		; $55c5
	ld a,$4d		; $55c8
	call playSound		; $55ca
_label_15_191:
	jp objectCreatePuff		; $55cd
	call getFreeInteractionSlot		; $55d0
	ret nz			; $55d3
	ld (hl),$60		; $55d4
	inc l			; $55d6
	ld (hl),$30		; $55d7
	inc l			; $55d9
	ld (hl),$01		; $55da
	call objectCopyPosition		; $55dc
	call getThisRoomFlags		; $55df
	set 6,(hl)		; $55e2
	ld l,$45		; $55e4
	set 7,(hl)		; $55e6
	ld a,$4d		; $55e8
	jp playSound		; $55ea
	ld a,$56		; $55ed
_label_15_192:
	call getARoomFlags		; $55ef
	bit 6,(hl)		; $55f2
	ld a,$01		; $55f4
	jr nz,_label_15_193	; $55f6
	dec a			; $55f8
_label_15_193:
	ld ($cfc1),a		; $55f9
	ret			; $55fc
	ld a,$4e		; $55fd
	jr _label_15_192		; $55ff
	ld a,($cc7a)		; $5601
	or a			; $5604
	jr nz,_label_15_194	; $5605
	ld a,(wFrameCounter)		; $5607
	rrca			; $560a
	ret c			; $560b
	ld h,d			; $560c
	ld l,$48		; $560d
	dec (hl)		; $560f
	ret nz			; $5610
	call getFreeEnemySlot		; $5611
	jr nz,_label_15_194	; $5614
	ld (hl),$1d		; $5616
	ld l,$8b		; $5618
	ld (hl),$27		; $561a
	ld l,$8d		; $561c
	ld (hl),$a0		; $561e
	ld a,$45		; $5620
	ld ($ccbc),a		; $5622
	ld a,$4d		; $5625
	call playSound		; $5627
	call getThisRoomFlags		; $562a
	set 7,(hl)		; $562d
_label_15_194:
	ld e,$49		; $562f
	ld a,$01		; $5631
	ld (de),a		; $5633
	ret			; $5634
	ld a,$d0		; $5635
	call findTileInRoom		; $5637
	ld a,l			; $563a
	ld l,$4b		; $563b
	ld h,d			; $563d
	jp setShortPosition		; $563e
	ld a,($cca4)		; $5641
	or a			; $5644
	ret nz			; $5645
	ld b,$39		; $5646
	call $5660		; $5648
	cp $04			; $564b
	ret nc			; $564d
	call getRandomNumber		; $564e
	cp $40			; $5651
	ret c			; $5653
	call getFreeEnemySlot_uncounted		; $5654
	ret nz			; $5657
	ld (hl),$39		; $5658
	inc l			; $565a
	ld (hl),$01		; $565b
	jp objectCopyPosition		; $565d
	ld c,$00		; $5660
	ld hl,$d080		; $5662
_label_15_195:
	ldi a,(hl)		; $5665
	or a			; $5666
	jr z,_label_15_196	; $5667
	ld a,(hl)		; $5669
	cp b			; $566a
	jr nz,_label_15_196	; $566b
	inc c			; $566d
_label_15_196:
	dec l			; $566e
	inc h			; $566f
	ld a,h			; $5670
	cp $e0			; $5671
	jr c,_label_15_195	; $5673
	ld a,c			; $5675
	or a			; $5676
	ret			; $5677
	xor a			; $5678
	ld ($cfc1),a		; $5679
	ld h,$cf		; $567c
	ld l,$4d		; $567e
	ld a,$2f		; $5680
	cp (hl)			; $5682
	ret nz			; $5683
	ld l,$5d		; $5684
	cp (hl)			; $5686
	ret nz			; $5687
	ld l,$6d		; $5688
	cp (hl)			; $568a
	ret nz			; $568b
	ld a,$01		; $568c
	ld ($cfc1),a		; $568e
	ret			; $5691
	ld e,$06		; $5692
_label_15_197:
	call getFreeEnemySlot		; $5694
	ret nz			; $5697
	ld (hl),$10		; $5698
	inc l			; $569a
	ld (hl),$01		; $569b
	call $56a4		; $569d
	dec e			; $56a0
	jr nz,_label_15_197	; $56a1
	ret			; $56a3
_label_15_198:
	call getRandomNumber		; $56a4
	and $07			; $56a7
	inc a			; $56a9
	swap a			; $56aa
	ld b,a			; $56ac
	bit 7,a			; $56ad
	jr nz,_label_15_198	; $56af
	call getRandomNumber		; $56b1
	and $07			; $56b4
	add $03			; $56b6
	or b			; $56b8
	ld b,$ce		; $56b9
	ld c,a			; $56bb
	ld a,(bc)		; $56bc
	or a			; $56bd
	jr nz,_label_15_198	; $56be
	ld l,$8b		; $56c0
	jp setShortPosition_paramC		; $56c2
	ld e,$49		; $56c5
	ld a,(de)		; $56c7
	ld b,a			; $56c8
	ld a,($cc31)		; $56c9
	and b			; $56cc
	cp b			; $56cd
	ld a,$01		; $56ce
	jr z,_label_15_199	; $56d0
	xor a			; $56d2
_label_15_199:
	ld ($ccba),a		; $56d3
	ret			; $56d6
	ld e,$49		; $56d7
	ld a,(de)		; $56d9
	ld c,a			; $56da
	ld b,$7c		; $56db
	jp objectCreateInteraction		; $56dd
	call getThisRoomFlags		; $56e0
	ld l,$93		; $56e3
	res 6,(hl)		; $56e5
	inc l			; $56e7
	res 6,(hl)		; $56e8
	inc l			; $56ea
	res 6,(hl)		; $56eb
	ret			; $56ed
	ld a,$08		; $56ee
	call findTileInRoom		; $56f0
	ret nz			; $56f3
	call $5702		; $56f4
_label_15_200:
	ld a,$08		; $56f7
	call backwardsSearch		; $56f9
	ret nz			; $56fc
	call $5702		; $56fd
	jr _label_15_200		; $5700
	push hl			; $5702
	ld c,l			; $5703
	call getFreePartSlot		; $5704
	jr nz,_label_15_201	; $5707
	ld (hl),$06		; $5709
	inc l			; $570b
	ld (hl),$01		; $570c
	ld l,$c7		; $570e
	ld (hl),$30		; $5710
	ld l,$cb		; $5712
	call setShortPosition_paramC		; $5714
_label_15_201:
	pop hl			; $5717
	dec hl			; $5718
	ret			; $5719
	call fadeoutToBlackWithDelay		; $571a
	jr _label_15_202		; $571d
	call fadeinFromBlackWithDelay		; $571f
_label_15_202:
	ld a,$ff		; $5722
	ld ($c4b1),a		; $5724
	ld ($c4b3),a		; $5727
	ld a,$01		; $572a
	ld ($c4b2),a		; $572c
	ld a,$fe		; $572f
	ld ($c4b4),a		; $5731
	ret			; $5734
	ld c,a			; $5735
	call checkIsLinkedGame		; $5736
	jr z,_label_15_203	; $5739
	ld a,c			; $573b
	add $1b			; $573c
	ld c,a			; $573e
_label_15_203:
	ld b,$17		; $573f
	jp showText		; $5741
	ld a,$10		; $5744
	jr _label_15_204		; $5746
	ld a,$08		; $5748
_label_15_204:
	ld h,d			; $574a
	ld l,$7e		; $574b
	ld b,(hl)		; $574d
	and b			; $574e
	ld l,$7f		; $574f
	ld (hl),$01		; $5751
	ret nz			; $5753
	ld (hl),$00		; $5754
	ret			; $5756
	ld a,($d601)		; $5757
	cp $05			; $575a
	ret nz			; $575c
	ld a,($cc7e)		; $575d
	or a			; $5760
	ret nz			; $5761
	call objectCheckCollidedWithLink_notDead		; $5762
	ret nc			; $5765
	ld a,$01		; $5766
	ld ($cfc0),a		; $5768
	ret			; $576b
	ld e,$42		; $576c
	ld a,(de)		; $576e
	cp $04			; $576f
	ret nz			; $5771
	call checkIsLinkedGame		; $5772
	ret z			; $5775
	call getFreeInteractionSlot		; $5776
	ret nz			; $5779
	ld (hl),$b3		; $577a
	inc l			; $577c
	ld (hl),$04		; $577d
	ld l,$4a		; $577f
	ld (hl),$28		; $5781
	ld l,$4c		; $5783
	ld (hl),$58		; $5785
	ret			; $5787
	ld e,$57		; $5788
	ld a,(de)		; $578a
	ld h,a			; $578b
	ld l,$4b		; $578c
	ld b,(hl)		; $578e
	ld l,$4d		; $578f
	ld c,(hl)		; $5791
	ld a,$6e		; $5792
	jp createEnergySwirlGoingIn		; $5794
	ld b,$00		; $5797
	jr _label_15_205		; $5799
	ld b,$01		; $579b
_label_15_205:
	call getFreeInteractionSlot		; $579d
	ret nz			; $57a0
	ld (hl),$50		; $57a1
	ld e,$43		; $57a3
	ld a,(de)		; $57a5
	inc l			; $57a6
	ldi (hl),a		; $57a7
	ld (hl),b		; $57a8
	ld l,$4b		; $57a9
	ld (hl),$18		; $57ab
	ld l,$4d		; $57ad
	ld (hl),$70		; $57af
	ld e,$57		; $57b1
	ld a,h			; $57b3
	ld (de),a		; $57b4
	ret			; $57b5
	ld a,($c6b0)		; $57b6
	add a			; $57b9
	call getNumSetBits		; $57ba
	ld h,d			; $57bd
	ld l,$7f		; $57be
	ld (hl),$00		; $57c0
	cp $04			; $57c2
	ret nz			; $57c4
	inc (hl)		; $57c5
	ld a,($cc4c)		; $57c6
	cp $f5			; $57c9
	ret z			; $57cb
	inc (hl)		; $57cc
	ret			; $57cd
	ld a,$05		; $57ce
	ld b,$b6		; $57d0
	call getRoomFlags		; $57d2
	and $40			; $57d5
	ld a,$01		; $57d7
	jr nz,_label_15_206	; $57d9
	xor a			; $57db
_label_15_206:
	ld e,$7c		; $57dc
	ld (de),a		; $57de
	ret			; $57df
	xor a			; $57e0
	ld ($d02b),a		; $57e1
	ret			; $57e4
	ld a,$04		; $57e5
	call interactionSetAnimation		; $57e7
	ld b,$f0		; $57ea
	ld c,$fc		; $57ec
	ld a,$40		; $57ee
	jp objectCreateExclamationMark		; $57f0
	call objectApplySpeed		; $57f3
	ld c,$10		; $57f6
	call objectCheckLinkWithinDistance		; $57f8
	ret nc			; $57fb
	ld e,$76		; $57fc
	ld a,$01		; $57fe
	ld (de),a		; $5800
	ret			; $5801
	ld e,$4b		; $5802
	ld a,(de)		; $5804
	ld hl,$d00b		; $5805
	cp (hl)			; $5808
	jp nz,objectApplySpeed		; $5809
	ld e,$76		; $580c
	ld a,$01		; $580e
	ld (de),a		; $5810
	ret			; $5811
	ld b,a			; $5812
	push bc			; $5813
	call objectApplySpeed		; $5814
	ld e,$4b		; $5817
	ld a,(de)		; $5819
	pop bc			; $581a
	sub b			; $581b
	ret nz			; $581c
	ld e,$76		; $581d
	ld (de),a		; $581f
	ret			; $5820
	ld b,$00		; $5821
	ld a,($c6bb)		; $5823
	bit 1,a			; $5826
	jr z,_label_15_207	; $5828
	inc b			; $582a
	ld a,$30		; $582b
	call checkGlobalFlag		; $582d
	jr z,_label_15_207	; $5830
	inc b			; $5832
_label_15_207:
	ld hl,$cfc0		; $5833
	ld (hl),b		; $5836
	ret			; $5837
	call objectApplySpeed		; $5838
	ld c,$10		; $583b
	jp objectUpdateSpeedZ_paramC		; $583d
	ld e,$4b		; $5840
	ld a,(de)		; $5842
	ld hl,$d00b		; $5843
	cp (hl)			; $5846
	ld a,$10		; $5847
	jr c,_label_15_208	; $5849
	xor a			; $584b
_label_15_208:
	ld e,$49		; $584c
	ld (de),a		; $584e
	ret			; $584f
	ld e,$42		; $5850
	ld a,(de)		; $5852
	ld hl,$585c		; $5853
	rst_addAToHl			; $5856
	ld b,$43		; $5857
	ld c,(hl)		; $5859
	jp showText		; $585a
	ld (bc),a		; $585d
	inc bc			; $585e
	inc bc			; $585f
	inc b			; $5860
	dec b			; $5861
	ld b,$07		; $5862
	ld ($2108),sp		; $5864
.DB $db				; $5867
	add $77			; $5868
	ret			; $586a
	ld hl,$c6dc		; $586b
	jp setFlag		; $586e
	ld hl,$c6dc		; $5871
	call checkFlag		; $5874
	ld a,$01		; $5877
	jr nz,_label_15_209	; $5879
	xor a			; $587b
_label_15_209:
	ld e,$7b		; $587c
	ld (de),a		; $587e
	ret			; $587f
	call cpRupeeValue		; $5880
	ld e,$7c		; $5883
	ld (de),a		; $5885
	ret			; $5886
	ld hl,$c60f		; $5887
	add (hl)		; $588a
	ld (hl),a		; $588b
	ret			; $588c
	ld hl,$c609		; $588d
	ld b,$00		; $5890
_label_15_210:
	ldi a,(hl)		; $5892
	or a			; $5893
	jr z,_label_15_211	; $5894
	and $0f			; $5896
	add b			; $5898
	ld b,a			; $5899
	jr _label_15_210		; $589a
_label_15_211:
	ld a,b			; $589c
_label_15_212:
	sub $03			; $589d
	jr nc,_label_15_212	; $589f
	add $04			; $58a1
	ld ($c60f),a		; $58a3
	ret			; $58a6
	ld a,$07		; $58a7
	jp openMenu		; $58a9
	ld hl,$cfde		; $58ac
	jr _label_15_213		; $58af
	ld hl,$cfdc		; $58b1
_label_15_213:
	ld (hl),d		; $58b4
	inc hl			; $58b5
	ld (hl),$58		; $58b6
	ret			; $58b8
	ld a,$10		; $58b9
	ld ($cc6b),a		; $58bb
	ld hl,$d008		; $58be
	ld (hl),$03		; $58c1
	ret			; $58c3
	ld a,($d00b)		; $58c4
	ld e,$4b		; $58c7
	ld (de),a		; $58c9
	ret			; $58ca
	ld a,($d00b)		; $58cb
	sub $08			; $58ce
	ld e,$4b		; $58d0
	ld (de),a		; $58d2
	ret			; $58d3
	ld e,$4d		; $58d4
	ld a,(de)		; $58d6
	ld b,a			; $58d7
	ld c,$f2		; $58d8
	jr _label_15_214		; $58da
	ld e,$4d		; $58dc
	ld a,(de)		; $58de
	ld b,a			; $58df
	ld c,$0e		; $58e0
_label_15_214:
	ld a,($cfc1)		; $58e2
	add c			; $58e5
	sub b			; $58e6
	ld e,$47		; $58e7
	ld (de),a		; $58e9
	ret			; $58ea
	ld a,$1e		; $58eb
	jp giveTreasure		; $58ed
	ld a,$64		; $58f0
	ld h,d			; $58f2
	ld l,$7e		; $58f3
	add (hl)		; $58f5
	call checkGlobalFlag		; $58f6
	ret z			; $58f9
	ld h,d			; $58fa
	ld l,$7f		; $58fb
	ld (hl),$01		; $58fd
	ret			; $58ff
	ld h,d			; $5900
	ld l,$7e		; $5901
	ld b,(hl)		; $5903
	ld a,$64		; $5904
	add b			; $5906
	call setGlobalFlag		; $5907
	ld a,$00		; $590a
	add b			; $590c
	ld ($c6e6),a		; $590d
	ld bc,$0003		; $5910
	jp secretFunctionCaller		; $5913
	ld c,a			; $5916
	ld a,$53		; $5917
	call interactionSetHighTextIndex		; $5919
	ld a,c			; $591c
	add $00			; $591d
	ld c,a			; $591f
	ld e,$7e		; $5920
	ld a,(de)		; $5922
	ld b,a			; $5923
	add a			; $5924
	add b			; $5925
	add a			; $5926
	add c			; $5927
	ld e,$72		; $5928
	ld (de),a		; $592a
	ret			; $592b
	ld a,($c626)		; $592c
	ld b,a			; $592f
	or a			; $5930
	ld c,$00		; $5931
	jr z,_label_15_215	; $5933
	inc c			; $5935
	cp $14			; $5936
	jr c,_label_15_215	; $5938
	inc c			; $593a
	cp $32			; $593b
	jr c,_label_15_215	; $593d
	inc c			; $593f
	cp $5a			; $5940
	jr c,_label_15_215	; $5942
	inc c			; $5944
	cp $64			; $5945
	jr c,_label_15_215	; $5947
	inc c			; $5949
_label_15_215:
	ld a,c			; $594a
	ld ($cfc0),a		; $594b
	ld a,b			; $594e
	call hexToDec		; $594f
	swap c			; $5952
	or c			; $5954
	ld ($cba8),a		; $5955
	ld a,b			; $5958
	ld ($cba9),a		; $5959
	ret			; $595c
	ld bc,$3700		; $595d
	jp giveRingToLink		; $5960
	ld a,$09		; $5963
	jp openMenu		; $5965
	ld e,$4d		; $5968
	ld a,(de)		; $596a
	srl a			; $596b
	add $10			; $596d
	ld e,$47		; $596f
	ld (de),a		; $5971
	ret			; $5972
	ld e,$77		; $5973
	xor a			; $5975
	ld (de),a		; $5976
	ld a,$46		; $5977
	jp loseTreasure		; $5979
	ld h,d			; $597c
	ld l,$42		; $597d
	ld (hl),$01		; $597f
	ld l,$44		; $5981
	xor a			; $5983
	ldi (hl),a		; $5984
	ld (hl),a		; $5985
	ld a,$27		; $5986
	ld (wActiveMusic),a		; $5988
	jp playSound		; $598b
	ld hl,$c60f		; $598e
	add (hl)		; $5991
	ld (hl),a		; $5992
	ret			; $5993
	call cpRupeeValue		; $5994
	ld e,$7c		; $5997
	ld (de),a		; $5999
	ret			; $599a
	ld hl,$cba5		; $599b
	add (hl)		; $599e
	ld ($c6dd),a		; $599f
	ret			; $59a2
	ld a,($c6dd)		; $59a3
	or a			; $59a6
	jr nz,_label_15_216	; $59a7
	ld a,$38		; $59a9
	jp playSound		; $59ab
_label_15_216:
	ld a,$4a		; $59ae
	jp playSound		; $59b0
	ld c,$40		; $59b3
	jr _label_15_217		; $59b5
	ld c,$04		; $59b7
_label_15_217:
	ld a,$29		; $59b9
	jp giveTreasure		; $59bb
	ld c,a			; $59be
	ld a,$28		; $59bf
	jp giveTreasure		; $59c1
	ld a,($c6c6)		; $59c4
	dec a			; $59c7
	ld c,$03		; $59c8
	jr z,_label_15_218	; $59ca
	ld c,$05		; $59cc
_label_15_218:
	ld b,$00		; $59ce
	ld hl,$cba8		; $59d0
	ld (hl),c		; $59d3
	inc hl			; $59d4
	ld (hl),b		; $59d5
	ret			; $59d6
	ld b,a			; $59d7
	ld e,$42		; $59d8
	ld a,(de)		; $59da
	add a			; $59db
	add b			; $59dc
	ld hl,$59e5		; $59dd
	rst_addAToHl			; $59e0
	ld b,$3a		; $59e1
	ld c,(hl)		; $59e3
	jp showText		; $59e4
	nop			; $59e7
	ld bc,$0302		; $59e8
	inc b			; $59eb
	dec b			; $59ec
	ld b,$07		; $59ed
	ld ($0908),sp		; $59ef
	add hl,bc		; $59f2
	ld c,$30		; $59f3
	call objectUpdateSpeedZ_paramC		; $59f5
	ret nz			; $59f8
	ld h,d			; $59f9
	ld l,$7d		; $59fa
	ld (hl),$01		; $59fc
	ret			; $59fe
	ld b,a			; $59ff
	ld e,$4d		; $5a00
	ld a,(de)		; $5a02
	and $f0			; $5a03
	swap a			; $5a05
	ld c,a			; $5a07
	ld a,b			; $5a08
	jp setTile		; $5a09
	ld a,$13		; $5a0c
	call setGlobalFlag		; $5a0e
	ld hl,$5a1c		; $5a11
	call setWarpDestVariables		; $5a14
	ld a,$8d		; $5a17
	jp playSound		; $5a19
	add c			; $5a1c
	ld (hl),h		; $5a1d
	nop			; $5a1e
	ld b,d			; $5a1f
	add e			; $5a20
	call getFreeInteractionSlot		; $5a21
	ret nz			; $5a24
	ld (hl),$40		; $5a25
	inc l			; $5a27
	ld (hl),$0c		; $5a28
	ld l,$4b		; $5a2a
	ld (hl),$28		; $5a2c
	ld l,$4d		; $5a2e
	ld (hl),$78		; $5a30
	ret			; $5a32
	call getFreeInteractionSlot		; $5a33
	ret nz			; $5a36
	ld (hl),$b8		; $5a37
	inc l			; $5a39
	ld (hl),$03		; $5a3a
	ld l,$4b		; $5a3c
	ld (hl),$88		; $5a3e
	ld l,$4d		; $5a40
	ld (hl),$50		; $5a42
	ret			; $5a44
	ld hl,$5a4d		; $5a45
	ld a,$15		; $5a48
	jp setSimulatedInputAddress		; $5a4a
	ld d,b			; $5a4d
	nop			; $5a4e
	stop			; $5a4f
	inc b			; $5a50
	nop			; $5a51
	nop			; $5a52
	jr nz,_label_15_219	; $5a53
_label_15_219:
	ld b,b			; $5a55
	ld ($0000),sp		; $5a56
	rst $38			; $5a59
	rst $38			; $5a5a
	ld hl,$d01a		; $5a5b
	res 7,(hl)		; $5a5e
	ret			; $5a60
	ld h,d			; $5a61
	ld l,$5a		; $5a62
	res 7,(hl)		; $5a64
	ret			; $5a66
	call setLinkForceStateToState08		; $5a67
	ld hl,$d008		; $5a6a
	ld (hl),$01		; $5a6d
	ret			; $5a6f
	ld e,$4d		; $5a70
	ld a,(de)		; $5a72
	ld hl,$d00d		; $5a73
	sub (hl)		; $5a76
	ld b,a			; $5a77
	add $0c			; $5a78
	cp $18			; $5a7a
	ret nc			; $5a7c
	ld a,($d00b)		; $5a7d
	cp $38			; $5a80
	ret c			; $5a82
	ld a,b			; $5a83
	sub (hl)		; $5a84
	ld a,$01		; $5a85
	jr nc,_label_15_220	; $5a87
	inc a			; $5a89
_label_15_220:
	ld e,$79		; $5a8a
	ld (de),a		; $5a8c
	ret			; $5a8d
	xor a			; $5a8e
	ld e,$79		; $5a8f
	ld (de),a		; $5a91
	ld hl,$c6a7		; $5a92
	ldi a,(hl)		; $5a95
	cp $77			; $5a96
	ret nz			; $5a98
	ld a,(hl)		; $5a99
	cp $07			; $5a9a
	ret nz			; $5a9c
	ld a,$01		; $5a9d
	ld (de),a		; $5a9f
	ret			; $5aa0
	ld hl,$c6ab		; $5aa1
	ld a,(hl)		; $5aa4
	add $20			; $5aa5
	ldd (hl),a		; $5aa7
	ld (hl),a		; $5aa8
	jp setStatusBarNeedsRefreshBit1		; $5aa9
	ld hl,$c6a3		; $5aac
	ld a,($c6a2)		; $5aaf
	cp (hl)			; $5ab2
	ret nz			; $5ab3
	ld e,$7f		; $5ab4
	ld a,$01		; $5ab6
	ld (de),a		; $5ab8
	ret			; $5ab9
	ld hl,$c6a2		; $5aba
	ld a,($cbe4)		; $5abd
	cp (hl)			; $5ac0
	ret nz			; $5ac1
	ld e,$7f		; $5ac2
	ld a,$01		; $5ac4
	ld (de),a		; $5ac6
	ret			; $5ac7
	ld b,$f8		; $5ac8
	ld c,$10		; $5aca
	ld a,$28		; $5acc
	jp objectCreateExclamationMark		; $5ace
	call getThisRoomFlags		; $5ad1
	res 5,(hl)		; $5ad4
	ret			; $5ad6
	ld hl,$d008		; $5ad7
	ld a,(hl)		; $5ada
	xor $02			; $5adb
	add $09			; $5add
	jp interactionSetAnimation		; $5adf
	ld b,a			; $5ae2
	ld c,$00		; $5ae3
	call checkIsLinkedGame		; $5ae5
	jr z,_label_15_221	; $5ae8
	ld c,$0a		; $5aea
_label_15_221:
	ld a,b			; $5aec
	add c			; $5aed
	ld h,d			; $5aee
	ld l,$72		; $5aef
	ldi (hl),a		; $5af1
	ld (hl),$0c		; $5af2
	ret			; $5af4
	jp loadAnimationData		; $5af5
	ld a,$41		; $5af8
	call checkTreasureObtained		; $5afa
	ld h,d			; $5afd
	ld l,$7f		; $5afe
	jr nc,_label_15_222	; $5b00
	cp $05			; $5b02
	jr c,_label_15_222	; $5b04
	ld (hl),$01		; $5b06
	ret			; $5b08
_label_15_222:
	ld (hl),$00		; $5b09
	ret			; $5b0b
	call getFreeInteractionSlot		; $5b0c
	ret nz			; $5b0f
	ld (hl),$84		; $5b10
	push de			; $5b12
	ld de,$d00b		; $5b13
	call objectCopyPosition_rawAddress		; $5b16
	pop de			; $5b19
	ret			; $5b1a
	ld a,$58		; $5b1b
	call loseTreasure		; $5b1d
	ld a,$49		; $5b20
	jp loseTreasure		; $5b22
	ld hl,$cfde		; $5b25
	ld bc,$627b		; $5b28
	jr _label_15_223		; $5b2b
	ld a,$0b		; $5b2d
	ld ($cc6a),a		; $5b2f
	ld hl,$d00b		; $5b32
	ld a,$68		; $5b35
	sub (hl)		; $5b37
	ld ($cc6c),a		; $5b38
	ld l,$08		; $5b3b
	ld (hl),$02		; $5b3d
	ld l,$09		; $5b3f
	ld (hl),$10		; $5b41
	ld hl,$cfde		; $5b43
	ld bc,$62c9		; $5b46
	call $5b52		; $5b49
	ld hl,$cfdc		; $5b4c
	ld bc,$62db		; $5b4f
_label_15_223:
	ldi a,(hl)		; $5b52
	ld l,(hl)		; $5b53
	ld h,a			; $5b54
	ld (hl),c		; $5b55
	inc l			; $5b56
	ld (hl),b		; $5b57
	ret			; $5b58
	ld c,$04		; $5b59
	jr _label_15_224		; $5b5b
	ld c,$05		; $5b5d
_label_15_224:
	ld b,$4c		; $5b5f
	jp objectCreateInteraction		; $5b61
	call getFreePartSlot		; $5b64
	ret nz			; $5b67
	ld (hl),$04		; $5b68
	ld l,$cb		; $5b6a
	ld (hl),$1c		; $5b6c
	ld l,$cd		; $5b6e
	ld (hl),$70		; $5b70
	ret			; $5b72
	ld a,$50		; $5b73
	call loseTreasure		; $5b75
	ld a,$51		; $5b78
	call loseTreasure		; $5b7a
	call getFreeInteractionSlot		; $5b7d
	ret nz			; $5b80
	ld (hl),$60		; $5b81
	inc l			; $5b83
	ld (hl),$52		; $5b84
	ld l,$4b		; $5b86
	ld (hl),$1c		; $5b88
	ld l,$4d		; $5b8a
	ld (hl),$70		; $5b8c
	ret			; $5b8e
	ld a,$e8		; $5b8f
	ld c,$06		; $5b91
	call setTile		; $5b93
	ld a,$e9		; $5b96
	ld c,$07		; $5b98
	call setTile		; $5b9a
	ld a,$ea		; $5b9d
	ld c,$16		; $5b9f
	call setTile		; $5ba1
	ld a,$eb		; $5ba4
	ld c,$17		; $5ba6
	call setTile		; $5ba8
	ld a,$70		; $5bab
	jp playSound		; $5bad
	ld a,$e4		; $5bb0
	ld c,$06		; $5bb2
	call setTile		; $5bb4
	ld a,$e5		; $5bb7
	ld c,$07		; $5bb9
	call setTile		; $5bbb
	ld a,$e6		; $5bbe
	ld c,$16		; $5bc0
	call setTile		; $5bc2
	ld a,$e7		; $5bc5
	ld c,$17		; $5bc7
	jp setTile		; $5bc9
	ld a,$01		; $5bcc
_label_15_225:
	ld ($ccab),a		; $5bce
	ld ($ccea),a		; $5bd1
	ret			; $5bd4
	xor a			; $5bd5
	jr _label_15_225		; $5bd6
	call refreshObjectGfx		; $5bd8
	ldh a,(<hActiveObject)	; $5bdb
	ld d,a			; $5bdd
	ld b,$54		; $5bde
	jp objectCreateInteractionWithSubid00		; $5be0
	ld h,d			; $5be3
	ld l,$50		; $5be4
	ld (hl),$28		; $5be6
	ld l,$54		; $5be8
	ld (hl),$00		; $5bea
	inc hl			; $5bec
	ld (hl),$fe		; $5bed
	ld a,$53		; $5bef
	jp playSound		; $5bf1
	ld c,$30		; $5bf4
	call objectUpdateSpeedZ_paramC		; $5bf6
	ret nz			; $5bf9
	ld h,d			; $5bfa
	ld l,$7d		; $5bfb
	ld (hl),$01		; $5bfd
	ret			; $5bff
	ld a,$1a		; $5c00
	call checkGlobalFlag		; $5c02
	ld a,$04		; $5c05
	jr z,_label_15_226	; $5c07
	ld a,$05		; $5c09
_label_15_226:
	ld e,$78		; $5c0b
	ld (de),a		; $5c0d
	call cpRupeeValue		; $5c0e
	ld e,$77		; $5c11
	ld (de),a		; $5c13
	ld a,$00		; $5c14
	ld ($cced),a		; $5c16
	xor a			; $5c19
	ld e,$71		; $5c1a
	ld (de),a		; $5c1c
	ld e,$44		; $5c1d
	ld a,$01		; $5c1f
	ld (de),a		; $5c21
	ret			; $5c22
	ld e,$78		; $5c23
	ld a,(de)		; $5c25
	jp removeRupeeValue		; $5c26
	ld e,$78		; $5c29
	ld a,(de)		; $5c2b
	call getRupeeValue		; $5c2c
	ld hl,$cba8		; $5c2f
	ld (hl),c		; $5c32
	inc hl			; $5c33
	ld (hl),b		; $5c34
	ret			; $5c35
	ld c,$07		; $5c36
	ld a,$28		; $5c38
	jp giveTreasure		; $5c3a
	call clearPegasusSeedCounter		; $5c3d
	call clearAllParentItems		; $5c40
	call dropLinkHeldItem		; $5c43
	jp clearItems		; $5c46
	call setLinkForceStateToState08		; $5c49
	ld hl,$d008		; $5c4c
	ld (hl),$03		; $5c4f
	ld l,$0b		; $5c51
	ld (hl),$40		; $5c53
	ld l,$0d		; $5c55
	ld (hl),$60		; $5c57
	xor a			; $5c59
	ld l,$0f		; $5c5a
	ld (hl),a		; $5c5c
	ld ($cc77),a		; $5c5d
	ret			; $5c60
	ld e,$79		; $5c61
	ld a,(de)		; $5c63
	ld h,a			; $5c64
	ld l,$44		; $5c65
	ld (hl),$02		; $5c67
	call getFreeEnemySlot		; $5c69
	ret nz			; $5c6c
	ld (hl),$54		; $5c6d
	ld l,$8b		; $5c6f
	ld (hl),$40		; $5c71
	ld l,$8d		; $5c73
	ld (hl),$40		; $5c75
	ld e,$56		; $5c77
	ld a,$80		; $5c79
	ld (de),a		; $5c7b
	inc e			; $5c7c
	ld a,h			; $5c7d
	ld (de),a		; $5c7e
	ret			; $5c7f
	push de			; $5c80
	call clearEnemies		; $5c81
	pop de			; $5c84
	ld bc,$4040		; $5c85
	call $5c9e		; $5c88
	ret nz			; $5c8b
	ld l,$4b		; $5c8c
	ld b,(hl)		; $5c8e
	ld l,$4d		; $5c8f
	ld c,(hl)		; $5c91
	ld e,$4b		; $5c92
	ld a,b			; $5c94
	ld (de),a		; $5c95
	ld e,$4d		; $5c96
	ld a,c			; $5c98
	ld (de),a		; $5c99
	ret			; $5c9a
	ld bc,$4050		; $5c9b
	call getFreeInteractionSlot		; $5c9e
	ret nz			; $5ca1
	ld (hl),$72		; $5ca2
	ld l,$4b		; $5ca4
	ld (hl),b		; $5ca6
	ld l,$4d		; $5ca7
	ld (hl),c		; $5ca9
	ld e,$79		; $5caa
	ld a,h			; $5cac
	ld (de),a		; $5cad
	xor a			; $5cae
	ret			; $5caf
	ldh (<hFF8B),a	; $5cb0
	ld a,$ff		; $5cb2
	ld ($cbea),a		; $5cb4
	ld hl,$c680		; $5cb7
	ld e,$df		; $5cba
	ldh a,(<hFF8B)	; $5cbc
	and $0f			; $5cbe
	call $5cdc		; $5cc0
	call $5cdf		; $5cc3
	ld l,$81		; $5cc6
	ldh a,(<hFF8B)	; $5cc8
	swap a			; $5cca
	and $0f			; $5ccc
	ld e,$de		; $5cce
	call $5cdc		; $5cd0
	ld a,b			; $5cd3
	cp $0c			; $5cd4
	call nz,$5cdf		; $5cd6
	jp disableActiveRing		; $5cd9
	ld b,(hl)		; $5cdc
	ld (hl),a		; $5cdd
	ret			; $5cde
	push de			; $5cdf
	ld d,$cf		; $5ce0
	ld l,$82		; $5ce2
_label_15_227:
	ld a,(hl)		; $5ce4
	or a			; $5ce5
	jr z,_label_15_228	; $5ce6
	inc l			; $5ce8
	jr _label_15_227		; $5ce9
_label_15_228:
	ld (hl),b		; $5ceb
	ld a,l			; $5cec
	ld (de),a		; $5ced
	pop de			; $5cee
	ret			; $5cef
	ld a,($ccec)		; $5cf0
	cp $03			; $5cf3
	jr z,_label_15_229	; $5cf5
	push de			; $5cf7
	ld a,$ff		; $5cf8
	ld ($cbea),a		; $5cfa
	ld h,$c6		; $5cfd
	ld de,$cfdf		; $5cff
	ld c,$80		; $5d02
	call $5d12		; $5d04
	ld e,$de		; $5d07
	ld c,$81		; $5d09
	call $5d12		; $5d0b
	pop de			; $5d0e
_label_15_229:
	jp enableActiveRing		; $5d0f
	ld a,(de)		; $5d12
	or a			; $5d13
	ret z			; $5d14
	ld l,a			; $5d15
	ld a,(hl)		; $5d16
	ld (hl),$00		; $5d17
	ld l,c			; $5d19
	ldi (hl),a		; $5d1a
	cp $0c			; $5d1b
	ret nz			; $5d1d
	ld (hl),a		; $5d1e
	ret			; $5d1f
	ld a,$01		; $5d20
	ld ($cfd2),a		; $5d22
	ld a,$04		; $5d25
	jr _label_15_230		; $5d27
	ld a,$ff		; $5d29
	ld ($cfd2),a		; $5d2b
	ld a,$04		; $5d2e
	jr _label_15_230		; $5d30
	ld a,$05		; $5d32
	jr _label_15_230		; $5d34
	ld a,$03		; $5d36
_label_15_230:
	ld ($cfd4),a		; $5d38
	ld a,$09		; $5d3b
	ld ($cfd1),a		; $5d3d
	ld hl,$cfda		; $5d40
	inc (hl)		; $5d43
	ret			; $5d44
	ld e,$54		; $5d45
	ld a,$80		; $5d47
	ld (de),a		; $5d49
	ld a,$fe		; $5d4a
	inc e			; $5d4c
	ld (de),a		; $5d4d
	ld e,$4e		; $5d4e
	ld a,$01		; $5d50
	ld (de),a		; $5d52
	ret			; $5d53
	call getThisRoomFlags		; $5d54
	bit 7,(hl)		; $5d57
	ld a,$03		; $5d59
	jr nz,_label_15_231	; $5d5b
	ld hl,$c781		; $5d5d
	bit 7,(hl)		; $5d60
	ld a,$02		; $5d62
	jr nz,_label_15_231	; $5d64
	call getThisRoomFlags		; $5d66
	bit 5,(hl)		; $5d69
	ld a,$01		; $5d6b
	jr nz,_label_15_231	; $5d6d
	dec a			; $5d6f
_label_15_231:
	ld ($cfc1),a		; $5d70
	ret			; $5d73
	ld a,$0e		; $5d74
	ld ($cc6a),a		; $5d76
	ld a,$01		; $5d79
	ld ($cc02),a		; $5d7b
	ld ($cca5),a		; $5d7e
	ld a,$ff		; $5d81
	ld ($cca4),a		; $5d83
	jp interactionSetAlwaysUpdateBit		; $5d86
	ld a,$11		; $5d89
	ld ($ccab),a		; $5d8b
	ld ($cca4),a		; $5d8e
	ret			; $5d91
	xor a			; $5d92
	ld ($ccab),a		; $5d93
	ld ($cc32),a		; $5d96
	ret			; $5d99
	ld h,$d7		; $5d9a
_label_15_232:
	ld l,$01		; $5d9c
	ld a,(hl)		; $5d9e
	sub $03			; $5d9f
	jr nz,_label_15_233	; $5da1
	ld l,$1a		; $5da3
	ld (hl),a		; $5da5
	ld l,$2f		; $5da6
	set 5,(hl)		; $5da8
_label_15_233:
	inc h			; $5daa
	ld a,h			; $5dab
	cp $dc			; $5dac
	jr c,_label_15_232	; $5dae
	ret			; $5db0
	ld a,$02		; $5db1
	ld ($cc9e),a		; $5db3
	ret			; $5db6
	ld hl,$c7cb		; $5db7
	set 7,(hl)		; $5dba
	xor a			; $5dbc
	ld ($cc9e),a		; $5dbd
	ld ($cc9f),a		; $5dc0
	ret			; $5dc3
	ld a,$1e		; $5dc4
	call addToGashaMaturity		; $5dc6
	ld hl,$c6e3		; $5dc9
	call incHlRefWithCap		; $5dcc
	call getThisRoomFlags		; $5dcf
	bit 5,(hl)		; $5dd2
	jr nz,_label_15_234	; $5dd4
	ld bc,loseTreasure		; $5dd6
	jr _label_15_237		; $5dd9
_label_15_234:
	ld a,($c6e3)		; $5ddb
	cp $08			; $5dde
	jr z,_label_15_236	; $5de0
	call getRandomNumber		; $5de2
	cp $60			; $5de5
	jr nc,_label_15_239	; $5de7
_label_15_235:
	ld bc,$3402		; $5de9
	jr _label_15_237		; $5dec
_label_15_236:
	call $5e20		; $5dee
	jr c,_label_15_235	; $5df1
	ld c,$03		; $5df3
	call createRingTreasure		; $5df5
	call $5e0a		; $5df8
	ld a,$14		; $5dfb
	jp setGlobalFlag		; $5dfd
_label_15_237:
	call getFreeInteractionSlot		; $5e00
	ret nz			; $5e03
	ld (hl),$60		; $5e04
	inc l			; $5e06
	ld (hl),b		; $5e07
	inc l			; $5e08
	ld (hl),c		; $5e09
_label_15_238:
	ld l,$4b		; $5e0a
	ld (hl),$48		; $5e0c
	inc l			; $5e0e
	inc l			; $5e0f
	ld (hl),$28		; $5e10
	ret			; $5e12
_label_15_239:
	call getFreeInteractionSlot		; $5e13
	ret nz			; $5e16
	ld (hl),$6b		; $5e17
	inc l			; $5e19
	ld (hl),$09		; $5e1a
	inc l			; $5e1c
	inc (hl)		; $5e1d
	jr _label_15_238		; $5e1e
	call getRandomNumber		; $5e20
	and $03			; $5e23
	ld c,a			; $5e25
	ld b,$04		; $5e26
_label_15_240:
	push bc			; $5e28
	ld a,c			; $5e29
	ld bc,$5e4a		; $5e2a
	call addAToBc		; $5e2d
	ld a,(bc)		; $5e30
	ld hl,$c616		; $5e31
	call checkFlag		; $5e34
	jr z,_label_15_241	; $5e37
	pop bc			; $5e39
	ld a,c			; $5e3a
	inc a			; $5e3b
	and $03			; $5e3c
	ld c,a			; $5e3e
	dec b			; $5e3f
	jr nz,_label_15_240	; $5e40
	ld b,$80		; $5e42
	scf			; $5e44
	ret			; $5e45
_label_15_241:
	ld a,(bc)		; $5e46
	pop bc			; $5e47
	ld b,a			; $5e48
	ret			; $5e49
	ld a,$3d		; $5e4a
	rra			; $5e4c
	ld a,(de)		; $5e4d
	call getFreePartSlot		; $5e4e
	ret nz			; $5e51
	ld (hl),$0e		; $5e52
	ld l,$d6		; $5e54
	ld a,$40		; $5e56
	ldi (hl),a		; $5e58
	ld (hl),d		; $5e59
	jp objectCopyPosition		; $5e5a
	call getFreeInteractionSlot		; $5e5d
	ret nz			; $5e60
	ld (hl),$6e		; $5e61
	ld l,$4b		; $5e63
	ld a,($d00b)		; $5e65
	ldi (hl),a		; $5e68
	inc l			; $5e69
	ld a,($d00d)		; $5e6a
	ld (hl),a		; $5e6d
	ret			; $5e6e
	call setLinkForceStateToState08		; $5e6f
	jp putLinkOnGround		; $5e72
	ld bc,$30a8		; $5e75
	ld e,$10		; $5e78
	call $5e82		; $5e7a
	ld bc,$34b8		; $5e7d
	ld e,$11		; $5e80
	call getFreeInteractionSlot		; $5e82
	ret nz			; $5e85
	ld (hl),$30		; $5e86
	inc l			; $5e88
	ld (hl),e		; $5e89
	ld l,$4b		; $5e8a
	ld (hl),b		; $5e8c
	ld l,$4d		; $5e8d
	ld (hl),c		; $5e8f
	ret			; $5e90
	ld hl,$d114		; $5e91
	ld (hl),$c0		; $5e94
	inc l			; $5e96
	ld (hl),$fe		; $5e97
	ld l,$3f		; $5e99
	ld (hl),$0b		; $5e9b
	ld l,$03		; $5e9d
	ld (hl),$03		; $5e9f
	ld l,$1c		; $5ea1
	ld (hl),$09		; $5ea3
	ret			; $5ea5
	ld hl,$d103		; $5ea6
	ld (hl),$04		; $5ea9
	ld l,$1a		; $5eab
	ld (hl),$c0		; $5ead
	ld l,$3f		; $5eaf
	ld (hl),$19		; $5eb1
	ret			; $5eb3
	ld a,$18		; $5eb4
	ld ($cc47),a		; $5eb6
	ld hl,$d009		; $5eb9
	ld (hl),a		; $5ebc
	ld l,$10		; $5ebd
	ld (hl),$32		; $5ebf
	ld a,$1d		; $5ec1
	ld ($d13f),a		; $5ec3
	ret			; $5ec6
	ld a,$02		; $5ec7
	ld ($d008),a		; $5ec9
	ld hl,$d108		; $5ecc
	ld (hl),$02		; $5ecf
	inc l			; $5ed1
	ld (hl),$10		; $5ed2
	ld l,$03		; $5ed4
	ld (hl),$06		; $5ed6
	ld a,$03		; $5ed8
	ld ($d13f),a		; $5eda
	ret			; $5edd
	ld a,($c610)		; $5ede
	cp $0d			; $5ee1
	ld a,$01		; $5ee3
	jr z,_label_15_242	; $5ee5
	xor a			; $5ee7
_label_15_242:
	ld e,$7b		; $5ee8
	ld (de),a		; $5eea
	ret			; $5eeb
	call objectGetAngleTowardLink		; $5eec
	ld e,$49		; $5eef
	ld (de),a		; $5ef1
	call convertAngleDeToDirection		; $5ef2
	ld e,$48		; $5ef5
	ld (de),a		; $5ef7
	jp interactionSetAnimation		; $5ef8
	ld a,$09		; $5efb
	ld ($cc6a),a		; $5efd
	ld hl,$d00b		; $5f00
	call objectCopyPosition		; $5f03
	ld a,($d00b)		; $5f06
	swap a			; $5f09
	and $0f			; $5f0b
	ldh (<hFF8D),a	; $5f0d
	ld a,($d00d)		; $5f0f
	swap a			; $5f12
	and $0f			; $5f14
	xor $0f			; $5f16
	ldh (<hFF8C),a	; $5f18
	ld a,($cc49)		; $5f1a
	ld hl,$5f6f		; $5f1d
	cp $04			; $5f20
	jr z,_label_15_243	; $5f22
	ld hl,$5f85		; $5f24
_label_15_243:
	ld a,($cc4c)		; $5f27
	ld e,a			; $5f2a
_label_15_244:
	ldi a,(hl)		; $5f2b
	or a			; $5f2c
	jr z,_label_15_248	; $5f2d
	cp e			; $5f2f
	jr z,_label_15_245	; $5f30
	inc hl			; $5f32
	inc hl			; $5f33
	jr _label_15_244		; $5f34
_label_15_245:
	ldi a,(hl)		; $5f36
	ld h,(hl)		; $5f37
	ld l,a			; $5f38
	push hl			; $5f39
	ldh a,(<hFF8D)	; $5f3a
	rst_addDoubleIndex			; $5f3c
	ldh a,(<hFF8C)	; $5f3d
	call checkFlag		; $5f3f
	ld c,$01		; $5f42
	jr nz,_label_15_246	; $5f44
	ld c,$00		; $5f46
	ld e,$42		; $5f48
	ld a,(de)		; $5f4a
	or a			; $5f4b
	jr z,_label_15_246	; $5f4c
	pop hl			; $5f4e
	ld bc,$0016		; $5f4f
	add hl,bc		; $5f52
	ldh a,(<hFF8D)	; $5f53
	rst_addDoubleIndex			; $5f55
	ldh a,(<hFF8C)	; $5f56
	call checkFlag		; $5f58
	ld c,$80		; $5f5b
	jr z,_label_15_247	; $5f5d
	ld c,$82		; $5f5f
	jr _label_15_247		; $5f61
_label_15_246:
	pop hl			; $5f63
_label_15_247:
	ld a,c			; $5f64
	ld ($cc6b),a		; $5f65
	ret			; $5f68
_label_15_248:
	ld a,$03		; $5f69
	ld ($cc6b),a		; $5f6b
	ret			; $5f6e
	ld a,$98		; $5f6f
	ld e,a			; $5f71
	ccf			; $5f72
	xor (hl)		; $5f73
	ld e,a			; $5f74
	ld b,e			; $5f75
	call nz,$b45f		; $5f76
	jp c,$c15f		; $5f79
	ld a,($ff00+$5f)	; $5f7c
	jp nz,$6006		; $5f7e
.DB $d3				; $5f81
	inc e			; $5f82
	ld h,b			; $5f83
	nop			; $5f84
	scf			; $5f85
	ldd (hl),a		; $5f86
	ld h,b			; $5f87
	jr c,$48		; $5f88
	ld h,b			; $5f8a
	ldd a,(hl)		; $5f8b
	ld (hl),h		; $5f8c
	ld h,b			; $5f8d
	ld b,l			; $5f8e
	and b			; $5f8f
	ld h,b			; $5f90
	ld c,c			; $5f91
	or (hl)			; $5f92
	ld h,b			; $5f93
	ld c,l			; $5f94
	call z,$0060		; $5f95
	rst $38			; $5f98
	rst $38			; $5f99
	rst $38			; $5f9a
	rst $38			; $5f9b
	rst $38			; $5f9c
	rst $38			; $5f9d
	rst $38			; $5f9e
	ei			; $5f9f
	rst $38			; $5fa0
	rst $38			; $5fa1
	rst $38			; $5fa2
	rst $38			; $5fa3
	rst $38			; $5fa4
	rst $38			; $5fa5
	cp a			; $5fa6
	rst $38			; $5fa7
	rst $38			; $5fa8
	rst $38			; $5fa9
	rst $38			; $5faa
	rst $38			; $5fab
	rst $38			; $5fac
	rst $38			; $5fad
	rst $38			; $5fae
	rst $38			; $5faf
	rst $38			; $5fb0
	rst $38			; $5fb1
	rst $38			; $5fb2
	rst $38			; $5fb3
	rst $38			; $5fb4
	rst $38			; $5fb5
	rst $38			; $5fb6
	rst $38			; $5fb7
	rst $30			; $5fb8
	rst $38			; $5fb9
	rst $38			; $5fba
	rst $38			; $5fbb
	rst $38			; $5fbc
	rst $38			; $5fbd
	rst $38			; $5fbe
	rst $38			; $5fbf
	rst $38			; $5fc0
	rst $38			; $5fc1
	rst $38			; $5fc2
	rst $38			; $5fc3
	rst $38			; $5fc4
	rst $38			; $5fc5
	rst $38			; $5fc6
	rst $38			; $5fc7
	rst $38			; $5fc8
	rst $38			; $5fc9
	rrca			; $5fca
	ld ($ff00+$ef),a	; $5fcb
	xor $ef			; $5fcd
	xor $0f			; $5fcf
	ld ($ff00+$ff),a	; $5fd1
	rst $38			; $5fd3
	rst $38			; $5fd4
	rst $38			; $5fd5
	rst $38			; $5fd6
	rst $38			; $5fd7
	rst $38			; $5fd8
	rst $38			; $5fd9
	rst $38			; $5fda
	rst $38			; $5fdb
	rst $38			; $5fdc
	sbc a			; $5fdd
	rst $38			; $5fde
	cp a			; $5fdf
	rst $38			; $5fe0
	rst $38			; $5fe1
	rst $38			; $5fe2
	rst $38			; $5fe3
	rst $38			; $5fe4
	rst $38			; $5fe5
	rst $38			; $5fe6
	rst $38			; $5fe7
	rst $38			; $5fe8
	rst $38			; $5fe9
	rst $38			; $5fea
	rst $38			; $5feb
	rst $38			; $5fec
	rst $38			; $5fed
	rst $38			; $5fee
	rst $38			; $5fef
	rst $38			; $5ff0
	rst $38			; $5ff1
.DB $e3				; $5ff2
	rst $38			; $5ff3
.DB $e3				; $5ff4
	rst $38			; $5ff5
	rst $38			; $5ff6
	rst $38			; $5ff7
	rst $38			; $5ff8
	rst $38			; $5ff9
	rst $38			; $5ffa
	rst $38			; $5ffb
	rst $38			; $5ffc
	rst $38			; $5ffd
	rst $38			; $5ffe
	rst $38			; $5fff
	rst $38			; $6000
	rst $38			; $6001
	rst $38			; $6002
	rst $38			; $6003
	rst $38			; $6004
	rst $38			; $6005
	rst $38			; $6006
	rst $38			; $6007
	rst $38			; $6008
	rst $38			; $6009
	rst $38			; $600a
	rst $38			; $600b
	rst $38			; $600c
	rst $38			; $600d
	rst $38			; $600e
	rst $38			; $600f
	rst $38			; $6010
	rst $38			; $6011
	rst $38			; $6012
	rst $38			; $6013
	rst $38			; $6014
	rst $38			; $6015
	rst $8			; $6016
	sbc a			; $6017
	rst $8			; $6018
	sbc a			; $6019
	rst $38			; $601a
	rst $38			; $601b
	rst $38			; $601c
	rst $38			; $601d
	rst $38			; $601e
	rst $38			; $601f
	rst $38			; $6020
	rst $38			; $6021
	rst $38			; $6022
	rst $38			; $6023
	rst $38			; $6024
	rst $38			; $6025
	rst $38			; $6026
	rst $38			; $6027
	rst $38			; $6028
	rst $38			; $6029
	rst $38			; $602a
	rst $38			; $602b
	rst $38			; $602c
	rst $38			; $602d
	ld h,a			; $602e
.DB $fc				; $602f
	rst $38			; $6030
	rst $38			; $6031
	rst $38			; $6032
	rst $38			; $6033
	di			; $6034
	rst $38			; $6035
	di			; $6036
	rst $38			; $6037
	di			; $6038
	rst $38			; $6039
	di			; $603a
	rst $38			; $603b
	di			; $603c
	rst $38			; $603d
	rst $38			; $603e
	rst $38			; $603f
	di			; $6040
	rst $38			; $6041
	di			; $6042
	rst $38			; $6043
	di			; $6044
	rst $38			; $6045
	rst $38			; $6046
	rst $38			; $6047
	rst $38			; $6048
	rst $38			; $6049
	rra			; $604a
	rst $38			; $604b
	rst $38			; $604c
	rst $38			; $604d
	rst $38			; $604e
	rst $38			; $604f
	rst $38			; $6050
	rst $38			; $6051
	rst $38			; $6052
	add a			; $6053
	rst $38			; $6054
	add a			; $6055
	rst $38			; $6056
	rst $38			; $6057
	rst $38			; $6058
	rst $38			; $6059
	rst $38			; $605a
	rst $38			; $605b
	rst $38			; $605c
	rst $38			; $605d
	rst $38			; $605e
	rst $38			; $605f
	rst $38			; $6060
	rst $38			; $6061
	rst $38			; $6062
	rst $38			; $6063
	rst $38			; $6064
	rst $38			; $6065
	rst $38			; $6066
	rst $38			; $6067
	rst $38			; $6068
	add a			; $6069
	rst $38			; $606a
	add a			; $606b
	rst $38			; $606c
	rst $38			; $606d
	rst $38			; $606e
	rst $38			; $606f
	rst $38			; $6070
	rst $38			; $6071
	rst $38			; $6072
	rst $38			; $6073
	rst $38			; $6074
	rst $38			; $6075
	rst $38			; $6076
	rst $38			; $6077
	rra			; $6078
	ld a,($ff00+$1f)	; $6079
	ld a,($ff00+$1f)	; $607b
	ld a,($ff00+$1f)	; $607d
	ld a,($ff00+$1f)	; $607f
	ld a,($ff00+$1f)	; $6081
	ld a,($ff00+$1f)	; $6083
	ld a,($ff00+$ff)	; $6085
	rst $38			; $6087
	rst $38			; $6088
	rst $38			; $6089
	rst $38			; $608a
	rst $38			; $608b
	rst $38			; $608c
	rst $38			; $608d
	rra			; $608e
	ld a,($ff00+$1f)	; $608f
	ld a,($ff00+$1f)	; $6091
	ld a,($ff00+$1f)	; $6093
	ld a,($ff00+$1f)	; $6095
	ld a,($ff00+$1f)	; $6097
	ld a,($ff00+$1f)	; $6099
	ld a,($ff00+$ff)	; $609b
	rst $38			; $609d
	rst $38			; $609e
	rst $38			; $609f
	rst $38			; $60a0
	rst $38			; $60a1
	rst $38			; $60a2
	rst $38			; $60a3
	rst $38			; $60a4
	rst $30			; $60a5
	rst $38			; $60a6
	rst $38			; $60a7
	rst $38			; $60a8
	add c			; $60a9
	rst $38			; $60aa
	sub c			; $60ab
	rst $38			; $60ac
	add c			; $60ad
	rst $38			; $60ae
	add c			; $60af
	rst $38			; $60b0
	add c			; $60b1
	rst $38			; $60b2
	add c			; $60b3
	rst $38			; $60b4
	rst $38			; $60b5
	rst $38			; $60b6
	rst $38			; $60b7
	rst $38			; $60b8
	adc a			; $60b9
	rst $38			; $60ba
	rst $38			; $60bb
	rst $38			; $60bc
	rst $38			; $60bd
	rst $38			; $60be
	rst $38			; $60bf
	rst $38			; $60c0
	rst $38			; $60c1
	rst $38			; $60c2
	rst $38			; $60c3
	rst $38			; $60c4
	rst $38			; $60c5
	rst $38			; $60c6
	rst $38			; $60c7
	rst $38			; $60c8
	rst $38			; $60c9
	rst $38			; $60ca
	rst $38			; $60cb
	rst $38			; $60cc
	rst $38			; $60cd
	rst $38			; $60ce
	rst $38			; $60cf
	rst $38			; $60d0
	rst $38			; $60d1
	rst $38			; $60d2
	rst $38			; $60d3
	ld a,a			; $60d4
.DB $f4				; $60d5
	ld a,a			; $60d6
.DB $fc				; $60d7
	ld a,a			; $60d8
.DB $fc				; $60d9
	rst $38			; $60da
	rst $38			; $60db
	rst $38			; $60dc
	rst $38			; $60dd
	rst $38			; $60de
	rst $38			; $60df
	rst $38			; $60e0
	rst $38			; $60e1
	ld hl,$c6e5		; $60e2
	ld (hl),a		; $60e5
	ret			; $60e6
	ld c,a			; $60e7
	jr _label_15_249		; $60e8
	call $60fc		; $60ea
	jr _label_15_249		; $60ed
	call $6104		; $60ef
	jr _label_15_249		; $60f2
	call $610c		; $60f4
_label_15_249:
	ld b,$17		; $60f7
	jp showText		; $60f9

seasonsFunc_15_60fc:
	ld a,(ws_cc39)		; $60fc
	ld hl,seasonsTable_15_6116		; $60ff
	rst_addAToHl			; $6102
	ld a,(hl)		; $6103
	call seasonsFunc_15_610c		; $6104
	ld hl,wMakuMapTextPresent		; $6107
	ld (hl),c		; $610a
	ret			; $610b

seasonsFunc_15_610c:
	ld c,a			; $610c
	call checkIsLinkedGame		; $610d
	ret z			; $6110
	ld a,c			; $6111
	add $1b			; $6112
	ld c,a			; $6114
	ret			; $6115

seasonsTable_15_6116:
	inc bc			; $6116
	dec b			; $6117
	ld ($0c0a),sp		; $6118
	ld de,$1513		; $611b
	rla			; $611e
	ld b,$0e		; $611f
	ld de,$fe18		; $6121
	nop			; $6124
	jr nz,_label_15_250	; $6125
	call $615f		; $6127
	ld a,$00		; $612a
_label_15_250:
	ld e,$77		; $612c
	ld (de),a		; $612e
	jp interactionSetAnimation		; $612f
	call getFreeInteractionSlot		; $6132
	ret nz			; $6135
	ld (hl),$60		; $6136
	inc l			; $6138
	ld (hl),$42		; $6139
	inc l			; $613b
	ld (hl),$00		; $613c
	ld l,$4b		; $613e
	ld (hl),$60		; $6140
	ld a,($d00d)		; $6142
	ld b,$50		; $6145
	cp $64			; $6147
	jr nc,_label_15_251	; $6149
	cp $3c			; $614b
	jr c,_label_15_251	; $614d
	ld b,$40		; $614f
	cp $50			; $6151
	jr nc,_label_15_251	; $6153
	ld b,$60		; $6155
_label_15_251:
	ld l,$4d		; $6157
	ld (hl),b		; $6159
	ld a,b			; $615a
	ld ($c6e0),a		; $615b
	ret			; $615e
	call getFreeEnemySlot		; $615f
	ret nz			; $6162
	ld (hl),$56		; $6163
	inc l			; $6165
	ld e,$42		; $6166
	ld a,(de)		; $6168
	ld (hl),a		; $6169
	ld l,$98		; $616a
	ld a,$40		; $616c
	ldi (hl),a		; $616e
	ld (hl),d		; $616f
	ld e,$56		; $6170
	ld a,$80		; $6172
	ld (de),a		; $6174
	inc e			; $6175
	ld a,h			; $6176
	ld (de),a		; $6177
	ld hl,$cfc0		; $6178
	res 7,(hl)		; $617b
	ret			; $617d
	ld bc,$9301		; $617e
	jp objectCreateInteraction		; $6181
	ld a,$0e		; $6184
	ld ($cc04),a		; $6186
	ld a,$19		; $6189
	jp setGlobalFlag		; $618b
	call checkIsLinkedGame		; $618e
	ret nz			; $6191
	xor a			; $6192
	ld ($cc02),a		; $6193
	ld ($cca4),a		; $6196
	ret			; $6199
	ld a,($cc66)		; $619a
	or a			; $619d
	ret nz			; $619e
	call setLinkForceStateToState08		; $619f
	ld hl,$d008		; $61a2
	ld (hl),$00		; $61a5
	ld l,$0b		; $61a7
	ld (hl),$68		; $61a9
	ld l,$0d		; $61ab
	ld (hl),$50		; $61ad
	ld l,$0f		; $61af
	ld (hl),$00		; $61b1
	ret			; $61b3
	ld bc,$61ca		; $61b4
	call addDoubleIndexToBc		; $61b7
	call getFreeInteractionSlot		; $61ba
	ret nz			; $61bd
	ld (hl),$05		; $61be
	ld l,$4b		; $61c0
	ld a,(bc)		; $61c2
	ld (hl),a		; $61c3
	inc bc			; $61c4
	ld l,$4d		; $61c5
	ld a,(bc)		; $61c7
	ld (hl),a		; $61c8
	ret			; $61c9
	ld h,$26		; $61ca
	ld h,$30		; $61cc
	ld h,$3a		; $61ce
	jr nc,$26		; $61d0
	jr nc,$30		; $61d2
	jr nc,$3a		; $61d4
	ldd a,(hl)		; $61d6
	ld h,$3a		; $61d7
	jr nc,$3a		; $61d9
	ldd a,(hl)		; $61db
	call getFreeEnemySlot		; $61dc
	ret nz			; $61df
	ld (hl),$4f		; $61e0
	ld l,$8b		; $61e2
	ld (hl),$30		; $61e4
	ld l,$8d		; $61e6
	ld (hl),$30		; $61e8
	ret			; $61ea
	ld a,$01		; $61eb
	call interactionSetAnimation		; $61ed
	ld h,d			; $61f0
	ld l,$4b		; $61f1
	ld (hl),$30		; $61f3
	inc l			; $61f5
	inc l			; $61f6
	ld (hl),$78		; $61f7
	ret			; $61f9
	call getFreeEnemySlot		; $61fa
	ret nz			; $61fd
	ld (hl),$20		; $61fe
	inc l			; $6200
	ld (hl),$01		; $6201
	jp objectCopyPosition		; $6203
	call getFreeEnemySlot		; $6206
	ret nz			; $6209
	ld (hl),$4a		; $620a
	jp objectCopyPosition		; $620c
	ld hl,$c6a5		; $620f
	ldi a,(hl)		; $6212
	or (hl)			; $6213
	ld e,$7f		; $6214
	ld (de),a		; $6216
	ret z			; $6217
	ld a,$01		; $6218
	ld (de),a		; $621a
	ld e,$42		; $621b
	ld a,(de)		; $621d
	ld hl,$6233		; $621e
	rst_addAToHl			; $6221
	ld a,(hl)		; $6222
	jp removeRupeeValue		; $6223
	ld e,$42		; $6226
	ld a,(de)		; $6228
	ld hl,$6233		; $6229
	rst_addAToHl			; $622c
	ld c,(hl)		; $622d
	ld a,$28		; $622e
	jp giveTreasure		; $6230
	stop			; $6233
	dec c			; $6234
	inc c			; $6235
	stop			; $6236
	inc c			; $6237
	dec c			; $6238
	dec bc			; $6239
	inc c			; $623a
	ld a,$40		; $623b
	call checkTreasureObtained		; $623d
	and $08			; $6240
	ld b,$00		; $6242
	jr nz,_label_15_252	; $6244
	inc b			; $6246
_label_15_252:
	ld hl,$cfc0		; $6247
	ld (hl),b		; $624a
	ret			; $624b
	call $624f		; $624c
	ld h,d			; $624f
	ld l,$7e		; $6250
	ld a,(hl)		; $6252
	inc (hl)		; $6253
	ld bc,$626a		; $6254
	call addDoubleIndexToBc		; $6257
	call getFreeInteractionSlot		; $625a
	ret nz			; $625d
	ld (hl),$05		; $625e
	ld l,$4b		; $6260
	ld a,(bc)		; $6262
	ld (hl),a		; $6263
	inc bc			; $6264
	ld l,$4d		; $6265
	ld a,(bc)		; $6267
	ld (hl),a		; $6268
	ret			; $6269
	ld e,$2e		; $626a
	ld e,$42		; $626c
	ld h,$38		; $626e
	ld d,$2e		; $6270
	ld d,$42		; $6272
	ld c,$38		; $6274
	ld a,(de)		; $6276
	jr c,$1e		; $6277
	ld a,$1e		; $6279
	ld d,d			; $627b
	ld h,$48		; $627c
	ld d,$3e		; $627e
	ld d,$52		; $6280
	ld c,$48		; $6282
	ld a,(de)		; $6284
	ld c,b			; $6285
	ld e,$4e		; $6286
	ld e,$62		; $6288
	ld h,$58		; $628a
	ld d,$4e		; $628c
	ld d,$62		; $628e
	ld c,$58		; $6290
	ld a,(de)		; $6292
	ld e,b			; $6293
	ld e,$5e		; $6294
	ld e,$72		; $6296
	ld h,$68		; $6298
	ld d,$5e		; $629a
	ld d,$72		; $629c
	ld c,$68		; $629e
	ld a,(de)		; $62a0
	ld l,b			; $62a1
	ld a,$52		; $62a2
	call loseTreasure		; $62a4
	ld a,$01		; $62a7
	call checkTreasureObtained		; $62a9
	jr c,_label_15_253	; $62ac
	xor a			; $62ae
_label_15_253:
	cp $03			; $62af
	jr c,_label_15_254	; $62b1
	ld a,$02		; $62b3
_label_15_254:
	ld c,a			; $62b5
	call getFreeInteractionSlot		; $62b6
	ret nz			; $62b9
	ld (hl),$60		; $62ba
	inc l			; $62bc
	ld (hl),$01		; $62bd
	inc l			; $62bf
	ld (hl),c		; $62c0
	push de			; $62c1
	ld de,$d00b		; $62c2
	call objectCopyPosition_rawAddress		; $62c5
	pop de			; $62c8
	ret			; $62c9
	call objectGetAngleTowardLink		; $62ca
	call convertAngleToDirection		; $62cd
	jp interactionSetAnimation		; $62d0
	ld bc,$f300		; $62d3
	jp objectCreateExclamationMark		; $62d6
	ld b,$f8		; $62d9
	ld c,$f0		; $62db
	ld a,$40		; $62dd
	jp objectCreateExclamationMark		; $62df
	ld a,$16		; $62e2
	call setGlobalFlag		; $62e4
	ld a,$2f		; $62e7
	call setGlobalFlag		; $62e9
	ld hl,$62f7		; $62ec
	call setWarpDestVariables		; $62ef
	ld a,$bc		; $62f2
	jp playSound		; $62f4
	add b			; $62f7
	ld e,e			; $62f8
	nop			; $62f9
	inc d			; $62fa
	add e			; $62fb
	ld a,$00		; $62fc
	ld ($d008),a		; $62fe
	jp setLinkForceStateToState08		; $6301
	call setLinkForceStateToState08		; $6304
	jp putLinkOnGround		; $6307
	ld hl,$cbb3		; $630a
	inc (hl)		; $630d
	ret			; $630e
	call getRandomNumber		; $630f
	and $03			; $6312
	jp interactionSetAnimation		; $6314
	call setLinkForceStateToState08		; $6317
	ld hl,$d008		; $631a
	ld (hl),$01		; $631d
	ld l,$1a		; $631f
	set 7,(hl)		; $6321
	ret			; $6323
	ld c,$10		; $6324
	call objectCheckLinkWithinDistance		; $6326
	rrca			; $6329
	and $03			; $632a
	jp interactionSetAnimation		; $632c
	call darkenRoom		; $632f
	jr _label_15_255		; $6332
	call brightenRoom		; $6334
_label_15_255:
	xor a			; $6337
	ld ($c4b2),a		; $6338
	ld ($c4b4),a		; $633b
	ld a,$7e		; $633e
	ld ($c4b1),a		; $6340
	ld ($c4b3),a		; $6343
	ret			; $6346
	ld bc,$5838		; $6347
	jr _label_15_256		; $634a
	ld bc,$1850		; $634c
_label_15_256:
	call getFreePartSlot		; $634f
	ret nz			; $6352
	ld (hl),$27		; $6353
	inc l			; $6355
	inc (hl)		; $6356
	ld l,$cb		; $6357
	ld (hl),b		; $6359
	ld l,$cd		; $635a
	ld (hl),c		; $635c
	ret			; $635d
	ld bc,$6372		; $635e
	jr _label_15_257		; $6361
	ld bc,$6375		; $6363
_label_15_257:
	call getFreeInteractionSlot		; $6366
	ret nz			; $6369
	ld (hl),$bf		; $636a
	inc l			; $636c
	ld a,(bc)		; $636d
	inc bc			; $636e
	ld (hl),a		; $636f
	jr _label_15_258		; $6370
	nop			; $6372
	ld h,b			; $6373
	jr c,$01		; $6374
	jr nz,$50		; $6376
	ld a,$01		; $6378
	ld ($cc17),a		; $637a
	ld a,$b4		; $637d
	ld ($cc1d),a		; $637f
	ret			; $6382
	ld bc,$63a0		; $6383
	call $638c		; $6386
	ld bc,$63a3		; $6389
	call getFreeInteractionSlot		; $638c
	ret nz			; $638f
	ld (hl),$b4		; $6390
	inc l			; $6392
	ld a,(bc)		; $6393
	inc bc			; $6394
	ld (hl),a		; $6395
_label_15_258:
	ld l,$4b		; $6396
	ld a,(bc)		; $6398
	inc bc			; $6399
	ld (hl),a		; $639a
	ld l,$4d		; $639b
	ld a,(bc)		; $639d
	ld (hl),a		; $639e
	ret			; $639f
	nop			; $63a0
	jr z,$50		; $63a1
	ld bc,$5028		; $63a3
	call getFreeInteractionSlot		; $63a6
	ret nz			; $63a9
	ld (hl),$22		; $63aa
	inc l			; $63ac
	ld (hl),$09		; $63ad
	ld l,$4b		; $63af
	ld (hl),$40		; $63b1
	ld l,$4d		; $63b3
	ld (hl),$50		; $63b5
	ret			; $63b7
_label_15_259:
	ld hl,$d008		; $63b8
	ld a,(hl)		; $63bb
	xor $02			; $63bc
	jp interactionSetAnimation		; $63be
	ld b,a			; $63c1
	ld c,$00		; $63c2
	jp giveRingToLink		; $63c4
	ld a,$08		; $63c7
	call setLinkIDOverride		; $63c9
	ld l,$02		; $63cc
	ld (hl),$08		; $63ce
	ret			; $63d0
	ld hl,$d008		; $63d1
	ld (hl),a		; $63d4
	jp setLinkForceStateToState08		; $63d5
	ld bc,$6417		; $63d8
	jr _label_15_260		; $63db
	ld bc,$640d		; $63dd
	call $63f5		; $63e0
	ld bc,$6412		; $63e3
	call $63f5		; $63e6
	ld bc,$641c		; $63e9
	call $63f5		; $63ec
	call $63f5		; $63ef
	call $63f5		; $63f2
_label_15_260:
	call getFreeInteractionSlot		; $63f5
	ret nz			; $63f8
	ld a,(bc)		; $63f9
	ldi (hl),a		; $63fa
	inc bc			; $63fb
	ld a,(bc)		; $63fc
	ldi (hl),a		; $63fd
	inc bc			; $63fe
	ld a,(bc)		; $63ff
	ldi (hl),a		; $6400
	inc bc			; $6401
	ld l,$4b		; $6402
	ld a,(bc)		; $6404
	ld (hl),a		; $6405
	inc bc			; $6406
	ld l,$4d		; $6407
	ld a,(bc)		; $6409
	ld (hl),a		; $640a
	inc bc			; $640b
	ret			; $640c
	sub l			; $640d
	dec b			; $640e
	nop			; $640f
	inc d			; $6410
	ld d,b			; $6411
	ld b,h			; $6412
	ld b,$00		; $6413
	ld c,b			; $6415
	ld d,b			; $6416
	cp d			; $6417
	inc bc			; $6418
	nop			; $6419
	adc b			; $641a
	ld b,b			; $641b
	sub (hl)		; $641c
	ld b,$00		; $641d
	ld c,b			; $641f
	jr c,_label_15_259	; $6420
	ld b,$01		; $6422
	ld c,b			; $6424
	ld l,b			; $6425
	sub (hl)		; $6426
	dec b			; $6427
	ld (bc),a		; $6428
	jr z,$30		; $6429
	sub (hl)		; $642b
	dec b			; $642c
	inc bc			; $642d
	jr z,_label_15_261	; $642e
	ld a,($ccf8)		; $6430
	ld hl,$cbaa		; $6433
	ldi (hl),a		; $6436
	ld (hl),$00		; $6437
	ld a,($ccf9)		; $6439
	ld hl,$cba8		; $643c
	ldi (hl),a		; $643f
	ld (hl),$00		; $6440
	ret			; $6442
	ld hl,$ccf7		; $6443
	xor a			; $6446
	ldi (hl),a		; $6447
	ldi (hl),a		; $6448
	ld (hl),a		; $6449
	ld e,$78		; $644a
	ld (de),a		; $644c
	ld e,$46		; $644d
	ld a,$01		; $644f
	ld (de),a		; $6451
	jp clearAllItemsAndPutLinkOnGround		; $6452
	ld a,$01		; $6455
	ld e,$7b		; $6457
	ld (de),a		; $6459
	jp objectSetInvisible		; $645a
	xor a			; $645d
	ld e,$7b		; $645e
	ld (de),a		; $6460
	jp objectSetVisible		; $6461
	push de			; $6464
	call clearEnemies		; $6465
	call clearItems		; $6468
	call clearParts		; $646b
	pop de			; $646e
	xor a			; $646f
	ld ($cc30),a		; $6470
	ld a,$01		; $6473
	ld ($cc17),a		; $6475
	call setLinkForceStateToState08		; $6478
	ld hl,$d008		; $647b
	ld (hl),$00		; $647e
	ld l,$0b		; $6480
	ld (hl),$88		; $6482
	ld l,$0d		; $6484
	ld (hl),$78		; $6486
	ld l,$0f		; $6488
	ld (hl),$00		; $648a
	ret			; $648c
	ld a,($d00b)		; $648d
	ld b,a			; $6490
	ld a,($d00d)		; $6491
	ld c,a			; $6494
	ld a,$6e		; $6495
	jp createEnergySwirlGoingIn		; $6497
	ld bc,$8400		; $649a
	jp objectCreateInteraction		; $649d
_label_15_261:
	ld h,d			; $64a0
	ld l,$7c		; $64a1
	ld a,($cba5)		; $64a3
	xor $01			; $64a6
	cp (hl)			; $64a8
	ld l,$7f		; $64a9
	jr nz,_label_15_262	; $64ab
	ld (hl),$00		; $64ad
	ret			; $64af
_label_15_262:
	ld (hl),$01		; $64b0
	ret			; $64b2
	call clearAllItemsAndPutLinkOnGround		; $64b3
	jp objectSetInvisible		; $64b6
	jp objectSetVisible		; $64b9
	call setLinkForceStateToState08		; $64bc
	ld hl,$d008		; $64bf
	ld (hl),$00		; $64c2
	ld l,$0b		; $64c4
	ld (hl),$5c		; $64c6
	ld l,$0d		; $64c8
	ld (hl),$50		; $64ca
	ld l,$0f		; $64cc
	ld (hl),$00		; $64ce
	ret			; $64d0
	call clearAllParentItems		; $64d1
	call dropLinkHeldItem		; $64d4
	call clearItems		; $64d7
	call setLinkForceStateToState08		; $64da
	ld hl,$d008		; $64dd
	ld (hl),$00		; $64e0
	ret			; $64e2
	ld hl,$d008		; $64e3
	ld (hl),$00		; $64e6
	ret			; $64e8
	ld h,d			; $64e9
	ld l,$79		; $64ea
	ld a,(hl)		; $64ec
	or a			; $64ed
	ret nz			; $64ee
	ld l,$78		; $64ef
	ld a,(hl)		; $64f1
	ld b,$00		; $64f2
	cp $03			; $64f4
	jr nc,_label_15_263	; $64f6
	ld b,$01		; $64f8
_label_15_263:
	ld l,$79		; $64fa
	ld (hl),b		; $64fc
	ret			; $64fd
	ld b,a			; $64fe
	ld hl,$cc63		; $64ff
	ld a,$84		; $6502
	ldi (hl),a		; $6504
	ld a,$f0		; $6505
	ldi (hl),a		; $6507
	ld a,$0f		; $6508
	ldi (hl),a		; $650a
	ld a,b			; $650b
	ldi (hl),a		; $650c
	ld a,$00		; $650d
	ld ($cc65),a		; $650f
	ld a,$03		; $6512
	ld ($cc67),a		; $6514
	ret			; $6517
	ld h,d			; $6518
	ld l,$73		; $6519
	ld (hl),$4c		; $651b
	ld b,$25		; $651d
	call getThisRoomFlags		; $651f
	and $03			; $6522
	dec a			; $6524
	jr z,_label_15_264	; $6525
	ld b,$27		; $6527
_label_15_264:
	ld a,b			; $6529
	ld e,$72		; $652a
	ld (de),a		; $652c
	ret			; $652d
	xor a			; $652e
	ld ($cca4),a		; $652f
	ld ($cc02),a		; $6532
	call getThisRoomFlags		; $6535
	and $c0			; $6538
	ld (hl),a		; $653a
	ret			; $653b
	ld b,a			; $653c
	call getThisRoomFlags		; $653d
	and $c0			; $6540
	or b			; $6542
	ld (hl),a		; $6543
	ret			; $6544
	call getThisRoomFlags		; $6545
	and $03			; $6548
	ld e,$7c		; $654a
	ld (de),a		; $654c
	ret			; $654d
	ld hl,$ccf7		; $654e
	xor a			; $6551
	ldi (hl),a		; $6552
	ldi (hl),a		; $6553
	ld (hl),a		; $6554
	jp clearAllItemsAndPutLinkOnGround		; $6555
	xor a			; $6558
	ld ($cfd1),a		; $6559
	ret			; $655c
	call setLinkForceStateToState08		; $655d
	ld hl,$d008		; $6560
	ld (hl),$00		; $6563
	ld l,$0b		; $6565
	ld (hl),$60		; $6567
	ld l,$0d		; $6569
	ld (hl),$50		; $656b
	ld l,$0f		; $656d
	ld (hl),$00		; $656f
	ret			; $6571
	ld hl,$ccf9		; $6572
	ldd a,(hl)		; $6575
	or a			; $6576
	jr nz,_label_15_265	; $6577
	ld a,(hl)		; $6579
	cp $31			; $657a
	jr nc,_label_15_265	; $657c
	ld a,$2e		; $657e
	jp setGlobalFlag		; $6580
_label_15_265:
	ld a,$2e		; $6583
	jp unsetGlobalFlag		; $6585
	ld hl,$6593		; $6588
	call setWarpDestVariables		; $658b
	ld a,$8d		; $658e
	jp playSound		; $6590
	add a			; $6593
	add sp,$00		; $6594
	ld b,$83		; $6596
	ld hl,$65a3		; $6598
	call setWarpDestVariables		; $659b
	ld a,$8d		; $659e
	jp playSound		; $65a0
	add e			; $65a3
	or (hl)			; $65a4
	nop			; $65a5
	ld b,l			; $65a6
	add e			; $65a7
	ld e,$20		; $65a8
_label_15_266:
	ld a,e			; $65aa
	call checkTreasureObtained		; $65ab
	ret nc			; $65ae
	inc e			; $65af
	ld a,e			; $65b0
	cp $25			; $65b1
	jr c,_label_15_266	; $65b3
	ld a,($c6ae)		; $65b5
	ld hl,$65ce		; $65b8
	rst_addAToHl			; $65bb
	ld b,(hl)		; $65bc
	ld hl,$c6b5		; $65bd
_label_15_267:
	ld a,b			; $65c0
	cp (hl)			; $65c1
	ret nz			; $65c2
	inc l			; $65c3
	ld a,l			; $65c4
	cp $ba			; $65c5
	jr c,_label_15_267	; $65c7
	ld h,d			; $65c9
	ld l,$78		; $65ca
	ld (hl),$01		; $65cc
	ret			; $65ce
	jr nz,$50		; $65cf
	sbc c			; $65d1

interactionCoded8:
	ld e,$44		; $65d2
	ld a,(de)		; $65d4
	rst_jumpTable			; $65d5
	jp c,$f865		; $65d6
	ld h,l			; $65d9
	call checkIsLinkedGame		; $65da
	jp z,interactionDelete		; $65dd
	ld a,$18		; $65e0
	call checkGlobalFlag		; $65e2
	jp z,interactionDelete		; $65e5
	call interactionInitGraphics		; $65e8
	call interactionIncState		; $65eb
	ld l,$7e		; $65ee
	ld (hl),$01		; $65f0
	ld hl,$5779		; $65f2
	call interactionSetScript		; $65f5
	call interactionRunScript		; $65f8
	jp interactionAnimateAsNpc		; $65fb

interactionCodedb:
	ld e,$44		; $65fe
	ld a,(de)		; $6600
	rst_jumpTable			; $6601
	ld b,$66		; $6602
	ld e,h			; $6604
	ld h,(hl)		; $6605
	ld a,$01		; $6606
	ld (de),a		; $6608
	call checkIsLinkedGame		; $6609
	jp z,interactionDelete		; $660c
	call $662f		; $660f
	jp z,interactionDelete		; $6612
	ld e,$42		; $6615
	ld a,(de)		; $6617
	ld hl,$662c		; $6618
	rst_addAToHl			; $661b
	ld a,(hl)		; $661c
	ld e,$7e		; $661d
	ld (de),a		; $661f
	ld hl,$5779		; $6620
	call interactionSetScript		; $6623
	call interactionInitGraphics		; $6626
	jp objectSetVisiblec2		; $6629
	dec b			; $662c
	ld b,$09		; $662d
	ld e,$42		; $662f
	ld a,(de)		; $6631
	rst_jumpTable			; $6632
	add hl,sp		; $6633
	ld h,(hl)		; $6634
	ccf			; $6635
	ld h,(hl)		; $6636
	ld c,c			; $6637
	ld h,(hl)		; $6638
	ld a,$2d		; $6639
	call checkGlobalFlag		; $663b
	ret			; $663e
	ld a,$00		; $663f
	ld b,$81		; $6641
	call getRoomFlags		; $6643
	bit 7,a			; $6646
	ret			; $6648
	ld a,$40		; $6649
	call checkTreasureObtained		; $664b
	jr nc,_label_15_268	; $664e
	call getHighestSetBit		; $6650
	cp $01			; $6653
	jr c,_label_15_268	; $6655
	or $01			; $6657
	ret			; $6659
_label_15_268:
	xor a			; $665a
	ret			; $665b
	call interactionRunScript		; $665c
	ld e,$42		; $665f
	ld a,(de)		; $6661
	or a			; $6662
	jp z,npcFaceLinkAndAnimate		; $6663
	jp interactionAnimateAsNpc		; $6666

interactionCodedc:
	ld e,$42		; $6669
	ld a,(de)		; $666b
	rst_jumpTable			; $666c
.DB $dd				; $666d
	ld h,(hl)		; $666e
	ld e,l			; $666f
	ld h,a			; $6670
	and (hl)		; $6671
	ld h,a			; $6672
.DB $db				; $6673
	ld h,a			; $6674
	pop af			; $6675
	ld h,a			; $6676
	ld d,a			; $6677
	ld l,b			; $6678
	or e			; $6679
	ld l,b			; $667a
	call c,$8668		; $667b
	ld l,c			; $667e
	ld a,(bc)		; $667f
	ld l,d			; $6680
	jr z,_label_15_270	; $6681
	jr nc,$6a		; $6683
	scf			; $6685
	ld l,d			; $6686
	ld l,c			; $6687
	ld l,d			; $6688
	ld a,d			; $6689
	ld l,d			; $668a
	adc l			; $668b
	ld h,(hl)		; $668c
	call interactionDeleteAndRetIfEnabled02		; $668d
	call getThisRoomFlags		; $6690
	and $20			; $6693
	jp nz,interactionDelete		; $6695
	ld e,$4d		; $6698
	ld a,(de)		; $669a
	ld b,a			; $669b
	ld a,($ccba)		; $669c
	cp b			; $669f
	jr nz,_label_15_269	; $66a0
	ld e,$4b		; $66a2
	ld a,(de)		; $66a4
	ld c,a			; $66a5
	ld b,$cf		; $66a6
	ld a,(bc)		; $66a8
	cp $f1			; $66a9
	ret z			; $66ab
	ld a,$f1		; $66ac
	call setTile		; $66ae
	call $66d2		; $66b1
	ld a,$4d		; $66b4
	jp playSound		; $66b6
_label_15_269:
	ld e,$4b		; $66b9
	ld a,(de)		; $66bb
	ld c,a			; $66bc
	ld b,$cf		; $66bd
	ld a,(bc)		; $66bf
	cp $f1			; $66c0
	ret nz			; $66c2
	ld a,$03		; $66c3
	ld ($ff00+$70),a	; $66c5
	ld b,$df		; $66c7
	ld a,(bc)		; $66c9
	ld l,a			; $66ca
	xor a			; $66cb
	ld ($ff00+$70),a	; $66cc
	ld a,l			; $66ce
	call setTile		; $66cf
	call getFreeInteractionSlot		; $66d2
	ret nz			; $66d5
	ld (hl),$05		; $66d6
	ld l,$4b		; $66d8
	jp setShortPosition_paramC		; $66da
	ld e,$44		; $66dd
	ld a,(de)		; $66df
	rst_jumpTable			; $66e0
	sbc e			; $66e1
	inc hl			; $66e2
.DB $ed				; $66e3
	ld h,(hl)		; $66e4
	ld a,($1666)		; $66e5
	ld h,a			; $66e8
	rra			; $66e9
	ld h,a			; $66ea
	add hl,sp		; $66eb
	ld h,a			; $66ec
_label_15_270:
	ld a,($ccba)		; $66ed
	or a			; $66f0
	ret z			; $66f1
	ld a,$01		; $66f2
	ld e,$46		; $66f4
	ld (de),a		; $66f6
	jp interactionIncState		; $66f7
	call interactionDecCounter1		; $66fa
	ret nz			; $66fd
	ld l,$45		; $66fe
	ld a,(hl)		; $6700
	cp $03			; $6701
	jr z,_label_15_271	; $6703
	inc (hl)		; $6705
	ld hl,$675a		; $6706
	rst_addAToHl			; $6709
	ld a,(hl)		; $670a
	ld b,$6d		; $670b
	jr _label_15_272		; $670d
_label_15_271:
	call interactionIncState		; $670f
	ld l,$46		; $6712
	ld (hl),$43		; $6714
	call interactionDecCounter1		; $6716
	ret nz			; $6719
	ld (hl),$01		; $671a
	jp interactionIncState		; $671c
	call interactionDecCounter1		; $671f
	ret nz			; $6722
	ld l,$45		; $6723
	ld a,(hl)		; $6725
	or a			; $6726
	jp z,interactionIncState		; $6727
	dec (hl)		; $672a
	ld a,(hl)		; $672b
	ld hl,$675a		; $672c
	rst_addAToHl			; $672f
	ld a,(hl)		; $6730
	ld b,$fd		; $6731
	call $6744		; $6733
	ld (hl),$1e		; $6736
	ret			; $6738
	ld a,($ccba)		; $6739
	or a			; $673c
	ret nz			; $673d
	ld a,$01		; $673e
	ld e,$44		; $6740
	ld (de),a		; $6742
	ret			; $6743
_label_15_272:
	ld c,a			; $6744
	ld a,b			; $6745
	call setTile		; $6746
	call getFreeInteractionSlot		; $6749
	ret nz			; $674c
	ld (hl),$05		; $674d
	ld l,$4b		; $674f
	call setShortPosition_paramC		; $6751
	ld h,d			; $6754
	ld l,$46		; $6755
	ld (hl),$0f		; $6757
	ret			; $6759
	ld h,l			; $675a
	ld h,h			; $675b
	ld h,e			; $675c
	ld e,$44		; $675d
	ld a,(de)		; $675f
	rst_jumpTable			; $6760
	ld h,a			; $6761
	ld h,a			; $6762
	ld (hl),h		; $6763
	ld h,a			; $6764
	add e			; $6765
	ld h,a			; $6766
	ld a,$01		; $6767
	ld (de),a		; $6769
	call checkIsLinkedGame		; $676a
	jp z,interactionDelete		; $676d
	ld ($ccaa),a		; $6770
	ret			; $6773
	call returnIfScrollMode01Unset		; $6774
	ld a,($ccb3)		; $6777
	ld b,a			; $677a
	ld a,($cca8)		; $677b
	cp b			; $677e
	ret z			; $677f
	jp interactionIncState		; $6780
	call objectGetTileAtPosition		; $6783
	ld b,a			; $6786
	ld a,($ccb4)		; $6787
	cp b			; $678a
	ret nz			; $678b
	call checkLinkID0AndControlNormal		; $678c
	ret nc			; $678f
	ld hl,$cc63		; $6790
	ld (hl),$85		; $6793
	inc l			; $6795
	ld (hl),$30		; $6796
	inc l			; $6798
	ld (hl),$93		; $6799
	inc l			; $679b
	ld (hl),$ff		; $679c
	ld a,$01		; $679e
	ld ($cc67),a		; $67a0
	jp interactionDelete		; $67a3
	ld e,$44		; $67a6
	ld a,(de)		; $67a8
	rst_jumpTable			; $67a9
	ld h,a			; $67aa
	ld h,a			; $67ab
	xor (hl)		; $67ac
	ld h,a			; $67ad
	ld a,$01		; $67ae
	ld ($ccaa),a		; $67b0
	call objectGetTileAtPosition		; $67b3
	ld b,a			; $67b6
	ld a,($ccb4)		; $67b7
	cp b			; $67ba
	ret nz			; $67bb
	ld a,($cc77)		; $67bc
	or a			; $67bf
	ret nz			; $67c0
	call seasonsFunc_3e8f		; $67c1
	ld a,$05		; $67c4
	ld ($cc63),a		; $67c6
	ld a,$09		; $67c9
	ld ($cc65),a		; $67cb
	ld a,$00		; $67ce
	ld ($cd00),a		; $67d0
	ld a,$0a		; $67d3
	ld ($cc6a),a		; $67d5
	jp interactionDelete		; $67d8
	ld h,d			; $67db
	ld l,$4b		; $67dc
	ld a,($ccba)		; $67de
	and (hl)		; $67e1
	cp (hl)			; $67e2
	ld hl,$ccba		; $67e3
	jr nz,_label_15_273	; $67e6
	set 7,(hl)		; $67e8
	ret			; $67ea
_label_15_273:
	ld hl,$ccba		; $67eb
	res 7,(hl)		; $67ee
	ret			; $67f0
	ld e,$44		; $67f1
	ld a,(de)		; $67f3
	rst_jumpTable			; $67f4
.DB $fd				; $67f5
	ld h,a			; $67f6
	dec h			; $67f7
	ld l,b			; $67f8
	dec (hl)		; $67f9
	ld l,b			; $67fa
	ld b,h			; $67fb
	ld l,b			; $67fc
	ld e,$4d		; $67fd
	ld a,(de)		; $67ff
	ld e,$70		; $6800
	ld (de),a		; $6802
	ld b,a			; $6803
	call getThisRoomFlags		; $6804
	and $20			; $6807
	jr z,_label_15_274	; $6809
	call $681b		; $680b
	jp interactionDelete		; $680e
_label_15_274:
	ld e,$4b		; $6811
	ld a,(de)		; $6813
	ld c,a			; $6814
	call objectSetShortPosition		; $6815
	jp interactionIncState		; $6818
	ld e,$70		; $681b
	ld a,(de)		; $681d
	ld hl,$c647		; $681e
	cp (hl)			; $6821
	ret c			; $6822
	ld (hl),a		; $6823
	ret			; $6824
	call getThisRoomFlags		; $6825
	and $20			; $6828
	ret z			; $682a
	call $681b		; $682b
	call interactionIncState		; $682e
	ld l,$46		; $6831
	ld (hl),$28		; $6833
	call retIfTextIsActive		; $6835
	call interactionDecCounter1		; $6838
	ret nz			; $683b
	ld (hl),$1e		; $683c
	call objectCreatePuff		; $683e
	jp interactionIncState		; $6841
	call interactionDecCounter1		; $6844
	ret nz			; $6847
	ld a,$4d		; $6848
	call playSound		; $684a
	ld bc,$7e02		; $684d
	call objectCreateInteraction		; $6850
	ret nz			; $6853
	jp interactionDelete		; $6854
	ld e,$44		; $6857
	ld a,(de)		; $6859
	rst_jumpTable			; $685a
	ld h,l			; $685b
	ld l,b			; $685c
	ld l,b			; $685d
	ld l,b			; $685e
	ld a,e			; $685f
	ld l,b			; $6860
	sub b			; $6861
	ld l,b			; $6862
	sbc c			; $6863
	ld l,b			; $6864
	ld a,$01		; $6865
	ld (de),a		; $6867
	ld a,($ccba)		; $6868
	cp $1f			; $686b
	ret nz			; $686d
	ld h,d			; $686e
	ld a,$0f		; $686f
	ld l,$46		; $6871
	ld (hl),$0f		; $6873
	inc l			; $6875
	ld (hl),$73		; $6876
	jp interactionIncState		; $6878
	call interactionDecCounter1		; $687b
	ret nz			; $687e
	inc l			; $687f
	ld a,(hl)		; $6880
	ld b,$6d		; $6881
	call $6744		; $6883
	ld a,c			; $6886
	cp $7d			; $6887
	jp z,interactionIncState		; $6889
	ld l,$47		; $688c
	inc (hl)		; $688e
	ret			; $688f
	ld a,($ccba)		; $6890
	cp $1f			; $6893
	ret z			; $6895
	jp interactionIncState		; $6896
	call interactionDecCounter1		; $6899
	ret nz			; $689c
	inc l			; $689d
	ld a,(hl)		; $689e
	ld b,$f4		; $689f
	call $6744		; $68a1
	ld a,c			; $68a4
	cp $73			; $68a5
	jr z,_label_15_275	; $68a7
	ld l,$47		; $68a9
	dec (hl)		; $68ab
	ret			; $68ac
_label_15_275:
	ld h,d			; $68ad
	ld l,$44		; $68ae
	ld (hl),$01		; $68b0
	ret			; $68b2
	ld e,$44		; $68b3
	ld a,(de)		; $68b5
	or a			; $68b6
	jr nz,_label_15_276	; $68b7
	call getThisRoomFlags		; $68b9
	and $20			; $68bc
	jp nz,interactionDelete		; $68be
	call interactionIncState		; $68c1
_label_15_276:
	ld a,($cc31)		; $68c4
	bit 6,a			; $68c7
	ret z			; $68c9
	call getFreeInteractionSlot		; $68ca
	ret nz			; $68cd
	ld (hl),$60		; $68ce
	inc l			; $68d0
	ld (hl),$30		; $68d1
	inc l			; $68d3
	ld (hl),$01		; $68d4
	call objectCopyPosition		; $68d6
	jp interactionDelete		; $68d9
	ld e,$44		; $68dc
	ld a,(de)		; $68de
	rst_jumpTable			; $68df
	ld ($ed68),a		; $68e0
	ld l,b			; $68e3
	ld ($4a69),sp		; $68e4
	ld l,c			; $68e7
	ld (hl),b		; $68e8
	ld l,c			; $68e9
	ld a,$01		; $68ea
	ld (de),a		; $68ec
	ld e,$70		; $68ed
	ld a,(de)		; $68ef
	ld b,a			; $68f0
	ld a,($ccba)		; $68f1
	cp b			; $68f4
	ret z			; $68f5
	ld (de),a		; $68f6
	ld ($ccc8),a		; $68f7
	ld c,a			; $68fa
	ld a,b			; $68fb
	cpl			; $68fc
	and c			; $68fd
	call getHighestSetBit		; $68fe
	ld h,d			; $6901
	ld l,$71		; $6902
	ld (hl),a		; $6904
	jp interactionIncState		; $6905
	ld b,$04		; $6908
_label_15_277:
	call $6923		; $690a
	call getFreeInteractionSlot		; $690d
	ret nz			; $6910
	ld (hl),$05		; $6911
	ld l,$4b		; $6913
	call setShortPosition_paramC		; $6915
	dec b			; $6918
	jr nz,_label_15_277	; $6919
	call interactionIncState		; $691b
	ld l,$46		; $691e
	ld (hl),$1e		; $6920
	ret			; $6922
	ld a,b			; $6923
	dec a			; $6924
	ld hl,$692b		; $6925
	rst_addAToHl			; $6928
	ld c,(hl)		; $6929
	ret			; $692a
	ldi (hl),a		; $692b
	inc l			; $692c
	add d			; $692d
	adc h			; $692e
	ld e,$71		; $692f
	ld a,(de)		; $6931
	ld hl,$693a		; $6932
	rst_addDoubleIndex			; $6935
	ldi a,(hl)		; $6936
	ld e,(hl)		; $6937
	ld d,a			; $6938
	ret			; $6939
	inc d			; $693a
	nop			; $693b
	ld (de),a		; $693c
	nop			; $693d
	ld hl,$3c01		; $693e
	nop			; $6941
	dec c			; $6942
	ld bc,$001c		; $6943
	inc hl			; $6946
	nop			; $6947
	ld sp,$cd02		; $6948
	add a			; $694b
	inc hl			; $694c
	ret nz			; $694d
	ld a,$01		; $694e
	ld ($cc17),a		; $6950
	call $692f		; $6953
	ld b,$04		; $6956
_label_15_278:
	call $6923		; $6958
	call getFreeEnemySlot		; $695b
	ret nz			; $695e
	ld (hl),d		; $695f
	inc l			; $6960
	ld (hl),e		; $6961
	ld l,$8b		; $6962
	call setShortPosition_paramC		; $6964
	dec b			; $6967
	jr nz,_label_15_278	; $6968
	ldh a,(<hActiveObject)	; $696a
	ld d,a			; $696c
	jp interactionIncState		; $696d
	ld a,($cc30)		; $6970
	or a			; $6973
	ret nz			; $6974
	ld a,($ccba)		; $6975
	inc a			; $6978
	jp z,interactionDelete		; $6979
	xor a			; $697c
	ld ($ccc8),a		; $697d
	ld e,$44		; $6980
	ld a,$01		; $6982
	ld (de),a		; $6984
	ret			; $6985
	ld e,$44		; $6986
	ld a,(de)		; $6988
	rst_jumpTable			; $6989
	adc (hl)		; $698a
	ld l,c			; $698b
	sub c			; $698c
	ld l,c			; $698d
	ld a,$01		; $698e
	ld (de),a		; $6990
	ld a,($ccbc)		; $6991
	or a			; $6994
	ret z			; $6995
	ld b,a			; $6996
	ld e,$47		; $6997
	ld a,(de)		; $6999
	ld hl,$6a02		; $699a
	rst_addAToHl			; $699d
	ld a,(hl)		; $699e
	cp b			; $699f
	jr nz,_label_15_279	; $69a0
	ld a,(de)		; $69a2
	inc a			; $69a3
	ld (de),a		; $69a4
	jr _label_15_280		; $69a5
_label_15_279:
	ld e,$70		; $69a7
	ld a,$01		; $69a9
	ld (de),a		; $69ab
_label_15_280:
	ld bc,$2809		; $69ac
	ld e,$70		; $69af
	ld a,(de)		; $69b1
	or a			; $69b2
	jr nz,_label_15_281	; $69b3
	ld bc,$280d		; $69b5
	ld e,$47		; $69b8
	ld a,(de)		; $69ba
	cp $08			; $69bb
	jr c,_label_15_283	; $69bd
	call getThisRoomFlags		; $69bf
	bit 5,a			; $69c2
	jr nz,_label_15_283	; $69c4
	set 7,(hl)		; $69c6
	call $6a18		; $69c8
	ld a,$4f		; $69cb
	call setTile		; $69cd
	ld a,$4d		; $69d0
	ld bc,$280d		; $69d2
	jr _label_15_282		; $69d5
_label_15_281:
	ld a,$5a		; $69d7
_label_15_282:
	call playSound		; $69d9
_label_15_283:
	call getFreeInteractionSlot		; $69dc
	ret nz			; $69df
	ld (hl),$60		; $69e0
	inc l			; $69e2
	ld (hl),b		; $69e3
	inc l			; $69e4
	ld (hl),c		; $69e5
	ld l,$4b		; $69e6
	ld a,($ccbc)		; $69e8
	ld b,a			; $69eb
	and $f0			; $69ec
	ldi (hl),a		; $69ee
	inc l			; $69ef
	ld a,b			; $69f0
	swap a			; $69f1
	and $f0			; $69f3
	or $08			; $69f5
	ld (hl),a		; $69f7
	ld a,$81		; $69f8
	ld ($cca4),a		; $69fa
	xor a			; $69fd
	ld ($ccbc),a		; $69fe
	ret			; $6a01
	ld h,(hl)		; $6a02
	ld e,e			; $6a03
	ld b,e			; $6a04
	dec sp			; $6a05
	ld e,c			; $6a06
	inc hl			; $6a07
	ld (hl),e		; $6a08
	dec (hl)		; $6a09
	call getThisRoomFlags		; $6a0a
	and $80			; $6a0d
	jp z,interactionDelete		; $6a0f
	call $6a18		; $6a12
	jp interactionDelete		; $6a15
	call getFreeInteractionSlot		; $6a18
	ret nz			; $6a1b
	ld (hl),$e1		; $6a1c
	inc l			; $6a1e
	ld (hl),$01		; $6a1f
	ld c,$57		; $6a21
	ld l,$4b		; $6a23
	jp setShortPosition_paramC		; $6a25
	ld hl,$c904		; $6a28
	set 4,(hl)		; $6a2b
	jp interactionDelete		; $6a2d
	xor a			; $6a30
	ld ($cc31),a		; $6a31
	jp interactionDelete		; $6a34
	call checkInteractionState		; $6a37
	jr nz,_label_15_284	; $6a3a
	call objectGetTileAtPosition		; $6a3c
	ld a,($cca8)		; $6a3f
	cp l			; $6a42
	jp nz,interactionDelete		; $6a43
	call interactionIncState		; $6a46
	call interactionSetAlwaysUpdateBit		; $6a49
	ld a,$81		; $6a4c
	ld ($cca4),a		; $6a4e
	ld ($cc02),a		; $6a51
_label_15_284:
	ld a,($c4ab)		; $6a54
	or a			; $6a57
	ret nz			; $6a58
	ld bc,$0202		; $6a59
	call showText		; $6a5c
	xor a			; $6a5f
	ld ($cca4),a		; $6a60
	ld ($cc02),a		; $6a63
	jp interactionDelete		; $6a66
	ld a,($cc66)		; $6a69
	cp $22			; $6a6c
	jr nz,_label_15_285	; $6a6e
	xor a			; $6a70
	ld ($cc66),a		; $6a71
	call initializeDungeonStuff		; $6a74
_label_15_285:
	jp interactionDelete		; $6a77
	ld a,($cd00)		; $6a7a
	and $01			; $6a7d
	ret z			; $6a7f
	ld hl,$cf79		; $6a80
_label_15_286:
	ld a,(hl)		; $6a83
	cp $fe			; $6a84
	jr z,_label_15_287	; $6a86
	cp $ff			; $6a88
	jr nz,_label_15_288	; $6a8a
_label_15_287:
	ld (hl),$7b		; $6a8c
_label_15_288:
	dec l			; $6a8e
	jr nz,_label_15_286	; $6a8f
	jp interactionDelete		; $6a91

interactionCodedd:
	ld e,$44		; $6a94
	ld a,(de)		; $6a96
	or a			; $6a97
	jr z,_label_15_289	; $6a98
	call interactionRunScript		; $6a9a
	jp c,interactionDelete		; $6a9d
	jp npcFaceLinkAndAnimate		; $6aa0
_label_15_289:
	call getThisRoomFlags		; $6aa3
	and $40			; $6aa6
	jp nz,interactionDelete		; $6aa8
	call interactionIncState		; $6aab
	call interactionInitGraphics		; $6aae
	call objectSetVisible82		; $6ab1
	ld a,$1f		; $6ab4
	call interactionSetHighTextIndex		; $6ab6
	ld hl,$7f0a		; $6ab9
	jp interactionSetScript		; $6abc
	xor a			; $6abf
	ld hl,$cba8		; $6ac0
	ldi (hl),a		; $6ac3
	ldd (hl),a		; $6ac4
	ld a,($c6c9)		; $6ac5
	and $0f			; $6ac8
	call getNumSetBits		; $6aca
	ld (hl),a		; $6acd
	cp $04			; $6ace
	ld a,$01		; $6ad0
	jr z,_label_15_290	; $6ad2
	dec a			; $6ad4
_label_15_290:
	ld ($cfc1),a		; $6ad5
	ret			; $6ad8
	ld bc,$0700		; $6ad9
	jp giveRingToLink		; $6adc

interactionCodede:
	ld e,$42		; $6adf
	ld a,(de)		; $6ae1
	rst_jumpTable			; $6ae2
	push af			; $6ae3
	ld l,d			; $6ae4
	dec l			; $6ae5
	ld l,h			; $6ae6
	dec l			; $6ae7
	ld l,h			; $6ae8
	dec l			; $6ae9
	ld l,h			; $6aea
	dec l			; $6aeb
	ld l,h			; $6aec
	dec l			; $6aed
	ld l,h			; $6aee
	dec l			; $6aef
	ld l,h			; $6af0
	dec l			; $6af1
	ld l,h			; $6af2
	dec l			; $6af3
	ld l,h			; $6af4
	ld e,$44		; $6af5
	ld a,(de)		; $6af7
	rst_jumpTable			; $6af8
	ld bc,$326b		; $6af9
	ld l,e			; $6afc
	ld b,h			; $6afd
	ld l,e			; $6afe
	ld l,d			; $6aff
	ld l,e			; $6b00
	ld a,$01		; $6b01
	ld (de),a		; $6b03
	call interactionInitGraphics		; $6b04
	ld a,($d00b)		; $6b07
	sub $0e			; $6b0a
	ld e,$4b		; $6b0c
	ld (de),a		; $6b0e
	ld a,($d00d)		; $6b0f
	ld e,$4d		; $6b12
	ld (de),a		; $6b14
	call setLinkForceStateToState08		; $6b15
	ld a,$f1		; $6b18
	call playSound		; $6b1a
	ld a,$77		; $6b1d
	call playSound		; $6b1f
	ld b,$84		; $6b22
	call objectCreateInteractionWithSubid00		; $6b24
	ret nz			; $6b27
	ld l,$46		; $6b28
	ld e,l			; $6b2a
	ld a,$78		; $6b2b
	ld (hl),a		; $6b2d
	ld (de),a		; $6b2e
	jp objectSetVisible82		; $6b2f
	ld a,$0f		; $6b32
	ld ($cc6b),a		; $6b34
	call interactionDecCounter1		; $6b37
	ret nz			; $6b3a
	ld (hl),$40		; $6b3b
	ld l,$50		; $6b3d
	ld (hl),$14		; $6b3f
	jp interactionIncState		; $6b41
	call objectApplySpeed		; $6b44
	call $6c94		; $6b47
	call interactionDecCounter1		; $6b4a
	ret nz			; $6b4d
	ld (hl),$78		; $6b4e
	ld a,$10		; $6b50
	ld ($cc6b),a		; $6b52
	ld l,$4b		; $6b55
	ld (hl),$28		; $6b57
	ld l,$4d		; $6b59
	ld (hl),$50		; $6b5b
	ld a,$8a		; $6b5d
	call playSound		; $6b5f
	ld a,$03		; $6b62
	call fadeinFromWhiteWithDelay		; $6b64
	jp interactionIncState		; $6b67
	call $6c94		; $6b6a
	call $6ccb		; $6b6d
	ld e,$45		; $6b70
	ld a,(de)		; $6b72
	rst_jumpTable			; $6b73
	adc b			; $6b74
	ld l,e			; $6b75
	sub h			; $6b76
	ld l,e			; $6b77
.DB $d3				; $6b78
	ld l,e			; $6b79
	and $6b			; $6b7a
	di			; $6b7c
	ld l,e			; $6b7d
	and $6b			; $6b7e
	di			; $6b80
	ld l,e			; $6b81
	and $6b			; $6b82
	rlca			; $6b84
	ld l,h			; $6b85
	jr $6c			; $6b86
	call interactionDecCounter1		; $6b88
	ret nz			; $6b8b
	ld (hl),$14		; $6b8c
	inc l			; $6b8e
	ld (hl),$08		; $6b8f
	jp interactionIncState2		; $6b91
	call interactionDecCounter1		; $6b94
	ret nz			; $6b97
	ld (hl),$14		; $6b98
	inc l			; $6b9a
	dec (hl)		; $6b9b
	ld b,(hl)		; $6b9c
	call getFreeInteractionSlot		; $6b9d
	ret nz			; $6ba0
	ld (hl),$de		; $6ba1
	call objectCopyPosition		; $6ba3
	ld a,b			; $6ba6
	ld bc,$6bc3		; $6ba7
	call addDoubleIndexToBc		; $6baa
	ld a,(bc)		; $6bad
	ld l,$42		; $6bae
	ld (hl),a		; $6bb0
	ld l,$49		; $6bb1
	inc bc			; $6bb3
	ld a,(bc)		; $6bb4
	ld (hl),a		; $6bb5
	ld e,$47		; $6bb6
	ld a,(de)		; $6bb8
	or a			; $6bb9
	ret nz			; $6bba
	call interactionIncState2		; $6bbb
	ld l,$46		; $6bbe
	ld (hl),$78		; $6bc0
	ret			; $6bc2
	ld ($071a),sp		; $6bc3
	ld d,$06		; $6bc6
	ld (de),a		; $6bc8
	dec b			; $6bc9
	ld c,$04		; $6bca
	ld a,(bc)		; $6bcc
	inc bc			; $6bcd
	ld b,$02		; $6bce
	ld (bc),a		; $6bd0
	ld bc,$cd1e		; $6bd1
	add a			; $6bd4
	inc hl			; $6bd5
	ret nz			; $6bd6
	ld (hl),$3c		; $6bd7
	ld a,$01		; $6bd9
	ld ($cfc0),a		; $6bdb
	ld a,$20		; $6bde
	ld ($cfc1),a		; $6be0
	jp interactionIncState2		; $6be3
	ld a,(wFrameCounter)		; $6be6
	and $03			; $6be9
	jr nz,_label_15_291	; $6beb
	ld hl,$cfc1		; $6bed
	dec (hl)		; $6bf0
	jr _label_15_291		; $6bf1
	ld a,(wFrameCounter)		; $6bf3
	and $03			; $6bf6
	jr nz,_label_15_291	; $6bf8
	ld hl,$cfc1		; $6bfa
	inc (hl)		; $6bfd
_label_15_291:
	call interactionDecCounter1		; $6bfe
	ret nz			; $6c01
	ld (hl),$3c		; $6c02
	jp interactionIncState2		; $6c04
	ld hl,$cfc1		; $6c07
	inc (hl)		; $6c0a
	ld a,$b4		; $6c0b
	call playSound		; $6c0d
	ld a,$04		; $6c10
	call fadeoutToWhiteWithDelay		; $6c12
	jp interactionIncState2		; $6c15
	ld hl,$cfc1		; $6c18
	inc (hl)		; $6c1b
	ld a,($c4ab)		; $6c1c
	or a			; $6c1f
	ret nz			; $6c20
	ld hl,$cbb3		; $6c21
	inc (hl)		; $6c24
	ld a,$08		; $6c25
	call fadeinFromWhiteWithDelay		; $6c27
	jp interactionDelete		; $6c2a
	ld e,$44		; $6c2d
	ld a,(de)		; $6c2f
	rst_jumpTable			; $6c30
	add hl,sp		; $6c31
	ld l,h			; $6c32
	ld e,h			; $6c33
	ld l,h			; $6c34
	ld h,(hl)		; $6c35
	ld l,h			; $6c36
	ld l,(hl)		; $6c37
	ld l,h			; $6c38
	ld a,$01		; $6c39
	ld (de),a		; $6c3b
	ld h,d			; $6c3c
	ld l,$46		; $6c3d
	ld (hl),$10		; $6c3f
	ld l,$50		; $6c41
	ld (hl),$50		; $6c43
	ld a,$98		; $6c45
	call playSound		; $6c47
	call objectCenterOnTile		; $6c4a
	ld l,$4d		; $6c4d
	ld a,(hl)		; $6c4f
	sub $08			; $6c50
	ldi (hl),a		; $6c52
	xor a			; $6c53
	ldi (hl),a		; $6c54
	ld (hl),a		; $6c55
	call interactionInitGraphics		; $6c56
	jp objectSetVisible80		; $6c59
	call objectApplySpeed		; $6c5c
	call interactionDecCounter1		; $6c5f
	ret nz			; $6c62
	jp interactionIncState		; $6c63
	ld a,($cfc0)		; $6c66
	or a			; $6c69
	ret z			; $6c6a
	jp interactionIncState		; $6c6b
	call objectCheckWithinScreenBoundary		; $6c6e
	jp nc,interactionDelete		; $6c71
	ld a,(wFrameCounter)		; $6c74
	rrca			; $6c77
	ret c			; $6c78
	ld h,d			; $6c79
	ld l,$49		; $6c7a
	inc (hl)		; $6c7c
	ld a,(hl)		; $6c7d
	and $1f			; $6c7e
	ld (hl),a		; $6c80
	ld e,l			; $6c81
	or a			; $6c82
	call z,$6c8f		; $6c83
	ld bc,$2850		; $6c86
	ld a,($cfc1)		; $6c89
	jp objectSetPositionInCircleArc		; $6c8c
	ld a,$c9		; $6c8f
	jp playSound		; $6c91
	ld a,(wFrameCounter)		; $6c94
	and $07			; $6c97
	ret nz			; $6c99
	ld bc,$8403		; $6c9a
	call objectCreateInteraction		; $6c9d
	ret nz			; $6ca0
	ld a,(wFrameCounter)		; $6ca1
	and $38			; $6ca4
	swap a			; $6ca6
	rlca			; $6ca8
	ld bc,$6cbb		; $6ca9
	call addDoubleIndexToBc		; $6cac
	ld l,$4b		; $6caf
	ld a,(bc)		; $6cb1
	add (hl)		; $6cb2
	ld (hl),a		; $6cb3
	inc bc			; $6cb4
	ld l,$4d		; $6cb5
	ld a,(bc)		; $6cb7
	add (hl)		; $6cb8
	ld (hl),a		; $6cb9
	ret			; $6cba
	stop			; $6cbb
	ld (bc),a		; $6cbc
	stop			; $6cbd
	cp $08			; $6cbe
	dec b			; $6cc0
	ld ($0cfb),sp		; $6cc1
	ld ($f80c),sp		; $6cc4
	ld b,$0b		; $6cc7
	ld b,$f5		; $6cc9
	ld a,(wFrameCounter)		; $6ccb
	and $07			; $6cce
	ret nz			; $6cd0
	ld a,(wFrameCounter)		; $6cd1
	and $38			; $6cd4
	swap a			; $6cd6
	rlca			; $6cd8
	ld hl,$6ce2		; $6cd9
	rst_addAToHl			; $6cdc
	ld e,$4f		; $6cdd
	ld a,(hl)		; $6cdf
	ld (de),a		; $6ce0
	ret			; $6ce1
	rst $38			; $6ce2
	cp $ff			; $6ce3
	nop			; $6ce5
	ld bc,$0102		; $6ce6
	nop			; $6ce9

interactionCodedf:
	ld e,$44		; $6cea
	ld a,(de)		; $6cec
	rst_jumpTable			; $6ced
	ld a,($ff00+c)		; $6cee
	ld l,h			; $6cef
	rrca			; $6cf0
	ld l,l			; $6cf1
	ld a,$01		; $6cf2
	ld (de),a		; $6cf4
	call interactionInitGraphics		; $6cf5
	ld h,d			; $6cf8
	ld l,$50		; $6cf9
	ld (hl),$14		; $6cfb
	ld l,$49		; $6cfd
	ld (hl),$18		; $6cff
	ld l,$46		; $6d01
	ld (hl),$3c		; $6d03
	ld l,$42		; $6d05
	ld a,(hl)		; $6d07
	or a			; $6d08
	jp z,objectSetVisiblec2		; $6d09
	jp objectSetVisiblec0		; $6d0c
	ld e,$45		; $6d0f
	ld a,(de)		; $6d11
	rst_jumpTable			; $6d12
	ld hl,$286d		; $6d13
	ld l,l			; $6d16
	ld b,d			; $6d17
	ld l,l			; $6d18
	ld d,a			; $6d19
	ld l,l			; $6d1a
	and a			; $6d1b
	ld l,l			; $6d1c
	cp (hl)			; $6d1d
	ld l,l			; $6d1e
	call z,$cd6d		; $6d1f
	add a			; $6d22
	inc hl			; $6d23
	ret nz			; $6d24
	call interactionIncState2		; $6d25
	call interactionAnimate		; $6d28
	call objectApplySpeed		; $6d2b
	cp $68			; $6d2e
	ret nz			; $6d30
	call interactionIncState2		; $6d31
	ld l,$46		; $6d34
	ld (hl),$b4		; $6d36
	ld l,$42		; $6d38
	ld a,(hl)		; $6d3a
	or a			; $6d3b
	ret nz			; $6d3c
	ld a,$05		; $6d3d
	jp interactionSetAnimation		; $6d3f
	call interactionDecCounter1		; $6d42
	ret nz			; $6d45
	ld hl,$cfd0		; $6d46
	ld (hl),$01		; $6d49
	call interactionIncState2		; $6d4b
	ld l,$46		; $6d4e
	ld (hl),$04		; $6d50
	inc l			; $6d52
	ld (hl),$01		; $6d53
	jr _label_15_294		; $6d55
	ld h,d			; $6d57
	ld l,$46		; $6d58
	call decHlRef16WithCap		; $6d5a
	jr nz,_label_15_293	; $6d5d
	call interactionIncState2		; $6d5f
	ld l,$46		; $6d62
	ld (hl),$64		; $6d64
	ld b,$14		; $6d66
	ld c,$04		; $6d68
	ld l,$42		; $6d6a
	ld a,(hl)		; $6d6c
	or a			; $6d6d
	jr z,_label_15_292	; $6d6e
	ld b,$3c		; $6d70
	ld c,$02		; $6d72
_label_15_292:
	ld l,$50		; $6d74
	ld (hl),b		; $6d76
	ld a,c			; $6d77
	call interactionSetAnimation		; $6d78
	ld hl,$cfd0		; $6d7b
	ld (hl),$02		; $6d7e
	ret			; $6d80
_label_15_293:
	ld l,$42		; $6d81
	ld a,(hl)		; $6d83
	or a			; $6d84
	call z,interactionAnimate		; $6d85
	ld l,$77		; $6d88
	dec (hl)		; $6d8a
	ret nz			; $6d8b
	ld l,$48		; $6d8c
	ld a,(hl)		; $6d8e
	xor $01			; $6d8f
	ld (hl),a		; $6d91
	ld e,$42		; $6d92
	ld a,(de)		; $6d94
	add a			; $6d95
	add (hl)		; $6d96
	call interactionSetAnimation		; $6d97
_label_15_294:
	call getRandomNumber_noPreserveVars		; $6d9a
	and $03			; $6d9d
	swap a			; $6d9f
	add $20			; $6da1
	ld e,$77		; $6da3
	ld (de),a		; $6da5
	ret			; $6da6
	call interactionDecCounter1		; $6da7
	ret nz			; $6daa
	ld b,$78		; $6dab
	ld e,$42		; $6dad
	ld a,(de)		; $6daf
	or a			; $6db0
	jr nz,_label_15_295	; $6db1
	ld b,$a0		; $6db3
_label_15_295:
	ld (hl),b		; $6db5
	ld hl,$cfd0		; $6db6
	ld (hl),$03		; $6db9
	jp interactionIncState2		; $6dbb
	call interactionDecCounter1		; $6dbe
	ret nz			; $6dc1
	ld (hl),$3c		; $6dc2
	ld hl,$cfd0		; $6dc4
	ld (hl),$04		; $6dc7
	jp interactionIncState2		; $6dc9
	call interactionAnimate		; $6dcc
	call objectApplySpeed		; $6dcf
	call interactionDecCounter1		; $6dd2
	ret nz			; $6dd5
	ld hl,$cfdf		; $6dd6
	ld (hl),$01		; $6dd9
	ret			; $6ddb

interactionCodee1:
	ld e,$44		; $6ddc
	ld a,(de)		; $6dde
	rst_jumpTable			; $6ddf
	and $6d			; $6de0
	rst $28			; $6de2
	ld l,l			; $6de3
	cp b			; $6de4
	dec h			; $6de5
	ld a,$01		; $6de6
	ld (de),a		; $6de8
	call interactionInitGraphics		; $6de9
	call interactionSetAlwaysUpdateBit		; $6dec
	ld a,($cc49)		; $6def
	or a			; $6df2
	jr nz,_label_15_296	; $6df3
	call objectGetTileAtPosition		; $6df5
	cp $e6			; $6df8
	ret nz			; $6dfa
_label_15_296:
	call $6e06		; $6dfb
	ld a,$02		; $6dfe
	ld e,$44		; $6e00
	ld (de),a		; $6e02
	jp objectSetVisible83		; $6e03
	ld e,$42		; $6e06
	ld a,(de)		; $6e08
	or a			; $6e09
	ret nz			; $6e0a
	call getThisRoomFlags		; $6e0b
	ld a,($cc49)		; $6e0e
	cp $02			; $6e11
	jr c,_label_15_297	; $6e13
	cp $03			; $6e15
	ret nz			; $6e17
	ld a,($cc4c)		; $6e18
	cp $a8			; $6e1b
	ld hl,$c704		; $6e1d
	jr z,_label_15_297	; $6e20
	ld hl,$c7f7		; $6e22
_label_15_297:
	set 3,(hl)		; $6e25
	ret			; $6e27

interactionCodee3:
	ld e,$44		; $6e28
	ld a,(de)		; $6e2a
	rst_jumpTable			; $6e2b
	jr nc,_label_15_300	; $6e2c
	ld d,d			; $6e2e
	ld l,(hl)		; $6e2f
	ld a,$01		; $6e30
	ld (de),a		; $6e32
	call interactionInitGraphics		; $6e33
	call interactionSetAlwaysUpdateBit		; $6e36
	ld bc,$fe00		; $6e39
	call objectSetSpeedZ		; $6e3c
	ld hl,$7f29		; $6e3f
	call interactionSetScript		; $6e42
	ld a,$bb		; $6e45
	call playSound		; $6e47
	ld a,$00		; $6e4a
	call interactionSetAnimation		; $6e4c
	jp interactionAnimateAsNpc		; $6e4f
	ld e,$45		; $6e52
	ld a,(de)		; $6e54
	rst_jumpTable			; $6e55
	ld e,(hl)		; $6e56
	ld l,(hl)		; $6e57
	ld a,(hl)		; $6e58
	ld l,(hl)		; $6e59
	sbc h			; $6e5a
	ld l,(hl)		; $6e5b
	cp h			; $6e5c
	ld l,(hl)		; $6e5d
	call $6ede		; $6e5e
	ld e,$4f		; $6e61
	ld a,(de)		; $6e63
	cp $e0			; $6e64
	jr c,_label_15_298	; $6e66
	jp interactionAnimateAsNpc		; $6e68
_label_15_298:
	call interactionIncState2		; $6e6b
	ld a,$39		; $6e6e
	ld (wActiveMusic),a		; $6e70
	call playSound		; $6e73
	ld a,$01		; $6e76
	call interactionSetAnimation		; $6e78
	jp interactionAnimateAsNpc		; $6e7b
	ld hl,$71ce		; $6e7e
	ld e,$0a		; $6e81
	call interBankCall		; $6e83
	call interactionRunScript		; $6e86
	jr c,_label_15_299	; $6e89
	jp interactionAnimateAsNpc		; $6e8b
_label_15_299:
	call interactionIncState2		; $6e8e
	ld a,$74		; $6e91
	call playSound		; $6e93
	ld bc,$fc00		; $6e96
	call objectSetSpeedZ		; $6e99
_label_15_300:
	call $6ede		; $6e9c
	ld e,$4f		; $6e9f
	ld a,(de)		; $6ea1
	cp $b0			; $6ea2
	jr c,_label_15_301	; $6ea4
	jp interactionAnimateAsNpc		; $6ea6
_label_15_301:
	ld a,($cc62)		; $6ea9
	ld (wActiveMusic),a		; $6eac
	call playSound		; $6eaf
	xor a			; $6eb2
	ld ($cc02),a		; $6eb3
	ld ($cca4),a		; $6eb6
	call interactionIncState2		; $6eb9
	call getFreeInteractionSlot		; $6ebc
	ret nz			; $6ebf
	ld (hl),$90		; $6ec0
	inc l			; $6ec2
	ld (hl),$07		; $6ec3
	ld l,$4b		; $6ec5
	ld (hl),$7c		; $6ec7
	ld l,$4d		; $6ec9
	ld (hl),$78		; $6ecb
	call getFreeInteractionSlot		; $6ecd
	jr nz,_label_15_302	; $6ed0
	ld (hl),$05		; $6ed2
	ld a,$78		; $6ed4
	ld l,$4b		; $6ed6
	ldi (hl),a		; $6ed8
	inc l			; $6ed9
	ld (hl),a		; $6eda
_label_15_302:
	jp interactionDelete		; $6edb
	ldh a,(<hActiveObjectType)	; $6ede
	add $0e			; $6ee0
	ld l,a			; $6ee2
	add $06			; $6ee3
	ld e,a			; $6ee5
	ld h,d			; $6ee6
	jp objectApplyComponentSpeed@addSpeedComponent		; $6ee7

interactionCodee4:
	call checkInteractionState		; $6eea
	jr z,_label_15_303	; $6eed
	call interactionRunScript		; $6eef
	jp c,interactionDelete		; $6ef2
	jp npcFaceLinkAndAnimate		; $6ef5
_label_15_303:
	call getThisRoomFlags		; $6ef8
	and $40			; $6efb
	jp nz,interactionDelete		; $6efd
	call interactionIncState		; $6f00
	call interactionInitGraphics		; $6f03
	call objectSetVisible82		; $6f06
	ld a,$33		; $6f09
	call interactionSetHighTextIndex		; $6f0b
	ld hl,$7f33		; $6f0e
	jp interactionSetScript		; $6f11
	ld a,$01		; $6f14
	ld ($ccbb),a		; $6f16
	dec a			; $6f19
	ld ($ccbc),a		; $6f1a
	ld b,$08		; $6f1d
_label_15_304:
	call $6f39		; $6f1f
	call getFreeInteractionSlot		; $6f22
	jr nz,_label_15_305	; $6f25
	ld (hl),$05		; $6f27
	ld l,$4b		; $6f29
	call setShortPosition_paramC		; $6f2b
_label_15_305:
	push bc			; $6f2e
	ld a,$f1		; $6f2f
	call setTile		; $6f31
	pop bc			; $6f34
	dec b			; $6f35
	jr nz,_label_15_304	; $6f36
	ret			; $6f38
	ld a,b			; $6f39
	dec a			; $6f3a
	ld hl,$6f41		; $6f3b
	rst_addAToHl			; $6f3e
	ld c,(hl)		; $6f3f
	ret			; $6f40
	inc hl			; $6f41
	dec (hl)		; $6f42
	dec sp			; $6f43
	ld b,e			; $6f44
	ld e,c			; $6f45
	ld e,e			; $6f46
	ld h,(hl)		; $6f47
	ld (hl),e		; $6f48
	xor a			; $6f49
	ld ($cfd0),a		; $6f4a
	ld a,$08		; $6f4d
	call cpRupeeValue		; $6f4f
	ret nz			; $6f52
	ld a,$08		; $6f53
	call removeRupeeValue		; $6f55
	ld a,$01		; $6f58
	ld ($cfd0),a		; $6f5a
	ret			; $6f5d

interactionCodee6:
	ld e,$44		; $6f5e
	ld a,(de)		; $6f60
	rst_jumpTable			; $6f61
	ld h,(hl)		; $6f62
	ld l,a			; $6f63
	add sp,$6f		; $6f64
	ld a,$01		; $6f66
	ld (de),a		; $6f68
	call interactionInitGraphics		; $6f69
	ld e,$42		; $6f6c
	ld a,(de)		; $6f6e
	rst_jumpTable			; $6f6f
	ld a,b			; $6f70
	ld l,a			; $6f71
	adc d			; $6f72
	ld l,a			; $6f73
	cp (hl)			; $6f74
	ld l,a			; $6f75
	ld ($ff00+c),a		; $6f76
	ld l,a			; $6f77
	call getThisRoomFlags		; $6f78
	bit 5,(hl)		; $6f7b
	jp nz,interactionDelete		; $6f7d
	xor a			; $6f80
	ld ($cceb),a		; $6f81
	ld hl,$7f66		; $6f84
	jp interactionSetScript		; $6f87
	ld e,$43		; $6f8a
	ld a,(de)		; $6f8c
	rlca			; $6f8d
	ld hl,$6fae		; $6f8e
	rst_addDoubleIndex			; $6f91
	ldi a,(hl)		; $6f92
	ld e,$49		; $6f93
	ld (de),a		; $6f95
	ldi a,(hl)		; $6f96
	ld e,$5c		; $6f97
	ld (de),a		; $6f99
	ldi a,(hl)		; $6f9a
	ld e,$7b		; $6f9b
	ld (de),a		; $6f9d
	ldi a,(hl)		; $6f9e
	ld e,$50		; $6f9f
	ld (de),a		; $6fa1
	ld h,d			; $6fa2
	ld l,$46		; $6fa3
	ld (hl),$3c		; $6fa5
	ld l,$47		; $6fa7
	ld (hl),$5a		; $6fa9
	jp objectSetVisible80		; $6fab
	inc bc			; $6fae
	nop			; $6faf
	ld ($0b3c),sp		; $6fb0
	ld (bc),a		; $6fb3
	inc c			; $6fb4
	jr z,_label_15_306	; $6fb5
	inc bc			; $6fb7
	stop			; $6fb8
	jr z,$1d		; $6fb9
	ld bc,$3c14		; $6fbb
	ld a,$04		; $6fbe
	call objectSetCollideRadius		; $6fc0
	ld h,d			; $6fc3
	ld l,$4f		; $6fc4
	ld (hl),$f0		; $6fc6
	ld l,$46		; $6fc8
	ld (hl),$00		; $6fca
_label_15_306:
	ld l,$47		; $6fcc
	ld (hl),$30		; $6fce
	ld bc,$e603		; $6fd0
	call objectCreateInteraction		; $6fd3
	ret nz			; $6fd6
	ld l,$56		; $6fd7
	ldh a,(<hActiveObjectType)	; $6fd9
	ldi (hl),a		; $6fdb
	ldh a,(<hActiveObject)	; $6fdc
	ld (hl),a		; $6fde
	jp objectSetVisible81		; $6fdf
	call interactionSetAlwaysUpdateBit		; $6fe2
	jp objectSetVisible82		; $6fe5
	ld e,$42		; $6fe8
	ld a,(de)		; $6fea
	rst_jumpTable			; $6feb
.DB $f4				; $6fec
	ld l,a			; $6fed
	ei			; $6fee
	ld l,a			; $6fef
	ld a,(de)		; $6ff0
	ld (hl),b		; $6ff1
	nop			; $6ff2
	ld (hl),c		; $6ff3
	call interactionRunScript		; $6ff4
	jp c,interactionDelete		; $6ff7
	ret			; $6ffa
	call interactionAnimate		; $6ffb
	ld e,$45		; $6ffe
	ld a,(de)		; $7000
	rst_jumpTable			; $7001
	ld b,$70		; $7002
	dec c			; $7004
	ld (hl),b		; $7005
	call interactionDecCounter2		; $7006
	ret nz			; $7009
	call interactionIncState2		; $700a
	call $7121		; $700d
	call objectApplySpeed		; $7010
	call interactionDecCounter1		; $7013
	jp z,interactionDelete		; $7016
	ret			; $7019
	ld e,$45		; $701a
	ld a,(de)		; $701c
	rst_jumpTable			; $701d
	inc l			; $701e
	ld (hl),b		; $701f
	ld l,a			; $7020
	ld (hl),b		; $7021
	add h			; $7022
	ld (hl),b		; $7023
	sub a			; $7024
	ld (hl),b		; $7025
	push de			; $7026
	ld (hl),b		; $7027
	pop hl			; $7028
	ld (hl),b		; $7029
	rst $28			; $702a
	ld (hl),b		; $702b
	ld a,(wFrameCounter)		; $702c
	and $03			; $702f
	ret nz			; $7031
	ld h,d			; $7032
	ld l,$46		; $7033
	inc (hl)		; $7035
	ld a,(hl)		; $7036
	and $0f			; $7037
	ld hl,$705f		; $7039
	rst_addAToHl			; $703c
	ld a,(hl)		; $703d
	add $f0			; $703e
	ld e,$4f		; $7040
	ld (de),a		; $7042
	ld h,d			; $7043
	ld l,$47		; $7044
	dec (hl)		; $7046
	ret nz			; $7047
	call clearAllParentItems		; $7048
	ld hl,$d008		; $704b
	ld (hl),$00		; $704e
	call objectGetAngleTowardLink		; $7050
	ld h,d			; $7053
	ld l,$49		; $7054
	ld (hl),a		; $7056
	ld l,$50		; $7057
	ld (hl),$14		; $7059
	ld l,$45		; $705b
	inc (hl)		; $705d
	ret			; $705e
	nop			; $705f
	nop			; $7060
	rst $38			; $7061
	rst $38			; $7062
	rst $38			; $7063
	cp $fe			; $7064
	cp $fe			; $7066
	cp $fe			; $7068
	rst $38			; $706a
	rst $38			; $706b
	rst $38			; $706c
	rst $38			; $706d
	nop			; $706e
	call objectGetAngleTowardLink		; $706f
	ld e,$49		; $7072
	ld (de),a		; $7074
	call objectApplySpeed		; $7075
	call objectCheckCollidedWithLink_ignoreZ		; $7078
	ret nc			; $707b
	ld e,$67		; $707c
	ld a,$06		; $707e
	ld (de),a		; $7080
	jp interactionIncState2		; $7081
	ld c,$08		; $7084
	call objectUpdateSpeedZ_paramC		; $7086
	jr z,_label_15_307	; $7089
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $708b
	ret nc			; $708e
_label_15_307:
	ld h,d			; $708f
	ld l,$47		; $7090
	ld (hl),$1e		; $7092
	jp interactionIncState2		; $7094
	call interactionDecCounter2		; $7097
	ret nz			; $709a
	ld a,$04		; $709b
	ld ($cc6a),a		; $709d
	xor a			; $70a0
	ld ($cc6b),a		; $70a1
	call interactionIncState2		; $70a4
	ld a,($d00b)		; $70a7
	sub $0e			; $70aa
	ld l,$4b		; $70ac
	ldi (hl),a		; $70ae
	inc l			; $70af
	ld a,($d00d)		; $70b0
	sub $04			; $70b3
	ldi (hl),a		; $70b5
	inc l			; $70b6
	xor a			; $70b7
	ldi (hl),a		; $70b8
	ld (hl),a		; $70b9
	ld b,$00		; $70ba
	ld c,$71		; $70bc
	call showText		; $70be
	call getThisRoomFlags		; $70c1
	set 5,(hl)		; $70c4
	ld a,$06		; $70c6
	call playSound		; $70c8
	ld c,$07		; $70cb
	ld a,$07		; $70cd
	call giveTreasure		; $70cf
	jp darkenRoom		; $70d2
	call retIfTextIsActive		; $70d5
	call interactionIncState2		; $70d8
	ld hl,$7f6a		; $70db
	jp interactionSetScript		; $70de
	call interactionRunScript		; $70e1
	ret nc			; $70e4
	call interactionIncState2		; $70e5
	ld l,$47		; $70e8
	ld (hl),$14		; $70ea
	jp brightenRoom		; $70ec
	ld a,($c4ab)		; $70ef
	or a			; $70f2
	ret nz			; $70f3
	call interactionDecCounter2		; $70f4
	ret nz			; $70f7
	ld a,$01		; $70f8
	ld ($cceb),a		; $70fa
	jp interactionDelete		; $70fd
	ld a,($cceb)		; $7100
	or a			; $7103
	jp nz,interactionDelete		; $7104
	ld a,$00		; $7107
	call objectGetRelatedObject1Var		; $7109
	call objectTakePosition		; $710c
	call interactionAnimate		; $710f
	ld h,d			; $7112
	ld l,$61		; $7113
	ld a,(hl)		; $7115
	or a			; $7116
	ret z			; $7117
	ld (hl),$00		; $7118
	ld l,$5a		; $711a
	ld a,$80		; $711c
	xor (hl)		; $711e
	ld (hl),a		; $711f
	ret			; $7120
	ld h,d			; $7121
	ld l,$7b		; $7122
	dec (hl)		; $7124
	ret nz			; $7125
	ld l,$7b		; $7126
	ld (hl),$10		; $7128
	ld bc,$8401		; $712a
	jp objectCreateInteraction		; $712d
	ld hl,$d008		; $7130
	ld (hl),a		; $7133
	ld a,$80		; $7134
	jp setLinkForceStateToState08_withParam		; $7136
	ld bc,$715e		; $7139
	xor a			; $713c
_label_15_308:
	ldh (<hFF8B),a	; $713d
	call getFreeInteractionSlot		; $713f
	ret nz			; $7142
	ld (hl),$e6		; $7143
	inc l			; $7145
	ld (hl),$01		; $7146
	inc l			; $7148
	ldh a,(<hFF8B)	; $7149
	ld (hl),a		; $714b
	ld l,$4b		; $714c
	ld a,(bc)		; $714e
	ld (hl),a		; $714f
	inc bc			; $7150
	ld l,$4d		; $7151
	ld a,(bc)		; $7153
	ld (hl),a		; $7154
	inc bc			; $7155
	ldh a,(<hFF8B)	; $7156
	inc a			; $7158
	cp $04			; $7159
	jr nz,_label_15_308	; $715b
	ret			; $715d
	ld a,b			; $715e
	jr _label_15_309		; $715f
	jr _label_15_310		; $7161
	adc b			; $7163
	ld a,b			; $7164
	adc b			; $7165

interactionCodee7:
	ld e,$44		; $7166
	ld a,(de)		; $7168
_label_15_309:
	rst_jumpTable			; $7169
	ld l,(hl)		; $716a
_label_15_310:
	ld (hl),c		; $716b
	adc c			; $716c
	ld (hl),c		; $716d
	ld a,$01		; $716e
	ld (de),a		; $7170
	call interactionInitGraphics		; $7171
	ld a,$36		; $7174
	call interactionSetHighTextIndex		; $7176
	ld e,$7e		; $7179
	ld a,$00		; $717b
	ld (de),a		; $717d
	ld hl,$5779		; $717e
	call interactionSetScript		; $7181
	ld a,$02		; $7184
	call interactionSetAnimation		; $7186
	call interactionRunScript		; $7189
	jp npcFaceLinkAndAnimate		; $718c
