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
