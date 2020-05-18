; ==============================================================================
; INTERACID_ERA_OR_SEASON_INFO
; ==============================================================================
interactionCodee0:
	ld e,Interaction.state		; $6f00
	ld a,(de)		; $6f02
	rst_jumpTable			; $6f03
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01		; $6f0c
	ld (de),a ; [state]

.ifdef ROM_AGES
	ld a,(wTilesetFlags)		; $6f0f
	and TILESETFLAG_PAST			; $6f12
	rlca			; $6f14
.else
	ld a,(wLoadingRoomPack)		; $4c15
	inc a			; $4c18
	jr z,+			; $4c19
	ld a,(wRoomStateModifier)		; $4c1b
+
.endif

	ld e,Interaction.subid		; $6f15
	ld (de),a		; $6f17

	call interactionInitGraphics		; $6f18
	call interactionSetAlwaysUpdateBit		; $6f1b
	ld l,Interaction.yh		; $6f1e
	ld (hl),$0a		; $6f20
	ld l,Interaction.xh		; $6f22
	ld (hl),$b0		; $6f24
	jp objectSetVisible80		; $6f26

@state1:
	ld h,d			; $6f29
	ld l,Interaction.xh		; $6f2a
	ld a,(hl)		; $6f2c
	sub $04			; $6f2d
	ld (hl),a		; $6f2f
	cp $10			; $6f30
	ret nz			; $6f32
	ld l,e			; $6f33
	inc (hl)		; $6f34
	ld l,Interaction.counter1		; $6f35
	ld (hl),40		; $6f37
	ret			; $6f39

@state2:
	call interactionDecCounter1		; $6f3a
	ret nz			; $6f3d
	ld l,e			; $6f3e
	inc (hl)		; $6f3f
	ld l,Interaction.counter1		; $6f40
	ld (hl),$06		; $6f42
	ret			; $6f44

@state3:
	ld h,d			; $6f45
	ld l,Interaction.xh		; $6f46
	ld a,(hl)		; $6f48
	sub $06			; $6f49
	ld (hl),a		; $6f4b
	ld l,Interaction.counter1		; $6f4c
	dec (hl)		; $6f4e
	ret nz			; $6f4f
	jp interactionDelete		; $6f50


; ==============================================================================
; INTERACID_STATUE_EYEBALL
; ==============================================================================
interactionCodee2:
	ld e,Interaction.subid		; $6f53
	ld a,(de)		; $6f55
	rst_jumpTable			; $6f56
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
	call checkInteractionState		; $6f61
	jr z,@state0Common	; $6f64

	; State 1
	ld a,(wScrollMode)		; $6f66
	and $01			; $6f69
	ret z			; $6f6b
	call @getDirectionToFace		; $6f6c
	jp interactionSetAnimation		; $6f6f

; Used by subid 0, 2, and 4
@state0Common:
	ld a,$01		; $6f72
	ld (de),a		; $6f74
	call interactionInitGraphics		; $6f75
	jp objectSetVisible83		; $6f78

@subid2:
	call checkInteractionState		; $6f7b
	jr z,@state0Common	; $6f7e

	; State 1
	ld a,(wScrollMode)		; $6f80
	and $01			; $6f83
	ret z			; $6f85

	call @centerOnTileAndGetDirectionToFace		; $6f86

@offsetPositionTowardLookingDirection:
	ld hl,@lowPositionValues		; $6f89
	rst_addDoubleIndex			; $6f8c
	ld e,Interaction.yh		; $6f8d
	ld a,(de)		; $6f8f
	and $f0			; $6f90
	or (hl)			; $6f92
	ld (de),a		; $6f93
	inc hl			; $6f94
	ld e,Interaction.xh		; $6f95
	ld a,(de)		; $6f97
	and $f0			; $6f98
	or (hl)			; $6f9a
	ld (de),a		; $6f9b
	ret			; $6f9c

; Values for the lower 4 bits of the Y/X position, based on the direction it's facing. For subid
; 2 and 4 only (they are offset further in the direction they're looking).
@lowPositionValues:
	.db $05 $08
	.db $05 $09
	.db $06 $09
	.db $07 $09
	.db $07 $08
	.db $07 $07
	.db $06 $07
	.db $05 $07

;;
; @addr{6fad}
@centerOnTileAndGetDirectionToFace:
	call objectCenterOnTile		; $6fad

;;
; Gets the direction the angle should face, as a number from 0-7. (This isn't a standard direction
; or angle value.)
;
; @param[out]	a	Direction (0-7)
; @addr{6fb0}
@getDirectionToFace:
	call objectGetAngleTowardLink		; $6fb0
	ld b,a			; $6fb3
	and $07			; $6fb4
	jr z,@@returnValue	; $6fb6
	cp $01			; $6fb8
	jr z,@@returnValue	; $6fba
	cp $07			; $6fbc
	jr z,@@returnValue	; $6fbe
	ld a,b			; $6fc0
	and $fc			; $6fc1
	or $04			; $6fc3
	ld b,a			; $6fc5

@@returnValue:
	ld a,b			; $6fc6
	rrca			; $6fc7
	rrca			; $6fc8
	and $07			; $6fc9
	ret			; $6fcb


; Spawner for subid 2
@subid1:
	ld e,$02 ; subid

@spawnChildren:
	ld bc,wRoomLayout + LARGE_ROOM_WIDTH-1 + (LARGE_ROOM_HEIGHT-1)*16
--
	ld a,(bc)		; $6fd1
	cp TILEINDEX_EYE_STATUE			; $6fd2
	call z,@spawnChild		; $6fd4
	dec c			; $6fd7
	jr nz,--		; $6fd8
	jp interactionDelete		; $6fda

;;
; @param	c	position
; @param	e	subid
; @addr{6fdd}
@spawnChild:
	call getFreeInteractionSlot		; $6fdd
	ret nz			; $6fe0
	ld (hl),INTERACID_STATUE_EYEBALL		; $6fe1
	inc l			; $6fe3
	ld (hl),e ; [subid]
	push bc			; $6fe5
	call convertShortToLongPosition_paramC		; $6fe6
	ld l,Interaction.yh		; $6fe9
	dec b			; $6feb
	dec b			; $6fec
	ld (hl),b		; $6fed
	inc l			; $6fee
	inc l			; $6fef
	ld (hl),c		; $6ff0
	pop bc			; $6ff1
	ret			; $6ff2


; Spawner for subid 4
@subid3:
	call returnIfScrollMode01Unset		; $6ff3
	ld a,(wEyePuzzleTransitionCounter)		; $6ff6
	cp $06			; $6ff9
	ld a,$00		; $6ffb
	jr nc,++		; $6ffd

	; Choose random direction to go
--
	call getRandomNumber		; $6fff
	and $03			; $7002
	cp $02			; $7004
	jr z,--			; $7006
++
	ld (wEyePuzzleCorrectDirection),a		; $7008
	ld e,$04		; $700b
	jr @spawnChildren		; $700d


@subid4:
	ld e,Interaction.state		; $700f
	ld a,(de)		; $7011
	rst_jumpTable			; $7012
	.dw @state0Common
	.dw @@state1
	.dw objectSetVisible83

@@state1:
	call checkInteractionState2	; $7019
	jr z,@substate0	; $701c

	call interactionDecCounter1		; $701e
	jr nz,@eyeSpinning	; $7021

	; Eye is done spinning.
	call interactionIncState		; $7023
	ld a,(wEyePuzzleCorrectDirection)		; $7026
	ld b,a			; $7029

	; Abuse the frame counter to get a random direction to face? (I guess this is so that all of
	; the eyes are guaranteed to point in various different directions? But this screws up the
	; frame counter value. I don't like it.)
--
	ld hl,wFrameCounter		; $702a
	inc (hl)		; $702d
	ld a,(hl)		; $702e
	and $03			; $702f
	cp b			; $7031
	jr z,--			; $7032

	add a			; $7034
	jp @offsetPositionTowardLookingDirection		; $7035

@eyeSpinning:
	ld a,(wFrameCounter)		; $7038
	and $03			; $703b
	ret nz			; $703d
	call getRandomNumber		; $703e
	and $07			; $7041
	jp @offsetPositionTowardLookingDirection		; $7043

@substate0:
	ld a,60		; $7046
	ld (de),a ; [state2] = nonzero
	ld e,Interaction.counter1		; $7049
	ld (de),a		; $704b
	ret			; $704c


; ==============================================================================
; INTERACID_RING_HELP_BOOK
; ==============================================================================
interactionCodee5:
	ld a,(wTextIsActive)		; $704d
	or a			; $7050
	jr nz,@doneTextFlagSetup	; $7051

	ld a,$02		; $7053
	ld (wTextboxPosition),a		; $7055
	ld a,TEXTBOXFLAG_DONTCHECKPOSITION		; $7058
	ld (wTextboxFlags),a		; $705a
@doneTextFlagSetup:

	call @runState		; $705d
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7060

@runState:
	ld e,Interaction.state		; $7063
	ld a,(de)		; $7065
	rst_jumpTable			; $7066
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics		; $706b
	ld a,>TX_3000		; $706e
	call interactionSetHighTextIndex		; $7070
	call interactionSetAlwaysUpdateBit		; $7073
	call interactionIncState		; $7076
	ld a,$06		; $7079
	call objectSetCollideRadius		; $707b

	ld e,Interaction.subid		; $707e
	ld a,(de)		; $7080
	ld hl,ringHelpBookSubid0Script		; $7081
	or a			; $7084
	jr z,++			; $7085

	ld e,Interaction.oamFlags		; $7087
	ld a,(de)		; $7089
	inc a			; $708a
	ld (de),a		; $708b
	ld hl,ringHelpBookSubid1Script		; $708c
++
	call interactionSetScript		; $708f
	ld e,Interaction.pressedAButton		; $7092
	jp objectAddToAButtonSensitiveObjectList		; $7094

@state1:
	jp interactionRunScript		; $7097


; ==============================================================================
; Some cutsene stuff is put here in the middle of the interaction bank, for some reason?
; ==============================================================================


; Input values for the intro cutscene in the temple
templeIntro_simulatedInput:
	dwb   45  $00
	dwb   16  BTN_UP
	dwb   48  $00
	dwb   32  BTN_UP
	dwb   24  $00
	dwb   32  BTN_UP
	dwb   48  $00
	dwb   34  BTN_UP
	dwb  112  $00
	dwb    5  BTN_UP
	dwb   32  $00
	dwb    5  BTN_UP
	dwb   36  $00
	dwb    5  BTN_UP
	dwb   36  $00
	dwb    5  BTN_UP
	dwb   36  $00
	dwb   12  BTN_UP
	.dw $ffff

; Exiting tower
blackTowerEscape_simulatedInput1:
	dwb  96 $00
	; Fall though

; Leaving screen
blackTowerEscape_simulatedInput2:
	dwb  33 BTN_DOWN
	dwb 256 $00
	.dw $ffff

; Walking up to ambi's guards
blackTowerEscape_simulatedInput3:
	dwb  48 BTN_UP
	dwb   4 $00
	dwb  16 BTN_RIGHT
	dwb   1 BTN_UP
	dwb 256 $00
	.dw $ffff

; Same room as above
blackTowerEscape_simulatedInput4:
	dwb  16 BTN_UP
	dwb 256 $00
	.dw $ffff


agesFunc_10_70f6:
	xor a			; $70f6
	ldh (<hOamTail),a	; $70f7
	ld de,$cbc2		; $70f9
	ld a,(de)		; $70fc
	rst_jumpTable			; $70fd
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
@substate0:
	ld a,(wPaletteThread_mode)		; $7110
	or a			; $7113
	ret nz			; $7114
	call incCbc2		; $7115
	call disableLcd		; $7118
	call clearDynamicInteractions		; $711b
	call clearOam		; $711e
	xor a			; $7121
	ld ($cfde),a		; $7122
	ld a,$95		; $7125
	call loadGfxHeader		; $7127
	ld a,PALH_a0		; $712a
	call loadPaletteHeader		; $712c
	ld a,$09		; $712f
	call loadGfxRegisterStateIndex		; $7131
	call fadeinFromWhite		; $7134
	call getFreeInteractionSlot		; $7137
	ret nz			; $713a
	ld (hl),INTERACID_CREDITS_TEXT_VERTICAL		; $713b
	ld l,$4b		; $713d
	ld (hl),$e8		; $713f
	inc l			; $7141
	inc l			; $7142
	ld (hl),$50		; $7143
	ret			; $7145
@substate1:
	ld a,($cfdf)		; $7146
	or a			; $7149
	ret z			; $714a
	ld hl,wTmpcbb3		; $714b
	ld (hl),$e0		; $714e
	inc hl			; $7150
	ld (hl),$01		; $7151
	jp incCbc2		; $7153
@substate2:
	ld hl,wTmpcbb3		; $7156
	call decHlRef16WithCap		; $7159
	ret nz			; $715c
	call checkIsLinkedGame		; $715d
	jr nz,@func_7174	; $7160
	callab cutscene_clearTmpCBB3		; $7162
	ld a,$03		; $716a
	ld ($cbc1),a		; $716c
	ld a,$04		; $716f
	jp fadeoutToWhiteWithDelay		; $7171
@func_7174:
	ld a,$04		; $7174
	ld (wTmpcbb3),a		; $7176
	ld a,(wGfxRegs1.SCY)		; $7179
	ldh (<hCameraY),a	; $717c
	ld a,UNCMP_GFXH_01		; $717e
	call loadUncompressedGfxHeader		; $7180
	ld a,PALH_0b		; $7183
	call loadPaletteHeader		; $7185
	ld b,$03		; $7188
-
	call getFreeInteractionSlot		; $718a
	jr nz,+			; $718d
	ld (hl),INTERACID_INTRO_SPRITES_1		; $718f
	inc l			; $7191
	ld (hl),$09		; $7192
	inc l			; $7194
	dec b			; $7195
	ld (hl),b		; $7196
	jr nz,-			; $7197
+
	jp incCbc2		; $7199
@substate3:
	ld a,(wGfxRegs1.SCY)		; $719c
	or a			; $719f
	jr nz,@func_71aa	; $71a0
	ld a,$78		; $71a2
	ld (wTmpcbb3),a		; $71a4
	jp incCbc2		; $71a7
@func_71aa:
	call decCbb3		; $71aa
	ret nz			; $71ad
	ld (hl),$04		; $71ae
	ld hl,wGfxRegs1.SCY		; $71b0
	dec (hl)		; $71b3
	ld a,(hl)		; $71b4
	ldh (<hCameraY),a	; $71b5
	ret			; $71b7
@substate4:
	call decCbb3		; $71b8
	ret nz			; $71bb
	ld a,$ff		; $71bc
	ld (wTmpcbba),a		; $71be
	jp incCbc2		; $71c1
@substate5:
	ld hl,wTmpcbb3		; $71c4
	ld b,$01		; $71c7
	call flashScreen		; $71c9
	ret z			; $71cc
	call disableLcd		; $71cd
	ld a,$9a		; $71d0
	call loadGfxHeader		; $71d2
	ld a,PALH_9f		; $71d5
	call loadPaletteHeader		; $71d7
	call clearDynamicInteractions		; $71da
	ld b,$03		; $71dd
-
	call getFreeInteractionSlot		; $71df
	jr nz,+			; $71e2
	ld (hl),INTERACID_cf		; $71e4
	inc l			; $71e6
	dec b			; $71e7
	ld (hl),b		; $71e8
	jr nz,-			; $71e9
+
	ld a,$04		; $71eb
	call loadGfxRegisterStateIndex		; $71ed
	ld a,$04		; $71f0
	call fadeinFromWhiteWithDelay		; $71f2
	call incCbc2		; $71f5
	ld a,$f0		; $71f8
	ld (wTmpcbb3),a		; $71fa
@func_71fd:
	xor a			; $71fd
	ldh (<hOamTail),a	; $71fe
	ld a,(wGfxRegs1.SCY)		; $7200
	cp $60			; $7203
	jr nc,+			; $7205
	cpl			; $7207
	inc a			; $7208
	ld b,a			; $7209
	ld a,(wFrameCounter)		; $720a
	and $01			; $720d
	jr nz,+			; $720f
	ld c,a			; $7211
	ld hl,bank16.oamData_4ed8		; $7212
	ld e,:bank16.oamData_4ed8		; $7215
	call addSpritesFromBankToOam_withOffset		; $7217
+
	ld a,(wGfxRegs1.SCY)		; $721a
	cpl			; $721d
	inc a			; $721e
	ld b,$c7		; $721f
	add b			; $7221
	ld b,a			; $7222
	ld c,$38		; $7223
	ld hl,bank16.oamData_4f21		; $7225
	ld e,:bank16.oamData_4f21		; $7228
	push bc			; $722a
	call addSpritesFromBankToOam_withOffset		; $722b
	pop bc			; $722e
	ld a,(wGfxRegs1.SCY)		; $722f
	cp $60			; $7232
	ret c			; $7234
	ld hl,bank16.oamData_4f56		; $7235
	ld e,:bank16.oamData_4f56		; $7238
	jp addSpritesFromBankToOam_withOffset		; $723a
@substate6:
	call @func_71fd		; $723d
	ld a,(wPaletteThread_mode)		; $7240
	or a			; $7243
	ret nz			; $7244
	call decCbb3		; $7245
	ret nz			; $7248
	ld a,$04		; $7249
	ld (wTmpcbb3),a		; $724b
	jp incCbc2		; $724e
@substate7:
	ld a,(wGfxRegs1.SCY)		; $7251
	cp $98			; $7254
	jr nz,@func_7262	; $7256
	ld a,$f0		; $7258
	ld (wTmpcbb3),a		; $725a
	call incCbc2		; $725d
	jr ++			; $7260
@func_7262:
	call decCbb3		; $7262
	jr nz,++		; $7265
	ld (hl),$04		; $7267
	ld hl,wGfxRegs1.SCY		; $7269
	inc (hl)		; $726c
	ld a,(hl)		; $726d
	ldh (<hCameraY),a	; $726e
	cp $60			; $7270
	jr nz,++		; $7272
	call clearDynamicInteractions		; $7274
	ld a,UNCMP_GFXH_2c		; $7277
	call loadUncompressedGfxHeader		; $7279
++
	jp @func_71fd		; $727c
@substate8:
	call @func_71fd		; $727f
	call decCbb3		; $7282
	ret nz			; $7285
	callab cutscene_clearTmpCBB3		; $7286
	ld a,$03		; $728e
	ld ($cbc1),a		; $7290
	ld a,$04		; $7293
	jp fadeoutToWhiteWithDelay		; $7295


agesFunc_10_7298:
	ld de,$cbc2		; $7298
	ld a,(de)		; $729b
	rst_jumpTable			; $729c
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
	.dw @substate9
	.dw @substateA
	.dw @substateB
@substate0:
	call checkIsLinkedGame		; $72b5
	call nz,agesFunc_10_70f6@func_71fd		; $72b8
	ld a,(wPaletteThread_mode)		; $72bb
	or a			; $72be
	ret nz			; $72bf
	call disableLcd		; $72c0
	call incCbc2		; $72c3
	callab func_60f1		; $72c6
	call clearDynamicInteractions		; $72ce
	call clearOam		; $72d1
	call checkIsLinkedGame		; $72d4
	jp z,@func_72ec		; $72d7
	ld a,$99		; $72da
	call loadGfxHeader		; $72dc
	ld a,PALH_aa		; $72df
	call loadPaletteHeader		; $72e1
	ld hl,objectData.objectData5574		; $72e4
	call parseGivenObjectData		; $72e7
	jr ++			; $72ea
@func_72ec:
	ld a,$98		; $72ec
	call loadGfxHeader		; $72ee
	ld a,PALH_a9		; $72f1
	call loadPaletteHeader		; $72f3
++
	ld a,$04		; $72f6
	call loadGfxRegisterStateIndex		; $72f8
	xor a			; $72fb
	ld hl,hCameraY		; $72fc
	ldi (hl),a		; $72ff
	ldi (hl),a		; $7300
	ldi (hl),a		; $7301
	ld (hl),a		; $7302
	ld hl,wTmpcbb3		; $7303
	ld (hl),$f0		; $7306
	ld (hl),a		; $7308
	ld a,SNDCTRL_MEDIUM_FADEOUT		; $7309
	call playSound		; $730b
	ld a,$04		; $730e
	jp fadeinFromWhiteWithDelay		; $7310
@substate1:
	ld a,(wPaletteThread_mode)		; $7313
	or a			; $7316
	ret nz			; $7317
	call incCbc2		; $7318
@func_731b:
	call checkIsLinkedGame		; $731b
	ret z			; $731e
	ld hl,wTmpcbb4		; $731f
	ld a,(hl)		; $7322
	or a			; $7323
	jr z,@playWaveSoundAtRandomIntervals_body	; $7324
	dec (hl)		; $7326
	ret			; $7327

;;
; Called from playWaveSoundAtRandomIntervals in bank 0.
;
; Part of the cutscene where tokays steal your stuff? "SND_WAVE" gets played at random
; intervals?
;
; @param	hl	Place to write a counter to (how many frames until calling this
;			again)
; @addr{7328}
@playWaveSoundAtRandomIntervals_body:
	push hl			; $7328
	ld a,SND_WAVE		; $7329
	call playSound		; $732b
	pop hl			; $732e
	call getRandomNumber		; $732f
	and $03			; $7332
	ld bc,@@data		; $7334
	call addAToBc		; $7337
	ld a,(bc)		; $733a
	ld (hl),a		; $733b
	ret			; $733c

@@data:
	.db $a0 $c8 $10 $f0

@substate2:
	call @func_731b		; $7341
	call decCbb3		; $7344
	ret nz			; $7347
	call incCbc2		; $7348
@substate3:
	call @func_731b		; $734b
	ld hl,wFileIsLinkedGame		; $734e
	ldi a,(hl)		; $7351
	add (hl)		; $7352
	cp $02			; $7353
	ret z			; $7355
	ld a,(wKeysJustPressed)		; $7356
	and (BTN_A|BTN_B|BTN_START)	; $7359
	ret z			; $735b
	call incCbc2		; $735c
	jp fadeoutToWhite		; $735f
@substate4:
	ld a,(wPaletteThread_mode)		; $7362
	or a			; $7365
	ret nz			; $7366
	call incCbc2		; $7367
	call disableLcd		; $736a
	callab generateGameTransferSecret		; $736d
	ld a,$ff		; $7375
	ld (wTmpcbba),a		; $7377
	
	ld a,($ff00+R_SVBK)	; $737a
	push af			; $737c
	ld a,TEXT_BANK		; $737d
	ld ($ff00+R_SVBK),a	; $737f
	ld hl,w7SecretText1		; $7381
	ld de,$d800		; $7384
	ld bc,$1800		; $7387
-
	ldi a,(hl)		; $738a
	call copyTextCharacterGfx		; $738b
	dec b			; $738e
	jr nz,-			; $738f
	pop af			; $7391
	ld ($ff00+R_SVBK),a	; $7392
	
	ld a,$97		; $7394
	call loadGfxHeader		; $7396
	ld a,PALH_05		; $7399
	call loadPaletteHeader		; $739b
	ld a,UNCMP_GFXH_2b		; $739e
	call loadUncompressedGfxHeader		; $73a0
	call checkIsLinkedGame		; $73a3
	ld a,$06		; $73a6
	call nz,loadGfxHeader		; $73a8
	call clearDynamicInteractions		; $73ab
	call clearOam		; $73ae
	ld a,$04		; $73b1
	call loadGfxRegisterStateIndex		; $73b3
	ld hl,wTmpcbb3		; $73b6
	ld (hl),$3c		; $73b9
	call fileSelect_redrawDecorations		; $73bb
	jp fadeinFromWhite		; $73be
@substate5:
	call fileSelect_redrawDecorations		; $73c1
	ld a,(wPaletteThread_mode)		; $73c4
	or a			; $73c7
	ret nz			; $73c8
	call decCbb3		; $73c9
	ret nz			; $73cc
	ld hl,wTmpcbb3		; $73cd
	ld b,$3c		; $73d0
	call checkIsLinkedGame		; $73d2
	jr z,+			; $73d5
	ld b,$b4		; $73d7
+
	ld (hl),b		; $73d9
	jp incCbc2		; $73da
@substate6:
	call fileSelect_redrawDecorations		; $73dd
	call decCbb3		; $73e0
	ret nz			; $73e3
	call checkIsLinkedGame		; $73e4
	jr nz,+			; $73e7
	call getFreeInteractionSlot		; $73e9
	jr nz,+			; $73ec
	ld (hl),$d1		; $73ee
	xor a			; $73f0
	ld ($cfde),a		; $73f1
+
	jp incCbc2		; $73f4
@substate7:
	call fileSelect_redrawDecorations		; $73f7
	call checkIsLinkedGame		; $73fa
	jr z,@func_7407	; $73fd
	ld a,(wKeysJustPressed)		; $73ff
	and $01			; $7402
	jr nz,++		; $7404
	ret			; $7406
@func_7407:
	ld a,($cfde)		; $7407
	or a			; $740a
	ret z			; $740b
++
	call incCbc2		; $740c
	ld a,SNDCTRL_FAST_FADEOUT		; $740f
	call playSound		; $7411
	jp fadeoutToWhite		; $7414
@substate8:
	call fileSelect_redrawDecorations		; $7417
	ld a,(wPaletteThread_mode)		; $741a
	or a			; $741d
	ret nz			; $741e
	call checkIsLinkedGame		; $741f
	jp nz,resetGame		; $7422
	call disableLcd		; $7425
	call clearOam		; $7428
	call incCbc2		; $742b
	ld a,$96		; $742e
	call loadGfxHeader		; $7430
	ld a,PALH_a7		; $7433
	call loadPaletteHeader		; $7435
	call fadeinFromWhite		; $7438
	ld a,$04		; $743b
	jp loadGfxRegisterStateIndex		; $743d
@substate9:
	call @func_7450		; $7440
	ld a,(wPaletteThread_mode)		; $7443
	or a			; $7446
	ret nz			; $7447
	ld hl,wTmpcbb3		; $7448
	ld (hl),$b4		; $744b
	jp incCbc2		; $744d
@func_7450:
	ld hl,bank16.oamData_4fec		; $7450
	ld e,:bank16.oamData_4fec		; $7453
	ld bc,$3038		; $7455
	xor a			; $7458
	ldh (<hOamTail),a	; $7459
	jp addSpritesFromBankToOam_withOffset		; $745b
@substateA:
	call @func_7450		; $745e
	ld hl,wTmpcbb3		; $7461
	ld a,(hl)		; $7464
	or a			; $7465
	jr z,@func_746a		; $7466
	dec (hl)		; $7468
	ret			; $7469
@func_746a:
	ld a,(wKeysJustPressed)		; $746a
	and BTN_A			; $746d
	ret z			; $746f
	call incCbc2		; $7470
	jp fadeoutToWhite		; $7473
@substateB:
	call @func_7450		; $7476
	ld a,(wPaletteThread_mode)		; $7479
	or a			; $747c
	ret nz			; $747d
	jp resetGame		; $747e


; ==============================================================================
; INTERACID_MISCELLANEOUS_2
; ==============================================================================
interactionCodedc:
	ld e,Interaction.subid		; $7481
	ld a,(de)		; $7483
	rst_jumpTable			; $7484
	.dw _interactiondc_subid00
	.dw _interactiondc_subid01
	.dw _interactiondc_subid02
	.dw _interactiondc_subid03
	.dw _interactiondc_subid04
	.dw _interactiondc_subid05
	.dw _interactiondc_subid06
	.dw _interactiondc_subid07
	.dw _interactiondc_subid08
	.dw _interactiondc_subid09
	.dw _interactiondc_subid0A
	.dw _interactiondc_subid0B
	.dw _interactiondc_subid0C
	.dw _interactiondc_subid0D
	.dw _interactiondc_subid0E
	.dw _interactiondc_subid0F
	.dw _interactiondc_subid10
	.dw _interactiondc_subid11
	.dw _interactiondc_subid12
	.dw _interactiondc_subid13
	.dw _interactiondc_subid14
	.dw _interactiondc_subid15
	.dw _interactiondc_subid16
	.dw _interactiondc_subid17


; Heart piece spawner
_interactiondc_subid07:
	call getThisRoomFlags		; $74b5
	and ROOMFLAG_ITEM			; $74b8
	jp nz,interactionDelete		; $74ba
	ld bc,TREASURE_HEART_PIECE_SUBID_00		; $74bd
	call createTreasure		; $74c0
	call objectCopyPosition		; $74c3
	jp interactionDelete		; $74c6


; Replaces a tile at a position with a given value when destroyed
_interactiondc_subid08:
	call checkInteractionState		; $74c9
	jr z,@state0	; $74cc

@state1:
	ld e,Interaction.yh		; $74ce
	ld a,(de)		; $74d0
	ld c,a			; $74d1

	ld b,>wRoomLayout		; $74d2
	ld a,(bc)		; $74d4
	ld l,a			; $74d5
	ld e,Interaction.var03		; $74d6
	ld a,(de)		; $74d8
	cp l			; $74d9
	ret z			; $74da

	call getThisRoomFlags		; $74db
	ld e,Interaction.xh		; $74de
	ld a,(de)		; $74e0
	or (hl)			; $74e1
	ld (hl),a		; $74e2
	jp interactionDelete		; $74e3

@state0:
	call getThisRoomFlags		; $74e6
	ld e,Interaction.xh		; $74e9
	ld a,(de)		; $74eb
	and (hl)		; $74ec
	jp nz,interactionDelete		; $74ed

	ld e,Interaction.yh		; $74f0
	ld a,(de)		; $74f2
	ld c,a			; $74f3
	ld b,>wRoomLayout		; $74f4
	ld a,(bc)		; $74f6
	ld e,Interaction.var03		; $74f7
	ld (de),a		; $74f9
	jp interactionIncState		; $74fa


; Graveyard key spawner
_interactiondc_subid00:
	call getThisRoomFlags		; $74fd
	and ROOMFLAG_ITEM			; $7500
	jp nz,interactionDelete		; $7502
	ld a,(wNumTorchesLit)		; $7505
	cp $02			; $7508
	ret nz			; $750a
	ld bc,TREASURE_GRAVEYARD_KEY_SUBID_00		; $750b
	call createTreasure		; $750e
	call objectCopyPosition		; $7511
	jp interactionDelete		; $7514


; Graveyard gate opening cutscene
_interactiondc_subid01:
	call checkInteractionState		; $7517
	jp nz,interactionRunScript		; $751a
	call getThisRoomFlags		; $751d
	and $80			; $7520
	jp nz,interactionDelete		; $7522
	ld hl,interactiondcSubid01Script		; $7525
	call interactionSetScript		; $7528
	call interactionSetAlwaysUpdateBit		; $752b
	jp interactionIncState		; $752e


; Initiates cutscene where present d2 collapses
_interactiondc_subid02:
	ld e,Interaction.state		; $7531
	ld a,(de)		; $7533
	rst_jumpTable			; $7534
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionDeleteAndRetIfEnabled02		; $753b
	call getThisRoomFlags		; $753e
	and $80			; $7541
	jp nz,interactionDelete		; $7543

	ld a,d			; $7546
	ld (wDiggingUpEnemiesForbidden),a		; $7547

	call objectGetTileAtPosition		; $754a
	cp TILEINDEX_OVERWORLD_STANDARD_GROUND
	ret nz			; $754f

	ld c,l			; $7550
	ld a,TILEINDEX_OVERWORLD_DUG_DIRT		; $7551
	call setTile		; $7553
	jp interactionIncState		; $7556

@state1:
	ld a,(wLinkGrabState)		; $7559
	cp $83			; $755c
	ret nz			; $755e

	ld a,DIR_RIGHT		; $755f
	ld (w1Link.direction),a		; $7561

	ld e,Interaction.counter1		; $7564
	ld a,30		; $7566
	ld (de),a		; $7568

	call checkLinkCollisionsEnabled		; $7569
	ret nc			; $756c

	ld a,DISABLE_LINK		; $756d
	ld (wDisabledObjects),a		; $756f
	ld (wMenuDisabled),a		; $7572
	call resetLinkInvincibility		; $7575
	ld a,SNDCTRL_STOPMUSIC		; $7578
	call playSound		; $757a
	jp interactionIncState		; $757d

; Screen shaking just before present collapse
@state2:
	ld e,Interaction.state2		; $7580
	ld a,(de)		; $7582
	rst_jumpTable			; $7583
	.dw @substate0
	.dw @substate1

@substate0:
	call interactionDecCounter1		; $7588
	ret nz			; $758b
	ld (hl),60 ; [counter1]
	ld a,60		; $758e
	ld bc,$f800		; $7590
	call objectCreateExclamationMark		; $7593
	call clearAllParentItems		; $7596
	call dropLinkHeldItem		; $7599
	jp interactionIncState2		; $759c

@substate1:
	ld a,$28		; $759f
	call setScreenShakeCounter		; $75a1
	call interactionDecCounter1		; $75a4
	ret nz			; $75a7
	ld a,CUTSCENE_D2_COLLAPSE		; $75a8
	ld (wCutsceneTrigger),a		; $75aa
	jp interactionDelete		; $75ad


; Reveals portal spot under bush in symmetry (left side)
_interactiondc_subid03:
	call checkInteractionState		; $75b0
	jr nz,_interactiondc_subid3And4_state1	; $75b3

@state0:
	call getThisRoomFlags		; $75b5
	and $02			; $75b8
	jp nz,interactionDelete		; $75ba
	ld e,Interaction.var03		; $75bd
	ld a,$02		; $75bf
	ld (de),a		; $75c1
	jp interactionIncState		; $75c2

_interactiondc_subid3And4_state1:
	call objectGetTileAtPosition		; $75c5
	cp TILEINDEX_OVERWORLD_STANDARD_GROUND			; $75c8
	ret nz			; $75ca
	ld a,TILEINDEX_PORTAL_SPOT		; $75cb
	ld c,l			; $75cd
	call setTile		; $75ce

	call getThisRoomFlags		; $75d1
	ld e,Interaction.var03		; $75d4
	ld a,(de)		; $75d6
	or (hl)			; $75d7
	ld (hl),a		; $75d8

	ld a,SND_SOLVEPUZZLE		; $75d9
	call playSound		; $75db
	jp interactionDelete		; $75de


; Reveals portal spot under bush in symmetry (right side)
_interactiondc_subid04:
	call checkInteractionState		; $75e1
	jr nz,_interactiondc_subid3And4_state1	; $75e4

@state0:
	call getThisRoomFlags		; $75e6
	and $04			; $75e9
	jp nz,interactionDelete		; $75eb
	ld e,Interaction.var03		; $75ee
	ld a,$04		; $75f0
	ld (de),a		; $75f2
	jp interactionIncState		; $75f3


; Makes screen shake before tuni nut is restored
_interactiondc_subid05:
	ld e,Interaction.state		; $75f6
	ld a,(de)		; $75f8
	rst_jumpTable			; $75f9
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,GLOBALFLAG_TUNI_NUT_PLACED		; $7600
	call checkGlobalFlag		; $7602
	jp nz,interactionDelete		; $7605

	call returnIfScrollMode01Unset		; $7608

	ld a,SNDCTRL_STOPSFX		; $760b
	call playSound		; $760d

	ld a,$01		; $7610
	ld (wScreenShakeMagnitude),a		; $7612

	call @setRandomShakeDuration		; $7615
	ld a,(wFrameCounter)		; $7618
	rrca			; $761b
	call c,interactionIncState		; $761c
	jp interactionIncState		; $761f

@state1:
	xor a			; $7622
	call @shakeScreen		; $7623
	ret nz			; $7626
	call @setRandomShakeDuration		; $7627
	jp interactionIncState		; $762a

@state2:
	ld a,(wFrameCounter)		; $762d
	and $0f			; $7630
	ld a,SND_RUMBLE		; $7632
	call z,playSound		; $7634
	ld a,$08		; $7637
	call @shakeScreen		; $7639
	ret nz			; $763c
	ld l,Interaction.state		; $763d
	ld (hl),$01		; $763f

@setRandomShakeDuration:
	call getRandomNumber		; $7641
	and $7f			; $7644
	sub $40			; $7646
	add $60			; $7648
	ld e,Interaction.counter1		; $764a
	ld (de),a		; $764c
	ret			; $764d

@shakeScreen:
	call setScreenShakeCounter		; $764e
	ld a,(wFrameCounter)		; $7651
	rrca			; $7654
	ret c			; $7655
	jp interactionDecCounter1		; $7656


; Makes volcanoes erupt before tuni nut is restored (spawns INTERACID_VOLCANO_HANLDER)
_interactiondc_subid06:
	ld a,GLOBALFLAG_TUNI_NUT_PLACED		; $7659
	call checkGlobalFlag		; $765b
	jr nz,@delete	; $765e
	ldbc INTERACID_VOLCANO_HANDLER,$01		; $7660
	call objectCreateInteraction		; $7663
@delete:
	jp interactionDelete		; $7666


; Animates jabu-jabu
_interactiondc_subid09:
	ld e,Interaction.state		; $7669
	ld a,(de)		; $766b
	rst_jumpTable			; $766c
	.dw interactionIncState
	.dw @state1
	.dw @state2
	.dw @state3

@state1:
	ld a,(wMenuDisabled)		; $7675
	or a			; $7678
	ret nz			; $7679

	ld a,(wFrameCounter)		; $767a
	and $07			; $767d
	ret nz			; $767f
	call getRandomNumber_noPreserveVars		; $7680
	and $07			; $7683
	ret nz			; $7685

	ld e,Interaction.state2		; $7686
	xor a			; $7688
	ld (de),a		; $7689
	ldh a,(<hRng2)	; $768a
	rrca			; $768c
	call c,interactionIncState		; $768d
	jp interactionIncState		; $7690

@state2:
	ld e,Interaction.state2		; $7693
	ld a,(de)		; $7695
	rst_jumpTable			; $7696
	.dw @state2Substate0
	.dw @state2Substate1
	.dw @returnToState1

@state2Substate0:
	ld e,Interaction.counter1		; $769d
	ld a,$08		; $769f
	ld (de),a		; $76a1
	ld hl,@tiles0		; $76a2

@replaceTileListAndIncSubstateA:
	call @replaceTileList		; $76a5
	jp interactionIncState2		; $76a8

@state2Substate1:
	call interactionDecCounter1		; $76ab
	ret nz			; $76ae
	ld (hl),$08		; $76af
	ld hl,@tiles1		; $76b1
	jr @replaceTileListAndIncSubstateA		; $76b4

@returnToState1:
	call interactionDecCounter1		; $76b6
	ret nz			; $76b9
	ld e,Interaction.state		; $76ba
	ld a,$01		; $76bc
	ld (de),a		; $76be
	ret			; $76bf

@state3:
	ld e,Interaction.state2		; $76c0
	ld a,(de)		; $76c2
	rst_jumpTable			; $76c3
	.dw @state3Substate0
	.dw @state3Substate1
	.dw @state3Substate2
	.dw @returnToState1

@state3Substate0:
	ld e,Interaction.counter1		; $76cc
	ld a,$0c		; $76ce
	ld (de),a		; $76d0
	ld hl,@tiles2		; $76d1

@replaceTileListAndIncSubstateB:
	call @replaceTileList		; $76d4
	jp interactionIncState2		; $76d7

@state3Substate1:
	call interactionDecCounter1		; $76da
	ret nz			; $76dd
	ld (hl),$0c		; $76de
	ld hl,@tiles3		; $76e0
	jr @replaceTileListAndIncSubstateB		; $76e3

@state3Substate2:
	call interactionDecCounter1		; $76e5
	ret nz			; $76e8
	ld (hl),$0c		; $76e9
	ld hl,@tiles4		; $76eb
	jr @replaceTileListAndIncSubstateB		; $76ee

;;
; @param	hl	List of tile postiion/value pairs to set
; @addr{76f0}
@replaceTileList:
	ldi a,(hl)		; $76f0
	or a			; $76f1
	ret z			; $76f2
	ld c,a			; $76f3
	ldi a,(hl)		; $76f4
	push hl			; $76f5
	call setTile		; $76f6
	pop hl			; $76f9
	jr @replaceTileList		; $76fa

@tiles0:
	.db $24 $87
	.db $25 $88
	.db $34 $97
	.db $35 $98
	.db $00

@tiles1:
	.db $24 $9b
	.db $25 $9c
	.db $34 $ab
	.db $35 $ac
	.db $00

@tiles2:
	.db $22 $0e
	.db $23 $0f
	.db $32 $1e
	.db $33 $1f
	.db $26 $4e
	.db $27 $4f
	.db $36 $5e
	.db $37 $5f
	.db $00

@tiles3:
	.db $22 $2e
	.db $23 $2f
	.db $32 $3e
	.db $33 $3f
	.db $26 $6e
	.db $27 $6f
	.db $36 $7e
	.db $37 $7f
	.db $00

@tiles4:
	.db $22 $99
	.db $23 $9a
	.db $32 $a9
	.db $33 $aa
	.db $26 $9d
	.db $27 $9e
	.db $36 $ad
	.db $37 $ae
	.db $00


; Initiates jabu opening his mouth cutscene
_interactiondc_subid0A:
	call checkInteractionState		; $7741
	jr z,@state0	; $7744

@state1:
	ld a,GLOBALFLAG_GOT_PERMISSION_TO_ENTER_JABU		; $7746
	call checkGlobalFlag		; $7748
	jp z,interactionDelete		; $774b

	ld a,DISABLE_ALL_BUT_INTERACTIONS|DISABLE_LINK		; $774e
	ld (wDisabledObjects),a		; $7750
	ld (wMenuDisabled),a		; $7753

	xor a			; $7756
	ld (w1Link.direction),a		; $7757
	ld a,CUTSCENE_JABU_OPEN		; $775a
	ld (wCutsceneTrigger),a		; $775c
	jp interactionDelete		; $775f

@state0:
	call getThisRoomFlags		; $7762
	and $02			; $7765
	jp nz,interactionDelete		; $7767
	jp interactionIncState		; $776a


; Handles floor falling in King Moblin's castle
_interactiondc_subid0B:
	ld e,Interaction.state		; $776d
	ld a,(de)		; $776f
	rst_jumpTable			; $7770
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01		; $7779
	ld (de),a		; $777b
	ld a,$18		; $777c
	call objectSetCollideRadius		; $777e
	ld hl,@listOfTilesToBreak		; $7781
	jp interactionSetMiniScript		; $7784

@state1:
	call objectCheckCollidedWithLink_ignoreZ		; $7787
	ret nc			; $778a
	call checkLinkCollisionsEnabled		; $778b
	ret nc			; $778e

	ld a,DISABLE_LINK		; $778f
	ld (wDisabledObjects),a		; $7791

	ld a,SND_CLINK		; $7794
	call playSound		; $7796

	ld hl,w1Link		; $7799
	call objectTakePosition		; $779c

	ld e,Interaction.counter1		; $779f
	ld a,30		; $77a1
	ld (de),a		; $77a3

	ld bc,$f808		; $77a4
	call objectCreateExclamationMark		; $77a7
	jp interactionIncState		; $77aa

@state2:
	call interactionDecCounter1		; $77ad
	ret nz			; $77b0
	ld (hl),30 ; [counter1]
	xor a			; $77b3
	ld (wDisabledObjects),a		; $77b4
	jp interactionIncState		; $77b7

@state3:
	call interactionDecCounter1		; $77ba
	ret nz			; $77bd
	ld (hl),$07 ; [counter1]

	call interactionGetMiniScript		; $77c0
	ldi a,(hl)		; $77c3
	ld c,a			; $77c4
	call interactionSetMiniScript		; $77c5
	ld a,c			; $77c8
	or a			; $77c9
	jp z,interactionDelete		; $77ca

	ld a,TILEINDEX_WARP_HOLE		; $77cd
	jp breakCrackedFloor		; $77cf

@listOfTilesToBreak:
	.db $67 $66 $65 $64 $63 $62 $61 $51
	.db $41 $31 $21 $11 $12 $13 $23 $33
	.db $43 $44 $45 $46 $47 $48 $38 $28
	.db $18 $17 $16 $00


; Bridge handler in Rolling Ridge past (subid 0c) and present (subid 0d)
_interactiondc_subid0C:
_interactiondc_subid0D:
	call checkInteractionState		; $77ee
	jr z,@state0	; $77f1

@state1:
	ld a,(wActiveTriggers)		; $77f3
	or a			; $77f6
	ret z			; $77f7

	ld e,Interaction.subid		; $77f8
	ld a,(de)		; $77fa
	sub $0c			; $77fb
	ld bc,$0801		; $77fd
	ld e,$56		; $7800
	jr z,++			; $7802
	ld bc,$0603		; $7804
	ld e,$28		; $7807
++
	call getFreePartSlot		; $7809
	ret nz			; $780c
	ld (hl),PARTID_BRIDGE_SPAWNER		; $780d
	ld l,Part.counter2		; $780f
	ld (hl),b		; $7811
	ld l,Part.angle		; $7812
	ld (hl),c		; $7814
	ld l,Part.yh		; $7815
	ld (hl),e		; $7817

	call getThisRoomFlags		; $7818
	set 7,(hl)		; $781b

	ld a,SND_SOLVEPUZZLE		; $781d
	call playSound		; $781f
	jp interactionDelete		; $7822

@state0:
	call getThisRoomFlags		; $7825
	and $80			; $7828
	jp nz,interactionDelete		; $782a
	jp interactionIncState		; $782d


; Puzzle at entrance to sea of no return (ancient tomb)
_interactiondc_subid0E:
	ld e,Interaction.state		; $7830
	ld a,(de)		; $7832
	rst_jumpTable			; $7833
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call getThisRoomFlags		; $783a
	and $80			; $783d
	jp nz,interactionDelete		; $783f
	jp interactionIncState		; $7842

@state1:
	call objectGetTileAtPosition		; $7845
	cp TILEINDEX_GRAVE_STATIONARY			; $7848
	ret nz			; $784a
	call checkLinkVulnerable		; $784b
	ret nc			; $784e

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK		; $784f
	ld (wDisabledObjects),a		; $7851
	ld (wMenuDisabled),a		; $7854

	ld e,Interaction.counter1		; $7857
	ld a,45		; $7859
	ld (de),a		; $785b

	call interactionIncState		; $785c

	ld c,$04		; $785f
	ld a,$30		; $7861
	call setTile		; $7863
	inc c			; $7866
	ld a,$32		; $7867
	call setTile		; $7869
	ld c,$14		; $786c
	ld a,$3a		; $786e
	call setTile		; $7870
	inc c			; $7873
	ld a,$3a		; $7874
	call setTile		; $7876

	ld c,$04		; $7879
	call @spawnPuff		; $787b
	ld c,$05		; $787e
	call @spawnPuff		; $7880
	ld c,$14		; $7883
	call @spawnPuff		; $7885
	ld c,$15		; $7888

@spawnPuff:
	call getFreeInteractionSlot		; $788a
	ret nz			; $788d
	ld (hl),INTERACID_PUFF		; $788e
	ld l,Interaction.yh		; $7890
	jp setShortPosition_paramC		; $7892

@state2:
	call interactionDecCounter1		; $7895
	ret nz			; $7898
	ld a,SND_SOLVEPUZZLE		; $7899
	call playSound		; $789b
	call getThisRoomFlags		; $789e
	set 7,(hl)		; $78a1
	xor a			; $78a3
	ld (wDisabledObjects),a		; $78a4
	ld (wMenuDisabled),a		; $78a7
	jp interactionDelete		; $78aa


; Shows text upon entering a room (only used for sea of no return entrance and black tower turret)
_interactiondc_subid0F:
	call checkInteractionState		; $78ad
	jr z,@state0	; $78b0
	call objectCheckCollidedWithLink_notDead		; $78b2
	ret nc			; $78b5

	ld bc,TX_120a		; $78b6
	ld a,(wActiveRoom)		; $78b9
	cp $d0			; $78bc
	jr nz,@showText	; $78be
	ld bc,TX_0209		; $78c0
@showText:
	call showText		; $78c3
	jp interactionDelete		; $78c6

@state0:
	ld a,(wScrollMode)		; $78c9
	and $02			; $78cc
	jp z,interactionDelete		; $78ce
	ld a,(w1Link.yh)		; $78d1
	cp $78			; $78d4
	jp c,interactionDelete		; $78d6
	ld a,$08		; $78d9
	call objectSetCollideRadius		; $78db
	jp interactionIncState		; $78de


; Black tower entrance handler: warps Link to different variants of black tower.
_interactiondc_subid10:
	ld e,Interaction.state		; $78e1
	ld a,(de)		; $78e3
	rst_jumpTable			; $78e4
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld hl,wRoomLayout+$44		; $78eb
	xor a			; $78ee
	ldi (hl),a		; $78ef
	ld (hl),a		; $78f0

	ld bc,$0410		; $78f1
	call objectSetCollideRadii		; $78f4

	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $78f7
	call nc,interactionIncState		; $78fa
	jp interactionIncState		; $78fd

@state1:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $7900
	ret c			; $7903
	jp interactionIncState		; $7904

@state2:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $7907
	ret nc			; $790a
	call checkLinkVulnerable		; $790b
	ret nc			; $790e

	call getThisRoomFlags		; $790f
	and $01			; $7912
	ld hl,@warp1		; $7914
	jr z,+			; $7917
	ld hl,@warp2		; $7919
+
	call setWarpDestVariables		; $791c
	ld a,SND_ENTERCAVE		; $791f
	call playSound		; $7921
	jp interactionDelete		; $7924

@warp1:
	m_HardcodedWarpA ROOM_AGES_4e7, $93, $ff, $01

@warp2:
	m_HardcodedWarpA ROOM_AGES_4f3, $93, $ff, $01


; Gives D6 Past boss key when you get D6 Present boss key
_interactiondc_subid11:
	call getThisRoomFlags		; $7931
	and ROOMFLAG_ITEM			; $7934
	ret z			; $7936
	ld hl,wDungeonBossKeys		; $7937
	ld a,$0c		; $793a
	jp setFlag		; $793c


; Bridge handler for cave leading to Tingle
_interactiondc_subid12:
	call getThisRoomFlags		; $793f
	and $40			; $7942
	jp nz,interactionDelete		; $7944

	ld a,(wToggleBlocksState)		; $7947
	or a			; $794a
	ret z			; $794b

	call getFreePartSlot		; $794c
	ret nz			; $794f
	ld (hl),PARTID_BRIDGE_SPAWNER		; $7950
	ld l,Part.counter2		; $7952
	ld (hl),$0c		; $7954
	ld l,Part.angle		; $7956
	ld (hl),$01		; $7958
	ld l,Part.yh		; $795a
	ld (hl),$13		; $795c

	call getThisRoomFlags		; $795e
	set 6,(hl)		; $7961

	ld a,SND_SOLVEPUZZLE		; $7963
	call playSound		; $7965
	jp interactionDelete		; $7968


; Makes lava-waterfall an d4 entrance behave like lava instead of just a wall, so that the fireballs
; "sink" into it instead of exploding like on land.
_interactiondc_subid13:
	call returnIfScrollMode01Unset		; $796b
	ld a,TILEINDEX_OVERWORLD_LAVA_1 ; TODO
	ld hl,wRoomLayout+$14		; $7970
	ldi (hl),a		; $7973
	ld (hl),a		; $7974
	ld l,$24		; $7975
	ldi (hl),a		; $7977
	ld (hl),a		; $7978
	ld l,$34		; $7979
	ldi (hl),a		; $797b
	ld (hl),a		; $797c
	jp interactionDelete		; $797d


; Spawns portal to final dungeon from maku tree
_interactiondc_subid14:
	call objectGetTileAtPosition		; $7980
	cp $dc ; TODO
	jr nz,@delete	; $7985
	ld b,INTERACID_DECORATION		; $7987
	call objectCreateInteractionWithSubid00		; $7989
@delete:
	jp interactionDelete		; $798c



; Sets present sea of storms chest contents (changes if linked)
_interactiondc_subid15:
	call checkInteractionState		; $798f
	jr z,_interactiondc_subid15And16_state0	; $7992

@state1:
	call checkIsLinkedGame		; $7994
	ld a,$01		; $7997
	jr nz,_interactiondc_subid15And16_setChestContents			; $7999
	dec a			; $799b

_interactiondc_subid15And16_setChestContents:
	ld hl,@chestContents		; $799c
	rst_addDoubleIndex			; $799f
	ldi a,(hl)		; $79a0
	ld (wChestContentsOverride),a		; $79a1
	ld a,(hl)		; $79a4
	ld (wChestContentsOverride+1),a		; $79a5
	jp interactionDelete		; $79a8

@chestContents:
	dwbe TREASURE_GASHA_SEED_SUBID_01 ; Unlinked
	dwbe TREASURE_RING_SUBID_1e       ; Linked

_interactiondc_subid15And16_state0:
	call getThisRoomFlags		; $79af
	and ROOMFLAG_ITEM			; $79b2
	jp nz,interactionDelete		; $79b4
	jp interactionIncState		; $79b7


; Sets past sea of storms chest contents (changes if linked)
_interactiondc_subid16:
	call checkInteractionState		; $79ba
	jr z,_interactiondc_subid15And16_state0	; $79bd
	call checkIsLinkedGame		; $79bf
	ld a,$00		; $79c2
	jr nz,_interactiondc_subid15And16_setChestContents	; $79c4
	inc a			; $79c6
	jr _interactiondc_subid15And16_setChestContents		; $79c7


; Forces Link to be squished when he's in a wall (used in ages d5 BK room)
_interactiondc_subid17:
	call checkInteractionState		; $79c9
	jp z,interactionIncState		; $79cc

@state1:
	ld a,(w1Link.yh)		; $79cf
	ld b,a			; $79d2
	ld a,(w1Link.xh)		; $79d3
	ld c,a			; $79d6
	callab bank5.checkPositionSurroundedByWalls		; $79d7
	rl b			; $79df
	ret nc			; $79e1

	ld a,(w1Link.state)		; $79e2
	cp LINK_STATE_NORMAL			; $79e5
	ret nz			; $79e7

	ld hl,wLinkForceState		; $79e8
	ld a,(hl)		; $79eb
	or a			; $79ec
	ret nz			; $79ed

	ld a,LINK_STATE_SQUISHED		; $79ee
	ldi (hl),a		; $79f0
	ld a,(wBlockPushAngle)		; $79f1
	and $08			; $79f4
	xor $08			; $79f6
	ld (hl),a ; [wcc50]
	ret			; $79f9


; ==============================================================================
; INTERACID_TIMEWARP
;
; Variables:
;   var03: ?
;   relatedObj2: ?
; ==============================================================================
interactionCodedd:
	ld e,Interaction.subid		; $79fa
	ld a,(de)		; $79fc
	rst_jumpTable			; $79fd
	.dw _timewarp_subid0
	.dw _timewarp_subid1
	.dw _timewarp_subid2
	.dw _timewarp_subid3
	.dw _timewarp_subid4

_timewarp_subid0:
	ld e,Interaction.state		; $7a08
	ld a,(de)		; $7a0a
	rst_jumpTable			; $7a0b
	.dw _timewarp_common_state0
	.dw _timewarp_subid0_state1
	.dw _timewarp_subid0_state2
	.dw _timewarp_animateUntilFinished


_timewarp_common_state0:
	call interactionInitGraphics		; $7a14
	call interactionIncState		; $7a17

	ld l,Interaction.yh		; $7a1a
	ldh a,(<hEnemyTargetY)	; $7a1c
	add $08			; $7a1e
	ldi (hl),a		; $7a20
	inc l			; $7a21
	ldh a,(<hEnemyTargetX)	; $7a22
	ld (hl),a		; $7a24

	jp objectSetVisible83		; $7a25


_timewarp_subid0_state1:
	call _timewarp_animate		; $7a28
	jp z,interactionIncState		; $7a2b
	dec a			; $7a2e
	jr nz,+			; $7a2f
	ret			; $7a31
+
	xor a			; $7a32
	ld (de),a ; [animParameter]

	ld b,$03		; $7a34

;;
; @param	b	Subid of INTERACID_TIMEWARP object to spawn
; @addr{7a36}
_timewarp_spawnChild:
	call getFreeInteractionSlot		; $7a36
	ret nz			; $7a39
	ld (hl),INTERACID_TIMEWARP		; $7a3a
	inc l			; $7a3c
	ld (hl),b ; [subid]
	inc l			; $7a3e
	ld e,l			; $7a3f
	ld a,(de) ; [var03]
	ld (hl),a		; $7a41
	ld e,Interaction.relatedObj2		; $7a42
	ld a,Interaction.start		; $7a44
	ld (de),a		; $7a46
	inc e			; $7a47
	ld a,h			; $7a48
	ld (de),a		; $7a49
	ld bc,$f800		; $7a4a
	jp objectCopyPositionWithOffset		; $7a4d


_timewarp_subid0_state2:
	call interactionDecCounter1		; $7a50
	jr z,@counterReached0	; $7a53

	ld a,(hl) ; [counter1]
	cp 36			; $7a56
	ret c			; $7a58
	and $07			; $7a59
	ret nz			; $7a5b
	ld a,(hl)		; $7a5c
	and $38			; $7a5d
	rrca			; $7a5f
	ld hl,@data		; $7a60
	rst_addAToHl			; $7a63
	ldi a,(hl)		; $7a64
	ld b,a			; $7a65
	ldi a,(hl)		; $7a66
	ld c,a			; $7a67
	ld e,(hl)		; $7a68

	call getFreePartSlot		; $7a69
	ret nz			; $7a6c
	ld (hl),PARTID_TIMEWARP_ANIMATION		; $7a6d
	inc l			; $7a6f
	ld (hl),e ; [subid]

	ld e,Interaction.relatedObj2+1		; $7a71
	ld a,(de)		; $7a73
	ld l,Part.relatedObj1+1		; $7a74
	ldd (hl),a		; $7a76
	ld (hl),Interaction.start		; $7a77

	ld l,Part.speed		; $7a79
	ld (hl),b		; $7a7b

	ld b,$00		; $7a7c
	jp objectCopyPositionWithOffset		; $7a7e

@counterReached0:
	ld a,$01		; $7a81
	call interactionSetAnimation		; $7a83
	ld a,Object.state		; $7a86
	call objectGetRelatedObject2Var		; $7a88
	inc (hl)		; $7a8b
	jp interactionIncState		; $7a8c

; Data format:
;   b0: speed
;   b1: x-offset
;   b2: subid
;   b3: unused
@data:
	.db SPEED_280, $fc, $00, $00
	.db SPEED_2c0, $09, $03, $00
	.db SPEED_240, $f7, $02, $00
	.db SPEED_2c0, $04, $01, $00
	.db SPEED_240, $fc, $00, $00
	.db SPEED_280, $04, $01, $00
	.db SPEED_2c0, $f7, $02, $00
	.db SPEED_240, $09, $03, $00


_timewarp_animateUntilFinished:
	call _timewarp_animate		; $7aaf
	ret nz			; $7ab2
	jp interactionDelete		; $7ab3


_timewarp_subid1:
	ld e,Interaction.state		; $7ab6
	ld a,(de)		; $7ab8
	rst_jumpTable			; $7ab9
	.dw _timewarp_common_state0
	.dw _timewarp_subid1_state1
	.dw _timewarp_animateUntilFinished ; TODO


_timewarp_subid1_state1:
	call _timewarp_animate		; $7ac0
	jr z,++			; $7ac3
	dec a			; $7ac5
	ret z			; $7ac6

	xor a			; $7ac7
	ld (de),a ; [animParameter
	ld b,$04		; $7ac9
	jp _timewarp_spawnChild		; $7acb
++
	ld a,Object.state		; $7ace
	call objectGetRelatedObject2Var		; $7ad0
	inc (hl)		; $7ad3
	call interactionIncState		; $7ad4
	ld a,$01		; $7ad7
	jp interactionSetAnimation		; $7ad9

_timewarp_subid2:
	ld e,Interaction.state		; $7adc
	ld a,(de)		; $7ade
	rst_jumpTable			; $7adf
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics		; $7ae6
	call interactionIncState		; $7ae9

	ld l,Interaction.speedTmp		; $7aec
	ld (hl),$fc		; $7aee
	ld l,Interaction.counter1		; $7af0
	ld (hl),$06		; $7af2
	jp objectSetVisible81		; $7af4

@state1:
	call _timewarp_animate		; $7af7
	ret nz			; $7afa
	jp interactionIncState		; $7afb

@state2:
	call objectApplyComponentSpeed		; $7afe
	ld e,Interaction.yh		; $7b01
	ld a,(de)		; $7b03
	cp $f0			; $7b04
	jp nc,interactionDelete		; $7b06
	call interactionDecCounter1		; $7b09
	ret nz			; $7b0c
	ld (hl),$06		; $7b0d
	ldbc INTERACID_SPARKLE, $01		; $7b0f
	call objectCreateInteraction		; $7b12
	ret nz			; $7b15
	ld l,Interaction.var03		; $7b16
	inc (hl)		; $7b18
	ret			; $7b19


_timewarp_subid3:
	ld e,Interaction.state		; $7b1a
	ld a,(de)		; $7b1c
	rst_jumpTable			; $7b1d
	.dw _itemwarp_subid3Or4_state0
	.dw _timewarp_subid3_state1
	.dw interactionAnimate
	.dw _timewarp_subid3Or4_state3
	.dw _timewarp_subid3Or4_state4

_itemwarp_subid3Or4_state0:
	ld e,Interaction.var03		; $7b28
	ld a,(de)		; $7b2a
	add $c0			; $7b2b
	call loadPaletteHeader		; $7b2d
	call interactionInitGraphics		; $7b30
	call interactionIncState		; $7b33
	jp objectSetVisible82		; $7b36

_timewarp_subid3_state1:
	call _timewarp_animate		; $7b39
	ret nz			; $7b3c
	ld a,$03		; $7b3d
	call interactionSetAnimation		; $7b3f
	jp interactionIncState		; $7b42

_timewarp_subid3Or4_state3:
	call interactionIncState		; $7b45
	ld a,$04		; $7b48
	jp interactionSetAnimation		; $7b4a

_timewarp_subid3Or4_state4:
	call _timewarp_animate		; $7b4d
	ret nz			; $7b50
	jp interactionDelete		; $7b51


_timewarp_subid4:
	ld e,Interaction.state		; $7b54
	ld a,(de)		; $7b56
	rst_jumpTable			; $7b57
	.dw _itemwarp_subid3Or4_state0
	.dw interactionAnimate
	.dw _timewarp_subid3Or4_state3 ; Actually state 2...
	.dw _timewarp_subid3Or4_state4 ; Actually state 3...


;;
; @param[out]	a	[Interaction.animParameter]+1
; @addr{7b60}
_timewarp_animate:
	call interactionAnimate		; $7b60
	ld e,Interaction.animParameter		; $7b63
	ld a,(de)		; $7b65
	inc a			; $7b66
	ret			; $7b67


; ==============================================================================
; INTERACID_TIMEPORTAL
;
; Variables:
;   var03: Short-form position
; ==============================================================================
interactionCodede:
	ld a,$02		; $7b68
	ld (wcddd),a		; $7b6a
	ld a,(wMenuDisabled)		; $7b6d
	or a			; $7b70
	jp nz,objectSetInvisible		; $7b71

	call objectSetVisible		; $7b74
	ld e,Interaction.state		; $7b77
	ld a,(de)		; $7b79
	rst_jumpTable			; $7b7a
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	; Delete self if a timeportal exists already.
	; BUG: This only checks for timeportals in object slots before the current one. This makes
	; it possible to "stack" timeportals.
	ld c,INTERACID_TIMEPORTAL		; $7b81
	call objectFindSameTypeObjectWithID		; $7b83
	ld a,h			; $7b86
	cp d			; $7b87
	jp nz,interactionDelete		; $7b88

	ld a,$03		; $7b8b
	call objectSetCollideRadius		; $7b8d
	call objectGetShortPosition		; $7b90
	ld c,a			; $7b93

	call interactionIncState		; $7b94

	ld l,Interaction.var03		; $7b97
	ld (hl),c		; $7b99
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $7b9a
	call nc,interactionIncState		; $7b9d
	call interactionInitGraphics		; $7ba0
	jp objectSetVisible83		; $7ba3

@state1:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $7ba6
	jp nc,interactionIncState		; $7ba9
	jr _timeportal_updatePalette		; $7bac

@state2:
	ld e,Interaction.var03		; $7bae
	ld a,(de)		; $7bb0
	ld b,a			; $7bb1
	ld a,(wPortalPos)		; $7bb2
	cp b			; $7bb5
	jp nz,interactionDelete		; $7bb6

	call _timeportal_updatePalette		; $7bb9
	ld a,(wLinkObjectIndex)		; $7bbc
	rrca			; $7bbf
	ret c			; $7bc0
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $7bc1
	ret nc			; $7bc4
	call checkLinkCollisionsEnabled		; $7bc5
	ret nc			; $7bc8

	; Link touched the portal
	ld a,$ff		; $7bc9
	ld (wPortalGroup),a		; $7bcb

	; Fall through

;;
; Also called by INTERACID_TIMEPORTAL_SPAWNER.
; @addr{7bce}
interactionBeginTimewarp:
	call resetLinkInvincibility		; $7bce
	ld hl,w1Link		; $7bd1
	call objectCopyPosition		; $7bd4
	ld l,<w1Link.direction		; $7bd7
	ld (hl),DIR_DOWN		; $7bd9

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a		; $7bdd
	ld (wDisableLinkCollisionsAndMenu),a		; $7be0

	call objectGetTileAtPosition		; $7be3
	ld (wActiveTileIndex),a		; $7be6
	ld a,l			; $7be9
	ld (wActiveTilePos),a		; $7bea
	inc a			; $7bed
	ld (wLinkTimeWarpTile),a		; $7bee
	ld (wcde0),a		; $7bf1

	ld a,CUTSCENE_TIMEWARP		; $7bf4
	ld (wCutsceneTrigger),a		; $7bf6
	call restartSound		; $7bf9
	jp interactionDelete		; $7bfc

;;
; @addr{7bff}
_timeportal_updatePalette:
	ld a,(wFrameCounter)		; $7bff
	and $01			; $7c02
	jr nz,@animate	; $7c04
	ld e,Interaction.oamFlags		; $7c06
	ld a,(de)		; $7c08
	inc a			; $7c09
	and $0b			; $7c0a
	ld (de),a		; $7c0c
@animate:
	jp interactionAnimate		; $7c0d


; ==============================================================================
; INTERACID_NAYRU_RALPH_CREDITS
; ==============================================================================
interactionCodedf:
	ld e,Interaction.state		; $7c10
	ld a,(de)		; $7c12
	rst_jumpTable			; $7c13
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $7c18
	ld (de),a		; $7c1a
	call interactionInitGraphics		; $7c1b

	ld h,d			; $7c1e
	ld l,Interaction.speed		; $7c1f
	ld (hl),SPEED_80		; $7c21
	ld l,Interaction.angle		; $7c23
	ld (hl),$18		; $7c25

	ld l,Interaction.counter1		; $7c27
	ld (hl),60		; $7c29
	ld l,Interaction.subid		; $7c2b
	ld a,(hl)		; $7c2d
	or a			; $7c2e
	jp z,objectSetVisiblec2		; $7c2f
	jp objectSetVisiblec0		; $7c32

@state1:
	ld e,Interaction.state2		; $7c35
	ld a,(de)		; $7c37
	rst_jumpTable			; $7c38
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

@substate0:
	call interactionDecCounter1		; $7c47
	ret nz			; $7c4a
	call interactionIncState2		; $7c4b

@substate1:
	call interactionAnimate		; $7c4e
	call objectApplySpeed		; $7c51
	cp $68 ; [xh]
	ret nz			; $7c56

	call interactionIncState2		; $7c57
	ld l,Interaction.counter1		; $7c5a
	ld (hl),180		; $7c5c

	ld l,Interaction.subid		; $7c5e
	ld a,(hl)		; $7c60
	or a			; $7c61
	ret nz			; $7c62
	ld a,$05		; $7c63
	jp interactionSetAnimation		; $7c65

@substate2:
	call interactionDecCounter1		; $7c68
	ret nz			; $7c6b
	ld hl,wTmpcfc0.genericCutscene.cfd0		; $7c6c
	ld (hl),$01		; $7c6f
	call interactionIncState2		; $7c71
	ld l,Interaction.counter1		; $7c74
	ld (hl),$04		; $7c76
	inc l			; $7c78
	ld (hl),$01 ; [counter2]
	jr @setRandomVar38		; $7c7b

@substate3:
	ld h,d			; $7c7d
	ld l,Interaction.counter1		; $7c7e
	call decHlRef16WithCap		; $7c80
	jr nz,@label_10_330	; $7c83

	call interactionIncState2		; $7c85
	ld l,Interaction.counter1		; $7c88
	ld (hl),100		; $7c8a

	ld b,SPEED_80 ; Nayru
	ld c,$04		; $7c8e
	ld l,Interaction.subid		; $7c90
	ld a,(hl)		; $7c92
	or a			; $7c93
	jr z,++			; $7c94
	ld b,SPEED_180 ; Ralph
	ld c,$02		; $7c98
++
	ld l,Interaction.speed		; $7c9a
	ld (hl),b		; $7c9c
	ld a,c			; $7c9d
	call interactionSetAnimation		; $7c9e
	ld hl,wTmpcfc0.genericCutscene.cfd0		; $7ca1
	ld (hl),$02		; $7ca4
	ret			; $7ca6

@label_10_330:
	ld l,Interaction.subid		; $7ca7
	ld a,(hl)		; $7ca9
	or a			; $7caa
	call z,interactionAnimate		; $7cab

.ifdef ROM_AGES
	ld l,Interaction.var38		; $7cae
.else
	ld l,Interaction.var37		; $7cae
.endif
	dec (hl)		; $7cb0
	ret nz			; $7cb1

	ld l,Interaction.direction		; $7cb2
	ld a,(hl)		; $7cb4
	xor $01			; $7cb5
	ld (hl),a		; $7cb7

	ld e,Interaction.subid		; $7cb8
	ld a,(de)		; $7cba
	add a			; $7cbb
	add (hl)		; $7cbc
	call interactionSetAnimation		; $7cbd

@setRandomVar38:
	call getRandomNumber_noPreserveVars		; $7cc0
	and $03			; $7cc3
	swap a			; $7cc5
	add $20			; $7cc7
.ifdef ROM_AGES
	ld e,Interaction.var38		; $7cc9
.else
	ld e,Interaction.var37		; $7cc9
.endif
	ld (de),a		; $7ccb
	ret			; $7ccc

@substate4:
	call interactionDecCounter1		; $7ccd
	ret nz			; $7cd0

	ld b,120		; $7cd1
	ld e,Interaction.subid		; $7cd3
	ld a,(de)		; $7cd5
	or a			; $7cd6
	jr nz,+			; $7cd7
	ld b,160		; $7cd9
+
	ld (hl),b ; [counter1]
	ld hl,wTmpcfc0.genericCutscene.cfd0		; $7cdc
	ld (hl),$03		; $7cdf
	jp interactionIncState2		; $7ce1

@substate5:
	call interactionDecCounter1		; $7ce4
	ret nz			; $7ce7
	ld (hl),60 ; [counter1]
	ld hl,wTmpcfc0.genericCutscene.cfd0		; $7cea
	ld (hl),$04		; $7ced
	jp interactionIncState2		; $7cef

@substate6:
	call interactionAnimate		; $7cf2
	call objectApplySpeed		; $7cf5
	call interactionDecCounter1		; $7cf8
	ret nz			; $7cfb
	ld hl,wTmpcfc0.genericCutscene.cfdf		; $7cfc
	ld (hl),$01		; $7cff
	ret			; $7d01


; ==============================================================================
; INTERACID_TIMEPORTAL_SPAWNER
; ==============================================================================
interactionCodee1:
	ld e,Interaction.state		; $7d02
	ld a,(de)		; $7d04
	rst_jumpTable			; $7d05
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

; Portal is active
@state3:
	call objectSetVisible83		; $7d0e
	ld b,$01		; $7d11
	call objectFlickerVisibility		; $7d13
	call interactionAnimate		; $7d16

	call @markSpotDiscovered		; $7d19

	; Wait for Link to touch the portal
	ld a,(wLinkObjectIndex)		; $7d1c
	rrca			; $7d1f
	ret c			; $7d20
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $7d21
	ret nc			; $7d24
	call checkLinkCollisionsEnabled		; $7d25
	ret nc			; $7d28

	; Link touched the portal
	ld e,Interaction.subid		; $7d29
	ld a,(de)		; $7d2b
	bit 6,a			; $7d2c
	jr z,++			; $7d2e
	call getThisRoomFlags		; $7d30
	set 1,(hl)		; $7d33
++
	jpab interactionBeginTimewarp
	; Above call will delete this object

@state0:
	ld e,Interaction.subid		; $7d3d
	ld a,(de)		; $7d3f
	and $0f			; $7d40
	rst_jumpTable			; $7d42
	.dw @commonInit
	.dw @subid1Init
	.dw @subid2Init

@subid1Init:
	ld a,GLOBALFLAG_MAKU_TREE_SAVED		; $7d49
	call checkGlobalFlag		; $7d4b
	jr nz,@commonInit	; $7d4e
	jr @setSubidBit7		; $7d50

@subid2Init:
	ld a,TREASURE_SEED_SATCHEL		; $7d52
	call checkTreasureObtained		; $7d54
	jr c,@commonInit	; $7d57

@setSubidBit7:
	ld h,d			; $7d59
	ld l,Interaction.subid		; $7d5a
	set 7,(hl)		; $7d5c

@commonInit:
	; If the portal tile is hidden, don't allow activation yet
	call objectGetTileAtPosition		; $7d5e
	cp TILEINDEX_PORTAL_SPOT			; $7d61
	ret nz			; $7d63

	call interactionInitGraphics		; $7d64
	call interactionSetAlwaysUpdateBit		; $7d67
	ld a,$02		; $7d6a
	call objectSetCollideRadius		; $7d6c

	ld l,Interaction.subid		; $7d6f
	ld b,(hl)		; $7d71
	bit 6,b			; $7d72
	jr z,@nextState	; $7d74

	call getThisRoomFlags		; $7d76
	and $02			; $7d79
	jr nz,@nextState	; $7d7b

	set 7,b			; $7d7d
@nextState:
	call interactionIncState		; $7d7f
	bit 7,b			; $7d82
	ret z			; $7d84
	ld (hl),$03		; $7d85
	ret			; $7d87

@state1:
	ld a,(wLinkPlayingInstrument)		; $7d88
	dec a			; $7d8b
	ret nz			; $7d8c
	call interactionIncState		; $7d8d

@markSpotDiscovered:
	call getThisRoomFlags		; $7d90
	set ROOMFLAG_BIT_PORTALSPOT_DISCOVERED,(hl)		; $7d93
	ret			; $7d95

@state2:
	ld a,(wLinkPlayingInstrument)		; $7d96
	or a			; $7d99
	ret nz			; $7d9a
	ld a,SNDCTRL_STOPSFX		; $7d9b
	call playSound		; $7d9d
	ld a,SND_TELEPORT		; $7da0
	call playSound		; $7da2
	jp interactionIncState		; $7da5


; ==============================================================================
; INTERACID_KNOW_IT_ALL_BIRD
;
; Variables:
;   var36: Counter until bird should turn around?
;   var37: Set while being talked to (signal to change animation)
; ==============================================================================
interactionCodee3:
	call checkInteractionState		; $7da8
	jr nz,@state1		; $7dab

@state0:
	ld a,$01		; $7dad
	ld (de),a		; $7daf
	call interactionInitGraphics		; $7db0
	ld hl,knowItAllBirdScript		; $7db3
	call interactionSetScript		; $7db6

	call getRandomNumber_noPreserveVars		; $7db9
	and $01			; $7dbc
	ld e,Interaction.direction		; $7dbe
	ld (de),a		; $7dc0
	call interactionSetAnimation		; $7dc1
	call interactionSetAlwaysUpdateBit		; $7dc4

	ld l,Interaction.var36		; $7dc7
	ld (hl),30		; $7dc9

	call @beginJump		; $7dcb
	ld l,Interaction.subid		; $7dce
	ld a,(hl)		; $7dd0
	ld l,Interaction.textID		; $7dd1
	ld (hl),a		; $7dd3

	ld hl,@oamFlagsTable		; $7dd4
	rst_addAToHl			; $7dd7
	ld a,(hl)		; $7dd8
	ld e,Interaction.oamFlags		; $7dd9
	ld (de),a		; $7ddb
	ld a,>TX_3200		; $7ddc
	call interactionSetHighTextIndex		; $7dde
	jp objectSetVisible82		; $7de1

@oamFlagsTable:
	.db $00 $01 $02 $03 $02 $03 $01 $00 $00 $01

@state1:
	call interactionRunScript		; $7dee
	call checkInteractionState2		; $7df1
	jr nz,@substate1	; $7df4

@substate0:
	ld e,Interaction.var37		; $7df6
	ld a,(de)		; $7df8
	or a			; $7df9
	jr z,@label_10_337	; $7dfa

	; Being talked to
	call interactionIncState2		; $7dfc
	ld l,Interaction.direction		; $7dff
	ld a,(hl)		; $7e01
	add $02			; $7e02
	jp interactionSetAnimation		; $7e04

@label_10_337:
	; Not being talked to; looks left and right
	call @decVar36		; $7e07
	jr nz,@animate	; $7e0a
	ld l,Interaction.var36		; $7e0c
	ld (hl),30		; $7e0e
	call getRandomNumber		; $7e10
	and $07			; $7e13
	jr nz,@animate	; $7e15
	ld l,Interaction.direction		; $7e17
	ld a,(hl)		; $7e19
	xor $01			; $7e1a
	ld (hl),a		; $7e1c
	jp interactionSetAnimation		; $7e1d

@animate:
	jp interactionAnimateAsNpc		; $7e20

@substate1:
	call interactionAnimate		; $7e23
	ld h,d			; $7e26
	ld l,Interaction.var37		; $7e27
	ld a,(hl)		; $7e29
	or a			; $7e2a
	jp nz,@updateSpeedZ		; $7e2b

	ld l,Interaction.var36		; $7e2e
	ld (hl),60		; $7e30

	; a == 0 here
	ld l,Interaction.state2		; $7e32
	ld (hl),a		; $7e34
	ld l,Interaction.z		; $7e35
	ldi (hl),a		; $7e37
	ld (hl),a		; $7e38

	ld l,Interaction.direction		; $7e39
	ld a,(hl)		; $7e3b
	jp interactionSetAnimation		; $7e3c

@decVar36:
	ld h,d			; $7e3f
	ld l,Interaction.var36		; $7e40
	dec (hl)		; $7e42
	ret			; $7e43

@updateSpeedZ:
	ld c,$20		; $7e44
	call objectUpdateSpeedZ_paramC		; $7e46
	ret nz			; $7e49
	ld h,d			; $7e4a

@beginJump:
	ld bc,-$c0		; $7e4b
	jp objectSetSpeedZ		; $7e4e


; ==============================================================================
; INTERACID_RAFT
; ==============================================================================
interactionCodee6:
	ld e,Interaction.state		; $7e51
	ld a,(de)		; $7e53
	rst_jumpTable			; $7e54
	.dw @state0
	.dw @state1
	.dw interactionDelete

@state0:
	ld e,Interaction.subid		; $7e5b
	ld a,(de)		; $7e5d
	rst_jumpTable			; $7e5e
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	ld a,(wDimitriState)		; $7e65
	bit 6,a			; $7e68
	jp z,interactionDelete		; $7e6a

; Subid 1: A raft that's put there through the room's object list; it must check that
; there is no already-existing raft on the screen (either from a remembered position, or
; from Link riding it)
@subid1:
	ld a,GLOBALFLAG_RAFTON_CHANGED_ROOMS		; $7e6d
	call checkGlobalFlag		; $7e6f
	jp z,interactionDelete		; $7e72

	; Check if Link's riding a raft
	ld a,(w1Companion.id)		; $7e75
	cp SPECIALOBJECTID_RAFT			; $7e78
	jp z,interactionDelete		; $7e7a

	; Check if there's another raft interaction
	ld c,INTERACID_RAFT		; $7e7d
	call objectFindSameTypeObjectWithID		; $7e7f
	ld a,h			; $7e82
	cp d			; $7e83
	jp nz,interactionDelete		; $7e84

; Subid 2: when the raft's position was remembered
@subid2:
	push de			; $7e87
	ld a,UNCMP_GFXH_3b		; $7e88
	call loadUncompressedGfxHeader		; $7e8a
	pop de			; $7e8d
	call interactionInitGraphics		; $7e8e
	call interactionIncState		; $7e91
	ld e,Interaction.direction		; $7e94
	ld a,(de)		; $7e96
	and $01			; $7e97
	call interactionSetAnimation		; $7e99
	jp objectSetVisible83		; $7e9c

@state1:
	call interactionAnimate		; $7e9f
	ld a,$09		; $7ea2
	call @checkLinkWithinRange		; $7ea4
	ret nc			; $7ea7

	ld a,(wLinkInAir)		; $7ea8
	or a			; $7eab
	jr z,@mountedRaft	; $7eac

	ld hl,w1Link.zh		; $7eae
	ld a,(hl)		; $7eb1
	cp $fd			; $7eb2
	ret c			; $7eb4

	ld l,<w1Link.speedZ+1		; $7eb5
	bit 7,(hl)		; $7eb7
	ret nz			; $7eb9

@mountedRaft:
	; Moving onto raft?
	ld a,d			; $7eba
	ld (wLinkRidingObject),a		; $7ebb
	ld a,$05		; $7ebe
	ld (wInstrumentsDisabledCounter),a		; $7ec0
	call @checkLinkWithinRange		; $7ec3
	ret nc			; $7ec6

	ld a,(w1Link.id)		; $7ec7
	or a			; $7eca
	jr z,++			; $7ecb
	xor a ; SPECIALOBJECTID_LINK
	call setLinkIDOverride		; $7ece
++
	ld hl,w1Companion.enabled		; $7ed1
	ld (hl),$03		; $7ed4
	inc l			; $7ed6
	ld (hl),SPECIALOBJECTID_RAFT		; $7ed7
	ld e,Interaction.direction		; $7ed9
	ld l,<w1Link.direction		; $7edb
	ld a,(de)		; $7edd
	ldi (hl),a		; $7ede
	call objectCopyPosition		; $7edf
	jp interactionIncState		; $7ee2


;;
; @param	a	Collision radius
; @addr{7ee5}
@checkLinkWithinRange:
	call objectSetCollideRadius		; $7ee5
	ld hl,w1Link.yh		; $7ee8
	ldi a,(hl)		; $7eeb
	add $05			; $7eec
	ld b,a			; $7eee
	inc l			; $7eef
	ld c,(hl) ; [w1Link.xh]
	jp interactionCheckContainsPoint		; $7ef1
