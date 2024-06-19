;;
; CUTSCENE_S_PIRATES_DEPART
cutsceneHandler_0c:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw cutsceneHandler_0c_stage0 ; initial
	.dw cutsceneHandler_0c_stage1 ; digging through subrosia
	.dw cutsceneHandler_0c_stage2 ; inside ship
	.dw cutsceneHandler_0c_stage3 ; out in samasa desert
	.dw cutsceneHandler_0c_stage4 ; back inside ship
	.dw cutsceneHandler_0c_stage5 ; approaching west coast

cutsceneHandler_0c_stage0:
	ld b,$10
	ld hl,$cbb3
	call clearMemory
	call clearWramBank1
	xor a
	ld (wDisabledObjects),a
	ld (wScrollMode),a
	ld a,(wGfxRegs2.SCY)
	ld ($cbba),a
	ld a,$80
	ld (wMenuDisabled),a
	ld a,$01
	ld (wCutsceneState),a
	ret

cutsceneHandler_0c_stage1:
	call seasonsFunc_03_6b6c
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,($cbb3)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

@state0:
	call incCbb3
	ld a,$08
	ld ($cbb8),a
	ld a,$04
	ld ($cbb4),a
	ld a,GFXH_PIRATE_SHIP_LEAVING_SUBROSIA_LAYOUT
	call loadGfxHeader
	ld a,GFXH_PIRATE_SHIP_MOVING_EXTRA_TILES
	call loadGfxHeader
	ld a,$04
	ldh (<hNextLcdInterruptBehaviour),a
	call seasonsFunc_03_681a
	jp seasonsFunc_03_67f8
@state0Func0:
	ld hl,@subrosianSandReplacementPositions
	ld d,$0f
-
	ldi a,(hl)
	ld c,a
	ld a,$0f
	push hl
	call setTile
	pop hl
	dec d
	jr nz,-
	ret
@subrosianSandReplacementPositions:
	.db $04 $05 $06 $07 $08
	.db $14 $15 $16 $17 $18
	.db $24 $25 $26 $27 $28

@state1:
	ld hl,$cbb4
	dec (hl)
	ret nz
	ld bc,TX_4e00
	call showText
	call @state0Func0
	jp incCbb3

@state2:
	call retIfTextIsActive
	ld hl,objectData.objectData_sandPuffsFromShipDigging
	call parseGivenObjectData
	ld a,MUS_TRIUMPHANT
	call playSound
	jp incCbb3

@state3:
	call incCbbfAndCbb8
	ld a,(hl)
	cp $10
	jr c,+
	call seasonsFunc_03_681a
	jr nz,+
	call incCbb3
+
	jp seasonsFunc_03_67f8

@state4:
	call incCbbfAndCbb8
	ld a,(hl)
	cp $30
	jr c,seasonsFunc_03_67f8
	call fadeoutToWhite
	call incCbb3
	jr seasonsFunc_03_67f8

@state5:
	call incCbbfAndCbb8
	ld a,(wPaletteThread_mode)
	or a
	jr nz,seasonsFunc_03_67f8
	ld a,$c7
	ld (wGfxRegs1.WINY),a
	ld (wGfxRegs2.WINY),a
	ld a,$03
	ldh (<hNextLcdInterruptBehaviour),a
	ld a,$02
seasonsFunc_03_67e9:
	ld (wCutsceneState),a
	xor a
	ld ($cfc0),a
	ld b,$10
	ld hl,$cbb3
	jp clearMemory

seasonsFunc_03_67f8:
	ld a,$40
	ld (wGfxRegs2.LYC),a
	ld a,$47
	ld (wGfxRegs2.WINX),a
	ld a,$a5
	ld (wGfxRegs1.WINX),a
	ld a,($cbb8)
	ld (wGfxRegs2.WINY),a
	ld (wGfxRegs1.WINY),a
	ld ($cbbc),a
	jr seasonsFunc_03_684c

incCbb3:
	ld hl,$cbb3
	inc (hl)
	ret

seasonsFunc_03_681a:
	ld a,($cbb7)
	ld hl,seasonsTable_03_6844
	rst_addAToHl
	ld a,(hl)
	cp $ff
	ret z
	ld l,a
	ld h,$d0
	push hl
	ld de,$9c00
	ld bc,$0f02
	call queueDmaTransfer
	pop hl
	set 2,h
	ld e,$01
	call queueDmaTransfer
	ld a,$08
	ld ($cbb8),a
	ld hl,$cbb7
	inc (hl)
	ret

seasonsTable_03_6844:
	.db $c0 $a0 $80 $60
	.db $40 $20 $00 $ff

seasonsFunc_03_684c:
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld a,($cbb8)
	and $07
	ld hl,$d800
	rst_addDoubleIndex
	ld de,$d9e0
	ld b,$10
	call copyMemory
	ld a,($cbb8)
	and $07
	ld hl,$d820
	rst_addDoubleIndex
	ld de,$d9f0
	ld b,$10
	call copyMemory
	ld a,$00
	ld ($ff00+R_SVBK),a
	ld hl,$d9e0
	ld de,$94e1
	ld bc,$0102
	jp queueDmaTransfer

cutsceneHandler_0c_stage2:
	ld a,($cbb3)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@seasonsFunc_03_688c:
	call disableLcd
	call clearScreenVariablesAndWramBank1
	call incCbb3
	ld bc,ROOM_SEASONS_5d4
	call cutsceneHandler_0c_stage3@loadNewRoom
	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$58
	ld l,<w1Link.xh
	ld (hl),$70
	ld l,<w1Link.direction
	ld (hl),$02
	xor a
	ld (wLinkForceState),a
	ld a,$01
	ld (wScreenShakeMagnitude),a
	call resetCamera
	ld a,$02
	jp cutsceneHandler_0c_stage3@state0Func1

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call @seasonsFunc_03_688c
	ld hl,objectData.objectData_insidePirateShipLeavingSubrosia
	jp parseGivenObjectData

@state1:
	ret

@state2:
	ld a,$03
	call seasonsFunc_03_67e9
	jp fadeoutToWhite

cutsceneHandler_0c_stage3:
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
	call disableLcd
	call clearScreenVariablesAndWramBank1
	call incCbb3
	ld a,$40
	ld ($cbb8),a
	ld ($cbbf),a
	ld a,$1e
	ld ($cbb4),a
	ld a,$01
	ld (wRoomStateModifier),a
	ld bc,ROOM_SEASONS_0fe
	call @loadNewRoom
	call @state0Func2
	ld e,$0c
	call loadObjectGfxHeaderToSlot4
	ld a,GFXH_PIRATE_SHIP_LEAVING_DESERT_LAYOUT
	call loadGfxHeader
	ld hl,objectData.objectData_leavingSamasaDesert
	call parseGivenObjectData
	ld a,$11
	jr @state0Func1
@loadNewRoom:
	ld a,b
	ld (wActiveGroup),a
	ld a,c
	ld (wActiveRoom),a
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics
	jp func_131f
@state0Func1:
	push af
	ld a,$01
	ld (wScrollMode),a
	call fadeinFromWhite
	call loadCommonGraphics
	pop af
	jp loadGfxRegisterStateIndex
@state0Func2:
	ld hl,@state0Table0
-
	ldi a,(hl)
	cp $ff
	ret z
	ld c,a
	ldi a,(hl)
	push hl
	call setTile
	pop hl
	jr -
@state0Table0:
	; position - tile - position - tile
	.db $05 $ad $06 $ad
	.db $08 $ae $09 $ae
	.db $15 $ad $16 $ad
	.db $18 $ae $19 $ae
	.db $25 $ad $26 $ad
	.db $28 $ae $29 $ae
	.db $35 $ad $36 $ad
	.db $38 $ae $39 $ae
	.db $ff

@state1:
	ld hl,$cbb4
	dec (hl)
	ret nz
	call incCbb3
	xor a
	ldh (<hCameraY),a
	ldh (<hCameraX),a
	ld bc,TX_4e09
	jp showText

@state2:
	call retIfTextIsActive
	ld a,$ff
	ld ($cfc0),a
	jp incCbb3

@state3:
	ld a,(wFrameCounter)
	and $07
	ret nz
	call incCbbfAndCbb8
	ld a,(hl)
	cp $70
	jr c,seasonsFunc_03_69d1
	call fadeoutToWhite
	ld a,$fb
	call playSound
	call incCbb3
	jr seasonsFunc_03_69d1

@state4:
	ld a,(wFrameCounter)
	and $07
	ret nz
	call incCbbfAndCbb8
	ld a,(wPaletteThread_mode)
	or a
	jr nz,seasonsFunc_03_69d1
	ld a,$c7
	ld (wGfxRegs1.WINY),a
	ld (wGfxRegs2.WINY),a
	ld a,$04
	ld (wCutsceneState),a
	ld b,$10
	ld hl,$cbb3
	jp clearMemory

seasonsFunc_03_69d1:
	ld a,$a5
	ld (wGfxRegs1.WINX),a
	ld a,($cbb8)
	ld (wGfxRegs2.WINY),a
	ld (wGfxRegs1.WINY),a
	ld ($cbbc),a
	ret

cutsceneHandler_0c_stage4:
	ld a,($cbb3)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cutsceneHandler_0c_stage2@seasonsFunc_03_688c
	xor a
	ld ($cfc0),a
	ld hl,objectData.objectData_sickPiratiansInShip
	jp parseGivenObjectData

@state1:
	ret

@state2:
	ld a,$05
	call seasonsFunc_03_67e9
	jp fadeoutToWhite

cutsceneHandler_0c_stage5:
	call seasonsFunc_03_6b6c
	ld a,($cbb3)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call disableLcd
	call clearScreenVariablesAndWramBank1
	call incCbb3
	ld a,$90
	ld ($cbb8),a
	ld ($cbbf),a
	ld a,$10
	ld ($cbbd),a
	ld a,$03
	ld (wRoomStateModifier),a
	ld bc,ROOM_SEASONS_0f2
	call cutsceneHandler_0c_stage3@loadNewRoom
	ld a,$ff
	ld ($cd25),a
	ld e,$00
	call loadObjectGfxHeaderToSlot4
	ld a,GFXH_PIRATE_SHIP_ARRIVING_LAYOUT
	call loadGfxHeader
	ld a,GFXH_PIRATE_SHIP_MOVING_EXTRA_TILES
	call loadGfxHeader
	ld hl,objectData.objectData_pirateShipEnteringWestCoast
	call parseGivenObjectData
	ld a,$12
	jp cutsceneHandler_0c_stage3@state0Func1

@state1:
	ld a,(wFrameCounter)
	and $03
	jr nz,@state1Func0
	call decCbbfAndCbb8
	ld a,(hl)
	cp $09
	jp nc,@state1Func0
	call seasonsFunc_03_6b30
	call incCbb3
@state1Func0:
	call seasonsFunc_03_69d1
	jr seasonsFunc_03_6aca

@state2:
	ld a,(wFrameCounter)
	and $07
	jr nz,@state1Func0
	call decCbbfAndCbb8
	ld a,(hl)
	cp $09
	jr nc,@state1Func0
	call seasonsFunc_03_6b30
	jr nz,@state1Func0
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	call setGlobalFlag
	xor a
	ld (wActiveMusic),a
	ld hl,@state2WarpDestVariables
	jp setWarpDestVariables
@state2WarpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_0e2 $0f $66 $03

seasonsFunc_03_6a9d:
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld a,($cbbe)
	dec a
	and $03
	ld hl,seasonsTable_03_6b1a
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,($cbb8)
	and $07
	rst_addDoubleIndex
	ld de,$d9e0
	call seasonsFunc_03_6b22
	ld a,$00
	ld ($ff00+R_SVBK),a
	ld hl,$d9e0
	ld de,$8ce0
	ld bc,$0102
	jp queueDmaTransfer

seasonsFunc_03_6aca:
	ld hl,$cbbd
	dec (hl)
	jr nz,seasonsFunc_03_6a9d
	ld (hl),$10
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld a,($cbbe)
	ld hl,seasonsTable_03_6b1a
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld de,$d9c0
	push hl
	call seasonsFunc_03_6b22
	pop hl
	ld a,($cbb8)
	and $07
	rst_addDoubleIndex
	ld de,$d9e0
	call seasonsFunc_03_6b22
	ld a,$00
	ld ($ff00+R_SVBK),a
	ld hl,$d9c0
	ld de,$88e1
	ld bc,$0102
	call queueDmaTransfer
	ld hl,$d9e0
	ld de,$8ce0
	ld bc,$0102
	call queueDmaTransfer
	ld a,($cbbe)
	inc a
	and $03
	ld ($cbbe),a
	ret

seasonsTable_03_6b1a:
	.db $40 $d8
	.db $80 $d8
	.db $c0 $d8
	.db $00 $d9

seasonsFunc_03_6b22:
	ld b,$10
	call copyMemory
	ld bc,$0010
	add hl,bc
	ld b,$10
	jp copyMemory

seasonsFunc_03_6b30:
	ld a,($cbb7)
	ld hl,seasonsTable_03_6b59
	rst_addDoubleIndex
	ldi a,(hl)
	cp $ff
	ret z
	ld h,(hl)
label_03_196:
	ld l,a
	push hl
	ld de,$9c00
	ld bc,$2102
	call queueDmaTransfer
	pop hl
	set 2,h
	ld e,$01
	call queueDmaTransfer
	ld a,$10
	ld ($cbb8),a
	ld hl,$cbb7
	inc (hl)
	ret

seasonsTable_03_6b59:
	.db $20 $d0
	.db $40 $d0
	.db $60 $d0
	.db $80 $d0
	.db $a0 $d0
	.db $c0 $d0
	.db $e0 $d0
	.db $00 $d1
	.db $20 $d1
	.db $ff

seasonsFunc_03_6b6c:
	ld hl,oamData_03_6b72
	jp addSpritesToOam

oamData_03_6b72:
	.db $01
	.db $10 $a6 $4c $09

incCbbfAndCbb8:
	ld hl,$cbbf
	inc (hl)
	ld hl,$cbb8
	inc (hl)
	ret

decCbbfAndCbb8:
	ld hl,$cbbf
	dec (hl)
	ld hl,$cbb8
	dec (hl)
	ret
