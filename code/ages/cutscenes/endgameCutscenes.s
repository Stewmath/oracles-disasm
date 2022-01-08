; This code goes right after the cutscene code in bank 3 (shares the same namespace)

;;
; CUTSCENE_BLACK_TOWER_ESCAPE
endgameCutsceneHandler_09:
	ld de,wGenericCutscene.cbc1
	ld a,(de)
	rst_jumpTable
	.dw endgameCutsceneHandler_09_stage0
	.dw endgameCutsceneHandler_09_stage1


endgameCutsceneHandler_09_stage0:
	call updateStatusBar
	call @runStates
	jp updateAllObjects

@runStates:
	ld de,wGenericCutscene.cbc2
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE
	.dw @stateF
	.dw @state10
	.dw @state11
	.dw @state12
	.dw @state13
	.dw @state14
	.dw @state15

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cutscene_clearCFC0ToCFDF
	call incCbc2

	; Outside black tower
	ld bc,ROOM_AGES_176
	call disableLcdAndLoadRoom
	call resetCamera

	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	call clearAllParentItems
	call dropLinkHeldItem

	ld hl,objectData.blackTowerEscape_nayruAndRalph
	call parseGivenObjectData
	ld hl,wGenericCutscene.cbb3
	ld (hl),60

	ld hl,blackTowerEscapeCutscene_doorBlockReplacement
	call cutscene_replaceListOfTiles

	call refreshObjectGfx
	ld a,$02
	call loadGfxRegisterStateIndex
	jp fadeinFromWhiteToRoom

@state1:
	call cutscene_decCBB3IfNotFadingOut
	ret nz
	ld (hl),120
	ld l,<wGenericCutscene.cbb6
	ld (hl),$10
	jp incCbc2

@state2:
	call decCbb3
	jr nz,@updateExplosionSoundsAndScreenShake
	ld (hl),60
	jp incCbc2

@updateExplosionSoundsAndScreenShake:
	ld hl,wTmpcbb6
	dec (hl)
	ret nz
	ld (hl),$10
	ld a,SND_EXPLOSION
	call playSound
	ld a,$08
	call setScreenShakeCounter
	xor a
	ret

@state3:
	call decCbb3
	ret nz
	ld (hl),30
	ld bc,TX_1d0a
	call showText
	jp incCbc2

@state4:
	call cutscene_decCBB3IfTextNotActive
	ret nz
	ld (hl),120
	ld l,<wGenericCutscene.cbb6
	ld (hl),$10
	jp incCbc2

@state5:
	call decCbb3
	jr nz,@explosions

	ld (hl),40
	call incCbc2

	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$48
	ld l,<w1Link.xh
	ld (hl),$50
	ld l,<w1Link.direction
	ld (hl),DIR_DOWN

	ld hl,cutscenesBank10.blackTowerEscape_simulatedInput1
	ld a,:cutscenesBank10.blackTowerEscape_simulatedInput1
	call setSimulatedInputAddress

	ld hl,blackTowerEscapeCutscene_doorOpenReplacement
	jp cutscene_replaceListOfTiles

@explosions:
	call @updateExplosionSoundsAndScreenShake
	ret nz
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_EXPLOSION_WITH_DEBRIS
	inc l
	inc l
	inc (hl) ; [var03] = $01
	ld a,$01
	ld (wTmpcfc0.genericCutscene.cfd0),a
	ret

@state6:
	call decCbb3
	jr nz,@explosions
	jp incCbc2

@state7:
	; Wait for signal from an object?
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $04
	ret nz

	call incCbc2
	xor a
	ld (wDisabledObjects),a
	ld (wScrollMode),a

	ld hl,cutscenesBank10.blackTowerEscape_simulatedInput2
	ld a,:cutscenesBank10.blackTowerEscape_simulatedInput2
	jp setSimulatedInputAddress

@state8:
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $05
	ret nz
	call incCbc2
	jp fadeoutToWhite

@state9:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call incCbc2

	ld bc,ROOM_AGES_165
	call disableLcdAndLoadRoom

	call resetCamera
	ld a,MUS_DISASTER
	call playSound

	ld a,$02
	call loadGfxRegisterStateIndex

	ld hl,objectData.blackTowerEscape_ambiAndGuards
	call parseGivenObjectData

	ld hl,wTmpcbb3
	ld (hl),30
	jp fadeinFromWhiteToRoom

@stateA:
	call cutscene_decCBB3IfNotFadingOut
	ret nz

	call incCbc2

	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$88
	ld l,<w1Link.xh
	ld (hl),$50
	ld l,<w1Link.direction
	ld (hl),DIR_UP

	ld hl,cutscenesBank10.blackTowerEscape_simulatedInput3
	ld a,:cutscenesBank10.blackTowerEscape_simulatedInput3
	call setSimulatedInputAddress
	xor a
	ld (wScrollMode),a
	ret

@stateB:
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $06
	ret nz
	call incCbc2
	ld hl,cutscenesBank10.blackTowerEscape_simulatedInput4
	ld a,:cutscenesBank10.blackTowerEscape_simulatedInput4
	jp setSimulatedInputAddress

@stateC:
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $0a
	ret nz
	call incCbc2

	; TODO: what is this?
	ld hl,wTmpcfc0.genericCutscene.cfde
	ld (hl),$08
	inc l
	ld (hl),$00

	jp fadeoutToWhite

@stateD:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
	call cutscene_loadRoomObjectSetAndFadein
	xor a
	ld (wTmpcfc0.genericCutscene.cfd1),a
	ld (wTmpcfc0.genericCutscene.cfdf),a
	ld a,$02
	jp loadGfxRegisterStateIndex

@stateE:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,wTmpcfc0.genericCutscene.cfdf
	ld a,(hl)
	cp $ff
	ret nz
	xor a

	ldd (hl),a ; wTmpcfc0.genericCutscene.cfdf
	inc (hl) ; wTmpcfc0.genericCutscene.cfde
	ld a,(hl)
	cp $0a
	ld a,$0d
	jr nz,+
	ld a,$0f
+
	ld hl,wGenericCutscene.cbc2
	ld (hl),a
	jp fadeoutToWhite

@stateF:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call incCbc2
	call cutscene_loadRoomObjectSetAndFadein

	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$48
	ld l,<w1Link.xh
	ld (hl),$60
	ld l,<w1Link.direction

	ld (hl),DIR_UP
	ld a,$0b
	ld (wTmpcfc0.genericCutscene.cfd0),a
	ld a,$02
	jp loadGfxRegisterStateIndex

@state10:
	call checkIsLinkedGame
	jr nz,@@linked

	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $10
	ret nz
	call incCbc2
	jp fadeoutToWhite

@@linked:
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $12
	ret nz
	ld hl,wGenericCutscene.cbc2
	ld (hl),$14
	ret

@state11:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),60

	ld a,$ff
	ld (wTilesetAnimation),a
	call disableLcd

	ld a,GFXH_2b
	call loadGfxHeader
	ld a,PALH_9d
	call loadPaletteHeader

	call cutscene_clearObjects
	call cutscene_resetOamWithSomething2
	ld a,$04
	call loadGfxRegisterStateIndex
	jp fadeinFromWhite

@state12:
	call cutscene_resetOamWithSomething2
	call cutscene_decCBB3IfNotFadingOut
	ret nz

	call incCbc2
	ld hl,wMenuDisabled
	ld (hl),$01
	ld hl,wTmpcbb3
	ld (hl),60

	ld bc,TX_1312

@showTextDuringTwinrovaCutscene:
	ld a,TEXTBOXFLAG_NOCOLORS
	ld (wTextboxFlags),a
	jp showText

@state13:
	call cutscene_resetOamWithSomething2
	call cutscene_decCBB3IfTextNotActive
	ret nz
	call cutscene_clearTmpCBB3
	ld a,$01
	ld (wGenericCutscene.cbc1),a
	jp fadeoutToWhite

@state14:
	ld a,(wTextIsActive)
	rlca
	ret nc
	ld a,(wKeysJustPressed)
	or a
	ret z
	call incCbc2
	ld a,$04
	jp fadeoutToWhiteWithDelay

@state15:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	xor a
	ld (wTextIsActive),a
	ld a,CUTSCENE_ZELDA_KIDNAPPED
	ld (wCutsceneTrigger),a
	ret


; Twinrova appears just before credits
endgameCutsceneHandler_09_stage1:
	call @runStates
	jp updateAllObjects

@runStates:
	ld de,wGenericCutscene.cbc2
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7
	.dw @state8
	.dw @state9

@state0:
	call cutscene_resetOamWithSomething2
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),60

	call disableLcd
	call clearOam
	ld a,GFXH_2c
	call loadGfxHeader
	ld a,PALH_9e
	call loadPaletteHeader
	ld a,$04
	call loadGfxRegisterStateIndex

	ld a,MUS_DISASTER
	call playSound
	jp fadeinFromWhite

@state1:
	ld a,TEXTBOXFLAG_NOCOLORS
	ld (wTextboxFlags),a
	ld a,60
	ld bc,TX_280b
	call cutscene_decCBB3IfNotFadingOut
	ret nz
	call incCbc2
	ld a,e
	ld (wTmpcbb3),a
	jp showText

@state2:
	call cutscene_decCBB3IfTextNotActive
	ret nz
	call incCbc2

	ld hl,wTmpcbb5
	ld (hl),$d0

@loadCertainOamData1:
	ld hl,bank16.oamData_4d05
	ld e,:bank16.oamData_4d05

@loadOamData:
	ld b,$30
	push de
	ld de,wTmpcbb5
	ld a,(de)
	pop de
	ld c,a
	jp cutscene_resetOamWithData

@state3:
	ld hl,wTmpcbb5
	inc (hl)
	jr nz,@loadCertainOamData1
	call clearOam
	ld a,UNCMP_GFXH_0a
	call loadUncompressedGfxHeader
	ld hl,wTmpcbb3
	ld (hl),30
	jp incCbc2

@state4:
	call decCbb3
	ret nz
	call incCbc2
	ld hl,wTmpcbb5
	ld (hl),$d0

@loadCertainOamData2:
	ld hl,bank16.oamData_4d9e
	ld e,:bank16.oamData_4d9e
	jr @loadOamData

@state5:
	call @loadCertainOamData2
	ld hl,wTmpcbb5
	dec (hl)
	ld a,(hl)
	sub $a0
	ret nz

	ld (wScreenOffsetY),a ; 0
	ld (wScreenOffsetX),a

	ld a,30
	ld (wTmpcbb3),a
	ld (wOpenedMenuType),a ; TODO: ???
	jp incCbc2

@state6:
	call @loadCertainOamData2
	call decCbb3
	ret nz
	ld hl,wTmpcbb3
	ld (hl),20
	ld bc,TX_280c
	call endgameCutsceneHandler_09_stage0@showTextDuringTwinrovaCutscene
	jp incCbc2

@state7:
	call @loadCertainOamData2
	call cutscene_decCBB3IfTextNotActive
	ret nz
	xor a
	ld (wOpenedMenuType),a
	dec a
	ld (wTmpcbba),a
	ld a,SND_LIGHTNING
	call playSound
	jp incCbc2

@state8:
	call @loadCertainOamData2
	ld hl,wTmpcbb3
	ld b,$02
	call flashScreen
	ret z

	; Time to load twinrova's face graphics?

	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),30

	call disableLcd
	call clearOam
	xor a
	ld ($ff00+R_VBK),a
	ld hl,$8000
	ld bc,$2000
	call clearMemoryBc

	xor a
	ld ($ff00+R_VBK),a
	ld hl,$9c00
	ld bc,$0400
	call clearMemoryBc

	ld a,$01
	ld ($ff00+R_VBK),a
	ld hl,$9c00
	ld bc,$0400
	call clearMemoryBc

	ld a,GFXH_2d
	call loadGfxHeader
	ld a,PALH_9c
	call loadPaletteHeader
	ld a,$04
	call loadGfxRegisterStateIndex
	ld a,SND_LIGHTNING
	call playSound
	jp clearPaletteFadeVariablesAndRefreshPalettes

@state9:
	call decCbb3
	ret nz
	ld a,CUTSCENE_CREDITS
	ld (wCutsceneIndex),a
	call cutscene_clearTmpCBB3
	ld hl,wRoomLayout
	ld bc,$00c0
	call clearMemoryBc
	ld hl,wRoomCollisions
	ld bc,$00c0
	call clearMemoryBc
	ldh (<hCameraY),a
	ldh (<hCameraX),a
	ld hl,wTmpcbb3
	ld (hl),60
	ld a,$03
	jp fadeoutToBlackWithDelay

;;
; CUTSCENE_FLAME_OF_DESPAIR
endgameCutsceneHandler_20:
	call @runStates
	jp updateAllObjects

@runStates:
	ld de,$cbc1
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE
	.dw @stateF
	.dw @state10
	.dw @state11
	.dw @state12
	.dw @state13
	.dw @state14
	.dw @state15
	.dw @state16

@state0:
	ld a,$0b
	ld ($cfde),a
	call cutscene_loadRoomObjectSetAndFadein
	call hideStatusBar
	ld a,PALH_ac
	call loadPaletteHeader
	xor a
	ld (wPaletteThread_mode),a
	call clearFadingPalettes2
	ld hl,wTmpcbb3
	ld (hl),$1e
	ld a,$13
	call loadGfxRegisterStateIndex
	ld hl,wGfxRegs1.SCY
	ldi a,(hl)
	ldh (<hCameraY),a
	ld a,(hl)
	ldh (<hCameraX),a
	ld a,$00
	ld (wScrollMode),a
	jp incCbc1

@state1:
	call decCbb3
	ret nz
	call incCbc1
	ld hl,wTmpcbb3
	ld (hl),$28
	ld a,TEXTBOXFLAG_ALTPALETTE1
	ld (wTextboxFlags),a
	ld bc,TX_2825
	jp showText

@state2:
	call cutscene_decCBB3IfTextNotActive
	ret nz
	call incCbc1
	ld a,$20
	ld hl,wTmpcbb3
	ldi (hl),a
	xor a
	ld (hl),a
	ret

@state3:
	call cutscene_decCBB3IfNotFadingOut
	ret nz
	ld hl,wTmpcbb3
	ld (hl),$20
	inc hl
	ld a,(hl)
	cp $03
	jr nc,+
	ld b,a
	push hl
	ld a,SND_LIGHTTORCH
	call playSound
	pop hl
	ld a,b
+
	inc (hl)
	ld hl,@table_5932
	rst_addAToHl
	ld a,(hl)
	or a
	ld b,a
	jr nz,@func_5920
	call fadeinFromBlack
	ld a,$01
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld a,MUS_ROOM_OF_RITES
	call playSound
	jp incCbc1
;;
; @param	b	values in @table_5932 one at a time
@func_5920:
	call fastFadeinFromBlack
	ld a,b
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	xor a
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	ret
@table_5932:
	.db $40 $10 $80 $28 $06
	.db $00

@state4:
	ld e,$28
	ld bc,TX_2826
	call @func_5943
	jp cutscene_decCBB3IfNotFadingOut_incState_setCBB3_showText

@func_5943:
	ld a,TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a
	ld a,$03
	ld (wTextboxPosition),a
	ret

@state5:
	ld e,$28
	ld bc,TX_2827
@func_5953:
	call cutscene_decCBB3IfTextNotActive
	ret nz
	call incCbc1
	ld hl,wTmpcbb3
	ld (hl),e
	call @func_5943
	jp showText

@state6:
	ld e,$3c
	ld bc,TX_2828
	jr @func_5953

@state7:
	ld e,$b4
@func_596d:
	call cutscene_decCBB3IfTextNotActive
	ret nz
	call incCbc1
	ld hl,wTmpcbb3
	ld (hl),e
	ret

@state8:
	call @func_5995
	call cutscene_rumbleSoundWhenFrameCounterLowerNibbleIs0
	call decCbb3
	ret nz
	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SNDCTRL_MEDIUM_FADEOUT
	call playSound
	call incCbc1
	ld a,$04
	jp fadeoutToWhiteWithDelay
@func_5995:
	ld hl,wGfxRegs1.SCY
	ldh a,(<hCameraY)
	ldi (hl),a
	ldh a,(<hCameraX)
	ldi (hl),a
	ld hl,@table_59ab
	ld de,wGfxRegs1.SCY
	call @func_59b3
	inc de
	jp @func_59b3
@table_59ab:
	.db $ff $01 $00 $01
	.db $00 $00 $ff $00
@func_59b3:
	push hl
	call getRandomNumber
	and $07
	rst_addAToHl
	ld a,(hl)
	ld b,a
	ld a,(de)
	add b
	ld (de),a
	pop hl
	ret

@state9:
	call @func_5995
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc1
	ld a,$0c
	ld ($cfde),a
	call cutscene_loadRoomObjectSetAndFadein
	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$48
	ld l,<w1Link.xh
	ld (hl),$60
	ld l,<w1Link.direction
	ld (hl),DIR_UP
	ld a,$81
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call cutscene_clearCFC0ToCFDF
	call showStatusBar
	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld a,$02
	jp loadGfxRegisterStateIndex

@stateA:
	call updateStatusBar
	ld a,($cfd0)
	cp $01
	ret nz
	call incCbc1
	ld c,$40
	ld a,$29
	call giveTreasure
	ld a,$08
	call setLinkIDOverride
	ld l,<w1Link.subid
	ld (hl),$0c
	ld hl,wTmpcbb3
	ld (hl),$5a
	ld a,MUS_PRECREDITS
	jp playSound

@stateB:
	call updateStatusBar
	call decCbb3
	ret nz
	call incCbc1
	ld hl,wTmpcbb3
	ld (hl),$b4
	ld bc,$4860
	ld a,$ff
	jp createEnergySwirlGoingOut

@stateC:
	call updateStatusBar
	call decCbb3
	ret nz
	call incCbc1
	ld hl,wTmpcbb3
	ld (hl),$3c
	jp fadeoutToWhite

@stateD:
	call cutscene_decCBB3IfNotFadingOut
	ret nz
	call incCbc1
	call disableLcd
	call clearOam
	call clearScreenVariablesAndWramBank1
	call refreshObjectGfx
	call hideStatusBar
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld hl,$de90
	ld b,$08
	ld a,$ff
	call fillMemory
	xor a
	ld ($ff00+R_SVBK),a
	ld a,$07
	ldh (<hDirtyBgPalettes),a
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_NAYRU
	inc l
	ld (hl),$12
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_DIN
	inc l
	ld (hl),$02
+
	ld a,$02
	ld (wOpenedMenuType),a
	call func_6e9a
	ld a,$02
	call func_6ed6
	ld hl,wTmpcbb3
	ld (hl),$1e
	ld a,$04
	call loadGfxRegisterStateIndex
	ld a,$10
	ldh (<hCameraY),a
	xor a
	ldh (<hCameraX),a
	ld a,$00
	ld (wScrollMode),a
	ld bc,TX_1d1a
	jp showText

@stateE:
	call cutscene_decCBB3IfTextNotActive
	ret nz
	call incCbc1
	ld b,$04
@func_5ac2:
	call fadeinFromWhite
	ld a,b
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	xor a
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	ld hl,wTmpcbb3
	ld (hl),$3c
	ret

@stateF:
	ld e,$1e
	ld bc,TX_1d1b
	jp cutscene_decCBB3IfNotFadingOut_incState_setCBB3_showText

@state10:
	call cutscene_decCBB3IfTextNotActive
	ret nz
	call incCbc1
	ld b,$12
	jp @func_5ac2

@state11:
	ld e,$1e
	ld bc,TX_1d1c
	jp cutscene_decCBB3IfNotFadingOut_incState_setCBB3_showText

@state12:
	ld e,$3c
	jp @func_596d

@state13:
	call decCbb3
	ret nz
	call incCbc1
	ld hl,wTmpcbb3
	ld (hl),$f0
	ld a,$ff
	ld bc,$4850
	jp createEnergySwirlGoingOut

@state14:
	call decCbb3
	ret nz
	ld hl,wTmpcbb3
	ld (hl),$5a
	call fadeoutToWhite
	ld a,$fc
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	jp incCbc1

@state15:
	call cutscene_decCBB3IfNotFadingOut
	ret nz
	call incCbc1
	call clearDynamicInteractions
	call clearParts
	call clearOam
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld bc,TX_1d1d
	jp showTextNonExitable

@state16:
	ld a,(wTextIsActive)
	rlca
	ret nc
	call decCbb3
	ret nz
	call showStatusBar
	xor a
	ld (wOpenedMenuType),a
	dec a
	ld (wActiveMusic),a
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	ld hl,@warpDest
	jp setWarpDestVariables

@warpDest:
	m_HardcodedWarpA ROOM_AGES_5f4, $0f, $57, $03


;;
; CUTSCENE_ROOM_OF_RITES_COLLAPSE
endgameCutsceneHandler_0f:
	ld de,$cbc1
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call updateStatusBar
	call @@runSubstates
	jp updateAllObjects

@@runSubstates:
	ld de,$cbc2
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6
	.dw @@substate7
	.dw @@substate8
	.dw @@substate9
	.dw @@substateA
	.dw @@substateB
	.dw @@substateC
	.dw @@substateD

@@substate0:
	ld a,$01
	ld (de),a
	ld hl,wActiveRing
	ld (hl),$ff
	xor a
	ldh (<hActiveObjectType),a
	ld de,$d000
	ld bc,$f8f0
	ld a,$28
	call objectCreateExclamationMark
	ld a,$28
	call objectCreateExclamationMark
	ld l,Interaction.yh
	ld (hl),$30
	inc l
	inc l
	ld (hl),$78
	ld hl,wTmpcbb3
	ld (hl),$0a
	ret
@@substate1:
	call decCbb3
	ret nz
	ld hl,wTmpcbb3
	ld (hl),$1e
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	jp incCbc2
@@substate2:
	call cutscene_setScreenShakeCounterTo4RumbleAt0
	call decCbb3
	ret nz
	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),$96
	jp @@func_5cb0
@@substate3:
	call cutscene_setScreenShakeCounterTo4RumbleAt0
	call decCbb3
	ret nz
	call incCbc2
	ld a,SNDCTRL_STOPSFX
	call playSound
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld bc,TX_3d0e
	jp showText
@@substate4:
	call cutscene_decCBB3IfTextNotActive
	ret nz
	call incCbc2
	ld a,MUS_DISASTER
	call playSound
	ld hl,wTmpcbb3
	ld (hl),$3c
	jp @@func_5cb0
@@substate5:
	call cutscene_setScreenShakeCounterTo4RumbleAt0
	call decCbb3
	ret nz
	ld hl,wTmpcbb3
	ld (hl),$5a
	jp incCbc2
@@substate6:
	call cutscene_setScreenShakeCounterTo4RumbleAt0
	call decCbb3
	ret nz
	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld a,SNDCTRL_STOPSFX
	jp playSound
@@substate7:
	call decCbb3
	ret nz
	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld bc,TX_3d0f
	jp showText
@@substate8:
	call cutscene_decCBB3IfTextNotActive
	ret nz
	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),$68
	inc hl
	ld (hl),$01
	jp @@func_5cb7
@@substate9:
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	ret nz
	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld bc,TX_0563
	jp showText
@@substateA:
	ld e,$1e
	jp cutscene_incCBC2setCBB3whenCBB3is0
@@substateB:
	call cutscene_setScreenShakeCounterTo4RumbleAt0
	call decCbb3
	ret nz
	call incCbc2
	call @@func_5cb0
	ld a,$8c
	ld (wTmpcbb3),a
	ld a,$ff
	ld bc,$4478
	jp createEnergySwirlGoingOut
@@substateC:
	call cutscene_setScreenShakeCounterTo4RumbleAt0
	call decCbb3
	ret nz
	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),$3c
	jp @@func_5cb0
@@substateD:
	call cutscene_setScreenShakeCounterTo4RumbleAt0
	call decCbb3
	ret nz
	call incCbc1
	inc l
	xor a
	ld (hl),a
	ld a,$03
	jp fadeoutToWhiteWithDelay
@@func_5cb0:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_ROOM_OF_RITES_FALLING_BOULDER
	ret
@@func_5cb7:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_MAKU_CONFETTI
	ret

@state1:
	call updateStatusBar
	call @@runSubstates
	jp updateAllObjects

@@runSubstates:
	ld de,$cbc2
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6
	.dw @@substate7
	.dw @@substate8
	.dw @@substate9
	.dw @@substateA
@@substate0:
	call cutscene_setScreenShakeCounterTo4RumbleAt0
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
	ld a,$11
	ld ($cfde),a
	call cutscene_loadRoomObjectSetAndFadein
	ld a,$04
	ld b,$02
	call cutscene_loadAObjectGfxBTimes_andReload
	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld a,$02
	jp loadGfxRegisterStateIndex
@@substate1:
	call cutscene_decCBB3IfNotFadingOut
	ret nz
	call incCbc2
	ld a,$3c
	ld (wTmpcbb3),a
	ld a,$64
	ld bc,$4850
	jp createEnergySwirlGoingIn
@@substate2:
	call decCbb3
	ret nz
	xor a
	ld (wTmpcbb3),a
	dec a
	ld (wTmpcbba),a
	jp incCbc2
@@substate3:
	ld hl,wTmpcbb3
	ld b,$01
	call flashScreen
	ret z
	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld a,$01
	ld ($cfc0),a
	ld a,$03
	jp fadeinFromWhiteWithDelay
@@substate4:
	call cutscene_decCBB3IfNotFadingOut
	ret nz
	call refreshObjectGfx
	ld a,$04
	ld b,$02
	call cutscene_loadAObjectGfxBTimes
	ld a,MUS_CREDITS_1
	call playSound
	ld hl,wTmpcbb3
	ld (hl),$3c
	jp incCbc2
@@substate5:
	call decCbb3
	ret nz
	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),$1e
	ret
@@substate6:
	call decCbb3
	ret nz
	call refreshObjectGfx
	ld a,$04
	ld b,$02
	call cutscene_loadAObjectGfxBTimes
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld hl,$cfc0
	ld (hl),$02
	jp incCbc2
@@substate7:
	ld a,($cfc0)
	cp $09
	ret nz
	call incCbc2
	ld a,$03
	jp fadeoutToWhiteWithDelay
@@substate8:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
	call disableLcd
	call clearScreenVariablesAndWramBank1
	call hideStatusBar
	ld a,$3c
	call loadGfxHeader
	ld a,PALH_c9
	call loadPaletteHeader
	ld hl,wTmpcbb3
	ld (hl),$f0
	ld a,$04
	call loadGfxRegisterStateIndex
	call cutscene_resetOamWithSomething1
	ld a,$03
	jp fadeinFromWhiteWithDelay
@@substate9:
	call cutscene_resetOamWithSomething1
	call cutscene_decCBB3IfNotFadingOut
	ret nz
	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),$10
	ld a,$03
	jp fadeoutToBlackWithDelay
@@substateA:
	call cutscene_resetOamWithSomething1
	call cutscene_decCBB3IfNotFadingOut
	ret nz
	ld a,CUTSCENE_CREDITS
	ld (wCutsceneIndex),a
	call cutscene_clearTmpCBB3
	ld hl,wRoomLayout
	ld bc,$00c0
	call clearMemoryBc
	ld hl,wRoomCollisions
	ld bc,$00c0
	call clearMemoryBc
	xor a
	ldh (<hCameraY),a
	ldh (<hCameraX),a
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld a,SNDCTRL_MEDIUM_FADEOUT
	jp playSound

;;
; CUTSCENE_CREDITS
endgameCutsceneHandler_0a:
	call @runStates
	jp func_3539

@runStates:
	ld de,$cbc1
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld de,$cbc2
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
@@substate0:
	call cutscene_decCBB3IfNotFadingOut
	ret nz
	call func_60e0
	call incCbc2
	call clearOam
	ld hl,wTmpcbb3
	ld (hl),$b4
	inc hl
	ld (hl),$00
	ld hl,wGfxRegs1.LCDC
	set 3,(hl)
	ld a,MUS_CREDITS_2
	jp playSound
@@substate1:
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	ret nz
	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),$48
	inc hl
	ld (hl),$03
	ld a,PALH_04
	call loadPaletteHeader
	ld a,$06
	jp fadeinFromBlackWithDelay
@@substate2:
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	ret nz
	call incCbc1
	inc l
	ld (hl),a
	ld b,$00
	call checkIsLinkedGame
	jr z,+
	ld b,$04
+
	ld hl,$cfde
	ld (hl),b
	inc l
	ld (hl),$00
	jp fadeoutToWhite

@state1:
	ld de,$cbc2
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
@@substate0:
	xor a
	ldh (<hOamTail),a
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call disableLcd
	call incCbc2
	call clearDynamicInteractions
	call clearOam
	ld a,$10
	ldh (<hOamTail),a
	ld a,($cfde)
	ld c,a
	call cutscene_clearCFC0ToCFDF
	ld a,c
	ld ($cfde),a
	cp $04
	jr nc,+
	ld hl,@@table_5f1c
	rst_addDoubleIndex
	ld b,(hl)
	inc hl
	ld c,(hl)
	ld a,$00
	call func_36f6
	ld a,($cfde)
	ld hl,@@table_5f24
	rst_addAToHl
	ldi a,(hl)
	call loadUncompressedGfxHeader
+
	ld a,($cfde)
	add a
	add $85
	call loadGfxHeader
	ld a,PALH_0f
	call loadPaletteHeader
	ld a,($cfde)
	ld b,$ff
	or a
	jr z,+
	cp $07
	jr z,+
	ld b,$01
+
	ld c,a
	ld a,b
	ld (wTilesetAnimation),a
	call loadAnimationData
	ld a,c
	ld hl,@@table_5f28
	rst_addAToHl
	ldi a,(hl)
	call loadPaletteHeader
	call reloadObjectGfx
	ld a,$01
	ld (wScrollMode),a
	xor a
	ldh (<hCameraX),a
	ld hl,$cfde
	ld b,(hl)
	call cutscene_parseObjectData_andLoadObjectGfx
	ld a,$04
	call loadGfxRegisterStateIndex
	jp fadeinFromWhite

@@table_5f1c:
	.db $00 $38
	.db $00 $3a
	.db $00 $4a
	.db $01 $16

@@table_5f24:
	.db $2d $0f
	.db $2d $0f

@@table_5f28:
	.db $30 $2d
	.db $2d $27
	.db $ca $ca
	.db $ca $ae

@@substate1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,($cfdf)
	or a
	ret z
	call incCbc2
	ld a,$ff
	ld (wTilesetAnimation),a
	jp fadeoutToWhite
@@substate2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
	call disableLcd
	call clearWramBank1
	ld a,($cfde)
	add a
	add $86
	call loadGfxHeader
	ld hl,wTmpcbb3
	ld (hl),$5a
	ld a,PALH_a1
	call loadPaletteHeader
	ld a,$04
	call loadGfxRegisterStateIndex
	ld a,($cfde)
	ld hl,@@table_5f81
	rst_addAToHl
	ld a,(hl)
	ld (wGfxRegs1.SCX),a
	ld a,$10
	ldh (<hCameraX),a
	xor a
	ld ($cfdf),a
	jp fadeinFromWhite
@@table_5f81:
	.db $00 $d0 $00 $d0
	.db $00 $d0 $00 $d0
@@substate3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call decCbb3
	ret nz
	call incCbc2
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_CREDITS_TEXT_HORIZONTAL
	inc l
	ld a,($cfde)
	ldi (hl),a
	ld (hl),$00
	ret
@@substate4:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	xor a
	ldh (<hOamTail),a
	ld a,($cfdf)
	or a
	ret z
	ld b,$03
	call checkIsLinkedGame
	jr z,+
	ld b,$07
+
	ld hl,$cfde
	ld a,(hl)
	cp b
	jr nc,@@func_5fc7
	inc (hl)
	xor a
	ld ($cbc2),a
	jr ++
@@func_5fc7:
	call cutscene_clearTmpCBB3
	call cutscene_clearCFC0ToCFDF
	ld a,$02
	ld ($cbc1),a
++
	jp fadeoutToWhite

@state2:
	jpab cutscenesBank10.agesFunc_10_70f6

@state3:
	jpab cutscenesBank10.agesFunc_10_7298

;;
; Called from disableLcdAndLoadRoom in bank 0.
;
disableLcdAndLoadRoom_body:
	ld a,b
	ld (wActiveGroup),a
	ld a,c
	ld (wActiveRoom),a
	call disableLcd
	call clearScreenVariablesAndWramBank1
	ld hl,wLinkInAir
	ld b,wcce9-wLinkInAir
	call clearMemory
	call initializeVramMaps
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics
	call func_131f
	ld a,$01
	ld (wScrollMode),a
	call loadCommonGraphics
	call clearOam
	ld a,$10
	ldh (<hOamTail),a
	ret


cutscene_parseObjectData_andLoadObjectGfx:
	call getEntryFromObjectTable1
	call parseGivenObjectData
	call refreshObjectGfx
	jp cutsceneFunc_6026

cutsceneFunc_6026:
	ld a,($cfde)
	cp $00
	jr z,cutscene_load_04_ObjectGfx2Times_andReload
	cp $01
	jr z,cutscene_load_26_ObjectGfx2Times_andReload
	cp $02
	jr z,cutscene_load_24_ObjectGfx2Times_andReload
	cp $04
	jr z,cutscene_load_26_ObjectGfx2Times_andReload
	ret

cutscene_loadAObjectGfxBTimes:
	ld hl,wLoadedObjectGfx
cutscene_loadAintoHL_BTimes:
	ldi (hl),a
	inc a
	ld (hl),$01
	inc l
	dec b
	jr nz,cutscene_loadAintoHL_BTimes
	ret

cutscene_load_24_ObjectGfx2Times_andReload:
	ld a,$24
	ld b,$02
	jr cutscene_loadAObjectGfxBTimes_andReload
cutscene_load_26_ObjectGfx2Times_andReload:
	ld a,$26
	ld b,$02
	jr cutscene_loadAObjectGfxBTimes_andReload
cutscene_load_04_ObjectGfx2Times_andReload:
	ld a,$04
	ld b,$02

cutscene_loadAObjectGfxBTimes_andReload:
	call cutscene_loadAObjectGfxBTimes
	jp reloadObjectGfx

cutscene_incCBC2setCBB3whenCBB3is0:
	call cutscene_decCBB3IfTextNotActive
	ret nz
	call incCbc2
	ld hl,wTmpcbb3
	ld (hl),e
	ret

;;
cutscene_decCBB3IfTextNotActive:
	ld a,(wTextIsActive)
	or a
	ret nz
	jp decCbb3

;;
cutscene_decCBB3IfNotFadingOut:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	jp decCbb3


cutscene_decCBB3IfNotFadingOut_incState_setCBB3_showText:
	call cutscene_decCBB3IfNotFadingOut
	ret nz
	call incCbc1
	ld a,e
	ld (wTmpcbb3),a
	jp showText

;;
cutscene_clearTmpCBB3:
	ld hl,wTmpcbb3
	ld b,$10
	jp clearMemory

;;
cutscene_clearCFC0ToCFDF:
	ld b,$20
	ld hl,$cfc0
	jp clearMemory

cutscene_setScreenShakeCounterTo4RumbleAt0:
	ld a,$04
	call setScreenShakeCounter
cutscene_rumbleSoundWhenFrameCounterLowerNibbleIs0:
	ld a,(wFrameCounter)
	and $0f
	ld a,SND_RUMBLE2
	jp z,playSound
	ret


;;
cutscene_resetOamWithSomething1:
	ld hl,bank16.oamData_4f73
	ld e,:bank16.oamData_4f73
	ld bc,$3038
	jr cutscene_resetOamWithData

;;
cutscene_resetOamWithSomething2:
	ld hl,bank16.oamData_4e37
	ld e,:bank16.oamData_4e37
	ld bc,$3038

;;
; @param	bc	Sprite offset
; @param	hl	OAM data to load
cutscene_resetOamWithData:
	xor a
	ldh (<hOamTail),a
	jp addSpritesFromBankToOam_withOffset

;;
; @param	hl	List of tiles (see below for example of format)
cutscene_replaceListOfTiles:
	ld b,(hl)
	inc hl
@loop:
	ld c,(hl)
	inc hl
	ldi a,(hl)
	push bc
	push hl
	call setTile
	pop hl
	pop bc
	dec b
	jr nz,@loop
	ret

blackTowerEscapeCutscene_doorBlockReplacement:
	.db $04     ; # of entries
	.db $44 $83 ; Position, New Tile Value
	.db $45 $83
	.db $54 $83
	.db $55 $83

blackTowerEscapeCutscene_doorOpenReplacement:
	.db $04
	.db $44 $df
	.db $45 $ed
	.db $54 $80
	.db $55 $80

;;
func_60e0:
	ld hl,wLinkHealth
	ld (hl),$04
	ld l,<wInventoryB
	ldi a,(hl)
	ld b,(hl)
	ld hl,wcde3
	ldi (hl),a
	ld (hl),b
	jp disableActiveRing

;;
func_60f1:
	ld hl,wLinkMaxHealth
	ldd a,(hl)
	ld (hl),a
	ld hl,wcde3
	ldi a,(hl)
	ld b,(hl)
	ld hl,wInventoryB
	ldi (hl),a
	ld (hl),b
	jp enableActiveRing
