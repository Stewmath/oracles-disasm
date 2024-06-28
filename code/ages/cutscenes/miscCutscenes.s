;;
; CUTSCENE_FAIRIES_HIDE
func_03_6103:
	ld a,($cfd1)
	cp $07
	jp z,fairyCutscene_cfd1is07
	ld a,(wCutsceneState)
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
	ld hl,wTmpcbb3
	ld a,(w1Link.yh)
	ldi (hl),a
	ld a,(w1Link.xh)
	ldi (hl),a
	ld a,(w1Link.direction)
	ld (hl),a
	call fadeoutToWhite
	jp fairyCutscene_incState
@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,<ROOM_AGES_081
@loadNewFairyRoom:
	ld (wActiveRoom),a
	call fairyCutscene_incState
	xor a
	ld ($cfd2),a
	call disableLcd
	call clearScreenVariablesAndWramBank1
	call initializeVramMaps
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics
	call func_131f
	ld a,$01
	ld (wScrollMode),a
	call refreshObjectGfx
	call loadCommonGraphics
	ld a,$02
	call loadGfxRegisterStateIndex
	jp fadeinFromWhite
@state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld b,$0c
;;
; @param	b	var03
@spawnForestFairy:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_FOREST_FAIRY
	ld l,Interaction.var03
	ld (hl),b
	jp fairyCutscene_incState
@state3:
@state6:
@state9:
	ld hl,$cfd2
	ld a,(hl)
	or a
	ret z
	ld (hl),$00
	call fairyCutscene_incState
	jp fadeoutToWhite
@state4:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,<ROOM_AGES_080
	jr @loadNewFairyRoom
@state5:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld b,$0d
	jr @spawnForestFairy
@state7:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,<ROOM_AGES_091
	jr @loadNewFairyRoom
@state8:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld b,$0e
	jp @spawnForestFairy
@stateA:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,<ROOM_AGES_082
	call @loadNewFairyRoom
	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld a,(wTmpcbb3)
	ldi (hl),a
	inc l
	ld a,(wTmpcbb4)
	ld (hl),a
	ld a,(wTmpcbb5)
	ld l,<w1Link.direction
	ld (hl),a
	ret
@stateB:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	inc a
	ld (wCutsceneIndex),a
	ld bc,TX_1104
	jp showText
	
fairyCutscene_cfd1is07:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld bc,TX_110a
	call showText
	jp fairyCutscene_incState
@state1:
	ld a,(wTextIsActive)
	or a
	ret nz
	call fairyCutscene_incState
	ld a,$0c
	ld (wTmpcbb6),a
	ld a,SND_MYSTERY_SEED
	call playSound
	jp fastFadeinFromWhite
@state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,wTmpcbb6
	dec (hl)
	ret nz
	jr @state1
@state3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,wTmpcbb6
	dec (hl)
	ret nz
	call fairyCutscene_incState
	xor a
	ld ($cfd0),a
	ld a,SND_MYSTERY_SEED
	call playSound
	ld a,$08
	jp fadeinFromWhiteWithDelay
@state4:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call fairyCutscene_incState
	ld bc,TX_110b
	jp showText
@state5:
	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME
	call setGlobalFlag
	ld a,GLOBALFLAG_FOREST_UNSCRAMBLED
	call setGlobalFlag
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	inc a
	ld (wCutsceneIndex),a
	ret
	
fairyCutscene_incState:
	ld hl,wCutsceneState
	inc (hl)
	ret

;;
; CUTSCENE_BOOTED_FROM_PALACE
func_03_6275:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	call fadeoutToWhite
	jr @bootedFromPalace_incState
@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call clearAllParentItems
	call dropLinkHeldItem
	ld a,>ROOM_AGES_146
	ld (wActiveGroup),a
	ld a,<ROOM_AGES_146
	ld (wActiveRoom),a
	call disableLcd
	call clearOam
	call clearScreenVariablesAndWramBank1
	call initializeVramMaps
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics
	call func_131f
	ld a,$01
	ld (wScrollMode),a
	call loadCommonGraphics
	call initializeRoom
	call fadeinFromWhite
	ld a,$02
	call loadGfxRegisterStateIndex
@bootedFromPalace_incState:
	ld hl,wCutsceneState
	inc (hl)
	ret
@state2:
	ld a,$03
	ld ($d000),a
	ld a,$0f
	ld (wLinkForceState),a
	jr @bootedFromPalace_incState
@state3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,($d005)
	cp $02
	ret nz
	ld bc,TX_590a
	call showText
	jr @bootedFromPalace_incState
@state4:
	ld a,(wTextIsActive)
	or a
	ret nz
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld (wDisableScreenTransitions),a
	ld (wCutsceneIndex),a
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	jp playSound

;;
miscCutsceneHandler:
	ld a,c
	rst_jumpTable
	.dw nayruSingingCutsceneHandler
	.dw makuTreeDisappearingCutsceneHandler
	.dw blackTowerExplanationCutsceneHandler
	.dw nayruWarpToMakuTreeCutsceneHandler
	.dw turnToStoneCutsceneHandler
	.dw twinrovaRevealCutsceneHandler
	.dw pregameIntroCutsceneHandler
	.dw blackTowerCompleteCutsceneHandler

;;
; CUTSCENE_NAYRU_SINGING
nayruSingingCutsceneHandler:
	call @runStates
	ld hl,wCutsceneState
	ld a,(hl)
	cp $02
	ret z
	cp $03
	ret z
	jp updateAllObjects

@runStates:
	ld de,wCutsceneState
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
	.dw nayruSingingStateE
	.dw nayruSingingStateF
	.dw nayruSingingState10
	.dw nayruSingingState11
@state0:
	ld a,$01
	ld (de),a
	ld a,SND_CLOSEMENU
	jp playSound
@state1:
	ld a,$ff
	ld (wTilesetAnimation),a
	ld a,$08
	ld ($cfd0),a
	ld hl,wMenuDisabled
	ld (hl),$01
	ld hl,$d01a
	res 7,(hl)
	call saveGraphicsOnEnterMenu
	ld a,GFXH_NAYRU_SINGING_CUTSCENE
	call loadGfxHeader
	ld a,PALH_95
	call loadPaletteHeader
	ld a,$04
	call loadGfxRegisterStateIndex
	ld hl,wTmpcbb3
	ld (hl),$58
	inc hl
	ld (hl),$02
	ld hl,wTmpcbb6
	ld (hl),$28
	call fastFadeinFromWhite
	call cutscene_incCutsceneState
	ld hl,wTmpcbb5
	ld (hl),$02
@func_6397:
	call clearOam
	ld b,$00
	ld a,(wGfxRegs1.SCX)
	cpl
	inc a
	ld c,a
	ld hl,bank3f.oamData_7249
	ld e,:bank3f.oamData_7249
	jp addSpritesFromBankToOam_withOffset
@state2:
	ld a,(wPaletteThread_mode)
	or a
	jp nz,@func_6397
	ret nz
	call @func_63db
	call @func_6397
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	jr z,+
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld bc,$00f0
	call compareHlToBc
	ret nc
	ld a,(wKeysJustPressed)
	and BTN_A
	ret z
+
	ld a,SND_CLOSEMENU
	call playSound
	call cutscene_incCutsceneState
	jp fastFadeoutToWhite
@func_63db:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld hl,wTmpcbb6
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ld hl,wGfxRegs1.SCX
	inc (hl)
	ret
@state3:
	ld a,(wPaletteThread_mode)
	or a
	jp nz,@func_6397
	ret nz
	xor a
	ld (wTilesetAnimation),a
	ld hl,$d01a
	set 7,(hl)
	ld a,$09
	ld ($cfd0),a
	call cutscene_incCutsceneState
	ld hl,wTmpcbb3
	ld (hl),$aa
	jp reloadGraphicsOnExitMenu
@state4:
	ld a,($cfd0)
	cp $0f
	ret nz
	call cutscene_incCutsceneState
	ld hl,$de90
	ld bc,paletteData44a8
	jp func_13c6
@state5:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,PALH_99
	call loadPaletteHeader
	ld a,$10
	ld ($cfd0),a
	jp cutscene_incCutsceneState
@state6:
	ld a,($cfd0)
	cp $14
	ret nz
	call cutscene_incCutsceneState
	ld hl,wTmpcbb3
	ld (hl),$3c
	jp fadeoutToWhite
@state7:
	call cutscene_decCBB3IfNotFadingOut
	ret nz
	call cutscene_incCutsceneState
	ld a,$15
	ld ($cfd0),a
	ld a,$03
	jp fadeinFromWhiteWithDelay
@state8:
	ld a,($cfd0)
	cp $18
	ret nz
	call cutscene_incCutsceneState
	xor a
	ld ($cfd2),a
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_LIGHTNING
	inc l
	inc (hl)
	inc l
	inc (hl)
	ld l,Part.yh
	ld (hl),$24
	ld l,Part.xh
	ld (hl),$28
	ret
@state9:
	ld a,($cfd2)
	or a
	ret z
	call cutscene_incCutsceneState
	call getThisRoomFlags
	set 6,(hl)
	ld c,$22
	ld a,$d7
	jp setTile
@stateA:
	ld a,($cfd0)
	cp $1d
	ret nz
	ld hl,wTmpcbb3
	ld (hl),$78
	jp cutscene_incCutsceneState
@stateB:
	call decCbb3
	ret nz
	ld (hl),$5a
	call cutscene_incCutsceneState
	ld bc,TX_5607
	jp showText
@stateC:
	call cutscene_decCBB3IfTextNotActive
	ret nz
	call cutscene_incCutsceneState
	xor a
	ld hl,$cfde
	ldi (hl),a
	ld (hl),a
	jp fadeoutToWhite
@stateD:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cutscene_incCutsceneState
	call cutscene_loadRoomObjectSetAndFadein
	ld a,$02
	jp loadGfxRegisterStateIndex

;;
cutscene_loadRoomObjectSetAndFadein:
	ld hl,wTmpcfc0.genericCutscene.cfde
	ld a,(hl)
	push af
	call cutscene_disableLcdLoadRoomResetCamera
	pop af
	ld b,a
	call getEntryFromObjectTable2
	call parseGivenObjectData
	call refreshObjectGfx
	xor a
	ld (wTmpcfc0.genericCutscene.cfd1),a
	jp fadeinFromWhite

nayruSingingStateE:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,$cfdf
	ld a,(hl)
	cp $ff
	ret nz
	xor a
	ldd (hl),a
	inc (hl)
	ld a,(hl)
	cp $03
	ld a,$0d
	jr nz,+
	ld a,$0f
+
	ld hl,wCutsceneState
	ld (hl),a
	jp fadeoutToWhite
	
nayruSingingStateF:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cutscene_incCutsceneState
	call cutscene_loadRoomObjectSetAndFadein
	ld a,PALH_99
	call loadPaletteHeader
	ld a,$08
	call setLinkIDOverride
	ld l,<w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.subid
	ld (hl),$04
	ld a,SNDCTRL_MEDIUM_FADEOUT
	call playSound
	ld a,MUS_SADNESS
	call playSound
	xor a
	ld (wPaletteThread_parameter),a
	ld a,$24
	ld b,$02
	call cutscene_loadAObjectGfxBTimes
	call reloadObjectGfx
	ld a,$02
	jp loadGfxRegisterStateIndex
	
nayruSingingState10:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,($cfd0)
	cp $1e
	ret nz
	call cutscene_incCutsceneState
	ld hl,$de90
	ld bc,paletteData4a30
	jp func_13c6
	
nayruSingingState11:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,PALH_TILESET_LYNNA_CITY
	call loadPaletteHeader
	ld a,$1f
	ld ($cfd0),a
	ld a,CUTSCENE_INGAME
	ld (wCutsceneIndex),a
	ret


;;
; CUTSCENE_MAKU_TREE_DISAPPEARING
makuTreeDisappearingCutsceneHandler:
	call @makuTreeDisappearing_body
	jp updateAllObjects

@makuTreeDisappearing_body:
	ld a,($cfc0)
	or a
	jr z,@label_03_119
	ld a,SND_FADEOUT
	call playSound
	xor a
	ld (wLinkStateParameter),a
	ld (wMenuDisabled),a
	ld a,GLOBALFLAG_0c
	call setGlobalFlag
	call getThisRoomFlags
	set 0,(hl)
	xor a
	ld (wUseSimulatedInput),a
	inc a
	ld (wDisabledObjects),a
	ld hl,@warpDest
	jp setWarpDestVariables
@label_03_119:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld hl,$cbb7
	ld a,(hl)
	inc a
	and $03
	ld (hl),a
	ld hl,@paletteHeaders
	rst_addAToHl
	ld a,(hl)
	jp loadPaletteHeader

@warpDest:
	m_HardcodedWarpA ROOM_AGES_038, $0c, $45, $83
@paletteHeaders:
	.db $9a $c4 $8f $c5


;;
; CUTSCENE_BLACK_TOWER_EXPLANATION
blackTowerExplanationCutsceneHandler:
	call @runStates
	jp updateAllObjects

@runStates:
	ld a,($cbb8)
	rst_jumpTable
	.dw @cbb8_00
	.dw @cbb8_01
	.dw @cbb8_02
@cbb8_00:
	ld de,wCutsceneState
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw func_6733
@@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call disableLcd
	call clearScreenVariablesAndWramBank1
	call clearOam
	ld a,($cbb8)
	ld hl,@@table_6625
	rst_addDoubleIndex
	ldi a,(hl)
	push hl
	call loadGfxHeader
	pop hl
	ld a,(hl)
	call loadGfxHeader
	ld a,PALH_c3
	call loadPaletteHeader
	ld b,$78
	ld a,($cbb8)
	cp $02
	jr z,+
	ld b,$3c
+
	ld hl,wTmpcbb3
	ld (hl),b
	or a
	ld a,MUS_DISASTER
	call z,playSound
	call cutscene_incCutsceneState
	xor a
	ld (wTmpcbb9),a
	call fadeinFromWhite
	ld a,$70
	ld (wScreenOffsetY),a
	ld hl,$cc10
	ld b,$08
	call clearMemory
	ld a,$09
	jp loadGfxRegisterStateIndex

@@table_6625:
	.db GFXH_BLACK_TOWER_STAGE_1_LAYOUT, GFXH_BLACK_TOWER_BASE
	.db GFXH_BLACK_TOWER_STAGE_2_LAYOUT, GFXH_BLACK_TOWER_MIDDLE
	.db GFXH_BLACK_TOWER_STAGE_3_LAYOUT, GFXH_BLACK_TOWER_MIDDLE

@@state1:
	call func_6ef7
	call func_6f44
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call decCbb3
	ret nz
	call cutscene_incCutsceneState
	ld bc,TX_1005
	ld a,($cbb8)
	or a
	jr z,+
	ld bc,TX_1317
+
	ld a,TEXTBOXFLAG_NOCOLORS
	ld (wTextboxFlags),a
	jp showText

@@state2:
	call func_6ef7
	call func_6f44
	ld a,(wTextIsActive)
	or a
	ret nz
	ld hl,wTmpcbb3
	ld (hl),$3c
	jp cutscene_incCutsceneState

@cbb8_01:
	ld de,wCutsceneState
	ld a,(de)
	rst_jumpTable
	.dw @cbb8_00@state0
	.dw @cbb8_00@state1
	.dw @cbb8_00@state2
	.dw @cbb8_02@state1
	.dw @cbb8_02@state2
	.dw @@state5
	.dw @@state6
	.dw @@state7

@@state5:
	call func_6ef7
	call func_6f44
	call decCbb3
	ret nz
	call cutscene_incCutsceneState
	jp fadeoutToWhite

@@state6:
	call func_6f44
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cutscene_incCutsceneState
	call clearDynamicInteractions
	ld bc, ROOM_AGES_0ba
	call disableLcdAndLoadRoom
	call resetCamera
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_REMOTE_MAKU_CUTSCENE
	inc l
	ld (hl),$00
	inc l
	ld (hl),$04
+
	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$65
	ld l,<w1Link.xh
	ld (hl),$58
	ld l,<w1Link.direction
	ld (hl),DIR_DOWN
	ld a,(wLoadingRoomPack)
	ld (wRoomPack),a
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld a,PALH_0f
	call loadPaletteHeader
	call fadeinFromWhiteToRoom
	call refreshObjectGfx
	call showStatusBar
	ld a,$02
	jp loadGfxRegisterStateIndex

@@state7:
	call updateStatusBar
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld (wCutsceneIndex),a
	ret
@cbb8_02:
	ld de,wCutsceneState
	ld a,(de)
	rst_jumpTable
	.dw @cbb8_00@state0
	.dw @@state1
	.dw @@state2
	.dw func_6733

@@state1:
	call func_6ef7
	call func_6f44
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call decCbb3
	ret nz
	ld a,$04
	ld (wTmpcbbb),a
	ld (wTmpcbb6),a
	ld a,($cbb8)
	ld hl,@@table_6722
	rst_addAToHl
	ld a,(hl)
	ld (wTmpcbb3),a
	jp cutscene_incCutsceneState
@@table_6722:
	.db $01 $61 $b1
@@state2:
	call func_6ef7
	call func_6f26
	jp nz,func_6f44
	ld (hl),$78
	call cutscene_incCutsceneState

func_6733:
	call func_6ef7
	call func_6f44
	call decCbb3
	ret nz
	ld a,($cbb8)
	rst_jumpTable
	.dw @cbb8_00
	.dw @cbb8_01
	.dw @cbb8_02
@cbb8_00:
@cbb8_01:
	ld hl,@warpDest1
	call setWarpDestVariables
	ld a,($cfd3)
	ld (wWarpDestPos),a
	ld a,($cfd4)
	ld (wcc50),a
	ld a,$ff
	ld (wActiveMusic),a
	ld a,$01
	ld ($cfc0),a
	ld a,SNDCTRL_MEDIUM_FADEOUT
	jp playSound
@cbb8_02:
	xor a
	ld (wLinkStateParameter),a
	ld hl,@warpDest2
	jp setWarpDestVariables

@warpDest1:
	m_HardcodedWarpA ROOM_AGES_186, $0c, $75, $03

@warpDest2:
	m_HardcodedWarpA ROOM_AGES_4f6, $0f, $47, $03


;;
; CUTSCENE_NAYRU_WARP_TO_MAKU_TREE
nayruWarpToMakuTreeCutsceneHandler:
	call @runStates
	call updateStatusBar
	jp updateAllObjects
	
@runStates:
	ld de,wCutsceneState
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
@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cutscene_incCutsceneState
	call clearDynamicInteractions
	ld bc, ROOM_AGES_038
	call disableLcdAndLoadRoom
	call resetCamera
	ld b,$04
	call getEntryFromObjectTable2
	call parseGivenObjectData
	call refreshObjectGfx
	ld a,$04
	ld b,$02
	call cutscene_loadAObjectGfxBTimes
	call reloadObjectGfx
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	ld a,$02
	call loadGfxRegisterStateIndex
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld b,$20
	ld hl,$cfc0
	call clearMemory
	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld a,MUS_MAKU_TREE
	call playSound
	call incMakuTreeState
	jp fadeinFromWhiteToRoom
@state1:
	call cutscene_decCBB3whenFadeDone
	ret nz
	ld (hl),$3c
	call cutscene_incCutsceneState
	ld a,$68
	ld bc,$5050
	jp createEnergySwirlGoingIn
@state2:
	call decCbb3
	ret nz
	xor a
	ld (hl),a
	dec a
	ld (wTmpcbba),a
	jp cutscene_incCutsceneState
@state3:
	ld hl,wTmpcbb3
	ld b,$02
	call flashScreen
	ret z
	call cutscene_incCutsceneState
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld a,$01
	ld ($cfd0),a
	call @func_6838
	ld a,$03
	jp fadeinFromWhiteWithDelay
@func_6838:
	ld a,$00
	call setLinkIDOverride
	ld l,<w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$68
	ld l,<w1Link.xh
	ld (hl),$50
	ld l,<w1Link.direction
	ld (hl),DIR_UP
	ret
@state4:
	call cutscene_decCBB3whenFadeDone
	ret nz
	jp cutscene_incCutsceneState
@state5:
	ld a,($cfd0)
	cp $02
	ret nz
	call cutscene_incCutsceneState
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	xor a
	ld hl,$cfde
	ld (hl),$05
	inc l
	ld (hl),$00
	jp fadeoutToWhite
@state6:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cutscene_incCutsceneState
	call cutscene_loadRoomObjectSetAndFadein
	ld a,$02
	jp loadGfxRegisterStateIndex
@state7:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,$cfdf
	ld a,(hl)
	cp $ff
	ret nz
	xor a
	ldd (hl),a
	inc (hl)
	ld a,(hl)
	cp $07
	ld a,$06
	jr nz,+
	ld a,$08
	ld hl,$cfd0
	ld (hl),$03
+
	ld hl,wCutsceneState
	ld (hl),a
	jp fadeoutToWhite
@state8:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cutscene_incCutsceneState
	call cutscene_loadRoomObjectSetAndFadein
	call @func_6838
	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,$04
	ld b,$02
	call cutscene_loadAObjectGfxBTimes
	ld a,$26
	ld b,$02
	call cutscene_loadAintoHL_BTimes
	ld a,$24
	ld b,$01
	call cutscene_loadAintoHL_BTimes
	ld b,l
	call checkIsLinkedGame
	jr z,+
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_TWINROVA
+
	call reloadObjectGfx
	ld a,MUS_MAKU_TREE
	call playSound
	ld a,$02
	jp loadGfxRegisterStateIndex
@state9:
	ld a,($cfd0)
	cp $07
	ret nz
	call cutscene_incCutsceneState
	ld a,SNDCTRL_STOPSFX
	call playSound
	ld bc,TX_2800
	call checkIsLinkedGame
	jr z,+
	ld c,<TX_2802
+
	jp showText
@stateA:
	ld a,(wTextIsActive)
	or a
	ret nz
	call cutscene_incCutsceneState
	ld hl,wTmpcbb3
	ld (hl),$b4
	ld a,DIR_RIGHT
	ld (w1Link.direction),a
	ld ($cbb7),a
	jr @func_6955
@stateB:
	call decCbb3
	jr nz,@func_6948
	call checkIsLinkedGame
	jr z,@func_692b
	ld a,$08
	ld ($cfd0),a
	jr @incCutsceneState
@func_692b:
	call getFreePartSlot
	jr nz,+
	ld (hl),PARTID_LIGHTNING
	inc l
	inc (hl)
	inc l
	inc (hl)
	ld l,Part.yh
	ld (hl),$40
	ld l,Part.xh
	ld (hl),$88
+
	call getFreeInteractionSlot
	jr nz,@incCutsceneState
	ld (hl),INTERACID_CLOAKED_TWINROVA
@incCutsceneState:
	jp cutscene_incCutsceneState
@func_6948:
	call cutscene_decCBB6
	ret nz
	ld l,<wGenericCutscene.cbb7
	ld a,(hl)
	xor $02
	ld (hl),a
	call @func_6962
@func_6955:
	call getRandomNumber_noPreserveVars
	and $03
	add a
	add a
	add $10
	ld (wTmpcbb6),a
	ret
@func_6962:
	ld (w1Link.direction),a
	ld a,$08
	ld (wLinkForceState),a
	ret
@stateC:
	ld a,($cfd0)
	cp $63
	jr z,@func_699a
	call checkIsLinkedGame
	ret z
	ld a,($cfd0)
	cp $09
	ret nc
	ld a,(wFrameCounter)
	and $07
	ret nz
	callab agesInteractionsBank0a.func_0a_7877
	ld de,w1Link.yh
	call objectGetRelativeAngle
	call convertAngleToDirection
	ld h,d
	ld l,<w1Link.direction
	cp (hl)
	ret z
	jr @func_6962
@func_699a:
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld a,(wLoadingRoomPack)
	ld (wRoomPack),a
	ld a,GLOBALFLAG_SAVED_NAYRU
	call setGlobalFlag
	call refreshObjectGfx
	ld a,CUTSCENE_INGAME
	ld (wCutsceneIndex),a
	ret

;;
; CUTSCENE_BLACK_TOWER_COMPLETE
blackTowerCompleteCutsceneHandler:
	call @runStates
	call updateStatusBar
	jp updateAllObjects
	
@runStates:
	ld de,wCutsceneState
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
@state0:
	ld a,$3c
	ld (wTmpcbb3),a
	jp cutscene_incCutsceneState
@state1:
	call decCbb3
	ret nz
	call cutscene_incCutsceneState
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	jp fastFadeoutToBlack
@state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call hideStatusBar
	ld a,($ff00+R_SVBK)
	push af
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld hl,$de90
	ld b,$30
	call clearMemory
	pop af
	ld ($ff00+R_SVBK),a
	callab bank1.checkDisableUnderwaterWaves
	xor a
	ld (wScrollMode),a
	ld (wTilesetFlags),a
	ld (wGfxRegs1.LYC),a
	ld (wGfxRegs2.SCY),a
	ld ($d01a),a
	ld a,$10
	ld (wScreenOffsetY),a
	call checkIsLinkedGame
	jr z,@func_6a2b
	call cutscene_incCutsceneState
	ld hl,wTmpcbb3
	ld (hl),$1e
	ret
@func_6a2b:
	call clearWramBank1
	call clearOam
	ld a,$05
	ld (wCutsceneState),a
	ldbc INTERACID_CLOAKED_TWINROVA $01
	jp createInteraction
@state3:
	call decCbb3
	ret nz
	ld a,SND_LIGHTNING
	call playSound
	xor a
	ld hl,wTmpcbb3
	ld (hl),a
	dec a
	ld hl,wTmpcbba
	ld (hl),a
	jp cutscene_incCutsceneState
@state4:
	ld hl,wTmpcbb3
	ld b,$02
	call flashScreen
	ret z
	call cutscene_incCutsceneState
	ld a,$10
	ld ($cfde),a
	callab cutscene_loadRoomObjectSetAndFadein
	call showStatusBar
	ld a,MUS_DISASTER
	call playSound
	ld a,PALH_ac
	call loadPaletteHeader
	ld a,$02
	call loadGfxRegisterStateIndex
	xor a
	ld (wScrollMode),a
	ld a,$28
	ld (wGfxRegs2.SCX),a
	ldh (<hCameraX),a
	ld a,$f0
	ld (wGfxRegs2.SCY),a
@state5:
	ret


;;
; CUTSCENE_TURN_TO_STONE
turnToStoneCutsceneHandler:
	call @runStates
	call updateStatusBar
	jp updateAllObjects

@runStates:
	ld de,wCutsceneState
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
@state0:
	call cutscene_incCutsceneState
	ld b,$20
	ld hl,$cfc0
	call clearMemory
	ld a,$0d
	ld hl,$cfde
	ldi (hl),a
	ld (hl),$00
	call showStatusBar
	jp fadeoutToWhite
@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cutscene_incCutsceneState
	call cutscene_loadRoomObjectSetAndFadein
	ld a,$02
	jp loadGfxRegisterStateIndex
@state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,$cfdf
	ld a,(hl)
	cp $ff
	ret nz
	xor a
	ldd (hl),a
	inc (hl)
	ld a,(hl)
	cp $0f
	ld a,$01
	jr nz,+
	ld a,$03
+
	ld hl,wCutsceneState
	ld (hl),a
	jp fadeoutToWhite
@state3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call @state1
	ld a,$08
	ld b,$28
	ld hl,hCameraY
	ldi (hl),a
	inc l
	ld (hl),b
	ld a,$f8
	ld hl,wGfxRegs2.SCY
	ldi (hl),a
	ld (hl),b
	xor a
	ld (wScrollMode),a
	ld (wScreenOffsetY),a
	ld (wScreenOffsetX),a
	ret
@state4:
	ld a,($cfc0)
	cp $03
	ret nz
	call cutscene_incCutsceneState
	jp fadeoutToWhite
@state5:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cutscene_incCutsceneState
	call clearDynamicInteractions
	ld bc, ROOM_AGES_290
	call disableLcdAndLoadRoom
	call resetCamera
	ld hl,objectData.objectData7798
	call parseGivenObjectData
	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$58
	ld l,<w1Link.xh
	ld (hl),$50
	ld l,<w1Link.direction
	ld (hl),DIR_DOWN
	call refreshObjectGfx
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	call showStatusBar
	ld a,$02
	call loadGfxRegisterStateIndex
	ld a,(wLoadingRoomPack)
	ld (wRoomPack),a
	jp fadeinFromWhiteToRoom
@state6:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld (wCutsceneIndex),a
	ret

;;
; CUTSCENE_TWINROVA_REVEAL
twinrovaRevealCutsceneHandler:
	call @runStates
	call updateStatusBar
	jp updateAllObjects
	
@runStates:
	ld de,wCutsceneState
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
	call cutscene_incCutsceneState
	ld b,$20
	ld hl,$cfc0
	call clearMemory
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld bc,TX_2810
	call checkIsLinkedGame
	jr z,+
	ld c,<TX_2815
+
	ld a,$02
	ld ($cfc0),a
	jp showText
@state1:
	call cutscene_decCBB3IfTextNotActive
	ret nz
	ld a,SNDCTRL_STOPMUSIC
	call playSound
@func_6bc9:
	ld hl,wTmpcbb3
	xor a
	ld (hl),a
	dec a
	ld (wTmpcbba),a
	jp cutscene_incCutsceneState
@state2:
	ld hl,wTmpcbb3
	ld b,$01
	call flashScreen
	ret z
	call checkIsLinkedGame
	jr nz,@func_6be8
	call func_6fb0
	jr ++
@func_6be8:
	call func_6f9e
++
	ld a,$01
	ld (wDisabledObjects),a
	call clearDynamicInteractions
	ld hl,objectData.objectData77b2
	call checkIsLinkedGame
	jr nz,+
	ld hl,wCutsceneState
	ld (hl),$06
	ld hl,objectData.objectData77a5
+
	call parseGivenObjectData
	jp cutscene_incCutsceneState
@state3:
	ld a,($cfc0)
	cp $03
	ret nz
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld a,SND_LIGHTNING
	call playSound
	jp @func_6bc9
@state4:
	ld hl,wTmpcbb3
	ld b,$04
	call flashScreen
	ret z
	ld a,$12
	ld ($cfde),a
	call cutscene_loadRoomObjectSetAndFadein
	call showStatusBar
	call cutscene_incCutsceneState
	ld a,MUS_ZELDA_SAVED
	call playSound
	ld a,$02
	call loadGfxRegisterStateIndex
	jp resetCamera
@state5:
	ld hl,$cfdf
	ld a,(hl)
	cp $ff
	ret nz
	ld a,SND_LIGHTNING
	call playSound
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	jp @func_6bc9
@state6:
	ld hl,wTmpcbb3
	ld b,$01
	call flashScreen
	ret z
	ld hl,$cfde
	inc (hl)
	call cutscene_loadRoomObjectSetAndFadein
	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$68
	ld l,<w1Link.xh
	ld (hl),$50
	ld l,<w1Link.direction
	ld (hl),DIR_UP
	ld a,$2c
	ld b,$03
	call cutscene_loadAObjectGfxBTimes
	call cutscene_incCutsceneState
	xor a
	ld (wPaletteThread_mode),a
.ifndef REGION_JP
	ldh (<hVBlankFunctionQueueTail),a
.endif
	inc a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,(wLoadingRoomPack)
	ld (wRoomPack),a
	call reloadObjectGfx
	ld a,$02
	call loadGfxRegisterStateIndex
	jp func_6fb0
@state7:
	ld a,($cfd0)
	cp $09
	ret nz
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	call fadeoutToBlack
	ld a,$ff
	ld (wFadeSprPaletteSources),a
	ld (wDirtyFadeSprPalettes),a
	ld a,$03
	ld (wFadeBgPaletteSources),a
	ld (wDirtyFadeBgPalettes),a
	jp cutscene_incCutsceneState
@state8:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cutscene_incCutsceneState
	call showStatusBar
	ld a,GLOBALFLAG_GOT_MAKU_SEED
	call setGlobalFlag
	ld a,$01
	ld (wScrollMode),a
	xor a
	ld (wScreenShakeCounterY),a
	ld (wScreenShakeCounterX),a
	ld a,$0f
	ld (wGfxRegs1.LYC),a
	ld a,$f0
	ld (wGfxRegs2.SCY),a
	call fadeinFromBlack
	ldbc INTERACID_MAKU_TREE $06
	call createInteraction
	ld bc,$4050
	call interactionHSetPosition
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	jp playSound
@state9:
	ld a,($cfc0)
	cp $04
	ret nz
	call refreshObjectGfx
	ld a,CUTSCENE_INGAME
	ld (wCutsceneIndex),a
	ret


;;
; CUTSCENE_PREGAME_INTRO
pregameIntroCutsceneHandler:
	call @runStates
	jp updateAllObjects
	
@runStates:
	ld de,wCutsceneState
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
@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call checkIsLinkedGame
	jr nz,@func_6d40
	ld a,$0a
	ld (de),a
	jp @stateA
@func_6d40:
	ld a,$01
	ld (de),a
	ld bc,ROOM_ZELDA_IN_FINAL_DUNGEON
	call disableLcdAndLoadRoom
	call resetCamera
	ld a,PALH_ac
	call loadPaletteHeader
	ld hl,objectData.objectData77b6
	call parseGivenObjectData
	ld a,MUS_FINAL_DUNGEON
	call playSound
	ld hl,wTmpcbb3
	ld (hl),$3c
	ld a,$13
	call loadGfxRegisterStateIndex
	ld a,(wGfxRegs2.SCX)
	ldh (<hCameraX),a
	xor a
	ldh (<hCameraY),a
	ld a,$00
	ld (wScrollMode),a
	jp clearFadingPalettes2
@state1:
	ld e,$96
--
	call decCbb3
	ret nz
	call cutscene_incCutsceneState
	ld hl,wTmpcbb3
	ld (hl),e
	ret
@state2:
	ld e,$3c
	jr --
@state3:
	call decCbb3
	ret nz
	call cutscene_incCutsceneState
	call fastFadeinFromBlack
	ld a,$40
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	ld a,$03
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	ld a,SND_LIGHTTORCH
	jp playSound
@state4:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cutscene_incCutsceneState
	ld a,$0e
	ld (wTmpcbb3),a
	call fadeinFromBlack
	ld a,$bf
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	ld a,$fc
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	ret
@state5:
	call decCbb3
	ret nz
	xor a
	ld (wPaletteThread_mode),a
	ld a,$78
	ld (wTmpcbb3),a
	jp cutscene_incCutsceneState
@state6:
	call decCbb3
	ret nz
	call cutscene_incCutsceneState
	ld a,TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a
	ld a,$03
	ld (wTextboxPosition),a
	ld bc,TX_281a
	jp showText
@state7:
	call retIfTextIsActive
	call cutscene_incCutsceneState
	ld (wTmpcbb3),a
	dec a
	ld (wTmpcbba),a
	call restartSound
	ld a,SND_BIG_EXPLOSION_2
	jp playSound
@state8:
	ld hl,wTmpcbb3
	ld b,$03
	call flashScreen
	ret z
	call cutscene_incCutsceneState
	ld a,$3c
	ld (wTmpcbb3),a
	ld a,$02
	jp fadeoutToWhiteWithDelay
@state9:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call decCbb3
	ret nz
	jp cutscene_incCutsceneState
@stateA:
	call disableLcd
	ld a,($ff00+R_SVBK)
	push af
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld hl,$de80
	ld b,$40
	call clearMemory
	pop af
	ld ($ff00+R_SVBK),a
	call clearScreenVariablesAndWramBank1
	call clearOam
	ld a,PALH_0f
	call loadPaletteHeader
	ld a,$02
	call func_6e9a
	call func_6eb7
	ld a,MUS_ESSENCE_ROOM
	call playSound
	ld a,$08
	call setLinkID
	ld l,<w1Link.enabled
	ld (hl),$01
	ld l,<w1Link.subid
	ld (hl),$0b
	ld a,$00
	ld (wScrollMode),a
	call cutscene_incCutsceneState
	call clearPaletteFadeVariablesAndRefreshPalettes
	xor a
	ldh (<hCameraY),a
	ldh (<hCameraX),a
	ld a,$15
	jp loadGfxRegisterStateIndex
@stateB:
	ld a,(wTmpcbb9)
	cp $07
	ret nz
	call clearLinkObject
	ld hl,wTmpcbb3
	ld (hl),$3c
	jp cutscene_incCutsceneState
@stateC:
	call decCbb3
	ret nz
	ld hl,wGameState
	xor a
	ldi (hl),a
	ld (hl),a
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld a,GLOBALFLAG_3d
	jp setGlobalFlag
	
func_6e9a:
	ldh (<hFF8B),a
	ld a,$01
	ld ($ff00+R_VBK),a
	ld hl,$9800
	ld bc,$0400
	ldh a,(<hFF8B)
	call fillMemoryBc
	xor a
	ld ($ff00+R_VBK),a
	ld hl,$9800
	ld bc,$0400
	jp clearMemoryBc

func_6eb7:
	ld a,($ff00+R_SVBK)
	push af
	
	ld a,$03
	ld ($ff00+R_SVBK),a
	
	ld hl,w3VramTiles
	ld bc,$0240
	call clearMemoryBc
	
	ld hl,w3VramAttributes
	ld bc,$0240
	ld a,$02
	call fillMemoryBc
	
	pop af
	ld ($ff00+R_SVBK),a
	ret
	
func_6ed6:
	ldh (<hFF8B),a
	ld a,($ff00+R_SVBK)
	push af
	ld a,$04
	ld ($ff00+R_SVBK),a
	ld hl,$d000
	ld bc,$0240
	call clearMemoryBc
	ld hl,$d400
	ld bc,$0240
	ldh a,(<hFF8B)
	call fillMemoryBc
	pop af
	ld ($ff00+R_SVBK),a
	ret

func_6ef7:
	ld a,(wTmpcbb9)
	or a
	jr z,func_6f0b
	ld hl,$cbb7
	ld b,$01
	call flashScreen
	ret z
	xor a
	ld (wTmpcbb9),a
	ret
	
func_6f0b:
	ld a,(wFrameCounter)
	and $1f
	ret nz
	call getRandomNumber
	and $07
	ret nz
	ld ($cbb7),a
	dec a
	ld (wTmpcbb9),a
	ld (wTmpcbba),a
	ld a,SND_LIGHTNING
	jp playSound

func_6f26:
	ld hl,wTmpcbb6
	dec (hl)
	ret nz
	call decCbb3
	ret z
	ld a,(wTmpcbbb)
	ld (wTmpcbb6),a
	ld hl,wGfxRegs1.SCY
	dec (hl)
	ld a,(hl)
	or a
	ret nz
	ld a,UNCMP_GFXH_34
	call loadUncompressedGfxHeader
	or $01
	ret

func_6f44:
	ld a,(wGfxRegs1.SCY)
	cpl
	inc a
	ld b,a
	xor a
	ldh (<hOamTail),a
	ld c,a
	ld a,($cbb8)
	rst_jumpTable
	.dw @cbb8_00
	.dw @cbb8_01
	.dw @cbb8_02
@cbb8_00:
	ld hl,bank3f.oamData_714c
	ld e,:bank3f.oamData_714c
	jp addSpritesFromBankToOam_withOffset
@cbb8_01:
	ld hl,bank3f.oamData_718d
	ld e,:bank3f.oamData_718d
	call addSpritesFromBankToOam_withOffset
	ld hl,bank3f.oamData_71ce
	ld e,:bank3f.oamData_71ce
	jp addSpritesFromBankToOam_withOffset
@cbb8_02:
	ld hl,bank3f.oamData_71f7
	ld e,:bank3f.oamData_71f7
	call addSpritesFromBankToOam_withOffset
	ld hl,bank3f.oamData_718d
	ld e,:bank3f.oamData_718d
	ld a,(wGfxRegs1.SCY)
	cp $71
	jr c,+
	ld hl,bank3f.oamData_7220
	ld e,:bank3f.oamData_7220
+
	jp addSpritesFromBankToOam_withOffset

cutscene_incCutsceneState:
	ld hl,wCutsceneState
	inc (hl)
	ret

cutscene_decCBB6:
	ld hl,wTmpcbb6
	dec (hl)
	ret
	
cutscene_decCBB3whenFadeDone:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	jp decCbb3

func_6f9e:
	ld a,($ff00+R_SVBK)
	push af
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld hl,$de90
	ld b,$30
	call clearMemory
	pop af
	ld ($ff00+R_SVBK),a
func_6fb0:
	ld a,($ff00+R_SVBK)
	push af
	
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld hl,w2FadingBgPalettes
	ld b,$80
	call clearMemory
	
	pop af
	ld ($ff00+R_SVBK),a
	call hideStatusBar
	ld a,$fc
	ldh (<hBgPaletteSources),a
	ldh (<hDirtyBgPalettes),a
	xor a
	ld (wScrollMode),a
	ld (wGfxRegs1.LYC),a
	ld (wGfxRegs2.SCY),a
	ret

;;
; @param	a	Index?
; @param[out]	b	Index for "objectTable2"?
; @param[out]	c
cutscene_disableLcdLoadRoomResetCamera:
	ld hl,@data
	rst_addDoubleIndex
	ld b,(hl)
	inc hl
	ld c,(hl)
	call disableLcdAndLoadRoom
	jp resetCamera

@data:
	dwbe ROOM_AGES_098
	dwbe ROOM_AGES_05a
	dwbe ROOM_AGES_20e
	dwbe ROOM_AGES_039
	dwbe ROOM_AGES_039
	dwbe ROOM_AGES_20e
	dwbe ROOM_AGES_05a
	dwbe ROOM_AGES_038
	dwbe ROOM_AGES_149
	dwbe ROOM_AGES_184
	dwbe ROOM_AGES_165
	dwbe ROOM_ZELDA_IN_FINAL_DUNGEON
	dwbe ROOM_AGES_165
	dwbe ROOM_AGES_149
	dwbe ROOM_AGES_184
	dwbe ROOM_AGES_4f6
	dwbe ROOM_ZELDA_IN_FINAL_DUNGEON
	dwbe ROOM_AGES_038
	dwbe ROOM_AGES_149
	dwbe ROOM_AGES_038


cutscene_tickDownCBB4ThenSetTo30:
	ld hl,$cbb4
	dec (hl)
	ret nz
	ld (hl),30
	ret
	
cutscene_incState:
	ld hl,wCutsceneState
	inc (hl)
	ret
	
cutscene_incCBB3:
	ld hl,wTmpcbb3
	inc (hl)
	ret

;;
; CUTSCENE_WALL_RETRACTION
func_701d:
	ld a,(wDungeonIndex)
	cp $08
	jp z,wallRetraction_dungeon8

	; D6 wall retraction
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,GFXH_MERMAIDS_CAVE_WALL_RETRACTION
@func_702f:
	call loadGfxHeader
	ld b,$10
	ld hl,wTmpcbb3
	call clearMemory
	call reloadTileMap
	call resetCamera
	call getThisRoomFlags
	set 6,(hl)
	call loadTilesetAndRoomLayout
	ld a,$3c
	ld (wTmpcbb4),a
	xor a
	ld (wScrollMode),a
	jr cutscene_incState
@state1:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @cbb3_00
	.dw @cbb3_01
@cbb3_00:
	call cutscene_tickDownCBB4ThenSetTo30
	ret nz
	ld (hl),$3c
	jr cutscene_incCBB3
@cbb3_01:
	ld a,$3c
	call setScreenShakeCounter
	call cutscene_tickDownCBB4ThenSetTo30
	ret nz
	ld (hl),$19
	callab tilesets.generateW3VramTilesAndAttributes
	ld bc,$260c
	call func_70f7
	xor a
	ld ($ff00+R_SVBK),a
	call reloadTileMap
	ld a,SND_DOORCLOSE
	call playSound
	ld hl,$cbb7
	inc (hl)
	ld a,(hl)
	cp $0f
	ret c
	call func_7098
	ld a,$0f
	ld ($ce5d),a
	ret

func_7098:
	ld a,SND_SOLVEPUZZLE
	call playSound
	ld a,CUTSCENE_INGAME
	ld (wCutsceneIndex),a
	ld a,$01
	ld (wScrollMode),a
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call loadTilesetAndRoomLayout
	jp loadRoomCollisions
	
wallRetraction_dungeon8:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,GFXH_ANCIENT_TOMB_WALL_RETRACTION
	jp func_701d@func_702f
@state1:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw func_701d@cbb3_00
	.dw @cbb3_01
@cbb3_01:
	ld a,$3c
	call setScreenShakeCounter
	call cutscene_tickDownCBB4ThenSetTo30
	ret nz
	ld (hl),$19
	callab tilesets.generateW3VramTilesAndAttributes
	ld bc,$4d04
	call func_70f7
	xor a
	ld ($ff00+R_SVBK),a
	call reloadTileMap
	ld a,SND_DOORCLOSE
	call playSound
	ld hl,$cbb7
	inc (hl)
	ld a,(hl)
	cp $0b
	ret c
	jr func_7098
	
func_70f7:
	ld a,c
	ldh (<hFF8C),a
	ld a,b
	ldh (<hFF8D),a
	swap a
	and $0f
	add a
	ld e,a
	ld a,($cbb7)
	add e
	ldh (<hFF93),a
	ld c,$20
	call multiplyAByC
	ld bc,w3VramTiles
	ldh a,(<hFF8D)
	and $0f
	call addDoubleIndexToBc
	add hl,bc
	ldh a,(<hFF8C)
	ld b,a
	ld a,$20
	sub b
	ldh (<hFF8E),a
	push hl
	ld c,d
	ld de,$d000
	call func_712f
	pop hl
	set 2,h
	ld de,$d400
func_712f:
	ldh a,(<hFF93)
	ld c,a
	ld a,$14
	sub c
	ret c
	ld c,a
--
	ldh a,(<hFF8C)
	ld b,a
-
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld a,(de)
	inc de
	ldh (<hFF8B),a
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	ldh a,(<hFF8B)
	ldi (hl),a
	dec b
	jr nz,-
	ldh a,(<hFF8E)
	call addAToDe
	ldh a,(<hFF8E)
	rst_addAToHl
	dec c
	jr nz,--
	ret
	

d2Collapse_decCBB4:
	ld hl,wTmpcbb4
	dec (hl)
	ret nz
	ret

d2Collapse_incState:
	ld hl,wCutsceneState
	inc (hl)
	ret

d2Collapse_incCBB3:
	ld hl,wTmpcbb3
	inc (hl)
	ret

;;
; CUTSCENE_D2_COLLAPSE
func_7168:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld b,$10
	ld hl,wTmpcbb3
	call clearMemory
	call getThisRoomFlags
	set 7,(hl)
	ld l,<ROOM_AGES_073
	set 7,(hl)
	xor a
	ld (wScrollMode),a
	ld a,$3c
	ld (wTmpcbb4),a
	call d2Collapse_incState
	jp reloadTileMap
@state1:
	call d2Collapse_decCBB4
	ret nz
	call d2Collapse_incState
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_97
	ld l,Interaction.yh
	ld (hl),$2c
	ld l,Interaction.xh
	ld (hl),$58
+
	ld a,GFXH_WING_DUNGEON_COLLAPSING_1
	jp loadGfxHeader
@state2:
	ld a,$0f
	call setScreenShakeCounter
	call func_stub
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @cbb3_00
	.dw @cbb3_01
	.dw @cbb3_02
	.dw @cbb3_03

@cbb3_00:
	ld bc,roomGfxChanges.rectangleData_02_7de1
	callab roomGfxChanges.copyRectangleFromTmpGfxBuffer_paramBc
@func_71d0:
	ld a,UNCMP_GFXH_AGES_3c
	call loadUncompressedGfxHeader
	ld a,SND_DOORCLOSE
	call playSound
	ld a,$1e
	ld (wTmpcbb4),a
	jp d2Collapse_incCBB3
@cbb3_01:
	ld b,GFXH_WING_DUNGEON_COLLAPSING_2
--
	call d2Collapse_decCBB4
	ret nz
	ld (hl),$1e
	ld a,b
	call loadGfxHeader
	jr @cbb3_00
@cbb3_02:
	ld b,GFXH_WING_DUNGEON_COLLAPSING_3
	jr --
@cbb3_03:
	call d2Collapse_decCBB4
	ret nz
	callab roomGfxChanges.drawCollapsedWingDungeon
	call @func_71d0
	ld a,$3c
	ld (wTmpcbb4),a
	jp d2Collapse_incState
@state3:
	call d2Collapse_decCBB4
	ret nz
	jp d2Collapse_incState
@state4:
	ld a,CUTSCENE_INGAME
	ld (wCutsceneIndex),a
	ld a,$01
	ld (wScrollMode),a
	ld hl,objectData.objectData7e69
	call parseGivenObjectData
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,(wActiveMusic)
	jp playSound
func_stub:
	ret


; unused??
	.db $00 $01 $00 $00


timewarpCutscene_decCBB4:
	ld hl,wTmpcbb4
	dec (hl)
	ret nz
	ret

timewarpCutscene_incState:
	ld hl,wCutsceneState
	inc (hl)
	ret

timewarpCutscene_incCBB3:
	ld hl,wTmpcbb3
	inc (hl)
	ret

;;
; CUTSCENE_TIMEWARP
func_03_7244:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld b,$10
	ld hl,wTmpcbb3
	call clearMemory
	call timewarpCutscene_incState
	call stopTextThread
	xor a
	ld hl,wLoadedTreeGfxActive
	ldi (hl),a
	ld (hl),a
	ld a,$01
	ld ($cc20),a
	dec a
	ld (wScrollMode),a
	ld a,$08
	ld ($cbb7),a
	callab bank3f.agesFunc_3f_4133
	callab bank6.specialObjectLoadAnimationFrameToBuffer
	ld a,GFXH_COMMON_SPRITES_TO_WRAM
	call loadGfxHeader
	call fastFadeoutToBlack
	xor a
	ld (wDirtyFadeSprPalettes),a
	dec a
	ld (wFadeSprPaletteSources),a
	ld hl,wLoadedObjectGfx
	ld b,$10
	call clearMemory
	jp hideStatusBar
@state1:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @@cbb3_00
	.dw @@cbb3_01
	.dw @@cbb3_02
	.dw @@cbb3_03
	.dw @@cbb3_04
	.dw @@cbb3_05
@@cbb3_00:
	ld hl,$d000
--
	call func_7431
	call func_745c
	jr timewarpCutscene_incCBB3
@@cbb3_01:
	ld hl,$d400
	jr --
@@cbb3_02:
	ld hl,$d800
	jr --
@@cbb3_03:
	ld hl,$dc00
	jr --
@@cbb3_04:
	ld hl,$d000
	call func_7431
	call func_7456
	jp timewarpCutscene_incCBB3
@@cbb3_05:
	ld hl,$d400
	call func_7431
	call func_7450
	ld hl,$cbb7
	dec (hl)
	jr z,@@func_72ec
	ld hl,$cbb8
	inc (hl)
	ld hl,wTmpcbb3
	ld (hl),$00
	ret
	
@@func_72ec:
	xor a
	ld ($ff00+R_SVBK),a
	call clearItems
	call clearEnemies
	call clearParts
	call clearReservedInteraction0
	call clearDynamicInteractions
	ld de,$d100
	call objectDelete_de
.ifndef REGION_JP
	ld a,>w1Link
	ld (wLinkObjectIndex),a
.endif
	call refreshObjectGfx
	xor a
	ld ($cc20),a
	ld hl,wTmpcbb3
	ld (hl),$00
	jp timewarpCutscene_incState

@state2:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @@cbb3_00
	.dw @@cbb3_01
	.dw @@cbb3_02
	.dw @@cbb3_03
	.dw @@cbb3_04
@@cbb3_00:
	ld a,(wcddf)
	or a
	jr nz,+
	callab tilesets.func_04_6f07
+
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld bc,$02c0
	ld hl,$d800
	call clearMemoryBc
	ld bc,$02c0
	ld hl,$dc00
	call clearMemoryBc
	call reloadTileMap
	jp timewarpCutscene_incCBB3
@@cbb3_01:
	call getFreeInteractionSlot
	ld (hl),INTERACID_TIMEWARP
	ld l,Interaction.counter1
	ld a,120
	ld (hl),a
	ld (wTmpcbb4),a
	ld a,(wTilesetFlags)
	and $80
	ld a,$02
	jr nz,+
	dec a
+
	ld l,Interaction.var03
	ld (hl),a
	ld (wcc50),a
	ld a,SND_TIMEWARP_INITIATED
	call playSound
	jp timewarpCutscene_incCBB3
@@cbb3_02:
	call timewarpCutscene_decCBB4
	ret nz
	ld (hl),$3c
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_TIMEWARP
	inc l
	ld (hl),$02
	ld de,w1Link.yh
	call objectCopyPosition_rawAddress
+
	ld de,w1Link.yh
	call getShortPositionFromDE
	ld (wTmpcbb9),a
	ld de,$d000
	call objectDelete_de
	jp timewarpCutscene_incCBB3
@@cbb3_03:
	call timewarpCutscene_decCBB4
	ret nz
	call fastFadeinFromBlack
	jp timewarpCutscene_incCBB3
@@cbb3_04:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call fadeoutToWhite
	jp timewarpCutscene_incState

@state3:
	ld a,(wcddf)
	or a
	jr nz,+
	callab tilesets.func_04_6e9b
+
	ld a,(wActiveRoom)
	ld b,a
	ld a,(wActiveGroup)
	xor $01
	call getRoomFlags
	ld (wLinkStateParameter),a
	ld hl,wWarpDestGroup
	ld a,(wActiveGroup)
	xor $01
	or $80
	ldi (hl),a
	ld a,(wActiveRoom)
	ldi (hl),a
	ld a,$06
	ldi (hl),a
	ld a,(wActiveTilePos)
	ld (hl),a
	callab bank1.checkSolidObjectAtWarpDestPos
	srl c
	jr nc,+
	ld a,(wTmpcbb9)
	ld (wWarpDestPos),a
+
	ld a,CUTSCENE_03
	ld (wCutsceneIndex),a
	ld a,$ff
	ld (wActiveMusic),a
	ld a,(wActiveRoom)
	ld hl,@sentBackByStrangeForceTable
	call checkFlag
	ret z
	ld a,$01
	ld (wSentBackByStrangeForce),a
	ret

@sentBackByStrangeForceTable:
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00011100
	dbrev %00000000 %00011100
	dbrev %00000110 %00011100
	dbrev %00000110 %00001000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000
	dbrev %00000000 %00000000

func_7431:
	push hl
	ld a,($cbb8)
	and $07
	ld hl,table_7440
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,(hl)
	ld d,a
	pop hl
	ret

table_7440:
	.db $dd $ff
	.db $dd $bb
	.db $55 $bb
	.db $55 $aa
	.db $11 $aa
	.db $11 $88
	.db $00 $88
	.db $00 $00

func_7450:
	ld b,$2f
	ld c,$06
	jr ++

func_7456:
	ld b,$3f
	ld c,$06
	jr ++

func_745c:
	ld b,$3f
	ld c,$05
++
	push bc
	push hl
	ld a,c
	ld ($ff00+R_SVBK),a
	ld b,$00
--
	ld a,(hl)
	and d
	ldi (hl),a
	ld a,(hl)
	and d
	ldi (hl),a
	ld a,(hl)
	and e
	ldi (hl),a
	ld a,(hl)
	and e
	ldi (hl),a
	dec b
	jr nz,--
	pop hl
	pop bc
	ld a,c
	sub $05
	ld e,a
	ld a,h
	and $8f
	ld d,a
	jp queueDmaTransfer


ambiPassageOpen_decCBB4:
	ld hl,wTmpcbb4
	dec (hl)
	ret nz
	ret
	
ambiPassageOpen_incState:
	ld hl,wCutsceneState
	inc (hl)
	ret
	
ambiPassageOpen_incCBB3:
	ld hl,wTmpcbb3
	inc (hl)
	ret

;;
; CUTSCENE_AMBI_PASSAGE_OPEN
func_03_7493:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld b,$08
	ld hl,wTmpcbb3
	call clearMemory
	ld a,$3c
	ld (wTmpcbb4),a
	call ambiPassageOpen_incState
	call disableLcd
	call clearOam
	call clearScreenVariablesAndWramBank1
	callab bank1.clearMemoryOnScreenReload
	call stopTextThread
	xor a
	ld bc, ROOM_AGES_127
	call forceLoadRoom
	call loadRoomCollisions
	call func_131f
	call loadCommonGraphics
	call fadeinFromWhite
	ld a,$02
	jp loadGfxRegisterStateIndex
@state1:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @cbb3_00
	.dw @cbb3_01
@cbb3_00:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call ambiPassageOpen_decCBB4
	ret nz
	ld (hl),$3e
	ld a,(wTmpcbbd)
	ld hl,@table_7513
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUSHBLOCK
	ld l,Interaction.angle
	ld (hl),b
	ld l,Interaction.yh
	call setShortPosition_paramC
	ld l,Interaction.yh
	dec (hl)
	dec (hl)
	ld l,Interaction.var30
	ld (hl),c
	jp ambiPassageOpen_incCBB3

@table_7513:
	.db $33 $10
	.db $34 $00
	.db $35 $10
	.db $36 $00
@cbb3_01:
	call ambiPassageOpen_decCBB4
	ret nz
	ld (hl),$1e
	ld a,SND_SOLVEPUZZLE
	call playSound
	jp ambiPassageOpen_incState
@state2:
	call ambiPassageOpen_decCBB4
	ret nz
	call getThisRoomFlags
	ld a,(wTmpcbbb)
	ld (wWarpDestRoom),a
	ld l,a
	set 7,(hl)
	ld a,$81
	ld (wWarpDestGroup),a
	ld a,(wTmpcbbc)
	ld (wWarpDestPos),a
	ld a,$00
	ld (wWarpTransition),a
	ld a,CUTSCENE_03
	ld (wCutsceneIndex),a
	xor a
	ld (wMenuDisabled),a
	jp fadeoutToWhite
	
jabuOpen_decCBB4:
	ld hl,wTmpcbb4
	dec (hl)
	ret nz
	ret
	
jabuOpen_incState:
	ld hl,wCutsceneState
	inc (hl)
	ret
	
jabuOpen_incCBB3:
	ld hl,wTmpcbb3
	inc (hl)
	ret

;;
; CUTSCENE_JABU_OPEN
func_03_7565:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld b,$10
	ld hl,wTmpcbb3
	call clearMemory
	callab bank1.checkDisableUnderwaterWaves
	call getThisRoomFlags
	set 1,(hl)
	ld a,$04
	ld (wTmpcbb4),a
	xor a
	ld (wScrollMode),a
	jr jabuOpen_incState
@state1:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @cbb3_00
	.dw @cbb3_01
	.dw @cbb3_02
	.dw @cbb3_03
@cbb3_00:
	call jabuOpen_decCBB4
	ret nz
	ld (hl),$3c
	call reloadTileMap
	callab bank1.checkInitUnderwaterWaves
	jr jabuOpen_incCBB3
@cbb3_01:
	call jabuOpen_decCBB4
	ret nz
	ld (hl),$3c
	jr jabuOpen_incCBB3
@cbb3_02:
	ld a,$3c
	call setScreenShakeCounter
	call jabuOpen_decCBB4
	ret nz
	ld (hl),$3c
	call jabuOpen_incCBB3
	ldbc, INTERACID_97 $01
	call objectCreateInteraction
	ld a,GFXH_JABU_OPENING_1
--
	call loadGfxHeader
	call reloadTileMap
	ld a,SND_DOORCLOSE
	jp playSound
@cbb3_03:
	ld a,$3c
	call setScreenShakeCounter
	call jabuOpen_decCBB4
	ret nz
	ld (hl),$3c
	call jabuOpen_incState
	ld a,GFXH_JABU_OPENING_2
	jr --
@state2:
	call jabuOpen_decCBB4
	ret nz
	ld a,SND_SOLVEPUZZLE
	call playSound
	ld a,CUTSCENE_INGAME
	ld (wCutsceneIndex),a
	ld a,$01
	ld (wScrollMode),a
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call loadTilesetAndRoomLayout
	jp loadRoomCollisions
	
	
cleanSeas_decCBB4:
	ld hl,wTmpcbb4
	dec (hl)
	ret nz
	ret
	
cleanSeas_incState:
	ld hl,wCutsceneState
	inc (hl)
	ret
	
cleanSeas_incCBB3:
	ld hl,wTmpcbb3
	inc (hl)
	ret

;;
; CUTSCENE_CLEAN_SEAS
func_03_7619:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld b,$10
	ld hl,wTmpcbb3
	call clearMemory
	call clearScreenVariablesAndWramBank1
	call refreshObjectGfx
	ld a,MUS_FAIRY_FOUNTAIN
	call playSound
	call cleanSeas_incState
	xor a
	ld bc, ROOM_AGES_1a5
@func_764a:
	push bc
	call disableLcd
	ld a,PALH_0f
	call loadPaletteHeader
	call clearOam
	call clearScreenVariablesAndWramBank1
	callab bank1.clearMemoryOnScreenReload
	call stopTextThread
	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	xor a
	pop bc
	call forceLoadRoom
	call func_131f
	call loadCommonGraphics
	ld a,$02
	jp loadGfxRegisterStateIndex
@state1:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @@cbb3_00
	.dw @@cbb3_01
	.dw @@cbb3_02
	.dw @@cbb3_03
@@cbb3_00:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$f0
	ld (wTmpcbb4),a
	jp cleanSeas_incCBB3
@@cbb3_01:
	ld a,(wFrameCounter)
	and $07
	jr nz,+
	call getFreePartSlot
	jr nz,+
	ld (hl),PARTID_SPARKLE
	call getRandomNumber
	and $7f
	ld c,a
	ld l,Part.yh
	call setShortPosition_paramC
+
	ld a,(wFrameCounter)
	and $1f
	ld a,SND_MAGIC_POWDER
	call z,playSound
	call cleanSeas_decCBB4
	ret nz
	ld (hl),$78
	ld a,$04
	call fadeoutToWhiteWithDelay
	ld a,SND_FADEOUT
	call playSound
	jp cleanSeas_incCBB3
@@cbb3_02:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call func_782a
	call func_782a
	call func_782a
	call func_782a
	ret z
	ld a,$04
	call fadeinFromWhiteWithDelay
	ld a,SND_FAIRYCUTSCENE
	call playSound
	jp cleanSeas_incCBB3
@@cbb3_03:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cleanSeas_decCBB4
	ret nz
	ld (hl),$3c
	call cleanSeas_incState
	xor a
	ld (wTmpcbb3),a
	ld bc, ROOM_AGES_1d2
	jp @func_764a
@state2:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @state1@cbb3_00
	.dw @state1@cbb3_01
	.dw @state1@cbb3_02
	.dw @@cbb3_03
@@cbb3_03:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cleanSeas_decCBB4
	ret nz
	ld (hl),$3c
	call cleanSeas_incState
	xor a
	ld (wTmpcbb3),a
	ld bc, ROOM_AGES_3b1
	call @func_764a
	ld hl,objectData.objectData7e71
	jp parseGivenObjectData
@state3:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @state1@cbb3_00
	.dw @state1@cbb3_01
	.dw @state1@cbb3_02
	.dw @@cbb3_03
@@cbb3_03:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,$cfc0
	bit 7,(hl)
	ret z
	res 7,(hl)
	call cleanSeas_incState
	xor a
	ld (wTmpcbb3),a
	ld a,$3c
	ld (wTmpcbb4),a
	ld bc, ROOM_AGES_3b0
	call @func_764a
	ld hl,objectData.objectData7e7b
	jp parseGivenObjectData
@state4:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @state1@cbb3_00
	.dw @state1@cbb3_01
	.dw @state1@cbb3_02
	.dw @@cbb3_03
@@cbb3_03:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,$cfc0
	bit 7,(hl)
	ret z
	ld a,$3c
	ld (wTmpcbb4),a
	call cleanSeas_incState
	xor a
	ld (wTmpcbb3),a
	ld bc, ROOM_AGES_1a3
	call @func_764a
	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$38
	ld l,<w1Link.xh
	ld (hl),$68
	ld l,<w1Link.direction
	ld (hl),DIR_DOWN
	jp setLinkForceStateToState08
@state5:
	ld a,(wTmpcbb3)
	ld e,a
	or a
	jr z,+
	ld a,(wFrameCounter)
	and $1f
	jr nz,+
	ld a,(w1Link.direction)
	and $02
	xor $02
	or $01
	ld (w1Link.direction),a
+
	ld a,e
	rst_jumpTable
	.dw @state1@cbb3_00
	.dw @state1@cbb3_01
	.dw @state1@cbb3_02
	.dw @@cbb3_03
@@cbb3_03:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,$cfc0
	bit 7,(hl)
	ret z
	ld a,$3c
	ld (wTmpcbb4),a
	ld a,SND_SOLVEPUZZLE_2
	call playSound
	jp cleanSeas_incState
@state6:
	call cleanSeas_decCBB4
	ret nz
	ld a,$01
	ld (wScrollMode),a
	callab bank1.calculateRoomEdge
	callab bank1.func_49c9
	callab bank1.setObjectsEnabledTo2
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld a,(wLoadingRoomPack)
	ld (wRoomPack),a
	ld a,(wActiveRoom)
	ld (wLoadingRoom),a
	ld a,$36
	ld (wEnteredWarpPosition),a
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	ld a,CUTSCENE_LOADING_ROOM
	ld (wCutsceneIndex),a
	ld a,$02
	ld (w1Link.direction),a
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call setGlobalFlag
	jp setDeathRespawnPoint
	
func_782a:
	ld a,$eb
	call findTileInRoom
	ret nz
	ld c,l
	ld a,(wTilesetFlags)
	and $40
	ld a,$fc
	jr z,+
	ld a,$3a
+
	call setTile
	xor a
	ret

.include "code/ages/cutscenes/linkedGameCutscenes.s"

blackTowerEscapeAttempt_incState:
	ld hl,wCutsceneState
	inc (hl)
	ret


	ld hl,wTmpcbb3
	inc (hl)
	ret

blackTowerEscapeAttempt_decCBB4:
	ld hl,wTmpcbb4
	dec (hl)
	ret

blackTowerEscapeAttempt_loadNewRoom:
	call disableLcd
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics
	jp func_131f

;;
; CUTSCENE_BLACK_TOWER_ESCAPE_ATTEMPT
func_03_7cb7:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
@state0:
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	ld hl,wTmpcbb3
	ld b,$10
	call clearMemory
	call clearWramBank1
	call refreshObjectGfx
	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,$3c
	ld (wTmpcbb4),a
	call blackTowerEscapeAttempt_incState
	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$58
	inc l
	inc l
	ld (hl),$78
	ld l,<w1Link.direction
	ld (hl),DIR_DOWN
	call resetCamera
	ld a,$00
	ld (wScrollMode),a
	ld hl,objectData.objectData7e85
	call parseGivenObjectData
	ld a,$04
	jp fadeinFromWhiteWithDelay
@state1:
	ld a,(wTmpcbb5)
	cp $04
	ret nz
	call blackTowerEscapeAttempt_decCBB4
	jr z,@func_7d33
	ld a,(hl)
	cp $01
	ret nz
	ld a,$0b
	ld (wLinkForceState),a
	ld a,$50
	ld (wLinkStateParameter),a
	ld a,$10
	ld ($d009),a
	ret
@func_7d33:
	ld (hl),$10
	call blackTowerEscapeAttempt_incState
	ld a,$04
	jp fadeoutToWhiteWithDelay
@state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	call blackTowerEscapeAttempt_incState
	ld a,$f3
	ld (wActiveRoom),a
	call blackTowerEscapeAttempt_loadNewRoom
	ld hl,w1Link.yh
	ld (hl),$78
	inc l
	inc l
	ld (hl),$78
	call resetCamera
	call loadCommonGraphics
	ld a,$04
	call fadeinFromWhiteWithDelay
	ld a,$02
	jp loadGfxRegisterStateIndex
@state3:
	ld a,$00
	ld (wScrollMode),a
	ld a,$f8
	ld (w1Link.yh),a
	ld a,$05
	ld (wTmpcbb5),a
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call blackTowerEscapeAttempt_decCBB4
	ret nz
	ld a,$0b
	ld (wLinkForceState),a
	ld a,$60
	ld (wLinkStateParameter),a
	ld a,$10
	ld ($d009),a
	jp blackTowerEscapeAttempt_incState
@state4:
	ld a,(wTmpcbb5)
	cp $06
	ret nz
	call func_7e40
	ld a,(wScreenShakeCounterY)
	dec a
	jr z,@func_7dbc
	and $1f
	ret nz
	ld a,(w1Link.direction)
	ld c,a
	rra
	xor c
	bit 0,a
	ld a,c
	jr z,@func_7db6
	xor $01
	jr ++
@func_7db6:
	xor $02
++
	ld (w1Link.direction),a
	ret
@func_7dbc:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_EXCLAMATION_MARK
	ld l,Interaction.counter1
	ld a,30
	ld (hl),a
	ld (wTmpcbb4),a
	ld a,(w1Link.yh)
	sub $10
	ld l,Interaction.yh
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	ld (hl),a
	ld a,SND_CLINK
	call playSound
	call blackTowerEscapeAttempt_incState
@state5:
	call func_7e40
	call blackTowerEscapeAttempt_decCBB4
	ret nz
	ld a,$0b
	ld (wLinkForceState),a
	ld a,$10
	ld (wLinkStateParameter),a
	ld hl,w1Link.direction
	ld a,DIR_DOWN
	ldi (hl),a
	ld (hl),ANGLE_DOWN
	ld a,$07
	ld (wTmpcbb5),a
	xor a
	ld ($cfde),a
	call getFreeInteractionSlot
	ld (hl),INTERACID_FALLING_ROCK
	ld l,Interaction.var03
	ld (hl),$01
	call getFreeInteractionSlot
	ld (hl),INTERACID_VERAN_CUTSCENE_WALLMASTER
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	add $10
	ldi (hl),a
	ld a,(w1Link.xh)
	inc l
	ld (hl),a
	jp blackTowerEscapeAttempt_incState
@state6:
	call func_7e40
	ld a,(wTmpcbb5)
	cp $08
	ret nz
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	xor a
	ld (wActiveMusic),a
	inc a
	ld (wCutsceneIndex),a
	ld hl,@warpDest
	jp setWarpDestVariables

@warpDest:
	m_HardcodedWarpA ROOM_AGES_5d7, $05, $77, $03

func_7e40:
	ld a,(wScreenShakeCounterY)
	and $0f
	ld a,SND_RUMBLE
	call z,playSound
	ld a,(wScreenShakeCounterY)
	or a
	ld a,$ff
	jp z,setScreenShakeCounter
	ret
