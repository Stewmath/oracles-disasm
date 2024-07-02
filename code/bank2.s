 m_section_free Bank_2 NAMESPACE bank2

;;
; This function checks if the game is run on a dmg (instead of a gbc) and, if so, displays
; the "only for gbc" screen.
checkDisplayDmgModeScreen:
	ldh a,(<hGameboyType)
	or a
	ret nz

	call disableLcd

	xor a ; GFXH_DMG_SCREEN
	call loadGfxHeader

.ifdef REGION_JP
	ld de,$8800
	xor a
	call copyTextCharactersFromSecretTextTable
.endif

	xor a
	call loadGfxRegisterStateIndex

	ld hl,wGfxRegs1
	ld de,wGfxRegsFinal
	ld b,GfxRegsStruct.size
	call copyMemory

@vblankLoop:
	ld a,$ff
	ld (wVBlankChecker),a
	halt
	nop
	ld a,(wVBlankChecker)
	bit 7,a
	jr nz,@vblankLoop

	ldh a,(<hSerialInterruptBehaviour)
	or a
	jr z,++

	call serialFunc_0c8d
	jr @vblankLoop
++
	call serialFunc_0c85
	ld a,$03
	ldh (<hFFBE),a
	xor a
	ldh (<hSerialLinkState),a
	jr @vblankLoop

;;
; Indoor rooms don't appear to rely on the tileset flags to tell if they're in the past; they
; have another room-based table to determine that.
;
; For ages, this marks rooms as being in the past; for seasons, it marks rooms as being in
; subrosia.
;
; Updates wTilesetFlags accordingly with TILESETFLAG_PAST (bit 7).
updateTilesetFlagsForIndoorRoomInAltWorld:
	ld a,(wActiveGroup)
	or a
	ret z

	ld hl,roomsInAltWorldTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wActiveRoom)
	call checkFlag
	ret z

	ld hl,wTilesetFlags
.ifdef ROM_AGES
	set TILESETFLAG_BIT_PAST,(hl)
.else
	set TILESETFLAG_BIT_SUBROSIA,(hl)
.endif
	ret


.include {"{GAME_DATA_DIR}/roomsInAltWorld.s"}


;;
; @param	a	Index for table
; @param	b	Number of characters to copy
; @param	de	Destination
copyTextCharactersFromSecretTextTable:
	ld hl,secretTextTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

;;
copyTextCharactersFromHlUntilNull:
	set 7,b

;;
; @param	b			Number of characters to copy, or copy until $00 if
;					bit 7 is set
; @param	de			Destination
; @param	hl			Pointer to characters indices to load
; @param	wFileSelect.fontXor	Value to xor every other byte with
copyTextCharactersFromHl:
	ldi a,(hl)
	bit 7,b
	jr z,+

	or a
	ret z

	cp $01
	jr z,copyTextCharactersFromHl
+
	ld c,$00
	cp $06
	jr nz,+

	inc c
	ldi a,(hl)
+
	call copyTextCharacterGfx
	bit 7,b
	jr nz,copyTextCharactersFromHl
	dec b
	jr nz,copyTextCharactersFromHl
	ret

;;
b2_fileSelectScreen:
	ld hl,wTmpcbb6
	inc (hl)
	call fileSelect_redrawDecorationsAndSetWramBank4
	ld a,(wFileSelect.mode)
	rst_jumpTable
	.dw fileSelectMode0 ; Initialization
	.dw fileSelectMode1 ; Main file select
	.dw fileSelectMode2 ; Entering name
	.dw fileSelectMode3 ; Copy
	.dw fileSelectMode4 ; Erase
	.dw fileSelectMode5 ; Selecting between new game, secret, link
	.dw fileSelectMode6 ; Entering a secret
	.dw fileSelectMode7 ; Game link

;;
func_02_4149:
	ld hl,wFileSelect.cursorPos
	ldi (hl),a

	; [wFileSelect.cursorPos2]         = $80
	; [wFileSelect.textInputCursorPos] = $80
	ld a,$80
	ldi (hl),a
	ldd (hl),a
	ret

;;
setFileSelectCursorOffsetToFileSelectMode:
	ld a,(wFileSelect.mode)
	ld (wFileSelect.cursorOffset),a
	ret

;;
setFileSelectModeTo1:
	ld a,$01
;;
setFileSelectMode:
	ld hl,wFileSelect.mode
	ldi (hl),a
	xor a
	ld (hl),a ; [wFileSelect.mode2] = $00
	ld (wFileSelect.textInputMode),a
	ret

;;
loadGfxRegisterState5AndIncFileSelectMode2:
	ld a,$05
	call loadGfxRegisterStateIndex
;;
incFileSelectMode2:
	ld hl,wFileSelect.mode2
	inc (hl)
	ret

;;
decFileSelectMode2IfBPressed:
	ld a,(wKeysJustPressed)
	and BTN_B
	ret z
;;
decFileSelectMode2:
	ld hl,wFileSelect.mode2
	dec (hl)
	ret

;;
; Gets the address for the given file's DisplayVariables.
;
; @param	a	File index
; @param	d	Value to add to address
getFileDisplayVariableAddress:
	ld e,a
getFileDisplayVariableAddress_paramE:
	ld a,e
	swap a
	rrca
	add d
	ld hl,w4FileDisplayVariables
	rst_addAToHl
	ret

;;
; Initialization of file select screen
fileSelectMode0:
	ld hl,wFileSelect.mode
	ld b,$10
	call clearMemory
	call disableLcd
	ld a,GFXH_FILE_MENU_GFX
	call loadGfxHeader
	ld a,MUS_FILE_SELECT
	call playSound
	xor a
	ld (wLastSecretInputLength),a
	call setFileSelectModeTo1
;;
; Main mode, selecting a file
fileSelectMode1:
	call @mode1SubModes
	call fileSelectDrawAcornCursor
	jp fileSelectDrawLink

;;
@mode1SubModes:
	ld a,(wFileSelect.mode2)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

;;
; Initialization
@state0:
	call setFileSelectCursorOffsetToFileSelectMode
	xor a
	call func_02_4149
	call disableLcd
	ld a,GFXH_FILE_MENU_WITH_MESSAGE_SPEED
	call loadGfxHeader
	ld a,PALH_05
	call loadPaletteHeader
	call loadFileDisplayVariables
	call textInput_updateEntryCursor
	call fileSelectDrawHeartsAndDeathCounter
	jp loadGfxRegisterState5AndIncFileSelectMode2

;;
; Normal mode
@state1:
	call fileSelectUpdateInput
	jr nz,++

	ld hl,wFileSelect.cursorPos
	ldi a,(hl)
	set 7,(hl)
	cp $03
	ret nz
	call func_02_448d
	ret z
++
	ld a,SND_SELECTITEM
	call playSound
	call @getNextFileSelectMode
	jp nz,setFileSelectMode

	; Selected a non-empty file
	call incFileSelectMode2
	call loadFile
	ld a,UNCMP_GFXH_16
	jp loadUncompressedGfxHeader

;;
; Called after selecting something.
;
; Returns nz with a value in A as the next file selection mode, or z for no mode change.
@getNextFileSelectMode:
	ld a,(wFileSelect.cursorPos)
	cp $03
	jr z,++

	ldh (<hActiveFileSlot),a
	ld d,$00
	call getFileDisplayVariableAddress
	bit 7,(hl)
	ld a,$05
	ret nz
	xor a
	ret
++
	ld a,(wFileSelect.cursorPos2)
	add $03
	ret

;;
; Selecting text speed
@state2:
	call @textSpeedMenu_checkInput
	jr @textSpeedMenu_addCursorToOam

;;
@textSpeedMenu_checkInput:
	ld a,(wKeysJustPressed)
	ld b,a
	and BTN_B | BTN_SELECT
	jr nz,@back

	ld c,$01
	bit BTN_BIT_RIGHT,b
	jr nz,@leftOrRight

	ld c,$ff
	bit BTN_BIT_LEFT,b
	jr nz,@leftOrRight

	ld a,b
	and BTN_A | BTN_START
	ret z

	ld a,SND_SELECTITEM
	call playSound
	call incFileSelectMode2
	call saveFile
	jp fadeoutToWhite

@back:
	ld a,UNCMP_GFXH_08
	call loadUncompressedGfxHeader
	jp decFileSelectMode2

@leftOrRight:
	ld hl,wTextSpeed
	ld a,(hl)
	add c
	cp $05
	ret nc
	ld (hl),a
	ld a,SND_MENU_MOVE
	jp playSound

;;
@textSpeedMenu_addCursorToOam:
	ld a,(wTextSpeed)
	swap a
	ld c,a
	ld b,$00
	ld hl,@data
	jp addSpritesToOam_withOffset

; OAM data for cursor?
@data:
	.db $01
	.db $90 $31 $2e $01

;;
; Screen fading out
@state3:
	ld a,(wPaletteThread_mode)
	or a
	jr nz,@textSpeedMenu_addCursorToOam

	; Fade done
	xor a
	ld (wLastSecretInputLength),a
	ld bc,mainThreadStart
	jp restartThisThread

;;
; Choose between new game, secret, game link
fileSelectMode5:
	call @mode5States
	jp fileSelectDrawAcornCursor

;;
@mode5States:
	ld a,(wFileSelect.mode2)
	rst_jumpTable
	.dw @state0
	.dw @state1

;;
@state0:
	call disableLcd
	ld a,GFXH_NEW_FILE_OPTIONS
	call loadGfxHeader
	ld a,GFXH_SAVE_MENU_LAYOUT
	call loadGfxHeader
	ld a,UNCMP_GFXH_08
	call loadUncompressedGfxHeader
	call setFileSelectCursorOffsetToFileSelectMode
	xor a
	call func_02_4149
	jp loadGfxRegisterState5AndIncFileSelectMode2

;;
@state1:
	ld a,(wKeysJustPressed)
	ld c,$01
	bit BTN_BIT_DOWN,a
	jr nz,@upOrDown

	ld c,$ff
	bit BTN_BIT_UP,a
	jr nz,@upOrDown

	ld c,a
	and BTN_B | BTN_SELECT
	jp nz,setFileSelectModeTo1

	ld a,c
	and BTN_A | BTN_START
	ret z

	ld a,(wFileSelect.cursorPos)
	ld hl,@selectionModes
	rst_addAToHl
	ld a,(hl)
	call setFileSelectMode
	ld a,SND_SELECTITEM
	jp playSound

@selectionModes:
	.db $02 ; Name entry
	.db $06 ; Secret entry
	.db $07 ; Game link

@upOrDown:
	ld hl,wFileSelect.cursorPos
	ld a,(hl)
-
	add c
	and $03
	cp $03
	jr nc,-

	ld (hl),a
	ld a,SND_MENU_MOVE
	jp playSound

;;
; Copying file
fileSelectMode3:
	call @mode3Update
	jp fileSelectDrawAcornCursor

;;
@mode3Update:
	ld a,(wFileSelect.mode2)
	rst_jumpTable
	.dw @mode0
	.dw @mode1
	.dw @mode2
	.dw @mode3

;;
@mode0:
	call setFileSelectCursorOffsetToFileSelectMode
	ld a,$03
	call func_02_4149
	call disableLcd
	ld a,GFXH_FILE_MENU_COPY
	call loadGfxHeader
	call loadFileDisplayVariables
	call textInput_updateEntryCursor
	ld a,UNCMP_GFXH_08
	call loadUncompressedGfxHeader
	jp loadGfxRegisterState5AndIncFileSelectMode2

;;
@mode1:
	call fileSelectUpdateInput
	ret z
	ld a,SND_SELECTITEM
	call playSound
	ld a,(wFileSelect.cursorPos)
	cp $03
	jp z,setFileSelectModeTo1

	ldh (<hActiveFileSlot),a
	ld d,$00
	call getFileDisplayVariableAddress
	bit 7,(hl)
	jr z,+

	ld a,SND_ERROR
	jp playSound
+
	xor a
	ld (wFileSelect.cursorOffset),a
	call func_02_4149
	call incFileSelectMode2
	ld b,$01
---
	ld a,b
	or a
	ret z
--
	ld hl,wFileSelect.cursorPos
	ldh a,(<hActiveFileSlot)
	cp (hl)
	ret nz
	ld a,(hl)
	add b
	and $03
	ld (hl),a
	jr --

;;
@mode2:
	call @func_02_4397
	call decFileSelectMode2IfBPressed
	jr nz,@label_02_015

	call fileSelectUpdateInput
	jr z,---

	ld a,SND_SELECTITEM
	call playSound
	ld a,(wFileSelect.cursorPos)
	cp $03
	jp nz,incFileSelectMode2
	call decFileSelectMode2
	jr @label_02_015

;;
@mode3:
	call @func_02_4397
	call decFileSelectMode2IfBPressed
	jr nz,@label_02_015
	call func_02_448d
	ret z

	ld a,SND_SELECTITEM
	call playSound
	ld a,(wFileSelect.cursorPos2)
	or a
	jp z,setFileSelectModeTo1

	call loadFile
	ld a,(wFileSelect.cursorPos)
	ldh (<hActiveFileSlot),a
	call saveFile
	jp setFileSelectModeTo1

;;
@func_02_4397:
	ldh a,(<hActiveFileSlot)
	ld hl,@data
	rst_addAToHl
	ld b,(hl)
	ld c,$00
	ld hl,@spriteData
	jp addSpritesToOam_withOffset

@data:
	.db $30 $48 $60

@spriteData:
	.db $06
	.db $10 $18 $2a $81
	.db $10 $20 $2a $81
	.db $10 $28 $2a $81
	.db $10 $30 $2a $81
	.db $10 $38 $2a $81
	.db $10 $40 $2a $81

@label_02_015:
	ld a,SND_CLINK
	call playSound
	ld a,(wFileSelect.mode2)
	cp $01
	ld a,(wFileSelect.cursorPos)
	jr nz,+

	call setFileSelectCursorOffsetToFileSelectMode
	ldh a,(<hActiveFileSlot)
+
	jp func_02_4149

;;
; Erasing a file
fileSelectMode4:
	call @mode4Update
	call fileSelectDrawAcornCursor
	jp fileSelectDrawLink

@mode4Update:
	ld a,(wFileSelect.mode2)
	rst_jumpTable
	.dw @mode0
	.dw @mode1
	.dw @mode2
	.dw @mode3

@mode0:
	call setFileSelectCursorOffsetToFileSelectMode
	ld a,$03
	call func_02_4149
	call disableLcd
	ld a,GFXH_FILE_MENU_ERASE
	call loadGfxHeader
	ld a,PALH_06
	call loadPaletteHeader
	call loadFileDisplayVariables
	call textInput_updateEntryCursor
	call fileSelectDrawHeartsAndDeathCounter
	jp loadGfxRegisterState5AndIncFileSelectMode2

@mode1:
	call fileSelectUpdateInput
	ret z

	ld a,SND_SELECTITEM
	call playSound
	ld a,(wFileSelect.cursorPos)
	cp $03
	jp z,setFileSelectModeTo1

	ldh (<hActiveFileSlot),a
	jp incFileSelectMode2

@mode2:
	call decFileSelectMode2IfBPressed
	jr nz,++

	call func_02_448d
	ret z

	ld a,(wFileSelect.cursorPos2)
	or a
	jp z,setFileSelectModeTo1
	jp incFileSelectMode2
++
	ld a,SND_CLINK
	call playSound
	ld a,(wFileSelect.cursorPos)
	jp func_02_4149

@mode3:
	ld hl,wFileSelect.linkTimer
	dec (hl)
	bit 0,(hl)
	ret nz

	ldh a,(<hActiveFileSlot)
	ld d,$02
	call getFileDisplayVariableAddress
	ld a,(hl)
	or a
	jr z,++

	dec a
	ld (hl),a
	and $03
	ld a,SND_GAINHEART
	call z,playSound
	jp fileSelectDrawHeartsAndDeathCounter
++
	call eraseFile
	jp setFileSelectModeTo1

;;
; Returns z-flag unset if something was selected.
fileSelectUpdateInput:
	ld a,(wKeysJustPressed)
	ld c,a
	ld hl,wFileSelect.cursorPos
	ld a,$ff
	bit BTN_BIT_UP,c
	jr nz,@upOrDown

	ld a,$01
	bit BTN_BIT_DOWN,c
	jr nz,@upOrDown

	ld a,c
	and BTN_A | BTN_START
	ld b,a
	ret
@upOrDown:
	ld b,a
	push bc
	add (hl)
	and $03
	call fileSelectSetCursor
	call fileSelectDrawHeartsAndDeathCounter
	pop bc
	xor a
	ret

;;
func_02_448d:
	ld a,(wKeysJustPressed)
	ld c,a
	ld hl,wFileSelect.cursorPos2
	res 7,(hl)
	xor a
	bit 5,c
	jr nz,+

	inc a
	bit 4,c
	jr nz,+

	ld a,c
	and $09
	ret
+
	cp (hl)
	call nz,fileSelectSetCursor
	xor a
	ret

;;
fileSelectSetCursor:
	ld (hl),a
	ld a,SND_MENU_MOVE
	jp playSound

;;
; Entering name
fileSelectMode2:
	call @func
	jp drawNameInputCursors

@func:
	ld a,(wFileSelect.mode2)
	rst_jumpTable
	.dw @mode0
	.dw runTextInput
	.dw @mode2

@mode0:
	call eraseFile
	call loadFile
	xor a
	jp copyNameToW4NameBuffer

@mode2:
	call getNameBufferLength
	jr z,+

	ld hl,w4NameBuffer
	ld de,wLinkName
	ld b,$06
	call copyMemory
	call initializeFile
+
	jp setFileSelectModeTo1

;;
runKidNameEntryMenu:
	call fileSelect_redrawDecorationsAndSetWramBank4
	call @func
	jp drawNameInputCursors

@func:
	ld a,(wFileSelect.mode2)
	rst_jumpTable
	.dw @mode0
	.dw @mode1
	.dw @mode2

@mode0:
	ld a,GFXH_FILE_MENU_GFX
	call loadGfxHeader
	ld a,$01
	call copyNameToW4NameBuffer
	jp fadeinFromWhite

@mode1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	jp runTextInput

@mode2:
	call getNameBufferLength
	ld a,$01
	jr z,+

	ld hl,w4NameBuffer
	ld de,wKidName
	ld b,$06
	call copyMemory
	ld a,SND_SELECTITEM
	call playSound
	xor a
+
	ld (wTextInputResult),a
	jp closeMenu

;;
; Entering a secret
fileSelectMode6:
	call @updateMode6
	jp drawSecretInputCursors

@updateMode6:
	ld a,(wFileSelect.mode2)
	rst_jumpTable
	.dw @mode0
	.dw runTextInput
	.dw @mode2
	.dw setFileSelectModeTo1
	.dw textInput_waitForInput

@mode0:
	xor a
	ld (wSecretInputType),a
	jp func_02_465c

@mode2:
	ld hl,w4SecretBuffer
	ld de,wTmpcec0
	ld b,$20
	call copyMemory
	ld bc,$0100
	call secretFunctionCaller
	jp nz,fileSelect_printError

	ld a,($ced2)
	or a
	jr z,+

	ld a,($cec5)
.ifdef ROM_AGES
	dec a
.else; ROM_SEASONS
	or a
.endif
	jp z,fileSelect_printError
+
	call loadFile
	ld bc,$0400
	call secretFunctionCaller
	call initializeFile
	jp setFileSelectModeTo1


;;
; A secret entry menu called from in-game (not called from file select)
runSecretEntryMenu:
	call fileSelect_redrawDecorationsAndSetWramBank4
	call @func
	jp drawSecretInputCursors

@func:
	ld a,(wFileSelect.mode2)
	rst_jumpTable
	.dw @mode0
	.dw @mode1
	.dw @mode2
	.dw closeMenu
	.dw textInput_waitForInput

@mode0:
	ld a,GFXH_FILE_MENU_GFX
	call loadGfxHeader
	call func_02_465c
	jp fadeinFromWhite

; Run text input
@mode1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	jp runTextInput

; Check whether secret is good
@mode2:
	ld hl,w4SecretBuffer
	ld de,wTmpcec0
	ld b,$20
	call copyMemory

	; Unpack the secret (b=$01)
	ldbc $01,$03
	ld a,(wSecretInputType)
	rlca
	jr c,+
	ld c,$02
+
	call secretFunctionCaller
	jr nz,@invalidSecret

	; Verify the secret (b=$02)
	ld b,$02
	call secretFunctionCaller
	jr nz,@invalidSecret


	; [$cec4] = the unpacked secret's "wShortSecretIndex" value (only for short secret
	; types)
	ld a,($cec4)
	ld b,a
	ld a,(wSecretInputType)
	cp $ff
	jr nz,++

	; 5-letter secret from farore (doesn't check which 5-letter secret it is)
	xor a
	ld (wSecretInputType),a
	ld a,b
	jr @setTextInputResult

++
	cp $02
	jr z,@loadRingSecretData

	; 5-letter secret: check that [$cec4] == [wSecretInputType]&$3f (basically, this
	; is the short secret type that we're looking for, not somebody else's)
	and $3f
	sub b
	jr z,@setTextInputResult

@invalidSecret:
	ld a,$01

@setTextInputResult:
	ld (wTextInputResult),a
	jr nz,fileSelect_printError

	ld a,SND_SOLVEPUZZLE
	call playSound
	jp closeMenu

@loadRingSecretData:
	; Load the data from the ring secret (updates obtained rings)
	ldbc $04,$02
	call secretFunctionCaller
	xor a
	jr @setTextInputResult

;;
fileSelect_printError:
	ld a,SND_ERROR
	call playSound
	ld a,$10
	ld (wFileSelect.linkTimer),a
	ld a,$04
	ld (wFileSelect.mode2),a
	ld a,GFXH_SECRET_ENTRY_ERROR_LAYOUT
	call loadGfxHeader
	ld a,UNCMP_GFXH_08
	jp loadUncompressedGfxHeader

;;
; Wait for input while showing "That's Wrong" text.
textInput_waitForInput:
	ld hl,wFileSelect.linkTimer
	ld a,(hl)
	or a
	jr z,+

	dec (hl)
	ret
+
	ld a,(wKeysPressed)
	or a
	ret z

	ld a,$01
	ld (wFileSelect.mode2),a
;;
func_02_461c:
	ld a,GFXH_SECRET_ENTRY_LAYOUT
	call loadGfxHeader
	ld a,UNCMP_GFXH_08
	jp loadUncompressedGfxHeader

;;
; Returns in b the length of the buffer used. Ignores trailing spaces.
getNameBufferLength:
	ld hl,w4NameBuffer
	ld b,$05
	xor a
--
	cp (hl)
	jr nz,+
	ld (hl),$20
+
	inc l
	dec b
	jr nz,--

	ldd (hl),a
	ld b,$05
--
	ld a,(hl)
	sub $20
	ret nz

	ldd (hl),a
	dec b
	jr nz,--
	ret

;;
; Dunno exactly what this does after the jump
; @param a 1 for kid name, 0 for link name
copyNameToW4NameBuffer:
	ld (wFileSelect.textInputMode),a
	ld de,wLinkName
	cp $01
	jr nz,+
	ld e,<wKidName
+
	ld hl,w4NameBuffer
	ld b,$06
	call copyMemoryReverse
	ld a,$04
	ld (wFileSelect.textInputMaxCursorPos),a
	jr label_02_038

;;
func_02_465c:
	ld a,(wSecretInputType)
	bit 7,a
	jr nz,+

	ldbc 14, $81
	cp $02
	jr z,++

	ldbc 19, $82
	jr ++
+
	ld a,$ff
	ld (wLastSecretInputLength),a
	ldbc 4, $80
++
	ld a,b
	ld (wFileSelect.textInputMaxCursorPos),a
	ld a,c
	ld (wFileSelect.textInputMode),a
label_02_038:
	ld hl,wTmpcbb9
	ld b,$0a
	call clearMemory
	call textInput_loadCharacterGfx
	call disableLcd
	ld a,UNCMP_GFXH_0b
	call loadUncompressedGfxHeader
	ld a,PALH_05
	call loadPaletteHeader
	ld a,(wFileSelect.textInputMode)
	rlca
	jr c,@secretEntry

; Entering a name for the player or the kid

	ld a,GFXH_NAME_ENTRY
	call loadGfxHeader
	ld a,(wFileSelect.textInputMode)
	rrca
	jr c,+

; Entering a name for the player

	; Draw the file number
	ldh a,(<hActiveFileSlot)
	add $20
	ld (w4TileMap+$49),a
+
	ld a,UNCMP_GFXH_08
	call loadUncompressedGfxHeader
	jr @end

@secretEntry:
	ld a,(wFileSelect.textInputMaxCursorPos)
	ld hl,wLastSecretInputLength
	cp (hl)
	ld (hl),a
	ld hl,w4SecretBuffer
	ld b,$20
	ld a,$20
	call nz,fillMemory
	ld a,GFXH_SECRET_ENTRY_GFX
	call loadGfxHeader
	call func_02_461c
@end:
	call textInput_updateEntryCursor
	jp loadGfxRegisterState5AndIncFileSelectMode2

;;
; Name / secret selection
runTextInput:
	ld a,$01
	ld (wTextInputResult),a
	call getInputWithAutofire
	ld b,a
	call getHighestSetBit
	ret nc

	ld b,a
	ld hl,@soundEffects
	rst_addAToHl
	ld a,(hl)
	call playSound
	ld a,b
	rst_jumpTable
	.dw @aButton
	.dw @bButton
	.dw @selectButton
	.dw @startButton
	.dw @rightButton
	.dw @leftButton
	.dw @upButton
	.dw @downButton

@soundEffects:
	.db SND_SELECTITEM
	.db SND_CLINK
	.db SND_SELECTITEM
	.db SND_SELECTITEM
	.db SND_MENU_MOVE
	.db SND_MENU_MOVE
	.db SND_MENU_MOVE
	.db SND_MENU_MOVE

@aButton:
	ld hl,wFileSelect.cursorPos
	ldi a,(hl)
	cp $50
	jr nc,@lowerOptions

	call textInput_getCursorPosition
	and $0f
	ld hl,w4TileMap+$a3
	rst_addAToHl
	ld a,b
	swap a
	add a
	add a
	call multiplyABy16
	add hl,bc

.ifdef REGION_JP

	ld a,(hl)
	rrca
	and $3f
	ld c,a
	ld a,(wFileSelect.textInputMode)
	rlca
	jr nc,@notEnteringSecret

	ld a,c
	sub $2e
	cp $0a
	jr nc,@notEnteringSecret
	add $30
	ld c,a
	jr @gotCharacter

@notEnteringSecret:
	ld a,c
	sub $37
	jr c,@label_02_046
	ld c,$2d
	jr z,@gotCharacter
	ld c,$20
	dec a
	jr z,@gotCharacter
	dec a
	ld e,a
	call textInput_getOutputAddress
	ld a,(hl)
	call func_02_494a
	jr c,@gotCharacter
	ld a,(wFileSelect.textInputCursorPos)
	or a
	jr z,++
	dec hl
	ld a,(hl)
	call func_02_494a
	jr nc,++
	ld hl,wFileSelect.textInputCursorPos
	dec (hl)
	jr @gotCharacter
++
	ld a,SND_ERROR
	jp playSound

@label_02_046:
	ld a,(wFileSelect.kanaMode)
	or a
	ld a,$60
	jr z,+
	ld a,$b0
+
	add c
	ld c,a

.else ; REGION_US, REGION_EU

	ld c,$20
	ld a,(hl)
	cp $02
	jr z,@gotCharacter

	rrca
	and $3f
	add $40

	ld c,a
	ld a,(wFileSelect.textInputMode)
	rlca
	jr nc,@gotCharacter

	ld a,c
	ld hl,secretSymbols-$40
	rst_addAToHl
	ld c,(hl)
.endif

@gotCharacter:
	call textInput_getOutputAddress
	ld (hl),c
@selectionRight:
	ld hl,wFileSelect.textInputCursorPos
	inc (hl)
	ld a,(wFileSelect.textInputMaxCursorPos)
	cp (hl)
	jr nc,@updateEntryCursor
	ld (hl),a
@updateEntryCursor:
	jp textInput_updateEntryCursor

@lowerOptions:
	ld a,(wFileSelect.textInputMode)
	rlca
	ld a,(wFileSelect.cursorPos2)
	jr c,@secretTable

@nameTable:
	rst_jumpTable
	.dw @selectionLeft
	.dw @selectionRight
.ifdef REGION_JP
	.dw @selectKatakana
	.dw @selectHiragana
.endif
	.dw @startButton

@secretTable:
	rst_jumpTable
	.dw @selectionLeft
	.dw @selectionRight
	.dw @back
	.dw @startButton

@bButton:
	call textInput_getOutputAddress
	ld (hl),$20
@selectionLeft:
	ld hl,wFileSelect.textInputCursorPos
	dec (hl)
	bit 7,(hl)
	jr z,@updateEntryCursor

	ld (hl),$00
	jr @updateEntryCursor


.ifdef REGION_JP

@selectButton:
	ld a,(wFileSelect.kanaMode)
	xor $01
	jr ++

@selectKatakana:
	ld a,$01
	jr ++

@selectHiragana:
@back:
	xor a
++
	ld (wFileSelect.kanaMode),a
	ld a,(wFileSelect.textInputMode)
	rlca
	jr c,++
	call textInput_loadCharacterGfx
	ld a,UNCMP_GFXH_0b
	jp loadUncompressedGfxHeader
++
	xor a
	ld (wFileSelect.kanaMode),a
	ld hl,wFileSelect.cursorPos
	ld a,$57
	ldi (hl),a
	ld a,$02
	cp (hl)
	ldd (hl),a
	ret nz
	ld a,$03
	ld (wFileSelect.mode2),a
	ret

.else ; REGION_US, REGION_EU

@selectButton:
	ret

@back:
	ld a,(wFileSelect.textInputMode)
	rlca
	ret nc

	xor a
	ld (wTmpcbb9),a
	ld hl,wFileSelect.cursorPos
	ld a,$57
	ldi (hl),a
	ld a,$02
	cp (hl)
	ldd (hl),a
	ret nz

	ld a,$03
	ld (wFileSelect.mode2),a
	ret
.endif


@rightButton:
	ld c,$01
	jr @leftOrRight
@leftButton:
	ld c,$ff

.ifdef REGION_JP

@leftOrRight:
	ld hl,wFileSelect.cursorPos
	ld a,(hl)
	cp $50
	jr nc,@label_02_056
@label_02_055:
	add c
	and $0f
	cp $0c
	jr nc,@label_02_055
	ld c,a
	ld a,(hl)
	and $f0
	add c
	ldi (hl),a
	ld (hl),$80
	ret
@label_02_056:
	inc l
	ld b,$05
	ld a,(wFileSelect.textInputMode)
	rlca
	ld a,(hl)
	jr nc,@label_02_057
	dec b
@label_02_057:
	add c
	and $0f
	cp b
	jr nc,@label_02_057
	ld (hl),a
	jp textInput_lowerOption_updateFileSelectCursorPos

.else ; REGION_US, REGION_EU

@leftOrRight:
	ldde $04, $0d
	ld a,(wFileSelect.textInputMode)
	rlca
	jr c,+
	ldde $03, $0c
+
	ld hl,wFileSelect.cursorPos
	ld a,(hl)
	cp $50
	jr nc,@@lowerOptions
-
	add c
	and $0f
	cp e
	jr nc,-

	ld c,a
	ld a,(hl)
	and $f0
	add c
	ldi (hl),a
	ld (hl),$80
	ret
@@lowerOptions:
	inc l
	ld b,d
	ld a,(hl)
-
	add c
	and $0f
	cp b
	jr nc,-

	ld (hl),a
	jp textInput_lowerOption_updateFileSelectCursorPos
.endif

@upButton:
	ld c,$f0
	jr @upOrDown
@downButton:
	ld c,$10

@upOrDown:
	ld hl,wFileSelect.cursorPos
	ld a,(hl)
-
	add c
	and $70
	cp $60
	jr nc,-

	ld c,a
	ld a,(hl)
	and $0f
	add c
	ldi (hl),a
	ld (hl),$80
	cp $50
	ret c
	jp textInput_lowerOption_updateFileSelectCursorPos2

@startButton:
	ld hl,wFileSelect.cursorPos
	ld a,$5a
	ldi (hl),a
	ld a,(wFileSelect.textInputMode)
	rlca

.ifdef REGION_JP
	ld a,$04
.else
	ld a,$02
.endif
	jr nc,+
	ld a,$03
+
	cp (hl)
	ldd (hl),a
	ret nz
	jp incFileSelectMode2

;;
; Returns the position of the character within w4TileMap in A, relative to the
; first character at position $a3.
textInput_getCursorPosition:
	ld a,(wFileSelect.cursorPos)
	ld c,a
	and $f0
	ld b,a
	ld a,c
	and $0f

.ifdef REGION_JP
	ld c,$02
	cp $0a
	jr nc,++
	dec c
	cp $05
	jr nc,++
	dec c
++
	add c
	add b
	ret

.else

	ld c,a
	push de
	ldde $08, $01
	ld a,(wFileSelect.textInputMode)
	rlca
	jr c,+
	ldde $06, $02
+
	ld a,c
	cp d
	ld c,e
	pop de
	jr nc,+
	ld c,$00
+
	add c
	add b
	ret
.endif

;;
; Draws cursors for the currently selected character, and the position in the
; input string.
drawNameInputCursors:
	call textInput_getCursorPosition
	cp $50
	jr nc,@lowerOptions

; Standard characters
@upperOptions:
	ld b,a
	and $0f
	add a
	add a
	add a
	ld c,a
	ld a,b
	and $f0
	ld b,a
	ld hl,@cursorOnCharacterSprites
	call addSpritesToOam_withOffset
	jr ++

; Extra options like cursor left, cursor right, back, OK
@lowerOptions:

.ifdef REGION_JP
	ld a,(wFileSelect.cursorPos2)
	ld hl,@jpInputOffsets
.else
	ld a,(wFileSelect.textInputMode)
	rlca
	ld hl,@secretInputOffsets
	jr c,+
	ld hl,@nameInputOffsets
+
	ld a,(wFileSelect.cursorPos2)
.endif
	rst_addAToHl
	ld c,(hl)
	ld b,$00
	ld hl,@lowerOptionCursorSprites
	call addSpritesToOam_withOffset
++
	ld a,(wFileSelect.textInputCursorPos)
	add a
	add a
	add a
	ld c,a
	ld b,$00
	ld hl,@textInputCursorSprite
	jp addSpritesToOam_withOffset

; The cursor and blue highlight for normal characters
@cursorOnCharacterSprites:
	.db $02
	.db $3a $20 $2c $02 ; Cursor
	.db $38 $20 $2a $81 ; Blue highlight

.ifdef REGION_JP
	@jpInputOffsets:
		.db $18 $30 $48 $60 $78
.else
	@nameInputOffsets:
		.db $18 $30 $78
	@secretInputOffsets:
		.db $18 $30 $48 $60
.endif

; The cursor for the bottom options
@lowerOptionCursorSprites:
	.db $02
	.db $8a $08 $2c $01 ; Left
	.db $8a $10 $2c $01 ; Right

; The cursor at the top of the screen where the secret/name text is.
@textInputCursorSprite:
	.db $01
	.db $1a $58 $2c $82

;;
; Same as drawNameInputCursors, but for secrets.
drawSecretInputCursors:
	call textInput_getCursorPosition
	cp $50
	jr nc,@lowerOptions

; Standard characters
@upperOptions:
	ld b,a
	and $0f
	add a
	add a
	add a
	ld c,a
	ld a,b
	and $f0
	ld b,a
	ld hl,@cursorOnCharacterSprites
	call addSpritesToOam_withOffset
	jr ++

; Extra options like cursor left, cursor right, back, OK
@lowerOptions:
	ld a,(wFileSelect.cursorPos2)
	ld hl,@lowerOptionsOffsets
	rst_addAToHl
	ld c,(hl)
	ld b,$00
	ld hl,@lowerOptionCursorSprites
	call addSpritesToOam_withOffset
++
	ld c,$0a
	ld a,(wFileSelect.textInputCursorPos)
	cp c
	ld b,$00
	jr c,+

	ld b,$10
	sub c
+
	cp $05
	jr c,+
	inc a
+
	add a
	add a
	add a
	ld c,a
	ld hl,@textInputCursorSprite
	jp addSpritesToOam_withOffset

@cursorOnCharacterSprites:
	.db $02
	.db $3a $20 $2c $02 ; Cursor
	.db $38 $20 $2a $81 ; Blue highlight

@lowerOptionsOffsets:
	.db $18 $30 $54 $78

@lowerOptionCursorSprites:
	.db $02
	.db $8a $08 $2c $01
	.db $8a $10 $2c $01

@textInputCursorSprite:
	.db $01
	.db $12 $38 $2c $02

;;
; Updates wFileSelect.cursorPos (the index for the upper options) based on
; wFileSelect.cursorPos2 (the index for the lower options)
textInput_lowerOption_updateFileSelectCursorPos:
	ld a,(wFileSelect.cursorPos2)
	ld e,a
	ld d,$ff
	call textInput_mapUpperXToLowerX
	ld a,b
	ld (wFileSelect.cursorPos),a
	ret

;;
; Reverse of above
textInput_lowerOption_updateFileSelectCursorPos2:
	ld a,(wFileSelect.cursorPos)
	ld d,a
	ld e,$ff
	call textInput_mapUpperXToLowerX
	ld a,c
	ld (wFileSelect.cursorPos2),a
	ret

;;
textInput_mapUpperXToLowerX:
	ld a,(wFileSelect.textInputMode)
	rlca
	ld hl,@nameTable
	jr nc,@label
	ld hl,@secretTable
@label:
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	cp e
	ret z

	ld a,b
	cp d
	jr nz,@label
	ret

.ifdef REGION_JP
	@nameTable:
		.db $50 $00
		.db $51 $00
		.db $52 $00
		.db $53 $01
		.db $54 $01
		.db $55 $02
		.db $56 $02
		.db $57 $02
		.db $58 $03
		.db $59 $03
		.db $5a $04
		.db $5b $04
		.db $ff $ff

	@secretTable:
		.db $50 $00
		.db $51 $00
		.db $52 $00
		.db $53 $01
		.db $54 $01
		.db $55 $02
		.db $56 $02
		.db $57 $02
		.db $58 $02
		.db $59 $03
		.db $5a $03
		.db $5b $03
		.db $ff $ff

.else ; REGION_US, REGION_EU

	@nameTable:
		.db $50 $00
		.db $51 $00
		.db $52 $00
		.db $53 $01
		.db $54 $01
		.db $55 $01
		.db $56 $02
		.db $57 $02
		.db $58 $02
		.db $59 $02
		.db $5a $02
		.db $5b $02
		.db $5c $02
		.db $ff $ff

	@secretTable:
		.db $50 $00
		.db $51 $00
		.db $52 $00
		.db $53 $01
		.db $54 $01
		.db $55 $02
		.db $56 $02
		.db $57 $02
		.db $58 $02
		.db $59 $03
		.db $5a $03
		.db $5b $03
		.db $5c $03
		.db $ff $ff
.endif

;;
; Used only in japanese version
func_02_494a:
	push hl
	ld hl,@table2
	bit 0,e
	jr nz,+
	ld hl,@table1
+
	cp $60
	ccf
	jr nc,@end

	ld b,$00
	cp $b0
	jr c,+

	ld b,$50
	sub b
+
	ld c,a
-
	ldi a,(hl)
	or a
	jr z,@end

	cp c
	ldi a,(hl)
	jr nz,-

	add b
	ld c,a
	scf
@end:
	pop hl
	ret

@table1:
	.db $65 $97
	.db $66 $98
	.db $67 $99
	.db $68 $9a
	.db $69 $9b
	.db $6a $9c
	.db $6b $9d
	.db $6c $9e
	.db $6d $9f
	.db $6e $a0
	.db $6f $a1
	.db $70 $a2
	.db $71 $a3
	.db $72 $a4
	.db $73 $a5
	.db $79 $a6
	.db $7a $a7
	.db $7b $a8
	.db $7c $a9
	.db $7d $aa
	.db $00

@table2:
	.db $79 $ab
	.db $7a $ac
	.db $7b $ad
	.db $7c $ae
	.db $7d $af
	.db $00

;;
; Load the appropriate characters based on whether it's doing name input or
; secret input.
textInput_loadCharacterGfx:
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w5NameEntryCharacterGfx
	ld ($ff00+R_SVBK),a
	xor a
	ld (wFileSelect.fontXor),a
	ld de,w5NameEntryCharacterGfx

.ifdef REGION_JP
	ldbc $2e, $60
	ld a,(wFileSelect.kanaMode)
	or a
	jr z,+
	ld c,$b0
+
	call copyTextCharacters
	ld hl,data_02_4a28
	ld b,$09
	ld a,(wFileSelect.textInputMode)
	rlca
	jr nc,++
	inc hl
	inc b
	ld c,$30
++
	call copyTextCharacters
	call copyTextCharactersFromHlUntilNull

.else

	ld a,(wFileSelect.textInputMode)
	rlca
	jr c,+

	ldbc $3b, $40
	call copyTextCharacters
	jr ++
+
	ld hl,secretSymbols
	ld b,$40
	call copyTextCharactersFromHlUntilNull
++
.endif

	pop af
	ld ($ff00+R_SVBK),a
	ret

;;
; @param	b			Number of characters to copy
; @param	c			First character to copy
; @param	de			Destination
; @param	wFileSelect.fontXor	Value to xor every other byte with
copyTextCharacters:
	push bc
	ld a,c
	ld c,$00
	call copyTextCharacterGfx
	pop bc
	inc c
	dec b
	jr nz,copyTextCharacters
	ret


.ifdef REGION_JP

data_02_4a28:
	.db $2d $20 $0e $0f $00

.endif

;;
; Loads variables related to each of the 3 files (heart display, etc)
loadFileDisplayVariables:
	ld a,$02
	ldh (<hActiveFileSlot),a
@nextFile:
	call loadFile
	ldh a,(<hActiveFileSlot)
	ld d,$00
	call getFileDisplayVariableAddress
	ld a,c
	ldi (hl),a
	ldi (hl),a
	ld a,(wLinkMaxHealth)
	ldi (hl),a
	ldi (hl),a
	ld a,(wDeathCounter)
	ldi (hl),a
	ld a,(wDeathCounter+1)
	ldi (hl),a
	ld a,(wFileIsLinkedGame)
	ldi (hl),a
	ld a,(wFileIsHeroGame)
	add a
	ld e,a
	ld a,(wFileIsCompleted)
	or e
	ldi (hl),a
	ldh a,(<hActiveFileSlot)
	add a
	ld e,a
	add a
	add e
	ld hl,w4NameBuffer
	rst_addAToHl
	ld de,wLinkName
	ld b,$06
	call copyMemoryReverse
	ld hl,hActiveFileSlot
	dec (hl)
	bit 7,(hl)
	jr z,@nextFile
	inc (hl)
	ret

;;
; Updates the displayed text and the cursor?
textInput_updateEntryCursor:
	xor a
	call textInput_getOutputAddressOffset
	ld de,w4GfxBuf1
	ld b,$18
	call copyTextCharactersFromHl
	xor a
	ld (wFileSelect.fontXor),a
	ld a,UNCMP_GFXH_07
	jp loadUncompressedGfxHeader

;;
textInput_getOutputAddress:
	ld a,(wFileSelect.textInputCursorPos)
textInput_getOutputAddressOffset:
	ld l,a
	ld a,(wFileSelect.textInputMode)
	rlca
	ld a,l
	ld hl,w4NameBuffer
	jr nc,+
	ld hl,w4SecretBuffer
+
	rst_addAToHl
	ret

;;
fileSelectDrawHeartsAndDeathCounter:
	ld a,(wFileSelect.mode)
	cp $03
	ret z

	ld a,GFXH_FILE_MENU_LAYOUT
	call loadGfxHeader

	; Jump if cursor isn't on a file
	ld a,(wFileSelect.cursorPos)
	cp $03
	jr nc,+++

	; Jump if the cursor is on an empty file
	ld d,$00
	call getFileDisplayVariableAddress
	bit 7,(hl)
	jr nz,+++

	; Draw death count
	ld d,$04
	call getFileDisplayVariableAddress_paramE
	ld e,l
	ld d,h
	ld hl,w4TileMap+$130
	ld b,$10
	ld a,(de)
	and $0f
	add b
	ldd (hl),a
	ld a,(de)
	and $f0
	swap a
	add b
	ldd (hl),a
	inc e
	ld a,(de)
	add b
	ldd (hl),a

	; Draw hearts
	ld a,(wFileSelect.cursorPos)
	ld d,$02
	call getFileDisplayVariableAddress
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	ld hl,w4TileMap+$14a
	call fileSelectDrawHeartDisplay
+++
	; Load the tile map that was just drawn on
	ld a,UNCMP_GFXH_08
	jp loadUncompressedGfxHeader

;;
; Draws the cursor on the main file select and "new game/secret/link" screen
fileSelectDrawAcornCursor:
	ld a,(wFileSelect.cursorOffset)
	ld hl,@table
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld c,a
	ld b,(hl)
	push bc
	ld hl,@sprite
	ld a,(wFileSelect.cursorPos)
	bit 7,a
	call z,@func
	pop de
	ld hl,@sprite
	ld a,(wFileSelect.cursorPos2)
	bit 7,a
	ret nz
;;
@func:
	call addDoubleIndexToDe
	ld a,(de)
	ld b,a
	inc de
	ld a,(de)
	ld c,a
	jp addSpritesToOam_withOffset

@sprite:
	.db $01
	.db $10 $08 $28 $04

@table:
	.dw @table2
	.dw @table1
	.dw @table1
	.dw @table4
	.dw @table5
	.dw @table6
	.dw @table3

@table1:
	.dw @data11
	.dw @data12

@data11:
	.db $34 $08
	.db $4c $08
	.db $64 $08
	.db $e0 $e0
@data12:
	.db $7a $22
	.db $7a $5a

@table3:
	.dw @data31

@data31:
	.db $34 $08
	.db $4c $08
	.db $64 $08
	.db $7a $20

@table4:
	.dw @data41
	.dw @data12

@data41:
	.db $34 $08
	.db $4c $08
	.db $64 $08
	.db $7a $22

@table2:
	.dw @data21
	.dw @data12

@data21:
	.db $34 $50
	.db $4c $50
	.db $64 $50
	.db $7a $22

@table5:
	.dw @data51
	.dw @data12

@data51:
	.db $34 $08
	.db $4c $08
	.db $64 $08
	.db $7a $22

@table6:
	.dw @data61

@data61:
	.db $38 $20
	.db $50 $20
	.db $68 $20

;;
; This is probably for linking to transfer ring secrets
runGameLinkMenu:
	ld hl,$cbb6
	inc (hl)
	call fileSelect_redrawDecorationsAndSetWramBank4

;;
; Game link
fileSelectMode7:
	call @mode7States
	ld a,(wFileSelect.mode2)
	cp $06
	ret z

	cp $03
	ret c

	call fileSelectDrawAcornCursor
	jp fileSelectDrawLinkInOtherGame

@mode7States:
	ld a,(wFileSelect.mode2)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

;;
; State 0: initialization
@state0:
	call disableLcd
	ld a,GFXH_FILE_MENU_GFX
	call loadGfxHeader
	ld a,GFXH_GAME_LINK
	call loadGfxHeader
	ld a,PALH_05
	call loadPaletteHeader
	ld a,UNCMP_GFXH_08
	call loadUncompressedGfxHeader

	ld hl,w4NameBuffer
	ld b,$20
	call clearMemory

	call textInput_updateEntryCursor
	call serialFunc_0c85

	ld a,$04
	ldh (<hFFBE),a
	xor a
	ldh (<hSerialLinkState),a
	ld ($cbc2),a

	ld hl,wFileSelect.linkTimer
	ld a,$f0
	ldi (hl),a
	ld a,$1e
	ld (hl),a

	jp loadGfxRegisterState5AndIncFileSelectMode2

;;
; State 1: waiting for response
@state1:
	ldh a,(<hSerialInterruptBehaviour)
	or a
	jr nz,++

	ldh a,(<hFFBD)
	or a
	jp nz,@func_02_4c55
	ld hl,wFileSelect.linkTimer
	dec (hl)
	jr nz,+

	ld a,$80
	ldh (<hFFBD),a
	jp @func_02_4c55
+
	jp serialFunc_0c73
++
	ld a,(wFileSelect.cbc0)
	or a
	jr z,+

	dec a
	ld (wFileSelect.cbc0),a
	ret
+
	call serialFunc_0c8d
	ldh a,(<hFFBD)
	or a
	jr z,+

	cp $83
	jr z,+

	jp nz,@func_02_4c55
+
	ldh a,(<hSerialLinkState)
	cp $07
	ret nz
	ld e,$03
-
	dec e
	ld d,$00
	call getFileDisplayVariableAddress_paramE
	bit 7,(hl)
	jr z,+

	ld a,e
	or a
	jr nz,-

	ld a,$85
	ld ($cbc2),a
	ld a,$ff
	ld (wFileSelect.cursorPos),a
	jp @func_02_4c4b
+
	jp loadGfxRegisterState5AndIncFileSelectMode2

;;
; State 2: Reloading graphics to show other files
@state2:
	call serialFunc_0c8d
	ld a,$06
	ld (wFileSelect.cursorOffset),a
	xor a
	call func_02_4149
	call disableLcd
	ld a,GFXH_FILE_MENU
	call loadGfxHeader
	ld a,GFXH_QUIT_GFX
	call loadGfxHeader
	call textInput_updateEntryCursor
	call fileSelectDrawHeartsAndDeathCounter
	jp loadGfxRegisterState5AndIncFileSelectMode2

;;
; State 3: Selecting file from other game
@state3:
	call serialFunc_0c8d
	call fileSelectUpdateInput
	jr nz,@selectedSomething

	ld a,(wKeysJustPressed)
	bit BTN_BIT_B,a
	ret z

.ifdef REGION_JP

@moveCursorToQuit:
	ld a,$03
	ld (wFileSelect.cursorPos),a
	ld a,$8f
	ld ($cbc2),a

@selectedSomething:
	ld a,(wFileSelect.cursorPos)
	cp $03
	jr z,@func_02_4c4b

.else

@moveCursorToQuit:
	ld a,$03
	ld (wFileSelect.cursorPos),a
	ld a,$8f
	ld ($cbc2),a
	jr @func_02_4c4b

@selectedSomething:
	ld a,(wFileSelect.cursorPos)
	cp $03
	jr z,@moveCursorToQuit

.endif

	ld d,FileDisplayStruct.b0
	call getFileDisplayVariableAddress
	bit 7,(hl) ; Check if file is blank
	jr z,+

	ld a,SND_ERROR
	jp playSound
+
	ld a,(wOpenedMenuType)
	cp MENU_RING_LINK
	jr nz,+

	; Link menu from blue snake
	ld a,$0c
	ldh (<hSerialLinkState),a
	ld a,$05
	ld (wFileSelect.mode2),a
	ret
+
	; Linking from file select screen
	ld a,$08
	ldh (<hSerialLinkState),a
	jp loadGfxRegisterState5AndIncFileSelectMode2

;;
@func_02_4c4b:
	ld a,$08
	ldh (<hSerialLinkState),a
	ld a,$05
	ld (wFileSelect.mode2),a
	ret

;;
@func_02_4c55:
	call disableLcd
	ld a,GFXH_ERROR_TEXT
	call loadGfxHeader
	call loadGfxRegisterState5AndIncFileSelectMode2
	ld a,$08
	ldh (<hSerialLinkState),a
	ld a,$06
	ld (wFileSelect.mode2),a
	ld a,180
	ld (wFileSelect.linkTimer),a
	ldh a,(<hFFBD)
	ld (wFileSelect.cbc0),a
	ret

;;
; Selected a file from the file select screen
@state4:
	call serialFunc_0c8d
	ldh a,(<hSerialInterruptBehaviour)
	or a
	ret nz

	call loadFile

	; set hl = wRingFortuneStuff + fileIndex * $16
	ld a,(wFileSelect.cursorPos)
	inc a
	ld hl,w4RingFortuneStuff
	ld bc,$0016
-
	dec a
	jr z,+

	add hl,bc
	jr -
+
	; Copy to the first $16 bytes of the new file to create ($c600-$c615). Includes link/child
	; name, animal companion, etc.
	ld b,$16
	ld de,wc600Block
	call copyMemory
	ld hl,wFileIsLinkedGame
	set 0,(hl)
	ld l,<wFileIsCompleted
	ld (hl),$00
	call initializeFile
	ld a,SND_SELECTITEM
	call playSound
	jp setFileSelectModeTo1

;;
; State 5: Connected successfully, waiting for data?
@state5:
	call serialFunc_0c8d
	ldh a,(<hSerialInterruptBehaviour)
	or a
	ret nz

@cancelLink:
	ld a,(wOpenedMenuType)
	cp MENU_RING_LINK
	jp z,closeMenu

	ld a,$00
	jp setFileSelectMode

;;
; State 6: error
@state6:
	call serialFunc_0c8d
	ldh a,(<hSerialInterruptBehaviour)
	or a
	ret nz

	ld a,(wFileSelect.cbc0)
	ldh (<hFFBD),a
	ld a,(wKeysJustPressed)
	or a
	jr nz,@cancelLink

	ld hl,wFileSelect.linkTimer
	dec (hl)
	ret nz
	jr @cancelLink

;;
; Clears the OAM, draws vines and stuff, sets wram bank 4
fileSelect_redrawDecorationsAndSetWramBank4:
	call clearOam
	ld a,$04
	ld ($ff00+R_SVBK),a
	ld hl,@sprites
	jp addSpritesToOam

@sprites:
	.db $10
	.db $23 $0a $20 $05
	.db $23 $12 $22 $05
	.db $33 $06 $20 $05
	.db $33 $0e $22 $05
	.db $0f $07 $26 $05
	.db $3b $16 $20 $25
	.db $3b $0e $22 $25
	.db $17 $0a $24 $25
	.db $21 $96 $20 $05
	.db $21 $9e $22 $05
	.db $17 $9b $26 $65
	.db $14 $9d $24 $05
	.db $31 $a2 $20 $25
	.db $31 $9a $22 $25
	.db $39 $92 $20 $05
	.db $39 $9a $22 $05

;;
fileSelectDrawLinkInOtherGame:
.ifdef ROM_AGES
	ld b,$00
.else
	ld b,$04
.endif
	jr +

;;
; Draws link and nayru/din on the file select
fileSelectDrawLink:
.ifdef ROM_AGES
	ld b,$04
.else
	ld b,$00
.endif
+
	ld a,(wFileSelect.cursorPos)
	cp $03
	ret nc

	ld d,$00
	call getFileDisplayVariableAddress
	ld c,$00
	; Jump if it's a blank file
	bit 7,(hl)
	jr nz,+

	push bc
	push de

	; Draw triforce symbol for hero's files
	ld d,$07
	call getFileDisplayVariableAddress_paramE
	xor a
	ld b,$10
	bit 1,(hl)
	call nz,@draw

	; Check whether file is linked
	pop de
	pop bc
	ld d,$06
	call getFileDisplayVariableAddress_paramE
	inc c
	ldi a,(hl)
	rrca
	jr c,+

	; Not linked; check whether the file is completed
	inc c
	bit 0,(hl)
	jr nz,+
	inc c
+
	ld a,(wTmpcbb6)
	and $10
	ld a,c
	jr z,@draw
	add $08
;;
@draw:
	add b
	ld hl,@spriteTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	jp addSpritesToOam

@spriteTable:
	; Seasons (frame 0)
	.db @sprites0-CADDR ; $00 - link standing still (blank file)
	.db @sprites3-CADDR ; $01 - linked file (rod of seasons)
	.db @sprites7-CADDR ; $02 - completed file (with din)
	.db @sprites1-CADDR ; $03 - unlinked file

	; Ages (frame 0)
	.db @sprites0-CADDR ; $04 - link standing still (blank file)
	.db @sprites5-CADDR ; $05 - linked file (harp of ages)
	.db @sprites9-CADDR ; $06 - completed file (with nayru)
	.db @sprites1-CADDR ; $07 - unlinked file

	; Seasons (frame 1)
	.db @sprites0-CADDR
	.db @sprites4-CADDR
	.db @sprites8-CADDR
	.db @sprites2-CADDR

	; Ages (frame 1)
	.db @sprites0-CADDR
	.db @sprites6-CADDR
	.db @spritesa-CADDR
	.db @sprites2-CADDR

	; $10 - Triforce symbol for hero's file
	.db @spritesb-CADDR

;;
@sprites0:
	.db $02
	.db $4e $58 $04 $00
	.db $4e $60 $06 $00

@sprites1:
	.db $02
	.db $4e $58 $00 $00
	.db $4e $60 $02 $00

@sprites2:
	.db $02
	.db $4e $58 $02 $20
	.db $4e $60 $00 $20

@sprites3:
	.db $04
	.db $4e $58 $0a $20
	.db $4e $60 $08 $20
	.db $4e $63 $1c $22
	.db $4e $6b $1a $22

@sprites4:
	.db $04
	.db $4e $58 $0e $20
	.db $4e $60 $0c $20
	.db $4e $68 $1c $22
	.db $4e $70 $1a $22

@sprites5:
	.db $03
	.db $4e $58 $12 $20
	.db $4e $60 $10 $20
	.db $4e $64 $14 $22

@sprites6:
	.db $03
	.db $4e $58 $18 $20
	.db $4e $60 $16 $20
	.db $4e $64 $14 $22

@sprites7:
	.db $05
	.db $4e $58 $00 $00
	.db $4e $60 $02 $00
	.db $4e $68 $00 $0a
	.db $4e $70 $02 $0a
	.db $3e $6d $04 $0a

@sprites8:
	.db $05
	.db $4e $58 $02 $20
	.db $4e $60 $00 $20
	.db $4e $68 $02 $2a
	.db $4e $70 $00 $2a
	.db $3e $6b $04 $2a

@sprites9:
	.db $04
	.db $4e $58 $00 $00
	.db $4e $60 $02 $00
	.db $4e $68 $06 $09
	.db $4e $70 $08 $09

@spritesa:
	.db $04
	.db $4e $58 $02 $20
	.db $4e $60 $00 $20
	.db $4e $68 $08 $29
	.db $4e $70 $06 $29

@spritesb:
	.db $02
	.db $4a $8c $30 $06
	.db $4a $94 $32 $06

secretTextTable:
	.dw @text0
	.dw @text1
	.dw @text2
	.dw @text3
	.dw @text4
	.dw @text5
	.dw @text6
	.dw @text7
	.dw @text8
	.dw @text9
	.dw @texta
	.dw @textb
	.dw @textc
	.dw @textd
	.dw @texte
	.dw @textf
	.dw @text10
	.dw @text11
	.dw @text12
	.dw @text13
	.dw @text14
	.dw @text15
	.dw @text16
	.dw @text17
	.dw @text18
	.dw @text19


.ifdef REGION_JP

@text0: ; TODO: what is this?
	.db $1f $2d $61 $62 $67 $69 $6a $6b
	.db $6c $6d $a1 $72 $a4 $78 $79 $85
	.db $01 $8d $b1 $b5 $ea $ed $e3 $c3
	.db $fa $d0 $d6 $d7 $00

@text1:
	.asc "--------" 0

; WLA doesn't currently support non-ascii characters

@text2: ; の　あいことば
	.db $78 $20 $60 $61 $69 $73 $a6 $00

@text3: ; ホロドラムへ
	.db $cd $da $f5 $d6 $d0 $7c $00

@text4: ; ラブレンヌへ
	.db $d6 $f8 $d9 $dd $c6 $7c $00

@text5: ; ゆびわ
	.db $84 $a7 $8b $00

@text6: ; とけいやウラ
	.db $73 $68 $61 $83 $b2 $d6 $00

@text7: ; ギーニ
	.db $e8 $2d $c5 $00

@text8: ; ウーラ
	.db $b2 $2d $d6 $00

@text9: ; すもぐりめいじん
	.db $6c $82 $99 $87 $81 $61 $9d $8d $00

@texta: ; ウーラコクホウ
	.db $b2 $2d $d6 $b9 $b7 $cd $b2 $00

@textb: ; かいぞく
	.db $65 $61 $a0 $67 $00

@textc: ; 大ようせい
	.db $06 $27 $85 $62 $6d $61 $00

@textd: ; デクナッツ
	.db $f4 $b7 $c4 $e3 $c1 $00

@texte: ; ダイゴロン
	.db $f1 $b1 $eb $da $dd $00

@textf: ; ルール村ちょう
	.db $d8 $2d $d8 $06 $01 $70 $96 $62 $00

@text10: ; キングゾーラ
	.db $b6 $dd $e9 $f0 $2d $d6 $00

@text11: ; ヤンチャようせい
	.db $d3 $dd $c0 $e4 $85 $62 $6d $61 $00

@text12: ; トカゲ人
	.db $c3 $b5 $ea $06 $31 $00

@text13: ; プレンちょうちょう
	.db $fd $d9 $dd $70 $96 $62 $70 $96 $62 $00

@text14: ; としょかん
	.db $73 $6b $96 $65 $8d $00

@text15: ; トロイ
	.db $c3 $da $b1 $00

@text16: ; ママム●ヤン
	.db $ce $ce $d0 $5f $d3 $dd $00

@text17: ; チングル
	.db $c0 $dd $b7 $d8 $00

@text18: ; ゴロンちょうろう
	.db $eb $da $dd $70 $96 $62 $8a $62 $00

@text19: ; シメトリ村
	.db $bb $d1 $c3 $d7 $06 $01 $00

.else ; REGION_US, REGION_EU

@text0:
.ifdef ROM_SEASONS
	.db 0
.endif

@text1:
	.asc "--------" 0

@text2:
	.asc " Secret" 0

@text3:
	.asc "Holodrum" 0

@text4:
	.asc "Labrynna" 0

@text5:
	.asc "Ring" 0

@text6:
	.asc "ClockShop" 0

@text7:
	.asc "Graveyard" 0

@text8:
	.asc "Subrosian" 0

@text9:
	.asc "Diver" 0

@texta:
	.asc "Smith" 0

@textb:
	.asc "Pirate" 0

@textc:
	.asc "Temple" 0

@textd:
	.asc "Deku" 0

@texte:
	.asc "Biggoron" 0

@textf:
	.asc "Ruul" 0

@text10:
	.asc "K Zora" 0

@text11:
	.asc "Fairy" 0

@text12:
	.asc "Tokay" 0

@text13:
	.asc "Plen" 0

@text14:
	.asc "Library" 0

@text15:
	.asc "Troy" 0

@text16:
	.asc "Mamamu" 0

@text17:
	.asc "Tingle" 0

@text18:
	.asc "Elder" 0

@text19:
	.asc "Symmetry" 0

.endif ; REGION_US, REGION_EU

;;
; @param h Index of function to run
; @param l Parameter to function
runBank2Function:
	ld c,l
	ld a,h
	rst_jumpTable
	.dw loadCommonGraphics_body
	.dw updateStatusBar_body
	.dw hideStatusBar_body
	.dw showStatusBar_body
	.dw saveGraphicsOnEnterMenu_body
	.dw reloadGraphicsOnExitMenu_body
	.dw openMenu_body
	.dw copyW2TilesetBgPalettesToW4PaletteData_body
	.dw copyW4PaletteDataToW2TilesetBgPalettes_body

;;
hideStatusBar_body:
	ld a,$04
	ld ($ff00+R_SVBK),a
	ld hl,wDontUpdateStatusBar

	; If (wDontUpdateStatusBar) isn't $77, set the sprite priority bit?
	ld a,(hl)
	ld (hl),$ff
	cp $77
	ld a,$80
	jr nz,+
	xor a
+
	ld hl,w4StatusBarAttributeMap
	ld b,$40
	call fillMemory

	ld hl,w4StatusBarTileMap
	ld b,$40
	call clearMemory

	xor a
	ld (wStatusBarNeedsRefresh),a
	ld a,UNCMP_GFXH_03
	call loadUncompressedGfxHeader

	; Clear the first 4 oam objects, if exactly that number has been drawn?
	; Must be the items on the status bar.
	ld b,$10
	ldh a,(<hOamTail)
	cp b
	ret nz

	ld a,$e0
	ld hl,wOam
	jp fillMemory

;;
showStatusBar_body:
	xor a
	ld (wDontUpdateStatusBar),a
	dec a
	ld (wStatusBarNeedsRefresh),a
	ret

;;
; @param	c	Value for wOpenedMenuType
openMenu_body:
	ld a,c
	ld hl,wOpenedMenuType
	ldi (hl),a
	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld (wTextIsActive),a
	jp fastFadeoutToWhite

;;
copyW2TilesetBgPalettesToW4PaletteData_body:
	ld hl,w2TilesetBgPalettes
	ld de,w4PaletteData
	ld b,$80
-
	ld a,:w2TilesetBgPalettes
	ld ($ff00+R_SVBK),a
	ld c,(hl)
	inc l
	ld a,:w4PaletteData
	ld ($ff00+R_SVBK),a
	ld a,c
	ld (de),a
	inc de
	dec b
	jr nz,-

	ld a,$ff
	ldh (<hDirtyBgPalettes),a
	ldh (<hDirtySprPalettes),a
	ret

;;
copyW4PaletteDataToW2TilesetBgPalettes_body:
	ld hl,w4PaletteData
	ld de,w2TilesetBgPalettes
	ld b,$80
-
	ld a,:w4PaletteData
	ld ($ff00+R_SVBK),a
	ld c,(hl)
	inc l
	ld a,:w2TilesetBgPalettes
	ld ($ff00+R_SVBK),a
	ld a,c
	ld (de),a
	inc de
	dec b
	jr nz,-

	ld a,$ff
	ldh (<hDirtyBgPalettes),a
	ldh (<hDirtySprPalettes),a
	ret

;;
closeMenu:
	ld hl,wMenuLoadState
	inc (hl)
	ld a,(wOpenedMenuType)
	cp MENU_SAVEQUIT
	ld a,SND_CLOSEMENU
	call nz,playSound
	xor a
	ld (wTextIsActive),a
	jp fastFadeoutToWhite

;;
; Updates menu states, also plays link heart beep sound
b2_updateMenus:
	ld a,(wOpenedMenuType)
	or a
	jr nz,@updateMenu

	; Return if screen is scrolling?
	ld a,(wScrollMode)
	and $0e
	ret nz

	; Return if text is on screen
	call retIfTextIsActive

	; Return if link is dying or something else
	ld a,(wLinkDeathTrigger)
	ld b,a
	ld a,(wLinkPlayingInstrument)
	or b
	ret nz

	ld a,(wKeysJustPressed)
	and BTN_START | BTN_SELECT
	jr z,+

	; Return if you haven't seen the opening cutscene yet
	ld a,(wGlobalFlags+GLOBALFLAG_INTRO_DONE/8)
	bit GLOBALFLAG_INTRO_DONE&7,a
	ld a, SND_ERROR
	jp z,playSound
+
	ld a,(wMenuDisabled)
	ld b,a
	ld a,(wDisableLinkCollisionsAndMenu)
	or b
	ret nz

	call playHeartBeepAtInterval
	ld a,(wKeysJustPressed)
	and BTN_START | BTN_SELECT
	ret z

	ld c,$03
	cp BTN_START | BTN_SELECT
	jr z,+

	dec c
	bit BTN_BIT_SELECT,a
	jr nz,+
	dec c
+
	jp openMenu_body

@updateMenu:
	ld a,$ff
	ld (wc4b6),a
	ld a,(wMenuLoadState)
	rst_jumpTable
	.dw menuStateFadeIntoMenu
	.dw menuSpecificCode
	.dw menuStateFadeOutOfMenu
	.dw menuStateFadeIntoGame

;;
menuSpecificCode:
	ld a,(wOpenedMenuType)
	rst_jumpTable
	.dw runSaveAndQuitMenu
	.dw runInventoryMenu
	.dw runMapMenu
	.dw runSaveAndQuitMenu
	.dw runRingMenu
	.dw runGaleSeedMenu
	.dw runSecretEntryMenu
	.dw runKidNameEntryMenu
	.dw runGameLinkMenu
	.dw runFakeReset
	.dw runSecretListMenu

;;
; Game is fading out just after initial start/select press
menuStateFadeIntoMenu:
	ld a,(wOpenedMenuType)
	cp $03
	jr nc,+

	ld a,(wKeysPressed)
	and BTN_START | BTN_SELECT
	cp BTN_START | BTN_SELECT
	jr nz,+

	ld a,MENU_SAVEQUIT
	ld (wOpenedMenuType),a
+
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call @openMenu
	ld hl,wMenuLoadState
	inc (hl)
	jp menuSpecificCode

;;
; Loads menu graphics and stuff
@openMenu:
	ld a,(wOpenedMenuType)
	cp MENU_SAVEQUIT
	ld a,SND_OPENMENU
	call nz,playSound
	ld a,$02
	call setMusicVolume
;;
saveGraphicsOnEnterMenu_body:
	ldh a,(<hCameraY)
	ld hl,wcbe1
	ldi (hl),a
	ldh a,(<hCameraX)
	ld (hl),a
	push de
	ld hl,wGfxRegs1
	ld de,wGfxRegs4
	ld b,GfxRegsStruct.size*2
	call copyMemory
	call disableLcd
	call copyW2TilesetBgPalettesToW4PaletteData_body
	ld a,:w4SavedOam
	ld ($ff00+R_SVBK),a
	ld hl,wOam
	ld de,w4SavedOam
	ld b,$a0
	call copyMemory
	ld a,$01
	ld ($ff00+R_VBK),a
	ld hl,$8600
	ld bc,$0180
	ld de,w4SavedVramTiles
	call copyMemoryBc

	ld hl,wMenuUnionStart
	ld b,wMenuUnionEnd - wMenuUnionStart
	call clearMemory

	ld a,$ff
	ld (wc4b6),a
	pop de
	jp clearOam

;;
menuStateFadeOutOfMenu:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call reloadGraphicsOnExitMenu_body
	ld hl,wMenuLoadState
	inc (hl)
	jp updateParentItemButtonAssignment

;;
; Called when exiting menus
reloadGraphicsOnExitMenu_body:
	ld hl,wcbe1
	ldi a,(hl)
	ldh (<hCameraY),a
	ld a,(hl)
	ldh (<hCameraX),a
	push de
	call disableLcd
	ld a,:w4SavedOam
	ld ($ff00+R_SVBK),a
	ld de,$8601
	ldbc $17, :w4SavedVramTiles
	ld hl,w4SavedVramTiles
	call queueDmaTransfer
	ld hl,w4SavedOam
	ld de,wOam
	ld b,$a0
	call copyMemory
	call copyW4PaletteDataToW2TilesetBgPalettes_body
	ld hl,wGfxRegs4
	ld de,wGfxRegs1
	ld b,GfxRegsStruct.size*2
	call copyMemory
	call loadCommonGraphics_body
	call reloadObjectGfx
	call loadTilesetData
	call loadTilesetGraphics
	call reloadTileMap
	call fastFadeinFromWhiteToRoom
	ld a,(wExtraBgPaletteHeader)
	or a
	call nz,loadPaletteHeader

.ifdef ROM_SEASONS
	; Checking for ROOM_SEASONS_7ff (onox fight?)
	ld a,(wActiveGroup)
	cp >ROOM_SEASONS_7ff
	jr nz,++
	ld a,(wActiveRoom)
	inc a
	jr nz,++
	pop de
	jp seasonsFunc_332f
.endif
++

	ld a,(wGfxRegs1.LCDC)
	ld (wGfxRegsFinal.LCDC),a
	ld ($ff00+R_LCDC),a
	pop de

.ifdef ROM_AGES
	jpab bank1.checkInitUnderwaterWaves
.else
	ret
.endif

;;
menuStateFadeIntoGame:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	xor a
	ld (wc4b6),a
	ld (wOpenedMenuType),a
	ld a,$03
	jp setMusicVolume

;;
playHeartBeepAtInterval:
	ld a,(w1Link.id)
	dec a
	ret z

	ld a,(wFrameCounter)
	and $3f
	ret nz

	ld hl,wLinkHealth
	ldi a,(hl)
	dec a
	add a
	ret c
	add a
	cp (hl)
	ret nc

	ld a,SND_HEARTBEEP
	jp playSound

;;
; Load graphics for the status bar and various sprites that appear everywhere
loadCommonGraphics_body:
	call disableLcd
	ld a,GFXH_HUD
	call loadGfxHeader
	ld a,GFXH_COMMON_SPRITES
	call loadGfxHeader

.ifdef ROM_AGES
	xor a
	ld (wcbe8),a
	call updateStatusBar_body

	; Check if in an underwater group
	ld a,(wActiveGroup)
	sub $02
	cp $02
	jr nc,+

	; Check if the tileset is actually underwater
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	jr z,+

	; Load a graphic for the seaweed being cut over the graphic for a bush
	; being cut
	ld a,GFXH_SEAWEED_CUT
	call loadGfxHeader
	ld a,PALH_SEAWEED_CUT
	call loadPaletteHeader
+
	jp checkReloadStatusBarGraphics

.else; ROM_SEASONS

; Update key, ore chunk, or small key graphic in hud

	ld a,(wTilesetFlags)
	ld b,a
	xor a
	ld c,<wNumRupees
	bit TILESETFLAG_BIT_DUNGEON,b
	jr nz,@loadMoneyGraphic

	bit TILESETFLAG_BIT_SUBROSIA,b
	jr z,@updateDisplayedMoney

	ld a,$10
	ld c,<wNumOreChunks

@loadMoneyGraphic:
	; Load either key (a=$00) or ore chunk (a=$10) graphic to replace rupee graphic
	push bc
	ld hl,gfx_key_orechunk
	rst_addAToHl
	ld de,$9090
	ldbc $00, :gfx_key_orechunk
	call queueDmaTransfer
	pop bc

@updateDisplayedMoney:
	ld a,c
	ld hl,wDisplayedMoneyAddress
	cp (hl)
	ld (hl),c
	jr z,++

	ld l,c
	ld h,>wc600Block
	ldi a,(hl)
	ld (wDisplayedRupees),a
	ld a,(hl)
	ld (wDisplayedRupees+1),a
++
	xor a
	ld (wcbe8),a
	call updateStatusBar_body
	jp checkReloadStatusBarGraphics


.endif

;;
updateStatusBar_body:
	ld a,(wDontUpdateStatusBar)
	or a
	ret nz

	ld a,$04
	ld ($ff00+R_SVBK),a
	call loadStatusBarMap

	; Check whether A and B items need refresh
	ld a,(wStatusBarNeedsRefresh)
	bit 0,a
	jr z,+

	call loadEquippedItemGfx
	call drawItemTilesOnStatusBar
	jr ++
+
	; Check whether item levels / counts need refresh
	bit 1,a
	call nz,drawItemTilesOnStatusBar
++
	; Update displayed rupee count

.ifdef ROM_SEASONS
	ld a,(wDisplayedMoneyAddress)
	ld l,a
	ld h,>wc600Block
.else; ROM_AGES
	ld hl,wNumRupees
.endif
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	ld hl,wDisplayedRupees
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call compareHlToBc
	jr z,@updateRupeeDisplay

	ld hl,wStatusBarNeedsRefresh
	set 3,(hl)
	ld bc,$0001
	ld l,<wDisplayedRupees
	dec a
	jr z,+

	call addDecimalToHlRef
	jr ++
+
	call subDecimalFromHlRef
++
	ld a,SND_RUPEE
	call playSound

@updateRupeeDisplay:
	ld a,(wStatusBarNeedsRefresh)
	bit 3,a
	jr z,+

	ld hl,w4StatusBarTileMap+$2c
	call correctAddressForExtraHeart
	ld c,$10
	ld a,(wDisplayedRupees)
	ld b,a
	and $0f
	add c
	ldd (hl),a
	ld a,b
	swap a
	and $0f
	add c
	ldd (hl),a
	ld a,(wDisplayedRupees+1)
	and $0f
	add c
	ldd (hl),a
+
	; Update displayed heart count
	ld hl,wDisplayedHearts
	ld a,(wLinkHealth)
	cp (hl)
	jr z,@updateHeartDisplay
	jr c,+

	ld a,(wFrameCounter)
	and $03
	jr nz,@updateHeartDisplay

	inc (hl)
	ld a,(hl)
	and $03
	ld a,SND_GAINHEART
	call z,playSound
	jr ++
+
	dec (hl)
++
	ld hl,wStatusBarNeedsRefresh
	set 2,(hl)

@updateHeartDisplay:
	ld a,(wStatusBarNeedsRefresh)
	bit 2,a
	call nz,inGameDrawHeartDisplay
	ld hl,w4StatusBarTileMap+$0a
	call correctAddressForExtraHeart
	ld (hl),$09

	ld a,(wTilesetFlags)

.ifdef ROM_AGES
	bit TILESETFLAG_BIT_LARGE_INDOORS,a
	jr nz,+
.endif

	bit TILESETFLAG_BIT_DUNGEON,a
	jr z,+

.ifdef ROM_AGES
	; Seasons replaces the rupee gfx with the key gfx if necessary, while Ages has
	; both the rupee and the key gfx loaded at all times (so it just changes which
	; tile is shown here).
	inc (hl)
.endif

	; "X" symbol next to key icon
	inc l
	ld (hl),$1b

	ld a,(wStatusBarNeedsRefresh)
	bit 4,a
	jr z,+

	; Update number of keys
	inc l
	ld a,(wDungeonIndex)
	ld bc,wDungeonSmallKeys
	call addAToBc
	ld a,(bc)
	add $10
	ld (hl),a
+
	xor a
	ld ($ff00+R_SVBK),a
	ld a,(wcbe8)
	bit 7,a
	jr nz,@biggoronSword

	; Update item sprites
	ld e,$10
	ld bc,$1038
	rrca
	jr nc,+
	ld c,$30
+

.ifdef ROM_AGES
	; If harp is equipped, adjust sprite X-position 8 pixels right
	ld hl,wInventoryB
	ld a,ITEMID_HARP
	cp (hl)
	jr nz,+
	set 3,e
+
	inc l
	cp (hl)
	jr nz,+

	ld a,c
	add $08
	ld c,a
+
.endif

	ld hl,wOam
	ld a,b
	ldi (hl),a
	ld a,e
	ldi (hl),a
	ld a,$78
	ldi (hl),a
	ld a,(wBItemSpriteAttribute1)
	ldi (hl),a

	ld a,b
	ldi (hl),a
	ld a,(wBItemSpriteXOffset)
	add e
	ldi (hl),a
	ld a,$7a
	ldi (hl),a
	ld a,(wBItemSpriteAttribute2)
	ldi (hl),a
	ld a,b

	ldi (hl),a
	ld a,c
	ldi (hl),a
	ld a,$7c
	ldi (hl),a
	ld a,(wAItemSpriteAttribute1)
	ldi (hl),a

	ld a,b
	ldi (hl),a
	ld a,(wAItemSpriteXOffset)
	add c
	ldi (hl),a
	ld a,$7e
	ldi (hl),a
	ld a,(wAItemSpriteAttribute2)
	ldi (hl),a
	ret

@biggoronSword:
	ld hl,wOam
	ld de,@oamData
	ld b,$10
	jp copyMemoryReverse

@oamData:
	.db $10 $18 $78 $0b ; B Item
	.db $10 $20 $7a $0b
	.db $10 $28 $7c $0b ; A Item
	.db $10 $30 $7e $0b

;;
; Subtracts hl by 1 if you have 15+ hearts - status bar needs to be compressed
; slightly
correctAddressForExtraHeart:
	ld a,(wcbe8)
	rrca
	ret nc
	dec l
	ret

;;
; Reloads status bar map, and loads the graphics for the sprites for the A/B button items.
;
; The OAM data for the sprites is probably always loaded, so this function doesn't need to
; handle that?
;
; When combined with drawItemTilesOnStatusBar, the A/B items get fully drawn.
;
loadEquippedItemGfx:
	call loadStatusBarMap

	; Return if biggoron sword is equipped
	ld a,(wcbe8)
	rlca
	ret c

	ld a,(wInventoryB)
	ld de,wBItemTreasure
	call loadEquippedItemSpriteData
	ld e,<w4ItemIconGfx+$00
	call c,loadItemIconGfx

	ld a,(wInventoryA)
	ld de,wAItemTreasure
	call loadEquippedItemSpriteData
	ld e,<w4ItemIconGfx+$40
	call c,loadItemIconGfx

;;
func_02_52f6:
	ld bc,$0020
	ld hl,w4StatusBarAttributeMap+$02
	ld a,(wBItemSpriteXOffset)
	bit 7,a
	call z,@func1

	ld l,<w4StatusBarAttributeMap+$07
	ld a,(wcbe8)
	rrca
	jr nc,+
	dec l
+
	ld a,(wAItemSpriteXOffset)
	bit 7,a
	ret nz
;;
@func1:
	or a
	call nz,@func2
	dec l
;;
@func2:
	ld d,l
	ld (hl),b
	add hl,bc
	ld (hl),b
	ld l,d
	ret

;;
; Loads the values for the "wAItem*" or "wBItem*" variables (5 bytes total) and returns in
; 'bc' what tile indices the item uses.
;
; @param	a	Treasure index
; @param	de	Where to write the item graphics data (ie. wAItemTreasure)
; @param[out]	bc	Left/right sprite indices
; @param[out]	cflag	Set if the data was loaded correctly (there is something to draw)
loadEquippedItemSpriteData:
	call loadTreasureDisplayData

	; [wItemTreasure] = the treasure ID to use for level/quantity data
	ldi a,(hl)
	ld (de),a

	; Read the left sprite + attribute bytes
	ldi a,(hl)
	or a
	jr z,@clearItem

	; Put left sprite index in 'b'
	inc e
	ld b,a

	; Comparion differs between ages/seasons. See the respective games'
	; "spr_item_icons_1.bin". This comparison changes the palette used for the seed
	; satchel, seed shooter, slingshot, and hyper slingshot.
.ifdef ROM_AGES
	cp $84
.else; ROM_SEASONS
	cp $86
.endif
	ldi a,(hl)
	jr nc,+
	sub $03
	or $01
+
	; Store into [wItemSpriteAttribtue1]
	set 3,a
	ld (de),a

	; Read the right sprite + attribute bytes
	inc e
	ldi a,(hl)

	; Put right sprite index in 'c'
	or a
	ld c,a
	jr z,+

	scf
	ld a,(hl)
+
	inc l

	; Store into [wItemSpriteAttribute2]
	set 3,a
	ld (de),a

	; Calculate [wItemSpriteXOffset]
	inc e
	ld a,$08
	jr c,+
	xor a
+
	ld (de),a

	; Copy value for [wItemDisplayMode]
	inc e
	ldi a,(hl)
	ld (de),a

	scf
	ret

@clearItem:
	ld l,e
	ld h,d
	ld b,$05
	ld a,$ff
-
	ldi (hl),a
	dec b
	jr nz,-
	ret

;;
; Redraw the tiles in w4StatusBar for the current equipped items.
; (Only deals with the background layer, ie. item count; not the sprites themselves)
;
; Note: returns with wram bank 4 loaded.
;
drawItemTilesOnStatusBar:
	; Return if biggoron's sword equipped
	ld a,(wcbe8)
	bit 7,a
	ret nz

	ld a,$04
	ld ($ff00+R_SVBK),a
	ld a,(wInventoryB)
	ld de,wBItemTreasure
	call loadEquippedItemSpriteData
	ld a,(wInventoryA)
	ld de,wAItemTreasure
	call loadEquippedItemSpriteData
	call func_02_52f6

	; Draw A button item
	; Need to check if the status bar is squished to the left
	ld a,(wcbe8)
	rrca
	ld de,w4StatusBarTileMap+$27
	jr nc,+
	dec e
+
	ld a,(wAItemTreasure)
	ld b,a
	ld a,(wAItemDisplayMode)
	call @drawItem

	; Draw B button item
	ld de,w4StatusBarTileMap+$22
	ld a,(wBItemTreasure)
	ld b,a
	ld a,(wBItemDisplayMode)

;;
; @param	a	Item display mode
; @param	b	Treasure index for the "amount" to display
; @param	de	Address in w4StatusBarTileMap to draw to
@drawItem:
	ld c,a
	rlca
	ret c

	; Get the number to display in 'b' (if applicable)
	ld a,b
	call checkTreasureObtained
	ld b,a

	ld a,c
	ld c,$80

;;
; Draws the "extra tiles" for a treasure (ie. numbers).
;
; @param	a	The item's "display mode" (whether to display a number beside it)
; @param	b	The number to draw (if applicable)
; @param	c	$80 if drawing on A/B buttons, $07 if on inventory
; @param	de	Address to draw to (should be a tilemap of some kind)
drawTreasureExtraTiles:
	bit 7,a
	ret nz

	dec a
	jr z,@val01
	dec a
	jr z,@val02
	dec a
	jr z,@val03
	dec a
	jr z,@val04
	jr @val00

; Display item quantity with "x" symbol (ie. slates in ages d8)
@val04:
	; Digit
	inc e
	ld a,b
	and $0f
	add $10
	ld (de),a

	; Attributes
	set 2,d
	ld a,c
	ld (de),a
	dec e
	ld (de),a

	; 'x' symbol
	res 2,d
	ld a,$1b
	ld (de),a
	ret

; Display item quantity (ie. bombs, seed satchel)
@val01:
	; 1's digit
	inc e
	ld a,b
	and $0f
	add $10
	ld (de),a

	; Attributes
	set 2,d
	ld a,c
	ld (de),a
	dec e
	ld (de),a

	; 10's digit
	res 2,d
	ld a,b
	swap a
	and $0f
	add $10
	ld (de),a
	ret

; Display the item's level
@val00:
	; Digit
	inc e
	ld a,b
	and $0f
	add $10

	; Attributes
	ld (de),a
	set 2,d
	ld a,c
	ld (de),a
	dec e
	ld (de),a

	; 'L-' symbol
	res 2,d
	ld a,$1a
	ld (de),a
	ret

.ifdef ROM_AGES

; Stub
@val03:
	ret

; Display the harp?
@val02:
	ld h,d
	ld l,e

	; Check whether drawing on inventory or on A/B buttons
	ld a,c
	cp $07
	jr z,@@drawOnInventory

	; Drawing on A/B buttons

	ld a,$1f
	ldd (hl),a
	ld (hl),$1d
	set 2,h
	ld a,$80
	ldi (hl),a
	ldi (hl),a
	ld (hl),$00
	ld bc,$ffe0
	add hl,bc
	ld (hl),$00
	dec l
	ldd (hl),a
	ld (hl),a
	res 2,h
	ld a,$1c
	ldi (hl),a
	ld (hl),$1e
	ret

@@drawOnInventory:
	ld a,$1f
	ldd (hl),a
	ld (hl),$1d
	set 2,h
	ld a,$84
	ldi (hl),a
	ldd (hl),a
	ld bc,$ffe0
	add hl,bc
	ldi (hl),a
	ldd (hl),a
	res 2,h
	ld a,$1c
	ldi (hl),a
	ld (hl),$1e
	ret

.else; ROM_SEASONS

; Print magnet glove polarity (overwrites "S" with "N" if necessary)
@val03:
	ld h,d
	ld l,e
	ld a,(wMagnetGlovePolarity)
	and $01
	ret z
	ld (hl),$0a
	set 2,d
	rrca
	or c
	ld (de),a
	ret

; Display obtained seasons
@val02:
	ld h,d
	ld l,e

	; Spring
	ld b,$1c
	ld a,(wObtainedSeasons)
	rrca
	ld e,a
	call c,@drawTile

	; Summer
	ld a,$e0
	add l
	ld l,a
	inc b
	srl e
	call c,@drawTile

	; Fall
	inc l
	inc b
	srl e
	call c,@drawTile

	; Winter
	ld a,$20
	rst_addAToHl
	inc b
	srl e
	jr c,@drawTile
	ret

.endif

;;
; Unused in ages
;
; @param	b	Tile
; @param	c	Flags
; @param	hl	Where to write to (a tilemap)
@drawTile:
	ld (hl),b
	set 2,h
	ld (hl),c
	res 2,h
	ret

;;
; @param b Number of heart containers
; @param c Number of hearts
; @param hl Address of tile buffer to write to
fileSelectDrawHeartDisplay:
	ld a,$01
	ldh (<hFF8B),a
	ld a,b
	jr drawHeartDisplay

;;
inGameDrawHeartDisplay:
	ld hl,w4StatusBarTileMap+$0d
	xor a
	ldh (<hFF8B),a
	ld a,(wDisplayedHearts)
	ld c,a
	ld a,(wLinkMaxHealth)
;;
; @param a Number of heart containers (in quarters)
; @param c Number of hearts (in quarters)
; @param hl Tile buffer to write to
; @param hFF8B
drawHeartDisplay:
	; e = hearts per row (7 normally, 8 if you have 15+ hearts)
	ld e,$07
	cp 14*4+1
	jr c,+
	inc e
+
	srl a
	srl a
	ld b,a
	ld a,c
	and $03
	ld d,a
	ld a,c
	srl a
	srl a
	ld c,a
	push bc
	cp e
	jr c,+
	ld c,e
+
	ld a,b
	cp e
	jr c,+
	ld a,e
+
	sub c
	ld b,a
	ldh a,(<hFF8B)
	or e
	rrca
	jr c,+
	dec l
+
	push hl
	call @drawHeartDisplayRow
	pop hl

	; Set up for the second row
	ld a,$20
	rst_addAToHl
	pop bc
	ld a,c
	sub e
	jr nc,+
	xor a
+
	ld c,a
	ld a,b
	sub e
	sub c
	bit 7,a
	jr z,+
	xor a
+
	ld b,a

;;
; @param b Number of unfilled hearts (including partially filled one)
; @param c Number of filled hearts (not quarters)
; @param d Number of quarters in partially-filled heart
; @param hl Tile buffer to write to
@drawHeartDisplayRow:
	ld a,c
	or a
	jr z,@partiallyFilledHeart

@filledHearts:
	ld a,$0f
-
	ldi (hl),a
	dec c
	jr nz,-

@partiallyFilledHeart:
	ld a,b
	or a
	jr z,@fillBlankSpace

	ld a,d
	or a
	jr z,@unfilledHearts

	add $0b
	ldi (hl),a
	ld d,$00
	dec b

@unfilledHearts:
	ld a,b
	or a
	jr z,@fillBlankSpace

	ld a,$0b
-
	ldi (hl),a
	dec b
	jr nz,-

@fillBlankSpace:
	ldh a,(<hFF8B)
	or a
	ret nz

	ld c,$08
-
	ldi (hl),a
	dec c
	jr nz,-
	ret

;;
; Loads two tiles for an equipped item's graphics ($40 bytes loaded total).
;
; @param	b	Left sprite index (tile index for spr_item_icons)
; @param	c	Right sprite index (tile index for spr_item_icons)
; @param	e	Low byte of where to load graphics (should be w4ItemIconGfx+XX)
loadItemIconGfx:
	ld d,>w4ItemIconGfx
	push bc
	ld a,b
	call @func
	pop bc
	ld a,c
;;
; @param	a	Tile index
; @param	de	Where to load the data
@func:
	or a
	jr z,@clear

.ifdef ROM_AGES
	; Special behaviour for harp song icons: add 2 to the index so that the "smaller
	; version" of the icon is drawn. (spr_item_icons_3.bin has two versions of each
	; song)
	cp $a3
	jr c,+
	add $02
+
.endif

	add a
	call multiplyABy16
	ld hl,spr_item_icons_1
	add hl,bc
	ld b,:spr_item_icons_1
	jp copy20BytesFromBank
@clear:
	ld h,d
	ld l,e
	ld b,$20
	ld a,$ff
	jp fillMemory

;;
loadStatusBarMap:
	ld c,$10
	ld a,(wLinkMaxHealth)
	cp 14*4+1
	jr c,+
	inc c
+
	; Check if biggoron's sword equipped
	ld a,(wInventoryB)
	cp ITEMID_BIGGORON_SWORD
	jr nz,+
	set 7,c
+
	ld hl,wStatusBarNeedsRefresh
	ldd a,(hl)
	rrca
	ld a,c
	jr c,+

	cp (hl)
	ret z
+
	ldi (hl),a

	; [wStatusBarNeedsRefresh] = $ff; should trigger complete redrawing, including
	; reloading item graphics?
	ld (hl),$ff

	ld hl,wBItemTreasure
	ld b,$0a
	call clearMemory
	bit 7,c
	ld a,GFXH_HUD_LAYOUT_BIGGORON_SWORD
	jr nz,+

	; Load one of:
	; - GFXH_HUD_LAYOUT_NORMAL (<14 hearts)
	; - GFXH_HUD_LAYOUT_EXTRA_HEARTS (>=14 hearts)
	ld a,c
	and $01
	add GFXH_HUD_LAYOUT_NORMAL
+
	jp loadGfxHeader

;;
runInventoryMenu:
	call clearOam
	ld a,$10
	ldh (<hOamTail),a
	ld a,$04
	ld ($ff00+R_SVBK),a
	call @inventoryMenuStates
	call inventoryMenuDrawSprites
	xor a
	ld ($ff00+R_SVBK),a
	jp updateStatusBar

;;
@inventoryMenuStates:
	ld a,(wMenuActiveState)
	rst_jumpTable
	.dw inventoryMenuState0
	.dw inventoryMenuState1
	.dw inventoryMenuState2
	.dw inventoryMenuState3

;;
; @param a
showItemText1:
	ld hl,w4SubscreenTextIndices
	rst_addAToHl
	ld a,(hl)
;;
; @param	a	Text index to show.
;			If bit 7 is set, it's a ring; use TX_03XX.
;			In this case, use TX_30c1 to combine the name (TX_3040+X) with the
;			description (TX_3080+X).
showItemText2:
	ld hl,wInventory.activeText
	cp (hl)
	ret z

	ld (hl),a
	ld c,a
	ld b,>TX_0900
	bit 7,c
	jr z,+

	ld b,>TX_3000
	ld c,$c0
	and $3f
	ld l,a
	add <TX_3040
	bit 6,c ; Bit 6 is always set?
	ld c,a
	jr z,+

	ld (wTextSubstitutions+2),a
	ld a,l
	add <TX_3080
	ld (wTextSubstitutions+3),a
	ld c,<TX_30c1
+
	jp showTextOnInventoryMenu

;;
; Initialization
inventoryMenuState0:
	ld hl,wInventorySubmenu2CursorPos
	ld a,(hl)
	cp $08
	jr nc,+
	ld (hl),$00
+

.ifdef ROM_SEASONS
	xor a
	ld (wInventorySubmenu),a
	ld (wInventory.cbba),a
	dec a
	ld (wInventory.activeText),a
	call checkWhetherToDisplaySeasonInSubscreen
	jr z,+
	ld a,$01
+
	ld (wInventory.submenu2CursorPos2),a

.else; ROM_AGES
	xor a
	ld (wInventorySubmenu),a
	ld (wInventory.cbba),a
	ld (wInventory.submenu2CursorPos2),a
	dec a
	ld (wInventory.activeText),a
.endif

	call loadCommonGraphics
	ld a,GFXH_INVENTORY_SCREEN
	call loadGfxHeader
	ld a,UNCMP_GFXH_06
	call loadUncompressedGfxHeader
	ld a,PALH_0a
	call loadPaletteHeader
	callab bank3f.getNumUnappraisedRings
	call func_02_55b2
	ld a,$01
	ld (wMenuActiveState),a
	call fastFadeinFromWhite
	ld a,$03
	jp loadGfxRegisterStateIndex

;;
func_02_55a8:
	ld a,(wInventory.cbba)
	and $01
	add UNCMP_GFXH_04
	jp loadUncompressedGfxHeader

;;
; Load graphics for subscreens?
func_02_55b2:
	ld hl,w4SubscreenTextIndices
	ld b,$20
	call clearMemory
	xor a
	call showItemText2
	ld hl,func_02_55a8
	push hl
	ld a,(wInventorySubmenu)
	rst_jumpTable
	.dw @subScreen0
	.dw @subScreen1
	.dw @subScreen2

;;
@subScreen0:
	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
	ld a,GFXH_INVENTORY_SUBSCREEN_1
	call loadGfxHeader
	jp inventorySubscreen0_drawStoredItems

;;
@subScreen1:
	ld a,GFXH_INVENTORY_SUBSCREEN_2
	call loadGfxHeader
	jp inventorySubscreen1_drawTreasures
;;
@subScreen2:
	ld a,GFXH_INVENTORY_SUBSCREEN_3
	call loadGfxHeader
	jp inventorySubscreen2_drawTreasures

;;
; Main state, waits for inputs
inventoryMenuState1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wKeysJustPressed)
	bit BTN_BIT_START,a
	jp nz,closeMenu

	bit BTN_BIT_SELECT,a
	ld a,$03
	jr nz,@func_02_5606

	ld a,(wInventorySubmenu)
	rst_jumpTable
	.dw @subscreen0
	.dw @subscreen1
	.dw @subscreen2

;;
@func_02_5606:
	ld hl,wMenuActiveState
	ldi (hl),a
	ld (hl),$00
	ret

;;
; Main item screen
@subscreen0:
	ld a,(wKeysJustPressed)
	ld c,a
	ld a,<wInventoryB
	bit BTN_BIT_B,c
	jr nz,@aOrB

	inc a
	bit BTN_BIT_A,c
	jr nz,@aOrB

	call inventorySubscreen0CheckDirectionButtons
	ld a,(wInventorySubmenu0CursorPos)
	ld hl,wInventoryStorage
	rst_addAToHl
	ld a,(hl)
	call loadTreasureDisplayData
	ld a,$06
	rst_addAToHl
	ld a,(hl)
	call showItemText2
	jp inventorySubscreen0_drawCursor

@aOrB:
	ld (wTmpcbb6),a
	ld a,(wInventorySubmenu0CursorPos)
	ld hl,wInventoryStorage
	rst_addAToHl
	ld a,(hl)
	ld (wInventory.selectedItem),a

	; Satchel or shooter?
	ld c,$1f
	cp ITEMID_SEED_SATCHEL
	jr z,@hasSubmenu

.ifdef ROM_AGES
	cp ITEMID_SHOOTER
	jr z,@hasSubmenu

	cp ITEMID_HARP
	jr nz,@finalizeEquip
	ld c,$e0

.else; ROM_SEASONS
	cp ITEMID_SLINGSHOT
	jr nz,@finalizeEquip
.endif

@hasSubmenu:
	ld a,(wSeedsAndHarpSongsObtained)
	and c
	call getNumSetBits
	ld (wInventory.cbb8),a
	cp $02
	ld a,$02
	jp nc,@func_02_5606

@finalizeEquip:
	call @equipItem
	call inventorySubscreen0_drawStoredItems
	call inventorySubscreen0_drawCursor
	ld a,SND_SELECTITEM
	call playSound
	ld a,$01
	call @func_02_5606
	jp func_02_55b2

;;
; Swaps the item at the cursor with the item on a button.
; @param wInventorySubmenu0CursorPos Item to equip
; @param wTmpcbb6 Address of button to unequip
@equipItem:
	ld d,>wInventoryStorage
	ld h,d
	ld a,(wTmpcbb6)
	ld e,a
	ld a,(wInventorySubmenu0CursorPos)
	add <wInventoryStorage
	ld l,a
	ld b,ITEMID_BIGGORON_SWORD
	ld a,(hl)
	cp b
	jr z,@@equipBiggoron

	ld a,(de)
	cp b
	jr nz,@@swapItems

@@unequipBiggoron:
	ld c,l
	ld l,<wInventoryB
	xor a
	ldi (hl),a
	ld (hl),a
	ld l,c
	ld a,b
	ld (de),a
@@swapItems:
	ld a,(de)
	ld c,a
	ld a,(hl)
	ld (de),a
	ld (hl),c
	ret

@@equipBiggoron:
	ld (hl),$00
	call @@swapItems
	ld a,(wInventoryB)
	call @@putItemInFirstBlankSlot
	ld a,(wInventoryA)
	call @@putItemInFirstBlankSlot
	ld l,<wInventoryB
	ld (hl),b
	inc l
	ld (hl),b
	ret

;;
; @param a Item to put in a blank slot
@@putItemInFirstBlankSlot:
	or a
	ret z

	ld c,a
	ld l,<wInventoryStorage
-
	ldi a,(hl)
	or a
	jr nz,-

	dec l
	ld (hl),c
	ret

;;
; Main code for secondary item screen (rings, passive items, etc)
@subscreen1:
	ld a,(wKeysJustPressed)
	bit BTN_BIT_A,a
	jr nz,+

	call inventorySubmenu1CheckDirectionButtons
	jr ++
+
	call @checkEquipRing
++
	call inventorySubmenu1_drawCursor
	ld a,(wInventorySubmenu1CursorPos)
	call showItemText1
	jp drawEquippedSpriteForActiveRing

;;
; Pressed A on subscreen 1; check whether to equip a ring
;
@checkEquipRing:
	ld a,(wInventorySubmenu1CursorPos)
	sub $10
	ret c

.ifdef ROM_SEASONS
	; Can't equip rings while boxing
	ld b,a
	ld a,(wInBoxingMatch)
	or a
	ld a,SND_ERROR
	jp nz,playSound

	ld a,b
.endif

	ld hl,wActiveRing
	ld c,(hl)
	ld l,<wRingBoxContents
	rst_addAToHl
	ld a,(hl)
	cp c
	jr nz,+

	cp $ff
	ret z
	ld a,$ff
+
	ld (wActiveRing),a
	ld a,SND_SELECTITEM
	jp playSound

;;
; Main code for last item screen (essences, heart pieces, s&q option)
@subscreen2:
	ld a,(wKeysJustPressed)
	and BTN_A
	jr z,+

	ld a,(wInventorySubmenu2CursorPos)
	rlca
	jr nc,+

	ld a,(wInventory.submenu2CursorPos2)
	cp $02
	jr nz,+

	; Save button selected
	inc a ; MENU_SAVEQUIT ($03)
	ld (wOpenedMenuType),a
	ld a,SND_SELECTITEM
	call playSound
	ld hl,wTmpcbb3
	ld b,$10
	jp clearMemory

+
	call inventorySubmenu2CheckDirectionButtons
	ld a,(wInventorySubmenu2CursorPos)
	bit 7,a
	jr z,+

	ld a,(wInventory.submenu2CursorPos2)
	add $08
+
	call showItemText1
	jp inventorySubmenu2_drawCursor

;;
; Opening a submenu (seeds, harp songs)
inventoryMenuState2:

.ifdef ROM_AGES
	call @subStates
	jp createBlankSpritesForItemSubmenu
.endif

; ROM_SEASONS just starts directly at @subStates.

@subStates:
	ld a,(wSubmenuState)
	rst_jumpTable
	.dw @subState0
	.dw @subState1
	.dw @subState2

;;
@subState0:

.ifdef ROM_AGES
	ld hl,wSelectedHarpSong
	ld d,(hl)
	dec d
	ld l,<wSatchelSelectedSeeds
	call cpInventorySelectedItemToHarp
	jr z,++

.else; ROM_SEASONS

	ld hl,wSatchelSelectedSeeds
	ld a,(wInventory.selectedItem)
.endif

	cp ITEMID_SEED_SATCHEL
	jr z,+
	inc l
+
	ld e,(hl)
	ld d,$00
-
	ld a,d
	call getSeedTypeInventoryIndex
	cp e
	jr z,++

	inc d
	jr -
++
	ld a,d
	ld (wInventory.itemSubmenuIndex),a
	ld a,(wInventory.cbb8)
	ld hl,@itemSubmenuWidths-2
	rst_addAToHl
	ld a,(hl)
	ld hl,wInventory.itemSubmenuMaxWidth
	ldi (hl),a

	; [wInventory.itemSubmenuWidth] = 0
	xor a
	ldi (hl),a

	; $cbc1 = 1
	inc a
	ldi (hl),a

	ld (wInventory.itemSubmenuCounter),a
	ld a,(wInventorySubmenu0CursorPos)
	cp $08
	ld a,$0a
	jr nc,+
	add $a0
+
	ldi (hl),a
	ld hl,wSubmenuState
	inc (hl)
;;
@subState1:
	ld hl,wInventory.itemSubmenuCounter
	dec (hl)
	ret nz

	ld (hl),$02
	call @func_02_57f3
	jr c,+

	call func_02_5a35
	ld hl,wSubmenuState
	inc (hl)
+
	jp func_02_55a8

;;
; Waiting for input (direction button or final selection).
;
@subState2:
	ld a,(wKeysJustPressed)
	and BTN_START | BTN_B | BTN_A
	jr nz,@buttonPressed

	call func_02_5938

.ifdef ROM_AGES
	call cpInventorySelectedItemToHarp
	ld a,(wInventory.itemSubmenuIndex)
	jr nz,+
	add $25
	jr ++
+

.else; ROM_SEASONS

	ld a,(wInventory.selectedItem)
	ld a,(wInventory.itemSubmenuIndex)
.endif

	call getSeedTypeInventoryIndex
	add $20
++
	call loadTreasureDisplayData
	ld a,$06
	rst_addAToHl
	ld a,(wInventory.selectedItem)

.ifdef ROM_AGES
	cp ITEMID_SHOOTER
.else
	cp ITEMID_SLINGSHOT
.endif

	ld a,$00
	jr nz,+
	ld a,$05
+
	add (hl)
	call showItemText2
	jp func_02_5a35

@buttonPressed:

.ifdef ROM_AGES
	call cpInventorySelectedItemToHarp
	jr nz,+

	ld e,<wSelectedHarpSong
	ld a,(wInventory.itemSubmenuIndex)
	inc a
	jr ++
+
	ld e,<wSatchelSelectedSeeds
	cp ITEMID_SEED_SATCHEL
	jr z,+
	inc e
+
.else; ROM_SEASONS

	ld a,(wInventory.selectedItem)
	ld e,<wSatchelSelectedSeeds
	cp ITEMID_SEED_SATCHEL
	jr z,+
	inc e
+
.endif

	ld a,(wInventory.itemSubmenuIndex)
	call getSeedTypeInventoryIndex
++
	ld d,>wc600Block
	ld (de),a
	jp inventoryMenuState1@finalizeEquip

;;
@func_02_57f3:
	ld hl,wInventory.itemSubmenuMaxWidth
	ldi a,(hl)
	ld c,a
	ld a,(hl)
	cp c
	jr nc,+

	add $02
	ldi (hl),a
	inc hl
	dec (hl)
	jr ++
+
	inc hl
	ld a,(hl)
	cp $04
	ret nc
	inc (hl)
++
	ld l,<wInventory.itemSubmenuWidth
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld b,a
	ld a,(hl)
	ld hl,w4TileMap+$80
	rst_addAToHl

.ifdef ROM_AGES
	ld de,$0101
	ld a,b
	cp $04
	jr z,+
	set 7,e
+

.else; ROM_SEASONS

	ld de,$0001
.endif

	; d = tile index, e = flags, bc = height/width of rectangle to fill
	; Note the differing values of 'd' at this point between ages and seasons; they
	; use different tiles for the submenus because they have different palettes
	; loaded.

	call fillRectangleInTilemap
	scf
	ret


; Widths for item submenus (satchel/shooter/harp)
; First byte is for 2 options in the menu, 2nd is for 3 options, etc.
@itemSubmenuWidths:
	.db $08 $0a $10 $10

;;
; Going to the next screen (when select is pressed)
inventoryMenuState3:
	ld a,(wSubmenuState)
	rst_jumpTable
	.dw @subState0
	.dw @subState1
	.dw @subState2

@subState0:
	ld hl,wInventorySubmenu
	ld a,(hl)
	inc a
	cp $03
	jr c,+
	xor a
+
	ld (hl),a
	ld a,(wInventory.cbba)
	xor $01
	ld (wInventory.cbba),a
	call func_02_55b2
	ld a,$9f
	ld (wGfxRegs2.WINX),a
	ld hl,wSubmenuState
	inc (hl)
	ld a,SND_OPENMENU
	call playSound

@subState1:
	ldbc $07, $0c
	ld a,(wGfxRegs2.WINX)
	sub c
	cp b
	jr nc,+
	ld a,b
+
	ld (wGfxRegs2.WINX),a
	ld a,(wGfxRegs2.SCX)
	add c
	ld (wGfxRegs2.SCX),a
	cp $98
	ret c

@subState2:
	ld a,$c7
	ld (wGfxRegs2.WINX),a
	xor a
	ld (wGfxRegs2.SCX),a
	ld a,(wGfxRegs2.LCDC)
	xor $48
	ld (wGfxRegs2.LCDC),a
	ld a,$01
	jp inventoryMenuState1@func_02_5606

;;
; Gets a value from 0-3 corresponding to the direction button pressed
; (right/left/up/down) and reads that offset from hl.
;
; This does not use the standard direction order of up/right/down/left; instead it uses
; the order of the bits at the hardware level (right/left/up/down).
;
; @param	hl	Value to read depending on the direction button pressed
; @param[out]	a	Value read from hl
; @param[out]	cflag	Set if a direction button is pressed.
getDirectionButtonOffsetFromHl:
	call getInputWithAutofire
	and $f0
	swap a
	call getLowestSetBit
	ret nc
	rst_addAToHl
	ld a,(hl)
	or a
	scf
	ret

;;
; Check direction buttons and update cursor appropriately on the item menu.
inventorySubscreen0CheckDirectionButtons:
	ld hl,@offsets
	call getDirectionButtonOffsetFromHl
	ret nc

	ld hl,wInventorySubmenu0CursorPos
	add (hl)
	and $0f
	ld (hl),a
	ld a,SND_MENU_MOVE
	jp playSound

@offsets:
	.db $01 $ff $fc $04

;;
; Same as above, but for the second submenu.
inventorySubmenu1CheckDirectionButtons:
	ld hl,@offsets
	call getDirectionButtonOffsetFromHl
	ret nc

	ld c,a
	ld b,a
	inc b

	; Calculate number of selectable positions in total (depends on the level of the
	; ring box). Store the number of selectable positions in 'd'.
	call getRingBoxCapacity
	ld e,$0f
	jr z,+
	inc a
+
	add e
	ld d,a

	ld hl,wInventorySubmenu1CursorPos
	ld a,(hl)
	bit 2,b
	jr nz,@upOrDown

@leftOrRight:
	add c
	cp d
	jr nc,@leftOrRight
	jr ++

@upOrDown:
	cp e
	jr nc,@@ringBoxRow

	add c
	cp e
	jr c,++

@@ringBoxRow:
	ld a,(hl) ; hl=wInventorySubmenu1CursorPos
-
	ld c,a
	call @updateCursorOnRingBoxRow
	cp d
	jr nc,-

++
	ld (hl),a
	ld a,SND_MENU_MOVE
	jp playSound

;;
; @param	b	"Offset" that the cursor is being moved
; @param	c	Cursor position (wInventorySubmenu1CursorPos)
; @param[out]	a	New cursor position
@updateCursorOnRingBoxRow:
	push hl
	ld hl,@ringBoxRowPositionMappings
-
	ldi a,(hl)
	cp c
	jr nz,-

	; Check if movement was up or down
	bit 3,b
	jr z,+
	dec hl
	dec hl
+
	ld a,(hl)
	pop hl
	ret

; b0: position to go to when "up" pressed
; b1: current position of the cursor (assumed on the ring box row)
; b2: position to go to when "down" pressed
@ringBoxRowPositionMappings:
	.db $0a $10 $00
	.db $0b $11 $01
	.db $0c $12 $02
	.db $0d $13 $03
	.db $0e $14 $04
	.db $0a $0f $00

; Cursor offsets when the corresponding direction button is pressed
@offsets:
	.db $01 $ff $fb $05

;;
inventorySubmenu2CheckDirectionButtons:

.ifdef ROM_SEASONS
	ld e,$80
	call checkWhetherToDisplaySeasonInSubscreen
	jr z,+
	ld e,$00
+
.endif

	ld hl,@offsets
	call getDirectionButtonOffsetFromHl
	ret nc

	ld hl,wInventorySubmenu2CursorPos
	ld c,a
	cp $80
	jr nz,@upOrDown

@leftOrRight:
	xor (hl)
	jr ++

@upOrDown:
	bit 7,(hl)
	jr z,@@leftSide

@@rightSide:
	ld hl,wInventory.submenu2CursorPos2
	ld a,(hl)
--
	add c
	and $03

.ifdef ROM_SEASONS
	cp e
	jr z,--
.endif
	cp $03
	jr nc,--
	jr ++

@@leftSide:
	add (hl)
	and $07

++
	ld (hl),a
	ld a,SND_MENU_MOVE
	jp playSound

@offsets:
	.db $80 $80 $ff $01


.ifdef ROM_SEASONS

;;
; @param[out]	zflag	Set if the season should be displayed. (Unset in dungeons,
;			subrosia, etc.)
checkWhetherToDisplaySeasonInSubscreen:
	ld a,(wTilesetFlags)
	and $fc
	ret

.endif
;;
func_02_5938:
	ld a,(wInventory.cbb8)
	ld b,a
	ld hl,@offsets
	call getDirectionButtonOffsetFromHl
	ret nc
	ret z

	ld hl,wTmpcbb5
	add (hl)
	bit 7,a
	jr nz,+
	cp b
	jr c,++
	xor a
	jr ++
+
	ld a,b
	dec a
++
	ld (hl),a
	ld a,SND_MENU_MOVE
	jp playSound

@offsets:
	.db $01 $ff $00 $00

;;
inventorySubscreen0_drawCursor:
	ld a,(wInventorySubmenu0CursorPos)
	ld c,a
	and $0c
	rrca
	rrca
	swap a
	ld b,a
	rrca
	add b
	ld b,a
	ld a,c
	and $03
	swap a
	add a
	ld c,a
	ld hl,@cursorSprites
	jp addSpritesToOam_withOffset

@cursorSprites:
	.db $02
	.db $28 $18 $0c $22 ; left
	.db $28 $38 $0c $02 ; right

;;
inventorySubmenu1_drawCursor:
	ld a,(wInventorySubmenu1CursorPos)
	ld e,a
	ld hl,@data
	rst_addAToHl
	ld a,(hl)
	and $f0
	rrca
	ld b,a
	ld a,(hl)
	and $0f
	swap a

	rrca
	ld c,a
	ld d,$02
	ld a,e

	cp $04
	jr z,+

.ifdef ROM_AGES
	cp $09
	jr z,+
.endif

	sub $0e
	jr z,+

	dec d
	dec a
	jr z,+

	dec d
+
	ld a,d
	ld hl,@spritesTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp addSpritesToOam_withOffset

@data:
	.db $52 $55 $58 $5b $5e $82 $85 $88
	.db $8b $8e $b2 $b5 $b8 $bb $be $e0
	.db $e3 $e6 $e9 $ec $ef

@spritesTable:
	.dw @sprites0
	.dw @sprites1
	.dw @sprites2

@sprites0:
	.db $02
	.db $00 $08 $0c $22
	.db $00 $20 $0c $02

@sprites1:
	.db $02
	.db $00 $0c $0c $22
	.db $00 $24 $0c $02

@sprites2:
	.db $02
	.db $00 $08 $0c $22
	.db $00 $28 $0c $02

inventorySubmenu2_drawCursor:
	ld a,(wInventorySubmenu2CursorPos)
	bit 7,a
	jr z,+
	ld a,(wInventory.submenu2CursorPos2)
	add $08
+
	ld e,a
	ld hl,@offsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	ld a,e
	cp $08
	ld hl,@sprites1
	jr c,+
	ld hl,@sprites2
+
	jp addSpritesToOam_withOffset

@offsets:
	.db $30 $20
	.db $30 $38
	.db $40 $48
	.db $58 $48
	.db $68 $38
	.db $68 $20
	.db $58 $10
	.db $40 $10
	.db $28 $70
	.db $58 $70
	.db $70 $70

@sprites1:
	.db $02
	.db $00 $00 $0c $22
	.db $00 $18 $0c $02

@sprites2:
	.db $02
	.db $00 $00 $0c $22
	.db $00 $28 $0c $02


; For some reason, ages uses a different row to display the numbers for seed counts?
.ifdef ROM_AGES
	.define NUMBER_OFFSET $20
.else; ROM_SEASONS
	.define NUMBER_OFFSET $10
.endif

;;
func_02_5a35:
	ldde $05, $00

.ifdef ROM_AGES
	call cpInventorySelectedItemToHarp
	jr nz,+
	ldde $03, $05
+
.endif

	; d = maximum number of options
	; e = first bit to check in wSeedsAndHarpSongsObtained

	ld b,d
	ld d,$00
@next:
	push bc
	ld a,e
	ld hl,wSeedsAndHarpSongsObtained
	call checkFlag
	jr z,@dontHaveSubItem

	push de
	ld a,d
	call func_02_5afc
	ld a,e
	ld hl,seedAndHarpSpriteTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	call addSpritesToOam_withOffset
	pop de

.ifdef ROM_AGES
	; If this is for the harp, skip over some of the following code
	ld a,e
	cp $05
	jr nc,@seedOnlyCodeDone
.endif

; Seed-only code (for seed satchel, seed shooter)
	ld a,e
	ld hl,wNumEmberSeeds
	rst_addAToHl
	ld b,(hl)
	ld a,(wInventory.cbb8)
	ld hl,table_5ae5-4
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,d
	rst_addAToHl
	ld c,(hl)
	ld hl,w4TileMap+$c0
	ld a,(wInventorySubmenu0CursorPos)
	cp $08
	jr nc,+
	ld hl,w4TileMap+$160
+
	ld a,c
	rst_addAToHl
	ld a,b
	and $f0
	swap a
	add NUMBER_OFFSET
	ldi (hl),a
	ld a,b
	and $0f
	add NUMBER_OFFSET
	ldd (hl),a

@seedOnlyCodeDone:
	inc d

@dontHaveSubItem:
	inc e
	pop bc
	dec b
	jr nz,@next

	ld a,(wTmpcbb5)
	call func_02_5afc
	ld hl,@cursorSprite
	jp addSpritesToOam_withOffset

.undefine NUMBER_OFFSET

; Sprite for cursor in submenus
@cursorSprite:
	.db $01
	.db $28 $0c $0e $03

seedAndHarpSpriteTable:
	.db @sprite0-CADDR
	.db @sprite1-CADDR
	.db @sprite2-CADDR
	.db @sprite3-CADDR
	.db @sprite4-CADDR

.ifdef ROM_AGES
	.db @sprite5-CADDR
	.db @sprite6-CADDR
	.db @sprite7-CADDR
.endif

@sprite0:
	.db $01
	.db $14 $0c $06 $0a

@sprite1:
	.db $01
	.db $14 $0c $08 $0b

@sprite2:
	.db $01
	.db $14 $0c $0a $09

@sprite3:
	.db $01
	.db $14 $0c $0c $09

@sprite4:
	.db $01
	.db $14 $0c $0e $08


.ifdef ROM_AGES

@sprite5:
	.db $02
	.db $14 $08 $46 $08
	.db $14 $10 $48 $08

@sprite6:
	.db $02
	.db $14 $08 $4e $0b
	.db $14 $10 $50 $0b

@sprite7:
	.db $02
	.db $14 $08 $56 $09
	.db $14 $10 $58 $09

.endif


table_5ae5:
	.dw @data2
	.dw @data3
	.dw @data4
	.dw @data5

@data4:
	.db $03
@data2:
	.db $07 $0b $0f
@data5:
	.db $03
@data3:
	.db $06 $09 $0c $0f


.ifdef ROM_AGES
;;
; Set z flag if selected inventory item is the harp.
cpInventorySelectedItemToHarp:
	ld a,(wInventory.selectedItem)
	cp ITEMID_HARP
	ret
.endif


;;
func_02_5afc:
	ld c,a
	ld a,(wInventory.cbb8)
	ld hl,table_5ae5-4
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,c
	rst_addAToHl
	ld a,(hl)
	swap a
	rrca
	ld c,a
	ld b,$20
	ld a,(wInventorySubmenu0CursorPos)
	cp $08
	ret nc
	ld b,$48
	ret

;;
; Convert the index of a seed type to the index in the inventory, based on how
; many types of seeds have been obtained.
; @param a Seed type
getSeedTypeInventoryIndex:
	ld c,a
	inc c
	ld hl,wSeedsAndHarpSongsObtained
	xor a
-
	ld b,a
	call checkFlag
	jr z,+
	dec c
	jr z,++
+
	ld a,b
	inc a
	jr -
++
	ld a,b
	ret

;;
; Draws the "E" on the ring you have equipped.
drawEquippedSpriteForActiveRing:
	call getRingBoxCapacity
	ret z

	ld b,a
	ld a,(wActiveRing)
	cp $ff
	ret z

	ld hl,wRingBoxContents
	ld c,$00
-
	cp (hl)
	jr z,@foundRing
	inc hl
	inc c
	dec b
	jr nz,-
	ret

@foundRing:
	ld a,$18
	call multiplyAByC
	ld c,l
	ld b,$00
	ld hl,@sprite
	jp addSpritesToOam_withOffset

@sprite:
	.db $01
	.db $6e $2e $ec $04

;;
; Draw all items in wInventoryStorage to their appropriate positions.
inventorySubscreen0_drawStoredItems:
	ld a,$10
--
	ldh (<hFF8D),a
	ld hl,wInventoryStorage-1
	rst_addAToHl
	ld a,(hl)
	call loadTreasureDisplayData
	ldi a,(hl)
	call checkTreasureObtained
	ldh (<hFF8B),a
	ldh a,(<hFF8D)
	ld bc,@itemPositions-2
	call addDoubleIndexToBc
	ld a,(bc)
	ld e,a
	inc bc
	ld a,(bc)
	ld d,a
	call drawTreasureDisplayDataToBg
	ldh a,(<hFF8D)
	dec a
	jr nz,--
	ret

; Positions of items in the menu screen.
@itemPositions:
	.dw w4TileMap+$63
	.dw w4TileMap+$67
	.dw w4TileMap+$6b
	.dw w4TileMap+$6f

	.dw w4TileMap+$c3
	.dw w4TileMap+$c7
	.dw w4TileMap+$cb
	.dw w4TileMap+$cf

	.dw w4TileMap+$123
	.dw w4TileMap+$127
	.dw w4TileMap+$12b
	.dw w4TileMap+$12f

	.dw w4TileMap+$183
	.dw w4TileMap+$187
	.dw w4TileMap+$18b
	.dw w4TileMap+$18f

;;
; Modifies the tilemap and displayed text for subscreen 1 based on obtained treasures.
;
inventorySubscreen1_drawTreasures:
	ld hl,subscreen1TreasureData
@drawTreasure:
	ldi a,(hl) ; Read treasure index
	or a
	jr z,@undrawRingBox

	ldh (<hFF8C),a
	call checkTreasureObtained
	jr nc,@nextTreasure

	; Draw it
	ldh (<hFF8B),a ; [hFF8B] = treasure parameter (needed for the "draw" call below)
	ldi a,(hl)
	call @getAddressToDrawTreasureAt
	push hl
	ldh a,(<hFF8C)
	call loadTreasureDisplayData
	inc hl
	call drawTreasureDisplayDataToBg

	; Set text index
	ld c,(hl)
	pop hl
	ldd a,(hl)
	ld de,w4SubscreenTextIndices
	call addAToDe
	ld a,c
	ld (de),a

@nextTreasure:
	inc hl
	inc hl
	jr @drawTreasure

@undrawRingBox:
	; Clear away some tiles based on ring box level
	ld a,(wRingBoxLevel)
	cp $03
	jr z,@drawRings

	ld hl,@ringBoxClearTiles
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,$03
	ld l,a
	ld h,>w4TileMap+1
	call fillRectangleInTileMapWithMenuBlock

@drawRings:
	call getRingBoxCapacity
	ret z

	ld b,a
@drawRing:
	; Get position of ring in tilemap in de
	ld a,b
	ld hl,@ringPositions-1
	rst_addAToHl
	ld e,(hl)
	ld d,>w4TileMap+1

	; Get ring index
	ld a,b
	ld hl,wRingBoxContents-1
	rst_addAToHl
	ld a,(hl)
	cp $ff
	jr z,@nextRing

	; Set ring text
	push bc
	ld c,a
	ld a,b
	ld hl,w4SubscreenTextIndices+$f
	rst_addAToHl
	ld a,c
	or $c0
	ld (hl),a

	; Draw ring
	ld a,c
	call getRingTiles

	pop bc
@nextRing:
	dec b
	jr nz,@drawRing

	; Set text and icon for ring box based on level
	ld a,(wRingBoxLevel)
	add <TX_091d-1
	ld (w4SubscreenTextIndices+$f),a
	ld de,w4TileMap+$182
	ld a,$fe
	jp getRingTiles

;;
; @param	a	"Position" byte to convert
; @param[out]	de	Position in w4TileMap to draw to
@getAddressToDrawTreasureAt:
	ld d,a
	and $f0
	swap a
	add a
	call multiplyABy16
	ld a,d
	and $0f
	add c
	ld de,w4TileMap+$62
	call addAToDe
	ret


; Each byte here is a position to start drawing a ring at (w4TileMap+$100+X).
@ringPositions:
	.db $84 $87 $8a $8d $90


; This table deals with clearing part of subscreen 1 depending on your ring box level.
;   b0: position to start at (w4TileMap+$100+X)
;   b1: number of tiles to clear horizontally
@ringBoxClearTiles:
	.db $81 $12 ; L0
	.db $87 $0c ; L1
	.db $8d $06 ; L2

;;
; Loading graphics for submenu 2?
;
inventorySubscreen2_drawTreasures:
	ld hl,itemSubmenu2TextIndices
	ld de,w4SubscreenTextIndices
	ld b,$0b
	call copyMemory

	; Loop through all essences; delete the ones we don't own.
	; (They're already all drawn to the screen.)
	ld b,$08
@drawEssence:
	ld a,b
	dec a
	ld hl,wEssencesObtained
	call checkFlag
	jr nz,@nextEssence

	; Clear this essence
	push bc
	ld a,b
	ld hl,itemSubmenu2EssencePositions-2
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld bc,$0202
	ld de,$0007
	call fillRectangleInTilemap
	pop bc
	ld a,b
	ld hl,$d3df
	rst_addAToHl
	ld (hl),$00
@nextEssence:
	dec b
	jr nz,@drawEssence

	; Change heart piece text based on how many you have
	ld a,(wNumHeartPieces)
	ld c,a
	ld hl,w4SubscreenTextIndices+9
	add (hl)
	ld (hl),a

	ld a,c
	or a
	jr z,@doneUpdatingHeartPiece

	; Fill in up to 3 sections based on how many heart pieces the player has
	add $10
	ld (w4TileMap+$14f),a
	ld hl,itemSubmenu2HeartPieceDisplayData
@nextQuarterHeart:
	push bc
	ldi a,(hl)
	ld de,w4TileMap+$ce
	call addAToDe
	call drawTreasureDisplayDataToBg
	pop bc
	dec c
	jr nz,@nextQuarterHeart
@doneUpdatingHeartPiece:


; The below code decides how to (and whether to) draw the time or season symbol.
; Naturally the games differ in how they do this.

.ifdef ROM_AGES
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	rlca

.else; ROM_SEASONS

	call checkWhetherToDisplaySeasonInSubscreen
	ld hl,w4TileMap+$4d
	ldbc $04,$06
	jp nz,fillRectangleInTileMapWithMenuBlock

	ld a,(wMinimapGroup)
	sub $02
	jr z,+
	ld a,(wLoadingRoomPack)
	inc a
	jr z,+
	ld a,(wRoomStateModifier)
+
.endif

	ld c,a

	; Set text index for time/season blurb
	ld hl,w4SubscreenTextIndices+8
	add (hl)
	ld (hl),a

	; Load graphic
	ld a,c
	add a
	add a
	add c
	ld hl,itemSubmenu2BlurbDisplayData
	rst_addDoubleIndex
	ld de,w4TileMap+$6e
	call drawTreasureDisplayDataToBg
	ld e,$70
	jp drawTreasureDisplayDataToBg

itemSubmenu2EssencePositions:
	.dw w4TileMap+$084 w4TileMap+$087 w4TileMap+$0c9 w4TileMap+$129
	.dw w4TileMap+$167 w4TileMap+$164 w4TileMap+$122 w4TileMap+$0c2


; Display data for time/season blurb in subscreen 2.
;  b0/b1: left tile index, attribute.
;  b2/b3: right tile index, attribute.
;  b4:    $ff to indicate no extra level/item count/etc drawn (since this uses
;         "drawTreasureDisplayData").
itemSubmenu2BlurbDisplayData:

	.ifdef ROM_AGES
		.db $18 $01 $19 $01 $ff ; Present
		.db $1a $01 $1b $01 $ff
		.db $1c $03 $1d $03 $ff ; Past
		.db $1e $03 $1f $03 $ff

	.else; ROM_SEASONS

		.db $10 $00 $11 $00 $ff ; Spring
		.db $12 $00 $13 $00 $ff
		.db $14 $02 $15 $02 $ff ; Summer
		.db $16 $02 $17 $02 $ff
		.db $18 $03 $19 $03 $ff ; Fall
		.db $1a $03 $1b $03 $ff
		.db $1c $01 $1d $01 $ff ; Winter
		.db $1e $01 $1f $01 $ff

	.endif



; Display data for heart piece quarters in subscreen 2.
;  b0:    offset from top-left of heart
;  b1/b2: left tile index, attribute.
;  b3/b4: right tile index, attribute.
;  b5:    $ff to indicate no extra level/item count/etc drawn (since this uses
;         "drawTreasureDisplayData").
itemSubmenu2HeartPieceDisplayData:
	.db $00 $78 $05 $79 $05 $ff
	.db $40 $7a $05 $7b $05 $ff
	.db $42 $7b $25 $7a $25 $ff

.ifdef ROM_AGES
; Text for essences and the options on the right side in item submenu 2.
itemSubmenu2TextIndices:
	.db <TX_0901, <TX_0902, <TX_0903, <TX_0904, <TX_0905, <TX_0906, <TX_0907, <TX_0908
	.db <TX_0965, <TX_0961, <TX_0960

.else; ROM_SEASONS

itemSubmenu2TextIndices:
	.db <TX_0901, <TX_0902, <TX_0903, <TX_0904, <TX_0905, <TX_0906, <TX_0907, <TX_0908
	.db <TX_0956, <TX_0952, <TX_0951
.endif

;;
; @param[out] a Capacity of ring box.
getRingBoxCapacity:
	push hl
	ld a,(wRingBoxLevel)
	ld hl,@ringBoxCapacities
	rst_addAToHl
	ld a,(hl)
	or a
	pop hl
	ret

@ringBoxCapacities:
	.db $00 $01 $03 $05

;;
; Fills a rectangle with that block tile that separates sections of the inventory menu.
;
; @param	bc	Height, width
; @param	hl	Tilemap (Top-left position to start at)
fillRectangleInTileMapWithMenuBlock:
	ld de,$e701

;;
; Fills a rectangular area in a tilemap with the given values.
;
; @param	b	Height
; @param	c	Width
; @param	de	Tile index (d) and flag (e) to fill in every position
; @param	hl	Tilemap (top-left position to start at)
fillRectangleInTilemap:
	push hl
	ld a,c
--
	ld (hl),d
	set 2,h
	ld (hl),e
	res 2,h
	inc hl
	dec a
	jr nz,--

	pop hl
	ld a,$20
	rst_addAToHl
	dec b
	jr nz,fillRectangleInTilemap
	ret

;;
; Draws an treasure in the inventory to the background layer.
;
; (This is not for the A/B items, since they use sprites as well as the background layer.
; Those are dealt with in the "updateStatusBar" function.)
;
; @param	de	Where to draw to (a tilemap of some sort)
; @param	hl	Pointer to second byte of treasure display data (ie. wTmpcec0+1)
;			(See the "treasureDisplayData" structures for details on format)
; @param	hFF8B	The number to draw with the treasure (if applicable)
drawTreasureDisplayDataToBg:
	; Draw the left tile
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld b,a
	call @writeTile

	; Draw the right tile
	inc e
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld b,a
	call @writeTile

	; Draw the "extra tiles" (ammo count, etc)
	ld a,$20
	call addAToDe
	ldh a,(<hFF8B)
	ld b,a
	ld c,$07
	ldi a,(hl)
	jp drawTreasureExtraTiles

;;
; @param bc
@writeTile:
	push de
	ld a,c
	or a
	jr z,@clearTile

	inc b
	inc b
	add a
	jr nc,+
	set 3,b
+
	ld c,a
	call @writeTileHlpr
	pop de
	ret

@clearTile:
	ld a,$02
	ld (de),a
	set 2,d
	dec a
	ld (de),a
	ld a,$20
	call addAToDe
	ld a,$01
	ld (de),a
	res 2,d
	inc a
	ld (de),a
	pop de
	ret

;;
; Writes tile index to (de) and (de+$20).
; Writes tile attribute to (de+$400), (de+$420).
;
; @param	b	Tile attribute
; @param	c	Tile index
@writeTileHlpr:
	ld a,c
	ld (de),a
	set 2,d
	ld a,b
	ld (de),a
	ld a,$20
	call addAToDe
	ld a,b
	ld (de),a
	res 2,d
	ld a,c
	inc a
	ld (de),a
	ret

;;
; Handles drawing of the maku seed and harp sprites on the inventory subscreens. These are
; at least partly sprites, unlike everything else.
inventoryMenuDrawSprites:

.ifdef ROM_AGES
	call inventoryMenuDrawHarpSprites
.endif

; Remainder of function: draw maku seed sprite

	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	ret nc

	ld bc,$2068
	ld a,(wMenuActiveState)
	cp $03
	jr z,@menuScrolling

@drawIfOnSubscreen1:
	ld a,(wInventorySubmenu)
	dec a
	ret nz
	jr @drawSprite

@menuScrolling:
	ld a,(wSubmenuState)
	or a
	jr z,@drawIfOnSubscreen1

	; Determine which scroll variable to use for calculating the seed's position
	ld a,(wInventorySubmenu)
	or a
	ret z
	dec a
	jr nz,+
	ld a,(wGfxRegs2.WINX)
	sub $07
	jr @drawSpriteWithXOffset
+
	ld a,(wGfxRegs2.SCX)
	cpl
	inc a

@drawSpriteWithXOffset:
	add c
	ld c,a
@drawSprite:
	ld hl,@makuSeedSprite
	jp addSpritesToOam_withOffset

@makuSeedSprite:
	.ifdef ROM_AGES
		.db $04
		.db $08 $00 $fe $0f
		.db $08 $08 $fe $2f
		.db $08 $00 $fa $0b
		.db $08 $08 $fc $0b
	.else
		.db $04
		.db $08 $00 $fe $0c
		.db $08 $08 $fe $2c
		.db $08 $00 $fa $0f
		.db $08 $08 $fc $0f
	.endif


.ifdef ROM_AGES

;;
; Draw harp sprites if it's in the inventory.
inventoryMenuDrawHarpSprites:
	ld hl,wInventoryStorage
	ld bc,$1000
--
	ldi a,(hl)
	cp ITEMID_HARP
	jr z,+
	inc c
	dec b
	jr nz,--
	ret
+
	; Currently, c = position of harp in inventory ($00-$0f).
	; Calculate the offset of the sprite in 'bc' (assuming we're on subscreen 0).
	ld a,c
	and $fc
	ld b,a
	add a
	add b
	add a
	add $14
	ld b,a
	ld a,c
	and $03
	swap a
	add a
	add $22
	ld c,a

	; Check if menu is scrolling
	ld a,(wMenuActiveState)
	cp $03
	jr z,+
--
	ld a,(wInventorySubmenu)
	or a
	ret nz
	jr @drawSprite
+
	ld a,(wSubmenuState)
	or a
	jr z,--

	ld a,(wInventorySubmenu)
	cp $02
	ret z

	or a
	jr nz,+

	ld a,(wGfxRegs2.WINX)
	sub $07
	jr @drawSpriteWithXOffset
+
	ld a,(wGfxRegs2.SCX)
	cpl
	inc a

@drawSpriteWithXOffset:
	add c
	ld c,a
@drawSprite:
	ld a,(wSelectedHarpSong)
	ld hl,seedAndHarpSpriteTable+4
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	jp addSpritesToOam_withOffset


;;
; While an item submenu is up (for harp or satchel), this creates a bunch of "blank
; sprites" that will mask any sprites behind the submenu.
;
; Doesn't exist in seasons since there are no items drawn with sprites on the inventory
; screen (only the harp of ages).
createBlankSpritesForItemSubmenu:
	ld hl,wInventory.cbc1
	ldi a,(hl)
	cp $04
	ret nz

	ld bc,$2800
	ld a,(hl)
	cp $20
	jr c,+
	ld b,$50
+
	ld e,$03
	ld a,(wInventory.cbb8)
	cp $04
	jr nc,+
	dec e
	cp $03
	jr nc,+
	dec e
+
	ld a,e
--
	dec a
	push af
	push bc
	ld hl,@spritesTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	call addSpritesToOam_withOffset
	pop bc
	pop af
	jr nz,--
	ret

@spritesTable:
	.db @sprites0-CADDR
	.db @sprites1-CADDR
	.db @sprites2-CADDR

@sprites0:
	.db $08
	.db $08 $48 $04 $88
	.db $18 $48 $04 $88
	.db $08 $50 $04 $88
	.db $18 $50 $04 $88
	.db $08 $68 $04 $88
	.db $18 $68 $04 $88
	.db $08 $70 $04 $88
	.db $18 $70 $04 $88

@sprites1:
	.db $02
	.db $08 $30 $04 $88
	.db $18 $30 $04 $88

@sprites2:
	.db $06
	.db $08 $28 $04 $88
	.db $18 $28 $04 $88
	.db $08 $88 $04 $88
	.db $18 $88 $04 $88
	.db $08 $90 $04 $88
	.db $18 $90 $04 $88

.endif ; ROM_AGES


; This is a list of treasures that are displayed on subscreen 1 if the player has them.
;   b0: treasure index
;   b1: "position" to draw the treasure at
;   b2: the slot index this treasure occupies
subscreen1TreasureData:

	.ifdef ROM_AGES
		; Row 1
		.db TREASURE_FLIPPERS			$01 $00
		.db TREASURE_MERMAID_SUIT		$01 $00
		.db TREASURE_POTION			$04 $01
		.db TREASURE_TRADEITEM			$07 $02
		.db TREASURE_EMPTY_BOTTLE		$0a $03
		.db TREASURE_FAIRY_POWDER		$0a $03
		.db TREASURE_ZORA_SCALE			$0a $03
		.db TREASURE_TOKAY_EYEBALL		$0a $03
		.db TREASURE_MAKU_SEED			$0a $03
		.db TREASURE_GASHA_SEED			$0d $04

		; Row 2
		.db TREASURE_GRAVEYARD_KEY		$31 $05
		.db TREASURE_CHEVAL_ROPE		$34 $06
		.db TREASURE_RICKY_GLOVES		$34 $06
		.db TREASURE_ISLAND_CHART		$34 $06
		.db TREASURE_MEMBERS_CARD		$34 $06
		.db TREASURE_SCENT_SEEDLING		$37 $07
		.db TREASURE_TUNI_NUT			$37 $07
		.db TREASURE_BOMB_FLOWER		$27 $07
		.db TREASURE_BOMB_FLOWER_LOWER_HALF	$47 $07
		.db TREASURE_CROWN_KEY			$37 $07
		.db TREASURE_BROTHER_EMBLEM		$3a $08
		.db TREASURE_SLATE			$3d $09

		; Row 3
		.db TREASURE_LAVA_JUICE			$61 $0a
		.db TREASURE_GORON_LETTER		$61 $0a
		.db TREASURE_MERMAID_KEY		$61 $0a
		.db TREASURE_ROCK_BRISKET		$64 $0b
		.db TREASURE_GORON_VASE			$64 $0b
		.db TREASURE_GORONADE			$64 $0b
		.db TREASURE_OLD_MERMAID_KEY		$64 $0b
		.db TREASURE_LIBRARY_KEY		$67 $0c
		.db TREASURE_BOOK_OF_SEALS		$6a $0d
		.db TREASURE_RING			$6d $0e
		.db $00

	.else; ROM_SEASONS

		; Row 1
		.db TREASURE_MASTERS_PLAQUE		$01 $00
		.db TREASURE_FLIPPERS			$01 $00
		.db TREASURE_POTION			$04 $01
		.db TREASURE_TRADEITEM			$07 $02
		.db TREASURE_MAKU_SEED			$0a $03
		.db TREASURE_GASHA_SEED			$0d $04

		; Row 2
		.db TREASURE_GNARLED_KEY		$31 $05
		.db TREASURE_RICKY_GLOVES		$34 $06
		.db TREASURE_FLOODGATE_KEY		$34 $06
		.db TREASURE_BOMB_FLOWER		$27 $07
		.db TREASURE_BOMB_FLOWER_LOWER_HALF	$47 $07
		.db TREASURE_PIRATES_BELL		$37 $07
		.db TREASURE_TREASURE_MAP		$3a $08
		.db TREASURE_ROUND_JEWEL		$3d $09
		.db TREASURE_PYRAMID_JEWEL		$3e $09
		.db TREASURE_SQUARE_JEWEL		$4d $09
		.db TREASURE_X_SHAPED_JEWEL		$4e $09

		; Row 3
		.db TREASURE_STAR_ORE			$61 $0a
		.db TREASURE_RIBBON			$61 $0a
		.db TREASURE_STAR_ORE			$61 $0a
		.db TREASURE_SPRING_BANANA		$61 $0a
		.db TREASURE_DRAGON_KEY			$61 $0a
		.db TREASURE_RED_ORE			$64 $0b
		.db TREASURE_HARD_ORE			$64 $0b
		.db TREASURE_BLUE_ORE			$67 $0c
		.db TREASURE_MEMBERS_CARD		$6a $0d
		.db TREASURE_RING			$6d $0e
		.db $00


	.endif


;;
; Performs replacements on minimap tiles, ie. for animal companion regions?
;
; @param	a	Index of replacement data to use
mapMenu_performTileSubstitutions:
	ld hl,mapMenu_tileSubstitutionTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

@nextSubstitution:
	ldi a,(hl)
	or a
	ret z

	ld b,a

	; de = destination
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld d,a

	; hl = src
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	push hl
	ld h,a
	ld l,c

	; b = height, c = width
	ld a,b
	and $0f
	ld c,a
	ld a,b
	and $f0
	swap a
	ld b,a

	; Copy the rectangular area from hl to de
@nextRow:
	push bc
@nextTile:
	ld a,(hl)
	ld (de),a
	set 2,h
	set 2,d
	ldi a,(hl)
	ld (de),a
	inc de
	res 2,h
	res 2,d
	dec c
	jr nz,@nextTile

	pop bc
	ld a,$20
	sub c
	ldh (<hFF8B),a
	rst_addAToHl
	ldh a,(<hFF8B)
	call addAToDe
	dec b
	jr nz,@nextRow

	pop hl
	jr @nextSubstitution

;;
runGaleSeedMenu:
	call clearOam
	call @runState
	jp mapMenu_drawSprites

@runState:
	ld a,(wMenuActiveState)
	rst_jumpTable
	.dw galeSeedMenu_state0
	.dw galeSeedMenu_state1
	.dw galeSeedMenu_state2
	.dw galeSeedMenu_state3

;;
galeSeedMenu_state0:
	call mapMenu_state0

	; This will be incremented, so set to 0, in the next function call
	ld a,$ff
	ld (wMapMenu.warpIndex),a

	ld a,$01
	ld (wMapMenu.drawWarpDestinations),a

	jp galeSeedMenu_addOffsetToWarpIndex

;;
; State 1: waiting for input (direction buttons, A or B)
galeSeedMenu_state1:
	ld a,(wPaletteThread_mode)
	or a
	jr nz,@end

	ld a,(wKeysJustPressed)
	bit BTN_BIT_B,a
	jr nz,@bPressed

	and (BTN_START | BTN_A)
	jr nz,@aPressed

	ld hl,@directionButtonOffsets
	call getDirectionButtonOffsetFromHl
	jr nc,@end

	; Direction button pressed
	call galeSeedMenu_addOffsetToWarpIndex
	ld a,SND_MENU_MOVE
	call nz,playSound
@end:
	jp mapMenu_loadPopupData

@bPressed:
	call mapGetRoomTextOrReturn
	ld a,$03
	ld c,<TX_0301 ; Reselect prompt
	jr @setState

@aPressed:
	call mapGetRoomTextOrReturn
	ld a,c
	ld (wTextSubstitutions+2),a
	ld c,<TX_0300 ; Warp prompt
	ld a,$02

@setState:
	ld (wMenuActiveState),a
	ld b,>TX_0300
	jp showText

@directionButtonOffsets:
	.db $01 ; Right
	.db $ff ; Left
	.db $ff ; Up
	.db $01 ; Down

;;
; State 2: selected a warp destination; waiting for confirmation
galeSeedMenu_state2:
	call retIfTextIsActive

	ld a,(wSelectedTextOption)
	or a
	jr nz,galeSeedMenu_gotoState1
	ld (wOpenedMenuType),a ; $00
	ld a,(wActiveGroup)
	or $80
	ld (wWarpDestGroup),a
	ld a,(wMapMenu.warpIndex)
	call getTreeWarpDataIndex
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ldi a,(hl)
	ld (wWarpDestPos),a
	ld a,$05
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a
	ld a,$03
	call setMusicVolume
	jp fadeoutToWhite

;;
galeSeedMenu_gotoState1:
	ld a,$01
	ld (wMenuActiveState),a
	ret

;;
; State 3: pressed B button; waiting for confirmation to exit
galeSeedMenu_state3:
	call retIfTextIsActive

	; If chose "reselect", go to state 1
	ld a,(wSelectedTextOption)
	or a
	jr z,galeSeedMenu_gotoState1

	; Otherwise exit the menu
	ld a,$ff
	ld (wWarpTransition2),a
	jp closeMenu

;;
; @param	a	Value to add to wMapMenu.warpIndex
; @param[out]	zflag	nz if the warp index changed.
galeSeedMenu_addOffsetToWarpIndex:
	ld e,a
	ld a,(wMapMenu.warpIndex)
	ld d,a
--
	; Keep adding the offset to the index until we reach a valid entry.
	ld a,d
	add e
	and $07
	ld d,a
	call getTreeWarpDataIndex
	ld a,(hl)
	or a
	jr z,--

	; We can only use entry if we've visited the room.
	call mapMenu_checkRoomVisited
	jr z,--

	ldi a,(hl)
	ld (wMapMenu.cursorIndex),a

	ld hl,wMapMenu.warpIndex
	ld a,d
	cp (hl)
	ld (hl),a
	ret

;;
; Shows the map (either overworld or dungeon).
runMapMenu:
	call clearOam
	ld a,(wMenuActiveState)
	rst_jumpTable
	.dw mapMenu_state0
	.dw mapMenu_state1

;;
mapMenu_state0:
	ld a,:w4TileMap
	ld ($ff00+R_SVBK),a

	call loadMinimapDisplayRoom

	; Load one of:
	; - GFXH_OVERWORLD_MAP
	; - GFXH_PAST_MAP (ages) / GFXH_SUBROSIA_MAP (seasons)
	; - GFXH_DUNGEON_MAP
	ld a,(wMapMenu.mode)
	add GFXH_OVERWORLD_MAP
	call loadGfxHeader

	ld a,(wMapMenu.mode)
	add PALH_07
	call loadPaletteHeader

	ld a,(wMapMenu.mode)
	cp $02
	jr z,@dungeon

.ifdef ROM_AGES

	or a
	jr nz,@past

@present:
	; If the companion is not ricky, perform appropriate minimap tile substitutions.
	ld a,(wAnimalCompanion)
	sub SPECIALOBJECTID_DIMITRI
	call nc,mapMenu_performTileSubstitutions

	; Perform tile substitutions if symmetry city has been saved
	ld a,(wPresentRoomFlags+$13)
	rrca
	ld a,$05
	call c,mapMenu_performTileSubstitutions

@past:
	; Check the position of the stone in talus peaks which changes water flow
	ld a,(wPastRoomFlags+$41)
	rrca
	ld a,$06
	call c,mapMenu_performTileSubstitutions

	call mapMenu_clearUnvisitedTiles
	ld a,(wMapMenu.currentRoom)
	ld (wMapMenu.cursorIndex),a
	call mapMenu_loadPopupData
	jr @commonCode

.else; ROM_SEASONS

	or a
	jr nz,@subrosia

@overworld:
	; If the companion is not ricky, perform appropriate minimap tile substitutions.
	ld a,(wAnimalCompanion)
	sub SPECIALOBJECTID_DIMITRI
	call nc,mapMenu_performTileSubstitutions

	; Check whether floodgates have been opened
	ld a,(wPresentRoomFlags+$81)
	rlca
	ld a,$05
	call c,mapMenu_performTileSubstitutions

	call checkPirateShipMoved
	ld a,$06
	call nz,mapMenu_performTileSubstitutions
	jr ++

@subrosia:
	call checkPirateShipMoved
	ld a,$07
	call nz,mapMenu_performTileSubstitutions
++
	call mapMenu_clearUnvisitedTiles
	ld a,(wMapMenu.currentRoom)
	ld (wMapMenu.cursorIndex),a
	call mapMenu_loadPopupData
	jr @commonCode

.endif; ROM_SEASONS


@dungeon:
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	ld a,(wMinimapDungeonFloor)
	jr nz,+
	ld a,(wDungeonFloor)
+
	ld b,a
	ld a,(wDungeonNumFloors)
	dec a
	sub b
	ld (wMapMenu.floorIndex),a

	; Calculate the scroll offset for the dungeon map.
	; [wMapMenu.floorIndex]*10
	call multiplyABy8
	ld a,(wMapMenu.floorIndex)
	add a
	add c
	ld (wMapMenu.dungeonScrollY),a

	call dungeonMap_calculateVisitedFloorsAndLinkPosition

	ld a,(wDungeonIndex)
	add GFXH_DUNGEON_0_BLURB
	call loadGfxHeader
	call dungeonMap_drawSmallKeyCount
	call dungeonMap_generateScrollableTilemap
	call dungeonMap_drawFloorList
	call dungeonMap_updateScroll

; Code for both overworld & dungeon maps
@commonCode:
	xor a
	ld ($ff00+R_SVBK),a
	call mapMenu_drawSprites

	xor a
	ldh (<hCameraX),a
	ldh (<hCameraY),a
	ld (wScreenOffsetX),a
	ld (wScreenOffsetY),a

	ld hl,wMenuActiveState
	inc (hl)

	call mapMenu_copyTilemapToVram
	call fastFadeinFromWhite
	ld a,$07
	jp loadGfxRegisterStateIndex

;;
; Calculates values for wMapMenu.currentRoom and wMapMenu.mode.
;
; Determines where the cursor is and in what way the minimap is shown (overworld/dungeon)
loadMinimapDisplayRoom:

.ifdef ROM_AGES
	ld hl,wMinimapGroup
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	ld b,$02
	ld a,(wTilesetFlags)
	bit TILESETFLAG_BIT_LARGE_INDOORS,a
	jr nz,@overworld
	bit TILESETFLAG_BIT_DUNGEON,a
	jr nz,@setRoom

@overworld:
	ld b,a
	rlca
	and $01 ; This tests TILESETFLAG_PAST
	bit TILESETFLAG_BIT_MAKU,b
	ld b,a
	jr z,@setRoom

	; If the area is the maku tree, hardcode the room index?
	ld c,$38

@setRoom:
	ld a,c
	ld (wMapMenu.currentRoom),a
	ld a,b
	ld (wMapMenu.mode),a
	ret

.else; ROM_SEASONS

	ld hl,wMinimapGroup
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	or a
	jr z,@overworld

	cp $02
	jr z,@makuTree

	cp $04
	jr z,@group4
	jr @setRoom

@overworld:
	; If on the sword upgrade screen, fake the minimap position
	ld a,c
	cp $c9
	jr nz,@setRoom
	ld c,$40
	jr @setRoom

@makuTree:
	; Make the minimap position to be here
	ld bc,$00c9
	jr @setRoom

@group4:
	; Check for the top of dungeon 6; change the minimap to the overworld.
	ld a,(wActiveGroup)
	cp >ROOM_SEASONS_398
	jr nz,@setRoom
	ld a,(wActiveRoom)
	cp <ROOM_SEASONS_398
	jr nz,@setRoom
	ld bc,$0000

@setRoom:
	ld a,c
	ld (wMapMenu.currentRoom),a
	ld a,b
	ld hl,@groupToDisplayMode
	rst_addAToHl
	ld a,(hl)
	ld (wMapMenu.mode),a
	ret


; Each byte is a value for "wMapMenu.mode" for the corresponding group we're on.
; 0=overworld, 1=subrosia, 2=dungeon.
@groupToDisplayMode:
	.db $00 $01 $00 $00 $02 $02 $02 $02

.endif ; ROM_SEASONS


;;
; Draws the number of small keys to the tilemap. (The key itself is a sprite.)
;
dungeonMap_drawSmallKeyCount:
	call getNumSmallKeys
	ret z
	ld hl,w4TileMap+$226
	add $90
	ldd (hl),a
	ld a,$9a ; "x" character
	ld (hl),a
	ret

;;
; Calculates values for:
; * wMapMenu.visitedFloors
; * wMapMenu.dungeonCursorIndex
; * wMapMenu.linkFloor
dungeonMap_calculateVisitedFloorsAndLinkPosition:
	ld a,(wDungeonIndex)
	ld hl,wDungeonVisitedFloors
	rst_addAToHl
	ld b,(hl)
	call checkLinkHasCompass
	ld a,b
	jr z,+

	ld a,(wMapFloorsUnlockedWithCompass)
	or b
+
	ld (wMapMenu.visitedFloors),a

	ld a,(wMinimapDungeonMapPosition)
	ld (wMapMenu.dungeonCursorIndex),a
	ld a,(wMinimapDungeonFloor)
	ld (wMapMenu.linkFloor),a

	; Check for the final battle room with ganon; this room is hardcoded to pretend to
	; be just below the other one
	ld a,(wActiveGroup)
	cp >ROOM_TWINROVA_FIGHT
	ret nz
	ld a,(wActiveRoom)
	cp <ROOM_TWINROVA_FIGHT
	ret nz
	ld a,$13
	ld (wMapMenu.dungeonCursorIndex),a

	ret

;;
mapMenu_state1:
	ld a,(wPaletteThread_mode)
	or a
	call z,@checkInput
	jp mapMenu_drawSprites

;;
@checkInput:
	ld a,(wMapMenu.mode)
	cp $02
	jr nz,@overworld

@dungeon:
	ld a,(wKeysJustPressed)
	and (BTN_B | BTN_SELECT)
	jp nz,closeMenu
	call dungeonMap_updateCursorFlickerCounter
	jp dungeonMap_checkDirectionButtons

@overworld:
	ld a,(wMapMenu.varcbb4)
	or a
	jr z,+
	dec a
	ld (wMapMenu.varcbb4),a
+
	call retIfTextIsActive

	ld hl,@directionOffsets
	call getDirectionButtonOffsetFromHl
	jr nc,@noDirectionButtonPressed

.ifdef ROM_AGES

	ld c,a
	; d,e are Y/X boundaries for the cursor (cursor can't meet or exceed them).
	ldde OVERWORLD_HEIGHT*16, OVERWORLD_WIDTH

.else; ROM_SEASONS

	; In seasons, 'd' is a bitset to AND the position with instead of a maximum value.
	ld c,a
	ldde $f0, OVERWORLD_WIDTH

	; Check for subrosia
	ld a,(wMapMenu.mode)
	rrca
	jr nc,+
	ldde $70, SUBROSIA_WIDTH
+
.endif

	; Set h to vertical component of cursor index, l to horizontal component
	ld a,(wMapMenu.cursorIndex)
	ld l,a
	and $f0
	ld h,a
	ld a,l
	xor h
	ld l,a

	; Update cursor position & check the boundaries
	sra c
	jr c,@verticalMove

@horizontalMove:
	ld a,l
	@loop1:
		add c
		and $0f
		cp e
		jr nc,@loop1
	ld l,a
	jr @setNewCursorIndex

@verticalMove:

.ifdef ROM_AGES
	ld a,h
	@loop2:
		add c
		and $f0
		cp d
		jr nc,@loop2
	ld h,a

.else; ROM_SEASONS

	ld a,h
	add c
	and d
	ld h,a
.endif

@setNewCursorIndex:
	ld a,h
	or l
	ld (wMapMenu.cursorIndex),a
	ld a,SND_MENU_MOVE
	call playSound
	jp mapMenu_loadPopupData

@noDirectionButtonPressed:
	ld a,(wKeysJustPressed)
	bit BTN_BIT_A,a
	jr nz,@showRoomText
	and (BTN_B | BTN_SELECT)
	jp nz,closeMenu
	ret

@showRoomText:
	call mapGetRoomTextOrReturn
	ld hl,wSubmenuState
	inc (hl)
	jp showText

; These are offsets to add to wMapMenu.cursorIndex (shifted left by 1) when
; a direction is pressed. If bit 0 is set, the game checks vertical boundaries instead of
; horizontal.
@directionOffsets:
	.db $02 ; right
	.db $fe ; left
	.db $e1 ; up
	.db $21 ; down

;;
; This function returns from the caller if the selected room hasn't been visited.
;
; @param[out]	bc	Text to show for the selected room on the map.
mapGetRoomTextOrReturn:
	call mapMenu_checkCursorRoomVisited
	jr nz,@visited

	; Return from caller
	pop af
	ret

@visited:
	; Decide whether to display textbox at top or bottom
	ld c,$80

.ifdef ROM_SEASONS
	ld a,(wMapMenu.mode) ; Check if in subrosia
	rrca
	jr nc,+
	ld c,$40
+
.endif
	ld a,(wMapMenu.cursorIndex)
	cp c
	ld a,$03
	jr c,+
	xor a
+
	ld (wTextboxPosition),a

	ld a,TEXTBOXFLAG_NOCOLORS | TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a

	; Fall through

;;
; Like function above, but doesn't set textbox variables, and always returns properly.
;
; @param[out]	bc	Text to show for selected room on the map
mapGetRoomText:
	call mapGetRoomIndexWithoutUnusedColumns
	ld hl,presentMapTextIndices
	jr nc,+
	ld hl,pastMapTextIndices
+
	ld b,>TX_0300
	rst_addAToHl
	ld c,(hl)
	bit 7,c
	ret z

	; If bit 7 was set in "present/pastMapTextIndices", run some special-case code.
	ld a,c
	and $07
	rst_jumpTable
	.dw @specialCode0
	.dw @specialCode1
	.dw @specialCode2
	.dw @specialCode3
	.dw @specialCode4

; Maku tree: text varies based on the point in the game the player is at
@specialCode0:

.ifdef ROM_SEASONS
	; Check if Link has met the maku tree
	ld a,GLOBALFLAG_GNARLED_KEY_GIVEN
	call checkGlobalFlag
	ld c,<TX_0317
	ret z

	; If so, use the appropriate text
	ld a,(wMakuMapTextPresent)
	ld c,a
	ld b,>TX_1700
	ret

.else; ROM_AGES

	push de
	ld a,(wTilesetFlags)
	rlca
	ld de,wMakuMapTextPresent
	ld c,<TX_0323
	ld a,GLOBALFLAG_MAKU_GIVES_ADVICE_FROM_PRESENT_MAP
	jr nc,+

	inc e ; e = wMakuMapTextPast
	inc c ; c = <TX_0324
	inc a ; a = GLOBALFLAG_MAKU_GIVES_ADVICE_FROM_PAST_MAP
+
	; Check if Link has met the maku tree (in the appropriate era)
	call checkGlobalFlag
	ld l,e
	ld h,d
	pop de
	ret z

	; If so, use the appropriate text
	ld a,(hl)
	ld c,a
	ld b,>TX_0500
	ret

.endif ; ROM_AGES


; Dungeons, other unlocked entrances use this?
; After a dungeon has been visited, the overworld map will say the dungeon's name.
; Upper 5 bits of 'c' indicate the "index" to use in a table lookup.
@specialCode1:
	ld a,c
	add a
	swap a
	and $0f
	ld c,a
	call @checkDungeonEntered
	jr nz,+
	ld a,(hl)
	and $7f
	ld c,a
	ret
+
	ld b,>TX_0200
	ret

; Moblin's keep
@specialCode2:
	call checkMoblinsKeepDestroyed
.ifdef ROM_AGES
	ld c,<TX_0317
.else
	ld c,<TX_030b
.endif
	ret nz
	inc c
	ret

; Animal companion regions (not used in ages)
@specialCode3:
	ld a,(wAnimalCompanion)
	sub SPECIALOBJECTID_RICKY
.ifdef ROM_AGES
	add <TX_032d
.else; ROM_SEASONS
	add <TX_0308
.endif
	ld c,a
	ret

; Advance shop: only show the text it's been visited.
@specialCode4:
	call checkAdvanceShopVisited

.ifdef ROM_AGES
	ld c,<TX_0326
	ret z
	dec c
	ret
.else
	ld c,<TX_0321
	ret z
	ld c,<TX_032c
	ret
.endif

;;
; @param	a	Index
; @param[out]	hl	Pointer to some data
; @param[out]	zflag	nz if the dungeon has been entered
@checkDungeonEntered:
	push de
	ld hl,mapMenu_dungeonEntranceText
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,a
	bit 7,(hl)
	ld d,>wGroup4Flags
	jr nz,+
	inc d
+
	ld a,(de)
	bit 4,a
	pop de
	ret

;;
; Checks for popups that should appear? (ie. house, gasha spot)
mapMenu_loadPopupData:
	call mapMenu_checkCursorRoomVisited
	jr z,@noIcon

	ld hl,presentMinimapPopups
	ld a,(wMapMenu.mode)
	rrca
	jr nc,+
	ld hl,pastMinimapPopups
+
	ld a,(wMapMenu.cursorIndex)
	ld c,a

	@loop:
		ldi a,(hl)
		cp $ff
		jr z,@noIcon
		cp c
		ldi a,(hl)
		jr nz,@loop
	jr @gotIcon

@noIcon:
	xor a
@gotIcon:
	ld d,a
	swap a
	call getMinimapPopupType
	ld (wMapMenu.popup2),a
	ld a,d
	call getMinimapPopupType
	ld hl,wMapMenu.popup1
	ldi (hl),a
	or a
	jr nz,+
	ldd a,(hl)
	ldi (hl),a
+
	ldd a,(hl)
	or a
	jr nz,+
	ldi a,(hl)
	ldd (hl),a
+
	; d/e: values to compare against wMapMenu.cursorIndex for when to shift the
	; popup icon's position
	ldde OVERWORD_MAP_POPUP_SHIFT_INDEX_Y<<4, OVERWORD_MAP_POPUP_SHIFT_INDEX_X

.ifdef ROM_SEASONS
	; Check for subrosia
	ld a,(wMapMenu.mode)
	rrca
	jr nc,+
	ldde SUBROSIA_MAP_POPUP_SHIFT_INDEX_Y<<4, SUBROSIA_MAP_POPUP_SHIFT_INDEX_X
+
.endif
	; b/c: position at which to place the popup (may change according to d/e)
	ldbc $20,$80

	ld a,(wMapMenu.cursorIndex)
	cp d
	jr c,+
	ld b,$70
+
	and $0f
	cp e
	jr c,+
	ld c,$20
+
	; Got position of popup in bc
	ld hl,wMapMenu.popupY
	ld a,(hl)
	ld (hl),b
	inc l
	sub b
	ld b,a
	ld a,(hl)
	ld (hl),c

	; Check if the position of the popup changed; reset the popup state if so.
	sub c
	or b
	ret z
	ld l,<wMapMenu.popupState
	ld (hl),$00
	ret

;;
; Input values:
; 0: no popup
; 1: present house
; 2: tokay trading hut
; 3: past house
; 4: maku tree icon (past or present)
; 5: eyeglass library
; 6: shooting gallery
; 7: ring shop or syrup's hut
; 8: cave (checks whether it's been opened)
; 9: gasha spot (only displays if something's been planted)
; A: timeportal spot (checks whether the timeportal is discovered)
; B: advance shop (icon only appears if it's been visited)
; C: shop
; D: moblin's keep (either intact or ruined)
; E: black tower (different icon based on progress)
; F: seed tree (checks the room index to set the tree type)
;
; @param	a	Popup "type"
; @param[out]	a	Popup index to show (an entry in "mapIconOamTable")
getMinimapPopupType:
	and $0f
	ld e,a
	rst_jumpTable

.ifdef ROM_AGES
	.dw minimapPopupType_normal
	.dw minimapPopupType_normal	; present house
	.dw minimapPopupType_normal	; tokay hut
	.dw minimapPopupType_normal	; past house
	.dw minimapPopupType_makuTree
	.dw minimapPopupType_normal	; eyeglass library
	.dw minimapPopupType_normal	; shooting gallery
	.dw minimapPopupType_vasuOrSyrup
	.dw minimapPopupType_cave
	.dw minimapPopupType_gashaSpot
	.dw minimapPopupType_portalSpot
	.dw minimapPopupType_advanceShop
	.dw minimapPopupType_shop
	.dw minimapPopupType_moblinsKeep
	.dw minimapPopupType_blackTower
	.dw minimapPopupType_seedTree

.else; ROM_SEASONS

	.dw minimapPopupType_normal
	.dw minimapPopupType_normal
	.dw minimapPopupType_advanceShop
	.dw minimapPopupType_normal
	.dw minimapPopupType_normal
	.dw minimapPopupType_normal
	.dw minimapPopupType_normal
	.dw minimapPopupType_normal
	.dw minimapPopupType_cave
	.dw minimapPopupType_gashaSpot
	.dw minimapPopupType_portalSpot
	.dw minimapPopupType_pirateShip
	.dw minimapPopupType_shop
	.dw minimapPopupType_moblinsKeep
	.dw minimapPopupType_templeOfSeasons
	.dw minimapPopupType_seedTree
.endif

minimapPopupType_normal:
	ld a,e
	ret

minimapPopupType_advanceShop:
	call checkAdvanceShopVisited
	ret z
	ld a,$0e
	ret


; Check if a cave was unlocked (based on text index being displayed), show popup if so
minimapPopupType_cave:
	ld a,(wMapMenu.cursorIndex)
	call mapGetRoomText
	ld a,$02
	cp b
	jr nz,minimapNoPopup
	ld a,e
	ret


minimapPopupType_gashaSpot:
	ld a,(wMapMenu.cursorIndex)
	call getIndexOfGashaSpotInRoom
	bit 7,c
	jr nz,minimapNoPopup
	ld a,e
	ret


; Area on map with dormant time portal (or subrosia portal for seasons?)
minimapPopupType_portalSpot:
	ld hl,wPresentRoomFlags
	ld a,(wMapMenu.mode)
	rrca
	jr nc,+
	ld hl,wPastRoomFlags
+
	ld a,(wMapMenu.cursorIndex)
	rst_addAToHl
	bit ROOMFLAG_BIT_PORTALSPOT_DISCOVERED,(hl)
	jr z,minimapNoPopup
	ld a,e
	ret

minimapPopupType_seedTree:
	ld a,(wMapMenu.cursorIndex)
	call getTreeWarpDataForRoom
	ret c
	inc hl
	ld a,(hl)
	ret

minimapPopupType_moblinsKeep:
	call checkMoblinsKeepDestroyed
	ld a,$0f
	ret z
	inc a
	ret

minimapNoPopup:
	xor a
	ret

minimapPopupType_shop:

.ifdef ROM_AGES
	ld a,$0e
	ret

.else; ROM_SEASONS

	ld e,$0c
	ld a,(wMapMenu.cursorIndex)
	cp $5e ; Check syrup's shop
	jr z,++
	inc e
	cp $e8 ; Check vasu's shop
	jr z,++
	inc e
++
	ld a,e
	ret

.endif


.ifdef ROM_AGES

minimapPopupType_vasuOrSyrup:
	ld a,(wMapMenu.cursorIndex)
	cp $5d
	ld a,$0c
	ret z
	inc a
	ret

minimapPopupType_blackTower:
	call getBlackTowerProgress
	add $11
	ret

minimapPopupType_makuTree:
	ld a,(wTilesetFlags)
	rlca
	ld a,$0b
	ret c
	ld hl,wPresentRoomFlags+$38
	bit 0,(hl)
	ld a,$04
	ret z
	ld a,$07
	ret

.else; ROM_SEASONS


; Separate popups for each season
minimapPopupType_templeOfSeasons:
	ld e,$11 ; Spring temple
	ld a,(wMapMenu.cursorIndex)
	cp $28
	jr z,++

	inc e ; Summer temple
	cp $08
	jr z,++

	inc e ; Fall temple
	cp $0a
	jr z,++

	inc e ; Winter temple
++
	ld a,e
	ret


; Suppress the pirate ship popup depending on whether it's moved.
minimapPopupType_pirateShip:
	call checkPirateShipMoved
	ld a,e
	ld hl,@shipBefore
	jr z,+
	ld hl,@shipAfter
+
	ld a,(wMapMenu.cursorIndex)
	ld c,a
--
	ldi a,(hl)
	or a
	jr z,minimapNoPopup
	cp c
	jr nz,--
	ld a,e
	ret

; List of rooms where the ship resides before moving (either in overworld or subrosia).
@shipBefore:
	.db $ee $64 $74 $00

; List of rooms where it resides after moving
@shipAfter:
	.db $e2 $f2 $00


.endif ; ROM_SEASONS

;;
maupMenu_drawPopup:
	call @updatePopupVariables
	ld hl,wMapMenu.popupY
	ldi a,(hl)
	ld c,(hl)
	ld b,a

	; If it hasn't finished expanding yet, don't draw the contents of the popup
	ld a,(wMapMenu.popupSize)
	cp $04
	jr nz,@drawBorder

; Draw the "inside" of the icon
	push bc
	ld a,(wMapMenu.popupIndex)
	and $01
	ld hl,wMapMenu.popup1
	rst_addAToHl

	ld a,(hl)
	ld hl,mapIconOamTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	call addSpritesToOam_withOffset
	pop bc

; Draw the "border" of the icon (or the whole thing while it's still expanding)
@drawBorder:
	ld a,(wMapMenu.popupSize)
	ld hl,mapIconBorderOamTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	jp addSpritesToOam_withOffset

;;
; Update the popup icon on the map.
@updatePopupVariables:
	ld de,wMapMenu.popupState
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call @checkPopupExists
	jr z,@resetPopup

	; Go to state 1
	ld a,$01
	ld (de),a

	ld e,<wMapMenu.popupSize
	ld (de),a
	ld e,<wTmpcbba
	inc a
	ld (de),a
	ret

@resetPopup:
	xor a
	ld hl,wMapMenu.popupState
	ldi (hl),a
	; wTmpcbba
	ldi (hl),a

	ld l,<wMapMenu.popupSize
	ld (hl),a
	ld l,<wTmpcbc0
	ld (hl),a
	ret

@state1:
	call @checkPopupExists
	jr z,@gotoState3
	ld l,<wTmpcbba
	dec (hl)
	ret nz
	ld (hl),$02
	ld l,<wMapMenu.popupSize
	inc (hl)
	ld a,(hl)
	cp $04
	ret c
	ld l,<wTmpcbba
	ld (hl),$18
	ld l,<wMapMenu.popupState
	ld (hl),$02

@state2:
	call @checkPopupExists
	jr z,@gotoState3

	ld l,<wTmpcbba
	dec (hl)
	ret nz

	ld (hl),$18
	ld l,<wTmpcbc0
	ld a,(hl)
	xor $01
	ld (hl),a
	ret

@gotoState3:
	ld h,d
	ld l,<wMapMenu.popupState
	ld (hl),$03
	ld l,<wTmpcbba
	ld (hl),$01

@state3:
	ld h,d
	ld l,<wTmpcbba
	dec (hl)
	ret nz

	ld (hl),$02
	ld l,<wMapMenu.popupSize
	ld a,(hl)
	dec a
	ld (hl),a
	ret nz
	jr @resetPopup

;;
; @param[out]	zflag	Set if there is no popup to display.
@checkPopupExists:
	ld h,d
	ld l,<wMapMenu.popup1
	ldi a,(hl)
	or (hl)
	ret

;;
; Checks if pressed up or down on dungeon map, updates accordingly.
dungeonMap_checkDirectionButtons:
	ld a,(wSubmenuState)
	rst_jumpTable
	.dw dungeonMap_scrollingState0
	.dw dungeonMap_scrollingState1

;;
; Dungeon map: waiting for input to scroll up/down
dungeonMap_scrollingState0:
	call getInputWithAutofire
	bit BTN_BIT_DOWN,a
	jr z,+

	call dungeonMap_checkCanScrollDown
	jr nz,@moveUpOrDown
	ret
+
	bit BTN_BIT_UP,a
	ret z
	call dungeonMap_checkCanScrollUp
	ret z

@moveUpOrDown:
	ld c,a
	ld a,b
	ld (wMapMenu.currentRoom),a
	or a
	jr z,+

	; down
	ld a,(wMapMenu.floorIndex)
	add c
	ld (wMapMenu.floorIndex),a
	jr ++
+
	; up
	ld a,(wMapMenu.floorIndex)
	sub c
	ld (wMapMenu.floorIndex),a
++
	ld a,c
	ld d,a
	call multiplyABy8
	ld a,d
	add a
	add c
	inc a
	ld (wMapMenu.varcbb4),a
	ld hl,wSubmenuState
	inc (hl)
	ld a,SND_MENU_MOVE
	jp playSound

;;
; @param[out]	a	Value to add or remove from floor number
; @param[out]	b	$01 to indicate downward direction
; @param[out]	zflag	Set if we're on the bottom floor already.
dungeonMap_checkCanScrollDown:
	; Check if we're on the bottom floor.
	push de
	ld a,(wDungeonNumFloors)
	dec a
	ld b,a
	ld a,(wMapMenu.floorIndex)
	cp b
	jr z,@failure

	; If Link has the map, it's ok to move down.
	call checkLinkHasMap
	ld a,$01
	jr nz,@ret

	; Otherwise, we must check if the floor we want to go to has been visited.
	ld a,(wMapMenu.floorIndex)
	ld c,a
	ld a,(wDungeonNumFloors)
	dec a
	sub c
	ld c,a
	ld e,a
	ld d,$00
--
	inc d
	ld a,e
	sub d
	ld hl,bitTable
	add l
	ld l,a
	ld b,(hl)
	ld a,(wMapMenu.visitedFloors)
	and b
	ld a,d
	jr nz,@ret
	dec c
	jr nz,--

@failure:
	xor a
@ret:
	ld b,$01
	or a
	pop de
	ret

;;
; @param[out]	a	Value to add or remove from floor number
; @param[out]	b	$00 to indicate downward direction
; @param[out]	zflag	Set if we're on the top floor already.
dungeonMap_checkCanScrollUp:
	; Check if we're on the top floor.
	push de
	ld a,(wMapMenu.floorIndex)
	or a
	jr z,@failure

	; If Link has the map, it's ok to move up.
	call checkLinkHasMap
	ld a,$01
	jr nz,@ret

	; Otherwise, we must check if the floor we want to go to has been visited.
	ld a,(wMapMenu.floorIndex)
	ld e,a
	ld a,(wDungeonNumFloors)
	dec a
	sub e
	ld c,e
	ld e,a
	ld d,$00
--
	inc d
	ld a,e
	add d
	ld hl,bitTable
	add l
	ld l,a
	ld b,(hl)
	ld a,(wMapMenu.visitedFloors)
	and b
	ld a,d
	jr nz,@ret
	dec c
	jr nz,--

@failure:
	xor a
@ret:
	ld b,$00
	or a
	pop de
	ret


;;
; Dungeon map: currently scrolling up or down a floor
;
dungeonMap_scrollingState1:
	ld hl,wMapMenu.varcbb4
	dec (hl)
	jr nz,++

	; Done scrolling
	xor a
	ld (wSubmenuState),a
	ret
++
	; In the process of scrolling.
	ld a,(wMapMenu.currentRoom) ; Get scroll direction
	or a
	ld a,$ff
	jr z,+
	ld a,$01
+
	ld hl,wMapMenu.dungeonScrollY
	add (hl)
	ld (hl),a
	call dungeonMap_updateScroll

	; Fall through

;;
mapMenu_copyTilemapToVram:
	xor a
	ld (wStatusBarNeedsRefresh),a
	ld a,UNCMP_GFXH_0a
	jp loadUncompressedGfxHeader

;;
; A lot of maps call this as regular updating code.
;
mapMenu_drawSprites:
	ld a,(wMapMenu.mode)
	cp $02
	jr nz,@overworld

@dungeon:
	call dungeonMap_drawItemSprites
	call dungeonMap_drawLinkIcons
	call dungeonMap_drawCursor
	call dungeonMap_drawArrows
	call dungeonMap_drawBossSymbolForFloor
	jp dungeonMap_drawFloorCursor

@overworld:
	call maupMenu_drawPopup
	call mapMenu_drawArrow
	call mapMenu_drawCursor
	ld a,(wMapMenu.drawWarpDestinations)
	or a
	jp nz,mapMenu_drawWarpSites

.ifdef ROM_AGES
	jp mapMenu_drawTimePortal

.else; ROM_SEASONS

	jp mapMenu_drawJewelLocations
.endif

;;
; Draws small key, boss key, compass, and map on the map screen if Link has them.
dungeonMap_drawItemSprites:
	call getNumSmallKeys
	ld hl,@smallKeySprite
	call nz,addSpritesToOam

	call checkLinkHasBossKey
	ld hl,@bossKeySprite
	call nz,addSpritesToOam

	call checkLinkHasCompass
	ld hl,@compassSprite
	call nz,addSpritesToOam

	call checkLinkHasMap
	ld hl,@mapSprite
	call nz,addSpritesToOam
	ret

@mapSprite:
	.db $02
	.db $7e $10 $00 $03
	.db $7e $18 $02 $03

@compassSprite:
	.db $02
	.db $7e $28 $04 $01
	.db $7e $30 $06 $01

@bossKeySprite:
	.db $02
	.db $90 $10 $08 $05
	.db $90 $18 $0a $05

@smallKeySprite:
	.db $01
	.db $90 $28 $0c $05

;;
; @param[out]	a	Number of small keys Link has for the current dungeon
; @param[out]	zflag	z if Link has no small keys
getNumSmallKeys:
	ld a,(wDungeonIndex)
	ld hl,wDungeonSmallKeys
	rst_addAToHl
	ld a,(hl)
	or a
	ret

;;
; @param[out]	zflag	nz if Link has the boss key for the current dungeon.
checkLinkHasBossKey:
	ld hl,wDungeonBossKeys
	ld a,(wDungeonIndex)
	jp checkFlag

;;
; Unsets Z flag if link has the compass.
checkLinkHasCompass:
	push hl
	ld hl,wDungeonCompasses
	ld a,(wDungeonIndex)
	call checkFlag
	pop hl
	ret

;;
; Unsets Z flag if link has the map.
checkLinkHasMap:
	push hl
	ld hl,wDungeonMaps
	ld a,(wDungeonIndex)
	call checkFlag
	pop hl
	ret

;;
dungeonMap_drawFloorCursor:
	ld a,(wDungeonIndex)
	ld hl,dungeonMapSymbolPositions
	rst_addDoubleIndex

	ld a,(wMapMenu.floorIndex)
	swap a
	rrca
	add (hl)

	ld b,a
	ld c,$00
	ld hl,@cursorOamData
	jp addSpritesToOam_withOffset

@cursorOamData:
	.db $01
	.db $00 $1e $84 $04

;;
; On the dungeon map, this draws the boss symbol next to its floor.
dungeonMap_drawBossSymbolForFloor:
	call checkLinkHasCompass
	ret z

	ld a,(wDungeonIndex)
	ld hl,dungeonMapSymbolPositions+1
	rst_addDoubleIndex

	ld b,(hl)
	ld c,$00
	ld hl,@bossSymbolOamData
	jp addSpritesToOam_withOffset

@bossSymbolOamData:
	.db $01
	.db $00 $38 $82 $05

;;
dungeonMap_drawLinkIcons:
	; Check whether to draw the Link icon on the map.
	ld a,(wMapMenu.dungeonCursorFlicker)
	or a
	jr z,++

	; Get the position of Link's icon on the map, not accounting for scrolling.
	call dungeonMap_getLinkIconPosition
	ld hl,wMapMenu.dungeonScrollY
	ld a,b
	sub (hl)
	cp $12
	jr nc,++

	; Multiply position by 8
	inc a
	swap a
	rrca
	ld b,a
	swap c
	rrc c

	; Draw the Link icon on the map.
	ld hl,@linkOnMapOamData
	call addSpritesToOam_withOffset

++
	; Draw the Link icon on the floor list

	ld a,(wDungeonIndex)
	ld hl,dungeonMapSymbolPositions
	rst_addDoubleIndex

	; Calculate Y position
	ld a,(wMapMenu.linkFloor)
	ld c,a
	ld a,(wDungeonNumFloors)
	dec a
	sub c
	swap a
	rrca
	add (hl)

	ld b,a
	ld c,$00
	ld hl,@linkOnFloorListOamData
	jp addSpritesToOam_withOffset

@linkOnMapOamData:
	.db $01
	.db $00 $58 $80 $00

@linkOnFloorListOamData:
	.db $01
	.db $00 $2c $80 $00

;;
dungeonMap_updateCursorFlickerCounter:
	ld a,(wFrameCounter)
	and $1f
	ret nz
	ld hl,wMapMenu.dungeonCursorFlicker
	ld a,(hl)
	xor $01
	ld (hl),a
	ret

;;
dungeonMap_drawCursor:
	; Return if scrolling
	ld a,(wSubmenuState)
	or a
	ret nz

	; Check cursor flicker cycle
	ld a,(wMapMenu.dungeonCursorFlicker)
	or a
	ret nz

	; Calculate position to draw cursor at
	ld a,(wMapMenu.dungeonCursorIndex)
	and $f8
	ld b,a
	ld a,(wMapMenu.dungeonCursorIndex)
	and $07
	add a
	add a
	add a
	ld c,a
	ld hl,@cursorSprites
	jp addSpritesToOam_withOffset

@cursorSprites:
	.db $02
	.db $34 $54 $88 $04
	.db $34 $5c $88 $24

;;
; Draws the up/down arrows on the dungeon map, assuming it's possible to scroll in those
; directions.
dungeonMap_drawArrows:
	; Return if map is scrolling
	ld a,(wSubmenuState)
	or a
	ret nz

	; Check if we can scroll up
	call dungeonMap_checkCanScrollUp
	jr z,+
	ld hl,@upArrow
	call addSpritesToOam
+
	; Check if we can scroll down
	call dungeonMap_checkCanScrollDown
	ret z
	ld hl,@downArrow
	jp addSpritesToOam

@upArrow:
	.db $01
	.db $24 $74 $86 $05

@downArrow:
	.db $01
	.db $7c $74 $86 $45

;;
; Since the Ages overworld is 14x14, this function returns the room index while ignoring
; the unused columns on the right - so the room at (0,1) has index 14.
;
; @param[out]	a	Index of room (assuming one row = 14 columns instead of 16)
; @param[out]	cflag	Set if TILESETFLAG_PAST/TILESETFLAG_SUBROSIA is set
mapGetRoomIndexWithoutUnusedColumns:

.ifdef ROM_AGES
	push bc

	; b = [wMapMenu.cursorIndex]-cursorY*2. Skips over the two unused columns.
	ld a,(wMapMenu.cursorIndex)
	ld b,a
	and $f0
	swap a
	add a
	ld c,a
	ld a,b
	sub c
	ld b,a

	; cflag = TILESETFLAG_PAST
	ld a,(wTilesetFlags)
	rlca

	ld a,b
	pop bc
	ret

.else; ROM_SEASONS

	; No calculations are necessary unless we're in subrosia.
	ld a,(wMapMenu.mode)
	rrca
	ld a,(wMapMenu.cursorIndex)
	ret nc

	; b = [wMapMenu.cursorIndex]-cursorY*5.
	push bc
	ld b,a
	and $f0
	swap a
	ld c,a
	add a
	add a
	add c
	ld c,a
	ld a,b
	sub c
	pop bc
	scf
	ret

.endif

;;
; @param[out]	zflag	Unset if the room has been visited
mapMenu_checkCursorRoomVisited:
	ld a,(wMapMenu.cursorIndex)

;;
; @param	a	Room to check
; @param[out]	zflag	nz if room has been visited
mapMenu_checkRoomVisited:
	push hl
	ld h,a
	ld a,(wMapMenu.mode)
	rrca
	ld a,h
	ld hl,wPastRoomFlags
	jr c,++

	ld hl,wPresentRoomFlags

.ifdef ROM_SEASONS
	; Special-case for the sword upgrade screen (read the maku tree screen's flag instead)
	cp <ROOM_SEASONS_0c9
	jr nz,++
	ld hl,wPastRoomFlags + <ROOM_SEASONS_10b
	xor a
.endif

++
	rst_addAToHl
	ld a,(hl)
	bit 4,a
	pop hl
	ret

;;
mapMenu_drawArrow:
	ld a,(wFrameCounter)
	and $20
	ret nz
	ld hl,@sprite
	ld a,(wMapMenu.currentRoom)
	jr mapMenu_drawSpriteAtRoomIndex

@sprite:
	.db $01
	.db $06 $08 $0e $47

;;
mapMenu_drawCursor:
	ld hl,@sprite
	ld a,(wMapMenu.cursorIndex)
	jr mapMenu_drawSpriteAtRoomIndex

@sprite:
	.db $02
	.db $0c $04 $88 $06
	.db $0c $0c $88 $26

;;
; Draws a given sprite at a position on the map grid.
;
; @param	a	Room index
; @param	hl	Pointer to sprite data
mapMenu_drawSpriteAtRoomIndex:
	ld c,a
	ldde OVERWORLD_MAP_START_Y*8, OVERWORLD_MAP_START_X*8

.ifdef ROM_SEASONS
	; Check for subrosia
	ld a,(wMapMenu.mode)
	rrca
	jr nc,+
	ldde SUBROSIA_MAP_START_Y*8, SUBROSIA_MAP_START_X*8
+
.endif

	; Calculate sprite offset
	ld a,c
	and $f0
	srl a
	add d
	ld b,a
	ld a,c
	and $0f
	add a
	add a
	add a
	add e
	ld c,a
	jp addSpritesToOam_withOffset

;;
; Draw all positions that Link can warp to on the map screen, using a circle marker.
;
mapMenu_drawWarpSites:
	; Use wTmpcec0 as a place to store and modify the OAM data to be drawn
	ld de,@spriteData
	ld hl,wTmpcec0
	ld b,$05
	call copyMemoryReverse

	; Set the frame of animation to use
	ld a,(wFrameCounter)
	and $18
	rrca
	rrca
	ld l,<wTmpcec0+3
	add (hl)
	ld (hl),a

	; Iterate through each warp position
	ld c,$00
@drawWarpDest:
	ld a,c
	call getTreeWarpDataIndex
	ldi a,(hl)
	or a
	ret z

	; Check if we've visited this room
	push bc
	ld c,a
	call mapMenu_checkRoomVisited
	jr z,@nextTree

	; If so, draw the sprite
	ld a,c
	ld hl,wTmpcec0
	call mapMenu_drawSpriteAtRoomIndex
@nextTree:
	pop bc
	inc c
	jr @drawWarpDest

; The "circle" sprite that marks warp destinations
@spriteData:
	.db $01
	.db $0c $08 $10 $07

;;
; Returns an entry in the "Tree Warp Data" for the current age.
;
; @param	a	Entry index
getTreeWarpDataIndex:
	ld c,a
	call getWarpTreeData
	add a
	add c
	rst_addAToHl
	ret

;;
; Takes a room index (for the current age) and gets the corresponding tree warp data, if
; it exists.
;
; @param	a	Room index
; @param[out]	hl	Pointer to last 2 bytes of tree warp data
; @param[out]	cflag	Set on failure (no tree exists for this room)
getTreeWarpDataForRoom:
	ld c,a
	call getWarpTreeData
--
	ldi a,(hl)
	or a
	scf
	ret z
	cp c
	ret z
	inc hl
	inc hl
	jr --

;;
; See data/[game]/treeWarps.s.
;
; @param[out]	hl	Address of "warp tree" data structure for appropriate age.
getWarpTreeData:
	push af

.ifdef ROM_SEASONS
	ld hl,treeWarps

.else; ROM_AGES
	; Check TILESETFLAG_PAST
	ld hl,pastTreeWarps
	ld a,(wTilesetFlags)
	rlca
	jr c,@ret

	; If in the present, skip over the scent tree if seedling wasn't planted.
	ld hl,presentTreeWarps
	ld a,(wPresentRoomFlags+$ac)
	rlca
	jr c,@ret
	ld a,$03
	rst_addAToHl
.endif

@ret:
	pop af
	ret


.ifdef ROM_AGES

;;
; Draws the time portal sprite on the map. (Ages only)
mapMenu_drawTimePortal:
	; Use wTmpcec0 as a place to store and modify the OAM data to be drawn
	ld de,@portalSprite
	ld hl,wTmpcec0
	ld b,$05
	call copyMemoryReverse

	; Set the frame of animation to use
	ld l,<(wTmpcec0+3)
	ld a,(wFrameCounter)
	add a
	swap a
	and $03
	add a
	add (hl)
	ld (hl),a

	; Check that the portal is in the map group we're currently in
	ld hl,wPortalGroup
	ld a,(wTilesetFlags)
	rlca
	and $01
	cp (hl)
	ret nz

	inc l
	ld a,(hl) ; hl = wPortalRoom
	ld hl,wTmpcec0
	jp mapMenu_drawSpriteAtRoomIndex

@portalSprite:
	.db $01
	.db $0c $08 $18 $07


.else; ROM_SEASONS


;;
; Seasons only: draw the locations of the jewels if Link has the treasure map.
mapMenu_drawJewelLocations:
	; Use wTmpcec0 as a place to store and modify the OAM data to be drawn
	ld de,@sprite
	ld hl,wTmpcec0
	ld b,$05
	call copyMemoryReverse

	; Decide on the frame of animation
	ld l,<wTmpcec0+3
	ld a,(wFrameCounter)
	add a
	swap a
	and $03
	add a
	add (hl)
	ld (hl),a

	; Return if in subrosia
	ld a,(wMapMenu.mode)
	rrca
	ret c

	; Return if Link doesn't have the treasure map
	ld a,TREASURE_TREASURE_MAP
	call checkTreasureObtained
	ret nc

	; Loop through all 4 jewels
	ldbc $04,$00
@drawTreasure:
	; Don't draw it if Link has the jewel
	ld a,c
	add TREASURE_ROUND_JEWEL
	call checkTreasureObtained
	jr c,@nextTreasure

	; Don't draw it if the jewel has been inserted into tarm ruins entrance.
	ld a,c
	ld hl,wInsertedJewels
	call checkFlag
	jr nz,@nextTreasure

	; Treasures are in different locations for linked game
	push bc
	call checkIsLinkedGame
	ld a,c
	jr z,+
	add $04
+
	; Get the location, draw the treasure
	ld hl,@jewelLocations
	rst_addAToHl
	ld a,(hl)
	ld hl,wTmpcec0
	call mapMenu_drawSpriteAtRoomIndex

	pop bc
@nextTreasure
	inc c
	dec b
	jr nz,@drawTreasure
	ret

@jewelLocations:
	.db $b5 $1d $c2 $f4 ; Normal locations
	.db $b5 $7e $a7 $f4 ; Linked game locations

@sprite:
	.db $01
	.db $0c $08 $18 $07


.endif; ROM_SEASONS


;;
; This blanks out all unvisited tiles when opening the map screen.
mapMenu_clearUnvisitedTiles:
	ld a,:w4TileMap
	ld ($ff00+R_SVBK),a

	ldde OVERWORLD_HEIGHT, OVERWORLD_WIDTH
	ld hl,w4TileMap + OVERWORLD_MAP_START_Y*$20 + OVERWORLD_MAP_START_X

.ifdef ROM_SEASONS
	; Different dimensions for subrosia map
	ld a,(wMapMenu.mode)
	rrca
	jr nc,+
	ldde SUBROSIA_HEIGHT, SUBROSIA_WIDTH
	ld hl,w4TileMap + SUBROSIA_MAP_START_Y*$20 + SUBROSIA_MAP_START_X
+
.endif

	ld b,$00

@rowLoop:
	ld c,$00
	push de

@columnLoop:
	ld a,b
	swap a
	add c
	call mapMenu_checkRoomVisited
	jr nz,@nextTile

	; Blank this tile
	ld (hl),$04
	set 2,h
	ld (hl),$0a
	res 2,h

@nextTile:
	inc hl
	inc c
	dec e
	jr nz,@columnLoop

	pop de
	ld a,$20
	sub e
	rst_addAToHl
	inc b
	dec d
	jr nz,@rowLoop
	ret

.ifdef ROM_SEASONS

;;
; @param[out]	zflag	nz if the pirate ship has moved
checkPirateShipMoved:
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	jp checkGlobalFlag

.endif ; ROM_SEASONS

;;
; @param[out]	zflag	nz if moblin's keep is destroyed
checkMoblinsKeepDestroyed:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	jp checkGlobalFlag

;;
; @param[out]	zflag	nz if the shop has been visited
checkAdvanceShopVisited:

.ifdef ROM_AGES
	ld a,(wPastRoomFlags+$fe)
.else
	ld a,(wPastRoomFlags+$af)
.endif
	and ROOMFLAG_VISITED
	ret


;;
; Gets the absolute position of Link's icon on the dungeon map (not accounting for
; scrolling).
;
; @param[out]	bc	Position to draw Link tile at (in tiles)
dungeonMap_getLinkIconPosition:
	ld a,(wMapMenu.linkFloor)
	ld b,a
	ld a,(wDungeonNumFloors)
	dec a
	sub b

	; a *= 10 (there is a 10 tile gap between each floor)
	ld h,a
	call multiplyABy8
	ld a,h
	add a
	add c

	add $05
	ld b,a

	; Now calculate the Y/X offsets within this floor
	ld a,(wMapMenu.dungeonCursorIndex)
	and $f8
	swap a
	rlca
	ld c,a
	ld a,b
	add c
	ld b,a
	ld a,(wMapMenu.dungeonCursorIndex)
	and $07
	ld c,a
	ret

;;
; Draws the floor list on the left side of the dungeon map menu.
; Called once when opening the dungeon map.
dungeonMap_drawFloorList:
	ld a,:w4TileMap
	ld ($ff00+R_SVBK),a

	ld a,(wDungeonIndex)
	ld hl,dungeonMapFloorListStartPositions
	rst_addAToHl
	ldi a,(hl)
	ld de,w4TileMap+$a0
	call addAToDe

	ld a,(wDungeonNumFloors)
	dec a
	ld c,a
@loop:
	call checkLinkHasMap
	jr nz,++

	; If Link doesn't have the map, we need to check if we've visited this floor
	ld a,c
	ld hl,bitTable
	add l
	ld l,a
	ld a,(wMapMenu.visitedFloors)
	and (hl)
	ld a,$20
	jr z,@nextFloor
++
	; Draw the floor name
	ld a,(wDungeonMapBaseFloor)
	add c
	ld hl,dungeonMapFloorNameTiles
	rst_addDoubleIndex
	ld b,$02
	ldi a,(hl)
	call drawTileABtoDE
	ldi a,(hl)
	call drawTileABtoDE

	ld a,$9c ; 'F' for "floor"
	call drawTileABtoDE

	; Draw 2-tile rectangular box representing the floor
	inc e
	ld b,$04
	ld a,$aa
	call drawTileABtoDE
	ld a,$ab
	call drawTileABtoDE

	ld a,$1a
@nextFloor:
	call addAToDe
	ld a,c
	dec c
	or a
	jr nz,@loop
	ret

;;
; @param	a,b	Tile index/map to draw
; @param	de	Position in w4TileMap to draw to
drawTileABtoDE:
	ld (de),a
	set 2,d
	ld a,b
	ld (de),a
	res 2,d
	inc de
	ret

;;
; Generates the tilemap for the scrollable portion of the dungeon map and stores it in
; w4GfxBuf1. Called once when opening a dungeon map.
dungeonMap_generateScrollableTilemap:
	ld de,w4GfxBuf1
	ld a,$28
	call @fillTileMapWithBlank

	ld a,(wDungeonNumFloors)
	ldh (<hFF8D),a
@nextFloor:
	ldh a,(<hFF8D)
	dec a
	call dungeonMap_getFloorAddress
	call dungeonMap_checkCanViewFloor
	ld a,$50
	jr z,@doneThisFloor

	ld a,$40
	ldh (<hFF8C),a
@nextTile:
	ld a,:w2DungeonLayout
	ld ($ff00+R_SVBK),a
	ldi a,(hl)
	ld c,a
	ld a,:w4GfxBuf1
	ld ($ff00+R_SVBK),a
	ld a,c
	call dungeonMap_getTileForRoom
	ld (de),a
	inc de
	ldh a,(<hFF8C)
	dec a
	ldh (<hFF8C),a
	jr nz,@nextTile

	; Fill 2 rows in-between with black
	ld a,$10

@doneThisFloor:
	call @fillTileMapWithBlank

	ldh a,(<hFF8D)
	dec a
	ldh (<hFF8D),a
	jr nz,@nextFloor

	; Fill another 3 rows with black
	ld a,$18

;;
; @param	a	Number of tiles to fill horizontally
; @param	de	Address to start at
@fillTileMapWithBlank:
	push bc
	ld c,a
	ld a,$ad ; Blank tile (outside of map region)
--
	ld (de),a
	inc de
	dec c
	jr nz,--
	pop bc
	ret

;;
; Redraws the tilemap for the dungeon map screen.
;
; Prior to calling this, w4GfxBuf stores the tilemap to be scrolled through.
dungeonMap_updateScroll:
	ld a,($ff00+R_SVBK)
	push af
	ld a,(wMapMenu.dungeonScrollY)
	call multiplyABy8
	ld hl,w4GfxBuf1
	add hl,bc
	ld de,w4TileMap+$0a

	; Iterate through 18 rows (height of screen)
	ld a,18
	ldh (<hFF8D),a

@nextRow:
	ld c,$08
@nextColumn:
	ld a,:w4GfxBuf1
	ld ($ff00+R_SVBK),a

	; a = tile index
	ld a,(hl)

	; b = flags
	ld b,$00
	cp $83 ; Boss room: palette 0
	jr z,++
	cp $ad ; Background: palette 0
	jr z,++

	ld b,$02
	cp $ae ; Treasure chest: palette 2
	jr z,++

	ld b,$04
	cp $af ; Unvisited room: palette 4
	jr z,++

	; Everything else: palette 5
	ld b,$05
++
	call drawTileABtoDE
	inc hl
	dec c
	jr nz,@nextColumn

	ld a,$18
	call addAToDe
	ldh a,(<hFF8D)
	dec a
	ldh (<hFF8D),a
	jr nz,@nextRow

	; Done drawing tiles

	pop af
	ld ($ff00+R_SVBK),a

	; Missing a "ret" opcode here.
	; This normally doesn't seem to cause any problems, though perhaps it's related to
	; the dungeon map crashes on the VBA emulator?

;;
; @param	a	Room index
; @param[out]	a	Tile index to draw on the map for this room
dungeonMap_getTileForRoom:
	push bc
	push de
	ld b,a

	; Room index 0 stands for "nothing".
	or a
	jr z,@hidden

	; Load the room flags into 'd', dungeon properties into 'e'.
	push hl
	ld l,b
	ld a,(wDungeonFlagsAddressH)
	ld h,a
	ld d,(hl)
	call getRoomDungeonProperties
	ld e,b
	pop hl

	; The combination of flags "chest + boss" means it's a hidden room.
	ld a,e
	cp (DUNGEONROOMPROPERTY_CHEST | DUNGEONROOMPROPERTY_BOSS)
	jr z,@hidden
	cp (DUNGEONROOMPROPERTY_CHEST | DUNGEONROOMPROPERTY_BOSS | DUNGEONROOMPROPERTY_KEY)
	jr z,@hidden

	bit ROOMFLAG_BIT_VISITED,d
	jr nz,@visited

; Room not visited; only show it if the compass reveals something or link has the map.

	call dungeonMap_checkCompassTile
	jr nz,@ret

	call checkLinkHasMap
	ld a,$af ; Unvisited tile
	jr nz,@ret

@hidden:
	ld a,$ac ; Blank tile
	jr @ret

	; Unreachable code?
	call dungeonMap_checkCompassTile
	jr nz,@ret
	ld a,$af ; Unvisited tile
	jr @ret

@visited:
	call dungeonMap_checkCompassTile
	jr nz,@ret

	; Calculate which tile to use based on the directions the room leads to.
	ld a,d
	or e
	and $0f
	add $b0
@ret:
	pop de
	pop bc
	ret

;;
; @param	hFF8D	A floor index?
; @param[out]	zflag	Set if link can't view that floor on the map.
dungeonMap_checkCanViewFloor:
	call checkLinkHasMap
	ret nz
	push hl
	ldh a,(<hFF8D)
	dec a
	ld hl,bitTable
	add l
	ld l,a
	ld a,(wMapMenu.visitedFloors)
	and (hl)
	pop hl
	ret

;;
; For the dungeon map; check a room's dungeon flags and room flags to see if something
; should be revealed by the compass (ie. treasure tile).
;
; @param	d	Room flags
; @param	e	Dungeon room flags
; @param[out]	a	Tile to draw (if $00, no special tile is drawn)
; @param[out]	zflag	Set if no special tile should be drawn (instead, the caller will
;			decide which of the "normal" directional tiles to use).
dungeonMap_checkCompassTile:
	call checkLinkHasCompass
	ret z

	ld a,e
	ld c,$83 ; Boss tile
	and (DUNGEONROOMPROPERTY_KEY|DUNGEONROOMPROPERTY_CHEST|DUNGEONROOMPROPERTY_BOSS)
	cp DUNGEONROOMPROPERTY_BOSS
	jr z,@@ret

	cp DUNGEONROOMPROPERTY_CHEST
	jr z,@@treasure
	cp (DUNGEONROOMPROPERTY_KEY|DUNGEONROOMPROPERTY_CHEST)
	jr nz,@@nothing

@@treasure:
	ld c,$ae ; Treasure tile
	ld a,d
	and ROOMFLAG_ITEM ; Check if the treasure has been obtained
	jr z,@@ret
@@nothing:
	ld c,$00
@@ret:
	ld a,c
	or a
	ret

;;
; @param	a	Floor?
; @param[out]	hl	Start of floor in w2DungeonLayout
dungeonMap_getFloorAddress:
	call multiplyABy16
	ld hl,w2DungeonLayout
	add hl,bc
	add hl,bc
	add hl,bc
	add hl,bc
	ret


; Each 2 bytes are two tile indices for a floor name on the dungeon map.
dungeonMapFloorNameTiles:
	.db $9b $93 ; B3
	.db $9b $92 ; B2
	.db $9b $91 ; B1
	.db $80 $91 ; F1
	.db $80 $92 ; F2
	.db $80 $93 ; F3
	.db $80 $94 ; F4
	.db $80 $95 ; F5
	.db $80 $96 ; F6
	.db $80 $97 ; F7
	.db $80 $98 ; F8

; Each byte is an offset in w4TileMap at which to start listing the floors on the left
; side of the screen.
dungeonMapFloorListStartPositions:
	.ifdef ROM_AGES
		.db $80 $80 $80 $80
		.db $80 $80 $80 $60
		.db $40 $60 $60 $60
		.db $80 $80

	.else; ROM_SEASONS

		.db $80 $80 $80 $80
		.db $60 $80 $40 $60
		.db $60 $60 $60 $60
	.endif

; b0: Y position at which to draw the cursor and Link (for the bottom floor)
; b1: Y position at which to draw the Boss symbol in a dungeon (next to the floor indicator)
dungeonMapSymbolPositions:
	.ifdef ROM_AGES
		.db $50 $00
		.db $50 $50
		.db $50 $50
		.db $50 $58
		.db $50 $58
		.db $50 $50
		.db $50 $00
		.db $48 $50
		.db $40 $58
		.db $48 $48
		.db $48 $48
		.db $48 $48
		.db $50 $50
		.db $50 $00

	.else; ROM_SEASONS

		.db $50 $00
		.db $50 $50
		.db $50 $50
		.db $50 $50
		.db $48 $58
		.db $50 $50
		.db $40 $40
		.db $48 $50
		.db $48 $50
		.db $48 $48
		.db $48 $48
		.db $48 $48
	.endif



; This is a table of oam data for a map icon's "border". Entries 0-3 are for while the
; icon is still expanding; entry 4 is for when it's at full size.
mapIconBorderOamTable:
	.db @entry0 - CADDR
	.db @entry1 - CADDR
	.db @entry2 - CADDR
	.db @entry3 - CADDR
	.db @entry4 - CADDR

@entry0:
	.db $00
@entry1:
	.db $01
	.db $08 $04 $00 $06
@entry2:
	.db $02
	.db $08 $00 $02 $06
	.db $08 $08 $02 $26
@entry3:
	.db $08
	.db $00 $f8 $04 $06
	.db $00 $00 $06 $06
	.db $00 $08 $06 $26
	.db $00 $10 $04 $26
	.db $10 $f8 $04 $46
	.db $10 $00 $06 $46
	.db $10 $08 $06 $66
	.db $10 $10 $04 $66
@entry4:
	.db $08
	.db $00 $f8 $08 $06
	.db $00 $00 $0a $06
	.db $00 $08 $0a $26
	.db $00 $10 $08 $26
	.db $10 $f8 $08 $46
	.db $10 $00 $0a $46
	.db $10 $08 $0a $66
	.db $10 $10 $08 $66


; This is a table of OAM data for map icons, ie. showing screens with houses, shops, etc.
; The output of the "getMinimapPopupType" function corresponds to an entry in this table.
mapIconOamTable:
	.db @mapIcon00 - CADDR
	.db @mapIcon01 - CADDR
	.db @mapIcon02 - CADDR
	.db @mapIcon03 - CADDR
	.db @mapIcon04 - CADDR
	.db @mapIcon05 - CADDR
	.db @mapIcon06 - CADDR
	.db @mapIcon07 - CADDR
	.db @mapIcon08 - CADDR
	.db @mapIcon09 - CADDR
	.db @mapIcon0A - CADDR
	.db @mapIcon0B - CADDR
	.db @mapIcon0C - CADDR
	.db @mapIcon0D - CADDR
	.db @mapIcon0E - CADDR
	.db @mapIcon0F - CADDR
	.db @mapIcon10 - CADDR
	.db @mapIcon11 - CADDR
	.db @mapIcon12 - CADDR
	.db @mapIcon13 - CADDR
	.db @mapIcon14 - CADDR
	.db @mapIcon15 - CADDR
	.db @mapIcon16 - CADDR
	.db @mapIcon17 - CADDR
	.db @mapIcon18 - CADDR
	.db @mapIcon19 - CADDR

.ifdef ROM_AGES

@mapIcon00:
	.db $00
@mapIcon01: ; House
	.db $02
	.db $08 $00 $22 $05
	.db $08 $08 $22 $25
@mapIcon02: ; Tokay trading hut
	.db $02
	.db $08 $00 $34 $03
	.db $08 $08 $34 $23
@mapIcon03: ; Past house
	.db $02
	.db $08 $00 $32 $03
	.db $08 $08 $32 $23
@mapIcon04: ; Present maku tree
	.db $02
	.db $08 $00 $28 $03
	.db $08 $08 $2a $03
@mapIcon05: ; Eyeglass library
	.db $02
	.db $08 $00 $36 $01
	.db $08 $08 $36 $21
@mapIcon06: ; Shooting gallery
	.db $02
	.db $08 $00 $44 $02
	.db $08 $08 $46 $02
@mapIcon07: ; Maku tree in danger?
	.db $02
	.db $08 $00 $2c $03
	.db $08 $08 $2e $03
@mapIcon08: ; Cave entrance
	.db $02
	.db $08 $00 $20 $03
	.db $08 $08 $20 $23
@mapIcon09: ; Planted gasha seed
	.db $02
	.db $08 $00 $26 $04
	.db $08 $08 $26 $24
@mapIcon0A: ; Timeportal
	.db $02
	.db $08 $00 $30 $03
	.db $08 $08 $30 $63
@mapIcon0B: ; Maku sprout
	.db $02
	.db $08 $00 $38 $03
	.db $08 $08 $38 $23
@mapIcon0C: ; Syrup
	.db $02
	.db $08 $00 $24 $03
	.db $08 $08 $24 $23
@mapIcon0D: ; Ring shop
	.db $02
	.db $08 $00 $40 $00
	.db $08 $08 $42 $00
@mapIcon0E: ; Shop
	.db $02
	.db $08 $00 $54 $06
	.db $08 $08 $56 $06
@mapIcon0F: ; Moblin's keep
	.db $02
	.db $08 $00 $4c $01
	.db $08 $08 $4e $01
@mapIcon10: ; Ruined keep
	.db $02
	.db $08 $00 $50 $01
	.db $08 $08 $52 $01
@mapIcon11: ; Black tower (small)
	.db $02
	.db $08 $00 $3a $01
	.db $08 $08 $3a $21
@mapIcon12: ; Black tower (medium)
	.db $02
	.db $08 $00 $3c $01
	.db $08 $08 $3c $21
@mapIcon13: ; Black tower (large)
	.db $02
	.db $08 $00 $3e $01
	.db $08 $08 $3e $21
@mapIcon14: ; Nothing
	.db $00

; After this are tree icons (15-19) common to both games


.else; ROM_SEASONS

@mapIcon00:
@mapIcon02:
	.db $00

@mapIcon01: ; House
	.db $02
	.db $08 $00 $22 $05
	.db $08 $08 $22 $25

@mapIcon03: ; Stump
	.db $02
	.db $08 $00 $2c $03
	.db $08 $08 $2e $03

@mapIcon04: ; Maku tree
	.db $02
	.db $08 $00 $28 $03
	.db $08 $08 $2a $03

@mapIcon05: ; Subrosian house
	.db $02
	.db $08 $00 $32 $05
	.db $08 $08 $34 $05

@mapIcon06: ; Subrosian market
	.db $02
	.db $08 $00 $36 $05
	.db $08 $08 $36 $25

@mapIcon07: ; Biggoron
	.db $02
	.db $08 $00 $44 $03
	.db $08 $08 $46 $03

@mapIcon08: ; Cave entrance
	.db $02
	.db $08 $00 $20 $03
	.db $08 $08 $20 $23

@mapIcon09: ; Planted gasha seed
	.db $02
	.db $08 $00 $26 $04
	.db $08 $08 $26 $24

@mapIcon0A: ; Subrosia portal
	.db $02
	.db $08 $00 $30 $02
	.db $08 $08 $30 $62

@mapIcon0B: ; Pirate ship
	.db $02
	.db $08 $00 $48 $03
	.db $08 $08 $4a $03

@mapIcon0C: ; Syrup
	.db $02
	.db $08 $00 $24 $03
	.db $08 $08 $24 $23

@mapIcon0D: ; Ring shop
	.db $02
	.db $08 $00 $40 $00
	.db $08 $08 $42 $00

@mapIcon0E: ; Shop
	.db $02
	.db $08 $00 $54 $06
	.db $08 $08 $56 $06

@mapIcon0F: ; Moblin's keep
	.db $02
	.db $08 $00 $4c $01
	.db $08 $08 $4e $01

@mapIcon10: ; Ruined moblin's keep
	.db $02
	.db $08 $00 $50 $01
	.db $08 $08 $52 $01

@mapIcon11: ; Spring temple
	.db $02
	.db $08 $00 $38 $00
	.db $08 $08 $38 $20

@mapIcon12: ; Summer temple
	.db $02
	.db $08 $00 $3a $05
	.db $08 $08 $3a $25

@mapIcon13: ; Fall temple
	.db $02
	.db $08 $00 $3c $04
	.db $08 $08 $3c $24

@mapIcon14: ; Winter temple
	.db $02
	.db $08 $00 $3e $02
	.db $08 $08 $3e $22

.endif ; ROM_SEASONS

; Tree icons common to both games

@mapIcon15: ; Ember tree
	.db $02
	.db $08 $00 $58 $04
	.db $08 $08 $5a $04
@mapIcon16: ; Scent tree
	.db $02
	.db $08 $00 $5c $04
	.db $08 $08 $5e $04
@mapIcon17: ; Pegasus tree
	.db $02
	.db $08 $00 $60 $04
	.db $08 $08 $62 $04
@mapIcon18: ; Gale tree
	.db $02
	.db $08 $00 $64 $04
	.db $08 $08 $66 $04
@mapIcon19: ; Mystery tree
	.db $02
	.db $08 $00 $68 $04
	.db $08 $08 $6a $04


.ifdef ROM_AGES

	; This is a table of tile substitutions to perform on the overworld map in various
	; situations.
	mapMenu_tileSubstitutionTable:
		.db @subst0 - CADDR
		.db @subst1 - CADDR
		.db @subst2 - CADDR
		.db @subst3 - CADDR
		.db @subst4 - CADDR
		.db @subst5 - CADDR
		.db @subst6 - CADDR

	; Data format:
	;  b0: Height/width of rectangular area to copy (or $00 to stop)
	;  w1: Address to write to
	;  w2: Address to read from (alternate layouts are stored just off-screen)

	@subst0: ; Animal companion region: dimitri
		dbww $33 w4TileMap+$068 w4TileMap+$075
		.db  $00

	@subst1: ; Animal companion region: moosh
		dbww $33 w4TileMap+$068 w4TileMap+$078
		.db  $00

	@subst2: ; Ring appraisal screen: L-1 ring box
		dbww $2d w4TileMap+$207 w4TileMap+$213
		.db  $00

	@subst3: ; Ring appraisal screen: L-2 ring box
		dbww $2d w4TileMap+$20d w4TileMap+$213
	@subst4: ; Ring appraisal screen: L-3 ring box
		.db  $00

	@subst5: ; Symmetry city: restored to balance
		dbww $23 w4TileMap+$045 w4TileMap+$07b
		.db  $00

	@subst6: ; Talus peaks: water shifted
		dbww $23 w4TileMap+$0c3 w4TileMap+$0d5
		.db  $00

.else; ROM_SEASONS

	; This is a table of tile substitutions to perform on the overworld map in various
	; situations.
	mapMenu_tileSubstitutionTable:
		.db @subst0 - CADDR
		.db @subst1 - CADDR
		.db @subst2 - CADDR
		.db @subst3 - CADDR
		.db @subst4 - CADDR
		.db @subst5 - CADDR
		.db @subst6 - CADDR
		.db @subst7 - CADDR

	; Data format:
	;  b0: Height/width of rectangular area to copy (or $00 to stop)
	;  w1: Address to write to
	;  w2: Address to read from (alternate layouts are stored just off-screen)

	@subst0: ; Companion region: dimitri
		dbww $45 w4TileMap+$0a8 w4TileMap+$0b6
		.db $00

	@subst1: ; Companion region: moosh
		dbww $45 w4TileMap+$0a8 w4TileMap+$0bb
		.db $00

	@subst2: ; Ring appraisal screen: L-1 ring box
		dbww $2d w4TileMap+$207 w4TileMap+$213
		.db $00

	@subst3: ; Ring appraisal screen: L-2 ring box
		dbww $2d w4TileMap+$20d w4TileMap+$213
	@subst4: ; Ring appraisal screen: L-3 ring box
		.db $00

	@subst5: ; Replace floodgates section with dried version
		dbww $22 w4TileMap+$0e2 w4TileMap+$0f4
		.db $00

	@subst6: ; Overworld: replace pirate ship tiles after moving
		dbww $21 w4TileMap+$1e4 w4TileMap+$1fe
		dbww $11 w4TileMap+$1f0 w4TileMap+$1ff
		.db $00

	@subst7: ; Subrosia: replace pirate ship tiles after moving
		dbww $21 w4TileMap+$168 w4TileMap+$178
		.db $00

.endif; ROM_SEASONS


.include {"{GAME_DATA_DIR}/mapTextAndPopups.s"}


; This table changes the text of a tile on a map depending on if a dungeon has been entered.
; b0: Room index; if Link's visited this room, use the dungeon's name as the text. Group number is
;     determined by bit 7 of b1 (see below).
; b1: Bits 0-6: Text index to use if the dungeon hasn't been entered.
;               If it HAS been entered, the index will be $02XX, where XX is the index used for this
;               table's lookup (a dungeon index).
;     Bit 7: 0=group 5, 1=group 4 (reversed from what you might expect)
mapMenu_dungeonEntranceText:

	.ifdef ROM_AGES
		.db $04, $80|(<TX_0307)
		.db $24, $80|(<TX_0309)
		.db $46, $80|(<TX_0337)
		.db $66, $80|(<TX_0311)
		.db $91, $80|(<TX_0303)
		.db $bb, $80|(<TX_0305)
		.db $26,     (<TX_0306)
		.db $56,     (<TX_030a)
		.db $aa,     (<TX_0336)
		.db $01, $80|(<TX_0332)
		.db $f4,     (<TX_0332)
		.db $ce, $80|(<TX_0332)
		.db $44,     (<TX_0306)
		.db $0d, $80|(<TX_0332)
		.db $01,     (<TX_0332)
		.db $01, $80|(<TX_0332)

	.else; ROM_SEASONS

		.db $04, $80|(<TX_0313)
		.db $1c, $80|(<TX_030f)
		.db $39, $80|(<TX_0311)
		.db $4b, $80|(<TX_030e)
		.db $81, $80|(<TX_0305)
		.db $a7, $80|(<TX_0310)
		.db $ba, $80|(<TX_032b)
		.db $5b,     (<TX_0312)
		.db $87,     (<TX_0330)
		.db $97,     (<TX_0302)
	.endif


.include {"{GAME_DATA_DIR}/treeWarps.s"}


;;
; This is either the "ring appraisal" or "ring list" menu.
; If "wRingMenu_mode" is 0, it's the appraisal menu; otherwise it's the ring list.
runRingMenu:
	; Clear OAM, but always leave the first 4 slots reserved for status bar items.
	call clearOam
	ld a,$10
	ldh (<hOamTail),a

	ld hl,wTextboxFlags
	set TEXTBOXFLAG_BIT_NOCOLORS,(hl)

	ld a,:w4TileMap
	ld ($ff00+R_SVBK),a

	call @runStateCode

	; Only draw the status bar on the appraisal menu, not the list menu
	ld a,(wRingMenu_mode)
	or a
	ret nz
	jp updateStatusBar

@runStateCode:
	ld a,(wMenuActiveState)
	rst_jumpTable
	.dw ringMenu_state0
	.dw ringMenu_state1
	.dw ringMenu_state2

;;
; State 0: initalization
ringMenu_state0:
	call loadCommonGraphics
	xor a
	ld (wRingMenu.tileMapIndex),a
	dec a
	ld (wRingMenu.ringNameTextIndex),a
	ld a,$80
	ld (wRingMenu.boxCursorFlickerCounter),a

	ld a,(wRingMenu_mode)
	add GFXH_UNAPPRAISED_RING_LIST
	call loadGfxHeader
	ld a,PALH_0a
	call loadPaletteHeader

	callab bank3f.realignUnappraisedRings
	call ringMenu_calculateNumPagesForUnappraisedRings
	call ringMenu_redrawRingListOrUnappraisedRings

	; Go to state 1
	ld hl,wMenuActiveState
	inc (hl)

	call fastFadeinFromWhite

	ld a,$05
	ldh (<hNextLcdInterruptBehaviour),a

	ld a,(wRingMenu_mode)
	add $0f
	jp loadGfxRegisterStateIndex

;;
; Uses an uncompressed gfx header (one of $12-$15, depending on variables) to copy the
; tilemap to vram.
ringMenu_copyTilemapToVram:
	ld hl,wRingMenu_mode
	ld a,(wRingMenu.tileMapIndex)
	and $01
	add a
	add (hl)
	add UNCMP_GFXH_12
	jp loadUncompressedGfxHeader

;;
; Clears the textbox, and decides whether to draw ring list or unappraised rings.
ringMenu_redrawRingListOrUnappraisedRings:
	xor a
	call showItemText2
	ld hl,ringMenu_copyTilemapToVram
	push hl

	ld a,(wRingMenu_mode)
	rst_jumpTable
	.dw ringMenu_drawUnappraisedRings
	.dw ringMenu_drawRingBox

;;
; Draws the ring box along with the rings in it in the ring list menu.
ringMenu_drawRingBox:
	ld a,(wMenuActiveState)
	or a
	jr nz,++

	; Draw appropriate slots for rings
	ld a,(wRingBoxLevel)
	inc a
	call mapMenu_performTileSubstitutions

	; Draw ring box icon at appropriate level
	ld de,w4TileMap+$201
	ld a,$fe
	call getRingTiles
++
	call ringMenu_drawRingBoxContents
	ld a,$04
	ld (wRingMenu.numPages),a
	ld a,$fe
	ld (wRingMenu.displayedRingNumberComparator),a
	jp ringMenu_drawRingList

;;
; State 1: "normal" state; processes input, etc.
ringMenu_state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wRingMenu_mode)
	rst_jumpTable
	.dw ringMenu_state1_unappraisedRings
	.dw ringMenu_state1_ringList

;;
ringMenu_state1_unappraisedRings:
	call ringMenu_drawSprites

	ld a,(wSubmenuState)
	rst_jumpTable
	.dw ringMenu_unappraisedRings_state0
	.dw ringMenu_unappraisedRings_state1
	.dw ringMenu_unappraisedRings_state2
	.dw ringMenu_unappraisedRings_state3
	.dw ringMenu_unappraisedRings_state4
	.dw ringMenu_unappraisedRings_state5

;;
; State 0: waiting for player to choose an unappraised ring
ringMenu_unappraisedRings_state0:
	ld a,(wTextIsActive)
	or a
	ld a,<TX_3004 ; "Which one shall I appraise?"
	call z,ringMenu_setDisplayedText

	ld a,(wKeysJustPressed)
	bit BTN_BIT_B,a
	jr nz,@bPressed
	bit BTN_BIT_A,a
	jr nz,@aPressed
	bit BTN_BIT_SELECT,a
	jp nz,ringMenu_initiateScrollRight
	jp ringMenu_checkRingListCursorMoved

@bPressed:
	; Don't allow exiting if this is the first time (they don't have a ring box yet)
	call ringMenu_checkObtainedRingBox
	ld a,<TX_3012
	jp z,ringMenu_setDisplayedText

	jp closeMenu

@aPressed:
	call ringMenu_updateSelectedRingFromList
	call ringMenu_getUnappraisedRingIndex
	rlca
	ret c

	; Selected a valid ring
	ld a,$01
	ld (wSubmenuState),a
	call ringMenu_checkObtainedRingBox
	ld a,<TX_3011 ; Doesn't mention rupees (first time appraising)
	jr z,+
	ld a,<TX_3005
+
	jp ringMenu_setDisplayedText

;;
; State 1: selected a ring; waiting for confirmation
ringMenu_unappraisedRings_state1:
	call ringMenu_retIfTextIsPrinting

	; If player chose "no", go back
	ld a,(wSelectedTextOption)
	or a
	jr nz,ringMenu_state1_restart

	; First time appraising, it's free
	call ringMenu_checkObtainedRingBox
	jr z,++

	; Check if Link has 20 rupees; subtract that amount if so
	ld a,RUPEEVAL_020
	call cpRupeeValue
	ld b,<TX_3006 ; "You don't have enough rupees"
	jp nz,ringMenu_unappraisedRings_gotoState5
	ld a,RUPEEVAL_020
	call removeRupeeValue
++
	ld hl,wNumRingsAppraised
	call incHlRefWithCap

	; Get the text to display for this ring's name
	call ringMenu_getUnappraisedRingIndex
	res 6,(hl)
	ld a,(hl)
	ld (wRingMenu.textDelayCounter2),a
	add <TX_3040
	ld (wTextSubstitutions+2),a
	ld bc,TX_301c ; "I call this the..."
	call ringMenu_showExitableText

	ld a,$02
	ld (wSubmenuState),a

	call ringMenu_drawUnappraisedRings
	jp ringMenu_copyTilemapToVram

;;
; Restart state 1 (begin prompt for ring appraisal again).
;
ringMenu_state1_restart:
	xor a
	ld (wSubmenuState),a
	ld (wTextIsActive),a
	ret

;;
; State 2: just appraised a ring; after the "ring name" textbox closes, this will print
; the ring's description and go to state 3.
ringMenu_unappraisedRings_state2:
	call ringMenu_retIfTextIsPrinting

	ld a,$03
	ld (wSubmenuState),a

	call ringMenu_getUnappraisedRingIndex
	add <TX_3080
	ld c,a
	ld b,>TX_3000
	jr ringMenu_showExitableText

;;
; State 3: after printing the ring's description, check if Link has the ring, print the
; appropriate text, then go to state 4.
ringMenu_unappraisedRings_state3:
	call ringMenu_retIfTextIsPrinting

	; Remove ring from unappraised list
	call ringMenu_getUnappraisedRingIndex
	ld c,a
	ld (hl),$ff

	ld hl,wRingsObtained
	call checkFlag
	jr nz,@refund

	; Put ring into list
	ld a,c
	call setFlag
	xor a
	ld b,<TX_3017 ; "I'll put it in your ring box"
	jr ++
@refund:
	ld a,RUPEEVAL_030
	ld b,<TX_3007 ; "You already have this"
++
	ld (wRingMenu.rupeeRefundValue),a
	call ringMenu_checkObtainedRingBox
	jp z,closeMenu

	ld a,40 ; Wait 40 frames after the next textbox closes
	ld (wRingMenu.textDelayCounter2),a

	ld a,$04
	ld (wSubmenuState),a

	ld a,b
	jp ringMenu_setDisplayedText

;;
; State 4: redraw ring list without the just-appraised ring, check whether to exit the
; ring menu or whether to keep going.
ringMenu_unappraisedRings_state4:
	call ringMenu_retIfTextIsPrinting
	call ringMenu_retIfCounterNotFinished

	; Refund if applicable
	ld a,(wRingMenu.rupeeRefundValue)
	or a
	ld c,a
	ld a,TREASURE_RUPEES
	call nz,giveTreasure

	callab bank3f.getNumUnappraisedRings
	call ringMenu_drawUnappraisedRings
	call ringMenu_copyTilemapToVram

	ld a,(wNumRingsAppraised)
	cp 100
	jr nz,@not100th

	; 100th ring
	ld a,GLOBALFLAG_APPRAISED_HUNDREDTH_RING
	call setGlobalFlag
	ld b,<TX_303c
	jr ringMenu_unappraisedRings_gotoState5

@not100th:
	; If we still have some rings left, go back to state 0
	ld a,(wNumUnappraisedRingsBcd)
	or a
	jp nz,ringMenu_state1_restart

	; Otherwise, proceed to exit the ring menu.
	ld b,<TX_3002 ; "I've appraised all your rings"

	; Fall through

;;
; @param	b	Low byte of text index to show
ringMenu_unappraisedRings_gotoState5:
	ld a,$05
	ld (wSubmenuState),a
	ld a,$3c
	ld (wRingMenu.textDelayCounter2),a
	ld a,b
	jp ringMenu_setDisplayedText

;;
; Shows an "exitable" textbox (used when vasu's speaking) unlike the "passive" textboxes
; used for ring descriptions most of the time.
;
; @param	bc	Text index
ringMenu_showExitableText:
	ld a,$02
	ld (wTextboxPosition),a
	ld a,TEXTBOXFLAG_NOCOLORS | TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a
	jp showText

;;
; State 5: exit ring menu after a delay.
ringMenu_unappraisedRings_state5:
	call ringMenu_retIfTextIsPrinting
	call ringMenu_retIfCounterNotFinished
	jp closeMenu

;;
ringMenu_checkObtainedRingBox:
	ld a,GLOBALFLAG_OBTAINED_RING_BOX
	jp checkGlobalFlag

;;
; @param[out]	a	The value of the unappraised ring that the cursor is over
; @param[out]	hl	The address of the ring in wUnappraisedRings
ringMenu_getUnappraisedRingIndex:
	ld a,(wRingMenu.selectedRing)
	ld hl,wUnappraisedRings
	rst_addAToHl
	ld a,(hl)
	ret

;;
; Returns from caller unless wRingMEnu_textDelayCounter2 has counted down to zero.
ringMenu_retIfCounterNotFinished:
	ld hl,wRingMenu.textDelayCounter2
	ld a,(hl)
	or a
	ret z
	dec (hl)
	pop af
	ret

;;
ringMenu_state1_ringList:
	call ringMenu_drawRingBoxCursor
	call ringMenu_drawEquippedRingSprite
	call ringMenu_drawSpritesForRingsInBox

	ld a,(wSubmenuState)
	rst_jumpTable
	.dw ringMenu_ringList_substate0
	.dw ringMenu_ringList_substate1

;;
; Substate 0: cursor is on the ring box (selecting a slot in the ring box)
ringMenu_ringList_substate0:
	ld a,(wRingMenu.boxCursorFlickerCounter)
	or a
	jr z,@aPressed

	ld hl,wRingMenu.textDelayCounter
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	jr @checkInput
+
	; Display text for the ring we're hovering over in the ring box
	ld a,(wRingMenu.ringBoxCursorIndex)
	ld hl,wRingBoxContents
	rst_addAToHl
	ld a,(hl)
	ld (wRingMenu.selectedRing),a
	call ringMenu_updateDisplayedRingNumberWithGivenComparator
	call ringMenu_updateRingText

@checkInput:
	ld a,(wKeysJustPressed)
	bit BTN_BIT_B,a
	jr nz,@bPressed
	bit BTN_BIT_A,a
	jp z,ringMenu_checkRingBoxCursorMoved

; Selected a ring box slot; move the cursor to the ring list (substate 1).
@aPressed:
	xor a
	ld (wRingMenu.boxCursorFlickerCounter),a
	inc a
	ld (wSubmenuState),a
	ld a,$80
	ld (wRingMenu.displayedRingNumberComparator),a
	ld a,$ff
	ld (wRingMenu.descriptionTextIndex),a
	ret

@bPressed:
	; Deactivate active ring if it was put away
	ld a,(wActiveRing)
	call ringMenu_checkRingIsInBox
	jr nc,+
	ld a,$ff
	ld (wActiveRing),a
+
	; Exit the ring menu
	xor a
	ld (wTextIsActive),a
	ld (wTextboxFlags),a
	jp closeMenu

;;
; Substate 1: cursor is on the ring list (selecting something to insert into the box)
ringMenu_ringList_substate1:
	ld a,(wKeysJustPressed)
	bit BTN_BIT_A,a
	jr nz,ringMenu_selectedRingFromList
	bit BTN_BIT_B,a
	jp nz,ringMenu_moveCursorToRingBox
	bit BTN_BIT_SELECT,a
	jp nz,ringMenu_initiateScrollRight

	call ringMenu_checkRingListCursorMoved
	call ringMenu_updateSelectedRingFromList
	call ringMenu_updateDisplayedRingNumber
	call ringMenu_drawSprites
	call ringMenu_retIfCounterNotFinished

	; Fall through

;;
; The ring list (not appraisal screen) runs this to update the textbox at the bottom.
ringMenu_updateRingText:
	; Determine what text to show for the ring name
	ld a,(wRingMenu.selectedRing)
	ld c,a
	ld hl,wRingsObtained
	call checkFlag
	jr z,+ ; If we don't have this ring, don't show its text
	ld a,c
	or $80
+
	; Check if the text to show is different from the text currently being shown
	ld hl,wRingMenu.ringNameTextIndex
	cp (hl)
	jr z,+
	call showItemText2
	ld a,$01
	ld (wRingMenu.textDelayCounter),a
	ret
+
	; Determine what text to show for the description
	ld a,(wRingMenu.selectedRing)
	ld c,a
	cp $ff
	ld a,<TX_30c0 ; Blank text
	jr z,@printDescription

	ld a,c
	ld hl,wRingsObtained
	call checkFlag
	ld a,<TX_30c0 ; Blank text
	jr z,@printDescription

	ld a,c
	add <TX_3080
@printDescription:
	; Check if the text to show is different from the text currently being shown
	ld hl,wRingMenu.descriptionTextIndex
	cp (hl)
	ret z

	; Display the textbox
	ld (hl),a
	ld c,a
	ld b,>TX_3000
	ld a,$04
	ld (wTextboxPosition),a
	ld a,TEXTBOXFLAG_NOCOLORS | TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a
	jp showTextNonExitable

;;
; Selected something from the ring list; put it into the ring box and move the cursor back
; there.
ringMenu_selectedRingFromList:
	ld a,SND_SELECTITEM
	call playSound

	; Put the ring (if it exists) in the box
	call ringMenu_updateSelectedRingFromList
	ld c,a
	ld hl,wRingsObtained
	call checkFlag
	jr nz,+
	ld c,$ff
+
	ld a,(wRingMenu.ringBoxCursorIndex)
	ld b,a
	ld a,c
	call ringMenu_checkRingIsInBox
	jr c,+
	ld (hl),$ff
	cp b
	jr z,ringMenu_moveCursorToRingBox
+
	ld a,b
	ld hl,wRingBoxContents
	rst_addAToHl
	ld (hl),c

	; Fall through

;;
; Sets the cursor to be at the ring box instead of ring list.
ringMenu_moveCursorToRingBox:
	xor a
	ld (wSubmenuState),a
	ld a,$80
	ld (wRingMenu.boxCursorFlickerCounter),a
	ld a,$ff
	ld (wTextIsActive),a
	ld (wRingMenu.ringNameTextIndex),a
	ld (wRingMenu.descriptionTextIndex),a
	call ringMenu_drawRingBoxContents
	jp ringMenu_copyTilemapToVram

;;
; @param	a	Ring to check if it's in the ring box
; @param[out]	a	The ring's index in the ring box
; @param[out]	cflag	nc if the ring's in the box
ringMenu_checkRingIsInBox:
	push bc
	ld hl,wRingBoxContents+4
	ld b,$05
@nextRing:
	cp (hl)
	jr z,@foundRing
	dec l
	dec b
	jr nz,@nextRing

	pop bc
	scf
	ret

@foundRing:
	dec b
	ld a,b
	pop bc
	ret

;;
ringMenu_initiateScrollRight:
	ld a,$01
	ld (wRingMenu.scrollDirection),a
	ld (wRingMenu.displayedRingNumberComparator),a
	xor a
	ld (wRingMenu.ringListCursorIndex),a
	ld a,(wRingMenu.page)
	inc a

;;
; @param	a	Page to scroll to
ringMenu_initiateScroll:
	ld hl,wRingMenu.numPages
	cp (hl)
	jr c,++
	ld a,$01
	cp (hl)
	ret z

	dec a
++
	ld (wRingMenu.page),a

	ld a,$02

;;
; @param	a	State to go to
ringMenu_setState:
	ld hl,wMenuActiveState
	ldi (hl),a
	xor a
	ld (hl),a ; [wSubmenuState] = 0
	ld (wTextIsActive),a

	ld a,$ff
	ld (wRingMenu.descriptionTextIndex),a
	ret

;;
; State 2: scrolling between pages
ringMenu_state2:
	ld a,(wRingMenu_mode)
	or a
	jr z,+
	call ringMenu_drawRingBoxCursor
	call ringMenu_drawEquippedRingSprite
+
	ld a,(wSubmenuState)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

; Initiating scroll
@substate0:
	ld hl,wRingMenu.tileMapIndex
	ld a,(hl)
	xor $01
	ld (hl),a

	call ringMenu_redrawRingListOrUnappraisedRings

	ld a,(wRingMenu.scrollDirection)
	bit 7,a
	ld a,$9f
	jr z,++
	ld hl,wGfxRegs2.LCDC
	ld a,(hl)
	xor $48
	ld (hl),a
	ld a,$98
	ld (wGfxRegs2.SCX),a
	ld a,$07
++
	ld (wGfxRegs2.WINX),a
	ld hl,wSubmenuState
	inc (hl)
	ld a,SND_OPENMENU
	jp playSound

; In the process of scrolling
@substate1:
	ld bc,$089f
	ld hl,wGfxRegs2.WINX
	ld de,wGfxRegs2.SCX
	ld a,(wRingMenu.scrollDirection)
	bit 7,a
	jr z,@scrollRight

@scrollLeft:
	ld a,(hl)
	add b
	cp c
	jr c,+
	ld a,c
+
	ld (hl),a
	ld a,(de)
	sub b
	ld (de),a
	cp $08
	ret nc
	jr @doneScrolling

@scrollRight:
	ld a,(hl)
	sub b
	cp $07
	jr nc,+
	ld a,$07
+
	ld (hl),a
	ld a,(de)
	add b
	ld (de),a
	cp $98
	ret c
	ld a,(wGfxRegs2.LCDC)
	xor $48
	ld (wGfxRegs2.LCDC),a

@doneScrolling:
	ld a,$c7
	ld (wGfxRegs2.WINX),a
	xor a
	ld (wGfxRegs2.SCX),a
	ld a,$01
	jp ringMenu_setState

;;
ringMenu_checkRingListCursorMoved:
	ld hl,@directionOffsets
	call getDirectionButtonOffsetFromHl
	ret nc

	ld c,a

	; Update position
	ld hl,wRingMenu.ringListCursorIndex
	ld e,a
	add (hl)
	ld b,a
	and $0f
	ld (hl),a

	; Check if we hit the edge of the screen
	bit 0,c
	jr z,@playSound
	bit 4,b
	jr z,@playSound

	; Initiate screen scrolling
	ld a,e
	ld (wRingMenu.scrollDirection),a
	ld a,(wRingMenu.page)
	add e
	cp $ff
	jr nz,++

	ld a,(wRingMenu.numPages)
	cp $01
	jr z,@playSound
	dec a
++
	call ringMenu_initiateScroll

@playSound:
	ld a,SND_MENU_MOVE
	call playSound
	scf
	ret

@directionOffsets:
	.db $01 ; Right
	.db $ff ; Left
	.db $f8 ; Up
	.db $08 ; Down

;;
; Update the cursor position in the ring box by checking if a direction button is pressed
ringMenu_checkRingBoxCursorMoved:
	call getRingBoxCapacity
	ld e,a
	ld hl,@directionOffsets
	call getDirectionButtonOffsetFromHl
	ret nc
	ret z
	ld hl,wRingMenu.ringBoxCursorIndex
	add (hl)
	cp e
	ret nc
	ld (hl),a
	ld a,SND_MENU_MOVE
	jp playSound

@directionOffsets:
	.db $01 ; Right
	.db $ff ; Left
	.db $00 ; Up
	.db $00 ; Down

;;
; Draw sprites for the cursor, and arrows indicating you can scroll between pages (if
; there's more than one page).
ringMenu_drawSprites:
	ld a,(wRingMenu.numPages)
	dec a
	ld hl,@arrowSprites
	call nz,addSpritesToOam

	ld hl,wRingMenu.listCursorFlickerCounter
	inc (hl)
	bit 3,(hl)
	ret nz
	ld bc,$3e20
	ld a,(wRingMenu.ringListCursorIndex)
	cp $08
	jr c,+
	ld b,$56
+
	and $07
	swap a
	add c
	ld c,a
	ld hl,@cursorSprite
	jp addSpritesToOam_withOffset

@cursorSprite:
	.db $01
	.db $00 $fc $0e $02

@arrowSprites:
	.db $02
	.db $3c $0c $08 $04
	.db $3c $9c $08 $24

;;
; Draws the "E" for equipped next to the equipped ring in the ring box.
ringMenu_drawEquippedRingSprite:
	ld a,(wActiveRing)
	cp $ff
	ret z
	call ringMenu_checkRingIsInBox
	ret c

	call ringMenu_getSpriteOffsetForRingBoxPosition
	ld hl,@equippedSprite
	jp addSpritesToOam_withOffset

@equippedSprite:
	.db $01
	.db $10 $00 $ec $04

;;
; @param[out]	bc	An offset to use for sprites to be drawn on a ring in the ring box
ringMenu_getSpriteOffsetForRingBoxPosition:
	ld hl,@offsets
	rst_addAToHl
	ld c,(hl)
	ld b,$00
	ret

@offsets:
	.db $38 $50 $68 $80 $98

;;
ringMenu_drawRingBoxCursor:
	ld hl,wRingMenu.boxCursorFlickerCounter
	bit 7,(hl)
	jr z,++

	; Flicker the cursor with this counter
	inc (hl)
	res 4,(hl)
	bit 3,(hl)
	ret nz
++
	ld a,(wRingMenu.ringBoxCursorIndex)
	call ringMenu_getSpriteOffsetForRingBoxPosition
	ld hl,@ringBoxCursor
	jp addSpritesToOam_withOffset

@ringBoxCursor:
	.db $01
	.db $1e $fc $0e $03

;;
; For each ring in the ring box, this draws a sprite (the letter "C") on the corresponding
; ring in the ring list.
ringMenu_drawSpritesForRingsInBox:
	ld a,$05
@loop:
	push af

	ld hl,wRingBoxContents-1
	rst_addAToHl
	ld a,(wRingMenu.page)
	swap a
	ld c,a

	ld a,(hl)
	cp $ff
	jr z,@nextRing

	; Make sure the ring is on this page
	sub c
	cp $10
	jr nc,@nextRing

	; Calculate the position to draw the "c" at
	ld b,$30
	bit 3,a
	jr z,+
	ld b,$48
+
	and $07
	swap a
	ld c,a
	ld hl,@sprite
	call addSpritesToOam_withOffset
@nextRing:
	pop af
	dec a
	jr nz,@loop
	ret

@sprite:
	.db $01
	.db $00 $20 $ef $05

;;
ringMenu_calculateNumPagesForUnappraisedRings:
	callab bank3f.getNumUnappraisedRings
	ld a,(wNumUnappraisedRingsBcd)
	or a
	ret z

	ld a,b
	dec a
	swap a
	and $0f
	inc a
	ld (wRingMenu.numPages),a
	ret

;;
ringMenu_updateSelectedRingFromList:
	ld a,(wRingMenu.page)
	swap a
	ld c,a
	ld a,(wRingMenu.ringListCursorIndex)
	add c
	ld (wRingMenu.selectedRing),a
	ret

;;
; Clear all ring icons in the selection area.
ringMenu_clearRingSelectionArea:
	ld hl,w4TileMap+$040
	ldbc $05,$14
	ldde $00,$07
	jp fillRectangleInTilemap

;;
ringMenu_drawUnappraisedRings:
	call ringMenu_clearRingSelectionArea

	ld b,$10
	ld a,(wRingMenu.page)
	swap a
	ld hl,wUnappraisedRings
	rst_addAToHl
@nextRing:
	ldi a,(hl)
	ld c,a
	call ringMenu_drawRing
	dec b
	jr nz,@nextRing

	jr ringMenu_drawPageCounter

;;
ringMenu_drawRingList:
	call ringMenu_clearRingSelectionArea

	ld b,$10
	ld a,(wRingMenu.page)
	swap a
	ld c,a
@nextRing:
	ld a,c
	ld hl,wRingsObtained
	call checkFlag
	call nz,ringMenu_drawRing
	inc c
	dec b
	jr nz,@nextRing

;;
ringMenu_drawPageCounter:
	; Draw page number
	ld hl,w4TileMap+$10f
	ld a,(wRingMenu.page)
	add $11
	ldi (hl),a

	; Draw total page number
	inc l
	ld a,(wRingMenu.numPages)
	add $10
	ld (hl),a
	ret

;;
; Draws the contents of the ring box for the ring list menu
ringMenu_drawRingBoxContents:
	ld hl,wRingBoxContents
	ld b,$11 ; b = index for ringMenu_drawRing function (cycles from $11-$15)

@nextRing:
	ldi a,(hl)
	cp $ff
	jr nz,@drawRing

	; Blank ring slot: fill with empty square
	push hl
	push bc
	ld a,b
	ld hl,ringMenu_ringPositionList-2
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldbc $02,$02
	ldde $00,$07
	call fillRectangleInTilemap
	pop bc
	pop hl
	jr ++
@drawRing:
	ld c,a
	call ringMenu_drawRing
++
	inc b
	ld a,l
	cp <wRingBoxContents+5
	jr c,@nextRing
	ret

;;
; Draws a ring's tiles at a position in the ring list.
;
; @param	b	Position index
; @param	c	Ring index
ringMenu_drawRing:
	push bc
	push hl
	ld a,b
	ld hl,ringMenu_ringPositionList-2
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld a,c
	call getRingTiles
	pop hl
	pop bc
	ret

ringMenu_ringPositionList:
	; Lower row
	.dw w4TileMap+$0b0
	.dw w4TileMap+$0ae
	.dw w4TileMap+$0ac
	.dw w4TileMap+$0aa
	.dw w4TileMap+$0a8
	.dw w4TileMap+$0a6
	.dw w4TileMap+$0a4
	.dw w4TileMap+$0a2

	; Upper row
	.dw w4TileMap+$050
	.dw w4TileMap+$04e
	.dw w4TileMap+$04c
	.dw w4TileMap+$04a
	.dw w4TileMap+$048
	.dw w4TileMap+$046
	.dw w4TileMap+$044
	.dw w4TileMap+$042

	; Ring box contents
	.dw w4TileMap+$205
	.dw w4TileMap+$208
	.dw w4TileMap+$20b
	.dw w4TileMap+$20e
	.dw w4TileMap+$211

;;
; Load the tiles for ring 'a' to address 'de'. Attributes go to de+$200.
;
; @param	a	Ring index ($ff=none, $fe=ring box)
; @param	de	Where to load ring tiles into
getRingTiles:
	cp $ff
	ret z

	; Unappraised ring?
	bit 6,a
	jr z,+

	; Ring box?
	cp $fe
	ld a,$40
	jr nz,+
	ld a,(wRingBoxLevel)
	add $40
	jr +
+
	call multiplyABy8
	ld hl,map_rings
	add hl,bc
	push de
	call copy8BytesFromRingMapToCec0
	pop hl
	ld de,wTmpcec0
	call @drawTile
	inc l
	call @drawTile
	ld a,$1f
	rst_addAToHl
	call @drawTile
	inc l
@drawTile:
	ld a,(de)
	ld (hl),a
	inc e
	set 2,h
	ld a,(de)
	ld (hl),a
	inc e
	res 2,h
	ret

;;
; Updates the "ring number" displayed below the ring list.
ringMenu_updateDisplayedRingNumber:
	ld a,(wRingMenu.ringListCursorIndex)

	; Fall through

;;
; @param	a	Value to compare against "wRingMenu.displayedRingNumberComparator"
;			for changes
ringMenu_updateDisplayedRingNumberWithGivenComparator:
	ld hl,wRingMenu.displayedRingNumberComparator
	cp (hl)
	ret z

	ld (hl),a

	; If no ring is selected, print two dashes
	ld a,(wRingMenu.selectedRing)
	inc a
	jr z,@noRing

	; Calculate the ring's number in bcd
	call hexToDec
	set 4,a
	set 4,c
	jr @drawNumber

@noRing:
	; Display two dashes
	ld a,$e8
	ld c,a
@drawNumber:
	ld hl,w4TileMap+$105
	ldd (hl),a
	ld (hl),c
	jp ringMenu_copyTilemapToVram

;;
; @param	a	Text index to show ($30XX)
ringMenu_setDisplayedText:
	ld hl,wRingMenu.descriptionTextIndex
	cp (hl)
	ret z

	ld (hl),a
	ld c,a
	ld b,>TX_3000
	ld a,$02
	ld (wTextboxPosition),a
	ld a,TEXTBOXFLAG_NOCOLORS | TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a
	jp showTextNonExitable

;;
; Returns from caller if text is still in the process of printing.
ringMenu_retIfTextIsPrinting:
	ld a,(wTextIsActive)
	and $7f
	ret z
	pop af
	ret


;;
; @param[out]	zflag	nz if we got here from a game over.
saveQuitMenu_checkIsGameOver:
	ld a,(wSaveQuitMenu.gameOver)
	or a
	ret

;;
runSaveAndQuitMenu:
	ld a,$00
	ld ($ff00+R_SVBK),a
	call @runState
	jp saveQuitMenu_drawSprites

@runState:
	ld a,(wSaveQuitMenu.state)
	rst_jumpTable
	.dw saveQuitMenu_state0
	.dw saveQuitMenu_state1
	.dw saveQuitMenu_state2

;;
; State 0: initialization (loading graphics, setting music, etc)
saveQuitMenu_state0:
	call disableLcd
	call stopTextThread

	ld a,GFXH_FILE_MENU_GFX
	call loadGfxHeader
	ld a,GFXH_SAVE_MENU_LAYOUT
	call loadGfxHeader
	ld a,GFXH_SAVE_MENU_GFX
	call loadGfxHeader

	call saveQuitMenu_checkIsGameOver
	jr z,@notGameOver

@gameOver:
	call restartSound
	ld a,THREAD_1
	call threadStop

	ld hl,wDeathCounter
	ld bc,$0001
	call addDecimalToHlRef
	cp $0a
	jr c,+
	ld (hl),$99 ; Death counter can't exceed 999
	inc l
	ld (hl),$09
+
	ld a,GFXH_GAME_OVER_GFX
	call loadGfxHeader

	ld a,MUS_GAMEOVER
	call playSound

	ld a,PALH_06
	jr ++

@notGameOver:
	xor a
	call setMusicVolume
	ld a,PALH_05
++
	call loadPaletteHeader
	ld a,UNCMP_GFXH_08
	call loadUncompressedGfxHeader

	call fastFadeinFromWhite

	ld a,$01
	ld (wSaveQuitMenu.state),a

	ld a,$05
	jp loadGfxRegisterStateIndex

;;
; State 1: processing input
saveQuitMenu_state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wKeysJustPressed)
	ld c,$ff
	bit BTN_BIT_UP,a
	jr nz,@upOrDown
	ld c,$01
	bit BTN_BIT_DOWN,a
	jr nz,@upOrDown

	bit BTN_BIT_B,a
	jr nz,@bPressed

	and (BTN_START|BTN_A)
	ret z

	; A pressed
	ld a,(wSaveQuitMenu.cursorIndex)
	or a
	call nz,saveFile ; Save for options 2 and 3

	ld a,$02
	ld (wSaveQuitMenu.state),a
	ld a,$1e
	ld (wSaveQuitMenu.delayCounter),a

	ld a,SND_SELECTITEM
	jp playSound

@upOrDown:
	ld hl,wSaveQuitMenu.cursorIndex
	ld a,(hl)
	add c
	cp $03
	ret nc
	ld (hl),a
	ld a,SND_MENU_MOVE
	jp playSound

@bPressed:
	call saveQuitMenu_checkIsGameOver
	ret nz
	jp closeMenu

;;
; State 2: selected an option; after a delay, decide whether to reset, etc.
saveQuitMenu_state2:
	ld hl,wSaveQuitMenu.delayCounter
	dec (hl)
	ret nz

	ld a,(wSaveQuitMenu.cursorIndex)
	cp $02
	jp z,resetGame

	call saveQuitMenu_checkIsGameOver
	jp z,closeMenu

	; Reset game
	ld a,THREAD_1
	ld bc,mainThreadStart
	call threadRestart
	jp stubThreadStart

;;
saveQuitMenu_drawSprites:
	call fileSelect_redrawDecorationsAndSetWramBank4

	; Flicker acorn if applicable
	ld a,(wSaveQuitMenu.delayCounter)
	and $04
	ret nz

	ld c,a ; c = 0
	ld a,(wSaveQuitMenu.cursorIndex)
	ld b,a
	add a
	add b
	swap a
	rrca
	ld b,a
	ld hl,@acornSprite
	jp addSpritesToOam_withOffset

@acornSprite:
	.db $01
	.db $48 $29 $28 $04


;;
; Run the secret list menu from farore's book.
runSecretListMenu:
	call clearOam
	ld a,TEXT_BANK
	ld ($ff00+R_SVBK),a
	call @runState
	jp secretListMenu_drawCursorSprite

@runState:
	ld a,(wSecretListMenu.state)
	rst_jumpTable
	.dw secretListMenu_state0
	.dw secretListMenu_state1
	.dw secretListMenu_state2

;;
; State 0: initialization
secretListMenu_state0:
	call disableLcd
	call stopTextThread

	ld a,$01
	ld (wSecretListMenu.state),a
	call @clearVramBank
	xor a
	call @clearVramBank

	ld a,GFXH_SECRET_LIST_MENU
	call loadGfxHeader
	ld a,PALH_SECRET_LIST_MENU
	call loadPaletteHeader
	call secretListMenu_loadAllSecretNames
	ld a,$ff
	call secretListMenu_printSecret
	call fastFadeinFromWhite
	ld a,$16
	jp loadGfxRegisterStateIndex

;;
; @param	a	Vram bank to fill with $ff
@clearVramBank:
	ld ($ff00+R_VBK),a
	ld hl,$8000
	ld bc,$1000
	ld a,$ff
	jp fillMemoryBc

;;
; State 1: processing input
secretListMenu_state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wKeysJustPressed)
	and (BTN_START|BTN_SELECT|BTN_B)
	jp nz,closeMenu

	call getInputWithAutofire
	ld c,a
	ld hl,wSecretListMenu.numEntries
	ldi a,(hl)
	ld b,a
	ld a,$ff

	bit BTN_BIT_UP,c
	jr nz,@upOrDown
	bit BTN_BIT_DOWN,c
	jr z,@end
	ld a,$01
@upOrDown:
	; Try to move cursor, stop if we're at the maximum
	add (hl) ; hl = wSecretListMenu.cursorIndex
	cp b
	jr nc,@end

	ldi (hl),a
	sub (hl) ; hl = wSecretListMenu.scroll
	cp $01
	jr c,@scrollUp
	cp $03
	jr c,@playSound

@scrollDown:
	ldi a,(hl) ; hl = wSecretListMenu.scroll
	sub b
	cp $fc
	jr nc,@playSound
	ld a,$02
	jr ++

@scrollUp:
	ldi a,(hl)
	or a
	jr z,@playSound
	ld a,$fe
++
	ld (wSecretListMenu.scrollSpeed),a
	ld l,<wSecretListMenu.state
	inc (hl) ; Go to state 2 (scrolling)

@playSound:
	ld a,SND_MENU_MOVE
	call playSound

@end:
	ld a,(wSaveQuitMenu.delayCounter)
	jr secretListMenu_printSecret

;;
; State 2: scrolling
secretListMenu_state2:
	ld hl,wSecretListMenu.scrollSpeed
	ld a,(wGfxRegs2.SCY)
	add (hl)
	ld (wGfxRegs2.SCY),a
	and $0f
	ret nz

	; Done scrolling
	ld a,(hl)
	sra a
	ld l,<wSecretListMenu.scroll
	add (hl)
	ld (hl),a
	ld l,<wSecretListMenu.state
	dec (hl) ; Go to state 1
	ret

;;
secretListMenu_drawCursorSprite:
	ld a,(wGfxRegs2.SCY)
	ld b,a
	ld a,(wSecretListMenu.cursorIndex)
	swap a
	sub b
	ld b,a
	ld c,$00
	ld hl,@cursor
	jp addSpritesToOam_withOffset

@cursor;
	.db $01
	.db $5a $14 $0c $24

;;
; @param	a	Index of secret to print (or $ff for nothing)
secretListMenu_printSecret:
	ld hl,wTmpcbb9
	cp (hl)
	ret z

	ld (hl),a
	push af

	ld hl,w7d800
	ld bc,$0300
	call clearMemoryBc

	ld hl,w7SecretText1
	ld b,$c*2
	call clearMemory

	pop af
	cp $ff
	jr z,@end

	call secretListMenu_getSecretData
	ldi a,(hl)
	rlca
	rlca
	and $03
	ld b,a
	ldi a,(hl)
	ld c,(hl)
	call checkGlobalFlag
	ld a,$ff
	ld (wFileSelect.fontXor),a
	jr z,secretListMenu_printSecret

	call @getSecretText
	ld hl,w7SecretText1
	ld de,w7d800
	ld b,$c*2
	call copyTextCharactersFromHl
@end:
	ld a,UNCMP_GFXH_35
	jp loadUncompressedGfxHeader

@getSecretText:
	ld a,b
	rst_jumpTable
	.dw @val0
	.dw @val1
	.dw @val2
	.dw @val3

@val0: ; game-transfer secret
@val1:
	jpab bank3.generateGameTransferSecret

@val2: ; ring secret
	ldbc $00,$02
	jp secretFunctionCaller

@val3: ; 5-letter secret
	ld a,c
	ld (wShortSecretIndex),a
	ld c,b
	ld b,$00
	jp secretFunctionCaller

;;
; Loads gfx for all secret names directly to vram starting at $8a00.
secretListMenu_loadAllSecretNames:
	xor a
	ld ($ff00+R_VBK),a

	ld de,$8a00
	ld b,$00
@nextSecret:
	ld a,b
	call secretListMenu_getSecretData
	ldi a,(hl)
	or a
	jr z,@end

	push bc
	ld c,a
	ldi a,(hl)
	call checkGlobalFlag
	ld a,$01 ; If we don't have this secret, show a dashed line
	jr z,++

	ld a,c
	and $3f
	call copyTextCharactersFromSecretTextTable
	ld a,$02 ; Put " Secret" after every string
++
	call copyTextCharactersFromSecretTextTable
	pop bc

	; Adjust de to point to next row
	dec de
	ld e,$00
	ld a,d
	and $fe
	add $02

	; If we've reached address 0:9000, loop around to 1:8000.
	cp $90
	jr c,++
	ld a,$01
	ld ($ff00+R_VBK),a
	ld a,$80
++
	ld d,a
	inc b
	jr @nextSecret

@end:
	ld a,b
	ld (wSecretListMenu.numEntries),a
	ret

;;
; @param	a	Index
secretListMenu_getSecretData:
	ld hl,wFileIsLinkedGame
	bit 0,(hl)
	ld hl,@unlinked
	jr z,+
	ld hl,@linked
+
	push bc

	ld c,a ; a *= 3
	add a
	add c

	rst_addAToHl
	pop bc
	ret


; The following data is the list of secrets to be displayed on farore's secret list.
;   b0: bits 0-5: Index for name from secretTextTable
;       bits 6-7: secret "mode" (0/1=game-transfer, 2=ring secret, 3=other)
;   b1: global flag which, if set, means the secret is unlocked
;   b2: Index of secret data?

.ifdef ROM_AGES
	@unlinked:
		.db $03, GLOBALFLAG_FINISHEDGAME,		$00
		.db $85, GLOBALFLAG_RING_SECRET_GENERATED,	$02
		.db $d0, GLOBALFLAG_DONE_KING_ZORA_SECRET,	$10
		.db $d4, GLOBALFLAG_DONE_LIBRARY_SECRET,	$14
		.db $d5, GLOBALFLAG_DONE_TROY_SECRET,		$12
		.db $d7, GLOBALFLAG_DONE_TINGLE_SECRET,		$17
		.db $d9, GLOBALFLAG_DONE_SYMMETRY_SECRET,	$19
		.db $d1, GLOBALFLAG_DONE_FAIRY_SECRET,		$11
		.db $d8, GLOBALFLAG_DONE_ELDER_SECRET,		$18
		.db $d2, GLOBALFLAG_DONE_TOKAY_SECRET,		$15
		; Don't display plen secret or mamamu secret, since rings can be exchanged
		; through vasu instead.
		.db $00

	@linked:
		.db $85, GLOBALFLAG_RING_SECRET_GENERATED,	$02
		.db $c6, GLOBALFLAG_BEGAN_CLOCK_SHOP_SECRET, 	$20
		.db $ca, GLOBALFLAG_BEGAN_SMITH_SECRET, 	$24
		.db $cb, GLOBALFLAG_BEGAN_PIRATE_SECRET, 	$25
		.db $cd, GLOBALFLAG_BEGAN_DEKU_SECRET, 		$27
		.db $cf, GLOBALFLAG_BEGAN_RUUL_SECRET,	 	$29
		.db $c7, GLOBALFLAG_BEGAN_GRAVEYARD_SECRET, 	$21
		.db $ce, GLOBALFLAG_BEGAN_BIGGORON_SECRET, 	$28
		.db $c8, GLOBALFLAG_BEGAN_SUBROSIAN_SECRET, 	$22
		.db $c9, GLOBALFLAG_BEGAN_DIVER_SECRET, 	$23
		.db $cc, GLOBALFLAG_BEGAN_TEMPLE_SECRET, 	$26
		.db $00

.else; ROM_SEASONS

	@unlinked:
		.db $04, GLOBALFLAG_FINISHEDGAME,		$00
		.db $85, GLOBALFLAG_RING_SECRET_GENERATED,	$02
		.db $c6, GLOBALFLAG_DONE_CLOCK_SHOP_SECRET,	$30
		.db $ca, GLOBALFLAG_DONE_SMITH_SECRET,		$34
		.db $cb, GLOBALFLAG_DONE_PIRATE_SECRET,		$35
		.db $cd, GLOBALFLAG_DONE_DEKU_SECRET,		$37
		.db $cf, GLOBALFLAG_DONE_RUUL_SECRET,		$39
		.db $c7, GLOBALFLAG_DONE_GRAVEYARD_SECRET,	$31
		.db $ce, GLOBALFLAG_DONE_BIGGORON_SECRET,	$38
		.db $c8, GLOBALFLAG_DONE_SUBROSIAN_SECRET,	$32
		.db $00

	@linked:
		.db $85, GLOBALFLAG_RING_SECRET_GENERATED,	$02
		.db $d0, GLOBALFLAG_BEGAN_KING_ZORA_SECRET,	$00
		.db $d4, GLOBALFLAG_BEGAN_LIBRARY_SECRET,	$04
		.db $d5, GLOBALFLAG_BEGAN_TROY_SECRET,		$02
		.db $d7, GLOBALFLAG_BEGAN_TINGLE_SECRET,	$07
		.db $d9, GLOBALFLAG_BEGAN_SYMMETRY_SECRET,	$09
		.db $d1, GLOBALFLAG_BEGAN_FAIRY_SECRET,		$01
		.db $d8, GLOBALFLAG_BEGAN_ELDER_SECRET,		$08
		.db $d2, GLOBALFLAG_BEGAN_TOKAY_SECRET,		$05
		.db $d3, GLOBALFLAG_BEGAN_PLEN_SECRET,		$03
		.db $d6, GLOBALFLAG_BEGAN_MAMAMU_SECRET,	$06
		.db $00

.endif; ROM_SEASONS

;;
; Runs the fake reset that happens when getting the sign ring in Seasons.
runFakeReset:
	ld a,(wFakeResetMenu.state)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call disableLcd
	call clearOam
	call clearVram
	call initializeVramMaps

	ld a,SNDCTRL_DISABLE
	call playSound

	ld a,GFXH_NINTENDO_CAPCOM_SCREEN
	call loadGfxHeader
	ld a,PALH_01
	call loadPaletteHeader

	ld a,120 ; Wait 2 seconds before fading the nintendo/capcom logo away
	ld (wFakeResetMenu.delayCounter),a

	ld hl,wFakeResetMenu.state
	inc (hl)

	call fadeinFromWhite
	xor a
	jp loadGfxRegisterStateIndex

@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,wFakeResetMenu.delayCounter
	dec (hl)
	ret nz

	ld a,SNDCTRL_ENABLE
	call playSound
	ld hl,wMenuLoadState
	inc (hl)
	jp fadeoutToWhite

.ENDS
