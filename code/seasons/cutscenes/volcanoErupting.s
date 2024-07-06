;;
; CUTSCENE_S_VOLCANO_ERUPTING
cutsceneHandler_0b:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw cutsceneHandler_0b_stage0
	.dw cutsceneHandler_0b_stage1
	.dw cutsceneHandler_0b_stage2
	.dw cutsceneHandler_0b_stage3
	.dw cutsceneHandler_0b_stage4
	.dw cutsceneHandler_0b_stage5

cutsceneHandler_0b_stage0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call disableLcd
	call clearScreenVariablesAndWramBank1
	ld a,$03
	ld (wRoomStateModifier),a
	ld bc,ROOM_SEASONS_103
	call seasonsFunc_03_6de4
	ld a,$78
	ld ($cbb4),a
	ld a,$01
	ld (wCutsceneState),a
	xor a
	ld ($cbb3),a
	ld a,MUS_DISASTER
	ld (wActiveMusic),a
	call playSound
	ld a,SND_OPENING
	call playSound
	ld a,$01
	ld (wScrollMode),a
	call fadeinFromWhite
	call loadCommonGraphics
	ld a,$02
	jp loadGfxRegisterStateIndex

cutsceneHandler_0b_stage1:
	call seasonsFunc_03_6df8
	ld a,($cbb3)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call seasonsFunc_03_6ddf
	ret nz
	ld a,$b0
	call playSound
	ld hl,$cbb4
	ld (hl),$96
	inc hl
	ld (hl),$01
	ld hl,$cbb3
	inc (hl)

@state1:
	ld bc,$1478
	ld hl,$cbb5
	call seasonsFunc_03_6db1
	call seasonsFunc_03_6ddf
	ret nz
	ld a,$81
	ld (wScreenTransitionDirection),a
	ld hl,$cbb3
	inc (hl)

@state2:
	ld a,(wScrollMode)
	and $04
	ret z
	ld a,$04
	ld (wActiveRoom),a
	callab bank1.setObjectsEnabledTo2
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetAndRoomLayout
	call generateVramTilesWithRoomChanges
	ld a,$08
	ld (wScrollMode),a
	ld hl,$cbb3
	inc (hl)

@state3:
	ld a,(wScrollMode)
	and $01
	ret z
	callab bank1.clearObjectsWithEnabled2
	ld hl,$cbb4
	ld (hl),$96
	inc hl
	ld (hl),$01
	inc hl
	ld (hl),$01
	ld a,SND_OPENING
	call playSound

seasonsFunc_03_6c5f:
	ld hl,wCutsceneState
	inc (hl)
	ld hl,$cbb3
	ld (hl),$00
	ret

cutsceneHandler_0b_stage2:
	call seasonsFunc_03_6df8
	ld bc,$1430
	ld hl,$cbb5
	call seasonsFunc_03_6db1
	ld bc,$1488
	ld hl,$cbb6
	call seasonsFunc_03_6db1
	ld hl,$cbb4
	dec (hl)
	ret nz
	call seasonsFunc_03_6c5f
	jp fastFadeoutToWhite

cutsceneHandler_0b_stage3:
	ld a,($cbb3)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call setScreenShakeCounter
	call disableLcd
	call clearScreenVariablesAndWramBank1
	ld bc,ROOM_SEASONS_015
	call seasonsFunc_03_6de4
	ld a,$1e
	ld ($cbb4),a
	ld hl,$cbb3
	inc (hl)
	jp seasonsFunc_03_6d9f

@state1:
	call seasonsFunc_03_6ddf
	ret nz
	call seasonsFunc_03_6df8
	ld hl,$cbb4
	ld (hl),$78
	inc hl
	ld (hl),$01
	ld hl,$cbb3
	inc (hl)

@state2:
	ld hl,$cbb5
	call seasonsFunc_03_6dcb
	call seasonsFunc_03_6ddf
	ret nz
	call seasonsFunc_03_6df8
	ld hl,$cbb3
	inc (hl)
	ld a,$02
	call fadeoutToWhiteWithDelay

@state3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call seasonsFunc_03_6d8b
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERAC_MISCELLANEOUS_2
	inc l
	ld (hl),$0e
+
	ld hl,$cbb3
	inc (hl)
	ld hl,$cbb4
	ld (hl),$78
	call seasonsFunc_03_6df8

@state4:
	ld hl,$cbb5
	call seasonsFunc_03_6dcb
	call seasonsFunc_03_6ddf
	ret nz
	call seasonsFunc_03_6c5f
	ld a,$02
	jp fadeoutToWhiteWithDelay

cutsceneHandler_0b_stage4:
	ld a,($cbb3)
	rst_jumpTable
	.dw @state0
	.dw cutsceneHandler_0b_stage3@state1
	.dw cutsceneHandler_0b_stage3@state2
	.dw cutsceneHandler_0b_stage3@state3
	.dw cutsceneHandler_0b_stage3@state4

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call setScreenShakeCounter
	call disableLcd
	call clearScreenVariablesAndWramBank1
	ld a,GLOBALFLAG_TEMPLE_REMAINS_FILLED_WITH_LAVA
	call unsetGlobalFlag
	ld bc,ROOM_SEASONS_027
	call seasonsFunc_03_6de4
	ld a,$1e
	ld ($cbb4),a
	ld hl,$cbb3
	inc (hl)
	jp seasonsFunc_03_6d9f

cutsceneHandler_0b_stage5:
	ld a,($cbb3)
	rst_jumpTable
	.dw @state0
	.dw cutsceneHandler_0b_stage3@state1
	.dw cutsceneHandler_0b_stage3@state2
	.dw cutsceneHandler_0b_stage3@state3
	.dw @state4

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call setScreenShakeCounter
	call disableLcd
	call clearScreenVariablesAndWramBank1
	ld a,GLOBALFLAG_TEMPLE_REMAINS_FILLED_WITH_LAVA
	call unsetGlobalFlag
	ld bc,ROOM_SEASONS_017
	call seasonsFunc_03_6de4
	ld a,$1e
	ld ($cbb4),a
	ld hl,$cbb3
	inc (hl)
	jp seasonsFunc_03_6d9f

@state4:
	ld hl,$cbb5
	call seasonsFunc_03_6dcb
	call seasonsFunc_03_6ddf
	ret nz
	ld hl,@warpDestVariables
	jp setWarpDestVariables
@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_4ef $00 $69 $03

seasonsFunc_03_6d8b:
	call disableLcd
	call clearScreenVariablesAndWramBank1
	ld a,GLOBALFLAG_TEMPLE_REMAINS_FILLED_WITH_LAVA
	call setGlobalFlag
	call loadTilesetData
	call loadTilesetGraphics
	call func_131f

seasonsFunc_03_6d9f:
	ld a,$01
	ld (wScrollMode),a
	ld a,$02
	call fadeinFromWhiteWithDelay
	call loadCommonGraphics
	ld a,$02
	jp loadGfxRegisterStateIndex

seasonsFunc_03_6db1:
	dec (hl)
	ret nz
	call getRandomNumber
	and $0f
	add $08
	ld (hl),a
	call getFreePartSlot
	ret nz
	ld (hl),PART_VOLCANO_ROCK
	inc l
	ld (hl),$01
	ld l,Part.yh
	ld (hl),b
	ld l,Part.xh
	ld (hl),c
	ret

seasonsFunc_03_6dcb:
	dec (hl)
	ret nz
	call getRandomNumber
	and $0f
	add $08
	ld (hl),a
	call getFreePartSlot
	ret nz
	ld (hl),PART_VOLCANO_ROCK
	inc l
	ld (hl),$02
	ret

seasonsFunc_03_6ddf:
	ld hl,$cbb4
	dec (hl)
	ret

seasonsFunc_03_6de4:
	ld a,b
	ld (wActiveGroup),a
	ld a,c
	ld (wActiveRoom),a
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics
	jp func_131f

seasonsFunc_03_6df8:
	ld a,$ff
	jp setScreenShakeCounter
