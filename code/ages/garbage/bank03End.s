.ifdef BUILD_VANILLA

; Garbage functions appear to follow (corrupted repeats of the above functions).

;;
func_7e54:
	ld a,$10
	ld (wLinkStateParameter),a
	ld hl,w1Link.direction
	ld a,$02
	ldi (hl),a
	ld (hl),$10
	ld a,$07
	ld (wTmpcbb5),a
	xor a
	ld ($cfde),a
	call $3b46
	ld (hl),$92
	ld l,$43
	ld (hl),$01
	call $3b46
	ld (hl),$2c
	ld l,$4b
	ld a,(w1Link.yh)
	add $10
	ldi (hl),a
	ld a,(w1Link.xh)
	inc l
	ld (hl),a
	jp $7d02

;;
func_7e88:
	call $7ea9
	ld a,(wTmpcbb5)
	cp $08
	ret nz
	ld a,$f0
	call $0cb1
	xor a
	ld (wActiveMusic),a
	inc a
	ld (wCutsceneIndex),a
	ld hl,$7ea4
	jp $19c5

;;
func_7ea4:
	add l
	rst_addAToHl
	dec b
	ld (hl),a
	inc bc
	ld a,(wScreenShakeCounterY)
	and $0f
	ld a,$b3
	call z,$0cb1
	ld a,(wScreenShakeCounterY)
	or a
	ld a,$ff
	jp z,$24f8
	ret

.endif