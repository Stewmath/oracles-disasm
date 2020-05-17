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
	call _cutscene_loadObjectSetAndFadein		; $55f0
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
	call _cutscene_loadObjectSetAndFadein		; $5626

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
	call $585a		; $5854
	jp updateAllObjects		; $5857
	ld de,$cbc1		; $585a
	ld a,(de)		; $585d
	rst_jumpTable			; $585e
.dw $588d
.dw $58bf
.dw $58d6
.dw $58e6
.dw $5938
.dw $594e
.dw $5964
.dw $596b
.dw $5979
.dw $59c1
.dw $5a02
.dw $5a28
.dw $5a3f
.dw $5a51
.dw $5ab9
.dw $5ad9
.dw $5ae1
.dw $5aed
.dw $5af5
.dw $5afa
.dw $5b0e
.dw $5b25
.dw $5b40

	ld a,$0b		; $588d
	ld ($cfde),a		; $588f
	call _cutscene_loadObjectSetAndFadein		; $5892
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
	call decCbb3		; $58bf
_label_03_091:
	ret nz			; $58c2
	call incCbc1		; $58c3
	ld hl,wTmpcbb3		; $58c6
	ld (hl),$28		; $58c9
	ld a,TEXTBOXFLAG_ALTPALETTE1		; $58cb
	ld (wTextboxFlags),a		; $58cd
	ld bc,$2825		; $58d0
	jp showText		; $58d3
	call _cutscene_decCBB3IfTextNotActive		; $58d6
	ret nz			; $58d9
	call incCbc1		; $58da
	ld a,$20		; $58dd
	ld hl,wTmpcbb3		; $58df
	ldi (hl),a		; $58e2
	xor a			; $58e3
	ld (hl),a		; $58e4
	ret			; $58e5
	call _cutscene_decCBB3IfNotFadingOut		; $58e6
	ret nz			; $58e9
	ld hl,wTmpcbb3		; $58ea
	ld (hl),$20		; $58ed
	inc hl			; $58ef
	ld a,(hl)		; $58f0
	cp $03			; $58f1
	jr nc,_label_03_092	; $58f3
	ld b,a			; $58f5
	push hl			; $58f6
	ld a,SND_LIGHTTORCH		; $58f7
	call playSound		; $58f9
	pop hl			; $58fc
	ld a,b			; $58fd
_label_03_092:
	inc (hl)		; $58fe
	ld hl,$5932		; $58ff
	rst_addAToHl			; $5902
	ld a,(hl)		; $5903
	or a			; $5904
	ld b,a			; $5905
	jr nz,_label_03_093	; $5906
	call fadeinFromBlack		; $5908
	ld a,$01		; $590b
	ld (wDirtyFadeSprPalettes),a		; $590d
	ld (wFadeSprPaletteSources),a		; $5910
	ld hl,wTmpcbb3		; $5913
	ld (hl),$3c		; $5916
	ld a,MUS_ROOM_OF_RITES		; $5918
	call playSound		; $591a
	jp incCbc1		; $591d
_label_03_093:
	call fastFadeinFromBlack		; $5920
	ld a,b			; $5923
	ld (wDirtyFadeSprPalettes),a		; $5924
	ld (wFadeSprPaletteSources),a		; $5927
	xor a			; $592a
	ld (wDirtyFadeBgPalettes),a		; $592b
	ld (wFadeBgPaletteSources),a		; $592e
	ret			; $5931
	ld b,b			; $5932
	stop			; $5933
	add b			; $5934
	jr z,_label_03_094	; $5935
	nop			; $5937
	ld e,$28		; $5938
	ld bc,$2826		; $593a
_label_03_094:
	call $5943		; $593d
	jp $6078		; $5940
	ld a,TEXTBOXFLAG_DONTCHECKPOSITION		; $5943
	ld (wTextboxFlags),a		; $5945
	ld a,$03		; $5948
	ld (wTextboxPosition),a		; $594a
	ret			; $594d
	ld e,$28		; $594e
	ld bc,$2827		; $5950
_label_03_095:
	call _cutscene_decCBB3IfTextNotActive		; $5953
	ret nz			; $5956
	call incCbc1		; $5957
	ld hl,wTmpcbb3		; $595a
	ld (hl),e		; $595d
	call $5943		; $595e
	jp showText		; $5961
	ld e,$3c		; $5964
	ld bc,$2828		; $5966
	jr _label_03_095		; $5969
	ld e,$b4		; $596b
	call _cutscene_decCBB3IfTextNotActive		; $596d
	ret nz			; $5970
	call incCbc1		; $5971
	ld hl,wTmpcbb3		; $5974
	ld (hl),e		; $5977
	ret			; $5978
	call $5995		; $5979
	call $609b		; $597c
	call decCbb3		; $597f
	ret nz			; $5982
	ld a,SNDCTRL_STOPSFX		; $5983
	call playSound		; $5985
	ld a,SNDCTRL_MEDIUM_FADEOUT		; $5988
	call playSound		; $598a
	call incCbc1		; $598d
	ld a,$04		; $5990
	jp fadeoutToWhiteWithDelay		; $5992
	ld hl,wGfxRegs1.SCY		; $5995
	ldh a,(<hCameraY)	; $5998
	ldi (hl),a		; $599a
	ldh a,(<hCameraX)	; $599b
	ldi (hl),a		; $599d
	ld hl,$59ab		; $599e
	ld de,wGfxRegs1.SCY		; $59a1
	call $59b3		; $59a4
	inc de			; $59a7
	jp $59b3		; $59a8
	rst $38			; $59ab
	ld bc,$0100		; $59ac
	nop			; $59af
	nop			; $59b0
	rst $38			; $59b1
	nop			; $59b2
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
	call $5995		; $59c1
	ld a,(wPaletteThread_mode)		; $59c4
	or a			; $59c7
	ret nz			; $59c8
	call incCbc1		; $59c9
	ld a,$0c		; $59cc
	ld ($cfde),a		; $59ce
	call _cutscene_loadObjectSetAndFadein		; $59d1
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
	call updateStatusBar		; $5a28
	call decCbb3		; $5a2b
	ret nz			; $5a2e
	call incCbc1		; $5a2f
	ld hl,wTmpcbb3		; $5a32
	ld (hl),$b4		; $5a35
	ld bc,$4860		; $5a37
	ld a,$ff		; $5a3a
	jp createEnergySwirlGoingOut		; $5a3c
	call updateStatusBar		; $5a3f
	call decCbb3		; $5a42
	ret nz			; $5a45
	call incCbc1		; $5a46
	ld hl,wTmpcbb3		; $5a49
	ld (hl),$3c		; $5a4c
	jp fadeoutToWhite		; $5a4e
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
	jr nz,_label_03_096	; $5a7f
	ld (hl),$36		; $5a81
	inc l			; $5a83
	ld (hl),$12		; $5a84
	call getFreeInteractionSlot		; $5a86
	jr nz,_label_03_096	; $5a89
	ld (hl),$aa		; $5a8b
	inc l			; $5a8d
	ld (hl),$02		; $5a8e
_label_03_096:
	ld a,$02		; $5a90
	ld (wOpenedMenuType),a		; $5a92
	call $6e9a		; $5a95
	ld a,$02		; $5a98
	call $6ed6		; $5a9a
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
	ld bc,$1d1a		; $5ab3
	jp showText		; $5ab6
	call _cutscene_decCBB3IfTextNotActive		; $5ab9
	ret nz			; $5abc
	call incCbc1		; $5abd
	ld b,$04		; $5ac0
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
	ld e,$1e		; $5ad9
	ld bc,$1d1b		; $5adb
	jp $6078		; $5ade
	call _cutscene_decCBB3IfTextNotActive		; $5ae1
	ret nz			; $5ae4
	call incCbc1		; $5ae5
	ld b,$12		; $5ae8
	jp $5ac2		; $5aea
	ld e,$1e		; $5aed
	ld bc,$1d1c		; $5aef
	jp $6078		; $5af2
	ld e,$3c		; $5af5
	jp $596d		; $5af7
	call decCbb3		; $5afa
	ret nz			; $5afd
	call incCbc1		; $5afe
	ld hl,wTmpcbb3		; $5b01
	ld (hl),$f0		; $5b04
	ld a,$ff		; $5b06
	ld bc,$4850		; $5b08
	jp createEnergySwirlGoingOut		; $5b0b
	call decCbb3		; $5b0e
	ret nz			; $5b11
	ld hl,wTmpcbb3		; $5b12
	ld (hl),$5a		; $5b15
	call fadeoutToWhite		; $5b17
	ld a,$fc		; $5b1a
	ld (wDirtyFadeBgPalettes),a		; $5b1c
	ld (wFadeBgPaletteSources),a		; $5b1f
	jp incCbc1		; $5b22
	call _cutscene_decCBB3IfNotFadingOut		; $5b25
	ret nz			; $5b28
	call incCbc1		; $5b29
	call clearDynamicInteractions		; $5b2c
	call clearParts		; $5b2f
	call clearOam		; $5b32
	ld hl,wTmpcbb3		; $5b35
	ld (hl),$3c		; $5b38
	ld bc,$1d1d		; $5b3a
	jp showTextNonExitable		; $5b3d
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
.dw $5b6d
.dw $5cbe

	call updateStatusBar		; $5b6d
	call $5b76		; $5b70
	jp updateAllObjects		; $5b73
	ld de,$cbc2		; $5b76
	ld a,(de)		; $5b79
	rst_jumpTable			; $5b7a
.dw $5b97
.dw $5bc0
.dw $5bd1
.dw $5be3
.dw $5bfd
.dw $5c11
.dw $5c20
.dw $5c34
.dw $5c46
.dw $5c58
.dw $5c6d
.dw $5c72
.dw $5c8c
.dw $5c9e

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
	call decCbb3		; $5bc0
	ret nz			; $5bc3
	ld hl,wTmpcbb3		; $5bc4
	ld (hl),$1e		; $5bc7
	ld a,SNDCTRL_STOPMUSIC		; $5bc9
	call playSound		; $5bcb
	jp incCbc2		; $5bce
	call $6096		; $5bd1
	call decCbb3		; $5bd4
	ret nz			; $5bd7
	call incCbc2		; $5bd8
	ld hl,wTmpcbb3		; $5bdb
	ld (hl),$96		; $5bde
	jp $5cb0		; $5be0
	call $6096		; $5be3
	call decCbb3		; $5be6
	ret nz			; $5be9
	call incCbc2		; $5bea
	ld a,SNDCTRL_STOPSFX		; $5bed
	call playSound		; $5bef
	ld hl,wTmpcbb3		; $5bf2
	ld (hl),$3c		; $5bf5
	ld bc,$3d0e		; $5bf7
	jp showText		; $5bfa
	call _cutscene_decCBB3IfTextNotActive		; $5bfd
	ret nz			; $5c00
	call incCbc2		; $5c01
	ld a,MUS_DISASTER		; $5c04
	call playSound		; $5c06
	ld hl,wTmpcbb3		; $5c09
	ld (hl),$3c		; $5c0c
	jp $5cb0		; $5c0e
	call $6096		; $5c11
	call decCbb3		; $5c14
	ret nz			; $5c17
	ld hl,wTmpcbb3		; $5c18
	ld (hl),$5a		; $5c1b
	jp incCbc2		; $5c1d
	call $6096		; $5c20
	call decCbb3		; $5c23
	ret nz			; $5c26
	call incCbc2		; $5c27
	ld hl,wTmpcbb3		; $5c2a
	ld (hl),$3c		; $5c2d
	ld a,SNDCTRL_STOPSFX		; $5c2f
	jp playSound		; $5c31
	call decCbb3		; $5c34
	ret nz			; $5c37
	call incCbc2		; $5c38
	ld hl,wTmpcbb3		; $5c3b
	ld (hl),$3c		; $5c3e
	ld bc,$3d0f		; $5c40
	jp showText		; $5c43
	call _cutscene_decCBB3IfTextNotActive		; $5c46
	ret nz			; $5c49
	call incCbc2		; $5c4a
	ld hl,wTmpcbb3		; $5c4d
	ld (hl),$68		; $5c50
	inc hl			; $5c52
	ld (hl),$01		; $5c53
	jp $5cb7		; $5c55
	ld hl,wTmpcbb3		; $5c58
	call decHlRef16WithCap		; $5c5b
	ret nz			; $5c5e
	call incCbc2		; $5c5f
	ld hl,wTmpcbb3		; $5c62
	ld (hl),$3c		; $5c65
	ld bc,$0563		; $5c67
	jp showText		; $5c6a
	ld e,$1e		; $5c6d
	jp $605c		; $5c6f
	call $6096		; $5c72
	call decCbb3		; $5c75
	ret nz			; $5c78
	call incCbc2		; $5c79
	call $5cb0		; $5c7c
	ld a,$8c		; $5c7f
	ld (wTmpcbb3),a		; $5c81
	ld a,$ff		; $5c84
	ld bc,$4478		; $5c86
	jp createEnergySwirlGoingOut		; $5c89
	call $6096		; $5c8c
	call decCbb3		; $5c8f
	ret nz			; $5c92
	call incCbc2		; $5c93
	ld hl,wTmpcbb3		; $5c96
	ld (hl),$3c		; $5c99
	jp $5cb0		; $5c9b
	call $6096		; $5c9e
	call decCbb3		; $5ca1
	ret nz			; $5ca4
	call incCbc1		; $5ca5
	inc l			; $5ca8
	xor a			; $5ca9
	ld (hl),a		; $5caa
	ld a,$03		; $5cab
	jp fadeoutToWhiteWithDelay		; $5cad
	call getFreePartSlot		; $5cb0
	ret nz			; $5cb3
	ld (hl),$54		; $5cb4
	ret			; $5cb6
	call getFreeInteractionSlot		; $5cb7
	ret nz			; $5cba
	ld (hl),$62		; $5cbb
	ret			; $5cbd
	call updateStatusBar		; $5cbe
	call $5cc7		; $5cc1
	jp updateAllObjects		; $5cc4
	ld de,$cbc2		; $5cc7
	ld a,(de)		; $5cca
	rst_jumpTable			; $5ccb
.dw $5ce2
.dw $5d10
.dw $5d24
.dw $5d33
.dw $5d4e
.dw $5d69
.dw $5d76
.dw $5d91
.dw $5d9f
.dw $5dcc
.dw $5de0

	call $6096		; $5ce2
	ld a,(wPaletteThread_mode)		; $5ce5
	or a			; $5ce8
	ret nz			; $5ce9
	call incCbc2		; $5cea
	ld a,$11		; $5ced
	ld ($cfde),a		; $5cef
	call _cutscene_loadObjectSetAndFadein		; $5cf2
	ld a,$04		; $5cf5
	ld b,$02		; $5cf7
	call $6056		; $5cf9
	ld a,SNDCTRL_STOPSFX		; $5cfc
	call playSound		; $5cfe
	ld a,SNDCTRL_FAST_FADEOUT		; $5d01
	call playSound		; $5d03
	ld hl,wTmpcbb3		; $5d06
	ld (hl),$3c		; $5d09
	ld a,$02		; $5d0b
	jp loadGfxRegisterStateIndex		; $5d0d
	call _cutscene_decCBB3IfNotFadingOut		; $5d10
	ret nz			; $5d13
	call incCbc2		; $5d14
	ld a,$3c		; $5d17
	ld (wTmpcbb3),a		; $5d19
	ld a,$64		; $5d1c
	ld bc,$4850		; $5d1e
	jp createEnergySwirlGoingIn		; $5d21
	call decCbb3		; $5d24
	ret nz			; $5d27
	xor a			; $5d28
	ld (wTmpcbb3),a		; $5d29
	dec a			; $5d2c
	ld (wTmpcbba),a		; $5d2d
	jp incCbc2		; $5d30
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
	call _cutscene_decCBB3IfNotFadingOut		; $5d4e
	ret nz			; $5d51
	call refreshObjectGfx		; $5d52
	ld a,$04		; $5d55
	ld b,$02		; $5d57
	call $603a		; $5d59
	ld a,MUS_CREDITS_1		; $5d5c
	call playSound		; $5d5e
	ld hl,wTmpcbb3		; $5d61
	ld (hl),$3c		; $5d64
	jp incCbc2		; $5d66
	call decCbb3		; $5d69
	ret nz			; $5d6c
	call incCbc2		; $5d6d
	ld hl,wTmpcbb3		; $5d70
	ld (hl),$1e		; $5d73
	ret			; $5d75
	call decCbb3		; $5d76
	ret nz			; $5d79
	call refreshObjectGfx		; $5d7a
	ld a,$04		; $5d7d
	ld b,$02		; $5d7f
	call $603a		; $5d81
	ld hl,wTmpcbb3		; $5d84
	ld (hl),$3c		; $5d87
	ld hl,$cfc0		; $5d89
	ld (hl),$02		; $5d8c
	jp incCbc2		; $5d8e
	ld a,($cfc0)		; $5d91
	cp $09			; $5d94
	ret nz			; $5d96
	call incCbc2		; $5d97
	ld a,$03		; $5d9a
	jp fadeoutToWhiteWithDelay		; $5d9c
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
	call _cutscene_resetOamWithSomething1		; $5dcc
	call _cutscene_decCBB3IfNotFadingOut		; $5dcf
	ret nz			; $5dd2
	call incCbc2		; $5dd3
	ld hl,wTmpcbb3		; $5dd6
	ld (hl),$10		; $5dd9
	ld a,$03		; $5ddb
	jp fadeoutToBlackWithDelay		; $5ddd
	call _cutscene_resetOamWithSomething1		; $5de0
	call _cutscene_decCBB3IfNotFadingOut		; $5de3
	ret nz			; $5de6
	ld a,$0a		; $5de7
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
	call $5e16		; $5e10
	jp func_3539		; $5e13
	ld de,$cbc1		; $5e16
	ld a,(de)		; $5e19
	rst_jumpTable			; $5e1a
.dw $5e23
.dw $5e88
.dw $5fd5
.dw $5fdd

	ld de,$cbc2		; $5e23
	ld a,(de)		; $5e26
	rst_jumpTable			; $5e27
.dw $5e2e
.dw $5e4d
.dw $5e69

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
	ld hl,wTmpcbb3		; $5e69
	call decHlRef16WithCap		; $5e6c
	ret nz			; $5e6f
	call incCbc1		; $5e70
	inc l			; $5e73
	ld (hl),a		; $5e74
	ld b,$00		; $5e75
	call checkIsLinkedGame		; $5e77
	jr z,_label_03_097	; $5e7a
	ld b,$04		; $5e7c
_label_03_097:
	ld hl,$cfde		; $5e7e
	ld (hl),b		; $5e81
	inc l			; $5e82
	ld (hl),$00		; $5e83
	jp fadeoutToWhite		; $5e85
	ld de,$cbc2		; $5e88
	ld a,(de)		; $5e8b
	rst_jumpTable			; $5e8c
.dw $5e97
.dw $5f30
.dw $5f45
.dw $5f89
.dw $5fa3

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
	jr nc,_label_03_098	; $5ebc
	ld hl,_table_5f1c		; $5ebe
	rst_addDoubleIndex			; $5ec1
	ld b,(hl)		; $5ec2
	inc hl			; $5ec3
	ld c,(hl)		; $5ec4
	ld a,$00		; $5ec5
	call func_36f6		; $5ec7
	ld a,($cfde)		; $5eca
	ld hl,_table_5f24		; $5ecd
	rst_addAToHl			; $5ed0
	ldi a,(hl)		; $5ed1
	call loadUncompressedGfxHeader		; $5ed2
_label_03_098:
	ld a,($cfde)		; $5ed5
	add a			; $5ed8
	add $85			; $5ed9
	call loadGfxHeader		; $5edb
	ld a,PALH_0f		; $5ede
	call loadPaletteHeader		; $5ee0
	ld a,($cfde)		; $5ee3
	ld b,$ff		; $5ee6
	or a			; $5ee8
	jr z,_label_03_099	; $5ee9
	cp $07			; $5eeb
	jr z,_label_03_099	; $5eed
	ld b,$01		; $5eef
_label_03_099:
	ld c,a			; $5ef1
	ld a,b			; $5ef2
	ld (wTilesetAnimation),a		; $5ef3
	call loadAnimationData		; $5ef6
	ld a,c			; $5ef9
	ld hl,_table_5f28		; $5efa
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
	call $601a		; $5f11
	ld a,$04		; $5f14
	call loadGfxRegisterStateIndex		; $5f16
	jp fadeinFromWhite		; $5f19

_table_5f1c:
	.db $00 $38
	.db $00 $3a
	.db $00 $4a
	.db $01 $16

_table_5f24:
	.db $2d $0f
	.db $2d $0f

_table_5f28:
	.db $30 $2d
	.db $2d $27
	.db $ca $ca
	.db $ca $ae

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
	ld a,(wPaletteThread_mode)		; $5f45
	or a			; $5f48
	ret nz			; $5f49
	call incCbc2		; $5f4a
	call disableLcd		; $5f4d
	call clearWramBank1		; $5f50
	ld a,($cfde)		; $5f53
	add a			; $5f56
_label_03_101:
	add $86			; $5f57
	call loadGfxHeader		; $5f59
	ld hl,wTmpcbb3		; $5f5c
	ld (hl),$5a		; $5f5f
	ld a,PALH_a1		; $5f61
	call loadPaletteHeader		; $5f63
	ld a,$04		; $5f66
	call loadGfxRegisterStateIndex		; $5f68
	ld a,($cfde)		; $5f6b
	ld hl,$5f81		; $5f6e
	rst_addAToHl			; $5f71
	ld a,(hl)		; $5f72
	ld (wGfxRegs1.SCX),a		; $5f73
	ld a,$10		; $5f76
	ldh (<hCameraX),a	; $5f78
	xor a			; $5f7a
	ld ($cfdf),a		; $5f7b
	jp fadeinFromWhite		; $5f7e
	nop			; $5f81
	ret nc			; $5f82
	nop			; $5f83
	ret nc			; $5f84
	nop			; $5f85
	ret nc			; $5f86
	nop			; $5f87
	ret nc			; $5f88
	ld a,(wPaletteThread_mode)		; $5f89
	or a			; $5f8c
	ret nz			; $5f8d
	call decCbb3		; $5f8e
	ret nz			; $5f91
	call incCbc2		; $5f92
	call getFreeInteractionSlot		; $5f95
	ret nz			; $5f98
	ld (hl),$ae		; $5f99
	inc l			; $5f9b
	ld a,($cfde)		; $5f9c
	ldi (hl),a		; $5f9f
	ld (hl),$00		; $5fa0
	ret			; $5fa2
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
	jr z,_label_03_102	; $5fb5
	ld b,$07		; $5fb7
_label_03_102:
	ld hl,$cfde		; $5fb9
	ld a,(hl)		; $5fbc
	cp b			; $5fbd
	jr nc,_label_03_103	; $5fbe
	inc (hl)		; $5fc0
	xor a			; $5fc1
	ld ($cbc2),a		; $5fc2
	jr _label_03_104		; $5fc5
_label_03_103:
	call cutscene_clearTmpCBB3		; $5fc7
	call _cutscene_clearCFC0ToCFDF		; $5fca
	ld a,$02		; $5fcd
	ld ($cbc1),a		; $5fcf
_label_03_104:
	jp fadeoutToWhite		; $5fd2
	jpab interactionBank10.agesFunc_10_70f6
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

	call getEntryFromObjectTable1		; $601a
	call parseGivenObjectData		; $601d
	call refreshObjectGfx		; $6020
	jp $6026		; $6023
	ld a,($cfde)		; $6026
	cp $00			; $6029
	jr z,_label_03_108	; $602b
	cp $01			; $602d
	jr z,_label_03_107	; $602f
	cp $02			; $6031
	jr z,_label_03_106	; $6033
	cp $04			; $6035
	jr z,_label_03_107	; $6037
	ret			; $6039
	ld hl,wLoadedObjectGfx		; $603a
_label_03_105:
	ldi (hl),a		; $603d
	inc a			; $603e
	ld (hl),$01		; $603f
	inc l			; $6041
	dec b			; $6042
	jr nz,_label_03_105	; $6043
	ret			; $6045
_label_03_106:
	ld a,$24		; $6046
	ld b,$02		; $6048
	jr _label_03_109		; $604a
_label_03_107:
	ld a,$26		; $604c
	ld b,$02		; $604e
	jr _label_03_109		; $6050
_label_03_108:
	ld a,$04		; $6052
	ld b,$02		; $6054
_label_03_109:
	call $603a		; $6056
	jp reloadObjectGfx		; $6059
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


	ld a,$04		; $6096
	call setScreenShakeCounter		; $6098
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
	ld hl,$cde3		; $60e9
	ldi (hl),a		; $60ec
	ld (hl),b		; $60ed
	jp disableActiveRing		; $60ee

;;
; @addr{60f1}
func_60f1:
	ld hl,wLinkMaxHealth		; $60f1
	ldd a,(hl)		; $60f4
	ld (hl),a		; $60f5
	ld hl,$cde3		; $60f6
	ldi a,(hl)		; $60f9
	ld b,(hl)		; $60fa
	ld hl,wInventoryB		; $60fb
	ldi (hl),a		; $60fe
	ld (hl),b		; $60ff
	jp enableActiveRing		; $6100

;;
; @addr{6103}
func_03_6103:
	ld a,($cfd1)		; $6103
	cp $07			; $6106
	jp z,$61f2		; $6108
	ld a,(wCutsceneState)		; $610b
	rst_jumpTable			; $610e
.dw $6127
.dw $613c
.dw $6175
.dw $6188
.dw $6196
.dw $619f
.dw $6188
.dw $61a8
.dw $61b1
.dw $6188
.dw $61bb
.dw $61dc

	ld hl,wTmpcbb3		; $6127
	ld a,(w1Link.yh)		; $612a
	ldi (hl),a		; $612d
	ld a,(w1Link.xh)		; $612e
	ldi (hl),a		; $6131
	ld a,(w1Link.direction)		; $6132
	ld (hl),a		; $6135
	call fadeoutToWhite		; $6136
	jp $6270		; $6139
	ld a,(wPaletteThread_mode)		; $613c
	or a			; $613f
	ret nz			; $6140
	ld a,$81		; $6141
_label_03_112:
	ld (wActiveRoom),a		; $6143
	call $6270		; $6146
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
	ld a,(wPaletteThread_mode)		; $6175
	or a			; $6178
	ret nz			; $6179
	ld b,$0c		; $617a
_label_03_113:
	call getFreeInteractionSlot		; $617c
	ret nz			; $617f
	ld (hl),$49		; $6180
	ld l,$43		; $6182
	ld (hl),b		; $6184
	jp $6270		; $6185
	ld hl,$cfd2		; $6188
	ld a,(hl)		; $618b
	or a			; $618c
	ret z			; $618d
	ld (hl),$00		; $618e
	call $6270		; $6190
	jp fadeoutToWhite		; $6193
	ld a,(wPaletteThread_mode)		; $6196
	or a			; $6199
	ret nz			; $619a
	ld a,$80		; $619b
	jr _label_03_112		; $619d
	ld a,(wPaletteThread_mode)		; $619f
	or a			; $61a2
	ret nz			; $61a3
	ld b,$0d		; $61a4
	jr _label_03_113		; $61a6
	ld a,(wPaletteThread_mode)		; $61a8
	or a			; $61ab
	ret nz			; $61ac
	ld a,$91		; $61ad
	jr _label_03_112		; $61af
	ld a,(wPaletteThread_mode)		; $61b1
	or a			; $61b4
	ret nz			; $61b5
	ld b,$0e		; $61b6
	jp $617c		; $61b8
	ld a,(wPaletteThread_mode)		; $61bb
	or a			; $61be
	ret nz			; $61bf
	ld a,$82		; $61c0
	call $6143		; $61c2
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
	ld a,(wPaletteThread_mode)		; $61dc
	or a			; $61df
	ret nz			; $61e0
	xor a			; $61e1
	ld (wDisabledObjects),a		; $61e2
	ld (wMenuDisabled),a		; $61e5
	inc a			; $61e8
	ld (wCutsceneIndex),a		; $61e9
	ld bc,$1104		; $61ec
	jp showText		; $61ef
	ld a,(wCutsceneState)		; $61f2
	rst_jumpTable			; $61f5
.dw $6202
.dw $6210
.dw $6225
.dw $6231
.dw $624c
.dw $625a

	ld a,(wPaletteThread_mode)		; $6202
	or a			; $6205
	ret nz			; $6206
	ld bc,$110a		; $6207
	call showText		; $620a
	jp $6270		; $620d
_label_03_114:
	ld a,(wTextIsActive)		; $6210
	or a			; $6213
	ret nz			; $6214
	call $6270		; $6215
	ld a,$0c		; $6218
	ld (wTmpcbb6),a		; $621a
	ld a,SND_MYSTERY_SEED		; $621d
	call playSound		; $621f
	jp fastFadeinFromWhite		; $6222
	ld a,(wPaletteThread_mode)		; $6225
	or a			; $6228
	ret nz			; $6229
	ld hl,wTmpcbb6		; $622a
	dec (hl)		; $622d
	ret nz			; $622e
	jr _label_03_114		; $622f
	ld a,(wPaletteThread_mode)		; $6231
	or a			; $6234
	ret nz			; $6235
	ld hl,wTmpcbb6		; $6236
	dec (hl)		; $6239
	ret nz			; $623a
	call $6270		; $623b
	xor a			; $623e
	ld ($cfd0),a		; $623f
	ld a,SND_MYSTERY_SEED		; $6242
	call playSound		; $6244
	ld a,$08		; $6247
	jp fadeinFromWhiteWithDelay		; $6249
	ld a,(wPaletteThread_mode)		; $624c
	or a			; $624f
	ret nz			; $6250
	call $6270		; $6251
	ld bc,$110b		; $6254
	jp showText		; $6257
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
	ld hl,wCutsceneState		; $6270
	inc (hl)		; $6273
	ret			; $6274

;;
; @addr{6275}
func_03_6275:
	ld a,(wCutsceneState)		; $6275
	rst_jumpTable			; $6278
.dw $6283
.dw $6288
.dw $62cd
.dw $62d9
.dw $62ec

	call fadeoutToWhite		; $6283
	jr _label_03_115		; $6286
	ld a,(wPaletteThread_mode)		; $6288
	or a			; $628b
	ret nz			; $628c
	call clearAllParentItems		; $628d
	call dropLinkHeldItem		; $6290
	ld a,$01		; $6293
	ld (wActiveGroup),a		; $6295
	ld a,$46		; $6298
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
_label_03_115:
	ld hl,wCutsceneState		; $62c8
	inc (hl)		; $62cb
	ret			; $62cc
	ld a,$03		; $62cd
	ld ($d000),a		; $62cf
	ld a,$0f		; $62d2
	ld (wLinkForceState),a		; $62d4
	jr _label_03_115		; $62d7
	ld a,(wPaletteThread_mode)		; $62d9
	or a			; $62dc
	ret nz			; $62dd
	ld a,($d005)		; $62de
	cp $02			; $62e1
	ret nz			; $62e3
	ld bc,$590a		; $62e4
	call showText		; $62e7
	jr _label_03_115		; $62ea
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
func_03_6306:
	ld a,c			; $6306
	rst_jumpTable			; $6307
.dw $6318
.dw $6564
.dw $65b3
.dw $677c
.dw $6a8e
.dw $6b77
.dw $6d0b
.dw $69b5

	call $6328		; $6318
	ld hl,wCutsceneState		; $631b
	ld a,(hl)		; $631e
	cp $02			; $631f
	ret z			; $6321
	cp $03			; $6322
	ret z			; $6324
	jp updateAllObjects		; $6325
	ld de,wCutsceneState		; $6328
	ld a,(de)		; $632b
	rst_jumpTable			; $632c
.dw $6351
.dw $6359
.dw $63aa
.dw $63ed
.dw $640e
.dw $6420
.dw $6432
.dw $6443
.dw $6454
.dw $6474
.dw $6488
.dw $6496
.dw $64a5
.dw $64b5
.dw $64df
.dw $64fe
.dw $6538
.dw $654f

	ld a,$01		; $6351
	ld (de),a		; $6353
	ld a,SND_CLOSEMENU		; $6354
	jp playSound		; $6356
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
	call $6f8c		; $638f
	ld hl,wTmpcbb5		; $6392
	ld (hl),$02		; $6395
	call clearOam		; $6397
	ld b,$00		; $639a
	ld a,(wGfxRegs1.SCX)		; $639c
	cpl			; $639f
	inc a			; $63a0
	ld c,a			; $63a1
	ld hl,bank3f.oamData_7249		; $63a2
	ld e,:bank3f.oamData_7249		; $63a5
	jp addSpritesFromBankToOam_withOffset		; $63a7
	ld a,(wPaletteThread_mode)		; $63aa
	or a			; $63ad
	jp nz,$6397		; $63ae
	ret nz			; $63b1
	call $63db		; $63b2
	call $6397		; $63b5
	ld hl,wTmpcbb3		; $63b8
	call decHlRef16WithCap		; $63bb
	jr z,_label_03_117	; $63be
	ldi a,(hl)		; $63c0
	ld h,(hl)		; $63c1
	ld l,a			; $63c2
	ld bc,$00f0		; $63c3
	call compareHlToBc		; $63c6
	ret nc			; $63c9
	ld a,(wKeysJustPressed)		; $63ca
	and $01			; $63cd
	ret z			; $63cf
_label_03_117:
	ld a,SND_CLOSEMENU		; $63d0
	call playSound		; $63d2
	call $6f8c		; $63d5
	jp fastFadeoutToWhite		; $63d8
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
	ld a,(wPaletteThread_mode)		; $63ed
	or a			; $63f0
	jp nz,$6397		; $63f1
	ret nz			; $63f4
	xor a			; $63f5
	ld (wTilesetAnimation),a		; $63f6
	ld hl,$d01a		; $63f9
	set 7,(hl)		; $63fc
	ld a,$09		; $63fe
	ld ($cfd0),a		; $6400
	call $6f8c		; $6403
	ld hl,wTmpcbb3		; $6406
	ld (hl),$aa		; $6409
	jp reloadGraphicsOnExitMenu		; $640b
	ld a,($cfd0)		; $640e
	cp $0f			; $6411
	ret nz			; $6413
	call $6f8c		; $6414
	ld hl,$de90		; $6417
.ifdef ROM_AGES
	ld bc,paletteData44a8		; $641a
.else
	ld bc,$44a8
.endif
	jp func_13c6		; $641d
	ld a,(wPaletteThread_mode)		; $6420
	or a			; $6423
	ret nz			; $6424
	ld a,PALH_99		; $6425
	call loadPaletteHeader		; $6427
	ld a,$10		; $642a
	ld ($cfd0),a		; $642c
	jp $6f8c		; $642f
	ld a,($cfd0)		; $6432
	cp $14			; $6435
	ret nz			; $6437
	call $6f8c		; $6438
	ld hl,wTmpcbb3		; $643b
	ld (hl),$3c		; $643e
	jp fadeoutToWhite		; $6440
	call _cutscene_decCBB3IfNotFadingOut		; $6443
	ret nz			; $6446
	call $6f8c		; $6447
	ld a,$15		; $644a
	ld ($cfd0),a		; $644c
	ld a,$03		; $644f
	jp fadeinFromWhiteWithDelay		; $6451
	ld a,($cfd0)		; $6454
	cp $18			; $6457
	ret nz			; $6459
	call $6f8c		; $645a
	xor a			; $645d
	ld ($cfd2),a		; $645e
	call getFreePartSlot		; $6461
	ret nz			; $6464
	ld (hl),$27		; $6465
	inc l			; $6467
	inc (hl)		; $6468
	inc l			; $6469
	inc (hl)		; $646a
	ld l,$cb		; $646b
	ld (hl),$24		; $646d
	ld l,$cd		; $646f
	ld (hl),$28		; $6471
	ret			; $6473
	ld a,($cfd2)		; $6474
	or a			; $6477
	ret z			; $6478
	call $6f8c		; $6479
	call getThisRoomFlags		; $647c
	set 6,(hl)		; $647f
	ld c,$22		; $6481
	ld a,$d7		; $6483
	jp setTile		; $6485
	ld a,($cfd0)		; $6488
	cp $1d			; $648b
	ret nz			; $648d
	ld hl,wTmpcbb3		; $648e
	ld (hl),$78		; $6491
	jp $6f8c		; $6493
	call decCbb3		; $6496
	ret nz			; $6499
	ld (hl),$5a		; $649a
	call $6f8c		; $649c
	ld bc,$5607		; $649f
	jp showText		; $64a2
	call _cutscene_decCBB3IfTextNotActive		; $64a5
	ret nz			; $64a8
	call $6f8c		; $64a9
	xor a			; $64ac
	ld hl,$cfde		; $64ad
	ldi (hl),a		; $64b0
	ld (hl),a		; $64b1
	jp fadeoutToWhite		; $64b2
	ld a,(wPaletteThread_mode)		; $64b5
	or a			; $64b8
	ret nz			; $64b9
	call $6f8c		; $64ba
	call _cutscene_loadObjectSetAndFadein		; $64bd
	ld a,$02		; $64c0
	jp loadGfxRegisterStateIndex		; $64c2

;;
; @addr{64c5}
_cutscene_loadObjectSetAndFadein:
	ld hl,wTmpcfc0.genericCutscene.cfde		; $64c5
	ld a,(hl)		; $64c8
	push af			; $64c9
	call _cutscene_getObjectSetIndexAndSomething		; $64ca
	pop af			; $64cd
	ld b,a			; $64ce
	call getEntryFromObjectTable2		; $64cf
	call parseGivenObjectData		; $64d2
	call refreshObjectGfx		; $64d5
	xor a			; $64d8
	ld (wTmpcfc0.genericCutscene.cfd1),a		; $64d9
	jp fadeinFromWhite		; $64dc

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
	jr nz,_label_03_118	; $64f3
	ld a,$0f		; $64f5
_label_03_118:
	ld hl,wCutsceneState		; $64f7
	ld (hl),a		; $64fa
	jp fadeoutToWhite		; $64fb
	ld a,(wPaletteThread_mode)		; $64fe
	or a			; $6501
	ret nz			; $6502
	call $6f8c		; $6503
	call _cutscene_loadObjectSetAndFadein		; $6506
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
	call $603a		; $652d
	call reloadObjectGfx		; $6530
	ld a,$02		; $6533
	jp loadGfxRegisterStateIndex		; $6535
	ld a,(wPaletteThread_mode)		; $6538
	or a			; $653b
	ret nz			; $653c
	ld a,($cfd0)		; $653d
	cp $1e			; $6540
	ret nz			; $6542
	call $6f8c		; $6543
	ld hl,$de90		; $6546
.ifdef ROM_AGES
	ld bc,paletteData4a30		; $6549
.else
	ld bc,$4a30
.endif
	jp func_13c6		; $654c
	ld a,(wPaletteThread_mode)		; $654f
	or a			; $6552
	ret nz			; $6553
	ld a,PALH_10		; $6554
	call loadPaletteHeader		; $6556
	ld a,$1f		; $6559
	ld ($cfd0),a		; $655b
	ld a,$01		; $655e
	ld (wCutsceneIndex),a		; $6560
	ret			; $6563
	call $656a		; $6564
	jp updateAllObjects		; $6567
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
	ld hl,$65af		; $65a2
	rst_addAToHl			; $65a5
	ld a,(hl)		; $65a6
	jp loadPaletteHeader		; $65a7

@warpDest:
	m_HardcodedWarpA ROOM_AGES_038, $0c, $45, $83

	sbc d			; $65af
	call nz,$c58f		; $65b0
	call $65b9		; $65b3
	jp updateAllObjects		; $65b6
_label_03_120:
	ld a,($cbb8)		; $65b9
	rst_jumpTable			; $65bc
.dw $65c3
.dw $6664
.dw $66f0

	ld de,wCutsceneState		; $65c3
	ld a,(de)		; $65c6
	rst_jumpTable			; $65c7
.dw $65d0
.dw $662b
.dw $6651
.dw $6733

	ld a,(wPaletteThread_mode)		; $65d0
	or a			; $65d3
	ret nz			; $65d4
	call disableLcd		; $65d5
	call clearScreenVariablesAndWramBank1		; $65d8
	call clearOam		; $65db
	ld a,($cbb8)		; $65de
	ld hl,_table_6625		; $65e1
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
	jr z,_label_03_121	; $65fb
	ld b,$3c		; $65fd
_label_03_121:
	ld hl,wTmpcbb3		; $65ff
	ld (hl),b		; $6602
	or a			; $6603
	ld a,MUS_DISASTER		; $6604
	call z,playSound		; $6606
	call $6f8c		; $6609
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

_table_6625:
	.db $82 $2f
	.db $81 $2e
	.db $80 $2e

	call $6ef7		; $662b
	call $6f44		; $662e
	ld a,(wPaletteThread_mode)		; $6631
	or a			; $6634
	ret nz			; $6635
	call decCbb3		; $6636
	ret nz			; $6639
	call $6f8c		; $663a
	ld bc,$1005		; $663d
	ld a,($cbb8)		; $6640
	or a			; $6643
	jr z,_label_03_122	; $6644
	ld bc,$1317		; $6646
_label_03_122:
	ld a,TEXTBOXFLAG_NOCOLORS		; $6649
	ld (wTextboxFlags),a		; $664b
	jp showText		; $664e
	call $6ef7		; $6651
	call $6f44		; $6654
	ld a,(wTextIsActive)		; $6657
	or a			; $665a
	ret nz			; $665b
	ld hl,wTmpcbb3		; $665c
	ld (hl),$3c		; $665f
	jp $6f8c		; $6661
	ld de,wCutsceneState		; $6664
	ld a,(de)		; $6667
	rst_jumpTable			; $6668
.dw $65d0
.dw $662b
.dw $6651
.dw $66fd
.dw $6725
.dw $6679
.dw $6689
.dw $66dc

	call $6ef7		; $6679
	call $6f44		; $667c
	call decCbb3		; $667f
	ret nz			; $6682
	call $6f8c		; $6683
	jp fadeoutToWhite		; $6686
	call $6f44		; $6689
	ld a,(wPaletteThread_mode)		; $668c
	or a			; $668f
	ret nz			; $6690
	call $6f8c		; $6691
	call clearDynamicInteractions		; $6694
	ld bc,$00ba		; $6697
	call disableLcdAndLoadRoom		; $669a
	call resetCamera		; $669d
	call getFreeInteractionSlot		; $66a0
	jr nz,_label_03_123	; $66a3
	ld (hl),$8a		; $66a5
	inc l			; $66a7
	ld (hl),$00		; $66a8
	inc l			; $66aa
	ld (hl),$04		; $66ab
_label_03_123:
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
	call updateStatusBar		; $66dc
	ld a,(wPaletteThread_mode)		; $66df
	or a			; $66e2
	ret nz			; $66e3
	ld a,$01		; $66e4
	ld (wMenuDisabled),a		; $66e6
	ld (wDisabledObjects),a		; $66e9
	ld (wCutsceneIndex),a		; $66ec
	ret			; $66ef
	ld de,wCutsceneState		; $66f0
	ld a,(de)		; $66f3
	rst_jumpTable			; $66f4
.dw $65d0
.dw $66fd
.dw $6725
.dw $6733

	call $6ef7		; $66fd
	call $6f44		; $6700
	ld a,(wPaletteThread_mode)		; $6703
	or a			; $6706
	ret nz			; $6707
	call decCbb3		; $6708
	ret nz			; $670b
	ld a,$04		; $670c
	ld (wTmpcbbb),a		; $670e
	ld (wTmpcbb6),a		; $6711
	ld a,($cbb8)		; $6714
	ld hl,$6722		; $6717
	rst_addAToHl			; $671a
	ld a,(hl)		; $671b
	ld (wTmpcbb3),a		; $671c
	jp $6f8c		; $671f
	ld bc,$b161		; $6722
	call $6ef7		; $6725
	call $6f26		; $6728
	jp nz,$6f44		; $672b
	ld (hl),$78		; $672e
	call $6f8c		; $6730
	call $6ef7		; $6733
	call $6f44		; $6736
	call decCbb3		; $6739
	ret nz			; $673c
	ld a,($cbb8)		; $673d
	rst_jumpTable			; $6740
.dw $6747
.dw $6747
.dw $6768

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
	xor a			; $6768
	ld (wLinkStateParameter),a		; $6769
	ld hl,@warpDest2		; $676c
	jp setWarpDestVariables		; $676f

@warpDest1:
	m_HardcodedWarpA ROOM_AGES_186, $0c, $75, $03

@warpDest2:
	m_HardcodedWarpA ROOM_AGES_4f6, $0f, $47, $03

	call $6785		; $677c
	call updateStatusBar		; $677f
	jp updateAllObjects		; $6782
	ld de,wCutsceneState		; $6785
	ld a,(de)		; $6788
	rst_jumpTable			; $6789
.dw $67a4
.dw $67fc
.dw $680d
.dw $681a
.dw $684e
.dw $6855
.dw $686f
.dw $687f
.dw $68a3
.dw $68e8
.dw $6903
.dw $691a
.dw $696b

	ld a,(wPaletteThread_mode)		; $67a4
	or a			; $67a7
	ret nz			; $67a8
	call $6f8c		; $67a9
	call clearDynamicInteractions		; $67ac
	ld bc,$0038		; $67af
	call disableLcdAndLoadRoom		; $67b2
	call resetCamera		; $67b5
	ld b,$04		; $67b8
	call getEntryFromObjectTable2		; $67ba
	call parseGivenObjectData		; $67bd
	call refreshObjectGfx		; $67c0
	ld a,$04		; $67c3
	ld b,$02		; $67c5
	call $603a		; $67c7
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
	call $6f96		; $67fc
	ret nz			; $67ff
	ld (hl),$3c		; $6800
	call $6f8c		; $6802
	ld a,$68		; $6805
	ld bc,$5050		; $6807
	jp createEnergySwirlGoingIn		; $680a
	call decCbb3		; $680d
	ret nz			; $6810
	xor a			; $6811
	ld (hl),a		; $6812
	dec a			; $6813
	ld (wTmpcbba),a		; $6814
	jp $6f8c		; $6817
	ld hl,wTmpcbb3		; $681a
	ld b,$02		; $681d
	call flashScreen		; $681f
	ret z			; $6822
	call $6f8c		; $6823
	ld hl,wTmpcbb3		; $6826
	ld (hl),$3c		; $6829
	ld a,$01		; $682b
	ld ($cfd0),a		; $682d
	call $6838		; $6830
	ld a,$03		; $6833
	jp fadeinFromWhiteWithDelay		; $6835
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
	call $6f96		; $684e
	ret nz			; $6851
	jp $6f8c		; $6852
	ld a,($cfd0)		; $6855
	cp $02			; $6858
	ret nz			; $685a
	call $6f8c		; $685b
	ld a,SNDCTRL_FAST_FADEOUT		; $685e
	call playSound		; $6860
	xor a			; $6863
	ld hl,$cfde		; $6864
	ld (hl),$05		; $6867
	inc l			; $6869
	ld (hl),$00		; $686a
	jp fadeoutToWhite		; $686c
	ld a,(wPaletteThread_mode)		; $686f
	or a			; $6872
	ret nz			; $6873
	call $6f8c		; $6874
	call _cutscene_loadObjectSetAndFadein		; $6877
	ld a,$02		; $687a
	jp loadGfxRegisterStateIndex		; $687c
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
	jr nz,_label_03_124	; $6893
	ld a,$08		; $6895
	ld hl,$cfd0		; $6897
	ld (hl),$03		; $689a
_label_03_124:
	ld hl,wCutsceneState		; $689c
	ld (hl),a		; $689f
	jp fadeoutToWhite		; $68a0
	ld a,(wPaletteThread_mode)		; $68a3
	or a			; $68a6
	ret nz			; $68a7
	call $6f8c		; $68a8
	call _cutscene_loadObjectSetAndFadein		; $68ab
	call $6838		; $68ae
	ld a,$01		; $68b1
	ld (wDisabledObjects),a		; $68b3
	ld (wMenuDisabled),a		; $68b6
	ld a,$04		; $68b9
	ld b,$02		; $68bb
	call $603a		; $68bd
	ld a,$26		; $68c0
	ld b,$02		; $68c2
	call $603d		; $68c4
	ld a,$24		; $68c7
	ld b,$01		; $68c9
	call $603d		; $68cb
	ld b,l			; $68ce
	call checkIsLinkedGame		; $68cf
	jr z,_label_03_125	; $68d2
	call getFreeInteractionSlot		; $68d4
	jr nz,_label_03_125	; $68d7
	ld (hl),$93		; $68d9
_label_03_125:
	call reloadObjectGfx		; $68db
	ld a,MUS_MAKU_TREE		; $68de
	call playSound		; $68e0
	ld a,$02		; $68e3
	jp loadGfxRegisterStateIndex		; $68e5
	ld a,($cfd0)		; $68e8
	cp $07			; $68eb
	ret nz			; $68ed
	call $6f8c		; $68ee
	ld a,SNDCTRL_STOPSFX		; $68f1
	call playSound		; $68f3
	ld bc,$2800		; $68f6
	call checkIsLinkedGame		; $68f9
	jr z,_label_03_126	; $68fc
	ld c,$02		; $68fe
_label_03_126:
	jp showText		; $6900
	ld a,(wTextIsActive)		; $6903
	or a			; $6906
	ret nz			; $6907
	call $6f8c		; $6908
	ld hl,wTmpcbb3		; $690b
	ld (hl),$b4		; $690e
	ld a,$01		; $6910
	ld (w1Link.direction),a		; $6912
	ld ($cbb7),a		; $6915
	jr _label_03_131		; $6918
	call decCbb3		; $691a
	jr nz,_label_03_130	; $691d
	call checkIsLinkedGame		; $691f
	jr z,_label_03_127	; $6922
	ld a,$08		; $6924
	ld ($cfd0),a		; $6926
	jr _label_03_129		; $6929
_label_03_127:
	call getFreePartSlot		; $692b
	jr nz,_label_03_128	; $692e
	ld (hl),$27		; $6930
	inc l			; $6932
	inc (hl)		; $6933
	inc l			; $6934
	inc (hl)		; $6935
	ld l,$cb		; $6936
	ld (hl),$40		; $6938
	ld l,$cd		; $693a
	ld (hl),$88		; $693c
_label_03_128:
	call getFreeInteractionSlot		; $693e
	jr nz,_label_03_129	; $6941
	ld (hl),$8d		; $6943
_label_03_129:
	jp $6f8c		; $6945
_label_03_130:
	call $6f91		; $6948
	ret nz			; $694b
	ld l,$b7		; $694c
	ld a,(hl)		; $694e
	xor $02			; $694f
	ld (hl),a		; $6951
	call $6962		; $6952
_label_03_131:
	call getRandomNumber_noPreserveVars		; $6955
	and $03			; $6958
	add a			; $695a
	add a			; $695b
	add $10			; $695c
	ld (wTmpcbb6),a		; $695e
	ret			; $6961
_label_03_132:
	ld (w1Link.direction),a		; $6962
	ld a,$08		; $6965
	ld (wLinkForceState),a		; $6967
	ret			; $696a
	ld a,($cfd0)		; $696b
	cp $63			; $696e
	jr z,_label_03_133	; $6970
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
	jr _label_03_132		; $6998
_label_03_133:
	xor a			; $699a
	ld (wMenuDisabled),a		; $699b
	ld (wDisabledObjects),a		; $699e
	ld a,(wLoadingRoomPack)		; $69a1
	ld (wRoomPack),a		; $69a4
	ld a,GLOBALFLAG_SAVED_NAYRU		; $69a7
	call setGlobalFlag		; $69a9
	call refreshObjectGfx		; $69ac
	ld a,$01		; $69af
	ld (wCutsceneIndex),a		; $69b1
	ret			; $69b4
	call $69be		; $69b5
	call updateStatusBar		; $69b8
	jp updateAllObjects		; $69bb
	ld de,wCutsceneState		; $69be
	ld a,(de)		; $69c1
	rst_jumpTable			; $69c2
.dw $69cf
.dw $69d7
.dw $69e6
.dw $6a3c
.dw $6a52
.dw $6a8d

	ld a,$3c		; $69cf
	ld (wTmpcbb3),a		; $69d1
	jp $6f8c		; $69d4
	call decCbb3		; $69d7
	ret nz			; $69da
	call $6f8c		; $69db
	ld a,SNDCTRL_FAST_FADEOUT		; $69de
	call playSound		; $69e0
	jp fastFadeoutToBlack		; $69e3
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
	jr z,_label_03_134	; $6a20
	call $6f8c		; $6a22
	ld hl,wTmpcbb3		; $6a25
	ld (hl),$1e		; $6a28
	ret			; $6a2a
_label_03_134:
	call clearWramBank1		; $6a2b
	call clearOam		; $6a2e
	ld a,$05		; $6a31
	ld (wCutsceneState),a		; $6a33
	ld bc,$8d01		; $6a36
	jp _createInteraction		; $6a39
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
	jp $6f8c		; $6a4f
	ld hl,wTmpcbb3		; $6a52
	ld b,$02		; $6a55
	call flashScreen		; $6a57
	ret z			; $6a5a
	call $6f8c		; $6a5b
	ld a,$10		; $6a5e
	ld ($cfde),a		; $6a60
	callab _cutscene_loadObjectSetAndFadein
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
	ret			; $6a8d
	call $6a97		; $6a8e
	call updateStatusBar		; $6a91
	jp updateAllObjects		; $6a94
	ld de,wCutsceneState		; $6a97
	ld a,(de)		; $6a9a
	rst_jumpTable			; $6a9b
.dw $6aaa
.dw $6ac3
.dw $6ad3
.dw $6af2
.dw $6b16
.dw $6b22
.dw $6b66

	call $6f8c		; $6aaa
	ld b,$20		; $6aad
	ld hl,$cfc0		; $6aaf
	call clearMemory		; $6ab2
	ld a,$0d		; $6ab5
	ld hl,$cfde		; $6ab7
	ldi (hl),a		; $6aba
	ld (hl),$00		; $6abb
	call showStatusBar		; $6abd
	jp fadeoutToWhite		; $6ac0
	ld a,(wPaletteThread_mode)		; $6ac3
	or a			; $6ac6
	ret nz			; $6ac7
	call $6f8c		; $6ac8
	call _cutscene_loadObjectSetAndFadein		; $6acb
	ld a,$02		; $6ace
	jp loadGfxRegisterStateIndex		; $6ad0
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
	jr nz,_label_03_135	; $6ae7
	ld a,$03		; $6ae9
_label_03_135:
	ld hl,wCutsceneState		; $6aeb
	ld (hl),a		; $6aee
	jp fadeoutToWhite		; $6aef
	ld a,(wPaletteThread_mode)		; $6af2
	or a			; $6af5
	ret nz			; $6af6
	call $6ac3		; $6af7
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
	ld a,($cfc0)		; $6b16
	cp $03			; $6b19
	ret nz			; $6b1b
	call $6f8c		; $6b1c
	jp fadeoutToWhite		; $6b1f
	ld a,(wPaletteThread_mode)		; $6b22
	or a			; $6b25
	ret nz			; $6b26
	call $6f8c		; $6b27
	call clearDynamicInteractions		; $6b2a
	ld bc,$0290		; $6b2d
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
	ld a,(wPaletteThread_mode)		; $6b66
	or a			; $6b69
	ret nz			; $6b6a
	ld a,$01		; $6b6b
	ld (wMenuDisabled),a		; $6b6d
	ld (wDisabledObjects),a		; $6b70
	ld (wCutsceneIndex),a		; $6b73
	ret			; $6b76
	call $6b80		; $6b77
	call updateStatusBar		; $6b7a
	jp updateAllObjects		; $6b7d
	ld de,wCutsceneState		; $6b80
	ld a,(de)		; $6b83
	rst_jumpTable			; $6b84
.dw $6b99
.dw $6bc0
.dw $6bd5
.dw $6c09
.dw $6c1c
.dw $6c40
.dw $6c54
.dw $6c9d
.dw $6cbe
.dw $6cfc

	call $6f8c		; $6b99
	ld b,$20		; $6b9c
	ld hl,$cfc0		; $6b9e
	call clearMemory		; $6ba1
	ld a,SNDCTRL_STOPMUSIC		; $6ba4
	call playSound		; $6ba6
	ld hl,wTmpcbb3		; $6ba9
	ld (hl),$3c		; $6bac
	ld bc,$2810		; $6bae
	call checkIsLinkedGame		; $6bb1
	jr z,_label_03_136	; $6bb4
	ld c,$15		; $6bb6
_label_03_136:
	ld a,$02		; $6bb8
	ld ($cfc0),a		; $6bba
	jp showText		; $6bbd
	call _cutscene_decCBB3IfTextNotActive		; $6bc0
	ret nz			; $6bc3
	ld a,SNDCTRL_STOPMUSIC		; $6bc4
	call playSound		; $6bc6
	ld hl,wTmpcbb3		; $6bc9
	xor a			; $6bcc
	ld (hl),a		; $6bcd
	dec a			; $6bce
	ld (wTmpcbba),a		; $6bcf
	jp $6f8c		; $6bd2
	ld hl,wTmpcbb3		; $6bd5
	ld b,$01		; $6bd8
	call flashScreen		; $6bda
	ret z			; $6bdd
	call checkIsLinkedGame		; $6bde
	jr nz,_label_03_137	; $6be1
	call $6fb0		; $6be3
	jr _label_03_138		; $6be6
_label_03_137:
	call $6f9e		; $6be8
_label_03_138:
	ld a,$01		; $6beb
	ld (wDisabledObjects),a		; $6bed
	call clearDynamicInteractions		; $6bf0
	ld hl,objectData.objectData77b2		; $6bf3
	call checkIsLinkedGame		; $6bf6
	jr nz,_label_03_139	; $6bf9
	ld hl,wCutsceneState		; $6bfb
	ld (hl),$06		; $6bfe
	ld hl,objectData.objectData77a5		; $6c00
_label_03_139:
	call parseGivenObjectData		; $6c03
	jp $6f8c		; $6c06
	ld a,($cfc0)		; $6c09
	cp $03			; $6c0c
	ret nz			; $6c0e
	ld a,SNDCTRL_STOPMUSIC		; $6c0f
	call playSound		; $6c11
	ld a,SND_LIGHTNING		; $6c14
	call playSound		; $6c16
	jp $6bc9		; $6c19
	ld hl,wTmpcbb3		; $6c1c
	ld b,$04		; $6c1f
	call flashScreen		; $6c21
	ret z			; $6c24
	ld a,$12		; $6c25
	ld ($cfde),a		; $6c27
	call _cutscene_loadObjectSetAndFadein		; $6c2a
	call showStatusBar		; $6c2d
	call $6f8c		; $6c30
	ld a,MUS_ZELDA_SAVED		; $6c33
	call playSound		; $6c35
	ld a,$02		; $6c38
	call loadGfxRegisterStateIndex		; $6c3a
	jp resetCamera		; $6c3d
	ld hl,$cfdf		; $6c40
	ld a,(hl)		; $6c43
	cp $ff			; $6c44
	ret nz			; $6c46
	ld a,SND_LIGHTNING		; $6c47
	call playSound		; $6c49
	ld a,SNDCTRL_STOPMUSIC		; $6c4c
	call playSound		; $6c4e
	jp $6bc9		; $6c51
	ld hl,wTmpcbb3		; $6c54
	ld b,$01		; $6c57
	call flashScreen		; $6c59
	ret z			; $6c5c
	ld hl,$cfde		; $6c5d
	inc (hl)		; $6c60
	call _cutscene_loadObjectSetAndFadein		; $6c61
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
	call $603a		; $6c79
	call $6f8c		; $6c7c
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
	jp $6fb0		; $6c9a
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
	jp $6f8c		; $6cbb
	ld a,(wPaletteThread_mode)		; $6cbe
	or a			; $6cc1
	ret nz			; $6cc2
	call $6f8c		; $6cc3
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
	ld bc,$8706		; $6ce7
	call _createInteraction		; $6cea
	ld bc,$4050		; $6ced
	call interactionHSetPosition		; $6cf0
	ld a,(wActiveMusic2)		; $6cf3
	ld (wActiveMusic),a		; $6cf6
	jp playSound		; $6cf9
	ld a,($cfc0)		; $6cfc
	cp $04			; $6cff
	ret nz			; $6d01
	call refreshObjectGfx		; $6d02
	ld a,$01		; $6d05
	ld (wCutsceneIndex),a		; $6d07
	ret			; $6d0a
	call $6d11		; $6d0b
	jp updateAllObjects		; $6d0e
	ld de,wCutsceneState		; $6d11
	ld a,(de)		; $6d14
	rst_jumpTable			; $6d15
.dw $6d30
.dw $6d76
.dw $6d84
.dw $6d88
.dw $6da7
.dw $6dc8
.dw $6dd8
.dw $6def
.dw $6e04
.dw $6e1a
.dw $6e26
.dw $6e75
.dw $6e86

	ld a,(wPaletteThread_mode)		; $6d30
	or a			; $6d33
	ret nz			; $6d34
	call checkIsLinkedGame		; $6d35
	jr nz,_label_03_140	; $6d38
	ld a,$0a		; $6d3a
	ld (de),a		; $6d3c
	jp $6e26		; $6d3d
_label_03_140:
	ld a,$01		; $6d40
	ld (de),a		; $6d42
	ld bc,$05f1		; $6d43
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
	ld e,$96		; $6d76
_label_03_141:
	call decCbb3		; $6d78
	ret nz			; $6d7b
	call $6f8c		; $6d7c
	ld hl,wTmpcbb3		; $6d7f
	ld (hl),e		; $6d82
	ret			; $6d83
	ld e,$3c		; $6d84
	jr _label_03_141		; $6d86
	call decCbb3		; $6d88
	ret nz			; $6d8b
	call $6f8c		; $6d8c
	call fastFadeinFromBlack		; $6d8f
	ld a,$40		; $6d92
	ld (wDirtyFadeSprPalettes),a		; $6d94
	ld (wFadeSprPaletteSources),a		; $6d97
	ld a,$03		; $6d9a
	ld (wDirtyFadeBgPalettes),a		; $6d9c
	ld (wFadeBgPaletteSources),a		; $6d9f
	ld a,SND_LIGHTTORCH		; $6da2
	jp playSound		; $6da4
	ld a,(wPaletteThread_mode)		; $6da7
	or a			; $6daa
	ret nz			; $6dab
	call $6f8c		; $6dac
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
	call decCbb3		; $6dc8
	ret nz			; $6dcb
	xor a			; $6dcc
	ld (wPaletteThread_mode),a		; $6dcd
	ld a,$78		; $6dd0
	ld (wTmpcbb3),a		; $6dd2
	jp $6f8c		; $6dd5
	call decCbb3		; $6dd8
	ret nz			; $6ddb
	call $6f8c		; $6ddc
	ld a,TEXTBOXFLAG_DONTCHECKPOSITION		; $6ddf
	ld (wTextboxFlags),a		; $6de1
	ld a,$03		; $6de4
	ld (wTextboxPosition),a		; $6de6
	ld bc,$281a		; $6de9
	jp showText		; $6dec
	call retIfTextIsActive		; $6def
	call $6f8c		; $6df2
	ld (wTmpcbb3),a		; $6df5
	dec a			; $6df8
	ld (wTmpcbba),a		; $6df9
	call restartSound		; $6dfc
	ld a,SND_BIG_EXPLOSION_2		; $6dff
	jp playSound		; $6e01
	ld hl,wTmpcbb3		; $6e04
	ld b,$03		; $6e07
	call flashScreen		; $6e09
	ret z			; $6e0c
	call $6f8c		; $6e0d
	ld a,$3c		; $6e10
	ld (wTmpcbb3),a		; $6e12
	ld a,$02		; $6e15
	jp fadeoutToWhiteWithDelay		; $6e17
	ld a,(wPaletteThread_mode)		; $6e1a
	or a			; $6e1d
	ret nz			; $6e1e
	call decCbb3		; $6e1f
	ret nz			; $6e22
	jp $6f8c		; $6e23
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
	call $6e9a		; $6e48
	call $6eb7		; $6e4b
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
	call $6f8c		; $6e65
	call clearPaletteFadeVariablesAndRefreshPalettes		; $6e68
	xor a			; $6e6b
	ldh (<hCameraY),a	; $6e6c
	ldh (<hCameraX),a	; $6e6e
	ld a,$15		; $6e70
	jp loadGfxRegisterStateIndex		; $6e72
	ld a,(wTmpcbb9)		; $6e75
	cp $07			; $6e78
	ret nz			; $6e7a
	call clearLinkObject		; $6e7b
	ld hl,wTmpcbb3		; $6e7e
	ld (hl),$3c		; $6e81
	jp $6f8c		; $6e83
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
	ld a,($ff00+R_SVBK)	; $6eb7
	push af			; $6eb9
	ld a,$03		; $6eba
	ld ($ff00+R_SVBK),a	; $6ebc
	ld hl,$d800		; $6ebe
	ld bc,$0240		; $6ec1
	call clearMemoryBc		; $6ec4
	ld hl,$dc00		; $6ec7
	ld bc,$0240		; $6eca
	ld a,$02		; $6ecd
	call fillMemoryBc		; $6ecf
	pop af			; $6ed2
	ld ($ff00+R_SVBK),a	; $6ed3
	ret			; $6ed5
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
	ld a,(wTmpcbb9)		; $6ef7
	or a			; $6efa
	jr z,_label_03_142	; $6efb
	ld hl,$cbb7		; $6efd
	ld b,$01		; $6f00
	call flashScreen		; $6f02
	ret z			; $6f05
	xor a			; $6f06
	ld (wTmpcbb9),a		; $6f07
	ret			; $6f0a
_label_03_142:
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

	ld a,(wGfxRegs1.SCY)		; $6f44
	cpl			; $6f47
	inc a			; $6f48
	ld b,a			; $6f49
	xor a			; $6f4a
	ldh (<hOamTail),a	; $6f4b
	ld c,a			; $6f4d
	ld a,($cbb8)		; $6f4e
	rst_jumpTable			; $6f51
.dw $6f58
.dw $6f60
.dw $6f70

	ld hl,bank3f.oamData_714c		; $6f58
	ld e,:bank3f.oamData_714c		; $6f5b
	jp addSpritesFromBankToOam_withOffset		; $6f5d

	ld hl,bank3f.oamData_718d		; $6f60
	ld e,:bank3f.oamData_718d		; $6f63
	call addSpritesFromBankToOam_withOffset		; $6f65
	ld hl,bank3f.oamData_71ce		; $6f68
	ld e,:bank3f.oamData_71ce		; $6f6b
	jp addSpritesFromBankToOam_withOffset		; $6f6d

	ld hl,bank3f.oamData_71f7		; $6f70
	ld e,:bank3f.oamData_71f7		; $6f73
	call addSpritesFromBankToOam_withOffset		; $6f75
	ld hl,bank3f.oamData_718d		; $6f78
	ld e,:bank3f.oamData_718d		; $6f7b
	ld a,(wGfxRegs1.SCY)		; $6f7d
	cp $71			; $6f80
	jr c,_label_03_143	; $6f82
	ld hl,bank3f.oamData_7220		; $6f84
	ld e,:bank3f.oamData_7220		; $6f87
_label_03_143:
	jp addSpritesFromBankToOam_withOffset		; $6f89

	ld hl,wCutsceneState		; $6f8c
	inc (hl)		; $6f8f
	ret			; $6f90
	ld hl,wTmpcbb6		; $6f91
	dec (hl)		; $6f94
	ret			; $6f95
	ld a,(wPaletteThread_mode)		; $6f96
	or a			; $6f99
	ret nz			; $6f9a
	jp decCbb3		; $6f9b
	ld a,($ff00+R_SVBK)	; $6f9e
	push af			; $6fa0
	ld a,$02		; $6fa1
	ld ($ff00+R_SVBK),a	; $6fa3
	ld hl,$de90		; $6fa5
	ld b,$30		; $6fa8
	call clearMemory		; $6faa
	pop af			; $6fad
	ld ($ff00+R_SVBK),a	; $6fae
	ld a,($ff00+R_SVBK)	; $6fb0
	push af			; $6fb2
	ld a,$02		; $6fb3
	ld ($ff00+R_SVBK),a	; $6fb5
	ld hl,$df80		; $6fb7
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
_cutscene_getObjectSetIndexAndSomething:
	ld hl,@data		; $6fd6
	rst_addDoubleIndex			; $6fd9
	ld b,(hl)		; $6fda
	inc hl			; $6fdb
	ld c,(hl)		; $6fdc
	call disableLcdAndLoadRoom		; $6fdd
	jp resetCamera		; $6fe0

@data:
	.db $00 $98
	.db $00 $5a
	.db $02 $0e
	.db $00 $39
	.db $00 $39
	.db $02 $0e
	.db $00 $5a
	.db $00 $38
	.db $01 $49
	.db $01 $84
	.db $01 $65
	.db $05 $f1
	.db $01 $65
	.db $01 $49
	.db $01 $84
	.db $04 $f6
	.db $05 $f1
	.db $00 $38
	.db $01 $49
	.db $00 $38

	ld hl,$cbb4		; $700b
	dec (hl)		; $700e
	ret nz			; $700f
	ld (hl),30		; $7010
	ret			; $7012
_label_03_146:
	ld hl,wCutsceneState		; $7013
	inc (hl)		; $7016
	ret			; $7017
_label_03_147:
	ld hl,wTmpcbb3		; $7018
	inc (hl)		; $701b
	ret			; $701c

;;
; @addr{701d}
func_701d:
	ld a,(wDungeonIndex)		; $701d
	cp $08			; $7020
	jp z,$70b4		; $7022
	ld a,(wCutsceneState)		; $7025
	rst_jumpTable			; $7028
.dw $702d
.dw $7053

_label_03_148:
	ld a,$72		; $702d
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
	jr _label_03_146		; $7051
	ld a,(wTmpcbb3)		; $7053
	rst_jumpTable			; $7056
.dw $705b
.dw $7063

	call $700b		; $705b
	ret nz			; $705e
	ld (hl),$3c		; $705f
	jr _label_03_147		; $7061
	ld a,$3c		; $7063
	call setScreenShakeCounter		; $7065
	call $700b		; $7068
	ret nz			; $706b
	ld (hl),$19		; $706c
	callab generateW3VramTilesAndAttributes		; $706e
	ld bc,$260c		; $7076
	call $70f7		; $7079
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
	call $7098		; $708f
	ld a,$0f		; $7092
	ld ($ce5d),a		; $7094
	ret			; $7097
_label_03_149:
	ld a,SND_SOLVEPUZZLE		; $7098
	call playSound		; $709a
	ld a,$01		; $709d
	ld (wCutsceneIndex),a		; $709f
	ld a,$01		; $70a2
	ld (wScrollMode),a		; $70a4
	xor a			; $70a7
	ld (wDisabledObjects),a		; $70a8
	ld (wMenuDisabled),a		; $70ab
	call loadTilesetAndRoomLayout		; $70ae
	jp loadRoomCollisions		; $70b1
	ld a,(wCutsceneState)		; $70b4
	rst_jumpTable			; $70b7
.dw $70bc
.dw $70c1

	ld a,$73		; $70bc
	jp $702f		; $70be
	ld a,(wTmpcbb3)		; $70c1
	rst_jumpTable			; $70c4
.dw $705b
.dw $70c9

	ld a,$3c		; $70c9
	call setScreenShakeCounter		; $70cb
	call $700b		; $70ce
	ret nz			; $70d1
	ld (hl),$19		; $70d2
	callab generateW3VramTilesAndAttributes		; $70d4
	ld bc,$4d04		; $70dc
	call $70f7		; $70df
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
	jr _label_03_149		; $70f5
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
	call $712f		; $7126
	pop hl			; $7129
	set 2,h			; $712a
	ld de,$d400		; $712c
	ldh a,(<hFF93)	; $712f
	ld c,a			; $7131
	ld a,$14		; $7132
	sub c			; $7134
	ret c			; $7135
	ld c,a			; $7136
_label_03_150:
	ldh a,(<hFF8C)	; $7137
	ld b,a			; $7139
_label_03_151:
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
	jr nz,_label_03_151	; $714a
	ldh a,(<hFF8E)	; $714c
	call addAToDe		; $714e
	ldh a,(<hFF8E)	; $7151
	rst_addAToHl			; $7153
	dec c			; $7154
	jr nz,_label_03_150	; $7155
	ret			; $7157
	ld hl,wTmpcbb4		; $7158
	dec (hl)		; $715b
	ret nz			; $715c
	ret			; $715d
	ld hl,wCutsceneState		; $715e
	inc (hl)		; $7161
	ret			; $7162
	ld hl,wTmpcbb3		; $7163
	inc (hl)		; $7166
	ret			; $7167

;;
; @addr{7168}
func_7168:
	ld a,(wCutsceneState)		; $7168
	rst_jumpTable			; $716b
.dw $7176
.dw $7196
.dw $71b1
.dw $720b
.dw $7212

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
	call $715e		; $7190
	jp reloadTileMap		; $7193
	call $7158		; $7196
	ret nz			; $7199
	call $715e		; $719a
	call getFreeInteractionSlot		; $719d
	jr nz,_label_03_152	; $71a0
	ld (hl),$97		; $71a2
	ld l,$4b		; $71a4
	ld (hl),$2c		; $71a6
	ld l,$4d		; $71a8
	ld (hl),$58		; $71aa
_label_03_152:
	ld a,$50		; $71ac
	jp loadGfxHeader		; $71ae
	ld a,$0f		; $71b1
	call setScreenShakeCounter		; $71b3
	call $722f		; $71b6
	ld a,(wTmpcbb3)		; $71b9
	rst_jumpTable			; $71bc
.dw $71c5
.dw $71e2
.dw $71f0
.dw $71f4

_label_03_153:
	ld bc,roomGfxChanges.rectangleData_02_7de1		; $71c5
	callab roomGfxChanges.copyRectangleFromTmpGfxBuffer_paramBc		; $71c8
	ld a,UNCMP_GFXH_3c		; $71d0
	call loadUncompressedGfxHeader		; $71d2
	ld a,SND_DOORCLOSE		; $71d5
	call playSound		; $71d7
	ld a,$1e		; $71da
	ld (wTmpcbb4),a		; $71dc
	jp $7163		; $71df
	ld b,$51		; $71e2
_label_03_154:
	call $7158		; $71e4
	ret nz			; $71e7
	ld (hl),$1e		; $71e8
	ld a,b			; $71ea
	call loadGfxHeader		; $71eb
	jr _label_03_153		; $71ee
	ld b,$52		; $71f0
	jr _label_03_154		; $71f2
	call $7158		; $71f4
	ret nz			; $71f7
	callab roomGfxChanges.drawCollapsedWingDungeon		; $71f8
	call $71d0		; $7200
	ld a,$3c		; $7203
	ld (wTmpcbb4),a		; $7205
	jp $715e		; $7208
	call $7158		; $720b
	ret nz			; $720e
	jp $715e		; $720f
	ld a,$01		; $7212
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
	ret			; $722f
	nop			; $7230
	ld bc,$0000		; $7231
	ld hl,wTmpcbb4		; $7234
	dec (hl)		; $7237
	ret nz			; $7238
	ret			; $7239
	ld hl,wCutsceneState		; $723a
	inc (hl)		; $723d
	ret			; $723e
_label_03_155:
	ld hl,wTmpcbb3		; $723f
	inc (hl)		; $7242
	ret			; $7243

;;
; @addr{7244}
func_03_7244:
	ld a,(wCutsceneState)		; $7244
	rst_jumpTable			; $7247
.dw $7250
.dw $729d
.dw $7318
.dw $73b2

	ld b,$10		; $7250
	ld hl,wTmpcbb3		; $7252
	call clearMemory		; $7255
	call $723a		; $7258
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
	ld a,(wTmpcbb3)		; $729d
	rst_jumpTable			; $72a0
.dw $72ad
.dw $72b8
.dw $72bd
.dw $72c2
.dw $72c7
.dw $72d3

	ld hl,$d000		; $72ad
_label_03_156:
	call $7431		; $72b0
	call $745c		; $72b3
	jr _label_03_155		; $72b6
	ld hl,$d400		; $72b8
	jr _label_03_156		; $72bb
	ld hl,$d800		; $72bd
	jr _label_03_156		; $72c0
	ld hl,$dc00		; $72c2
	jr _label_03_156		; $72c5
	ld hl,$d000		; $72c7
	call $7431		; $72ca
	call $7456		; $72cd
	jp $723f		; $72d0
	ld hl,$d400		; $72d3
	call $7431		; $72d6
	call $7450		; $72d9
	ld hl,$cbb7		; $72dc
	dec (hl)		; $72df
	jr z,_label_03_157	; $72e0
	ld hl,$cbb8		; $72e2
	inc (hl)		; $72e5
	ld hl,wTmpcbb3		; $72e6
	ld (hl),$00		; $72e9
	ret			; $72eb
_label_03_157:
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
	jp $723a		; $7315
	ld a,(wTmpcbb3)		; $7318
	rst_jumpTable			; $731b
.dw $7326
.dw $7350
.dw $7375
.dw $739d
.dw $73a7

	ld a,(wcddf)		; $7326
	or a			; $7329
	jr nz,_label_03_158	; $732a
	callab func_04_6f07		; $732c
_label_03_158:
	ld a,$03		; $7334
	ld ($ff00+R_SVBK),a	; $7336
	ld bc,$02c0		; $7338
	ld hl,$d800		; $733b
	call clearMemoryBc		; $733e
	ld bc,$02c0		; $7341
	ld hl,$dc00		; $7344
	call clearMemoryBc		; $7347
	call reloadTileMap		; $734a
	jp $723f		; $734d
	call getFreeInteractionSlot		; $7350
	ld (hl),$dd		; $7353
	ld l,$46		; $7355
	ld a,$78		; $7357
	ld (hl),a		; $7359
	ld (wTmpcbb4),a		; $735a
	ld a,(wTilesetFlags)		; $735d
	and $80			; $7360
	ld a,$02		; $7362
	jr nz,_label_03_159	; $7364
	dec a			; $7366
_label_03_159:
	ld l,$43		; $7367
	ld (hl),a		; $7369
	ld (wcc50),a		; $736a
.ifdef ROM_AGES
	ld a,SND_TIMEWARP_INITIATED		; $736d
.else
	ld a,$d1
.endif
	call playSound		; $736f
	jp $723f		; $7372
	call $7234		; $7375
	ret nz			; $7378
	ld (hl),$3c		; $7379
	call getFreeInteractionSlot		; $737b
	jr nz,_label_03_160	; $737e
	ld (hl),$dd		; $7380
	inc l			; $7382
	ld (hl),$02		; $7383
	ld de,w1Link.yh		; $7385
	call objectCopyPosition_rawAddress		; $7388
_label_03_160:
	ld de,w1Link.yh		; $738b
	call getShortPositionFromDE		; $738e
	ld (wTmpcbb9),a		; $7391
	ld de,$d000		; $7394
	call objectDelete_de		; $7397
	jp $723f		; $739a
	call $7234		; $739d
	ret nz			; $73a0
	call fastFadeinFromBlack		; $73a1
	jp $723f		; $73a4
	ld a,(wPaletteThread_mode)		; $73a7
	or a			; $73aa
	ret nz			; $73ab
	call fadeoutToWhite		; $73ac
	jp $723a		; $73af
	ld a,(wcddf)		; $73b2
	or a			; $73b5
	jr nz,_label_03_161	; $73b6
	callab func_04_6e9b		; $73b8
_label_03_161:
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
	jr nc,_label_03_162	; $73ef
	ld a,(wTmpcbb9)		; $73f1
	ld (wWarpDestPos),a		; $73f4
_label_03_162:
	ld a,$03		; $73f7
	ld (wCutsceneIndex),a		; $73f9
	ld a,$ff		; $73fc
	ld (wActiveMusic),a		; $73fe
	ld a,(wActiveRoom)		; $7401
	ld hl,$7411		; $7404
	call checkFlag		; $7407
	ret z			; $740a
	ld a,$01		; $740b
	ld (wSentBackByStrangeForce),a		; $740d
	ret			; $7410
	nop			; $7411
	nop			; $7412
	nop			; $7413
	nop			; $7414
	nop			; $7415
	nop			; $7416
	nop			; $7417
	nop			; $7418
	nop			; $7419
	nop			; $741a
	nop			; $741b
	jr c,_label_03_163	; $741c
_label_03_163:
	jr c,_label_03_166	; $741e
	jr c,$60		; $7420
	stop			; $7422
	nop			; $7423
	nop			; $7424
	nop			; $7425
	nop			; $7426
	nop			; $7427
	nop			; $7428
	nop			; $7429
	nop			; $742a
	nop			; $742b
	nop			; $742c
	nop			; $742d
	nop			; $742e
	nop			; $742f
	nop			; $7430


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


	ld b,$2f		; $7450
	ld c,$06		; $7452
	jr _label_03_164		; $7454
	ld b,$3f		; $7456
	ld c,$06		; $7458
	jr _label_03_164		; $745a
	ld b,$3f		; $745c
	ld c,$05		; $745e
_label_03_164:
	push bc			; $7460
	push hl			; $7461
	ld a,c			; $7462
	ld ($ff00+R_SVBK),a	; $7463
	ld b,$00		; $7465
_label_03_165:
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
	jr nz,_label_03_165	; $7474
	pop hl			; $7476
	pop bc			; $7477
	ld a,c			; $7478
	sub $05			; $7479
	ld e,a			; $747b
	ld a,h			; $747c
	and $8f			; $747d
	ld d,a			; $747f
_label_03_166:
	jp queueDmaTransfer		; $7480
	ld hl,wTmpcbb4		; $7483
	dec (hl)		; $7486
	ret nz			; $7487
	ret			; $7488
	ld hl,wCutsceneState		; $7489
	inc (hl)		; $748c
	ret			; $748d
	ld hl,wTmpcbb3		; $748e
	inc (hl)		; $7491
	ret			; $7492

;;
; @addr{7493}
func_03_7493:
	ld a,(wCutsceneState)		; $7493
	rst_jumpTable			; $7496
	.dw $749d
	.dw $74de
	.dw $7529

	ld a,(wPaletteThread_mode)		; $749d
	or a			; $74a0
	ret nz			; $74a1
	ld b,$08		; $74a2
	ld hl,wTmpcbb3		; $74a4
	call clearMemory		; $74a7
	ld a,$3c		; $74aa
	ld (wTmpcbb4),a		; $74ac
	call $7489		; $74af
	call disableLcd		; $74b2
	call clearOam		; $74b5
	call clearScreenVariablesAndWramBank1		; $74b8
	callab bank1.clearMemoryOnScreenReload		; $74bb
	call stopTextThread		; $74c3
	xor a			; $74c6
	ld bc,$0127		; $74c7
	call func_36f6		; $74ca
	call loadRoomCollisions		; $74cd
	call func_131f		; $74d0
	call loadCommonGraphics		; $74d3
	call fadeinFromWhite		; $74d6
	ld a,$02		; $74d9
	jp loadGfxRegisterStateIndex		; $74db
	ld a,(wTmpcbb3)		; $74de
	rst_jumpTable			; $74e1
.dw $74e6
.dw $751b

	ld a,(wPaletteThread_mode)		; $74e6
	or a			; $74e9
	ret nz			; $74ea
	call $7483		; $74eb
	ret nz			; $74ee
	ld (hl),$3e		; $74ef
	ld a,(wTmpcbbd)		; $74f1
	ld hl,_table_7513		; $74f4
	rst_addDoubleIndex			; $74f7
	ldi a,(hl)		; $74f8
	ld b,(hl)		; $74f9
	ld c,a			; $74fa
	call getFreeInteractionSlot		; $74fb
	ret nz			; $74fe
	ld (hl),$14		; $74ff
	ld l,$49		; $7501
	ld (hl),b		; $7503
	ld l,$4b		; $7504
	call setShortPosition_paramC		; $7506
	ld l,$4b		; $7509
	dec (hl)		; $750b
	dec (hl)		; $750c
	ld l,$70		; $750d
	ld (hl),c		; $750f
	jp $748e		; $7510

_table_7513:
	.db $33 $10
	.db $34 $00
	.db $35 $10
	.db $36 $00

	call $7483		; $751b
	ret nz			; $751e
	ld (hl),$1e		; $751f
	ld a,SND_SOLVEPUZZLE		; $7521
	call playSound		; $7523
	jp $7489		; $7526
	call $7483		; $7529
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
	ld a,$03		; $7549
	ld (wCutsceneIndex),a		; $754b
	xor a			; $754e
	ld (wMenuDisabled),a		; $754f
	jp fadeoutToWhite		; $7552
	ld hl,wTmpcbb4		; $7555
	dec (hl)		; $7558
	ret nz			; $7559
	ret			; $755a
_label_03_167:
	ld hl,wCutsceneState		; $755b
	inc (hl)		; $755e
	ret			; $755f
_label_03_168:
	ld hl,wTmpcbb3		; $7560
	inc (hl)		; $7563
	ret			; $7564

func_03_7565:
	ld a,(wCutsceneState)		; $7565
	rst_jumpTable			; $7568
.dw $756f
.dw $758f
.dw $75e9

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
	jr _label_03_167		; $758d
	ld a,(wTmpcbb3)		; $758f
	rst_jumpTable			; $7592
.dw $759b
.dw $75ae
.dw $75b6
.dw $75d7

	call $7555		; $759b
	ret nz			; $759e
	ld (hl),$3c		; $759f
	call reloadTileMap		; $75a1
	callab bank1.checkInitUnderwaterWaves		; $75a4
	jr _label_03_168		; $75ac
	call $7555		; $75ae
	ret nz			; $75b1
	ld (hl),$3c		; $75b2
	jr _label_03_168		; $75b4
	ld a,$3c		; $75b6
	call setScreenShakeCounter		; $75b8
	call $7555		; $75bb
	ret nz			; $75be
	ld (hl),$3c		; $75bf
	call $7560		; $75c1
	ld bc,$9701		; $75c4
	call objectCreateInteraction		; $75c7
	ld a,$74		; $75ca
_label_03_169:
	call loadGfxHeader		; $75cc
	call reloadTileMap		; $75cf
	ld a,SND_DOORCLOSE		; $75d2
	jp playSound		; $75d4
	ld a,$3c		; $75d7
	call setScreenShakeCounter		; $75d9
	call $7555		; $75dc
	ret nz			; $75df
	ld (hl),$3c		; $75e0
	call $755b		; $75e2
	ld a,$75		; $75e5
	jr _label_03_169		; $75e7
	call $7555		; $75e9
	ret nz			; $75ec
	ld a,SND_SOLVEPUZZLE		; $75ed
	call playSound		; $75ef
	ld a,$01		; $75f2
	ld (wCutsceneIndex),a		; $75f4
	ld a,$01		; $75f7
	ld (wScrollMode),a		; $75f9
	xor a			; $75fc
	ld (wDisabledObjects),a		; $75fd
	ld (wMenuDisabled),a		; $7600
	call loadTilesetAndRoomLayout		; $7603
	jp loadRoomCollisions		; $7606
	ld hl,wTmpcbb4		; $7609
	dec (hl)		; $760c
	ret nz			; $760d
	ret			; $760e
	ld hl,wCutsceneState		; $760f
	inc (hl)		; $7612
	ret			; $7613
	ld hl,wTmpcbb3		; $7614
	inc (hl)		; $7617
	ret			; $7618

;;
; @addr{7619}
func_03_7619:
	ld a,(wCutsceneState)		; $7619
	rst_jumpTable			; $761c
.dw $762b
.dw $767c
.dw $7702
.dw $772c
.dw $775d
.dw $779a
.dw $77d6

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
	call $760f		; $7643
	xor a			; $7646
	ld bc,$01a5		; $7647
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
	ld a,(wTmpcbb3)		; $767c
	rst_jumpTable			; $767f
.dw $7688
.dw $7695
.dw $76cb
.dw $76ea

	ld a,(wPaletteThread_mode)		; $7688
	or a			; $768b
	ret nz			; $768c
	ld a,$f0		; $768d
	ld (wTmpcbb4),a		; $768f
	jp $7614		; $7692
	ld a,(wFrameCounter)		; $7695
	and $07			; $7698
	jr nz,_label_03_170	; $769a
	call getFreePartSlot		; $769c
	jr nz,_label_03_170	; $769f
	ld (hl),$26		; $76a1
	call getRandomNumber		; $76a3
	and $7f			; $76a6
	ld c,a			; $76a8
	ld l,$cb		; $76a9
	call setShortPosition_paramC		; $76ab
_label_03_170:
	ld a,(wFrameCounter)		; $76ae
	and $1f			; $76b1
	ld a,SND_MAGIC_POWDER		; $76b3
	call z,playSound		; $76b5
	call $7609		; $76b8
	ret nz			; $76bb
	ld (hl),$78		; $76bc
	ld a,$04		; $76be
	call fadeoutToWhiteWithDelay		; $76c0
	ld a,SND_FADEOUT		; $76c3
	call playSound		; $76c5
	jp $7614		; $76c8
	ld a,(wPaletteThread_mode)		; $76cb
	or a			; $76ce
	ret nz			; $76cf
	call $782a		; $76d0
	call $782a		; $76d3
	call $782a		; $76d6
	call $782a		; $76d9
	ret z			; $76dc
	ld a,$04		; $76dd
	call fadeinFromWhiteWithDelay		; $76df
	ld a,SND_FAIRYCUTSCENE		; $76e2
	call playSound		; $76e4
	jp $7614		; $76e7
	ld a,(wPaletteThread_mode)		; $76ea
	or a			; $76ed
	ret nz			; $76ee
	call $7609		; $76ef
	ret nz			; $76f2
	ld (hl),$3c		; $76f3
	call $760f		; $76f5
	xor a			; $76f8
	ld (wTmpcbb3),a		; $76f9
	ld bc,$01d2		; $76fc
	jp $764a		; $76ff
	ld a,(wTmpcbb3)		; $7702
	rst_jumpTable			; $7705
.dw $7688
.dw $7695
.dw $76cb
.dw $770e

	ld a,(wPaletteThread_mode)		; $770e
	or a			; $7711
	ret nz			; $7712
	call $7609		; $7713
	ret nz			; $7716
	ld (hl),$3c		; $7717
	call $760f		; $7719
	xor a			; $771c
	ld (wTmpcbb3),a		; $771d
	ld bc,$03b1		; $7720
	call $764a		; $7723
	ld hl,objectData.objectData7e71		; $7726
	jp parseGivenObjectData		; $7729
	ld a,(wTmpcbb3)		; $772c
	rst_jumpTable			; $772f
.dw $7688
.dw $7695
.dw $76cb
.dw $7738

	ld a,(wPaletteThread_mode)		; $7738
	or a			; $773b
	ret nz			; $773c
	ld hl,$cfc0		; $773d
	bit 7,(hl)		; $7740
	ret z			; $7742
	res 7,(hl)		; $7743
	call $760f		; $7745
	xor a			; $7748
	ld (wTmpcbb3),a		; $7749
	ld a,$3c		; $774c
	ld (wTmpcbb4),a		; $774e
	ld bc,$03b0		; $7751
	call $764a		; $7754
	ld hl,objectData.objectData7e7b		; $7757
	jp parseGivenObjectData		; $775a
	ld a,(wTmpcbb3)		; $775d
	rst_jumpTable			; $7760
.dw $7688
.dw $7695
.dw $76cb
.dw $7769

	ld a,(wPaletteThread_mode)		; $7769
	or a			; $776c
	ret nz			; $776d
	ld hl,$cfc0		; $776e
	bit 7,(hl)		; $7771
	ret z			; $7773
	ld a,$3c		; $7774
	ld (wTmpcbb4),a		; $7776
	call $760f		; $7779
	xor a			; $777c
	ld (wTmpcbb3),a		; $777d
	ld bc,$01a3		; $7780
	call $764a		; $7783
	ld hl,$d000		; $7786
	ld (hl),$03		; $7789
	ld l,$0b		; $778b
	ld (hl),$38		; $778d
	ld l,$0d		; $778f
	ld (hl),$68		; $7791
	ld l,$08		; $7793
	ld (hl),$02		; $7795
	jp setLinkForceStateToState08		; $7797
	ld a,(wTmpcbb3)		; $779a
	ld e,a			; $779d
	or a			; $779e
	jr z,_label_03_172	; $779f
	ld a,(wFrameCounter)		; $77a1
	and $1f			; $77a4
	jr nz,_label_03_172	; $77a6
	ld a,(w1Link.direction)		; $77a8
	and $02			; $77ab
	xor $02			; $77ad
_label_03_171:
	or $01			; $77af
	ld (w1Link.direction),a		; $77b1
_label_03_172:
	ld a,e			; $77b4
	rst_jumpTable			; $77b5
.dw $7688
.dw $7695
.dw $76cb
.dw $77be

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
	jp $760f		; $77d3
	call $7609		; $77d6
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
	ld a,$00		; $7818
	ld (wCutsceneIndex),a		; $781a
	ld a,$02		; $781d
	ld (w1Link.direction),a		; $781f
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $7822
	call setGlobalFlag		; $7824
	jp setDeathRespawnPoint		; $7827
	ld a,$eb		; $782a
	call findTileInRoom		; $782c
	ret nz			; $782f
	ld c,l			; $7830
	ld a,(wTilesetFlags)		; $7831
	and $40			; $7834
	ld a,$fc		; $7836
	jr z,_label_03_173	; $7838
	ld a,$3a		; $783a
_label_03_173:
	call setTile		; $783c
	xor a			; $783f
	ret			; $7840

;;
; Called from "func_3ed0" in bank 0.
;
; @addr{7841}
func_03_7841:
	ld a,(wCutsceneState)		; $7841
	rst_jumpTable			; $7844
.dw _func_03_7851
.dw _func_03_786b

;;
; Called from "func_3ee4" in bank 0.
; @addr{7849}
func_03_7849:
	ld a,(wCutsceneState)		; $7849
	rst_jumpTable			; $784c
.dw _func_03_7851
.dw $797d

;;
; @addr{7851}
_func_03_7851:
	ld b,$10		; $7851
	ld hl,wTmpcbb3		; $7853
	call clearMemory		; $7856
	call clearWramBank1		; $7859
	xor a			; $785c
	ld (wDisabledObjects),a		; $785d
	ld a,$80		; $7860
	ld (wMenuDisabled),a		; $7862
	ld a,$01		; $7865
	ld (wCutsceneState),a		; $7867
	ret			; $786a

;;
; @addr{786b}
_func_03_786b:
	ld a,(wTmpcbb3)		; $786b
	rst_jumpTable			; $786e
.dw $7887
.dw $788f
.dw $78b8
.dw $78c7
.dw _func_03_78e1
.dw $78ef
.dw $7913
.dw $7936
.dw $793f
.dw $7948
.dw $7951
.dw $7960

	ld a,$28		; $7887
	ld (wTmpcbb5),a		; $7889
	jp $7b8b		; $788c
	call _func_03_7b95		; $788f
	ret nz			; $7892
	call $7bab		; $7893
	call getFreeInteractionSlot		; $7896
	jr nz,_label_03_174	; $7899
	ld (hl),$a9		; $789b
	inc l			; $789d
	ld (hl),$01		; $789e
_label_03_174:
	ld a,$13		; $78a0
	call loadGfxRegisterStateIndex		; $78a2
	ld a,SND_LIGHTNING		; $78a5
	call playSound		; $78a7
	xor a			; $78aa
	ld (wTmpcbb5),a		; $78ab
	ld (wTmpcbb6),a		; $78ae
	dec a			; $78b1
	ld (wTmpcbba),a		; $78b2
	call $7b8b		; $78b5
	ld hl,wTmpcbb5		; $78b8
	ld b,$05		; $78bb
	call flashScreen		; $78bd
	ret z			; $78c0
	call clearPaletteFadeVariablesAndRefreshPalettes		; $78c1
	jp $7b8b		; $78c4
	call getFreeInteractionSlot		; $78c7
	jr nz,_label_03_175	; $78ca
	ld (hl),$a9		; $78cc
_label_03_175:
	ld a,SNDCTRL_STOPMUSIC		; $78ce
	call playSound		; $78d0
	call _clearFadingPalettes		; $78d3
	ld a,$bf		; $78d6
	ldh (<hSprPaletteSources),a	; $78d8
	ldh (<hDirtySprPalettes),a	; $78da
	ld a,$04		; $78dc
	jp $7b88		; $78de

;;
; @addr{78e1}
_func_03_78e1:
	call _func_03_7b95		; $78e1
	ret nz			; $78e4

	ld a,TEXTBOXFLAG_ALTPALETTE1		; $78e5
	ld (wTextboxFlags),a		; $78e7
	ld c,$1b		; $78ea
	jp _func_03_7b81		; $78ec

	call $7b9a		; $78ef
	ret nz			; $78f2
	ld b,$10		; $78f3
	call $78fd		; $78f5
	ld a,$1e		; $78f8
	jp $7b88		; $78fa
	call fastFadeinFromBlack		; $78fd
	ld a,b			; $7900
	ld (wDirtyFadeSprPalettes),a		; $7901
	ld (wFadeSprPaletteSources),a		; $7904
	xor a			; $7907
	ld (wDirtyFadeBgPalettes),a		; $7908
	ld (wFadeBgPaletteSources),a		; $790b
	ld a,SND_LIGHTTORCH		; $790e
	jp playSound		; $7910
	call $7ba1		; $7913
	ret nz			; $7916
	call fadeinFromBlack		; $7917
	ld a,$af		; $791a
	ld (wDirtyFadeSprPalettes),a		; $791c
	ld (wFadeSprPaletteSources),a		; $791f
	call $7bd0		; $7922
	ld a,MUS_DISASTER		; $7925
	ld (wActiveMusic),a		; $7927
	call playSound		; $792a
	xor a			; $792d
	ld ($cfc6),a		; $792e
	ld a,$1e		; $7931
	jp $7b88		; $7933
	call $7ba1		; $7936
	ret nz			; $7939
	ld c,$29		; $793a
	jp _func_03_7b81		; $793c
	call $7b9a		; $793f
	ret nz			; $7942
	ld c,$1c		; $7943
	jp _func_03_7b81		; $7945
	call $7b9a		; $7948
	ret nz			; $794b
	ld c,$1d		; $794c
	jp _func_03_7b81		; $794e
	call $7b9a		; $7951
	ret nz			; $7954
	ld c,$1e		; $7955
	call _func_03_7b81		; $7957
	ld a,$3c		; $795a
	ld (wTmpcbb5),a		; $795c
	ret			; $795f
	call $7b9a		; $7960
	ret nz			; $7963
	xor a			; $7964
	ld (wMenuDisabled),a		; $7965
	ld hl,@warpDest		; $7968
	call setWarpDestVariables		; $796b
	ld a,$00		; $796e
	ld (wcc50),a		; $7970
	ld a,PALH_0f		; $7973
	jp loadPaletteHeader		; $7975

@warpDest:
	m_HardcodedWarpA ROOM_AGES_4ea, $0c, $87, $83

	call $7983		; $797d
	jp updateStatusBar		; $7980
	ld a,(wTmpcbb3)		; $7983
	rst_jumpTable			; $7986
.dw $79b5
.dw $79d8
.dw $79e6
.dw $79f9
.dw $7a0b
.dw $7a19
.dw $7a2c
.dw $7a37
.dw $7a45
.dw $7a54
.dw $7a6d
.dw $7a8b
.dw $7a9a
.dw $7aa3
.dw $7aac
.dw $7ab8
.dw $7aca
.dw $7adf
.dw $7af6
.dw $7aff
.dw $7b08
.dw $7b1b
.dw $7b30

	ld a,(wPaletteThread_mode)		; $79b5
	or a			; $79b8
	ret nz			; $79b9
	ld a,$01		; $79ba
	ld (wLoadedTreeGfxIndex),a		; $79bc
	ld bc,$0149		; $79bf
	call disableLcdAndLoadRoom		; $79c2
	ld a,$02		; $79c5
	call loadGfxRegisterStateIndex		; $79c7
	call restartSound		; $79ca
	call $7c2a		; $79cd
	call fadeinFromWhite		; $79d0
	ld a,$3c		; $79d3
	jp $7b88		; $79d5
	call $7ba1		; $79d8
	ret nz			; $79db
	ld hl,$cfc0		; $79dc
	set 0,(hl)		; $79df
	ld a,$01		; $79e1
	jp $7b88		; $79e3
	ld hl,$cfc0		; $79e6
	bit 1,(hl)		; $79e9
	ret z			; $79eb
	call _func_03_7b95		; $79ec
	ret nz			; $79ef
	xor a			; $79f0
	call $7c68		; $79f1
	ld a,$1e		; $79f4
	jp $7b88		; $79f6
	call _func_03_7b95		; $79f9
	ret nz			; $79fc
	xor a			; $79fd
	call $7c83		; $79fe
	ld hl,$cfc0		; $7a01
	set 2,(hl)		; $7a04
	ld a,$1e		; $7a06
	jp $7b88		; $7a08
	call _func_03_7b95		; $7a0b
	ret nz			; $7a0e
	ld a,$01		; $7a0f
	call $7c68		; $7a11
	ld a,$1e		; $7a14
	jp $7b88		; $7a16
	call _func_03_7b95		; $7a19
	ret nz			; $7a1c
	ld a,$01		; $7a1d
	call $7c83		; $7a1f
	ld hl,$cfc0		; $7a22
	set 3,(hl)		; $7a25
	ld a,$1e		; $7a27
	jp $7b88		; $7a29
	ld hl,$cfc0		; $7a2c
	bit 4,(hl)		; $7a2f
	ret z			; $7a31
	ld a,$1e		; $7a32
	jp $7b88		; $7a34
	call _func_03_7b95		; $7a37
	ret nz			; $7a3a
	ld hl,$cfc0		; $7a3b
	set 5,(hl)		; $7a3e
	ld a,$28		; $7a40
	jp $7b88		; $7a42
	call _func_03_7b95		; $7a45
	ret nz			; $7a48
	ld c,$1f		; $7a49
	call _func_03_7b81		; $7a4b
	ld a,$5a		; $7a4e
	ld (wTmpcbb5),a		; $7a50
	ret			; $7a53
	call $7b9a		; $7a54
	jr z,_label_03_176	; $7a57
	ld a,$3c		; $7a59
	cp (hl)			; $7a5b
	ret nz			; $7a5c
	ld hl,$cfc0		; $7a5d
	set 6,(hl)		; $7a60
	ret			; $7a62
_label_03_176:
	ld hl,$cfc0		; $7a63
	set 7,(hl)		; $7a66
	ld a,$3c		; $7a68
	jp $7b88		; $7a6a
	call _func_03_7b95		; $7a6d
	ret nz			; $7a70
	call $7c1f		; $7a71
	call $7beb		; $7a74
	ld a,MUS_DISASTER		; $7a77
	ld (wActiveMusic),a		; $7a79
	call playSound		; $7a7c
	xor a			; $7a7f
	ld ($cfc0),a		; $7a80
	ld ($cfc6),a		; $7a83
	ld a,$1e		; $7a86
	jp $7b88		; $7a88
	ld a,($cfc0)		; $7a8b
	bit 0,a			; $7a8e
	ret z			; $7a90
	call _func_03_7b95		; $7a91
	ret nz			; $7a94
	ld c,$20		; $7a95
	jp _func_03_7b81		; $7a97
	call $7b9a		; $7a9a
	ret nz			; $7a9d
	ld c,$21		; $7a9e
	jp _func_03_7b81		; $7aa0
	call $7b9a		; $7aa3
	ret nz			; $7aa6
	ld c,$22		; $7aa7
	jp _func_03_7b81		; $7aa9
	call $7b9a		; $7aac
	ret nz			; $7aaf
	ld hl,$cfc0		; $7ab0
	res 0,(hl)		; $7ab3
	jp $7b8b		; $7ab5
	ld a,($cfc0)		; $7ab8
	bit 0,a			; $7abb
	ret z			; $7abd
	ld a,SND_LIGHTNING		; $7abe
	call playSound		; $7ac0
	xor a			; $7ac3
	ld (wTmpcbb4),a		; $7ac4
	call $7b8b		; $7ac7
	call $7b48		; $7aca
	ret nz			; $7acd
	call clearDynamicInteractions		; $7ace
	ld hl,$cfc0		; $7ad1
	res 0,(hl)		; $7ad4
	xor a			; $7ad6
	ld ($cfc6),a		; $7ad7
	ld a,$04		; $7ada
	jp $7b88		; $7adc
	call _func_03_7b95		; $7adf
	ret nz			; $7ae2
	call $7c1f		; $7ae3
	call $7bf6		; $7ae6
	call $7c2f		; $7ae9
	ld a,$04		; $7aec
	call fadeinFromWhiteWithDelay		; $7aee
	ld a,$1e		; $7af1
	jp $7b88		; $7af3
	call $7ba1		; $7af6
	ret nz			; $7af9
	ld c,$23		; $7afa
	jp _func_03_7b81		; $7afc
	call $7b9a		; $7aff
	ret nz			; $7b02
	ld c,$24		; $7b03
	jp _func_03_7b81		; $7b05
	call $7b9a		; $7b08
	ret nz			; $7b0b
	ld a,SND_BEAM2		; $7b0c
	call playSound		; $7b0e
	ld hl,$cfc0		; $7b11
	set 0,(hl)		; $7b14
	ld a,$5a		; $7b16
	jp $7b88		; $7b18
	call _func_03_7b95		; $7b1b
	ret nz			; $7b1e
	dec a			; $7b1f
	ld (wTmpcbba),a		; $7b20
	ld a,SND_LIGHTNING		; $7b23
	call playSound		; $7b25
	ld a,SNDCTRL_STOPMUSIC		; $7b28
	call playSound		; $7b2a
	jp $7b8b		; $7b2d
	ld hl,wTmpcbb5		; $7b30
	ld b,$02		; $7b33
	call flashScreen		; $7b35
	ret z			; $7b38
	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT		; $7b39
	call setGlobalFlag		; $7b3b
	xor a			; $7b3e
	ld (wMenuDisabled),a		; $7b3f
	ld a,CUTSCENE_FLAME_OF_DESPAIR		; $7b42
	ld (wCutsceneTrigger),a		; $7b44
	ret			; $7b47
	ld a,(wTmpcbb4)		; $7b48
	rst_jumpTable			; $7b4b
.dw $7b58
.dw $7b63
.dw $7b63
.dw $7b72
.dw $7b76
.dw $7b7e

	ld a,$0a		; $7b58
_label_03_177:
	ld (wTmpcbb5),a		; $7b5a
	call clearFadingPalettes		; $7b5d
	jp _func_03_7b90		; $7b60
	call _func_03_7b95		; $7b63
	ret nz			; $7b66
	ld a,$0a		; $7b67
_label_03_178:
	ld (wTmpcbb5),a		; $7b69
	call fastFadeoutToWhite		; $7b6c
	jp _func_03_7b90		; $7b6f
	ld a,$14		; $7b72
	jr _label_03_177		; $7b74
	call _func_03_7b95		; $7b76
	ret nz			; $7b79
	ld a,$1e		; $7b7a
	jr _label_03_178		; $7b7c
	jp $7ba1		; $7b7e

;;
; @param c Low byte of text index
; @addr{7b81}
_func_03_7b81:
	ld b,$28		; $7b81
	call showText		; $7b83
	ld a,$1e		; $7b86
	ld (wTmpcbb5),a		; $7b88
	ld hl,wTmpcbb3		; $7b8b
	inc (hl)		; $7b8e
	ret			; $7b8f

;;
; @addr{7b90}
_func_03_7b90:
	ld hl,wTmpcbb4		; $7b90
	inc (hl)		; $7b93
	ret			; $7b94

;;
; @addr{7b95}
_func_03_7b95:
	ld hl,wTmpcbb5		; $7b95
	dec (hl)		; $7b98
	ret			; $7b99

	ld a,(wTextIsActive)		; $7b9a
	or a			; $7b9d
	ret nz			; $7b9e
	jr _label_03_179		; $7b9f
	ld a,(wPaletteThread_mode)		; $7ba1
	or a			; $7ba4
	ret nz			; $7ba5
_label_03_179:
	ld hl,wTmpcbb5		; $7ba6
	dec (hl)		; $7ba9
	ret			; $7baa
	xor a			; $7bab
	ld bc,$05f1		; $7bac
	call disableLcdAndLoadRoom		; $7baf
	ld a,PALH_ac		; $7bb2
	call loadPaletteHeader		; $7bb4
	ld a,$28		; $7bb7
	ld (wGfxRegs1.SCX),a		; $7bb9
	ld (wGfxRegs2.SCX),a		; $7bbc
	ldh (<hCameraX),a	; $7bbf
	xor a			; $7bc1
	ldh (<hCameraY),a	; $7bc2
	ld a,$00		; $7bc4
	ld (wScrollMode),a		; $7bc6
	ld a,$10		; $7bc9
	ldh (<hOamTail),a	; $7bcb
	jp clearWramBank1		; $7bcd
	ld bc,$7be5		; $7bd0
	call $7bd9		; $7bd3
	ld bc,$7be8		; $7bd6
	call getFreeInteractionSlot		; $7bd9
	ret nz			; $7bdc
	ld (hl),$b0		; $7bdd
	inc l			; $7bdf
	ld a,(bc)		; $7be0
	inc bc			; $7be1
	ld (hl),a		; $7be2
	jr _label_03_181		; $7be3
	ld (bc),a		; $7be5
	ld c,h			; $7be6
	adc (hl)		; $7be7
	inc bc			; $7be8
	ld c,h			; $7be9
	ld h,d			; $7bea
	ld bc,$7c13		; $7beb
	call $7bff		; $7bee
	ld bc,$7c16		; $7bf1
	jr _label_03_180		; $7bf4
	ld bc,$7c19		; $7bf6
	call $7bff		; $7bf9
	ld bc,$7c1c		; $7bfc
_label_03_180:
	call getFreeInteractionSlot		; $7bff
	ret nz			; $7c02
	ld (hl),$bc		; $7c03
	inc l			; $7c05
	ld a,(bc)		; $7c06
	inc bc			; $7c07
	ld (hl),a		; $7c08
_label_03_181:
	ld l,$4b		; $7c09
	ld a,(bc)		; $7c0b
	inc bc			; $7c0c
	ld (hl),a		; $7c0d
	ld l,$4d		; $7c0e
	ld a,(bc)		; $7c10
	ld (hl),a		; $7c11
	ret			; $7c12
	nop			; $7c13
	nop			; $7c14
	ld b,b			; $7c15
	ld bc,$6000		; $7c16
	ld (bc),a		; $7c19
	ld d,b			; $7c1a
	ld l,b			; $7c1b
	inc bc			; $7c1c
	ld d,b			; $7c1d
	jr c,_label_03_183	; $7c1e
	ld bc,$18ea		; $7c20
	call z,$bc3e		; $7c23
	ld (wInteractionIDToLoadExtraGfx),a		; $7c26
	ret			; $7c29
	ld bc,$7c4e		; $7c2a
	jr _label_03_182		; $7c2d
	ld bc,$7c5d		; $7c2f
_label_03_182:
	ld a,(bc)		; $7c32
	or a			; $7c33
	ret z			; $7c34
	call getFreeInteractionSlot		; $7c35
	ret nz			; $7c38
	ld a,(bc)		; $7c39
	ldi (hl),a		; $7c3a
	inc bc			; $7c3b
	ld a,(bc)		; $7c3c
	ldi (hl),a		; $7c3d
	inc bc			; $7c3e
	ld a,(bc)		; $7c3f
	ldi (hl),a		; $7c40
	inc bc			; $7c41
	ld l,$4b		; $7c42
	ld a,(bc)		; $7c44
	ld (hl),a		; $7c45
	inc bc			; $7c46
	ld l,$4d		; $7c47
	ld a,(bc)		; $7c49
	ld (hl),a		; $7c4a
	inc bc			; $7c4b
	jr _label_03_182		; $7c4c
	inc a			; $7c4e
	rrca			; $7c4f
	inc bc			; $7c50
	ld c,b			; $7c51
	ld c,b			; $7c52
	ld sp,$0308		; $7c53
	ld c,b			; $7c56
	ld e,b			; $7c57
	xor l			; $7c58
	add hl,bc		; $7c59
	ld (bc),a		; $7c5a
	jr c,$50		; $7c5b
	ldd a,(hl)		; $7c5d
_label_03_183:
	ld c,$01		; $7c5e
	ld c,b			; $7c60
	jr c,_label_03_184	; $7c61
	rlca			; $7c63
	nop			; $7c64
	jr z,$78		; $7c65
	nop			; $7c67
	ld bc,$7c7f		; $7c68
	call addDoubleIndexToBc		; $7c6b
	call getFreePartSlot		; $7c6e
	ret nz			; $7c71
	ld (hl),$27		; $7c72
	inc l			; $7c74
	inc (hl)		; $7c75
	ld l,$cb		; $7c76
	ld a,(bc)		; $7c78
	ldi (hl),a		; $7c79
	inc bc			; $7c7a
	inc l			; $7c7b
	ld a,(bc)		; $7c7c
	ld (hl),a		; $7c7d
	ret			; $7c7e
	ld e,b			; $7c7f
	jr c,$48		; $7c80
	ld l,b			; $7c82
	ld bc,$7c7f		; $7c83
	call addDoubleIndexToBc		; $7c86
	call getFreeInteractionSlot		; $7c89
	ret nz			; $7c8c
	ld (hl),$6b		; $7c8d
	inc l			; $7c8f
	ld (hl),$16		; $7c90
	ld l,$46		; $7c92
	ld (hl),$78		; $7c94
	jp $7c09		; $7c96
	ld hl,wCutsceneState		; $7c99
	inc (hl)		; $7c9c
	ret			; $7c9d
	ld hl,wTmpcbb3		; $7c9e
	inc (hl)		; $7ca1
	ret			; $7ca2
	ld hl,wTmpcbb4		; $7ca3
_label_03_184:
	dec (hl)		; $7ca6
	ret			; $7ca7
	call disableLcd		; $7ca8
	call loadScreenMusicAndSetRoomPack		; $7cab
	call loadTilesetData		; $7cae
	call loadTilesetGraphics		; $7cb1
	jp func_131f		; $7cb4
;;
; @addr{7cb7}
func_03_7cb7:
	ld a,(wCutsceneState)		; $7cb7
	rst_jumpTable			; $7cba
.dw $7cc9
.dw $7d14
.dw $7d3d
.dw $7d6b
.dw $7d95
.dw $7ddf
.dw $7e1f

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
	call $7c99		; $7ced
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
	ld a,(wTmpcbb5)		; $7d14
	cp $04			; $7d17
	ret nz			; $7d19
	call $7ca3		; $7d1a
	jr z,_label_03_185	; $7d1d
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
_label_03_185:
	ld (hl),$10		; $7d33
	call $7c99		; $7d35
	ld a,$04		; $7d38
	jp fadeoutToWhiteWithDelay		; $7d3a
	ld a,(wPaletteThread_mode)		; $7d3d
	or a			; $7d40
	ret nz			; $7d41
	ld a,SNDCTRL_STOPMUSIC		; $7d42
	call playSound		; $7d44
	call $7c99		; $7d47
	ld a,$f3		; $7d4a
	ld (wActiveRoom),a		; $7d4c
	call $7ca8		; $7d4f
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
	ld a,$00		; $7d6b
	ld (wScrollMode),a		; $7d6d
	ld a,$f8		; $7d70
	ld (w1Link.yh),a		; $7d72
	ld a,$05		; $7d75
	ld (wTmpcbb5),a		; $7d77
	ld a,(wPaletteThread_mode)		; $7d7a
	or a			; $7d7d
	ret nz			; $7d7e
	call $7ca3		; $7d7f
	ret nz			; $7d82
	ld a,$0b		; $7d83
	ld (wLinkForceState),a		; $7d85
	ld a,$60		; $7d88
	ld (wLinkStateParameter),a		; $7d8a
	ld a,$10		; $7d8d
	ld ($d009),a		; $7d8f
	jp $7c99		; $7d92
	ld a,(wTmpcbb5)		; $7d95
	cp $06			; $7d98
	ret nz			; $7d9a
	call $7e40		; $7d9b
	ld a,(wScreenShakeCounterY)		; $7d9e
	dec a			; $7da1
	jr z,_label_03_188	; $7da2
	and $1f			; $7da4
	ret nz			; $7da6
	ld a,(w1Link.direction)		; $7da7
	ld c,a			; $7daa
	rra			; $7dab
	xor c			; $7dac
	bit 0,a			; $7dad
	ld a,c			; $7daf
	jr z,_label_03_186	; $7db0
	xor $01			; $7db2
	jr _label_03_187		; $7db4
_label_03_186:
	xor $02			; $7db6
_label_03_187:
	ld (w1Link.direction),a		; $7db8
	ret			; $7dbb
_label_03_188:
	call getFreeInteractionSlot		; $7dbc
	ret nz			; $7dbf
	ld (hl),$9f		; $7dc0
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
	call $7c99		; $7ddc
	call $7e40		; $7ddf
	call $7ca3		; $7de2
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
	ld (hl),$92		; $7e04
	ld l,$43		; $7e06
	ld (hl),$01		; $7e08
	call getFreeInteractionSlot		; $7e0a
	ld (hl),$2c		; $7e0d
	ld l,$4b		; $7e0f
	ld a,(w1Link.yh)		; $7e11
	add $10			; $7e14
	ldi (hl),a		; $7e16
	ld a,(w1Link.xh)		; $7e17
	inc l			; $7e1a
	ld (hl),a		; $7e1b
	jp $7c99		; $7e1c
	call $7e40		; $7e1f
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

	ld a,(wScreenShakeCounterY)		; $7e40
	and $0f			; $7e43
	ld a,SND_RUMBLE		; $7e45
	call z,playSound		; $7e47
	ld a,(wScreenShakeCounterY)		; $7e4a
	or a			; $7e4d
	ld a,$ff		; $7e4e
	jp z,setScreenShakeCounter		; $7e50
	ret			; $7e53
