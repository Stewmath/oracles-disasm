; Namespace "bank2".


;;
; Called from the file select menu. Use select + direction on file menu to toggle options. Wrapper
; function unlocks and locks sram.
checkChangeRandoVars:
	push bc
	ld a,$0a
	ld ($1111),a
	call @body
	ldh a,(<hRandoVars)
	ld (sramRandoVars),a
	xor a
	ld ($1111),a
	pop bc
	ret

@body:
	ld a,(wKeysPressed)
	and BTN_SELECT
	ldh a,(<hRandoVars)
	ld b,a
	ret z

	ld a,(wKeysJustPressed)
	ld c,a

	; select + right = toggle music
	ld a,c
	and BTN_RIGHT
	jr z,@notRightDpad
	ld a,b
	xor $04
	ldh (<hRandoVars),a
	bit 2,a
	ld b,$03
	jr z,+
	ld b,$00
+
	ld a,b
	call setMusicVolume
	ret

@notRightDpad:
	; select + left = toggle gbc palette override
	ld a,c
	and BTN_LEFT
	ret z
	ld a,b
	xor $08
	ldh (<hRandoVars),a

	ld a,$ff
	ldh (<hDirtyBgPalettes),a
	ldh (<hDirtySprPalettes),a
	ret


;;
; Queues a DMA transfer for the custom string to be displayed at the top of the file select screen.
drawRandoFileSelectString:
      ; first load custom font
      ld b,$19 ; 26*16 bytes
      ld c,:randoCustomFontLetters
      ld de,$8e21
      ld hl,randoCustomFontLetters
      call queueDmaTransfer

      ld b,3 ; 4*16 bytes
      ld c,:randoCustomFontPunct
      ld de,$8fc1
      ld hl,randoCustomFontPunct
      call queueDmaTransfer

      ld b,3 ; 64 bytes
      ld c,:randoFileSelectStringAttrs
      ld de,$9c21
      ld hl,randoFileSelectStringAttrs
      call queueDmaTransfer

      ld b,3 ; 64 bytes
      ld c,:randoFileSelectStringTiles
      ld de,$9c20
      ld hl,randoFileSelectStringTiles
      jp queueDmaTransfer
