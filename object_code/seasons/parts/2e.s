; ==================================================================================================
; PART_2e
; ==================================================================================================
partCode2e:
	ld e,$c4
	ld a,(de)
	or a
	jr z,++
	ld e,$e1
	ld a,(de)
	or a
	jr z,+
	bit 7,a
	jp nz,partDelete
	call func_6853
+
	jp partAnimate
++
	ld a,$01
	ld (de),a
	call objectGetTileAtPosition
	cp $f3
	jp z,partDelete
	ld h,$ce
	ld a,(hl)
	or a
	jp nz,partDelete
	ld a,SND_POOF
	call playSound
	jp objectSetVisible83
	
func_6853:
	push af
	xor a
	ld (de),a
	call objectGetTileAtPosition
	pop af
	ld e,$f0
	dec a
	jr z,+
	ld a,(de)
	ld (hl),a
	ret
+
	ld a,(hl)
	ld (de),a
	ld (hl),$f3
	ret
