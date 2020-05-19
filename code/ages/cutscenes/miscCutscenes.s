;;
; CUTSCENE_FAIRIES_HIDE
; @addr{6103}
func_03_6103:
	ld a,($cfd1)		; $6103
	cp $07			; $6106
	jp z,_fairyCutscene_cfd1is07		; $6108
	ld a,(wCutsceneState)		; $610b
	rst_jumpTable			; $610e
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
	ld hl,wTmpcbb3		; $6127
	ld a,(w1Link.yh)		; $612a
	ldi (hl),a		; $612d
	ld a,(w1Link.xh)		; $612e
	ldi (hl),a		; $6131
	ld a,(w1Link.direction)		; $6132
	ld (hl),a		; $6135
	call fadeoutToWhite		; $6136
	jp _fairyCutscene_incState		; $6139
@state1:
	ld a,(wPaletteThread_mode)		; $613c
	or a			; $613f
	ret nz			; $6140
	ld a,<ROOM_AGES_081		; $6141
@loadNewFairyRoom:
	ld (wActiveRoom),a		; $6143
	call _fairyCutscene_incState		; $6146
	xor a			; $6149
	ld ($cfd2),a		; $614a
	call disableLcd		; $614d
	call clearScreenVariablesAndWramBank1		; $6150
	call initializeVramMaps		; $6153
	call loadScreenMusicAndSetRoomPack		; $6156
	call loadTilesetData		; $6159
	call loadTilesetGraphics		; $615c
	call func_131f		; $615f
	ld a,$01		; $6162
	ld (wScrollMode),a		; $6164
	call refreshObjectGfx		; $6167
	call loadCommonGraphics		; $616a
	ld a,$02		; $616d
	call loadGfxRegisterStateIndex		; $616f
	jp fadeinFromWhite		; $6172
@state2:
	ld a,(wPaletteThread_mode)		; $6175
	or a			; $6178
	ret nz			; $6179
	ld b,$0c		; $617a
;;
; @param	b	var03
@spawnForestFairy:
	call getFreeInteractionSlot		; $617c
	ret nz			; $617f
	ld (hl),INTERACID_FOREST_FAIRY		; $6180
	ld l,$43		; $6182
	ld (hl),b		; $6184
	jp _fairyCutscene_incState		; $6185
@state3:
@state6:
@state9:
	ld hl,$cfd2		; $6188
	ld a,(hl)		; $618b
	or a			; $618c
	ret z			; $618d
	ld (hl),$00		; $618e
	call _fairyCutscene_incState		; $6190
	jp fadeoutToWhite		; $6193
@state4:
	ld a,(wPaletteThread_mode)		; $6196
	or a			; $6199
	ret nz			; $619a
	ld a,<ROOM_AGES_080		; $619b
	jr @loadNewFairyRoom		; $619d
@state5:
	ld a,(wPaletteThread_mode)		; $619f
	or a			; $61a2
	ret nz			; $61a3
	ld b,$0d		; $61a4
	jr @spawnForestFairy		; $61a6
@state7:
	ld a,(wPaletteThread_mode)		; $61a8
	or a			; $61ab
	ret nz			; $61ac
	ld a,<ROOM_AGES_091		; $61ad
	jr @loadNewFairyRoom		; $61af
@state8:
	ld a,(wPaletteThread_mode)		; $61b1
	or a			; $61b4
	ret nz			; $61b5
	ld b,$0e		; $61b6
	jp @spawnForestFairy		; $61b8
@stateA:
	ld a,(wPaletteThread_mode)		; $61bb
	or a			; $61be
	ret nz			; $61bf
	ld a,<ROOM_AGES_082		; $61c0
	call @loadNewFairyRoom		; $61c2
	ld hl,$d000		; $61c5
	ld (hl),$03		; $61c8
	ld l,$0b		; $61ca
	ld a,(wTmpcbb3)		; $61cc
	ldi (hl),a		; $61cf
	inc l			; $61d0
	ld a,(wTmpcbb4)		; $61d1
	ld (hl),a		; $61d4
	ld a,(wTmpcbb5)		; $61d5
	ld l,$08		; $61d8
	ld (hl),a		; $61da
	ret			; $61db
@stateB:
	ld a,(wPaletteThread_mode)		; $61dc
	or a			; $61df
	ret nz			; $61e0
	xor a			; $61e1
	ld (wDisabledObjects),a		; $61e2
	ld (wMenuDisabled),a		; $61e5
	inc a			; $61e8
	ld (wCutsceneIndex),a		; $61e9
	ld bc,TX_1104		; $61ec
	jp showText		; $61ef
	
_fairyCutscene_cfd1is07:
	ld a,(wCutsceneState)		; $61f2
	rst_jumpTable			; $61f5
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
@state0:
	ld a,(wPaletteThread_mode)		; $6202
	or a			; $6205
	ret nz			; $6206
	ld bc,TX_110a		; $6207
	call showText		; $620a
	jp _fairyCutscene_incState		; $620d
@state1:
	ld a,(wTextIsActive)		; $6210
	or a			; $6213
	ret nz			; $6214
	call _fairyCutscene_incState		; $6215
	ld a,$0c		; $6218
	ld (wTmpcbb6),a		; $621a
	ld a,SND_MYSTERY_SEED		; $621d
	call playSound		; $621f
	jp fastFadeinFromWhite		; $6222
@state2:
	ld a,(wPaletteThread_mode)		; $6225
	or a			; $6228
	ret nz			; $6229
	ld hl,wTmpcbb6		; $622a
	dec (hl)		; $622d
	ret nz			; $622e
	jr @state1		; $622f
@state3:
	ld a,(wPaletteThread_mode)		; $6231
	or a			; $6234
	ret nz			; $6235
	ld hl,wTmpcbb6		; $6236
	dec (hl)		; $6239
	ret nz			; $623a
	call _fairyCutscene_incState		; $623b
	xor a			; $623e
	ld ($cfd0),a		; $623f
	ld a,SND_MYSTERY_SEED		; $6242
	call playSound		; $6244
	ld a,$08		; $6247
	jp fadeinFromWhiteWithDelay		; $6249
@state4:
	ld a,(wPaletteThread_mode)		; $624c
	or a			; $624f
	ret nz			; $6250
	call _fairyCutscene_incState		; $6251
	ld bc,TX_110b		; $6254
	jp showText		; $6257
@state5:
	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME		; $625a
	call setGlobalFlag		; $625c
	ld a,GLOBALFLAG_FOREST_UNSCRAMBLED		; $625f
	call setGlobalFlag		; $6261
	xor a			; $6264
	ld (wMenuDisabled),a		; $6265
	ld (wDisabledObjects),a		; $6268
	inc a			; $626b
	ld (wCutsceneIndex),a		; $626c
	ret			; $626f
	
_fairyCutscene_incState:
	ld hl,wCutsceneState		; $6270
	inc (hl)		; $6273
	ret			; $6274

;;
; CUTSCENE_BOOTED_FROM_PALACE
; @addr{6275}
func_03_6275:
	ld a,(wCutsceneState)		; $6275
	rst_jumpTable			; $6278
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	call fadeoutToWhite		; $6283
	jr @bootedFromPalace_incState		; $6286
@state1:
	ld a,(wPaletteThread_mode)		; $6288
	or a			; $628b
	ret nz			; $628c
	call clearAllParentItems		; $628d
	call dropLinkHeldItem		; $6290
	ld a,>ROOM_AGES_146		; $6293
	ld (wActiveGroup),a		; $6295
	ld a,<ROOM_AGES_146		; $6298
	ld (wActiveRoom),a		; $629a
	call disableLcd		; $629d
	call clearOam		; $62a0
	call clearScreenVariablesAndWramBank1		; $62a3
	call initializeVramMaps		; $62a6
	call loadScreenMusicAndSetRoomPack		; $62a9
	call loadTilesetData		; $62ac
	call loadTilesetGraphics		; $62af
	call func_131f		; $62b2
	ld a,$01		; $62b5
	ld (wScrollMode),a		; $62b7
	call loadCommonGraphics		; $62ba
	call initializeRoom		; $62bd
	call fadeinFromWhite		; $62c0
	ld a,$02		; $62c3
	call loadGfxRegisterStateIndex		; $62c5
@bootedFromPalace_incState:
	ld hl,wCutsceneState		; $62c8
	inc (hl)		; $62cb
	ret			; $62cc
@state2:
	ld a,$03		; $62cd
	ld ($d000),a		; $62cf
	ld a,$0f		; $62d2
	ld (wLinkForceState),a		; $62d4
	jr @bootedFromPalace_incState		; $62d7
@state3:
	ld a,(wPaletteThread_mode)		; $62d9
	or a			; $62dc
	ret nz			; $62dd
	ld a,($d005)		; $62de
	cp $02			; $62e1
	ret nz			; $62e3
	ld bc,TX_590a		; $62e4
	call showText		; $62e7
	jr @bootedFromPalace_incState		; $62ea
@state4:
	ld a,(wTextIsActive)		; $62ec
	or a			; $62ef
	ret nz			; $62f0
	ld (wMenuDisabled),a		; $62f1
	ld (wDisabledObjects),a		; $62f4
	ld (wDisableScreenTransitions),a		; $62f7
	ld (wCutsceneIndex),a		; $62fa
	ld a,(wActiveMusic2)		; $62fd
	ld (wActiveMusic),a		; $6300
	jp playSound		; $6303

;;
; @addr{6306}
miscCutsceneHandler:
	ld a,c			; $6306
	rst_jumpTable			; $6307
	.dw _nayruSingingCutsceneHandler
	.dw _makuTreeDisappearingCutsceneHandler
	.dw _blackTowerExplanationCutsceneHandler
	.dw _nayruWarpToMakuTreeCutsceneHandler
	.dw _turnToStoneCutsceneHandler
	.dw _twinrovaRevealCutsceneHandler
	.dw _pregameIntroCutsceneHandler
	.dw _blackTowerCompleteCutsceneHandler

;;
; CUTSCENE_NAYRU_SINGING
_nayruSingingCutsceneHandler:
	call @runStates		; $6318
	ld hl,wCutsceneState		; $631b
	ld a,(hl)		; $631e
	cp $02			; $631f
	ret z			; $6321
	cp $03			; $6322
	ret z			; $6324
	jp updateAllObjects		; $6325

@runStates:
	ld de,wCutsceneState		; $6328
	ld a,(de)		; $632b
	rst_jumpTable			; $632c
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
	.dw _nayruSingingStateE
	.dw _nayruSingingStateF
	.dw _nayruSingingState10
	.dw _nayruSingingState11
@state0:
	ld a,$01		; $6351
	ld (de),a		; $6353
	ld a,SND_CLOSEMENU		; $6354
	jp playSound		; $6356
@state1:
	ld a,$ff		; $6359
	ld (wTilesetAnimation),a		; $635b
	ld a,$08		; $635e
	ld ($cfd0),a		; $6360
	ld hl,wMenuDisabled		; $6363
	ld (hl),$01		; $6366
	ld hl,$d01a		; $6368
	res 7,(hl)		; $636b
	call saveGraphicsOnEnterMenu		; $636d
	ld a,$0c		; $6370
	call loadGfxHeader		; $6372
	ld a,PALH_95		; $6375
	call loadPaletteHeader		; $6377
	ld a,$04		; $637a
	call loadGfxRegisterStateIndex		; $637c
	ld hl,wTmpcbb3		; $637f
	ld (hl),$58		; $6382
	inc hl			; $6384
	ld (hl),$02		; $6385
	ld hl,wTmpcbb6		; $6387
	ld (hl),$28		; $638a
	call fastFadeinFromWhite		; $638c
	call _cutscene_incCutsceneState		; $638f
	ld hl,wTmpcbb5		; $6392
	ld (hl),$02		; $6395
@func_6397:
	call clearOam		; $6397
	ld b,$00		; $639a
	ld a,(wGfxRegs1.SCX)		; $639c
	cpl			; $639f
	inc a			; $63a0
	ld c,a			; $63a1
	ld hl,bank3f.oamData_7249		; $63a2
	ld e,:bank3f.oamData_7249		; $63a5
	jp addSpritesFromBankToOam_withOffset		; $63a7
@state2:
	ld a,(wPaletteThread_mode)		; $63aa
	or a			; $63ad
	jp nz,@func_6397		; $63ae
	ret nz			; $63b1
	call @func_63db		; $63b2
	call @func_6397		; $63b5
	ld hl,wTmpcbb3		; $63b8
	call decHlRef16WithCap		; $63bb
	jr z,+			; $63be
	ldi a,(hl)		; $63c0
	ld h,(hl)		; $63c1
	ld l,a			; $63c2
	ld bc,$00f0		; $63c3
	call compareHlToBc		; $63c6
	ret nc			; $63c9
	ld a,(wKeysJustPressed)		; $63ca
	and BTN_A			; $63cd
	ret z			; $63cf
+
	ld a,SND_CLOSEMENU		; $63d0
	call playSound		; $63d2
	call _cutscene_incCutsceneState		; $63d5
	jp fastFadeoutToWhite		; $63d8
@func_63db:
	ld a,(wFrameCounter)		; $63db
	and $07			; $63de
	ret nz			; $63e0
	ld hl,wTmpcbb6		; $63e1
	ld a,(hl)		; $63e4
	or a			; $63e5
	ret z			; $63e6
	dec (hl)		; $63e7
	ld hl,wGfxRegs1.SCX		; $63e8
	inc (hl)		; $63eb
	ret			; $63ec
@state3:
	ld a,(wPaletteThread_mode)		; $63ed
	or a			; $63f0
	jp nz,@func_6397		; $63f1
	ret nz			; $63f4
	xor a			; $63f5
	ld (wTilesetAnimation),a		; $63f6
	ld hl,$d01a		; $63f9
	set 7,(hl)		; $63fc
	ld a,$09		; $63fe
	ld ($cfd0),a		; $6400
	call _cutscene_incCutsceneState		; $6403
	ld hl,wTmpcbb3		; $6406
	ld (hl),$aa		; $6409
	jp reloadGraphicsOnExitMenu		; $640b
@state4:
	ld a,($cfd0)		; $640e
	cp $0f			; $6411
	ret nz			; $6413
	call _cutscene_incCutsceneState		; $6414
	ld hl,$de90		; $6417
	ld bc,paletteData44a8		; $641a
	jp func_13c6		; $641d
@state5:
	ld a,(wPaletteThread_mode)		; $6420
	or a			; $6423
	ret nz			; $6424
	ld a,PALH_99		; $6425
	call loadPaletteHeader		; $6427
	ld a,$10		; $642a
	ld ($cfd0),a		; $642c
	jp _cutscene_incCutsceneState		; $642f
@state6:
	ld a,($cfd0)		; $6432
	cp $14			; $6435
	ret nz			; $6437
	call _cutscene_incCutsceneState		; $6438
	ld hl,wTmpcbb3		; $643b
	ld (hl),$3c		; $643e
	jp fadeoutToWhite		; $6440
@state7:
	call _cutscene_decCBB3IfNotFadingOut		; $6443
	ret nz			; $6446
	call _cutscene_incCutsceneState		; $6447
	ld a,$15		; $644a
	ld ($cfd0),a		; $644c
	ld a,$03		; $644f
	jp fadeinFromWhiteWithDelay		; $6451
@state8:
	ld a,($cfd0)		; $6454
	cp $18			; $6457
	ret nz			; $6459
	call _cutscene_incCutsceneState		; $645a
	xor a			; $645d
	ld ($cfd2),a		; $645e
	call getFreePartSlot		; $6461
	ret nz			; $6464
	ld (hl),PARTID_LIGHTNING		; $6465
	inc l			; $6467
	inc (hl)		; $6468
	inc l			; $6469
	inc (hl)		; $646a
	ld l,$cb		; $646b
	ld (hl),$24		; $646d
	ld l,$cd		; $646f
	ld (hl),$28		; $6471
	ret			; $6473
@state9:
	ld a,($cfd2)		; $6474
	or a			; $6477
	ret z			; $6478
	call _cutscene_incCutsceneState		; $6479
	call getThisRoomFlags		; $647c
	set 6,(hl)		; $647f
	ld c,$22		; $6481
	ld a,$d7		; $6483
	jp setTile		; $6485
@stateA:
	ld a,($cfd0)		; $6488
	cp $1d			; $648b
	ret nz			; $648d
	ld hl,wTmpcbb3		; $648e
	ld (hl),$78		; $6491
	jp _cutscene_incCutsceneState		; $6493
@stateB:
	call decCbb3		; $6496
	ret nz			; $6499
	ld (hl),$5a		; $649a
	call _cutscene_incCutsceneState		; $649c
	ld bc,TX_5607		; $649f
	jp showText		; $64a2
@stateC:
	call _cutscene_decCBB3IfTextNotActive		; $64a5
	ret nz			; $64a8
	call _cutscene_incCutsceneState		; $64a9
	xor a			; $64ac
	ld hl,$cfde		; $64ad
	ldi (hl),a		; $64b0
	ld (hl),a		; $64b1
	jp fadeoutToWhite		; $64b2
@stateD:
	ld a,(wPaletteThread_mode)		; $64b5
	or a			; $64b8
	ret nz			; $64b9
	call _cutscene_incCutsceneState		; $64ba
	call _cutscene_loadRoomObjectSetAndFadein		; $64bd
	ld a,$02		; $64c0
	jp loadGfxRegisterStateIndex		; $64c2

;;
; @addr{64c5}
_cutscene_loadRoomObjectSetAndFadein:
	ld hl,wTmpcfc0.genericCutscene.cfde		; $64c5
	ld a,(hl)		; $64c8
	push af			; $64c9
	call _cutscene_disableLcdLoadRoomResetCamera		; $64ca
	pop af			; $64cd
	ld b,a			; $64ce
	call getEntryFromObjectTable2		; $64cf
	call parseGivenObjectData		; $64d2
	call refreshObjectGfx		; $64d5
	xor a			; $64d8
	ld (wTmpcfc0.genericCutscene.cfd1),a		; $64d9
	jp fadeinFromWhite		; $64dc

_nayruSingingStateE:
	ld a,(wPaletteThread_mode)		; $64df
	or a			; $64e2
	ret nz			; $64e3
	ld hl,$cfdf		; $64e4
	ld a,(hl)		; $64e7
	cp $ff			; $64e8
	ret nz			; $64ea
	xor a			; $64eb
	ldd (hl),a		; $64ec
	inc (hl)		; $64ed
	ld a,(hl)		; $64ee
	cp $03			; $64ef
	ld a,$0d		; $64f1
	jr nz,+			; $64f3
	ld a,$0f		; $64f5
+
	ld hl,wCutsceneState		; $64f7
	ld (hl),a		; $64fa
	jp fadeoutToWhite		; $64fb
	
_nayruSingingStateF:
	ld a,(wPaletteThread_mode)		; $64fe
	or a			; $6501
	ret nz			; $6502
	call _cutscene_incCutsceneState		; $6503
	call _cutscene_loadRoomObjectSetAndFadein		; $6506
	ld a,PALH_99		; $6509
	call loadPaletteHeader		; $650b
	ld a,$08		; $650e
	call setLinkIDOverride		; $6510
	ld l,$00		; $6513
	ld (hl),$03		; $6515
	ld l,$02		; $6517
	ld (hl),$04		; $6519
	ld a,SNDCTRL_MEDIUM_FADEOUT		; $651b
	call playSound		; $651d
	ld a,MUS_SADNESS		; $6520
	call playSound		; $6522
	xor a			; $6525
	ld (wPaletteThread_parameter),a		; $6526
	ld a,$24		; $6529
	ld b,$02		; $652b
	call _cutscene_loadAObjectGfxBTimes		; $652d
	call reloadObjectGfx		; $6530
	ld a,$02		; $6533
	jp loadGfxRegisterStateIndex		; $6535
	
_nayruSingingState10:
	ld a,(wPaletteThread_mode)		; $6538
	or a			; $653b
	ret nz			; $653c
	ld a,($cfd0)		; $653d
	cp $1e			; $6540
	ret nz			; $6542
	call _cutscene_incCutsceneState		; $6543
	ld hl,$de90		; $6546
	ld bc,paletteData4a30		; $6549
	jp func_13c6		; $654c
	
_nayruSingingState11:
	ld a,(wPaletteThread_mode)		; $654f
	or a			; $6552
	ret nz			; $6553
	ld a,PALH_10		; $6554
	call loadPaletteHeader		; $6556
	ld a,$1f		; $6559
	ld ($cfd0),a		; $655b
	ld a,CUTSCENE_INGAME		; $655e
	ld (wCutsceneIndex),a		; $6560
	ret			; $6563


;;
; CUTSCENE_MAKU_TREE_DISAPPEARING
_makuTreeDisappearingCutsceneHandler:
	call @makuTreeDisappearing_body		; $6564
	jp updateAllObjects		; $6567

@makuTreeDisappearing_body:
	ld a,($cfc0)		; $656a
	or a			; $656d
	jr z,@label_03_119	; $656e
	ld a,SND_FADEOUT		; $6570
	call playSound		; $6572
	xor a			; $6575
	ld (wLinkStateParameter),a		; $6576
	ld (wMenuDisabled),a		; $6579
	ld a,GLOBALFLAG_0c		; $657c
	call setGlobalFlag		; $657e
	call getThisRoomFlags		; $6581
	set 0,(hl)		; $6584
	xor a			; $6586
	ld (wUseSimulatedInput),a		; $6587
	inc a			; $658a
	ld (wDisabledObjects),a		; $658b
	ld hl,@warpDest		; $658e
	jp setWarpDestVariables		; $6591
@label_03_119:
	ld a,(wFrameCounter)		; $6594
	and $07			; $6597
	ret nz			; $6599
	ld hl,$cbb7		; $659a
	ld a,(hl)		; $659d
	inc a			; $659e
	and $03			; $659f
	ld (hl),a		; $65a1
	ld hl,@paletteHeaders		; $65a2
	rst_addAToHl			; $65a5
	ld a,(hl)		; $65a6
	jp loadPaletteHeader		; $65a7

@warpDest:
	m_HardcodedWarpA ROOM_AGES_038, $0c, $45, $83
@paletteHeaders:
	.db $9a $c4 $8f $c5


;;
; CUTSCENE_BLACK_TOWER_EXPLANATION
_blackTowerExplanationCutsceneHandler:
	call @runStates		; $65b3
	jp updateAllObjects		; $65b6

@runStates:
	ld a,($cbb8)		; $65b9
	rst_jumpTable			; $65bc
	.dw @cbb8_00
	.dw @cbb8_01
	.dw @cbb8_02
@cbb8_00:
	ld de,wCutsceneState		; $65c3
	ld a,(de)		; $65c6
	rst_jumpTable			; $65c7
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw _func_6733
@@state0:
	ld a,(wPaletteThread_mode)		; $65d0
	or a			; $65d3
	ret nz			; $65d4
	call disableLcd		; $65d5
	call clearScreenVariablesAndWramBank1		; $65d8
	call clearOam		; $65db
	ld a,($cbb8)		; $65de
	ld hl,@@table_6625		; $65e1
	rst_addDoubleIndex			; $65e4
	ldi a,(hl)		; $65e5
	push hl			; $65e6
	call loadGfxHeader		; $65e7
	pop hl			; $65ea
	ld a,(hl)		; $65eb
	call loadGfxHeader		; $65ec
	ld a,PALH_c3		; $65ef
	call loadPaletteHeader		; $65f1
	ld b,$78		; $65f4
	ld a,($cbb8)		; $65f6
	cp $02			; $65f9
	jr z,+			; $65fb
	ld b,$3c		; $65fd
+
	ld hl,wTmpcbb3		; $65ff
	ld (hl),b		; $6602
	or a			; $6603
	ld a,MUS_DISASTER		; $6604
	call z,playSound		; $6606
	call _cutscene_incCutsceneState		; $6609
	xor a			; $660c
	ld (wTmpcbb9),a		; $660d
	call fadeinFromWhite		; $6610
	ld a,$70		; $6613
	ld (wScreenOffsetY),a		; $6615
	ld hl,$cc10		; $6618
	ld b,$08		; $661b
	call clearMemory		; $661d
	ld a,$09		; $6620
	jp loadGfxRegisterStateIndex		; $6622

@@table_6625:
	.db $82 $2f
	.db $81 $2e
	.db $80 $2e

@@state1:
	call _func_6ef7		; $662b
	call _func_6f44		; $662e
	ld a,(wPaletteThread_mode)		; $6631
	or a			; $6634
	ret nz			; $6635
	call decCbb3		; $6636
	ret nz			; $6639
	call _cutscene_incCutsceneState		; $663a
	ld bc,TX_1005		; $663d
	ld a,($cbb8)		; $6640
	or a			; $6643
	jr z,+			; $6644
	ld bc,TX_1317		; $6646
+
	ld a,TEXTBOXFLAG_NOCOLORS		; $6649
	ld (wTextboxFlags),a		; $664b
	jp showText		; $664e

@@state2:
	call _func_6ef7		; $6651
	call _func_6f44		; $6654
	ld a,(wTextIsActive)		; $6657
	or a			; $665a
	ret nz			; $665b
	ld hl,wTmpcbb3		; $665c
	ld (hl),$3c		; $665f
	jp _cutscene_incCutsceneState		; $6661

@cbb8_01:
	ld de,wCutsceneState		; $6664
	ld a,(de)		; $6667
	rst_jumpTable			; $6668
	.dw @cbb8_00@state0
	.dw @cbb8_00@state1
	.dw @cbb8_00@state2
	.dw @cbb8_02@state1
	.dw @cbb8_02@state2
	.dw @@state5
	.dw @@state6
	.dw @@state7

@@state5:
	call _func_6ef7		; $6679
	call _func_6f44		; $667c
	call decCbb3		; $667f
	ret nz			; $6682
	call _cutscene_incCutsceneState		; $6683
	jp fadeoutToWhite		; $6686

@@state6:
	call _func_6f44		; $6689
	ld a,(wPaletteThread_mode)		; $668c
	or a			; $668f
	ret nz			; $6690
	call _cutscene_incCutsceneState		; $6691
	call clearDynamicInteractions		; $6694
	ld bc, ROOM_AGES_0ba		; $6697
	call disableLcdAndLoadRoom		; $669a
	call resetCamera		; $669d
	call getFreeInteractionSlot		; $66a0
	jr nz,+			; $66a3
	ld (hl),INTERACID_REMOTE_MAKU_CUTSCENE		; $66a5
	inc l			; $66a7
	ld (hl),$00		; $66a8
	inc l			; $66aa
	ld (hl),$04		; $66ab
+
	ld hl,$d000		; $66ad
	ld (hl),$03		; $66b0
	ld l,$0b		; $66b2
	ld (hl),$65		; $66b4
	ld l,$0d		; $66b6
	ld (hl),$58		; $66b8
	ld l,$08		; $66ba
	ld (hl),$02		; $66bc
	ld a,(wLoadingRoomPack)		; $66be
	ld (wRoomPack),a		; $66c1
	ld a,SNDCTRL_STOPMUSIC		; $66c4
	call playSound		; $66c6
	ld a,PALH_0f		; $66c9
	call loadPaletteHeader		; $66cb
	call fadeinFromWhiteToRoom		; $66ce
	call refreshObjectGfx		; $66d1
	call showStatusBar		; $66d4
	ld a,$02		; $66d7
	jp loadGfxRegisterStateIndex		; $66d9

@@state7:
	call updateStatusBar		; $66dc
	ld a,(wPaletteThread_mode)		; $66df
	or a			; $66e2
	ret nz			; $66e3
	ld a,$01		; $66e4
	ld (wMenuDisabled),a		; $66e6
	ld (wDisabledObjects),a		; $66e9
	ld (wCutsceneIndex),a		; $66ec
	ret			; $66ef
@cbb8_02:
	ld de,wCutsceneState		; $66f0
	ld a,(de)		; $66f3
	rst_jumpTable			; $66f4
	.dw @cbb8_00@state0
	.dw @@state1
	.dw @@state2
	.dw _func_6733

@@state1:
	call _func_6ef7		; $66fd
	call _func_6f44		; $6700
	ld a,(wPaletteThread_mode)		; $6703
	or a			; $6706
	ret nz			; $6707
	call decCbb3		; $6708
	ret nz			; $670b
	ld a,$04		; $670c
	ld (wTmpcbbb),a		; $670e
	ld (wTmpcbb6),a		; $6711
	ld a,($cbb8)		; $6714
	ld hl,@@table_6722		; $6717
	rst_addAToHl			; $671a
	ld a,(hl)		; $671b
	ld (wTmpcbb3),a		; $671c
	jp _cutscene_incCutsceneState		; $671f
@@table_6722:
	.db $01 $61 $b1
@@state2:
	call _func_6ef7		; $6725
	call _func_6f26		; $6728
	jp nz,_func_6f44		; $672b
	ld (hl),$78		; $672e
	call _cutscene_incCutsceneState		; $6730

_func_6733:
	call _func_6ef7		; $6733
	call _func_6f44		; $6736
	call decCbb3		; $6739
	ret nz			; $673c
	ld a,($cbb8)		; $673d
	rst_jumpTable			; $6740
	.dw @cbb8_00
	.dw @cbb8_01
	.dw @cbb8_02
@cbb8_00:
@cbb8_01:
	ld hl,@warpDest1		; $6747
	call setWarpDestVariables		; $674a
	ld a,($cfd3)		; $674d
	ld (wWarpDestPos),a		; $6750
	ld a,($cfd4)		; $6753
	ld (wcc50),a		; $6756
	ld a,$ff		; $6759
	ld (wActiveMusic),a		; $675b
	ld a,$01		; $675e
	ld ($cfc0),a		; $6760
	ld a,SNDCTRL_MEDIUM_FADEOUT		; $6763
	jp playSound		; $6765
@cbb8_02:
	xor a			; $6768
	ld (wLinkStateParameter),a		; $6769
	ld hl,@warpDest2		; $676c
	jp setWarpDestVariables		; $676f

@warpDest1:
	m_HardcodedWarpA ROOM_AGES_186, $0c, $75, $03

@warpDest2:
	m_HardcodedWarpA ROOM_AGES_4f6, $0f, $47, $03


;;
; CUTSCENE_NAYRU_WARP_TO_MAKU_TREE
_nayruWarpToMakuTreeCutsceneHandler:
	call @runStates		; $677c
	call updateStatusBar		; $677f
	jp updateAllObjects		; $6782
	
@runStates:
	ld de,wCutsceneState		; $6785
	ld a,(de)		; $6788
	rst_jumpTable			; $6789
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
	ld a,(wPaletteThread_mode)		; $67a4
	or a			; $67a7
	ret nz			; $67a8
	call _cutscene_incCutsceneState		; $67a9
	call clearDynamicInteractions		; $67ac
	ld bc, ROOM_AGES_038		; $67af
	call disableLcdAndLoadRoom		; $67b2
	call resetCamera		; $67b5
	ld b,$04		; $67b8
	call getEntryFromObjectTable2		; $67ba
	call parseGivenObjectData		; $67bd
	call refreshObjectGfx		; $67c0
	ld a,$04		; $67c3
	ld b,$02		; $67c5
	call _cutscene_loadAObjectGfxBTimes		; $67c7
	call reloadObjectGfx		; $67ca
	ld a,SNDCTRL_FAST_FADEOUT		; $67cd
	call playSound		; $67cf
	ld a,$02		; $67d2
	call loadGfxRegisterStateIndex		; $67d4
	ld hl,wTmpcbb3		; $67d7
	ld (hl),$3c		; $67da
	ld b,$20		; $67dc
	ld hl,$cfc0		; $67de
	call clearMemory		; $67e1
	ld a,$01		; $67e4
	ld (wDisabledObjects),a		; $67e6
	ld (wMenuDisabled),a		; $67e9
	ld a,SNDCTRL_STOPMUSIC		; $67ec
	call playSound		; $67ee
	ld a,MUS_MAKU_TREE		; $67f1
	call playSound		; $67f3
	call incMakuTreeState		; $67f6
	jp fadeinFromWhiteToRoom		; $67f9
@state1:
	call _cutscene_decCBB3whenFadeDone		; $67fc
	ret nz			; $67ff
	ld (hl),$3c		; $6800
	call _cutscene_incCutsceneState		; $6802
	ld a,$68		; $6805
	ld bc,$5050		; $6807
	jp createEnergySwirlGoingIn		; $680a
@state2:
	call decCbb3		; $680d
	ret nz			; $6810
	xor a			; $6811
	ld (hl),a		; $6812
	dec a			; $6813
	ld (wTmpcbba),a		; $6814
	jp _cutscene_incCutsceneState		; $6817
@state3:
	ld hl,wTmpcbb3		; $681a
	ld b,$02		; $681d
	call flashScreen		; $681f
	ret z			; $6822
	call _cutscene_incCutsceneState		; $6823
	ld hl,wTmpcbb3		; $6826
	ld (hl),$3c		; $6829
	ld a,$01		; $682b
	ld ($cfd0),a		; $682d
	call @func_6838		; $6830
	ld a,$03		; $6833
	jp fadeinFromWhiteWithDelay		; $6835
@func_6838:
	ld a,$00		; $6838
	call setLinkIDOverride		; $683a
	ld l,$00		; $683d
	ld (hl),$03		; $683f
	ld l,$0b		; $6841
	ld (hl),$68		; $6843
	ld l,$0d		; $6845
	ld (hl),$50		; $6847
	ld l,$08		; $6849
	ld (hl),$00		; $684b
	ret			; $684d
@state4:
	call _cutscene_decCBB3whenFadeDone		; $684e
	ret nz			; $6851
	jp _cutscene_incCutsceneState		; $6852
@state5:
	ld a,($cfd0)		; $6855
	cp $02			; $6858
	ret nz			; $685a
	call _cutscene_incCutsceneState		; $685b
	ld a,SNDCTRL_FAST_FADEOUT		; $685e
	call playSound		; $6860
	xor a			; $6863
	ld hl,$cfde		; $6864
	ld (hl),$05		; $6867
	inc l			; $6869
	ld (hl),$00		; $686a
	jp fadeoutToWhite		; $686c
@state6:
	ld a,(wPaletteThread_mode)		; $686f
	or a			; $6872
	ret nz			; $6873
	call _cutscene_incCutsceneState		; $6874
	call _cutscene_loadRoomObjectSetAndFadein		; $6877
	ld a,$02		; $687a
	jp loadGfxRegisterStateIndex		; $687c
@state7:
	ld a,(wPaletteThread_mode)		; $687f
	or a			; $6882
	ret nz			; $6883
	ld hl,$cfdf		; $6884
	ld a,(hl)		; $6887
	cp $ff			; $6888
	ret nz			; $688a
	xor a			; $688b
	ldd (hl),a		; $688c
	inc (hl)		; $688d
	ld a,(hl)		; $688e
	cp $07			; $688f
	ld a,$06		; $6891
	jr nz,+			; $6893
	ld a,$08		; $6895
	ld hl,$cfd0		; $6897
	ld (hl),$03		; $689a
+
	ld hl,wCutsceneState		; $689c
	ld (hl),a		; $689f
	jp fadeoutToWhite		; $68a0
@state8:
	ld a,(wPaletteThread_mode)		; $68a3
	or a			; $68a6
	ret nz			; $68a7
	call _cutscene_incCutsceneState		; $68a8
	call _cutscene_loadRoomObjectSetAndFadein		; $68ab
	call @func_6838		; $68ae
	ld a,$01		; $68b1
	ld (wDisabledObjects),a		; $68b3
	ld (wMenuDisabled),a		; $68b6
	ld a,$04		; $68b9
	ld b,$02		; $68bb
	call _cutscene_loadAObjectGfxBTimes		; $68bd
	ld a,$26		; $68c0
	ld b,$02		; $68c2
	call _cutscene_loadAintoHL_BTimes		; $68c4
	ld a,$24		; $68c7
	ld b,$01		; $68c9
	call _cutscene_loadAintoHL_BTimes		; $68cb
	ld b,l			; $68ce
	call checkIsLinkedGame		; $68cf
	jr z,+			; $68d2
	call getFreeInteractionSlot		; $68d4
	jr nz,+			; $68d7
	ld (hl),INTERACID_TWINROVA		; $68d9
+
	call reloadObjectGfx		; $68db
	ld a,MUS_MAKU_TREE		; $68de
	call playSound		; $68e0
	ld a,$02		; $68e3
	jp loadGfxRegisterStateIndex		; $68e5
@state9:
	ld a,($cfd0)		; $68e8
	cp $07			; $68eb
	ret nz			; $68ed
	call _cutscene_incCutsceneState		; $68ee
	ld a,SNDCTRL_STOPSFX		; $68f1
	call playSound		; $68f3
	ld bc,TX_2800		; $68f6
	call checkIsLinkedGame		; $68f9
	jr z,+			; $68fc
	ld c,<TX_2802		; $68fe
+
	jp showText		; $6900
@stateA:
	ld a,(wTextIsActive)		; $6903
	or a			; $6906
	ret nz			; $6907
	call _cutscene_incCutsceneState		; $6908
	ld hl,wTmpcbb3		; $690b
	ld (hl),$b4		; $690e
	ld a,$01		; $6910
	ld (w1Link.direction),a		; $6912
	ld ($cbb7),a		; $6915
	jr @func_6955		; $6918
@stateB:
	call decCbb3		; $691a
	jr nz,@func_6948	; $691d
	call checkIsLinkedGame		; $691f
	jr z,@func_692b	; $6922
	ld a,$08		; $6924
	ld ($cfd0),a		; $6926
	jr @incCutsceneState		; $6929
@func_692b:
	call getFreePartSlot		; $692b
	jr nz,+			; $692e
	ld (hl),PARTID_LIGHTNING		; $6930
	inc l			; $6932
	inc (hl)		; $6933
	inc l			; $6934
	inc (hl)		; $6935
	ld l,$cb		; $6936
	ld (hl),$40		; $6938
	ld l,$cd		; $693a
	ld (hl),$88		; $693c
+
	call getFreeInteractionSlot		; $693e
	jr nz,@incCutsceneState	; $6941
	ld (hl),INTERACID_CLOAKED_TWINROVA		; $6943
@incCutsceneState:
	jp _cutscene_incCutsceneState		; $6945
@func_6948:
	call _cutscene_decCBB6		; $6948
	ret nz			; $694b
	ld l,$b7		; $694c
	ld a,(hl)		; $694e
	xor $02			; $694f
	ld (hl),a		; $6951
	call @func_6962		; $6952
@func_6955:
	call getRandomNumber_noPreserveVars		; $6955
	and $03			; $6958
	add a			; $695a
	add a			; $695b
	add $10			; $695c
	ld (wTmpcbb6),a		; $695e
	ret			; $6961
@func_6962:
	ld (w1Link.direction),a		; $6962
	ld a,$08		; $6965
	ld (wLinkForceState),a		; $6967
	ret			; $696a
@stateC:
	ld a,($cfd0)		; $696b
	cp $63			; $696e
	jr z,@func_699a	; $6970
	call checkIsLinkedGame		; $6972
	ret z			; $6975
	ld a,($cfd0)		; $6976
	cp $09			; $6979
	ret nc			; $697b
	ld a,(wFrameCounter)		; $697c
	and $07			; $697f
	ret nz			; $6981
	callab interactionBank0a.func_0a_7877		; $6982
	ld de,w1Link.yh		; $698a
	call objectGetRelativeAngle		; $698d
	call convertAngleToDirection		; $6990
	ld h,d			; $6993
	ld l,$08		; $6994
	cp (hl)			; $6996
	ret z			; $6997
	jr @func_6962		; $6998
@func_699a:
	xor a			; $699a
	ld (wMenuDisabled),a		; $699b
	ld (wDisabledObjects),a		; $699e
	ld a,(wLoadingRoomPack)		; $69a1
	ld (wRoomPack),a		; $69a4
	ld a,GLOBALFLAG_SAVED_NAYRU		; $69a7
	call setGlobalFlag		; $69a9
	call refreshObjectGfx		; $69ac
	ld a,CUTSCENE_INGAME		; $69af
	ld (wCutsceneIndex),a		; $69b1
	ret			; $69b4

;;
; CUTSCENE_BLACK_TOWER_COMPLETE
_blackTowerCompleteCutsceneHandler:
	call @runStates		; $69b5
	call updateStatusBar		; $69b8
	jp updateAllObjects		; $69bb
	
@runStates:
	ld de,wCutsceneState		; $69be
	ld a,(de)		; $69c1
	rst_jumpTable			; $69c2
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
@state0:
	ld a,$3c		; $69cf
	ld (wTmpcbb3),a		; $69d1
	jp _cutscene_incCutsceneState		; $69d4
@state1:
	call decCbb3		; $69d7
	ret nz			; $69da
	call _cutscene_incCutsceneState		; $69db
	ld a,SNDCTRL_FAST_FADEOUT		; $69de
	call playSound		; $69e0
	jp fastFadeoutToBlack		; $69e3
@state2:
	ld a,(wPaletteThread_mode)		; $69e6
	or a			; $69e9
	ret nz			; $69ea
	call hideStatusBar		; $69eb
	ld a,($ff00+R_SVBK)	; $69ee
	push af			; $69f0
	ld a,$02		; $69f1
	ld ($ff00+R_SVBK),a	; $69f3
	ld hl,$de90		; $69f5
	ld b,$30		; $69f8
	call clearMemory		; $69fa
	pop af			; $69fd
	ld ($ff00+R_SVBK),a	; $69fe
	callab bank1.checkDisableUnderwaterWaves		; $6a00
	xor a			; $6a08
	ld (wScrollMode),a		; $6a09
	ld (wTilesetFlags),a		; $6a0c
	ld (wGfxRegs1.LYC),a		; $6a0f
	ld (wGfxRegs2.SCY),a		; $6a12
	ld ($d01a),a		; $6a15
	ld a,$10		; $6a18
	ld (wScreenOffsetY),a		; $6a1a
	call checkIsLinkedGame		; $6a1d
	jr z,@func_6a2b	; $6a20
	call _cutscene_incCutsceneState		; $6a22
	ld hl,wTmpcbb3		; $6a25
	ld (hl),$1e		; $6a28
	ret			; $6a2a
@func_6a2b:
	call clearWramBank1		; $6a2b
	call clearOam		; $6a2e
	ld a,$05		; $6a31
	ld (wCutsceneState),a		; $6a33
	ldbc INTERACID_CLOAKED_TWINROVA $01		; $6a36
	jp _createInteraction		; $6a39
@state3:
	call decCbb3		; $6a3c
	ret nz			; $6a3f
	ld a,SND_LIGHTNING		; $6a40
	call playSound		; $6a42
	xor a			; $6a45
	ld hl,wTmpcbb3		; $6a46
	ld (hl),a		; $6a49
	dec a			; $6a4a
	ld hl,wTmpcbba		; $6a4b
	ld (hl),a		; $6a4e
	jp _cutscene_incCutsceneState		; $6a4f
@state4:
	ld hl,wTmpcbb3		; $6a52
	ld b,$02		; $6a55
	call flashScreen		; $6a57
	ret z			; $6a5a
	call _cutscene_incCutsceneState		; $6a5b
	ld a,$10		; $6a5e
	ld ($cfde),a		; $6a60
	callab _cutscene_loadRoomObjectSetAndFadein
	call showStatusBar		; $6a6b
	ld a,MUS_DISASTER		; $6a6e
	call playSound		; $6a70
	ld a,PALH_ac		; $6a73
	call loadPaletteHeader		; $6a75
	ld a,$02		; $6a78
	call loadGfxRegisterStateIndex		; $6a7a
	xor a			; $6a7d
	ld (wScrollMode),a		; $6a7e
	ld a,$28		; $6a81
	ld (wGfxRegs2.SCX),a		; $6a83
	ldh (<hCameraX),a	; $6a86
	ld a,$f0		; $6a88
	ld (wGfxRegs2.SCY),a		; $6a8a
@state5:
	ret			; $6a8d


;;
; CUTSCENE_TURN_TO_STONE
_turnToStoneCutsceneHandler:
	call @runStates		; $6a8e
	call updateStatusBar		; $6a91
	jp updateAllObjects		; $6a94

@runStates:
	ld de,wCutsceneState		; $6a97
	ld a,(de)		; $6a9a
	rst_jumpTable			; $6a9b
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
@state0:
	call _cutscene_incCutsceneState		; $6aaa
	ld b,$20		; $6aad
	ld hl,$cfc0		; $6aaf
	call clearMemory		; $6ab2
	ld a,$0d		; $6ab5
	ld hl,$cfde		; $6ab7
	ldi (hl),a		; $6aba
	ld (hl),$00		; $6abb
	call showStatusBar		; $6abd
	jp fadeoutToWhite		; $6ac0
@state1:
	ld a,(wPaletteThread_mode)		; $6ac3
	or a			; $6ac6
	ret nz			; $6ac7
	call _cutscene_incCutsceneState		; $6ac8
	call _cutscene_loadRoomObjectSetAndFadein		; $6acb
	ld a,$02		; $6ace
	jp loadGfxRegisterStateIndex		; $6ad0
@state2:
	ld a,(wPaletteThread_mode)		; $6ad3
	or a			; $6ad6
	ret nz			; $6ad7
	ld hl,$cfdf		; $6ad8
	ld a,(hl)		; $6adb
	cp $ff			; $6adc
	ret nz			; $6ade
	xor a			; $6adf
	ldd (hl),a		; $6ae0
	inc (hl)		; $6ae1
	ld a,(hl)		; $6ae2
	cp $0f			; $6ae3
	ld a,$01		; $6ae5
	jr nz,+			; $6ae7
	ld a,$03		; $6ae9
+
	ld hl,wCutsceneState		; $6aeb
	ld (hl),a		; $6aee
	jp fadeoutToWhite		; $6aef
@state3:
	ld a,(wPaletteThread_mode)		; $6af2
	or a			; $6af5
	ret nz			; $6af6
	call @state1		; $6af7
	ld a,$08		; $6afa
	ld b,$28		; $6afc
	ld hl,hCameraY		; $6afe
	ldi (hl),a		; $6b01
	inc l			; $6b02
	ld (hl),b		; $6b03
	ld a,$f8		; $6b04
	ld hl,wGfxRegs2.SCY		; $6b06
	ldi (hl),a		; $6b09
	ld (hl),b		; $6b0a
	xor a			; $6b0b
	ld (wScrollMode),a		; $6b0c
	ld (wScreenOffsetY),a		; $6b0f
	ld (wScreenOffsetX),a		; $6b12
	ret			; $6b15
@state4:
	ld a,($cfc0)		; $6b16
	cp $03			; $6b19
	ret nz			; $6b1b
	call _cutscene_incCutsceneState		; $6b1c
	jp fadeoutToWhite		; $6b1f
@state5:
	ld a,(wPaletteThread_mode)		; $6b22
	or a			; $6b25
	ret nz			; $6b26
	call _cutscene_incCutsceneState		; $6b27
	call clearDynamicInteractions		; $6b2a
	ld bc, ROOM_AGES_290		; $6b2d
	call disableLcdAndLoadRoom		; $6b30
	call resetCamera		; $6b33
	ld hl,objectData.objectData7798		; $6b36
	call parseGivenObjectData		; $6b39
	ld hl,$d000		; $6b3c
	ld (hl),$03		; $6b3f
	ld l,$0b		; $6b41
	ld (hl),$58		; $6b43
	ld l,$0d		; $6b45
	ld (hl),$50		; $6b47
	ld l,$08		; $6b49
	ld (hl),$02		; $6b4b
	call refreshObjectGfx		; $6b4d
	ld a,SNDCTRL_STOPMUSIC		; $6b50
	call playSound		; $6b52
	call showStatusBar		; $6b55
	ld a,$02		; $6b58
	call loadGfxRegisterStateIndex		; $6b5a
	ld a,(wLoadingRoomPack)		; $6b5d
	ld (wRoomPack),a		; $6b60
	jp fadeinFromWhiteToRoom		; $6b63
@state6:
	ld a,(wPaletteThread_mode)		; $6b66
	or a			; $6b69
	ret nz			; $6b6a
	ld a,$01		; $6b6b
	ld (wMenuDisabled),a		; $6b6d
	ld (wDisabledObjects),a		; $6b70
	ld (wCutsceneIndex),a		; $6b73
	ret			; $6b76

;;
; CUTSCENE_TWINROVA_REVEAL
_twinrovaRevealCutsceneHandler:
	call @runStates		; $6b77
	call updateStatusBar		; $6b7a
	jp updateAllObjects		; $6b7d
	
@runStates:
	ld de,wCutsceneState		; $6b80
	ld a,(de)		; $6b83
	rst_jumpTable			; $6b84
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
	call _cutscene_incCutsceneState		; $6b99
	ld b,$20		; $6b9c
	ld hl,$cfc0		; $6b9e
	call clearMemory		; $6ba1
	ld a,SNDCTRL_STOPMUSIC		; $6ba4
	call playSound		; $6ba6
	ld hl,wTmpcbb3		; $6ba9
	ld (hl),$3c		; $6bac
	ld bc,TX_2810		; $6bae
	call checkIsLinkedGame		; $6bb1
	jr z,+			; $6bb4
	ld c,<TX_2815		; $6bb6
+
	ld a,$02		; $6bb8
	ld ($cfc0),a		; $6bba
	jp showText		; $6bbd
@state1:
	call _cutscene_decCBB3IfTextNotActive		; $6bc0
	ret nz			; $6bc3
	ld a,SNDCTRL_STOPMUSIC		; $6bc4
	call playSound		; $6bc6
@func_6bc9:
	ld hl,wTmpcbb3		; $6bc9
	xor a			; $6bcc
	ld (hl),a		; $6bcd
	dec a			; $6bce
	ld (wTmpcbba),a		; $6bcf
	jp _cutscene_incCutsceneState		; $6bd2
@state2:
	ld hl,wTmpcbb3		; $6bd5
	ld b,$01		; $6bd8
	call flashScreen		; $6bda
	ret z			; $6bdd
	call checkIsLinkedGame		; $6bde
	jr nz,@func_6be8	; $6be1
	call _func_6fb0		; $6be3
	jr ++			; $6be6
@func_6be8:
	call _func_6f9e		; $6be8
++
	ld a,$01		; $6beb
	ld (wDisabledObjects),a		; $6bed
	call clearDynamicInteractions		; $6bf0
	ld hl,objectData.objectData77b2		; $6bf3
	call checkIsLinkedGame		; $6bf6
	jr nz,+			; $6bf9
	ld hl,wCutsceneState		; $6bfb
	ld (hl),$06		; $6bfe
	ld hl,objectData.objectData77a5		; $6c00
+
	call parseGivenObjectData		; $6c03
	jp _cutscene_incCutsceneState		; $6c06
@state3:
	ld a,($cfc0)		; $6c09
	cp $03			; $6c0c
	ret nz			; $6c0e
	ld a,SNDCTRL_STOPMUSIC		; $6c0f
	call playSound		; $6c11
	ld a,SND_LIGHTNING		; $6c14
	call playSound		; $6c16
	jp @func_6bc9		; $6c19
@state4:
	ld hl,wTmpcbb3		; $6c1c
	ld b,$04		; $6c1f
	call flashScreen		; $6c21
	ret z			; $6c24
	ld a,$12		; $6c25
	ld ($cfde),a		; $6c27
	call _cutscene_loadRoomObjectSetAndFadein		; $6c2a
	call showStatusBar		; $6c2d
	call _cutscene_incCutsceneState		; $6c30
	ld a,MUS_ZELDA_SAVED		; $6c33
	call playSound		; $6c35
	ld a,$02		; $6c38
	call loadGfxRegisterStateIndex		; $6c3a
	jp resetCamera		; $6c3d
@state5:
	ld hl,$cfdf		; $6c40
	ld a,(hl)		; $6c43
	cp $ff			; $6c44
	ret nz			; $6c46
	ld a,SND_LIGHTNING		; $6c47
	call playSound		; $6c49
	ld a,SNDCTRL_STOPMUSIC		; $6c4c
	call playSound		; $6c4e
	jp @func_6bc9		; $6c51
@state6:
	ld hl,wTmpcbb3		; $6c54
	ld b,$01		; $6c57
	call flashScreen		; $6c59
	ret z			; $6c5c
	ld hl,$cfde		; $6c5d
	inc (hl)		; $6c60
	call _cutscene_loadRoomObjectSetAndFadein		; $6c61
	ld hl,$d000		; $6c64
	ld (hl),$03		; $6c67
	ld l,$0b		; $6c69
	ld (hl),$68		; $6c6b
	ld l,$0d		; $6c6d
	ld (hl),$50		; $6c6f
	ld l,$08		; $6c71
	ld (hl),$00		; $6c73
	ld a,$2c		; $6c75
	ld b,$03		; $6c77
	call _cutscene_loadAObjectGfxBTimes		; $6c79
	call _cutscene_incCutsceneState		; $6c7c
	xor a			; $6c7f
	ld (wPaletteThread_mode),a		; $6c80
	ldh (<hVBlankFunctionQueueTail),a	; $6c83
	inc a			; $6c85
	ld (wDisabledObjects),a		; $6c86
	ld (wMenuDisabled),a		; $6c89
	ld a,(wLoadingRoomPack)		; $6c8c
	ld (wRoomPack),a		; $6c8f
	call reloadObjectGfx		; $6c92
	ld a,$02		; $6c95
	call loadGfxRegisterStateIndex		; $6c97
	jp _func_6fb0		; $6c9a
@state7:
	ld a,($cfd0)		; $6c9d
	cp $09			; $6ca0
	ret nz			; $6ca2
	ld a,SNDCTRL_FAST_FADEOUT		; $6ca3
	call playSound		; $6ca5
	call fadeoutToBlack		; $6ca8
	ld a,$ff		; $6cab
	ld (wFadeSprPaletteSources),a		; $6cad
	ld (wDirtyFadeSprPalettes),a		; $6cb0
	ld a,$03		; $6cb3
	ld (wFadeBgPaletteSources),a		; $6cb5
	ld (wDirtyFadeBgPalettes),a		; $6cb8
	jp _cutscene_incCutsceneState		; $6cbb
@state8:
	ld a,(wPaletteThread_mode)		; $6cbe
	or a			; $6cc1
	ret nz			; $6cc2
	call _cutscene_incCutsceneState		; $6cc3
	call showStatusBar		; $6cc6
	ld a,GLOBALFLAG_GOT_MAKU_SEED		; $6cc9
	call setGlobalFlag		; $6ccb
	ld a,$01		; $6cce
	ld (wScrollMode),a		; $6cd0
	xor a			; $6cd3
	ld (wScreenShakeCounterY),a		; $6cd4
	ld (wScreenShakeCounterX),a		; $6cd7
	ld a,$0f		; $6cda
	ld (wGfxRegs1.LYC),a		; $6cdc
	ld a,$f0		; $6cdf
	ld (wGfxRegs2.SCY),a		; $6ce1
	call fadeinFromBlack		; $6ce4
	ldbc INTERACID_MAKU_TREE $06		; $6ce7
	call _createInteraction		; $6cea
	ld bc,$4050		; $6ced
	call interactionHSetPosition		; $6cf0
	ld a,(wActiveMusic2)		; $6cf3
	ld (wActiveMusic),a		; $6cf6
	jp playSound		; $6cf9
@state9:
	ld a,($cfc0)		; $6cfc
	cp $04			; $6cff
	ret nz			; $6d01
	call refreshObjectGfx		; $6d02
	ld a,CUTSCENE_INGAME		; $6d05
	ld (wCutsceneIndex),a		; $6d07
	ret			; $6d0a


;;
; CUTSCENE_PREGAME_INTRO
_pregameIntroCutsceneHandler:
	call @runStates		; $6d0b
	jp updateAllObjects		; $6d0e
	
@runStates:
	ld de,wCutsceneState		; $6d11
	ld a,(de)		; $6d14
	rst_jumpTable			; $6d15
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
	ld a,(wPaletteThread_mode)		; $6d30
	or a			; $6d33
	ret nz			; $6d34
	call checkIsLinkedGame		; $6d35
	jr nz,@func_6d40	; $6d38
	ld a,$0a		; $6d3a
	ld (de),a		; $6d3c
	jp @stateA		; $6d3d
@func_6d40:
	ld a,$01		; $6d40
	ld (de),a		; $6d42
	ld bc, ROOM_AGES_5f1		; $6d43
	call disableLcdAndLoadRoom		; $6d46
	call resetCamera		; $6d49
	ld a,PALH_ac		; $6d4c
	call loadPaletteHeader		; $6d4e
	ld hl,objectData.objectData77b6		; $6d51
	call parseGivenObjectData		; $6d54
	ld a,MUS_FINAL_DUNGEON		; $6d57
	call playSound		; $6d59
	ld hl,wTmpcbb3		; $6d5c
	ld (hl),$3c		; $6d5f
	ld a,$13		; $6d61
	call loadGfxRegisterStateIndex		; $6d63
	ld a,(wGfxRegs2.SCX)		; $6d66
	ldh (<hCameraX),a	; $6d69
	xor a			; $6d6b
	ldh (<hCameraY),a	; $6d6c
	ld a,$00		; $6d6e
	ld (wScrollMode),a		; $6d70
	jp _clearFadingPalettes		; $6d73
@state1:
	ld e,$96		; $6d76
--
	call decCbb3		; $6d78
	ret nz			; $6d7b
	call _cutscene_incCutsceneState		; $6d7c
	ld hl,wTmpcbb3		; $6d7f
	ld (hl),e		; $6d82
	ret			; $6d83
@state2:
	ld e,$3c		; $6d84
	jr --			; $6d86
@state3:
	call decCbb3		; $6d88
	ret nz			; $6d8b
	call _cutscene_incCutsceneState		; $6d8c
	call fastFadeinFromBlack		; $6d8f
	ld a,$40		; $6d92
	ld (wDirtyFadeSprPalettes),a		; $6d94
	ld (wFadeSprPaletteSources),a		; $6d97
	ld a,$03		; $6d9a
	ld (wDirtyFadeBgPalettes),a		; $6d9c
	ld (wFadeBgPaletteSources),a		; $6d9f
	ld a,SND_LIGHTTORCH		; $6da2
	jp playSound		; $6da4
@state4:
	ld a,(wPaletteThread_mode)		; $6da7
	or a			; $6daa
	ret nz			; $6dab
	call _cutscene_incCutsceneState		; $6dac
	ld a,$0e		; $6daf
	ld (wTmpcbb3),a		; $6db1
	call fadeinFromBlack		; $6db4
	ld a,$bf		; $6db7
	ld (wDirtyFadeSprPalettes),a		; $6db9
	ld (wFadeSprPaletteSources),a		; $6dbc
	ld a,$fc		; $6dbf
	ld (wDirtyFadeBgPalettes),a		; $6dc1
	ld (wFadeBgPaletteSources),a		; $6dc4
	ret			; $6dc7
@state5:
	call decCbb3		; $6dc8
	ret nz			; $6dcb
	xor a			; $6dcc
	ld (wPaletteThread_mode),a		; $6dcd
	ld a,$78		; $6dd0
	ld (wTmpcbb3),a		; $6dd2
	jp _cutscene_incCutsceneState		; $6dd5
@state6:
	call decCbb3		; $6dd8
	ret nz			; $6ddb
	call _cutscene_incCutsceneState		; $6ddc
	ld a,TEXTBOXFLAG_DONTCHECKPOSITION		; $6ddf
	ld (wTextboxFlags),a		; $6de1
	ld a,$03		; $6de4
	ld (wTextboxPosition),a		; $6de6
	ld bc,TX_281a		; $6de9
	jp showText		; $6dec
@state7:
	call retIfTextIsActive		; $6def
	call _cutscene_incCutsceneState		; $6df2
	ld (wTmpcbb3),a		; $6df5
	dec a			; $6df8
	ld (wTmpcbba),a		; $6df9
	call restartSound		; $6dfc
	ld a,SND_BIG_EXPLOSION_2		; $6dff
	jp playSound		; $6e01
@state8:
	ld hl,wTmpcbb3		; $6e04
	ld b,$03		; $6e07
	call flashScreen		; $6e09
	ret z			; $6e0c
	call _cutscene_incCutsceneState		; $6e0d
	ld a,$3c		; $6e10
	ld (wTmpcbb3),a		; $6e12
	ld a,$02		; $6e15
	jp fadeoutToWhiteWithDelay		; $6e17
@state9:
	ld a,(wPaletteThread_mode)		; $6e1a
	or a			; $6e1d
	ret nz			; $6e1e
	call decCbb3		; $6e1f
	ret nz			; $6e22
	jp _cutscene_incCutsceneState		; $6e23
@stateA:
	call disableLcd		; $6e26
	ld a,($ff00+R_SVBK)	; $6e29
	push af			; $6e2b
	ld a,$02		; $6e2c
	ld ($ff00+R_SVBK),a	; $6e2e
	ld hl,$de80		; $6e30
	ld b,$40		; $6e33
	call clearMemory		; $6e35
	pop af			; $6e38
	ld ($ff00+R_SVBK),a	; $6e39
	call clearScreenVariablesAndWramBank1		; $6e3b
	call clearOam		; $6e3e
	ld a,PALH_0f		; $6e41
	call loadPaletteHeader		; $6e43
	ld a,$02		; $6e46
	call _func_6e9a		; $6e48
	call _func_6eb7		; $6e4b
	ld a,MUS_ESSENCE_ROOM		; $6e4e
	call playSound		; $6e50
	ld a,$08		; $6e53
	call setLinkID		; $6e55
	ld l,$00		; $6e58
	ld (hl),$01		; $6e5a
	ld l,$02		; $6e5c
	ld (hl),$0b		; $6e5e
	ld a,$00		; $6e60
	ld (wScrollMode),a		; $6e62
	call _cutscene_incCutsceneState		; $6e65
	call clearPaletteFadeVariablesAndRefreshPalettes		; $6e68
	xor a			; $6e6b
	ldh (<hCameraY),a	; $6e6c
	ldh (<hCameraX),a	; $6e6e
	ld a,$15		; $6e70
	jp loadGfxRegisterStateIndex		; $6e72
@stateB:
	ld a,(wTmpcbb9)		; $6e75
	cp $07			; $6e78
	ret nz			; $6e7a
	call clearLinkObject		; $6e7b
	ld hl,wTmpcbb3		; $6e7e
	ld (hl),$3c		; $6e81
	jp _cutscene_incCutsceneState		; $6e83
@stateC:
	call decCbb3		; $6e86
	ret nz			; $6e89
	ld hl,wGameState		; $6e8a
	xor a			; $6e8d
	ldi (hl),a		; $6e8e
	ld (hl),a		; $6e8f
	ld a,SNDCTRL_STOPMUSIC		; $6e90
	call playSound		; $6e92
	ld a,GLOBALFLAG_3d		; $6e95
	jp setGlobalFlag		; $6e97
	
_func_6e9a:
	ldh (<hFF8B),a	; $6e9a
	ld a,$01		; $6e9c
	ld ($ff00+R_VBK),a	; $6e9e
	ld hl,$9800		; $6ea0
	ld bc,$0400		; $6ea3
	ldh a,(<hFF8B)	; $6ea6
	call fillMemoryBc		; $6ea8
	xor a			; $6eab
	ld ($ff00+R_VBK),a	; $6eac
	ld hl,$9800		; $6eae
	ld bc,$0400		; $6eb1
	jp clearMemoryBc		; $6eb4

_func_6eb7:
	ld a,($ff00+R_SVBK)	; $6eb7
	push af			; $6eb9
	
	ld a,$03		; $6eba
	ld ($ff00+R_SVBK),a	; $6ebc
	
	ld hl,w3VramTiles		; $6ebe
	ld bc,$0240		; $6ec1
	call clearMemoryBc		; $6ec4
	
	ld hl,w3VramAttributes		; $6ec7
	ld bc,$0240		; $6eca
	ld a,$02		; $6ecd
	call fillMemoryBc		; $6ecf
	
	pop af			; $6ed2
	ld ($ff00+R_SVBK),a	; $6ed3
	ret			; $6ed5
	
_func_6ed6:
	ldh (<hFF8B),a	; $6ed6
	ld a,($ff00+R_SVBK)	; $6ed8
	push af			; $6eda
	ld a,$04		; $6edb
	ld ($ff00+R_SVBK),a	; $6edd
	ld hl,$d000		; $6edf
	ld bc,$0240		; $6ee2
	call clearMemoryBc		; $6ee5
	ld hl,$d400		; $6ee8
	ld bc,$0240		; $6eeb
	ldh a,(<hFF8B)	; $6eee
	call fillMemoryBc		; $6ef0
	pop af			; $6ef3
	ld ($ff00+R_SVBK),a	; $6ef4
	ret			; $6ef6

_func_6ef7:
	ld a,(wTmpcbb9)		; $6ef7
	or a			; $6efa
	jr z,_func_6f0b	; $6efb
	ld hl,$cbb7		; $6efd
	ld b,$01		; $6f00
	call flashScreen		; $6f02
	ret z			; $6f05
	xor a			; $6f06
	ld (wTmpcbb9),a		; $6f07
	ret			; $6f0a
	
_func_6f0b:
	ld a,(wFrameCounter)		; $6f0b
	and $1f			; $6f0e
	ret nz			; $6f10
	call getRandomNumber		; $6f11
	and $07			; $6f14
	ret nz			; $6f16
	ld ($cbb7),a		; $6f17
	dec a			; $6f1a
	ld (wTmpcbb9),a		; $6f1b
	ld (wTmpcbba),a		; $6f1e
	ld a,SND_LIGHTNING		; $6f21
	jp playSound		; $6f23

_func_6f26:
	ld hl,wTmpcbb6		; $6f26
	dec (hl)		; $6f29
	ret nz			; $6f2a
	call decCbb3		; $6f2b
	ret z			; $6f2e
	ld a,(wTmpcbbb)		; $6f2f
	ld (wTmpcbb6),a		; $6f32
	ld hl,wGfxRegs1.SCY		; $6f35
	dec (hl)		; $6f38
	ld a,(hl)		; $6f39
	or a			; $6f3a
	ret nz			; $6f3b
	ld a,UNCMP_GFXH_34		; $6f3c
	call loadUncompressedGfxHeader		; $6f3e
	or $01			; $6f41
	ret			; $6f43

_func_6f44:
	ld a,(wGfxRegs1.SCY)		; $6f44
	cpl			; $6f47
	inc a			; $6f48
	ld b,a			; $6f49
	xor a			; $6f4a
	ldh (<hOamTail),a	; $6f4b
	ld c,a			; $6f4d
	ld a,($cbb8)		; $6f4e
	rst_jumpTable			; $6f51
	.dw @cbb8_00
	.dw @cbb8_01
	.dw @cbb8_02
@cbb8_00:
	ld hl,bank3f.oamData_714c		; $6f58
	ld e,:bank3f.oamData_714c		; $6f5b
	jp addSpritesFromBankToOam_withOffset		; $6f5d
@cbb8_01:
	ld hl,bank3f.oamData_718d		; $6f60
	ld e,:bank3f.oamData_718d		; $6f63
	call addSpritesFromBankToOam_withOffset		; $6f65
	ld hl,bank3f.oamData_71ce		; $6f68
	ld e,:bank3f.oamData_71ce		; $6f6b
	jp addSpritesFromBankToOam_withOffset		; $6f6d
@cbb8_02:
	ld hl,bank3f.oamData_71f7		; $6f70
	ld e,:bank3f.oamData_71f7		; $6f73
	call addSpritesFromBankToOam_withOffset		; $6f75
	ld hl,bank3f.oamData_718d		; $6f78
	ld e,:bank3f.oamData_718d		; $6f7b
	ld a,(wGfxRegs1.SCY)		; $6f7d
	cp $71			; $6f80
	jr c,+			; $6f82
	ld hl,bank3f.oamData_7220		; $6f84
	ld e,:bank3f.oamData_7220		; $6f87
+
	jp addSpritesFromBankToOam_withOffset		; $6f89

_cutscene_incCutsceneState:
	ld hl,wCutsceneState	; $6f8c
	inc (hl)		; $6f8f
	ret			; $6f90

_cutscene_decCBB6:
	ld hl,wTmpcbb6		; $6f91
	dec (hl)		; $6f94
	ret			; $6f95
	
_cutscene_decCBB3whenFadeDone:
	ld a,(wPaletteThread_mode)		; $6f96
	or a			; $6f99
	ret nz			; $6f9a
	jp decCbb3		; $6f9b

_func_6f9e:
	ld a,($ff00+R_SVBK)	; $6f9e
	push af			; $6fa0
	ld a,$02		; $6fa1
	ld ($ff00+R_SVBK),a	; $6fa3
	ld hl,$de90		; $6fa5
	ld b,$30		; $6fa8
	call clearMemory		; $6faa
	pop af			; $6fad
	ld ($ff00+R_SVBK),a	; $6fae
_func_6fb0:
	ld a,($ff00+R_SVBK)	; $6fb0
	push af			; $6fb2
	
	ld a,$02		; $6fb3
	ld ($ff00+R_SVBK),a	; $6fb5
	ld hl,w2FadingBgPalettes		; $6fb7
	ld b,$80		; $6fba
	call clearMemory		; $6fbc
	
	pop af			; $6fbf
	ld ($ff00+R_SVBK),a	; $6fc0
	call hideStatusBar		; $6fc2
	ld a,$fc		; $6fc5
	ldh (<hBgPaletteSources),a	; $6fc7
	ldh (<hDirtyBgPalettes),a	; $6fc9
	xor a			; $6fcb
	ld (wScrollMode),a		; $6fcc
	ld (wGfxRegs1.LYC),a		; $6fcf
	ld (wGfxRegs2.SCY),a		; $6fd2
	ret			; $6fd5

;;
; @param	a	Index?
; @param[out]	b	Index for "objectTable2"?
; @param[out]	c
; @addr{6fd6}
_cutscene_disableLcdLoadRoomResetCamera:
	ld hl,@data		; $6fd6
	rst_addDoubleIndex			; $6fd9
	ld b,(hl)		; $6fda
	inc hl			; $6fdb
	ld c,(hl)		; $6fdc
	call disableLcdAndLoadRoom		; $6fdd
	jp resetCamera		; $6fe0

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
	dwbe ROOM_AGES_5f1
	dwbe ROOM_AGES_165
	dwbe ROOM_AGES_149
	dwbe ROOM_AGES_184
	dwbe ROOM_AGES_4f6
	dwbe ROOM_AGES_5f1
	dwbe ROOM_AGES_038
	dwbe ROOM_AGES_149
	dwbe ROOM_AGES_038


_cutscene_tickDownCBB4ThenSetTo30:
	ld hl,$cbb4		; $700b
	dec (hl)		; $700e
	ret nz			; $700f
	ld (hl),30		; $7010
	ret			; $7012
	
_cutscene_incState:
	ld hl,wCutsceneState		; $7013
	inc (hl)		; $7016
	ret			; $7017
	
_cutscene_incCBB3:
	ld hl,wTmpcbb3		; $7018
	inc (hl)		; $701b
	ret			; $701c

;;
; CUTSCENE_WALL_RETRACTION
; @addr{701d}
func_701d:
	ld a,(wDungeonIndex)		; $701d
	cp $08			; $7020
	jp z,_wallRetraction_dungeon8		; $7022
	ld a,(wCutsceneState)		; $7025
	rst_jumpTable			; $7028
	.dw @state0
	.dw @state1

@state0:
	ld a,$72		; $702d
@func_702f:
	call loadGfxHeader		; $702f
	ld b,$10		; $7032
	ld hl,wTmpcbb3		; $7034
	call clearMemory		; $7037
	call reloadTileMap		; $703a
	call resetCamera		; $703d
	call getThisRoomFlags		; $7040
	set 6,(hl)		; $7043
	call loadTilesetAndRoomLayout		; $7045
	ld a,$3c		; $7048
	ld (wTmpcbb4),a		; $704a
	xor a			; $704d
	ld (wScrollMode),a		; $704e
	jr _cutscene_incState		; $7051
@state1:
	ld a,(wTmpcbb3)		; $7053
	rst_jumpTable			; $7056
	.dw @cbb3_00
	.dw @cbb3_01
@cbb3_00:
	call _cutscene_tickDownCBB4ThenSetTo30		; $705b
	ret nz			; $705e
	ld (hl),$3c		; $705f
	jr _cutscene_incCBB3		; $7061
@cbb3_01:
	ld a,$3c		; $7063
	call setScreenShakeCounter		; $7065
	call _cutscene_tickDownCBB4ThenSetTo30		; $7068
	ret nz			; $706b
	ld (hl),$19		; $706c
	callab generateW3VramTilesAndAttributes		; $706e
	ld bc,$260c		; $7076
	call _func_70f7		; $7079
	xor a			; $707c
	ld ($ff00+R_SVBK),a	; $707d
	call reloadTileMap		; $707f
	ld a,SND_DOORCLOSE		; $7082
	call playSound		; $7084
	ld hl,$cbb7		; $7087
	inc (hl)		; $708a
	ld a,(hl)		; $708b
	cp $0f			; $708c
	ret c			; $708e
	call _func_7098		; $708f
	ld a,$0f		; $7092
	ld ($ce5d),a		; $7094
	ret			; $7097

_func_7098:
	ld a,SND_SOLVEPUZZLE		; $7098
	call playSound		; $709a
	ld a,CUTSCENE_INGAME		; $709d
	ld (wCutsceneIndex),a		; $709f
	ld a,$01		; $70a2
	ld (wScrollMode),a		; $70a4
	xor a			; $70a7
	ld (wDisabledObjects),a		; $70a8
	ld (wMenuDisabled),a		; $70ab
	call loadTilesetAndRoomLayout		; $70ae
	jp loadRoomCollisions		; $70b1
	
_wallRetraction_dungeon8:
	ld a,(wCutsceneState)		; $70b4
	rst_jumpTable			; $70b7
	.dw @state0
	.dw @state1
@state0:
	ld a,$73		; $70bc
	jp func_701d@func_702f		; $70be
@state1:
	ld a,(wTmpcbb3)		; $70c1
	rst_jumpTable			; $70c4
	.dw func_701d@cbb3_00
	.dw @cbb3_01
@cbb3_01:
	ld a,$3c		; $70c9
	call setScreenShakeCounter		; $70cb
	call _cutscene_tickDownCBB4ThenSetTo30		; $70ce
	ret nz			; $70d1
	ld (hl),$19		; $70d2
	callab generateW3VramTilesAndAttributes		; $70d4
	ld bc,$4d04		; $70dc
	call _func_70f7		; $70df
	xor a			; $70e2
	ld ($ff00+R_SVBK),a	; $70e3
	call reloadTileMap		; $70e5
	ld a,SND_DOORCLOSE		; $70e8
	call playSound		; $70ea
	ld hl,$cbb7		; $70ed
	inc (hl)		; $70f0
	ld a,(hl)		; $70f1
	cp $0b			; $70f2
	ret c			; $70f4
	jr _func_7098		; $70f5
	
_func_70f7:
	ld a,c			; $70f7
	ldh (<hFF8C),a	; $70f8
	ld a,b			; $70fa
	ldh (<hFF8D),a	; $70fb
	swap a			; $70fd
	and $0f			; $70ff
	add a			; $7101
	ld e,a			; $7102
	ld a,($cbb7)		; $7103
	add e			; $7106
	ldh (<hFF93),a	; $7107
	ld c,$20		; $7109
	call multiplyAByC		; $710b
	ld bc,$d800		; $710e
	ldh a,(<hFF8D)	; $7111
	and $0f			; $7113
	call addDoubleIndexToBc		; $7115
	add hl,bc		; $7118
	ldh a,(<hFF8C)	; $7119
	ld b,a			; $711b
	ld a,$20		; $711c
	sub b			; $711e
	ldh (<hFF8E),a	; $711f
	push hl			; $7121
	ld c,d			; $7122
	ld de,$d000		; $7123
	call _func_712f		; $7126
	pop hl			; $7129
	set 2,h			; $712a
	ld de,$d400		; $712c
_func_712f:
	ldh a,(<hFF93)		; $712f
	ld c,a			; $7131
	ld a,$14		; $7132
	sub c			; $7134
	ret c			; $7135
	ld c,a			; $7136
--
	ldh a,(<hFF8C)	; $7137
	ld b,a			; $7139
-
	ld a,$02		; $713a
	ld ($ff00+R_SVBK),a	; $713c
	ld a,(de)		; $713e
	inc de			; $713f
	ldh (<hFF8B),a	; $7140
	ld a,$03		; $7142
	ld ($ff00+R_SVBK),a	; $7144
	ldh a,(<hFF8B)	; $7146
	ldi (hl),a		; $7148
	dec b			; $7149
	jr nz,-			; $714a
	ldh a,(<hFF8E)	; $714c
	call addAToDe		; $714e
	ldh a,(<hFF8E)	; $7151
	rst_addAToHl			; $7153
	dec c			; $7154
	jr nz,--		; $7155
	ret			; $7157
	

_d2Collapse_decCBB4:
	ld hl,wTmpcbb4		; $7158
	dec (hl)		; $715b
	ret nz			; $715c
	ret			; $715d

_d2Collapse_incState:
	ld hl,wCutsceneState		; $715e
	inc (hl)		; $7161
	ret			; $7162

_d2Collapse_incCBB3:
	ld hl,wTmpcbb3		; $7163
	inc (hl)		; $7166
	ret			; $7167

;;
; CUTSCENE_D2_COLLAPSE
; @addr{7168}
func_7168:
	ld a,(wCutsceneState)		; $7168
	rst_jumpTable			; $716b
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld b,$10		; $7176
	ld hl,wTmpcbb3		; $7178
	call clearMemory		; $717b
	call getThisRoomFlags		; $717e
	set 7,(hl)		; $7181
	ld l,$73		; $7183
	set 7,(hl)		; $7185
	xor a			; $7187
	ld (wScrollMode),a		; $7188
	ld a,$3c		; $718b
	ld (wTmpcbb4),a		; $718d
	call _d2Collapse_incState		; $7190
	jp reloadTileMap		; $7193
@state1:
	call _d2Collapse_decCBB4		; $7196
	ret nz			; $7199
	call _d2Collapse_incState		; $719a
	call getFreeInteractionSlot		; $719d
	jr nz,+			; $71a0
	ld (hl),INTERACID_97		; $71a2
	ld l,$4b		; $71a4
	ld (hl),$2c		; $71a6
	ld l,$4d		; $71a8
	ld (hl),$58		; $71aa
+
	ld a,$50		; $71ac
	jp loadGfxHeader		; $71ae
@state2:
	ld a,$0f		; $71b1
	call setScreenShakeCounter		; $71b3
	call _func_stub		; $71b6
	ld a,(wTmpcbb3)		; $71b9
	rst_jumpTable			; $71bc
	.dw @cbb3_00
	.dw @cbb3_01
	.dw @cbb3_02
	.dw @cbb3_03

@cbb3_00:
	ld bc,roomGfxChanges.rectangleData_02_7de1		; $71c5
	callab roomGfxChanges.copyRectangleFromTmpGfxBuffer_paramBc		; $71c8
@func_71d0:
	ld a,UNCMP_GFXH_3c		; $71d0
	call loadUncompressedGfxHeader		; $71d2
	ld a,SND_DOORCLOSE		; $71d5
	call playSound		; $71d7
	ld a,$1e		; $71da
	ld (wTmpcbb4),a		; $71dc
	jp _d2Collapse_incCBB3		; $71df
@cbb3_01:
	ld b,$51		; $71e2
--
	call _d2Collapse_decCBB4		; $71e4
	ret nz			; $71e7
	ld (hl),$1e		; $71e8
	ld a,b			; $71ea
	call loadGfxHeader		; $71eb
	jr @cbb3_00		; $71ee
@cbb3_02:
	ld b,$52		; $71f0
	jr --			; $71f2
@cbb3_03:
	call _d2Collapse_decCBB4		; $71f4
	ret nz			; $71f7
	callab roomGfxChanges.drawCollapsedWingDungeon		; $71f8
	call @func_71d0		; $7200
	ld a,$3c		; $7203
	ld (wTmpcbb4),a		; $7205
	jp _d2Collapse_incState		; $7208
@state3:
	call _d2Collapse_decCBB4		; $720b
	ret nz			; $720e
	jp _d2Collapse_incState		; $720f
@state4:
	ld a,CUTSCENE_INGAME		; $7212
	ld (wCutsceneIndex),a		; $7214
	ld a,$01		; $7217
	ld (wScrollMode),a		; $7219
	ld hl,objectData.objectData7e69		; $721c
	call parseGivenObjectData		; $721f
	xor a			; $7222
	ld (wDisabledObjects),a		; $7223
	ld (wMenuDisabled),a		; $7226
	ld a,(wActiveMusic)		; $7229
	jp playSound		; $722c
_func_stub:
	ret			; $722f


; unused??
	.db $00 $01 $00 $00


_timewarpCutscene_decCBB4:
	ld hl,wTmpcbb4		; $7234
	dec (hl)		; $7237
	ret nz			; $7238
	ret			; $7239

_timewarpCutscene_incState:
	ld hl,wCutsceneState		; $723a
	inc (hl)		; $723d
	ret			; $723e

_timewarpCutscene_incCBB3:
	ld hl,wTmpcbb3		; $723f
	inc (hl)		; $7242
	ret			; $7243

;;
; CUTSCENE_TIMEWARP
; @addr{7244}
func_03_7244:
	ld a,(wCutsceneState)		; $7244
	rst_jumpTable			; $7247
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld b,$10		; $7250
	ld hl,wTmpcbb3		; $7252
	call clearMemory		; $7255
	call _timewarpCutscene_incState		; $7258
	call stopTextThread		; $725b
	xor a			; $725e
	ld hl,wLoadedTreeGfxActive		; $725f
	ldi (hl),a		; $7262
	ld (hl),a		; $7263
	ld a,$01		; $7264
	ld ($cc20),a		; $7266
	dec a			; $7269
	ld (wScrollMode),a		; $726a
	ld a,$08		; $726d
	ld ($cbb7),a		; $726f
	callab bank3f.agesFunc_3f_4133
	callab bank6.specialObjectLoadAnimationFrameToBuffer		; $727a
	ld a,$6f		; $7282
	call loadGfxHeader		; $7284
	call fastFadeoutToBlack		; $7287
	xor a			; $728a
	ld (wDirtyFadeSprPalettes),a		; $728b
	dec a			; $728e
	ld (wFadeSprPaletteSources),a		; $728f
	ld hl,wLoadedObjectGfx		; $7292
	ld b,$10		; $7295
	call clearMemory		; $7297
	jp hideStatusBar		; $729a
@state1:
	ld a,(wTmpcbb3)		; $729d
	rst_jumpTable			; $72a0
	.dw @@cbb3_00
	.dw @@cbb3_01
	.dw @@cbb3_02
	.dw @@cbb3_03
	.dw @@cbb3_04
	.dw @@cbb3_05
@@cbb3_00:
	ld hl,$d000		; $72ad
--
	call _func_7431		; $72b0
	call _func_745c		; $72b3
	jr _timewarpCutscene_incCBB3		; $72b6
@@cbb3_01:
	ld hl,$d400		; $72b8
	jr --			; $72bb
@@cbb3_02:
	ld hl,$d800		; $72bd
	jr --			; $72c0
@@cbb3_03:
	ld hl,$dc00		; $72c2
	jr --			; $72c5
@@cbb3_04:
	ld hl,$d000		; $72c7
	call _func_7431		; $72ca
	call _func_7456		; $72cd
	jp _timewarpCutscene_incCBB3		; $72d0
@@cbb3_05:
	ld hl,$d400		; $72d3
	call _func_7431		; $72d6
	call _func_7450		; $72d9
	ld hl,$cbb7		; $72dc
	dec (hl)		; $72df
	jr z,@@func_72ec	; $72e0
	ld hl,$cbb8		; $72e2
	inc (hl)		; $72e5
	ld hl,wTmpcbb3		; $72e6
	ld (hl),$00		; $72e9
	ret			; $72eb
	
@@func_72ec:
	xor a			; $72ec
	ld ($ff00+R_SVBK),a	; $72ed
	call clearItems		; $72ef
	call clearEnemies		; $72f2
	call clearParts		; $72f5
	call clearReservedInteraction0		; $72f8
	call clearDynamicInteractions		; $72fb
	ld de,$d100		; $72fe
	call objectDelete_de		; $7301
	ld a,$d0		; $7304
	ld (wLinkObjectIndex),a		; $7306
	call refreshObjectGfx		; $7309
	xor a			; $730c
	ld ($cc20),a		; $730d
	ld hl,wTmpcbb3		; $7310
	ld (hl),$00		; $7313
	jp _timewarpCutscene_incState		; $7315

@state2:
	ld a,(wTmpcbb3)		; $7318
	rst_jumpTable			; $731b
	.dw @@cbb3_00
	.dw @@cbb3_01
	.dw @@cbb3_02
	.dw @@cbb3_03
	.dw @@cbb3_04
@@cbb3_00:
	ld a,(wcddf)		; $7326
	or a			; $7329
	jr nz,+			; $732a
	callab func_04_6f07		; $732c
+
	ld a,$03		; $7334
	ld ($ff00+R_SVBK),a	; $7336
	ld bc,$02c0		; $7338
	ld hl,$d800		; $733b
	call clearMemoryBc		; $733e
	ld bc,$02c0		; $7341
	ld hl,$dc00		; $7344
	call clearMemoryBc		; $7347
	call reloadTileMap		; $734a
	jp _timewarpCutscene_incCBB3		; $734d
@@cbb3_01:
	call getFreeInteractionSlot		; $7350
	ld (hl),INTERACID_TIMEWARP		; $7353
	ld l,$46		; $7355
	ld a,$78		; $7357
	ld (hl),a		; $7359
	ld (wTmpcbb4),a		; $735a
	ld a,(wTilesetFlags)		; $735d
	and $80			; $7360
	ld a,$02		; $7362
	jr nz,+			; $7364
	dec a			; $7366
+
	ld l,$43		; $7367
	ld (hl),a		; $7369
	ld (wcc50),a		; $736a
	ld a,SND_TIMEWARP_INITIATED		; $736d
	call playSound		; $736f
	jp _timewarpCutscene_incCBB3		; $7372
@@cbb3_02:
	call _timewarpCutscene_decCBB4		; $7375
	ret nz			; $7378
	ld (hl),$3c		; $7379
	call getFreeInteractionSlot		; $737b
	jr nz,+			; $737e
	ld (hl),INTERACID_TIMEWARP		; $7380
	inc l			; $7382
	ld (hl),$02		; $7383
	ld de,w1Link.yh		; $7385
	call objectCopyPosition_rawAddress		; $7388
+
	ld de,w1Link.yh		; $738b
	call getShortPositionFromDE		; $738e
	ld (wTmpcbb9),a		; $7391
	ld de,$d000		; $7394
	call objectDelete_de		; $7397
	jp _timewarpCutscene_incCBB3		; $739a
@@cbb3_03:
	call _timewarpCutscene_decCBB4		; $739d
	ret nz			; $73a0
	call fastFadeinFromBlack		; $73a1
	jp _timewarpCutscene_incCBB3		; $73a4
@@cbb3_04:
	ld a,(wPaletteThread_mode)		; $73a7
	or a			; $73aa
	ret nz			; $73ab
	call fadeoutToWhite		; $73ac
	jp _timewarpCutscene_incState		; $73af

@state3:
	ld a,(wcddf)		; $73b2
	or a			; $73b5
	jr nz,+			; $73b6
	callab func_04_6e9b		; $73b8
+
	ld a,(wActiveRoom)		; $73c0
	ld b,a			; $73c3
	ld a,(wActiveGroup)		; $73c4
	xor $01			; $73c7
	call getRoomFlags		; $73c9
	ld (wLinkStateParameter),a		; $73cc
	ld hl,wWarpDestGroup		; $73cf
	ld a,(wActiveGroup)		; $73d2
	xor $01			; $73d5
	or $80			; $73d7
	ldi (hl),a		; $73d9
	ld a,(wActiveRoom)		; $73da
	ldi (hl),a		; $73dd
	ld a,$06		; $73de
	ldi (hl),a		; $73e0
	ld a,(wActiveTilePos)		; $73e1
	ld (hl),a		; $73e4
	callab bank1.checkSolidObjectAtWarpDestPos		; $73e5
	srl c			; $73ed
	jr nc,+			; $73ef
	ld a,(wTmpcbb9)		; $73f1
	ld (wWarpDestPos),a		; $73f4
+
	ld a,CUTSCENE_03		; $73f7
	ld (wCutsceneIndex),a		; $73f9
	ld a,$ff		; $73fc
	ld (wActiveMusic),a		; $73fe
	ld a,(wActiveRoom)		; $7401
	ld hl,@sentBackByStrangeForceTable		; $7404
	call checkFlag		; $7407
	ret z			; $740a
	ld a,$01		; $740b
	ld (wSentBackByStrangeForce),a		; $740d
	ret			; $7410

@sentBackByStrangeForceTable:
	dwbe %0000000000000000
	dwbe %0000000000000000
	dwbe %0000000000000000
	dwbe %0000000000000000
	dwbe %0000000000000000
	dwbe %0000000000111000
	dwbe %0000000000111000
	dwbe %0110000000111000
	dwbe %0110000000010000
	dwbe %0000000000000000
	dwbe %0000000000000000
	dwbe %0000000000000000
	dwbe %0000000000000000
	dwbe %0000000000000000
	dwbe %0000000000000000
	dwbe %0000000000000000

_func_7431:
	push hl			; $7431
	ld a,($cbb8)		; $7432
	and $07			; $7435
	ld hl,_table_7440		; $7437
	rst_addDoubleIndex			; $743a
	ldi a,(hl)		; $743b
	ld e,(hl)		; $743c
	ld d,a			; $743d
	pop hl			; $743e
	ret			; $743f

_table_7440:
	.db $dd $ff
	.db $dd $bb
	.db $55 $bb
	.db $55 $aa
	.db $11 $aa
	.db $11 $88
	.db $00 $88
	.db $00 $00

_func_7450:
	ld b,$2f		; $7450
	ld c,$06		; $7452
	jr ++			; $7454

_func_7456:
	ld b,$3f		; $7456
	ld c,$06		; $7458
	jr ++			; $745a

_func_745c:
	ld b,$3f		; $745c
	ld c,$05		; $745e
++
	push bc			; $7460
	push hl			; $7461
	ld a,c			; $7462
	ld ($ff00+R_SVBK),a	; $7463
	ld b,$00		; $7465
--
	ld a,(hl)		; $7467
	and d			; $7468
	ldi (hl),a		; $7469
	ld a,(hl)		; $746a
	and d			; $746b
	ldi (hl),a		; $746c
	ld a,(hl)		; $746d
	and e			; $746e
	ldi (hl),a		; $746f
	ld a,(hl)		; $7470
	and e			; $7471
	ldi (hl),a		; $7472
	dec b			; $7473
	jr nz,--		; $7474
	pop hl			; $7476
	pop bc			; $7477
	ld a,c			; $7478
	sub $05			; $7479
	ld e,a			; $747b
	ld a,h			; $747c
	and $8f			; $747d
	ld d,a			; $747f
	jp queueDmaTransfer		; $7480


_ambiPassageOpen_decCBB4:
	ld hl,wTmpcbb4		; $7483
	dec (hl)		; $7486
	ret nz			; $7487
	ret			; $7488
	
_ambiPassageOpen_incState:
	ld hl,wCutsceneState		; $7489
	inc (hl)		; $748c
	ret			; $748d
	
_ambiPassageOpen_incCBB3:
	ld hl,wTmpcbb3		; $748e
	inc (hl)		; $7491
	ret			; $7492

;;
; CUTSCENE_AMBI_PASSAGE_OPEN
; @addr{7493}
func_03_7493:
	ld a,(wCutsceneState)		; $7493
	rst_jumpTable			; $7496
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,(wPaletteThread_mode)		; $749d
	or a			; $74a0
	ret nz			; $74a1
	ld b,$08		; $74a2
	ld hl,wTmpcbb3		; $74a4
	call clearMemory		; $74a7
	ld a,$3c		; $74aa
	ld (wTmpcbb4),a		; $74ac
	call _ambiPassageOpen_incState		; $74af
	call disableLcd		; $74b2
	call clearOam		; $74b5
	call clearScreenVariablesAndWramBank1		; $74b8
	callab bank1.clearMemoryOnScreenReload		; $74bb
	call stopTextThread		; $74c3
	xor a			; $74c6
	ld bc, ROOM_AGES_127		; $74c7
	call func_36f6		; $74ca
	call loadRoomCollisions		; $74cd
	call func_131f		; $74d0
	call loadCommonGraphics		; $74d3
	call fadeinFromWhite		; $74d6
	ld a,$02		; $74d9
	jp loadGfxRegisterStateIndex		; $74db
@state1:
	ld a,(wTmpcbb3)		; $74de
	rst_jumpTable			; $74e1
	.dw @cbb3_00
	.dw @cbb3_01
@cbb3_00:
	ld a,(wPaletteThread_mode)		; $74e6
	or a			; $74e9
	ret nz			; $74ea
	call _ambiPassageOpen_decCBB4		; $74eb
	ret nz			; $74ee
	ld (hl),$3e		; $74ef
	ld a,(wTmpcbbd)		; $74f1
	ld hl,@table_7513		; $74f4
	rst_addDoubleIndex			; $74f7
	ldi a,(hl)		; $74f8
	ld b,(hl)		; $74f9
	ld c,a			; $74fa
	call getFreeInteractionSlot		; $74fb
	ret nz			; $74fe
	ld (hl),INTERACID_PUSHBLOCK		; $74ff
	ld l,$49		; $7501
	ld (hl),b		; $7503
	ld l,$4b		; $7504
	call setShortPosition_paramC		; $7506
	ld l,$4b		; $7509
	dec (hl)		; $750b
	dec (hl)		; $750c
	ld l,$70		; $750d
	ld (hl),c		; $750f
	jp _ambiPassageOpen_incCBB3		; $7510

@table_7513:
	.db $33 $10
	.db $34 $00
	.db $35 $10
	.db $36 $00
@cbb3_01:
	call _ambiPassageOpen_decCBB4		; $751b
	ret nz			; $751e
	ld (hl),$1e		; $751f
	ld a,SND_SOLVEPUZZLE		; $7521
	call playSound		; $7523
	jp _ambiPassageOpen_incState		; $7526
@state2:
	call _ambiPassageOpen_decCBB4		; $7529
	ret nz			; $752c
	call getThisRoomFlags		; $752d
	ld a,(wTmpcbbb)		; $7530
	ld (wWarpDestRoom),a		; $7533
	ld l,a			; $7536
	set 7,(hl)		; $7537
	ld a,$81		; $7539
	ld (wWarpDestGroup),a		; $753b
	ld a,(wTmpcbbc)		; $753e
	ld (wWarpDestPos),a		; $7541
	ld a,$00		; $7544
	ld (wWarpTransition),a		; $7546
	ld a,CUTSCENE_03		; $7549
	ld (wCutsceneIndex),a		; $754b
	xor a			; $754e
	ld (wMenuDisabled),a		; $754f
	jp fadeoutToWhite		; $7552
	
_jabuOpen_decCBB4:
	ld hl,wTmpcbb4		; $7555
	dec (hl)		; $7558
	ret nz			; $7559
	ret			; $755a
	
_jabuOpen_incState:
	ld hl,wCutsceneState		; $755b
	inc (hl)		; $755e
	ret			; $755f
	
_jabuOpen_incCBB3:
	ld hl,wTmpcbb3		; $7560
	inc (hl)		; $7563
	ret			; $7564

;;
; CUTSCENE_JABU_OPEN
func_03_7565:
	ld a,(wCutsceneState)		; $7565
	rst_jumpTable			; $7568
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld b,$10		; $756f
	ld hl,wTmpcbb3		; $7571
	call clearMemory		; $7574
	callab bank1.checkDisableUnderwaterWaves		; $7577
	call getThisRoomFlags		; $757f
	set 1,(hl)		; $7582
	ld a,$04		; $7584
	ld (wTmpcbb4),a		; $7586
	xor a			; $7589
	ld (wScrollMode),a		; $758a
	jr _jabuOpen_incState		; $758d
@state1:
	ld a,(wTmpcbb3)		; $758f
	rst_jumpTable			; $7592
	.dw @cbb3_00
	.dw @cbb3_01
	.dw @cbb3_02
	.dw @cbb3_03
@cbb3_00:
	call _jabuOpen_decCBB4		; $759b
	ret nz			; $759e
	ld (hl),$3c		; $759f
	call reloadTileMap		; $75a1
	callab bank1.checkInitUnderwaterWaves		; $75a4
	jr _jabuOpen_incCBB3		; $75ac
@cbb3_01:
	call _jabuOpen_decCBB4		; $75ae
	ret nz			; $75b1
	ld (hl),$3c		; $75b2
	jr _jabuOpen_incCBB3		; $75b4
@cbb3_02:
	ld a,$3c		; $75b6
	call setScreenShakeCounter		; $75b8
	call _jabuOpen_decCBB4		; $75bb
	ret nz			; $75be
	ld (hl),$3c		; $75bf
	call _jabuOpen_incCBB3		; $75c1
	ldbc, INTERACID_97 $01		; $75c4
	call objectCreateInteraction		; $75c7
	ld a,$74		; $75ca
--
	call loadGfxHeader		; $75cc
	call reloadTileMap		; $75cf
	ld a,SND_DOORCLOSE		; $75d2
	jp playSound		; $75d4
@cbb3_03:
	ld a,$3c		; $75d7
	call setScreenShakeCounter		; $75d9
	call _jabuOpen_decCBB4		; $75dc
	ret nz			; $75df
	ld (hl),$3c		; $75e0
	call _jabuOpen_incState		; $75e2
	ld a,$75		; $75e5
	jr --			; $75e7
@state2:
	call _jabuOpen_decCBB4		; $75e9
	ret nz			; $75ec
	ld a,SND_SOLVEPUZZLE		; $75ed
	call playSound		; $75ef
	ld a,CUTSCENE_INGAME		; $75f2
	ld (wCutsceneIndex),a		; $75f4
	ld a,$01		; $75f7
	ld (wScrollMode),a		; $75f9
	xor a			; $75fc
	ld (wDisabledObjects),a		; $75fd
	ld (wMenuDisabled),a		; $7600
	call loadTilesetAndRoomLayout		; $7603
	jp loadRoomCollisions		; $7606
	
	
_cleanSeas_decCBB4:
	ld hl,wTmpcbb4		; $7609
	dec (hl)		; $760c
	ret nz			; $760d
	ret			; $760e
	
_cleanSeas_incState:
	ld hl,wCutsceneState		; $760f
	inc (hl)		; $7612
	ret			; $7613
	
_cleanSeas_incCBB3:
	ld hl,wTmpcbb3		; $7614
	inc (hl)		; $7617
	ret			; $7618

;;
; CUTSCENE_CLEAN_SEAS
; @addr{7619}
func_03_7619:
	ld a,(wCutsceneState)		; $7619
	rst_jumpTable			; $761c
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
@state0:
	ld a,(wPaletteThread_mode)		; $762b
	or a			; $762e
	ret nz			; $762f
	ld b,$10		; $7630
	ld hl,wTmpcbb3		; $7632
	call clearMemory		; $7635
	call clearScreenVariablesAndWramBank1		; $7638
	call refreshObjectGfx		; $763b
	ld a,MUS_FAIRY		; $763e
	call playSound		; $7640
	call _cleanSeas_incState		; $7643
	xor a			; $7646
	ld bc, ROOM_AGES_1a5		; $7647
@func_764a:
	push bc			; $764a
	call disableLcd		; $764b
	ld a,PALH_0f		; $764e
	call loadPaletteHeader		; $7650
	call clearOam		; $7653
	call clearScreenVariablesAndWramBank1		; $7656
	callab bank1.clearMemoryOnScreenReload		; $7659
	call stopTextThread		; $7661
	ld a,$01		; $7664
	ld (wDisabledObjects),a		; $7666
	ld (wMenuDisabled),a		; $7669
	xor a			; $766c
	pop bc			; $766d
	call func_36f6		; $766e
	call func_131f		; $7671
	call loadCommonGraphics		; $7674
	ld a,$02		; $7677
	jp loadGfxRegisterStateIndex		; $7679
@state1:
	ld a,(wTmpcbb3)		; $767c
	rst_jumpTable			; $767f
	.dw @@cbb3_00
	.dw @@cbb3_01
	.dw @@cbb3_02
	.dw @@cbb3_03
@@cbb3_00:
	ld a,(wPaletteThread_mode)		; $7688
	or a			; $768b
	ret nz			; $768c
	ld a,$f0		; $768d
	ld (wTmpcbb4),a		; $768f
	jp _cleanSeas_incCBB3		; $7692
@@cbb3_01:
	ld a,(wFrameCounter)		; $7695
	and $07			; $7698
	jr nz,+			; $769a
	call getFreePartSlot		; $769c
	jr nz,+			; $769f
	ld (hl),PARTID_SPARKLE		; $76a1
	call getRandomNumber		; $76a3
	and $7f			; $76a6
	ld c,a			; $76a8
	ld l,$cb		; $76a9
	call setShortPosition_paramC		; $76ab
+
	ld a,(wFrameCounter)		; $76ae
	and $1f			; $76b1
	ld a,SND_MAGIC_POWDER		; $76b3
	call z,playSound		; $76b5
	call _cleanSeas_decCBB4		; $76b8
	ret nz			; $76bb
	ld (hl),$78		; $76bc
	ld a,$04		; $76be
	call fadeoutToWhiteWithDelay		; $76c0
	ld a,SND_FADEOUT		; $76c3
	call playSound		; $76c5
	jp _cleanSeas_incCBB3		; $76c8
@@cbb3_02:
	ld a,(wPaletteThread_mode)		; $76cb
	or a			; $76ce
	ret nz			; $76cf
	call _func_782a		; $76d0
	call _func_782a		; $76d3
	call _func_782a		; $76d6
	call _func_782a		; $76d9
	ret z			; $76dc
	ld a,$04		; $76dd
	call fadeinFromWhiteWithDelay		; $76df
	ld a,SND_FAIRYCUTSCENE		; $76e2
	call playSound		; $76e4
	jp _cleanSeas_incCBB3		; $76e7
@@cbb3_03:
	ld a,(wPaletteThread_mode)		; $76ea
	or a			; $76ed
	ret nz			; $76ee
	call _cleanSeas_decCBB4		; $76ef
	ret nz			; $76f2
	ld (hl),$3c		; $76f3
	call _cleanSeas_incState		; $76f5
	xor a			; $76f8
	ld (wTmpcbb3),a		; $76f9
	ld bc, ROOM_AGES_1d2		; $76fc
	jp @func_764a		; $76ff
@state2:
	ld a,(wTmpcbb3)		; $7702
	rst_jumpTable			; $7705
	.dw @state1@cbb3_00
	.dw @state1@cbb3_01
	.dw @state1@cbb3_02
	.dw @@cbb3_03
@@cbb3_03:
	ld a,(wPaletteThread_mode)		; $770e
	or a			; $7711
	ret nz			; $7712
	call _cleanSeas_decCBB4		; $7713
	ret nz			; $7716
	ld (hl),$3c		; $7717
	call _cleanSeas_incState		; $7719
	xor a			; $771c
	ld (wTmpcbb3),a		; $771d
	ld bc, ROOM_AGES_3b1		; $7720
	call @func_764a		; $7723
	ld hl,objectData.objectData7e71		; $7726
	jp parseGivenObjectData		; $7729
@state3:
	ld a,(wTmpcbb3)		; $772c
	rst_jumpTable			; $772f
	.dw @state1@cbb3_00
	.dw @state1@cbb3_01
	.dw @state1@cbb3_02
	.dw @@cbb3_03
@@cbb3_03:
	ld a,(wPaletteThread_mode)		; $7738
	or a			; $773b
	ret nz			; $773c
	ld hl,$cfc0		; $773d
	bit 7,(hl)		; $7740
	ret z			; $7742
	res 7,(hl)		; $7743
	call _cleanSeas_incState		; $7745
	xor a			; $7748
	ld (wTmpcbb3),a		; $7749
	ld a,$3c		; $774c
	ld (wTmpcbb4),a		; $774e
	ld bc, ROOM_AGES_3b0		; $7751
	call @func_764a		; $7754
	ld hl,objectData.objectData7e7b		; $7757
	jp parseGivenObjectData		; $775a
@state4:
	ld a,(wTmpcbb3)		; $775d
	rst_jumpTable			; $7760
	.dw @state1@cbb3_00
	.dw @state1@cbb3_01
	.dw @state1@cbb3_02
	.dw @@cbb3_03
@@cbb3_03:
	ld a,(wPaletteThread_mode)		; $7769
	or a			; $776c
	ret nz			; $776d
	ld hl,$cfc0		; $776e
	bit 7,(hl)		; $7771
	ret z			; $7773
	ld a,$3c		; $7774
	ld (wTmpcbb4),a		; $7776
	call _cleanSeas_incState		; $7779
	xor a			; $777c
	ld (wTmpcbb3),a		; $777d
	ld bc, ROOM_AGES_1a3		; $7780
	call @func_764a		; $7783
	ld hl,$d000		; $7786
	ld (hl),$03		; $7789
	ld l,$0b		; $778b
	ld (hl),$38		; $778d
	ld l,$0d		; $778f
	ld (hl),$68		; $7791
	ld l,$08		; $7793
	ld (hl),$02		; $7795
	jp setLinkForceStateToState08		; $7797
@state5:
	ld a,(wTmpcbb3)		; $779a
	ld e,a			; $779d
	or a			; $779e
	jr z,+			; $779f
	ld a,(wFrameCounter)		; $77a1
	and $1f			; $77a4
	jr nz,+			; $77a6
	ld a,(w1Link.direction)		; $77a8
	and $02			; $77ab
	xor $02			; $77ad
	or $01			; $77af
	ld (w1Link.direction),a		; $77b1
+
	ld a,e			; $77b4
	rst_jumpTable			; $77b5
	.dw @state1@cbb3_00
	.dw @state1@cbb3_01
	.dw @state1@cbb3_02
	.dw @@cbb3_03
@@cbb3_03:
	ld a,(wPaletteThread_mode)		; $77be
	or a			; $77c1
	ret nz			; $77c2
	ld hl,$cfc0		; $77c3
	bit 7,(hl)		; $77c6
	ret z			; $77c8
	ld a,$3c		; $77c9
	ld (wTmpcbb4),a		; $77cb
	ld a,SND_SOLVEPUZZLE_2		; $77ce
	call playSound		; $77d0
	jp _cleanSeas_incState		; $77d3
@state6:
	call _cleanSeas_decCBB4		; $77d6
	ret nz			; $77d9
	ld a,$01		; $77da
	ld (wScrollMode),a		; $77dc
	callab bank1.calculateRoomEdge		; $77df
	callab bank1.func_49c9		; $77e7
	callab bank1.setObjectsEnabledTo2		; $77ef
	xor a			; $77f7
	ld (wMenuDisabled),a		; $77f8
	ld (wDisabledObjects),a		; $77fb
	ld a,(wLoadingRoomPack)		; $77fe
	ld (wRoomPack),a		; $7801
	ld a,(wActiveRoom)		; $7804
	ld (wLoadingRoom),a		; $7807
	ld a,MUS_CAVE		; $780a
	ld (wEnteredWarpPosition),a		; $780c
	ld a,(wActiveMusic2)		; $780f
	ld (wActiveMusic),a		; $7812
	call playSound		; $7815
	ld a,CUTSCENE_LOADING_ROOM		; $7818
	ld (wCutsceneIndex),a		; $781a
	ld a,$02		; $781d
	ld (w1Link.direction),a		; $781f
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $7822
	call setGlobalFlag		; $7824
	jp setDeathRespawnPoint		; $7827
	
_func_782a:
	ld a,$eb		; $782a
	call findTileInRoom		; $782c
	ret nz			; $782f
	ld c,l			; $7830
	ld a,(wTilesetFlags)		; $7831
	and $40			; $7834
	ld a,$fc		; $7836
	jr z,+			; $7838
	ld a,$3a		; $783a
+
	call setTile		; $783c
	xor a			; $783f
	ret			; $7840

.include "code/ages/cutscenes/linkedGameCutscenes.s"

_blackTowerEscapeAttempt_incState:
	ld hl,wCutsceneState		; $7c99
	inc (hl)		; $7c9c
	ret			; $7c9d


	ld hl,wTmpcbb3		; $7c9e
	inc (hl)		; $7ca1
	ret			; $7ca2

_blackTowerEscapeAttempt_decCBB4:
	ld hl,wTmpcbb4		; $7ca3
	dec (hl)		; $7ca6
	ret			; $7ca7

_blackTowerEscapeAttempt_loadNewRoom:
	call disableLcd		; $7ca8
	call loadScreenMusicAndSetRoomPack		; $7cab
	call loadTilesetData		; $7cae
	call loadTilesetGraphics		; $7cb1
	jp func_131f		; $7cb4

;;
; CUTSCENE_BLACK_TOWER_ESCAPE_ATTEMPT
; @addr{7cb7}
func_03_7cb7:
	ld a,(wCutsceneState)		; $7cb7
	rst_jumpTable			; $7cba
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
@state0:
	ld a,(wActiveMusic2)		; $7cc9
	ld (wActiveMusic),a		; $7ccc
	call playSound		; $7ccf
	ld hl,wTmpcbb3		; $7cd2
	ld b,$10		; $7cd5
	call clearMemory		; $7cd7
	call clearWramBank1		; $7cda
	call refreshObjectGfx		; $7cdd
	ld a,$01		; $7ce0
	ld (wDisabledObjects),a		; $7ce2
	ld (wMenuDisabled),a		; $7ce5
	ld a,$3c		; $7ce8
	ld (wTmpcbb4),a		; $7cea
	call _blackTowerEscapeAttempt_incState		; $7ced
	ld hl,$d000		; $7cf0
	ld (hl),$03		; $7cf3
	ld l,$0b		; $7cf5
	ld (hl),$58		; $7cf7
	inc l			; $7cf9
	inc l			; $7cfa
	ld (hl),$78		; $7cfb
	ld l,$08		; $7cfd
	ld (hl),$02		; $7cff
	call resetCamera		; $7d01
	ld a,$00		; $7d04
	ld (wScrollMode),a		; $7d06
	ld hl,objectData.objectData7e85		; $7d09
	call parseGivenObjectData		; $7d0c
	ld a,$04		; $7d0f
	jp fadeinFromWhiteWithDelay		; $7d11
@state1:
	ld a,(wTmpcbb5)		; $7d14
	cp $04			; $7d17
	ret nz			; $7d19
	call _blackTowerEscapeAttempt_decCBB4		; $7d1a
	jr z,@func_7d33	; $7d1d
	ld a,(hl)		; $7d1f
	cp $01			; $7d20
	ret nz			; $7d22
	ld a,$0b		; $7d23
	ld (wLinkForceState),a		; $7d25
	ld a,$50		; $7d28
	ld (wLinkStateParameter),a		; $7d2a
	ld a,$10		; $7d2d
	ld ($d009),a		; $7d2f
	ret			; $7d32
@func_7d33:
	ld (hl),$10		; $7d33
	call _blackTowerEscapeAttempt_incState		; $7d35
	ld a,$04		; $7d38
	jp fadeoutToWhiteWithDelay		; $7d3a
@state2:
	ld a,(wPaletteThread_mode)		; $7d3d
	or a			; $7d40
	ret nz			; $7d41
	ld a,SNDCTRL_STOPMUSIC		; $7d42
	call playSound		; $7d44
	call _blackTowerEscapeAttempt_incState		; $7d47
	ld a,$f3		; $7d4a
	ld (wActiveRoom),a		; $7d4c
	call _blackTowerEscapeAttempt_loadNewRoom		; $7d4f
	ld hl,w1Link.yh		; $7d52
	ld (hl),$78		; $7d55
	inc l			; $7d57
	inc l			; $7d58
	ld (hl),$78		; $7d59
	call resetCamera		; $7d5b
	call loadCommonGraphics		; $7d5e
	ld a,$04		; $7d61
	call fadeinFromWhiteWithDelay		; $7d63
	ld a,$02		; $7d66
	jp loadGfxRegisterStateIndex		; $7d68
@state3:
	ld a,$00		; $7d6b
	ld (wScrollMode),a		; $7d6d
	ld a,$f8		; $7d70
	ld (w1Link.yh),a		; $7d72
	ld a,$05		; $7d75
	ld (wTmpcbb5),a		; $7d77
	ld a,(wPaletteThread_mode)		; $7d7a
	or a			; $7d7d
	ret nz			; $7d7e
	call _blackTowerEscapeAttempt_decCBB4		; $7d7f
	ret nz			; $7d82
	ld a,$0b		; $7d83
	ld (wLinkForceState),a		; $7d85
	ld a,$60		; $7d88
	ld (wLinkStateParameter),a		; $7d8a
	ld a,$10		; $7d8d
	ld ($d009),a		; $7d8f
	jp _blackTowerEscapeAttempt_incState		; $7d92
@state4:
	ld a,(wTmpcbb5)		; $7d95
	cp $06			; $7d98
	ret nz			; $7d9a
	call _func_7e40		; $7d9b
	ld a,(wScreenShakeCounterY)		; $7d9e
	dec a			; $7da1
	jr z,@func_7dbc	; $7da2
	and $1f			; $7da4
	ret nz			; $7da6
	ld a,(w1Link.direction)		; $7da7
	ld c,a			; $7daa
	rra			; $7dab
	xor c			; $7dac
	bit 0,a			; $7dad
	ld a,c			; $7daf
	jr z,@func_7db6	; $7db0
	xor $01			; $7db2
	jr ++			; $7db4
@func_7db6:
	xor $02			; $7db6
++
	ld (w1Link.direction),a		; $7db8
	ret			; $7dbb
@func_7dbc:
	call getFreeInteractionSlot		; $7dbc
	ret nz			; $7dbf
	ld (hl),INTERACID_EXCLAMATION_MARK		; $7dc0
	ld l,$46		; $7dc2
	ld a,$1e		; $7dc4
	ld (hl),a		; $7dc6
	ld (wTmpcbb4),a		; $7dc7
	ld a,(w1Link.yh)		; $7dca
	sub $10			; $7dcd
	ld l,$4b		; $7dcf
	ldi (hl),a		; $7dd1
	inc l			; $7dd2
	ld a,(w1Link.xh)		; $7dd3
	ld (hl),a		; $7dd6
	ld a,SND_CLINK		; $7dd7
	call playSound		; $7dd9
	call _blackTowerEscapeAttempt_incState		; $7ddc
@state5:
	call _func_7e40		; $7ddf
	call _blackTowerEscapeAttempt_decCBB4		; $7de2
	ret nz			; $7de5
	ld a,$0b		; $7de6
	ld (wLinkForceState),a		; $7de8
	ld a,$10		; $7deb
	ld (wLinkStateParameter),a		; $7ded
	ld hl,w1Link.direction		; $7df0
	ld a,$02		; $7df3
	ldi (hl),a		; $7df5
	ld (hl),$10		; $7df6
	ld a,$07		; $7df8
	ld (wTmpcbb5),a		; $7dfa
	xor a			; $7dfd
	ld ($cfde),a		; $7dfe
	call getFreeInteractionSlot		; $7e01
	ld (hl),INTERACID_FALLING_ROCK		; $7e04
	ld l,$43		; $7e06
	ld (hl),$01		; $7e08
	call getFreeInteractionSlot		; $7e0a
	ld (hl),INTERACID_VERAN_CUTSCENE_WALLMASTER		; $7e0d
	ld l,$4b		; $7e0f
	ld a,(w1Link.yh)		; $7e11
	add $10			; $7e14
	ldi (hl),a		; $7e16
	ld a,(w1Link.xh)		; $7e17
	inc l			; $7e1a
	ld (hl),a		; $7e1b
	jp _blackTowerEscapeAttempt_incState		; $7e1c
@state6:
	call _func_7e40		; $7e1f
	ld a,(wTmpcbb5)		; $7e22
	cp $08			; $7e25
	ret nz			; $7e27
	ld a,SNDCTRL_STOPMUSIC		; $7e28
	call playSound		; $7e2a
	xor a			; $7e2d
	ld (wActiveMusic),a		; $7e2e
	inc a			; $7e31
	ld (wCutsceneIndex),a		; $7e32
	ld hl,@warpDest		; $7e35
	jp setWarpDestVariables		; $7e38

@warpDest:
	m_HardcodedWarpA ROOM_AGES_5d7, $05, $77, $03

_func_7e40:
	ld a,(wScreenShakeCounterY)		; $7e40
	and $0f			; $7e43
	ld a,SND_RUMBLE		; $7e45
	call z,playSound		; $7e47
	ld a,(wScreenShakeCounterY)		; $7e4a
	or a			; $7e4d
	ld a,$ff		; $7e4e
	jp z,setScreenShakeCounter		; $7e50
	ret			; $7e53
