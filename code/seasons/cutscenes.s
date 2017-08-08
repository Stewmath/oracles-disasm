;;
seasonsFunc_5bd2:
	ld e,$00
	jp seasonsFunc_35b8

;;
seasonsFunc_5bd7:
	ld e,$01
	call seasonsFunc_35b8
	call updateInteractionsAndDrawAllSprites
	jp loadScreenMusic

;;
seasonsFunc_5be2:
	ld e,$02
	call seasonsFunc_35b8
	jp updateInteractionsAndDrawAllSprites

cutscene06:
	call $1601		; $5bea
	ld e,$00		; $5bed
	call $2db1		; $5bef
	ld a,($cc67)		; $5bf2
	or a			; $5bf5
	ret z			; $5bf6
	jp $5c85		; $5bf7

	call $1601		; $5bfa
	ld e,$02		; $5bfd
	jp $2db1		; $5bff
	ld e,$01		; $5c02
	jp $2db1		; $5c04
	ld hl,$6b89		; $5c07
	ld e,$03		; $5c0a
	call $008a		; $5c0c
	jr _func_5d31		; $5c0f
	ld hl,$66ff		; $5c11
	ld e,$03		; $5c14
	call $008a		; $5c16
	jr _func_5d31		; $5c19
	call $1601		; $5c1b
	ld e,$03		; $5c1e
	jp $35b8		; $5c20
	ld a,($cc67)		; $5c23
	or a			; $5c26
	jr nz,func_5e0e		; $5c27
	ld e,$04		; $5c29
	call $35b8		; $5c2b
	jp $3276		; $5c2e
	call $3346		; $5c31
	jp $5bc5		; $5c34
	call $335a		; $5c37
	jp $5bb5		; $5c3a
	call $336e		; $5c3d
	jp $5bc5		; $5c40
	call $1a17		; $5c43
	ret nz			; $5c46
	ld hl,$cc67		; $5c47
	ld a,(hl)		; $5c4a
	ld (hl),$00		; $5c4b
	inc a			; $5c4d
	ld a,$03		; $5c4e
	jr nz,label_01_135	; $5c50
	call $3382		; $5c52
	ld a,$01		; $5c55
label_01_135:
	ld ($c2ef),a		; $5c57
	xor a			; $5c5a
	ld ($cc02),a		; $5c5b
	ld ($cca6),a		; $5c5e
	ld ($ccab),a		; $5c61
	ret			; $5c64

cutscene07:
cutscene08:
cutscene0c:
cutscene09:
cutscene0f:
cutscene0a:
cutscene20:
cutscene0d:
cutscene0e:
cutscene21:
cutscene10:
cutscene11:
cutscene12:
cutscene16:
