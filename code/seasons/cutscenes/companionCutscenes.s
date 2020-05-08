specialObjectCode_companionCutscene:
	ld hl,w1Companion.id		; $69c9
	ld a,(hl)		; $69cc
	sub $0f			; $69cd
	rst_jumpTable			; $69cf
	.dw rickyCutscenes
	.dw dimitriCutscenes
	.dw mooshCutscenes
	.dw mapleCutscenes

rickyCutscenes:
	ld e,Object.state		; $69d8
	ld a,(de)		; $69da
	ld a,(de)		; $69db
	rst_jumpTable			; $69dc
	.dw @state0
	.dw _rickyState1

@state0:
	call _incState		; $69e1
	ld h,d			; $69e4
	ld l,Object.subid		; $69e5
	ld a,(hl)		; $69e7
	or a			; $69e8
	jr z,_func_69fe			; $69e9
	ld l,$10		; $69eb
	ld (hl),$50		; $69ed
	ld l,$09		; $69ef
	ld (hl),$08		; $69f1

_func_69f3:
	ld bc,$fe00		; $69f3
	call objectSetSpeedZ		; $69f6
	ld a,$02		; $69f9
	jp specialObjectSetAnimation		; $69fb

_func_69fe:
	xor a			; $69fe
	ld ($cbb5),a		; $69ff
	ld a,$1e		; $6a02
	jp specialObjectSetAnimation		; $6a04

_incState:
	ld a,$01		; $6a07
	ld (de),a		; $6a09
	callab bank5.specialObjectSetOamVariables
	jp objectSetVisiblec0		; $6a12

_rickyState1:
	ld e,Object.subid		; $6a15
	ld a,(de)		; $6a17
	rst_jumpTable			; $6a18
	.dw @subid0
	.dw @subid1

@subid0:
	ld e,Object.state2		; $6a1d
	ld a,(de)		; $6a1f
	rst_jumpTable			; $6a20
	.dw @@substate0
	.dw @@substate1

@@substate0:
	call specialObjectAnimate		; $6a25
	ld h,d			; $6a28
	ld l,$21		; $6a29
	ld a,(hl)		; $6a2b
	or a			; $6a2c
	jr z,+			; $6a2d
	ld a,$01		; $6a2f
	ld ($cbb5),a		; $6a31
	ld l,$05		; $6a34
	inc (hl)		; $6a36
+
	ld c,$20		; $6a37
	call objectUpdateSpeedZ_paramC		; $6a39
	ret nz			; $6a3c
	ld h,d			; $6a3d
	ld bc,$ff20		; $6a3e
	jp objectSetSpeedZ		; $6a41

@@substate1:
	call specialObjectAnimate		; $6a44
	ld h,d			; $6a47
	ld l,$21		; $6a48
	ld a,(hl)		; $6a4a
	or a			; $6a4b
	ret z			; $6a4c
	ld (hl),$00		; $6a4d
	inc a			; $6a4f
	jr z,+			; $6a50

@clink:
	call getFreeInteractionSlot		; $6a52
	ret nz			; $6a55
	ld (hl),INTERACID_CLINK		; $6a56
	ld bc,$f812		; $6a58
	jp objectCopyPositionWithOffset		; $6a5b

+
	ld l,$05		; $6a5e
	ld (hl),$00		; $6a60
	jp _func_69fe		; $6a62

@subid1:
	ld e,Object.state2		; $6a65
	ld a,(de)		; $6a67
	rst_jumpTable			; $6a68
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6
	.dw @@substate7
	.dw @@substate8
	.dw @@substate9
	.dw @@substateA

@@substate0:
	ld l,$05		; $6a7f
	inc (hl)		; $6a81

@@substate1:
	call objectApplySpeed		; $6a82
	ld e,$0d		; $6a85
	ld a,(de)		; $6a87
	bit 7,a			; $6a88
	jr nz,+			; $6a8a
	ld hl,$d00d		; $6a8c
	ld b,(hl)		; $6a8f
	add $18			; $6a90
	cp b			; $6a92
	jr c,+			; $6a93
	call itemIncState2		; $6a95
	inc (hl)		; $6a98
	inc l			; $6a99
	ld (hl),$3c		; $6a9a
	ld l,$0e		; $6a9c
	xor a			; $6a9e
	ldi (hl),a		; $6a9f
	ld (hl),a		; $6aa0
	jp specialObjectAnimate		; $6aa1
+
	ld c,$40		; $6aa4
	call objectUpdateSpeedZ_paramC		; $6aa6
	ret nz			; $6aa9
	call itemIncState2		; $6aaa
	ld l,$06		; $6aad
	ld (hl),$08		; $6aaf
	jp specialObjectAnimate		; $6ab1

@@substate2:
	call itemDecCounter1		; $6ab4
	ret nz			; $6ab7
	dec l			; $6ab8
	dec (hl)		; $6ab9
	jp _func_69f3		; $6aba

@@substate3:
	call itemDecCounter1		; $6abd
	ret nz			; $6ac0
	ld (hl),$5a		; $6ac1
	dec l			; $6ac3
	inc (hl)		; $6ac4
	ld a,$14		; $6ac5
	jp specialObjectSetAnimation		; $6ac7

@@substate4:
	call specialObjectAnimate		; $6aca
	call itemDecCounter1		; $6acd
	ret nz			; $6ad0
	ld (hl),$0c		; $6ad1
	dec l			; $6ad3
	inc (hl)		; $6ad4
	ld a,$1f		; $6ad5
	call specialObjectSetAnimation		; $6ad7
	jp @clink		; $6ada

@@substate5:
	call itemDecCounter1		; $6add
	ret nz			; $6ae0
	ld (hl),$3c		; $6ae1
	dec l			; $6ae3
	inc (hl)		; $6ae4
	ld a,$1e		; $6ae5
	jp specialObjectSetAnimation		; $6ae7

@@substate6:
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

@@substate7:
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

@@substate8:
	call itemDecCounter1		; $6b24
	ret nz			; $6b27
	dec l			; $6b28
	inc (hl)		; $6b29
	ld l,$09		; $6b2a
	ld (hl),$18		; $6b2c

@@func_6b2e:
	ld a,$1c		; $6b2e
	call specialObjectSetAnimation		; $6b30
	ld bc,$fe00		; $6b33
	jp objectSetSpeedZ		; $6b36

@@substate9:
	call objectApplySpeed		; $6b39
	ld e,$0d		; $6b3c
	ld a,(de)		; $6b3e
	sub $10			; $6b3f
	rlca			; $6b41
	jr nc,+			; $6b42
	ld hl,$cfdf		; $6b44
	ld (hl),$01		; $6b47
	ret			; $6b49
+
	ld c,$40		; $6b4a
	call objectUpdateSpeedZ_paramC		; $6b4c
	ret nz			; $6b4f
	call itemIncState2		; $6b50
	ld l,$06		; $6b53
	ld (hl),$08		; $6b55
	jp specialObjectAnimate		; $6b57

@@substateA:
	call itemDecCounter1		; $6b5a
	ret nz			; $6b5d
	ld l,$05		; $6b5e
	dec (hl)		; $6b60
	jp @@func_6b2e		; $6b61


mooshCutscenes:
	ld e,Object.state	; $6b64
	ld a,(de)		; $6b66
	rst_jumpTable			; $6b67
	.dw @state0
	.dw @state1

@state0:
	call _incState		; $6b6c
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
	jr nz,+			; $6b8a
	ld (hl),INTERACID_BANANA		; $6b8c
	ld l,$57		; $6b8e
	ld (hl),d		; $6b90
+
	ld a,$07		; $6b91
	jp specialObjectSetAnimation		; $6b93

@state1:
	ld e,Object.state2		; $6b96
	ld a,(de)		; $6b98
	or a			; $6b99
	jr z,+			; $6b9a
	call specialObjectAnimate		; $6b9c
	call objectApplySpeed		; $6b9f
+
	ld e,Object.state2		; $6ba2
	ld a,(de)		; $6ba4
	rst_jumpTable			; $6ba5
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4

@@substate0:
	call itemDecCounter1		; $6bb0
	ret nz			; $6bb3
	ld (hl),$48		; $6bb4
	ld l,$05		; $6bb6
	inc (hl)		; $6bb8
	ret			; $6bb9

@@substate1:
	call itemDecCounter1		; $6bba
	ret nz			; $6bbd
	ld (hl),$06		; $6bbe
	ld l,$05		; $6bc0
	inc (hl)		; $6bc2
	jp seasonsFunc_06_6d89		; $6bc3

@@substate2:
	ld h,d			; $6bc6
	ld l,$09		; $6bc7
	ld a,(hl)		; $6bc9
	cp $10			; $6bca
	jr z,@@func_6bd2			; $6bcc
	ld l,$05		; $6bce
	inc (hl)		; $6bd0
	ret			; $6bd1
@@func_6bd2:
	ld l,$06		; $6bd2
	dec (hl)		; $6bd4
	ret nz			; $6bd5
	call seasonsFunc_06_6da0		; $6bd6
	ld (hl),$06		; $6bd9
	jp seasonsFunc_06_6d89		; $6bdb

@@substate3:
	ld h,d			; $6bde
	ld l,$09		; $6bdf
	ld a,(hl)		; $6be1
	cp $10			; $6be2
	jr nz,@@func_6bd2	; $6be4
	ld l,$05		; $6be6
	inc (hl)		; $6be8
	ld a,$07		; $6be9
	jp specialObjectSetAnimation		; $6beb

@@substate4:
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


dimitriCutscenes:
	ld e,Object.state		; $6c0a
	ld a,(de)		; $6c0c
	rst_jumpTable			; $6c0d
	.dw @state0
	.dw @state1

@state0:
	call _incState		; $6c12
	ld h,d			; $6c15
	ld l,$10		; $6c16
	ld (hl),$28		; $6c18
	ld l,$0e		; $6c1a
	ld (hl),$e0		; $6c1c
	inc l			; $6c1e
	ld (hl),$ff		; $6c1f
	ld a,$19		; $6c21
	jp specialObjectSetAnimation		; $6c23

@state1:
	ld e,Object.state2		; $6c26
	ld a,(de)		; $6c28
	rst_jumpTable			; $6c29
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6

@@substate0:
	ld h,d			; $6c38
	ld l,$05		; $6c39
	inc (hl)		; $6c3b
	ld l,$07		; $6c3c
	ld a,(hl)		; $6c3e
	cp $02			; $6c3f
	jr nz,+			; $6c41
	push af			; $6c43
	ld a,$1a		; $6c44
	call specialObjectSetAnimation		; $6c46
	pop af			; $6c49
+
	ld b,a			; $6c4a
	add a			; $6c4b
	add b			; $6c4c
	ld hl,@@table_6c5b		; $6c4d
	rst_addAToHl			; $6c50
	ldi a,(hl)		; $6c51
	ld e,$09		; $6c52
	ld (de),a		; $6c54
	ld c,(hl)		; $6c55
	inc hl			; $6c56
	ld b,(hl)		; $6c57
	jp objectSetSpeedZ		; $6c58

@@table_6c5b:
	.db $0c $40 $fd
	.db $0c $a0 $fd
	.db $13 $80 $fe

@@substate1:
	call specialObjectAnimate			; $6c64
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
	jr z,+			; $6c79
	dec (hl)		; $6c7b
	ld l,$06		; $6c7c
	ld (hl),$08		; $6c7e
	ret			; $6c80
+
	inc (hl)		; $6c81
	ld l,$06		; $6c82
	ld (hl),$06		; $6c84
	ret			; $6c86

@@substate2:
	call itemDecCounter1		; $6c87
	ret nz			; $6c8a
	ld l,$05		; $6c8b
	inc (hl)		; $6c8d
	ld l,$06		; $6c8e
	ld (hl),$14		; $6c90
	ld a,$27		; $6c92
	jp specialObjectSetAnimation		; $6c94

@@substate3:
	call itemDecCounter1		; $6c97
	ret nz			; $6c9a
	ld l,$05		; $6c9b
	inc (hl)		; $6c9d
	ld l,$06		; $6c9e
	ld (hl),$78		; $6ca0
	ret			; $6ca2

@@substate4:
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

@@substate5:
	call itemDecCounter1		; $6cba
	ret nz			; $6cbd
	ld l,$05		; $6cbe
	inc (hl)		; $6cc0
	ld a,$26		; $6cc1
	jp specialObjectSetAnimation		; $6cc3

@@substate6:
	call specialObjectAnimate		; $6cc6
	call objectApplySpeed		; $6cc9
	ld e,$0d		; $6ccc
	ld a,(de)		; $6cce
	cp $78			; $6ccf
	jr nz,+			; $6cd1
	ld a,$05		; $6cd3
	jp specialObjectSetAnimation		; $6cd5
+
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


mapleCutscenes:
	ld e,Object.state		; $6cf4
	ld a,(de)		; $6cf6
	ld a,(de)		; $6cf7
	rst_jumpTable			; $6cf8
	.dw @state0
	.dw @state1

@state0:
	call _incState		; $6cfd
	ld h,d			; $6d00
	ld l,$10		; $6d01
	ld (hl),$32		; $6d03
	ld l,$36		; $6d05
	ld (hl),$04		; $6d07
	ld l,$02		; $6d09
	ld a,(hl)		; $6d0b
	or a			; $6d0c
	ld a,$f0		; $6d0d
	jr z,+			; $6d0f
	ld a,d			; $6d11
	ld ($cc48),a		; $6d12
	ld a,$d0		; $6d15
+
	ld l,$0f		; $6d17
	ld (hl),a		; $6d19
	ld l,$09		; $6d1a
	ld (hl),$18		; $6d1c
	ld l,$02		; $6d1e
	ld a,(hl)		; $6d20
	jp seasonsFunc_06_6d78		; $6d21

@state1:
	ld e,Object.subid		; $6d24
	ld a,(de)		; $6d26
	rst_jumpTable			; $6d27
	.dw @@subid0
	.dw @@subid1

@@subid1:
	ld e,Object.state2		; $6d2c
	ld a,(de)		; $6d2e
	rst_jumpTable			; $6d2f
	.dw @@@substate0
	.dw seasonsFunc_06_6d62
	.dw _ret

@@@substate0:
	ld a,($cfc0)		; $6d36
	or a			; $6d39
	jr z,@@subid0			; $6d3a
	call itemIncState2		; $6d3c
	ld bc,$ff00		; $6d3f
	call objectSetSpeedZ		; $6d42
	ld l,$09		; $6d45
	ld (hl),$0e		; $6d47
	ld l,$10		; $6d49
	ld (hl),$14		; $6d4b
	ld a,$1b		; $6d4d
	jp specialObjectSetAnimation		; $6d4f

@@subid0:
	ld h,d			; $6d52
	ld l,$02		; $6d53
	ld a,(hl)		; $6d55
	ld l,$06		; $6d56
	dec (hl)		; $6d58
	call z,seasonsFunc_06_6d78		; $6d59
	call objectApplySpeed		; $6d5c
	jp specialObjectAnimate		; $6d5f

seasonsFunc_06_6d62:
	call objectApplySpeed		; $6d62
	ld c,$20		; $6d65
	call objectUpdateSpeedZAndBounce		; $6d67
	jp nc,seasonsFunc_06_6d74		; $6d6a
	call itemIncState2		; $6d6d
	ld l,$20		; $6d70
	ld (hl),$01		; $6d72

seasonsFunc_06_6d74:
	jp specialObjectAnimate		; $6d74

_ret:
	ret			; $6d77

seasonsFunc_06_6d78:
	ld hl,seasonsTable_06_6da8		; $6d78
	rst_addDoubleIndex			; $6d7b
	ldi a,(hl)		; $6d7c
	ld h,(hl)		; $6d7d
	ld l,a			; $6d7e
	call seasonsFunc_06_6da0		; $6d7f
	ld b,a			; $6d82
	rst_addAToHl			; $6d83
	ld a,(hl)		; $6d84
	ld e,$06		; $6d85
	ld (de),a		; $6d87
	ld a,b			; $6d88

seasonsFunc_06_6d89:
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

seasonsFunc_06_6da0:
	ld e,$09		; $6da0
	ld a,(de)		; $6da2
	dec a			; $6da3
	and $1f			; $6da4
	ld (de),a		; $6da6
	ret			; $6da7

seasonsTable_06_6da8:
	.dw seasonsTable_06_6dac
	.dw seasonsTable_06_6dcc

seasonsTable_06_6dac:
	.db $06 $06 $06 $06 $07 $08 $09 $0a
	.db $0b $0a $09 $08 $07 $06 $06 $06
	.db $06 $06 $06 $06 $07 $08 $09 $0a
	.db $0b $0a $09 $08 $07 $06 $06 $06

seasonsTable_06_6dcc:
	.db $02 $02 $02 $02 $04 $06 $08 $0a
	.db $0d $0a $08 $06 $04 $02 $02 $02
	.db $02 $02 $02 $02 $04 $06 $08 $0a
	.db $0d $0a $08 $06 $04 $02 $02 $02
