; Helper functions etc.

; return z iff the current group and room match c and b.
compareRoom:
	ld a,(wActiveGroup)
	cp c
	ret nz
	ld a,(wActiveRoom)
	cp b
	ret

; returns the byte at e:hl into e.
readByte:
	ld a,($ff00+<hRomBank)
	push af
	ld a,e
	ld ($ff00+<hRomBank),a
	ld ($2222),a
	ld e,(hl)
	pop af
	ld ($ff00+<hRomBank),a
	ld ($2222),a
	ret

; Searches for a value in a table starting at hl, with an entry matching keys 'b' and subkey 'c',
; and values 'e' bytes long. Sets cflag if found. A key of ff ends the table.
searchDoubleKey:
@loop:
	ldi a,(hl)
	cp a,$ff
	ret z
	cp b
	jr nz,@next
	ldi a,(hl)
	cp c
	jr nz,@done
	scf
	ret
@next:
	inc hl
@done:
	ld a,e
	rst_addAToHl
	jr @loop

; Increment hl until (hl) equals either register a or $ff. Returns z if a match was found.
searchValue:
	push bc
	ld b,a
@loop:
	ldi a,(hl)
	cp b
	jr z,@match
	inc a
	jr z,@noMatch
	jr @loop

@noMatch:
	inc a
@match:
	ld a,b
	pop bc
	ret


;;
; Certain randomized slots (ie. maku tree screen) borrow unused treasure flags for remembering if
; they have been obtained.
;
; @param	a	Flag to check
; @param[out]	z,cflag	Set if the flag is set
checkRandoFlag:
	push hl
	ld hl,wObtainedTreasureFlags
	call checkFlag
	pop hl
	ret z
	scf
	ret

;;
; @param	a	Flag to set
setRandoFlag:
	ld hl,wObtainedTreasureFlags
	jp setFlag
