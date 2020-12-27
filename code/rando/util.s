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
checkRandoFlag:
	ld hl,wObtainedTreasureFlags
	jp checkFlag

;;
; @param	a	Flag to set
setRandoFlag:
	ld hl,wObtainedTreasureFlags
	jp setFlag


.ifdef ROM_SEASONS

; Call a function hl in bank $02, preserving af. 'e' can't be used as a parameter to that function,
; but it can be returned. This function only exists because banks $08 and $09 are so tight on space.
callBank2:
	push af
	ld e,$02
	call interBankCall
	pop af
	ret

.endif
