.include "code/interactionCode/treasure.s"
.include "code/interactionCode/group3.s"


interactionCode5e:
	call returnIfScrollMode01Unset		; $4bce
	ld e,Interaction.state		; $4bd1
	ld a,(de)		; $4bd3
	rst_jumpTable			; $4bd4
.DB $db				; $4bd5
	ld c,e			; $4bd6
	sbc $4b			; $4bd7
	ld b,a			; $4bd9
	ld c,h			; $4bda
	ld a,$01		; $4bdb
	ld (de),a		; $4bdd
	ld a,$21		; $4bde
	call objectSetCollideRadius		; $4be0
	call $4cbd		; $4be3
	call $4cb1		; $4be6
	call $4ce8		; $4be9
	ld a,($d004)		; $4bec
	cp $01			; $4bef
	ret nz			; $4bf1
	ld a,($d00f)		; $4bf2
	or a			; $4bf5
	ret nz			; $4bf6
	ld bc,$2105		; $4bf7
	call $4c91		; $4bfa
	ret nc			; $4bfd
	ld a,$23		; $4bfe
	call cpActiveRing		; $4c00
	jr z,_label_09_050	; $4c03
	call objectGetAngleTowardLink		; $4c05
	xor $10			; $4c08
	ld c,a			; $4c0a
	ld b,$14		; $4c0b
	call updateLinkPositionGivenVelocity		; $4c0d
_label_09_050:
	call $4ca3		; $4c10
	ld bc,$0300		; $4c13
	call $4c91		; $4c16
	ret nc			; $4c19
	ld e,Interaction.subid		; $4c1a
	ld a,(de)		; $4c1c
	or a			; $4c1d
	ld a,$01		; $4c1e
	jr z,_label_09_051	; $4c20
	call dropLinkHeldItem		; $4c22
	call clearAllParentItems		; $4c25
	ld h,d			; $4c28
	ld l,$44		; $4c29
	ld (hl),$02		; $4c2b
	ld a,($ccc1)		; $4c2d
	and $7f			; $4c30
	ld l,$47		; $4c32
	ldd (hl),a		; $4c34
	ld (hl),$3c		; $4c35
	ld a,$03		; $4c37
_label_09_051:
	ld ($cc6c),a		; $4c39
	ld a,$02		; $4c3c
	ld ($cc6a),a		; $4c3e
	ld hl,$d00b		; $4c41
	jp objectCopyPosition		; $4c44
	xor a			; $4c47
	ld ($ccc1),a		; $4c48
	call interactionDecCounter1		; $4c4b
	ret nz			; $4c4e
	ld c,$03		; $4c4f
	ld l,$42		; $4c51
	ld a,(hl)		; $4c53
	cp $05			; $4c54
	jr z,_label_09_052	; $4c56
	dec c			; $4c58
	ld e,$47		; $4c59
	ld a,(de)		; $4c5b
	cp (hl)			; $4c5c
	jr z,_label_09_052	; $4c5d
	ld a,(wFrameCounter)		; $4c5f
	and $01			; $4c62
	ld c,a			; $4c64
_label_09_052:
	ld a,c			; $4c65
	add a			; $4c66
	add c			; $4c67
	ld hl,$4c85		; $4c68
	rst_addAToHl			; $4c6b
	ldi a,(hl)		; $4c6c
	ld ($cc63),a		; $4c6d
	ldi a,(hl)		; $4c70
	ld ($cc64),a		; $4c71
	ldi a,(hl)		; $4c74
	ld ($cc66),a		; $4c75
	ld a,$05		; $4c78
	ld ($cc65),a		; $4c7a
	ld a,$03		; $4c7d
	ld ($cc67),a		; $4c7f
	jp interactionDelete		; $4c82
	add l			; $4c85
	ret nc			; $4c86
	ld d,a			; $4c87
	add l			; $4c88
	pop de			; $4c89
	ld d,a			; $4c8a
	add l			; $4c8b
	jp nc,$8457		; $4c8c
.DB $f4				; $4c8f
	daa			; $4c90
	ld h,d			; $4c91
	ld l,$66		; $4c92
	ld (hl),b		; $4c94
	inc l			; $4c95
	ld (hl),b		; $4c96
	ld a,($d00b)		; $4c97
	add c			; $4c9a
	ld b,a			; $4c9b
	ld a,($d00d)		; $4c9c
	ld c,a			; $4c9f
	jp interactionCheckContainsPoint		; $4ca0
	ld hl,$ccc1		; $4ca3
	ld a,(hl)		; $4ca6
	or a			; $4ca7
	ret z			; $4ca8
	ld e,Interaction.subid		; $4ca9
	ld a,(de)		; $4cab
	cp (hl)			; $4cac
	ret nz			; $4cad
	set 7,(hl)		; $4cae
	ret			; $4cb0
	ld c,$4d		; $4cb1
	call objectFindSameTypeObjectWithID		; $4cb3
	ret nz			; $4cb6
	ld l,$4f		; $4cb7
	ld e,$7a		; $4cb9
	jr _label_09_054		; $4cbb
	ld h,$d0		; $4cbd
_label_09_053:
	ld l,$c1		; $4cbf
	ld a,(hl)		; $4cc1
	cp $01			; $4cc2
	call z,$4cce		; $4cc4
	inc h			; $4cc7
	ld a,h			; $4cc8
	cp $e0			; $4cc9
	jr c,_label_09_053	; $4ccb
	ret			; $4ccd
	ld l,$cf		; $4cce
	ld e,$f1		; $4cd0
_label_09_054:
	ldd a,(hl)		; $4cd2
	rlca			; $4cd3
	ret c			; $4cd4
	dec l			; $4cd5
	ld c,(hl)		; $4cd6
	dec l			; $4cd7
	dec l			; $4cd8
	ld b,(hl)		; $4cd9
	ld l,e			; $4cda
	push hl			; $4cdb
	call interactionCheckContainsPoint		; $4cdc
	pop hl			; $4cdf
	ret nc			; $4ce0
	call objectGetPosition		; $4ce1
	ld (hl),b		; $4ce4
	inc l			; $4ce5
	ld (hl),c		; $4ce6
	ret			; $4ce7
	ld c,$03		; $4ce8
	call findItemWithID		; $4cea
	call z,$4cfe		; $4ced
	ld c,$03		; $4cf0
	call findItemWithID_startingAfterH		; $4cf2
	call z,$4cfe		; $4cf5
	ld c,$21		; $4cf8
	call findItemWithID		; $4cfa
	ret nz			; $4cfd
	ld l,$0f		; $4cfe
	ld e,$31		; $4d00
	jr _label_09_054		; $4d02

interactionCode5f:
	ld e,Interaction.subid		; $4d04
	ld a,(de)		; $4d06
	cp $06			; $4d07
	jr z,_label_09_055	; $4d09
	ld a,(de)		; $4d0b
	rlca			; $4d0c
	jr c,_label_09_056	; $4d0d
	ld a,($d100)		; $4d0f
	or a			; $4d12
	jp nz,_label_09_060		; $4d13
_label_09_055:
	ld a,(de)		; $4d16
	rst_jumpTable			; $4d17
	or b			; $4d18
	ld c,(hl)		; $4d19
	ld l,h			; $4d1a
	ld c,(hl)		; $4d1b
	ld h,b			; $4d1c
	ld c,(hl)		; $4d1d
	sbc b			; $4d1e
	ld c,(hl)		; $4d1f
	dec a			; $4d20
	ld c,(hl)		; $4d21
	ld l,$4e		; $4d22
	add h			; $4d24
	ld c,(hl)		; $4d25
_label_09_056:
	ld a,($d100)		; $4d26
	or a			; $4d29
	jr z,_label_09_057	; $4d2a
	ld a,($d101)		; $4d2c
	cp $0e			; $4d2f
	jr nc,_label_09_057	; $4d31
	cp $0a			; $4d33
	jp nz,_label_09_060		; $4d35
_label_09_057:
	ld a,($cc50)		; $4d38
	and $81			; $4d3b
	cp $01			; $4d3d
	jp nz,_label_09_060		; $4d3f
	ld bc,$510f		; $4d42
	ld a,($c6af)		; $4d45
	or a			; $4d48
	jp z,$4e24		; $4d49
	ld a,($cc4c)		; $4d4c
	ld hl,$4f2e		; $4d4f
	call checkFlag		; $4d52
	jp z,$4e21		; $4d55
	ld a,($d100)		; $4d58
	or a			; $4d5b
	jp nz,_label_09_060		; $4d5c
	ld e,$7e		; $4d5f
	ld hl,$d00b		; $4d61
	ldi a,(hl)		; $4d64
	and $f0			; $4d65
	ld (de),a		; $4d67
	inc l			; $4d68
	inc e			; $4d69
	ld a,(hl)		; $4d6a
	swap a			; $4d6b
	and $0f			; $4d6d
	ld (de),a		; $4d6f
	ld hl,$ce00		; $4d70
	rst_addAToHl			; $4d73
	call $4ed5		; $4d74
	ld b,$f8		; $4d77
	ld l,c			; $4d79
	ld h,$10		; $4d7a
	ld a,$02		; $4d7c
	jr z,_label_09_058	; $4d7e
	ld e,$7f		; $4d80
	ld a,(de)		; $4d82
	ld hl,$ce60		; $4d83
	rst_addAToHl			; $4d86
	call $4ed5		; $4d87
	ld b,$88		; $4d8a
	ld l,c			; $4d8c
	ld h,$70		; $4d8d
	ld a,$00		; $4d8f
	jr z,_label_09_058	; $4d91
	ld e,$7e		; $4d93
	ld a,(de)		; $4d95
	ld hl,$ce08		; $4d96
	rst_addAToHl			; $4d99
	call $4ed9		; $4d9a
	ld c,$a8		; $4d9d
	ld h,b			; $4d9f
	ld l,$90		; $4da0
	ld a,$03		; $4da2
	jr z,_label_09_058	; $4da4
	ld e,$7e		; $4da6
	ld a,(de)		; $4da8
	ld hl,$ce00		; $4da9
	rst_addAToHl			; $4dac
	call $4ed9		; $4dad
	ld c,$f8		; $4db0
	ld h,b			; $4db2
	ld l,$10		; $4db3
	ld a,$01		; $4db5
	jr z,_label_09_058	; $4db7
	ld hl,$ce03		; $4db9
	call $4eea		; $4dbc
	ld b,$f8		; $4dbf
	ld l,c			; $4dc1
	ld h,$10		; $4dc2
	ld a,$02		; $4dc4
	jr nz,_label_09_058	; $4dc6
	ld hl,$ce63		; $4dc8
	call $4eea		; $4dcb
	ld b,$88		; $4dce
	ld l,c			; $4dd0
	ld h,$70		; $4dd1
	ld a,$00		; $4dd3
	jr nz,_label_09_058	; $4dd5
	ld hl,$ce28		; $4dd7
	call $4ef1		; $4dda
	ld c,$a8		; $4ddd
	ld h,b			; $4ddf
	ld l,$90		; $4de0
	ld a,$03		; $4de2
	jr nz,_label_09_058	; $4de4
	ld hl,$ce20		; $4de6
	call $4ef1		; $4de9
	ld c,$f8		; $4dec
	ld h,b			; $4dee
	ld l,$10		; $4def
	ld a,$01		; $4df1
	jr z,_label_09_059	; $4df3
_label_09_058:
	push de			; $4df5
	push hl			; $4df6
	pop de			; $4df7
	ld hl,$c638		; $4df8
	ldh (<hFF8B),a	; $4dfb
	ld a,d			; $4dfd
	ldi (hl),a		; $4dfe
	ld a,e			; $4dff
	ld (hl),a		; $4e00
	ldh a,(<hFF8B)	; $4e01
	pop de			; $4e03
	ld hl,$d108		; $4e04
	ldi (hl),a		; $4e07
	swap a			; $4e08
	srl a			; $4e0a
	ldi (hl),a		; $4e0c
	inc l			; $4e0d
	ld (hl),b		; $4e0e
	ld l,$0d		; $4e0f
	ld (hl),c		; $4e11
	ld l,$00		; $4e12
	inc (hl)		; $4e14
	inc l			; $4e15
	ld a,($c610)		; $4e16
	ldi (hl),a		; $4e19
	ld l,$04		; $4e1a
	ld a,$0c		; $4e1c
	ld (hl),a		; $4e1e
	jr _label_09_060		; $4e1f
_label_09_059:
	ld bc,$510c		; $4e21
	ld a,($cba0)		; $4e24
	or a			; $4e27
	call z,showText		; $4e28
_label_09_060:
	jp interactionDelete		; $4e2b
	ld hl,$c645		; $4e2e
	ld a,($c6bb)		; $4e31
	bit 3,a			; $4e34
	jp z,$4eab		; $4e36
	set 6,(hl)		; $4e39
	jr _label_09_060		; $4e3b
	ld a,($c6bb)		; $4e3d
	bit 2,a			; $4e40
	jr z,_label_09_060	; $4e42
	ld a,($c644)		; $4e44
	and $20			; $4e47
	jr z,_label_09_060	; $4e49
	ld a,($c610)		; $4e4b
	cp $0c			; $4e4e
	jr z,_label_09_060	; $4e50
	ld hl,$c644		; $4e52
	ld a,TREASURE_FLIPPERS		; $4e55
	call checkTreasureObtained		; $4e57
	jr nc,_label_09_063	; $4e5a
	set 6,(hl)		; $4e5c
	jr _label_09_060		; $4e5e
	ld a,($c610)		; $4e60
	cp $0c			; $4e63
	jr nz,_label_09_060	; $4e65
	ld hl,$c644		; $4e67
	jr _label_09_062		; $4e6a
	ld hl,$c643		; $4e6c
	ld a,($c6bb)		; $4e6f
	bit 1,a			; $4e72
	jr z,_label_09_060	; $4e74
	ld a,($c610)		; $4e76
	cp $0b			; $4e79
	jr z,_label_09_062	; $4e7b
	ld a,(hl)		; $4e7d
	bit 6,a			; $4e7e
	jr z,_label_09_063	; $4e80
	jr _label_09_060		; $4e82
	ld hl,$c643		; $4e84
	ld a,($c610)		; $4e87
	cp $0b			; $4e8a
	jr z,_label_09_061	; $4e8c
	ld a,($c6af)		; $4e8e
	or a			; $4e91
	jr z,_label_09_060	; $4e92
	set 6,(hl)		; $4e94
_label_09_061:
	jr _label_09_060		; $4e96
	ld a,($c610)		; $4e98
	cp $0d			; $4e9b
	jr nz,_label_09_060	; $4e9d
	ld hl,$c645		; $4e9f
	ld a,(hl)		; $4ea2
	and $a0			; $4ea3
	jr nz,_label_09_060	; $4ea5
_label_09_062:
	bit 7,(hl)		; $4ea7
	jr nz,_label_09_061	; $4ea9
_label_09_063:
	ld a,(hl)		; $4eab
	and $40			; $4eac
	jr nz,_label_09_061	; $4eae
	ld e,Interaction.subid		; $4eb0
	ld a,(de)		; $4eb2
	add a			; $4eb3
	ld hl,$4f16		; $4eb4
	rst_addDoubleIndex			; $4eb7
	ld bc,$d100		; $4eb8
	ld a,$01		; $4ebb
	ld (bc),a		; $4ebd
	inc c			; $4ebe
	ldi a,(hl)		; $4ebf
	ld (bc),a		; $4ec0
	ld c,$0b		; $4ec1
	ldi a,(hl)		; $4ec3
	ld (bc),a		; $4ec4
	ld ($c638),a		; $4ec5
	ld c,$0d		; $4ec8
	ldi a,(hl)		; $4eca
	ld (bc),a		; $4ecb
	ld ($c639),a		; $4ecc
	xor a			; $4ecf
	ld ($cc40),a		; $4ed0
	jr _label_09_061		; $4ed3
	ld b,$10		; $4ed5
	jr _label_09_064		; $4ed7
	ld b,$01		; $4ed9
_label_09_064:
	ld a,(hl)		; $4edb
	or a			; $4edc
	ret nz			; $4edd
	ld a,l			; $4ede
	add b			; $4edf
	ld l,a			; $4ee0
	ld a,(hl)		; $4ee1
	or a			; $4ee2
	ld a,l			; $4ee3
	ret nz			; $4ee4
	call convertShortToLongPosition		; $4ee5
	xor a			; $4ee8
	ret			; $4ee9
	push de			; $4eea
	ld b,$01		; $4eeb
	ld e,$10		; $4eed
	jr _label_09_065		; $4eef
	push de			; $4ef1
	ld b,$10		; $4ef2
	ld e,$01		; $4ef4
_label_09_065:
	ld c,$04		; $4ef6
_label_09_066:
	ld a,(hl)		; $4ef8
	or a			; $4ef9
	jr z,_label_09_068	; $4efa
_label_09_067:
	ld a,l			; $4efc
	add b			; $4efd
	ld l,a			; $4efe
	dec c			; $4eff
	jr nz,_label_09_066	; $4f00
	pop de			; $4f02
	ret			; $4f03
_label_09_068:
	ld a,l			; $4f04
	add e			; $4f05
	ld l,a			; $4f06
	ld a,(hl)		; $4f07
	or a			; $4f08
	ld a,l			; $4f09
	jr z,_label_09_069	; $4f0a
	sub e			; $4f0c
	ld l,a			; $4f0d
	jr _label_09_067		; $4f0e
_label_09_069:
	call convertShortToLongPosition		; $4f10
	or d			; $4f13
	pop de			; $4f14
	ret			; $4f15
	ld c,$18		; $4f16
	cp b			; $4f18
	nop			; $4f19
	dec bc			; $4f1a
	jr c,$50		; $4f1b
	nop			; $4f1d
	inc c			; $4f1e
	jr $5f			; $4f1f
	nop			; $4f21
	dec c			; $4f22
	jr _label_09_070		; $4f23
	nop			; $4f25
	inc c			; $4f26
	jr z,$60		; $4f27
	nop			; $4f29
	dec c			; $4f2a
	ld e,b			; $4f2b
	ld b,b			; $4f2c
	nop			; $4f2d
	nop			; $4f2e
	nop			; $4f2f
	nop			; $4f30
	nop			; $4f31
	nop			; $4f32
	nop			; $4f33
	nop			; $4f34
	nop			; $4f35
	ld ($ff00+$1f),a	; $4f36
	or b			; $4f38
	rlca			; $4f39
	or a			; $4f3a
	rlca			; $4f3b
	rst $38			; $4f3c
	rst $30			; $4f3d
.DB $fd				; $4f3e
	rst $38			; $4f3f
	rst $38			; $4f40
	rst $38			; $4f41
	rst $38			; $4f42
	rst $38			; $4f43
	rst $38			; $4f44
	rra			; $4f45
	rst $38			; $4f46
	dec e			; $4f47
	ld hl,sp+$0f		; $4f48
	ld hl,sp+$0f		; $4f4a
	ld hl,sp+$03		; $4f4c

interactionCode62:
	ld e,Interaction.subid		; $4f4e
	ld a,(de)		; $4f50
	rst_jumpTable			; $4f51
	ld d,(hl)		; $4f52
	ld c,a			; $4f53
	or l			; $4f54
_label_09_070:
	ld c,a			; $4f55
	ld e,Interaction.state		; $4f56
	ld a,(de)		; $4f58
	rst_jumpTable			; $4f59
	ld h,d			; $4f5a
	ld c,a			; $4f5b
	ld a,c			; $4f5c
	ld c,a			; $4f5d
	or l			; $4f5e
	ld c,a			; $4f5f
	or l			; $4f60
	ld c,a			; $4f61
	call getThisRoomFlags		; $4f62
	bit 5,(hl)		; $4f65
	jp nz,interactionDelete		; $4f67
	ld e,Interaction.state		; $4f6a
	ld a,$01		; $4f6c
	ld (de),a		; $4f6e
	ld ($ccbb),a		; $4f6f
	xor a			; $4f72
	ld ($cfd8),a		; $4f73
	ld ($cfd9),a		; $4f76
	ld a,($cc30)		; $4f79
	or a			; $4f7c
	ret nz			; $4f7d
	ld a,($cfd0)		; $4f7e
	ld b,a			; $4f81
	ld c,$00		; $4f82
	call $4fa5		; $4f84
	ld a,($cfd1)		; $4f87
	ld b,a			; $4f8a
	ld c,$01		; $4f8b
	call $4fa5		; $4f8d
	ld a,($cfd2)		; $4f90
	ld b,a			; $4f93
	ld c,$02		; $4f94
	call $4fa5		; $4f96
	ld a,($cfd3)		; $4f99
	ld b,a			; $4f9c
	ld c,$03		; $4f9d
	call $4fa5		; $4f9f
	jp interactionDelete		; $4fa2
	call getFreeInteractionSlot		; $4fa5
	ret nz			; $4fa8
	ld (hl),$62		; $4fa9
	inc l			; $4fab
	ld (hl),$01		; $4fac
	ld l,$70		; $4fae
	ld (hl),b		; $4fb0
	ld l,$43		; $4fb1
	ld (hl),c		; $4fb3
	ret			; $4fb4
	ld e,Interaction.state		; $4fb5
	ld a,(de)		; $4fb7
	rst_jumpTable			; $4fb8
	jp $dd4f		; $4fb9
	ld c,a			; $4fbc
.DB $ec				; $4fbd
	ld c,a			; $4fbe
	ld d,e			; $4fbf
	ld d,b			; $4fc0
	ld e,d			; $4fc1
	ld d,b			; $4fc2
	ld a,$01		; $4fc3
	ld (de),a		; $4fc5
	ld e,$70		; $4fc6
	ld a,(de)		; $4fc8
	ld h,d			; $4fc9
	ld l,$4b		; $4fca
	call setShortPosition		; $4fcc
	ld l,$66		; $4fcf
	ld (hl),$04		; $4fd1
	inc l			; $4fd3
	ld (hl),$06		; $4fd4
	ld l,$46		; $4fd6
	ld (hl),$1e		; $4fd8
	call objectCreatePuff		; $4fda
	call interactionDecCounter1		; $4fdd
	ret nz			; $4fe0
	ld l,$44		; $4fe1
	inc (hl)		; $4fe3
	ld l,$70		; $4fe4
	ld c,(hl)		; $4fe6
	ld a,$f1		; $4fe7
	call setTile		; $4fe9
	ld a,($cfd9)		; $4fec
	or a			; $4fef
	jp nz,_label_09_073		; $4ff0
	call objectPreventLinkFromPassing		; $4ff3
	ld a,($ccbc)		; $4ff6
	or a			; $4ff9
	ret z			; $4ffa
	ld b,a			; $4ffb
	ld e,$70		; $4ffc
	ld a,(de)		; $4ffe
	cp b			; $4fff
	ret nz			; $5000
	ld a,($cfd8)		; $5001
	ld b,a			; $5004
	ld e,$43		; $5005
	ld a,(de)		; $5007
	cp b			; $5008
	jr nz,_label_09_071	; $5009
	inc a			; $500b
	ld ($cfd8),a		; $500c
	ld hl,$d040		; $500f
	ld b,$40		; $5012
	call clearMemory		; $5014
	ld hl,$d040		; $5017
	inc (hl)		; $501a
	inc l			; $501b
	ld (hl),$60		; $501c
	inc l			; $501e
	ld a,($cfd8)		; $501f
	dec a			; $5022
	ld bc,$504b		; $5023
	call addDoubleIndexToBc		; $5026
	ld a,(bc)		; $5029
	ld (hl),a		; $502a
	inc l			; $502b
	inc bc			; $502c
	ld a,(bc)		; $502d
	ld (hl),a		; $502e
	ld bc,$f800		; $502f
	call objectCopyPositionWithOffset		; $5032
	ld e,Interaction.state		; $5035
	ld a,$03		; $5037
	ld (de),a		; $5039
	ld a,$81		; $503a
	ld ($cca4),a		; $503c
	ret			; $503f
_label_09_071:
	ld a,$5a		; $5040
	call playSound		; $5042
	ld a,$01		; $5045
	ld ($cfd9),a		; $5047
	ret			; $504a
	jr z,_label_09_072	; $504b
	inc bc			; $504d
	ld bc,$0020		; $504e
	jr nc,_label_09_072	; $5051
	ld a,($cfd9)		; $5053
_label_09_072:
	or a			; $5056
	jr nz,_label_09_073	; $5057
	ret			; $5059
	call interactionDecCounter1		; $505a
	ret nz			; $505d
	call objectCreatePuff		; $505e
	call getFreeEnemySlot		; $5061
	ret nz			; $5064
	ld (hl),$19		; $5065
	call objectCopyPosition		; $5067
	ld e,$70		; $506a
	ld a,(de)		; $506c
	ld c,a			; $506d
	ld a,$a0		; $506e
	call setTile		; $5070
	jp interactionDelete		; $5073
_label_09_073:
	ld e,Interaction.state		; $5076
	ld a,$04		; $5078
	ld (de),a		; $507a
	ld e,$46		; $507b
	ld a,$3c		; $507d
	ld (de),a		; $507f
	ret			; $5080

interactionCode63:
	ld e,Interaction.state		; $5081
	ld a,(de)		; $5083
	rst_jumpTable			; $5084
	adc c			; $5085
	ld d,b			; $5086
	sbc $50			; $5087
	ld a,($ccc0)		; $5089
	or a			; $508c
	ret z			; $508d
	add $10			; $508e
	and $1f			; $5090
	add $04			; $5092
	add a			; $5094
	swap a			; $5095
	and $03			; $5097
	ld hl,$50da		; $5099
	rst_addAToHl			; $509c
	ld c,(hl)		; $509d
	call objectGetShortPosition		; $509e
	add c			; $50a1
	ld b,$ce		; $50a2
	ld c,a			; $50a4
	ldh (<hFF8C),a	; $50a5
	ld a,(bc)		; $50a7
	or a			; $50a8
	jr nz,_label_09_074	; $50a9
	call getFreeInteractionSlot		; $50ab
	ret nz			; $50ae
	ld (hl),$14		; $50af
	ld l,$49		; $50b1
	ld a,($ccc0)		; $50b3
	add $10			; $50b6
	and $1f			; $50b8
	ld (hl),a		; $50ba
	ldh (<hFF8B),a	; $50bb
	ld bc,$fe00		; $50bd
	call objectCopyPositionWithOffset		; $50c0
	call objectGetShortPosition		; $50c3
	ld l,$70		; $50c6
	ld (hl),a		; $50c8
	ld h,d			; $50c9
	ld l,$4b		; $50ca
	ldh a,(<hFF8C)	; $50cc
	call setShortPosition		; $50ce
	ld l,$44		; $50d1
	ld (hl),$01		; $50d3
	xor a			; $50d5
	ld ($ccc0),a		; $50d6
	ret			; $50d9
	ld a,($ff00+$01)	; $50da
	stop			; $50dc
	rst $38			; $50dd
	ld a,($ccc0)		; $50de
	or a			; $50e1
	ret z			; $50e2
_label_09_074:
	ld e,Interaction.state		; $50e3
	xor a			; $50e5
	ld (de),a		; $50e6
	ld ($ccc0),a		; $50e7
	ret			; $50ea

interactionCode64:
	ld e,Interaction.state		; $50eb
	ld a,(de)		; $50ed
	rst_jumpTable			; $50ee
	ei			; $50ef
	ld d,b			; $50f0
	add hl,de		; $50f1
	ld d,c			; $50f2
	ld sp,$3851		; $50f3
	ld d,c			; $50f6
	ld b,e			; $50f7
	ld d,c			; $50f8
	reti			; $50f9
	ldd a,(hl)		; $50fa
	call interactionInitGraphics		; $50fb
	call getThisRoomFlags		; $50fe
	bit 7,(hl)		; $5101
	jr nz,_label_09_075	; $5103
	call objectGetZAboveScreen		; $5105
	ld h,d			; $5108
	ld l,$44		; $5109
	ld (hl),$01		; $510b
	ld l,$4f		; $510d
	ld (hl),a		; $510f
	ret			; $5110
_label_09_075:
	ld e,Interaction.state		; $5111
	ld a,$04		; $5113
	ld (de),a		; $5115
	jp objectSetVisiblec2		; $5116
	call getThisRoomFlags		; $5119
	bit 7,(hl)		; $511c
	ret z			; $511e
	ld e,Interaction.state		; $511f
	ld a,$02		; $5121
	ld (de),a		; $5123
	ld e,$46		; $5124
	ld a,$1e		; $5126
	ld (de),a		; $5128
	ld a,$4d		; $5129
	call playSound		; $512b
	jp objectSetVisiblec1		; $512e
	call interactionDecCounter1		; $5131
	ret nz			; $5134
	ld l,$44		; $5135
	inc (hl)		; $5137
	ld c,$10		; $5138
	call objectUpdateSpeedZAndBounce		; $513a
	ret nc			; $513d
	ld e,Interaction.state		; $513e
	ld a,$04		; $5140
	ld (de),a		; $5142
	ld hl,$dd00		; $5143
	ld a,(hl)		; $5146
	or a			; $5147
	ret nz			; $5148
	ld (hl),$01		; $5149
	inc l			; $514b
	ld (hl),$29		; $514c
	call objectCopyPosition		; $514e
	ld e,$56		; $5151
	ld l,$16		; $5153
	ld a,(de)		; $5155
	ldi (hl),a		; $5156
	inc e			; $5157
	ld a,(de)		; $5158
	ld (hl),a		; $5159
	ld e,Interaction.state		; $515a
	ld a,$05		; $515c
	ld (de),a		; $515e
	ret			; $515f

interactionCode65:
	call returnIfScrollMode01Unset		; $5160
	call $5258		; $5163
	jp nz,interactionDelete		; $5166
	ld e,Interaction.state		; $5169
	ld a,(de)		; $516b
	rst_jumpTable			; $516c
	ld (hl),e		; $516d
	ld d,c			; $516e
	rst_jumpTable			; $516f
	ld d,c			; $5170
	inc d			; $5171
	ld d,d			; $5172
	ld a,$01		; $5173
	ld (de),a		; $5175
	call objectSetReservedBit1		; $5176
	ld e,Interaction.subid		; $5179
	ld a,(de)		; $517b
	or a			; $517c
	jr nz,_label_09_076	; $517d
	ld e,$46		; $517f
	ld a,$78		; $5181
	ld (de),a		; $5183
	ld a,$02		; $5184
	ld ($ff00+$70),a	; $5186
	ld a,$80		; $5188
	ld hl,$d000		; $518a
	call $51c0		; $518d
	ld hl,$d0a0		; $5190
	call $51c0		; $5193
	ld a,$0b		; $5196
	ld hl,$d400		; $5198
	call $51c0		; $519b
	ld hl,$d4a0		; $519e
	call $51c0		; $51a1
	xor a			; $51a4
	ld ($ff00+$70),a	; $51a5
	call getFreeInteractionSlot		; $51a7
	ret nz			; $51aa
	ld (hl),$65		; $51ab
	inc l			; $51ad
	ld (hl),$01		; $51ae
	call getFreeInteractionSlot		; $51b0
	ret nz			; $51b3
	ld (hl),$65		; $51b4
	inc l			; $51b6
	ld (hl),$02		; $51b7
	ret			; $51b9
_label_09_076:
	ld e,Interaction.state		; $51ba
	ld a,$02		; $51bc
	ld (de),a		; $51be
	ret			; $51bf
	ld b,$20		; $51c0
_label_09_077:
	ldi (hl),a		; $51c2
	dec b			; $51c3
	jr nz,_label_09_077	; $51c4
	ret			; $51c6
	xor a			; $51c7
	ld ($ccab),a		; $51c8
	ld a,$3c		; $51cb
	ld ($cd19),a		; $51cd
	call interactionDecCounter1		; $51d0
	ret nz			; $51d3
	ld (hl),$78		; $51d4
	ld a,$01		; $51d6
	ld ($ccab),a		; $51d8
	ld hl,$cfd0		; $51db
	inc (hl)		; $51de
	call $5261		; $51df
	call $545a		; $51e2
	call $52d9		; $51e5
	call $537e		; $51e8
	xor a			; $51eb
	ld ($ff00+$70),a	; $51ec
	ldh a,(<hActiveObject)	; $51ee
	ld d,a			; $51f0
	ld a,$70		; $51f1
	call playSound		; $51f3
	ld a,$0f		; $51f6
	ld ($cd18),a		; $51f8
	ld a,($cfd0)		; $51fb
	cp $09			; $51fe
	ret c			; $5200
	call $5258		; $5201
	jp nz,interactionDelete		; $5204
	ld a,$11		; $5207
	ld ($cc6a),a		; $5209
	ld a,$81		; $520c
	ld ($cc6b),a		; $520e
	jp interactionDelete		; $5211
	call $5258		; $5214
	jp nz,interactionDelete		; $5217
	ld a,($cfd0)		; $521a
	cp $09			; $521d
	jr z,_label_09_079	; $521f
	ld a,($cfd0)		; $5221
	ld c,$08		; $5224
	call multiplyAByC		; $5226
	ld a,l			; $5229
	add $10			; $522a
	ld b,a			; $522c
	ld hl,$d00b		; $522d
	ld a,(hl)		; $5230
	cp b			; $5231
	jr nc,_label_09_078	; $5232
	ld (hl),b		; $5234
_label_09_078:
	ld a,($cfd0)		; $5235
	ld b,a			; $5238
	ld a,$15		; $5239
	sub b			; $523b
	ld c,$08		; $523c
	call multiplyAByC		; $523e
	ld a,l			; $5241
	sub $0e			; $5242
	ld b,a			; $5244
	ld hl,$d00b		; $5245
	ld a,(hl)		; $5248
	cp b			; $5249
	ret c			; $524a
	ld (hl),b		; $524b
	ret			; $524c
_label_09_079:
	ld a,$08		; $524d
	call setScreenShakeCounter		; $524f
	ld a,$58		; $5252
	ld ($d00b),a		; $5254
	ret			; $5257
	ld a,($cc4c)		; $5258
	cp $c5			; $525b
	ret z			; $525d
	cp $c6			; $525e
	ret			; $5260
	ld a,$02		; $5261
	ld ($ff00+$70),a	; $5263
	ld a,($cd09)		; $5265
	cpl			; $5268
	inc a			; $5269
	swap a			; $526a
	rlca			; $526c
	ldh (<hFF8B),a	; $526d
	xor a			; $526f
	call $5293		; $5270
	ld a,$04		; $5273
	call $5293		; $5275
_label_09_080:
	ld a,$08		; $5278
	call $5293		; $527a
	ld a,$0c		; $527d
	call $5293		; $527f
	ld a,$10		; $5282
	call $5293		; $5284
_label_09_081:
	ld a,$14		; $5287
	call $5293		; $5289
_label_09_082:
	ld a,$18		; $528c
	call $5293		; $528e
	ld a,$1c		; $5291
	ld hl,$52a6		; $5293
	rst_addAToHl			; $5296
	ldi a,(hl)		; $5297
	ld d,(hl)		; $5298
	ld e,a			; $5299
	inc hl			; $529a
	ldi a,(hl)		; $529b
	ld h,(hl)		; $529c
	ld l,a			; $529d
	ldh a,(<hFF8B)	; $529e
	ld c,a			; $52a0
	ld b,$00		; $52a1
	add hl,bc		; $52a3
	jr _label_09_083		; $52a4
	jr nz,_label_09_080	; $52a6
	ret nz			; $52a8
	ret nc			; $52a9
	ld b,b			; $52aa
	ret nc			; $52ab
	ld ($ff00+$d0),a	; $52ac
	ld h,b			; $52ae
	ret nc			; $52af
	nop			; $52b0
	pop de			; $52b1
	add b			; $52b2
	ret nc			; $52b3
	jr nz,_label_09_081	; $52b4
	jr nz,_label_09_082	; $52b6
	ret nz			; $52b8
	call nc,$d440		; $52b9
	ld ($ff00+$d4),a	; $52bc
	ld h,b			; $52be
	call nc,$d500		; $52bf
	add b			; $52c2
	call nc,$d520		; $52c3
_label_09_083:
	ld b,$20		; $52c6
_label_09_084:
	ld a,(hl)		; $52c8
	ld (de),a		; $52c9
	inc de			; $52ca
	inc l			; $52cb
	ld a,l			; $52cc
	and $1f			; $52cd
	jr nz,_label_09_085	; $52cf
	ld a,l			; $52d1
	sub $20			; $52d2
	ld l,a			; $52d4
_label_09_085:
	dec b			; $52d5
	jr nz,_label_09_084	; $52d6
	ret			; $52d8
	push de			; $52d9
	ld a,($cfd0)		; $52da
	add a			; $52dd
	ld hl,$5326		; $52de
	rst_addDoubleIndex			; $52e1
	ldi a,(hl)		; $52e2
	ld d,(hl)		; $52e3
	ld e,a			; $52e4
	inc hl			; $52e5
	push hl			; $52e6
	ld hl,$d400		; $52e7
	ld b,$05		; $52ea
	ld c,$02		; $52ec
	call queueDmaTransfer		; $52ee
	pop hl			; $52f1
	ldi a,(hl)		; $52f2
	ld d,(hl)		; $52f3
	ld e,a			; $52f4
	ld hl,$d000		; $52f5
	ld b,$05		; $52f8
	ld c,$02		; $52fa
	call queueDmaTransfer		; $52fc
	ld a,($cfd0)		; $52ff
	add a			; $5302
	ld hl,$5352		; $5303
	rst_addDoubleIndex			; $5306
	ldi a,(hl)		; $5307
	ld d,(hl)		; $5308
	ld e,a			; $5309
	inc hl			; $530a
	push hl			; $530b
	ld hl,$d460		; $530c
	ld b,$05		; $530f
	ld c,$02		; $5311
	call queueDmaTransfer		; $5313
	pop hl			; $5316
	ldi a,(hl)		; $5317
	ld d,(hl)		; $5318
	ld e,a			; $5319
	ld hl,$d060		; $531a
	ld b,$05		; $531d
	ld c,$02		; $531f
	call queueDmaTransfer		; $5321
	pop de			; $5324
	ret			; $5325
	ld bc,$0098		; $5326
	sbc b			; $5329
	ld bc,$0098		; $532a
	sbc b			; $532d
	ld hl,$2098		; $532e
	sbc b			; $5331
	ld b,c			; $5332
	sbc b			; $5333
	ld b,b			; $5334
	sbc b			; $5335
	ld h,c			; $5336
	sbc b			; $5337
	ld h,b			; $5338
	sbc b			; $5339
	add c			; $533a
	sbc b			; $533b
	add b			; $533c
	sbc b			; $533d
	and c			; $533e
	sbc b			; $533f
	and b			; $5340
	sbc b			; $5341
	pop bc			; $5342
	sbc b			; $5343
	ret nz			; $5344
	sbc b			; $5345
	pop hl			; $5346
	sbc b			; $5347
	ldh (<hActiveFileSlot),a	; $5348
	ld bc,$0099		; $534a
	sbc c			; $534d
	ld hl,objectCenterOnTile		; $534e
	sbc c			; $5351
	ld h,c			; $5352
	sbc d			; $5353
	ld h,b			; $5354
	sbc d			; $5355
	ld h,c			; $5356
	sbc d			; $5357
	ld h,b			; $5358
	sbc d			; $5359
	ld b,c			; $535a
	sbc d			; $535b
	ld b,b			; $535c
	sbc d			; $535d
	ld hl,$209a		; $535e
	sbc d			; $5361
	ld bc,$009a		; $5362
	sbc d			; $5365
	pop hl			; $5366
	sbc c			; $5367
	ldh (<hLcdInterruptBehaviour),a	; $5368
	pop bc			; $536a
	sbc c			; $536b
	ret nz			; $536c
	sbc c			; $536d
	and c			; $536e
	sbc c			; $536f
	and b			; $5370
	sbc c			; $5371
	add c			; $5372
	sbc c			; $5373
	add b			; $5374
	sbc c			; $5375
	ld h,c			; $5376
	sbc c			; $5377
	ld h,b			; $5378
	sbc c			; $5379
	ld b,c			; $537a
	sbc c			; $537b
	ld b,b			; $537c
	sbc c			; $537d
	ld a,($cfd0)		; $537e
	or a			; $5381
	ret z			; $5382
	bit 0,a			; $5383
	jr nz,_label_09_086	; $5385
	srl a			; $5387
	swap a			; $5389
	ld l,a			; $538b
	ld a,$0f		; $538c
	call $53bb		; $538e
	ld a,($cfd0)		; $5391
	srl a			; $5394
	ld b,a			; $5396
	ld a,$0a		; $5397
	sub b			; $5399
	swap a			; $539a
	ld l,a			; $539c
	ld a,$0f		; $539d
	jr _label_09_087		; $539f
_label_09_086:
	inc a			; $53a1
	srl a			; $53a2
	swap a			; $53a4
	ld l,a			; $53a6
	ld a,$0c		; $53a7
	call $53bb		; $53a9
	ld a,($cfd0)		; $53ac
	inc a			; $53af
	srl a			; $53b0
	ld b,a			; $53b2
	ld a,$0a		; $53b3
	sub b			; $53b5
	swap a			; $53b6
	ld l,a			; $53b8
	ld a,$03		; $53b9
_label_09_087:
	ld e,a			; $53bb
	ld b,$10		; $53bc
	ld h,$ce		; $53be
_label_09_088:
	ld a,(hl)		; $53c0
	or e			; $53c1
	ldi (hl),a		; $53c2
	dec b			; $53c3
	jr nz,_label_09_088	; $53c4
	ret			; $53c6
	ld a,($cfd0)		; $53c7
	or a			; $53ca
	ret z			; $53cb
	bit 0,a			; $53cc
	ret nz			; $53ce
	srl a			; $53cf
	swap a			; $53d1
	ld l,a			; $53d3
	ld a,$b0		; $53d4
	call $53e7		; $53d6
	ld a,($cfd0)		; $53d9
	srl a			; $53dc
	ld b,a			; $53de
	ld a,$0a		; $53df
	sub b			; $53e1
	swap a			; $53e2
	ld l,a			; $53e4
	ld a,$b2		; $53e5
	ld b,$10		; $53e7
	ld h,$cf		; $53e9
_label_09_089:
	ldi (hl),a		; $53eb
	dec b			; $53ec
	jr nz,_label_09_089	; $53ed
	ret			; $53ef

;;
; $02: D6 wall-closing room
; @addr{53f0}
roomTileChangesAfterLoad02_body:
	call $537e		; $53f0
	call $53c7		; $53f3
	ld hl,$d800		; $53f6
	ld de,$d0c0		; $53f9
	call $5440		; $53fc
	ld hl,$d820		; $53ff
	ld de,$d0e0		; $5402
	call $5440		; $5405
	ld hl,$dc00		; $5408
	ld de,$d4c0		; $540b
	call $5440		; $540e
	ld hl,$dc20		; $5411
	ld de,$d4e0		; $5414
	call $5440		; $5417
	ld hl,$da80		; $541a
	ld de,$d100		; $541d
	call $5440		; $5420
	ld hl,$daa0		; $5423
	ld de,$d120		; $5426
	call $5440		; $5429
	ld hl,$de80		; $542c
	ld de,$d500		; $542f
	call $5440		; $5432
	ld hl,$dea0		; $5435
	ld de,$d520		; $5438
	call $5440		; $543b
	jr _label_09_090		; $543e
	ld a,$03		; $5440
	ld ($ff00+$70),a	; $5442
	push de			; $5444
	ld de,$cd40		; $5445
	ld b,$20		; $5448
	call copyMemory		; $544a
	pop de			; $544d
	ld a,$02		; $544e
	ld ($ff00+$70),a	; $5450
	ld hl,$cd40		; $5452
	ld b,$20		; $5455
	jp copyMemory		; $5457
_label_09_090:
	ld a,($cfd0)		; $545a
	or a			; $545d
	ret z			; $545e
	push de			; $545f
	push hl			; $5460
	ld hl,$d0c0		; $5461
	ld de,$cd40		; $5464
	ld b,$40		; $5467
	ld c,$02		; $5469
	call $553a		; $546b
	ld a,($cfd0)		; $546e
	ld hl,$5544		; $5471
	rst_addDoubleIndex			; $5474
	ldi a,(hl)		; $5475
	ld d,(hl)		; $5476
	ld e,a			; $5477
	ld hl,$cd40		; $5478
	ld b,$40		; $547b
	ld c,$03		; $547d
	call $553a		; $547f
	ld hl,$d100		; $5482
	ld de,$cd40		; $5485
	ld b,$40		; $5488
	ld c,$02		; $548a
	call $553a		; $548c
	ld a,($cfd0)		; $548f
	ld hl,$5558		; $5492
	rst_addDoubleIndex			; $5495
	ldi a,(hl)		; $5496
	ld d,(hl)		; $5497
	ld e,a			; $5498
	ld hl,$cd40		; $5499
	ld b,$40		; $549c
	ld c,$03		; $549e
	call $553a		; $54a0
	ld hl,$d4c0		; $54a3
	ld de,$cd40		; $54a6
	ld b,$40		; $54a9
	ld c,$02		; $54ab
	call $553a		; $54ad
	ld a,($cfd0)		; $54b0
	ld hl,$5544		; $54b3
	rst_addDoubleIndex			; $54b6
	ldi a,(hl)		; $54b7
	ld e,a			; $54b8
	ld a,(hl)		; $54b9
	add $04			; $54ba
	ld d,a			; $54bc
	ld hl,$cd40		; $54bd
	ld b,$40		; $54c0
	ld c,$03		; $54c2
	call $553a		; $54c4
	ld hl,$d500		; $54c7
	ld de,$cd40		; $54ca
	ld b,$40		; $54cd
	ld c,$02		; $54cf
	call $553a		; $54d1
	ld a,($cfd0)		; $54d4
	ld hl,$5558		; $54d7
	rst_addDoubleIndex			; $54da
	ldi a,(hl)		; $54db
	ld e,a			; $54dc
	ld a,(hl)		; $54dd
	add $04			; $54de
	ld d,a			; $54e0
	ld hl,$cd40		; $54e1
	ld b,$40		; $54e4
	ld c,$03		; $54e6
	call $553a		; $54e8
	ld a,$03		; $54eb
	ld ($ff00+$70),a	; $54ed
	ld hl,$d800		; $54ef
	ld a,$80		; $54f2
	call $552a		; $54f4
	ld hl,$dc00		; $54f7
	ld a,$0b		; $54fa
	call $552a		; $54fc
	ld a,($cfd0)		; $54ff
	ld c,a			; $5502
	ld b,$00		; $5503
	ld a,$16		; $5505
	sub c			; $5507
	ld c,a			; $5508
	ld a,$20		; $5509
	call multiplyAByC		; $550b
	ld c,l			; $550e
	ld b,h			; $550f
	ld hl,$d800		; $5510
	add hl,bc		; $5513
	ld a,$80		; $5514
	push hl			; $5516
	call $552a		; $5517
	pop hl			; $551a
	ld bc,$0400		; $551b
	add hl,bc		; $551e
	ld a,$0b		; $551f
	call $552a		; $5521
	xor a			; $5524
	ld ($ff00+$70),a	; $5525
	pop hl			; $5527
	pop de			; $5528
	ret			; $5529
	ld e,a			; $552a
	ld a,($cfd0)		; $552b
	ld c,a			; $552e
	ld a,e			; $552f
_label_09_091:
	ld b,$20		; $5530
_label_09_092:
	ldi (hl),a		; $5532
	dec b			; $5533
	jr nz,_label_09_092	; $5534
	dec c			; $5536
	jr nz,_label_09_091	; $5537
	ret			; $5539
	ld a,c			; $553a
	ld ($ff00+$70),a	; $553b
	call copyMemory		; $553d
	xor a			; $5540
	ld ($ff00+$70),a	; $5541
	ret			; $5543
	nop			; $5544
	ret c			; $5545
	jr nz,-$28		; $5546
	ld b,b			; $5548
	ret c			; $5549
	ld h,b			; $554a
	ret c			; $554b
	add b			; $554c
	ret c			; $554d
	and b			; $554e
	ret c			; $554f
	ret nz			; $5550
	ret c			; $5551
	ld ($ff00+$d8),a	; $5552
	nop			; $5554
	reti			; $5555
	jr nz,-$27		; $5556
	add b			; $5558
	jp c,$da60		; $5559
	ld b,b			; $555c
	jp c,$da20		; $555d
	nop			; $5560
	jp c,$d9e0		; $5561
	ret nz			; $5564
	reti			; $5565
	and b			; $5566
	reti			; $5567
	add b			; $5568
	reti			; $5569
	ld h,b			; $556a
	reti			; $556b

interactionCode66:
	ld e,Interaction.subid		; $556c
	ld a,(de)		; $556e
	rst_jumpTable			; $556f
.DB $db				; $5570
	ld d,l			; $5571
	ld (hl),h		; $5572
	ld d,l			; $5573
	ld e,Interaction.state		; $5574
	ld a,(de)		; $5576
	rst_jumpTable			; $5577
	ld a,h			; $5578
	ld d,l			; $5579
	xor b			; $557a
	ld d,l			; $557b
	ld a,$01		; $557c
	ld (de),a		; $557e
	call interactionInitGraphics		; $557f
	ld a,$27		; $5582
	call objectMimicBgTile		; $5584
	ld a,$06		; $5587
	call objectSetCollideRadius		; $5589
	ld l,$50		; $558c
	ld (hl),$28		; $558e
	ld l,$46		; $5590
	ld (hl),$10		; $5592
	inc l			; $5594
	ld (hl),$02		; $5595
	ld l,$4b		; $5597
	dec (hl)		; $5599
	dec (hl)		; $559a
	push de			; $559b
	call $55c8		; $559c
	pop de			; $559f
	ld a,$71		; $55a0
	call playSound		; $55a2
	jp objectSetVisible82		; $55a5
	call objectApplySpeed		; $55a8
	call objectPreventLinkFromPassing		; $55ab
	call interactionDecCounter1		; $55ae
	ret nz			; $55b1
	ld (hl),$10		; $55b2
	inc l			; $55b4
	dec (hl)		; $55b5
	jr z,_label_09_093	; $55b6
	call interactionCheckAdjacentTileIsSolid		; $55b8
	ret z			; $55bb
_label_09_093:
	call objectGetShortPosition		; $55bc
	ld c,a			; $55bf
	ld a,$27		; $55c0
	call setTile		; $55c2
	jp interactionDelete		; $55c5
	call objectGetShortPosition		; $55c8
	ld c,a			; $55cb
	ld a,$03		; $55cc
	ld ($ff00+$70),a	; $55ce
	ld b,$df		; $55d0
	ld a,(bc)		; $55d2
	ld b,a			; $55d3
	xor a			; $55d4
	ld ($ff00+$70),a	; $55d5
	ld a,b			; $55d7
	jp setTile		; $55d8
	ld e,Interaction.state		; $55db
	ld a,(de)		; $55dd
	rst_jumpTable			; $55de
	push hl			; $55df
	ld d,l			; $55e0
	jr _label_09_096		; $55e1
	ld (hl),l		; $55e3
	ld d,(hl)		; $55e4
	ld e,Interaction.state		; $55e5
	ld a,$01		; $55e7
	ld (de),a		; $55e9
	ld a,$03		; $55ea
	ld ($ff00+$70),a	; $55ec
	ld b,$df		; $55ee
	ld hl,$5610		; $55f0
	ld a,$a3		; $55f3
_label_09_094:
	ld c,(hl)		; $55f5
	inc hl			; $55f6
	ld (bc),a		; $55f7
	dec e			; $55f8
	jr nz,_label_09_094	; $55f9
	ld h,b			; $55fb
	ld l,$17		; $55fc
	ld (hl),$a0		; $55fe
	ld l,$3b		; $5600
	ld (hl),$a0		; $5602
	ld l,$5b		; $5604
	ld (hl),$a0		; $5606
	ld l,$57		; $5608
	ld (hl),$a2		; $560a
	xor a			; $560c
	ld ($ff00+$70),a	; $560d
	ret			; $560f
	dec (hl)		; $5610
	scf			; $5611
	add hl,sp		; $5612
	ld d,l			; $5613
	ld e,c			; $5614
	ld (hl),l		; $5615
	ld (hl),a		; $5616
	ld a,c			; $5617
	ld hl,$ccba		; $5618
	bit 4,(hl)		; $561b
	jr nz,_label_09_095	; $561d
	bit 0,(hl)		; $561f
	jr z,_label_09_095	; $5621
	set 4,(hl)		; $5623
	ld c,$32		; $5625
	call nz,$5694		; $5627
_label_09_095:
	ld hl,$ccba		; $562a
	bit 5,(hl)		; $562d
	jr nz,_label_09_097	; $562f
	bit 1,(hl)		; $5631
	jr z,_label_09_097	; $5633
	set 5,(hl)		; $5635
	ld c,$52		; $5637
_label_09_096:
	call nz,$5694		; $5639
_label_09_097:
	ld hl,$ccba		; $563c
	bit 6,(hl)		; $563f
	jr nz,_label_09_098	; $5641
	bit 2,(hl)		; $5643
	jr z,_label_09_098	; $5645
	set 6,(hl)		; $5647
	ld c,$95		; $5649
	call nz,$56a5		; $564b
_label_09_098:
	ld hl,$ccba		; $564e
	bit 7,(hl)		; $5651
	jr nz,_label_09_099	; $5653
	bit 3,(hl)		; $5655
	jr z,_label_09_099	; $5657
	set 7,(hl)		; $5659
	ld c,$97		; $565b
	call nz,$56a5		; $565d
_label_09_099:
	ld a,($ccba)		; $5660
	inc a			; $5663
	ret nz			; $5664
	call getThisRoomFlags		; $5665
	bit 5,(hl)		; $5668
	jp nz,interactionDelete		; $566a
	ld e,$46		; $566d
	ld a,$3c		; $566f
	ld (de),a		; $5671
	jp interactionIncState		; $5672
	call interactionDecCounter1		; $5675
	ret nz			; $5678
	ld a,$a3		; $5679
	call findTileInRoom		; $567b
	jr nz,_label_09_100	; $567e
	ld a,$5a		; $5680
	call playSound		; $5682
	jp interactionDelete		; $5685
_label_09_100:
	ld bc,$3001		; $5688
	call createTreasure		; $568b
	call objectCopyPosition		; $568e
	jp interactionDelete		; $5691
	ld b,$cf		; $5694
_label_09_101:
	ld a,(bc)		; $5696
	cp $27			; $5697
	ld e,$18		; $5699
	call z,$56b8		; $569b
	inc c			; $569e
	ld a,c			; $569f
	and $0f			; $56a0
	ret z			; $56a2
	jr _label_09_101		; $56a3
	ld b,$cf		; $56a5
_label_09_102:
	ld a,(bc)		; $56a7
	cp $27			; $56a8
	ld e,$10		; $56aa
	call z,$56b8		; $56ac
	ld a,c			; $56af
	sub $10			; $56b0
	ld c,a			; $56b2
	and $f0			; $56b3
	ret z			; $56b5
	jr _label_09_102		; $56b6
	call getFreeInteractionSlot		; $56b8
	ret nz			; $56bb
	ld (hl),$66		; $56bc
	inc l			; $56be
	ld (hl),$01		; $56bf
	push bc			; $56c1
	ld l,$4b		; $56c2
	call setShortPosition_paramC		; $56c4
	pop bc			; $56c7
	ld l,$49		; $56c8
	ld (hl),e		; $56ca
	ret			; $56cb

interactionCode67:
	ld e,Interaction.state		; $56cc
	ld a,(de)		; $56ce
	rst_jumpTable			; $56cf
	jp c,$ed56		; $56d0
	ld d,(hl)		; $56d3
	scf			; $56d4
	ld d,a			; $56d5
	ld c,d			; $56d6
	ld d,a			; $56d7
.DB $ec				; $56d8
	ld d,a			; $56d9
	call getThisRoomFlags		; $56da
	bit 5,(hl)		; $56dd
	jp nz,interactionDelete		; $56df
	ld a,$0a		; $56e2
	call objectSetCollideRadius		; $56e4
	ld l,$44		; $56e7
	inc (hl)		; $56e9
	jp interactionInitGraphics		; $56ea
	call objectCheckCollidedWithLink_notDead		; $56ed
	ret nc			; $56f0
	call getRandomNumber		; $56f1
	and $0f			; $56f4
	ld hl,$5727		; $56f6
	rst_addAToHl			; $56f9
	ld a,(hl)		; $56fa
	ld e,$43		; $56fb
	ld (de),a		; $56fd
	ld hl,$571f		; $56fe
	rst_addDoubleIndex			; $5701
	ldi a,(hl)		; $5702
	ld h,(hl)		; $5703
	ld l,a			; $5704
	call interactionSetScript		; $5705
	call interactionIncState		; $5708
	ld a,$81		; $570b
	ld ($cca4),a		; $570d
	call objectSetVisible82		; $5710
	call setCameraFocusedObject		; $5713
	call $57f3		; $5716
	ld e,$79		; $5719
	ld (de),a		; $571b
	jp objectCreatePuff		; $571c
	ld (hl),c		; $571f
	ld h,l			; $5720
	and c			; $5721
	ld h,l			; $5722
	cp (hl)			; $5723
	ld h,l			; $5724
	rst $20			; $5725
	ld h,l			; $5726
	nop			; $5727
	ld bc,$0302		; $5728
	nop			; $572b
	ld bc,$0302		; $572c
	nop			; $572f
	ld bc,$0302		; $5730
	nop			; $5733
	ld bc,$0302		; $5734
	ld a,(wFrameCounter)		; $5737
	rrca			; $573a
	jr nc,_label_09_103	; $573b
	ld a,$80		; $573d
	ld h,d			; $573f
	ld l,$5a		; $5740
	xor (hl)		; $5742
	ld (hl),a		; $5743
_label_09_103:
	call interactionAnimate		; $5744
	jp interactionRunScript		; $5747
	ld e,$5a		; $574a
	xor a			; $574c
	ld (de),a		; $574d
	call $57f3		; $574e
	ld b,a			; $5751
	ld e,$79		; $5752
	ld a,(de)		; $5754
	cp b			; $5755
	ret z			; $5756
	ld e,$43		; $5757
	ld a,(de)		; $5759
	ld hl,$579a		; $575a
	rst_addDoubleIndex			; $575d
	ldi a,(hl)		; $575e
	ld h,(hl)		; $575f
	ld l,a			; $5760
	ld e,$78		; $5761
	ld a,(de)		; $5763
	rst_addAToHl			; $5764
	ld a,(hl)		; $5765
	cp b			; $5766
	jr nz,_label_09_105	; $5767
	cp $1c			; $5769
	jr z,_label_09_104	; $576b
	ld c,a			; $576d
	ld a,(de)		; $576e
	inc a			; $576f
	ld (de),a		; $5770
	ld a,b			; $5771
	ld e,$79		; $5772
	ld (de),a		; $5774
	ld a,$a2		; $5775
	call setTile		; $5777
	ld a,$62		; $577a
	jp playSound		; $577c
_label_09_104:
	ld c,$1c		; $577f
	call $5775		; $5781
	call interactionIncState		; $5784
	ld a,$4d		; $5787
	call playSound		; $5789
	ld hl,$660c		; $578c
	jp interactionSetScript		; $578f
_label_09_105:
	ld a,$5a		; $5792
	call playSound		; $5794
	jp interactionDelete		; $5797
	and d			; $579a
	ld d,a			; $579b
	or e			; $579c
	ld d,a			; $579d
	jp nz,$d757		; $579e
	ld d,a			; $57a1
	sbc h			; $57a2
	adc h			; $57a3
	ld a,h			; $57a4
	ld a,l			; $57a5
	ld l,l			; $57a6
	ld l,h			; $57a7
	ld l,e			; $57a8
	ld l,d			; $57a9
	ld e,d			; $57aa
	ld c,d			; $57ab
	ldd a,(hl)		; $57ac
	ldi a,(hl)		; $57ad
	ld a,(de)		; $57ae
	dec de			; $57af
	dec hl			; $57b0
	inc l			; $57b1
	inc e			; $57b2
	sbc h			; $57b3
	adc h			; $57b4
	ld a,h			; $57b5
	ld a,l			; $57b6
	ld l,l			; $57b7
	ld e,l			; $57b8
	ld c,l			; $57b9
	ld c,h			; $57ba
	ld c,e			; $57bb
	ld c,d			; $57bc
	ldd a,(hl)		; $57bd
	ldi a,(hl)		; $57be
	ld a,(de)		; $57bf
	dec de			; $57c0
	inc e			; $57c1
	sbc h			; $57c2
	sbc e			; $57c3
	sbc d			; $57c4
	adc d			; $57c5
	adc e			; $57c6
	adc h			; $57c7
	adc l			; $57c8
	ld a,l			; $57c9
	ld a,h			; $57ca
	ld a,e			; $57cb
	ld a,d			; $57cc
	ld l,d			; $57cd
	ld e,d			; $57ce
	ld c,d			; $57cf
	ldd a,(hl)		; $57d0
	ldi a,(hl)		; $57d1
	dec hl			; $57d2
	inc l			; $57d3
	dec l			; $57d4
	dec e			; $57d5
	inc e			; $57d6
	sbc h			; $57d7
	adc h			; $57d8
	ld a,h			; $57d9
	ld l,h			; $57da
	ld e,h			; $57db
	ld e,e			; $57dc
	ld l,e			; $57dd
	ld a,e			; $57de
	ld a,h			; $57df
	ld a,l			; $57e0
	ld l,l			; $57e1
	ld l,h			; $57e2
	ld l,e			; $57e3
	ld l,d			; $57e4
	ld e,d			; $57e5
	ld c,d			; $57e6
	ldd a,(hl)		; $57e7
	ldi a,(hl)		; $57e8
	ld a,(de)		; $57e9
	dec de			; $57ea
	inc e			; $57eb
	call interactionRunScript		; $57ec
	jp c,interactionDelete		; $57ef
	ret			; $57f2
	ld hl,$d00b		; $57f3
	ldi a,(hl)		; $57f6
	add $04			; $57f7
	and $f0			; $57f9
	ld b,a			; $57fb
	inc l			; $57fc
	ld a,(hl)		; $57fd
	swap a			; $57fe
	and $0f			; $5800
	or b			; $5802
	ret			; $5803

interactionCode68:
	ld e,Interaction.state		; $5804
	ld a,(de)		; $5806
	rst_jumpTable			; $5807
	stop			; $5808
	ld e,b			; $5809
	ld e,$58		; $580a
	ld e,d			; $580c
	ld e,b			; $580d
	sub h			; $580e
	ld e,b			; $580f
	ld a,$01		; $5810
	ld (de),a		; $5812
	call interactionInitGraphics		; $5813
	ld a,$06		; $5816
	call objectSetCollideRadius		; $5818
	jp objectSetVisiblec2		; $581b
	ld c,$20		; $581e
	call objectUpdateSpeedZ_paramC		; $5820
	ld a,($cc77)		; $5823
	or a			; $5826
	jr nz,_label_09_106	; $5827
	ld a,($cc48)		; $5829
	rrca			; $582c
	call nc,objectPushLinkAwayOnCollision		; $582d
_label_09_106:
	call objectAddToGrabbableObjectBuffer		; $5830
_label_09_107:
	call objectCheckIsOnHazard		; $5833
	ret nc			; $5836
	bit 6,a			; $5837
	jr nz,_label_09_108	; $5839
	dec a			; $583b
	jp z,objectReplaceWithSplash		; $583c
	jp objectReplaceWithFallingDownHoleInteraction		; $583f
_label_09_108:
	call getThisRoomFlags		; $5842
	bit 6,(hl)		; $5845
	jp nz,objectReplaceWithFallingDownHoleInteraction		; $5847
	call objectSetInvisible		; $584a
	ld l,$44		; $584d
	ld (hl),$03		; $584f
	ld l,$46		; $5851
	ld (hl),$1e		; $5853
	ld b,$0f		; $5855
	jp objectCreateInteractionWithSubid00		; $5857
	ld e,Interaction.state2		; $585a
	ld a,(de)		; $585c
	rst_jumpTable			; $585d
	ld h,(hl)		; $585e
	ld e,b			; $585f
	ld (hl),b		; $5860
	ld e,b			; $5861
	ld (hl),c		; $5862
	ld e,b			; $5863
	add (hl)		; $5864
	ld e,b			; $5865
	ld h,d			; $5866
	ld l,e			; $5867
	inc (hl)		; $5868
	xor a			; $5869
	ld (wLinkGrabState2),a		; $586a
	jp objectSetVisible81		; $586d
	ret			; $5870
	call objectCheckWithinRoomBoundary		; $5871
	jp nc,interactionDelete		; $5874
	call objectSetVisiblec1		; $5877
	ld h,d			; $587a
	ld l,$40		; $587b
	res 1,(hl)		; $587d
	ld e,$4f		; $587f
	ld a,(de)		; $5881
	or a			; $5882
	jr z,_label_09_107	; $5883
	ret			; $5885
	ld h,d			; $5886
	ld l,$40		; $5887
	res 1,(hl)		; $5889
	ld l,$45		; $588b
	xor a			; $588d
	ldd (hl),a		; $588e
	inc a			; $588f
	ld (hl),a		; $5890
	jp objectSetVisible82		; $5891
	call interactionDecCounter1		; $5894
	ret nz			; $5897
	ld a,($d004)		; $5898
	cp $01			; $589b
	jr nz,_label_09_109	; $589d
	ld a,($cc34)		; $589f
	or a			; $58a2
	jr nz,_label_09_109	; $58a3
	ld a,($cc48)		; $58a5
	cp $d0			; $58a8
	jr nz,_label_09_109	; $58aa
	call resetLinkInvincibility		; $58ac
	ld a,$80		; $58af
	ld ($cc02),a		; $58b1
	ld ($ccaa),a		; $58b4
	ld ($ccab),a		; $58b7
	call getThisRoomFlags		; $58ba
	set 6,(hl)		; $58bd
	call $58e4		; $58bf
	ldh a,(<hActiveObject)	; $58c2
	ld d,a			; $58c4
	ld a,($cc57)		; $58c5
	dec a			; $58c8
	ld ($cc57),a		; $58c9
	call getActiveRoomFromDungeonMapPosition		; $58cc
	ld ($cc64),a		; $58cf
	ld a,$85		; $58d2
	ld ($cc63),a		; $58d4
	ld a,$0f		; $58d7
	ld ($cc65),a		; $58d9
	ld a,$03		; $58dc
	ld ($cc67),a		; $58de
_label_09_109:
	jp interactionDelete		; $58e1
	call objectGetTileAtPosition		; $58e4
	dec h			; $58e7
	ld b,l			; $58e8
	ld a,($ccb4)		; $58e9
	cp $d0			; $58ec
	ld a,($ccb3)		; $58ee
	jr nz,_label_09_111	; $58f1
	ld a,b			; $58f3
	sub $10			; $58f4
	call $5907		; $58f6
	jr z,_label_09_110	; $58f9
	ld a,b			; $58fb
	inc a			; $58fc
	call $5907		; $58fd
	jr z,_label_09_110	; $5900
	ld a,b			; $5902
	add $10			; $5903
	jr _label_09_111		; $5905
	ld l,a			; $5907
	ld a,(hl)		; $5908
	or a			; $5909
	ret			; $590a
_label_09_110:
	ld a,l			; $590b
_label_09_111:
	ld ($cfd0),a		; $590c
	ld a,($cc4c)		; $590f
	cp $7f			; $5912
	jr nz,_label_09_112	; $5914
	ld b,$27		; $5916
_label_09_112:
	ld a,b			; $5918
	ld ($cc66),a		; $5919
	ret			; $591c

interactionCode69:
	ld e,Interaction.subid		; $591d
	ld a,(de)		; $591f
	rst_jumpTable			; $5920
	dec hl			; $5921
	ld e,c			; $5922
	dec a			; $5923
	ld e,d			; $5924
	add (hl)		; $5925
	ld e,d			; $5926
	sbc a			; $5927
	ld e,d			; $5928
	call z,objectGetAngleTowardLink		; $5929
	ld b,h			; $592c
	ld a,(de)		; $592d
	rst_jumpTable			; $592e
	scf			; $592f
	ld e,c			; $5930
	sbc l			; $5931
	ld e,c			; $5932
	ret nz			; $5933
	ld e,c			; $5934
.DB $ec				; $5935
	ld e,c			; $5936
	ld e,Interaction.state2		; $5937
	ld a,(de)		; $5939
	rst_jumpTable			; $593a
	ccf			; $593b
	ld e,c			; $593c
	ld a,d			; $593d
	ld e,c			; $593e
	call getThisRoomFlags		; $593f
	bit 6,(hl)		; $5942
	jp nz,interactionDelete		; $5944
	ld e,$4d		; $5947
	ld a,(de)		; $5949
	ld e,$43		; $594a
	ld (de),a		; $594c
	ld hl,$5976		; $594d
	rst_addAToHl			; $5950
	ld b,(hl)		; $5951
	call getThisRoomFlags		; $5952
	ld l,b			; $5955
	bit 6,(hl)		; $5956
	jp z,interactionDelete		; $5958
	call getThisRoomFlags		; $595b
	set 6,(hl)		; $595e
	ld e,Interaction.state2		; $5960
	ld a,$01		; $5962
	ld (de),a		; $5964
	ld a,$f0		; $5965
	call playSound		; $5967
	ld a,$ff		; $596a
	ld (wActiveMusic),a		; $596c
	ld a,$80		; $596f
	ld ($cca4),a		; $5971
	jr _label_09_113		; $5974
	ld a,(hl)		; $5976
	ld a,a			; $5977
	adc b			; $5978
	adc c			; $5979
_label_09_113:
	call $5ae0		; $597a
	ld a,($c4ab)		; $597d
	or a			; $5980
	ret nz			; $5981
	ld e,Interaction.state		; $5982
	ld a,$01		; $5984
	ld (de),a		; $5986
	xor a			; $5987
	inc e			; $5988
	ld (de),a		; $5989
	call getFreeInteractionSlot		; $598a
	jp nz,interactionDelete		; $598d
	ld (hl),$69		; $5990
	inc l			; $5992
	ld (hl),$01		; $5993
	ld e,$4b		; $5995
	ld a,(de)		; $5997
	ld l,$4b		; $5998
	jp setShortPosition		; $599a
	ld a,($cfc0)		; $599d
	inc a			; $59a0
	ret nz			; $59a1
	ld e,Interaction.state		; $59a2
	ld a,$02		; $59a4
	ld (de),a		; $59a6
	ld e,$43		; $59a7
	ld a,(de)		; $59a9
	ld hl,$5b0d		; $59aa
	rst_addDoubleIndex			; $59ad
	ld e,$58		; $59ae
	ldi a,(hl)		; $59b0
	ld (de),a		; $59b1
	inc e			; $59b2
	ld a,(hl)		; $59b3
	ld (de),a		; $59b4
	ld h,d			; $59b5
	ld l,$46		; $59b6
	ld (hl),$14		; $59b8
	inc l			; $59ba
	ld (hl),$03		; $59bb
	call fastFadeoutToWhite		; $59bd
	ld a,$3c		; $59c0
	call setScreenShakeCounter		; $59c2
	call interactionDecCounter1		; $59c5
	ret nz			; $59c8
	ld (hl),$14		; $59c9
	inc l			; $59cb
	dec (hl)		; $59cc
	jp nz,fastFadeoutToWhite		; $59cd
	ld l,$44		; $59d0
	inc (hl)		; $59d2
	call clearPaletteFadeVariablesAndRefreshPalettes		; $59d3
	call getFreeInteractionSlot		; $59d6
	jr nz,_label_09_114	; $59d9
	ld (hl),$69		; $59db
	inc l			; $59dd
	ld (hl),$04		; $59de
	ld e,$58		; $59e0
	ld l,e			; $59e2
	ld a,(de)		; $59e3
	ldi (hl),a		; $59e4
	inc e			; $59e5
	ld a,(de)		; $59e6
	ld (hl),a		; $59e7
	ld l,$46		; $59e8
	ld (hl),$84		; $59ea
_label_09_114:
	ld a,$3c		; $59ec
	call setScreenShakeCounter		; $59ee
	ld a,($c4ab)		; $59f1
	or a			; $59f4
	ret nz			; $59f5
	call interactionDecCounter1		; $59f6
	ret nz			; $59f9
	ld (hl),$08		; $59fa
	ld a,$7a		; $59fc
	call playSound		; $59fe
	ld b,$d6		; $5a01
	call $5af7		; $5a03
	ret nz			; $5a06
	jp interactionDelete		; $5a07
	ld a,($cc57)		; $5a0a
	inc a			; $5a0d
	ld ($cc57),a		; $5a0e
	call getActiveRoomFromDungeonMapPosition		; $5a11
	ld ($cc64),a		; $5a14
	ld a,($cfd0)		; $5a17
	ld ($cc66),a		; $5a1a
	ld a,($cc49)		; $5a1d
	or $80			; $5a20
	ld ($cc63),a		; $5a22
	xor a			; $5a25
	ld ($cc65),a		; $5a26
	ld a,$03		; $5a29
	ld ($cc67),a		; $5a2b
	call getThisRoomFlags		; $5a2e
	res 4,(hl)		; $5a31
	xor a			; $5a33
	ld ($cca4),a		; $5a34
	ld ($cc02),a		; $5a37
	jp interactionDelete		; $5a3a
	ld e,Interaction.state		; $5a3d
	ld a,(de)		; $5a3f
	rst_jumpTable			; $5a40
	ld b,l			; $5a41
	ld e,d			; $5a42
	ld h,h			; $5a43
	ld e,d			; $5a44
	ld a,$01		; $5a45
	ld (de),a		; $5a47
	call interactionInitGraphics		; $5a48
	call objectGetZAboveScreen		; $5a4b
	ld e,$4f		; $5a4e
	ld (de),a		; $5a50
	call objectSetVisiblec0		; $5a51
	call getFreeInteractionSlot		; $5a54
	ret nz			; $5a57
	ld (hl),$69		; $5a58
	inc l			; $5a5a
	ld (hl),$02		; $5a5b
	ld e,$59		; $5a5d
	ld a,h			; $5a5f
	ld (de),a		; $5a60
	jp objectCopyPosition		; $5a61
	ld e,$59		; $5a64
	ld a,(de)		; $5a66
	ld h,a			; $5a67
	ld l,$4a		; $5a68
	ld e,l			; $5a6a
	ld b,$06		; $5a6b
	call copyMemoryReverse		; $5a6d
	ld c,$08		; $5a70
	call objectUpdateSpeedZ_paramC		; $5a72
	ret nz			; $5a75
	ld bc,$6903		; $5a76
	call objectCreateInteraction		; $5a79
	jr nz,_label_09_115	; $5a7c
	ld a,$01		; $5a7e
	ld ($cfc0),a		; $5a80
_label_09_115:
	jp interactionDelete		; $5a83
	ld e,Interaction.state		; $5a86
	ld a,(de)		; $5a88
	or a			; $5a89
	jr nz,_label_09_116	; $5a8a
	ld a,$01		; $5a8c
	ld (de),a		; $5a8e
	call interactionInitGraphics		; $5a8f
	call objectSetVisible83		; $5a92
_label_09_116:
	ld a,($cfc0)		; $5a95
	or a			; $5a98
	jp nz,interactionDelete		; $5a99
	jp interactionAnimate		; $5a9c
	ld e,Interaction.state		; $5a9f
	ld a,(de)		; $5aa1
	or a			; $5aa2
	jr nz,_label_09_117	; $5aa3
	ld a,$01		; $5aa5
	ld (de),a		; $5aa7
	call interactionInitGraphics		; $5aa8
	call objectSetVisible83		; $5aab
	ld a,$5c		; $5aae
	call playSound		; $5ab0
_label_09_117:
	call interactionAnimate		; $5ab3
	ld e,$61		; $5ab6
	ld a,(de)		; $5ab8
	inc a			; $5ab9
	ret nz			; $5aba
	ld a,$ff		; $5abb
	ld ($cfc0),a		; $5abd
	call objectGetShortPosition		; $5ac0
	ld c,a			; $5ac3
	ld a,$d5		; $5ac4
	call setTile		; $5ac6
	jp interactionDelete		; $5ac9
	ld a,($c4ab)		; $5acc
	or a			; $5acf
	ret nz			; $5ad0
	call interactionDecCounter1		; $5ad1
	ret nz			; $5ad4
	ld (hl),$08		; $5ad5
	ld b,$d7		; $5ad7
	call $5af7		; $5ad9
	ret nz			; $5adc
	jp $5a0a		; $5add
	ld hl,$d080		; $5ae0
_label_09_118:
	ld a,(hl)		; $5ae3
	or a			; $5ae4
	call nz,$5aef		; $5ae5
	inc h			; $5ae8
	ld a,h			; $5ae9
	cp $e0			; $5aea
	jr c,_label_09_118	; $5aec
	ret			; $5aee
	xor a			; $5aef
	ld l,$9a		; $5af0
	ld (hl),a		; $5af2
	ld l,$80		; $5af3
	ld (hl),a		; $5af5
	ret			; $5af6
	ld h,d			; $5af7
	ld l,$58		; $5af8
	ld e,l			; $5afa
	ldi a,(hl)		; $5afb
	ld h,(hl)		; $5afc
	ld l,a			; $5afd
	ldi a,(hl)		; $5afe
	or a			; $5aff
	ret z			; $5b00
	ld c,a			; $5b01
	ld a,l			; $5b02
	ld (de),a		; $5b03
	inc e			; $5b04
	ld a,h			; $5b05
	ld (de),a		; $5b06
	ld a,b			; $5b07
	call setTile		; $5b08
	or d			; $5b0b
	ret			; $5b0c
	dec d			; $5b0d
	ld e,e			; $5b0e
	ccf			; $5b0f
	ld e,e			; $5b10
	ld (hl),e		; $5b11
	ld e,e			; $5b12
	cp e			; $5b13
	ld e,e			; $5b14
	inc (hl)		; $5b15
	ld b,h			; $5b16
	ld b,e			; $5b17
	ld b,l			; $5b18
	ld b,d			; $5b19
	ld b,(hl)		; $5b1a
	ld b,c			; $5b1b
	ld b,a			; $5b1c
	ld d,e			; $5b1d
	ld d,l			; $5b1e
	ld d,d			; $5b1f
	ld sp,$2137		; $5b20
	daa			; $5b23
	jr z,_label_09_119	; $5b24
	rla			; $5b26
	jr _label_09_120		; $5b27
	ld h,d			; $5b29
	ld h,c			; $5b2a
	ld h,h			; $5b2b
	ld h,(hl)		; $5b2c
	ld h,a			; $5b2d
	ld l,b			; $5b2e
	ld (hl),h		; $5b2f
	ld (hl),e		; $5b30
	ld (hl),l		; $5b31
	ld (hl),d		; $5b32
	halt			; $5b33
	ld (hl),c		; $5b34
	ld (hl),a		; $5b35
	add c			; $5b36
_label_09_119:
	add d			; $5b37
	add e			; $5b38
	add h			; $5b39
	add l			; $5b3a
	add (hl)		; $5b3b
	add a			; $5b3c
	adc b			; $5b3d
	nop			; $5b3e
	daa			; $5b3f
	scf			; $5b40
	ld (hl),$47		; $5b41
	jr c,_label_09_121	; $5b43
	ld c,b			; $5b45
	dec (hl)		; $5b46
	add hl,sp		; $5b47
	ldd a,(hl)		; $5b48
	ld c,d			; $5b49
	ld c,c			; $5b4a
	ld e,c			; $5b4b
	ld e,b			; $5b4c
	ld d,a			; $5b4d
	ld d,(hl)		; $5b4e
	ld b,l			; $5b4f
	ld b,h			; $5b50
	ld d,l			; $5b51
	ld d,h			; $5b52
	ldi a,(hl)		; $5b53
	ld a,(de)		; $5b54
	dec de			; $5b55
	ld d,e			; $5b56
	ld h,e			; $5b57
	ld h,h			; $5b58
	ld c,e			; $5b59
	ld e,e			; $5b5a
	ld e,d			; $5b5b
	inc e			; $5b5c
	inc l			; $5b5d
	inc a			; $5b5e
	ld l,d			; $5b5f
	ld l,c			; $5b60
	ld l,b			; $5b61
	ld h,a			; $5b62
	ld h,(hl)		; $5b63
	ld h,d			; $5b64
	halt			; $5b65
	ld (hl),a		; $5b66
	ld l,e			; $5b67
	ld e,h			; $5b68
	ld l,h			; $5b69
	ld a,h			; $5b6a
	ld a,e			; $5b6b
	ld a,d			; $5b6c
	ld a,c			; $5b6d
	ld a,b			; $5b6e
	ld (hl),d		; $5b6f
	ld (hl),e		; $5b70
	ld (hl),h		; $5b71
	nop			; $5b72
	scf			; $5b73
	ld b,a			; $5b74
	ld d,a			; $5b75
	ld b,(hl)		; $5b76
	ld d,(hl)		; $5b77
	ld h,(hl)		; $5b78
	ld h,a			; $5b79
_label_09_120:
	ld c,b			; $5b7a
	ld e,b			; $5b7b
	ld l,b			; $5b7c
	ld b,l			; $5b7d
	ld d,l			; $5b7e
	ld h,l			; $5b7f
	ld c,c			; $5b80
	ld e,c			; $5b81
	ld l,c			; $5b82
	ld h,h			; $5b83
	ld d,h			; $5b84
	ld b,h			; $5b85
	inc (hl)		; $5b86
	ld e,d			; $5b87
	ld l,d			; $5b88
	ld l,e			; $5b89
	ld e,e			; $5b8a
_label_09_121:
	ld c,e			; $5b8b
	ld a,e			; $5b8c
	ld a,d			; $5b8d
	ld a,c			; $5b8e
	ld e,h			; $5b8f
	ld l,h			; $5b90
	ld a,h			; $5b91
	ld (hl),h		; $5b92
	ld (hl),e		; $5b93
	ld h,e			; $5b94
	ld d,e			; $5b95
	ld b,e			; $5b96
	ld (hl),a		; $5b97
	ld a,b			; $5b98
	ldd a,(hl)		; $5b99
	ldi a,(hl)		; $5b9a
	ld a,(de)		; $5b9b
	inc sp			; $5b9c
	inc hl			; $5b9d
	ldi (hl),a		; $5b9e
	ldd (hl),a		; $5b9f
	ld b,d			; $5ba0
	ld d,d			; $5ba1
	ld h,d			; $5ba2
	ld (hl),d		; $5ba3
	inc h			; $5ba4
	inc d			; $5ba5
	inc de			; $5ba6
	inc bc			; $5ba7
	ld (bc),a		; $5ba8
	ld (de),a		; $5ba9
	inc b			; $5baa
	dec b			; $5bab
	dec sp			; $5bac
	dec hl			; $5bad
	dec de			; $5bae
	dec bc			; $5baf
	inc l			; $5bb0
	inc a			; $5bb1
	ld c,h			; $5bb2
	ld a,(bc)		; $5bb3
	add hl,bc		; $5bb4
	ld ($1c0c),sp		; $5bb5
	ld b,$07		; $5bb8
	nop			; $5bba
	ld a,c			; $5bbb
	adc c			; $5bbc
	adc b			; $5bbd
	sbc c			; $5bbe
	adc d			; $5bbf
	add a			; $5bc0
	sub a			; $5bc1
	sbc b			; $5bc2
	sbc d			; $5bc3
	sbc e			; $5bc4
	adc e			; $5bc5
	halt			; $5bc6
	add (hl)		; $5bc7
	sbc h			; $5bc8
	sbc l			; $5bc9
	adc l			; $5bca
	ld a,l			; $5bcb
	ld l,l			; $5bcc
	ld e,l			; $5bcd
	dec l			; $5bce
	inc l			; $5bcf
	ldi a,(hl)		; $5bd0
	add hl,hl		; $5bd1
	ld c,l			; $5bd2
	dec a			; $5bd3
	ld c,h			; $5bd4
	ld c,d			; $5bd5
	inc a			; $5bd6
	dec sp			; $5bd7
	ld c,c			; $5bd8
	jr c,_label_09_122	; $5bd9
	add hl,sp		; $5bdb
	ld (hl),l		; $5bdc
	add l			; $5bdd
	ld h,l			; $5bde
	sub l			; $5bdf
	add h			; $5be0
	sub h			; $5be1
	daa			; $5be2
	ld h,$24		; $5be3
	nop			; $5be5

interactionCode6a:
	ld e,Interaction.subid		; $5be6
	ld a,(de)		; $5be8
	rst_jumpTable			; $5be9
	ld a,($ff00+c)		; $5bea
	ld e,e			; $5beb
	ld ($3d5c),sp		; $5bec
	ld e,a			; $5bef
	xor (hl)		; $5bf0
	ld h,b			; $5bf1
	ld a,$01		; $5bf2
	ld ($ccea),a		; $5bf4
	ld b,$20		; $5bf7
	ld hl,$cfc0		; $5bf9
	call clearMemory		; $5bfc
	ld hl,$7e6c		; $5bff
	call parseGivenObjectData		; $5c02
	jp interactionDelete		; $5c05
	ld e,Interaction.state		; $5c08
	ld a,(de)		; $5c0a
	rst_jumpTable			; $5c0b
	jr $5c			; $5c0c
	ld (hl),c		; $5c0e
	ld e,(hl)		; $5c0f
	inc (hl)		; $5c10
	ld e,h			; $5c11
	ccf			; $5c12
	ld e,h			; $5c13
	sub h			; $5c14
_label_09_122:
	ld e,h			; $5c15
	rst $8			; $5c16
	ld e,l			; $5c17
	call $5c21		; $5c18
	ld hl,$6613		; $5c1b
	jp interactionSetScript		; $5c1e
	ld a,$01		; $5c21
	ld (de),a		; $5c23
	call interactionSetAlwaysUpdateBit		; $5c24
	ld l,$48		; $5c27
	ld (hl),$02		; $5c29
	inc l			; $5c2b
	ld (hl),$10		; $5c2c
	call interactionInitGraphics		; $5c2e
	jp objectSetVisiblec2		; $5c31
	ld c,$28		; $5c34
	call objectUpdateSpeedZ_paramC		; $5c36
	call interactionRunScript		; $5c39
	jp interactionAnimate		; $5c3c
	call interactionAnimate		; $5c3f
	ld e,Interaction.state2		; $5c42
	ld a,(de)		; $5c44
	rst_jumpTable			; $5c45
	ld c,h			; $5c46
	ld e,h			; $5c47
	inc c			; $5c48
	dec h			; $5c49
	ld e,l			; $5c4a
	ld e,h			; $5c4b
	ld a,$01		; $5c4c
	ld (de),a		; $5c4e
	ld ($cfda),a		; $5c4f
	ld a,$50		; $5c52
	ld ($cfd3),a		; $5c54
	ld hl,$6634		; $5c57
	jp interactionSetScript		; $5c5a
	ld a,($c4ab)		; $5c5d
	or a			; $5c60
	ret nz			; $5c61
	xor a			; $5c62
	ld h,d			; $5c63
	ld l,e			; $5c64
	ldd (hl),a		; $5c65
	inc (hl)		; $5c66
	ld a,$01		; $5c67
	call setLinkIDOverride		; $5c69
	jp fastFadeinFromWhite		; $5c6c
	ld a,$01		; $5c6f
	ld ($cfd2),a		; $5c71
	ld a,$04		; $5c74
	jr _label_09_123		; $5c76
	ld a,$ff		; $5c78
	ld ($cfd2),a		; $5c7a
	ld a,$04		; $5c7d
	jr _label_09_123		; $5c7f
	ld a,$05		; $5c81
	jr _label_09_123		; $5c83
	ld a,$03		; $5c85
_label_09_123:
	ld ($cfd4),a		; $5c87
	ld a,$09		; $5c8a
	ld ($cfd1),a		; $5c8c
	ld hl,$cfda		; $5c8f
	inc (hl)		; $5c92
	ret			; $5c93
	ld e,Interaction.state2		; $5c94
	ld a,(de)		; $5c96
	rst_jumpTable			; $5c97
	and d			; $5c98
	ld e,h			; $5c99
	inc d			; $5c9a
	ld e,l			; $5c9b
	scf			; $5c9c
	ld e,l			; $5c9d
	ld e,a			; $5c9e
	ld e,l			; $5c9f
	pop bc			; $5ca0
	ld e,l			; $5ca1
	ld a,$01		; $5ca2
	ld (de),a		; $5ca4
	ld a,($c6e2)		; $5ca5
	cp $08			; $5ca8
	jr c,_label_09_124	; $5caa
	ld a,$08		; $5cac
_label_09_124:
	ld ($cfd7),a		; $5cae
	ld ($cfdc),a		; $5cb1
	call $5cdd		; $5cb4
	ld a,($cfd7)		; $5cb7
	ld hl,$5d0b		; $5cba
	rst_addAToHl			; $5cbd
	call getRandomNumber		; $5cbe
	and $03			; $5cc1
	add (hl)		; $5cc3
	ld ($cfd5),a		; $5cc4
	xor a			; $5cc7
	ld ($cfd4),a		; $5cc8
	ld ($cfdb),a		; $5ccb
	ld a,$cc		; $5cce
	call playSound		; $5cd0
	ld e,$47		; $5cd3
	ld a,$3c		; $5cd5
	ld (de),a		; $5cd7
	ld a,$22		; $5cd8
	jp playSound		; $5cda
	ld a,($cfd7)		; $5cdd
	ld hl,$5ced		; $5ce0
	rst_addDoubleIndex			; $5ce3
	ldi a,(hl)		; $5ce4
	ld ($cfd3),a		; $5ce5
	ldi a,(hl)		; $5ce8
	ld ($cfd6),a		; $5ce9
	ret			; $5cec
	jr z,_label_09_125	; $5ced
	ldd (hl),a		; $5cef
	ld e,$32		; $5cf0
	inc e			; $5cf2
	inc a			; $5cf3
	ld a,(de)		; $5cf4
	inc a			; $5cf5
	jr _label_09_126		; $5cf6
	ld d,$46		; $5cf8
	inc d			; $5cfa
	ld d,b			; $5cfb
	inc d			; $5cfc
	ld d,b			; $5cfd
	ld (de),a		; $5cfe
	ld e,d			; $5cff
	ld (de),a		; $5d00
	ld h,h			; $5d01
	stop			; $5d02
	ld h,h			; $5d03
	stop			; $5d04
	ld h,h			; $5d05
	ld c,$78		; $5d06
	dec c			; $5d08
	ld a,b			; $5d09
	inc c			; $5d0a
	add hl,bc		; $5d0b
	add hl,bc		; $5d0c
	ld a,(bc)		; $5d0d
	inc c			; $5d0e
_label_09_125:
	ld c,$10		; $5d0f
	ld (de),a		; $5d11
	inc d			; $5d12
	jr -$33			; $5d13
	adc h			; $5d15
	inc hl			; $5d16
	ret nz			; $5d17
	ld (hl),$01		; $5d18
	ld a,$02		; $5d1a
	ld (de),a		; $5d1c
	ld hl,$cfc8		; $5d1d
	call $5ec4		; $5d20
	ldi (hl),a		; $5d23
	call $5ec4		; $5d24
	ldi (hl),a		; $5d27
	call $5ec4		; $5d28
	ldi (hl),a		; $5d2b
	xor a			; $5d2c
	ld (hl),a		; $5d2d
	ld e,$46		; $5d2e
	ld a,($cfd6)		; $5d30
	ld (de),a		; $5d33
	call $5eb9		; $5d34
	call $5f1d		; $5d37
	ret nz			; $5d3a
	ld a,($cfcb)		; $5d3b
_label_09_126:
	cp $03			; $5d3e
	jr z,_label_09_127	; $5d40
	jp $5ee1		; $5d42
_label_09_127:
	call interactionIncState2		; $5d45
	ld a,($cfd6)		; $5d48
	ld l,$46		; $5d4b
	ld (hl),a		; $5d4d
	xor a			; $5d4e
	ld ($cfcb),a		; $5d4f
	ld ($cfd9),a		; $5d52
	ld a,$ff		; $5d55
	ld ($cfd8),a		; $5d57
	ld a,$02		; $5d5a
	call interactionSetAnimation		; $5d5c
	call $5e97		; $5d5f
	jr nz,_label_09_129	; $5d62
	call $5f1d		; $5d64
	ret nz			; $5d67
	ld a,($cfd1)		; $5d68
	or a			; $5d6b
	ret nz			; $5d6c
	ld a,($cfcb)		; $5d6d
	cp $03			; $5d70
	jr z,_label_09_128	; $5d72
	jp $5eea		; $5d74
_label_09_128:
	ld a,($cfd9)		; $5d77
	cp $03			; $5d7a
	jr nz,_label_09_129	; $5d7c
	ld hl,$cfd5		; $5d7e
	dec (hl)		; $5d81
	jr z,_label_09_130	; $5d82
	call $5e77		; $5d84
	ld e,Interaction.state2		; $5d87
	ld a,$01		; $5d89
	ld (de),a		; $5d8b
	xor a			; $5d8c
	ld ($cfcb),a		; $5d8d
	ret			; $5d90
_label_09_129:
	ld bc,$0104		; $5d91
	call showText		; $5d94
	ld a,$04		; $5d97
	ld e,Interaction.state2		; $5d99
	ld (de),a		; $5d9b
	ld a,$ff		; $5d9c
	ld ($cfd0),a		; $5d9e
	ld a,$cc		; $5da1
	call playSound		; $5da3
	ld a,$fb		; $5da6
	jp playSound		; $5da8
_label_09_130:
	call interactionIncState		; $5dab
	inc l			; $5dae
	ld (hl),$00		; $5daf
	ld a,$01		; $5db1
	ld ($cfd0),a		; $5db3
	ld a,$fb		; $5db6
	call playSound		; $5db8
	ld bc,$010a		; $5dbb
	jp showText		; $5dbe
	call retIfTextIsActive		; $5dc1
	ld hl,$5dca		; $5dc4
	jp setWarpDestVariables		; $5dc7
	add c			; $5dca
	inc h			; $5dcb
	nop			; $5dcc
	inc d			; $5dcd
	inc bc			; $5dce
	ld e,Interaction.state2		; $5dcf
	ld a,(de)		; $5dd1
	rst_jumpTable			; $5dd2
.DB $dd				; $5dd3
	ld e,l			; $5dd4
	add sp,$5d		; $5dd5
	stop			; $5dd7
	ld e,(hl)		; $5dd8
	inc c			; $5dd9
	dec h			; $5dda
	pop bc			; $5ddb
	ld e,l			; $5ddc
	call retIfTextIsActive		; $5ddd
	ld e,Interaction.state2		; $5de0
	ld a,$01		; $5de2
	ld (de),a		; $5de4
	jp fastFadeoutToWhite		; $5de5
	ld a,($c4ab)		; $5de8
	or a			; $5deb
	ret nz			; $5dec
	xor a			; $5ded
	call setLinkIDOverride		; $5dee
	ld l,$0b		; $5df1
	ld (hl),$30		; $5df3
	ld l,$0d		; $5df5
	ld (hl),$48		; $5df7
	ld l,$08		; $5df9
	ld (hl),$02		; $5dfb
	call interactionIncState2		; $5dfd
	ld a,$81		; $5e00
	ld ($cca4),a		; $5e02
	ld ($cbca),a		; $5e05
	ld a,$1e		; $5e08
	call addToGashaMaturity		; $5e0a
	jp fastFadeinFromWhite		; $5e0d
	ld a,($c4ab)		; $5e10
	or a			; $5e13
	ret nz			; $5e14
	ld a,$81		; $5e15
	ld ($cca4),a		; $5e17
	ld ($cc02),a		; $5e1a
	ld hl,$c6e2		; $5e1d
	call incHlRefWithCap		; $5e20
	ld a,(hl)		; $5e23
	dec a			; $5e24
	jr z,_label_09_134	; $5e25
	cp $08			; $5e27
	jr z,_label_09_131	; $5e29
	cp $05			; $5e2b
	jr nz,_label_09_132	; $5e2d
	call checkIsLinkedGame		; $5e2f
	jr nz,_label_09_132	; $5e32
	ld a,($c643)		; $5e34
	and $20			; $5e37
	jr nz,_label_09_132	; $5e39
	ld hl,$664a		; $5e3b
	jr _label_09_135		; $5e3e
_label_09_131:
	ld hl,$5e20		; $5e40
	ld e,$15		; $5e43
	call interBankCall		; $5e45
	bit 7,b			; $5e48
	jr nz,_label_09_133	; $5e4a
	ld c,$00		; $5e4c
	call giveRingToLink		; $5e4e
	ld hl,$6657		; $5e51
	jr _label_09_135		; $5e54
_label_09_132:
	call getRandomNumber		; $5e56
	cp $60			; $5e59
	ld hl,$6654		; $5e5b
	jr nc,_label_09_135	; $5e5e
_label_09_133:
	ld hl,$664f		; $5e60
	jr _label_09_135		; $5e63
_label_09_134:
	ld hl,$6645		; $5e65
_label_09_135:
	call interactionSetScript		; $5e68
	ld e,Interaction.state2		; $5e6b
	ld a,$03		; $5e6d
	ld (de),a		; $5e6f
	ret			; $5e70
	call interactionRunScript		; $5e71
	jp npcFaceLinkAndAnimate		; $5e74
	ld hl,$cfdb		; $5e77
	ld a,(hl)		; $5e7a
	cp $08			; $5e7b
	jr c,_label_09_136	; $5e7d
	ld a,$08		; $5e7f
_label_09_136:
	inc a			; $5e81
	ld (hl),a		; $5e82
	ld b,a			; $5e83
	and $03			; $5e84
	ret nz			; $5e86
	ld a,b			; $5e87
	rrca			; $5e88
	rrca			; $5e89
	and $03			; $5e8a
	ld b,a			; $5e8c
	ld a,($cfd7)		; $5e8d
	add b			; $5e90
	ld ($cfd7),a		; $5e91
	jp $5cdd		; $5e94
	ld a,($cfdd)		; $5e97
	or a			; $5e9a
	ret nz			; $5e9b
	ld a,($cfd8)		; $5e9c
	ld b,a			; $5e9f
	inc a			; $5ea0
	ret z			; $5ea1
	ld a,($cfd9)		; $5ea2
	cp $03			; $5ea5
	ret z			; $5ea7
	ld hl,$cfd9		; $5ea8
	inc (hl)		; $5eab
	ld hl,$cfc8		; $5eac
	rst_addAToHl			; $5eaf
	ld a,(hl)		; $5eb0
	cp b			; $5eb1
	ret nz			; $5eb2
	ld a,$ff		; $5eb3
	ld ($cfd8),a		; $5eb5
	ret			; $5eb8
	ld a,$02		; $5eb9
	call interactionSetAnimation		; $5ebb
	ld bc,$fe80		; $5ebe
	jp objectSetSpeedZ		; $5ec1
	call getRandomNumber		; $5ec4
	and $0f			; $5ec7
	ld bc,$5ed1		; $5ec9
	call addAToBc		; $5ecc
	ld a,(bc)		; $5ecf
	ret			; $5ed0
	nop			; $5ed1
	nop			; $5ed2
	nop			; $5ed3
	nop			; $5ed4
	nop			; $5ed5
	nop			; $5ed6
	nop			; $5ed7
	nop			; $5ed8
	ld bc,$0101		; $5ed9
	ld bc,$0202		; $5edc
	ld (bc),a		; $5edf
	ld (bc),a		; $5ee0
	call $5efd		; $5ee1
	ld a,e			; $5ee4
	call interactionSetAnimation		; $5ee5
	jr _label_09_137		; $5ee8
	call $5efd		; $5eea
	ldh a,(<hFF8B)	; $5eed
	call $5f10		; $5eef
_label_09_137:
	ld hl,$cfcb		; $5ef2
	inc (hl)		; $5ef5
	ld e,$46		; $5ef6
	ld a,($cfd6)		; $5ef8
	ld (de),a		; $5efb
	ret			; $5efc
	ld a,($cfcb)		; $5efd
	ld hl,$cfc8		; $5f00
	rst_addAToHl			; $5f03
	ld a,(hl)		; $5f04
	ldh (<hFF8B),a	; $5f05
	ld hl,$5f17		; $5f07
	rst_addDoubleIndex			; $5f0a
	ldi a,(hl)		; $5f0b
	ld e,(hl)		; $5f0c
	jp playSound		; $5f0d
	rst_jumpTable			; $5f10
	ld l,a			; $5f11
	ld e,h			; $5f12
	ld a,b			; $5f13
	ld e,h			; $5f14
	add c			; $5f15
	ld e,h			; $5f16
	jp z,$cb05		; $5f17
	ld b,$cd		; $5f1a
	inc b			; $5f1c
	ld c,$28		; $5f1d
	call objectUpdateSpeedZ_paramC		; $5f1f
	call interactionAnimate		; $5f22
	ld h,d			; $5f25
	ld l,$61		; $5f26
	ld a,(hl)		; $5f28
	or a			; $5f29
	jr z,_label_09_138	; $5f2a
	inc a			; $5f2c
	jr z,_label_09_138	; $5f2d
	dec a			; $5f2f
	ld (hl),$00		; $5f30
	ld l,$4d		; $5f32
	add (hl)		; $5f34
	ld (hl),a		; $5f35
_label_09_138:
	ld l,$46		; $5f36
	ld a,(hl)		; $5f38
	or a			; $5f39
	ret z			; $5f3a
	dec (hl)		; $5f3b
	ret			; $5f3c
	ld e,Interaction.state		; $5f3d
	ld a,(de)		; $5f3f
	rst_jumpTable			; $5f40
	ld c,a			; $5f41
	ld e,a			; $5f42
	ld a,e			; $5f43
	ld e,a			; $5f44
	sub c			; $5f45
	ld e,a			; $5f46
	add hl,de		; $5f47
	ld h,b			; $5f48
	inc hl			; $5f49
	ld h,b			; $5f4a
	dec l			; $5f4b
	ld h,b			; $5f4c
	cp b			; $5f4d
	dec h			; $5f4e
	call $5c21		; $5f4f
	ld e,$4d		; $5f52
	ld a,(de)		; $5f54
	ld hl,$5f72		; $5f55
	rst_addAToHl			; $5f58
	ld e,$72		; $5f59
	ld a,(hl)		; $5f5b
	ld (de),a		; $5f5c
	ld a,$01		; $5f5d
	inc e			; $5f5f
	ld (de),a		; $5f60
	ld h,d			; $5f61
	ld l,$7b		; $5f62
	ld (hl),$01		; $5f64
	ld l,$4b		; $5f66
	ld a,(hl)		; $5f68
	call setShortPosition		; $5f69
	ld hl,$665d		; $5f6c
	jp interactionSetScript		; $5f6f
	dec bc			; $5f72
	inc c			; $5f73
	dec c			; $5f74
	ld c,$0f		; $5f75
	stop			; $5f77
	ld de,$1312		; $5f78
	ld a,($cfda)		; $5f7b
	or a			; $5f7e
	jr nz,_label_09_139	; $5f7f
	call interactionRunScript		; $5f81
	jp npcFaceLinkAndAnimate		; $5f84
_label_09_139:
	ld e,Interaction.state		; $5f87
	ld a,$02		; $5f89
	ld (de),a		; $5f8b
	ld a,$02		; $5f8c
	jp interactionSetAnimation		; $5f8e
	call $60a4		; $5f91
	jr c,_label_09_140	; $5f94
	call interactionAnimate		; $5f96
	ld a,($cfd0)		; $5f99
	or a			; $5f9c
	jr nz,_label_09_140	; $5f9d
	ld h,d			; $5f9f
	ld l,$7b		; $5fa0
	ld a,($cfda)		; $5fa2
	cp (hl)			; $5fa5
	ret z			; $5fa6
	ld (hl),a		; $5fa7
	ld a,($cfd4)		; $5fa8
	ld l,$44		; $5fab
	ld (hl),a		; $5fad
	cp $04			; $5fae
	call z,$5fc3		; $5fb0
	xor a			; $5fb3
	ld e,$78		; $5fb4
	ld (de),a		; $5fb6
	ret			; $5fb7
_label_09_140:
	ld a,$02		; $5fb8
	call interactionSetAnimation		; $5fba
	ld e,Interaction.state		; $5fbd
	ld a,$06		; $5fbf
	ld (de),a		; $5fc1
	ret			; $5fc2
	call objectGetShortPosition		; $5fc3
	ld c,a			; $5fc6
	ld hl,$5ff1		; $5fc7
_label_09_141:
	ldi a,(hl)		; $5fca
	cp c			; $5fcb
	jr z,_label_09_142	; $5fcc
	inc hl			; $5fce
	jr _label_09_141		; $5fcf
_label_09_142:
	ld a,($cfd2)		; $5fd1
	bit 7,a			; $5fd4
	jr nz,_label_09_143	; $5fd6
	ld a,(hl)		; $5fd8
	jr _label_09_144		; $5fd9
_label_09_143:
	ld a,(hl)		; $5fdb
	swap a			; $5fdc
_label_09_144:
	and $0f			; $5fde
	ld e,$48		; $5fe0
	ld (de),a		; $5fe2
	ldh (<hFF8B),a	; $5fe3
	call interactionSetAnimation		; $5fe5
	ldh a,(<hFF8B)	; $5fe8
	swap a			; $5fea
	rrca			; $5fec
	ld e,$49		; $5fed
	ld (de),a		; $5fef
	ret			; $5ff0
	ld de,$2121		; $5ff1
	jr nz,_label_09_145	; $5ff4
	jr nz,$41		; $5ff6
	jr nz,$51		; $5ff8
	jr nz,$61		; $5ffa
	stop			; $5ffc
	ld h,d			; $5ffd
	inc de			; $5ffe
	ld h,e			; $5fff
	inc de			; $6000
	ld h,h			; $6001
	inc de			; $6002
	ld h,l			; $6003
	inc de			; $6004
	ld h,(hl)		; $6005
	inc bc			; $6006
	ld d,(hl)		; $6007
	ld (bc),a		; $6008
	ld b,(hl)		; $6009
	ld (bc),a		; $600a
	ld (hl),$02		; $600b
	ld h,$02		; $600d
	ld d,$32		; $600f
	dec d			; $6011
	ld sp,$3114		; $6012
	inc de			; $6015
	ld sp,$3112		; $6016
	ld a,$02		; $6019
	ld (de),a		; $601b
	ld a,$02		; $601c
	call interactionSetAnimation		; $601e
	jr _label_09_146		; $6021
	call $603f		; $6023
	ret c			; $6026
_label_09_145:
	ld l,$44		; $6027
	ld (hl),$02		; $6029
	jr _label_09_146		; $602b
	ld a,$02		; $602d
	ld (de),a		; $602f
	ld a,$04		; $6030
	call interactionSetAnimation		; $6032
	jr _label_09_146		; $6035
_label_09_146:
	ld hl,$cfd1		; $6037
	ld a,(hl)		; $603a
	or a			; $603b
	ret z			; $603c
	dec (hl)		; $603d
	ret			; $603e
	ld h,d			; $603f
	ld e,$4b		; $6040
	ld l,$79		; $6042
	ld a,(de)		; $6044
	ldi (hl),a		; $6045
	ld e,$4d		; $6046
	ld a,(de)		; $6048
	ld (hl),a		; $6049
	ld a,($cfd3)		; $604a
	ld e,$50		; $604d
	ld (de),a		; $604f
	call objectApplySpeed		; $6050
	call $6058		; $6053
	jr _label_09_148		; $6056
	ld h,d			; $6058
	ld l,$4b		; $6059
	call $6061		; $605b
	ld h,d			; $605e
	ld l,$4d		; $605f
	ld a,$17		; $6061
	cp (hl)			; $6063
	inc a			; $6064
	jr nc,_label_09_147	; $6065
	ld a,$68		; $6067
	cp (hl)			; $6069
	ret nc			; $606a
_label_09_147:
	ld (hl),a		; $606b
	ld a,($cfd2)		; $606c
	ld l,$48		; $606f
	add (hl)		; $6071
	and $03			; $6072
	ldi (hl),a		; $6074
	ld b,a			; $6075
	swap a			; $6076
	rrca			; $6078
	ld (hl),a		; $6079
	ld a,b			; $607a
	jp interactionSetAnimation		; $607b
_label_09_148:
	ld e,$4b		; $607e
	ld a,(de)		; $6080
	ld b,a			; $6081
	ld e,$79		; $6082
	ld a,(de)		; $6084
	sub b			; $6085
	jr nc,_label_09_149	; $6086
	cpl			; $6088
	inc a			; $6089
_label_09_149:
	ld c,a			; $608a
	ld e,$4d		; $608b
	ld a,(de)		; $608d
	ld b,a			; $608e
	ld e,$7a		; $608f
	ld a,(de)		; $6091
	sub b			; $6092
	jr nc,_label_09_150	; $6093
	cpl			; $6095
	inc a			; $6096
_label_09_150:
	add c			; $6097
	ld b,a			; $6098
	ld e,$78		; $6099
	ld a,(de)		; $609b
	add b			; $609c
	ld (de),a		; $609d
	cp $10			; $609e
	ret c			; $60a0
	jp objectCenterOnTile		; $60a1
	call objectCheckCollidedWithLink		; $60a4
	ret nc			; $60a7
	ld a,$01		; $60a8
	ld ($cfdd),a		; $60aa
	ret			; $60ad
	ld e,Interaction.state		; $60ae
	ld a,(de)		; $60b0
	or a			; $60b1
	jr nz,_label_09_151	; $60b2
	ld a,$01		; $60b4
	ld (de),a		; $60b6
	ld e,$40		; $60b7
	ld a,$81		; $60b9
	ld (de),a		; $60bb
	call interactionInitGraphics		; $60bc
_label_09_151:
	ld a,($cfdf)		; $60bf
	ld b,a			; $60c2
	or a			; $60c3
	jp z,objectSetInvisible		; $60c4
	call objectSetVisible80		; $60c7
	ld a,b			; $60ca
	cp $ff			; $60cb
	jp z,interactionDelete		; $60cd
	add a			; $60d0
	add b			; $60d1
	ld hl,$60e2		; $60d2
	rst_addAToHl			; $60d5
	ldi a,(hl)		; $60d6
	ld e,$4b		; $60d7
	ld (de),a		; $60d9
	ld e,$4d		; $60da
	ldi a,(hl)		; $60dc
	ld (de),a		; $60dd
	ld a,(hl)		; $60de
	jp interactionSetAnimation		; $60df
.db $30 $58 $07 $30 $58 $07 $30 $38
.db $08 $30 $58 $09


; ==============================================================================
; INTERACID_MISCELLANEOUS_1
; ==============================================================================
interactionCode6b:
	ld e,Interaction.subid		; $60ee
	ld a,(de)		; $60f0
	rst_jumpTable			; $60f1
	.dw $6140
	.dw $6161
	.dw interactionCode6bSubid02
	.dw interactionCode6bSubid03
	.dw $626e
	.dw $62a2
	.dw $62a8
	.dw $62cf
	.dw $6333
	.dw $6345
	.dw $6381
	.dw $639e
	.dw $63df
	.dw $640d
	.dw $6427
	.dw $648b
	.dw $6491
	.dw interactionCode6bSubid11
	.dw interactionCode6bSubid12
	.dw $6545
	.dw interactionCode6bSubid14
	.dw $657c
	.dw $658c
	.dw $65af
	.dw $65f5
	.dw $6608
	.dw $660e
	.dw $6614
	.dw $6644
	.dw $6653
	.dw $6677
	.dw $66aa
	.dw $66b0
	.dw $66b6
	.dw $66e1
	.dw $66ef
	.dw $673e
	.dw $674e
	.dw $6776
	call checkInteractionState		; $6140
	jr nz,_label_09_155	; $6143
	ld a,$01		; $6145
	ld (de),a		; $6147
	call interactionInitGraphics		; $6148
	ld hl,$6665		; $614b
	call interactionSetScript		; $614e
	call objectSetVisible82		; $6151
	xor a			; $6154
	ld ($cfc1),a		; $6155
_label_09_155:
	call interactionAnimate		; $6158
	call objectPreventLinkFromPassing		; $615b
	jp interactionRunScript		; $615e
	call checkInteractionState		; $6161
	jr nz,_label_09_157	; $6164
	ld a,$01		; $6166
	ld (de),a		; $6168
	call getThisRoomFlags		; $6169
	bit 6,(hl)		; $616c
	jr z,_label_09_156	; $616e
	ld bc,$cf68		; $6170
	ld a,$0b		; $6173
	ld (bc),a		; $6175
	jp interactionDelete		; $6176
_label_09_156:
	call interactionInitGraphics		; $6179
	call objectSetVisible83		; $617c
	call objectSetInvisible		; $617f
	xor a			; $6182
	ld ($cc32),a		; $6183
	ld hl,$66aa		; $6186
	jp interactionSetScript		; $6189
_label_09_157:
	call interactionAnimate		; $618c
	call interactionRunScript		; $618f
	ret nc			; $6192
	jp interactionDelete		; $6193

interactionCode6bSubid02:
	ld e,Interaction.state		; $6196
	ld a,(de)		; $6198
	rst_jumpTable			; $6199
	.dw $61a0
	.dw interactionRunScript
	.dw $61b1
	ld a,$01		; $61a0
	ld (de),a		; $61a2
	call getThisRoomFlags		; $61a3
	bit 7,(hl)		; $61a6
	jp nz,interactionDelete		; $61a8
	ld hl,$66ca		; $61ab
	jp interactionSetScript		; $61ae

	ld a,$04		; $61b1
	call setScreenShakeCounter		; $61b3
	ld a,($cfc0)		; $61b6
	bit 7,a			; $61b9
	ret z			; $61bb
	ld a,($cc62)		; $61bc
	ld (wActiveMusic),a		; $61bf
	call playSound		; $61c2
	jr _label_09_158		; $61c5
	ld a,$ff		; $61c7
	ld (wActiveMusic),a		; $61c9
_label_09_158:
	xor a			; $61cc
	ld ($cc02),a		; $61cd
	ld ($cca4),a		; $61d0
	ld a,$f1		; $61d3
	call playSound		; $61d5
	ld a,$4d		; $61d8
	call playSound		; $61da
	jp interactionDelete		; $61dd

interactionCode6bSubid03:
	ld e,Interaction.state		; $61e0
	ld a,(de)		; $61e2
	rst_jumpTable			; $61e3
	.dw $61ee
	.dw $6207
	.dw $6224
	.dw $623f
	.dw $6253

	ld a,$01		; $61ee
	ld (de),a		; $61f0
	call getThisRoomFlags		; $61f1
	bit 7,(hl)		; $61f4
	jp nz,interactionDelete		; $61f6
	call objectSetReservedBit1		; $61f9
	ld a,$01		; $61fc
	ld ($ccae),a		; $61fe
	ld hl,$66e0		; $6201
	jp interactionSetScript		; $6204


	ld a,($cc4c)		; $6207
	cp $0d			; $620a
	jp nz,interactionDelete		; $620c
	call interactionRunScript		; $620f
	ret nc			; $6212
	call interactionIncState		; $6213
	ld hl,simpleScript_14_4d80		; $6216
	jp interactionSetSimpleScript		; $6219
	ld h,d			; $621c
	ld l,$46		; $621d
	ld a,(hl)		; $621f
	or a			; $6220
	ret z			; $6221
	dec (hl)		; $6222
	ret			; $6223
	call $621c		; $6224
	ret nz			; $6227
	call interactionRunSimpleScript		; $6228
	ret nc			; $622b
	call interactionIncState		; $622c
	ld a,$1d		; $622f
	ld b,$02		; $6231
	call func_1383		; $6233
	ld hl,$5d79		; $6236
	ld e,$15		; $6239
	call interBankCall		; $623b
	ret			; $623e

	ld a,($cd00)		; $623f
	and $01			; $6242
	ret z			; $6244
	call getThisRoomFlags		; $6245
	set 7,(hl)		; $6248
	call interactionIncState		; $624a
	ld hl,simpleScript_14_4dbd		; $624d
	jp interactionSetSimpleScript		; $6250
	ld a,$3c		; $6253
	call setScreenShakeCounter		; $6255
	call $621c		; $6258
	ret nz			; $625b
	call interactionRunSimpleScript		; $625c
	ret nc			; $625f
	ld hl,$6269		; $6260
	call setWarpDestVariables		; $6263
	jp $61c7		; $6266
	ret nz			; $6269
	dec c			; $626a
	ld bc,$0323		; $626b
	ld e,Interaction.state		; $626e
	ld a,(de)		; $6270
	rst_jumpTable			; $6271
	ld a,b			; $6272
	ld h,d			; $6273
	adc c			; $6274
	ld h,d			; $6275
	inc c			; $6276
	dec h			; $6277
	call getThisRoomFlags		; $6278
	and $60			; $627b
	cp $40			; $627d
	ret nz			; $627f
	ld bc,$4300		; $6280
	call $6391		; $6283
	jp interactionIncState		; $6286
	ld a,TREASURE_FLOODGATE_KEY		; $6289
	call checkTreasureObtained		; $628b
	ret nc			; $628e
	call interactionIncState		; $628f
	ld hl,$cca4		; $6292
	set 7,(hl)		; $6295
	ld a,$01		; $6297
	ld ($cc02),a		; $6299
	ld hl,$66a5		; $629c
	jp interactionSetScript		; $629f
	ld bc,$4400		; $62a2
	jp $6384		; $62a5
	ld e,Interaction.state		; $62a8
	ld a,(de)		; $62aa
	rst_jumpTable			; $62ab
	or d			; $62ac
	ld h,d			; $62ad
	jp $8f62		; $62ae
	ld h,c			; $62b1
	call getThisRoomFlags		; $62b2
	and $40			; $62b5
	jp nz,interactionDelete		; $62b7
	call interactionIncState		; $62ba
	ld hl,$66fd		; $62bd
	jp interactionSetScript		; $62c0
	call objectGetTileAtPosition		; $62c3
	cp $04			; $62c6
	ret nz			; $62c8
	call interactionIncState		; $62c9
	jp $618f		; $62cc
	ld a,($cc4c)		; $62cf
	cp $42			; $62d2
	jp nz,interactionDelete		; $62d4
	ld e,Interaction.state		; $62d7
	ld a,(de)		; $62d9
	rst_jumpTable			; $62da
	pop hl			; $62db
	ld h,d			; $62dc
	ld sp,hl		; $62dd
	ld h,d			; $62de
	ld c,$63		; $62df
	ld a,$01		; $62e1
	ld (de),a		; $62e3
	ld a,($cc4e)		; $62e4
	cp $03			; $62e7
	jp nz,interactionDelete		; $62e9
	call getThisRoomFlags		; $62ec
	ld e,$4b		; $62ef
	ld a,(de)		; $62f1
	and (hl)		; $62f2
	jp nz,interactionDelete		; $62f3
	jp objectSetReservedBit1		; $62f6
	ld a,($cc4e)		; $62f9
	cp $03			; $62fc
	jp nz,interactionDelete		; $62fe
	ld e,$4d		; $6301
	ld a,(de)		; $6303
	ld l,a			; $6304
	ld h,$cf		; $6305
	ld a,$9c		; $6307
	cp (hl)			; $6309
	ret nz			; $630a
	jp interactionIncState		; $630b
	ld a,($cc4e)		; $630e
	cp $03			; $6311
	ret z			; $6313
	ld a,($c4ab)		; $6314
	or a			; $6317
	ret z			; $6318
	call getThisRoomFlags		; $6319
	ld e,$4b		; $631c
	ld a,(de)		; $631e
	or (hl)			; $631f
	ld (hl),a		; $6320
	ld e,$4d		; $6321
	ld a,(de)		; $6323
	dec a			; $6324
	ld c,a			; $6325
	ld a,$09		; $6326
	call setTile		; $6328
	inc c			; $632b
	ld a,$bc		; $632c
	call setTile		; $632e
	jr _label_09_159		; $6331
	call returnIfScrollMode01Unset		; $6333
	ld a,($cd02)		; $6336
	or a			; $6339
	jp nz,interactionDelete		; $633a
_label_09_159:
	ld a,$4d		; $633d
	call playSound		; $633f
	jp interactionDelete		; $6342
	call checkInteractionState		; $6345
	jr nz,_label_09_161	; $6348
	ld a,$01		; $634a
	ld (de),a		; $634c
	ld e,$43		; $634d
	ld a,(de)		; $634f
	or a			; $6350
	jr nz,_label_09_160	; $6351
	call getThisRoomFlags		; $6353
	and $20			; $6356
	jp nz,interactionDelete		; $6358
_label_09_160:
	call objectGetShortPosition		; $635b
	ld ($ccc5),a		; $635e
_label_09_161:
	ld a,($ccc5)		; $6361
	inc a			; $6364
	ret nz			; $6365
	call getFreePartSlot		; $6366
	ret nz			; $6369
	ld (hl),$01		; $636a
	inc l			; $636c
	ld (hl),$0e		; $636d
	inc l			; $636f
	ld (hl),$01		; $6370
	ld a,($d008)		; $6372
	swap a			; $6375
	rrca			; $6377
	ld l,$c9		; $6378
	ld (hl),a		; $637a
	call objectCopyPosition		; $637b
	jp interactionDelete		; $637e
	ld bc,$2b00		; $6381
	call getThisRoomFlags		; $6384
	and $20			; $6387
	jr nz,_label_09_162	; $6389
	call $6391		; $638b
_label_09_162:
	jp interactionDelete		; $638e
	call getFreeInteractionSlot		; $6391
	ret nz			; $6394
	ld (hl),$60		; $6395
	inc l			; $6397
	ld (hl),b		; $6398
	inc l			; $6399
	ld (hl),c		; $639a
	jp objectCopyPosition		; $639b
	call checkInteractionState		; $639e
	jr nz,_label_09_163	; $63a1
	call returnIfScrollMode01Unset		; $63a3
	call getThisRoomFlags		; $63a6
	ld e,$4d		; $63a9
	ld a,(de)		; $63ab
	and (hl)		; $63ac
	jp nz,interactionDelete		; $63ad
	ld b,$cf		; $63b0
	ld e,$4b		; $63b2
	ld a,(de)		; $63b4
	ld c,a			; $63b5
	ld a,(bc)		; $63b6
	ld e,$43		; $63b7
	ld (de),a		; $63b9
	ld e,Interaction.state		; $63ba
	ld a,$01		; $63bc
	ld (de),a		; $63be
_label_09_163:
	ld a,($cd00)		; $63bf
	and $01			; $63c2
	jp z,interactionDelete		; $63c4
	ld e,$43		; $63c7
	ld a,(de)		; $63c9
	ld b,a			; $63ca
	ld e,$4b		; $63cb
	ld a,(de)		; $63cd
	ld l,a			; $63ce
	ld h,$cf		; $63cf
	ld a,b			; $63d1
	cp (hl)			; $63d2
	ret z			; $63d3
	call getThisRoomFlags		; $63d4
	ld e,$4d		; $63d7
	ld a,(de)		; $63d9
	or (hl)			; $63da
	ld (hl),a		; $63db
	jp interactionDelete		; $63dc
	ld e,Interaction.state		; $63df
	ld a,(de)		; $63e1
	rst_jumpTable			; $63e2
	jp hl			; $63e3
	ld h,e			; $63e4
.DB $f4				; $63e5
	ld h,e			; $63e6
	adc a			; $63e7
	ld h,c			; $63e8
	call getThisRoomFlags		; $63e9
	and $20			; $63ec
	jp nz,interactionDelete		; $63ee
	call interactionIncState		; $63f1
	call getThisRoomFlags		; $63f4
	and $20			; $63f7
	ret z			; $63f9
	ld hl,$cca4		; $63fa
	set 0,(hl)		; $63fd
	ld a,$01		; $63ff
	ld ($cc02),a		; $6401
	call interactionIncState		; $6404
	ld hl,$6710		; $6407
	jp interactionSetScript		; $640a
	call getThisRoomFlags		; $640d
	and $20			; $6410
	jp nz,interactionDelete		; $6412
	ld a,($ccba)		; $6415
	or a			; $6418
	ret z			; $6419
	ld bc,$2701		; $641a
	call createRingTreasure		; $641d
	ret nz			; $6420
	call objectCopyPosition		; $6421
	jp interactionDelete		; $6424
	ld e,Interaction.state		; $6427
	ld a,(de)		; $6429
	rst_jumpTable			; $642a
	inc sp			; $642b
	ld h,h			; $642c
	ld b,a			; $642d
	ld h,h			; $642e
	ld c,(hl)		; $642f
	ld h,h			; $6430
	ld a,h			; $6431
	ld h,h			; $6432
_label_09_164:
	call getThisRoomFlags		; $6433
	bit 5,(hl)		; $6436
	jp nz,interactionDelete		; $6438
	ld h,d			; $643b
	ld l,$44		; $643c
	ld (hl),$01		; $643e
	ld l,$70		; $6440
	ld b,$06		; $6442
	jp clearMemory		; $6444
	call $6483		; $6447
	ret nz			; $644a
	ld a,$02		; $644b
	ld (de),a		; $644d
	call $6483		; $644e
	jr nz,_label_09_164	; $6451
	ld a,($ccc6)		; $6453
	cp $2b			; $6456
	jr z,_label_09_165	; $6458
	cp $2a			; $645a
	ret nz			; $645c
_label_09_165:
	ld h,d			; $645d
	ld l,$70		; $645e
	ld a,($ccc7)		; $6460
	ld c,a			; $6463
_label_09_166:
	ldi a,(hl)		; $6464
	cp c			; $6465
	ret z			; $6466
	or a			; $6467
	jr nz,_label_09_166	; $6468
	dec l			; $646a
	ld (hl),c		; $646b
	ld a,l			; $646c
	cp $73			; $646d
	jr nc,_label_09_167	; $646f
	ret			; $6471
_label_09_167:
	ld l,$44		; $6472
	ld (hl),$03		; $6474
	ld hl,$66f3		; $6476
	call interactionSetScript		; $6479
	call interactionRunScript		; $647c
	jp c,interactionDelete		; $647f
	ret			; $6482
	ld a,($cc7e)		; $6483
	and $0f			; $6486
	cp $02			; $6488
	ret			; $648a
	ld bc,$4a00		; $648b
	jp $6384		; $648e
	call returnIfScrollMode01Unset		; $6491
	call getThisRoomFlags		; $6494
	bit 7,(hl)		; $6497
	jp nz,interactionDelete		; $6499
	bit 6,(hl)		; $649c
	jp nz,interactionDelete		; $649e
	call objectGetTileAtPosition		; $64a1
	cp $d6			; $64a4
	ret z			; $64a6
	ld a,($ccc0)		; $64a7
	and $7f			; $64aa
	cp $18			; $64ac
	ld b,$80		; $64ae
	jr z,_label_09_168	; $64b0
	ld b,$40		; $64b2
_label_09_168:
	call getThisRoomFlags		; $64b4
	or b			; $64b7
	ld (hl),a		; $64b8
	jp interactionDelete		; $64b9


interactionCode6bSubid11:
	ld e,Interaction.state		; $64bc
	ld a,(de)		; $64be
	rst_jumpTable			; $64bf
	.dw $64c6
	.dw $64e5
	.dw $6503
	ld a,$01		; $64c6
	ld (de),a		; $64c8
	ld a,($c610)		; $64c9
	cp $0c			; $64cc
	jp z,interactionDelete		; $64ce
	call getThisRoomFlags		; $64d1
	and $40			; $64d4
	jp nz,interactionDelete		; $64d6
	call getFreePartSlot		; $64d9
	ret nz			; $64dc
	ld (hl),$05		; $64dd
	inc l			; $64df
	ld (hl),$01		; $64e0
	jp objectCopyPosition		; $64e2

	ld a,($cc32)		; $64e5
	or a			; $64e8
	ret z			; $64e9
	ld a,$81		; $64ea
	ld ($cc02),a		; $64ec
	ld ($cca4),a		; $64ef
	ld ($ccab),a		; $64f2
	call getThisRoomFlags		; $64f5
	set 6,(hl)		; $64f8
	call interactionIncState		; $64fa
	ld hl,simpleScript_14_4e12		; $64fd
	jp interactionSetSimpleScript		; $6500
	call $621c		; $6503
	ret nz			; $6506
	call interactionRunSimpleScript		; $6507
	ret nc			; $650a
	xor a			; $650b
	ld ($cc02),a		; $650c
	ld ($cca4),a		; $650f
	ld ($ccab),a		; $6512
	jp interactionDelete		; $6515


; Cutscene outside onox's castle
interactionCode6bSubid12:
	ld a,$1d		; $6518
	call checkGlobalFlag		; $651a
	jp nz,interactionDelete		; $651d
	ld a,$1f		; $6520
	call checkGlobalFlag		; $6522
	jp nz,interactionDelete		; $6525
	ld a,$01		; $6528
	ld ($cca4),a		; $652a
	ld ($cc02),a		; $652d
	call returnIfScrollMode01Unset		; $6530
	ld a,$14		; $6533
	ld ($cc04),a		; $6535
	xor a			; $6538
	ld ($d008),a		; $6539
	call dropLinkHeldItem		; $653c
	call clearAllParentItems		; $653f
	jp interactionDelete		; $6542
	ld a,$22		; $6545
	call checkGlobalFlag		; $6547
	ret z			; $654a
	ld a,$23		; $654b
	call checkGlobalFlag		; $654d
	ret nz			; $6550
	ld a,$80		; $6551
	ld ($cc9f),a		; $6553
	jp interactionDelete		; $6556

interactionCode6bSubid14:
	ld h,d			; $6559
	ld l,$46		; $655a
	ld a,(hl)		; $655c
	or a			; $655d
	jr z,_label_09_169	; $655e
	dec (hl)		; $6560
	ret nz			; $6561
_label_09_169:
	call checkInteractionState		; $6562
	jr nz,_label_09_170	; $6565
	call interactionIncState		; $6567
	ld hl,simpleScript_14_4c6a		; $656a
	jp interactionSetSimpleScript		; $656d
_label_09_170:
	call interactionRunSimpleScript		; $6570
	ret nc			; $6573
	ld hl,$cfc0		; $6574
	set 7,(hl)		; $6577
	jp interactionDelete		; $6579

	ld a,$17		; $657c
	call checkGlobalFlag		; $657e
	jp z,interactionDelete		; $6581
	ld b,$5e		; $6584
	call objectCreateInteractionWithSubid00		; $6586
	jp interactionDelete		; $6589
	call checkInteractionState		; $658c
	jr nz,_label_09_171	; $658f
	call objectGetTileAtPosition		; $6591
	ld h,d			; $6594
	ld l,$49		; $6595
	ld (hl),a		; $6597
	ld l,$44		; $6598
	inc (hl)		; $659a
_label_09_171:
	ld a,$01		; $659b
	ld ($ccab),a		; $659d
	call objectGetTileAtPosition		; $65a0
	ld e,$49		; $65a3
	ld a,(de)		; $65a5
	cp (hl)			; $65a6
	ret z			; $65a7
	xor a			; $65a8
	ld ($ccab),a		; $65a9
	jp interactionDelete		; $65ac
	call checkInteractionState		; $65af
	jr nz,_label_09_172	; $65b2
	xor a			; $65b4
	ld ($cc32),a		; $65b5
	call getThisRoomFlags		; $65b8
	and $40			; $65bb
	jp nz,interactionDelete		; $65bd
	call interactionIncState		; $65c0
_label_09_172:
	ld a,($cc32)		; $65c3
	or a			; $65c6
	ret z			; $65c7
	call getThisRoomFlags		; $65c8
	set 6,(hl)		; $65cb
	ld a,$4d		; $65cd
	call playSound		; $65cf
	ld bc,$0047		; $65d2
	ld e,$08		; $65d5
	call $65e5		; $65d7
	ld bc,$0114		; $65da
	ld e,$06		; $65dd
	call $65e5		; $65df
	jp interactionDelete		; $65e2
	call getFreePartSlot		; $65e5
	ret nz			; $65e8
	ld (hl),$0c		; $65e9
	ld l,$c7		; $65eb
	ld (hl),e		; $65ed
	ld l,$c9		; $65ee
	ld (hl),b		; $65f0
	ld l,$cb		; $65f1
	ld (hl),c		; $65f3
	ret			; $65f4
	call getThisRoomFlags		; $65f5
	and $20			; $65f8
	jp nz,interactionDelete		; $65fa
	ld c,$02		; $65fd
	call getRandomRingOfGivenTier		; $65ff
	ld b,c			; $6602
	ld c,$03		; $6603
	jp $641d		; $6605
	ld bc,$3404		; $6608
	jp $6384		; $660b
	ld bc,$3405		; $660e
	jp $6384		; $6611
	call checkInteractionState		; $6614
	jr nz,_label_09_173	; $6617
	call objectGetTileAtPosition		; $6619
	cp $04			; $661c
	ret nz			; $661e
	ld a,l			; $661f
	ld ($ccc5),a		; $6620
	ld e,Interaction.state		; $6623
	ld a,$01		; $6625
	ld (de),a		; $6627
	ret			; $6628
_label_09_173:
	call returnIfScrollMode01Unset		; $6629
	call objectGetTileAtPosition		; $662c
	cp $04			; $662f
	ret z			; $6631
_label_09_174:
	ld c,l			; $6632
	ld a,c			; $6633
	ld ($cca8),a		; $6634
	ld a,$e7		; $6637
	call setTile		; $6639
	ld a,$4d		; $663c
	call playSound		; $663e
	jp interactionDelete		; $6641
	call returnIfScrollMode01Unset		; $6644
	call objectGetTileAtPosition		; $6647
	cp $01			; $664a
	ret z			; $664c
	ld a,l			; $664d
	ld ($ccc5),a		; $664e
	jr _label_09_174		; $6651
	call checkInteractionState		; $6653
	jr nz,_label_09_175	; $6656
	ld a,$01		; $6658
	ld (de),a		; $665a
	call getThisRoomFlags		; $665b
	bit 7,(hl)		; $665e
	jp nz,interactionDelete		; $6660
	ld hl,$7e96		; $6663
	jp parseGivenObjectData		; $6666
_label_09_175:
	ld a,($cca9)		; $6669
	cp $02			; $666c
	ret nz			; $666e
	call getThisRoomFlags		; $666f
	set 7,(hl)		; $6672
	jp interactionDelete		; $6674
	call checkInteractionState		; $6677
	jr nz,_label_09_176	; $667a
	ld a,$24		; $667c
	call checkGlobalFlag		; $667e
	jp z,interactionDelete		; $6681
	ld a,$24		; $6684
	call unsetGlobalFlag		; $6686
	ld h,d			; $6689
	ld l,$44		; $668a
	inc (hl)		; $668c
	ld l,$46		; $668d
	ld (hl),$3c		; $668f
_label_09_176:
	ld a,$01		; $6691
	ld ($cca4),a		; $6693
	call interactionDecCounter1		; $6696
	ret nz			; $6699
	xor a			; $669a
	ld ($cc02),a		; $669b
	ld ($cca4),a		; $669e
	ld bc,$501b		; $66a1
	call showText		; $66a4
	jp interactionDelete		; $66a7
	ld bc,$3404		; $66aa
	jp $6384		; $66ad
	ld bc,$1900		; $66b0
	jp $6384		; $66b3
	ld a,($cc4e)		; $66b6
	or a			; $66b9
	jp nz,interactionDelete		; $66ba
	call getThisRoomFlags		; $66bd
	and $20			; $66c0
	jp nz,interactionDelete		; $66c2
	ld bc,$4700		; $66c5
	call $6391		; $66c8
	ld b,h			; $66cb
	ld a,$06		; $66cc
	ldi (hl),a		; $66ce
	ld (hl),a		; $66cf
	call getFreePartSlot		; $66d0
	jp nz,interactionDelete		; $66d3
	ld (hl),$17		; $66d6
	ld l,$d6		; $66d8
	ld (hl),$40		; $66da
	inc l			; $66dc
	ld (hl),b		; $66dd
	jp interactionDelete		; $66de
	call getThisRoomFlags		; $66e1
	and $40			; $66e4
	jp z,interactionDelete		; $66e6
	ld bc,$5200		; $66e9
	jp $6384		; $66ec
	call checkInteractionState		; $66ef
	jr nz,_label_09_179	; $66f2
	call getThisRoomFlags		; $66f4
	and $80			; $66f7
	jp nz,interactionDelete		; $66f9
	ld hl,$ccba		; $66fc
	ld a,(hl)		; $66ff
	cp $04			; $6700
	jr nz,_label_09_177	; $6702
	set 7,(hl)		; $6704
_label_09_177:
	cp $85			; $6706
	jr nz,_label_09_178	; $6708
	set 6,(hl)		; $670a
_label_09_178:
	and $07			; $670c
	cp $07			; $670e
	ret nz			; $6710
	ld a,$1e		; $6711
	ld e,$46		; $6713
	ld (de),a		; $6715
	jp interactionIncState		; $6716
_label_09_179:
	call interactionDecCounter1		; $6719
	ret nz			; $671c
	ld a,($ccba)		; $671d
	bit 6,a			; $6720
	ld b,$5a		; $6722
	jr z,_label_09_180	; $6724
	ld c,$5c		; $6726
	ld a,$05		; $6728
	call setTile		; $672a
	call objectCreatePuff		; $672d
	call getThisRoomFlags		; $6730
	set 7,(hl)		; $6733
	ld b,$4d		; $6735
_label_09_180:
	ld a,b			; $6737
	call playSound		; $6738
	jp interactionDelete		; $673b
	ld a,($cc31)		; $673e
	and $0f			; $6741
	cp $0e			; $6743
	ld a,$01		; $6745
	jr z,_label_09_181	; $6747
	dec a			; $6749
_label_09_181:
	ld ($ccba),a		; $674a
	ret			; $674d
	call checkInteractionState		; $674e
	jr nz,_label_09_182	; $6751
	ld a,($cc30)		; $6753
	or a			; $6756
	ret nz			; $6757
	call interactionIncState		; $6758
	ld l,$46		; $675b
	ld (hl),$3c		; $675d
_label_09_182:
	call interactionDecCounter1		; $675f
	ret nz			; $6762
	call objectCreatePuff		; $6763
	call objectGetShortPosition		; $6766
	ld c,a			; $6769
	ld a,$44		; $676a
	call setTile		; $676c
	xor a			; $676f
	ld ($cbca),a		; $6770
	jp interactionDelete		; $6773
	call checkInteractionState		; $6776
	jp nz,interactionRunScript		; $6779
	ld hl,$6662		; $677c
	call interactionSetScript		; $677f
	jp interactionIncState		; $6782

interactionCode6c:
	ld e,Interaction.subid		; $6785
	ld a,(de)		; $6787
	rst_jumpTable			; $6788
	sub a			; $6789
	ld h,a			; $678a
	ld (hl),c		; $678b
	ld l,b			; $678c

interactionCode6d:
	ld e,Interaction.subid		; $678d
	ld a,(de)		; $678f
	rst_jumpTable			; $6790
	dec a			; $6791
	ld l,c			; $6792
	ld d,h			; $6793
	ld l,d			; $6794
	ld d,h			; $6795
	ld l,d			; $6796
	ld e,Interaction.state2		; $6797
	ld a,(de)		; $6799
	rst_jumpTable			; $679a
	sbc a			; $679b
	ld h,a			; $679c
	ld d,$68		; $679d
	ld a,$01		; $679f
	ld (de),a		; $67a1
	ld a,TREASURE_ESSENCE		; $67a2
	call checkTreasureObtained		; $67a4
	and $01			; $67a7
	jp z,interactionDelete		; $67a9
	call getThisRoomFlags		; $67ac
	bit 7,a			; $67af
	jp nz,interactionDelete		; $67b1
	call interactionSetAlwaysUpdateBit		; $67b4
	call objectSetReservedBit1		; $67b7
	ld a,$01		; $67ba
	ld ($cca4),a		; $67bc
	ld ($cc02),a		; $67bf
	ld e,$79		; $67c2
	ld a,($cc4c)		; $67c4
	ld (de),a		; $67c7
	xor a			; $67c8
	ld (wActiveMusic),a		; $67c9
	ld a,$0b		; $67cc
	call playSound		; $67ce
	ld a,$80		; $67d1
	ld ($cc9f),a		; $67d3
	ld a,$01		; $67d6
	ld ($ccab),a		; $67d8
	ld bc,$016c		; $67db
	call $699c		; $67de
	ld e,a			; $67e1
	ld bc,$67f1		; $67e2
	call addDoubleIndexToBc		; $67e5
	call $69ac		; $67e8
	ld a,e			; $67eb
	cp $04			; $67ec
	jr z,_label_09_184	; $67ee
	ret			; $67f0
	jr z,_label_09_186	; $67f1
	ld e,b			; $67f3
	ld l,b			; $67f4
	ld e,b			; $67f5
	ld e,b			; $67f6
	ld e,b			; $67f7
	ld e,b			; $67f8
	ld e,b			; $67f9
	ld e,b			; $67fa
_label_09_183:
	ld a,($cc4c)		; $67fb
	cp $cb			; $67fe
	jp z,interactionDelete		; $6800
	ld a,($cc62)		; $6803
	ld (wActiveMusic),a		; $6806
	call playSound		; $6809
_label_09_184:
	xor a			; $680c
	ld ($cc9f),a		; $680d
	ld ($ccab),a		; $6810
	jp interactionDelete		; $6813
	ld e,$78		; $6816
	ld a,(de)		; $6818
	rst_jumpTable			; $6819
	ld e,$68		; $681a
	ld sp,$fa68		; $681c
	ld c,h			; $681f
	call z,$cbfe		; $6820
	jr nz,_label_09_183	; $6823
	ld a,($cc9e)		; $6825
	cp $02			; $6828
	ret nz			; $682a
	ld e,$78		; $682b
	ld a,$01		; $682d
	ld (de),a		; $682f
	ret			; $6830
	ld a,($cfc0)		; $6831
	or a			; $6834
	jr z,_label_09_185	; $6835
	ld e,$7a		; $6837
	ld a,$01		; $6839
	ld (de),a		; $683b
	xor a			; $683c
	ld ($ccab),a		; $683d
_label_09_185:
	ld e,$79		; $6840
	ld a,(de)		; $6842
_label_09_186:
	ld b,a			; $6843
	ld a,($cc4c)		; $6844
	cp b			; $6847
	ret z			; $6848
	ld (de),a		; $6849
	cp $cb			; $684a
	jr z,_label_09_183	; $684c
	ld e,$7a		; $684e
	ld a,(de)		; $6850
	or a			; $6851
	jr z,_label_09_183	; $6852
	xor a			; $6854
	ld (de),a		; $6855
	ld h,d			; $6856
	ld l,$46		; $6857
	inc (hl)		; $6859
	ld a,(hl)		; $685a
	ld bc,$686c		; $685b
	call addAToBc		; $685e
	ld a,(bc)		; $6861
	ld b,a			; $6862
	ld a,($cc4c)		; $6863
	cp b			; $6866
	jr nz,_label_09_183	; $6867
	jp $67d1		; $6869
	res 7,e			; $686c
	xor e			; $686e
	sbc e			; $686f
	sbc d			; $6870
	ld e,Interaction.state2		; $6871
	ld a,(de)		; $6873
	rst_jumpTable			; $6874
	add c			; $6875
	ld l,b			; $6876
	sbc h			; $6877
	ld l,b			; $6878
	and a			; $6879
	ld l,b			; $687a
	cp c			; $687b
	ld l,b			; $687c
	rst_jumpTable			; $687d
	ld l,b			; $687e
	ret c			; $687f
	ld l,b			; $6880
	ld a,$01		; $6881
	ld (de),a		; $6883
	call interactionInitGraphics		; $6884
	ld e,$43		; $6887
	ld a,(de)		; $6889
	ld hl,$6931		; $688a
	rst_addDoubleIndex			; $688d
	ldi a,(hl)		; $688e
	ld h,(hl)		; $688f
	ld l,a			; $6890
	call interactionSetScript		; $6891
	ld e,$6d		; $6894
	ld a,$08		; $6896
	ld (de),a		; $6898
	call objectSetVisiblec2		; $6899
	call interactionRunScript		; $689c
	jp c,interactionDelete		; $689f
	ld c,$20		; $68a2
	jp objectUpdateSpeedZ_paramC		; $68a4
	call interactionRunScript		; $68a7
	jp c,interactionDelete		; $68aa
	ld c,$20		; $68ad
	call objectUpdateSpeedZ_paramC		; $68af
	ret nz			; $68b2
	ld bc,$fe40		; $68b3
	jp objectSetSpeedZ		; $68b6
_label_09_187:
	call interactionAnimate		; $68b9
	call $68a2		; $68bc
	ret nz			; $68bf
	call interactionRunScript		; $68c0
	jp c,interactionDelete		; $68c3
	ret			; $68c6
	ld e,$7b		; $68c7
	ld a,(de)		; $68c9
	inc a			; $68ca
	jr z,_label_09_188	; $68cb
	jr _label_09_187		; $68cd
_label_09_188:
	ld hl,$6771		; $68cf
	call interactionSetScript		; $68d2
	jp interactionRunScript		; $68d5
	call interactionAnimate		; $68d8
	call $68a2		; $68db
	ret nz			; $68de
	ld a,$09		; $68df
	call objectGetShortPosition_withYOffset		; $68e1
	ld c,a			; $68e4
	ld b,$ce		; $68e5
	ld a,(bc)		; $68e7
	cp $ff			; $68e8
	jr z,_label_09_189	; $68ea
	or a			; $68ec
	jr nz,_label_09_190	; $68ed
_label_09_189:
	ld a,$10		; $68ef
	jr _label_09_192		; $68f1
_label_09_190:
	ld e,$6d		; $68f3
	ld a,(de)		; $68f5
	ldh (<hFF8B),a	; $68f6
	ld e,$49		; $68f8
	ld (de),a		; $68fa
	call convertAngleDeToDirection		; $68fb
	xor $02			; $68fe
	sub $02			; $6900
	add c			; $6902
	ld c,a			; $6903
	ld a,(bc)		; $6904
	or a			; $6905
	ldh a,(<hFF8B)	; $6906
	jr z,_label_09_192	; $6908
	ld e,$6d		; $690a
	ld a,(de)		; $690c
	cp $08			; $690d
	jr z,_label_09_191	; $690f
	ld a,$08		; $6911
	ld (de),a		; $6913
	jr _label_09_192		; $6914
_label_09_191:
	ld a,$18		; $6916
	ld (de),a		; $6918
_label_09_192:
	ld e,$49		; $6919
	ld (de),a		; $691b
	call objectApplySpeed		; $691c
	ld e,$4b		; $691f
	ld a,(de)		; $6921
	cp $90			; $6922
	jr nc,_label_09_193	; $6924
	ret			; $6926
_label_09_193:
	xor a			; $6927
	ld ($cca4),a		; $6928
	ld ($ccab),a		; $692b
	jp interactionDelete		; $692e
	rla			; $6931
	ld h,a			; $6932
	dec l			; $6933
	ld h,a			; $6934
	ld b,c			; $6935
	ld h,a			; $6936
	ld d,l			; $6937
	ld h,a			; $6938
	ld l,l			; $6939
	ld h,a			; $693a
	ld (hl),c		; $693b
	ld h,a			; $693c
	ld e,Interaction.state		; $693d
	ld a,(de)		; $693f
	rst_jumpTable			; $6940
	ld c,c			; $6941
	ld l,c			; $6942
	or l			; $6943
	ld l,c			; $6944
	call nc,$3369		; $6945
	ld l,d			; $6948
	ld a,$01		; $6949
	ld (de),a		; $694b
	ld a,$10		; $694c
	call checkGlobalFlag		; $694e
	jp nz,interactionDelete		; $6951
	ld e,$40		; $6954
	ld a,$83		; $6956
	ld (de),a		; $6958
	ld a,($cc4c)		; $6959
	ld ($cfd1),a		; $695c
	ld a,$10		; $695f
	call setGlobalFlag		; $6961
	ld a,$01		; $6964
	ld ($ccab),a		; $6966
	ld bc,$016d		; $6969
	call $699c		; $696c
	ld bc,pollInput		; $696f
	call $699c		; $6972
	ld a,TREASURE_FEATHER		; $6975
	call checkTreasureObtained		; $6977
	ld a,$01		; $697a
	jr nc,_label_09_194	; $697c
	call getRandomNumber		; $697e
	and $01			; $6981
_label_09_194:
	ld ($cfd0),a		; $6983
	ld e,$46		; $6986
	ld a,(de)		; $6988
	cp $06			; $6989
	jp z,$6995		; $698b
	ret			; $698e
_label_09_195:
	ld a,(wActiveMusic)		; $698f
	call playSound		; $6992
	xor a			; $6995
	ld ($cc9e),a		; $6996
	jp interactionDelete		; $6999
	call getFreeInteractionSlot		; $699c
	dec l			; $699f
	set 7,(hl)		; $69a0
	inc l			; $69a2
	ld (hl),c		; $69a3
	inc l			; $69a4
	ld (hl),b		; $69a5
	inc l			; $69a6
	ld e,$46		; $69a7
	ld a,(de)		; $69a9
	ld (hl),a		; $69aa
	ret			; $69ab
	ld l,$4b		; $69ac
	ld a,(bc)		; $69ae
	ldi (hl),a		; $69af
	inc l			; $69b0
	inc bc			; $69b1
	ld a,(bc)		; $69b2
	ld (hl),a		; $69b3
	ret			; $69b4
	ld a,($cd00)		; $69b5
	and $01			; $69b8
	ret z			; $69ba
	ld a,($cc9e)		; $69bb
	cp $02			; $69be
	ret nz			; $69c0
	xor a			; $69c1
	ld ($cfc0),a		; $69c2
	ld e,Interaction.state		; $69c5
	ld a,$02		; $69c7
	ld (de),a		; $69c9
	ld a,$11		; $69ca
	call unsetGlobalFlag		; $69cc
	ld a,$0b		; $69cf
	jp playSound		; $69d1
	ld a,($cfc0)		; $69d4
	cp $ff			; $69d7
	jr z,_label_09_197	; $69d9
	and $03			; $69db
	cp $03			; $69dd
	jr nz,_label_09_196	; $69df
	ld e,$7a		; $69e1
	ld (de),a		; $69e3
	xor a			; $69e4
	ld ($ccab),a		; $69e5
	ld ($cfc0),a		; $69e8
_label_09_196:
	ld a,($cc4c)		; $69eb
	ld b,a			; $69ee
	ld a,($cfd1)		; $69ef
	cp b			; $69f2
	ret z			; $69f3
	ld a,b			; $69f4
	ld ($cfd1),a		; $69f5
	cp $51			; $69f8
	jr z,_label_09_195	; $69fa
	ld e,$7a		; $69fc
	ld a,(de)		; $69fe
	cp $03			; $69ff
	jr nz,_label_09_195	; $6a01
	xor a			; $6a03
	ld (de),a		; $6a04
	ld h,d			; $6a05
	ld l,$46		; $6a06
	inc (hl)		; $6a08
	ld a,(hl)		; $6a09
	ld bc,$6a1c		; $6a0a
	call addAToBc		; $6a0d
	ld a,(bc)		; $6a10
	ld b,a			; $6a11
	ld a,($cc4c)		; $6a12
	cp b			; $6a15
	jp nz,_label_09_195		; $6a16
	jp $6964		; $6a19
	ld d,c			; $6a1c
	ld h,c			; $6a1d
	ld (hl),c		; $6a1e
	ld (hl),b		; $6a1f
	ld h,b			; $6a20
	ld d,b			; $6a21
	ld h,b			; $6a22
_label_09_197:
	ld e,Interaction.state		; $6a23
	ld a,$03		; $6a25
	ld (de),a		; $6a27
	ld a,$01		; $6a28
	ld ($cc02),a		; $6a2a
	ld bc,$2804		; $6a2d
	jp showText		; $6a30
	ld a,($cfc0)		; $6a33
	or a			; $6a36
	ret nz			; $6a37
	ld a,$11		; $6a38
	call setGlobalFlag		; $6a3a
	ld a,$10		; $6a3d
	call unsetGlobalFlag		; $6a3f
	xor a			; $6a42
	ld ($ccab),a		; $6a43
	ld hl,$6a4f		; $6a46
	call setWarpDestVariables		; $6a49
	jp interactionDelete		; $6a4c
	add c			; $6a4f
	ld d,c			; $6a50
	nop			; $6a51
	jr z,_label_09_198	; $6a52
	ld e,Interaction.state		; $6a54
	ld a,(de)		; $6a56
_label_09_198:
	rst_jumpTable			; $6a57
	ld e,(hl)		; $6a58
	ld l,d			; $6a59
	or d			; $6a5a
	ld l,d			; $6a5b
	rst $38			; $6a5c
	ld l,d			; $6a5d
	ld a,$01		; $6a5e
	ld (de),a		; $6a60
	call interactionInitGraphics		; $6a61
	ld e,$50		; $6a64
	ld a,$28		; $6a66
	ld (de),a		; $6a68
	ld e,Interaction.subid		; $6a69
	ld a,(de)		; $6a6b
	ld b,a			; $6a6c
	dec a			; $6a6d
	ld a,$02		; $6a6e
	jr z,_label_09_199	; $6a70
	dec a			; $6a72
_label_09_199:
	ld e,$5c		; $6a73
	ld (de),a		; $6a75
	ld a,b			; $6a76
	dec a			; $6a77
	ld hl,$6a92		; $6a78
	rst_addDoubleIndex			; $6a7b
	ldi a,(hl)		; $6a7c
	ld h,(hl)		; $6a7d
	ld l,a			; $6a7e
	ld e,$43		; $6a7f
	ld a,(de)		; $6a81
	rst_addDoubleIndex			; $6a82
	ldi a,(hl)		; $6a83
	ld h,(hl)		; $6a84
	ld l,a			; $6a85
	call interactionSetScript		; $6a86
	call interactionRunScript		; $6a89
	call interactionRunScript		; $6a8c
	jp objectSetVisiblec2		; $6a8f
	sub (hl)		; $6a92
	ld l,d			; $6a93
	and h			; $6a94
	ld l,d			; $6a95
	and c			; $6a96
	ld h,a			; $6a97
.DB $fd				; $6a98
	ld h,a			; $6a99
	ld d,c			; $6a9a
	ld l,b			; $6a9b
	sbc d			; $6a9c
	ld l,b			; $6a9d
	call c,$2668		; $6a9e
	ld l,c			; $6aa1
	ld l,(hl)		; $6aa2
	ld l,c			; $6aa3
	sub b			; $6aa4
	ld l,c			; $6aa5
	xor a			; $6aa6
	ld l,c			; $6aa7
	cp (hl)			; $6aa8
	ld l,c			; $6aa9
	call $dc69		; $6aaa
	ld l,c			; $6aad
.DB $eb				; $6aae
	ld l,c			; $6aaf
	ld a,($fa69)		; $6ab0
	and a			; $6ab3
	call z,$20b7		; $6ab4
	dec h			; $6ab7
	ld e,$7b		; $6ab8
	ld a,(de)		; $6aba
	or a			; $6abb
	jr nz,_label_09_200	; $6abc
	ld a,($cfc0)		; $6abe
	cp $ff			; $6ac1
	jr z,_label_09_200	; $6ac3
	call interactionAnimate		; $6ac5
	call interactionAnimate		; $6ac8
	call interactionRunScript		; $6acb
	jp c,interactionDelete		; $6ace
	ld c,$60		; $6ad1
	call objectUpdateSpeedZ_paramC		; $6ad3
	ret nz			; $6ad6
	ld bc,$fe00		; $6ad7
	jp objectSetSpeedZ		; $6ada
_label_09_200:
	ld a,$ff		; $6add
	ld ($cfc0),a		; $6adf
	ld a,$01		; $6ae2
	ld ($cca4),a		; $6ae4
	ld h,d			; $6ae7
	ld l,$44		; $6ae8
	inc (hl)		; $6aea
	ld l,$50		; $6aeb
	ld (hl),$64		; $6aed
	call objectGetAngleTowardLink		; $6aef
	add $10			; $6af2
	and $1f			; $6af4
	ld e,$49		; $6af6
	ld (de),a		; $6af8
	call convertAngleDeToDirection		; $6af9
	jp interactionSetAnimation		; $6afc
	call interactionAnimate		; $6aff
	call interactionAnimate		; $6b02
	call $6ad1		; $6b05
	call retIfTextIsActive		; $6b08
	call objectApplySpeed		; $6b0b
	call objectCheckWithinScreenBoundary		; $6b0e
	ret c			; $6b11
	call objectSetInvisible		; $6b12
	ld h,d			; $6b15
	ld l,$44		; $6b16
	inc (hl)		; $6b18
	jr _label_09_201		; $6b19
_label_09_201:
	xor a			; $6b1b
	ld ($cfc0),a		; $6b1c
	jp interactionDelete		; $6b1f

interactionCode6e:
	ld e,Interaction.subid		; $6b22
	ld a,(de)		; $6b24
	rst_jumpTable			; $6b25
	inc l			; $6b26
	ld l,e			; $6b27
	cp d			; $6b28
	ld l,e			; $6b29
	jr z,_label_09_203	; $6b2a
	ld e,Interaction.state		; $6b2c
	ld a,(de)		; $6b2e
	rst_jumpTable			; $6b2f
	ld (hl),$6b		; $6b30
	ld e,c			; $6b32
	ld l,e			; $6b33
	adc c			; $6b34
	ld l,e			; $6b35
	ld a,$01		; $6b36
	ld (de),a		; $6b38
	call interactionInitGraphics		; $6b39
	ld a,$17		; $6b3c
	call loseTreasure		; $6b3e
	ld bc,$fd80		; $6b41
	call objectSetSpeedZ		; $6b44
	ld l,$50		; $6b47
	ld (hl),$0f		; $6b49
	ld l,$49		; $6b4b
	ld (hl),$18		; $6b4d
	ld l,$46		; $6b4f
	ld (hl),$3c		; $6b51
	call interactionSetAlwaysUpdateBit		; $6b53
	jp objectSetVisiblec0		; $6b56
	call objectApplySpeed		; $6b59
	ld h,d			; $6b5c
	ld l,$4d		; $6b5d
	ld a,$18		; $6b5f
	cp (hl)			; $6b61
	jr c,_label_09_202	; $6b62
	ld (hl),a		; $6b64
_label_09_202:
	call interactionAnimate		; $6b65
	ld c,$14		; $6b68
	call objectUpdateSpeedZ_paramC		; $6b6a
	call interactionDecCounter1		; $6b6d
	ret nz			; $6b70
	ld l,$4f		; $6b71
	ld a,(hl)		; $6b73
	ld l,$52		; $6b74
	ld (hl),a		; $6b76
	ld l,$44		; $6b77
	inc (hl)		; $6b79
	ld l,$4d		; $6b7a
	ld a,(hl)		; $6b7c
	ld ($cfc1),a		; $6b7d
	ld hl,$cfc0		; $6b80
	set 2,(hl)		; $6b83
	xor a			; $6b85
	call interactionSetAnimation		; $6b86
	ld hl,$cfc0		; $6b89
	bit 7,(hl)		; $6b8c
	jp nz,interactionDelete		; $6b8e
	ld a,(wFrameCounter)		; $6b91
	and $03			; $6b94
	ret nz			; $6b96
	ld h,d			; $6b97
_label_09_203:
	ld l,$46		; $6b98
	inc (hl)		; $6b9a
	ld a,(hl)		; $6b9b
	and $0f			; $6b9c
	ld hl,$6baa		; $6b9e
	rst_addAToHl			; $6ba1
	ld e,$52		; $6ba2
	ld a,(de)		; $6ba4
	add (hl)		; $6ba5
	ld e,$4f		; $6ba6
	ld (de),a		; $6ba8
	ret			; $6ba9
	nop			; $6baa
	nop			; $6bab
	rst $38			; $6bac
	rst $38			; $6bad
	rst $38			; $6bae
	cp $fe			; $6baf
	cp $fe			; $6bb1
	cp $fe			; $6bb3
	rst $38			; $6bb5
	rst $38			; $6bb6
	rst $38			; $6bb7
	rst $38			; $6bb8
	nop			; $6bb9
	ld e,Interaction.state		; $6bba
	ld a,(de)		; $6bbc
	rst_jumpTable			; $6bbd
	call nz,$0c6b		; $6bbe
	dec h			; $6bc1
	push de			; $6bc2
	ld l,e			; $6bc3
	ld a,$01		; $6bc4
	ld (de),a		; $6bc6
	call getThisRoomFlags		; $6bc7
	bit 6,(hl)		; $6bca
	jp nz,interactionDelete		; $6bcc
	ld hl,$6a28		; $6bcf
	jp interactionSetScript		; $6bd2
	ld e,Interaction.state2		; $6bd5
	ld a,(de)		; $6bd7
	rst_jumpTable			; $6bd8
.DB $dd				; $6bd9
	ld l,e			; $6bda
	pop af			; $6bdb
	ld l,e			; $6bdc
	ld a,$01		; $6bdd
	ld (de),a		; $6bdf
	ld bc,$fe00		; $6be0
	call objectSetSpeedZ		; $6be3
	ld l,$4b		; $6be6
	ld a,($d00b)		; $6be8
	ldi (hl),a		; $6beb
	inc l			; $6bec
	ld a,($d00d)		; $6bed
	ld (hl),a		; $6bf0
	ld a,(wFrameCounter)		; $6bf1
	rrca			; $6bf4
	call c,$6c19		; $6bf5
	call objectApplySpeed		; $6bf8
	ld e,$4b		; $6bfb
	ld a,(de)		; $6bfd
	cp $08			; $6bfe
	jr nc,_label_09_204	; $6c00
	ld e,$49		; $6c02
	ld a,$0c		; $6c04
	ld (de),a		; $6c06
_label_09_204:
	ld c,$40		; $6c07
	call objectUpdateSpeedZAndBounce		; $6c09
	jr nc,_label_09_205	; $6c0c
	call $6c22		; $6c0e
	ld a,$02		; $6c11
	ld ($cc6b),a		; $6c13
	jp interactionDelete		; $6c16
	ld hl,$d008		; $6c19
	ld a,(hl)		; $6c1c
	inc a			; $6c1d
	and $03			; $6c1e
	ld (hl),a		; $6c20
	ret			; $6c21
_label_09_205:
	ld hl,$d000		; $6c22
	jp objectCopyPosition		; $6c25
	ld a,$0f		; $6c28
	call unsetGlobalFlag		; $6c2a
	ld a,$10		; $6c2d
	call unsetGlobalFlag		; $6c2f
	ld a,$11		; $6c32
	call unsetGlobalFlag		; $6c34
	jp interactionDelete		; $6c37

interactionCode70:
	ld e,Interaction.subid		; $6c3a
	ld a,(de)		; $6c3c
	or a			; $6c3d
	jr nz,_label_09_208	; $6c3e
	call checkInteractionState		; $6c40
	jr nz,_label_09_207	; $6c43
	ld a,$01		; $6c45
	ld (de),a		; $6c47
	ld a,($cc66)		; $6c48
	cp $04			; $6c4b
	ld hl,$6a56		; $6c4d
	jr z,_label_09_206	; $6c50
	ld hl,$6a61		; $6c52
_label_09_206:
	call interactionSetScript		; $6c55
	call interactionInitGraphics		; $6c58
	jp objectSetVisiblec2		; $6c5b
_label_09_207:
	call interactionRunScript		; $6c5e
	ld c,$0e		; $6c61
	call objectUpdateSpeedZ_paramC		; $6c63
	jp npcFaceLinkAndAnimate		; $6c66
_label_09_208:
	call returnIfScrollMode01Unset		; $6c69
	call interactionDeleteAndRetIfEnabled02		; $6c6c
	ld a,$d9		; $6c6f
	call findTileInRoom		; $6c71
	jr nz,_label_09_210	; $6c74
	ld b,$00		; $6c76
_label_09_209:
	inc b			; $6c78
	dec l			; $6c79
	call backwardsSearch		; $6c7a
	jr z,_label_09_209	; $6c7d
	ld a,b			; $6c7f
	cp $04			; $6c80
	jr z,_label_09_211	; $6c82
_label_09_210:
	ld a,$25		; $6c84
	jp setGlobalFlag		; $6c86
_label_09_211:
	ld a,$25		; $6c89
	jp unsetGlobalFlag		; $6c8b

interactionCode71:
	ld a,($cc34)		; $6c8e
	or a			; $6c91
	jr z,_label_09_212	; $6c92
	xor a			; $6c94
	ld ($cca4),a		; $6c95
	jp interactionDelete		; $6c98
_label_09_212:
	ld e,Interaction.subid		; $6c9b
	ld a,(de)		; $6c9d
	rst_jumpTable			; $6c9e
	or e			; $6c9f
	ld l,h			; $6ca0
.DB $eb				; $6ca1
	ld l,h			; $6ca2
	ld b,b			; $6ca3
	ld l,l			; $6ca4
	daa			; $6ca5
	ld l,(hl)		; $6ca6
	ret nc			; $6ca7
	ld l,(hl)		; $6ca8
	ld hl,sp+$6e		; $6ca9
	add l			; $6cab
	ld l,l			; $6cac
	rla			; $6cad
	ld l,a			; $6cae
	ldi (hl),a		; $6caf
	ld l,a			; $6cb0
	ld l,l			; $6cb1
	ld l,a			; $6cb2
	ld e,Interaction.state		; $6cb3
	ld a,(de)		; $6cb5
	rst_jumpTable			; $6cb6
	cp e			; $6cb7
	ld l,h			; $6cb8
	ld (hl),$6d		; $6cb9
	ld a,$01		; $6cbb
	ld (de),a		; $6cbd
	ld a,($cc48)		; $6cbe
	and $01			; $6cc1
	jr z,_label_09_213	; $6cc3
	ld a,($d101)		; $6cc5
	cp $0b			; $6cc8
	jr nz,_label_09_213	; $6cca
	ld a,($c610)		; $6ccc
	cp $0b			; $6ccf
	jp z,interactionDelete		; $6cd1
	ld a,$0a		; $6cd4
	ld hl,$d104		; $6cd6
	ldi (hl),a		; $6cd9
	ld l,$03		; $6cda
	ld a,$02		; $6cdc
	ld (hl),a		; $6cde
	ld l,$30		; $6cdf
	ld a,(hl)		; $6ce1
	ld l,$3f		; $6ce2
	ld (hl),a		; $6ce4
	ld hl,$6ba9		; $6ce5
	jp interactionSetScript		; $6ce8
	ld e,Interaction.state		; $6ceb
	ld a,(de)		; $6ced
	rst_jumpTable			; $6cee
	rst $30			; $6cef
	ld l,h			; $6cf0
	ld (hl),$6d		; $6cf1
	ld d,c			; $6cf3
	ld l,(hl)		; $6cf4
	xor a			; $6cf5
	ld l,(hl)		; $6cf6
	ld a,($d101)		; $6cf7
	cp $0d			; $6cfa
	jr nz,_label_09_213	; $6cfc
	ld a,($c610)		; $6cfe
	cp $0d			; $6d01
	jr nz,_label_09_213	; $6d03
	ld a,$01		; $6d05
	ld (de),a		; $6d07
	ld e,$79		; $6d08
	ld a,$0d		; $6d0a
	ld (de),a		; $6d0c
	call $6f85		; $6d0d
	ld e,$42		; $6d10
	ld a,$01		; $6d12
	ld (de),a		; $6d14
	ld a,$1c		; $6d15
	ld e,$4b		; $6d17
	ld (de),a		; $6d19
	ld a,$2c		; $6d1a
	ld e,$4d		; $6d1c
	ld (de),a		; $6d1e
	ld hl,$6a80		; $6d1f
	call interactionSetScript		; $6d22
	ld a,($c645)		; $6d25
	bit 5,a			; $6d28
	jr nz,_label_09_213	; $6d2a
	or a			; $6d2c
	ld a,$01		; $6d2d
	ld ($ccf4),a		; $6d2f
	ret nz			; $6d32
	jp interactionAnimateAsNpc		; $6d33
	call interactionRunScript		; $6d36
	ret nc			; $6d39
	call setStatusBarNeedsRefreshBit1		; $6d3a
_label_09_213:
	jp interactionDelete		; $6d3d
	ld e,Interaction.state		; $6d40
	ld a,(de)		; $6d42
	rst_jumpTable			; $6d43
	ld c,b			; $6d44
	ld l,l			; $6d45
	ld a,a			; $6d46
	ld l,l			; $6d47
	ld a,$01		; $6d48
	ld (de),a		; $6d4a
	ld a,($cc48)		; $6d4b
	and $01			; $6d4e
	jr z,_label_09_213	; $6d50
	ld a,($d101)		; $6d52
	cp $0b			; $6d55
	jr z,_label_09_214	; $6d57
	cp $0d			; $6d59
	jr nz,_label_09_213	; $6d5b
	ld a,$0a		; $6d5d
	ld hl,$d104		; $6d5f
	ldi (hl),a		; $6d62
	ld l,$03		; $6d63
	ld a,$08		; $6d65
	ld (hl),a		; $6d67
	ld l,$3f		; $6d68
	ld (hl),$14		; $6d6a
	ld hl,$6c6a		; $6d6c
	jp interactionSetScript		; $6d6f
_label_09_214:
	ld hl,$d104		; $6d72
	ld a,$0a		; $6d75
	ldi (hl),a		; $6d77
	ld l,$03		; $6d78
	ld a,$09		; $6d7a
	ld (hl),a		; $6d7c
	jr _label_09_213		; $6d7d
	call interactionRunScript		; $6d7f
	jr c,_label_09_213	; $6d82
	ret			; $6d84
	ld e,Interaction.state		; $6d85
	ld a,(de)		; $6d87
	rst_jumpTable			; $6d88
	adc a			; $6d89
	ld l,l			; $6d8a
	or h			; $6d8b
	ld l,l			; $6d8c
.DB $ec				; $6d8d
	ld l,l			; $6d8e
	ld a,($c645)		; $6d8f
	and $80			; $6d92
	jr nz,_label_09_213	; $6d94
	ld a,$01		; $6d96
	ld (de),a		; $6d98
	ld a,$1c		; $6d99
	ld e,$4b		; $6d9b
	ld (de),a		; $6d9d
	ld a,$2c		; $6d9e
	ld e,$4d		; $6da0
	ld (de),a		; $6da2
	ld a,TREASURE_SPRING_BANANA		; $6da3
	call checkTreasureObtained		; $6da5
	ld a,$00		; $6da8
	rla			; $6daa
	ld e,$78		; $6dab
	ld (de),a		; $6dad
	ld hl,$6ca3		; $6dae
	jp interactionSetScript		; $6db1
	ld a,($d13d)		; $6db4
	or a			; $6db7
	jr z,_label_09_215	; $6db8
	ld e,$78		; $6dba
	ld a,(de)		; $6dbc
	or a			; $6dbd
	jr z,_label_09_215	; $6dbe
	ld e,$7a		; $6dc0
	ld a,(de)		; $6dc2
	or a			; $6dc3
	jr nz,_label_09_215	; $6dc4
	inc a			; $6dc6
	ld (de),a		; $6dc7
	ld ($cc02),a		; $6dc8
	ld hl,$d000		; $6dcb
	call objectTakePosition		; $6dce
	ld a,($d10b)		; $6dd1
	ld b,a			; $6dd4
	ld a,($d10d)		; $6dd5
	ld c,a			; $6dd8
	call objectGetRelativeAngle		; $6dd9
	ld e,$49		; $6ddc
	ld (de),a		; $6dde
	ld a,$02		; $6ddf
	ld ($d108),a		; $6de1
	add $01			; $6de4
	ld ($d13f),a		; $6de6
_label_09_215:
	jp $6d36		; $6de9
	ld h,d			; $6dec
	ld l,$5a		; $6ded
	bit 7,(hl)		; $6def
	jr nz,_label_09_216	; $6df1
	ld l,$50		; $6df3
	ld (hl),$32		; $6df5
	ld bc,$fec0		; $6df7
	call objectSetSpeedZ		; $6dfa
	call objectSetVisible80		; $6dfd
	call $6f85		; $6e00
	ld a,$06		; $6e03
	ld e,Interaction.subid		; $6e05
	ld (de),a		; $6e07
	ld e,$46		; $6e08
	ld a,$10		; $6e0a
	ld (de),a		; $6e0c
_label_09_216:
	call retIfTextIsActive		; $6e0d
	ld c,$40		; $6e10
	call objectUpdateSpeedZ_paramC		; $6e12
	jp nz,objectApplySpeed		; $6e15
	call interactionDecCounter1		; $6e18
	ret nz			; $6e1b
	ld l,$44		; $6e1c
	dec (hl)		; $6e1e
	ld a,$47		; $6e1f
	call loseTreasure		; $6e21
	jp objectSetInvisible		; $6e24
	ld e,Interaction.state		; $6e27
	ld a,(de)		; $6e29
	rst_jumpTable			; $6e2a
	inc sp			; $6e2b
	ld l,(hl)		; $6e2c
	ld (hl),$6d		; $6e2d
	ld c,h			; $6e2f
	ld l,(hl)		; $6e30
	xor a			; $6e31
	ld l,(hl)		; $6e32
	ld a,($c643)		; $6e33
	and $80			; $6e36
	jp nz,_label_09_218		; $6e38
	ld a,$01		; $6e3b
	ld (de),a		; $6e3d
	ld e,$79		; $6e3e
	ld a,$0b		; $6e40
	ld (de),a		; $6e42
	call interactionSetAlwaysUpdateBit		; $6e43
	ld hl,$6b26		; $6e46
	jp interactionSetScript		; $6e49
	ld a,$48		; $6e4c
	call loseTreasure		; $6e4e
	ld a,$01		; $6e51
	ld ($cc02),a		; $6e53
	call interactionIncState		; $6e56
	ld e,$79		; $6e59
	ld a,(de)		; $6e5b
	ld c,a			; $6e5c
	cp $0d			; $6e5d
	jr z,_label_09_217	; $6e5f
	ld hl,$c638		; $6e61
	rst_addAToHl			; $6e64
	set 7,(hl)		; $6e65
_label_09_217:
	ld a,c			; $6e67
	ld hl,$c610		; $6e68
	cp (hl)			; $6e6b
	ret nz			; $6e6c
	sub $0a			; $6e6d
	ld l,$af		; $6e6f
	ld (hl),a		; $6e71
	ld a,(de)		; $6e72
	ld c,a			; $6e73
	ld a,TREASURE_FLUTE		; $6e74
	call giveTreasure		; $6e76
	ld hl,$cbea		; $6e79
	set 0,(hl)		; $6e7c
	ld e,Interaction.subid		; $6e7e
	ld a,$01		; $6e80
	ld (de),a		; $6e82
	call interactionInitGraphics		; $6e83
	ld e,Interaction.subid		; $6e86
	ld a,$03		; $6e88
	ld (de),a		; $6e8a
	ld e,$79		; $6e8b
	ld a,(de)		; $6e8d
	sub $0a			; $6e8e
	ld c,a			; $6e90
	and $01			; $6e91
	add a			; $6e93
	xor c			; $6e94
	ld e,$5c		; $6e95
	ld (de),a		; $6e97
	ld hl,$cc6a		; $6e98
	ld a,$04		; $6e9b
	ldi (hl),a		; $6e9d
	ld (hl),$01		; $6e9e
	ld hl,$d000		; $6ea0
	ld bc,$f200		; $6ea3
	call objectTakePositionWithOffset		; $6ea6
	call objectSetVisible80		; $6ea9
	jp interactionRunScript		; $6eac
	call retIfTextIsActive		; $6eaf
	ld ($cca4),a		; $6eb2
	call objectSetInvisible		; $6eb5
	ld a,($cc48)		; $6eb8
	and $0f			; $6ebb
	add a			; $6ebd
	swap a			; $6ebe
	ld ($cca4),a		; $6ec0
	call interactionRunScript		; $6ec3
	ret nc			; $6ec6
	xor a			; $6ec7
	ld ($cca4),a		; $6ec8
	ld ($cc02),a		; $6ecb
	jr _label_09_218		; $6ece
	ld e,Interaction.state		; $6ed0
	ld a,(de)		; $6ed2
	rst_jumpTable			; $6ed3
	call c,$366e		; $6ed4
	ld l,l			; $6ed7
	ld d,c			; $6ed8
	ld l,(hl)		; $6ed9
	xor a			; $6eda
	ld l,(hl)		; $6edb
	ld a,($c644)		; $6edc
	and $80			; $6edf
	jr nz,_label_09_218	; $6ee1
	ld a,($c610)		; $6ee3
	cp $0c			; $6ee6
	jr nz,_label_09_218	; $6ee8
	ld a,$01		; $6eea
	ld (de),a		; $6eec
	ld e,$79		; $6eed
	ld a,$0c		; $6eef
	ld (de),a		; $6ef1
	ld hl,$6c0a		; $6ef2
	jp interactionSetScript		; $6ef5
	ld e,Interaction.state		; $6ef8
	ld a,(de)		; $6efa
	rst_jumpTable			; $6efb
	nop			; $6efc
	ld l,a			; $6efd
	ld (hl),$6d		; $6efe
	ld a,($c644)		; $6f00
	and $80			; $6f03
	jr nz,_label_09_218	; $6f05
	ld a,($c610)		; $6f07
	cp $0c			; $6f0a
	jr z,_label_09_218	; $6f0c
	ld a,$01		; $6f0e
	ld (de),a		; $6f10
	ld hl,$6c51		; $6f11
	jp interactionSetScript		; $6f14
	ld a,($c644)		; $6f17
	or $20			; $6f1a
	ld ($c644),a		; $6f1c
_label_09_218:
	jp interactionDelete		; $6f1f
	ld e,Interaction.state		; $6f22
	ld a,(de)		; $6f24
	rst_jumpTable			; $6f25
	ldi a,(hl)		; $6f26
	ld l,a			; $6f27
	dec sp			; $6f28
	ld l,a			; $6f29
	ld a,$01		; $6f2a
	ld (de),a		; $6f2c
	ld a,($d101)		; $6f2d
	cp $0c			; $6f30
	jr nz,_label_09_218	; $6f32
	ld a,($c610)		; $6f34
	cp $0c			; $6f37
	jr z,_label_09_218	; $6f39
	ld a,($cd00)		; $6f3b
	and $0e			; $6f3e
	ret nz			; $6f40
	ld hl,$d10b		; $6f41
	ldi a,(hl)		; $6f44
	cp $50			; $6f45
	ret nc			; $6f47
	cp $30			; $6f48
	ret c			; $6f4a
	inc l			; $6f4b
	ld a,(hl)		; $6f4c
	cp $10			; $6f4d
	ret nc			; $6f4f
	ld a,$10		; $6f50
	ld (hl),a		; $6f52
	ld l,$04		; $6f53
	ld a,(hl)		; $6f55
	cp $08			; $6f56
	jr z,_label_09_219	; $6f58
	cp $02			; $6f5a
	jr nz,_label_09_219	; $6f5c
	ld (hl),$01		; $6f5e
	call dropLinkHeldItem		; $6f60
_label_09_219:
	ld l,$04		; $6f63
	ld (hl),$0d		; $6f65
	ld bc,objectGetRelatedObject1Var		; $6f67
	jp showText		; $6f6a
	ld h,$c6		; $6f6d
	call checkIsLinkedGame		; $6f6f
	jr nz,_label_09_220	; $6f72
	ld a,TREASURE_FLUTE		; $6f74
	call checkTreasureObtained		; $6f76
	jr c,_label_09_220	; $6f79
	ld l,$10		; $6f7b
	ld (hl),$0b		; $6f7d
_label_09_220:
	ld l,$43		; $6f7f
	set 5,(hl)		; $6f81
	jr _label_09_218		; $6f83
	ld e,Interaction.subid		; $6f85
	xor a			; $6f87
	ld (de),a		; $6f88
	jp interactionInitGraphics		; $6f89

interactionCode72:
	ld e,Interaction.subid		; $6f8c
	ld a,(de)		; $6f8e
	or a			; $6f8f
	jr nz,_label_09_225	; $6f90
	ld e,Interaction.state		; $6f92
	ld a,(de)		; $6f94
	rst_jumpTable			; $6f95
	sbc h			; $6f96
	ld l,a			; $6f97
	pop de			; $6f98
	ld l,a			; $6f99
	reti			; $6f9a
	ldd a,(hl)		; $6f9b
	call interactionIncState		; $6f9c
	ld a,($cced)		; $6f9f
	cp $00			; $6fa2
	jr z,_label_09_221	; $6fa4
	cp $01			; $6fa6
	jr z,_label_09_222	; $6fa8
	cp $03			; $6faa
	jr z,_label_09_221	; $6fac
_label_09_221:
	ld l,$78		; $6fae
	ld (hl),$01		; $6fb0
	ld l,$77		; $6fb2
	ld (hl),$02		; $6fb4
	ld a,$06		; $6fb6
	call objectSetCollideRadius		; $6fb8
	call $7055		; $6fbb
	call interactionInitGraphics		; $6fbe
	jr _label_09_223		; $6fc1
_label_09_222:
	ld l,$78		; $6fc3
	ld (hl),$00		; $6fc5
	call interactionInitGraphics		; $6fc7
	ld a,$01		; $6fca
	jp interactionSetAnimation		; $6fcc
	jr _label_09_224		; $6fcf
	ld e,$78		; $6fd1
	ld a,(de)		; $6fd3
	or a			; $6fd4
	jr z,_label_09_224	; $6fd5
	call $7036		; $6fd7
	call $704f		; $6fda
_label_09_223:
	call interactionAnimate		; $6fdd
_label_09_224:
	call objectPreventLinkFromPassing		; $6fe0
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6fe3
_label_09_225:
	ld e,Interaction.state		; $6fe6
	ld a,(de)		; $6fe8
	rst_jumpTable			; $6fe9
	xor $6f			; $6fea
.DB $fc				; $6fec
	ld l,a			; $6fed
	ld a,$01		; $6fee
	ld (de),a		; $6ff0
	call interactionInitGraphics		; $6ff1
	ld a,$04		; $6ff4
	call interactionSetAnimation		; $6ff6
	jp objectSetVisiblec1		; $6ff9
	ld e,Interaction.state2		; $6ffc
	ld a,(de)		; $6ffe
	rst_jumpTable			; $6fff
	ld b,$70		; $7000
	inc e			; $7002
	ld (hl),b		; $7003
	add hl,hl		; $7004
	ld (hl),b		; $7005
	ld a,($cbb5)		; $7006
	or a			; $7009
	jr z,_label_09_227	; $700a
	ld h,d			; $700c
	ld l,$45		; $700d
	inc (hl)		; $700f
	ld l,$60		; $7010
	ld (hl),$01		; $7012
	xor a			; $7014
	ld l,$4e		; $7015
	ldi (hl),a		; $7017
	ld (hl),a		; $7018
	jp interactionAnimate		; $7019
	ld h,d			; $701c
	ld l,$61		; $701d
	ld a,(hl)		; $701f
	or a			; $7020
	jr z,_label_09_226	; $7021
	ld l,$45		; $7023
	inc (hl)		; $7025
_label_09_226:
	jp interactionAnimate		; $7026
_label_09_227:
	ld c,$20		; $7029
	call objectUpdateSpeedZ_paramC		; $702b
	ret nz			; $702e
	ld h,d			; $702f
	ld bc,$ff40		; $7030
	jp objectSetSpeedZ		; $7033
	ld a,(wFrameCounter)		; $7036
	and $07			; $7039
	ret nz			; $703b
	call objectGetAngleTowardLink		; $703c
	add $04			; $703f
	and $18			; $7041
	swap a			; $7043
	rlca			; $7045
	ld h,d			; $7046
	ld l,$77		; $7047
	cp (hl)			; $7049
	ret z			; $704a
	ld (hl),a		; $704b
	jp interactionSetAnimation		; $704c
	ld c,$0e		; $704f
	call objectUpdateSpeedZ_paramC		; $7051
	ret nz			; $7054
	ld e,$54		; $7055
	ld a,$80		; $7057
	ld (de),a		; $7059
	inc e			; $705a
	ld a,$ff		; $705b
	ld (de),a		; $705d
	ret			; $705e

interactionCode73:
	ld h,d			; $705f
	ld l,$42		; $7060
	ldi a,(hl)		; $7062
	or a			; $7063
	jr nz,_label_09_228	; $7064
	inc l			; $7066
	ld a,(hl)		; $7067
	or a			; $7068
	jr z,_label_09_228	; $7069
	ld a,($cd00)		; $706b
	and $0e			; $706e
	jr z,_label_09_228	; $7070
	ld a,$3c		; $7072
	ld ($cc85),a		; $7074
	ret			; $7077
_label_09_228:
	ld e,$44		; $7078
	ld a,($c610)		; $707a
	cp $0b			; $707d
	or a			; $707f
	jr z,_label_09_233	; $7080
	cp $0d			; $7082
	jr z,_label_09_229	; $7084
	ld a,(de)		; $7086
	rst_jumpTable			; $7087
	sub h			; $7088
	ld (hl),b		; $7089
	nop			; $708a
	ld (hl),c		; $708b
	ld c,b			; $708c
	ld (hl),c		; $708d
_label_09_229:
	ld a,(de)		; $708e
	rst_jumpTable			; $708f
	sub h			; $7090
	ld (hl),b		; $7091
	ld d,a			; $7092
	ld (hl),c		; $7093
	ld a,$01		; $7094
	ld (de),a		; $7096
	call interactionInitGraphics		; $7097
	ld hl,$d101		; $709a
	ld a,($c610)		; $709d
	cp $0d			; $70a0
	jr z,_label_09_230	; $70a2
	cp $0c			; $70a4
	jr nz,_label_09_233	; $70a6
	cp (hl)			; $70a8
	jr nz,_label_09_233	; $70a9
	ld a,($c644)		; $70ab
	and $88			; $70ae
	jr nz,_label_09_233	; $70b0
	call $71ac		; $70b2
	ld hl,$71cd		; $70b5
	rst_addDoubleIndex			; $70b8
	ldi a,(hl)		; $70b9
	ld h,(hl)		; $70ba
	ld l,a			; $70bb
	call interactionSetScript		; $70bc
	jr _label_09_232		; $70bf
_label_09_230:
	cp (hl)			; $70c1
	jr nz,_label_09_233	; $70c2
	ld a,($c645)		; $70c4
	bit 5,a			; $70c7
	jr nz,_label_09_233	; $70c9
	bit 7,a			; $70cb
	jr nz,_label_09_233	; $70cd
	bit 2,a			; $70cf
	jr nz,_label_09_233	; $70d1
	and $03			; $70d3
	jr z,_label_09_231	; $70d5
	ld h,d			; $70d7
	ld l,$42		; $70d8
	ld a,(hl)		; $70da
	or a			; $70db
	jr nz,_label_09_231	; $70dc
	ld l,$4b		; $70de
	ld (hl),$28		; $70e0
	ld l,$4d		; $70e2
	ld (hl),$a8		; $70e4
_label_09_231:
	call $71ac		; $70e6
	ld hl,$71d9		; $70e9
	rst_addDoubleIndex			; $70ec
	ldi a,(hl)		; $70ed
	ld h,(hl)		; $70ee
	ld l,a			; $70ef
	call interactionSetScript		; $70f0
_label_09_232:
	call interactionAnimateAsNpc		; $70f3
	call objectCheckWithinScreenBoundary		; $70f6
	ret c			; $70f9
	jp objectSetInvisible		; $70fa
_label_09_233:
	jp interactionDelete		; $70fd
	call interactionAnimateAsNpc		; $7100
	ld e,Interaction.subid		; $7103
	ld a,(de)		; $7105
	and $1f			; $7106
	call z,$7183		; $7108
	ld a,($c644)		; $710b
	and $08			; $710e
	jr nz,_label_09_235	; $7110
	ld a,($c4ab)		; $7112
	or a			; $7115
	ret nz			; $7116
	call $71c0		; $7117
	ld e,$71		; $711a
	ld a,(de)		; $711c
	or a			; $711d
	jr z,_label_09_234	; $711e
	call objectGetAngleTowardLink		; $7120
	ld e,$49		; $7123
	ld (de),a		; $7125
	call convertAngleDeToDirection		; $7126
	dec e			; $7129
	ld (de),a		; $712a
	call interactionSetAnimation		; $712b
_label_09_234:
	jp interactionRunScript		; $712e
_label_09_235:
	ld a,$01		; $7131
	ld ($cca4),a		; $7133
	ld e,Interaction.state		; $7136
	ld a,$02		; $7138
	ld (de),a		; $713a
	ld e,Interaction.subid		; $713b
	ld a,(de)		; $713d
	ld hl,$71d3		; $713e
	rst_addDoubleIndex			; $7141
	ldi a,(hl)		; $7142
	ld h,(hl)		; $7143
	ld l,a			; $7144
	jp interactionSetScript		; $7145
	call $71c0		; $7148
	call interactionAnimate		; $714b
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $714e
	call interactionRunScript		; $7151
	ret nc			; $7154
_label_09_236:
	jr _label_09_233		; $7155
	call interactionAnimate		; $7157
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $715a
	ld a,($c4ab)		; $715d
	or a			; $7160
	ret nz			; $7161
	ld a,($cc30)		; $7162
	or a			; $7165
	jr z,_label_09_237	; $7166
	ld a,$01		; $7168
_label_09_237:
	ld e,$7b		; $716a
	ld (de),a		; $716c
	call $71c0		; $716d
	call objectCheckWithinScreenBoundary		; $7170
	jr nc,_label_09_238	; $7173
	call objectSetVisible		; $7175
	jr _label_09_239		; $7178
_label_09_238:
	call objectSetInvisible		; $717a
_label_09_239:
	call interactionRunScript		; $717d
	jr c,_label_09_236	; $7180
	ret			; $7182
	xor a			; $7183
	ld e,$78		; $7184
	ld (de),a		; $7186
	inc e			; $7187
	ld (de),a		; $7188
	ld a,$07		; $7189
	call cpRupeeValue		; $718b
	jr nz,_label_09_240	; $718e
	ld e,$78		; $7190
	ld a,$01		; $7192
	ld (de),a		; $7194
	ld a,$0b		; $7195
	call cpRupeeValue		; $7197
	jr nz,_label_09_240	; $719a
	ld e,$79		; $719c
	ld a,$01		; $719e
	ld (de),a		; $71a0
_label_09_240:
	ld h,d			; $71a1
	ld l,$7a		; $71a2
	ld a,(hl)		; $71a4
	or a			; $71a5
	ret z			; $71a6
	ld (hl),$00		; $71a7
	jp removeRupeeValue		; $71a9
	call interactionSetAlwaysUpdateBit		; $71ac
	ld l,$66		; $71af
	ld a,$06		; $71b1
	ldi (hl),a		; $71b3
	ld a,$06		; $71b4
	ld (hl),a		; $71b6
	ld l,$50		; $71b7
	ld a,$32		; $71b9
	ld (hl),a		; $71bb
	ld e,Interaction.subid		; $71bc
	ld a,(de)		; $71be
	ret			; $71bf
	ld c,$40		; $71c0
	call objectUpdateSpeedZ_paramC		; $71c2
	jr z,_label_09_241	; $71c5
	ld a,$01		; $71c7
_label_09_241:
	ld e,$77		; $71c9
	ld (de),a		; $71cb
	ret			; $71cc
.DB $e3				; $71cd
	ld l,h			; $71ce
	ld d,(hl)		; $71cf
	ld l,l			; $71d0
	ld a,h			; $71d1
	ld l,l			; $71d2
	and e			; $71d3
	ld l,l			; $71d4
	or l			; $71d5
	ld l,l			; $71d6
.DB $db				; $71d7
	ld l,l			; $71d8
	nop			; $71d9
	ld l,(hl)		; $71da
	xor l			; $71db
	ld l,(hl)		; $71dc
	or $6e			; $71dd
	inc hl			; $71df
	ld l,a			; $71e0
	scf			; $71e1
	ld l,a			; $71e2
	dec a			; $71e3
	ld l,a			; $71e4

interactionCode74:
	ld e,Interaction.subid		; $71e5
	ld a,(de)		; $71e7
	rst_jumpTable			; $71e8
	inc bc			; $71e9
	ld (hl),d		; $71ea
	inc bc			; $71eb
	ld (hl),d		; $71ec
	inc sp			; $71ed
	ld (hl),d		; $71ee
	inc bc			; $71ef
	ld (hl),d		; $71f0
	ld b,h			; $71f1
	ld (hl),d		; $71f2
	inc bc			; $71f3
	ld (hl),d		; $71f4
	ld a,l			; $71f5
	ld (hl),d		; $71f6
	ld b,h			; $71f7
	ld (hl),d		; $71f8
	inc bc			; $71f9
	ld (hl),d		; $71fa
	inc bc			; $71fb
	ld (hl),d		; $71fc
	ld a,l			; $71fd
	ld (hl),d		; $71fe
	ld a,l			; $71ff
	ld (hl),d		; $7200
	adc b			; $7201
	ld (hl),d		; $7202
	call $7283		; $7203
	jr nz,_label_09_243	; $7206
_label_09_242:
	ld e,Interaction.state		; $7208
	ld a,$01		; $720a
	ld (de),a		; $720c
	ld a,$57		; $720d
	call loadPaletteHeader		; $720f
	call interactionInitGraphics		; $7212
	jp objectSetVisible80		; $7215
_label_09_243:
	ld e,Interaction.subid		; $7218
	ld a,(de)		; $721a
	ld hl,$7229		; $721b
	rst_addAToHl			; $721e
	ld a,($cbbf)		; $721f
	add (hl)		; $7222
	ld e,$4b		; $7223
	ld (de),a		; $7225
	jp interactionAnimate		; $7226
	add sp,$58		; $7229
	nop			; $722b
	ld ($ff00+$00),a	; $722c
	stop			; $722e
	nop			; $722f
	nop			; $7230
	stop			; $7231
	stop			; $7232
	call $7283		; $7233
	ret nz			; $7236
	ld a,$17		; $7237
	call checkGlobalFlag		; $7239
	jp nz,interactionDelete		; $723c
	call $725b		; $723f
	jr _label_09_242		; $7242
	call $7283		; $7244
	jp nz,interactionAnimate		; $7247
	ld a,$17		; $724a
	call checkGlobalFlag		; $724c
	jp z,interactionDelete		; $724f
	call $7208		; $7252
	ld e,Interaction.subid		; $7255
	ld a,(de)		; $7257
	cp $04			; $7258
	ret nz			; $725a
	ld bc,func_3211		; $725b
	ld e,$0a		; $725e
	call $7268		; $7260
	ld bc,$3018		; $7263
	ld e,$0b		; $7266
	call getFreeInteractionSlot		; $7268
	ret nz			; $726b
	ld (hl),$74		; $726c
	inc l			; $726e
	ld (hl),e		; $726f
	ld e,$4b		; $7270
	ld a,(de)		; $7272
	add b			; $7273
	ld l,e			; $7274
	ld (hl),a		; $7275
	ld e,$4d		; $7276
	ld a,(de)		; $7278
	add c			; $7279
	ld l,e			; $727a
	ld (hl),a		; $727b
	ret			; $727c
	call $7283		; $727d
	ret nz			; $7280
	jr _label_09_242		; $7281
	ld e,Interaction.state		; $7283
	ld a,(de)		; $7285
	or a			; $7286
	ret			; $7287
	call $7283		; $7288
	jp nz,interactionAnimate		; $728b
	ld a,$16		; $728e
	call checkGlobalFlag		; $7290
	jp nz,interactionDelete		; $7293
	jp $7208		; $7296

interactionCode75:
	ld e,Interaction.state		; $7299
	ld a,(de)		; $729b
	rst_jumpTable			; $729c
	and c			; $729d
	ld (hl),d		; $729e
	sub $72			; $729f
	call interactionIncState		; $72a1
	call interactionInitGraphics		; $72a4
	ld e,Interaction.subid		; $72a7
	ld a,(de)		; $72a9
	or a			; $72aa
	jr nz,_label_09_244	; $72ab
	ld hl,$6f48		; $72ad
	call interactionSetScript		; $72b0
	jp objectSetVisible82		; $72b3
_label_09_244:
	ld h,d			; $72b6
	ld l,$4b		; $72b7
	ld (hl),$70		; $72b9
	inc l			; $72bb
	inc l			; $72bc
	ld (hl),$80		; $72bd
	ld l,$49		; $72bf
	ld (hl),$18		; $72c1
	ld l,$50		; $72c3
	ld (hl),$05		; $72c5
	ld l,$42		; $72c7
	ld a,(hl)		; $72c9
	cp $02			; $72ca
	jp z,objectSetVisible83		; $72cc
	ld l,$46		; $72cf
	ld (hl),$05		; $72d1
	jp objectSetVisible82		; $72d3
	ld e,Interaction.subid		; $72d6
	ld a,(de)		; $72d8
	rst_jumpTable			; $72d9
	ld ($ff00+$72),a	; $72da
	rst $38			; $72dc
	ld (hl),d		; $72dd
	dec e			; $72de
	ld (hl),e		; $72df
	call interactionRunScript		; $72e0
	jp c,interactionDelete		; $72e3
	call interactionAnimate		; $72e6
	ld h,d			; $72e9
	ld l,$61		; $72ea
	ld a,(hl)		; $72ec
	or a			; $72ed
	ret z			; $72ee
	ld (hl),$00		; $72ef
	dec a			; $72f1
	add $30			; $72f2
	push de			; $72f4
	call loadGfxHeader		; $72f5
	ld a,UNCMP_GFXH_0c		; $72f8
	call loadUncompressedGfxHeader		; $72fa
	pop de			; $72fd
	ret			; $72fe
	call checkInteractionState2		; $72ff
	jr nz,_label_09_245	; $7302
	call interactionAnimate		; $7304
	ld h,d			; $7307
	ld l,$61		; $7308
	ld a,(hl)		; $730a
	or a			; $730b
	jr z,_label_09_245	; $730c
	ld (hl),$00		; $730e
	ld l,$46		; $7310
	dec (hl)		; $7312
	jr nz,_label_09_245	; $7313
	ld l,$45		; $7315
	inc (hl)		; $7317
	ld a,$04		; $7318
	call interactionSetAnimation		; $731a
_label_09_245:
	ld hl,$cbb6		; $731d
	ld a,(hl)		; $7320
	or a			; $7321
	ret z			; $7322
	jp objectApplySpeed		; $7323

interactionCode76:
	ld e,Interaction.state		; $7326
	ld a,(de)		; $7328
	rst_jumpTable			; $7329
	ldd (hl),a		; $732a
	ld (hl),e		; $732b
	ld sp,hl		; $732c
	ld (hl),e		; $732d
	cp l			; $732e
	ld (hl),e		; $732f
	xor $73			; $7330
	ld a,$01		; $7332
	ld (de),a		; $7334
	ld a,$28		; $7335
	call checkGlobalFlag		; $7337
	jp nz,_label_09_248		; $733a
	ld a,($c644)		; $733d
	and $40			; $7340
	jr z,_label_09_246	; $7342
	ld a,$03		; $7344
	ld (de),a		; $7346
	call $745b		; $7347
	ld e,Interaction.subid		; $734a
	ld a,(de)		; $734c
	and $1f			; $734d
	ld e,Interaction.subid		; $734f
	ld a,(de)		; $7351
	and $1f			; $7352
	ld c,a			; $7354
	ld hl,$748f		; $7355
	rst_addDoubleIndex			; $7358
	ld e,$4b		; $7359
	ldi a,(hl)		; $735b
	ld (de),a		; $735c
	ld e,$4d		; $735d
	ldi a,(hl)		; $735f
	ld (de),a		; $7360
	ld a,c			; $7361
	ld hl,$7483		; $7362
	rst_addDoubleIndex			; $7365
	ldi a,(hl)		; $7366
	ld h,(hl)		; $7367
	ld l,a			; $7368
	call interactionSetScript		; $7369
	ld a,c			; $736c
	ld hl,$7495		; $736d
	rst_addAToHl			; $7370
	ld a,(hl)		; $7371
	jp interactionSetAnimation		; $7372
_label_09_246:
	ld hl,$d101		; $7375
	ld a,(hl)		; $7378
	cp $0c			; $7379
	jr nz,_label_09_248	; $737b
	ld a,($c610)		; $737d
	cp $0c			; $7380
	jr z,_label_09_248	; $7382
	ld a,($c644)		; $7384
	bit 5,a			; $7387
	jr z,_label_09_248	; $7389
	bit 4,a			; $738b
	jr nz,_label_09_248	; $738d
	call $745b		; $738f
	ld e,Interaction.subid		; $7392
	ld a,(de)		; $7394
	and $1f			; $7395
	ld c,a			; $7397
	ld hl,$7489		; $7398
	rst_addDoubleIndex			; $739b
	ld e,$4b		; $739c
	ldi a,(hl)		; $739e
	ld (de),a		; $739f
	ld e,$4d		; $73a0
	ldi a,(hl)		; $73a2
	ld (de),a		; $73a3
	ld a,c			; $73a4
	ld hl,$7477		; $73a5
	rst_addDoubleIndex			; $73a8
	ldi a,(hl)		; $73a9
	ld h,(hl)		; $73aa
	ld l,a			; $73ab
	call interactionSetScript		; $73ac
	ld e,Interaction.subid		; $73af
	ld a,(de)		; $73b1
	and $1f			; $73b2
	call z,$743e		; $73b4
	ld a,$78		; $73b7
	ld ($cc85),a		; $73b9
	ret			; $73bc
	ld c,$40		; $73bd
	call objectUpdateSpeedZ_paramC		; $73bf
	jr z,_label_09_247	; $73c2
	ld a,$01		; $73c4
_label_09_247:
	ld e,$77		; $73c6
	ld (de),a		; $73c8
	call interactionAnimate		; $73c9
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $73cc
	call interactionRunScript		; $73cf
	ld e,$4b		; $73d2
	ld a,(de)		; $73d4
	bit 7,a			; $73d5
	ret z			; $73d7
	ld e,Interaction.subid		; $73d8
	ld a,(de)		; $73da
	and $1f			; $73db
	cp $01			; $73dd
	jr nz,_label_09_248	; $73df
	xor a			; $73e1
	ld ($cba0),a		; $73e2
	ld ($cca4),a		; $73e5
	ld ($cc02),a		; $73e8
_label_09_248:
	jp interactionDelete		; $73eb
	ld a,($cd00)		; $73ee
	and $0e			; $73f1
	ret nz			; $73f3
	call interactionAnimateAsNpc		; $73f4
	jr _label_09_249		; $73f7
	ld a,($cd00)		; $73f9
	and $0e			; $73fc
	ret nz			; $73fe
	call interactionAnimateAsNpc		; $73ff
	ld e,Interaction.subid		; $7402
	ld a,(de)		; $7404
	and $1f			; $7405
	call z,$743e		; $7407
	ld a,($c644)		; $740a
	and $08			; $740d
	jr nz,_label_09_251	; $740f
_label_09_249:
	ld a,($c4ab)		; $7411
	or a			; $7414
	ret nz			; $7415
	ld c,$40		; $7416
	call objectUpdateSpeedZ_paramC		; $7418
	jr z,_label_09_250	; $741b
	ld a,$c0		; $741d
	ld e,$5a		; $741f
	ld (de),a		; $7421
	ld a,$01		; $7422
_label_09_250:
	ld e,$77		; $7424
	ld (de),a		; $7426
	jp interactionRunScript		; $7427
_label_09_251:
	ld e,Interaction.state		; $742a
	ld a,$02		; $742c
	ld (de),a		; $742e
	ld e,Interaction.subid		; $742f
	ld a,(de)		; $7431
	and $1f			; $7432
	ld hl,$747d		; $7434
	rst_addDoubleIndex			; $7437
	ldi a,(hl)		; $7438
	ld h,(hl)		; $7439
	ld l,a			; $743a
	jp interactionSetScript		; $743b
	xor a			; $743e
	ld e,$78		; $743f
	ld (de),a		; $7441
	ld hl,$c6aa		; $7442
	ld a,(hl)		; $7445
	or a			; $7446
	jr z,_label_09_252	; $7447
	ld a,$01		; $7449
	ld e,$78		; $744b
	ld (de),a		; $744d
_label_09_252:
	ld e,$79		; $744e
	ld a,(de)		; $7450
	or a			; $7451
	ret z			; $7452
	xor a			; $7453
	ld (de),a		; $7454
	xor a			; $7455
	ld (hl),a		; $7456
	call setStatusBarNeedsRefreshBit1		; $7457
	ret			; $745a
	call interactionInitGraphics		; $745b
	call interactionSetAlwaysUpdateBit		; $745e
	call interactionAnimateAsNpc		; $7461
	ld h,d			; $7464
	ld l,$66		; $7465
	ld a,$06		; $7467
	ldi (hl),a		; $7469
	ld a,$06		; $746a
	ld (hl),a		; $746c
	ld l,$50		; $746d
	ld a,$32		; $746f
	ld (hl),a		; $7471
	ld a,$21		; $7472
	jp interactionSetHighTextIndex		; $7474
	ld e,h			; $7477
	ld l,a			; $7478
	and (hl)		; $7479
	ld l,a			; $747a
	call z,$f46f		; $747b
	ld l,a			; $747e
	ld bc,$1370		; $747f
	ld (hl),b		; $7482
	inc l			; $7483
	ld (hl),b		; $7484
	inc (hl)		; $7485
	ld (hl),b		; $7486
	inc a			; $7487
	ld (hl),b		; $7488
	jr c,_label_09_255	; $7489
	jr c,_label_09_257	; $748b
	jr z,$48		; $748d
	jr c,_label_09_253	; $748f
	jr c,_label_09_256	; $7491
	ld e,b			; $7493
	ld c,b			; $7494
	ld (bc),a		; $7495
	ld (bc),a		; $7496
	nop			; $7497

interactionCode77:
	ld e,Interaction.state		; $7498
	ld a,(de)		; $749a
	rst_jumpTable			; $749b
	and b			; $749c
	ld (hl),h		; $749d
	or (hl)			; $749e
	ld (hl),h		; $749f
	ld a,$01		; $74a0
	ld (de),a		; $74a2
	call interactionInitGraphics		; $74a3
	ld e,Interaction.subid		; $74a6
	ld a,(de)		; $74a8
	call interactionSetAnimation		; $74a9
	ld e,Interaction.subid		; $74ac
	ld a,(de)		; $74ae
	or a			; $74af
	jp z,objectSetVisible82		; $74b0
	jp objectSetVisible83		; $74b3
	ld hl,$cfd3		; $74b6
	ld a,(hl)		; $74b9
	and $80			; $74ba
	jp nz,objectSetInvisible		; $74bc
	call objectSetVisible		; $74bf
	ld e,Interaction.subid		; $74c2
	ld a,(de)		; $74c4
	or a			; $74c5
	jr nz,_label_09_254	; $74c6
	ld a,($c486)		; $74c8
	ld b,a			; $74cb
	ld a,$7d		; $74cc
	sub b			; $74ce
	ld e,$4b		; $74cf
	ld (de),a		; $74d1
	ld a,($c487)		; $74d2
	ld b,a			; $74d5
	ld a,$54		; $74d6
	sub b			; $74d8
_label_09_253:
	ld e,$4d		; $74d9
	ld (de),a		; $74db
	ret			; $74dc
_label_09_254:
	ld a,($c488)		; $74dd
	ld b,a			; $74e0
	ld a,$e9		; $74e1
_label_09_255:
	add b			; $74e3
	ld e,$4b		; $74e4
	ld (de),a		; $74e6
	ld a,($c489)		; $74e7
	ld b,a			; $74ea
_label_09_256:
	ld a,$19		; $74eb
	add b			; $74ed
	ld e,$4d		; $74ee
	ld (de),a		; $74f0
	ret			; $74f1

interactionCode7b:
	ld h,d			; $74f2
	ld l,$46		; $74f3
_label_09_257:
	ld a,(hl)		; $74f5
	or a			; $74f6
	jr z,_label_09_258	; $74f7
	dec (hl)		; $74f9
	jr z,_label_09_258	; $74fa
	ld a,d			; $74fc
	ld ($ccb0),a		; $74fd
_label_09_258:
	ld e,Interaction.state		; $7500
	ld a,(de)		; $7502
	rst_jumpTable			; $7503
	ld a,(bc)		; $7504
	ld (hl),l		; $7505
	jr _label_09_260		; $7506
	ld (hl),c		; $7508
	ld (hl),l		; $7509
	ld a,$01		; $750a
	ld (de),a		; $750c
	call interactionInitGraphics		; $750d
	ld a,$07		; $7510
	call objectSetCollideRadius		; $7512
	jp objectSetVisible82		; $7515
	call objectGetTileAtPosition		; $7518
	ld (hl),$3f		; $751b
	call $75e7		; $751d
	call nc,interactionAnimate		; $7520
	call objectPreventLinkFromPassing		; $7523
	ret nc			; $7526
	ld a,($cc79)		; $7527
	or a			; $752a
	jr z,_label_09_259	; $752b
	ld e,$61		; $752d
	ld a,(de)		; $752f
	or a			; $7530
	ret nz			; $7531
	ld c,$18		; $7532
	call objectCheckLinkWithinDistance		; $7534
	srl a			; $7537
	ld e,$48		; $7539
	ld (de),a		; $753b
	ld b,a			; $753c
	ld a,($d008)		; $753d
	xor $02			; $7540
	cp b			; $7542
	ret nz			; $7543
	call $75e7		; $7544
	ret c			; $7547
	call interactionIncState		; $7548
	jp $75e1		; $754b
_label_09_259:
	ld a,($ccb0)		; $754e
	or a			; $7551
	ret nz			; $7552
	ld c,$18		; $7553
	call objectCheckLinkWithinDistance		; $7555
	srl a			; $7558
	ret nz			; $755a
	ld a,($ccb4)		; $755b
	cp $3f			; $755e
	ret nz			; $7560
	ld a,($d004)		; $7561
	cp $01			; $7564
	ret nz			; $7566
	ld a,$02		; $7567
	ld ($cc6a),a		; $7569
	xor a			; $756c
	ld ($cc6c),a		; $756d
	ret			; $7570
	call $75e1		; $7571
	call interactionAnimate		; $7574
	ld a,($cc79)		; $7577
	or a			; $757a
	jr z,_label_09_262	; $757b
_label_09_260:
	bit 1,a			; $757d
	jr z,_label_09_262	; $757f
	ld e,$61		; $7581
	ld a,(de)		; $7583
	cp $ff			; $7584
	jr z,_label_09_261	; $7586
	add a			; $7588
	ld c,a			; $7589
	ld e,$48		; $758a
	ld a,(de)		; $758c
	swap a			; $758d
	rrca			; $758f
	ld hl,$75c1		; $7590
	rst_addAToHl			; $7593
	ld b,$00		; $7594
	add hl,bc		; $7596
	ld e,$4b		; $7597
	ld a,(de)		; $7599
	add (hl)		; $759a
	ld ($d00b),a		; $759b
	inc hl			; $759e
	ld e,$4d		; $759f
	ld a,(de)		; $75a1
	add (hl)		; $75a2
	ld ($d00d),a		; $75a3
	ret			; $75a6
_label_09_261:
	ld e,$48		; $75a7
	ld a,(de)		; $75a9
	inc a			; $75aa
	and $03			; $75ab
	ldh (<hFF8B),a	; $75ad
	ld c,$00		; $75af
	call $758d		; $75b1
	ldh a,(<hFF8B)	; $75b4
	xor $02			; $75b6
	ld ($d008),a		; $75b8
_label_09_262:
	ld e,Interaction.state		; $75bb
	ld a,$01		; $75bd
	ld (de),a		; $75bf
	ret			; $75c0
	ld a,($ff00+$00)	; $75c1
.DB $f4				; $75c3
	inc b			; $75c4
	ld hl,sp+$08		; $75c5
.DB $fc				; $75c7
	inc c			; $75c8
	nop			; $75c9
	stop			; $75ca
	inc b			; $75cb
	inc c			; $75cc
	ld ($0c08),sp		; $75cd
	inc b			; $75d0
	stop			; $75d1
	nop			; $75d2
	inc c			; $75d3
.DB $fc				; $75d4
	ld ($04f8),sp		; $75d5
.DB $f4				; $75d8
	nop			; $75d9
	ld a,($ff00+$fc)	; $75da
.DB $f4				; $75dc
	ld hl,sp-$08		; $75dd
.DB $f4				; $75df
.DB $fc				; $75e0
	ld e,$46		; $75e1
	ld a,$14		; $75e3
	ld (de),a		; $75e5
	ret			; $75e6
	ld e,Interaction.subid		; $75e7
	ld a,(de)		; $75e9
	ld b,a			; $75ea
	and $80			; $75eb
	ret z			; $75ed
	ld a,b			; $75ee
	and $07			; $75ef
	ld hl,$cc31		; $75f1
	call checkFlag		; $75f4
	ret nz			; $75f7
	scf			; $75f8
	ret			; $75f9

interactionCode7c:
	call objectSetPriorityRelativeToLink		; $75fa
	ld e,Interaction.state		; $75fd
	ld a,(de)		; $75ff
	rst_jumpTable			; $7600
	dec bc			; $7601
	halt			; $7602
	ld e,$76		; $7603
	add hl,hl		; $7605
	halt			; $7606
	or e			; $7607
	halt			; $7608
	add $76			; $7609
	ld a,$01		; $760b
	ld (de),a		; $760d
	call interactionInitGraphics		; $760e
	ld a,$07		; $7611
	call objectSetCollideRadius		; $7613
	ld a,$14		; $7616
	ld l,$50		; $7618
	ld (hl),a		; $761a
	jp objectSetVisible82		; $761b
	call returnIfScrollMode01Unset		; $761e
	ld e,Interaction.state		; $7621
	ld a,$02		; $7623
	ld (de),a		; $7625
	jp $76d4		; $7626
	ld a,($d00f)		; $7629
	or a			; $762c
	jr nz,_label_09_264	; $762d
	xor a			; $762f
	ld e,$70		; $7630
	ld (de),a		; $7632
	ld a,$07		; $7633
	call objectSetCollideRadius		; $7635
	call objectPreventLinkFromPassing		; $7638
	jr nc,_label_09_263	; $763b
	call objectCheckLinkPushingAgainstCenter		; $763d
	jr nc,_label_09_263	; $7640
	ld a,$01		; $7642
	ld ($cc81),a		; $7644
	call interactionDecCounter1		; $7647
	ret nz			; $764a
	ld c,$28		; $764b
	call objectCheckLinkWithinDistance		; $764d
	ld e,$48		; $7650
	xor $04			; $7652
	ld (de),a		; $7654
	call interactionCheckAdjacentTileIsSolid_viaDirection		; $7655
	ret nz			; $7658
	ld h,d			; $7659
	ld l,$48		; $765a
	ld a,(hl)		; $765c
	add a			; $765d
	add a			; $765e
	ld l,$49		; $765f
	ld (hl),a		; $7661
	ld l,$46		; $7662
	ld (hl),$20		; $7664
	ld l,$44		; $7666
	inc (hl)		; $7668
	call $76e0		; $7669
	ld a,$71		; $766c
	jp playSound		; $766e
_label_09_263:
	ld e,$46		; $7671
	ld a,$1e		; $7673
	ld (de),a		; $7675
	ret			; $7676
_label_09_264:
	ld a,$0a		; $7677
	call objectSetCollideRadius		; $7679
	ld a,($d00b)		; $767c
	ld b,a			; $767f
	ld a,($d00d)		; $7680
	ld c,a			; $7683
	call interactionCheckContainsPoint		; $7684
	ret nc			; $7687
	ld a,($d00f)		; $7688
	ld b,a			; $768b
	cp $e8			; $768c
	jr nc,_label_09_265	; $768e
	ld e,$70		; $7690
	ld (de),a		; $7692
_label_09_265:
	ld a,b			; $7693
	cp $fc			; $7694
	ret c			; $7696
	ld e,$70		; $7697
	ld a,(de)		; $7699
	or a			; $769a
	jr nz,_label_09_266	; $769b
	ld hl,$5efb		; $769d
	ld e,$15		; $76a0
	call interBankCall		; $76a2
_label_09_266:
	ld e,Interaction.state		; $76a5
	ld a,$04		; $76a7
	ld (de),a		; $76a9
	xor a			; $76aa
	call interactionSetAnimation		; $76ab
	ld a,$53		; $76ae
	jp playSound		; $76b0
	call objectApplySpeed		; $76b3
	call objectPreventLinkFromPassing		; $76b6
	call interactionDecCounter1		; $76b9
	ret nz			; $76bc
	ld l,$44		; $76bd
	dec (hl)		; $76bf
	ld l,$46		; $76c0
	ld (hl),$1e		; $76c2
	jr _label_09_267		; $76c4
	call interactionAnimate		; $76c6
	ld e,$61		; $76c9
	ld a,(de)		; $76cb
	inc a			; $76cc
	ret nz			; $76cd
	ld e,Interaction.state		; $76ce
	ld a,$02		; $76d0
	ld (de),a		; $76d2
	ret			; $76d3
_label_09_267:
	call objectGetTileAtPosition		; $76d4
	ld e,$71		; $76d7
	ld (de),a		; $76d9
	ld (hl),$07		; $76da
	dec h			; $76dc
	ld (hl),$14		; $76dd
	ret			; $76df
	call objectGetTileAtPosition		; $76e0
	ld e,$71		; $76e3
	ld a,(de)		; $76e5
	ld (hl),a		; $76e6
	dec h			; $76e7
	ld (hl),$00		; $76e8
	ret			; $76ea

interactionCode80:
	call checkInteractionState		; $76eb
	jr nz,_label_09_268	; $76ee
	ld a,$01		; $76f0
	ld (de),a		; $76f2
	call interactionInitGraphics		; $76f3
	ld b,$07		; $76f6
	call seasonsFunc_3e07		; $76f8
	ld a,c			; $76fb
	or a			; $76fc
	jp z,interactionDelete		; $76fd
	ld e,Interaction.subid		; $7700
	ld a,b			; $7702
	ld (de),a		; $7703
	ld hl,$7717		; $7704
	rst_addDoubleIndex			; $7707
	ldi a,(hl)		; $7708
	ld h,(hl)		; $7709
	ld l,a			; $770a
	call interactionSetScript		; $770b
	jp objectSetVisible82		; $770e
_label_09_268:
	call interactionRunScript		; $7711
	jp interactionAnimateAsNpc		; $7714
	ld b,h			; $7717
	ld (hl),b		; $7718
	ld b,h			; $7719
	ld (hl),b		; $771a
	ld b,a			; $771b
	ld (hl),b		; $771c
	ld b,a			; $771d
	ld (hl),b		; $771e
	ld c,d			; $771f
	ld (hl),b		; $7720
	ld c,l			; $7721
	ld (hl),b		; $7722
	ld c,l			; $7723
	ld (hl),b		; $7724
	ld c,l			; $7725
	ld (hl),b		; $7726
	ld d,b			; $7727
	ld (hl),b		; $7728
	ld b,a			; $7729
	ld (hl),b		; $772a
	ld d,e			; $772b
	ld (hl),b		; $772c

interactionCode81:
	ld e,Interaction.state		; $772d
	ld a,(de)		; $772f
	rst_jumpTable			; $7730
	add hl,sp		; $7731
	ld (hl),a		; $7732
	ld hl,sp+$77		; $7733
	ld a,(de)		; $7735
	ld a,b			; $7736
	jr c,_label_09_275	; $7737
	ld a,$01		; $7739
	ld (de),a		; $773b
	ld e,$40		; $773c
	ld a,(de)		; $773e
	or $80			; $773f
	ld (de),a		; $7741
_label_09_269:
	ld e,Interaction.subid		; $7742
	ld a,(de)		; $7744
	cp $0a			; $7745
	jr z,_label_09_270	; $7747
	cp $0d			; $7749
	jr nz,_label_09_272	; $774b
	ld a,($c6bb)		; $774d
	bit 2,a			; $7750
	jr z,_label_09_271	; $7752
	ld a,TREASURE_MEMBERS_CARD		; $7754
	call checkTreasureObtained		; $7756
	jr c,_label_09_271	; $7759
	jr _label_09_272		; $775b
_label_09_270:
	ld a,($c6a9)		; $775d
	cp $02			; $7760
	jr nc,_label_09_271	; $7762
	ld a,TREASURE_SHIELD		; $7764
	call checkTreasureObtained		; $7766
	jr nc,_label_09_272	; $7769
_label_09_271:
	ld a,(de)		; $776b
	inc a			; $776c
	ld (de),a		; $776d
	jr _label_09_272		; $776e
_label_09_272:
	ld a,(de)		; $7770
	add a			; $7771
	ld hl,$779e		; $7772
	rst_addDoubleIndex			; $7775
	ld a,($c642)		; $7776
	and (hl)		; $7779
	jr nz,_label_09_274	; $777a
	inc hl			; $777c
	ld e,$77		; $777d
	ld b,$03		; $777f
_label_09_273:
	ldi a,(hl)		; $7781
	ld (de),a		; $7782
	inc e			; $7783
	dec b			; $7784
	jr nz,_label_09_273	; $7785
	call interactionInitGraphics		; $7787
	ld e,$66		; $778a
	ld a,$06		; $778c
	ld (de),a		; $778e
	inc e			; $778f
	ld (de),a		; $7790
	ld e,$71		; $7791
	call objectAddToAButtonSensitiveObjectList		; $7793
	jp objectSetVisible82		; $7796
_label_09_274:
	ld a,(de)		; $7799
	inc a			; $779a
	ld (de),a		; $779b
	jr _label_09_269		; $779c
	ld bc,$0000		; $779e
	nop			; $77a1
	inc b			; $77a2
	xor d			; $77a3
	stop			; $77a4
	dec bc			; $77a5
	ld ($20b6),sp		; $77a6
	ld b,$00		; $77a9
	or (hl)			; $77ab
	jr nz,$0c		; $77ac
	ld (bc),a		; $77ae
	or l			; $77af
	stop			; $77b0
_label_09_275:
	dec b			; $77b1
	stop			; $77b2
	nop			; $77b3
	nop			; $77b4
	rlca			; $77b5
	jr nz,_label_09_276	; $77b6
_label_09_276:
	nop			; $77b8
	ld b,$40		; $77b9
	nop			; $77bb
	nop			; $77bc
	dec bc			; $77bd
	add b			; $77be
	nop			; $77bf
	nop			; $77c0
	add hl,bc		; $77c1
	nop			; $77c2
	nop			; $77c3
	nop			; $77c4
	inc bc			; $77c5
	nop			; $77c6
	or l			; $77c7
	dec b			; $77c8
	nop			; $77c9
	nop			; $77ca
	nop			; $77cb
	nop			; $77cc
	ld a,(bc)		; $77cd
	nop			; $77ce
	nop			; $77cf
	nop			; $77d0
	inc b			; $77d1
	nop			; $77d2
	nop			; $77d3
	nop			; $77d4
	inc bc			; $77d5
	nop			; $77d6
	cp b			; $77d7
	jr nz,_label_09_277	; $77d8
_label_09_277:
	ld b,(hl)		; $77da
	nop			; $77db
	inc bc			; $77dc
	stop			; $77dd
	inc (hl)		; $77de
	ld bc,$0134		; $77df
	dec hl			; $77e2
	ld bc,$032d		; $77e3
	dec l			; $77e6
	inc bc			; $77e7
	dec l			; $77e8
	inc bc			; $77e9
	dec l			; $77ea
	ld (bc),a		; $77eb
	jr nz,_label_09_278	; $77ec
	ld bc,$2201		; $77ee
	stop			; $77f1
_label_09_278:
	add hl,hl		; $77f2
	inc c			; $77f3
	ld d,e			; $77f4
	stop			; $77f5
	scf			; $77f6
	inc b			; $77f7
	call interactionAnimateAsNpc		; $77f8
	ld e,$71		; $77fb
	ld a,(de)		; $77fd
	or a			; $77fe
	ret z			; $77ff
	xor a			; $7800
	ld (de),a		; $7801
	ld e,$7d		; $7802
	ld (de),a		; $7804
	call $7931		; $7805
	ld e,Interaction.state		; $7808
	ld a,$02		; $780a
	ld (de),a		; $780c
	ld e,Interaction.subid		; $780d
	ld a,(de)		; $780f
	ld hl,$7994		; $7810
	rst_addDoubleIndex			; $7813
	ldi a,(hl)		; $7814
	ld h,(hl)		; $7815
	ld l,a			; $7816
	jp interactionSetScript		; $7817
	call interactionAnimateAsNpc		; $781a
	call interactionRunScript		; $781d
	ret nc			; $7820
	ld e,$7d		; $7821
	ld a,(de)		; $7823
	bit 7,a			; $7824
	ld e,Interaction.state		; $7826
	ld a,$01		; $7828
	ld (de),a		; $782a
	ret nz			; $782b
	ld a,$03		; $782c
	ld (de),a		; $782e
	inc e			; $782f
	xor a			; $7830
	ld (de),a		; $7831
	ld a,$80		; $7832
	ld ($cc02),a		; $7834
	ret			; $7837
	ld e,Interaction.state2		; $7838
	ld a,(de)		; $783a
	rst_jumpTable			; $783b
	ld b,(hl)		; $783c
	ld a,b			; $783d
	ret nz			; $783e
	ld a,b			; $783f
	call $fb78		; $7840
	ld a,b			; $7843
	inc e			; $7844
	ld a,c			; $7845
	call objectSetVisible80		; $7846
	ld a,($ccea)		; $7849
	dec a			; $784c
	ld ($ccea),a		; $784d
	call $7973		; $7850
	ld a,$04		; $7853
	ld ($cc6a),a		; $7855
	ld a,$01		; $7858
	ld ($cc6b),a		; $785a
	ld h,d			; $785d
	ld l,$4b		; $785e
	ld a,($d00b)		; $7860
	sub $0e			; $7863
	ld (hl),a		; $7865
	ld l,$4d		; $7866
	ld a,($d00d)		; $7868
	ld (hl),a		; $786b
	ld l,$46		; $786c
	ld a,$80		; $786e
	ldi (hl),a		; $7870
	ld (hl),$04		; $7871
	ld l,$45		; $7873
	ld a,$01		; $7875
	ld (hl),a		; $7877
	ld hl,$cbea		; $7878
	set 2,(hl)		; $787b
	ld e,Interaction.subid		; $787d
	ld a,(de)		; $787f
	cp $01			; $7880
	jr z,_label_09_280	; $7882
	ld hl,$77da		; $7884
	rst_addDoubleIndex			; $7887
	ldi a,(hl)		; $7888
	ld c,(hl)		; $7889
	cp $2d			; $788a
	jr nz,_label_09_279	; $788c
	call getRandomRingOfGivenTier		; $788e
_label_09_279:
	call giveTreasure		; $7891
	ld e,Interaction.subid		; $7894
	ld a,(de)		; $7896
	ld hl,$78b1		; $7897
	rst_addAToHl			; $789a
	ld c,(hl)		; $789b
	ld b,$00		; $789c
	call showText		; $789e
	ld e,Interaction.subid		; $78a1
	ld a,(de)		; $78a3
	cp $04			; $78a4
	ret z			; $78a6
	ld a,$4c		; $78a7
	jp playSound		; $78a9
_label_09_280:
	ld h,d			; $78ac
	ld l,$45		; $78ad
	inc (hl)		; $78af
	ret			; $78b0
	ld b,c			; $78b1
	nop			; $78b2
	ld c,e			; $78b3
	ld c,e			; $78b4
	rla			; $78b5
	ld d,h			; $78b6
	ld d,h			; $78b7
	ld d,h			; $78b8
	ld d,h			; $78b9
	ld c,a			; $78ba
	rra			; $78bb
	ld d,b			; $78bc
	ld c,h			; $78bd
	ld b,l			; $78be
	ld c,(hl)		; $78bf
	call retIfTextIsActive		; $78c0
	xor a			; $78c3
	ld ($cca4),a		; $78c4
	ld ($cc02),a		; $78c7
	jp interactionDelete		; $78ca
	call interactionDecCounter1		; $78cd
	jr z,_label_09_281	; $78d0
	inc l			; $78d2
	dec (hl)		; $78d3
	ret nz			; $78d4
	ld (hl),$04		; $78d5
	ld a,$01		; $78d7
	ld l,$5c		; $78d9
	xor (hl)		; $78db
	ld (hl),a		; $78dc
	ret			; $78dd
_label_09_281:
	ld l,$5b		; $78de
	ld a,$0a		; $78e0
	ldi (hl),a		; $78e2
	ldi (hl),a		; $78e3
	ld (hl),$0c		; $78e4
	ld l,$45		; $78e6
	ld (hl),$03		; $78e8
	ld l,$47		; $78ea
	ld (hl),$1e		; $78ec
	ld a,$08		; $78ee
	call interactionSetAnimation		; $78f0
	ld a,$bc		; $78f3
	call playSound		; $78f5
	jp fadeoutToWhite		; $78f8
	call interactionAnimate		; $78fb
	ld a,($c4ab)		; $78fe
	or a			; $7901
	ret nz			; $7902
	call interactionDecCounter2		; $7903
	ret nz			; $7906
	ld l,$5a		; $7907
	ld (hl),a		; $7909
	ld l,$45		; $790a
	ld (hl),$04		; $790c
	ld hl,$c6ab		; $790e
	ld a,(hl)		; $7911
	add $20			; $7912
	ldd (hl),a		; $7914
	ld (hl),a		; $7915
	call setStatusBarNeedsRefreshBit1		; $7916
	jp fadeinFromWhite		; $7919
	ld a,($c4ab)		; $791c
	or a			; $791f
	ret nz			; $7920
	xor a			; $7921
	ld ($cca4),a		; $7922
	ld ($cc02),a		; $7925
	ld bc,$2b0e		; $7928
	call showText		; $792b
	jp interactionDelete		; $792e
	ld e,$7b		; $7931
	xor a			; $7933
	ld (de),a		; $7934
	ld e,Interaction.subid		; $7935
	ld a,(de)		; $7937
	or a			; $7938
	jr z,_label_09_285	; $7939
	ld e,$77		; $793b
	ld a,(de)		; $793d
	or a			; $793e
	jr z,_label_09_282	; $793f
	ld l,a			; $7941
	ld h,$c6		; $7942
	inc e			; $7944
	ld a,(de)		; $7945
	ld b,a			; $7946
	ld a,(hl)		; $7947
	cp b			; $7948
	jr c,_label_09_283	; $7949
_label_09_282:
	ld e,$7b		; $794b
	ld a,$01		; $794d
	ld (de),a		; $794f
_label_09_283:
	ld e,$79		; $7950
	ld a,(de)		; $7952
	call cpOreChunkValue		; $7953
	ld hl,$cba8		; $7956
	ld (hl),c		; $7959
	inc l			; $795a
	ld (hl),b		; $795b
	ld e,$7b		; $795c
	xor $01			; $795e
	jr z,_label_09_284	; $7960
	ld c,a			; $7962
	ld a,(de)		; $7963
	and c			; $7964
_label_09_284:
	ld (de),a		; $7965
	ret			; $7966
_label_09_285:
	ld a,TREASURE_STAR_ORE		; $7967
	call checkTreasureObtained		; $7969
	ret nc			; $796c
	ld e,$7b		; $796d
	ld a,$01		; $796f
	ld (de),a		; $7971
	ret			; $7972
	ld e,Interaction.subid		; $7973
	ld a,(de)		; $7975
	or a			; $7976
	ret z			; $7977
	ld a,$ff		; $7978
	ld ($cbea),a		; $797a
	ld e,$77		; $797d
	ld a,(de)		; $797f
	or a			; $7980
	jr z,_label_09_286	; $7981
	ld l,a			; $7983
	ld h,$c6		; $7984
	inc e			; $7986
	ld a,(de)		; $7987
	ld c,a			; $7988
	ld a,(hl)		; $7989
	sub c			; $798a
	daa			; $798b
	ld (hl),a		; $798c
_label_09_286:
	ld e,$79		; $798d
	ld a,(de)		; $798f
	ld c,a			; $7990
	jp removeOreChunkValue		; $7991
	ld d,(hl)		; $7994
	ld (hl),b		; $7995
	ld h,c			; $7996
	ld (hl),b		; $7997
	ld (hl),b		; $7998
	ld (hl),b		; $7999
	ld (hl),b		; $799a
	ld (hl),b		; $799b
	ld a,e			; $799c
	ld (hl),b		; $799d
	add (hl)		; $799e
	ld (hl),b		; $799f
	sub c			; $79a0
	ld (hl),b		; $79a1
	sbc h			; $79a2
	ld (hl),b		; $79a3
	and a			; $79a4
	ld (hl),b		; $79a5
	or d			; $79a6
	ld (hl),b		; $79a7
	cp c			; $79a8
	ld (hl),b		; $79a9
	ret nz			; $79aa
	ld (hl),b		; $79ab
	rst_jumpTable			; $79ac
	ld (hl),b		; $79ad
	adc $70			; $79ae
	push de			; $79b0
	ld (hl),b		; $79b1

interactionCode82:
	call checkInteractionState		; $79b2
	jr nz,_label_09_287	; $79b5
	ld a,$01		; $79b7
	ld (de),a		; $79b9
	ld h,d			; $79ba
	ld l,$4e		; $79bb
	xor a			; $79bd
	ldi (hl),a		; $79be
	ld (hl),a		; $79bf
	call $7a99		; $79c0
	ld l,$46		; $79c3
	ld (hl),$5a		; $79c5
	call interactionInitGraphics		; $79c7
	jp objectSetVisible82		; $79ca
_label_09_287:
	ld e,Interaction.state2		; $79cd
	ld a,(de)		; $79cf
	rst_jumpTable			; $79d0
.DB $dd				; $79d1
	ld a,c			; $79d2
	rrca			; $79d3
	ld a,d			; $79d4
	ld hl,$417a		; $79d5
	ld a,d			; $79d8
	ld h,d			; $79d9
	ld a,d			; $79da
	ld l,a			; $79db
	ld a,d			; $79dc
	call $7a09		; $79dd
	call objectGetRelatedObject1Var		; $79e0
	ld l,$4d		; $79e3
	ld a,(hl)		; $79e5
	add $08			; $79e6
	ld b,a			; $79e8
	ld e,l			; $79e9
	ld a,(de)		; $79ea
	cp b			; $79eb
	jr c,_label_09_288	; $79ec
	call interactionIncState2		; $79ee
	ld l,$46		; $79f1
	ld (hl),$14		; $79f3
	ld a,$06		; $79f5
	call interactionSetAnimation		; $79f7
	jr _label_09_289		; $79fa
_label_09_288:
	ld e,$46		; $79fc
	ld a,(de)		; $79fe
	or a			; $79ff
	jp z,$7a93		; $7a00
	jp interactionDecCounter1		; $7a03
_label_09_289:
	call $7a93		; $7a06
	call interactionAnimate		; $7a09
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7a0c
	call $7a06		; $7a0f
	call interactionDecCounter1		; $7a12
	ret nz			; $7a15
	ld l,$49		; $7a16
	ld (hl),$18		; $7a18
	ld l,$50		; $7a1a
	ld (hl),$28		; $7a1c
	jp interactionIncState2		; $7a1e
	call $7a06		; $7a21
	call objectGetRelatedObject1Var		; $7a24
	ld l,$4d		; $7a27
	ld a,(hl)		; $7a29
	add $04			; $7a2a
	call $7a9f		; $7a2c
	jp nz,objectApplySpeed		; $7a2f
	call interactionIncState2		; $7a32
	ld l,$46		; $7a35
	ld (hl),$0c		; $7a37
	ld l,$4e		; $7a39
	xor a			; $7a3b
	ldi (hl),a		; $7a3c
	ld (hl),a		; $7a3d
	jp $7aa5		; $7a3e
	call $7a09		; $7a41
	call interactionDecCounter1		; $7a44
	jp z,$7a4f		; $7a47
	call objectApplySpeed		; $7a4a
	jr _label_09_290		; $7a4d
	call interactionIncState2		; $7a4f
	ld l,$46		; $7a52
	ld (hl),$1e		; $7a54
	ld l,$49		; $7a56
	ld (hl),$08		; $7a58
	ld a,$05		; $7a5a
	call interactionSetAnimation		; $7a5c
_label_09_290:
	jp $7aa5		; $7a5f
	call $7a09		; $7a62
	call $7aa5		; $7a65
	call interactionDecCounter1		; $7a68
	ret nz			; $7a6b
	jp interactionIncState2		; $7a6c
	call $7a06		; $7a6f
	call $7aa5		; $7a72
	call objectApplySpeed		; $7a75
	ld e,$76		; $7a78
	ld a,(de)		; $7a7a
	call $7a9f		; $7a7b
	ret nz			; $7a7e
	ld hl,$cceb		; $7a7f
	ld (hl),$02		; $7a82
	ld h,d			; $7a84
	ld l,$45		; $7a85
	ld (hl),$00		; $7a87
	ld l,$4e		; $7a89
	xor a			; $7a8b
	ldi (hl),a		; $7a8c
	ld (hl),a		; $7a8d
	ld l,$46		; $7a8e
	ld (hl),$3c		; $7a90
	ret			; $7a92
	ld c,$20		; $7a93
	call objectUpdateSpeedZ_paramC		; $7a95
	ret nz			; $7a98
	ld bc,$ff40		; $7a99
	jp objectSetSpeedZ		; $7a9c
	ld b,a			; $7a9f
	ld e,$4d		; $7aa0
	ld a,(de)		; $7aa2
	cp b			; $7aa3
	ret			; $7aa4
	ld a,$40		; $7aa5
	call objectGetRelatedObject1Var		; $7aa7
	ld e,$49		; $7aaa
	ld a,(de)		; $7aac
	cp $18			; $7aad
	ld c,$07		; $7aaf
	jr nz,_label_09_291	; $7ab1
	ld c,$fb		; $7ab3
_label_09_291:
	ld b,$fe		; $7ab5
	jp objectCopyPositionWithOffset		; $7ab7

interactionCode83:
	call checkInteractionState		; $7aba
	jr nz,_label_09_293	; $7abd
	ld a,$01		; $7abf
	ld (de),a		; $7ac1
	ld h,d			; $7ac2
	call $7aea		; $7ac3
	ld l,$50		; $7ac6
	ld (hl),$3c		; $7ac8
	ld l,$49		; $7aca
	ld (hl),$18		; $7acc
	call getFreeInteractionSlot		; $7ace
	jr nz,_label_09_292	; $7ad1
	ld (hl),$82		; $7ad3
	ld l,$57		; $7ad5
	ld (hl),d		; $7ad7
	ld bc,$00f4		; $7ad8
	call objectCopyPositionWithOffset		; $7adb
	ld l,$4d		; $7ade
	ld a,(hl)		; $7ae0
	ld l,$76		; $7ae1
	ld (hl),a		; $7ae3
_label_09_292:
	call interactionInitGraphics		; $7ae4
	jp objectSetVisible82		; $7ae7
	ld l,$4e		; $7aea
	ld (hl),$ff		; $7aec
	inc l			; $7aee
	ld (hl),$fc		; $7aef
	ret			; $7af1
_label_09_293:
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $7af2
	ld h,d			; $7af5
	ld l,$5a		; $7af6
	res 6,(hl)		; $7af8
	ld e,Interaction.state2		; $7afa
	ld a,(de)		; $7afc
	rst_jumpTable			; $7afd
	inc b			; $7afe
	ld a,e			; $7aff
	dec e			; $7b00
	ld a,e			; $7b01
	ld b,e			; $7b02
	ld a,e			; $7b03
	ld a,($cceb)		; $7b04
	cp $01			; $7b07
	ret nz			; $7b09
	call getRandomNumber_noPreserveVars		; $7b0a
	and $03			; $7b0d
	ld hl,$7b59		; $7b0f
	rst_addDoubleIndex			; $7b12
	ldi a,(hl)		; $7b13
	ld e,$54		; $7b14
	ld (de),a		; $7b16
	ld a,(hl)		; $7b17
	inc e			; $7b18
	ld (de),a		; $7b19
	jp interactionIncState2		; $7b1a
	ld c,$20		; $7b1d
	call objectUpdateSpeedZ_paramC		; $7b1f
	jp nz,objectApplySpeed		; $7b22
	ld l,$55		; $7b25
	ldd a,(hl)		; $7b27
	srl a			; $7b28
	ld b,a			; $7b2a
	ld a,(hl)		; $7b2b
	rra			; $7b2c
	cpl			; $7b2d
	add $01			; $7b2e
	ldi (hl),a		; $7b30
	ld a,b			; $7b31
	cpl			; $7b32
	adc $00			; $7b33
	ldd (hl),a		; $7b35
	ld bc,$ffa0		; $7b36
	ldi a,(hl)		; $7b39
	ld h,(hl)		; $7b3a
	ld l,a			; $7b3b
	call compareHlToBc		; $7b3c
	ret c			; $7b3f
	jp interactionIncState2		; $7b40
	ld a,($cceb)		; $7b43
	cp $02			; $7b46
	ret nz			; $7b48
	xor a			; $7b49
	ld (de),a		; $7b4a
	ld h,d			; $7b4b
	ld l,$76		; $7b4c
	ld e,$4b		; $7b4e
	ldi a,(hl)		; $7b50
	ld (de),a		; $7b51
	inc e			; $7b52
	inc e			; $7b53
	ld a,(hl)		; $7b54
	ld (de),a		; $7b55
	jp $7aea		; $7b56
	ld ($ff00+$fe),a	; $7b59
	add b			; $7b5b
	cp $20			; $7b5c
	cp $c0			; $7b5e
.DB $fd				; $7b60

; ==============================================================================
; INTERACID_SPARKLE
; ==============================================================================
interactionCode84:
	call checkInteractionState		; $7b61
	jr nz,_label_09_294	; $7b64
	call interactionInitGraphics		; $7b66
	call interactionSetAlwaysUpdateBit		; $7b69
	ld l,$44		; $7b6c
	inc (hl)		; $7b6e
	ld e,Interaction.subid		; $7b6f
	ld a,(de)		; $7b71
	rst_jumpTable			; $7b72
	add a			; $7b73
	ld a,e			; $7b74
	sub a			; $7b75
	ld a,e			; $7b76
	adc a			; $7b77
	ld a,e			; $7b78
	sbc d			; $7b79
	ld a,e			; $7b7a
	and l			; $7b7b
	ld a,e			; $7b7c
	sub a			; $7b7d
	ld a,e			; $7b7e
	sub a			; $7b7f
	ld a,e			; $7b80
	adc h			; $7b81
	ld a,e			; $7b82
	xor b			; $7b83
	ld a,e			; $7b84
	sub a			; $7b85
	ld a,e			; $7b86
	ld h,d			; $7b87
	ld l,$46		; $7b88
	ld (hl),$78		; $7b8a
	jp objectSetVisible82		; $7b8c
	ld h,d			; $7b8f
	ld l,$50		; $7b90
	ld (hl),$80		; $7b92
	inc l			; $7b94
	ld (hl),$ff		; $7b95
	jp objectSetVisible81		; $7b97
	ld h,d			; $7b9a
	ld l,$50		; $7b9b
	ld (hl),$c0		; $7b9d
	inc l			; $7b9f
	ld (hl),$ff		; $7ba0
	jp objectSetVisible81		; $7ba2
	jp objectSetVisible80		; $7ba5
	ld h,d			; $7ba8
	ld l,$46		; $7ba9
	ld (hl),$c2		; $7bab
	jp objectSetVisible80		; $7bad
_label_09_294:
	ld e,Interaction.subid		; $7bb0
	ld a,(de)		; $7bb2
	rst_jumpTable			; $7bb3
	ret z			; $7bb4
	ld a,e			; $7bb5
	sbc $7b			; $7bb6
.DB $db				; $7bb8
	ld a,e			; $7bb9
.DB $db				; $7bba
	ld a,e			; $7bbb
	jp hl			; $7bbc
	ld a,e			; $7bbd
	sbc $7b			; $7bbe
.DB $fd				; $7bc0
	ld a,e			; $7bc1
	ret z			; $7bc2
	ld a,e			; $7bc3
	dec d			; $7bc4
	ld a,h			; $7bc5
	di			; $7bc6
	ld a,e			; $7bc7
_label_09_295:
	call interactionDecCounter1		; $7bc8
	jp z,interactionDelete		; $7bcb
_label_09_296:
	call interactionAnimate		; $7bce
	ld a,(wFrameCounter)		; $7bd1
_label_09_297:
	rrca			; $7bd4
	jp c,objectSetInvisible		; $7bd5
	jp objectSetVisible		; $7bd8
	call objectApplyComponentSpeed		; $7bdb
	ld e,$61		; $7bde
	ld a,(de)		; $7be0
	cp $ff			; $7be1
	jp z,interactionDelete		; $7be3
	jp interactionAnimate		; $7be6
	ld a,($cfc0)		; $7be9
	bit 0,a			; $7bec
	jp nz,interactionDelete		; $7bee
	jr _label_09_296		; $7bf1
	ld a,($cbb9)		; $7bf3
	cp $06			; $7bf6
	jp z,interactionDelete		; $7bf8
	jr _label_09_298		; $7bfb
	ld a,($cbb9)		; $7bfd
	cp $07			; $7c00
	jp z,interactionDelete		; $7c02
_label_09_298:
	call interactionAnimate		; $7c05
	ld a,$0b		; $7c08
	call objectGetRelatedObject1Var		; $7c0a
	call objectTakePosition		; $7c0d
	ld a,($cbb7)		; $7c10
	jr _label_09_297		; $7c13
	ld a,$0b		; $7c15
	call objectGetRelatedObject1Var		; $7c17
	call objectTakePosition		; $7c1a
	jr _label_09_295		; $7c1d

interactionCode85:
	ld e,Interaction.state		; $7c1f
	ld a,(de)		; $7c21
	rst_jumpTable			; $7c22
	daa			; $7c23
	ld a,h			; $7c24
	ld b,h			; $7c25
	ld a,h			; $7c26
	ld a,$01		; $7c27
	ld (de),a		; $7c29
	ld a,$98		; $7c2a
	call getARoomFlags		; $7c2c
	and $40			; $7c2f
	jp nz,interactionDelete		; $7c31
	ld hl,$cfd7		; $7c34
	ld a,(hl)		; $7c37
	or a			; $7c38
	ret nz			; $7c39
	inc a			; $7c3a
	ld (hl),a		; $7c3b
	ld ($cc02),a		; $7c3c
	ld a,$08		; $7c3f
	call playSound		; $7c41
	ld a,($d00d)		; $7c44
	cp $70			; $7c47
	ld a,$01		; $7c49
	jr c,_label_09_299	; $7c4b
	inc a			; $7c4d
_label_09_299:
	ld h,d			; $7c4e
	ld l,$77		; $7c4f
	cp (hl)			; $7c51
	ret z			; $7c52
	ld (hl),a		; $7c53
	jp setMusicVolume		; $7c54

interactionCode86:
	call checkInteractionState		; $7c57
	jr nz,_label_09_300	; $7c5a
	ld a,$01		; $7c5c
	ld (de),a		; $7c5e
	call interactionInitGraphics		; $7c5f
	ld e,Interaction.subid		; $7c62
	ld a,(de)		; $7c64
	ld b,a			; $7c65
	add a			; $7c66
	add b			; $7c67
	ld b,a			; $7c68
	ld h,d			; $7c69
	ld l,$62		; $7c6a
	ldi a,(hl)		; $7c6c
	ld h,(hl)		; $7c6d
	ld l,a			; $7c6e
	ld a,b			; $7c6f
	rst_addAToHl			; $7c70
	ld e,$62		; $7c71
	ld a,l			; $7c73
	ld (de),a		; $7c74
	inc e			; $7c75
	ld a,h			; $7c76
	ld (de),a		; $7c77
	call $7cb3		; $7c78
	jp objectSetVisible81		; $7c7b
_label_09_300:
	ld hl,$cfd3		; $7c7e
	ld a,(hl)		; $7c81
	inc a			; $7c82
	jp z,interactionDelete		; $7c83
	dec a			; $7c86
	and $7f			; $7c87
	ld b,a			; $7c89
	ld h,d			; $7c8a
	ld l,$43		; $7c8b
	ld a,(hl)		; $7c8d
	cp b			; $7c8e
	jr z,_label_09_301	; $7c8f
	ld (hl),b		; $7c91
	call $7cb3		; $7c92
	jr _label_09_302		; $7c95
_label_09_301:
	ld e,$61		; $7c97
	ld a,(de)		; $7c99
	inc a			; $7c9a
	call z,$7cb3		; $7c9b
_label_09_302:
	call interactionAnimate		; $7c9e
	ld e,Interaction.subid		; $7ca1
	ld a,(de)		; $7ca3
	and $01			; $7ca4
	ld b,a			; $7ca6
	ld a,(wFrameCounter)		; $7ca7
	and $01			; $7caa
	xor b			; $7cac
	jp z,objectSetInvisible		; $7cad
	jp objectSetVisible		; $7cb0
	ld hl,$cfd3		; $7cb3
	ld a,(hl)		; $7cb6
	and $7f			; $7cb7
	ld hl,$7cd8		; $7cb9
	rst_addDoubleIndex			; $7cbc
	ldi a,(hl)		; $7cbd
	ld h,(hl)		; $7cbe
	ld l,a			; $7cbf
	ld e,Interaction.subid		; $7cc0
	ld a,(de)		; $7cc2
	rst_addDoubleIndex			; $7cc3
	ldi a,(hl)		; $7cc4
	ld e,$4b		; $7cc5
	call $7ccd		; $7cc7
	ld a,(hl)		; $7cca
	ld e,$4d		; $7ccb
	ld b,a			; $7ccd
	call getRandomNumber		; $7cce
	and $03			; $7cd1
	sub $02			; $7cd3
	add b			; $7cd5
	ld (de),a		; $7cd6
	ret			; $7cd7
	ld ($ff00+c),a		; $7cd8
	ld a,h			; $7cd9
.DB $ec				; $7cda
	ld a,h			; $7cdb
	or $7c			; $7cdc
	nop			; $7cde
	ld a,l			; $7cdf
	ld a,(bc)		; $7ce0
	ld a,l			; $7ce1
	ld a,c			; $7ce2
	ld b,d			; $7ce3
	ld a,e			; $7ce4
	ld c,(hl)		; $7ce5
	ld a,(hl)		; $7ce6
	ld e,e			; $7ce7
	add b			; $7ce8
	ld (hl),b		; $7ce9
	add c			; $7cea
	adc d			; $7ceb
	nop			; $7cec
	jr c,_label_09_309	; $7ced
	jr nz,_label_09_305	; $7cef
	ld b,b			; $7cf1
	inc a			; $7cf2
	sub c			; $7cf3
	inc (hl)		; $7cf4
	ld h,h			; $7cf5
	inc l			; $7cf6
	ld a,(hl)		; $7cf7
	ld e,$9e		; $7cf8
	ld d,b			; $7cfa
	ld l,(hl)		; $7cfb
	jr z,_label_09_304	; $7cfc
	ld h,b			; $7cfe
	jr nz,_label_09_303	; $7cff
	jr _label_09_306		; $7d01
	ld h,h			; $7d03
	nop			; $7d04
	ld e,h			; $7d05
	ld l,b			; $7d06
	ld (hl),b		; $7d07
	ld (hl),h		; $7d08
	inc (hl)		; $7d09
	ld ($ff00+$e0),a	; $7d0a
	ld a,e			; $7d0c
	ld c,(hl)		; $7d0d
	ld a,(hl)		; $7d0e
	ld e,b			; $7d0f
	add b			; $7d10
	ld l,b			; $7d11
	add c			; $7d12
	add b			; $7d13

interactionCode87:
	ld e,Interaction.state		; $7d14
	ld a,(de)		; $7d16
	rst_jumpTable			; $7d17
	jr nz,$7d		; $7d18
	add d			; $7d1a
	ld a,l			; $7d1b
	add l			; $7d1c
_label_09_303:
	ld a,l			; $7d1d
	adc b			; $7d1e
	ld a,l			; $7d1f
	ld e,Interaction.subid		; $7d20
_label_09_304:
	ld a,(de)		; $7d22
	rst_jumpTable			; $7d23
	ldi a,(hl)		; $7d24
	ld a,l			; $7d25
	ld d,a			; $7d26
	ld a,l			; $7d27
	ld l,e			; $7d28
	ld a,l			; $7d29
	call interactionInitGraphics		; $7d2a
	call objectSetVisible83		; $7d2d
	call interactionSetAlwaysUpdateBit		; $7d30
	call $7d8b		; $7d33
	call $7e05		; $7d36
_label_09_305:
	ld hl,$710b		; $7d39
	call interactionSetScript		; $7d3c
	ld a,($cc39)		; $7d3f
	or a			; $7d42
	jr nz,_label_09_307	; $7d43
	ld a,$01		; $7d45
_label_09_306:
	jr _label_09_308		; $7d47
_label_09_307:
	ld a,$02		; $7d49
_label_09_308:
	ld e,Interaction.state		; $7d4b
	ld (de),a		; $7d4d
	call interactionRunScript		; $7d4e
	call interactionRunScript		; $7d51
	jp interactionRunScript		; $7d54
	ld e,Interaction.state		; $7d57
	ld a,$02		; $7d59
_label_09_309:
	ld (de),a		; $7d5b
	call interactionInitGraphics		; $7d5c
	call objectSetVisible83		; $7d5f
	ld hl,$7255		; $7d62
	call interactionSetScript		; $7d65
	jp interactionRunScript		; $7d68
	ld e,Interaction.state		; $7d6b
	ld a,$02		; $7d6d
	ld (de),a		; $7d6f
	call interactionInitGraphics		; $7d70
	call objectSetVisible83		; $7d73
	call interactionSetAlwaysUpdateBit		; $7d76
	ld hl,$7261		; $7d79
	call interactionSetScript		; $7d7c
	jp interactionRunScript		; $7d7f
	call $7df6		; $7d82
	call interactionRunScript		; $7d85
	jp interactionAnimate		; $7d88

seasonsFunc_09_7d8b:
	ld a,GLOBALFLAG_FINISHEDGAME		; $7d8b
	call checkGlobalFlag		; $7d8d
	jp nz,seasonsFunc_09_7df0		; $7d90
	ld a,TREASURE_ESSENCE		; $7d93
	call checkTreasureObtained		; $7d95
	jr c,+			; $7d98
	xor a			; $7d9a
+
	cp $17			; $7d9b
	jr z,_label_09_313	; $7d9d
	cp $1f			; $7d9f
	jr z,_label_09_314	; $7da1
	call getHighestSetBit		; $7da3
	jr nc,_label_09_311	; $7da6
	inc a			; $7da8
_label_09_311:
	call $7df2		; $7da9
	cp $01			; $7dac
	jr z,_label_09_312	; $7dae
	cp $08			; $7db0
	jr z,_label_09_316	; $7db2
	ret			; $7db4
_label_09_312:
	ld a,$01		; $7db5
	ld b,$2a		; $7db7
	call getRoomFlags		; $7db9
	and $40			; $7dbc
	ret z			; $7dbe
	ld a,$09		; $7dbf
	jr _label_09_318		; $7dc1
_label_09_313:
	ld a,$27		; $7dc3
	call setGlobalFlag		; $7dc5
	ld a,$0a		; $7dc8
	jr _label_09_318		; $7dca
_label_09_314:
	ld a,$27		; $7dcc
	call checkGlobalFlag		; $7dce
	jr nz,_label_09_315	; $7dd1
	ld a,$05		; $7dd3
	jr _label_09_318		; $7dd5
_label_09_315:
	ld a,$0b		; $7dd7
	jr _label_09_318		; $7dd9
_label_09_316:
	ld a,($c6df)		; $7ddb
	cp $09			; $7dde
	jr z,_label_09_317	; $7de0
	ld a,$19		; $7de2
	call checkGlobalFlag		; $7de4
	ret z			; $7de7
	ld a,$0c		; $7de8
	jr _label_09_318		; $7dea
_label_09_317:
	ld a,$0d		; $7dec
	jr _label_09_318		; $7dee

seasonsFunc_09_7df0:
	ld a,$0e		; $7df0
_label_09_318:
	ld ($cc39),a		; $7df2
	ret			; $7df5
	call getThisRoomFlags		; $7df6
	and $40			; $7df9
	ret nz			; $7dfb
	ld a,TREASURE_GNARLED_KEY		; $7dfc
	call checkTreasureObtained		; $7dfe
	ret nc			; $7e01
	set 6,(hl)		; $7e02
	ret			; $7e04
	call getThisRoomFlags		; $7e05
	bit 6,a			; $7e08
	ret nz			; $7e0a
	bit 7,a			; $7e0b
	ret z			; $7e0d
	call getFreeInteractionSlot		; $7e0e
	ret nz			; $7e11
	ld (hl),$60		; $7e12
	inc l			; $7e14
	ld (hl),$42		; $7e15
	inc l			; $7e17
	ld (hl),$01		; $7e18
	ld l,$4b		; $7e1a
	ld a,$58		; $7e1c
	ldi (hl),a		; $7e1e
	ld a,($c6e0)		; $7e1f
	ld l,$4d		; $7e22
	ld (hl),a		; $7e24
	ret			; $7e25

interactionCode88:
	call checkInteractionState		; $7e26
	jr nz,_label_09_321	; $7e29
	ld a,($c4ab)		; $7e2b
	or a			; $7e2e
	ret nz			; $7e2f
	ld a,$01		; $7e30
	ld (de),a		; $7e32
	ld e,$40		; $7e33
	ld a,(de)		; $7e35
	or $80			; $7e36
	ld (de),a		; $7e38
	call interactionInitGraphics		; $7e39
	call objectSetVisible82		; $7e3c
	call objectSetInvisible		; $7e3f
	ld e,Interaction.subid		; $7e42
	ld a,(de)		; $7e44
	or a			; $7e45
	jr z,_label_09_319	; $7e46
	ld a,($c486)		; $7e48
	cpl			; $7e4b
	inc a			; $7e4c
_label_09_319:
	add $28			; $7e4d
	ld l,$4b		; $7e4f
	ld (hl),a		; $7e51
	ld e,Interaction.subid		; $7e52
	ld a,(de)		; $7e54
	or a			; $7e55
	jr nz,_label_09_320	; $7e56
	call interactionIncState2		; $7e58
	ld hl,$7f33		; $7e5b
	jp $7f01		; $7e5e
_label_09_320:
	ld a,$30		; $7e61
	call checkGlobalFlag		; $7e63
	jp nz,interactionDelete		; $7e66
	ld e,$46		; $7e69
	ld a,$3c		; $7e6b
	ld (de),a		; $7e6d
	ret			; $7e6e
_label_09_321:
	ld a,$0a		; $7e6f
	call checkGlobalFlag		; $7e71
	jr nz,_label_09_322	; $7e74
	ld a,($c4ab)		; $7e76
	or a			; $7e79
	jp nz,interactionDelete		; $7e7a
_label_09_322:
	call checkInteractionState2		; $7e7d
	jr nz,_label_09_323	; $7e80
	call interactionDecCounter1		; $7e82
	ret nz			; $7e85
	ld l,$46		; $7e86
	ld (hl),$3c		; $7e88
	call getRandomNumber_noPreserveVars		; $7e8a
	and $01			; $7e8d
	ret z			; $7e8f
	call interactionIncState2		; $7e90
	call getRandomNumber_noPreserveVars		; $7e93
	and $03			; $7e96
	ld hl,$7f2b		; $7e98
	rst_addDoubleIndex			; $7e9b
	ldi a,(hl)		; $7e9c
	ld h,(hl)		; $7e9d
	ld l,a			; $7e9e
	jp $7f01		; $7e9f
_label_09_323:
	ld e,$70		; $7ea2
	ld a,(de)		; $7ea4
	or a			; $7ea5
	jr nz,_label_09_326	; $7ea6
	ld a,$01		; $7ea8
	ld (de),a		; $7eaa
	ld e,$47		; $7eab
	ld a,(de)		; $7ead
	ld hl,$7f28		; $7eae
	rst_addAToHl			; $7eb1
	ld a,(hl)		; $7eb2
	call loadPaletteHeader		; $7eb3
	ld a,$ff		; $7eb6
	ld ($cd29),a		; $7eb8
	ld a,(de)		; $7ebb
	or a			; $7ebc
	ld a,$d2		; $7ebd
	call nz,playSound		; $7ebf
	ld a,(de)		; $7ec2
	cp $02			; $7ec3
	jr z,_label_09_324	; $7ec5
	call objectSetInvisible		; $7ec7
	jr _label_09_326		; $7eca
_label_09_324:
	call getRandomNumber		; $7ecc
	and $01			; $7ecf
	ld b,a			; $7ed1
	ld a,$13		; $7ed2
	jr z,_label_09_325	; $7ed4
	ld a,$8d		; $7ed6
_label_09_325:
	ld e,$4d		; $7ed8
	ld (de),a		; $7eda
	ld a,b			; $7edb
	call interactionSetAnimation		; $7edc
	call objectSetVisible		; $7edf
_label_09_326:
	ld e,$47		; $7ee2
	ld a,(de)		; $7ee4
	cp $02			; $7ee5
	jr nz,_label_09_327	; $7ee7
	call interactionAnimate		; $7ee9
	ld e,$61		; $7eec
	ld a,(de)		; $7eee
	inc a			; $7eef
	jr nz,_label_09_327	; $7ef0
	call objectSetInvisible		; $7ef2
_label_09_327:
	call interactionDecCounter1		; $7ef5
	ret nz			; $7ef8
	ld h,d			; $7ef9
	ld l,$58		; $7efa
	ldi a,(hl)		; $7efc
	ld l,(hl)		; $7efd
	ld h,a			; $7efe
	inc hl			; $7eff
	inc hl			; $7f00
	ld e,$58		; $7f01
	ld a,h			; $7f03
	ld (de),a		; $7f04
	inc e			; $7f05
	ld a,l			; $7f06
	ld (de),a		; $7f07
	ldi a,(hl)		; $7f08
	inc a			; $7f09
	jr z,_label_09_328	; $7f0a
	ld e,$46		; $7f0c
	ld (de),a		; $7f0e
	inc e			; $7f0f
	ld a,(hl)		; $7f10
	ld (de),a		; $7f11
	ld e,$70		; $7f12
	xor a			; $7f14
	ld (de),a		; $7f15
	ret			; $7f16
_label_09_328:
	ld h,d			; $7f17
	ld l,$42		; $7f18
	ld a,(hl)		; $7f1a
	or a			; $7f1b
	jp z,interactionDelete		; $7f1c
	ld l,$45		; $7f1f
	ld (hl),$00		; $7f21
	ld l,$46		; $7f23
	ld (hl),$3c		; $7f25
	ret			; $7f27
	dec sp			; $7f28
	sbc c			; $7f29
	sbc d			; $7f2a
	inc sp			; $7f2b
	ld a,a			; $7f2c
	inc sp			; $7f2d
	ld a,a			; $7f2e
	inc sp			; $7f2f
	ld a,a			; $7f30
	inc sp			; $7f31
	ld a,a			; $7f32
	inc a			; $7f33
	nop			; $7f34
	ld (bc),a		; $7f35
	ld bc,$0004		; $7f36
	ld (bc),a		; $7f39
	ld (bc),a		; $7f3a
	ld a,b			; $7f3b
	nop			; $7f3c
	ld (bc),a		; $7f3d
	ld bc,$0002		; $7f3e
	ld (bc),a		; $7f41
	ld bc,$0002		; $7f42
	inc bc			; $7f45
	ld bc,$0001		; $7f46
	inc c			; $7f49
	ld (bc),a		; $7f4a
	inc a			; $7f4b
	nop			; $7f4c
	rst $38			; $7f4d
