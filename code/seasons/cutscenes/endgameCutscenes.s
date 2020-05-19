;;
; CUTSCENE_S_DIN_CRYSTAL_DESCENDING
_endgameCutsceneHandler_09:
	ld de,$cbc1		; $551f
	ld a,(de)		; $5522
	rst_jumpTable			; $5523
	.dw _endgameCutsceneHandler_09_stage0
	.dw _endgameCutsceneHandler_09_stage1

_endgameCutsceneHandler_09_stage0:
	call updateStatusBar		; $5528
	call _endgameCutsceneHandler_09_stage0_body		; $552b
	call updateAllObjects		; $552e
	jp checkEnemyAndPartCollisionsIfTextInactive		; $5531

_endgameCutsceneHandler_09_stage0_body:
	ld de,$cbc2		; $5534
	ld a,(de)		; $5537
	rst_jumpTable			; $5538
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
	ld a,(wPaletteThread_mode)		; $5589
	or a			; $558c
	ret nz			; $558d
	ld b,$20		; $558e
	ld hl,$cfc0		; $5590
	call clearMemory		; $5593
	call incCbc2		; $5596
	xor a			; $5599
	ld bc,$0790		; $559a
	call disableLcdAndLoadRoom_body		; $559d
	ld a,$0d		; $55a0
	call playSound		; $55a2
	call clearAllParentItems		; $55a5
	call dropLinkHeldItem		; $55a8
	ld c,$00		; $55ab
@state0Func0:
	call getFreeInteractionSlot		; $55ad
	jr nz,+			; $55b0
	ld a,INTERACID_S_DIN		; $55b2
	ld (wInteractionIDToLoadExtraGfx),a		; $55b4
	ldi (hl),a		; $55b7
	ld (hl),c		; $55b8
	ld (wLoadedTreeGfxIndex),a		; $55b9
+
	ld a,c			; $55bc
	ld hl,$d000		; $55bd
	ld (hl),$03		; $55c0
	ld de,@state0Table_03_55f3		; $55c2
	call addDoubleIndexToDe		; $55c5
	ld a,(de)		; $55c8
	inc de			; $55c9
	ld l,$0b		; $55ca
	ldi (hl),a		; $55cc
	inc l			; $55cd
	ld a,(de)		; $55ce
	ldi (hl),a		; $55cf
	ld l,$08		; $55d0
	ld (hl),$03		; $55d2
	ld a,c			; $55d4
	ld bc,$0050		; $55d5
	or a			; $55d8
	jr z,+			; $55d9
	ld bc,$3050		; $55db
+
	ld hl,hCameraY		; $55de
	ld (hl),b		; $55e1
	ld hl,hCameraX		; $55e2
	ld (hl),c		; $55e5
	ld a,$80		; $55e6
	ld (wDisabledObjects),a		; $55e8
	ld a,$02		; $55eb
	call loadGfxRegisterStateIndex		; $55ed
	jp fadeinFromWhiteToRoom		; $55f0
@state0Table_03_55f3:
	.db $99 $c8
	.db $99 $b8

@state1:
	ld hl,wccd8		; $55f7
	ld (hl),$ff		; $55fa
	ld a,(wPaletteThread_mode)		; $55fc
	or a			; $55ff
	ret nz			; $5600
	ld a,($cfdf)		; $5601
	or a			; $5604
	ret z			; $5605
	call incCbc2		; $5606
	ld bc,TX_3d00		; $5609
	jp showText		; $560c

@state2:
	call retIfTextIsActive		; $560f
	call incCbc2		; $5612
	jp fastFadeoutToWhite		; $5615

@state3:
	ld a,(wPaletteThread_mode)		; $5618
	or a			; $561b
	ret nz			; $561c
	call incCbc2		; $561d
	ld hl,$cbb3		; $5620
	ld (hl),$3c		; $5623
	inc l			; $5625
	ld (hl),$00		; $5626
	jr @state7Func0		; $5628

@state4:
	call seasonsFunc_03_6462		; $562a
	ret nz			; $562d
	call incCbc2		; $562e
	ld a,SND_RESTORE		; $5631
	call playSound		; $5633
	jp fadeoutToWhite		; $5636

@state5:
	ld a,(wPaletteThread_mode)		; $5639
	or a			; $563c
	ret nz			; $563d
	call incCbc2		; $563e
	ld a,$00		; $5641
	call seasonsFunc_03_644c		; $5643
	ld hl,$cbb3		; $5646
	ld (hl),$3c		; $5649
	jp fadeinFromWhite		; $564b

@state6:
	call seasonsFunc_03_6462		; $564e
	ret nz			; $5651
	call incCbc2		; $5652
	jp fastFadeoutToWhite		; $5655

@state7:
	ld a,(wPaletteThread_mode)		; $5658
	or a			; $565b
	ret nz			; $565c
@state7Func0:
	call clearDynamicInteractions		; $565d
	ld hl,$cbb3		; $5660
	ld (hl),$3c		; $5663
	inc l			; $5665
	ld a,(hl)		; $5666
	ld hl,@state7Table0		; $5667
	rst_addDoubleIndex			; $566a
	ld c,(hl)		; $566b
	inc hl			; $566c
	ld b,(hl)		; $566d
	ld a,$03		; $566e
	call disableLcdAndLoadRoom_body		; $5670
	call fastFadeinFromWhite		; $5673
	ld hl,$cbb4		; $5676
	ld a,(hl)		; $5679
	ld b,a			; $567a
	inc (hl)		; $567b
	cp $04			; $567c
	jr nc,+			; $567e
	ld c,$04		; $5680
	push bc			; $5682
	ld a,$02		; $5683
	call loadGfxRegisterStateIndex		; $5685
	call resetCamera		; $5688
	pop bc			; $568b
	jr ++			; $568c
+
	ld hl,$cbb3		; $568e
	ld (hl),$3c		; $5691
	push bc			; $5693
	ld c,$01		; $5694
	call @state0Func0		; $5696
	pop bc			; $5699
	ld c,$08		; $569a
	call checkIsLinkedGame		; $569c
	ld b,$ff		; $569f
	jr z,++			; $56a1
	ld c,$0d		; $56a3
++
	ld hl,$cbc2		; $56a5
	ld (hl),c		; $56a8
	jp seasonsFunc_03_6405		; $56a9
@state7Table0:
	.db $e7 $00
	.db $54 $00
	.db $d1 $00
	.db $5e $00
	.db $90 $07

@state8:
	ld e,$3c		; $56b6
	ld bc,TX_3d01		; $56b8
	jr @stateDFunc0		; $56bb

@state9:
	call seasonsFunc_03_645a		; $56bd
	ret nz			; $56c0
	call incCbc2		; $56c1
	jp fadeoutToWhite		; $56c4

@stateA:
	ld a,(wPaletteThread_mode)		; $56c7
	or a			; $56ca
	ret nz			; $56cb
	call incCbc2		; $56cc
	ld hl,$cbb3		; $56cf
	ld (hl),$3c		; $56d2
	ld a,$ff		; $56d4
	ld (wTilesetAnimation),a		; $56d6
	call disableLcd		; $56d9
	ld a,$2b		; $56dc
	call loadGfxHeader		; $56de
	ld a,$9d		; $56e1
	call loadPaletteHeader		; $56e3
	call _cutscene_clearObjects		; $56e6
	call _endgameCutsceneHandler_09_stage1_body@seasonsFunc_03_5ab0		; $56e9
	ld a,$04		; $56ec
	call loadGfxRegisterStateIndex		; $56ee
	jp fadeinFromWhite		; $56f1

@stateB:
	call _endgameCutsceneHandler_09_stage1_body@seasonsFunc_03_5ab0		; $56f4
	call seasonsFunc_03_6462		; $56f7
	ret nz			; $56fa
	call incCbc2		; $56fb
	ld hl,wMenuDisabled		; $56fe
	ld (hl),$01		; $5701
	ld hl,$cbb3		; $5703
	ld (hl),$3c		; $5706
	ld bc,TX_3d02		; $5708
@stateBFunc0:
	ld a,$01		; $570b
	ld (wTextboxFlags),a		; $570d
	jp showText		; $5710

@stateC:
	call _endgameCutsceneHandler_09_stage1_body@seasonsFunc_03_5ab0		; $5713
	call seasonsFunc_03_645a		; $5716
	ret nz			; $5719
	call seasonsFunc_03_646a		; $571a
	ld a,$01		; $571d
	ld ($cbc1),a		; $571f
	call disableActiveRing		; $5722
	jp fadeoutToWhite		; $5725

@stateD:
	ld e,$3c		; $5728
	ld bc,TX_4f00		; $572a
@stateDFunc0:
	call seasonsFunc_03_6462		; $572d
	ret nz			; $5730
	call incCbc2		; $5731
	ld a,e			; $5734
	ld ($cbb3),a		; $5735
	jp showText		; $5738

@stateE:
	call seasonsFunc_03_645a		; $573b
	ret nz			; $573e
	xor a			; $573f
	ld ($cbb3),a		; $5740
	dec a			; $5743
	ld ($cbba),a		; $5744
	ld a,SND_LIGHTNING		; $5747
	call playSound		; $5749
	ld a,SNDCTRL_STOPMUSIC		; $574c
	call playSound		; $574e
	jp incCbc2		; $5751

@stateF:
	ld hl,$cbb3		; $5754
	ld b,$02		; $5757
	call flashScreen		; $5759
	ret z			; $575c
	call incCbc2		; $575d
	xor a			; $5760
	ld bc,$059a		; $5761
	call disableLcdAndLoadRoom_body		; $5764
	ld a,$ac		; $5767
	call loadPaletteHeader		; $5769
	call hideStatusBar		; $576c
	call _clearFadingPalettes		; $576f
	ld b,$06		; $5772
-
	call getFreeInteractionSlot		; $5774
	jr nz,+			; $5777
	ld (hl),INTERACID_TWINROVA_FLAME		; $5779
	inc l			; $577b
	dec b			; $577c
	ld (hl),b		; $577d
	jr nz,-			; $577e
+
	ld hl,$cbb3		; $5780
	ld (hl),$1e		; $5783
	ld a,$13		; $5785
	call loadGfxRegisterStateIndex		; $5787
	ld hl,wGfxRegs1.SCY		; $578a
	ldi a,(hl)		; $578d
	ldh (<hCameraY),a	; $578e
	ld a,(hl)		; $5790
	ldh (<hCameraX),a	; $5791
	ld a,$00		; $5793
	ld (wScrollMode),a		; $5795
	ret			; $5798

@state10:
	call decCbb3		; $5799
	ret nz			; $579c
	call incCbc2		; $579d
	ld hl,$cbb3		; $57a0
	ld (hl),$28		; $57a3
	ld a,$04		; $57a5
	ld (wTextboxFlags),a		; $57a7
	ld bc,TX_4f01		; $57aa
	jp showText		; $57ad

@state11:
	call seasonsFunc_03_645a		; $57b0
	ret nz			; $57b3
	call incCbc2		; $57b4
	ld a,$20		; $57b7
	ld hl,$cbb3		; $57b9
	ldi (hl),a		; $57bc
	xor a			; $57bd
	ld (hl),a		; $57be
	ret			; $57bf

@state12:
	call seasonsFunc_03_6462		; $57c0
	ret nz			; $57c3
	ld hl,$cbb3		; $57c4
	ld (hl),$20		; $57c7
	inc hl			; $57c9
	ld a,(hl)		; $57ca
	cp $03			; $57cb
	jr nc,+			; $57cd
	ld b,a			; $57cf
	push hl			; $57d0
	ld a,SND_LIGHTTORCH		; $57d1
	call playSound		; $57d3
	pop hl			; $57d6
	ld a,b			; $57d7
+
	inc (hl)		; $57d8
	ld hl,@state12Table0		; $57d9
	rst_addAToHl			; $57dc
	ld a,(hl)		; $57dd
	or a			; $57de
	ld b,a			; $57df
	jr nz,+			; $57e0
	call fadeinFromBlack		; $57e2
	ld a,$01		; $57e5
	ld (wDirtyFadeSprPalettes),a		; $57e7
	ld (wFadeSprPaletteSources),a		; $57ea
	ld hl,$cbb3		; $57ed
	ld (hl),$3c		; $57f0
	ld a,MUS_DISASTER		; $57f2
	call playSound		; $57f4
	jp incCbc2		; $57f7
+
	call fastFadeinFromBlack		; $57fa
	ld a,b			; $57fd
	ld (wDirtyFadeSprPalettes),a		; $57fe
	ld (wFadeSprPaletteSources),a		; $5801
	xor a			; $5804
	ld (wDirtyFadeBgPalettes),a		; $5805
	ld (wFadeBgPaletteSources),a		; $5808
	ret			; $580b
@state12Table0:
	.db $10 $40
	.db $80 $28
	.db $06 $00

@state13:
	ld e,$28		; $5812
	ld bc,TX_4f02		; $5814
	call @state13Func0		; $5817
	jp @stateDFunc0		; $581a
@state13Func0:
	ld a,$08		; $581d
	ld (wTextboxFlags),a		; $581f
	ld a,$03		; $5822
	ld (wTextboxPosition),a		; $5824
	ret			; $5827

@state14:
	ld e,$28		; $5828
	ld bc,TX_4f03		; $582a
-
	call seasonsFunc_03_645a		; $582d
	ret nz			; $5830
	call incCbc2		; $5831
	ld hl,$cbb3		; $5834
	ld (hl),e		; $5837
	call @state13Func0		; $5838
	jp showText		; $583b

@state15:
	ld e,$3c		; $583e
	ld bc,TX_4f04		; $5840
	jr -		; $5843

@state16:
	ld e,$b4		; $5845
@state16Func0:
	call seasonsFunc_03_645a		; $5847
	ret nz			; $584a
	call incCbc2		; $584b
	ld hl,$cbb3		; $584e
	ld (hl),e		; $5851
	ret			; $5852

@state17:
	ld hl,wGfxRegs1.SCY		; $5853
	ldh a,(<hCameraY)	; $5856
	ldi (hl),a		; $5858
	ldh a,(<hCameraX)	; $5859
	ldi (hl),a		; $585b
	ld hl,@state17Table0		; $585c
	ld de,wGfxRegs1.SCY		; $585f
	call seasonsFunc_03_79cd		; $5862
	inc de			; $5865
	call seasonsFunc_03_79cd		; $5866
	call seasonsFunc_03_5d00		; $5869
	call decCbb3		; $586c
	ret nz			; $586f
	dec a			; $5870
	ld ($cbba),a		; $5871
	ld a,SND_LIGHTNING		; $5874
	call playSound		; $5876
	ld a,SNDCTRL_STOPMUSIC		; $5879
	call playSound		; $587b
	jp incCbc2		; $587e
@state17Table0:
	.db $ff $01
	.db $00 $01
	.db $00 $00
	.db $ff $00

@state18:
	ld hl,$cbb3		; $5889
	ld b,$01		; $588c
	call flashScreen		; $588e
	ret z			; $5891
	call incCbc2		; $5892
	ld hl,$cbb3		; $5895
	ld (hl),$3c		; $5898
	call clearDynamicInteractions		; $589a
	call clearOam		; $589d
	call showStatusBar		; $58a0
	xor a			; $58a3
	ld bc,ROOM_SEASONS_790		; $58a4
	call disableLcdAndLoadRoom_body		; $58a7
	ld c,$01		; $58aa
	jp @state0Func0		; $58ac

@state19:
	call decCbb3		; $58af
	ret nz			; $58b2
	call incCbc2		; $58b3
	ld hl,$cbb3		; $58b6
	ld (hl),$1e		; $58b9
	ld bc,TX_3d17		; $58bb
	jp showText		; $58be

@state1A:
	call seasonsFunc_03_645a		; $58c1
	ret nz			; $58c4
	call incCbc2		; $58c5
	ld hl,$cbb3		; $58c8
	ld (hl),$1e		; $58cb
	ld bc,TX_4f09		; $58cd
	jp showText		; $58d0

@state1B:
	call seasonsFunc_03_645a		; $58d3
	ret nz			; $58d6
	call incCbc2		; $58d7
	ld c,$40		; $58da
	ld a,TREASURE_HEART_REFILL		; $58dc
	call giveTreasure		; $58de
	ld a,$08		; $58e1
	call setLinkIDOverride		; $58e3
	ld l,$02		; $58e6
	ld (hl),$07		; $58e8
	ld hl,$cbb3		; $58ea
	ld (hl),$5a		; $58ed
	ld a,MUS_PRECREDITS		; $58ef
	jp playSound		; $58f1

@state1C:
	call decCbb3		; $58f4
	ret nz			; $58f7
	call incCbc2		; $58f8
	ld hl,$cbb3		; $58fb
	ld (hl),$b4		; $58fe
	ld bc,$90bd		; $5900
	ld a,$ff		; $5903
	jp createEnergySwirlGoingOut		; $5905

@state1D:
	call decCbb3		; $5908
	ret nz			; $590b
	call incCbc2		; $590c
	ld hl,$cbb3		; $590f
	ld (hl),$3c		; $5912
	jp fadeoutToWhite		; $5914

@state1E:
	call seasonsFunc_03_6462		; $5917
	ret nz			; $591a
	call incCbc2		; $591b
	call disableLcd		; $591e
	call clearOam		; $5921
	call clearDynamicInteractions		; $5924
	call refreshObjectGfx		; $5927
	call hideStatusBar		; $592a
	ld a,$02		; $592d
	ld ($ff00+R_SVBK),a	; $592f
	ld hl,w2TilesetBgPalettes+$10		; $5931
	ld b,$08		; $5934
	ld a,$ff		; $5936
	call fillMemory		; $5938
	xor a			; $593b
	ld ($ff00+R_SVBK),a	; $593c
	ld a,$07		; $593e
	ldh (<hDirtyBgPalettes),a	; $5940
	ld b,$02		; $5942
-
	call getFreeInteractionSlot		; $5944
	jr nz,+			; $5947
	ld (hl),INTERACID_TWINROVA_FLAME		; $5949
	inc l			; $594b
	ld a,$05		; $594c
	add b			; $594e
	ld (hl),a		; $594f
	dec b			; $5950
	jr nz,-			; $5951
+
	ld a,$02		; $5953
	ld (wOpenedMenuType),a		; $5955
	call seasonsFunc_03_7a6b		; $5958
	ld a,$02		; $595b
	call seasonsFunc_03_7a88		; $595d
	ld hl,$cbb3		; $5960
	ld (hl),$1e		; $5963
	ld a,$04		; $5965
	call loadGfxRegisterStateIndex		; $5967
	ld a,$10		; $596a
	ldh (<hCameraY),a	; $596c
	ld (wDeleteEnergyBeads),a		; $596e
	xor a			; $5971
	ldh (<hCameraX),a	; $5972
	ld a,$00		; $5974
	ld (wScrollMode),a		; $5976
	ld bc,TX_4f05		; $5979
	jp showText		; $597c

@state1F:
	call seasonsFunc_03_645a		; $597f
	ret nz			; $5982
	call incCbc2		; $5983
	ld b,$02		; $5986
@state1FFunc0:
	call fadeinFromWhite		; $5988
	ld a,b			; $598b
	ld (wDirtyFadeSprPalettes),a		; $598c
	ld (wFadeSprPaletteSources),a		; $598f
	xor a			; $5992
	ld (wDirtyFadeBgPalettes),a		; $5993
	ld (wFadeBgPaletteSources),a		; $5996
	ld hl,$cbb3		; $5999
	ld (hl),$3c		; $599c
	ret			; $599e

@state20:
	ld e,$1e		; $599f
	ld bc,TX_4f06		; $59a1
	jp @stateDFunc0		; $59a4

@state21:
	call seasonsFunc_03_645a		; $59a7
	ret nz			; $59aa
	call incCbc2		; $59ab
	ld b,$14		; $59ae
	jp @state1FFunc0		; $59b0

@state22:
	ld e,$1e		; $59b3
	ld bc,TX_4f07		; $59b5
	jp @stateDFunc0		; $59b8

@state23:
	ld e,$3c		; $59bb
	jp @state16Func0		; $59bd

@state24:
	call decCbb3		; $59c0
	ret nz			; $59c3
	call incCbc2		; $59c4
	ld hl,$cbb3		; $59c7
	ld (hl),$f0		; $59ca
	ld a,$ff		; $59cc
	ld bc,$4850		; $59ce
	jp createEnergySwirlGoingOut		; $59d1

@state25:
	call decCbb3		; $59d4
	ret nz			; $59d7
	ld hl,$cbb3		; $59d8
	ld (hl),$5a		; $59db
	call fadeoutToWhite		; $59dd
	ld a,$fc		; $59e0
	ld (wDirtyFadeBgPalettes),a		; $59e2
	ld (wFadeBgPaletteSources),a		; $59e5
	jp incCbc2		; $59e8

@state26:
	call seasonsFunc_03_6462		; $59eb
	ret nz			; $59ee
	call incCbc2		; $59ef
	call clearDynamicInteractions		; $59f2
	call clearParts		; $59f5
	call clearOam		; $59f8
	ld hl,$cbb3		; $59fb
	ld (hl),$3c		; $59fe
	ld bc,TX_4f08		; $5a00
	jp showTextNonExitable		; $5a03

@state27:
	ld a,(wTextIsActive)		; $5a06
	rlca			; $5a09
	ret nc			; $5a0a
	call decCbb3		; $5a0b
	ret nz			; $5a0e
	call showStatusBar		; $5a0f
	xor a			; $5a12
	ld (wOpenedMenuType),a		; $5a13
	dec a			; $5a16
	ld (wActiveMusic),a		; $5a17
	ld a,SNDCTRL_STOPMUSIC		; $5a1a
	call playSound		; $5a1c
	ld hl,wWarpDestGroup		; $5a1f
	ld a,$80|>ROOM_SEASONS_59d		; $5a22
	ldi (hl),a		; $5a24
	ld a,<ROOM_SEASONS_59d		; $5a25
	ldi (hl),a		; $5a27
	ld a,$0f		; $5a28
	ldi (hl),a		; $5a2a
	ld a,$57		; $5a2b
	ldi (hl),a		; $5a2d
	ld (hl),$03		; $5a2e
	ret			; $5a30

_endgameCutsceneHandler_09_stage1:
	call _endgameCutsceneHandler_09_stage1_body		; $5a31
	jp updateAllObjects		; $5a34

_endgameCutsceneHandler_09_stage1_body:
	ld de,$cbc2		; $5a37
	ld a,(de)		; $5a3a
	rst_jumpTable			; $5a3b
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
	call @seasonsFunc_03_5ab0		; $5a50
	ld a,(wPaletteThread_mode)		; $5a53
	or a			; $5a56
	ret nz			; $5a57
	call incCbc2		; $5a58
	ld hl,$cbb3		; $5a5b
	ld (hl),$3c		; $5a5e
	call disableLcd		; $5a60
	call clearOam		; $5a63
	ld a,GFXH_2c		; $5a66
	call loadGfxHeader		; $5a68
	ld a,SEASONS_PALH_9e		; $5a6b
	call loadPaletteHeader		; $5a6d
	ld a,$04		; $5a70
	call loadGfxRegisterStateIndex		; $5a72
	ld a,MUS_DISASTER		; $5a75
	call playSound		; $5a77
	jp fadeinFromWhite		; $5a7a

@state1:
	ld a,$01		; $5a7d
	ld (wTextboxFlags),a		; $5a7f
	ld a,$3c		; $5a82
	ld bc,TX_3d03		; $5a84
	jp _endgameCutsceneHandler_09_stage0_body@stateDFunc0		; $5a87

@state2:
	call seasonsFunc_03_645a		; $5a8a
	ret nz			; $5a8d
	call incCbc2		; $5a8e
	ld hl,$cbb5		; $5a91
	ld (hl),$d0		; $5a94
--
	ld hl,seasonsOamData_03_6472		; $5a96
-
	ld b,$30		; $5a99
	ld de,$cbb5		; $5a9b
	ld a,(de)		; $5a9e
	ld c,a			; $5a9f
	jr +			; $5aa0

@seasonsFunc_03_5aa2:
	ld hl,oamData_15_4da3		; $5aa2
	ld e,:oamData_15_4da3		; $5aa5
	ld bc,$3038		; $5aa7
	xor a			; $5aaa
	ldh (<hOamTail),a	; $5aab
	jp addSpritesFromBankToOam_withOffset		; $5aad

@seasonsFunc_03_5ab0:
	ld hl,seasonsOamData_03_65a4		; $5ab0
	ld bc,$3038		; $5ab3
+
	xor a			; $5ab6
	ldh (<hOamTail),a	; $5ab7
	jp addSpritesToOam_withOffset		; $5ab9

@state3:
	ld hl,$cbb5		; $5abc
	inc (hl)		; $5abf
	jr nz,--		; $5ac0
	call clearOam		; $5ac2
	ld a,UNCMP_GFXH_0a		; $5ac5
	call loadUncompressedGfxHeader		; $5ac7
	ld hl,$cbb3		; $5aca
	ld (hl),$1e		; $5acd
	jp incCbc2		; $5acf

@state4:
	call decCbb3		; $5ad2
	ret nz			; $5ad5
	call incCbc2		; $5ad6
	ld hl,$cbb5		; $5ad9
	ld (hl),$d0		; $5adc
@state4Func0:
	ld hl,seasonsOamData_03_650b		; $5ade
	jr -			; $5ae1

@state5:
	call @state4Func0		; $5ae3
	ld hl,$cbb5		; $5ae6
	dec (hl)		; $5ae9
	ld a,(hl)		; $5aea
	sub $a0			; $5aeb
	ret nz			; $5aed
	ld (wScreenOffsetY),a		; $5aee
	ld (wScreenOffsetX),a		; $5af1
	ld a,$1e		; $5af4
	ld ($cbb3),a		; $5af6
	ld (wOpenedMenuType),a		; $5af9
	jp incCbc2		; $5afc

@state6:
	call @state4Func0		; $5aff
	call decCbb3		; $5b02
	ret nz			; $5b05
	ld hl,$cbb3		; $5b06
	ld (hl),$14		; $5b09
	ld bc,TX_3d04		; $5b0b
	call _endgameCutsceneHandler_09_stage0_body@stateBFunc0		; $5b0e
	jp incCbc2		; $5b11

@state7:
	call @state4Func0		; $5b14
	call seasonsFunc_03_645a		; $5b17
	ret nz			; $5b1a
	xor a			; $5b1b
	ld (wOpenedMenuType),a		; $5b1c
	dec a			; $5b1f
	ld ($cbba),a		; $5b20
	ld a,SND_LIGHTNING		; $5b23
	call playSound		; $5b25
	jp incCbc2		; $5b28

@state8:
	call @state4Func0		; $5b2b
	ld hl,$cbb3		; $5b2e
	ld b,$02		; $5b31
	call flashScreen		; $5b33
	ret z			; $5b36
	call incCbc2		; $5b37
	ld hl,$cbb3		; $5b3a
	ld (hl),$1e		; $5b3d
	call disableLcd		; $5b3f
	call clearOam		; $5b42
	xor a			; $5b45
	ld ($ff00+R_VBK),a	; $5b46
	ld hl,$8000		; $5b48
	ld bc,$2000		; $5b4b
	call clearMemoryBc		; $5b4e
	xor a			; $5b51
	ld ($ff00+R_VBK),a	; $5b52
	ld hl,$9c00		; $5b54
	ld bc,$0400		; $5b57
	call clearMemoryBc		; $5b5a
	ld a,$01		; $5b5d
	ld ($ff00+R_VBK),a	; $5b5f
	ld hl,$9c00		; $5b61
	ld bc,$0400		; $5b64
	call clearMemoryBc		; $5b67
	ld a,GFXH_2d		; $5b6a
	call loadGfxHeader		; $5b6c
	ld a,SEASONS_PALH_9c		; $5b6f
	call loadPaletteHeader		; $5b71
	ld a,$04		; $5b74
	call loadGfxRegisterStateIndex		; $5b76
	ld a,SND_LIGHTNING		; $5b79
	call playSound		; $5b7b
	jp clearPaletteFadeVariablesAndRefreshPalettes		; $5b7e

@state9:
	call decCbb3		; $5b81
	ret nz			; $5b84
	ld a,CUTSCENE_S_CREDITS		; $5b85
	ld (wCutsceneIndex),a		; $5b87
	call seasonsFunc_03_646a		; $5b8a
	ld hl,$cf00		; $5b8d
	ld bc,$00c0		; $5b90
	call clearMemoryBc		; $5b93
	ld hl,$ce00		; $5b96
	ld bc,$00c0		; $5b99
	call clearMemoryBc		; $5b9c
	ldh (<hCameraY),a	; $5b9f
	ldh (<hCameraX),a	; $5ba1
	ld hl,$cbb3		; $5ba3
	ld (hl),$3c		; $5ba6
	ld a,$03		; $5ba8
	jp fadeoutToBlackWithDelay		; $5baa

;;
; CUTSCENE_S_ROOM_OF_RITES_COLLAPSE
_endgameCutsceneHandler_0f:
	ld de,$cbc1		; $5bad
	ld a,(de)		; $5bb0
	rst_jumpTable			; $5bb1
	.dw _endgameCutsceneHandler_0f_stage0
	.dw _endgameCutsceneHandler_0f_stage1

_endgameCutsceneHandler_0f_stage0:
	call updateStatusBar		; $5bb6
	call _endgameCutsceneHandler_0f_stage0_body		; $5bb9
	jp updateAllObjects		; $5bbc

_endgameCutsceneHandler_0f_stage0_body:
	ld de,$cbc2		; $5bbf
	ld a,(de)		; $5bc2
	rst_jumpTable			; $5bc3
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
	ld a,$01		; $5be0
	ld (de),a		; $5be2
	ld hl,wActiveRing		; $5be3
	ld (hl),$ff		; $5be6
	xor a			; $5be8
	ldh (<hActiveObjectType),a	; $5be9
	ld de,$d000		; $5beb
	ld bc,$f8f0		; $5bee
	ld a,$28		; $5bf1
	call objectCreateExclamationMark		; $5bf3
	ld a,$28		; $5bf6
	call objectCreateExclamationMark		; $5bf8
	ld l,$4b		; $5bfb
	ld (hl),$30		; $5bfd
	inc l			; $5bff
	inc l			; $5c00
	ld (hl),$78		; $5c01
	ld hl,$cbb3		; $5c03
	ld (hl),$0a		; $5c06
	ret			; $5c08

@state1:
	call decCbb3		; $5c09
	ret nz			; $5c0c
	ld hl,$cbb3		; $5c0d
	ld (hl),$1e		; $5c10
	ld a,SNDCTRL_STOPMUSIC		; $5c12
	call playSound		; $5c14
	jp incCbc2		; $5c17

@state2:
	call seasonsFunc_03_5cfb		; $5c1a
	call decCbb3		; $5c1d
	ret nz			; $5c20
	call incCbc2		; $5c21
	ld hl,$cbb3		; $5c24
	ld (hl),$96		; $5c27
	jp seasonsFunc_03_5d0b		; $5c29

@state3:
	call seasonsFunc_03_5cfb		; $5c2c
	call decCbb3		; $5c2f
	ret nz			; $5c32
	call incCbc2		; $5c33
	ld a,SNDCTRL_STOPSFX		; $5c36
	call playSound		; $5c38
	ld hl,$cbb3		; $5c3b
	ld (hl),$3c		; $5c3e
	ld bc,TX_3d0e		; $5c40
	jp showText		; $5c43

@state4:
	call seasonsFunc_03_645a		; $5c46
	ret nz			; $5c49
	call incCbc2		; $5c4a
	ld a,MUS_DISASTER		; $5c4d
	call playSound		; $5c4f
	ld hl,$cbb3		; $5c52
	ld (hl),$3c		; $5c55
	jp seasonsFunc_03_5d0b		; $5c57

@state5:
	call seasonsFunc_03_5cfb		; $5c5a
	call decCbb3		; $5c5d
	ret nz			; $5c60
	ld hl,$cbb3		; $5c61
	ld (hl),$5a		; $5c64
	jp incCbc2		; $5c66

@state6:
	call seasonsFunc_03_5cfb		; $5c69
	call decCbb3		; $5c6c
	ret nz			; $5c6f
	call incCbc2		; $5c70
	ld hl,$cbb3		; $5c73
	ld (hl),$3c		; $5c76
	ld a,SNDCTRL_STOPSFX		; $5c78
	jp playSound		; $5c7a

@state7:
	call decCbb3		; $5c7d
	ret nz			; $5c80
	call incCbc2		; $5c81
	ld hl,$cbb3		; $5c84
	ld (hl),$3c		; $5c87
	ld bc,TX_3d0f		; $5c89
	jp showText		; $5c8c

@state8:
	call seasonsFunc_03_645a		; $5c8f
	ret nz			; $5c92
	call incCbc2		; $5c93
	ld hl,$cbb3		; $5c96
	ld (hl),$2c		; $5c99
	inc hl			; $5c9b
	ld (hl),$01		; $5c9c
	ld b,$03		; $5c9e
	jp seasonsFunc_03_5d12		; $5ca0

@state9:
	ld hl,$cbb3		; $5ca3
	call decHlRef16WithCap		; $5ca6
	ret nz			; $5ca9
	call incCbc2		; $5caa
	ld hl,$cbb3		; $5cad
	ld (hl),$3c		; $5cb0
	ld bc,TX_3d10		; $5cb2
	jp showText		; $5cb5

@stateA:
	ld e,$1e		; $5cb8
	jp _endgameCutsceneHandler_09_stage0_body@state16Func0		; $5cba

@stateB:
	call seasonsFunc_03_5cfb		; $5cbd
	call decCbb3		; $5cc0
	ret nz			; $5cc3
	call incCbc2		; $5cc4
	call seasonsFunc_03_5d0b		; $5cc7
	ld a,$8c		; $5cca
	ld ($cbb3),a		; $5ccc
	ld a,$ff		; $5ccf
	ld bc,$4478		; $5cd1
	jp createEnergySwirlGoingOut		; $5cd4

@stateC:
	call seasonsFunc_03_5cfb		; $5cd7
	call decCbb3		; $5cda
	ret nz			; $5cdd
	call incCbc2		; $5cde
	ld hl,$cbb3		; $5ce1
	ld (hl),$3c		; $5ce4
	jp seasonsFunc_03_5d0b		; $5ce6

@stateD:
	call seasonsFunc_03_5cfb		; $5ce9
	call decCbb3		; $5cec
	ret nz			; $5cef
	call incCbc1		; $5cf0
	inc l			; $5cf3
	xor a			; $5cf4
	ld (hl),a		; $5cf5
	ld a,$03		; $5cf6
	jp fadeoutToWhiteWithDelay		; $5cf8

seasonsFunc_03_5cfb:
	ld a,$04		; $5cfb
	call setScreenShakeCounter		; $5cfd

seasonsFunc_03_5d00:
	ld a,(wFrameCounter)		; $5d00
	and $0f			; $5d03
	ld a,SND_RUMBLE2		; $5d05
	jp z,playSound		; $5d07
	ret			; $5d0a

seasonsFunc_03_5d0b:
	call getFreePartSlot		; $5d0b
	ret nz			; $5d0e
	ld (hl),PARTID_48		; $5d0f
	ret			; $5d11

seasonsFunc_03_5d12:
	call getFreeInteractionSlot		; $5d12
	ret nz			; $5d15
	ld (hl),INTERACID_MAKU_LEAF		; $5d16
	inc l			; $5d18
	ld (hl),$00		; $5d19
	inc l			; $5d1b
	ld (hl),b		; $5d1c
	ret			; $5d1d

_endgameCutsceneHandler_0f_stage1:
	call updateStatusBar		; $5d1e
	call _endgameCutsceneHandler_0f_stage1_body		; $5d21
	jp updateAllObjects		; $5d24

_endgameCutsceneHandler_0f_stage1_body:
	ld de,$cbc2		; $5d27
	ld a,(de)		; $5d2a
	rst_jumpTable			; $5d2b
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
	call seasonsFunc_03_5cfb		; $5d42
	ld a,(wPaletteThread_mode)		; $5d45
	or a			; $5d48
	ret nz			; $5d49
	call incCbc2		; $5d4a
	xor a			; $5d4d
	ld bc,ROOM_SEASONS_22b		; $5d4e
	call disableLcdAndLoadRoom_body		; $5d51
	call refreshObjectGfx		; $5d54
	ld b,$0c		; $5d57
	call getEntryFromObjectTable1		; $5d59
	ld d,h			; $5d5c
	ld e,l			; $5d5d
	call parseGivenObjectData		; $5d5e
	ld a,$04		; $5d61
	ld b,$02		; $5d63
	call seasonsFunc_03_642e		; $5d65
	ld a,SNDCTRL_STOPSFX		; $5d68
	call playSound		; $5d6a
	ld a,SNDCTRL_FAST_FADEOUT		; $5d6d
	call playSound		; $5d6f
	ld a,$02		; $5d72
	call loadGfxRegisterStateIndex		; $5d74
	ld hl,$cbb3		; $5d77
	ld (hl),$3c		; $5d7a
	jp fadeinFromWhiteToRoom		; $5d7c

@state1:
	call seasonsFunc_03_6462		; $5d7f
	ret nz			; $5d82
	call incCbc2		; $5d83
	ld a,$3c		; $5d86
	ld ($cbb3),a		; $5d88
	ld a,$64		; $5d8b
	ld bc,$5850		; $5d8d
	jp createEnergySwirlGoingIn		; $5d90

@state2:
	call decCbb3		; $5d93
	ret nz			; $5d96
	xor a			; $5d97
	ld ($cbb3),a		; $5d98
	dec a			; $5d9b
	ld ($cbba),a		; $5d9c
	jp incCbc2		; $5d9f

@state3:
	ld hl,$cbb3		; $5da2
	ld b,$01		; $5da5
	call flashScreen		; $5da7
	ret z			; $5daa
	call incCbc2		; $5dab
	ld hl,$cbb3		; $5dae
	ld (hl),$3c		; $5db1
	ld a,$01		; $5db3
	ld ($cfc0),a		; $5db5
	ld a,$03		; $5db8
	jp fadeinFromWhiteWithDelay		; $5dba

@state4:
	call seasonsFunc_03_6462		; $5dbd
	ret nz			; $5dc0
	ld a,$01		; $5dc1
	ld (wLoadedTreeGfxIndex),a		; $5dc3
	ld a,MUS_CREDITS_1		; $5dc6
	call playSound		; $5dc8
	ld hl,$cbb3		; $5dcb
	ld (hl),$3c		; $5dce
	jp incCbc2		; $5dd0

@state5:
	call decCbb3		; $5dd3
	ret nz			; $5dd6
	call incCbc2		; $5dd7
	ld hl,$cbb3		; $5dda
	ld (hl),$2c		; $5ddd
	inc hl			; $5ddf
	ld (hl),$01		; $5de0
	ld b,$00		; $5de2
	jp seasonsFunc_03_5d12		; $5de4

@state6:
	ld hl,$cbb3		; $5de7
	call decHlRef16WithCap		; $5dea
	ret nz			; $5ded
	ld a,$01		; $5dee
	ld (wLoadedTreeGfxIndex),a		; $5df0
	ld hl,$cbb3		; $5df3
	ld (hl),$3c		; $5df6
	ld hl,$cfc0		; $5df8
	ld (hl),$02		; $5dfb
	jp incCbc2		; $5dfd

@state7:
	ld a,($cfc0)		; $5e00
	cp $09			; $5e03
	ret nz			; $5e05
	call incCbc2		; $5e06
	ld a,$03		; $5e09
	jp fadeoutToWhiteWithDelay		; $5e0b

@state8:
	ld a,(wPaletteThread_mode)		; $5e0e
	or a			; $5e11
	ret nz			; $5e12
	call incCbc2		; $5e13
	call disableLcd		; $5e16
	call clearScreenVariablesAndWramBank1		; $5e19
	call hideStatusBar		; $5e1c
	ld a,GFXH_3c		; $5e1f
	call loadGfxHeader		; $5e21
	ld a,SEASONS_PALH_ad		; $5e24
	call loadPaletteHeader		; $5e26
	ld hl,$cbb3		; $5e29
	ld (hl),$f0		; $5e2c
	ld a,$04		; $5e2e
	call loadGfxRegisterStateIndex		; $5e30
	call _endgameCutsceneHandler_09_stage1_body@seasonsFunc_03_5aa2		; $5e33
	ld a,$03		; $5e36
	jp fadeinFromWhiteWithDelay		; $5e38

@state9:
	call _endgameCutsceneHandler_09_stage1_body@seasonsFunc_03_5aa2		; $5e3b
	call seasonsFunc_03_6462		; $5e3e
	ret nz			; $5e41
	call incCbc2		; $5e42
	ld hl,$cbb3		; $5e45
	ld (hl),$10		; $5e48
	ld a,$03		; $5e4a
	jp fadeoutToBlackWithDelay		; $5e4c

@stateA:
	call _endgameCutsceneHandler_09_stage1_body@seasonsFunc_03_5aa2		; $5e4f
	call seasonsFunc_03_6462		; $5e52
	ret nz			; $5e55
	ld a,CUTSCENE_S_CREDITS		; $5e56
	ld (wCutsceneIndex),a		; $5e58
	call seasonsFunc_03_646a		; $5e5b
	ld hl,$cf00		; $5e5e
	ld bc,$00c0		; $5e61
	call clearMemoryBc		; $5e64
	ld hl,$ce00		; $5e67
	ld bc,$00c0		; $5e6a
	call clearMemoryBc		; $5e6d
	xor a			; $5e70
	ldh (<hCameraY),a	; $5e71
	ldh (<hCameraX),a	; $5e73
	ld hl,$cbb3		; $5e75
	ld (hl),$3c		; $5e78
	ld a,SNDCTRL_MEDIUM_FADEOUT		; $5e7a
	jp playSound		; $5e7c

;;
; CUTSCENE_S_CREDITS
_endgameCutsceneHandler_0a:
	call _endgameCutsceneHandler_0a_body		; $5e7f
	jp func_3539		; $5e82

_endgameCutsceneHandler_0a_body:
	ld de,$cbc1		; $5e85
	ld a,(de)		; $5e88
	rst_jumpTable			; $5e89
	.dw _endgameCutsceneHandler_0a_stage0
	.dw _endgameCutsceneHandler_0a_stage1
	.dw _endgameCutsceneHandler_0a_stage2
	.dw _endgameCutsceneHandler_0a_stage3

_endgameCutsceneHandler_0a_stage0:
	ld de,$cbc2		; $5e92
	ld a,(de)
	rst_jumpTable			; $5e96
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call seasonsFunc_03_6462		; $5e9d
	ret nz			; $5ea0
	call seasonsFunc_03_66dc		; $5ea1
	call incCbc2		; $5ea4
	call clearOam		; $5ea7
	ld hl,$cbb3		; $5eaa
	ld (hl),$b4		; $5ead
	inc hl			; $5eaf
	ld (hl),$00		; $5eb0
	ld hl,wGfxRegs1.LCDC		; $5eb2
	set 3,(hl)		; $5eb5
	ld a,MUS_CREDITS_2		; $5eb7
	jp playSound		; $5eb9

@state1:
	ld hl,$cbb3		; $5ebc
	call decHlRef16WithCap		; $5ebf
	ret nz			; $5ec2
	call incCbc2		; $5ec3
	ld hl,$cbb3		; $5ec6
	ld (hl),$48		; $5ec9
	inc hl			; $5ecb
	ld (hl),$03		; $5ecc
	ld a,PALH_04		; $5ece
	call loadPaletteHeader		; $5ed0
	ld a,$06		; $5ed3
	jp fadeinFromBlackWithDelay		; $5ed5

@state2:
	ld hl,$cbb3		; $5ed8
	call decHlRef16WithCap		; $5edb
	ret nz			; $5ede
	call incCbc1		; $5edf
	inc l			; $5ee2
	ld (hl),a		; $5ee3
	ld b,$04		; $5ee4
	call checkIsLinkedGame		; $5ee6
	jr z,+			; $5ee9
	ld b,$08		; $5eeb
+
	ld hl,$cbb4		; $5eed
	ld (hl),b		; $5ef0
	jp fadeoutToWhite		; $5ef1

_endgameCutsceneHandler_0a_stage1:
	ld de,$cbc2		; $5ef4
	ld a,(de)		; $5ef7
	rst_jumpTable			; $5ef8
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	xor a			; $5f03
	ldh (<hOamTail),a	; $5f04
	ld a,(wPaletteThread_mode)		; $5f06
	or a			; $5f09
	ret nz			; $5f0a
	call disableLcd		; $5f0b
	call incCbc2		; $5f0e
	call clearDynamicInteractions		; $5f11
	call clearOam		; $5f14
	ld a,$10		; $5f17
	ldh (<hOamTail),a	; $5f19
	ld a,($cbb4)		; $5f1b
	sub $04			; $5f1e
	ld hl,@state0Table0		; $5f20
	rst_addDoubleIndex			; $5f23
	ld b,(hl)		; $5f24
	inc hl			; $5f25
	ld a,(hl)		; $5f26
	or a			; $5f27
	jr z,++			; $5f28
	ld c,a			; $5f2a
	ld a,$00		; $5f2b
	call func_36f6		; $5f2d
	ld b,$2d		; $5f30
	ld a,($cbb4)		; $5f32
	cp $04			; $5f35
	jr nz,+			; $5f37
	ld b,UNCMP_GFXH_0f		; $5f39
+
	ld a,b			; $5f3b
	call loadUncompressedGfxHeader		; $5f3c
++
	ld a,($cbb4)		; $5f3f
	sub $04			; $5f42
	add a			; $5f44
	add $85			; $5f45
	call loadGfxHeader		; $5f47
	ld a,PALH_0f		; $5f4a
	call loadPaletteHeader		; $5f4c
	call reloadObjectGfx		; $5f4f
	call checkIsLinkedGame		; $5f52
	jr nz,+			; $5f55
	ld a,($cbb4)		; $5f57
	ld b,$10		; $5f5a
	ld c,$00		; $5f5c
	cp $05			; $5f5e
	jr nz,++		; $5f60
	ld b,$50		; $5f62
	ld c,$0e		; $5f64
	jr ++			; $5f66
+
	ld a,($cbb4)		; $5f68
	ld b,$10		; $5f6b
	ld c,$00		; $5f6d
	cp $0b			; $5f6f
	jr nz,++		; $5f71
	ld b,$ae		; $5f73
	ld c,$ff		; $5f75
++
	ld a,b			; $5f77
	push bc			; $5f78
	call loadPaletteHeader		; $5f79
	pop bc			; $5f7c
	ld a,c			; $5f7d
	ld (wTilesetAnimation),a		; $5f7e
	call loadAnimationData		; $5f81
	ld a,$01		; $5f84
	ld (wScrollMode),a		; $5f86
	xor a			; $5f89
	ldh (<hCameraX),a	; $5f8a
	ld b,$20		; $5f8c
	ld hl,$cfc0		; $5f8e
	call clearMemory		; $5f91
	ld hl,$cbb3		; $5f94
	ld (hl),$f0		; $5f97
	inc l			; $5f99
	ld b,(hl)		; $5f9a
	call seasonsFunc_03_6405		; $5f9b
	ld a,$04		; $5f9e
	call loadGfxRegisterStateIndex		; $5fa0
	jp fadeinFromWhite		; $5fa3
@state0Table0:
	.db $00 $c6
	.db $01 $2b
	.db $00 $b6
	.db $00 $d6
	.db $00 $00
	.db $01 $2b
	.db $00 $00
	.db $00 $00

@state1:
	ld a,(wPaletteThread_mode)		; $5fb6
	or a			; $5fb9
	ret nz			; $5fba
	ld a,($cfdf)		; $5fbb
	or a			; $5fbe
	ret z			; $5fbf
	call incCbc2		; $5fc0
	ld a,$ff		; $5fc3
	ld (wTilesetAnimation),a		; $5fc5
	jp fadeoutToWhite		; $5fc8

@state2:
	ld a,(wPaletteThread_mode)		; $5fcb
	or a			; $5fce
	ret nz			; $5fcf
	call incCbc2		; $5fd0
	call disableLcd		; $5fd3
	call clearWramBank1		; $5fd6
	ld a,($cbb4)		; $5fd9
	sub $04			; $5fdc
	add a			; $5fde
	add $86			; $5fdf
	call loadGfxHeader		; $5fe1
	ld hl,$cbb3		; $5fe4
	ld (hl),$5a		; $5fe7
	inc l			; $5fe9
	ld a,(hl)		; $5fea
	add $9d			; $5feb
	call loadPaletteHeader		; $5fed
	ld a,$04		; $5ff0
	call loadGfxRegisterStateIndex		; $5ff2
	ld a,($cbb4)		; $5ff5
	sub $04			; $5ff8
	ld hl,@state2Table0		; $5ffa
	rst_addAToHl			; $5ffd
	ld a,(hl)		; $5ffe
	ld (wGfxRegs1.SCX),a		; $5fff
	ld a,$10		; $6002
	ldh (<hCameraX),a	; $6004
	jp fadeinFromWhite		; $6006
@state2Table0:
	.db $00 $d0
	.db $00 $d0
	.db $00 $d0
	.db $00 $d0

@state3:
	ld a,(wPaletteThread_mode)		; $6011
	or a			; $6014
	ret nz			; $6015
	call decCbb3		; $6016
	ret nz			; $6019
	call incCbc2		; $601a
	call getFreeInteractionSlot		; $601d
	ret nz			; $6020
	ld (hl),INTERACID_CREDITS_TEXT_HORIZONTAL		; $6021
	inc l			; $6023
	ld a,($cbb4)		; $6024
	sub $04			; $6027
	ldi (hl),a		; $6029
	ld (hl),$00		; $602a
	ret			; $602c

@state4:
	ld a,(wPaletteThread_mode)		; $602d
	or a			; $6030
	ret nz			; $6031
	xor a			; $6032
	ldh (<hOamTail),a	; $6033
	ld a,($cfde)		; $6035
	or a			; $6038
	ret z			; $6039
	ld b,$07		; $603a
	call checkIsLinkedGame		; $603c
	jr z,+			; $603f
	ld b,$0b		; $6041
+
	ld hl,$cbb4		; $6043
	ld a,(hl)		; $6046
	cp b			; $6047
	jr nc,+			; $6048
	inc (hl)		; $604a
	xor a			; $604b
	ld ($cbc2),a		; $604c
	jr ++			; $604f
+
	call seasonsFunc_03_646a		; $6051
	call enableActiveRing		; $6054
	ld a,$02		; $6057
	ld ($cbc1),a		; $6059
	ld hl,wLinkMaxHealth		; $605c
	ldd a,(hl)		; $605f
	ld (hl),a		; $6060
	xor a			; $6061
	ld l,$80		; $6062
	ldi (hl),a		; $6064
	ld (hl),a		; $6065
	ld l,$c5		; $6066
	ld (hl),$ff		; $6068
++
	jp fadeoutToWhite		; $606a

_endgameCutsceneHandler_0a_stage2:
	xor a			; $606d
	ldh (<hOamTail),a	; $606e
	ld de,$cbc2		; $6070
	ld a,(de)		; $6073
	rst_jumpTable			; $6074
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
	ld a,(wPaletteThread_mode)		; $6087
	or a			; $608a
	ret nz			; $608b
	call incCbc2		; $608c
	call disableLcd		; $608f
	call clearDynamicInteractions		; $6092
	call clearOam		; $6095
	xor a			; $6098
	ld ($cfde),a		; $6099
	ld a,GFXH_95		; $609c
	call loadGfxHeader		; $609e
	ld a,SEASONS_PALH_a0		; $60a1
	call loadPaletteHeader		; $60a3
	ld a,$09		; $60a6
	call loadGfxRegisterStateIndex		; $60a8
	call fadeinFromWhite		; $60ab
	call getFreeInteractionSlot		; $60ae
	ret nz			; $60b1
	ld (hl),INTERACID_CREDITS_TEXT_VERTICAL		; $60b2
	ld l,$4b		; $60b4
	ld (hl),$e8		; $60b6
	inc l			; $60b8
	inc l			; $60b9
	ld (hl),$50		; $60ba
	ret			; $60bc

@state1:
	ld a,($cfde)		; $60bd
	or a			; $60c0
	ret z			; $60c1
	ld hl,$cbb3		; $60c2
	ld (hl),$e0		; $60c5
	inc hl			; $60c7
	ld (hl),$01		; $60c8
	jp incCbc2		; $60ca

@state2:
	ld hl,$cbb3		; $60cd
	call decHlRef16WithCap		; $60d0
	ret nz			; $60d3
	call checkIsLinkedGame		; $60d4
	jr nz,+			; $60d7
	call seasonsFunc_03_646a		; $60d9
	ld a,$03		; $60dc
	ld ($cbc1),a		; $60de
	ld a,$04		; $60e1
	jp fadeoutToWhiteWithDelay		; $60e3
+
	ld a,$04		; $60e6
	ld ($cbb3),a		; $60e8
	ld a,(wGfxRegs1.SCY)		; $60eb
	ldh (<hCameraY),a	; $60ee
	ld a,UNCMP_GFXH_01		; $60f0
	call loadUncompressedGfxHeader		; $60f2
	ld a,PALH_0b		; $60f5
	call loadPaletteHeader		; $60f7
	ld b,$03		; $60fa
-
	call getFreeInteractionSlot		; $60fc
	jr nz,+			; $60ff
	ld (hl),INTERACID_INTRO_SPRITES_1		; $6101
	inc l			; $6103
	ld (hl),$09		; $6104
	inc l			; $6106
	dec b			; $6107
	ld (hl),b		; $6108
	jr nz,-			; $6109
+
	jp incCbc2		; $610b

@state3:
	ld a,(wGfxRegs1.SCY)		; $610e
	or a			; $6111
	jr nz,+			; $6112
	ld a,$78		; $6114
	ld ($cbb3),a		; $6116
	jp incCbc2		; $6119
+
	call decCbb3		; $611c
	ret nz			; $611f
	ld (hl),$04		; $6120
	ld hl,wGfxRegs1.SCY	; $6122
	dec (hl)		; $6125
	ld a,(hl)		; $6126
	ldh (<hCameraY),a	; $6127
	ret			; $6129

@state4:
	call decCbb3		; $612a
	ret nz			; $612d
	ld a,$ff		; $612e
	ld ($cbba),a		; $6130
	jp incCbc2		; $6133

@state5:
	ld hl,$cbb3		; $6136
	ld b,$01		; $6139
	call flashScreen		; $613b
	ret z			; $613e
	call disableLcd		; $613f
	ld a,GFXH_9a		; $6142
	call loadGfxHeader		; $6144
	ld a,SEASONS_PALH_9f		; $6147
	call loadPaletteHeader		; $6149
	call clearDynamicInteractions		; $614c
	ld b,$03		; $614f
-
	call getFreeInteractionSlot		; $6151
	jr nz,+			; $6154
	ld (hl),INTERACID_cf		; $6156
	inc l			; $6158
	dec b			; $6159
	ld (hl),b		; $615a
	jr nz,-			; $615b
+
	ld a,$04		; $615d
	call loadGfxRegisterStateIndex		; $615f
	ld a,$04		; $6162
	call fadeinFromWhiteWithDelay		; $6164
	call incCbc2		; $6167
	ld a,$f0		; $616a
	ld ($cbb3),a		; $616c

@seasonsFunc_03_616f:
	xor a			; $616f
	ldh (<hOamTail),a	; $6170
	ld a,(wGfxRegs1.SCY)		; $6172
	cp $60			; $6175
	jr nc,+			; $6177
	cpl			; $6179
	inc a			; $617a
	ld b,a			; $617b
	ld a,(wFrameCounter)		; $617c
	and $01			; $617f
	jr nz,+			; $6181
	ld c,a			; $6183
	ld hl,seasonsOamData_03_6641		; $6184
	call addSpritesToOam_withOffset		; $6187
+
	ld a,(wGfxRegs1.SCY)		; $618a
	cpl			; $618d
	inc a			; $618e
	ld b,$c7		; $618f
	add b			; $6191
	ld b,a			; $6192
	ld c,$38		; $6193
	ld hl,seasonsOamData_03_668a		; $6195
	push bc			; $6198
	call addSpritesToOam_withOffset		; $6199
	pop bc			; $619c
	ld a,(wGfxRegs1.SCY)		; $619d
	cp $60			; $61a0
	ret c			; $61a2
	ld hl,seasonsOamData_03_66bf		; $61a3
	jp addSpritesToOam_withOffset		; $61a6

@state6:
	call @seasonsFunc_03_616f		; $61a9
	call seasonsFunc_03_6462		; $61ac
	ret nz			; $61af
	ld a,$04		; $61b0
	ld ($cbb3),a		; $61b2
	jp incCbc2		; $61b5

@state7:
	ld a,(wGfxRegs1.SCY)		; $61b8
	cp $98			; $61bb
	jr nz,+			; $61bd
	ld a,$f0		; $61bf
	ld ($cbb3),a		; $61c1
	call incCbc2		; $61c4
	jr ++			; $61c7
+
	call decCbb3		; $61c9
	jr nz,++		; $61cc
	ld (hl),$04		; $61ce
	ld hl,wGfxRegs1.SCY		; $61d0
	inc (hl)		; $61d3
	ld a,(hl)		; $61d4
	ldh (<hCameraY),a	; $61d5
	cp $60			; $61d7
	jr nz,++		; $61d9
	call clearDynamicInteractions		; $61db
	ld a,UNCMP_GFXH_2c		; $61de
	call loadUncompressedGfxHeader		; $61e0
++
	jp @seasonsFunc_03_616f		; $61e3

@state8:
	call @seasonsFunc_03_616f		; $61e6
	call decCbb3		; $61e9
	ret nz			; $61ec
	call seasonsFunc_03_646a		; $61ed
	ld a,$03		; $61f0
	ld ($cbc1),a		; $61f2
	ld a,$04		; $61f5
	jp fadeoutToWhiteWithDelay		; $61f7

_endgameCutsceneHandler_0a_stage3:
	ld de,$cbc2		; $61fa
	ld a,(de)		; $61fd
	rst_jumpTable			; $61fe
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
	call checkIsLinkedGame		; $6217
	call nz,_endgameCutsceneHandler_0a_stage2@seasonsFunc_03_616f		; $621a
	ld a,(wPaletteThread_mode)		; $621d
	or a			; $6220
	ret nz			; $6221
	call disableLcd		; $6222
	call incCbc2		; $6225
	call seasonsFunc_03_66ed		; $6228
	call clearDynamicInteractions		; $622b
	call clearOam		; $622e
	call checkIsLinkedGame		; $6231
	jp z,@state0Func0		; $6234
	ld a,$99		; $6237
	call loadGfxHeader		; $6239
	ld a,$aa		; $623c
	call loadPaletteHeader		; $623e
	ld hl,objectData.objectData5887		; $6241
	call parseGivenObjectData		; $6244
	jr +				; $6247
@state0Func0:
	ld a,GFXH_98		; $6249
	call loadGfxHeader		; $624b
	ld a,SEASONS_PALH_a9		; $624e
	call loadPaletteHeader		; $6250
+
	ld a,$04		; $6253
	call loadGfxRegisterStateIndex		; $6255
	xor a			; $6258
	ld hl,hCameraY		; $6259
	ldi (hl),a		; $625c
	ldi (hl),a		; $625d
	ldi (hl),a		; $625e
	ld (hl),a		; $625f
	ld hl,$cbb3		; $6260
	ld (hl),$f0		; $6263
	ld (hl),a		; $6265
	ld a,SNDCTRL_MEDIUM_FADEOUT		; $6266
	call playSound		; $6268
	ld a,$04		; $626b
	jp fadeinFromWhiteWithDelay		; $626d

@state1:
	ld a,(wPaletteThread_mode)		; $6270
	or a			; $6273
	ret nz			; $6274
	call incCbc2		; $6275
@state1Func0:
	call checkIsLinkedGame		; $6278
	ret z			; $627b
	ld hl,$cbb4		; $627c
	ld a,(hl)		; $627f
	or a			; $6280
	jr z,+			; $6281
	dec (hl)		; $6283
	ret			; $6284
+
	ld a,SND_WAVE		; $6285
	call playSound		; $6287
	call getRandomNumber_noPreserveVars		; $628a
	and $03			; $628d
	ld hl,@state1Table0		; $628f
	rst_addAToHl			; $6292
	ld a,(hl)		; $6293
	ld ($cbb4),a		; $6294
	ret			; $6297
@state1Table0:
	.db $a0 $c8
	.db $10 $f0

@state2:
	call @state1Func0		; $629c
	call decCbb3		; $629f
	ret nz			; $62a2
	call incCbc2		; $62a3

@state3:
	call @state1Func0		; $62a6
	ld hl,wFileIsLinkedGame		; $62a9
	ldi a,(hl)		; $62ac
	add (hl)		; $62ad
	cp $02			; $62ae
	ret z			; $62b0
	ld a,(wKeysJustPressed)		; $62b1
	and (BTN_START|BTN_A|BTN_B)	; $62b4
	ret z			; $62b6
	call incCbc2		; $62b7
	jp fadeoutToWhite		; $62ba

@state4:
	ld a,(wPaletteThread_mode)		; $62bd
	or a			; $62c0
	ret nz			; $62c1
	call incCbc2		; $62c2
	call disableLcd		; $62c5
	call generateGameTransferSecret		; $62c8
	ld a,$ff		; $62cb
	ld ($cbba),a		; $62cd
	ld a,($ff00+R_SVBK)	; $62d0
	push af			; $62d2
	ld a,$07		; $62d3
	ld ($ff00+R_SVBK),a	; $62d5
	ld hl,$d460		; $62d7
	ld de,$d800		; $62da
	ld bc,$1800		; $62dd
-
	ldi a,(hl)		; $62e0
	call copyTextCharacterGfx		; $62e1
	dec b			; $62e4
	jr nz,-			; $62e5
	pop af			; $62e7
	ld ($ff00+R_SVBK),a	; $62e8
	ld a,GFXH_97		; $62ea
	call loadGfxHeader		; $62ec
	ld a,UNCMP_GFXH_2b		; $62ef
	call loadUncompressedGfxHeader		; $62f1
	ld a,PALH_05		; $62f4
	call loadPaletteHeader		; $62f6
	call checkIsLinkedGame		; $62f9
	ld a,GFXH_84		; $62fc
	call nz,loadGfxHeader		; $62fe
	call clearDynamicInteractions		; $6301
	call clearOam		; $6304
	ld a,$04		; $6307
	call loadGfxRegisterStateIndex		; $6309
	ld hl,$cbb3		; $630c
	ld (hl),$3c		; $630f
	call fileSelect_redrawDecorations		; $6311
	jp fadeinFromWhite		; $6314

@state5:
	call fileSelect_redrawDecorations		; $6317
	call seasonsFunc_03_6462		; $631a
	ret nz			; $631d
	ld hl,$cbb3		; $631e
	ld b,$3c		; $6321
	call checkIsLinkedGame		; $6323
	jr z,+			; $6326
	ld b,$b4		; $6328
+
	ld (hl),b		; $632a
	jp incCbc2		; $632b

@state6:
	call fileSelect_redrawDecorations		; $632e
	call decCbb3		; $6331
	ret nz			; $6334
	call checkIsLinkedGame		; $6335
	jr nz,+			; $6338
	call getFreeInteractionSlot		; $633a
	jr nz,+			; $633d
	ld (hl),INTERACID_d1		; $633f
	xor a			; $6341
	ld ($cfde),a		; $6342
+
	jp incCbc2		; $6345

@state7:
	call fileSelect_redrawDecorations		; $6348
	call checkIsLinkedGame		; $634b
	jr z,+		; $634e
	ld a,(wKeysJustPressed)		; $6350
	and BTN_A			; $6353
	jr nz,++	; $6355
	ret			; $6357
+
	ld a,($cfde)		; $6358
	or a			; $635b
	ret z			; $635c
++
	call incCbc2		; $635d
	ld a,SNDCTRL_FAST_FADEOUT		; $6360
	call playSound		; $6362
	jp fadeoutToWhite		; $6365

@state8:
	call fileSelect_redrawDecorations		; $6368
	ld a,(wPaletteThread_mode)		; $636b
	or a			; $636e
	ret nz			; $636f
	call checkIsLinkedGame		; $6370
	jp nz,resetGame		; $6373
	call disableLcd		; $6376
	call clearOam		; $6379
	call incCbc2		; $637c
	ld a,GFXH_82		; $637f
	call loadGfxHeader		; $6381
	ld a,SEASONS_PALH_8f		; $6384
	call loadPaletteHeader		; $6386
	call fadeinFromWhite		; $6389
	ld a,$04		; $638c
	jp loadGfxRegisterStateIndex		; $638e

@state9:
	call @state9Func0		; $6391
	ld a,(wPaletteThread_mode)		; $6394
	or a			; $6397
	ret nz			; $6398
	ld hl,$cbb3		; $6399
	ld (hl),$b4		; $639c
	jp incCbc2		; $639e
@state9Func0:
	ld hl,oamData_15_4e0c		; $63a1
	ld e,:oamData_15_4e0c		; $63a4
	ld bc,$3038		; $63a6
	xor a			; $63a9
	ldh (<hOamTail),a	; $63aa
	jp addSpritesFromBankToOam_withOffset		; $63ac

@stateA:
	call @state9Func0		; $63af
	ld hl,$cbb3		; $63b2
	ld a,(hl)		; $63b5
	or a			; $63b6
	jr z,+			; $63b7
	dec (hl)		; $63b9
	ret			; $63ba
+
	ld a,(wKeysJustPressed)		; $63bb
	and BTN_A		; $63be
	ret z			; $63c0
	call incCbc2		; $63c1
	jp fadeoutToWhite		; $63c4

@stateB:
	call @state9Func0		; $63c7
	ld a,(wPaletteThread_mode)		; $63ca
	or a			; $63cd
	ret nz			; $63ce
	jp resetGame		; $63cf

;;
; Similar to ages' version of this function
;
; @addr{63d2}
disableLcdAndLoadRoom_body:
	ld (wRoomStateModifier),a		; $63d2
	ld a,b			; $63d5
	ld (wActiveGroup),a		; $63d6
	ld a,c			; $63d9
	ld (wActiveRoom),a		; $63da
	call disableLcd		; $63dd
	call clearScreenVariablesAndWramBank1		; $63e0
	ld hl,wLinkInAir		; $63e3
	ld b,wcce9-wLinkInAir		; $63e6
	call clearMemory		; $63e8

seasonsFunc_03_63eb:
	call initializeVramMaps		; $63eb
	call loadScreenMusicAndSetRoomPack		; $63ee
	call loadTilesetData		; $63f1
	call loadTilesetGraphics		; $63f4
	call func_131f		; $63f7
	ld a,$01		; $63fa
	ld (wScrollMode),a		; $63fc
	call loadCommonGraphics		; $63ff
	jp clearOam		; $6402

seasonsFunc_03_6405:
	ld a,b			; $6405
	cp $ff			; $6406
	ret z			; $6408
	push bc			; $6409
	call refreshObjectGfx		; $640a
	pop bc			; $640d
	call getEntryFromObjectTable1		; $640e
	ld d,h			; $6411
	ld e,l			; $6412
	call parseGivenObjectData		; $6413
	xor a			; $6416
	ld ($cfc0),a		; $6417
	ld a,($cbb4)		; $641a
	cp $05			; $641d
	jr z,+			; $641f
	cp $06			; $6421
	jr z,++			; $6423
	cp $07			; $6425
	jr z,+++		; $6427
	ret			; $6429
+
	ld a,$04		; $642a
	ld b,$03		; $642c

seasonsFunc_03_642e:
	call seasonsFunc_03_6434		; $642e
	jp reloadObjectGfx		; $6431

seasonsFunc_03_6434:
	ld hl,wLoadedObjectGfx		; $6434
-
	ldi (hl),a		; $6437
	inc a			; $6438
	ld (hl),$01		; $6439
	inc l			; $643b
	dec b			; $643c
	jr nz,-			; $643d
	ret			; $643f
++
	ld a,$0f		; $6440
	ld b,$06		; $6442
	jr seasonsFunc_03_642e		; $6444
+++
	ld a,$13		; $6446
	ld b,$02		; $6448
	jr seasonsFunc_03_642e		; $644a

seasonsFunc_03_644c:
	ld (wRoomStateModifier),a		; $644c
	call disableLcd		; $644f
	call seasonsFunc_03_63eb		; $6452
	ld a,$02		; $6455
	jp loadGfxRegisterStateIndex		; $6457

seasonsFunc_03_645a:
	ld a,(wTextIsActive)		; $645a
	or a			; $645d
	ret nz			; $645e
	jp decCbb3		; $645f

seasonsFunc_03_6462:
	ld a,(wPaletteThread_mode)		; $6462
	or a			; $6465
	ret nz			; $6466
	jp decCbb3		; $6467

seasonsFunc_03_646a:
	ld hl,$cbb3		; $646a
	ld b,$10		; $646d
	jp clearMemory		; $646f

.include "build/data/creditsOamData.s"

seasonsFunc_03_66dc:
	ld hl,wLinkHealth		; $66dc
	ld (hl),$04		; $66df
	ld l,<wInventoryB		; $66e1
	ldi a,(hl)		; $66e3
	ld b,(hl)		; $66e4
	ld hl,wcc1f		; $66e5
	ldi (hl),a		; $66e8
	ld (hl),b		; $66e9
	jp disableActiveRing		; $66ea

seasonsFunc_03_66ed:
	ld hl,wLinkMaxHealth		; $66ed
	ldd a,(hl)		; $66f0
	ld (hl),a		; $66f1
	ld hl,wcc1f		; $66f2
	ldi a,(hl)		; $66f5
	ld b,(hl)		; $66f6
	ld hl,wInventoryB		; $66f7
	ldi (hl),a		; $66fa
	ld (hl),b		; $66fb
	jp enableActiveRing		; $66fc
