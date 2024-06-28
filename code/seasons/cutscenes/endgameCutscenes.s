; TODO: Some code in this file is shared with "code/ages/cutscenes/bank10.s".

;;
; CUTSCENE_S_DIN_CRYSTAL_DESCENDING
endgameCutsceneHandler_09:
	ld de,$cbc1
	ld a,(de)
	rst_jumpTable
	.dw endgameCutsceneHandler_09_stage0
	.dw endgameCutsceneHandler_09_stage1

endgameCutsceneHandler_09_stage0:
	call updateStatusBar
	call endgameCutsceneHandler_09_stage0_body
	call updateAllObjects
	jp checkEnemyAndPartCollisionsIfTextInactive

endgameCutsceneHandler_09_stage0_body:
	ld de,$cbc2
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
	.dw @state17
	.dw @state18
	.dw @state19
	.dw @state1A
	.dw @state1B
	.dw @state1C
	.dw @state1D
	.dw @state1E
	.dw @state1F
	.dw @state20
	.dw @state21
	.dw @state22
	.dw @state23
	.dw @state24
	.dw @state25
	.dw @state26
	.dw @state27

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld b,$20
	ld hl,$cfc0
	call clearMemory
	call incCbc2
	xor a
	ld bc,$0790
	call disableLcdAndLoadRoom_body
	ld a,$0d
	call playSound
	call clearAllParentItems
	call dropLinkHeldItem
	ld c,$00
@state0Func0:
	call getFreeInteractionSlot
	jr nz,+
	ld a,INTERACID_S_DIN
	ld (wInteractionIDToLoadExtraGfx),a
	ldi (hl),a
	ld (hl),c
	ld (wLoadedTreeGfxIndex),a
+
	ld a,c
	ld hl,w1Link.enabled
	ld (hl),$03
	ld de,@state0Table_03_55f3
	call addDoubleIndexToDe
	ld a,(de)
	inc de
	ld l,<w1Link.yh
	ldi (hl),a
	inc l
	ld a,(de)
	ldi (hl),a
	ld l,<w1Link.direction
	ld (hl),$03
	ld a,c
	ld bc,$0050
	or a
	jr z,+
	ld bc,$3050
+
	ld hl,hCameraY
	ld (hl),b
	ld hl,hCameraX
	ld (hl),c
	ld a,$80
	ld (wDisabledObjects),a
	ld a,$02
	call loadGfxRegisterStateIndex
	jp fadeinFromWhiteToRoom
@state0Table_03_55f3:
	.db $99 $c8
	.db $99 $b8

@state1:
	ld hl,wccd8
	ld (hl),$ff
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,($cfdf)
	or a
	ret z
	call incCbc2
	ld bc,TX_3d00
	jp showText

@state2:
	call retIfTextIsActive
	call incCbc2
	jp fastFadeoutToWhite

@state3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$3c
	inc l
	ld (hl),$00
	jr @state7Func0

@state4:
	call seasonsFunc_03_6462
	ret nz
	call incCbc2
	ld a,SND_RESTORE
	call playSound
	jp fadeoutToWhite

@state5:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
	ld a,$00
	call seasonsFunc_03_644c
	ld hl,$cbb3
	ld (hl),$3c
	jp fadeinFromWhite

@state6:
	call seasonsFunc_03_6462
	ret nz
	call incCbc2
	jp fastFadeoutToWhite

@state7:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
@state7Func0:
	call clearDynamicInteractions
	ld hl,$cbb3
	ld (hl),$3c
	inc l
	ld a,(hl)
	ld hl,@state7Table0
	rst_addDoubleIndex
	ld c,(hl)
	inc hl
	ld b,(hl)
	ld a,$03
	call disableLcdAndLoadRoom_body
	call fastFadeinFromWhite
	ld hl,$cbb4
	ld a,(hl)
	ld b,a
	inc (hl)
	cp $04
	jr nc,+
	ld c,$04
	push bc
	ld a,$02
	call loadGfxRegisterStateIndex
	call resetCamera
	pop bc
	jr ++
+
	ld hl,$cbb3
	ld (hl),$3c
	push bc
	ld c,$01
	call @state0Func0
	pop bc
	ld c,$08
	call checkIsLinkedGame
	ld b,$ff
	jr z,++
	ld c,$0d
++
	ld hl,$cbc2
	ld (hl),c
	jp seasonsFunc_03_6405
@state7Table0:
	.db $e7 $00
	.db $54 $00
	.db $d1 $00
	.db $5e $00
	.db $90 $07

@state8:
	ld e,$3c
	ld bc,TX_3d01
	jr @stateDFunc0

@state9:
	call seasonsFunc_03_645a
	ret nz
	call incCbc2
	jp fadeoutToWhite

@stateA:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$3c
	ld a,$ff
	ld (wTilesetAnimation),a
	call disableLcd
	ld a,GFXH_LINK_WITH_ORACLE_END_SCENE
	call loadGfxHeader
	ld a,$9d
	call loadPaletteHeader
	call cutscene_clearObjects
	call endgameCutsceneHandler_09_stage1_body@seasonsFunc_03_5ab0
	ld a,$04
	call loadGfxRegisterStateIndex
	jp fadeinFromWhite

@stateB:
	call endgameCutsceneHandler_09_stage1_body@seasonsFunc_03_5ab0
	call seasonsFunc_03_6462
	ret nz
	call incCbc2
	ld hl,wMenuDisabled
	ld (hl),$01
	ld hl,$cbb3
	ld (hl),$3c
	ld bc,TX_3d02
@stateBFunc0:
	ld a,$01
	ld (wTextboxFlags),a
	jp showText

@stateC:
	call endgameCutsceneHandler_09_stage1_body@seasonsFunc_03_5ab0
	call seasonsFunc_03_645a
	ret nz
	call seasonsFunc_03_646a
	ld a,$01
	ld ($cbc1),a
	call disableActiveRing
	jp fadeoutToWhite

@stateD:
	ld e,$3c
	ld bc,TX_4f00
@stateDFunc0:
	call seasonsFunc_03_6462
	ret nz
	call incCbc2
	ld a,e
	ld ($cbb3),a
	jp showText

@stateE:
	call seasonsFunc_03_645a
	ret nz
	xor a
	ld ($cbb3),a
	dec a
	ld ($cbba),a
	ld a,SND_LIGHTNING
	call playSound
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	jp incCbc2

@stateF:
	ld hl,$cbb3
	ld b,$02
	call flashScreen
	ret z
	call incCbc2
	xor a
	ld bc,$059a
	call disableLcdAndLoadRoom_body
	ld a,$ac
	call loadPaletteHeader
	call hideStatusBar
	call clearFadingPalettes2
	ld b,$06
-
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_TWINROVA_FLAME
	inc l
	dec b
	ld (hl),b
	jr nz,-
+
	ld hl,$cbb3
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
	ret

@state10:
	call decCbb3
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$28
	ld a,$04
	ld (wTextboxFlags),a
	ld bc,TX_4f01
	jp showText

@state11:
	call seasonsFunc_03_645a
	ret nz
	call incCbc2
	ld a,$20
	ld hl,$cbb3
	ldi (hl),a
	xor a
	ld (hl),a
	ret

@state12:
	call seasonsFunc_03_6462
	ret nz
	ld hl,$cbb3
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
	ld hl,@state12Table0
	rst_addAToHl
	ld a,(hl)
	or a
	ld b,a
	jr nz,+
	call fadeinFromBlack
	ld a,$01
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	ld hl,$cbb3
	ld (hl),$3c
	ld a,MUS_DISASTER
	call playSound
	jp incCbc2
+
	call fastFadeinFromBlack
	ld a,b
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	xor a
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	ret
@state12Table0:
	.db $10 $40
	.db $80 $28
	.db $06 $00

@state13:
	ld e,$28
	ld bc,TX_4f02
	call @state13Func0
	jp @stateDFunc0
@state13Func0:
	ld a,$08
	ld (wTextboxFlags),a
	ld a,$03
	ld (wTextboxPosition),a
	ret

@state14:
	ld e,$28
	ld bc,TX_4f03
-
	call seasonsFunc_03_645a
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),e
	call @state13Func0
	jp showText

@state15:
	ld e,$3c
	ld bc,TX_4f04
	jr -

@state16:
	ld e,$b4
@state16Func0:
	call seasonsFunc_03_645a
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),e
	ret

@state17:
	ld hl,wGfxRegs1.SCY
	ldh a,(<hCameraY)
	ldi (hl),a
	ldh a,(<hCameraX)
	ldi (hl),a
	ld hl,@state17Table0
	ld de,wGfxRegs1.SCY
	call seasonsFunc_03_79cd
	inc de
	call seasonsFunc_03_79cd
	call seasonsFunc_03_5d00
	call decCbb3
	ret nz
	dec a
	ld ($cbba),a
	ld a,SND_LIGHTNING
	call playSound
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	jp incCbc2
@state17Table0:
	.db $ff $01
	.db $00 $01
	.db $00 $00
	.db $ff $00

@state18:
	ld hl,$cbb3
	ld b,$01
	call flashScreen
	ret z
	call incCbc2
	ld hl,$cbb3
	ld (hl),$3c
	call clearDynamicInteractions
	call clearOam
	call showStatusBar
	xor a
	ld bc,ROOM_SEASONS_790
	call disableLcdAndLoadRoom_body
	ld c,$01
	jp @state0Func0

@state19:
	call decCbb3
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$1e
	ld bc,TX_3d17
	jp showText

@state1A:
	call seasonsFunc_03_645a
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$1e
	ld bc,TX_4f09
	jp showText

@state1B:
	call seasonsFunc_03_645a
	ret nz
	call incCbc2
	ld c,$40
	ld a,TREASURE_HEART_REFILL
	call giveTreasure
	ld a,SPECIALOBJECTID_LINK_CUTSCENE
	call setLinkIDOverride
	ld l,<w1Link.subid
	ld (hl),$07
	ld hl,$cbb3
	ld (hl),$5a
	ld a,MUS_PRECREDITS
	jp playSound

@state1C:
	call decCbb3
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$b4
	ld bc,$90bd
	ld a,$ff
	jp createEnergySwirlGoingOut

@state1D:
	call decCbb3
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$3c
	jp fadeoutToWhite

@state1E:
	call seasonsFunc_03_6462
	ret nz
	call incCbc2
	call disableLcd
	call clearOam
	call clearDynamicInteractions
	call refreshObjectGfx
	call hideStatusBar
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld hl,w2TilesetBgPalettes+$10
	ld b,$08
	ld a,$ff
	call fillMemory
	xor a
	ld ($ff00+R_SVBK),a
	ld a,$07
	ldh (<hDirtyBgPalettes),a
	ld b,$02
-
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_TWINROVA_FLAME
	inc l
	ld a,$05
	add b
	ld (hl),a
	dec b
	jr nz,-
+
	ld a,$02
	ld (wOpenedMenuType),a
	call seasonsFunc_03_7a6b
	ld a,$02
	call seasonsFunc_03_7a88
	ld hl,$cbb3
	ld (hl),$1e
	ld a,$04
	call loadGfxRegisterStateIndex
	ld a,$10
	ldh (<hCameraY),a
	ld (wDeleteEnergyBeads),a
	xor a
	ldh (<hCameraX),a
	ld a,$00
	ld (wScrollMode),a
	ld bc,TX_4f05
	jp showText

@state1F:
	call seasonsFunc_03_645a
	ret nz
	call incCbc2
	ld b,$02
@state1FFunc0:
	call fadeinFromWhite
	ld a,b
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	xor a
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	ld hl,$cbb3
	ld (hl),$3c
	ret

@state20:
	ld e,$1e
	ld bc,TX_4f06
	jp @stateDFunc0

@state21:
	call seasonsFunc_03_645a
	ret nz
	call incCbc2
	ld b,$14
	jp @state1FFunc0

@state22:
	ld e,$1e
	ld bc,TX_4f07
	jp @stateDFunc0

@state23:
	ld e,$3c
	jp @state16Func0

@state24:
	call decCbb3
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$f0
	ld a,$ff
	ld bc,$4850
	jp createEnergySwirlGoingOut

@state25:
	call decCbb3
	ret nz
	ld hl,$cbb3
	ld (hl),$5a
	call fadeoutToWhite
	ld a,$fc
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	jp incCbc2

@state26:
	call seasonsFunc_03_6462
	ret nz
	call incCbc2
	call clearDynamicInteractions
	call clearParts
	call clearOam
	ld hl,$cbb3
	ld (hl),$3c
	ld bc,TX_4f08
	jp showTextNonExitable

@state27:
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
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld hl,wWarpDestGroup
	ld a,$80|>ROOM_SEASONS_59d
	ldi (hl),a
	ld a,<ROOM_SEASONS_59d
	ldi (hl),a
	ld a,$0f
	ldi (hl),a
	ld a,$57
	ldi (hl),a
	ld (hl),$03
	ret

endgameCutsceneHandler_09_stage1:
	call endgameCutsceneHandler_09_stage1_body
	jp updateAllObjects

endgameCutsceneHandler_09_stage1_body:
	ld de,$cbc2
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
	call @seasonsFunc_03_5ab0
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$3c
	call disableLcd
	call clearOam
	ld a,GFXH_LINK_WITH_ORACLE_AND_TWINROVA_END_SCENE
	call loadGfxHeader
	ld a,PALH_SEASONS_9e
	call loadPaletteHeader
	ld a,$04
	call loadGfxRegisterStateIndex
	ld a,MUS_DISASTER
	call playSound
	jp fadeinFromWhite

@state1:
	ld a,$01
	ld (wTextboxFlags),a
	ld a,$3c
	ld bc,TX_3d03
	jp endgameCutsceneHandler_09_stage0_body@stateDFunc0

@state2:
	call seasonsFunc_03_645a
	ret nz
	call incCbc2
	ld hl,$cbb5
	ld (hl),$d0
--
	ld hl,seasonsOamData_03_6472
-
	ld b,$30
	ld de,$cbb5
	ld a,(de)
	ld c,a
	jr +

@seasonsFunc_03_5aa2:
	ld hl,oamData_15_4da3
	ld e,:oamData_15_4da3
	ld bc,$3038
	xor a
	ldh (<hOamTail),a
	jp addSpritesFromBankToOam_withOffset

@seasonsFunc_03_5ab0:
	ld hl,seasonsOamData_03_65a4
	ld bc,$3038
+
	xor a
	ldh (<hOamTail),a
	jp addSpritesToOam_withOffset

@state3:
	ld hl,$cbb5
	inc (hl)
	jr nz,--
	call clearOam
	ld a,UNCMP_GFXH_0a
	call loadUncompressedGfxHeader
	ld hl,$cbb3
	ld (hl),$1e
	jp incCbc2

@state4:
	call decCbb3
	ret nz
	call incCbc2
	ld hl,$cbb5
	ld (hl),$d0
@state4Func0:
	ld hl,seasonsOamData_03_650b
	jr -

@state5:
	call @state4Func0
	ld hl,$cbb5
	dec (hl)
	ld a,(hl)
	sub $a0
	ret nz
	ld (wScreenOffsetY),a
	ld (wScreenOffsetX),a
	ld a,$1e
	ld ($cbb3),a
	ld (wOpenedMenuType),a
	jp incCbc2

@state6:
	call @state4Func0
	call decCbb3
	ret nz
	ld hl,$cbb3
	ld (hl),$14
	ld bc,TX_3d04
	call endgameCutsceneHandler_09_stage0_body@stateBFunc0
	jp incCbc2

@state7:
	call @state4Func0
	call seasonsFunc_03_645a
	ret nz
	xor a
	ld (wOpenedMenuType),a
	dec a
	ld ($cbba),a
	ld a,SND_LIGHTNING
	call playSound
	jp incCbc2

@state8:
	call @state4Func0
	ld hl,$cbb3
	ld b,$02
	call flashScreen
	ret z
	call incCbc2
	ld hl,$cbb3
	ld (hl),$1e
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
	ld a,GFXH_TWINROVA_CLOSEUP
	call loadGfxHeader
	ld a,PALH_SEASONS_9c
	call loadPaletteHeader
	ld a,$04
	call loadGfxRegisterStateIndex
	ld a,SND_LIGHTNING
	call playSound
	jp clearPaletteFadeVariablesAndRefreshPalettes

@state9:
	call decCbb3
	ret nz
	ld a,CUTSCENE_S_CREDITS
	ld (wCutsceneIndex),a
	call seasonsFunc_03_646a
	ld hl,$cf00
	ld bc,$00c0
	call clearMemoryBc
	ld hl,$ce00
	ld bc,$00c0
	call clearMemoryBc
	ldh (<hCameraY),a
	ldh (<hCameraX),a
	ld hl,$cbb3
	ld (hl),$3c
	ld a,$03
	jp fadeoutToBlackWithDelay

;;
; CUTSCENE_S_ROOM_OF_RITES_COLLAPSE
endgameCutsceneHandler_0f:
	ld de,$cbc1
	ld a,(de)
	rst_jumpTable
	.dw endgameCutsceneHandler_0f_stage0
	.dw endgameCutsceneHandler_0f_stage1

endgameCutsceneHandler_0f_stage0:
	call updateStatusBar
	call endgameCutsceneHandler_0f_stage0_body
	jp updateAllObjects

endgameCutsceneHandler_0f_stage0_body:
	ld de,$cbc2
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

@state0:
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
	ld hl,$cbb3
	ld (hl),$0a
	ret

@state1:
	call decCbb3
	ret nz
	ld hl,$cbb3
	ld (hl),$1e
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	jp incCbc2

@state2:
	call seasonsFunc_03_5cfb
	call decCbb3
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$96
	jp seasonsFunc_03_5d0b

@state3:
	call seasonsFunc_03_5cfb
	call decCbb3
	ret nz
	call incCbc2
	ld a,SNDCTRL_STOPSFX
	call playSound
	ld hl,$cbb3
	ld (hl),$3c
	ld bc,TX_3d0e
	jp showText

@state4:
	call seasonsFunc_03_645a
	ret nz
	call incCbc2
	ld a,MUS_DISASTER
	call playSound
	ld hl,$cbb3
	ld (hl),$3c
	jp seasonsFunc_03_5d0b

@state5:
	call seasonsFunc_03_5cfb
	call decCbb3
	ret nz
	ld hl,$cbb3
	ld (hl),$5a
	jp incCbc2

@state6:
	call seasonsFunc_03_5cfb
	call decCbb3
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$3c
	ld a,SNDCTRL_STOPSFX
	jp playSound

@state7:
	call decCbb3
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$3c
	ld bc,TX_3d0f
	jp showText

@state8:
	call seasonsFunc_03_645a
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$2c
	inc hl
	ld (hl),$01
	ld b,$03
	jp seasonsFunc_03_5d12

@state9:
	ld hl,$cbb3
	call decHlRef16WithCap
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$3c
	ld bc,TX_3d10
	jp showText

@stateA:
	ld e,$1e
	jp endgameCutsceneHandler_09_stage0_body@state16Func0

@stateB:
	call seasonsFunc_03_5cfb
	call decCbb3
	ret nz
	call incCbc2
	call seasonsFunc_03_5d0b
	ld a,$8c
	ld ($cbb3),a
	ld a,$ff
	ld bc,$4478
	jp createEnergySwirlGoingOut

@stateC:
	call seasonsFunc_03_5cfb
	call decCbb3
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$3c
	jp seasonsFunc_03_5d0b

@stateD:
	call seasonsFunc_03_5cfb
	call decCbb3
	ret nz
	call incCbc1
	inc l
	xor a
	ld (hl),a
	ld a,$03
	jp fadeoutToWhiteWithDelay

seasonsFunc_03_5cfb:
	ld a,$04
	call setScreenShakeCounter

seasonsFunc_03_5d00:
	ld a,(wFrameCounter)
	and $0f
	ld a,SND_RUMBLE2
	jp z,playSound
	ret

seasonsFunc_03_5d0b:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_48
	ret

seasonsFunc_03_5d12:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_MAKU_LEAF
	inc l
	ld (hl),$00
	inc l
	ld (hl),b
	ret

endgameCutsceneHandler_0f_stage1:
	call updateStatusBar
	call endgameCutsceneHandler_0f_stage1_body
	jp updateAllObjects

endgameCutsceneHandler_0f_stage1_body:
	ld de,$cbc2
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

@state0:
	call seasonsFunc_03_5cfb
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
	xor a
	ld bc,ROOM_SEASONS_22b
	call disableLcdAndLoadRoom_body
	call refreshObjectGfx
	ld b,$0c
	call getEntryFromObjectTable1
	ld d,h
	ld e,l
	call parseGivenObjectData
	ld a,$04
	ld b,$02
	call seasonsFunc_03_642e
	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	ld a,$02
	call loadGfxRegisterStateIndex
	ld hl,$cbb3
	ld (hl),$3c
	jp fadeinFromWhiteToRoom

@state1:
	call seasonsFunc_03_6462
	ret nz
	call incCbc2
	ld a,$3c
	ld ($cbb3),a
	ld a,$64
	ld bc,$5850
	jp createEnergySwirlGoingIn

@state2:
	call decCbb3
	ret nz
	xor a
	ld ($cbb3),a
	dec a
	ld ($cbba),a
	jp incCbc2

@state3:
	ld hl,$cbb3
	ld b,$01
	call flashScreen
	ret z
	call incCbc2
	ld hl,$cbb3
	ld (hl),$3c
	ld a,$01
	ld ($cfc0),a
	ld a,$03
	jp fadeinFromWhiteWithDelay

@state4:
	call seasonsFunc_03_6462
	ret nz
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	ld a,MUS_CREDITS_1
	call playSound
	ld hl,$cbb3
	ld (hl),$3c
	jp incCbc2

@state5:
	call decCbb3
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$2c
	inc hl
	ld (hl),$01
	ld b,$00
	jp seasonsFunc_03_5d12

@state6:
	ld hl,$cbb3
	call decHlRef16WithCap
	ret nz
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	ld hl,$cbb3
	ld (hl),$3c
	ld hl,$cfc0
	ld (hl),$02
	jp incCbc2

@state7:
	ld a,($cfc0)
	cp $09
	ret nz
	call incCbc2
	ld a,$03
	jp fadeoutToWhiteWithDelay

@state8:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
	call disableLcd
	call clearScreenVariablesAndWramBank1
	call hideStatusBar
	ld a,GFXH_SCENE_CREDITS_MAKUTREE
	call loadGfxHeader
	ld a,PALH_SEASONS_ad
	call loadPaletteHeader
	ld hl,$cbb3
	ld (hl),$f0
	ld a,$04
	call loadGfxRegisterStateIndex
	call endgameCutsceneHandler_09_stage1_body@seasonsFunc_03_5aa2
	ld a,$03
	jp fadeinFromWhiteWithDelay

@state9:
	call endgameCutsceneHandler_09_stage1_body@seasonsFunc_03_5aa2
	call seasonsFunc_03_6462
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$10
	ld a,$03
	jp fadeoutToBlackWithDelay

@stateA:
	call endgameCutsceneHandler_09_stage1_body@seasonsFunc_03_5aa2
	call seasonsFunc_03_6462
	ret nz
	ld a,CUTSCENE_S_CREDITS
	ld (wCutsceneIndex),a
	call seasonsFunc_03_646a
	ld hl,$cf00
	ld bc,$00c0
	call clearMemoryBc
	ld hl,$ce00
	ld bc,$00c0
	call clearMemoryBc
	xor a
	ldh (<hCameraY),a
	ldh (<hCameraX),a
	ld hl,$cbb3
	ld (hl),$3c
	ld a,SNDCTRL_MEDIUM_FADEOUT
	jp playSound

;;
; CUTSCENE_S_CREDITS
endgameCutsceneHandler_0a:
	call endgameCutsceneHandler_0a_body
	jp func_3539

endgameCutsceneHandler_0a_body:
	ld de,$cbc1
	ld a,(de)
	rst_jumpTable
	.dw endgameCutsceneHandler_0a_stage0
	.dw endgameCutsceneHandler_0a_stage1
	.dw endgameCutsceneHandler_0a_stage2
	.dw endgameCutsceneHandler_0a_stage3

endgameCutsceneHandler_0a_stage0:
	ld de,$cbc2
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call seasonsFunc_03_6462
	ret nz
	call seasonsFunc_03_66dc
	call incCbc2
	call clearOam
	ld hl,$cbb3
	ld (hl),$b4
	inc hl
	ld (hl),$00
	ld hl,wGfxRegs1.LCDC
	set 3,(hl)
	ld a,MUS_CREDITS_2
	jp playSound

@state1:
	ld hl,$cbb3
	call decHlRef16WithCap
	ret nz
	call incCbc2
	ld hl,$cbb3
	ld (hl),$48
	inc hl
	ld (hl),$03
	ld a,PALH_04
	call loadPaletteHeader
	ld a,$06
	jp fadeinFromBlackWithDelay

@state2:
	ld hl,$cbb3
	call decHlRef16WithCap
	ret nz
	call incCbc1
	inc l
	ld (hl),a
	ld b,$04
	call checkIsLinkedGame
	jr z,+
	ld b,$08
+
	ld hl,$cbb4
	ld (hl),b
	jp fadeoutToWhite

endgameCutsceneHandler_0a_stage1:
	ld de,$cbc2
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
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
	ld a,($cbb4)
	sub $04
	ld hl,@state0Table0
	rst_addDoubleIndex
	ld b,(hl)
	inc hl
	ld a,(hl)
	or a
	jr z,++
	ld c,a
	ld a,$00
	call forceLoadRoom
	ld b,$2d
	ld a,($cbb4)
	cp $04
	jr nz,+
	ld b,UNCMP_GFXH_0f
+
	ld a,b
	call loadUncompressedGfxHeader
++
	ld a,($cbb4)
	sub $04
	add a
	add GFXH_CREDITS_SCENE1
	call loadGfxHeader
	ld a,PALH_0f
	call loadPaletteHeader
	call reloadObjectGfx
	call checkIsLinkedGame
	jr nz,+
	ld a,($cbb4)
	ld b,$10
	ld c,$00
	cp $05
	jr nz,++
	ld b,$50
	ld c,$0e
	jr ++
+
	ld a,($cbb4)
	ld b,$10
	ld c,$00
	cp $0b
	jr nz,++
	ld b,$ae
	ld c,$ff
++
	ld a,b
	push bc
	call loadPaletteHeader
	pop bc
	ld a,c
	ld (wTilesetAnimation),a
	call loadAnimationData
	ld a,$01
	ld (wScrollMode),a
	xor a
	ldh (<hCameraX),a
	ld b,$20
	ld hl,$cfc0
	call clearMemory
	ld hl,$cbb3
	ld (hl),$f0
	inc l
	ld b,(hl)
	call seasonsFunc_03_6405
	ld a,$04
	call loadGfxRegisterStateIndex
	jp fadeinFromWhite

@state0Table0:
	dwbe ROOM_SEASONS_0c6
	dwbe ROOM_SEASONS_12b
	dwbe ROOM_SEASONS_0b6
	dwbe ROOM_SEASONS_0d6
	dwbe $0000
	dwbe ROOM_SEASONS_12b
	dwbe $0000
	dwbe $0000

@state1:
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

@state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
	call disableLcd
	call clearWramBank1
	ld a,($cbb4)
	sub $04
	add a
	add GFXH_CREDITS_IMAGE1
	call loadGfxHeader
	ld hl,$cbb3
	ld (hl),$5a
	inc l
	ld a,(hl)
	add $9d
	call loadPaletteHeader
	ld a,$04
	call loadGfxRegisterStateIndex
	ld a,($cbb4)
	sub $04
	ld hl,@state2Table0
	rst_addAToHl
	ld a,(hl)
	ld (wGfxRegs1.SCX),a
	ld a,$10
	ldh (<hCameraX),a
	jp fadeinFromWhite
@state2Table0:
	.db $00 $d0
	.db $00 $d0
	.db $00 $d0
	.db $00 $d0

@state3:
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
	ld a,($cbb4)
	sub $04
	ldi (hl),a
	ld (hl),$00
	ret

@state4:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	xor a
	ldh (<hOamTail),a
	ld a,($cfde)
	or a
	ret z
	ld b,$07
	call checkIsLinkedGame
	jr z,+
	ld b,$0b
+
	ld hl,$cbb4
	ld a,(hl)
	cp b
	jr nc,+
	inc (hl)
	xor a
	ld ($cbc2),a
	jr ++
+
	call seasonsFunc_03_646a
	call enableActiveRing
	ld a,$02
	ld ($cbc1),a
	ld hl,wLinkMaxHealth
	ldd a,(hl)
	ld (hl),a ; [wLinkHealth]
	xor a
	ld l,<wInventoryB
	ldi (hl),a
	ld (hl),a ; [wInventoryA]
	ld l,<wActiveRing
	ld (hl),$ff
++
	jp fadeoutToWhite

endgameCutsceneHandler_0a_stage2:
	xor a
	ldh (<hOamTail),a
	ld de,$cbc2
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

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
	call disableLcd
	call clearDynamicInteractions
	call clearOam
	xor a
	ld ($cfde),a
	ld a,GFXH_CREDITS_SCROLL
	call loadGfxHeader
	ld a,PALH_SEASONS_a0
	call loadPaletteHeader
	ld a,$09
	call loadGfxRegisterStateIndex
	call fadeinFromWhite
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_CREDITS_TEXT_VERTICAL
	ld l,Interaction.yh
	ld (hl),$e8
	inc l
	inc l
	ld (hl),$50
	ret

@state1:
	ld a,($cfde)
	or a
	ret z
	ld hl,$cbb3
	ld (hl),$e0
	inc hl
	ld (hl),$01
	jp incCbc2

@state2:
	ld hl,$cbb3
	call decHlRef16WithCap
	ret nz
	call checkIsLinkedGame
	jr nz,+
	call seasonsFunc_03_646a
	ld a,$03
	ld ($cbc1),a
	ld a,$04
	jp fadeoutToWhiteWithDelay
+
	ld a,$04
	ld ($cbb3),a
	ld a,(wGfxRegs1.SCY)
	ldh (<hCameraY),a
	ld a,UNCMP_GFXH_01
	call loadUncompressedGfxHeader
	ld a,PALH_0b
	call loadPaletteHeader
	ld b,$03
-
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_INTRO_SPRITES_1
	inc l
	ld (hl),$09
	inc l
	dec b
	ld (hl),b
	jr nz,-
+
	jp incCbc2

@state3:
	ld a,(wGfxRegs1.SCY)
	or a
	jr nz,+
	ld a,$78
	ld ($cbb3),a
	jp incCbc2
+
	call decCbb3
	ret nz
	ld (hl),$04
	ld hl,wGfxRegs1.SCY
	dec (hl)
	ld a,(hl)
	ldh (<hCameraY),a
	ret

@state4:
	call decCbb3
	ret nz
	ld a,$ff
	ld ($cbba),a
	jp incCbc2

@state5:
	ld hl,$cbb3
	ld b,$01
	call flashScreen
	ret z
	call disableLcd
	ld a,GFXH_CREDITS_LINKED_WAVING_GOODBYE
	call loadGfxHeader
	ld a,PALH_SEASONS_9f
	call loadPaletteHeader
	call clearDynamicInteractions
	ld b,$03
-
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_cf
	inc l
	dec b
	ld (hl),b
	jr nz,-
+
	ld a,$04
	call loadGfxRegisterStateIndex
	ld a,$04
	call fadeinFromWhiteWithDelay
	call incCbc2
	ld a,$f0
	ld ($cbb3),a

@seasonsFunc_03_616f:
	xor a
	ldh (<hOamTail),a
	ld a,(wGfxRegs1.SCY)
	cp $60
	jr nc,+
	cpl
	inc a
	ld b,a
	ld a,(wFrameCounter)
	and $01
	jr nz,+
	ld c,a
	ld hl,seasonsOamData_03_6641
	call addSpritesToOam_withOffset
+
	ld a,(wGfxRegs1.SCY)
	cpl
	inc a
	ld b,$c7
	add b
	ld b,a
	ld c,$38
	ld hl,seasonsOamData_03_668a
	push bc
	call addSpritesToOam_withOffset
	pop bc
	ld a,(wGfxRegs1.SCY)
	cp $60
	ret c
	ld hl,seasonsOamData_03_66bf
	jp addSpritesToOam_withOffset

@state6:
	call @seasonsFunc_03_616f
	call seasonsFunc_03_6462
	ret nz
	ld a,$04
	ld ($cbb3),a
	jp incCbc2

@state7:
	ld a,(wGfxRegs1.SCY)
	cp $98
	jr nz,+
	ld a,$f0
	ld ($cbb3),a
	call incCbc2
	jr ++
+
	call decCbb3
	jr nz,++
	ld (hl),$04
	ld hl,wGfxRegs1.SCY
	inc (hl)
	ld a,(hl)
	ldh (<hCameraY),a
	cp $60
	jr nz,++
	call clearDynamicInteractions
	ld a,UNCMP_GFXH_2c
	call loadUncompressedGfxHeader
++
	jp @seasonsFunc_03_616f

@state8:
	call @seasonsFunc_03_616f
	call decCbb3
	ret nz
	call seasonsFunc_03_646a
	ld a,$03
	ld ($cbc1),a
	ld a,$04
	jp fadeoutToWhiteWithDelay

endgameCutsceneHandler_0a_stage3:
	ld de,$cbc2
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

@state0:
	call checkIsLinkedGame
	call nz,endgameCutsceneHandler_0a_stage2@seasonsFunc_03_616f
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call disableLcd
	call incCbc2
	call seasonsFunc_03_66ed
	call clearDynamicInteractions
	call clearOam
	call checkIsLinkedGame
	jp z,@state0Func0
	ld a,GFXH_CREDITS_LINKED_THE_END
	call loadGfxHeader
	ld a,$aa
	call loadPaletteHeader
	ld hl,objectData.objectData5887
	call parseGivenObjectData
	jr +
@state0Func0:
	ld a,GFXH_CREDITS_THE_END
	call loadGfxHeader
	ld a,PALH_SEASONS_a9
	call loadPaletteHeader
+
	ld a,$04
	call loadGfxRegisterStateIndex
	xor a
	ld hl,hCameraY
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld hl,$cbb3
	ld (hl),$f0
	ld (hl),a
	ld a,SNDCTRL_MEDIUM_FADEOUT
	call playSound
	ld a,$04
	jp fadeinFromWhiteWithDelay

@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
@state1Func0:
	call checkIsLinkedGame
	ret z
	ld hl,$cbb4
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret
+
	ld a,SND_WAVE
	call playSound
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@state1Table0
	rst_addAToHl
	ld a,(hl)
	ld ($cbb4),a
	ret
@state1Table0:
	.db $a0 $c8
	.db $10 $f0

@state2:
	call @state1Func0
	call decCbb3
	ret nz
	call incCbc2

@state3:
	call @state1Func0
	ld hl,wFileIsLinkedGame
	ldi a,(hl)
	add (hl)
	cp $02
	ret z
	ld a,(wKeysJustPressed)
	and (BTN_START|BTN_A|BTN_B)
	ret z
	call incCbc2
	jp fadeoutToWhite

@state4:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCbc2
	call disableLcd
	call bank3.generateGameTransferSecret
	ld a,$ff
	ld ($cbba),a
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w7d800
	ld ($ff00+R_SVBK),a
	ld hl,w7SecretText1
	ld de,w7d800
	ld bc,$1800
-
	ldi a,(hl)
	call copyTextCharacterGfx
	dec b
	jr nz,-
	pop af
	ld ($ff00+R_SVBK),a
	ld a,GFXH_SECRET_FOR_LINKED_GAME
	call loadGfxHeader
	ld a,UNCMP_GFXH_2b
	call loadUncompressedGfxHeader
	ld a,PALH_05
	call loadPaletteHeader
	call checkIsLinkedGame
	ld a,GFXH_HEROS_SECRET_TEXT
	call nz,loadGfxHeader
	call clearDynamicInteractions
	call clearOam
	ld a,$04
	call loadGfxRegisterStateIndex
	ld hl,$cbb3
	ld (hl),$3c
	call fileSelect_redrawDecorations
	jp fadeinFromWhite

@state5:
	call fileSelect_redrawDecorations
	call seasonsFunc_03_6462
	ret nz
	ld hl,$cbb3
	ld b,$3c
	call checkIsLinkedGame
	jr z,+
	ld b,$b4
+
	ld (hl),b
	jp incCbc2

@state6:
	call fileSelect_redrawDecorations
	call decCbb3
	ret nz
	call checkIsLinkedGame
	jr nz,+
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_d1
	xor a
	ld ($cfde),a
+
	jp incCbc2

@state7:
	call fileSelect_redrawDecorations
	call checkIsLinkedGame
	jr z,+
	ld a,(wKeysJustPressed)
	and BTN_A
	jr nz,++
	ret
+
	ld a,($cfde)
	or a
	ret z
++
	call incCbc2
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	jp fadeoutToWhite

@state8:
	call fileSelect_redrawDecorations
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call checkIsLinkedGame
	jp nz,resetGame
	call disableLcd
	call clearOam
	call incCbc2
	ld a,GFXH_TO_BE_CONTINUED
	call loadGfxHeader
	ld a,PALH_SEASONS_8f
	call loadPaletteHeader
	call fadeinFromWhite
	ld a,$04
	jp loadGfxRegisterStateIndex

@state9:
	call @state9Func0
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,$cbb3
	ld (hl),$b4
	jp incCbc2
@state9Func0:
	ld hl,oamData_15_4e0c
	ld e,:oamData_15_4e0c
	ld bc,$3038
	xor a
	ldh (<hOamTail),a
	jp addSpritesFromBankToOam_withOffset

@stateA:
	call @state9Func0
	ld hl,$cbb3
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret
+
	ld a,(wKeysJustPressed)
	and BTN_A
	ret z
	call incCbc2
	jp fadeoutToWhite

@stateB:
	call @state9Func0
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	jp resetGame

;;
; Similar to ages' version of this function
;
disableLcdAndLoadRoom_body:
	ld (wRoomStateModifier),a
	ld a,b
	ld (wActiveGroup),a
	ld a,c
	ld (wActiveRoom),a
	call disableLcd
	call clearScreenVariablesAndWramBank1
	ld hl,wLinkInAir
	ld b,wcce9-wLinkInAir
	call clearMemory

seasonsFunc_03_63eb:
	call initializeVramMaps
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics
	call func_131f
	ld a,$01
	ld (wScrollMode),a
	call loadCommonGraphics
	jp clearOam

seasonsFunc_03_6405:
	ld a,b
	cp $ff
	ret z
	push bc
	call refreshObjectGfx
	pop bc
	call getEntryFromObjectTable1
	ld d,h
	ld e,l
	call parseGivenObjectData
	xor a
	ld ($cfc0),a
	ld a,($cbb4)
	cp $05
	jr z,+
	cp $06
	jr z,++
	cp $07
	jr z,+++
	ret
+
	ld a,$04
	ld b,$03

seasonsFunc_03_642e:
	call seasonsFunc_03_6434
	jp reloadObjectGfx

seasonsFunc_03_6434:
	ld hl,wLoadedObjectGfx
-
	ldi (hl),a
	inc a
	ld (hl),$01
	inc l
	dec b
	jr nz,-
	ret
++
	ld a,$0f
	ld b,$06
	jr seasonsFunc_03_642e
+++
	ld a,$13
	ld b,$02
	jr seasonsFunc_03_642e

seasonsFunc_03_644c:
	ld (wRoomStateModifier),a
	call disableLcd
	call seasonsFunc_03_63eb
	ld a,$02
	jp loadGfxRegisterStateIndex

seasonsFunc_03_645a:
	ld a,(wTextIsActive)
	or a
	ret nz
	jp decCbb3

seasonsFunc_03_6462:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	jp decCbb3

seasonsFunc_03_646a:
	ld hl,$cbb3
	ld b,$10
	jp clearMemory

.include {"{GAME_DATA_DIR}/creditsOamData.s"}

seasonsFunc_03_66dc:
	ld hl,wLinkHealth
	ld (hl),$04
	ld l,<wInventoryB
	ldi a,(hl)
	ld b,(hl)
	ld hl,wcc1f
	ldi (hl),a
	ld (hl),b
	jp disableActiveRing

seasonsFunc_03_66ed:
	ld hl,wLinkMaxHealth
	ldd a,(hl)
	ld (hl),a
	ld hl,wcc1f
	ldi a,(hl)
	ld b,(hl)
	ld hl,wInventoryB
	ldi (hl),a
	ld (hl),b
	jp enableActiveRing
