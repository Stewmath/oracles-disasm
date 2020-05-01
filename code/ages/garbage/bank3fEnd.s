.ifdef BUILD_VANILLA

; Garbage functions appear to follow (corrupted repeats of the above functions).

;;
; @addr{7ca7}
func_7ca7:
	jr -$30			; $7ca7
	call $2118		; $7ca9
	jp $2422		; $7cac

;;
; @addr{7caf}
func_7caf:
	ld c,$20		; $7caf
	call $1f83		; $7cb1
	ret nz			; $7cb4

	ld a,$77		; $7cb5
	call $0cb1		; $7cb7
	ld e,$46		; $7cba
	ld a,$5a		; $7cbc
	ld (de),a		; $7cbe
	ld a,$5b		; $7cbf
	call $0cb1		; $7cc1
	jp $2422		; $7cc4

;;
; @addr{7cc7}
func_7cc7:
	call $2409		; $7cc7
	ret nz			; $7cca
	call $33a2		; $7ccb
	jp $2422		; $7cce

;;
; @addr{7cd1}
func_7cd1:
	ld a,(wPaletteThread_mode)		; $7cd1
	or a			; $7cd4
	ret nz			; $7cd5
	ld a,$29		; $7cd6
	call $324b		; $7cd8
	ld a,$4c		; $7cdb
	call $1761		; $7cdd
	call $7cf8		; $7ce0
	xor a			; $7ce3
	ld (wDisabledObjects),a		; $7ce4
	ld (wMenuDisabled),a		; $7ce7
	ld hl,$cfc0		; $7cea
	set 0,(hl)		; $7ced
	ld a,(wActiveMusic)		; $7cef
	call $0cb1		; $7cf2
	jp $7bf2		; $7cf5

;;
; @addr{7cf8}
func_7cf8:
	ld hl,$c702		; $7cf8
	call $7d00		; $7cfb
	ld l,$12		; $7cfe
	set 0,(hl)		; $7d00
	inc l			; $7d02
	set 0,(hl)		; $7d03
	inc l			; $7d05
	set 0,(hl)		; $7d06
	inc l			; $7d08
	ret			; $7d09

.endif