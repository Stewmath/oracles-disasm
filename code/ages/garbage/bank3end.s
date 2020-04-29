; Garbage functions appear to follow (corrupted repeats of the above functions).

;;
; @addr{7e54}
func_7e54:
	ld a,$10		; $7e54
	ld (wLinkStateParameter),a		; $7e56
	ld hl,w1Link.direction		; $7e59
	ld a,$02		; $7e5c
	ldi (hl),a		; $7e5e
	ld (hl),$10		; $7e5f
	ld a,$07		; $7e61
	ld (wTmpcbb5),a		; $7e63
	xor a			; $7e66
	ld ($cfde),a		; $7e67
	call $3b46		; $7e6a
	ld (hl),$92		; $7e6d
	ld l,$43		; $7e6f
	ld (hl),$01		; $7e71
	call $3b46		; $7e73
	ld (hl),$2c		; $7e76
	ld l,$4b		; $7e78
	ld a,(w1Link.yh)		; $7e7a
	add $10			; $7e7d
	ldi (hl),a		; $7e7f
	ld a,(w1Link.xh)		; $7e80
	inc l			; $7e83
	ld (hl),a		; $7e84
	jp $7d02		; $7e85

;;
; @addr{7e88}
func_7e88:
	call $7ea9		; $7e88
	ld a,(wTmpcbb5)		; $7e8b
	cp $08			; $7e8e
	ret nz			; $7e90
	ld a,$f0		; $7e91
	call $0cb1		; $7e93
	xor a			; $7e96
	ld (wActiveMusic),a		; $7e97
	inc a			; $7e9a
	ld (wCutsceneIndex),a		; $7e9b
	ld hl,$7ea4		; $7e9e
	jp $19c5		; $7ea1

;;
; @addr{7ea4}
func_7ea4:
	add l			; $7ea4
	rst_addAToHl			; $7ea5
	dec b			; $7ea6
	ld (hl),a		; $7ea7
	inc bc			; $7ea8
	ld a,(wScreenShakeCounterY)		; $7ea9
	and $0f			; $7eac
	ld a,$b3		; $7eae
	call z,$0cb1		; $7eb0
	ld a,(wScreenShakeCounterY)		; $7eb3
	or a			; $7eb6
	ld a,$ff		; $7eb7
	jp z,$24f8		; $7eb9
	ret			; $7ebc
