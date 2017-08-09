;;
; Sets up the LCD interrupt behaviour to do the underwater waves, and initializes the SCX
; values needed.
;
; @addr{626e}
checkInitUnderwaterWaves:
	ld a,(wAreaFlags)		; $626e
	and AREAFLAG_UNDERWATER		; $6271
	ret z			; $6273

	ld a,$10		; $6274
	ld (wGfxRegs2.LYC),a		; $6276
	ld a,$02		; $6279
	ldh (<hNextLcdInterruptBehaviour),a	; $627b
	ld a,$02		; $627d
	call initWaveScrollValues		; $627f

;;
; Updates wBigBuffer with the values for SCX for next frame.
;
; @addr{6282}
checkUpdateUnderwaterWaves:
	ld a,(wAreaFlags)		; $6282
	and AREAFLAG_UNDERWATER			; $6285
	ret z			; $6287

	ld a,:w2WaveScrollValues		; $6288
	ld ($ff00+R_SVBK),a	; $628a

	ld a,(wGfxRegs2.SCX)		; $628c
	ld c,a			; $628f
	ld a,(wFrameCounter)		; $6290
	ld b,a			; $6293
	ld a,(wGfxRegs2.SCY)		; $6294
	add b			; $6297
	and $7f			; $6298
	ld de,w2WaveScrollValues	; $629a
	call addAToDe		; $629d
	ld hl,wBigBuffer+$10	; $62a0
	ld b,$80		; $62a3
--
	ld a,(de)		; $62a5
	add c			; $62a6
	ldi (hl),a		; $62a7
	ld a,e			; $62a8
	inc a			; $62a9
	and $7f			; $62aa
	ld e,a			; $62ac
	dec b			; $62ad
	jr nz,--		; $62ae

	xor a			; $62b0
	ld ($ff00+R_SVBK),a	; $62b1
	ret			; $62b3

;;
; Cancels the underwater wave effect momentarily during screen transitions.
;
; @addr{62b4}
checkDisableUnderwaterWaves:
	ld a,(wAreaFlags)		; $62b4
	and AREAFLAG_UNDERWATER			; $62b7
	ret z			; $62b9

	ld a,$03		; $62ba
	ldh (<hNextLcdInterruptBehaviour),a	; $62bc

	; This should be high enough so the LYC interrupt doesn't trigger
	ld a,199		; $62be
	ld (wGfxRegs2.LYC),a		; $62c0

	ret			; $62c3
