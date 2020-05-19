;;
; CUTSCENE_BLACK_TOWER_ESCAPE
; @addr{5449}
_endgameCutsceneHandler_09:
	ld de,wGenericCutscene.cbc1		; $5449
	ld a,(de)		; $544c
	rst_jumpTable			; $544d
	.dw _endgameCutsceneHandler_09_stage0
	.dw _endgameCutsceneHandler_09_stage1


_endgameCutsceneHandler_09_stage0:
	call updateStatusBar		; $5452
	call @runStates		; $5455
	jp updateAllObjects		; $5458

@runStates:
	ld de,wGenericCutscene.cbc2		; $545b
	ld a,(de)		; $545e
	rst_jumpTable			; $545f
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
	ld a,(wPaletteThread_mode)		; $548c
	or a			; $548f
	ret nz			; $5490
	call _cutscene_clearCFC0ToCFDF		; $5491
	call incCbc2		; $5494

	; Outside black tower
	ld bc,ROOM_AGES_176		; $5497
	call disableLcdAndLoadRoom		; $549a
	call resetCamera		; $549d

	ld a,SNDCTRL_FAST_FADEOUT		; $54a0
	call playSound		; $54a2
	call clearAllParentItems		; $54a5
	call dropLinkHeldItem		; $54a8

	ld hl,objectData.blackTowerEscape_nayruAndRalph		; $54ab
	call parseGivenObjectData		; $54ae
	ld hl,wGenericCutscene.cbb3		; $54b1
	ld (hl),60		; $54b4

	ld hl,_blackTowerEscapeCutscene_doorBlockReplacement		; $54b6
	call _cutscene_replaceListOfTiles		; $54b9

	call refreshObjectGfx		; $54bc
	ld a,$02		; $54bf
	call loadGfxRegisterStateIndex		; $54c1
	jp fadeinFromWhiteToRoom		; $54c4

@state1:
	call _cutscene_decCBB3IfNotFadingOut		; $54c7
	ret nz			; $54ca
	ld (hl),120		; $54cb
	ld l,<wGenericCutscene.cbb6		; $54cd
	ld (hl),$10		; $54cf
	jp incCbc2		; $54d1

@state2:
	call decCbb3		; $54d4
	jr nz,@updateExplosionSoundsAndScreenShake	; $54d7
	ld (hl),60		; $54d9
	jp incCbc2		; $54db

@updateExplosionSoundsAndScreenShake:
	ld hl,wTmpcbb6		; $54de
	dec (hl)		; $54e1
	ret nz			; $54e2
	ld (hl),$10		; $54e3
	ld a,SND_EXPLOSION		; $54e5
	call playSound		; $54e7
	ld a,$08		; $54ea
	call setScreenShakeCounter		; $54ec
	xor a			; $54ef
	ret			; $54f0

@state3:
	call decCbb3		; $54f1
	ret nz			; $54f4
	ld (hl),30		; $54f5
	ld bc,TX_1d0a		; $54f7
	call showText		; $54fa
	jp incCbc2		; $54fd

@state4:
	call _cutscene_decCBB3IfTextNotActive		; $5500
	ret nz			; $5503
	ld (hl),120		; $5504
	ld l,<wGenericCutscene.cbb6		; $5506
	ld (hl),$10		; $5508
	jp incCbc2		; $550a

@state5:
	call decCbb3		; $550d
	jr nz,@explosions	; $5510

	ld (hl),40		; $5512
	call incCbc2		; $5514

	ld hl,w1Link.enabled		; $5517
	ld (hl),$03		; $551a
	ld l,<w1Link.yh		; $551c
	ld (hl),$48		; $551e
	ld l,<w1Link.xh		; $5520
	ld (hl),$50		; $5522
	ld l,<w1Link.direction		; $5524
	ld (hl),DIR_DOWN		; $5526

	ld hl,interactionBank10.blackTowerEscape_simulatedInput1		; $5528
	ld a,:interactionBank10.blackTowerEscape_simulatedInput1		; $552b
	call setSimulatedInputAddress		; $552d

	ld hl,_blackTowerEscapeCutscene_doorOpenReplacement		; $5530
	jp _cutscene_replaceListOfTiles		; $5533

@explosions:
	call @updateExplosionSoundsAndScreenShake		; $5536
	ret nz			; $5539
	call getFreeInteractionSlot		; $553a
	ret nz			; $553d
	ld (hl),INTERACID_EXPLOSION_WITH_DEBRIS		; $553e
	inc l			; $5540
	inc l			; $5541
	inc (hl) ; [var03] = $01
	ld a,$01		; $5543
	ld (wTmpcfc0.genericCutscene.cfd0),a		; $5545
	ret			; $5548

@state6:
	call decCbb3		; $5549
	jr nz,@explosions	; $554c
	jp incCbc2		; $554e

@state7:
	; Wait for signal from an object?
	ld a,(wTmpcfc0.genericCutscene.cfd0)		; $5551
	cp $04			; $5554
	ret nz			; $5556

	call incCbc2		; $5557
	xor a			; $555a
	ld (wDisabledObjects),a		; $555b
	ld (wScrollMode),a		; $555e

	ld hl,interactionBank10.blackTowerEscape_simulatedInput2		; $5561
	ld a,:interactionBank10.blackTowerEscape_simulatedInput2		; $5564
	jp setSimulatedInputAddress		; $5566

@state8:
	ld a,(wTmpcfc0.genericCutscene.cfd0)		; $5569
	cp $05			; $556c
	ret nz			; $556e
	call incCbc2		; $556f
	jp fadeoutToWhite		; $5572

@state9:
	ld a,(wPaletteThread_mode)		; $5575
	or a			; $5578
	ret nz			; $5579

	call incCbc2		; $557a

	ld bc,ROOM_AGES_165		; $557d
	call disableLcdAndLoadRoom		; $5580

	call resetCamera		; $5583
	ld a,MUS_DISASTER		; $5586
	call playSound		; $5588

	ld a,$02		; $558b
	call loadGfxRegisterStateIndex		; $558d

	ld hl,objectData.blackTowerEscape_ambiAndGuards		; $5590
	call parseGivenObjectData		; $5593

	ld hl,wTmpcbb3		; $5596
	ld (hl),30		; $5599
	jp fadeinFromWhiteToRoom		; $559b

@stateA:
	call _cutscene_decCBB3IfNotFadingOut		; $559e
	ret nz			; $55a1

	call incCbc2		; $55a2

	ld hl,w1Link.enabled		; $55a5
	ld (hl),$03		; $55a8
	ld l,<w1Link.yh		; $55aa
	ld (hl),$88		; $55ac
	ld l,<w1Link.xh		; $55ae
	ld (hl),$50		; $55b0
	ld l,<w1Link.direction		; $55b2
	ld (hl),DIR_UP		; $55b4

	ld hl,interactionBank10.blackTowerEscape_simulatedInput3		; $55b6
	ld a,:interactionBank10.blackTowerEscape_simulatedInput3		; $55b9
	call setSimulatedInputAddress		; $55bb
	xor a			; $55be
	ld (wScrollMode),a		; $55bf
	ret			; $55c2

@stateB:
	ld a,(wTmpcfc0.genericCutscene.cfd0)		; $55c3
	cp $06			; $55c6
	ret nz			; $55c8
	call incCbc2		; $55c9
	ld hl,interactionBank10.blackTowerEscape_simulatedInput4		; $55cc
	ld a,:interactionBank10.blackTowerEscape_simulatedInput4		; $55cf
	jp setSimulatedInputAddress		; $55d1

@stateC:
	ld a,(wTmpcfc0.genericCutscene.cfd0)		; $55d4
	cp $0a			; $55d7
	ret nz			; $55d9
	call incCbc2		; $55da

	; TODO: what is this?
	ld hl,wTmpcfc0.genericCutscene.cfde		; $55dd
	ld (hl),$08		; $55e0
	inc l			; $55e2
	ld (hl),$00		; $55e3

	jp fadeoutToWhite		; $55e5

@stateD:
	ld a,(wPaletteThread_mode)		; $55e8
	or a			; $55eb
	ret nz			; $55ec
	call incCbc2		; $55ed
	call _cutscene_loadRoomObjectSetAndFadein		; $55f0
	xor a			; $55f3
	ld (wTmpcfc0.genericCutscene.cfd1),a		; $55f4
	ld (wTmpcfc0.genericCutscene.cfdf),a		; $55f7
	ld a,$02		; $55fa
	jp loadGfxRegisterStateIndex		; $55fc

@stateE:
	ld a,(wPaletteThread_mode)		; $55ff
	or a			; $5602
	ret nz			; $5603
	ld hl,wTmpcfc0.genericCutscene.cfdf		; $5604
	ld a,(hl)		; $5607
	cp $ff			; $5608
	ret nz			; $560a
	xor a			; $560b

	ldd (hl),a ; wTmpcfc0.genericCutscene.cfdf
	inc (hl) ; wTmpcfc0.genericCutscene.cfde
	ld a,(hl)		; $560e
	cp $0a			; $560f
	ld a,$0d		; $5611
	jr nz,+			; $5613
	ld a,$0f		; $5615
+
	ld hl,wGenericCutscene.cbc2		; $5617
	ld (hl),a		; $561a
	jp fadeoutToWhite		; $561b

@stateF:
	ld a,(wPaletteThread_mode)		; $561e
	or a			; $5621
	ret nz			; $5622

	call incCbc2		; $5623
	call _cutscene_loadRoomObjectSetAndFadein		; $5626

	ld hl,w1Link.enabled		; $5629
	ld (hl),$03		; $562c
	ld l,<w1Link.yh		; $562e
	ld (hl),$48		; $5630
	ld l,<w1Link.xh		; $5632
	ld (hl),$60		; $5634
	ld l,<w1Link.direction		; $5636

	ld (hl),DIR_UP		; $5638
	ld a,$0b		; $563a
	ld (wTmpcfc0.genericCutscene.cfd0),a		; $563c
	ld a,$02		; $563f
	jp loadGfxRegisterStateIndex		; $5641

@state10:
	call checkIsLinkedGame		; $5644
	jr nz,@@linked	; $5647

	ld a,(wTmpcfc0.genericCutscene.cfd0)		; $5649
	cp $10			; $564c
	ret nz			; $564e
	call incCbc2		; $564f
	jp fadeoutToWhite		; $5652

@@linked:
	ld a,(wTmpcfc0.genericCutscene.cfd0)		; $5655
	cp $12			; $5658
	ret nz			; $565a
	ld hl,wGenericCutscene.cbc2		; $565b
	ld (hl),$14		; $565e
	ret			; $5660

@state11:
	ld a,(wPaletteThread_mode)		; $5661
	or a			; $5664
	ret nz			; $5665

	call incCbc2		; $5666
	ld hl,wTmpcbb3		; $5669
	ld (hl),60		; $566c

	ld a,$ff		; $566e
	ld (wTilesetAnimation),a		; $5670
	call disableLcd		; $5673

	ld a,GFXH_2b		; $5676
	call loadGfxHeader		; $5678
	ld a,PALH_9d		; $567b
	call loadPaletteHeader		; $567d

	call _cutscene_clearObjects		; $5680
	call _cutscene_resetOamWithSomething2		; $5683
	ld a,$04		; $5686
	call loadGfxRegisterStateIndex		; $5688
	jp fadeinFromWhite		; $568b

@state12:
	call _cutscene_resetOamWithSomething2		; $568e
	call _cutscene_decCBB3IfNotFadingOut		; $5691
	ret nz			; $5694

	call incCbc2		; $5695
	ld hl,wMenuDisabled		; $5698
	ld (hl),$01		; $569b
	ld hl,wTmpcbb3		; $569d
	ld (hl),60		; $56a0

	ld bc,TX_1312		; $56a2

@showTextDuringTwinrovaCutscene:
	ld a,TEXTBOXFLAG_NOCOLORS	; $56a5
	ld (wTextboxFlags),a		; $56a7
	jp showText		; $56aa

@state13:
	call _cutscene_resetOamWithSomething2		; $56ad
	call _cutscene_decCBB3IfTextNotActive		; $56b0
	ret nz			; $56b3
	call cutscene_clearTmpCBB3		; $56b4
	ld a,$01		; $56b7
	ld (wGenericCutscene.cbc1),a		; $56b9
	jp fadeoutToWhite		; $56bc

@state14:
	ld a,(wTextIsActive)		; $56bf
	rlca			; $56c2
	ret nc			; $56c3
	ld a,(wKeysJustPressed)		; $56c4
	or a			; $56c7
	ret z			; $56c8
	call incCbc2		; $56c9
	ld a,$04		; $56cc
	jp fadeoutToWhiteWithDelay		; $56ce

@state15:
	ld a,(wPaletteThread_mode)		; $56d1
	or a			; $56d4
	ret nz			; $56d5
	xor a			; $56d6
	ld (wTextIsActive),a		; $56d7
	ld a,CUTSCENE_ZELDA_KIDNAPPED		; $56da
	ld (wCutsceneTrigger),a		; $56dc
	ret			; $56df


; Twinrova appears just before credits
_endgameCutsceneHandler_09_stage1:
	call @runStates		; $56e0
	jp updateAllObjects		; $56e3

@runStates:
	ld de,wGenericCutscene.cbc2		; $56e6
	ld a,(de)		; $56e9
	rst_jumpTable			; $56ea
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
	call _cutscene_resetOamWithSomething2		; $56ff
	ld a,(wPaletteThread_mode)		; $5702
	or a			; $5705
	ret nz			; $5706

	call incCbc2		; $5707
	ld hl,wTmpcbb3		; $570a
	ld (hl),60		; $570d

	call disableLcd		; $570f
	call clearOam		; $5712
	ld a,GFXH_2c		; $5715
	call loadGfxHeader		; $5717
	ld a,PALH_9e		; $571a
	call loadPaletteHeader		; $571c
	ld a,$04		; $571f
	call loadGfxRegisterStateIndex		; $5721

	ld a,MUS_DISASTER		; $5724
	call playSound		; $5726
	jp fadeinFromWhite		; $5729

@state1:
	ld a,TEXTBOXFLAG_NOCOLORS	; $572c
	ld (wTextboxFlags),a		; $572e
	ld a,60		; $5731
	ld bc,TX_280b		; $5733
	call _cutscene_decCBB3IfNotFadingOut		; $5736
	ret nz			; $5739
	call incCbc2		; $573a
	ld a,e			; $573d
	ld (wTmpcbb3),a		; $573e
	jp showText		; $5741

@state2:
	call _cutscene_decCBB3IfTextNotActive		; $5744
	ret nz			; $5747
	call incCbc2		; $5748

	ld hl,wTmpcbb5		; $574b
	ld (hl),$d0		; $574e

@loadCertainOamData1:
	ld hl,bank16.oamData_4d05		; $5750
	ld e,:bank16.oamData_4d05		; $5753

@loadOamData:
	ld b,$30		; $5755
	push de			; $5757
	ld de,wTmpcbb5		; $5758
	ld a,(de)		; $575b
	pop de			; $575c
	ld c,a			; $575d
	jp _cutscene_resetOamWithData		; $575e

@state3:
	ld hl,wTmpcbb5		; $5761
	inc (hl)		; $5764
	jr nz,@loadCertainOamData1	; $5765
	call clearOam		; $5767
	ld a,UNCMP_GFXH_0a		; $576a
	call loadUncompressedGfxHeader		; $576c
	ld hl,wTmpcbb3		; $576f
	ld (hl),30		; $5772
	jp incCbc2		; $5774

@state4:
	call decCbb3		; $5777
	ret nz			; $577a
	call incCbc2		; $577b
	ld hl,wTmpcbb5		; $577e
	ld (hl),$d0		; $5781

@loadCertainOamData2:
	ld hl,bank16.oamData_4d9e		; $5783
	ld e,:bank16.oamData_4d9e		; $5786
	jr @loadOamData		; $5788

@state5:
	call @loadCertainOamData2		; $578a
	ld hl,wTmpcbb5		; $578d
	dec (hl)		; $5790
	ld a,(hl)		; $5791
	sub $a0			; $5792
	ret nz			; $5794

	ld (wScreenOffsetY),a ; 0
	ld (wScreenOffsetX),a

	ld a,30		; $579b
	ld (wTmpcbb3),a		; $579d
	ld (wOpenedMenuType),a ; TODO: ???
	jp incCbc2		; $57a3

@state6:
	call @loadCertainOamData2		; $57a6
	call decCbb3		; $57a9
	ret nz			; $57ac
	ld hl,wTmpcbb3		; $57ad
	ld (hl),20		; $57b0
	ld bc,TX_280c		; $57b2
	call _endgameCutsceneHandler_09_stage0@showTextDuringTwinrovaCutscene		; $57b5
	jp incCbc2		; $57b8

@state7:
	call @loadCertainOamData2		; $57bb
	call _cutscene_decCBB3IfTextNotActive		; $57be
	ret nz			; $57c1
	xor a			; $57c2
	ld (wOpenedMenuType),a		; $57c3
	dec a			; $57c6
	ld (wTmpcbba),a		; $57c7
	ld a,SND_LIGHTNING		; $57ca
	call playSound		; $57cc
	jp incCbc2		; $57cf

@state8:
	call @loadCertainOamData2		; $57d2
	ld hl,wTmpcbb3		; $57d5
	ld b,$02		; $57d8
	call flashScreen		; $57da
	ret z			; $57dd

	; Time to load twinrova's face graphics?

	call incCbc2		; $57de
	ld hl,wTmpcbb3		; $57e1
	ld (hl),30		; $57e4

	call disableLcd		; $57e6
	call clearOam		; $57e9
	xor a			; $57ec
	ld ($ff00+R_VBK),a	; $57ed
	ld hl,$8000		; $57ef
	ld bc,$2000		; $57f2
	call clearMemoryBc		; $57f5

	xor a			; $57f8
	ld ($ff00+R_VBK),a	; $57f9
	ld hl,$9c00		; $57fb
	ld bc,$0400		; $57fe
	call clearMemoryBc		; $5801

	ld a,$01		; $5804
	ld ($ff00+R_VBK),a	; $5806
	ld hl,$9c00		; $5808
	ld bc,$0400		; $580b
	call clearMemoryBc		; $580e

	ld a,GFXH_2d		; $5811
	call loadGfxHeader		; $5813
	ld a,PALH_9c		; $5816
	call loadPaletteHeader		; $5818
	ld a,$04		; $581b
	call loadGfxRegisterStateIndex		; $581d
	ld a,SND_LIGHTNING		; $5820
	call playSound		; $5822
	jp clearPaletteFadeVariablesAndRefreshPalettes		; $5825

@state9:
	call decCbb3		; $5828
	ret nz			; $582b
	ld a,CUTSCENE_CREDITS		; $582c
	ld (wCutsceneIndex),a		; $582e
	call cutscene_clearTmpCBB3		; $5831
	ld hl,wRoomLayout		; $5834
	ld bc,$00c0		; $5837
	call clearMemoryBc		; $583a
	ld hl,wRoomCollisions		; $583d
	ld bc,$00c0		; $5840
	call clearMemoryBc		; $5843
	ldh (<hCameraY),a	; $5846
	ldh (<hCameraX),a	; $5848
	ld hl,wTmpcbb3		; $584a
	ld (hl),60		; $584d
	ld a,$03		; $584f
	jp fadeoutToBlackWithDelay		; $5851

;;
; CUTSCENE_FLAME_OF_DESPAIR
; @addr{5854}
_endgameCutsceneHandler_20:
	call @runStates		; $5854
	jp updateAllObjects		; $5857

@runStates:
	ld de,$cbc1		; $585a
	ld a,(de)		; $585d
	rst_jumpTable			; $585e
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
	ld a,$0b		; $588d
	ld ($cfde),a		; $588f
	call _cutscene_loadRoomObjectSetAndFadein		; $5892
	call hideStatusBar		; $5895
	ld a,PALH_ac		; $5898
	call loadPaletteHeader		; $589a
	xor a			; $589d
	ld (wPaletteThread_mode),a		; $589e
	call _clearFadingPalettes		; $58a1
	ld hl,wTmpcbb3		; $58a4
	ld (hl),$1e		; $58a7
	ld a,$13		; $58a9
	call loadGfxRegisterStateIndex		; $58ab
	ld hl,wGfxRegs1.SCY		; $58ae
	ldi a,(hl)		; $58b1
	ldh (<hCameraY),a	; $58b2
	ld a,(hl)		; $58b4
	ldh (<hCameraX),a	; $58b5
	ld a,$00		; $58b7
	ld (wScrollMode),a		; $58b9
	jp incCbc1		; $58bc

@state1:
	call decCbb3		; $58bf
	ret nz			; $58c2
	call incCbc1		; $58c3
	ld hl,wTmpcbb3		; $58c6
	ld (hl),$28		; $58c9
	ld a,TEXTBOXFLAG_ALTPALETTE1		; $58cb
	ld (wTextboxFlags),a		; $58cd
	ld bc,TX_2825		; $58d0
	jp showText		; $58d3

@state2:
	call _cutscene_decCBB3IfTextNotActive		; $58d6
	ret nz			; $58d9
	call incCbc1		; $58da
	ld a,$20		; $58dd
	ld hl,wTmpcbb3		; $58df
	ldi (hl),a		; $58e2
	xor a			; $58e3
	ld (hl),a		; $58e4
	ret			; $58e5

@state3:
	call _cutscene_decCBB3IfNotFadingOut		; $58e6
	ret nz			; $58e9
	ld hl,wTmpcbb3		; $58ea
	ld (hl),$20		; $58ed
	inc hl			; $58ef
	ld a,(hl)		; $58f0
	cp $03			; $58f1
	jr nc,+			; $58f3
	ld b,a			; $58f5
	push hl			; $58f6
	ld a,SND_LIGHTTORCH		; $58f7
	call playSound		; $58f9
	pop hl			; $58fc
	ld a,b			; $58fd
+
	inc (hl)		; $58fe
	ld hl,@table_5932		; $58ff
	rst_addAToHl			; $5902
	ld a,(hl)		; $5903
	or a			; $5904
	ld b,a			; $5905
	jr nz,@func_5920	; $5906
	call fadeinFromBlack		; $5908
	ld a,$01		; $590b
	ld (wDirtyFadeSprPalettes),a		; $590d
	ld (wFadeSprPaletteSources),a		; $5910
	ld hl,wTmpcbb3		; $5913
	ld (hl),$3c		; $5916
	ld a,MUS_ROOM_OF_RITES		; $5918
	call playSound		; $591a
	jp incCbc1		; $591d
;;
; @param	b	values in @table_5932 one at a time
@func_5920:
	call fastFadeinFromBlack		; $5920
	ld a,b			; $5923
	ld (wDirtyFadeSprPalettes),a		; $5924
	ld (wFadeSprPaletteSources),a		; $5927
	xor a			; $592a
	ld (wDirtyFadeBgPalettes),a		; $592b
	ld (wFadeBgPaletteSources),a		; $592e
	ret			; $5931
@table_5932:
	.db $40 $10 $80 $28 $06
	.db $00

@state4:
	ld e,$28		; $5938
	ld bc,TX_2826		; $593a
	call @func_5943		; $593d
	jp _cutscene_decCBB3IfNotFadingOut_incState_setCBB3_showText		; $5940

@func_5943:
	ld a,TEXTBOXFLAG_DONTCHECKPOSITION		; $5943
	ld (wTextboxFlags),a		; $5945
	ld a,$03		; $5948
	ld (wTextboxPosition),a		; $594a
	ret			; $594d

@state5:
	ld e,$28		; $594e
	ld bc,TX_2827		; $5950
@func_5953:
	call _cutscene_decCBB3IfTextNotActive		; $5953
	ret nz			; $5956
	call incCbc1		; $5957
	ld hl,wTmpcbb3		; $595a
	ld (hl),e		; $595d
	call @func_5943		; $595e
	jp showText		; $5961

@state6:
	ld e,$3c		; $5964
	ld bc,TX_2828		; $5966
	jr @func_5953		; $5969

@state7:
	ld e,$b4		; $596b
@func_596d:
	call _cutscene_decCBB3IfTextNotActive		; $596d
	ret nz			; $5970
	call incCbc1		; $5971
	ld hl,wTmpcbb3		; $5974
	ld (hl),e		; $5977
	ret			; $5978

@state8:
	call @func_5995		; $5979
	call _cutscene_rumbleSoundWhenFrameCounterLowerNibbleIs0		; $597c
	call decCbb3		; $597f
	ret nz			; $5982
	ld a,SNDCTRL_STOPSFX		; $5983
	call playSound		; $5985
	ld a,SNDCTRL_MEDIUM_FADEOUT		; $5988
	call playSound		; $598a
	call incCbc1		; $598d
	ld a,$04		; $5990
	jp fadeoutToWhiteWithDelay		; $5992
@func_5995:
	ld hl,wGfxRegs1.SCY		; $5995
	ldh a,(<hCameraY)	; $5998
	ldi (hl),a		; $599a
	ldh a,(<hCameraX)	; $599b
	ldi (hl),a		; $599d
	ld hl,@table_59ab		; $599e
	ld de,wGfxRegs1.SCY		; $59a1
	call @func_59b3		; $59a4
	inc de			; $59a7
	jp @func_59b3		; $59a8
@table_59ab:
	.db $ff $01 $00 $01
	.db $00 $00 $ff $00
@func_59b3:
	push hl			; $59b3
	call getRandomNumber		; $59b4
	and $07			; $59b7
	rst_addAToHl			; $59b9
	ld a,(hl)		; $59ba
	ld b,a			; $59bb
	ld a,(de)		; $59bc
	add b			; $59bd
	ld (de),a		; $59be
	pop hl			; $59bf
	ret			; $59c0

@state9:
	call @func_5995		; $59c1
	ld a,(wPaletteThread_mode)		; $59c4
	or a			; $59c7
	ret nz			; $59c8
	call incCbc1		; $59c9
	ld a,$0c		; $59cc
	ld ($cfde),a		; $59ce
	call _cutscene_loadRoomObjectSetAndFadein		; $59d1
	ld hl,$d000		; $59d4
	ld (hl),$03		; $59d7
	ld l,$0b		; $59d9
	ld (hl),$48		; $59db
	ld l,$0d		; $59dd
	ld (hl),$60		; $59df
	ld l,$08		; $59e1
	ld (hl),$00		; $59e3
	ld a,$81		; $59e5
	ld (wDisabledObjects),a		; $59e7
	ld (wMenuDisabled),a		; $59ea
	call _cutscene_clearCFC0ToCFDF		; $59ed
	call showStatusBar		; $59f0
	ld a,SNDCTRL_STOPSFX		; $59f3
	call playSound		; $59f5
	ld a,SNDCTRL_STOPMUSIC		; $59f8
	call playSound		; $59fa
	ld a,$02		; $59fd
	jp loadGfxRegisterStateIndex		; $59ff

@stateA:
	call updateStatusBar		; $5a02
	ld a,($cfd0)		; $5a05
	cp $01			; $5a08
	ret nz			; $5a0a
	call incCbc1		; $5a0b
	ld c,$40		; $5a0e
	ld a,$29		; $5a10
	call giveTreasure		; $5a12
	ld a,$08		; $5a15
	call setLinkIDOverride		; $5a17
	ld l,$02		; $5a1a
	ld (hl),$0c		; $5a1c
	ld hl,wTmpcbb3		; $5a1e
	ld (hl),$5a		; $5a21
	ld a,MUS_PRECREDITS		; $5a23
	jp playSound		; $5a25

@stateB:
	call updateStatusBar		; $5a28
	call decCbb3		; $5a2b
	ret nz			; $5a2e
	call incCbc1		; $5a2f
	ld hl,wTmpcbb3		; $5a32
	ld (hl),$b4		; $5a35
	ld bc,$4860		; $5a37
	ld a,$ff		; $5a3a
	jp createEnergySwirlGoingOut		; $5a3c

@stateC:
	call updateStatusBar		; $5a3f
	call decCbb3		; $5a42
	ret nz			; $5a45
	call incCbc1		; $5a46
	ld hl,wTmpcbb3		; $5a49
	ld (hl),$3c		; $5a4c
	jp fadeoutToWhite		; $5a4e

@stateD:
	call _cutscene_decCBB3IfNotFadingOut		; $5a51
	ret nz			; $5a54
	call incCbc1		; $5a55
	call disableLcd		; $5a58
	call clearOam		; $5a5b
	call clearScreenVariablesAndWramBank1		; $5a5e
	call refreshObjectGfx		; $5a61
	call hideStatusBar		; $5a64
	ld a,$02		; $5a67
	ld ($ff00+R_SVBK),a	; $5a69
	ld hl,$de90		; $5a6b
	ld b,$08		; $5a6e
	ld a,$ff		; $5a70
	call fillMemory		; $5a72
	xor a			; $5a75
	ld ($ff00+R_SVBK),a	; $5a76
	ld a,$07		; $5a78
	ldh (<hDirtyBgPalettes),a	; $5a7a
	call getFreeInteractionSlot		; $5a7c
	jr nz,+			; $5a7f
	ld (hl),INTERACID_NAYRU		; $5a81
	inc l			; $5a83
	ld (hl),$12		; $5a84
	call getFreeInteractionSlot		; $5a86
	jr nz,+			; $5a89
	ld (hl),INTERACID_DIN		; $5a8b
	inc l			; $5a8d
	ld (hl),$02		; $5a8e
+
	ld a,$02		; $5a90
	ld (wOpenedMenuType),a		; $5a92
	call _func_6e9a		; $5a95
	ld a,$02		; $5a98
	call _func_6ed6		; $5a9a
	ld hl,wTmpcbb3		; $5a9d
	ld (hl),$1e		; $5aa0
	ld a,$04		; $5aa2
	call loadGfxRegisterStateIndex		; $5aa4
	ld a,$10		; $5aa7
	ldh (<hCameraY),a	; $5aa9
	xor a			; $5aab
	ldh (<hCameraX),a	; $5aac
	ld a,$00		; $5aae
	ld (wScrollMode),a		; $5ab0
	ld bc,TX_1d1a		; $5ab3
	jp showText		; $5ab6

@stateE:
	call _cutscene_decCBB3IfTextNotActive		; $5ab9
	ret nz			; $5abc
	call incCbc1		; $5abd
	ld b,$04		; $5ac0
@func_5ac2:
	call fadeinFromWhite		; $5ac2
	ld a,b			; $5ac5
	ld (wDirtyFadeSprPalettes),a		; $5ac6
	ld (wFadeSprPaletteSources),a		; $5ac9
	xor a			; $5acc
	ld (wDirtyFadeBgPalettes),a		; $5acd
	ld (wFadeBgPaletteSources),a		; $5ad0
	ld hl,wTmpcbb3		; $5ad3
	ld (hl),$3c		; $5ad6
	ret			; $5ad8

@stateF:
	ld e,$1e		; $5ad9
	ld bc,TX_1d1b		; $5adb
	jp _cutscene_decCBB3IfNotFadingOut_incState_setCBB3_showText		; $5ade

@state10:
	call _cutscene_decCBB3IfTextNotActive		; $5ae1
	ret nz			; $5ae4
	call incCbc1		; $5ae5
	ld b,$12		; $5ae8
	jp @func_5ac2		; $5aea

@state11:
	ld e,$1e		; $5aed
	ld bc,TX_1d1c		; $5aef
	jp _cutscene_decCBB3IfNotFadingOut_incState_setCBB3_showText		; $5af2

@state12:
	ld e,$3c		; $5af5
	jp @func_596d		; $5af7

@state13:
	call decCbb3		; $5afa
	ret nz			; $5afd
	call incCbc1		; $5afe
	ld hl,wTmpcbb3		; $5b01
	ld (hl),$f0		; $5b04
	ld a,$ff		; $5b06
	ld bc,$4850		; $5b08
	jp createEnergySwirlGoingOut		; $5b0b

@state14:
	call decCbb3		; $5b0e
	ret nz			; $5b11
	ld hl,wTmpcbb3		; $5b12
	ld (hl),$5a		; $5b15
	call fadeoutToWhite		; $5b17
	ld a,$fc		; $5b1a
	ld (wDirtyFadeBgPalettes),a		; $5b1c
	ld (wFadeBgPaletteSources),a		; $5b1f
	jp incCbc1		; $5b22

@state15:
	call _cutscene_decCBB3IfNotFadingOut		; $5b25
	ret nz			; $5b28
	call incCbc1		; $5b29
	call clearDynamicInteractions		; $5b2c
	call clearParts		; $5b2f
	call clearOam		; $5b32
	ld hl,wTmpcbb3		; $5b35
	ld (hl),$3c		; $5b38
	ld bc,TX_1d1d		; $5b3a
	jp showTextNonExitable		; $5b3d

@state16:
	ld a,(wTextIsActive)		; $5b40
	rlca			; $5b43
	ret nc			; $5b44
	call decCbb3		; $5b45
	ret nz			; $5b48
	call showStatusBar		; $5b49
	xor a			; $5b4c
	ld (wOpenedMenuType),a		; $5b4d
	dec a			; $5b50
	ld (wActiveMusic),a		; $5b51
	ld a,SNDCTRL_FAST_FADEOUT		; $5b54
	call playSound		; $5b56
	ld hl,@warpDest		; $5b59
	jp setWarpDestVariables		; $5b5c

@warpDest:
	m_HardcodedWarpA ROOM_AGES_5f4, $0f, $57, $03


;;
; CUTSCENE_ROOM_OF_RITES_COLLAPSE
; @addr{5b64}
_endgameCutsceneHandler_0f:
	ld de,$cbc1		; $5b64
	ld a,(de)		; $5b67
	rst_jumpTable			; $5b68
	.dw @state0
	.dw @state1

@state0:
	call updateStatusBar		; $5b6d
	call @@runSubstates		; $5b70
	jp updateAllObjects		; $5b73

@@runSubstates:
	ld de,$cbc2		; $5b76
	ld a,(de)		; $5b79
	rst_jumpTable			; $5b7a
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
	ld a,$01		; $5b97
	ld (de),a		; $5b99
	ld hl,wActiveRing		; $5b9a
	ld (hl),$ff		; $5b9d
	xor a			; $5b9f
	ldh (<hActiveObjectType),a	; $5ba0
	ld de,$d000		; $5ba2
	ld bc,$f8f0		; $5ba5
	ld a,$28		; $5ba8
	call objectCreateExclamationMark		; $5baa
	ld a,$28		; $5bad
	call objectCreateExclamationMark		; $5baf
	ld l,$4b		; $5bb2
	ld (hl),$30		; $5bb4
	inc l			; $5bb6
	inc l			; $5bb7
	ld (hl),$78		; $5bb8
	ld hl,wTmpcbb3		; $5bba
	ld (hl),$0a		; $5bbd
	ret			; $5bbf
@@substate1:
	call decCbb3		; $5bc0
	ret nz			; $5bc3
	ld hl,wTmpcbb3		; $5bc4
	ld (hl),$1e		; $5bc7
	ld a,SNDCTRL_STOPMUSIC		; $5bc9
	call playSound		; $5bcb
	jp incCbc2		; $5bce
@@substate2:
	call _cutscene_setScreenShakeCounterTo4RumbleAt0		; $5bd1
	call decCbb3		; $5bd4
	ret nz			; $5bd7
	call incCbc2		; $5bd8
	ld hl,wTmpcbb3		; $5bdb
	ld (hl),$96		; $5bde
	jp @@func_5cb0		; $5be0
@@substate3:
	call _cutscene_setScreenShakeCounterTo4RumbleAt0		; $5be3
	call decCbb3		; $5be6
	ret nz			; $5be9
	call incCbc2		; $5bea
	ld a,SNDCTRL_STOPSFX		; $5bed
	call playSound		; $5bef
	ld hl,wTmpcbb3		; $5bf2
	ld (hl),$3c		; $5bf5
	ld bc,TX_3d0e		; $5bf7
	jp showText		; $5bfa
@@substate4:
	call _cutscene_decCBB3IfTextNotActive		; $5bfd
	ret nz			; $5c00
	call incCbc2		; $5c01
	ld a,MUS_DISASTER		; $5c04
	call playSound		; $5c06
	ld hl,wTmpcbb3		; $5c09
	ld (hl),$3c		; $5c0c
	jp @@func_5cb0		; $5c0e
@@substate5:
	call _cutscene_setScreenShakeCounterTo4RumbleAt0		; $5c11
	call decCbb3		; $5c14
	ret nz			; $5c17
	ld hl,wTmpcbb3		; $5c18
	ld (hl),$5a		; $5c1b
	jp incCbc2		; $5c1d
@@substate6:
	call _cutscene_setScreenShakeCounterTo4RumbleAt0		; $5c20
	call decCbb3		; $5c23
	ret nz			; $5c26
	call incCbc2		; $5c27
	ld hl,wTmpcbb3		; $5c2a
	ld (hl),$3c		; $5c2d
	ld a,SNDCTRL_STOPSFX		; $5c2f
	jp playSound		; $5c31
@@substate7:
	call decCbb3		; $5c34
	ret nz			; $5c37
	call incCbc2		; $5c38
	ld hl,wTmpcbb3		; $5c3b
	ld (hl),$3c		; $5c3e
	ld bc,TX_3d0f		; $5c40
	jp showText		; $5c43
@@substate8:
	call _cutscene_decCBB3IfTextNotActive		; $5c46
	ret nz			; $5c49
	call incCbc2		; $5c4a
	ld hl,wTmpcbb3		; $5c4d
	ld (hl),$68		; $5c50
	inc hl			; $5c52
	ld (hl),$01		; $5c53
	jp @@func_5cb7		; $5c55
@@substate9:
	ld hl,wTmpcbb3		; $5c58
	call decHlRef16WithCap		; $5c5b
	ret nz			; $5c5e
	call incCbc2		; $5c5f
	ld hl,wTmpcbb3		; $5c62
	ld (hl),$3c		; $5c65
	ld bc,TX_0563		; $5c67
	jp showText		; $5c6a
@@substateA:
	ld e,$1e		; $5c6d
	jp _cutscene_incCBC2setCBB3whenCBB3is0		; $5c6f
@@substateB:
	call _cutscene_setScreenShakeCounterTo4RumbleAt0		; $5c72
	call decCbb3		; $5c75
	ret nz			; $5c78
	call incCbc2		; $5c79
	call @@func_5cb0		; $5c7c
	ld a,$8c		; $5c7f
	ld (wTmpcbb3),a		; $5c81
	ld a,$ff		; $5c84
	ld bc,$4478		; $5c86
	jp createEnergySwirlGoingOut		; $5c89
@@substateC:
	call _cutscene_setScreenShakeCounterTo4RumbleAt0		; $5c8c
	call decCbb3		; $5c8f
	ret nz			; $5c92
	call incCbc2		; $5c93
	ld hl,wTmpcbb3		; $5c96
	ld (hl),$3c		; $5c99
	jp @@func_5cb0		; $5c9b
@@substateD:
	call _cutscene_setScreenShakeCounterTo4RumbleAt0		; $5c9e
	call decCbb3		; $5ca1
	ret nz			; $5ca4
	call incCbc1		; $5ca5
	inc l			; $5ca8
	xor a			; $5ca9
	ld (hl),a		; $5caa
	ld a,$03		; $5cab
	jp fadeoutToWhiteWithDelay		; $5cad
@@func_5cb0:
	call getFreePartSlot		; $5cb0
	ret nz			; $5cb3
	ld (hl),PARTID_ROOM_OF_RITES_FALLING_BOULDER		; $5cb4
	ret			; $5cb6
@@func_5cb7:
	call getFreeInteractionSlot		; $5cb7
	ret nz			; $5cba
	ld (hl),INTERACID_MAKU_CONFETTI		; $5cbb
	ret			; $5cbd

@state1:
	call updateStatusBar		; $5cbe
	call @@runSubstates		; $5cc1
	jp updateAllObjects		; $5cc4

@@runSubstates:
	ld de,$cbc2		; $5cc7
	ld a,(de)		; $5cca
	rst_jumpTable			; $5ccb
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
	call _cutscene_setScreenShakeCounterTo4RumbleAt0		; $5ce2
	ld a,(wPaletteThread_mode)		; $5ce5
	or a			; $5ce8
	ret nz			; $5ce9
	call incCbc2		; $5cea
	ld a,$11		; $5ced
	ld ($cfde),a		; $5cef
	call _cutscene_loadRoomObjectSetAndFadein		; $5cf2
	ld a,$04		; $5cf5
	ld b,$02		; $5cf7
	call _cutscene_loadAObjectGfxBTimes_andReload		; $5cf9
	ld a,SNDCTRL_STOPSFX		; $5cfc
	call playSound		; $5cfe
	ld a,SNDCTRL_FAST_FADEOUT		; $5d01
	call playSound		; $5d03
	ld hl,wTmpcbb3		; $5d06
	ld (hl),$3c		; $5d09
	ld a,$02		; $5d0b
	jp loadGfxRegisterStateIndex		; $5d0d
@@substate1:
	call _cutscene_decCBB3IfNotFadingOut		; $5d10
	ret nz			; $5d13
	call incCbc2		; $5d14
	ld a,$3c		; $5d17
	ld (wTmpcbb3),a		; $5d19
	ld a,$64		; $5d1c
	ld bc,$4850		; $5d1e
	jp createEnergySwirlGoingIn		; $5d21
@@substate2:
	call decCbb3		; $5d24
	ret nz			; $5d27
	xor a			; $5d28
	ld (wTmpcbb3),a		; $5d29
	dec a			; $5d2c
	ld (wTmpcbba),a		; $5d2d
	jp incCbc2		; $5d30
@@substate3:
	ld hl,wTmpcbb3		; $5d33
	ld b,$01		; $5d36
	call flashScreen		; $5d38
	ret z			; $5d3b
	call incCbc2		; $5d3c
	ld hl,wTmpcbb3		; $5d3f
	ld (hl),$3c		; $5d42
	ld a,$01		; $5d44
	ld ($cfc0),a		; $5d46
	ld a,$03		; $5d49
	jp fadeinFromWhiteWithDelay		; $5d4b
@@substate4:
	call _cutscene_decCBB3IfNotFadingOut		; $5d4e
	ret nz			; $5d51
	call refreshObjectGfx		; $5d52
	ld a,$04		; $5d55
	ld b,$02		; $5d57
	call _cutscene_loadAObjectGfxBTimes		; $5d59
	ld a,MUS_CREDITS_1		; $5d5c
	call playSound		; $5d5e
	ld hl,wTmpcbb3		; $5d61
	ld (hl),$3c		; $5d64
	jp incCbc2		; $5d66
@@substate5:
	call decCbb3		; $5d69
	ret nz			; $5d6c
	call incCbc2		; $5d6d
	ld hl,wTmpcbb3		; $5d70
	ld (hl),$1e		; $5d73
	ret			; $5d75
@@substate6:
	call decCbb3		; $5d76
	ret nz			; $5d79
	call refreshObjectGfx		; $5d7a
	ld a,$04		; $5d7d
	ld b,$02		; $5d7f
	call _cutscene_loadAObjectGfxBTimes		; $5d81
	ld hl,wTmpcbb3		; $5d84
	ld (hl),$3c		; $5d87
	ld hl,$cfc0		; $5d89
	ld (hl),$02		; $5d8c
	jp incCbc2		; $5d8e
@@substate7:
	ld a,($cfc0)		; $5d91
	cp $09			; $5d94
	ret nz			; $5d96
	call incCbc2		; $5d97
	ld a,$03		; $5d9a
	jp fadeoutToWhiteWithDelay		; $5d9c
@@substate8:
	ld a,(wPaletteThread_mode)		; $5d9f
	or a			; $5da2
	ret nz			; $5da3
	call incCbc2		; $5da4
	call disableLcd		; $5da7
	call clearScreenVariablesAndWramBank1		; $5daa
	call hideStatusBar		; $5dad
	ld a,$3c		; $5db0
	call loadGfxHeader		; $5db2
	ld a,PALH_c9		; $5db5
	call loadPaletteHeader		; $5db7
	ld hl,wTmpcbb3		; $5dba
	ld (hl),$f0		; $5dbd
	ld a,$04		; $5dbf
	call loadGfxRegisterStateIndex		; $5dc1
	call _cutscene_resetOamWithSomething1		; $5dc4
	ld a,$03		; $5dc7
	jp fadeinFromWhiteWithDelay		; $5dc9
@@substate9:
	call _cutscene_resetOamWithSomething1		; $5dcc
	call _cutscene_decCBB3IfNotFadingOut		; $5dcf
	ret nz			; $5dd2
	call incCbc2		; $5dd3
	ld hl,wTmpcbb3		; $5dd6
	ld (hl),$10		; $5dd9
	ld a,$03		; $5ddb
	jp fadeoutToBlackWithDelay		; $5ddd
@@substateA:
	call _cutscene_resetOamWithSomething1		; $5de0
	call _cutscene_decCBB3IfNotFadingOut		; $5de3
	ret nz			; $5de6
	ld a,CUTSCENE_CREDITS		; $5de7
	ld (wCutsceneIndex),a		; $5de9
	call cutscene_clearTmpCBB3		; $5dec
	ld hl,wRoomLayout		; $5def
	ld bc,$00c0		; $5df2
	call clearMemoryBc		; $5df5
	ld hl,wRoomCollisions		; $5df8
	ld bc,$00c0		; $5dfb
	call clearMemoryBc		; $5dfe
	xor a			; $5e01
	ldh (<hCameraY),a	; $5e02
	ldh (<hCameraX),a	; $5e04
	ld hl,wTmpcbb3		; $5e06
	ld (hl),$3c		; $5e09
	ld a,SNDCTRL_MEDIUM_FADEOUT		; $5e0b
	jp playSound		; $5e0d

;;
; CUTSCENE_CREDITS
; @addr{5e10}
_endgameCutsceneHandler_0a:
	call @runStates		; $5e10
	jp func_3539		; $5e13

@runStates:
	ld de,$cbc1		; $5e16
	ld a,(de)		; $5e19
	rst_jumpTable			; $5e1a
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld de,$cbc2		; $5e23
	ld a,(de)		; $5e26
	rst_jumpTable			; $5e27
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
@@substate0:
	call _cutscene_decCBB3IfNotFadingOut		; $5e2e
	ret nz			; $5e31
	call func_60e0		; $5e32
	call incCbc2		; $5e35
	call clearOam		; $5e38
	ld hl,wTmpcbb3		; $5e3b
	ld (hl),$b4		; $5e3e
	inc hl			; $5e40
	ld (hl),$00		; $5e41
	ld hl,wGfxRegs1.LCDC		; $5e43
	set 3,(hl)		; $5e46
	ld a,MUS_CREDITS_2		; $5e48
	jp playSound		; $5e4a
@@substate1:
	ld hl,wTmpcbb3		; $5e4d
	call decHlRef16WithCap		; $5e50
	ret nz			; $5e53
	call incCbc2		; $5e54
	ld hl,wTmpcbb3		; $5e57
	ld (hl),$48		; $5e5a
	inc hl			; $5e5c
	ld (hl),$03		; $5e5d
	ld a,PALH_04		; $5e5f
	call loadPaletteHeader		; $5e61
	ld a,$06		; $5e64
	jp fadeinFromBlackWithDelay		; $5e66
@@substate2:
	ld hl,wTmpcbb3		; $5e69
	call decHlRef16WithCap		; $5e6c
	ret nz			; $5e6f
	call incCbc1		; $5e70
	inc l			; $5e73
	ld (hl),a		; $5e74
	ld b,$00		; $5e75
	call checkIsLinkedGame		; $5e77
	jr z,+			; $5e7a
	ld b,$04		; $5e7c
+
	ld hl,$cfde		; $5e7e
	ld (hl),b		; $5e81
	inc l			; $5e82
	ld (hl),$00		; $5e83
	jp fadeoutToWhite		; $5e85

@state1:
	ld de,$cbc2		; $5e88
	ld a,(de)		; $5e8b
	rst_jumpTable			; $5e8c
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
@@substate0:
	xor a			; $5e97
	ldh (<hOamTail),a	; $5e98
	ld a,(wPaletteThread_mode)		; $5e9a
	or a			; $5e9d
	ret nz			; $5e9e
	call disableLcd		; $5e9f
	call incCbc2		; $5ea2
	call clearDynamicInteractions		; $5ea5
	call clearOam		; $5ea8
	ld a,$10		; $5eab
	ldh (<hOamTail),a	; $5ead
	ld a,($cfde)		; $5eaf
	ld c,a			; $5eb2
	call _cutscene_clearCFC0ToCFDF		; $5eb3
	ld a,c			; $5eb6
	ld ($cfde),a		; $5eb7
	cp $04			; $5eba
	jr nc,+			; $5ebc
	ld hl,@@table_5f1c		; $5ebe
	rst_addDoubleIndex			; $5ec1
	ld b,(hl)		; $5ec2
	inc hl			; $5ec3
	ld c,(hl)		; $5ec4
	ld a,$00		; $5ec5
	call func_36f6		; $5ec7
	ld a,($cfde)		; $5eca
	ld hl,@@table_5f24		; $5ecd
	rst_addAToHl			; $5ed0
	ldi a,(hl)		; $5ed1
	call loadUncompressedGfxHeader		; $5ed2
+
	ld a,($cfde)		; $5ed5
	add a			; $5ed8
	add $85			; $5ed9
	call loadGfxHeader		; $5edb
	ld a,PALH_0f		; $5ede
	call loadPaletteHeader		; $5ee0
	ld a,($cfde)		; $5ee3
	ld b,$ff		; $5ee6
	or a			; $5ee8
	jr z,+			; $5ee9
	cp $07			; $5eeb
	jr z,+			; $5eed
	ld b,$01		; $5eef
+
	ld c,a			; $5ef1
	ld a,b			; $5ef2
	ld (wTilesetAnimation),a		; $5ef3
	call loadAnimationData		; $5ef6
	ld a,c			; $5ef9
	ld hl,@@table_5f28		; $5efa
	rst_addAToHl			; $5efd
	ldi a,(hl)		; $5efe
	call loadPaletteHeader		; $5eff
	call reloadObjectGfx		; $5f02
	ld a,$01		; $5f05
	ld (wScrollMode),a		; $5f07
	xor a			; $5f0a
	ldh (<hCameraX),a	; $5f0b
	ld hl,$cfde		; $5f0d
	ld b,(hl)		; $5f10
	call _cutscene_parseObjectData_andLoadObjectGfx		; $5f11
	ld a,$04		; $5f14
	call loadGfxRegisterStateIndex		; $5f16
	jp fadeinFromWhite		; $5f19

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
	ld a,(wPaletteThread_mode)		; $5f30
	or a			; $5f33
	ret nz			; $5f34
	ld a,($cfdf)		; $5f35
	or a			; $5f38
	ret z			; $5f39
	call incCbc2		; $5f3a
	ld a,$ff		; $5f3d
	ld (wTilesetAnimation),a		; $5f3f
	jp fadeoutToWhite		; $5f42
@@substate2:
	ld a,(wPaletteThread_mode)		; $5f45
	or a			; $5f48
	ret nz			; $5f49
	call incCbc2		; $5f4a
	call disableLcd		; $5f4d
	call clearWramBank1		; $5f50
	ld a,($cfde)		; $5f53
	add a			; $5f56
	add $86			; $5f57
	call loadGfxHeader		; $5f59
	ld hl,wTmpcbb3		; $5f5c
	ld (hl),$5a		; $5f5f
	ld a,PALH_a1		; $5f61
	call loadPaletteHeader		; $5f63
	ld a,$04		; $5f66
	call loadGfxRegisterStateIndex		; $5f68
	ld a,($cfde)		; $5f6b
	ld hl,@@table_5f81		; $5f6e
	rst_addAToHl			; $5f71
	ld a,(hl)		; $5f72
	ld (wGfxRegs1.SCX),a		; $5f73
	ld a,$10		; $5f76
	ldh (<hCameraX),a	; $5f78
	xor a			; $5f7a
	ld ($cfdf),a		; $5f7b
	jp fadeinFromWhite		; $5f7e
@@table_5f81:
	.db $00 $d0 $00 $d0
	.db $00 $d0 $00 $d0
@@substate3:
	ld a,(wPaletteThread_mode)		; $5f89
	or a			; $5f8c
	ret nz			; $5f8d
	call decCbb3		; $5f8e
	ret nz			; $5f91
	call incCbc2		; $5f92
	call getFreeInteractionSlot		; $5f95
	ret nz			; $5f98
	ld (hl),INTERACID_CREDITS_TEXT_HORIZONTAL		; $5f99
	inc l			; $5f9b
	ld a,($cfde)		; $5f9c
	ldi (hl),a		; $5f9f
	ld (hl),$00		; $5fa0
	ret			; $5fa2
@@substate4:
	ld a,(wPaletteThread_mode)		; $5fa3
	or a			; $5fa6
	ret nz			; $5fa7
	xor a			; $5fa8
	ldh (<hOamTail),a	; $5fa9
	ld a,($cfdf)		; $5fab
	or a			; $5fae
	ret z			; $5faf
	ld b,$03		; $5fb0
	call checkIsLinkedGame		; $5fb2
	jr z,+			; $5fb5
	ld b,$07		; $5fb7
+
	ld hl,$cfde		; $5fb9
	ld a,(hl)		; $5fbc
	cp b			; $5fbd
	jr nc,@@func_5fc7	; $5fbe
	inc (hl)		; $5fc0
	xor a			; $5fc1
	ld ($cbc2),a		; $5fc2
	jr ++			; $5fc5
@@func_5fc7:
	call cutscene_clearTmpCBB3		; $5fc7
	call _cutscene_clearCFC0ToCFDF		; $5fca
	ld a,$02		; $5fcd
	ld ($cbc1),a		; $5fcf
++
	jp fadeoutToWhite		; $5fd2

@state2:
	jpab interactionBank10.agesFunc_10_70f6

@state3:
	jpab interactionBank10.agesFunc_10_7298

;;
; Called from disableLcdAndLoadRoom in bank 0.
;
; @addr{5fe5}
disableLcdAndLoadRoom_body:
	ld a,b			; $5fe5
	ld (wActiveGroup),a		; $5fe6
	ld a,c			; $5fe9
	ld (wActiveRoom),a		; $5fea
	call disableLcd		; $5fed
	call clearScreenVariablesAndWramBank1		; $5ff0
	ld hl,wLinkInAir		; $5ff3
	ld b,wcce9-wLinkInAir		; $5ff6
	call clearMemory		; $5ff8
	call initializeVramMaps		; $5ffb
	call loadScreenMusicAndSetRoomPack		; $5ffe
	call loadTilesetData		; $6001
	call loadTilesetGraphics		; $6004
	call func_131f		; $6007
	ld a,$01		; $600a
	ld (wScrollMode),a		; $600c
	call loadCommonGraphics		; $600f
	call clearOam		; $6012
	ld a,$10		; $6015
	ldh (<hOamTail),a	; $6017
	ret			; $6019


_cutscene_parseObjectData_andLoadObjectGfx:
	call getEntryFromObjectTable1		; $601a
	call parseGivenObjectData		; $601d
	call refreshObjectGfx		; $6020
	jp _cutsceneFunc_6026		; $6023

_cutsceneFunc_6026:
	ld a,($cfde)		; $6026
	cp $00			; $6029
	jr z,_cutscene_load_04_ObjectGfx2Times_andReload	; $602b
	cp $01			; $602d
	jr z,_cutscene_load_26_ObjectGfx2Times_andReload	; $602f
	cp $02			; $6031
	jr z,_cutscene_load_24_ObjectGfx2Times_andReload	; $6033
	cp $04			; $6035
	jr z,_cutscene_load_26_ObjectGfx2Times_andReload	; $6037
	ret			; $6039

_cutscene_loadAObjectGfxBTimes:
	ld hl,wLoadedObjectGfx		; $603a
_cutscene_loadAintoHL_BTimes:
	ldi (hl),a		; $603d
	inc a			; $603e
	ld (hl),$01		; $603f
	inc l			; $6041
	dec b			; $6042
	jr nz,_cutscene_loadAintoHL_BTimes	; $6043
	ret			; $6045

_cutscene_load_24_ObjectGfx2Times_andReload:
	ld a,$24		; $6046
	ld b,$02		; $6048
	jr _cutscene_loadAObjectGfxBTimes_andReload		; $604a
_cutscene_load_26_ObjectGfx2Times_andReload:
	ld a,$26		; $604c
	ld b,$02		; $604e
	jr _cutscene_loadAObjectGfxBTimes_andReload		; $6050
_cutscene_load_04_ObjectGfx2Times_andReload:
	ld a,$04		; $6052
	ld b,$02		; $6054

_cutscene_loadAObjectGfxBTimes_andReload:
	call _cutscene_loadAObjectGfxBTimes		; $6056
	jp reloadObjectGfx		; $6059

_cutscene_incCBC2setCBB3whenCBB3is0:
	call _cutscene_decCBB3IfTextNotActive		; $605c
	ret nz			; $605f
	call incCbc2		; $6060
	ld hl,wTmpcbb3		; $6063
	ld (hl),e		; $6066
	ret			; $6067

;;
; @addr{6068}
_cutscene_decCBB3IfTextNotActive:
	ld a,(wTextIsActive)		; $6068
	or a			; $606b
	ret nz			; $606c
	jp decCbb3		; $606d

;;
; @addr{6070}
_cutscene_decCBB3IfNotFadingOut:
	ld a,(wPaletteThread_mode)		; $6070
	or a			; $6073
	ret nz			; $6074
	jp decCbb3		; $6075


_cutscene_decCBB3IfNotFadingOut_incState_setCBB3_showText:
	call _cutscene_decCBB3IfNotFadingOut		; $6078
	ret nz			; $607b
	call incCbc1		; $607c
	ld a,e			; $607f
	ld (wTmpcbb3),a		; $6080
	jp showText		; $6083

;;
; @addr{6086}
cutscene_clearTmpCBB3:
	ld hl,wTmpcbb3		; $6086
	ld b,$10		; $6089
	jp clearMemory		; $608b

;;
; @addr{608e}
_cutscene_clearCFC0ToCFDF:
	ld b,$20		; $608e
	ld hl,$cfc0		; $6090
	jp clearMemory		; $6093

_cutscene_setScreenShakeCounterTo4RumbleAt0:
	ld a,$04		; $6096
	call setScreenShakeCounter		; $6098
_cutscene_rumbleSoundWhenFrameCounterLowerNibbleIs0:
	ld a,(wFrameCounter)		; $609b
	and $0f			; $609e
	ld a,SND_RUMBLE2		; $60a0
	jp z,playSound		; $60a2
	ret			; $60a5


;;
; @addr{60a6}
_cutscene_resetOamWithSomething1:
	ld hl,bank16.oamData_4f73		; $60a6
	ld e,:bank16.oamData_4f73		; $60a9
	ld bc,$3038		; $60ab
	jr _cutscene_resetOamWithData			; $60ae

;;
; @addr{60b0}
_cutscene_resetOamWithSomething2:
	ld hl,bank16.oamData_4e37		; $60b0
	ld e,:bank16.oamData_4e37		; $60b3
	ld bc,$3038		; $60b5

;;
; @param	bc	Sprite offset
; @param	hl	OAM data to load
; @addr{60b8}
_cutscene_resetOamWithData:
	xor a			; $60b8
	ldh (<hOamTail),a	; $60b9
	jp addSpritesFromBankToOam_withOffset		; $60bb

;;
; @param	hl	List of tiles (see below for example of format)
; @addr{60be}
_cutscene_replaceListOfTiles:
	ld b,(hl)		; $60be
	inc hl			; $60bf
@loop:
	ld c,(hl)		; $60c0
	inc hl			; $60c1
	ldi a,(hl)		; $60c2
	push bc			; $60c3
	push hl			; $60c4
	call setTile		; $60c5
	pop hl			; $60c8
	pop bc			; $60c9
	dec b			; $60ca
	jr nz,@loop	; $60cb
	ret			; $60cd

_blackTowerEscapeCutscene_doorBlockReplacement:
	.db $04     ; # of entries
	.db $44 $83 ; Position, New Tile Value
	.db $45 $83
	.db $54 $83
	.db $55 $83

_blackTowerEscapeCutscene_doorOpenReplacement:
	.db $04
	.db $44 $df
	.db $45 $ed
	.db $54 $80
	.db $55 $80

;;
; @addr{60e0}
func_60e0:
	ld hl,wLinkHealth		; $60e0
	ld (hl),$04		; $60e3
	ld l,<wInventoryB		; $60e5
	ldi a,(hl)		; $60e7
	ld b,(hl)		; $60e8
	ld hl,wcde3		; $60e9
	ldi (hl),a		; $60ec
	ld (hl),b		; $60ed
	jp disableActiveRing		; $60ee

;;
; @addr{60f1}
func_60f1:
	ld hl,wLinkMaxHealth		; $60f1
	ldd a,(hl)		; $60f4
	ld (hl),a		; $60f5
	ld hl,wcde3		; $60f6
	ldi a,(hl)		; $60f9
	ld b,(hl)		; $60fa
	ld hl,wInventoryB		; $60fb
	ldi (hl),a		; $60fe
	ld (hl),b		; $60ff
	jp enableActiveRing		; $6100
