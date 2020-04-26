tileTypesTable:
	cp c			; $7bad
	ld a,e			; $7bae
.DB $ec				; $7baf
	ld a,e			; $7bb0
	add hl,hl		; $7bb1
	ld a,h			; $7bb2
	ldd (hl),a		; $7bb3
	ld a,h			; $7bb4
	ldd (hl),a		; $7bb5
	ld a,h			; $7bb6
	ld (hl),e		; $7bb7
	ld a,h			; $7bb8
	jr nz,_label_05_432	; $7bb9
	di			; $7bbb
	ld bc,$01f4		; $7bbc
.DB $dd				; $7bbf
	inc b			; $7bc0
	sbc $04			; $7bc1
_label_05_432:
	rst_addDoubleIndex			; $7bc3
	inc b			; $7bc4
	ld hl,sp+$05		; $7bc5
	ld sp,hl		; $7bc7
	dec b			; $7bc8
	ret nc			; $7bc9
	ld b,$db		; $7bca
	ld c,$dc		; $7bcc
	rrca			; $7bce
.DB $fd				; $7bcf
	rlca			; $7bd0
	ld a,($fb11)		; $7bd1
	ld de,setRoomFlagsForUnlockedKeyDoor_overworldOnly		; $7bd4
	pop de			; $7bd7
	ld (de),a		; $7bd8
	call nc,$d213		; $7bd9
	inc d			; $7bdc
.DB $d3				; $7bdd
	dec d			; $7bde
	ret			; $7bdf
	inc bc			; $7be0
	ld a,e			; $7be1
	stop			; $7be2
	ld a,h			; $7be3
	stop			; $7be4
	ld a,l			; $7be5
	stop			; $7be6
	ld a,(hl)		; $7be7
	stop			; $7be8
	ld a,a			; $7be9
	stop			; $7bea
	nop			; $7beb
	di			; $7bec
	ld bc,$01f4		; $7bed
	ld hl,sp+$05		; $7bf0
	ld sp,hl		; $7bf2
	dec b			; $7bf3
	ret nc			; $7bf4
	ld b,$d1		; $7bf5
	ld b,$fa		; $7bf7
	ld de,$11fb		; $7bf9
.DB $fc				; $7bfc
	ld de,$107b		; $7bfd
	ld a,h			; $7c00
	stop			; $7c01
	ld a,l			; $7c02
	stop			; $7c03
	ld a,(hl)		; $7c04
	stop			; $7c05
	ld a,a			; $7c06
	stop			; $7c07
	ret nz			; $7c08
	stop			; $7c09
	pop bc			; $7c0a
	stop			; $7c0b
	jp nz,$c310		; $7c0c
	stop			; $7c0f
	call nz,$c510		; $7c10
	stop			; $7c13
	add $10			; $7c14
	rst_jumpTable			; $7c16
	stop			; $7c17
	ret z			; $7c18
	stop			; $7c19
	ret			; $7c1a
	stop			; $7c1b
	jp z,$cb10		; $7c1c
	stop			; $7c1f
	call z,$cd10		; $7c20
	stop			; $7c23
	adc $10			; $7c24
	rst $8			; $7c26
	stop			; $7c27
	nop			; $7c28
	ret nc			; $7c29
	inc b			; $7c2a
.DB $dd				; $7c2b
	inc b			; $7c2c
	sbc $04			; $7c2d
	rst_addDoubleIndex			; $7c2f
	inc b			; $7c30
	nop			; $7c31
	di			; $7c32
	ld bc,$01f4		; $7c33
	push af			; $7c36
	ld bc,$01f6		; $7c37
	rst $30			; $7c3a
	ld bc,$07fd		; $7c3b
	ld a,($fb11)		; $7c3e
	ld de,setRoomFlagsForUnlockedKeyDoor_overworldOnly		; $7c41
	ret nc			; $7c44
_label_05_433:
	ld bc,$1061		; $7c45
	ld h,d			; $7c48
	stop			; $7c49
	ld h,e			; $7c4a
	stop			; $7c4b
	ld h,h			; $7c4c
	stop			; $7c4d
	ld h,l			; $7c4e
	stop			; $7c4f
	ld d,b			; $7c50
	ld b,$51		; $7c51
	ld b,$52		; $7c53
	ld b,$53		; $7c55
	ld b,$48		; $7c57
	ld (bc),a		; $7c59
	ld c,c			; $7c5a
	ld (bc),a		; $7c5b
	ld c,d			; $7c5c
	ld (bc),a		; $7c5d
	ld c,e			; $7c5e
	ld (bc),a		; $7c5f
	ld c,l			; $7c60
	inc bc			; $7c61
	ld d,h			; $7c62
	add hl,bc		; $7c63
	ld d,l			; $7c64
	ld a,(bc)		; $7c65
	ld d,(hl)		; $7c66
	dec bc			; $7c67
	ld d,a			; $7c68
	inc c			; $7c69
	ld h,b			; $7c6a
	dec c			; $7c6b
	adc h			; $7c6c
	rrca			; $7c6d
	adc l			; $7c6e
	rrca			; $7c6f
	ccf			; $7c70
	ld bc,$1600		; $7c71
	stop			; $7c74
	jr $10			; $7c75
	rla			; $7c77
	sub b			; $7c78
	add hl,de		; $7c79
	sub b			; $7c7a
.DB $f4				; $7c7b
	ld bc,$010f		; $7c7c
	inc c			; $7c7f
	ld bc,$301a		; $7c80
	dec de			; $7c83
_label_05_434:
	jr nz,$1c	; $7c84
	jr nz,$1d	; $7c86
	jr nz,$1e	; $7c88
	jr nz,$1f	; $7c8a
	jr nz,$20	; $7c8c
	ld b,b			; $7c8e
	ldi (hl),a		; $7c8f
	ld b,b			; $7c90
	inc c			; $7c91
	inc b			; $7c92
	dec c			; $7c93
	inc b			; $7c94
	ld c,$04		; $7c95
	ld (bc),a		; $7c97
	nop			; $7c98
	nop			; $7c99