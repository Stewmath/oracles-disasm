;;
; Sets up the LCD interrupt behaviour to do the underwater waves, and initializes the SCX
; values needed.
;
checkInitUnderwaterWaves:
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	ret z

	ld a,$10
	ld (wGfxRegs2.LYC),a
	ld a,$02
	ldh (<hNextLcdInterruptBehaviour),a
	ld a,$02
	call initWaveScrollValues

;;
; Updates wBigBuffer with the values for SCX for next frame.
;
checkUpdateUnderwaterWaves:
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	ret z

	ld a,:w2WaveScrollValues
	ld ($ff00+R_SVBK),a

	ld a,(wGfxRegs2.SCX)
	ld c,a
	ld a,(wFrameCounter)
	ld b,a
	ld a,(wGfxRegs2.SCY)
	add b
	and $7f
	ld de,w2WaveScrollValues
	call addAToDe
	ld hl,wBigBuffer+$10
	ld b,$80
--
	ld a,(de)
	add c
	ldi (hl),a
	ld a,e
	inc a
	and $7f
	ld e,a
	dec b
	jr nz,--

	xor a
	ld ($ff00+R_SVBK),a
	ret

;;
; Cancels the underwater wave effect momentarily during screen transitions.
;
checkDisableUnderwaterWaves:
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	ret z

	ld a,$03
	ldh (<hNextLcdInterruptBehaviour),a

	; This should be high enough so the LYC interrupt doesn't trigger
	ld a,199
	ld (wGfxRegs2.LYC),a

	ret
