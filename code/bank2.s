.BANK $02 SLOT 1
.ORG 0

 m_section_force "Bank_2" NAMESPACE "bank2"

;;
; This function checks if the game is run on a dmg (instead of a gbc) and, if so, displays
; the "only for gbc" screen.
;
; @addr{4000}
checkDisplayDmgModeScreen:
	ldh a,(<hGameboyType)	; $4000
	or a			; $4002
	ret nz			; $4003

	call disableLcd		; $4004

	lda GFXH_00			; $4007
	call loadGfxHeader		; $4008

	xor a			; $400b
	call loadGfxRegisterStateIndex		; $400c

	ld hl,wGfxRegs1		; $400f
	ld de,wGfxRegsFinal		; $4012
	ld b,GfxRegsStruct.size
	call copyMemory		; $4017

@vblankLoop:
	ld a,$ff		; $401a
	ld (wVBlankChecker),a		; $401c
	halt			; $401f
	nop			; $4020
	ld a,(wVBlankChecker)		; $4021
	bit 7,a			; $4024
	jr nz,@vblankLoop	; $4026

	ldh a,(<hSerialInterruptBehaviour)	; $4028
	or a			; $402a
	jr z,++			; $402b

	call serialFunc_0c8d		; $402d
	jr @vblankLoop		; $4030
++
	call serialFunc_0c85		; $4032
	ld a,$03		; $4035
	ldh (<hFFBE),a	; $4037
	xor a			; $4039
	ldh (<hFFBF),a	; $403a
	jr @vblankLoop		; $403c

;;
; Indoor rooms don't appear to rely on the area flags to tell if they're in the past; they
; have another room-based table to determine that.
;
; For ages, this marks rooms as being in the past; for seasons, it marks rooms as being in
; subrosia.
;
; Updates wAreaFlags accordingly with AREAFLAG_PAST (bit 7).
;
; @addr{403e}
updateAreaFlagsForIndoorRoomInAltWorld:
	ld a,(wActiveGroup)		; $403e
	or a			; $4041
	ret z			; $4042

	ld hl,roomsInAltWorldTable	; $4043
	rst_addDoubleIndex			; $4046
	ldi a,(hl)		; $4047
	ld h,(hl)		; $4048
	ld l,a			; $4049
	ld a,(wActiveRoom)		; $404a
	call checkFlag		; $404d
	ret z			; $4050

	ld hl,wAreaFlags		; $4051
.ifdef ROM_AGES
	set AREAFLAG_BIT_PAST,(hl)		; $4054
.else
	set AREAFLAG_BIT_SUBROSIA,(hl)
.endif
	ret			; $4056


.include "build/data/roomsInAltWorld.s"


;;
; @param	a	Index for table
; @param	b	Number of characters to copy
; @param	de	Destination
; @addr{4107}
_copyTextCharactersFromSecretTextTable:
	ld hl,_secretTextTable		; $4107
	rst_addDoubleIndex			; $410a
	ldi a,(hl)		; $410b
	ld h,(hl)		; $410c
	ld l,a			; $410d

;;
; @addr{410e}
_copyTextCharactersFromHlUntilNull:
	set 7,b			; $410e

;;
; @param	b			Number of characters to copy, or copy until $00 if
;					bit 7 is set
; @param	de			Destination
; @param	hl			Pointer to characters indices to load
; @param	wFileSelect.fontXor	Value to xor every other byte with
; @addr{4110}
_copyTextCharactersFromHl:
	ldi a,(hl)		; $4110
	bit 7,b			; $4111
	jr z,+

	or a			; $4115
	ret z			; $4116

	cp $01			; $4117
	jr z,_copyTextCharactersFromHl
+
	ld c,$00		; $411b
	cp $06			; $411d
	jr nz,+

	inc c			; $4121
	ldi a,(hl)		; $4122
+
	call copyTextCharacterGfx		; $4123
	bit 7,b			; $4126
	jr nz,_copyTextCharactersFromHl
	dec b			; $412a
	jr nz,_copyTextCharactersFromHl
	ret			; $412d

;;
; @addr{412e}
b2_fileSelectScreen:
	ld hl,wTmpcbb6		; $412e
	inc (hl)		; $4131
	call fileSelect_redrawDecorationsAndSetWramBank4		; $4132
	ld a,(wFileSelect.mode)		; $4135
	rst_jumpTable			; $4138
	.dw _fileSelectMode0 ; Initialization
	.dw _fileSelectMode1 ; Main file select
	.dw _fileSelectMode2 ; Entering name
	.dw _fileSelectMode3 ; Copy
	.dw _fileSelectMode4 ; Erase
	.dw _fileSelectMode5 ; Selecting between new game, secret, link
	.dw _fileSelectMode6 ; Entering a secret
	.dw _fileSelectMode7 ; Game link

;;
; @addr{4149}
_func_02_4149:
	ld hl,wFileSelect.cursorPos		; $4149
	ldi (hl),a		; $414c

	; [wFileSelect.cursorPos2]         = $80
	; [wFileSelect.textInputCursorPos] = $80
	ld a,$80		; $414d
	ldi (hl),a		; $414f
	ldd (hl),a		; $4150
	ret			; $4151

;;
; @addr{4152}
_setFileSelectCursorOffsetToFileSelectMode:
	ld a,(wFileSelect.mode)		; $4152
	ld (wFileSelect.cursorOffset),a		; $4155
	ret			; $4158

;;
; @addr{4159}
_setFileSelectModeTo1:
	ld a,$01		; $4159
;;
; @addr{415b}
_setFileSelectMode:
	ld hl,wFileSelect.mode		; $415b
	ldi (hl),a		; $415e
	xor a			; $415f
	ld (hl),a ; [wFileSelect.mode2] = $00
	ld (wFileSelect.textInputMode),a		; $4161
	ret			; $4164

;;
; @addr{4165}
_loadGfxRegisterState5AndIncFileSelectMode2:
	ld a,$05		; $4165
	call loadGfxRegisterStateIndex		; $4167
;;
; @addr{416a}
_incFileSelectMode2:
	ld hl,wFileSelect.mode2		; $416a
	inc (hl)		; $416d
	ret			; $416e

;;
; @addr{416f}
_decFileSelectMode2IfBPressed:
	ld a,(wKeysJustPressed)		; $416f
	and BTN_B			; $4172
	ret z			; $4174
;;
; @addr{4175}
_decFileSelectMode2:
	ld hl,wFileSelect.mode2		; $4175
	dec (hl)		; $4178
	ret			; $4179

;;
; Gets the address for the given file's DisplayVariables.
; @param a File index
; @param d Value to add to address
; @addr{417a}
_getFileDisplayVariableAddress:
	ld e,a			; $417a
_getFileDisplayVariableAddress_paramE:
	ld a,e			; $417b
	swap a			; $417c
	rrca			; $417e
	add d			; $417f
	ld hl,w4FileDisplayVariables	; $4180
	rst_addAToHl			; $4183
	ret			; $4184

;;
; Initialization of file select screen
; @addr{4185}
_fileSelectMode0:
	ld hl,wFileSelect.mode		; $4185
	ld b,$10		; $4188
	call clearMemory		; $418a
	call disableLcd		; $418d
	ld a,GFXH_a0		; $4190
	call loadGfxHeader		; $4192
	ld a,MUS_FILE_SELECT		; $4195
	call playSound		; $4197
	xor a			; $419a
	ld (wLastSecretInputLength),a		; $419b
	call _setFileSelectModeTo1		; $419e
;;
; Main mode, selecting a file
; @addr{41a1}
_fileSelectMode1:
	call @mode1SubModes		; $41a1
	call _fileSelectDrawAcornCursor		; $41a4
	jp _fileSelectDrawLink		; $41a7

;;
; @addr{41aa}
@mode1SubModes:
	ld a,(wFileSelect.mode2)		; $41aa
	rst_jumpTable			; $41ad
.dw @state0
.dw @state1
.dw @state2
.dw @state3

;;
; Initialization
; @addr{41b6}
@state0:
	call _setFileSelectCursorOffsetToFileSelectMode		; $41b6
	xor a			; $41b9
	call _func_02_4149		; $41ba
	call disableLcd		; $41bd
	ld a,GFXH_ba		; $41c0
	call loadGfxHeader		; $41c2
	ld a,PALH_05		; $41c5
	call loadPaletteHeader		; $41c7
	call _loadFileDisplayVariables		; $41ca
	call _textInput_updateEntryCursor		; $41cd
	call _fileSelectDrawHeartsAndDeathCounter		; $41d0
	jp _loadGfxRegisterState5AndIncFileSelectMode2		; $41d3

;;
; Normal mode
; @addr{41d6}
@state1:
	call _fileSelectUpdateInput		; $41d6
	jr nz,++		; $41d9

	ld hl,wFileSelect.cursorPos		; $41db
	ldi a,(hl)		; $41de
	set 7,(hl)		; $41df
	cp $03			; $41e1
	ret nz			; $41e3
	call func_02_448d		; $41e4
	ret z			; $41e7
++
	ld a,SND_SELECTITEM		; $41e8
	call playSound		; $41ea
	call @getNextFileSelectMode		; $41ed
	jp nz,_setFileSelectMode		; $41f0

	; Selected a non-empty file
	call _incFileSelectMode2		; $41f3
	call loadFile		; $41f6
	ld a,UNCMP_GFXH_16		; $41f9
	jp loadUncompressedGfxHeader		; $41fb

;;
; Called after selecting something.
; Returns zero-flag unset with a value in A as the next file selection mode, or
; zero-flag set for no mode change.
; @addr{41fe}
@getNextFileSelectMode:
	ld a,(wFileSelect.cursorPos)		; $41fe
	cp $03			; $4201
	jr z,++			; $4203

	ldh (<hActiveFileSlot),a	; $4205
	ld d,$00		; $4207
	call _getFileDisplayVariableAddress		; $4209
	bit 7,(hl)		; $420c
	ld a,$05		; $420e
	ret nz			; $4210
	xor a			; $4211
	ret			; $4212
++
	ld a,(wFileSelect.cursorPos2)		; $4213
	add $03			; $4216
	ret			; $4218

;;
; Selecting text speed
; @addr{4219}
@state2:
	call @textSpeedMenu_checkInput		; $4219
	jr @textSpeedMenu_addCursorToOam		; $421c

;;
; @addr{421e}
@textSpeedMenu_checkInput:
	ld a,(wKeysJustPressed)		; $421e
	ld b,a			; $4221
	and BTN_B | BTN_SELECT			; $4222
	jr nz,@back		; $4224

	ld c,$01		; $4226
	bit BTN_BIT_RIGHT,b			; $4228
	jr nz,@leftOrRight	; $422a

	ld c,$ff		; $422c
	bit BTN_BIT_LEFT,b			; $422e
	jr nz,@leftOrRight	; $4230

	ld a,b			; $4232
	and BTN_A | BTN_START			; $4233
	ret z			; $4235

	ld a,SND_SELECTITEM		; $4236
	call playSound		; $4238
	call _incFileSelectMode2		; $423b
	call saveFile		; $423e
	jp fadeoutToWhite		; $4241

@back:
	ld a,UNCMP_GFXH_08		; $4244
	call loadUncompressedGfxHeader		; $4246
	jp _decFileSelectMode2		; $4249

@leftOrRight:
	ld hl,wTextSpeed		; $424c
	ld a,(hl)		; $424f
	add c			; $4250
	cp $05			; $4251
	ret nc			; $4253
	ld (hl),a		; $4254
	ld a,SND_MENU_MOVE		; $4255
	jp playSound		; $4257

;;
; @addr{425a}
@textSpeedMenu_addCursorToOam:
	ld a,(wTextSpeed)		; $425a
	swap a			; $425d
	ld c,a			; $425f
	ld b,$00		; $4260
	ld hl,@data		; $4262
	jp addSpritesToOam_withOffset		; $4265

; OAM data for cursor?
@data:
	.db $01
	.db $90 $31 $2e $01

;;
; Screen fading out
; @addr{426d}
@state3:
	ld a,(wPaletteThread_mode)		; $426d
	or a			; $4270
	jr nz,@textSpeedMenu_addCursorToOam	; $4271

	; Fade done
	xor a			; $4273
	ld (wLastSecretInputLength),a		; $4274
	ld bc,mainThreadStart		; $4277
	jp restartThisThread		; $427a

;;
; Choose between new game, secret, game link
; @addr{427d}
_fileSelectMode5:
	call @mode5States		; $427d
	jp _fileSelectDrawAcornCursor		; $4280

;;
; @addr{4283}
@mode5States:
	ld a,(wFileSelect.mode2)		; $4283
	rst_jumpTable			; $4286
.dw @state0
.dw @state1

;;
; @addr{428b}
@state0:
	call disableLcd		; $428b
	ld a,GFXH_a7		; $428e
	call loadGfxHeader		; $4290
	ld a,GFXH_a6		; $4293
	call loadGfxHeader		; $4295
	ld a,UNCMP_GFXH_08		; $4298
	call loadUncompressedGfxHeader		; $429a
	call _setFileSelectCursorOffsetToFileSelectMode		; $429d
	xor a			; $42a0
	call _func_02_4149		; $42a1
	jp _loadGfxRegisterState5AndIncFileSelectMode2		; $42a4

;;
; @addr{42a7}
@state1:
	ld a,(wKeysJustPressed)		; $42a7
	ld c,$01		; $42aa
	bit BTN_BIT_DOWN,a			; $42ac
	jr nz,@upOrDown		; $42ae

	ld c,$ff		; $42b0
	bit BTN_BIT_UP,a			; $42b2
	jr nz,@upOrDown		; $42b4

	ld c,a			; $42b6
	and BTN_B | BTN_SELECT		; $42b7
	jp nz,_setFileSelectModeTo1		; $42b9

	ld a,c			; $42bc
	and BTN_A | BTN_START		; $42bd
	ret z			; $42bf

	ld a,(wFileSelect.cursorPos)		; $42c0
	ld hl,@selectionModes		; $42c3
	rst_addAToHl			; $42c6
	ld a,(hl)		; $42c7
	call _setFileSelectMode		; $42c8
	ld a,SND_SELECTITEM		; $42cb
	jp playSound		; $42cd

@selectionModes:
	.db $02 ; Name entry
	.db $06 ; Secret entry
	.db $07 ; Game link

@upOrDown:
	ld hl,wFileSelect.cursorPos		; $42d3
	ld a,(hl)		; $42d6
-
	add c			; $42d7
	and $03			; $42d8
	cp $03			; $42da
	jr nc,-			; $42dc

	ld (hl),a		; $42de
	ld a,SND_MENU_MOVE		; $42df
	jp playSound		; $42e1

;;
; Copying file
; @addr{42e4}
_fileSelectMode3:
	call @mode3Update	; $42e4
	jp _fileSelectDrawAcornCursor		; $42e7

;;
; @addr{42ea}
@mode3Update:
	ld a,(wFileSelect.mode2)		; $42ea
	rst_jumpTable			; $42ed
.dw @mode0
.dw @mode1
.dw @mode2
.dw @mode3

;;
; @addr{42f6}
@mode0:
	call _setFileSelectCursorOffsetToFileSelectMode		; $42f6
	ld a,$03		; $42f9
	call _func_02_4149		; $42fb
	call disableLcd		; $42fe
	ld a,GFXH_a3		; $4301
	call loadGfxHeader		; $4303
	call _loadFileDisplayVariables		; $4306
	call _textInput_updateEntryCursor		; $4309
	ld a,UNCMP_GFXH_08		; $430c
	call loadUncompressedGfxHeader		; $430e
	jp _loadGfxRegisterState5AndIncFileSelectMode2		; $4311

;;
; @addr{4314}
@mode1:
	call _fileSelectUpdateInput		; $4314
	ret z			; $4317
	ld a,SND_SELECTITEM		; $4318
	call playSound		; $431a
	ld a,(wFileSelect.cursorPos)		; $431d
	cp $03			; $4320
	jp z,_setFileSelectModeTo1		; $4322

	ldh (<hActiveFileSlot),a	; $4325
	ld d,$00		; $4327
	call _getFileDisplayVariableAddress		; $4329
	bit 7,(hl)		; $432c
	jr z,+			; $432e

	ld a,SND_ERROR		; $4330
	jp playSound		; $4332
+
	xor a			; $4335
	ld (wFileSelect.cursorOffset),a		; $4336
	call _func_02_4149		; $4339
	call _incFileSelectMode2		; $433c
	ld b,$01		; $433f
---
	ld a,b			; $4341
	or a			; $4342
	ret z			; $4343
--
	ld hl,wFileSelect.cursorPos		; $4344
	ldh a,(<hActiveFileSlot)	; $4347
	cp (hl)			; $4349
	ret nz			; $434a
	ld a,(hl)		; $434b
	add b			; $434c
	and $03			; $434d
	ld (hl),a		; $434f
	jr --			; $4350

;;
; @addr{4352}
@mode2:
	call @func_02_4397		; $4352
	call _decFileSelectMode2IfBPressed		; $4355
	jr nz,@label_02_015	; $4358

	call _fileSelectUpdateInput		; $435a
	jr z,---		; $435d

	ld a,SND_SELECTITEM		; $435f
	call playSound		; $4361
	ld a,(wFileSelect.cursorPos)		; $4364
	cp $03			; $4367
	jp nz,_incFileSelectMode2		; $4369
	call _decFileSelectMode2		; $436c
	jr @label_02_015		; $436f

;;
; @addr{4371}
@mode3:
	call @func_02_4397		; $4371
	call _decFileSelectMode2IfBPressed		; $4374
	jr nz,@label_02_015	; $4377
	call func_02_448d		; $4379
	ret z			; $437c

	ld a,SND_SELECTITEM		; $437d
	call playSound		; $437f
	ld a,(wFileSelect.cursorPos2)		; $4382
	or a			; $4385
	jp z,_setFileSelectModeTo1		; $4386

	call loadFile		; $4389
	ld a,(wFileSelect.cursorPos)		; $438c
	ldh (<hActiveFileSlot),a	; $438f
	call saveFile		; $4391
	jp _setFileSelectModeTo1		; $4394

;;
; @addr{4397}
@func_02_4397:
	ldh a,(<hActiveFileSlot)	; $4397
	ld hl,@data		; $4399
	rst_addAToHl			; $439c
	ld b,(hl)		; $439d
	ld c,$00		; $439e
	ld hl,@spriteData		; $43a0
	jp addSpritesToOam_withOffset		; $43a3

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
	ld a,SND_CLINK		; $43c2
	call playSound		; $43c4
	ld a,(wFileSelect.mode2)		; $43c7
	cp $01			; $43ca
	ld a,(wFileSelect.cursorPos)		; $43cc
	jr nz,+			; $43cf

	call _setFileSelectCursorOffsetToFileSelectMode		; $43d1
	ldh a,(<hActiveFileSlot)	; $43d4
+
	jp _func_02_4149		; $43d6

;;
; Erasing a file
; @addr{43d9}
_fileSelectMode4:
	call @mode4Update		; $43d9
	call _fileSelectDrawAcornCursor		; $43dc
	jp _fileSelectDrawLink		; $43df

; @addr{43e2}
@mode4Update:
	ld a,(wFileSelect.mode2)		; $43e2
	rst_jumpTable			; $43e5
.dw @mode0
.dw @mode1
.dw @mode2
.dw @mode3

@mode0:
	call _setFileSelectCursorOffsetToFileSelectMode		; $43ee
	ld a,$03		; $43f1
	call _func_02_4149		; $43f3
	call disableLcd		; $43f6
	ld a,GFXH_a4		; $43f9
	call loadGfxHeader		; $43fb
	ld a,PALH_06		; $43fe
	call loadPaletteHeader		; $4400
	call _loadFileDisplayVariables		; $4403
	call _textInput_updateEntryCursor		; $4406
	call _fileSelectDrawHeartsAndDeathCounter		; $4409
	jp _loadGfxRegisterState5AndIncFileSelectMode2		; $440c

@mode1:
	call _fileSelectUpdateInput		; $440f
	ret z			; $4412

	ld a,SND_SELECTITEM	; $4413
	call playSound		; $4415
	ld a,(wFileSelect.cursorPos)		; $4418
	cp $03			; $441b
	jp z,_setFileSelectModeTo1		; $441d

	ldh (<hActiveFileSlot),a	; $4420
	jp _incFileSelectMode2		; $4422

@mode2:
	call _decFileSelectMode2IfBPressed		; $4425
	jr nz,++		; $4428

	call func_02_448d		; $442a
	ret z			; $442d

	ld a,(wFileSelect.cursorPos2)		; $442e
	or a			; $4431
	jp z,_setFileSelectModeTo1		; $4432
	jp _incFileSelectMode2		; $4435
++
	ld a,SND_CLINK		; $4438
	call playSound		; $443a
	ld a,(wFileSelect.cursorPos)		; $443d
	jp _func_02_4149		; $4440

@mode3:
	ld hl,wInventory.itemSubmenuMaxWidth		; $4443
	dec (hl)		; $4446
	bit 0,(hl)		; $4447
	ret nz			; $4449

	ldh a,(<hActiveFileSlot)	; $444a
	ld d,$02		; $444c
	call _getFileDisplayVariableAddress		; $444e
	ld a,(hl)		; $4451
	or a			; $4452
	jr z,++			; $4453

	dec a			; $4455
	ld (hl),a		; $4456
	and $03			; $4457
	ld a,SND_GAINHEART	; $4459
	call z,playSound		; $445b
	jp _fileSelectDrawHeartsAndDeathCounter		; $445e
++
	call eraseFile		; $4461
	jp _setFileSelectModeTo1		; $4464

;;
; Returns z-flag unset if something was selected.
; @addr{4467}
_fileSelectUpdateInput:
	ld a,(wKeysJustPressed)		; $4467
	ld c,a			; $446a
	ld hl,wFileSelect.cursorPos		; $446b
	ld a,$ff		; $446e
	bit BTN_BIT_UP,c			; $4470
	jr nz,@upOrDown			; $4472

	ld a,$01		; $4474
	bit BTN_BIT_DOWN,c			; $4476
	jr nz,@upOrDown			; $4478

	ld a,c			; $447a
	and BTN_A | BTN_START	; $447b
	ld b,a			; $447d
	ret			; $447e
@upOrDown:
	ld b,a			; $447f
	push bc			; $4480
	add (hl)		; $4481
	and $03			; $4482
	call _fileSelectSetCursor		; $4484
	call _fileSelectDrawHeartsAndDeathCounter		; $4487
	pop bc			; $448a
	xor a			; $448b
	ret			; $448c

;;
; @addr{448d}
func_02_448d:
	ld a,(wKeysJustPressed)		; $448d
	ld c,a			; $4490
	ld hl,wFileSelect.cursorPos2		; $4491
	res 7,(hl)		; $4494
	xor a			; $4496
	bit 5,c			; $4497
	jr nz,+			; $4499

	inc a			; $449b
	bit 4,c			; $449c
	jr nz,+			; $449e

	ld a,c			; $44a0
	and $09			; $44a1
	ret			; $44a3
+
	cp (hl)			; $44a4
	call nz,_fileSelectSetCursor		; $44a5
	xor a			; $44a8
	ret			; $44a9

;;
; @addr{44aa}
_fileSelectSetCursor:
	ld (hl),a		; $44aa
	ld a,SND_MENU_MOVE		; $44ab
	jp playSound		; $44ad

;;
; Entering name
; @addr{44b0}
_fileSelectMode2:
	call @func		; $44b0
	jp _drawNameInputCursors		; $44b3

@func:
	ld a,(wFileSelect.mode2)		; $44b6
	rst_jumpTable			; $44b9
.dw @mode0
.dw _runTextInput
.dw @mode2

@mode0:
	call eraseFile		; $44c0
	call loadFile		; $44c3
	xor a			; $44c6
	jp _copyNameToW4NameBuffer		; $44c7

@mode2:
	call _getNameBufferLength		; $44ca
	jr z,+			; $44cd

	ld hl,w4NameBuffer		; $44cf
	ld de,wLinkName		; $44d2
	ld b,$06		; $44d5
	call copyMemory		; $44d7
	call initializeFile		; $44da
+
	jp _setFileSelectModeTo1		; $44dd

;;
; @addr{44e0}
_runKidNameEntryMenu:
	call fileSelect_redrawDecorationsAndSetWramBank4		; $44e0
	call @func		; $44e3
	jp _drawNameInputCursors		; $44e6

@func:
	ld a,(wFileSelect.mode2)		; $44e9
	rst_jumpTable			; $44ec
.dw @mode0
.dw @mode1
.dw @mode2

@mode0:
	ld a,GFXH_a0		; $44f3
	call loadGfxHeader		; $44f5
	ld a,$01		; $44f8
	call _copyNameToW4NameBuffer		; $44fa
	jp fadeinFromWhite		; $44fd

@mode1:
	ld a,(wPaletteThread_mode)		; $4500
	or a			; $4503
	ret nz			; $4504
	jp _runTextInput		; $4505

@mode2:
	call _getNameBufferLength		; $4508
	ld a,$01		; $450b
	jr z,+			; $450d

	ld hl,w4NameBuffer		; $450f
	ld de,wKidName		; $4512
	ld b,$06		; $4515
	call copyMemory		; $4517
	ld a,SND_SELECTITEM	; $451a
	call playSound		; $451c
	xor a			; $451f
+
	ld (wTextInputResult),a		; $4520
	jp _closeMenu		; $4523

;;
; Entering a secret
; @addr{4526}
_fileSelectMode6:
	call @updateMode6		; $4526
	jp _drawSecretInputCursors		; $4529

@updateMode6:
	ld a,(wFileSelect.mode2)		; $452c
	rst_jumpTable			; $452f
	.dw @mode0
	.dw _runTextInput
	.dw @mode2
	.dw _setFileSelectModeTo1
	.dw _textInput_waitForInput

@mode0:
	xor a			; $453a
	ld (wSecretInputType),a		; $453b
	jp _func_02_465c		; $453e

@mode2:
	ld hl,w4SecretBuffer		; $4541
	ld de,wTmpcec0		; $4544
	ld b,$20		; $4547
	call copyMemory		; $4549
	ld bc,$0100		; $454c
	call secretFunctionCaller		; $454f
	jp nz,_fileSelect_printError		; $4552

	ld a,($ced2)		; $4555
	or a			; $4558
	jr z,+			; $4559

	ld a,($cec5)		; $455b
.ifdef ROM_AGES
	dec a			; $455e
.else; ROM_SEASONS
	or a
.endif
	jp z,_fileSelect_printError		; $455f
+
	call loadFile		; $4562
	ld bc,$0400		; $4565
	call secretFunctionCaller		; $4568
	call initializeFile		; $456b
	jp _setFileSelectModeTo1		; $456e


;;
; A secret entry menu called from in-game (not called from file select)
; @addr{4571}
_runSecretEntryMenu:
	call fileSelect_redrawDecorationsAndSetWramBank4		; $4571
	call @func		; $4574
	jp _drawSecretInputCursors		; $4577

@func:
	ld a,(wFileSelect.mode2)		; $457a
	rst_jumpTable			; $457d
	.dw @mode0
	.dw @mode1
	.dw @mode2
	.dw _closeMenu
	.dw _textInput_waitForInput

@mode0:
	ld a,GFXH_a0		; $4588
	call loadGfxHeader		; $458a
	call _func_02_465c		; $458d
	jp fadeinFromWhite		; $4590

; Run text input
@mode1:
	ld a,(wPaletteThread_mode)		; $4593
	or a			; $4596
	ret nz			; $4597
	jp _runTextInput		; $4598

; Check whether secret is good
@mode2:
	ld hl,w4SecretBuffer		; $459b
	ld de,wTmpcec0		; $459e
	ld b,$20		; $45a1
	call copyMemory		; $45a3

	; Unpack the secret (b=$01)
	ldbc $01,$03		; $45a6
	ld a,(wSecretInputType)		; $45a9
	rlca			; $45ac
	jr c,+			; $45ad
	ld c,$02		; $45af
+
	call secretFunctionCaller		; $45b1
	jr nz,@invalidSecret	; $45b4

	; Verify the secret (b=$02)
	ld b,$02		; $45b6
	call secretFunctionCaller		; $45b8
	jr nz,@invalidSecret	; $45bb


	; [$cec4] = the unpacked secret's "wShortSecretIndex" value (only for short secret
	; types)
	ld a,($cec4)		; $45bd
	ld b,a			; $45c0
	ld a,(wSecretInputType)		; $45c1
	cp $ff			; $45c4
	jr nz,++		; $45c6

	; 5-letter secret from farore (doesn't check which 5-letter secret it is)
	xor a			; $45c8
	ld (wSecretInputType),a		; $45c9
	ld a,b			; $45cc
	jr @setTextInputResult		; $45cd

++
	cp $02			; $45cf
	jr z,@loadRingSecretData	; $45d1

	; 5-letter secret: check that [$cec4] == [wSecretInputType]&$3f (basically, this
	; is the short secret type that we're looking for, not somebody else's)
	and $3f			; $45d3
	sub b			; $45d5
	jr z,@setTextInputResult	; $45d6

@invalidSecret:
	ld a,$01		; $45d8

@setTextInputResult:
	ld (wTextInputResult),a		; $45da
	jr nz,_fileSelect_printError		; $45dd

	ld a,SND_SOLVEPUZZLE	; $45df
	call playSound		; $45e1
	jp _closeMenu		; $45e4

@loadRingSecretData:
	; Load the data from the ring secret (updates obtained rings)
	ldbc $04,$02		; $45e7
	call secretFunctionCaller		; $45ea
	xor a			; $45ed
	jr @setTextInputResult		; $45ee

;;
; @addr{45f0}
_fileSelect_printError:
	ld a,SND_ERROR		; $45f0
	call playSound		; $45f2
	ld a,$10		; $45f5
	ld (wInventory.itemSubmenuMaxWidth),a		; $45f7
	ld a,$04		; $45fa
	ld (wFileSelect.mode2),a		; $45fc
	ld a,GFXH_ad		; $45ff
	call loadGfxHeader		; $4601
	ld a,UNCMP_GFXH_08		; $4604
	jp loadUncompressedGfxHeader		; $4606

;;
; Wait for input while showing "That's Wrong" text.
; @addr{4609}
_textInput_waitForInput:
	ld hl,wInventory.itemSubmenuMaxWidth		; $4609
	ld a,(hl)		; $460c
	or a			; $460d
	jr z,+			; $460e

	dec (hl)		; $4610
	ret			; $4611
+
	ld a,(wKeysPressed)		; $4612
	or a			; $4615
	ret z			; $4616

	ld a,$01		; $4617
	ld (wFileSelect.mode2),a		; $4619
;;
; @addr{461c}
func_02_461c:
	ld a,GFXH_ac		; $461c
	call loadGfxHeader		; $461e
	ld a,UNCMP_GFXH_08		; $4621
	jp loadUncompressedGfxHeader		; $4623

;;
; Returns in b the length of the buffer used. Ignores trailing spaces.
; @addr{4626}
_getNameBufferLength:
	ld hl,w4NameBuffer		; $4626
	ld b,$05		; $4629
	xor a			; $462b
--
	cp (hl)			; $462c
	jr nz,+			; $462d
	ld (hl),$20		; $462f
+
	inc l			; $4631
	dec b			; $4632
	jr nz,--		; $4633

	ldd (hl),a		; $4635
	ld b,$05		; $4636
--
	ld a,(hl)		; $4638
	sub $20			; $4639
	ret nz			; $463b

	ldd (hl),a		; $463c
	dec b			; $463d
	jr nz,--		; $463e
	ret			; $4640

;;
; Dunno exactly what this does after the jump
; @param a 1 for kid name, 0 for link name
; @addr{4641}
_copyNameToW4NameBuffer:
	ld (wFileSelect.textInputMode),a		; $4641
	ld de,wLinkName		; $4644
	cp $01			; $4647
	jr nz,+			; $4649
	ld e,<wKidName		; $464b
+
	ld hl,w4NameBuffer		; $464d
	ld b,$06		; $4650
	call copyMemoryReverse		; $4652
	ld a,$04		; $4655
	ld (wFileSelect.textInputMaxCursorPos),a		; $4657
	jr _label_02_038		; $465a

;;
; @addr{465c}
_func_02_465c:
	ld a,(wSecretInputType)		; $465c
	bit 7,a			; $465f
	jr nz,+			; $4661

	ldbc 14, $81		; $4663
	cp $02			; $4666
	jr z,++			; $4668

	ldbc 19, $82		; $466a
	jr ++			; $466d
+
	ld a,$ff		; $466f
	ld (wLastSecretInputLength),a		; $4671
	ldbc 4, $80		; $4674
++
	ld a,b			; $4677
	ld (wFileSelect.textInputMaxCursorPos),a		; $4678
	ld a,c			; $467b
	ld (wFileSelect.textInputMode),a		; $467c
_label_02_038:
	ld hl,wTmpcbb9		; $467f
	ld b,$0a		; $4682
	call clearMemory		; $4684
	call _textInput_loadCharacterGfx		; $4687
	call disableLcd		; $468a
	ld a,UNCMP_GFXH_0b		; $468d
	call loadUncompressedGfxHeader		; $468f
	ld a,PALH_05		; $4692
	call loadPaletteHeader		; $4694
	ld a,(wFileSelect.textInputMode)		; $4697
	rlca			; $469a
	jr c,@secretEntry			; $469b

; Entering a name for the player or the kid

	ld a,GFXH_a5		; $469d
	call loadGfxHeader		; $469f
	ld a,(wFileSelect.textInputMode)		; $46a2
	rrca			; $46a5
	jr c,+			; $46a6

; Entering a name for the player

	; Draw the file number
	ldh a,(<hActiveFileSlot)	; $46a8
	add $20			; $46aa
	ld (w4TileMap+$49),a		; $46ac
+
	ld a,UNCMP_GFXH_08		; $46af
	call loadUncompressedGfxHeader		; $46b1
	jr @end			; $46b4

@secretEntry:
	ld a,(wFileSelect.textInputMaxCursorPos)		; $46b6
	ld hl,wLastSecretInputLength		; $46b9
	cp (hl)			; $46bc
	ld (hl),a		; $46bd
	ld hl,w4SecretBuffer		; $46be
	ld b,$20		; $46c1
	ld a,$20		; $46c3
	call nz,fillMemory		; $46c5
	ld a,GFXH_aa		; $46c8
	call loadGfxHeader		; $46ca
	call func_02_461c		; $46cd
@end:
	call _textInput_updateEntryCursor		; $46d0
	jp _loadGfxRegisterState5AndIncFileSelectMode2		; $46d3

;;
; Name / secret selection
; @addr{46d6}
_runTextInput:
	ld a,$01		; $46d6
	ld (wTextInputResult),a		; $46d8
	call getInputWithAutofire		; $46db
	ld b,a			; $46de
	call getHighestSetBit		; $46df
	ret nc			; $46e2

	ld b,a			; $46e3
	ld hl,@soundEffects	; $46e4
	rst_addAToHl			; $46e7
	ld a,(hl)		; $46e8
	call playSound		; $46e9
	ld a,b			; $46ec
	rst_jumpTable			; $46ed
.dw @aButton
.dw @bButton
.dw @selectButton
.dw @startButton
.dw @rightButton
.dw @leftButton
.dw @upButton
.dw @downButton

; @addr{46fe}
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
	ld hl,wFileSelect.cursorPos		; $4706
	ldi a,(hl)		; $4709
	cp $50			; $470a
	jr nc,@lowerOptions	; $470c

	call _textInput_getCursorPosition		; $470e
	and $0f			; $4711
	ld hl,w4TileMap+$a3		; $4713
	rst_addAToHl			; $4716
	ld a,b			; $4717
	swap a			; $4718
	add a			; $471a
	add a			; $471b
	call multiplyABy16		; $471c
	add hl,bc		; $471f
	ld c,$20		; $4720
	ld a,(hl)		; $4722
	cp $02			; $4723
	jr z,++			; $4725

	rrca			; $4727
	and $3f			; $4728
	add $40			; $472a
	ld c,a			; $472c
	ld a,(wFileSelect.textInputMode)		; $472d
	rlca			; $4730
	jr nc,++		; $4731

	ld a,c			; $4733
	ld hl,secretSymbols-$40	; $4734
	rst_addAToHl			; $4737
	ld c,(hl)		; $4738
++
	call _textInput_getOutputAddress		; $4739
	ld (hl),c		; $473c
@selectionRight:
	ld hl,wFileSelect.textInputCursorPos		; $473d
	inc (hl)		; $4740
	ld a,(wFileSelect.textInputMaxCursorPos)		; $4741
	cp (hl)			; $4744
	jr nc,@updateEntryCursor			; $4745
	ld (hl),a		; $4747
@updateEntryCursor:
	jp _textInput_updateEntryCursor		; $4748

@lowerOptions:
	ld a,(wFileSelect.textInputMode)		; $474b
	rlca			; $474e
	ld a,(wFileSelect.cursorPos2)		; $474f
	jr c,@secretTable			; $4752

@nameTable:
	rst_jumpTable			; $4754
	.dw @selectionLeft
	.dw @selectionRight
	.dw @startButton

@secretTable:
	rst_jumpTable			; $475b
	.dw @selectionLeft
	.dw @selectionRight
	.dw @back
	.dw @startButton

@bButton:
	call _textInput_getOutputAddress		; $4764
	ld (hl),$20		; $4767
@selectionLeft:
	ld hl,wFileSelect.textInputCursorPos		; $4769
	dec (hl)		; $476c
	bit 7,(hl)		; $476d
	jr z,@updateEntryCursor		; $476f

	ld (hl),$00		; $4771
	jr @updateEntryCursor			; $4773

@selectButton:
	ret			; $4775

@back:
	ld a,(wFileSelect.textInputMode)		; $4776
	rlca			; $4779
	ret nc			; $477a

	xor a			; $477b
	ld (wTmpcbb9),a		; $477c
	ld hl,wFileSelect.cursorPos		; $477f
	ld a,$57		; $4782
	ldi (hl),a		; $4784
	ld a,$02		; $4785
	cp (hl)			; $4787
	ldd (hl),a		; $4788
	ret nz			; $4789

	ld a,$03		; $478a
	ld (wFileSelect.mode2),a		; $478c
	ret			; $478f

@rightButton:
	ld c,$01		; $4790
	jr @leftOrRight		; $4792
@leftButton:
	ld c,$ff		; $4794

@leftOrRight:
	ldde $04, $0d		; $4796
	ld a,(wFileSelect.textInputMode)		; $4799
	rlca			; $479c
	jr c,+			; $479d
	ldde $03, $0c		; $479f
+
	ld hl,wFileSelect.cursorPos		; $47a2
	ld a,(hl)		; $47a5
	cp $50			; $47a6
	jr nc,@@lowerOptions	; $47a8
-
	add c			; $47aa
	and $0f			; $47ab
	cp e			; $47ad
	jr nc,-			; $47ae

	ld c,a			; $47b0
	ld a,(hl)		; $47b1
	and $f0			; $47b2
	add c			; $47b4
	ldi (hl),a		; $47b5
	ld (hl),$80		; $47b6
	ret			; $47b8
@@lowerOptions:
	inc l			; $47b9
	ld b,d			; $47ba
	ld a,(hl)		; $47bb
-
	add c			; $47bc
	and $0f			; $47bd
	cp b			; $47bf
	jr nc,-			; $47c0

	ld (hl),a		; $47c2
	jp _textInput_lowerOption_updateFileSelectCursorPos		; $47c3

@upButton:
	ld c,$f0		; $47c6
	jr @upOrDown		; $47c8
@downButton:
	ld c,$10		; $47ca

@upOrDown:
	ld hl,wFileSelect.cursorPos		; $47cc
	ld a,(hl)		; $47cf
-
	add c			; $47d0
	and $70			; $47d1
	cp $60			; $47d3
	jr nc,-			; $47d5

	ld c,a			; $47d7
	ld a,(hl)		; $47d8
	and $0f			; $47d9
	add c			; $47db
	ldi (hl),a		; $47dc
	ld (hl),$80		; $47dd
	cp $50			; $47df
	ret c			; $47e1
	jp _textInput_lowerOption_updateFileSelectCursorPos2		; $47e2

@startButton:
	ld hl,wFileSelect.cursorPos		; $47e5
	ld a,$5a		; $47e8
	ldi (hl),a		; $47ea
	ld a,(wFileSelect.textInputMode)		; $47eb
	rlca			; $47ee
	ld a,$02		; $47ef
	jr nc,+			; $47f1
	ld a,$03		; $47f3
+
	cp (hl)			; $47f5
	ldd (hl),a		; $47f6
	ret nz			; $47f7
	jp _incFileSelectMode2		; $47f8

;;
; Returns the position of the character within w4TileMap in A, relative to the
; first character at position $a3.
; @addr{47fb}
_textInput_getCursorPosition:
	ld a,(wFileSelect.cursorPos)		; $47fb
	ld c,a			; $47fe
	and $f0			; $47ff
	ld b,a			; $4801
	ld a,c			; $4802
	and $0f			; $4803
	ld c,a			; $4805
	push de			; $4806
	ldde $08, $01		; $4807
	ld a,(wFileSelect.textInputMode)		; $480a
	rlca			; $480d
	jr c,+			; $480e
	ldde $06, $02		; $4810
+
	ld a,c			; $4813
	cp d			; $4814
	ld c,e			; $4815
	pop de			; $4816
	jr nc,+			; $4817
	ld c,$00		; $4819
+
	add c			; $481b
	add b			; $481c
	ret			; $481d

;;
; Draws cursors for the currently selected character, and the position in the
; input string.
; @addr{481e}
_drawNameInputCursors:
	call _textInput_getCursorPosition		; $481e
	cp $50			; $4821
	jr nc,@lowerOptions	; $4823

; Standard characters
@upperOptions:
	ld b,a			; $4825
	and $0f			; $4826
	add a			; $4828
	add a			; $4829
	add a			; $482a
	ld c,a			; $482b
	ld a,b			; $482c
	and $f0			; $482d
	ld b,a			; $482f
	ld hl,@cursorOnCharacterSprites		; $4830
	call addSpritesToOam_withOffset		; $4833
	jr ++			; $4836

; Extra options like cursor left, cursor right, back, OK
@lowerOptions:
	ld a,(wFileSelect.textInputMode)		; $4838
	rlca			; $483b
	ld hl,@secretInputOffsets	; $483c
	jr c,+			; $483f
	ld hl,@nameInputOffsets	; $4841
+
	ld a,(wFileSelect.cursorPos2)		; $4844
	rst_addAToHl			; $4847
	ld c,(hl)		; $4848
	ld b,$00		; $4849
	ld hl,@lowerOptionCursorSprites	; $484b
	call addSpritesToOam_withOffset		; $484e
++
	ld a,(wFileSelect.textInputCursorPos)		; $4851
	add a			; $4854
	add a			; $4855
	add a			; $4856
	ld c,a			; $4857
	ld b,$00		; $4858
	ld hl,@textInputCursorSprite	; $485a
	jp addSpritesToOam_withOffset		; $485d

; The cursor and blue highlight for normal characters
; @addr{4860}
@cursorOnCharacterSprites:
	.db $02
	.db $3a $20 $2c $02 ; Cursor
	.db $38 $20 $2a $81 ; Blue highlight

; @addr{4869}
@nameInputOffsets:
	.db $18 $30 $78
; @addr{486c}
@secretInputOffsets:
	.db $18 $30 $48 $60

; The cursor for the bottom options
; @addr{4870}
@lowerOptionCursorSprites:
	.db $02
	.db $8a $08 $2c $01 ; Left
	.db $8a $10 $2c $01 ; Right

; The cursor at the top of the screen where the secret/name text is.
; @addr{4879}
@textInputCursorSprite:
	.db $01
	.db $1a $58 $2c $82

;;
; Same as drawNameInputCursors, but for secrets.
; @addr{487e}
_drawSecretInputCursors:
	call _textInput_getCursorPosition		; $487e
	cp $50			; $4881
	jr nc,@lowerOptions	; $4883

; Standard characters
@upperOptions:
	ld b,a			; $4885
	and $0f			; $4886
	add a			; $4888
	add a			; $4889
	add a			; $488a
	ld c,a			; $488b
	ld a,b			; $488c
	and $f0			; $488d
	ld b,a			; $488f
	ld hl,@cursorOnCharacterSprites	; $4890
	call addSpritesToOam_withOffset		; $4893
	jr ++			; $4896

; Extra options like cursor left, cursor right, back, OK
@lowerOptions:
	ld a,(wFileSelect.cursorPos2)		; $4898
	ld hl,@lowerOptionsOffsets	; $489b
	rst_addAToHl			; $489e
	ld c,(hl)		; $489f
	ld b,$00		; $48a0
	ld hl,@lowerOptionCursorSprites		; $48a2
	call addSpritesToOam_withOffset		; $48a5
++
	ld c,$0a		; $48a8
	ld a,(wFileSelect.textInputCursorPos)		; $48aa
	cp c			; $48ad
	ld b,$00		; $48ae
	jr c,+			; $48b0

	ld b,$10		; $48b2
	sub c			; $48b4
+
	cp $05			; $48b5
	jr c,+			; $48b7
	inc a			; $48b9
+
	add a			; $48ba
	add a			; $48bb
	add a			; $48bc
	ld c,a			; $48bd
	ld hl,@textInputCursorSprite	; $48be
	jp addSpritesToOam_withOffset		; $48c1

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
; @addr{48df}
_textInput_lowerOption_updateFileSelectCursorPos:
	ld a,(wFileSelect.cursorPos2)		; $48df
	ld e,a			; $48e2
	ld d,$ff		; $48e3
	call _textInput_mapUpperXToLowerX		; $48e5
	ld a,b			; $48e8
	ld (wFileSelect.cursorPos),a		; $48e9
	ret			; $48ec

;;
; Reverse of above
; @addr{48ed}
_textInput_lowerOption_updateFileSelectCursorPos2:
	ld a,(wFileSelect.cursorPos)		; $48ed
	ld d,a			; $48f0
	ld e,$ff		; $48f1
	call _textInput_mapUpperXToLowerX		; $48f3
	ld a,c			; $48f6
	ld (wFileSelect.cursorPos2),a		; $48f7
	ret			; $48fa

;;
; @addr{48fb}
_textInput_mapUpperXToLowerX:
	ld a,(wFileSelect.textInputMode)		; $48fb
	rlca			; $48fe
	ld hl,@nameTable	; $48ff
	jr nc,@label		; $4902
	ld hl,@secretTable	; $4904
@label:
	ldi a,(hl)		; $4907
	ld b,a			; $4908
	ldi a,(hl)		; $4909
	ld c,a			; $490a
	cp e			; $490b
	ret z			; $490c

	ld a,b			; $490d
	cp d			; $490e
	jr nz,@label		; $490f
	ret			; $4911

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

;;
; Unused?
; @addr{494a}
_func_02_494a:
	push hl			; $494a
	ld hl,@table2		; $494b
	bit 0,e			; $494e
	jr nz,+			; $4950
	ld hl,@table1		; $4952
+
	cp $60			; $4955
	ccf			; $4957
	jr nc,@end		; $4958

	ld b,$00		; $495a
	cp $b0			; $495c
	jr c,+			; $495e

	ld b,$50		; $4960
	sub b			; $4962
+
	ld c,a			; $4963
-
	ldi a,(hl)		; $4964
	or a			; $4965
	jr z,@end		; $4966

	cp c			; $4968
	ldi a,(hl)		; $4969
	jr nz,-			; $496a

	add b			; $496c
	ld c,a			; $496d
	scf			; $496e
@end:
	pop hl			; $496f
	ret			; $4970

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
; @addr{49a5}
_textInput_loadCharacterGfx:
	ld a,($ff00+R_SVBK)	; $49a5
	push af			; $49a7
	ld a,:w5NameEntryCharacterGfx		; $49a8
	ld ($ff00+R_SVBK),a	; $49aa
	xor a			; $49ac
	ld (wFileSelect.fontXor),a		; $49ad
	ld de,w5NameEntryCharacterGfx		; $49b0
	ld a,(wFileSelect.textInputMode)		; $49b3
	rlca			; $49b6
	jr c,+			; $49b7

	ldbc $3b, $40		; $49b9
	call _copyTextCharacters		; $49bc
	jr ++			; $49bf
+
	ld hl,secretSymbols		; $49c1
	ld b,$40		; $49c4
	call _copyTextCharactersFromHlUntilNull		; $49c6
++
	pop af			; $49c9
	ld ($ff00+R_SVBK),a	; $49ca
	ret			; $49cc

;;
; @param	b			Number of characters to copy
; @param	c			First character to copy
; @param	de			Destination
; @param	wFileSelect.fontXor	Value to xor every other byte with
; @addr{49cd}
_copyTextCharacters:
	push bc			; $49cd
	ld a,c			; $49ce
	ld c,$00		; $49cf
	call copyTextCharacterGfx		; $49d1
	pop bc			; $49d4
	inc c			; $49d5
	dec b			; $49d6
	jr nz,_copyTextCharacters	; $49d7
	ret			; $49d9

;;
; Loads variables related to each of the 3 files (heart display, etc)
; @addr{49da}
_loadFileDisplayVariables:
	ld a,$02		; $49da
	ldh (<hActiveFileSlot),a	; $49dc
@nextFile:
	call loadFile		; $49de
	ldh a,(<hActiveFileSlot)	; $49e1
	ld d,$00		; $49e3
	call _getFileDisplayVariableAddress		; $49e5
	ld a,c			; $49e8
	ldi (hl),a		; $49e9
	ldi (hl),a		; $49ea
	ld a,(wLinkMaxHealth)		; $49eb
	ldi (hl),a		; $49ee
	ldi (hl),a		; $49ef
	ld a,(wDeathCounter)		; $49f0
	ldi (hl),a		; $49f3
	ld a,(wDeathCounter+1)		; $49f4
	ldi (hl),a		; $49f7
	ld a,(wFileIsLinkedGame)		; $49f8
	ldi (hl),a		; $49fb
	ld a,(wFileIsHeroGame)		; $49fc
	add a			; $49ff
	ld e,a			; $4a00
	ld a,($c614)		; $4a01
	or e			; $4a04
	ldi (hl),a		; $4a05
	ldh a,(<hActiveFileSlot)	; $4a06
	add a			; $4a08
	ld e,a			; $4a09
	add a			; $4a0a
	add e			; $4a0b
	ld hl,w4NameBuffer		; $4a0c
	rst_addAToHl			; $4a0f
	ld de,wLinkName		; $4a10
	ld b,$06		; $4a13
	call copyMemoryReverse		; $4a15
	ld hl,hActiveFileSlot		; $4a18
	dec (hl)		; $4a1b
	bit 7,(hl)		; $4a1c
	jr z,@nextFile		; $4a1e
	inc (hl)		; $4a20
	ret			; $4a21

;;
; Updates the displayed text and the cursor?
; @addr{4a22}
_textInput_updateEntryCursor:
	xor a			; $4a22
	call _textInput_getOutputAddressOffset		; $4a23
	ld de,w4GfxBuf1		; $4a26
	ld b,$18		; $4a29
	call _copyTextCharactersFromHl		; $4a2b
	xor a			; $4a2e
	ld (wFileSelect.fontXor),a		; $4a2f
	ld a,UNCMP_GFXH_07		; $4a32
	jp loadUncompressedGfxHeader		; $4a34

;;
; @addr{4a37}
_textInput_getOutputAddress:
	ld a,(wFileSelect.textInputCursorPos)		; $4a37
_textInput_getOutputAddressOffset:
	ld l,a			; $4a3a
	ld a,(wFileSelect.textInputMode)		; $4a3b
	rlca			; $4a3e
	ld a,l			; $4a3f
	ld hl,w4NameBuffer		; $4a40
	jr nc,+			; $4a43
	ld hl,w4SecretBuffer		; $4a45
+
	rst_addAToHl			; $4a48
	ret			; $4a49

;;
; @addr{4a4a}
_fileSelectDrawHeartsAndDeathCounter:
	ld a,(wFileSelect.mode)		; $4a4a
	cp $03			; $4a4d
	ret z			; $4a4f

	ld a,GFXH_a2		; $4a50
	call loadGfxHeader		; $4a52

	; Jump if cursor isn't on a file
	ld a,(wFileSelect.cursorPos)		; $4a55
	cp $03			; $4a58
	jr nc,+++		; $4a5a

	; Jump if the cursor is on an empty file
	ld d,$00		; $4a5c
	call _getFileDisplayVariableAddress		; $4a5e
	bit 7,(hl)		; $4a61
	jr nz,+++		; $4a63

	; Draw death count
	ld d,$04		; $4a65
	call _getFileDisplayVariableAddress_paramE		; $4a67
	ld e,l			; $4a6a
	ld d,h			; $4a6b
	ld hl,w4TileMap+$130		; $4a6c
	ld b,$10		; $4a6f
	ld a,(de)		; $4a71
	and $0f			; $4a72
	add b			; $4a74
	ldd (hl),a		; $4a75
	ld a,(de)		; $4a76
	and $f0			; $4a77
	swap a			; $4a79
	add b			; $4a7b
	ldd (hl),a		; $4a7c
	inc e			; $4a7d
	ld a,(de)		; $4a7e
	add b			; $4a7f
	ldd (hl),a		; $4a80

	; Draw hearts
	ld a,(wFileSelect.cursorPos)		; $4a81
	ld d,$02		; $4a84
	call _getFileDisplayVariableAddress		; $4a86
	ldi a,(hl)		; $4a89
	ld b,(hl)		; $4a8a
	ld c,a			; $4a8b
	ld hl,w4TileMap+$14a		; $4a8c
	call _fileSelectDrawHeartDisplay		; $4a8f
+++
	; Load the tile map that was just drawn on
	ld a,UNCMP_GFXH_08		; $4a92
	jp loadUncompressedGfxHeader		; $4a94

;;
; Draws the cursor on the main file select and "new game/secret/link" screen
; @addr{4a97}
_fileSelectDrawAcornCursor:
	ld a,(wFileSelect.cursorOffset)		; $4a97
	ld hl,@table		; $4a9a
	rst_addDoubleIndex			; $4a9d
	ldi a,(hl)		; $4a9e
	ld h,(hl)		; $4a9f
	ld l,a			; $4aa0
	ldi a,(hl)		; $4aa1
	ld e,a			; $4aa2
	ldi a,(hl)		; $4aa3
	ld d,a			; $4aa4
	ldi a,(hl)		; $4aa5
	ld c,a			; $4aa6
	ld b,(hl)		; $4aa7
	push bc			; $4aa8
	ld hl,@sprite		; $4aa9
	ld a,(wFileSelect.cursorPos)		; $4aac
	bit 7,a			; $4aaf
	call z,@func		; $4ab1
	pop de			; $4ab4
	ld hl,@sprite		; $4ab5
	ld a,(wFileSelect.cursorPos2)		; $4ab8
	bit 7,a			; $4abb
	ret nz			; $4abd
;;
; @addr{4abe}
@func:
	call addDoubleIndexToDe		; $4abe
	ld a,(de)		; $4ac1
	ld b,a			; $4ac2
	inc de			; $4ac3
	ld a,(de)		; $4ac4
	ld c,a			; $4ac5
	jp addSpritesToOam_withOffset		; $4ac6

; @addr{4ac9}
@sprite:
	.db $01
	.db $10 $08 $28 $04

; @addr{4ace}
@table:
	.dw @table2
	.dw @table1
	.dw @table1
	.dw @table4
	.dw @table5
	.dw @table6
	.dw @table3

; @addr{4adc}
@table1:
	.dw @data11
	.dw @data12

; @addr{4ae0}
@data11:
	.db $34 $08
	.db $4c $08
	.db $64 $08
	.db $e0 $e0
; @addr{4ae8}
@data12:
	.db $7a $22
	.db $7a $5a

; @addr{4aec}
@table3:
	.dw @data31

; @addr{4aee}
@data31:
	.db $34 $08
	.db $4c $08
	.db $64 $08
	.db $7a $20

; @addr{4af6}
@table4:
	.dw @data41
	.dw @data12

; @addr{4afa}
@data41:
	.db $34 $08
	.db $4c $08
	.db $64 $08
	.db $7a $22

; @addr{4b02}
@table2:
	.dw @data21
	.dw @data12

; @addr{4b06}
@data21:
	.db $34 $50
	.db $4c $50
	.db $64 $50
	.db $7a $22

; @addr{4b0e}
@table5:
	.dw @data51
	.dw @data12

; @addr{4b12}
@data51:
	.db $34 $08
	.db $4c $08
	.db $64 $08
	.db $7a $22

; @addr{4b1a}
@table6:
	.dw @data61

; @addr{4b1c}
@data61:
	.db $38 $20
	.db $50 $20
	.db $68 $20

;;
; This is probably for linking to transfer ring secrets
; @addr{4b22}
_runGameLinkMenu:
	ld hl,$cbb6		; $4b22
	inc (hl)		; $4b25
	call fileSelect_redrawDecorationsAndSetWramBank4		; $4b26

;;
; Game link
; @addr{4b29}
_fileSelectMode7:
	call @mode7States	; $4b29
	ld a,(wFileSelect.mode2)		; $4b2c
	cp $06			; $4b2f
	ret z			; $4b31

	cp $03			; $4b32
	ret c			; $4b34

	call _fileSelectDrawAcornCursor		; $4b35
	jp _fileSelectDrawLinkInOtherGame		; $4b38

@mode7States:
	ld a,(wFileSelect.mode2)		; $4b3b
	rst_jumpTable			; $4b3e
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

;;
; State 0: initialization
; @addr{4b4d}
@state0:
	call disableLcd		; $4b4d
	ld a,GFXH_a0		; $4b50
	call loadGfxHeader		; $4b52
	ld a,GFXH_ae		; $4b55
	call loadGfxHeader		; $4b57
	ld a,PALH_05		; $4b5a
	call loadPaletteHeader		; $4b5c
	ld a,UNCMP_GFXH_08		; $4b5f
	call loadUncompressedGfxHeader		; $4b61

	ld hl,w4NameBuffer		; $4b64
	ld b,$20		; $4b67
	call clearMemory		; $4b69

	call _textInput_updateEntryCursor		; $4b6c
	call serialFunc_0c85		; $4b6f

	ld a,$04		; $4b72
	ldh (<hFFBE),a	; $4b74
	xor a			; $4b76
	ldh (<hFFBF),a	; $4b77
	ld ($cbc2),a		; $4b79

	ld hl,wFileSelect.linkTimer		; $4b7c
	ld a,$f0		; $4b7f
	ldi (hl),a		; $4b81
	ld a,$1e		; $4b82
	ld (hl),a		; $4b84

	jp _loadGfxRegisterState5AndIncFileSelectMode2		; $4b85

;;
; State 1: waiting for response
; @addr{4b88}
@state1:
	ldh a,(<hSerialInterruptBehaviour)	; $4b88
	or a			; $4b8a
	jr nz,++		; $4b8b

	ldh a,(<hFFBD)	; $4b8d
	or a			; $4b8f
	jp nz,@func_02_4c55		; $4b90
	ld hl,wFileSelect.linkTimer		; $4b93
	dec (hl)		; $4b96
	jr nz,+			; $4b97

	ld a,$80		; $4b99
	ldh (<hFFBD),a	; $4b9b
	jp @func_02_4c55		; $4b9d
+
	jp serialFunc_0c73		; $4ba0
++
	ld a,(wInventory.itemSubmenuWidth)		; $4ba3
	or a			; $4ba6
	jr z,+			; $4ba7

	dec a			; $4ba9
	ld (wInventory.itemSubmenuWidth),a		; $4baa
	ret			; $4bad
+
	call serialFunc_0c8d		; $4bae
	ldh a,(<hFFBD)	; $4bb1
	or a			; $4bb3
	jr z,+			; $4bb4

	cp $83			; $4bb6
	jr z,+			; $4bb8

	jp nz,@func_02_4c55		; $4bba
+
	ldh a,(<hFFBF)	; $4bbd
	cp $07			; $4bbf
	ret nz			; $4bc1
	ld e,$03		; $4bc2
-
	dec e			; $4bc4
	ld d,$00		; $4bc5
	call _getFileDisplayVariableAddress_paramE		; $4bc7
	bit 7,(hl)		; $4bca
	jr z,+			; $4bcc

	ld a,e			; $4bce
	or a			; $4bcf
	jr nz,-			; $4bd0

	ld a,$85		; $4bd2
	ld ($cbc2),a		; $4bd4
	ld a,$ff		; $4bd7
	ld (wFileSelect.cursorPos),a		; $4bd9
	jp @func_02_4c4b		; $4bdc
+
	jp _loadGfxRegisterState5AndIncFileSelectMode2		; $4bdf

;;
; @addr{4be2}
@state2:
	call serialFunc_0c8d		; $4be2
	ld a,$06		; $4be5
	ld (wFileSelect.cursorOffset),a		; $4be7
	xor a			; $4bea
	call _func_02_4149		; $4beb
	call disableLcd		; $4bee
	ld a,GFXH_a1		; $4bf1
	call loadGfxHeader		; $4bf3
	ld a,GFXH_af		; $4bf6
	call loadGfxHeader		; $4bf8
	call _textInput_updateEntryCursor		; $4bfb
	call _fileSelectDrawHeartsAndDeathCounter		; $4bfe
	jp _loadGfxRegisterState5AndIncFileSelectMode2		; $4c01

;;
; @addr{4c04}
@state3:
	call serialFunc_0c8d		; $4c04
	call _fileSelectUpdateInput		; $4c07
	jr nz,+			; $4c0a

	ld a,(wKeysJustPressed)		; $4c0c
	bit 1,a			; $4c0f
	ret z			; $4c11
-
	ld a,$03		; $4c12
	ld (wFileSelect.cursorPos),a		; $4c14
	ld a,$8f		; $4c17
	ld ($cbc2),a		; $4c19
	jr @func_02_4c4b			; $4c1c
+
	ld a,(wFileSelect.cursorPos)		; $4c1e
	cp $03			; $4c21
	jr z,-			; $4c23

	ld d,$00		; $4c25
	call _getFileDisplayVariableAddress		; $4c27
	bit 7,(hl)		; $4c2a
	jr z,+			; $4c2c

	ld a,SND_ERROR		; $4c2e
	jp playSound		; $4c30
+
	ld a,(wOpenedMenuType)		; $4c33
	cp $08			; $4c36
	jr nz,+			; $4c38

	ld a,$0c		; $4c3a
	ldh (<hFFBF),a	; $4c3c
	ld a,$05		; $4c3e
	ld (wFileSelect.mode2),a		; $4c40
	ret			; $4c43
+
	ld a,$08		; $4c44
	ldh (<hFFBF),a	; $4c46
	jp _loadGfxRegisterState5AndIncFileSelectMode2		; $4c48

;;
; @addr{4c4b}
@func_02_4c4b:
	ld a,$08		; $4c4b
	ldh (<hFFBF),a	; $4c4d
	ld a,$05		; $4c4f
	ld (wFileSelect.mode2),a		; $4c51
	ret			; $4c54

;;
; @addr{4c55}
@func_02_4c55:
	call disableLcd		; $4c55
	ld a,GFXH_07		; $4c58
	call loadGfxHeader		; $4c5a
	call _loadGfxRegisterState5AndIncFileSelectMode2		; $4c5d
	ld a,$08		; $4c60
	ldh (<hFFBF),a	; $4c62
	ld a,$06		; $4c64
	ld (wFileSelect.mode2),a		; $4c66
	ld a,$b4		; $4c69
	ld (wFileSelect.linkTimer),a		; $4c6b
	ldh a,(<hFFBD)	; $4c6e
	ld (wInventory.itemSubmenuWidth),a		; $4c70
	ret			; $4c73

;;
; @addr{4c74}
@state4:
	call serialFunc_0c8d		; $4c74
	ldh a,(<hSerialInterruptBehaviour)	; $4c77
	or a			; $4c79
	ret nz			; $4c7a
	call loadFile		; $4c7b
	ld a,(wFileSelect.cursorPos)		; $4c7e
	inc a			; $4c81
	ld hl,w4RingFortuneStuff		; $4c82
	ld bc,$0016		; $4c85
-
	dec a			; $4c88
	jr z,+			; $4c89

	add hl,bc		; $4c8b
	jr -			; $4c8c
+
	ld b,$16		; $4c8e
	ld de,wc600Block		; $4c90
	call copyMemory		; $4c93
	ld hl,wFileIsLinkedGame		; $4c96
	set 0,(hl)		; $4c99
	ld l,<wFileIsCompleted		; $4c9b
	ld (hl),$00		; $4c9d
	call initializeFile		; $4c9f
	ld a,SND_SELECTITEM	; $4ca2
	call playSound		; $4ca4
	jp _setFileSelectModeTo1		; $4ca7

;;
; @addr{4caa}
@state5:
	call serialFunc_0c8d		; $4caa
	ldh a,(<hSerialInterruptBehaviour)	; $4cad
	or a			; $4caf
	ret nz			; $4cb0
-
	ld a,(wOpenedMenuType)		; $4cb1
	cp $08			; $4cb4
	jp z,_closeMenu		; $4cb6

	ld a,$00		; $4cb9
	jp _setFileSelectMode		; $4cbb

;;
; State 6: error
; @addr{4cbe}
@state6:
	call serialFunc_0c8d		; $4cbe
	ldh a,(<hSerialInterruptBehaviour)	; $4cc1
	or a			; $4cc3
	ret nz			; $4cc4

	ld a,(wInventory.itemSubmenuWidth)		; $4cc5
	ldh (<hFFBD),a	; $4cc8
	ld a,(wKeysJustPressed)		; $4cca
	or a			; $4ccd
	jr nz,-			; $4cce

	ld hl,wFileSelect.linkTimer		; $4cd0
	dec (hl)		; $4cd3
	ret nz			; $4cd4
	jr -			; $4cd5

;;
; Clears the OAM, draws vines and stuff, sets wram bank 4
; @addr{4cd7}
fileSelect_redrawDecorationsAndSetWramBank4:
	call clearOam		; $4cd7
	ld a,$04		; $4cda
	ld ($ff00+R_SVBK),a	; $4cdc
	ld hl,@sprites		; $4cde
	jp addSpritesToOam		; $4ce1

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
; @addr{4d25}
_fileSelectDrawLinkInOtherGame:
.ifdef ROM_AGES
	ld b,$00		; $4d25
.else
	ld b,$04
.endif
	jr +			; $4d27

;;
; Draws link and nayru/din on the file select
; @addr{4d29}
_fileSelectDrawLink:
.ifdef ROM_AGES
	ld b,$04		; $4d29
.else
	ld b,$00
.endif
+
	ld a,(wFileSelect.cursorPos)		; $4d2b
	cp $03			; $4d2e
	ret nc			; $4d30

	ld d,$00		; $4d31
	call _getFileDisplayVariableAddress		; $4d33
	ld c,$00		; $4d36
	; Jump if it's a blank file
	bit 7,(hl)		; $4d38
	jr nz,+			; $4d3a

	push bc			; $4d3c
	push de			; $4d3d

	; Draw triforce symbol for hero's files
	ld d,$07		; $4d3e
	call _getFileDisplayVariableAddress_paramE		; $4d40
	xor a			; $4d43
	ld b,$10		; $4d44
	bit 1,(hl)		; $4d46
	call nz,@draw		; $4d48

	; Check whether file is linked
	pop de			; $4d4b
	pop bc			; $4d4c
	ld d,$06		; $4d4d
	call _getFileDisplayVariableAddress_paramE		; $4d4f
	inc c			; $4d52
	ldi a,(hl)		; $4d53
	rrca			; $4d54
	jr c,+			; $4d55

	; Not linked; check whether the file is completed
	inc c			; $4d57
	bit 0,(hl)		; $4d58
	jr nz,+			; $4d5a
	inc c			; $4d5c
+
	ld a,(wTmpcbb6)		; $4d5d
	and $10			; $4d60
	ld a,c			; $4d62
	jr z,@draw		; $4d63
	add $08			; $4d65
;;
; @addr{4d67}
@draw:
	add b			; $4d67
	ld hl,@spriteTable	; $4d68
	rst_addAToHl			; $4d6b
	ld a,(hl)		; $4d6c
	rst_addAToHl			; $4d6d
	jp addSpritesToOam		; $4d6e

; @addr{4d71}
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
; @addr{4d82}
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

; @addr{4e2e}
_secretTextTable:
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


@text0:
	.ifdef ROM_SEASONS
	.db 0
	.endif

; @addr{4e62}
@text1:
	.asc "--------" 0

; @addr{4e6b}
@text2:
	.asc " Secret" 0

; @addr{4e73}
@text3:
	.asc "Holodrum" 0

; @addr{4e7c}
@text4:
	.asc "Labrynna" 0

; @addr{4e85}
@text5:
	.asc "Ring" 0

; @addr{4e8a}
@text6:
	.asc "ClockShop" 0

; @addr{4e94}
@text7:
	.asc "Graveyard" 0

; @addr{4e9e}
@text8:
	.asc "Subrosian" 0

; @addr{4ea8}
@text9:
	.asc "Diver" 0

; @addr{4eae}
@texta:
	.asc "Smith" 0

; @addr{4eb4}
@textb:
	.asc "Pirate" 0

; @addr{4ebb}
@textc:
	.asc "Temple" 0

; @addr{4ec7}
@textd:
	.asc "Deku" 0

; @addr{4ed0}
@texte:
	.asc "Biggoron" 0

; @addr{4ed5}
@textf:
	.asc "Ruul" 0

; @addr{4ed5}
@text10:
	.asc "K Zora" 0

; @addr{4edc}
@text11:
	.asc "Fairy" 0

; @addr{4ee2}
@text12:
	.asc "Tokay" 0

; @addr{4ee8}
@text13:
	.asc "Plen" 0

; @addr{4eed}
@text14:
	.asc "Library" 0

; @addr{4ef5}
@text15:
	.asc "Troy" 0

; @addr{4efa}
@text16:
	.asc "Mamamu" 0

; @addr{4f01}
@text17:
	.asc "Tingle" 0

; @addr{4f08}
@text18:
	.asc "Elder" 0

; @addr{4f0e}
@text19:
	.asc "Symmetry" 0

;;
; @param h Index of function to run
; @param l Parameter to function
; @addr{4f17}
runBank2Function:
	ld c,l			; $4f17
	ld a,h			; $4f18
	rst_jumpTable			; $4f19
.dw _loadCommonGraphics
.dw _updateStatusBar
.dw _hideStatusBar
.dw _showStatusBar
.dw _saveGraphicsOnEnterMenu
.dw _reloadGraphicsOnExitMenu
.dw _openMenu
.dw _copyW2AreaBgPalettesToW4PaletteData
.dw _copyW4PaletteDataToW2AreaBgPalettes

;;
; @addr{4f2c}
_hideStatusBar:
	ld a,$04		; $4f2c
	ld ($ff00+R_SVBK),a	; $4f2e
	ld hl,wDontUpdateStatusBar		; $4f30

	; If (wDontUpdateStatusBar) isn't $77, set the sprite priority bit?
	ld a,(hl)		; $4f33
	ld (hl),$ff		; $4f34
	cp $77			; $4f36
	ld a,$80		; $4f38
	jr nz,+			; $4f3a
	xor a			; $4f3c
+
	ld hl,w4StatusBarAttributeMap	; $4f3d
	ld b,$40		; $4f40
	call fillMemory		; $4f42

	ld hl,w4StatusBarTileMap	; $4f45
	ld b,$40		; $4f48
	call clearMemory	; $4f4a

	xor a			; $4f4d
	ld (wStatusBarNeedsRefresh),a		; $4f4e
	ld a,UNCMP_GFXH_03	; $4f51
	call loadUncompressedGfxHeader		; $4f53

	; Clear the first 4 oam objects, if exactly that number has been drawn?
	; Must be the items on the status bar.
	ld b,$10		; $4f56
	ldh a,(<hOamTail)	; $4f58
	cp b			; $4f5a
	ret nz			; $4f5b

	ld a,$e0		; $4f5c
	ld hl,wOam		; $4f5e
	jp fillMemory		; $4f61

;;
; @addr{4f64}
_showStatusBar:
	xor a			; $4f64
	ld (wDontUpdateStatusBar),a		; $4f65
	dec a			; $4f68
	ld (wStatusBarNeedsRefresh),a		; $4f69
	ret			; $4f6c

;;
; @param c Value for wOpenedMenuType
; @addr{4f6d}
_openMenu:
	ld a,c			; $4f6d
	ld hl,wOpenedMenuType		; $4f6e
	ldi (hl),a		; $4f71
	xor a			; $4f72
	ldi (hl),a		; $4f73
	ldi (hl),a		; $4f74
	ldi (hl),a		; $4f75
	ld (wTextIsActive),a		; $4f76
	jp fastFadeoutToWhite		; $4f79

;;
; @addr{4f7c}
_copyW2AreaBgPalettesToW4PaletteData:
	ld hl,w2AreaBgPalettes	; $4f7c
	ld de,w4PaletteData	; $4f7f
	ld b,$80		; $4f82
-
	ld a,:w2AreaBgPalettes	; $4f84
	ld ($ff00+R_SVBK),a	; $4f86
	ld c,(hl)		; $4f88
	inc l			; $4f89
	ld a,:w4PaletteData	; $4f8a
	ld ($ff00+R_SVBK),a	; $4f8c
	ld a,c			; $4f8e
	ld (de),a		; $4f8f
	inc de			; $4f90
	dec b			; $4f91
	jr nz,-			; $4f92

	ld a,$ff		; $4f94
	ldh (<hDirtyBgPalettes),a	; $4f96
	ldh (<hDirtySprPalettes),a	; $4f98
	ret			; $4f9a

;;
; @addr{4f9b}
_copyW4PaletteDataToW2AreaBgPalettes:
	ld hl,w4PaletteData	; $4f9b
	ld de,w2AreaBgPalettes	; $4f9e
	ld b,$80		; $4fa1
-
	ld a,:w4PaletteData	; $4fa3
	ld ($ff00+R_SVBK),a	; $4fa5
	ld c,(hl)		; $4fa7
	inc l			; $4fa8
	ld a,:w2AreaBgPalettes	; $4fa9
	ld ($ff00+R_SVBK),a	; $4fab
	ld a,c			; $4fad
	ld (de),a		; $4fae
	inc de			; $4faf
	dec b			; $4fb0
	jr nz,-			; $4fb1

	ld a,$ff		; $4fb3
	ldh (<hDirtyBgPalettes),a	; $4fb5
	ldh (<hDirtySprPalettes),a	; $4fb7
	ret			; $4fb9

;;
; @addr{4fba}
_closeMenu:
	ld hl,wMenuLoadState		; $4fba
	inc (hl)		; $4fbd
	ld a,(wOpenedMenuType)		; $4fbe
	cp $03			; $4fc1
	ld a,SND_CLOSEMENU	; $4fc3
	call nz,playSound		; $4fc5
	xor a			; $4fc8
	ld (wTextIsActive),a		; $4fc9
	jp fastFadeoutToWhite		; $4fcc

;;
; Updates menu states, also plays link heart beep sound
; @addr{4fcf}
b2_updateMenus:
	ld a,(wOpenedMenuType)		; $4fcf
	or a			; $4fd2
	jr nz,@updateMenu		; $4fd3

	; Return if screen is scrolling?
	ld a,(wScrollMode)		; $4fd5
	and $0e			; $4fd8
	ret nz			; $4fda

	; Return if text is on screen
	call retIfTextIsActive		; $4fdb

	; Return if link is dying or something else
	ld a,(wLinkDeathTrigger)		; $4fde
	ld b,a			; $4fe1
	ld a,(wLinkPlayingInstrument)		; $4fe2
	or b			; $4fe5
	ret nz			; $4fe6

	ld a,(wKeysJustPressed)		; $4fe7
	and BTN_START | BTN_SELECT	; $4fea
	jr z,+			; $4fec

	; Return if you haven't seen the opening cutscene yet
	ld a,(wGlobalFlags+GLOBALFLAG_INTRO_DONE/8)
	bit GLOBALFLAG_INTRO_DONE&7,a
	ld a, SND_ERROR
	jp z,playSound		; $4ff5
+
	ld a,(wMenuDisabled)		; $4ff8
	ld b,a			; $4ffb
	ld a,(wDisableLinkCollisionsAndMenu)		; $4ffc
	or b			; $4fff
	ret nz			; $5000

	call _playHeartBeepAtInterval		; $5001
	ld a,(wKeysJustPressed)		; $5004
	and BTN_START | BTN_SELECT	; $5007
	ret z			; $5009

	ld c,$03		; $500a
	cp BTN_START | BTN_SELECT	; $500c
	jr z,+			; $500e

	dec c			; $5010
	bit BTN_BIT_SELECT,a	; $5011
	jr nz,+			; $5013
	dec c			; $5015
+
	jp _openMenu		; $5016

@updateMenu:
	ld a,$ff		; $5019
	ld (wc4b6),a		; $501b
	ld a,(wMenuLoadState)		; $501e
	rst_jumpTable			; $5021
.dw _menuStateFadeIntoMenu
.dw _menuSpecificCode
.dw _menuStateFadeOutOfMenu
.dw _menuStateFadeIntoGame

;;
; @addr{502a}
_menuSpecificCode:
	ld a,(wOpenedMenuType)		; $502a
	rst_jumpTable			; $502d
.dw runSaveAndQuitMenu
.dw _runInventoryMenu
.dw _runMapMenu
.dw runSaveAndQuitMenu
.dw _runRingMenu
.dw _runGaleSeedMenu
.dw _runSecretEntryMenu
.dw _runKidNameEntryMenu
.dw _runGameLinkMenu
.dw _runFakeReset
.dw _runSecretListMenu

;;
; Game is fading out just after initial start/select press
; @addr{5044}
_menuStateFadeIntoMenu:
	ld a,(wOpenedMenuType)		; $5044
	cp $03			; $5047
	jr nc,+			; $5049

	ld a,(wKeysPressed)		; $504b
	and BTN_START | BTN_SELECT	; $504e
	cp BTN_START | BTN_SELECT	; $5050
	jr nz,+			; $5052

	ld a,$03		; $5054
	ld (wOpenedMenuType),a		; $5056
+
	ld a,(wPaletteThread_mode)		; $5059
	or a			; $505c
	ret nz			; $505d

	call @openMenu		; $505e
	ld hl,wMenuLoadState		; $5061
	inc (hl)		; $5064
	jp _menuSpecificCode		; $5065

;;
; Loads menu graphics and stuff
; @addr{5068}
@openMenu:
	ld a,(wOpenedMenuType)		; $5068
	cp $03			; $506b
	ld a,SND_OPENMENU	; $506d
	call nz,playSound		; $506f
	ld a,$02		; $5072
	call setMusicVolume		; $5074
;;
; @addr{5077}
_saveGraphicsOnEnterMenu:
	ldh a,(<hCameraY)	; $5077
	ld hl,$cbe1		; $5079
	ldi (hl),a		; $507c
	ldh a,(<hCameraX)	; $507d
	ld (hl),a		; $507f
	push de			; $5080
	ld hl,wGfxRegs1		; $5081
	ld de,wGfxRegs4		; $5084
	ld b,GfxRegsStruct.size*2
	call copyMemory		; $5089
	call disableLcd		; $508c
	call _copyW2AreaBgPalettesToW4PaletteData		; $508f
	ld a,:w4SavedOam	; $5092
	ld ($ff00+R_SVBK),a	; $5094
	ld hl,wOam		; $5096
	ld de,w4SavedOam	; $5099
	ld b,$a0		; $509c
	call copyMemory		; $509e
	ld a,$01		; $50a1
	ld ($ff00+R_VBK),a	; $50a3
	ld hl,$8600		; $50a5
	ld bc,$0180		; $50a8
	ld de,w4SavedVramTiles	; $50ab
	call copyMemoryBc		; $50ae

	ld hl,wMenuUnionStart		; $50b1
	ld b,wMenuUnionEnd - wMenuUnionStart		; $50b4
	call clearMemory		; $50b6

	ld a,$ff		; $50b9
	ld (wc4b6),a		; $50bb
	pop de			; $50be
	jp clearOam		; $50bf

;;
; @addr{50c2}
_menuStateFadeOutOfMenu:
	ld a,(wPaletteThread_mode)		; $50c2
	or a			; $50c5
	ret nz			; $50c6

	call _reloadGraphicsOnExitMenu		; $50c7
	ld hl,wMenuLoadState		; $50ca
	inc (hl)		; $50cd
	jp updateParentItemButtonAssignment		; $50ce

;;
; Called when exiting menus
; @addr{50d1}
_reloadGraphicsOnExitMenu:
	ld hl,$cbe1		; $50d1
	ldi a,(hl)		; $50d4
	ldh (<hCameraY),a	; $50d5
	ld a,(hl)		; $50d7
	ldh (<hCameraX),a	; $50d8
	push de			; $50da
	call disableLcd		; $50db
	ld a,:w4SavedOam	; $50de
	ld ($ff00+R_SVBK),a	; $50e0
	ld de,$8601		; $50e2
	ldbc $17, :w4SavedVramTiles	; $50e5
	ld hl,w4SavedVramTiles		; $50e8
	call queueDmaTransfer		; $50eb
	ld hl,w4SavedOam	; $50ee
	ld de,wOam		; $50f1
	ld b,$a0		; $50f4
	call copyMemory		; $50f6
	call _copyW4PaletteDataToW2AreaBgPalettes		; $50f9
	ld hl,wGfxRegs4		; $50fc
	ld de,wGfxRegs1		; $50ff
	ld b,GfxRegsStruct.size*2	; $5102
	call copyMemory		; $5104
	call _loadCommonGraphics		; $5107
	call reloadObjectGfx		; $510a
	call loadAreaData		; $510d
	call loadAreaGraphics		; $5110
	call reloadTileMap		; $5113
	call fastFadeinFromWhiteToRoom		; $5116
	ld a,(wExtraBgPaletteHeader)		; $5119
	or a			; $511c
	call nz,loadPaletteHeader		; $511d

.ifdef ROM_SEASONS
	; Checking for room $07ff?
	ld a,(wActiveGroup)
	cp $07
	jr nz,++
	ld a,(wActiveRoom)
	inc a
	jr nz,++
	pop de
	jp seasonsFunc_332f
.endif
++

	ld a,(wGfxRegs1.LCDC)		; $5120
	ld (wGfxRegsFinal.LCDC),a		; $5123
	ld ($ff00+R_LCDC),a	; $5126
	pop de			; $5128

.ifdef ROM_AGES
	jpab bank1.checkInitUnderwaterWaves		; $5129
.else
	ret
.endif

;;
; @addr{5131}
_menuStateFadeIntoGame:
	ld a,(wPaletteThread_mode)		; $5131
	or a			; $5134
	ret nz			; $5135

	xor a			; $5136
	ld (wc4b6),a		; $5137
	ld (wOpenedMenuType),a		; $513a
	ld a,$03		; $513d
	jp setMusicVolume		; $513f

;;
; @addr{5142}
_playHeartBeepAtInterval:
	ld a,(w1Link.id)		; $5142
	dec a			; $5145
	ret z			; $5146

	ld a,(wFrameCounter)		; $5147
	and $3f			; $514a
	ret nz			; $514c

	ld hl,wLinkHealth		; $514d
	ldi a,(hl)		; $5150
	dec a			; $5151
	add a			; $5152
	ret c			; $5153
	add a			; $5154
	cp (hl)			; $5155
	ret nc			; $5156

	ld a,SND_HEARTBEEP	; $5157
	jp playSound		; $5159

;;
; Load graphics for the status bar and various sprites that appear everywhere
; @addr{515c}
_loadCommonGraphics:
	call disableLcd		; $515c
	ld a,GFXH_HUD		; $515f
	call loadGfxHeader		; $5161
	ld a,GFXH_COMMON_SPRITES		; $5164
	call loadGfxHeader		; $5166

.ifdef ROM_AGES
	xor a			; $5169
	ld (wcbe8),a		; $516a
	call _updateStatusBar		; $516d

	; Check if in an underwater group
	ld a,(wActiveGroup)		; $5170
	sub $02			; $5173
	cp $02			; $5175
	jr nc,+			; $5177

	; Check if the area is actually underwater
	ld a,(wAreaFlags)		; $5179
	and AREAFLAG_UNDERWATER	; $517c
	jr z,+			; $517e

	; Load a graphic for the seaweed being cut over the graphic for a bush
	; being cut
	ld a,GFXH_SEAWEED_CUT		; $5180
	call loadGfxHeader		; $5182
	ld a,PALH_SEAWEED_CUT		; $5185
	call loadPaletteHeader		; $5187
+
	jp checkReloadStatusBarGraphics		; $518a

.else; ROM_SEASONS

; Update key, ore chunk, or small key graphic in hud

	ld a,(wAreaFlags)
	ld b,a
	xor a
	ld c,<wNumRupees
	bit AREAFLAG_BIT_DUNGEON,b
	jr nz,@loadMoneyGraphic

	bit AREAFLAG_BIT_SUBROSIA,b
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
	call _updateStatusBar
	jp checkReloadStatusBarGraphics


.endif

;;
; @addr{518d}
_updateStatusBar:
	ld a,(wDontUpdateStatusBar)		; $518d
	or a			; $5190
	ret nz			; $5191

	ld a,$04		; $5192
	ld ($ff00+R_SVBK),a	; $5194
	call loadStatusBarMap		; $5196

	; Check whether A and B items need refresh
	ld a,(wStatusBarNeedsRefresh)		; $5199
	bit 0,a			; $519c
	jr z,+			; $519e

	call _loadEquippedItemGfx		; $51a0
	call _drawItemTilesOnStatusBar		; $51a3
	jr ++			; $51a6
+
	; Check whether item levels / counts need refresh
	bit 1,a			; $51a8
	call nz,_drawItemTilesOnStatusBar		; $51aa
++
	; Update displayed rupee count

.ifdef ROM_SEASONS
	ld a,(wDisplayedMoneyAddress)
	ld l,a
	ld h,>wc600Block
.else; ROM_AGES
	ld hl,wNumRupees		; $51ad
.endif
	ldi a,(hl)		; $51b0
	ld b,(hl)		; $51b1
	ld c,a			; $51b2
	ld hl,wDisplayedRupees		; $51b3
	ldi a,(hl)		; $51b6
	ld h,(hl)		; $51b7
	ld l,a			; $51b8
	call compareHlToBc		; $51b9
	jr z,@updateRupeeDisplay; $51bc

	ld hl,wStatusBarNeedsRefresh		; $51be
	set 3,(hl)		; $51c1
	ld bc,$0001		; $51c3
	ld l,<wDisplayedRupees	; $51c6
	dec a			; $51c8
	jr z,+			; $51c9

	call addDecimalToHlRef		; $51cb
	jr ++			; $51ce
+
	call subDecimalFromHlRef		; $51d0
++
	ld a,SND_RUPEE		; $51d3
	call playSound		; $51d5

@updateRupeeDisplay:
	ld a,(wStatusBarNeedsRefresh)		; $51d8
	bit 3,a			; $51db
	jr z,+			; $51dd

	ld hl,w4StatusBarTileMap+$2c	; $51df
	call _correctAddressForExtraHeart		; $51e2
	ld c,$10		; $51e5
	ld a,(wDisplayedRupees)		; $51e7
	ld b,a			; $51ea
	and $0f			; $51eb
	add c			; $51ed
	ldd (hl),a		; $51ee
	ld a,b			; $51ef
	swap a			; $51f0
	and $0f			; $51f2
	add c			; $51f4
	ldd (hl),a		; $51f5
	ld a,(wDisplayedRupees+1)		; $51f6
	and $0f			; $51f9
	add c			; $51fb
	ldd (hl),a		; $51fc
+
	; Update displayed heart count
	ld hl,wDisplayedHearts		; $51fd
	ld a,(wLinkHealth)		; $5200
	cp (hl)			; $5203
	jr z,@updateHeartDisplay	; $5204
	jr c,+			; $5206

	ld a,(wFrameCounter)		; $5208
	and $03			; $520b
	jr nz,@updateHeartDisplay	; $520d

	inc (hl)		; $520f
	ld a,(hl)		; $5210
	and $03			; $5211
	ld a,SND_GAINHEART	; $5213
	call z,playSound		; $5215
	jr ++			; $5218
+
	dec (hl)		; $521a
++
	ld hl,wStatusBarNeedsRefresh		; $521b
	set 2,(hl)		; $521e

@updateHeartDisplay:
	ld a,(wStatusBarNeedsRefresh)		; $5220
	bit 2,a			; $5223
	call nz,_inGameDrawHeartDisplay		; $5225
	ld hl,w4StatusBarTileMap+$0a	; $5228
	call _correctAddressForExtraHeart		; $522b
	ld (hl),$09		; $522e

	ld a,(wAreaFlags)		; $5230

.ifdef ROM_AGES
	bit AREAFLAG_BIT_10,a	; $5233
	jr nz,+			; $5235
.endif

	bit AREAFLAG_BIT_DUNGEON,a	; $5237
	jr z,+			; $5239

.ifdef ROM_AGES
	; Seasons replaces the rupee gfx with the key gfx if necessary, while Ages has
	; both the rupee and the key gfx loaded at all times (so it just changes which
	; tile is shown here).
	inc (hl)		; $523b
.endif

	; "X" symbol next to key icon
	inc l			; $523c
	ld (hl),$1b		; $523d

	ld a,(wStatusBarNeedsRefresh)		; $523f
	bit 4,a			; $5242
	jr z,+			; $5244

	; Update number of keys
	inc l			; $5246
	ld a,(wDungeonIndex)		; $5247
	ld bc,wDungeonSmallKeys		; $524a
	call addAToBc		; $524d
	ld a,(bc)		; $5250
	add $10			; $5251
	ld (hl),a		; $5253
+
	xor a			; $5254
	ld ($ff00+R_SVBK),a	; $5255
	ld a,(wcbe8)		; $5257
	bit 7,a			; $525a
	jr nz,@biggoronSword	; $525c

	; Update item sprites
	ld e,$10		; $525e
	ld bc,$1038		; $5260
	rrca			; $5263
	jr nc,+			; $5264
	ld c,$30		; $5266
+

.ifdef ROM_AGES
	; If harp is equipped, adjust sprite X-position 8 pixels right
	ld hl,wInventoryB		; $5268
	ld a,ITEMID_HARP		; $526b
	cp (hl)			; $526d
	jr nz,+			; $526e
	set 3,e			; $5270
+
	inc l			; $5272
	cp (hl)			; $5273
	jr nz,+			; $5274

	ld a,c			; $5276
	add $08			; $5277
	ld c,a			; $5279
+
.endif

	ld hl,wOam		; $527a
	ld a,b			; $527d
	ldi (hl),a		; $527e
	ld a,e			; $527f
	ldi (hl),a		; $5280
	ld a,$78		; $5281
	ldi (hl),a		; $5283
	ld a,(wBItemSpriteAttribute1)		; $5284
	ldi (hl),a		; $5287

	ld a,b			; $5288
	ldi (hl),a		; $5289
	ld a,(wBItemSpriteXOffset)		; $528a
	add e			; $528d
	ldi (hl),a		; $528e
	ld a,$7a		; $528f
	ldi (hl),a		; $5291
	ld a,(wBItemSpriteAttribute2)		; $5292
	ldi (hl),a		; $5295
	ld a,b			; $5296

	ldi (hl),a		; $5297
	ld a,c			; $5298
	ldi (hl),a		; $5299
	ld a,$7c		; $529a
	ldi (hl),a		; $529c
	ld a,(wAItemSpriteAttribute1)		; $529d
	ldi (hl),a		; $52a0

	ld a,b			; $52a1
	ldi (hl),a		; $52a2
	ld a,(wAItemSpriteXOffset)		; $52a3
	add c			; $52a6
	ldi (hl),a		; $52a7
	ld a,$7e		; $52a8
	ldi (hl),a		; $52aa
	ld a,(wAItemSpriteAttribute2)		; $52ab
	ldi (hl),a		; $52ae
	ret			; $52af

@biggoronSword:
	ld hl,wOam		; $52b0
	ld de,@oamData		; $52b3
	ld b,$10		; $52b6
	jp copyMemoryReverse		; $52b8

; @addr{52bb}
@oamData:
	.db $10 $18 $78 $0b ; B Item
	.db $10 $20 $7a $0b
	.db $10 $28 $7c $0b ; A Item
	.db $10 $30 $7e $0b

;;
; Subtracts hl by 1 if you have 15+ hearts - status bar needs to be compressed
; slightly
; @addr{52cb}
_correctAddressForExtraHeart:
	ld a,(wcbe8)		; $52cb
	rrca			; $52ce
	ret nc			; $52cf
	dec l			; $52d0
	ret			; $52d1

;;
; Reloads status bar map, and loads the graphics for the sprites for the A/B button items.
;
; The OAM data for the sprites is probably always loaded, so this function doesn't need to
; handle that?
;
; When combined with _drawItemTilesOnStatusBar, the A/B items get fully drawn.
;
; @addr{52d2}
_loadEquippedItemGfx:
	call loadStatusBarMap		; $52d2

	; Return if biggoron sword is equipped
	ld a,(wcbe8)		; $52d5
	rlca			; $52d8
	ret c			; $52d9

	ld a,(wInventoryB)		; $52da
	ld de,wBItemTreasure		; $52dd
	call _loadEquippedItemSpriteData		; $52e0
	ld e,<w4ItemIconGfx+$00		; $52e3
	call c,_loadItemIconGfx		; $52e5

	ld a,(wInventoryA)		; $52e8
	ld de,wAItemTreasure		; $52eb
	call _loadEquippedItemSpriteData		; $52ee
	ld e,<w4ItemIconGfx+$40		; $52f1
	call c,_loadItemIconGfx		; $52f3

;;
; @addr{52f6}
_func_02_52f6:
	ld bc,$0020		; $52f6
	ld hl,w4StatusBarAttributeMap+$02	; $52f9
	ld a,(wBItemSpriteXOffset)		; $52fc
	bit 7,a			; $52ff
	call z,@func1		; $5301

	ld l,<w4StatusBarAttributeMap+$07	; $5304
	ld a,(wcbe8)		; $5306
	rrca			; $5309
	jr nc,+			; $530a
	dec l			; $530c
+
	ld a,(wAItemSpriteXOffset)		; $530d
	bit 7,a			; $5310
	ret nz			; $5312
;;
; @addr{5313}
@func1:
	or a			; $5313
	call nz,@func2		; $5314
	dec l			; $5317
;;
; @addr{5318}
@func2:
	ld d,l			; $5318
	ld (hl),b		; $5319
	add hl,bc		; $531a
	ld (hl),b		; $531b
	ld l,d			; $531c
	ret			; $531d

;;
; Loads the values for the "wAItem*" or "wBItem*" variables (5 bytes total) and returns in
; 'bc' what tile indices the item uses.
;
; @param	a	Treasure index
; @param	de	Where to write the item graphics data (ie. wAItemTreasure)
; @param[out]	bc	Left/right sprite indices
; @param[out]	cflag	Set if the data was loaded correctly (there is something to draw)
; @addr{531e}
_loadEquippedItemSpriteData:
	call loadTreasureDisplayData		; $531e

	; [wItemTreasure] = the treasure ID to use for level/quantity data
	ldi a,(hl)		; $5321
	ld (de),a		; $5322

	; Read the left sprite + attribute bytes
	ldi a,(hl)		; $5323
	or a			; $5324
	jr z,@clearItem		; $5325

	; Put left sprite index in 'b'
	inc e			; $5327
	ld b,a			; $5328

	; Comparion differs between ages/seasons. See the respective games'
	; "gfx_item_icons_1.bin". This comparison changes the palette used for the seed
	; satchel, seed shooter, slingshot, and hyper slingshot.
.ifdef ROM_AGES
	cp $84			; $5329
.else; ROM_SEASONS
	cp $86
.endif
	ldi a,(hl)		; $532b
	jr nc,+			; $532c
	sub $03			; $532e
	or $01			; $5330
+
	; Store into [wItemSpriteAttribtue1]
	set 3,a			; $5332
	ld (de),a		; $5334

	; Read the right sprite + attribute bytes
	inc e			; $5335
	ldi a,(hl)		; $5336

	; Put right sprite index in 'c'
	or a			; $5337
	ld c,a			; $5338
	jr z,+			; $5339

	scf			; $533b
	ld a,(hl)		; $533c
+
	inc l			; $533d

	; Store into [wItemSpriteAttribute2]
	set 3,a			; $533e
	ld (de),a		; $5340

	; Calculate [wItemSpriteXOffset]
	inc e			; $5341
	ld a,$08		; $5342
	jr c,+			; $5344
	xor a			; $5346
+
	ld (de),a		; $5347

	; Copy value for [wItemDisplayMode]
	inc e			; $5348
	ldi a,(hl)		; $5349
	ld (de),a		; $534a

	scf			; $534b
	ret			; $534c

@clearItem:
	ld l,e			; $534d
	ld h,d			; $534e
	ld b,$05		; $534f
	ld a,$ff		; $5351
-
	ldi (hl),a		; $5353
	dec b			; $5354
	jr nz,-			; $5355
	ret			; $5357

;;
; Redraw the tiles in w4StatusBar for the current equipped items.
; (Only deals with the background layer, ie. item count; not the sprites themselves)
;
; Note: returns with wram bank 4 loaded.
;
; @addr{5358}
_drawItemTilesOnStatusBar:
	; Return if biggoron's sword equipped
	ld a,(wcbe8)		; $5358
	bit 7,a			; $535b
	ret nz			; $535d

	ld a,$04		; $535e
	ld ($ff00+R_SVBK),a	; $5360
	ld a,(wInventoryB)		; $5362
	ld de,wBItemTreasure		; $5365
	call _loadEquippedItemSpriteData		; $5368
	ld a,(wInventoryA)		; $536b
	ld de,wAItemTreasure		; $536e
	call _loadEquippedItemSpriteData		; $5371
	call _func_02_52f6		; $5374

	; Draw A button item
	; Need to check if the status bar is squished to the left
	ld a,(wcbe8)		; $5377
	rrca			; $537a
	ld de,w4StatusBarTileMap+$27		; $537b
	jr nc,+			; $537e
	dec e			; $5380
+
	ld a,(wAItemTreasure)		; $5381
	ld b,a			; $5384
	ld a,(wAItemDisplayMode)		; $5385
	call @drawItem		; $5388

	; Draw B button item
	ld de,w4StatusBarTileMap+$22		; $538b
	ld a,(wBItemTreasure)		; $538e
	ld b,a			; $5391
	ld a,(wBItemDisplayMode)		; $5392

;;
; @param	a	Item display mode
; @param	b	Treasure index for the "amount" to display
; @param	de	Address in w4StatusBarTileMap to draw to
; @addr{5395}
@drawItem:
	ld c,a			; $5395
	rlca			; $5396
	ret c			; $5397

	; Get the number to display in 'b' (if applicable)
	ld a,b			; $5398
	call checkTreasureObtained		; $5399
	ld b,a			; $539c

	ld a,c			; $539d
	ld c,$80		; $539e

;;
; Draws the "extra tiles" for a treasure (ie. numbers).
;
; @param	a	The item's "display mode" (whether to display a number beside it)
; @param	b	The number to draw (if applicable)
; @param	c	$80 if drawing on A/B buttons, $07 if on inventory
; @param	de	Address to draw to (should be a tilemap of some kind)
; @addr{53a0}
_drawTreasureExtraTiles:
	bit 7,a			; $53a0
	ret nz			; $53a2

	dec a			; $53a3
	jr z,@val01		; $53a4
	dec a			; $53a6
	jr z,@val02		; $53a7
	dec a			; $53a9
	jr z,@val03		; $53aa
	dec a			; $53ac
	jr z,@val04		; $53ad
	jr @val00		; $53af

; Display item quantity with "x" symbol (ie. slates in ages d8)
@val04:
	; Digit
	inc e			; $53b1
	ld a,b			; $53b2
	and $0f			; $53b3
	add $10			; $53b5
	ld (de),a		; $53b7

	; Attributes
	set 2,d			; $53b8
	ld a,c			; $53ba
	ld (de),a		; $53bb
	dec e			; $53bc
	ld (de),a		; $53bd

	; 'x' symbol
	res 2,d			; $53be
	ld a,$1b		; $53c0
	ld (de),a		; $53c2
	ret			; $53c3

; Display item quantity (ie. bombs, seed satchel)
@val01:
	; 1's digit
	inc e			; $53c4
	ld a,b			; $53c5
	and $0f			; $53c6
	add $10			; $53c8
	ld (de),a		; $53ca

	; Attributes
	set 2,d			; $53cb
	ld a,c			; $53cd
	ld (de),a		; $53ce
	dec e			; $53cf
	ld (de),a		; $53d0

	; 10's digit
	res 2,d			; $53d1
	ld a,b			; $53d3
	swap a			; $53d4
	and $0f			; $53d6
	add $10			; $53d8
	ld (de),a		; $53da
	ret			; $53db

; Display the item's level
@val00:
	; Digit
	inc e			; $53dc
	ld a,b			; $53dd
	and $0f			; $53de
	add $10			; $53e0

	; Attributes
	ld (de),a		; $53e2
	set 2,d			; $53e3
	ld a,c			; $53e5
	ld (de),a		; $53e6
	dec e			; $53e7
	ld (de),a		; $53e8

	; 'L-' symbol
	res 2,d			; $53e9
	ld a,$1a		; $53eb
	ld (de),a		; $53ed
	ret			; $53ee

.ifdef ROM_AGES

; Stub
@val03:
	ret

; Display the harp?
@val02:
	ld h,d			; $53f0
	ld l,e			; $53f1

	; Check whether drawing on inventory or on A/B buttons
	ld a,c			; $53f2
	cp $07			; $53f3
	jr z,@@drawOnInventory	; $53f5

	; Drawing on A/B buttons

	ld a,$1f		; $53f7
	ldd (hl),a		; $53f9
	ld (hl),$1d		; $53fa
	set 2,h			; $53fc
	ld a,$80		; $53fe
	ldi (hl),a		; $5400
	ldi (hl),a		; $5401
	ld (hl),$00		; $5402
	ld bc,$ffe0		; $5404
	add hl,bc		; $5407
	ld (hl),$00		; $5408
	dec l			; $540a
	ldd (hl),a		; $540b
	ld (hl),a		; $540c
	res 2,h			; $540d
	ld a,$1c		; $540f
	ldi (hl),a		; $5411
	ld (hl),$1e		; $5412
	ret			; $5414

@@drawOnInventory:
	ld a,$1f		; $5415
	ldd (hl),a		; $5417
	ld (hl),$1d		; $5418
	set 2,h			; $541a
	ld a,$84		; $541c
	ldi (hl),a		; $541e
	ldd (hl),a		; $541f
	ld bc,$ffe0		; $5420
	add hl,bc		; $5423
	ldi (hl),a		; $5424
	ldd (hl),a		; $5425
	res 2,h			; $5426
	ld a,$1c		; $5428
	ldi (hl),a		; $542a
	ld (hl),$1e		; $542b
	ret			; $542d

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
; @addr{542e}
@drawTile:
	ld (hl),b		; $542e
	set 2,h			; $542f
	ld (hl),c		; $5431
	res 2,h			; $5432
	ret			; $5434

;;
; @param b Number of heart containers
; @param c Number of hearts
; @param hl Address of tile buffer to write to
; @addr{5435}
_fileSelectDrawHeartDisplay:
	ld a,$01		; $5435
	ldh (<hFF8B),a	; $5437
	ld a,b			; $5439
	jr _drawHeartDisplay	; $543a

;;
; @addr{543c}
_inGameDrawHeartDisplay:
	ld hl,w4StatusBarTileMap+$0d		; $543c
	xor a			; $543f
	ldh (<hFF8B),a	; $5440
	ld a,(wDisplayedHearts)		; $5442
	ld c,a			; $5445
	ld a,(wLinkMaxHealth)		; $5446
;;
; @param a Number of heart containers (in quarters)
; @param c Number of hearts (in quarters)
; @param hl Tile buffer to write to
; @param hFF8B
; @addr{5449}
_drawHeartDisplay:
	; e = hearts per row (7 normally, 8 if you have 15+ hearts)
	ld e,$07		; $5449
	cp 14*4+1		; $544b
	jr c,+			; $544d
	inc e			; $544f
+
	srl a			; $5450
	srl a			; $5452
	ld b,a			; $5454
	ld a,c			; $5455
	and $03			; $5456
	ld d,a			; $5458
	ld a,c			; $5459
	srl a			; $545a
	srl a			; $545c
	ld c,a			; $545e
	push bc			; $545f
	cp e			; $5460
	jr c,+			; $5461
	ld c,e			; $5463
+
	ld a,b			; $5464
	cp e			; $5465
	jr c,+			; $5466
	ld a,e			; $5468
+
	sub c			; $5469
	ld b,a			; $546a
	ldh a,(<hFF8B)	; $546b
	or e			; $546d
	rrca			; $546e
	jr c,+			; $546f
	dec l			; $5471
+
	push hl			; $5472
	call @drawHeartDisplayRow	; $5473
	pop hl			; $5476

	; Set up for the second row
	ld a,$20		; $5477
	rst_addAToHl			; $5479
	pop bc			; $547a
	ld a,c			; $547b
	sub e			; $547c
	jr nc,+			; $547d
	xor a			; $547f
+
	ld c,a			; $5480
	ld a,b			; $5481
	sub e			; $5482
	sub c			; $5483
	bit 7,a			; $5484
	jr z,+			; $5486
	xor a			; $5488
+
	ld b,a			; $5489

;;
; @param b Number of unfilled hearts (including partially filled one)
; @param c Number of filled hearts (not quarters)
; @param d Number of quarters in partially-filled heart
; @param hl Tile buffer to write to
; @addr{548a}
@drawHeartDisplayRow:
	ld a,c			; $548a
	or a			; $548b
	jr z,@partiallyFilledHeart	; $548c

@filledHearts:
	ld a,$0f		; $548e
-
	ldi (hl),a		; $5490
	dec c			; $5491
	jr nz,-			; $5492

@partiallyFilledHeart:
	ld a,b			; $5494
	or a			; $5495
	jr z,@fillBlankSpace	; $5496

	ld a,d			; $5498
	or a			; $5499
	jr z,@unfilledHearts	; $549a

	add $0b			; $549c
	ldi (hl),a		; $549e
	ld d,$00		; $549f
	dec b			; $54a1

@unfilledHearts:
	ld a,b			; $54a2
	or a			; $54a3
	jr z,@fillBlankSpace	; $54a4

	ld a,$0b		; $54a6
-
	ldi (hl),a		; $54a8
	dec b			; $54a9
	jr nz,-			; $54aa

@fillBlankSpace:
	ldh a,(<hFF8B)	; $54ac
	or a			; $54ae
	ret nz			; $54af

	ld c,$08		; $54b0
-
	ldi (hl),a		; $54b2
	dec c			; $54b3
	jr nz,-			; $54b4
	ret			; $54b6

;;
; Loads two tiles for an equipped item's graphics ($40 bytes loaded total).
;
; @param	b	Left sprite index (tile index for gfx_item_icons)
; @param	c	Right sprite index (tile index for gfx_item_icons)
; @param	e	Low byte of where to load graphics (should be w4ItemIconGfx+XX)
; @addr{54b7}
_loadItemIconGfx:
	ld d,>w4ItemIconGfx		; $54b7
	push bc			; $54b9
	ld a,b			; $54ba
	call @func		; $54bb
	pop bc			; $54be
	ld a,c			; $54bf
;;
; @param	a	Tile index
; @param	de	Where to load the data
; @addr{54c0}
@func:
	or a			; $54c0
	jr z,@clear		; $54c1

.ifdef ROM_AGES
	; Special behaviour for harp song icons: add 2 to the index so that the "smaller
	; version" of the icon is drawn. (gfx_item_icons_3.bin has two versions of each
	; song)
	cp $a3			; $54c3
	jr c,+			; $54c5
	add $02			; $54c7
+
.endif

	add a			; $54c9
	call multiplyABy16		; $54ca
	ld hl,gfx_item_icons_1
	add hl,bc		; $54d0
	ld b,:gfx_item_icons_1
	jp copy20BytesFromBank		; $54d3
@clear:
	ld h,d			; $54d6
	ld l,e			; $54d7
	ld b,$20		; $54d8
	ld a,$ff		; $54da
	jp fillMemory		; $54dc

;;
; @addr{54df}
loadStatusBarMap:
	ld c,$10		; $54df
	ld a,(wLinkMaxHealth)		; $54e1
	cp 14*4+1		; $54e4
	jr c,+			; $54e6
	inc c			; $54e8
+
	; Check if biggoron's sword equipped
	ld a,(wInventoryB)		; $54e9
	cp ITEMID_BIGGORON_SWORD	; $54ec
	jr nz,+			; $54ee
	set 7,c			; $54f0
+
	ld hl,wStatusBarNeedsRefresh		; $54f2
	ldd a,(hl)		; $54f5
	rrca			; $54f6
	ld a,c			; $54f7
	jr c,+			; $54f8

	cp (hl)			; $54fa
	ret z			; $54fb
+
	ldi (hl),a		; $54fc

	; [wStatusBarNeedsRefresh] = $ff; should trigger complete redrawing, including
	; reloading item graphics?
	ld (hl),$ff		; $54fd

	ld hl,wBItemTreasure		; $54ff
	ld b,$0a		; $5502
	call clearMemory		; $5504
	bit 7,c			; $5507
	ld a,GFXH_23		; $5509
	jr nz,+			; $550b

	; GFXH_21 is for <14 hearts, GFXH_22 for >=14 hearts
	ld a,c			; $550d
	and $01			; $550e
	add GFXH_21			; $5510
+
	jp loadGfxHeader		; $5512

;;
; @addr{5515}
_runInventoryMenu:
	call clearOam		; $5515
	ld a,$10		; $5518
	ldh (<hOamTail),a	; $551a
	ld a,$04		; $551c
	ld ($ff00+R_SVBK),a	; $551e
	call @inventoryMenuStates		; $5520
	call _inventoryMenuDrawSprites		; $5523
	xor a			; $5526
	ld ($ff00+R_SVBK),a	; $5527
	jp updateStatusBar		; $5529

;;
; @addr{552c}
@inventoryMenuStates:
	ld a,(wMenuActiveState)		; $552c
	rst_jumpTable			; $552f
	.dw _inventoryMenuState0
	.dw _inventoryMenuState1
	.dw _inventoryMenuState2
	.dw _inventoryMenuState3

;;
; @param a
; @addr{5538}
_showItemText1:
	ld hl,w4SubscreenTextIndices	; $5538
	rst_addAToHl			; $553b
	ld a,(hl)		; $553c
;;
; @param	a	Text index to show.
;			If bit 7 is set, it's a ring; use TX_03XX.
;			In this case, use TX_30c1 to combine the name (TX_3040+X) with the
;			description (TX_3080+X).
; @addr{553d}
_showItemText2:
	ld hl,wInventory.activeText		; $553d
	cp (hl)			; $5540
	ret z			; $5541

	ld (hl),a		; $5542
	ld c,a			; $5543
	ld b,>TX_0900		; $5544
	bit 7,c			; $5546
	jr z,+			; $5548

	ld b,>TX_3000		; $554a
	ld c,$c0		; $554c
	and $3f			; $554e
	ld l,a			; $5550
	add <TX_3040		; $5551
	bit 6,c ; Bit 6 is always set?
	ld c,a			; $5555
	jr z,+			; $5556

	ld (wTextSubstitutions+2),a		; $5558
	ld a,l			; $555b
	add <TX_3080		; $555c
	ld (wTextSubstitutions+3),a		; $555e
	ld c,<TX_30c1		; $5561
+
	jp showTextOnInventoryMenu		; $5563

;;
; Initialization
; @addr{5566}
_inventoryMenuState0:
	ld hl,wInventorySubmenu2CursorPos		; $5566
	ld a,(hl)		; $5569
	cp $08			; $556a
	jr nc,+			; $556c
	ld (hl),$00		; $556e
+

.ifdef ROM_SEASONS
	xor a
	ld (wInventorySubmenu),a
	ld (wInventory.cbba),a
	dec a
	ld (wInventory.activeText),a
	call _checkWhetherToDisplaySeasonInSubscreen
	jr z,+
	ld a,$01
+
	ld (wInventory.submenu2CursorPos2),a

.else; ROM_AGES
	xor a			; $5570
	ld (wInventorySubmenu),a		; $5571
	ld (wInventory.cbba),a		; $5574
	ld (wInventory.submenu2CursorPos2),a		; $5577
	dec a			; $557a
	ld (wInventory.activeText),a		; $557b
.endif

	call loadCommonGraphics		; $557e
	ld a,GFXH_08		; $5581
	call loadGfxHeader		; $5583
	ld a,UNCMP_GFXH_06	; $5586
	call loadUncompressedGfxHeader		; $5588
	ld a,PALH_0a		; $558b
	call loadPaletteHeader		; $558d
	callab bank3f.getNumUnappraisedRings		; $5590
	call _func_02_55b2		; $5598
	ld a,$01		; $559b
	ld (wMenuActiveState),a		; $559d
	call fastFadeinFromWhite		; $55a0
	ld a,$03		; $55a3
	jp loadGfxRegisterStateIndex		; $55a5

;;
; @addr{55a8}
_func_02_55a8:
	ld a,(wInventory.cbba)		; $55a8
	and $01			; $55ab
	add UNCMP_GFXH_04	; $55ad
	jp loadUncompressedGfxHeader		; $55af

;;
; Load graphics for subscreens?
; @addr{55b2}
_func_02_55b2:
	ld hl,w4SubscreenTextIndices	; $55b2
	ld b,$20		; $55b5
	call clearMemory		; $55b7
	xor a			; $55ba
	call _showItemText2		; $55bb
	ld hl,_func_02_55a8		; $55be
	push hl			; $55c1
	ld a,(wInventorySubmenu)		; $55c2
	rst_jumpTable			; $55c5
.dw @subScreen0
.dw @subScreen1
.dw @subScreen2

;;
; @addr{55cc}
@subScreen0:
	ld a,$ff		; $55cc
	ld (wStatusBarNeedsRefresh),a		; $55ce
	ld a,GFXH_09		; $55d1
	call loadGfxHeader		; $55d3
	jp _inventorySubscreen0_drawStoredItems		; $55d6

;;
; @addr{55d9}
@subScreen1:
	ld a,GFXH_0a		; $55d9
	call loadGfxHeader		; $55db
	jp _inventorySubscreen1_drawTreasures		; $55de
;;
; @addr{55e1}
@subScreen2:
	ld a,GFXH_0b		; $55e1
	call loadGfxHeader		; $55e3
	jp _inventorySubscreen2_drawTreasures		; $55e6

;;
; Main state, waits for inputs
; @addr{55e9}
_inventoryMenuState1:
	ld a,(wPaletteThread_mode)		; $55e9
	or a			; $55ec
	ret nz			; $55ed

	ld a,(wKeysJustPressed)		; $55ee
	bit BTN_BIT_START,a		; $55f1
	jp nz,_closeMenu		; $55f3

	bit BTN_BIT_SELECT,a	; $55f6
	ld a,$03		; $55f8
	jr nz,@func_02_5606	; $55fa

	ld a,(wInventorySubmenu)		; $55fc
	rst_jumpTable			; $55ff
.dw @subscreen0
.dw @subscreen1
.dw @subscreen2

;;
; @addr{5606}
@func_02_5606:
	ld hl,wMenuActiveState		; $5606
	ldi (hl),a		; $5609
	ld (hl),$00		; $560a
	ret			; $560c

;;
; Main item screen
; @addr{560d}
@subscreen0:
	ld a,(wKeysJustPressed)		; $560d
	ld c,a			; $5610
	ld a,<wInventoryB	; $5611
	bit BTN_BIT_B,c			; $5613
	jr nz,@aOrB		; $5615

	inc a			; $5617
	bit BTN_BIT_A,c			; $5618
	jr nz,@aOrB		; $561a

	call _inventorySubscreen0CheckDirectionButtons		; $561c
	ld a,(wInventorySubmenu0CursorPos)		; $561f
	ld hl,wInventoryStorage		; $5622
	rst_addAToHl			; $5625
	ld a,(hl)		; $5626
	call loadTreasureDisplayData		; $5627
	ld a,$06		; $562a
	rst_addAToHl			; $562c
	ld a,(hl)		; $562d
	call _showItemText2		; $562e
	jp _inventorySubscreen0_drawCursor		; $5631

@aOrB:
	ld (wTmpcbb6),a		; $5634
	ld a,(wInventorySubmenu0CursorPos)		; $5637
	ld hl,wInventoryStorage		; $563a
	rst_addAToHl			; $563d
	ld a,(hl)		; $563e
	ld (wInventory.selectedItem),a		; $563f

	; Satchel or shooter?
	ld c,$1f		; $5642
	cp ITEMID_SEED_SATCHEL		; $5644
	jr z,@hasSubmenu	; $5646

.ifdef ROM_AGES
	cp ITEMID_SHOOTER		; $5648
	jr z,@hasSubmenu	; $564a

	cp ITEMID_HARP		; $564c
	jr nz,@finalizeEquip	; $564e
	ld c,$e0		; $5650

.else; ROM_SEASONS
	cp ITEMID_SLINGSHOT
	jr nz,@finalizeEquip
.endif

@hasSubmenu:
	ld a,(wSeedsAndHarpSongsObtained)		; $5652
	and c			; $5655
	call getNumSetBits		; $5656
	ld (wInventory.cbb8),a		; $5659
	cp $02			; $565c
	ld a,$02		; $565e
	jp nc,@func_02_5606		; $5660

@finalizeEquip:
	call @equipItem		; $5663
	call _inventorySubscreen0_drawStoredItems		; $5666
	call _inventorySubscreen0_drawCursor		; $5669
	ld a,SND_SELECTITEM	; $566c
	call playSound		; $566e
	ld a,$01		; $5671
	call @func_02_5606		; $5673
	jp _func_02_55b2		; $5676

;;
; Swaps the item at the cursor with the item on a button.
; @param wInventorySubmenu0CursorPos Item to equip
; @param wTmpcbb6 Address of button to unequip
; @addr{5679}
@equipItem:
	ld d,>wInventoryStorage	; $5679
	ld h,d			; $567b
	ld a,(wTmpcbb6)		; $567c
	ld e,a			; $567f
	ld a,(wInventorySubmenu0CursorPos)		; $5680
	add <wInventoryStorage			; $5683
	ld l,a			; $5685
	ld b,ITEMID_BIGGORON_SWORD		; $5686
	ld a,(hl)		; $5688
	cp b			; $5689
	jr z,@@equipBiggoron	; $568a

	ld a,(de)		; $568c
	cp b			; $568d
	jr nz,@@swapItems	; $568e

@@unequipBiggoron:
	ld c,l			; $5690
	ld l,<wInventoryB		; $5691
	xor a			; $5693
	ldi (hl),a		; $5694
	ld (hl),a		; $5695
	ld l,c			; $5696
	ld a,b			; $5697
	ld (de),a		; $5698
@@swapItems:
	ld a,(de)		; $5699
	ld c,a			; $569a
	ld a,(hl)		; $569b
	ld (de),a		; $569c
	ld (hl),c		; $569d
	ret			; $569e

@@equipBiggoron:
	ld (hl),$00		; $569f
	call @@swapItems		; $56a1
	ld a,(wInventoryB)		; $56a4
	call @@putItemInFirstBlankSlot		; $56a7
	ld a,(wInventoryA)		; $56aa
	call @@putItemInFirstBlankSlot		; $56ad
	ld l,<wInventoryB	; $56b0
	ld (hl),b		; $56b2
	inc l			; $56b3
	ld (hl),b		; $56b4
	ret			; $56b5

;;
; @param a Item to put in a blank slot
; @addr{56b6}
@@putItemInFirstBlankSlot:
	or a			; $56b6
	ret z			; $56b7

	ld c,a			; $56b8
	ld l,<wInventoryStorage		; $56b9
-
	ldi a,(hl)		; $56bb
	or a			; $56bc
	jr nz,-			; $56bd

	dec l			; $56bf
	ld (hl),c		; $56c0
	ret			; $56c1

;;
; Main code for secondary item screen (rings, passive items, etc)
; @addr{56c2}
@subscreen1:
	ld a,(wKeysJustPressed)		; $56c2
	bit BTN_BIT_A,a			; $56c5
	jr nz,+			; $56c7

	call _inventorySubmenu1CheckDirectionButtons		; $56c9
	jr ++			; $56cc
+
	call @checkEquipRing		; $56ce
++
	call _inventorySubmenu1_drawCursor		; $56d1
	ld a,(wInventorySubmenu1CursorPos)		; $56d4
	call _showItemText1		; $56d7
	jp _drawEquippedSpriteForActiveRing		; $56da

;;
; Pressed A on subscreen 1; check whether to equip a ring
;
; @addr{56dd}
@checkEquipRing:
	ld a,(wInventorySubmenu1CursorPos)		; $56dd
	sub $10			; $56e0
	ret c			; $56e2

.ifdef ROM_SEASONS
	; Can't equip rings while boxing
	ld b,a
	ld a,(wInBoxingMatch)
	or a
	ld a,SND_ERROR
	jp nz,playSound

	ld a,b
.endif

	ld hl,wActiveRing		; $56e3
	ld c,(hl)		; $56e6
	ld l,<wRingBoxContents		; $56e7
	rst_addAToHl			; $56e9
	ld a,(hl)		; $56ea
	cp c			; $56eb
	jr nz,+			; $56ec

	cp $ff			; $56ee
	ret z			; $56f0
	ld a,$ff		; $56f1
+
	ld (wActiveRing),a		; $56f3
	ld a,SND_SELECTITEM	; $56f6
	jp playSound		; $56f8

;;
; Main code for last item screen (essences, heart pieces, s&q option)
; @addr{56fb}
@subscreen2:
	ld a,(wKeysJustPressed)		; $56fb
	and BTN_A			; $56fe
	jr z,+			; $5700

	ld a,(wInventorySubmenu2CursorPos)		; $5702
	rlca			; $5705
	jr nc,+			; $5706

	ld a,(wInventory.submenu2CursorPos2)		; $5708
	cp $02			; $570b
	jr nz,+			; $570d

	; Save button selected
	inc a			; $570f
	ld (wOpenedMenuType),a		; $5710
	ld a,SND_SELECTITEM		; $5713
	call playSound		; $5715
	ld hl,wTmpcbb3		; $5718
	ld b,$10		; $571b
	jp clearMemory		; $571d

+
	call _inventorySubmenu2CheckDirectionButtons		; $5720
	ld a,(wInventorySubmenu2CursorPos)		; $5723
	bit 7,a			; $5726
	jr z,+			; $5728

	ld a,(wInventory.submenu2CursorPos2)		; $572a
	add $08			; $572d
+
	call _showItemText1		; $572f
	jp _inventorySubmenu2_drawCursor		; $5732

;;
; Opening a submenu (seeds, harp songs)
; @addr{5735}
_inventoryMenuState2:

.ifdef ROM_AGES
	call @subStates		; $5735
	jp _createBlankSpritesForItemSubmenu		; $5738
.endif

; ROM_SEASONS just starts directly at @subStates.

@subStates:
	ld a,(wSubmenuState)		; $573b
	rst_jumpTable			; $573e
.dw @subState0
.dw @subState1
.dw @subState2

;;
; @addr{5745}
@subState0:

.ifdef ROM_AGES
	ld hl,wSelectedHarpSong		; $5745
	ld d,(hl)		; $5748
	dec d			; $5749
	ld l,<wSatchelSelectedSeeds		; $574a
	call _cpInventorySelectedItemToHarp		; $574c
	jr z,++			; $574f

.else; ROM_SEASONS

	ld hl,wSatchelSelectedSeeds
	ld a,(wInventory.selectedItem)
.endif

	cp ITEMID_SEED_SATCHEL		; $5751
	jr z,+			; $5753
	inc l			; $5755
+
	ld e,(hl)		; $5756
	ld d,$00		; $5757
-
	ld a,d			; $5759
	call _getSeedTypeInventoryIndex		; $575a
	cp e			; $575d
	jr z,++			; $575e

	inc d			; $5760
	jr -			; $5761
++
	ld a,d			; $5763
	ld (wInventory.itemSubmenuIndex),a		; $5764
	ld a,(wInventory.cbb8)		; $5767
	ld hl,@itemSubmenuWidths-2		; $576a
	rst_addAToHl			; $576d
	ld a,(hl)		; $576e
	ld hl,wInventory.itemSubmenuMaxWidth		; $576f
	ldi (hl),a		; $5772

	; [wInventory.itemSubmenuWidth] = 0
	xor a			; $5773
	ldi (hl),a		; $5774

	; $cbc1 = 1
	inc a			; $5775
	ldi (hl),a		; $5776

	ld (wInventory.itemSubmenuCounter),a		; $5777
	ld a,(wInventorySubmenu0CursorPos)		; $577a
	cp $08			; $577d
	ld a,$0a		; $577f
	jr nc,+			; $5781
	add $a0			; $5783
+
	ldi (hl),a		; $5785
	ld hl,wSubmenuState		; $5786
	inc (hl)		; $5789
;;
; @addr{578a}
@subState1:
	ld hl,wInventory.itemSubmenuCounter		; $578a
	dec (hl)		; $578d
	ret nz			; $578e

	ld (hl),$02		; $578f
	call @func_02_57f3		; $5791
	jr c,+			; $5794

	call _func_02_5a35		; $5796
	ld hl,wSubmenuState		; $5799
	inc (hl)		; $579c
+
	jp _func_02_55a8		; $579d

;;
; Waiting for input (direction button or final selection).
;
; @addr{57a0}
@subState2:
	ld a,(wKeysJustPressed)		; $57a0
	and BTN_START | BTN_B | BTN_A	; $57a3
	jr nz,@buttonPressed		; $57a5

	call _func_02_5938		; $57a7

.ifdef ROM_AGES
	call _cpInventorySelectedItemToHarp		; $57aa
	ld a,(wInventory.itemSubmenuIndex)		; $57ad
	jr nz,+			; $57b0
	add $25			; $57b2
	jr ++			; $57b4
+

.else; ROM_SEASONS

	ld a,(wInventory.selectedItem)
	ld a,(wInventory.itemSubmenuIndex)
.endif

	call _getSeedTypeInventoryIndex		; $57b6
	add $20			; $57b9
++
	call loadTreasureDisplayData		; $57bb
	ld a,$06		; $57be
	rst_addAToHl			; $57c0
	ld a,(wInventory.selectedItem)		; $57c1

.ifdef ROM_AGES
	cp ITEMID_SHOOTER			; $57c4
.else
	cp ITEMID_SLINGSHOT
.endif

	ld a,$00		; $57c6
	jr nz,+			; $57c8
	ld a,$05		; $57ca
+
	add (hl)		; $57cc
	call _showItemText2		; $57cd
	jp _func_02_5a35		; $57d0

@buttonPressed:

.ifdef ROM_AGES
	call _cpInventorySelectedItemToHarp		; $57d3
	jr nz,+			; $57d6

	ld e,<wSelectedHarpSong		; $57d8
	ld a,(wInventory.itemSubmenuIndex)		; $57da
	inc a			; $57dd
	jr ++			; $57de
+
	ld e,<wSatchelSelectedSeeds		; $57e0
	cp ITEMID_SEED_SATCHEL			; $57e2
	jr z,+			; $57e4
	inc e			; $57e6
+
.else; ROM_SEASONS

	ld a,(wInventory.selectedItem)
	ld e,<wSatchelSelectedSeeds
	cp ITEMID_SEED_SATCHEL
	jr z,+
	inc e
+
.endif

	ld a,(wInventory.itemSubmenuIndex)		; $57e7
	call _getSeedTypeInventoryIndex		; $57ea
++
	ld d,>wc600Block	; $57ed
	ld (de),a		; $57ef
	jp _inventoryMenuState1@finalizeEquip		; $57f0

;;
; @addr{57f3}
@func_02_57f3:
	ld hl,wInventory.itemSubmenuMaxWidth		; $57f3
	ldi a,(hl)		; $57f6
	ld c,a			; $57f7
	ld a,(hl)		; $57f8
	cp c			; $57f9
	jr nc,+			; $57fa

	add $02			; $57fc
	ldi (hl),a		; $57fe
	inc hl			; $57ff
	dec (hl)		; $5800
	jr ++			; $5801
+
	inc hl			; $5803
	ld a,(hl)		; $5804
	cp $04			; $5805
	ret nc			; $5807
	inc (hl)		; $5808
++
	ld l,<wInventory.itemSubmenuWidth	; $5809
	ldi a,(hl)		; $580b
	ld c,a			; $580c
	ldi a,(hl)		; $580d
	ld b,a			; $580e
	ld a,(hl)		; $580f
	ld hl,w4TileMap+$80		; $5810
	rst_addAToHl			; $5813

.ifdef ROM_AGES
	ld de,$0101		; $5814
	ld a,b			; $5817
	cp $04			; $5818
	jr z,+			; $581a
	set 7,e			; $581c
+

.else; ROM_SEASONS

	ld de,$0001
.endif

	; d = tile index, e = flags, bc = height/width of rectangle to fill
	; Note the differing values of 'd' at this point between ages and seasons; they
	; use different tiles for the submenus because they have different palettes
	; loaded.

	call _fillRectangleInTilemap		; $581e
	scf			; $5821
	ret			; $5822


; Widths for item submenus (satchel/shooter/harp)
; First byte is for 2 options in the menu, 2nd is for 3 options, etc.
; @addr{5823}
@itemSubmenuWidths:
	.db $08 $0a $10 $10

;;
; Going to the next screen (when select is pressed)
; @addr{5827}
_inventoryMenuState3:
	ld a,(wSubmenuState)		; $5827
	rst_jumpTable			; $582a
	.dw @subState0
	.dw @subState1
	.dw @subState2

@subState0:
	ld hl,wInventorySubmenu		; $5831
	ld a,(hl)		; $5834
	inc a			; $5835
	cp $03			; $5836
	jr c,+			; $5838
	xor a			; $583a
+
	ld (hl),a		; $583b
	ld a,(wInventory.cbba)		; $583c
	xor $01			; $583f
	ld (wInventory.cbba),a		; $5841
	call _func_02_55b2		; $5844
	ld a,$9f		; $5847
	ld (wGfxRegs2.WINX),a		; $5849
	ld hl,wSubmenuState		; $584c
	inc (hl)		; $584f
	ld a,SND_OPENMENU	; $5850
	call playSound		; $5852

@subState1:
	ldbc $07, $0c		; $5855
	ld a,(wGfxRegs2.WINX)		; $5858
	sub c			; $585b
	cp b			; $585c
	jr nc,+			; $585d
	ld a,b			; $585f
+
	ld (wGfxRegs2.WINX),a		; $5860
	ld a,(wGfxRegs2.SCX)		; $5863
	add c			; $5866
	ld (wGfxRegs2.SCX),a		; $5867
	cp $98			; $586a
	ret c			; $586c

@subState2:
	ld a,$c7		; $586d
	ld (wGfxRegs2.WINX),a		; $586f
	xor a			; $5872
	ld (wGfxRegs2.SCX),a		; $5873
	ld a,(wGfxRegs2.LCDC)		; $5876
	xor $48			; $5879
	ld (wGfxRegs2.LCDC),a		; $587b
	ld a,$01		; $587e
	jp _inventoryMenuState1@func_02_5606		; $5880

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
; @addr{5883}
_getDirectionButtonOffsetFromHl:
	call getInputWithAutofire		; $5883
	and $f0			; $5886
	swap a			; $5888
	call getLowestSetBit		; $588a
	ret nc			; $588d
	rst_addAToHl			; $588e
	ld a,(hl)		; $588f
	or a			; $5890
	scf			; $5891
	ret			; $5892

;;
; Check direction buttons and update cursor appropriately on the item menu.
; @addr{5893}
_inventorySubscreen0CheckDirectionButtons:
	ld hl,@offsets		; $5893
	call _getDirectionButtonOffsetFromHl		; $5896
	ret nc			; $5899

	ld hl,wInventorySubmenu0CursorPos		; $589a
	add (hl)		; $589d
	and $0f			; $589e
	ld (hl),a		; $58a0
	ld a,SND_MENU_MOVE	; $58a1
	jp playSound		; $58a3

; @addr{58a6}
@offsets:
	.db $01 $ff $fc $04

;;
; Same as above, but for the second submenu.
; @addr{58aa}
_inventorySubmenu1CheckDirectionButtons:
	ld hl,@offsets		; $58aa
	call _getDirectionButtonOffsetFromHl		; $58ad
	ret nc			; $58b0

	ld c,a			; $58b1
	ld b,a			; $58b2
	inc b			; $58b3

	; Calculate number of selectable positions in total (depends on the level of the
	; ring box). Store the number of selectable positions in 'd'.
	call _getRingBoxCapacity		; $58b4
	ld e,$0f		; $58b7
	jr z,+			; $58b9
	inc a			; $58bb
+
	add e			; $58bc
	ld d,a			; $58bd

	ld hl,wInventorySubmenu1CursorPos		; $58be
	ld a,(hl)		; $58c1
	bit 2,b			; $58c2
	jr nz,@upOrDown		; $58c4

@leftOrRight:
	add c			; $58c6
	cp d			; $58c7
	jr nc,@leftOrRight		; $58c8
	jr ++			; $58ca

@upOrDown:
	cp e			; $58cc
	jr nc,@@ringBoxRow			; $58cd

	add c			; $58cf
	cp e			; $58d0
	jr c,++			; $58d1

@@ringBoxRow:
	ld a,(hl) ; hl=wInventorySubmenu1CursorPos
-
	ld c,a			; $58d4
	call @updateCursorOnRingBoxRow		; $58d5
	cp d			; $58d8
	jr nc,-			; $58d9

++
	ld (hl),a		; $58db
	ld a,SND_MENU_MOVE	; $58dc
	jp playSound		; $58de

;;
; @param	b	"Offset" that the cursor is being moved
; @param	c	Cursor position (wInventorySubmenu1CursorPos)
; @param[out]	a	New cursor position
; @addr{58e1}
@updateCursorOnRingBoxRow:
	push hl			; $58e1
	ld hl,@ringBoxRowPositionMappings		; $58e2
-
	ldi a,(hl)		; $58e5
	cp c			; $58e6
	jr nz,-			; $58e7

	; Check if movement was up or down
	bit 3,b			; $58e9
	jr z,+			; $58eb
	dec hl			; $58ed
	dec hl			; $58ee
+
	ld a,(hl)		; $58ef
	pop hl			; $58f0
	ret			; $58f1

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
; @addr{5908}
_inventorySubmenu2CheckDirectionButtons:

.ifdef ROM_SEASONS
	ld e,$80
	call _checkWhetherToDisplaySeasonInSubscreen
	jr z,+
	ld e,$00
+
.endif

	ld hl,@offsets		; $5908
	call _getDirectionButtonOffsetFromHl		; $590b
	ret nc			; $590e

	ld hl,wInventorySubmenu2CursorPos		; $590f
	ld c,a			; $5912
	cp $80			; $5913
	jr nz,@upOrDown			; $5915

@leftOrRight:
	xor (hl)		; $5917
	jr ++			; $5918

@upOrDown:
	bit 7,(hl)		; $591a
	jr z,@@leftSide		; $591c

@@rightSide:
	ld hl,wInventory.submenu2CursorPos2	; $591e
	ld a,(hl)		; $5921
--
	add c			; $5922
	and $03			; $5923

.ifdef ROM_SEASONS
	cp e
	jr z,--
.endif
	cp $03			; $5925
	jr nc,--			; $5927
	jr ++			; $5929

@@leftSide:
	add (hl)		; $592b
	and $07			; $592c

++
	ld (hl),a		; $592e
	ld a,SND_MENU_MOVE	; $592f
	jp playSound		; $5931

; @addr{5934}
@offsets:
	.db $80 $80 $ff $01


.ifdef ROM_SEASONS

;;
; @param[out]	zflag	Set if the season should be displayed. (Unset in dungeons,
;			subrosia, etc.)
_checkWhetherToDisplaySeasonInSubscreen:
	ld a,(wAreaFlags)
	and $fc
	ret

.endif
;;
; @addr{5938}
_func_02_5938:
	ld a,(wInventory.cbb8)		; $5938
	ld b,a			; $593b
	ld hl,@offsets		; $593c
	call _getDirectionButtonOffsetFromHl		; $593f
	ret nc			; $5942
	ret z			; $5943

	ld hl,wTmpcbb5		; $5944
	add (hl)		; $5947
	bit 7,a			; $5948
	jr nz,+			; $594a
	cp b			; $594c
	jr c,++			; $594d
	xor a			; $594f
	jr ++			; $5950
+
	ld a,b			; $5952
	dec a			; $5953
++
	ld (hl),a		; $5954
	ld a,SND_MENU_MOVE	; $5955
	jp playSound		; $5957

; @addr{595a}
@offsets:
	.db $01 $ff $00 $00

;;
; @addr{595e}
_inventorySubscreen0_drawCursor:
	ld a,(wInventorySubmenu0CursorPos)		; $595e
	ld c,a			; $5961
	and $0c			; $5962
	rrca			; $5964
	rrca			; $5965
	swap a			; $5966
	ld b,a			; $5968
	rrca			; $5969
	add b			; $596a
	ld b,a			; $596b
	ld a,c			; $596c
	and $03			; $596d
	swap a			; $596f
	add a			; $5971
	ld c,a			; $5972
	ld hl,@cursorSprites	; $5973
	jp addSpritesToOam_withOffset		; $5976

; @addr{5979}
@cursorSprites:
	.db $02
	.db $28 $18 $0c $22 ; left
	.db $28 $38 $0c $02 ; right

;;
; @addr{5982}
_inventorySubmenu1_drawCursor:
	ld a,(wInventorySubmenu1CursorPos)		; $5982
	ld e,a			; $5985
	ld hl,@data		; $5986
	rst_addAToHl			; $5989
	ld a,(hl)		; $598a
	and $f0			; $598b
	rrca			; $598d
	ld b,a			; $598e
	ld a,(hl)		; $598f
	and $0f			; $5990
	swap a			; $5992

	rrca			; $5994
	ld c,a			; $5995
	ld d,$02		; $5996
	ld a,e			; $5998

	cp $04			; $5999
	jr z,+			; $599b

.ifdef ROM_AGES
	cp $09			; $599d
	jr z,+			; $599f
.endif

	sub $0e			; $59a1
	jr z,+			; $59a3

	dec d			; $59a5
	dec a			; $59a6
	jr z,+			; $59a7

	dec d			; $59a9
+
	ld a,d			; $59aa
	ld hl,@spritesTable	; $59ab
	rst_addDoubleIndex			; $59ae
	ldi a,(hl)		; $59af
	ld h,(hl)		; $59b0
	ld l,a			; $59b1
	jp addSpritesToOam_withOffset		; $59b2

; @addr{59b5}
@data:
	.db $52 $55 $58 $5b $5e $82 $85 $88
	.db $8b $8e $b2 $b5 $b8 $bb $be $e0
	.db $e3 $e6 $e9 $ec $ef

; @addr{59ca}
@spritesTable:
	.dw @sprites0
	.dw @sprites1
	.dw @sprites2

; @addr{59d0}
@sprites0:
	.db $02
	.db $00 $08 $0c $22
	.db $00 $20 $0c $02

; @addr{59d9}
@sprites1:
	.db $02
	.db $00 $0c $0c $22
	.db $00 $24 $0c $02

; @addr{59e2}
@sprites2:
	.db $02
	.db $00 $08 $0c $22
	.db $00 $28 $0c $02

_inventorySubmenu2_drawCursor:
	ld a,(wInventorySubmenu2CursorPos)		; $59eb
	bit 7,a			; $59ee
	jr z,+			; $59f0
	ld a,(wInventory.submenu2CursorPos2)		; $59f2
	add $08			; $59f5
+
	ld e,a			; $59f7
	ld hl,@offsets		; $59f8
	rst_addDoubleIndex			; $59fb
	ldi a,(hl)		; $59fc
	ld b,a			; $59fd
	ld c,(hl)		; $59fe
	ld a,e			; $59ff
	cp $08			; $5a00
	ld hl,@sprites1		; $5a02
	jr c,+			; $5a05
	ld hl,@sprites2		; $5a07
+
	jp addSpritesToOam_withOffset		; $5a0a

; @addr{5a0d}
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

; @addr{5a23}
@sprites1:
	.db $02
	.db $00 $00 $0c $22
	.db $00 $18 $0c $02

; @addr{5a2c}
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
; @addr{5a35}
_func_02_5a35:
	ldde $05, $00		; $5a35

.ifdef ROM_AGES
	call _cpInventorySelectedItemToHarp		; $5a38
	jr nz,+			; $5a3b
	ldde $03, $05		; $5a3d
+
.endif

	; d = maximum number of options
	; e = first bit to check in wSeedsAndHarpSongsObtained

	ld b,d			; $5a40
	ld d,$00		; $5a41
@next:
	push bc			; $5a43
	ld a,e			; $5a44
	ld hl,wSeedsAndHarpSongsObtained		; $5a45
	call checkFlag		; $5a48
	jr z,@dontHaveSubItem	; $5a4b

	push de			; $5a4d
	ld a,d			; $5a4e
	call _func_02_5afc		; $5a4f
	ld a,e			; $5a52
	ld hl,_seedAndHarpSpriteTable	; $5a53
	rst_addAToHl			; $5a56
	ld a,(hl)		; $5a57
	rst_addAToHl			; $5a58
	call addSpritesToOam_withOffset		; $5a59
	pop de			; $5a5c

.ifdef ROM_AGES
	; If this is for the harp, skip over some of the following code
	ld a,e			; $5a5d
	cp $05			; $5a5e
	jr nc,@seedOnlyCodeDone	; $5a60
.endif

; Seed-only code (for seed satchel, seed shooter)
	ld a,e			; $5a62
	ld hl,wNumEmberSeeds		; $5a63
	rst_addAToHl			; $5a66
	ld b,(hl)		; $5a67
	ld a,(wInventory.cbb8)		; $5a68
	ld hl,_table_5ae5-4		; $5a6b
	rst_addDoubleIndex			; $5a6e
	ldi a,(hl)		; $5a6f
	ld h,(hl)		; $5a70
	ld l,a			; $5a71
	ld a,d			; $5a72
	rst_addAToHl			; $5a73
	ld c,(hl)		; $5a74
	ld hl,w4TileMap+$c0		; $5a75
	ld a,(wInventorySubmenu0CursorPos)		; $5a78
	cp $08			; $5a7b
	jr nc,+			; $5a7d
	ld hl,w4TileMap+$160		; $5a7f
+
	ld a,c			; $5a82
	rst_addAToHl			; $5a83
	ld a,b			; $5a84
	and $f0			; $5a85
	swap a			; $5a87
	add NUMBER_OFFSET			; $5a89
	ldi (hl),a		; $5a8b
	ld a,b			; $5a8c
	and $0f			; $5a8d
	add NUMBER_OFFSET			; $5a8f
	ldd (hl),a		; $5a91

@seedOnlyCodeDone:
	inc d			; $5a92

@dontHaveSubItem:
	inc e			; $5a93
	pop bc			; $5a94
	dec b			; $5a95
	jr nz,@next		; $5a96

	ld a,(wTmpcbb5)		; $5a98
	call _func_02_5afc		; $5a9b
	ld hl,@cursorSprite		; $5a9e
	jp addSpritesToOam_withOffset		; $5aa1

.undefine NUMBER_OFFSET

; Sprite for cursor in submenus
; @addr{5aa4}
@cursorSprite:
	.db $01
	.db $28 $0c $0e $03

; @addr{5aa9}
_seedAndHarpSpriteTable:
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

; @addr{5ab1}
@sprite0:
	.db $01
	.db $14 $0c $06 $0a

; @addr{5ab6}
@sprite1:
	.db $01
	.db $14 $0c $08 $0b

; @addr{5abb}
@sprite2:
	.db $01
	.db $14 $0c $0a $09

; @addr{5ac0}
@sprite3:
	.db $01
	.db $14 $0c $0c $09

; @addr{5ac5}
@sprite4:
	.db $01
	.db $14 $0c $0e $08


.ifdef ROM_AGES

; @addr{5acb}
@sprite5:
	.db $02
	.db $14 $08 $46 $08
	.db $14 $10 $48 $08

; @addr{5ad3}
@sprite6:
	.db $02
	.db $14 $08 $4e $0b
	.db $14 $10 $50 $0b

; @addr{5adc}
@sprite7:
	.db $02
	.db $14 $08 $56 $09
	.db $14 $10 $58 $09

.endif


; @addr{5ae5}
_table_5ae5:
	.dw @data2
	.dw @data3
	.dw @data4
	.dw @data5

; @addr{5aed}
@data4:
	.db $03
; @addr{5aee}
@data2:
	.db $07 $0b $0f
; @addr{5af1}
@data5:
	.db $03
; @addr{5af2}
@data3:
	.db $06 $09 $0c $0f


.ifdef ROM_AGES
;;
; Set z flag if selected inventory item is the harp.
; @addr{5af6}
_cpInventorySelectedItemToHarp:
	ld a,(wInventory.selectedItem)		; $5af6
	cp ITEMID_HARP		; $5af9
	ret			; $5afb
.endif


;;
; @addr{5afc}
_func_02_5afc:
	ld c,a			; $5afc
	ld a,(wInventory.cbb8)		; $5afd
	ld hl,_table_5ae5-4		; $5b00
	rst_addDoubleIndex			; $5b03
	ldi a,(hl)		; $5b04
	ld h,(hl)		; $5b05
	ld l,a			; $5b06
	ld a,c			; $5b07
	rst_addAToHl			; $5b08
	ld a,(hl)		; $5b09
	swap a			; $5b0a
	rrca			; $5b0c
	ld c,a			; $5b0d
	ld b,$20		; $5b0e
	ld a,(wInventorySubmenu0CursorPos)		; $5b10
	cp $08			; $5b13
	ret nc			; $5b15
	ld b,$48		; $5b16
	ret			; $5b18

;;
; Convert the index of a seed type to the index in the inventory, based on how
; many types of seeds have been obtained.
; @param a Seed type
; @addr{5b19}
_getSeedTypeInventoryIndex:
	ld c,a			; $5b19
	inc c			; $5b1a
	ld hl,wSeedsAndHarpSongsObtained		; $5b1b
	xor a			; $5b1e
-
	ld b,a			; $5b1f
	call checkFlag		; $5b20
	jr z,+			; $5b23
	dec c			; $5b25
	jr z,++			; $5b26
+
	ld a,b			; $5b28
	inc a			; $5b29
	jr -			; $5b2a
++
	ld a,b			; $5b2c
	ret			; $5b2d

;;
; Draws the "E" on the ring you have equipped.
; @addr{5b2e}
_drawEquippedSpriteForActiveRing:
	call _getRingBoxCapacity		; $5b2e
	ret z			; $5b31

	ld b,a			; $5b32
	ld a,(wActiveRing)		; $5b33
	cp $ff			; $5b36
	ret z			; $5b38

	ld hl,wRingBoxContents		; $5b39
	ld c,$00		; $5b3c
-
	cp (hl)			; $5b3e
	jr z,@foundRing		; $5b3f
	inc hl			; $5b41
	inc c			; $5b42
	dec b			; $5b43
	jr nz,-			; $5b44
	ret			; $5b46

@foundRing:
	ld a,$18		; $5b47
	call multiplyAByC		; $5b49
	ld c,l			; $5b4c
	ld b,$00		; $5b4d
	ld hl,@sprite		; $5b4f
	jp addSpritesToOam_withOffset		; $5b52

; @addr{5b55}
@sprite:
	.db $01
	.db $6e $2e $ec $04

;;
; Draw all items in wInventoryStorage to their appropriate positions.
; @addr{5b5a}
_inventorySubscreen0_drawStoredItems:
	ld a,$10		; $5b5a
--
	ldh (<hFF8D),a	; $5b5c
	ld hl,wInventoryStorage-1	; $5b5e
	rst_addAToHl			; $5b61
	ld a,(hl)		; $5b62
	call loadTreasureDisplayData		; $5b63
	ldi a,(hl)		; $5b66
	call checkTreasureObtained		; $5b67
	ldh (<hFF8B),a	; $5b6a
	ldh a,(<hFF8D)	; $5b6c
	ld bc,@itemPositions-2		; $5b6e
	call addDoubleIndexToBc		; $5b71
	ld a,(bc)		; $5b74
	ld e,a			; $5b75
	inc bc			; $5b76
	ld a,(bc)		; $5b77
	ld d,a			; $5b78
	call _drawTreasureDisplayDataToBg		; $5b79
	ldh a,(<hFF8D)	; $5b7c
	dec a			; $5b7e
	jr nz,--		; $5b7f
	ret			; $5b81

; Positions of items in the menu screen.
; @addr{5b82}
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
; @addr{5ba2}
_inventorySubscreen1_drawTreasures:
	ld hl,_subscreen1TreasureData		; $5ba2
@drawTreasure:
	ldi a,(hl) ; Read treasure index
	or a			; $5ba6
	jr z,@undrawRingBox	; $5ba7

	ldh (<hFF8C),a	; $5ba9
	call checkTreasureObtained		; $5bab
	jr nc,@nextTreasure	; $5bae

	; Draw it
	ldh (<hFF8B),a ; [hFF8B] = treasure parameter (needed for the "draw" call below)
	ldi a,(hl)		; $5bb2
	call @getAddressToDrawTreasureAt		; $5bb3
	push hl			; $5bb6
	ldh a,(<hFF8C)	; $5bb7
	call loadTreasureDisplayData		; $5bb9
	inc hl			; $5bbc
	call _drawTreasureDisplayDataToBg		; $5bbd

	; Set text index
	ld c,(hl)		; $5bc0
	pop hl			; $5bc1
	ldd a,(hl)		; $5bc2
	ld de,w4SubscreenTextIndices		; $5bc3
	call addAToDe		; $5bc6
	ld a,c			; $5bc9
	ld (de),a		; $5bca

@nextTreasure:
	inc hl			; $5bcb
	inc hl			; $5bcc
	jr @drawTreasure		; $5bcd

@undrawRingBox:
	; Clear away some tiles based on ring box level
	ld a,(wRingBoxLevel)		; $5bcf
	cp $03			; $5bd2
	jr z,@drawRings		; $5bd4

	ld hl,@ringBoxClearTiles		; $5bd6
	rst_addDoubleIndex			; $5bd9
	ldi a,(hl)		; $5bda
	ld c,(hl)		; $5bdb
	ld b,$03		; $5bdc
	ld l,a			; $5bde
	ld h,>w4TileMap+1		; $5bdf
	call _fillRectangleInTileMapWithMenuBlock		; $5be1

@drawRings:
	call _getRingBoxCapacity		; $5be4
	ret z			; $5be7

	ld b,a			; $5be8
@drawRing:
	; Get position of ring in tilemap in de
	ld a,b			; $5be9
	ld hl,@ringPositions-1		; $5bea
	rst_addAToHl			; $5bed
	ld e,(hl)		; $5bee
	ld d,>w4TileMap+1		; $5bef

	; Get ring index
	ld a,b			; $5bf1
	ld hl,wRingBoxContents-1		; $5bf2
	rst_addAToHl			; $5bf5
	ld a,(hl)		; $5bf6
	cp $ff			; $5bf7
	jr z,@nextRing		; $5bf9

	; Set ring text
	push bc			; $5bfb
	ld c,a			; $5bfc
	ld a,b			; $5bfd
	ld hl,w4SubscreenTextIndices+$f		; $5bfe
	rst_addAToHl			; $5c01
	ld a,c			; $5c02
	or $c0			; $5c03
	ld (hl),a		; $5c05

	; Draw ring
	ld a,c			; $5c06
	call _getRingTiles		; $5c07

	pop bc			; $5c0a
@nextRing:
	dec b			; $5c0b
	jr nz,@drawRing		; $5c0c

	; Set text and icon for ring box based on level
	ld a,(wRingBoxLevel)		; $5c0e
	add <TX_091d-1			; $5c11
	ld (w4SubscreenTextIndices+$f),a		; $5c13
	ld de,w4TileMap+$182		; $5c16
	ld a,$fe		; $5c19
	jp _getRingTiles		; $5c1b

;;
; @param	a	"Position" byte to convert
; @param[out]	de	Position in w4TileMap to draw to
; @addr{5c1e}
@getAddressToDrawTreasureAt:
	ld d,a			; $5c1e
	and $f0			; $5c1f
	swap a			; $5c21
	add a			; $5c23
	call multiplyABy16		; $5c24
	ld a,d			; $5c27
	and $0f			; $5c28
	add c			; $5c2a
	ld de,w4TileMap+$62		; $5c2b
	call addAToDe		; $5c2e
	ret			; $5c31


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
; @addr{5c3d}
_inventorySubscreen2_drawTreasures:
	ld hl,_itemSubmenu2TextIndices		; $5c3d
	ld de,w4SubscreenTextIndices		; $5c40
	ld b,$0b		; $5c43
	call copyMemory		; $5c45

	; Loop through all essences; delete the ones we don't own.
	; (They're already all drawn to the screen.)
	ld b,$08		; $5c48
@drawEssence:
	ld a,b			; $5c4a
	dec a			; $5c4b
	ld hl,wEssencesObtained		; $5c4c
	call checkFlag		; $5c4f
	jr nz,@nextEssence		; $5c52

	; Clear this essence
	push bc			; $5c54
	ld a,b			; $5c55
	ld hl,_itemSubmenu2EssencePositions-2		; $5c56
	rst_addDoubleIndex			; $5c59
	ldi a,(hl)		; $5c5a
	ld h,(hl)		; $5c5b
	ld l,a			; $5c5c
	ld bc,$0202		; $5c5d
	ld de,$0007		; $5c60
	call _fillRectangleInTilemap		; $5c63
	pop bc			; $5c66
	ld a,b			; $5c67
	ld hl,$d3df		; $5c68
	rst_addAToHl			; $5c6b
	ld (hl),$00		; $5c6c
@nextEssence:
	dec b			; $5c6e
	jr nz,@drawEssence	; $5c6f

	; Change heart piece text based on how many you have
	ld a,(wNumHeartPieces)		; $5c71
	ld c,a			; $5c74
	ld hl,w4SubscreenTextIndices+9		; $5c75
	add (hl)		; $5c78
	ld (hl),a		; $5c79

	ld a,c			; $5c7a
	or a			; $5c7b
	jr z,@doneUpdatingHeartPiece	; $5c7c

	; Fill in up to 3 sections based on how many heart pieces the player has
	add $10			; $5c7e
	ld (w4TileMap+$14f),a		; $5c80
	ld hl,_itemSubmenu2HeartPieceDisplayData		; $5c83
@nextQuarterHeart:
	push bc			; $5c86
	ldi a,(hl)		; $5c87
	ld de,w4TileMap+$ce		; $5c88
	call addAToDe		; $5c8b
	call _drawTreasureDisplayDataToBg		; $5c8e
	pop bc			; $5c91
	dec c			; $5c92
	jr nz,@nextQuarterHeart	; $5c93
@doneUpdatingHeartPiece:


; The below code decides how to (and whether to) draw the time or season symbol.
; Naturally the games differ in how they do this.

.ifdef ROM_AGES
	ld a,(wAreaFlags)		; $5c95
	and AREAFLAG_PAST			; $5c98
	rlca			; $5c9a

.else; ROM_SEASONS

	call _checkWhetherToDisplaySeasonInSubscreen
	ld hl,w4TileMap+$4d
	ldbc $04,$06
	jp nz,_fillRectangleInTileMapWithMenuBlock

	ld a,(wMinimapGroup)
	sub $02
	jr z,+
	ld a,(wLoadingRoomPack)
	inc a
	jr z,+
	ld a,(wRoomStateModifier)
+
.endif

	ld c,a			; $5c9b

	; Set text index for time/season blurb
	ld hl,w4SubscreenTextIndices+8		; $5c9c
	add (hl)		; $5c9f
	ld (hl),a		; $5ca0

	; Load graphic
	ld a,c			; $5ca1
	add a			; $5ca2
	add a			; $5ca3
	add c			; $5ca4
	ld hl,_itemSubmenu2BlurbDisplayData		; $5ca5
	rst_addDoubleIndex			; $5ca8
	ld de,w4TileMap+$6e		; $5ca9
	call _drawTreasureDisplayDataToBg		; $5cac
	ld e,$70		; $5caf
	jp _drawTreasureDisplayDataToBg		; $5cb1

; @addr{5cb4}
_itemSubmenu2EssencePositions:
	.dw w4TileMap+$084 w4TileMap+$087 w4TileMap+$0c9 w4TileMap+$129
	.dw w4TileMap+$167 w4TileMap+$164 w4TileMap+$122 w4TileMap+$0c2


; Display data for time/season blurb in subscreen 2.
;  b0/b1: left tile index, attribute.
;  b2/b3: right tile index, attribute.
;  b4:    $ff to indicate no extra level/item count/etc drawn (since this uses
;         "drawTreasureDisplayData").
; @addr{5cc4}
_itemSubmenu2BlurbDisplayData:

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
; @addr{5cd8}
_itemSubmenu2HeartPieceDisplayData:
	.db $00 $78 $05 $79 $05 $ff
	.db $40 $7a $05 $7b $05 $ff
	.db $42 $7b $25 $7a $25 $ff

.ifdef ROM_AGES
; Text for essences and the options on the right side in item submenu 2.
_itemSubmenu2TextIndices:
	.db <TX_0901 <TX_0902 <TX_0903 <TX_0904 <TX_0905 <TX_0906 <TX_0907 <TX_0908
	.db <TX_0965 <TX_0961 <TX_0960

.else; ROM_SEASONS

_itemSubmenu2TextIndices:
	.db <TX_0901 <TX_0902 <TX_0903 <TX_0904 <TX_0905 <TX_0906 <TX_0907 <TX_0908
	.db <TX_0956 <TX_0952 <TX_0951
.endif

;;
; @param[out] a Capacity of ring box.
; @addr{5cf5}
_getRingBoxCapacity:
	push hl			; $5cf5
	ld a,(wRingBoxLevel)		; $5cf6
	ld hl,@ringBoxCapacities		; $5cf9
	rst_addAToHl			; $5cfc
	ld a,(hl)		; $5cfd
	or a			; $5cfe
	pop hl			; $5cff
	ret			; $5d00

; @addr{5d01}
@ringBoxCapacities:
	.db $00 $01 $03 $05

;;
; Fills a rectangle with that block tile that separates sections of the inventory menu.
;
; @param	bc	Height, width
; @param	hl	Tilemap (Top-left position to start at)
; @addr{5d05}
_fillRectangleInTileMapWithMenuBlock:
	ld de,$e701		; $5d05

;;
; Fills a rectangular area in a tilemap with the given values.
;
; @param	b	Height
; @param	c	Width
; @param	de	Tile index (d) and flag (e) to fill in every position
; @param	hl	Tilemap (top-left position to start at)
; @addr{5d08}
_fillRectangleInTilemap:
	push hl			; $5d08
	ld a,c			; $5d09
--
	ld (hl),d		; $5d0a
	set 2,h			; $5d0b
	ld (hl),e		; $5d0d
	res 2,h			; $5d0e
	inc hl			; $5d10
	dec a			; $5d11
	jr nz,--		; $5d12

	pop hl			; $5d14
	ld a,$20		; $5d15
	rst_addAToHl			; $5d17
	dec b			; $5d18
	jr nz,_fillRectangleInTilemap	; $5d19
	ret			; $5d1b

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
; @addr{5d1c}
_drawTreasureDisplayDataToBg:
	; Draw the left tile
	ldi a,(hl)		; $5d1c
	ld c,a			; $5d1d
	ldi a,(hl)		; $5d1e
	ld b,a			; $5d1f
	call @writeTile		; $5d20

	; Draw the right tile
	inc e			; $5d23
	ldi a,(hl)		; $5d24
	ld c,a			; $5d25
	ldi a,(hl)		; $5d26
	ld b,a			; $5d27
	call @writeTile		; $5d28

	; Draw the "extra tiles" (ammo count, etc)
	ld a,$20		; $5d2b
	call addAToDe		; $5d2d
	ldh a,(<hFF8B)	; $5d30
	ld b,a			; $5d32
	ld c,$07		; $5d33
	ldi a,(hl)		; $5d35
	jp _drawTreasureExtraTiles		; $5d36

;;
; @param bc
; @addr{5d39}
@writeTile:
	push de			; $5d39
	ld a,c			; $5d3a
	or a			; $5d3b
	jr z,@clearTile		; $5d3c

	inc b			; $5d3e
	inc b			; $5d3f
	add a			; $5d40
	jr nc,+			; $5d41
	set 3,b			; $5d43
+
	ld c,a			; $5d45
	call @writeTileHlpr	; $5d46
	pop de			; $5d49
	ret			; $5d4a

@clearTile:
	ld a,$02		; $5d4b
	ld (de),a		; $5d4d
	set 2,d			; $5d4e
	dec a			; $5d50
	ld (de),a		; $5d51
	ld a,$20		; $5d52
	call addAToDe		; $5d54
	ld a,$01		; $5d57
	ld (de),a		; $5d59
	res 2,d			; $5d5a
	inc a			; $5d5c
	ld (de),a		; $5d5d
	pop de			; $5d5e
	ret			; $5d5f

;;
; Writes tile index to (de) and (de+$20).
; Writes tile attribute to (de+$400), (de+$420).
; @param b Tile attribute
; @param c Tile index
; @addr{5d60}
@writeTileHlpr:
	ld a,c			; $5d60
	ld (de),a		; $5d61
	set 2,d			; $5d62
	ld a,b			; $5d64
	ld (de),a		; $5d65
	ld a,$20		; $5d66
	call addAToDe		; $5d68
	ld a,b			; $5d6b
	ld (de),a		; $5d6c
	res 2,d			; $5d6d
	ld a,c			; $5d6f
	inc a			; $5d70
	ld (de),a		; $5d71
	ret			; $5d72

;;
; Handles drawing of the maku seed and harp sprites on the inventory subscreens. These are
; at least partly sprites, unlike everything else.
;
; @addr{5d73}
_inventoryMenuDrawSprites:

.ifdef ROM_AGES
	call _inventoryMenuDrawHarpSprites		; $5d73
.endif

; Remainder of function: draw maku seed sprite

	ld a,TREASURE_MAKU_SEED		; $5d76
	call checkTreasureObtained		; $5d78
	ret nc			; $5d7b

	ld bc,$2068		; $5d7c
	ld a,(wMenuActiveState)		; $5d7f
	cp $03			; $5d82
	jr z,@menuScrolling		; $5d84

@drawIfOnSubscreen1:
	ld a,(wInventorySubmenu)		; $5d86
	dec a			; $5d89
	ret nz			; $5d8a
	jr @drawSprite		; $5d8b

@menuScrolling:
	ld a,(wSubmenuState)		; $5d8d
	or a			; $5d90
	jr z,@drawIfOnSubscreen1	; $5d91

	; Determine which scroll variable to use for calculating the seed's position
	ld a,(wInventorySubmenu)		; $5d93
	or a			; $5d96
	ret z			; $5d97
	dec a			; $5d98
	jr nz,+			; $5d99
	ld a,(wGfxRegs2.WINX)		; $5d9b
	sub $07			; $5d9e
	jr @drawSpriteWithXOffset		; $5da0
+
	ld a,(wGfxRegs2.SCX)		; $5da2
	cpl			; $5da5
	inc a			; $5da6

@drawSpriteWithXOffset:
	add c			; $5da7
	ld c,a			; $5da8
@drawSprite:
	ld hl,@makuSeedSprite		; $5da9
	jp addSpritesToOam_withOffset		; $5dac

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
; @addr{5dc0}
_inventoryMenuDrawHarpSprites:
	ld hl,wInventoryStorage		; $5dc0
	ld bc,$1000		; $5dc3
--
	ldi a,(hl)		; $5dc6
	cp ITEMID_HARP			; $5dc7
	jr z,+			; $5dc9
	inc c			; $5dcb
	dec b			; $5dcc
	jr nz,--		; $5dcd
	ret			; $5dcf
+
	; Currently, c = position of harp in inventory ($00-$0f).
	; Calculate the offset of the sprite in 'bc' (assuming we're on subscreen 0).
	ld a,c			; $5dd0
	and $fc			; $5dd1
	ld b,a			; $5dd3
	add a			; $5dd4
	add b			; $5dd5
	add a			; $5dd6
	add $14			; $5dd7
	ld b,a			; $5dd9
	ld a,c			; $5dda
	and $03			; $5ddb
	swap a			; $5ddd
	add a			; $5ddf
	add $22			; $5de0
	ld c,a			; $5de2

	; Check if menu is scrolling
	ld a,(wMenuActiveState)		; $5de3
	cp $03			; $5de6
	jr z,+			; $5de8
--
	ld a,(wInventorySubmenu)		; $5dea
	or a			; $5ded
	ret nz			; $5dee
	jr @drawSprite		; $5def
+
	ld a,(wSubmenuState)		; $5df1
	or a			; $5df4
	jr z,--			; $5df5

	ld a,(wInventorySubmenu)		; $5df7
	cp $02			; $5dfa
	ret z			; $5dfc

	or a			; $5dfd
	jr nz,+			; $5dfe

	ld a,(wGfxRegs2.WINX)		; $5e00
	sub $07			; $5e03
	jr @drawSpriteWithXOffset			; $5e05
+
	ld a,(wGfxRegs2.SCX)		; $5e07
	cpl			; $5e0a
	inc a			; $5e0b

@drawSpriteWithXOffset:
	add c			; $5e0c
	ld c,a			; $5e0d
@drawSprite:
	ld a,(wSelectedHarpSong)		; $5e0e
	ld hl,_seedAndHarpSpriteTable+4		; $5e11
	rst_addAToHl			; $5e14
	ld a,(hl)		; $5e15
	rst_addAToHl			; $5e16
	jp addSpritesToOam_withOffset		; $5e17


;;
; While an item submenu is up (for harp or satchel), this creates a bunch of "blank
; sprites" that will mask any sprites behind the submenu.
;
; Doesn't exist in seasons since there are no items drawn with sprites on the inventory
; screen (only the harp of ages).
;
; @addr{5e1a}
_createBlankSpritesForItemSubmenu:
	ld hl,wInventory.cbc1		; $5e1a
	ldi a,(hl)		; $5e1d
	cp $04			; $5e1e
	ret nz			; $5e20

	ld bc,$2800		; $5e21
	ld a,(hl)		; $5e24
	cp $20			; $5e25
	jr c,+			; $5e27
	ld b,$50		; $5e29
+
	ld e,$03		; $5e2b
	ld a,(wInventory.cbb8)		; $5e2d
	cp $04			; $5e30
	jr nc,+			; $5e32
	dec e			; $5e34
	cp $03			; $5e35
	jr nc,+			; $5e37
	dec e			; $5e39
+
	ld a,e			; $5e3a
--
	dec a			; $5e3b
	push af			; $5e3c
	push bc			; $5e3d
	ld hl,@spritesTable		; $5e3e
	rst_addAToHl			; $5e41
	ld a,(hl)		; $5e42
	rst_addAToHl			; $5e43
	call addSpritesToOam_withOffset		; $5e44
	pop bc			; $5e47
	pop af			; $5e48
	jr nz,--		; $5e49
	ret			; $5e4b

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
;
; @addr{5e94}
_subscreen1TreasureData:

	.ifdef ROM_AGES
		; Row 1
		.db TREASURE_FLIPPERS		$01 $00
		.db TREASURE_MERMAID_SUIT	$01 $00
		.db TREASURE_POTION		$04 $01
		.db TREASURE_TRADEITEM		$07 $02
		.db TREASURE_EMPTY_BOTTLE	$0a $03
		.db TREASURE_FAIRY_POWDER	$0a $03
		.db TREASURE_ZORA_SCALE		$0a $03
		.db TREASURE_TOKAY_EYEBALL	$0a $03
		.db TREASURE_MAKU_SEED		$0a $03
		.db TREASURE_GASHA_SEED		$0d $04

		; Row 2
		.db TREASURE_GRAVEYARD_KEY	$31 $05
		.db TREASURE_CHEVAL_ROPE	$34 $06
		.db TREASURE_RICKY_GLOVES	$34 $06
		.db TREASURE_ISLAND_CHART	$34 $06
		.db TREASURE_MEMBERS_CARD	$34 $06
		.db TREASURE_SCENT_SEEDLING	$37 $07
		.db TREASURE_TUNI_NUT		$37 $07
		.db TREASURE_BOMB_FLOWER	$27 $07
		.db TREASURE_58			$47 $07
		.db TREASURE_CROWN_KEY		$37 $07
		.db TREASURE_BROTHER_EMBLEM	$3a $08
		.db TREASURE_SLATE		$3d $09

		; Row 3
		.db TREASURE_LAVA_JUICE		$61 $0a
		.db TREASURE_GORON_LETTER	$61 $0a
		.db TREASURE_OLD_MERMAID_KEY	$61 $0a
		.db TREASURE_ROCK_BRISKET	$64 $0b
		.db TREASURE_GORON_VASE		$64 $0b
		.db TREASURE_GORONADE		$64 $0b
		.db TREASURE_MERMAID_KEY	$64 $0b
		.db TREASURE_LIBRARY_KEY	$67 $0c
		.db TREASURE_BOOK_OF_SEALS	$6a $0d
		.db TREASURE_RING		$6d $0e
		.db $00

	.else; ROM_SEASONS

		; Row 1
		.db TREASURE_MASTERS_PLAQUE	$01 $00
		.db TREASURE_FLIPPERS		$01 $00
		.db TREASURE_POTION		$04 $01
		.db TREASURE_TRADEITEM		$07 $02
		.db TREASURE_MAKU_SEED		$0a $03
		.db TREASURE_GASHA_SEED		$0d $04

		; Row 2
		.db TREASURE_GNARLED_KEY	$31 $05
		.db TREASURE_RICKY_GLOVES	$34 $06
		.db TREASURE_FLOODGATE_KEY	$34 $06
		.db TREASURE_BOMB_FLOWER	$27 $07
		.db TREASURE_58			$47 $07
		.db TREASURE_PIRATES_BELL	$37 $07
		.db TREASURE_TREASURE_MAP	$3a $08
		.db TREASURE_ROUND_JEWEL	$3d $09
		.db TREASURE_PYRAMID_JEWEL	$3e $09
		.db TREASURE_SQUARE_JEWEL	$4d $09
		.db TREASURE_X_SHAPED_JEWEL	$4e $09

		; Row 3
		.db TREASURE_STAR_ORE		$61 $0a
		.db TREASURE_RIBBON		$61 $0a
		.db TREASURE_STAR_ORE		$61 $0a
		.db TREASURE_SPRING_BANANA	$61 $0a
		.db TREASURE_DRAGON_KEY		$61 $0a
		.db TREASURE_RED_ORE		$64 $0b
		.db TREASURE_HARD_ORE		$64 $0b
		.db TREASURE_BLUE_ORE		$67 $0c
		.db TREASURE_MEMBERS_CARD	$6a $0d
		.db TREASURE_RING		$6d $0e
		.db $00


	.endif


;;
; Performs replacements on minimap tiles, ie. for animal companion regions?
;
; @param	a	Index of replacement data to use
; @addr{5ef3}
_mapMenu_performTileSubstitutions:
	ld hl,_mapMenu_tileSubstitutionTable		; $5ef3
	rst_addAToHl			; $5ef6
	ld a,(hl)		; $5ef7
	rst_addAToHl			; $5ef8

@nextSubstitution:
	ldi a,(hl)		; $5ef9
	or a			; $5efa
	ret z			; $5efb

	ld b,a			; $5efc

	; de = destination
	ldi a,(hl)		; $5efd
	ld e,a			; $5efe
	ldi a,(hl)		; $5eff
	ld d,a			; $5f00

	; hl = src
	ldi a,(hl)		; $5f01
	ld c,a			; $5f02
	ldi a,(hl)		; $5f03
	push hl			; $5f04
	ld h,a			; $5f05
	ld l,c			; $5f06

	; b = height, c = width
	ld a,b			; $5f07
	and $0f			; $5f08
	ld c,a			; $5f0a
	ld a,b			; $5f0b
	and $f0			; $5f0c
	swap a			; $5f0e
	ld b,a			; $5f10

	; Copy the rectangular area from hl to de
@nextRow:
	push bc			; $5f11
@nextTile:
	ld a,(hl)		; $5f12
	ld (de),a		; $5f13
	set 2,h			; $5f14
	set 2,d			; $5f16
	ldi a,(hl)		; $5f18
	ld (de),a		; $5f19
	inc de			; $5f1a
	res 2,h			; $5f1b
	res 2,d			; $5f1d
	dec c			; $5f1f
	jr nz,@nextTile		; $5f20

	pop bc			; $5f22
	ld a,$20		; $5f23
	sub c			; $5f25
	ldh (<hFF8B),a	; $5f26
	rst_addAToHl			; $5f28
	ldh a,(<hFF8B)	; $5f29
	call addAToDe		; $5f2b
	dec b			; $5f2e
	jr nz,@nextRow		; $5f2f

	pop hl			; $5f31
	jr @nextSubstitution		; $5f32

;;
; @addr{5f34}
_runGaleSeedMenu:
	call clearOam		; $5f34
	call @runState		; $5f37
	jp _mapMenu_drawSprites		; $5f3a

@runState:
	ld a,(wMenuActiveState)		; $5f3d
	rst_jumpTable			; $5f40
	.dw _galeSeedMenu_state0
	.dw _galeSeedMenu_state1
	.dw _galeSeedMenu_state2
	.dw _galeSeedMenu_state3

;;
; @addr{5f49}
_galeSeedMenu_state0:
	call _mapMenu_state0		; $5f49

	; This will be incremented, so set to 0, in the next function call
	ld a,$ff		; $5f4c
	ld (wMapMenu.warpIndex),a		; $5f4e

	ld a,$01		; $5f51
	ld (wMapMenu.drawWarpDestinations),a		; $5f53

	jp _galeSeedMenu_addOffsetToWarpIndex		; $5f56

;;
; State 1: waiting for input (direction buttons, A or B)
;
; @addr{5f59}
_galeSeedMenu_state1:
	ld a,(wPaletteThread_mode)		; $5f59
	or a			; $5f5c
	jr nz,@end		; $5f5d

	ld a,(wKeysJustPressed)		; $5f5f
	bit BTN_BIT_B,a			; $5f62
	jr nz,@bPressed		; $5f64

	and (BTN_START | BTN_A)			; $5f66
	jr nz,@aPressed		; $5f68

	ld hl,@directionButtonOffsets		; $5f6a
	call _getDirectionButtonOffsetFromHl		; $5f6d
	jr nc,@end	; $5f70

	; Direction button pressed
	call _galeSeedMenu_addOffsetToWarpIndex		; $5f72
	ld a,SND_MENU_MOVE		; $5f75
	call nz,playSound		; $5f77
@end:
	jp _mapMenu_loadPopupData		; $5f7a

@bPressed:
	call _mapGetRoomTextOrReturn		; $5f7d
	ld a,$03		; $5f80
	ld c,<TX_0301 ; Reselect prompt
	jr @setState		; $5f84

@aPressed:
	call _mapGetRoomTextOrReturn		; $5f86
	ld a,c			; $5f89
	ld (wTextSubstitutions+2),a		; $5f8a
	ld c,<TX_0300 ; Warp prompt
	ld a,$02		; $5f8f

@setState:
	ld (wMenuActiveState),a		; $5f91
	ld b,>TX_0300		; $5f94
	jp showText		; $5f96

@directionButtonOffsets:
	.db $01 ; Right
	.db $ff ; Left
	.db $ff ; Up
	.db $01 ; Down

;;
; State 2: selected a warp destination; waiting for confirmation
;
; @addr{5f9d}
_galeSeedMenu_state2:
	call retIfTextIsActive	; $5f9d

	ld a,(wSelectedTextOption)	; 5fa0
	or a			; $5fa3
	jr nz,_galeSeedMenu_gotoState1	; $5fa4
	ld (wOpenedMenuType),a		; $5fa6
	ld a,(wActiveGroup)		; $5fa9
	or $80			; $5fac
	ld (wWarpDestGroup),a		; $5fae
	ld a,(wMapMenu.warpIndex)		; $5fb1
	call _getTreeWarpDataIndex		; $5fb4
	ldi a,(hl)		; $5fb7
	ld (wWarpDestIndex),a		; $5fb8
	ldi a,(hl)		; $5fbb
	ld (wWarpDestPos),a		; $5fbc
	ld a,$05		; $5fbf
	ld (wWarpTransition),a		; $5fc1
	ld a,$03		; $5fc4
	ld (wWarpTransition2),a		; $5fc6
	ld a,$03		; $5fc9
	call setMusicVolume		; $5fcb
	jp fadeoutToWhite		; $5fce

;;
; @addr{5fd1}
_galeSeedMenu_gotoState1:
	ld a,$01		; $5fd1
	ld (wMenuActiveState),a		; $5fd3
	ret			; $5fd6

;;
; State 3: pressed B button; waiting for confirmation to exit
;
; @addr{5fd7}
_galeSeedMenu_state3:
	call retIfTextIsActive		; $5fd7

	; If chose "reselect", go to state 1
	ld a,(wSelectedTextOption)		; $5fda
	or a			; $5fdd
	jr z,_galeSeedMenu_gotoState1	; $5fde

	; Otherwise exit the menu
	ld a,$ff		; $5fe0
	ld (wWarpTransition2),a		; $5fe2
	jp _closeMenu		; $5fe5

;;
; @param	a	Value to add to wMapMenu.warpIndex
; @param[out]	zflag	nz if the warp index changed.
; @addr{5fe8}
_galeSeedMenu_addOffsetToWarpIndex:
	ld e,a			; $5fe8
	ld a,(wMapMenu.warpIndex)		; $5fe9
	ld d,a			; $5fec
--
	; Keep adding the offset to the index until we reach a valid entry.
	ld a,d			; $5fed
	add e			; $5fee
	and $07			; $5fef
	ld d,a			; $5ff1
	call _getTreeWarpDataIndex		; $5ff2
	ld a,(hl)		; $5ff5
	or a			; $5ff6
	jr z,--			; $5ff7

	; We can only use entry if we've visited the room.
	call _mapMenu_checkRoomVisited		; $5ff9
	jr z,--			; $5ffc

	ldi a,(hl)		; $5ffe
	ld (wMapMenu.cursorIndex),a		; $5fff

	ld hl,wMapMenu.warpIndex		; $6002
	ld a,d			; $6005
	cp (hl)			; $6006
	ld (hl),a		; $6007
	ret			; $6008

;;
; Shows the map (either overworld or dungeon).
; @addr{6009}
_runMapMenu:
	call clearOam		; $6009
	ld a,(wMenuActiveState)		; $600c
	rst_jumpTable			; $600f
	.dw _mapMenu_state0
	.dw _mapMenu_state1

;;
; @addr{6014}
_mapMenu_state0:
	ld a,:w4TileMap		; $6014
	ld ($ff00+R_SVBK),a	; $6016

	call _loadMinimapDisplayRoom		; $6018
	ld a,(wMapMenu.mode)		; $601b
	add GFXH_0d			; $601e
	call loadGfxHeader		; $6020

	ld a,(wMapMenu.mode)		; $6023
	add PALH_07			; $6026
	call loadPaletteHeader		; $6028

	ld a,(wMapMenu.mode)		; $602b
	cp $02			; $602e
	jr z,@dungeon	; $6030

.ifdef ROM_AGES

	or a			; $6032
	jr nz,@past		; $6033

@present:
	; If the companion is not ricky, perform appropriate minimap tile substitutions.
	ld a,(wAnimalCompanion)		; $6035
	sub SPECIALOBJECTID_DIMITRI			; $6038
	call nc,_mapMenu_performTileSubstitutions		; $603a

	; Perform tile substitutions if symmetry city has been saved
	ld a,(wPresentRoomFlags+$13)		; $603d
	rrca			; $6040
	ld a,$05		; $6041
	call c,_mapMenu_performTileSubstitutions		; $6043

@past:
	; Check the position of the stone in talus peaks which changes water flow
	ld a,(wPastRoomFlags+$41)		; $6046
	rrca			; $6049
	ld a,$06		; $604a
	call c,_mapMenu_performTileSubstitutions		; $604c

	call _mapMenu_clearUnvisitedTiles		; $604f
	ld a,(wMapMenu.currentRoom)		; $6052
	ld (wMapMenu.cursorIndex),a		; $6055
	call _mapMenu_loadPopupData		; $6058
	jr @commonCode		; $605b

.else; ROM_SEASONS

	or a
	jr nz,@subrosia

@overworld:
	; If the companion is not ricky, perform appropriate minimap tile substitutions.
	ld a,(wAnimalCompanion)
	sub SPECIALOBJECTID_DIMITRI
	call nc,_mapMenu_performTileSubstitutions

	; Check whether floodgates have been opened
	ld a,(wPresentRoomFlags+$81)
	rlca
	ld a,$05
	call c,_mapMenu_performTileSubstitutions

	call _checkPirateShipMoved
	ld a,$06
	call nz,_mapMenu_performTileSubstitutions
	jr ++

@subrosia:
	call _checkPirateShipMoved
	ld a,$07
	call nz,_mapMenu_performTileSubstitutions
++
	call _mapMenu_clearUnvisitedTiles
	ld a,(wMapMenu.currentRoom)
	ld (wMapMenu.cursorIndex),a
	call _mapMenu_loadPopupData
	jr @commonCode

.endif; ROM_SEASONS


@dungeon:
	ld a,(wAreaFlags)		; $605d
	and AREAFLAG_SIDESCROLL			; $6060
	ld a,(wMinimapDungeonFloor)		; $6062
	jr nz,+			; $6065
	ld a,(wDungeonFloor)		; $6067
+
	ld b,a			; $606a
	ld a,(wDungeonNumFloors)		; $606b
	dec a			; $606e
	sub b			; $606f
	ld (wMapMenu.floorIndex),a		; $6070

	; Calculate the scroll offset for the dungeon map.
	; [wMapMenu.floorIndex]*10
	call multiplyABy8		; $6073
	ld a,(wMapMenu.floorIndex)		; $6076
	add a			; $6079
	add c			; $607a
	ld (wMapMenu.dungeonScrollY),a		; $607b

	call _dungeonMap_calculateVisitedFloorsAndLinkPosition		; $607e

	ld a,(wDungeonIndex)		; $6081
	add GFXH_10			; $6084
	call loadGfxHeader		; $6086
	call _dungeonMap_drawSmallKeyCount		; $6089
	call _dungeonMap_generateScrollableTilemap		; $608c
	call _dungeonMap_drawFloorList		; $608f
	call _dungeonMap_updateScroll		; $6092

; Code for both overworld & dungeon maps
@commonCode:
	xor a			; $6095
	ld ($ff00+R_SVBK),a	; $6096
	call _mapMenu_drawSprites		; $6098

	xor a			; $609b
	ldh (<hCameraX),a	; $609c
	ldh (<hCameraY),a	; $609e
	ld (wScreenOffsetX),a		; $60a0
	ld (wScreenOffsetY),a		; $60a3

	ld hl,wMenuActiveState		; $60a6
	inc (hl)		; $60a9

	call _mapMenu_copyTilemapToVram		; $60aa
	call fastFadeinFromWhite		; $60ad
	ld a,$07		; $60b0
	jp loadGfxRegisterStateIndex		; $60b2

;;
; Calculates values for wMapMenu.currentRoom and wMapMenu.mode.
;
; Determines where the cursor is and in what way the minimap is shown (overworld/dungeon)
;
; @addr{60b5}
_loadMinimapDisplayRoom:

.ifdef ROM_AGES
	ld hl,wMinimapGroup		; $60b5
	ldi a,(hl)		; $60b8
	ld c,(hl)		; $60b9
	ld b,a			; $60ba
	ld b,$02		; $60bb
	ld a,(wAreaFlags)		; $60bd
	bit AREAFLAG_BIT_10,a			; $60c0
	jr nz,@overworld			; $60c2
	bit AREAFLAG_BIT_DUNGEON,a			; $60c4
	jr nz,@setRoom		; $60c6

@overworld:
	ld b,a			; $60c8
	rlca			; $60c9
	and $01 ; This tests AREAFLAG_PAST
	bit AREAFLAG_BIT_MAKU,b			; $60cc
	ld b,a			; $60ce
	jr z,@setRoom			; $60cf

	; If the area is the maku tree, hardcode the room index?
	ld c,$38		; $60d1

@setRoom:
	ld a,c			; $60d3
	ld (wMapMenu.currentRoom),a		; $60d4
	ld a,b			; $60d7
	ld (wMapMenu.mode),a		; $60d8
	ret			; $60db

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
	cp $03
	jr nz,@setRoom
	ld a,(wActiveRoom)
	cp $98
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
; @addr{60dc}
_dungeonMap_drawSmallKeyCount:
	call _getNumSmallKeys		; $60dc
	ret z			; $60df
	ld hl,w4TileMap+$226		; $60e0
	add $90			; $60e3
	ldd (hl),a		; $60e5
	ld a,$9a ; "x" character
	ld (hl),a		; $60e8
	ret			; $60e9

;;
; Calculates values for:
; * wMapMenu.visitedFloors
; * wMapMenu.dungeonCursorIndex
; * wMapMenu.linkFloor
;
; @addr{60ea}
_dungeonMap_calculateVisitedFloorsAndLinkPosition:
	ld a,(wDungeonIndex)		; $60ea
	ld hl,wDungeonVisitedFloors		; $60ed
	rst_addAToHl			; $60f0
	ld b,(hl)		; $60f1
	call _checkLinkHasCompass		; $60f2
	ld a,b			; $60f5
	jr z,+			; $60f6

	ld a,(wMapFloorsUnlockedWithCompass)		; $60f8
	or b			; $60fb
+
	ld (wMapMenu.visitedFloors),a		; $60fc

	ld a,(wMinimapDungeonMapPosition)		; $60ff
	ld (wMapMenu.dungeonCursorIndex),a		; $6102
	ld a,(wMinimapDungeonFloor)		; $6105
	ld (wMapMenu.linkFloor),a		; $6108

	; Check for the final battle room with ganon; this room is hardcoded to pretend to
	; be just below the other one
	ld a,(wActiveGroup)		; $610b
	cp >GANON_ROOM			; $610e
	ret nz			; $6110
	ld a,(wActiveRoom)		; $6111
	cp <GANON_ROOM			; $6114
	ret nz			; $6116
	ld a,$13		; $6117
	ld (wMapMenu.dungeonCursorIndex),a		; $6119

	ret			; $611c

;;
; @addr{611d}
_mapMenu_state1:
	ld a,(wPaletteThread_mode)		; $611d
	or a			; $6120
	call z,@checkInput		; $6121
	jp _mapMenu_drawSprites		; $6124

;;
; @addr{6127}
@checkInput:
	ld a,(wMapMenu.mode)		; $6127
	cp $02			; $612a
	jr nz,@overworld	; $612c

@dungeon:
	ld a,(wKeysJustPressed)		; $612e
	and (BTN_B | BTN_SELECT)			; $6131
	jp nz,_closeMenu		; $6133
	call _dungeonMap_updateCursorFlickerCounter		; $6136
	jp _dungeonMap_checkDirectionButtons		; $6139

@overworld:
	ld a,(wMapMenu.varcbb4)		; $613c
	or a			; $613f
	jr z,+			; $6140
	dec a			; $6142
	ld (wMapMenu.varcbb4),a		; $6143
+
	call retIfTextIsActive		; $6146

	ld hl,@directionOffsets		; $6149
	call _getDirectionButtonOffsetFromHl		; $614c
	jr nc,@noDirectionButtonPressed	; $614f

.ifdef ROM_AGES

	ld c,a			; $6151
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
	ld a,(wMapMenu.cursorIndex)		; $6155
	ld l,a			; $6158
	and $f0			; $6159
	ld h,a			; $615b
	ld a,l			; $615c
	xor h			; $615d
	ld l,a			; $615e

	; Update cursor position & check the boundaries
	sra c			; $615f
	jr c,@verticalMove	; $6161

@horizontalMove:
	ld a,l			; $6163
	@loop1:
		add c			; $6164
		and $0f			; $6165
		cp e			; $6167
		jr nc,@loop1	; $6168
	ld l,a			; $616a
	jr @setNewCursorIndex		; $616b

@verticalMove:

.ifdef ROM_AGES
	ld a,h			; $616d
	@loop2:
		add c			; $616e
		and $f0			; $616f
		cp d			; $6171
		jr nc,@loop2		; $6172
	ld h,a			; $6174

.else; ROM_SEASONS

	ld a,h
	add c
	and d
	ld h,a
.endif

@setNewCursorIndex:
	ld a,h			; $6175
	or l			; $6176
	ld (wMapMenu.cursorIndex),a		; $6177
	ld a,SND_MENU_MOVE		; $617a
	call playSound		; $617c
	jp _mapMenu_loadPopupData		; $617f

@noDirectionButtonPressed:
	ld a,(wKeysJustPressed)		; $6182
	bit BTN_BIT_A,a			; $6185
	jr nz,@showRoomText	; $6187
	and (BTN_B | BTN_SELECT)			; $6189
	jp nz,_closeMenu		; $618b
	ret			; $618e

@showRoomText:
	call _mapGetRoomTextOrReturn		; $618f
	ld hl,wSubmenuState		; $6192
	inc (hl)		; $6195
	jp showText		; $6196

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
; @addr{619d}
_mapGetRoomTextOrReturn:
	call _mapMenu_checkCursorRoomVisited	; $619d
	jr nz,@visited		; $61a0

	; Return from caller
	pop af			; $61a2
	ret			; $61a3

@visited:
	; Decide whether to display textbox at top or bottom
	ld c,$80		; $61a4

.ifdef ROM_SEASONS
	ld a,(wMapMenu.mode) ; Check if in subrosia
	rrca
	jr nc,+
	ld c,$40
+
.endif
	ld a,(wMapMenu.cursorIndex)		; $61a6
	cp c			; $61a9
	ld a,$03		; $61aa
	jr c,+			; $61ac
	xor a			; $61ae
+
	ld (wTextboxPosition),a		; $61af

	ld a,TEXTBOXFLAG_NOCOLORS | TEXTBOXFLAG_DONTCHECKPOSITION	; $61b2
	ld (wTextboxFlags),a		; $61b4

	; Fall through

;;
; Like function above, but doesn't set textbox variables, and always returns properly.
;
; @param[out]	bc	Text to show for selected room on the map
; @addr{61b7}
_mapGetRoomText:
	call _mapGetRoomIndexWithoutUnusedColumns		; $61b7
	ld hl,presentMapTextIndices		; $61ba
	jr nc,+			; $61bd
	ld hl,pastMapTextIndices		; $61bf
+
	ld b,>TX_0300		; $61c2
	rst_addAToHl			; $61c4
	ld c,(hl)		; $61c5
	bit 7,c			; $61c6
	ret z			; $61c8

	; If bit 7 was set in "present/pastMapTextIndices", run some special-case code.
	ld a,c			; $61c9
	and $07			; $61ca
	rst_jumpTable			; $61cc
.dw @specialCode0
.dw @specialCode1
.dw @specialCode2
.dw @specialCode3
.dw @specialCode4

; Maku tree: text varies based on the point in the game the player is at
@specialCode0:

.ifdef ROM_SEASONS
	; Check if Link has met the maku tree
	ld a,GLOBALFLAG_S_18
	call checkGlobalFlag
	ld c,<TX_0317
	ret z

	; If so, use the appropriate text
	ld a,($c6e5)
	ld c,a
	ld b,>TX_1700
	ret

.else; ROM_AGES

	push de			; $61d7
	ld a,(wAreaFlags)		; $61d8
	rlca			; $61db
	ld de,wMakuMapTextPresent		; $61dc
	ld c,<TX_0323		; $61df
	ld a,GLOBALFLAG_MAKU_GIVES_ADVICE_FROM_PRESENT_MAP		; $61e1
	jr nc,+			; $61e3

	inc e ; e = wMakuMapTextPast
	inc c ; c = <TX_0324
	inc a ; a = GLOBALFLAG_MAKU_GIVES_ADVICE_FROM_PAST_MAP
+
	; Check if Link has met the maku tree (in the appropriate era)
	call checkGlobalFlag		; $61e8
	ld l,e			; $61eb
	ld h,d			; $61ec
	pop de			; $61ed
	ret z			; $61ee

	; If so, use the appropriate text
	ld a,(hl)		; $61ef
	ld c,a			; $61f0
	ld b,>TX_0500		; $61f1
	ret			; $61f3

.endif ; ROM_AGES


; Dungeons, other unlocked entrances use this?
; After a dungeon has been visited, the overworld map will say the dungeon's name.
; Upper 5 bits of 'c' indicate the "index" to use in a table lookup.
@specialCode1:
	ld a,c			; $61f4
	add a			; $61f5
	swap a			; $61f6
	and $0f			; $61f8
	ld c,a			; $61fa
	call @checkDungeonEntered		; $61fb
	jr nz,+			; $61fe
	ld a,(hl)		; $6200
	and $7f			; $6201
	ld c,a			; $6203
	ret			; $6204
+
	ld b,>TX_0200		; $6205
	ret			; $6207

; Moblin's keep
@specialCode2:
	call _checkMoblinsKeepDestroyed		; $6208
.ifdef ROM_AGES
	ld c,<TX_0317		; $620b
.else
	ld c,<TX_030b
.endif
	ret nz			; $620d
	inc c			; $620e
	ret			; $620f

; Animal companion regions (not used in ages)
@specialCode3:
	ld a,(wAnimalCompanion)		; $6210
	sub SPECIALOBJECTID_RICKY			; $6213
.ifdef ROM_AGES
	add <TX_032d			; $6215
.else; ROM_SEASONS
	add <TX_0308
.endif
	ld c,a			; $6217
	ret			; $6218

; Advance shop: only show the text it's been visited.
@specialCode4:
	call _checkAdvanceShopVisited		; $6219

.ifdef ROM_AGES
	ld c,<TX_0326		; $621c
	ret z			; $621e
	dec c			; $621f
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
; @addr{6221}
@checkDungeonEntered:
	push de			; $6221
	ld hl,_mapMenu_dungeonEntranceText		; $6222
	rst_addDoubleIndex			; $6225
	ldi a,(hl)		; $6226
	ld e,a			; $6227
	bit 7,(hl)		; $6228
	ld d,>wGroup4Flags		; $622a
	jr nz,+			; $622c
	inc d			; $622e
+
	ld a,(de)		; $622f
	bit 4,a			; $6230
	pop de			; $6232
	ret			; $6233

;;
; Checks for popups that should appear? (ie. house, gasha spot)
;
; @addr{6234}
_mapMenu_loadPopupData:
	call _mapMenu_checkCursorRoomVisited		; $6234
	jr z,@noIcon		; $6237

	ld hl,presentMinimapPopups		; $6239
	ld a,(wMapMenu.mode)		; $623c
	rrca			; $623f
	jr nc,+			; $6240
	ld hl,pastMinimapPopups		; $6242
+
	ld a,(wMapMenu.cursorIndex)		; $6245
	ld c,a			; $6248

	@loop:
		ldi a,(hl)		; $6249
		cp $ff			; $624a
		jr z,@noIcon		; $624c
		cp c			; $624e
		ldi a,(hl)		; $624f
		jr nz,@loop		; $6250
	jr @gotIcon		; $6252

@noIcon:
	xor a			; $6254
@gotIcon:
	ld d,a			; $6255
	swap a			; $6256
	call _getMinimapPopupType		; $6258
	ld (wMapMenu.popup2),a		; $625b
	ld a,d			; $625e
	call _getMinimapPopupType		; $625f
	ld hl,wMapMenu.popup1		; $6262
	ldi (hl),a		; $6265
	or a			; $6266
	jr nz,+			; $6267
	ldd a,(hl)		; $6269
	ldi (hl),a		; $626a
+
	ldd a,(hl)		; $626b
	or a			; $626c
	jr nz,+			; $626d
	ldi a,(hl)		; $626f
	ldd (hl),a		; $6270
+
	; d/e: values to compare against wMapMenu.cursorIndex for when to shift the
	; popup icon's position
	ldde OVERWORD_MAP_POPUP_SHIFT_INDEX_Y<<4, OVERWORD_MAP_POPUP_SHIFT_INDEX_X

.ifdef ROM_SEASONS
	; Check for subrosia
	ld a,(wMapMenu.mode)		; $616d
	rrca			; $6170
	jr nc,+			; $6171
	ldde SUBROSIA_MAP_POPUP_SHIFT_INDEX_Y<<4, SUBROSIA_MAP_POPUP_SHIFT_INDEX_X
+
.endif
	; b/c: position at which to place the popup (may change according to d/e)
	ldbc $20,$80		; $6274

	ld a,(wMapMenu.cursorIndex)		; $6277
	cp d			; $627a
	jr c,+			; $627b
	ld b,$70		; $627d
+
	and $0f			; $627f
	cp e			; $6281
	jr c,+			; $6282
	ld c,$20		; $6284
+
	; Got position of popup in bc
	ld hl,wMapMenu.popupY		; $6286
	ld a,(hl)		; $6289
	ld (hl),b		; $628a
	inc l			; $628b
	sub b			; $628c
	ld b,a			; $628d
	ld a,(hl)		; $628e
	ld (hl),c		; $628f

	; Check if the position of the popup changed; reset the popup state if so.
	sub c			; $6290
	or b			; $6291
	ret z			; $6292
	ld l,<wMapMenu.popupState		; $6293
	ld (hl),$00		; $6295
	ret			; $6297

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
; @addr{6298}
_getMinimapPopupType:
	and $0f			; $6298
	ld e,a			; $629a
	rst_jumpTable			; $629b

.ifdef ROM_AGES
	.dw _minimapPopupType_normal
	.dw _minimapPopupType_normal	; present house
	.dw _minimapPopupType_normal	; tokay hut
	.dw _minimapPopupType_normal	; past house
	.dw _minimapPopupType_makuTree
	.dw _minimapPopupType_normal	; eyeglass library
	.dw _minimapPopupType_normal	; shooting gallery
	.dw _minimapPopupType_vasuOrSyrup
	.dw _minimapPopupType_cave
	.dw _minimapPopupType_gashaSpot
	.dw _minimapPopupType_portalSpot
	.dw _minimapPopupType_advanceShop
	.dw _minimapPopupType_shop
	.dw _minimapPopupType_moblinsKeep
	.dw _minimapPopupType_blackTower
	.dw _minimapPopupType_seedTree

.else; ROM_SEASONS

	.dw _minimapPopupType_normal
	.dw _minimapPopupType_normal
	.dw _minimapPopupType_advanceShop
	.dw _minimapPopupType_normal
	.dw _minimapPopupType_normal
	.dw _minimapPopupType_normal
	.dw _minimapPopupType_normal
	.dw _minimapPopupType_normal
	.dw _minimapPopupType_cave
	.dw _minimapPopupType_gashaSpot
	.dw _minimapPopupType_portalSpot
	.dw _minimapPopupType_pirateShip
	.dw _minimapPopupType_shop
	.dw _minimapPopupType_moblinsKeep
	.dw _minimapPopupType_templeOfSeasons
	.dw _minimapPopupType_seedTree
.endif

_minimapPopupType_normal:
	ld a,e			; $62bc
	ret			; $62bd

_minimapPopupType_advanceShop:
	call _checkAdvanceShopVisited		; $62be
	ret z			; $62c1
	ld a,$0e		; $62c2
	ret			; $62c4


; Check if a cave was unlocked (based on text index being displayed), show popup if so
_minimapPopupType_cave:
	ld a,(wMapMenu.cursorIndex)		; $62c5
	call _mapGetRoomText		; $62c8
	ld a,$02		; $62cb
	cp b			; $62cd
	jr nz,_minimapNoPopup	; $62ce
	ld a,e			; $62d0
	ret			; $62d1


_minimapPopupType_gashaSpot:
	ld a,(wMapMenu.cursorIndex)		; $62d2
	call getIndexOfGashaSpotInRoom		; $62d5
	bit 7,c			; $62d8
	jr nz,_minimapNoPopup	; $62da
	ld a,e			; $62dc
	ret			; $62dd


; Area on map with dormant time portal (or subrosia portal for seasons?)
_minimapPopupType_portalSpot:
	ld hl,wPresentRoomFlags		; $62de
	ld a,(wMapMenu.mode)		; $62e1
	rrca			; $62e4
	jr nc,+			; $62e5
	ld hl,wPastRoomFlags		; $62e7
+
	ld a,(wMapMenu.cursorIndex)		; $62ea
	rst_addAToHl			; $62ed
	bit ROOMFLAG_BIT_PORTALSPOT_DISCOVERED,(hl)		; $62ee
	jr z,_minimapNoPopup	; $62f0
	ld a,e			; $62f2
	ret			; $62f3

_minimapPopupType_seedTree:
	ld a,(wMapMenu.cursorIndex)		; $62f4
	call _getTreeWarpDataForRoom		; $62f7
	ret c			; $62fa
	inc hl			; $62fb
	ld a,(hl)		; $62fc
	ret			; $62fd

_minimapPopupType_moblinsKeep:
	call _checkMoblinsKeepDestroyed		; $62fe
	ld a,$0f		; $6301
	ret z			; $6303
	inc a			; $6304
	ret			; $6305

_minimapNoPopup:
	xor a			; $6306
	ret			; $6307

_minimapPopupType_shop:

.ifdef ROM_AGES
	ld a,$0e		; $6308
	ret			; $630a

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

_minimapPopupType_vasuOrSyrup:
	ld a,(wMapMenu.cursorIndex)		; $630b
	cp $5d			; $630e
	ld a,$0c		; $6310
	ret z			; $6312
	inc a			; $6313
	ret			; $6314

_minimapPopupType_blackTower:
	call getBlackTowerProgress		; $6315
	add $11			; $6318
	ret			; $631a

_minimapPopupType_makuTree:
	ld a,(wAreaFlags)		; $631b
	rlca			; $631e
	ld a,$0b		; $631f
	ret c			; $6321
	ld hl,wPresentRoomFlags+$38		; $6322
	bit 0,(hl)		; $6325
	ld a,$04		; $6327
	ret z			; $6329
	ld a,$07		; $632a
	ret			; $632c

.else; ROM_SEASONS


; Separate popups for each season
_minimapPopupType_templeOfSeasons:
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
_minimapPopupType_pirateShip:
	call _checkPirateShipMoved
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
	jr z,_minimapNoPopup
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
; @addr{632d}
_maupMenu_drawPopup:
	call @updatePopupVariables		; $632d
	ld hl,wMapMenu.popupY		; $6330
	ldi a,(hl)		; $6333
	ld c,(hl)		; $6334
	ld b,a			; $6335

	; If it hasn't finished expanding yet, don't draw the contents of the popup
	ld a,(wMapMenu.popupSize)		; $6336
	cp $04			; $6339
	jr nz,@drawBorder	; $633b

; Draw the "inside" of the icon
	push bc			; $633d
	ld a,(wMapMenu.popupIndex)		; $633e
	and $01			; $6341
	ld hl,wMapMenu.popup1		; $6343
	rst_addAToHl			; $6346

	ld a,(hl)		; $6347
	ld hl,mapIconOamTable		; $6348
	rst_addAToHl			; $634b
	ld a,(hl)		; $634c
	rst_addAToHl			; $634d
	call addSpritesToOam_withOffset		; $634e
	pop bc			; $6351

; Draw the "border" of the icon (or the whole thing while it's still expanding)
@drawBorder:
	ld a,(wMapMenu.popupSize)		; $6352
	ld hl,mapIconBorderOamTable		; $6355
	rst_addAToHl			; $6358
	ld a,(hl)		; $6359
	rst_addAToHl			; $635a
	jp addSpritesToOam_withOffset		; $635b

;;
; Update the popup icon on the map.
; @addr{635e}
@updatePopupVariables:
	ld de,wMapMenu.popupState		; $635e
	ld a,(de)		; $6361
	rst_jumpTable			; $6362
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call @checkPopupExists		; $636b
	jr z,@resetPopup			; $636e

	; Go to state 1
	ld a,$01		; $6370
	ld (de),a		; $6372

	ld e,<wMapMenu.popupSize		; $6373
	ld (de),a		; $6375
	ld e,<wTmpcbba		; $6376
	inc a			; $6378
	ld (de),a		; $6379
	ret			; $637a

@resetPopup:
	xor a			; $637b
	ld hl,wMapMenu.popupState		; $637c
	ldi (hl),a		; $637f
	; wTmpcbba
	ldi (hl),a		; $6380

	ld l,<wMapMenu.popupSize		; $6381
	ld (hl),a		; $6383
	ld l,<wTmpcbc0		; $6384
	ld (hl),a		; $6386
	ret			; $6387

@state1:
	call @checkPopupExists		; $6388
	jr z,@gotoState3	; $638b
	ld l,<wTmpcbba		; $638d
	dec (hl)		; $638f
	ret nz			; $6390
	ld (hl),$02		; $6391
	ld l,<wMapMenu.popupSize		; $6393
	inc (hl)		; $6395
	ld a,(hl)		; $6396
	cp $04			; $6397
	ret c			; $6399
	ld l,<wTmpcbba		; $639a
	ld (hl),$18		; $639c
	ld l,<wMapMenu.popupState		; $639e
	ld (hl),$02		; $63a0

@state2:
	call @checkPopupExists		; $63a2
	jr z,@gotoState3	; $63a5

	ld l,<wTmpcbba		; $63a7
	dec (hl)		; $63a9
	ret nz			; $63aa

	ld (hl),$18		; $63ab
	ld l,<wTmpcbc0		; $63ad
	ld a,(hl)		; $63af
	xor $01			; $63b0
	ld (hl),a		; $63b2
	ret			; $63b3

@gotoState3:
	ld h,d			; $63b4
	ld l,<wMapMenu.popupState		; $63b5
	ld (hl),$03		; $63b7
	ld l,<wTmpcbba		; $63b9
	ld (hl),$01		; $63bb

@state3:
	ld h,d			; $63bd
	ld l,<wTmpcbba		; $63be
	dec (hl)		; $63c0
	ret nz			; $63c1

	ld (hl),$02		; $63c2
	ld l,<wMapMenu.popupSize		; $63c4
	ld a,(hl)		; $63c6
	dec a			; $63c7
	ld (hl),a		; $63c8
	ret nz			; $63c9
	jr @resetPopup		; $63ca

;;
; @param[out]	zflag	Set if there is no popup to display.
@checkPopupExists:
	ld h,d			; $63cc
	ld l,<wMapMenu.popup1		; $63cd
	ldi a,(hl)		; $63cf
	or (hl)			; $63d0
	ret			; $63d1

;;
; Checks if pressed up or down on dungeon map, updates accordingly.
;
; @addr{63d2}
_dungeonMap_checkDirectionButtons:
	ld a,(wSubmenuState)		; $63d2
	rst_jumpTable			; $63d5
	.dw _dungeonMap_scrollingState0
	.dw _dungeonMap_scrollingState1

;;
; Dungeon map: waiting for input to scroll up/down
;
; @addr{63da}
_dungeonMap_scrollingState0:
	call getInputWithAutofire		; $63da
	bit BTN_BIT_DOWN,a			; $63dd
	jr z,+			; $63df

	call _dungeonMap_checkCanScrollDown		; $63e1
	jr nz,@moveUpOrDown		; $63e4
	ret			; $63e6
+
	bit BTN_BIT_UP,a			; $63e7
	ret z			; $63e9
	call _dungeonMap_checkCanScrollUp		; $63ea
	ret z			; $63ed

@moveUpOrDown:
	ld c,a			; $63ee
	ld a,b			; $63ef
	ld (wMapMenu.currentRoom),a		; $63f0
	or a			; $63f3
	jr z,+			; $63f4

	; down
	ld a,(wMapMenu.floorIndex)		; $63f6
	add c			; $63f9
	ld (wMapMenu.floorIndex),a		; $63fa
	jr ++		; $63fd
+
	; up
	ld a,(wMapMenu.floorIndex)		; $63ff
	sub c			; $6402
	ld (wMapMenu.floorIndex),a		; $6403
++
	ld a,c			; $6406
	ld d,a			; $6407
	call multiplyABy8		; $6408
	ld a,d			; $640b
	add a			; $640c
	add c			; $640d
	inc a			; $640e
	ld (wMapMenu.varcbb4),a		; $640f
	ld hl,wSubmenuState		; $6412
	inc (hl)		; $6415
	ld a,SND_MENU_MOVE		; $6416
	jp playSound		; $6418

;;
; @param[out]	a	Value to add or remove from floor number
; @param[out]	b	$01 to indicate downward direction
; @param[out]	zflag	Set if we're on the bottom floor already.
; @addr{641b}
_dungeonMap_checkCanScrollDown:
	; Check if we're on the bottom floor.
	push de			; $641b
	ld a,(wDungeonNumFloors)		; $641c
	dec a			; $641f
	ld b,a			; $6420
	ld a,(wMapMenu.floorIndex)		; $6421
	cp b			; $6424
	jr z,@failure		; $6425

	; If Link has the map, it's ok to move down.
	call _checkLinkHasMap		; $6427
	ld a,$01		; $642a
	jr nz,@ret	; $642c

	; Otherwise, we must check if the floor we want to go to has been visited.
	ld a,(wMapMenu.floorIndex)		; $642e
	ld c,a			; $6431
	ld a,(wDungeonNumFloors)		; $6432
	dec a			; $6435
	sub c			; $6436
	ld c,a			; $6437
	ld e,a			; $6438
	ld d,$00		; $6439
--
	inc d			; $643b
	ld a,e			; $643c
	sub d			; $643d
	ld hl,bitTable		; $643e
	add l			; $6441
	ld l,a			; $6442
	ld b,(hl)		; $6443
	ld a,(wMapMenu.visitedFloors)		; $6444
	and b			; $6447
	ld a,d			; $6448
	jr nz,@ret	; $6449
	dec c			; $644b
	jr nz,--		; $644c

@failure:
	xor a			; $644e
@ret:
	ld b,$01		; $644f
	or a			; $6451
	pop de			; $6452
	ret			; $6453

;;
; @param[out]	a	Value to add or remove from floor number
; @param[out]	b	$00 to indicate downward direction
; @param[out]	zflag	Set if we're on the top floor already.
; @addr{6454}
_dungeonMap_checkCanScrollUp:
	; Check if we're on the top floor.
	push de			; $6454
	ld a,(wMapMenu.floorIndex)		; $6455
	or a			; $6458
	jr z,@failure		; $6459

	; If Link has the map, it's ok to move up.
	call _checkLinkHasMap		; $645b
	ld a,$01		; $645e
	jr nz,@ret	; $6460

	; Otherwise, we must check if the floor we want to go to has been visited.
	ld a,(wMapMenu.floorIndex)		; $6462
	ld e,a			; $6465
	ld a,(wDungeonNumFloors)		; $6466
	dec a			; $6469
	sub e			; $646a
	ld c,e			; $646b
	ld e,a			; $646c
	ld d,$00		; $646d
--
	inc d			; $646f
	ld a,e			; $6470
	add d			; $6471
	ld hl,bitTable		; $6472
	add l			; $6475
	ld l,a			; $6476
	ld b,(hl)		; $6477
	ld a,(wMapMenu.visitedFloors)		; $6478
	and b			; $647b
	ld a,d			; $647c
	jr nz,@ret	; $647d
	dec c			; $647f
	jr nz,--		; $6480

@failure:
	xor a			; $6482
@ret:
	ld b,$00		; $6483
	or a			; $6485
	pop de			; $6486
	ret			; $6487


;;
; Dungeon map: currently scrolling up or down a floor
;
; @addr{6488}
_dungeonMap_scrollingState1:
	ld hl,wMapMenu.varcbb4		; $6488
	dec (hl)		; $648b
	jr nz,++			; $648c

	; Done scrolling
	xor a			; $648e
	ld (wSubmenuState),a		; $648f
	ret			; $6492
++
	; In the process of scrolling.
	ld a,(wMapMenu.currentRoom) ; Get scroll direction
	or a			; $6496
	ld a,$ff		; $6497
	jr z,+			; $6499
	ld a,$01		; $649b
+
	ld hl,wMapMenu.dungeonScrollY		; $649d
	add (hl)		; $64a0
	ld (hl),a		; $64a1
	call _dungeonMap_updateScroll		; $64a2

	; Fall through

;;
; @addr{64a5}
_mapMenu_copyTilemapToVram:
	xor a			; $64a5
	ld (wStatusBarNeedsRefresh),a		; $64a6
	ld a,UNCMP_GFXH_0a		; $64a9
	jp loadUncompressedGfxHeader		; $64ab

;;
; A lot of maps call this as regular updating code.
;
; @addr{64ae}
_mapMenu_drawSprites:
	ld a,(wMapMenu.mode)		; $64ae
	cp $02			; $64b1
	jr nz,@overworld	; $64b3

@dungeon:
	call _dungeonMap_drawItemSprites		; $64b5
	call _dungeonMap_drawLinkIcons		; $64b8
	call _dungeonMap_drawCursor		; $64bb
	call _dungeonMap_drawArrows		; $64be
	call _dungeonMap_drawBossSymbolForFloor		; $64c1
	jp _dungeonMap_drawFloorCursor		; $64c4

@overworld:
	call _maupMenu_drawPopup		; $64c7
	call _mapMenu_drawArrow		; $64ca
	call _mapMenu_drawCursor		; $64cd
	ld a,(wMapMenu.drawWarpDestinations)		; $64d0
	or a			; $64d3
	jp nz,_mapMenu_drawWarpSites		; $64d4

.ifdef ROM_AGES
	jp _mapMenu_drawTimePortal		; $64d7

.else; ROM_SEASONS

	jp _mapMenu_drawJewelLocations
.endif

;;
; Draws small key, boss key, compass, and map on the map screen if Link has them.
;
; @addr{64da}
_dungeonMap_drawItemSprites:
	call _getNumSmallKeys		; $64da
	ld hl,@smallKeySprite		; $64dd
	call nz,addSpritesToOam		; $64e0

	call _checkLinkHasBossKey		; $64e3
	ld hl,@bossKeySprite		; $64e6
	call nz,addSpritesToOam		; $64e9

	call _checkLinkHasCompass		; $64ec
	ld hl,@compassSprite		; $64ef
	call nz,addSpritesToOam		; $64f2

	call _checkLinkHasMap		; $64f5
	ld hl,@mapSprite		; $64f8
	call nz,addSpritesToOam		; $64fb
	ret			; $64fe

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
; @addr{651f}
_getNumSmallKeys:
	ld a,(wDungeonIndex)		; $651f
	ld hl,wDungeonSmallKeys		; $6522
	rst_addAToHl			; $6525
	ld a,(hl)		; $6526
	or a			; $6527
	ret			; $6528

;;
; @param[out]	zflag	nz if Link has the boss key for the current dungeon.
; @addr{6529}
_checkLinkHasBossKey:
	ld hl,wDungeonBossKeys		; $6529
	ld a,(wDungeonIndex)		; $652c
	jp checkFlag		; $652f

;;
; Unsets Z flag if link has the compass.
; @addr{6532}
_checkLinkHasCompass:
	push hl			; $6532
	ld hl,wDungeonCompasses		; $6533
	ld a,(wDungeonIndex)		; $6536
	call checkFlag		; $6539
	pop hl			; $653c
	ret			; $653d

;;
; Unsets Z flag if link has the map.
_checkLinkHasMap:
	push hl			; $653e
	ld hl,wDungeonMaps		; $653f
	ld a,(wDungeonIndex)		; $6542
	call checkFlag		; $6545
	pop hl			; $6548
	ret			; $6549

;;
; @addr{654a}
_dungeonMap_drawFloorCursor:
	ld a,(wDungeonIndex)		; $654a
	ld hl,_dungeonMapSymbolPositions		; $654d
	rst_addDoubleIndex			; $6550

	ld a,(wMapMenu.floorIndex)		; $6551
	swap a			; $6554
	rrca			; $6556
	add (hl)		; $6557

	ld b,a			; $6558
	ld c,$00		; $6559
	ld hl,@cursorOamData		; $655b
	jp addSpritesToOam_withOffset		; $655e

@cursorOamData:
	.db $01
	.db $00 $1e $84 $04

;;
; On the dungeon map, this draws the boss symbol next to its floor.
; @addr{6566}
_dungeonMap_drawBossSymbolForFloor:
	call _checkLinkHasCompass		; $6566
	ret z			; $6569

	ld a,(wDungeonIndex)		; $656a
	ld hl,_dungeonMapSymbolPositions+1		; $656d
	rst_addDoubleIndex			; $6570

	ld b,(hl)		; $6571
	ld c,$00		; $6572
	ld hl,@bossSymbolOamData		; $6574
	jp addSpritesToOam_withOffset		; $6577

@bossSymbolOamData:
	.db $01
	.db $00 $38 $82 $05

;;
; @addr{657f}
_dungeonMap_drawLinkIcons:
	; Check whether to draw the Link icon on the map.
	ld a,(wMapMenu.dungeonCursorFlicker)		; $657f
	or a			; $6582
	jr z,++			; $6583

	; Get the position of Link's icon on the map, not accounting for scrolling.
	call _dungeonMap_getLinkIconPosition		; $6585
	ld hl,wMapMenu.dungeonScrollY		; $6588
	ld a,b			; $658b
	sub (hl)		; $658c
	cp $12			; $658d
	jr nc,++		; $658f

	; Multiply position by 8
	inc a			; $6591
	swap a			; $6592
	rrca			; $6594
	ld b,a			; $6595
	swap c			; $6596
	rrc c			; $6598

	; Draw the Link icon on the map.
	ld hl,@linkOnMapOamData		; $659a
	call addSpritesToOam_withOffset		; $659d

++
	; Draw the Link icon on the floor list

	ld a,(wDungeonIndex)		; $65a0
	ld hl,_dungeonMapSymbolPositions		; $65a3
	rst_addDoubleIndex			; $65a6

	; Calculate Y position
	ld a,(wMapMenu.linkFloor)		; $65a7
	ld c,a			; $65aa
	ld a,(wDungeonNumFloors)		; $65ab
	dec a			; $65ae
	sub c			; $65af
	swap a			; $65b0
	rrca			; $65b2
	add (hl)		; $65b3

	ld b,a			; $65b4
	ld c,$00		; $65b5
	ld hl,@linkOnFloorListOamData		; $65b7
	jp addSpritesToOam_withOffset		; $65ba

@linkOnMapOamData:
	.db $01
	.db $00 $58 $80 $00

@linkOnFloorListOamData:
	.db $01
	.db $00 $2c $80 $00

;;
; @addr{65c7}
_dungeonMap_updateCursorFlickerCounter:
	ld a,(wFrameCounter)		; $65c7
	and $1f			; $65ca
	ret nz			; $65cc
	ld hl,wMapMenu.dungeonCursorFlicker		; $65cd
	ld a,(hl)		; $65d0
	xor $01			; $65d1
	ld (hl),a		; $65d3
	ret			; $65d4

;;
; @addr{65d5}
_dungeonMap_drawCursor:
	; Return if scrolling
	ld a,(wSubmenuState)		; $65d5
	or a			; $65d8
	ret nz			; $65d9

	; Check cursor flicker cycle
	ld a,(wMapMenu.dungeonCursorFlicker)		; $65da
	or a			; $65dd
	ret nz			; $65de

	; Calculate position to draw cursor at
	ld a,(wMapMenu.dungeonCursorIndex)		; $65df
	and $f8			; $65e2
	ld b,a			; $65e4
	ld a,(wMapMenu.dungeonCursorIndex)		; $65e5
	and $07			; $65e8
	add a			; $65ea
	add a			; $65eb
	add a			; $65ec
	ld c,a			; $65ed
	ld hl,@cursorSprites		; $65ee
	jp addSpritesToOam_withOffset		; $65f1

@cursorSprites:
	.db $02
	.db $34 $54 $88 $04
	.db $34 $5c $88 $24

;;
; Draws the up/down arrows on the dungeon map, assuming it's possible to scroll in those
; directions.
;
; @addr{65fd}
_dungeonMap_drawArrows:
	; Return if map is scrolling
	ld a,(wSubmenuState)		; $65fd
	or a			; $6600
	ret nz			; $6601

	; Check if we can scroll up
	call _dungeonMap_checkCanScrollUp		; $6602
	jr z,+			; $6605
	ld hl,@upArrow		; $6607
	call addSpritesToOam		; $660a
+
	; Check if we can scroll down
	call _dungeonMap_checkCanScrollDown		; $660d
	ret z			; $6610
	ld hl,@downArrow		; $6611
	jp addSpritesToOam		; $6614

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
; @param[out]	cflag	Set if AREAFLAG_PAST/AREAFLAG_SUBROSIA is set
; @addr{6621}
_mapGetRoomIndexWithoutUnusedColumns:

.ifdef ROM_AGES
	push bc			; $6621

	; b = [wMapMenu.cursorIndex]-cursorY*2. Skips over the two unused columns.
	ld a,(wMapMenu.cursorIndex)		; $6622
	ld b,a			; $6625
	and $f0			; $6626
	swap a			; $6628
	add a			; $662a
	ld c,a			; $662b
	ld a,b			; $662c
	sub c			; $662d
	ld b,a			; $662e

	; cflag = AREAFLAG_PAST
	ld a,(wAreaFlags)		; $662f
	rlca			; $6632

	ld a,b			; $6633
	pop bc			; $6634
	ret			; $6635

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
; @addr{6636}
_mapMenu_checkCursorRoomVisited:
	ld a,(wMapMenu.cursorIndex)		; $6636

;;
; @param	a	Room to check
; @param[out]	zflag	nz if room has been visited
; @addr{6639}
_mapMenu_checkRoomVisited:
	push hl			; $6639
	ld h,a			; $663a
	ld a,(wMapMenu.mode)		; $663b
	rrca			; $663e
	ld a,h			; $663f
	ld hl,wPastRoomFlags		; $6640
	jr c,++			; $6643

	ld hl,wPresentRoomFlags		; $6645

.ifdef ROM_SEASONS
	; Special-case for the sword upgrade screen
	cp $c9
	jr nz,++
	ld hl,wPastRoomFlags+$0b
	xor a
.endif

++
	rst_addAToHl			; $6648
	ld a,(hl)		; $6649
	bit 4,a			; $664a
	pop hl			; $664c
	ret			; $664d

;;
; @addr{664e}
_mapMenu_drawArrow:
	ld a,(wFrameCounter)		; $664e
	and $20			; $6651
	ret nz			; $6653
	ld hl,@sprite		; $6654
	ld a,(wMapMenu.currentRoom)		; $6657
	jr _mapMenu_drawSpriteAtRoomIndex			; $665a

@sprite:
	.db $01
	.db $06 $08 $0e $47

;;
; @addr{6661}
_mapMenu_drawCursor:
	ld hl,@sprite		; $6661
	ld a,(wMapMenu.cursorIndex)		; $6664
	jr _mapMenu_drawSpriteAtRoomIndex			; $6667

@sprite:
	.db $02
	.db $0c $04 $88 $06
	.db $0c $0c $88 $26

;;
; Draws a given sprite at a position on the map grid.
;
; @param	a	Room index
; @param	hl	Pointer to sprite data
; @addr{6672}
_mapMenu_drawSpriteAtRoomIndex:
	ld c,a			; $6672
	ldde OVERWORLD_MAP_START_Y*8, OVERWORLD_MAP_START_X*8		; $6673

.ifdef ROM_SEASONS
	; Check for subrosia
	ld a,(wMapMenu.mode)
	rrca
	jr nc,+
	ldde SUBROSIA_MAP_START_Y*8, SUBROSIA_MAP_START_X*8		; $6673
+
.endif

	; Calculate sprite offset
	ld a,c			; $6676
	and $f0			; $6677
	srl a			; $6679
	add d			; $667b
	ld b,a			; $667c
	ld a,c			; $667d
	and $0f			; $667e
	add a			; $6680
	add a			; $6681
	add a			; $6682
	add e			; $6683
	ld c,a			; $6684
	jp addSpritesToOam_withOffset		; $6685

;;
; Draw all positions that Link can warp to on the map screen, using a circle marker.
;
; @addr{6688}
_mapMenu_drawWarpSites:
	; Use wTmpcec0 as a place to store and modify the OAM data to be drawn
	ld de,@spriteData		; $6688
	ld hl,wTmpcec0		; $668b
	ld b,$05		; $668e
	call copyMemoryReverse		; $6690

	; Set the frame of animation to use
	ld a,(wFrameCounter)		; $6693
	and $18			; $6696
	rrca			; $6698
	rrca			; $6699
	ld l,<wTmpcec0+3		; $669a
	add (hl)		; $669c
	ld (hl),a		; $669d

	; Iterate through each warp position
	ld c,$00		; $669e
@drawWarpDest:
	ld a,c			; $66a0
	call _getTreeWarpDataIndex		; $66a1
	ldi a,(hl)		; $66a4
	or a			; $66a5
	ret z			; $66a6

	; Check if we've visited this room
	push bc			; $66a7
	ld c,a			; $66a8
	call _mapMenu_checkRoomVisited		; $66a9
	jr z,@nextTree		; $66ac

	; If so, draw the sprite
	ld a,c			; $66ae
	ld hl,wTmpcec0		; $66af
	call _mapMenu_drawSpriteAtRoomIndex		; $66b2
@nextTree:
	pop bc			; $66b5
	inc c			; $66b6
	jr @drawWarpDest		; $66b7

; The "circle" sprite that marks warp destinations
@spriteData:
	.db $01
	.db $0c $08 $10 $07

;;
; Returns an entry in the "Tree Warp Data" for the current age.
;
; @param	a	Entry index
; @addr{66be}
_getTreeWarpDataIndex:
	ld c,a			; $66be
	call _getWarpTreeData		; $66bf
	add a			; $66c2
	add c			; $66c3
	rst_addAToHl			; $66c4
	ret			; $66c5

;;
; Takes a room index (for the current age) and gets the corresponding tree warp data, if
; it exists.
;
; @param	a	Room index
; @param[out]	hl	Pointer to last 2 bytes of tree warp data
; @param[out]	cflag	Set on failure (no tree exists for this room)
; @addr{66c6}
_getTreeWarpDataForRoom:
	ld c,a			; $66c6
	call _getWarpTreeData		; $66c7
--
	ldi a,(hl)		; $66ca
	or a			; $66cb
	scf			; $66cc
	ret z			; $66cd
	cp c			; $66ce
	ret z			; $66cf
	inc hl			; $66d0
	inc hl			; $66d1
	jr --			; $66d2

;;
; See data/[game]/treeWarps.s.
;
; @param[out]	hl	Address of "warp tree" data structure for appropriate age.
; @addr{66d4}
_getWarpTreeData:
	push af			; $66d4

.ifdef ROM_SEASONS
	ld hl,treeWarps		; $660d

.else; ROM_AGES
	; Check AREAFLAG_PAST
	ld hl,pastTreeWarps		; $66d5
	ld a,(wAreaFlags)		; $66d8
	rlca			; $66db
	jr c,@ret		; $66dc

	; If in the present, skip over the scent tree if seedling wasn't planted.
	ld hl,presentTreeWarps		; $66de
	ld a,(wPresentRoomFlags+$ac)		; $66e1
	rlca			; $66e4
	jr c,@ret		; $66e5
	ld a,$03		; $66e7
	rst_addAToHl			; $66e9
.endif

@ret:
	pop af			; $66ea
	ret			; $66eb


.ifdef ROM_AGES

;;
; Draws the time portal sprite on the map. (Ages only)
;
; @addr{66ec}
_mapMenu_drawTimePortal:
	; Use wTmpcec0 as a place to store and modify the OAM data to be drawn
	ld de,@portalSprite		; $66ec
	ld hl,wTmpcec0		; $66ef
	ld b,$05		; $66f2
	call copyMemoryReverse		; $66f4

	; Set the frame of animation to use
	ld l,<(wTmpcec0+3)		; $66f7
	ld a,(wFrameCounter)		; $66f9
	add a			; $66fc
	swap a			; $66fd
	and $03			; $66ff
	add a			; $6701
	add (hl)		; $6702
	ld (hl),a		; $6703

	; Check that the portal is in the map group we're currently in
	ld hl,wPortalGroup		; $6704
	ld a,(wAreaFlags)		; $6707
	rlca			; $670a
	and $01			; $670b
	cp (hl)			; $670d
	ret nz			; $670e

	inc l			; $670f
	ld a,(hl) ; hl = wPortalRoom
	ld hl,wTmpcec0		; $6711
	jp _mapMenu_drawSpriteAtRoomIndex		; $6714

@portalSprite:
	.db $01
	.db $0c $08 $18 $07


.else; ROM_SEASONS


;;
; Seasons only: draw the locations of the jewels if Link has the treasure map.
_mapMenu_drawJewelLocations:
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
	call _mapMenu_drawSpriteAtRoomIndex

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
;
; @addr{671c}
_mapMenu_clearUnvisitedTiles:
	ld a,:w4TileMap		; $671c
	ld ($ff00+R_SVBK),a	; $671e

	ldde OVERWORLD_HEIGHT, OVERWORLD_WIDTH		; $6720
	ld hl,w4TileMap + OVERWORLD_MAP_START_Y*$20 + OVERWORLD_MAP_START_X		; $6723

.ifdef ROM_SEASONS
	; Different dimensions for subrosia map
	ld a,(wMapMenu.mode)
	rrca
	jr nc,+
	ldde SUBROSIA_HEIGHT, SUBROSIA_WIDTH
	ld hl,w4TileMap + SUBROSIA_MAP_START_Y*$20 + SUBROSIA_MAP_START_X
+
.endif

	ld b,$00		; $6726

@rowLoop:
	ld c,$00		; $6728
	push de			; $672a

@columnLoop:
	ld a,b			; $672b
	swap a			; $672c
	add c			; $672e
	call _mapMenu_checkRoomVisited		; $672f
	jr nz,@nextTile		; $6732

	; Blank this tile
	ld (hl),$04		; $6734
	set 2,h			; $6736
	ld (hl),$0a		; $6738
	res 2,h			; $673a

@nextTile:
	inc hl			; $673c
	inc c			; $673d
	dec e			; $673e
	jr nz,@columnLoop	; $673f

	pop de			; $6741
	ld a,$20		; $6742
	sub e			; $6744
	rst_addAToHl			; $6745
	inc b			; $6746
	dec d			; $6747
	jr nz,@rowLoop		; $6748
	ret			; $674a

.ifdef ROM_SEASONS

;;
; @param[out]	zflag	nz if the pirate ship has moved
_checkPirateShipMoved:
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	jp checkGlobalFlag

.endif ; ROM_SEASONS

;;
; @param[out]	zflag	nz if moblin's keep is destroyed
; @addr{674b}
_checkMoblinsKeepDestroyed:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED		; $674b
	jp checkGlobalFlag		; $674d

;;
; @param[out]	zflag	nz if the shop has been visited
; @addr{6750}
_checkAdvanceShopVisited:

.ifdef ROM_AGES
	ld a,(wPastRoomFlags+$fe)		; $6750
.else
	ld a,(wPastRoomFlags+$af)
.endif
	and ROOMFLAG_VISITED			; $6753
	ret			; $6755


;;
; Gets the absolute position of Link's icon on the dungeon map (not accounting for
; scrolling).
;
; @param[out]	bc	Position to draw Link tile at (in tiles)
; @addr{6756}
_dungeonMap_getLinkIconPosition:
	ld a,(wMapMenu.linkFloor)		; $6756
	ld b,a			; $6759
	ld a,(wDungeonNumFloors)		; $675a
	dec a			; $675d
	sub b			; $675e

	; a *= 10 (there is a 10 tile gap between each floor)
	ld h,a			; $675f
	call multiplyABy8		; $6760
	ld a,h			; $6763
	add a			; $6764
	add c			; $6765

	add $05			; $6766
	ld b,a			; $6768

	; Now calculate the Y/X offsets within this floor
	ld a,(wMapMenu.dungeonCursorIndex)		; $6769
	and $f8			; $676c
	swap a			; $676e
	rlca			; $6770
	ld c,a			; $6771
	ld a,b			; $6772
	add c			; $6773
	ld b,a			; $6774
	ld a,(wMapMenu.dungeonCursorIndex)		; $6775
	and $07			; $6778
	ld c,a			; $677a
	ret			; $677b

;;
; Draws the floor list on the left side of the dungeon map menu.
; Called once when opening the dungeon map.
;
; @addr{677c}
_dungeonMap_drawFloorList:
	ld a,:w4TileMap		; $677c
	ld ($ff00+R_SVBK),a	; $677e

	ld a,(wDungeonIndex)		; $6780
	ld hl,_dungeonMapFloorListStartPositions		; $6783
	rst_addAToHl			; $6786
	ldi a,(hl)		; $6787
	ld de,w4TileMap+$a0		; $6788
	call addAToDe		; $678b

	ld a,(wDungeonNumFloors)		; $678e
	dec a			; $6791
	ld c,a			; $6792
@loop:
	call _checkLinkHasMap		; $6793
	jr nz,++		; $6796

	; If Link doesn't have the map, we need to check if we've visited this floor
	ld a,c			; $6798
	ld hl,bitTable		; $6799
	add l			; $679c
	ld l,a			; $679d
	ld a,(wMapMenu.visitedFloors)		; $679e
	and (hl)		; $67a1
	ld a,$20		; $67a2
	jr z,@nextFloor		; $67a4
++
	; Draw the floor name
	ld a,(wDungeonMapBaseFloor)		; $67a6
	add c			; $67a9
	ld hl,_dungeonMapFloorNameTiles		; $67aa
	rst_addDoubleIndex			; $67ad
	ld b,$02		; $67ae
	ldi a,(hl)		; $67b0
	call _drawTileABtoDE		; $67b1
	ldi a,(hl)		; $67b4
	call _drawTileABtoDE		; $67b5

	ld a,$9c ; 'F' for "floor"
	call _drawTileABtoDE		; $67ba

	; Draw 2-tile rectangular box representing the floor
	inc e			; $67bd
	ld b,$04		; $67be
	ld a,$aa		; $67c0
	call _drawTileABtoDE		; $67c2
	ld a,$ab		; $67c5
	call _drawTileABtoDE		; $67c7

	ld a,$1a		; $67ca
@nextFloor:
	call addAToDe		; $67cc
	ld a,c			; $67cf
	dec c			; $67d0
	or a			; $67d1
	jr nz,@loop		; $67d2
	ret			; $67d4

;;
; @param	a,b	Tile index/map to draw
; @param	de	Position in w4TileMap to draw to
; @addr{67d5}
_drawTileABtoDE:
	ld (de),a		; $67d5
	set 2,d			; $67d6
	ld a,b			; $67d8
	ld (de),a		; $67d9
	res 2,d			; $67da
	inc de			; $67dc
	ret			; $67dd

;;
; Generates the tilemap for the scrollable portion of the dungeon map and stores it in
; w4GfxBuf1. Called once when opening a dungeon map.
;
; @addr{67de}
_dungeonMap_generateScrollableTilemap:
	ld de,w4GfxBuf1		; $67de
	ld a,$28		; $67e1
	call @fillTileMapWithBlank		; $67e3

	ld a,(wDungeonNumFloors)		; $67e6
	ldh (<hFF8D),a	; $67e9
@nextFloor:
	ldh a,(<hFF8D)	; $67eb
	dec a			; $67ed
	call _dungeonMap_getFloorAddress		; $67ee
	call _dungeonMap_checkCanViewFloor		; $67f1
	ld a,$50		; $67f4
	jr z,@doneThisFloor		; $67f6

	ld a,$40		; $67f8
	ldh (<hFF8C),a	; $67fa
@nextTile:
	ld a,:w2DungeonLayout		; $67fc
	ld ($ff00+R_SVBK),a	; $67fe
	ldi a,(hl)		; $6800
	ld c,a			; $6801
	ld a,:w4GfxBuf1		; $6802
	ld ($ff00+R_SVBK),a	; $6804
	ld a,c			; $6806
	call _dungeonMap_getTileForRoom		; $6807
	ld (de),a		; $680a
	inc de			; $680b
	ldh a,(<hFF8C)	; $680c
	dec a			; $680e
	ldh (<hFF8C),a	; $680f
	jr nz,@nextTile		; $6811

	; Fill 2 rows in-between with black
	ld a,$10		; $6813

@doneThisFloor:
	call @fillTileMapWithBlank		; $6815

	ldh a,(<hFF8D)	; $6818
	dec a			; $681a
	ldh (<hFF8D),a	; $681b
	jr nz,@nextFloor	; $681d

	; Fill another 3 rows with black
	ld a,$18		; $681f

;;
; @param	a	Number of tiles to fill horizontally
; @param	de	Address to start at
; @addr{6821}
@fillTileMapWithBlank:
	push bc			; $6821
	ld c,a			; $6822
	ld a,$ad ; Blank tile (outside of map region)
--
	ld (de),a		; $6825
	inc de			; $6826
	dec c			; $6827
	jr nz,--		; $6828
	pop bc			; $682a
	ret			; $682b

;;
; Redraws the tilemap for the dungeon map screen.
;
; Prior to calling this, w4GfxBuf stores the tilemap to be scrolled through.
;
; @addr{682c}
_dungeonMap_updateScroll:
	ld a,($ff00+R_SVBK)	; $682c
	push af			; $682e
	ld a,(wMapMenu.dungeonScrollY)		; $682f
	call multiplyABy8		; $6832
	ld hl,w4GfxBuf1		; $6835
	add hl,bc		; $6838
	ld de,w4TileMap+$0a		; $6839

	; Iterate through 18 rows (height of screen)
	ld a,18		; $683c
	ldh (<hFF8D),a	; $683e

@nextRow:
	ld c,$08		; $6840
@nextColumn:
	ld a,:w4GfxBuf1		; $6842
	ld ($ff00+R_SVBK),a	; $6844

	; a = tile index
	ld a,(hl)		; $6846

	; b = flags
	ld b,$00		; $6847
	cp $83 ; Boss room: palette 0
	jr z,++			; $684b
	cp $ad ; Background: palette 0
	jr z,++			; $684f

	ld b,$02		; $6851
	cp $ae ; Treasure chest: palette 2
	jr z,++			; $6855

	ld b,$04		; $6857
	cp $af ; Unvisited room: palette 4
	jr z,++			; $685b

	; Everything else: palette 5
	ld b,$05		; $685d
++
	call _drawTileABtoDE		; $685f
	inc hl			; $6862
	dec c			; $6863
	jr nz,@nextColumn		; $6864

	ld a,$18		; $6866
	call addAToDe		; $6868
	ldh a,(<hFF8D)		; $686b
	dec a			; $686d
	ldh (<hFF8D),a		; $686e
	jr nz,@nextRow		; $6870

	; Done drawing tiles

	pop af			; $6872
	ld ($ff00+R_SVBK),a	; $6873

	; Missing a "ret" opcode here.
	; This normally doesn't seem to cause any problems, though perhaps it's related to
	; the dungeon map crashes on the VBA emulator?

;;
; @param	a	Room index
; @param[out]	a	Tile index to draw on the map for this room
; @addr{6875}
_dungeonMap_getTileForRoom:
	push bc			; $6875
	push de			; $6876
	ld b,a			; $6877

	; Room index 0 stands for "nothing".
	or a			; $6878
	jr z,@hidden		; $6879

	; Load the room flags into 'd', dungeon properties into 'e'.
	push hl			; $687b
	ld l,b			; $687c
	ld a,(wDungeonFlagsAddressH)		; $687d
	ld h,a			; $6880
	ld d,(hl)		; $6881
	call getRoomDungeonProperties		; $6882
	ld e,b			; $6885
	pop hl			; $6886

	; The combination of flags "chest + boss" means it's a hidden room.
	ld a,e			; $6887
	cp (DUNGEONROOMPROPERTY_CHEST | DUNGEONROOMPROPERTY_BOSS)
	jr z,@hidden		; $688a
	cp (DUNGEONROOMPROPERTY_CHEST | DUNGEONROOMPROPERTY_BOSS | DUNGEONROOMPROPERTY_KEY)
	jr z,@hidden		; $688e

	bit ROOMFLAG_BIT_VISITED,d			; $6890
	jr nz,@visited		; $6892

; Room not visited; only show it if the compass reveals something or link has the map.

	call _dungeonMap_checkCompassTile		; $6894
	jr nz,@ret		; $6897

	call _checkLinkHasMap		; $6899
	ld a,$af ; Unvisited tile
	jr nz,@ret		; $689e

@hidden:
	ld a,$ac ; Blank tile
	jr @ret			; $68a2

	; Unreachable code?
	call _dungeonMap_checkCompassTile		; $68a4
	jr nz,@ret		; $68a7
	ld a,$af ; Unvisited tile
	jr @ret			; $68ab

@visited:
	call _dungeonMap_checkCompassTile		; $68ad
	jr nz,@ret	; $68b0

	; Calculate which tile to use based on the directions the room leads to.
	ld a,d			; $68b2
	or e			; $68b3
	and $0f			; $68b4
	add $b0			; $68b6
@ret:
	pop de			; $68b8
	pop bc			; $68b9
	ret			; $68ba

;;
; @param	hFF8D	A floor index?
; @param[out]	zflag	Set if link can't view that floor on the map.
; @addr{68bb}
_dungeonMap_checkCanViewFloor:
	call _checkLinkHasMap		; $68bb
	ret nz			; $68be
	push hl			; $68bf
	ldh a,(<hFF8D)	; $68c0
	dec a			; $68c2
	ld hl,bitTable		; $68c3
	add l			; $68c6
	ld l,a			; $68c7
	ld a,(wMapMenu.visitedFloors)		; $68c8
	and (hl)		; $68cb
	pop hl			; $68cc
	ret			; $68cd

;;
; For the dungeon map; check a room's dungeon flags and room flags to see if something
; should be revealed by the compass (ie. treasure tile).
;
; @param	d	Room flags
; @param	e	Dungeon room flags
; @param[out]	a	Tile to draw (if $00, no special tile is drawn)
; @param[out]	zflag	Set if no special tile should be drawn (instead, the caller will
;			decide which of the "normal" directional tiles to use).
; @addr{68ce}
_dungeonMap_checkCompassTile:
	call _checkLinkHasCompass		; $68ce
	ret z			; $68d1

	ld a,e			; $68d2
	ld c,$83 ; Boss tile
	and (DUNGEONROOMPROPERTY_KEY|DUNGEONROOMPROPERTY_CHEST|DUNGEONROOMPROPERTY_BOSS)
	cp DUNGEONROOMPROPERTY_BOSS			; $68d7
	jr z,@@ret		; $68d9

	cp DUNGEONROOMPROPERTY_CHEST			; $68db
	jr z,@@treasure		; $68dd
	cp (DUNGEONROOMPROPERTY_KEY|DUNGEONROOMPROPERTY_CHEST)			; $68df
	jr nz,@@nothing		; $68e1

@@treasure:
	ld c,$ae ; Treasure tile
	ld a,d			; $68e5
	and ROOMFLAG_ITEM ; Check if the treasure has been obtained
	jr z,@@ret		; $68e8
@@nothing:
	ld c,$00		; $68ea
@@ret:
	ld a,c			; $68ec
	or a			; $68ed
	ret			; $68ee

;;
; @param	a	Floor?
; @param[out]	hl	Start of floor in w2DungeonLayout
; @addr{68ef}
_dungeonMap_getFloorAddress:
	call multiplyABy16		; $68ef
	ld hl,w2DungeonLayout		; $68f2
	add hl,bc		; $68f5
	add hl,bc		; $68f6
	add hl,bc		; $68f7
	add hl,bc		; $68f8
	ret			; $68f9


; Each 2 bytes are two tile indices for a floor name on the dungeon map.
_dungeonMapFloorNameTiles:
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
_dungeonMapFloorListStartPositions:
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
; @addr{691e}
_dungeonMapSymbolPositions:
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
; The output of the "_getMinimapPopupType" function corresponds to an entry in this table.
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
	_mapMenu_tileSubstitutionTable:
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
	_mapMenu_tileSubstitutionTable:
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


.include "build/data/mapTextAndPopups.s"


; This table changes the text of a tile on a map depending on if a dungeon has been
; entered.
; b0: Room index (if Link's visited this room, use the dungeon's name as the text)
; b1: Bits 0-6: Text index to use if the dungeon hasn't been entered.
;               If it HAS been entered, the index will be $02XX, where XX is the index
;               used for this table's lookup (a dungeon index).
;     Bit 7: 0=group 4, 1=group 5
_mapMenu_dungeonEntranceText:

	.ifdef ROM_AGES
		.db $04  $80|(<TX_0307)
		.db $24  $80|(<TX_0309)
		.db $46  $80|(<TX_0337)
		.db $66  $80|(<TX_0311)
		.db $91  $80|(<TX_0303)
		.db $bb  $80|(<TX_0305)
		.db $26      (<TX_0306)
		.db $56      (<TX_030a)
		.db $aa      (<TX_0336)
		.db $01  $80|(<TX_0332)
		.db $f4      (<TX_0332)
		.db $ce  $80|(<TX_0332)
		.db $44      (<TX_0306)
		.db $0d  $80|(<TX_0332)
		.db $01      (<TX_0332)
		.db $01  $80|(<TX_0332)

	.else; ROM_SEASONS

		.db $04  $80|(<TX_0313)
		.db $1c  $80|(<TX_030f)
		.db $39  $80|(<TX_0311)
		.db $4b  $80|(<TX_030e)
		.db $81  $80|(<TX_0305)
		.db $a7  $80|(<TX_0310)
		.db $ba  $80|(<TX_032b)
		.db $5b      (<TX_0312)
		.db $87      (<TX_0330)
		.db $97      (<TX_0302)
	.endif


.include "build/data/treeWarps.s"


;;
; This is either the "ring appraisal" or "ring list" menu.
; If "wRingMenu_mode" is 0, it's the appraisal menu; otherwise it's the ring list.
; @addr{6d36}
_runRingMenu:
	; Clear OAM, but always leave the first 4 slots reserved for status bar items.
	call clearOam		; $6d36
	ld a,$10		; $6d39
	ldh (<hOamTail),a	; $6d3b

	ld hl,wTextboxFlags		; $6d3d
	set TEXTBOXFLAG_BIT_NOCOLORS,(hl)		; $6d40

	ld a,:w4TileMap		; $6d42
	ld ($ff00+R_SVBK),a	; $6d44

	call @runStateCode		; $6d46

	; Only draw the status bar on the appraisal menu, not the list menu
	ld a,(wRingMenu_mode)		; $6d49
	or a			; $6d4c
	ret nz			; $6d4d
	jp updateStatusBar		; $6d4e

@runStateCode:
	ld a,(wMenuActiveState)		; $6d51
	rst_jumpTable			; $6d54
	.dw _ringMenu_state0
	.dw _ringMenu_state1
	.dw _ringMenu_state2

;;
; State 0: initalization
;
; @addr{6d5b}
_ringMenu_state0:
	call loadCommonGraphics		; $6d5b
	xor a			; $6d5e
	ld (wRingMenu.tileMapIndex),a		; $6d5f
	dec a			; $6d62
	ld (wRingMenu.ringNameTextIndex),a		; $6d63
	ld a,$80		; $6d66
	ld (wRingMenu.boxCursorFlickerCounter),a		; $6d68

	ld a,(wRingMenu_mode)		; $6d6b
	add GFXH_3a			; $6d6e
	call loadGfxHeader		; $6d70
	ld a,PALH_0a		; $6d73
	call loadPaletteHeader		; $6d75

	callab bank3f.realignUnappraisedRings	; $6d78
	call _ringMenu_calculateNumPagesForUnappraisedRings		; $6d80
	call _ringMenu_redrawRingListOrUnappraisedRings		; $6d83

	; Go to state 1
	ld hl,wMenuActiveState		; $6d86
	inc (hl)		; $6d89

	call fastFadeinFromWhite		; $6d8a

	ld a,$05		; $6d8d
	ldh (<hNextLcdInterruptBehaviour),a	; $6d8f

	ld a,(wRingMenu_mode)		; $6d91
	add $0f			; $6d94
	jp loadGfxRegisterStateIndex		; $6d96

;;
; Uses an uncompressed gfx header (one of $12-$15, depending on variables) to copy the
; tilemap to vram.
;
; @addr{6d99}
_ringMenu_copyTilemapToVram:
	ld hl,wRingMenu_mode		; $6d99
	ld a,(wRingMenu.tileMapIndex)		; $6d9c
	and $01			; $6d9f
	add a			; $6da1
	add (hl)		; $6da2
	add UNCMP_GFXH_12			; $6da3
	jp loadUncompressedGfxHeader		; $6da5

;;
; Clears the textbox, and decides whether to draw ring list or unappraised rings.
;
; @addr{6da8}
_ringMenu_redrawRingListOrUnappraisedRings:
	xor a			; $6da8
	call _showItemText2		; $6da9
	ld hl,_ringMenu_copyTilemapToVram		; $6dac
	push hl			; $6daf

	ld a,(wRingMenu_mode)		; $6db0
	rst_jumpTable			; $6db3
	.dw _ringMenu_drawUnappraisedRings
	.dw _ringMenu_drawRingBox

;;
; Draws the ring box along with the rings in it in the ring list menu.
; @addr{6db8}
_ringMenu_drawRingBox:
	ld a,(wMenuActiveState)		; $6db8
	or a			; $6dbb
	jr nz,++		; $6dbc

	; Draw appropriate slots for rings
	ld a,(wRingBoxLevel)		; $6dbe
	inc a			; $6dc1
	call _mapMenu_performTileSubstitutions		; $6dc2

	; Draw ring box icon at appropriate level
	ld de,w4TileMap+$201		; $6dc5
	ld a,$fe		; $6dc8
	call _getRingTiles		; $6dca
++
	call _ringMenu_drawRingBoxContents		; $6dcd
	ld a,$04		; $6dd0
	ld (wRingMenu.numPages),a		; $6dd2
	ld a,$fe		; $6dd5
	ld (wRingMenu.displayedRingNumberComparator),a		; $6dd7
	jp _ringMenu_drawRingList		; $6dda

;;
; State 1: "normal" state; processes input, etc.
;
; @addr{6ddd}
_ringMenu_state1:
	ld a,(wPaletteThread_mode)		; $6ddd
	or a			; $6de0
	ret nz			; $6de1

	ld a,(wRingMenu_mode)		; $6de2
	rst_jumpTable			; $6de5
	.dw _ringMenu_state1_unappraisedRings
	.dw _ringMenu_state1_ringList

;;
; @addr{6dea}
_ringMenu_state1_unappraisedRings:
	call _ringMenu_drawSprites		; $6dea

	ld a,(wSubmenuState)		; $6ded
	rst_jumpTable			; $6df0
	.dw _ringMenu_unappraisedRings_state0
	.dw _ringMenu_unappraisedRings_state1
	.dw _ringMenu_unappraisedRings_state2
	.dw _ringMenu_unappraisedRings_state3
	.dw _ringMenu_unappraisedRings_state4
	.dw _ringMenu_unappraisedRings_state5

;;
; State 0: waiting for player to choose an unappraised ring
;
; @addr{6dfd}
_ringMenu_unappraisedRings_state0:
	ld a,(wTextIsActive)		; $6dfd
	or a			; $6e00
	ld a,<TX_3004 ; "Which one shall I appraise?"
	call z,_ringMenu_setDisplayedText		; $6e03

	ld a,(wKeysJustPressed)		; $6e06
	bit BTN_BIT_B,a			; $6e09
	jr nz,@bPressed		; $6e0b
	bit BTN_BIT_A,a			; $6e0d
	jr nz,@aPressed		; $6e0f
	bit BTN_BIT_SELECT,a			; $6e11
	jp nz,_ringMenu_initiateScrollRight		; $6e13
	jp _ringMenu_checkRingListCursorMoved		; $6e16

@bPressed:
	; Don't allow exiting if this is the first time (they don't have a ring box yet)
	call _ringMenu_checkObtainedRingBox		; $6e19
	ld a,<TX_3012		; $6e1c
	jp z,_ringMenu_setDisplayedText		; $6e1e

	jp _closeMenu		; $6e21

@aPressed:
	call _ringMenu_updateSelectedRingFromList		; $6e24
	call _ringMenu_getUnappraisedRingIndex		; $6e27
	rlca			; $6e2a
	ret c			; $6e2b

	; Selected a valid ring
	ld a,$01		; $6e2c
	ld (wSubmenuState),a		; $6e2e
	call _ringMenu_checkObtainedRingBox		; $6e31
	ld a,<TX_3011 ; Doesn't mention rupees (first time appraising)
	jr z,+			; $6e36
	ld a,<TX_3005		; $6e38
+
	jp _ringMenu_setDisplayedText		; $6e3a

;;
; State 1: selected a ring; waiting for confirmation
;
; @addr{6e3d}
_ringMenu_unappraisedRings_state1:
	call _ringMenu_retIfTextIsPrinting		; $6e3d

	; If player chose "no", go back
	ld a,(wSelectedTextOption)		; $6e40
	or a			; $6e43
	jr nz,_ringMenu_state1_restart	; $6e44

	; First time appraising, it's free
	call _ringMenu_checkObtainedRingBox		; $6e46
	jr z,++			; $6e49

	; Check if Link has 20 rupees; subtract that amount if so
	ld a,RUPEEVAL_020		; $6e4b
	call cpRupeeValue		; $6e4d
	ld b,<TX_3006 ; "You don't have enough rupees"
	jp nz,_ringMenu_unappraisedRings_gotoState5		; $6e52
	ld a,RUPEEVAL_020		; $6e55
	call removeRupeeValue		; $6e57
++
	ld hl,wNumRingsAppraised		; $6e5a
	call incHlRefWithCap		; $6e5d

	; Get the text to display for this ring's name
	call _ringMenu_getUnappraisedRingIndex		; $6e60
	res 6,(hl)		; $6e63
	ld a,(hl)		; $6e65
	ld (wRingMenu.textDelayCounter2),a		; $6e66
	add <TX_3040			; $6e69
	ld (wTextSubstitutions+2),a		; $6e6b
	ld bc,TX_301c ; "I call this the..."
	call _ringMenu_showExitableText		; $6e71

	ld a,$02		; $6e74
	ld (wSubmenuState),a		; $6e76

	call _ringMenu_drawUnappraisedRings		; $6e79
	jp _ringMenu_copyTilemapToVram		; $6e7c

;;
; Restart state 1 (begin prompt for ring appraisal again).
;
; @addr{6e7f}
_ringMenu_state1_restart:
	xor a			; $6e7f
	ld (wSubmenuState),a		; $6e80
	ld (wTextIsActive),a		; $6e83
	ret			; $6e86

;;
; State 2: just appraised a ring; after the "ring name" textbox closes, this will print
; the ring's description and go to state 3.
;
; @addr{6e87}
_ringMenu_unappraisedRings_state2:
	call _ringMenu_retIfTextIsPrinting		; $6e87

	ld a,$03		; $6e8a
	ld (wSubmenuState),a		; $6e8c

	call _ringMenu_getUnappraisedRingIndex		; $6e8f
	add <TX_3080			; $6e92
	ld c,a			; $6e94
	ld b,>TX_3000		; $6e95
	jr _ringMenu_showExitableText		; $6e97

;;
; State 3: after printing the ring's description, check if Link has the ring, print the
; appropriate text, then go to state 4.
;
; @addr{6e99}
_ringMenu_unappraisedRings_state3:
	call _ringMenu_retIfTextIsPrinting		; $6e99

	; Remove ring from unappraised list
	call _ringMenu_getUnappraisedRingIndex		; $6e9c
	ld c,a			; $6e9f
	ld (hl),$ff		; $6ea0

	ld hl,wRingsObtained		; $6ea2
	call checkFlag		; $6ea5
	jr nz,@refund		; $6ea8

	; Put ring into list
	ld a,c			; $6eaa
	call setFlag		; $6eab
	xor a			; $6eae
	ld b,<TX_3017 ; "I'll put it in your ring box"
	jr ++			; $6eb1
@refund:
	ld a,RUPEEVAL_030		; $6eb3
	ld b,<TX_3007 ; "You already have this"
++
	ld (wRingMenu.rupeeRefundValue),a		; $6eb7
	call _ringMenu_checkObtainedRingBox		; $6eba
	jp z,_closeMenu		; $6ebd

	ld a,40 ; Wait 40 frames after the next textbox closes
	ld (wRingMenu.textDelayCounter2),a		; $6ec2

	ld a,$04		; $6ec5
	ld (wSubmenuState),a		; $6ec7

	ld a,b			; $6eca
	jp _ringMenu_setDisplayedText		; $6ecb

;;
; State 4: redraw ring list without the just-appraised ring, check whether to exit the
; ring menu or whether to keep going.
;
; @addr{6ece}
_ringMenu_unappraisedRings_state4:
	call _ringMenu_retIfTextIsPrinting		; $6ece
	call _ringMenu_retIfCounterNotFinished		; $6ed1

	; Refund if applicable
	ld a,(wRingMenu.rupeeRefundValue)		; $6ed4
	or a			; $6ed7
	ld c,a			; $6ed8
	ld a,TREASURE_RUPEES		; $6ed9
	call nz,giveTreasure		; $6edb

	callab bank3f.getNumUnappraisedRings		; $6ede
	call _ringMenu_drawUnappraisedRings		; $6ee6
	call _ringMenu_copyTilemapToVram		; $6ee9

	ld a,(wNumRingsAppraised)		; $6eec
	cp 100			; $6eef
	jr nz,@not100th		; $6ef1

	; 100th ring
	ld a,GLOBALFLAG_APPRAISED_HUNDREDTH_RING		; $6ef3
	call setGlobalFlag		; $6ef5
	ld b,<TX_303c		; $6ef8
	jr _ringMenu_unappraisedRings_gotoState5			; $6efa

@not100th:
	; If we still have some rings left, go back to state 0
	ld a,(wNumUnappraisedRingsBcd)		; $6efc
	or a			; $6eff
	jp nz,_ringMenu_state1_restart		; $6f00

	; Otherwise, proceed to exit the ring menu.
	ld b,<TX_3002 ; "I've appraised all your rings"

	; Fall through

;;
; @param	b	Low byte of text index to show
; @addr{6f05}
_ringMenu_unappraisedRings_gotoState5:
	ld a,$05		; $6f05
	ld (wSubmenuState),a		; $6f07
	ld a,$3c		; $6f0a
	ld (wRingMenu.textDelayCounter2),a		; $6f0c
	ld a,b			; $6f0f
	jp _ringMenu_setDisplayedText		; $6f10

;;
; Shows an "exitable" textbox (used when vasu's speaking) unlike the "passive" textboxes
; used for ring descriptions most of the time.
;
; @param	bc	Text index
; @addr{6f13}
_ringMenu_showExitableText:
	ld a,$02		; $6f13
	ld (wTextboxPosition),a		; $6f15
	ld a,TEXTBOXFLAG_NOCOLORS | TEXTBOXFLAG_DONTCHECKPOSITION		; $6f18
	ld (wTextboxFlags),a		; $6f1a
	jp showText		; $6f1d

;;
; State 5: exit ring menu after a delay.
;
; @addr{6f20}
_ringMenu_unappraisedRings_state5:
	call _ringMenu_retIfTextIsPrinting		; $6f20
	call _ringMenu_retIfCounterNotFinished		; $6f23
	jp _closeMenu		; $6f26

;;
; @addr{6f29}
_ringMenu_checkObtainedRingBox:
	ld a,GLOBALFLAG_OBTAINED_RING_BOX		; $6f29
	jp checkGlobalFlag		; $6f2b

;;
; @param[out]	a	The value of the unappraised ring that the cursor is over
; @param[out]	hl	The address of the ring in wUnappraisedRings
; @addr{6f2e}
_ringMenu_getUnappraisedRingIndex:
	ld a,(wRingMenu.selectedRing)		; $6f2e
	ld hl,wUnappraisedRings		; $6f31
	rst_addAToHl			; $6f34
	ld a,(hl)		; $6f35
	ret			; $6f36

;;
; Returns from caller unless wRingMEnu_textDelayCounter2 has counted down to zero.
; @addr{6f37}
_ringMenu_retIfCounterNotFinished:
	ld hl,wRingMenu.textDelayCounter2		; $6f37
	ld a,(hl)		; $6f3a
	or a			; $6f3b
	ret z			; $6f3c
	dec (hl)		; $6f3d
	pop af			; $6f3e
	ret			; $6f3f

;;
; @addr{6f40}
_ringMenu_state1_ringList:
	call _ringMenu_drawRingBoxCursor		; $6f40
	call _ringMenu_drawEquippedRingSprite		; $6f43
	call _ringMenu_drawSpritesForRingsInBox		; $6f46

	ld a,(wSubmenuState)		; $6f49
	rst_jumpTable			; $6f4c
	.dw _ringMenu_ringList_substate0
	.dw _ringMenu_ringList_substate1

;;
; Substate 0: cursor is on the ring box (selecting a slot in the ring box)
;
; @addr{6f51}
_ringMenu_ringList_substate0:
	ld a,(wRingMenu.boxCursorFlickerCounter)		; $6f51
	or a			; $6f54
	jr z,@aPressed		; $6f55

	ld hl,wRingMenu.textDelayCounter		; $6f57
	ld a,(hl)		; $6f5a
	or a			; $6f5b
	jr z,+			; $6f5c
	dec (hl)		; $6f5e
	jr @checkInput		; $6f5f
+
	; Display text for the ring we're hovering over in the ring box
	ld a,(wRingMenu.ringBoxCursorIndex)		; $6f61
	ld hl,wRingBoxContents		; $6f64
	rst_addAToHl			; $6f67
	ld a,(hl)		; $6f68
	ld (wRingMenu.selectedRing),a		; $6f69
	call _ringMenu_updateDisplayedRingNumberWithGivenComparator		; $6f6c
	call _ringMenu_updateRingText		; $6f6f

@checkInput:
	ld a,(wKeysJustPressed)		; $6f72
	bit BTN_BIT_B,a			; $6f75
	jr nz,@bPressed		; $6f77
	bit BTN_BIT_A,a			; $6f79
	jp z,_ringMenu_checkRingBoxCursorMoved		; $6f7b

; Selected a ring box slot; move the cursor to the ring list (substate 1).
@aPressed:
	xor a			; $6f7e
	ld (wRingMenu.boxCursorFlickerCounter),a		; $6f7f
	inc a			; $6f82
	ld (wSubmenuState),a		; $6f83
	ld a,$80		; $6f86
	ld (wRingMenu.displayedRingNumberComparator),a		; $6f88
	ld a,$ff		; $6f8b
	ld (wRingMenu.descriptionTextIndex),a		; $6f8d
	ret			; $6f90

@bPressed:
	; Deactivate active ring if it was put away
	ld a,(wActiveRing)		; $6f91
	call _ringMenu_checkRingIsInBox		; $6f94
	jr nc,+			; $6f97
	ld a,$ff		; $6f99
	ld (wActiveRing),a		; $6f9b
+
	; Exit the ring menu
	xor a			; $6f9e
	ld (wTextIsActive),a		; $6f9f
	ld (wTextboxFlags),a		; $6fa2
	jp _closeMenu		; $6fa5

;;
; Substate 1: cursor is on the ring list (selecting something to insert into the box)
;
; @addr{6fa8}
_ringMenu_ringList_substate1:
	ld a,(wKeysJustPressed)		; $6fa8
	bit BTN_BIT_A,a			; $6fab
	jr nz,_ringMenu_selectedRingFromList	; $6fad
	bit BTN_BIT_B,a			; $6faf
	jp nz,_ringMenu_moveCursorToRingBox		; $6fb1
	bit BTN_BIT_SELECT,a			; $6fb4
	jp nz,_ringMenu_initiateScrollRight		; $6fb6

	call _ringMenu_checkRingListCursorMoved		; $6fb9
	call _ringMenu_updateSelectedRingFromList		; $6fbc
	call _ringMenu_updateDisplayedRingNumber		; $6fbf
	call _ringMenu_drawSprites		; $6fc2
	call _ringMenu_retIfCounterNotFinished		; $6fc5

	; Fall through

;;
; The ring list (not appraisal screen) runs this to update the textbox at the bottom.
;
; @addr{6fc8}
_ringMenu_updateRingText:
	; Determine what text to show for the ring name
	ld a,(wRingMenu.selectedRing)		; $6fc8
	ld c,a			; $6fcb
	ld hl,wRingsObtained		; $6fcc
	call checkFlag		; $6fcf
	jr z,+ ; If we don't have this ring, don't show its text
	ld a,c			; $6fd4
	or $80			; $6fd5
+
	; Check if the text to show is different from the text currently being shown
	ld hl,wRingMenu.ringNameTextIndex		; $6fd7
	cp (hl)			; $6fda
	jr z,+			; $6fdb
	call _showItemText2		; $6fdd
	ld a,$01		; $6fe0
	ld (wRingMenu.textDelayCounter),a		; $6fe2
	ret			; $6fe5
+
	; Determine what text to show for the description
	ld a,(wRingMenu.selectedRing)		; $6fe6
	ld c,a			; $6fe9
	cp $ff			; $6fea
	ld a,<TX_30c0 ; Blank text
	jr z,@printDescription	; $6fee

	ld a,c			; $6ff0
	ld hl,wRingsObtained		; $6ff1
	call checkFlag		; $6ff4
	ld a,<TX_30c0 ; Blank text
	jr z,@printDescription	; $6ff9

	ld a,c			; $6ffb
	add <TX_3080			; $6ffc
@printDescription:
	; Check if the text to show is different from the text currently being shown
	ld hl,wRingMenu.descriptionTextIndex		; $6ffe
	cp (hl)			; $7001
	ret z			; $7002

	; Display the textbox
	ld (hl),a		; $7003
	ld c,a			; $7004
	ld b,>TX_3000		; $7005
	ld a,$04		; $7007
	ld (wTextboxPosition),a		; $7009
	ld a,TEXTBOXFLAG_NOCOLORS | TEXTBOXFLAG_DONTCHECKPOSITION		; $700c
	ld (wTextboxFlags),a		; $700e
	jp showTextNonExitable		; $7011

;;
; Selected something from the ring list; put it into the ring box and move the cursor back
; there.
;
; @addr{7014}
_ringMenu_selectedRingFromList:
	ld a,SND_SELECTITEM		; $7014
	call playSound		; $7016

	; Put the ring (if it exists) in the box
	call _ringMenu_updateSelectedRingFromList		; $7019
	ld c,a			; $701c
	ld hl,wRingsObtained		; $701d
	call checkFlag		; $7020
	jr nz,+			; $7023
	ld c,$ff		; $7025
+
	ld a,(wRingMenu.ringBoxCursorIndex)		; $7027
	ld b,a			; $702a
	ld a,c			; $702b
	call _ringMenu_checkRingIsInBox		; $702c
	jr c,+			; $702f
	ld (hl),$ff		; $7031
	cp b			; $7033
	jr z,_ringMenu_moveCursorToRingBox	; $7034
+
	ld a,b			; $7036
	ld hl,wRingBoxContents		; $7037
	rst_addAToHl			; $703a
	ld (hl),c		; $703b

	; Fall through

;;
; Sets the cursor to be at the ring box instead of ring list.
;
; @addr{703c}
_ringMenu_moveCursorToRingBox:
	xor a			; $703c
	ld (wSubmenuState),a		; $703d
	ld a,$80		; $7040
	ld (wRingMenu.boxCursorFlickerCounter),a		; $7042
	ld a,$ff		; $7045
	ld (wTextIsActive),a		; $7047
	ld (wRingMenu.ringNameTextIndex),a		; $704a
	ld (wRingMenu.descriptionTextIndex),a		; $704d
	call _ringMenu_drawRingBoxContents		; $7050
	jp _ringMenu_copyTilemapToVram		; $7053

;;
; @param	a	Ring to check if it's in the ring box
; @param[out]	a	The ring's index in the ring box
; @param[out]	cflag	nc if the ring's in the box
; @addr{7056}
_ringMenu_checkRingIsInBox:
	push bc			; $7056
	ld hl,wRingBoxContents+4		; $7057
	ld b,$05		; $705a
@nextRing:
	cp (hl)			; $705c
	jr z,@foundRing		; $705d
	dec l			; $705f
	dec b			; $7060
	jr nz,@nextRing		; $7061

	pop bc			; $7063
	scf			; $7064
	ret			; $7065

@foundRing:
	dec b			; $7066
	ld a,b			; $7067
	pop bc			; $7068
	ret			; $7069

;;
; @addr{706a}
_ringMenu_initiateScrollRight:
	ld a,$01		; $706a
	ld (wRingMenu.scrollDirection),a		; $706c
	ld (wRingMenu.displayedRingNumberComparator),a		; $706f
	xor a			; $7072
	ld (wRingMenu.ringListCursorIndex),a		; $7073
	ld a,(wRingMenu.page)		; $7076
	inc a			; $7079

;;
; @param	a	Page to scroll to
; @addr{707a}
_ringMenu_initiateScroll:
	ld hl,wRingMenu.numPages		; $707a
	cp (hl)			; $707d
	jr c,++			; $707e
	ld a,$01		; $7080
	cp (hl)			; $7082
	ret z			; $7083

	dec a			; $7084
++
	ld (wRingMenu.page),a		; $7085

	ld a,$02		; $7088

;;
; @param	a	State to go to
; @addr{708a}
_ringMenu_setState:
	ld hl,wMenuActiveState		; $708a
	ldi (hl),a		; $708d
	xor a			; $708e
	ld (hl),a ; [wSubmenuState] = 0
	ld (wTextIsActive),a		; $7090

	ld a,$ff		; $7093
	ld (wRingMenu.descriptionTextIndex),a		; $7095
	ret			; $7098

;;
; State 2: scrolling between pages
;
; @addr{7099}
_ringMenu_state2:
	ld a,(wRingMenu_mode)		; $7099
	or a			; $709c
	jr z,+			; $709d
	call _ringMenu_drawRingBoxCursor		; $709f
	call _ringMenu_drawEquippedRingSprite		; $70a2
+
	ld a,(wSubmenuState)		; $70a5
	rst_jumpTable			; $70a8
	.dw @substate0
	.dw @substate1

; Initiating scroll
@substate0:
	ld hl,wRingMenu.tileMapIndex		; $70ad
	ld a,(hl)		; $70b0
	xor $01			; $70b1
	ld (hl),a		; $70b3

	call _ringMenu_redrawRingListOrUnappraisedRings		; $70b4

	ld a,(wRingMenu.scrollDirection)		; $70b7
	bit 7,a			; $70ba
	ld a,$9f		; $70bc
	jr z,++			; $70be
	ld hl,wGfxRegs2.LCDC		; $70c0
	ld a,(hl)		; $70c3
	xor $48			; $70c4
	ld (hl),a		; $70c6
	ld a,$98		; $70c7
	ld (wGfxRegs2.SCX),a		; $70c9
	ld a,$07		; $70cc
++
	ld (wGfxRegs2.WINX),a		; $70ce
	ld hl,wSubmenuState		; $70d1
	inc (hl)		; $70d4
	ld a,SND_OPENMENU		; $70d5
	jp playSound		; $70d7

; In the process of scrolling
@substate1:
	ld bc,$089f		; $70da
	ld hl,wGfxRegs2.WINX		; $70dd
	ld de,wGfxRegs2.SCX		; $70e0
	ld a,(wRingMenu.scrollDirection)		; $70e3
	bit 7,a			; $70e6
	jr z,@scrollRight	; $70e8

@scrollLeft:
	ld a,(hl)		; $70ea
	add b			; $70eb
	cp c			; $70ec
	jr c,+			; $70ed
	ld a,c			; $70ef
+
	ld (hl),a		; $70f0
	ld a,(de)		; $70f1
	sub b			; $70f2
	ld (de),a		; $70f3
	cp $08			; $70f4
	ret nc			; $70f6
	jr @doneScrolling		; $70f7

@scrollRight:
	ld a,(hl)		; $70f9
	sub b			; $70fa
	cp $07			; $70fb
	jr nc,+			; $70fd
	ld a,$07		; $70ff
+
	ld (hl),a		; $7101
	ld a,(de)		; $7102
	add b			; $7103
	ld (de),a		; $7104
	cp $98			; $7105
	ret c			; $7107
	ld a,(wGfxRegs2.LCDC)		; $7108
	xor $48			; $710b
	ld (wGfxRegs2.LCDC),a		; $710d

@doneScrolling:
	ld a,$c7		; $7110
	ld (wGfxRegs2.WINX),a		; $7112
	xor a			; $7115
	ld (wGfxRegs2.SCX),a		; $7116
	ld a,$01		; $7119
	jp _ringMenu_setState		; $711b

;;
; @addr{711e}
_ringMenu_checkRingListCursorMoved:
	ld hl,@directionOffsets		; $711e
	call _getDirectionButtonOffsetFromHl		; $7121
	ret nc			; $7124

	ld c,a			; $7125

	; Update position
	ld hl,wRingMenu.ringListCursorIndex		; $7126
	ld e,a			; $7129
	add (hl)		; $712a
	ld b,a			; $712b
	and $0f			; $712c
	ld (hl),a		; $712e

	; Check if we hit the edge of the screen
	bit 0,c			; $712f
	jr z,@playSound		; $7131
	bit 4,b			; $7133
	jr z,@playSound		; $7135

	; Initiate screen scrolling
	ld a,e			; $7137
	ld (wRingMenu.scrollDirection),a		; $7138
	ld a,(wRingMenu.page)		; $713b
	add e			; $713e
	cp $ff			; $713f
	jr nz,++		; $7141

	ld a,(wRingMenu.numPages)		; $7143
	cp $01			; $7146
	jr z,@playSound	; $7148
	dec a			; $714a
++
	call _ringMenu_initiateScroll		; $714b

@playSound:
	ld a,SND_MENU_MOVE		; $714e
	call playSound		; $7150
	scf			; $7153
	ret			; $7154

@directionOffsets:
	.db $01 ; Right
	.db $ff ; Left
	.db $f8 ; Up
	.db $08 ; Down

;;
; Update the cursor position in the ring box by checking if a direction button is pressed
;
; @addr{7159}
_ringMenu_checkRingBoxCursorMoved:
	call _getRingBoxCapacity		; $7159
	ld e,a			; $715c
	ld hl,@directionOffsets		; $715d
	call _getDirectionButtonOffsetFromHl		; $7160
	ret nc			; $7163
	ret z			; $7164
	ld hl,wRingMenu.ringBoxCursorIndex		; $7165
	add (hl)		; $7168
	cp e			; $7169
	ret nc			; $716a
	ld (hl),a		; $716b
	ld a,SND_MENU_MOVE		; $716c
	jp playSound		; $716e

@directionOffsets:
	.db $01 ; Right
	.db $ff ; Left
	.db $00 ; Up
	.db $00 ; Down

;;
; Draw sprites for the cursor, and arrows indicating you can scroll between pages (if
; there's more than one page).
;
; @addr{7175}
_ringMenu_drawSprites:
	ld a,(wRingMenu.numPages)		; $7175
	dec a			; $7178
	ld hl,@arrowSprites		; $7179
	call nz,addSpritesToOam		; $717c

	ld hl,wRingMenu.listCursorFlickerCounter		; $717f
	inc (hl)		; $7182
	bit 3,(hl)		; $7183
	ret nz			; $7185
	ld bc,$3e20		; $7186
	ld a,(wRingMenu.ringListCursorIndex)		; $7189
	cp $08			; $718c
	jr c,+			; $718e
	ld b,$56		; $7190
+
	and $07			; $7192
	swap a			; $7194
	add c			; $7196
	ld c,a			; $7197
	ld hl,@cursorSprite		; $7198
	jp addSpritesToOam_withOffset		; $719b

@cursorSprite:
	.db $01
	.db $00 $fc $0e $02

@arrowSprites:
	.db $02
	.db $3c $0c $08 $04
	.db $3c $9c $08 $24

;;
; Draws the "E" for equipped next to the equipped ring in the ring box.
;
; @addr{71ac}
_ringMenu_drawEquippedRingSprite:
	ld a,(wActiveRing)		; $71ac
	cp $ff			; $71af
	ret z			; $71b1
	call _ringMenu_checkRingIsInBox		; $71b2
	ret c			; $71b5

	call _ringMenu_getSpriteOffsetForRingBoxPosition		; $71b6
	ld hl,@equippedSprite		; $71b9
	jp addSpritesToOam_withOffset		; $71bc

@equippedSprite:
	.db $01
	.db $10 $00 $ec $04

;;
; @param[out]	bc	An offset to use for sprites to be drawn on a ring in the ring box
; @addr{71c4}
_ringMenu_getSpriteOffsetForRingBoxPosition:
	ld hl,@offsets		; $71c4
	rst_addAToHl			; $71c7
	ld c,(hl)		; $71c8
	ld b,$00		; $71c9
	ret			; $71cb

@offsets:
	.db $38 $50 $68 $80 $98

;;
; @addr{71d1}
_ringMenu_drawRingBoxCursor:
	ld hl,wRingMenu.boxCursorFlickerCounter		; $71d1
	bit 7,(hl)		; $71d4
	jr z,++			; $71d6

	; Flicker the cursor with this counter
	inc (hl)		; $71d8
	res 4,(hl)		; $71d9
	bit 3,(hl)		; $71db
	ret nz			; $71dd
++
	ld a,(wRingMenu.ringBoxCursorIndex)		; $71de
	call _ringMenu_getSpriteOffsetForRingBoxPosition		; $71e1
	ld hl,@ringBoxCursor		; $71e4
	jp addSpritesToOam_withOffset		; $71e7

@ringBoxCursor:
	.db $01
	.db $1e $fc $0e $03

;;
; For each ring in the ring box, this draws a sprite (the letter "C") on the corresponding
; ring in the ring list.
;
; @addr{71ef}
_ringMenu_drawSpritesForRingsInBox:
	ld a,$05		; $71ef
@loop:
	push af			; $71f1

	ld hl,wRingBoxContents-1		; $71f2
	rst_addAToHl			; $71f5
	ld a,(wRingMenu.page)		; $71f6
	swap a			; $71f9
	ld c,a			; $71fb

	ld a,(hl)		; $71fc
	cp $ff			; $71fd
	jr z,@nextRing		; $71ff

	; Make sure the ring is on this page
	sub c			; $7201
	cp $10			; $7202
	jr nc,@nextRing		; $7204

	; Calculate the position to draw the "c" at
	ld b,$30		; $7206
	bit 3,a			; $7208
	jr z,+			; $720a
	ld b,$48		; $720c
+
	and $07			; $720e
	swap a			; $7210
	ld c,a			; $7212
	ld hl,@sprite		; $7213
	call addSpritesToOam_withOffset		; $7216
@nextRing:
	pop af			; $7219
	dec a			; $721a
	jr nz,@loop		; $721b
	ret			; $721d

@sprite:
	.db $01
	.db $00 $20 $ef $05

;;
; @addr{7223}
_ringMenu_calculateNumPagesForUnappraisedRings:
	callab bank3f.getNumUnappraisedRings		; $7223
	ld a,(wNumUnappraisedRingsBcd)		; $722b
	or a			; $722e
	ret z			; $722f

	ld a,b			; $7230
	dec a			; $7231
	swap a			; $7232
	and $0f			; $7234
	inc a			; $7236
	ld (wRingMenu.numPages),a		; $7237
	ret			; $723a

;;
; @addr{723b}
_ringMenu_updateSelectedRingFromList:
	ld a,(wRingMenu.page)		; $723b
	swap a			; $723e
	ld c,a			; $7240
	ld a,(wRingMenu.ringListCursorIndex)		; $7241
	add c			; $7244
	ld (wRingMenu.selectedRing),a		; $7245
	ret			; $7248

;;
; Clear all ring icons in the selection area.
;
; @addr{7249}
_ringMenu_clearRingSelectionArea:
	ld hl,w4TileMap+$040		; $7249
	ldbc $05,$14		; $724c
	ldde $00,$07		; $724f
	jp _fillRectangleInTilemap		; $7252

;;
; @addr{7255}
_ringMenu_drawUnappraisedRings:
	call _ringMenu_clearRingSelectionArea		; $7255

	ld b,$10		; $7258
	ld a,(wRingMenu.page)		; $725a
	swap a			; $725d
	ld hl,wUnappraisedRings		; $725f
	rst_addAToHl			; $7262
@nextRing:
	ldi a,(hl)		; $7263
	ld c,a			; $7264
	call _ringMenu_drawRing		; $7265
	dec b			; $7268
	jr nz,@nextRing		; $7269

	jr _ringMenu_drawPageCounter		; $726b

;;
; @addr{726d}
_ringMenu_drawRingList:
	call _ringMenu_clearRingSelectionArea		; $726d

	ld b,$10		; $7270
	ld a,(wRingMenu.page)		; $7272
	swap a			; $7275
	ld c,a			; $7277
@nextRing:
	ld a,c			; $7278
	ld hl,wRingsObtained		; $7279
	call checkFlag		; $727c
	call nz,_ringMenu_drawRing		; $727f
	inc c			; $7282
	dec b			; $7283
	jr nz,@nextRing		; $7284

;;
; @addr{7286}
_ringMenu_drawPageCounter:
	; Draw page number
	ld hl,w4TileMap+$10f		; $7286
	ld a,(wRingMenu.page)		; $7289
	add $11			; $728c
	ldi (hl),a		; $728e

	; Draw total page number
	inc l			; $728f
	ld a,(wRingMenu.numPages)		; $7290
	add $10			; $7293
	ld (hl),a		; $7295
	ret			; $7296

;;
; Draws the contents of the ring box for the ring list menu
;
; @addr{7297}
_ringMenu_drawRingBoxContents:
	ld hl,wRingBoxContents		; $7297
	ld b,$11 ; b = index for _ringMenu_drawRing function (cycles from $11-$15)

@nextRing:
	ldi a,(hl)		; $729c
	cp $ff			; $729d
	jr nz,@drawRing		; $729f

	; Blank ring slot: fill with empty square
	push hl			; $72a1
	push bc			; $72a2
	ld a,b			; $72a3
	ld hl,_ringMenu_ringPositionList-2		; $72a4
	rst_addDoubleIndex			; $72a7
	ldi a,(hl)		; $72a8
	ld h,(hl)		; $72a9
	ld l,a			; $72aa
	ldbc $02,$02		; $72ab
	ldde $00,$07		; $72ae
	call _fillRectangleInTilemap		; $72b1
	pop bc			; $72b4
	pop hl			; $72b5
	jr ++			; $72b6
@drawRing:
	ld c,a			; $72b8
	call _ringMenu_drawRing		; $72b9
++
	inc b			; $72bc
	ld a,l			; $72bd
	cp <wRingBoxContents+5			; $72be
	jr c,@nextRing		; $72c0
	ret			; $72c2

;;
; Draws a ring's tiles at a position in the ring list.
;
; @param	b	Position index
; @param	c	Ring index
; @addr{72c3}
_ringMenu_drawRing:
	push bc			; $72c3
	push hl			; $72c4
	ld a,b			; $72c5
	ld hl,_ringMenu_ringPositionList-2		; $72c6
	rst_addDoubleIndex			; $72c9
	ldi a,(hl)		; $72ca
	ld d,(hl)		; $72cb
	ld e,a			; $72cc
	ld a,c			; $72cd
	call _getRingTiles		; $72ce
	pop hl			; $72d1
	pop bc			; $72d2
	ret			; $72d3

; @addr{72d4}
_ringMenu_ringPositionList:
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
; @addr{72fe}
_getRingTiles:
	cp $ff			; $72fe
	ret z			; $7300

	; Unappraised ring?
	bit 6,a			; $7301
	jr z,+			; $7303

	; Ring box?
	cp $fe			; $7305
	ld a,$40		; $7307
	jr nz,+			; $7309
	ld a,(wRingBoxLevel)		; $730b
	add $40			; $730e
	jr +			; $7310
+
	call multiplyABy8		; $7312
	ld hl,map_rings		; $7315
	add hl,bc		; $7318
	push de			; $7319
	call copy8BytesFromRingMapToCec0		; $731a
	pop hl			; $731d
	ld de,wTmpcec0		; $731e
	call @drawTile		; $7321
	inc l			; $7324
	call @drawTile		; $7325
	ld a,$1f		; $7328
	rst_addAToHl			; $732a
	call @drawTile		; $732b
	inc l			; $732e
@drawTile:
	ld a,(de)		; $732f
	ld (hl),a		; $7330
	inc e			; $7331
	set 2,h			; $7332
	ld a,(de)		; $7334
	ld (hl),a		; $7335
	inc e			; $7336
	res 2,h			; $7337
	ret			; $7339

;;
; Updates the "ring number" displayed below the ring list.
; @addr{733a}
_ringMenu_updateDisplayedRingNumber:
	ld a,(wRingMenu.ringListCursorIndex)		; $733a

	; Fall through

;;
; @param	a	Value to compare against "wRingMenu.displayedRingNumberComparator"
;			for changes
; @addr{733d}
_ringMenu_updateDisplayedRingNumberWithGivenComparator:
	ld hl,wRingMenu.displayedRingNumberComparator		; $733d
	cp (hl)			; $7340
	ret z			; $7341

	ld (hl),a		; $7342

	; If no ring is selected, print two dashes
	ld a,(wRingMenu.selectedRing)		; $7343
	inc a			; $7346
	jr z,@noRing			; $7347

	; Calculate the ring's number in bcd
	call hexToDec		; $7349
	set 4,a			; $734c
	set 4,c			; $734e
	jr @drawNumber			; $7350

@noRing:
	; Display two dashes
	ld a,$e8		; $7352
	ld c,a			; $7354
@drawNumber:
	ld hl,w4TileMap+$105		; $7355
	ldd (hl),a		; $7358
	ld (hl),c		; $7359
	jp _ringMenu_copyTilemapToVram		; $735a

;;
; @param	a	Text index to show ($30XX)
; @addr{735d}
_ringMenu_setDisplayedText:
	ld hl,wRingMenu.descriptionTextIndex		; $735d
	cp (hl)			; $7360
	ret z			; $7361

	ld (hl),a		; $7362
	ld c,a			; $7363
	ld b,>TX_3000		; $7364
	ld a,$02		; $7366
	ld (wTextboxPosition),a		; $7368
	ld a,TEXTBOXFLAG_NOCOLORS | TEXTBOXFLAG_DONTCHECKPOSITION		; $736b
	ld (wTextboxFlags),a		; $736d
	jp showTextNonExitable		; $7370

;;
; Returns from caller if text is still in the process of printing.
;
; @addr{7373}
_ringMenu_retIfTextIsPrinting:
	ld a,(wTextIsActive)		; $7373
	and $7f			; $7376
	ret z			; $7378
	pop af			; $7379
	ret			; $737a


;;
; @param[out]	zflag	Set if we got here from a game over.
; @addr{737b}
_saveQuitMenu_checkIsGameOver:
	ld a,(wSaveQuitMenu.gameOver)		; $737b
	or a			; $737e
	ret			; $737f

;;
; @addr{7380}
runSaveAndQuitMenu:
	ld a,$00		; $7380
	ld ($ff00+R_SVBK),a	; $7382
	call @runState		; $7384
	jp _saveQuitMenu_drawSprites		; $7387

@runState:
	ld a,(wSaveQuitMenu.state)		; $738a
	rst_jumpTable			; $738d
	.dw _saveQuitMenu_state0
	.dw _saveQuitMenu_state1
	.dw _saveQuitMenu_state2

;;
; State 0: initialization (loading graphics, setting music, etc)
; @addr{7394}
_saveQuitMenu_state0:
	call disableLcd		; $7394
	call stopTextThread		; $7397

	ld a,GFXH_a0		; $739a
	call loadGfxHeader		; $739c
	ld a,GFXH_a6		; $739f
	call loadGfxHeader		; $73a1
	ld a,GFXH_a8		; $73a4
	call loadGfxHeader		; $73a6

	call _saveQuitMenu_checkIsGameOver		; $73a9
	jr z,@notGameOver		; $73ac

@gameOver:
	call restartSound		; $73ae
	ld a,THREAD_1		; $73b1
	call threadStop		; $73b3

	ld hl,wDeathCounter		; $73b6
	ld bc,$0001		; $73b9
	call addDecimalToHlRef		; $73bc
	cp $0a			; $73bf
	jr c,+			; $73c1
	ld (hl),$99 ; Death counter can't exceed 999
	inc l			; $73c5
	ld (hl),$09		; $73c6
+
	ld a,GFXH_a9		; $73c8
	call loadGfxHeader		; $73ca

	ld a,MUS_GAMEOVER		; $73cd
	call playSound		; $73cf

	ld a,PALH_06		; $73d2
	jr ++			; $73d4

@notGameOver:
	xor a			; $73d6
	call setMusicVolume		; $73d7
	ld a,PALH_05		; $73da
++
	call loadPaletteHeader		; $73dc
	ld a,UNCMP_GFXH_08		; $73df
	call loadUncompressedGfxHeader		; $73e1

	call fastFadeinFromWhite		; $73e4

	ld a,$01		; $73e7
	ld (wSaveQuitMenu.state),a		; $73e9

	ld a,$05		; $73ec
	jp loadGfxRegisterStateIndex		; $73ee

;;
; State 1: processing input
;
; @addr{73f1}
_saveQuitMenu_state1:
	ld a,(wPaletteThread_mode)		; $73f1
	or a			; $73f4
	ret nz			; $73f5

	ld a,(wKeysJustPressed)		; $73f6
	ld c,$ff		; $73f9
	bit BTN_BIT_UP,a			; $73fb
	jr nz,@upOrDown		; $73fd
	ld c,$01		; $73ff
	bit BTN_BIT_DOWN,a			; $7401
	jr nz,@upOrDown		; $7403

	bit BTN_BIT_B,a			; $7405
	jr nz,@bPressed		; $7407

	and (BTN_START|BTN_A)			; $7409
	ret z			; $740b

	; A pressed
	ld a,(wSaveQuitMenu.cursorIndex)		; $740c
	or a			; $740f
	call nz,saveFile ; Save for options 2 and 3

	ld a,$02		; $7413
	ld (wSaveQuitMenu.state),a		; $7415
	ld a,$1e		; $7418
	ld (wSaveQuitMenu.delayCounter),a		; $741a

	ld a,SND_SELECTITEM		; $741d
	jp playSound		; $741f

@upOrDown:
	ld hl,wSaveQuitMenu.cursorIndex		; $7422
	ld a,(hl)		; $7425
	add c			; $7426
	cp $03			; $7427
	ret nc			; $7429
	ld (hl),a		; $742a
	ld a,SND_MENU_MOVE		; $742b
	jp playSound		; $742d

@bPressed:
	call _saveQuitMenu_checkIsGameOver		; $7430
	ret nz			; $7433
	jp _closeMenu		; $7434

;;
; State 2: selected an option; after a delay, decide whether to reset, etc.
;
; @addr{7437}
_saveQuitMenu_state2:
	ld hl,wSaveQuitMenu.delayCounter		; $7437
	dec (hl)		; $743a
	ret nz			; $743b

	ld a,(wSaveQuitMenu.cursorIndex)		; $743c
	cp $02			; $743f
	jp z,resetGame		; $7441

	call _saveQuitMenu_checkIsGameOver		; $7444
	jp z,_closeMenu		; $7447

	; Reset game
	ld a,THREAD_1		; $744a
	ld bc,mainThreadStart		; $744c
	call threadRestart		; $744f
	jp stubThreadStart		; $7452

;;
; @addr{7455}
_saveQuitMenu_drawSprites:
	call fileSelect_redrawDecorationsAndSetWramBank4		; $7455

	; Flicker acorn if applicable
	ld a,(wSaveQuitMenu.delayCounter)		; $7458
	and $04			; $745b
	ret nz			; $745d

	ld c,a ; c = 0
	ld a,(wSaveQuitMenu.cursorIndex)		; $745f
	ld b,a			; $7462
	add a			; $7463
	add b			; $7464
	swap a			; $7465
	rrca			; $7467
	ld b,a			; $7468
	ld hl,@acornSprite		; $7469
	jp addSpritesToOam_withOffset		; $746c

@acornSprite:
	.db $01
	.db $48 $29 $28 $04


;;
; Run the secret list menu from farore's book.
;
; @addr{7474}
_runSecretListMenu:
	call clearOam		; $7474
	ld a,TEXT_BANK		; $7477
	ld ($ff00+R_SVBK),a	; $7479
	call @runState		; $747b
	jp _secretListMenu_drawCursorSprite		; $747e

@runState:
	ld a,(wSecretListMenu.state)		; $7481
	rst_jumpTable			; $7484
	.dw _secretListMenu_state0
	.dw _secretListMenu_state1
	.dw _secretListMenu_state2

;;
; State 0: initialization
; @addr{748b}
_secretListMenu_state0:
	call disableLcd		; $748b
	call stopTextThread		; $748e

	ld a,$01		; $7491
	ld (wSecretListMenu.state),a		; $7493
	call @clearVramBank		; $7496
	xor a			; $7499
	call @clearVramBank		; $749a

	ld a,GFXH_05		; $749d
	call loadGfxHeader		; $749f
	ld a,PALH_SECRET_LIST_MENU		; $74a2
	call loadPaletteHeader		; $74a4
	call _secretListMenu_loadAllSecretNames		; $74a7
	ld a,$ff		; $74aa
	call _secretListMenu_printSecret		; $74ac
	call fastFadeinFromWhite		; $74af
	ld a,$16		; $74b2
	jp loadGfxRegisterStateIndex		; $74b4

;;
; @param	a	Vram bank to fill with $ff
; @addr{74b7}
@clearVramBank:
	ld ($ff00+R_VBK),a	; $74b7
	ld hl,$8000		; $74b9
	ld bc,$1000		; $74bc
	ld a,$ff		; $74bf
	jp fillMemoryBc		; $74c1

;;
; State 1: processing input
; @addr{74c4}
_secretListMenu_state1:
	ld a,(wPaletteThread_mode)		; $74c4
	or a			; $74c7
	ret nz			; $74c8

	ld a,(wKeysJustPressed)		; $74c9
	and (BTN_START|BTN_SELECT|BTN_B)			; $74cc
	jp nz,_closeMenu		; $74ce

	call getInputWithAutofire		; $74d1
	ld c,a			; $74d4
	ld hl,wSecretListMenu.numEntries		; $74d5
	ldi a,(hl)		; $74d8
	ld b,a			; $74d9
	ld a,$ff		; $74da

	bit BTN_BIT_UP,c			; $74dc
	jr nz,@upOrDown		; $74de
	bit BTN_BIT_DOWN,c			; $74e0
	jr z,@end		; $74e2
	ld a,$01		; $74e4
@upOrDown:
	; Try to move cursor, stop if we're at the maximum
	add (hl) ; hl = wSecretListMenu.cursorIndex
	cp b			; $74e7
	jr nc,@end		; $74e8

	ldi (hl),a		; $74ea
	sub (hl) ; hl = wSecretListMenu.scroll
	cp $01			; $74ec
	jr c,@scrollUp		; $74ee
	cp $03			; $74f0
	jr c,@playSound		; $74f2

@scrollDown:
	ldi a,(hl) ; hl = wSecretListMenu.scroll
	sub b			; $74f5
	cp $fc			; $74f6
	jr nc,@playSound	; $74f8
	ld a,$02		; $74fa
	jr ++			; $74fc

@scrollUp:
	ldi a,(hl)		; $74fe
	or a			; $74ff
	jr z,@playSound	; $7500
	ld a,$fe		; $7502
++
	ld (wSecretListMenu.scrollSpeed),a		; $7504
	ld l,<wSecretListMenu.state		; $7507
	inc (hl) ; Go to state 2 (scrolling)

@playSound:
	ld a,SND_MENU_MOVE	; $750a
	call playSound		; $750c

@end:
	ld a,(wSaveQuitMenu.delayCounter)		; $750f
	jr _secretListMenu_printSecret		; $7512

;;
; State 2: scrolling
; @addr{7514}
_secretListMenu_state2:
	ld hl,wSecretListMenu.scrollSpeed		; $7514
	ld a,(wGfxRegs2.SCY)		; $7517
	add (hl)		; $751a
	ld (wGfxRegs2.SCY),a		; $751b
	and $0f			; $751e
	ret nz			; $7520

	; Done scrolling
	ld a,(hl)		; $7521
	sra a			; $7522
	ld l,<wSecretListMenu.scroll		; $7524
	add (hl)		; $7526
	ld (hl),a		; $7527
	ld l,<wSecretListMenu.state		; $7528
	dec (hl) ; Go to state 1
	ret			; $752b

;;
; @addr{752c}
_secretListMenu_drawCursorSprite:
	ld a,(wGfxRegs2.SCY)		; $752c
	ld b,a			; $752f
	ld a,(wSecretListMenu.cursorIndex)		; $7530
	swap a			; $7533
	sub b			; $7535
	ld b,a			; $7536
	ld c,$00		; $7537
	ld hl,@cursor		; $7539
	jp addSpritesToOam_withOffset		; $753c

@cursor;
	.db $01
	.db $5a $14 $0c $24

;;
; @param	a	Index of secret to print (or $ff for nothing)
; @addr{7544}
_secretListMenu_printSecret:
	ld hl,wTmpcbb9		; $7544
	cp (hl)			; $7547
	ret z			; $7548

	ld (hl),a		; $7549
	push af			; $754a

	ld hl,w7d800		; $754b
	ld bc,$0300		; $754e
	call clearMemoryBc		; $7551

	ld hl,w7SecretText1		; $7554
	ld b,$c*2		; $7557
	call clearMemory		; $7559

	pop af			; $755c
	cp $ff			; $755d
	jr z,@end		; $755f

	call _secretListMenu_getSecretData		; $7561
	ldi a,(hl)		; $7564
	rlca			; $7565
	rlca			; $7566
	and $03			; $7567
	ld b,a			; $7569
	ldi a,(hl)		; $756a
	ld c,(hl)		; $756b
	call checkGlobalFlag		; $756c
	ld a,$ff		; $756f
	ld (wFileSelect.fontXor),a		; $7571
	jr z,_secretListMenu_printSecret	; $7574

	call @getSecretText		; $7576
	ld hl,w7SecretText1		; $7579
	ld de,w7d800		; $757c
	ld b,$c*2		; $757f
	call _copyTextCharactersFromHl		; $7581
@end:
	ld a,UNCMP_GFXH_35		; $7584
	jp loadUncompressedGfxHeader		; $7586

@getSecretText:
	ld a,b			; $7589
	rst_jumpTable			; $758a
	.dw @val0
	.dw @val1
	.dw @val2
	.dw @val3

@val0: ; game-transfer secret
@val1:
	jpab generateGameTransferSecret		; $7593

@val2: ; ring secret
	ldbc $00,$02		; $759b
	jp secretFunctionCaller		; $759e

@val3: ; 5-letter secret
	ld a,c			; $75a1
	ld (wShortSecretIndex),a		; $75a2
	ld c,b			; $75a5
	ld b,$00		; $75a6
	jp secretFunctionCaller		; $75a8

;;
; Loads gfx for all secret names directly to vram starting at $8a00.
;
; @addr{75ab}
_secretListMenu_loadAllSecretNames:
	xor a			; $75ab
	ld ($ff00+R_VBK),a	; $75ac

	ld de,$8a00		; $75ae
	ld b,$00		; $75b1
@nextSecret:
	ld a,b			; $75b3
	call _secretListMenu_getSecretData		; $75b4
	ldi a,(hl)		; $75b7
	or a			; $75b8
	jr z,@end		; $75b9

	push bc			; $75bb
	ld c,a			; $75bc
	ldi a,(hl)		; $75bd
	call checkGlobalFlag		; $75be
	ld a,$01 ; If we don't have this secret, show a dashed line
	jr z,++			; $75c3

	ld a,c			; $75c5
	and $3f			; $75c6
	call _copyTextCharactersFromSecretTextTable		; $75c8
	ld a,$02 ; Put " Secret" after every string
++
	call _copyTextCharactersFromSecretTextTable		; $75cd
	pop bc			; $75d0

	; Adjust de to point to next row
	dec de			; $75d1
	ld e,$00		; $75d2
	ld a,d			; $75d4
	and $fe			; $75d5
	add $02			; $75d7

	; If we've reached address 0:9000, loop around to 1:8000.
	cp $90			; $75d9
	jr c,++			; $75db
	ld a,$01		; $75dd
	ld ($ff00+R_VBK),a	; $75df
	ld a,$80		; $75e1
++
	ld d,a			; $75e3
	inc b			; $75e4
	jr @nextSecret		; $75e5

@end:
	ld a,b			; $75e7
	ld (wSecretListMenu.numEntries),a		; $75e8
	ret			; $75eb

;;
; @param	a	Index
; @addr{75ec}
_secretListMenu_getSecretData:
	ld hl,wFileIsLinkedGame		; $75ec
	bit 0,(hl)		; $75ef
	ld hl,@unlinked		; $75f1
	jr z,+			; $75f4
	ld hl,@linked		; $75f6
+
	push bc			; $75f9

	ld c,a ; a *= 3
	add a			; $75fb
	add c			; $75fc

	rst_addAToHl			; $75fd
	pop bc			; $75fe
	ret			; $75ff


; The following data is the list of secrets to be displayed on farore's secret list.
;   b0: bits 0-5: Index for name (possibly for secret too?)
;       bits 6-7: secret "mode" (0/1=game-transfer, 2=ring secret, 3=other)
;   b1: global flag which, if set, means the secret is unlocked
;   b2: Index of secret data?

.ifdef ROM_AGES
	@unlinked:
		.db $03 GLOBALFLAG_FINISHEDGAME			$00
		.db $85 GLOBALFLAG_RING_SECRET_GENERATED	$02
		.db $d0 GLOBALFLAG_DONE_KING_ZORA_SECRET	$10
		.db $d4 GLOBALFLAG_DONE_LIBRARY_SECRET		$14
		.db $d5 GLOBALFLAG_DONE_TROY_SECRET		$12
		.db $d7 GLOBALFLAG_DONE_TINGLE_SECRET		$17
		.db $d9 GLOBALFLAG_DONE_SYMMETRY_SECRET		$19
		.db $d1 GLOBALFLAG_DONE_FAIRY_SECRET		$11
		.db $d8 GLOBALFLAG_DONE_ELDER_SECRET		$18
		.db $d2 GLOBALFLAG_DONE_TOKAY_SECRET		$15
		; Don't display plen secret or mamamu secret, since rings can be exchanged
		; through vasu instead.
		.db $00

	@linked:
		.db $85 GLOBALFLAG_RING_SECRET_GENERATED	$02
		.db $c6 GLOBALFLAG_50 	$20
		.db $ca GLOBALFLAG_54 	$24
		.db $cb GLOBALFLAG_55 	$25
		.db $cd GLOBALFLAG_57 	$27
		.db $cf GLOBALFLAG_59 	$29
		.db $c7 GLOBALFLAG_51 	$21
		.db $ce GLOBALFLAG_58 	$28
		.db $c8 GLOBALFLAG_52 	$22
		.db $c9 GLOBALFLAG_53 	$23
		.db $cc GLOBALFLAG_56 	$26
		.db $00

.else; ROM_SEASONS

	@unlinked:
		.db $04 GLOBALFLAG_FINISHEDGAME	$00
		.db $85 GLOBALFLAG_RING_SECRET_GENERATED	$02
		.db $c6 GLOBALFLAG_5a	$30
		.db $ca GLOBALFLAG_5e	$34
		.db $cb GLOBALFLAG_5f	$35
		.db $cd GLOBALFLAG_61	$37
		.db $cf GLOBALFLAG_63	$39
		.db $c7 GLOBALFLAG_5b	$31
		.db $ce GLOBALFLAG_62	$38
		.db $c8 GLOBALFLAG_5c	$32
		.db $00

	@linked:
		.db $85 GLOBALFLAG_RING_SECRET_GENERATED	$02
		.db $d0 GLOBALFLAG_BEGAN_KING_ZORA_SECRET	$00
		.db $d4 GLOBALFLAG_BEGAN_LIBRARY_SECRET		$04
		.db $d5 GLOBALFLAG_BEGAN_TROY_SECRET		$02
		.db $d7 GLOBALFLAG_BEGAN_TINGLE_SECRET		$07
		.db $d9 GLOBALFLAG_BEGAN_SYMMETRY_SECRET	$09
		.db $d1 GLOBALFLAG_BEGAN_FAIRY_SECRET		$01
		.db $d8 GLOBALFLAG_BEGAN_ELDER_SECRET		$08
		.db $d2 GLOBALFLAG_BEGAN_TOKAY_SECRET		$05
		.db $d3 GLOBALFLAG_BEGAN_PLEN_SECRET		$03
		.db $d6 GLOBALFLAG_BEGAN_MAMAMU_SECRET		$06
		.db $00

.endif; ROM_SEASONS

;;
; Runs the fake reset that happens when getting the sign ring in Seasons.
;
; @addr{7641}
_runFakeReset:
	ld a,(wFakeResetMenu.state)		; $7641
	rst_jumpTable			; $7644
	.dw @state0
	.dw @state1

@state0:
	call disableLcd		; $7649
	call clearOam		; $764c
	call clearVram		; $764f
	call initializeVramMaps		; $7652

	ld a,SNDCTRL_DISABLE		; $7655
	call playSound		; $7657

	ld a,GFXH_01		; $765a
	call loadGfxHeader		; $765c
	ld a,PALH_01		; $765f
	call loadPaletteHeader		; $7661

	ld a,120 ; Wait 2 seconds before fading the nintendo/capcom logo away
	ld (wFakeResetMenu.delayCounter),a		; $7666

	ld hl,wFakeResetMenu.state		; $7669
	inc (hl)		; $766c

	call fadeinFromWhite		; $766d
	xor a			; $7670
	jp loadGfxRegisterStateIndex		; $7671

@state1:
	ld a,(wPaletteThread_mode)		; $7674
	or a			; $7677
	ret nz			; $7678
	ld hl,wFakeResetMenu.delayCounter		; $7679
	dec (hl)		; $767c
	ret nz			; $767d

	ld a,SNDCTRL_ENABLE		; $767e
	call playSound		; $7680
	ld hl,wMenuLoadState		; $7683
	inc (hl)		; $7686
	jp fadeoutToWhite		; $7687


.ifdef ROM_AGES

.include "code/roomInitialization.s"
.include "code/ages/roomGfxChanges.s"


.ifdef BUILD_VANILLA

; From here on are corrupted repeats of functions starting from
; "readParametersForRectangleDrawing".

;;
; @addr{7de7}
_fake_readParametersForRectangleDrawing:
	ldi a,(hl)		; $7de7
	ld b,a			; $7de8
	ldi a,(hl)		; $7de9
	ld c,a			; $7dea
	ret			; $7deb

;;
; @addr{7dec}
_fake_drawRectangleToVramTiles_withParameters:
	ld a,($ff00+R_SVBK)	; $7dec
	push af			; $7dee
	ld a,$03		; $7def
	ld ($ff00+R_SVBK),a	; $7df1
	jr _fake_drawRectangleToVramTiles@nextRow			; $7df3

;;
; @addr{7df5}
_fake_drawRectangleToVramTiles:
	ld a,($ff00+R_SVBK)	; $7df5
	push af			; $7df7
	ld a,$03		; $7df8
	ld ($ff00+R_SVBK),a	; $7dfa
	call $7de3		; $7dfc

@nextRow:
	push bc			; $7dff
--
	ldi a,(hl)		; $7e00
	ld (de),a		; $7e01
	set 2,d			; $7e02
	ldi a,(hl)		; $7e04
	ld (de),a		; $7e05
	res 2,d			; $7e06
	inc de			; $7e08
	dec c			; $7e09
	jr nz,--		; $7e0a

	pop bc			; $7e0c
	ld a,$20		; $7e0d
	sub c			; $7e0f
	call addAToDe		; $7e10
	dec b			; $7e13
	jr nz,@nextRow		; $7e14

	pop af			; $7e16
	ld ($ff00+R_SVBK),a	; $7e17
	ret			; $7e19

;;
; @addr{7e1a}
_fake_copyRectangleFromVramTilesToAddress_paramBc:
	ld l,c			; $7e1a
	ld h,b			; $7e1b

;;
; @addr{7e1c}
_fake_copyRectangleFromVramTilesToAddress:
	ld a,($ff00+R_SVBK)	; $7e1c
	push af			; $7e1e

	ldi a,(hl)		; $7e1f
	ld b,a			; $7e20
	ldi a,(hl)		; $7e21
	ld c,a			; $7e22
	ldi a,(hl)		; $7e23
	ld e,a			; $7e24
	ldi a,(hl)		; $7e25
	ld d,a			; $7e26
	ldi a,(hl)		; $7e27
	ld h,(hl)		; $7e28
	ld l,a			; $7e29

@nextRow:
	push bc			; $7e2a
--
	ld a,$02		; $7e2b
	ld ($ff00+R_SVBK),a	; $7e2d
	ldi a,(hl)		; $7e2f
	ld b,a			; $7e30
	ld a,$03		; $7e31
	ld ($ff00+R_SVBK),a	; $7e33
	ld a,b			; $7e35
	ld (de),a		; $7e36
	inc de			; $7e37
	dec c			; $7e38
	jr nz,--		; $7e39
	pop bc			; $7e3b
	ld a,$20		; $7e3c
	sub c			; $7e3e
	call addAToDe		; $7e3f
	ld a,$20		; $7e42
	sub c			; $7e44
	rst_addAToHl			; $7e45
	dec b			; $7e46
	jr nz,@nextRow		; $7e47

	pop af			; $7e49
	ld ($ff00+R_SVBK),a	; $7e4a
	ret			; $7e4c

;;
; @addr{7e4d}
_fake_copyRectangleToRoomLayoutAndCollisions:
	ldi a,(hl)		; $7e4d
	ld e,a			; $7e4e
	ldi a,(hl)		; $7e4f
	ld d,a			; $7e50

;;
; @addr{7e51}
_fake_copyRectangleToRoomLayoutAndCollisions_paramDe:
	ldi a,(hl)		; $7e51
	ld b,a			; $7e52
	ldi a,(hl)		; $7e53
	ld c,a			; $7e54

@nextRow:
	push bc			; $7e55
--
	ldi a,(hl)		; $7e56
	ld (de),a		; $7e57
	dec d			; $7e58
	ldi a,(hl)		; $7e59
	ld (de),a		; $7e5a
	inc d			; $7e5b
	inc de			; $7e5c
	dec c			; $7e5d
	jr nz,--		; $7e5e
	pop bc			; $7e60
	ld a,$10		; $7e61
	sub c			; $7e63
	call addAToDe		; $7e64
	dec b			; $7e67
	jr nz,@nextRow		; $7e68
	ret			; $7e6a

;;
; @addr{7e6b}
_fake_roomTileChangesAfterLoad04:
	ld hl,wInShop		; $7e6b
	set 1,(hl)		; $7e6e
	ld a,TREE_GFXH_03		; $7e70
	jp $1686		; $7e72

;;
; @addr{7e75}
_fake_checkLoadPastSignAndChestGfx:
	ld a,(wDungeonIndex)		; $7e75
	cp $0f			; $7e78
	ret z			; $7e7a

	ld a,(wAreaFlags)		; $7e7b
	bit 7,a			; $7e7e
	ret z			; $7e80

	bit 0,a			; $7e81
	ret nz			; $7e83

	bit 5,a			; $7e84
	ret nz			; $7e86

	and $1c			; $7e87
	ret z			; $7e89

	ld a,UNCMP_GFXH_37		; $7e8a
	jp $05df		; $7e8c

_fake_rectangleData_02_7de1:
	.db $06 $06
	.dw w3VramTiles+8 w2TmpGfxBuffer

.endif ; BUILD_VANILLA
.endif ; ROM_AGES

.ENDS
