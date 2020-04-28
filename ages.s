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


; These 2 includes must be in the same bank
.include "build/data/roomPacks.s"
.include "build/data/musicAssignments.s"


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

.include "code/bank5.s"
.include "build/data/tileTypeMappings.s"
.include "build/data/cliffTilesTable.s"

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
	.include "code/collisionEffects.s"
.ends


 m_section_superfree "Item_Code" namespace "itemCode"
.include "code/updateItems.s"

.include "build/data/itemConveyorTilesTable.s"
.include "build/data/itemPassableCliffTilesTable.s"
.include "build/data/itemPassableTilesTable.s"


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
	ld a,SND_SWITCH2		; $598d
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
