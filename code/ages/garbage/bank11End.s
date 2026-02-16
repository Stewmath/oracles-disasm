.ifdef INCLUDE_GARBAGE

.ifdef REGION_US
; Garbage function follows (partial repeat of the last function)

;;
func_11_7f64:
	call $20ef
	ld h,$cf
	ld (hl),$00
	ld a,$98
	call $0510
	jp $1eaf
.endif ; REGION_US

.endif