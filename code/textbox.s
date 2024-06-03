;;
; Called once as a textbox is about to be shown.
initTextbox:
	ld a,(wTextboxFlags)
	bit TEXTBOXFLAG_BIT_DONTCHECKPOSITION,a
	jr nz,++

	; Decide whether to put the textbox at the top or bottom
	ldh a,(<hCameraY)
	ld b,a
	ld a,(w1Link.yh)
	sub b
	cp $48
	ld a,$02
	jr c,+
	xor a
+
	ld (wTextboxPosition),a
++
	ld a,$07
	ld ($ff00+R_SVBK),a
	ld hl,$d000
	ld bc,w7TextVariablesEnd - $d000
	call clearMemoryBc
	jp initTextboxStuff

;;
; Called every frame while a textbox is being shown.
updateTextbox:
	ld a,$07
	ld ($ff00+R_SVBK),a
	ld d,>w7TextDisplayState
	ld a,(wTextIsActive)
	inc a
	jr nz,+

	; If [wTextIsActive] == 0xff...
	ld (wTextDisplayMode),a
	ld h,d
	ld l,<w7TextDisplayState
	ld (hl),$0f
	inc l
	set 3,(hl)
+
	call @updateText

	; Stop everything if [wTextIsActive] == 0
	ld a,(wTextIsActive)
	or a
	ret nz

	ld (wTextboxFlags),a
	jp stubThreadStart

;;
@updateText:
	ld a,(wTextIsActive)
	cp $80
	ret z

	ld e,<w7TextDisplayState
	ld a,(wTextDisplayMode)
	rst_jumpTable
	.dw @standardText
	.dw @textOption
	.dw @inventoryText

;;
@standardText:
	ld a,(de)
	rst_jumpTable
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
@textOption:
	ld a,(de)
	rst_jumpTable
	.dw textOptionCode@state00
	.dw textOptionCode@state01
	.dw textOptionCode@state02
	.dw textOptionCode@state03
	.dw textOptionCode@state04

;;
@inventoryText:
	ld a,(de)
	rst_jumpTable
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
@standardTextState0:
	ld a,$01
	ld (de),a
	call saveTilesUnderTextbox
	call initTextboxMapping
	jp dmaTextboxMap

;;
; Prepare to draw the top line.
@standardTextState1:
	ld h,d
	ld l,<w7TextDisplayState
	inc (hl)
	ld l,<w7d0d3
	ld (hl),$40
	ld l,<w7CharacterDisplayLength
	ldi a,(hl)
	ld (hl),a
	call drawLineOfText
	jp dmaTextGfxBuffer

;;
; Displaying a row of characters
; State 2: top row
; State 4: bottom row
; State A: bottom row, next row will come up automatically
@standardTextState2:
@standardTextState4:
@standardTextStatea:
	call getNextCharacterToDisplay
	jr z,+

	call updateCharacterDisplayTimer
	ret nz

	call displayNextTextCharacter
	call dmaTextboxMap
	ld d,>w7TextStatus
	call getNextCharacterToDisplay
	ret nz
+
	call func_53eb
	ret nz

	ld d,>w7TextStatus
	call func_5296
	ret nz

	ld h,d
	ld l,<w7TextStatus
	ld a,(hl)
	or a
	ld l,<w7TextDisplayState
	jr z,@textFinished

	inc (hl)
	ld l,<w7CharacterDisplayLength
	ldi a,(hl)
	ld (hl),a
	ret

@textFinished:
	ld (hl),$0f
	ret

;;
; Preparing to draw the bottom line
@standardTextState3:
@standardTextState9:
	call updateCharacterDisplayTimer
	ret nz

	call drawLineOfText
	ld a,$02
	call dmaTextGfxBuffer
	ld hl,w7TextDisplayState
	inc (hl)
	ld l,<w7d0d3
	ld (hl),$60
	ld l,<w7CharacterDisplayLength
	ldi a,(hl)
	ld (hl),a
	ret

;;
; Waiting for input to display the next 2 rows of characters
@standardTextState5:
	ld a,(wKeysJustPressed)
	and BTN_A | BTN_B
	jp z,updateTextboxArrow

	ld a,SND_TEXT_2
	call playSound
	ld h,d
	ld l,<w7d0c1
	res 0,(hl)
	jr @standardTextStateb

;;
; Doesn't really do anything
@standardTextState6:
@standardTextStatec:
	; Go to state $07/0d
	ld h,d
	ld l,e
	inc (hl)

	jp dmaTextboxMap

;;
; Shifts the text up one tile.
@standardTextState7:
@standardTextStated:
	; Go to state $08/0e
	ld h,d
	ld l,e
	inc (hl)

	call shiftTextboxMapUp
	jp subFirstRowOfTextMapBy20

;;
; The first of the next 2 lines of text is about to come up.
@standardTextState8:
	; Go to state $09
	ld h,d
	ld l,e
	inc (hl)

	ld l,<w7CharacterDisplayLength
	ldi a,(hl)
	ld (hl),a

	; Redraw the previous line of text to the top line.

	call dmaTextboxMap
	xor a
	jp dmaTextGfxBuffer

;;
; A new line has just been drawn after scrolling text up. Another line of text
; still needs to scroll up.
@standardTextStateb:
	; Go to state $0c
	ld h,d
	ld l,e
	inc (hl)

	; Get the position of the red arrow, remove it
	ld l,<w7d0cc
	ld a,(hl)
	add $12
	and $1f
	add <w7TextboxMap+$80
	ld l,a
	ld h,>w7TextboxMap
	ld (hl),$02

	call shiftTextboxMapUp
	jp clearTopRowOfTextMap

;;
; The second new line is ready to be shown.
@standardTextStatee:
	; Go to state $03
	ld h,d
	ld l,e
	ld (hl),$03

	ld l,<w7CharacterDisplayLength
	ldi a,(hl)
	ld (hl),a

	call dmaTextboxMap
	xor a
	jp dmaTextGfxBuffer

;;
@standardTextStatef:
	ld h,d
	ld l,<w7d0ef
	bit 7,(hl)
	jr z,@label_3f_096

	ld a,(wKeysJustPressed)
	and BTN_A | BTN_B
	ret z

	ld (hl),$00
	ld l,e
	ld (hl),$00

	; You got 4 pieces of heart. That's 1 heart container
.ifdef ROM_AGES
	ld a,<TX_0049
	ld (wTextIndexL),a
	ld a,>TX_0049
.else
	ld a,<TX_0024
	ld (wTextIndexL),a
	ld a,>TX_0024
.endif

	add $04
	ld (wTextIndexH),a
	call checkInitialTextCommands
	ld a,SND_FILLED_HEART_CONTAINER
	call playSound
	ld a,TREASURE_HEART_CONTAINER
	ld c,$04
	jp giveTreasure

@label_3f_096:
	ld l,<w7d0c1
	bit 3,(hl)
	jr nz,+

	call @checkShouldExit
	ret z
+
	ld l,e
	inc (hl)
	ld l,<w7d0ef
	bit 0,(hl)
	jr z,+

	ld a,TREASURE_HEART_REFILL
	ld c,$40
	call giveTreasure
+
	jp saveTilesUnderTextbox

;;
; Unsets zero flag if the textbox should be exited from (usually, player has
; pressed a button to exit the textbox).
@checkShouldExit:
	ld a,(wTextboxFlags)
	bit TEXTBOXFLAG_BIT_NONEXITABLE,a
	jr nz,@@nonExitable

	ld l,<w7TextboxTimer
	ld a,(hl)
	or a
	jr z,+

	dec (hl)
	jr z,@@end
+
	ld a,(wKeysJustPressed)
	or a
	ret

@@nonExitable:
	res TEXTBOXFLAG_BIT_NONEXITABLE,a
	ld (wTextboxFlags),a
	ld a,$80
	ld (wTextIsActive),a
@@end:
	or d
	ret

;;
; Closes the textbox
@standardTextState10:
	xor a
	ld (wTextIsActive),a
	jp dmaTextboxMap


textOptionCode:

; This code is for when you have a prompt, ie "yes/no".

;;
; Initialization
@state00:
	; hl = w7TextDisplayState (go to state $01)
	ld h,d
	ld l,e
	inc (hl)

	; Set the delay until the cursor appears
	ld a,(wTextSpeed)
	ld hl,@cursorDelay
	rst_addAToHl
	ld a,(hl)
	ld e,<w7CharacterDisplayTimer
	ld (de),a
	ret

; These are values determining how many frames until the cursor appears.
; Which value is used depends on wTextSpeed.
@cursorDelay:
	.db $20 $1c $18 $14 $10

;;
@state01:
	ld h,d
	ld l,<w7CharacterDisplayTimer
	dec (hl)
	ret nz

	; hl = w7TextDisplayState (go to state $02)
	ld l,e
	inc (hl)

	jp updateSelectedTextPositionAndDmaTextboxMap

;;
@state02:
	ld a,(wKeysJustPressed)
	and BTN_A | BTN_B
	jp z,textOptionCode_checkDirectionButtons

	call textOptionCode_checkBButton
	ret nz

	; A button pressed

	ld a,SND_SELECTITEM
	call playSound

	; Go to state 3
	ld hl,w7TextDisplayState
	inc (hl)

	ld l,<w7SelectedTextOption
	ld a,(hl)
	ld (wSelectedTextOption),a

	ld a,(wTextboxFlags)
	bit TEXTBOXFLAG_BIT_NONEXITABLE,a
	ret z

	res TEXTBOXFLAG_BIT_NONEXITABLE,a
	ld (wTextboxFlags),a
	ld a,$80
	ld (wTextIsActive),a
	ret

;;
@state03:
	; hl = w7TextDisplayState (go to state $04)
	ld h,d
	ld l,e
	inc (hl)

	; hl = w7d0c1
	inc l
	bit 4,(hl)
	jr z,+

	; If the textbox ended with command 8 / control code 8, do this special
	; behaviour

	push hl
	call readNextTextByte
	pop hl
	cp $ff
	jp z,+

	ld (wTextIndexL),a
	call checkInitialTextCommands
	jp func_53dd

+
	set 3,(hl)

	; hl = w7TextStatus
	inc l
	ld (hl),$00

	; Go to standard text mode, state $0f
	ld l,<w7TextDisplayState
	ld (hl),$0f
	ld a,$00
	ld (wTextDisplayMode),a
	ret

;;
@state04:
	ld a,$00
	ld (wTextDisplayMode),a
	ld h,d
	ld l,e
	ld (hl),$02 ; [w7TextDisplayState]
	inc l
	ld (hl),$00 ; [w7d0c1]
	ld l,<w7CharacterDisplayLength
	ldi a,(hl)
	ld (hl),a ; [w7CharacterDisplayTimer]
	ld l,<w7d0d3
	ld (hl),$40

	; Clear w7TextboxOptionPositions, w7SelectedTextOption, and w7SelectedTextPosition
	ld l,<w7TextboxOptionPositions
	ld b,$0a
	call clearMemory

	call drawLineOfText
	jp dmaTextGfxBuffer


inventoryTextCode:

;;
; Initialization
@state00:
	; hl = w7TextDisplayState (go to state $01)
	ld h,d
	ld l,e
	inc (hl)

	ld l,<w7TextIndexL_backup
	ld a,(wTextIndexL)
	ld (hl),a

	ld l,<w7InvTextScrollTimer
	ld (hl),$28

	ld l,<w7InvTextSpacesAfterName
	ld a,$ff
	ld (hl),a

	ld l,<w7TextStatus
	ld (hl),a

	call doInventoryTextFirstPass

	ld d,>w7TextAddress
	jr z,+

	ld e,<w7TextAddress
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld e,<w7InvTextSpacesAfterName
	ld a,(de)
	or a
	jr z,++

	inc a
	srl a
	ld (de),a
+
	ld e,<w7InvTextSpacesAfterName
	ld a,(de)
	inc a
	jr z,@@stopText
++
	ld e,<w7TextStatus
	ld a,(de)
	or a
	jr nz,@@end

@@stopText:
	ld (wTextIsActive),a

@@end:
	; Load the graphics from w7TextGfxBuffer
	ld a,UNCMP_GFXH_17
	jp loadUncompressedGfxHeader

;;
; Text is paused on the name of the item being viewed
@state01:
	call decInvTextScrollTimer
	ret nz

	; hl = w7InvTextScrollTimer
	ld (hl),$01

	; hl = w7TextDisplayState (go to state 2)
	ld l,e
	inc (hl)

	ld l,<w7TextStatus
	ld (hl),$ff
	ret

;;
; Text is scrolling and more remains to be read
@state02:
	call decInvTextScrollTimer
	ret nz

	call shiftTextGfxBufferLeft
--
	call readByteFromW7ActiveBankAndIncHl

	cp $10
	jr nc,@drawCharacter

	cp $01
	jr z,@drawSpace

	call handleTextControlCodeWithSpecialCase
	; Jump if it was command $06 (a special symbol)
	jr z,@saveTextAddressAndDmaTextGfxBuffer

	; Keep looping until an actual character is read, or the end of the
	; text is reached.
	ld a,(w7TextStatus)
	or a
	jr nz,--

	; End of text has been reached.

	ld a,l
	ld b,h

	ld hl,w7TextStatus
	ld (hl),$ff

	; Insert $10 blank spaces before looping to the start of the text.
	ld l,<w7InvTextSpaceCounter
	ld (hl),$10

	; Go to state $03
	ld l,<w7TextDisplayState
	inc (hl)

	ld l,<w7TextAddress
	ldi (hl),a
	ld (hl),b

@drawSpaceWithoutSavingTextAddress:
	ld a,$20
	ld bc,w7TextGfxBuffer+$1e0
	call retrieveTextCharacter
	jr @dmaTextGfxBuffer

;;
; Text is scrolling but all of it has been displayed
@state03:
	call decInvTextScrollTimer
	ret nz

	; hl = w7InvTextSpaceCounter
	inc l
	dec (hl)
	jr nz,@insertSpace

	; hl = w7TextDisplayState (go to state $04)
	ld l,e
	inc (hl)

	; Reload the text index?
	ld l,<w7TextIndexL_backup
	ld a,(hl)
	ld (wTextIndexL),a
	ld a,(wTextIndexH_backup)
	ld (wTextIndexH),a

	; This will get the start address of the text based on wTextIndexL/H.
	call checkInitialTextCommands

@insertSpace:
	call shiftTextGfxBufferLeft

@drawSpace:
	; $20 = character for space
	ld a,$20

@drawCharacter:
	ld bc,w7TextGfxBuffer+$1e0
	call retrieveTextCharacter

@saveTextAddressAndDmaTextGfxBuffer:
	ld a,l
	ld (w7TextAddress),a
	ld a,h
	ld (w7TextAddress+1),a

@dmaTextGfxBuffer:
	; Copy w7TextGfxBuffer to vram
	ld a,UNCMP_GFXH_17
	jp loadUncompressedGfxHeader

;;
; The name of the item is being read again.
@state04:
	call decInvTextScrollTimer
	ret nz

	call shiftTextGfxBufferLeft
---
	call readByteFromW7ActiveBankAndIncHl
	cp $10
	jr nc,@drawCharacter

	cp $01
	jr nz,++

	; Newline character

	ld a,l
	ld b,h
	ld hl,w7TextAddress
	ld l,<w7TextAddress
	ldi (hl),a
	ld (hl),b

	ld l,<w7InvTextSpacesAfterName
	ld a,(hl)
	ld l,<w7InvTextSpaceCounter
	ld (hl),a

	; Go to state $05
	ld l,<w7TextDisplayState
	inc (hl)

	or a
	jr nz,@drawSpaceWithoutSavingTextAddress

	; Go to state $06
	inc (hl)
	ret
++
	call handleTextControlCodeWithSpecialCase
	jr z,@saveTextAddressAndDmaTextGfxBuffer

	jr ---

;;
; The name of the item has been read, now it's scrolling to the middle.
@state05:
	call decInvTextScrollTimer
	ret nz

	; hl = w7InvTextSpaceCounter
	inc l
	dec (hl)
	jr nz,@insertSpace

	; hl = w7InvTextScrollTimer
	dec l
	ld (hl),$28

	; hl = w7TextDisplayState (go to state $01)
	ld l,e
	ld (hl),$01
	ret

;;
@state06:
	call decInvTextScrollTimer
	ret nz

	; hl = w7InvTextScrollTimer
	ld (hl),$28

	; hl = w7TextDisplayState (go to state $07)
	ld l,e
	inc (hl)
	ret

;;
@state07:
	call decInvTextScrollTimer
	ret nz

	; hl = w7InvTextScrollTimer
	ld (hl),$08

	; hl = w7TextDisplayState (go to state $02)
	ld l,e
	ld (hl),$02

	ld l,<w7TextStatus
	ld (hl),$ff

	ld l,<w7TextAddress
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp @drawSpace

;;
; Initializes text stuff, particularly position variables for the textbox.
initTextboxStuff:
	ld a,(wActiveLanguage)
	ld b,a
	add a
	add b
	ld hl,textTableTable
	rst_addAToHl
	ldi a,(hl)
	ld (w7TextTableAddr),a
	ldi a,(hl)
	ld (w7TextTableAddr+1),a
	ld a,(hl)
	ld (w7TextTableBank),a
	call checkInitialTextCommands

	ld hl,w7TextSound
	ld (hl),SND_TEXT

	; w7CharacterDisplayLength
	inc l
	call getCharacterDisplayLength
	ldi (hl),a

	; w7TextAttribute
	inc l
	ld (hl),$80
	; w7TextArrowState
	inc l
	ld (hl),$03
	; w7TextboxPosBank
	inc l
	ld de,w3VramTiles
	ld (hl),:w3VramTiles

	ld a,(wOpenedMenuType)
	or a
	jr z,+

	ld de,w4TileMap
	ld (hl),:w4TileMap
+
	ld a,(wTextboxPosition)
	ld hl,@textboxPositions
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	push hl
	add e
	ld l,a
	ld a,d
	adc h
	ld h,a

	; Adjust Y of textbox based on hCameraY
	ld de,$0020
	ldh a,(<hCameraY)
	add $04
	and $f8
	jr z,++

	swap a
	rlca
-
	add hl,de
	dec a
	jr nz,-
++
	; Adjust X of textbox based on hCameraX
	ldh a,(<hCameraX)
	add $04
	and $f8
	swap a
	rlca
	add l
	ld (w7TextboxPos),a

	ld a,h
	ld (w7TextboxPos+1),a

	; Same as above but for calculating the position in vram. Accounts for
	; wScreenOffsetX/Y for some reason? That's weirdly inconsistent. If
	; a textbox came up while those were nonzero, I think graphics could
	; get messed up.
	pop hl
	ldh a,(<hCameraY)
	ld b,a
	ld a,(wScreenOffsetY)
	add b
	add $04
	and $f8
	jr z,++

	; a /= 8
	swap a
	rlca
-
	add hl,de
	dec a
	jr nz,-
++
	ld a,h
	and $03
	ld h,a
	ld a,(wTextMapAddress)
	ld b,a
	ld c,$00
	add hl,bc
	ld a,l
	ld (w7TextboxVramPos),a
	ld a,h
	ld (w7TextboxVramPos+1),a

	ld a,(wScreenOffsetX)
	ld b,a
	ldh a,(<hCameraX)
	add $04
	add b
	and $f8
	swap a
	rlca
	ld (w7d0cc),a

	sub $20
	cpl
	dec a
	cp $10
	jr c,+
	ld a,$10
+
	ld (w7d0cd),a
	ld b,a
	ld a,$10
	sub b
	ld (w7d0ce),a

	ld a,(wTextboxFlags)
	bit TEXTBOXFLAG_BIT_NOCOLORS,a
	ret nz

	; If neither TEXTBOXFLAG_ALTPALETTE2 nor TEXTBOXFLAG_ALTPALETTE1 is set, use PALH_0e
	and TEXTBOXFLAG_ALTPALETTE2 | TEXTBOXFLAG_ALTPALETTE1
	ld a,PALH_0e
	jr z,+

	; If TEXTBOXFLAG_ALTPALETTE2 is set, use PALH_bd
	ld a,(wTextboxFlags)
	and TEXTBOXFLAG_ALTPALETTE2
.ifdef ROM_AGES
	ld a,PALH_bd
.else
	ld a,SEASONS_PALH_bd
.endif
	jr nz,+

	; If TEXTBOXFLAG_ALTPALETTE1 is set, use PALH_0d
	ld a,$81
	ld (w7TextAttribute),a
	ld a,PALH_0d
+
	jp loadPaletteHeader

@textboxPositions:
	.dw $0020 $00a0 $0140 $0180 $0160 $00c0 $0060

;;
; Gets address of the text index in hl, stores bank number in [w7ActiveBank]
getTextAddress:
	push de
	ld a,(w7TextTableAddr)
	ld l,a
	ld a,(w7TextTableAddr+1)
	ld h,a
	push hl
	ld a,(wTextIndexH)
	rst_addDoubleIndex
	call readByteFromW7TextTableBank
	ld c,a
	call readByteFromW7TextTableBank
	ld b,a
	pop hl
	add hl,bc
	ld a,(wTextIndexL)
	rst_addDoubleIndex
	call readByteFromW7TextTableBank
	ld c,a
	call readByteFromW7TextTableBank
	ld b,a

; If wTextIndexH < TEXT_OFFSET_SPLIT_INDEX, text is relative to TEXT_OFFSET_1
	ld a,(wActiveLanguage)
	add a
	ld hl,textOffset1Table
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wTextIndexH)
	cp TEXT_OFFSET_SPLIT_INDEX
	jr c,+
; Else, text is relative to TEXT_OFFSET_2
	ld a,(wActiveLanguage)
	add a
	ld hl,textOffset2Table
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld h,(hl)
	ld l,a
+
	ld a,e
	add $04
	add hl,bc
	jr c,++

	ld a,h
	and $c0
	rlca
	rlca
	add e
++
	ld (w7ActiveBank),a
	res 7,h
	set 6,h
	pop de
	ret


textOffset1Table:
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

textOffset2Table:
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

textTableTable:
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
checkInitialTextCommands:
	push de
	call getTextAddress
	call readByteFromW7ActiveBank
	cp $08
	jr z,@cmd8

	cp $0c
	jr nz,@end

@cmdc:
	ld d,h
	ld e,l
	call incHlAndUpdateBank
	call readByteFromW7ActiveBank
	ld b,a
	and $fc
	cp $20
	jr z,+

	ld h,d
	ld l,e
	jr @end
+
	ld a,(wTextboxFlags)
	bit TEXTBOXFLAG_BIT_DONTCHECKPOSITION,a
	jr nz,+

	ld a,b
	and $07
	ld (wTextboxPosition),a
+
	call incHlAndUpdateBank

@end:
	ld a,l
	ld (w7TextAddress),a
	ld a,h
	ld (w7TextAddress+1),a
	pop de
	ret

@cmd8:
	call incHlAndUpdateBank
	call readByteFromW7ActiveBank
	call getExtraTextIndex
	cp $ff
	jp z,@noExtraText

	ld (wTextIndexL),a
	jr checkInitialTextCommands

@noExtraText:
	ld a,$00
	ld (wTextDisplayMode),a
	ld hl,w7TextDisplayState
	ld (hl),$0f

	; w7d0c1
	inc l
	set 3,(hl)

	; w7TextStatus
	inc l
	ld (hl),$00
	ret

;;
; Gets the graphics for a line of text and puts it into w7TextGfxBuffer.
; Also sets w7LineTextBuffer, w7LineAttributesBuffer, etc.
drawLineOfText:
	ld h,d
	ld l,<w7TextStatus
	ld (hl),$ff
	ld l,<w7TextAddress
	push hl
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	push hl
	call clearTextGfxBuffer
	call clearLineTextBuffer
	pop hl
	ld bc,w7TextGfxBuffer
--
	call readByteFromW7ActiveBankAndIncHl
	cp $10
	jr nc,+

	call handleTextControlCode

	; Check whether to stop? ($00 = end of textbox, $01 = newline)
	ld a,(w7TextStatus)
	cp $02
	jr nc,--

	jr ++
+
	call setLineTextBuffers
	call retrieveTextCharacter
	jr --
++
	pop de
	ld a,l
	ld (de),a ; w7TextAddress
	inc e
	ld a,h
	ld (de),a ; w7TextAddress+1
	ld e,<w7NextTextColumnToDisplay
	xor a
	ld (de),a
	ret

;;
clearTextGfxBuffer:
	ld hl,w7TextGfxBuffer
	ld bc,$0200
	ld a,$ff
	jp fillMemoryBc

;;
clearLineTextBuffer:
	ld hl,w7LineTextBuffer
	ld d,h
	ld e,l
	ld b,$10
	jp clearMemory

;;
; Given an address in w7LineTextBuffers, this sets the values for this
; character in each LineBuffer to appropriate values.
; @param a Character
; @param de Address in w7LineTextBuffer
setLineTextBuffers:
	; Write to w7LineTextBuffer
	ld (de),a
	push de
	push hl

	; Write to w7LineAttributesBuffer
	ld hl,w7TextAttribute
	ld a,e
	add $10
	ld e,a
	ldd a,(hl)
	ld (de),a

	; Write w7CharacterDisplayLength to w7LineDelaysBuffer
	ld a,e
	add $10
	ld e,a
	dec l
	ldd a,(hl)
	ld (de),a

	; Write w7TextSound to w7LineSoundsBuffer
	ld a,e
	add $10
	ld e,a
	ldd a,(hl)
	ld (de),a

	; Write w7SoundEffect to w7LineSoundEffectsBuffer
	ld a,e
	add $10
	ld e,a
	ld a,(hl)
	ld (de),a
	ld (hl),$00

	pop hl
	pop de
	ld a,(de)
	inc e
	ret

;;
; @param a Relative offset for where to write to. Should be $00 or $02.
dmaTextGfxBuffer:
	add $94
	ld d,a
	ld e,$00
	ld hl,w7TextGfxBuffer
	ldbc $1f, TEXT_BANK
	push hl
	call queueDmaTransfer
	pop hl
	ret

;;
saveTilesUnderTextbox:
	ld hl,w7TextboxPos
	ld e,(hl)
	inc l
	ld d,(hl)
	inc l
	ld l,(hl)
	ld h,>w7TextboxMap
	call @copyTileMap

	ld hl,w7TextboxPos
	ld e,(hl)
	inc l
	ldi a,(hl)
	add $04
	ld d,a
	ld l,(hl)
	ld h,>w7TextboxAttributes

;;
; Copies 6 rows of tiles (from a tile map) from de to hl. A row is $20 bytes,
; so this copies $c0 bytes. It uses an intermediate buffer at wTmpVramBuffer in
; order to copy between any 2 banks.
; @param de Where to copy the data from
; @param hl Where to copy the data to (bank 7)
; @param [w7TextboxPosBank] Bank to copy the data from
@copyTileMap:
	; Iterate 3 times
	ld a,$03

@next2Rows:
	push af
	push hl
	ld a,(w7TextboxPosBank)
	ld ($ff00+R_SVBK),a

	; Copy 2 rows ($40 bytes) to wTmpVramBuffer
	ld hl,wTmpVramBuffer
	ld a,$02
@getNextRow:
	push af
	ld a,e
	and $e0
	ld c,a
	ld b,$20

@getNextTile:
	ld a,(de)
	ldi (hl),a
	ld a,e
	inc a
	and $1f
	or c
	ld e,a
	dec b
	jr nz,@getNextTile

	ld a,$20
	call addAToDe
	pop af
	dec a
	jr nz,@getNextRow

	; Change back to bank 7,
	ld a,$07
	ld ($ff00+R_SVBK),a
	pop hl
	push de

	; Copy the 2 rows in wTmpVramBuffer to hl (parameter to function)
	ld de,wTmpVramBuffer
	ld a,$02
@writeNextRow:
	push af
	ld a,l
	and $e0
	ld c,a
	ld b,$20

@writeNextTile:
	ld a,(de)
	ld (hl),a
	inc e
	ld a,l
	inc a
	and $1f
	or c
	ld l,a
	dec b
	jr nz,@writeNextTile

	ld a,$20
	rst_addAToHl
	pop af
	dec a
	jr nz,@writeNextRow

	pop de
	pop af
	dec a
	jr nz,@next2Rows

	ret

;;
; Initialize the textbox map and attributes so it starts as a black box.
initTextboxMapping:
	ld a,(w7d0cc)
	inc a
	and $1f
	ld l,a
	ld e,$05
--
	ld b,$12
	ld a,l
	ld d,a
	and $e0
	ld c,a
-
	ld h,>w7TextboxMap
	ld (hl),$02
	ld h,>w7TextboxAttributes
	ld (hl),$80
	ld a,l
	inc a
	and $1f
	or c
	ld l,a
	dec b
	jr nz,-

	ld a,d
	add $20
	ld l,a
	dec e
	jr nz,--

	ret

;;
; Sets up the textbox map and attributes for dma'ing.
; I have no idea what the branch instructions are for.
dmaTextboxMap:
	ld a,(wTextMapAddress)
	add $03
	ld c,a
	ld hl,w7TextboxVramPos
	ldi a,(hl)
	ld e,a
	cp $61
	ld a,(hl)
	ld d,a
	jr c,+

	cp c
	jr z,++
+
	ld b,$09
	ld hl,w7TextboxMap

@func:
	ld c,TEXT_BANK
	push hl
	call queueDmaTransfer
	pop hl
	inc e
	inc h
	jp queueDmaTransfer
++
	xor a
	sub e
	ld c,a
	swap a
	dec a
	ld b,a
	ld hl,w7TextboxMap
	push bc
	call @func

	pop bc
	ld a,(wTextMapAddress)
	ld d,a
	ld e,$00
	ld l,c
	ld h,>w7TextboxMap
	ld a,$a0
	sub c
	swap a
	dec a
	ld b,a
	jr @func

;;
; Updates the timer, and sets bit 0 of w7d0c1 if A or B is pressed.
updateCharacterDisplayTimer:
	ld h,d
	ld l,<w7TextSoundCooldownCounter
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
+
	ld l,<w7TextSlowdownTimer
	ld a,(hl)
	or a
	jr z,@checkInput

	dec (hl)
	jr nz,@countdownToNextCharacter

@checkInput:
	ld a,(wKeysJustPressed)
	and BTN_A | BTN_B
	jr nz,@skipToLineEnd

	; Wait for the next character to display itself
@countdownToNextCharacter:
	ld l,<w7CharacterDisplayTimer
	dec (hl)
	ret

	; Skip to the end of the line
@skipToLineEnd:
	ld l,<w7d0c1
	set 0,(hl)
	xor a
	ret

;;
; This function updates the textbox's tilemap to display the next character, as
; well as playing associated sound effects and whatnot.
displayNextTextCharacter:
	ld e,<w7d0d3
	ld a,(de)
	ld c,a
	cp $40
	ld b,$00
	jr z,+
	ld b,$40
+
	ld e,<w7NextTextColumnToDisplay
	ld a,(de)
	ld l,a
	ld e,<w7d0cc
	ld a,(de)
	add $02
	add l
	and $1f
	add b
	ld e,a

	; Get character, check if it's null (end of text)
	ld h,>w7LineTextBuffer
	ld a,(hl)
	or a
	jr z,@endLine

	; Store character
	ldh (<hFF8B),a

	; Write the tile index of the character to the textbox map (it's 8x16,
	; so there's two bytes to be written)
	ld d,>w7TextboxMap
	ld a,l
	add a
	add c
	ld b,a
	inc b
	ld (de),a
	ld a,e
	add $20
	ld e,a
	ld a,b
	ld (de),a

	; Similarly, write the attribute (from w7LineAttributeBuffer to
	; w7TextboxAttributes)
	inc d
	ld a,l
	add $10
	ld l,a
	ld a,(hl)
	ld (de),a
	ld a,e
	sub $20
	ld e,a
	ld a,(hl)
	ld (de),a

	; Increment the column we're on
	ld d,>w7NextTextColumnToDisplay
	ld e,<w7NextTextColumnToDisplay
	ld a,(de)
	inc a
	ld (de),a

	; End of line?
	cp $10
	jr z,@endLine

	call @checkCanAdvanceWithAB
	jr nz,+

	; Check bit 0 of <w7d0c1 (whether A or B is pressed, skip to line end)
	ld e,<w7d0c1
	ld a,(de)
	bit 0,a
	jr nz,displayNextTextCharacter
+
	call @readSubsequentLineBuffers
	or d
	ret

@endLine:
	; Play the sound effect once more if we got here by pressing A/B
	ld h,d
	ld l,<w7d0c1
	bit 0,(hl)
	ret z

	ld l,<w7TextSoundCooldownCounter
	ld a,(hl)
	or a
	jr nz,+

	ld (hl),$04
	ld l,<w7TextSound
	ld a,(hl)
	call playSound
+
	xor a
	ret

;;
; Reads and applies values from w7LineDelaysBuffer, w7LineSoundsBuffer, and
; w7LineSoundEffectsBuffer.
; @param hl Pointer within w7LineAttributeBuffer
@readSubsequentLineBuffers:
	; Have hl point to w7LineDelaysBuffer, set w7CharacterDisplayTimer
	ld a,l
	add $10
	ld l,a
	ld a,(hl)
	ld e,<w7CharacterDisplayTimer
	ld (de),a

	; Read from w7LineSoundsBuffer
	ld a,l
	add $10
	ld l,a
	ld a,(hl)
	or a
	jr z,++

	; If character is a space ($20), don't play the text sound
	ld b,a
	ldh a,(<hFF8B)
	cp ' '
	jr z,++

	; Don't play the text sound if we already played one recently
	ld e,<w7TextSoundCooldownCounter
	ld a,(de)
	or a
	jr nz,++

	ld a,$04
	ld (de),a
	ld a,b
	call @playSound

++
	; Read from w7LineSoundEffectsBuffer, play sound if applicable
	; This is different from above, it's for one-off sound effects like the
	; gorons make
	ld a,l
	add $10
	ld l,a
	ld a,(hl)
	or a
	ret z

@playSound:
	push hl
	call playSound
	pop hl
	ret

;;
; Sets zero flag if the player isn't allowed to advance with A/B currently.
@checkCanAdvanceWithAB:
	push hl
	ld e,<w7NextTextColumnToDisplay
	ld a,(de)
	add <w7LineAdvanceableBuffer
	ld l,a
	ld h,>w7LineAdvanceableBuffer
	bit 0,(hl)
	pop hl
	ret

;;
; Get the next character to display based on w7NextTextColumnToDisplay.
; Sets the zero flag if there's nothing more to display this line.
getNextCharacterToDisplay:
	ld e,<w7NextTextColumnToDisplay
	ld a,(de)
	cp $10
	ret z

	add <w7LineTextBuffer
	ld l,a
	ld h,>w7LineTextBuffer
	ld a,(hl)
	or a
	ret

;;
func_5296:
	ld h,d
	ld l,<w7d0c1
	ldd a,(hl)
	bit 2,a
	jr nz,@chooseOption

	bit 1,a
	jr nz,label_3f_155

	bit 4,a
	ret z

	call readNextTextByte
	cp $ff
	jr z,label_3f_158

	ld (wTextIndexL),a
	call checkInitialTextCommands
	ld e,<w7d0c1
	xor a
	ld (de),a
	inc e
	inc a
	ld (de),a
	ret

; The text has an option being displayed (ie. yes/no)
@chooseOption:
	ld e,<w7TextStatus
	ld a,(de)
	or a
	jr nz,label_3f_159

	ld (hl),a ; [w7TextDisplayState]
	ld a,$01
	ld (wTextDisplayMode),a
	or h
	ret

label_3f_155:
	bit 0,a
	jr z,+

	inc l
	res 0,(hl) ; [w7d0c1]
	jr label_3f_157
+
	ld a,(wKeysJustPressed)
	and (BTN_A | BTN_B)
	jr z,label_3f_157
	ld (hl),$00 ; [w7TextDisplayState]
	ld l,<w7d0c1
	res 1,(hl)
	pop hl
	ld a,SND_TEXT_2
	jp playSound
label_3f_157:
	call updateTextboxArrow
	or h
	ret
label_3f_158:
	xor a
	ld ($00c2),a ; ????????
	ret

label_3f_159:
	ld hl,w7TextboxOptionPositions
label_3f_160:
	ld a,(hl)
	or a
	ret z

	xor $20
	ldi (hl),a
	ld a,l
	and $07
	jr nz,label_3f_160
	ret

;;
readNextTextByte:
	ld l,<w7TextAddress
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call readByteFromW7ActiveBankAndIncHl

;;
; This is part of text command $08, used in shops when trying to buy something.
; @param a Index
getExtraTextIndex:
	ld hl,extraTextIndices
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld b,a
	ld a,(bc)
	rst_addAToHl
	ld a,(hl)
	ret

;;
; Update the little red arrow in the bottom-right of the textbox.
updateTextboxArrow:
	ld a,(wFrameCounter)
	and $0f
	ret nz

	; Get position of little red arrow in hl
	ld e,<w7d0cc
	ld a,(de)
	add $12
	and $1f
	add <w7TextboxMap+$80
	ld l,a
	ld h,>w7TextboxMap

	ld e,<w7TextArrowState
	ld a,(de)
	cp $03
	ld a,$02
	jr z,+
	ld a,$03
+
	ld (de),a
	ld (hl),a

	; Calculate the source and destination for the arrow
	ld a,(wTextMapAddress)
	add $04
	ld c,a
	ld l,<w7TextboxMap+$80
	ld h,>w7TextboxMap
	ld e,<w7TextboxVramPos
	ld a,(de)
	add l
	ld b,a
	inc e
	ld a,(de)
	adc $00
	cp c
	jr c,+
	ld a,(wTextMapAddress)
+
	ld d,a
	ld e,b
	ldbc $01, TEXT_BANK
	jp queueDmaTransfer

;;
; This clears the very top row - only the 8x8 portion, not the 8x16 portion.
clearTopRowOfTextMap:
	ld h,>w7TextboxMap
	ld a,(w7d0cc)
	add $02
	and $1f
	ld l,a
	ld c,a
	ld b,$10
	ld a,$02
	push bc
	call @func

	pop bc
	ld h,>w7TextboxAttributes
	ld l,c
	ld a,$80

@func:
	ld c,a
	ld a,l
	and $e0
	ld e,a
-
	ld (hl),c
	ld a,l
	inc a
	and $1f
	or e
	ld l,a
	dec b
	jr nz,-
	ret

;;
; Shifts everything in w7TextboxMap and w7TextboxAttributes up one tile.
shiftTextboxMapUp:
	ld h,>w7TextboxMap
	call @func

	ld h,>w7TextboxAttributes
@func:
	ld d,h
	ld a,(w7d0cc)
	add $02
	and $1f
	ld e,a
	add $20
	ld l,a
	ld b,a
	ld c,$04
--
	push bc
	ld a,e
	and $e0
	ld c,a
	ld b,$10
-
	ld a,(hl)
	ld (de),a
	ld a,e
	inc a
	and $1f
	or c
	ld e,a
	add $20
	ld l,a
	dec b
	jr nz,-

	pop bc
	ld e,b
	ld a,b
	add $20
	ld l,a
	ld b,a
	dec c
	jr nz,--
	ret

;;
; This resets bit 5 for every piece of text in the top row.
; This causes it to reference the values in the map $20 bytes earlier.
subFirstRowOfTextMapBy20:
	ld h,>w7TextboxMap
	ld b,$00
	call @func

	ld b,$20
@func:
	ld a,(w7d0cc)
	add $02
	and $1f
	add b
	ld l,a
	and $e0
	ld c,a
	ld b,$10
--
	ld a,(hl)
	and $60
	cp $60
	jr nz,+
	res 5,(hl)
+
	ld a,l
	inc a
	and $1f
	or c
	ld l,a
	dec b
	jr nz,--
	ret

;;
func_53dd:
	ld h,d
	ld l,<w7d0c1
	res 1,(hl)
	call saveTilesUnderTextbox
	call initTextboxMapping
	jp dmaTextboxMap

;;
; Something to do with pieces of heart
func_53eb:
	ld h,d
	ld l,<w7d0c1
	bit 5,(hl)
	jr nz,++

	ld l,<w7d0ea
	ld a,(hl)
	or a
	ret z

	dec (hl)
	ret nz

	ld b,$00
	call @func
	ld a,SND_TEXT_2
	call playSound
	xor a
	ret
++
	res 5,(hl)
	ld l,<w7d0ea
	ld (hl),$1e
	ld l,<w7d0ef
	ld (hl),$01
	call @dmaHeartPieceDisplay
	ld b,$ff

;;
; Something to do with pieces of heart
;
; @param	b	Relative number of pieces of heart to show; $ff to show one less
;			than you actually have
@func:
	ld a,(wNumHeartPieces)
	add b
	add a
	push af
	sub $08
	jr nz,+

	ld (wNumHeartPieces),a
	dec a
	ld (wStatusBarNeedsRefresh),a
	ld (w7d0ef),a
+
	pop af
	ld hl,@data
	rst_addDoubleIndex
	ld d,>w7TextboxMap
	ld a,(w7d0cc)
	add $11
	and $1f
	ld c,a
	dec a
	and $1f
	ld b,a
	add $20
	ld e,a
	ldi a,(hl)
	ld (de),a
	ld a,b
	add $40
	ld e,a
	ldi a,(hl)
	ld (de),a
	ld a,c
	add $20
	ld e,a
	ldi a,(hl)
	ld (de),a
	ld a,c
	add $40
	ld e,a
	ld a,(hl)
	ld (de),a
	ld d,>w7TextboxAttributes
	ld a,(de)
	or $20
	ld (de),a
	ld a,c
	add $20
	ld e,a
	ld a,(de)
	or $20
	ld (de),a
	call dmaTextboxMap
	or d
	ret

@data:
	.db $5d $7c $5d $7c $5f $7c $5d $7c
	.db $5f $7e $5d $7c $5f $7e $5d $7e
	.db $5f $7e $5f $7e

;;
@dmaHeartPieceDisplay:
	ld hl,gfx_font_heartpiece
	ld de,$95d0
	ldbc $00, :gfx_font_heartpiece
	call queueDmaTransfer

	ld hl,gfx_font_heartpiece+$10
	ld e,$f0
	call queueDmaTransfer

	ld hl,gfx_font_heartpiece+$20
	ld de,$97c0
	call queueDmaTransfer

	ld hl,gfx_font_heartpiece+$30
	ld e,$e0
	jp queueDmaTransfer

;;
; This is called when an item is first selected.
; This calculates w7InvTextSpacesAfterName such that the text will be centered.
; It also draws the initial line of text, because that should be visible
; immediately, not scrolled in.
doInventoryTextFirstPass:
	call clearTextGfxBuffer
	ld h,d
	ld l,<w7ActiveBank
	ldi a,(hl)
	ldh (<hFF8A),a
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	push hl
	ld e,$00
--
	call readByteFromW7ActiveBankAndIncHl
	cp $00
	jr z,@nullTerminator

	cp $01
	jr z,@lineEnd

	cp $10
	jr nc,@notControlCode

	call @controlCode
	jr --

@notControlCode:
	; Check if 16 or more characters have been read
	inc e
	bit 4,e
	jr z,--
	jr @lineEnd

@nullTerminator:
	call popFromTextStack
	ld a,h
	or a
	jr nz,--

@lineEnd:
	call popFromTextStack

	; pop the initial text address, store it into w7TextAddress
	pop bc
	ld hl,w7ActiveBank
	ldh a,(<hFF8A)
	ldi (hl),a
	ld (hl),c
	inc l
	ld (hl),b

	; Check how many characters were read
	ld a,e
	or a
	ret z

	; Calculate a value for w7InvTextSpacesAfterName such that it will be
	; centered.
	push bc
	sub $11
	cpl
	ld l,<w7InvTextSpacesAfterName
	ld (hl),a

	; Calculate where in w7TextGfxBuffer to put the first character
	and $0e
	swap a
	add $00
	ld c,a

	call clearLineTextBuffer
	ld b,>w7TextGfxBuffer
	pop hl

@nextCharacter:
	call readByteFromW7ActiveBankAndIncHl
	cp $10
	jr c,+

	; Standard character
	call setLineTextBuffers
	call retrieveTextCharacter

	; Stop at 16 characters
	bit 4,e
	jr z,@nextCharacter
	ret
+
	; Control code
	call handleTextControlCode

	; Stop at a newline or end of text
	ld a,(w7TextStatus)
	cp $02
	jr nc,@nextCharacter
	ret

;;
; When dealing with control codes, we only need to know how much space each one
; takes up. The actual contents of the text aren't important here.
; The point of this function is just to increment e by how many characters
; there are.
; @param a Control code
@controlCode:
	sub $02
	ld b,a
	push hl
	rst_jumpTable
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
@dictionary:
	pop hl
	call readByteFromW7ActiveBankAndIncHl
	ld (wTextIndexL),a
	call pushToTextStack
	ld a,b
	ld (wTextIndexH),a
	jp getTextAddress

;;
; Symbol
@controlCode6:
	inc e
@controlCodeNil:
	pop hl
	jp incHlAndUpdateBank

;;
; Jump to another text index
@controlCode7:
	pop hl
	call readByteFromW7ActiveBankAndIncHl
	ld (wTextIndexL),a
	jp checkInitialTextCommands

;;
; Link name, kid name, or secret
@controlCodeA:
	pop hl
	call readByteFromW7ActiveBankAndIncHl
	push hl
	ld hl,nameAddressTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
--
	ldi a,(hl)
	or a
	jr z,+

	inc e
	jr --
+
@controlCode8:
	pop hl
	ret

;;
; Call another text index
@controlCodeF:
	pop hl
	call readByteFromW7ActiveBankAndIncHl
	cp $fc
	jr c,++

	push hl
	cpl
	ld hl,wTextSubstitutions
	rst_addAToHl
	ld a,(hl)
	pop hl
++
	ld (wTextIndexL),a
	call pushToTextStack
	jp checkInitialTextCommands

;;
; Shift w7TextGfxBuffer such that each tile is moved one position to the left.
; @param[out] hl Text address
shiftTextGfxBufferLeft:
	ld hl,w7TextGfxBuffer
	ld de,w7TextGfxBuffer+$20
	ld bc,$01e0
--
	ld a,(de)
	ldi (hl),a
	inc de
	dec bc
	ld a,c
	or b
	jr nz,--

	ld hl,w7TextAddress
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ret

;;
decInvTextScrollTimer:
	ld h,d
	ld l,<w7InvTextScrollTimer
	dec (hl)
	ret nz

	ld (hl),$08
	xor a
	ret

;;
; Sets z flag if $06 is passed (command to read a trade item or symbol
; graphic). I think the reasoning is that the z flag is set when an actual
; character is drawn, since most control codes don't draw characters.
handleTextControlCodeWithSpecialCase:
	cp $06
	jr z,@cmd6

	call handleTextControlCode
	or d
	ret

	; Control code 6: trade item or symbol
@cmd6:
	ld bc,w7TextGfxBuffer+$1e0
	ld de,w7d5e0
	call handleTextControlCode
	xor a
	ret

;;
; Updates w7SelectedTextPosition based on w7SelectedTextOption, and draws the
; cursor to that position in w7TextboxMap.
updateSelectedTextPosition:
	call getSelectedTextOptionAddress
	bit 5,(hl)
	ld b,$60
	jr nz,+
	ld b,$20
+
	ld a,(hl)

	; de = w7SelectedTextPosition
	inc e
	ld (de),a

	call getAddressInTextboxMap
	ld (hl),$04
	ret

;;
; @param[out] hl The address in w7TextboxOptionPositions for the current
; selected option.
getSelectedTextOptionAddress:
	ld e,<w7SelectedTextOption
	ld a,(de)
	add <w7TextboxOptionPositions
	ld l,a
	ld h,d
	ret

;;
; @param a Value from w7TextboxOptionPositions
; @param b Offset to start of row ($20 for top row, $60 for bottom)
; @param[out] hl Pointer to somewhere in w7TextboxMap
getAddressInTextboxMap:
	and $1e
	rrca
	ld l,a
	ld e,<w7d0cc
	ld a,(de)

	; Text starts 2 tiles from the leftmost edge
	add $02

	add l
	and $1f
	add b
	ld l,a
	ld h,>w7TextboxMap
	ret

;;
removeCursorFromSelectedTextPosition:
	ld b,$60
	ld e,<w7SelectedTextPosition
	ld a,(de)
	ld c,a
	bit 5,a
	jr nz,+
	ld b,$20
+
	call getAddressInTextboxMap
	ld (hl),c
	ret

;;
moveSelectedTextOptionRight:
	ld e,<w7SelectedTextOption
	ld a,(de)
	inc a
	and $07
	ld (de),a
	call getSelectedTextOptionAddress
	ld a,(hl)
	or a
	ret nz

	xor a
	ld (de),a
	ret

;;
moveSelectedTextOptionLeft:
	ld e,<w7SelectedTextOption
	ld a,(de)
	dec a
	and $07
	ld (de),a
	call getSelectedTextOptionAddress
	ld a,(hl)
	or a
	ret nz
	jr moveSelectedTextOptionLeft

;;
textOptionCode_checkDirectionButtons:
	ld a,(wKeysJustPressed)
	and BTN_UP|BTN_DOWN|BTN_LEFT|BTN_RIGHT
	ret z

	ld a,SND_MENU_MOVE
	call playSound
	call removeCursorFromSelectedTextPosition
	call @updateSelectedTextOption
	jr updateSelectedTextPositionAndDmaTextboxMap

;;
; Updates w7SelectedTextOption depending on the input.
@updateSelectedTextOption:
	ld a,(wKeysJustPressed)
	call getHighestSetBit
	sub $04

	; Right
	jr z,moveSelectedTextOptionRight

	; Left
	dec a
	jr z,moveSelectedTextOptionLeft

	; Up or down

	call getSelectedTextOptionAddress
	ld b,(hl)
	ld c,$ff
	ld l,<w7TextboxOptionPositions
	ld e,l
---
	ld a,(hl)
	or a
	jr z,@end

	sub b
	jr nc,+
	cpl
	inc a
+
	sub $20
	jr nc,+
	cpl
	inc a
+
	cp c
	jr nc,+
	ld c,a
	ld e,l
+
	inc l
	jr ---

@end:
	ld a,c
	cp $10
	ret nc

	ld a,e
	sub <w7TextboxOptionPositions
	ld e,<w7SelectedTextOption
	ld (de),a
	ret

;;
updateSelectedTextPositionAndDmaTextboxMap:
	call updateSelectedTextPosition
	jp dmaTextboxMap

;;
; When the B button is pressed, move the cursor to the last option.
; Unsets zero flag if B is pressed.
; @param a Buttons pressed
textOptionCode_checkBButton:
	and BTN_B
	ret z

	; Find last option
	ld h,d
	ld l,<w7TextboxOptionPositions
-
	ldi a,(hl)
	or a
	jr nz,-

	ld a,l
	sub <w7TextboxOptionPositions+2
	ld l,<w7SelectedTextOption
	ld (hl),a

	ld a,SND_MENU_MOVE
	call playSound
	call removeCursorFromSelectedTextPosition
	call updateSelectedTextPositionAndDmaTextboxMap
	or d
	ret

;;
; Save the current address of text being read.
; @param hl Current address of text
pushToTextStack:
	push de
	push bc
	push hl
	ld hl,w7TextStack+$1b
	ld de,w7TextStack+$1f
	ld b,$1c
-
	ldd a,(hl)
	ld (de),a
	dec e
	dec b
	jr nz,-

	; hl = w7TextStack
	inc l

	ld de,w7ActiveBank
	ld a,(de)
	ldi (hl),a
	pop de
	ld (hl),e
	inc l
	ld (hl),d
	inc l
	ld a,(wTextIndexH)
	ld (hl),a
	ld h,d
	ld l,e
	pop bc
	pop de
	ret

;;
popFromTextStack:
	push de
	push bc
	ld hl,w7TextStack+3
	ldd a,(hl)
	ld (wTextIndexH),a
	ldd a,(hl)
	ld de,w7TextAddress+1
	ld (de),a
	ld b,a
	ldd a,(hl)
	dec e
	ld (de),a
	ld c,a
	ld a,(hl)
	dec e
	ld (de),a
	push bc
	ld de,w7TextStack+4
	ld b,$1c
-
	ld a,(de)
	ldi (hl),a
	inc e
	dec b
	jr nz,-

	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	pop hl
	pop bc
	pop de
	ret

;;
readByteFromW7ActiveBankAndIncHl:
	call readByteFromW7ActiveBank

;;
incHlAndUpdateBank:
	inc l
	ret nz

	inc h
	bit 7,h
	ret z

	rrc h
	push af
	ld a,(w7ActiveBank)
	inc a
	ld (w7ActiveBank),a
	pop af
	ret

;;
; Handle control codes for text (any value under $10)
; @param a Control code
handleTextControlCode:
	push bc
	push hl
	rst_jumpTable
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
	pop hl
	pop bc
	ret

;;
; Null terminator; end of text
@controlCode0:
	pop hl
	pop bc
	call popFromTextStack
	ld a,h
	or a
	ret nz

	; If $00 was popped from the text stack, we've reached the end
	ld (w7TextStatus),a
	ret

;;
; Newline character
@controlCode1:
	pop hl
	pop bc
	ld a,$01
	ld (w7TextStatus),a
	ret

;;
; Special character - japanese kanji or trade item symbol.
; If bit 7 of the parameter is set, it reads a trade item from
; gfx_font_tradeitems.
; Otherwise, it reads a kanji from gfx_font_jp. This file also contains the
; triangle symbol which is used sometimes in the english version.
@controlCode6:
	pop hl
	call readByteFromW7ActiveBankAndIncHl
	ld b,a
	cp $80
	jr c,@kanji

@tradeItem:
	ld a,(wTextGfxColorIndex)
	swap a
	or $03
	ld (wTextGfxColorIndex),a
	ld a,$02
	ld (w7TextGfxSource),a
	ld a,b
	sub $80
	add a
	jr ++

@kanji:
	ld a,$01
	ld (w7TextGfxSource),a
	ld a,b
++
	pop bc
	push af
	ld a,$06
	call setLineTextBuffers
	pop af
	jp retrieveTextCharacter

;;
; Dictionary 0
@controlCode2:
	xor a
	jr ++

;;
; Dictionary 1
@controlCode3:
	ld a,$01
	jr ++

;;
; Dictionary 2
@controlCode4:
	ld a,$02
	jr ++

;;
; Dictionary 3
@controlCode5:
	ld a,$03
++
	ldh (<hFF8B),a
	pop hl
	call readByteFromW7ActiveBankAndIncHl
	ld (wTextIndexL),a
	call pushToTextStack
	ldh a,(<hFF8B)
	ld (wTextIndexH),a
	call getTextAddress
	jr @popBcAndRet

;;
; "Call" another piece of text; insert that text, then go back to reading the
; current text.
@controlCodeF:
	pop hl
	call readByteFromW7ActiveBankAndIncHl
	cp $fc
	jr c,+

	push hl
	cpl
	ld hl,wTextSubstitutions
	rst_addAToHl
	ld a,(hl)
	pop hl
+
	ld (wTextIndexL),a
	ld a,(wTextIndexH_backup)
	ld (wTextIndexH),a
	call pushToTextStack
	call checkInitialTextCommands
	jr @popBcAndRet

;;
; "Jump" to a different text index
@controlCode7:
	pop hl
	call readByteFromW7ActiveBankAndIncHl
	ld (wTextIndexL),a
	call checkInitialTextCommands
	jr @popBcAndRet

;;
; This tells the game to stop displaying the text, and to show a different
; textbox when this one is closed. Used in shops to show various messages
; depending whether you can hold or can afford a particular item.
; This command actually takes a parameter, but it's not read here.
@controlCode8:
	; Show another textbox later
	ld a,(w7d0c1)
	or $10
	ld (w7d0c1),a

	; End this text
	xor a
	ld (w7TextStatus),a

	pop hl
	jr @popBcAndRet

;;
; Change text color or set the attribute byte.
; If the parameter has bit 7 set, it is written directly to w7TextAttribute.
; Otherwise, the parameter is used as an index for a table of preset values.
@controlCode9:
	pop hl

	; Check TEXTBOXFLAG_NOCOLORS
	ld a,(wTextboxFlags)
	rrca
	jr c,@@noColors

	call readByteFromW7ActiveBankAndIncHl
	bit 7,a
	jr nz,+

	ld bc,@textColorData
	call addDoubleIndexToBc
	ld a,(bc)
	ld (w7TextAttribute),a
	inc bc
	ld a,(bc)
	ld (wTextGfxColorIndex),a
	pop bc
	ret
+
	ld (w7TextAttribute),a
	jr @popBcAndRet

@@noColors:
	call incHlAndUpdateBank

@popBcAndRet:
	pop bc
	ret

; b0: attribute byte (which palette to use)
; b1: Value for wTextGfxColorIndex
@textColorData:
	.db $80 $02 ; White (palette 0)
	.db $80 $01 ; Red (palette 0)
	.db $81 $00 ; Red (palette 1, color 0, appears behind sprites)
	.db $81 $01 ; Blue (palette 1)
	.db $81 $02 ; White (palette 1)


;;
; Link or kid name
@controlCodeA:
	pop hl
	pop bc
	call readByteFromW7ActiveBankAndIncHl
	push hl
	ld hl,nameAddressTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
--
	ldi a,(hl)
	or a
	jr z,+

	call setLineTextBuffers
	call retrieveTextCharacter
	jr --
+
	pop hl
	ret

;;
; Play a sound effect
@controlCodeE:
	pop hl
	call readByteFromW7ActiveBankAndIncHl
	ld (w7SoundEffect),a
	jr @popBcAndRet

; Unused?
	pop hl
	call readByteFromW7ActiveBankAndIncHl
	ld b,a
	call @@func2
	call @@func1
	jr @popBcAndRet

@@func1:
	push de
	ld a,e
	add $50
	ld e,a
	ld a,(de)
	or $01
	ld (de),a
	pop de
	ret

@@func2:
	push de
	ld a,e
	add $20
	ld e,a
	ld a,b
	ld (de),a
	pop de
	ret

;;
; Set the sound that's made when each character is displayed
@controlCodeB:
	pop hl
	call readByteFromW7ActiveBankAndIncHl
	ld (w7TextSound),a
	jr @popBcAndRet

;;
; Set the number of frames until the textbox closes itself.
@controlCodeD:
	pop hl
	call readByteFromW7ActiveBankAndIncHl
	ld (w7TextboxTimer),a
	jr @popBcAndRet

;;
; Parameter:
;  Bits 0-1: Loaded into c
;  Bits 3-7: Action to perform. Values of 0-7 are valid.
@controlCodeC:
	pop hl
	call readByteFromW7ActiveBankAndIncHl
	push hl
	ld b,a
	and $03
	ld c,a
	ld a,b
	swap a
	rlca
	and $1f
	rst_jumpTable
	.dw textControlCodeC_0
	.dw textControlCodeC_1
	.dw textControlCodeC_2
	.dw textControlCodeC_3
	.dw textControlCodeC_ret ; $04 is dealt with in checkInitialTextCommands.
	.dw textControlCodeC_5
	.dw textControlCodeC_6
	.dw textControlCodeC_7

;;
; Gets the number of frames each character is displayed for, based on
; wTextSpeed.
; @param[out] a Frames per character
getCharacterDisplayLength:
	push hl
	ld a,(wTextSpeed)
	swap a
	rrca
	ld hl,textSpeedData+2
	rst_addAToHl
	ld a,(hl)
	pop hl
	ret

;;
; Sets the speed of the text. Value of $02 for c sets it to normal, lower
; values are faster, higher ones are slower.
textControlCodeC_0:
	ld a,(wTextSpeed)
	swap a
	rrca
	add c
	ld hl,textSpeedData
	rst_addAToHl
	ld a,(hl)
	ld (w7CharacterDisplayLength),a
	jr textControlCodeC_ret

; This is the structure which controls the values for each text speed. I don't
; know why there are 8 bytes per text speed, but the 3rd byte of each appears
; to be the only important one.
textSpeedData:
	.db $04 $05 $07 $08 $0a $0c $0e $0f ; Text speed 1
	.db $03 $04 $05 $07 $08 $0a $0b $0c ; Text speed 2
	.db $02 $03 $04 $05 $06 $08 $08 $0a ; 3
	.db $02 $02 $03 $03 $04 $06 $06 $08 ; 4
	.db $01 $01 $02 $02 $03 $03 $04 $05 ; 5
;;
; Slow down the text. Used for essences.
textControlCodeC_7:
	ld a,$78
	ld (w7TextSlowdownTimer),a
	jr textControlCodeC_ret

;;
; Show the piece of heart icon.
textControlCodeC_5:
	ld hl,w7d0c1
	set 5,(hl)

;;
; Stop text here, clear textbox on next button press.
textControlCodeC_3:
	ld hl,w7d0c1
	set 1,(hl)

;;
textControlCodeC_ret:
	pop hl
	pop bc
	ret

;;
; Unused?
textControlCodeC_6:
	ld a,($cbab)
	ld (wTextNumberSubstitution+1),a
	ld a,($cbaa)
	ld (wTextNumberSubstitution),a

;;
; Display a number of up to 3 digits. Usually bcd format.
textControlCodeC_1:
	pop hl
	pop bc

	; Hundreds digit
	ld a,(wTextNumberSubstitution+1)
	or a
	jr z,+

	call @drawDigit

	; Tens digit
	ld a,(wTextNumberSubstitution)
	and $f0
	jr ++
+
	ld a,(wTextNumberSubstitution)
	and $f0
	jr z,+++
++
	swap a
	call @drawDigit
+++
	; Ones digit
	ld a,(wTextNumberSubstitution)
	and $0f

@drawDigit:
	add $30
	call setLineTextBuffers
	jp retrieveTextCharacter

;;
; An option is presented, ie. yes/no. This command marks a possible position
; for the cursor.
textControlCodeC_2:
	call @getNextTextboxOptionPosition
	ld a,(w7d0c1)
	or $04
	ld (w7d0c1),a

	; e is the position in the line
	ld a,e
	; Multiply by 2 since each character is 2 bytes
	add a
	; w7TextboxMap+$60 is the start of the bottom row
	or $60

	ld b,a
	inc b
	ld (hl),b
	pop hl
	pop bc

	; Reserve this spot for the cursor
	ld a,$20
	call setLineTextBuffers
	jp retrieveTextCharacter

;;
@getNextTextboxOptionPosition:
	ld hl,w7TextboxOptionPositions
-
	ld a,(hl)
	or a
	ret z

	inc l
	jr -

nameAddressTable:
	.dw wLinkName wKidName
	.dw w7SecretText1 w7SecretText2

; This data structure works with text command $08. When buying something from
; a shop, it checks the given variable ($cbad) and displays one of these pieces
; of text depending on the value.
;
.ifdef ROM_AGES
extraTextIndices:
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
	.db <TX_0d02, <TX_0d08, <TX_0d04, <TX_0d03

; Gasha seed in Syrup's hut
@index0e:
	.dw $cbad
	.db <TX_0d06, <TX_0d08, <TX_0d07, <TX_0d03

; Ring box upgrade in upstairs Lynna shop
@index0f:
	.dw $cbad
	.db $ff, <TX_0e06, <TX_0e05, $ff

; Bombchus in Syrup's hut
@index11:
	.dw $cbad
	.db <TX_0d0c, <TX_0d08, <TX_0d07, <TX_0d03
.else
extraTextIndices:
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
	.db <TX_0d02, <TX_0d08, <TX_0d04, <TX_0d03

; Gasha seed in Syrup's hut
@index0e:
	.dw $cbad
	.db <TX_0d06, <TX_0d08, <TX_0d07, <TX_0d03

; TODO: ???
@index0f:
	.dw $cbad
	.db $ff, <TX_0e06, <TX_0e05, $ff

@index10:
	; corrupted version of index00?
	.db <$cba5
	.db $02, $03

; Bombchus in Syrup's hut
@index11:
	.dw $cbad
	.db <TX_0d0c, <TX_0d08, <TX_0d07, <TX_0d03
.endif
