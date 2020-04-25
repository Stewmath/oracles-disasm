; Main file for Oracle of Ages, US version

.include "include/rominfo.s"
.include "include/emptyfill.s"
.include "include/constants.s"
.include "include/structs.s"
.include "include/wram.s"
.include "include/hram.s"
.include "include/macros.s"
.include "include/script_commands.s"
.include "include/simplescript_commands.s"
.include "include/movementscript_commands.s"

.include "objects/macros.s"
.include "include/gfxDataMacros.s"

.include "build/textDefines.s"


.BANK $00 SLOT 0
.ORG 0

	.include "code/bank0.s"

.BANK $01 SLOT 1
.ORG 0

	.include "code/bank1.s"


.BANK $02 SLOT 1
.ORG 0

	.include "code/bank2.s"


.BANK $03 SLOT 1
.ORG 0

.include "code/bank3.s"

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
	ld hl,$5f1c		; $5ebe
	rst_addDoubleIndex			; $5ec1
	ld b,(hl)		; $5ec2
	inc hl			; $5ec3
	ld c,(hl)		; $5ec4
	ld a,$00		; $5ec5
	call func_36f6		; $5ec7
	ld a,($cfde)		; $5eca
	ld hl,$5f24		; $5ecd
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
	ld hl,$5f28		; $5efa
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
	nop			; $5f1c
	jr c,_label_03_100	; $5f1d
_label_03_100:
	ldd a,(hl)		; $5f1f
	nop			; $5f20
	ld c,d			; $5f21
	ld bc,$2d16		; $5f22
	rrca			; $5f25
	dec l			; $5f26
	rrca			; $5f27
	jr nc,_label_03_101	; $5f28
	dec l			; $5f2a
	daa			; $5f2b
	jp z,$caca		; $5f2c
	xor (hl)		; $5f2f
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
	ld hl,$70f6		; $5fd5
	ld e,$10		; $5fd8
	jp interBankCall		; $5fda
	ld hl,$7298		; $5fdd
	ld e,$10		; $5fe0
	jp interBankCall		; $5fe2

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
	ld hl,$4f73		; $60a6
	ld e,$16		; $60a9
	ld bc,$3038		; $60ab
	jr _cutscene_resetOamWithData			; $60ae

;;
; @addr{60b0}
_cutscene_resetOamWithSomething2:
	ld hl,$4e37		; $60b0
	ld e,$16		; $60b3
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
	ld hl,$6625		; $65e1
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
	add d			; $6625
	cpl			; $6626
	add c			; $6627
	ld l,$80		; $6628
	ld l,$cd		; $662a
	rst $30			; $662c
	ld l,(hl)		; $662d
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
	ld hl,_cutscene_loadObjectSetAndFadein		; $6a63
	ld e,$03		; $6a66
	call interBankCall		; $6a68
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
	ld hl,$6fe3		; $6fd6
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
	ld hl,$4133		; $7272
	ld e,$3f		; $7275
	call interBankCall		; $7277
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
	ld hl,$7440		; $7437
	rst_addDoubleIndex			; $743a
	ldi a,(hl)		; $743b
	ld e,(hl)		; $743c
	ld d,a			; $743d
	pop hl			; $743e
	ret			; $743f
.DB $dd				; $7440
	rst $38			; $7441
.DB $dd				; $7442
	cp e			; $7443
	ld d,l			; $7444
	cp e			; $7445
	ld d,l			; $7446
	xor d			; $7447
	ld de,$11aa		; $7448
	adc b			; $744b
	nop			; $744c
	adc b			; $744d
	nop			; $744e
	nop			; $744f
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
	ld hl,$7513		; $74f4
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
	inc sp			; $7513
	stop			; $7514
	inc (hl)		; $7515
	nop			; $7516
	dec (hl)		; $7517
	stop			; $7518
	ld (hl),$00		; $7519
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

.ifdef BUILD_VANILLA

; Garbage functions appear to follow (corrupted repeats of the above functions).

;;
; @addr{7e54}
func_7e54:
	ld a,$10		; $7e54
	ld (wLinkStateParameter),a		; $7e56
	ld hl,w1Link.direction		; $7e59
	ld a,$02		; $7e5c
	ldi (hl),a		; $7e5e
	ld (hl),$10		; $7e5f
	ld a,$07		; $7e61
	ld (wTmpcbb5),a		; $7e63
	xor a			; $7e66
	ld ($cfde),a		; $7e67
	call $3b46		; $7e6a
	ld (hl),$92		; $7e6d
	ld l,$43		; $7e6f
	ld (hl),$01		; $7e71
	call $3b46		; $7e73
	ld (hl),$2c		; $7e76
	ld l,$4b		; $7e78
	ld a,(w1Link.yh)		; $7e7a
	add $10			; $7e7d
	ldi (hl),a		; $7e7f
	ld a,(w1Link.xh)		; $7e80
	inc l			; $7e83
	ld (hl),a		; $7e84
	jp $7d02		; $7e85

;;
; @addr{7e88}
func_7e88:
	call $7ea9		; $7e88
	ld a,(wTmpcbb5)		; $7e8b
	cp $08			; $7e8e
	ret nz			; $7e90
	ld a,$f0		; $7e91
	call $0cb1		; $7e93
	xor a			; $7e96
	ld (wActiveMusic),a		; $7e97
	inc a			; $7e9a
	ld (wCutsceneIndex),a		; $7e9b
	ld hl,$7ea4		; $7e9e
	jp $19c5		; $7ea1

;;
; @addr{7ea4}
func_7ea4:
	add l			; $7ea4
	rst_addAToHl			; $7ea5
	dec b			; $7ea6
	ld (hl),a		; $7ea7
	inc bc			; $7ea8
	ld a,(wScreenShakeCounterY)		; $7ea9
	and $0f			; $7eac
	ld a,$b3		; $7eae
	call z,$0cb1		; $7eb0
	ld a,(wScreenShakeCounterY)		; $7eb3
	or a			; $7eb6
	ld a,$ff		; $7eb7
	jp z,$24f8		; $7eb9
	ret			; $7ebc

.endif

.BANK $04 SLOT 1
.ORG 0

.include "code/bank4.s"


; roomPacks must be in the same bank as groupMusicPointerTable, etc.
.include "build/data/roomPacks.s"


groupMusicPointerTable: ; 495c
	.dw group0Music
	.dw group1Music
	.dw group2Music
	.dw group3Music
	.dw group4Music
	.dw group5Music
	.dw group6Music
	.dw group7Music

group0Music:
	.incbin "audio/ages/group0IDs.bin"
group1Music:
	.incbin "audio/ages/group1IDs.bin"
group2Music:
	.incbin "audio/ages/group2IDs.bin"
group3Music:
	.incbin "audio/ages/group3IDs.bin"
group4Music:
group6Music:
	.incbin "audio/ages/group4IDs.bin"
group5Music:
group7Music:
	.incbin "audio/ages/group5IDs.bin"


; Format:
; First byte indicates whether it's a dungeon or not (and consequently what compression it uses)
; 3 byte pointer to a table containing relative offsets for room data for each sector on the map
; 3 byte pointer to the base offset of the actual layout data
roomLayoutGroupTable: ; $4f6c
	.db $01
	3BytePointer roomLayoutGroup0Table
	3BytePointer room0000
	.db $00

	.db $01
	3BytePointer roomLayoutGroup1Table
	3BytePointer room0100
	.db $00

	.db $01
	3BytePointer roomLayoutGroup2Table
	3BytePointer room0200
	.db $00

	.db $01
	3BytePointer roomLayoutGroup3Table
	3BytePointer room0300
	.db $00

	.db $00
	3BytePointer roomLayoutGroup4Table
	3BytePointer room0400
	.db $00

	.db $00
	3BytePointer roomLayoutGroup5Table
	3BytePointer room0500
	.db $00

.include "build/data/tilesets.s"
.include "build/data/tilesetAssignments.s"


;;
; @addr{58e4}
initializeAnimations:
	ld a,(wTilesetAnimation)		; $58e4
	cp $ff			; $58e7
	ret z			; $58e9

	call loadAnimationData		; $58ea
	call @locFunc		; $58ed
	ld hl,wAnimationState		; $58f0
	set 7,(hl)		; $58f3
	call @locFunc		; $58f5
	ld hl,wAnimationState		; $58f8
	set 7,(hl)		; $58fb
@locFunc:
	call updateAnimationData		; $58fd
-
	call updateAnimationQueue		; $5900
	jr nz, -
	ret			; $5905

;;
; @addr{5906}
updateAnimations:
	ld hl,wAnimationState		; $5906
	res 6,(hl)		; $5909
	ld a,(wTilesetAnimation)		; $590b
	inc a			; $590e
	ret z			; $590f

	ld a,(wScrollMode)		; $5910
	and $01			; $5913
	ret z			; $5915

	call updateAnimationQueue		; $5916
	jr updateAnimationData		; $5919

;;
; Read the next index off of the animation queue, set zero flag if there's
; nothing more to be read.
; @addr{591b}
updateAnimationQueue:
	ld a,(wAnimationQueueHead)		; $591b
	ld b,a			; $591e
	ld a,(wAnimationQueueTail)		; $591f
	cp b			; $5922
	ret z			; $5923

	inc b			; $5924
	ld a,b			; $5925
	and $1f			; $5926
	ld (wAnimationQueueHead),a		; $5928
	ld hl,w2AnimationQueue		; $592b
	rst_addAToHl			; $592e
	ld a,:w2AnimationQueue
	ld ($ff00+R_SVBK),a	; $5931
	ld b,(hl)		; $5933
	xor a			; $5934
	ld ($ff00+R_SVBK),a	; $5935
	ld a,b			; $5937
	call loadAnimationGfxIndex		; $5938
	ld hl,wAnimationState		; $593b
	set 6,(hl)		; $593e
	or h			; $5940
	ret			; $5941

;;
; @addr{5942}
updateAnimationData:
	ld hl,wAnimationCounter1		; $5942
	ld a,(wAnimationState)		; $5945
	bit 0,a			; $5948
	call nz,updateAnimationDataPointer		; $594a
	ld hl,wAnimationCounter2		; $594d
	ld a,(wAnimationState)		; $5950
	bit 1,a			; $5953
	call nz,updateAnimationDataPointer		; $5955
	ld hl,wAnimationCounter3		; $5958
	ld a,(wAnimationState)		; $595b
	bit 2,a			; $595e
	call nz,updateAnimationDataPointer		; $5960
	ld hl,wAnimationCounter4		; $5963
	ld a,(wAnimationState)		; $5966
	bit 3,a			; $5969
	call nz,updateAnimationDataPointer		; $596b

	; Unset force update bit
	ld a,(wAnimationState)		; $596e
	and $7f			; $5971
	ld (wAnimationState),a		; $5973
	ret			; $5976

;;
; Update animation data pointed to by hl
; @addr{5977}
updateAnimationDataPointer:
	; If bit 7 set, force update
	ld a,(wAnimationState)		; $5977
	bit 7,a			; $597a
	jr nz, +

	; Otherwise, decrement counter
	dec (hl)		; $597e
	ret nz			; $597f
+
	; Load hl with a pointer to the animationData structure
	push hl			; $5980
	inc hl			; $5981
	ldi a,(hl)		; $5982
	ld h,(hl)		; $5983
	ld l,a			; $5984

	; e = animation gfx index
	ld e,(hl)		; $5985
	inc hl			; $5986
	; If next byte is 0xff, it jumps several bytes back, otherwise the data
	; structure continues
	ldi a,(hl)		; $5987
	cp $ff			; $5988
	jr nz, +
	ld b,a			; $598c
	ld c,(hl)		; $598d
	add hl,bc		; $598e
	ldi a,(hl)		; $598f
+
	ld c,l			; $5990
	ld b,h			; $5991
	pop hl			; $5992
	ldi (hl),a		; $5993
	ld (hl),c		; $5994
	inc hl			; $5995
	ld (hl),b		; $5996

	; Set animation index to be loaded
	ld b,e			; $5997
	ld a,(wAnimationQueueTail)		; $5998
	inc a			; $599b
	and $1f			; $599c
	ld e,a			; $599e
	ld a,(wAnimationQueueHead)		; $599f
	cp e			; $59a2
	ret z			; $59a3

	ld a,e			; $59a4
	ld (wAnimationQueueTail),a		; $59a5
	ld a,:w2AnimationQueue
	ld ($ff00+R_SVBK),a	; $59aa
	ld a,e			; $59ac
	ld hl,w2AnimationQueue		; $59ad
	rst_addAToHl			; $59b0
	ld (hl),b		; $59b1
	xor a			; $59b2
	ld ($ff00+R_SVBK),a	; $59b3
	or h			; $59b5
	ret			; $59b6

;;
; Load animation index a
; @addr{59b7}
loadAnimationGfxIndex:
	ld c,$06		; $59b7
	call multiplyAByC		; $59b9
	ld bc, animationGfxHeaders
	add hl,bc		; $59bf
	ldi a,(hl)		; $59c0
	ld c,a			; $59c1
	ldi a,(hl)		; $59c2
	ld d,a			; $59c3
	ldi a,(hl)		; $59c4
	ld e,a			; $59c5
	push de			; $59c6
	ldi a,(hl)		; $59c7
	ld d,a			; $59c8
	ldi a,(hl)		; $59c9
	ld e,a			; $59ca
	ld b,(hl)		; $59cb
	pop hl			; $59cc
	jp queueDmaTransfer		; $59cd

.include "build/data/uniqueGfxHeaders.s"
.include "build/data/uniqueGfxHeaderPointers.s"
.include "build/data/animationGroups.s"
.include "build/data/animationGfxHeaders.s"
.include "build/data/animationData.s"

;;
; @addr{5fef}
applyAllTileSubstitutions:
	call replacePollutionWithWaterIfPollutionFixed		; $5fef
	call applySingleTileChanges		; $5ff2
	call applyStandardTileSubstitutions		; $5ff5
	call replaceOpenedChest		; $5ff8
	ld a,(wActiveGroup)		; $5ffb
	and $06			; $5ffe
	cp NUM_SMALL_GROUPS		; $6000
	jr nz,+			; $6002

	call replaceShutterForLinkEntering		; $6004
	call replaceSwitchTiles		; $6007
	call replaceToggleBlocks		; $600a
	call replaceJabuTilesIfUnderwater		; $600d
+
	call applyRoomSpecificTileChanges		; $6010
	ld a,(wActiveGroup)		; $6013
	cp $02			; $6016
	ret nc			; $6018

	; In the overworld

	call replaceBreakableTileOverPortal		; $6019
	call replaceBreakableTileOverLinkTimeWarpingIn		; $601c
	ld a,(wLinkTimeWarpTile)		; $601f
	or a			; $6022
	ret z			; $6023

	; If link was sent back from trying to travel through time, clear the
	; breakable tile at his position (if it exists) so he can safely
	; return.

	ld c,a			; $6024
	dec c			; $6025
	ld b,>wRoomLayout		; $6026
	ld a,(bc)		; $6028
	ld e,a			; $6029
	ld hl,@tileReplacementDict		; $602a
	call lookupKey		; $602d
	ret nc			; $6030

	ld (bc),a		; $6031
	ret			; $6032

@tileReplacementDict:
	.db $c0 $3a ; Rocks
	.db $c3 $3a
	.db $c5 $3a ; Bushes
	.db $c8 $3a
	.db $ce $3a ; Burnable bush
	.db $db $3a ; Switchhook diamond
	.db $f2 $3a ; Sign
	.db $cd $3a ; Dirt
	.db $04 $3a ; Flowers (in some areas)
	.db $00

;;
; @addr{6046}
replaceBreakableTileOverPortal:
	ld hl,wPortalGroup		; $6046
	ld a,(wActiveGroup)		; $6049
	cp (hl)			; $604c
	ret nz			; $604d

	inc l			; $604e
	ld a,(wActiveRoom)		; $604f
	cp (hl)			; $6052
	ret nz			; $6053

	inc l			; $6054
	ld c,(hl)		; $6055
_removeBreakableTileForTimeWarp:
	ld b,>wRoomLayout		; $6056
	ld a,(bc)		; $6058
	ld e,a			; $6059
	ld hl,@tileReplacementDict		; $605a
	call lookupKey		; $605d
	ret nc			; $6060

	ld (bc),a		; $6061
	ret			; $6062

; @addr{6063}
@tileReplacementDict:
	.db $c5 $3a
	.db $c8 $3a
	.db $04 $3a
	.db $00

;;
; @addr{606a}
replaceBreakableTileOverLinkTimeWarpingIn:
	ld a,(wWarpTransition)		; $606a
	and $0f			; $606d
	cp TRANSITION_DEST_TIMEWARP		; $606f
	ret nz			; $6071

	ld a,(wWarpDestPos)		; $6072
	ld c,a			; $6075
	jr _removeBreakableTileForTimeWarp		; $6076

;;
; @addr{6078}
replacePollutionWithWaterIfPollutionFixed:
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $6078
	call checkGlobalFlag		; $607a
	ret z			; $607d

	ld a,(wTilesetFlags)		; $607e
	bit TILESETFLAG_BIT_OUTDOORS,a			; $6081
	ret z			; $6083

	ld de,@aboveWaterReplacement		; $6084
	and TILESETFLAG_UNDERWATER		; $6087
	jr z,+			; $6089
	ld de,@belowWaterReplacement		; $608b
+
	jr replaceTiles		; $608e

; @addr{6090}
@aboveWaterReplacement:
	.db $fc $eb
	.db $00
; @addr{6093}
@belowWaterReplacement:
	.db $3b $eb
	.db $00

;;
; @param de Structure for tiles to replace
; (format: tile to replace with, tile to replace, repeat, $00 to end)
; @addr{6096}
replaceTiles:
	ld a,(de)		; $6096
	or a			; $6097
	ret z			; $6098

	ld b,a			; $6099
	inc de			; $609a
	ld a,(de)		; $609b
	inc de			; $609c
	call findTileInRoom		; $609d
	jr nz,replaceTiles	; $60a0

	ld (hl),b		; $60a2
	ld c,a			; $60a3
	ld a,l			; $60a4
	or a			; $60a5
	jr z,replaceTiles	; $60a6
--
	dec l			; $60a8
	ld a,c			; $60a9
	call backwardsSearch		; $60aa
	jr nz,replaceTiles	; $60ad

	ld (hl),b		; $60af
	ld c,a			; $60b0
	ld a,l			; $60b1
	or a			; $60b2
	jr z,replaceTiles	; $60b3
	jr --			; $60b5

;;
; Substitutes various tiles when particular room flag bits (0-3, 7) are set.
; @addr{60b7}
applyStandardTileSubstitutions:
	call getThisRoomFlags		; $60b7
	ldh (<hFF8B),a	; $60ba
	ld hl,@bit0		; $60bc
	bit 0,a			; $60bf
	call nz,@locFunc		; $60c1

	ld hl,@bit1		; $60c4
	ldh a,(<hFF8B)	; $60c7
	bit 1,a			; $60c9
	call nz,@locFunc		; $60cb

	ld hl,@bit2		; $60ce
	ldh a,(<hFF8B)	; $60d1
	bit 2,a			; $60d3
	call nz,@locFunc		; $60d5

	ld hl,@bit3		; $60d8
	ldh a,(<hFF8B)	; $60db
	bit 3,a			; $60dd
	call nz,@locFunc		; $60df

	ld hl,@bit7		; $60e2
	ldh a,(<hFF8B)	; $60e5
	bit 7,a			; $60e7
	ret z			; $60e9
@locFunc:
	ld a,(wActiveCollisions)		; $60ea
	rst_addDoubleIndex			; $60ed
	ldi a,(hl)		; $60ee
	ld h,(hl)		; $60ef
	ld l,a			; $60f0
	ld e,l			; $60f1
	ld d,h			; $60f2
	jr replaceTiles			; $60f3

; @addr{60f5}
@bit0:
	.dw @bit0Collisions0
	.dw @bit0Collisions1
	.dw @bit0Collisions2
	.dw @bit0Collisions3
	.dw @bit0Collisions4
	.dw @bit0Collisions5
; @addr{6101}
@bit1:
	.dw @bit1Collisions0
	.dw @bit1Collisions1
	.dw @bit1Collisions2
	.dw @bit1Collisions3
	.dw @bit1Collisions4
	.dw @bit1Collisions5
; @addr{610d}
@bit2:
	.dw @bit2Collisions0
	.dw @bit2Collisions1
	.dw @bit2Collisions2
	.dw @bit2Collisions3
	.dw @bit2Collisions4
	.dw @bit2Collisions5
; @addr{6119}
@bit3:
	.dw @bit3Collisions0
	.dw @bit3Collisions1
	.dw @bit3Collisions2
	.dw @bit3Collisions3
	.dw @bit3Collisions4
	.dw @bit3Collisions5
; @addr{6125}
@bit7:
	.dw @bit7Collisions0
	.dw @bit7Collisions1
	.dw @bit7Collisions2
	.dw @bit7Collisions3
	.dw @bit7Collisions4
	.dw @bit7Collisions5

@bit0Collisions0:
@bit0Collisions4:
@bit0Collisions5:
	.db $00
@bit0Collisions1:
@bit0Collisions2:
	.db $34 $30 ; Bombable walls, key doors (up)
	.db $34 $38
	.db $a0 $70
	.db $a0 $74
	.db $00
@bit0Collisions3:
	.db $00

@bit1Collisions0:
@bit1Collisions4:
@bit1Collisions5:
	.db $00
@bit1Collisions1:
@bit1Collisions2:
	.db $35 $31 ; Bombable walls, key doors (right)
	.db $35 $39
	.db $35 $68
	.db $a0 $71
	.db $a0 $75
@bit1Collisions3:
	.db $00

@bit2Collisions0:
@bit2Collisions5:
@bit2Collisions4:
	.db $00
@bit2Collisions1:
@bit2Collisions2:
	.db $36 $32 ; Bombable walls, key doors (down)
	.db $36 $3a
	.db $a0 $72
	.db $a0 $76
@bit2Collisions3:
	.db $00

@bit3Collisions0:
@bit3Collisions4:
@bit3Collisions5:
	.db $00
@bit3Collisions1:
@bit3Collisions2:
	.db $37 $33 ; Bombable walls, key doors (left)
	.db $37 $3b
	.db $37 $69
	.db $a0 $73
	.db $a0 $77
@bit3Collisions3:
	.db $00

@bit7Collisions0:
	.db $dd $c1 ; Cave door under rock? (Is this a bug?)
	.db $d2 $c2 ; Soil under rock
	.db $d7 $c4 ; Portal under rock
	.db $dc $c6 ; Grave pushed onto land
	.db $d2 $c7 ; Soil under bush
	.db $d7 $c9 ; Soil under bush
	.db $d2 $cb ; Soil under earth
	.db $dc $cf ; Stairs under burnable tree
	.db $dd $d1 ; Bombable cave door
@bit7Collisions1:
	.db $00
@bit7Collisions2:
	.db $a0 $1e ; Keyblock
	.db $44 $42 ; Appearing upward stairs
	.db $45 $43 ; Appearing downward stairs
	.db $46 $40 ; Appearing upward stairs in wall
	.db $47 $41 ; Appearing downward stairs in wall
@bit7Collisions3:
@bit7Collisions4:
@bit7Collisions5:
	.db $00

;;
; Updates the toggleable blocks to the correct state when loading a room.
; @addr{617c}
replaceToggleBlocks:
	call checkDungeonUsesToggleBlocks		; $617c
	ret z			; $617f

	callab roomGfxChanges.func_02_7a77		; $6180
	ld de,@state1		; $6188
	ld a,(wToggleBlocksState)		; $618b
	or a			; $618e
	jr nz,+			; $618f
	ld de,@state2		; $6191
+
	jp replaceTiles		; $6194

; @addr{6197}
@state1:
	.db $0f $29
	.db $28 $0e
	.db $00
; @addr{619c}
@state2:
	.db $0e $28
	.db $29 $0f
	.db $00

;;
; Does the necessary tile changes if underwater in jabu-jabu.
; @addr{61a1}
replaceJabuTilesIfUnderwater:
	ld a,(wDungeonIndex)		; $61a1
	cp $07			; $61a4
	ret nz			; $61a6

	ld a,(wTilesetFlags)		; $61a7
	and TILESETFLAG_SIDESCROLL			; $61aa
	ret nz			; $61ac

	; Only substitute tiles if on the first non-underwater floor
	ld a,(wDungeonFloor)		; $61ad
	ld b,a			; $61b0
	ld a,(wJabuWaterLevel)		; $61b1
	and $07			; $61b4
	cp b			; $61b6
	ret nz			; $61b7

	ld de,@data1		; $61b8
	call replaceTiles		; $61bb
	ld de,@data2		; $61be
	jp replaceTiles		; $61c1

; @addr{61c4}
@data1:
	.db $fa $f3 ; holes -> shallow water
	.db $fa $f4
	.db $fa $f5
	.db $fa $f6
	.db $fa $f7
	.db $00

; @addr{61cf}
@data2:
	.db $fc $48 ; floor-transfer holes -> deep water
	.db $fc $49
	.db $fc $4a
	.db $fc $4b
	.db $00

;;
; Replaces a shutter link is about to walk on to with empty floor.
; @addr{61d8}
replaceShutterForLinkEntering:
	ldbc >wRoomLayout, (LARGE_ROOM_HEIGHT-1)<<4 + (LARGE_ROOM_WIDTH-1)	; $61d8
--
	ld a,(bc)		; $61db
	push bc			; $61dc
	sub $78			; $61dd
	cp $08			; $61df
	call c,@temporarilyOpenDoor		; $61e1
	pop bc			; $61e4
	dec c			; $61e5
	jr nz,--		; $61e6
	ret			; $61e8

; Replaces a door at position bc with empty floor, and adds an interaction to
; re-close it when link moves away (for minecart doors only)
@temporarilyOpenDoor:
	ld de,@shutterData		; $61e9
	call addDoubleIndexToDe		; $61ec
	ld a,(de)		; $61ef
	ldh (<hFF8B),a	; $61f0
	inc de			; $61f2
	ld a,(de)		; $61f3
	ld e,a			; $61f4
	ld a,(wScrollMode)		; $61f5
	and $08			; $61f8
	jr z,@doneReplacement	; $61fa

	ld a,(wLinkObjectIndex)		; $61fc
	ld h,a			; $61ff
	ld a,(wScreenTransitionDirection)		; $6200
	xor $02			; $6203
	ld d,a			; $6205
	ld a,e			; $6206
	and $03			; $6207
	cp d			; $6209
	ret nz			; $620a

	ld a,(wScreenTransitionDirection)		; $620b
	bit 0,a			; $620e
	jr nz,@horizontal			; $6210
; vertical
	and $02			; $6212
	ld l,<w1Link.xh		; $6214
	ld a,(hl)		; $6216
	jr nz,@down		; $6217
@up:
	and $f0			; $6219
	swap a			; $621b
	or $a0			; $621d
	jr @doReplacement		; $621f
@down:
	and $f0			; $6221
	swap a			; $6223
	jr @doReplacement		; $6225

@horizontal:
	and $02			; $6227
	ld l,<w1Link.yh		; $6229
	ld a,(hl)		; $622b
	jr nz,@left	; $622c
@right:
	and $f0			; $622e
	jr @doReplacement		; $6230
@left:
	and $f0			; $6232
	or $0e			; $6234

@doReplacement:
	; Only replace if link is standing on the tile.
	cp c			; $6236
	jr nz,@doneReplacement	; $6237

	push bc			; $6239
	ld c,a			; $623a
	ld a,(bc)		; $623b
	sub $78			; $623c
	cp $08			; $623e
	jr nc,+			; $6240

	ldh a,(<hFF8B)	; $6242
	ld (bc),a		; $6244
+
	pop bc			; $6245

@doneReplacement:
	; If bit 7 is set, don't add an auto-shutter interaction.
	ld a,e			; $6246
	bit 7,a			; $6247
	ret nz			; $6249

	and $7f			; $624a
	ld e,a			; $624c

	; If not in a dungeon, don't add an auto-shutter.
	ld a,(wTilesetFlags)		; $624d
	bit TILESETFLAG_BIT_DUNGEON,a			; $6250
	ret z			; $6252

	call getFreeInteractionSlot		; $6253
	ret nz			; $6256

	ld (hl),$1e		; $6257
	inc l			; $6259
	ld (hl),e		; $625a
	ld l,Interaction.yh		; $625b
	ld (hl),c		; $625d
	ret			; $625e

; Data format:
; Byte 1 - tile to replace shutter with
; Byte 2 - bit 7: don't auto-close, bits 0-6: low byte of interaction id
; @addr{625f}
@shutterData:
	.db $a0 $80 ; Normal shutters
	.db $a0 $81
	.db $a0 $82
	.db $a0 $83
	.db $5e $0c ; Minecart shutters
	.db $5d $0d
	.db $5e $0e
	.db $5d $0f

;;
; @addr{626f}
replaceOpenedChest:
	call getThisRoomFlags		; $626f
	bit ROOMFLAG_BIT_ITEM,a			; $6272
	ret z			; $6274

	call getChestData		; $6275
	ld d,>wRoomLayout		; $6278
	ld a,TILEINDEX_CHEST_OPENED	; $627a
	ld (de),a		; $627c
	ret			; $627d

;;
; Replaces switch tiles and whatever they control if the switch is set.
; Groups 4 and 5 only.
; @addr{627e}
replaceSwitchTiles:
	ld hl,@group4SwitchData		; $627e
	ld a,(wActiveGroup)		; $6281
	sub NUM_SMALL_GROUPS			; $6284
	jr z,+			; $6286

	dec a			; $6288
	ret nz			; $6289

	ld hl,@group5SwitchData		; $628a
+
	ld a,(wActiveRoom)		; $628d
	ld b,a			; $6290
	ld a,(wSwitchState)		; $6291
	ld c,a			; $6294
	ld d,>wRoomLayout		; $6295
@next:
	ldi a,(hl)		; $6297
	or a			; $6298
	ret z			; $6299

	; Check room
	cp b			; $629a
	jr nz,@skip3Bytes	; $629b

	; Check if corresponding bit of wSwitchState is set
	ldi a,(hl)		; $629d
	and c			; $629e
	jr z,@skip2Bytes	; $629f

	ldi a,(hl)		; $62a1
	ld e,(hl)		; $62a2
	inc hl			; $62a3
	ld (de),a		; $62a4
	jr @next		; $62a5

@skip3Bytes:
	inc hl			; $62a7
@skip2Bytes:
	inc hl			; $62a8
	inc hl			; $62a9
	jr @next		; $62aa

; Data format:
; Room, Switch bit, new tile index, position of tile to replace

; @addr{62ac}
@group4SwitchData:
	.db $2f $02 $0b $79
	.db $2f $02 $5a $6c
	.db $3b $20 $af $79
	.db $4c $01 $0b $38
	.db $4e $02 $0b $68
	.db $53 $04 $0b $6a
	.db $72 $01 $af $8d
	.db $89 $04 $0b $62
	.db $89 $04 $5d $67
	.db $8f $08 $0b $81
	.db $8f $08 $5e $52
	.db $c7 $01 $0b $68
	.db $00

; @addr{62dd}
@group5SwitchData:
	.db $00

;;
; @addr{62de}
applySingleTileChanges:
	ld a,(wActiveRoom)		; $62de
	ld b,a			; $62e1
	call getThisRoomFlags		; $62e2
	ld c,a			; $62e5
	ld d,>wRoomLayout		; $62e6
	ld a,(wActiveGroup)		; $62e8
	ld hl,singleTileChangeGroupTable		; $62eb
	rst_addDoubleIndex			; $62ee
	ldi a,(hl)		; $62ef
	ld h,(hl)		; $62f0
	ld l,a			; $62f1
@next:
	; Check room
	ldi a,(hl)		; $62f2
	cp b			; $62f3
	jr nz,@notMatch		; $62f4

	ld a,(hl)		; $62f6
	cp $f0			; $62f7
	jr z,@unlinkedOnly	; $62f9

	cp $f1			; $62fb
	jr z,@linkedOnly	; $62fd

	cp $f2			; $62ff
	jr z,@finishedGameOnly	; $6301

	ld a,(hl)		; $6303
	and c			; $6304
	jr z,@notMatch		; $6305

@match:
	inc hl			; $6307
	ldi a,(hl)		; $6308
	ld e,a			; $6309
	ldi a,(hl)		; $630a
	ld (de),a		; $630b
	jr @next		; $630c

@notMatch:
	ld a,(hl)		; $630e
	or a			; $630f
	ret z			; $6310

	inc hl			; $6311
	inc hl			; $6312
	inc hl			; $6313
	jr @next		; $6314

@unlinkedOnly:
	call checkIsLinkedGame		; $6316
	jr nz,@notMatch		; $6319
	jr @match			; $631b

@linkedOnly:
	call checkIsLinkedGame		; $631d
	jr z,@notMatch		; $6320
	jr @match			; $6322

@finishedGameOnly:
	ld a,GLOBALFLAG_FINISHEDGAME		; $6324
	push hl			; $6326
	call checkGlobalFlag		; $6327
	pop hl			; $632a
	ret z			; $632b
	jr @match		; $632c

.include "data/singleTileChanges.s"

;;
; @addr{642c}
applyRoomSpecificTileChanges:
	ld a,(wActiveRoom)		; $642c
	ld hl,roomTileChangerCodeGroupTable		; $642f
	call findRoomSpecificData		; $6432
	ret nc			; $6435
	rst_jumpTable			; $6436
	.dw tileReplacement_group5Mapf5 ; $00
	.dw tileReplacement_group4Map1b ; $01
	.dw tileReplacement_group2Map7e ; $02
	.dw tileReplacement_group4Map4c ; $03
	.dw tileReplacement_group4Map4e ; $04
	.dw tileReplacement_group4Map59 ; $05
	.dw tileReplacement_group4Map60 ; $06
	.dw tileReplacement_group4Map52 ; $07
	.dw tileReplacement_group0Map38 ; $08
	.dw tileReplacement_group1Map38 ; $09
	.dw tileReplacement_group5Map38 ; $0a
	.dw tileReplacement_group5Map25 ; $0b
	.dw tileReplacement_group5Map43 ; $0c
	.dw tileReplacement_group5Map4c ; $0d
	.dw tileReplacement_group5Map5c ; $0e
	.dw tileReplacement_group5Map4d ; $0f
	.dw tileReplacement_group5Map5d ; $10
	.dw tileReplacement_group7Map4a ; $11
	.dw tileReplacement_group5Map95 ; $12
	.dw tileReplacement_group5Mapc3 ; $13
	.dw tileReplacement_group0Map5c ; $14
	.dw tileReplacement_group2Mapf7 ; $15
	.dw tileReplacement_group0Map73 ; $16
	.dw tileReplacement_group0Map48 ; $17
	.dw tileReplacement_group0Mapac ; $18
	.dw tileReplacement_group0Map2c ; $19
	.dw tileReplacement_group0Map1c ; $1a
	.dw tileReplacement_group0Mapba ; $1b
	.dw tileReplacement_group0Mapaa ; $1c
	.dw tileReplacement_group0Mapcc ; $1d
	.dw tileReplacement_group0Mapbc ; $1e
	.dw tileReplacement_group0Mapda ; $1f
	.dw tileReplacement_group0Mapca ; $20
	.dw tileReplacement_group0Map61 ; $21
	.dw tileReplacement_group0Map51 ; $22
	.dw tileReplacement_group0Map54 ; $23
	.dw tileReplacement_group0Map25 ; $24
	.dw tileReplacement_group0Map3a ; $25
	.dw tileReplacement_group0Map0b ; $26
	.dw tileReplacement_group5Mapb9 ; $27
	.dw tileReplacement_group1Map27 ; $28
	.dw tileReplacement_group5Mapc2 ; $29
	.dw tileReplacement_group5Mape3 ; $2a
	.dw tileReplacement_group2Map90 ; $2b
	.dw tileReplacement_group1Map8c ; $2c
	.dw tileReplacement_group4Mapc7 ; $2d
	.dw tileReplacement_group4Mapc9 ; $2e
	.dw tileReplacement_group2Map9e ; $2f
	.dw tileReplacement_group0Mape0 ; $30
	.dw tileReplacement_group0Mape1 ; $31
	.dw tileReplacement_group0Mape2 ; $32
	.dw tileReplacement_group4Mapea ; $33
	.dw tileReplacement_group1Map58 ; $34
	.dw tileReplacement_group0Map98 ; $35
	.dw tileReplacement_group0Map76 ; $36
	.dw tileReplacement_group0Mapa5 ; $37

; @addr{$124a7}
roomTileChangerCodeGroupTable:
	.dw roomTileChangerCodeGroup0Data
	.dw roomTileChangerCodeGroup1Data
	.dw roomTileChangerCodeGroup2Data
	.dw roomTileChangerCodeGroup3Data
	.dw roomTileChangerCodeGroup4Data
	.dw roomTileChangerCodeGroup5Data
	.dw roomTileChangerCodeGroup6Data
	.dw roomTileChangerCodeGroup7Data

; @addr{$124b7}
roomTileChangerCodeGroup0Data:
	.db $38 $08
	.db $48 $17
	.db $5c $14
	.db $73 $16
	.db $ac $18
	.db $2c $19
	.db $1c $1a
	.db $ba $1b
	.db $aa $1c
	.db $cc $1d
	.db $bc $1e
	.db $da $1f
	.db $ca $20
	.db $61 $21
	.db $51 $22
	.db $54 $23
	.db $25 $24
	.db $3a $25
	.db $0b $26
	.db $e0 $30
	.db $e1 $31
	.db $e2 $32
	.db $98 $35
	.db $a5 $37
	.db $76 $36
	.db $00
; @addr{$124ea}
roomTileChangerCodeGroup1Data:
	.db $38 $09
	.db $27 $28
	.db $8c $2c
	.db $58 $34
	.db $00
; @addr{$124f3}
roomTileChangerCodeGroup2Data:
	.db $f7 $15
	.db $90 $2b
	.db $9e $2f
	.db $7e $02
	.db $00
; @addr{$124fc}
roomTileChangerCodeGroup3Data:
	.db $00
; @addr{$124fd}
roomTileChangerCodeGroup4Data:
	.db $1b $01
	.db $4c $03
	.db $4e $04
	.db $59 $05
	.db $60 $06
	.db $52 $07
	.db $c7 $2d
	.db $c9 $2e
	.db $ea $33
	.db $00
; @addr{$12510}
roomTileChangerCodeGroup5Data:
	.db $f5 $00
	.db $38 $0a
	.db $25 $0b
	.db $43 $0c
	.db $4c $0d
	.db $5c $0e
	.db $71 $0e
	.db $4d $0f
	.db $5d $10
	.db $72 $10
	.db $95 $12
	.db $c3 $13
	.db $b9 $27
	.db $c2 $29
	.db $e3 $2a
	.db $00
; @addr{$1252f}
roomTileChangerCodeGroup6Data:
	.db $00
; @addr{$12530}
roomTileChangerCodeGroup7Data:
	.db $4a $11
	.db $00

;;
; Opens advance shop
; @addr{6533}
tileReplacement_group1Map58:
	ldh a,(<hGameboyType)	; $6533
	rlca			; $6535
	ret nc			; $6536
	ld hl,wRoomLayout + $35		; $6537
	ld (hl),$de		; $653a
	ret			; $653c

;;
; Twinrova/ganon fight
; @addr{653d}
tileReplacement_group5Mapf5:
	ld a,(wTwinrovaTileReplacementMode)		; $653d
	or a			; $6540
	ret z			; $6541
	dec a			; $6542
	jr z,@val01		; $6543
	dec a			; $6545
	jr z,@fillWithIce		; $6546
	dec a			; $6548
	jr z,@val03		; $6549

	; Fill the room with the seizure tiles?
	xor a			; $654b
	ld (wTwinrovaTileReplacementMode),a		; $654c
	ld hl,@seizureTiles		; $654f
	jp fillRectInRoomLayout		; $6552

; @addr{6555}
@seizureTiles:
	.db $00, LARGE_ROOM_HEIGHT, LARGE_ROOM_WIDTH, $aa

@val03:
	ld (wTwinrovaTileReplacementMode),a		; $6559
	ld a,GFXH_b9		; $655c
	jp loadGfxHeader		; $655e

@fillWithIce:
	ld (wTwinrovaTileReplacementMode),a		; $6561
	ld hl,@iceTiles		; $6564
	jp fillRectInRoomLayout		; $6567

@iceTiles:
	.db $11, LARGE_ROOM_HEIGHT-2, LARGE_ROOM_WIDTH-2, $8a

@val01:
	ld (wTwinrovaTileReplacementMode),a		; $656e
	ld a,GFXH_b8		; $6571
	jp loadGfxHeader		; $6573

;;
; Dungeon 1 in the room where torches light up to make stairs appear
; @addr{6576}
tileReplacement_group4Map1b:
	call getThisRoomFlags		; $6576
	and $80			; $6579
	ret z			; $657b

	ld hl,wRoomLayout + $1a		; $657c
	ld a,TILEINDEX_LIT_TORCH		; $657f
	ldi (hl),a		; $6581
	inc l			; $6582
	ld (hl),a		; $6583

	; The programmers forgot a "ret" here! This causes a bug where chests
	; are inserted into dungeon 1 after buying everything from the secret
	; shop.

;;
; Secret shop: replace item area with blank floor and 2 chests, if you've
; already bought everything.
; @addr{6584}
tileReplacement_group2Map7e:
	ld a,(wBoughtShopItems1)		; $6584
	and $0f			; $6587
	cp $0f			; $6589
	ret nz			; $658b

	ld hl,@data		; $658c
	call fillRectInRoomLayout		; $658f
	ld a,TILEINDEX_CHEST		; $6592
	ld hl,wRoomLayout + $25		; $6594
	ld (hl),a		; $6597
	ld l,$27		; $6598
	ld (hl),a		; $659a
	ld l,$32		; $659b
	ld (hl),$a0		; $659d
	ret			; $659f

@data:
	.db $13 $03 $06 $a0

;;
; Hero's cave: make a bridge appear
; @addr{65a4}
tileReplacement_group4Mapc9:
	call getThisRoomFlags		; $65a4
	and ROOMFLAG_40			; $65a7
	ret z			; $65a9

	ld hl,wRoomLayout + $27		; $65aa
	ld a,$6d		; $65ad
	jp set4Bytes		; $65af

;;
; Hero's cave: make a bridge appear, make another disappear if a switch is set
; @addr{65b2}
tileReplacement_group4Mapc7:
	ld hl,wSwitchState		; $65b2
	bit 0,(hl)		; $65b5
	ret nz			; $65b7

	ld hl,wRoomLayout + $27		; $65b8
	ld a,$6d		; $65bb
	call set4Bytes		; $65bd
	ld a,$f4		; $65c0
	ld l,$3d		; $65c2
	ld (hl),a		; $65c4
	ld l,$4d		; $65c5
	ld (hl),a		; $65c7
	ld l,$5d		; $65c8
	ld (hl),a		; $65ca
	ld l,$6d		; $65cb
	ld (hl),a		; $65cd
	ret			; $65ce

;;
; D3, left of miniboss: deal with bridges
; @addr{65cf}
tileReplacement_group4Map4c:
	ld hl,wSwitchState		; $65cf
	bit 0,(hl)		; $65d2
	ret nz			; $65d4

	ld hl,wRoomLayout + $43		; $65d5
	ld a,$6a		; $65d8
	ld (hl),a		; $65da
	ld l,$53		; $65db
	ld (hl),a		; $65dd
	ld l,$63		; $65de
	ld (hl),a		; $65e0
	ld l,$76		; $65e1
	ld a,$f4		; $65e3
	jp set4Bytes		; $65e5

;;
; D3, left, down from miniboss: deal with bridges
; @addr{65e8}
tileReplacement_group4Map4e:
	ld hl,wSwitchState		; $65e8
	bit 1,(hl)		; $65eb
	ret z			; $65ed

	ld hl,wRoomLayout + $36		; $65ee
	ld a,$6d		; $65f1
	call set4Bytes		; $65f3
	ld a,$f4		; $65f6
	ld l,$42		; $65f8
	ld (hl),a		; $65fa
	ld l,$52		; $65fb
	ld (hl),a		; $65fd
	ld l,$62		; $65fe
	ld (hl),a		; $6600
	ld l,$4c		; $6601
	ld (hl),a		; $6603
	ld l,$5c		; $6604
	ld (hl),a		; $6606
	ld l,$6c		; $6607
	ld (hl),a		; $6609
	ret			; $660a

;;
; D3, right of seed shooter room: set torch lit
; @addr{660b}
tileReplacement_group4Map59:
	call getThisRoomFlags		; $660b
	and $80			; $660e
	ret z			; $6610

	ld de,@replacementTiles		; $6611
	jp replaceTiles		; $6614

; @addr{6617}
@replacementTiles:
	.db $09 $08 ; Replace unlit torch with lit
	.db $00

;;
; D3, upper spinner room: remove spinner if crystals broken (doesn't remove
; interaction itself)
; @addr{661a}
tileReplacement_group4Map60:
	ld a,GLOBALFLAG_D3_CRYSTALS		; $661a
	call checkGlobalFlag		; $661c
	ret z			; $661f

	ld hl,@rect		; $6620
	call fillRectInRoomLayout		; $6623
	call getThisRoomFlags		; $6626
	and ROOMFLAG_ITEM			; $6629
	ld a,TILEINDEX_CHEST_OPENED	; $662b
	jr nz,+			; $662d
	inc a			; $662f
+
	ld hl,wRoomLayout + $57		; $6630
	ld (hl),a		; $6633
	ld l,$34		; $6634
	ld (hl),$1d		; $6636
	ld l,$3a		; $6638
	ld (hl),$1d		; $663a
	ld l,$74		; $663c
	ld (hl),$1d		; $663e
	ld l,$7a		; $6640
	ld (hl),$1d		; $6642
	ret			; $6644
; @addr{6645}
@rect:
	.db $34 $05 $07 $a0

;;
; D3, lower spinner room: add spinner if crystals broken (doesn't add
; interaction itself)
; @addr{6649}
tileReplacement_group4Map52:
	ld a,GLOBALFLAG_D3_CRYSTALS		; $6649
	call checkGlobalFlag		; $664b
	ret z			; $664e

	; Load the room above instead of this room
	ld a,$60		; $664f
	ld (wLoadingRoom),a		; $6651
	callab loadRoomLayout		; $6654
	ret			; $665c

;;
; Maku tree present
; @addr{665d}
tileReplacement_group0Map38:
	ld a,GLOBALFLAG_MAKU_TREE_SAVED		; $665d
	call checkGlobalFlag		; $665f
	ret z			; $6662
	jr +			; $6663
;;
; Maku tree past
; @addr{6665}
tileReplacement_group1Map38:
	call getThisRoomFlags		; $6665
	bit 7,(hl)		; $6668
	ret z			; $666a
+
	; Clear barrier
	ld hl,wRoomLayout + $73		; $666b
	ld a,$f9		; $666e
	jp set4Bytes		; $6670

;;
; Present: Screen below maku tree
; @addr{6673}
tileReplacement_group0Map48:
	ld a,GLOBALFLAG_MAKU_TREE_SAVED		; $6673
	call checkGlobalFlag		; $6675
	ret z			; $6678

	; Clear barrier
	ld hl,wRoomLayout + $03		; $6679
	ld a,$3a		; $667c
	jp set4Bytes		; $667e

;;
; D6 before boss room: create bridge
; @addr{6681}
tileReplacement_group5Map38:
	call getThisRoomFlags		; $6681
	and ROOMFLAG_40			; $6684
	ret z			; $6686

	ld a,$6a		; $6687
	ld hl,wRoomLayout + $39		; $6689
	ld (hl),a		; $668c
	ld l,$49		; $668d
	ld (hl),a		; $668f
	ld l,$59		; $6690
	ld (hl),a		; $6692
	ld l,$69		; $6693
	ld (hl),a		; $6695
	ret			; $6696

;;
; D6 present: screen with retracting wall
; @addr{6697}
tileReplacement_group5Map25:
	call getThisRoomFlags		; $6697
	and $40			; $669a
	ret nz			; $669c

	ld hl,_d6RetractingWallRectPresent		; $669d
	call fillRectInRoomLayout		; $66a0
	jr ++			; $66a3

; @addr{66a5}
_d6RetractingWallRectPresent:
	.db $17 $09 $04 $a6
; @addr{66a9}
_d6RetractingWallRectPast:
	.db $17 $09 $04 $a7

;;
; D6 past: screen with retracting walls
; @addr{66ad}
tileReplacement_group5Map43:
	call getThisRoomFlags		; $66ad
	and $40			; $66b0
	jr nz,@pastRetracted		; $66b2

	ld hl,_d6RetractingWallRectPast		; $66b4
	call fillRectInRoomLayout		; $66b7
++
	ld hl,@wallEdge1		; $66ba
	call fillRectInRoomLayout		; $66bd
	ld hl,@wallEdge2		; $66c0
	jp fillRectInRoomLayout		; $66c3

@wallEdge1:
	.db $1b $09 $01 $b3

@wallEdge2:
	.db $16 $09 $01 $b1

; Light the torches.
@pastRetracted:
	ld de,@tilesToReplace		; $66ce
	jp replaceTiles		; $66d1

@tilesToReplace:
	.db $09 $08 ; Replace unlit torch with lit
	.db $00

;;
; D8: room with retracting wall
; @addr{66d7}
tileReplacement_group5Map95:
	call getThisRoomFlags		; $66d7
	and $40			; $66da
	ret nz			; $66dc

	ld hl,wRoomLayout + $4d		; $66dd
	ld (hl),$b4		; $66e0
	inc l			; $66e2
	ld (hl),$b2		; $66e3
	ld hl,@wallInterior		; $66e5
	call fillRectInRoomLayout		; $66e8
	ld hl,@wallEdge		; $66eb
	jp fillRectInRoomLayout		; $66ee

@wallInterior:
	.db $5e $05 $01 $a7
@wallEdge:
	.db $5d $05 $01 $b1

;;
; Past: cave with goron elder
; Gets rid of a boulder and creates a shortcut
; @addr{66f9}
tileReplacement_group5Mapc3:
	call @func_04_672e		; $66f9
	call getThisRoomFlags		; $66fc
	and ROOMFLAG_40			; $66ff
	ret z			; $6701

	ld bc,@boulderReplacementTiles		; $6702
	ld hl,wRoomLayout + $31		; $6705
	call @locFunc		; $6708
	ld l,$41		; $670b
	call @locFunc		; $670d
	ld l,$51		; $6710
@locFunc:
	ld a,$05		; $6712
--
	ldh (<hFF8D),a	; $6714
	ld a,(bc)		; $6716
	inc bc			; $6717
	ldi (hl),a		; $6718
	ldh a,(<hFF8D)	; $6719
	dec a			; $671b
	jr nz,--		; $671c
	ret			; $671e

; @addr{671f}
@boulderReplacementTiles:
	.db $a2 $a1 $a2 $a1 $a2
	.db $a1 $a2 $a1 $a2 $a1
	.db $a2 $a1 $a2 $a1 $a2


;;
; If d5 is beaten, remove a wall to make the area easier to traverse. (This
; does not remove the boulder)
; @addr{672e}
@func_04_672e:
	ld a,$04		; $672e
	ld hl,wEssencesObtained		; $6730
	call checkFlag		; $6733
	ret z			; $6736

	ld hl,@newTiles		; $6737
	ld bc,wRoomLayout + $06		; $673a
	ld a,$04		; $673d
---
	ldh (<hFF8D),a	; $673f
	ld a,$04		; $6741
--
	ldh (<hFF8C),a	; $6743
	ldi a,(hl)		; $6745
	or a			; $6746
	jr z,+			; $6747
	ld (bc),a		; $6749
+
	inc bc			; $674a
	ldh a,(<hFF8C)	; $674b
	dec a			; $674d
	jr nz,--		; $674e

	ld a,$0c		; $6750
	call addAToBc		; $6752
	ldh a,(<hFF8D)	; $6755
	dec a			; $6757
	jr nz,---		; $6758
	ret			; $675a

; 4x4 grid of new tiles to insert ($00 means unchanged).
; @addr{675b}
@newTiles:
	.db $b0 $b0 $b0 $b0
	.db $ef $00 $00 $ef
	.db $ef $00 $00 $ef
	.db $b4 $b2 $b2 $b2

;;
; Past: cave in goron mountain with 2 chests
; @addr{676b}
tileReplacement_group2Mapf7:
	call getThisRoomFlags		; $676b
	bit ROOMFLAG_BIT_ITEM,(hl)		; $676e
	jr z,++			; $6770

	ld a,TILEINDEX_CHEST_OPENED	; $6772
	ld c,$14		; $6774
	call setTile		; $6776
	ld a,TILEINDEX_CHEST_OPENED	; $6779
	ld c,$16		; $677b
	jp setTile		; $677d
++
	ld a,(hl)		; $6780
	and $c0			; $6781
	cp $c0			; $6783
	ret z			; $6785

	bit 6,(hl)		; $6786
	jr z,+			; $6788

	ld a,(wSeedTreeRefilledBitset)		; $678a
	bit 0,a			; $678d
	ret nz			; $678f
+
	ld hl,@wallInsertion	; $6790
	ld bc,wRoomLayout + $03		; $6793
	ld a,$04		; $6796
---
	ldh (<hFF8D),a	; $6798
	ld a,$05		; $679a
--
	ldh (<hFF8C),a	; $679c
	ldi a,(hl)		; $679e
	ld (bc),a		; $679f
	inc bc			; $67a0
	ldh a,(<hFF8C)	; $67a1
	dec a			; $67a3
	jr nz,--	; $67a4

	ld a,$0b		; $67a6
	call addAToBc		; $67a8
	ldh a,(<hFF8D)	; $67ab
	dec a			; $67ad
	jr nz,---		; $67ae
	ret			; $67b0

; @addr{67b1}
@wallInsertion:
	.db $b9 $a7 $a7 $a7 $b8
	.db $b1 $a7 $a7 $a7 $b3
	.db $b1 $a7 $a7 $a7 $b3
	.db $b6 $b0 $b0 $b0 $b7

;;
; D7: 1st platform on floor 1
; @addr{67c5}
tileReplacement_group5Map4c:
	ld a,(wJabuWaterLevel)		; $67c5
	and $07			; $67c8
	ret z			; $67ca

	ld hl,@rect		; $67cb
	call fillRectInRoomLayout		; $67ce

	; Staircase going down
	ld l,$57		; $67d1
	ld (hl),$45		; $67d3
	ret			; $67d5

; @addr{67d6}
@rect:
	.db $35 $05 $05 $a2

;;
; D7: 2nd platform on floor 1
; @addr{67da}
tileReplacement_group5Map4d:
	ld a,(wJabuWaterLevel)		; $67da
	and $07			; $67dd
	ret z			; $67df

	ld hl,@rect		; $67e0
	jp fillRectInRoomLayout		; $67e3

; @addr{67e6}
@rect:
	.db $12 $05 $05 $a2

;;
; D7: Used in room $55c and $571. Makes the 1st platform appear if the water
; level is correct.
; @addr{67ea}
tileReplacement_group5Map5c:
	ld a,(wDungeonFloor)		; $67ea
	ld b,a			; $67ed
	ld a,(wJabuWaterLevel)		; $67ee
	and $07			; $67f1
	cp b			; $67f3
	ret nz			; $67f4

	ld de,@platformRect		; $67f5
	jp drawRectInRoomLayout		; $67f8

; @addr{67fb}
@platformRect:
	.db $35 $05 $05
	.db $c5 $c3 $c3 $c3 $c6
	.db $c2 $a0 $a0 $a0 $c4
	.db $c2 $a0 $10 $a0 $c4
	.db $c2 $a0 $a0 $a0 $c4
	.db $c7 $c1 $c1 $c1 $c8

;;
; D7: used is room $55d and $572. Makes the 2nd platform appear if the water
; level is correct.
; @addr{6817}
tileReplacement_group5Map5d:
	ld a,(wDungeonFloor)		; $6817
	ld b,a			; $681a
	ld a,(wJabuWaterLevel)		; $681b
	and $07			; $681e
	cp b			; $6820
	ret nz			; $6821

	ld de,@platformRect		; $6822
	jp drawRectInRoomLayout		; $6825

@platformRect:
	.db $12 $05 $05
	.db $c5 $c3 $c3 $c3 $c6
	.db $c2 $91 $96 $90 $c4
	.db $c2 $95 $db $94 $c4
	.db $c2 $9b $92 $9a $c4
	.db $c7 $c1 $c1 $c1 $c8

;;
; D7 miniboss room (except it's group 7 instead of 5?)
; Creates a ladder if the miniboss has been murdered.
; @addr{6844}
tileReplacement_group7Map4a:
	call getThisRoomFlags		; $6844
	and $80			; $6847
	ret z			; $6849

	ld hl,@ladderRect		; $684a
	jp fillRectInRoomLayout		; $684d

; @addr{5850}
@ladderRect:
	.db $0d $0a $01 $18

;;
; Graveyard: Clear the fence if opened
; @addr{6854}
tileReplacement_group0Map5c:
	call getThisRoomFlags	; $6854
	and $80			; $6857
	ret z			; $6859

	ld hl,wRoomLayout + $34		; $685a
	ld a,$3a		; $685d
	ld (hl),a		; $685f
	ld l,$43		; $6860
	jp set3Bytes		; $6862

;;
; Present forest above d2: clear rubble
; @addr{6865}
tileReplacement_group0Map73:
	call getThisRoomFlags		; $6865
	and $80			; $6868
	ret z			; $686a

	ld hl,wRoomLayout + $73		; $686b
	ld (hl),$3a		; $686e
	inc l			; $6870
	ld (hl),$10		; $6871
	inc l			; $6873
	ld (hl),$11		; $6874
	inc l			; $6876
	ld (hl),$12		; $6877
	inc l			; $6879
	ld (hl),$3a		; $687a
	ret			; $687c

;;
; Present Tokay: remove scent tree if not planted
; @addr{687d}
tileReplacement_group0Mapac:
	call getThisRoomFlags		; $687d
	and $80			; $6880
	ret nz			; $6882

	ld hl,wRoomLayout + $33		; $6883
	ld a,$af		; $6886
	ldi (hl),a		; $6888
	ld (hl),a		; $6889
	ld l,$43		; $688a
	ldi (hl),a		; $688c
	ld (hl),a		; $688d
	ret			; $688e

;;
; Rolling ridge present screen with vine
; @addr{688f}
tileReplacement_group0Map2c:
	ld bc,$0017		; $688f
	call getVinePosition		; $6892
	jp nz,setTileToWitheredVine		; $6895
	ld l,$06		; $6898
	ld de,@vineEdgeReplacements	; $689a
	jp replaceVineTiles		; $689d

; @addr{68a0}
@vineEdgeReplacements:
	.db $5d $60
	.db $00

;;
; Rolling ridge present, above the screen with a vine
; @addr{68a3}
tileReplacement_group0Map1c:
	ld bc,$0017		; $68a3
	call getVinePosition		; $68a6
	ret nz			; $68a9
	ld l,$66		; $68aa
	ld de,@vineEdgeReplacements		; $68ac
	jp replaceVineTiles		; $68af

; @addr{68b2}
@vineEdgeReplacements:
	.db $5b $45
	.db $4d $55
	.db $00

;;
; Tokay island present, D3 entrance screen (has a vine)
; @addr{68b7}
tileReplacement_group0Mapba:
	ld bc,$0218		; $68b7
	call getVinePosition		; $68ba
	jp nz,setTileToWitheredVine		; $68bd
	ld l,$07		; $68c0
	ld de,@vineEdgeReplacements		; $68c2
	call replaceVineTiles		; $68c5
	ld a,$8b		; $68c8
	ld (wRoomLayout+$18),a		; $68ca
	ret			; $68cd

; @addr{68ce}
@vineEdgeReplacements:
	.db $61 $60
	.db $00

;;
; Tokay island present, above D3 entrance screen
; @addr{68d1}
tileReplacement_group0Mapaa:
	ld bc,$0218		; $68d1
	call getVinePosition		; $68d4
	ret nz			; $68d7

	ld l,$77		; $68d8
	ld de,@vineEdgeReplacements	; $68da
	jp replaceVineTiles		; $68dd

; @addr{68e0}
@vineEdgeReplacements:
	.db $46 $45
	.db $00

;;
; Tokay island present, 2nd vine screen
; @addr{68e3}
tileReplacement_group0Mapcc:
	ld bc,$0311		; $68e3
	call getVinePosition		; $68e6
	jp nz,setTileToWitheredVine		; $68e9

	ld l,$00		; $68ec
	ld de,@vineEdgeReplacements	; $68ee
	jp replaceVineTiles		; $68f1

; @addr{68f4}
@vineEdgeReplacements:
	.db $61 $5d
	.db $00

;;
; Tokay island present, above 2nd vine screen
; @addr{68f7}
tileReplacement_group0Mapbc:
	ld bc,$0311		; $68f7
	call getVinePosition		; $68fa
	ret nz			; $68fd

	ld l,$70		; $68fe
	ld de,@vineEdgeReplacements	; $6900
	jp replaceVineTiles		; $6903

; @addr{6906}
@vineEdgeReplacements:
	.db $46 $5c
	.db $00

;;
; Tokay island present, 3rd vine screen
; @addr{6909}
tileReplacement_group0Mapda:
	ld bc,$0418		; $6909
	call getVinePosition		; $690c
	jp nz,setTileToWitheredVine		; $690f

	ld l,$07		; $6912
	ld de,@vineEdgeReplacements	; $6914
	jp replaceVineTiles		; $6917

; @addr{691a}
@vineEdgeReplacements:
	.db $61 $60
	.db $00

;;
; Tokay island present, above 3rd vine screen
; @addr{691d}
tileReplacement_group0Mapca:
	ld bc,$0418		; $691d
	call getVinePosition		; $6920
	ret nz			; $6923

	ld l,$77		; $6924
	ld de,@videEdgeReplacements	; $6926
	jp replaceVineTiles		; $6929

; @addr{692c}
@videEdgeReplacements:
	.db $46 $45
	.db $00

;;
; Talus Peaks Present, has 2 vines
; @addr{692f}
tileReplacement_group0Map61:
	ld bc,$0122		; $692f
	call getVinePosition		; $6932
	jr z,@vine1			; $6935

	ld bc,$0127		; $6937
	call getVinePosition		; $693a
	jp nz,setTileToWitheredVine		; $693d
@vine2:
	ld hl,wRoomLayout + $06		; $6940
	ld (hl),$4d		; $6943
	inc l			; $6945
	ld (hl),$d5		; $6946
	inc l			; $6948
	ld (hl),$55		; $6949
	ld l,$16		; $694b
	ld (hl),$5d		; $694d
	inc l			; $694f
	ld (hl),$d6		; $6950
	inc l			; $6952
	ld (hl),$60		; $6953
	ld l,$27		; $6955
	ld (hl),$8d		; $6957
	ret			; $6959
@vine1:
	ld hl,wRoomLayout + $01		; $695a
	ld (hl),$56		; $695d
	inc l			; $695f
	ld (hl),$d5		; $6960
	inc l			; $6962
	ld (hl),$4d		; $6963
	ld l,$11		; $6965
	ld (hl),$61		; $6967
	inc l			; $6969
	ld (hl),$d6		; $696a
	inc l			; $696c
	ld (hl),$5d		; $696d
	ld l,$22		; $696f
	ld (hl),$8d		; $6971
	ret			; $6973

;;
; Screen above talus peaks vines
; @addr{6974}
tileReplacement_group0Map51:
	ld bc,$0122		; $6974
	call getVinePosition		; $6977
	jr z,@vines1		; $697a

	ld bc,$0127		; $697c
	call getVinePosition		; $697f
	ret nz			; $6982
@vines2:
	ld hl,wRoomLayout + $76		; $6983
	ld (hl),$5b		; $6986
	inc l			; $6988
	ld (hl),$d4		; $6989
	inc l			; $698b
	ld (hl),$45		; $698c
	ret			; $698e
@vines1:
	ld hl,wRoomLayout + $71		; $698f
	ld (hl),$46		; $6992
	inc l			; $6994
	ld (hl),$d4		; $6995
	inc l			; $6997
	ld (hl),$5c		; $6998
	ret			; $699a

;;
; Replaces tiles that should be turned into vines.
; @param de Data structure with values to replace the sides of the vine with.
; Format: left byte, right byte, repeat, $00 to end
; @param l Top-left of where to apply the data at de.
; @addr{699b}
replaceVineTiles:
	ld h,>wRoomLayout		; $699b
--
	ld a,(de)		; $699d
	or a			; $699e
	jr z,++			; $699f

	ld a,(de)		; $69a1
	inc de			; $69a2
	ldi (hl),a		; $69a3
	inc l			; $69a4
	ld a,(de)		; $69a5
	inc de			; $69a6
	ldi (hl),a		; $69a7
	ld a,$0d		; $69a8
	rst_addAToHl			; $69aa
	jr --			; $69ab
++
	ld de,@vineReplacements		; $69ad
	call replaceTiles		; $69b0

	; Find the vine base
	ld a,$d6		; $69b3
	call findTileInRoom		; $69b5
	ret nz			; $69b8

	; Set the tile below that to $8d which completes the vine base
	ld a,l			; $69b9
	add $10			; $69ba
	ld l,a			; $69bc
	ld (hl),$8d		; $69bd
	ret			; $69bf

; @addr{69c0}
@vineReplacements:
	.db $d4 $05 ; Top of cliff -> top of vine
	.db $d5 $8e ; Body
	.db $d6 $8f ; Bottom
	.db $00


;;
; Retrieve a position from [hl], set the tile at that position to a withered
; vine.
; @addr{69c7}
setTileToWitheredVine:
	ld l,(hl)		; $69c7
	ld h,>wRoomLayout		; $69c8
	ld a,(hl)		; $69ca
	push hl			; $69cb
	call retrieveTileCollisionValue		; $69cc
	pop hl			; $69cf
	or a			; $69d0
	ret nz			; $69d1
	ld (hl),$8c		; $69d2
	ret			; $69d4

;;
; Get the position of vine B and compare with C.
; @addr{69d5}
getVinePosition:
	ld a,b			; $69d5
	ld hl,wVinePositions		; $69d6
	rst_addAToHl			; $69d9
	ld a,(hl)		; $69da
	cp c			; $69db
	ret			; $69dc

;;
; @addr{69dd}
initializeVinePositions:
	ld hl,wVinePositions		; $69dd
	ld de,@defaultVinePositions	; $69e0
	ld b,$06		; $69e3
	jp copyMemoryReverse		; $69e5

@defaultVinePositions:
	.include "build/data/defaultVinePositions.s"

;;
; Present, bridge to nuun highlands
; @addr{69ee}
tileReplacement_group0Map54:
	xor a			; $69ee
	ld (wSwitchState),a		; $69ef
	call getThisRoomFlags		; $69f2
	and $40			; $69f5
	ret z			; $69f7

	ld a,$1d		; $69f8
	ld hl,wRoomLayout + $43		; $69fa
	ldi (hl),a		; $69fd
	ldi (hl),a		; $69fe
	ldi (hl),a		; $69ff
	ld a,$1e		; $6a00
	ld l,$53		; $6a02
	ldi (hl),a		; $6a04
	ldi (hl),a		; $6a05
	ld (hl),a		; $6a06
	ld a,$9e		; $6a07
	ld (wRoomLayout+$68),a		; $6a09
	ret			; $6a0c

;;
; Present, right side of bridge to symmetry city
; @addr{6a0d}
tileReplacement_group0Map25:
	ld a,GLOBALFLAG_SYMMETRY_BRIDGE_BUILT		; $6a0d
	call checkGlobalFlag		; $6a0f
	ret z			; $6a12

	ld a,$1d		; $6a13
	ld hl,wRoomLayout + $50		; $6a15
	ldi (hl),a		; $6a18
	ldi (hl),a		; $6a19
	ldi (hl),a		; $6a1a
	ld a,$1e		; $6a1b
	ld hl,wRoomLayout+$60		; $6a1d
	ldi (hl),a		; $6a20
	ldi (hl),a		; $6a21
	ld (hl),a		; $6a22
	ret			; $6a23

;;
; Present overworld, impa's house
; @addr{6a24}
tileReplacement_group0Map3a:
	ld a,GLOBALFLAG_INTRO_DONE		; $6a24
	call checkGlobalFlag		; $6a26
	ret z			; $6a29

	; Open door
	ld a,$ee		; $6a2a
	ld (wRoomLayout+$23),a		; $6a2c
	ret			; $6a2f

;;
; Present, screen right of d5 where a cave opens up
; @addr{6a30}
tileReplacement_group0Map0b:
	ld hl,wPresentRoomFlags+$0a		; $6a30
	bit ROOMFLAG_BIT_40,(hl)		; $6a33
	ret z			; $6a35

	ld hl,wRoomLayout+$43		; $6a36
	ld (hl),$dd		; $6a39
	ret			; $6a3b

;;
; Present cave with goron elder.
; Removes boulders after dungeon 4 is beaten.
; @addr{6a3c}
tileReplacement_group5Mapb9:
	; Must have beaten dungeon 4
	ld a,$03		; $6a3c
	ld hl,wEssencesObtained		; $6a3e
	call checkFlag		; $6a41
	ret z			; $6a44

	ld bc,@replacementTiles		; $6a45
	ld hl,wRoomLayout+$41		; $6a48
	call @locFunc		; $6a4b
	ld l,$51		; $6a4e
@locFunc:
	ld a,$05		; $6a50
--
	ldh (<hFF8D),a	; $6a52
	ld a,(bc)		; $6a54
	inc bc			; $6a55
	ldi (hl),a		; $6a56
	ldh a,(<hFF8D)	; $6a57
	dec a			; $6a59
	jr nz,--		; $6a5a
	ret			; $6a5c

@replacementTiles:
	.db $a1 $a1 $a1 $ef $a1
	.db $a2 $ef $a2 $a2 $a2

;;
; Past overworld, Ambi's Palace secret passage
; @addr{6a67}
tileReplacement_group1Map27:
	call getThisRoomFlags		; $6a67
	ld l,$15		; $6a6a
	bit 7,(hl)		; $6a6c
	jr z,+			; $6a6e

	ld de,$3343		; $6a70
	call @locFunc		; $6a73
+
	ld l,$17		; $6a76
	bit 7,(hl)		; $6a78
	jr z,+			; $6a7a

	ld de,$3424		; $6a7c
	call @locFunc		; $6a7f
+
	ld l,$35		; $6a82
	bit 7,(hl)		; $6a84
	jr z,+			; $6a86

	ld de,$3545		; $6a88
	call @locFunc		; $6a8b
+
	ld l,$37		; $6a8e
	bit 7,(hl)		; $6a90
	ret z			; $6a92

	ld de,$3626		; $6a93
@locFunc:
	ld b,>wRoomLayout		; $6a96
	ld c,d			; $6a98
	ld a,$3a		; $6a99
	ld (bc),a		; $6a9b
	ld c,e			; $6a9c
	ld a,$02		; $6a9d
	ld (bc),a		; $6a9f
	ret			; $6aa0

;;
; Present cave on the way to rolling ridge
; Has a bridge
; @addr{6aa1}
tileReplacement_group5Mapc2:
	call getThisRoomFlags		; $6aa1
	and $80			; $6aa4
	ret z			; $6aa6

	ld hl,wRoomLayout+$56		; $6aa7
	ld a,$6d		; $6aaa

;;
; Sets 4 bytes at hl to the value of a.
; @addr{6aac}
set4Bytes:
	ldi (hl),a		; $6aac
set3Bytes:
	ldi (hl),a		; $6aad
	ldi (hl),a		; $6aae
	ld (hl),a		; $6aaf
	ret			; $6ab0

;;
; Past cave on the way to the d6 area
; Has a bridge
; @addr{6ab1}
tileReplacement_group5Mape3:
	call getThisRoomFlags		; $6ab1
	and $80			; $6ab4
	ret z			; $6ab6

	ld hl,wRoomLayout+$26		; $6ab7
	ld a,$6d		; $6aba
	jr set3Bytes		; $6abc

;;
; Underwater, entrance to Jabu
; @addr{6abe}
tileReplacement_group2Map90:
	call getThisRoomFlags		; $6abe
	and $02			; $6ac1
	ret z			; $6ac3

	ld de,@rect		; $6ac4
	jp drawRectInRoomLayout		; $6ac7

; @addr{6aca}
@rect:
	.db $42 $02 $06
	.db $dd $de $df $ed $ee $ef
	.db $b9 $ba $bb $bc $bd $be

;;
; Past, area beneath the entrance to d8 maze
; @addr{6ad9}
tileReplacement_group1Map8c:
	call getThisRoomFlags		; $6ad9
	and $80			; $6adc
	ret z			; $6ade

	ld hl,wRoomLayout+$04		; $6adf
	ld (hl),$30		; $6ae2
	inc l			; $6ae4
	ld (hl),$32		; $6ae5
	ld a,$3a		; $6ae7
	ld l,$14		; $6ae9
	ldi (hl),a		; $6aeb
	ld (hl),a		; $6aec
	ld l,$34		; $6aed
	ld (hl),$02		; $6aef
	inc l			; $6af1
	ld (hl),$3a		; $6af2
	ret			; $6af4

;;
; Present, shortcut cave for tingle
; @addr{6af5}
tileReplacement_group2Map9e:
	xor a			; $6af5
	ld (wToggleBlocksState),a		; $6af6
	call getThisRoomFlags		; $6af9
	and $40			; $6afc
	ret z			; $6afe

	ld hl,wRoomLayout+$13		; $6aff
	ld a,$6d		; $6b02
	call set3Bytes		; $6b04
	inc l			; $6b07
	jp set3Bytes		; $6b08

;;
; Present, on top of maku tree (left end)
; @addr{6b0b}
tileReplacement_group0Mape0:
	ld a,(wEssencesObtained)		; $6b0b
	bit 4,a			; $6b0e
	ld l,$46		; $6b10
	call nz,_setTileToDoor		; $6b12
	ld c,$1b		; $6b15
;;
; @addr{6b17}
_createInteraction90:
	call getFreeInteractionSlot		; $6b17
	ret nz			; $6b1a

	ld (hl),INTERACID_MISC_PUZZLES		; $6b1b
	inc l			; $6b1d
	ld (hl),c		; $6b1e
	ret			; $6b1f

;;
; Present, on top of maku tree (middle)
; @addr{6b20}
tileReplacement_group0Mape1:
	ld c,$1c		; $6b20
	call _createInteraction90		; $6b22
	ld a,(wEssencesObtained)		; $6b25
	rrca			; $6b28
	ld l,$26		; $6b29
	call c,_setTileToDoor		; $6b2b
	rrca			; $6b2e
	ret nc			; $6b2f

	ld l,$53		; $6b30
	jr _setTileToDoor		; $6b32

;;
; Present, on top of maku tree (right)
; @addr{6b34}
tileReplacement_group0Mape2:
	ld c,$1d		; $6b34
	call _createInteraction90		; $6b36
	ld a,(wEssencesObtained)		; $6b39
	bit 2,a			; $6b3c
	ret z			; $6b3e

	ld l,$54		; $6b3f

;;
; @addr{6b41}
_setTileToDoor:
	ld h,>wRoomLayout		; $6b41
	ld (hl),$dd		; $6b43
	ret			; $6b45

;;
; Black Tower, room with 3 doors
; @addr{6b46}
tileReplacement_group4Mapea:
	call getThisRoomFlags		; $6b46
	and $40			; $6b49
	ret z			; $6b4b

	ld a,$a3		; $6b4c
	ld hl,wRoomLayout+$33		; $6b4e
	call set3Bytes		; $6b51
	ld l,$39		; $6b54
	call set3Bytes		; $6b56
	ld a,$b7		; $6b59
	ld l,$43		; $6b5b
	call set3Bytes		; $6b5d
	ld l,$49		; $6b60
	call set3Bytes		; $6b62
	ld a,$88		; $6b65
	ld l,$53		; $6b67
	call set3Bytes		; $6b69
	ld l,$59		; $6b6c
	jp set3Bytes		; $6b6e

;;
; Present, room where you find ricky's gloves
; @addr{6b71}
tileReplacement_group0Map98:
	ld a,(wRickyState)		; $6b71
	bit 5,a			; $6b74
	jr nz,@removeDirt		; $6b76

	and $01			; $6b78
	jr z,@removeDirt			; $6b7a

	ld a,TREASURE_RICKY_GLOVES		; $6b7c
	call checkTreasureObtained		; $6b7e
	ret nc			; $6b81

@removeDirt:
	ld a,$3a		; $6b82
	ld (wRoomLayout+$24),a		; $6b84
	ret			; $6b87

;;
; Present overworld, black tower entrance
; @addr{6b88}
tileReplacement_group0Map76:
	call checkIsLinkedGame		; $6b88
	ret z			; $6b8b

	call getBlackTowerProgress		; $6b8c
	dec a			; $6b8f
	ret nz			; $6b90

	ld hl,wRoomLayout+$54		; $6b91
	ld a,$a7		; $6b94
	ldi (hl),a		; $6b96
	ld (hl),a		; $6b97
	ret			; $6b98

;;
; Present library
; @addr{6b99}
tileReplacement_group0Mapa5:
	ld a,(wPastRoomFlags+$a5)		; $6b99
	bit 7,a			; $6b9c
	ret z			; $6b9e

	ld hl,wRoomLayout+$22		; $6b9f
	ld (hl),$ee		; $6ba2
	inc l			; $6ba4
	ld (hl),$ef		; $6ba5
	ret			; $6ba7

;;
; Unused?
; @addr{6ba8}
func_04_6ba8:
	ld d,>wRoomLayout		; $6ba8
	ldi a,(hl)		; $6baa
	ld c,a			; $6bab
--
	ldi a,(hl)		; $6bac
	cp $ff			; $6bad
	ret z			; $6baf

	ld e,a			; $6bb0
	ld a,c			; $6bb1
	ld (de),a		; $6bb2
	jr --			; $6bb3

;;
; Fills a square in wRoomLayout using the data at hl.
; Data format:
; - Top-left position (YX)
; - Height
; - Width
; - Tile value
; @addr{6bb5}
fillRectInRoomLayout:
	ldi a,(hl)		; $6bb5
	ld e,a			; $6bb6
	ldi a,(hl)		; $6bb7
	ld b,a			; $6bb8
	ldi a,(hl)		; $6bb9
	ld c,a			; $6bba
	ldi a,(hl)		; $6bbb
	ld d,a			; $6bbc
	ld h,>wRoomLayout		; $6bbd
--
	ld a,d			; $6bbf
	ld l,e			; $6bc0
	push bc			; $6bc1
-
	ldi (hl),a		; $6bc2
	dec c			; $6bc3
	jr nz,-			; $6bc4

	ld a,e			; $6bc6
	add $10			; $6bc7
	ld e,a			; $6bc9
	pop bc			; $6bca
	dec b			; $6bcb
	jr nz,--		; $6bcc
	ret			; $6bce

;;
; Like fillRect, but reads a series of bytes for the tile values instead of
; just one.
; @addr{6bcf}
drawRectInRoomLayout:
	ld a,(de)		; $6bcf
	inc de			; $6bd0
	ld h,>wRoomLayout		; $6bd1
	ld l,a			; $6bd3
	ldh (<hFF8B),a	; $6bd4
	ld a,(de)		; $6bd6
	inc de			; $6bd7
	ld c,a			; $6bd8
	ld a,(de)		; $6bd9
	inc de			; $6bda
	ldh (<hFF8D),a	; $6bdb
---
	ldh a,(<hFF8D)	; $6bdd
	ld b,a			; $6bdf
--
	ld a,(de)		; $6be0
	inc de			; $6be1
	ldi (hl),a		; $6be2
	dec b			; $6be3
	jr nz,--		; $6be4

	ldh a,(<hFF8B)	; $6be6
	add $10			; $6be8
	ldh (<hFF8B),a	; $6bea
	ld l,a			; $6bec
	dec c			; $6bed
	jr nz,---		; $6bee
	ret			; $6bf0

;;
; Generate the buffers at w3VramTiles and w3VramAttributes based on the tiles
; loaded in wRoomLayout.
; @addr{6bf1}
generateW3VramTilesAndAttributes:
	ld a,:w3VramTiles		; $6bf1
	ld ($ff00+R_SVBK),a	; $6bf3
	ld hl,wRoomLayout		; $6bf5
	ld de,w3VramTiles		; $6bf8
	ld c,$0b		; $6bfb
---
	ld b,$10		; $6bfd
--
	push bc			; $6bff
	ldi a,(hl)		; $6c00
	push hl			; $6c01
	call setHlToTileMappingDataPlusATimes8		; $6c02
	push de			; $6c05
	call write4BytesToVramLayout		; $6c06
	pop de			; $6c09
	set 2,d			; $6c0a
	call write4BytesToVramLayout		; $6c0c
	res 2,d			; $6c0f
	ld a,e			; $6c11
	sub $1f			; $6c12
	ld e,a			; $6c14
	pop hl			; $6c15
	pop bc			; $6c16
	dec b			; $6c17
	jr nz,--		; $6c18

	ld a,$20		; $6c1a
	call addAToDe		; $6c1c
	dec c			; $6c1f
	jr nz,---		; $6c20
	ret			; $6c22

;;
; Take 4 bytes from hl, write 2 to de, write the next 2 $20 bytes later.
; @addr{6c23}
write4BytesToVramLayout:
	ldi a,(hl)		; $6c23
	ld (de),a		; $6c24
	inc e			; $6c25
	ldi a,(hl)		; $6c26
	ld (de),a		; $6c27
	ld a,$1f		; $6c28
	add e			; $6c2a
	ld e,a			; $6c2b
	ldi a,(hl)		; $6c2c
	ld (de),a		; $6c2d
	inc e			; $6c2e
	ldi a,(hl)		; $6c2f
	ld (de),a		; $6c30
	ret			; $6c31

;;
; This updates up to 4 entries in w2ChangedTileQueue by writing a command to the vblank
; queue.
;
; @addr{6c32}
updateChangedTileQueue:
	ld a,(wScrollMode)		; $6c32
	and $0e			; $6c35
	ret nz			; $6c37

	; Update up to 4 tiles per frame
	ld b,$04		; $6c38
--
	push bc			; $6c3a
	call @handleSingleEntry		; $6c3b
	pop bc			; $6c3e
	dec b			; $6c3f
	jr nz,--		; $6c40

	xor a			; $6c42
	ld ($ff00+R_SVBK),a	; $6c43
	ret			; $6c45

;;
; @addr{6c46}
@handleSingleEntry:
	ld a,(wChangedTileQueueHead)		; $6c46
	ld b,a			; $6c49
	ld a,(wChangedTileQueueTail)		; $6c4a
	cp b			; $6c4d
	ret z			; $6c4e

	inc b			; $6c4f
	ld a,b			; $6c50
	and $1f			; $6c51
	ld (wChangedTileQueueHead),a		; $6c53
	ld hl,w2ChangedTileQueue		; $6c56
	rst_addDoubleIndex			; $6c59

	ld a,:w2ChangedTileQueue		; $6c5a
	ld ($ff00+R_SVBK),a	; $6c5c

	; b = New value of tile
	; c = position of tile
	ldi a,(hl)		; $6c5e
	ld c,(hl)		; $6c5f
	ld b,a			; $6c60

	ld a,c			; $6c61
	ldh (<hFF8C),a	; $6c62

	ld a,($ff00+R_SVBK)	; $6c64
	push af			; $6c66
	ld a,:w3VramTiles		; $6c67
	ld ($ff00+R_SVBK),a	; $6c69
	call getVramSubtileAddressOfTile		; $6c6b

	ld a,b			; $6c6e
	call setHlToTileMappingDataPlusATimes8		; $6c6f
	push hl			; $6c72

	; Write tile data
	push de			; $6c73
	call write4BytesToVramLayout		; $6c74
	pop de			; $6c77

	; Write mapping data
	ld a,$04		; $6c78
	add d			; $6c7a
	ld d,a			; $6c7b
	call write4BytesToVramLayout		; $6c7c

	ldh a,(<hFF8C)	; $6c7f
	pop hl			; $6c81
	call queueTileWriteAtVBlank		; $6c82

	pop af			; $6c85
	ld ($ff00+R_SVBK),a	; $6c86
	ret			; $6c88

;;
; @param	c	Tile index
; @param[out]	de	Address of tile c's top-left subtile in w3VramTiles
; @addr{6c89}
getVramSubtileAddressOfTile:
	ld a,c			; $6c89
	swap a			; $6c8a
	and $0f			; $6c8c
	ld hl,@addresses	; $6c8e
	rst_addDoubleIndex			; $6c91
	ldi a,(hl)		; $6c92
	ld h,(hl)		; $6c93
	ld l,a			; $6c94

	ld a,c			; $6c95
	and $0f			; $6c96
	add a			; $6c98
	rst_addAToHl			; $6c99
	ld e,l			; $6c9a
	ld d,h			; $6c9b
	ret			; $6c9c

@addresses:
	.dw w3VramTiles+$000
	.dw w3VramTiles+$040
	.dw w3VramTiles+$080
	.dw w3VramTiles+$0c0
	.dw w3VramTiles+$100
	.dw w3VramTiles+$140
	.dw w3VramTiles+$180
	.dw w3VramTiles+$1c0
	.dw w3VramTiles+$200
	.dw w3VramTiles+$240
	.dw w3VramTiles+$280

;;
; Called from "setInterleavedTile" in bank 0.
;
; Mixes two tiles together by using some subtiles from one, and some subtiles from the
; other. Used for example by shutter doors, which would combine the door and floor tiles
; for the partway-closed part of the animation.
;
; Tile 2 uses its tiles from the same "half" that tile 1 uses. For example, if tile 1 was
; placed on the right side, both tiles would use the right halves of their subtiles.
;
; @param	a	0: Top is tile 2, bottom is tile 1
;			1: Left is tile 1, right is tile 2
;			2: Top is tile 1, bottom is tile 2
;			3: Left is tile 2, right is tile 1
; @param	hFF8C	Position of tile to change
; @param	hFF8F	Tile index 1
; @param	hFF8E	Tile index 2
; @addr{6cb3}
setInterleavedTile_body:
	ldh (<hFF8B),a	; $6cb3

	ld a,($ff00+R_SVBK)	; $6cb5
	push af			; $6cb7
	ld a,:w3TileMappingData		; $6cb8
	ld ($ff00+R_SVBK),a	; $6cba

	ldh a,(<hFF8F)	; $6cbc
	call setHlToTileMappingDataPlusATimes8		; $6cbe
	ld de,$cec8		; $6cc1
	ld b,$08		; $6cc4
-
	ldi a,(hl)		; $6cc6
	ld (de),a		; $6cc7
	inc de			; $6cc8
	dec b			; $6cc9
	jr nz,-			; $6cca

	ldh a,(<hFF8E)	; $6ccc
	call setHlToTileMappingDataPlusATimes8		; $6cce
	ld de,$cec8		; $6cd1
	ldh a,(<hFF8B)	; $6cd4
	bit 0,a			; $6cd6
	jr nz,@interleaveDiagonally		; $6cd8

	bit 1,a			; $6cda
	jr nz,+			; $6cdc

	inc hl			; $6cde
	inc hl			; $6cdf
	call @copy2Bytes		; $6ce0
	jr ++			; $6ce3
+
	inc de			; $6ce5
	inc de			; $6ce6
	call @copy2Bytes		; $6ce7
++
	inc hl			; $6cea
	inc hl			; $6ceb
	inc de			; $6cec
	inc de			; $6ced
	call @copy2Bytes		; $6cee
	jr @queueWrite			; $6cf1

@copy2Bytes:
	ldi a,(hl)		; $6cf3
	ld (de),a		; $6cf4
	inc de			; $6cf5
	ldi a,(hl)		; $6cf6
	ld (de),a		; $6cf7
	inc de			; $6cf8
	ret			; $6cf9

@interleaveDiagonally:
	bit 1,a			; $6cfa
	jr nz,+			; $6cfc

	inc de			; $6cfe
	call @copy2BytesSeparated		; $6cff
	jr ++			; $6d02
+
	inc hl			; $6d04
	call @copy2BytesSeparated		; $6d05
++
	inc hl			; $6d08
	inc de			; $6d09
	call @copy2BytesSeparated		; $6d0a
	jr @queueWrite			; $6d0d

;;
; @addr{6d0f}
@copy2BytesSeparated:
	ldi a,(hl)		; $6d0f
	ld (de),a		; $6d10
	inc de			; $6d11
	inc hl			; $6d12
	inc de			; $6d13
	ldi a,(hl)		; $6d14
	ld (de),a		; $6d15
	inc de			; $6d16
	ret			; $6d17

;;
; @param	hFF8C	The position of the tile to refresh
; @param	$cec8	The data to write for that tile
; @addr{6d18}
@queueWrite:
	ldh a,(<hFF8C)	; $6d18
	ld hl,$cec8		; $6d1a
	call queueTileWriteAtVBlank		; $6d1d
	pop af			; $6d20
	ld ($ff00+R_SVBK),a	; $6d21
	ret			; $6d23

;;
; Set wram bank to 3 (or wherever hl is pointing to) before calling this.
;
; @param	a	Tile position
; @param	hl	Pointer to 8 bytes of tile data (usually somewhere in
;			w3TileMappingData)
; @addr{6d24}
queueTileWriteAtVBlank:
	push hl			; $6d24
	call @getTilePositionInVram		; $6d25
	add $20			; $6d28
	ld c,a			; $6d2a

	; Add a command to the vblank queue.
	ldh a,(<hVBlankFunctionQueueTail)	; $6d2b
	ld l,a			; $6d2d
	ld h,>wVBlankFunctionQueue
	ld a,(vblankCopyTileFunctionOffset)		; $6d30
	ldi (hl),a		; $6d33
	ld (hl),e		; $6d34
	inc l			; $6d35
	ld (hl),d		; $6d36
	inc l			; $6d37

	ld e,l			; $6d38
	ld d,h			; $6d39
	pop hl			; $6d3a
	ld b,$02		; $6d3b
--
	; Write 2 bytes to the command
	call @copy2Bytes		; $6d3d

	; Then give it the address for the lower half of the tile
	ld a,c			; $6d40
	ld (de),a		; $6d41
	inc e			; $6d42

	; Then write the next 2 bytes
	call @copy2Bytes		; $6d43
	dec b			; $6d46
	jr nz,--		; $6d47

	; Update the tail of the vblank queue
	ld a,e			; $6d49
	ldh (<hVBlankFunctionQueueTail),a	; $6d4a
	ret			; $6d4c

;;
; @addr{6d4d}
@copy2Bytes:
	ldi a,(hl)		; $6d4d
	ld (de),a		; $6d4e
	inc e			; $6d4f
	ldi a,(hl)		; $6d50
	ld (de),a		; $6d51
	inc e			; $6d52
	ret			; $6d53

;;
; @param	a	Tile position
; @param[out]	a	Same as 'e'
; @param[out]	de	Somewhere in the vram bg map
; @addr{6d54}
@getTilePositionInVram:
	ld e,a			; $6d54
	and $f0			; $6d55
	swap a			; $6d57
	ld d,a			; $6d59
	ld a,e			; $6d5a
	and $0f			; $6d5b
	add a			; $6d5d
	ld e,a			; $6d5e
	ld a,(wScreenOffsetX)		; $6d5f
	swap a			; $6d62
	add a			; $6d64
	add e			; $6d65
	and $1f			; $6d66
	ld e,a			; $6d68
	ld a,(wScreenOffsetY)		; $6d69
	swap a			; $6d6c
	add d			; $6d6e
	and $0f			; $6d6f
	ld hl,vramBgMapTable		; $6d71
	rst_addDoubleIndex			; $6d74
	ldi a,(hl)		; $6d75
	add e			; $6d76
	ld e,a			; $6d77
	ld d,(hl)		; $6d78
	ret			; $6d79

;;
; Called from loadTilesetData in bank 0.
;
; @addr{6d7a}
loadTilesetData_body:
	call getAdjustedRoomGroup		; $6d7a
	ld hl,roomTilesetsGroupTable
	rst_addDoubleIndex			; $6d80
	ldi a,(hl)		; $6d81
	ld h,(hl)		; $6d82
	ld l,a			; $6d83
	ld a,(wActiveRoom)		; $6d84
	rst_addAToHl			; $6d87
	ld a,(hl)		; $6d88
	ldh (<hFF8D),a	; $6d89
	call @func_6d94		; $6d8b
	call func_6de7		; $6d8e
	ret nc			; $6d91
	ldh a,(<hFF8D)	; $6d92
@func_6d94:
	and $80			; $6d94
	ldh (<hFF8B),a	; $6d96
	ldh a,(<hFF8D)	; $6d98
	and $7f			; $6d9a
	call multiplyABy8		; $6d9c
	ld hl,tilesetData
	add hl,bc		; $6da2
	ldi a,(hl)		; $6da3
	ld e,a			; $6da4
	ldi a,(hl)		; $6da5
	ld (wTilesetFlags),a		; $6da6
	bit TILESETFLAG_BIT_DUNGEON,a			; $6da9
	jr z,+

	ld a,e			; $6dad
	and $0f			; $6dae
	ld (wDungeonIndex),a		; $6db0
	jr ++
+
	ld a,$ff		; $6db5
	ld (wDungeonIndex),a		; $6db7
++
	ld a,e			; $6dba
	swap a			; $6dbb
	and $07			; $6dbd
	ld (wActiveCollisions),a		; $6dbf

	ld b,$06		; $6dc2
	ld de,wTilesetUniqueGfx		; $6dc4
@copyloop:
	ldi a,(hl)		; $6dc7
	ld (de),a		; $6dc8
	inc e			; $6dc9
	dec b			; $6dca
	jr nz,@copyloop

	ld e,wTilesetUniqueGfx&$ff
	ld a,(de)		; $6dcf
	ld b,a			; $6dd0
	ldh a,(<hFF8B)	; $6dd1
	or b			; $6dd3
	ld (de),a		; $6dd4
	ret			; $6dd5

;;
; Returns the group to load the room layout from, accounting for bit 0 of the room flag
; which tells it to use the underwater group
;
; @param[out]	a,b	The corrected group number
; @addr{6dd6}
getAdjustedRoomGroup:
	ld a,(wActiveGroup)		; $6dd6
	ld b,a			; $6dd9
	cp $02			; $6dda
	ret nc			; $6ddc
	call getThisRoomFlags		; $6ddd
	rrca			; $6de0
	jr nc,+
	set 1,b			; $6de3
+
	ld a,b			; $6de5
	ret			; $6de6

;;
; Modifies hFF8D to indicate changes to a room (ie. jabu flooding)?
; @addr{6de7}
func_6de7:
	call @func_04_6e0d		; $6de7
	ret c			; $6dea

	call @checkJabuFlooded		; $6deb
	ret c			; $6dee

	ld a,(wActiveGroup)		; $6def
	or a			; $6df2
	jr nz,@xor		; $6df3

	ld a,(wLoadingRoomPack)		; $6df5
	cp $7f			; $6df8
	jr nz,@xor		; $6dfa

	ld a,(wAnimalCompanion)		; $6dfc
	sub SPECIALOBJECTID_RICKY			; $6dff
	jr z,@xor		; $6e01

	ld b,a			; $6e03
	ldh a,(<hFF8D)	; $6e04
	add b			; $6e06
	ldh (<hFF8D),a	; $6e07
	scf			; $6e09
	ret			; $6e0a
@xor:
	xor a			; $6e0b
	ret			; $6e0c

;;
; @addr{6e0d}
@func_04_6e0d:
	ld a,(wActiveGroup)		; $6e0d
	or a			; $6e10
	ret nz			; $6e11

	ld a,(wActiveRoom)		; $6e12
	cp $38			; $6e15
	jr nz,+			; $6e17

	ld a,($c848)		; $6e19
	and $01			; $6e1c
	ret z			; $6e1e

	ld hl,hFF8D		; $6e1f
	inc (hl)		; $6e22
	inc (hl)		; $6e23
	scf			; $6e24
	ret			; $6e25
+
	xor a			; $6e26
	ret			; $6e27

;;
; @param[out]	cflag	Set if the current room is flooded in jabu-jabu?
; @addr{6e28}
@checkJabuFlooded:

.ifdef ROM_AGES
	ld a,(wDungeonIndex)		; $6e28
	cp $07			; $6e2b
	jr nz,++		; $6e2d

	ld a,(wTilesetFlags)		; $6e2f
	and TILESETFLAG_SIDESCROLL			; $6e32
	jr nz,++		; $6e34

	ld a,$11		; $6e36
	ld (wDungeonFirstLayout),a		; $6e38
	callab bank1.findActiveRoomInDungeonLayoutWithPointlessBankSwitch		; $6e3b
	ld a,(wJabuWaterLevel)		; $6e43
	and $07			; $6e46
	ld hl,@data		; $6e48
	rst_addAToHl			; $6e4b
	ld a,(wDungeonFloor)		; $6e4c
	ld bc,bitTable		; $6e4f
	add c			; $6e52
	ld c,a			; $6e53
	ld a,(bc)		; $6e54
	and (hl)		; $6e55
	ret z			; $6e56

	ldh a,(<hFF8D)	; $6e57
	inc a			; $6e59
	ldh (<hFF8D),a	; $6e5a
	scf			; $6e5c
	ret			; $6e5d
++
	xor a			; $6e5e
	ret			; $6e5f

; @addr{6e60}
@data:
	.db $00 $01 $03

.endif

;;
; Ages only: For tiles 0x40-0x7f, in the past, replace blue palettes (6) with red palettes (0). This
; is done so that tilesets can reuse attribute data for both the past and present tilesets.
;
; This is annoying so it's disabled in the hack-base branch, which separates all tileset data
; anyway.
;
; @addr{6e63}
setPastCliffPalettesToRed:
	ld a,(wActiveCollisions)		; $6e63
	or a			; $6e66
	jr nz,@done		; $6e68

	ld a,(wTilesetFlags)		; $6e6a
	and TILESETFLAG_PAST			; $6e6d
	jr z,@done		; $6e6e

	ld a,(wActiveRoom)		; $6e70
	cp <ROOM_AGES_138			; $6e73
	ret z			; $6e75

	; Replace all attributes that have palette "6" with palette "0"
	ld a,:w3TileMappingData		; $6e76
	ld ($ff00+R_SVBK),a	; $6e78
	ld hl,w3TileMappingData + $204		; $6e7a
	ld d,$06		; $6e7d
---
	ld b,$04		; $6e7f
--
	ld a,(hl)		; $6e81
	and $07			; $6e82
	cp d			; $6e84
	jr nz,+			; $6e85

	ld a,(hl)		; $6e87
	and $f8			; $6e88
	ld (hl),a		; $6e8a
+
	inc hl			; $6e8b
	dec b			; $6e8c
	jr nz,--		; $6e8d

	ld a,$04		; $6e8f
	rst_addAToHl			; $6e91
	ld a,h			; $6e92
	cp $d4			; $6e93
	jr c,---		; $6e95
@done:
	xor a			; $6e97
	ld ($ff00+R_SVBK),a	; $6e98
	ret			; $6e9a

;;
; @addr{6e9b}
func_04_6e9b:
	ld a,$02		; $6e9b
	ld ($ff00+R_SVBK),a	; $6e9d
	ld hl,wRoomLayout		; $6e9f
	ld de,$d000		; $6ea2
	ld b,$c0		; $6ea5
	call copyMemory		; $6ea7
	ld hl,wRoomCollisions		; $6eaa
	ld de,$d100		; $6ead
	ld b,$c0		; $6eb0
	call copyMemory		; $6eb2
	ld hl,$df00		; $6eb5
	ld de,$d200		; $6eb8
	ld b,$c0		; $6ebb
--
	ld a,$03		; $6ebd
	ld ($ff00+R_SVBK),a	; $6ebf
	ldi a,(hl)		; $6ec1
	ld c,a			; $6ec2
	ld a,$02		; $6ec3
	ld ($ff00+R_SVBK),a	; $6ec5
	ld a,c			; $6ec7
	ld (de),a		; $6ec8
	inc de			; $6ec9
	dec b			; $6eca
	jr nz,--		; $6ecb

	xor a			; $6ecd
	ld ($ff00+R_SVBK),a	; $6ece
	ret			; $6ed0

;;
; @addr{6ed1}
func_04_6ed1:
	ld a,$02		; $6ed1
	ld ($ff00+R_SVBK),a	; $6ed3
	ld hl,wRoomLayout		; $6ed5
	ld de,$d000		; $6ed8
	ld b,$c0		; $6edb
	call copyMemoryReverse		; $6edd
	ld hl,wRoomCollisions		; $6ee0
	ld de,$d100		; $6ee3
	ld b,$c0		; $6ee6
	call copyMemoryReverse		; $6ee8
	ld hl,$df00		; $6eeb
	ld de,$d200		; $6eee
	ld b,$c0		; $6ef1
--
	ld a,$02		; $6ef3
	ld ($ff00+R_SVBK),a	; $6ef5
	ld a,(de)		; $6ef7
	inc de			; $6ef8
	ld c,a			; $6ef9
	ld a,$03		; $6efa
	ld ($ff00+R_SVBK),a	; $6efc
	ld a,c			; $6efe
	ldi (hl),a		; $6eff
	dec b			; $6f00
	jr nz,--		; $6f01

	xor a			; $6f03
	ld ($ff00+R_SVBK),a	; $6f04
	ret			; $6f06

;;
; @addr{6f07}
func_04_6f07:
	ld hl,$d800		; $6f07
	ld de,$dc00		; $6f0a
	ld bc,$0200		; $6f0d
	call @locFunc		; $6f10
	ld hl,$dc00		; $6f13
	ld de,$de00		; $6f16
	ld bc,$0200		; $6f19
@locFunc:
	ld a,$03		; $6f1c
	ld ($ff00+R_SVBK),a	; $6f1e
	ldi a,(hl)		; $6f20
	ldh (<hFF8B),a	; $6f21
	ld a,$06		; $6f23
	ld ($ff00+R_SVBK),a	; $6f25
	ldh a,(<hFF8B)	; $6f27
	ld (de),a		; $6f29
	inc de			; $6f2a
	dec bc			; $6f2b
	ld a,b			; $6f2c
	or c			; $6f2d
	jr nz,@locFunc		; $6f2e
	ret			; $6f30

;;
; @addr{6f31}
func_04_6f31:
	ld hl,$dc00		; $6f31
	ld de,$d800		; $6f34
	ld bc,$0200		; $6f37
	call @locFunc		; $6f3a
	ld hl,$de00		; $6f3d
	ld de,$dc00		; $6f40
	ld bc,$0200		; $6f43
@locFunc:
	ld a,$06		; $6f46
	ld ($ff00+R_SVBK),a	; $6f48
	ldi a,(hl)		; $6f4a
	ldh (<hFF8B),a	; $6f4b
	ld a,$03		; $6f4d
	ld ($ff00+R_SVBK),a	; $6f4f
	ldh a,(<hFF8B)	; $6f51
	ld (de),a		; $6f53
	inc de			; $6f54
	dec bc			; $6f55
	ld a,b			; $6f56
	or c			; $6f57
	jr nz,@locFunc	; $6f58
	ret			; $6f5a

; .ORGA $6f5b

.include "build/data/warpData.s"


.ifdef BUILD_VANILLA

; Garbage data? Looks like a partial repeat of the last warp.
; @addr{7ede}
unknownData7ede:
	.db $ef $44 $43 $ff ; $7ede

.endif


.BANK $05 SLOT 1
.ORG 0

 m_section_force "Bank_5" NAMESPACE bank5

;;
; @addr{4000}
updateSpecialObjects:
	ld hl,wLinkIDOverride		; $4000
	ld a,(hl)		; $4003
	ld (hl),$00		; $4004
	or a			; $4006
	jr z,+			; $4007
	and $7f			; $4009
	ld (w1Link.id),a		; $400b
+
	ld hl,w1Link.var2f		; $400e
	ld a,(hl)		; $4011
	and $3f			; $4012
	ld (hl),a		; $4014

.ifdef ROM_AGES
	ld a,TREASURE_MERMAID_SUIT		; $4015
	call checkTreasureObtained		; $4017
	jr nc,+			; $401a
	set 6,(hl)		; $401c
+
	ld a,(wTilesetFlags)		; $401e
	and TILESETFLAG_UNDERWATER			; $4021
	jr z,+			; $4023
	set 7,(hl)		; $4025
+
.endif

	xor a			; $4027
	ld (wBraceletGrabbingNothing),a		; $4028
	ld (wcc92),a		; $402b
	ld (wForceLinkPushAnimation),a		; $402e

	ld hl,wcc95		; $4031
	ld a,(hl)		; $4034
	or $7f			; $4035
	ld (hl),a		; $4037

	ld hl,wLinkTurningDisabled		; $4038
	res 7,(hl)		; $403b

	call _updateGameKeysPressed		; $403d

	ld hl,w1Companion		; $4040
	call @updateSpecialObject		; $4043

	xor a			; $4046
	ld (wLinkClimbingVine),a		; $4047
	ld (wDisallowMountingCompanion),a		; $404a

	ld hl,w1Link		; $404d
	call @updateSpecialObject		; $4050

	call _updateLinkInvincibilityCounter		; $4053

	ld a,(wLinkPlayingInstrument)		; $4056
	ld (wLinkRidingObject),a		; $4059

	ld hl,wLinkImmobilized		; $405c
	ld a,(hl)		; $405f
	and $0f			; $4060
	ld (hl),a		; $4062

	xor a			; $4063
	ld (wcc67),a		; $4064
	ld (w1Link.var2a),a		; $4067
	ld (wccd8),a		; $406a

	ld hl,wInstrumentsDisabledCounter		; $406d
	ld a,(hl)		; $4070
	or a			; $4071
	jr z,+			; $4072
	dec (hl)		; $4074
+
	ld hl,wGrabbableObjectBuffer		; $4075
	ld b,$10		; $4078
	jp clearMemory		; $407a

;;
; @param hl Object to update (w1Link or w1Companion)
; @addr{407d}
@updateSpecialObject:
	ld a,(hl)		; $407d
	or a			; $407e
	ret z			; $407f

	ld a,l			; $4080
	ldh (<hActiveObjectType),a	; $4081
	ld a,h			; $4083
	ldh (<hActiveObject),a	; $4084
	ld d,h			; $4086

	ld l,Object.id		; $4087
	ld a,(hl)		; $4089
	rst_jumpTable			; $408a
	.dw  specialObjectCode_link
	.dw  specialObjectCode_transformedLink
	.dw  specialObjectCode_transformedLink
	.dw  specialObjectCode_transformedLink
	.dw  specialObjectCode_transformedLink
	.dw  specialObjectCode_transformedLink
	.dw  specialObjectCode_transformedLink
	.dw  specialObjectCode_transformedLink
	.dw  specialObjectCode_linkInCutscene
	.dw  specialObjectCode_linkRidingAnimal
	.dw _specialObjectCode_minecart
	.dw _specialObjectCode_ricky
	.dw _specialObjectCode_dimitri
	.dw _specialObjectCode_moosh
	.dw _specialObjectCode_maple
	.dw  specialObjectCode_companionCutscene
	.dw  specialObjectCode_companionCutscene
	.dw  specialObjectCode_companionCutscene
	.dw  specialObjectCode_companionCutscene
	.dw _specialObjectCode_raft

;;
; Updates wGameKeysPressed based on wKeysPressed, and updates wLinkAngle based on
; direction buttons pressed.
; @addr{40b3}
_updateGameKeysPressed:
	ld a,(wKeysPressed)		; $40b3
	ld c,a			; $40b6

	ld a,(wUseSimulatedInput)		; $40b7
	or a			; $40ba
	jr z,@updateKeysPressed_c	; $40bb

	cp $02			; $40bd
	jr z,@reverseMovement			; $40bf

	call getSimulatedInput		; $40c1
	jr @updateKeysPressed_a		; $40c4

	; This code is used in the Ganon fight where he reverses Link's movement?
@reverseMovement:
	xor a			; $40c6
	ld (wUseSimulatedInput),a		; $40c7
	ld a,BTN_DOWN | BTN_LEFT		; $40ca
	and c			; $40cc
	rrca			; $40cd
	ld b,a			; $40ce

	ld a,BTN_UP | BTN_RIGHT		; $40cf
	and c			; $40d1
	rlca			; $40d2
	or b			; $40d3
	ld b,a			; $40d4

	ld a,$0f		; $40d5
	and c			; $40d7
	or b			; $40d8

@updateKeysPressed_a:
	ld c,a			; $40d9
@updateKeysPressed_c:
	ld a,(wLinkDeathTrigger)		; $40da
	or a			; $40dd
	ld hl,wGameKeysPressed		; $40de
	jr nz,@dying		; $40e1

	; Update wGameKeysPressed, wGameKeysJustPressed based on the value of 'c'.
	ld a,(hl)		; $40e3
	cpl			; $40e4
	ld b,a			; $40e5
	ld a,c			; $40e6
	ldi (hl),a		; $40e7
	and b			; $40e8
	ldi (hl),a		; $40e9

	; Update Link's angle based on the direction buttons pressed.
	ld a,c			; $40ea
	and $f0			; $40eb
	swap a			; $40ed
	ld hl,@directionButtonToAngle		; $40ef
	rst_addAToHl			; $40f2
	ld a,(hl)		; $40f3
	ld (wLinkAngle),a		; $40f4
	ret			; $40f7

@dying:
	; Clear wGameKeysPressed, wGameKeysJustPressed
	xor a			; $40f8
	ldi (hl),a		; $40f9
	ldi (hl),a		; $40fa

	; Set wLinkAngle to $ff
	dec a			; $40fb
	ldi (hl),a		; $40fc
	ret			; $40fd

; Index is direction buttons pressed, value is the corresponding angle.
@directionButtonToAngle:
	.db $ff $08 $18 $ff $00 $04 $1c $ff
	.db $10 $0c $14 $ff $ff $ff $ff

;;
; This is called when Link is riding something (wLinkObjectIndex == $d1).
;
; @addr{410d}
func_410d:
	xor a			; $410d
	ldh (<hActiveObjectType),a	; $410e
	ld de,w1Companion.id		; $4110
	ld a,d			; $4113
	ldh (<hActiveObject),a	; $4114
	ld a,(de)		; $4116
	sub SPECIALOBJECTID_MINECART			; $4117
	rst_jumpTable			; $4119

	.dw @ridingMinecart
	.dw @ridingRicky
	.dw @ridingDimitri
	.dw @ridingMoosh
	.dw @invalid
	.dw @invalid
	.dw @invalid
	.dw @invalid
	.dw @invalid
	.dw @ridingRaft

@invalid:
	ret			; $412e

@ridingRicky:
	ld bc,$0000		; $412f
	jr @companion		; $4132

@ridingDimitri:
	ld e,<w1Companion.direction		; $4134
	ld a,(de)		; $4136
	rrca			; $4137
	ld bc,$f600		; $4138
	jr nc,@companion	; $413b

	ld c,$fb		; $413d
	rrca			; $413f
	jr nc,@companion	; $4140

	ld c,$05		; $4142
	jr @companion		; $4144

@ridingMoosh:
	ld e,SpecialObject.direction		; $4146
	ld a,(de)		; $4148
	rrca			; $4149
	ld bc,$f200		; $414a
	jr nc,@companion	; $414d
	ld b,$f0		; $414f

;;
; @param	bc	Position offset relative to companion to place Link at
; @addr{4151}
@companion:
	ld hl,w1Link.yh		; $4151
	call objectCopyPositionWithOffset		; $4154

	ld e,<w1Companion.direction		; $4157
	ld l,<w1Link.direction		; $4159
	ld a,(de)		; $415b
	ld (hl),a		; $415c
	ld a,$01		; $415d
	ld (wcc90),a		; $415f

	ld l,<w1Link.var2a		; $4162
	ldi a,(hl)		; $4164
	or (hl)			; $4165
	ld l,<w1Link.knockbackCounter		; $4166
	or (hl)			; $4168
	jr nz,@noDamage		; $4169
	ld l,<w1Link.damageToApply		; $416b
	ld e,l			; $416d
	ld a,(de)		; $416e
	or a			; $416f
	jr z,@noDamage		; $4170

	ldi (hl),a ; [w1Link.damageToApply] = [w1Companion.damageToApply]

	; Copy health, var2a, invincibilityCounter, knockbackAngle, knockbackCounter,
	; stunCounter from companion to Link.
	ld l,<w1Link.health		; $4173
	ld e,l			; $4175
	ld b,$06		; $4176
	call copyMemoryReverse		; $4178
	jr @label_05_010		; $417b

@noDamage:
	ld l,<w1Link.damageToApply		; $417d
	ld e,l			; $417f
	ld a,(hl)		; $4180
	ld (de),a		; $4181

	; Copy health, var2a, invincibilityCounter, knockbackAngle, knockbackCounter,
	; stunCounter from Link to companion.
	ld d,>w1Link		; $4182
	ld h,>w1Companion		; $4184
	ld l,SpecialObject.health		; $4186
	ld e,l			; $4188
	ld b,$06		; $4189
	call copyMemoryReverse		; $418b

@label_05_010:
	ld h,>w1Link		; $418e
	ld d,>w1Companion		; $4190
	ld l,<w1Link.oamFlags		; $4192
	ld a,(hl)		; $4194
	ld l,<w1Link.oamFlagsBackup		; $4195
	cp (hl)			; $4197
	jr nz,+			; $4198
	ld e,<w1Companion.oamFlagsBackup		; $419a
	ld a,(de)		; $419c
+
	ld e,<w1Companion.oamFlags		; $419d
	ld (de),a		; $419f
	ld l,<w1Link.visible		; $41a0
	ld e,l			; $41a2
	ld a,(de)		; $41a3
	and $83			; $41a4
	ld (hl),a		; $41a6
	ret			; $41a7

@ridingMinecart:
	ld h,d			; $41a8
	ld l,<w1Companion.direction		; $41a9
	ld a,(hl)		; $41ab
	ld l,<w1Companion.animParameter		; $41ac
	add (hl)		; $41ae
	ld hl,@linkOffsets		; $41af
	rst_addDoubleIndex			; $41b2
	ldi a,(hl)		; $41b3
	ld c,(hl)		; $41b4
	ld b,a			; $41b5
	ld hl,w1Link.yh		; $41b6
	call objectCopyPositionWithOffset		; $41b9

	; Disable terrain effects on Link
	ld l,<w1Link.visible		; $41bc
	res 6,(hl)		; $41be

	ret			; $41c0


; Data structure:
;   Each row corresponds to a frame of the minecart animation.
;   Each column corresponds to a direction.
;   Each 2 bytes are a position offset for Link relative to the minecart.
@linkOffsets:
;           --Up--   --Right-- --Down-- --Left--
	.db $f7 $00  $f7 $00   $f7 $00  $f7 $00
	.db $f7 $ff  $f8 $00   $f7 $ff  $f8 $00

;;
; @addr{41d1}
@ridingRaft:
	ld a,(wLinkForceState)		; $41d1
	cp LINK_STATE_RESPAWNING			; $41d4
	ret z			; $41d6

	ld hl,w1Link.state		; $41d7
	ldi a,(hl)		; $41da
	cp LINK_STATE_RESPAWNING			; $41db
	jr nz,++		; $41dd
	ldi a,(hl) ; Check w1Link.state2
	cp $03			; $41e0
	ret c			; $41e2
++
	; Disable terrain effects on Link
	ld l,<w1Link.visible		; $41e3
	res 6,(hl)		; $41e5

	; Set Link's position to be 5 or 6 pixels above the raft, depending on the frame
	; of animation
	ld bc,$fb00		; $41e7
	ld e,<w1Companion.animParameter		; $41ea
	ld a,(de)		; $41ec
	or a			; $41ed
	jr z,+			; $41ee
	dec b			; $41f0
+
	call objectCopyPositionWithOffset		; $41f1
	jp objectSetVisiblec3		; $41f4

;;
; Initializes SpecialObject.oamFlags and SpecialObject.oamTileIndexBase, according to the
; id of the object.
;
; @param	d	Object
; @addr{41f7}
specialObjectSetOamVariables:
	ld e,SpecialObject.var32		; $41f7
	ld a,$ff		; $41f9
	ld (de),a		; $41fb

	ld e,SpecialObject.id		; $41fc
	ld a,(de)		; $41fe
	ld hl,@data		; $41ff
	rst_addDoubleIndex			; $4202

	ld e,SpecialObject.oamTileIndexBase		; $4203
	ldi a,(hl)		; $4205
	ld (de),a		; $4206

	; Write to SpecialObject.oamFlags
	dec e			; $4207
	ldi a,(hl)		; $4208
	ld (de),a		; $4209

	; Write flags to SpecialObject.oamFlagsBackup as well
	dec e			; $420a
	ld (de),a		; $420b
	ret			; $420c

; 2 bytes for each SpecialObject id: oamTileIndexBase, oamFlags (palette).
; @addr{420d}
@data:
	.db $70 $08 ; 0x00 (Link)
	.db $70 $08 ; 0x01
	.db $70 $08 ; 0x02
	.db $70 $08 ; 0x03
	.db $70 $08 ; 0x04
	.db $70 $08 ; 0x05
	.db $70 $08 ; 0x06
	.db $70 $08 ; 0x07
	.db $70 $08 ; 0x08
	.db $70 $08 ; 0x09
	.db $60 $0c ; 0x0a (Minecart)
	.db $60 $0b ; 0x0b
	.db $60 $0a ; 0x0c
	.db $60 $09 ; 0x0d
	.db $60 $08 ; 0x0e
	.db $60 $0b ; 0x0f
	.db $60 $0a ; 0x10
	.db $60 $09 ; 0x11
	.db $60 $08 ; 0x12
	.db $60 $0b ; 0x13

;;
; Deals 4 points of damage (1/2 heart?) to link, and applies knockback in the opposite
; direction he is moving.
; @addr{4235}
_dealSpikeDamageToLink:
	ld a,(wLinkRidingObject)		; $4235
	ld b,a			; $4238
	ld h,d			; $4239
	ld l,SpecialObject.invincibilityCounter		; $423a
	or (hl)			; $423c
	ret nz			; $423d

	ld (hl),40 ; 40 frames invincibility

	; Get damage value (4 normally, 2 with red luck ring)
	ld a,RED_LUCK_RING		; $4240
	call cpActiveRing		; $4242
	ld a,-4		; $4245
	jr nz,+			; $4247
	sra a			; $4249
+
	ld l,SpecialObject.damageToApply		; $424b
	add (hl)		; $424d
	ld (hl),a		; $424e

	ld l,SpecialObject.var2a		; $424f
	ld (hl),$80		; $4251

	; 10 frames knockback
	ld l,SpecialObject.knockbackCounter		; $4253
	ld a,10		; $4255
	add (hl)		; $4257
	ld (hl),a		; $4258

	; Calculate knockback angle
	ld e,SpecialObject.angle		; $4259
	ld a,(de)		; $425b
	xor $10			; $425c
	ld l,SpecialObject.knockbackAngle		; $425e
	ld (hl),a		; $4260

	ld a,SND_DAMAGE_LINK		; $4261
	call playSound		; $4263
	jr linkApplyDamage_b5			; $4266

;;
; @addr{4268}
updateLinkDamageTaken:
	callab bank6.linkUpdateDamageToApplyForRings		; $4268

linkApplyDamage_b5:
	callab bank6.linkApplyDamage		; $4270
	ret			; $4278

;;
; @addr{4279}
_updateLinkInvincibilityCounter:
	ld hl,w1Link.invincibilityCounter		; $4279
	ld a,(hl)		; $427c
	or a			; $427d
	ret z			; $427e

	; If $80 or higher, invincibilityCounter goes up and Link doesn't flash red
	bit 7,a			; $427f
	jr nz,@incCounter	; $4281

	; Otherwise it goes down, and Link flashes red
	dec (hl)		; $4283
	jr z,@normalFlags	; $4284

	ld a,(wFrameCounter)		; $4286
	bit 2,a			; $4289
	jr nz,@normalFlags	; $428b

	; Set Link's palette to red
	ld l,SpecialObject.oamFlags		; $428d
	ld (hl),$0d		; $428f
	ret			; $4291

@incCounter:
	inc (hl)		; $4292

@normalFlags:
	ld l,SpecialObject.oamFlagsBackup		; $4293
	ldi a,(hl)		; $4295
	ld (hl),a		; $4296
	ret			; $4297

;;
; Updates wActiveTileIndex, wActiveTileType, and wLastActiveTileType.
;
; NOTE: wLastActiveTileType actually keeps track of the tile BELOW Link when in
; a sidescrolling section.
;
; @addr{4298}
_sidescrollUpdateActiveTile:
	call objectGetTileAtPosition		; $4298
	ld (wActiveTileIndex),a		; $429b

	ld hl,tileTypesTable		; $429e
	call lookupCollisionTable		; $42a1
	ld (wActiveTileType),a		; $42a4

	ld bc,$0800		; $42a7
	call objectGetRelativeTile		; $42aa
	ld hl,tileTypesTable		; $42ad
	call lookupCollisionTable		; $42b0
	ld (wLastActiveTileType),a		; $42b3
	ret			; $42b6

;;
; Does various things based on the tile type of the tile Link is standing on (see
; constants/tileTypes.s).
;
; @param	d	Link object
; @addr{42b7}
_linkApplyTileTypes:
	xor a			; $42b7
	ld (wIsTileSlippery),a		; $42b8
	ld a,(wLinkInAir)		; $42bb
	or a			; $42be
	jp nz,@tileType_normal		; $42bf

	ld (wLinkRaisedFloorOffset),a		; $42c2
	call @linkGetActiveTileType		; $42c5

	ld (wActiveTileType),a		; $42c8
	rst_jumpTable			; $42cb
	.dw @tileType_normal ; TILETYPE_NORMAL
	.dw @tileType_hole ; TILETYPE_HOLE
	.dw @tileType_warpHole ; TILETYPE_WARPHOLE
	.dw @tileType_crackedFloor ; TILETYPE_CRACKEDFLOOR
	.dw @tileType_vines ; TILETYPE_VINES
	.dw @notSwimming ; TILETYPE_GRASS
	.dw @notSwimming ; TILETYPE_STAIRS
	.dw @swimming ; TILETYPE_WATER
	.dw @tileType_stump ; TILETYPE_STUMP
	.dw @tileType_conveyor ; TILETYPE_UPCONVEYOR
	.dw @tileType_conveyor ; TILETYPE_RIGHTCONVEYOR
	.dw @tileType_conveyor ; TILETYPE_DOWNCONVEYOR
	.dw @tileType_conveyor ; TILETYPE_LEFTCONVEYOR
	.dw _dealSpikeDamageToLink ; TILETYPE_SPIKE
	.dw @tileType_nothing ; TILETYPE_NOTHING
	.dw @tileType_ice ; TILETYPE_ICE
	.dw @tileType_lava ; TILETYPE_LAVA
	.dw @tileType_puddle ; TILETYPE_PUDDLE
	.dw @tileType_current ; TILETYPE_UPCURRENT
	.dw @tileType_current ; TILETYPE_RIGHTCURRENT
	.dw @tileType_current ; TILETYPE_DOWNCURRENT
	.dw @tileType_current ; TILETYPE_LEFTCURRENT
	.dw @tiletype_raisableFloor ; TILETYPE_RAISABLE_FLOOR
	.dw @swimming ; TILETYPE_SEAWATER
	.dw @swimming ; TILETYPE_WHIRLPOOL

@tiletype_raisableFloor:
	ld a,-3		; $42fe
	ld (wLinkRaisedFloorOffset),a		; $4300

@tileType_normal:
	xor a			; $4303
	ld (wActiveTileType),a		; $4304
	ld (wStandingOnTileCounter),a		; $4307
	ld (wLinkSwimmingState),a		; $430a
	ret			; $430d

@tileType_puddle:
	ld h,d			; $430e
	ld l,SpecialObject.animParameter		; $430f
	bit 5,(hl)		; $4311
	jr z,@tileType_normal	; $4313

	res 5,(hl)		; $4315
	ld a,(wLinkImmobilized)		; $4317
	or a			; $431a
	ld a,SND_SPLASH		; $431b
	call z,playSound		; $431d
	jr @tileType_normal		; $4320

@tileType_stump:
	ld h,d			; $4322
	ld l,SpecialObject.adjacentWallsBitset		; $4323
	ld (hl),$ff		; $4325
	ld l,SpecialObject.collisionType		; $4327
	res 7,(hl)		; $4329
	jr @notSwimming		; $432b

@tileType_vines:
	call dropLinkHeldItem		; $432d
	ld a,$ff		; $4330
	ld (wLinkClimbingVine),a		; $4332

@notSwimming:
	xor a			; $4335
	ld (wLinkSwimmingState),a		; $4336
	ret			; $4339

@tileType_crackedFloor:
	ld a,ROCS_RING		; $433a
	call cpActiveRing		; $433c
	jr z,@tileType_normal	; $433f

	; Don't break the floor until Link has stood there for 32 frames
	ld a,(wStandingOnTileCounter)		; $4341
	cp 32			; $4344
	jr c,@notSwimming	; $4346

	ld a,(wActiveTilePos)		; $4348
	ld c,a			; $434b
	ld a,TILEINDEX_HOLE		; $434c
	call breakCrackedFloor		; $434e
	xor a			; $4351
	ld (wStandingOnTileCounter),a		; $4352

@tileType_hole:
@tileType_warpHole:
	ld a,(wTilesetFlags)		; $4355
	and TILESETFLAG_UNDERWATER			; $4358
	jr nz,@tileType_normal	; $435a

	xor a			; $435c
	ld (wLinkSwimmingState),a		; $435d

	ld a,(wLinkRidingObject)		; $4360
	or a			; $4363
	jr nz,@tileType_normal	; $4364

	ld a,(wMagnetGloveState)		; $4366
	bit 6,a			; $4369
	jr nz,@tileType_normal	; $436b

	; Jump if tile type has changed
	ld hl,wLastActiveTileType		; $436d
	ldd a,(hl)		; $4370
	cp (hl)			; $4371
	jr nz,++		; $4372

	; Jump if Link's position has not changed
	ld l,<wActiveTilePos		; $4374
	ldi a,(hl)		; $4376
	cp b			; $4377
	jr z,++			; $4378

	; [wStandingOnTileCounter] = $0e
	inc l			; $437a
	ld a,$0e		; $437b
	ld (hl),a		; $437d
++
	ld a,$80		; $437e
	ld (wcc92),a		; $4380
	jp _linkPullIntoHole		; $4383

@tileType_ice:
	ld a,SNOWSHOE_RING		; $4386
	call cpActiveRing		; $4388
	jr z,@notSwimming	; $438b

	ld hl,wIsTileSlippery		; $438d
	set 6,(hl)		; $4390
	jr @notSwimming		; $4392

@tileType_nothing:
	ret			; $4394

@swimming:
	ld a,(wLinkRidingObject)		; $4395
	or a			; $4398
	jp nz,@tileType_normal		; $4399

	; Run the below code only the moment he gets into the water
	ld a,(wLinkSwimmingState)		; $439c
	or a			; $439f
	ret nz			; $43a0

	ld a,(w1Link.var2f)		; $43a1
	bit 7,a			; $43a4
	ret nz			; $43a6

	xor a			; $43a7
	ld e,SpecialObject.var35		; $43a8
	ld (de),a		; $43aa
	ld e,SpecialObject.knockbackCounter		; $43ab
	ld (de),a		; $43ad

	inc a			; $43ae
	ld (wLinkSwimmingState),a		; $43af

	ld a,$80		; $43b2
	ld (wcc92),a		; $43b4
	ret			; $43b7

@tileType_lava:
	ld a,(wLinkRidingObject)		; $43b8
	or a			; $43bb
	jp nz,@tileType_normal		; $43bc

	ld a,$80		; $43bf
	ld (wcc92),a		; $43c1

	ld e,SpecialObject.knockbackCounter		; $43c4
	xor a			; $43c6
	ld (de),a		; $43c7

	ld a,(wLinkSwimmingState)		; $43c8
	or a			; $43cb
	ret nz			; $43cc

	xor a			; $43cd
	ld e,SpecialObject.var35		; $43ce
	ld (de),a		; $43d0

	ld a,$41		; $43d1
	ld (wLinkSwimmingState),a		; $43d3
	ret			; $43d6

@tileType_conveyor:
	ld a,(wLinkRidingObject)		; $43d7
	or a			; $43da
	jp nz,@tileType_normal		; $43db

	ld a,QUICKSAND_RING		; $43de
	call cpActiveRing		; $43e0
	jp z,@tileType_normal		; $43e3

	ldbc SPEED_80, TILETYPE_UPCONVEYOR		; $43e6

@adjustLinkOnConveyor:
	ld a,$01		; $43e9
	ld (wcc92),a		; $43eb

	; Get angle to move link in c
	ld a,(wActiveTileType)		; $43ee
	sub c			; $43f1
	ld hl,@conveyorAngles		; $43f2
	rst_addAToHl			; $43f5
	ld c,(hl)		; $43f6

	jp specialObjectUpdatePositionGivenVelocity		; $43f7

@conveyorAngles:
	.db $00 $08 $10 $18

@tileType_current:
	ldbc SPEED_c0, TILETYPE_UPCURRENT		; $43fe
	call @adjustLinkOnConveyor		; $4401
	jr @swimming		; $4404

;;
; Gets the tile type of the tile link is standing on (see constants/tileTypes.s).
; Also updates wActiveTilePos, wActiveTileIndex and wLastActiveTileType, but not
; wActiveTileType.
;
; @param	d	Link object
; @param[out]	a	Tile type
; @param[out]	b	Former value of wActiveTilePos
; @addr{4406}
@linkGetActiveTileType:
	ld bc,$0500		; $4406
	call objectGetRelativeTile		; $4409
	ld c,a			; $440c
	ld b,l			; $440d
	ld hl,wActiveTilePos		; $440e
	ldi a,(hl)		; $4411
	cp b			; $4412
	jr nz,+			; $4413

	ld a,(hl)		; $4415
	cp c			; $4416
	jr z,++			; $4417
+
	; Update wActiveTilePos
	ld l,<wActiveTilePos		; $4419
	ld a,(hl)		; $441b
	ld (hl),b		; $441c
	ld b,a			; $441d

	; Update wActiveTileIndex
	inc l			; $441e
	ld (hl),c		; $441f

	; Write $00 to wStandingOnTileCounter
	inc l			; $4420
	ld (hl),$00		; $4421
++
	ld l,<wStandingOnTileCounter		; $4423
	inc (hl)		; $4425

	; Copy wActiveTileType to wLastActiveTileType
	inc l			; $4426
	ldi a,(hl)		; $4427
	ld (hl),a		; $4428

	ld a,c			; $4429
	ld hl,tileTypesTable		; $442a
	jp lookupCollisionTable		; $442d

;;
; Same as below, but operates on SpecialObject.angle, not a given variable.
; @addr{4430}
_linkAdjustAngleInSidescrollingArea:
	ld l,SpecialObject.angle		; $4430

;;
; Adjusts Link's angle in sidescrolling areas when not on a staircase.
; This results in Link only moving in horizontal directions.
;
; @param	l	Angle variable to use
; @addr{4432}
_linkAdjustGivenAngleInSidescrollingArea:
	ld h,d			; $4432
	ld e,l			; $4433

	ld a,(wTilesetFlags)		; $4434
	and TILESETFLAG_SIDESCROLL			; $4437
	ret z			; $4439

	; Return if angle value >= $80
	bit 7,(hl)		; $443a
	ret nz			; $443c

	ld a,(hl)		; $443d
	ld hl,@horizontalAngleTable		; $443e
	rst_addAToHl			; $4441
	ld a,(hl)		; $4442
	ld (de),a		; $4443
	ret			; $4444

; This table converts an angle value such that it becomes purely horizontal.
@horizontalAngleTable:
	.db $ff $08 $08 $08 $08 $08 $08 $08
	.db $08 $08 $08 $08 $08 $08 $08 $08
	.db $ff $18 $18 $18 $18 $18 $18 $18
	.db $18 $18 $18 $18 $18 $18 $18 $18

;;
; Prevents link from passing object d.
;
; @param	d	The object that Link shall not pass.
; @addr{4465}
_companionPreventLinkFromPassing_noExtraChecks:
	ld hl,w1Link		; $4465
	jp preventObjectHFromPassingObjectD		; $4468

;;
; @addr{446b}
_companionUpdateMovement:
	call _companionCalculateAdjacentWallsBitset		; $446b
	call specialObjectUpdatePosition		; $446e

	; Don't attempt to break tile on ground if in midair
	ld h,d			; $4471
	ld l,SpecialObject.zh		; $4472
	ld a,(hl)		; $4474
	or a			; $4475
	ret nz			; $4476

;;
; Calculate position of the tile beneath the companion's feet, to see if it can be broken
; (just by walking on it)
; @addr{4477}
_companionTryToBreakTileFromMoving:
	ld h,d			; $4477
	ld l,SpecialObject.yh		; $4478
	ld a,(hl)		; $447a
	add $05			; $447b
	ld b,a			; $447d
	ld l,SpecialObject.xh		; $447e
	ld c,(hl)		; $4480

	ld a,BREAKABLETILESOURCE_13		; $4481
	jp tryToBreakTile		; $4483

;;
; @param	d	Special object
; @addr{4486}
_companionCalculateAdjacentWallsBitset:
	ld e,SpecialObject.adjacentWallsBitset		; $4486
	xor a			; $4488
	ld (de),a		; $4489
	ld h,d			; $448a
	ld l,SpecialObject.yh		; $448b
	ld b,(hl)		; $448d
	ld l,SpecialObject.xh		; $448e
	ld c,(hl)		; $4490

	ld a,$01		; $4491
	ldh (<hFF8B),a	; $4493
	ld hl,@offsets		; $4495
--
	ldi a,(hl)		; $4498
	add b			; $4499
	ld b,a			; $449a
	ldi a,(hl)		; $449b
	add c			; $449c
	ld c,a			; $449d
	push hl			; $449e
	call _checkCollisionForCompanion		; $449f
	pop hl			; $44a2
	ldh a,(<hFF8B)	; $44a3
	rla			; $44a5
	ldh (<hFF8B),a	; $44a6
	jr nc,--		; $44a8

	ld e,SpecialObject.adjacentWallsBitset		; $44aa
	ld (de),a		; $44ac
	ret			; $44ad

@offsets:
	.db $fb $fd
	.db $00 $07
	.db $0d $f9
	.db $00 $07
	.db $f5 $f7
	.db $09 $00
	.db $f7 $0b
	.db $09 $00

;;
; @param	bc	Position to check
; @param	d	A special object (should be a companion?)
; @param[out]	cflag	Set if a collision happened
; @addr{44be}
_checkCollisionForCompanion:
	; Animals can't pass through climbable vines
	call getTileAtPosition		; $44be
	ld a,(hl)		; $44c1
	cp TILEINDEX_VINE_BOTTOM			; $44c2
	jr z,@setCollision	; $44c4
	cp TILEINDEX_VINE_MIDDLE			; $44c6
	jr z,@setCollision	; $44c8

	; Check for collision on bottom half of this tile only
	cp TILEINDEX_VINE_TOP			; $44ca
	ld a,$03		; $44cc
	jp z,checkGivenCollision_allowHoles		; $44ce

	ld e,SpecialObject.id		; $44d1
	ld a,(de)		; $44d3
	cp SPECIALOBJECTID_RICKY			; $44d4
	jr nz,@notRicky		; $44d6

	; This condition appears to have no effect either way?
	ld e,SpecialObject.zh		; $44d8
	ld a,(de)		; $44da
	bit 7,a			; $44db
	jr z,@checkCollision	; $44dd
	ld a,(hl)		; $44df
	jr @checkCollision		; $44e0

@notRicky:
	cp SPECIALOBJECTID_DIMITRI			; $44e2
	jr nz,@checkCollision	; $44e4
	ld a,(hl)		; $44e6
	cp SPECIALCOLLISION_fe			; $44e7
	ret nc			; $44e9
	jr @checkCollision		; $44ea

@setCollision:
	scf			; $44ec
	ret			; $44ed

@checkCollision:
	jp checkCollisionPosition_disallowSmallBridges		; $44ee

;;
; @param	d	Special object
; @param	hl	Table which takes object's direction as an index
; @param[out]	a	Collision value of tile at object's position + offset
; @param[out]	b	Tile index at object's position + offset
; @param[out]	hl	Address of collision value
; @addr{44f1}
_specialObjectGetRelativeTileWithDirectionTable:
	ld e,SpecialObject.direction		; $44f1
	ld a,(de)		; $44f3
	rst_addDoubleIndex			; $44f4

;;
; @param	d	Special object
; @param	hl	Address of Y/X offsets to use relative to object
; @param[out]	a	Collision value of tile at object's position + offset
; @param[out]	b	Tile index at object's position + offset
; @param[out]	hl	Address of collision value
; @addr{44f5}
_specialObjectGetRelativeTileFromHl:
	ldi a,(hl)		; $44f5
	ld b,a			; $44f6
	ld c,(hl)		; $44f7
	call objectGetRelativeTile		; $44f8
	ld b,a			; $44fb
	ld h,>wRoomCollisions		; $44fc
	ld a,(hl)		; $44fe
	ret			; $44ff

;;
; @param[out]	zflag	nz if an object is moving away from a wall
; @addr{4500}
_specialObjectCheckMovingAwayFromWall:
	; Check that the object is trying to move
	ld h,d			; $4500
	ld l,SpecialObject.angle		; $4501
	ld a,(hl)		; $4503
	cp $ff			; $4504
	ret z			; $4506

	; Invert angle
	add $10			; $4507
	and $1f			; $4509
	ld (hl),a		; $450b

	call _specialObjectCheckFacingWall		; $450c
	ld c,a			; $450f

	; Uninvert angle
	ld l,SpecialObject.angle		; $4510
	ld a,(hl)		; $4512
	add $10			; $4513
	and $1f			; $4515
	ld (hl),a		; $4517

	ld a,c			; $4518
	or a			; $4519
	ret			; $451a

;;
; Checks if an object is directly against a wall and trying to move toward it
;
; @param	d	Special object
; @param[out]	a	The bits from adjacentWallsBitset corresponding to the direction
;			it's moving in
; @param[out]	zflag	nz if an object is moving toward a wall
; @addr{451b}
_specialObjectCheckMovingTowardWall:
	; Check that the object is trying to move
	ld h,d			; $451b
	ld l,SpecialObject.angle		; $451c
	ld a,(hl)		; $451e
	cp $ff			; $451f
	ret z			; $4521

;;
; @param	a	Should equal object's angle value
; @param	h	Special object
; @param[out]	a	The bits from adjacentWallsBitset corresponding to the direction
;			it's moving in
; @addr{4522}
_specialObjectCheckFacingWall:
	ld bc,$0000		; $4522

	; Check if straight left or right
	cp $08			; $4525
	jr z,@checkVertical	; $4527
	cp $18			; $4529
	jr z,@checkVertical	; $452b

	ld l,SpecialObject.adjacentWallsBitset		; $452d
	ld b,(hl)		; $452f
	add a			; $4530
	swap a			; $4531
	and $03
	ld a,$30		; $4535
	jr nz,+			; $4537
	ld a,$c0		; $4539
+
	and b			; $453b
	ld b,a			; $453c

@checkVertical:
	; Check if straight up or down
	ld l,SpecialObject.angle		; $453d
	ld a,(hl)		; $453f
	and $0f			; $4540
	jr z,@ret		; $4542

	ld a,(hl)		; $4544
	ld l,SpecialObject.adjacentWallsBitset		; $4545
	ld c,(hl)		; $4547
	bit 4,a ; Check if angle is to the left
	ld a,$03		; $454a
	jr z,+			; $454c
	ld a,$0c		; $454e
+
	and c			; $4550
	ld c,a			; $4551

@ret:
	ld a,b			; $4552
	or c			; $4553
	ret			; $4554

;;
; Create an item which deals damage 7.
;
; @param	bc	Item ID
; @addr{4555}
_companionCreateItem:
	call getFreeItemSlot		; $4555
	ret nz			; $4558
	jr ++			; $4559

;;
; Create the weapon item which deals damage 7.
;
; @param	bc	Item ID
; @addr{455b}
_companionCreateWeaponItem:
	ld hl,w1WeaponItem.enabled		; $455b
	ld a,(hl)		; $455e
	or a			; $455f
	ret nz			; $4560
++
	inc (hl)		; $4561
	inc l			; $4562
	ld (hl),b		; $4563
	inc l			; $4564
	ld (hl),c		; $4565
	ld l,Item.damage		; $4566
	ld (hl),-7		; $4568
	xor a			; $456a
	ret			; $456b

;;
; Animates a companion, also checks whether the animation needs to change based on
; direction.
;
; @param	c	Base animation index?
; @addr{456c}
_companionUpdateDirectionAndAnimate:
	ld e,SpecialObject.direction		; $456c
	ld a,(de)		; $456e
	ld (w1Link.direction),a		; $456f
	ld e,SpecialObject.state		; $4572
	ld a,(de)		; $4574
	cp $0c			; $4575
	jp z,specialObjectAnimate		; $4577

	call updateLinkDirectionFromAngle		; $457a
	ld hl,w1Companion.direction		; $457d
	cp (hl)			; $4580
	jp z,specialObjectAnimate		; $4581

;;
; Same as below, but updates the companion's direction based on its angle first?
;
; @param	c	Base animation index?
; @addr{4584}
_companionUpdateDirectionAndSetAnimation:
	ld e,SpecialObject.angle		; $4584
	ld a,(de)		; $4586
	add a			; $4587
	swap a			; $4588
	and $03			; $458a
	dec e			; $458c
	ld (de),a		; $458d

;;
; @param	c	Base animation index? (Added with direction, var38)
; @addr{458e}
_companionSetAnimation:
	ld h,d			; $458e
	ld a,c			; $458f
	ld l,SpecialObject.direction		; $4590
	add (hl)		; $4592
	ld l,SpecialObject.var38		; $4593
	add (hl)		; $4595
	jp specialObjectSetAnimation		; $4596

;;
; Relates to mounting a companion?
;
; @param[out]	zflag	Set if mounted successfully?
; @addr{4599}
_companionTryToMount:
	ld a,(wActiveTileType)		; $4599
	cp TILETYPE_HOLE			; $459c
	jr z,@cantMount	; $459e
	ld a,(wDisallowMountingCompanion)		; $45a0
	or a			; $45a3
	jr nz,@cantMount	; $45a4

	call checkLinkVulnerableAndIDZero		; $45a6
	jr c,@tryMounting	; $45a9

@cantMount:
	or d			; $45ab
	ret			; $45ac

@tryMounting:
	ld a,(w1Link.state)		; $45ad
	cp LINK_STATE_NORMAL			; $45b0
	ret nz			; $45b2
	ld a,(wLinkSwimmingState)		; $45b3
	or a			; $45b6
	ret nz			; $45b7
	ld a,(wLinkGrabState)		; $45b8
	or a			; $45bb
	ret nz			; $45bc
	ld a,(wLinkInAir)		; $45bd
	or a			; $45c0
	ret nz			; $45c1

	; Link can mount the companion. Set up all variables accordingly.

	inc a			; $45c2
	ld (wcc90),a		; $45c3
	ld (wWarpsDisabled),a		; $45c6
	ld e,SpecialObject.state		; $45c9
	ld a,$03		; $45cb
	ld (de),a		; $45cd

	ld a,$ff		; $45ce

;;
; Sets Link's speed and speedZ to be the values needed for mounting or dismounting
; a companion.
;
; @param	a	Link's angle
; @addr{45d0}
_setLinkMountingSpeed:
	ld (wLinkAngle),a		; $45d0
	ld a,$81		; $45d3
	ld (wLinkInAir),a		; $45d5
	ld (wDisableScreenTransitions),a		; $45d8
	ld hl,w1Link.angle		; $45db
	ld (hl),a		; $45de

	ld l,<w1Link.speed		; $45df
	ld (hl),SPEED_80		; $45e1

	ld l,<w1Link.speedZ		; $45e3
	ld (hl),$40		; $45e5
	inc l			; $45e7
	ld (hl),$fe		; $45e8
	xor a			; $45ea
	ret			; $45eb

;;
; @param[out]	a	Hazard type (see "objectCheckIsOnHazard")
; @param[out]	cflag	Set if the companion is on a hazard
; @addr{45ec}
_companionCheckHazards:
	call objectCheckIsOnHazard		; $45ec
	ld h,d			; $45ef
	ret nc			; $45f0

;;
; Sets a companion's state to 4, which handles falling in a hazard.
; @addr{45f1}
_companionGotoHazardHandlingState:
	push af			; $45f1
	ld l,SpecialObject.state		; $45f2
	ld a,$04		; $45f4
	ldi (hl),a		; $45f6
	xor a			; $45f7
	ldi (hl),a ; [state2] = 0
	ldi (hl),a ; [counter1] = 0

	ld l,SpecialObject.id		; $45fa
	ld a,(hl)		; $45fc
	cp SPECIALOBJECTID_DIMITRI			; $45fd
	jr z,@ret	; $45ff
	ld (wDisableScreenTransitions),a		; $4601
	ld a,SND_SPLASH		; $4604
	call playSound		; $4606
@ret:
	pop af			; $4609
	scf			; $460a
	ret			; $460b

;;
; @addr{460c}
companionDismountAndSavePosition:
	call companionDismount		; $460c

	; The below code checks your animal companion, but ultimately appears to do the
	; same thing in all cases.

	ld e,SpecialObject.id		; $460f
	ld a,(de)		; $4611
	ld hl,wAnimalCompanion		; $4612
	cp (hl)			; $4615
	jr z,@normalDismount	; $4616

	cp SPECIALOBJECTID_RICKY			; $4618
	jr z,@ricky		; $461a
	cp SPECIALOBJECTID_DIMITRI			; $461c
	jr z,@dimitri		; $461e
@moosh:
	jr @normalDismount		; $4620
@ricky:
	jr @normalDismount		; $4622
@dimitri:
	jr @normalDismount		; $4624

	; Unused code? (dismount and don't save companion's position)
	call saveLinkLocalRespawnAndCompanionPosition		; $4626
	xor a			; $4629
	ld (wRememberedCompanionId),a		; $462a
	ret			; $462d

@normalDismount:
	jr saveLinkLocalRespawnAndCompanionPosition		; $462e

;;
; Called when dismounting an animal companion
;
; @addr{4630}
companionDismount:
	lda SPECIALOBJECTID_LINK			; $4630
	call setLinkID		; $4631
	ld hl,w1Link.oamFlagsBackup		; $4634
	ldi a,(hl)		; $4637
	ldd (hl),a		; $4638

	ld h,d			; $4639
	ldi a,(hl)		; $463a
	ld (hl),a		; $463b

	xor a			; $463c
	ld l,SpecialObject.damageToApply		; $463d
	ld (hl),a		; $463f

	; Clear invincibilityCounter, knockbackAngle, knockbackCounter
	ld l,SpecialObject.invincibilityCounter		; $4640
	ldi (hl),a		; $4642
	ldi (hl),a		; $4643
	ld (hl),a		; $4644

	ld l,SpecialObject.var3c		; $4645
	ld (hl),a		; $4647

	ld (wLinkForceState),a		; $4648
	ld (wcc50),a		; $464b

	ld l,SpecialObject.enabled		; $464e
	ld (hl),$01		; $4650

	; Calculate angle based on direction
	ld l,SpecialObject.direction		; $4652
	ldi a,(hl)		; $4654
	swap a			; $4655
	srl a			; $4657
	ld (hl),a		; $4659

	call _setLinkMountingSpeed		; $465a

	ld hl,w1Link.angle		; $465d
	ld (hl),$ff		; $4660

	call objectCopyPosition		; $4662

	; Set w1Link.zh to $f8
	dec l			; $4665
	ld (hl),$f8		; $4666

	; Set wLinkObjectIndex to $d0 (no longer riding an animal)
	ld a,h			; $4668
	ld (wLinkObjectIndex),a		; $4669

	xor a			; $466c
	ld (wcc90),a		; $466d
	ld (wWarpsDisabled),a		; $4670
	ld (wForceCompanionDismount),a		; $4673
	ld (wDisableScreenTransitions),a		; $4676
	jp setCameraFocusedObjectToLink		; $4679

;;
; @addr{467c}
saveLinkLocalRespawnAndCompanionPosition:
	ld hl,wRememberedCompanionId		; $467c
	ld a,(w1Companion.id)		; $467f
	ldi (hl),a		; $4682

	ld a,(wActiveGroup)		; $4683
	ldi (hl),a		; $4686
	ld a,(wActiveRoom)		; $4687
	ldi (hl),a		; $468a

	ld a,(w1Companion.direction)		; $468b
	ld (wLinkLocalRespawnDir),a		; $468e

	ld a,(w1Companion.yh)		; $4691
	ldi (hl),a		; $4694
	ld (wLinkLocalRespawnY),a		; $4695

	ld a,(w1Companion.xh)		; $4698
	ldi (hl),a		; $469b
	ld (wLinkLocalRespawnX),a		; $469c
	ret			; $469f

;;
; @param[out]	zflag	Set if the companion has reached the center of the hole
; @addr{46a0}
_companionDragToCenterOfHole:
	ld e,SpecialObject.var3d		; $46a0
	ld a,(de)		; $46a2
	or a			; $46a3
	jr z,+			; $46a4
	xor a			; $46a6
	ret			; $46a7
+
	; Get the center of the hole tile in bc
	ld bc,$0500		; $46a8
	call objectGetRelativeTile		; $46ab
	ld c,l			; $46ae
	call convertShortToLongPosition_paramC		; $46af

	; Now drag the companion's X and Y values toward the hole by $40 subpixels per
	; frame (for X and Y).
@adjustX:
	ld e,SpecialObject.xh		; $46b2
	ld a,(de)		; $46b4
	cp c			; $46b5
	ld c,$00		; $46b6
	jr z,@adjustY		; $46b8

	ld hl, $40		; $46ba
	jr c,+			; $46bd
	ld hl,-$40		; $46bf
+
	; [SpecialObject.x] += hl
	dec e			; $46c2
	ld a,(de)		; $46c3
	add l			; $46c4
	ld (de),a		; $46c5
	inc e			; $46c6
	ld a,(de)		; $46c7
	adc h			; $46c8
	ld (de),a		; $46c9

	dec c			; $46ca

@adjustY:
	ld e,SpecialObject.yh		; $46cb
	ld a,(de)		; $46cd
	cp b			; $46ce
	jr z,@return		; $46cf

	ld hl, $40		; $46d1
	jr c,+			; $46d4
	ld hl,-$40		; $46d6
+
	; [SpecialObject.y] += hl
	dec e			; $46d9
	ld a,(de)		; $46da
	add l			; $46db
	ld (de),a		; $46dc
	inc e			; $46dd
	ld a,(de)		; $46de
	adc h			; $46df
	ld (de),a		; $46e0

	dec c			; $46e1

@return:
	ld h,d			; $46e2
	ld a,c			; $46e3
	or a			; $46e4
	ret			; $46e5

;;
; @addr{46e6}
_companionRespawn:
	xor a			; $46e6
	ld (wDisableScreenTransitions),a		; $46e7
	ld (wLinkForceState),a		; $46ea
	ld (wcc50),a		; $46ed

	; Set animal's position to respawn point, then check if the position is valid
	call specialObjectSetCoordinatesToRespawnYX		; $46f0
	call objectCheckSimpleCollision		; $46f3
	jr nz,@invalidPosition		; $46f6

	call objectGetPosition		; $46f8
	call _checkCollisionForCompanion		; $46fb
	jr c,@invalidPosition	; $46fe

	call objectCheckIsOnHazard		; $4700
	jr nc,@applyDamageAndSetState	; $4703

@invalidPosition:
	; Current position is invalid, so change respawn to the last animal mount point
	ld h,d			; $4705
	ld l,SpecialObject.yh		; $4706
	ld a,(wLastAnimalMountPointY)		; $4708
	ld (wLinkLocalRespawnY),a		; $470b
	ldi (hl),a		; $470e
	inc l			; $470f
	ld a,(wLastAnimalMountPointX)		; $4710
	ld (wLinkLocalRespawnX),a		; $4713
	ldi (hl),a		; $4716

@applyDamageAndSetState:
	; Apply damage to Link only if he's on the companion
	ld a,(wLinkObjectIndex)		; $4717
	rrca			; $471a
	ld a,$01		; $471b
	jr nc,@setState	; $471d

	ld a,-2			; $471f
	ld (w1Link.damageToApply),a		; $4721
	ld a,$40		; $4724
	ld (w1Link.invincibilityCounter),a		; $4726

	ld a,$05		; $4729
@setState:
	ld h,d			; $472b
	ld l,SpecialObject.state		; $472c
	ldi (hl),a		; $472e
	xor a			; $472f
	ld (hl),a ; [state2] = 0

	ld l,SpecialObject.var3d		; $4731
	ld (hl),a		; $4733
	ld (wDisableScreenTransitions),a		; $4734

	ld l,SpecialObject.collisionType		; $4737
	res 7,(hl)		; $4739
	ret			; $473b

;;
; Checks if a companion's moving toward a cliff from the top, to hop down if so.
;
; @param[out]	zflag	Set if the companion should hop down a cliff
; @addr{473c}
_companionCheckHopDownCliff:
	; Make sure we're not moving at an angle
	ld a,(wLinkAngle)		; $473c
	ld c,a			; $473f
	and $e7			; $4740
	ret nz			; $4742

	; Check that the companion's angle equals Link's angle?
	ld e,SpecialObject.angle		; $4743
	ld a,(de)		; $4745
	cp c			; $4746
	ret nz			; $4747

	call _specialObjectCheckMovingTowardWall		; $4748
	cp $03  ; Wall to the right?
	jr z,++			; $474d
	cp $0c  ; Wall to the left?
	jr z,++			; $4751
	cp $30  ; Wall below?
	ret nz			; $4755
++
	; Get offset from companion's position for tile to check
	ld e,SpecialObject.direction		; $4756
	ld a,(de)		; $4758
	ld hl,@directionOffsets		; $4759
	rst_addDoubleIndex			; $475c
	ldi a,(hl)		; $475d
	ld b,a			; $475e
	ld c,(hl)		; $475f

	call objectGetRelativeTile		; $4760
	cp TILEINDEX_VINE_TOP			; $4763
	jr z,@vineTop		; $4765

	ld hl,cliffTilesTable		; $4767
	call lookupCollisionTable		; $476a
	jr c,@cliffTile		; $476d

	or d			; $476f
	ret			; $4770

@vineTop:
	ld a,$10		; $4771

@cliffTile:
	; 'a' should contain the desired angle to be moving in
	ld h,d			; $4773
	ld l,SpecialObject.angle		; $4774
	cp (hl)			; $4776
	ret nz			; $4777

	; Initiate hopping down

	ld a,$80		; $4778
	ld (wLinkInAir),a		; $477a
	ld bc,-$2c0		; $477d
	call objectSetSpeedZ		; $4780

	ld l,SpecialObject.speed		; $4783
	ld (hl),SPEED_200		; $4785
	ld l,SpecialObject.counter1		; $4787
	ld a,$14		; $4789
	ldi (hl),a		; $478b
	xor a			; $478c
	ld (hl),a ; [counter2] = 0

	ld l,SpecialObject.state		; $478e
	ld a,$07		; $4790
	ldi (hl),a		; $4792
	xor a			; $4793
	ld (hl),a ; [state2] = 0
	ret			; $4795


@directionOffsets:
	.db $fa $00 ; DIR_UP
	.db $00 $04 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $fb ; DIR_LEFT

;;
; Sets a bunch of variables the moment Link completes the mounting animation.
; @addr{479e}
_companionFinalizeMounting:
	ld h,d			; $479e
	ld l,SpecialObject.enabled		; $479f
	set 1,(hl)		; $47a1

	ld l,SpecialObject.state		; $47a3
	ld (hl),$05		; $47a5

	ld l,SpecialObject.angle		; $47a7
	ld a,$ff		; $47a9
	ld (hl),a		; $47ab
	ld l,SpecialObject.var3c		; $47ac
	ld (hl),a		; $47ae

	; Give companion draw priority 1
	ld l,SpecialObject.visible		; $47af
	ld a,(hl)		; $47b1
	and $c0			; $47b2
	or $01			; $47b4
	ld (hl),a		; $47b6

	xor a			; $47b7
	ld l,SpecialObject.var3d		; $47b8
	ld (hl),a		; $47ba
	ld (wLinkInAir),a		; $47bb
	ld (wDisableScreenTransitions),a		; $47be

	ld bc,wLastAnimalMountPointY		; $47c1
	ld l,SpecialObject.yh		; $47c4
	ldi a,(hl)		; $47c6
	ld (bc),a		; $47c7
	inc c			; $47c8
	inc l			; $47c9
	ld a,(hl)		; $47ca
	ld (bc),a		; $47cb

	ld a,d			; $47cc
	ld (wLinkObjectIndex),a		; $47cd
	call setCameraFocusedObjectToLink		; $47d0
	ld a,SPECIALOBJECTID_LINK_RIDING_ANIMAL		; $47d3
	jp setLinkID		; $47d5

;;
; Something to do with dismounting companions?
;
; @param[out]	zflag
; @addr{47d8}
_companionFunc_47d8:
	ld h,d			; $47d8
	ld l,SpecialObject.var3c		; $47d9
	ld a,(hl)		; $47db
	or a			; $47dc
	ret z			; $47dd
	ld a,(wLinkDeathTrigger)		; $47de
	or a			; $47e1
	ret z			; $47e2

	xor a			; $47e3
	ld (hl),a ; [var3c] = 0
	ld e,SpecialObject.z		; $47e5
	ldi (hl),a		; $47e7
	ldi (hl),a		; $47e8

	ld l,SpecialObject.state		; $47e9
	ld (hl),$09		; $47eb
	ld e,SpecialObject.oamFlagsBackup		; $47ed
	ldi a,(hl)		; $47ef
	ld (hl),a		; $47f0
	ld e,SpecialObject.visible		; $47f1
	xor a			; $47f3
	ld (de),a		; $47f4

	; Copy Link's position to companion
	ld h,>w1Link		; $47f5
	call objectCopyPosition		; $47f7
	ld a,h			; $47fa
	ld (wLinkObjectIndex),a		; $47fb
	call setCameraFocusedObjectToLink		; $47fe
	lda SPECIALOBJECTID_LINK			; $4801
	call setLinkID		; $4802
	or d			; $4805
	ret			; $4806

;;
; @addr{4807}
_companionGotoDismountState:
	ld e,SpecialObject.var38		; $4807
	ld a,(de)		; $4809
	or a			; $480a
	jr z,+			; $480b
	xor a			; $480d
	ld (wForceCompanionDismount),a		; $480e
	ret			; $4811
+
	; Go to state 6
	ld a,$06		; $4812
	jr ++			; $4814

;;
; Sets a companion's animation and returns to state 5, substate 0 (normal movement with
; Link)
;
; @param	c	Animation
; @addr{4816}
_companionSetAnimationAndGotoState5:
	call _companionSetAnimation		; $4816
	ld a,$05		; $4819
++
	ld e,SpecialObject.state		; $481b
	ld (de),a		; $481d
	inc e			; $481e
	xor a			; $481f
	ld (de),a		; $4820
	ret			; $4821

;;
; Called on initialization of companion. Checks if its current position is ok to spawn at?
; If so, this sets the companion's state to [var03]+1.
;
; May return from caller.
;
; @addr{4822}
_companionCheckCanSpawn:
	ld e,SpecialObject.state		; $4822
	ld a,(de)		; $4824
	or a			; $4825
	jr nz,@canSpawn		; $4826

	; Jump if [state2] != 0
	inc e			; $4828
	ld a,(de)		; $4829
	or a			; $482a
	jr nz,++		; $482b

	; Set [state2]=1, return from caller
	inc a			; $482d
	ld (de),a		; $482e
	pop af			; $482f
	ret			; $4830
++
	xor a			; $4831
	ld (de),a ; [state2] = 0

	; Delete self if there's already a solid object in its position
	call objectGetShortPosition		; $4833
	ld b,a			; $4836
	ld a,:w2SolidObjectPositions		; $4837
	ld ($ff00+R_SVBK),a	; $4839
	ld a,b			; $483b
	ld hl,w2SolidObjectPositions		; $483c
	call checkFlag		; $483f
	ld a,$00		; $4842
	ld ($ff00+R_SVBK),a	; $4844
	jr z,+			; $4846
	pop af			; $4848
	jp itemDelete		; $4849
+
	; If the tile at the animal's feet is not completely solid or a hole, it can
	; spawn here.
	ld e,SpecialObject.yh		; $484c
	ld a,(de)		; $484e
	add $05			; $484f
	ld b,a			; $4851
	ld e,SpecialObject.xh		; $4852
	ld a,(de)		; $4854
	ld c,a			; $4855
	call getTileCollisionsAtPosition		; $4856
	cp SPECIALCOLLISION_HOLE			; $4859
	jr z,+			; $485b
	cp $0f			; $485d
	jr nz,@canSpawn		; $485f
+
	; It can't spawn where it is, so try to spawn it somewhere else.
	ld hl,wLastAnimalMountPointY		; $4861
	ldi a,(hl)		; $4864
	ld e,SpecialObject.yh		; $4865
	ld (de),a		; $4867
	ld a,(hl)		; $4868
	ld e,SpecialObject.xh		; $4869
	ld (de),a		; $486b
	call objectGetTileCollisions		; $486c
	jr z,@canSpawn		; $486f
	pop af			; $4871
	jp itemDelete		; $4872

@canSpawn:
	call specialObjectSetOamVariables		; $4875

	ld hl,w1Companion.var03		; $4878
	ldi a,(hl)		; $487b
	inc a			; $487c
	ld (hl),a ; [state] = [var03]+1

	ld l,SpecialObject.collisionType		; $487e
	ld (hl),$80|ITEMCOLLISION_LINK		; $4880
	ret			; $4882

;;
; Returns from caller if the companion should not be updated right now.
;
; @addr{4883}
_companionRetIfInactive:
	; Always update when in state 0 (uninitialized)
	ld e,SpecialObject.state		; $4883
	ld a,(de)		; $4885
	or a			; $4886
	ret z			; $4887

	; Don't update when text is on-screen
	ld a,(wTextIsActive)		; $4888
	or a			; $488b
	jr nz,_companionRetIfInactiveWithoutStateCheck@ret	; $488c

;;
; @addr{488e}
_companionRetIfInactiveWithoutStateCheck:
	; Don't update when screen is scrolling, palette is fading, or wDisabledObjects is
	; set to something.
	ld a,(wScrollMode)		; $488e
	and $0e			; $4891
	jr nz,@ret	; $4893
	ld a,(wPaletteThread_mode)		; $4895
	or a			; $4898
	jr nz,@ret	; $4899
	ld a,(wDisabledObjects)		; $489b
	and (DISABLE_ALL_BUT_INTERACTIONS | DISABLE_COMPANION)			; $489e
	ret z			; $48a0
@ret:
	pop af			; $48a1
	ret			; $48a2

;;
; @addr{48a3}
_companionSetAnimationToVar3f:
	ld h,d			; $48a3
	ld l,SpecialObject.var3f		; $48a4
	ld a,(hl)		; $48a6
	ld l,SpecialObject.animMode		; $48a7
	cp (hl)			; $48a9
	jp nz,specialObjectSetAnimation		; $48aa
	ret			; $48ad

;;
; Manipulates a companion's oam flags to make it flash when charging an attack.
; @addr{48ae}
_companionFlashFromChargingAnimation:
	ld hl,w1Link.oamFlagsBackup		; $48ae
	ld a,(wFrameCounter)		; $48b1
	bit 2,a			; $48b4
	jr nz,++		; $48b6
	ldi a,(hl)		; $48b8
	and $f8			; $48b9
	or c			; $48bb
	ld (hl),a		; $48bc
	ret			; $48bd
++
	ldi a,(hl)		; $48be
	ld (hl),a		; $48bf
	ret			; $48c0

;;
; @param[out]	zflag	Set if complete
; @addr{48c1}
_companionCheckMountingComplete:
	; Check if something interrupted the mounting?
	ld a,(wDisallowMountingCompanion)		; $48c1
	or a			; $48c4
	jr nz,@stopMounting	; $48c5
	ld a,(w1Link.state)		; $48c7
	cp LINK_STATE_NORMAL			; $48ca
	jr nz,@stopMounting	; $48cc
	ld a,(wLinkGrabState)		; $48ce
	or a			; $48d1
	jr z,@continue	; $48d2

@stopMounting:
	xor a			; $48d4
	ld (wcc90),a		; $48d5
	ld (wWarpsDisabled),a		; $48d8
	ld (wDisableScreenTransitions),a		; $48db
	ld a,$01		; $48de
	ld e,SpecialObject.state		; $48e0
	ld (de),a		; $48e2
	or d			; $48e3
	ret			; $48e4

@continue:
	ld hl,w1Link.yh		; $48e5
	ld e,SpecialObject.yh		; $48e8
	ld a,(de)		; $48ea
	cp (hl)			; $48eb
	call nz,@nudgeLinkTowardCompanion		; $48ec

	ld e,SpecialObject.xh		; $48ef
	ld l,e			; $48f1
	ld a,(de)		; $48f2
	cp (hl)			; $48f3
	call nz,@nudgeLinkTowardCompanion		; $48f4

	; Check if Link has fallen far enough down to complete the mounting animation
	ld l,<w1Link.speedZ+1		; $48f7
	bit 7,(hl)		; $48f9
	ret nz			; $48fb
	ld l,SpecialObject.zh		; $48fc
	ld a,(hl)		; $48fe
	cp $fc			; $48ff
	ret c			; $4901
	xor a			; $4902
	ret			; $4903

@nudgeLinkTowardCompanion:
	jr c,+			; $4904
	inc (hl)		; $4906
	ret			; $4907
+
	dec (hl)		; $4908
	ret			; $4909

;;
; @addr{490a}
_companionCheckEnableTerrainEffects:
	ld h,d			; $490a
	ld l,SpecialObject.enabled		; $490b
	ld a,(hl)		; $490d
	or a			; $490e
	ret z			; $490f

	ld l,SpecialObject.var3c		; $4910
	ld a,(hl)		; $4912
	ld (wWarpsDisabled),a		; $4913

	; If in midair, enable terrain effects for shadows
	ld l,SpecialObject.zh		; $4916
	ldi a,(hl)		; $4918
	bit 7,a			; $4919
	jr nz,@enableTerrainEffects	; $491b

	; If on puddle, enable terrain effects for that
	ld bc,$0500		; $491d
	call objectGetRelativeTile		; $4920
	ld h,d			; $4923
	cp TILEINDEX_PUDDLE			; $4924
	jr nz,@label_05_067	; $4926

	; Disable terrain effects
	ld l,SpecialObject.visible		; $4928
	res 6,(hl)		; $492a
	ret			; $492c

@label_05_067:
	ld l,SpecialObject.zh		; $492d
	ld (hl),$00		; $492f

@enableTerrainEffects:
	ld l,SpecialObject.visible		; $4931
	set 6,(hl)		; $4933
	ret			; $4935

;;
; Set the animal's draw priority relative to Link's position.
; @addr{4936}
_companionSetPriorityRelativeToLink:
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $4936
	dec b			; $4939
	and $c0			; $493a
	or b			; $493c
	ld (de),a		; $493d
	ret			; $493e

;;
; Decrements counter1, and once it reaches 0, it plays the "jump" sound effect.
;
; @param[out]	cflag	nc if counter1 has reached 0 (should jump down the cliff).
; @param[out]	zflag	Same as carry
; @addr{493f}
_companionDecCounter1ToJumpDownCliff:
	ld e,SpecialObject.counter1		; $493f
	ld a,(de)		; $4941
	or a			; $4942
	jr z,@animate		; $4943

	dec a			; $4945
	ld (de),a		; $4946
	ld a,SND_JUMP		; $4947
	scf			; $4949
	ret nz			; $494a
	call playSound		; $494b
	xor a			; $494e
	scf			; $494f
	ret			; $4950

@animate:
	call specialObjectAnimate		; $4951
	call objectApplySpeed		; $4954
	ld c,$40		; $4957
	call objectUpdateSpeedZ_paramC		; $4959
	or d			; $495c
	ret			; $495d

;;
; @addr{495e}
_companionDecCounter1IfNonzero:
	ld h,d			; $495e
	ld l,SpecialObject.counter1		; $495f
	ld a,(hl)		; $4961
	or a			; $4962
	ret z			; $4963
	dec (hl)		; $4964
	ret			; $4965

;;
; Updates animation, and respawns the companion when the animation is over (bit 7 of
; animParameter is set).
;
; @param[out]	cflag	Set if the animation finished and the companion has respawned.
; @addr{4966}
_companionAnimateDrowningOrFallingThenRespawn:
	call specialObjectAnimate		; $4966
	ld e,SpecialObject.animParameter		; $4969
	ld a,(de)		; $496b
	rlca			; $496c
	ret nc			; $496d

	call _companionRespawn		; $496e
	scf			; $4971
	ret			; $4972

;;
; @param[out]	hl	Companion's counter2 variable
; @addr{4973}
_companionInitializeOnEnteringScreen:
	call _companionCheckCanSpawn		; $4973
	ld l,SpecialObject.state		; $4976
	ld (hl),$0c		; $4978
	ld l,SpecialObject.var03		; $497a
	inc (hl)		; $497c
	ld l,SpecialObject.counter2		; $497d
	jp objectSetVisiblec1		; $497f

;;
; Used with dimitri and moosh when they're walking into the screen.
;
; @param	hl	Table of direction offsets
; @addr{4982}
_companionRetIfNotFinishedWalkingIn:
	; Check that the tile in front has collision value 0
	call _specialObjectGetRelativeTileWithDirectionTable		; $4982
	or a			; $4985
	ret nz			; $4986

	; Decrement counter2
	ld e,SpecialObject.counter2		; $4987
	ld a,(de)		; $4989
	dec a			; $498a
	ld (de),a		; $498b
	ret z			; $498c

	; Return from caller if counter2 is nonzero
	pop af			; $498d
	ret			; $498e

;;
; @addr{498f}
_companionForceMount:
	ld a,(wMenuDisabled)		; $498f
	push af			; $4992
	xor a			; $4993
	ld (wMenuDisabled),a		; $4994
	ld (w1Link.invincibilityCounter),a		; $4997
	call _companionTryToMount		; $499a
	pop af			; $499d
	ld (wMenuDisabled),a		; $499e
	ret			; $49a1

;;
; @addr{49a2}
_companionDecCounter1:
	ld h,d			; $49a2
	ld l,SpecialObject.counter1		; $49a3
	ld a,(hl)		; $49a5
	or a			; $49a6
	ret			; $49a7

;;
; @addr{49a8}
specialObjectTryToBreakTile_source05:
	ld h,d			; $49a8
	ld l,<w1Link.yh		; $49a9
	ldi a,(hl)		; $49ab
	inc l			; $49ac
	ld c,(hl)		; $49ad
	add $05		; $49ae
	ld b,a			; $49b0
	ld a,BREAKABLETILESOURCE_05		; $49b1
	jp tryToBreakTile		; $49b3

;;
; Update the link object.
; @param d Link object
; @addr{49b6}
specialObjectCode_link:
	ld e,<w1Link.state		; $49b6
	ld a,(de)		; $49b8
	rst_jumpTable			; $49b9
	.dw _linkState00
	.dw _linkState01
	.dw _linkState02
	.dw _linkState03
	.dw _linkState04
	.dw _linkState05
	.dw _linkState06
	.dw linkState07
	.dw _linkState08
	.dw _linkState09
	.dw _linkState0a
	.dw _linkState0b
	.dw _linkState0c
	.dw _linkState0d
	.dw _linkState0e
	.dw _linkState0f
	.dw _linkState10
	.dw _linkState11
	.dw _linkState12
	.dw _linkState13
	.dw _linkState14

;;
; LINK_STATE_00
; @addr{49e4}
_linkState00:
	call clearAllParentItems		; $49e4
	call specialObjectSetOamVariables		; $49e7
	ld a,LINK_ANIM_MODE_WALK		; $49ea
	call specialObjectSetAnimation		; $49ec

	; Enable collisions?
	ld h,d			; $49ef
	ld l,SpecialObject.collisionType		; $49f0
	ld a,$80		; $49f2
	ldi (hl),a		; $49f4

	; Set collisionRadiusY,X
	inc l			; $49f5
	ld a,$06		; $49f6
	ldi (hl),a		; $49f8
	ldi (hl),a		; $49f9

	; A non-dead default health?
	ld l,SpecialObject.health		; $49fa
	ld (hl),$01		; $49fc

	; Do a series of checks to see whether Link spawned in an invalid position.

	ld a,(wLinkForceState)		; $49fe
	cp LINK_STATE_WARPING			; $4a01
	jr z,+			; $4a03

	ld a,(wDisableRingTransformations)		; $4a05
	or a			; $4a08
	jr nz,+			; $4a09

	; Check if he's in a solid wall
	call objectGetTileCollisions		; $4a0b
	cp $0f			; $4a0e
	jr nz,+			; $4a10

	; If he's in a wall, move Link to wLastAnimalMountPointY/X?
	ld hl,wLastAnimalMountPointY		; $4a12
	ldi a,(hl)		; $4a15
	ld e,<w1Link.yh		; $4a16
	ld (de),a		; $4a18
	ld a,(hl)		; $4a19
	ld e,<w1Link.xh		; $4a1a
	ld (de),a		; $4a1c
+
	call objectSetVisiblec1		; $4a1d
	call _checkLinkForceState		; $4a20
	jp _initLinkStateAndAnimateStanding		; $4a23

;;
; LINK_STATE_WARPING
; @addr{4a26}
_linkState0a:
	ld a,(wWarpTransition)		; $4a26
	and $0f			; $4a29
	rst_jumpTable			; $4a2b
	.dw _warpTransition0
	.dw _warpTransition1
	.dw _warpTransition2
	.dw _warpTransition3
	.dw _warpTransition4
	.dw _warpTransition5
	.dw _warpTransition6
	.dw _warpTransition7
	.dw _warpTransition8
	.dw _warpTransition9
	.dw _warpTransition7
	.dw _warpTransitionB
	.dw _warpTransitionC
	.dw _warpTransition7
	.dw _warpTransitionE
	.dw _warpTransitionF

;;
; @addr{4a4c}
_warpTransition0:
	call _warpTransition_setLinkFacingDir		; $4a4c
;;
; @addr{4a4f}
_warpTransition7:
	jp _initLinkStateAndAnimateStanding		; $4a4f

;;
; Transition E shifts Link's X position left 8, but otherwise behaves like Transition 1
; @addr{4a52}
_warpTransitionE:
	call objectCenterOnTile		; $4a52
	ld a,(hl)		; $4a55
	and $f0			; $4a56
	ld (hl),a		; $4a58

;;
; Transition 1 behaves like transition 0, but saves link's deathwarp point
; @addr{4a59}
_warpTransition1:
	call _warpTransition_setLinkFacingDir		; $4a59

;;
; @addr{4a5c}
_warpUpdateRespawnPoint:
	ld a,(wActiveGroup)		; $4a5c
	cp NUM_UNIQUE_GROUPS		; $4a5f
	jr nc,_warpTransition0		; $4a61
	call setDeathRespawnPoint		; $4a63
	call updateLinkLocalRespawnPosition		; $4a66
	jp _initLinkStateAndAnimateStanding		; $4a69

;;
; Transition C behaves like transition 0, but sets link's facing direction in
; a way I don't understand
; @addr{4a6c}
_warpTransitionC:
	ld a,(wcc50)		; $4a6c
	and $03			; $4a6f
	ld e,<w1Link.direction	; $4a71
	ld (de),a		; $4a73
	jp _initLinkStateAndAnimateStanding		; $4a74

;;
; @addr{4a77}
_warpTransition_setLinkFacingDir:
	call objectGetTileAtPosition		; $4a77
	ld hl,_facingDirAfterWarpTable		; $4a7a
	call lookupCollisionTable		; $4a7d
	jr c,+			; $4a80
	ld a,DIR_DOWN		; $4a82
+
	ld e,<w1Link.direction	; $4a84
	ld (de),a		; $4a86
	ret			; $4a87

; @addr{4a88}
_facingDirAfterWarpTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions1:
	.db $36 DIR_UP ; Cave opening?

@collisions2:
@collisions3:
	.db $44 DIR_LEFT  ; Up stairs
	.db $45 DIR_RIGHT ; Down stairs

@collisions0:
@collisions4:
@collisions5:
	.db $00


;;
; Transition 2 is used by warp sources to fade out the screen.
; @addr{4a9b}
_warpTransition2:
	ld a,$03		; $4a9b
	ld (wWarpTransition2),a		; $4a9d
	ld a,SND_ENTERCAVE	; $4aa0
	jp playSound		; $4aa2

;;
; Transition 3 is used by both sources and destinations for transitions where
; link walks off the screen (or comes in from off the screen). It saves link's
; deathwarp point.
; @addr{4aa5}
_warpTransition3:
	ld e,<w1Link.warpVar1	; $4aa5
	ld a,(de)		; $4aa7
	or a			; $4aa8
	jr nz,@eachFrame	; $4aa9

	; Initialization stuff
	ld h,d			; $4aab
	ld l,e			; $4aac
	inc (hl)		; $4aad
	ld l,<w1Link.warpVar2	; $4aae
	ld (hl),$10		; $4ab0

	; Set link speed, up or down
	ld a,(wWarpTransition)		; $4ab2
	and $40			; $4ab5
	swap a			; $4ab7
	rrca			; $4ab9
	ld bc,@directionTable	; $4aba
	call addAToBc		; $4abd
	ld l,<w1Link.direction	; $4ac0
	ld a,(bc)		; $4ac2
	ldi (hl),a		; $4ac3
	inc bc			; $4ac4
	ld a,(bc)		; $4ac5
	ld (hl),a		; $4ac6

	call updateLinkSpeed_standard		; $4ac7
	call _animateLinkStanding		; $4aca
	ld a,(wWarpTransition)		; $4acd
	rlca			; $4ad0
	jr c,@destInit	; $4ad1

	ld a,SND_ENTERCAVE	; $4ad3
	jp playSound		; $4ad5

@directionTable: ; $4ad8
	.db $00 $00
	.db $02 $10

@eachFrame:
	ld a,(wScrollMode)		; $4adc
	and $0a			; $4adf
	ret nz			; $4ae1

	ld a,$00		; $4ae2
	ld (wScrollMode),a		; $4ae4
	call specialObjectAnimate		; $4ae7
	call itemDecCounter1		; $4aea
	jp nz,specialObjectUpdatePosition		; $4aed

	; Counter has reached zero
	ld a,$01		; $4af0
	ld (wScrollMode),a		; $4af2
	xor a			; $4af5
	ld (wMenuDisabled),a		; $4af6

	; Update respawn point if this is a destination
	ld a,(wWarpTransition)		; $4af9
	bit 7,a			; $4afc
	jp nz,_warpUpdateRespawnPoint		; $4afe

	swap a			; $4b01
	and $03			; $4b03
	ld (wWarpTransition2),a		; $4b05
	ret			; $4b08

@destInit:
	ld h,d			; $4b09
	ld a,(wWarpDestPos)		; $4b0a
	cp $ff			; $4b0d
	jr z,@enterFromMiddleBottom	; $4b0f

	cp $f0			; $4b11
	jr nc,@enterFromBottom		; $4b13

	ld l,<w1Link.yh		; $4b15
	call setShortPosition		; $4b17
	ld l,<w1Link.warpVar2	; $4b1a
	ld (hl),$1c		; $4b1c
	jp _initLinkStateAndAnimateStanding		; $4b1e

@enterFromMiddleBottom:
	ld a,$01		; $4b21
	ld (wMenuDisabled),a		; $4b23
	ld l,<w1Link.warpVar2	; $4b26
	ld (hl),$1c		; $4b28
	ld a,(wWarpTransition)		; $4b2a
	and $40			; $4b2d
	swap a			; $4b2f
	ld b,a			; $4b31
	ld a,(wActiveGroup)		; $4b32
	and NUM_SMALL_GROUPS	; $4b35
	rrca			; $4b37
	or b			; $4b38
	ld bc,@linkPosTable		; $4b39
	call addAToBc		; $4b3c
	ld l,<w1Link.yh		; $4b3f
	ld a,(bc)		; $4b41
	ldi (hl),a		; $4b42
	inc bc			; $4b43
	inc l			; $4b44
	ld a,(bc)		; $4b45
	ld (hl),a		; $4b46
	ret			; $4b47

@enterFromBottom:
	call @enterFromMiddleBottom	; $4b48
	ld a,(wWarpDestPos)		; $4b4b
	swap a			; $4b4e
	and $f0			; $4b50
	ld b,a			; $4b52
	ld a,(wActiveGroup)		; $4b53
	and NUM_SMALL_GROUPS		; $4b56
	jr z,+			; $4b58

	rlca			; $4b5a
+
	or b			; $4b5b
	ld l,<w1Link.xh		; $4b5c
	ld (hl),a		; $4b5e
	ret			; $4b5f

@linkPosTable:
	.db $80 $50 ; small room, enter from bottom
	.db $b0 $78 ; large room, enter from bottom
	.db $f0 $50 ; small room, enter from top
	.db $f0 $78 ; large room, enter from top

;;
; @addr{4b68}
_warpTransition4:
	ld a,(wWarpTransition)		; $4b68
	rlca			; $4b6b
	jp c,_warpTransition0		; $4b6c

	ld a,$01		; $4b6f
	ld (wWarpTransition2),a		; $4b71
	ld a,SND_ENTERCAVE	; $4b74
	jp playSound		; $4b76

;;
; Link falls into the screen
; @addr{4b79}
_warpTransition5:
	ld e,<w1Link.warpVar1	; $4b79
	ld a,(de)		; $4b7b
	rst_jumpTable			; $4b7c
	.dw _warpTransition5_00
	.dw _warpTransition5_01
	.dw _warpTransition5_02

_warpTransition5_00:
	ld a,$01		; $4b83
	ld (de),a		; $4b85
	ld bc,$0020		; $4b86
	call objectSetSpeedZ		; $4b89
	call objectGetZAboveScreen		; $4b8c
	ld l,<w1Link.zh		; $4b8f
	ld (hl),a		; $4b91
	ld l,<w1Link.yh		; $4b92
	ld a,(hl)		; $4b94
	sub $04			; $4b95
	ld (hl),a		; $4b97
	ld l,<w1Link.direction	; $4b98
	ld (hl),DIR_DOWN	; $4b9a
	ld a,LINK_ANIM_MODE_FALL	; $4b9c
	jp specialObjectSetAnimation		; $4b9e

_warpTransition5_01:
	call specialObjectAnimate		; $4ba1
	ld c,$20		; $4ba4
	call objectUpdateSpeedZ_paramC		; $4ba6
	ret nz			; $4ba9
	ld hl,hazardCollisionTable		; $4baa
	call lookupCollisionTable		; $4bad
	jp nc,func_4bb6@label_4c05		; $4bb0
	jp _initLinkStateAndAnimateStanding		; $4bb3

;;
; Unused?
; @addr{4bb6}
func_4bb6:
	ld e,<w1Link.warpVar1	; $4bb6
	ld a,(de)		; $4bb8
	rst_jumpTable			; $4bb9
	.dw @warpVar0
	.dw @warpVar1
	.dw @warpVar2
	.dw @warpVar3

@warpVar0:
	ld a,$01		; $4bc2
	ld (de),a		; $4bc4

	ld h,d			; $4bc5
	ld l,<w1Link.direction	; $4bc6
	ld (hl),DIR_DOWN	; $4bc8
	inc l			; $4bca
	ld (hl),$10		; $4bcb
	ld l,<w1Link.speed		; $4bcd
	ld (hl),SPEED_100		; $4bcf

	ld l,<w1Link.visible	; $4bd1
	res 7,(hl)		; $4bd3

	ld l,<w1Link.warpVar2	; $4bd5
	ld (hl),$78		; $4bd7

	ld a,LINK_ANIM_MODE_FALL	; $4bd9
	call specialObjectSetAnimation		; $4bdb

	ld a,SND_LINK_FALL	; $4bde
	jp playSound		; $4be0

@warpVar1:
	call itemDecCounter1		; $4be3
	ret nz			; $4be6

	ld l,<w1Link.warpVar1	; $4be7
	inc (hl)		; $4be9
	ld l,<w1Link.visible		; $4bea
	set 7,(hl)		; $4bec
	ld l,<w1Link.warpVar2	; $4bee
	ld (hl),$30		; $4bf0
	ld a,$10		; $4bf2
	call setScreenShakeCounter		; $4bf4
	ld a,SND_SCENT_SEED	; $4bf7
	jp playSound		; $4bf9

;;
; @addr{4bfc}
@warpVar2:
	call specialObjectAnimate		; $4bfc
	call itemDecCounter1		; $4bff
	jp nz,specialObjectUpdatePosition		; $4c02
;;
; @addr{4c05}
@label_4c05:
	call itemIncState2		; $4c05
	ld l,<w1Link.warpVar2	; $4c08
	ld (hl),$1e		; $4c0a
	ld a,LINK_ANIM_MODE_COLLAPSED	; $4c0c
	call specialObjectSetAnimation		; $4c0e
	ld a,SND_SPLASH		; $4c11
	jp playSound		; $4c13

;;
; @addr{4c16}
@warpVar3:
	call setDeathRespawnPoint		; $4c16

_warpTransition5_02:
	call itemDecCounter1		; $4c19
	ret nz			; $4c1c
	jp _initLinkStateAndAnimateStanding		; $4c1d

;;
; @addr{4c20}
_linkIncrementDirectionOnOddFrames:
	ld a,(wFrameCounter)		; $4c20
	rrca			; $4c23
	ret nc			; $4c24

;;
; @addr{4c25}
_linkIncrementDirection:
	ld e,<w1Link.direction	; $4c25
	ld a,(de)		; $4c27
	inc a			; $4c28
	and $03			; $4c29
	ld (de),a		; $4c2b
	ret			; $4c2c

;;
; A subrosian warp portal?
; @addr{4c2d}
_warpTransition8:
	ld e,SpecialObject.state2		; $4c2d
	ld a,(de)		; $4c2f
	rst_jumpTable			; $4c30
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7

@substate0:
	ld a,$01		; $4c41
	ld (de),a		; $4c43
	ld a,$ff		; $4c44
	ld (wDisabledObjects),a		; $4c46
	ld a,$80		; $4c49
	ld (wMenuDisabled),a		; $4c4b
	ld a,$15		; $4c4e
	ld (wCutsceneTrigger),a		; $4c50

	ld bc,$ff60		; $4c53
	call objectSetSpeedZ		; $4c56

	ld l,SpecialObject.counter1		; $4c59
	ld (hl),$30		; $4c5b

	call linkCancelAllItemUsage		; $4c5d
	call restartSound		; $4c60

	ld a,SND_FADEOUT		; $4c63
	call playSound		; $4c65
	jp objectCenterOnTile		; $4c68

@substate1:
	ld c,$02		; $4c6b
	call objectUpdateSpeedZ_paramC		; $4c6d
	ld a,(wFrameCounter)		; $4c70
	and $03			; $4c73
	jr nz,+			; $4c75
	ld hl,wTmpcbbc		; $4c77
	inc (hl)		; $4c7a
+
	ld a,(wFrameCounter)		; $4c7b
	and $03			; $4c7e
	call z,_linkIncrementDirection		; $4c80
	call itemDecCounter1		; $4c83
	ret nz			; $4c86
	jp itemIncState2		; $4c87

@substate2:
	ld c,$02		; $4c8a
	call objectUpdateSpeedZ_paramC		; $4c8c
	call _linkIncrementDirectionOnOddFrames		; $4c8f

	ld h,d			; $4c92
	ld l,SpecialObject.speedZ+1		; $4c93
	bit 7,(hl)		; $4c95
	ret nz			; $4c97

	ld l,SpecialObject.counter1		; $4c98
	ld (hl),$28		; $4c9a

	ld a,$02		; $4c9c
	call fadeoutToWhiteWithDelay		; $4c9e

	jp itemIncState2		; $4ca1

@substate3:
	call _linkIncrementDirectionOnOddFrames		; $4ca4
	call itemDecCounter1		; $4ca7
	ret nz			; $4caa
	ld hl,wTmpcbb3		; $4cab
	inc (hl)		; $4cae
	jp itemIncState2		; $4caf

@substate4:
	call _linkIncrementDirectionOnOddFrames		; $4cb2
	ld a,(wCutsceneState)		; $4cb5
	cp $02			; $4cb8
	ret nz			; $4cba
	call itemIncState2		; $4cbb
	ld l,SpecialObject.counter1		; $4cbe
	ld (hl),$28		; $4cc0
	ret			; $4cc2

@substate5:
	ld c,$02		; $4cc3
	call objectUpdateSpeedZ_paramC		; $4cc5
	call _linkIncrementDirectionOnOddFrames		; $4cc8
	call itemDecCounter1		; $4ccb
	ret nz			; $4cce
	jp itemIncState2		; $4ccf

@substate6:
	ld c,$02		; $4cd2
	call objectUpdateSpeedZ_paramC		; $4cd4
	ld a,(wFrameCounter)		; $4cd7
	and $03			; $4cda
	ret nz			; $4cdc

	call _linkIncrementDirection		; $4cdd
	ld hl,wTmpcbbc		; $4ce0
	dec (hl)		; $4ce3
	ret nz			; $4ce4

	ld hl,wTmpcbb3		; $4ce5
	inc (hl)		; $4ce8
	jp itemIncState2		; $4ce9

@substate7:
	ld a,(wDisabledObjects)		; $4cec
	and $81			; $4cef
	jr z,+			; $4cf1

	ld a,(wFrameCounter)		; $4cf3
	and $07			; $4cf6
	ret nz			; $4cf8
	jp _linkIncrementDirection		; $4cf9
+
	ld e,SpecialObject.direction		; $4cfc
	ld a,(de)		; $4cfe
	cp $02			; $4cff
	jp nz,_linkIncrementDirection		; $4d01
	ld a,(wActiveMusic2)		; $4d04
	ld (wActiveMusic),a		; $4d07
	call playSound		; $4d0a
	call setDeathRespawnPoint		; $4d0d
	call updateLinkLocalRespawnPosition		; $4d10
	call resetLinkInvincibility		; $4d13
	jp _initLinkStateAndAnimateStanding		; $4d16

;;
; @addr{4d19}
_warpTransition9:
	ld e,SpecialObject.state2		; $4d19
	ld a,(de)		; $4d1b
	rst_jumpTable			; $4d1c
	.dw @substate0
	.dw @substate1

@substate0:
	call itemIncState2		; $4d21

	ld l,SpecialObject.yh		; $4d24
	ld a,$08		; $4d26
	add (hl)		; $4d28
	ld (hl),a		; $4d29

	call objectCenterOnTile		; $4d2a
	call clearAllParentItems		; $4d2d

	ld a,LINK_ANIM_MODE_FALLINHOLE		; $4d30
	call specialObjectSetAnimation		; $4d32

	ld a,SND_LINK_FALL		; $4d35
	jp playSound		; $4d37

@substate1:
	ld e,SpecialObject.animParameter		; $4d3a
	ld a,(de)		; $4d3c
	inc a			; $4d3d
	jp nz,specialObjectAnimate		; $4d3e

	ld a,$03		; $4d41
	ld (wWarpTransition2),a		; $4d43
	ret			; $4d46

;;
; @addr{4d47}
_warpTransitionB:
	ld e,<w1Link.warpVar1	; $4d47
	ld a,(de)		; $4d49
	rst_jumpTable			; $4d4a
	.dw @warpVar0
	.dw @warpVar1
	.dw @warpVar2

@warpVar0:
	call itemIncState2		; $4d51

	call objectGetZAboveScreen		; $4d54
	ld l,<w1Link.zh		; $4d57
	ld (hl),a		; $4d59

	ld l,<w1Link.direction	; $4d5a
	ld (hl),DIR_DOWN	; $4d5c

	ld a,LINK_ANIM_MODE_FALL		; $4d5e
	jp specialObjectSetAnimation		; $4d60

@warpVar1:
	call specialObjectAnimate		; $4d63
	ld c,$0c		; $4d66
	call objectUpdateSpeedZ_paramC		; $4d68
	ret nz			; $4d6b

	call itemIncState2		; $4d6c
	call _animateLinkStanding		; $4d6f
	ld a,SND_SPLASH		; $4d72
	jp playSound		; $4d74

@warpVar2:
	ld a,(wDisabledObjects)		; $4d77
	and $81			; $4d7a
	ret nz			; $4d7c

	call objectSetVisiblec2		; $4d7d
	jp _initLinkStateAndAnimateStanding		; $4d80


;;
; @addr{4d83}
_warpTransitionF:
	call _checkLinkForceState		; $4d83
	jp objectSetInvisible		; $4d86

;;
; "Timewarp" transition
; @addr{4d89}
_warpTransition6:
	ld e,SpecialObject.state2		; $4d89
	ld a,(de)		; $4d8b
	rst_jumpTable			; $4d8c
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7

;;
; @addr{4d9d}
@flickerVisibilityAndDecCounter1:
	ld b,$03		; $4d9d
	call objectFlickerVisibility		; $4d9f
	jp itemDecCounter1		; $4da2

;;
; @addr{4da5}
@createDestinationTimewarpAnimation:
	call getFreeInteractionSlot		; $4da5
	ret nz			; $4da8
	ld (hl),INTERACID_TIMEWARP		; $4da9
	inc l			; $4dab
	inc (hl)		; $4dac

	; [Interaction.var03] = [wcc50]
	ld a,(wcc50)		; $4dad
	inc l			; $4db0
	ld (hl),a		; $4db1
	ret			; $4db2

;;
; This function should center Link if it detects that he's warped into a 2-tile-wide
; doorway.
; Except, it doesn't work. There's a typo.
; @addr{4db3}
@centerLinkOnDoorway:
	call objectGetTileAtPosition		; $4db3
	push hl			; $4db6

	; This should be "ld e,a" instead of "ld a,e".
	ld a,e			; $4db7

	ld hl,@doorTiles		; $4db8
	call findByteAtHl		; $4dbb
	pop hl			; $4dbe
	ret nc			; $4dbf

	push hl			; $4dc0
	dec l			; $4dc1
	ld e,(hl)		; $4dc2
	ld hl,@doorTiles		; $4dc3
	call findByteAtHl		; $4dc6
	pop hl			; $4dc9
	jr nc,+			; $4dca

	ld e,SpecialObject.xh		; $4dcc
	ld a,(de)		; $4dce
	and $f0			; $4dcf
	ld (de),a		; $4dd1
	ret			; $4dd2
+
	inc l			; $4dd3
	ld e,(hl)		; $4dd4
	ld hl,@doorTiles		; $4dd5
	call findByteAtHl		; $4dd8
	ret nc			; $4ddb

	ld e,SpecialObject.xh		; $4ddc
	ld a,(de)		; $4dde
	add $08			; $4ddf
	ld (de),a		; $4de1
	ld hl,wEnteredWarpPosition		; $4de2
	inc (hl)		; $4de5
	ret			; $4de6

; List of tile indices that are "door tiles" which initiate warps.
@doorTiles:
	.db $dc $dd $de $df $ed $ee $ef
	.db $00


; Initialization
@substate0:
	call itemIncState2		; $4def

	ld l,SpecialObject.counter1		; $4df2
	ld (hl),$1e		; $4df4
	ld l,SpecialObject.direction		; $4df6
	ld (hl),DIR_DOWN		; $4df8

	ld a,d			; $4dfa
	ld (wLinkCanPassNpcs),a		; $4dfb
	ld (wMenuDisabled),a		; $4dfe

	call @centerLinkOnDoorway		; $4e01
	jp objectSetInvisible		; $4e04


; Waiting for palette to fade in and counter1 to reach 0
@substate1:
	ld a,(wPaletteThread_mode)		; $4e07
	or a			; $4e0a
	ret nz			; $4e0b
	call itemDecCounter1		; $4e0c
	ret nz			; $4e0f

; Create the timewarp animation, and go to substate 4 if Link is obstructed from warping
; in, otherwise go to substate 2.

	ld (hl),$10		; $4e10
	call @createDestinationTimewarpAnimation		; $4e12

	ld a,(wSentBackByStrangeForce)		; $4e15
	dec a			; $4e18
	jr z,@warpFailed			; $4e19

	callab bank1.checkLinkCanStandOnTile		; $4e1b
	srl c			; $4e23
	jr c,@warpFailed			; $4e25

	callab bank1.checkSolidObjectAtWarpDestPos		; $4e27
	srl c			; $4e2f
	jr c,@warpFailed			; $4e31

	jp itemIncState2		; $4e33

	; Link will be returned to the time he came from.
@warpFailed:
	ld e,SpecialObject.state2		; $4e36
	ld a,$04		; $4e38
	ld (de),a		; $4e3a
	ret			; $4e3b


; Waiting several frames before making Link visible and playing the sound effect
@substate2:
	call itemDecCounter1		; $4e3c
	ret nz			; $4e3f

	ld (hl),$1e		; $4e40

@makeLinkVisibleAndPlaySound:
.ifdef ROM_AGES
	ld a,SND_TIMEWARP_COMPLETED		; $4e42
.else
	ld a,$d4
.endif
	call playSound		; $4e44
	call objectSetVisiblec0		; $4e47
	jp itemIncState2		; $4e4a


@substate3:
	call @flickerVisibilityAndDecCounter1		; $4e4d
	ret nz			; $4e50

; Warp is completed; create a time portal if necessary, restore control to Link

	; Check if a time portal should be created
	ld a,(wLinkTimeWarpTile)		; $4e51
	or a			; $4e54
	jr nz,++	; $4e55

	; Create a time portal
	ld hl,wPortalGroup		; $4e57
	ld a,(wActiveGroup)		; $4e5a
	ldi (hl),a		; $4e5d
	ld a,(wActiveRoom)		; $4e5e
	ldi (hl),a		; $4e61
	ld a,(wWarpDestPos)		; $4e62
	ld (hl),a		; $4e65
	ld c,a			; $4e66
	call getFreeInteractionSlot		; $4e67
	jr nz,++	; $4e6a

	ld (hl),INTERACID_TIMEPORTAL		; $4e6c
	ld l,Interaction.yh		; $4e6e
	call setShortPosition_paramC		; $4e70
++
	; Check whether to show the "Sent back by strange force" text.
	ld a,(wSentBackByStrangeForce)		; $4e73
	or a			; $4e76
	jr z,+			; $4e77
	ld bc,TX_5112		; $4e79
	call showText		; $4e7c
+
	; Restore everything to normal, give control back to Link.
	xor a			; $4e7f
	ld (wLinkTimeWarpTile),a		; $4e80
	ld (wWarpTransition),a		; $4e83
	ld (wLinkCanPassNpcs),a		; $4e86
	ld (wMenuDisabled),a		; $4e89
	ld (wSentBackByStrangeForce),a		; $4e8c
	ld (wcddf),a		; $4e8f
	ld (wcde0),a		; $4e92

	ld e,SpecialObject.invincibilityCounter		; $4e95
	ld a,$88		; $4e97
	ld (de),a		; $4e99

	call updateLinkLocalRespawnPosition		; $4e9a
	call objectSetVisiblec2		; $4e9d
	jp _initLinkStateAndAnimateStanding		; $4ea0


; Substates 4-7: Warp failed, Link will be sent back to the time he came from

@substate4:
	call itemDecCounter1		; $4ea3
	ret nz			; $4ea6

	ld (hl),$78		; $4ea7
	jr @makeLinkVisibleAndPlaySound		; $4ea9

@substate5:
	call @flickerVisibilityAndDecCounter1		; $4eab
	ret nz			; $4eae

	ld (hl),$10		; $4eaf
	call @createDestinationTimewarpAnimation		; $4eb1
	jp itemIncState2		; $4eb4

@substate6:
	call @flickerVisibilityAndDecCounter1		; $4eb7
	ret nz			; $4eba

	ld (hl),$14		; $4ebb
	call objectSetInvisible		; $4ebd
	jp itemIncState2		; $4ec0

@substate7:
	call itemDecCounter1		; $4ec3
	ret nz			; $4ec6

; Initiate another warp sending Link back to the time he came from

	call objectGetTileAtPosition		; $4ec7
	ld c,l			; $4eca

	ld hl,wWarpDestGroup		; $4ecb
	ld a,(wActiveGroup)		; $4ece
	xor $01			; $4ed1
	or $80			; $4ed3
	ldi (hl),a		; $4ed5

	; wWarpDestRoom
	ld a,(wActiveRoom)		; $4ed6
	ldi (hl),a		; $4ed9

	; wWarpTransition
	ld a,TRANSITION_DEST_TIMEWARP		; $4eda
	ldi (hl),a		; $4edc

	; wWarpDestPos
	ld a,c			; $4edd
	ldi (hl),a		; $4ede

	inc a			; $4edf
	ld (wLinkTimeWarpTile),a		; $4ee0
	ld (wcddf),a		; $4ee3

	; wWarpTransition2
	ld a,$03		; $4ee6
	ld (hl),a		; $4ee8

	xor a			; $4ee9
	ld (wScrollMode),a		; $4eea

	ld hl,wSentBackByStrangeForce		; $4eed
	ld a,(hl)		; $4ef0
	or a			; $4ef1
	jr z,+			; $4ef2
	inc (hl)		; $4ef4
+
	ld a,(wLinkStateParameter)		; $4ef5
	bit 4,a			; $4ef8
	jr nz,+			; $4efa
	call getThisRoomFlags		; $4efc
	res 4,(hl)		; $4eff
+
.ifdef ROM_AGES
	ld a,SND_TIMEWARP_COMPLETED		; $4f01
.else
	ld a,$d4
.endif
	call playSound		; $4f03

	ld de,w1Link		; $4f06
	jp objectDelete_de		; $4f09

;;
; LINK_STATE_08
; @addr{4f0c}
_linkState08:
	ld e,SpecialObject.state2		; $4f0c
	ld a,(de)		; $4f0e
	rst_jumpTable			; $4f0f
	.dw @substate0
	.dw @substate1

@substate0:
	; Go to substate 1
	ld a,$01		; $4f14
	ld (de),a		; $4f16

	ld hl,wcc50		; $4f17
	ld a,(hl)		; $4f1a
	ld (hl),$00		; $4f1b
	or a			; $4f1d
	ret nz			; $4f1e

	call linkCancelAllItemUsageAndClearAdjacentWallsBitset		; $4f1f
	ld a,LINK_ANIM_MODE_WALK		; $4f22
	jp specialObjectSetAnimation		; $4f24

@substate1:
	call _checkLinkForceState		; $4f27

	ld hl,wcc50		; $4f2a
	ld a,(hl)		; $4f2d
	or a			; $4f2e
	jr z,+			; $4f2f
	ld (hl),$00		; $4f31
	call specialObjectSetAnimation		; $4f33
+
	ld a,(wcc63)		; $4f36
	or a			; $4f39
	call nz,checkUseItems		; $4f3a

	ld a,(wDisabledObjects)		; $4f3d
	or a			; $4f40
	ret nz			; $4f41

	jp _initLinkStateAndAnimateStanding		; $4f42

;;
; @addr{4f45}
linkCancelAllItemUsageAndClearAdjacentWallsBitset:
	ld e,SpecialObject.adjacentWallsBitset		; $4f45
	xor a			; $4f47
	ld (de),a		; $4f48
;;
; Drop any held items, cancels usage of sword, etc?
; @addr{4f49}
linkCancelAllItemUsage:
	call dropLinkHeldItem		; $4f49
	jp clearAllParentItems		; $4f4c

;;
; LINK_STATE_0e
; @addr{4f4f}
_linkState0e:
	ld e,SpecialObject.state2		; $4f4f
	ld a,(de)		; $4f51
	rst_jumpTable			; $4f52
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call itemIncState2		; $4f59
	ld e,SpecialObject.var37		; $4f5c
	ld a,(wActiveRoom)		; $4f5e
	ld (de),a		; $4f61

@substate1:
	call objectCheckWithinScreenBoundary		; $4f62
	ret c			; $4f65
	call itemIncState2		; $4f66
	call objectSetInvisible		; $4f69

@substate2:
	ld h,d			; $4f6c
	ld l,SpecialObject.var37		; $4f6d
	ld a,(wActiveRoom)		; $4f6f
	cp (hl)			; $4f72
	ret nz			; $4f73

	call objectCheckWithinScreenBoundary		; $4f74
	ret nc			; $4f77

	ld e,SpecialObject.state2		; $4f78
	ld a,$01		; $4f7a
	ld (de),a		; $4f7c
	jp objectSetVisiblec2		; $4f7d

;;
; LINK_STATE_TOSSED_BY_GUARDS
; @addr{4f80}
_linkState0f:
	ld a,(wTextIsActive)		; $4f80
	or a			; $4f83
	ret nz			; $4f84

	ld e,SpecialObject.state2		; $4f85
	ld a,(de)		; $4f87
	rst_jumpTable			; $4f88
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call itemIncState2		; $4f8f

	; [SpecialObject.counter1] = $14
	inc l			; $4f92
	ld (hl),$14		; $4f93

	ld l,SpecialObject.angle		; $4f95
	ld (hl),$10		; $4f97
	ld l,SpecialObject.yh		; $4f99
	ld (hl),$38		; $4f9b
	ld l,SpecialObject.xh		; $4f9d
	ld (hl),$50		; $4f9f
	ld l,SpecialObject.speed		; $4fa1
	ld (hl),SPEED_100		; $4fa3

	ld l,SpecialObject.speedZ		; $4fa5
	ld a,$80		; $4fa7
	ldi (hl),a		; $4fa9
	ld (hl),$fe		; $4faa

	ld a,LINK_ANIM_MODE_COLLAPSED		; $4fac
	call specialObjectSetAnimation		; $4fae

	jp objectSetVisiblec2		; $4fb1

@substate1:
	call objectApplySpeed		; $4fb4

	ld c,$20		; $4fb7
	call objectUpdateSpeedZAndBounce		; $4fb9
	ret nc ; Return if Link can still bounce

	jp itemIncState2		; $4fbd

@substate2:
	call itemDecCounter1		; $4fc0
	ret nz			; $4fc3
	jp _initLinkStateAndAnimateStanding		; $4fc4

;;
; LINK_STATE_FORCE_MOVEMENT
; @addr{4fc7}
_linkState0b:
	ld e,SpecialObject.state2		; $4fc7
	ld a,(de)		; $4fc9
	rst_jumpTable			; $4fca
	.dw @substate0
	.dw @substate1

@substate0:
	ld a,$01		; $4fcf
	ld (de),a		; $4fd1

	ld e,SpecialObject.counter1		; $4fd2
	ld a,(wLinkStateParameter)		; $4fd4
	ld (de),a		; $4fd7

	call clearPegasusSeedCounter		; $4fd8
	call linkCancelAllItemUsageAndClearAdjacentWallsBitset		; $4fdb
	call updateLinkSpeed_standard		; $4fde

	ld a,LINK_ANIM_MODE_WALK		; $4fe1
	call specialObjectSetAnimation		; $4fe3

@substate1:
	call specialObjectAnimate		; $4fe6
	call itemDecCounter1		; $4fe9
	ld l,SpecialObject.adjacentWallsBitset		; $4fec
	ld (hl),$00		; $4fee
	jp nz,specialObjectUpdatePosition		; $4ff0

	; When counter1 reaches 0, go back to LINK_STATE_NORMAL.
	jp _initLinkStateAndAnimateStanding		; $4ff3


;;
; LINK_STATE_04
; @addr{4ff6}
_linkState04:
	ld e,SpecialObject.state2		; $4ff6
	ld a,(de)		; $4ff8
	rst_jumpTable			; $4ff9
	.dw @substate0
	.dw @substate1

@substate0:
	; Go to substate 1
	ld a,$01		; $4ffe
	ld (de),a		; $5000

	call linkCancelAllItemUsage		; $5001

	ld e,SpecialObject.animMode		; $5004
	ld a,(de)		; $5006
	ld ($cc52),a		; $5007

	ld a,(wcc50)		; $500a
	and $0f			; $500d
	add $0e			; $500f
	jp specialObjectSetAnimation		; $5011

@substate1:
	call retIfTextIsActive		; $5014
	ld a,(wcc50)		; $5017
	rlca			; $501a
	jr c,+			; $501b

	ld a,(wDisabledObjects)		; $501d
	and $81			; $5020
	ret nz			; $5022
+
	ld e,SpecialObject.state		; $5023
	ld a,LINK_STATE_NORMAL		; $5025
	ld (de),a		; $5027
	ld a,($cc52)		; $5028
	jp specialObjectSetAnimation		; $502b

;;
; @addr{502e}
setLinkStateToDead:
	ld a,LINK_STATE_DYING		; $502e
	call linkSetState		; $5030
;;
; LINK_STATE_DYING
; @addr{5033}
_linkState03:
	xor a			; $5033
	ld (wLinkHealth),a		; $5034
	ld e,SpecialObject.state2		; $5037
	ld a,(de)		; $5039
	rst_jumpTable			; $503a
	.dw @substate0
	.dw @substate1

; Link just started dying (initialization)
@substate0:
	call _specialObjectUpdateAdjacentWallsBitset		; $503f

	ld e,SpecialObject.knockbackCounter		; $5042
	ld a,(de)		; $5044
	or a			; $5045
	jp nz,_linkUpdateKnockback		; $5046

	ld h,d			; $5049
	ld l,SpecialObject.state2		; $504a
	inc (hl)		; $504c

	ld l,SpecialObject.counter1		; $504d
	ld (hl),$04		; $504f

	call linkCancelAllItemUsage		; $5051

	ld a,LINK_ANIM_MODE_SPIN		; $5054
	call specialObjectSetAnimation		; $5056
	ld a,SND_LINK_DEAD		; $5059
	jp playSound		; $505b

; Link is in the process of dying (spinning around)
@substate1:
	call resetLinkInvincibility		; $505e
	call specialObjectAnimate		; $5061

	ld h,d			; $5064
	ld l,SpecialObject.animParameter		; $5065
	ld a,(hl)		; $5067
	add a			; $5068
	jr nz,@triggerGameOver		; $5069
	ret nc			; $506b

; When animParameter is $80 or above, change link's animation to "unconscious"
	ld l,SpecialObject.counter1		; $506c
	dec (hl)		; $506e
	ret nz			; $506f
	ld a,LINK_ANIM_MODE_COLLAPSED		; $5070
	jp specialObjectSetAnimation		; $5072

@triggerGameOver:
	ld a,$ff		; $5075
	ld (wGameOverScreenTrigger),a		; $5077
	ret			; $507a

;;
; LINK_STATE_RESPAWNING
;
; This state behaves differently depending on wLinkStateParameter:
;  0: Fall down a hole
;  1: Fall down a hole without centering Link on the tile
;  2: Respawn instantly
;  3: Fall down a hole, different behaviour?
;  4: Drown
; @addr{507b}
_linkState02:
	ld a,$ff		; $507b
	ld (wGameKeysPressed),a		; $507d

	; Disable the push animation
	ld a,$80		; $5080
	ld (wForceLinkPushAnimation),a		; $5082

	ld e,SpecialObject.state2		; $5085
	ld a,(de)		; $5087
	rst_jumpTable			; $5088
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

; Initialization
@substate0:
	call linkCancelAllItemUsage		; $5095

	ld a,(wLinkStateParameter)		; $5098
	rst_jumpTable			; $509b
	.dw @parameter_fallDownHole
	.dw @parameter_fallDownHoleWithoutCentering
	.dw @respawn
	.dw @parameter_3
	.dw @parameter_drown

@parameter_drown:
	ld e,SpecialObject.state2		; $50a6
	ld a,$05		; $50a8
	ld (de),a		; $50aa
	ld a,LINK_ANIM_MODE_DROWN		; $50ab
	jp specialObjectSetAnimation		; $50ad

@parameter_fallDownHole:
	call objectCenterOnTile		; $50b0

@parameter_fallDownHoleWithoutCentering:
	call itemIncState2		; $50b3
	jr ++			; $50b6

@parameter_3:
	ld e,SpecialObject.state2		; $50b8
	ld a,$04		; $50ba
	ld (de),a		; $50bc
++
	; Disable collisions
	ld h,d			; $50bd
	ld l,SpecialObject.collisionType		; $50be
	res 7,(hl)		; $50c0

	; Do the "fall in hole" animation
	ld a,LINK_ANIM_MODE_FALLINHOLE		; $50c2
	call specialObjectSetAnimation		; $50c4
	ld a,SND_LINK_FALL		; $50c7
	jp playSound		; $50c9


; Doing a "falling down hole" animation, waiting for it to finish
@substate1:
	; Wait for the animation to finish
	ld h,d			; $50cc
	ld l,SpecialObject.animParameter		; $50cd
	bit 7,(hl)		; $50cf
	jp z,specialObjectAnimate		; $50d1

	ld a,(wActiveTileType)		; $50d4
	cp TILETYPE_WARPHOLE			; $50d7
	jr nz,@respawn		; $50d9

.ifdef ROM_AGES
	; Check if the current room is the moblin keep with the crumbling floors
	ld a,(wActiveGroup)		; $50db
	cp $02			; $50de
	jr nz,+			; $50e0
	ld a,(wActiveRoom)		; $50e2
	cp $9f			; $50e5
	jr nz,+			; $50e7

	jpab bank1.warpToMoblinKeepUnderground		; $50e9
+
.endif
	; This function call will only work in dungeons.
	jpab bank1.initiateFallDownHoleWarp		; $50f1

@respawn:
	call specialObjectSetCoordinatesToRespawnYX		; $50f9
	ld l,SpecialObject.state2		; $50fc
	ld a,$02		; $50fe
	ldi (hl),a		; $5100

	; [SpecialObject.counter1] = $02
	ld (hl),a		; $5101

	call specialObjectTryToBreakTile_source05		; $5102

	; Set wEnteredWarpPosition, which prevents Link from instantly activating a warp
	; tile if he respawns on one.
	call objectGetTileAtPosition		; $5105
	ld a,l			; $5108
	ld (wEnteredWarpPosition),a		; $5109

	jp objectSetInvisible		; $510c


; Waiting for counter1 to reach 0 before having Link reappear.
@substate2:
	ld h,d			; $510f
	ld l,SpecialObject.counter1		; $5110

	; Check if the screen is scrolling?
	ld a,(wScrollMode)		; $5112
	and $80			; $5115
	jr z,+			; $5117
	ld (hl),$04		; $5119
	ret			; $511b
+
	dec (hl)		; $511c
	ret nz			; $511d

	; Counter has reached 0; make Link reappear, apply damage

	xor a			; $511e
	ld (wLinkInAir),a		; $511f
	ld (wLinkSwimmingState),a		; $5122

	ld a,GOLD_LUCK_RING		; $5125
	call cpActiveRing		; $5127
	ld a,$fc		; $512a
	jr nz,+			; $512c
	sra a			; $512e
+
	call itemIncState2		; $5130

	ld l,SpecialObject.damageToApply		; $5133
	ld (hl),a		; $5135
	ld l,SpecialObject.invincibilityCounter		; $5136
	ld (hl),$3c		; $5138

	ld l,SpecialObject.counter1		; $513a
	ld (hl),$10		; $513c

	call linkApplyDamage		; $513e
	call objectSetVisiblec1		; $5141
	call _specialObjectUpdateAdjacentWallsBitset		; $5144
	jp _animateLinkStanding		; $5147


; Waiting for counter1 to reach 0 before switching back to LINK_STATE_NORMAL.
@substate3:
	call itemDecCounter1		; $514a
	ret nz			; $514d

	; Enable collisions
	ld l,SpecialObject.collisionType		; $514e
	set 7,(hl)		; $5150

	jp _initLinkStateAndAnimateStanding		; $5152


@substate4:
	ld h,d			; $5155
	ld l,SpecialObject.animParameter		; $5156
	bit 7,(hl)		; $5158
	jp z,specialObjectAnimate		; $515a
	call objectSetInvisible		; $515d
	jp _checkLinkForceState		; $5160


; Drowning instead of falling into a hole
@substate5:
	ld e,SpecialObject.animParameter		; $5163
	ld a,(de)		; $5165
	rlca			; $5166
	jp nc,specialObjectAnimate		; $5167
	jr @respawn		; $516a

;;
; Makes Link surface from an underwater area if he's pressed B.
; @addr{516c}
_checkForUnderwaterTransition:
	ld a,(wDisableScreenTransitions)		; $516c
	or a			; $516f
	ret nz			; $5170
	ld a,(wTilesetFlags)		; $5171
	and TILESETFLAG_UNDERWATER			; $5174
	ret z			; $5176
	ld a,(wGameKeysJustPressed)		; $5177
	and BTN_B			; $517a
	ret z			; $517c

	ld a,(wActiveTilePos)		; $517d
	ld l,a			; $5180
	ld h,>wRoomLayout		; $5181
	ld a,(hl)		; $5183
	ld hl,tileTypesTable		; $5184
	call lookupCollisionTable		; $5187

	; Don't allow surfacing on whirlpools
	cp TILETYPE_WHIRLPOOL			; $518a
	ret z			; $518c

	; Move down instead of up when over a "warp hole" (only used in jabu-jabu?)
	cp TILETYPE_WARPHOLE			; $518d
	jr z,@levelDown		; $518f

	; Return if Link can't surface here
	call checkLinkCanSurface		; $5191
	ret nc			; $5194

	; Return from the caller (_linkState01)
	pop af			; $5195

	ld a,(wTilesetFlags)		; $5196
	and TILESETFLAG_DUNGEON			; $5199
	jr nz,@dungeon		; $519b

	; Not in a dungeon

	; Set 'c' to the value to add to wActiveGroup.
	; Set 'a' to the room index to end up in.
	ld c,$fe		; $519d
	ld a,(wActiveRoom)		; $519f
	jr @initializeWarp		; $51a2

@dungeon:
	; Increment the floor you're on, get the new room index
	ld a,(wDungeonFloor)		; $51a4
	inc a			; $51a7
	ld (wDungeonFloor),a		; $51a8
	call getActiveRoomFromDungeonMapPosition		; $51ab
	ld c,$00		; $51ae
	jr @initializeWarp		; $51b0

	; Go down a level instead of up one
@levelDown:
	; Return from caller
	pop af			; $51b2

	ld a,(wTilesetFlags)		; $51b3
	and TILESETFLAG_DUNGEON			; $51b6
	jr nz,+			; $51b8

	; Not in a dungeon: add 2 to wActiveGroup.
	ld c,$02		; $51ba
	ld a,(wActiveRoom)		; $51bc
	jr @initializeWarp		; $51bf
+
	; In a dungeon: decrement the floor you're on, get the new room index
	ld a,(wDungeonFloor)		; $51c1
	dec a			; $51c4
	ld (wDungeonFloor),a		; $51c5
	call getActiveRoomFromDungeonMapPosition		; $51c8
	ld c,$00		; $51cb
	jr @initializeWarp		; $51cd

@initializeWarp:
	ld (wWarpDestRoom),a		; $51cf

	ld a,(wActiveGroup)		; $51d2
	add c			; $51d5
	or $80			; $51d6
	ld (wWarpDestGroup),a		; $51d8

	ld a,(wActiveTilePos)		; $51db
	ld (wWarpDestPos),a		; $51de

	ld a,$00		; $51e1
	ld (wWarpTransition),a		; $51e3

	ld a,$03		; $51e6
	ld (wWarpTransition2),a		; $51e8
	ret			; $51eb

;;
; LINK_STATE_GRABBED_BY_WALLMASTER
; @addr{51ec}
_linkState0c:
	ld e,SpecialObject.state2		; $51ec
	ld a,(de)		; $51ee
	rst_jumpTable			; $51ef
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	; Go to substate 1
	ld a,$01		; $51f6
	ld (de),a		; $51f8

	ld (wWarpsDisabled),a		; $51f9

	xor a			; $51fc
	ld e,SpecialObject.collisionType		; $51fd
	ld (de),a		; $51ff

	ld a,$00		; $5200
	ld (wScrollMode),a		; $5202

	call linkCancelAllItemUsage		; $5205

	ld a,SND_BOSS_DEAD		; $5208
	jp playSound		; $520a


; The wallmaster writes [w1Link.state2] = 2 when Link is fully dragged off-screen.
@substate2:
	xor a			; $520d
	ld (wWarpsDisabled),a		; $520e

	ld hl,wWarpDestGroup		; $5211
	ld a,(wActiveGroup)		; $5214
	or $80			; $5217
	ldi (hl),a		; $5219

	; wWarpDestRoom
	ld a,(wDungeonWallmasterDestRoom)		; $521a
	ldi (hl),a		; $521d

	; wWarpDestTransition
	ld a,TRANSITION_DEST_FALL		; $521e
	ldi (hl),a		; $5220

	; wWarpDestPos
	ld a,$87		; $5221
	ldi (hl),a		; $5223

	; wWarpDestTransition2
	ld (hl),$03		; $5224

; Substate 1: waiting for the wallmaster to increment w1Link.state2.
@substate1:
	ret			; $5226

;;
; LINK_STATE_STONE
; Only used in Seasons for the Medusa boss
; @addr{5227}
_linkState13:
	ld a,$80		; $5227
	ld (wForceLinkPushAnimation),a		; $5229

	ld e,SpecialObject.state2		; $522c
	ld a,(de)		; $522e
	rst_jumpTable			; $522f
	.dw @substate0
	.dw @substate1

@substate0:
	call itemIncState2		; $5234

	; [SpecialObject.counter1] = $b4
	inc l			; $5237
	ld (hl),$b4		; $5238

	ld l,SpecialObject.oamFlagsBackup		; $523a
	ld a,$0f		; $523c
	ldi (hl),a		; $523e
	ld (hl),a		; $523f

	ld a,PALH_7f		; $5240
	call loadPaletteHeader		; $5242

	xor a			; $5245
	ld (wcc50),a		; $5246
	ret			; $5249


; This is used by both _linkState13 and _linkState14.
; Waits for counter1 to reach 0, then restores Link to normal.
@substate1:
	ld c,$40		; $524a
	call objectUpdateSpeedZ_paramC		; $524c
	ld a,(wcc50)		; $524f
	or a			; $5252
	jr z,+			; $5253

	call updateLinkDirectionFromAngle		; $5255

	ld l,SpecialObject.var2a		; $5258
	ld a,(hl)		; $525a
	or a			; $525b
	jr nz,@restoreToNormal		; $525c
+
	; Restore Link to normal more quickly when pressing any button.
	ld c,$01		; $525e
	ld a,(wGameKeysJustPressed)		; $5260
	or a			; $5263
	jr z,+			; $5264
	ld c,$04		; $5266
+
	ld l,SpecialObject.counter1		; $5268
	ld a,(hl)		; $526a
	sub c			; $526b
	ld (hl),a		; $526c
	ret nc			; $526d

@restoreToNormal:
	ld l,SpecialObject.oamFlagsBackup		; $526e
	ld a,$08		; $5270
	ldi (hl),a		; $5272
	ld (hl),a		; $5273

	ld l,SpecialObject.knockbackCounter		; $5274
	ld (hl),$00		; $5276

	xor a			; $5278
	ld (wLinkForceState),a		; $5279
	jp _initLinkStateAndAnimateStanding		; $527c

;;
; LINK_STATE_COLLAPSED
; @addr{527f}
_linkState14:
	ld e,SpecialObject.state2		; $527f
	ld a,(de)		; $5281
	rst_jumpTable			; $5282
	.dw @substate0
	.dw _linkState13@substate1

@substate0:
	call itemIncState2		; $5287

	ld l,SpecialObject.counter1		; $528a
	ld (hl),$f0		; $528c
	call linkCancelAllItemUsage		; $528e

	ld a,(wcc50)		; $5291
	or a			; $5294
	ld a,LINK_ANIM_MODE_COLLAPSED		; $5295
	jr z,+			; $5297
	ld a,LINK_ANIM_MODE_WALK		; $5299
+
	jp specialObjectSetAnimation		; $529b

;;
; LINK_STATE_GRABBED
; Grabbed by Like-like, Gohma, Veran spider form?
; @addr{529e}
_linkState0d:
	ld a,$80		; $529e
	ld (wcc92),a		; $52a0
	ld e,SpecialObject.state2		; $52a3
	ld a,(de)		; $52a5
	rst_jumpTable			; $52a6
	.dw @substate0
	.dw updateLinkDamageTaken
	.dw @substate2
	.dw @substate3
	.dw @substate4

; Initialization
@substate0:
	ld a,$01		; $52b1
	ld (de),a		; $52b3
	ld (wWarpsDisabled),a		; $52b4

	ld e,SpecialObject.animMode		; $52b7
	xor a			; $52b9
	ld (de),a		; $52ba

	jp linkCancelAllItemUsage		; $52bb

; Link has been released, now he's about to fly downwards
@substate2:
	ld a,$03		; $52be
	ld (de),a		; $52c0

	ld h,d			; $52c1
	ld l,SpecialObject.counter1		; $52c2
	ld (hl),$1e		; $52c4

	ld l,SpecialObject.speedZ		; $52c6
	ld a,$20		; $52c8
	ldi (hl),a		; $52ca
	ld (hl),$fe		; $52cb

	; Face up
	ld l,SpecialObject.direction		; $52cd
	xor a			; $52cf
	ldi (hl),a		; $52d0

	; [SpecialObject.angle] = $10 (move down)
	ld (hl),$10		; $52d1

	ld l,SpecialObject.speed		; $52d3
	ld (hl),SPEED_180		; $52d5
	ld a,LINK_ANIM_MODE_GALE		; $52d7
	jp specialObjectSetAnimation		; $52d9

; Continue moving downwards until counter1 reaches 0
@substate3:
	call itemDecCounter1		; $52dc
	jr z,++			; $52df

	ld c,$20		; $52e1
	call objectUpdateSpeedZ_paramC		; $52e3
	call _specialObjectUpdateAdjacentWallsBitset		; $52e6
	call specialObjectUpdatePosition		; $52e9
	jp specialObjectAnimate		; $52ec


; Link is released without anything special.
; ENEMYID_LIKE_LIKE sends Link to this state directly upon release.
@substate4:
	ld h,d			; $52ef
	ld l,SpecialObject.invincibilityCounter		; $52f0
	ld (hl),$94		; $52f2
++
	xor a			; $52f4
	ld (wWarpsDisabled),a		; $52f5
	jp _initLinkStateAndAnimateStanding		; $52f8

;;
; LINK_STATE_SLEEPING
; @addr{52fb}
_linkState05:
	ld e,SpecialObject.state2		; $52fb
	ld a,(de)		; $52fd
	rst_jumpTable			; $52fe
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Just touched the bed
@substate0:
	call itemIncState2		; $5305

	ld l,SpecialObject.speed		; $5308
	ld (hl),SPEED_80		; $530a

	; Set destination position (var37 / var38)
	ld l,$18		; $530c
	ld a,$02		; $530e
	call _specialObjectSetVar37AndVar38		; $5310

	ld bc,-$180		; $5313
	call objectSetSpeedZ		; $5316

	ld a,$81		; $5319
	ld (wLinkInAir),a		; $531b

	ld a,LINK_ANIM_MODE_SLEEPING		; $531e
	jp specialObjectSetAnimation		; $5320

; Jumping into the bed
@substate1:
	call specialObjectAnimate		; $5323
	call _specialObjectSetAngleRelativeToVar38		; $5326
	call objectApplySpeed		; $5329

	ld c,$20		; $532c
	call objectUpdateSpeedZ_paramC		; $532e
	ret nz			; $5331

	call itemIncState2		; $5332
	jp _specialObjectSetPositionToVar38IfSet		; $5335

; Sleeping; do various things depending on "animParameter".
@substate2:
	call specialObjectAnimate		; $5338
	ld h,d			; $533b
	ld l,SpecialObject.animParameter		; $533c
	ld a,(hl)		; $533e
	ld (hl),$00		; $533f
	rst_jumpTable			; $5341
	.dw @animParameter0
	.dw @animParameter1
	.dw @animParameter2
	.dw @animParameter3
	.dw @animParameter4

@animParameter1:
	call darkenRoomLightly		; $534c
	ld a,$06		; $534f
	ld (wPaletteThread_updateRate),a		; $5351
	ret			; $5354

@animParameter2:
	ld hl,wLinkMaxHealth		; $5355
	ldd a,(hl)		; $5358
	ld (hl),a		; $5359

@animParameter0:
	ret			; $535a

@animParameter3:
	jp brightenRoom		; $535b

@animParameter4:
	ld bc,-$180		; $535e
	call objectSetSpeedZ		; $5361

	ld l,SpecialObject.direction		; $5364
	ld (hl),DIR_LEFT		; $5366

	; [SpecialObject.angle] = $18
	inc l			; $5368
	ld (hl),$18		; $5369

	ld l,SpecialObject.speed		; $536b
	ld (hl),SPEED_80		; $536d

	ld a,$81		; $536f
	ld (wLinkInAir),a		; $5371
	jp _initLinkStateAndAnimateStanding		; $5374

;;
; LINK_STATE_06
; Moves Link up until he's no longer in a solid wall?
; @addr{5377}
_linkState06:
	ld e,SpecialObject.state2		; $5377
	ld a,(de)		; $5379
	rst_jumpTable			; $537a
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	; Go to substate 1
	ld a,$01		; $5383
	ld (de),a		; $5385

	ld h,d			; $5386
	ld l,SpecialObject.counter1		; $5387
	ld (hl),$08		; $5389
	ld l,SpecialObject.speed		; $538b
	ld (hl),SPEED_200		; $538d

	; Set angle to "up"
	ld l,SpecialObject.angle		; $538f
	ld (hl),$00		; $5391

	ld a,$81		; $5393
	ld (wLinkInAir),a		; $5395
	ld a,SND_JUMP		; $5398
	call playSound		; $539a

@substate1:
	call specialObjectUpdatePositionWithoutTileEdgeAdjust		; $539d
	call itemDecCounter1		; $53a0
	ret nz			; $53a3

	; Go to substate 2
	ld l,SpecialObject.state2		; $53a4
	inc (hl)		; $53a6

	ld l,SpecialObject.direction		; $53a7
	ld (hl),$00		; $53a9
	ld a,LINK_ANIM_MODE_FALL		; $53ab
	call specialObjectSetAnimation		; $53ad

@substate2:
	call specialObjectAnimate		; $53b0
	ld a,(wScrollMode)		; $53b3
	and $01			; $53b6
	ret z			; $53b8

	call objectCheckTileCollision_allowHoles		; $53b9
	jp c,specialObjectUpdatePositionWithoutTileEdgeAdjust		; $53bc

	ld bc,-$200		; $53bf
	call objectSetSpeedZ		; $53c2

	; Go to substate 3
	ld l,SpecialObject.state2		; $53c5
	inc (hl)		; $53c7

	ld l,SpecialObject.speed		; $53c8
	ld (hl),SPEED_40		; $53ca
	ld a,LINK_ANIM_MODE_JUMP		; $53cc
	call specialObjectSetAnimation		; $53ce

@substate3:
	call specialObjectAnimate		; $53d1
	call _specialObjectUpdateAdjacentWallsBitset		; $53d4
	call specialObjectUpdatePosition		; $53d7
	ld c,$18		; $53da
	call objectUpdateSpeedZ_paramC		; $53dc
	ret nz			; $53df

	xor a			; $53e0
	ld (wLinkInAir),a		; $53e1
	ld (wWarpsDisabled),a		; $53e4
	jp _initLinkStateAndAnimateStanding		; $53e7

;;
; LINK_STATE_AMBI_POSSESSED_CUTSCENE
; This state is used during the cutscene in the black tower where Ambi gets un-possessed.
; @addr{53ea}
_linkState09:
	ld e,SpecialObject.state2		; $53ea
	ld a,(de)		; $53ec
	rst_jumpTable			; $53ed
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5


; Initialization
@substate0:
	call itemIncState2		; $53fa

; Backing up to the right

	ld l,SpecialObject.speed		; $53fd
	ld (hl),SPEED_100		; $53ff
	ld l,SpecialObject.direction		; $5401
	ld (hl),DIR_LEFT		; $5403

	; [SpecialObject.angle] = $08
	inc l			; $5405
	ld (hl),$08		; $5406

	ld l,SpecialObject.counter1		; $5408
	ld (hl),$0c		; $540a

@substate1:
	call itemDecCounter1		; $540c
	jr nz,@animate	; $540f

; Moving back left

	ld (hl),$0c		; $5411

	; Go to substate 2
	ld l,e			; $5413
	inc (hl)		; $5414

	ld l,SpecialObject.angle		; $5415
	ld (hl),$18		; $5417

@substate2:
	call itemDecCounter1		; $5419
	jr nz,@animate	; $541c

; Looking down

	ld (hl),$32		; $541e

	; Go to substate 3
	ld l,e			; $5420
	inc (hl)		; $5421

	ld l,SpecialObject.direction		; $5422
	ld (hl),DIR_DOWN		; $5424

@substate3:
	call itemDecCounter1		; $5426
	ret nz			; $5429

; Looking up with an exclamation mark

	; Go to substate 4
	ld l,e			; $542a
	inc (hl)		; $542b

	ld l,SpecialObject.direction		; $542c
	ld (hl),DIR_UP		; $542e

	; [SpecialObject.angle] = $10
	inc l			; $5430
	ld (hl),$10		; $5431

	ld l,SpecialObject.counter1		; $5433
	ld a,$1e		; $5435
	ld (hl),a		; $5437

	ld bc,$f4f8		; $5438
	jp objectCreateExclamationMark		; $543b

@substate4:
	call itemDecCounter1		; $543e
	ret nz			; $5441

; Jumping away

	; Go to substate 5
	ld l,e			; $5442
	inc (hl)		; $5443

	ld bc,-$180		; $5444
	call objectSetSpeedZ		; $5447

	ld a,LINK_ANIM_MODE_JUMP		; $544a
	call specialObjectSetAnimation		; $544c
	ld a,SND_JUMP		; $544f
	jp playSound		; $5451

@substate5:
	ld c,$18		; $5454
	call objectUpdateSpeedZ_paramC		; $5456
	jr nz,@animate	; $5459

	; a is 0 at this point
	ld l,SpecialObject.state2		; $545b
	ldd (hl),a		; $545d
	ld (hl),SpecialObject.direction		; $545e
	ret			; $5460

@animate:
	call specialObjectAnimate		; $5461
	jp specialObjectUpdatePositionWithoutTileEdgeAdjust		; $5464

;;
; LINK_STATE_SQUISHED
; @addr{5467}
_linkState11:
	ld e,SpecialObject.state2		; $5467
	ld a,(de)		; $5469
	rst_jumpTable			; $546a
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01		; $5471
	ld (de),a		; $5473

	call linkCancelAllItemUsage		; $5474

	xor a			; $5477
	ld e,SpecialObject.collisionType		; $5478
	ld (de),a		; $547a

	ld a,SND_DAMAGE_ENEMY		; $547b
	call playSound		; $547d

	; Check whether to do the horizontal or vertical squish animation
	ld a,(wcc50)		; $5480
	and $7f			; $5483
	ld a,LINK_ANIM_MODE_SQUISHX		; $5485
	jr z,+			; $5487
	inc a			; $5489
+
	call specialObjectSetAnimation		; $548a

@substate1:
	call specialObjectAnimate		; $548d

	; Wait for the animation to finish
	ld e,SpecialObject.animParameter		; $5490
	ld a,(de)		; $5492
	inc a			; $5493
	ret nz			; $5494

	call itemIncState2		; $5495
	ld l,SpecialObject.counter1		; $5498
	ld (hl),$14		; $549a

@substate2:
	call specialObjectAnimate		; $549c

	; Invisible every other frame
	ld a,(wFrameCounter)		; $549f
	rrca			; $54a2
	jp c,objectSetInvisible		; $54a3

	call objectSetVisible		; $54a6
	call itemDecCounter1		; $54a9
	ret nz			; $54ac

	ld a,(wcc50)		; $54ad
	bit 7,a			; $54b0
	jr nz,+			; $54b2

	call respawnLink		; $54b4
	jr _checkLinkForceState		; $54b7
+
	ld a,LINK_STATE_DYING		; $54b9
	ld (wLinkForceState),a		; $54bb
	jr _checkLinkForceState		; $54be

;;
; Checks wLinkForceState, and sets Link's state to that value if it's nonzero.
; This also returns from the function that called it if his state changed.
; @addr{54c0}
_checkLinkForceState:
	ld hl,wLinkForceState		; $54c0
	ld a,(hl)		; $54c3
	or a			; $54c4
	ret z			; $54c5

	ld (hl),$00		; $54c6
	pop hl			; $54c8

;;
; Sets w1Link.state to the given value, and w1Link.state2 to $00.
; For some reason, this also runs the code for the state immediately if it's
; LINK_STATE_WARPING, LINK_STATE_GRABBED_BY_WALLMASTER, or LINK_STATE_GRABBED.
;
; @param	a	New value for w1Link.state
; @param	d	Link object
; @addr{54c9}
linkSetState:
	ld h,d			; $54c9
	ld l,SpecialObject.state		; $54ca
	ldi (hl),a		; $54cc
	ld (hl),$00		; $54cd
	cp LINK_STATE_WARPING			; $54cf
	jr z,+			; $54d1

	cp LINK_STATE_GRABBED_BY_WALLMASTER			; $54d3
	jr z,+			; $54d5

	cp LINK_STATE_GRABBED			; $54d7
	ret nz			; $54d9
+
	jp specialObjectCode_link		; $54da

;;
; LINK_STATE_NORMAL
; LINK_STATE_10
; @addr{54dd}
_linkState01:
_linkState10:
	; This should prevent Link from ever doing his pushing animation.
	; Under normal circumstances, this should be overwritten with $00 later, allowing
	; him to do his pushing animation when necessary.
	ld a,$80		; $54dd
	ld (wForceLinkPushAnimation),a		; $54df

	; For some reason, Link can't do anything while the palette is changing
	ld a,(wPaletteThread_mode)		; $54e2
	or a			; $54e5
	ret nz			; $54e6

	ld a,(wScrollMode)		; $54e7
	and $0e			; $54ea
	ret nz			; $54ec

	call updateLinkDamageTaken		; $54ed
	ld a,(wLinkDeathTrigger)		; $54f0
	or a			; $54f3
	jp nz,setLinkStateToDead		; $54f4

	; This will return if [wLinkForceState] != 0
	call _checkLinkForceState		; $54f7

	call retIfTextIsActive		; $54fa

	ld a,(wDisabledObjects)		; $54fd
	and $81			; $5500
	ret nz			; $5502

	call decPegasusSeedCounter		; $5503

	ld a,(w1Companion.id)		; $5506
	cp SPECIALOBJECTID_MINECART			; $5509
	jr z,++			; $550b
	cp SPECIALOBJECTID_RAFT			; $550d
	jr z,++			; $550f

	; Return if Link is riding an animal?
	ld a,(wLinkObjectIndex)		; $5511
	rrca			; $5514
	ret c			; $5515

	ld a,(wLinkPlayingInstrument)		; $5516
	ld b,a			; $5519
	ld a,(wLinkInAir)		; $551a
	or b			; $551d
	jr nz,++		; $551e

	ld e,SpecialObject.knockbackCounter		; $5520
	ld a,(de)		; $5522
	or a			; $5523
	jr nz,++		; $5524

	; Return if Link interacts with an object
	call linkInteractWithAButtonSensitiveObjects		; $5526
	ret c			; $5529

	; Deal with push blocks, chests, signs, etc. and return if he opened a chest, read
	; a sign, or opened an overworld keyhole?
	call interactWithTileBeforeLink		; $552a
	ret c			; $552d
++
	xor a			; $552e
	ld (wForceLinkPushAnimation),a		; $552f
	ld (wLinkPlayingInstrument),a		; $5532

	ld a,(wTilesetFlags)		; $5535
	and TILESETFLAG_SIDESCROLL			; $5538
	jp nz,_linkState01_sidescroll		; $553a

	; The rest of this code is only run in non-sidescrolling areas.

	; Apply stuff like breakable floors, holes, conveyors, etc.
	call _linkApplyTileTypes		; $553d

	; Let Link move around if a chest spawned on top of him
	call checkAndUpdateLinkOnChest		; $5540

	; Check whether Link pressed A or B to use an item
	call checkUseItems		; $5543

	ld a,(wLinkPlayingInstrument)		; $5546
	or a			; $5549
	ret nz			; $554a

	call _specialObjectUpdateAdjacentWallsBitset		; $554b
	call _linkUpdateKnockback		; $554e

	; Jump if drowning
	ld a,(wLinkSwimmingState)		; $5551
	and $40			; $5554
	jr nz,++		; $5556

	ld a,(wMagnetGloveState)		; $5558
	bit 6,a			; $555b
	jr nz,++		; $555d

	ld a,(wLinkInAir)		; $555f
	or a			; $5562
	jr nz,++		; $5563

	ld a,(wLinkGrabState)		; $5565
	ld c,a			; $5568
	ld a,(wLinkImmobilized)		; $5569
	or c			; $556c
	jr nz,++		; $556d

	call checkLinkPushingAgainstBed		; $556f
	call _checkLinkJumpingOffCliff		; $5572
++
	call _linkUpdateInAir		; $5575
	ld a,(wLinkInAir)		; $5578
	or a			; $557b
	jr z,@notInAir			; $557c

	; Link is in the air, either jumping or going down a ledge.

	bit 7,a			; $557e
	jr nz,+			; $5580

	ld e,SpecialObject.speedZ+1		; $5582
	ld a,(de)		; $5584
	bit 7,a			; $5585
	call z,_linkUpdateVelocity		; $5587
+
	ld hl,wcc95		; $558a
	res 4,(hl)		; $558d
	call _specialObjectSetAngleRelativeToVar38		; $558f
	call specialObjectUpdatePosition		; $5592
	jp specialObjectAnimate		; $5595

@notInAir:
	ld a,(wMagnetGloveState)		; $5598
	bit 6,a			; $559b
	jp nz,_animateLinkStanding		; $559d

	ld e,SpecialObject.knockbackCounter		; $55a0
	ld a,(de)		; $55a2
	or a			; $55a3
	jp nz,_func_5631		; $55a4

	ld h,d			; $55a7
	ld l,SpecialObject.collisionType		; $55a8
	set 7,(hl)		; $55aa

	ld a,(wLinkSwimmingState)		; $55ac
	or a			; $55af
	jp nz,_linkUpdateSwimming		; $55b0

	call objectSetVisiblec1		; $55b3
	ld a,(wLinkObjectIndex)		; $55b6
	rrca			; $55b9
	jr nc,+			; $55ba


	; This is odd. The "jr z" line below will never jump since 'a' will never be 0.
	; A "cp" opcode instead of "or" would make a lot more sense. Is this a typo?
	; The only difference this makes is that, when on a raft, Link can change
	; directions while swinging his sword / using other items.

	ld a,(w1Companion.id)		; $55bc
	or SPECIALOBJECTID_RAFT			; $55bf
	jr z,@updateDirectionIfNotUsingItem	; $55c1
	jr @updateDirection		; $55c3
+
	; This will return if a transition occurs (pressed B in an underwater area).
	call _checkForUnderwaterTransition		; $55c5

	; Check whether Link is wearing a transformation ring or is a baby
	callab bank6.getTransformedLinkID		; $55c8
	ld a,b			; $55d0
	or a			; $55d1
	jp nz,setLinkIDOverride		; $55d2


	; Handle movement

	; Check if Link is underwater?
	ld h,d			; $55d5
	ld l,SpecialObject.var2f		; $55d6
	bit 7,(hl)		; $55d8
	jr z,+			; $55da

	; Do mermaid-suit-based movement
	call _linkUpdateVelocity@mermaidSuit		; $55dc
	jr ++			; $55df
+
	; Check if bits 0-3 of wLinkGrabState == 1 or 2.
	; (Link is grabbing or lifting something. This cancels ice physics.)
	ld a,(wLinkGrabState)		; $55e1
	and $0f			; $55e4
	dec a			; $55e6
	cp $02			; $55e7
	jr c,@normalMovement	; $55e9

	ld hl,wIsTileSlippery		; $55eb
	bit 6,(hl)		; $55ee
	jr z,@normalMovement	; $55f0

	; Slippery tile movement?
	ld c,$88		; $55f2
	call updateLinkSpeed_withParam		; $55f4
	call _linkUpdateVelocity		; $55f7
++
	ld a,(wLinkAngle)		; $55fa
	rlca			; $55fd
	ld c,$02		; $55fe
	jr c,@updateMovement	; $5600
	jr @walking		; $5602

@normalMovement:
	ld a,(wcc95)		; $5604
	ld b,a			; $5607

	ld e,SpecialObject.angle		; $5608
	ld a,(wLinkAngle)		; $560a
	ld (de),a		; $560d

	; Set cflag if in a spinner or wLinkAngle is set. (The latter case just means he
	; isn't moving.)
	or b			; $560e
	rlca			; $560f

	ld c,$00		; $5610
	jr c,@updateMovement	; $5612

	ld c,$01		; $5614
	ld a,(wLinkImmobilized)		; $5616
	or a			; $5619
	jr nz,@updateMovement	; $561a

	call updateLinkSpeed_standard		; $561c

@walking:
	ld c,$07		; $561f

@updateMovement:
	; The value of 'c' here determines whether Link should move, what his animation
	; should be, and whether the heart ring should apply. See the _linkUpdateMovement
	; function for details.
	call _linkUpdateMovement		; $5621

@updateDirectionIfNotUsingItem:
	ld a,(wLinkTurningDisabled)		; $5624
	or a			; $5627
	ret nz			; $5628

@updateDirection:
	jp updateLinkDirectionFromAngle		; $5629

;;
; @addr{562c}
linkResetSpeed:
	ld e,SpecialObject.speed		; $562c
	xor a			; $562e
	ld (de),a		; $562f
	ret			; $5630

;;
; Does something with Link's knockback when on a slippery tile?
; @addr{5631}
_func_5631:
	ld hl,wIsTileSlippery		; $5631
	bit 6,(hl)		; $5634
	ret z			; $5636
	ld e,SpecialObject.knockbackAngle		; $5637
	ld a,(de)		; $5639
	ld e,SpecialObject.angle		; $563a
	ld (de),a		; $563c
	ret			; $563d

;;
; Called once per frame that Link is moving.
;
; @param	a		Bits 0,1 set if Link's y,x offsets should be added to the
;				counter, respectively.
; @param	wTmpcec0	Offsets of Link's movement, to be added to wHeartRingCounter.
; @addr{563e}
_updateHeartRingCounter:
	ld e,a			; $563e
	ld a,(wActiveRing)		; $563f

	; b = number of steps (divided by $100, in pixels) until you get a heart refill.
	; c = number of quarter hearts to refill (times 4).

	ldbc $02,$08		; $5642
	cp HEART_RING_L1			; $5645
	jr z,@heartRingEquipped		; $5647

	cp HEART_RING_L2			; $5649
	jr nz,@clearCounter		; $564b
	ldbc $03,$10		; $564d

@heartRingEquipped:
	ld a,e			; $5650
	or c			; $5651
	ld c,a			; $5652
	push de			; $5653

	; Add Link's y position offset
	ld de,wTmpcec0+1		; $5654
	ld hl,wHeartRingCounter		; $5657
	srl c			; $565a
	call c,@addOffsetsToCounter		; $565c

	; Add Link's x position offset
	ld e,<wTmpcec0+3		; $565f
	ld l,<wHeartRingCounter		; $5661
	srl c			; $5663
	call c,@addOffsetsToCounter		; $5665

	; Check if the counter is high enough for a refill
	pop de			; $5668
	ld a,(wHeartRingCounter+2)		; $5669
	cp b			; $566c
	ret c			; $566d

	; Give hearts if health isn't full already
	ld hl,wLinkHealth		; $566e
	ldi a,(hl)		; $5671
	cp (hl)			; $5672
	ld a,TREASURE_HEART_REFILL		; $5673
	call c,giveTreasure		; $5675

@clearCounter:
	ld hl,wHeartRingCounter		; $5678
	xor a			; $567b
	ldi (hl),a		; $567c
	ldi (hl),a		; $567d
	ldi (hl),a		; $567e
	ret			; $567f

;;
; Adds the position offsets at 'de' to the counter at 'hl'.
; @addr{5680}
@addOffsetsToCounter:
	ld a,(de)		; $5680
	dec e			; $5681
	rlca			; $5682
	jr nc,+			; $5683

	; If moving in a negative direction, negate the offsets so they're positive again
	ld a,(de)		; $5685
	cpl			; $5686
	adc (hl)		; $5687
	ldi (hl),a		; $5688
	inc e			; $5689
	ld a,(de)		; $568a
	cpl			; $568b
	jr ++			; $568c
+
	ld a,(de)		; $568e
	add (hl)		; $568f
	ldi (hl),a		; $5690
	inc e			; $5691
	ld a,(de)		; $5692
++
	adc (hl)		; $5693
	ldi (hl),a		; $5694
	ret nc			; $5695
	inc (hl)		; $5696
	ret			; $5697

;;
; This is called from _linkState01 if [wLinkSwimmingState] != 0.
; Only for non-sidescrolling areas. (See also _linkUpdateSwimming_sidescroll.)
; @addr{5698}
_linkUpdateSwimming:
	ld a,(wLinkSwimmingState)		; $5698
	and $0f			; $569b

	ld hl,wcc95		; $569d
	res 4,(hl)		; $56a0

	rst_jumpTable			; $56a2
	.dw _initLinkState
	.dw _overworldSwimmingState1
	.dw _overworldSwimmingState2
	.dw _overworldSwimmingState3
	.dw _linkUpdateDrowning

;;
; Just entered the water
; @addr{56ad}
_overworldSwimmingState1:
	call linkCancelAllItemUsage		; $56ad
	call _linkSetSwimmingSpeed		; $56b0

	; Set counter1 to the number of frames to stay in swimmingState2.
	; This is just a period of time during which Link's speed is locked immediately
	; after entering the water.
	ld l,SpecialObject.var2f		; $56b3
	bit 6,(hl)		; $56b5
	ld l,SpecialObject.counter1		; $56b7
	ld (hl),$0a		; $56b9
	jr z,+			; $56bb
	ld (hl),$02		; $56bd
+
	ld a,(wLinkSwimmingState)		; $56bf
	bit 6,a			; $56c2
	jr nz,@drownWithLessInvincibility		; $56c4

	call _checkSwimmingOverSeawater		; $56c6
	jr z,@drown		; $56c9

	ld a,TREASURE_FLIPPERS		; $56cb
	call checkTreasureObtained		; $56cd
	ld b,LINK_ANIM_MODE_SWIM		; $56d0
	jr c,@splashAndSetAnimation	; $56d2

@drown:
	ld c,$88		; $56d4
	jr +			; $56d6

@drownWithLessInvincibility:
	ld c,$78		; $56d8
+
	ld a,LINK_STATE_RESPAWNING		; $56da
	ld (wLinkForceState),a		; $56dc
	ld a,$04		; $56df
	ld (wLinkStateParameter),a		; $56e1
	ld a,$80		; $56e4
	ld (wcc92),a		; $56e6

	ld h,d			; $56e9
	ld l,SpecialObject.invincibilityCounter		; $56ea
	ld (hl),c		; $56ec
	ld l,SpecialObject.collisionType		; $56ed
	res 7,(hl)		; $56ef

	ld a,SND_DAMAGE_LINK		; $56f1
	call playSound		; $56f3

	ld b,LINK_ANIM_MODE_DROWN		; $56f6

@splashAndSetAnimation:
	ld hl,wLinkSwimmingState		; $56f8
	ld a,(hl)		; $56fb
	and $f0			; $56fc
	or $02			; $56fe
	ld (hl),a		; $5700
	ld a,b			; $5701
	call specialObjectSetAnimation		; $5702
	jp linkCreateSplash		; $5705

;;
; This is called from _linkUpdateSwimming_sidescroll.
; @addr{5708}
_forceDrownLink:
	ld hl,wLinkSwimmingState		; $5708
	set 6,(hl)		; $570b
	jr _overworldSwimmingState1@drownWithLessInvincibility		; $570d

;;
; @param[out]	zflag	Set if swimming over seawater (and you have the mermaid suit)
; @addr{570f}
_checkSwimmingOverSeawater:
	ld a,(w1Link.var2f)		; $570f
	bit 6,a			; $5712
	ret nz			; $5714
	ld a,(wActiveTileType)		; $5715
	sub TILETYPE_SEAWATER			; $5718
	ret			; $571a

;;
; State 2: speed is locked for a few frames after entering the water
; @addr{571b}
_overworldSwimmingState2:
	call itemDecCounter1		; $571b
	jp nz,specialObjectUpdatePosition		; $571e

	ld hl,wLinkSwimmingState		; $5721
	inc (hl)		; $5724

;;
; State 3: the normal state when swimming
; @addr{5725}
_overworldSwimmingState3:
	call _checkSwimmingOverSeawater		; $5725
	jr z,_overworldSwimmingState1@drown		; $5728

	call _linkUpdateDiving		; $572a

	; Set Link's visibility layer to normal
	call objectSetVisiblec1		; $572d

	; Enable Link's collisions
	ld h,d			; $5730
	ld l,SpecialObject.collisionType		; $5731
	set 7,(hl)		; $5733

	; Check if Link is diving
	ld a,(wLinkSwimmingState)		; $5735
	rlca			; $5738
	jr nc,+			; $5739

	; If he's diving, disable Link's collisions
	res 7,(hl)		; $573b
	; Draw him behind other sprites
	call objectSetVisiblec3		; $573d
+
	call updateLinkDirectionFromAngle		; $5740

	; Check whether the flippers or the mermaid suit are in use
	ld h,d			; $5743
	ld l,SpecialObject.var2f		; $5744
	bit 6,(hl)		; $5746
	jr z,+			; $5748

	; Mermaid suit movement
	call _linkUpdateVelocity@mermaidSuit		; $574a
	jp specialObjectUpdatePosition		; $574d
+
	; Flippers movement
	call _linkUpdateFlippersSpeed		; $5750
	call _func_5933		; $5753
	jp specialObjectUpdatePosition		; $5756


;;
; Deals with Link drowning
; @addr{5759}
_linkUpdateDrowning:
	ld a,$80		; $5759
	ld (wcc92),a		; $575b

	call specialObjectAnimate		; $575e

	ld h,d			; $5761
	xor a			; $5762
	ld l,SpecialObject.collisionType		; $5763
	ld (hl),a		; $5765

	ld l,SpecialObject.animParameter		; $5766
	bit 7,(hl)		; $5768
	ret z			; $576a

	ld (wLinkSwimmingState),a		; $576b

	; Set link's state to LINK_STATE_RESPAWNING; but, set
	; wLinkStateParameter to $02 to trigger only the respawning code, and not
	; anything else.
	ld a,$02		; $576e
	ld (wLinkStateParameter),a		; $5770
	ld a,LINK_STATE_RESPAWNING		; $5773
	jp linkSetState		; $5775

;;
; Sets Link's speed, speedTmp, var12, and var35 variables.
; @addr{5778}
_linkSetSwimmingSpeed:
	ld a,SWIMMERS_RING		; $5778
	call cpActiveRing		; $577a
	ld a,SPEED_e0		; $577d
	jr z,+			; $577f
	ld a,SPEED_80		; $5781
+
	; Set speed, speedTmp to specified value
	ld h,d			; $5783
	ld l,SpecialObject.speed		; $5784
	ldi (hl),a		; $5786
	ldi (hl),a		; $5787

	; [SpecialObject.var12] = $03
	inc l			; $5788
	ld a,$03		; $5789
	ld (hl),a		; $578b

	ld l,SpecialObject.var35		; $578c
	ld (hl),$00		; $578e
	ret			; $5790

;;
; Sets the speedTmp variable in the same way as the above function, but doesn't touch any
; other variables.
; @addr{5791}
_linkSetSwimmingSpeedTmp:
	ld a,SWIMMERS_RING		; $5791
	call cpActiveRing		; $5793
	ld a,SPEED_e0		; $5796
	jr z,+			; $5798
	ld a,SPEED_80		; $579a
+
	ld e,SpecialObject.speedTmp		; $579c
	ld (de),a		; $579e
	ret			; $579f

;;
; @param[out]	a	The angle Link should move in?
; @addr{57a0}
_linkUpdateFlippersSpeed:
	ld e,SpecialObject.var35		; $57a0
	ld a,(de)		; $57a2
	rst_jumpTable			; $57a3
	.dw @flippersState0
	.dw @flippersState1
	.dw @flippersState2

; Swimming with flippers; waiting for Link to press A, if he will at all
@flippersState0:
	ld a,(wGameKeysJustPressed)		; $57aa
	and BTN_A			; $57ad
	jr nz,@pressedA			; $57af

	call _linkSetSwimmingSpeedTmp		; $57b1
	ld a,(wLinkAngle)		; $57b4
	ret			; $57b7

@pressedA:
	; Go to next state
	ld a,$01		; $57b8
	ld (de),a		; $57ba

	ld a,$08		; $57bb
--
	push af			; $57bd
	ld e,SpecialObject.direction		; $57be
	ld a,(de)		; $57c0
	add a			; $57c1
	add a			; $57c2
	add a			; $57c3
	call _func_5933		; $57c4
	pop af			; $57c7
	dec a			; $57c8
	jr nz,--		; $57c9

	ld e,SpecialObject.counter1		; $57cb
	ld a,$0d		; $57cd
	ld (de),a		; $57cf
	ld a,SND_LINK_SWIM		; $57d0
	call playSound		; $57d2


; Accerelating
@flippersState1:
	ldbc $01,$05		; $57d5
	jr ++			; $57d8


; Decelerating
@flippersState2:
	; b: Next state to go to (minus 1)
	; c: Value to add to speedTmp
	ldbc $ff,-5		; $57da
++
	call itemDecCounter1		; $57dd
	jr z,@nextState		; $57e0

	ld a,(hl)		; $57e2
	and $03			; $57e3
	jr z,@accelerate	; $57e5
	jr @returnDirection		; $57e7

@nextState:
	ld l,SpecialObject.var35		; $57e9
	inc b			; $57eb
	ld (hl),b		; $57ec
	jr nz,+			; $57ed

	call _linkSetSwimmingSpeed		; $57ef
	jr @returnDirection		; $57f2
+
	ld l,SpecialObject.counter1		; $57f4
	ld a,$0c		; $57f6
	ld (hl),a		; $57f8

	; Accelerate, or decelerate depending on 'c'.
@accelerate:
	ld l,SpecialObject.speedTmp		; $57f9
	ld a,(hl)		; $57fb
	add c			; $57fc
	bit 7,a			; $57fd
	jr z,+			; $57ff
	xor a			; $5801
+
	ld (hl),a		; $5802

	; Return an angle value based on Link's direction?
@returnDirection:
	ld a,(wLinkAngle)		; $5803
	bit 7,a			; $5806
	ret z			; $5808

	ld e,SpecialObject.direction		; $5809
	ld a,(de)		; $580b
	swap a			; $580c
	rrca			; $580e
	ret			; $580f

;;
; @addr{5810}
_linkUpdateDiving:
	call specialObjectAnimate		; $5810
	ld hl,wLinkSwimmingState		; $5813
	bit 7,(hl)		; $5816
	jr z,@checkInput			; $5818

	ld a,(wDisableScreenTransitions)		; $581a
	or a			; $581d
	jr nz,@checkInput		; $581e

	ld a,(wActiveTilePos)		; $5820
	ld c,a			; $5823
	ld b,>wRoomLayout		; $5824
	ld a,(bc)		; $5826
	cp TILEINDEX_DEEP_WATER			; $5827
	jp z,_checkForUnderwaterTransition@levelDown		; $5829

@checkInput:
	ld a,(wGameKeysJustPressed)		; $582c
	bit BTN_BIT_B,a			; $582f
	jr nz,@pressedB		; $5831

	ld a,ZORA_RING		; $5833
	call cpActiveRing		; $5835
	ret z			; $5838

	ld e,SpecialObject.counter2		; $5839
	ld a,(de)		; $583b
	dec a			; $583c
	ld (de),a		; $583d
	jr z,@surface		; $583e
	ret			; $5840

@pressedB:
	bit 7,(hl)		; $5841
	jr z,@dive		; $5843

@surface:
	res 7,(hl)		; $5845
	ld a,LINK_ANIM_MODE_SWIM		; $5847
	jp specialObjectSetAnimation		; $5849

@dive:
	set 7,(hl)		; $584c

	ld e,SpecialObject.counter2		; $584e
	ld a,$78		; $5850
	ld (de),a		; $5852

	call linkCreateSplash		; $5853
	ld a,LINK_ANIM_MODE_DIVE		; $5856
	jp specialObjectSetAnimation		; $5858

;;
; @addr{585b}
_linkUpdateSwimming_sidescroll:
	ld a,(wLinkSwimmingState)		; $585b
	and $0f			; $585e
	jr z,@swimmingState0	; $5860

	ld hl,wcc95		; $5862
	res 4,(hl)		; $5865

	rst_jumpTable			; $5867
	.dw @swimmingState0
	.dw @swimmingState1
	.dw @swimmingState2
	.dw _linkUpdateDrowning

; Not swimming
@swimmingState0:
	jp _initLinkState		; $5870


; Just entered the water
@swimmingState1:
	call linkCancelAllItemUsage		; $5873

	ld hl,wLinkSwimmingState		; $5876
	inc (hl)		; $5879

	call _linkSetSwimmingSpeed		; $587a
	call objectSetVisiblec1		; $587d

	ld a,TREASURE_FLIPPERS		; $5880
	call checkTreasureObtained		; $5882
	jr nc,@drown			; $5885

	ld hl,w1Link.var2f		; $5887
	bit 6,(hl)		; $588a
	ld a,LINK_ANIM_MODE_SWIM_2D		; $588c
	jr z,++			; $588e

	set 7,(hl)		; $5890
	ld a,LINK_ANIM_MODE_MERMAID		; $5892
	jr ++			; $5894

@drown:
	ld a,$03		; $5896
	ld (wLinkSwimmingState),a		; $5898
	ld a,LINK_ANIM_MODE_DROWN		; $589b
++
	jp specialObjectSetAnimation		; $589d


; Link remains in this state until he exits the water
@swimmingState2:
	xor a			; $58a0
	ld (wLinkInAir),a		; $58a1

	ld h,d			; $58a4
	ld l,SpecialObject.collisionType		; $58a5
	set 7,(hl)		; $58a7
	ld a,(wLinkImmobilized)		; $58a9
	or a			; $58ac
	jr nz,+++		; $58ad

	; Jump if Link isn't moving ([w1LinkAngle] == $ff)
	ld l,SpecialObject.direction		; $58af
	ld a,(wLinkAngle)		; $58b1
	add a			; $58b4
	jr c,+			; $58b5

	; Jump if Link's angle is going directly up or directly down (so, don't modify his
	; current facing direction)
	ld c,a			; $58b7
	and $18			; $58b8
	jr z,+			; $58ba

	; Set Link's facing direction based on his angle
	ld a,c			; $58bc
	swap a			; $58bd
	and $03			; $58bf
	ld (hl),a		; $58c1
+
	; Ensure that he's facing either left or right (not up or down)
	set 0,(hl)		; $58c2

	; Jump if Link does not have the mermaid suit (only flippers)
	ld l,SpecialObject.var2f		; $58c4
	bit 6,(hl)		; $58c6
	jr z,+			; $58c8

	; Mermaid suit movement
	call _linkUpdateVelocity@mermaidSuit		; $58ca
	jr ++			; $58cd
+
	; Flippers movement
	call _linkUpdateFlippersSpeed		; $58cf
	call _func_5933		; $58d2
++
	call specialObjectUpdatePosition		; $58d5
+++
	; When counter2 goes below 0, create a bubble
	ld h,d			; $58d8
	ld l,SpecialObject.counter2		; $58d9
	dec (hl)		; $58db
	bit 7,(hl)		; $58dc
	jr z,+			; $58de

	; Wait between 50-81 frames before creating the next bubble
	call getRandomNumber		; $58e0
	and $1f			; $58e3
	add 50			; $58e5
	ld (hl),a		; $58e7

	ld b,INTERACID_BUBBLE		; $58e8
	call objectCreateInteractionWithSubid00		; $58ea
+
	jp specialObjectAnimate		; $58ed

;;
; Updates speed and angle for things like ice, jumping, underwater? (Things where he
; accelerates and decelerates)
; @addr{58f0}
_linkUpdateVelocity:
	ld a,(wTilesetFlags)		; $58f0
	and TILESETFLAG_UNDERWATER			; $58f3
	jr z,@label_05_159	; $58f5

@mermaidSuit:
	ld c,$98		; $58f7
	call updateLinkSpeed_withParam		; $58f9
	ld a,(wActiveRing)		; $58fc
	cp SWIMMERS_RING			; $58ff
	jr nz,+			; $5901

	ld e,SpecialObject.speedTmp		; $5903
	ld a,SPEED_160		; $5905
	ld (de),a		; $5907
+
	ld h,d			; $5908
	ld a,(wLinkImmobilized)		; $5909
	or a			; $590c
	jr nz,+			; $590d

	ld a,(wGameKeysJustPressed)		; $590f
	and (BTN_UP | BTN_RIGHT | BTN_DOWN | BTN_LEFT)			; $5912
	jr nz,@directionButtonPressed	; $5914
+
	ld l,SpecialObject.var3e		; $5916
	dec (hl)		; $5918
	bit 7,(hl)		; $5919
	jr z,++			; $591b

	ld a,$ff		; $591d
	ld (hl),a		; $591f
	jr _func_5933			; $5920

@directionButtonPressed:
	ld a,SND_SPLASH		; $5922
	call playSound		; $5924
	ld h,d			; $5927
	ld l,SpecialObject.var3e		; $5928
	ld (hl),$04		; $592a
++
	ld l,SpecialObject.var12		; $592c
	ld (hl),$14		; $592e

@label_05_159:
	ld a,(wLinkAngle)		; $5930

;;
; @param a
; @addr{5933}
_func_5933:
	ld e,a			; $5933
	ld h,d			; $5934
	ld l,SpecialObject.angle		; $5935
	bit 7,(hl)		; $5937
	jr z,+			; $5939

	ld (hl),e		; $593b
	ret			; $593c
+
	bit 7,a			; $593d
	jr nz,@label_05_162	; $593f
	sub (hl)		; $5941
	add $04			; $5942
	and $1f			; $5944
	cp $09			; $5946
	jr c,@label_05_164	; $5948
	sub $10			; $594a
	cp $09			; $594c
	jr c,@label_05_163	; $594e
	ld bc,$0100		; $5950
	bit 7,a			; $5953
	jr nz,@label_05_165	; $5955
	ld b,$ff		; $5957
	jr @label_05_165		; $5959
@label_05_162:
	ld bc,$00fb		; $595b
	ld a,(wLinkInAir)		; $595e
	or a			; $5961
	jr z,@label_05_165	; $5962
	ld c,b			; $5964
	jr @label_05_165		; $5965
@label_05_163:
	ld bc,$01fb		; $5967
	cp $03			; $596a
	jr c,@label_05_165	; $596c
	ld b,$ff		; $596e
	cp $06			; $5970
	jr nc,@label_05_165	; $5972
	ld a,e			; $5974
	xor $10			; $5975
	ld (hl),a		; $5977
	ld b,$00		; $5978
	jr @label_05_165		; $597a
@label_05_164:
	ld bc,$ff05		; $597c
	cp $03			; $597f
	jr c,@label_05_165	; $5981
	ld b,$01		; $5983
	cp $06			; $5985
	jr nc,@label_05_165	; $5987
	ld a,e			; $5989
	ld (hl),a		; $598a
	ld b,$00		; $598b
@label_05_165:
	ld l,SpecialObject.var12		; $598d
	inc (hl)		; $598f
	ldi a,(hl)		; $5990
	cp (hl)			; $5991
	ret c			; $5992

	; Set SpecialObject.speedTmp to $00
	dec l			; $5993
	ld (hl),$00		; $5994

	ld l,SpecialObject.angle		; $5996
	ld a,(hl)		; $5998
	add b			; $5999
	and $1f			; $599a
	ld (hl),a		; $599c
	ld l,SpecialObject.speedTmp		; $599d
	ldd a,(hl)		; $599f
	ld b,a			; $59a0
	ld a,(hl)		; $59a1
	add c			; $59a2
	jr z,++			; $59a3
	bit 7,a			; $59a5
	jr nz,++		; $59a7

	cp b			; $59a9
	jr c,+			; $59aa
	ld a,b			; $59ac
+
	ld (hl),a		; $59ad
	ret			; $59ae
++
	ld l,SpecialObject.speed		; $59af
	xor a			; $59b1
	ldi (hl),a		; $59b2
	inc l			; $59b3
	ld (hl),l		; $59b4
	dec a			; $59b5
	ld l,SpecialObject.angle		; $59b6
	ld (hl),a		; $59b8
	ret			; $59b9

;;
; linkState01 code, only for sidescrolling areas.
; @addr{59ba}
_linkState01_sidescroll:
	call _sidescrollUpdateActiveTile		; $59ba
	ld a,(wActiveTileType)		; $59bd
	bit TILETYPE_SS_BIT_WATER,a			; $59c0
	jr z,@notInWater		; $59c2

	; In water

	ld h,d			; $59c4
	ld l,SpecialObject.var2f		; $59c5
	bit 6,(hl)		; $59c7
	jr z,+			; $59c9
	set 7,(hl)		; $59cb
+
	; If link was in water last frame, don't create a splash
	ld a,(wLinkSwimmingState)		; $59cd
	or a			; $59d0
	jr nz,++		; $59d1

	; Otherwise, he's just entering the water; create a splash
	inc a			; $59d3
	ld (wLinkSwimmingState),a		; $59d4
	call linkCreateSplash		; $59d7
	jr ++			; $59da

@notInWater:
	; Set WLinkSwimmingState to $00, and jump if he wasn't in water last frame
	ld hl,wLinkSwimmingState		; $59dc
	ld a,(hl)		; $59df
	ld (hl),$00		; $59e0
	or a			; $59e2
	jr z,++			; $59e3

	; He was in water last frame.

	; Skip the below code if he surfaced from an underwater ladder tile.
	ld a,(wLastActiveTileType)		; $59e5
	cp (TILETYPE_SS_LADDER | TILETYPE_SS_WATER)	; $59e8
	jr z,++			; $59ea

	; Make him "hop out" of the water.

	ld a,$02		; $59ec
	ld (wLinkInAir),a		; $59ee
	call linkCreateSplash		; $59f1

	ld bc,-$1a0		; $59f4
	call objectSetSpeedZ		; $59f7

	ld a,(wLinkAngle)		; $59fa
	ld l,SpecialObject.angle		; $59fd
	ld (hl),a		; $59ff

++
	call checkUseItems		; $5a00

	ld a,(wLinkPlayingInstrument)		; $5a03
	or a			; $5a06
	ret nz			; $5a07

	call _specialObjectUpdateAdjacentWallsBitset		; $5a08
	call _linkUpdateKnockback		; $5a0b

	ld a,(wLinkSwimmingState)		; $5a0e
	or a			; $5a11
	jp nz,_linkUpdateSwimming_sidescroll		; $5a12

	ld a,(wMagnetGloveState)		; $5a15
	bit 6,a			; $5a18
	jp z,+			; $5a1a

	xor a			; $5a1d
	ld (wLinkInAir),a		; $5a1e
	jp _animateLinkStanding		; $5a21
+
	call _linkUpdateInAir_sidescroll		; $5a24
	ret z			; $5a27

	ld e,SpecialObject.knockbackCounter		; $5a28
	ld a,(de)		; $5a2a
	or a			; $5a2b
	ret nz			; $5a2c

	ld a,(wActiveTileIndex)		; $5a2d
	cp TILEINDEX_SS_SPIKE			; $5a30
	call z,_dealSpikeDamageToLink		; $5a32

	ld a,(wForceIcePhysics)		; $5a35
	or a			; $5a38
	jr z,+			; $5a39

	ld e,SpecialObject.adjacentWallsBitset		; $5a3b
	ld a,(de)		; $5a3d
	and $30			; $5a3e
	jr nz,@onIce		; $5a40
+
	ld a,(wLastActiveTileType)		; $5a42
	cp TILETYPE_SS_ICE			; $5a45
	jr nz,@notOnIce		; $5a47

@onIce:
	ld a,SNOWSHOE_RING		; $5a49
	call cpActiveRing		; $5a4b
	jr z,@notOnIce		; $5a4e

	ld c,$88		; $5a50
	call updateLinkSpeed_withParam		; $5a52

	ld a,$06		; $5a55
	ld (wForceIcePhysics),a		; $5a57

	call _linkUpdateVelocity		; $5a5a

	ld c,$02		; $5a5d
	ld a,(wLinkAngle)		; $5a5f
	rlca			; $5a62
	jr c,++			; $5a63
	jr +			; $5a65

@notOnIce:
	xor a			; $5a67
	ld (wForceIcePhysics),a		; $5a68
	ld c,a			; $5a6b
	ld a,(wLinkAngle)		; $5a6c
	ld e,SpecialObject.angle		; $5a6f
	ld (de),a		; $5a71
	rlca			; $5a72
	jr c,++			; $5a73

	call updateLinkSpeed_standard		; $5a75

	; Parameter for _linkUpdateMovement (update his animation only; don't update his
	; position)
	ld c,$01		; $5a78

	ld a,(wLinkImmobilized)		; $5a7a
	or a			; $5a7d
	jr nz,++		; $5a7e
+
	; Parameter for _linkUpdateMovement (update everything, including his position)
	ld c,$07		; $5a80
++
	; When not in the water or in other tiles with particular effects, adjust Link's
	; angle so that he moves purely horizontally.
	ld hl,wActiveTileType		; $5a82
	ldi a,(hl)		; $5a85
	or (hl)			; $5a86
	and $ff~TILETYPE_SS_ICE			; $5a87
	call z,_linkAdjustAngleInSidescrollingArea		; $5a89

	call _linkUpdateMovement		; $5a8c

	; The following checks are for whether to cap Link's y position so he doesn't go
	; above a certain point.

	ld e,SpecialObject.angle		; $5a8f
	ld a,(de)		; $5a91
	add $04			; $5a92
	and $1f			; $5a94
	cp $09			; $5a96
	jr nc,++	; $5a98

	; Allow him to move up if the tile he's in has any special properties?
	ld hl,wActiveTileType		; $5a9a
	ldi a,(hl)		; $5a9d
	or a			; $5a9e
	jr nz,++	; $5a9f

	; Allow him to move up if the tile he's standing on is NOT the top of a ladder?
	ld a,(hl)		; $5aa1
	cp (TILETYPE_SS_LADDER | TILETYPE_SS_LADDER_TOP)	; $5aa2
	jr nz,++	; $5aa4

	; Check if Link's y position within the tile is lower than 9
	ld e,SpecialObject.yh		; $5aa6
	ld a,(de)		; $5aa8
	and $0f			; $5aa9
	cp $09			; $5aab
	jr nc,++	; $5aad

	; If it's lower than 9, set it back to 9
	ld a,(de)		; $5aaf
	and $f0			; $5ab0
	add $09			; $5ab2
	ld (de),a		; $5ab4

++
	; Don't climb a ladder if Link is touching the ground
	ld e,SpecialObject.adjacentWallsBitset		; $5ab5
	ld a,(de)		; $5ab7
	and $30			; $5ab8
	jr nz,+			; $5aba

	ld a,(wActiveTileType)		; $5abc
	bit TILETYPE_SS_BIT_LADDER,a			; $5abf
	jr z,+			; $5ac1

	; Climbing a ladder
	ld a,$01		; $5ac3
	ld (wLinkClimbingVine),a		; $5ac5
+
	ld a,(wLinkTurningDisabled)		; $5ac8
	or a			; $5acb
	ret nz			; $5acc
	jp updateLinkDirectionFromAngle		; $5acd

;;
; Updates Link's animation and position based on his current speed and angle variables,
; among other things.
; @param c Bit 0: Set if Link's animation should be "walking" instead of "standing".
;          Bit 1: Set if Link's position should be updated based on his speed and angle.
;          Bit 2: Set if the heart ring's regeneration should be applied (if he moves).
; @addr{5ad0}
_linkUpdateMovement:
	ld a,c			; $5ad0

	; Check whether to animate him "standing" or "walking"
	rrca			; $5ad1
	push af			; $5ad2
	jr c,+			; $5ad3
	call _animateLinkStanding		; $5ad5
	jr ++			; $5ad8
+
	call _animateLinkWalking		; $5ada
++
	pop af			; $5add

	; Check whether to update his position
	rrca			; $5ade
	jr nc,++		; $5adf

	push af			; $5ae1
	call specialObjectUpdatePosition		; $5ae2
	jr z,+			; $5ae5

	ld c,a			; $5ae7
	pop af			; $5ae8

	; Check whether to update the heart ring counter
	rrca			; $5ae9
	ret nc			; $5aea

	ld a,c			; $5aeb
	jp _updateHeartRingCounter		; $5aec
+
	pop af			; $5aef
++
	jp linkResetSpeed		; $5af0

;;
; Only for top-down sections. (See also _linkUpdateInAir_sidescroll.)
; @addr{5af3}
_linkUpdateInAir:
	ld a,(wLinkInAir)		; $5af3
	and $0f			; $5af6
	rst_jumpTable			; $5af8
	.dw @notInAir
	.dw @startedJump
	.dw @inAir

@notInAir:
	; Ensure that bit 1 of wLinkInAir is set if Link's z position is < 0.
	ld h,d			; $5aff
	ld l,SpecialObject.zh		; $5b00
	bit 7,(hl)		; $5b02
	ret z			; $5b04

	ld a,$02		; $5b05
	ld (wLinkInAir),a		; $5b07
	jr ++			; $5b0a

@startedJump:
	ld hl,wLinkInAir		; $5b0c
	inc (hl)		; $5b0f
	bit 7,(hl)		; $5b10
	jr nz,+			; $5b12

	ld hl,wIsTileSlippery		; $5b14
	bit 6,(hl)		; $5b17
	jr nz,+			; $5b19

	ld l,<wActiveTileType		; $5b1b
	ld (hl),TILETYPE_NORMAL		; $5b1d
	call updateLinkSpeed_standard		; $5b1f

	ld a,(wLinkAngle)		; $5b22
	ld e,SpecialObject.angle		; $5b25
	ld (de),a		; $5b27
+
	ld a,SND_JUMP		; $5b28
	call playSound		; $5b2a
++
	; Set jumping animation if he's not holding anything or using an item
	ld a,(wLinkGrabState)		; $5b2d
	ld c,a			; $5b30
	ld a,(wLinkTurningDisabled)		; $5b31
	or c			; $5b34
	ld a,LINK_ANIM_MODE_JUMP		; $5b35
	call z,specialObjectSetAnimation		; $5b37

@inAir:
	xor a			; $5b3a
	ld e,SpecialObject.var12		; $5b3b
	ld (de),a		; $5b3d
	inc e			; $5b3e
	ld (de),a		; $5b3f

	; If bit 7 of wLinkInAir is set, allow him to pass through walls (needed for
	; moving through cliff tiles?)
	ld hl,wLinkInAir		; $5b40
	bit 7,(hl)		; $5b43
	jr z,+			; $5b45
	ld e,SpecialObject.adjacentWallsBitset		; $5b47
	ld (de),a		; $5b49
+
	; Set 'c' to the gravity value. Reduce if bit 5 of wLinkInAir is set?
	bit 5,(hl)		; $5b4a
	ld c,$20		; $5b4c
	jr z,+			; $5b4e
	ld c,$0a		; $5b50
+
	call objectUpdateSpeedZ_paramC		; $5b52

	ld l,SpecialObject.speedZ+1		; $5b55
	jr z,@landed			; $5b57

	; Still in the air

	; Return if speedZ is negative
	ld a,(hl)		; $5b59
	bit 7,a			; $5b5a
	ret nz			; $5b5c

	; Return if speedZ < $0300
	cp $03			; $5b5d
	ret c			; $5b5f

	; Cap speedZ to $0300
	ld (hl),$03		; $5b60
	dec l			; $5b62
	ld (hl),$00		; $5b63
	ret			; $5b65

@landed:
	; Set speedZ and wLinkInAir to 0
	xor a			; $5b66
	ldd (hl),a		; $5b67
	ld (hl),a		; $5b68
	ld (wLinkInAir),a		; $5b69

	ld e,SpecialObject.var36		; $5b6c
	ld (de),a		; $5b6e

	call _animateLinkStanding		; $5b6f
	call _specialObjectSetPositionToVar38IfSet		; $5b72
	call _linkApplyTileTypes		; $5b75

	; Check if wActiveTileType is TILETYPE_HOLE or TILETYPE_WARPHOLE
	ld a,(wActiveTileType)		; $5b78
	dec a			; $5b7b
	cp TILETYPE_WARPHOLE			; $5b7c
	jr nc,+			; $5b7e

	; If it's a hole tile, initialize this
	ld a,$04		; $5b80
	ld (wStandingOnTileCounter),a		; $5b82
+
	ld a,SND_LAND		; $5b85
	call playSound		; $5b87
	call _specialObjectUpdateAdjacentWallsBitset		; $5b8a
	jp _initLinkState		; $5b8d

;;
; @param[out]	zflag	If set, _linkState01_sidescroll will return prematurely.
; @addr{5b90}
_linkUpdateInAir_sidescroll:
	ld a,(wLinkInAir)		; $5b90
	and $0f			; $5b93
	rst_jumpTable			; $5b95
	.dw @notInAir
	.dw @jumping
	.dw @inAir

@notInAir:
	ld a,(wLinkRidingObject)		; $5b9c
	or a			; $5b9f
	ret nz			; $5ba0

	; Return if Link is on solid ground
	ld e,SpecialObject.adjacentWallsBitset		; $5ba1
	ld a,(de)		; $5ba3
	and $30			; $5ba4
	ret nz			; $5ba6

	; Return if Link's current tile, or the one he's standing on, is a ladder.
	ld hl,wActiveTileType		; $5ba7
	ldi a,(hl)		; $5baa
	or (hl)			; $5bab
	bit TILETYPE_SS_BIT_LADDER,a			; $5bac
	ret nz			; $5bae

	; Link is in the air.
	ld h,d			; $5baf
	ld l,SpecialObject.speedZ		; $5bb0
	xor a			; $5bb2
	ldi (hl),a		; $5bb3
	ldi (hl),a		; $5bb4
	jr +			; $5bb5

@jumping:
	ld a,SND_JUMP		; $5bb7
	call playSound		; $5bb9
+
	ld a,(wLinkGrabState)		; $5bbc
	ld c,a			; $5bbf
	ld a,(wLinkTurningDisabled)		; $5bc0
	or c			; $5bc3
	ld a,LINK_ANIM_MODE_JUMP		; $5bc4
	call z,specialObjectSetAnimation		; $5bc6

	ld a,$02		; $5bc9
	ld (wLinkInAir),a		; $5bcb
	call updateLinkSpeed_standard		; $5bce

@inAir:
	ld h,d			; $5bd1
	ld l,SpecialObject.speedZ+1		; $5bd2
	bit 7,(hl)		; $5bd4
	jr z,@positiveSpeedZ			; $5bd6

	; If speedZ is negative, check if he hits the ceiling
	ld e,SpecialObject.adjacentWallsBitset		; $5bd8
	ld a,(de)		; $5bda
	and $c0			; $5bdb
	jr nz,@applyGravity	; $5bdd
	jr @applySpeedZ		; $5bdf

@positiveSpeedZ:
	ld a,(wLinkRidingObject)		; $5be1
	or a			; $5be4
	jp nz,@playingInstrument		; $5be5

	; Check if Link is on solid ground
	ld e,SpecialObject.adjacentWallsBitset		; $5be8
	ld a,(de)		; $5bea
	and $30			; $5beb
	jp nz,@landedOnGround		; $5bed

	; Check if Link presses up on a ladder; this will put him back into a ground state
	ld a,(wActiveTileType)		; $5bf0
	bit TILETYPE_SS_BIT_LADDER,a			; $5bf3
	jr z,+			; $5bf5

	ld a,(wGameKeysPressed)		; $5bf7
	and BTN_UP			; $5bfa
	jp nz,@landed		; $5bfc
+
	ld e,SpecialObject.yh		; $5bff
	ld a,(de)		; $5c01
	bit 3,a			; $5c02
	jr z,+			; $5c04

	ld a,(wLastActiveTileType)		; $5c06
	cp (TILETYPE_SS_LADDER | TILETYPE_SS_LADDER_TOP)	; $5c09
	jr z,@landedOnGround	; $5c0b
+
	ld hl,wActiveTileType		; $5c0d
	ldi a,(hl)		; $5c10
	cp TILETYPE_SS_LAVA			; $5c11
	jp z,_forceDrownLink		; $5c13

	; Check if he's ended up in a hole
	cp TILETYPE_SS_HOLE			; $5c16
	jr nz,++		; $5c18

	; Check the tile below link? (In this case, since wLastActiveTileType is the tile
	; 8 pixels below him, this will probably be the same as wActiveTile, UNTIL he
	; reaches the center of the tile. At which time, if the tile beneath has
	; a tileType of $00, Link will respawn.
	ld a,(hl)		; $5c1a
	or a			; $5c1b
	jr nz,++		; $5c1c

	; Damage Link and respawn him.
	ld a,SND_DAMAGE_LINK		; $5c1e
	call playSound		; $5c20
	jp respawnLink		; $5c23

++
	call _linkUpdateVelocity		; $5c26

@applySpeedZ:
	; Apply speedZ to Y position
	ld l,SpecialObject.y		; $5c29
	ld e,SpecialObject.speedZ		; $5c2b
	ld a,(de)		; $5c2d
	add (hl)		; $5c2e
	ldi (hl),a		; $5c2f
	inc e			; $5c30
	ld a,(de)		; $5c31
	adc (hl)		; $5c32
	ldi (hl),a		; $5c33

@applyGravity:
	; Set 'c' to the gravity value (value to add to speedZ).
	ld c,$24		; $5c34
	ld a,(wLinkInAir)		; $5c36
	bit 5,a			; $5c39
	jr z,+			; $5c3b
	ld c,$0e		; $5c3d
+
	ld l,SpecialObject.speedZ		; $5c3f
	ld a,(hl)		; $5c41
	add c			; $5c42
	ldi (hl),a		; $5c43
	ld a,(hl)		; $5c44
	adc $00			; $5c45
	ldd (hl),a		; $5c47

	; Cap Link's speedZ to $0300
	bit 7,a			; $5c48
	jr nz,+			; $5c4a
	cp $03			; $5c4c
	jr c,+			; $5c4e
	xor a			; $5c50
	ldi (hl),a		; $5c51
	ld (hl),$03		; $5c52
+
	call _specialObjectUpdateAdjacentWallsBitset		; $5c54

	; Check (again) whether Link has reached the ground.
	ld e,SpecialObject.adjacentWallsBitset		; $5c57
	ld a,(de)		; $5c59
	and $30			; $5c5a
	jr nz,@landedOnGround	; $5c5c

	; Adjusts Link's angle so he doesn't move (on his own) on the y axis.
	; This is confusing since he has a Z speed, which gets applied to the Y axis. All
	; this does is prevent Link's movement from affecting the Y axis; it still allows
	; his Z speed to be applied.
	; Disabling this would give him some control over the height of his jumps.
	call _linkAdjustAngleInSidescrollingArea		; $5c5e

	call specialObjectUpdatePosition		; $5c61
	call specialObjectAnimate		; $5c64

	; Check if Link's reached the bottom boundary of the room?
	ld e,SpecialObject.yh		; $5c67
	ld a,(de)		; $5c69
	cp $a9			; $5c6a
	jr c,@notLanded	; $5c6c
	jr @landedOnGround		; $5c6e

@notLanded:
	xor a			; $5c70
	ret			; $5c71

@landedOnGround:
	; Lock his y position to the 9th pixel on that tile.
	ld e,SpecialObject.yh		; $5c72
	ld a,(de)		; $5c74
	and $f8			; $5c75
	add $01			; $5c77
	ld (de),a		; $5c79

@landed:
	xor a			; $5c7a
	ld e,SpecialObject.speedZ		; $5c7b
	ld (de),a		; $5c7d
	inc e			; $5c7e
	ld (de),a		; $5c7f

	ld (wLinkInAir),a		; $5c80

	; Check if he landed on a spike
	ld a,(wActiveTileIndex)		; $5c83
	cp TILEINDEX_SS_SPIKE			; $5c86
	call z,_dealSpikeDamageToLink		; $5c88

	ld a,SND_LAND		; $5c8b
	call playSound		; $5c8d
	call _animateLinkStanding		; $5c90
	xor a			; $5c93
	ret			; $5c94

@playingInstrument:
	ld e,SpecialObject.var12		; $5c95
	xor a			; $5c97
	ld (de),a		; $5c98

	; Write $ff to the variable that you just wrote $00 to? OK, game.
	ld a,$ff		; $5c99
	ld (de),a		; $5c9b

	ld e,SpecialObject.angle		; $5c9c
	ld (de),a		; $5c9e
	jr @landed		; $5c9f

;;
; Sets link's state to LINK_STATE_NORMAL, sets var35 to $00
; @addr{5ca1}
_initLinkState:
	ld h,d			; $5ca1
	ld l,<w1Link.state		; $5ca2
	ld (hl),LINK_STATE_NORMAL		; $5ca4
	inc l			; $5ca6
	ld (hl),$00		; $5ca7
	ld l,<w1Link.var35		; $5ca9
	ld (hl),$00		; $5cab
	ret			; $5cad

;;
; @addr{5cae}
_initLinkStateAndAnimateStanding:
	call _initLinkState		; $5cae
	ld l,<w1Link.visible	; $5cb1
	set 7,(hl)		; $5cb3
;;
; @addr{5cb5}
_animateLinkStanding:
	ld e,<w1Link.animMode	; $5cb5
	ld a,(de)		; $5cb7
	cp LINK_ANIM_MODE_WALK	; $5cb8
	jr nz,+			; $5cba

	call checkPegasusSeedCounter		; $5cbc
	jr nz,_animateLinkWalking		; $5cbf
+
	; If not using pegasus seeds, set animMode to 0. At the end of the function, this
	; will be changed back to LINK_ANIM_MODE_WALK; this will simply cause the
	; animation to be reset, resulting in him staying on the animation's first frame.
	xor a			; $5cc1
	ld (de),a		; $5cc2

;;
; @addr{5cc3}
_animateLinkWalking:
	call checkPegasusSeedCounter		; $5cc3
	jr z,++			; $5cc6

	rlca			; $5cc8
	jr nc,++		; $5cc9

	; This has to do with the little puffs appearing at link's feet
	ld hl,w1ReservedItemF		; $5ccb
	ld a,$03		; $5cce
	ldi (hl),a		; $5cd0
	ld (hl),ITEMID_DUST		; $5cd1
	inc l			; $5cd3
	inc (hl)		; $5cd4

	ld a,SND_LAND		; $5cd5
	call playSound		; $5cd7
++
	ld h,d			; $5cda
	ld a,$10	; $5cdb
	ld l,<w1Link.animMode	; $5cdd
	cp (hl)			; $5cdf
	jp nz,specialObjectSetAnimation		; $5ce0
	jp specialObjectAnimate		; $5ce3

;;
; @addr{5ce6}
updateLinkSpeed_standard:
	ld c,$00		; $5ce6

;;
; @param	c	Bit 7 set if speed shouldn't be modified?
; @addr{5ce8}
updateLinkSpeed_withParam:
	ld e,<w1Link.var36		; $5ce8
	ld a,(de)		; $5cea
	cp c			; $5ceb
	jr z,++			; $5cec

	ld a,c			; $5cee
	ld (de),a		; $5cef
	and $7f			; $5cf0
	ld hl,@data		; $5cf2
	rst_addAToHl			; $5cf5

	ld e,<w1Link.speed		; $5cf6
	ldi a,(hl)		; $5cf8
	or a			; $5cf9
	jr z,+			; $5cfa

	ld (de),a		; $5cfc
+
	xor a			; $5cfd
	ld e,<w1Link.var12		; $5cfe
	ld (de),a		; $5d00
	inc e			; $5d01
	ldi a,(hl)		; $5d02
	ld (de),a		; $5d03
++
	; 'b' will be added to the index for the below table, depending on whether Link is
	; slowed down by grass, stairs, etc.
	ld b,$02		; $5d04
	; 'e' will be added to the index in the same way as 'b'. It will be $04 if Link is
	; using pegasus seeds.
	ld e,$00		; $5d06

	; Don't apply pegasus seed modifier when on a hole?
	ld a,(wActiveTileType)		; $5d08
	cp TILETYPE_HOLE	; $5d0b
	jr z,++			; $5d0d
	cp TILETYPE_WARPHOLE	; $5d0f
	jr z,++			; $5d11

	; Grass: b = $02
	cp TILETYPE_GRASS	; $5d13
	jr z,+			; $5d15
	inc b			; $5d17

	; Stairs / vines: b = $03
	cp TILETYPE_STAIRS	; $5d18
	jr z,+			; $5d1a
	cp TILETYPE_VINES	; $5d1c
	jr z,+			; $5d1e

	; Standard movement: b = $04
	inc b			; $5d20
+
	call checkPegasusSeedCounter		; $5d21
	jr z,++			; $5d24

	ld e,$03		; $5d26
++
	ld a,e			; $5d28
	add b			; $5d29
	add c			; $5d2a
	and $7f			; $5d2b
	ld hl,@data		; $5d2d
	rst_addAToHl			; $5d30
	ld a,(hl)		; $5d31
	ld h,d			; $5d32
	ld l,<w1Link.speedTmp		; $5d33
	ldd (hl),a		; $5d35
	bit 7,c			; $5d36
	ret nz			; $5d38
	ld (hl),a		; $5d39
	ret			; $5d3a

@data:
	.db $28 $00 $1e $14 $28 $2d $1e $3c
	.db $00 $06 $28 $28 $28 $3c $3c $3c
	.db $14 $03 $1e $14 $28 $2d $1e $3c
	.db $00 $05 $2d $2d $2d $2d $2d $2d

;;
; Updates Link's speed and updates his position if he's experiencing knockback.
; @addr{5d5b}
_linkUpdateKnockback:
	ld e,SpecialObject.state		; $5d5b
	ld a,(de)		; $5d5d
	cp LINK_STATE_RESPAWNING			; $5d5e
	jr z,@cancelKnockback	; $5d60

	ld a,(wLinkInAir)		; $5d62
	rlca			; $5d65
	jr c,@cancelKnockback	; $5d66

	; Set c to the amount to decrement knockback by.
	; $01 normally, $02 if in the air?
	ld c,$01		; $5d68
	or a			; $5d6a
	jr z,+			; $5d6b
	inc c			; $5d6d
+
	ld h,d			; $5d6e
	ld l,SpecialObject.knockbackCounter		; $5d6f
	ld a,(hl)		; $5d71
	or a			; $5d72
	ret z			; $5d73

	; Decrement knockback
	sub c			; $5d74
	jr c,@cancelKnockback	; $5d75
	ld (hl),a		; $5d77

	; Adjust link's knockback angle if necessary when sidescrolling
	ld l,SpecialObject.knockbackAngle		; $5d78
	call _linkAdjustGivenAngleInSidescrollingArea		; $5d7a

	; Get speed and knockback angle (de = w1Link.knockbackAngle)
	ld a,(de)		; $5d7d
	ld c,a			; $5d7e
	ld b,SPEED_140		; $5d7f

	ld hl,wcc95		; $5d81
	res 5,(hl)		; $5d84

	jp specialObjectUpdatePositionGivenVelocity		; $5d86

@cancelKnockback:
	ld e,SpecialObject.knockbackCounter		; $5d89
	xor a			; $5d8b
	ld (de),a		; $5d8c
	ret			; $5d8d

;;
; Updates a special object's position without allowing it to "slide off" tiles when they
; are approached from the side.
; @addr{5d8e}
specialObjectUpdatePositionWithoutTileEdgeAdjust:
	ld e,SpecialObject.speed		; $5d8e
	ld a,(de)		; $5d90
	ld b,a			; $5d91
	ld e,SpecialObject.angle		; $5d92
	ld a,(de)		; $5d94
	jr +			; $5d95

;;
; @addr{5d97}
specialObjectUpdatePosition:
	ld e,SpecialObject.speed		; $5d97
	ld a,(de)		; $5d99
	ld b,a			; $5d9a
	ld e,SpecialObject.angle	; $5d9b
	ld a,(de)		; $5d9d
	ld c,a			; $5d9e

;;
; Updates position, accounting for solid walls.
;
; @param	b	Speed
; @param	c	Angle
; @param[out]	a	Bits 0, 1 set if his y, x positions changed, respectively.
; @param[out]	c	Same as a.
; @param[out]	zflag	Set if the object did not move at all.
; @addr{5d9f}
specialObjectUpdatePositionGivenVelocity:
	bit 7,c			; $5d9f
	jr nz,++++		; $5da1

	ld e,SpecialObject.adjacentWallsBitset		; $5da3
	ld a,(de)		; $5da5
	ld e,a			; $5da6
	call @tileEdgeAdjust		; $5da7
	jr nz,++		; $5daa
+
	ld c,a			; $5dac
	ld e,$00		; $5dad
++
	; Depending on the angle, change 'e' to hold the bits that should be checked for
	; collision in adjacentWallsBitset. If the angle is facing up, then only the 'up'
	; bits will be set.
	ld a,c			; $5daf
	ld hl,@bitsToCheck		; $5db0
	rst_addAToHl			; $5db3
	ld a,e			; $5db4
	and (hl)		; $5db5
	ld e,a			; $5db6

	; Get 4 bytes at hl determining the offsets Link should move for speed 'b' and
	; angle 'c'.
	call getPositionOffsetForVelocity		; $5db7

	ld c,$00		; $5dba

	; Don't apply vertical speed if there is a wall.
	ld b,e			; $5dbc
	ld a,b			; $5dbd
	and $f0			; $5dbe
	jr nz,++		; $5dc0

	; Don't run the below code if the vertical offset is zero.
	ldi a,(hl)		; $5dc2
	or (hl)			; $5dc3
	jr z,++			; $5dc4

	; Add values at hl to y position
	dec l			; $5dc6
	ld e,SpecialObject.y		; $5dc7
	ld a,(de)		; $5dc9
	add (hl)		; $5dca
	ld (de),a		; $5dcb
	inc e			; $5dcc
	inc l			; $5dcd
	ld a,(de)		; $5dce
	adc (hl)		; $5dcf
	ld (de),a		; $5dd0

	; Set bit 0 of c
	inc c			; $5dd1
++
	; Don't apply horizontal speed if there is a wall.
	ld a,b			; $5dd2
	and $0f			; $5dd3
	jr nz,++		; $5dd5

	; Don't run the below code if the horizontal offset is zero.
	ld l,<(wTmpcec0+3)		; $5dd7
	ldd a,(hl)		; $5dd9
	or (hl)			; $5dda
	jr z,++			; $5ddb

	; Add values at hl to x position
	ld e,SpecialObject.x		; $5ddd
	ld a,(de)		; $5ddf
	add (hl)		; $5de0
	ld (de),a		; $5de1
	inc l			; $5de2
	inc e			; $5de3
	ld a,(de)		; $5de4
	adc (hl)		; $5de5
	ld (de),a		; $5de6

	set 1,c			; $5de7
++
	ld a,c			; $5de9
	or a			; $5dea
	ret			; $5deb
++++
	xor a			; $5dec
	ld c,a			; $5ded
	ret			; $5dee

; Takes an angle as an index.
; Each value tells which bits in adjacentWallsBitset to check for collision for that
; angle. Ie. when moving up, only check collisions above Link, not below.
@bitsToCheck:
	.db $cf $c3 $c3 $c3 $c3 $c3 $c3 $c3
	.db $f3 $33 $33 $33 $33 $33 $33 $33
	.db $3f $3c $3c $3c $3c $3c $3c $3c
	.db $fc $cc $cc $cc $cc $cc $cc $cc

;;
; Converts Link's angle such that he "slides off" a tile when walking towards the edge.
; @param c Angle
; @param e adjacentWallsBitset
; @param[out] a New angle value
; @param[out] zflag Set if a value has been returned in 'a'.
; @addr{5e0f}
@tileEdgeAdjust:
	ld a,c			; $5e0f
	ld hl,slideAngleTable		; $5e10
	rst_addAToHl			; $5e13
	ld a,(hl)		; $5e14
	and $03			; $5e15
	ret nz			; $5e17

	ld a,(hl)		; $5e18
	rlca			; $5e19
	jr c,@bit7		; $5e1a
	rlca			; $5e1c
	jr c,@bit6		; $5e1d
	rlca			; $5e1f
	jr c,@bit5		; $5e20

	ld a,e			; $5e22
	and $cc			; $5e23
	cp $04			; $5e25
	ld a,$00		; $5e27
	ret z			; $5e29

	ld a,e			; $5e2a
	and $3c			; $5e2b
	cp $08			; $5e2d
	ld a,$10		; $5e2f
	ret			; $5e31
@bit5:
	ld a,e			; $5e32
	and $c3			; $5e33
	cp $01			; $5e35
	ld a,$00		; $5e37
	ret z			; $5e39
	ld a,e			; $5e3a
	and $33			; $5e3b
	cp $02			; $5e3d
	ld a,$10		; $5e3f
	ret			; $5e41
@bit7:
	ld a,e			; $5e42
	and $c3			; $5e43
	cp $80			; $5e45
	ld a,$08		; $5e47
	ret z			; $5e49
	ld a,e			; $5e4a
	and $cc			; $5e4b
	cp $40			; $5e4d
	ld a,$18		; $5e4f
	ret			; $5e51
@bit6:
	ld a,e			; $5e52
	and $33			; $5e53
	cp $20			; $5e55
	ld a,$08		; $5e57
	ret z			; $5e59
	ld a,e			; $5e5a
	and $3c			; $5e5b
	cp $10			; $5e5d
	ld a,$18		; $5e5f
	ret			; $5e61

;;
; Updates SpecialObject.adjacentWallsBitset (always for link?) which determines which ways
; he can move.
; @addr{5e62}
_specialObjectUpdateAdjacentWallsBitset:
	ld e,SpecialObject.adjacentWallsBitset		; $5e62
	xor a			; $5e64
	ld (de),a		; $5e65

	; Return if Link is riding a companion, minecart
	ld a,(wLinkObjectIndex)		; $5e66
	rrca			; $5e69
	ret c			; $5e6a

	ld h,d			; $5e6b
	ld l,SpecialObject.yh		; $5e6c
	ld b,(hl)		; $5e6e
	ld l,SpecialObject.xh		; $5e6f
	ld c,(hl)		; $5e71
	call calculateAdjacentWallsBitset		; $5e72
	ld b,a			; $5e75
	ld hl,@data-1		; $5e76
--
	inc hl			; $5e79
	ldi a,(hl)		; $5e7a
	or a			; $5e7b
	jr z,++			; $5e7c
	cp b			; $5e7e
	jr nz,--		; $5e7f

	ld a,(hl)		; $5e81
	ldh (<hFF8B),a	; $5e82
	ld e,SpecialObject.adjacentWallsBitset		; $5e84
	ld (de),a		; $5e86
	ret			; $5e87
++
	ld a,b			; $5e88
	ld e,SpecialObject.adjacentWallsBitset		; $5e89
	ld (de),a		; $5e8b
	ret			; $5e8c

@data:
	.db $db $c3
	.db $ee $cc
	.db $00

;;
; This function only really works with Link.
;
; @param	bc	Position to check
; @param[out]	b	Bit 7 set if the position is surrounded by a wall on all sides?
; @addr{5e92}
checkPositionSurroundedByWalls:
	call calculateAdjacentWallsBitset		; $5e92
--
	ld b,$80		; $5e95
	cp $ff			; $5e97
	ret z			; $5e99

	rra			; $5e9a
	rl b			; $5e9b
	rra			; $5e9d
	rl b			; $5e9e
	jr nz,--		; $5ea0
	ret			; $5ea2

;;
; This function is likely meant for Link only, due to its use of "wLinkRaisedFloorOffset".
;
; @param	bc	YX position.
; @param[out]	a	Bitset of adjacent walls.
; @param[out]	hFF8B	Same as 'a'.
; @addr{5ea3}
calculateAdjacentWallsBitset:
	ld a,$01		; $5ea3
	ldh (<hFF8B),a	; $5ea5

	ld hl,@overworldOffsets		; $5ea7
	ld a,(wTilesetFlags)		; $5eaa
	and TILESETFLAG_SIDESCROLL			; $5ead
	jr z,@loop			; $5eaf
	ld hl,@sidescrollOffsets		; $5eb1

; Loop 8 times
@loop:
	ldi a,(hl)		; $5eb4
	add b			; $5eb5
	ld b,a			; $5eb6
	ldi a,(hl)		; $5eb7
	add c			; $5eb8
	ld c,a			; $5eb9
	push hl			; $5eba

	ld a,(wLinkRaisedFloorOffset)		; $5ebb
	or a			; $5ebe
	jr z,+			; $5ebf

	call @checkTileCollisionAt_allowRaisedFl		; $5ec1
	jr ++			; $5ec4
+
	call checkTileCollisionAt_allowHoles		; $5ec6
++
	pop hl			; $5ec9
	ldh a,(<hFF8B)	; $5eca
	rla			; $5ecc
	ldh (<hFF8B),a	; $5ecd
	jr nc,@loop		; $5ecf
	ret			; $5ed1

; List of YX offsets from Link's position to check for collision at.
; For each offset where there is a collision, the corresponding bit of 'a' will be set.
@overworldOffsets:
	.db -3, -3
	.db  0,  5
	.db 10, -5
	.db  0,  5
	.db -7, -7
	.db  5,  0
	.db -5,  9
	.db  5,  0

@sidescrollOffsets:
	.db -3, -3
	.db  0,  5
	.db 10, -5
	.db  0,  5
	.db -7, -7
	.db  5,  0
	.db -5,  9
	.db  5,  0

;;
; This may be identical to "checkTileCollisionAt_allowHoles", except that unlike that,
; this does not consider raised floors to have collision?
; @param bc YX position to check for collision
; @param[out] cflag Set on collision
; @addr{5ef2}
@checkTileCollisionAt_allowRaisedFl:
	ld a,b			; $5ef2
	and $f0			; $5ef3
	ld l,a			; $5ef5
	ld a,c			; $5ef6
	swap a			; $5ef7
	and $0f			; $5ef9
	or l			; $5efb
	ld l,a			; $5efc
	ld h,>wRoomCollisions		; $5efd
	ld a,(hl)		; $5eff
	cp $10			; $5f00
	jr c,@simpleCollision		; $5f02

; Complex collision

	and $0f			; $5f04
	ld hl,@specialCollisions		; $5f06
	rst_addAToHl			; $5f09
	ld e,(hl)		; $5f0a
	cp $08			; $5f0b
	ld a,b			; $5f0d
	jr nc,+			; $5f0e
	ld a,c			; $5f10
+
	rrca			; $5f11
	and $07			; $5f12
	ld hl,bitTable		; $5f14
	add l			; $5f17
	ld l,a			; $5f18
	ld a,(hl)		; $5f19
	and e			; $5f1a
	ret z			; $5f1b
	scf			; $5f1c
	ret			; $5f1d

@specialCollisions:
	.db %00000000 %11000011 %00000011 %11000000 %00000000 %11000011 %11000011 %00000000
	.db %00000000 %11000011 %00000011 %11000000 %11000000 %11000001 %00000000 %00000000


@simpleCollision:
	bit 3,b			; $5f2e
	jr nz,+			; $5f30
	rrca			; $5f32
	rrca			; $5f33
+
	bit 3,c			; $5f34
	jr nz,+			; $5f36
	rrca			; $5f38
+
	rrca			; $5f39
	ret			; $5f3a

;;
; Unused?
; @addr{5f3b}
_clearLinkImmobilizedBit4:
	push hl			; $5f3b
	ld hl,wLinkImmobilized		; $5f3c
	res 4,(hl)		; $5f3f
	pop hl			; $5f41
	ret			; $5f42

;;
; @addr{5f43}
_setLinkImmobilizedBit4:
	push hl			; $5f43
	ld hl,wLinkImmobilized		; $5f44
	set 4,(hl)		; $5f47
	pop hl			; $5f49
	ret			; $5f4a

;;
; Adjusts Link's position to suck him into the center of a tile, and sets his state to
; LINK_STATE_FALLING when he reaches the center.
; @addr{5f4b}
_linkPullIntoHole:
	xor a			; $5f4b
	ld e,SpecialObject.knockbackCounter		; $5f4c
	ld (de),a		; $5f4e

	ld h,d			; $5f4f
	ld l,SpecialObject.state		; $5f50
	ld a,(hl)		; $5f52
	cp LINK_STATE_RESPAWNING			; $5f53
	ret z			; $5f55

	; Allow partial control of Link's position for the first 16 frames he's over the
	; hole.
	ld a,(wStandingOnTileCounter)		; $5f56
	cp $10			; $5f59
	call nc,_setLinkImmobilizedBit4		; $5f5b

	; Depending on the frame counter, move horizontally, vertically, or not at all.
	and $03			; $5f5e
	jr z,@moveVertical			; $5f60
	dec a			; $5f62
	jr z,@moveHorizontal			; $5f63
	ret			; $5f65

@moveVertical:
	ld l,SpecialObject.yh		; $5f66
	ld a,(hl)		; $5f68
	add $05			; $5f69
	and $f0			; $5f6b
	add $08			; $5f6d
	sub (hl)		; $5f6f
	jr c,@decPosition			; $5f70
	jr @incPosition			; $5f72

@moveHorizontal:
	ld l,SpecialObject.xh		; $5f74
	ld a,(hl)		; $5f76
	and $f0			; $5f77
	add $08			; $5f79
	sub (hl)		; $5f7b
	jr c,@decPosition			; $5f7c

@incPosition:
	ld a,(hl)		; $5f7e
	inc a			; $5f7f
	jr +			; $5f80

@decPosition:
	ld a,(hl)		; $5f82
	dec a			; $5f83
+
	ld (hl),a		; $5f84

	; Check that Link is within 3 pixels of the vertical center
	ld l,SpecialObject.yh		; $5f85
	ldi a,(hl)		; $5f87
	and $0f			; $5f88
	sub $07			; $5f8a
	cp $03			; $5f8c
	ret nc			; $5f8e

	; Check that Link is within 3 pixels of the horizontal center
	inc l			; $5f8f
	ldi a,(hl)		; $5f90
	and $0f			; $5f91
	sub $07			; $5f93
	cp $03			; $5f95
	ret nc			; $5f97

	; Link has reached the center of the tile, now he'll start falling

	call clearAllParentItems		; $5f98

	ld e,SpecialObject.knockbackCounter		; $5f9b
	xor a			; $5f9d
	ld (de),a		; $5f9e
	ld (wLinkStateParameter),a		; $5f9f

	; Change Link's state to the falling state
	ld e,SpecialObject.id		; $5fa2
	ld a,(de)		; $5fa4
	or a			; $5fa5
	ld a,LINK_STATE_RESPAWNING		; $5fa6
	jp z,linkSetState		; $5fa8

	; If link's ID isn't zero, set his state indirectly...?
	ld (wLinkForceState),a		; $5fab
	ret			; $5fae

;;
; Checks if Link is pushing against the bed in Nayru's house. If so, set Link's state to
; LINK_STATE_SLEEPING.
; The only bed that this works for is the one in Nayru's house.
; @addr{5faf}
checkLinkPushingAgainstBed:
	ld hl,wInformativeTextsShown		; $5faf
	bit 1,(hl)		; $5fb2
	ret nz			; $5fb4

	ld a,(wActiveGroup)		; $5fb5
	cp $03			; $5fb8
	ret nz			; $5fba

	; Check link is in room $9e, position $17, facing right
	ldbc $9e, $17		; $5fbb
	ld l,DIR_RIGHT		; $5fbe
	ld a,(wActiveRoom)		; $5fc0
	cp b			; $5fc3
	ret nz			; $5fc4

	ld a,(wActiveTilePos)		; $5fc5
	cp c			; $5fc8
	ret nz			; $5fc9

	ld e,SpecialObject.direction		; $5fca
	ld a,(de)		; $5fcc
	cp l			; $5fcd
	ret nz			; $5fce

	call checkLinkPushingAgainstWall		; $5fcf
	ret z			; $5fd2

	; Increment counter, wait until it's been 90 frames
	ld hl,wLinkPushingAgainstBedCounter		; $5fd3
	inc (hl)		; $5fd6
	ld a,(hl)		; $5fd7
	cp 90			; $5fd8
	ret c			; $5fda

	pop hl			; $5fdb
	ld hl,wInformativeTextsShown		; $5fdc
	set 1,(hl)		; $5fdf
	ld a,LINK_STATE_SLEEPING		; $5fe1
	jp linkSetState		; $5fe3

_label_05_234:
	xor a			; $5fe6
	ld e,SpecialObject.var37		; $5fe7
	ld (de),a		; $5fe9
	inc e			; $5fea
	ld (de),a		; $5feb
	ret			; $5fec

;;
; @param	a	Value for var37
; @param	l	Value for var38 (a position value)
; @addr{5fed}
_specialObjectSetVar37AndVar38:
	ld e,SpecialObject.var37		; $5fed
	ld (de),a		; $5fef
	inc e			; $5ff0
	ld a,l			; $5ff1
	ld (de),a		; $5ff2

;;
; Sets an object's angle to face the position in var37/var38?
; @addr{5ff3}
_specialObjectSetAngleRelativeToVar38:
	ld e,SpecialObject.var37		; $5ff3
	ld a,(de)		; $5ff5
	or a			; $5ff6
	ret z			; $5ff7

	ld hl,_data_6012-2		; $5ff8
	rst_addDoubleIndex			; $5ffb

	inc e			; $5ffc
	ld a,(de)		; $5ffd
	ld c,a			; $5ffe
	and $f0			; $5fff
	add (hl)		; $6001
	ld b,a			; $6002
	inc hl			; $6003
	ld a,c			; $6004
	and $0f			; $6005
	swap a			; $6007
	add (hl)		; $6009
	ld c,a			; $600a

	call objectGetRelativeAngle		; $600b
	ld e,SpecialObject.angle		; $600e
	ld (de),a		; $6010
	ret			; $6011

; @addr{6012}
_data_6012:
	.db $02 $08
	.db $0c $08

;;
; Warps link somewhere based on var37 and var38?
; @addr{6016}
_specialObjectSetPositionToVar38IfSet:
	ld e,SpecialObject.var37		; $6016
	ld a,(de)		; $6018
	or a			; $6019
	ret z			; $601a

	ld hl,_data_6012-2		; $601b
	rst_addDoubleIndex			; $601e

	; de = SpecialObject.var38
	inc e			; $601f
	ld a,(de)		; $6020
	ld c,a			; $6021
	and $f0			; $6022
	add (hl)		; $6024
	ld e,SpecialObject.yh		; $6025
	ld (de),a		; $6027

	inc hl			; $6028
	ld a,c			; $6029
	and $0f			; $602a
	swap a			; $602c
	add (hl)		; $602e
	ld e,SpecialObject.xh		; $602f
	ld (de),a		; $6031
	jr _label_05_234		; $6032

;;
; Checks if Link touches a cliff tile, and starts the jumping-off-cliff code if so.
; @addr{6034}
_checkLinkJumpingOffCliff:
	; Return if Link is not moving in a cardinal direction?
	ld a,(wLinkAngle)		; $6034
	ld c,a			; $6037
	and $e7			; $6038
	ret nz			; $603a

	ld h,d			; $603b
	ld l,SpecialObject.angle		; $603c
	xor c			; $603e
	cp (hl)			; $603f
	ret nz			; $6040

	; Check that Link is facing towards a solid wall
	add a			; $6041
	swap a			; $6042
	ld c,a			; $6044
	add a			; $6045
	add a			; $6046
	add c			; $6047
	ld hl,@wallDirections		; $6048
	rst_addAToHl			; $604b
	ld e,SpecialObject.adjacentWallsBitset		; $604c
	ld a,(de)		; $604e
	and (hl)		; $604f
	cp (hl)			; $6050
	ret nz			; $6051

	; Check 2 offsets from Link's position to ensure that both of them are cliff
	; tiles.
	call @checkCliffTile		; $6052
	ret nc			; $6055
	call @checkCliffTile		; $6056
	ret nc			; $6059

	; If the above checks passed, start making Link jump off the cliff.

	ld a,$81		; $605a
	ld (wLinkInAir),a		; $605c
	ld bc,-$1c0		; $605f
	call objectSetSpeedZ		; $6062
	ld l,SpecialObject.knockbackCounter		; $6065
	ld (hl),$00		; $6067

	; Return from caller (don't execute any more "linkState01" code)
	pop hl			; $6069

	ld a,LINK_STATE_JUMPING_DOWN_LEDGE		; $606a
	call linkSetState		; $606c
	jr _linkState12		; $606f

;;
; Unused?
; @addr{6071}
@setSpeed140:
	ld l,SpecialObject.speed		; $6071
	ld (hl),SPEED_140		; $6073
	ret			; $6075

;;
; @param[out] cflag
; @addr{6076}
@checkCliffTile:
	inc hl			; $6076
	ldi a,(hl)		; $6077
	ld c,(hl)		; $6078
	ld b,a			; $6079
	push hl			; $607a
	call objectGetRelativeTile		; $607b
	ldh (<hFF8B),a	; $607e
	ld hl,cliffTilesTable		; $6080
	call lookupCollisionTable		; $6083
	pop hl			; $6086
	ret nc			; $6087

	ld c,a			; $6088
	ld e,SpecialObject.angle		; $6089
	ld a,(de)		; $608b
	cp c			; $608c
	scf			; $608d
	ret z			; $608e

	xor a			; $608f
	ret			; $6090

; Data format:
; b0: bits that must be set in w1Link.adjacentWallsBitset for that direction
; b1-b2, b3-b4: Each of these pairs of bytes is a relative offset from Link's position to
; check whether the tile there is a cliff tile. Both resulting positions must be valid.
@wallDirections:
	.db $c0 $fc $fd $fc $02 ; DIR_UP
	.db $03 $00 $04 $05 $04 ; DIR_RIGHT
	.db $30 $08 $fd $08 $02 ; DIR_DOWN
	.db $0c $00 $fb $05 $fb ; DIR_LEFT

;;
; LINK_STATE_JUMPING_DOWN_LEDGE
; @addr{60a5}
_linkState12:
	ld e,SpecialObject.state2		; $60a5
	ld a,(de)		; $60a7
	rst_jumpTable			; $60a8
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call itemIncState2		; $60b1

	; Set jumping animation if not underwater
	ld l,SpecialObject.var2f		; $60b4
	bit 7,(hl)		; $60b6
	jr nz,++		; $60b8

	ld a,(wLinkGrabState)		; $60ba
	ld c,a			; $60bd
	ld a,(wLinkTurningDisabled)		; $60be
	or c			; $60c1
	ld a,LINK_ANIM_MODE_JUMP		; $60c2
	call z,specialObjectSetAnimation		; $60c4
++
	ld a,SND_JUMP		; $60c7
	call playSound		; $60c9

	call @getLengthOfCliff		; $60cc
	jr z,@willTransition			; $60cf

	ld hl,@cliffSpeedTable - 1		; $60d1
	rst_addAToHl			; $60d4
	ld a,(hl)		; $60d5
	ld e,SpecialObject.speed		; $60d6
	ld (de),a		; $60d8
	ret			; $60d9

; A screen transition will occur by jumping off this cliff. Only works properly for cliffs
; facing down.
@willTransition:
	ld a,(wScreenTransitionBoundaryY)		; $60da
	ld b,a			; $60dd
	ld h,d			; $60de
	ld l,SpecialObject.yh		; $60df
	ld a,(hl)		; $60e1
	sub b			; $60e2
	ld (hl),b		; $60e3

	ld l,SpecialObject.zh		; $60e4
	ld (hl),a		; $60e6

	; Disable terrain effects (shadow)
	ld l,SpecialObject.visible		; $60e7
	res 6,(hl)		; $60e9

	ld l,SpecialObject.state2		; $60eb
	ld (hl),$02		; $60ed

	xor a			; $60ef
	ld l,SpecialObject.speed		; $60f0
	ld (hl),a		; $60f2
	ld l,SpecialObject.speedZ		; $60f3
	ldi (hl),a		; $60f5
	ld (hl),$ff		; $60f6

	; [wDisableScreenTransitions] = $01
	inc a			; $60f8
	ld (wDisableScreenTransitions),a		; $60f9

	ld l,SpecialObject.var2f		; $60fc
	set 0,(hl)		; $60fe
	ret			; $6100


; The index to this table is the length of a cliff in tiles; the value is the speed
; required to pass through the cliff.
@cliffSpeedTable:
	.db           SPEED_080 SPEED_0a0 SPEED_0e0
	.db SPEED_120 SPEED_160 SPEED_1a0 SPEED_200
	.db SPEED_240 SPEED_280 SPEED_2c0 SPEED_300


; In the process of falling down the cliff (will land in-bounds).
@substate1:
	call objectApplySpeed		; $610c
	ld c,$20		; $610f
	call objectUpdateSpeedZ_paramC		; $6111
	jp nz,specialObjectAnimate		; $6114

; Link has landed on the ground

	; If a screen transition happened, update respawn position
	ld h,d			; $6117
	ld l,SpecialObject.var2f		; $6118
	bit 0,(hl)		; $611a
	res 0,(hl)		; $611c
	call nz,updateLinkLocalRespawnPosition		; $611e

	call specialObjectTryToBreakTile_source05		; $6121

	xor a			; $6124
	ld (wLinkInAir),a		; $6125
	ld (wLinkSwimmingState),a		; $6128

	ld a,SND_LAND		; $612b
	call playSound		; $612d

	call _specialObjectUpdateAdjacentWallsBitset		; $6130
	jp _initLinkStateAndAnimateStanding		; $6133


; In the process of falling down the cliff (a screen transition will occur).
@substate2:
	ld c,$20		; $6136
	call objectUpdateSpeedZ_paramC		; $6138
	jp nz,specialObjectAnimate		; $613b

	; Initiate screen transition
	ld a,$82		; $613e
	ld (wScreenTransitionDirection),a		; $6140
	ld e,SpecialObject.state2		; $6143
	ld a,$03		; $6145
	ld (de),a		; $6147
	ret			; $6148

; In the process of falling down the cliff, after a screen transition happened.
@substate3:
	; Wait for transition to finish
	ld a,(wScrollMode)		; $6149
	cp $01			; $614c
	ret nz			; $614e

	call @getLengthOfCliff		; $614f

	; Set his y position to the position he'll land at, and set his z position to the
	; equivalent height needed to appear to not have moved.
	ld h,d			; $6152
	ld l,SpecialObject.yh		; $6153
	ld a,(hl)		; $6155
	sub b			; $6156
	ld (hl),b		; $6157
	ld l,SpecialObject.zh		; $6158
	ld (hl),a		; $615a

	; Re-enable terrain effects (shadow)
	ld l,SpecialObject.visible		; $615b
	set 6,(hl)		; $615d

	; Go to substate 1 to complete the fall.
	ld l,SpecialObject.state2		; $615f
	ld (hl),$01		; $6161
	ret			; $6163

;;
; Calculates the number of cliff tiles Link will need to pass through.
;
; @param[out]	a	Number of cliff tiles that Link must pass through
; @param[out]	bc	Position of the tile that will be landed on
; @param[out]	zflag	Set if there will be a screen transition before hitting the ground
; @addr{6164}
@getLengthOfCliff:
	; Get Link's position in bc
	ld h,d			; $6164
	ld l,SpecialObject.yh		; $6165
	ldi a,(hl)		; $6167
	add $05			; $6168
	ld b,a			; $616a
	inc l			; $616b
	ld c,(hl)		; $616c

	; Determine direction he's moving in based on angle
	ld l,SpecialObject.angle		; $616d
	ld a,(hl)		; $616f
	add a			; $6170
	swap a			; $6171
	and $03			; $6173
	ld hl,@offsets		; $6175
	rst_addDoubleIndex			; $6178

	ldi a,(hl)
	ldh (<hFF8D),a ; [hFF8D] = y-offset to add to get the next tile's position
	ld a,(hl)
	ldh (<hFF8C),a ; [hFF8C] = x-offset to add to get the next tile's position
	ld a,$01
	ldh (<hFF8B),a ; [hFF8B] = how many tiles away the one we're checking is

@nextTile:
	; Get next tile's position
	ldh a,(<hFF8D)	; $6183
	add b			; $6185
	ld b,a			; $6186
	ldh a,(<hFF8C)	; $6187
	add c			; $6189
	ld c,a			; $618a

	call checkTileCollisionAt_allowHoles		; $618b
	jr nc,@noCollision	; $618e

	; If this tile is breakable, we can land here
	ld a, $80 | BREAKABLETILESOURCE_05		; $6190
	call tryToBreakTile		; $6192
	jr c,@landHere	; $6195

	; Even if it's solid and unbreakable, check if it's an exception (raisable floor)
	ldh a,(<hFF92)	; $6197
	ld hl,_landableTileFromCliffExceptions		; $6199
	call findByteInCollisionTable		; $619c
	jr c,@landHere	; $619f

	; Try the next tile
	ldh a,(<hFF8B)	; $61a1
	inc a			; $61a3
	ldh (<hFF8B),a	; $61a4
	jr @nextTile			; $61a6

@noCollision:
	; Check if we've gone out of bounds (tile index $00)
	call getTileAtPosition		; $61a8
	or a			; $61ab
	ret z			; $61ac

@landHere:
	ldh a,(<hFF8B)	; $61ad
	cp $0b			; $61af
	jr c,+			; $61b1
	ld a,$0b		; $61b3
+
	or a			; $61b5
	ret			; $61b6

@offsets:
	.db $f8 $00 ; DIR_UP
	.db $00 $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT


; This is a list of tiles that can be landed on when jumping down a cliff, despite being
; solid.
_landableTileFromCliffExceptions:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions1:
@collisions2:
@collisions5:
	.db TILEINDEX_RAISABLE_FLOOR_1 TILEINDEX_RAISABLE_FLOOR_2
@collisions0:
@collisions3:
@collisions4:
	.db $00


;;
; @addr{61ce}
specialObjectCode_transformedLink:
	ld e,SpecialObject.state		; $61ce
	ld a,(de)		; $61d0
	rst_jumpTable			; $61d1
	.dw @state0
	.dw @state1

;;
; State 0: initialization (just transformed)
; @addr{61d6}
@state0:
	call dropLinkHeldItem		; $61d6
	call clearAllParentItems		; $61d9
	ld a,(wLinkForceState)		; $61dc
	or a			; $61df
	jr nz,@resetIDToNormal	; $61e0

	call specialObjectSetOamVariables		; $61e2
	xor a			; $61e5
	call specialObjectSetAnimation		; $61e6
	call objectSetVisiblec1		; $61e9
	call itemIncState		; $61ec

	ld l,SpecialObject.collisionType		; $61ef
	ld a, $80 | ITEMCOLLISION_LINK
	ldi (hl),a		; $61f3

	inc l			; $61f4
	ld a,$06		; $61f5
	ldi (hl),a ; [collisionRadiusY] = $06
	ldi (hl),a ; [collisionRadiusX] = $06

	ld l,SpecialObject.id		; $61f9
	ld a,(hl)		; $61fb
	cp SPECIALOBJECTID_LINK_AS_BABY			; $61fc
	ret nz			; $61fe

	ld l,SpecialObject.counter1		; $61ff
	ld (hl),$e0		; $6201
	inc l			; $6203
	ld (hl),$01 ; [counter2] = $01

	ld a,SND_BECOME_BABY		; $6206
	call playSound		; $6208
	jr @createGreenPoof		; $620b

@disableTransformationForBaby:
	ld a,SND_MAGIC_POWDER		; $620d
	call playSound		; $620f

@disableTransformation:
	lda SPECIALOBJECTID_LINK			; $6212
	call setLinkIDOverride		; $6213
	ld a,$01		; $6216
	ld (wDisableRingTransformations),a		; $6218

	ld e,SpecialObject.id		; $621b
	ld a,(de)		; $621d
	cp SPECIALOBJECTID_LINK_AS_BABY			; $621e
	ret nz			; $6220

@createGreenPoof:
	ld b,INTERACID_GREENPOOF		; $6221
	jp objectCreateInteractionWithSubid00		; $6223

@resetIDToNormal:
	; If a specific state is requested, go back to normal Link code and run it.
	lda SPECIALOBJECTID_LINK			; $6226
	call setLinkID		; $6227
	ld a,$01		; $622a
	ld (wDisableRingTransformations),a		; $622c
	jp specialObjectCode_link		; $622f

;;
; State 1: normal movement, etc in transformed state
; @addr{6232}
@state1:
	ld a,(wLinkForceState)		; $6232
	or a			; $6235
	jr nz,@resetIDToNormal	; $6236

	ld a,(wPaletteThread_mode)		; $6238
	or a			; $623b
	ret nz			; $623c

	ld a,(wScrollMode)		; $623d
	and $0e			; $6240
	ret nz			; $6242

	call updateLinkDamageTaken		; $6243
	ld a,(wLinkDeathTrigger)		; $6246
	or a			; $6249
	jr nz,@disableTransformation	; $624a

	call retIfTextIsActive		; $624c

	ld a,(wDisabledObjects)		; $624f
	and $81			; $6252
	ret nz			; $6254

	call decPegasusSeedCounter		; $6255

	ld h,d			; $6258
	ld l,SpecialObject.id		; $6259
	ld a,(hl)		; $625b
	cp SPECIALOBJECTID_LINK_AS_BABY			; $625c
	jr nz,+		; $625e
	ld l,SpecialObject.counter1		; $6260
	call decHlRef16WithCap		; $6262
	jr z,@disableTransformationForBaby	; $6265
	jr ++			; $6267
+
	call _linkApplyTileTypes		; $6269
	ld a,(wLinkSwimmingState)		; $626c
	or a			; $626f
	jr nz,@resetIDToNormal	; $6270

	callab bank6.getTransformedLinkID		; $6272
	ld e,SpecialObject.id		; $627a
	ld a,(de)		; $627c
	cp b			; $627d
	ld a,b			; $627e
	jr nz,@resetIDToNormal	; $627f
++
	call _specialObjectUpdateAdjacentWallsBitset		; $6281
	call _linkUpdateKnockback		; $6284
	call updateLinkSpeed_standard		; $6287

	; Halve speed if he's in baby form
	ld h,d			; $628a
	ld l,SpecialObject.id		; $628b
	ld a,(hl)		; $628d
	cp SPECIALOBJECTID_LINK_AS_BABY			; $628e
	jr nz,+			; $6290
	ld l,SpecialObject.speed		; $6292
	srl (hl)		; $6294
+
	ld l,SpecialObject.knockbackCounter		; $6296
	ld a,(hl)		; $6298
	or a			; $6299
	jr nz,@animateIfPegasusSeedsActive	; $629a

	ld l,SpecialObject.collisionType		; $629c
	set 7,(hl)		; $629e

	; Update gravity
	ld l,SpecialObject.zh		; $62a0
	bit 7,(hl)		; $62a2
	jr z,++			; $62a4
	ld c,$20		; $62a6
	call objectUpdateSpeedZ_paramC		; $62a8
	jr nz,++		; $62ab
	xor a			; $62ad
	ld (wLinkInAir),a		; $62ae
++
	ld a,(wcc95)		; $62b1
	ld b,a			; $62b4
	ld l,SpecialObject.angle		; $62b5
	ld a,(wLinkAngle)		; $62b7
	ld (hl),a		; $62ba

	; Set carry flag if [wLinkAngle] == $ff or Link is in a spinner
	or b			; $62bb
	rlca			; $62bc
	jr c,@animateIfPegasusSeedsActive	; $62bd

	ld l,SpecialObject.id		; $62bf
	ld a,(hl)		; $62c1
	cp SPECIALOBJECTID_LINK_AS_BABY			; $62c2
	jr nz,++		; $62c4
	ld l,SpecialObject.animParameter		; $62c6
	bit 7,(hl)		; $62c8
	res 7,(hl)		; $62ca
	ld a,SND_SPLASH		; $62cc
	call nz,playSound		; $62ce
++
	ld a,(wLinkTurningDisabled)		; $62d1
	or a			; $62d4
	call z,updateLinkDirectionFromAngle		; $62d5
	ld a,(wActiveTileType)		; $62d8
	cp TILETYPE_STUMP			; $62db
	jr z,@animate			; $62dd
	ld a,(wLinkImmobilized)		; $62df
	or a			; $62e2
	jr nz,@animate		; $62e3
	call specialObjectUpdatePosition		; $62e5

@animate:
	; Check whether to create the pegasus seed effect
	call checkPegasusSeedCounter		; $62e8
	jr z,++			; $62eb
	rlca			; $62ed
	jr nc,++		; $62ee
	call getFreeInteractionSlot		; $62f0
	jr nz,++		; $62f3
	ld (hl),INTERACID_FALLDOWNHOLE		; $62f5
	inc l			; $62f7
	inc (hl)		; $62f8
	ld bc,$0500		; $62f9
	call objectCopyPositionWithOffset		; $62fc
++
	ld e,SpecialObject.animMode		; $62ff
	ld a,(de)		; $6301
	or a			; $6302
	jp z,specialObjectAnimate		; $6303
	xor a			; $6306
	jp specialObjectSetAnimation		; $6307

@animateIfPegasusSeedsActive:
	call checkPegasusSeedCounter		; $630a
	jr nz,@animate		; $630d
	xor a			; $630f
	jp specialObjectSetAnimation		; $6310


;;
; @addr{6313}
specialObjectCode_linkRidingAnimal:
	ld e,SpecialObject.state		; $6313
	ld a,(de)		; $6315
	rst_jumpTable			; $6316
	.dw @state0
	.dw @state1

@state0:
	call dropLinkHeldItem		; $631b
	call clearAllParentItems		; $631e
	call specialObjectSetOamVariables		; $6321

	ld h,d			; $6324
	ld l,SpecialObject.state		; $6325
	inc (hl)		; $6327
	ld l,SpecialObject.collisionType		; $6328
	ld a, $80 | ITEMCOLLISION_LINK		; $632a
	ldi (hl),a		; $632c

	inc l			; $632d
	ld a,$06		; $632e
	ldi (hl),a ; [collisionRadiusY] = $06
	ldi (hl),a ; [collisionRadiusX] = $06
	call @readCompanionAnimParameter		; $6332
	jp objectSetVisiblec1		; $6335

	; Unused code? (Revert back to ordinary Link code)
	lda SPECIALOBJECTID_LINK			; $6338
	call setLinkIDOverride		; $6339
	ld b,INTERACID_GREENPOOF		; $633c
	jp objectCreateInteractionWithSubid00		; $633e

@state1:
	ld a,(wPaletteThread_mode)		; $6341
	or a			; $6344
	ret nz			; $6345

	call updateLinkDamageTaken		; $6346

	call retIfTextIsActive		; $6349
	ld a,(wScrollMode)		; $634c
	and $0e			; $634f
	ret nz			; $6351

	ld a,(wDisabledObjects)		; $6352
	rlca			; $6355
	ret c			; $6356
	call _linkUpdateKnockback		; $6357

;;
; Copies companion's animParameter & $3f to var31.
; @addr{635a}
@readCompanionAnimParameter:
	ld hl,w1Companion.animParameter		; $635a
	ld a,(hl)		; $635d
	and $3f			; $635e
	ld e,SpecialObject.var31		; $6360
	ld (de),a		; $6362
	ret			; $6363


;;
; Update a minecart object.
; @addr{6364}
_specialObjectCode_minecart:
	; Jump to code in bank 6 to handle it
	jpab bank6.specialObjectCode_minecart		; $6364




; Maple variables:
;
;  var03:  gets set to 0 (rarer item drops) or 1 (standard item drops) when spawning.
;
;  relatedObj1: pointer to a bomb object (maple can suck one up when on her vacuum).
;  relatedObj2: At first, this is a pointer to data in the rom determining Maple's path?
;               When collecting items, this is a pointer to the item she's collecting.
;
;  damage: maple's vehicle (0=broom, 1=vacuum, 2=ufo)
;  health: the value of the loot that Maple's gotten
;  var2a:  the value of the loot that Link's gotten
;
;  invincibilityCounter: nonzero if maple's dropped a heart piece
;  knockbackAngle: actually stores bitmask for item indices 1-4; a bit is set if the item
;                  has been spawned. These items can't spawn more than once.
;  stunCounter: the index of the item that Maple is picking up
;
;  var3a: When recoiling, this gets copied to speedZ?
;         During item collection, this is the delay for maple turning?
;  var3b: Counter until Maple can update her angle by a unit. (Length determined by var3a)
;  var3c: Counter until Maple's Z speed reverses (when floating up and down)
;  var3d: Angle that she's turning toward
;  var3f: Value from 0-2 which determines how much variation there is in maple's movement
;         path? (The variation in her movement increases as she's encountered more often.)
;
;
;;
; @addr{636c}
_specialObjectCode_maple:
	call _companionRetIfInactiveWithoutStateCheck		; $636c
	ld e,SpecialObject.state		; $636f
	ld a,(de)		; $6371
	rst_jumpTable			; $6372
	.dw _mapleState0
	.dw _mapleState1
	.dw _mapleState2
	.dw _mapleState3
	.dw _mapleState4
	.dw _mapleState5
	.dw _mapleState6
	.dw _mapleState7
	.dw _mapleState8
	.dw _mapleState9
	.dw _mapleStateA
	.dw _mapleStateB
	.dw _mapleStateC

;;
; State 0: Initialization
; @addr{638d}
_mapleState0:
	xor a			; $638d
	ld (wcc85),a		; $638e
	call specialObjectSetOamVariables		; $6391

	; Set 'c' to be the amount of variation in maple's path (higher the more she's
	; been encountered)
	ld c,$02		; $6394
	ld a,(wMapleState)		; $6396
	and $0f			; $6399
	cp $0f			; $639b
	jr z,+			; $639d
	dec c			; $639f
	cp $08			; $63a0
	jr nc,+			; $63a2
	dec c			; $63a4
+
	ld a,c			; $63a5
	ld e,SpecialObject.var3f		; $63a6
	ld (de),a		; $63a8

	; Determine maple's vehicle (written to "damage" variable); broom/vacuum in normal
	; game, or broom/ufo in linked game.
	or a			; $63a9
	jr z,+			; $63aa
	ld a,$01		; $63ac
+
	ld e,SpecialObject.damage		; $63ae
	ld (de),a		; $63b0
	or a			; $63b1
	jr z,++			; $63b2
	call checkIsLinkedGame		; $63b4
	jr z,++			; $63b7
	ld a,$02		; $63b9
	ld (de),a		; $63bb
++
	call itemIncState		; $63bc

	ld l,SpecialObject.yh		; $63bf
	ld a,$10		; $63c1
	ldi (hl),a  ; [yh] = $10
	inc l			; $63c4
	ld (hl),$b8 ; [xh] = $b8

	ld l,SpecialObject.zh		; $63c7
	ld a,$88		; $63c9
	ldi (hl),a		; $63cb

	ld (hl),SPEED_140 ; [speed] = SPEED_140

	ld l,SpecialObject.collisionRadiusY		; $63ce
	ld a,$08		; $63d0
	ldi (hl),a		; $63d2
	ld (hl),a		; $63d3

	ld l,SpecialObject.knockbackCounter		; $63d4
	ld (hl),$03		; $63d6

	; Decide on Maple's drop pattern.
	; If [var03] = 0, it's a rare item pattern (1/8 times).
	; If [var03] = 1, it's a standard pattern  (7/8 times).
	call getRandomNumber		; $63d8
	and $07			; $63db
	jr z,+			; $63dd
	ld a,$01		; $63df
+
	ld e,SpecialObject.var03		; $63e1
	ld (de),a		; $63e3

	ld hl,_mapleShadowPathsTable		; $63e4
	rst_addDoubleIndex			; $63e7
	ldi a,(hl)		; $63e8
	ld h,(hl)		; $63e9
	ld l,a			; $63ea

	ld e,SpecialObject.var3a		; $63eb
	ldi a,(hl)		; $63ed
	ld (de),a		; $63ee
	inc e			; $63ef
	ld (de),a		; $63f0
	ld e,SpecialObject.relatedObj2		; $63f1
	ld a,l			; $63f3
	ld (de),a		; $63f4
	inc e			; $63f5
	ld a,h			; $63f6
	ld (de),a		; $63f7

	ld a,(hl)		; $63f8
	ld e,SpecialObject.angle		; $63f9
	ld (de),a		; $63fb
	call _mapleDecideNextAngle		; $63fc
	call objectSetVisiblec0		; $63ff
	ld a,$19		; $6402
	jp specialObjectSetAnimation		; $6404

;;
; @addr{6407}
_mapleState1:
	call _mapleState4		; $6407
	ret nz			; $640a
	ld a,(wMenuDisabled)		; $640b
	or a			; $640e
	jp nz,_mapleDeleteSelf		; $640f

	ld a,MUS_MAPLE_THEME		; $6412
	ld (wActiveMusic),a		; $6414
	jp playSound		; $6417

;;
; State 4: lying on ground after being hit
; @addr{641a}
_mapleState4:
	ld hl,w1Companion.knockbackCounter		; $641a
	dec (hl)		; $641d
	ret nz			; $641e
	call itemIncState		; $641f
	xor a			; $6422
	ret			; $6423

;;
; State 2: flying around (above screen or otherwise) before being hit
; @addr{6424}
_mapleState2:
	ld a,(wTextIsActive)		; $6424
	or a			; $6427
	jr nz,@animate		; $6428
	ld hl,w1Companion.counter2		; $642a
	ld a,(hl)		; $642d
	or a			; $642e
	jr z,+			; $642f
	dec (hl)		; $6431
	ret			; $6432
+
	ld l,SpecialObject.var3d		; $6433
	ld a,(hl)		; $6435
	ld l,SpecialObject.angle		; $6436
	cp (hl)			; $6438
	jr z,+			; $6439
	call _mapleUpdateAngle		; $643b
	jr ++			; $643e
+
	ld l,SpecialObject.counter1		; $6440
	dec (hl)		; $6442
	call z,_mapleDecideNextAngle		; $6443
	jr z,@label_05_262	; $6446
++
	call objectApplySpeed		; $6448
	ld e,SpecialObject.var3e		; $644b
	ld a,(de)		; $644d
	or a			; $644e
	ret z			; $644f

	call checkLinkVulnerableAndIDZero		; $6450
	jr nc,@animate		; $6453
	call objectCheckCollidedWithLink_ignoreZ		; $6455
	jr c,_mapleCollideWithLink	; $6458
@animate:
	call _mapleUpdateOscillation		; $645a
	jp specialObjectAnimate		; $645d

@label_05_262:
	ld hl,w1Companion.var3e		; $6460
	ld a,(hl)		; $6463
	or a			; $6464
	jp nz,_mapleDeleteSelf		; $6465

	inc (hl)		; $6468
	call _mapleInitZPositionAndSpeed		; $6469

	ld l,SpecialObject.speed		; $646c
	ld (hl),SPEED_200		; $646e
	ld l,SpecialObject.counter2		; $6470
	ld (hl),$3c		; $6472

	ld e,SpecialObject.var3f		; $6474
	ld a,(de)		; $6476

	ld e,$03		; $6477
	or a			; $6479
	jr z,++			; $647a
	set 2,e			; $647c
	cp $01			; $647e
	jr z,++			; $6480
	set 3,e			; $6482
++
	call getRandomNumber		; $6484
	and e			; $6487
	ld hl,_mapleMovementPatternIndices		; $6488
	rst_addAToHl			; $648b
	ld a,(hl)		; $648c
	ld hl,_mapleMovementPatternTable		; $648d
	rst_addDoubleIndex			; $6490

	ld e,SpecialObject.yh		; $6491
	ldi a,(hl)		; $6493
	ld h,(hl)		; $6494
	ld l,a			; $6495

	ldi a,(hl)		; $6496
	ld (de),a		; $6497
	ld e,SpecialObject.xh		; $6498
	ldi a,(hl)		; $649a
	ld (de),a		; $649b

	ldi a,(hl)		; $649c
	ld e,SpecialObject.var3a		; $649d
	ld (de),a		; $649f
	inc e			; $64a0
	ld (de),a		; $64a1

	ld a,(hl)		; $64a2
	ld e,SpecialObject.angle		; $64a3
	ld (de),a		; $64a5

	ld e,SpecialObject.relatedObj2		; $64a6
	ld a,l			; $64a8
	ld (de),a		; $64a9
	inc e			; $64aa
	ld a,h			; $64ab
	ld (de),a		; $64ac

;;
; Updates var3d with the angle Maple should be turning toward next, and counter1 with the
; length of time she should stay in that angle.
;
; @param[out]	zflag	z if we've reached the end of the "angle data".
; @addr{64ad}
_mapleDecideNextAngle:
	ld hl,w1Companion.relatedObj2		; $64ad
	ldi a,(hl)		; $64b0
	ld h,(hl)		; $64b1
	ld l,a			; $64b2

	ld e,SpecialObject.var3d		; $64b3
	ldi a,(hl)		; $64b5
	ld (de),a		; $64b6
	ld c,a			; $64b7
	ld e,SpecialObject.counter1		; $64b8
	ldi a,(hl)		; $64ba
	ld (de),a		; $64bb

	ld e,SpecialObject.relatedObj2		; $64bc
	ld a,l			; $64be
	ld (de),a		; $64bf
	inc e			; $64c0
	ld a,h			; $64c1
	ld (de),a		; $64c2

	ld a,c			; $64c3
	cp $ff			; $64c4
	ret z			; $64c6
	jp _mapleDecideAnimation		; $64c7

;;
; Handles stuff when Maple collides with Link. (Sets knockback for both, sets Maple's
; animation, drops items, and goes to state 3.)
;
; @addr{64ca}
_mapleCollideWithLink:
	call dropLinkHeldItem		; $64ca
	call _mapleSpawnItemDrops		; $64cd

	ld a,$01		; $64d0
	ld (wDisableScreenTransitions),a		; $64d2
	ld (wMenuDisabled),a		; $64d5
	ld a,$3c		; $64d8
	ld (wInstrumentsDisabledCounter),a		; $64da
	ld e,SpecialObject.counter1		; $64dd
	xor a			; $64df
	ld (de),a		; $64e0

	; Set knockback direction and angle for Link and Maple
	call _mapleGetCardinalAngleTowardLink		; $64e1
	ld b,a			; $64e4
	ld hl,w1Link.knockbackCounter		; $64e5
	ld (hl),$18		; $64e8

	ld e,SpecialObject.angle		; $64ea
	ld l,<w1Link.knockbackAngle		; $64ec
	ld (hl),a		; $64ee
	xor $10			; $64ef
	ld (de),a		; $64f1

	; Determine maple's knockback speed
	ld e,SpecialObject.damage		; $64f2
	ld a,(de)		; $64f4
	ld hl,@speeds		; $64f5
	rst_addAToHl			; $64f8
	ld a,(hl)		; $64f9
	ld e,SpecialObject.speed		; $64fa
	ld (de),a		; $64fc

	ld e,SpecialObject.var3a		; $64fd
	ld a,$fc		; $64ff
	ld (de),a		; $6501
	ld a,$0f		; $6502
	ld (wScreenShakeCounterX),a		; $6504

	ld e,SpecialObject.state		; $6507
	ld a,$03		; $6509
	ld (de),a		; $650b

	; Determine animation? ('b' currently holds the angle toward link.)
	ld a,b			; $650c
	add $04			; $650d
	add a			; $650f
	add a			; $6510
	swap a			; $6511
	and $01			; $6513
	xor $01			; $6515
	add $10			; $6517
	ld b,a			; $6519
	ld e,SpecialObject.damage		; $651a
	ld a,(de)		; $651c
	add a			; $651d
	add b			; $651e
	call specialObjectSetAnimation		; $651f

	ld a,SND_SCENT_SEED		; $6522
	jp playSound		; $6524

@speeds:
	.db SPEED_100
	.db SPEED_140
	.db SPEED_180

;;
; State 3: recoiling after being hit
; @addr{652a}
_mapleState3:
	ld a,(w1Link.knockbackCounter)		; $652a
	or a			; $652d
	jr nz,+			; $652e
	ld a,$01		; $6530
	ld (wDisabledObjects),a		; $6532
+
	ld h,d			; $6535
	ld e,SpecialObject.var3a		; $6536
	ld a,(de)		; $6538
	or a			; $6539
	jr z,@animate		; $653a

	ld e,SpecialObject.zh		; $653c
	ld a,(de)		; $653e
	or a			; $653f
	jr nz,@applyKnockback	; $6540

	; Update speedZ
	ld e,SpecialObject.var3a		; $6542
	ld l,SpecialObject.speedZ+1		; $6544
	ld a,(de)		; $6546
	inc a			; $6547
	ld (de),a		; $6548
	ld (hl),a		; $6549

@applyKnockback:
	ld c,$40		; $654a
	call objectUpdateSpeedZ_paramC		; $654c
	call objectApplySpeed		; $654f
	call _mapleKeepInBounds		; $6552
	call objectGetTileCollisions		; $6555
	ret z			; $6558
	jr @counteractWallSpeed		; $6559

@animate:
	ld a,(wDisabledObjects)		; $655b
	or a			; $655e
	ret z			; $655f

	; Wait until the animation gives the signal to go to state 4
	ld e,SpecialObject.animParameter		; $6560
	ld a,(de)		; $6562
	cp $ff			; $6563
	jp nz,specialObjectAnimate		; $6565
	ld e,SpecialObject.knockbackCounter		; $6568
	ld a,$78		; $656a
	ld (de),a		; $656c
	ld e,SpecialObject.state		; $656d
	ld a,$04		; $656f
	ld (de),a		; $6571
	ret			; $6572

; If maple's hitting a wall, counteract the speed being applied.
@counteractWallSpeed:
	ld e,SpecialObject.angle		; $6573
	call convertAngleDeToDirection		; $6575
	ld hl,@offsets		; $6578
	rst_addDoubleIndex			; $657b
	ld e,SpecialObject.yh		; $657c
	ld a,(de)		; $657e
	add (hl)		; $657f
	ld b,a			; $6580
	inc hl			; $6581
	ld e,SpecialObject.xh		; $6582
	ld a,(de)		; $6584
	add (hl)		; $6585
	ld c,a			; $6586

	ld h,d			; $6587
	ld l,SpecialObject.yh		; $6588
	ld (hl),b		; $658a
	ld l,SpecialObject.xh		; $658b
	ld (hl),c		; $658d
	ret			; $658e

@offsets:
	.db $04 $00 ; DIR_UP
	.db $00 $fc ; DIR_RIGHT
	.db $fc $00 ; DIR_DOWN
	.db $00 $04 ; DIR_LEFT

;;
; State 5: floating back up after being hit
; @addr{6597}
_mapleState5:
	ld hl,w1Companion.counter1		; $6597
	ld a,(hl)		; $659a
	or a			; $659b
	jr nz,@floatUp		; $659c

; counter1 has reached 0

	inc (hl)		; $659e
	call _mapleInitZPositionAndSpeed		; $659f
	ld l,SpecialObject.zh		; $65a2
	ld (hl),$ff		; $65a4
	ld a,$01		; $65a6
	ld l,SpecialObject.var3a		; $65a8
	ldi (hl),a		; $65aa
	ld (hl),a  ; [var3b] = $01

	; Reverse direction (to face Link)
	ld e,SpecialObject.angle		; $65ac
	ld a,(de)		; $65ae
	xor $10			; $65af
	ld (de),a		; $65b1
	call _mapleDecideAnimation		; $65b2

@floatUp:
	ld e,SpecialObject.damage		; $65b5
	ld a,(de)		; $65b7
	ld c,a			; $65b8

	; Rise one pixel per frame
	ld e,SpecialObject.zh		; $65b9
	ld a,(de)		; $65bb
	dec a			; $65bc
	ld (de),a		; $65bd
	cp $f9			; $65be
	ret nc			; $65c0

	; If on the ufo or vacuum cleaner, rise 16 pixels higher
	ld a,c			; $65c1
	or a			; $65c2
	jr z,@finishedFloatingUp			; $65c3
	ld a,(de)		; $65c5
	cp $e9			; $65c6
	ret nc			; $65c8

@finishedFloatingUp:
	ld a,(wMapleState)		; $65c9
	bit 4,a			; $65cc
	jr nz,@exchangeTouchingBook	; $65ce

	ld l,SpecialObject.state		; $65d0
	ld (hl),$06		; $65d2

	; Set collision radius variables
	ld e,SpecialObject.damage		; $65d4
	ld a,(de)		; $65d6
	ld hl,@collisionRadii		; $65d7
	rst_addDoubleIndex			; $65da
	ld e,SpecialObject.collisionRadiusY		; $65db
	ldi a,(hl)		; $65dd
	ld (de),a		; $65de
	inc e			; $65df
	ld a,(hl)		; $65e0
	ld (de),a		; $65e1

	; Check if this is the past. She says something about coming through a "weird
	; tunnel", which is probably their justification for her being in the past? She
	; only says this the first time she's encountered in the past.
	ld a,(wActiveGroup)		; $65e2
	dec a			; $65e5
	jr nz,@normalEncounter	; $65e6

	ld a,(wMapleState)		; $65e8
	and $0f			; $65eb
	ld bc,TX_0712		; $65ed
	jr z,++			; $65f0

	ld a,GLOBALFLAG_44		; $65f2
	call checkGlobalFlag		; $65f4
	ld bc,TX_0713		; $65f7
	jr nz,@normalEncounter	; $65fa
++
	ld a,GLOBALFLAG_44		; $65fc
	call setGlobalFlag		; $65fe
	jr @showText		; $6601

@normalEncounter:
	; If this is the first encounter, show TX_0700
	ld a,(wMapleState)		; $6603
	and $0f			; $6606
	ld bc,TX_0700		; $6608
	jr z,@showText		; $660b

	; If we've encountered maple 5 times or more, show TX_0705
	ld c,<TX_0705		; $660d
	cp $05			; $660f
	jr nc,@showText		; $6611

	; Otherwise, pick a random text index from TX_0701-TX_0704
	call getRandomNumber		; $6613
	and $03			; $6616
	ld hl,@normalEncounterText		; $6618
	rst_addAToHl			; $661b
	ld c,(hl)		; $661c
@showText:
	call showText		; $661d
	xor a			; $6620
	ld (wDisabledObjects),a		; $6621
	ld (wMenuDisabled),a		; $6624
	jp _mapleDecideItemToCollectAndUpdateTargetAngle		; $6627

@exchangeTouchingBook:
	ld a,$0b		; $662a
	ld l,SpecialObject.state		; $662c
	ld (hl),a		; $662e

	ld l,SpecialObject.direction		; $662f
	ldi (hl),a  ; [direction] = $0b (?)
	ld (hl),$ff ; [angle] = $ff

	ld l,SpecialObject.speed		; $6634
	ld (hl),SPEED_100		; $6636

	ld bc,TX_070d		; $6638
	jp showText		; $663b


; One of these pieces of text is chosen at random when bumping into maple between the 2nd
; and 4th encounters (inclusive).
@normalEncounterText:
	.db <TX_0701 <TX_0702 <TX_0703 <TX_0704


; Values for collisionRadiusY/X for maple's various forms.
@collisionRadii:
	.db $02 $02 ; broom
	.db $02 $02 ; vacuum cleaner
	.db $04 $04 ; ufo


;;
; Updates maple's Z position and speedZ for oscillation (but not if she's in a ufo?)
; @addr{6648}
_mapleUpdateOscillation:
	ld h,d			; $6648
	ld e,SpecialObject.damage		; $6649
	ld a,(de)		; $664b
	cp $02			; $664c
	ret z			; $664e

	ld c,$00		; $664f
	call objectUpdateSpeedZ_paramC		; $6651

	; Wait a certain number of frames before inverting speedZ
	ld l,SpecialObject.var3c		; $6654
	ld a,(hl)		; $6656
	dec a			; $6657
	ld (hl),a		; $6658
	ret nz			; $6659

	ld a,$16		; $665a
	ld (hl),a		; $665c

	; Invert speedZ
	ld l,SpecialObject.speedZ		; $665d
	ld a,(hl)		; $665f
	cpl			; $6660
	inc a			; $6661
	ldi (hl),a		; $6662
	ld a,(hl)		; $6663
	cpl			; $6664
	ld (hl),a		; $6665
	ret			; $6666

;;
; @addr{6667}
_mapleUpdateAngle:
	ld hl,w1Companion.var3b		; $6667
	dec (hl)		; $666a
	ret nz			; $666b

	ld e,SpecialObject.var3a		; $666c
	ld a,(de)		; $666e
	ld (hl),a		; $666f
	ld l,SpecialObject.angle		; $6670
	ld e,SpecialObject.var3d		; $6672
	ld l,(hl)		; $6674
	ldh (<hFF8B),a	; $6675
	ld a,(de)		; $6677
	call objectNudgeAngleTowards		; $6678

;;
; @param[out]	zflag
; @addr{667b}
_mapleDecideAnimation:
	ld e,SpecialObject.var3e		; $667b
	ld a,(de)		; $667d
	or a			; $667e
	jr z,@ret		; $667f

	ld h,d			; $6681
	ld l,SpecialObject.angle		; $6682
	ld a,(hl)		; $6684
	call convertAngleToDirection		; $6685
	add $04			; $6688
	ld b,a			; $668a
	ld e,SpecialObject.damage		; $668b
	ld a,(de)		; $668d
	add a			; $668e
	add a			; $668f
	add b			; $6690
	ld l,SpecialObject.animMode		; $6691
	cp (hl)			; $6693
	call nz,specialObjectSetAnimation		; $6694
@ret:
	or d			; $6697
	ret			; $6698


;;
; State 6: talking to Link / moving toward an item
; @addr{6699}
_mapleState6:
	call _mapleUpdateOscillation		; $6699
	call specialObjectAnimate		; $669c
	call retIfTextIsActive		; $669f

	ld a,(wActiveMusic)		; $66a2
	cp MUS_MAPLE_GAME			; $66a5
	jr z,++			; $66a7
	ld a,MUS_MAPLE_GAME		; $66a9
	ld (wActiveMusic),a		; $66ab
	call playSound		; $66ae
++
	; Check whether to update Maple's angle toward an item
	ld l,SpecialObject.var3d		; $66b1
	ld a,(hl)		; $66b3
	ld l,SpecialObject.angle		; $66b4
	cp (hl)			; $66b6
	call nz,_mapleUpdateAngle		; $66b7

	call _mapleDecideItemToCollectAndUpdateTargetAngle		; $66ba
	call objectApplySpeed		; $66bd

	; Check if Maple's touching the target object
	ld e,SpecialObject.relatedObj2		; $66c0
	ld a,(de)		; $66c2
	ld h,a			; $66c3
	inc e			; $66c4
	ld a,(de)		; $66c5
	ld l,a			; $66c6
	call checkObjectsCollided		; $66c7
	jp nc,_mapleKeepInBounds		; $66ca

	; Set the item being collected to state 4
	ld e,SpecialObject.relatedObj2		; $66cd
	ld a,(de)		; $66cf
	ld h,a			; $66d0
	inc e			; $66d1
	ld a,(de)		; $66d2
	or Object.state			; $66d3
	ld l,a			; $66d5
	ld (hl),$04 ; [Part.state] = $04
	inc l			; $66d8
	ld (hl),$00 ; [Part.state2] = $00

	; Read the item's var03 to determine how long it takes to collect.
	ld a,(de)		; $66db
	or Object.var03			; $66dc
	ld l,a			; $66de
	ld a,(hl)		; $66df
	ld e,SpecialObject.stunCounter		; $66e0
	ld (de),a		; $66e2

	; Go to state 7
	ld e,SpecialObject.state		; $66e3
	ld a,$07		; $66e5
	ld (de),a		; $66e7

	; If maple's on her broom, she'll only do her sweeping animation if she's not in
	; a wall - otherwise, she'll just sort of sit there?
	ld e,SpecialObject.damage		; $66e8
	ld a,(de)		; $66ea
	or a			; $66eb
	call z,_mapleFunc_6c27		; $66ec
	ret z			; $66ef

	add $16			; $66f0
	jp specialObjectSetAnimation		; $66f2


;;
; State 7: picking up an item
; @addr{66f5}
_mapleState7:
	call specialObjectAnimate		; $66f5

	ld e,SpecialObject.damage		; $66f8
	ld a,(de)		; $66fa
	cp $01			; $66fb
	jp nz,@anyVehicle		; $66fd

; Maple is on the vacuum.
;
; The next bit of code deals with pulling a bomb object (an actual explosive one) toward
; maple. When it touches her, she will be momentarily stunned.

	; Adjust collisionRadiusY/X for the purpose of checking if a bomb object is close
	; enough to be sucked toward the vacuum.
	ld e,SpecialObject.collisionRadiusY		; $6700
	ld a,$08		; $6702
	ld (de),a		; $6704
	inc e			; $6705
	ld a,$0a		; $6706
	ld (de),a		; $6708

	; Check if there's an actual bomb (one that can explode) on-screen.
	call _mapleFindUnexplodedBomb		; $6709
	jr nz,+			; $670c
	call checkObjectsCollided		; $670e
	jr c,@explosiveBombNearMaple	; $6711
+
	call _mapleFindNextUnexplodedBomb		; $6713
	jr nz,@updateItemBeingCollected	; $6716
	call checkObjectsCollided		; $6718
	jr c,@explosiveBombNearMaple	; $671b

	ld e,SpecialObject.relatedObj1		; $671d
	xor a			; $671f
	ld (de),a		; $6720
	inc e			; $6721
	ld (de),a		; $6722
	jr @updateItemBeingCollected		; $6723

@explosiveBombNearMaple:
	; Constantly signal the bomb to reset its animation so it doesn't explode
	ld l,SpecialObject.var2f		; $6725
	set 7,(hl)		; $6727

	; Update the bomb's X and Y positions toward maple, and check if they've reached
	; her.
	ld b,$00		; $6729
	ld l,Item.yh		; $672b
	ld e,l			; $672d
	ld a,(de)		; $672e
	cp (hl)			; $672f
	jr z,@updateBombX	; $6730
	inc b			; $6732
	jr c,+			; $6733
	inc (hl)		; $6735
	jr @updateBombX		; $6736
+
	dec (hl)		; $6738

@updateBombX:
	ld l,Item.xh		; $6739
	ld e,l			; $673b
	ld a,(de)		; $673c
	cp (hl)			; $673d
	jr z,++			; $673e
	inc b			; $6740
	jr c,+			; $6741
	inc (hl)		; $6743
	jr ++			; $6744
+
	dec (hl)		; $6746
++
	ld a,b			; $6747
	or a			; $6748
	jr nz,@updateItemBeingCollected	; $6749

; The bomb has reached maple's Y/X position. Start pulling it up.

	; [Item.z] -= $0040
	ld l,Item.z		; $674b
	ld a,(hl)		; $674d
	sub $40			; $674e
	ldi (hl),a		; $6750
	ld a,(hl)		; $6751
	sbc $00			; $6752
	ld (hl),a		; $6754

	cp $f8			; $6755
	jr nz,@updateItemBeingCollected	; $6757

; The bomb has risen high enough. Maple will now be stunned.

	; Signal the bomb to delete itself
	ld l,SpecialObject.var2f		; $6759
	set 5,(hl)		; $675b

	ld a,$1a		; $675d
	call specialObjectSetAnimation		; $675f

	; Go to state 8
	ld h,d			; $6762
	ld l,SpecialObject.state		; $6763
	ld (hl),$08		; $6765
	inc l			; $6767
	ld (hl),$00 ; [state2] = 0

	ld l,SpecialObject.counter2		; $676a
	ld (hl),$20		; $676c

	ld e,SpecialObject.relatedObj2		; $676e
	ld a,(de)		; $6770
	ld h,a			; $6771
	inc e			; $6772
	ld a,(de)		; $6773
	ld l,a			; $6774
	ld a,(hl)		; $6775
	or a			; $6776
	jr z,@updateItemBeingCollected	; $6777

	; Release the other item Maple was pulling up
	ld a,(de)		; $6779
	add Object.state			; $677a
	ld l,a			; $677c
	ld (hl),$01		; $677d

	add Object.angle-Object.state			; $677f
	ld l,a			; $6781
	ld (hl),$80		; $6782

	xor a			; $6784
	ld e,SpecialObject.relatedObj2		; $6785
	ld (de),a		; $6787

; Done with bomb-pulling code. Below is standard vacuum cleaner code.

@updateItemBeingCollected:
	; Fix collision radius after the above code changed it for bomb detection
	ld e,SpecialObject.collisionRadiusY		; $6788
	ld a,$02		; $678a
	ld (de),a		; $678c
	inc e			; $678d
	ld a,$02		; $678e
	ld (de),a		; $6790

; Vacuum-exclusive code is done.

@anyVehicle:
	ld e,SpecialObject.relatedObj2		; $6791
	ld a,(de)		; $6793
	or a			; $6794
	ret z			; $6795
	ld h,a			; $6796
	inc e			; $6797
	ld a,(de)		; $6798
	ld l,a			; $6799

	ldi a,(hl)		; $679a
	or a			; $679b
	jr z,@itemCollected	; $679c

	; Check bit 7 of item's subid?
	inc l			; $679e
	bit 7,(hl)		; $679f
	jr nz,@itemCollected	; $67a1

	; Check if they've collided (the part object writes to maple's "damageToApply"?)
	ld e,SpecialObject.damageToApply		; $67a3
	ld a,(de)		; $67a5
	or a			; $67a6
	ret z			; $67a7

	ld e,SpecialObject.relatedObj2		; $67a8
	ld a,(de)		; $67aa
	ld h,a			; $67ab
	ld l,Part.var03		; $67ac
	ld a,$80		; $67ae
	ld (hl),a		; $67b0

	xor a			; $67b1
	ld l,Part.invincibilityCounter		; $67b2
	ld (hl),a		; $67b4
	ld l,Part.collisionType		; $67b5
	ld (hl),a		; $67b7

	ld e,SpecialObject.stunCounter		; $67b8
	ld a,(de)		; $67ba
	ld hl,_mapleItemValues		; $67bb
	rst_addAToHl			; $67be
	ld a,$0e		; $67bf
	ld (de),a		; $67c1

	ld e,SpecialObject.health		; $67c2
	ld a,(de)		; $67c4
	ld b,a			; $67c5
	ld a,(hl)		; $67c6
	add b			; $67c7
	ld (de),a		; $67c8

	; If maple's on a broom, go to state $0a (dusting animation); otherwise go back to
	; state $06 (start heading toward the next item)
	ld e,SpecialObject.damage		; $67c9
	ld a,(de)		; $67cb
	or a			; $67cc
	jr nz,@itemCollected	; $67cd

	ld a,$0a		; $67cf
	jr @setState		; $67d1

@itemCollected:
	; Return if Maple's still pulling up a real bomb
	ld h,d			; $67d3
	ld l,SpecialObject.relatedObj1		; $67d4
	ldi a,(hl)		; $67d6
	or (hl)			; $67d7
	ret nz			; $67d8

	ld a,$06		; $67d9
@setState:
	ld e,SpecialObject.state		; $67db
	ld (de),a		; $67dd

	; Update direction with target direction. (I don't think this has been updated? So
	; she'll still be moving in the direction she was headed to reach this item.)
	ld e,SpecialObject.var3d		; $67de
	ld a,(de)		; $67e0
	ld e,SpecialObject.angle		; $67e1
	ld (de),a		; $67e3
	ret			; $67e4

;;
; State A: Maple doing her dusting animation after getting an item (broom only)
; @addr{67e5}
_mapleStateA:
	call specialObjectAnimate		; $67e5
	call itemDecCounter2		; $67e8
	ret nz			; $67eb

	ld l,SpecialObject.state		; $67ec
	ld (hl),$06		; $67ee

	; [zh] = [direction]. ???
	ld l,SpecialObject.direction		; $67f0
	ld a,(hl)		; $67f2
	ld l,SpecialObject.zh		; $67f3
	ld (hl),a		; $67f5

	ld a,$04		; $67f6
	jp specialObjectSetAnimation		; $67f8

;;
; State 8: stunned from a bomb
; @addr{67fb}
_mapleState8:
	call specialObjectAnimate		; $67fb
	ld e,SpecialObject.state2		; $67fe
	ld a,(de)		; $6800
	rst_jumpTable			; $6801
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call itemDecCounter2		; $680a
	ret nz			; $680d

	ld l,SpecialObject.state2		; $680e
	ld (hl),$01		; $6810

	ld l,SpecialObject.speedZ		; $6812
	xor a			; $6814
	ldi (hl),a		; $6815
	ld (hl),a		; $6816

	ld a,$13		; $6817
	jp specialObjectSetAnimation		; $6819

@substate1:
	ld c,$40		; $681c
	call objectUpdateSpeedZ_paramC		; $681e
	ret nz			; $6821

	ld l,SpecialObject.state2		; $6822
	ld (hl),$02		; $6824
	ld l,SpecialObject.counter2		; $6826
	ld (hl),$40		; $6828
	ret			; $682a

@substate2:
	call itemDecCounter2		; $682b
	ret nz			; $682e

	ld l,SpecialObject.state2		; $682f
	ld (hl),$03		; $6831
	ld a,$08		; $6833
	jp specialObjectSetAnimation		; $6835

@substate3:
	ld h,d			; $6838
	ld l,SpecialObject.zh		; $6839
	dec (hl)		; $683b
	ld a,(hl)		; $683c
	cp $e9			; $683d
	ret nc			; $683f

	; Go back to state 6 (moving toward next item)
	ld l,SpecialObject.state		; $6840
	ld (hl),$06		; $6842

	ld l,SpecialObject.health		; $6844
	inc (hl)		; $6846

	ld l,SpecialObject.speedZ		; $6847
	ld a,$40		; $6849
	ldi (hl),a		; $684b
	ld (hl),$00		; $684c

	jp _mapleDecideItemToCollectAndUpdateTargetAngle		; $684e

;;
; State 9: flying away after item collection is over
; @addr{6851}
_mapleState9:
	call specialObjectAnimate		; $6851
	ld e,SpecialObject.state2		; $6854
	ld a,(de)		; $6856
	rst_jumpTable			; $6857
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Substate 0: display text
@substate0:
	call retIfTextIsActive		; $685e

	ld a,$3c		; $6861
	ld (wInstrumentsDisabledCounter),a		; $6863

	ld a,$01		; $6866
	ld (de),a ; [state2] = $01

	; "health" is maple's obtained value, and "var2a" is Link's obtained value.

	; Check if either of them got anything
	ld h,d			; $6869
	ld l,SpecialObject.health		; $686a
	ldi a,(hl)		; $686c
	ld b,a			; $686d
	or (hl) ; hl = SpecialObject.var2a
	jr z,@showText		; $686f

	; Check for draw, or maple got more, or link got more
	ld a,(hl)		; $6871
	cp b			; $6872
	ld a,$01		; $6873
	jr z,@showText		; $6875
	inc a			; $6877
	jr c,@showText		; $6878
	inc a			; $687a

@showText:
	ld hl,@textIndices		; $687b
	rst_addDoubleIndex			; $687e
	ld c,(hl)		; $687f
	inc hl			; $6880
	ld b,(hl)		; $6881
	call showText		; $6882

	call _mapleGetCardinalAngleTowardLink		; $6885
	call convertAngleToDirection		; $6888
	add $04			; $688b
	ld b,a			; $688d
	ld e,SpecialObject.damage		; $688e
	ld a,(de)		; $6890
	add a			; $6891
	add a			; $6892
	add b			; $6893
	jp specialObjectSetAnimation		; $6894

@textIndices:
	.dw TX_070c ; 0: nothing obtained by maple or link
	.dw TX_0708 ; 1: draw
	.dw TX_0706 ; 2: maple got more
	.dw TX_0707 ; 3: link got more


; Substate 1: wait until textbox is closed
@substate1:
	call _mapleUpdateOscillation		; $689f
	call retIfTextIsActive		; $68a2

	ld a,$80		; $68a5
	ld (wTextIsActive),a		; $68a7
	ld a,$1f		; $68aa
	ld (wDisabledObjects),a		; $68ac

	ld l,SpecialObject.angle		; $68af
	ld (hl),$18		; $68b1
	ld l,SpecialObject.speed		; $68b3
	ld (hl),SPEED_300		; $68b5

	ld l,SpecialObject.state2		; $68b7
	ld (hl),$02		; $68b9

	ld e,SpecialObject.damage		; $68bb
	ld a,(de)		; $68bd
	add a			; $68be
	add a			; $68bf
	add $07			; $68c0
	jp specialObjectSetAnimation		; $68c2


; Substate 2: moving until off screen
@substate2:
	call _mapleUpdateOscillation		; $68c5
	call objectApplySpeed		; $68c8
	call objectCheckWithinScreenBoundary		; $68cb
	ret c			; $68ce

;;
; Increments meeting counter, deletes maple, etc.
; @addr{68cf}
_mapleEndEncounter:
	xor a			; $68cf
	ld (wTextIsActive),a		; $68d0
	ld (wDisabledObjects),a		; $68d3
	ld (wMenuDisabled),a		; $68d6
	ld (wDisableScreenTransitions),a		; $68d9
	call _mapleIncrementMeetingCounter		; $68dc

	; Fall through

;;
; @addr{68df}
_mapleDeleteSelf:
	ld a,(wActiveMusic2)		; $68df
	ld (wActiveMusic),a		; $68e2
	call playSound		; $68e5
	pop af			; $68e8
	xor a			; $68e9
	ld (wIsMaplePresent),a		; $68ea
	jp itemDelete		; $68ed


;;
; State B: exchanging touching book
; @addr{68f0}
_mapleStateB:
	inc e			; $68f0
	ld a,(de) ; a = [state2]
	or a			; $68f2
	jr nz,@substate1	; $68f3

@substate0:
	call _mapleUpdateOscillation		; $68f5
	ld e,SpecialObject.direction		; $68f8
	ld a,(de)		; $68fa
	bit 7,a			; $68fb
	jr z,+			; $68fd
	and $03			; $68ff
	jr @determineAnimation		; $6901
+
	call objectGetAngleTowardLink		; $6903
	call convertAngleToDirection		; $6906
	ld h,d			; $6909
	ld l,SpecialObject.direction		; $690a
	cp (hl)			; $690c
	ld (hl),a		; $690d
	jr z,@waitForText	; $690e

@determineAnimation:
	add $04			; $6910
	ld b,a			; $6912
	ld e,SpecialObject.damage		; $6913
	ld a,(de)		; $6915
	add a			; $6916
	add a			; $6917
	add b			; $6918
	call specialObjectSetAnimation		; $6919

@waitForText:
	call retIfTextIsActive		; $691c

	ld hl,wMapleState		; $691f
	set 5,(hl)		; $6922
	ld e,SpecialObject.angle		; $6924
	ld a,(de)		; $6926
	rlca			; $6927
	jp nc,objectApplySpeed		; $6928
	ret			; $692b

@substate1:
	dec a			; $692c
	ld (de),a ; [state2] -= 1
	ret nz			; $692e

	ld bc,TX_0711		; $692f
	call showText		; $6932
	ld e,SpecialObject.angle		; $6935
	ld a,$18		; $6937
	ld (de),a		; $6939

	; Go to state $0c
	call itemIncState		; $693a

	ld l,SpecialObject.speed		; $693d
	ld (hl),SPEED_300		; $693f

	; Fall through

;;
; State C: leaving after reading touching book
; @addr{6941}
_mapleStateC:
	call _mapleUpdateOscillation		; $6941
	call retIfTextIsActive		; $6944

	call objectApplySpeed		; $6947

	ld e,SpecialObject.damage		; $694a
	ld a,(de)		; $694c
	add a			; $694d
	add a			; $694e
	add $07			; $694f
	ld hl,wMapleState		; $6951
	bit 4,(hl)		; $6954
	res 4,(hl)		; $6956
	call nz,specialObjectSetAnimation		; $6958

	call objectCheckWithinScreenBoundary		; $695b
	ret c			; $695e
	jp _mapleEndEncounter		; $695f


;;
; Adjusts Maple's X and Y position to keep them in-bounds.
; @addr{6962}
_mapleKeepInBounds:
	ld e,SpecialObject.yh		; $6962
	ld a,(de)		; $6964
	cp $f0			; $6965
	jr c,+			; $6967
	xor a			; $6969
+
	cp $20			; $696a
	jr nc,++		; $696c
	ld a,$20		; $696e
	ld (de),a		; $6970
	jr @checkX		; $6971
++
	cp SCREEN_HEIGHT*16 - 8			; $6973
	jr c,@checkX	; $6975
	ld a,SCREEN_HEIGHT*16 - 8		; $6977
	ld (de),a		; $6979

@checkX:
	ld e,SpecialObject.xh		; $697a
	ld a,(de)		; $697c
	cp $f0			; $697d
	jr c,+			; $697f
	xor a			; $6981
+
	cp $08			; $6982
	jr nc,++		; $6984
	ld a,$08		; $6986
	ld (de),a		; $6988
	jr @ret			; $6989
++
	cp SCREEN_WIDTH*16 - 8			; $698b
	jr c,@ret		; $698d
	ld a,SCREEN_WIDTH*16 - 8		; $698f
	ld (de),a		; $6991
@ret:
	ret			; $6992


;;
; @addr{6993}
_mapleSpawnItemDrops:
	; Check if Link has the touching book
	ld a,TREASURE_TRADEITEM		; $6993
	call checkTreasureObtained		; $6995
	jr nc,@noTradeItem	; $6998
	cp $08			; $699a
	jr nz,@noTradeItem	; $699c

	ld b,INTERACID_TOUCHING_BOOK		; $699e
	call objectCreateInteractionWithSubid00		; $69a0
	ret nz			; $69a3
	ld hl,wMapleState		; $69a4
	set 4,(hl)		; $69a7
	ret			; $69a9

@noTradeItem:
	; Clear health and var2a (the total value of the items Maple and Link have
	; collected, respectively)
	ld e,SpecialObject.var2a		; $69aa
	xor a			; $69ac
	ld (de),a		; $69ad
	ld e,SpecialObject.health		; $69ae
	ld (de),a		; $69b0

; Spawn 5 items from Maple

	ld e,SpecialObject.counter1		; $69b1
	ld a,$05		; $69b3
	ld (de),a		; $69b5

@nextMapleItem:
	ld e,SpecialObject.var03 ; If var03 is 0, rarer items will be dropped
	ld a,(de)		; $69b8
	ld hl,_maple_itemDropDistributionTable		; $69b9
	rst_addDoubleIndex			; $69bc
	ldi a,(hl)		; $69bd
	ld h,(hl)		; $69be
	ld l,a			; $69bf
	call getRandomIndexFromProbabilityDistribution		; $69c0

	ld a,b			; $69c3
	call @checkSpawnItem		; $69c4
	jr c,+			; $69c7
	jr nz,@nextMapleItem	; $69c9
+
	ld e,SpecialObject.counter1		; $69cb
	ld a,(de)		; $69cd
	dec a			; $69ce
	ld (de),a		; $69cf
	jr nz,@nextMapleItem	; $69d0

; Spawn 5 items from Link

	; hFF8C acts as a "drop attempt" counter. It's possible that Link will run out of
	; things to drop, so it'll stop trying eventually.
	ld a,$20		; $69d2
	ldh (<hFF8C),a	; $69d4

	ld e,SpecialObject.counter1		; $69d6
	ld a,$05		; $69d8
	ld (de),a		; $69da

@nextLinkItem:
	ldh a,(<hFF8C)	; $69db
	dec a			; $69dd
	ldh (<hFF8C),a	; $69de
	jr z,@ret	; $69e0

	ld hl,_maple_linkItemDropDistribution		; $69e2
	call getRandomIndexFromProbabilityDistribution		; $69e5

	call _mapleCheckLinkCanDropItem		; $69e8
	jr z,@nextLinkItem	; $69eb

	ld d,>w1Link		; $69ed
	call _mapleSpawnItemDrop		; $69ef

	ld d,>w1Companion		; $69f2
	ld e,SpecialObject.counter1		; $69f4
	ld a,(de)		; $69f6
	dec a			; $69f7
	ld (de),a		; $69f8
	jr nz,@nextLinkItem	; $69f9
@ret:
	ret			; $69fb

;;
; @param	a	Index of item to drop
; @param[out]	cflag	Set if it's ok to drop this item
; @param[out]	zflag
; @addr{69fc}
@checkSpawnItem:
	; Check that Link has obtained the item (if applicable)
	push af			; $69fc
	ld hl,_mapleItemDropTreasureIndices		; $69fd
	rst_addAToHl			; $6a00
	ld a,(hl)		; $6a01
	call checkTreasureObtained		; $6a02
	pop hl			; $6a05
	jr c,@obtained		; $6a06
	or d			; $6a08
	ret			; $6a09

@obtained:
	ld a,h			; $6a0a
	ldh (<hFF8B),a	; $6a0b

	; Skip the below conditions for all items of index 5 or above (items that can be
	; dropped multiple times)
	cp $05			; $6a0d
	jp nc,_mapleSpawnItemDrop		; $6a0f

	; If this is the heart piece, only drop it if it hasn't been obtained yet
	or a			; $6a12
	jr nz,@notHeartPiece	; $6a13
	ld a,(wMapleState)		; $6a15
	bit 7,a			; $6a18
	ret nz			; $6a1a
	ld e,SpecialObject.invincibilityCounter		; $6a1b
	ld a,(de)		; $6a1d
	or a			; $6a1e
	ret nz			; $6a1f

	inc a			; $6a20
	ld (de),a		; $6a21
	jr @spawnItem		; $6a22

@notHeartPiece:
	dec a			; $6a24
	ld hl,@itemBitmasks		; $6a25
	rst_addAToHl			; $6a28
	ld b,(hl)		; $6a29
	ld e,SpecialObject.knockbackAngle		; $6a2a
	ld a,(de)		; $6a2c
	and b			; $6a2d
	ret nz			; $6a2e
	ld a,(de)		; $6a2f
	or b			; $6a30
	ld (de),a		; $6a31

@spawnItem:
	jr _mapleSpawnItemDrop_variant		; $6a32


; Bitmasks for items 1-5 for remembering if one's spawned already
@itemBitmasks:
	.db $04 $02 $02 $01


; The following are probability distributions for maple's dropped items. The sum of the
; numbers in each distribution should be exactly $100. An item with a higher number has
; a higher chance of dropping.

_maple_itemDropDistributionTable: ; Probabilities that Maple will drop something
	.dw @rareItems
	.dw @standardItems

@rareItems:
	.db $14 $0e $0e $1e $20 $00 $00 $00
	.db $00 $00 $28 $2e $28 $14

@standardItems:
	.db $00 $02 $04 $08 $0a $00 $00 $00
	.db $00 $00 $32 $34 $3c $46


_maple_linkItemDropDistribution: ; Probabilities that Link will drop something
	.db $00 $00 $00 $00 $00 $20 $20 $20
	.db $20 $20 $20 $20 $00 $20


; Each byte is the "value" of an item. The values of the items Link and Maple pick up are
; added up and totalled to see who "won" the encounter.
_mapleItemValues:
	.db $3c $0f $0a $08 $06 $05 $05 $05
	.db $05 $05 $04 $03 $02 $01 $00


; Given an index of an item drop, the corresponding value in the table below is a treasure
; to check if Link's obtained in order to allow Maple to drop it. "TREASURE_PUNCH" is
; always considered obtained, so it's used as a value to mean "always drop this".
;
; Item indices:
;  $00: heart piece
;  $01: gasha seed
;  $02: ring
;  $03: ring (different class?)
;  $04: potion
;  $05: ember seeds
;  $06: scent seeds
;  $07: pegasus seeds
;  $08: gale seeds
;  $09: mystery seeds
;  $0a: bombs
;  $0b: heart
;  $0c: 5 rupees
;  $0d: 1 rupee

_mapleItemDropTreasureIndices:
	.db TREASURE_PUNCH      TREASURE_PUNCH         TREASURE_PUNCH       TREASURE_PUNCH
	.db TREASURE_PUNCH      TREASURE_EMBER_SEEDS   TREASURE_SCENT_SEEDS TREASURE_PEGASUS_SEEDS
	.db TREASURE_GALE_SEEDS TREASURE_MYSTERY_SEEDS TREASURE_BOMBS       TREASURE_PUNCH
	.db TREASURE_PUNCH      TREASURE_PUNCH

;;
; @param	d	Object it comes from (Link or Maple)
; @param	hFF8B	Value for part's subid and var03 (item type?)
; @addr{6a83}
_mapleSpawnItemDrop:
	call getFreePartSlot		; $6a83
	scf			; $6a86
	ret nz			; $6a87
	ld (hl),PARTID_ITEM_FROM_MAPLE		; $6a88
	ld e,SpecialObject.yh		; $6a8a
	call objectCopyPosition_rawAddress		; $6a8c
	ldh a,(<hFF8B)	; $6a8f
	ld l,Part.var03		; $6a91
	ldd (hl),a ; [var03] = [hFF8B]
	ld (hl),a  ; [subid] = [hFF8B]
	xor a			; $6a95
	ret			; $6a96

;;
; @param	d	Object it comes from (Link or Maple)
; @param	hFF8B	Value for part's subid and var03 (item type?)
; @addr{6a97}
_mapleSpawnItemDrop_variant:
	call getFreePartSlot		; $6a97
	scf			; $6a9a
	ret nz			; $6a9b
	ld (hl),PARTID_ITEM_FROM_MAPLE_2		; $6a9c
	ld l,Part.subid		; $6a9e
	ldh a,(<hFF8B)	; $6aa0
	ldi (hl),a		; $6aa2
	ld (hl),a		; $6aa3
	call objectCopyPosition		; $6aa4
	or a			; $6aa7
	ret			; $6aa8

;;
; Decides what Maple's next item target should be.
;
; @param[out]	hl	The part object to go for
; @param[out]	zflag	nz if there are no items left
; @addr{6aa9}
_mapleDecideItemToCollect:

; Search for item IDs 0-4 first

	ld b,$00		; $6aa9

@idLoop1
	ldhl FIRST_PART_INDEX, Part.enabled		; $6aab

@partLoop1:
	ld l,Part.enabled		; $6aae
	ldi a,(hl)		; $6ab0
	or a			; $6ab1
	jr z,@nextPart1			; $6ab2

	ldi a,(hl)		; $6ab4
	cp PARTID_ITEM_FROM_MAPLE_2			; $6ab5
	jr nz,@nextPart1		; $6ab7

	ldd a,(hl)		; $6ab9
	cp b			; $6aba
	jr nz,@nextPart1		; $6abb

	; Found an item to go for
	dec l			; $6abd
	xor a			; $6abe
	ret			; $6abf

@nextPart1:
	inc h			; $6ac0
	ld a,h			; $6ac1
	cp LAST_PART_INDEX+1			; $6ac2
	jr c,@partLoop1		; $6ac4

	inc b			; $6ac6
	ld a,b			; $6ac7
	cp $05			; $6ac8
	jr c,@idLoop1		; $6aca

; Now search for item IDs $05-$0d

	xor a			; $6acc
	ld c,$00		; $6acd
	ld hl,@itemIDs		; $6acf
	rst_addAToHl			; $6ad2
	ld a,(hl)		; $6ad3
	ld b,a			; $6ad4
	xor a			; $6ad5
	ldh (<hFF91),a	; $6ad6

@idLoop2:
	ldhl FIRST_PART_INDEX, Part.enabled		; $6ad8

@partLoop2:
	ld l,Part.enabled		; $6adb
	ldi a,(hl)		; $6add
	or a			; $6ade
	jr z,@nextPart2		; $6adf

	ldi a,(hl)		; $6ae1
	cp PARTID_ITEM_FROM_MAPLE			; $6ae2
	jr nz,@nextPart2		; $6ae4

	ldd a,(hl)		; $6ae6
	cp b			; $6ae7
	jr nz,@nextPart2		; $6ae8

; We've found an item to go for. However, we'll only pick this one if it's closest of its
; type. Start by calculating maple's distance from it.

	ld l,Part.yh		; $6aea
	ld l,(hl)		; $6aec
	ld e,SpecialObject.yh		; $6aed
	ld a,(de)		; $6aef
	sub l			; $6af0
	jr nc,+			; $6af1
	cpl			; $6af3
	inc a			; $6af4
+
	ldh (<hFF8C),a	; $6af5
	ld l,Part.xh		; $6af7
	ld l,(hl)		; $6af9
	ld e,SpecialObject.xh		; $6afa
	ld a,(de)		; $6afc
	sub l			; $6afd
	jr nc,+			; $6afe
	cpl			; $6b00
	inc a			; $6b01
+
	ld l,a			; $6b02
	ldh a,(<hFF8C)	; $6b03
	add l			; $6b05
	ld l,a			; $6b06

; l now contains the distance to the item. Check if it's less than the closest item's
; distance (stored in hFF8D), or if this is the first such item (index stored in hFF91).

	ldh a,(<hFF91)	; $6b07
	or a			; $6b09
	jr z,++			; $6b0a
	ldh a,(<hFF8D)	; $6b0c
	cp l			; $6b0e
	jr c,@nextPart2		; $6b0f
++
	ld a,l			; $6b11
	ldh (<hFF8D),a	; $6b12
	ld a,h			; $6b14
	ldh (<hFF91),a	; $6b15

@nextPart2:
	inc h			; $6b17
	ld a,h			; $6b18
	cp $e0			; $6b19
	jr c,@partLoop2		; $6b1b

	; If we found an item of this type, return.
	ldh a,(<hFF91)	; $6b1d
	or a			; $6b1f
	jr nz,@foundItem	; $6b20

	; Otherwise, try the next item type.
	inc c			; $6b22
	ld a,c			; $6b23
	cp $09			; $6b24
	jr nc,@noItemsLeft	; $6b26

	ld hl,@itemIDs		; $6b28
	rst_addAToHl			; $6b2b
	ld a,(hl)		; $6b2c
	ld b,a			; $6b2d
	jr @idLoop2		; $6b2e

@noItemsLeft:
	; This will unset the zflag, since a=$09 and d=$d1... but they probably meant to
	; write "or d" to produce that effect. (That's what they normally do.)
	and d			; $6b30
	ret			; $6b31

@foundItem:
	ld h,a			; $6b32
	ld l,Part.enabled		; $6b33
	xor a			; $6b35
	ret			; $6b36

@itemIDs:
	.db $05 $06 $07 $08 $09 $0a $0b $0c
	.db $0d


;;
; Searches for a bomb item (an actual bomb that will explode). If one exists, and isn't
; currently exploding, it gets set as Maple's relatedObj1.
;
; @param[out]	zflag	z if the first bomb object found was suitable
; @addr{6b40}
_mapleFindUnexplodedBomb:
	ld e,SpecialObject.relatedObj1		; $6b40
	xor a			; $6b42
	ld (de),a		; $6b43
	inc e			; $6b44
	ld (de),a		; $6b45
	ld c,ITEMID_BOMB		; $6b46
	call findItemWithID		; $6b48
	ret nz			; $6b4b
	jr ++			; $6b4c

;;
; This is similar to above, except it's a "continuation" in case the first bomb that was
; found was unsuitable (in the process of exploding).
;
; @addr{6b4e}
_mapleFindNextUnexplodedBomb:
	ld c,ITEMID_BOMB		; $6b4e
	call findItemWithID_startingAfterH		; $6b50
	ret nz			; $6b53
++
	ld l,Item.var2f		; $6b54
	ld a,(hl)		; $6b56
	bit 7,a			; $6b57
	jr nz,++		; $6b59
	and $60			; $6b5b
	ret nz			; $6b5d
	ld l,$0f		; $6b5e
	bit 7,(hl)		; $6b60
	ret nz			; $6b62
++
	ld e,SpecialObject.relatedObj1		; $6b63
	ld a,h			; $6b65
	ld (de),a		; $6b66
	inc e			; $6b67
	xor a			; $6b68
	ld (de),a		; $6b69
	ret			; $6b6a

;;
; @addr{6b6b}
_mapleInitZPositionAndSpeed:
	ld h,d			; $6b6b
	ld l,SpecialObject.zh		; $6b6c
	ld a,$f8		; $6b6e
	ldi (hl),a		; $6b70

	ld l,SpecialObject.speedZ		; $6b71
	ld (hl),$40		; $6b73
	inc l			; $6b75
	ld (hl),$00		; $6b76

	ld l,SpecialObject.var3c		; $6b78
	ld a,$16		; $6b7a
	ldi (hl),a		; $6b7c
	ret			; $6b7d

;;
; @param[out]	a	Angle toward link (rounded to cardinal direction)
; @addr{6b7e}
_mapleGetCardinalAngleTowardLink:
	call objectGetAngleTowardLink		; $6b7e
	and $18			; $6b81
	ret			; $6b83

;;
; Decides what item Maple should go for, and updates var3d appropriately (the angle she's
; turning toward).
;
; If there are no more items, this sets Maple's state to $09.
;
; @addr{6b84}
_mapleDecideItemToCollectAndUpdateTargetAngle:
	call _mapleDecideItemToCollect		; $6b84
	jr nz,@noMoreItems	; $6b87

	ld e,SpecialObject.relatedObj2		; $6b89
	ld a,h			; $6b8b
	ld (de),a		; $6b8c
	inc e			; $6b8d
	ld a,l			; $6b8e
	ld (de),a		; $6b8f
	ld e,SpecialObject.damageToApply		; $6b90
	xor a			; $6b92
	ld (de),a		; $6b93
	jr _mapleSetTargetDirectionToRelatedObj2		; $6b94

@noMoreItems:
	ld e,SpecialObject.state		; $6b96
	ld a,$09		; $6b98
	ld (de),a		; $6b9a
	inc e			; $6b9b
	xor a			; $6b9c
	ld (de),a ; [state2] = 0
	ret			; $6b9e

;;
; @addr{6b9f}
_mapleSetTargetDirectionToRelatedObj2:
	ld e,SpecialObject.relatedObj2		; $6b9f
	ld a,(de)		; $6ba1
	ld h,a			; $6ba2
	inc e			; $6ba3
	ld a,(de)		; $6ba4
	or Object.yh			; $6ba5
	ld l,a			; $6ba7

	ldi a,(hl)		; $6ba8
	ld b,a			; $6ba9
	inc l			; $6baa
	ld a,(hl)		; $6bab
	ld c,a			; $6bac
	call objectGetRelativeAngle		; $6bad
	ld e,SpecialObject.var3d		; $6bb0
	ld (de),a		; $6bb2
	ret			; $6bb3

;;
; Checks if Link can drop an item in Maple's minigame, and removes the item amount from
; his inventory if he can.
;
; This function is bugged. The programmers mixed up the "treasure indices" with maple's
; item indices. As a result, the incorrect treasures are checked to be obtained; for
; example, pegasus seeds check that Link has obtained the rod of seasons. This means
; pegasus seeds will never drop in Ages. Similarly, gale seeds check the magnet gloves.
;
; @param	b	The item to drop
; @param[out]	hFF8B	The "maple item index" of the item to be dropped
; @param[out]	zflag	nz if Link can drop it
; @addr{6bb4}
_mapleCheckLinkCanDropItem:
	ld a,b			; $6bb4
	sub $05			; $6bb5
	ld b,a			; $6bb7
	rst_jumpTable			; $6bb8
	.dw @seed
	.dw @seed
	.dw @seed
	.dw @seed
	.dw @seed
	.dw @bombs
	.dw @heart
	.dw @heart ; This should be 5 rupees, but Link never drops that.
	.dw @oneRupee

@oneRupee:
	ld hl,wNumRupees		; $6bcb
	ldi a,(hl)		; $6bce
	or (hl)			; $6bcf
	ret z			; $6bd0
	ld a,$01		; $6bd1
	call removeRupeeValue		; $6bd3
	ld a,$0c		; $6bd6
	jr @setMapleItemIndex		; $6bd8

@bombs:
	; $0a corresponds to bombs in maple's treasure indices, but for the purpose of the
	; "checkTreasureObtained" call, it actually corresponds to "TREASURE_SWITCH_HOOK"!
	ld a,$0a		; $6bda
	ldh (<hFF8B),a	; $6bdc
	call checkTreasureObtained		; $6bde
	jr nc,@cannotDrop	; $6be1

	ld hl,wNumBombs		; $6be3
	ld a,(hl)		; $6be6
	sub $04			; $6be7
	jr c,@cannotDrop	; $6be9
	daa			; $6beb
	ld (hl),a		; $6bec
	call setStatusBarNeedsRefreshBit1		; $6bed
	or d			; $6bf0
	ret			; $6bf1

@seed:
	; BUG: For the purpose of "checkTreasureObtained", the treasure index will be very
	; wrong.
	;   Ember seed:   TREASURE_SWORD
	;   Scent seed:   TREASURE_BOOMERANG
	;   Pegasus seed: TREASURE_ROD_OF_SEASONS
	;   Gale seed:    TREASURE_MAGNET_GLOVES
	;   Mystery seed: TREASURE_SWITCH_HOOK_HELPER
	ld a,b			; $6bf2
	add $05			; $6bf3
	ldh (<hFF8B),a	; $6bf5
	call checkTreasureObtained		; $6bf7
	jr nc,@cannotDrop	; $6bfa

	; See if we can remove 5 of the seed type from the inventory
	ld a,b			; $6bfc
	ld hl,wNumEmberSeeds		; $6bfd
	rst_addAToHl			; $6c00
	ld a,(hl)		; $6c01
	sub $05			; $6c02
	jr c,@cannotDrop	; $6c04
	daa			; $6c06
	ld (hl),a		; $6c07

	call setStatusBarNeedsRefreshBit1		; $6c08
	or d			; $6c0b
	ret			; $6c0c

@cannotDrop:
	xor a			; $6c0d
	ret			; $6c0e

@heart:
	ld hl,wLinkHealth		; $6c0f
	ld a,(hl)		; $6c12
	cp 12 ; Check for at least 3 hearts
	jr nc,+			; $6c15
	xor a			; $6c17
	ret			; $6c18
+
	sub $04			; $6c19
	ld (hl),a		; $6c1b

	ld hl,wStatusBarNeedsRefresh		; $6c1c
	set 2,(hl)		; $6c1f

	ld a,$0b		; $6c21

@setMapleItemIndex:
	ldh (<hFF8B),a	; $6c23
	or d			; $6c25
	ret			; $6c26

;;
; @param[out]	a	Maple.damage variable (actually vehicle type)
; @param[out]	zflag	z if Maple's in a wall? (she won't do her sweeping animation)
; @addr{6c27}
_mapleFunc_6c27:
	ld e,SpecialObject.counter2		; $6c27
	ld a,$30		; $6c29
	ld (de),a		; $6c2b

	; [direction] = [zh]. ???
	ld e,SpecialObject.zh		; $6c2c
	ld a,(de)		; $6c2e
	ld e,SpecialObject.direction		; $6c2f
	ld (de),a		; $6c31

	call objectGetTileCollisions		; $6c32
	jr nz,@collision	; $6c35
	ld e,SpecialObject.zh		; $6c37
	xor a			; $6c39
	ld (de),a		; $6c3a
	or d			; $6c3b
	ld e,SpecialObject.damage		; $6c3c
	ld a,(de)		; $6c3e
	ret			; $6c3f
@collision:
	xor a			; $6c40
	ret			; $6c41

;;
; Increments lower 4 bits of wMapleState (the number of times Maple has been met)
; @addr{6c42}
_mapleIncrementMeetingCounter:
	ld hl,wMapleState		; $6c42
	ld a,(hl)		; $6c45
	and $0f			; $6c46
	ld b,a			; $6c48
	cp $0f			; $6c49
	jr nc,+			; $6c4b
	inc b			; $6c4d
+
	xor (hl)		; $6c4e
	or b			; $6c4f
	ld (hl),a		; $6c50
	ret			; $6c51


; These are the possible paths Maple can take when you just see her shadow.
_mapleShadowPathsTable:
	.dw @rareItemDrops
	.dw @standardItemDrops

; Data format:
;   First byte is the delay it takes to change angles. (Higher values make larger arcs.)
;   Each subsequent row is:
;     b0: target angle
;     b1: number of frames to move in that direction (not counting time it takes to turn)
@rareItemDrops:
	.db $02
	.db $18 $64
	.db $10 $02
	.db $08 $1e
	.db $10 $02
	.db $18 $7a
	.db $ff $ff

@standardItemDrops:
	.db $04
	.db $18 $64
	.db $10 $04
	.db $08 $64
	.db $ff $ff


; Maps a number to an index for the table below. At first, only the first 4 bytes are read
; at random from this table, but as maple is encountered more, the subsequent bytes are
; read, giving maple more variety in the way she moves.
_mapleMovementPatternIndices:
	.db $00 $01 $02 $00 $03 $04 $05 $03
	.db $06 $07 $01 $02 $04 $05 $06 $07

_mapleMovementPatternTable:
	.dw @pattern0
	.dw @pattern1
	.dw @pattern2
	.dw @pattern3
	.dw @pattern4
	.dw @pattern5
	.dw @pattern6
	.dw @pattern7

; Data format:
;   First row is the Y/X position for Maple to start at.
;   Second row is one byte for the delay it takes to change angles.
;   Each subsequent row is:
;     b0: target angle
;     b1: number of frames to move in that direction (not counting time it takes to turn)
@pattern0:
	.db $18 $b8
	.db $02
	.db $18 $4b
	.db $10 $01
	.db $08 $32
	.db $10 $01
	.db $18 $46
	.db $ff $ff

@pattern1:
	.db $70 $b8
	.db $02
	.db $18 $4b
	.db $00 $01
	.db $08 $32
	.db $00 $01
	.db $18 $46
	.db $ff $ff

@pattern2:
	.db $18 $f0
	.db $02
	.db $08 $46
	.db $10 $19
	.db $18 $28
	.db $00 $14
	.db $08 $19
	.db $10 $0f
	.db $18 $14
	.db $00 $0a
	.db $08 $0f
	.db $10 $32
	.db $ff $ff

@pattern3:
	.db $a0 $90
	.db $02
	.db $00 $37
	.db $18 $01
	.db $10 $19
	.db $18 $01
	.db $00 $19
	.db $18 $01
	.db $10 $3c
	.db $ff $ff

@pattern4:
	.db $a0 $10
	.db $02
	.db $00 $37
	.db $08 $01
	.db $10 $19
	.db $08 $01
	.db $00 $19
	.db $08 $01
	.db $10 $3c
	.db $ff $ff

@pattern5:
	.db $18 $f0
	.db $01
	.db $08 $28
	.db $16 $0f
	.db $08 $2d
	.db $16 $0a
	.db $08 $37
	.db $ff $ff

@pattern6:
	.db $f0 $30
	.db $02
	.db $14 $19
	.db $05 $11
	.db $14 $0a
	.db $17 $05
	.db $10 $01
	.db $05 $1e
	.db $14 $1e
	.db $ff $ff

@pattern7:
	.db $f0 $70
	.db $02
	.db $0c $19
	.db $1b $11
	.db $0c $08
	.db $0a $02
	.db $10 $01
	.db $1b $0f
	.db $0c $1e
	.db $ff $ff



;;
; @addr{6d1e}
_specialObjectCode_ricky:
	call _companionRetIfInactive		; $6d1e
	call _companionFunc_47d8		; $6d21
	call @runState		; $6d24
	jp _companionCheckEnableTerrainEffects		; $6d27

@runState:
	ld e,SpecialObject.state		; $6d2a
	ld a,(de)		; $6d2c
	rst_jumpTable			; $6d2d
	.dw _rickyState0
	.dw _rickyState1
	.dw _rickyState2
	.dw _rickyState3
	.dw _rickyState4
	.dw _rickyState5
	.dw _rickyState6
	.dw _rickyState7
	.dw _rickyState8
	.dw _rickyState9
	.dw _rickyStateA
	.dw _rickyStateB
	.dw _rickyStateC

;;
; State 0: initialization
; @addr{6d48}
_rickyState0:
_rickyStateB:
	call _companionCheckCanSpawn ; This may return

	ld a,$06		; $6d4b
	call objectSetCollideRadius		; $6d4d

	ld a,DIR_DOWN		; $6d50
	ld l,SpecialObject.direction		; $6d52
	ldi (hl),a		; $6d54
	ld (hl),a ; [angle] = $02

	ld l,SpecialObject.var39		; $6d56
	ld (hl),$10		; $6d58
	ld a,(wRickyState)		; $6d5a
	bit 7,a			; $6d5d
	jr nz,@setAnimation17	; $6d5f

	ld c,$17		; $6d61
	bit 6,a			; $6d63
	jr nz,@canTalkToRicky	; $6d65

	and $20			; $6d67
	jr nz,@setAnimation17	; $6d69

	ld c,$00		; $6d6b
@canTalkToRicky:
	; Ricky not ridable yet, can press A to talk to him
	ld l,SpecialObject.state		; $6d6d
	ld (hl),$0a		; $6d6f
	ld e,SpecialObject.var3d		; $6d71
	call objectAddToAButtonSensitiveObjectList		; $6d73
	ld a,c			; $6d76
	jr @setAnimation		; $6d77

@setAnimation17:
	ld a,$17		; $6d79

@setAnimation:
	call specialObjectSetAnimation		; $6d7b
	jp objectSetVisiblec1		; $6d7e

;;
; State 1: waiting for Link to mount
; @addr{6d81}
_rickyState1:
	call specialObjectAnimate		; $6d81
	call _companionSetPriorityRelativeToLink		; $6d84

	ld c,$09		; $6d87
	call objectCheckLinkWithinDistance		; $6d89
	jr nc,@didntMount	; $6d8c

	call _companionTryToMount		; $6d8e
	ret z			; $6d91

@didntMount:
	; Make Ricky hop every once in a while
	ld e,SpecialObject.animParameter		; $6d92
	ld a,(de)		; $6d94
	and $c0			; $6d95
	jr z,_rickyCheckHazards		; $6d97
	rlca			; $6d99
	ld c,$40		; $6d9a
	jp nc,objectUpdateSpeedZ_paramC		; $6d9c
	ld bc,$ff00		; $6d9f
	call objectSetSpeedZ		; $6da2

;;
; @addr{6da5}
_rickyCheckHazards:
	call _companionCheckHazards		; $6da5
	jp c,_rickyFunc_70cc		; $6da8

;;
; @addr{6dab}
_rickyState9:
	ret			; $6dab

;;
; State 2: Jumping up a cliff
; @addr{6dac}
_rickyState2:
	call _companionDecCounter1		; $6dac
	jr z,++			; $6daf
	dec (hl)		; $6db1
	ret nz			; $6db2
	ld a,SND_RICKY		; $6db3
	call playSound		; $6db5
++
	ld c,$40		; $6db8
	call objectUpdateSpeedZ_paramC		; $6dba
	call specialObjectAnimate		; $6dbd
	call objectApplySpeed		; $6dc0

	call _companionCalculateAdjacentWallsBitset		; $6dc3

	; Check whether Ricky's passed through any walls?
	ld e,SpecialObject.adjacentWallsBitset		; $6dc6
	ld a,(de)		; $6dc8
	and $0f			; $6dc9
	ld e,SpecialObject.counter2		; $6dcb
	jr z,+			; $6dcd
	ld (de),a		; $6dcf
	ret			; $6dd0
+
	ld a,(de)		; $6dd1
	or a			; $6dd2
	ret z			; $6dd3
	jp _rickyStopUntilLandedOnGround		; $6dd4

;;
; State 3: Link is currently jumping up to mount Ricky
; @addr{6dd7}
_rickyState3:
	ld c,$40		; $6dd7
	call objectUpdateSpeedZ_paramC		; $6dd9
	call _companionCheckMountingComplete		; $6ddc
	ret nz			; $6ddf

	call _companionFinalizeMounting		; $6de0
	ld a,SND_RICKY		; $6de3
	call playSound		; $6de5
	ld c,$20		; $6de8
	jp _companionSetAnimation		; $6dea

;;
; State 4: Ricky falling into a hazard (hole/water)
; @addr{6ded}
_rickyState4:
	ld e,SpecialObject.var37		; $6ded
	ld a,(de)		; $6def
	cp $0e ; Is this water?
	jr z,++			; $6df2

	; For any other value of var37, assume it's a hole ($0d).
	ld a,$0d		; $6df4
	ld (de),a		; $6df6
	call _companionDragToCenterOfHole		; $6df7
	ret nz			; $6dfa
++
	call _companionDecCounter1		; $6dfb
	jr nz,@animate	; $6dfe

	inc (hl)		; $6e00
	ld e,SpecialObject.var37		; $6e01
	ld a,(de)		; $6e03
	call specialObjectSetAnimation		; $6e04

	ld e,SpecialObject.var37		; $6e07
	ld a,(de)		; $6e09
	cp $0e ; Is this water?
	jr z,@animate	; $6e0c
	ld a,SND_LINK_FALL		; $6e0e
	jp playSound		; $6e10

@animate:
	call _companionAnimateDrowningOrFallingThenRespawn		; $6e13
	ret nc			; $6e16

	; Decide animation depending whether Link is riding Ricky
	ld c,$01		; $6e17
	ld a,(wLinkObjectIndex)		; $6e19
	rrca			; $6e1c
	jr nc,+			; $6e1d
	ld c,$05		; $6e1f
+
	jp _companionUpdateDirectionAndSetAnimation		; $6e21

;;
; State 5: Link riding Ricky.
;
; (Note: this may be called from state C?)
;
; @addr{6e24}
_rickyState5:
	ld e,SpecialObject.state2		; $6e24
	ld a,(de)		; $6e26
	rst_jumpTable			; $6e27
	.dw _rickyState5Substate0
	.dw _rickyState5Substate1
	.dw _rickyState5Substate2
	.dw _rickyState5Substate3

;;
; Substate 0: moving (not hopping)
; @addr{6e30}
_rickyState5Substate0:
	ld a,(wForceCompanionDismount)		; $6e30
	or a			; $6e33
	jr nz,++		; $6e34

	ld a,(wGameKeysJustPressed)		; $6e36
	bit BTN_BIT_A,a			; $6e39
	jp nz,_rickyStartPunch		; $6e3b

	bit BTN_BIT_B,a			; $6e3e
++
	jp nz,_companionGotoDismountState		; $6e40

	; Copy Link's angle (calculated from input buttons) to companion's angle
	ld h,d			; $6e43
	ld a,(wLinkAngle)		; $6e44
	ld l,SpecialObject.angle		; $6e47
	ld (hl),a		; $6e49

	; If not moving, set var39 to $10 (counter until Ricky hops)
	rlca			; $6e4a
	ld l,SpecialObject.var39		; $6e4b
	jr nc,@moving		; $6e4d
	ld a,$10		; $6e4f
	ld (hl),a		; $6e51

	ld c,$20		; $6e52
	call _companionSetAnimation		; $6e54
	jp _rickyCheckHazards		; $6e57

@moving:
	; Check if the "jump countdown" has reached zero
	ld l,SpecialObject.var39		; $6e5a
	ld a,(hl)		; $6e5c
	or a			; $6e5d
	jr z,@tryToJump		; $6e5e

	dec (hl) ; [var39]-=1

	ld l,SpecialObject.speed		; $6e61
	ld (hl),SPEED_c0		; $6e63

	ld c,$20		; $6e65
	call _companionUpdateDirectionAndAnimate		; $6e67
	call _rickyCheckForHoleInFront		; $6e6a
	jp z,_rickyBeginJumpOverHole		; $6e6d

	call _companionCheckHopDownCliff		; $6e70
	jr nz,+			; $6e73
	jp _rickySetJumpSpeed		; $6e75
+
	call _rickyCheckHopUpCliff		; $6e78
	jr nz,+			; $6e7b
	jp _rickySetJumpSpeed_andcc91		; $6e7d
+
	call _companionUpdateMovement		; $6e80
	jp _rickyCheckHazards		; $6e83

; "Jump timer" has reached zero; make him jump (either from movement, over a hole, or up
; or down a cliff).
@tryToJump:
	ld h,d			; $6e86
	ld l,SpecialObject.angle		; $6e87
	ldd a,(hl)		; $6e89
	add a			; $6e8a
	swap a			; $6e8b
	and $03			; $6e8d
	ldi (hl),a		; $6e8f
	call _rickySetJumpSpeed_andcc91		; $6e90

	; If he's moving left or right, skip the up/down cliff checks
	ld l,SpecialObject.angle		; $6e93
	ld a,(hl)		; $6e95
	bit 2,a			; $6e96
	jr nz,@jump	; $6e98

	call _companionCheckHopDownCliff		; $6e9a
	jr nz,++		; $6e9d
	ld (wDisableScreenTransitions),a		; $6e9f
	ld c,$0f		; $6ea2
	jp _companionSetAnimation		; $6ea4
++
	call _rickyCheckHopUpCliff		; $6ea7
	ld c,$0f		; $6eaa
	jp z,_companionSetAnimation		; $6eac

@jump:
	; If there's a hole in front, try to jump over it
	ld e,SpecialObject.state2		; $6eaf
	ld a,$02		; $6eb1
	ld (de),a		; $6eb3
	call _rickyCheckForHoleInFront		; $6eb4
	jp z,_rickyBeginJumpOverHole		; $6eb7

	; Otherwise, just do a normal hop
	ld bc,-$180		; $6eba
	call objectSetSpeedZ		; $6ebd
	ld l,SpecialObject.state2		; $6ec0
	ld (hl),$01		; $6ec2
	ld l,SpecialObject.counter1		; $6ec4
	ld (hl),$08		; $6ec6
	ld l,SpecialObject.speed		; $6ec8
	ld (hl),SPEED_200		; $6eca
	ld c,$19		; $6ecc
	call _companionSetAnimation		; $6ece

	call getRandomNumber		; $6ed1
	and $0f			; $6ed4
	ld a,SND_JUMP		; $6ed6
	jr nz,+			; $6ed8
	ld a,SND_RICKY		; $6eda
+
	jp playSound		; $6edc

;;
; Checks for holes for Ricky to jump over. Stores the tile 2 spaces away in var36.
;
; @param[out]	a	The tile directly in front of Ricky
; @param[out]	var36	The tile 2 spaces in front of Ricky
; @param[out]	zflag	Set if the tile in front of Ricky is a hole
; @addr{6edf}
_rickyCheckForHoleInFront:
	; Make sure we're not moving diagonally
	ld a,(wLinkAngle)		; $6edf
	and $04			; $6ee2
	ret nz			; $6ee4

	ld e,SpecialObject.direction		; $6ee5
	ld a,(de)		; $6ee7
	ld hl,_rickyHoleCheckOffsets		; $6ee8
	rst_addDoubleIndex			; $6eeb

	; Set b = y-position 2 tiles away, [hFF90] = y-position one tile away
	ld e,SpecialObject.yh		; $6eec
	ld a,(de)		; $6eee
	add (hl)		; $6eef
	ldh (<hFF90),a	; $6ef0
	add (hl)		; $6ef2
	ld b,a			; $6ef3

	; Set c = x-position 2 tiles away, [hFF91] = x-position one tile away
	inc hl			; $6ef4
	ld e,SpecialObject.xh		; $6ef5
	ld a,(de)		; $6ef7
	add (hl)		; $6ef8
	ldh (<hFF91),a	; $6ef9
	add (hl)		; $6efb
	ld c,a			; $6efc

	; Store in var36 the index of the tile 2 spaces away
	call getTileAtPosition		; $6efd
	ld a,l			; $6f00
	ld e,SpecialObject.var36		; $6f01
	ld (de),a		; $6f03

	ldh a,(<hFF90)	; $6f04
	ld b,a			; $6f06
	ldh a,(<hFF91)	; $6f07
	ld c,a			; $6f09
	call getTileAtPosition		; $6f0a
	ld h,>wRoomLayout		; $6f0d
	ld a,(hl)		; $6f0f
	cp TILEINDEX_HOLE			; $6f10
	ret z			; $6f12
	cp TILEINDEX_FD			; $6f13
	ret			; $6f15

;;
; Substate 1: hopping during normal movement
; @addr{6f16}
_rickyState5Substate1:
	dec e			; $6f16
	ld a,(de) ; Check [state]
	cp $05			; $6f18
	jr nz,@doneInputParsing	; $6f1a

	ld a,(wGameKeysJustPressed)		; $6f1c
	bit BTN_BIT_A,a			; $6f1f
	jp nz,_rickyStartPunch		; $6f21

	; Check if we're attempting to move
	ld a,(wLinkAngle)		; $6f24
	bit 7,a			; $6f27
	jr nz,@doneInputParsing	; $6f29

	; Update direction based on wLinkAngle
	ld hl,w1Companion.direction		; $6f2b
	ld b,a			; $6f2e
	add a			; $6f2f
	swap a			; $6f30
	and $03			; $6f32
	ldi (hl),a		; $6f34

	; Check if angle changed (and if animation needs updating)
	ld a,b			; $6f35
	cp (hl)			; $6f36
	ld (hl),a		; $6f37
	ld c,$19		; $6f38
	call nz,_companionSetAnimation		; $6f3a

@doneInputParsing:
	ld c,$40		; $6f3d
	call objectUpdateSpeedZ_paramC		; $6f3f
	jr z,@landed		; $6f42

	ld a,(wLinkObjectIndex)		; $6f44
	rra			; $6f47
	jr nc,++		; Check if Link's riding?
	ld a,(wLinkAngle)		; $6f4a
	and $04			; $6f4d
	jr nz,@updateMovement	; $6f4f
++
	; If Ricky's facing a hole, don't move into it
	ld hl,_rickyHoleCheckOffsets		; $6f51
	call _specialObjectGetRelativeTileWithDirectionTable		; $6f54
	ld a,b			; $6f57
	cp TILEINDEX_HOLE			; $6f58
	ret z			; $6f5a
	cp TILEINDEX_FD			; $6f5b
	ret z			; $6f5d

@updateMovement:
	jp _companionUpdateMovement		; $6f5e

@landed:
	call specialObjectAnimate		; $6f61
	call _companionDecCounter1IfNonzero		; $6f64
	ret nz			; $6f67
	jp _rickyStopUntilLandedOnGround		; $6f68

;;
; Substate 2: jumping over a hole
; @addr{6f6b}
_rickyState5Substate2:
	call _companionDecCounter1		; $6f6b
	jr z,++			; $6f6e
	dec (hl)		; $6f70
	ret nz			; $6f71
	ld a,SND_RICKY		; $6f72
	call playSound		; $6f74
++
	ld c,$40		; $6f77
	call objectUpdateSpeedZ_paramC		; $6f79
	jp z,_rickyStopUntilLandedOnGround		; $6f7c

	call specialObjectAnimate		; $6f7f
	call _companionUpdateMovement		; $6f82
	call _specialObjectCheckMovingTowardWall		; $6f85
	jp nz,_rickyStopUntilLandedOnGround		; $6f88
	ret			; $6f8b

;;
; Substate 3: just landed on the ground (or waiting to land on the ground?)
; @addr{6f8c}
_rickyState5Substate3:
	; If he hasn't landed yet, do nothing until he does
	ld c,$40		; $6f8c
	call objectUpdateSpeedZ_paramC		; $6f8e
	ret nz			; $6f91

	call _rickyBreakTilesOnLanding		; $6f92

	; Return to state 5, substate 0 (normal movement)
	xor a			; $6f95
	ld e,SpecialObject.state2		; $6f96
	ld (de),a		; $6f98

	jp _rickyCheckHazards2		; $6f99

;;
; State 8: punching (substate 0) or charging tornado (substate 1)
; @addr{6f9c}
_rickyState8:
	ld e,$05		; $6f9c
	ld a,(de)		; $6f9e
	rst_jumpTable			; $6f9f
	.dw @substate0
	.dw @substate1

; Substate 0: punching
@substate0:
	ld c,$40		; $6fa4
	call objectUpdateSpeedZ_paramC		; $6fa6
	jr z,@onGround			; $6fa9

	call _companionUpdateMovement		; $6fab
	jr ++			; $6fae

@onGround:
	call _companionTryToBreakTileFromMoving		; $6fb0
	call _rickyCheckHazards		; $6fb3
++
	; Wait for the animation to signal something (play sound effect or start tornado
	; charging)
	call specialObjectAnimate		; $6fb6
	ld e,SpecialObject.animParameter		; $6fb9
	ld a,(de)		; $6fbb
	and $c0			; $6fbc
	ret z			; $6fbe

	rlca			; $6fbf
	jr c,@startTornadoCharge			; $6fc0

	ld a,SND_UNKNOWN5		; $6fc2
	jp playSound		; $6fc4

@startTornadoCharge:
	; Return if in midair
	ld e,SpecialObject.zh		; $6fc7
	ld a,(de)		; $6fc9
	or a			; $6fca
	ret nz			; $6fcb

	; Check if let go of the button
	ld a,(wGameKeysPressed)		; $6fcc
	and BTN_A			; $6fcf
	jp z,_rickyStopUntilLandedOnGround		; $6fd1

	; Start tornado charging
	call itemIncState2		; $6fd4
	ld c,$13		; $6fd7
	call _companionSetAnimation		; $6fd9
	call _companionCheckHazards		; $6fdc
	ret nc			; $6fdf
	jp _rickyFunc_70cc		; $6fe0

; Substate 1: charging tornado
@substate1:
	; Update facing direction
	ld a,(wLinkAngle)		; $6fe3
	bit 7,a			; $6fe6
	jr nz,++		; $6fe8
	ld hl,w1Companion.angle		; $6fea
	cp (hl)			; $6fed
	ld (hl),a		; $6fee
	ld c,$13		; $6fef
	call nz,_companionUpdateDirectionAndAnimate		; $6ff1
++
	call specialObjectAnimate		; $6ff4
	ld a,(wGameKeysPressed)		; $6ff7
	and BTN_A			; $6ffa
	jr z,@releasedAButton	; $6ffc

	; Check if fully charged
	ld e,SpecialObject.var35		; $6ffe
	ld a,(de)		; $7000
	cp $1e			; $7001
	jr nz,@continueCharging		; $7003

	call _companionTryToBreakTileFromMoving		; $7005
	call _rickyCheckHazards		; $7008
	ld c,$04		; $700b
	jp _companionFlashFromChargingAnimation		; $700d

@continueCharging:
	inc a			; $7010
	ld (de),a ; [var35]++
	cp $1e			; $7012
	ret nz			; $7014
	ld a,SND_CHARGE_SWORD		; $7015
	jp playSound		; $7017

@releasedAButton:
	; Reset palette to normal
	ld hl,w1Link.oamFlagsBackup		; $701a
	ldi a,(hl)		; $701d
	ld (hl),a		; $701e

	ld e,SpecialObject.var35		; $701f
	ld a,(de)		; $7021
	cp $1e			; $7022
	jr nz,@notCharged	; $7024

	ldbc ITEMID_RICKY_TORNADO, $00		; $7026
	call _companionCreateItem		; $7029

	ld a,SNDCTRL_STOPSFX		; $702c
	call playSound		; $702e
	ld a,SND_SWORDSPIN		; $7031
	call playSound		; $7033

	jr _rickyStartPunch		; $7036

@notCharged:
	ld c,$05		; $7038
	jp _companionSetAnimationAndGotoState5		; $703a

;;
; @addr{703d}
_rickyStartPunch:
	ldbc ITEMID_28, $00		; $703d
	call _companionCreateWeaponItem		; $7040
	ret nz			; $7043
	ld h,d			; $7044
	ld l,SpecialObject.state		; $7045
	ld a,$08		; $7047
	ldi (hl),a		; $7049
	xor a			; $704a
	ld (hl),a ; [state2] = 0

	inc a			; $704c
	ld l,SpecialObject.var35		; $704d
	ld (hl),a		; $704f
	ld c,$09		; $7050
	call _companionSetAnimation		; $7052
	ld a,SND_SWORDSLASH		; $7055
	jp playSound		; $7057

;;
; State 6: Link has dismounted; he can't remount until he moves a certain distance away,
; then comes back.
; @addr{705a}
_rickyState6:
	ld e,SpecialObject.state2		; $705a
	ld a,(de)		; $705c
	rst_jumpTable			; $705d
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld c,$40		; $7064
	call objectUpdateSpeedZ_paramC		; $7066
	ret nz			; $7069
	call itemIncState2		; $706a
	call companionDismountAndSavePosition		; $706d
	ld a,$17		; $7070
	jp specialObjectSetAnimation		; $7072

@substate1:
	ld a,(wLinkInAir)		; $7075
	or a			; $7078
	ret nz			; $7079
	jp itemIncState2		; $707a

; Waiting for Link to get a certain distance away before allowing him to mount again
@substate2:
	call _companionSetPriorityRelativeToLink		; $707d

	ld c,$09		; $7080
	call objectCheckLinkWithinDistance		; $7082
	jp c,_rickyCheckHazards		; $7085

	; Link is far enough away; allow him to remount when he approaches again.
	ld e,SpecialObject.state2		; $7088
	xor a			; $708a
	ld (de),a ; [state2] = 0
	dec e			; $708c
	inc a			; $708d
	ld (de),a ; [state] = 1
	ret			; $708f

;;
; State 7: Jumping down a cliff
; @addr{7090}
_rickyState7:
	call _companionDecCounter1ToJumpDownCliff		; $7090
	ret c			; $7093

	call _companionCalculateAdjacentWallsBitset		; $7094
	call _specialObjectCheckMovingAwayFromWall		; $7097
	ld e,$07		; $709a
	jr z,+			; $709c
	ld (de),a		; $709e
	ret			; $709f
+
	ld a,(de)		; $70a0
	or a			; $70a1
	ret z			; $70a2

;;
; Sets ricky to state 5, substate 3 (do nothing until he lands, then continue normal
; movement)
; @addr{70a3}
_rickyStopUntilLandedOnGround:
	ld a,(wLinkObjectIndex)		; $70a3
	rrca			; $70a6
	jr nc,+			; $70a7
	xor a			; $70a9
	ld (wLinkInAir),a		; $70aa
	ld (wDisableScreenTransitions),a		; $70ad
+
	ld a,$05		; $70b0
	ld e,SpecialObject.state		; $70b2
	ld (de),a		; $70b4
	ld a,$03		; $70b5
	ld e,SpecialObject.state2		; $70b7
	ld (de),a		; $70b9

	; If Ricky's close to the screen edge, set the "jump delay counter" back to $10 so
	; that he'll stay on the ground long enough for a screen transition to happen
	call _rickyCheckAtScreenEdge		; $70ba
	jr z,_rickyCheckHazards2			; $70bd
	ld e,SpecialObject.var39		; $70bf
	ld a,$10		; $70c1
	ld (de),a		; $70c3

;;
; @addr{70c4}
_rickyCheckHazards2:
	call _companionCheckHazards		; $70c4
	ld c,$20		; $70c7
	jp nc,_companionSetAnimation		; $70c9

;;
; @param	a	Hazard type landed on
; @addr{70cc}
_rickyFunc_70cc:
	ld c,$0e		; $70cc
	cp $01 ; Landed on water?
	jr z,+			; $70d0
	ld c,$0d		; $70d2
+
	ld h,d			; $70d4
	ld l,SpecialObject.var37		; $70d5
	ld (hl),c		; $70d7
	ld l,SpecialObject.counter1		; $70d8
	ld (hl),$00		; $70da
	ret			; $70dc

;;
; State A: various cutscene-related things? Behaviour is controlled by "var03" instead of
; "state2".
;
; @addr{70dd}
_rickyStateA:
	ld e,SpecialObject.var03		; $70dd
	ld a,(de)		; $70df
	rst_jumpTable			; $70e0
	.dw _rickyStateASubstate0
	.dw _rickyStateASubstate1
	.dw _rickyStateASubstate2
	.dw _rickyStateASubstate3
	.dw _rickyStateASubstate4
	.dw _rickyStateASubstate5
	.dw _rickyStateASubstate6
	.dw _rickyStateASubstate7

;;
; Standing around doing nothing?
; @addr{70f1}
_rickyStateASubstate0:
	call _companionPreventLinkFromPassing_noExtraChecks		; $70f1
	call _companionSetPriorityRelativeToLink		; $70f4
	call specialObjectAnimate		; $70f7
	ld e,$21		; $70fa
	ld a,(de)		; $70fc
	rlca			; $70fd
	ld c,$40		; $70fe
	jp nc,objectUpdateSpeedZ_paramC		; $7100
	ld bc,-$100		; $7103
	jp objectSetSpeedZ		; $7106

;;
; Force Link to mount
; @addr{7109}
_rickyStateASubstate1:
	ld e,SpecialObject.var3d		; $7109
	call objectRemoveFromAButtonSensitiveObjectList		; $710b
	jp _companionForceMount		; $710e

;;
; Ricky leaving upon meeting Tingle (part 1: print text)
; @addr{7111}
_rickyStateASubstate2:
	ld c,$40		; $7111
	call objectUpdateSpeedZ_paramC		; $7113
	ret nz			; $7116

	ld bc,TX_2006		; $7117
	call showText		; $711a

	ld hl,w1Link.yh		; $711d
	ld e,SpecialObject.yh		; $7120
	ld a,(de)		; $7122
	cp (hl)			; $7123
	ld a,$02		; $7124
	jr c,+			; $7126
	ld a,$00		; $7128
+
	ld e,SpecialObject.direction		; $712a
	ld (de),a		; $712c
	ld a,$03		; $712d
	ld e,SpecialObject.var3f		; $712f
	ld (de),a		; $7131
	call specialObjectSetAnimation		; $7132
	call _rickyIncVar03		; $7135
	jr _rickySetJumpSpeedForCutscene		; $7138

;;
; @addr{713a}
_rickySetJumpSpeedForCutsceneAndSetAngle:
	ld b,$30		; $713a
	ld c,$58		; $713c
	call objectGetRelativeAngle		; $713e
	and $1c			; $7141
	ld e,SpecialObject.angle		; $7143
	ld (de),a		; $7145

;;
; @addr{7146}
_rickySetJumpSpeedForCutscene:
	ld bc,-$180		; $7146
	call objectSetSpeedZ		; $7149
	ld l,SpecialObject.state2		; $714c
	ld (hl),$01		; $714e
	ld l,SpecialObject.speed		; $7150
	ld (hl),SPEED_200		; $7152
	ld l,SpecialObject.counter1		; $7154
	ld (hl),$08		; $7156
	ret			; $7158

;;
; Ricky leaving upon meeting Tingle (part 5: punching the air)
; @addr{7159}
_rickyStateASubstate6:
	; Wait for animation to give signals to play sound, start moving away.
	call specialObjectAnimate		; $7159
	ld e,SpecialObject.animParameter		; $715c
	ld a,(de)		; $715e
	or a			; $715f
	ld a,SND_RICKY		; $7160
	jp z,playSound		; $7162

	ld a,(de)		; $7165
	rlca			; $7166
	ret nc			; $7167

	; Start moving away
	call _rickySetJumpSpeedForCutsceneAndSetAngle		; $7168
	ld e,SpecialObject.angle		; $716b
	ld a,$10		; $716d
	ld (de),a		; $716f

	ld c,$05		; $7170
	call _companionSetAnimation		; $7172
	jp _rickyIncVar03		; $7175

;;
; Ricky leaving upon meeting Tingle (part 2: start moving toward cliff)
; @addr{7178}
_rickyStateASubstate3:
	call retIfTextIsActive		; $7178

	; Move down-left
	ld a,$14		; $717b
	ld e,SpecialObject.angle		; $717d
	ld (de),a		; $717f

	; Face down
	dec e			; $7180
	ld a,$02		; $7181
	ld (de),a		; $7183

	ld c,$05		; $7184
	call _companionSetAnimation		; $7186
	jp _rickyIncVar03		; $7189

;;
; Ricky leaving upon meeting Tingle (part 4: jumping down cliff)
; @addr{718c}
_rickyStateASubstate5:
	call specialObjectAnimate		; $718c
	call objectApplySpeed		; $718f
	ld c,$40		; $7192
	call objectUpdateSpeedZ_paramC		; $7194
	ret nz			; $7197

	; Reached bottom of cliff
	ld a,$18		; $7198
	call specialObjectSetAnimation		; $719a
	jp _rickyIncVar03		; $719d

;;
; Ricky leaving upon meeting Tingle (part 3: moving toward cliff, or...
;                                    part 6: moving toward screen edge)
; @addr{71a0}
_rickyStateASubstate4:
_rickyStateASubstate7:
	call _companionSetAnimationToVar3f		; $71a0
	call _rickyWaitUntilJumpDone		; $71a3
	ret nz			; $71a6

	; Ricky has just touched the ground, and is ready to do another hop.

	; Check if moving toward a wall on the left
	ld a,$18		; $71a7
	ld e,SpecialObject.angle		; $71a9
	ld (de),a		; $71ab
	call _specialObjectCheckMovingTowardWall		; $71ac
	jr z,@hop	; $71af

	; Check if moving toward a wall below
	ld a,$10		; $71b1
	ld e,SpecialObject.angle		; $71b3
	ld (de),a		; $71b5
	call _specialObjectCheckMovingTowardWall		; $71b6
	jr z,@hop	; $71b9

	; He's against the cliff; proceed to next state (jumping down cliff).
	call _rickySetJumpSpeed		; $71bb
	ld a,SND_JUMP		; $71be
	call playSound		; $71c0
	jp _rickyIncVar03		; $71c3

@hop:
	call objectCheckWithinScreenBoundary		; $71c6
	jr nc,@leftScreen	; $71c9

	; Moving toward cliff, or screen edge? Set angle accordingly.
	ld e,SpecialObject.var03		; $71cb
	ld a,(de)		; $71cd
	cp $07			; $71ce
	ld a,$10		; $71d0
	jr z,+			; $71d2
	ld a,$14		; $71d4
+
	ld e,SpecialObject.angle		; $71d6
	ld (de),a		; $71d8
	jp _rickySetJumpSpeedForCutscene		; $71d9

@leftScreen:
	xor a			; $71dc
	ld (wDisabledObjects),a		; $71dd
	ld (wMenuDisabled),a		; $71e0
	ld (wDeathRespawnBuffer.rememberedCompanionId),a		; $71e3
	call itemDelete		; $71e6
	ld hl,wRickyState		; $71e9
	set 6,(hl)		; $71ec
	jp saveLinkLocalRespawnAndCompanionPosition		; $71ee

;;
; @addr{71f1}
_rickyIncVar03:
	ld e,SpecialObject.var03		; $71f1
	ld a,(de)		; $71f3
	inc a			; $71f4
	ld (de),a		; $71f5
	ret			; $71f6

;;
; Unused? (Seasons departure code?)
; @addr{71f7}
_rickyFunc_71f7:
	call retIfTextIsActive		; $71f7
	call companionDismount		; $71fa

	ld a,$18		; $71fd
	ld (w1Link.angle),a		; $71ff
	ld (wLinkAngle),a		; $7202

	ld a,SPEED_140		; $7205
	ld (w1Link.speed),a		; $7207

	ld h,d			; $720a
	ld l,SpecialObject.angle		; $720b
	ld a,$18		; $720d
	ldd (hl),a		; $720f

	ld a,DIR_LEFT		; $7210
	ldd (hl),a ; [direction] = DIR_LEFT
	ld a,$1e		; $7213
	ld (hl),a ; [counter2] = $1e

	ld a,$24		; $7216
	call specialObjectSetAnimation		; $7218
	jr _rickyIncVar03		; $721b

;;
; Unused? (Seasons departure code?)
; @addr{721d}
_rickyFunc_721d:
	ld a,(wLinkInAir)		; $721d
	or a			; $7220
	ret nz			; $7221

	call setLinkForceStateToState08		; $7222
	ld hl,w1Link.xh		; $7225
	ld e,SpecialObject.xh		; $7228
	ld a,(de)		; $722a
	bit 7,a			; $722b
	jr nz,+		; $722d

	cp (hl)			; $722f
	ld a,DIR_RIGHT		; $7230
	jr nc,++			; $7232
+
	ld a,DIR_LEFT		; $7234
++
	ld l,SpecialObject.direction		; $7236
	ld (hl),a		; $7238
	ld e,SpecialObject.counter2		; $7239
	ld a,(de)		; $723b
	or a			; $723c
	jr z,@moveCompanion	; $723d
	dec a			; $723f
	ld (de),a		; $7240
	ret			; $7241

@moveCompanion:
	call specialObjectAnimate		; $7242
	call _companionUpdateMovement		; $7245
	call objectCheckWithinScreenBoundary		; $7248
	ret c			; $724b
	xor a			; $724c
	ld (wRememberedCompanionId),a		; $724d
	ld (wDisabledObjects),a		; $7250
	ld (wMenuDisabled),a		; $7253
	jp itemDelete		; $7256

;;
; @param[out]	zflag	Set if Ricky's on the ground and counter1 has reached 0.
; @addr{7259}
_rickyWaitUntilJumpDone:
	ld c,$40		; $7259
	call objectUpdateSpeedZ_paramC		; $725b
	jr z,@onGround		; $725e

	call _companionUpdateMovement		; $7260
	or d			; $7263
	ret			; $7264

@onGround:
	ld c,$05		; $7265
	call _companionSetAnimation		; $7267
	jp _companionDecCounter1IfNonzero		; $726a

;;
; State $0c: Ricky entering screen from flute call
; @addr{726d}
_rickyStateC:
	ld e,SpecialObject.var03		; $726d
	ld a,(de)		; $726f
	rst_jumpTable			; $7270
	.dw @parameter0
	.dw @parameter1

@parameter0:
	call _companionInitializeOnEnteringScreen		; $7275
	ld (hl),$02		; $7278
	call _rickySetJumpSpeedForCutscene		; $727a
	ld a,SND_RICKY		; $727d
	call playSound		; $727f
	ld c,$01		; $7282
	jp _companionSetAnimation		; $7284

@parameter1:
	call _rickyState5		; $7287

	; Return if falling into a hazard
	ld e,SpecialObject.state		; $728a
	ld a,(de)		; $728c
	cp $04			; $728d
	ret z			; $728f

	ld a,$0c		; $7290
	ld (de),a ; [state] = $0c
	inc e			; $7293
	ld a,(de) ; a = [state2]
	cp $03			; $7295
	ret nz			; $7297

	call _rickyBreakTilesOnLanding		; $7298
	ld hl,_rickyHoleCheckOffsets		; $729b
	call _specialObjectGetRelativeTileWithDirectionTable		; $729e
	or a			; $72a1
	jr nz,@initializeRicky	; $72a2
	call itemDecCounter2		; $72a4
	jr z,@initializeRicky	; $72a7
	call _rickySetJumpSpeedForCutscene		; $72a9
	ld c,$01		; $72ac
	jp _companionSetAnimation		; $72ae

; Make Ricky stop moving in, start waiting in place
@initializeRicky:
	ld e,SpecialObject.var03		; $72b1
	xor a			; $72b3
	ld (de),a		; $72b4
	jp _rickyState0		; $72b5


;;
; @param[out]	zflag	Set if Ricky should hop up a cliff
; @addr{72b8}
_rickyCheckHopUpCliff:
	; Check that Ricky's facing a wall above him
	ld e,SpecialObject.adjacentWallsBitset		; $72b8
	ld a,(de)		; $72ba
	and $c0			; $72bb
	cp $c0			; $72bd
	ret nz			; $72bf

	; Check that we're trying to move up
	ld a,(wLinkAngle)		; $72c0
	cp $00			; $72c3
	ret nz			; $72c5

	; Ricky can jump up to two tiles above him where the collision value equals $03
	; (only the bottom half of the tile is solid).

; Check that the tiles on ricky's left and right sides one tile up are clear
@tryOneTileUp:
	ld hl,@cliffOffset_oneUp_right		; $72c6
	call _specialObjectGetRelativeTileFromHl		; $72c9
	cp $03			; $72cc
	jr z,+			; $72ce
	ld a,b			; $72d0
	cp TILEINDEX_VINE_TOP			; $72d1
	jr nz,@tryTwoTilesUp	; $72d3
+
	ld hl,@cliffOffset_oneUp_left		; $72d5
	call _specialObjectGetRelativeTileFromHl		; $72d8
	cp $03			; $72db
	jr z,@canJumpUpCliff	; $72dd
	ld a,b			; $72df
	cp TILEINDEX_VINE_TOP			; $72e0
	jr z,@canJumpUpCliff	; $72e2

; Check that the tiles on ricky's left and right sides two tiles up are clear
@tryTwoTilesUp:
	ld hl,@cliffOffset_twoUp_right		; $72e4
	call _specialObjectGetRelativeTileFromHl		; $72e7
	cp $03			; $72ea
	jr z,+			; $72ec
	ld a,b			; $72ee
	cp TILEINDEX_VINE_TOP			; $72ef
	ret nz			; $72f1
+
	ld hl,@cliffOffset_twoUp_left		; $72f2
	call _specialObjectGetRelativeTileFromHl		; $72f5
	cp $03			; $72f8
	jr z,@canJumpUpCliff	; $72fa
	ld a,b			; $72fc
	cp TILEINDEX_VINE_TOP			; $72fd
	ret nz			; $72ff

@canJumpUpCliff:
	; State 2 handles jumping up a cliff
	ld e,SpecialObject.state		; $7300
	ld a,$02		; $7302
	ld (de),a		; $7304
	inc e			; $7305
	xor a			; $7306
	ld (de),a ; [state2] = 0

	ld e,SpecialObject.counter2		; $7308
	ld (de),a		; $730a
	ret			; $730b

; Offsets for the cliff tile that Ricky will be hopping up to

@cliffOffset_oneUp_right:
	.db $f8 $06
@cliffOffset_oneUp_left:
	.db $f8 $fa
@cliffOffset_twoUp_right:
	.db $e8 $06
@cliffOffset_twoUp_left:
	.db $e8 $fa


;;
; @addr{7314}
_rickyBreakTilesOnLanding:
	ld hl,@offsets		; $7314
@next:
	ldi a,(hl)		; $7317
	ld b,a			; $7318
	ldi a,(hl)		; $7319
	ld c,a			; $731a
	or b			; $731b
	ret z			; $731c
	push hl			; $731d
	ld a,(w1Companion.yh)		; $731e
	add b			; $7321
	ld b,a			; $7322
	ld a,(w1Companion.xh)		; $7323
	add c			; $7326
	ld c,a			; $7327
	ld a,BREAKABLETILESOURCE_10		; $7328
	call tryToBreakTile		; $732a
	pop hl			; $732d
	jr @next		; $732e

; Each row is a Y/X offset at which to attempt to break a tile when Ricky lands.
@offsets:
	.db $04 $00
	.db $04 $06
	.db $fe $00
	.db $04 $fa
	.db $00 $00


;;
; Seems to set variables for ricky's jump speed, etc, but the jump may still be cancelled
; after this?
; @addr{733a}
_rickyBeginJumpOverHole:
	ld a,$01		; $733a
	ld (wLinkInAir),a		; $733c

;;
; @addr{733f}
_rickySetJumpSpeed_andcc91:
	ld a,$01		; $733f
	ld (wDisableScreenTransitions),a		; $7341

;;
; Sets up Ricky's speed for long jumps across holes and cliffs.
; @addr{7344}
_rickySetJumpSpeed:
	ld bc,-$300		; $7344
	call objectSetSpeedZ		; $7347
	ld l,SpecialObject.counter1		; $734a
	ld (hl),$08		; $734c
	ld l,SpecialObject.speed		; $734e
	ld (hl),SPEED_140		; $7350
	ld c,$0f		; $7352
	call _companionSetAnimation		; $7354
	ld h,d			; $7357
	ret			; $7358

;;
; @param[out]	zflag	Set if Ricky's close to the screen edge
; @addr{7359}
_rickyCheckAtScreenEdge:
	ld h,d			; $7359
	ld l,SpecialObject.yh		; $735a
	ld a,$06		; $735c
	cp (hl)			; $735e
	jr nc,@outsideScreen	; $735f

	ld a,(wScreenTransitionBoundaryY)		; $7361
	dec a			; $7364
	cp (hl)			; $7365
	jr c,@outsideScreen	; $7366

	ld l,SpecialObject.xh		; $7368
	ld a,$06		; $736a
	cp (hl)			; $736c
	jr nc,@outsideScreen	; $736d

	ld a,(wScreenTransitionBoundaryX)		; $736f
	dec a			; $7372
	cp (hl)			; $7373
	jr c,@outsideScreen	; $7374

	xor a			; $7376
	ret			; $7377

@outsideScreen:
	or d			; $7378
	ret			; $7379

; Offsets relative to Ricky's position to check for holes to jump over
_rickyHoleCheckOffsets:
	.db $f8 $00
	.db $05 $08
	.db $08 $00
	.db $05 $f8


;;
; var38: nonzero if Dimitri is in water?
; @addr{7382}
_specialObjectCode_dimitri:
	call _companionRetIfInactive		; $7382
	call _companionFunc_47d8		; $7385
	call @runState		; $7388
	xor a			; $738b
	ld (wDimitriHitNpc),a		; $738c
	jp _companionCheckEnableTerrainEffects		; $738f

; Note: expects that h=d (call to _companionFunc_47d8 does this)
@runState:
	ld e,SpecialObject.state		; $7392
	ld a,(de)		; $7394
	rst_jumpTable			; $7395
	.dw _dimitriState0
	.dw _dimitriState1
	.dw _dimitriState2
	.dw _dimitriState3
	.dw _dimitriState4
	.dw _dimitriState5
	.dw _dimitriState6
	.dw _dimitriState7
	.dw _dimitriState8
	.dw _dimitriState9
	.dw _dimitriStateA
	.dw _dimitriStateB
	.dw _dimitriStateC
	.dw _dimitriStateD

;;
; State 0: initialization, deciding which state to go to
; @addr{73b2}
_dimitriState0:
	call _companionCheckCanSpawn		; $73b2

	ld a,DIR_DOWN		; $73b5
	ld l,SpecialObject.direction		; $73b7
	ldi (hl),a		; $73b9
	ld (hl),a ; [counter2] = $02

	ld a,(wDimitriState)		; $73bb
	bit 7,a			; $73be
	jr nz,@setAnimation	; $73c0
	bit 6,a			; $73c2
	jr nz,+			; $73c4
	and $20			; $73c6
	jr nz,@setAnimation	; $73c8
+
	ld a,GLOBALFLAG_SAVED_COMPANION_FROM_FOREST		; $73ca
	call checkGlobalFlag		; $73cc
	ld h,d			; $73cf
	ld c,$24		; $73d0
	jr z,+			; $73d2
	ld c,$1e		; $73d4
+
	ld l,SpecialObject.state		; $73d6
	ld (hl),$0a		; $73d8

	ld e,SpecialObject.var3d		; $73da
	call objectAddToAButtonSensitiveObjectList		; $73dc

	ld a,c			; $73df
	ld e,SpecialObject.var3f		; $73e0
	ld (de),a		; $73e2
	call specialObjectSetAnimation		; $73e3

	ld bc,$0408		; $73e6
	call objectSetCollideRadii		; $73e9
	jr @setVisible		; $73ec

@setAnimation:
	ld c,$1c		; $73ee
	call _companionSetAnimation		; $73f0
@setVisible:
	jp objectSetVisible81		; $73f3

;;
; State 1: waiting for Link to mount
; @addr{73f6}
_dimitriState1:
	call _companionSetPriorityRelativeToLink		; $73f6
	ld c,$40		; $73f9
	call objectUpdateSpeedZ_paramC		; $73fb
	ret nz			; $73fe

	; Is dimitri in a hole?
	call _companionCheckHazards		; $73ff
	jr nc,@onLand		; $7402
	cp $02			; $7404
	ret z			; $7406

	; No, he must be in water
	call _dimitriAddWaterfallResistance		; $7407
	ld a,$04		; $740a
	call _dimitriFunc_756d		; $740c
	jr ++			; $740f

@onLand:
	ld e,SpecialObject.var38		; $7411
	ld a,(de)		; $7413
	or a			; $7414
	jr z,++			; $7415
	xor a			; $7417
	ld (de),a		; $7418
	ld c,$1c		; $7419
	call _companionSetAnimation		; $741b
++
	ld a,$06		; $741e
	call objectSetCollideRadius		; $7420

	ld e,SpecialObject.var3b		; $7423
	ld a,(de)		; $7425
	or a			; $7426
	jp nz,_dimitriGotoState1IfLinkFarAway		; $7427

	ld c,$09		; $742a
	call objectCheckLinkWithinDistance		; $742c
	jp nc,_dimitriCheckAddToGrabbableObjectBuffer		; $742f
	jp _companionTryToMount		; $7432

;;
; State 2: curled into a ball (being held or thrown).
;
; The substates are generally controlled by power bracelet code (see "itemCode16").
;
; @addr{7435}
_dimitriState2:
	inc e			; $7435
	ld a,(de)		; $7436
	rst_jumpTable			; $7437
	.dw _dimitriState2Substate0
	.dw _dimitriState2Substate1
	.dw _dimitriState2Substate2
	.dw _dimitriState2Substate3

;;
; Substate 0: just grabbed
; @addr{7440}
_dimitriState2Substate0:
	ld a,$40		; $7440
	ld (wLinkGrabState2),a		; $7442
	call itemIncState2		; $7445
	xor a			; $7448
	ld (wcc90),a		; $7449

	ld l,SpecialObject.var38		; $744c
	ld (hl),a		; $744e
	ld l,$3f		; $744f
	ld (hl),$ff		; $7451

	call objectSetVisiblec0		; $7453

	ld a,$02		; $7456
	ld hl,wCompanionTutorialTextShown		; $7458
	call setFlag		; $745b

	ld c,$18		; $745e
	jp _companionSetAnimation		; $7460

;;
; Substate 1: being lifted, carried
; @addr{7463}
_dimitriState2Substate1:
	xor a			; $7463
	ld (w1Link.knockbackCounter),a		; $7464
	ld a,(wActiveTileType)		; $7467
	cp TILETYPE_NOTHING			; $746a
	jr nz,+			; $746c
	ld a,$20		; $746e
	ld (wStandingOnTileCounter),a		; $7470
+
	ld a,(wLinkClimbingVine)		; $7473
	or a			; $7476
	jr nz,@releaseDimitri	; $7477

	ld a,(w1Link.angle)		; $7479
	bit 7,a			; $747c
	jr nz,@update	; $747e

	ld e,SpecialObject.angle		; $7480
	ld (de),a		; $7482

	ld a,(w1Link.direction)		; $7483
	dec e			; $7486
	ld (de),a ; [direction] = [w1Link.direction]

	call _dimitriCheckCanBeHeldInDirection		; $7488
	jr nz,@update	; $748b

@releaseDimitri:
	ld h,d			; $748d
	ld l,$00		; $748e
	res 1,(hl)		; $7490
	ld l,$3b		; $7492
	ld (hl),$01		; $7494
	jp dropLinkHeldItem		; $7496

@update:
	; Check whether to prevent Link from throwing dimitri (write nonzero to wcc67)
	call _companionCalculateAdjacentWallsBitset		; $7499
	call _specialObjectCheckMovingTowardWall		; $749c
	ret z			; $749f
	ld (wcc67),a		; $74a0
	ret			; $74a3

;;
; Substate 2: dimitri released, falling to ground
; @addr{74a4}
_dimitriState2Substate2:
	ld h,d			; $74a4
	ld l,SpecialObject.enabled		; $74a5
	res 1,(hl)		; $74a7

	call _companionCheckHazards		; $74a9
	jr nc,@noHazard		; $74ac

	; Return if he's on a hole
	cp $02			; $74ae
	ret z			; $74b0
	jr @onHazard		; $74b1

@noHazard:
	ld h,d			; $74b3
	ld l,SpecialObject.var3f		; $74b4
	ld a,(hl)		; $74b6
	cp $ff			; $74b7
	jr nz,++		; $74b9

	; Set Link's current position as the spot to return to if Dimitri lands in water
	xor a			; $74bb
	ld (hl),a		; $74bc
	ld l,SpecialObject.var39		; $74bd
	ld a,(w1Link.yh)		; $74bf
	ldi (hl),a		; $74c2
	ld a,(w1Link.xh)		; $74c3
	ld (hl),a		; $74c6
++

; Check whether Dimitri should stop moving when thrown. Involves screen boundary checks.

	ld a,(wDimitriHitNpc)		; $74c7
	or a			; $74ca
	jr nz,@stopMovement	; $74cb

	call _companionCalculateAdjacentWallsBitset		; $74cd
	call _specialObjectCheckMovingTowardWall		; $74d0
	jr nz,@stopMovement	; $74d3

	ld c,$00		; $74d5
	ld h,d			; $74d7
	ld l,SpecialObject.yh		; $74d8
	ld a,(hl)		; $74da
	cp $08			; $74db
	jr nc,++		; $74dd
	ld (hl),$10		; $74df
	inc c			; $74e1
	jr @checkX		; $74e2
++
	ld a,(wActiveGroup)		; $74e4
	or a			; $74e7
	ld a,(hl)		; $74e8
	jr nz,@largeRoomYCheck	; $74e9
@smallRoomYCheck:
	cp SMALL_ROOM_HEIGHT*16-6
	jr c,@checkX			; $74ed
	ld (hl), SMALL_ROOM_HEIGHT*16-6
	inc c			; $74f1
	jr @checkX			; $74f2
@largeRoomYCheck:
	cp LARGE_ROOM_HEIGHT*16-8
	jr c,@checkX			; $74f6
	ld (hl), LARGE_ROOM_HEIGHT*16-8
	inc c			; $74fa
	jr @checkX			; $74fb

@checkX:
	ld l,SpecialObject.xh		; $74fd
	ld a,(hl)		; $74ff
	cp $04			; $7500
	jr nc,++		; $7502
	ld (hl),$04		; $7504
	inc c			; $7506
	jr @doneBoundsCheck		; $7507
++
	ld a,(wActiveGroup)		; $7509
	or a			; $750c
	ld a,(hl)		; $750d
	jr nz,@largeRoomXCheck	; $750e
@smallRoomXCheck:
	cp SMALL_ROOM_WIDTH*16-5			; $7510
	jr c,@doneBoundsCheck	; $7512
	ld (hl), SMALL_ROOM_WIDTH*16-5		; $7514
	inc c			; $7516
	jr @doneBoundsCheck		; $7517
@largeRoomXCheck:
	cp LARGE_ROOM_WIDTH*16-17			; $7519
	jr c,@doneBoundsCheck	; $751b
	ld (hl), LARGE_ROOM_WIDTH*16-17		; $751d
	inc c			; $751f

@doneBoundsCheck:
	ld a,c			; $7520
	or a			; $7521
	jr z,@checkOnHazard	; $7522

@stopMovement:
	ld a,SPEED_0		; $7524
	ld (w1ReservedItemC.speed),a		; $7526

@checkOnHazard:
	call objectCheckIsOnHazard		; $7529
	cp $01			; $752c
	ret nz			; $752e

@onHazard:
	ld h,d			; $752f
	ld l,SpecialObject.state		; $7530
	ld (hl),$0b		; $7532
	ld l,SpecialObject.var38		; $7534
	ld (hl),$04		; $7536

	; Calculate angle toward Link?
	ld l,SpecialObject.var39		; $7538
	ldi a,(hl)		; $753a
	ld c,(hl)		; $753b
	ld b,a			; $753c
	call objectGetRelativeAngle		; $753d
	and $18			; $7540
	ld e,SpecialObject.angle		; $7542
	ld (de),a		; $7544

	; Calculate direction based on angle
	add a			; $7545
	swap a			; $7546
	and $03			; $7548
	dec e			; $754a
	ld (de),a ; [direction] = a

	ld c,$00		; $754c
	jp _companionSetAnimation		; $754e

;;
; Substate 3: landed on ground for good
; @addr{7551}
_dimitriState2Substate3:
	ld h,d			; $7551
	ld l,SpecialObject.enabled		; $7552
	res 1,(hl)		; $7554

	ld c,$40		; $7556
	call objectUpdateSpeedZ_paramC		; $7558
	ret nz			; $755b
	call _companionTryToBreakTileFromMoving		; $755c
	call _companionCheckHazards		; $755f
	jr nc,@gotoState1	; $7562

	; If on a hole, return (stay in this state?)
	cp $02			; $7564
	ret z			; $7566

	; If in water, go to state 1, but with alternate value for var38?
	ld a,$04		; $7567
	jp _dimitriFunc_756d		; $7569

@gotoState1:
	xor a			; $756c

;;
; @param	a	Value for var38
; @addr{756d}
_dimitriFunc_756d:
	ld h,d			; $756d
	ld l,SpecialObject.var38		; $756e
	ld (hl),a		; $7570

	ld l,SpecialObject.state		; $7571
	ld a,$01		; $7573
	ldi (hl),a		; $7575
	ld (hl),$00 ; [state2] = 0

	ld c,$1c		; $7578
	jp _companionSetAnimation		; $757a

;;
; State 3: Link is jumping up to mount Dimitri
; @addr{757d}
_dimitriState3:
	call _companionCheckMountingComplete		; $757d
	ret nz			; $7580
	call _companionFinalizeMounting		; $7581
	ld c,$00		; $7584
	jp _companionSetAnimation		; $7586

;;
; State 4: Dimitri's falling into a hazard (hole/water)
; @addr{7589}
_dimitriState4:
	call _companionDragToCenterOfHole		; $7589
	ret nz			; $758c
	call _companionDecCounter1		; $758d
	jr nz,@animate		; $7590

	inc (hl)		; $7592
	ld a,SND_LINK_FALL		; $7593
	call playSound		; $7595
	ld a,$25		; $7598
	jp specialObjectSetAnimation		; $759a

@animate:
	call _companionAnimateDrowningOrFallingThenRespawn		; $759d
	ret nc			; $75a0
	ld c,$00		; $75a1
	jp _companionUpdateDirectionAndSetAnimation		; $75a3

;;
; State 5: Link riding dimitri.
; @addr{75a6}
_dimitriState5:
	ld c,$40		; $75a6
	call objectUpdateSpeedZ_paramC		; $75a8
	ret nz			; $75ab

	ld a,(wForceCompanionDismount)		; $75ac
	or a			; $75af
	jr nz,++		; $75b0
	ld a,(wGameKeysJustPressed)		; $75b2
	bit BTN_BIT_A,a			; $75b5
	jr nz,_dimitriGotoEatingState	; $75b7
	bit BTN_BIT_B,a			; $75b9
++
	jp nz,_companionGotoDismountState		; $75bb

	ld a,(wLinkAngle)		; $75be
	bit 7,a			; $75c1
	jr nz,_dimitriUpdateMovement@checkHazards	; $75c3

	; Check if angle changed, update direction if so
	ld hl,w1Companion.angle		; $75c5
	cp (hl)			; $75c8
	ld (hl),a		; $75c9
	ld c,$00		; $75ca
	jp nz,_companionUpdateDirectionAndAnimate		; $75cc

	; Return if he should hop down a cliff (state changed in function call)
	call _companionCheckHopDownCliff		; $75cf
	ret z			; $75d2

;;
; @addr{75d3}
_dimitriUpdateMovement:
	; Play sound effect when animation indicates to do so
	ld h,d			; $75d3
	ld l,SpecialObject.animParameter		; $75d4
	ld a,(hl)		; $75d6
	rlca			; $75d7
	ld a,SND_LINK_SWIM		; $75d8
	call c,playSound		; $75da

	; Determine speed
	ld l,SpecialObject.var38		; $75dd
	ld a,(hl)		; $75df
	or a			; $75e0
	ld a,SPEED_c0		; $75e1
	jr z,+			; $75e3
	ld a,SPEED_100		; $75e5
+
	ld l,SpecialObject.speed		; $75e7
	ld (hl),a		; $75e9
	call _companionUpdateMovement		; $75ea
	call specialObjectAnimate		; $75ed

@checkHazards:
	call _companionCheckHazards		; $75f0
	ld h,d			; $75f3
	jr nc,@setNotInWater	; $75f4

	; Return if the hazard is a hole
	cp $02			; $75f6
	ret z			; $75f8

	; If it's water, stay in state 5 (he can swim).
	ld l,SpecialObject.state		; $75f9
	ld (hl),$05		; $75fb

	ld a,(wLinkForceState)		; $75fd
	cp LINK_STATE_RESPAWNING			; $7600
	jr nz,++		; $7602
	xor a			; $7604
	ld (wLinkForceState),a		; $7605
	jp _companionGotoHazardHandlingState		; $7608
++
	call _dimitriAddWaterfallResistance		; $760b
	ld b,$04		; $760e
	jr @setWaterStatus		; $7610

@setNotInWater:
	ld b,$00		; $7612

@setWaterStatus:
	; Set var38 to value of "b", update animation if it changed
	ld l,SpecialObject.var38		; $7614
	ld a,(hl)		; $7616
	cp b			; $7617
	ld (hl),b		; $7618
	ld c,$00		; $7619
	jp nz,_companionUpdateDirectionAndSetAnimation		; $761b

;;
; @addr{761e}
_dimitriState9:
	ret			; $761e

;;
; @addr{761f}
_dimitriGotoEatingState:
	ld h,d			; $761f
	ld l,SpecialObject.state		; $7620
	ld a,$08		; $7622
	ldi (hl),a		; $7624
	xor a			; $7625
	ldi (hl),a ; [state2] = 0
	ld (hl),a  ; [counter1] = 0

	ld l,SpecialObject.var35		; $7628
	ld (hl),a		; $762a

	; Calculate angle based on direction
	ld l,SpecialObject.direction		; $762b
	ldi a,(hl)		; $762d
	swap a			; $762e
	rrca			; $7630
	ld (hl),a		; $7631

	ld a,$01		; $7632
	ld (wLinkInAir),a		; $7634
	ld l,SpecialObject.speed		; $7637
	ld (hl),SPEED_c0		; $7639
	ld c,$08		; $763b
	call _companionSetAnimation		; $763d
	ldbc ITEMID_DIMITRI_MOUTH, $00		; $7640
	call _companionCreateWeaponItem		; $7643

	ld a,SND_DIMITRI		; $7646
	jp playSound		; $7648

;;
; State 6: Link has dismounted; he can't remount until he moves a certain distance away,
; then comes back.
; @addr{764b}
_dimitriState6:
	ld e,SpecialObject.state2		; $764b
	ld a,(de)		; $764d
	rst_jumpTable			; $764e
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01		; $7655
	ld (de),a		; $7657
	call companionDismountAndSavePosition		; $7658
	ld c,$1c		; $765b
	jp _companionSetAnimation		; $765d

@substate1:
	ld a,(wLinkInAir)		; $7660
	or a			; $7663
	ret nz			; $7664
	jp itemIncState2		; $7665

@substate2:
	call _dimitriCheckAddToGrabbableObjectBuffer		; $7668

;;
; @addr{766b}
_dimitriGotoState1IfLinkFarAway:
	; Return if Link is too close
	ld c,$09		; $766b
	call objectCheckLinkWithinDistance		; $766d
	ret c			; $7670

;;
; @param[out]	a	0
; @param[out]	de	var3b
; @addr{7671}
_dimitriGotoState1:
	ld e,SpecialObject.state		; $7671
	ld a,$01		; $7673
	ld (de),a		; $7675
	inc e			; $7676
	xor a			; $7677
	ld (de),a ; [state2] = 0
	ld e,SpecialObject.var3b		; $7679
	ld (de),a		; $767b
	ret			; $767c

;;
; State 7: jumping down a cliff
; @addr{767d}
_dimitriState7:
	call _companionDecCounter1ToJumpDownCliff		; $767d
	ret c			; $7680
	call _companionCalculateAdjacentWallsBitset		; $7681
	call _specialObjectCheckMovingAwayFromWall		; $7684

	ld l,SpecialObject.counter2		; $7687
	jr z,+			; $7689
	ld (hl),a		; $768b
	ret			; $768c
+
	ld a,(hl)		; $768d
	or a			; $768e
	ret z			; $768f
	jp _dimitriLandOnGroundAndGotoState5		; $7690

;;
; State 8: Attempting to eat something
; @addr{7693}
_dimitriState8:
	ld e,SpecialObject.state2		; $7693
	ld a,(de)		; $7695
	rst_jumpTable			; $7696
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Substate 0: Moving forward for the bite
@substate0:
	call specialObjectAnimate		; $769d
	call objectApplySpeed		; $76a0
	ld e,SpecialObject.animParameter		; $76a3
	ld a,(de)		; $76a5
	rlca			; $76a6
	ret nc			; $76a7

	; Initialize stuff for substate 1 (moving back)

	call itemIncState2		; $76a8

	; Calculate angle based on the reverse of the current direction
	ld l,SpecialObject.direction		; $76ab
	ldi a,(hl)		; $76ad
	xor $02			; $76ae
	swap a			; $76b0
	rrca			; $76b2
	ld (hl),a		; $76b3

	ld l,SpecialObject.counter1		; $76b4
	ld (hl),$0c		; $76b6
	ld c,$00		; $76b8
	jp _companionSetAnimation		; $76ba

; Substate 1: moving back
@substate1:
	call specialObjectAnimate		; $76bd
	call objectApplySpeed		; $76c0
	call _companionDecCounter1IfNonzero		; $76c3
	ret nz			; $76c6

	; Done moving back

	ld (hl),$14		; $76c7

	; Fix angle to be consistent with direction
	ld l,SpecialObject.direction		; $76c9
	ldi a,(hl)		; $76cb
	swap a			; $76cc
	rrca			; $76ce
	ld (hl),a		; $76cf

	; Check if he swallowed something; if so, go to substate 2, otherwise resume
	; normal movement.
	ld l,SpecialObject.var35		; $76d0
	ld a,(hl)		; $76d2
	or a			; $76d3
	jp z,_dimitriLandOnGroundAndGotoState5		; $76d4
	call itemIncState2		; $76d7
	ld c,$10		; $76da
	jp _companionSetAnimation		; $76dc

; Substate 2: swallowing something
@substate2:
	call specialObjectAnimate		; $76df
	call _companionDecCounter1IfNonzero		; $76e2
	ret nz			; $76e5
	jr _dimitriLandOnGroundAndGotoState5		; $76e6

;;
; State B: swimming back to land after being thrown into water
; @addr{76e8}
_dimitriStateB:
	ld c,$40		; $76e8
	call objectUpdateSpeedZ_paramC		; $76ea
	ret nz			; $76ed

	call _dimitriUpdateMovement		; $76ee

	; Set state to $01 if he's out of the water; stay in $0b otherwise
	ld h,d			; $76f1
	ld l,SpecialObject.var38		; $76f2
	ld a,(hl)		; $76f4
	or a			; $76f5
	ld l,SpecialObject.state		; $76f6
	ld (hl),$0b		; $76f8
	ret nz			; $76fa
	ld (hl),$01		; $76fb
	ret			; $76fd

;;
; State C: Dimitri entering screen from flute call
; @addr{76fe}
_dimitriStateC:
	ld e,SpecialObject.var03		; $76fe
	ld a,(de)		; $7700
	rst_jumpTable			; $7701
	.dw @parameter0
	.dw @parameter1

; substate 0: dimitri just spawned?
@parameter0:
	call _companionInitializeOnEnteringScreen		; $7706
	ld (hl),$3c ; [counter2] = $3c

	ld a,SND_DIMITRI		; $770b
	call playSound		; $770d
	ld c,$00		; $7710
	jp _companionSetAnimation		; $7712

; substate 1: walking in
@parameter1:
	call _dimitriUpdateMovement		; $7715
	ld e,SpecialObject.state		; $7718
	ld a,$0c		; $771a
	ld (de),a		; $771c

	ld hl,_dimitriTileOffsets		; $771d
	call _companionRetIfNotFinishedWalkingIn		; $7720

	; Done walking into screen; jump to state 0
	ld e,SpecialObject.var03		; $7723
	xor a			; $7725
	ld (de),a		; $7726
	jp _dimitriState0		; $7727

;;
; State D: ? (set to this by INTERACID_CARPENTER subid $ff?)
; @addr{772a}
_dimitriStateD:
	ld e,SpecialObject.var3c		; $772a
	ld a,(de)		; $772c
	or a			; $772d
	jr nz,++		; $772e

	call _dimitriGotoState1		; $7730
	inc a			; $7733
	ld (de),a ; [var3b] = 1

	ld hl,w1Companion.enabled		; $7735
	res 1,(hl)		; $7738
	ld c,$1c		; $773a
	jp _companionSetAnimation		; $773c
++
	ld e,SpecialObject.state		; $773f
	ld a,$05		; $7741
	ld (de),a		; $7743

;;
; @addr{7744}
_dimitriLandOnGroundAndGotoState5:
	xor a			; $7744
	ld (wLinkInAir),a		; $7745
	ld c,$00		; $7748
	jp _companionSetAnimationAndGotoState5		; $774a

;;
; State A: cutscene-related stuff
; @addr{774d}
_dimitriStateA:
	ld e,SpecialObject.var03		; $774d
	ld a,(de)		; $774f
	rst_jumpTable			; $7750
	.dw _dimitriStateASubstate0
	.dw _dimitriStateASubstate1
	.dw _dimitriStateASubstate2
	.dw _dimitriStateASubstate3
	.dw _dimitriStateASubstate4

;;
; Force mounting Dimitri?
; @addr{775b}
_dimitriStateASubstate0:
	ld e,SpecialObject.var3d		; $775b
	ld a,(de)		; $775d
	or a			; $775e
	jr z,+			; $775f
	ld a,$81		; $7761
	ld (wDisabledObjects),a		; $7763
+
	call _companionSetAnimationToVar3f		; $7766
	call _companionPreventLinkFromPassing_noExtraChecks		; $7769
	call specialObjectAnimate		; $776c

	ld e,SpecialObject.visible		; $776f
	ld a,$c7		; $7771
	ld (de),a		; $7773

	ld a,(wDimitriState)		; $7774
	and $80			; $7777
	ret z			; $7779

	ld e,SpecialObject.visible		; $777a
	ld a,$c1		; $777c
	ld (de),a		; $777e

	ld a,$ff		; $777f
	ld (wStatusBarNeedsRefresh),a		; $7781
	ld c,$1c		; $7784
	call _companionSetAnimation		; $7786
	jp _companionForceMount		; $7789

;;
; Force mounting dimitri?
; @addr{778c}
_dimitriStateASubstate1:
	ld e,SpecialObject.var3d		; $778c
	call objectRemoveFromAButtonSensitiveObjectList		; $778e
	ld c,$1c		; $7791
	call _companionSetAnimation		; $7793
	jp _companionForceMount		; $7796

;;
; Dimitri begins parting upon reaching mainland?
; @addr{7799}
_dimitriStateASubstate3:
	ld e,SpecialObject.direction		; $7799
	ld a,DIR_RIGHT		; $779b
	ld (de),a		; $779d
	inc e			; $779e
	ld a,$08		; $779f
	ld (de),a ; [angle] = $08

	ld c,$00		; $77a2
	call _companionSetAnimation		; $77a4
	ld e,SpecialObject.var03		; $77a7
	ld a,$04		; $77a9
	ld (de),a		; $77ab

	ld a,SND_DIMITRI		; $77ac
	jp playSound		; $77ae

;;
; Dimitri moving until he goes off-screen
; @addr{77b1}
_dimitriStateASubstate4:
	call _dimitriUpdateMovement		; $77b1

	ld e,SpecialObject.state		; $77b4
	ld a,$0a		; $77b6
	ld (de),a		; $77b8

	call objectCheckWithinScreenBoundary		; $77b9
	ret c			; $77bc

	xor a			; $77bd
	ld (wDisabledObjects),a		; $77be
	ld (wMenuDisabled),a		; $77c1
	ld (wUseSimulatedInput),a		; $77c4
	jp itemDelete		; $77c7

;;
; Force dismount Dimitri
; @addr{77ca}
_dimitriStateASubstate2:
	ld a,(wLinkObjectIndex)		; $77ca
	cp >w1Companion			; $77cd
	ret nz			; $77cf
	call companionDismountAndSavePosition		; $77d0
	xor a			; $77d3
	ld (wRememberedCompanionId),a		; $77d4
	ret			; $77d7


;;
; @addr{77d8}
_dimitriCheckAddToGrabbableObjectBuffer:
	ld a,(wLinkClimbingVine)		; $77d8
	or a			; $77db
	ret nz			; $77dc
	ld a,(w1Link.direction)		; $77dd
	call _dimitriCheckCanBeHeldInDirection		; $77e0
	ret z			; $77e3

	; Check the collisions at Link's position
	ld hl,w1Link.yh		; $77e4
	ld b,(hl)		; $77e7
	ld l,<w1Link.xh		; $77e8
	ld c,(hl)		; $77ea
	call getTileCollisionsAtPosition		; $77eb

	; Disallow cave entrances (top half solid)?
	cp $0c			; $77ee
	jr z,@ret	; $77f0

	; Disallow if Link's on a fully solid tile?
	cp $0f			; $77f2
	jr z,@ret	; $77f4

	cp SPECIALCOLLISION_VERTICAL_BRIDGE			; $77f6
	jr z,@ret	; $77f8
	cp SPECIALCOLLISION_HORIZONTAL_BRIDGE			; $77fa
	call nz,objectAddToGrabbableObjectBuffer		; $77fc
@ret:
	ret			; $77ff

;;
; Checks the tiles in front of Dimitri to see if he can be held?
; (if moving diagonally, it checks both directions, and fails if one is impassable).
;
; This seems to disallow holding him on small bridges and cave entrances.
;
; @param	a	Direction that Link/Dimitri's moving toward
; @param[out]	zflag	Set if one of the tiles in front are not passable.
; @addr{7800}
_dimitriCheckCanBeHeldInDirection:
	call @checkTile		; $7800
	ret z			; $7803

	ld hl,w1Link.angle		; $7804
	ldd a,(hl)		; $7807
	bit 7,a			; $7808
	ret nz			; $780a
	bit 2,a			; $780b
	jr nz,@diagonalMovement			; $780d

	or d			; $780f
	ret			; $7810

@diagonalMovement:
	; Calculate the other direction being moved in
	add a			; $7811
	ld b,a			; $7812
	ldi a,(hl) ; a = [direction]
	swap a			; $7814
	srl a			; $7816
	xor b			; $7818
	add a			; $7819
	swap a			; $781a
	and $03			; $781c

;;
; @param	a	Direction
; @param[out]	zflag	Set if the tile in that direction is not ok for holding dimitri?
; @addr{781e}
@checkTile:
	ld hl,_dimitriTileOffsets		; $781e
	rst_addDoubleIndex			; $7821
	ldi a,(hl)		; $7822
	ld c,(hl)		; $7823
	ld b,a			; $7824
	call objectGetRelativeTile		; $7825

	cp TILEINDEX_VINE_BOTTOM			; $7828
	ret z			; $782a
	cp TILEINDEX_VINE_MIDDLE			; $782b
	ret z			; $782d
	cp TILEINDEX_VINE_TOP			; $782e
	ret z			; $7830

	; Only disallow tiles where the top half is solid? (cave entrances?
	ld h,>wRoomCollisions		; $7831
	ld a,(hl)		; $7833
	cp $0c			; $7834
	ret z			; $7836

	cp SPECIALCOLLISION_VERTICAL_BRIDGE			; $7837
	ret z			; $7839
	cp SPECIALCOLLISION_HORIZONTAL_BRIDGE			; $783a
	ret			; $783c

;;
; Moves Dimitri down if he's on a waterfall
; @addr{783d}
_dimitriAddWaterfallResistance:
	call objectGetTileAtPosition		; $783d
	ld h,d			; $7840
	cp TILEINDEX_WATERFALL			; $7841
	jr z,+			; $7843
	cp TILEINDEX_WATERFALL_BOTTOM			; $7845
	ret nz			; $7847
+
	; Move y-position down the waterfall (acts as resistance)
	ld l,SpecialObject.y		; $7848
	ld a,(hl)		; $784a
	add $c0			; $784b
	ldi (hl),a		; $784d
	ld a,(hl)		; $784e
	adc $00			; $784f
	ld (hl),a		; $7851

	; Check if we should start a screen transition based on downward waterfall
	; movement
	ld a,(wScreenTransitionBoundaryY)		; $7852
	cp (hl)			; $7855
	ret nc			; $7856
	ld a,$82		; $7857
	ld (wScreenTransitionDirection),a		; $7859
	ret			; $785c

_dimitriTileOffsets:
	.db $f8 $00 ; DIR_UP
	.db $00 $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT

;;
; @addr{7865}
_specialObjectCode_moosh:
	call _companionRetIfInactive		; $7865
	call _companionFunc_47d8		; $7868
	call @runState		; $786b
	jp _companionCheckEnableTerrainEffects		; $786e

@runState:
	ld e,SpecialObject.state		; $7871
	ld a,(de)		; $7873
	rst_jumpTable			; $7874
	.dw _mooshState0
	.dw _mooshState1
	.dw _mooshState2
	.dw _mooshState3
	.dw _mooshState4
	.dw _mooshState5
	.dw _mooshState6
	.dw _mooshState7
	.dw _mooshState8
	.dw _mooshState9
	.dw _mooshStateA
	.dw _mooshStateB
	.dw _mooshStateC

;;
; State 0: initialization
; @addr{788f}
_mooshState0:
	call _companionCheckCanSpawn		; $788f
	ld a,$06		; $7892
	call objectSetCollideRadius		; $7894

	ld a,DIR_DOWN		; $7897
	ld l,SpecialObject.direction		; $7899
	ldi (hl),a		; $789b
	ldi (hl),a ; [angle] = $02

	ld hl,wMooshState		; $789d
	ld a,$80		; $78a0
	and (hl)		; $78a2
	jr nz,@setAnimation	; $78a3

	; Check for the screen with the bridge near the forest?
	ld a,(wActiveRoom)		; $78a5
	cp $54			; $78a8
	jr z,@gotoCutsceneStateA	; $78aa

	ld a,$20		; $78ac
	and (hl)		; $78ae
	jr z,@gotoCutsceneStateA	; $78af
	ld a,$40		; $78b1
	and (hl)		; $78b3
	jr nz,@gotoCutsceneStateA	; $78b4

	; Check for the room where Moosh leaves after obtaining cheval's rope
	ld a,TREASURE_CHEVAL_ROPE		; $78b6
	call checkTreasureObtained		; $78b8
	jr nc,@setAnimation	; $78bb
	ld a,(wActiveRoom)		; $78bd
	cp $6b			; $78c0
	jr nz,@setAnimation	; $78c2

@gotoCutsceneStateA:
	ld e,SpecialObject.state		; $78c4
	ld a,$0a		; $78c6
	ld (de),a		; $78c8
	jp _mooshStateA		; $78c9

@setAnimation:
	ld c,$01		; $78cc
	call _companionSetAnimation		; $78ce
	jp objectSetVisiblec1		; $78d1

;;
; State 1: waiting for Link to mount
; @addr{78d4}
_mooshState1:
	call _companionSetPriorityRelativeToLink		; $78d4
	call specialObjectAnimate		; $78d7

	ld c,$09		; $78da
	call objectCheckLinkWithinDistance		; $78dc
	jp c,_companionTryToMount		; $78df

;;
; @addr{78e2}
_mooshCheckHazards:
	call _companionCheckHazards		; $78e2
	ret nc			; $78e5
	jr _mooshSetVar37ForHazard		; $78e6

;;
; State 3: Link is currently jumping up to mount Moosh
; @addr{78e8}
_mooshState3:
	call _companionCheckMountingComplete		; $78e8
	ret nz			; $78eb
	call _companionFinalizeMounting		; $78ec
	ld c,$13		; $78ef
	jp _companionSetAnimation		; $78f1

;;
; State 4: Moosh falling into a hazard (hole/water)
; @addr{78f4}
_mooshState4:
	ld h,d			; $78f4
	ld l,SpecialObject.collisionType		; $78f5
	set 7,(hl)		; $78f7

	; Check if the hazard is water
	ld l,SpecialObject.var37		; $78f9
	ld a,(hl)		; $78fb
	cp $0d
	jr z,++			; $78fe

	; No, it's a hole
	ld a,$0e		; $7900
	ld (hl),a		; $7902
	call _companionDragToCenterOfHole		; $7903
	ret nz			; $7906
++
	call _companionDecCounter1		; $7907
	jr nz,@animate	; $790a

	; Set falling/drowning animation, play falling sound if appropriate
	dec (hl)		; $790c
	ld l,SpecialObject.var37		; $790d
	ld a,(hl)		; $790f
	call specialObjectSetAnimation		; $7910

	ld e,SpecialObject.var37		; $7913
	ld a,(de)		; $7915
	cp $0d ; Is this water?
	jr z,@animate	; $7918

	ld a,SND_LINK_FALL		; $791a
	jp playSound		; $791c

@animate:
	call _companionAnimateDrowningOrFallingThenRespawn		; $791f
	ret nc			; $7922
	ld c,$13		; $7923
	ld a,(wLinkObjectIndex)		; $7925
	rrca			; $7928
	jr c,+			; $7929
	ld c,$01		; $792b
+
	jp _companionUpdateDirectionAndSetAnimation		; $792d

;;
; @addr{7930}
_mooshTryToBreakTileFromMovingAndCheckHazards:
	call _companionTryToBreakTileFromMoving		; $7930
	call _companionCheckHazards		; $7933
	ld c,$13		; $7936
	jp nc,_companionUpdateDirectionAndAnimate		; $7938

;;
; @addr{793b}
_mooshSetVar37ForHazard:
	dec a			; $793b
	ld c,$0d		; $793c
	jr z,+			; $793e
	ld c,$0e		; $7940
+
	ld e,SpecialObject.var37		; $7942
	ld a,c			; $7944
	ld (de),a		; $7945
	ld e,SpecialObject.counter1		; $7946
	xor a			; $7948
	ld (de),a		; $7949
	ret			; $794a

;;
; State 5: Link riding Moosh.
; @addr{794b}
_mooshState5:
	ld c,$10		; $794b
	call objectUpdateSpeedZ_paramC		; $794d
	ret nz			; $7950

	call _companionCheckHazards		; $7951
	jr c,_mooshSetVar37ForHazard	; $7954

	ld a,(wForceCompanionDismount)		; $7956
	or a			; $7959
	jr nz,++		; $795a
	ld a,(wGameKeysJustPressed)		; $795c
	bit BTN_BIT_A,a			; $795f
	jr nz,_mooshPressedAButton	; $7961
	bit BTN_BIT_B,a			; $7963
++
	jp nz,_companionGotoDismountState		; $7965

	; Return if not attempting to move
	ld a,(wLinkAngle)		; $7968
	bit 7,a			; $796b
	ret nz			; $796d

	; Update angle, and animation if the angle changed
	ld hl,w1Companion.angle		; $796e
	cp (hl)			; $7971
	ld (hl),a		; $7972
	ld c,$13		; $7973
	jp nz,_companionUpdateDirectionAndAnimate		; $7975

	call _companionCheckHopDownCliff		; $7978
	ret z			; $797b

	ld e,SpecialObject.speed		; $797c
	ld a,SPEED_100		; $797e
	ld (de),a		; $7980
	call _companionUpdateMovement		; $7981

	jr _mooshTryToBreakTileFromMovingAndCheckHazards		; $7984

;;
; @addr{7986}
_mooshLandOnGroundAndGotoState5:
	xor a			; $7986
	ld (wLinkInAir),a		; $7987
	ld c,$13		; $798a
	jp _companionSetAnimationAndGotoState5		; $798c

;;
; @addr{798f}
_mooshPressedAButton:
	ld a,$08		; $798f
	ld e,SpecialObject.state		; $7991
	ld (de),a		; $7993
	inc e			; $7994
	xor a			; $7995
	ld (de),a		; $7996
	ld a,SND_JUMP		; $7997
	call playSound		; $7999

;;
; @addr{799c}
_mooshState2:
_mooshState9:
_mooshStateB:
	ret			; $799c

;;
; State 8: floating in air, possibly performing buttstomp
; @addr{799d}
_mooshState8:
	ld e,SpecialObject.state2		; $799d
	ld a,(de)		; $799f
	rst_jumpTable			; $79a0
	.dw _mooshState8Substate0
	.dw _mooshState8Substate1
	.dw _mooshState8Substate2
	.dw _mooshState8Substate3
	.dw _mooshState8Substate4
	.dw _mooshState8Substate5

;;
; Substate 0: just pressed A button
; @addr{79ad}
_mooshState8Substate0:
	ld a,$01		; $79ad
	ld (de),a ; [state2] = 1

	ld bc,-$140		; $79b0
	call objectSetSpeedZ		; $79b3
	ld l,SpecialObject.speed		; $79b6
	ld (hl),SPEED_100		; $79b8

	ld l,SpecialObject.var39		; $79ba
	ld a,$04		; $79bc
	ldi (hl),a		; $79be
	xor a			; $79bf
	ldi (hl),a ; [var3a] = 0
	ldi (hl),a ; [var3b] = 0

	ld c,$09		; $79c2
	jp _companionSetAnimation		; $79c4

;;
; Substate 1: floating in air
; @addr{79c7}
_mooshState8Substate1:
	; Check if over water
	call objectCheckIsOverHazard		; $79c7
	cp $01			; $79ca
	jr nz,@notOverWater	; $79cc

; He's over water; go to substate 5.

	ld bc,$0000		; $79ce
	call objectSetSpeedZ		; $79d1

	ld l,SpecialObject.state2		; $79d4
	ld (hl),$05		; $79d6

	ld b,INTERACID_EXCLAMATION_MARK		; $79d8
	call objectCreateInteractionWithSubid00		; $79da

	; Subtract new interaction's zh by $20 (should be above moosh)
	dec l			; $79dd
	ld a,(hl)		; $79de
	sub $20			; $79df
	ld (hl),a		; $79e1

	ld l,Interaction.counter1		; $79e2
	ld e,SpecialObject.counter1		; $79e4
	ld a,$3c		; $79e6
	ld (hl),a ; [Interaction.counter1] = $3c
	ld (de),a ; [Moosh.counter1] = $3c
	ret			; $79ea

@notOverWater:
	ld a,(wLinkAngle)		; $79eb
	bit 7,a			; $79ee
	jr nz,+			; $79f0
	ld hl,w1Companion.angle		; $79f2
	cp (hl)			; $79f5
	ld (hl),a		; $79f6
	call _companionUpdateMovement		; $79f7
+
	ld e,SpecialObject.speedZ+1		; $79fa
	ld a,(de)		; $79fc
	rlca			; $79fd
	jr c,@movingUp	; $79fe

; Moosh is moving down (speedZ is positive or 0).

	; Increment var3b once for every frame A is held (or set to 0 if A is released).
	ld e,SpecialObject.var3b		; $7a00
	ld a,(wGameKeysPressed)		; $7a02
	and BTN_A			; $7a05
	jr z,+			; $7a07
	ld a,(de)		; $7a09
	inc a			; $7a0a
+
	ld (de),a		; $7a0b

	; Start charging stomp after A is held for 10 frames
	cp $0a			; $7a0c
	jr nc,@gotoSubstate2	; $7a0e

	; If pressed A, flutter in the air.
	ld a,(wGameKeysJustPressed)		; $7a10
	bit BTN_BIT_A,a			; $7a13
	jr z,@label_05_444	; $7a15

	; Don't allow him to flutter more than 16 times.
	ld e,SpecialObject.var3a		; $7a17
	ld a,(de)		; $7a19
	cp $10			; $7a1a
	jr z,@label_05_444	; $7a1c

	; [var3a] += 1 (counter for number of times he's fluttered)
	inc a			; $7a1e
	ld (de),a		; $7a1f

	; [var39] += 8 (ignore gravity for 8 more frames)
	dec e			; $7a20
	ld a,(de)		; $7a21
	add $08			; $7a22
	ld (de),a		; $7a24

	ld e,SpecialObject.animCounter		; $7a25
	ld a,$01		; $7a27
	ld (de),a		; $7a29
	call specialObjectAnimate		; $7a2a
	ld a,SND_JUMP		; $7a2d
	call playSound		; $7a2f

@label_05_444:
	ld e,SpecialObject.var39		; $7a32
	ld a,(de)		; $7a34
	or a			; $7a35
	jr z,@updateMovement	; $7a36

	; [var39] -= 1
	dec a			; $7a38
	ld (de),a		; $7a39

	ld e,SpecialObject.animCounter		; $7a3a
	ld a,$0f		; $7a3c
	ld (de),a		; $7a3e
	ld c,$09		; $7a3f
	jp _companionUpdateDirectionAndAnimate		; $7a41

@movingUp:
	ld c,$09		; $7a44
	call _companionUpdateDirectionAndAnimate		; $7a46

@updateMovement:
	ld c,$10		; $7a49
	call objectUpdateSpeedZ_paramC		; $7a4b
	ret nz			; $7a4e
	call _companionTryToBreakTileFromMoving		; $7a4f
	call _mooshLandOnGroundAndGotoState5		; $7a52
	jp _mooshTryToBreakTileFromMovingAndCheckHazards		; $7a55

@gotoSubstate2:
	jp itemIncState2		; $7a58

;;
; Substate 2: charging buttstomp
; @addr{7a5b}
_mooshState8Substate2:
	call specialObjectAnimate		; $7a5b

	ld a,(wGameKeysPressed)		; $7a5e
	bit BTN_BIT_A,a			; $7a61
	jr z,@gotoNextSubstate	; $7a63

	ld e,SpecialObject.var3b		; $7a65
	ld a,(de)		; $7a67
	cp 40			; $7a68
	jr c,+			; $7a6a
	ld c,$02		; $7a6c
	call _companionFlashFromChargingAnimation		; $7a6e
+
	ld e,SpecialObject.var3b		; $7a71
	ld a,(de)		; $7a73
	inc a			; $7a74
	ld (de),a		; $7a75

	; Check if it's finished charging
	cp 40			; $7a76
	ret c			; $7a78
	ld a,SND_CHARGE_SWORD		; $7a79
	jp z,playSound		; $7a7b

	; Reset bit 7 on w1Link.collisionType and w1Companion.collisionType (disable
	; collisions?)
	ld hl,w1Link.collisionType		; $7a7e
	res 7,(hl)		; $7a81
	inc h			; $7a83
	res 7,(hl)		; $7a84

	; Force the buttstomp to release after 120 frames of charging
	ld e,SpecialObject.var3b		; $7a86
	ld a,(de)		; $7a88
	cp 120			; $7a89
	ret nz			; $7a8b

@gotoNextSubstate:
	ld hl,w1Link.oamFlagsBackup		; $7a8c
	ldi a,(hl)		; $7a8f
	ld (hl),a ; [w1Link.oamFlags] = [w1Link.oamFlagsBackup]

	call itemIncState2		; $7a91
	ld c,$17		; $7a94

	; Set buttstomp animation if he's charged up enough
	ld e,SpecialObject.var3b		; $7a96
	ld a,(de)		; $7a98
	cp 40			; $7a99
	ret c			; $7a9b
	jp _companionSetAnimation		; $7a9c

;;
; Substate 3: falling to ground with buttstomp attack (or cancelling buttstomp)
; @addr{7a9f}
_mooshState8Substate3:
	ld c,$80		; $7a9f
	call objectUpdateSpeedZ_paramC		; $7aa1
	ret nz			; $7aa4

; Reached the ground

	ld e,SpecialObject.var3b		; $7aa5
	ld a,(de)		; $7aa7
	cp 40			; $7aa8
	jr nc,+			; $7aaa

	; Buttstomp not charged; just land on the ground
	call _mooshLandOnGroundAndGotoState5		; $7aac
	jp _mooshTryToBreakTileFromMovingAndCheckHazards		; $7aaf
+
	; Buttstomp charged; unleash the attack
	call _companionCheckHazards		; $7ab2
	jp c,_mooshSetVar37ForHazard		; $7ab5

	call itemIncState2		; $7ab8

	ld a,$0f		; $7abb
	ld (wScreenShakeCounterY),a		; $7abd

	ld a,SNDCTRL_STOPSFX		; $7ac0
	call playSound		; $7ac2
	ld a,SND_SCENT_SEED		; $7ac5
	call playSound		; $7ac7

	ld a,$05		; $7aca
	ld hl,wCompanionTutorialTextShown		; $7acc
	call setFlag		; $7acf

	ldbc ITEMID_28, $00		; $7ad2
	jp _companionCreateWeaponItem		; $7ad5

;;
; Substate 4: sitting on the ground briefly after buttstomp attack
; @addr{7ad8}
_mooshState8Substate4:
	call specialObjectAnimate		; $7ad8
	ld e,SpecialObject.animParameter		; $7adb
	ld a,(de)		; $7add
	rlca			; $7ade
	ret nc			; $7adf

	; Set bit 7 on w1Link.collisionType and w1Companion.collisionType (enable
	; collisions?)
	ld hl,w1Link.collisionType		; $7ae0
	set 7,(hl)		; $7ae3
	inc h			; $7ae5
	set 7,(hl)		; $7ae6

	jp _mooshLandOnGroundAndGotoState5		; $7ae8

;;
; Substate 5: Moosh is over water, in the process of falling down.
; @addr{7aeb}
_mooshState8Substate5:
	call _companionDecCounter1IfNonzero		; $7aeb
	jr z,+			; $7aee
	jp specialObjectAnimate		; $7af0
+
	ld c,$10		; $7af3
	call objectUpdateSpeedZ_paramC		; $7af5
	ret nz			; $7af8
	call _mooshLandOnGroundAndGotoState5		; $7af9
	jp _mooshTryToBreakTileFromMovingAndCheckHazards		; $7afc

;;
; State 6: Link has dismounted; he can't remount until he moves a certain distance away,
; then comes back.
; @addr{7aff}
_mooshState6:
	ld e,SpecialObject.state2		; $7aff
	ld a,(de)		; $7b01
	rst_jumpTable			; $7b02
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01		; $7b09
	ld (de),a		; $7b0b
	call companionDismountAndSavePosition		; $7b0c
	ld c,$01		; $7b0f
	jp _companionSetAnimation		; $7b11

@substate1:
	ld a,(wLinkInAir)		; $7b14
	or a			; $7b17
	ret nz			; $7b18
	jp itemIncState2		; $7b19

@substate2:
	ld c,$09		; $7b1c
	call objectCheckLinkWithinDistance		; $7b1e
	jp c,_mooshCheckHazards		; $7b21

	ld e,SpecialObject.state2		; $7b24
	xor a			; $7b26
	ld (de),a		; $7b27
	dec e			; $7b28
	ld a,$01		; $7b29
	ld (de),a ; [state] = $01 (waiting for Link to mount)
	ret			; $7b2c

;;
; State 7: jumping down a cliff
; @addr{7b2d}
_mooshState7:
	call _companionDecCounter1ToJumpDownCliff		; $7b2d
	jr nc,+		; $7b30
	ret nz			; $7b32
	ld c,$09		; $7b33
	jp _companionSetAnimation		; $7b35
+
	call _companionCalculateAdjacentWallsBitset		; $7b38
	call _specialObjectCheckMovingAwayFromWall		; $7b3b
	ld e,$07		; $7b3e
	jr z,+			; $7b40
	ld (de),a		; $7b42
	ret			; $7b43
+
	ld a,(de)		; $7b44
	or a			; $7b45
	ret z			; $7b46
	jp _mooshLandOnGroundAndGotoState5		; $7b47

;;
; State C: Moosh entering from a flute call
; @addr{7b4a}
_mooshStateC:
	ld e,SpecialObject.var03		; $7b4a
	ld a,(de)		; $7b4c
	rst_jumpTable			; $7b4d
	.dw @substate0
	.dw @substate1

@substate0:
	call _companionInitializeOnEnteringScreen		; $7b52
	ld (hl),$3c ; [counter2] = $3c
	ld a,SND_MOOSH		; $7b57
	call playSound		; $7b59
	ld c,$0f		; $7b5c
	jp _companionSetAnimation		; $7b5e

@substate1:
	call specialObjectAnimate		; $7b61

	ld e,SpecialObject.speed		; $7b64
	ld a,SPEED_c0		; $7b66
	ld (de),a		; $7b68

	call _companionUpdateMovement		; $7b69
	ld hl,@mooshDirectionOffsets		; $7b6c
	call _companionRetIfNotFinishedWalkingIn		; $7b6f
	ld e,SpecialObject.var03		; $7b72
	xor a			; $7b74
	ld (de),a		; $7b75
	jp _mooshState0		; $7b76

@mooshDirectionOffsets:
	.db $f8 $00 ; DIR_UP
	.db $00 $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT


;;
; State A: cutscene stuff
; @addr{7b81}
_mooshStateA:
	ld e,SpecialObject.var03		; $7b81
	ld a,(de)		; $7b83
	rst_jumpTable			; $7b84
	.dw @mooshStateASubstate0
	.dw _mooshStateASubstate1
	.dw @mooshStateASubstate2
	.dw _mooshStateASubstate3
	.dw _mooshStateASubstate4
	.dw _mooshStateASubstate5
	.dw _mooshStateASubstate6

;;
; @addr{7b93}
@mooshStateASubstate0:
	ld a,$01 ; [var03] = $01
	ld (de),a		; $7b95

	ld hl,wMooshState		; $7b96
	ld a,$20		; $7b99
	and (hl)		; $7b9b
	jr z,@label_05_454	; $7b9c

	ld a,$40		; $7b9e
	and (hl)		; $7ba0
	jr z,@label_05_456	; $7ba1

;;
; @addr{7ba3}
@mooshStateASubstate2:
	ld a,$01		; $7ba3
	ld (de),a ; [var03] = $01

	ld e,SpecialObject.var3d		; $7ba6
	call objectAddToAButtonSensitiveObjectList		; $7ba8

@label_05_454:
	ld a,GLOBALFLAG_SAVED_COMPANION_FROM_FOREST		; $7bab
	call checkGlobalFlag		; $7bad
	ld a,$00		; $7bb0
	jr z,+			; $7bb2
	ld a,$03		; $7bb4
+
	ld e,SpecialObject.var3f		; $7bb6
	ld (de),a		; $7bb8
	call specialObjectSetAnimation		; $7bb9
	jp objectSetVisiblec3		; $7bbc

@label_05_456:
	ld a,$01		; $7bbf
	ld (wMenuDisabled),a		; $7bc1
	ld (wDisabledObjects),a		; $7bc4

	ld a,$04		; $7bc7
	ld (de),a ; [var03] = $04

	ld a,$01		; $7bca
	call specialObjectSetAnimation		; $7bcc
	jp objectSetVisiblec3		; $7bcf

;;
; @addr{7bd2}
_mooshStateASubstate1:
	ld e,SpecialObject.var3d		; $7bd2
	ld a,(de)		; $7bd4
	or a			; $7bd5
	jr z,+			; $7bd6
	ld a,$01		; $7bd8
	ld (wDisabledObjects),a		; $7bda
	ld (wMenuDisabled),a		; $7bdd
+
	call _companionSetAnimationToVar3f		; $7be0
	call _mooshUpdateAsNpc		; $7be3
	ld a,(wMooshState)		; $7be6
	and $80			; $7be9
	ret z			; $7beb
	jr _label_05_458		; $7bec

;;
; @addr{7bee}
_mooshStateASubstate3:
	call _companionSetAnimationToVar3f		; $7bee
	call _mooshUpdateAsNpc		; $7bf1
	ld a,(wMooshState)		; $7bf4
	and $20			; $7bf7
	ret z			; $7bf9
	ld a,$ff		; $7bfa
	ld (wStatusBarNeedsRefresh),a		; $7bfc

_label_05_458:
	ld e,SpecialObject.var3d	; $7bff
	xor a			; $7c01
	ld (de),a		; $7c02
	call objectRemoveFromAButtonSensitiveObjectList		; $7c03

	ld c,$01		; $7c06
	call _companionSetAnimation		; $7c08
	jp _companionForceMount		; $7c0b

;;
; @addr{7c0e}
_mooshStateASubstate4:
	call _mooshIncVar03		; $7c0e
	ld bc,TX_2208		; $7c11
	jp showText		; $7c14

;;
; @addr{7c17}
_mooshStateASubstate5:
	call retIfTextIsActive		; $7c17

	ld bc,-$140		; $7c1a
	call objectSetSpeedZ		; $7c1d
	ld l,SpecialObject.angle		; $7c20
	ld (hl),$10		; $7c22
	ld l,SpecialObject.speed		; $7c24
	ld (hl),SPEED_100		; $7c26

	ld a,$0b		; $7c28
	call specialObjectSetAnimation		; $7c2a

	jp _mooshIncVar03		; $7c2d

;;
; @addr{7c30}
_mooshStateASubstate6:
	call specialObjectAnimate		; $7c30

	ld e,SpecialObject.speedZ+1		; $7c33
	ld a,(de)		; $7c35
	or a			; $7c36
	ld c,$10		; $7c37
	jp nz,objectUpdateSpeedZ_paramC		; $7c39

	call objectApplySpeed		; $7c3c
	ld e,SpecialObject.yh		; $7c3f
	ld a,(de)		; $7c41
	cp $f0			; $7c42
	ret c			; $7c44

	xor a			; $7c45
	ld (wDisabledObjects),a		; $7c46
	ld (wMenuDisabled),a		; $7c49
	ld (wRememberedCompanionId),a		; $7c4c

	ld hl,wMooshState		; $7c4f
	set 6,(hl)		; $7c52
	jp itemDelete		; $7c54

;;
; Prevents Link from passing Moosh, calls animate.
; @addr{7c57}
_mooshUpdateAsNpc:
	call _companionPreventLinkFromPassing_noExtraChecks		; $7c57
	call specialObjectAnimate		; $7c5a
	jp _companionSetPriorityRelativeToLink		; $7c5d

;;
; @addr{7c60}
_mooshIncVar03:
	ld e,SpecialObject.var03		; $7c60
	ld a,(de)		; $7c62
	inc a			; $7c63
	ld (de),a		; $7c64
	ret			; $7c65


;;
; @addr{7c66}
_specialObjectCode_raft:
	jpab bank6.specialObjectCode_raft		; $7c66


.include "data/tileTypeMappings.s"


; @addr{7d09}
cliffTilesTable:
	.dw @collisions0Data
	.dw @collisions1Data
	.dw @collisions2Data
	.dw @collisions3Data
	.dw @collisions4Data
	.dw @collisions5Data

; Data format:
; b0: Tile index
; b1: Angle value from which the tile can be jumped off of.

@collisions0Data:
@collisions4Data:
	.db $05 $10
	.db $06 $10
	.db $07 $10
	.db $0a $18
	.db $0b $08
	.db $64 $10
	.db $ff $10
	.db $00

@collisions1Data:
@collisions2Data:
@collisions5Data:
	.db $b0 $10
	.db $b1 $18
	.db $b2 $00
	.db $b3 $08
	.db $c1 $10
	.db $c2 $18
	.db $c3 $00
	.db $c4 $08
@collisions3Data:
	.db $00


.ifdef BUILD_VANILLA

; Garbage data

	.db $52 $06
	.db $53 $06
	.db $48 $02
	.db $49 $02
	.db $4a $02
	.db $4b $02
	.db $4d $03
	.db $54 $09
	.db $55 $0a
	.db $56 $0b
	.db $57 $0c
	.db $60 $0d
	.db $8a $0f
	.db $00

	.db $16 $10
	.db $18 $10
	.db $17 $90
	.db $19 $90
	.db $f4 $01
	.db $0f $01
	.db $0c $01
	.db $1a $30
	.db $1b $20
	.db $1c $20
	.db $1d $20
	.db $1e $20
	.db $1f $20
	.db $20 $40
	.db $22 $40
	.db $02 $00
	.db $00

	.db $7d $7d
	.db $8c $7d
	.db $8c $7d
	.db $9c $7d
	.db $7d $7d
	.db $8c $7d
	.db $05 $10
	.db $06 $10
	.db $07 $10
	.db $0a $18
	.db $0b $08
	.db $64 $10
	.db $ff $10
	.db $00

	.db $b0 $10
	.db $b1 $18
	.db $b2 $00
	.db $b3 $08
	.db $c1 $10
	.db $c2 $18
	.db $c3 $00
	.db $c4 $08
	.db $00

.endif
.ends


.BANK $06 SLOT 1
.ORG 0


 m_section_superfree "Bank_6" NAMESPACE bank6

	.include "code/interactableTiles.s"
	.include "code/specialObjectAnimationsAndDamage.s"
	.include "code/breakableTiles.s"

	.include "code/items/parentItemUsage.s"

	.include "code/items/shieldParent.s"
	.include "code/items/otherSwordsParent.s"
	.include "code/items/switchHookParent.s"
	.include "code/items/caneOfSomariaParent.s"
	.include "code/items/swordParent.s"
	.include "code/items/harpFluteParent.s"
	.include "code/items/seedsParent.s"
	.include "code/items/shovelParent.s"
	.include "code/items/boomerangParent.s"
	.include "code/items/bombsBraceletParent.s"
	.include "code/items/featherParent.s"
	.include "code/items/magnetGloveParent.s"

	.include "code/items/parentItemCommon.s"


; Following table affects how an item can be used (ie. how it interacts with other items
; being used).
;
; Data format:
;  b0: bits 4-7: Priority (higher value = higher precedence)
;                Gets written to high nibble of Item.enabled
;      bits 0-3: Determines what "parent item" slot to use when the button is pressed.
;                0: Item is unusable.
;                1: Uses w1ParentItem3 or 4.
;                2: Uses w1ParentItem3 or 4, but only one instance of the item may exist
;                   at once. (boomerang, seed satchel)
;                3: Uses w1ParentItem2. If an object is already there, it gets
;                   overwritten if this object's priority is high enough.
;                   (sword, cane, bombs, etc)
;                4: Same as 2, but the item can't be used if w1ParentItem2 is in use (Link
;                   is holding a sword or something)
;                5: Uses w1ParentItem5 (only if not already in use). (shield, flute, harp)
;                6-7: invalid
;  b1: Byte to check input against when the item is first used
;
; @addr{55be}
_itemUsageParameterTable:
	.db $00 <wGameKeysPressed	; ITEMID_NONE
	.db $05 <wGameKeysPressed	; ITEMID_SHIELD
	.db $03 <wGameKeysJustPressed	; ITEMID_PUNCH
	.db $23 <wGameKeysJustPressed	; ITEMID_BOMB
	.db $03 <wGameKeysJustPressed	; ITEMID_CANE_OF_SOMARIA
	.db $63 <wGameKeysJustPressed	; ITEMID_SWORD
	.db $02 <wGameKeysJustPressed	; ITEMID_BOOMERANG
	.db $00 <wGameKeysJustPressed	; ITEMID_ROD_OF_SEASONS
	.db $00 <wGameKeysJustPressed	; ITEMID_MAGNET_GLOVES
	.db $00 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK_HELPER
	.db $73 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK
	.db $00 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK_CHAIN
	.db $73 <wGameKeysJustPressed	; ITEMID_BIGGORON_SWORD
	.db $02 <wGameKeysJustPressed	; ITEMID_BOMBCHUS
	.db $05 <wGameKeysJustPressed	; ITEMID_FLUTE
	.db $43 <wGameKeysJustPressed	; ITEMID_SHOOTER
	.db $00 <wGameKeysJustPressed	; ITEMID_10
	.db $05 <wGameKeysJustPressed	; ITEMID_HARP
	.db $00 <wGameKeysJustPressed	; ITEMID_12
	.db $00 <wGameKeysJustPressed	; ITEMID_SLINGSHOT
	.db $00 <wGameKeysJustPressed	; ITEMID_14
	.db $13 <wGameKeysJustPressed	; ITEMID_SHOVEL
	.db $13 <wGameKeysPressed	; ITEMID_BRACELET
	.db $01 <wGameKeysJustPressed	; ITEMID_FEATHER
	.db $00 <wGameKeysJustPressed	; ITEMID_18
	.db $02 <wGameKeysJustPressed	; ITEMID_SEED_SATCHEL
	.db $00 <wGameKeysJustPressed	; ITEMID_DUST
	.db $00 <wGameKeysJustPressed	; ITEMID_1b
	.db $00 <wGameKeysJustPressed	; ITEMID_1c
	.db $00 <wGameKeysJustPressed	; ITEMID_MINECART_COLLISION
	.db $00 <wGameKeysJustPressed	; ITEMID_FOOLS_ORE
	.db $00 <wGameKeysJustPressed	; ITEMID_1f



; Data format:
;  b0: bit 7:    If set, the corresponding bit in wLinkUsingItem1 will be set.
;      bits 4-6: Value for bits 0-2 of Item.var3f
;      bits 0-3: Determines parent item's relatedObj2?
;                A value of $6 refers to w1WeaponItem.
;  b1: Animation to set Link to? (see constants/linkAnimations.s)
;
; @addr{55fe}
_linkItemAnimationTable:
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_NONE
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_SHIELD
	.db $d6  LINK_ANIM_MODE_21	; ITEMID_PUNCH
	.db $30  LINK_ANIM_MODE_LIFT	; ITEMID_BOMB
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_CANE_OF_SOMARIA
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_SWORD
	.db $b0  LINK_ANIM_MODE_21	; ITEMID_BOOMERANG
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_ROD_OF_SEASONS
	.db $60  LINK_ANIM_MODE_NONE	; ITEMID_MAGNET_GLOVES
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_HELPER
	.db $f6  LINK_ANIM_MODE_21	; ITEMID_SWITCH_HOOK
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_CHAIN
	.db $f6  LINK_ANIM_MODE_23	; ITEMID_BIGGORON_SWORD
	.db $30  LINK_ANIM_MODE_21	; ITEMID_BOMBCHUS
	.db $70  LINK_ANIM_MODE_FLUTE	; ITEMID_FLUTE
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SHOOTER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_10
	.db $70  LINK_ANIM_MODE_HARP_2	; ITEMID_HARP
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_12
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SLINGSHOT
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_14
	.db $b0  LINK_ANIM_MODE_DIG_2	; ITEMID_SHOVEL
	.db $40  LINK_ANIM_MODE_LIFT_3	; ITEMID_BRACELET
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_FEATHER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_18
	.db $a0  LINK_ANIM_MODE_21	; ITEMID_SEED_SATCHEL
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_DUST
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1b
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1c
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_MINECART_COLLISION
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_FOOLS_ORE
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1f


;;
; Update a minecart object.
; (Called from bank5._specialObjectCode_minecart)
; @addr{563e}
specialObjectCode_minecart:
	call _minecartCreateCollisionItem		; $563e
	ld e,SpecialObject.state		; $5641
	ld a,(de)		; $5643
	rst_jumpTable			; $5644

	.dw @state0
	.dw @state1

@state0:
	; Set state to $01
	ld a,$01		; $5649
	ld (de),a		; $564b

	; Setup palette, etc
	callab bank5.specialObjectSetOamVariables		; $564c

	ld h,d			; $5654
	ld l,SpecialObject.speed		; $5655
	ld (hl),SPEED_100		; $5657

	ld l,SpecialObject.direction		; $5659
	ld a,(hl)		; $565b
	call specialObjectSetAnimation		; $565c

	ld a,d			; $565f
	ld (wLinkObjectIndex),a		; $5660
	call setCameraFocusedObjectToLink		; $5663

	; Resets link's animation if he's using an item, maybe?
	call clearVar3fForParentItems		; $5666

	call clearPegasusSeedCounter		; $5669

	ld hl,w1Link.z		; $566c
	xor a			; $566f
	ldi (hl),a		; $5670
	ldi (hl),a		; $5671

	jp objectSetVisiblec2		; $5672

@state1:
	ld a,(wPaletteThread_mode)		; $5675
	or a			; $5678
	ret nz			; $5679

	call retIfTextIsActive		; $567a

	ld a,(wScrollMode)		; $567d
	and $0e			; $5680
	ret nz			; $5682

	ld a,(wDisabledObjects)		; $5683
	and $81			; $5686
	ret nz			; $5688

	; Disable link's collisions?
	ld hl,w1Link.collisionType		; $5689
	res 7,(hl)		; $568c

	xor a			; $568e
	ld l,<w1Link.knockbackCounter		; $568f
	ldi (hl),a		; $5691

	; Check if on the center of the tile (y)
	ld h,d			; $5692
	ld l,SpecialObject.yh		; $5693
	ldi a,(hl)		; $5695
	ld b,a			; $5696
	and $0f			; $5697
	cp $08			; $5699
	jr nz,++		; $569b

	; Check if on the center of the tile (x)
	inc l			; $569d
	ldi a,(hl)		; $569e
	ld c,a			; $569f
	and $0f			; $56a0
	cp $08			; $56a2
	jr nz,++		; $56a4

	; Minecart is centered on the tile

	call _minecartCheckCollisions		; $56a6
	jr c,@minecartStopped	; $56a9

	; Compare direction to angle, ensure they're synchronized
	ld h,d			; $56ab
	ld l,SpecialObject.direction		; $56ac
	ldi a,(hl)		; $56ae
	swap a			; $56af
	rrca			; $56b1
	cp (hl)			; $56b2
	jr z,++			; $56b3

	ldd (hl),a		; $56b5
	ld a,(hl)		; $56b6
	call specialObjectSetAnimation		; $56b7

++
	ld h,d			; $56ba
	ld l,SpecialObject.var35		; $56bb
	dec (hl)		; $56bd
	bit 7,(hl)		; $56be
	jr z,+			; $56c0

	ld (hl),$1a		; $56c2
	ld a,SND_MINECART		; $56c4
	call playSound		; $56c6
+
	call objectApplySpeed		; $56c9
	jp specialObjectAnimate		; $56cc

@minecartStopped:
	; Go to state $02.
	; State $02 doesn't exist, so, good thing this is getting deleted anyway.
	ld e,SpecialObject.state		; $56cf
	ld a,$02		; $56d1
	ld (de),a		; $56d3

	call clearVar3fForParentItems		; $56d4

	; Force link to jump, lock his direction?
	ld a,$81		; $56d7
	ld (wLinkInAir),a		; $56d9

	; Copy / initialize various link variables

	ld hl,w1Link.angle		; $56dc
	ld e,SpecialObject.angle		; $56df
	ld a,(de)		; $56e1
	ld (hl),a		; $56e2

	ld l,<w1Link.yh		; $56e3
	ld a,(hl)		; $56e5
	add $06			; $56e6
	ld (hl),a		; $56e8

	ld l,<w1Link.zh		; $56e9
	ld (hl),$fa		; $56eb

	ld l,<w1Link.speed		; $56ed
	ld (hl),SPEED_80		; $56ef

	ld l,<w1Link.speedZ		; $56f1
	ld (hl),$40		; $56f3
	inc l			; $56f5
	ld (hl),$fe		; $56f6

	; Re-enable terrain effects (shadow)
	ld l,<w1Link.visible		; $56f8
	set 6,(hl)		; $56fa

	; Change main object back to w1Link ($d000) instead of this object ($d100)
	ld a,>w1Link		; $56fc
	ld (wLinkObjectIndex),a		; $56fe
	call setCameraFocusedObjectToLink		; $5701

	; Create the "interaction" minecart to replace the "special object" minecart
	ld b,INTERACID_MINECART		; $5704
	call objectCreateInteractionWithSubid00		; $5706
	jp objectDelete_useActiveObjectType		; $5709

;;
; Check for collisions, check the track for changing direction.
; @param[out] cflag Set if the minecart should stop (reached a platform)
; @addr{570c}
_minecartCheckCollisions:
	; Get minecart position in c, tile it's on in e
	call getTileAtPosition		; $570c
	ld e,a			; $570f
	ld c,l			; $5710

	; Try to find the relevant data in @trackData based on the tile the minecart is
	; currently on.
	ld h,d			; $5711
	ld l,SpecialObject.direction		; $5712
	ld a,(hl)		; $5714
	swap a			; $5715
	ld hl,@trackData		; $5717
	rst_addAToHl			; $571a
--
	ldi a,(hl)		; $571b
	or a			; $571c
	jr z,@noTrackFound		; $571d

	cp e			; $571f
	jr z,++			; $5720

	ld a,$04		; $5722
	rst_addAToHl			; $5724
	jr --		; $5725

	; Found a matching tile in @trackData
++
	; Add value to c to get the position of the next tile the minecart will move to.
	ldi a,(hl)		; $5727
	add c			; $5728
	ld c,a			; $5729
	ldh (<hFF8B),a	; $572a

	; Check for the edge of the room
	ld b,>wRoomCollisions		; $572c
	ld a,(bc)		; $572e
	cp $ff			; $572f
	ret z			; $5731

	; Check for a platform to disembark at
	ld b,>wRoomLayout		; $5732
	ld a,(bc)		; $5734
	cp TILEINDEX_MINECART_PLATFORM			; $5735
	jr z,@stopMinecart	; $5737

	; c will now store the value of the next tile.
	ld c,a			; $5739

	; Check the next 3 bytes of @trackData to see if the next track tile is acceptable
	ld b,$03		; $573a
--
	ldi a,(hl)		; $573c
	cp c			; $573d
	jr z,@updateDirection	; $573e
	dec b			; $5740
	jr nz,--		; $5741
	jr @noTrackFound		; $5743

@stopMinecart:
	; Set carry flag to give the signal that the ride is over.
	scf			; $5745
	ret			; $5746

@updateDirection:
	ld a,e			; $5747
	sub TILEINDEX_TRACK_TL		; $5748
	cp TILEINDEX_MINECART_PLATFORM - TILEINDEX_TRACK_TL	; $574a
	jr c,++			; $574c

@noTrackFound:
	; Index $06 will jump to @notTrack.
	ld a,$06		; $574e
++
	ld e,SpecialObject.direction		; $5750
	rst_jumpTable			; $5752
.dw @trackTL
.dw @trackBR
.dw @trackBL
.dw @trackTR
.dw @trackHorizontal
.dw @trackVertical
.dw @notTrack

@trackTL:
@trackBR:
	ld a,(de)		; $5761
	xor $01			; $5762
	ld (de),a		; $5764
	ret			; $5765

@trackBL:
@trackTR:
	ld a,(de)		; $5766
	xor $03			; $5767
	ld (de),a		; $5769
	ret			; $576a

@trackHorizontal:
	ld a,(de)		; $576b
	and $02			; $576c
	or $01			; $576e
	ld (de),a		; $5770
	ret			; $5771

@trackVertical:
	ld a,(de)		; $5772
	and $02			; $5773
	ld (de),a		; $5775
	ret			; $5776

@notTrack:
	call @checkMinecartDoor		; $5777
	jr nc,+			; $577a

	; Next tile is a minecart door, keep going
	xor a			; $577c
	ret			; $577d
+
	; Reverse direction
	ld a,(de)		; $577e
	xor $02			; $577f
	ld (de),a		; $5781
	ret			; $5782

; b0: Tile to check for ($00 to end list)
; b1: Value to add to position (where the next tile is)
; b2-b4: Other tiles that are allowed to link to the current tile
; @addr{5783}
@trackData:
	; DIR_UP
	.db TILEINDEX_TRACK_VERTICAL $f0 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_TL TILEINDEX_TRACK_TR
	.db TILEINDEX_TRACK_TL       $01 TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BR TILEINDEX_TRACK_TR
	.db TILEINDEX_TRACK_TR       $ff TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BL TILEINDEX_TRACK_TL
	.db $00

	; DIR_RIGHT
	.db TILEINDEX_TRACK_HORIZONTAL $01 TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BR TILEINDEX_TRACK_TR
	.db TILEINDEX_TRACK_BR         $f0 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_TL TILEINDEX_TRACK_TR
	.db TILEINDEX_TRACK_TR         $10 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_BL TILEINDEX_TRACK_BR
	.db $00

	; DIR_DOWN
	.db TILEINDEX_TRACK_VERTICAL $10 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_BR TILEINDEX_TRACK_BL
	.db TILEINDEX_TRACK_BR       $ff TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BL TILEINDEX_TRACK_TL
	.db TILEINDEX_TRACK_BL       $01 TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BR TILEINDEX_TRACK_TR
	.db $00

	; DIR_LEFT
	.db TILEINDEX_TRACK_HORIZONTAL $ff TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BL TILEINDEX_TRACK_TL
	.db TILEINDEX_TRACK_BL         $f0 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_TR TILEINDEX_TRACK_TL
	.db TILEINDEX_TRACK_TL         $10 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_BR TILEINDEX_TRACK_BL
	.db $00

;;
; @param	c	Next tile
; @param[out]	cflag	Set if the next tile is a minecart door that will open
; @addr{57c3}
@checkMinecartDoor:
	; Check if the next tile is a minecart door
	ld a,c			; $57c3
	sub TILEINDEX_MINECART_DOOR_UP			; $57c4
	cp $04			; $57c6
	ret nc			; $57c8

	; Calculate the angle for the interaction to be created (?)
	add $0c			; $57c9
	add a			; $57cb
	ld b,a			; $57cc

	call getFreeInteractionSlot		; $57cd
	ret nz			; $57d0

	ld (hl),INTERACID_DOOR_CONTROLLER		; $57d1

	ld l,Interaction.angle		; $57d3
	ld (hl),b		; $57d5

	; Set position (this interaction stuffs both X and Y in the yh variable)
	ld l,Interaction.yh		; $57d6
	ldh a,(<hFF8B)	; $57d8
	ld (hl),a		; $57da

	scf			; $57db
	ret			; $57dc

;;
; Creates an invisible item object which stays with the minecart to give it collision with enemies
; @addr{57dd}
_minecartCreateCollisionItem:
	; Check if the "item" has been created already
	ld e,SpecialObject.var36		; $57dd
	ld a,(de)		; $57df
	or a			; $57e0
	ret nz			; $57e1

	call getFreeItemSlot		; $57e2
	ret nz			; $57e5

	; Mark it as created
	ld e,SpecialObject.var36		; $57e6
	ld a,$01		; $57e8
	ld (de),a		; $57ea

	; Set Item.enabled
	ldi (hl),a		; $57eb

	; Set Item.id
	ld (hl),ITEMID_MINECART_COLLISION		; $57ec
	ret			; $57ee

;;
; @addr{57ef}
specialObjectCode_raft:
	ld a,d			; $57ef
	ld (wLinkRidingObject),a		; $57f0
	ld e,Item.state		; $57f3
	ld a,(de)		; $57f5
	rst_jumpTable			; $57f6
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	callab bank5.specialObjectSetOamVariables		; $57ff
	xor a			; $5807
	call specialObjectSetAnimation		; $5808
	call itemIncState		; $580b

	ld l,SpecialObject.collisionType		; $580e
	ld a,$80|ITEMCOLLISION_LINK		; $5810
	ldi (hl),a		; $5812

	; collisionRadiusY/X
	inc l			; $5813
	ld a,$06		; $5814
	ldi (hl),a		; $5816
	ldi (hl),a		; $5817

	ld l,SpecialObject.counter1		; $5818
	ld (hl),$0c		; $581a

	ld a,d			; $581c
	ld (wLinkObjectIndex),a		; $581d
	call setCameraFocusedObjectToLink		; $5820
	jp @saveRaftPosition		; $5823


; State 1: riding the raft
@state1:
	ld a,(wPaletteThread_mode)		; $5826
	or a			; $5829
	ret nz			; $582a
	call retIfTextIsActive		; $582b
	ld a,(wScrollMode)		; $582e
	and $0e			; $5831
	ret nz			; $5833
	ld a,(wDisabledObjects)		; $5834
	and $81			; $5837
	ret nz			; $5839

	ld a,(wLinkForceState)		; $583a
	cp LINK_STATE_RESPAWNING			; $583d
	jr z,@respawning			; $583f
	ld a,(w1Link.state)		; $5841
	cp LINK_STATE_RESPAWNING			; $5844
	jr nz,++		; $5846

@respawning:
	ld hl,wLinkLocalRespawnY		; $5848
	ld e,SpecialObject.yh		; $584b
	ldi a,(hl)		; $584d
	ld (de),a		; $584e
	ld e,SpecialObject.xh		; $584f
	ldi a,(hl)		; $5851
	ld (de),a		; $5852
	jp objectSetInvisible		; $5853

++
	; Update direction; if changed, re-initialize animation
	call updateCompanionDirectionFromAngle		; $5856
	jr c,+			; $5859
	call specialObjectAnimate		; $585b
	jr ++			; $585e
+
	call specialObjectSetAnimation		; $5860
++
	call @raftCalculateAdjacentWallsBitset		; $5863
	call @transferKnockbackToLink		; $5866
	ld hl,w1Link.knockbackCounter		; $5869
	ld a,(hl)		; $586c
	or a			; $586d
	jr z,@updateMovement	; $586e

	; Experiencing knockback; decrement counter, apply knockback speed
	dec (hl)		; $5870
	dec l			; $5871
	ld c,(hl)		; $5872
	ld b,SPEED_100		; $5873
	callab bank5.specialObjectUpdatePositionGivenVelocity		; $5875

	ld a,$88		; $587d
	ld (wcc92),a		; $587f
	jr @notDismounting		; $5882

@updateMovement:
	ld e,SpecialObject.speed		; $5884
	ld a,SPEED_e0		; $5886
	ld (de),a		; $5888

	ld e,SpecialObject.angle		; $5889
	ld a,(wLinkAngle)		; $588b
	ld (de),a		; $588e
	bit 7,a			; $588f
	jr nz,@notDismounting	; $5891
	ld a,(wLinkImmobilized)		; $5893
	or a			; $5896
	jr nz,@notDismounting	; $5897

	callab bank5.specialObjectUpdatePosition	; $5899
	ld a,c			; $58a1
	or a			; $58a2
	jr z,@positionUnchanged	; $58a3

	ld a,$08		; $58a5
	ld (wcc92),a		; $58a7


	; If not dismounting this frame, reset 'dismounting angle' (var3e) and
	; 'dismounting counter' (var3f).
@notDismounting:
	ld h,d			; $58aa
	ld l,SpecialObject.var3e		; $58ab
	ld a,$ff		; $58ad
	ldi (hl),a		; $58af

	; [var3f] = $04
	ld (hl),$04		; $58b0
	ret			; $58b2


	; If position is unchanged, check whether to dismount
@positionUnchanged:
	; Return if "dismount angle" changed from before
	ld h,d			; $58b3
	ld e,SpecialObject.angle		; $58b4
	ld a,(de)		; $58b6
	ld l,SpecialObject.var3e		; $58b7
	cp (hl)			; $58b9
	ldi (hl),a		; $58ba
	ret nz			; $58bb

	; [var3f]--
	dec (hl)		; $58bc
	ret nz			; $58bd

	; Get angle from var3e
	dec e			; $58be
	ld a,(de)		; $58bf
	ld hl,@dismountTileOffsets		; $58c0
	rst_addDoubleIndex			; $58c3

	; Get Y/X offset from this object in 'bc'
	ldi a,(hl)		; $58c4
	ld c,(hl)		; $58c5
	ld h,d			; $58c6
	ld l,SpecialObject.yh		; $58c7
	add (hl)		; $58c9
	ld b,a			; $58ca
	ld l,SpecialObject.xh		; $58cb
	ld a,(hl)		; $58cd
	add c			; $58ce
	ld c,a			; $58cf

	; If Link can walk on the adjacent tile, check whether to dismount
	call getTileAtPosition		; $58d0
	ld h,>wRoomCollisions		; $58d3
	ld a,(hl)		; $58d5
	or a			; $58d6
	jr z,@checkDismount	; $58d7
	cp SPECIALCOLLISION_STAIRS			; $58d9
	jr nz,@notDismounting	; $58db

@checkDismount:
	callab bank5.calculateAdjacentWallsBitset		; $58dd
	ldh a,(<hFF8B)	; $58e5
	or a			; $58e7
	jr nz,@notDismounting	; $58e8

	; Disable menu, force Link to walk for 14 frames
	inc a			; $58ea
	ld (wMenuDisabled),a		; $58eb
	ld a,LINK_STATE_FORCE_MOVEMENT		; $58ee
	ld (wLinkForceState),a		; $58f0
	ld a,14		; $58f3
	ld (wLinkStateParameter),a		; $58f5

	; Update angle; copy direction + angle to Link
	call itemUpdateAngle		; $58f8
	ld e,l			; $58fb
	ld h,>w1Link		; $58fc
	ld a,(de)		; $58fe
	ldi (hl),a		; $58ff
	inc e			; $5900
	ld a,(de)		; $5901
	ldi (hl),a		; $5902

	; Link is no longer riding the raft, set object index to $d0
	ld a,h			; $5903
	ld (wLinkObjectIndex),a		; $5904

	call setCameraFocusedObjectToLink		; $5907
	call itemIncState		; $590a
	jr @saveRaftPosition		; $590d


; These are offsets from the raft's position at which to check whether the tile there can
; be dismounted onto. (the only requirement is that it's non-solid.)
@dismountTileOffsets:
	.db $f7 $00 ; DIR_UP
	.db $fd $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $fd $f7 ; DIR_LEFT


; State 2: started dismounting
@state2:
	ld a,$80		; $5917
	ld (wcc92),a		; $5919
	call itemDecCounter1		; $591c
	ret nz			; $591f

	xor a			; $5920
	ld (wMenuDisabled),a		; $5921
	ld e,SpecialObject.enabled		; $5924
	inc a			; $5926
	ld (de),a		; $5927
	call updateLinkLocalRespawnPosition		; $5928
	call itemIncState		; $592b


; State 3: replace self with raft interaction
@state3:
	ldbc INTERACID_RAFT, $02		; $592e
	call objectCreateInteraction		; $5931
	ret nz			; $5934
	ld e,SpecialObject.direction		; $5935
	ld a,(de)		; $5937
	ld l,Interaction.direction		; $5938
	ld (hl),a		; $593a
	jp itemDelete		; $593b

;;
; @addr{593e}
@saveRaftPosition:
	ld bc,wLastAnimalMountPointY		; $593e
	ld h,d			; $5941
	ld l,SpecialObject.yh		; $5942
	ldi a,(hl)		; $5944
	ld (bc),a		; $5945
	inc c			; $5946
	inc l			; $5947
	ld a,(hl)		; $5948
	ld (bc),a		; $5949
	jpab bank5.saveLinkLocalRespawnAndCompanionPosition		; $594a

;;
; Calculates the "adjacent walls bitset" for the raft specifically, treating everything as
; solid except for water tiles.
;
; @addr{5952}
@raftCalculateAdjacentWallsBitset:
	ld a,$01		; $5952
	ldh (<hFF8B),a	; $5954
	ld hl,@@wallPositionOffsets		; $5956
--
	ldi a,(hl)		; $5959
	ld b,a			; $595a
	ldi a,(hl)		; $595b
	ld c,a			; $595c
	push hl			; $595d
	call objectGetRelativeTile		; $595e
	or a			; $5961
	jr z,+			; $5962
	ld e,a			; $5964
	ld hl,@@validTiles		; $5965
	call findByteAtHl		; $5968
	ccf			; $596b
+
	pop hl			; $596c
	ldh a,(<hFF8B)	; $596d
	rla			; $596f
	ldh (<hFF8B),a	; $5970
	jr nc,--		; $5972

	ld e,SpecialObject.adjacentWallsBitset		; $5974
	ld (de),a		; $5976
	ret			; $5977

; Offsets at which to check for solid walls (8 positions to check)
@@wallPositionOffsets:
	.db $fa $fb
	.db $fa $04
	.db $05 $fb
	.db $05 $04
	.db $fb $fa
	.db $04 $fa
	.db $fb $05
	.db $04 $05


; A list of tiles that the raft may cross.
@@validTiles:
	.db TILEINDEX_DEEP_WATER
	.db TILEINDEX_CURRENT_UP
	.db TILEINDEX_CURRENT_DOWN
	.db TILEINDEX_CURRENT_LEFT
	.db TILEINDEX_CURRENT_RIGHT
	.db TILEINDEX_WATER
	.db TILEINDEX_WHIRLPOOL
	.db $00


;;
; @addr{5990}
@transferKnockbackToLink:
	; Check Link's invincibilityCounter and var2a
	ld hl,w1Link.invincibilityCounter		; $5990
	ldd a,(hl)		; $5993
	or (hl)			; $5994
	jr nz,@@end		; $5995

	; Ret if raft's var2a is zero
	ld e,l			; $5997
	ld a,(de)		; $5998
	or a			; $5999
	ret z			; $599a

	; Transfer raft's var2a, invincibilityCounter, knockbackCounter, knockbackAngle,
	; and damageToApply to Link.
	ldi (hl),a		; $599b
	inc e			; $599c
	ld a,(de)		; $599d
	ldi (hl),a		; $599e
	inc e			; $599f
	ld a,(de)		; $59a0
	ldi (hl),a		; $59a1
	inc e			; $59a2
	ld a,(de)		; $59a3
	ldi (hl),a		; $59a4
	ld e,SpecialObject.damageToApply		; $59a5
	ld a,(de)		; $59a7
	ld l,e			; $59a8
	ld (hl),a		; $59a9

@@end:
	; Clear raft's invincibilityCounter and var2a
	ld e,SpecialObject.var2a		; $59aa
	xor a			; $59ac
	ld (de),a		; $59ad
	inc e			; $59ae
	ld (de),a		; $59af
	ret			; $59b0


	.include "build/data/specialObjectAnimationData.s"


;;
; @addr{6cec}
specialObjectCode_companionCutscene:
	ld hl,w1Companion.id		; $6cec
	ld a,(hl)		; $6cef
	sub SPECIALOBJECTID_RICKY_CUTSCENE			; $6cf0
	rst_jumpTable			; $6cf2
	.dw _specialObjectCode_rickyCutscene
	.dw _specialObjectCode_dimitriCutscene
	.dw _specialObjectCode_mooshCutscene
	.dw _specialObjectCode_mapleCutscene

;;
; @addr{6cfb}
_specialObjectCode_rickyCutscene:
	ld e,SpecialObject.state		; $6cfb
	ld a,(de)		; $6cfd
	ld a,(de)		; $6cfe
	rst_jumpTable			; $6cff
	.dw @state0
	.dw _rickyCutscene_state1

@state0:
	call _companionCutsceneInitOam		; $6d04
	ld h,d			; $6d07
	ld l,SpecialObject.speed		; $6d08
	ld (hl),SPEED_200		; $6d0a
	ld l,SpecialObject.angle		; $6d0c
	ld (hl),$08		; $6d0e

_rickyCutsceneJump:
	ld bc,$fe00		; $6d10
	call objectSetSpeedZ		; $6d13
	ld a,$02		; $6d16
	jp specialObjectSetAnimation		; $6d18


;;
; @param	de	Pointer to Object.state variable
; @addr{6d1b}
_companionCutsceneInitOam:
	ld a,$01		; $6d1b
	ld (de),a		; $6d1d
	callab bank5.specialObjectSetOamVariables		; $6d1e
	jp objectSetVisiblec0		; $6d26


_rickyCutscene_state1:
	ld e,SpecialObject.subid		; $6d29
	ld a,(de)		; $6d2b
	rst_jumpTable			; $6d2c
	.dw @subid0
	.dw @subid1

@subid0:
	ret			; $6d31

@subid1:
	ld e,SpecialObject.state2		; $6d32
	ld a,(de)		; $6d34
	rst_jumpTable			; $6d35
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
	.dw @substate9
	.dw @substateA

@substate0:
	ld l,SpecialObject.state2		; $6d4c
	inc (hl)		; $6d4e

@substate1:
	call objectApplySpeed		; $6d4f

	ld e,SpecialObject.xh		; $6d52
	ld a,(de)		; $6d54
	bit 7,a			; $6d55
	jr nz,++		; $6d57

	ld hl,w1Link.xh		; $6d59
	ld b,(hl)		; $6d5c
	add $18			; $6d5d
	cp b			; $6d5f
	jr c,++			; $6d60

	call itemIncState2		; $6d62
	inc (hl)		; $6d65
	ld l,SpecialObject.z		; $6d66
	xor a			; $6d68
	ldi (hl),a		; $6d69
	ld (hl),a		; $6d6a
	ld l,SpecialObject.counter1		; $6d6b
	ld (hl),$3c		; $6d6d
	jp specialObjectAnimate		; $6d6f
++
	ld c,$40		; $6d72
	call objectUpdateSpeedZ_paramC		; $6d74
	ret nz			; $6d77
	call itemIncState2		; $6d78
	ld l,SpecialObject.counter1		; $6d7b
	ld (hl),$08		; $6d7d
	jp specialObjectAnimate		; $6d7f

@substate2:
	call itemDecCounter1		; $6d82
	ret nz			; $6d85
	ld l,SpecialObject.state2		; $6d86
	dec (hl)		; $6d88
	jp _rickyCutsceneJump		; $6d89

@substate3:
	call itemDecCounter1		; $6d8c
	ret nz			; $6d8f
	ld l,SpecialObject.state2		; $6d90
	inc (hl)		; $6d92
	ld l,SpecialObject.counter1		; $6d93
	ld (hl),$5a		; $6d95
	ld a,$14		; $6d97
	jp specialObjectSetAnimation		; $6d99

@substate4:
	call specialObjectAnimate		; $6d9c
	call itemDecCounter1		; $6d9f
	ret nz			; $6da2
	ld l,SpecialObject.state2		; $6da3
	inc (hl)		; $6da5
	ld l,SpecialObject.counter1		; $6da6
	ld (hl),$0c		; $6da8
	ld a,$1f		; $6daa
	call specialObjectSetAnimation		; $6dac
	call getFreeInteractionSlot		; $6daf
	ret nz			; $6db2

	ld (hl),$07		; $6db3
	ld bc,$f812		; $6db5
	jp objectCopyPositionWithOffset		; $6db8

	ld l,SpecialObject.state2		; $6dbb
	ld (hl),$00		; $6dbd
	ld a,$1e		; $6dbf
	jp specialObjectSetAnimation		; $6dc1

@substate5:
	call itemDecCounter1		; $6dc4
	ret nz			; $6dc7
	ld l,SpecialObject.state2		; $6dc8
	inc (hl)		; $6dca
	ld l,SpecialObject.counter1		; $6dcb
	ld (hl),$3c		; $6dcd
	ld a,$1e		; $6dcf
	jp specialObjectSetAnimation		; $6dd1

@substate6:
	call itemDecCounter1		; $6dd4
	ret nz			; $6dd7
	ld l,SpecialObject.state2		; $6dd8
	inc (hl)		; $6dda

	; counter1
	inc l			; $6ddb
	ld (hl),$1e		; $6ddc

	ld hl,wActiveRing		; $6dde
	ld (hl),$ff		; $6de1
	ld a,$81		; $6de3
	ld (wLinkInAir),a		; $6de5
	ld hl,w1Link.speed		; $6de8
	ld (hl),SPEED_80		; $6deb
	ld l,SpecialObject.speedZ		; $6ded
	ld (hl),$00		; $6def
	inc l			; $6df1
	ld (hl),$fe		; $6df2

	ld a,$18		; $6df4
	ld (w1Link.angle),a		; $6df6
	ld a,SND_JUMP		; $6df9
	jp playSound		; $6dfb

@substate7:
	call itemDecCounter1		; $6dfe
	ret nz			; $6e01
	ld l,SpecialObject.state2		; $6e02
	inc (hl)		; $6e04
	ld l,SpecialObject.counter1		; $6e05
	ld (hl),$14		; $6e07
	xor a			; $6e09
	ld hl,w1Link.visible		; $6e0a
	ld (hl),a		; $6e0d
	inc a			; $6e0e
	ld (wDisabledObjects),a		; $6e0f
	ret			; $6e12

@substate8:
	call itemDecCounter1		; $6e13
	ret nz			; $6e16
	ld l,SpecialObject.state2		; $6e17
	inc (hl)		; $6e19
	ld l,SpecialObject.angle		; $6e1a
	ld (hl),$18		; $6e1c

@jump:
	ld a,$1c		; $6e1e
	call specialObjectSetAnimation		; $6e20
	ld bc,$fe00		; $6e23
	jp objectSetSpeedZ		; $6e26

@substate9:
	call objectApplySpeed		; $6e29
	ld e,SpecialObject.xh		; $6e2c
	ld a,(de)		; $6e2e
	sub $10			; $6e2f
	rlca			; $6e31
	jr nc,+			; $6e32
	ld hl,$cfdf		; $6e34
	ld (hl),$01		; $6e37
	ret			; $6e39
+
	ld c,$40		; $6e3a
	call objectUpdateSpeedZ_paramC		; $6e3c
	ret nz			; $6e3f
	call itemIncState2		; $6e40
	ld l,SpecialObject.counter1		; $6e43
	ld (hl),$08		; $6e45
	jp specialObjectAnimate		; $6e47

@substateA:
	call itemDecCounter1		; $6e4a
	ret nz			; $6e4d
	ld l,SpecialObject.state2		; $6e4e
	dec (hl)		; $6e50
	jp @jump		; $6e51

;;
; @addr{6e54}
_specialObjectCode_mooshCutscene:
	ld e,SpecialObject.state		; $6e54
	ld a,(de)		; $6e56
	rst_jumpTable			; $6e57
	.dw @state0
	.dw @state1

@state0:
	call _companionCutsceneInitOam		; $6e5c
	ld h,d			; $6e5f
	ld l,SpecialObject.counter1		; $6e60
	ld (hl),$5a		; $6e62
	ld l,SpecialObject.speed		; $6e64
	ld (hl),SPEED_160		; $6e66
	ld l,SpecialObject.var36		; $6e68
	ld (hl),$05		; $6e6a
	ld l,SpecialObject.angle		; $6e6c
	ld (hl),$10		; $6e6e
	ld l,SpecialObject.z		; $6e70
	ld (hl),$ff		; $6e72
	inc l			; $6e74
	ld (hl),$e0		; $6e75

	call getFreeInteractionSlot		; $6e77
	jr nz,+			; $6e7a
	ld (hl),INTERACID_BANANA		; $6e7c
	ld l,Interaction.relatedObj1+1		; $6e7e
	ld (hl),d		; $6e80
+
	ld a,$07		; $6e81
	jp specialObjectSetAnimation		; $6e83

@state1:
	ld e,SpecialObject.state2		; $6e86
	ld a,(de)		; $6e88
	or a			; $6e89
	jr z,+			; $6e8a
	call specialObjectAnimate		; $6e8c
	call objectApplySpeed		; $6e8f
+
	ld e,SpecialObject.state2		; $6e92
	ld a,(de)		; $6e94
	rst_jumpTable			; $6e95
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	call itemDecCounter1		; $6ea0
	ret nz			; $6ea3
	ld (hl),$48		; $6ea4
	ld l,SpecialObject.state2		; $6ea6
	inc (hl)		; $6ea8
	ret			; $6ea9

@substate1:
	call itemDecCounter1		; $6eaa
	ret nz			; $6ead
	ld (hl),$06		; $6eae
	ld l,SpecialObject.state2		; $6eb0
	inc (hl)		; $6eb2
	jp _companionCutsceneFunc_7081		; $6eb3

@substate2:
	ld h,d			; $6eb6
	ld l,SpecialObject.angle		; $6eb7
	ld a,(hl)		; $6eb9
	cp $10			; $6eba
	jr z,@label_6ec2			; $6ebc
	ld l,SpecialObject.state2		; $6ebe
	inc (hl)		; $6ec0
	ret			; $6ec1

@label_6ec2:
	ld l,SpecialObject.counter1		; $6ec2
	dec (hl)		; $6ec4
	ret nz			; $6ec5
	call _companionCutsceneDecAngle		; $6ec6
	ld (hl),$06		; $6ec9
	jp _companionCutsceneFunc_7081		; $6ecb

@substate3:
	ld h,d			; $6ece
	ld l,SpecialObject.angle		; $6ecf
	ld a,(hl)		; $6ed1
	cp $10			; $6ed2
	jr nz,@label_6ec2		; $6ed4
	ld l,SpecialObject.state2		; $6ed6
	inc (hl)		; $6ed8
	ld a,$07		; $6ed9
	jp specialObjectSetAnimation		; $6edb

@substate4:
	ld e,SpecialObject.yh		; $6ede
	ld a,(de)		; $6ee0
	cp $b0			; $6ee1
	ret c			; $6ee3

	ld hl,w1Companion.id		; $6ee4
	ld b,$3f		; $6ee7
	call clearMemory		; $6ee9
	ld hl,w1Companion.id		; $6eec
	ld (hl),SPECIALOBJECTID_DIMITRI_CUTSCENE		; $6eef
	ld l,SpecialObject.yh		; $6ef1
	ld (hl),$e8		; $6ef3
	inc l			; $6ef5
	inc l			; $6ef6
	ld (hl),$28		; $6ef7
	ret			; $6ef9

;;
; @addr{6efa}
_specialObjectCode_dimitriCutscene:
	ld e,SpecialObject.state		; $6efa
	ld a,(de)		; $6efc
	rst_jumpTable			; $6efd
	.dw @state0
	.dw @state1

@state0:
	call _companionCutsceneInitOam		; $6f02
	ld h,d			; $6f05
	ld l,SpecialObject.speed		; $6f06
	ld (hl),SPEED_100		; $6f08
	ld l,SpecialObject.z		; $6f0a
	ld (hl),$e0		; $6f0c
	inc l			; $6f0e
	ld (hl),$ff		; $6f0f
	ld a,$19		; $6f11
	jp specialObjectSetAnimation		; $6f13

@state1:
	ld e,SpecialObject.state2		; $6f16
	ld a,(de)		; $6f18
	rst_jumpTable			; $6f19
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

@substate0:
	ld h,d			; $6f28
	ld l,SpecialObject.state2		; $6f29
	inc (hl)		; $6f2b
	ld l,SpecialObject.counter2		; $6f2c
	ld a,(hl)		; $6f2e
	cp $02			; $6f2f
	jr nz,+			; $6f31

	push af			; $6f33
	ld a,$1a		; $6f34
	call specialObjectSetAnimation		; $6f36
	pop af			; $6f39
+
	ld b,a			; $6f3a
	add a			; $6f3b
	add b			; $6f3c
	ld hl,@@data		; $6f3d
	rst_addAToHl			; $6f40
	ldi a,(hl)		; $6f41
	ld e,SpecialObject.angle		; $6f42
	ld (de),a		; $6f44
	ld c,(hl)		; $6f45
	inc hl			; $6f46
	ld b,(hl)		; $6f47
	jp objectSetSpeedZ		; $6f48


; b0: angle
; b1/b2: speedZ
@@data:
	dbw $0c $fd40
	dbw $0c $fda0
	dbw $13 $fe80


@substate1:
	call specialObjectAnimate		; $6f54
	call objectApplySpeed		; $6f57
	ld c,$18		; $6f5a
	call objectUpdateSpeedZ_paramC		; $6f5c
	ret nz			; $6f5f

	ld h,d			; $6f60
	ld l,SpecialObject.counter2		; $6f61
	inc (hl)		; $6f63
	ld a,(hl)		; $6f64
	ld l,SpecialObject.state2		; $6f65
	cp $03			; $6f67
	jr z,+			; $6f69
	dec (hl)		; $6f6b
	ld l,SpecialObject.counter1		; $6f6c
	ld (hl),$08		; $6f6e
	ret			; $6f70
+
	inc (hl)		; $6f71
	ld l,SpecialObject.counter1		; $6f72
	ld (hl),$06		; $6f74
	ret			; $6f76

@substate2:
	call itemDecCounter1		; $6f77
	ret nz			; $6f7a
	ld l,SpecialObject.state2		; $6f7b
	inc (hl)		; $6f7d
	ld l,SpecialObject.counter1		; $6f7e
	ld (hl),$14		; $6f80
	ld a,$27		; $6f82
	jp specialObjectSetAnimation		; $6f84

@substate3:
	call itemDecCounter1		; $6f87
	ret nz			; $6f8a
	ld l,SpecialObject.state2		; $6f8b
	inc (hl)		; $6f8d
	ld l,SpecialObject.counter1		; $6f8e
	ld (hl),$78		; $6f90
	ret			; $6f92

@substate4:
	call specialObjectAnimate		; $6f93
	call itemDecCounter1		; $6f96
	ret nz			; $6f99
	ld l,SpecialObject.state2		; $6f9a
	inc (hl)		; $6f9c
	ld l,SpecialObject.counter1		; $6f9d
	ld (hl),$3c		; $6f9f
	ld l,SpecialObject.angle		; $6fa1
	ld (hl),$0b		; $6fa3
	ld l,SpecialObject.speed		; $6fa5
	ld (hl),SPEED_80		; $6fa7
	ret			; $6fa9

@substate5:
	call itemDecCounter1		; $6faa
	ret nz			; $6fad
	ld l,SpecialObject.state2		; $6fae
	inc (hl)		; $6fb0
	ld a,$26		; $6fb1
	jp specialObjectSetAnimation		; $6fb3

@substate6:
	call specialObjectAnimate		; $6fb6
	call objectApplySpeed		; $6fb9
	ld e,SpecialObject.xh		; $6fbc
	ld a,(de)		; $6fbe
	cp $78			; $6fbf
	jr nz,+			; $6fc1
	ld a,$05		; $6fc3
	jp specialObjectSetAnimation		; $6fc5
+
	cp $b0			; $6fc8
	ret c			; $6fca

	ld hl,w1Companion.id		; $6fcb
	ld b,$3f		; $6fce
	call clearMemory		; $6fd0
	ld hl,w1Companion.id		; $6fd3
	ld (hl),SPECIALOBJECTID_RICKY_CUTSCENE		; $6fd6
	inc l			; $6fd8
	ld (hl),$01		; $6fd9
	ld l,SpecialObject.yh		; $6fdb
	ld (hl),$48		; $6fdd
	inc l			; $6fdf
	inc l			; $6fe0
	ld (hl),$d8		; $6fe1
	ret			; $6fe3

;;
; @addr{6fe4}
_specialObjectCode_mapleCutscene:
	ld e,SpecialObject.state		; $6fe4
	ld a,(de)		; $6fe6
	rst_jumpTable			; $6fe7
	.dw @state0
	.dw @state1

@state0:
	call _companionCutsceneInitOam		; $6fec
	ld h,d			; $6fef
	ld l,SpecialObject.zh		; $6ff0
	ld (hl),$f0		; $6ff2
	ld l,SpecialObject.angle		; $6ff4
	ld (hl),$08		; $6ff6
	ld l,SpecialObject.counter1		; $6ff8
	ld (hl),$5a		; $6ffa
	ret			; $6ffc

@initPositionSpeedAnimation:
	ld l,SpecialObject.counter2		; $6ffd
	ld a,(hl)		; $6fff
	add a			; $7000
	ld hl,@@data		; $7001
	rst_addDoubleIndex			; $7004
	ldi a,(hl)		; $7005
	ld e,SpecialObject.speed		; $7006
	ld (de),a		; $7008
	ldi a,(hl)		; $7009
	ld e,SpecialObject.counter1		; $700a
	ld (de),a		; $700c
	ldi a,(hl)		; $700d
	ld e,SpecialObject.yh		; $700e
	ld (de),a		; $7010
	ld a,(hl)		; $7011
	jp specialObjectSetAnimation		; $7012


; b0: speed
; b1: counter1
; b2: yh
; b3: animation
@@data:
	.db SPEED_200 $60 $78 $05
	.db SPEED_1c0 $6e $70 $07
	.db SPEED_180 $7d $68 $05
	.db SPEED_040 $e6 $2c $05


@state1:
	call specialObjectAnimate		; $7025
	call objectOscillateZ		; $7028
	ld e,SpecialObject.state2		; $702b
	ld a,(de)		; $702d
	rst_jumpTable			; $702e
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,(wPaletteThread_mode)		; $7037
	or a			; $703a
	call z,itemDecCounter1		; $703b
	ret nz			; $703e
	call itemIncState2		; $703f
	jr @initPositionSpeedAnimation		; $7042

@substate1:
	call itemDecCounter1		; $7044
	jp nz,objectApplySpeed		; $7047
	ld (hl),$5a		; $704a
	inc l			; $704c
	inc (hl)		; $704d
	jp itemIncState2		; $704e

@substate2:
	call itemDecCounter1		; $7051
	ret nz			; $7054

	; Check counter2
	inc l			; $7055
	ld a,(hl)		; $7056
	cp $04			; $7057
	jr nz,++		; $7059

	; Set counter1
	dec l			; $705b
	ld (hl),$1e		; $705c

	call itemIncState2		; $705e
	ld a,$07		; $7061
	jp specialObjectSetAnimation		; $7063
++
	ld l,SpecialObject.state2		; $7066
	dec (hl)		; $7068
	ld l,SpecialObject.angle		; $7069
	ld a,(hl)		; $706b
	xor $10			; $706c
	ld (hl),a		; $706e
	jr @initPositionSpeedAnimation		; $706f

@substate3:
	call itemDecCounter1		; $7071
	jr z,+			; $7074
	ld c,$02		; $7076
	jp objectUpdateSpeedZ_paramC		; $7078
+
	ld a,$ff		; $707b
	ld ($cfdf),a		; $707d
	ret			; $7080

;;
; @param	a	Angle
; @addr{7081}
_companionCutsceneFunc_7081:
	sub $04			; $7081
	and $07			; $7083
	ret nz			; $7085
	ld e,SpecialObject.angle		; $7086
	call convertAngleDeToDirection		; $7088
	dec a			; $708b
	and $03			; $708c
	ld h,d			; $708e
	ld l,SpecialObject.direction		; $708f
	ld (hl),a		; $7091
	ld l,SpecialObject.var36		; $7092
	add (hl)		; $7094
	jp specialObjectSetAnimation		; $7095

;;
; @addr{7098}
_companionCutsceneDecAngle:
	ld e,SpecialObject.angle		; $7098
	ld a,(de)		; $709a
	dec a			; $709b
	and $1f			; $709c
	ld (de),a		; $709e
	ret			; $709f


;;
; @addr{70a0}
specialObjectCode_linkInCutscene:
	ld e,SpecialObject.subid		; $70a0
	ld a,(de)		; $70a2
	rst_jumpTable			; $70a3
	.dw _linkCutscene0
	.dw _linkCutscene1
	.dw _linkCutscene2
	.dw _linkCutscene3
	.dw _linkCutscene4
	.dw _linkCutscene5
	.dw _linkCutscene6
	.dw _linkCutscene7
	.dw _linkCutscene8
	.dw _linkCutscene9
	.dw _linkCutsceneA
	.dw _linkCutsceneB
	.dw _linkCutsceneC


;;
; Opening cutscene with the triforce
; @addr{70be}
_linkCutscene0:
	ld e,Item.state		; $70be
	ld a,(de)		; $70c0
	rst_jumpTable			; $70c1
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $70c6
	call objectSetVisible81		; $70c9
	xor a			; $70cc
	call specialObjectSetAnimation		; $70cd

@state1:
	ld e,SpecialObject.state2		; $70d0
	ld a,(de)		; $70d2
	rst_jumpTable			; $70d3
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw _linkCutscene0_substate6

@substate0:
	ld a,(wLinkAngle)		; $70e2
	rlca			; $70e5
	ld a,$00		; $70e6
	jp c,specialObjectSetAnimation		; $70e8

	ld h,d			; $70eb
	ld l,SpecialObject.yh		; $70ec
	ld a,(wGameKeysPressed)		; $70ee
	bit BTN_BIT_DOWN,a			; $70f1
	jr z,+			; $70f3
	inc (hl)		; $70f5
+
	bit BTN_BIT_UP,a			; $70f6
	jr z,+			; $70f8
	dec (hl)		; $70fa
+
	ld a,(hl)		; $70fb
	cp $40			; $70fc
	jp nc,specialObjectAnimate		; $70fe
	ld a,$01		; $7101
	ld (wTmpcbb9),a		; $7103
	ld a,SND_DROPESSENCE		; $7106
	call playSound		; $7108
	jp itemIncState2		; $710b

@substate1:
	ld a,(wTmpcbb9)		; $710e
	cp $02			; $7111
	ret nz			; $7113

	call itemIncState2		; $7114
	ld b,$04		; $7117
	call func_2d48		; $7119
	ld a,b			; $711c
	ld e,SpecialObject.counter1		; $711d
	ld (de),a		; $711f
	ld a,$04		; $7120
	jp specialObjectSetAnimation		; $7122

@substate2:
	call itemDecCounter1		; $7125
	jp nz,specialObjectAnimate		; $7128

	ld l,SpecialObject.speed		; $712b
	ld (hl),SPEED_20		; $712d
	ld b,$05		; $712f
	call func_2d48		; $7131
	ld a,b			; $7134
	ld e,SpecialObject.counter1		; $7135
	ld (de),a		; $7137
	jp itemIncState2		; $7138

@substate3:
	call itemDecCounter1		; $713b
	jp nz,++		; $713e

	call itemIncState2		; $7141
	ld b,$07		; $7144
	call func_2d48		; $7146
	ld a,b			; $7149
	ld e,SpecialObject.counter1		; $714a
	ld (de),a		; $714c
++
	ld hl,_linkCutscene_zOscillation0		; $714d
	jr _linkCutscene_oscillateZ		; $7150

@substate4:
	call itemDecCounter1		; $7152
	jp nz,_linkCutscene_oscillateZ_1		; $7155
	ld a,$03		; $7158
	ld (wTmpcbb9),a		; $715a
	call itemIncState2		; $715d

@substate5:
	ld a,(wTmpcbb9)		; $7160
	cp $06			; $7163
	jr nz,_linkCutscene_oscillateZ_1	; $7165

;;
; Creates the colored orb that appears under Link in the opening cutscene
; @addr{7167}
_linkCutscene_createGlowingOrb:
	ldbc INTERACID_SPARKLE, $06		; $7167
	call objectCreateInteraction		; $716a
	jr nz,+			; $716d
	ld l,Interaction.relatedObj1		; $716f
	ld a,SpecialObject.start		; $7171
	ldi (hl),a		; $7173
	ld (hl),d		; $7174
+
	call itemIncState2		; $7175
	ld a,$05		; $7178
	jp specialObjectSetAnimation		; $717a

;;
; @addr{717d}
_linkCutscene_oscillateZ_1:
	ld hl,_linkCutscene_zOscillation1		; $717d

;;
; @addr{7180}
_linkCutscene_oscillateZ:
	ld a,($cbb7)		; $7180
	and $07			; $7183
	jr nz,++		; $7185

	ld a,($cbb7)		; $7187
	and $38			; $718a
	swap a			; $718c
	rlca			; $718e
	rst_addAToHl			; $718f
	ld e,SpecialObject.zh		; $7190
	ld a,(hl)		; $7192
	ld b,a			; $7193
	ld a,(de)		; $7194
	add b			; $7195
	ld (de),a		; $7196
++
	jp specialObjectAnimate		; $7197

_linkCutscene_zOscillation0
	.db $ff $fe $fe $ff $00 $01 $01 $00

_linkCutscene_zOscillation1:
	.db $ff $ff $ff $00 $01 $01 $01 $00

_linkCutscene_zOscillation2:
	.db $02 $03 $04 $03 $02 $00 $ff $00


_linkCutscene0_substate6:
	ld e,SpecialObject.animParameter		; $71b2
	ld a,(de)		; $71b4
	inc a			; $71b5
	jr nz,+			; $71b6
	ld a,$07		; $71b8
	ld (wTmpcbb9),a		; $71ba
	ret			; $71bd
+
	call specialObjectAnimate		; $71be
	ld a,($cbb7)		; $71c1
	rrca			; $71c4
	jp nc,objectSetInvisible		; $71c5
	jp objectSetVisible		; $71c8


;;
; @addr{71cb}
_linkCutscene1:
	ld e,SpecialObject.state		; $71cb
	ld a,(de)		; $71cd
	rst_jumpTable			; $71ce
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $71d3
	ld e,SpecialObject.counter1		; $71d6
	ld a,$78		; $71d8
	ld (de),a		; $71da
	xor a			; $71db
	ld e,SpecialObject.direction		; $71dc
	ld (de),a		; $71de
	call specialObjectSetAnimation		; $71df

@state1:
	ld e,SpecialObject.state2		; $71e2
	ld a,(de)		; $71e4
	rst_jumpTable			; $71e5
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw _linkCutsceneRet

@substate0:
	call itemDecCounter1		; $71f0
	ret nz			; $71f3
	call itemIncState2		; $71f4
	ld l,SpecialObject.speed		; $71f7
	ld (hl),SPEED_100		; $71f9
	ld l,SpecialObject.xh		; $71fb
	ld a,(hl)		; $71fd
	cp $48			; $71fe
	ld a,$00		; $7200
	jr z,++			; $7202
	ld a,$18		; $7204
	jr nc,++		; $7206
	ld a,$08		; $7208
++
	ld l,SpecialObject.angle		; $720a
	ld (hl),a		; $720c
	swap a			; $720d
	rlca			; $720f
	jp specialObjectSetAnimation		; $7210

@substate1:
	ld e,SpecialObject.xh		; $7213
	ld a,(de)		; $7215
	cp $48			; $7216
	jr nz,++		; $7218
	call itemIncState2		; $721a
	ld l,SpecialObject.counter1		; $721d
	ld (hl),$04		; $721f
	ret			; $7221
++
	call objectApplySpeed		; $7222
	jp specialObjectAnimate		; $7225

@substate2:
	call itemDecCounter1		; $7228
	ret nz			; $722b
	ld (hl),$2e		; $722c
	call itemIncState2		; $722e
	ld l,SpecialObject.angle		; $7231
	ld (hl),$00		; $7233
	xor a			; $7235
	jp specialObjectSetAnimation		; $7236

@substate3:
	call specialObjectAnimate		; $7239
	call objectApplySpeed		; $723c
	call itemDecCounter1		; $723f
	ret nz			; $7242
	ld hl,$cfd0		; $7243
	ld (hl),$01		; $7246
	ld a,SND_CLINK		; $7248
	call playSound		; $724a
	jp itemIncState2		; $724d

_linkCutsceneRet:
	ret			; $7250

;;
; @addr{7251}
_linkCutscene2:
	ld e,SpecialObject.state		; $7251
	ld a,(de)		; $7253
	rst_jumpTable			; $7254
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $7259
	ld bc,$3838		; $725c
	call objectGetRelativeAngle		; $725f
	ld e,SpecialObject.angle		; $7262
	ld (de),a		; $7264
	call convertAngleDeToDirection		; $7265
	jp specialObjectSetAnimation		; $7268

@state1:
	ld e,SpecialObject.state2		; $726b
	ld a,(de)		; $726d
	rst_jumpTable			; $726e
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8

@substate0:
	ld a,($cfd0)		; $7281
	cp $02			; $7284
	ret nz			; $7286

	call itemIncState2		; $7287
	ld l,SpecialObject.yh		; $728a
	ldi a,(hl)		; $728c
	cp $48			; $728d
	ld a,$18		; $728f
	ld b,$04		; $7291
	jr z,++			; $7293
	ld a,$10		; $7295
	jr c,++			; $7297

	inc l			; $7299
	ld b,$01		; $729a
	ld a,(hl)		; $729c
	cp $38			; $729d
	ld a,$00		; $729f
	jr z,++			; $72a1
	ld a,$18		; $72a3
	jr nc,++		; $72a5
	ld a,$08		; $72a7
++
	ld l,SpecialObject.state2		; $72a9
	ld (hl),b		; $72ab
	ld l,SpecialObject.angle		; $72ac
	ld (hl),a		; $72ae
	swap a			; $72af
	rlca			; $72b1
	jp specialObjectSetAnimation		; $72b2

@substate1:
	call specialObjectAnimate		; $72b5
	call _linkCutscene_cpxTo38		; $72b8
	jp nz,objectApplySpeed		; $72bb

	call itemIncState2		; $72be
	ld l,SpecialObject.counter1		; $72c1
	ld (hl),$08		; $72c3
	ret			; $72c5

@substate2:
	ld b,$00		; $72c6

@label_72c8:
	call itemDecCounter1		; $72c8
	ret nz			; $72cb

@label_72cc:
	call itemIncState2		; $72cc
	ld l,SpecialObject.angle		; $72cf
	ld (hl),b		; $72d1
	ld a,b			; $72d2
	swap a			; $72d3
	rlca			; $72d5
	jp specialObjectSetAnimation		; $72d6

@substate3:
	call specialObjectAnimate		; $72d9
	call _linkCutscene_cpyTo48		; $72dc
	jp nz,objectApplySpeed		; $72df

@gotoState7:
	ld h,d			; $72e2
	ld l,SpecialObject.state2		; $72e3
	ld (hl),$07		; $72e5
	ld l,SpecialObject.counter1		; $72e7
	ld (hl),$3c		; $72e9
	xor a			; $72eb
	jp specialObjectSetAnimation		; $72ec

@substate4:
	call specialObjectAnimate		; $72ef
	call _linkCutscene_cpyTo48		; $72f2
	jp nz,objectApplySpeed		; $72f5
	call itemIncState2		; $72f8
	ld l,SpecialObject.counter1		; $72fb
	ld (hl),$08		; $72fd
	ret			; $72ff

@substate5:
	ld b,$18		; $7300
	jp @label_72c8		; $7302

@substate6:
	call specialObjectAnimate		; $7305
	call _linkCutscene_cpxTo38		; $7308
	jp nz,objectApplySpeed		; $730b
	jr @gotoState7			; $730e

@substate7:
	call itemDecCounter1		; $7310
	ret nz			; $7313
	ld (hl),$10		; $7314
	ld b,$00		; $7316
	call @label_72cc		; $7318
	ld hl,$cfd0		; $731b
	ld (hl),$03		; $731e
	ret			; $7320

@substate8:
	ret			; $7321

;;
; @addr{7322}
_linkCutscene3:
	ld e,SpecialObject.state		; $7322
	ld a,(de)		; $7324
	rst_jumpTable			; $7325
.dw @state0
.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $732a
	ld a,$01		; $732d
	jp specialObjectSetAnimation		; $732f

@state1:
	ld e,SpecialObject.state2		; $7332
	ld a,(de)		; $7334
	rst_jumpTable			; $7335
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
	.dw @substate9

@substate0:
	ld a,($cfd0)		; $734a
	cp $09			; $734d
	ret nz			; $734f

	call itemIncState2		; $7350
	ld l,SpecialObject.yh		; $7353
	ld a,$30		; $7355
	ldi (hl),a		; $7357
	inc l			; $7358
	ld a,$78		; $7359
	ld (hl),a		; $735b
	ld a,$01		; $735c
	jp specialObjectSetAnimation		; $735e

@substate1:
	ld a,($cfd0)		; $7361
	cp $0a			; $7364
	ret nz			; $7366
	call itemIncState2		; $7367
	ld l,SpecialObject.counter1		; $736a
	ld (hl),$1e		; $736c
	ret			; $736e

@substate2:
	call itemDecCounter1		; $736f
	ret nz			; $7372
	call itemIncState2		; $7373
	xor a			; $7376
	jp specialObjectSetAnimation		; $7377

@substate3:
	ld b,$0e		; $737a
	ld c,$02		; $737c
	ld a,($cfd0)		; $737e
	cp b			; $7381
	ret nz			; $7382
	call itemIncState2		; $7383
	ld a,c			; $7386
	jp specialObjectSetAnimation		; $7387

@substate4:
	ld a,($cfd0)		; $738a
	cp $11			; $738d
	ret nz			; $738f

	call itemIncState2		; $7390
	ld l,SpecialObject.angle		; $7393
	ld (hl),$18		; $7395
	ld l,SpecialObject.speed		; $7397
	ld (hl),SPEED_180		; $7399
	ld l,SpecialObject.counter1		; $739b
	ld (hl),$16		; $739d
	ld a,SND_UNKNOWN5		; $739f
	call playSound		; $73a1
	ld a,$03		; $73a4
	jp specialObjectSetAnimation		; $73a6

@substate5:
	call _linkCutscene_animateAndDecCounter1		; $73a9
	jp nz,objectApplySpeed		; $73ac
	call itemIncState2		; $73af
	ld l,SpecialObject.counter1		; $73b2
	ld (hl),$06		; $73b4

@substate9:
	ret			; $73b6

@substate6:
	call itemDecCounter1		; $73b7
	ret nz			; $73ba
	ld (hl),$08		; $73bb
	ld l,SpecialObject.angle		; $73bd
	ld (hl),$10		; $73bf
	ld a,$02		; $73c1
	ld l,SpecialObject.direction		; $73c3
	ld (hl),a		; $73c5
	call specialObjectSetAnimation		; $73c6
	jp itemIncState2		; $73c9

@substate7:
	call _linkCutscene_animateAndDecCounter1		; $73cc
	jp nz,objectApplySpeed		; $73cf
	ld a,SND_UNKNOWN5		; $73d2
	call playSound		; $73d4
	jp itemIncState2		; $73d7

@substate8:
	ld a,($cfd2)		; $73da
	or a			; $73dd
	jr z,_linkCutsceneFunc_73e8			; $73de

	ld a,$03		; $73e0
	call specialObjectSetAnimation		; $73e2
	jp itemIncState2		; $73e5

;;
; @addr{73e8}
_linkCutsceneFunc_73e8:
	ld a,(wFrameCounter)		; $73e8
	and $07			; $73eb
	ret nz			; $73ed

	callab interactionBank0a.func_0a_7877		; $73ee
	call objectGetRelativeAngle		; $73f6
	call convertAngleToDirection		; $73f9
	ld h,d			; $73fc
	ld l,SpecialObject.direction		; $73fd
	cp (hl)			; $73ff
	ret z			; $7400
	ld (hl),a		; $7401
	jp specialObjectSetAnimation		; $7402

;;
; @addr{7405}
_linkCutscene4:
	ld e,SpecialObject.state		; $7405
	ld a,(de)		; $7407
	rst_jumpTable			; $7408
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $740d
	ld l,SpecialObject.yh		; $7410
	ld a,$38		; $7412
	ldi (hl),a		; $7414
	inc l			; $7415
	ld a,$58		; $7416
	ld (hl),a		; $7418
	xor a			; $7419
	jp specialObjectSetAnimation		; $741a

@state1:
	ld e,SpecialObject.state2		; $741d
	ld a,(de)		; $741f
	rst_jumpTable			; $7420
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	ld a,($cfd0)		; $742d
	cp $1f			; $7430
	ret nz			; $7432
	jp itemIncState2		; $7433

@substate1:
	ld a,($cfd0)		; $7436
	cp $20			; $7439
	jp nz,_linkCutsceneFunc_73e8		; $743b
	call itemIncState2		; $743e
	ld l,SpecialObject.counter1		; $7441
	ld (hl),$50		; $7443
	ret			; $7445

@substate2:
	call itemDecCounter1		; $7446
	ret nz			; $7449
	ld (hl),$30		; $744a
	ld l,SpecialObject.speed		; $744c
	ld (hl),SPEED_100		; $744e
	ld b,$10		; $7450
	jp _linkCutscene2@label_72cc		; $7452

@substate3:
	call _linkCutscene_animateAndDecCounter1		; $7455
	jp nz,objectApplySpeed		; $7458
	ld (hl),$08		; $745b
	jp itemIncState2		; $745d

@substate4:
	call itemDecCounter1		; $7460
	ret nz			; $7463
	ld (hl),$10		; $7464
	ld b,$18		; $7466
	jp _linkCutscene2@label_72cc		; $7468

@substate5:
	call _linkCutscene_animateAndDecCounter1		; $746b
	jp nz,objectApplySpeed		; $746e
	ld a,$21		; $7471
	ld ($cfd0),a		; $7473
	ld a,$81		; $7476
	ld (wMenuDisabled),a		; $7478
	ld (wDisabledObjects),a		; $747b
	ld e,SpecialObject.direction		; $747e
	ld a,$03		; $7480
	ld (de),a		; $7482
	lda SPECIALOBJECTID_LINK			; $7483
	jp setLinkIDOverride		; $7484

;;
; @addr{7487}
_linkCutscene_cpyTo48:
	ld e,SpecialObject.yh		; $7487
	ld a,(de)		; $7489
	cp $48			; $748a
	ret			; $748c

;;
; @addr{748d}
_linkCutscene_cpxTo38:
	ld e,SpecialObject.xh		; $748d
	ld a,(de)		; $748f
	cp $38			; $7490
	ret			; $7492

;;
; @addr{7493}
_linkCutscene_initOam_setVisible_incState:
	callab bank5.specialObjectSetOamVariables		; $7493
	call objectSetVisiblec1		; $749b
	jp itemIncState		; $749e

;;
; @addr{74a1}
_linkCutscene_animateAndDecCounter1:
	call specialObjectAnimate		; $74a1
	jp itemDecCounter1		; $74a4

;;
; @addr{74a7}
_linkCutscene5:
	ld e,SpecialObject.state		; $74a7
	ld a,(de)		; $74a9
	rst_jumpTable			; $74aa
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $74af
	ld l,SpecialObject.speed		; $74b2
	ld (hl),SPEED_100		; $74b4
	ld l,SpecialObject.var3d		; $74b6
	ld (hl),$00		; $74b8
	ld l,SpecialObject.direction		; $74ba
	ld (hl),$ff		; $74bc

@state1:
	call _linkCutscene_updateAngleOnPath		; $74be
	jr z,+			; $74c1
	call specialObjectAnimate		; $74c3
	jp objectApplySpeed		; $74c6
+
	ld a,SPECIALOBJECTID_LINK		; $74c9
	jp setLinkIDOverride		; $74cb

;;
; @addr{74ce}
_linkCutscene6:
	ld e,SpecialObject.state		; $74ce
	ld a,(de)		; $74d0
	rst_jumpTable			; $74d1
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $74d6
	ld l,SpecialObject.speed		; $74d9
	ld (hl),SPEED_80		; $74db
	ld b,$16		; $74dd
	ld l,SpecialObject.angle		; $74df
	ld a,(hl)		; $74e1
	cp $08			; $74e2
	jr z,+			; $74e4
	ld b,$15		; $74e6
+
	ld a,b			; $74e8
	call specialObjectSetAnimation		; $74e9

@state1:
	ld e,SpecialObject.state2		; $74ec
	ld a,(de)		; $74ee
	rst_jumpTable			; $74ef
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call specialObjectAnimate		; $74f6
	call getThisRoomFlags		; $74f9
	and $c0			; $74fc
	jp z,objectApplySpeed		; $74fe
	jp itemIncState2		; $7501

@substate1:
	ld a,($cfd0)		; $7504
	cp $07			; $7507
	ret nz			; $7509
	call itemIncState2		; $750a
	ld a,$02		; $750d
	jp specialObjectSetAnimation		; $750f

@substate2:
	ret			; $7512

;;
; @addr{7513}
_linkCutscene7:
	ld e,SpecialObject.state		; $7513
	ld a,(de)		; $7515
	rst_jumpTable			; $7516
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $751b
	ld l,SpecialObject.counter1		; $751e
	ld (hl),$f0		; $7520
	ld a,$14		; $7522
	jp specialObjectSetAnimation		; $7524

@state1:
	call specialObjectAnimate		; $7527
	call itemDecCounter1		; $752a
	ret nz			; $752d
	lda SPECIALOBJECTID_LINK			; $752e
	call setLinkIDOverride		; $752f
	ld l,SpecialObject.direction		; $7532
	ld (hl),$02		; $7534
	ld a,$01		; $7536
	ld (wUseSimulatedInput),a		; $7538
	ld (wMenuDisabled),a		; $753b
	ret			; $753e

;;
; @addr{753f}
_linkCutscene8:
	ld e,SpecialObject.state		; $753f
	ld a,(de)		; $7541
	rst_jumpTable			; $7542
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $7547
	ld l,SpecialObject.yh		; $754a
	ld (hl),$68		; $754c
	ld l,SpecialObject.xh		; $754e
	ld (hl),$50		; $7550
	ld a,$00		; $7552
	call specialObjectSetAnimation		; $7554
	jp objectSetInvisible		; $7557

@state1:
	ld e,SpecialObject.state2		; $755a
	ld a,(de)		; $755c
	rst_jumpTable			; $755d
	.dw @substate0
	.dw @substate1

@substate0:
	ld a,($cfd0)		; $7562
	cp $03			; $7565
	jr z,+			; $7567
	ld a,($cfd0)		; $7569
	cp $01			; $756c
	ret nz			; $756e
+
	call itemIncState2		; $756f
	jp objectSetVisiblec2		; $7572

@substate1:
	ret			; $7575

;;
; @addr{7576}
_linkCutscene9:
	ld e,SpecialObject.state		; $7576
	ld a,(de)		; $7578
	rst_jumpTable			; $7579
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $757e
	ld a,$02		; $7581
	call specialObjectSetAnimation		; $7583
	jp objectSetInvisible		; $7586

@state1:
	ld e,SpecialObject.state2		; $7589
	ld a,(de)		; $758b
	rst_jumpTable			; $758c
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld a,($cfc0)		; $7597
	cp $01			; $759a
	ret nz			; $759c
	call itemIncState2		; $759d
	jp objectSetVisible82		; $75a0

@substate1:
	ld a,($cfc0)		; $75a3
	cp $03			; $75a6
	ret nz			; $75a8
	call itemIncState2		; $75a9

@substate2:
	ld a,($cfc0)		; $75ac
	cp $06			; $75af
	jp nz,_linkCutsceneFunc_73e8		; $75b1

	call itemIncState2		; $75b4
	ld bc,$fe40		; $75b7
	call objectSetSpeedZ		; $75ba
	ld a,$0d		; $75bd
	jp specialObjectSetAnimation		; $75bf

@substate3:
	ld c,$20		; $75c2
	call objectUpdateSpeedZ_paramC		; $75c4
	ret nz			; $75c7

	call itemIncState2		; $75c8
	ld l,SpecialObject.counter1		; $75cb
	ld (hl),$78		; $75cd
	ld l,SpecialObject.animCounter		; $75cf
	ld (hl),$01		; $75d1
	ret			; $75d3

@substate4:
	call itemDecCounter1		; $75d4
	jp nz,specialObjectAnimate		; $75d7
	ld hl,$cfdf		; $75da
	ld (hl),$ff		; $75dd
	ret			; $75df

;;
; Link being kissed by Zelda in ending cutscene
;
; @addr{75e0}
_linkCutsceneA:
	ld e,SpecialObject.state		; $75e0
	ld a,(de)		; $75e2
	rst_jumpTable			; $75e3
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $75e8
	call objectSetInvisible		; $75eb

	call @checkShieldEquipped		; $75ee
	ld a,$0b		; $75f1
	jr nz,+			; $75f3
	ld a,$0f		; $75f5
+
	jp specialObjectSetAnimation		; $75f7

;;
; @param[out]	zflag	Set if shield equipped
; @addr{75fa}
@checkShieldEquipped:
	ld hl,wInventoryB		; $75fa
	ld a,ITEMID_SHIELD		; $75fd
	cp (hl)			; $75ff
	ret z			; $7600
	inc l			; $7601
	cp (hl)			; $7602
	ret			; $7603

@state1:
	ld e,SpecialObject.state2		; $7604
	ld a,(de)		; $7606
	rst_jumpTable			; $7607
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfc0)		; $7610
	cp $01			; $7613
	ret nz			; $7615

	call itemIncState2		; $7616
	jp objectSetVisible82		; $7619

@substate1:
	ld a,($cfc0)		; $761c
	cp $07			; $761f
	ret nz			; $7621

	call itemIncState2		; $7622
	call @checkShieldEquipped		; $7625
	ld a,$10		; $7628
	jr nz,+			; $762a
	inc a			; $762c
+
	jp specialObjectSetAnimation		; $762d

@substate2:
	ld a,($cfc0)		; $7630
	cp $08			; $7633
	ret nz			; $7635

	call itemIncState2		; $7636
	ld l,SpecialObject.counter1		; $7639
	ld (hl),$68		; $763b
	inc l			; $763d
	ld (hl),$01		; $763e
	ld b,$02		; $7640
--
	call getFreeInteractionSlot		; $7642
	jr nz,@@setAnimation	; $7645
	ld (hl),INTERACID_KISS_HEART		; $7647
	inc l			; $7649
	ld a,b			; $764a
	dec a			; $764b
	ld (hl),a		; $764c
	call objectCopyPosition		; $764d
	dec b			; $7650
	jr nz,--		; $7651

@@setAnimation:
	ld a,$12		; $7653
	jp specialObjectSetAnimation		; $7655

@substate3:
	call specialObjectAnimate		; $7658
	ld h,d			; $765b
	ld l,SpecialObject.counter1		; $765c
	call decHlRef16WithCap		; $765e
	ret nz			; $7661

	ld hl,$cfc0		; $7662
	ld (hl),$09		; $7665
	ret			; $7667

;;
; Cutscene played on starting a new game ("accept our quest, hero")
;
; @addr{7668}
_linkCutsceneB:
	ld e,SpecialObject.state		; $7668
	ld a,(de)		; $766a
	rst_jumpTable			; $766b
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $7670
	call objectSetVisible81		; $7673

	ld l,SpecialObject.counter1		; $7676
	ld (hl),$2c		; $7678
	inc hl			; $767a
	ld (hl),$01		; $767b
	ld l,SpecialObject.yh		; $767d
	ld (hl),$d0		; $767f
	ld l,SpecialObject.xh		; $7681
	ld (hl),$50		; $7683

	ld a,$08		; $7685
	call specialObjectSetAnimation		; $7687
	xor a			; $768a
	ld (wTmpcbb9),a		; $768b

	ldbc INTERACID_SPARKLE, $0d		; $768e
	call objectCreateInteraction		; $7691
	jr nz,@state1	; $7694
	ld l,Interaction.relatedObj1		; $7696
	ld a,SpecialObject.start		; $7698
	ldi (hl),a		; $769a
	ld (hl),d		; $769b

@state1:
	ld a,(wFrameCounter)		; $769c
	ld ($cbb7),a		; $769f
	ld e,SpecialObject.state2		; $76a2
	ld a,(de)		; $76a4
	rst_jumpTable			; $76a5
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call _linkCutscene_oscillateZ_2		; $76ae
	ld hl,w1Link.counter1		; $76b1
	call decHlRef16WithCap		; $76b4
	ret nz			; $76b7

	ld (hl),$3c		; $76b8
	jp itemIncState2		; $76ba

@substate1:
	call _linkCutscene_oscillateZ_2		; $76bd
	call itemDecCounter1		; $76c0
	ret nz			; $76c3

	call itemIncState2		; $76c4
	ld bc,TX_1213		; $76c7
	jp showText		; $76ca

@substate2:
	ld hl,_linkCutscene_zOscillation1		; $76cd
	call _linkCutscene_oscillateZ		; $76d0
	ld a,(wTextIsActive)		; $76d3
	or a			; $76d6
	ret nz			; $76d7

	ld a,$06		; $76d8
	ld (wTmpcbb9),a		; $76da
	ld a,SND_FAIRYCUTSCENE		; $76dd
	call playSound		; $76df
	jp _linkCutscene_createGlowingOrb		; $76e2

@substate3:
	ld e,SpecialObject.animParameter		; $76e5
	ld a,(de)		; $76e7
	inc a			; $76e8
	jr nz,+			; $76e9
	ld a,$07		; $76eb
	ld (wTmpcbb9),a		; $76ed
	ret			; $76f0
+
	call specialObjectAnimate		; $76f1
	ld a,(wFrameCounter)		; $76f4
	rrca			; $76f7
	jp nc,objectSetInvisible		; $76f8
	jp objectSetVisible		; $76fb

;;
; @addr{76fe}
_linkCutsceneC:
	ld e,SpecialObject.state		; $76fe
	ld a,(de)		; $7700
	rst_jumpTable			; $7701
	.dw @state0
	.dw _linkCutsceneRet

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $7706
	ld bc,$f804		; $7709
	ld a,$ff		; $770c
	call objectCreateExclamationMark		; $770e
	ld l,Interaction.subid		; $7711
	ld (hl),$01		; $7713
	ld a,$06		; $7715
	jp specialObjectSetAnimation		; $7717

;;
; @addr{771a}
_linkCutscene_oscillateZ_2:
	ld hl,_linkCutscene_zOscillation2		; $771a
	jp _linkCutscene_oscillateZ		; $771d

;;
; Update Link's angle to follow a certain path. Which path it is depends on var03 (value
; from 0-2).
;
; @param[out]	zflag	Set if reached the destination
; @addr{7720}
_linkCutscene_updateAngleOnPath:
	ld e,SpecialObject.var03		; $7720
	ld a,(de)		; $7722
	ld hl,@paths		; $7723
	rst_addDoubleIndex			; $7726
	ldi a,(hl)		; $7727
	ld h,(hl)		; $7728
	ld l,a			; $7729

	ld e,SpecialObject.var3d		; $772a
	ld a,(de)		; $772c
	add a			; $772d
	rst_addAToHl			; $772e
	ldi a,(hl)		; $772f
	cp $ff			; $7730
	ret z			; $7732

	or a			; $7733
	jr nz,@checkX		; $7734

	ld e,SpecialObject.yh		; $7736
	ld a,(de)		; $7738
	sub (hl)		; $7739
	ld b,$00		; $773a
	jr nc,+			; $773c
	ld b,$02		; $773e
+
	jr nz,@updateDirection	; $7740
	jr @next		; $7742

@checkX:
	ld e,SpecialObject.xh		; $7744
	ld a,(de)		; $7746
	sub (hl)		; $7747
	ld b,$03		; $7748
	jr nc,+			; $774a
	ld b,$01		; $774c
+
	jr nz,@updateDirection	; $774e

@next:
	ld h,d			; $7750
	ld l,SpecialObject.var3d		; $7751
	inc (hl)		; $7753
	call @updateDirection		; $7754
	jr _linkCutscene_updateAngleOnPath		; $7757

;;
; @param	b	Direction value
; @param[out]	zflag	Unset
; @addr{7759}
@updateDirection:
	ld e,SpecialObject.direction		; $7759
	ld a,(de)		; $775b
	cp b			; $775c
	jr z,@ret		; $775d

	ld a,b			; $775f
	ld (de),a		; $7760
	call specialObjectSetAnimation		; $7761
	ld e,SpecialObject.direction		; $7764
	ld a,(de)		; $7766
	swap a			; $7767
	rrca			; $7769
	ld e,SpecialObject.angle		; $776a
	ld (de),a		; $776c

@ret:
	or d			; $776d
	ret			; $776e


@paths:
	.dw @@path0
	.dw @@path1
	.dw @@path2

; Data format:
;  b0: 0 for y, 1 for x
;  b1: Target position to walk to

@@path0: ; Just saved the maku sapling, moving toward her
	.db $00 $38
	.db $01 $50
	.db $00 $38
	.db $ff

@@path1: ; Just freed the goron elder, moving toward him
	.db $01 $38
	.db $00 $60
	.db $ff

@@path2: ; Funny joke cutscene in trading sequence
	.db $00 $48
	.db $ff


.include "build/data/signText.s"


; @addr{7818}
_breakableTileCollisionTable:
	.dw _breakableTileCollision0Data
	.dw _breakableTileCollision1Data
	.dw _breakableTileCollision2Data
	.dw _breakableTileCollision3Data
	.dw _breakableTileCollision4Data
	.dw _breakableTileCollision5Data

; 1st byte is the tile index, 2nd is an index for "_breakableTileModes".

; @addr{7824}
_breakableTileCollision0Data:
_breakableTileCollision4Data:
	.db $da $32
	.db $f8 $00
	.db $f2 $0d
	.db $c0 $07
	.db $c1 $08
	.db $c2 $09
	.db $c3 $0b
	.db $c4 $0a
	.db $c5 $01
	.db $c6 $04
	.db $c7 $03
	.db $c8 $06
	.db $c9 $02
	.db $ca $05
	.db $cb $12
	.db $cc $13
	.db $cd $0e
	.db $ce $0f
	.db $cf $10
	.db $d1 $0c
	.db $db $14
	.db $04 $15
	.db $01 $11
	.db $10 $11
	.db $11 $11
	.db $12 $11
	.db $13 $11
	.db $14 $11
	.db $15 $11
	.db $16 $11
	.db $17 $11
	.db $18 $11
	.db $19 $11
	.db $1a $11
	.db $1b $11
	.db $20 $11
	.db $21 $11
	.db $22 $11
	.db $23 $11
	.db $24 $11
	.db $25 $11
	.db $26 $11
	.db $27 $11
	.db $28 $11
	.db $29 $11
	.db $2a $11
	.db $2b $11
	.db $30 $11
	.db $31 $11
	.db $32 $11
	.db $33 $11
	.db $34 $11
	.db $35 $11
	.db $36 $11
	.db $37 $11
	.db $38 $11
	.db $39 $11
	.db $3a $11
	.db $3b $11
	.db $af $11
	.db $bf $11
	.db $00
; @addr{789f}
_breakableTileCollision1Data:
_breakableTileCollision2Data:
_breakableTileCollision5Data:
	.db $da $32
	.db $f2 $16
	.db $f8 $2a
	.db $20 $17
	.db $21 $18
	.db $22 $19
	.db $23 $1a
	.db $ef $2b
	.db $11 $1b
	.db $12 $1c
	.db $10 $1d
	.db $13 $1e
	.db $1f $1f
	.db $30 $20
	.db $31 $21
	.db $32 $22
	.db $33 $23
	.db $38 $24
	.db $39 $25
	.db $3a $26
	.db $3b $27
	.db $16 $28
	.db $15 $29
	.db $db $2d
	.db $24 $2c
	.db $68 $2e
	.db $69 $2f
	.db $00
; @addr{78d6}
_breakableTileCollision3Data:
	.db $da $32
	.db $12 $30
	.db $71 $31
	.db $00

; Data format:
;  First 3 parameters are ways the tile can be broken.
;  4th parameter:
;   Dunno
;  5th parameter:
;   Bits 0-3: the id of the interaction that should be created when the
;             object is destroyed (ie. bush destroying animation).
;   Bit 4:    sets the subid (0 or 1) which tells it whether to flicker.
;   Bit 6:    whether to play the discovery sound.
;   Bit 7:    set if the game should call updateRoomFlagsForBrokenTile on breakage
;  6th parameter:
;   The tile it should turn into when broken, or $00 for no change.
.macro m_BreakableTileData
	.if \3 > $f
	.fail
	.endif
	.if \4 > $f
	.fail
	.endif

	.db \1 \2
	.db \3 | (\4<<4)
	.db \5 \6
.endm

; @addr{78dd}
_breakableTileModes:
	m_BreakableTileData %10010110 %00110000 %0010 $1 $10 $3a ; $00
	m_BreakableTileData %10110111 %10110001 %0110 $1 $00 $3a ; $01
	m_BreakableTileData %10110111 %10110001 %0110 $0 $c0 $d7 ; $02
	m_BreakableTileData %10110111 %10110001 %0110 $0 $c0 $d2 ; $03
	m_BreakableTileData %10110111 %10110001 %0110 $0 $c0 $dc ; $04
	m_BreakableTileData %10110111 %10110001 %0110 $0 $00 $f3 ; $05
	m_BreakableTileData %10110111 %10110001 %0110 $0 $00 $3a ; $06
	m_BreakableTileData %00100001 %00000000 %0000 $4 $06 $3a ; $07
	m_BreakableTileData %00100001 %00000000 %0000 $0 $c6 $dc ; $08
	m_BreakableTileData %00100001 %00000000 %0000 $0 $c6 $d2 ; $09
	m_BreakableTileData %00100001 %00000000 %0000 $0 $c6 $d7 ; $0a
	m_BreakableTileData %00100001 %00000000 %0000 $0 $06 $3a ; $0b
	m_BreakableTileData %00110000 %10000000 %0000 $0 $c6 $dd ; $0c
	m_BreakableTileData %10101101 %00010001 %0000 $7 $0c $3a ; $0d
	m_BreakableTileData %01000000 %10000000 %0111 $4 $0a $3a ; $0e
	m_BreakableTileData %00000000 %00010000 %0000 $7 $1f $3a ; $0f
	m_BreakableTileData %00000000 %00010000 %0000 $0 $df $dc ; $10
	m_BreakableTileData %01000000 %00000000 %0000 $9 $0a $1c ; $11
	m_BreakableTileData %01000000 %00000000 %0000 $0 $ca $d2 ; $12
	m_BreakableTileData %01000000 %00000000 %0000 $0 $0a $d7 ; $13
	m_BreakableTileData %00100000 %00000001 %0000 $0 $06 $3a ; $14
	m_BreakableTileData %00010110 %10010000 %1111 $0 $00 $3b ; $15
	m_BreakableTileData %10101101 %00010001 %0000 $7 $0c $a0 ; $16
	m_BreakableTileData %10110111 %00110001 %0100 $1 $00 $a0 ; $17
	m_BreakableTileData %10110111 %00110001 %0100 $0 $00 $a0 ; $18
	m_BreakableTileData %10110111 %00110001 %0100 $0 $40 $45 ; $19
	m_BreakableTileData %10110111 %00110001 %0100 $0 $00 $f3 ; $1a
	m_BreakableTileData %00100101 %00000001 %0000 $0 $06 $a0 ; $1b
	m_BreakableTileData %00100101 %00000001 %0000 $0 $46 $45 ; $1c
	m_BreakableTileData %00100101 %00000001 %0000 $2 $06 $a0 ; $1d
	m_BreakableTileData %00100101 %00000001 %0000 $0 $46 $0d ; $1e
	m_BreakableTileData %00110000 %00000000 %0000 $0 $06 $a0 ; $1f
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $34 ; $20
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $35 ; $21
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $36 ; $22
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $37 ; $23
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $34 ; $24
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $35 ; $25
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $36 ; $26
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $37 ; $27
	m_BreakableTileData %00111111 %00010000 %0000 $0 $06 $a0 ; $28
	m_BreakableTileData %00100001 %00000000 %0000 $4 $06 $4c ; $29
	m_BreakableTileData %10010110 %00110000 %0010 $0 $10 $ef ; $2a
	m_BreakableTileData %01000000 %00000000 %0000 $c $0a $4c ; $2b
	m_BreakableTileData %01000000 %00000000 %0000 $0 $0a $a1 ; $2c
	m_BreakableTileData %00100000 %00000001 %0000 $0 $06 $a0 ; $2d
	m_BreakableTileData %00000000 %00010000 %0000 $0 $df $35 ; $2e
	m_BreakableTileData %00000000 %00010000 %0000 $0 $df $37 ; $2f
	m_BreakableTileData %00110000 %00000000 %0000 $0 $06 $01 ; $30
	m_BreakableTileData %00100101 %00000001 %0000 $0 $06 $01 ; $31
	m_BreakableTileData %00111110 %10000000 %1011 $0 $1f $00 ; $32


;;
; @addr{79dc}
specialObjectLoadAnimationFrameToBuffer:
	ld hl,w1Companion.visible		; $79dc
	bit 7,(hl)		; $79df
	ret z			; $79e1

	ld l,<w1Companion.var32		; $79e2
	ld a,(hl)		; $79e4
	call _getSpecialObjectGraphicsFrame		; $79e5
	ret z			; $79e8

	ld a,l			; $79e9
	and $f0			; $79ea
	ld l,a			; $79ec
	ld de,w6SpecialObjectGfxBuffer|(:w6SpecialObjectGfxBuffer)		; $79ed
	jp copy256BytesFromBank		; $79f0


	; Garbage data/code

.ifdef BUILD_VANILLA

	m_BreakableTileData %00000000 %00010000 %0000 $0 $df $37 ; $2f
	m_BreakableTileData %00110000 %00000000 %0000 $0 $06 $01 ; $30
	m_BreakableTileData %00100101 %00000001 %0000 $0 $06 $01 ; $31
	m_BreakableTileData %00111110 %10000000 %1011 $0 $1f $00 ; $32


_fake_specialObjectLoadAnimationFrameToBuffer:
	ld hl,w1Companion.visible		; $7a07
	bit 7,(hl)		; $7a0a
	ret z			; $7a0c

	ld l,<w1Companion.var32		; $7a0d
	ld a,(hl)		; $7a0f
	call $4524		; $7a10
	ret z			; $7a13

	ld a,l			; $7a14
	and $f0			; $7a15
	ld l,a			; $7a17
	ld de,w6SpecialObjectGfxBuffer|(:w6SpecialObjectGfxBuffer)		; $7a18
	jp $3f17		; $7a1b


	ld a,(hl)		; $7a1e
	ret z			; $7a1f

	ld l,<w1Companion.var32		; $7a20
	ld a,(hl)		; $7a22
	call $4524		; $7a23
	ret z			; $7a26

	ld a,l			; $7a27
	and $f0			; $7a28
	ld l,a			; $7a2a
	ld de,w6SpecialObjectGfxBuffer|(:w6SpecialObjectGfxBuffer)		; $7a2b
	jp $3f31		; $7a2e
.endif

.ends

.BANK $07 SLOT 1
.ORG 0

.include "code/fileManagement.s"

 ; This section can't be superfree, since it must be in the same bank as section
 ; "Bank_7_Data".
 m_section_free "Enemy_Part_Collisions" namespace "bank7"

;;
; For each Enemy and each Part, check for collisions with Link and Items.
; @addr{41d1}
checkEnemyAndPartCollisions:
	; Calculate shield position
	ld a,(w1Link.direction)		; $41d1
	add a			; $41d4
	add a			; $41d5
	ld hl,@shieldPositionOffsets		; $41d6
	rst_addAToHl			; $41d9
	ld de,wShieldY		; $41da
	ld a,(w1Link.yh)		; $41dd
	add (hl)		; $41e0
	ld (de),a		; $41e1
	inc hl			; $41e2
	inc e			; $41e3
	ld a,(w1Link.xh)		; $41e4
	add (hl)		; $41e7
	ld (de),a		; $41e8

	inc hl			; $41e9
	inc e			; $41ea
	ldi a,(hl)		; $41eb
	ld (de),a		; $41ec
	inc e			; $41ed
	ldi a,(hl)		; $41ee
	ld (de),a		; $41ef

	; Check collisions for all Enemies
	ld a,Enemy.start		; $41f0
	ldh (<hActiveObjectType),a	; $41f2
	ld d,FIRST_ENEMY_INDEX		; $41f4
	ld a,d			; $41f6
@nextEnemy:
	ldh (<hActiveObject),a	; $41f7
	ld h,d			; $41f9
	ld l,Enemy.collisionType		; $41fa
	bit 7,(hl)		; $41fc
	jr z,+			; $41fe

	ld a,(hl)		; $4200
	ld l,Enemy.var2a		; $4201
	bit 7,(hl)		; $4203
	call z,_enemyCheckCollisions		; $4205
+
	inc d			; $4208
	ld a,d			; $4209
	cp LAST_ENEMY_INDEX+1			; $420a
	jr c,@nextEnemy		; $420c

	; Check collisions for all Parts
	ld a,Part.start		; $420e
	ldh (<hActiveObjectType),a	; $4210
	ld d,FIRST_PART_INDEX		; $4212
	ld a,d			; $4214
@nextPart:
	ldh (<hActiveObject),a	; $4215
	ld h,d			; $4217
	ld l,Part.collisionType		; $4218
	bit 7,(hl)		; $421a
	jr z,+			; $421c

	ld l,Part.var2a		; $421e
	bit 7,(hl)		; $4220
	jr nz,+			; $4222

	; Check Part.invincibilityCounter
	inc l			; $4224
	ld a,(hl)		; $4225
	or a			; $4226
	call z,_partCheckCollisions		; $4227
+
	inc d			; $422a
	ld a,d			; $422b
	cp LAST_PART_INDEX+1			; $422c
	jr c,@nextPart		; $422e

	ret			; $4230

; @addr{4231}
@shieldPositionOffsets:
	.db $f9 $01 $01 $06 ; DIR_UP
	.db $00 $06 $07 $01 ; DIR_RIGHT
	.db $06 $ff $01 $06 ; DIR_DOWN
	.db $00 $f9 $07 $01 ; DIR_LEFT


;;
; Check if the given part is colliding with an item or link, and do the appropriate
; action.
; @param d Part index
; @addr{4241}
_partCheckCollisions:
	ld e,Part.collisionType		; $4241
	ld a,(de)		; $4243
	ld hl,partActiveCollisions		; $4244
	ld e,Part.yh		; $4247
	jr ++			; $4249

;;
; Check if the given enemy is colliding with an item or link, and do the appropriate
; action.
; @param a Enemy.collisionType
; @param d Enemy index
; @addr{424b}
_enemyCheckCollisions:
	ld hl,enemyActiveCollisions		; $424b
	ld e,Enemy.yh		; $424e

++
	add a			; $4250
	ld c,a			; $4251
	ld b,$00		; $4252
	add hl,bc		; $4254
	add hl,bc		; $4255

	; Store pointer for later
	ld a,l			; $4256
	ldh (<hFF92),a	; $4257
	ld a,h			; $4259
	ldh (<hFF93),a	; $425a

	; Store X in hFF8E, Y in hFF8F, Z in hFF91
	ld h,d			; $425c
	ld l,e			; $425d
	ldi a,(hl)		; $425e
	ldh (<hFF8F),a	; $425f
	inc l			; $4261
	ldi a,(hl)		; $4262
	ldh (<hFF8E),a	; $4263
	inc l			; $4265
	ld a,(hl)		; $4266
	ldh (<hFF91),a	; $4267

	; Check invincibility
	ld a,l			; $4269
	add Object.invincibilityCounter-Object.zh		; $426a
	ld l,a			; $426c
	ld a,(hl)		; $426d
	or a			; $426e
	jr nz,@doneCheckingItems	; $426f

	; Check collisions with items
	ld h,FIRST_ITEM_INDEX		; $4271
@checkItem:
	ld l,Item.collisionType		; $4273
	ld a,(hl)		; $4275
	bit 7,a			; $4276
	jr z,@nextItem		; $4278

	and $7f			; $427a
	ldh (<hFF90),a	; $427c
	ld b,a			; $427e
	ld e,h			; $427f
	ldh a,(<hFF92)	; $4280
	ld l,a			; $4282
	ldh a,(<hFF93)	; $4283
	ld h,a			; $4285
	ld a,b			; $4286
	call @checkFlag		; $4287
	ld h,e			; $428a
	jr z,@nextItem		; $428b

	ld bc,$0e07		; $428d
	ldh a,(<hFF90)	; $4290
	cp ITEMCOLLISION_BOMB			; $4292
	jr nz,++		; $4294

	ld l,Item.collisionRadiusY		; $4296
	ld a,(hl)		; $4298
	ld c,a			; $4299
	add a			; $429a
	ld b,a			; $429b
++
	ld l,Item.zh		; $429c
	ldh a,(<hFF91)	; $429e
	sub (hl)		; $42a0
	add c			; $42a1
	cp b			; $42a2
	jr nc,@nextItem		; $42a3

	ld l,Item.yh		; $42a5
	ld b,(hl)		; $42a7
	ld l,Item.xh		; $42a8
	ld c,(hl)		; $42aa
	ld l,Item.collisionRadiusY		; $42ab
	ldh a,(<hActiveObjectType)	; $42ad
	add Object.collisionRadiusY			; $42af
	ld e,a			; $42b1
	call checkObjectsCollidedFromVariables		; $42b2
	jp c,@handleCollision		; $42b5

@nextItem:
	inc h			; $42b8
	ld a,h			; $42b9
	cp LAST_STANDARD_ITEM_INDEX+1			; $42ba
	jr c,@checkItem		; $42bc

@doneCheckingItems:
	call checkLinkVulnerable		; $42be
	ret nc			; $42c1

	; Check for collision with link
	; (hl points to link object from the call to checkLinkVulnerable)

	; Check if Z positions are within 7 pixels
	ld l,<w1Link.zh		; $42c2
	ldh a,(<hFF91)	; $42c4
	sub (hl)		; $42c6
	add $07			; $42c7
	cp $0e			; $42c9
	ret nc			; $42cb

	; If the shield is out...
	ld a,(wUsingShield)		; $42cc
	or a			; $42cf
	jr z,@checkHitLink		; $42d0

	; Store shield level as collision type
	ldh (<hFF90),a	; $42d2

	; Check if the shield can defend from this object
	ldh a,(<hFF92)	; $42d4
	ld l,a			; $42d6
	ldh a,(<hFF93)	; $42d7
	ld h,a			; $42d9
	ldh a,(<hFF90)	; $42da
	call @checkFlag		; $42dc
	jr z,@checkHitLink		; $42df

	; Check if current object is within the shield's hitbox
	ld hl,wShieldY		; $42e1
	ldi a,(hl)		; $42e4
	ld b,a			; $42e5
	ldi a,(hl)		; $42e6
	ld c,a			; $42e7
	ldh a,(<hActiveObjectType)	; $42e8
	add <Object.collisionRadiusY			; $42ea
	ld e,a			; $42ec
	call checkObjectsCollidedFromVariables		; $42ed
	ld hl,w1Link		; $42f0
	jp c,@handleCollision		; $42f3

	; Not using shield (or shield is ineffective)
@checkHitLink:
	ldh a,(<hActiveObjectType)	; $42f6
	add Object.stunCounter			; $42f8
	ld e,a			; $42fa
	ld a,(de)		; $42fb
	or a			; $42fc
	ret nz			; $42fd

	; Check if the current object responds to link's collisionType
	ld a,(wLinkObjectIndex)		; $42fe
	ld h,a			; $4301
	ld e,a			; $4302
	ld l,<w1Link.collisionType		; $4303
	ld a,(hl)		; $4305
	and $7f			; $4306
	ldh (<hFF90),a	; $4308
	ldh a,(<hFF92)	; $430a
	ld l,a			; $430c
	ldh a,(<hFF93)	; $430d
	ld h,a			; $430f
	ldh a,(<hFF90)	; $4310
	call @checkFlag		; $4312
	ret z			; $4315

	; If link and the current object collide, damage link

	ld h,e			; $4316
	ld l,<w1Link.yh		; $4317
	ld b,(hl)		; $4319
	ld l,<w1Link.xh		; $431a
	ld c,(hl)		; $431c
	ld l,<w1Link.collisionRadiusY		; $431d
	ldh a,(<hActiveObjectType)	; $431f
	add Object.collisionRadiusY			; $4321
	ld e,a			; $4323
	call checkObjectsCollidedFromVariables		; $4324
	jp c,@handleCollision		; $4327
	ret			; $432a

;;
; This appears to behave identically to the checkFlag function in bank 0.
; I guess it's a bit more efficient?
; @param a Bit to check
; @param hl Start of flags
; @addr{432b}
@checkFlag:
	ld b,a			; $432b
	and $f8			; $432c
	rlca			; $432e
	swap a			; $432f
	ld c,a			; $4331
	ld a,b			; $4332
	and $07			; $4333
	ld b,$00		; $4335
	add hl,bc		; $4337
	ld c,(hl)		; $4338
	ld hl,bitTable		; $4339
	add l			; $433c
	ld l,a			; $433d
	ld a,(hl)		; $433e
	and c			; $433f
	ret			; $4340

;;
; @param de Object 1 (Enemy/Part?)
; @param hl Object 2 (Link/Item?)
; @param hFF8D Y-position?
; @param hFF8E X-position?
; @param hFF90 Collision type
; @addr{4341}
@handleCollision:
	ld a,l			; $4341
	and $c0			; $4342
	ld l,a			; $4344
	push hl			; $4345
	ld a,WEAPON_ITEM_INDEX		; $4346
	cp h			; $4348
	jr nz,@notWeaponItem		; $4349

@weaponItem:
	ld a,(w1Link.yh)		; $434b
	ld b,a			; $434e
	ld a,(w1Link.xh)		; $434f
	jr ++			; $4352

@notWeaponItem:
	ldh a,(<hFF8D)	; $4354
	ld b,a			; $4356
	ldh a,(<hFF8C)	; $4357

++
	ld c,a			; $4359
	call objectGetRelativeAngleWithTempVars		; $435a
	ldh (<hFF8A),a	; $435d
	ldh a,(<hActiveObjectType)	; $435f
	add Object.enemyCollisionMode			; $4361
	ld e,a			; $4363
	ld a,(de)		; $4364
	add a			; $4365
	call multiplyABy16		; $4366
	ld hl,objectCollisionTable		; $4369
	add hl,bc		; $436c
	pop bc			; $436d
	ldh a,(<hFF90)	; $436e
	rst_addAToHl			; $4370
	ld a,(hl)		; $4371
	rst_jumpTable			; $4372
	.dw _collisionEffect00
	.dw _collisionEffect01
	.dw _collisionEffect02
	.dw _collisionEffect03
	.dw _collisionEffect04
	.dw _collisionEffect05
	.dw _collisionEffect06
	.dw _collisionEffect07
	.dw _collisionEffect08
	.dw _collisionEffect09
	.dw _collisionEffect0a
	.dw _collisionEffect0b
	.dw _collisionEffect0c
	.dw _collisionEffect0d
	.dw _collisionEffect0e
	.dw _collisionEffect0f
	.dw _collisionEffect10
	.dw _collisionEffect11
	.dw _collisionEffect12
	.dw _collisionEffect13
	.dw _collisionEffect14
	.dw _collisionEffect15
	.dw _collisionEffect16
	.dw _collisionEffect17
	.dw _collisionEffect18
	.dw _collisionEffect19
	.dw _collisionEffect1a
	.dw _collisionEffect1b
	.dw _collisionEffect1c
	.dw _collisionEffect1d
	.dw _collisionEffect1e
	.dw _collisionEffect1f
	.dw _collisionEffect20
	.dw _collisionEffect21
	.dw _collisionEffect22
	.dw _collisionEffect23
	.dw _collisionEffect24
	.dw _collisionEffect25
	.dw _collisionEffect26
	.dw _collisionEffect27
	.dw _collisionEffect28
	.dw _collisionEffect29
	.dw _collisionEffect2a
	.dw _collisionEffect2b
	.dw _collisionEffect2c
	.dw _collisionEffect2d
	.dw _collisionEffect2e
	.dw _collisionEffect2f
	.dw _collisionEffect30
	.dw _collisionEffect31
	.dw _collisionEffect32
	.dw _collisionEffect33
	.dw _collisionEffect34
	.dw _collisionEffect35
	.dw _collisionEffect36
	.dw _collisionEffect37
	.dw _collisionEffect38
	.dw _collisionEffect39
	.dw _collisionEffect3a
	.dw _collisionEffect3b
	.dw _collisionEffect3c
	.dw _collisionEffect3d
	.dw _collisionEffect3e
	.dw _collisionEffect3f

; Parameters which get passed to collision code functions:
; bc = link / item object (points to the start of the object)
; de = enemy / part object (points to Object.enemyCollisionMode)

;;
; COLLISIONEFFECT_NONE
; @addr{43f3}
_collisionEffect00:
	ret			; $43f3

;;
; COLLISIONEFFECT_DAMAGE_LINK_WITH_RING_MODIFIER
; This is the same as COLLISIONEFFECT_DAMAGE_LINK, but it checks for rings that reduce or
; prevent damage.
; @addr{43f4}
_collisionEffect3c:
	; Get Object.id
	ldh a,(<hActiveObjectType)	; $43f4
	inc a			; $43f6
	ld e,a			; $43f7
	ld a,(de)		; $43f8
	ld c,a			; $43f9

	; Try to find the id in @ringProtections
	ld hl,@ringProtections		; $43fa
--
	ldi a,(hl)		; $43fd
	or a			; $43fe
	jr z,_collisionEffect02	; $43ff

	cp c			; $4401
	ldi a,(hl)		; $4402
	jr nz,--		; $4403

	; If the id was found, check if the corresponding ring is equipped
	ld c,a			; $4405
	and $7f			; $4406
	call cpActiveRing		; $4408
	jr nz,_collisionEffect02	; $440b

	; If bit 7 is unset, destroy the projectile
	bit 7,c			; $440d
	ld a,ENEMYDMG_40		; $440f
	jp z,_applyDamageToEnemyOrPart		; $4411

	; Else, hit link but halve the damage
	call _collisionEffect02		; $4414
	ld h,b			; $4417
	ld l,<w1Link.damageToApply		; $4418
	sra (hl)		; $441a
	ret			; $441c

; @addr{441d}
@ringProtections:
	.db ENEMYID_BLADE_TRAP		$80|GREEN_LUCK_RING
	.db PARTID_OCTOROK_PROJECTILE	$00|RED_HOLY_RING
	.db PARTID_ZORA_FIRE		$00|BLUE_HOLY_RING
	.db PARTID_BEAM			$80|BLUE_LUCK_RING
	.db $00

;;
; COLLISIONEFFECT_DAMAGE_LINK_LOW_KNOCKBACK
; @addr{4426}
_collisionEffect01:
	ld e,LINKDMG_00		; $4426
	jr ++			; $4428

;;
; COLLISIONEFFECT_DAMAGE_LINK
; @addr{442a}
_collisionEffect02:
	ld e,LINKDMG_04		; $442a
	jr ++			; $442c

;;
; COLLISIONEFFECT_DAMAGE_LINK_HIGH_KNOCKBACK
; @addr{442e}
_collisionEffect03:
	ld e,LINKDMG_08		; $442e
	jr ++			; $4430

;;
; COLLISIONEFFECT_DAMAGE_LINK_NO_KNOCKBACK
; @addr{4432}
_collisionEffect04:
	ld e,LINKDMG_0c		; $4432
++
	call _applyDamageToLink_paramE		; $4434
	ld a,ENEMYDMG_1c		; $4437
	jp _applyDamageToEnemyOrPart		; $4439

;;
; COLLISIONEFFECT_SWORD_LOW_KNOCKBACK
; @addr{443c}
_collisionEffect08:
	ld e,ENEMYDMG_00		; $443c
	jr _label_07_027		; $443e

;;
; COLLISIONEFFECT_SWORD
; @addr{4440}
_collisionEffect09:
	ld e,ENEMYDMG_04		; $4440
	jr _label_07_027		; $4442

;;
; COLLISIONEFFECT_SWORD_HIGH_KNOCKBACK
; @addr{4440}
_collisionEffect0a:
	ld e,ENEMYDMG_08		; $4444
	jr _label_07_027		; $4446

;;
; COLLISIONEFFECT_SWORD_NO_KNOCKBACK
; @addr{4440}
_collisionEffect0b:
	call _func_07_47b7		; $4448
	ret z			; $444b
	ld e,ENEMYDMG_0c		; $444c
	jr _label_07_027		; $444e

;;
; COLLISIONEFFECT_21
; @addr{4450}
_collisionEffect21:
	ld e,ENEMYDMG_30		; $4450
_label_07_027:
	ldh a,(<hActiveObjectType)	; $4452
	add Object.var3e			; $4454
	ld l,a			; $4456
	ld h,d			; $4457
	ld c,Item.var2a		; $4458
	ld a,(bc)		; $445a
	or (hl)			; $445b
	ld (bc),a		; $445c
	ld a,e			; $445d
	jp _applyDamageToEnemyOrPart		; $445e

;;
; COLLISIONEFFECT_BUMP_WITH_CLINK_LOW_KNOCKBACK
; @addr{4461}
_collisionEffect12:
	call _createClinkInteraction		; $4461

;;
; COLLISIONEFFECT_BUMP_LOW_KNOCKBACK
; @addr{4464}
_collisionEffect0c:
	ld e,ENEMYDMG_10		; $4464
	jr _label_07_028		; $4466

;;
; COLLISIONEFFECT_BUMP_WITH_CLINK
; @addr{4468}
_collisionEffect13:
	call _createClinkInteraction		; $4468

;;
; COLLISIONEFFECT_BUMP
; @addr{446b}
_collisionEffect0d:
	ld e,ENEMYDMG_14		; $446b
	jr _label_07_028		; $446d

;;
; COLLISIONEFFECT_BUMP_WITH_CLINK_HIGH_KNOCKBACK
; @addr{446f}
_collisionEffect14:
	call _createClinkInteraction		; $446f

;;
; COLLISIONEFFECT_BUMP_HIGH_KNOCKBACK
; @addr{4472}
_collisionEffect0e:
	ld e,ENEMYDMG_18		; $4472
_label_07_028:
	ldh a,(<hActiveObjectType)	; $4474
	add Object.var3e			; $4476
	ld l,a			; $4478
	ld h,d			; $4479
	ld c,Item.var2a		; $447a
	ld a,(bc)		; $447c
	or (hl)			; $447d
	ld (bc),a		; $447e
	ld a,e			; $447f
	jp _applyDamageToEnemyOrPart		; $4480

;;
; COLLISIONEFFECT_05
; @addr{4483}
_collisionEffect05:
	ldhl LINKDMG_10, ENEMYDMG_1c		; $4483
	jr _applyDamageToBothObjects		; $4486

;;
; COLLISIONEFFECT_06
; @addr{4488}
_collisionEffect06:
	ldhl LINKDMG_14, ENEMYDMG_1c		; $4488
	jr _applyDamageToBothObjects		; $448b

;;
; COLLISIONEFFECT_07
; @addr{448d}
_collisionEffect07:
	ldhl LINKDMG_18, ENEMYDMG_1c		; $448d
	jr _applyDamageToBothObjects		; $4490

;;
; COLLISIONEFFECT_SHIELD_BUMP_WITH_CLINK
; @addr{4492}
_collisionEffect18:
	call _createClinkInteraction		; $4492

;;
; COLLISIONEFFECT_SHIELD_BUMP
; @addr{4495}
_collisionEffect0f:
	ldhl LINKDMG_10, ENEMYDMG_10		; $4495
	jr _applyDamageToBothObjects		; $4498

;;
; COLLISIONEFFECT_SHIELD_BUMP_WITH_CLINK_HIGH_KNOCKBACK
; @addr{449a}
_collisionEffect19:
	call _createClinkInteraction		; $449a

;;
; COLLISIONEFFECT_SHIELD_BUMP_HIGH_KNOCKBACK
; @addr{449d}
_collisionEffect10:
	ldhl LINKDMG_14, ENEMYDMG_14		; $449d
	jr _applyDamageToBothObjects		; $44a0

;;
; COLLISIONEFFECT_15
; @addr{44a2}
_collisionEffect15:
	call _createClinkInteraction		; $44a2
	ldhl LINKDMG_10, ENEMYDMG_34		; $44a5
	jr _applyDamageToBothObjects		; $44a8

;;
; COLLISIONEFFECT_16
; @addr{44aa}
_collisionEffect16:
	call _createClinkInteraction		; $44aa
	ldhl LINKDMG_14, ENEMYDMG_34		; $44ad
	jr _applyDamageToBothObjects		; $44b0

;;
; COLLISIONEFFECT_17
; @addr{44b2}
_collisionEffect17:
	call _createClinkInteraction		; $44b2
	ldhl LINKDMG_18, ENEMYDMG_34		; $44b5
	jr _applyDamageToBothObjects		; $44b8

;;
; COLLISIONEFFECT_1a
; @addr{44ba}
_collisionEffect1a:
	call _createClinkInteraction		; $44ba

;;
; COLLISIONEFFECT_11
; @addr{44bd}
_collisionEffect11:
	ldhl LINKDMG_18, ENEMYDMG_18		; $44bd
	jr _applyDamageToBothObjects		; $44c0

;;
; COLLISIONEFFECT_1b
; @addr{44c2}
_collisionEffect1b:
	call _createClinkInteraction		; $44c2
	ldhl LINKDMG_1c, ENEMYDMG_28		; $44c5
	jr _applyDamageToBothObjects		; $44c8

;;
; COLLISIONEFFECT_1d
; @addr{44ca}
_collisionEffect1d:
	ldhl LINKDMG_0c, ENEMYDMG_04		; $44ca
	jr _applyDamageToBothObjects		; $44cd

;;
; COLLISIONEFFECT_1e
; @addr{44cf}
_collisionEffect1e:
	ldhl LINKDMG_28, ENEMYDMG_34		; $44cf
	jr _applyDamageToBothObjects		; $44d2

;;
; COLLISIONEFFECT_1f
; @addr{44d4}
_collisionEffect1f:
	ldhl LINKDMG_20, ENEMYDMG_34		; $44d4
	jr _applyDamageToBothObjects		; $44d7

;;
; COLLISIONEFFECT_20
; @addr{44d9}
_collisionEffect20:
	ld h,b			; $44d9
	ld l,Item.id		; $44da
	ld a,(hl)		; $44dc
	cp $28			; $44dd
	jr nc,+			; $44df

	ld l,Item.collisionType		; $44e1
	res 7,(hl)		; $44e3
+
	call _func_07_47b7		; $44e5
	ret z			; $44e8

	ldhl LINKDMG_24, ENEMYDMG_44		; $44e9
	jr _applyDamageToBothObjects		; $44ec

;;
; COLLISIONEFFECT_STUN
; @addr{44ee}
_collisionEffect22:
	ldhl LINKDMG_1c, ENEMYDMG_24		; $44ee

;;
; @param h Damage type for link ( / item?)
; @param l Damage type for enemy / part
; @addr{44f1}
_applyDamageToBothObjects:
	ld a,h			; $44f1
	push hl			; $44f2
	call _applyDamageToLink		; $44f3
	pop hl			; $44f6
	ld a,l			; $44f7
	jp _applyDamageToEnemyOrPart		; $44f8

;;
; COLLISIONEFFECT_26
; @addr{44fb}
_collisionEffect26:
	ldhl LINKDMG_1c, ENEMYDMG_34		; $44fb
	jr _applyDamageToBothObjects		; $44fe

;;
; COLLISIONEFFECT_BURN
; @addr{4500}
_collisionEffect27:
	ld h,b			; $4500
	ld l,Item.collisionType		; $4501
	res 7,(hl)		; $4503
	call _func_07_47b7		; $4505
	ret z			; $4508

	call _createFlamePart		; $4509
	ldhl LINKDMG_1c, ENEMYDMG_2c		; $450c
	jr _applyDamageToBothObjects		; $450f

;;
; COLLISIONEFFECT_PEGASUS_SEED
; @addr{4511}
_collisionEffect28:
	ld h,b			; $4511
	ld l,Item.collisionType		; $4512
	res 7,(hl)		; $4514
	call _func_07_47b7		; $4516
	ret z			; $4519

	ldhl LINKDMG_1c, ENEMYDMG_38		; $451a
	jr _applyDamageToBothObjects		; $451d

;;
; COLLISIONEFFECT_3a
; Assumes that the first object is an Enemy, not a Part.
; @addr{451f}
_collisionEffect3a:
	ld e,Enemy.knockbackCounter		; $451f
	ld a,(de)		; $4521
	or a			; $4522
	ret nz			; $4523

;;
; COLLISIONEFFECT_LIKELIKE
; @addr{4524}
_collisionEffect3d:
	ld a,(w1Link.id)		; $4524
	or a			; $4527
	ret nz			; $4528

	ld a,(wWarpsDisabled)		; $4529
	or a			; $452c
	ret nz			; $452d

	ld a,LINK_STATE_GRABBED		; $452e
	ld (wLinkForceState),a		; $4530
	ldhl LINKDMG_2c, ENEMYDMG_1c		; $4533
	jr _applyDamageToBothObjects		; $4536

;;
; COLLISIONEFFECT_2b
; @addr{4538}
_collisionEffect2b:
	ldhl LINKDMG_1c, ENEMYDMG_3c		; $4538
	jr _applyDamageToBothObjects		; $453b

;;
; COLLISIONEFFECT_2c
; @addr{453d}
_collisionEffect2c:
	ldhl LINKDMG_14, ENEMYDMG_30		; $453d
	jr _applyDamageToBothObjects		; $4540

;;
; COLLISIONEFFECT_2f
; @addr{4542}
_collisionEffect2f:
	ldhl LINKDMG_30, ENEMYDMG_04		; $4542
	jr _applyDamageToBothObjects		; $4545

;;
; COLLISIONEFFECT_30
; @addr{4547}
_collisionEffect30:
	ldhl LINKDMG_1c, ENEMYDMG_44		; $4547
	jr _applyDamageToBothObjects		; $454a

;;
; COLLISIONEFFECT_1c
; @addr{454c}
_collisionEffect1c:
	ldhl LINKDMG_1c, ENEMYDMG_1c		; $454c
	jr _applyDamageToBothObjects		; $454f

;;
; COLLISIONEFFECT_SWITCH_HOOK
; @addr{4551}
_collisionEffect2e:
	ld h,d			; $4551
	ldh a,(<hActiveObjectType)	; $4552
	add Object.health			; $4554
	ld l,a			; $4556
	ld a,(hl)		; $4557
	or a			; $4558
	jr z,_collisionEffect1c	; $4559

	; Clear Object.stunCounter, Object.knockbackCounter
	ld a,l			; $455b
	add Object.stunCounter-Object.health			; $455c
	ld l,a			; $455e
	xor a			; $455f
	ldd (hl),a		; $4560
	ldd (hl),a		; $4561

	; l = Object.knockbackAngle
	ldh a,(<hFF8A)	; $4562
	xor $10			; $4564
	ld (hl),a		; $4566

	; l = Object.collisionType
	res 3,l			; $4567
	res 7,(hl)		; $4569

	ld a,l			; $456b
	add Object.state-Object.collisionType			; $456c
	ld l,a			; $456e
	ld (hl),$03		; $456f

	; l = Object.state2
	inc l			; $4571
	ld (hl),$00		; $4572

	; Now do something with link
	ld h,b			; $4574
	ld l,<w1Link.var2a		; $4575
	set 5,(hl)		; $4577
	ld l,<w1Link.collisionType		; $4579
	res 7,(hl)		; $457b
	ld l,<w1Link.relatedObj2		; $457d
	ldh a,(<hActiveObjectType)	; $457f
	ldi (hl),a		; $4581
	ld (hl),d		; $4582
	ret			; $4583

;;
; COLLISIONEFFECT_23
; @addr{4584}
_collisionEffect23:
	ldh a,(<hActiveObjectType)	; $4584
	add Object.health			; $4586
	ld l,a			; $4588
	ld h,d			; $4589
	ld (hl),$00		; $458a
	ret			; $458c

;;
; COLLISIONEFFECT_24
; @addr{458d}
_collisionEffect24:
	ldh a,(<hActiveObjectType)	; $458d
	add Object.var2a			; $458f
	ld e,a			; $4591
	ldh a,(<hFF90)	; $4592
	or $80			; $4594
	ld (de),a		; $4596

	ld a,e			; $4597
	add Object.relatedObj1-Object.var2a			; $4598
	ld l,a			; $459a
	ld h,d			; $459b
	ld (hl),c		; $459c
	inc l			; $459d
	ld (hl),b		; $459e

	ld c,Item.var2a		; $459f
	ld a,$01		; $45a1
	ld (bc),a		; $45a3
	ret			; $45a4

;;
; COLLISIONEFFECT_25
; @addr{45a5}
_collisionEffect25:
	call _killEnemyOrPart		; $45a5
	ld a,l			; $45a8
	add Object.var3f-Object.collisionType			; $45a9
	ld l,a			; $45ab
	set 7,(hl)		; $45ac

	ld c,Item.var2a		; $45ae
	ld a,$02		; $45b0
	ld (bc),a		; $45b2
	ret			; $45b3

;;
; COLLISIONEFFECT_GALE_SEED
; This assumes that second object is an Enemy, NOT a Part. At least, it does when
; func_07_47b7 returns nonzero...
; @addr{45b4}
_collisionEffect29:
	ld h,b			; $45b4
	ld l,Item.collisionType		; $45b5
	res 7,(hl)		; $45b7
	call _func_07_47b7		; $45b9
	ret z			; $45bc

	ld h,d			; $45bd
	ld l,Enemy.var2a		; $45be
	ld (hl),$9e		; $45c0
	ld l,Enemy.stunCounter		; $45c2
	ld (hl),$00		; $45c4
	ld l,Enemy.collisionType		; $45c6
	res 7,(hl)		; $45c8
	ld l,Enemy.state		; $45ca
	ld (hl),$05		; $45cc

	ld l,Enemy.visible		; $45ce
	ld a,(hl)		; $45d0
	and $c0			; $45d1
	or $02			; $45d3
	ld (hl),a		; $45d5

	ld l,Enemy.counter2		; $45d6
	ld (hl),$1e		; $45d8
	ld l,Enemy.speed		; $45da
	ld (hl),$05		; $45dc

	ld l,Enemy.speedZ		; $45de
	ld (hl),$00		; $45e0
	inc l			; $45e2
	ld (hl),$fa		; $45e3

	; Copy item's x/y position to enemy
	ld l,Enemy.yh		; $45e5
	ld c,Item.yh		; $45e7
	ld a,(bc)		; $45e9
	ldi (hl),a		; $45ea
	inc l			; $45eb
	ld c,Item.xh		; $45ec
	ld a,(bc)		; $45ee
	ldi (hl),a		; $45ef

	; l = Enemy.zh
	inc l			; $45f0
	ld a,(hl)		; $45f1
	rlca			; $45f2
	jr c,+			; $45f3
	ld (hl),$ff		; $45f5
+
	call getRandomNumber		; $45f7
	and $18			; $45fa
	ld e,Enemy.angle		; $45fc
	ld (de),a		; $45fe
	ld a,LINKDMG_1c		; $45ff
	jp _applyDamageToLink		; $4601

;;
; COLLISIONEFFECT_2a
; This assumes that the second object is a Part, not an Enemy.
; @addr{4604}
_collisionEffect2a:
	ld h,b			; $4604
	ld l,Item.knockbackCounter		; $4605
	ld a,d			; $4607
	cp (hl)			; $4608
	ret z			; $4609

	ldd (hl),a		; $460a

	; Write to Item.knockbackAngle
	ld e,Part.animParameter		; $460b
	ld a,(de)		; $460d
	ldd (hl),a		; $460e

	; l = Item.var2a
	dec l			; $460f
	set 4,(hl)		; $4610

	ld e,Part.var2a		; $4612
	ldh a,(<hFF90)	; $4614
	or $80			; $4616
	ld (de),a		; $4618
	ret			; $4619

;;
; COLLISIONEFFECT_2d
; @addr{461a}
_collisionEffect2d:
	ld h,b			; $461a
	ld l,Item.var2f		; $461b
	set 5,(hl)		; $461d
	ret			; $461f

;;
; COLLISIONEFFECT_31
; @addr{4620}
_collisionEffect31:
	ld a,ENEMYDMG_34		; $4620
	jp _applyDamageToEnemyOrPart		; $4622

;;
; COLLISIONEFFECT_32
; @addr{4625}
_collisionEffect32:
	ldhl LINKDMG_34, ENEMYDMG_48		; $4625
	jr _label_07_033		; $4628

;;
; COLLISIONEFFECT_33
; @addr{462a}
_collisionEffect33:
	ldhl LINKDMG_38, ENEMYDMG_4c		; $462a
_label_07_033:
	call _applyDamageToBothObjects		; $462d
	jp _createClinkInteraction		; $4630

;;
; COLLISIONEFFECT_34
; @addr{4633}
_collisionEffect34:
	call _createFlamePart		; $4633
	ld h,b			; $4636
	ld l,Item.collisionType		; $4637
	res 7,(hl)		; $4639
	ldhl LINKDMG_1c, ENEMYDMG_2c		; $463b
	call _applyDamageToBothObjects		; $463e
	jr _killEnemyOrPart		; $4641

;;
; COLLISIONEFFECT_35
; @addr{4643}
_collisionEffect35:
	ldhl LINKDMG_1c, ENEMYDMG_1c		; $4643
	call _applyDamageToBothObjects		; $4646

;;
; Set the Enemy/Part's health to zero, disable its collisions?
; @addr{4649}
_killEnemyOrPart:
	ld h,d			; $4649
	ldh a,(<hActiveObjectType)	; $464a
	add Object.health			; $464c
	ld l,a			; $464e
	ld (hl),$00		; $464f

	add Object.collisionType-Object.health			; $4651
	ld l,a			; $4653
	res 7,(hl)		; $4654
	ret			; $4656

;;
; COLLISIONEFFECT_ELECTRIC_SHOCK
; @addr{4657}
_collisionEffect36:
	ld h,d			; $4657
	ldh a,(<hActiveObjectType)	; $4658
	add Object.var2a			; $465a
	ld l,a			; $465c
	ld (hl),$80|ITEMCOLLISION_ELECTRIC_SHOCK		; $465d

	add Object.collisionType-Object.var2a			; $465f
	ld l,a			; $4661
	res 7,(hl)		; $4662

	; Apply damage if green holy ring is not equipped
	ld a,GREEN_HOLY_RING		; $4664
	call cpActiveRing		; $4666
	ld a,$f8		; $4669
	jr nz,+			; $466b
	xor a			; $466d
+
	ld hl,w1Link.damageToApply		; $466e
	ld (hl),a		; $4671

	ld l,<w1Link.knockbackAngle		; $4672
	ldh a,(<hFF8A)	; $4674
	ld (hl),a		; $4676

	ld l,<w1Link.knockbackCounter		; $4677
	ld (hl),$08		; $4679

	ld l,<w1Link.invincibilityCounter		; $467b
	ld (hl),$0c		; $467d

	ld a,(wIsLinkBeingShocked)		; $467f
	or a			; $4682
	jr nz,+			; $4683

	inc a			; $4685
	ld (wIsLinkBeingShocked),a		; $4686
+
	ld h,b			; $4689
	ld l,<Item.collisionType		; $468a
	res 7,(hl)		; $468c

	ld a,LINKDMG_1c		; $468e
	jp _applyDamageToLink		; $4690

;;
; COLLISIONEFFECT_37
; @addr{4693}
_collisionEffect37:
	ldh a,(<hActiveObjectType)	; $4693
	add Object.invincibilityCounter			; $4695
	ld e,a			; $4697
	ld a,(de)		; $4698
	or a			; $4699
	ret nz			; $469a

	ld a,(wWarpsDisabled)		; $469b
	or a			; $469e
	ret nz			; $469f

	ld a,(w1Link.state)		; $46a0
	cp LINK_STATE_NORMAL			; $46a3
	ret nz			; $46a5

	ld a,e			; $46a6
	add Object.collisionType-Object.invincibilityCounter		; $46a7
	ld e,a			; $46a9
	xor a			; $46aa
	ld (de),a		; $46ab

	ld a,LINK_STATE_GRABBED_BY_WALLMASTER		; $46ac
	ld (wLinkForceState),a		; $46ae
	ld a,ENEMYDMG_1c		; $46b1
	jp _applyDamageToEnemyOrPart		; $46b3

;;
; COLLISIONEFFECT_38
; @addr{46b6}
_collisionEffect38:
	ld h,d			; $46b6
	ldh a,(<hActiveObjectType)	; $46b7
	add Object.collisionType			; $46b9
	ld l,a			; $46bb
	res 7,(hl)		; $46bc

	add Object.counter1-Object.collisionType		; $46be
	ld l,a			; $46c0
	ld (hl),$60		; $46c1

	add Object.zh-Object.counter1			; $46c3
	ld l,a			; $46c5
	ld (hl),$00		; $46c6
	ld a,ENEMYDMG_1c		; $46c8
	jp _applyDamageToEnemyOrPart		; $46ca

;;
; COLLISIONEFFECT_39
; @addr{46cd}
_collisionEffect39:
	ret			; $46cd

;;
; COLLISIONEFFECT_3b
; @addr{46ce}
_collisionEffect3b:
	ld a,$02		; $46ce
	call setLinkIDOverride		; $46d0
	ld a,ENEMYDMG_1c		; $46d3
	jp _applyDamageToEnemyOrPart		; $46d5

;;
; COLLISIONEFFECT_3e
; @addr{46d8}
_collisionEffect3e:
	ret			; $46d8

;;
; COLLISIONEFFECT_3f
; @addr{46d9}
_collisionEffect3f:
	ret			; $46d9

;;
; @addr{46da}
_createFlamePart:
	call getFreePartSlot		; $46da
	ret nz			; $46dd

	ld (hl),PARTID_FLAME		; $46de
	ld l,Part.relatedObj1		; $46e0
	ldh a,(<hActiveObjectType)	; $46e2
	ldi (hl),a		; $46e4
	ld (hl),d		; $46e5
	ret			; $46e6

;;
; @addr{46e7}
_createClinkInteraction:
	call getFreeInteractionSlot		; $46e7
	jr nz,@ret		; $46ea

	ld (hl),INTERACID_CLINK		; $46ec
	ldh a,(<hFF8F)	; $46ee
	ld l,a			; $46f0
	ldh a,(<hFF8D)	; $46f1
	sub l			; $46f3
	sra a			; $46f4
	add l			; $46f6
	ld l,Interaction.yh		; $46f7
	ldi (hl),a		; $46f9
	ldh a,(<hFF8E)	; $46fa
	ld l,a			; $46fc
	ldh a,(<hFF8C)	; $46fd
	sub l			; $46ff
	sra a			; $4700
	add l			; $4702
	ld l,Interaction.xh		; $4703
	ld (hl),a		; $4705
@ret:
	ret			; $4706

;;
; Apply damage to the enemy/part
; @param	b	Item/Link object
; @param	d	Enemy/Part object
; @param	e	Enemy damage type (see enum below)
; @param	hFF90	CollisionType
; @addr{4707}
_applyDamageToEnemyOrPart:
	ld hl,@damageTypeTable		; $4707
	rst_addAToHl			; $470a
	ldh a,(<hActiveObjectType)	; $470b
	add Object.health			; $470d
	ld e,a			; $470f
	bit 7,(hl)		; $4710
	jr z,++			; $4712

	; Apply damage
	ld c,Item.damage		; $4714
	ld a,(bc)		; $4716
	ld c,a			; $4717
	ld a,(de)		; $4718
	add c			; $4719
	jr c,+			; $471a
	xor a			; $471c
+
	ld (de),a		; $471d
	jr nz,++		; $471e

	; If health reaches zero, disable collisions
	ld c,e			; $4720
	ld a,e			; $4721
	add Object.collisionType-Object.health		; $4722
	ld e,a			; $4724
	ld a,(de)		; $4725
	res 7,a			; $4726
	ld (de),a		; $4728
	ld e,c			; $4729
++
	; e = Object.var2a
	inc e			; $472a
	ldi a,(hl)		; $472b
	ld c,a			; $472c
	bit 6,c			; $472d
	jr z,+			; $472f

	; Set var2a to the collisionType of the object it collided with
	ldh a,(<hFF90)	; $4731
	or $80			; $4733
	ld (de),a		; $4735
+
	; e = Object.invincibilityCounter
	inc e			; $4736
	ldi a,(hl)		; $4737
	bit 5,c			; $4738
	jr z,+			; $473a
	ld (de),a		; $473c
+
	; e = Object.knockbackCounter
	inc e			; $473d
	inc e			; $473e
	bit 4,c			; $473f
	ldi a,(hl)		; $4741
	jr z,++			; $4742

	; Apply knockback
	ld (de),a		; $4744

	; Calculate value for Object.knockbackAngle
	ldh a,(<hFF8A)	; $4745
	xor $10			; $4747
	dec e			; $4749
	ld (de),a		; $474a
	inc e			; $474b
++
	; e = Object.stunCounter
	inc e			; $474c
	ldi a,(hl)		; $474d
	bit 3,c			; $474e
	jr z,+			; $4750
	ld (de),a		; $4752
+
	ld a,c			; $4753
	and $07			; $4754
	ret z			; $4756

	ld hl,@soundEffects		; $4757
	rst_addAToHl			; $475a
	ld a,(hl)		; $475b
	jp playSound		; $475c

; Data format:
; b0: bit 7: whether to apply damage to the enemy/part
;     bit 6: whether to write something to Object.var2a?
;     bit 5: whether to give invincibility frames
;     bit 4: whether to give knockback
;     bit 3: whether to stun it
;     bits 0-2: sound effect to play
; b1: Value to write to Object.invincibilityFrames (if applicable)
; b2: Value to write to Object.knockbackCounter (if applicable)
; b3: Value to write to Object.stunCounter (if applicable)

; @addr{475f}
@damageTypeTable:
	.db $f1 $10 $08 $00 ; ENEMYDMG_00
	.db $f1 $15 $0b $00 ; ENEMYDMG_04
	.db $f1 $1a $0f $00 ; ENEMYDMG_08
	.db $f1 $20 $00 $00 ; ENEMYDMG_0c
	.db $70 $f0 $08 $00 ; ENEMYDMG_10
	.db $70 $eb $0b $00 ; ENEMYDMG_14
	.db $70 $e6 $0f $00 ; ENEMYDMG_18
	.db $40 $00 $00 $00 ; ENEMYDMG_1c
	.db $e1 $20 $00 $00 ; ENEMYDMG_20
	.db $29 $f0 $00 $78 ; ENEMYDMG_24
	.db $60 $ec $00 $00 ; ENEMYDMG_28
	.db $e8 $a6 $00 $5a ; ENEMYDMG_2c
	.db $f2 $20 $00 $00 ; ENEMYDMG_30
	.db $60 $e4 $00 $00 ; ENEMYDMG_34
	.db $29 $f0 $00 $f0 ; ENEMYDMG_38
	.db $a9 $18 $00 $78 ; ENEMYDMG_3c
	.db $e3 $20 $00 $00 ; ENEMYDMG_40
	.db $50 $00 $00 $00 ; ENEMYDMG_44
	.db $70 $f7 $07 $00 ; ENEMYDMG_48
	.db $70 $f5 $09 $00 ; ENEMYDMG_4c


; @addr{47af}
@soundEffects:
	.db SND_NONE
	.db SND_DAMAGE_ENEMY
	.db SND_BOSS_DAMAGE
	.db SND_CLINK2
	.db SND_NONE
	.db SND_NONE
	.db SND_NONE
	.db SND_NONE

.ENUM 0 EXPORT
	ENEMYDMG_00	dsb 4
	ENEMYDMG_04	dsb 4
	ENEMYDMG_08	dsb 4
	ENEMYDMG_0c	dsb 4
	ENEMYDMG_10	dsb 4
	ENEMYDMG_14	dsb 4
	ENEMYDMG_18	dsb 4
	ENEMYDMG_1c	dsb 4
	ENEMYDMG_20	dsb 4
	ENEMYDMG_24	dsb 4
	ENEMYDMG_28	dsb 4
	ENEMYDMG_2c	dsb 4
	ENEMYDMG_30	dsb 4
	ENEMYDMG_34	dsb 4
	ENEMYDMG_38	dsb 4
	ENEMYDMG_3c	dsb 4
	ENEMYDMG_40	dsb 4
	ENEMYDMG_44	dsb 4
	ENEMYDMG_48	dsb 4
	ENEMYDMG_4c	dsb 4
.ENDE


;;
; @addr{47b7}
_func_07_47b7:
	ld c,Item.id		; $47b7
	ld a,(bc)		; $47b9
	cp ITEMID_MYSTERY_SEED			; $47ba
	ret nz			; $47bc

	ldh a,(<hActiveObjectType)	; $47bd
	add Object.var3f			; $47bf
	ld e,a			; $47c1
	ld a,(de)		; $47c2
	cpl			; $47c3
	bit 5,a			; $47c4
	ret nz			; $47c6

	ld h,b			; $47c7
	ld l,Item.var2a		; $47c8
	ld (hl),$40		; $47ca
	ld l,Item.collisionType		; $47cc
	res 7,(hl)		; $47ce

	ldh a,(<hActiveObjectType)	; $47d0
	add Object.var2a			; $47d2
	ld e,a			; $47d4
	ld a,$9a		; $47d5
	ld (de),a		; $47d7

	ld a,e			; $47d8
	add Object.stunCounter-Object.var2a			; $47d9
	ld e,a			; $47db
	xor a			; $47dc
	ld (de),a		; $47dd
	ret			; $47de

;;
; This can be called for either Link or an item object. (Perhaps other special objects?)
;
; @param	b	Link/Item object
; @param	d	Enemy / part object
; @param	e	Link damage type (see enum below)
; @addr{47df}
_applyDamageToLink_paramE:
	ld a,e			; $47df

;;
; @addr{47e0}
_applyDamageToLink:
	push af			; $47e0
	ldh a,(<hActiveObjectType)	; $47e1
	add Object.var3e			; $47e3
	ld e,a			; $47e5
	ld a,(de)		; $47e6
	ld (wTmpcec0),a		; $47e7
	pop af			; $47ea
	ld hl,@damageTypeTable		; $47eb
	rst_addAToHl			; $47ee

	bit 7,(hl)		; $47ef
	jr z,++			; $47f1

	ldh a,(<hActiveObjectType)	; $47f3
	add Object.damage			; $47f5
	ld e,a			; $47f7
	ld a,(de)		; $47f8
	ld c,Item.damageToApply		; $47f9
	ld (bc),a		; $47fb
++
	ldi a,(hl)		; $47fc
	ld e,a			; $47fd
	ld c,Item.var2a		; $47fe
	ld a,(bc)		; $4800
	ld c,a			; $4801
	ld a,(wTmpcec0)		; $4802
	or c			; $4805
	ld c,Item.var2a		; $4806
	ld (bc),a		; $4808

	; bc = invincibilityCounter
	inc c			; $4809
	ldi a,(hl)		; $480a
	bit 5,e			; $480b
	jr z,+			; $480d
	ld (bc),a		; $480f
+
	; bc = knockbackAngle
	inc c			; $4810
	ldh a,(<hFF8A)	; $4811
	ld (bc),a		; $4813

	; bc = knockbackCounter
	inc c			; $4814
	ldi a,(hl)		; $4815
	bit 4,e			; $4816
	jr z,+			; $4818
	ld (bc),a		; $481a
+
	; bc = stunCounter
	inc c			; $481b
	ldi a,(hl)		; $481c
	bit 4,e			; $481d
	jr z,+			; $481f
	ld (bc),a		; $4821
+
	ld a,e			; $4822
	and $07			; $4823
	ret z			; $4825

	ld hl,@soundEffects		; $4826
	rst_addAToHl			; $4829
	ld a,(hl)		; $482a
	jp playSound		; $482b

; Data format:
; b0: bit 7: whether to apply damage to Link
;     bit 6: does nothing?
;     bit 5: whether to give invincibility frames
;     bit 4: whether to give knockback
;     bit 3: whether to stun it
;     bits 0-2: sound effect to play
; b1: Value to write to Object.invincibilityFrames (if applicable)
; b2: Value to write to Object.knockbackCounter (if applicable)
; b3: Value to write to Object.stunCounter (if applicable)

; @addr{482e}
@damageTypeTable:
	.db $b2 $19 $07 $00 ; LINKDMG_00
	.db $b2 $22 $0f $00 ; LINKDMG_04
	.db $b2 $2a $15 $00 ; LINKDMG_08
	.db $b2 $20 $00 $00 ; LINKDMG_0c
	.db $31 $f8 $0b $00 ; LINKDMG_10
	.db $31 $f1 $13 $00 ; LINKDMG_14
	.db $31 $ea $19 $00 ; LINKDMG_18
	.db $40 $00 $00 $00 ; LINKDMG_1c
	.db $03 $00 $00 $00 ; LINKDMG_20
	.db $c0 $00 $00 $00 ; LINKDMG_24
	.db $13 $00 $10 $00 ; LINKDMG_28
	.db $62 $f4 $00 $00 ; LINKDMG_2c
	.db $c0 $00 $00 $00 ; LINKDMG_30
	.db $31 $fa $06 $00 ; LINKDMG_34
	.db $31 $f8 $08 $00 ; LINKDMG_38

; @addr{486a}
@soundEffects:
	.db SND_NONE
	.db SND_BOMB_LAND
	.db SND_DAMAGE_LINK
	.db SND_CLINK2
	.db SND_BOMB_LAND
	.db SND_BOMB_LAND
	.db SND_BOMB_LAND
	.db SND_BOMB_LAND

.ENUM 0 EXPORT
	LINKDMG_00	dsb 4
	LINKDMG_04	dsb 4
	LINKDMG_08	dsb 4
	LINKDMG_0c	dsb 4
	LINKDMG_10	dsb 4
	LINKDMG_14	dsb 4
	LINKDMG_18	dsb 4
	LINKDMG_1c	dsb 4
	LINKDMG_20	dsb 4
	LINKDMG_24	dsb 4
	LINKDMG_28	dsb 4
	LINKDMG_2c	dsb 4
	LINKDMG_30	dsb 4
	LINKDMG_34	dsb 4
	LINKDMG_38	dsb 4
.ENDE

.ends


 m_section_superfree "Item_Code" namespace "itemCode"

;;
; @addr{4872}
updateItems:
	ld b,$00		; $4872

	ld a,(wScrollMode)		; $4874
	cp $08			; $4877
	jr z,@dontUpdateItems	; $4879

	ld a,(wDisabledObjects)		; $487b
	and $90			; $487e
	jr nz,@dontUpdateItems	; $4880

	ld a,(wPaletteThread_mode)		; $4882
	or a			; $4885
	jr nz,@dontUpdateItems	; $4886

	ld a,(wTextIsActive)		; $4888
	or a			; $488b
	jr z,++			; $488c

	; Set b to $01, indicating items shouldn't be updated after initialization
@dontUpdateItems:
	inc b			; $488e
++
	ld hl,$cc8b		; $488f
	ld a,(hl)		; $4892
	and $fe			; $4893
	or b			; $4895
	ld (hl),a		; $4896

	xor a			; $4897
	ld (wScentSeedActive),a		; $4898

	ld a,Item.start		; $489b
	ldh (<hActiveObjectType),a	; $489d
	ld d,FIRST_ITEM_INDEX		; $489f
	ld a,d			; $48a1

@itemLoop:
	ldh (<hActiveObject),a	; $48a2
	ld e,Item.start		; $48a4
	ld a,(de)		; $48a6
	or a			; $48a7
	jr z,@nextItem		; $48a8

	; Always update items when uninitialized
	ld e,Item.state		; $48aa
	ld a,(de)		; $48ac
	or a			; $48ad
	jr z,+			; $48ae

	; If already initialized, don't update items if this variable is set
	ld a,($cc8b)		; $48b0
	or a			; $48b3
+
	call z,@updateItem		; $48b4
@nextItem:
	inc d			; $48b7
	ld a,d			; $48b8
	cp LAST_ITEM_INDEX+1			; $48b9
	jr c,@itemLoop		; $48bb
	ret			; $48bd

;;
; @param d Item index
; @addr{48be}
@updateItem:
	ld e,Item.id		; $48be
	ld a,(de)		; $48c0
	rst_jumpTable			; $48c1
	.dw itemCode00 ; 0x00
	.dw itemDelete ; 0x01
	.dw itemCode02 ; 0x02
	.dw itemCode03 ; 0x03
	.dw itemCode04 ; 0x04
	.dw itemCode05 ; 0x05
	.dw itemCode06 ; 0x06
	.dw itemDelete ; 0x07
	.dw itemDelete ; 0x08
	.dw itemCode09 ; 0x09
	.dw itemCode0a ; 0x0a
	.dw itemCode0b ; 0x0b
	.dw itemCode0c ; 0x0c
	.dw itemCode0d ; 0x0d
	.dw itemDelete ; 0x0e
	.dw itemCode0f ; 0x0f
	.dw itemDelete ; 0x10
	.dw itemDelete ; 0x11
	.dw itemDelete ; 0x12
	.dw itemCode13 ; 0x13
	.dw itemDelete ; 0x14
	.dw itemCode15 ; 0x15
	.dw itemCode16 ; 0x16
	.dw itemDelete ; 0x17
	.dw itemCode18 ; 0x18
	.dw itemDelete ; 0x19
	.dw itemCode1a ; 0x1a
	.dw itemDelete ; 0x1b
	.dw itemDelete ; 0x1c
	.dw itemCode1d ; 0x1d
	.dw itemCode1e ; 0x1e
	.dw itemDelete ; 0x1f
	.dw itemCode20 ; 0x20
	.dw itemCode21 ; 0x21
	.dw itemCode22 ; 0x22
	.dw itemCode23 ; 0x23
	.dw itemCode24 ; 0x24
	.dw itemDelete ; 0x25
	.dw itemDelete ; 0x26
	.dw itemCode27 ; 0x27
	.dw itemCode28 ; 0x28
	.dw itemCode29 ; 0x29
	.dw itemCode2a ; 0x2a
	.dw itemCode2b ; 0x2b

;;
; The main difference between this and the above "updateItems" is that this is called
; after all of the other objects have been updated. This also doesn't have any conditions
; before it starts calling the update code.
;
; @addr{491a}
updateItemsPost:
	lda Item.start			; $491a
	ldh (<hActiveObjectType),a	; $491b
	ld d,FIRST_ITEM_INDEX		; $491d
	ld a,d			; $491f
@itemLoop:
	ldh (<hActiveObject),a	; $4920
	ld e,Item.enabled		; $4922
	ld a,(de)		; $4924
	or a			; $4925
	call nz,_updateItemPost		; $4926
	inc d			; $4929
	ld a,d			; $492a
	cp $e0			; $492b
	jr c,@itemLoop		; $492d

itemCodeNilPost:
	ret			; $492f

;;
; @addr{4930}
_updateItemPost:
	ld e,$01		; $4930
	ld a,(de)		; $4932
	rst_jumpTable			; $4933

	.dw itemCode00Post	; 0x00
	.dw itemCodeNilPost	; 0x01
	.dw itemCode02Post	; 0x02
	.dw itemCodeNilPost	; 0x03
	.dw itemCode04Post	; 0x04
	.dw itemCode05Post	; 0x05
	.dw itemCodeNilPost	; 0x06
	.dw itemCode07Post	; 0x07
	.dw itemCode08Post	; 0x08
	.dw itemCodeNilPost	; 0x09
	.dw itemCode0aPost	; 0x0a
	.dw itemCode0bPost	; 0x0b
	.dw itemCode0cPost	; 0x0c
	.dw itemCodeNilPost	; 0x0d
	.dw itemCodeNilPost	; 0x0e
	.dw itemCode0fPost	; 0x0f
	.dw itemCodeNilPost	; 0x10
	.dw itemCodeNilPost	; 0x11
	.dw itemCodeNilPost	; 0x12
	.dw itemCode13Post	; 0x13
	.dw itemCodeNilPost	; 0x14
	.dw itemCodeNilPost	; 0x15
	.dw itemCodeNilPost	; 0x16
	.dw itemCodeNilPost	; 0x17
	.dw itemCodeNilPost	; 0x18
	.dw itemCodeNilPost	; 0x19
	.dw itemCodeNilPost	; 0x1a
	.dw itemCodeNilPost	; 0x1b
	.dw itemCodeNilPost	; 0x1c
	.dw itemCode1dPost	; 0x1d
	.dw itemCode1ePost	; 0x1e
	.dw itemCodeNilPost	; 0x1f
	.dw itemCodeNilPost	; 0x20
	.dw itemCodeNilPost	; 0x21
	.dw itemCodeNilPost	; 0x22
	.dw itemCodeNilPost	; 0x23
	.dw itemCodeNilPost	; 0x24
	.dw itemCodeNilPost	; 0x25
	.dw itemCodeNilPost	; 0x26
	.dw itemCodeNilPost	; 0x27
	.dw itemCodeNilPost	; 0x28
	.dw itemCodeNilPost	; 0x29
	.dw itemCodeNilPost	; 0x2a
	.dw itemCodeNilPost	; 0x2b

;;
; @addr{498c}
_loadAttributesAndGraphicsAndIncState:
	call itemIncState		; $498c
	ld l,Item.enabled		; $498f
	ld (hl),$03		; $4991

;;
; Loads values for Item.collisionRadiusY/X, Item.damage, Item.health, and loads graphics.
; @addr{4993}
_itemLoadAttributesAndGraphics:
	ld e,Item.id		; $4993
	ld a,(de)		; $4995
	add a			; $4996
	ld hl,itemAttributes		; $4997
	rst_addDoubleIndex			; $499a

	; b0: Item.collisionType
	ld e,Item.collisionType		; $499b
	ldi a,(hl)		; $499d
	ld (de),a		; $499e

	; b1: Item.collisionRadiusY/X
	ld e,Item.collisionRadiusY		; $499f
	ld a,(hl)		; $49a1
	swap a			; $49a2
	and $0f			; $49a4
	ld (de),a		; $49a6
	inc e			; $49a7
	ldi a,(hl)		; $49a8
	and $0f			; $49a9
	ld (de),a		; $49ab

	; b2: Item.damage
	inc e			; $49ac
	ldi a,(hl)		; $49ad
	ld (de),a		; $49ae
	ld c,a			; $49af

	; b3: Item.health
	inc e			; $49b0
	ldi a,(hl)		; $49b1
	ld (de),a		; $49b2

	; Write Item.damage to Item.var3a as well?
	ld e,Item.var3a		; $49b3
	ld a,c			; $49b5
	ld (de),a		; $49b6

	call _itemSetVar3cToFF		; $49b7
	jpab bank3f.itemLoadGraphics		; $49ba

;;
; @addr{49c2}
_itemSetVar3cToFF:
	ld e,Item.var3c		; $49c2
	ld a,$ff		; $49c4
	ld (de),a		; $49c6
	ret			; $49c7

;;
; Reduces the item's health according to the Item.damageToApply variable.
; Also does something with Item.var2a.
;
; @param[out]	a	[Item.var2a]
; @param[out]	hl	Item.var2a
; @param[out]	zflag	Set if Item.var2a is zero.
; @param[out]	cflag	Set if health went below 0
; @addr{49c8}
_itemUpdateDamageToApply:
	ld h,d			; $49c8
	ld l,Item.damageToApply		; $49c9
	ld a,(hl)		; $49cb
	ld (hl),$00		; $49cc

	ld l,Item.health		; $49ce
	add (hl)		; $49d0
	ld (hl),a		; $49d1
	rlca			; $49d2
	ld l,Item.var2a		; $49d3
	ld a,(hl)		; $49d5
	dec a			; $49d6
	inc a			; $49d7
	ret			; $49d8

;;
; @addr{49d9}
itemAnimate:
	ld h,d			; $49d9
	ld l,Item.animCounter		; $49da
	dec (hl)		; $49dc
	ret nz			; $49dd

	ld l,Item.animPointer		; $49de
	jr _itemNextAnimationFrame		; $49e0

;;
; @param a Animation index
; @addr{49e2}
itemSetAnimation:
	add a			; $49e2
	ld c,a			; $49e3
	ld b,$00		; $49e4
	ld e,Item.id		; $49e6
	ld a,(de)		; $49e8
	ld hl,itemAnimationTable		; $49e9
	rst_addDoubleIndex			; $49ec
	ldi a,(hl)		; $49ed
	ld h,(hl)		; $49ee
	ld l,a			; $49ef
	add hl,bc		; $49f0

;;
; @addr{49f1}
_itemNextAnimationFrame:
	ldi a,(hl)		; $49f1
	ld h,(hl)		; $49f2
	ld l,a			; $49f3

	; Byte 0: how many frames to hold it (or $ff to loop)
	ldi a,(hl)		; $49f4
	cp $ff			; $49f5
	jr nz,++		; $49f7

	; If $ff, animation loops
	ld b,a			; $49f9
	ld c,(hl)		; $49fa
	add hl,bc		; $49fb
	ldi a,(hl)		; $49fc
++
	ld e,Item.animCounter		; $49fd
	ld (de),a		; $49ff

	; Byte 1: frame index (store in bc for now)
	ldi a,(hl)		; $4a00
	ld c,a			; $4a01
	ld b,$00		; $4a02

	; Item.animParameter
	inc e			; $4a04
	ldi a,(hl)		; $4a05
	ld (de),a		; $4a06

	; Item.animPointer
	inc e			; $4a07
	; Save the current position in the animation
	ld a,l			; $4a08
	ld (de),a		; $4a09
	inc e			; $4a0a
	ld a,h			; $4a0b
	ld (de),a		; $4a0c

	ld e,Item.id		; $4a0d
	ld a,(de)		; $4a0f
	ld hl,itemOamDataTable		; $4a10
	rst_addDoubleIndex			; $4a13
	ldi a,(hl)		; $4a14
	ld h,(hl)		; $4a15
	ld l,a			; $4a16
	add hl,bc		; $4a17

	; Set the address of the oam data
	ld e,Item.oamDataAddress		; $4a18
	ldi a,(hl)		; $4a1a
	ld (de),a		; $4a1b
	inc e			; $4a1c
	ldi a,(hl)		; $4a1d
	and $3f			; $4a1e
	ld (de),a		; $4a20
	ret			; $4a21

;;
; Transfer an item's knockbackCounter and knockbackAngle to Link.
; @addr{4a22}
_itemTransferKnockbackToLink:
	ld h,d			; $4a22
	ld l,Item.knockbackCounter		; $4a23
	ld a,(hl)		; $4a25
	or a			; $4a26
	ret z			; $4a27

	ld (hl),$00		; $4a28

	; b = [Item.knockbackAngle]
	dec l			; $4a2a
	ld b,(hl)		; $4a2b

	ld hl,w1Link.knockbackCounter		; $4a2c
	cp (hl)			; $4a2f
	jr c,+			; $4a30
	ld (hl),a		; $4a32
+
	; Set Item.knockbackAngle
	dec l			; $4a33
	ld (hl),b		; $4a34
	ret			; $4a35

;;
; Applies speed based on Item.direction?
;
; @param	hl	Table of offsets for Y/X/Z positions based on Item.direction
; @addr{4a36}
_applyOffsetTableHL:
	ld e,Item.direction		; $4a36
	ld a,(de)		; $4a38

	; a *= 3
	ld e,a			; $4a39
	add a			; $4a3a
	add e			; $4a3b

	rst_addAToHl			; $4a3c

	; b0: Y offset
	ld e,Item.yh		; $4a3d
	ld a,(de)		; $4a3f
	add (hl)		; $4a40
	ld (de),a		; $4a41

	; b1: X offset
	inc hl			; $4a42
	ld e,Item.xh		; $4a43
	ld a,(de)		; $4a45
	add (hl)		; $4a46
	ld (de),a		; $4a47

	; b2: Z offset
	inc hl			; $4a48
	ld e,Item.zh		; $4a49
	ld a,(de)		; $4a4b
	add (hl)		; $4a4c
	ld (de),a		; $4a4d
	ret			; $4a4e

;;
; In sidescrolling areas, the Z position and Y position can't both exist.
; This function adds the Z position to the Y position, and zeroes the Z position.
;
; @param[out]	zflag	Set if not in a sidescrolling area
; @addr{4a4f}
_itemMergeZPositionIfSidescrollingArea:
	ld h,d			; $4a4f
	ld a,(wTilesetFlags)		; $4a50
	and TILESETFLAG_SIDESCROLL			; $4a53
	ret z			; $4a55

	ld e,Item.yh		; $4a56
	ld l,Item.zh		; $4a58
	ld a,(de)		; $4a5a
	add (hl)		; $4a5b
	ld (de),a		; $4a5c
	xor a			; $4a5d
	ldd (hl),a		; $4a5e
	ld (hl),a		; $4a5f
	or d			; $4a60
	ret			; $4a61

;;
; Updates Z position if in midair (not if on the ground). If the item falls into a hazard
; (water/lava/hole), this creates an animation, deletes the item, and returns from the
; caller.
;
; @param	c	Gravity
; @addr{4a62}
_itemUpdateSpeedZAndCheckHazards:
	ld e,Item.zh		; $4a62
	ld a,e			; $4a64
	ldh (<hFF8B),a	; $4a65
	ld a,(de)		; $4a67
	rlca			; $4a68
	jr nc,++		; $4a69

	; If in midair, update z speed
	rrca			; $4a6b
	ldh (<hFF8B),a	; $4a6c
	call objectUpdateSpeedZ_paramC		; $4a6e
	jr nz,+++		; $4a71

	; Item has hit the ground

	ldh (<hFF8B),a	; $4a73
++
	call objectReplaceWithAnimationIfOnHazard		; $4a75
	jr nc,+++		; $4a78

	; Return from caller if this was replaced with an animation
	pop hl			; $4a7a
	ld a,$ff		; $4a7b
	ret			; $4a7d

	; Above ground?
+++
	ldh a,(<hFF8B)	; $4a7e
	rlca			; $4a80
	or a			; $4a81
	ret			; $4a82

;;
; This function moves a bomb toward a point stored in the item's var31/var32 variables.
; Does nothing when var31/var32 are set to zero.
;
; Not used by bombchus, but IS used by scent seeds...
;
; @param[out]	cflag	Set when the bomb has reached the point (if such a point exists)
; @addr{4a83}
_bombPullTowardPoint:
	ld h,d			; $4a83

	; Return if object is above ground.
	ld l,Item.zh		; $4a84
	and $80			; $4a86
	jr nz,@end		; $4a88

	; The following code pulls a bomb towards a specific point.
	; The point is stored in its var31/var32 variables.

	; Load bc with Item.var31/32, and zero out those values
	ld l,Item.var31		; $4a8a
	ld b,(hl)		; $4a8c
	ldi (hl),a		; $4a8d
	ld c,(hl)		; $4a8e
	ldi (hl),a		; $4a8f
	; Return if they were already zero
	or b			; $4a90
	ret z			; $4a91

	; Return if the object contains the point
	push bc			; $4a92
	call objectCheckContainsPoint		; $4a93
	pop bc			; $4a96
	ret c			; $4a97

	; If it doesn't contain the point (not there yet), move toward it
	call objectGetRelativeAngle		; $4a98
	ld c,a			; $4a9b
	ld b,$0a		; $4a9c
	ld e,Item.angle		; $4a9e
	call objectApplyGivenSpeed		; $4aa0
@end:
	xor a			; $4aa3
	ret			; $4aa4

;;
; Deals with checking whether a thrown item has landed on a hole/water/lava, updating its
; vertical speed, etc.
;
; Sets Item.var3b depending on what it landed on (see structs.s for more info).
;
; This does not check for collision with walls; it only updates "vertical" motion and
; checks for collision on that front.
;
; @param	c	Gravity
; @param[out]	cflag	Set if the item has landed.
; @addr{4aa5}
_itemUpdateThrowingVertically:
	; Jump if in a sidescrolling area
	call _itemMergeZPositionIfSidescrollingArea		; $4aa5
	jr nz,@sidescrolling	; $4aa8

	; Update vertical speed, return if the object hasn't landed yet
	call objectUpdateSpeedZ_paramC		; $4aaa
	jr nz,@unsetCollision			; $4aad

	; Object has landed / is bouncing; need to check for collision with water, holes,
	; etc.

	call @checkHoleOrWater		; $4aaf
	bit 4,(hl)		; $4ab2
	set 4,(hl)		; $4ab4
	scf			; $4ab6
	ret			; $4ab7

;;
; @param[out]	zflag	Unset.
; @param[out]	cflag	Unset.
; @addr{4ab8}
@unsetCollision:
	ld l,Item.var3b		; $4ab8
	res 4,(hl)		; $4aba
	or d			; $4abc
	ret			; $4abd

;;
; @param[out]	zflag	Former value of bit 4 of Item.var3b.
; @param[out]	cflag	Set.
; @addr{4abe}
@setCollision:
	ld h,d			; $4abe
	ld l,Item.var3b		; $4abf
	bit 4,(hl)		; $4ac1
	set 4,(hl)		; $4ac3
	scf			; $4ac5
	ret			; $4ac6

;;
; Throwing item update code for sidescrolling areas
;
; @addr{4ac7}
@sidescrolling:
	push bc			; $4ac7
	call @checkHoleOrWater		; $4ac8

	; Jump if object is not moving up.
	ld l,Item.speedZ+1		; $4acb
	bit 7,(hl)		; $4acd
	jr z,@notMovingUp		; $4acf

	; Check for collision with the ceiling
	call objectCheckTileCollision_allowHoles		; $4ad1
	ld h,d			; $4ad4
	pop bc			; $4ad5
	jr nc,@noCeilingCollision	; $4ad6

	; Object collided with ceiling, so Y position isn't updated (though gravity is)
	ld b,$03		; $4ad8
	jr @updateGravity		; $4ada

@notMovingUp:
	; Check for a collision 5 pixels below center
	ld l,Item.yh		; $4adc
	ldi a,(hl)		; $4ade
	add $05			; $4adf
	ld b,a			; $4ae1
	inc l			; $4ae2
	ld c,(hl)		; $4ae3
	call checkTileCollisionAt_allowHoles		; $4ae4
	ld h,d			; $4ae7
	pop bc			; $4ae8
	jr c,@setCollision		; $4ae9

@noCeilingCollision:
	; Set maximum gravity = $0300 normally, $0100 when in water
	ld l,Item.var3b		; $4aeb
	bit 0,(hl)		; $4aed
	ld b,$03		; $4aef
	jr z,+			; $4af1

	ld b,$01		; $4af3
	bit 7,(hl)		; $4af5
	jr nz,@unsetCollision	; $4af7
+
	; Update Y position based on speedZ (since this is a sidescrolling area)
	ld e,Item.speedZ		; $4af9
	ld l,Item.y		; $4afb
	ld a,(de)		; $4afd
	add (hl)		; $4afe
	ldi (hl),a		; $4aff
	inc e			; $4b00
	ld a,(de)		; $4b01
	adc (hl)		; $4b02
	ldi (hl),a		; $4b03

@updateGravity:
	; Update speedZ based on gravity
	ld l,Item.speedZ		; $4b04
	ld a,(hl)		; $4b06
	add c			; $4b07
	ldi (hl),a		; $4b08
	ld a,(hl)		; $4b09
	adc $00			; $4b0a
	ld (hl),a		; $4b0c

	; Return if speedZ is beneath the maximum speed ('b').
	bit 7,a			; $4b0d
	jr nz,@unsetCollision	; $4b0f
	cp b			; $4b11
	jr c,@unsetCollision	; $4b12

	; Set speedZ to the maximum speed 'b'.
	ld (hl),b		; $4b14
	dec l			; $4b15
	ld (hl),$00		; $4b16
	jr @unsetCollision		; $4b18

;;
; Updates Item.var3b depending whether it's on a hole, lava, water tile.
; @addr{4b1a}
@checkHoleOrWater:
	call _itemMergeZPositionIfSidescrollingArea		; $4b1a
	jr nz,@@sidescrolling			; $4b1d

	; Note: a=0 here

	; If top-down view and object is in midair, skip the "objectCheckIsOverHazard" check
	ld l,Item.zh		; $4b1f
	bit 7,(hl)		; $4b21
	jr nz,++		; $4b23

@@sidescrolling:
	call objectCheckIsOverHazard		; $4b25
	ld h,d			; $4b28
++
	; Here, 'a' holds the value for what kind of landing collision has occurred.

	; Update Item.var3b: flip bit 7, clear bit 6, update bits 0-2
	ld b,a			; $4b29
	ld l,Item.var3b		; $4b2a
	ld a,(hl)		; $4b2c
	ld c,a			; $4b2d
	and $b8			; $4b2e
	xor $80			; $4b30
	or b			; $4b32
	ld (hl),a		; $4b33

	; Set bit 6 if the item's bit 0 has changed?
	; (in other words, "landed on water" state has changed)
	ld a,b			; $4b34
	xor c			; $4b35
	rrca			; $4b36
	jr nc,+			; $4b37
	set 6,(hl)		; $4b39
+
	ret			; $4b3b

;;
; Calls _itemUpdateThrowingVertically and creates an appropriate animation if this item
; has fallen into something (water, lava, or a hole). Caller still needs to delete the
; object.
;
; @param	c	Gravity
; @param[out]	cflag	Set if the object has landed in water, lava, or a hole.
; @param[out]	zflag	Set if the object is in midair.
; @addr{4b3c}
_itemUpdateThrowingVerticallyAndCheckHazards:
	call _itemUpdateThrowingVertically		; $4b3c
	jr c,@landed			; $4b3f

	; Object isn't on the ground, so only check for collisions in sidescrolling areas.

	ld a,(wTilesetFlags)		; $4b41
	and TILESETFLAG_SIDESCROLL			; $4b44
	jr z,+			; $4b46

	ld b,INTERACID_LAVASPLASH		; $4b48
	bit 2,(hl)		; $4b4a
	jr nz,@createSplash		; $4b4c

	ld b,INTERACID_SPLASH		; $4b4e
	bit 6,(hl)		; $4b50
	call nz,@createSplash		; $4b52
+
	xor a			; $4b55
	ret			; $4b56

@landed:
	; If the item has landed in a sidescrolling area, there's no need to check what it
	; landed on (since if it had touched water, it would have still been considered
	; to be in midair).
	ld a,(wTilesetFlags)		; $4b57
	and TILESETFLAG_SIDESCROLL			; $4b5a
	jr nz,@noCollisions		; $4b5c

	ld h,d			; $4b5e
	ld l,Item.var3b		; $4b5f
	ld b,INTERACID_SPLASH		; $4b61
	bit 0,(hl)		; $4b63
	jr nz,@createSplash		; $4b65

	ld b,$0f		; $4b67
	bit 1,(hl)		; $4b69
	jr nz,@createHoleAnim	; $4b6b

	ld b,INTERACID_LAVASPLASH		; $4b6d
	bit 2,(hl)		; $4b6f
	jr nz,@createSplash		; $4b71

@noCollisions:
	xor a			; $4b73
	bit 4,(hl)		; $4b74
	ret			; $4b76

@createSplash:
	call objectCreateInteractionWithSubid00		; $4b77
	scf			; $4b7a
	ret			; $4b7b

@createHoleAnim:
	call objectCreateFallingDownHoleInteraction		; $4b7c
	scf			; $4b7f
	ret			; $4b80

;;
; Creates an interaction to do the clinking animation.
; @addr{4b81}
_objectCreateClinkInteraction:
	ld b,INTERACID_CLINK		; $4b81
	jp objectCreateInteractionWithSubid00		; $4b83

;;
; @addr{4b86}
_cpRelatedObject1ID:
	ld a,Object.id		; $4b86
	call objectGetRelatedObject1Var		; $4b88
	ld e,Item.id		; $4b8b
	ld a,(de)		; $4b8d
	cp (hl)			; $4b8e
	ret			; $4b8f

;;
; Same as below, but checks the tile at position bc instead of the tile at the object's
; position.
;
; @param	bc	Position of tile to check
; @addr{4b90}
_itemCheckCanPassSolidTileAt:
	call getTileAtPosition		; $4b90
	jr ++			; $4b93

;;
; This function checks for exceptions to solid tiles which items (switch hook, seeds) can
; pass through. It also keeps track of an "elevation level" in var3e which keeps track of
; how many cliff tiles the item has passed through.
;
; Also updates var3c, var3d (tile position and index).
;
; @param[out]	zflag	Set if there is no collision.
; @addr{4b95}
_itemCheckCanPassSolidTile:
	call objectGetTileAtPosition		; $4b95
++
	; Check if position / tile has changed? (var3c = position, var3d = tile index)
	ld e,a			; $4b98
	ld a,l			; $4b99
	ld h,d			; $4b9a
	ld l,Item.var3c		; $4b9b
	cp (hl)			; $4b9d
	ldi (hl),a		; $4b9e
	jr nz,@tileChanged		; $4b9f

	; Return if the tile index has not changed
	ld a,e			; $4ba1
	cp (hl)			; $4ba2
	ret z			; $4ba3

@tileChanged:
	ld (hl),e		; $4ba4
	ld l,Item.angle		; $4ba5
	ld b,(hl)		; $4ba7
	call _checkTileIsPassableFromDirection		; $4ba8
	jr nc,@collision		; $4bab
	ret z			; $4bad

	; If there was no collision, but the zero flag was not set, the item must move up
	; or down an elevation level (depending on the value of a from the function call).
	ld h,d			; $4bae
	ld l,Item.var3e		; $4baf
	add (hl)		; $4bb1
	ld (hl),a		; $4bb2

	; Check if the item has passed to a "negative" elevation, if so, trigger
	; a collision
	and $80			; $4bb3
	ret z			; $4bb5

@collision:
	ld h,d			; $4bb6
	ld l,Item.var3c		; $4bb7
	ld a,$ff		; $4bb9
	ldi (hl),a		; $4bbb
	ld (hl),a		; $4bbc
	or d			; $4bbd
	ret			; $4bbe

;;
; Checks if an item can pass through the given tile with a given angle.
;
; @param	b	angle
; @param	e	Tile index
; @param[out]	a	The elevation level change that will occur if the item can pass
;			this tile
; @param[out]	cflag	Set if the tile is passable
; @param[out]	zflag	Set if there will be no elevation change (ignore the value of a)
; @addr{4bbf}
_checkTileIsPassableFromDirection:
	; Check if the tile can be passed by items
	ld hl,_itemPassableTilesTable		; $4bbf
	call findByteInCollisionTable_paramE		; $4bc2
	jr c,@canPassWithoutElevationChange		; $4bc5

	; Retrieve a value based on the given angle to see which directions
	; should be checked for passability
	ld a,b			; $4bc7
	ld hl,angleTable		; $4bc8
	rst_addAToHl			; $4bcb
	ld a,(hl)		; $4bcc
	push af			; $4bcd

	ld a,(wActiveCollisions)		; $4bce
	ld hl,_itemPassableCliffTilesTable		; $4bd1
	rst_addDoubleIndex			; $4bd4
	ldi a,(hl)		; $4bd5
	ld h,(hl)		; $4bd6
	ld l,a			; $4bd7

	; If the value retrieved from angleTable was odd, allow the item to pass
	; through 2 directions
	pop af			; $4bd8
	srl a			; $4bd9
	jr nc,@checkOneDirectionOnly	; $4bdb

	rst_addAToHl			; $4bdd
	ld a,(hl)		; $4bde
	push hl			; $4bdf
	rst_addAToHl			; $4be0
	call lookupKey		; $4be1
	pop hl			; $4be4
	jr c,@canPassWithElevationChange		; $4be5

	inc hl			; $4be7
	jr ++			; $4be8

@checkOneDirectionOnly:
	rst_addAToHl			; $4bea
++
	ld a,(hl)		; $4beb
	rst_addAToHl			; $4bec
	call lookupKey		; $4bed
	ret nc			; $4bf0

@canPassWithElevationChange:
	or a			; $4bf1
	scf			; $4bf2
	ret			; $4bf3

@canPassWithoutElevationChange:
	xor a			; $4bf4
	scf			; $4bf5
	ret			; $4bf6

;;
; Checks if the item is on a conveyor belt, updates its position if so.
;
; Used by bombs, bombchus. Might not work well with other items due to assumptions about
; their size.
;
; @addr{4bf7}
_itemUpdateConveyorBelt:
	; Return if in midair
	ld e,Item.zh		; $4bf7
	ld a,(de)		; $4bf9
	rlca			; $4bfa
	ret c			; $4bfb

	; Check if on a conveyor belt; get in 'a' the angle to move in if so
	ld bc,$0500		; $4bfc
	call objectGetRelativeTile		; $4bff
	ld hl,_itemConveyorTilesTable		; $4c02
	call lookupCollisionTable		; $4c05
	ret nc			; $4c08

	push af			; $4c09
	rrca			; $4c0a
	rrca			; $4c0b
	ld hl,_bombEdgeOffsets		; $4c0c
	rst_addAToHl			; $4c0f

	; Set 'bc' to the item's position + offset (where to check for a wall)
	ldi a,(hl)		; $4c10
	ld c,(hl)		; $4c11
	ld h,d			; $4c12
	ld l,Item.yh		; $4c13
	add (hl)		; $4c15
	ld b,a			; $4c16
	ld l,Item.xh		; $4c17
	ld a,(hl)		; $4c19
	add c			; $4c1a
	ld c,a			; $4c1b

	call getTileCollisionsAtPosition		; $4c1c
	cp SPECIALCOLLISION_SCREEN_BOUNDARY			; $4c1f
	jr z,@ret		; $4c21

	call checkGivenCollision_allowHoles		; $4c23
	jr c,@ret		; $4c26

	pop af			; $4c28
	ld c,a			; $4c29
	ld b,SPEED_80		; $4c2a
	ld e,Item.angle		; $4c2c
	jp objectApplyGivenSpeed		; $4c2e

@ret:
	pop af			; $4c31
	ret			; $4c32


; These are offsets from a bomb or bombchu's center to check for wall collisions at.
; This might apply to all throwable items?
_bombEdgeOffsets:
	.db $fd $00 ; DIR_UP
	.db $00 $03 ; DIR_RIGHT
	.db $07 $00 ; DIR_DOWN
	.db $00 $fd ; DIR_LEFT


_itemConveyorTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

; b0: tile index
; b1: angle to move in

@collisions2:
@collisions5:
	.db TILEINDEX_CONVEYOR_UP	$00
	.db TILEINDEX_CONVEYOR_RIGHT	$08
	.db TILEINDEX_CONVEYOR_DOWN	$10
	.db TILEINDEX_CONVEYOR_LEFT	$18
@collisions0:
@collisions1:
@collisions3:
@collisions4:
	.db $00


; This lists the tiles that are passible from a single direction - usually cliffs.
; The second byte in the .db's specifies whether the item has to go up or down a level of
; elevation in order to pass it.
; @addr{4c50}
_itemPassableCliffTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
@collisions4:
	.db @@up-CADDR
	.db @@right-CADDR
	.db @@down-CADDR
	.db @@left-CADDR
	.db @@up-CADDR
@@up:
	.db $64 $ff
	.db $05 $ff
	.db $06 $ff
	.db $07 $ff
	.db $8e $ff
	.db $00
@@down:
	.db $64 $01
	.db $05 $01
	.db $06 $01
	.db $07 $01
	.db $8e $01
	.db $00
@@right:
	.db $0b $01
	.db $0a $ff
	.db $00
@@left:
	.db $0b $ff
	.db $0a $01
	.db $00

@collisions1:
	.db @@up-CADDR
	.db @@right-CADDR
	.db @@down-CADDR
	.db @@left-CADDR
	.db @@up-CADDR
@@up:
	.db $b2 $01
	.db $b0 $ff
	.db $00
@@down:
	.db $b0 $01
	.db $b2 $ff
	.db $00
@@right:
	.db $b3 $01
	.db $b1 $ff
	.db $00
@@left:
	.db $b1 $01
	.db $b3 $ff
	.db $00

@collisions2:
@collisions5:
	.db @@up-CADDR
	.db @@right-CADDR
	.db @@down-CADDR
	.db @@left-CADDR
	.db @@up-CADDR

@@up:
	.db $b0 $ff
	.db $b2 $01
	.db $c1 $ff
	.db $c3 $01
	.db $00
@@down:
	.db $b0 $01
	.db $b2 $ff
	.db $c1 $01
	.db $c3 $ff
	.db $00
@@right:
	.db $c4 $01
	.db $c2 $ff
	.db $b3 $01
	.db $b1 $ff
	.db $00
@@left:
	.db $c4 $ff
	.db $c2 $01
	.db $b3 $ff
	.db $b1 $01
	.db $00

@collisions3:
	.db @@up-CADDR
	.db @@right-CADDR
	.db @@down-CADDR
	.db @@left-CADDR
	.db @@up-CADDR
@@up:
@@right:
@@down:
@@left:
	.db $00

; This lists the tiles that can be passed through by items (such as the switch hook or
; seeds) even if their collisions prevent link from passing them.
; @addr{4cc9}
_itemPassableTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
@collisions4:
	.db $fd $eb
	.db $00
@collisions1:
	.db $94 $95 $0a
	.db $00
@collisions2:
@collisions5:
	.db $90 $91 $92 $93 $94 $95 $96 $97
	.db $98 $99 $9a $9b $0a $0b $0e $0f
@collisions3:
	.db $00


;;
; ITEMID_EMBER_SEED
; ITEMID_SCENT_SEED
; ITEMID_PEGASUS_SEED
; ITEMID_GALE_SEED
; ITEMID_MYSTERY_SEED
;
; @addr{4ced}
itemCode20:
itemCode21:
itemCode22:
itemCode23:
itemCode24:
	ld e,Item.state		; $4ced
	ld a,(de)		; $4cef
	rst_jumpTable			; $4cf0
	.dw @state0
	.dw _seedItemState1
	.dw _seedItemState2
	.dw _seedItemState3

@state0:
	call _itemLoadAttributesAndGraphics		; $4cf9
	xor a			; $4cfc
	call itemSetAnimation		; $4cfd
	call objectSetVisiblec1		; $4d00
	call itemIncState		; $4d03
	ld bc,$ffe0		; $4d06
	call objectSetSpeedZ		; $4d09

	; Subid is nonzero if being used from seed shooter
	ld l,Item.subid		; $4d0c
	ld a,(hl)		; $4d0e
	or a			; $4d0f
	call z,itemUpdateAngle		; $4d10

	ld l,Item.var34		; $4d13
	ld (hl),$03		; $4d15

	ld l,Item.subid		; $4d17
	ldd a,(hl)		; $4d19
	or a			; $4d1a
	jr nz,@shooter		; $4d1b

	; Satchel
	ldi a,(hl)		; $4d1d
	cp ITEMID_GALE_SEED			; $4d1e
	jr nz,++		; $4d20

	; Gale seed
	ld l,Item.zh		; $4d22
	ld a,(hl)		; $4d24
	add $f8			; $4d25
	ld (hl),a		; $4d27
	ld l,Item.angle		; $4d28
	ld (hl),$ff		; $4d2a
	ret			; $4d2c
++
	ld hl,@satchelPositionOffsets		; $4d2d
	call _applyOffsetTableHL		; $4d30
	ld a,SPEED_c0		; $4d33
	jr @setSpeed		; $4d35

@shooter:
	ld e,Item.angle		; $4d37
	ld a,(de)		; $4d39
	rrca			; $4d3a
	ld hl,@shooterPositionOffsets		; $4d3b
	rst_addAToHl			; $4d3e
	ldi a,(hl)		; $4d3f
	ld c,(hl)		; $4d40
	ld b,a			; $4d41

	ld h,d			; $4d42
	ld l,Item.zh		; $4d43
	ld a,(hl)		; $4d45
	add $fe			; $4d46
	ld (hl),a		; $4d48

	; Since 'd'='h', this will copy its own position and apply the offset
	call objectCopyPositionWithOffset		; $4d49

	ld hl,wIsSeedShooterInUse		; $4d4c
	inc (hl)		; $4d4f
	ld a,SPEED_300		; $4d50

@setSpeed:
	ld e,Item.speed		; $4d52
	ld (de),a		; $4d54

	; If it's a mystery seed, get a random effect
	ld e,Item.id		; $4d55
	ld a,(de)		; $4d57
	cp ITEMID_MYSTERY_SEED			; $4d58
	ret nz			; $4d5a

	call getRandomNumber_noPreserveVars		; $4d5b
	and $03			; $4d5e
	ld e,Item.var03		; $4d60
	ld (de),a		; $4d62
	add $80|ITEMCOLLISION_EMBER_SEED			; $4d63
	ld e,Item.collisionType		; $4d65
	ld (de),a		; $4d67
	ret			; $4d68


; Y/X/Z position offsets relative to Link to make seeds appear at (for satchel)
@satchelPositionOffsets:
	.db $fc $00 $fe ; DIR_UP
	.db $01 $04 $fe ; DIR_RIGHT
	.db $05 $00 $fe ; DIR_DOWN
	.db $01 $fb $fe ; DIR_LEFT

; Y/X offsets for shooter
@shooterPositionOffsets:
	.db $f2 $fc ; Up
	.db $fc $0b ; Up-right
	.db $05 $0c ; Right
	.db $09 $0b ; Down-right
	.db $0d $03 ; Down
	.db $0a $f8 ; Down-left
	.db $05 $f3 ; Left
	.db $f8 $f8 ; Up-left


;;
; State 1: seed moving
; @addr{4d85}
_seedItemState1:
	call _itemUpdateDamageToApply		; $4d85
	jr z,@noCollision		; $4d88

	; Check bit 4 of Item.var2a
	bit 4,a			; $4d8a
	jr z,@seedCollidedWithEnemy	; $4d8c

	; [Item.var2a] = 0
	ld (hl),$00		; $4d8e

	call _func_50f4		; $4d90
	jr z,@updatePosition	; $4d93
	jr @seedCollidedWithWall		; $4d95

@noCollision:
	ld e,Item.subid		; $4d97
	ld a,(de)		; $4d99
	or a			; $4d9a
	jr z,@satchelUpdate	; $4d9b

	call _seedItemUpdateBouncing		; $4d9d
	jr nz,@seedCollidedWithWall	; $4da0

@updatePosition:
	call objectCheckWithinRoomBoundary		; $4da2
	jp c,objectApplySpeed		; $4da5
	jp _seedItemDelete		; $4da8

@satchelUpdate:
	; Set speed to 0 if landed in water?
	ld h,d			; $4dab
	ld l,Item.var3b		; $4dac
	bit 0,(hl)		; $4dae
	jr z,+			; $4db0
	ld l,Item.speed		; $4db2
	ld (hl),SPEED_0		; $4db4
+
	call objectCheckWithinRoomBoundary		; $4db6
	jp nc,_seedItemDelete		; $4db9

	call objectApplySpeed		; $4dbc
	ld c,$1c		; $4dbf
	call _itemUpdateThrowingVerticallyAndCheckHazards		; $4dc1
	jp c,_seedItemDelete		; $4dc4
	ret z			; $4dc7

; Landed on ground

	ld a,SND_BOMB_LAND	; $4dc8
	call playSound		; $4dca
	call itemAnimate		; $4dcd
	ld e,Item.id		; $4dd0
	ld a,(de)		; $4dd2
	sub ITEMID_EMBER_SEED			; $4dd3
	rst_jumpTable			; $4dd5
	.dw @emberStandard
	.dw @scentLanded
	.dw _seedItemDelete
	.dw @galeLanded
	.dw @mysteryStandard


; This activates the seed on collision with something. The behaviour is slightly different
; than when it lands on the ground (which is covered above).
@seedCollidedWithWall:
	call itemAnimate		; $4de0
	ld e,Item.id		; $4de3
	ld a,(de)		; $4de5
	sub ITEMID_EMBER_SEED			; $4de6
	rst_jumpTable			; $4de8
	.dw @emberStandard
	.dw @scentOrPegasusCollided
	.dw @scentOrPegasusCollided
	.dw @galeCollidedWithWall
	.dw @mysteryStandard


; Behaviour on collision with enemy; again slightly different
@seedCollidedWithEnemy:
	call itemAnimate		; $4df3
	ld e,Item.collisionType		; $4df6
	xor a			; $4df8
	ld (de),a		; $4df9
	ld e,Item.id		; $4dfa
	ld a,(de)		; $4dfc
	sub ITEMID_EMBER_SEED			; $4dfd
	rst_jumpTable			; $4dff
	.dw @emberStandard
	.dw @scentOrPegasusCollided
	.dw @scentOrPegasusCollided
	.dw @galeCollidedWithEnemy
	.dw @mysteryCollidedWithEnemy


@emberStandard:
@galeCollidedWithEnemy:
	call @initState3		; $4e0a
	jp objectSetVisible82		; $4e0d


@scentLanded:
	ld a,$27		; $4e10
	call @loadGfxVarsWithIndex		; $4e12
	ld a,$02		; $4e15
	call itemSetState		; $4e17
	ld l,Item.collisionType		; $4e1a
	res 7,(hl)		; $4e1c
	ld a,$01		; $4e1e
	call itemSetAnimation		; $4e20
	jp objectSetVisible83		; $4e23


@scentOrPegasusCollided:
	ld e,Item.collisionType		; $4e26
	xor a			; $4e28
	ld (de),a		; $4e29
	jr @initState3		; $4e2a


@galeLanded:
	call @breakTileWithGaleSeed		; $4e2c

	ld a,$25		; $4e2f
	call @loadGfxVarsWithIndex		; $4e31
	ld a,$02		; $4e34
	call itemSetState		; $4e36

	ld l,Item.collisionType		; $4e39
	xor a			; $4e3b
	ldi (hl),a		; $4e3c

	; Set collisionRadiusY/X
	inc l			; $4e3d
	ld a,$02		; $4e3e
	ldi (hl),a		; $4e40
	ld (hl),a		; $4e41

	jp objectSetVisible82		; $4e42


@breakTileWithGaleSeed:
	ld a,BREAKABLETILESOURCE_0d		; $4e45
	jp itemTryToBreakTile		; $4e47


@galeCollidedWithWall:
	call @breakTileWithGaleSeed		; $4e4a
	ld a,$26		; $4e4d
	call @loadGfxVarsWithIndex		; $4e4f
	ld a,$03		; $4e52
	call itemSetState		; $4e54
	ld l,Item.collisionType		; $4e57
	res 7,(hl)		; $4e59
	jp objectSetVisible82		; $4e5b


@mysteryCollidedWithEnemy:
	ld h,d			; $4e5e
	ld l,Item.var2a		; $4e5f
	bit 6,(hl)		; $4e61
	jr nz,@mysteryStandard	; $4e63

	; Change id to be the random type selected
	ld l,Item.var03		; $4e65
	ldd a,(hl)		; $4e67
	add ITEMID_EMBER_SEED			; $4e68
	dec l			; $4e6a
	ld (hl),a		; $4e6b

	call _itemLoadAttributesAndGraphics		; $4e6c
	xor a			; $4e6f
	call itemSetAnimation		; $4e70
	ld e,Item.health		; $4e73
	ld a,$ff		; $4e75
	ld (de),a		; $4e77
	jp @seedCollidedWithEnemy		; $4e78


@mysteryStandard:
	ld e,Item.collisionType		; $4e7b
	xor a			; $4e7d
	ld (de),a		; $4e7e
	call objectSetVisible82		; $4e7f

;;
; Sets state to 3, loads gfx for the new effect, plays sound, sets counter1.
;
; @addr{4e82}
@initState3:
	ld e,Item.state		; $4e82
	ld a,$03		; $4e84
	ld (de),a		; $4e86

	ld e,Item.id		; $4e87
	ld a,(de)		; $4e89

;;
; @param	a	Index to use for below table (plus $20, since
;			ITEMID_EMBER_SEED=$20)
; @addr{4e8a}
@loadGfxVarsWithIndex:
	add a			; $4e8a
	ld hl,@data-(ITEMID_EMBER_SEED*4)		; $4e8b
	rst_addDoubleIndex			; $4e8e

	ld e,Item.oamFlagsBackup		; $4e8f
	ldi a,(hl)		; $4e91
	ld (de),a		; $4e92
	inc e			; $4e93
	ld (de),a		; $4e94
	inc e			; $4e95
	ldi a,(hl)		; $4e96
	ld (de),a		; $4e97
	ldi a,(hl)		; $4e98
	ld e,Item.counter1		; $4e99
	ld (de),a		; $4e9b
	ld a,(hl)		; $4e9c
	jp playSound		; $4e9d

; b0: value for Item.oamFlags and oamFlagsBackup
; b1: value for Item.oamTileIndexBase
; b2: value for Item.counter1
; b3: sound effect
@data:
	.db $0a $06 $3a SND_LIGHTTORCH
	.db $0b $10 $3c SND_PIRATE_BELL
	.db $09 $18 $00 SND_LIGHTTORCH
	.db $09 $28 $32 SND_GALE_SEED
	.db $08 $18 $00 SND_MYSTERY_SEED

	.db $09 $28 $b4 SND_GALE_SEED
	.db $09 $28 $1e SND_GALE_SEED
	.db $0b $3c $96 SND_SCENT_SEED

;;
; @addr{4ec0}
_seedItemDelete:
	ld e,Item.subid		; $4ec0
	ld a,(de)		; $4ec2
	or a			; $4ec3
	jr z,@delete			; $4ec4

	ld hl,wIsSeedShooterInUse		; $4ec6
	ld a,(hl)		; $4ec9
	or a			; $4eca
	jr z,@delete			; $4ecb
	dec (hl)		; $4ecd
@delete:
	jp itemDelete		; $4ece


;;
; State 3: typically occurs when the seed collides with a wall or enemy (instead of the
; ground)
; @addr{4ed1}
_seedItemState3:
	ld e,Item.id		; $4ed1
	ld a,(de)		; $4ed3
	sub ITEMID_EMBER_SEED			; $4ed4
	rst_jumpTable			; $4ed6
	.dw _emberSeedBurn
	.dw _seedUpdateAnimation
	.dw _seedUpdateAnimation
	.dw _galeSeedUpdateAnimationAndCounter
	.dw _seedUpdateAnimation

_emberSeedBurn:
	ld h,d			; $4ee1
	ld l,Item.counter1		; $4ee2
	dec (hl)		; $4ee4
	jr z,@breakTile		; $4ee5

	call itemAnimate		; $4ee7
	call _itemUpdateDamageToApply		; $4eea
	ld l,Item.animParameter		; $4eed
	ld b,(hl)		; $4eef
	jr z,+			; $4ef0

	ld l,Item.collisionType		; $4ef2
	ld (hl),$00		; $4ef4
	bit 7,b			; $4ef6
	jr nz,@deleteSelf	; $4ef8
+
	ld l,Item.z		; $4efa
	ldi a,(hl)		; $4efc
	or (hl)			; $4efd
	ld c,$1c		; $4efe
	jp nz,objectUpdateSpeedZ_paramC		; $4f00
	bit 6,b			; $4f03
	ret z			; $4f05

	call objectCheckTileAtPositionIsWater		; $4f06
	jr c,@deleteSelf	; $4f09
	ret			; $4f0b

@breakTile:
	ld a,BREAKABLETILESOURCE_0c		; $4f0c
	call itemTryToBreakTile		; $4f0e
@deleteSelf:
	jp _seedItemDelete		; $4f11


;;
; Generic update function for seed states 2/3
;
; @addr{4f14}
_seedUpdateAnimation:
	ld e,Item.collisionType		; $4f14
	xor a			; $4f16
	ld (de),a		; $4f17
	call itemAnimate		; $4f18
	ld e,Item.animParameter		; $4f1b
	ld a,(de)		; $4f1d
	rlca			; $4f1e
	ret nc			; $4f1f
	jp _seedItemDelete		; $4f20

;;
; State 2: typically occurs when the seed lands on the ground
; @addr{4f23}
_seedItemState2:
	ld e,Item.id		; $4f23
	ld a,(de)		; $4f25
	sub ITEMID_EMBER_SEED			; $4f26
	rst_jumpTable			; $4f28
	.dw _emberSeedBurn
	.dw _scentSeedSmell
	.dw _seedUpdateAnimation
	.dw _galeSeedTryToWarpLink
	.dw _seedUpdateAnimation

;;
; Scent seed in the "smelling" state that attracts enemies
;
; @addr{4f33}
_scentSeedSmell:
	ld h,d			; $4f33
	ld l,Item.counter1		; $4f34
	ld a,(wFrameCounter)		; $4f36
	rrca			; $4f39
	jr c,+			; $4f3a
	dec (hl)		; $4f3c
	jp z,_seedItemDelete		; $4f3d
+
	; Toggle visibility when counter is low enough
	ld a,(hl)		; $4f40
	cp $1e			; $4f41
	jr nc,+			; $4f43
	ld l,Item.visible		; $4f45
	ld a,(hl)		; $4f47
	xor $80			; $4f48
	ld (hl),a		; $4f4a
+
	ld l,Item.yh		; $4f4b
	ldi a,(hl)		; $4f4d
	ldh (<hFFB2),a	; $4f4e
	inc l			; $4f50
	ldi a,(hl)		; $4f51
	ldh (<hFFB3),a	; $4f52

	ld a,$ff		; $4f54
	ld (wScentSeedActive),a		; $4f56
	call itemAnimate		; $4f59
	call _bombPullTowardPoint		; $4f5c
	jp c,_seedItemDelete		; $4f5f
	jp _itemUpdateSpeedZAndCheckHazards		; $4f62

;;
; @addr{4f65}
_galeSeedUpdateAnimationAndCounter:
	call _galeSeedUpdateAnimation		; $4f65
	call itemDecCounter1		; $4f68
	jp z,_seedItemDelete		; $4f6b

	; Toggle visibility when almost disappeared
	ld a,(hl)		; $4f6e
	cp $14			; $4f6f
	ret nc			; $4f71
	ld l,Item.visible		; $4f72
	ld a,(hl)		; $4f74
	xor $80			; $4f75
	ld (hl),a		; $4f77
	ret			; $4f78

;;
; Note: for some reason, this tends to be called twice per frame in the
; "_galeSeedTryToWarpLink" function, which causes the animation to go over, and it skips
; over some of the palettes?
;
; @addr{4f79}
_galeSeedUpdateAnimation:
	call itemAnimate		; $4f79
	ld e,Item.counter1		; $4f7c
	ld a,(de)		; $4f7e
	and $03			; $4f7f
	ret nz			; $4f81

	; Cycle through palettes
	ld e,Item.oamFlagsBackup		; $4f82
	ld a,(de)		; $4f84
	inc a			; $4f85
	and $0b			; $4f86
	ld (de),a		; $4f88
	inc e			; $4f89
	ld (de),a		; $4f8a
	ret			; $4f8b

;;
; Gale seed in its tornado state, will pull in Link if possible
; @addr{4f8c}
_galeSeedTryToWarpLink:
	call _galeSeedUpdateAnimation		; $4f8c
	ld e,Item.state2		; $4f8f
	ld a,(de)		; $4f91
	rst_jumpTable			; $4f92
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	; Test TILESETFLAG_OUTDOORS
	ld a,(wTilesetFlags)		; $4f9b
	rrca			; $4f9e
	jr nc,@setSubstate3	; $4f9f

	; Check warps enabled, Link not riding companion
	ld a,(wWarpsDisabled)		; $4fa1
	or a			; $4fa4
	jr nz,_galeSeedUpdateAnimationAndCounter	; $4fa5
	ld a,(wLinkObjectIndex)		; $4fa7
	rrca			; $4faa
	jr c,_galeSeedUpdateAnimationAndCounter	; $4fab

	; Don't allow warp to occur if holding a very heavy object?
	ld a,(wLinkGrabState2)		; $4fad
	and $f0			; $4fb0
	cp $40			; $4fb2
	jr z,_galeSeedUpdateAnimationAndCounter	; $4fb4

	call checkLinkVulnerableAndIDZero		; $4fb6
	jr nc,_galeSeedUpdateAnimationAndCounter	; $4fb9
	call objectCheckCollidedWithLink		; $4fbb
	jr nc,_galeSeedUpdateAnimationAndCounter	; $4fbe

	ld hl,w1Link		; $4fc0
	call objectTakePosition		; $4fc3
	ld e,Item.counter2		; $4fc6
	ld a,$3c		; $4fc8
	ld (de),a		; $4fca
	ld e,Item.state2		; $4fcb
	ld a,$01		; $4fcd
	ld (de),a		; $4fcf
	ld (wMenuDisabled),a		; $4fd0
	ld (wLinkCanPassNpcs),a		; $4fd3
	ld (wDisableScreenTransitions),a		; $4fd6
	ld a,LINK_STATE_SPINNING_FROM_GALE		; $4fd9
	ld (wLinkForceState),a		; $4fdb
	jp objectSetVisible80		; $4fde

@setSubstate3:
	ld e,Item.state2		; $4fe1
	ld a,$03		; $4fe3
	ld (de),a		; $4fe5
	ret			; $4fe6


; Substate 1: Link caught in the gale, but still on the ground
@substate1:
	ld a,(wLinkDeathTrigger)		; $4fe7
	or a			; $4fea
	jr nz,@setSubstate3	; $4feb
	ld h,d			; $4fed
	ld l,Item.counter2		; $4fee
	dec (hl)		; $4ff0
	jr z,+			; $4ff1

	; Only flicker if in group 0??? This causes it to look slightly different when
	; used in the past, as opposed to the present...
	ld a,(wActiveGroup)		; $4ff3
	or a			; $4ff6
	jr z,@flickerAndCopyPositionToLink	; $4ff7
	ret			; $4ff9
+
	ld a,$02		; $4ffa
	ld (de),a		; $4ffc


; Substate 2: Link and gale moving up
@substate2:
	; Move Z position up until it reaches $7f
	ld h,d			; $4ffd
	ld l,Item.zh		; $4ffe
	dec (hl)		; $5000
	dec (hl)		; $5001
	bit 7,(hl)		; $5002
	jr nz,@flickerAndCopyPositionToLink	; $5004

	ld a,$02		; $5006
	ld (w1Link.state2),a		; $5008
	ld a,CUTSCENE_16		; $500b
	ld (wCutsceneTrigger),a		; $500d

	; Open warp menu, delete self
	ld a,$05		; $5010
	call openMenu		; $5012
	jp _seedItemDelete		; $5015

@flickerAndCopyPositionToLink:
	ld e,Item.visible		; $5018
	ld a,(de)		; $501a
	xor $80			; $501b
	ld (de),a		; $501d

	xor a			; $501e
	ld (wLinkSwimmingState),a		; $501f
	ld hl,w1Link		; $5022
	jp objectCopyPosition		; $5025


; Substate 3: doesn't warp Link anywhere, just waiting for it to get deleted
@substate3:
	call itemDecCounter2		; $5028
	jp z,_seedItemDelete		; $502b
	ld l,Item.visible		; $502e
	ld a,(hl)		; $5030
	xor $80			; $5031
	ld (hl),a		; $5033
	ret			; $5034

;;
; Called for seeds used with seed shooter. Checks for tile collisions and triggers
; "bounces" when that happens.
;
; @param[out]	zflag	Unset when the seed's "effect" should be activated
; @addr{5035}
_seedItemUpdateBouncing:
	call objectGetTileAtPosition		; $5035
	ld hl,_seedDontBounceTilesTable		; $5038
	call findByteInCollisionTable		; $503b
	jr c,@unsetZFlag	; $503e

	ld e,Item.angle		; $5040
	ld a,(de)		; $5042
	bit 2,a			; $5043
	jr z,@movingStraight		; $5045

; Moving diagonal

	call _seedItemCheckDiagonalCollision		; $5047

	; Call this just to update var3c/var3d (tile position / index)?
	push af			; $504a
	call _itemCheckCanPassSolidTile		; $504b
	pop af			; $504e

	jr z,@setZFlag		; $504f
	jr @bounce		; $5051

@movingStraight:
	ld e,Item.var33		; $5053
	xor a			; $5055
	ld (de),a		; $5056
	call objectCheckTileCollision_allowHoles		; $5057
	jr nc,@setZFlag		; $505a

	ld e,Item.var33		; $505c
	ld a,$03		; $505e
	ld (de),a		; $5060
	call _itemCheckCanPassSolidTile		; $5061
	jr z,@setZFlag		; $5064

@bounce:
	call _seedItemClearKnockback		; $5066

	; Decrement bounce counter
	ld h,d			; $5069
	ld l,Item.var34		; $506a
	dec (hl)		; $506c
	jr z,@unsetZFlag	; $506d

	ld l,Item.var33		; $506f
	ld a,(hl)		; $5071
	cp $03			; $5072
	jr z,@reverseBothComponents	; $5074

	; Calculate new angle based on whether it was a vertical or horizontal collision
	ld c,a			; $5076
	ld e,Item.angle		; $5077
	ld a,(de)		; $5079
	rrca			; $507a
	rrca			; $507b
	and $06			; $507c
	add c			; $507e
	ld hl,@angleCalcTable-1		; $507f
	rst_addAToHl			; $5082
	ld a,(hl)		; $5083
	ld (de),a		; $5084

@setZFlag:
	xor a			; $5085
	ret			; $5086

; Flips both X and Y componets
@reverseBothComponents:
	ld l,Item.angle		; $5087
	ld a,(hl)		; $5089
	xor $10			; $508a
	ld (hl),a		; $508c
	xor a			; $508d
	ret			; $508e

@unsetZFlag:
	or d			; $508f
	ret			; $5090


; Used for calculating new angle after bounces
@angleCalcTable:
	.db $1c $0c $14 $04 $0c $1c $04 $14

;;
; Called when a seed is moving in a diagonal direction.
;
; Sets var33 such that bits 0 and 1 are set on horizontal and vertical collisions,
; respectively.
;
; @param	a	Angle
; @param[out]	zflag	Unset if the seed should bounce
; @addr{5099}
_seedItemCheckDiagonalCollision:
	rrca			; $5099
	and $0c			; $509a
	ld hl,@collisionOffsets		; $509c
	rst_addAToHl			; $509f
	xor a			; $50a0
	ldh (<hFF8A),a	; $50a1

	; Loop will iterate twice (first for vertical collision, then horizontal).
	ld e,Item.var33		; $50a3
	ld a,$40		; $50a5
	ld (de),a		; $50a7

@nextComponent:
	ld e,Item.yh		; $50a8
	ld a,(de)		; $50aa
	add (hl)		; $50ab
	ld b,a			; $50ac
	inc hl			; $50ad
	ld e,Item.xh		; $50ae
	ld a,(de)		; $50b0
	add (hl)		; $50b1
	ld c,a			; $50b2

	inc hl			; $50b3
	push hl			; $50b4
	call checkTileCollisionAt_allowHoles		; $50b5
	jr nc,@next		; $50b8

; Collision occurred; check whether it should bounce (set carry flag if so)

	call getTileAtPosition		; $50ba
	ld hl,_seedDontBounceTilesTable		; $50bd
	call findByteInCollisionTable		; $50c0
	ccf			; $50c3
	jr nc,@next	; $50c4

	ld h,d			; $50c6
	ld l,Item.angle		; $50c7
	ld b,(hl)		; $50c9
	call _checkTileIsPassableFromDirection		; $50ca
	ccf			; $50cd
	jr c,@next	; $50ce
	jr z,@next	; $50d0

	; Bounce if the new elevation would be negative
	ld h,d			; $50d2
	ld l,Item.var3e		; $50d3
	add (hl)		; $50d5
	rlca			; $50d6

@next:
	; Rotate carry bit into var33
	ld h,d			; $50d7
	ld l,Item.var33		; $50d8
	rl (hl)			; $50da
	pop hl			; $50dc
	jr nc,@nextComponent	; $50dd

	ld e,Item.var33		; $50df
	ld a,(de)		; $50e1
	or a			; $50e2
	ret			; $50e3


; Offsets from item position to check for collisions at.
; First 2 bytes are offsets for vertical collisions, next 2 are for horizontal.
@collisionOffsets:
	.db $fc $00 $00 $03 ; Up-right
	.db $03 $00 $00 $03 ; Down-right
	.db $03 $00 $00 $fc ; Down-left
	.db $fc $00 $00 $fc ; Up-left


;;
; @param	h,d	Object
; @param[out]	zflag	Set if there are still bounces left?
; @addr{50f4}
_func_50f4:
	ld e,Item.angle		; $50f4
	ld l,Item.knockbackAngle		; $50f6
	ld a,(de)		; $50f8
	add (hl)		; $50f9
	ld hl,_data_5114		; $50fa
	rst_addAToHl			; $50fd
	ld c,(hl)		; $50fe
	ld a,(de)		; $50ff
	cp c			; $5100
	jr z,_seedItemClearKnockback	; $5101

	ld h,d			; $5103
	ld l,Item.var34		; $5104
	dec (hl)		; $5106
	jr z,@unsetZFlag	; $5107

	; Set Item.angle
	ld a,c			; $5109
	ld (de),a		; $510a
	xor a			; $510b
	ret			; $510c

@unsetZFlag:
	or d			; $510d
	ret			; $510e

;;
; @addr{510f}
_seedItemClearKnockback:
	ld e,Item.knockbackCounter		; $510f
	xor a			; $5111
	ld (de),a		; $5112
	ret			; $5113


_data_5114:
	.db $00 $08 $10 $18 $1c $04 $0c $14
	.db $18 $00 $08 $10 $14 $1c $04 $0c
	.db $10 $18 $00 $08 $0c $14 $1c $04
	.db $08 $10 $18 $00 $04 $0c $14 $1c


; List of tiles which seeds don't bounce off of. (Burnable stuff.)
_seedDontBounceTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
	.db $ce $cf $c5 $c5 $c6 $c7 $c8 $c9 $ca
@collisions1:
@collisions3:
@collisions4:
	.db $00

@collisions2:
@collisions5:
	.db TILEINDEX_UNLIT_TORCH
	.db TILEINDEX_LIT_TORCH
	.db $00


;;
; This is an object which serves as a collision for enemies when Dimitri does his eating
; attack. Also checks for eatable tiles.
;
; ITEMID_DIMITRI_MOUTH
; @addr{514d}
itemCode2b:
	ld e,Item.state		; $514d
	ld a,(de)		; $514f
	or a			; $5150
	jr nz,+			; $5151

	; Initialization
	call _itemLoadAttributesAndGraphics		; $5153
	call itemIncState		; $5156
	ld l,Item.counter1		; $5159
	ld (hl),$0c		; $515b
+
	call @calcPosition		; $515d

	; Check for enemy collision?
	ld h,d			; $5160
	ld l,Item.var2a		; $5161
	bit 1,(hl)		; $5163
	jr nz,@swallow		; $5165

	ld a,BREAKABLETILESOURCE_DIMITRI_EAT		; $5167
	call itemTryToBreakTile		; $5169
	jr c,@swallow			; $516c

	; Delete self after 12 frames
	call itemDecCounter1		; $516e
	jr z,@delete		; $5171
	ret			; $5173

@swallow:
	; Set var35 to $01 to tell Dimitri to do his swallow animation?
	ld a,$01		; $5174
	ld (w1Companion.var35),a		; $5176

@delete:
	jp itemDelete		; $5179

;;
; Sets the position for this object around Dimitri's mouth.
;
; @addr{517c}
@calcPosition:
	ld a,(w1Companion.direction)		; $517c
	ld hl,@offsets		; $517f
	rst_addDoubleIndex			; $5182
	ldi a,(hl)		; $5183
	ld c,(hl)		; $5184
	ld b,a			; $5185
	ld hl,w1Companion.yh		; $5186
	jp objectTakePositionWithOffset		; $5189

@offsets:
	.db $f6 $00 ; DIR_UP
	.db $fe $0a ; DIR_RIGHT
	.db $04 $00 ; DIR_DOWN
	.db $fe $f6 ; DIR_LEFT


;;
; ITEMID_BOMBCHUS
; @addr{5194}
itemCode0d:
	call _bombchuCountdownToExplosion		; $5194

	; If state is $ff, it's exploding
	ld e,Item.state		; $5197
	ld a,(de)		; $5199
	cp $ff			; $519a
	jp nc,_itemUpdateExplosion		; $519c

	call objectCheckWithinRoomBoundary		; $519f
	jp nc,itemDelete		; $51a2

	call objectSetPriorityRelativeToLink_withTerrainEffects		; $51a5

	ld a,(wTilesetFlags)		; $51a8
	and TILESETFLAG_SIDESCROLL			; $51ab
	jr nz,@sidescroll	; $51ad

	; This call will return if the bombchu falls into a hole/water/lava.
	ld c,$20		; $51af
	call _itemUpdateSpeedZAndCheckHazards		; $51b1

	ld e,Item.state		; $51b4
	ld a,(de)		; $51b6
	rst_jumpTable			; $51b7

	.dw @tdState0
	.dw @tdState1
	.dw @tdState2
	.dw @tdState3
	.dw @tdState4

@sidescroll:
	ld e,Item.var32		; $51c2
	ld a,(de)		; $51c4
	or a			; $51c5
	jr nz,+			; $51c6

	ld c,$18		; $51c8
	call _itemUpdateThrowingVerticallyAndCheckHazards		; $51ca
	jp c,itemDelete		; $51cd
+
	ld e,Item.state		; $51d0
	ld a,(de)		; $51d2
	rst_jumpTable			; $51d3

	.dw @ssState0
	.dw @ssState1
	.dw @ssState2
	.dw @ssState3


@tdState0:
	call _itemLoadAttributesAndGraphics		; $51dc
	call decNumBombchus		; $51df

	ld h,d			; $51e2
	ld l,Item.state		; $51e3
	inc (hl)		; $51e5

	; var30 used to cycle through possible targets
	ld l,Item.var30		; $51e6
	ld (hl),FIRST_ENEMY_INDEX		; $51e8

	ld l,Item.speedTmp		; $51ea
	ld (hl),SPEED_80		; $51ec

	ld l,Item.counter1		; $51ee
	ld (hl),$10		; $51f0

	; Explosion countdown
	inc l			; $51f2
	ld (hl),$b4		; $51f3

	; Collision radius is used as vision radius before a target is found
	ld l,Item.collisionRadiusY		; $51f5
	ld a,$18		; $51f7
	ldi (hl),a		; $51f9
	ld (hl),a		; $51fa

	; Default "direction to turn" on encountering a hole
	ld l,Item.var31		; $51fb
	ld (hl),$08		; $51fd

	; Initialize angle based on link's facing direction
	ld l,Item.angle		; $51ff
	ld a,(w1Link.direction)		; $5201
	swap a			; $5204
	rrca			; $5206
	ld (hl),a		; $5207
	ld l,Item.direction		; $5208
	ld (hl),$ff		; $520a

	call _bombchuSetAnimationFromAngle		; $520c
	jp _bombchuSetPositionInFrontOfLink		; $520f


; State 1: waiting to reach the ground (if dropped from midair)
@tdState1:
	ld h,d			; $5212
	ld l,Item.zh		; $5213
	bit 7,(hl)		; $5215
	jr nz,++		; $5217

	; Increment state if on the ground
	ld l,e			; $5219
	inc (hl)		; $521a

; State 2: searching for target
@tdState2:
	call _bombchuCheckForEnemyTarget		; $521b
	ret z			; $521e
++
	call _bombchuUpdateSpeed		; $521f
	call _itemUpdateConveyorBelt		; $5222

@animate:
	jp itemAnimate		; $5225


; State 3: target found
@tdState3:
	ld h,d			; $5228
	ld l,Item.counter1		; $5229
	dec (hl)		; $522b
	jp nz,_itemUpdateConveyorBelt		; $522c

	; Set counter
	ld (hl),$0a		; $522f

	; Increment state
	ld l,e			; $5231
	inc (hl)		; $5232


; State 4: Dashing toward target
@tdState4:
	call _bombchuCheckCollidedWithTarget		; $5233
	jp c,_bombchuClearCounter2AndInitializeExplosion		; $5236

	call _bombchuUpdateVelocity		; $5239
	call _itemUpdateConveyorBelt		; $523c
	jr @animate		; $523f


; Sidescrolling states

@ssState0:
	; Do the same initialization as top-down areas
	call @tdState0		; $5241

	; Force the bombchu to face left or right
	ld e,Item.angle		; $5244
	ld a,(de)		; $5246
	bit 3,a			; $5247
	ret nz			; $5249

	add $08			; $524a
	ld (de),a		; $524c
	jp _bombchuSetAnimationFromAngle		; $524d

; State 1: searching for target
@ssState1:
	ld e,Item.speed		; $5250
	ld a,SPEED_80		; $5252
	ld (de),a		; $5254
	call _bombchuCheckForEnemyTarget		; $5255
	ret z			; $5258

	; Target not found yet

	call _bombchuCheckWallsAndApplySpeed		; $5259

@ssAnimate:
	jp itemAnimate		; $525c


; State 2: Target found, wait for a few frames
@ssState2:
	call itemDecCounter1		; $525f
	ret nz			; $5262

	ld (hl),$0a		; $5263

	; Increment state
	ld l,e			; $5265
	inc (hl)		; $5266

; State 3: Chase after target
@ssState3:
	call _bombchuCheckCollidedWithTarget		; $5267
	jp c,_bombchuClearCounter2AndInitializeExplosion		; $526a
	call _bombchuUpdateVelocityAndClimbing_sidescroll		; $526d
	jr @ssAnimate		; $5270


;;
; Updates bombchu's position & speed every frame, and the angle every 8 frames.
;
; @addr{5272}
_bombchuUpdateVelocity:
	ld a,(wFrameCounter)		; $5272
	and $07			; $5275
	call z,_bombchuUpdateAngle_topDown		; $5277

;;
; @addr{527a}
_bombchuUpdateSpeed:
	call @updateSpeed		; $527a

	; Note: this will actually update the Z position for a second time in the frame?
	; (due to earlier call to _itemUpdateSpeedZAndCheckHazards)
	ld c,$18		; $527d
	call objectUpdateSpeedZ_paramC		; $527f

	jp objectApplySpeed		; $5282


; Update the speed based on what kind of tile it's on
@updateSpeed:
	ld e,Item.angle		; $5285
	call _bombchuGetTileCollisions		; $5287

	cp SPECIALCOLLISION_HOLE			; $528a
	jr z,@impassableTile	; $528c

	cp SPECIALCOLLISION_15			; $528e
	jr z,@impassableTile	; $5290

	; Check for SPECIALCOLLISION_SCREEN_BOUNDARY
	inc a			; $5292
	jr z,@impassableTile	; $5293

	; Set the bombchu's speed (halve it if it's on a solid tile)
	dec a			; $5295
	ld e,Item.speedTmp		; $5296
	ld a,(de)		; $5298
	jr z,+			; $5299

	ld e,a			; $529b
	ld hl,_bounceSpeedReductionMapping		; $529c
	call lookupKey		; $529f
+
	; If new speed < old speed, trigger a jump. (Happens when a bombchu starts
	; climbing a wall)
	ld h,d			; $52a2
	ld l,Item.speed		; $52a3
	cp (hl)			; $52a5
	ld (hl),a		; $52a6
	ret nc			; $52a7

	ld l,Item.speedZ		; $52a8
	ld a,$80		; $52aa
	ldi (hl),a		; $52ac
	ld (hl),$ff		; $52ad
	ret			; $52af

; Bombchus can pass most tiles, even walls, but not holes (perhaps a few other things).
@impassableTile:
	; Item.var31 holds the direction the bombchu should turn to continue moving closer
	; to the target.
	ld h,d			; $52b0
	ld l,Item.var31		; $52b1
	ld a,(hl)		; $52b3
	ld l,Item.angle		; $52b4
	add (hl)		; $52b6
	and $18			; $52b7
	ld (hl),a		; $52b9
	jp _bombchuSetAnimationFromAngle		; $52ba

;;
; Get tile collisions at the front end of the bombchu.
;
; @param	e	Angle address (object variable)
; @param[out]	a	Collision value
; @param[out]	hl	Address of collision data
; @param[out]	zflag	Set if there is no collision.
; @addr{52bd}
_bombchuGetTileCollisions:
	ld h,d			; $52bd
	ld l,Item.yh		; $52be
	ld b,(hl)		; $52c0
	ld l,Item.xh		; $52c1
	ld c,(hl)		; $52c3

	ld a,(de)		; $52c4
	rrca			; $52c5
	rrca			; $52c6
	ld hl,@offsets		; $52c7
	rst_addAToHl			; $52ca
	ldi a,(hl)		; $52cb
	add b			; $52cc
	ld b,a			; $52cd
	ld a,(hl)		; $52ce
	add c			; $52cf
	ld c,a			; $52d0
	jp getTileCollisionsAtPosition		; $52d1

@offsets:
	.db $fc $00 ; DIR_UP
	.db $02 $03 ; DIR_RIGHT
	.db $06 $00 ; DIR_DOWN
	.db $02 $fc ; DIR_LEFT

;;
; @addr{52dc}
_bombchuUpdateVelocityAndClimbing_sidescroll:
	ld a,(wFrameCounter)		; $52dc
	and $07			; $52df
	call z,_bombchuUpdateAngle_sidescrolling		; $52e1

;;
; In sidescrolling areas, this updates the bombchu's "climbing wall" state.
;
; @addr{52e4}
_bombchuCheckWallsAndApplySpeed:
	call @updateWallClimbing		; $52e4
	jp objectApplySpeed		; $52e7

;;
; @addr{52ea}
@updateWallClimbing:
	ld e,Item.var32		; $52ea
	ld a,(de)		; $52ec
	or a			; $52ed
	jr nz,@climbingWall	; $52ee

	; Return if it hasn't collided with a wall
	ld e,Item.angle		; $52f0
	call _bombchuGetTileCollisions		; $52f2
	ret z			; $52f5

	; Check for SPECIALCOLLISION_SCREEN_BOUNDARY
	inc a			; $52f6
	jr nz,+			; $52f7

	; Reverse direction if it runs into such a tile
	ld e,Item.angle		; $52f9
	ld a,(de)		; $52fb
	xor $10			; $52fc
	ld (de),a		; $52fe
	jp _bombchuSetAnimationFromAngle		; $52ff
+
	; Tell it to start climbing the wall
	ld h,d			; $5302
	ld l,Item.angle		; $5303
	ld a,(hl)		; $5305
	ld (hl),$00		; $5306
	ld l,Item.var33		; $5308
	ld (hl),a		; $530a
	ld l,Item.var32		; $530b
	ld (hl),$01		; $530d
	jp _bombchuSetAnimationFromAngle		; $530f

@climbingWall:
	; Check if the bombchu is still touching the wall it's supposed to be climbing
	ld e,Item.var33		; $5312
	call _bombchuGetTileCollisions		; $5314
	jr nz,@@touchingWall	; $5317

	; Bombchu is no longer touching the wall it's climbing. It will now "uncling"; the
	; following code figures out which direction to make it face.
	; The direction will be the "former angle" (var33) unless it's on the ceiling, in
	; which case, it will just continue in its current direction.

	ld h,d			; $5319
	ld l,Item.angle		; $531a
	ld e,Item.var33		; $531c
	ld a,(de)		; $531e
	or a			; $531f
	jr nz,+			; $5320

	ld a,(hl)		; $5322
	ld e,Item.var33		; $5323
	ld (de),a		; $5325
+
	; Revert to former angle and uncling
	ld a,(de)		; $5326
	ld (hl),a		; $5327
	ld l,Item.var32		; $5328
	xor a			; $532a
	ldi (hl),a		; $532b
	inc l			; $532c
	ld (hl),a		; $532d

	; Clear vertical speed
	ld l,Item.speedZ		; $532e
	ldi (hl),a		; $5330
	ldi (hl),a		; $5331

	ld l,Item.direction		; $5332
	ld (hl),$ff		; $5334
	jp _bombchuSetAnimationFromAngle		; $5336

@@touchingWall:
	; Check if it hits a wall
	ld e,Item.angle		; $5339
	call _bombchuGetTileCollisions		; $533b
	ret z			; $533e

	; If so, try to cling to it
	ld h,d			; $533f
	ld l,Item.angle		; $5340
	ld b,(hl)		; $5342
	ld e,Item.var33		; $5343
	ld a,(de)		; $5345
	xor $10			; $5346
	ld (hl),a		; $5348

	; If both the new and old angles are horizontal, stop clinging to the wall?
	bit 3,a			; $5349
	jr z,+			; $534b
	bit 3,b			; $534d
	jr z,+			; $534f

	ld l,Item.var32		; $5351
	ld (hl),$00		; $5353
+
	; Set var33
	ld a,b			; $5355
	ld (de),a		; $5356

	; If a==0 (old angle was "up"), the bombchu will cling to the ceiling (var34 will
	; be nonzero).
	or a			; $5357
	ld l,Item.var34		; $5358
	ld (hl),$00		; $535a
	jr nz,_bombchuSetAnimationFromAngle	; $535c
	inc (hl)		; $535e
	jr _bombchuSetAnimationFromAngle		; $535f

;;
; Sets the bombchu's angle relative to its target.
;
; @addr{5361}
_bombchuUpdateAngle_topDown:
	ld a,Object.yh		; $5361
	call objectGetRelatedObject2Var		; $5363
	ld b,(hl)		; $5366
	ld l,Enemy.xh		; $5367
	ld c,(hl)		; $5369
	call objectGetRelativeAngle		; $536a

	; Turn the angle into a cardinal direction, set that to the bombchu's angle
	ld b,a			; $536d
	add $04			; $536e
	and $18			; $5370
	ld e,Item.angle		; $5372
	ld (de),a		; $5374

	; Write $08 or $f8 to Item.var31, depending on which "side" the bombchu will need
	; to turn towards later?
	sub b			; $5375
	and $1f			; $5376
	cp $10			; $5378
	ld a,$08		; $537a
	jr nc,+			; $537c
	ld a,$f8		; $537e
+
	ld e,Item.var31		; $5380
	ld (de),a		; $5382

;;
; If [Item.angle] != [Item.direction], this updates the item's animation. The animation
; index is 0-3 depending on the item's angle (or sometimes it's 4-5 if var34 is set).
;
; Note: this sets the direction to equal the angle value, which is non-standard (usually
; the direction is a value from 0-3, not from $00-$1f).
;
; Also, this assumes that the item's angle is a cardinal direction?
;
; @addr{5383}
_bombchuSetAnimationFromAngle:
	ld h,d			; $5383
	ld l,Item.direction		; $5384
	ld e,Item.angle		; $5386
	ld a,(de)		; $5388
	cp (hl)			; $5389
	ret z			; $538a

	; Update Item.direction
	ld (hl),a		; $538b

	; Convert angle to a value from 0-3. (Assumes that the angle is a cardinal
	; direction?)
	swap a			; $538c
	rlca			; $538e

	ld l,Item.var34		; $538f
	bit 0,(hl)		; $5391
	jr z,+			; $5393
	dec a			; $5395
	ld a,$04		; $5396
	jr z,+			; $5398
	inc a			; $539a
+
	jp itemSetAnimation		; $539b

;;
; Sets up a bombchu's angle toward its target such that it will only move along its
; current axis; so if it's moving along the X axis, it will chase on the X axis, and
; vice-versa.
;
; @addr{539e}
_bombchuUpdateAngle_sidescrolling:
	ld a,Object.yh		; $539e
	call objectGetRelatedObject2Var		; $53a0
	ld b,(hl)		; $53a3
	ld l,Enemy.xh		; $53a4
	ld c,(hl)		; $53a6
	call objectGetRelativeAngle		; $53a7

	ld b,a			; $53aa
	ld e,Item.angle		; $53ab
	ld a,(de)		; $53ad
	bit 3,a			; $53ae
	ld a,b			; $53b0
	jr nz,@leftOrRight	; $53b1

; Bombchu facing up or down

	sub $08			; $53b3
	and $1f			; $53b5
	cp $10			; $53b7
	ld a,$00		; $53b9
	jr c,@setAngle		; $53bb
	ld a,$10		; $53bd
	jr @setAngle		; $53bf

; Bombchu facing left or right
@leftOrRight:
	cp $10			; $53c1
	ld a,$08		; $53c3
	jr c,@setAngle		; $53c5
	ld a,$18		; $53c7

@setAngle:
	ld e,Item.angle		; $53c9
	ld (de),a		; $53cb
	jr _bombchuSetAnimationFromAngle		; $53cc

;;
; Set a bombchu's position to be slightly in front of Link, based on his direction. If it
; would put the item in a wall, it will default to Link's exact position instead.
;
; @param[out]	zflag	Set if the item defaulted to Link's exact position due to a wall
; @addr{53ce}
_bombchuSetPositionInFrontOfLink:
	ld hl,w1Link.yh		; $53ce
	ld b,(hl)		; $53d1
	ld l,<w1Link.xh		; $53d2
	ld c,(hl)		; $53d4

	ld a,(wActiveGroup)		; $53d5
	cp FIRST_SIDESCROLL_GROUP			; $53d8
	ld l,<w1Link.direction		; $53da
	ld a,(hl)		; $53dc

	ld hl,@normalOffsets		; $53dd
	jr c,+			; $53e0
	ld hl,@sidescrollOffsets		; $53e2
+
	; Set the item's position to [Link's position] + [Offset from table]
	rst_addDoubleIndex			; $53e5
	ld e,Item.yh		; $53e6
	ldi a,(hl)		; $53e8
	add b			; $53e9
	ld (de),a		; $53ea
	ld e,Item.xh		; $53eb
	ld a,(hl)		; $53ed
	add c			; $53ee
	ld (de),a		; $53ef

	; Check if it's in a wall
	push bc			; $53f0
	call objectGetTileCollisions		; $53f1
	pop bc			; $53f4
	cp $0f			; $53f5
	ret nz			; $53f7

	; If the item would end up on a solid tile, put it directly on Link instead
	; (ignore the offset from the table)
	ld a,c			; $53f8
	ld (de),a		; $53f9
	ld e,Item.yh		; $53fa
	ld a,b			; $53fc
	ld (de),a		; $53fd
	ret			; $53fe

; Offsets relative to Link where items will appear

@normalOffsets:
	.db $f4 $00 ; DIR_UP
	.db $02 $0c ; DIR_RIGHT
	.db $0c $00 ; DIR_DOWN
	.db $02 $f4 ; DIR_LEFT

@sidescrollOffsets:
	.db $00 $00 ; DIR_UP
	.db $02 $0c ; DIR_RIGHT
	.db $00 $00 ; DIR_DOWN
	.db $02 $f4 ; DIR_LEFT


;;
; Bombchus call this every frame.
;
; @addr{540f}
_bombchuCountdownToExplosion:
	call itemDecCounter2		; $540f
	ret nz			; $5412

;;
; @addr{5413}
_bombchuClearCounter2AndInitializeExplosion:
	ld e,Item.counter2		; $5413
	xor a			; $5415
	ld (de),a		; $5416
	jp _itemInitializeBombExplosion		; $5417

;;
; @param[out]	cflag	Set on collision or if the enemy has died
; @addr{541a}
_bombchuCheckCollidedWithTarget:
	ld a,Object.health		; $541a
	call objectGetRelatedObject2Var		; $541c
	ld a,(hl)		; $541f
	or a			; $5420
	scf			; $5421
	ret z			; $5422
	jp checkObjectsCollided		; $5423

;;
; Each time this is called, it checks one enemy and sets it as the target if it meets all
; the conditions (close enough, valid target, etc).
;
; Each time it loops through all enemies, the bombchu's vision radius increases.
;
; @param[out]	zflag	Set if a valid target is found
; @addr{5426}
_bombchuCheckForEnemyTarget:
	; Check if the target enemy is enabled
	ld e,Item.var30		; $5426
	ld a,(de)		; $5428
	ld h,a			; $5429
	ld l,Enemy.enabled		; $542a
	ld a,(hl)		; $542c
	or a			; $542d
	jr z,@nextTarget	; $542e

	; Check it's visible
	ld l,Enemy.visible		; $5430
	bit 7,(hl)		; $5432
	jr z,@nextTarget	; $5434

	; Check it's a valid target (see data/bombchuTargets.s)
	ld l,Enemy.id		; $5436
	ld a,(hl)		; $5438
	push hl			; $5439
	ld hl,bombchuTargets		; $543a
	call checkFlag		; $543d
	pop hl			; $5440
	jr z,@nextTarget	; $5441

	; Check if it's within the bombchu's "collision radius" (actually used as vision
	; radius)
	call checkObjectsCollided		; $5443
	jr nc,@nextTarget	; $5446

	; Valid target established; set relatedObj2 to the target
	ld a,h			; $5448
	ld h,d			; $5449
	ld l,Item.relatedObj2+1		; $544a
	ldd (hl),a		; $544c
	ld (hl),Enemy.enabled		; $544d

	; Stop using collision radius as vision radius
	ld l,Item.collisionRadiusY		; $544f
	ld a,$06		; $5451
	ldi (hl),a		; $5453
	ld (hl),a		; $5454

	; Set counter1, speedTmp
	ld l,Item.counter1		; $5455
	ld (hl),$0c		; $5457
	ld l,Item.speedTmp		; $5459
	ld (hl),SPEED_1c0		; $545b

	; Increment state
	ld l,Item.state		; $545d
	inc (hl)		; $545f

	ld a,(wTilesetFlags)		; $5460
	and TILESETFLAG_SIDESCROLL			; $5463
	jr nz,+			; $5465

	call _bombchuUpdateAngle_topDown		; $5467
	xor a			; $546a
	ret			; $546b
+
	call _bombchuUpdateAngle_sidescrolling		; $546c
	xor a			; $546f
	ret			; $5470

@nextTarget:
	; Increment target enemy index by one
	inc h			; $5471
	ld a,h			; $5472
	cp LAST_ENEMY_INDEX+1			; $5473
	jr c,+			; $5475

	; Looped through all enemies
	call @incVisionRadius		; $5477
	ld a,FIRST_ENEMY_INDEX		; $547a
+
	ld e,Item.var30		; $547c
	ld (de),a		; $547e
	or d			; $547f
	ret			; $5480

@incVisionRadius:
	; Increase collisionRadiusY/X by increments of $10, but keep it below $70. (these
	; act as the bombchu's vision radius)
	ld e,Item.collisionRadiusY		; $5481
	ld a,(de)		; $5483
	add $10			; $5484
	cp $60			; $5486
	jr c,+			; $5488
	ld a,$18		; $548a
+
	ld (de),a		; $548c
	inc e			; $548d
	ld (de),a		; $548e
	ret			; $548f

.include "data/bombchuTargets.s"

;;
; ITEMID_BOMB
; @addr{54a0}
itemCode03:
	ld e,Item.var2f		; $54a0
	ld a,(de)		; $54a2
	bit 5,a			; $54a3
	jr nz,@label_07_153	; $54a5

	bit 7,a			; $54a7
	jp nz,_bombResetAnimationAndSetVisiblec1		; $54a9

	; Check if exploding
	bit 4,a			; $54ac
	jp nz,_bombUpdateExplosion		; $54ae

	ld e,Item.state		; $54b1
	ld a,(de)		; $54b3
	rst_jumpTable			; $54b4

	.dw @state0
	.dw @state1
	.dw @state2


; Not sure when this is executed. Causes the bomb to be deleted.
@label_07_153:
	ld h,d			; $54bb
	ld l,Item.state		; $54bc
	ldi a,(hl)		; $54be
	cp $02			; $54bf
	jr nz,+			; $54c1

	; Check bit 1 of Item.state2 (check if it's being held?)
	bit 1,(hl)		; $54c3
	call z,dropLinkHeldItem		; $54c5
+
	jp itemDelete		; $54c8

; State 1: bomb is motionless on the ground
@state1:
	ld c,$20		; $54cb
	call _bombUpdateThrowingVerticallyAndCheckDelete		; $54cd
	ret c			; $54d0

	; No idea what function is for
	call _bombPullTowardPoint		; $54d1
	jp c,itemDelete		; $54d4

	call _itemUpdateConveyorBelt		; $54d7
	jp _bombUpdateAnimation		; $54da

; State 0/2: bomb is being picked up / thrown around
@state0:
@state2:
	ld e,Item.state2		; $54dd
	ld a,(de)		; $54df
	rst_jumpTable			; $54e0

	.dw @heldState0
	.dw @heldState1
	.dw @heldState2
	.dw @heldState3


; Bomb just picked up
@heldState0:
	call itemIncState2		; $54e9

	ld l,Item.var2f		; $54ec
	set 6,(hl)		; $54ee

	ld l,Item.var37		; $54f0
	res 0,(hl)		; $54f2
	call _bombInitializeIfNeeded		; $54f4

; Bomb being held
@heldState1:
	; Bombs don't explode while being held if the peace ring is equipped
	ld a,PEACE_RING		; $54f7
	call cpActiveRing		; $54f9
	jp z,_bombResetAnimationAndSetVisiblec1		; $54fc

	call _bombUpdateAnimation		; $54ff
	ret z			; $5502

	; If z-flag was unset (bomb started exploding), release the item?
	jp dropLinkHeldItem		; $5503

; Bomb being thrown
@heldState2:
@heldState3:
	; Set state2 to $03
	ld a,$03		; $5506
	ld (de),a		; $5508

	; Update movement?
	call _bombUpdateThrowingLaterally		; $5509

	ld e,Item.var39		; $550c
	ld a,(de)		; $550e
	ld c,a			; $550f

	; Update throwing, return if the bomb was deleted from falling into a hazard
	call _bombUpdateThrowingVerticallyAndCheckDelete		; $5510
	ret c			; $5513

	; Jump if the item is not on the ground
	jr z,+			; $5514

	; If on the ground...
	call _itemBounce		; $5516
	jr c,@stoppedBouncing			; $5519

	; No idea what this function is for
	call _bombPullTowardPoint		; $551b
	jp c,itemDelete		; $551e
+
	jp _bombUpdateAnimation		; $5521

@stoppedBouncing:
	; Bomb goes to state 1 (motionless on the ground)
	ld h,d			; $5524
	ld l,Item.state		; $5525
	ld (hl),$01		; $5527

	ld l,Item.var2f		; $5529
	res 6,(hl)		; $552b

	jp _bombUpdateAnimation		; $552d

;;
; @param[out]	cflag	Set if the item was deleted
; @param[out]	zflag	Set if the bomb is not on the ground
; @addr{5530}
_bombUpdateThrowingVerticallyAndCheckDelete:
	push bc			; $5530
	ld a,(wTilesetFlags)		; $5531
	and TILESETFLAG_SIDESCROLL			; $5534
	jr z,+			; $5536

	; If in a sidescrolling area, allow Y values between $08-$f7?
	ld e,Item.yh		; $5538
	ld a,(de)		; $553a
	sub $08			; $553b
	cp $f0			; $553d
	ccf			; $553f
	jr c,++			; $5540
+
	call objectCheckWithinRoomBoundary		; $5542
++
	pop bc			; $5545
	jr nc,@delete		; $5546

	; Within the room boundary

	; Return if it hasn't landed in a hazard (hole/water/lava)
	call _itemUpdateThrowingVerticallyAndCheckHazards		; $5548
	ret nc			; $554b

	; Check if room $0050 (Present overworld, bomb upgrade screen)
	ld bc,$0050		; $554c
	ld a,(wActiveGroup)		; $554f
	cp b			; $5552
	jr nz,@delete		; $5553
	ld a,(wActiveRoom)		; $5555
	cp c			; $5558
	jr nz,@delete		; $5559

	; If so, trigger a cutscene?
	ld a,$01		; $555b
	ld (wTmpcfc0.bombUpgradeCutscene.state),a		; $555d

@delete:
	call itemDelete		; $5560
	scf			; $5563
	ret			; $5564

;;
; Update function for bombs and bombchus while they're exploding
;
; @addr{5565}
_itemUpdateExplosion:
	; animParameter specifies:
	;  Bits 0-4: collision radius
	;  Bit 6:    Zero out "collisionType" if set?
	;  Bit 7:    End of animation (delete self)
	ld h,d			; $5565
	ld l,Item.animParameter		; $5566
	ld a,(hl)		; $5568
	bit 7,a			; $5569
	jp nz,itemDelete		; $556b

	ld l,Item.collisionType		; $556e
	bit 6,a			; $5570
	jr z,+			; $5572
	ld (hl),$00		; $5574
+
	ld c,(hl)		; $5576
	ld l,Item.collisionRadiusY		; $5577
	and $1f			; $5579
	ldi (hl),a		; $557b
	ldi (hl),a		; $557c

	; If bit 7 of Item.collisionType is set, check for collision with Link
	bit 7,c			; $557d
	call nz,_explosionCheckAndApplyLinkCollision		; $557f

	ld h,d			; $5582
	ld l,Item.counter1		; $5583
	bit 7,(hl)		; $5585
	call z,_explosionTryToBreakNextTile		; $5587
	jp itemAnimate		; $558a

;;
; Bombs call each frame if bit 4 of Item.var2f is set.
;
; @addr{558d}
_bombUpdateExplosion:
	ld h,d			; $558d
	ld l,Item.state		; $558e
	ld a,(hl)		; $5590
	cp $ff			; $5591
	jr nz,_itemInitializeBombExplosion	; $5593
	jr _itemUpdateExplosion		; $5595

;;
; @param[out]	zflag	Set if the bomb isn't exploding (not sure if it gets unset on just
;			one frame, or all frames after the explosion starts)
; @addr{5597}
_bombUpdateAnimation:
	call itemAnimate		; $5597
	ld e,Item.animParameter		; $559a
	ld a,(de)		; $559c
	or a			; $559d
	ret z			; $559e

;;
; Initializes a bomb explosion?
;
; @param[out]	zflag
; @addr{559f}
_itemInitializeBombExplosion:
	ld h,d			; $559f
	ld l,Item.oamFlagsBackup		; $55a0
	ld a,$0a		; $55a2
	ldi (hl),a		; $55a4
	ldi (hl),a		; $55a5

	; Set Item.oamTileIndexBase
	ld (hl),$0c		; $55a6

	; Enable collisions
	ld l,Item.collisionType		; $55a8
	set 7,(hl)		; $55aa

	; Decrease damage if not using blast ring
	ld a,BLAST_RING		; $55ac
	call cpActiveRing		; $55ae
	jr nz,+			; $55b1
	ld l,Item.damage		; $55b3
	dec (hl)		; $55b5
	dec (hl)		; $55b6
+
	; State $ff means exploding
	ld l,Item.state		; $55b7
	ld (hl),$ff		; $55b9
	ld l,Item.counter1		; $55bb
	ld (hl),$08		; $55bd

	ld l,Item.var2f		; $55bf
	ld a,(hl)		; $55c1
	or $50			; $55c2
	ld (hl),a		; $55c4

	ld l,Item.id		; $55c5
	ldd a,(hl)		; $55c7

	; Reset bit 1 of Item.enabled
	res 1,(hl)		; $55c8

	; Check if this is a bomb, as opposed to a bombchu?
	cp ITEMID_BOMB			; $55ca
	ld a,$01		; $55cc
	jr z,+			; $55ce
	ld a,$06		; $55d0
+
	call itemSetAnimation		; $55d2
	call objectSetVisible80		; $55d5
	ld a,SND_EXPLOSION		; $55d8
	call playSound		; $55da
	or d			; $55dd
	ret			; $55de

;;
; @addr{55df}
_bombInitializeIfNeeded:
	ld h,d			; $55df
	ld l,Item.var37		; $55e0
	bit 7,(hl)		; $55e2
	ret nz			; $55e4

	set 7,(hl)		; $55e5
	call decNumBombs		; $55e7
	call _itemLoadAttributesAndGraphics		; $55ea
	call _itemMergeZPositionIfSidescrollingArea		; $55ed

;;
; @addr{55f0}
_bombResetAnimationAndSetVisiblec1:
	xor a			; $55f0
	call itemSetAnimation		; $55f1
	jp objectSetVisiblec1		; $55f4

;;
; Bombs call this to check for collision with Link and apply the damage.
;
; @addr{55f7}
_explosionCheckAndApplyLinkCollision:
	; Return if the bomb has already hit Link
	ld h,d			; $55f7
	ld l,Item.var37		; $55f8
	bit 6,(hl)		; $55fa
	ret nz			; $55fc

	ld a,(w1Companion.id)		; $55fd
	cp SPECIALOBJECTID_MINECART			; $5600
	ret z			; $5602

	ld a,BOMBPROOF_RING		; $5603
	call cpActiveRing		; $5605
	ret z			; $5608

	call checkLinkVulnerable		; $5609
	ret nc			; $560c

	; Check if close enough on the Z axis
	ld h,d			; $560d
	ld l,Item.collisionRadiusY		; $560e
	ld a,(hl)		; $5610
	ld c,a			; $5611
	add a			; $5612
	ld b,a			; $5613
	ld l,Item.zh		; $5614
	ld a,(w1Link.zh)		; $5616
	sub (hl)		; $5619
	add c			; $561a
	cp b			; $561b
	ret nc			; $561c

	call objectCheckCollidedWithLink_ignoreZ		; $561d
	ret nc			; $5620

	; Collision occurred; now give Link knockback, etc.

	call objectGetAngleTowardLink		; $5621

	; Set bit 6 to prevent double-hits?
	ld h,d			; $5624
	ld l,Item.var37		; $5625
	set 6,(hl)		; $5627

	ld l,Item.damage		; $5629
	ld c,(hl)		; $562b
	ld hl,w1Link.damageToApply		; $562c
	ld (hl),c		; $562f

	ld l,<w1Link.knockbackCounter		; $5630
	ld (hl),$0c		; $5632

	; knockbackAngle
	dec l			; $5634
	ldd (hl),a		; $5635

	; invincibilityCounter
	ld (hl),$10		; $5636

	; var2a
	dec l			; $5638
	ld (hl),$01		; $5639

	jp linkApplyDamage		; $563b

;;
; Checks whether nearby tiles should be blown up from the explosion.
;
; Each call checks one tile for deletion. After 9 calls, all spots will have been checked.
;
; @param	hl	Pointer to a counter (should count down from 8 to 0)
; @addr{563e}
_explosionTryToBreakNextTile:
	ld a,(hl)		; $563e
	dec (hl)		; $563f
	ld l,a			; $5640
	add a			; $5641
	add l			; $5642
	ld hl,@data		; $5643
	rst_addAToHl			; $5646

	; Verify Z position is close enough (for non-sidescrolling areas)
	ld a,(wTilesetFlags)		; $5647
	and TILESETFLAG_SIDESCROLL			; $564a
	ld e,Item.zh		; $564c
	ld a,(de)		; $564e
	jr nz,+			; $564f

	sub $02			; $5651
	cp (hl)			; $5653
	ret c			; $5654

	xor a			; $5655
+
	ld c,a			; $5656
	inc hl			; $5657
	ldi a,(hl)		; $5658
	add c			; $5659
	ld b,a			; $565a

	ld a,(hl)		; $565b
	ld c,a			; $565c

	; bc = offset to add to explosion's position

	; Get Y position of tile, return if out of bounds
	ld h,d			; $565d
	ld e,$00		; $565e
	bit 7,b			; $5660
	jr z,+			; $5662
	dec e			; $5664
+
	ld l,Item.yh		; $5665
	ldi a,(hl)		; $5667
	add b			; $5668
	ld b,a			; $5669
	ld a,$00		; $566a
	adc e			; $566c
	ret nz			; $566d

	; Get X position of tile, return if out of bounds
	inc l			; $566e
	ld e,$00		; $566f
	bit 7,c			; $5671
	jr z,+			; $5673
	dec e			; $5675
+
	ld a,(hl)		; $5676
	add c			; $5677
	ld c,a			; $5678
	ld a,$00		; $5679
	adc e			; $567b
	ret nz			; $567c

	ld a,BREAKABLETILESOURCE_04		; $567d
	jp tryToBreakTile		; $567f

; The following is a list of offsets from the center of the bomb at which to try
; destroying tiles.
;
; b0: necessary Z-axis proximity (lower is closer?)
; b1: offset from y-position
; b2: offset from x-position

@data:
	.db $f8 $f3 $f3
	.db $f8 $0c $f3
	.db $f8 $0c $0c
	.db $f8 $f3 $0c
	.db $f4 $00 $f3
	.db $f4 $0c $00
	.db $f4 $00 $0c
	.db $f4 $f3 $00
	.db $f2 $00 $00

;;
; ITEMID_BOOMERANG
; @addr{569d}
itemCode06:
	ld e,Item.state		; $569d
	ld a,(de)		; $569f
	rst_jumpTable			; $56a0

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call _itemLoadAttributesAndGraphics		; $56ab
	ld a,UNCMP_GFXH_18		; $56ae
	call loadWeaponGfx		; $56b0

	call itemIncState		; $56b3
	ld l,Item.speed		; $56b6
	ld (hl),SPEED_1a0		; $56b8

	ld l,Item.counter1		; $56ba
	ld (hl),$28		; $56bc

	ld c,-1		; $56be
	ld a,RANG_RING_L1		; $56c0
	call cpActiveRing		; $56c2
	jr z,+			; $56c5

	ld a,RANG_RING_L2		; $56c7
	call cpActiveRing		; $56c9
	jr nz,++		; $56cc
	ld c,-2		; $56ce
+
	; One of the rang rings are equipped; damage output increased (value of 'c')
	ld l,Item.damage		; $56d0
	ld a,(hl)		; $56d2
	add c			; $56d3
	ld (hl),a		; $56d4
++
	call objectSetVisible82		; $56d5
	xor a			; $56d8
	jp itemSetAnimation		; $56d9


; State 1: boomerang moving outward
@state1:
	ld e,Item.var2a		; $56dc
	ld a,(de)		; $56de
	or a			; $56df
	jr nz,@returnToLink	; $56e0

	call objectCheckTileCollision_allowHoles		; $56e2
	jr nc,@noCollision	; $56e5
	call _itemCheckCanPassSolidTile		; $56e7
	jr nz,@hitWall		; $56ea

@noCollision:
	call objectCheckWithinRoomBoundary		; $56ec
	jr nc,@returnToLink	; $56ef

	; Nudge angle toward a certain value. (Is this for the magical boomerang?)
	ld e,Item.var34		; $56f1
	ld a,(de)		; $56f3
	call objectNudgeAngleTowards		; $56f4

	; Decrement counter until boomerang must return
	call itemDecCounter1		; $56f7
	jr nz,@updateSpeedAndAnimation	; $56fa

; Decide on the angle to change to, then go to the next state
@returnToLink:
	call objectGetAngleTowardLink		; $56fc
	ld c,a			; $56ff

	; If the boomerang's Y or X has gone below 0 (above $f0), go directly to link?
	ld h,d			; $5700
	ld l,Item.yh		; $5701
	ld a,$f0		; $5703
	cp (hl)			; $5705
	jr c,@@setAngle		; $5706
	ld l,Item.xh		; $5708
	cp (hl)			; $570a
	jr c,@@setAngle		; $570b

	; If the boomerang is already moving in Link's general direction, don't bother
	; changing the angle?
	ld l,Item.angle		; $570d
	ld a,c			; $570f
	sub (hl)		; $5710
	add $08			; $5711
	cp $11			; $5713
	jr c,@nextState		; $5715

@@setAngle:
	ld l,Item.angle		; $5717
	ld (hl),c		; $5719
	jr @nextState		; $571a

@hitWall:
	call _objectCreateClinkInteraction		; $571c

	; Reverse direction
	ld h,d			; $571f
	ld l,Item.angle		; $5720
	ld a,(hl)		; $5722
	xor $10			; $5723
	ld (hl),a		; $5725

@nextState:
	ld l,Item.state		; $5726
	inc (hl)		; $5728

	; Clear link to parent item
	ld l,Item.relatedObj1		; $5729
	xor a			; $572b
	ldi (hl),a		; $572c
	ld (hl),a		; $572d

	jr @updateSpeedAndAnimation		; $572e


; State 2: boomerang returning to Link
@state2:
	call objectGetAngleTowardLink		; $5730
	call objectNudgeAngleTowards		; $5733

	; Increment state if within 10 pixels of Link
	ld bc,$140a		; $5736
	call _itemCheckWithinRangeOfLink		; $5739
	call c,itemIncState		; $573c

	jr @updateSpeedAndAnimation		; $573f


; State 3: boomerang within 10 pixels of link; move directly toward him instead of nudging
; the angle.
@state3:
	call objectGetAngleTowardLink		; $5741
	ld e,Item.angle		; $5744
	ld (de),a		; $5746

	; Check if within 2 pixels of Link
	ld bc,$0402		; $5747
	call _itemCheckWithinRangeOfLink		; $574a
	jr nc,@updateSpeedAndAnimation	; $574d

	; Go to state 4, make invisible, disable collisions
	call itemIncState		; $574f
	ld l,Item.counter1		; $5752
	ld (hl),$04		; $5754
	ld l,Item.collisionType		; $5756
	ld (hl),$00		; $5758
	jp objectSetInvisible		; $575a


; Stays in this state for 4 frames before deleting itself. I guess this creates a delay
; before the boomerang can be used again?
@state4:
	call itemDecCounter1		; $575d
	jp z,itemDelete		; $5760

	ld a,(wLinkObjectIndex)		; $5763
	ld h,a			; $5766
	ld l,SpecialObject.yh		; $5767
	jp objectTakePosition		; $5769


@updateSpeedAndAnimation:
	call objectApplySpeed		; $576c
	ld h,d			; $576f
	ld l,Item.animParameter		; $5770
	ld a,(hl)		; $5772
	or a			; $5773
	ld (hl),$00		; $5774

	; Play sound when animParameter is nonzero
	ld a,SND_BOOMERANG		; $5776
	call nz,playSound		; $5778

	jp itemAnimate		; $577b

;;
; Assumes that both objects are of the same size (checks top-left positions)
;
; @param	b	Should be double the value of c
; @param	c	Range to be within
; @param[out]	cflag	Set if within specified range of link
; @addr{577e}
_itemCheckWithinRangeOfLink:
	ld hl,w1Link.yh		; $577e
	ld e,Item.yh		; $5781
	ld a,(de)		; $5783
	sub (hl)		; $5784
	add c			; $5785
	cp b			; $5786
	ret nc			; $5787

	ld l,<w1Link.xh		; $5788
	ld e,Item.xh		; $578a
	ld a,(de)		; $578c
	sub (hl)		; $578d
	add c			; $578e
	cp b			; $578f
	ret			; $5790

;;
; The chain on the switch hook; cycles between 3 intermediate positions
;
; ITEMID_SWITCH_HOOK_CHAIN
; @addr{5791}
itemCode0bPost:
	ld a,(w1WeaponItem.id)		; $5791
	cp ITEMID_SWITCH_HOOK			; $5794
	jp nz,itemDelete		; $5796

	ld a,(w1WeaponItem.var2f)		; $5799
	bit 4,a			; $579c
	jp nz,itemDelete		; $579e

	; Copy Z position
	ld h,d			; $57a1
	ld a,(w1WeaponItem.zh)		; $57a2
	ld l,Item.zh		; $57a5
	ld (hl),a		; $57a7

	; Cycle through the 3 positions
	ld l,Item.counter1		; $57a8
	dec (hl)		; $57aa
	jr nz,+			; $57ab
	ld (hl),$03		; $57ad
+
	ld e,(hl)		; $57af

	; Set Y position
	push de			; $57b0
	ld b,$03		; $57b1
	ld hl,w1WeaponItem.yh		; $57b3
	call @setPositionComponent		; $57b6

	; Set X position
	pop de			; $57b9
	ld b,$00		; $57ba
	ld hl,w1WeaponItem.xh		; $57bc

; @param	b	Offset to add to position
; @param	e	Index, or which position to place this at (1-3)
; @param	hl	X or Y position variable
@setPositionComponent:
	ld a,(hl)		; $57bf
	cp $f8			; $57c0
	jr c,+			; $57c2
	xor a			; $57c4
+
	; Calculate: c = ([Switch hook pos] - [Link pos]) / 4
	ld h,>w1Link		; $57c5
	sub (hl)		; $57c7
	ld c,a			; $57c8
	ld a,$00		; $57c9
	sbc a			; $57cb
	rra			; $57cc
	rr c			; $57cd
	rra			; $57cf
	rr c			; $57d0

	; Calculate: a = c * e
	xor a			; $57d2
-
	add c			; $57d3
	dec e			; $57d4
	jr nz,-			; $57d5

	; Add this to the current position (plus offset 'b')
	add (hl)		; $57d7
	add b			; $57d8
	ld h,d			; $57d9
	ldi (hl),a		; $57da
	ret			; $57db

;;
; ITEMID_SWITCH_HOOK_CHAIN
; @addr{57dc}
itemCode0b:
	ld e,Item.state		; $57dc
	ld a,(de)		; $57de
	or a			; $57df
	ret nz			; $57e0

	call _itemLoadAttributesAndGraphics		; $57e1
	call itemIncState		; $57e4
	ld l,Item.counter1		; $57e7
	ld (hl),$03		; $57e9
	xor a			; $57eb
	call itemSetAnimation		; $57ec
	jp objectSetVisible83		; $57ef

;;
; ITEMID_SWITCH_HOOK
; @addr{57f2}
itemCode0aPost:
	call _cpRelatedObject1ID		; $57f2
	ret z			; $57f5

	ld a,(wSwitchHookState)		; $57f6
	or a			; $57f9
	jp z,itemDelete		; $57fa

	jp _func_5902		; $57fd

;;
; ITEMID_SWITCH_HOOK
; @addr{5800}
itemCode0a:
	ld a,$08		; $5800
	ld (wDisableRingTransformations),a		; $5802
	ld a,$80		; $5805
	ld (wcc92),a		; $5807
	ld e,Item.state		; $580a
	ld a,(de)		; $580c
	rst_jumpTable			; $580d
	.dw @state0
	.dw @state1
	.dw @state2
	.dw _switchHookState3

@state0:
	ld a,UNCMP_GFXH_1f		; $5816
	call loadWeaponGfx		; $5818

	ld hl,@offsetsTable		; $581b
	call _applyOffsetTableHL		; $581e

	call objectSetVisible82		; $5821
	call _loadAttributesAndGraphicsAndIncState		; $5824

	; Depending on the switch hook's level, set speed (b) and # frames to extend (c)
	ldbc SPEED_200,$29		; $5827
	ld a,(wSwitchHookLevel)		; $582a
	dec a			; $582d
	jr z,+			; $582e
	ldbc SPEED_300,$26		; $5830
+
	ld h,d			; $5833
	ld l,Item.speed		; $5834
	ld (hl),b		; $5836
	ld l,Item.counter1		; $5837
	ld (hl),c		; $5839

	ld l,Item.var2f		; $583a
	ld (hl),$01		; $583c
	call itemUpdateAngle		; $583e

	; Set animation based on Item.direction
	ld a,(hl)		; $5841
	add $02			; $5842
	jp itemSetAnimation		; $5844

; Offsets to make the switch hook centered with link
@offsetsTable:
	.db $01 $00 $00 ; DIR_UP
	.db $03 $01 $00 ; DIR_RIGHT
	.db $01 $00 $00 ; DIR_DOWN
	.db $03 $ff $00 ; DIR_LEFT

; State 1: extending the hook
@state1:
	; When var2a is nonzero, a collision has occured?
	ld e,Item.var2a		; $5853
	ld a,(de)		; $5855
	or a			; $5856
	jr z,+			; $5857

	; If bit 5 is set, the switch hook can exchange with the object
	bit 5,a			; $5859
	jr nz,@goToState3	; $585b

	; Otherwise, it will be pulled back
	jr @startRetracting		; $585d
+
	; Cancel the switch hook when you take damage
	ld h,d			; $585f
	ld l,Item.var2f		; $5860
	bit 5,(hl)		; $5862
	jp nz,itemDelete		; $5864

	call itemDecCounter1		; $5867
	jr z,@startRetracting	; $586a

	call objectCheckWithinRoomBoundary		; $586c
	jr nc,@startRetracting	; $586f

	; Check if collided with a tile
	call objectCheckTileCollision_allowHoles		; $5871
	jr nc,@noCollisionWithTile	; $5874

	; There is a collision, but check for exceptions (tiles that items can pass by)
	call _itemCheckCanPassSolidTile		; $5876
	jr nz,@collisionWithTile	; $5879

@noCollisionWithTile:
	; Bit 3 of var2f remembers whether a "chain" item has been created
	ld e,Item.var2f		; $587b
	ld a,(de)		; $587d
	bit 3,a			; $587e
	jr nz,++		; $5880

	call getFreeItemSlot		; $5882
	jr nz,++		; $5885

	inc a			; $5887
	ldi (hl),a		; $5888
	ld (hl),ITEMID_SWITCH_HOOK_CHAIN		; $5889

	; Remember to not create the item again
	ld h,d			; $588b
	ld l,Item.var2f		; $588c
	set 3,(hl)		; $588e
++
	call _updateSwitchHookSound		; $5890
	jp objectApplySpeed		; $5893

@collisionWithTile:
	call _objectCreateClinkInteraction		; $5896

	; Check if the tile is breakable (oring with $80 makes it perform only a check,
	; not the breakage itself).
	ld a,$80 | BREAKABLETILESOURCE_SWITCH_HOOK		; $5899
	call itemTryToBreakTile		; $589b
	; Retract if not breakable by the switch hook
	jr nc,@startRetracting	; $589e

	; Hooked onto a tile that can be swapped with
	ld e,Item.subid		; $58a0
	ld a,$01		; $58a2
	ld (de),a		; $58a4

@goToState3:
	ld a,$03		; $58a5
	call itemSetState		; $58a7

	; Disable collisions with objects?
	ld l,Item.collisionType		; $58aa
	res 7,(hl)		; $58ac

	ld a,$ff		; $58ae
	ld (wDisableLinkCollisionsAndMenu),a		; $58b0

	ld a,$01		; $58b3
	ld (wSwitchHookState),a		; $58b5

	jp resetLinkInvincibility		; $58b8

@label_07_185:
	xor a			; $58bb
	ld (wDisableLinkCollisionsAndMenu),a		; $58bc
	ld (wSwitchHookState),a		; $58bf

@startRetracting:
	ld h,d			; $58c2

	; Disable collisions with objects?
	ld l,Item.collisionType		; $58c3
	res 7,(hl)		; $58c5

	ld a,$02		; $58c7
	jp itemSetState		; $58c9

; State 2: retracting the hook
@state2:
	ld e,Item.state2		; $58cc
	ld a,(de)		; $58ce
	or a			; $58cf
	jr nz,@fullyRetracted		; $58d0

	; The counter is just for keeping track of the sound?
	call itemDecCounter1		; $58d2
	call _updateSwitchHookSound		; $58d5

	; Update angle based on position of link
	call objectGetAngleTowardLink		; $58d8
	ld e,Item.angle		; $58db
	ld (de),a		; $58dd

	call objectApplySpeed		; $58de

	; Check if within 8 pixels of link
	ld bc,$1008		; $58e1
	call _itemCheckWithinRangeOfLink		; $58e4
	ret nc			; $58e7

	; Item has reached Link

	call itemIncState2		; $58e8

	; Set Item.counter1 to $03
	inc l			; $58eb
	ld (hl),$03		; $58ec

	ld l,Item.var2f		; $58ee
	set 4,(hl)		; $58f0
	jp objectSetInvisible		; $58f2

@fullyRetracted:
	ld hl,w1Link.yh		; $58f5
	call objectTakePosition		; $58f8
	call itemDecCounter1		; $58fb
	ret nz			; $58fe
	jp itemDelete		; $58ff

;;
; Swap with an object?
; @addr{5902}
_func_5902:
	call _checkRelatedObject2States		; $5902
	jr nc,++		; $5905
	jr z,++			; $5907

	ld a,Object.state2		; $5909
	call objectGetRelatedObject2Var		; $590b
	ld (hl),$03		; $590e
++
	xor a			; $5910
	ld (wDisableLinkCollisionsAndMenu),a		; $5911
	ld (wSwitchHookState),a		; $5914
	jp itemDelete		; $5917

; State 3: grabbed something switchable
; Uses w1ReservedItemE as ITEMID_SWITCH_HOOK_HELPER to hold the positions for link and the
; object temporarily.
_switchHookState3:
	ld e,Item.state2		; $591a
	ld a,(de)		; $591c
	rst_jumpTable			; $591d
	.dw @s3subState0
	.dw @s3subState1
	.dw @s3subState2
	.dw @s3subState3

; Substate 0: grabbed an object/tile, doing the cling animation for several frames
@s3subState0:
	ld h,d			; $5926

	; Check if deletion was requested?
	ld l,Item.var2f		; $5927
	bit 5,(hl)		; $5929
	jp nz,_func_5902		; $592b

	; Wait until the animation writes bit 7 to animParameter
	ld l,Item.animParameter		; $592e
	bit 7,(hl)		; $5930
	jp z,itemAnimate		; $5932

	; At this point the animation is finished, now link and the hooked object/tile
	; will rise and swap

	call _checkRelatedObject2States		; $5935
	jr nc,itemCode0a@label_07_185	; $5938
	; Jump if an object collision, not a tile collision
	jr nz,@@objectCollision		; $593a

	; Tile collision

	; Break the tile underneath whatever was latched on to
	ld a,BREAKABLETILESOURCE_SWITCH_HOOK		; $593c
	call itemTryToBreakTile		; $593e
	jp nc,itemCode0a@label_07_185		; $5941

	ld h,d			; $5944
	ld l,Item.var03		; $5945
	ldh a,(<hFF8E)	; $5947
	ld (hl),a		; $5949

	ld l,Item.var3c		; $594a
	ldh a,(<hFF93)	; $594c
	ldi (hl),a		; $594e
	ldh a,(<hFF92)	; $594f
	ld (hl),a		; $5951

	; Imitate the tile that was grabbed
	call _itemMimicBgTile		; $5952

	ld h,d			; $5955
	ld l,Item.var3c		; $5956
	ld c,(hl)		; $5958
	call objectSetShortPosition		; $5959
	call objectSetVisiblec2		; $595c
	jr +++			; $595f

@@objectCollision:
	ld a,(w1ReservedInteraction1.id)		; $5961
	cp INTERACID_PUSHBLOCK			; $5964
	jr z,++			; $5966

	; Get the object being switched with's yx in bc
	ld a,Object.yh		; $5968
	call objectGetRelatedObject2Var		; $596a
	ldi a,(hl)		; $596d
	inc l			; $596e
	ld c,(hl)		; $596f
	ld b,a			; $5970

	callab bank5.checkPositionSurroundedByWalls		; $5971
	rl b			; $5979
	jr c,++			; $597b

	ld a,Object.yh		; $597d
	call objectGetRelatedObject2Var		; $597f
	call objectTakePosition		; $5982
	call objectSetInvisible		; $5985
+++
	ld a,$02		; $5988
	ld (wSwitchHookState),a		; $598a
.ifdef ROM_AGES
	ld a,SND_SWITCH2		; $598d
.else
	ld a,$8e
.endif
	call playSound		; $598f

	call itemIncState2		; $5992

	ld l,Item.zh		; $5995
	ld (hl),$00		; $5997
	ld l,Item.var2f		; $5999
	set 1,(hl)		; $599b

	; Use w1ReservedItemE to keep copies of xyz positions
	ld hl,w1ReservedItemE		; $599d
	ld a,$01		; $59a0
	ldi (hl),a		; $59a2
	ld (hl),ITEMID_SWITCH_HOOK_HELPER		; $59a3

	; Zero Item.state and Item.state2
	ld l,Item.state		; $59a5
	xor a			; $59a7
	ldi (hl),a		; $59a8
	ldi (hl),a		; $59a9

	call objectCopyPosition		; $59aa
	jp resetLinkInvincibility		; $59ad
++
	ld a,Object.state2		; $59b0
	call objectGetRelatedObject2Var		; $59b2
	ld (hl),$03		; $59b5
	jp itemCode0a@label_07_185		; $59b7


; Substate 1: Link and the object are rising for several frames
@s3subState1:
	ld h,d			; $59ba
	ld l,Item.zh		; $59bb
	dec (hl)		; $59bd
	ld a,(hl)		; $59be
	cp $f1			; $59bf
	call c,itemIncState2		; $59c1
	jr @updateOtherPositions		; $59c4

; Substate 2: Link and the object swap positions
@s3subState2:
	push de			; $59c6

	; Swap Link and Hook's xyz (at least, the copies in w1ReservedItemE)
	ld hl,w1ReservedItemE.var36		; $59c7
	ld de,w1ReservedItemE.var30		; $59ca
	ld b,$06		; $59cd
--
	ld a,(de)		; $59cf
	ld c,(hl)		; $59d0
	ldi (hl),a		; $59d1
	ld a,c			; $59d2
	ld (de),a		; $59d3
	inc e			; $59d4
	dec b			; $59d5
	jr nz,--		; $59d6

	pop de			; $59d8
	ld e,Item.subid		; $59d9
	ld a,(de)		; $59db
	or a			; $59dc
	; Jump if hooked an object, and not a tile
	jr z,@doneCentering	; $59dd

	; Everything from here to @doneCentering involves centering the hooked tile at
	; link's position.

	ld a,(w1Link.direction)		; $59df
	; a *= 3
	ld l,a			; $59e2
	add a			; $59e3
	add l			; $59e4

	ld hl,itemCode0a@offsetsTable		; $59e5
	rst_addAToHl			; $59e8

	push de			; $59e9
	ld de,w1ReservedItemE.var31		; $59ea
	ld a,(de)		; $59ed
	add (hl)		; $59ee
	ld (de),a		; $59ef

	inc hl			; $59f0
	ld e,<w1ReservedItemE.var33		; $59f1
	ld a,(de)		; $59f3
	add (hl)		; $59f4
	ld (de),a		; $59f5

	ld e,<w1ReservedItemE.var31		; $59f6
	call getShortPositionFromDE		; $59f8
	pop de			; $59fb
	ld l,a			; $59fc
	call _checkCanPlaceDiamondOnTile		; $59fd
	jr z,++			; $5a00

	ld e,l			; $5a02
	ld a,(w1Link.direction)		; $5a03
	ld bc,@data		; $5a06
	call addAToBc		; $5a09
	ld a,(bc)		; $5a0c
	rst_addAToHl			; $5a0d
	call _checkCanPlaceDiamondOnTile		; $5a0e
	jr z,++			; $5a11
	ld l,e			; $5a13
++
	ld c,l			; $5a14
	ld hl,w1ReservedItemE.var31		; $5a15
	call setShortPosition_paramC		; $5a18

@doneCentering:
	ld e,Item.y		; $5a1b
	ld hl,w1ReservedItemE.var30		; $5a1d
	ld b,$04		; $5a20
	call copyMemory		; $5a22

	; Reverse link's direction
	ld hl,w1Link.direction		; $5a25
	ld a,(hl)		; $5a28
	xor $02			; $5a29
	ld (hl),a		; $5a2b

	call itemIncState2		; $5a2c
	call _checkRelatedObject2States		; $5a2f
	jr nc,+			; $5a32
	jr z,+			; $5a34
	ld (hl),$02		; $5a36
+
	jr @updateOtherPositions			; $5a38

@data:
	.db $10 $ff $f0 $01

; Update the positions (mainly z positions) for Link and the object being hooked.
@updateOtherPositions:
	; Update other object position if hooked to an enemy
	call _checkRelatedObject2States		; $5a3e
	call nz,objectCopyPosition		; $5a41

	; Update the Z position that w1ReservedItemE is keeping track of
	push de			; $5a44
	ld e,Item.zh		; $5a45
	ld a,(de)		; $5a47
	ld de,w1ReservedItemE.var3b		; $5a48
	ld (de),a		; $5a4b

	; Update link's position
	ld hl,w1Link.y		; $5a4c
	ld e,<w1ReservedItemE.var36		; $5a4f
	ld b,$06		; $5a51
	call copyMemoryReverse		; $5a53
	pop de			; $5a56
	ret			; $5a57

; Substate 3: Link and the other object are moving back to the ground
@s3subState3:
	ld h,d			; $5a58

	; Lower 1 pixel
	ld l,Item.zh		; $5a59
	inc (hl)		; $5a5b
	call @updateOtherPositions		; $5a5c

	; Return if link and the item haven't reached the ground yet
	ld e,Item.zh		; $5a5f
	ld a,(de)		; $5a61
	or a			; $5a62
	ret nz			; $5a63

	call _checkRelatedObject2States		; $5a64
	jr nz,@reenableEnemy		; $5a67

	; For tile collisions, check whether to make the interaction which shows it
	; breaking, or whether to keep the switch hook diamond there

	call objectGetTileCollisions		; $5a69
	call _checkCanPlaceDiamondOnTile		; $5a6c
	jr nz,+			; $5a6f

	; If the current block is the switch diamond, do NOT break it
	ld c,l			; $5a71
	ld e,Item.var3d		; $5a72
	ld a,(de)		; $5a74
	cp TILEINDEX_SWITCH_DIAMOND			; $5a75
	jr nz,+			; $5a77

	call setTile		; $5a79
	jr @delete			; $5a7c
+
	; Create the bush/pot/etc breakage animation (based on var03)
	callab bank6.itemMakeInteractionForBreakableTile		; $5a7e
	jr @delete		; $5a86

@reenableEnemy:
	ld (hl),$03		; $5a88
@delete:
	xor a			; $5a8a
	ld (wSwitchHookState),a		; $5a8b
	ld (wDisableLinkCollisionsAndMenu),a		; $5a8e
	jp itemDelete		; $5a91

;;
; This function is used for the switch hook.
;
; @param[out]	hl	Related object 2's state2 variable
; @param[out]	zflag	Set if latched onto a tile, not an object
; @param[out]	cflag	Unset if the related object is on state 3, substate 3?
; @addr{5a94}
_checkRelatedObject2States:
	; Jump if latched onto a tile, not an object
	ld e,Item.subid		; $5a94
	ld a,(de)		; $5a96
	dec a			; $5a97
	jr z,++			; $5a98

	; It might be assuming that there aren't any states above $03, so the carry flag
	; will always be set when returning here?
	ld a,Object.state		; $5a9a
	call objectGetRelatedObject2Var		; $5a9c
	ldi a,(hl)		; $5a9f
	cp $03			; $5aa0
	ret nz			; $5aa2

	ld a,(hl)		; $5aa3
	cp $03			; $5aa4
	ret nc			; $5aa6

	or d			; $5aa7
++
	scf			; $5aa8
	ret			; $5aa9

;;
; Plays the switch hook sound every 4 frames.
; @addr{5aaa}
_updateSwitchHookSound:
	ld e,Item.counter1		; $5aaa
	ld a,(de)		; $5aac
	and $03			; $5aad
	ret z			; $5aaf

	ld a,SND_SWITCH_HOOK		; $5ab0
	jp playSound		; $5ab2

;;
; @param l Position to check
; @param[out] zflag Set if the tile at l has a collision value of 0 (or is the somaria
; block?)
; @addr{5ab5}
_checkCanPlaceDiamondOnTile:
	ld h,>wRoomCollisions		; $5ab5
	ld a,(hl)		; $5ab7
	or a			; $5ab8
	ret z			; $5ab9
	ld h,>wRoomLayout		; $5aba
	ld a,(hl)		; $5abc
	cp TILEINDEX_SOMARIA_BLOCK			; $5abd
	ret			; $5abf


;;
; ITEMID_SWITCH_HOOK_HELPER
; Used with the switch hook in w1ReservedItemE to store position values.
; @addr{5ac0}
itemCode09:
	ld h,d			; $5ac0
	ld l,Item.var2f		; $5ac1
	bit 5,(hl)		; $5ac3
	jr nz,@state2		; $5ac5

	ld e,Item.state		; $5ac7
	ld a,(de)		; $5ac9
	rst_jumpTable			; $5aca
	.dw @state0
	.dw @state1
	.dw @state2

; Initialization (initial copying of positions)
@state0:
	call itemIncState		; $5ad1
	ld h,d			; $5ad4

	; Copy from Item.y to Item.var30
	ld l,Item.y		; $5ad5
	ld e,Item.var30		; $5ad7
	ld b,$06		; $5ad9
	call copyMemory		; $5adb

	; Copy from w1Link.y to Item.var36
	ld hl,w1Link.y		; $5ade
	ld b,$06		; $5ae1
	call copyMemory		; $5ae3

	; Set the focused object to this
	jp setCameraFocusedObject		; $5ae6

; State 1: do nothing until the switch hook is no longer in use, then delete self
@state1:
	ld a,(w1WeaponItem.id)		; $5ae9
	cp ITEMID_SWITCH_HOOK			; $5aec
	ret z			; $5aee

; State 2: Restore camera to focusing on Link and delete self
@state2:
	call setCameraFocusedObjectToLink		; $5aef
	jp itemDelete		; $5af2

;;
; Unused?
; @addr{5af5}
_func_5af5:
	ld hl,w1ReservedItemE		; $5af5
	bit 0,(hl)		; $5af8
	ret z			; $5afa
	ld l,Item.var2f		; $5afb
	set 5,(hl)		; $5afd
	ret			; $5aff

;;
; ITEMID_RICKY_TORNADO
; @addr{5b00}
itemCode2a:
	ld e,Item.state		; $5b00
	ld a,(de)		; $5b02
	rst_jumpTable			; $5b03

	.dw @state0
	.dw @state1


; State 0: initialization
@state0:
	call itemIncState		; $5b08
	ld l,Item.speed		; $5b0b
	ld (hl),SPEED_300		; $5b0d

	ld a,(w1Companion.direction)		; $5b0f
	ld c,a			; $5b12
	swap a			; $5b13
	rrca			; $5b15
	ld l,Item.angle		; $5b16
	ld (hl),a		; $5b18

	; Get offset from companion position to spawn at in 'bc'
	ld a,c			; $5b19
	ld hl,@offsets		; $5b1a
	rst_addDoubleIndex			; $5b1d
	ldi a,(hl)		; $5b1e
	ld c,(hl)		; $5b1f
	ld b,a			; $5b20

	; Copy companion's position
	ld hl,w1Companion.yh		; $5b21
	call objectTakePositionWithOffset		; $5b24

	; Make Z position 2 higher than companion
	sub $02			; $5b27
	ld (de),a		; $5b29

	call _itemLoadAttributesAndGraphics		; $5b2a
	xor a			; $5b2d
	call itemSetAnimation		; $5b2e
	jp objectSetVisiblec1		; $5b31

@offsets:
	.db $f0 $00 ; DIR_UP
	.db $00 $0c ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f4 ; DIR_LEFT


; State 1: flying away until it hits something
@state1:
	call objectApplySpeed		; $5b3c

	ld a,BREAKABLETILESOURCE_SWORD_L1		; $5b3f
	call itemTryToBreakTile		; $5b41

	call objectGetTileCollisions		; $5b44
	and $0f			; $5b47
	cp $0f			; $5b49
	jp z,itemDelete		; $5b4b

	jp itemAnimate		; $5b4e


;;
; ITEMID_SHOOTER
; ITEMID_29
;
; @addr{5b51}
itemCode0f:
itemCode29:
	ld e,Item.state		; $5b51
	ld a,(de)		; $5b53
	rst_jumpTable			; $5b54
	.dw @state0
	.dw @state1

@state0:
	ld a,UNCMP_GFXH_1d		; $5b59
	call loadWeaponGfx		; $5b5b
	call _loadAttributesAndGraphicsAndIncState		; $5b5e
	ld e,Item.var30		; $5b61
	ld a,$ff		; $5b63
	ld (de),a		; $5b65
	jp objectSetVisible81		; $5b66

@state1:
	ret			; $5b69


;;
; ITEMID_SHOOTER
; @addr{5b6a}
itemCode0fPost:
	call _cpRelatedObject1ID		; $5b6a
	jp nz,itemDelete		; $5b6d

	ld hl,@data		; $5b70
	call _itemInitializeFromLinkPosition		; $5b73

	; Copy link Z position
	ld h,d			; $5b76
	ld a,(w1Link.zh)		; $5b77
	ld l,Item.zh		; $5b7a
	ld (hl),a		; $5b7c

	; Check if angle has changed
	ld l,Item.var30		; $5b7d
	ld a,(w1ParentItem2.angle)		; $5b7f
	cp (hl)			; $5b82
	ld (hl),a		; $5b83
	ret z			; $5b84
	jp itemSetAnimation		; $5b85


; b0/b1: collisionRadiusY/X
; b2/b3: Y/X offsets relative to Link
@data:
	.db $00 $00 $00 $00


;;
; ITEMID_28 (ricky/moosh attack?)
;
; @addr{5b8c}
itemCode28:
	ld e,Item.state		; $5b8c
	ld a,(de)		; $5b8e
	or a			; $5b8f
	jr nz,+			; $5b90

	; Initialization
	call itemIncState		; $5b92
	ld l,Item.counter1		; $5b95
	ld (hl),$14		; $5b97
	call _itemLoadAttributesAndGraphics		; $5b99
	jr @calculatePosition			; $5b9c
+
	call @calculatePosition		; $5b9e
	call @tryToBreakTiles		; $5ba1
	call itemDecCounter1		; $5ba4
	ret nz			; $5ba7
	jp itemDelete		; $5ba8

@calculatePosition:
	ld a,(w1Companion.id)		; $5bab
	cp SPECIALOBJECTID_RICKY			; $5bae
	ld hl,@mooshData		; $5bb0
	jr nz,+			; $5bb3

	ld a,(w1Companion.direction)		; $5bb5
	add a			; $5bb8
	ld hl,@rickyData		; $5bb9
	rst_addDoubleIndex			; $5bbc
+
	jp _itemInitializeFromLinkPosition		; $5bbd


; b0/b1: collisionRadiusY/X
; b2/b3: Y/X offsets from Link's position

@rickyData:
	.db $10 $0c $f4 $00 ; DIR_UP
	.db $0c $12 $fe $08 ; DIR_RIGHT
	.db $10 $0c $08 $00 ; DIR_DOWN
	.db $0c $12 $fe $f8 ; DIR_LEFT

@mooshData:
	.db $18 $18 $10 $00


@tryToBreakTiles:
	ld hl,@rickyBreakableTileOffsets		; $5bd4
	ld a,(w1Companion.id)		; $5bd7
	cp SPECIALOBJECTID_RICKY			; $5bda
	jr z,@nextTile			; $5bdc
	ld hl,@mooshBreakableTileOffsets		; $5bde

@nextTile:
	; Get item Y/X + offset in bc
	ld e,Item.yh		; $5be1
	ld a,(de)		; $5be3
	add (hl)		; $5be4
	ld b,a			; $5be5
	inc hl			; $5be6
	ld e,Item.xh		; $5be7
	ld a,(de)		; $5be9
	add (hl)		; $5bea
	ld c,a			; $5beb

	inc hl			; $5bec
	push hl			; $5bed
	ld a,(w1Companion.id)		; $5bee
	cp SPECIALOBJECTID_RICKY			; $5bf1
	ld a,BREAKABLETILESOURCE_0f		; $5bf3
	jr z,+			; $5bf5
	ld a,BREAKABLETILESOURCE_11		; $5bf7
+
	call tryToBreakTile		; $5bf9
	pop hl			; $5bfc
	ld a,(hl)		; $5bfd
	cp $ff			; $5bfe
	jr nz,@nextTile		; $5c00
	ret			; $5c02


; List of offsets from this object's position to try breaking tiles at

@rickyBreakableTileOffsets:
	.db $f8 $08
	.db $f8 $f8
	.db $08 $08
	.db $08 $f8
	.db $ff

@mooshBreakableTileOffsets:
	.db $00 $00
	.db $f0 $f0
	.db $f0 $00
	.db $f0 $10
	.db $00 $f0
	.db $00 $10
	.db $10 $f0
	.db $10 $00
	.db $10 $10
	.db $ff


;;
; ITEMID_SHOVEL
; @addr{5c1f}
itemCode15:
	ld e,Item.state		; $5c1f
	ld a,(de)		; $5c21
	or a			; $5c22
	jr nz,@state1		; $5c23

	; Initialization (state 0)

	call _itemLoadAttributesAndGraphics		; $5c25
	call itemIncState		; $5c28
	ld l,Item.counter1		; $5c2b
	ld (hl),$04		; $5c2d

	ld a,BREAKABLETILESOURCE_06		; $5c2f
	call itemTryToBreakTile		; $5c31
	ld a,SND_CLINK		; $5c34
	jr nc,+			; $5c36

	; Dig succeeded
	ld a,$01		; $5c38
	call addToGashaMaturity		; $5c3a
	ld a,SND_DIG		; $5c3d
+
	jp playSound		; $5c3f

; State 1: does nothing for 4 frames?
@state1:
	call itemDecCounter1		; $5c42
	ret nz			; $5c45
	jp itemDelete		; $5c46


;;
; ITEMID_CANE_OF_SOMARIA
; @addr{5c49}
itemCode04:
	call _itemTransferKnockbackToLink		; $5c49
	ld e,Item.state		; $5c4c
	ld a,(de)		; $5c4e
	rst_jumpTable			; $5c4f

	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,UNCMP_GFXH_1c		; $5c56
	call loadWeaponGfx		; $5c58
	call _loadAttributesAndGraphicsAndIncState		; $5c5b

	ld a,SND_SWORDSLASH		; $5c5e
	call playSound		; $5c60

	xor a			; $5c63
	call itemSetAnimation		; $5c64
	jp objectSetVisible82		; $5c67

@state1:
	; Wait for a particular part of the swing animation
	ld a,(w1ParentItem2.animParameter)		; $5c6a
	cp $06			; $5c6d
	ret nz			; $5c6f

	call itemIncState		; $5c70

	ld c,ITEMID_18		; $5c73
	call findItemWithID		; $5c75
	jr nz,+			; $5c78

	; Set var2f of any previous instance of ITEMID_18 (triggers deletion?)
	ld l,Item.var2f		; $5c7a
	set 5,(hl)		; $5c7c
+
	; Get in bc the place to try to make a block
	ld a,(w1Link.direction)		; $5c7e
	ld hl,@somariaCreationOffsets		; $5c81
	rst_addDoubleIndex			; $5c84
	ld a,(w1Link.yh)		; $5c85
	add (hl)		; $5c88
	ld b,a			; $5c89
	inc hl			; $5c8a
	ld a,(w1Link.xh)		; $5c8b
	add (hl)		; $5c8e
	ld c,a			; $5c8f

	call getFreeItemSlot		; $5c90
	ret nz			; $5c93
	inc (hl)		; $5c94
	inc l			; $5c95
	ld (hl),ITEMID_18		; $5c96

	; Set Y/X of the new item as calculated earlier, and copy Link's Z position
	ld l,Item.yh		; $5c98
	ld (hl),b		; $5c9a
	ld a,(w1Link.zh)		; $5c9b
	ld l,Item.zh		; $5c9e
	ldd (hl),a		; $5ca0
	dec l			; $5ca1
	ld (hl),c		; $5ca2

@state2:
	ret			; $5ca3

; Offsets relative to link's position to try to create a somaria block?
@somariaCreationOffsets:
	.dw $00ec ; DIR_UP
	.dw $1300 ; DIR_RIGHT
	.dw $0013 ; DIR_DOWN
	.dw $ec00 ; DIR_LEFT


;;
; ITEMID_18 (somaria block object)
; @addr{5cac}
itemCode18:
	ld e,Item.state		; $5cac
	ld a,(de)		; $5cae
	rst_jumpTable			; $5caf

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4


; State 0: initialization
@state0:
	call _itemMergeZPositionIfSidescrollingArea		; $5cba
	call @alignOnTile		; $5cbd
	call _itemLoadAttributesAndGraphics		; $5cc0
	xor a			; $5cc3
	call itemSetAnimation		; $5cc4
	call itemIncState		; $5cc7
	ld a,SND_MYSTERY_SEED		; $5cca
	call playSound		; $5ccc
	jp objectSetVisible83		; $5ccf


; State 1: phasing in
@state1:
	call @checkBlockCanAppear		; $5cd2
	call z,@pushLinkAway		; $5cd5

	; Wait for phase-in animation to complete
	call itemAnimate		; $5cd8
	ld e,Item.animParameter		; $5cdb
	ld a,(de)		; $5cdd
	or a			; $5cde
	ret z			; $5cdf

	; Animation done

	ld h,d			; $5ce0
	ld l,Item.oamFlagsBackup		; $5ce1
	ld a,$0d		; $5ce3
	ldi (hl),a		; $5ce5
	ldi (hl),a		; $5ce6

	; Item.oamTileIndexBase
	ld (hl),$36		; $5ce7

	; Enable collisions with enemies?
	ld l,Item.collisionType		; $5ce9
	set 7,(hl)		; $5ceb

@checkCreateBlock:
	call @checkBlockCanAppear		; $5ced
	jr nz,@deleteSelfWithPuff	; $5cf0
	call @createBlockIfNotOnHazard		; $5cf2
	jr nz,@deleteSelfWithPuff	; $5cf5

	; Note: a = 0 here

	ld h,d			; $5cf7
	ld l,Item.zh		; $5cf8
	ld (hl),a		; $5cfa

	; Set [state]=3, [state2]=0
	ld l,Item.state2		; $5cfb
	ldd (hl),a		; $5cfd
	ld (hl),$03		; $5cfe

	ld l,Item.collisionRadiusY		; $5d00
	ld a,$04		; $5d02
	ldi (hl),a		; $5d04
	ldi (hl),a		; $5d05

	ld l,Item.var2f		; $5d06
	ld a,(hl)		; $5d08
	and $f0			; $5d09
	ld (hl),a		; $5d0b

	ld a,$01		; $5d0c
	jp itemSetAnimation		; $5d0e


; State 4: block being pushed
@state4:
	ld e,Item.state2		; $5d11
	ld a,(de)		; $5d13
	rst_jumpTable			; $5d14

	.dw @state4Substate0
	.dw @state4Substate1

@state4Substate0:
	call itemIncState2		; $5d19
	call itemUpdateAngle		; $5d1c

	; Set speed & counter1 based on bracelet level
	ldbc SPEED_80, $20		; $5d1f
	ld a,(wBraceletLevel)		; $5d22
	cp $02			; $5d25
	jr nz,+			; $5d27
	ldbc SPEED_c0, $15		; $5d29
+
	ld l,Item.speed		; $5d2c
	ld (hl),b		; $5d2e
	ld l,Item.counter1		; $5d2f
	ld (hl),c		; $5d31

	ld a,SND_MOVEBLOCK		; $5d32
	call playSound		; $5d34
	call @removeBlock		; $5d37

@state4Substate1:
	call _itemUpdateDamageToApply		; $5d3a
	jr c,@deleteSelfWithPuff	; $5d3d
	call @checkDeletionTrigger		; $5d3f
	jr nz,@deleteSelfWithPuff	; $5d42

	call objectApplySpeed		; $5d44
	call @pushLinkAway		; $5d47
	call itemDecCounter1		; $5d4a

	ld l,Item.collisionRadiusY		; $5d4d
	ld a,$04		; $5d4f
	ldi (hl),a		; $5d51
	ld (hl),a		; $5d52

	; Return if counter1 is not 0
	ret nz			; $5d53

	jr @checkCreateBlock		; $5d54


@removeBlockAndDeleteSelfWithPuff:
	call @removeBlock		; $5d56
@deleteSelfWithPuff:
	ld h,d			; $5d59
	ld l,Item.var2f		; $5d5a
	bit 4,(hl)		; $5d5c
	call z,objectCreatePuff		; $5d5e
@deleteSelf:
	jp itemDelete		; $5d61


; State 2: being picked up / thrown
@state2:
	ld e,Item.state2		; $5d64
	ld a,(de)		; $5d66
	rst_jumpTable			; $5d67

	.dw @state2Substate0
	.dw @state2Substate1
	.dw @state2Substate2
	.dw @state2Substate3

; Substate 0: just picked up
@state2Substate0:
	call itemIncState2		; $5d70
	call @removeBlock		; $5d73
	call objectSetVisiblec1		; $5d76
	ld a,$02		; $5d79
	jp itemSetAnimation		; $5d7b

; Substate 1: being lifted
@state2Substate1:
	call _itemUpdateDamageToApply		; $5d7e
	ret nc			; $5d81
	call dropLinkHeldItem		; $5d82
	jr @deleteSelfWithPuff		; $5d85

; Substate 2/3: being thrown
@state2Substate2:
@state2Substate3:
	call objectCheckWithinRoomBoundary		; $5d87
	jr nc,@deleteSelf	; $5d8a

	call _bombUpdateThrowingLaterally		; $5d8c
	call @checkDeletionTrigger		; $5d8f
	jr nz,@deleteSelfWithPuff	; $5d92

	; var39 = gravity
	ld l,Item.var39		; $5d94
	ld c,(hl)		; $5d96
	call _itemUpdateThrowingVerticallyAndCheckHazards		; $5d97
	jr c,@deleteSelf	; $5d9a

	ret z			; $5d9c
	jr @deleteSelfWithPuff		; $5d9d


; State 3: block is just sitting around
@state3:
	call @checkBlockInPlace		; $5d9f
	jr nz,@deleteSelfWithPuff	; $5da2

	; Check if health went below 0
	call _itemUpdateDamageToApply		; $5da4
	jr c,@removeBlockAndDeleteSelfWithPuff	; $5da7

	; Check bit 5 of var2f (set when another somaria block is being created)
	call @checkDeletionTrigger		; $5da9
	jr nz,@removeBlockAndDeleteSelfWithPuff	; $5dac

	; If Link somehow ends up on this tile, delete the block
	ld a,(wActiveTilePos)		; $5dae
	ld l,Item.var32		; $5db1
	cp (hl)			; $5db3
	jr z,@removeBlockAndDeleteSelfWithPuff	; $5db4

	; If in a sidescrolling area, check that the tile below is solid
	ld a,(wTilesetFlags)		; $5db6
	and TILESETFLAG_SIDESCROLL			; $5db9
	jr z,++			; $5dbb

	ld a,(hl)		; $5dbd
	add $10			; $5dbe
	ld c,a			; $5dc0
	ld b,>wRoomCollisions		; $5dc1
	ld a,(bc)		; $5dc3
	cp $0f			; $5dc4
	jr nz,@removeBlockAndDeleteSelfWithPuff	; $5dc6
++
	ld l,Item.var2f		; $5dc8
	bit 0,(hl)		; $5dca
	jp z,objectAddToGrabbableObjectBuffer		; $5dcc

	; Link pushed on the block
	ld a,$04		; $5dcf
	jp itemSetState		; $5dd1

;;
; @param[out]	zflag	Unset if slated for deletion
; @addr{5dd4}
@checkDeletionTrigger:
	ld h,d			; $5dd4
	ld l,Item.var2f		; $5dd5
	bit 5,(hl)		; $5dd7
	ret			; $5dd9

;;
; @addr{5dda}
@pushLinkAway:
	ld e,Item.collisionRadiusY		; $5dda
	ld a,$07		; $5ddc
	ld (de),a		; $5dde
	ld hl,w1Link		; $5ddf
	jp preventObjectHFromPassingObjectD		; $5de2

;;
; @param[out]	zflag	Set if the cane of somaria block is present, and is solid?
; @addr{5de5}
@checkBlockInPlace:
	ld e,Item.var32		; $5de5
	ld a,(de)		; $5de7
	ld l,a			; $5de8
	ld h,>wRoomLayout		; $5de9
	ld a,(hl)		; $5deb
	cp TILEINDEX_SOMARIA_BLOCK			; $5dec
	ret nz			; $5dee

	ld h,>wRoomCollisions		; $5def
	ld a,(hl)		; $5df1
	cp $0f			; $5df2
	ret			; $5df4

;;
; @addr{5df5}
@removeBlock:
	call @checkBlockInPlace		; $5df5
	ret nz			; $5df8

	; Restore tile
	ld e,Item.var32		; $5df9
	ld a,(de)		; $5dfb
	call getTileIndexFromRoomLayoutBuffer		; $5dfc
	jp setTile		; $5dff

;;
; @param[out]	zflag	Set if the block can appear at this position
; @addr{5e02}
@checkBlockCanAppear:
	; Disallow cane of somaria usage if in patch's minigame room
	ld a,(wActiveGroup)		; $5e02
	cp $05			; $5e05
	jr nz,+			; $5e07
	ld a,(wActiveRoom)		; $5e09
	cp $e8			; $5e0c
	jr z,@@disallow		; $5e0e
+
	; Must be close to the ground
	ld e,Item.zh		; $5e10
	ld a,(de)		; $5e12
	dec a			; $5e13
	cp $fc			; $5e14
	jr c,@@disallow		; $5e16

	; Can't be in a wall
	call objectGetTileCollisions		; $5e18
	ret nz			; $5e1b

	; If underwater, never allow it
	ld a,(wTilesetFlags)		; $5e1c
	bit TILESETFLAG_BIT_UNDERWATER,a			; $5e1f
	ret nz			; $5e21

	; If in a sidescrolling area, check for floor underneath
	and TILESETFLAG_SIDESCROLL			; $5e22
	ret z			; $5e24

	ld a,l			; $5e25
	add $10			; $5e26
	ld l,a			; $5e28
	ld a,(hl)		; $5e29
	cp $0f			; $5e2a
	ret			; $5e2c

@@disallow:
	or d			; $5e2d
	ret			; $5e2e

;;
; @param[out]	zflag	Set on success
; @addr{5e2f}
@createBlockIfNotOnHazard:
	call @alignOnTile		; $5e2f
	call objectGetTileAtPosition		; $5e32
	push hl			; $5e35
	ld hl,hazardCollisionTable		; $5e36
	call lookupCollisionTable		; $5e39
	pop hl			; $5e3c
	jr c,++			; $5e3d

	; Overwrite the tile with the somaria block
	ld b,(hl)		; $5e3f
	ld (hl),TILEINDEX_SOMARIA_BLOCK		; $5e40
	ld h,>wRoomCollisions		; $5e42
	ld (hl),$0f		; $5e44

	; Save the old value of the tile to w3RoomLayoutBuffer
	ld e,Item.var32		; $5e46
	ld a,l			; $5e48
	ld (de),a		; $5e49
	ld c,a			; $5e4a
	call setTileInRoomLayoutBuffer		; $5e4b
	xor a			; $5e4e
	ret			; $5e4f
++
	or d			; $5e50
	ret			; $5e51

@alignOnTile:
	call objectCenterOnTile		; $5e52
	ld l,Item.yh		; $5e55
	dec (hl)		; $5e57
	dec (hl)		; $5e58
	ret			; $5e59


;;
; ITEMID_MINECART_COLLISION
; @addr{5e5a}
itemCode1d:
	ld e,Item.state		; $5e5a
	ld a,(de)		; $5e5c
	or a			; $5e5d
	ret nz			; $5e5e

	call _itemLoadAttributesAndGraphics		; $5e5f
	call itemIncState		; $5e62
	ld l,Item.enabled		; $5e65
	set 1,(hl)		; $5e67

@ret:
	ret			; $5e69

;;
; ITEMID_MINECART_COLLISION
; @addr{5e6a}
itemCode1dPost:
	ld hl,w1Companion.id		; $5e6a
	ld a,(hl)		; $5e6d
	cp SPECIALOBJECTID_MINECART			; $5e6e
	jp z,objectTakePosition		; $5e70
	jp itemDelete		; $5e73


;;
; ITEMID_SLINGSHOT
; @addr{5e76}
itemCode13:
	ret			; $5e76


;;
; ITEMID_BIGGORON_SWORD
; ITEMID_FOOLS_ORE
;
; @addr{5e77}
itemCode0c:
itemCode1e:
	ld e,Item.state		; $5e77
	ld a,(de)		; $5e79
	rst_jumpTable			; $5e7a

	.dw @state0
	.dw itemCode1d@ret

@state0:
	ld a,UNCMP_GFXH_1b		; $5e7f
	call loadWeaponGfx		; $5e81
	call _loadAttributesAndGraphicsAndIncState		; $5e84
	ld a,SND_BIGSWORD		; $5e87
	call playSound		; $5e89
	jp objectSetVisible82		; $5e8c


;;
; ITEMID_SWORD
; @addr{5e8f}
itemCode05:
	call _itemTransferKnockbackToLink		; $5e8f
	ld e,Item.state		; $5e92
	ld a,(de)		; $5e94
	rst_jumpTable			; $5e95

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@swordSounds:
	.db SND_SWORDSLASH
	.db SND_UNKNOWN5
	.db SND_BOOMERANG
	.db SND_SWORDSLASH
	.db SND_SWORDSLASH
	.db SND_UNKNOWN5
	.db SND_SWORDSLASH
	.db SND_SWORDSLASH


@state0:
	ld a,UNCMP_GFXH_1a		; $5eac
	call loadWeaponGfx		; $5eae

	; Play a random sound
	call getRandomNumber_noPreserveVars		; $5eb1
	and $07			; $5eb4
	ld hl,@swordSounds		; $5eb6
	rst_addAToHl			; $5eb9
	ld a,(hl)		; $5eba
	call playSound		; $5ebb

	ld e,Item.var31		; $5ebe
	xor a			; $5ec0
	ld (de),a		; $5ec1


; State 6: partial re-initialization?
@state6:
	call _loadAttributesAndGraphicsAndIncState		; $5ec2

	; Load collisiontype and damage
	ld a,(wSwordLevel)		; $5ec5
	ld hl,@swordLevelData-2		; $5ec8
	rst_addDoubleIndex			; $5ecb

	ld e,Item.collisionType		; $5ecc
	ldi a,(hl)		; $5ece
	ld (de),a		; $5ecf
	ld c,(hl)		; $5ed0

	; If var31 was nonzero, skip whimsical ring check?
	ld e,Item.var31		; $5ed1
	ld a,(de)		; $5ed3
	or a			; $5ed4
	ld a,c			; $5ed5
	ld (de),a		; $5ed6
	jr nz,@@setDamage		; $5ed7

	; Whimsical ring: usually 1 damage, with a 1/256 chance of doing 12 damage
	ld a,WHIMSICAL_RING		; $5ed9
	call cpActiveRing		; $5edb
	jr nz,@@setDamage		; $5ede
	call getRandomNumber		; $5ee0
	or a			; $5ee3
	ld c,-1		; $5ee4
	jr nz,@@setDamage		; $5ee6
	ld a,SND_LIGHTNING		; $5ee8
	call playSound		; $5eea
	ld c,-12		; $5eed

@@setDamage:
	ld e,Item.var3a		; $5eef
	ld a,c			; $5ef1
	ld (de),a		; $5ef2

	ld e,Item.state		; $5ef3
	ld a,$01		; $5ef5
	ld (de),a		; $5ef7

	jp objectSetVisible82		; $5ef8

; b0: collisionType
; b1: base damage
@swordLevelData:
	; L-1
	.db ($80|ITEMCOLLISION_L1_SWORD)
	.db (-2)

	; L-2
	.db ($80|ITEMCOLLISION_L2_SWORD)
	.db (-3)

	; L-3
	.db ($80|ITEMCOLLISION_L3_SWORD)
	.db (-5)


; State 4: swordspinning
@state4:
	ld e,Item.collisionType		; $5f01
	ld a, $80 | ITEMCOLLISION_SWORDSPIN		; $5f03
	ld (de),a		; $5f05


; State 1: being swung
@state1:
	ld h,d			; $5f06
	ld l,Item.oamFlagsBackup		; $5f07
	ldi a,(hl)		; $5f09
	ld (hl),a		; $5f0a
	ret			; $5f0b


; State 2: charging
@state2:
	ld e,Item.var31		; $5f0c
	ld a,(de)		; $5f0e
	ld e,Item.var3a		; $5f0f
	ld (de),a		; $5f11
	ret			; $5f12


; State 3: sword fully charged, flashing
@state3:
	ld h,d			; $5f13
	ld l,Item.counter1		; $5f14
	inc (hl)		; $5f16
	bit 2,(hl)		; $5f17
	ld l,Item.oamFlagsBackup		; $5f19
	ldi a,(hl)		; $5f1b
	jr nz,+			; $5f1c
	ld a,$0d		; $5f1e
+
	ld (hl),a		; $5f20
	ret			; $5f21


; State 5: end of swordspin
@state5:
	; Try to break tile at Link's feet, then delete self
	ld a,$08		; $5f22
	call _tryBreakTileWithSword_calculateLevel		; $5f24
	jp itemDelete		; $5f27


;;
; ITEMID_PUNCH
; ITEMID_NONE also points here, but this doesn't get called from there normally
; @addr{5f2a}
itemCode00:
itemCode02:
	ld e,Item.state		; $5f2a
	ld a,(de)		; $5f2c
	rst_jumpTable			; $5f2d

	.dw @state0
	.dw @state1

@state0:
	call _itemLoadAttributesAndGraphics		; $5f32
	ld c,SND_STRIKE		; $5f35
	call itemIncState		; $5f37
	ld l,Item.counter1		; $5f3a
	ld (hl),$04		; $5f3c
	ld l,Item.subid		; $5f3e
	bit 0,(hl)		; $5f40
	jr z,++			; $5f42

	; Expert's ring (bit 0 of Item.subid set)

	ld l,Item.collisionRadiusY		; $5f44
	ld a,$06		; $5f46
	ldi (hl),a		; $5f48
	ldi (hl),a		; $5f49

	; Increase Item.damage
	ld a,(hl)		; $5f4a
	add $fd			; $5f4b
	ld (hl),a		; $5f4d

	; Different collisionType for expert's ring?
	ld l,Item.collisionType		; $5f4e
	inc (hl)		; $5f50

	; Check for clinks against bombable walls?
	call _tryBreakTileWithExpertsRing		; $5f51

	ld c,SND_EXPLOSION		; $5f54
++
	ld a,c			; $5f56
	jp playSound		; $5f57

@state1:
	call itemDecCounter1		; $5f5a
	jp z,itemDelete		; $5f5d
	ret			; $5f60


;;
; ITEMID_SWORD_BEAM
; @addr{5f61}
itemCode27:
	ld e,Item.state		; $5f61
	ld a,(de)		; $5f63
	rst_jumpTable			; $5f64

	.dw @state0
	.dw @state1

@state0:
	ld hl,@initialOffsetsTable		; $5f69
	call _applyOffsetTableHL		; $5f6c
	call _itemLoadAttributesAndGraphics		; $5f6f
	call itemIncState		; $5f72

	ld l,Item.speed		; $5f75
	ld (hl),SPEED_300		; $5f77

	; Calculate angle
	ld l,Item.direction		; $5f79
	ldi a,(hl)		; $5f7b
	ld c,a			; $5f7c
	swap a			; $5f7d
	rrca			; $5f7f
	ld (hl),a		; $5f80

	ld a,c			; $5f81
	call itemSetAnimation		; $5f82
	call objectSetVisible81		; $5f85

	ld a,SND_SWORDBEAM		; $5f88
	jp playSound		; $5f8a

@initialOffsetsTable:
	.db $f5 $fc $00 ; DIR_UP
	.db $00 $0c $00 ; DIR_RIGHT
	.db $0a $03 $00 ; DIR_DOWN
	.db $00 $f3 $00 ; DIR_LEFT

@state1:
	call _itemUpdateDamageToApply		; $5f99
	jr nz,@collision		; $5f9c

	; No collision with an object?

	call objectApplySpeed		; $5f9e
	call objectCheckTileCollision_allowHoles		; $5fa1
	jr nc,@noCollision			; $5fa4

	call _itemCheckCanPassSolidTile		; $5fa6
	jr nz,@collision		; $5fa9

@noCollision:
	; Flip palette every 4 frames
	ld a,(wFrameCounter)		; $5fab
	and $03			; $5fae
	jr nz,+			; $5fb0
	ld h,d			; $5fb2
	ld l,Item.oamFlagsBackup		; $5fb3
	ld a,(hl)		; $5fb5
	xor $01			; $5fb6
	ldi (hl),a		; $5fb8
	ldi (hl),a		; $5fb9
+
	call objectCheckWithinScreenBoundary		; $5fba
	ret c			; $5fbd
	jp itemDelete		; $5fbe

@collision:
	ldbc INTERACID_CLINK, $81		; $5fc1
	call objectCreateInteraction		; $5fc4
	jp itemDelete		; $5fc7

;;
; Used for sword, cane of somaria, rod of seasons. Updates animation, deals with
; destroying tiles?
;
; @addr{5fca}
_updateSwingableItemAnimation:
	ld l,Item.animParameter		; $5fca
	cp $04			; $5fcc
	jr z,_label_07_227	; $5fce
	bit 6,(hl)		; $5fd0
	jr z,_label_07_227	; $5fd2

	res 6,(hl)		; $5fd4
	ld a,(hl)		; $5fd6
	and $1f			; $5fd7
	cp $10			; $5fd9
	jr nc,+			; $5fdb
	ld a,(w1Link.direction)		; $5fdd
	add a			; $5fe0
+
	and $07			; $5fe1
	push hl			; $5fe3
	call _tryBreakTileWithSword_calculateLevel		; $5fe4
	pop hl			; $5fe7

_label_07_227:
	ld c,$10		; $5fe8
	ld a,(hl)		; $5fea
	and $1f			; $5feb
	cp c			; $5fed
	jr nc,+			; $5fee

	srl a			; $5ff0
	ld c,a			; $5ff2
	ld a,(w1Link.direction)		; $5ff3
	add a			; $5ff6
	add a			; $5ff7
	add c			; $5ff8
	ld c,$00		; $5ff9
+
	ld hl,@data		; $5ffb
	rst_addAToHl			; $5ffe
	ld a,(hl)		; $5fff
	and $f0			; $6000
	swap a			; $6002
	add c			; $6004
	ld e,Item.var30		; $6005
	ld (de),a		; $6007

	ld a,(hl)		; $6008
	and $07			; $6009
	jp itemSetAnimation		; $600b


; For each byte:
;  Bits 4-7: value for Item.var30?
;  Bits 0-2: Animation index?
@data:
	.db $02 $41 $80 $c0 $10 $51 $92 $d2
	.db $26 $65 $a4 $e4 $30 $77 $b6 $f6

	.db $00 $11 $22 $33 $44 $55 $66 $77

;;
; Analagous to _updateSwingableItemAnimation, but specifically for biggoron's sword
;
; @addr{6026}
_updateBiggoronSwordAnimation:
	ld b,$00		; $6026
	ld l,Item.animParameter		; $6028
	bit 6,(hl)		; $602a
	jr z,+			; $602c
	res 6,(hl)		; $602e
	inc b			; $6030
+
	ld a,(hl)		; $6031
	and $0e			; $6032
	rrca			; $6034
	ld c,a			; $6035
	ld a,(w1Link.direction)		; $6036
	cp $01			; $6039
	jr nz,+			; $603b
	ld a,c			; $603d
	jr ++			; $603e
+
	inc a			; $6040
	add a			; $6041
	sub c			; $6042
++
	and $07			; $6043
	bit 0,b			; $6045
	jr z,++			; $6047

	push af			; $6049
	ld c,a			; $604a
	ld a,BREAKABLETILESOURCE_SWORD_L2		; $604b
	call _tryBreakTileWithSword		; $604d
	pop af			; $6050
++
	ld e,Item.var30		; $6051
	ld (de),a		; $6053
	jp itemSetAnimation		; $6054

;;
; ITEMID_MAGNET_GLOVES
;
; @addr{6057}
itemCode08Post:
	call _cpRelatedObject1ID		; $6057
	jp nz,itemDelete		; $605a

	ld hl,w1Link.yh		; $605d
	call objectTakePosition		; $6060
	ld a,(wFrameCounter)		; $6063
	rrca			; $6066
	rrca			; $6067
	ld a,(w1Link.direction)		; $6068
	adc a			; $606b
	ld e,Item.var30		; $606c
	ld (de),a		; $606e
	jp itemSetAnimation		; $606f

;;
; ITEMID_SLINGSHOT
;
; @addr{6072}
itemCode13Post:
	call _cpRelatedObject1ID		; $6072
	jp nz,itemDelete		; $6075

	ld hl,w1Link.yh		; $6078
	call objectTakePosition		; $607b
	ld a,(w1Link.direction)		; $607e
	ld e,Item.var30		; $6081
	ld (de),a		; $6083
	jp itemSetAnimation		; $6084

;;
; ITEMID_FOOLS_ORE
;
; @addr{6087}
itemCode1ePost:
	call _cpRelatedObject1ID		; $6087
	jp nz,itemDelete		; $608a

	ld l,Item.animParameter		; $608d
	ld a,(hl)		; $608f
	and $06			; $6090
	add a			; $6092
	ld b,a			; $6093
	ld a,(w1Link.direction)		; $6094
	add b			; $6097
	ld e,Item.var30		; $6098
	ld (de),a		; $609a
	ld hl,_swordArcData		; $609b
	jr _itemSetPositionInSwordArc		; $609e

;;
; ITEMID_PUNCH
;
; @addr{60a0}
itemCode00Post:
itemCode02Post:
	ld a,(w1Link.direction)		; $60a0
	add $18			; $60a3
	ld hl,_swordArcData		; $60a5
	jr _itemSetPositionInSwordArc		; $60a8

;;
; ITEMID_BIGGORON_SWORD
;
; @addr{60aa}
itemCode0cPost:
	call _cpRelatedObject1ID		; $60aa
	jp nz,itemDelete		; $60ad

	call _updateBiggoronSwordAnimation		; $60b0
	ld e,Item.var30		; $60b3
	ld a,(de)		; $60b5
	ld hl,_biggoronSwordArcData		; $60b6
	call _itemSetPositionInSwordArc		; $60b9
	jp _itemCalculateSwordDamage		; $60bc

;;
; ITEMID_CANE_OF_SOMARIA
; ITEMID_SWORD
; ITEMID_ROD_OF_SEASONS
;
; @addr{60bf}
itemCode04Post:
itemCode05Post:
itemCode07Post:
	call _cpRelatedObject1ID		; $60bf
	jp nz,itemDelete		; $60c2

	call _updateSwingableItemAnimation		; $60c5

	ld e,Item.var30		; $60c8
	ld a,(de)		; $60ca
	ld hl,_swordArcData		; $60cb
	call _itemSetPositionInSwordArc		; $60ce

	jp _itemCalculateSwordDamage		; $60d1

;;
; @param	a	Index for table 'hl'
; @param	hl	Usually points to _swordArcData
; @addr{60d4}
_itemSetPositionInSwordArc:
	add a			; $60d4
	rst_addDoubleIndex			; $60d5

;;
; Copy Link's position (accounting for raised floors, with Z position 2 higher than Link)
;
; @param	hl	Pointer to data for collision radii and position offsets
; @addr{60d6}
_itemInitializeFromLinkPosition:
	ld e,Item.collisionRadiusY		; $60d6
	ldi a,(hl)		; $60d8
	ld (de),a		; $60d9
	inc e			; $60da
	ldi a,(hl)		; $60db
	ld (de),a		; $60dc

	; Y
	ld a,(wLinkRaisedFloorOffset)		; $60dd
	ld b,a			; $60e0
	ld a,(w1Link.yh)		; $60e1
	add b			; $60e4
	add (hl)		; $60e5
	ld e,Item.yh		; $60e6
	ld (de),a		; $60e8

	; X
	inc hl			; $60e9
	ld e,Item.xh		; $60ea
	ld a,(w1Link.xh)		; $60ec
	add (hl)		; $60ef
	ld (de),a		; $60f0

	; Z
	ld a,(w1Link.zh)		; $60f1
	ld e,Item.zh		; $60f4
	sub $02			; $60f6
	ld (de),a		; $60f8
	ret			; $60f9


; Each row probably corresponds to part of a sword's arc? (Also used by punches.)
; b0/b1: collisionRadiusY/X
; b2/b3: Y/X offsets relative to Link
; @addr{60fa}
_swordArcData:
	.db $09 $06 $fe $10
	.db $06 $09 $f2 $00
	.db $09 $06 $00 $f1
	.db $06 $09 $f2 $00
	.db $07 $07 $f5 $0d
	.db $07 $07 $f5 $0d
	.db $07 $07 $11 $f3
	.db $07 $07 $f5 $f3
	.db $09 $06 $ef $fc
	.db $06 $09 $02 $13
	.db $09 $06 $15 $03
	.db $06 $09 $02 $ed
	.db $09 $06 $f6 $fc
	.db $04 $09 $02 $0c
	.db $09 $06 $10 $03
	.db $06 $09 $02 $f4
	.db $09 $09 $ef $fc
	.db $09 $09 $f2 $10
	.db $09 $09 $02 $13
	.db $09 $09 $12 $10
	.db $09 $09 $15 $03
	.db $09 $09 $11 $f3
	.db $09 $09 $02 $ed
	.db $09 $09 $f5 $f3
	.db $05 $05 $f4 $fd
	.db $05 $05 $00 $0c
	.db $05 $05 $0c $03
	.db $05 $05 $00 $f4

; @addr{616a}
_biggoronSwordArcData:
	.db $0b $0b $ef $fe
	.db $09 $0c $f2 $10
	.db $0b $0b $02 $13
	.db $0c $09 $12 $10
	.db $0b $0b $15 $01
	.db $09 $0c $11 $f3
	.db $0b $0b $02 $ed
	.db $0c $09 $f5 $f3


;;
; @addr{618a}
_tryBreakTileWithExpertsRing:
	ld a,(w1Link.direction)		; $618a
	add a			; $618d
	ld c,a			; $618e
	ld a,BREAKABLETILESOURCE_03		; $618f
	jr _tryBreakTileWithSword			; $6191

;;
; Same as below function, except this checks the sword's level to decide on the
; "breakableTileSource".
;
; @param	a	Direction (see below function)
; @addr{6193}
_tryBreakTileWithSword_calculateLevel:
	; Use BREAKABLETILESOURCE_SWORD_L1 or L2 depending on sword's level
	ld c,a			; $6193
	ld a,(wSwordLevel)		; $6194
	cp $01			; $6197
	jr z,_tryBreakTileWithSword		; $6199
	ld a,BREAKABLETILESOURCE_SWORD_L2		; $619b

;;
; Deals with sword slashing / spinning / poking against tiles, breaking them
;
; @param	a	See constants/breakableTileSources.s
; @param	c	Direction (0-7 are 45-degree increments, 8 is link's center)
; @addr{619d}
_tryBreakTileWithSword:
	; Check link is close enough to the ground
	ld e,a			; $619d
	ld a,(w1Link.zh)		; $619e
	dec a			; $61a1
	cp $f6			; $61a2
	ret c			; $61a4

	; Get Y/X relative to Link in bc
	ld a,c			; $61a5
	ld hl,@linkOffsets		; $61a6
	rst_addDoubleIndex			; $61a9
	ld a,(w1Link.yh)		; $61aa
	add (hl)		; $61ad
	ld b,a			; $61ae
	inc hl			; $61af
	ld a,(w1Link.xh)		; $61b0
	add (hl)		; $61b3
	ld c,a			; $61b4

	; Try to break the tile
	push bc			; $61b5
	ld a,e			; $61b6
	call tryToBreakTile		; $61b7

	; Copy tile position, then tile index
	ldh a,(<hFF93)	; $61ba
	ld ($ccb0),a		; $61bc
	ldh a,(<hFF92)	; $61bf
	ld ($ccaf),a		; $61c1
	pop bc			; $61c4

	; Return if the tile was broken
	ret c			; $61c5

	; Check for bombable wall clink sound
	ld hl,@clinkSoundTable		; $61c6
	call findByteInCollisionTable		; $61c9
	jr c,@bombableWallClink			; $61cc

	; Only continue if the sword is in a "poking" state
	ld a,(w1ParentItem2.subid)		; $61ce
	or a			; $61d1
	ret z			; $61d2

	; Check the second list of tiles to see if it produces no clink at all
	call findByteAtHl		; $61d3
	ret c			; $61d6

	; Produce a clink only if the tile is solid
	ldh a,(<hFF93)	; $61d7
	ld l,a			; $61d9
	ld h,>wRoomCollisions		; $61da
	ld a,(hl)		; $61dc
	cp $0f			; $61dd
	ret nz			; $61df
	ld e,$01		; $61e0
	jr @createClink			; $61e2

	; Play a different sound effect on bombable walls
@bombableWallClink:
	ld a,SND_CLINK2		; $61e4
	call playSound		; $61e6

	; Set bit 7 of subid to prevent 'clink' interaction from also playing a sound
	ld e,$80		; $61e9

@createClink:
	call getFreeInteractionSlot		; $61eb
	ret nz			; $61ee

	ld (hl),INTERACID_CLINK		; $61ef
	inc l			; $61f1
	ld (hl),e		; $61f2
	ld l,Interaction.yh		; $61f3
	ld (hl),b		; $61f5
	ld l,Interaction.xh		; $61f6
	ld (hl),c		; $61f8
	ret			; $61f9


@linkOffsets:
	.db $f2 $00 ; Up
	.db $f2 $0d ; Up-right
	.db $00 $0d ; Right
	.db $0d $0d ; Down-right
	.db $0d $00 ; Down
	.db $0d $f2 ; Down-left
	.db $00 $f2 ; Left
	.db $f2 $f2 ; Up-left
	.db $00 $00 ; Center


; 2 lists per entry:
; * The first is a list of tiles which produce an alternate "clinking" sound indicating
; they're bombable.
; * The second is a list of tiles which don't produce clinks at all.
;
; @addr{620c}
@clinkSoundTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
@collisions4:
	.db $c1 $c2 $c4 $d1 $cf
	.db $00

	.db $fd $fe $ff
	.db $00
	.db $00

@collisions1:
@collisions2:
@collisions5:
	.db $1f $30 $31 $32 $33 $38 $39 $3a $3b $68 $69
	.db $00

	.db $0a $0b
	.db $00

@collisions3:
	.db $12
	.db $00

	.db $00


;;
; Calculates the value for Item.damage, accounting for ring modifiers.
;
; @addr{6235}
_itemCalculateSwordDamage:
	ld e,Item.var3a		; $6235
	ld a,(de)		; $6237
	ld b,a			; $6238
	ld a,(w1ParentItem2.var3a)		; $6239
	or a			; $623c
	jr nz,@applyDamageModifier	; $623d

	ld hl,@swordDamageModifiers		; $623f
	ld a,(wActiveRing)		; $6242
	ld e,a			; $6245
@nextRing:
	ldi a,(hl)		; $6246
	or a			; $6247
	jr z,@noRingModifier	; $6248
	cp e			; $624a
	jr z,@foundRingModifier	; $624b
	inc hl			; $624d
	jr @nextRing		; $624e

@noRingModifier:
	ld a,e			; $6250
	cp RED_RING			; $6251
	jr z,@redRing		; $6253
	cp GREEN_RING			; $6255
	jr z,@greenRing		; $6257
	cp CURSED_RING			; $6259
	jr z,@cursedRing	; $625b

	ld a,b			; $625d
	jr @setDamage		; $625e

@redRing:
	ld a,b			; $6260
	jr @applyDamageModifier		; $6261

@greenRing:
	ld a,b			; $6263
	cpl			; $6264
	inc a			; $6265
	sra a			; $6266
	cpl			; $6268
	inc a			; $6269
	jr @applyDamageModifier		; $626a

@cursedRing:
	ld a,b			; $626c
	cpl			; $626d
	inc a			; $626e
	sra a			; $626f
	cpl			; $6271
	inc a			; $6272
	jr @setDamage		; $6273

@foundRingModifier:
	ld a,(hl)		; $6275

@applyDamageModifier:
	add b			; $6276

@setDamage:
	; Make sure it's not positive (don't want to heal enemies)
	bit 7,a			; $6277
	jr nz,+			; $6279
	ld a,$ff		; $627b
+
	ld e,Item.damage		; $627d
	ld (de),a		; $627f
	ret			; $6280


; Negative values give the sword more damage for that ring.
@swordDamageModifiers:
	.db POWER_RING_L1	$ff
	.db POWER_RING_L2	$fe
	.db POWER_RING_L3	$fd
	.db ARMOR_RING_L1	$01
	.db ARMOR_RING_L2	$01
	.db ARMOR_RING_L3	$01
	.db $00


;;
; Makes the given item mimic a tile. Used for switch hooking bushes and pots and stuff,
; possibly for other things too?
; @addr{628e}
_itemMimicBgTile:
	call getTileMappingData		; $628e
	push bc			; $6291
	ld h,d			; $6292

	; Set Item.oamFlagsBackup, Item.oamFlags
	ld l,Item.oamFlagsBackup		; $6293
	ld a,$0f		; $6295
	ldi (hl),a		; $6297
	ldi (hl),a		; $6298

	; Set Item.oamTileIndexBase
	ld (hl),c		; $6299

	; Compare the top-right tile to the top-left tile, and select the appropriate
	; animation depending on whether they reuse the same tile or not.
	; If they don't, it assumes that the graphics are adjacent to each other, due to
	; sprite limitations?
	ld a,($cec1)		; $629a
	sub c			; $629d
	jr z,+			; $629e
	ld a,$01		; $62a0
+
	call itemSetAnimation		; $62a2

	; Copy the BG palette which the tile uses to OBJ palette 7
	pop af			; $62a5
	and $07			; $62a6
	swap a			; $62a8
	rrca			; $62aa
	ld hl,w2TilesetBgPalettes		; $62ab
	rst_addAToHl			; $62ae
	push de			; $62af
	ld a,:w2TilesetSprPalettes		; $62b0
	ld ($ff00+R_SVBK),a	; $62b2
	ld de,w2TilesetSprPalettes+7*8		; $62b4
	ld b,$08		; $62b7
	call copyMemory		; $62b9

	; Mark OBJ 7 as modified
	ld hl,hDirtySprPalettes	; $62bc
	set 7,(hl)		; $62bf

	xor a			; $62c1
	ld ($ff00+R_SVBK),a	; $62c2
	pop de			; $62c4
	ret			; $62c5

;;
; This is the object representation of a tile while being held / thrown?
;
; If it's not a tile (ie. it's dimitri), this is just an invisible item with collisions?
;
; ITEMID_BRACELET
; @addr{62c6}
itemCode16:
	ld e,Item.state		; $62c6
	ld a,(de)		; $62c8
	rst_jumpTable			; $62c9

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call _itemLoadAttributesAndGraphics		; $62d2
	ld h,d			; $62d5
	ld l,Item.enabled		; $62d6
	set 1,(hl)		; $62d8

	; Check subid, which is the index of tile being lifted, or 0 if not lifting a tile
	ld l,Item.subid		; $62da
	ld a,(hl)		; $62dc
	or a			; $62dd
	jr z,@notTile		; $62de

	ld l,Item.state		; $62e0
	ld (hl),$02		; $62e2
	call _itemMimicBgTile		; $62e4
	jp objectSetVisiblec0		; $62e7


; State 1/2: being held
@state1:
@state2:
	ld h,d			; $62ea
	ld l,Item.state2		; $62eb
	ld a,(hl)		; $62ed
	or a			; $62ee
	ret z			; $62ef

	; Item thrown; enable collisions
	ld l,Item.collisionRadiusX		; $62f0
	ld a,$06		; $62f2
	ldd (hl),a		; $62f4
	ldd (hl),a		; $62f5

	; bit 7 of Item.collisionType
	dec l			; $62f6
	set 7,(hl)		; $62f7

	jr @throwItem		; $62f9


; When a bracelet object is created that doesn't come from a tile on the ground, it is
; created at the time it is thrown, instead of the time it is picked up. Also, it's
; invisible, since its only purpose is to provide collisions?
@notTile:
	call _braceletCheckDeleteSelfWhileThrowing		; $62fb

	; Check if relatedObj2 is an item or not?
	ld a,h			; $62fe
	cp >w1Companion			; $62ff
	jr z,@@copyCollisions			; $6301
	ld a,l			; $6303
	cp Item.start+$40			; $6304
	jr c,@throwItem	; $6306

; This will copy collision attributes of non-item objects. This should allow "non-allied"
; objects to damage enemies?
@@copyCollisions:
	; Copy angle (this -> relatedObj2)
	ld a,Object.angle		; $6308
	call objectGetRelatedObject2Var		; $630a
	ld e,Item.angle		; $630d
	ld a,(de)		; $630f
	ld (hl),a		; $6310

	; Copy collisionRadius (relatedObj2 -> this)
	ld a,l			; $6311
	add Object.collisionRadiusY-Object.angle			; $6312
	ld l,a			; $6314
	ld e,Item.collisionRadiusY		; $6315
	ldi a,(hl)		; $6317
	ld (de),a		; $6318
	inc e			; $6319
	ldi a,(hl)		; $631a
	ld (de),a		; $631b

	; Enable collisions (on this)
	ld h,d			; $631c
	ld l,Item.collisionType		; $631d
	set 7,(hl)		; $631f

@throwItem:
	call _itemBeginThrow		; $6321
	ld h,d			; $6324
	ld l,Item.state		; $6325
	ld (hl),$03		; $6327
	inc l			; $6329
	ld (hl),$00		; $632a


; State 3: being thrown
@state3:
	call _braceletCheckDeleteSelfWhileThrowing		; $632c
	call _itemUpdateThrowingLaterally		; $632f
	jr z,@@destroyWithAnimation	; $6332

	ld e,Item.var39		; $6334
	ld a,(de)		; $6336
	ld c,a			; $6337
	call _itemUpdateThrowingVertically		; $6338
	jr nc,@@noCollision	; $633b

	; If it's breakable, destroy it; if not, let it bounce
	call _braceletCheckBreakable		; $633d
	jr nz,@@destroyWithAnimation	; $6340
	call _itemBounce		; $6342
	jr c,@@release		; $6345

@@noCollision:
	; If this is not a breakable tile, copy this object's position to relatedObj2.
	ld e,Item.subid		; $6347
	ld a,(de)		; $6349
	or a			; $634a
	ret nz			; $634b
	ld a,Object.yh		; $634c
	call objectGetRelatedObject2Var		; $634e
	jp objectCopyPosition		; $6351

@@release:
	ld a,Object.state2		; $6354
	call objectGetRelatedObject2Var		; $6356
	ld (hl),$03		; $6359
	jp itemDelete		; $635b

@@destroyWithAnimation:
	call objectReplaceWithAnimationIfOnHazard		; $635e
	ret c			; $6361
	callab bank6.itemMakeInteractionForBreakableTile		; $6362
	jp itemDelete		; $636a

;;
; @param[out] zflag Set if Item.subid is zero
; @param[out] cflag Inverse of zflag?
; @addr{636d}
_braceletCheckBreakable:
	ld e,Item.subid		; $636d
	ld a,(de)		; $636f
	or a			; $6370
	ret z			; $6371
	scf			; $6372
	ret			; $6373

;;
; Called each frame an item's being thrown. Returns from caller if it decides to delete
; itself.
;
; @param[out]	hl	relatedObj2.state2 or this.state2
; @addr{6374}
_braceletCheckDeleteSelfWhileThrowing:
	ld e,Item.subid		; $6374
	ld a,(de)		; $6376
	or a			; $6377
	jr nz,@throwingTile		; $6378

	lda Item.enabled			; $637a
	call objectGetRelatedObject2Var		; $637b
	bit 0,(hl)		; $637e
	jr z,@deleteSelfAndRetFromCaller	; $6380

	; Delete self unless related object is on state 2, substate 0/1/2 (being held by
	; Link or just released)
	ld a,l			; $6382
	add Object.state-Object.enabled			; $6383
	ld l,a			; $6385
	ldi a,(hl)		; $6386
	cp $02			; $6387
	jr nz,@deleteSelfAndRetFromCaller	; $6389
	ld a,(hl)		; $638b
	cp $03			; $638c
	ret c			; $638e

@deleteSelfAndRetFromCaller:
	pop af			; $638f
	jp itemDelete		; $6390

@throwingTile:
	call objectCheckWithinRoomBoundary		; $6393
	jr nc,@deleteSelfAndRetFromCaller	; $6396
	ld h,d			; $6398
	ld l,Item.state2		; $6399
	ret			; $639b

;;
; Called every frame a bomb is being thrown. Also used by somaria block?
;
; @addr{639c}
_bombUpdateThrowingLaterally:
	; If it's landed in water, set speed to 0 (for sidescrolling areas)
	ld h,d			; $639c
	ld l,Item.var3b		; $639d
	bit 0,(hl)		; $639f
	jr z,+			; $63a1
	ld l,Item.speed		; $63a3
	ld (hl),$00		; $63a5
+
	; If this is the start of the throw, initialize speed variables
	ld l,Item.var37		; $63a7
	bit 0,(hl)		; $63a9
	call z,_itemBeginThrow		; $63ab

	; Check for collisions with walls, update position.
	jp _itemUpdateThrowingLaterally		; $63ae

;;
; Items call this once on the frame they're thrown
;
; @addr{63b1}
_itemBeginThrow:
	call _itemSetVar3cToFF		; $63b1

	; Move the item one pixel in Link's facing direction
	ld a,(w1Link.direction)		; $63b4
	ld hl,@throwOffsets		; $63b7
	rst_addAToHl			; $63ba
	ldi a,(hl)		; $63bb
	ld c,(hl)		; $63bc

	ld h,d			; $63bd
	ld l,Item.yh		; $63be
	add (hl)		; $63c0
	ldi (hl),a		; $63c1
	inc l			; $63c2
	ld a,(hl)		; $63c3
	add c			; $63c4
	ld (hl),a		; $63c5

	ld l,Item.enabled		; $63c6
	res 1,(hl)		; $63c8

	; Mark as thrown?
	ld l,Item.var37		; $63ca
	set 0,(hl)		; $63cc

	; Item.var38 contains "weight" information (how the object will be thrown)
	inc l			; $63ce
	ld a,(hl)		; $63cf
	and $f0			; $63d0
	swap a			; $63d2
	add a			; $63d4
	ld hl,_itemWeights		; $63d5
	rst_addDoubleIndex			; $63d8

	; Byte 0 from hl: value for Item.var39 (gravity)
	ldi a,(hl)		; $63d9
	ld e,Item.var39		; $63da
	ld (de),a		; $63dc

	; If angle is $ff (motionless), skip the rest.
	ld e,Item.angle		; $63dd
	ld a,(de)		; $63df
	rlca			; $63e0
	jr c,@clearItemSpeed	; $63e1

	; Byte 1: Value for Item.speedZ (8-bit, high byte is $ff)
	ld e,Item.speedZ		; $63e3
	ldi a,(hl)		; $63e5
	ld (de),a		; $63e6
	inc e			; $63e7
	ld a,$ff		; $63e8
	ld (de),a		; $63ea

	; Bytes 2,3: Throw speed with and without toss ring, respectively
	ld a,TOSS_RING		; $63eb
	call cpActiveRing		; $63ed
	jr nz,+			; $63f0
	inc hl			; $63f2
+
	ld e,Item.speed		; $63f3
	ldi a,(hl)		; $63f5
	ld (de),a		; $63f6
	ret			; $63f7

@clearItemSpeed:
	ld h,d			; $63f8
	ld l,Item.speed		; $63f9
	xor a			; $63fb
	ld (hl),a		; $63fc
	ld l,Item.speedZ		; $63fd
	ldi (hl),a		; $63ff
	ldi (hl),a		; $6400
	ret			; $6401

; Offsets to move the item when it's thrown.
; Each direction value reads 2 of these, one for Y and one for X.
@throwOffsets:
	.db $ff
	.db $00
	.db $01
	.db $00
	.db $ff

;;
; Checks whether a throwable item has collided with a wall; if not, this updates its
; position.
;
; Called by throwable items each frame. See also "_itemUpdateThrowingVertically".
;
; @param[out]	zflag	Set if the item should break.
; @addr{6407}
_itemUpdateThrowingLaterally:
	ld e,Item.var38		; $6407
	ld a,(de)		; $6409

	; Check whether the "weight" value for the item equals 3?
	cp $40			; $640a
	jr nc,+			; $640c
	cp $30			; $640e
	jr nc,@weight3		; $6410
+
	; Return if not moving
	ld e,Item.angle		; $6412
	ld a,(de)		; $6414
	cp $ff			; $6415
	jr z,@unsetZFlag	; $6417

	and $18			; $6419
	rrca			; $641b
	rrca			; $641c
	ld hl,_bombEdgeOffsets		; $641d
	rst_addAToHl			; $6420
	ldi a,(hl)		; $6421
	ld c,(hl)		; $6422

	; Load y position into b, jump if beyond room boundary.
	ld h,d			; $6423
	ld l,Item.yh		; $6424
	add (hl)		; $6426
	cp (LARGE_ROOM_HEIGHT*$10)			; $6427
	jr nc,@noCollision	; $6429

	ld b,a			; $642b
	ld l,Item.xh		; $642c
	ld a,c			; $642e
	add (hl)		; $642f
	ld c,a			; $6430

	call checkTileCollisionAt_allowHoles		; $6431
	jr nc,@noCollision	; $6434
	call _itemCheckCanPassSolidTileAt		; $6436
	jr z,@noCollision	; $6439
	jr @collision		; $643b

; This is probably a specific item with different dimensions than other throwable stuff
@weight3:
	ld h,d			; $643d
	ld l,Item.yh		; $643e
	ld b,(hl)		; $6440
	ld l,Item.xh		; $6441
	ld c,(hl)		; $6443

	ld e,Item.angle		; $6444
	ld a,(de)		; $6446
	and $18			; $6447
	ld hl,_data_649a		; $6449
	rst_addAToHl			; $644c

	; Loop 4 times, once for each corner of the object?
	ld e,$04		; $644d
--
	push bc			; $644f
	ldi a,(hl)		; $6450
	add b			; $6451
	ld b,a			; $6452
	ldi a,(hl)		; $6453
	add c			; $6454
	ld c,a			; $6455
	push hl			; $6456
	call checkTileCollisionAt_allowHoles		; $6457
	pop hl			; $645a
	pop bc			; $645b
	jr c,@collision	; $645c
	dec e			; $645e
	jr nz,--		; $645f
	jr @noCollision		; $6461

@collision:
	; Check if this is a breakable object (based on a tile that was picked up)?
	call _braceletCheckBreakable		; $6463
	jr nz,@setZFlag	; $6466

	; Clear angle, which will also set speed to 0
	ld e,Item.angle		; $6468
	ld a,$ff		; $646a
	ld (de),a		; $646c

@noCollision:
	ld a,(wTilesetFlags)		; $646d
	and TILESETFLAG_SIDESCROLL			; $6470
	jr z,+			; $6472

	; If in a sidescrolling area, don't apply speed if moving directly vertically?
	ld e,Item.angle		; $6474
	ld a,(de)		; $6476
	and $0f			; $6477
	jr z,@unsetZFlag	; $6479
+
	call objectApplySpeed		; $647b

@unsetZFlag:
	or d			; $647e
	ret			; $647f

@setZFlag:
	xor a			; $6480
	ret			; $6481

;;
; Called each time a particular item (ie a bomb) lands on a ground. This will cause it to
; bounce a few times before settling, reducing in speed with each bounce.
; @param[out] zflag Set if the item has reached a ground speed of zero.
; @param[out] cflag Set if the item has stopped bouncing.
; @addr{6482}
_itemBounce:
	ld a,SND_BOMB_LAND		; $6482
	call playSound		; $6484

	; Invert and reduce vertical speed
	call objectNegateAndHalveSpeedZ		; $6487
	ret c			; $648a

	; Reduce regular speed
	ld e,Item.speed		; $648b
	ld a,(de)		; $648d
	ld e,a			; $648e
	ld hl,_bounceSpeedReductionMapping		; $648f
	call lookupKey		; $6492
	ld e,Item.speed		; $6495
	ld (de),a		; $6497
	or a			; $6498
	ret			; $6499

; This seems to list the offsets of the 4 corners of a particular object, to be used for
; collision calculations.
; Somewhat similar to "_bombEdgeOffsets", except that is only used to check for collisions
; in the direction it's moving in, whereas this seems to cover the entire object.
_data_649a:
	.db $00 $00 $fa $fa $fa $00 $fa $05 ; DIR_UP
	.db $00 $00 $fa $05 $00 $05 $05 $05 ; DIR_RIGHT
	.db $00 $00 $05 $fb $05 $00 $05 $05 ; DIR_DOWN
	.db $00 $00 $fa $fa $00 $fa $06 $fa ; DIR_LEFT

; b0: Value to write to Item.var39 (gravity).
; b1: Low byte of Z speed to give the object (high byte will be $ff)
; b2: Throw speed without toss ring
; b3: Throw speed with toss ring
_itemWeights:
	.db $1c $10 SPEED_180 SPEED_280
	.db $20 $00 SPEED_080 SPEED_100
	.db $28 $20 SPEED_1a0 SPEED_280
	.db $20 $00 SPEED_080 SPEED_100
	.db $20 $e0 SPEED_140 SPEED_180
	.db $20 $00 SPEED_080 SPEED_100

; A series of key-value pairs where the key is a bouncing object's current speed, and the
; value is the object's new speed after one bounce.
; This returns roughly half the value of the key.
; @addr{64d2}
_bounceSpeedReductionMapping:
	.db SPEED_020 SPEED_000
	.db SPEED_040 SPEED_020
	.db SPEED_060 SPEED_020
	.db SPEED_080 SPEED_040
	.db SPEED_0a0 SPEED_040
	.db SPEED_0c0 SPEED_060
	.db SPEED_0e0 SPEED_060
	.db SPEED_100 SPEED_080
	.db SPEED_120 SPEED_080
	.db SPEED_140 SPEED_0a0
	.db SPEED_160 SPEED_0a0
	.db SPEED_180 SPEED_0c0
	.db SPEED_1a0 SPEED_0c0
	.db SPEED_1c0 SPEED_0e0
	.db SPEED_1e0 SPEED_0e0
	.db SPEED_200 SPEED_100
	.db SPEED_220 SPEED_100
	.db SPEED_240 SPEED_120
	.db SPEED_260 SPEED_120
	.db SPEED_280 SPEED_140
	.db SPEED_2a0 SPEED_140
	.db SPEED_2c0 SPEED_160
	.db SPEED_2e0 SPEED_160
	.db SPEED_300 SPEED_180
	.db $00 $00

;;
; ITEMID_DUST
; @addr{6504}
itemCode1a:
	ld e,Item.state2		; $6504
	ld a,(de)		; $6506
	rst_jumpTable			; $6507
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call _itemLoadAttributesAndGraphics		; $650e
	call itemIncState2		; $6511
	ld hl,w1Link.yh		; $6514
	call objectTakePosition		; $6517
	xor a			; $651a
	call itemSetAnimation		; $651b
	jp objectSetVisible80		; $651e


; Substate 1: initial dust cloud above Link (lasts less than a second)
@substate1:
	call itemAnimate		; $6521
	call @setOamTileIndexBaseFromAnimParameter		; $6524

	; Mess with Item.oamFlags and Item.oamFlagsBackup
	ld a,(hl)		; $6527
	inc a			; $6528
	and $fb			; $6529
	xor $60			; $652b
	ldd (hl),a		; $652d
	ld (hl),a		; $652e

	; If bit 7 of animParameter was set, go to state 2
	bit 7,b			; $652f
	ret z			; $6531

	; [Item.oamFlags] = [Item.oamFlagsBackup] = $0b
	ld a,$0b		; $6532
	ldi (hl),a		; $6534
	ld (hl),a		; $6535

	ld l,Item.z		; $6536
	xor a			; $6538
	ldi (hl),a		; $6539
	ld (hl),a		; $653a

	call objectSetInvisible		; $653b
	jp itemIncState2		; $653e


; Substate 2: dust by Link's feet (spends the majority of time in this state)
@substate2:
	call checkPegasusSeedCounter		; $6541
	jp z,itemDelete		; $6544

	call @initializeNextDustCloud		; $6547

	; Each frame, alternate between two dust cloud positions, with corresponding
	; variables stored at var30-var33 and var34-var37.
	call itemDecCounter1		; $654a
	bit 0,(hl)		; $654d
	ld l,Item.var30		; $654f
	jr z,+			; $6551
	ld l,Item.var34		; $6553
+
	bit 7,(hl)		; $6555
	jp z,objectSetInvisible		; $6557

	; Inc var30/var34 (acts as a counter)
	inc (hl)		; $655a
	ld a,(hl)		; $655b
	cp $82			; $655c
	jr c,++			; $655e

	; Reset the counter, increment var31/var35 (which controls the animation)
	ld (hl),$80		; $6560
	inc l			; $6562
	inc (hl)		; $6563
	ld a,(hl)		; $6564
	dec l			; $6565
	cp $03			; $6566
	jr nc,@clearDustCloudVariables	; $6568
++
	; c = [var31/var35]+1
	inc l			; $656a
	ldi a,(hl)		; $656b
	inc a			; $656c
	ld c,a			; $656d

	; [Item.yh] = [var32/var36], [Item.xh] = [var33/var37]
	ldi a,(hl)		; $656e
	ld e,Item.yh		; $656f
	ld (de),a		; $6571
	ldi a,(hl)		; $6572
	ld e,Item.xh		; $6573
	ld (de),a		; $6575

	; Load the animation (corresponding to [var31/var35])
	ld a,c			; $6576
	call itemSetAnimation		; $6577
	call objectSetVisible80		; $657a

;;
; @param[out]	b	[Item.animParameter]
; @param[out]	hl	Item.oamFlags
; @addr{657d}
@setOamTileIndexBaseFromAnimParameter:
	ld h,d			; $657d
	ld l,Item.animParameter		; $657e
	ld a,(hl)		; $6580
	ld b,a			; $6581
	and $7f			; $6582
	ld l,Item.oamTileIndexBase		; $6584
	ldd (hl),a		; $6586
	ret			; $6587

;;
; Clears one of the "slots" for the dust cloud objects.
; @addr{6588}
@clearDustCloudVariables:
	xor a			; $6588
	ldi (hl),a		; $6589
	ldi (hl),a		; $658a
	ldi (hl),a		; $658b
	ldi (hl),a		; $658c
	jp objectSetInvisible		; $658d

;;
; Initializes a dust cloud if one of the two slots are blank
;
; @addr{6590}
@initializeNextDustCloud:
	ld h,d			; $6590
	ld l,Item.subid		; $6591
	bit 0,(hl)		; $6593
	ret z			; $6595

	ld (hl),$00		; $6596

	ld l,Item.var30		; $6598
	bit 7,(hl)		; $659a
	jr z,+			; $659c
	ld l,Item.var34		; $659e
	bit 7,(hl)		; $65a0
	ret nz			; $65a2
+
	ld a,$80		; $65a3
	ldi (hl),a		; $65a5
	xor a			; $65a6
	ldi (hl),a		; $65a7
	ld a,(w1Link.yh)		; $65a8
	add $05			; $65ab
	ldi (hl),a		; $65ad
	ld a,(w1Link.xh)		; $65ae
	ld (hl),a		; $65b1
	ret			; $65b2


	.include "build/data/itemAttributes.s"
	.include "data/itemAnimations.s"

.ends


 ; This section can't be superfree, since it must be in the same bank as section
 ; "Enemy_Part_Collisions".
 m_section_free "Bank_7_Data" namespace "bank7"

	.include "build/data/enemyActiveCollisions.s"
	.include "build/data/partActiveCollisions.s"
	.include "build/data/objectCollisionTable.s"

	; Garbage data follows (repeats of object collision table)

.ifdef BUILD_VANILLA
	; 0x72
	.db                     $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; 0x73
	.db $03 $00 $00 $07 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; 0x74
	.db $02 $17 $16 $16 $15 $15 $15 $16 $1b $15 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; 0x75
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $2a $2a $2a $2a $2a $00

	; 0x76
	.db $02 $1f $1f $1f $1c $1c $1c $1c $1c $1c $00 $1c $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $1c $1c $1c $20 $20 $20 $20 $20 $20 $00

	; 0x77
	.db $3b $00 $00 $1e $1c $1c $1c $1c $1c $00 $00 $00 $1c $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; 0x78
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $1c $00 $00 $00 $00 $00 $00 $00 $00

	; 0x79
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $31 $31 $31 $31 $31 $00

	; 0x7a
	.db $02 $00 $00 $1e $00 $1c $1c $00 $1c $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; 0x7b
	.db $03 $00 $06 $06 $16 $16 $16 $16 $16 $16 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $2d $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; 0x7c
	.db $3d $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

.endif

.ends


.BANK $08 SLOT 1
.ORG 0


 m_section_force Interaction_Code_Bank08 NAMESPACE interactionBank08

	.include "code/ages/interactionCode/bank08.s"

.ends


.BANK $09 SLOT 1
.ORG 0

 m_section_force Interaction_Code_Bank09 NAMESPACE interactionBank09

	.include "code/ages/interactionCode/bank09.s"

.ends


.BANK $0a SLOT 1
.ORG 0


 m_section_force Interaction_Code_Bank0a NAMESPACE interactionBank0a

	.include "code/ages/interactionCode/bank0a.s"

.ends


.BANK $0b SLOT 1
.ORG 0


 m_section_force Interaction_Code_Bank0b NAMESPACE interactionBank0b

	.include "code/ages/interactionCode/bank0b.s"

.ifdef BUILD_VANILLA

; Garbage function here (partial repeat of the above function)

;;
; @addr{7fa1}
func_7fa1:
	call $258f		; $7fa1
	ret nc			; $7fa4
	jp $3b5c		; $7fa5

.endif

.ends


.BANK $0c SLOT 1
.ORG 0

	.include "code/scripting.s"
	.include "scripts/ages/scripts.s"


.BANK $0d SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0d NAMESPACE bank0d

	.include "code/enemyCommon.s"
	.include "code/ages/enemyCode/bank0d.s"

.ends

 m_section_superfree Enemy_Animations
	.include "build/data/enemyAnimations.s"
.ends


.BANK $0e SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0e NAMESPACE bank0e

	.include "code/enemyCommon.s"
	.include "code/ages/enemyCode/bank0e.s"

; ==============================================================================
; Data for INTERACID_MOVING_SIDESCROLL_PLATFORM and INTERACID_MOVING_SIDESCROLL_CONVEYOR
; ==============================================================================

movingSidescrollPlatformScriptTable:
	.dw _movingSidescrollPlatformScript_subid00
	.dw _movingSidescrollPlatformScript_subid01
	.dw _movingSidescrollPlatformScript_subid02
	.dw _movingSidescrollPlatformScript_subid03
	.dw _movingSidescrollPlatformScript_subid04
	.dw _movingSidescrollPlatformScript_subid05
	.dw _movingSidescrollPlatformScript_subid06
	.dw _movingSidescrollPlatformScript_subid07
	.dw _movingSidescrollPlatformScript_subid08
	.dw _movingSidescrollPlatformScript_subid09
	.dw _movingSidescrollPlatformScript_subid0a
	.dw _movingSidescrollPlatformScript_subid0b
	.dw _movingSidescrollPlatformScript_subid0c
	.dw _movingSidescrollPlatformScript_subid0d
	.dw _movingSidescrollPlatformScript_subid0e


_movingSidescrollPlatformScript_subid00:
	.db SPEED_80
	.db $04
@@loop:
	ms_right $78
	ms_left  $58
	ms_loop  @@loop


_movingSidescrollPlatformScript_subid01:
	.db SPEED_80
	.db $04
@@loop:
	ms_up    $28
	ms_down  $68
	ms_loop  @@loop


_movingSidescrollPlatformScript_subid02:
	.db SPEED_80
	.db $00
@@loop:
	ms_up    $28
	ms_right $50
	ms_down  $68
	ms_left  $30
	ms_loop  @@loop

_movingSidescrollPlatformScript_subid03:

	.db SPEED_80
	.db $00
@@loop:
	ms_left  $70
	ms_up    $28
	ms_right $90
	ms_down  $88
	ms_loop  @@loop


_movingSidescrollPlatformScript_subid04:
	.db SPEED_80
	.db $02
@@loop:
	ms_up    $48
	ms_down  $88
	ms_loop  @@loop


_movingSidescrollPlatformScript_subid05:
	.db SPEED_80
	.db $02
@@loop:
	ms_down  $78
	ms_up    $38
	ms_loop  @@loop



movingSidescrollConveyorScriptTable: ; INTERACID_MOVING_SIDESCROLL_CONVEYOR
	.dw @subid00

@subid00:
	.db SPEED_80
	.db $01
@@loop:
	ms_right $50
	ms_down  $88
	ms_left  $38
	ms_up    $38
	ms_loop  @@loop



_movingSidescrollPlatformScript_subid06:
	.db SPEED_80
	.db $04
@@loop:
	ms_up    $38
	ms_down  $68
	ms_loop  @@loop


_movingSidescrollPlatformScript_subid07:
	.db SPEED_80
	.db $04
@@loop:
	ms_left  $88
	ms_right $a8
	ms_loop  @@loop


_movingSidescrollPlatformScript_subid08:
	.db SPEED_80
	.db $04
@@loop:
	ms_up    $58
	ms_down  $98
	ms_loop  @@loop


_movingSidescrollPlatformScript_subid09:
	.db SPEED_80
	.db $04
@@loop:
	ms_up    $48
	ms_down  $98
	ms_loop  @@loop


_movingSidescrollPlatformScript_subid0a:
	.db SPEED_80
	.db $01
@@loop:
	ms_up    $38
	ms_down  $88
	ms_loop  @@loop


_movingSidescrollPlatformScript_subid0b:
	.db SPEED_80
	.db $03
@@loop:
	ms_left  $40
	ms_wait  30
	ms_right $80
	ms_wait  30
	ms_loop  @@loop


_movingSidescrollPlatformScript_subid0c:
	.db SPEED_80
	.db $00
@@loop:
	ms_down  $68
	ms_wait  30
	ms_up    $38
	ms_loop  @@loop


_movingSidescrollPlatformScript_subid0d:
	.db SPEED_80
	.db $00
@@loop:
	ms_down  $98
	ms_wait  30
	ms_up    $68
	ms_loop  @@loop


_movingSidescrollPlatformScript_subid0e:
	.db SPEED_80
	.db $00
@@loop:
	ms_left  $30
	ms_wait  30
	ms_right $a0
	ms_wait  30
	ms_loop  @@loop



; Garbage repeated data
.ifdef BUILD_VANILLA

_fake1:
	.db $00
	.dw $7f71

_fake2:
	.db SPEED_80
	.db $00
@@loop:
	ms_left  $30
	ms_wait  30
	ms_right $a0
	ms_wait  30
	ms_loop  @@loop
.endif

.ends

.BANK $0f SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0f NAMESPACE bank0f

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "code/ages/enemyCode/bank0f.s"

.ends

.BANK $10 SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank10 NAMESPACE bank10

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "code/ages/enemyCode/bank10.s"

.ends


; Some blank space here ($6e1f-$6eff)

.ORGA $6f00

 m_section_force Interaction_Code_Bank10 NAMESPACE interactionBank10

	.include "code/ages/interactionCode/bank10.s"

.ends


.BANK $11 SLOT 1
.ORG 0

	.define PART_BANK $11
	.export PART_BANK

 m_section_force "Bank_11" NAMESPACE "partCode"

	.include "code/partCommon.s"
	.include "code/ages/partCode.s"

.ifdef BUILD_VANILLA

; Garbage function follows (partial repeat of the last function)

;;
; @addr{7f64}
func_11_7f64:
	call $20ef		; $7f64
	ld h,$cf		; $7f67
	ld (hl),$00		; $7f69
	ld a,$98		; $7f6b
	call $0510		; $7f6d
	jp $1eaf		; $7f70

.endif

.ends


.BANK $12 SLOT 1
.ORG 0

.include "code/objectLoading.s"

 m_section_superfree "Room_Code" namespace "roomSpecificCode"

;;
; @addr{5872}
runRoomSpecificCode: ; 5872
	ld a,(wActiveRoom)		; $5872
	ld hl, _roomSpecificCodeGroupTable
	call findRoomSpecificData		; $5878
	ret nc			; $587b
	rst_jumpTable			; $587c
.dw _roomSpecificCode0
.dw _roomSpecificCode1
.dw _roomSpecificCode2
.dw _roomSpecificCode3
.dw _roomSpecificCode4
.dw _roomSpecificCode5
.dw setDeathRespawnPoint
.dw _roomSpecificCode7
.dw _roomSpecificCode8
.dw _roomSpecificCode9
.dw _roomSpecificCodeA
.dw _roomSpecificCodeB
.dw _roomSpecificCodeC

	; Random stub not called by anything?
	ret			; 5897

_roomSpecificCodeGroupTable: ; 5898
	.dw _roomSpecificCodeGroup0Table
	.dw _roomSpecificCodeGroup1Table
	.dw _roomSpecificCodeGroup2Table
	.dw _roomSpecificCodeGroup3Table
	.dw _roomSpecificCodeGroup4Table
	.dw _roomSpecificCodeGroup5Table
	.dw _roomSpecificCodeGroup6Table
	.dw _roomSpecificCodeGroup7Table

; Format: room index

_roomSpecificCodeGroup0Table: ; 58a8
	.db $93 $00
	.db $38 $06
	.db $39 $08
	.db $3a $09
	.db $00
_roomSpecificCodeGroup1Table: ; 58b1
	.db $81 $03
	.db $38 $06
	.db $97 $07
	.db $0e $0a
	.db $00
_roomSpecificCodeGroup2Table: ; 58ba
	.db $0e $05
	.db $00
_roomSpecificCodeGroup3Table: ; 58bd
	.db $0f $0b
	.db $00
_roomSpecificCodeGroup4Table: ; 58c0
	.db $60 $01
	.db $52 $02
	.db $e6 $0c
	.db $00
_roomSpecificCodeGroup5Table: ; 58c7
	.db $d2 $04
_roomSpecificCodeGroup6Table:
_roomSpecificCodeGroup7Table: ; 58c9
	.db $00

;;
; @addr{58ca}
_roomSpecificCode0: ; 58ca
	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME		; $58ca
	call checkGlobalFlag		; $58cc
	ret nz			; $58cf
	ld hl,$cfd0		; $58d0
	ld b,$10		; $58d3
	jp clearMemory		; $58d5

;;
; @addr{5cd8}
_roomSpecificCode1: ; 5cd8
	ld a, GLOBALFLAG_D3_CRYSTALS	; $5cd8
	call checkGlobalFlag		; $58da
	ret nz			; $58dd
---
	; Create spinner object
	call getFreeInteractionSlot		; $58de
	ret nz			; $58e1
	ld (hl),$7d		; $58e2
	ld l,Interaction.yh
	ld (hl),$57		; $58e6
	ld l,Interaction.xh
	ld (hl),$01		; $58ea
	ret			; $58ec

;;
; @addr{58ed}
_roomSpecificCode2: ; 58ed
	ld a,GLOBALFLAG_D3_CRYSTALS	; $58ed
	call checkGlobalFlag		; $58ef
	ret z			; $58f2
	; Create spinner if the flag is UNset
	jr ---

;;
; @addr{58f5}
_roomSpecificCode3: ; 58f5
	call getThisRoomFlags		; $58f5
	bit 6,a			; $58f8
	ret nz			; $58fa
	ld a,TREASURE_MYSTERY_SEEDS		; $58fb
	call checkTreasureObtained		; $58fd
	ret nc			; $5900
	ld hl,wcc05		; $5901
	res 1,(hl)		; $5904
	call getFreeInteractionSlot		; $5906
	ret nz			; $5909
	ld (hl),$40		; $590a
	inc l			; $590c
	ld (hl),$0a		; $590d
	ld a,$01		; $590f
	ld (wDiggingUpEnemiesForbidden),a		; $5911
	ret			; $5914

;;
; @addr{5915}
_roomSpecificCode7: ; 5915
	ld a,GLOBALFLAG_GAVE_ROPE_TO_RAFTON	; $5915
	call checkGlobalFlag		; $5917
	ret z			; $591a
	call getThisRoomFlags		; $591b
	bit 6,a			; $591e
	ret nz			; $5920
.ifdef ROM_AGES
	ld a,MUS_RALPH
.else
	ld a,$35
.endif
	ld (wActiveMusic2),a		; $5923
	ret			; $5926

;;
; @addr{5927}
_roomSpecificCode5: ; 5927
	ld a,GLOBALFLAG_SAVED_NAYRU	; $5927
	call checkGlobalFlag		; $5929
	ret nz			; $592c
	ld a,MUS_SADNESS
	ld (wActiveMusic2),a		; $592f
	ret			; $5932

;;
; Something in ambi's palace
; @addr{5933}
_roomSpecificCode4: ; 5933
	ld a,$06		; $5933
	ld (wMinimapRoom),a		; $5935
	ld hl,wPastRoomFlags+$06
	set 4,(hl)		; $593b
	ret			; $593d

;;
; Check to play ralph music for ralph entering portal cutscene
; @addr{593e}
_roomSpecificCode8: ; 593e
	ld a,(wScreenTransitionDirection)		; $593e
	cp DIR_RIGHT			; $5941
	ret nz			; $5943
	ld a, GLOBALFLAG_RALPH_ENTERED_PORTAL
	call checkGlobalFlag		; $5946
	ret nz			; $5949
.ifdef ROM_AGES
	ld a, MUS_RALPH
.else
	ld a,$35
.endif
	ld (wActiveMusic2),a		; $594c
	ret			; $594f

;;
; Play nayru music on impa's house screen, for some reason
; @addr{5950}
_roomSpecificCode9: ; 5950
	ld a,GLOBALFLAG_FINISHEDGAME		; $5950
	call checkGlobalFlag		; $5952
	ret z			; $5955
.ifdef ROM_AGES
	ld a, MUS_NAYRU
.else
	ld a,$08
.endif
	ld (wActiveMusic2),a		; $5958
	ret			; $595b

;;
; Correct minimap in mermaid's cave present
; @addr{595c}
_roomSpecificCodeA: ; 595c
	ld hl,wMinimapGroup		; $595c
	ld (hl),$00		; $595f
	inc l			; $5961
	ld (hl),$3c		; $5962
	ret			; $5964

;;
; Correct minimap in mermaid's cave past
; @addr{5965}
_roomSpecificCodeB: ; 5965
	ld hl,wMinimapGroup		; $5965
	ld (hl),$01		; $5968
	inc l			; $596a
	ld (hl),$3c		; $596b
	ret			; $596d

;;
; Something happening on vire black tower screen
; @addr{596e}
_roomSpecificCodeC: ; 596e
	ld hl,wActiveMusic		; $596e
	ld a,(hl)		; $5971
	or a			; $5972
	ret nz			; $5973
	ld (hl),$ff		; $5974
	ret			; $5976


.ends

 m_section_free "Objects_2" namespace "objectData"

.include "objects/ages/mainData.s"
.include "objects/ages/extraData3.s"

.ends


 m_section_superfree "Underwater Surface Data"

;;
; Sets carry (bit 0 of c) if link is allowed to surface
; @addr{78e4}
checkLinkCanSurface_isUnderwater: ; 78e4
	ld a,(wActiveGroup)		; $78e4
	ld hl, underWaterSurfaceTable
	rst_addDoubleIndex			; $78ea
	ldi a,(hl)		; $78eb
	ld h,(hl)		; $78ec
	ld l,a			; $78ed
	ld a,(wActiveRoom)		; $78ee
	ld b,a			; $78f1
-
	ldi a,(hl)		; $78f2
	or a			; $78f3
	jr z,+++
	cp b			; $78f6
	jr z,+
	inc hl			; $78f9
	inc hl			; $78fa
	jr -
+
	ldi a,(hl)		; $78fd
	ld h,(hl)		; $78fe
	ld l,a			; $78ff
	ld a,(wTilesetFlags)		; $7900
	and $01			; $7903
	jr z, +
	ld b,(hl)		; $7907
	ld a,b			; $7908
	and $03			; $7909
	jr z, ++
	push hl			; $790d
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $790e
	call checkGlobalFlag		; $7910
	pop hl			; $7913
	jr z, ++
	bit 0,b			; $7916
	jr nz, +++
	ld a,$08		; $791a
	rst_addDoubleIndex			; $791c
	jr ++
+
	ld a,(wDungeonIndex)		; $791f
	cp $07			; $7922
	jr nz, ++
	ld a,(wJabuWaterLevel)		; $7926
	and $03			; $7929
	cp $02			; $792b
	jr nz, ++
	ld a,(wActiveRoom)		; $792f
	cp $4c			; $7932
	jr z, +
	cp $4d			; $7936
	jr nz, ++
+
	ld a,$0b		; $793a
	rst_addDoubleIndex			; $793c
++
	ld a,(wActiveTilePos)		; $793d
	ld b,a			; $7940
	swap a			; $7941
	and $0f			; $7943
	rst_addDoubleIndex			; $7945
	ld a,b			; $7946
	and $0f			; $7947
	xor $0f			; $7949
	call checkFlag		; $794b
	jr nz,++++
	scf			; $7950
	jr ++++
+++
	ld a,(wTilesetFlags)		; $7953
	and $01			; $7956
	jr z, ++++
	scf			; $795a
++++
	rl c			; $795b
	ret			; $795d

underWaterSurfaceTable: ; 795e
	.dw underWaterSurfaceTableGroup0
	.dw underWaterSurfaceTableGroup1
	.dw underWaterSurfaceTableGroup2
	.dw underWaterSurfaceTableGroup3
	.dw underWaterSurfaceTableGroup4
	.dw underWaterSurfaceTableGroup5
	.dw underWaterSurfaceTableGroup6
	.dw underWaterSurfaceTableGroup7

; Format: room pointer

underWaterSurfaceTableGroup0: ; 796e
underWaterSurfaceTableGroup1:
underWaterSurfaceTableGroup2:
underWaterSurfaceTableGroup6:
underWaterSurfaceTableGroup7:
	.db $90
	.dw underWaterSurfaceData_7a47

	.db $a0
	.dw underWaterSurfaceData_7a47

	.db $ac
	.dw underWaterSurfaceData_7a47

	.db $ba
	.dw underWaterSurfaceData_7a47

	.db $bb
	.dw underWaterSurfaceData_7a47

	.db $bc
	.dw underWaterSurfaceData_7a47

	.db $ca
	.dw underWaterSurfaceData_7a47

	.db $cb
	.dw underWaterSurfaceData_7a47

	.db $cc
	.dw underWaterSurfaceData_7a47

	.db $da
	.dw underWaterSurfaceData_7a47

	.db $db
	.dw underWaterSurfaceData_7a47

	.db $9c
	.dw underWaterSurfaceData_7a57

	.db $a1
	.dw underWaterSurfaceData_7a67

	.db $a2
	.dw underWaterSurfaceData_7a87

	.db $a3
	.dw underWaterSurfaceData_7a97

	.db $a4
	.dw underWaterSurfaceData_7aa7

	.db $ab
	.dw underWaterSurfaceData_7ab7

	.db $b0
	.dw underWaterSurfaceData_7ac7

	.db $b1
	.dw underWaterSurfaceData_7ad7

	.db $b2
	.dw underWaterSurfaceData_7ae7

	.db $b3
	.dw underWaterSurfaceData_7af7

	.db $b4
	.dw underWaterSurfaceData_7b07

	.db $b5
	.dw underWaterSurfaceData_7b27

	.db $b6
	.dw underWaterSurfaceData_7b37

	.db $b7
	.dw underWaterSurfaceData_7b47

	.db $bd
	.dw underWaterSurfaceData_7b57

	.db $c1
	.dw underWaterSurfaceData_7b67

	.db $c2
	.dw underWaterSurfaceData_7b77

	.db $c4
	.dw underWaterSurfaceData_7b87

	.db $c7
	.dw underWaterSurfaceData_7b97

	.db $d0
	.dw underWaterSurfaceData_7ba7

	.db $d1
	.dw underWaterSurfaceData_7bb7

	.db $d2
	.dw underWaterSurfaceData_7bd7

	.db $d4
	.dw underWaterSurfaceData_7bf7

	.db $d5
	.dw underWaterSurfaceData_7c07

	.db $d7
	.dw underWaterSurfaceData_7c27

	.db $d8
	.dw underWaterSurfaceData_7c37

	.db $00

underWaterSurfaceTableGroup3: ; 79de
	.db $90
	.dw underWaterSurfaceData_7a47

	.db $a0
	.dw underWaterSurfaceData_7a47

	.db $e1
	.dw underWaterSurfaceData_7a47

	.db $0e
	.dw underWaterSurfaceData_7c47

	.db $a1
	.dw underWaterSurfaceData_7a67

	.db $a2
	.dw underWaterSurfaceData_7c67

	.db $b0
	.dw underWaterSurfaceData_7c77

	.db $b1
	.dw underWaterSurfaceData_7c87

	.db $b5
	.dw underWaterSurfaceData_7c97

	.db $b6
	.dw underWaterSurfaceData_7ca7

	.db $c1
	.dw underWaterSurfaceData_7b67

	.db $c2
	.dw underWaterSurfaceData_7cb7

	.db $c4
	.dw underWaterSurfaceData_7cc7

	.db $c5
	.dw underWaterSurfaceData_7cd7

	.db $c7
	.dw underWaterSurfaceData_7ce7

	.db $d0
	.dw underWaterSurfaceData_7ba7

	.db $d1
	.dw underWaterSurfaceData_7bb7

	.db $d2
	.dw underWaterSurfaceData_7cf7

	.db $d4
	.dw underWaterSurfaceData_7d17

	.db $d5
	.dw underWaterSurfaceData_7d27

	.db $d9
	.dw underWaterSurfaceData_7d47

	.db $e0
	.dw underWaterSurfaceData_7d57

	.db $e2
	.dw underWaterSurfaceData_7d67

	.db $8c
	.dw underWaterSurfaceData_7c57

	.db $d6
	.dw underWaterSurfaceData_7d37

	.db $00

underWaterSurfaceTableGroup4: ; 7a2a
	.db $c1
	.dw underWaterSurfaceData_7e53

	.db $00

underWaterSurfaceTableGroup5: ; 7a2e
	.db $4c
	.dw underWaterSurfaceData_7d77

	.db $4d
	.dw underWaterSurfaceData_7da3

	.db $4f
	.dw underWaterSurfaceData_7dcf

	.db $52
	.dw underWaterSurfaceData_7de5

	.db $53
	.dw underWaterSurfaceData_7dfb

	.db $2d
	.dw underWaterSurfaceData_7e3d

	.db $30
	.dw underWaterSurfaceData_7e11

	.db $35
	.dw underWaterSurfaceData_7e27

	.db $00

underWaterSurfaceData_7a47:
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
underWaterSurfaceData_7a57:
	.dw %1111111111000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %1111111111000000
underWaterSurfaceData_7a67:
	.dw %1111111111000010
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
underWaterSurfaceData_7a77:
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111110000000
	.dw %1111111111000000
underWaterSurfaceData_7a87:
	.dw %1111111111000001
	.dw %1111000001000000
	.dw %1110000001000000
	.dw %1110000001000000
	.dw %1100000111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
underWaterSurfaceData_7a97:
	.dw %1111111111000001
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111110000000
	.dw %1111111110000000
	.dw %1111111111000000
	.dw %1111100001000000
	.dw %1111111111000000
underWaterSurfaceData_7aa7:
	.dw %1111111111000001
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %0000111111000000
	.dw %0000111111000000
	.dw %1000111111000000
	.dw %1000000001000000
	.dw %1111111111000000
underWaterSurfaceData_7ab7:
	.dw %0000000011000000
	.dw %0000000011000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
underWaterSurfaceData_7ac7:
	.dw %1111111111000000
	.dw %1101111011000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0011000000000000
	.dw %1111111111000000
underWaterSurfaceData_7ad7:
	.dw %1101111011000000
	.dw %1000110001000000
	.dw %0000000001000000
	.dw %0000010001000000
	.dw %0000000001000000
	.dw %0000000001000000
	.dw %0001111111000000
	.dw %1001111111000000
underWaterSurfaceData_7ae7:
	.dw %1111111111000001
	.dw %1111111111000000
	.dw %1111110111000000
	.dw %1111110111000000
	.dw %1111110011000000
	.dw %1111110000000000
	.dw %1111110000000000
	.dw %1111111111000000
underWaterSurfaceData_7af7:
	.dw %1111111111000001
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111110001000000
	.dw %0011110001000000
	.dw %0011110001000000
	.dw %1011110001000000
underWaterSurfaceData_7b07:
	.dw %1111111111000010
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111110001000000
	.dw %1111111111000000
underWaterSurfaceData_7b17:
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000011111000000
	.dw %1000011111000000
	.dw %1000011111000000
	.dw %1000011111000000
	.dw %1000010001000000
	.dw %1110000001000000
underWaterSurfaceData_7b27:
	.dw %1111111111000001
	.dw %1001111111000000
	.dw %1000011111000000
	.dw %1000001111000000
	.dw %1000000111000000
	.dw %1000000111000000
	.dw %1000000111000000
	.dw %1111111111000000
underWaterSurfaceData_7b37:
	.dw %1000000000000001
	.dw %1000000000000000
	.dw %1000001111000000
	.dw %1000001111000000
	.dw %1000001000000000
	.dw %1000001000000000
	.dw %1000001000000000
	.dw %1100011000000000
underWaterSurfaceData_7b47:
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0001000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
underWaterSurfaceData_7b57:
	.dw %1111111001000000
	.dw %1111111001000000
	.dw %1111111001000000
	.dw %1111111101000000
	.dw %1111111101000000
	.dw %1111111101000000
	.dw %1111111101000000
	.dw %1111111101000000
underWaterSurfaceData_7b67:
	.dw %1001111111000000
	.dw %1001111111000000
	.dw %1001111111000000
	.dw %0001111111000000
	.dw %0001111111000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %1111100000000000
underWaterSurfaceData_7b77:
	.dw %1111111111000001
	.dw %1000000001000000
	.dw %1000000001000000
	.dw %1000000001000000
	.dw %1000000001000000
	.dw %1111100001000000
	.dw %1111100001000000
	.dw %1111111111000000
underWaterSurfaceData_7b87:
	.dw %1111111111000000
	.dw %1000000001000000
	.dw %1000000001000000
	.dw %0000000111000000
	.dw %0000100111000000
	.dw %0000000111000000
	.dw %0000000001000000
	.dw %1111111111000000
underWaterSurfaceData_7b97:
	.dw %0011111111000000
	.dw %0011001111000000
	.dw %0011001111000000
	.dw %1110001111000000
	.dw %1110000011000000
	.dw %1111111111000000
	.dw %0011111111000000
	.dw %0011111111000000
underWaterSurfaceData_7ba7:
	.dw %1111111001000000
	.dw %1111111000000000
	.dw %1111111000000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
underWaterSurfaceData_7bb7:
	.dw %1111100001000010
	.dw %0000000001000000
	.dw %0000000001000000
	.dw %1111000011000000
	.dw %1111000001000000
	.dw %1111000001000000
	.dw %1111000001000000
	.dw %1111111111000000
underWaterSurfaceData_7bc7:
	.dw %1111100001000000
	.dw %0000000001000000
	.dw %0000000001000000
	.dw %1111000011000000
	.dw %1111000001000000
	.dw %1111000000000000
	.dw %1111000000000000
	.dw %1111111111000000
underWaterSurfaceData_7bd7:
	.dw %1111111111000010
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
underWaterSurfaceData_7be7:
	.dw %1111100001000000
	.dw %1111100001000000
	.dw %1111100001000000
	.dw %1111100001000000
	.dw %1000000000000000
	.dw %0000000100000000
	.dw %0000000000000000
	.dw %1111111111000000
underWaterSurfaceData_7bf7:
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1011100111000000
	.dw %1011100111000000
	.dw %1010000111000000
	.dw %0001111000000000
	.dw %0000000000000000
	.dw %1111111111000000
underWaterSurfaceData_7c07:
	.dw %1111111111000010
	.dw %1111111111000000
	.dw %1100111101000000
	.dw %1100111101000000
	.dw %1110001100000000
	.dw %0001111000000000
	.dw %0000001000000000
	.dw %1111111111000000
underWaterSurfaceData_7c17:
	.dw %1111111111000010
	.dw %1111111111000000
	.dw %1100111001000000
	.dw %1100111001000000
	.dw %1110001000000000
	.dw %0001110000000000
	.dw %0000000000000000
	.dw %1111111111000000
underWaterSurfaceData_7c27:
	.dw %0011111111000000
	.dw %0011111100000000
	.dw %0011111100000000
	.dw %1111111100000000
	.dw %1111111111000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
underWaterSurfaceData_7c37:
	.dw %1110001000000000
	.dw %0010001000000000
	.dw %0010001000000000
	.dw %0011111000000000
	.dw %1111111000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
underWaterSurfaceData_7c47:
	.dw %1111111111000000
	.dw %1001111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
underWaterSurfaceData_7c57:
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000010000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
underWaterSurfaceData_7c67:
	.dw %1111111111000001
	.dw %1100011000000000
	.dw %1100000000000000
	.dw %1110000000000000
	.dw %1111000001000000
	.dw %1111100011000000
	.dw %1111111111000000
	.dw %1111111111000000
underWaterSurfaceData_7c77:
	.dw %1111111111000000
	.dw %1101111011000000
	.dw %1000000000000000
	.dw %1000000000000000
	.dw %1000000000000000
	.dw %1000000000000000
	.dw %1001000000000000
	.dw %1111111111000000
underWaterSurfaceData_7c87:
	.dw %1101111011000000
	.dw %1000110001000000
	.dw %0000000001000000
	.dw %0000010001000000
	.dw %0000000001000000
	.dw %0000000001000000
	.dw %0001111111000000
	.dw %1001111111000000
underWaterSurfaceData_7c97:
	.dw %1111111111000001
	.dw %1111100001000000
	.dw %1111100001000000
	.dw %1111100001000000
	.dw %1111100001000000
	.dw %1111100001000000
	.dw %1000000001000000
	.dw %1111111111000000
underWaterSurfaceData_7ca7:
	.dw %1000000000000001
	.dw %1000000000000000
	.dw %1001111111000000
	.dw %1001000000000000
	.dw %1001000000000000
	.dw %1001000000000000
	.dw %1001000000000000
	.dw %1101000000000000
underWaterSurfaceData_7cb7:
	.dw %1000001111000000
	.dw %1000000001000000
	.dw %1000000001000000
	.dw %1000000001000000
	.dw %1000000001000000
	.dw %1000011111000000
	.dw %1000011111000000
	.dw %1111111111000000
underWaterSurfaceData_7cc7:
	.dw %1110000001000000
	.dw %1000000001000000
	.dw %1000000001000000
	.dw %0000000000000000
	.dw %0000100000000000
	.dw %0000000000000000
	.dw %0000000001000000
	.dw %1111111111000000
underWaterSurfaceData_7cd7:
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1000001111000000
	.dw %0011111111000000
	.dw %0011111111000000
	.dw %0011111111000000
	.dw %1000000001000000
	.dw %1111111111000000
underWaterSurfaceData_7ce7:
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000001000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
underWaterSurfaceData_7cf7:
	.dw %1111111111000010
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
underWaterSurfaceData_7d07:
	.dw %1000011111000000
	.dw %1000011111000000
	.dw %1000011111000000
	.dw %1000011111000000
	.dw %1000000000000000
	.dw %0000000100000000
	.dw %0000000000000000
	.dw %1111111111000000
underWaterSurfaceData_7d17:
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1010011111000000
	.dw %1000011111000000
	.dw %1010000011000000
	.dw %0011011000000000
	.dw %0000000000000000
	.dw %1111111111000000
underWaterSurfaceData_7d27:
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1100001111000000
	.dw %1100001111000000
	.dw %1110001000000000
	.dw %0001110000000000
	.dw %0000000000000000
	.dw %1111111111000000
underWaterSurfaceData_7d37:
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000000000000000
	.dw %0000010000000000
	.dw %0000000000000000
	.dw %0000000000000000
underWaterSurfaceData_7d47:
	.dw %1001111111000000
	.dw %1001111111000000
	.dw %0100111111000000
	.dw %1001111111000000
	.dw %0101111111000000
	.dw %1001111001000000
	.dw %1100010011000000
	.dw %0111111100000000
underWaterSurfaceData_7d57:
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1100111111000000
	.dw %1100111111000000
	.dw %1111111111000000
underWaterSurfaceData_7d67:
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111001000000
	.dw %1111111001000000
	.dw %1111111111000000
	.dw %1111111111000000
	.dw %1111111111000000


underWaterSurfaceData_7d77:
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111110111
	.dw %1111111111110111
	.dw %1111111111110111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111

	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111100000111111
	.dw %1111100000111111
	.dw %1111100000110111
	.dw %1111100000110111
	.dw %1111100000110111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111

underWaterSurfaceData_7da3:
	.dw %1111111111111111
	.dw %1111111111100111
	.dw %1111111111100111
	.dw %1111111111100111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111

	.dw %1111111111111111
	.dw %1100000111100111
	.dw %1100000111100111
	.dw %1100000111100111
	.dw %1100000111111111
	.dw %1100000111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111


underWaterSurfaceData_7dcf:
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1001111111110011
	.dw %1000000000000011
	.dw %1100000000000111
	.dw %1100001110000111
	.dw %1100000000000111
	.dw %1000000000000011
	.dw %1001111111110011
	.dw %1111111111111111
	.dw %1111111111111111

underWaterSurfaceData_7de5:
	.dw %1111111111111111
	.dw %1111111111100111
	.dw %1111111111100111
	.dw %1111111111100111
	.dw %1110000000000111
	.dw %1110000000000111
	.dw %1110000000000111
	.dw %1110000000000111
	.dw %1110000000000111
	.dw %1111111111111111
	.dw %1111111111111111


underWaterSurfaceData_7dfb:
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1100011111111111
	.dw %1100011111111111
	.dw %1100011111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111

underWaterSurfaceData_7e11:
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1000000111111111
	.dw %1000000111111111
	.dw %1111111111111111

underWaterSurfaceData_7e27:
	.dw %1111111111111111
	.dw %1111111111110011
	.dw %1111111111110011
	.dw %1111111111110011
	.dw %1111111111110011
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111

underWaterSurfaceData_7e3d:
	.dw %1111111111111111
	.dw %1000000000000011
	.dw %1000000000000011
	.dw %1000000000000011
	.dw %1000010101000011
	.dw %1000011111000011
	.dw %1000010101000011
	.dw %1000000000000011
	.dw %1000000000000011
	.dw %1000000000000011
	.dw %1111111111111111

underWaterSurfaceData_7e53:
	.dw %1111111111111111
	.dw %1111111001111111
	.dw %1111111001111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111001111111
	.dw %1001111001110001
	.dw %1001111111110001
	.dw %1111111111111111

.ENDS

 m_section_free "Objects_3" namespace "objectData"

.include "objects/ages/extraData4.s"

.ends


.BANK $13 SLOT 1
.ORG 0

	.define BASE_OAM_DATA_BANK $13
	.export BASE_OAM_DATA_BANK

	.include "build/data/specialObjectOamData.s"
	.include "data/itemOamData.s"
	.include "build/data/enemyOamData.s"

.BANK $14 SLOT 1
.ORG 0

 m_section_superfree "Terrain_Effects" NAMESPACE "terrainEffects"

; @addr{4000}
shadowAnimation:
	.db $01
	.db $13 $04 $20 $08

; @addr{4005}
greenGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $08
	.db $11 $07 $24 $08

; @addr{400e}
blueGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $09
	.db $11 $07 $24 $09

; @addr{4017}
_puddleAnimationFrame0:
	.db $02
	.db $16 $03 $22 $08
	.db $16 $05 $22 $28

; @addr{4020}
orangeGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $0b
	.db $11 $07 $24 $0b

; @addr{4029}
greenGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $28
	.db $11 $07 $24 $28

; @addr{4032}
blueGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $29
	.db $11 $07 $24 $29

; @addr{403b}
_puddleAnimationFrame1:
	.db $02
	.db $16 $02 $22 $08
	.db $16 $06 $22 $28

; @addr{4044}
orangeGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $2b
	.db $11 $07 $24 $2b

; @addr{404d}
_puddleAnimationFrame2:
	.db $02
	.db $17 $01 $22 $08
	.db $17 $07 $22 $28

; @addr{4056}
_puddleAnimationFrame3:
	.db $02
	.db $18 $00 $22 $08
	.db $18 $08 $22 $28

; @addr{405f}
puddleAnimationFrames:
	.dw _puddleAnimationFrame0
	.dw _puddleAnimationFrame1
	.dw _puddleAnimationFrame2
	.dw _puddleAnimationFrame3

.ends

.include "build/data/interactionOamData.s"
.include "build/data/partOamData.s"


.include "code/ages/bank15.s"


.BANK $16 SLOT 1
.ORG 0

.include "code/serialFunctions.s"

 m_section_force Bank16 NAMESPACE bank16

;;
; @param	d	Interaction index (should be of type INTERACID_TREASURE)
; @addr{451e}
interactionLoadTreasureData:
	ld e,Interaction.subid	; $451e
	ld a,(de)		; $4520
	ld e,Interaction.var30		; $4521
	ld (de),a		; $4523
	ld hl,treasureObjectData		; $4524
--
	call multiplyABy4		; $4527
	add hl,bc		; $452a
	bit 7,(hl)		; $452b
	jr z,+			; $452d

	inc hl			; $452f
	ldi a,(hl)		; $4530
	ld h,(hl)		; $4531
	ld l,a			; $4532
	ld e,Interaction.var03		; $4533
	ld a,(de)		; $4535
	jr --			; $4536
+
	; var31 = spawn mode
	ldi a,(hl)		; $4538
	ld b,a			; $4539
	swap a			; $453a
	and $07			; $453c
	ld e,Interaction.var31		; $453e
	ld (de),a		; $4540

	; var32 = collect mode
	ld a,b			; $4541
	and $07			; $4542
	inc e			; $4544
	ld (de),a		; $4545

	; var33 = ?
	ld a,b			; $4546
	and $08			; $4547
	inc e			; $4549
	ld (de),a		; $454a

	; var34 = parameter (value of 'c' for "giveTreasure")
	ldi a,(hl)		; $454b
	inc e			; $454c
	ld (de),a		; $454d

	; var35 = low text ID
	ldi a,(hl)		; $454e
	inc e			; $454f
	ld (de),a		; $4550

	; subid = graphics to use
	ldi a,(hl)		; $4551
	ld e,Interaction.subid		; $4552
	ld (de),a		; $4554
	ret			; $4555


; Tons of OAM data here. TODO: account for all address references.
data_4556:
	.dw @data0
	.dw @data1
	.dw @data2
	.dw @data3
	.dw @data4
	.dw @data5
	.dw @data6
	.dw @data7
	.dw @data8
	.dw @data9
	.dw @dataA
	.dw @dataB
	.dw @dataC
	.dw @dataD
	.dw @dataE
	.dw @dataF
	.dw @data10


@data0:
	.db $10
	.db $ab $e0 $40 $01
	.db $ab $ea $42 $01
	.db $ab $f4 $44 $01
	.db $ab $fe $46 $01
	.db $ab $1c $48 $01
	.db $ab $08 $4c $01
	.db $ab $12 $4e $01
	.db $ab $27 $56 $01
	.db $d0 $e9 $0a $00
	.db $d0 $f1 $16 $00
	.db $d0 $f9 $00 $00
	.db $d0 $01 $0c $00
	.db $d0 $09 $24 $00
	.db $d0 $11 $0e $00
	.db $d0 $17 $10 $00
	.db $d0 $1d $1e $00

@data1:
	.db $1b
	.db $a8 $e9 $4a $01
	.db $a8 $f2 $4c $01
	.db $a8 $fc $4e $01
	.db $a8 $04 $4c $01
	.db $a8 $16 $50 $01
	.db $a8 $20 $52 $01
	.db $a8 $29 $4e $01
	.db $b8 $ee $6a $01
	.db $b8 $f8 $6c $01
	.db $b8 $01 $6e $01
	.db $b8 $09 $70 $01
	.db $b8 $13 $72 $01
	.db $b8 $1c $74 $01
	.db $a8 $e0 $42 $01
	.db $a8 $0e $42 $01
	.db $d0 $dc $30 $00
	.db $d0 $e4 $28 $00
	.db $d0 $ec $24 $00
	.db $d0 $f4 $28 $00
	.db $d0 $fc $14 $00
	.db $d0 $04 $08 $00
	.db $e0 $04 $1a $00
	.db $e0 $0c $00 $00
	.db $e0 $14 $14 $00
	.db $e0 $1c $00 $00
	.db $e0 $23 $1a $00
	.db $e0 $2b $1c $00

@data2:
	.db $1c
	.db $a8 $e0 $52 $01
	.db $a8 $e8 $54 $01
	.db $a8 $fa $50 $01
	.db $a8 $04 $56 $01
	.db $a8 $0d $4e $01
	.db $a8 $1e $4c $01
	.db $a8 $28 $58 $01
	.db $b8 $ee $6a $01
	.db $b8 $f8 $6c $01
	.db $b8 $01 $6e $01
	.db $b8 $09 $70 $01
	.db $b8 $13 $72 $01
	.db $b8 $1c $74 $01
	.db $a8 $f1 $48 $01
	.db $a8 $15 $48 $01
	.db $d0 $f4 $00 $00
	.db $d0 $fc $28 $00
	.db $d0 $04 $0c $00
	.db $d0 $0c $08 $00
	.db $d0 $13 $1a $00
	.db $f0 $e9 $30 $00
	.db $f0 $f1 $34 $00
	.db $f0 $f9 $26 $00
	.db $f0 $00 $00 $00
	.db $f0 $07 $1a $00
	.db $f0 $0f $00 $00
	.db $f0 $17 $14 $00
	.db $f0 $1f $00 $00

@data3:
	.db $1f
	.db $d2 $f9 $0e $00
	.db $d2 $01 $1c $00
	.db $d2 $09 $26 $00
	.db $d2 $11 $26 $00
	.db $d2 $18 $00 $00
	.db $06 $f4 $26 $00
	.db $06 $fc $08 $00
	.db $06 $04 $32 $00
	.db $06 $0c $28 $00
	.db $06 $14 $14 $00
	.db $06 $1c $00 $00
	.db $d2 $f0 $70 $08
	.db $06 $ec $70 $08
	.db $ec $ec $72 $08
	.db $ec $f6 $30 $00
	.db $ec $fe $00 $00
	.db $ec $06 $18 $00
	.db $ec $0e $00 $00
	.db $ec $16 $06 $00
	.db $ec $1e $00 $00
	.db $a8 $03 $5a $01
	.db $a8 $0b $52 $01
	.db $a8 $14 $4e $01
	.db $b0 $ee $5c $01
	.db $a8 $f3 $40 $01
	.db $b0 $fb $60 $01
	.db $b8 $18 $6e $01
	.db $b8 $ff $6e $01
	.db $b8 $f7 $70 $01
	.db $b8 $07 $64 $01
	.db $b8 $0f $68 $01

@dataA:
	.db $19
	.db $b0 $e8 $4c $09
	.db $b0 $f0 $4e $09
	.db $b0 $f8 $50 $09
	.db $b0 $00 $52 $09
	.db $b0 $08 $54 $09
	.db $b0 $10 $56 $09
	.db $b0 $18 $58 $09
	.db $b0 $20 $5a $09
	.db $d0 $ed $00 $00
	.db $d0 $f5 $30 $00
	.db $d0 $fd $00 $00
	.db $d0 $05 $1a $00
	.db $d0 $0d $00 $00
	.db $d0 $15 $0c $00
	.db $d0 $1d $10 $00
	.db $ea $f4 $18 $00
	.db $ea $fc $10 $00
	.db $ea $04 $16 $00
	.db $ea $0c $14 $00
	.db $ea $14 $30 $00
	.db $04 $f4 $10 $00
	.db $04 $fc $32 $00
	.db $04 $04 $28 $00
	.db $04 $0c $18 $00
	.db $04 $14 $10 $00

@dataE:
	.db $18
	.db $ac $e0 $5a $01
	.db $ac $ea $4e $01
	.db $ac $f5 $56 $01
	.db $ac $ff $54 $01
	.db $ac $1e $52 $01
	.db $ac $29 $4e $01
	.db $b4 $0a $60 $01
	.db $ac $14 $42 $01
	.db $d0 $d0 $1a $00
	.db $d0 $d8 $1c $00
	.db $d0 $e0 $22 $00
	.db $d0 $e6 $10 $00
	.db $d0 $ec $26 $00
	.db $d0 $f3 $00 $00
	.db $d0 $fb $14 $00
	.db $e0 $03 $0a $00
	.db $e0 $0b $28 $00
	.db $e0 $12 $1a $00
	.db $e0 $1b $00 $00
	.db $e0 $23 $18 $00
	.db $e0 $29 $10 $00
	.db $e0 $2f $32 $00
	.db $e0 $37 $28 $00
	.db $d0 $03 $00 $00

@dataF:
	.db $27
	.db $d0 $d4 $24 $00
	.db $d0 $dc $0e $00
	.db $d0 $e2 $10 $00
	.db $d0 $e8 $0c $00
	.db $d0 $f0 $08 $00
	.db $d0 $f8 $22 $00
	.db $d0 $00 $28 $00
	.db $e0 $00 $18 $00
	.db $e0 $0c $30 $00
	.db $e0 $06 $10 $00
	.db $e0 $13 $00 $00
	.db $e0 $1b $18 $00
	.db $e0 $23 $1c $00
	.db $e0 $2b $26 $00
	.db $e0 $33 $1c $00
	.db $f8 $d7 $30 $00
	.db $f8 $df $1c $00
	.db $f8 $e7 $24 $00
	.db $f8 $ef $0e $00
	.db $f8 $f5 $10 $00
	.db $f8 $fb $14 $00
	.db $f8 $01 $10 $00
	.db $08 $01 $1c $00
	.db $08 $09 $14 $00
	.db $08 $11 $00 $00
	.db $08 $19 $18 $00
	.db $08 $21 $1c $00
	.db $08 $29 $26 $00
	.db $08 $31 $1c $00
	.db $b0 $e0 $12 $09
	.db $b0 $e8 $14 $09
	.db $b0 $f0 $16 $09
	.db $b0 $f8 $18 $09
	.db $b0 $00 $1a $09
	.db $b0 $08 $1c $09
	.db $b0 $10 $1e $09
	.db $b0 $18 $20 $09
	.db $b0 $20 $22 $09
	.db $b0 $28 $24 $09

@data10:
	.db $20
	.db $a8 $df $52 $01
	.db $b0 $e8 $7e $01
	.db $a8 $f1 $52 $01
	.db $a8 $0c $50 $01
	.db $a8 $1f $5c $01
	.db $a8 $29 $52 $01
	.db $b8 $fe $6a $01
	.db $b8 $1b $6c $01
	.db $a8 $fa $42 $01
	.db $b0 $04 $60 $01
	.db $a8 $16 $48 $01
	.db $b8 $08 $60 $01
	.db $d0 $d5 $0e $00
	.db $d0 $db $10 $00
	.db $d0 $e1 $22 $00
	.db $d0 $e9 $1c $00
	.db $d0 $f1 $24 $00
	.db $d0 $f9 $0e $00
	.db $d0 $ff $10 $00
	.db $e0 $ff $30 $00
	.db $e0 $06 $00 $00
	.db $e0 $0e $18 $00
	.db $e0 $16 $00 $00
	.db $e0 $1e $28 $00
	.db $e0 $26 $04 $00
	.db $e0 $2e $0e $00
	.db $e0 $34 $10 $00
	.db $b8 $e3 $62 $01
	.db $b8 $ec $68 $01
	.db $b8 $f6 $64 $01
	.db $b8 $11 $66 $01
	.db $b8 $24 $68 $01

@data5:
	.db $18
	.db $d8 $ec $14 $00
	.db $d8 $f4 $34 $00
	.db $d8 $fc $14 $00
	.db $d8 $04 $1c $00
	.db $d8 $0c $1a $00
	.db $d8 $14 $06 $00
	.db $d8 $1c $1c $00
	.db $a8 $e0 $38 $09
	.db $a8 $e8 $3a $09
	.db $a8 $f0 $3c $09
	.db $a8 $f8 $3e $09
	.db $b0 $00 $40 $09
	.db $b0 $08 $42 $09
	.db $a8 $10 $44 $09
	.db $a8 $18 $46 $09
	.db $a8 $20 $48 $09
	.db $a8 $28 $4a $09
	.db $c0 $ec $7a $01
	.db $c0 $f4 $6a $01
	.db $b8 $fc $5c $01
	.db $c0 $04 $70 $01
	.db $c0 $0c $6e $01
	.db $c0 $14 $6c $01
	.db $c0 $1c $68 $01

@data6:
	.db $16
	.db $a8 $ec $5a $01
	.db $a8 $f4 $58 $01
	.db $a8 $fc $4c $01
	.db $a8 $04 $46 $01
	.db $a8 $0c $46 $01
	.db $a8 $14 $44 $01
	.db $a8 $1c $4e $01
	.db $b8 $ec $6e $01
	.db $b8 $f4 $60 $01
	.db $b8 $fc $62 $01
	.db $b8 $04 $62 $01
	.db $b8 $0c $64 $01
	.db $b8 $14 $68 $01
	.db $b8 $1c $76 $01
	.db $d0 $e8 $1a $00
	.db $d0 $f0 $1c $00
	.db $d0 $f8 $24 $00
	.db $d0 $00 $08 $00
	.db $d0 $08 $26 $00
	.db $d0 $10 $00 $00
	.db $d0 $18 $14 $00
	.db $d0 $20 $08 $00

@data4:
	.db $1a
	.db $d0 $e8 $18 $00
	.db $d0 $f0 $34 $00
	.db $d0 $f8 $1a $00
	.db $d0 $00 $00 $00
	.db $d0 $08 $22 $00
	.db $d0 $10 $10 $00
	.db $d0 $18 $26 $00
	.db $d0 $20 $00 $00
	.db $e8 $e8 $14 $00
	.db $e8 $f0 $34 $00
	.db $e8 $f8 $18 $00
	.db $e8 $00 $10 $00
	.db $e8 $08 $32 $00
	.db $e8 $10 $28 $00
	.db $e8 $18 $14 $00
	.db $e8 $20 $10 $00
	.db $00 $ec $30 $00
	.db $00 $f3 $00 $00
	.db $00 $fb $18 $00
	.db $00 $03 $00 $00
	.db $00 $0b $24 $00
	.db $00 $13 $0e $00
	.db $00 $19 $10 $00
	.db $00 $1f $26 $00
	.db $00 $25 $00 $00
	.db $00 $e4 $72 $08

@dataB:
	.db $1f
	.db $b4 $f8 $08 $00
	.db $b4 $00 $0c $00
	.db $b4 $08 $28 $00
	.db $b4 $10 $04 $00
	.db $b4 $18 $0e $00
	.db $b4 $20 $10 $00
	.db $b4 $f0 $34 $00
	.db $b4 $e8 $18 $00
	.db $ce $d8 $18 $00
	.db $ce $e0 $10 $00
	.db $ce $e7 $1a $00
	.db $ce $f0 $1c $00
	.db $ce $f8 $22 $00
	.db $ce $00 $28 $00
	.db $de $00 $00 $00
	.db $de $08 $22 $00
	.db $de $10 $00 $00
	.db $de $18 $14 $00
	.db $de $20 $00 $00
	.db $de $28 $2c $00
	.db $de $30 $00 $00
	.db $f4 $e4 $18 $00
	.db $f4 $ec $10 $00
	.db $f4 $f4 $14 $00
	.db $f4 $fc $08 $00
	.db $04 $fc $0a $00
	.db $04 $04 $28 $00
	.db $04 $0c $14 $00
	.db $04 $14 $28 $00
	.db $04 $1c $06 $00
	.db $04 $24 $00 $00

@dataC:
	.db $23
	.db $cc $e8 $1c $00
	.db $cc $f0 $22 $00
	.db $cc $f8 $10 $00
	.db $cc $00 $0c $00
	.db $cc $08 $10 $00
	.db $cc $10 $1a $00
	.db $cc $18 $00 $00
	.db $cc $20 $16 $00
	.db $f4 $f4 $24 $00
	.db $f4 $04 $1e $00
	.db $f4 $fc $28 $00
	.db $f4 $0c $08 $00
	.db $f4 $14 $22 $00
	.db $04 $e2 $18 $00
	.db $04 $f2 $22 $00
	.db $04 $ea $00 $00
	.db $04 $fa $10 $00
	.db $04 $02 $1c $00
	.db $04 $0e $04 $00
	.db $04 $16 $16 $00
	.db $04 $1e $28 $00
	.db $04 $26 $02 $00
	.db $dc $de $5c $08
	.db $dc $e6 $5e $08
	.db $dc $ee $60 $08
	.db $dc $f6 $62 $08
	.db $dc $fe $64 $08
	.db $dc $06 $66 $08
	.db $dc $0e $68 $08
	.db $dc $16 $6a $08
	.db $dc $1e $6c $08
	.db $dc $26 $6e $08
	.db $b4 $fc $00 $00
	.db $b4 $04 $02 $00
	.db $b4 $0c $28 $00

@dataD:
	.db $0d
	.db $b8 $fc $1a $00
	.db $b8 $04 $1c $00
	.db $b8 $0c $00 $00
	.db $c8 $dd $06 $00
	.db $c8 $e5 $08 $00
	.db $c8 $ed $02 $00
	.db $c8 $f5 $28 $00
	.db $c8 $fd $0c $00
	.db $c8 $0c $24 $00
	.db $c8 $14 $26 $00
	.db $c8 $1c $00 $00
	.db $c8 $24 $0a $00
	.db $c8 $2c $0a $00

@data7:
	.db $28
	.db $b0 $e0 $c0 $09
	.db $b0 $e8 $c2 $09
	.db $b0 $f0 $c4 $09
	.db $b0 $f8 $c6 $09
	.db $b0 $00 $c8 $09
	.db $b0 $08 $ca $09
	.db $b0 $10 $cc $09
	.db $b0 $18 $ce $09
	.db $b0 $20 $d0 $09
	.db $b0 $28 $d2 $09
	.db $ce $e0 $d4 $09
	.db $ce $e8 $d6 $09
	.db $ce $f0 $d8 $09
	.db $ce $f8 $da $09
	.db $ce $00 $dc $09
	.db $ce $08 $de $09
	.db $ce $10 $e0 $09
	.db $ce $18 $e2 $09
	.db $ce $20 $e4 $09
	.db $de $e0 $e6 $09
	.db $de $e8 $e8 $09
	.db $de $f0 $ea $09
	.db $de $f8 $ec $09
	.db $de $00 $ee $09
	.db $de $08 $f0 $09
	.db $de $10 $f2 $09
	.db $de $18 $f4 $09
	.db $de $20 $f6 $09
	.db $de $28 $f8 $09
	.db $ce $28 $f8 $09
	.db $f8 $e5 $02 $00
	.db $f8 $ed $10 $00
	.db $f8 $f5 $16 $00
	.db $f8 $fd $16 $00
	.db $08 $fd $26 $00
	.db $08 $05 $22 $00
	.db $08 $0d $10 $00
	.db $08 $15 $1a $00
	.db $08 $1d $08 $00
	.db $08 $24 $1a $00

@data8:
	.db $1a
	.db $a8 $f8 $50 $01
	.db $a8 $00 $52 $01
	.db $b0 $08 $7e $01
	.db $a8 $10 $50 $01
	.db $b8 $ec $6c $01
	.db $b8 $f4 $6a $01
	.db $b8 $fc $70 $01
	.db $b8 $04 $76 $01
	.db $b8 $0c $64 $01
	.db $b8 $1c $6e $01
	.db $b8 $14 $68 $01
	.db $d8 $d8 $26 $00
	.db $d8 $e0 $08 $00
	.db $d8 $e8 $22 $00
	.db $d8 $f0 $08 $00
	.db $d8 $f8 $24 $00
	.db $d8 $00 $00 $00
	.db $e8 $fa $16 $00
	.db $e8 $01 $10 $00
	.db $e8 $08 $16 $00
	.db $e8 $10 $16 $00
	.db $e8 $18 $30 $00
	.db $e8 $20 $0c $00
	.db $e8 $28 $22 $00
	.db $e8 $30 $08 $00
	.db $e8 $37 $1a $00

@data9:
	.db $28
	.db $a8 $e0 $e6 $09
	.db $a8 $e8 $e8 $09
	.db $a8 $f0 $ea $09
	.db $a8 $f8 $ec $09
	.db $a8 $10 $f2 $09
	.db $a8 $18 $f4 $09
	.db $a8 $20 $f6 $09
	.db $a8 $28 $f8 $09
	.db $a8 $00 $fa $09
	.db $a8 $08 $fc $09
	.db $b8 $e8 $7a $01
	.db $b8 $f0 $74 $01
	.db $b8 $f8 $7a $01
	.db $b8 $00 $72 $01
	.db $b8 $08 $6c $01
	.db $b8 $20 $74 $01
	.db $b8 $28 $76 $01
	.db $d0 $dc $16 $00
	.db $d0 $e4 $08 $00
	.db $d0 $ec $24 $00
	.db $d0 $f4 $16 $00
	.db $d0 $fc $10 $00
	.db $d0 $04 $08 $00
	.db $d0 $14 $24 $00
	.db $d0 $1c $2c $00
	.db $d0 $24 $00 $00
	.db $d0 $2c $1a $00
	.db $f0 $dc $12 $00
	.db $f0 $e4 $08 $00
	.db $f0 $ec $0a $00
	.db $f0 $f4 $0a $00
	.db $f0 $04 $18 $00
	.db $f0 $0c $10 $00
	.db $f0 $14 $16 $00
	.db $f0 $1c $16 $00
	.db $f0 $24 $08 $00
	.db $f0 $2c $22 $00
	.db $b8 $18 $6c $01
	.db $b8 $10 $fe $09
	.db $b8 $e0 $fe $09


; Used in CUTSCENE_BLACK_TOWER_ESCAPE
; @addr{4d05}
oamData_4d05:
	.db $26
	.db $e0 $10 $02 $01
	.db $e0 $18 $04 $01
	.db $e0 $20 $06 $01
	.db $e0 $28 $08 $01
	.db $f0 $08 $14 $01
	.db $f0 $10 $16 $01
	.db $f0 $18 $18 $01
	.db $f0 $20 $1a $01
	.db $f0 $28 $1c $01
	.db $00 $08 $28 $01
	.db $00 $10 $2a $01
	.db $00 $18 $2c $01
	.db $00 $20 $2e $01
	.db $00 $28 $30 $01
	.db $10 $08 $3a $01
	.db $10 $10 $3c $01
	.db $10 $18 $3e $01
	.db $10 $20 $40 $01
	.db $10 $28 $42 $01
	.db $20 $08 $00 $01
	.db $20 $10 $0a $01
	.db $20 $18 $0c $01
	.db $20 $20 $0e $01
	.db $20 $28 $10 $01
	.db $30 $08 $1e $01
	.db $30 $10 $20 $01
	.db $30 $18 $22 $01
	.db $30 $20 $24 $01
	.db $30 $28 $26 $01
	.db $40 $08 $32 $01
	.db $40 $10 $34 $01
	.db $40 $18 $36 $01
	.db $50 $08 $44 $01
	.db $50 $10 $46 $01
	.db $50 $18 $48 $01
	.db $40 $20 $38 $01
	.db $60 $08 $00 $01
	.db $60 $10 $12 $01

; Used by CUTSCENE_BLACK_TOWER_ESCAPE
; @addr{4d9e}
oamData_4d9e:
	.db $26
	.db $e0 $f8 $02 $21
	.db $e0 $f0 $04 $21
	.db $e0 $e8 $06 $21
	.db $e0 $e0 $08 $21
	.db $f0 $00 $14 $21
	.db $f0 $f8 $16 $21
	.db $f0 $f0 $18 $21
	.db $f0 $e8 $1a $21
	.db $f0 $e0 $1c $21
	.db $00 $00 $28 $21
	.db $00 $f8 $2a $21
	.db $00 $f0 $2c $21
	.db $00 $e8 $2e $21
	.db $00 $e0 $30 $21
	.db $10 $00 $3a $21
	.db $10 $f8 $3c $21
	.db $10 $f0 $3e $21
	.db $10 $e8 $40 $21
	.db $10 $e0 $42 $21
	.db $20 $00 $00 $21
	.db $20 $f8 $0a $21
	.db $20 $f0 $0c $21
	.db $20 $e8 $0e $21
	.db $20 $e0 $10 $21
	.db $30 $00 $1e $21
	.db $30 $f8 $20 $21
	.db $30 $f0 $22 $21
	.db $30 $e8 $24 $21
	.db $30 $e0 $26 $21
	.db $40 $00 $32 $21
	.db $40 $f8 $34 $21
	.db $40 $f0 $36 $21
	.db $50 $00 $44 $21
	.db $50 $f8 $46 $21
	.db $50 $f0 $48 $21
	.db $40 $e8 $38 $21
	.db $60 $00 $00 $21
	.db $60 $f8 $12 $21

; @addr{4e37}
_oamData_4e37:
	.db $28
	.db $44 $21 $00 $00
	.db $44 $29 $02 $00
	.db $54 $29 $04 $00
	.db $34 $1b $06 $00
	.db $50 $d9 $08 $00
	.db $08 $e0 $0a $00
	.db $30 $d8 $0c $01
	.db $20 $d1 $0e $00
	.db $fb $ee $10 $02
	.db $fb $f6 $12 $02
	.db $0b $e6 $14 $02
	.db $0b $ee $16 $02
	.db $1b $e6 $18 $02
	.db $1b $ee $1a $02
	.db $00 $48 $1c $01
	.db $58 $40 $1e $00
	.db $10 $58 $22 $01
	.db $00 $50 $20 $01
	.db $38 $50 $24 $01
	.db $28 $50 $26 $03
	.db $28 $58 $28 $03
	.db $16 $4a $2a $04
	.db $16 $52 $2c $04
	.db $e8 $d0 $2e $01
	.db $f8 $d0 $30 $04
	.db $f8 $d8 $32 $04
	.db $00 $da $34 $02
	.db $e8 $e5 $36 $01
	.db $20 $0f $38 $04
	.db $20 $20 $3a $04
	.db $db $38 $40 $07
	.db $db $40 $42 $07
	.db $e8 $35 $44 $07
	.db $e8 $3d $46 $07
	.db $fc $30 $48 $07
	.db $f8 $38 $4a $07
	.db $00 $40 $4c $07
	.db $18 $38 $4e $07
	.db $10 $40 $50 $07
	.db $20 $40 $52 $07

; @addr{4ed8}
_oamData_4ed8:
	.db $12
	.db $10 $08 $00 $0c
	.db $10 $10 $02 $0c
	.db $10 $18 $04 $0c
	.db $20 $08 $0c $0c
	.db $20 $10 $0e $0c
	.db $20 $18 $10 $0c
	.db $31 $23 $06 $0d
	.db $31 $2b $08 $0d
	.db $31 $3b $06 $2d
	.db $31 $33 $08 $2d
	.db $41 $23 $06 $4d
	.db $41 $2b $08 $4d
	.db $41 $3b $06 $6d
	.db $41 $33 $08 $6d
	.db $2c $1d $0a $0d
	.db $2c $25 $0a $2d
	.db $4c $3a $0a $0d
	.db $4c $42 $0a $2d

; @addr{4f21}
_oamData_4f21:
	.db $0d
	.db $38 $d3 $02 $03
	.db $32 $f8 $0c $01
	.db $f8 $d8 $10 $07
	.db $f8 $e0 $12 $07
	.db $f8 $e8 $14 $07
	.db $f7 $f7 $16 $07
	.db $22 $f8 $1a $03
	.db $1a $00 $1c $03
	.db $11 $e2 $1e $00
	.db $11 $ea $20 $00
	.db $01 $ea $22 $00
	.db $11 $f2 $26 $00
	.db $01 $f2 $24 $00

; @addr{4f56}
_oamData_4f56:
	.db $07
	.db $60 $f8 $00 $02
	.db $48 $d3 $04 $03
	.db $40 $e0 $06 $07
	.db $40 $e8 $08 $07
	.db $40 $f0 $0a $07
	.db $42 $f8 $0e $01
	.db $68 $e0 $18 $02

; @addr{4f73}
_oamData_4f73:
	.db $1e
	.db $e8 $e8 $00 $06
	.db $e8 $f0 $02 $06
	.db $f8 $e0 $04 $06
	.db $00 $d8 $06 $06
	.db $08 $e8 $08 $06
	.db $08 $f0 $0a $06
	.db $f8 $f6 $0c $06
	.db $10 $e0 $0e $06
	.db $18 $e8 $10 $07
	.db $18 $da $12 $04
	.db $18 $e2 $14 $04
	.db $08 $d0 $16 $06
	.db $40 $d8 $18 $06
	.db $30 $f8 $1a $04
	.db $28 $d3 $1c $00
	.db $f0 $f8 $1e $00
	.db $48 $f8 $20 $04
	.db $36 $f5 $22 $04
	.db $58 $00 $24 $05
	.db $3b $18 $26 $05
	.db $3b $20 $28 $05
	.db $38 $3c $2a $03
	.db $14 $38 $2c $05
	.db $28 $48 $2e $00
	.db $30 $51 $30 $00
	.db $30 $60 $32 $00
	.db $28 $68 $34 $04
	.db $f8 $40 $36 $00
	.db $00 $48 $38 $00
	.db $00 $50 $3a $05

; @addr{4fec}
_oamData_4fec:
	.db $0a
	.db $48 $4d $88 $05
	.db $48 $55 $8a $05
	.db $47 $45 $84 $03
	.db $47 $4d $86 $03
	.db $39 $4e $90 $03
	.db $43 $59 $8c $03
	.db $39 $46 $8e $03
	.db $3b $3c $92 $03
	.db $49 $4c $80 $02
	.db $49 $54 $82 $02

.ends


.include "code/staticObjects.s"
.include "build/data/staticDungeonObjects.s"
.include "build/data/chestData.s"

 m_section_force Bank16_2 NAMESPACE bank16

.include "build/data/treasureObjectData.s"

;;
; Used in the room in present Mermaid's Cave with the changing floor
;
; @param	b	Floor state (0/1)
; @addr{5766}
loadD6ChangingFloorPatternToBigBuffer:
	ld a,b			; $5766
	add a			; $5767
	ld hl,@changingFloorData		; $5768
	rst_addDoubleIndex			; $576b
	push hl			; $576c
	ldi a,(hl)		; $576d
	ld d,(hl)		; $576e
	ld e,a			; $576f
	ld b,$41		; $5770
	ld hl,wBigBuffer		; $5772
	call copyMemoryReverse		; $5775

	pop hl			; $5778
	inc hl			; $5779
	inc hl			; $577a
	ldi a,(hl)		; $577b
	ld d,(hl)		; $577c
	ld e,a			; $577d
	ld b,$41		; $577e
	ld hl,wBigBuffer+$80		; $5780
	call copyMemoryReverse		; $5783

	ldh a,(<hActiveObject)	; $5786
	ld d,a			; $5788
	ret			; $5789

@changingFloorData:
	.dw @tiles0_bottomHalf
	.dw @tiles0_topHalf

	.dw @tiles1
	.dw @tiles1

@tiles0_bottomHalf:
	.db $a0 $a0 $a0 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4
	.db $00

@tiles0_topHalf:
	.db $a0 $a0 $a0 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $a0 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $a0 $f4 $f4 $f4 $f4 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $a0 $ff
	.db $a0 $a0 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $ff
	.db $f4 $f4 $f4 $f4
	.db $00

@tiles1:
	.db $a0 $a0 $f4 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $a0 $a0 $f4 $f4 $f4 $f4 $f4 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $a0 $a0 $a0 $f4 $f4 $a0 $ff
	.db $a0 $a0 $f4 $a0
	.db $00

.ends

.include "build/data/interactionAnimations.s"
.include "build/data/partAnimations.s"

.BANK $17 SLOT 1 ; Seasons: should be bank $16
.ORG 0

	.include "build/data/paletteData.s"
	.include "build/data/tilesetCollisions.s"
	.include "build/data/smallRoomLayoutTables.s"


.ifdef ROM_AGES
.ifdef BUILD_VANILLA

	; Leftovers from seasons. No clue what it actually is though.
	; @addr{6ee3}

	.db     $dc $56 $57 $cc $dc $dc $57
	.db $cc $47 $dc $57 $46 $47 $47 $dc
	.db $6b $30 $7b $22 $31 $6b $22 $7b
	.db $46 $47 $34 $34 $34 $34 $24 $25
	.db $cc $cc $6b $6b $4a $4b $3a $3b
	.db $67 $67 $77 $77 $76 $66 $67 $70
	.db $66 $76 $70 $67 $77 $71 $62 $62
	.db $71 $77 $62 $62 $21 $21 $31 $30
	.db $21 $21 $30 $31 $27 $26 $37 $36
	.db $2d $2c $3d $3c $2b $2a $3b $3a
	.db $44 $44 $54 $54 $45 $45 $55 $55
	.db $4c $4d $5c $5d $2e $2f $2e $2f
	.db $2f $2e $2f $2e $53 $53 $53 $53
	.db $6e $6c $67 $70 $6c $6e $70 $67
	.db $76 $76 $76 $76 $72 $73 $64 $65
	.db $60 $68 $70 $78 $4a $4b $80 $80
	.db $5a $5b $80 $80 $2e $2e $3e $3e
	.db $71 $71 $61 $61 $71 $71 $53 $53
	.db $74 $75 $63 $63 $71 $71 $62 $62
	.db $cc $cc $2a $2b $5c $5c $5c $5c
	.db $68 $6f $7e $5f $6f $6e $4f $4e
	.db $7d $7c $4c $4d $6e $6f $4e $4f
	.db $3c $3d $3e $3f $5e $5e $65 $66
	.db $65 $66 $5e $5e $5c $5c $6c $6c
	.db $64 $6f $7e $7f $34 $35 $36 $37
	.db $35 $34 $37 $36 $38 $39 $3a $3b
	.db $39 $38 $3b $3a $0b $0b $0b $0b
	.db $6f $7c $52 $51 $7d $7c $55 $56
	.db $7d $7c $7c $7d $6e $6f $51 $52
	.db $40 $41 $43 $44 $42 $74 $45 $75
	.db $46 $47 $49 $4a $48 $50 $4b $59
	.db $74 $42 $75 $45 $41 $40 $44 $43
	.db $50 $48 $59 $4b $47 $46 $4a $49
	.db $78 $69 $7a $7b $69 $78 $7b $7a
	.db $6f $57 $5f $7e $58 $7c $53 $56
	.db $7d $67 $55 $54 $31 $32 $33 $33
	.db $32 $31 $33 $33 $03 $07 $12 $07
	.db $06 $19 $11 $02 $79 $78 $7b $7a
	.db $77 $76 $7a $7b $76 $77 $7b $7a
	.db $78 $79 $7a $7b $5e $5e $5e $5e
	.db $6f $64 $7f $7e $6f $6e $5f $7e
	.db $6e $6f $7e $5f $71 $71 $71 $71
	.db $72 $72 $72 $72 $73 $73 $73 $73
	.db $5d $5d $6d $6d $18 $11 $15 $16
	.db $11 $18 $17 $15 $33 $83 $8e $8f
	.db $83 $33 $8e $8f $18 $18 $07 $03
	.db $6f $6e $52 $51 $18 $19 $15 $11
	.db $19 $18 $11 $15 $38 $38 $38 $38
	.db $39 $39 $39 $39 $3a $3a $3a $3a
	.db $3b $3b $3b $3b $39 $3a $3b $3b
	.db $3a $39 $3b $3b $da $0d $0d $db
	.db $fc $fc $fc $fc $ed $ed $ed $ed
	.db $ec $ec $ec $ec $80 $a3 $a3 $1f
	.db $80 $a3 $1f $80 $0b $0c $1c $1d
	.db $0c $0b $1d $1c $0c $0c $1d $1d
	.db $1b $1b $1b $1b $9a $9a $9a $9a
	.db $98 $98 $9b $9b $99 $98 $9a $ed
	.db $98 $98 $ed $ed $98 $99 $ed $9a
	.db $9a $ed $9a $ed $ed $9a $ed $9a
	.db $9a $ed $9c $9b $ed $ed $9b $9b
	.db $ed $9a $9b $9c $5f $5e $cb $cc
	.db $aa $aa $aa $aa $05 $c4 $25 $c4
	.db $a8 $a8 $a8 $a8 $c7 $c6 $d7 $d6
	.db $c4 $05 $c4 $25 $46 $30 $46 $2a
	.db $31 $32 $2b $2b $33 $46 $2c $46
	.db $44 $45 $46 $20 $45 $45 $21 $22
	.db $45 $44 $23 $46 $d5 $d5 $78 $78
	.db $e4 $e5 $b2 $b3 $e5 $e4 $b2 $b3
	.db $e7 $e6 $f7 $f6 $49 $49 $49 $49
	.db $46 $3a $54 $55 $3b $3b $55 $55
	.db $3c $46 $55 $54 $46 $30 $46 $40
	.db $31 $32 $41 $42 $33 $46 $43 $46
	.db $46 $30 $46 $60 $31 $32 $61 $62
	.db $33 $46 $63 $46 $dd $b0 $d8 $c0
	.db $b1 $d9 $c1 $de $07 $06 $17 $16
	.db $e1 $d9 $d9 $de $46 $30 $46 $2d
	.db $31 $32 $2e $2e $33 $46 $2f $46
	.db $46 $50 $54 $55 $51 $52 $55 $55
	.db $53 $46 $55 $54 $46 $70 $54 $55
	.db $71 $72 $55 $55 $73 $46 $55 $54
	.db $26 $27 $d8 $d9 $28 $28 $dd $de
	.db $de $d0 $d9 $e0 $d1 $dd $e1 $d8
	.db $f1 $f2 $f3 $f4 $27 $26 $dc $dd
	.db $de $e0 $dd $dc $46 $3d $54 $55
	.db $3e $3e $55 $55 $3f $46 $55 $54
	.db $64 $6d $74 $7d $6d $64 $7d $74
	.db $35 $36 $37 $38 $e5 $e5 $b2 $24
	.db $e5 $e5 $04 $b3 $47 $65 $57 $75
	.db $6f $48 $7f $58 $47 $48 $47 $48
	.db $5f $5e $5a $5a $4a $4a $4f $4e
	.db $4b $5b $5c $5d $4a $4d $5a $5d
	.db $47 $49 $47 $49 $d8 $d9 $dd $de
	.db $dd $de $d8 $d9 $d9 $d8 $de $dd
	.db $de $dd $d9 $d8 $de $d9 $dc $de
	.db $c2 $34 $d2 $d3 $14 $c3 $d2 $d3
	.db $e2 $e3 $de $dd $a9 $a9 $a9 $a9
	.db $5f $5b $4f $5b $4b $5e $4b $4e
	.db $4c $4d $4b $5b $4c $4a $5c $5a
	.db $47 $49 $57 $59 $4b $5e $5c $5a
	.db $5f $5b $5a $5d $49 $48 $49 $48
	.db $49 $65 $59 $75 $6f $49 $7f $59
	.db $6a $69 $02 $02 $6a $6c $01 $7b
	.db $13 $7a $00 $02 $6a $7c $01 $7b
	.db $6b $7b $7b $6b $7b $6b $6b $7b
	.db $7a $69 $6b $7a $6a $69 $69 $6a
	.db $6c $6b $69 $7c $6b $6c $7c $69
	.db $03 $6b $13 $7b $13 $6b $13 $7b
	.db $02 $01 $7a $13 $5c $5d $57 $58
	.db $7a $7b $69 $7a $02 $02 $69 $6a
	.db $01 $6b $69 $6c $00 $02 $13 $7a
	.db $6c $69 $7b $01 $6b $13 $7b $13
	.db $7b $7a $7a $6a $6a $7c $6c $7b
	.db $7c $69 $7b $6c $13 $6b $12 $7b
	.db $6a $7a $7a $6b $7a $13 $02 $01
	.db $b4 $b5 $c4 $a8 $b5 $b6 $a8 $c6
	.db $b7 $4c $c7 $4b $4d $b7 $5b $c7
	.db $b6 $b5 $c6 $a8 $b5 $b4 $a8 $c4
	.db $c4 $a8 $d4 $d5 $a8 $d6 $d5 $d5
	.db $dc $77 $dd $56 $77 $d8 $56 $de
	.db $dd $44 $50 $51 $d8 $d9 $dc $47
	.db $dc $dd $48 $48 $de $d8 $46 $d9
	.db $dd $de $d8 $5b $dd $60 $d9 $70
	.db $de $63 $d8 $73 $d9 $dd $d8 $5e
	.db $de $d9 $5f $5f $d8 $de $5e $de
	.db $d8 $de $5b $d9 $60 $d9 $70 $dd
	.db $63 $de $73 $dc $ac $ac $ac $ac
	.db $ad $ad $ad $ad $4c $4a $4b $4e
	.db $4b $5b $4b $5b $4a $4d $4f $5b
	.db $d7 $5c $d5 $d5 $5d $d7 $d5 $d5
	.db $d6 $a8 $d5 $d5 $a8 $c4 $d5 $d4
	.db $96 $97 $a6 $a7 $ab $ab $ab $ab
	.db $be $be $a0 $a1 $ed $ed $17 $16
	.db $80 $80 $17 $16 $ea $ea $fa $fa
	.db $e5 $e5 $83 $83 $9d $9d $c8 $c8
	.db $b8 $b8 $c8 $c8 $8c $8e $8d $8f
	.db $f3 $f4 $f1 $f2 $f1 $f2 $f1 $f2
	.db $df $df $f0 $f0 $df $df $df $df
	.db $07 $01 $c4 $17 $01 $07 $16 $c4
	.db $04 $04 $fd $fd $fd $fd $14 $14
	.db $05 $17 $c4 $16 $16 $05 $17 $c4
	.db $02 $01 $09 $13 $01 $02 $13 $09
	.db $0a $1a $1a $0a $06 $19 $07 $11
	.db $19 $06 $11 $07 $05 $05 $c4 $c4
	.db $b4 $b1 $c0 $c1 $b2 $b7 $c2 $c3
	.db $9e $9f $ae $af $d0 $d1 $e0 $e1
	.db $d2 $d3 $e2 $e3 $61 $62 $71 $72
	.db $62 $61 $72 $71 $02 $11 $69 $6a
	.db $11 $02 $69 $6a $6a $69 $02 $11
	.db $6a $69 $11 $02 $d9 $dd $df $df
	.db $16 $92 $17 $93 $92 $17 $93 $16
	.db $66 $76 $5c $5d $d9 $d8 $df $df
	.db $76 $66 $5d $5c $dd $b5 $c7 $c5
	.db $b6 $de $c6 $c7 $d4 $d5 $e4 $e5
	.db $d6 $d7 $e6 $e7 $09 $13 $02 $01
	.db $94 $95 $a4 $a5 $99 $98 $9c $9b
	.db $99 $99 $9c $9c $98 $99 $9b $9c
	.db $9a $9a $9c $9c $99 $99 $9a $9a
	.db $eb $eb $fb $fb $90 $90 $91 $91
	.db $45 $45 $52 $4c $4f $4e $4d $4b
	.db $53 $54 $56 $57 $54 $53 $57 $56
	.db $69 $6a $7b $81 $6a $69 $81 $7b
	.db $7b $81 $79 $7a $81 $81 $7a $7a
	.db $81 $7b $7a $79 $55 $55 $58 $58
	.db $54 $60 $5d $70 $65 $54 $75 $5d
	.db $5d $79 $58 $57 $56 $59 $57 $57
	.db $59 $59 $57 $57 $59 $56 $57 $57
	.db $5d $50 $5d $5a $4d $4e $dd $de
	.db $4f $5d $55 $5d $6f $7c $6f $7c
	.db $55 $5d $55 $5d $51 $4c $5b $5c
	.db $5d $55 $5d $55 $4d $4e $d8 $d9
	.db $dc $52 $dd $55 $56 $5d $81 $5d
	.db $6f $6c $6f $6c $7c $7c $06 $03
	.db $d9 $de $59 $59 $d9 $55 $59 $6a
	.db $81 $5d $57 $58 $5d $56 $5d $69
	.db $52 $5f $55 $dd $5e $55 $de $55
	.db $69 $5d $79 $5d $6f $66 $7f $76
	.db $5e $5f $dd $de $5e $5f $d8 $d9
	.db $19 $4e $02 $5e $4e $19 $5e $02
	.db $78 $48 $57 $58 $4d $4d $5d $5d
	.db $4c $4b $5c $5b $50 $66 $60 $51
	.db $67 $68 $52 $53 $68 $67 $53 $52
	.db $66 $50 $51 $60 $63 $62 $74 $75
	.db $61 $60 $76 $70 $55 $54 $65 $64
	.db $6a $6b $6a $7b $75 $5a $57 $56
	.db $79 $79 $56 $56 $5a $75 $56 $57
	.db $6b $6a $7b $6a $bb $bc $58 $73
	.db $bb $bc $72 $71 $bb $bc $70 $70
	.db $bb $bc $71 $72 $bb $bc $73 $58
	.db $59 $51 $6a $5d $63 $62 $5c $5b
	.db $4a $4b $5b $5b $62 $63 $5b $5c
	.db $51 $59 $5d $6a $dd $b5 $c4 $c5
	.db $7a $6b $6a $7b $53 $52 $55 $54
	.db $52 $53 $54 $55 $6b $7a $7b $6a
	.db $f6 $f6 $f7 $f7 $61 $60 $6a $7b
	.db $60 $60 $65 $5a $60 $60 $69 $69
	.db $60 $60 $5a $65 $60 $61 $7b $7a
	.db $6a $5e $6e $cc $5f $6a $cb $6f
	.db $50 $50 $4c $4d $83 $83 $e8 $e9
	.db $d2 $d3 $94 $95 $d5 $d4 $d6 $d7
	.db $d4 $d5 $d7 $d6 $83 $d7 $83 $83
	.db $d7 $83 $83 $83 $83 $83 $83 $d5
	.db $d6 $d6 $d4 $d4 $83 $83 $d5 $83
	.db $d6 $d6 $83 $83 $d8 $d9 $d8 $d9
	.db $da $db $d8 $d9 $dc $dd $d8 $d9
	.db $50 $51 $52 $53 $f2 $f2 $02 $02
	.db $f3 $f3 $03 $03 $1a $1b $1c $1d
	.db $16 $17 $18 $19 $24 $25 $26 $27
	.db $20 $21 $22 $23 $90 $91 $90 $91
	.db $92 $93 $92 $93 $08 $09 $08 $09
	.db $d1 $d1 $82 $82 $0c $0d $0e $0f
	.db $82 $82 $0e $0f $0f $0e $0e $0f
	.db $45 $46 $46 $45 $47 $48 $49 $4a
	.db $4b $4c $4d $4e $8e $8f $9e $9f
	.db $96 $97 $98 $99 $04 $05 $98 $99
	.db $f4 $f5 $98 $99 $98 $99 $98 $99
	.db $a3 $a2 $a7 $a6 $a1 $a0 $a5 $a4
	.db $a0 $a1 $a4 $a5 $a2 $a3 $a6 $a7
	.db $a9 $a8 $ae $bc $a8 $a9 $bc $bd
	.db $a8 $a9 $bc $be $12 $13 $ae $bc
	.db $12 $13 $bc $bd $13 $12 $bc $be
	.db $a8 $a9 $b8 $b9 $12 $13 $14 $15
	.db $a8 $a8 $be $be $12 $12 $be $be
	.db $f0 $f1 $00 $01 $aa $ab $ba $bb
	.db $ba $bb $aa $ab $28 $29 $2a $2b
	.db $be $ac $ae $bc $ad $ae $bd $af
	.db $be $ac $ae $be $ac $ac $bc $be
	.db $ad $ad $be $bd $ad $ae $be $be
	.db $be $ad $bc $bd $ac $be $bc $bd
	.db $be $be $bc $bd $b2 $41 $ac $ad
	.db $40 $41 $ac $ad $b0 $f7 $ac $ad
	.db $f6 $f7 $ac $ad $96 $97 $54 $54
	.db $be $ac $b9 $b8 $ad $ac $b8 $b9
	.db $ad $bf $b8 $b9 $be $bf $b8 $b8
	.db $be $bf $14 $14 $be $ac $15 $14
	.db $ad $ac $14 $15 $ad $bf $14 $15
	.db $ea $eb $fa $fb $55 $eb $fa $fb
	.db $8c $8d $9c $9d $83 $83 $9c $9d
	.db $b4 $b5 $c4 $c5 $b5 $b4 $c5 $c4
	.db $58 $59 $56 $57 $59 $58 $57 $56
	.db $b2 $b3 $e2 $c7 $b2 $b3 $c6 $e3
	.db $b2 $b3 $c6 $c7 $b2 $b3 $e2 $e3
	.db $e0 $b7 $e2 $c7 $b7 $b6 $c7 $c6
	.db $b6 $b7 $c6 $c7 $b6 $e1 $c6 $e3
	.db $e0 $e1 $c2 $c3 $e0 $e1 $e2 $e3
	.db $e0 $b7 $c6 $c7 $b6 $e1 $c6 $c7
	.db $1e $1f $10 $11 $2c $2d $2e $2f
	.db $30 $31 $34 $35 $32 $33 $36 $37
	.db $42 $43 $44 $35 $0e $0e $0e $0e
	.db $28 $28 $28 $28 $4c $6c $0c $2c
	.db $0c $0c $0c $0c $08 $28 $08 $28
	.db $28 $28 $08 $28 $2d $2d $0d $2d
	.db $0d $0d $0d $2d $0c $2c $0c $2c
	.db $0e $2e $0e $2e $0a $0a $0a $0a
	.db $2a $0a $2a $0a $0f $0f $0f $0f
	.db $0d $0d $0d $0d $0b $0b $0b $0b
	.db $2b $2b $2b $2b $4b $4b $4b $4b
	.db $0b $2b $0b $2b $6b $6b $2b $2b
	.db $4b $6b $4b $6b $4b $4b $0b $0b
	.db $0c $0a $0c $0a $0a $0c $0a $0c
	.db $4c $4c $4c $4c $0a $2a $4a $6a
	.db $2c $2c $2c $2c $2c $0c $2c $0c
	.db $08 $08 $0c $2c $0c $2c $08 $08
	.db $2c $08 $2c $08 $08 $2c $08 $2c
	.db $0d $2d $0d $2d $6d $6d $2d $2d
	.db $4d $6d $4d $6d $4d $4d $0d $0d
	.db $2d $2d $6d $6d $0d $0d $4d $4d
	.db $6d $2d $2d $6d $0d $4d $4d $0d
	.db $2d $0a $0a $0a $0a $2a $0a $2a
	.db $2a $2d $2a $2a $0a $0a $4a $4a
	.db $2a $2a $6a $6a $4a $4a $2d $4a
	.db $4a $6a $4a $6a $6a $6a $6a $2d
	.db $0a $6a $0a $2a $4e $6e $4e $6e
	.db $08 $08 $08 $08 $0e $0e $0c $0e
	.db $0e $0e $0e $0c $0c $0c $0e $0e
	.db $0c $0c $0e $0c $0c $0e $0c $0e
	.db $0e $0c $0e $0c $0e $0e $0c $0c
	.db $0e $0c $0c $0c $0c $0c $0c $0e
	.db $0c $0e $0c $0c $0c $0e $0e $0e
	.db $0e $0c $0e $0e $0d $2d $4d $6d
	.db $0e $2e $4e $6e $6b $6b $6b $6b
	.db $08 $08 $0e $0e $0e $08 $0e $08
	.db $4e $4e $08 $08 $08 $2e $08 $2e
	.db $0b $0c $0b $0c $2c $2c $2b $2b
	.db $4b $4c $4b $4c $0c $0c $0b $0b
	.db $0e $0e $0e $0d $0e $0e $0d $2d
	.db $0e $0e $2d $0e $0e $0d $0c $0c
	.db $2d $0e $2c $2c $2c $2c $08 $08
	.db $08 $08 $2c $2c $0f $2f $0f $2f
	.db $4a $4a $4a $4a $2a $2a $2a $2a
	.db $4e $6e $0e $2e $2b $0c $2b $0c
	.db $0e $2a $0e $0a $0a $2e $2a $2e
	.db $0e $2a $0e $0e $0a $2e $0e $2e
	.db $0a $2a $0e $0e $0a $2a $2a $0a
	.db $4d $4d $4d $4d $2d $2d $2d $2d
	.db $0e $6e $0e $2e $0c $2c $4c $6c
	.db $08 $08 $0c $0c $0c $08 $0c $08
	.db $4c $4c $08 $08 $0d $2e $0d $0e
	.db $0e $2d $2e $2d $0d $2e $0d $0d
	.db $0e $2d $0d $2d $0e $2e $0d $0d
	.db $0e $2e $2e $0e $2c $2c $0c $0c
	.db $0c $0c $2c $2c $0d $0d $0c $0d
	.db $0d $0d $0d $0c $0c $0c $0d $0d
	.db $0c $0c $0d $0c $0c $0d $0c $0d
	.db $0d $0c $0d $0c $0d $0d $0c $0c
	.db $0d $0c $0c $0c $0c $0c $0c $0d
	.db $0c $0d $0c $0c $0c $0d $0d $0d
	.db $0d $0c $0d $0d $08 $08 $0b $2b
	.db $0b $2b $08 $08 $2b $08 $2b $08
	.db $08 $2b $08 $2b $0b $2b $4b $6b
	.db $2d $0c $0c $0c $2c $2d $2c $2c
	.db $0c $0c $4c $4c $2c $2c $6c $6c
	.db $4c $4c $2d $4c $4c $6c $4c $6c
	.db $6c $6c $6c $2d $0d $6d $0d $2d
	.db $4b $6b $0b $2b $0b $0b $0d $0d
	.db $08 $08 $0b $0b $0b $08 $0b $08
	.db $4b $4b $08 $08 $0e $4d $0c $0c
	.db $0c $2c $0c $0c $68 $68 $0c $0c
	.db $0c $68 $0c $68 $4c $4c $68 $68
	.db $68 $6c $68 $6c $0c $28 $0c $28
	.db $0c $0c $0c $08 $0c $0c $08 $08
	.db $0c $2c $28 $2c $0c $48 $0c $0c
	.db $0c $28 $08 $28 $08 $2c $08 $08
	.db $2d $2d $4d $4d $0d $2d $4d $4d
	.db $0d $0d $4d $6d $68 $2c $0c $2c
	.db $0d $2d $0d $0d $0d $0e $0d $0e
	.db $0e $0d $0e $0d $0d $0e $0d $0d
	.db $0e $0d $0d $0d $0e $0e $0d $0d
	.db $08 $08 $0e $2e $0e $2e $08 $08
	.db $2e $2e $2e $2e $2e $08 $2e $08
	.db $0f $2f $4f $6f $0d $2c $0d $0c
	.db $0c $2d $2c $2d $0d $2c $0d $0d
	.db $0c $2d $0d $2d $0c $2c $0d $0d
	.db $0c $2c $2c $0c $0b $0b $0c $0b
	.db $0b $0b $0b $0c $0c $0c $0b $0c
	.db $0c $0b $0c $0b $0b $0b $0c $0c
	.db $0b $0c $0c $0c $0c $0c $0c $0b
	.db $0b $28 $0b $2b $2b $0b $2b $0b
	.db $28 $2b $2b $2b $2f $6f $0f $4f
	.db $0b $2b $0c $2c $4c $6c $4b $6b
	.db $0e $0e $0e $2e $0e $2e $2e $2e
	.db $0d $2d $08 $08 $2d $0c $2d $0c
	.db $0c $0c $0e $2e $0c $0c $2e $2e
	.db $4b $6b $4b $68 $6b $4b $6b $4b
	.db $6b $6b $68 $6b $2f $2f $2f $2f
	.db $4b $0c $4b $0c $08 $28 $0e $2e
	.db $28 $28 $0e $2e $2c $0f $2c $0f
	.db $0f $2c $0f $2c $4a $2a $4a $2a
	.db $0a $0a $0c $0c $2a $2a $2c $2c
	.db $0b $0b $0f $0f $2f $0f $0f $2f
	.db $2b $0b $0b $0b $0a $2a $0c $0c
	.db $0b $0b $0a $2a $0c $0c $6b $4b
	.db $2d $2d $2c $2d $4d $4c $4d $4d
	.db $6c $6d $6d $6d $0c $0c $4f $4f
	.db $0f $0f $0c $0c $0c $0c $0f $4f
	.db $0c $0c $4f $2f $4f $0f $0c $0c
	.db $0f $6f $0c $0c $0b $2c $0b $0b
	.db $2c $2b $0b $2b $4b $0b $4b $0b
	.db $2b $4b $2b $4b $0c $4b $0c $4b
	.db $0b $2b $0b $4b $2b $2b $4b $4b
	.db $2b $2b $4b $2b $4b $0b $0b $0b
	.db $6c $2c $2c $0c $08 $08 $08 $28
	.db $2d $0d $2d $0d $0c $0d $0d $0c
	.db $2e $0e $2e $0e $0e $2d $2d $2d
	.db $2e $2d $2e $2d $0d $0c $0c $0d
	.db $28 $28 $0d $0d $0d $28 $0d $28
	.db $4d $4d $28 $28 $28 $6d $28 $6d
	.db $8d $8d $8d $8d $2d $2c $0d $2c
	.db $2c $4b $2c $4b $0c $0c $0c $0a
	.db $0c $2c $0a $2c $0c $0c $0a $0a
	.db $2c $2c $0c $2c $0c $0c $0c $2c
	.db $4e $4e $4e $4e $08 $08 $2e $0e
	.db $6e $4e $08 $08 $0b $0b $4b $4b
	.db $0c $0b $2c $2c $2b $2b $2c $2b
	.db $2c $2e $2e $2e $0b $0f $0b $0f
	.db $0f $2b $0f $2b $0b $0b $0b $0f
	.db $2b $2b $0f $2b $0b $0c $0b $0b
	.db $2b $2b $2b $0b $2b $0b $4b $4b
	.db $0c $0c $4b $6b $0b $2c $0b $0c
	.db $2c $2b $0c $2b $0b $0a $0b $0c
	.db $0a $2b $0c $2b $0a $2a $0a $0a
	.db $0a $2a $4a $4a $4a $4a $0a $0a
	.db $0a $0a $4a $6a $2a $2a $4a $4a
	.db $0a $6a $6a $0a $2a $2a $2a $0a
	.db $2a $2c $2a $2c $2a $2a $0c $0c
	.db $0c $0c $2a $2c $0a $0b $0b $0b
	.db $0b $0b $0f $0b $2b $2b $2b $0f
	.db $0c $0b $2a $2c $0b $2b $0f $0f
	.db $0f $2b $2b $2b $0c $0a $0c $0c
	.db $2a $2c $0c $2c $0c $0b $0c $0c
	.db $0c $4a $0c $2c $6a $2c $0c $2c
	.db $0f $2f $0f $0f $0f $0f $2f $0f
	.db $2f $2f $2f $0f $2b $0a $2b $2b
	.db $0d $0d $0a $0d $0f $0e $0f $0f
	.db $0e $0e $0f $0e $2f $2f $0f $0f
	.db $0a $0a $0d $0c $0e $0e $0e $0f
	.db $0e $0f $0f $0f $0d $2d $0c $0c
	.db $0a $0a $0d $0d $0a $0d $2a $0d
	.db $0b $0a $0a $2a $2a $2a $0a $0a
	.db $0f $08 $0b $0a $0c $0b $0d $0d
	.db $0a $0a $2a $0a $0a $0c $0c $0c
	.db $0c $2a $0c $0c $0e $0a $0e $0a
	.db $0a $0c $0d $0c $0c $0a $0c $0d
	.db $0a $2a $0d $0d $0a $0d $0a $0d
	.db $2a $0d $2a $0d $0e $0c $0d $0c
	.db $0c $0d $0c $0e $0a $0d $0a $0a
	.db $0d $0d $0a $0a $0c $0e $0d $0e
	.db $0e $0e $0a $0a $0e $2a $0a $0a
	.db $0c $0d $0e $0e $0c $0b $0e $0e
	.db $0a $08 $0a $0a $08 $2a $0a $2a
	.db $0a $0a $0a $08 $0a $2a $08 $2a
	.db $0d $0d $2d $0d $2d $2d $2d $0d
	.db $2c $2d $0c $0d $0c $2d $0d $0d
	.db $4c $0c $4c $0c $4c $2d $4c $0d
	.db $0d $2c $0d $2c $0d $2d $0a $0a
	.db $0c $08 $08 $28 $08 $28 $0c $2c
	.db $4c $08 $0c $08 $08 $2c $28 $2c
	.db $28 $28 $0c $0c $28 $08 $2c $08
	.db $28 $28 $08 $0c $0c $08 $4c $08
	.db $0c $08 $0c $0c $28 $2c $2c $2c
	.db $0c $0c $2c $0c $08 $28 $0c $0c
	.db $08 $2c $0c $2c $0c $08 $0c $2c
	.db $0c $2c $08 $28 $68 $2c $2c $2c
	.db $0c $0c $08 $28 $2c $08 $4c $08
	.db $08 $0c $08 $2c $2c $0c $4c $4c
	.db $0c $0c $4c $6c $8c $0c $8c $0c
	.db $0f $0f $0f $0d $0f $0f $0d $0d
	.db $0b $0a $0c $0c $0a $2b $0c $0c
	.db $0f $0d $0f $0d $0d $2f $0d $2f
	.db $0f $2f $0d $2f $0f $2f $2f $2f
	.db $0d $8c $0d $8c $0f $0f $0f $2f
	.db $0e $2e $0c $2e $0a $2a $0c $2c
	.db $08 $28 $08 $08 $0d $2d $0a $2a
	.db $0a $0a $0a $2a $0c $2c $2c $2c
	.db $2a $0a $2a $2a $0a $6a $0a $0a
	.db $4a $0a $0a $0a $0e $0e $2e $2e
	.db $2c $0c $0f $0f $0a $0a $0e $0e
	.db $2a $2a $2e $2e $0d $2d $0c $0d
	.db $0c $2d $0d $0c $2c $0c $0c $0c
	.db $0b $2b $0c $0c $8c $8c $0d $8c
	.db $2e $2e $0e $2e $2e $2e $2e $0e
	.db $0b $0b $0b $0a $2b $2b $2a $2b
	.db $2e $0e $0e $2e $2b $2c $2c $2c
	.db $0c $0d $0b $0b $0d $0d $0b $0b
	.db $0d $2c $0b $0b $0c $2c $0f $0f
	.db $0e $2e $0e $0e $0e $0e $4e $4e
	.db $0d $0d $0e $2e $2d $0d $2d $2d
	.db $0d $0b $0b $0b $2a $0b $2b $2b
	.db $0b $0b $0b $2b $0b $2d $0b $2b
	.db $0d $0d $0d $0b $0b $0b $0a $0a
	.db $2b $2b $2a $2a $2d $2d $0b $2d
	.db $0b $0b $0a $0b $2b $0b $2b $2b
	.db $0b $0b $2b $2b $2b $2b $2b $2a
	.db $2d $0d $2b $2d $0b $0a $0b $0b
	.db $0a $0a $0b $0b $0a $0f $0a $0a
	.db $0f $0f $0a $0a $2f $2f $2a $2a
	.db $2f $2a $2a $2a $2a $2a $2b $2b
	.db $28 $08 $28 $08 $0a $2b $2c $2c
	.db $0a $2b $0c $2c $28 $28 $2c $2c
	.db $28 $2c $28 $2c $0c $2c $08 $2c
	.db $2b $2c $4b $2c $0c $2c $2b $2c
	.db $2b $2c $2b $2c $6b $2c $2c $2c
	.db $0c $4b $0c $0c $0c $0c $4b $4b
	.db $2b $0c $2c $0c $0c $8c $8c $8c
	.db $8c $ac $8c $ac $ac $0c $ac $ac
	.db $0c $8c $0c $0c $8c $8c $0c $2c
	.db $ac $ac $0c $2c $ac $0c $2c $0c
	.db $0b $2d $0b $0b $6c $4c $2c $6c
	.db $4c $4c $4c $0c $0d $2b $2b $2b
	.db $2c $2c $2c $0c $0c $0c $28 $28
	.db $08 $2c $68 $08 $2f $0f $2f $2f
	.db $0d $2d $2d $0d $68 $2c $0c $6c
	.db $2d $0d $0d $2d $0d $0d $2d $2d
	.db $0f $2f $0c $0c $0c $0f $0f $0f
	.db $0f $0c $0f $0f $2e $0e $2e $2e
	.db $2b $0b $0d $2d $0b $0b $0d $2d
	.db $0d $0d $2b $0b $0d $2d $0b $0b
	.db $eb $8b $eb $8b $8b $8b $8b $8b
	.db $ab $ab $ab $8b $8b $8b $2d $2d
	.db $8b $8b $0d $0d $8b $8b $0d $2d
	.db $ab $8b $0d $2d $0c $0c $0f $0f
	.db $2d $28 $2d $2d $08 $0d $0d $0d
	.db $0f $2f $2f $0f $28 $2c $0c $2c
	.db $0d $0d $0e $0e $0d $2c $0e $0e
	.db $0c $2c $0c $08 $0c $2a $0c $0a
	.db $0a $2c $0a $2c $0a $2c $2c $2c
	.db $2a $2a $0a $2a $0a $2a $0a $2c
	.db $0a $2a $0c $0a $0b $0d $0b $0d
	.db $0d $0b $0d $0b $2d $2d $0b $0b
	.db $0b $0d $0b $0b $8d $ad $8d $ad
	.db $ad $ad $ad $ad $2d $2d $2a $2a
	.db $0d $0d $2b $2b $4c $4c $28 $0c
	.db $08 $4c $68 $08 $08 $0c $08 $0c
	.db $28 $28 $2c $28 $6c $2c $4c $6c
	.db $68 $0c $2c $0c $28 $08 $08 $0c
	.db $6c $4c $2c $08 $0c $4c $4c $4c
	.db $6c $08 $08 $68 $28 $0b $28 $0b
	.db $0b $0c $0d $0c $0b $0b $0b $0d
	.db $0b $0b $2d $0b $2d $0b $2d $0b
	.db $0d $2d $2d $2d $2c $0c $6c $4c
	.db $4c $4c $0c $0c $28 $28 $2c $08
	.db $08 $28 $08 $0c $08 $2c $2c $2c
	.db $08 $68 $0c $2c $08 $28 $2c $2c
	.db $4c $4c $28 $28 $4c $4c $08 $28
	.db $0c $2e $0c $2e $0b $0d $2d $0d
	.db $0d $0b $0d $0d $2c $2c $2c $2d
	.db $08 $08 $28 $28 $08 $28 $28 $28
	.db $08 $08 $28 $08 $0b $28 $0b $28
	.db $28 $08 $08 $08 $2c $2c $0c $08
	.db $0b $0b $08 $08 $0b $08 $08 $28
	.db $28 $08 $28 $28 $08 $08 $08 $0b
	.db $08 $28 $0b $28 $0c $0d $08 $0d
	.db $2d $0c $2d $08 $28 $28 $08 $08
	.db $08 $08 $08 $0c $0e $0e $2e $0e
	.db $2e $2f $2e $2e $0f $0e $0e $0e
	.db $0b $0d $0d $0d $2e $0e $0e $0e
	.db $2e $2e $0e $0e $09 $09 $09 $09
	.db $0f $0f $0b $0b $0f $0f $2f $2f
	.db $6f $6f $0f $6f $6f $4f $6f $4f
	.db $4f $4f $4f $0f $8e $8e $8e $8e
	.db $8c $8c $8c $8c $2a $0a $0a $0a
	.db $0a $0a $2a $2a $ac $ac $ac $ac

.endif
.endif

.BANK $18 SLOT 1 ; Seasons: should be bank $17
.ORG 0

 m_section_superfree Tile_Mappings

	tileMappingIndexDataPointer:
		.dw tileMappingIndexData
	tileMappingAttributeDataPointer:
		.dw tileMappingAttributeData

	tileMappingTable:
		.incbin "build/tileset_layouts/tileMappingTable.bin"
	tileMappingIndexData:
		.incbin "build/tileset_layouts/tileMappingIndexData.bin"
	tileMappingAttributeData:
		.incbin "build/tileset_layouts/tileMappingAttributeData.bin"

.ifdef ROM_AGES
.ifdef BUILD_VANILLA
	; Leftovers from seasons
	; @addr{799e}
	.incbin "build/gfx/gfx_credits_sprites_2.cmp" SKIP 1+$1e
.endif
.endif

.ends


.BANK $19 SLOT 1
.ORG 0

 m_section_superfree "Gfx_19_1" ALIGN $10
	.include "data/ages/gfxDataBank19_1.s"
.ends

 m_section_superfree "Tile_mappings"
	.include "build/data/tilesetMappings.s"
.ends

 m_section_superfree "Gfx_19_2" ALIGN $10
	.include "data/ages/gfxDataBank19_2.s"
.ends


.BANK $1a SLOT 1
.ORG 0


 m_section_free "Gfx_1a" ALIGN $20
	.include "data/gfxDataBank1a.s"
.ends


.BANK $1b SLOT 1
.ORG 0

 m_section_free "Gfx_1b" ALIGN $20
	.include "data/gfxDataBank1b.s"
.ends


.BANK $1c SLOT 1
.ORG 0

	; The first $e characters of gfx_font are blank, so they aren't
	; included in the rom. In order to get the offsets correct, use
	; gfx_font_start as the label instead of gfx_font.

	.define gfx_font_start gfx_font-$e0
	.export gfx_font_start

	m_GfxDataSimple gfx_font_jp ; $70000
	m_GfxDataSimple gfx_font_tradeitems ; $70600
	m_GfxDataSimple gfx_font $e0 ; $70800
	m_GfxDataSimple gfx_font_heartpiece ; $71720

	m_GfxDataSimple map_rings ; $717a0

	.include "build/data/largeRoomLayoutTables.s" ; $719c0

.ifdef ROM_AGES
.ifdef BUILD_VANILLA

	; Leftovers from seasons - part of its text dictionary
	; $73dc0

	.db $62 $65 $66 $6f $72 $65 $00 $53
	.db $70 $69 $72 $69 $74 $00 $57 $65
	.db $27 $72 $65 $20 $00 $48 $6d $6d
	.db $2e $2e $2e $00 $61 $6c $77 $61
	.db $79 $73 $00 $65 $72 $68 $61 $70
	.db $73 $00 $20 $63 $61 $6e $20 $00
	.db $43 $6c $69 $6d $62 $20 $61 $74
	.db $6f $70 $20 $61 $01 $00 $70 $6f
	.db $77 $65 $72 $00 $20 $79 $6f $75
	.db $2e $00 $54 $68 $69 $73 $20 $00
	.db $20 $79 $6f $75 $21 $00 $20 $74
	.db $6f $20 $73 $65 $65 $00 $63 $6f
	.db $75 $72 $61 $67 $65 $00 $77 $61
	.db $6e $74 $20 $74 $6f $00 $20 $74
	.db $68 $61 $6e $6b $73 $00 $75 $73
	.db $68 $72 $6f $6f $6d $00 $20 $4c
	.db $65 $76 $65 $6c $20 $00 $41 $64
	.db $76 $61 $6e $63 $65 $00 $74 $65
	.db $6c $6c $20 $6d $65 $00 $72 $69
	.db $6e $63 $65 $73 $73 $00 $20 $4f
	.db $72 $61 $63 $6c $65 $00 $59 $6f
	.db $75 $27 $6c $6c $20 $00 $61 $6e
	.db $79 $74 $69 $6d $65 $00 $53 $6e
	.db $61 $6b $65 $09 $00 $00 $20 $69
	.db $73 $20 $61 $00 $57 $68 $61 $74
	.db $20 $00 $20 $6d $6f $72 $65 $00
	.db $20 $74 $68 $65 $6d $00 $20 $73
	.db $6f $6d $65 $00 $73 $73 $65 $6e
	.db $63 $65 $00 $63 $68 $61 $6e $67
	.db $65 $00 $72 $65 $74 $75 $72 $6e
	.db $00 $20 $49 $74 $27 $73 $01 $00
	.db $61 $6b $65 $20 $69 $74 $00 $20
	.db $64 $61 $6e $63 $65 $00 $65 $6e
	.db $6f $75 $67 $68 $00 $68 $69 $64
	.db $64 $65 $6e $00 $6f $72 $74 $75
	.db $6e $65 $00 $09 $01 $42 $6f $6d
	.db $62 $00 $09 $00 $21 $0c $18 $01
	.db $00 $74 $68 $69 $6e $67 $00 $74
	.db $68 $69 $73 $20 $00 $73 $20 $6f
	.db $66 $01 $00 $54 $68 $65 $6e $20
	.db $00 $20 $68 $65 $72 $6f $00 $72
	.db $69 $6e $67 $20 $00 $61 $74 $75
	.db $72 $65 $00 $20 $67 $65 $74 $20
	.db $00 $20 $61 $72 $65 $01 $00 $66
	.db $72 $6f $6d $20 $00 $46 $65 $72
	.db $74 $69 $6c $65 $20 $53 $6f $69
	.db $6c $00 $4b $6e $6f $77 $2d $49
	.db $74 $2d $41 $6c $6c $01 $00 $4d
	.db $61 $67 $69 $63 $20 $50 $6f $74
	.db $69 $6f $6e $00 $61 $68 $2c $20
	.db $68 $61 $68 $2c $20 $68 $61 $68
	.db $00 $65 $67 $65 $6e $64 $61 $72
	.db $79 $00 $79 $6f $75 $72 $73 $65
	.db $6c $66 $00 $73 $74 $72 $65 $6e
	.db $67 $74 $68 $00 $70 $72 $65 $63
	.db $69 $6f $75 $73 $00 $20 $79 $6f
	.db $75 $27 $6c $6c $01 $00 $42 $77
	.db $65 $65 $2d $68 $65 $65 $00 $66
	.db $69 $6e $69 $73 $68 $65 $64 $00
	.db $09 $01 $47 $61 $73 $68 $61 $01
	.db $00 $09 $03 $48 $6f $72 $6f $6e
	.db $01 $00 $54 $68 $61 $74 $20 $00
	.db $20 $67 $6f $6f $64 $00 $20 $68
	.db $61 $73 $01 $00 $20 $69 $74 $20
	.db $74 $6f $00 $65 $61 $74 $68 $65
	.db $72 $00 $73 $68 $6f $75 $6c $64
	.db $00 $6d $61 $73 $74 $65 $72 $00
	.db $20 $6d $75 $73 $74 $20 $00 $54
	.db $68 $61 $6e $6b $73 $00 $62 $65
	.db $61 $73 $74 $73 $00 $63 $61 $6c
	.db $6c $65 $64 $00 $62 $65 $74 $74
	.db $65 $72 $00 $74 $72 $61 $76 $65

.endif
.endif

; "build/textData.s" will determine where this data starts.
;   Ages:    1d:4000
;   Seasons: 1c:5c00

	.include "build/textData.s"

	.REDEFINE DATA_ADDR TEXT_END_ADDR
	.REDEFINE DATA_BANK TEXT_END_BANK

	.include "build/data/roomLayoutData.s"
	.include "build/data/gfxDataMain.s"



.BANK $3f SLOT 1
.ORG 0

 m_section_force Bank3f NAMESPACE bank3f

.define BANK_3f $3f

.include "code/loadGraphics.s"
.include "code/treasureAndDrops.s"
.include "code/textbox.s"

; @addr{5951}
data_5951:
	.db $3c $b4 $3c $50 $78 $b4 $3c $3c
	.db $3c $70 $78 $78

.ifdef ROM_AGES

; In Seasons these sprites are located elsewhere

titlescreenMakuSeedSprite:
	.db $13
	.db $48 $90 $62 $06
	.db $42 $8e $68 $06
	.db $51 $7a $56 $04
	.db $50 $82 $74 $04
	.db $58 $7a $6a $07
	.db $58 $82 $6c $07
	.db $58 $8a $6e $07
	.db $54 $8a $54 $03
	.db $54 $82 $52 $03
	.db $54 $7a $50 $03
	.db $64 $7a $70 $03
	.db $64 $82 $72 $03
	.db $64 $8a $70 $23
	.db $40 $86 $66 $06
	.db $40 $7f $64 $06
	.db $41 $70 $60 $06
	.db $55 $76 $5a $06
	.db $44 $68 $5e $26
	.db $74 $00 $46 $02

titlescreenPressStartSprites:
	.db $0a
	.db $80 $2c $38 $00
	.db $80 $34 $3a $00
	.db $80 $3c $3c $00
	.db $80 $44 $3e $00
	.db $80 $4c $3e $00
	.db $80 $5c $3e $00
	.db $80 $64 $40 $00
	.db $80 $6c $42 $00
	.db $80 $74 $3a $00
	.db $80 $7c $40 $00

; Sprites used on the closeup shot of Link on the horse in the intro
linkOnHorseCloseupSprites_2:
	.db $26
	.db $80 $80 $40 $06
	.db $80 $50 $42 $00
	.db $80 $58 $44 $00
	.db $68 $40 $46 $06
	.db $b8 $3d $20 $02
	.db $b8 $45 $22 $02
	.db $b8 $4d $24 $02
	.db $b8 $55 $26 $02
	.db $b8 $5d $28 $02
	.db $90 $28 $2c $02
	.db $90 $30 $2e $02
	.db $80 $30 $2a $02
	.db $20 $78 $48 $05
	.db $58 $68 $00 $02
	.db $58 $70 $02 $02
	.db $68 $68 $04 $02
	.db $48 $70 $06 $02
	.db $5a $40 $08 $01
	.db $5a $48 $0a $01
	.db $5a $50 $0c $01
	.db $38 $88 $0e $04
	.db $30 $78 $10 $04
	.db $30 $80 $12 $04
	.db $40 $80 $14 $04
	.db $50 $76 $16 $04
	.db $50 $7e $18 $04
	.db $41 $62 $1a $03
	.db $80 $28 $1c $02
	.db $a8 $59 $1e $02
	.db $98 $20 $30 $02
	.db $98 $28 $32 $02
	.db $8c $38 $34 $07
	.db $a8 $41 $36 $02
	.db $a8 $49 $38 $02
	.db $a8 $51 $3a $02
	.db $90 $40 $3e $07
	.db $8a $5c $4a $00
	.db $8a $64 $4c $00

; Sprites used to touch up the appearance of the temple in the intro (the scene where
; Link's on a cliff with his horse)
introTempleSprites:
	.db $05
	.db $30 $28 $48 $02
	.db $30 $30 $4a $02
	.db $18 $38 $4c $03
	.db $10 $40 $4e $03
	.db $18 $48 $50 $03


; Used in intro (ages only)
linkOnHorseFacingCameraSprite:
	.db $02
	.db $70 $08 $58 $02
	.db $70 $10 $5a $02

.endif ; ROM_AGES


.include "build/data/objectGfxHeaders.s"
.include "build/data/treeGfxHeaders.s"

.include "build/data/enemyData.s"
.include "build/data/partData.s"
.include "build/data/itemData.s"
.include "build/data/interactionData.s"

.include "build/data/treasureCollectionBehaviours.s"
.include "build/data/treasureDisplayData.s"

; @addr{714c}
oamData_714c:
	.db $10
	.db $c8 $38 $2e $0e
	.db $c8 $40 $30 $0e
	.db $c8 $48 $32 $0e
	.db $c8 $60 $34 $0f
	.db $c8 $68 $36 $0f
	.db $c8 $70 $38 $0f
	.db $d8 $78 $06 $2e
	.db $e8 $80 $00 $0d
	.db $e8 $78 $08 $0e
	.db $e0 $90 $00 $0d
	.db $d8 $a0 $00 $0d
	.db $e8 $30 $04 $0e
	.db $d8 $30 $06 $0e
	.db $f8 $28 $02 $0e
	.db $f0 $18 $00 $2d
	.db $e8 $08 $00 $2d

; @addr{718d}
oamData_718d:
	.db $10
	.db $a8 $38 $12 $0a
	.db $b8 $38 $0e $0f
	.db $c8 $38 $0a $0f
	.db $a8 $70 $14 $0a
	.db $b8 $70 $10 $0a
	.db $c8 $70 $0c $0f
	.db $e8 $80 $00 $0d
	.db $d8 $78 $06 $2e
	.db $e8 $78 $08 $0e
	.db $e0 $90 $00 $0d
	.db $d8 $a0 $00 $0d
	.db $f8 $28 $02 $0e
	.db $f0 $18 $00 $2d
	.db $e8 $08 $00 $2d
	.db $d8 $30 $06 $0e
	.db $e8 $30 $08 $2e

; @addr{71ce}
oamData_71ce:
	.db $0a
	.db $50 $40 $40 $0b
	.db $50 $48 $42 $0b
	.db $50 $50 $44 $0b
	.db $50 $58 $46 $0b
	.db $50 $60 $48 $0b
	.db $50 $68 $4a $0b
	.db $70 $70 $3c $0c
	.db $60 $70 $3e $2c
	.db $70 $38 $3a $0c
	.db $60 $38 $3e $0c

; @addr{71f7}
oamData_71f7:
	.db $0a
	.db $10 $40 $22 $08
	.db $10 $68 $22 $28
	.db $60 $38 $16 $0c
	.db $70 $38 $1a $0c
	.db $60 $70 $18 $0c
	.db $70 $70 $1a $2c
	.db $40 $40 $1c $08
	.db $40 $68 $1e $08
	.db $50 $40 $20 $08
	.db $50 $68 $20 $28

; @addr{7220}
oamData_7220:
	.db $0a
	.db $e0 $48 $24 $0b
	.db $e0 $60 $24 $2b
	.db $e0 $50 $26 $0b
	.db $e0 $58 $26 $2b
	.db $f0 $48 $28 $0b
	.db $f0 $60 $28 $2b
	.db $00 $48 $2a $0b
	.db $00 $60 $2a $2b
	.db $f8 $50 $2c $0b
	.db $f8 $58 $2c $2b

; @addr{7249}
oamData_7249:
	.db $27
	.db $38 $38 $00 $01
	.db $38 $58 $02 $00
	.db $30 $48 $04 $00
	.db $30 $50 $06 $00
	.db $40 $48 $08 $00
	.db $58 $38 $0a $00
	.db $50 $40 $0c $02
	.db $50 $48 $0e $04
	.db $58 $50 $10 $03
	.db $60 $57 $12 $03
	.db $60 $5f $14 $03
	.db $60 $30 $16 $00
	.db $72 $38 $18 $00
	.db $70 $30 $1a $03
	.db $88 $28 $1c $00
	.db $3b $9a $1e $04
	.db $4b $9a $20 $04
	.db $58 $90 $22 $05
	.db $58 $98 $24 $05
	.db $22 $a0 $26 $06
	.db $22 $a8 $28 $06
	.db $32 $a0 $2a $06
	.db $32 $a8 $2c $06
	.db $12 $a0 $2e $06
	.db $12 $a8 $30 $06
	.db $12 $b0 $32 $06
	.db $6c $b0 $34 $03
	.db $70 $c0 $36 $01
	.db $80 $c0 $38 $05
	.db $90 $58 $3a $03
	.db $30 $90 $3c $00
	.db $90 $c0 $3e $05
	.db $90 $78 $40 $05
	.db $80 $70 $42 $05
	.db $80 $78 $44 $05
	.db $80 $88 $46 $05
	.db $90 $80 $48 $05
	.db $48 $50 $4a $02
	.db $60 $40 $4c $00


; ==============================================================================
; INTERACID_MONKEY
;
; Variables:
;   var38/39: Copied to speedZ?
;   var3a:    Animation index?
; ==============================================================================
interactionCode39_body:
	ld e,Interaction.state		; $72e6
	ld a,(de)		; $72e8
	rst_jumpTable			; $72e9
	.dw @state0
	.dw _monkeyState1

@state0:
	ld a,$01		; $72ee
	ld (de),a		; $72f0

	ld a,>TX_5700		; $72f1
	call interactionSetHighTextIndex		; $72f3

	call interactionInitGraphics		; $72f6
	call objectSetVisiblec2		; $72f9
	call @initSubid		; $72fc

	ld e,Interaction.var03		; $72ff
	ld a,(de)		; $7301
	cp $09			; $7302
	ret z			; $7304

	ld e,Interaction.enabled		; $7305
	ld a,(de)		; $7307
	or a			; $7308
	jp nz,objectMarkSolidPosition		; $7309
	ret			; $730c

@initSubid:
	ld e,Interaction.subid		; $730d
	ld a,(de)		; $730f
	rst_jumpTable			; $7310
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init
	.dw @subid3Init
	.dw @subid4Init
	.dw @subid5Init
	.dw @subid6Init
	.dw @subid7Init

@subid0Init:
	ld a,$02		; $7321
	call interactionSetAnimation		; $7323

	ld hl,monkeySubid0Script		; $7326
	jp interactionSetScript		; $7329


@subid2Init:
	ld a,$02		; $732c
	ld e,Interaction.oamFlags		; $732e
	ld (de),a		; $7330
	ld a,$06		; $7331
	call interactionSetAnimation		; $7333
	jr ++			; $7336

@subid3Init:
	ld a,$07		; $7338
	call interactionSetAnimation		; $733a
++
	ld a,GLOBALFLAG_INTRO_DONE		; $733d
	call checkGlobalFlag		; $733f
	jp nz,interactionDelete		; $7342

	ld e,Interaction.subid		; $7345
	ld a,(de)		; $7347
	sub $02			; $7348
	ld hl,_introMonkeyScriptTable		; $734a
	rst_addDoubleIndex			; $734d
	ldi a,(hl)		; $734e
	ld h,(hl)		; $734f
	ld l,a			; $7350
	jp interactionSetScript		; $7351


@subid1Init: ; Subids 4 and 5 calls this too
	ld e,Interaction.var03		; $7354
	ld a,(de)		; $7356
	ld c,a			; $7357
	or a			; $7358
	jr nz,@doneSpawning	; $7359

	; Load PALH_ad if this isn't subid 5?
	dec e			; $735b
	ld a,(de)		; $735c
	cp $05			; $735d
	jr z,++			; $735f
	push bc			; $7361
	ld a,PALH_ad		; $7362
	call loadPaletteHeader		; $7364
	pop bc			; $7367
++

	; Spawn 9 monkeys
	ld b,$09		; $7368

@nextMonkey:
	call getFreeInteractionSlot		; $736a
	jr nz,@doneSpawning	; $736d

	ld (hl),INTERACID_MONKEY		; $736f
	inc l			; $7371
	ld e,Interaction.subid		; $7372
	ld a,(de)		; $7374
	ld (hl),a ; Copy subid
	inc l			; $7376
	ld (hl),b ; [var03] = b
	dec b			; $7378
	jr nz,@nextMonkey	; $7379

@doneSpawning:
	; Retrieve var03
	ld a,c			; $737b
	add a			; $737c

	ld hl,@monkeyPositions		; $737d
	rst_addDoubleIndex			; $7380
	ldi a,(hl)		; $7381
	ld e,Interaction.yh		; $7382
	ld (de),a		; $7384
	ldi a,(hl)		; $7385
	ld e,Interaction.xh		; $7386
	ld (de),a		; $7388

	ldi a,(hl)		; $7389
	ld e,Interaction.counter1		; $738a
	ld (de),a		; $738c
	ld a,(hl)		; $738d
	call interactionSetAnimation		; $738e

	; Randomize the animation slightly?
	call getRandomNumber_noPreserveVars		; $7391
	and $0f			; $7394
	ld h,d			; $7396
	ld l,Interaction.counter2		; $7397
	ld (hl),a		; $7399
	sub $07			; $739a
	ld l,Interaction.animCounter		; $739c
	add (hl)		; $739e
	ld (hl),a		; $739f

	; Randomize jump speeds?
	call getRandomNumber		; $73a0
	and $03			; $73a3
	ld bc,@jumpSpeeds		; $73a5
	call addDoubleIndexToBc		; $73a8
	ld l,Interaction.var38		; $73ab
	ld a,(bc)		; $73ad
	ldi (hl),a		; $73ae
	inc bc			; $73af
	ld a,(bc)		; $73b0
	ld (hl),a		; $73b1
	jp _monkeySetJumpSpeed		; $73b2


@jumpSpeeds:
	.dw -$80
	.dw -$a0
	.dw -$70
	.dw -$90


; This table takes var03 as an index.
; Data format:
;   b0: Y
;   b1: X
;   b2: counter1
;   b3: animation
@monkeyPositions:
	.db $58 $88 $f0 $00
	.db $58 $78 $d2 $01
	.db $28 $28 $dc $01
	.db $38 $38 $be $02
	.db $18 $68 $64 $01
	.db $1c $80 $78 $00
	.db $30 $68 $50 $05
	.db $34 $88 $8c $02
	.db $50 $46 $b4 $02
	.db $64 $28 $b8 $08

@subid4Init:
	call objectSetInvisible		; $73e5
	call @subid1Init		; $73e8

	ld l,Interaction.oamFlags		; $73eb
	ld (hl),$06		; $73ed
	ld l,Interaction.counter2		; $73ef
	ld (hl),$3c		; $73f1

	ld l,Interaction.var03		; $73f3
	ld a,(hl)		; $73f5
	cp $09			; $73f6
	jr nz,++		; $73f8

	; Monkey $09: ?
	ld l,Interaction.var3c		; $73fa
	inc (hl)		; $73fc
	ld bc,$6424		; $73fd
	jp interactionSetPosition		; $7400
++
	cp $08			; $7403
	ret nz			; $7405

	; Monkey $08: the monkey with a bowtie
	ld a,$fa		; $7406
	ld e,Interaction.counter1		; $7408
	ld (de),a		; $740a

@initBowtieMonkey:
	ld a,$07		; $740b
	call interactionSetAnimation		; $740d

	; Create a bowtie
	call getFreeInteractionSlot		; $7410
	ret nz			; $7413
	ld (hl),INTERACID_ACCESSORY		; $7414
	inc l			; $7416
	ld (hl),$3d		; $7417
	inc l			; $7419
	ld (hl),$01		; $741a

	ld l,Interaction.relatedObj1		; $741c
	ld (hl),Interaction.start		; $741e
	inc l			; $7420
	ld (hl),d		; $7421

	ld e,Interaction.relatedObj2+1		; $7422
	ld a,h			; $7424
	ld (de),a		; $7425
	ret			; $7426

@subid5Init:
	ld a,GLOBALFLAG_SAVED_NAYRU		; $7427
	call checkGlobalFlag		; $7429
	jp z,interactionDelete		; $742c
	call @subid1Init		; $742f
	ld l,Interaction.counter1		; $7432
	ldi (hl),a		; $7434
	ld (hl),a		; $7435
	ld hl,monkeySubid5Script		; $7436

	ld e,Interaction.var03		; $7439
	ld a,(de)		; $743b
	cp $08			; $743c
	jr nz,+			; $743e

	; Bowtie monkey has a different script
	push af			; $7440
	call @initBowtieMonkey		; $7441
	ld hl,monkeySubid5Script_bowtieMonkey		; $7444
	pop af			; $7447
+
	; Monkey $05 gets the red palette
	cp $05			; $7448
	ld a,$03		; $744a
	jr nz,+			; $744c
	ld a,$02		; $744e
+
	ld e,Interaction.oamFlags		; $7450
	ld (de),a		; $7452
	jp interactionSetScript		; $7453

@subid6Init:
	ld a,$05		; $7456
	jp interactionSetAnimation		; $7458

@subid7Init:
	ld e,Interaction.var03		; $745b
	ld a,(de)		; $745d
	rst_jumpTable			; $745e
	.dw @subid7Init_0
	.dw @subid7Init_1
	.dw @subid7Init_2

@subid7Init_0:
	ld a,GLOBALFLAG_FINISHEDGAME		; $7465
	call checkGlobalFlag		; $7467
	jp nz,interactionDelete		; $746a

	ld a,GLOBALFLAG_SAVED_NAYRU		; $746d
	call checkGlobalFlag		; $746f
	jp z,interactionDelete		; $7472

	ld hl,monkeySubid7Script_0		; $7475
	call interactionSetScript		; $7478
	ld a,$06		; $747b
	jr @setVar3aAnimation		; $747d

@subid7Init_1:
	ld a,GLOBALFLAG_FINISHEDGAME		; $747f
	call checkGlobalFlag		; $7481
	jp z,interactionDelete		; $7484

	ld hl,monkeySubid7Script_1		; $7487
	call interactionSetScript		; $748a
	ld a,$05		; $748d
	jr @setVar3aAnimation		; $748f

@subid7Init_2:
	ld a,GLOBALFLAG_FINISHEDGAME		; $7491
	call checkGlobalFlag		; $7493
	jp nz,interactionDelete		; $7496

	ld a,GLOBALFLAG_MAKU_TREE_SAVED		; $7499
	call checkGlobalFlag		; $749b
	jp z,interactionDelete		; $749e

	ld a,GLOBALFLAG_SAVED_NAYRU		; $74a1
	call checkGlobalFlag		; $74a3
	ld hl,monkeySubid7Script_2		; $74a6
	jp z,@setScript		; $74a9
	ld hl,monkeySubid7Script_3		; $74ac
@setScript:
	call interactionSetScript		; $74af
	ld a,$05		; $74b2

@setVar3aAnimation:
	ld e,Interaction.var3a		; $74b4
	ld (de),a		; $74b6
	jp interactionSetAnimation		; $74b7

_monkeyState1:
	ld e,Interaction.subid		; $74ba
	ld a,(de)		; $74bc
	rst_jumpTable			; $74bd
	.dw _monkeySubid0State1
	.dw _monkeySubid1State1
	.dw _monkeySubid2State1
	.dw _monkeySubid3State1
	.dw _monkeySubid4State1
	.dw _monkeySubid5State1
	.dw interactionAnimate
	.dw _monkeyAnimateAndRunScript

;;
; @addr{74ce}
_monkeySubid0State1:
	call interactionAnimate		; $74ce
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $74d1
	ld e,Interaction.state2		; $74d4
	ld a,(de)		; $74d6
	or a			; $74d7
	call z,objectPreventLinkFromPassing		; $74d8

	ld e,Interaction.state2		; $74db
	ld a,(de)		; $74dd
	rst_jumpTable			; $74de
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw _monkeySubid0State1Substate3

@substate0:
	ld a,($cfd0)		; $74e7
	cp $0e			; $74ea
	jp nz,interactionRunScript		; $74ec
	call interactionIncState2		; $74ef
	ld a,$06		; $74f2
	jp interactionSetAnimation		; $74f4

@substate1:
	ld a,($cfd0)		; $74f7
	cp $10			; $74fa
	ret nz			; $74fc
	call interactionIncState2		; $74fd
	ld l,Interaction.counter1		; $7500
	ld (hl),$32		; $7502
	ld a,$03		; $7504
	call interactionSetAnimation		; $7506
	jr _monkeyJumpSpeed120		; $7509

@substate2:
	call interactionDecCounter1		; $750b
	jr nz,_monkeyUpdateGravityAndHop	; $750e

	call interactionIncState2		; $7510
	ld l,Interaction.angle		; $7513
	ld (hl),$02		; $7515
	ld l,Interaction.zh		; $7517
	ld (hl),$00		; $7519
	ld l,Interaction.speed		; $751b
	ld (hl),SPEED_180		; $751d

_monkeySetAnimationAndJump:
	call interactionSetAnimation		; $751f

_monkeyJumpSpeed100:
	ld bc,-$100		; $7522
	jp objectSetSpeedZ		; $7525

_monkeySubid0State1Substate3:
	call objectCheckWithinScreenBoundary		; $7528
	jr c,++			; $752b
	ld a,$01		; $752d
	ld (wLoadedTreeGfxIndex),a		; $752f
	jp interactionDelete		; $7532
++
	ld c,$20		; $7535
	call objectUpdateSpeedZ_paramC		; $7537
	jp nz,objectApplySpeed		; $753a
	ld a,$04		; $753d
	jr _monkeySetAnimationAndJump		; $753f

_monkeyUpdateGravityAndHop:
	ld c,$20		; $7541
	call objectUpdateSpeedZ_paramC		; $7543
	ret nz			; $7546

_monkeyJumpSpeed120:
	ld bc,-$120		; $7547
	jp objectSetSpeedZ		; $754a

;;
; Updates gravity, and if the monkey landed, resets speedZ to values of var38/var39.
; @addr{754d}
_monkeyUpdateGravityAndJumpIfLanded:
	ld c,$10		; $754d
	call objectUpdateSpeedZ_paramC		; $754f
	ret nz			; $7552

;;
; Sets speedZ to values of var38/var39.
; @addr{7553}
_monkeySetJumpSpeed:
	ld l,Interaction.var38		; $7553
	ldi a,(hl)		; $7555
	ld e,Interaction.speedZ		; $7556
	ld (de),a		; $7558
	inc e			; $7559
	ld a,(hl)		; $755a
	ld (de),a		; $755b
	ret			; $755c

;;
; Monkey disappearance cutscene
; @addr{755d}
_monkeySubid1State1:
	ld e,Interaction.var03		; $755d
	ld a,(de)		; $755f
	rst_jumpTable			; $7560
	.dw _monkey0Disappearance
	.dw _monkey1Disappearance
	.dw _monkey2Disappearance
	.dw _monkey3Disappearance
	.dw _monkey4Disappearance
	.dw _monkey5Disappearance
	.dw _monkey6Disappearance
	.dw _monkey7Disappearance
	.dw _monkey8Disappearance
	.dw _monkey9Disappearance


_monkey0Disappearance:
_monkey1Disappearance:
_monkey2Disappearance:
_monkey4Disappearance:
	ld e,Interaction.state2		; $7575
	ld a,(de)		; $7577
	rst_jumpTable			; $7578
	.dw @substate0
	.dw @substate1
	.dw _monkeyWaitBeforeFlickering
	.dw _monkeyFlickerUntilDeletion

@substate0:
	call interactionAnimate		; $7581
	call interactionDecCounter2		; $7584
	ret nz			; $7587
	jp interactionIncState2		; $7588

@substate1:
	call interactionDecCounter1		; $758b
	jr nz,+			; $758e
	jr _monkeyBeginDisappearing			; $7590
+
	call _monkeyUpdateGravityAndJumpIfLanded		; $7592
	jp interactionAnimate		; $7595

_monkeyBeginDisappearing:
	ld (hl),$3c		; $7598
	ld l,Interaction.oamFlags		; $759a
	ld (hl),$06		; $759c
	ld l,Interaction.zh		; $759e
	ld (hl),$00		; $75a0

	ld a,SND_CLINK		; $75a2
	call playSound		; $75a4
	jp interactionIncState2		; $75a7

_monkeyWaitBeforeFlickering:
	call interactionDecCounter1		; $75aa
	ret nz			; $75ad
	ld (hl),$3c		; $75ae
	jp interactionIncState2		; $75b0

_monkeyFlickerUntilDeletion:
	call interactionDecCounter1		; $75b3
	jr nz,+			; $75b6
	jp interactionDelete		; $75b8
+
	ld b,$01		; $75bb
	jp objectFlickerVisibility		; $75bd


_monkey3Disappearance:
_monkey6Disappearance:
_monkey7Disappearance:
	ld e,Interaction.state2		; $75c0
	ld a,(de)		; $75c2
	rst_jumpTable			; $75c3
	.dw @substate0
	.dw _monkeyWaitBeforeFlickering
	.dw _monkeyFlickerUntilDeletion

@substate0:
	call interactionDecCounter1		; $75ca
	jp nz,interactionAnimate		; $75cd
	jr _monkeyBeginDisappearing		; $75d0


_monkey5Disappearance:
	ld e,Interaction.state2		; $75d2
	ld a,(de)		; $75d4
	rst_jumpTable			; $75d5
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw _monkeyWaitBeforeFlickering
	.dw _monkeyFlickerUntilDeletion

@substate0:
	call interactionIncState2		; $75e0
	ld l,Interaction.oamFlags		; $75e3
	ld (hl),$02		; $75e5

@substate1:
	call interactionDecCounter1		; $75e7
	ret nz			; $75ea
	ld (hl),$b4		; $75eb
	call interactionIncState2		; $75ed
	ld bc,$f3f8		; $75f0
	ld a,$5a		; $75f3
	jp objectCreateExclamationMark		; $75f5

@substate2:
	call interactionDecCounter1		; $75f8
	ret nz			; $75fb
	jp _monkeyBeginDisappearing		; $75fc


	; Unused code?
	ld e,Interaction.state2		; $75ff
	ld a,(de)		; $7601
	rst_jumpTable			; $7602
	.dw @@substate0
	.dw _monkeyWaitBeforeFlickering
	.dw _monkeyFlickerUntilDeletion

@@substate0:
	call interactionDecCounter1		; $7609
	ret nz			; $760c
	jr _monkeyBeginDisappearing		; $760d


_monkey9Disappearance:
	call _monkeyCheckChangeAnimation		; $760f

	ld e,Interaction.state2		; $7612
	ld a,(de)		; $7614
	cp $04			; $7615
	jr nc,++		; $7617
	call interactionDecCounter1		; $7619
	jr nz,++			; $761c
	call _monkeyBeginDisappearing		; $761e
	ld l,Interaction.state2		; $7621
	ld (hl),$04		; $7623
++
	ld e,Interaction.state2		; $7625
	ld a,(de)		; $7627
	rst_jumpTable			; $7628
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw _monkeyWaitBeforeFlickering
	.dw _monkeyFlickerUntilDeletion

@substate0:
	ld h,d			; $7635
	ld l,Interaction.direction		; $7636
	ld a,$08		; $7638
	ldi (hl),a		; $763a
	ld (hl),a		; $763b

	ld l,Interaction.speed		; $763c
	ld (hl),SPEED_100		; $763e
	call interactionIncState2		; $7640
	jp _monkeyJumpSpeed100		; $7643

@substate1:
	ld c,$20		; $7646
	call objectUpdateSpeedZ_paramC		; $7648
	jp nz,objectApplySpeed		; $764b

	call _monkeyJumpSpeed100		; $764e

	ld l,Interaction.var3c		; $7651
	inc (hl)		; $7653
	ld a,(hl)		; $7654
	cp $03			; $7655
	ret nz			; $7657

	call interactionIncState2		; $7658
	ld l,Interaction.var38		; $765b
	ld (hl),$10		; $765d
	ret			; $765f

@substate2:
	ld h,d			; $7660
	ld l,Interaction.var38		; $7661
	dec (hl)		; $7663
	ret nz			; $7664

	ld (hl),$10		; $7665
	call interactionIncState2		; $7667

	ld l,Interaction.direction		; $766a
	ld a,(hl)		; $766c
	xor $10			; $766d
	ldi (hl),a		; $766f
	ld (hl),a		; $7670

	ld l,Interaction.angle		; $7671
	ld a,(hl)		; $7673
	and $10			; $7674
	ld a,$03		; $7676
	jr nz,+			; $7678
	ld a,$08		; $767a
+
	jp _monkeySetAnimationAndJump		; $767c

@substate3:
	ld h,d			; $767f
	ld l,Interaction.var38		; $7680
	dec (hl)		; $7682
	ret nz			; $7683

	ld l,Interaction.var3c		; $7684
	ld (hl),$00		; $7686
	ld l,Interaction.state2		; $7688
	dec (hl)		; $768a
	dec (hl)		; $768b
	ret			; $768c

;;
; Checks if the monkey is in the air, updates var3a and animation accordingly?
; @addr{768d}
_monkeyCheckChangeAnimation:
	ld h,d			; $768d
	ld l,Interaction.zh		; $768e
	ld a,(hl)		; $7690
	sub $03			; $7691
	cp $fa			; $7693
	ld a,$00		; $7695
	jr nc,+			; $7697
	inc a			; $7699
+
	ld l,Interaction.var3a		; $769a
	cp (hl)			; $769c
	ret z			; $769d
	ld (hl),a		; $769e
	ld l,Interaction.animCounter		; $769f
	ld (hl),$01		; $76a1
	jp interactionAnimate		; $76a3


_monkey8Disappearance:
	ld e,Interaction.state2		; $76a6
	ld a,(de)		; $76a8
	rst_jumpTable			; $76a9
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw _monkeyWaitBeforeFlickering
	.dw @substate3
	.dw @substate4

@substate0:
	call interactionDecCounter1		; $76b6
	jr nz,++		; $76b9
	ld (hl),$5a		; $76bb
	call interactionIncState2		; $76bd
	ld bc,$f3f8		; $76c0
	ld a,$3c		; $76c3
	jp objectCreateExclamationMark		; $76c5
++
	ld a,(wFrameCounter)		; $76c8
	and $01			; $76cb
	ret nz			; $76cd
	jp interactionAnimate		; $76ce

@substate1:
	call interactionDecCounter1		; $76d1
	ret nz			; $76d4
	ld (hl),$b4		; $76d5
	jp interactionIncState2		; $76d7

@substate2:
	call interactionDecCounter1		; $76da
	jr nz,+			; $76dd
	jp _monkeyBeginDisappearing		; $76df
+
	ld a,(wFrameCounter)		; $76e2
	and $0f			; $76e5
	ret nz			; $76e7
	ld l,Interaction.direction		; $76e8
	ld a,(hl)		; $76ea
	xor $01			; $76eb
	ld (hl),a		; $76ed
	jp interactionSetAnimation		; $76ee

@substate3:
	call interactionDecCounter1		; $76f1
	jr nz,++		; $76f4
	ld (hl),$1e		; $76f6
	call objectSetInvisible		; $76f8
	jp interactionIncState2		; $76fb
++
	ld b,$01		; $76fe
	jp objectFlickerVisibility		; $7700

@substate4:
	call interactionDecCounter1		; $7703
	ret nz			; $7706
	ld a,$ff		; $7707
	ld ($cfdf),a		; $7709
	jp interactionDelete		; $770c

;;
; Monkey that only exists before intro
; @addr{770f}
_monkeySubid2State1:
_monkeySubid3State1:
	call interactionRunScript		; $770f
	jp interactionAnimateAsNpc		; $7712


;;
; @addr{7715}
_monkeySubid4State1:
	ld e,Interaction.var03		; $7715
	ld a,(de)		; $7717
	rst_jumpTable			; $7718
	.dw @monkey0
	.dw @monkey0
	.dw @monkey0
	.dw @monkey3
	.dw @monkey0
	.dw @monkey3
	.dw @monkey3
	.dw @monkey3
	.dw @monkey3
	.dw @monkey9

@monkey0:
	ld e,Interaction.state2		; $772d
	ld a,(de)		; $772f
	rst_jumpTable			; $7730
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4_0

@substate0:
	call interactionDecCounter2		; $773b
	ret nz			; $773e
	jp interactionIncState2		; $773f

@substate1:
	call interactionDecCounter1		; $7742
	ret nz			; $7745
	ld (hl),$3c		; $7746
	ld l,Interaction.var03		; $7748
	ld a,(hl)		; $774a
	cp $08			; $774b
	jr nz,++		; $774d
	ld a,Object.enabled		; $774f
	call objectGetRelatedObject2Var		; $7751
	ld l,Interaction.oamFlags		; $7754
	ld (hl),$06		; $7756
++
	ld a,SND_GALE_SEED		; $7758
	call playSound		; $775a
	jp interactionIncState2		; $775d

@substate2:
	call interactionDecCounter1		; $7760
	jr nz,++		; $7763
	ld (hl),$3c		; $7765
	call objectSetVisible		; $7767
	jp interactionIncState2		; $776a
++
	ld b,$01		; $776d
	jp objectFlickerVisibility		; $776f

@substate3:
	call interactionDecCounter1		; $7772
	ret nz			; $7775
	ld b,$03		; $7776
	ld l,Interaction.var03		; $7778
	ld a,(hl)		; $777a
	cp $05			; $777b
	jr nz,+			; $777d
	dec b			; $777f
	jr ++			; $7780
+
	cp $08			; $7782
	jr nz,++		; $7784
	ld a,Object.enabled		; $7786
	call objectGetRelatedObject2Var		; $7788
	ld l,Interaction.oamFlags		; $778b
	ld (hl),$02		; $778d
	ld h,d			; $778f
	ld l,Interaction.counter1		; $7790
	ld (hl),$b4		; $7792
++
	ld l,Interaction.oamFlags		; $7794
	ld (hl),b		; $7796
	jp interactionIncState2		; $7797

@substate4_0:
	call _monkeyUpdateGravityAndJumpIfLanded		; $779a

@substate4_1:
	call interactionAnimate		; $779d
	ld e,Interaction.var03		; $77a0
	ld a,(de)		; $77a2
	cp $08			; $77a3
	ret nz			; $77a5
	call interactionDecCounter1		; $77a6
	ret nz			; $77a9
	ld a,$ff		; $77aa
	ld ($cfdf),a		; $77ac
	ret			; $77af

@monkey3:
	ld e,Interaction.state2		; $77b0
	ld a,(de)		; $77b2
	rst_jumpTable			; $77b3
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4_1

@monkey9:
	ld e,Interaction.state2		; $77be
	ld a,(de)		; $77c0
	cp $04			; $77c1
	call nc,_monkeyCheckChangeAnimation		; $77c3
	ld e,Interaction.state2		; $77c6
	ld a,(de)		; $77c8
	rst_jumpTable			; $77c9
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw _monkey9Disappearance@substate0
	.dw _monkey9Disappearance@substate1
	.dw _monkey9Disappearance@substate2
	.dw _monkey9Disappearance@substate3


;;
; @addr{77da}
_monkeySubid5State1:
	ld e,Interaction.var03		; $77da
	ld a,(de)		; $77dc
	rst_jumpTable			; $77dd
	.dw @monkey0
	.dw @monkey0
	.dw @monkey0
	.dw _monkeyAnimateAndRunScript
	.dw @monkey0
	.dw _monkeyAnimateAndRunScript
	.dw _monkeyAnimateAndRunScript
	.dw _monkeyAnimateAndRunScript
	.dw _monkeyAnimateAndRunScript
	.dw _monkeySubid5State1_monkey9

@monkey0:
	call _monkeyUpdateGravityAndJumpIfLanded		; $77f2

_monkeyAnimateAndRunScript:
	call interactionRunScript		; $77f5
	jp interactionAnimateAsNpc		; $77f8

_monkeySubid5State1_monkey9:
	call interactionRunScript		; $77fb
	call _monkeyCheckChangeAnimation		; $77fe
	call objectPushLinkAwayOnCollision		; $7801
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $7804
	ld e,Interaction.state2	; $7807
	ld a,(de)		; $7809
	rst_jumpTable			; $780a
	.dw _monkey9Disappearance@substate0
	.dw _monkey9Disappearance@substate1
	.dw _monkey9Disappearance@substate2
	.dw _monkey9Disappearance@substate3

_introMonkeyScriptTable:
	.dw monkeySubid2Script
	.dw monkeySubid3Script


; ==============================================================================
; INTERACID_RABBIT
; ==============================================================================
interactionCode4b_body:
	ld e,Interaction.state		; $7817
	ld a,(de)		; $7819
	rst_jumpTable			; $781a
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $781f
	ld (de),a		; $7821
	call interactionInitGraphics		; $7822
	call objectSetVisiblec2		; $7825
	call @initSubid		; $7828
	ld e,Interaction.enabled		; $782b
	ld a,(de)		; $782d
	or a			; $782e
	jp nz,objectMarkSolidPosition		; $782f
	ret			; $7832

@initSubid:
	ld e,Interaction.subid		; $7833
	ld a,(de)		; $7835
	rst_jumpTable			; $7836
	.dw @initSubid0
	.dw @initSubid1
	.dw @initSubid2
	.dw @initSubid3
	.dw @initSubid4
	.dw @initSubid5
	.dw @initSubid6
	.dw @initSubid7

@initSubid0:
	ld hl,rabbitScript_listeningToNayruGameStart		; $7847
	jp interactionSetScript		; $784a

; This is also called from outside this interaction's code
@initSubid1:
	ld h,d			; $784d
	ld l,Interaction.angle		; $784e
	ld (hl),$18		; $7850
	ld l,Interaction.speed		; $7852
	ld (hl),SPEED_180		; $7854

@setJumpAnimation:
	ld a,$05		; $7856
	call interactionSetAnimation		; $7858

	ld bc,-$180		; $785b
	jp objectSetSpeedZ		; $785e

@initSubid2:
	ld e,Interaction.counter1		; $7861
	ld a,180		; $7863
	ld (de),a		; $7865
	callab interactionBank08.loadStoneNpcPalette		; $7866
	jp _rabbitSubid2SetRandomSpawnDelay		; $786e

@initSubid6:
	; Delete if veran defeated
	ld hl,wGroup4Flags+$fc		; $7871
	bit 7,(hl)		; $7874
	jp nz,interactionDelete		; $7876

	; Delete if haven't beaten Jabu
	ld a,(wEssencesObtained)		; $7879
	bit 6,a			; $787c
	jp z,interactionDelete		; $787e

	callab interactionBank08.loadStoneNpcPalette		; $7881
	ld a,$06		; $7889
	call objectSetCollideRadius		; $788b

@initSubid3:
	ld a,120		; $788e
	ld e,Interaction.counter1		; $7890
	ld (de),a		; $7892

@setStonePaletteAndAnimation:
	ld a,$06		; $7893
	ld e,Interaction.oamFlags		; $7895
	ld (de),a		; $7897
	jp interactionSetAnimation		; $7898

@initSubid5:
	call interactionLoadExtraGraphics		; $789b
	ld h,d			; $789e
	ld l,Interaction.counter1		; $789f
	ld (hl),$0e		; $78a1
	inc l			; $78a3
	ld (hl),$01		; $78a4
	jr @setStonePaletteAndAnimation		; $78a6

@initSubid4:
	call interactionLoadExtraGraphics		; $78a8
	jp _rabbitJump		; $78ab

@initSubid7:
	ld a,GLOBALFLAG_FINISHEDGAME		; $78ae
	call checkGlobalFlag		; $78b0
	jp nz,interactionDelete		; $78b3

	ld a,GLOBALFLAG_MAKU_TREE_SAVED		; $78b6
	call checkGlobalFlag		; $78b8
	jp z,interactionDelete		; $78bb

	ld a,GLOBALFLAG_SAVED_NAYRU		; $78be
	call checkGlobalFlag		; $78c0
	ld hl,rabbitScript_waitingForNayru1		; $78c3
	jp z,+			; $78c6
	ld hl,rabbitScript_waitingForNayru2		; $78c9
+
	call interactionSetScript		; $78cc

@state1:
	ld e,Interaction.subid		; $78cf
	ld a,(de)		; $78d1
	rst_jumpTable			; $78d2
	.dw _rabbitSubid0
	.dw _rabbitSubid1
	.dw _rabbitSubid2
	.dw _rabbitSubid3
	.dw _rabbitSubid4
	.dw _rabbitSubid5
	.dw interactionPushLinkAwayAndUpdateDrawPriority
	.dw _rabbitSubid7


; Listening to Nayru at the start of the game
_rabbitSubid0:
	call interactionAnimateAsNpc		; $78e3
	ld e,Interaction.state2		; $78e6
	ld a,(de)		; $78e8
	rst_jumpTable			; $78e9
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfd0)		; $78f2
	cp $0e			; $78f5
	jp nz,interactionRunScript		; $78f7

	call interactionIncState2		; $78fa
	ld a,$02		; $78fd
	jp interactionSetAnimation		; $78ff

@substate1:
	ld a,($cfd0)		; $7902
	cp $10			; $7905
	jp nz,interactionRunScript		; $7907

	call interactionIncState2		; $790a
	ld l,Interaction.counter1		; $790d
	ld (hl),40		; $790f
	ret			; $7911

@substate2:
	call interactionDecCounter1		; $7912
	jp nz,interactionAnimate		; $7915

	call interactionIncState2		; $7918
	ld l,Interaction.angle		; $791b
	ld (hl),$06		; $791d
	ld l,Interaction.speed		; $791f
	ld (hl),SPEED_180		; $7921

@jump:
	ld bc,-$200		; $7923
	call objectSetSpeedZ		; $7926
	ld a,$04		; $7929
	jp interactionSetAnimation		; $792b

@substate3:
	call objectCheckWithinScreenBoundary		; $792e
	jp nc,interactionDelete		; $7931
	ld c,$20		; $7934
	call objectUpdateSpeedZ_paramC		; $7936
	jp nz,objectApplySpeed		; $7939
	jr @jump		; $793c


_rabbitSubid1:
	ld h,d			; $793e
	ld l,Interaction.counter1		; $793f
	ld a,(hl)		; $7941
	or a			; $7942
	jr z,@updateSubstate	; $7943
	dec (hl)		; $7945
	jr nz,@updateSubstate	; $7946

	inc l			; $7948
	ld a,30 ; [counter2] = 30

	ld (hl),a		; $794b
	ld l,Interaction.state2		; $794c
	ld (hl),$02		; $794e
	ld bc,$f000		; $7950
	call objectCreateExclamationMark		; $7953

@updateSubstate:
	ld e,Interaction.state2		; $7956
	ld a,(de)		; $7958
	rst_jumpTable			; $7959
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

; This is also called by subids 1 and 3
@substate0:
	call interactionAnimate		; $7968
	ld e,Interaction.animParameter		; $796b
	ld a,(de)		; $796d
	or a			; $796e
	ret z			; $796f
	ld a,SND_JUMP		; $7970
	call playSound		; $7972
	jp interactionIncState2		; $7975

; This is also called by subids 1 and 3
@substate1:
	ld e,Interaction.xh		; $7978
	ld a,(de)		; $797a
	cp $d0			; $797b
	jp nc,interactionDelete		; $797d

	call objectApplySpeed		; $7980
	ld c,$20		; $7983
	call objectUpdateSpeedZ_paramC		; $7985
	ret nz			; $7988

	ld h,d			; $7989
	ld l,Interaction.state2		; $798a
	dec (hl)		; $798c
	jp interactionCode4b_body@setJumpAnimation		; $798d

@substate2:
	call interactionDecCounter2		; $7990
	ret nz			; $7993

	ld (hl),60		; $7994
	ld l,Interaction.xh		; $7996
	ld a,(hl)		; $7998
	ld l,Interaction.var3d		; $7999
	ld (hl),a		; $799b
	jp interactionIncState2		; $799c

@substate3:
	callab interactionBank08.interactionOscillateXRandomly		; $799f
	call interactionDecCounter2		; $79a7
	ret nz			; $79aa
	ld (hl),20		; $79ab

	; Set stone color
	ld l,Interaction.oamFlags		; $79ad
	ld (hl),$06		; $79af

	jp interactionIncState2		; $79b1

@substate4:
	call interactionDecCounter2		; $79b4
	ret nz			; $79b7

	ld bc,$0000		; $79b8
	call objectSetSpeedZ		; $79bb
	jp interactionIncState2		; $79be

@substate5:
	ld c,$20		; $79c1
	call objectUpdateSpeedZ_paramC		; $79c3
	ret nz			; $79c6

	call interactionIncState2		; $79c7
	ld l,Interaction.counter2		; $79ca
	ld (hl),240		; $79cc
	ld a,$04		; $79ce
	jp setScreenShakeCounter		; $79d0

@substate6:
	call interactionDecCounter2		; $79d3
	ret nz			; $79d6
	ld a,$ff		; $79d7
	ld ($cfdf),a		; $79d9
	ret			; $79dc


; "Controller" for the cutscene where rabbits turn to stone? (spawns subid $01)
_rabbitSubid2:
	ld h,d			; $79dd
	ld l,Interaction.counter1		; $79de
	ld a,(hl)		; $79e0
	or a			; $79e1
	jr z,+			; $79e2
	dec (hl)		; $79e4
	call z,_spawnNextRabbitThatTurnsToStone		; $79e5
+
	; After a random delay, spawn a rabbit that just runs across the screen (doesn't
	; turn to stone)
	ld h,d			; $79e8
	ld l,Interaction.var38		; $79e9
	dec (hl)		; $79eb
	ret nz			; $79ec

	call getRandomNumber_noPreserveVars		; $79ed
	and $07			; $79f0
	ld hl,_rabbitSubid2YPositions		; $79f2
	rst_addAToHl			; $79f5
	ld b,(hl)		; $79f6
	call getRandomNumber		; $79f7
	and $0f			; $79fa
	cpl			; $79fc
	inc a			; $79fd
	add $b0			; $79fe
	ld c,a			; $7a00
	call _spawnRabbitWithSubid1		; $7a01
	jp _rabbitSubid2SetRandomSpawnDelay		; $7a04


; Rabbit being restored from stone cutscene (gets restored and jumps away)
_rabbitSubid3:
	ld e,Interaction.state2		; $7a07
	ld a,(de)		; $7a09
	rst_jumpTable			; $7a0a
	.dw @substate0
	.dw @substate1
	.dw _rabbitSubid1@substate0
	.dw _rabbitSubid1@substate1

@substate0:
	call interactionDecCounter1		; $7a13
	ret nz			; $7a16
	ld (hl),$5a		; $7a17
	ld a,$01		; $7a19
	ld ($cfd1),a		; $7a1b
	ld a,SND_RESTORE		; $7a1e
	call playSound		; $7a20
	jp interactionIncState2		; $7a23

; This is also called from subid 5
@substate1:
	call interactionDecCounter1		; $7a26
	jr z,+			; $7a29
	jpab interactionBank08.childFlickerBetweenStone		; $7a2b
+
	call interactionIncState2		; $7a33
	ld l,Interaction.oamFlags		; $7a36
	ld (hl),$02		; $7a38
	ld l,Interaction.var38		; $7a3a
	ld (hl),$20		; $7a3c
	jp interactionCode4b_body@initSubid1		; $7a3e


; Rabbit being restored from stone cutscene (the one that wasn't stone)
_rabbitSubid4:
	ld e,Interaction.state2		; $7a41
	ld a,(de)		; $7a43
	rst_jumpTable			; $7a44
	.dw @substate0
	.dw @substate1
	.dw _rabbitSubid4Substate2
	.dw _rabbitSubid5@substate3
	.dw _rabbitSubid5@ret

@substate0:
	ld a,($cfd1)		; $7a4f
	cp $01			; $7a52
	jr nz,++		; $7a54

	ld h,d			; $7a56
	ld l,Interaction.state2		; $7a57
	ld (hl),$02		; $7a59
	ld hl,rabbitSubid4Script		; $7a5b
	jp interactionSetScript		; $7a5e
++
	call interactionAnimate		; $7a61
	ld e,Interaction.animParameter		; $7a64
	ld a,(de)		; $7a66
	or a			; $7a67
	ret z			; $7a68
	jp interactionIncState2		; $7a69

@substate1:
	ld c,$20		; $7a6c
	call objectUpdateSpeedZ_paramC		; $7a6e
	ret nz			; $7a71

	ld h,d			; $7a72
	ld l,Interaction.state2		; $7a73
	dec (hl)		; $7a75

;;
; @addr{7a76}
_rabbitJump:
	ld a,$07		; $7a76
	call interactionSetAnimation		; $7a78
	ld bc,-$e0		; $7a7b
	jp objectSetSpeedZ		; $7a7e


_rabbitSubid4Substate2:
	ld a,($cfd1)		; $7a81
	cp $02			; $7a84
	jp nz,interactionRunScript		; $7a86

	call interactionIncState2		; $7a89
	ld l,Interaction.angle		; $7a8c
	ld (hl),$18		; $7a8e

	ld l,Interaction.speed		; $7a90
	ld (hl),SPEED_a0		; $7a92
	ld bc,-$180		; $7a94
	call objectSetSpeedZ		; $7a97

	ld a,$09		; $7a9a
	jp interactionSetAnimation		; $7a9c

_rabbitSubid5:
	ld h,d			; $7a9f
	ld l,Interaction.var38		; $7aa0
	ld a,(hl)		; $7aa2
	or a			; $7aa3
	jr z,@updateSubstate	; $7aa4
	dec (hl)		; $7aa6
	jr nz,@updateSubstate	; $7aa7

	; Just collided with another rabbit?

	ld l,Interaction.state2		; $7aa9
	ld (hl),$04		; $7aab
	ld l,Interaction.angle		; $7aad
	ld (hl),$08		; $7aaf

	ld l,Interaction.speed		; $7ab1
	ld (hl),SPEED_a0		; $7ab3
	ld bc,-$1e0		; $7ab5
	call objectSetSpeedZ		; $7ab8

	ldbc INTERACID_CLINK,$80		; $7abb
	call objectCreateInteraction		; $7abe
	jr nz,@label_3f_367	; $7ac1

	ld a,SND_DAMAGE_ENEMY		; $7ac3
	call playSound		; $7ac5
	ld a,$02		; $7ac8
	ld ($cfd1),a		; $7aca

@label_3f_367:
	ld a,$08		; $7acd
	call interactionSetAnimation		; $7acf

@updateSubstate:
	ld e,Interaction.state2		; $7ad2
	ld a,(de)		; $7ad4
	rst_jumpTable			; $7ad5
	.dw @substate0
	.dw _rabbitSubid3@substate1
	.dw _rabbitSubid1@substate0
	.dw _rabbitSubid1@substate1
	.dw @substate3
	.dw @substate4

@substate0:
	ld h,d			; $7ae2
	ld l,Interaction.counter1		; $7ae3
	call decHlRef16WithCap		; $7ae5
	ret nz			; $7ae8

	ld (hl),$5a		; $7ae9
	call interactionIncState2		; $7aeb
	ld a,SND_RESTORE		; $7aee
	jp playSound		; $7af0

; Also called from subid 4
@substate3:
	call objectApplySpeed		; $7af3
	ld c,$20		; $7af6
	call objectUpdateSpeedZAndBounce		; $7af8
	ret nc			; $7afb

	call interactionIncState2		; $7afc
	ld l,Interaction.counter1		; $7aff
	ld (hl),$3c		; $7b01

@ret:
	ret			; $7b03

@substate4:
	call interactionDecCounter1		; $7b04
	ret nz			; $7b07

	ld a,$ff		; $7b08
	ld ($cfdf),a		; $7b0a
	ret			; $7b0d


; Generic NPC waiting around in the spot Nayru used to sing
_rabbitSubid7:
	call interactionRunScript		; $7b0e
	jp c,interactionDelete		; $7b11
	jp npcFaceLinkAndAnimate		; $7b14

;;
; This might be setting one of 4 possible speed values to var38?
; @addr{7b17}
_rabbitSubid2SetRandomSpawnDelay:
	call getRandomNumber_noPreserveVars		; $7b17
	and $03			; $7b1a
	ld bc,_rabbitSubid2SpawnDelays		; $7b1c
	call addAToBc		; $7b1f
	ld a,(bc)		; $7b22
	ld e,Interaction.var38		; $7b23
	ld (de),a		; $7b25
	ret			; $7b26

;;
; hl should point to "counter1".
; @addr{7b27}
_spawnNextRabbitThatTurnsToStone:
	; Increment counter2, the index of the rabbit to spawn (0-2)
	inc l			; $7b27
	ld a,(hl)		; $7b28
	inc (hl)		; $7b29

	ld b,a			; $7b2a
	add a			; $7b2b
	add b			; $7b2c
	ld hl,@data		; $7b2d
	rst_addAToHl			; $7b30
	ldi a,(hl)		; $7b31
	ld e,Interaction.counter1		; $7b32
	ld (de),a		; $7b34
	ld b,(hl)		; $7b35
	inc hl			; $7b36
	ld c,(hl)		; $7b37

	; Spawn a rabbit that will turn to stone after 95 frames
	call _spawnRabbitWithSubid1		; $7b38
	ld l,Interaction.counter1		; $7b3b
	ld (hl),95		; $7b3d
	ret			; $7b3f

; Data for the rabbits that turn to stone in a cutscene. Format:
;   b0: Frames until next rabbit is spawned?
;   b1: Y position
;   b2: X position
@data:
	.db $5a $28 $b8
	.db $1e $40 $a8
	.db $00 $50 $c8 

;;
; Spawns a rabbit for the cutscene where a bunch of rabbits turn to stone
;
; @param	bc	Position
; @addr{7b49}
_spawnRabbitWithSubid1;
	call getFreeInteractionSlot		; $7b49
	ret nz			; $7b4c
	ld (hl),INTERACID_RABBIT		; $7b4d
	inc l			; $7b4f
	inc (hl)		; $7b50
	jp interactionHSetPosition		; $7b51


; A byte from here is chosen randomly to spawn a rabbit at.
_rabbitSubid2YPositions:
	.db $66 $5e $58 $46 $3a $30 $20 $18

; A byte from here is chosen randomly as a delay before spawning another rabbit.
_rabbitSubid2SpawnDelays:
	.db $1e $3c $50 $78


; ==============================================================================
; INTERACID_TUNI_NUT
; ==============================================================================
interactionCodeb1_body:
	ld e,Interaction.state		; $7b60
	ld a,(de)		; $7b62
	rst_jumpTable			; $7b63
	.dw _tuniNut_state0
	.dw _tuniNut_state1
	.dw _tuniNut_state2
	.dw _tuniNut_state3
	.dw objectPreventLinkFromPassing


_tuniNut_state0:
	call interactionInitGraphics		; $7b6e
	ld a,GLOBALFLAG_TUNI_NUT_PLACED		; $7b71
	call checkGlobalFlag		; $7b73
	jr nz,_tuniNut_gotoState4	; $7b76

	ld a,TREASURE_TUNI_NUT		; $7b78
	call checkTreasureObtained		; $7b7a
	jr nc,@delete	; $7b7d
	cp $02			; $7b7f
	jr nz,@delete	; $7b81

	ld bc,$0810		; $7b83
	call objectSetCollideRadii		; $7b86
	jp interactionIncState		; $7b89

@delete:
	jp interactionDelete		; $7b8c


_tuniNut_gotoState4:
	ld bc,$1878		; $7b8f
	call interactionSetPosition		; $7b92
	ld l,Interaction.state		; $7b95
	ld (hl),$04		; $7b97
	ld a,$06		; $7b99
	call objectSetCollideRadius		; $7b9b
	jp objectSetVisible82		; $7b9e


; Waiting for Link to walk up to the object (currently invisible, acting as a cutscene trigger)
_tuniNut_state1:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $7ba1
	ret nc			; $7ba4
	call checkLinkCollisionsEnabled		; $7ba5
	ret nc			; $7ba8

	push de			; $7ba9
	call clearAllItemsAndPutLinkOnGround		; $7baa
	pop de			; $7bad

	ld a,DISABLE_LINK		; $7bae
	ld (wDisabledObjects),a		; $7bb0
	ld (wMenuDisabled),a		; $7bb3

	ld a,(w1Link.xh)		; $7bb6
	sub LARGE_ROOM_WIDTH<<3			; $7bb9
	jr z,@perfectlyCentered	; $7bbb
	jr c,@leftSide	; $7bbd

	; Right side
	ld b,DIR_LEFT		; $7bbf
	jr @moveToCenter		; $7bc1

@leftSide:
	cpl			; $7bc3
	inc a			; $7bc4
	ld b,DIR_RIGHT		; $7bc5

@moveToCenter:
	ld (wLinkStateParameter),a		; $7bc7
	ld e,Interaction.counter1		; $7bca
	ld (de),a		; $7bcc
	ld a,b			; $7bcd
	ld (w1Link.direction),a		; $7bce
	swap a			; $7bd1
	rrca			; $7bd3
	ld (w1Link.angle),a		; $7bd4
	ld a,LINK_STATE_FORCE_MOVEMENT		; $7bd7
	ld (wLinkForceState),a		; $7bd9
	jp interactionIncState		; $7bdc

@perfectlyCentered:
	call interactionIncState		; $7bdf
	jr _tuniNut_beginMovingIntoPlace		; $7be2


_tuniNut_state2:
	call interactionDecCounter1		; $7be4
	ret nz			; $7be7

_tuniNut_beginMovingIntoPlace:
	xor a			; $7be8
	ld (w1Link.direction),a		; $7be9

	ld e,Interaction.counter1		; $7bec
	ld a,60		; $7bee
	ld (de),a		; $7bf0

	ldbc INTERACID_SPARKLE, $07		; $7bf1
	call objectCreateInteraction		; $7bf4
	ld l,Interaction.relatedObj1		; $7bf7
	ld a,e			; $7bf9
	ldi (hl),a		; $7bfa
	ld a,d			; $7bfb
	ld (hl),a		; $7bfc

	call darkenRoomLightly		; $7bfd
	ld a,SNDCTRL_STOPMUSIC		; $7c00
	call playSound		; $7c02
	call objectSetVisiblec0		; $7c05
	jp interactionIncState		; $7c08


_tuniNut_state3:
	ld e,Interaction.state2		; $7c0b
	ld a,(de)		; $7c0d
	rst_jumpTable			; $7c0e
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	call interactionDecCounter1		; $7c1b
	ret nz			; $7c1e
	ld (hl),$10		; $7c1f
	jp interactionIncState2		; $7c21

@substate1:
	ld a,(wFrameCounter)		; $7c24
	rrca			; $7c27
	ret c			; $7c28
	ld h,d			; $7c29
	ld l,Interaction.zh		; $7c2a
	dec (hl)		; $7c2c
	call interactionDecCounter1		; $7c2d
	ret nz			; $7c30
	call objectCenterOnTile		; $7c31
	jp interactionIncState2		; $7c34

@substate2:
	ld b,SPEED_40		; $7c37
	ld c,$00		; $7c39
	ld e,Interaction.angle		; $7c3b
	call objectApplyGivenSpeed		; $7c3d
	ld e,Interaction.yh		; $7c40
	ld a,(de)		; $7c42
	cp $18			; $7c43
	ret nc			; $7c45
	call objectCenterOnTile		; $7c46
	jp interactionIncState2		; $7c49

@substate3:
	ld c,$20		; $7c4c
	call objectUpdateSpeedZ_paramC		; $7c4e
	ret nz			; $7c51
	ld a,SND_DROPESSENCE		; $7c52
	call playSound		; $7c54
	ld e,Interaction.counter1		; $7c57
	ld a,90		; $7c59
	ld (de),a		; $7c5b
	ld a,SND_SOLVEPUZZLE_2		; $7c5c
	call playSound		; $7c5e
	jp interactionIncState2		; $7c61

@substate4:
	call interactionDecCounter1		; $7c64
	ret nz			; $7c67
	call brightenRoom		; $7c68
	jp interactionIncState2		; $7c6b

@substate5:
	ld a,(wPaletteThread_mode)		; $7c6e
	or a			; $7c71
	ret nz			; $7c72

	ld a,GLOBALFLAG_TUNI_NUT_PLACED		; $7c73
	call setGlobalFlag		; $7c75

	ld a,TREASURE_TUNI_NUT		; $7c78
	call loseTreasure		; $7c7a

	call @setSymmetryVillageRoomFlags		; $7c7d

	xor a			; $7c80
	ld (wDisabledObjects),a		; $7c81
	ld (wMenuDisabled),a		; $7c84

	ld hl,wTmpcfc0.genericCutscene.state		; $7c87
	set 0,(hl)		; $7c8a

	ld a,(wActiveMusic)		; $7c8c
	call playSound		; $7c8f
	jp _tuniNut_gotoState4		; $7c92

;;
; Sets the room flags so present symmetry village is nice and cheerful now
; @addr{7c95}
@setSymmetryVillageRoomFlags:
	ld hl,wPresentRoomFlags+$02		; $7c95
	call @setRow		; $7c98
	ld l,$12		; $7c9b
@setRow:
	set 0,(hl)		; $7c9d
	inc l			; $7c9f
	set 0,(hl)		; $7ca0
	inc l			; $7ca2
	set 0,(hl)		; $7ca3
	inc l			; $7ca5
	ret			; $7ca6


.ifdef BUILD_VANILLA

; Garbage functions appear to follow (corrupted repeats of the above functions).

;;
; @addr{7ca7}
func_7ca7:
	jr -$30			; $7ca7
	call $2118		; $7ca9
	jp $2422		; $7cac

;;
; @addr{7caf}
func_7caf:
	ld c,$20		; $7caf
	call $1f83		; $7cb1
	ret nz			; $7cb4

	ld a,$77		; $7cb5
	call $0cb1		; $7cb7
	ld e,$46		; $7cba
	ld a,$5a		; $7cbc
	ld (de),a		; $7cbe
	ld a,$5b		; $7cbf
	call $0cb1		; $7cc1
	jp $2422		; $7cc4

;;
; @addr{7cc7}
func_7cc7:
	call $2409		; $7cc7
	ret nz			; $7cca
	call $33a2		; $7ccb
	jp $2422		; $7cce

;;
; @addr{7cd1}
func_7cd1:
	ld a,(wPaletteThread_mode)		; $7cd1
	or a			; $7cd4
	ret nz			; $7cd5
	ld a,$29		; $7cd6
	call $324b		; $7cd8
	ld a,$4c		; $7cdb
	call $1761		; $7cdd
	call $7cf8		; $7ce0
	xor a			; $7ce3
	ld (wDisabledObjects),a		; $7ce4
	ld (wMenuDisabled),a		; $7ce7
	ld hl,$cfc0		; $7cea
	set 0,(hl)		; $7ced
	ld a,(wActiveMusic)		; $7cef
	call $0cb1		; $7cf2
	jp $7bf2		; $7cf5

;;
; @addr{7cf8}
func_7cf8:
	ld hl,$c702		; $7cf8
	call $7d00		; $7cfb
	ld l,$12		; $7cfe
	set 0,(hl)		; $7d00
	inc l			; $7d02
	set 0,(hl)		; $7d03
	inc l			; $7d05
	set 0,(hl)		; $7d06
	inc l			; $7d08
	ret			; $7d09

.endif

.ends
