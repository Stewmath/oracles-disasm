.ifdef BUILD_VANILLA

; Garbage function follows (partial repeat of the last function)

;;
; @addr{7f64}
func_11_7f64:
	call $20ef		; $7f64
	ld h,$cf		; $7f67
	ld (hl),$00		; $7f69
	ld a,$98		; $7f6b
	call $0510		; $7f6d
	jp $1eaf		; $7f70

.endif