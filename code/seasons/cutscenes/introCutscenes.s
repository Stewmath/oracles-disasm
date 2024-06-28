; TODO: this is more than just intro cutscenes, rename this

multiIntroCutsceneHandler:
	ld a,e
	rst_jumpTable
	.dw cutsceneDinDancing
	.dw cutsceneDinImprisoned
	.dw cutsceneTempleSinking
	.dw cutscenePregameIntro
	.dw cutsceneOnoxTaunting

cutsceneDinDancing:
	call cutsceneDinDancingHandler
	ld hl,wCutsceneState
	ld a,(hl)
	cp $02
	ret z
	cp $03
	ret z
	jp updateAllObjects

cutsceneDinDancingHandler:
	ld de,wCutsceneState
	ld a,(de)
	rst_jumpTable
	.dw cutscene06Func0
	.dw cutscene06Func1
	.dw cutscene06Func2 ; don't updateAllObjects
	.dw cutscene06Func3 ; don't updateAllObjects
	.dw cutscene06Func4
	.dw cutscene06Func5
	.dw cutscene06Func6
	.dw cutscene06Func7
	.dw cutscene06Func8
	.dw cutscene06Func9
	.dw cutscene06Funca
	.dw cutscene06Funcb
	.dw cutscene06Funcc
	.dw cutscene06Funcd
	.dw cutscene06Funce
	.dw cutscene06Funcf
cutscene06Func0:
	ld a,$01
	ld (de),a
	ld a,SND_CLOSEMENU
	call playSound
cutscene06Func1:
	ld a,$ff
	ld (wTilesetAnimation),a
	ld a,$01
	ld ($cfd0),a
	ld hl,$cc02
	ld (hl),$01
	ld hl,$d01a
	res 7,(hl)
	call saveGraphicsOnEnterMenu
	ld a,GFXH_DIN_DANCING_CUTSCENE
	call loadGfxHeader
	ld a,PALH_SEASONS_95
	call loadPaletteHeader
	ld a,$04
	call loadGfxRegisterStateIndex
	ld hl,$cbb3
	ld (hl),$58
	inc hl
	ld (hl),$02
	ld hl,$cbb6
	ld (hl),$28
	call fastFadeinFromWhite
	call incCutsceneState2
	ld hl,$cbb5
	ld (hl),$02
	
seasonsFunc_03_7386:
	call clearOam
	ld b,$00
	ld a,(wGfxRegs1.SCX)
	cpl
	inc a
	ld c,a
	ld hl,seasonsOamData_03_7397
	jp addSpritesToOam_withOffset

seasonsOamData_03_7397:
	.db $24
	.db $51 $3f $1e $06
	.db $40 $0c $08 $01
	.db $4f $0c $28 $01
	.db $5c $30 $20 $02
	.db $5c $38 $22 $01
	.db $4c $3f $04 $01
	.db $50 $4a $06 $02
	.db $40 $14 $0a $01
	.db $4f $14 $2a $01
	.db $61 $64 $0c $01
	.db $61 $6c $0e $01
	.db $71 $64 $2c $01
	.db $71 $6c $2e $01
	.db $88 $38 $10 $00
	.db $69 $50 $26 $04
	.db $69 $48 $24 $04
	.db $4c $2f $00 $01
	.db $4c $37 $02 $01
	.db $53 $30 $12 $05
	.db $53 $38 $14 $05
	.db $11 $86 $42 $03
	.db $17 $88 $16 $04
	.db $37 $a2 $30 $04
	.db $37 $aa $32 $04
	.db $21 $9f $18 $05
	.db $21 $a7 $1a $05
	.db $22 $9e $1c $03
	.db $73 $b0 $34 $04
	.db $73 $b8 $36 $04
	.db $3a $9c $38 $03
	.db $3b $2b $3a $03
	.db $3b $33 $3c $03
	.db $40 $42 $3e $03
	.db $70 $80 $40 $03
	.db $90 $34 $44 $06
	.db $90 $3c $46 $06

cutscene06Func2:
	ld a,(wPaletteThread_mode)
	or a
	jp nz,seasonsFunc_03_7386
	call seasonsFunc_03_7458
	call seasonsFunc_03_7386
	ld hl,$cbb3
	call decHlRef16WithCap
	jr z,+
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld bc,$00f0
	call compareHlToBc
	ret nc
	ld a,($c482)
	and $01
	ret z
+
	ld a,SND_CLOSEMENU
	call playSound
	call incCutsceneState2
	jp fastFadeoutToWhite
	
seasonsFunc_03_7458:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld hl,$cbb6
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ld hl,$c487
	inc (hl)
	ret
cutscene06Func3:
	ld a,(wPaletteThread_mode)
	or a
	jp nz,seasonsFunc_03_7386
	xor a
	ld (wTilesetAnimation),a
	ld hl,$d01a
	set 7,(hl)
	xor a
	ld ($cfd0),a
	call incCutsceneState2
	jp reloadGraphicsOnExitMenu

cutscene06Func4:
	ld a,($cfd0)
	cp $02
	ret nz
	ld hl,$cbb4
	xor a
	ld (hl),a
	call seasonsFunc_03_74aa
	ld hl,$de90
	ld bc,$44e8
	call func_13c6
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	jp incCutsceneState2

seasonsFunc_03_74a3:
	call decCbb3
	ret nz
	inc l
	inc (hl)
	ld a,(hl)
	
seasonsFunc_03_74aa:
	ld d,h
	ld e,l
	add a
	ld hl,seasonsTable_03_74d1
	rst_addDoubleIndex
	dec e
	ldi a,(hl)
	ld (de),a
	inc a
	ret z

seasonsFunc_03_74b6:
	ld d,h
	ld e,l
	call getFreePartSlot
	jr nz,+
	ld (hl),PARTID_LIGHTNING
	ld l,Part.subid
	inc (hl)
	inc l
	ld a,(de)
	ld (hl),a
	inc de
	ld l,Part.yh
	ld a,(de)
	ldi (hl),a
	inc de
	inc hl
	ld a,(de)
	ld (hl),a
+
	or $01
	ret

seasonsTable_03_74d1:
	.db $3c $00 $50 $20
	.db $3c $01 $70 $58
	.db $28 $00 $40 $80
	.db $28 $00 $18 $30
	.db $1e $02 $10 $80
	.db $1e $00 $40 $48
	.db $14 $00 $20 $70
	.db $14 $04 $78 $88
	.db $14 $08 $70 $70
	.db $14 $00 $40 $40
	.db $ff

seasonsTable_03_74fa:
	.db $10 $70 $18
	
cutscene06Func5:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,$cfd0
	ld (hl),$03
	call seasonsFunc_03_7516
	call seasonsFunc_03_74a3
	ret nz
	ld hl,$cbb3
	ld (hl),$3c
	jp incCutsceneState2

seasonsFunc_03_7516:
	ld de,$cfd2
	ld b,$03
-
	ld a,(de)
	ld c,a
	ld a,b
	ld hl,bitTable
	add l
	ld l,a
	ld a,(hl)
	and c
	call nz,cutsceneDinDancing_loadListOfTiles
	dec b
	bit 7,b
	jr z,-
	ret

;;
; @param	b	index of tile list in table below
cutsceneDinDancing_loadListOfTiles:
	xor c
	ld (de),a
	push bc
	push de
	ld a,b
	ld hl,@tileListTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld b,(hl)
	inc hl
-
	ld c,(hl)
	inc hl
	ld e,c
	ld d,$cf
	ld a,(de)
	push bc
	push hl
	call setTile
	pop hl
	pop bc
	dec b
	jr nz,-
	pop de
	pop bc
	ret
@tileListTable:
	.dw @tileList1
	.dw @tileList2
	.dw @tileList3
	.dw @tileList4
	; numTiles -> list of tile indices
@tileList1:
	.db $02 $65 $75
@tileList2:
	.db $03 $07 $08 $18
@tileList3:
	.db $01	$78
@tileList4:
	.db $04 $66 $67 $76 $77
	
cutscene06Func6:
	call decCbb3
	ret nz
	call incCutsceneState2
	ld bc,$0c08
	call checkIsLinkedGame
	jr z,+
	ld bc,$0c12
+
	jp showText
	
cutscene06Func7:
	call retIfTextIsActive
	call incCutsceneState2
	ld hl,seasonsTable_03_74fa
	jp seasonsFunc_03_74b6
	
cutscene06Func8:
	ld hl,$cfd2
	ld a,(hl)
	bit 4,a
	ret z
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_DIN_DANCING_EVENT
	inc l
	ld (hl),$07
+
	jp incCutsceneState2
	
cutscene06Func9:
	ld c,$09
	call checkIsLinkedGame
	jr z,+
	ld c,$13
+
	ld a,$05

seasonsFunc_03_75a5:
	ld b,a
	ld hl,$cfd0
	ld a,(hl)
	cp b
	ret nz
	call incCutsceneState2
	ld b,$0c
	jp showText
	
cutscene06Funca:
	call retIfTextIsActive
	ld hl,$cfd0
	ld (hl),$06
	jp incCutsceneState2
	
cutscene06Funcb:
	ld a,$08
	ld c,$14
	jp seasonsFunc_03_75a5
	
cutscene06Funcc:
	call retIfTextIsActive
	ld hl,$cbb3
	ld (hl),$1e
	jp incCutsceneState2
	
cutscene06Funcd:
	call decCbb3
	ret nz
	ld hl,$cfd0
	ld (hl),$09
	jp incCutsceneState2
	
cutscene06Funce:
	ld hl,$cfd0
	ld a,(hl)
	cp $0b
	ret nz
	ld hl,$cbb3
	ld (hl),$3c
	jp incCutsceneState2
	
cutscene06Funcf:
	call decCbb3
	ret nz
	call clearOam
	call cutscene_clearObjects
	ld a,CUTSCENE_S_DIN_IMPRISONED
	ld (wCutsceneIndex),a
	xor a
	ld (wMenuDisabled),a
	ld (wCutsceneState),a
	ld a,GLOBALFLAG_SEASON_ALWAYS_SPRING
	call unsetGlobalFlag
	jp fadeoutToWhite


cutsceneDinImprisoned:
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
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$01
	ld (de),a
	ld a,$09
	ld ($cfd0),a
	ld hl,$cbb3
	ld (hl),$58
	inc l
	ld (hl),$01
	ld a,$09
	ld b,$00
	call seasonsFunc_03_7aa9
	ld a,MUS_ONOX_CASTLE
	call playSound
	jp fadeinFromWhite

@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,$cbb3
	call decHlRef16WithCap
	jr nz,+
	xor a
	ld (wGfxRegs1.SCY),a
	call incCutsceneState2
	jp fadeoutToWhite
+
	ld hl,$cbb3
	ld a,(hl)
	and $01
	ret nz
	ld hl,wGfxRegs1.SCY
	ld a,(hl)
	or a
	ret z
	dec a
	ld (hl),a
	ldh (<hCameraY),a
	ret

@state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCutsceneState2
	ld a,$0a
	ld ($cfd0),a
	call disableLcd
	xor a
	ld (wScreenOffsetY),a
	ld (wScreenOffsetX),a
	ld a,GFXH_SCENE_INSIDE_ONOX_CASTLE
	call loadGfxHeader
	ld a,PALH_SEASONS_97
	call loadPaletteHeader
	ld a,$01
	ld (wScrollMode),a
	ld a,$18
	ld (wTilesetAnimation),a
	call loadAnimationData
	call getFreeInteractionSlot
	jr nz,+
	ld a,INTERACID_DIN_IMPRISONED_EVENT
	ldi (hl),a
	ld (hl),$00
	ld ($cc1d),a
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_DIN_IMPRISONED_EVENT
	inc l
	ld (hl),$01
+
	call refreshObjectGfx
	ld a,$0d
	call loadGfxRegisterStateIndex
	ld hl,wGfxRegs1.SCY
	ldi a,(hl)
	ldh (<hCameraY),a
	ld a,(hl)
	ldh (<hCameraX),a
	jp fadeinFromWhite
@state3:
	ld hl,$cfd0
	ld a,(hl)
	cp $0b
	ret nz
	ld b,$04
-
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_DIN_IMPRISONED_EVENT
	inc l
	ld (hl),$02
	inc l
	dec b
	ld a,b
	ld (hl),a
	jr nz,-
+
	jp incCutsceneState2

@state4:
	ld a,($cfd0)
	sub $0c
	ret nz
	ld ($cbb3),a
	dec a
	ld ($cbba),a
	jp incCutsceneState2

@state5:
	ld hl,$cbb3
	ld b,$01
	call flashScreen
	ret z
	call disableLcd
	ld a,$01
	ldh (<hDirtyBgPalettes),a
	ld a,$fe
	ldh (<hBgPaletteSources),a
	ld a,$81
	call seasonsFunc_03_7a6b
	ld a,$81
	ld ($cbcb),a
	call seasonsFunc_03_7a88
	ld bc,TX_1e05
	call showText
	ld a,$0d
	call loadGfxRegisterStateIndex
	ld hl,wGfxRegs1.SCY
	ldi a,(hl)
	ldh (<hCameraY),a
	ld a,(hl)
	ldh (<hCameraX),a
	ld hl,$cfd0
	ld (hl),$0d
	jp incCutsceneState2

@state6:
	call retIfTextIsActive
	call disableLcd
	ld a,UNCMP_GFXH_0e
	call loadUncompressedGfxHeader
	ld a,SND_CLINK
	call playSound
	ld a,$0d
	call loadGfxRegisterStateIndex
	call fadeinFromWhite
	ld hl,$cbb3
	ld (hl),$f0
	xor a
	ld ($cbcb),a
	jp incCutsceneState2

@state7:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call decCbb3
	ret nz
	call incCutsceneState2
	jp fadeoutToWhite

@state8:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCutsceneState2
	ld a,$ff
	ld (wTilesetAnimation),a
	ld a,$0e
	ld ($cfd0),a
	ld a,$07
	ld b,$01
	call seasonsFunc_03_7aa9
	jp fadeinFromWhite

@state9:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,$cfd0
	ld a,(hl)
	cp $0f
	ret nz

	call clearDynamicInteractions
	ld a,CUTSCENE_S_TEMPLE_SINKING
	ld (wCutsceneIndex),a
	xor a
	ld (wCutsceneState),a
	jp fadeoutToWhite


cutsceneTempleSinking:
	ld de,wCutsceneState
	ld a,(de)
	rst_jumpTable
	.dw cutscene08Func0
	.dw cutscene08Func1
	.dw cutscene08Func2
	.dw cutscene08Func3
	.dw cutscene08Func4
	.dw cutscene08Func5
	.dw cutscene08Func6
	.dw cutscene08Func7
	.dw cutscene08Func8
cutscene08Func0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$01
	ld (de),a
	ld b,$02
-
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_77
	inc l
	dec b
	ld (hl),b
	jr nz,-
+
	call disableLcd
	ld a,GFXH_TEMPLEFALL_SCENE1
	call loadGfxHeader
	ld a,PALH_SEASONS_98
	call loadPaletteHeader
	ld a,$0e
	call loadGfxRegisterStateIndex
	ld hl,wGfxRegs1.SCY
	ldi a,(hl)
	ldh (<hCameraY),a
	ldi a,(hl)
	ldh (<hCameraX),a
	ld de,$cbb6
	ldi a,(hl)
	ld (de),a
	inc de
	ld a,(hl)
	ld (de),a
	ld hl,$cbb3
	ld (hl),$3c
	xor a
	ld hl,$cfd3
	ld (hl),a
	call seasonsFunc_03_79db
	ld a,MUS_DISASTER
	call playSound
	jp fadeinFromWhite
cutscene08Func1:
	ld a,(wPaletteThread_mode)
	or a
	jp nz,seasonsFunc_03_7827
	call decCbb3
	jr nz,seasonsFunc_03_7827
	ld b,$05
-
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_TEMPLE_SINKING_EXPLOSION
	inc l
	dec b
	ld a,b
	ld (hl),a
	jr nz,-
+
	ld hl,$cbb3
	ld (hl),$b4
	inc hl
	ld (hl),$00
	call incCutsceneState2

seasonsFunc_03_7827:
	jp seasonsFunc_03_7981
cutscene08Func2:
	call decCbb3
	jr nz,+
	call seasonsFunc_03_7a01
	xor a
	ld hl,$cbb4
	ld (hl),a
	call seasonsFunc_03_7917
	ld hl,$cfd3
	inc (hl)
	set 7,(hl)
	jp incCutsceneState2
+
	call seasonsFunc_03_7909
	jp seasonsFunc_03_7981
cutscene08Func3:
	call seasonsFunc_03_7981
	call decCbb3
	ret nz
	inc l
	inc (hl)
	ld a,(hl)
	cp $03
	jr z,+
	ld hl,$cfd3
	inc (hl)
	jp seasonsFunc_03_7917
+
	call disableLcd
	ld a,GFXH_TEMPLEFALL_SCENE1
	call loadGfxHeader
	ld a,PALH_SEASONS_98
	call loadPaletteHeader
	call seasonsFunc_03_7a17
	ld hl,$cbb3
	ld (hl),$78
	inc l
	ld (hl),$00
	ld hl,$cfd3
	inc (hl)
	res 7,(hl)
	jp incCutsceneState2
cutscene08Func4:
	call decCbb3
	jr nz,+
	call disableLcd
	ld a,$03
	inc l
	ld (hl),a
	call seasonsFunc_03_7917
	ld hl,$cfd3
	ld (hl),$ff
	call incCutsceneState2
	ld hl,$cbba
	ld (hl),$02
	ld hl,$cbb8
	jp seasonsFunc_03_7a3b
+
	call seasonsFunc_03_7909
	jp seasonsFunc_03_7981
cutscene08Func5:
	call seasonsFunc_03_7981
	call seasonsFunc_03_7a2e
	call decCbb3
	ret nz
	inc l
	inc (hl)
	ld a,(hl)
	cp $06
	jr z,+
	jp seasonsFunc_03_7917
+
	ld hl,$cbb3
	ld (hl),$3c
	call reloadObjectGfx
	ld a,$07
	ld b,$01
	call seasonsFunc_03_7aa9
	call clearPaletteFadeVariablesAndRefreshPalettes
	jp incCutsceneState2
cutscene08Func6:
	call decCbb3
	ret nz
	ld a,$01
	ld ($cc02),a
	ld bc,$1e04
	call showText
	jp incCutsceneState2
cutscene08Func7:
	call retIfTextIsActive
	call incCutsceneState2
	ld hl,$cbb3
	ld (hl),$5a
	jp fadeoutToBlack
cutscene08Func8:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call decCbb3
	ret nz
	xor a
	ld (wGameState),a
	ld (wCutsceneIndex),a
	ld c,a
	jpab bank1.loadDeathRespawnBufferPreset

seasonsFunc_03_7909:
	ld hl,$cbb4
	inc (hl)
	ld a,(hl)
	sub $07
	ret nz
	ld (hl),a
	ld hl,$cbb6
	inc (hl)
	ret

seasonsFunc_03_7917:
	ld ($cbbb),a
	ld hl,$cbb3
	ld (hl),$5a
	call disableLcd
	ld a,($cbbb)
	cp $03
	jr c,++
	sub $03
	ld hl,seasonsTable_03_797b
	rst_addDoubleIndex
	ld b,$00
	ldi a,(hl)
	ld c,(hl)
	call forceLoadRoom
	ld b,$31
	ld a,($cbbb)
	cp $05
	jr nz,+
	ld b,UNCMP_GFXH_0f
+
	ld a,b
	call loadUncompressedGfxHeader
	ld a,($cbbb)
++
	add GFXH_TEMPLEFALL_SCENE2
	call loadGfxHeader
	ld a,($cbbb)
	ld hl,seasonsTable_03_7972
	rst_addAToHl
	ld a,(hl)
	call loadPaletteHeader
	ld a,PALH_0f
	call loadPaletteHeader
	ld a,$04
	call loadGfxRegisterStateIndex
	ld a,($cbbb)
	sub $03
	ret c
	ld hl,seasonsTable_03_7978
	rst_addAToHl
	ld a,(hl)
	ld de,$cbb9
	ld (de),a
	ret

seasonsTable_03_7972:
	.db $5f $5f $5f $11 $13 $12

seasonsTable_03_7978:
	.db $02 $03 $01

seasonsTable_03_797b:
	.db SEASON_SUMMER, <ROOM_SEASONS_0b8
	.db SEASON_AUTUMN, <ROOM_SEASONS_0c6
	.db SEASON_AUTUMN, <ROOM_SEASONS_0c8

seasonsFunc_03_7981:
	call seasonsFunc_03_79bb
	ld hl,wFrameCounter
	ld a,(hl)
	and $0f
	ld a,SND_RUMBLE2
	call z,playSound
	ld de,$cbb5
	ld a,(de)
	cp $02
	jr z,+
	ld hl,$cbb4
	dec (hl)
	jr nz,+
	inc a
	ld (de),a
	call seasonsFunc_03_79db
+
	add a
	add a
	ld hl,seasonsTable_03_79e9
	rst_addDoubleIndex
	ld b,$00
	call seasonsFunc_03_79af
	ld b,$01

seasonsFunc_03_79af:
	ld de,wGfxRegs1.SCY
	dec b
	jr nz,+
	ld de,$c488
+
	jp seasonsFunc_03_79cd

seasonsFunc_03_79bb:
	ld hl,wGfxRegs1.SCY
	ldh a,(<hCameraY)
	ldi (hl),a
	ldh a,(<hCameraX)
	ldi (hl),a
	ld de,$cbb6
	ld a,(de)
	ldi (hl),a
	inc de
	ld a,(de)
	ldi (hl),a
	ret

seasonsFunc_03_79cd:
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

seasonsFunc_03_79db:
	ld b,a
	ld hl,seasonsTable_03_79e7
	rst_addAToHl
	ld a,(hl)
	ld hl,$cbb4
	ld (hl),a
	ld a,b
	ret

seasonsTable_03_79e7:
	.db $1e $14

seasonsTable_03_79e9:
	.db $00 $00 $00 $00 $00 $01 $00 $00
	.db $00 $00 $01 $00 $00 $00 $ff $00
	.db $ff $01 $00 $01 $00 $00 $ff $00

seasonsFunc_03_7a01:
	ld hl,$cbd5
	ld de,$c485
	ld b,$0c
-
	ld a,(de)
	ldi (hl),a
	inc e
	dec b
	jr nz,-
	call clearOam
	ld a,$10
	ldh (<hOamTail),a
	ret

seasonsFunc_03_7a17:
	ld hl,$cbd5
	ld de,$c485
	ld b,$0c
-
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,-
	ld a,($c485)
	ld ($c497),a
	ld ($ff00+R_LCDC),a
	ret

seasonsFunc_03_7a2e:
	ld hl,$cbba
	dec (hl)
	ret nz
	ld (hl),$02
	ld hl,$cbb8
	dec (hl)
	jr nz,+

seasonsFunc_03_7a3b:
	ld (hl),$1f
	ld hl,$cbb9
	inc (hl)
	ld a,(hl)
	and $03
	ld (hl),a
	ld hl,seasonsTable_03_7a5e
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld b,h
	ld c,l
	ld hl,$de90
	call func_13c6
	xor a
	ld (wPaletteThread_mode),a
	ld hl,$cbb8
+
	jp func_35ec

seasonsTable_03_7a5e:
	.db $b0 $49
	.db $10 $4a
	.db $e0 $49
	.db $40 $4a

;;
; There is an identical function named "incCutsceneState" in bank3Cutscenes.s.
incCutsceneState2:
	ld hl,wCutsceneState
	inc (hl)
	ret

seasonsFunc_03_7a6b:
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

seasonsFunc_03_7a88:
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

seasonsFunc_03_7aa9:
	ld d,a
	ld a,b
	ld e,a
	call disableLcd
	push de
	ld a,GFXH_SCENE_OUTSIDE_ONOX_CASTLE
	call loadGfxHeader
	ld a,PALH_0f
	call loadPaletteHeader
	ld a,PALH_TILESET_ONOX_CASTLE_OUTSIDE_WINTER
	call loadPaletteHeader
	pop de
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_88
	inc l
	ld (hl),e
+
	ld a,d
	call loadGfxRegisterStateIndex
	ld hl,wGfxRegs1.SCY
	ldi a,(hl)
	ldh (<hCameraY),a
	ld a,(hl)
	ldh (<hCameraX),a
	ret

cutscenePregameIntro:
	call cutscenePregameIntroHandler
	jp updateAllObjects

cutscenePregameIntroHandler:
	ld de,wCutsceneState
	ld a,(de)
	rst_jumpTable
	.dw cutscene0dFunc0
	.dw cutscene0dFunc1
	.dw cutscene0dFunc2
	.dw cutscene0dFunc3
	.dw cutscene0dFunc4
	.dw cutscene0dFunc5
	.dw cutscene0dFunc6
	.dw cutscene0dFunc7
	.dw cutscene0dFunc8
	.dw cutscene0dFunc9

	.dw cutscene0dFunca
	.dw cutscene0dFuncb
	.dw cutscene0dFuncc

cutscene0dFunc0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call checkIsLinkedGame
	jr nz,+
	ld a,$0a
	ld (de),a
	jp cutscene0dFunca
+
	ld a,$01
	ld (de),a
	; Room of Rites
	ld bc,ROOM_ZELDA_IN_FINAL_DUNGEON
	call disableLcdAndLoadRoom_body
	ld a,PALH_ac
	call loadPaletteHeader
	ld b,$03
-
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_TWINROVA_FLAME
	inc l
	ld (hl),b
	dec b
	jr nz,-
+
	ld a,MUS_FINAL_DUNGEON
	call playSound
	ld hl,$cbb3
	ld (hl),$3c
	ld a,$13
	call loadGfxRegisterStateIndex
	ld a,($c48d)
	ldh (<hCameraX),a
	xor a
	ldh (<hCameraY),a
	ld a,$00
	ld (wScrollMode),a
	jp clearFadingPalettes2
cutscene0dFunc1:
	ld e,$96
-
	call decCbb3
	ret nz
	call incCutsceneState2
	ld hl,$cbb3
	ld (hl),e
	ld a,SND_CREEPY_LAUGH
	jp playSound
cutscene0dFunc2:
	ld e,$3c
	jr -
cutscene0dFunc3:
	call decCbb3
	ret nz
	call incCutsceneState2
	call fastFadeinFromBlack
	ld a,$10
	ld ($c4b2),a
	ld ($c4b4),a
	ld a,$03
	ld ($c4b1),a
	ld ($c4b3),a
	ld a,SND_LIGHTTORCH
	jp playSound
cutscene0dFunc4:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incCutsceneState2
	ld a,$0e
	ld ($cbb3),a
	call fadeinFromBlack
	ld a,$ef
	ld ($c4b2),a
	ld ($c4b4),a
	ld a,$fc
	ld ($c4b1),a
	ld ($c4b3),a
	ret
cutscene0dFunc5:
	call decCbb3
	ret nz
	xor a
	ld (wPaletteThread_mode),a
	ld a,$78
	ld ($cbb3),a
	jp incCutsceneState2
cutscene0dFunc6:
	call decCbb3
	ret nz
	call incCutsceneState2
	ld a,$08
	ld ($cbae),a
	ld a,$03
	ld ($cbac),a
	ld bc,$0c15
	jp showText
cutscene0dFunc7:
	call retIfTextIsActive
	call incCutsceneState2
	ld ($cbb3),a
	dec a
	ld ($cbba),a
	call restartSound
	ld a,SND_BIG_EXPLOSION_2
	jp playSound
cutscene0dFunc8:
	ld hl,$cbb3
	ld b,$03
	call flashScreen
	ret z
	call incCutsceneState2
	ld a,$3c
	ld ($cbb3),a
	ld a,$02
	jp fadeoutToWhiteWithDelay
cutscene0dFunc9:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call decCbb3
	ret nz
	jp incCutsceneState2

cutsceneOnoxTaunting:
	call cutsceneOnoxTauntingHandler
	jp updateInteractionsAndDrawAllSprites

cutsceneOnoxTauntingHandler:
	ld de,wCutsceneState
	ld a,(de)
	rst_jumpTable
	.dw cutscene0eFunc0
	.dw cutscene0eFunc1
	.dw cutscene0eFunc2
	.dw cutscene0eFunc3
	.dw cutscene0eFunc4
	.dw cutscene0eFunc5
	.dw cutscene0eFunc6
	.dw cutscene0eFunc7
cutscene0eFunc0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call hideStatusBar
	call clearDynamicInteractions
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	ld hl,$cbb3
	ld (hl),$3c
	ld hl,$d01a
	res 7,(hl)
	xor a
	ld ($cfc0),a
	jp incCutsceneState2
cutscene0eFunc1:
	call decCbb3
	ret nz
	ld (hl),$14
	call incCutsceneState2
	ld hl,$cbae
	ld (hl),$04
	ld bc,$1719
	jp showText
cutscene0eFunc2:
	call retIfTextIsActive
	call decCbb3
	ret nz
	call disableLcd
	call getFreeInteractionSlot
	jr nz,+
	ld a,INTERACID_S_DIN
	ld ($cc1d),a
	ldi (hl),a
	ld (hl),$06
	call refreshObjectGfx
+
	xor a
	ld (wScreenOffsetY),a
	ld (wScreenOffsetX),a
	ld a,GFXH_SCENE_INSIDE_ONOX_CASTLE
	call loadGfxHeader
	ld a,PALH_SEASONS_97
	call loadPaletteHeader
	ld a,$01
	ld (wScrollMode),a
	ld a,$18
	ld (wTilesetAnimation),a
	call loadAnimationData
	ld a,$0d
	call loadGfxRegisterStateIndex
	ld hl,wGfxRegs1.SCY
	ldi a,(hl)
	ldh (<hCameraY),a
	ld a,(hl)
	ldh (<hCameraX),a
	ld a,$18
	ld (wTilesetAnimation),a
	call loadAnimationData
	xor a
	ld ($cbb3),a
	dec a
	ld ($cbba),a
	ld a,SND_LIGHTNING
	call playSound
	jp incCutsceneState2
cutscene0eFunc3:
	ld hl,$cbb3
	ld b,$01
	call flashScreen
	ret z
	xor a
	ldh (<hFF8B),a
	ld a,$f0
	ld c,a
	ld ($c4ae),a
	call seasonsFunc_35cc
	ld a,$ff
	ldh (<hDirtyBgPalettes),a
	ldh (<hDirtySprPalettes),a
	ldh (<hBgPaletteSources),a
	ldh (<hSprPaletteSources),a
	ld hl,$cbb3
	ld (hl),$3c
	ld a,MUS_DISASTER
	call playSound
	jp incCutsceneState2
cutscene0eFunc4:
	call decCbb3
	ret nz
	ld (hl),$3c
	call brightenRoom
	ld a,$ff
	ld ($c4b2),a
	ld ($c4b4),a
	xor a
	ld ($c4b1),a
	ld ($c4b3),a
	jp incCutsceneState2
cutscene0eFunc5:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call decCbb3
	ret nz
	ld (hl),$5a
	ld a,$f0
	ld ($c4ae),a
	call brightenRoom
	ld a,$ff
	ld ($c4b1),a
	ld ($c4b3),a
	jp incCutsceneState2
cutscene0eFunc6:
	call decCbb3
	ret nz
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_DIN_IMPRISONED_EVENT
	inc l
	ld (hl),$05
+
	jp incCutsceneState2
cutscene0eFunc7:
	ld a,($cfc0)
	or a
	ret z
	call showStatusBar
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	xor a
	ld ($cc66),a
	ld a,$82
	ld ($cc63),a
	ld a,$5d
	ld ($cc64),a
	xor a
	ld ($cc65),a
	ld a,$03
	ld (wWarpTransition2),a
	ret

cutscene0dFunca:
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
	call seasonsFunc_03_7a6b
	call seasonsFunc_03_7db8
	ld a,MUS_ESSENCE_ROOM
	call playSound
	ld a,$08
	call setLinkID
	ld l,<w1Link.enabled
	ld (hl),$01
	ld l,<w1Link.subid
	ld (hl),$0a
	ld a,$00
	ld (wScrollMode),a
	call incCutsceneState2
	call clearPaletteFadeVariablesAndRefreshPalettes
	xor a
	ldh (<hCameraY),a
	ldh (<hCameraX),a
	ld a,$15
	jp loadGfxRegisterStateIndex
cutscene0dFuncb:
	ld a,($cbb9)
	cp $07
	ret nz
	call clearLinkObject
	ld hl,$cbb3
	ld (hl),$3c
	jp incCutsceneState2
cutscene0dFuncc:
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

seasonsFunc_03_7db8:
	ld a,($ff00+R_SVBK)
	push af
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld hl,$d800
	ld bc,$0240
	call clearMemoryBc
	ld hl,$dc00
	ld bc,$0240
	ld a,$02
	call fillMemoryBc
	pop af
	ld ($ff00+R_SVBK),a
	ret
