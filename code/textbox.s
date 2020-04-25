;;
; Called once as a textbox is about to be shown.
; @addr{4af7}
initTextbox:
	ld a,(wTextboxFlags)		; $4af7
	bit TEXTBOXFLAG_BIT_DONTCHECKPOSITION,a			; $4afa
	jr nz,++		; $4afc

	; Decide whether to put the textbox at the top or bottom
	ldh a,(<hCameraY)	; $4afe
	ld b,a			; $4b00
	ld a,(w1Link.yh)		; $4b01
	sub b			; $4b04
	cp $48			; $4b05
	ld a,$02		; $4b07
	jr c,+			; $4b09
	xor a			; $4b0b
+
	ld (wTextboxPosition),a		; $4b0c
++
	ld a,$07		; $4b0f
	ld ($ff00+R_SVBK),a	; $4b11
	ld hl,$d000		; $4b13
	ld bc,$0460		; $4b16
	call clearMemoryBc		; $4b19
	jp _initTextboxStuff		; $4b1c

;;
; Called every frame while a textbox is being shown.
; @addr{4b1f}
updateTextbox:
	ld a,$07		; $4b1f
	ld ($ff00+R_SVBK),a	; $4b21
	ld d,$d0		; $4b23
	ld a,(wTextIsActive)		; $4b25
	inc a			; $4b28
	jr nz,+			; $4b29

	; If [wTextIsActive] == 0xff...
	ld (wTextDisplayMode),a		; $4b2b
	ld h,d			; $4b2e
	ld l,<w7TextDisplayState	; $4b2f
	ld (hl),$0f		; $4b31
	inc l			; $4b33
	set 3,(hl)		; $4b34
+
	call @updateText	; $4b36

	; Stop everything if [wTextIsActive] == 0
	ld a,(wTextIsActive)		; $4b39
	or a			; $4b3c
	ret nz			; $4b3d

	ld (wTextboxFlags),a		; $4b3e
	jp stubThreadStart		; $4b41

;;
; @addr{4b44}
@updateText:
	ld a,(wTextIsActive)		; $4b44
	cp $80			; $4b47
	ret z			; $4b49

	ld e,<w7TextDisplayState	; $4b4a
	ld a,(wTextDisplayMode)		; $4b4c
	rst_jumpTable			; $4b4f
.dw @standardText
.dw @textOption
.dw @inventoryText

;;
; @addr{4b56}
@standardText:
	ld a,(de)		; $4b56
	rst_jumpTable			; $4b57
.dw @standardTextState0
.dw @standardTextState1
.dw @standardTextState2
.dw @standardTextState3
.dw @standardTextState4
.dw @standardTextState5
.dw @standardTextState6
.dw @standardTextState7
.dw @standardTextState8
.dw @standardTextState9
.dw @standardTextStatea
.dw @standardTextStateb
.dw @standardTextStatec
.dw @standardTextStated
.dw @standardTextStatee
.dw @standardTextStatef
.dw @standardTextState10

;;
; An option has come up (ie yes/no)
; @addr{4b7a}
@textOption:
	ld a,(de)		; $4b7a
	rst_jumpTable			; $4b7b
.dw textOptionCode@state00
.dw textOptionCode@state01
.dw textOptionCode@state02
.dw textOptionCode@state03
.dw textOptionCode@state04

;;
; @addr{4b86}
@inventoryText:
	ld a,(de)		; $4b86
	rst_jumpTable			; $4b87
.dw inventoryTextCode@state00
.dw inventoryTextCode@state01
.dw inventoryTextCode@state02
.dw inventoryTextCode@state03
.dw inventoryTextCode@state04
.dw inventoryTextCode@state05
.dw inventoryTextCode@state06
.dw inventoryTextCode@state07

;;
; Initializing
; @addr{4b98}
@standardTextState0:
	ld a,$01		; $4b98
	ld (de),a		; $4b9a
	call _saveTilesUnderTextbox		; $4b9b
	call _initTextboxMapping		; $4b9e
	jp _dmaTextboxMap		; $4ba1

;;
; Prepare to draw the top line.
; @addr{4ba4}
@standardTextState1:
	ld h,d			; $4ba4
	ld l,<w7TextDisplayState	; $4ba5
	inc (hl)		; $4ba7
	ld l,<w7d0d3		; $4ba8
	ld (hl),$40		; $4baa
	ld l,<w7CharacterDisplayLength		; $4bac
	ldi a,(hl)		; $4bae
	ld (hl),a		; $4baf
	call _drawLineOfText		; $4bb0
	jp _dmaTextGfxBuffer		; $4bb3

;;
; Displaying a row of characters
; State 2: top row
; State 4: bottom row
; State A: bottom row, next row will come up automatically
; @addr{4bb6}
@standardTextState2:
@standardTextState4:
@standardTextStatea:
	call _getNextCharacterToDisplay		; $4bb6
	jr z,+			; $4bb9

	call _updateCharacterDisplayTimer		; $4bbb
	ret nz			; $4bbe

	call _displayNextTextCharacter		; $4bbf
	call _dmaTextboxMap		; $4bc2
	ld d,$d0		; $4bc5
	call _getNextCharacterToDisplay		; $4bc7
	ret nz			; $4bca
+
	call _func_53eb		; $4bcb
	ret nz			; $4bce

	ld d,$d0		; $4bcf
	call _func_5296		; $4bd1
	ret nz			; $4bd4

	ld h,d			; $4bd5
	ld l,<w7TextStatus		; $4bd6
	ld a,(hl)		; $4bd8
	or a			; $4bd9
	ld l,<w7TextDisplayState	; $4bda
	jr z,@textFinished	; $4bdc

	inc (hl)		; $4bde
	ld l,<w7CharacterDisplayLength		; $4bdf
	ldi a,(hl)		; $4be1
	ld (hl),a		; $4be2
	ret			; $4be3

@textFinished:
	ld (hl),$0f		; $4be4
	ret			; $4be6

;;
; Preparing to draw the bottom line
; @addr{4be7}
@standardTextState3:
@standardTextState9:
	call _updateCharacterDisplayTimer		; $4be7
	ret nz			; $4bea

	call _drawLineOfText		; $4beb
	ld a,$02		; $4bee
	call _dmaTextGfxBuffer		; $4bf0
	ld hl,w7TextDisplayState		; $4bf3
	inc (hl)		; $4bf6
	ld l,<w7d0d3		; $4bf7
	ld (hl),$60		; $4bf9
	ld l,<w7CharacterDisplayLength		; $4bfb
	ldi a,(hl)		; $4bfd
	ld (hl),a		; $4bfe
	ret			; $4bff

;;
; Waiting for input to display the next 2 rows of characters
; @addr{4c00}
@standardTextState5:
	ld a,(wKeysJustPressed)		; $4c00
	and BTN_A | BTN_B		; $4c03
	jp z,_updateTextboxArrow		; $4c05

	ld a,SND_TEXT_2		; $4c08
	call playSound		; $4c0a
	ld h,d			; $4c0d
	ld l,<w7d0c1		; $4c0e
	res 0,(hl)		; $4c10
	jr @standardTextStateb	; $4c12

;;
; Doesn't really do anything
; @addr{4c14}
@standardTextState6:
@standardTextStatec:
	; Go to state $07/0d
	ld h,d			; $4c14
	ld l,e			; $4c15
	inc (hl)		; $4c16

	jp _dmaTextboxMap		; $4c17

;;
; Shifts the text up one tile.
; @addr{4c1a}
@standardTextState7:
@standardTextStated:
	; Go to state $08/0e
	ld h,d			; $4c1a
	ld l,e			; $4c1b
	inc (hl)		; $4c1c

	call _shiftTextboxMapUp		; $4c1d
	jp _subFirstRowOfTextMapBy20		; $4c20

;;
; The first of the next 2 lines of text is about to come up.
; @addr{4c23}
@standardTextState8:
	; Go to state $09
	ld h,d			; $4c23
	ld l,e			; $4c24
	inc (hl)		; $4c25

	ld l,<w7CharacterDisplayLength		; $4c26
	ldi a,(hl)		; $4c28
	ld (hl),a		; $4c29

	; Redraw the previous line of text to the top line.

	call _dmaTextboxMap		; $4c2a
	xor a			; $4c2d
	jp _dmaTextGfxBuffer		; $4c2e

;;
; A new line has just been drawn after scrolling text up. Another line of text
; still needs to scroll up.
; @addr{4c31}
@standardTextStateb:
	; Go to state $0c
	ld h,d			; $4c31
	ld l,e			; $4c32
	inc (hl)		; $4c33

	; Get the position of the red arrow, remove it
	ld l,<w7d0cc		; $4c34
	ld a,(hl)		; $4c36
	add $12			; $4c37
	and $1f			; $4c39
	add <w7TextboxMap+$80			; $4c3b
	ld l,a			; $4c3d
	ld h,>w7TextboxMap		; $4c3e
	ld (hl),$02		; $4c40

	call _shiftTextboxMapUp		; $4c42
	jp _clearTopRowOfTextMap		; $4c45

;;
; The second new line is ready to be shown.
; @addr{4c48}
@standardTextStatee:
	; Go to state $03
	ld h,d			; $4c48
	ld l,e			; $4c49
	ld (hl),$03		; $4c4a

	ld l,<w7CharacterDisplayLength		; $4c4c
	ldi a,(hl)		; $4c4e
	ld (hl),a		; $4c4f

	call _dmaTextboxMap		; $4c50
	xor a			; $4c53
	jp _dmaTextGfxBuffer		; $4c54

;;
; @addr{4c57}
@standardTextStatef:
	ld h,d			; $4c57
	ld l,<w7d0ef		; $4c58
	bit 7,(hl)		; $4c5a
	jr z,@label_3f_096	; $4c5c

	ld a,(wKeysJustPressed)		; $4c5e
	and BTN_A | BTN_B	; $4c61
	ret z			; $4c63

	ld (hl),$00		; $4c64
	ld l,e			; $4c66
	ld (hl),$00		; $4c67

	; You got 4 pieces of heart. That's 1 heart container
.ifdef ROM_AGES
	ld a,<TX_0049		; $4c69
	ld (wTextIndexL),a		; $4c6b
	ld a,>TX_0049		; $4c6e
.else
	ld a,<TX_0024		; $4c69
	ld (wTextIndexL),a		; $4c6b
	ld a,>TX_0024		; $4c6e
.endif

	add $04			; $4c70
	ld (wTextIndexH),a		; $4c72
	call _checkInitialTextCommands		; $4c75
	ld a,SND_CRANEGAME	; $4c78
	call playSound		; $4c7a
	ld a,TREASURE_HEART_CONTAINER		; $4c7d
	ld c,$04		; $4c7f
	jp giveTreasure		; $4c81

@label_3f_096:
	ld l,<w7d0c1		; $4c84
	bit 3,(hl)		; $4c86
	jr nz,+			; $4c88

	call @checkShouldExit	; $4c8a
	ret z			; $4c8d
+
	ld l,e			; $4c8e
	inc (hl)		; $4c8f
	ld l,<w7d0ef		; $4c90
	bit 0,(hl)		; $4c92
	jr z,+			; $4c94

	ld a,TREASURE_HEART_REFILL		; $4c96
	ld c,$40		; $4c98
	call giveTreasure		; $4c9a
+
	jp _saveTilesUnderTextbox		; $4c9d

;;
; Unsets zero flag if the textbox should be exited from (usually, player has
; pressed a button to exit the textbox).
; @addr{4ca0}
@checkShouldExit:
	ld a,(wTextboxFlags)		; $4ca0
	bit TEXTBOXFLAG_BIT_NONEXITABLE,a			; $4ca3
	jr nz,@@nonExitable	; $4ca5

	ld l,<w7TextboxTimer		; $4ca7
	ld a,(hl)		; $4ca9
	or a			; $4caa
	jr z,+			; $4cab

	dec (hl)		; $4cad
	jr z,@@end		; $4cae
+
	ld a,(wKeysJustPressed)		; $4cb0
	or a			; $4cb3
	ret			; $4cb4

@@nonExitable:
	res TEXTBOXFLAG_BIT_NONEXITABLE,a			; $4cb5
	ld (wTextboxFlags),a		; $4cb7
	ld a,$80		; $4cba
	ld (wTextIsActive),a		; $4cbc
@@end:
	or d			; $4cbf
	ret			; $4cc0

;;
; Closes the textbox
; @addr{4cc1}
@standardTextState10:
	xor a			; $4cc1
	ld (wTextIsActive),a		; $4cc2
	jp _dmaTextboxMap		; $4cc5


textOptionCode:

; This code is for when you have a prompt, ie "yes/no".

;;
; Initialization
; @addr{4cc8}
@state00:
	; hl = w7TextDisplayState (go to state $01)
	ld h,d			; $4cc8
	ld l,e			; $4cc9
	inc (hl)		; $4cca

	; Set the delay until the cursor appears
	ld a,(wTextSpeed)		; $4ccb
	ld hl,@cursorDelay		; $4cce
	rst_addAToHl			; $4cd1
	ld a,(hl)		; $4cd2
	ld e,<w7CharacterDisplayTimer		; $4cd3
	ld (de),a		; $4cd5
	ret			; $4cd6

; These are values determining how many frames until the cursor appears.
; Which value is used depends on wTextSpeed.
@cursorDelay:
	.db $20 $1c $18 $14 $10

;;
; @addr{4cdc}
@state01:
	ld h,d			; $4cdc
	ld l,<w7CharacterDisplayTimer		; $4cdd
	dec (hl)		; $4cdf
	ret nz			; $4ce0

	; hl = w7TextDisplayState (go to state $02)
	ld l,e			; $4ce1
	inc (hl)		; $4ce2

	jp _updateSelectedTextPositionAndDmaTextboxMap		; $4ce3

;;
; @addr{4ce6}
@state02:
	ld a,(wKeysJustPressed)		; $4ce6
	and BTN_A | BTN_B			; $4ce9
	jp z,_textOptionCode_checkDirectionButtons		; $4ceb

	call _textOptionCode_checkBButton		; $4cee
	ret nz			; $4cf1

	; A button pressed

	ld a,SND_SELECTITEM	; $4cf2
	call playSound		; $4cf4

	; Go to state 3
	ld hl,w7TextDisplayState		; $4cf7
	inc (hl)		; $4cfa

	ld l,<w7SelectedTextOption		; $4cfb
	ld a,(hl)		; $4cfd
	ld (wSelectedTextOption),a		; $4cfe

	ld a,(wTextboxFlags)		; $4d01
	bit TEXTBOXFLAG_BIT_NONEXITABLE,a			; $4d04
	ret z			; $4d06

	res TEXTBOXFLAG_BIT_NONEXITABLE,a			; $4d07
	ld (wTextboxFlags),a		; $4d09
	ld a,$80		; $4d0c
	ld (wTextIsActive),a		; $4d0e
	ret			; $4d11

;;
; @addr{4d12}
@state03:
	; hl = w7TextDisplayState (go to state $04)
	ld h,d			; $4d12
	ld l,e			; $4d13
	inc (hl)		; $4d14

	; hl = w7d0c1
	inc l			; $4d15
	bit 4,(hl)		; $4d16
	jr z,+			; $4d18

	; If the textbox ended with command 8 / control code 8, do this special
	; behaviour

	push hl			; $4d1a
	call _readNextTextByte		; $4d1b
	pop hl			; $4d1e
	cp $ff			; $4d1f
	jp z,+			; $4d21

	ld (wTextIndexL),a		; $4d24
	call _checkInitialTextCommands		; $4d27
	jp _func_53dd		; $4d2a

+
	set 3,(hl)		; $4d2d

	; hl = w7TextStatus
	inc l			; $4d2f
	ld (hl),$00		; $4d30

	; Go to standard text mode, state $0f
	ld l,<w7TextDisplayState		; $4d32
	ld (hl),$0f		; $4d34
	ld a,$00		; $4d36
	ld (wTextDisplayMode),a		; $4d38
	ret			; $4d3b

;;
; @addr{4d3c}
@state04:
	ld a,$00		; $4d3c
	ld (wTextDisplayMode),a		; $4d3e
	ld h,d			; $4d41
	ld l,e			; $4d42
	ld (hl),$02		; $4d43
	inc l			; $4d45
	ld (hl),$00		; $4d46
	ld l,$c5		; $4d48
	ldi a,(hl)		; $4d4a
	ld (hl),a		; $4d4b
	ld l,$d3		; $4d4c
	ld (hl),$40		; $4d4e
	ld l,$e0		; $4d50
	ld b,$0a		; $4d52
	call clearMemory		; $4d54
	call _drawLineOfText		; $4d57
	jp _dmaTextGfxBuffer		; $4d5a


inventoryTextCode:

;;
; Initialization
; @addr{4d5d}
@state00:
	; hl = w7TextDisplayState (go to state $01)
	ld h,d			; $4d5d
	ld l,e			; $4d5e
	inc (hl)		; $4d5f

	ld l,<w7TextIndexL_backup		; $4d60
	ld a,(wTextIndexL)		; $4d62
	ld (hl),a		; $4d65

	ld l,<w7InvTextScrollTimer		; $4d66
	ld (hl),$28		; $4d68

	ld l,<w7InvTextSpacesAfterName		; $4d6a
	ld a,$ff		; $4d6c
	ld (hl),a		; $4d6e

	ld l,<w7TextStatus	; $4d6f
	ld (hl),a		; $4d71

	call _doInventoryTextFirstPass		; $4d72

	ld d,>w7TextAddressL		; $4d75
	jr z,+			; $4d77

	ld e,<w7TextAddressL		; $4d79
	ld a,l			; $4d7b
	ld (de),a		; $4d7c
	inc e			; $4d7d
	ld a,h			; $4d7e
	ld (de),a		; $4d7f

	ld e,<w7InvTextSpacesAfterName		; $4d80
	ld a,(de)		; $4d82
	or a			; $4d83
	jr z,++			; $4d84

	inc a			; $4d86
	srl a			; $4d87
	ld (de),a		; $4d89
+
	ld e,<w7InvTextSpacesAfterName		; $4d8a
	ld a,(de)		; $4d8c
	inc a			; $4d8d
	jr z,@@stopText		; $4d8e
++
	ld e,<w7TextStatus	; $4d90
	ld a,(de)		; $4d92
	or a			; $4d93
	jr nz,@@end		; $4d94

@@stopText:
	ld (wTextIsActive),a		; $4d96

@@end:
	; Load the graphics from w7TextGfxBuffer
	ld a,UNCMP_GFXH_17		; $4d99
	jp loadUncompressedGfxHeader		; $4d9b

;;
; Text is paused on the name of the item being viewed
; @addr{4d9e}
@state01:
	call _decInvTextScrollTimer		; $4d9e
	ret nz			; $4da1

	; hl = w7InvTextScrollTimer
	ld (hl),$01		; $4da2

	; hl = w7TextDisplayState (go to state 2)
	ld l,e			; $4da4
	inc (hl)		; $4da5

	ld l,<w7TextStatus	; $4da6
	ld (hl),$ff		; $4da8
	ret			; $4daa

;;
; Text is scrolling and more remains to be read
; @addr{4dab}
@state02:
	call _decInvTextScrollTimer		; $4dab
	ret nz			; $4dae

	call _shiftTextGfxBufferLeft		; $4daf
--
	call _readByteFromW7ActiveBankAndIncHl		; $4db2

	cp $10			; $4db5
	jr nc,@drawCharacter	; $4db7

	cp $01			; $4db9
	jr z,@drawSpace	; $4dbb

	call _handleTextControlCodeWithSpecialCase		; $4dbd
	; Jump if it was command $06 (a special symbol)
	jr z,@saveTextAddressAndDmaTextGfxBuffer	; $4dc0

	; Keep looping until an actual character is read, or the end of the
	; text is reached.
	ld a,(w7TextStatus)		; $4dc2
	or a			; $4dc5
	jr nz,--		; $4dc6

	; End of text has been reached.

	ld a,l			; $4dc8
	ld b,h			; $4dc9

	ld hl,w7TextStatus		; $4dca
	ld (hl),$ff		; $4dcd

	; Insert $10 blank spaces before looping to the start of the text.
	ld l,<w7InvTextSpaceCounter		; $4dcf
	ld (hl),$10		; $4dd1

	; Go to state $03
	ld l,<w7TextDisplayState		; $4dd3
	inc (hl)		; $4dd5

	ld l,<w7TextAddressL		; $4dd6
	ldi (hl),a		; $4dd8
	ld (hl),b		; $4dd9

@drawSpaceWithoutSavingTextAddress:
	ld a,$20		; $4dda
	ld bc,w7TextGfxBuffer+$1e0		; $4ddc
	call retrieveTextCharacter		; $4ddf
	jr @dmaTextGfxBuffer		; $4de2

;;
; Text is scrolling but all of it has been displayed
; @addr{4de4}
@state03:
	call _decInvTextScrollTimer		; $4de4
	ret nz			; $4de7

	; hl = w7InvTextSpaceCounter
	inc l			; $4de8
	dec (hl)		; $4de9
	jr nz,@insertSpace			; $4dea

	; hl = w7TextDisplayState (go to state $04)
	ld l,e			; $4dec
	inc (hl)		; $4ded

	; Reload the text index?
	ld l,<w7TextIndexL_backup		; $4dee
	ld a,(hl)		; $4df0
	ld (wTextIndexL),a		; $4df1
	ld a,(wTextIndexH_backup)		; $4df4
	ld (wTextIndexH),a		; $4df7

	; This will get the start address of the text based on wTextIndexL/H.
	call _checkInitialTextCommands		; $4dfa

@insertSpace:
	call _shiftTextGfxBufferLeft		; $4dfd

@drawSpace:
	; $20 = character for space
	ld a,$20		; $4e00

@drawCharacter:
	ld bc,w7TextGfxBuffer+$1e0		; $4e02
	call retrieveTextCharacter		; $4e05

@saveTextAddressAndDmaTextGfxBuffer:
	ld a,l			; $4e08
	ld (w7TextAddressL),a		; $4e09
	ld a,h			; $4e0c
	ld (w7TextAddressH),a		; $4e0d

@dmaTextGfxBuffer:
	; Copy w7TextGfxBuffer to vram
	ld a,UNCMP_GFXH_17		; $4e10
	jp loadUncompressedGfxHeader		; $4e12

;;
; The name of the item is being read again.
; @addr{4e15}
@state04:
	call _decInvTextScrollTimer		; $4e15
	ret nz			; $4e18

	call _shiftTextGfxBufferLeft		; $4e19
---
	call _readByteFromW7ActiveBankAndIncHl		; $4e1c
	cp $10			; $4e1f
	jr nc,@drawCharacter	; $4e21

	cp $01			; $4e23
	jr nz,++			; $4e25

	; Newline character

	ld a,l			; $4e27
	ld b,h			; $4e28
	ld hl,w7TextAddressL		; $4e29
	ld l,<w7TextAddressL		; $4e2c
	ldi (hl),a		; $4e2e
	ld (hl),b		; $4e2f

	ld l,<w7InvTextSpacesAfterName		; $4e30
	ld a,(hl)		; $4e32
	ld l,<w7InvTextSpaceCounter		; $4e33
	ld (hl),a		; $4e35

	; Go to state $05
	ld l,<w7TextDisplayState		; $4e36
	inc (hl)		; $4e38

	or a			; $4e39
	jr nz,@drawSpaceWithoutSavingTextAddress	; $4e3a

	; Go to state $06
	inc (hl)		; $4e3c
	ret			; $4e3d
++
	call _handleTextControlCodeWithSpecialCase		; $4e3e
	jr z,@saveTextAddressAndDmaTextGfxBuffer	; $4e41

	jr ---			; $4e43

;;
; The name of the item has been read, now it's scrolling to the middle.
; @addr{4e45}
@state05:
	call _decInvTextScrollTimer		; $4e45
	ret nz			; $4e48

	; hl = w7InvTextSpaceCounter
	inc l			; $4e49
	dec (hl)		; $4e4a
	jr nz,@insertSpace		; $4e4b

	; hl = w7InvTextScrollTimer
	dec l			; $4e4d
	ld (hl),$28		; $4e4e

	; hl = w7TextDisplayState (go to state $01)
	ld l,e			; $4e50
	ld (hl),$01		; $4e51
	ret			; $4e53

;;
; @addr{4e54}
@state06:
	call _decInvTextScrollTimer		; $4e54
	ret nz			; $4e57

	; hl = w7InvTextScrollTimer
	ld (hl),$28		; $4e58

	; hl = w7TextDisplayState (go to state $07)
	ld l,e			; $4e5a
	inc (hl)		; $4e5b
	ret			; $4e5c

;;
; @addr{4e5d}
@state07:
	call _decInvTextScrollTimer		; $4e5d
	ret nz			; $4e60

	; hl = w7InvTextScrollTimer
	ld (hl),$08		; $4e61

	; hl = w7TextDisplayState (go to state $02)
	ld l,e			; $4e63
	ld (hl),$02		; $4e64

	ld l,<w7TextStatus		; $4e66
	ld (hl),$ff		; $4e68

	ld l,<w7TextAddressL		; $4e6a
	ldi a,(hl)		; $4e6c
	ld h,(hl)		; $4e6d
	ld l,a			; $4e6e
	jp @drawSpace		; $4e6f

;;
; Initializes text stuff, particularly position variables for the textbox.
; @addr{4e72}
_initTextboxStuff:
	ld a,(wActiveLanguage)		; $4e72
	ld b,a			; $4e75
	add a			; $4e76
	add b			; $4e77
	ld hl,textTableTable
	rst_addAToHl			; $4e7b
	ldi a,(hl)		; $4e7c
	ld (w7TextTableAddr),a		; $4e7d
	ldi a,(hl)		; $4e80
	ld (w7TextTableAddr+1),a		; $4e81
	ld a,(hl)		; $4e84
	ld (w7TextTableBank),a		; $4e85
	call _checkInitialTextCommands		; $4e88

	ld hl,w7TextSound		; $4e8b
	ld (hl),SND_TEXT	; $4e8e

	; w7CharacterDisplayLength
	inc l			; $4e90
	call _getCharacterDisplayLength		; $4e91
	ldi (hl),a		; $4e94

	; w7TextAttribute
	inc l			; $4e95
	ld (hl),$80		; $4e96
	; w7TextArrowState
	inc l			; $4e98
	ld (hl),$03		; $4e99
	; w7TextboxPosBank
	inc l			; $4e9b
	ld de,w3VramTiles	; $4e9c
	ld (hl),:w3VramTiles		; $4e9f

	ld a,(wOpenedMenuType)		; $4ea1
	or a			; $4ea4
	jr z,+			; $4ea5

	ld de,w4TileMap		; $4ea7
	ld (hl),:w4TileMap	; $4eaa
+
	ld a,(wTextboxPosition)		; $4eac
	ld hl,@textboxPositions		; $4eaf
	rst_addDoubleIndex			; $4eb2
	ldi a,(hl)		; $4eb3
	ld h,(hl)		; $4eb4
	ld l,a			; $4eb5
	push hl			; $4eb6
	add e			; $4eb7
	ld l,a			; $4eb8
	ld a,d			; $4eb9
	adc h			; $4eba
	ld h,a			; $4ebb

	; Adjust Y of textbox based on hCameraY
	ld de,$0020		; $4ebc
	ldh a,(<hCameraY)	; $4ebf
	add $04			; $4ec1
	and $f8			; $4ec3
	jr z,++			; $4ec5

	swap a			; $4ec7
	rlca			; $4ec9
-
	add hl,de		; $4eca
	dec a			; $4ecb
	jr nz,-			; $4ecc
++
	; Adjust X of textbox based on hCameraX
	ldh a,(<hCameraX)	; $4ece
	add $04			; $4ed0
	and $f8			; $4ed2
	swap a			; $4ed4
	rlca			; $4ed6
	add l			; $4ed7
	ld (w7TextboxPosL),a		; $4ed8

	ld a,h			; $4edb
	ld (w7TextboxPosH),a		; $4edc

	; Same as above but for calculating the position in vram. Accounts for
	; wScreenOffsetX/Y for some reason? That's weirdly inconsistent. If
	; a textbox came up while those were nonzero, I think graphics could
	; get messed up.
	pop hl			; $4edf
	ldh a,(<hCameraY)	; $4ee0
	ld b,a			; $4ee2
	ld a,(wScreenOffsetY)		; $4ee3
	add b			; $4ee6
	add $04			; $4ee7
	and $f8			; $4ee9
	jr z,++			; $4eeb

	; a /= 8
	swap a			; $4eed
	rlca			; $4eef
-
	add hl,de		; $4ef0
	dec a			; $4ef1
	jr nz,-			; $4ef2
++
	ld a,h			; $4ef4
	and $03			; $4ef5
	ld h,a			; $4ef7
	ld a,(wTextMapAddress)		; $4ef8
	ld b,a			; $4efb
	ld c,$00		; $4efc
	add hl,bc		; $4efe
	ld a,l			; $4eff
	ld (w7TextboxVramPosL),a		; $4f00
	ld a,h			; $4f03
	ld (w7TextboxVramPosH),a		; $4f04

	ld a,(wScreenOffsetX)		; $4f07
	ld b,a			; $4f0a
	ldh a,(<hCameraX)	; $4f0b
	add $04			; $4f0d
	add b			; $4f0f
	and $f8			; $4f10
	swap a			; $4f12
	rlca			; $4f14
	ld (w7d0cc),a		; $4f15

	sub $20			; $4f18
	cpl			; $4f1a
	dec a			; $4f1b
	cp $10			; $4f1c
	jr c,+			; $4f1e
	ld a,$10		; $4f20
+
	ld ($d0cd),a		; $4f22
	ld b,a			; $4f25
	ld a,$10		; $4f26
	sub b			; $4f28
	ld ($d0ce),a		; $4f29

	ld a,(wTextboxFlags)		; $4f2c
	bit TEXTBOXFLAG_BIT_NOCOLORS,a			; $4f2f
	ret nz			; $4f31

	; If neither TEXTBOXFLAG_ALTPALETTE2 nor TEXTBOXFLAG_ALTPALETTE1 is set, use PALH_0e
	and TEXTBOXFLAG_ALTPALETTE2 | TEXTBOXFLAG_ALTPALETTE1	; $4f32
	ld a,PALH_0e		; $4f34
	jr z,+			; $4f36

	; If TEXTBOXFLAG_ALTPALETTE2 is set, use PALH_bd
	ld a,(wTextboxFlags)		; $4f38
	and TEXTBOXFLAG_ALTPALETTE2			; $4f3b
.ifdef ROM_AGES
	ld a,PALH_bd		; $4f3d
.else
	ld a,SEASONS_PALH_bd		; $4f3d
.endif
	jr nz,+			; $4f3f

	; If TEXTBOXFLAG_ALTPALETTE1 is set, use PALH_0d
	ld a,$81		; $4f41
	ld (w7TextAttribute),a		; $4f43
	ld a,PALH_0d		; $4f46
+
	jp loadPaletteHeader		; $4f48

; @addr{4f4b}
@textboxPositions:
	.dw $0020 $00a0 $0140 $0180 $0160 $00c0 $0060

;;
; Gets address of the text index in hl, stores bank number in [w7ActiveBank]
; @addr{4f59}
_getTextAddress:
	push de			; $4f59
	ld a,(w7TextTableAddr)		; $4f5a
	ld l,a			; $4f5d
	ld a,(w7TextTableAddr+1)		; $4f5e
	ld h,a			; $4f61
	push hl			; $4f62
	ld a,(wTextIndexH)		; $4f63
	rst_addDoubleIndex			; $4f66
	call readByteFromW7TextTableBank		; $4f67
	ld c,a			; $4f6a
	call readByteFromW7TextTableBank		; $4f6b
	ld b,a			; $4f6e
	pop hl			; $4f6f
	add hl,bc		; $4f70
	ld a,(wTextIndexL)		; $4f71
	rst_addDoubleIndex			; $4f74
	call readByteFromW7TextTableBank		; $4f75
	ld c,a			; $4f78
	call readByteFromW7TextTableBank		; $4f79
	ld b,a			; $4f7c

; If wTextIndexH < TEXT_OFFSET_SPLIT_INDEX, text is relative to TEXT_OFFSET_1
	ld a,(wActiveLanguage)		; $4f7d
	add a			; $4f80
	ld hl,textOffset1Table
	rst_addDoubleIndex			; $4f84
	ldi a,(hl)		; $4f85
	ld e,a			; $4f86
	ldi a,(hl)		; $4f87
	ld h,(hl)		; $4f88
	ld l,a			; $4f89
	ld a,(wTextIndexH)		; $4f8a
	cp TEXT_OFFSET_SPLIT_INDEX
	jr c,+	; $4f8f
; Else, text is relative to TEXT_OFFSET_2
	ld a,(wActiveLanguage)		; $4f91
	add a			; $4f94
	ld hl,textOffset2Table		; $4f95
	rst_addDoubleIndex			; $4f98
	ldi a,(hl)		; $4f99
	ld e,a			; $4f9a
	ldi a,(hl)		; $4f9b
	ld h,(hl)		; $4f9c
	ld l,a			; $4f9d
+
	ld a,e			; $4f9e
	add $04			; $4f9f
	add hl,bc		; $4fa1
	jr c,++

	ld a,h			; $4fa4
	and $c0			; $4fa5
	rlca			; $4fa7
	rlca			; $4fa8
	add e			; $4fa9
++
	ld (w7ActiveBank),a		; $4faa
	res 7,h			; $4fad
	set 6,h			; $4faf
	pop de			; $4fb1
	ret			; $4fb2


textOffset1Table: ; $0fb3
	.db :TEXT_OFFSET_1
	.dw TEXT_OFFSET_1&$3fff
	.db 0
	.db :TEXT_OFFSET_1
	.dw TEXT_OFFSET_1&$3fff
	.db 0
	.db :TEXT_OFFSET_1
	.dw TEXT_OFFSET_1&$3fff
	.db 0
	.db :TEXT_OFFSET_1
	.dw TEXT_OFFSET_1&$3fff
	.db 0
	.db :TEXT_OFFSET_1
	.dw TEXT_OFFSET_1&$3fff
	.db 0
	.db :TEXT_OFFSET_1
	.dw TEXT_OFFSET_1&$3fff
	.db 0

textOffset2Table: ; $0fcb
	.db :TEXT_OFFSET_2
	.dw TEXT_OFFSET_2&$3fff
	.db 0
	.db :TEXT_OFFSET_2
	.dw TEXT_OFFSET_2&$3fff
	.db 0
; These seem to be corrupted. Only the first entry is used anyway, though.
	.db :TEXT_OFFSET_2
	.dw TEXT_OFFSET_1&$3fff
	.db 0
	.db :TEXT_OFFSET_2
	.dw TEXT_OFFSET_1&$3fff
	.db 0
	.db :TEXT_OFFSET_2
	.dw TEXT_OFFSET_1&$3fff
	.db 0
	.db :TEXT_OFFSET_2
	.dw TEXT_OFFSET_1&$3fff
	.db 0

textTableTable: ; $0fe3
	Pointer3Byte textTableENG
	Pointer3Byte textTableENG
	Pointer3Byte textTableENG
	Pointer3Byte textTableENG
	Pointer3Byte textTableENG
	Pointer3Byte textTableENG

;;
; This peeks at the text to check if the next command is something particular.
; It deals with the textbox positioning command ("\pos()" in text.txt) and
; command 8 (displaying extra text after buying something).
; Most of the time this does nothing though.
; @addr{4ff5}
_checkInitialTextCommands:
	push de			; $4ff5
	call _getTextAddress		; $4ff6
	call readByteFromW7ActiveBank		; $4ff9
	cp $08			; $4ffc
	jr z,@cmd8		; $4ffe

	cp $0c			; $5000
	jr nz,@end		; $5002

@cmdc:
	ld d,h			; $5004
	ld e,l			; $5005
	call _incHlAndUpdateBank		; $5006
	call readByteFromW7ActiveBank		; $5009
	ld b,a			; $500c
	and $fc			; $500d
	cp $20			; $500f
	jr z,+			; $5011

	ld h,d			; $5013
	ld l,e			; $5014
	jr @end			; $5015
+
	ld a,(wTextboxFlags)		; $5017
	bit TEXTBOXFLAG_BIT_DONTCHECKPOSITION,a			; $501a
	jr nz,+			; $501c

	ld a,b			; $501e
	and $07			; $501f
	ld (wTextboxPosition),a		; $5021
+
	call _incHlAndUpdateBank		; $5024

@end:
	ld a,l			; $5027
	ld (w7TextAddressL),a		; $5028
	ld a,h			; $502b
	ld (w7TextAddressH),a		; $502c
	pop de			; $502f
	ret			; $5030

@cmd8:
	call _incHlAndUpdateBank		; $5031
	call readByteFromW7ActiveBank		; $5034
	call _getExtraTextIndex		; $5037
	cp $ff			; $503a
	jp z,@noExtraText	; $503c

	ld (wTextIndexL),a		; $503f
	jr _checkInitialTextCommands		; $5042

@noExtraText:
	ld a,$00		; $5044
	ld (wTextDisplayMode),a		; $5046
	ld hl,w7TextDisplayState		; $5049
	ld (hl),$0f		; $504c

	; w7d0c1
	inc l			; $504e
	set 3,(hl)		; $504f

	; w7TextStatus
	inc l			; $5051
	ld (hl),$00		; $5052
	ret			; $5054

;;
; Gets the graphics for a line of text and puts it into w7TextGfxBuffer.
; Also sets w7LineTextBuffer, w7LineAttributesBuffer, etc.
; @addr{5055}
_drawLineOfText:
	ld h,d			; $5055
	ld l,<w7TextStatus		; $5056
	ld (hl),$ff		; $5058
	ld l,<w7TextAddressL		; $505a
	push hl			; $505c
	ldi a,(hl)		; $505d
	ld h,(hl)		; $505e
	ld l,a			; $505f
	push hl			; $5060
	call _clearTextGfxBuffer		; $5061
	call _clearLineTextBuffer		; $5064
	pop hl			; $5067
	ld bc,w7TextGfxBuffer	; $5068
--
	call _readByteFromW7ActiveBankAndIncHl		; $506b
	cp $10			; $506e
	jr nc,+			; $5070

	call _handleTextControlCode		; $5072

	; Check whether to stop? ($00 = end of textbox, $01 = newline)
	ld a,(w7TextStatus)		; $5075
	cp $02			; $5078
	jr nc,--		; $507a

	jr ++			; $507c
+
	call _setLineTextBuffers		; $507e
	call retrieveTextCharacter		; $5081
	jr --			; $5084
++
	pop de			; $5086
	ld a,l			; $5087
	ld (de),a		; $5088
	inc e			; $5089
	ld a,h			; $508a
	ld (de),a		; $508b
	ld e,$d0		; $508c
	xor a			; $508e
	ld (de),a		; $508f
	ret			; $5090

;;
; @addr{5091}
_clearTextGfxBuffer:
	ld hl,w7TextGfxBuffer	; $5091
	ld bc,$0200		; $5094
	ld a,$ff		; $5097
	jp fillMemoryBc		; $5099

;;
; @addr{509c}
_clearLineTextBuffer:
	ld hl,w7LineTextBuffer		; $509c
	ld d,h			; $509f
	ld e,l			; $50a0
	ld b,$10		; $50a1
	jp clearMemory		; $50a3

;;
; Given an address in w7LineTextBuffers, this sets the values for this
; character in each LineBuffer to appropriate values.
; @param a Character
; @param de Address in w7LineTextBuffer
; @addr{50a6}
_setLineTextBuffers:
	; Write to w7LineTextBuffer
	ld (de),a		; $50a6
	push de			; $50a7
	push hl			; $50a8

	; Write to w7LineAttributesBuffer
	ld hl,w7TextAttribute		; $50a9
	ld a,e			; $50ac
	add $10			; $50ad
	ld e,a			; $50af
	ldd a,(hl)		; $50b0
	ld (de),a		; $50b1

	; Write w7CharacterDisplayLength to w7LineDelaysBuffer
	ld a,e			; $50b2
	add $10			; $50b3
	ld e,a			; $50b5
	dec l			; $50b6
	ldd a,(hl)		; $50b7
	ld (de),a		; $50b8

	; Write w7TextSound to w7LineSoundsBuffer
	ld a,e			; $50b9
	add $10			; $50ba
	ld e,a			; $50bc
	ldd a,(hl)		; $50bd
	ld (de),a		; $50be

	; Write w7SoundEffect to w7LineSoundEffectsBuffer
	ld a,e			; $50bf
	add $10			; $50c0
	ld e,a			; $50c2
	ld a,(hl)		; $50c3
	ld (de),a		; $50c4
	ld (hl),$00		; $50c5

	pop hl			; $50c7
	pop de			; $50c8
	ld a,(de)		; $50c9
	inc e			; $50ca
	ret			; $50cb

;;
; @param a Relative offset for where to write to. Should be $00 or $02.
; @addr{50cc}
_dmaTextGfxBuffer:
	add $94			; $50cc
	ld d,a			; $50ce
	ld e,$00		; $50cf
	ld hl,w7TextGfxBuffer		; $50d1
	ldbc $1f, TEXT_BANK		; $50d4
	push hl			; $50d7
	call queueDmaTransfer		; $50d8
	pop hl			; $50db
	ret			; $50dc

;;
; @addr{50dd}
_saveTilesUnderTextbox:
	ld hl,w7TextboxPosL		; $50dd
	ld e,(hl)		; $50e0
	inc l			; $50e1
	ld d,(hl)		; $50e2
	inc l			; $50e3
	ld l,(hl)		; $50e4
	ld h,$d0		; $50e5
	call @copyTileMap	; $50e7

	; The attribute map is assumed to be $400 bytes after the tile map
	ld hl,w7TextboxPosL		; $50ea
	ld e,(hl)		; $50ed
	inc l			; $50ee
	ldi a,(hl)		; $50ef
	add $04			; $50f0
	ld d,a			; $50f2
	ld l,(hl)		; $50f3
	ld h,$d1		; $50f4

;;
; Copies 6 rows of tiles (from a tile map) from de to hl. A row is $20 bytes,
; so this copies $c0 bytes. It uses an intermediate buffer at wTmpVramBuffer in
; order to copy between any 2 banks.
; @param de Where to copy the data from
; @param hl Where to copy the data to (bank 7)
; @param [w7TextboxPosBank] Bank to copy the data from
; @addr{50f6}
@copyTileMap:
	; Iterate 3 times
	ld a,$03		; $50f6

@next2Rows:
	push af			; $50f8
	push hl			; $50f9
	ld a,(w7TextboxPosBank)		; $50fa
	ld ($ff00+R_SVBK),a	; $50fd

	; Copy 2 rows ($40 bytes) to wTmpVramBuffer
	ld hl,wTmpVramBuffer		; $50ff
	ld a,$02		; $5102
@getNextRow:
	push af			; $5104
	ld a,e			; $5105
	and $e0			; $5106
	ld c,a			; $5108
	ld b,$20		; $5109

@getNextTile:
	ld a,(de)		; $510b
	ldi (hl),a		; $510c
	ld a,e			; $510d
	inc a			; $510e
	and $1f			; $510f
	or c			; $5111
	ld e,a			; $5112
	dec b			; $5113
	jr nz,@getNextTile		; $5114

	ld a,$20		; $5116
	call addAToDe		; $5118
	pop af			; $511b
	dec a			; $511c
	jr nz,@getNextRow		; $511d

	; Change back to bank 7,
	ld a,$07		; $511f
	ld ($ff00+R_SVBK),a	; $5121
	pop hl			; $5123
	push de			; $5124

	; Copy the 2 rows in wTmpVramBuffer to hl (parameter to function)
	ld de,wTmpVramBuffer		; $5125
	ld a,$02		; $5128
@writeNextRow:
	push af			; $512a
	ld a,l			; $512b
	and $e0			; $512c
	ld c,a			; $512e
	ld b,$20		; $512f

@writeNextTile:
	ld a,(de)		; $5131
	ld (hl),a		; $5132
	inc e			; $5133
	ld a,l			; $5134
	inc a			; $5135
	and $1f			; $5136
	or c			; $5138
	ld l,a			; $5139
	dec b			; $513a
	jr nz,@writeNextTile	; $513b

	ld a,$20		; $513d
	rst_addAToHl			; $513f
	pop af			; $5140
	dec a			; $5141
	jr nz,@writeNextRow	; $5142

	pop de			; $5144
	pop af			; $5145
	dec a			; $5146
	jr nz,@next2Rows	; $5147

	ret			; $5149

;;
; Initialize the textbox map and attributes so it starts as a black box.
; @addr{514a}
_initTextboxMapping:
	ld a,(w7d0cc)		; $514a
	inc a			; $514d
	and $1f			; $514e
	ld l,a			; $5150
	ld e,$05		; $5151
--
	ld b,$12		; $5153
	ld a,l			; $5155
	ld d,a			; $5156
	and $e0			; $5157
	ld c,a			; $5159
-
	ld h,>w7TextboxMap	; $515a
	ld (hl),$02		; $515c
	ld h,>w7TextboxAttributes	; $515e
	ld (hl),$80		; $5160
	ld a,l			; $5162
	inc a			; $5163
	and $1f			; $5164
	or c			; $5166
	ld l,a			; $5167
	dec b			; $5168
	jr nz,-			; $5169

	ld a,d			; $516b
	add $20			; $516c
	ld l,a			; $516e
	dec e			; $516f
	jr nz,--		; $5170

	ret			; $5172

;;
; Sets up the textbox map and attributes for dma'ing.
; I have no idea what the branch instructions are for.
; @addr{5173}
_dmaTextboxMap:
	ld a,(wTextMapAddress)		; $5173
	add $03			; $5176
	ld c,a			; $5178
	ld hl,w7TextboxVramPosL		; $5179
	ldi a,(hl)		; $517c
	ld e,a			; $517d
	cp $61			; $517e
	ld a,(hl)		; $5180
	ld d,a			; $5181
	jr c,+			; $5182

	cp c			; $5184
	jr z,++			; $5185
+
	ld b,$09		; $5187
	ld hl,w7TextboxMap	; $5189

@func:
	ld c,TEXT_BANK		; $518c
	push hl			; $518e
	call queueDmaTransfer		; $518f
	pop hl			; $5192
	inc e			; $5193
	inc h			; $5194
	jp queueDmaTransfer		; $5195
++
	xor a			; $5198
	sub e			; $5199
	ld c,a			; $519a
	swap a			; $519b
	dec a			; $519d
	ld b,a			; $519e
	ld hl,w7TextboxMap	; $519f
	push bc			; $51a2
	call @func		; $51a3

	pop bc			; $51a6
	ld a,(wTextMapAddress)		; $51a7
	ld d,a			; $51aa
	ld e,$00		; $51ab
	ld l,c			; $51ad
	ld h,>w7TextboxMap	; $51ae
	ld a,$a0		; $51b0
	sub c			; $51b2
	swap a			; $51b3
	dec a			; $51b5
	ld b,a			; $51b6
	jr @func		; $51b7

;;
; Updates the timer, and sets bit 0 of w7d0c1 if A or B is pressed.
; @addr{51b9}
_updateCharacterDisplayTimer:
	ld h,d			; $51b9
	ld l,<w7TextSoundCooldownCounter		; $51ba
	ld a,(hl)		; $51bc
	or a			; $51bd
	jr z,+			; $51be
	dec (hl)		; $51c0
+
	ld l,<w7TextSlowdownTimer	; $51c1
	ld a,(hl)		; $51c3
	or a			; $51c4
	jr z,@checkInput	; $51c5

	dec (hl)		; $51c7
	jr nz,@countdownToNextCharacter	; $51c8

@checkInput:
	ld a,(wKeysJustPressed)		; $51ca
	and BTN_A | BTN_B		; $51cd
	jr nz,@skipToLineEnd	; $51cf

	; Wait for the next character to display itself
@countdownToNextCharacter:
	ld l,<w7CharacterDisplayTimer		; $51d1
	dec (hl)		; $51d3
	ret			; $51d4

	; Skip to the end of the line
@skipToLineEnd:
	ld l,<w7d0c1		; $51d5
	set 0,(hl)		; $51d7
	xor a			; $51d9
	ret			; $51da

;;
; This function updates the textbox's tilemap to display the next character, as
; well as playing associated sound effects and whatnot.
; @addr{51db}
_displayNextTextCharacter:
	ld e,<w7d0d3		; $51db
	ld a,(de)		; $51dd
	ld c,a			; $51de
	cp $40			; $51df
	ld b,$00		; $51e1
	jr z,+			; $51e3
	ld b,$40		; $51e5
+
	ld e,<w7NextTextColumnToDisplay		; $51e7
	ld a,(de)		; $51e9
	ld l,a			; $51ea
	ld e,<w7d0cc		; $51eb
	ld a,(de)		; $51ed
	add $02			; $51ee
	add l			; $51f0
	and $1f			; $51f1
	add b			; $51f3
	ld e,a			; $51f4

	; Get character, check if it's null (end of text)
	ld h,>w7LineTextBuffer		; $51f5
	ld a,(hl)		; $51f7
	or a			; $51f8
	jr z,@endLine			; $51f9

	; Store character
	ldh (<hFF8B),a	; $51fb

	; Write the tile index of the character to the textbox map (it's 8x16,
	; so there's two bytes to be written)
	ld d,>w7TextboxMap		; $51fd
	ld a,l			; $51ff
	add a			; $5200
	add c			; $5201
	ld b,a			; $5202
	inc b			; $5203
	ld (de),a		; $5204
	ld a,e			; $5205
	add $20			; $5206
	ld e,a			; $5208
	ld a,b			; $5209
	ld (de),a		; $520a

	; Similarly, write the attribute (from w7LineAttributeBuffer to
	; w7TextboxAttributes)
	inc d			; $520b
	ld a,l			; $520c
	add $10			; $520d
	ld l,a			; $520f
	ld a,(hl)		; $5210
	ld (de),a		; $5211
	ld a,e			; $5212
	sub $20			; $5213
	ld e,a			; $5215
	ld a,(hl)		; $5216
	ld (de),a		; $5217

	; Increment the column we're on
	ld d,>w7NextTextColumnToDisplay		; $5218
	ld e,<w7NextTextColumnToDisplay		; $521a
	ld a,(de)		; $521c
	inc a			; $521d
	ld (de),a		; $521e

	; End of line?
	cp $10			; $521f
	jr z,@endLine			; $5221

	call @checkCanAdvanceWithAB		; $5223
	jr nz,+			; $5226

	; Check bit 0 of <w7d0c1 (whether A or B is pressed, skip to line end)
	ld e,<w7d0c1		; $5228
	ld a,(de)		; $522a
	bit 0,a			; $522b
	jr nz,_displayNextTextCharacter	; $522d
+
	call @readSubsequentLineBuffers		; $522f
	or d			; $5232
	ret			; $5233

@endLine:
	; Play the sound effect once more if we got here by pressing A/B
	ld h,d			; $5234
	ld l,<w7d0c1		; $5235
	bit 0,(hl)		; $5237
	ret z			; $5239

	ld l,<w7TextSoundCooldownCounter		; $523a
	ld a,(hl)		; $523c
	or a			; $523d
	jr nz,+			; $523e

	ld (hl),$04		; $5240
	ld l,<w7TextSound		; $5242
	ld a,(hl)		; $5244
	call playSound		; $5245
+
	xor a			; $5248
	ret			; $5249

;;
; Reads and applies values from w7LineDelaysBuffer, w7LineSoundsBuffer, and
; w7LineSoundEffectsBuffer.
; @param hl Pointer within w7LineAttributeBuffer
; @addr{524a}
@readSubsequentLineBuffers:
	; Have hl point to w7LineDelaysBuffer, set w7CharacterDisplayTimer
	ld a,l			; $524a
	add $10			; $524b
	ld l,a			; $524d
	ld a,(hl)		; $524e
	ld e,<w7CharacterDisplayTimer		; $524f
	ld (de),a		; $5251

	; Read from w7LineSoundsBuffer
	ld a,l			; $5252
	add $10			; $5253
	ld l,a			; $5255
	ld a,(hl)		; $5256
	or a			; $5257
	jr z,++			; $5258

	; If character is a space ($20), don't play the text sound
	ld b,a			; $525a
	ldh a,(<hFF8B)	; $525b
	cp ' '			; $525d
	jr z,++			; $525f

	; Don't play the text sound if we already played one recently
	ld e,<w7TextSoundCooldownCounter		; $5261
	ld a,(de)		; $5263
	or a			; $5264
	jr nz,++		; $5265

	ld a,$04		; $5267
	ld (de),a		; $5269
	ld a,b			; $526a
	call @playSound		; $526b

++
	; Read from w7LineSoundEffectsBuffer, play sound if applicable
	; This is different from above, it's for one-off sound effects like the
	; gorons make
	ld a,l			; $526e
	add $10			; $526f
	ld l,a			; $5271
	ld a,(hl)		; $5272
	or a			; $5273
	ret z			; $5274

@playSound:
	push hl			; $5275
	call playSound		; $5276
	pop hl			; $5279
	ret			; $527a

;;
; Sets zero flag if the player isn't allowed to advance with A/B currently.
; @addr{527b}
@checkCanAdvanceWithAB:
	push hl			; $527b
	ld e,<w7NextTextColumnToDisplay		; $527c
	ld a,(de)		; $527e
	add <w7LineAdvanceableBuffer			; $527f
	ld l,a			; $5281
	ld h,>w7LineAdvanceableBuffer		; $5282
	bit 0,(hl)		; $5284
	pop hl			; $5286
	ret			; $5287

;;
; Get the next character to display based on w7NextTextColumnToDisplay.
; Sets the zero flag if there's nothing more to display this line.
; @addr{5288}
_getNextCharacterToDisplay:
	ld e,<w7NextTextColumnToDisplay		; $5288
	ld a,(de)		; $528a
	cp $10			; $528b
	ret z			; $528d

	add <w7LineTextBuffer		; $528e
	ld l,a			; $5290
	ld h,>w7LineTextBuffer	; $5291
	ld a,(hl)		; $5293
	or a			; $5294
	ret			; $5295

;;
; @addr{5296}
_func_5296:
	ld h,d			; $5296
	ld l,<w7d0c1		; $5297
	ldd a,(hl)		; $5299
	bit 2,a			; $529a
	jr nz,@chooseOption	; $529c

	bit 1,a			; $529e
	jr nz,_label_3f_155	; $52a0

	bit 4,a			; $52a2
	ret z			; $52a4

	call _readNextTextByte		; $52a5
	cp $ff			; $52a8
	jr z,_label_3f_158	; $52aa

	ld (wTextIndexL),a		; $52ac
	call _checkInitialTextCommands		; $52af
	ld e,<w7d0c1		; $52b2
	xor a			; $52b4
	ld (de),a		; $52b5
	inc e			; $52b6
	inc a			; $52b7
	ld (de),a		; $52b8
	ret			; $52b9

; The text has an option being displayed (ie. yes/no)
@chooseOption:
	ld e,<w7TextStatus		; $52ba
	ld a,(de)		; $52bc
	or a			; $52bd
	jr nz,_label_3f_159	; $52be

	ld (hl),a		; $52c0
	ld a,$01		; $52c1
	ld (wTextDisplayMode),a		; $52c3
	or h			; $52c6
	ret			; $52c7

_label_3f_155:
	bit 0,a			; $52c8
	jr z,+			; $52ca

	inc l			; $52cc
	res 0,(hl)		; $52cd
	jr _label_3f_157		; $52cf
+
	ld a,(wKeysJustPressed)		; $52d1
	and $03			; $52d4
	jr z,_label_3f_157	; $52d6
	ld (hl),$00		; $52d8
	ld l,$c1		; $52da
	res 1,(hl)		; $52dc
	pop hl			; $52de
	ld a,SND_TEXT_2		; $52df
	jp playSound		; $52e1
_label_3f_157:
	call _updateTextboxArrow		; $52e4
	or h			; $52e7
	ret			; $52e8
_label_3f_158:
	xor a			; $52e9
	ld ($00c2),a		; $52ea
	ret			; $52ed

_label_3f_159:
	ld hl,w7TextboxOptionPositions		; $52ee
_label_3f_160:
	ld a,(hl)		; $52f1
	or a			; $52f2
	ret z			; $52f3

	xor $20			; $52f4
	ldi (hl),a		; $52f6
	ld a,l			; $52f7
	and $07			; $52f8
	jr nz,_label_3f_160	; $52fa
	ret			; $52fc

;;
; @addr{52fd}
_readNextTextByte:
	ld l,<w7TextAddressL	; $52fd
	ldi a,(hl)		; $52ff
	ld h,(hl)		; $5300
	ld l,a			; $5301
	call _readByteFromW7ActiveBankAndIncHl		; $5302

;;
; This is part of text command $08, used in shops when trying to buy something.
; @param a Index
; @addr{5305}
_getExtraTextIndex:
	ld hl,_extraTextIndices		; $5305
	rst_addDoubleIndex			; $5308
	ldi a,(hl)		; $5309
	ld h,(hl)		; $530a
	ld l,a			; $530b
	ldi a,(hl)		; $530c
	ld c,a			; $530d
	ldi a,(hl)		; $530e
	ld b,a			; $530f
	ld a,(bc)		; $5310
	rst_addAToHl			; $5311
	ld a,(hl)		; $5312
	ret			; $5313

;;
; Update the little red arrow in the bottom-right of the textbox.
; @addr{5314}
_updateTextboxArrow:
	ld a,(wFrameCounter)		; $5314
	and $0f			; $5317
	ret nz			; $5319

	; Get position of little red arrow in hl
	ld e,<w7d0cc		; $531a
	ld a,(de)		; $531c
	add $12			; $531d
	and $1f			; $531f
	add <w7TextboxMap+$80			; $5321
	ld l,a			; $5323
	ld h,>w7TextboxMap		; $5324

	ld e,<w7TextArrowState		; $5326
	ld a,(de)		; $5328
	cp $03			; $5329
	ld a,$02		; $532b
	jr z,+			; $532d
	ld a,$03		; $532f
+
	ld (de),a		; $5331
	ld (hl),a		; $5332

	; Calculate the source and destination for the arrow
	ld a,(wTextMapAddress)		; $5333
	add $04			; $5336
	ld c,a			; $5338
	ld l,<w7TextboxMap+$80		; $5339
	ld h,>w7TextboxMap		; $533b
	ld e,<w7TextboxVramPosL		; $533d
	ld a,(de)		; $533f
	add l			; $5340
	ld b,a			; $5341
	inc e			; $5342
	ld a,(de)		; $5343
	adc $00			; $5344
	cp c			; $5346
	jr c,+			; $5347
	ld a,(wTextMapAddress)		; $5349
+
	ld d,a			; $534c
	ld e,b			; $534d
	ldbc $01, TEXT_BANK		; $534e
	jp queueDmaTransfer		; $5351

;;
; This clears the very top row - only the 8x8 portion, not the 8x16 portion.
; @addr{5354}
_clearTopRowOfTextMap:
	ld h,>w7TextboxMap		; $5354
	ld a,(w7d0cc)		; $5356
	add $02			; $5359
	and $1f			; $535b
	ld l,a			; $535d
	ld c,a			; $535e
	ld b,$10		; $535f
	ld a,$02		; $5361
	push bc			; $5363
	call @func		; $5364

	pop bc			; $5367
	ld h,>w7TextboxAttributes		; $5368
	ld l,c			; $536a
	ld a,$80		; $536b

@func:
	ld c,a			; $536d
	ld a,l			; $536e
	and $e0			; $536f
	ld e,a			; $5371
-
	ld (hl),c		; $5372
	ld a,l			; $5373
	inc a			; $5374
	and $1f			; $5375
	or e			; $5377
	ld l,a			; $5378
	dec b			; $5379
	jr nz,-			; $537a
	ret			; $537c

;;
; Shifts everything in w7TextboxMap and w7TextboxAttributes up one tile.
; @addr{537d}
_shiftTextboxMapUp:
	ld h,>w7TextboxMap		; $537d
	call @func		; $537f

	ld h,>w7TextboxAttributes		; $5382
@func:
	ld d,h			; $5384
	ld a,(w7d0cc)		; $5385
	add $02			; $5388
	and $1f			; $538a
	ld e,a			; $538c
	add $20			; $538d
	ld l,a			; $538f
	ld b,a			; $5390
	ld c,$04		; $5391
--
	push bc			; $5393
	ld a,e			; $5394
	and $e0			; $5395
	ld c,a			; $5397
	ld b,$10		; $5398
-
	ld a,(hl)		; $539a
	ld (de),a		; $539b
	ld a,e			; $539c
	inc a			; $539d
	and $1f			; $539e
	or c			; $53a0
	ld e,a			; $53a1
	add $20			; $53a2
	ld l,a			; $53a4
	dec b			; $53a5
	jr nz,-			; $53a6

	pop bc			; $53a8
	ld e,b			; $53a9
	ld a,b			; $53aa
	add $20			; $53ab
	ld l,a			; $53ad
	ld b,a			; $53ae
	dec c			; $53af
	jr nz,--		; $53b0
	ret			; $53b2

;;
; This resets bit 5 for every piece of text in the top row.
; This causes it to reference the values in the map $20 bytes earlier.
; @addr{53b3}
_subFirstRowOfTextMapBy20:
	ld h,>w7TextboxMap		; $53b3
	ld b,$00		; $53b5
	call @func		; $53b7

	ld b,$20		; $53ba
@func:
	ld a,(w7d0cc)		; $53bc
	add $02			; $53bf
	and $1f			; $53c1
	add b			; $53c3
	ld l,a			; $53c4
	and $e0			; $53c5
	ld c,a			; $53c7
	ld b,$10		; $53c8
--
	ld a,(hl)		; $53ca
	and $60			; $53cb
	cp $60			; $53cd
	jr nz,+			; $53cf
	res 5,(hl)		; $53d1
+
	ld a,l			; $53d3
	inc a			; $53d4
	and $1f			; $53d5
	or c			; $53d7
	ld l,a			; $53d8
	dec b			; $53d9
	jr nz,--		; $53da
	ret			; $53dc

;;
; @addr{53dd}
_func_53dd:
	ld h,d			; $53dd
	ld l,<w7d0c1		; $53de
	res 1,(hl)		; $53e0
	call _saveTilesUnderTextbox		; $53e2
	call _initTextboxMapping		; $53e5
	jp _dmaTextboxMap		; $53e8

;;
; Something to do with pieces of heart
; @addr{53eb}
_func_53eb:
	ld h,d			; $53eb
	ld l,<w7d0c1		; $53ec
	bit 5,(hl)		; $53ee
	jr nz,++		; $53f0

	ld l,<w7d0ea		; $53f2
	ld a,(hl)		; $53f4
	or a			; $53f5
	ret z			; $53f6

	dec (hl)		; $53f7
	ret nz			; $53f8

	ld b,$00		; $53f9
	call @func		; $53fb
	ld a,SND_TEXT_2		; $53fe
	call playSound		; $5400
	xor a			; $5403
	ret			; $5404
++
	res 5,(hl)		; $5405
	ld l,<w7d0ea		; $5407
	ld (hl),$1e		; $5409
	ld l,<w7d0ef		; $540b
	ld (hl),$01		; $540d
	call @dmaHeartPieceDisplay		; $540f
	ld b,$ff		; $5412

;;
; Something to do with pieces of heart
; @param b Relative number of pieces of heart to show; $ff to show one less
; than you actually have
; @addr{5414}
@func:
	ld a,(wNumHeartPieces)		; $5414
	add b			; $5417
	add a			; $5418
	push af			; $5419
	sub $08			; $541a
	jr nz,+			; $541c

	ld (wNumHeartPieces),a		; $541e
	dec a			; $5421
	ld (wStatusBarNeedsRefresh),a		; $5422
	ld (w7d0ef),a		; $5425
+
	pop af			; $5428
	ld hl,@data		; $5429
	rst_addDoubleIndex			; $542c
	ld d,$d0		; $542d
	ld a,(w7d0cc)		; $542f
	add $11			; $5432
	and $1f			; $5434
	ld c,a			; $5436
	dec a			; $5437
	and $1f			; $5438
	ld b,a			; $543a
	add $20			; $543b
	ld e,a			; $543d
	ldi a,(hl)		; $543e
	ld (de),a		; $543f
	ld a,b			; $5440
	add $40			; $5441
	ld e,a			; $5443
	ldi a,(hl)		; $5444
	ld (de),a		; $5445
	ld a,c			; $5446
	add $20			; $5447
	ld e,a			; $5449
	ldi a,(hl)		; $544a
	ld (de),a		; $544b
	ld a,c			; $544c
	add $40			; $544d
	ld e,a			; $544f
	ld a,(hl)		; $5450
	ld (de),a		; $5451
	ld d,$d1		; $5452
	ld a,(de)		; $5454
	or $20			; $5455
	ld (de),a		; $5457
	ld a,c			; $5458
	add $20			; $5459
	ld e,a			; $545b
	ld a,(de)		; $545c
	or $20			; $545d
	ld (de),a		; $545f
	call _dmaTextboxMap		; $5460
	or d			; $5463
	ret			; $5464

@data:
	.db $5d $7c $5d $7c $5f $7c $5d $7c
	.db $5f $7e $5d $7c $5f $7e $5d $7e
	.db $5f $7e $5f $7e

;;
; @addr{5479}
@dmaHeartPieceDisplay:
	ld hl,gfx_font_heartpiece		; $5479
	ld de,$95d0		; $547c
	ldbc $00, :gfx_font_heartpiece		; $547f
	call queueDmaTransfer		; $5482

	ld hl,gfx_font_heartpiece+$10		; $5485
	ld e,$f0		; $5488
	call queueDmaTransfer		; $548a

	ld hl,gfx_font_heartpiece+$20		; $548d
	ld de,$97c0		; $5490
	call queueDmaTransfer		; $5493

	ld hl,gfx_font_heartpiece+$30		; $5496
	ld e,$e0		; $5499
	jp queueDmaTransfer		; $549b

;;
; This is called when an item is first selected.
; This calculates w7InvTextSpacesAfterName such that the text will be centered.
; It also draws the initial line of text, because that should be visible
; immediately, not scrolled in.
; @addr{549e}
_doInventoryTextFirstPass:
	call _clearTextGfxBuffer		; $549e
	ld h,d			; $54a1
	ld l,<w7ActiveBank		; $54a2
	ldi a,(hl)		; $54a4
	ldh (<hFF8A),a	; $54a5
	ldi a,(hl)		; $54a7
	ld h,(hl)		; $54a8
	ld l,a			; $54a9
	push hl			; $54aa
	ld e,$00		; $54ab
--
	call _readByteFromW7ActiveBankAndIncHl		; $54ad
	cp $00			; $54b0
	jr z,@nullTerminator	; $54b2

	cp $01			; $54b4
	jr z,@lineEnd		; $54b6

	cp $10			; $54b8
	jr nc,@notControlCode	; $54ba

	call @controlCode		; $54bc
	jr --			; $54bf

@notControlCode:
	; Check if 16 or more characters have been read
	inc e			; $54c1
	bit 4,e			; $54c2
	jr z,--			; $54c4
	jr @lineEnd		; $54c6

@nullTerminator:
	call _popFromTextStack		; $54c8
	ld a,h			; $54cb
	or a			; $54cc
	jr nz,--		; $54cd

@lineEnd:
	call _popFromTextStack		; $54cf

	; pop the initial text address, store it into w7TextAddressL/H
	pop bc			; $54d2
	ld hl,w7ActiveBank		; $54d3
	ldh a,(<hFF8A)	; $54d6
	ldi (hl),a		; $54d8
	ld (hl),c		; $54d9
	inc l			; $54da
	ld (hl),b		; $54db

	; Check how many characters were read
	ld a,e			; $54dc
	or a			; $54dd
	ret z			; $54de

	; Calculate a value for w7InvTextSpacesAfterName such that it will be
	; centered.
	push bc			; $54df
	sub $11			; $54e0
	cpl			; $54e2
	ld l,<w7InvTextSpacesAfterName		; $54e3
	ld (hl),a		; $54e5

	; Calculate where in w7TextGfxBuffer to put the first character
	and $0e			; $54e6
	swap a			; $54e8
	add $00			; $54ea
	ld c,a			; $54ec

	call _clearLineTextBuffer		; $54ed
	ld b,>w7TextGfxBuffer		; $54f0
	pop hl			; $54f2

@nextCharacter:
	call _readByteFromW7ActiveBankAndIncHl		; $54f3
	cp $10			; $54f6
	jr c,+			; $54f8

	; Standard character
	call _setLineTextBuffers		; $54fa
	call retrieveTextCharacter		; $54fd

	; Stop at 16 characters
	bit 4,e			; $5500
	jr z,@nextCharacter	; $5502
	ret			; $5504
+
	; Control code
	call _handleTextControlCode		; $5505

	; Stop at a newline or end of text
	ld a,(w7TextStatus)		; $5508
	cp $02			; $550b
	jr nc,@nextCharacter	; $550d
	ret			; $550f

;;
; When dealing with control codes, we only need to know how much space each one
; takes up. The actual contents of the text aren't important here.
; The point of this function is just to increment e by how many characters
; there are.
; @param a Control code
; @addr{5510}
@controlCode:
	sub $02			; $5510
	ld b,a			; $5512
	push hl			; $5513
	rst_jumpTable			; $5514
.dw @dictionary
.dw @dictionary
.dw @dictionary
.dw @dictionary
.dw @controlCode6
.dw @controlCode7
.dw @controlCode8
.dw @controlCodeNil
.dw @controlCodeA
.dw @controlCodeNil
.dw @controlCodeNil
.dw @controlCodeNil
.dw @controlCodeNil
.dw @controlCodeF

;;
; @addr{5531}
@dictionary:
	pop hl			; $5531
	call _readByteFromW7ActiveBankAndIncHl		; $5532
	ld (wTextIndexL),a		; $5535
	call _pushToTextStack		; $5538
	ld a,b			; $553b
	ld (wTextIndexH),a		; $553c
	jp _getTextAddress		; $553f

;;
; Symbol
; @addr{5542}
@controlCode6:
	inc e			; $5542
@controlCodeNil:
	pop hl			; $5543
	jp _incHlAndUpdateBank		; $5544

;;
; Jump to another text index
; @addr{5547}
@controlCode7:
	pop hl			; $5547
	call _readByteFromW7ActiveBankAndIncHl		; $5548
	ld (wTextIndexL),a		; $554b
	jp _checkInitialTextCommands		; $554e

;;
; Link name, kid name, or secret
; @addr{5551}
@controlCodeA:
	pop hl			; $5551
	call _readByteFromW7ActiveBankAndIncHl		; $5552
	push hl			; $5555
	ld hl,_nameAddressTable		; $5556
	rst_addDoubleIndex			; $5559
	ldi a,(hl)		; $555a
	ld h,(hl)		; $555b
	ld l,a			; $555c
--
	ldi a,(hl)		; $555d
	or a			; $555e
	jr z,+			; $555f

	inc e			; $5561
	jr --			; $5562
+
@controlCode8:
	pop hl			; $5564
	ret			; $5565

;;
; Call another text index
; @addr{5566}
@controlCodeF:
	pop hl			; $5566
	call _readByteFromW7ActiveBankAndIncHl		; $5567
	cp $fc			; $556a
	jr c,++			; $556c

	push hl			; $556e
	cpl			; $556f
	ld hl,wTextSubstitutions		; $5570
	rst_addAToHl			; $5573
	ld a,(hl)		; $5574
	pop hl			; $5575
++
	ld (wTextIndexL),a		; $5576
	call _pushToTextStack		; $5579
	jp _checkInitialTextCommands		; $557c

;;
; Shift w7TextGfxBuffer such that each tile is moved one position to the left.
; @param[out] hl Text address
; @addr{557f}
_shiftTextGfxBufferLeft:
	ld hl,w7TextGfxBuffer		; $557f
	ld de,w7TextGfxBuffer+$20		; $5582
	ld bc,$01e0		; $5585
--
	ld a,(de)		; $5588
	ldi (hl),a		; $5589
	inc de			; $558a
	dec bc			; $558b
	ld a,c			; $558c
	or b			; $558d
	jr nz,--		; $558e

	ld hl,w7TextAddressL		; $5590
	ldi a,(hl)		; $5593
	ld h,(hl)		; $5594
	ld l,a			; $5595
	ret			; $5596

;;
; @addr{5597}
_decInvTextScrollTimer:
	ld h,d			; $5597
	ld l,<w7InvTextScrollTimer		; $5598
	dec (hl)		; $559a
	ret nz			; $559b

	ld (hl),$08		; $559c
	xor a			; $559e
	ret			; $559f

;;
; Sets z flag if $06 is passed (command to read a trade item or symbol
; graphic). I think the reasoning is that the z flag is set when an actual
; character is drawn, since most control codes don't draw characters.
; @addr{55a0}
_handleTextControlCodeWithSpecialCase:
	cp $06			; $55a0
	jr z,@cmd6		; $55a2

	call _handleTextControlCode		; $55a4
	or d			; $55a7
	ret			; $55a8

	; Control code 6: trade item or symbol
@cmd6:
	ld bc,w7TextGfxBuffer+$1e0		; $55a9
	ld de,$d5e0		; $55ac
	call _handleTextControlCode		; $55af
	xor a			; $55b2
	ret			; $55b3

;;
; Updates w7SelectedTextPosition based on w7SelectedTextOption, and draws the
; cursor to that position in w7TextboxMap.
; @addr{55b4}
_updateSelectedTextPosition:
	call _getSelectedTextOptionAddress		; $55b4
	bit 5,(hl)		; $55b7
	ld b,$60		; $55b9
	jr nz,+			; $55bb
	ld b,$20		; $55bd
+
	ld a,(hl)		; $55bf

	; de = w7SelectedTextPosition
	inc e			; $55c0
	ld (de),a		; $55c1

	call _getAddressInTextboxMap		; $55c2
	ld (hl),$04		; $55c5
	ret			; $55c7

;;
; @param[out] hl The address in w7TextboxOptionPositions for the current
; selected option.
; @addr{55c8}
_getSelectedTextOptionAddress:
	ld e,<w7SelectedTextOption		; $55c8
	ld a,(de)		; $55ca
	add <w7TextboxOptionPositions		; $55cb
	ld l,a			; $55cd
	ld h,d			; $55ce
	ret			; $55cf

;;
; @param a Value from w7TextboxOptionPositions
; @param b Offset to start of row ($20 for top row, $60 for bottom)
; @param[out] hl Pointer to somewhere in w7TextboxMap
; @addr{55d0}
_getAddressInTextboxMap:
	and $1e			; $55d0
	rrca			; $55d2
	ld l,a			; $55d3
	ld e,<w7d0cc		; $55d4
	ld a,(de)		; $55d6

	; Text starts 2 tiles from the leftmost edge
	add $02			; $55d7

	add l			; $55d9
	and $1f			; $55da
	add b			; $55dc
	ld l,a			; $55dd
	ld h,>w7TextboxMap		; $55de
	ret			; $55e0

;;
; @addr{55e1}
_removeCursorFromSelectedTextPosition:
	ld b,$60		; $55e1
	ld e,<w7SelectedTextPosition		; $55e3
	ld a,(de)		; $55e5
	ld c,a			; $55e6
	bit 5,a			; $55e7
	jr nz,+			; $55e9
	ld b,$20		; $55eb
+
	call _getAddressInTextboxMap		; $55ed
	ld (hl),c		; $55f0
	ret			; $55f1

;;
; @addr{55f2}
_moveSelectedTextOptionRight:
	ld e,<w7SelectedTextOption		; $55f2
	ld a,(de)		; $55f4
	inc a			; $55f5
	and $07			; $55f6
	ld (de),a		; $55f8
	call _getSelectedTextOptionAddress		; $55f9
	ld a,(hl)		; $55fc
	or a			; $55fd
	ret nz			; $55fe

	xor a			; $55ff
	ld (de),a		; $5600
	ret			; $5601

;;
; @addr{5602}
_moveSelectedTextOptionLeft:
	ld e,<w7SelectedTextOption		; $5602
	ld a,(de)		; $5604
	dec a			; $5605
	and $07			; $5606
	ld (de),a		; $5608
	call _getSelectedTextOptionAddress		; $5609
	ld a,(hl)		; $560c
	or a			; $560d
	ret nz			; $560e
	jr _moveSelectedTextOptionLeft		; $560f

;;
; @addr{5611}
_textOptionCode_checkDirectionButtons:
	ld a,(wKeysJustPressed)		; $5611
	and BTN_UP|BTN_DOWN|BTN_LEFT|BTN_RIGHT			; $5614
	ret z			; $5616

	ld a,SND_MENU_MOVE		; $5617
	call playSound		; $5619
	call _removeCursorFromSelectedTextPosition		; $561c
	call @updateSelectedTextOption		; $561f
	jr _updateSelectedTextPositionAndDmaTextboxMap		; $5622

;;
; Updates w7SelectedTextOption depending on the input.
; @addr{5624}
@updateSelectedTextOption:
	ld a,(wKeysJustPressed)		; $5624
	call getHighestSetBit		; $5627
	sub $04			; $562a

	; Right
	jr z,_moveSelectedTextOptionRight	; $562c

	; Left
	dec a			; $562e
	jr z,_moveSelectedTextOptionLeft	; $562f

	; Up or down

	call _getSelectedTextOptionAddress		; $5631
	ld b,(hl)		; $5634
	ld c,$ff		; $5635
	ld l,<w7TextboxOptionPositions		; $5637
	ld e,l			; $5639
---
	ld a,(hl)		; $563a
	or a			; $563b
	jr z,@end		; $563c

	sub b			; $563e
	jr nc,+			; $563f
	cpl			; $5641
	inc a			; $5642
+
	sub $20			; $5643
	jr nc,+			; $5645
	cpl			; $5647
	inc a			; $5648
+
	cp c			; $5649
	jr nc,+			; $564a
	ld c,a			; $564c
	ld e,l			; $564d
+
	inc l			; $564e
	jr ---			; $564f

@end:
	ld a,c			; $5651
	cp $10			; $5652
	ret nc			; $5654

	ld a,e			; $5655
	sub <w7TextboxOptionPositions			; $5656
	ld e,<w7SelectedTextOption		; $5658
	ld (de),a		; $565a
	ret			; $565b

;;
; @addr{565c}
_updateSelectedTextPositionAndDmaTextboxMap:
	call _updateSelectedTextPosition		; $565c
	jp _dmaTextboxMap		; $565f

;;
; When the B button is pressed, move the cursor to the last option.
; Unsets zero flag if B is pressed.
; @param a Buttons pressed
; @addr{5662}
_textOptionCode_checkBButton:
	and BTN_B			; $5662
	ret z			; $5664

	; Find last option
	ld h,d			; $5665
	ld l,<w7TextboxOptionPositions		; $5666
-
	ldi a,(hl)		; $5668
	or a			; $5669
	jr nz,-			; $566a

	ld a,l			; $566c
	sub <w7TextboxOptionPositions+2		; $566d
	ld l,<w7SelectedTextOption		; $566f
	ld (hl),a		; $5671

	ld a,SND_MENU_MOVE	; $5672
	call playSound		; $5674
	call _removeCursorFromSelectedTextPosition		; $5677
	call _updateSelectedTextPositionAndDmaTextboxMap		; $567a
	or d			; $567d
	ret			; $567e

;;
; Save the current address of text being read.
; @param hl Current address of text
; @addr{567f}
_pushToTextStack:
	push de			; $567f
	push bc			; $5680
	push hl			; $5681
	ld hl,w7TextStack+$1b		; $5682
	ld de,w7TextStack+$1f		; $5685
	ld b,$1c		; $5688
-
	ldd a,(hl)		; $568a
	ld (de),a		; $568b
	dec e			; $568c
	dec b			; $568d
	jr nz,-		; $568e

	; hl = w7TextStack
	inc l			; $5690

	ld de,w7ActiveBank		; $5691
	ld a,(de)		; $5694
	ldi (hl),a		; $5695
	pop de			; $5696
	ld (hl),e		; $5697
	inc l			; $5698
	ld (hl),d		; $5699
	inc l			; $569a
	ld a,(wTextIndexH)		; $569b
	ld (hl),a		; $569e
	ld h,d			; $569f
	ld l,e			; $56a0
	pop bc			; $56a1
	pop de			; $56a2
	ret			; $56a3

;;
; @addr{56a4}
_popFromTextStack:
	push de			; $56a4
	push bc			; $56a5
	ld hl,w7TextStack+3		; $56a6
	ldd a,(hl)		; $56a9
	ld (wTextIndexH),a		; $56aa
	ldd a,(hl)		; $56ad
	ld de,w7TextAddressH		; $56ae
	ld (de),a		; $56b1
	ld b,a			; $56b2
	ldd a,(hl)		; $56b3
	dec e			; $56b4
	ld (de),a		; $56b5
	ld c,a			; $56b6
	ld a,(hl)		; $56b7
	dec e			; $56b8
	ld (de),a		; $56b9
	push bc			; $56ba
	ld de,w7TextStack+4		; $56bb
	ld b,$1c		; $56be
-
	ld a,(de)		; $56c0
	ldi (hl),a		; $56c1
	inc e			; $56c2
	dec b			; $56c3
	jr nz,-			; $56c4

	xor a			; $56c6
	ldi (hl),a		; $56c7
	ldi (hl),a		; $56c8
	ldi (hl),a		; $56c9
	ld (hl),a		; $56ca
	pop hl			; $56cb
	pop bc			; $56cc
	pop de			; $56cd
	ret			; $56ce

;;
; @addr{56cf}
_readByteFromW7ActiveBankAndIncHl:
	call readByteFromW7ActiveBank		; $56cf

;;
; @addr{56d2}
_incHlAndUpdateBank:
	inc l			; $56d2
	ret nz			; $56d3

	inc h			; $56d4
	bit 7,h			; $56d5
	ret z			; $56d7

	rrc h			; $56d8
	push af			; $56da
	ld a,(w7ActiveBank)		; $56db
	inc a			; $56de
	ld (w7ActiveBank),a		; $56df
	pop af			; $56e2
	ret			; $56e3

;;
; Handle control codes for text (any value under $10)
; @param a Control code
; @addr{56e4}
_handleTextControlCode:
	push bc			; $56e4
	push hl			; $56e5
	rst_jumpTable			; $56e6
.dw @controlCode0
.dw @controlCode1
.dw @controlCode2
.dw @controlCode3
.dw @controlCode4
.dw @controlCode5
.dw @controlCode6
.dw @controlCode7
.dw @controlCode8
.dw @controlCode9
.dw @controlCodeA
.dw @controlCodeB
.dw @controlCodeC
.dw @controlCodeD
.dw @controlCodeE
.dw @controlCodeF

; Unused?
@blankCode:
	pop hl			; $5707
	pop bc			; $5708
	ret			; $5709

;;
; Null terminator; end of text
; @addr{570a}
@controlCode0:
	pop hl			; $570a
	pop bc			; $570b
	call _popFromTextStack		; $570c
	ld a,h			; $570f
	or a			; $5710
	ret nz			; $5711

	; If $00 was popped from the text stack, we've reached the end
	ld (w7TextStatus),a		; $5712
	ret			; $5715

;;
; Newline character
; @addr{5716}
@controlCode1:
	pop hl			; $5716
	pop bc			; $5717
	ld a,$01		; $5718
	ld (w7TextStatus),a		; $571a
	ret			; $571d

;;
; Special character - japanese kanji or trade item symbol.
; If bit 7 of the parameter is set, it reads a trade item from
; gfx_font_tradeitems.
; Otherwise, it reads a kanji from gfx_font_jp. This file also contains the
; triangle symbol which is used sometimes in the english version.
; @addr{571e}
@controlCode6:
	pop hl			; $571e
	call _readByteFromW7ActiveBankAndIncHl		; $571f
	ld b,a			; $5722
	cp $80			; $5723
	jr c,@kanji		; $5725

@tradeItem:
	ld a,(wTextGfxColorIndex)		; $5727
	swap a			; $572a
	or $03			; $572c
	ld (wTextGfxColorIndex),a		; $572e
	ld a,$02		; $5731
	ld (w7TextGfxSource),a		; $5733
	ld a,b			; $5736
	sub $80			; $5737
	add a			; $5739
	jr ++			; $573a

@kanji:
	ld a,$01		; $573c
	ld (w7TextGfxSource),a		; $573e
	ld a,b			; $5741
++
	pop bc			; $5742
	push af			; $5743
	ld a,$06		; $5744
	call _setLineTextBuffers		; $5746
	pop af			; $5749
	jp retrieveTextCharacter		; $574a

;;
; Dictionary 0
; @addr{574d}
@controlCode2:
	xor a			; $574d
	jr ++			; $574e

;;
; Dictionary 1
; @addr{5750}
@controlCode3:
	ld a,$01		; $5750
	jr ++			; $5752

;;
; Dictionary 2
; @addr{5754}
@controlCode4:
	ld a,$02		; $5754
	jr ++			; $5756

;;
; Dictionary 3
; @addr{5758}
@controlCode5:
	ld a,$03		; $5758
++
	ldh (<hFF8B),a	; $575a
	pop hl			; $575c
	call _readByteFromW7ActiveBankAndIncHl		; $575d
	ld (wTextIndexL),a		; $5760
	call _pushToTextStack		; $5763
	ldh a,(<hFF8B)	; $5766
	ld (wTextIndexH),a		; $5768
	call _getTextAddress		; $576b
	jr @popBcAndRet		; $576e

;;
; "Call" another piece of text; insert that text, then go back to reading the
; current text.
; @addr{5770}
@controlCodeF:
	pop hl			; $5770
	call _readByteFromW7ActiveBankAndIncHl		; $5771
	cp $fc			; $5774
	jr c,+			; $5776

	push hl			; $5778
	cpl			; $5779
	ld hl,wTextSubstitutions		; $577a
	rst_addAToHl			; $577d
	ld a,(hl)		; $577e
	pop hl			; $577f
+
	ld (wTextIndexL),a		; $5780
	ld a,(wTextIndexH_backup)		; $5783
	ld (wTextIndexH),a		; $5786
	call _pushToTextStack		; $5789
	call _checkInitialTextCommands		; $578c
	jr @popBcAndRet		; $578f

;;
; "Jump" to a different text index
; @addr{5791}
@controlCode7:
	pop hl			; $5791
	call _readByteFromW7ActiveBankAndIncHl		; $5792
	ld (wTextIndexL),a		; $5795
	call _checkInitialTextCommands		; $5798
	jr @popBcAndRet		; $579b

;;
; This tells the game to stop displaying the text, and to show a different
; textbox when this one is closed. Used in shops to show various messages
; depending whether you can hold or can afford a particular item.
; This command actually takes a parameter, but it's not read here.
; @addr{579d}
@controlCode8:
	; Show another textbox later
	ld a,(w7d0c1)		; $579d
	or $10			; $57a0
	ld (w7d0c1),a		; $57a2

	; End this text
	xor a			; $57a5
	ld (w7TextStatus),a		; $57a6

	pop hl			; $57a9
	jr @popBcAndRet		; $57aa

;;
; Change text color or set the attribute byte.
; If the parameter has bit 7 set, it is written directly to w7TextAttribute.
; Otherwise, the parameter is used as an index for a table of preset values.
; @addr{57ac}
@controlCode9:
	pop hl			; $57ac

	; Check TEXTBOXFLAG_NOCOLORS
	ld a,(wTextboxFlags)		; $57ad
	rrca			; $57b0
	jr c,@@noColors		; $57b1

	call _readByteFromW7ActiveBankAndIncHl		; $57b3
	bit 7,a			; $57b6
	jr nz,+			; $57b8

	ld bc,@textColorData	; $57ba
	call addDoubleIndexToBc		; $57bd
	ld a,(bc)		; $57c0
	ld (w7TextAttribute),a		; $57c1
	inc bc			; $57c4
	ld a,(bc)		; $57c5
	ld (wTextGfxColorIndex),a		; $57c6
	pop bc			; $57c9
	ret			; $57ca
+
	ld (w7TextAttribute),a		; $57cb
	jr @popBcAndRet		; $57ce

@@noColors:
	call _incHlAndUpdateBank		; $57d0

@popBcAndRet:
	pop bc			; $57d3
	ret			; $57d4

; b0: attribute byte (which palette to use)
; b1: Value for wTextGfxColorIndex
; @addr{57d5}
@textColorData:
	.db $80 $02
	.db $80 $01
	.db $81 $00
	.db $81 $01
	.db $81 $02

;;
; Link or kid name
; @addr{57df}
@controlCodeA:
	pop hl			; $57df
	pop bc			; $57e0
	call _readByteFromW7ActiveBankAndIncHl		; $57e1
	push hl			; $57e4
	ld hl,_nameAddressTable		; $57e5
	rst_addDoubleIndex			; $57e8
	ldi a,(hl)		; $57e9
	ld h,(hl)		; $57ea
	ld l,a			; $57eb
--
	ldi a,(hl)		; $57ec
	or a			; $57ed
	jr z,+			; $57ee

	call _setLineTextBuffers		; $57f0
	call retrieveTextCharacter		; $57f3
	jr --			; $57f6
+
	pop hl			; $57f8
	ret			; $57f9

;;
; Play a sound effect
; @addr{57fa}
@controlCodeE:
	pop hl			; $57fa
	call _readByteFromW7ActiveBankAndIncHl		; $57fb
	ld (w7SoundEffect),a		; $57fe
	jr @popBcAndRet		; $5801

; Unused?
	pop hl			; $5803
	call _readByteFromW7ActiveBankAndIncHl		; $5804
	ld b,a			; $5807
	call @@func2		; $5808
	call @@func1		; $580b
	jr @popBcAndRet		; $580e

@@func1:
	push de			; $5810
	ld a,e			; $5811
	add $50			; $5812
	ld e,a			; $5814
	ld a,(de)		; $5815
	or $01			; $5816
	ld (de),a		; $5818
	pop de			; $5819
	ret			; $581a

@@func2:
	push de			; $581b
	ld a,e			; $581c
	add $20			; $581d
	ld e,a			; $581f
	ld a,b			; $5820
	ld (de),a		; $5821
	pop de			; $5822
	ret			; $5823

;;
; Set the sound that's made when each character is displayed
; @addr{5824}
@controlCodeB:
	pop hl			; $5824
	call _readByteFromW7ActiveBankAndIncHl		; $5825
	ld (w7TextSound),a		; $5828
	jr @popBcAndRet		; $582b

;;
; Set the number of frames until the textbox closes itself.
; @addr{582d}
@controlCodeD:
	pop hl			; $582d
	call _readByteFromW7ActiveBankAndIncHl		; $582e
	ld (w7TextboxTimer),a		; $5831
	jr @popBcAndRet		; $5834

;;
; Parameter:
;  Bits 0-1: Loaded into c
;  Bits 3-7: Action to perform. Values of 0-7 are valid.
; @addr{5836}
@controlCodeC:
	pop hl			; $5836
	call _readByteFromW7ActiveBankAndIncHl		; $5837
	push hl			; $583a
	ld b,a			; $583b
	and $03			; $583c
	ld c,a			; $583e
	ld a,b			; $583f
	swap a			; $5840
	rlca			; $5842
	and $1f			; $5843
	rst_jumpTable			; $5845
.dw _textControlCodeC_0
.dw _textControlCodeC_1
.dw _textControlCodeC_2
.dw _textControlCodeC_3
.dw _textControlCodeC_ret ; $04 is dealt with in _checkInitialTextCommands.
.dw _textControlCodeC_5
.dw _textControlCodeC_6
.dw _textControlCodeC_7

;;
; Gets the number of frames each character is displayed for, based on
; wTextSpeed.
; @param[out] a Frames per character
; @addr{5856}
_getCharacterDisplayLength:
	push hl			; $5856
	ld a,(wTextSpeed)		; $5857
	swap a			; $585a
	rrca			; $585c
	ld hl,_textSpeedData+2	; $585d
	rst_addAToHl			; $5860
	ld a,(hl)		; $5861
	pop hl			; $5862
	ret			; $5863

;;
; Sets the speed of the text. Value of $02 for c sets it to normal, lower
; values are faster, higher ones are slower.
; @addr{5864}
_textControlCodeC_0:
	ld a,(wTextSpeed)		; $5864
	swap a			; $5867
	rrca			; $5869
	add c			; $586a
	ld hl,_textSpeedData	; $586b
	rst_addAToHl			; $586e
	ld a,(hl)		; $586f
	ld (w7CharacterDisplayLength),a		; $5870
	jr _textControlCodeC_ret		; $5873

; This is the structure which controls the values for each text speed. I don't
; know why there are 8 bytes per text speed, but the 3rd byte of each appears
; to be the only important one.
; @addr{5875}
_textSpeedData:
	.db $04 $05 $07 $08 $0a $0c $0e $0f ; Text speed 1
	.db $03 $04 $05 $07 $08 $0a $0b $0c ; Text speed 2
	.db $02 $03 $04 $05 $06 $08 $08 $0a ; 3
	.db $02 $02 $03 $03 $04 $06 $06 $08 ; 4
	.db $01 $01 $02 $02 $03 $03 $04 $05 ; 5
;;
; Slow down the text. Used for essences.
; @addr{589d}
_textControlCodeC_7:
	ld a,$78		; $589d
	ld (w7TextSlowdownTimer),a		; $589f
	jr _textControlCodeC_ret		; $58a2

;;
; Show the piece of heart icon.
; @addr{58a4}
_textControlCodeC_5:
	ld hl,w7d0c1		; $58a4
	set 5,(hl)		; $58a7

;;
; Stop text here, clear textbox on next button press.
; @addr{58a9}
_textControlCodeC_3:
	ld hl,w7d0c1		; $58a9
	set 1,(hl)		; $58ac

;;
; @addr{58ae}
_textControlCodeC_ret:
	pop hl			; $58ae
	pop bc			; $58af
	ret			; $58b0

;;
; Unused?
; @addr{58b1}
_textControlCodeC_6:
	ld a,($cbab)		; $58b1
	ld (wTextNumberSubstitution+1),a		; $58b4
	ld a,($cbaa)		; $58b7
	ld (wTextNumberSubstitution),a		; $58ba

;;
; Display a number of up to 3 digits. Usually bcd format.
; @addr{58bd}
_textControlCodeC_1:
	pop hl			; $58bd
	pop bc			; $58be

	; Hundreds digit
	ld a,(wTextNumberSubstitution+1)		; $58bf
	or a			; $58c2
	jr z,+			; $58c3

	call @drawDigit		; $58c5

	; Tens digit
	ld a,(wTextNumberSubstitution)		; $58c8
	and $f0			; $58cb
	jr ++			; $58cd
+
	ld a,(wTextNumberSubstitution)		; $58cf
	and $f0			; $58d2
	jr z,+++		; $58d4
++
	swap a			; $58d6
	call @drawDigit		; $58d8
+++
	; Ones digit
	ld a,(wTextNumberSubstitution)		; $58db
	and $0f			; $58de

@drawDigit:
	add $30			; $58e0
	call _setLineTextBuffers		; $58e2
	jp retrieveTextCharacter		; $58e5

;;
; An option is presented, ie. yes/no. This command marks a possible position
; for the cursor.
; @addr{58e8}
_textControlCodeC_2:
	call @getNextTextboxOptionPosition		; $58e8
	ld a,(w7d0c1)		; $58eb
	or $04			; $58ee
	ld (w7d0c1),a		; $58f0

	; e is the position in the line
	ld a,e			; $58f3
	; Multiply by 2 since each character is 2 bytes
	add a			; $58f4
	; w7TextboxMap+$60 is the start of the bottom row
	or $60			; $58f5

	ld b,a			; $58f7
	inc b			; $58f8
	ld (hl),b		; $58f9
	pop hl			; $58fa
	pop bc			; $58fb

	; Reserve this spot for the cursor
	ld a,$20		; $58fc
	call _setLineTextBuffers		; $58fe
	jp retrieveTextCharacter		; $5901

;;
; @addr{5904}
@getNextTextboxOptionPosition:
	ld hl,w7TextboxOptionPositions		; $5904
-
	ld a,(hl)		; $5907
	or a			; $5908
	ret z			; $5909

	inc l			; $590a
	jr -			; $590b

; @addr{590d}
_nameAddressTable:
	.dw wLinkName wKidName
	.dw w7SecretText1 w7SecretText2

; This data structure works with text command $08. When buying something from
; a shop, it checks the given variable ($cbad) and displays one of these pieces
; of text depending on the value.
;
; @addr{5915}
.ifdef ROM_AGES
_extraTextIndices:
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw @index0d
	.dw @index0e
	.dw @index0f
	.dw $0000
	.dw @index11

; Potion in Syrup's hut
@index0d:
	.dw $cbad
	.db <TX_0d02 <TX_0d08 <TX_0d04 <TX_0d03

; Gasha seed in Syrup's hut
@index0e:
	.dw $cbad
	.db <TX_0d06 <TX_0d08 <TX_0d07 <TX_0d03

; Ring box upgrade in upstairs Lynna shop
@index0f:
	.dw $cbad
	.db $ff <TX_0e06 <TX_0e05 $ff

; Bombchus in Syrup's hut
@index11:
	.dw $cbad
	.db <TX_0d0c <TX_0d08 <TX_0d07 <TX_0d03
.else
_extraTextIndices:
	.dw @index00
	.dw @index01
	.dw @index02
	.dw @index03
	.dw @index04
	.dw @index05
	.dw @index06
	.dw @index07
	.dw @index08
	.dw @index09
	.dw @index0a
	.dw @index0b
	.dw @index0c
	.dw @index0d
	.dw @index0e
	.dw @index0f
	.dw @index10
	.dw @index11
; TODO: get the correct text id for these
@index00:
	.dw $cba5
	.db $02 $03
@index01:
	.dw $cba5
	.db $09 $05
@index02:
	.dw $cba5
	.db $14 $16
@index03:
	.dw $cba5
	.db $1c $1e
@index04:
	.dw $cba5
	.db $21 $25
@index05:
	.dw $cba5
	.db $28 $2a
@index06:
	.dw $cba5
	.db $2d $2f
@index07:
	.dw $cba5
	.db $33 $37
@index08:
	.dw $cba5
	.db $3b $3c
@index09:
	.dw $cba5
	.db $40 $42
@index0a:
	.dw $cba5
	.db $45 $47
@index0b:
	.dw $cba5
	.db $4a $4c
@index0c:
	.dw $cba5
	.db $50 $ff

; Potion in Syrup's hut
@index0d:
	.dw $cbad
	.db <TX_0d02 <TX_0d08 <TX_0d04 <TX_0d03

; Gasha seed in Syrup's hut
@index0e:
	.dw $cbad
	.db <TX_0d06 <TX_0d08 <TX_0d07 <TX_0d03

; TODO: ???
@index0f:
	.dw $cbad
	.db $ff <TX_0e06 <TX_0e05 $ff

@index10:
	; corrupted version of index00?
	.db <$cba5
	.db $02 $03

; Bombchus in Syrup's hut
@index11:
	.dw $cbad
	.db <TX_0d0c <TX_0d08 <TX_0d07 <TX_0d03
.endif
