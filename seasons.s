; Main file for Oracle of Seasons, US version

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
.include "include/musicMacros.s"

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

	ld de,$cbc1		; $551f
	ld a,(de)		; $5522
	rst_jumpTable			; $5523
	jr z,_label_03_112	; $5524
	ld sp,$cd5a		; $5526
	ld h,d			; $5529
	ld a,(de)		; $552a
	call $5534		; $552b
	call updateAllObjects		; $552e
	jp checkEnemyAndPartCollisionsIfTextInactive		; $5531
	ld de,$cbc2		; $5534
	ld a,(de)		; $5537
	rst_jumpTable			; $5538
	adc c			; $5539
	ld d,l			; $553a
	rst $30			; $553b
	ld d,l			; $553c
	rrca			; $553d
	ld d,(hl)		; $553e
	jr $56			; $553f
	ldi a,(hl)		; $5541
	ld d,(hl)		; $5542
	add hl,sp		; $5543
	ld d,(hl)		; $5544
	ld c,(hl)		; $5545
	ld d,(hl)		; $5546
	ld e,b			; $5547
	ld d,(hl)		; $5548
	or (hl)			; $5549
	ld d,(hl)		; $554a
	cp l			; $554b
	ld d,(hl)		; $554c
	rst_jumpTable			; $554d
	ld d,(hl)		; $554e
.DB $f4				; $554f
	ld d,(hl)		; $5550
	inc de			; $5551
	ld d,a			; $5552
	jr z,$57		; $5553
	dec sp			; $5555
	ld d,a			; $5556
	ld d,h			; $5557
	ld d,a			; $5558
	sbc c			; $5559
	ld d,a			; $555a
	or b			; $555b
	ld d,a			; $555c
	ret nz			; $555d
	ld d,a			; $555e
	ld (de),a		; $555f
	ld e,b			; $5560
	jr z,$58		; $5561
	ld a,$58		; $5563
	ld b,l			; $5565
	ld e,b			; $5566
	ld d,e			; $5567
	ld e,b			; $5568
	adc c			; $5569
	ld e,b			; $556a
	xor a			; $556b
	ld e,b			; $556c
	pop bc			; $556d
	ld e,b			; $556e
.DB $d3				; $556f
	ld e,b			; $5570
.DB $f4				; $5571
	ld e,b			; $5572
	ld ($1759),sp		; $5573
	ld e,c			; $5576
	ld a,a			; $5577
	ld e,c			; $5578
	sbc a			; $5579
	ld e,c			; $557a
_label_03_112:
	and a			; $557b
	ld e,c			; $557c
	or e			; $557d
	ld e,c			; $557e
	cp e			; $557f
	ld e,c			; $5580
	ret nz			; $5581
	ld e,c			; $5582
	call nc,$eb59		; $5583
	ld e,c			; $5586
	ld b,$5a		; $5587
	ld a,($c4ab)		; $5589
	or a			; $558c
	ret nz			; $558d
	ld b,$20		; $558e
	ld hl,$cfc0		; $5590
	call clearMemory		; $5593
	call incCbc2		; $5596
	xor a			; $5599
	ld bc,$0790		; $559a
	call $63d2		; $559d
	ld a,$0d		; $55a0
	call playSound		; $55a2
	call clearAllParentItems		; $55a5
	call dropLinkHeldItem		; $55a8
	ld c,$00		; $55ab
	call getFreeInteractionSlot		; $55ad
	jr nz,_label_03_113	; $55b0
	ld a,$a5		; $55b2
	ld ($cc1d),a		; $55b4
	ldi (hl),a		; $55b7
	ld (hl),c		; $55b8
	ld ($cc17),a		; $55b9
_label_03_113:
	ld a,c			; $55bc
	ld hl,$d000		; $55bd
	ld (hl),$03		; $55c0
	ld de,$55f3		; $55c2
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
	jr z,_label_03_114	; $55d9
	ld bc,$3050		; $55db
_label_03_114:
	ld hl,$ffa8		; $55de
	ld (hl),b		; $55e1
	ld hl,$ffaa		; $55e2
	ld (hl),c		; $55e5
	ld a,$80		; $55e6
	ld ($cca4),a		; $55e8
	ld a,$02		; $55eb
	call loadGfxRegisterStateIndex		; $55ed
	jp fadeinFromWhiteToRoom		; $55f0
	sbc c			; $55f3
	ret z			; $55f4
	sbc c			; $55f5
	cp b			; $55f6
	ld hl,$ccef		; $55f7
	ld (hl),$ff		; $55fa
	ld a,($c4ab)		; $55fc
	or a			; $55ff
	ret nz			; $5600
	ld a,($cfdf)		; $5601
	or a			; $5604
	ret z			; $5605
	call incCbc2		; $5606
	ld bc,$3d00		; $5609
	jp showText		; $560c
	call retIfTextIsActive		; $560f
	call incCbc2		; $5612
	jp fastFadeoutToWhite		; $5615
	ld a,($c4ab)		; $5618
	or a			; $561b
	ret nz			; $561c
	call incCbc2		; $561d
	ld hl,$cbb3		; $5620
	ld (hl),$3c		; $5623
	inc l			; $5625
	ld (hl),$00		; $5626
	jr _label_03_115		; $5628
	call $6462		; $562a
	ret nz			; $562d
	call incCbc2		; $562e
	ld a,$c1		; $5631
	call playSound		; $5633
	jp fadeoutToWhite		; $5636
	ld a,($c4ab)		; $5639
	or a			; $563c
	ret nz			; $563d
	call incCbc2		; $563e
	ld a,$00		; $5641
	call $644c		; $5643
	ld hl,$cbb3		; $5646
	ld (hl),$3c		; $5649
	jp fadeinFromWhite		; $564b
	call $6462		; $564e
	ret nz			; $5651
	call incCbc2		; $5652
	jp fastFadeoutToWhite		; $5655
	ld a,($c4ab)		; $5658
	or a			; $565b
	ret nz			; $565c
_label_03_115:
	call clearDynamicInteractions		; $565d
	ld hl,$cbb3		; $5660
	ld (hl),$3c		; $5663
	inc l			; $5665
	ld a,(hl)		; $5666
	ld hl,$56ac		; $5667
	rst_addDoubleIndex			; $566a
	ld c,(hl)		; $566b
	inc hl			; $566c
	ld b,(hl)		; $566d
	ld a,$03		; $566e
	call $63d2		; $5670
	call fastFadeinFromWhite		; $5673
	ld hl,$cbb4		; $5676
	ld a,(hl)		; $5679
	ld b,a			; $567a
	inc (hl)		; $567b
	cp $04			; $567c
	jr nc,_label_03_116	; $567e
	ld c,$04		; $5680
	push bc			; $5682
	ld a,$02		; $5683
	call loadGfxRegisterStateIndex		; $5685
	call resetCamera		; $5688
	pop bc			; $568b
	jr _label_03_117		; $568c
_label_03_116:
	ld hl,$cbb3		; $568e
	ld (hl),$3c		; $5691
	push bc			; $5693
	ld c,$01		; $5694
	call $55ad		; $5696
	pop bc			; $5699
	ld c,$08		; $569a
	call checkIsLinkedGame		; $569c
	ld b,$ff		; $569f
	jr z,_label_03_117	; $56a1
	ld c,$0d		; $56a3
_label_03_117:
	ld hl,$cbc2		; $56a5
	ld (hl),c		; $56a8
	jp $6405		; $56a9
	rst $20			; $56ac
	nop			; $56ad
	ld d,h			; $56ae
	nop			; $56af
	pop de			; $56b0
	nop			; $56b1
	ld e,(hl)		; $56b2
	nop			; $56b3
	sub b			; $56b4
	rlca			; $56b5
	ld e,$3c		; $56b6
	ld bc,$3d01		; $56b8
	jr _label_03_118		; $56bb
	call $645a		; $56bd
	ret nz			; $56c0
	call incCbc2		; $56c1
	jp fadeoutToWhite		; $56c4
	ld a,($c4ab)		; $56c7
	or a			; $56ca
	ret nz			; $56cb
	call incCbc2		; $56cc
	ld hl,$cbb3		; $56cf
	ld (hl),$3c		; $56d2
	ld a,$ff		; $56d4
	ld ($cd25),a		; $56d6
	call disableLcd		; $56d9
	ld a,$2b		; $56dc
	call loadGfxHeader		; $56de
	ld a,$9d		; $56e1
	call loadPaletteHeader		; $56e3
	call $539c		; $56e6
	call $5ab0		; $56e9
	ld a,$04		; $56ec
	call loadGfxRegisterStateIndex		; $56ee
	jp fadeinFromWhite		; $56f1
	call $5ab0		; $56f4
	call $6462		; $56f7
	ret nz			; $56fa
	call incCbc2		; $56fb
	ld hl,$cc02		; $56fe
	ld (hl),$01		; $5701
	ld hl,$cbb3		; $5703
	ld (hl),$3c		; $5706
	ld bc,$3d02		; $5708
	ld a,$01		; $570b
	ld ($cbae),a		; $570d
	jp showText		; $5710
	call $5ab0		; $5713
	call $645a		; $5716
	ret nz			; $5719
	call $646a		; $571a
	ld a,$01		; $571d
	ld ($cbc1),a		; $571f
	call disableActiveRing		; $5722
	jp fadeoutToWhite		; $5725
	ld e,$3c		; $5728
	ld bc,$4f00		; $572a
_label_03_118:
	call $6462		; $572d
	ret nz			; $5730
	call incCbc2		; $5731
	ld a,e			; $5734
	ld ($cbb3),a		; $5735
	jp showText		; $5738
	call $645a		; $573b
	ret nz			; $573e
	xor a			; $573f
	ld ($cbb3),a		; $5740
	dec a			; $5743
	ld ($cbba),a		; $5744
	ld a,$d2		; $5747
	call playSound		; $5749
	ld a,$f0		; $574c
	call playSound		; $574e
	jp incCbc2		; $5751
	ld hl,$cbb3		; $5754
	ld b,$02		; $5757
	call flashScreen		; $5759
	ret z			; $575c
	call incCbc2		; $575d
	xor a			; $5760
	ld bc,$059a		; $5761
	call $63d2		; $5764
	ld a,$ac		; $5767
	call loadPaletteHeader		; $5769
	call hideStatusBar		; $576c
	call $5504		; $576f
	ld b,$06		; $5772
_label_03_119:
	call getFreeInteractionSlot		; $5774
	jr nz,_label_03_120	; $5777
	ld (hl),$b0		; $5779
	inc l			; $577b
	dec b			; $577c
	ld (hl),b		; $577d
	jr nz,_label_03_119	; $577e
_label_03_120:
	ld hl,$cbb3		; $5780
	ld (hl),$1e		; $5783
	ld a,$13		; $5785
	call loadGfxRegisterStateIndex		; $5787
	ld hl,$c486		; $578a
	ldi a,(hl)		; $578d
	ldh (<hCameraY),a	; $578e
	ld a,(hl)		; $5790
	ldh (<hCameraX),a	; $5791
	ld a,$00		; $5793
	ld ($cd00),a		; $5795
	ret			; $5798
	call decCbb3		; $5799
	ret nz			; $579c
	call incCbc2		; $579d
	ld hl,$cbb3		; $57a0
	ld (hl),$28		; $57a3
	ld a,$04		; $57a5
	ld ($cbae),a		; $57a7
	ld bc,$4f01		; $57aa
	jp showText		; $57ad
	call $645a		; $57b0
	ret nz			; $57b3
	call incCbc2		; $57b4
	ld a,$20		; $57b7
	ld hl,$cbb3		; $57b9
	ldi (hl),a		; $57bc
	xor a			; $57bd
	ld (hl),a		; $57be
	ret			; $57bf
	call $6462		; $57c0
	ret nz			; $57c3
	ld hl,$cbb3		; $57c4
	ld (hl),$20		; $57c7
	inc hl			; $57c9
	ld a,(hl)		; $57ca
	cp $03			; $57cb
	jr nc,_label_03_121	; $57cd
	ld b,a			; $57cf
	push hl			; $57d0
	ld a,$72		; $57d1
	call playSound		; $57d3
	pop hl			; $57d6
	ld a,b			; $57d7
_label_03_121:
	inc (hl)		; $57d8
	ld hl,$580c		; $57d9
	rst_addAToHl			; $57dc
	ld a,(hl)		; $57dd
	or a			; $57de
	ld b,a			; $57df
	jr nz,_label_03_122	; $57e0
	call fadeinFromBlack		; $57e2
	ld a,$01		; $57e5
	ld ($c4b2),a		; $57e7
	ld ($c4b4),a		; $57ea
	ld hl,$cbb3		; $57ed
	ld (hl),$3c		; $57f0
	ld a,$21		; $57f2
	call playSound		; $57f4
	jp incCbc2		; $57f7
_label_03_122:
	call fastFadeinFromBlack		; $57fa
	ld a,b			; $57fd
	ld ($c4b2),a		; $57fe
	ld ($c4b4),a		; $5801
	xor a			; $5804
	ld ($c4b1),a		; $5805
	ld ($c4b3),a		; $5808
	ret			; $580b
	stop			; $580c
	ld b,b			; $580d
	add b			; $580e
	jr z,_label_03_123	; $580f
	nop			; $5811
	ld e,$28		; $5812
	ld bc,$4f02		; $5814
_label_03_123:
	call $581d		; $5817
	jp $572d		; $581a
	ld a,$08		; $581d
	ld ($cbae),a		; $581f
	ld a,$03		; $5822
	ld ($cbac),a		; $5824
	ret			; $5827
	ld e,$28		; $5828
	ld bc,$4f03		; $582a
_label_03_124:
	call $645a		; $582d
	ret nz			; $5830
	call incCbc2		; $5831
	ld hl,$cbb3		; $5834
	ld (hl),e		; $5837
	call $581d		; $5838
	jp showText		; $583b
	ld e,$3c		; $583e
	ld bc,$4f04		; $5840
	jr _label_03_124		; $5843
	ld e,$b4		; $5845
	call $645a		; $5847
	ret nz			; $584a
	call incCbc2		; $584b
	ld hl,$cbb3		; $584e
	ld (hl),e		; $5851
	ret			; $5852
	ld hl,$c486		; $5853
	ldh a,(<hCameraY)	; $5856
	ldi (hl),a		; $5858
	ldh a,(<hCameraX)	; $5859
	ldi (hl),a		; $585b
	ld hl,$5881		; $585c
	ld de,$c486		; $585f
	call $79cd		; $5862
	inc de			; $5865
	call $79cd		; $5866
	call $5d00		; $5869
	call decCbb3		; $586c
	ret nz			; $586f
	dec a			; $5870
	ld ($cbba),a		; $5871
	ld a,$d2		; $5874
	call playSound		; $5876
	ld a,$f0		; $5879
	call playSound		; $587b
	jp incCbc2		; $587e
	rst $38			; $5881
	ld bc,$0100		; $5882
	nop			; $5885
	nop			; $5886
	rst $38			; $5887
	nop			; $5888
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
	ld bc,$0790		; $58a4
	call $63d2		; $58a7
	ld c,$01		; $58aa
	jp $55ad		; $58ac
	call decCbb3		; $58af
	ret nz			; $58b2
	call incCbc2		; $58b3
	ld hl,$cbb3		; $58b6
	ld (hl),$1e		; $58b9
	ld bc,$3d17		; $58bb
	jp showText		; $58be
	call $645a		; $58c1
	ret nz			; $58c4
	call incCbc2		; $58c5
	ld hl,$cbb3		; $58c8
	ld (hl),$1e		; $58cb
	ld bc,$4f09		; $58cd
	jp showText		; $58d0
	call $645a		; $58d3
	ret nz			; $58d6
	call incCbc2		; $58d7
	ld c,$40		; $58da
	ld a,$29		; $58dc
	call giveTreasure		; $58de
	ld a,$08		; $58e1
	call setLinkIDOverride		; $58e3
	ld l,$02		; $58e6
	ld (hl),$07		; $58e8
	ld hl,$cbb3		; $58ea
	ld (hl),$5a		; $58ed
	ld a,$4a		; $58ef
	jp playSound		; $58f1
	call decCbb3		; $58f4
	ret nz			; $58f7
	call incCbc2		; $58f8
	ld hl,$cbb3		; $58fb
	ld (hl),$b4		; $58fe
	ld bc,$90bd		; $5900
	ld a,$ff		; $5903
	jp createEnergySwirlGoingOut		; $5905
	call decCbb3		; $5908
	ret nz			; $590b
	call incCbc2		; $590c
	ld hl,$cbb3		; $590f
	ld (hl),$3c		; $5912
	jp fadeoutToWhite		; $5914
	call $6462		; $5917
	ret nz			; $591a
	call incCbc2		; $591b
	call disableLcd		; $591e
	call clearOam		; $5921
	call clearDynamicInteractions		; $5924
	call refreshObjectGfx		; $5927
	call hideStatusBar		; $592a
	ld a,$02		; $592d
	ld ($ff00+$70),a	; $592f
	ld hl,$de90		; $5931
	ld b,$08		; $5934
	ld a,$ff		; $5936
	call fillMemory		; $5938
	xor a			; $593b
	ld ($ff00+$70),a	; $593c
	ld a,$07		; $593e
	ldh (<hDirtyBgPalettes),a	; $5940
	ld b,$02		; $5942
_label_03_125:
	call getFreeInteractionSlot		; $5944
	jr nz,_label_03_126	; $5947
	ld (hl),$b0		; $5949
	inc l			; $594b
	ld a,$05		; $594c
	add b			; $594e
	ld (hl),a		; $594f
	dec b			; $5950
	jr nz,_label_03_125	; $5951
_label_03_126:
	ld a,$02		; $5953
	ld ($cbcb),a		; $5955
	call $7a6b		; $5958
	ld a,$02		; $595b
	call $7a88		; $595d
	ld hl,$cbb3		; $5960
	ld (hl),$1e		; $5963
	ld a,$04		; $5965
	call loadGfxRegisterStateIndex		; $5967
	ld a,$10		; $596a
	ldh (<hCameraY),a	; $596c
	ld ($cd2d),a		; $596e
	xor a			; $5971
	ldh (<hCameraX),a	; $5972
	ld a,$00		; $5974
	ld ($cd00),a		; $5976
	ld bc,$4f05		; $5979
	jp showText		; $597c
	call $645a		; $597f
	ret nz			; $5982
	call incCbc2		; $5983
	ld b,$02		; $5986
	call fadeinFromWhite		; $5988
	ld a,b			; $598b
	ld ($c4b2),a		; $598c
	ld ($c4b4),a		; $598f
	xor a			; $5992
	ld ($c4b1),a		; $5993
	ld ($c4b3),a		; $5996
	ld hl,$cbb3		; $5999
	ld (hl),$3c		; $599c
	ret			; $599e
	ld e,$1e		; $599f
	ld bc,$4f06		; $59a1
	jp $572d		; $59a4
	call $645a		; $59a7
	ret nz			; $59aa
	call incCbc2		; $59ab
	ld b,$14		; $59ae
	jp $5988		; $59b0
	ld e,$1e		; $59b3
	ld bc,$4f07		; $59b5
	jp $572d		; $59b8
	ld e,$3c		; $59bb
	jp $5847		; $59bd
	call decCbb3		; $59c0
	ret nz			; $59c3
	call incCbc2		; $59c4
	ld hl,$cbb3		; $59c7
	ld (hl),$f0		; $59ca
	ld a,$ff		; $59cc
	ld bc,$4850		; $59ce
	jp createEnergySwirlGoingOut		; $59d1
	call decCbb3		; $59d4
	ret nz			; $59d7
	ld hl,$cbb3		; $59d8
	ld (hl),$5a		; $59db
	call fadeoutToWhite		; $59dd
	ld a,$fc		; $59e0
	ld ($c4b1),a		; $59e2
	ld ($c4b3),a		; $59e5
	jp incCbc2		; $59e8
	call $6462		; $59eb
	ret nz			; $59ee
	call incCbc2		; $59ef
	call clearDynamicInteractions		; $59f2
	call clearParts		; $59f5
	call clearOam		; $59f8
	ld hl,$cbb3		; $59fb
	ld (hl),$3c		; $59fe
	ld bc,$4f08		; $5a00
	jp showTextNonExitable		; $5a03
	ld a,($cba0)		; $5a06
	rlca			; $5a09
	ret nc			; $5a0a
	call decCbb3		; $5a0b
	ret nz			; $5a0e
	call showStatusBar		; $5a0f
	xor a			; $5a12
	ld ($cbcb),a		; $5a13
	dec a			; $5a16
	ld (wActiveMusic),a		; $5a17
	ld a,$f0		; $5a1a
	call playSound		; $5a1c
	ld hl,$cc63		; $5a1f
	ld a,$85		; $5a22
	ldi (hl),a		; $5a24
	ld a,$9d		; $5a25
	ldi (hl),a		; $5a27
	ld a,$0f		; $5a28
	ldi (hl),a		; $5a2a
	ld a,$57		; $5a2b
	ldi (hl),a		; $5a2d
	ld (hl),$03		; $5a2e
	ret			; $5a30
	call $5a37		; $5a31
	jp updateAllObjects		; $5a34
	ld de,$cbc2		; $5a37
	ld a,(de)		; $5a3a
	rst_jumpTable			; $5a3b
	ld d,b			; $5a3c
	ld e,d			; $5a3d
	ld a,l			; $5a3e
	ld e,d			; $5a3f
	adc d			; $5a40
	ld e,d			; $5a41
	cp h			; $5a42
	ld e,d			; $5a43
	jp nc,$e35a		; $5a44
	ld e,d			; $5a47
	rst $38			; $5a48
	ld e,d			; $5a49
	inc d			; $5a4a
	ld e,e			; $5a4b
	dec hl			; $5a4c
	ld e,e			; $5a4d
	add c			; $5a4e
	ld e,e			; $5a4f
	call $5ab0		; $5a50
	ld a,($c4ab)		; $5a53
	or a			; $5a56
	ret nz			; $5a57
	call incCbc2		; $5a58
	ld hl,$cbb3		; $5a5b
	ld (hl),$3c		; $5a5e
	call disableLcd		; $5a60
	call clearOam		; $5a63
	ld a,$2c		; $5a66
	call loadGfxHeader		; $5a68
	ld a,$9e		; $5a6b
	call loadPaletteHeader		; $5a6d
	ld a,$04		; $5a70
	call loadGfxRegisterStateIndex		; $5a72
	ld a,$21		; $5a75
	call playSound		; $5a77
	jp fadeinFromWhite		; $5a7a
	ld a,$01		; $5a7d
	ld ($cbae),a		; $5a7f
	ld a,$3c		; $5a82
	ld bc,$3d03		; $5a84
	jp $572d		; $5a87
	call $645a		; $5a8a
	ret nz			; $5a8d
	call incCbc2		; $5a8e
	ld hl,$cbb5		; $5a91
	ld (hl),$d0		; $5a94
_label_03_127:
	ld hl,$6472		; $5a96
_label_03_128:
	ld b,$30		; $5a99
	ld de,$cbb5		; $5a9b
	ld a,(de)		; $5a9e
	ld c,a			; $5a9f
	jr _label_03_129		; $5aa0
	ld hl,$4da3		; $5aa2
	ld e,$15		; $5aa5
	ld bc,$3038		; $5aa7
	xor a			; $5aaa
	ldh (<hOamTail),a	; $5aab
	jp addSpritesFromBankToOam_withOffset		; $5aad
	ld hl,$65a4		; $5ab0
	ld bc,$3038		; $5ab3
_label_03_129:
	xor a			; $5ab6
	ldh (<hOamTail),a	; $5ab7
	jp addSpritesToOam_withOffset		; $5ab9
	ld hl,$cbb5		; $5abc
	inc (hl)		; $5abf
	jr nz,_label_03_127	; $5ac0
	call clearOam		; $5ac2
	ld a,UNCMP_GFXH_0a		; $5ac5
	call loadUncompressedGfxHeader		; $5ac7
	ld hl,$cbb3		; $5aca
	ld (hl),$1e		; $5acd
	jp incCbc2		; $5acf
	call decCbb3		; $5ad2
	ret nz			; $5ad5
	call incCbc2		; $5ad6
	ld hl,$cbb5		; $5ad9
	ld (hl),$d0		; $5adc
	ld hl,$650b		; $5ade
	jr _label_03_128		; $5ae1
	call $5ade		; $5ae3
	ld hl,$cbb5		; $5ae6
	dec (hl)		; $5ae9
	ld a,(hl)		; $5aea
	sub $a0			; $5aeb
	ret nz			; $5aed
	ld ($cd08),a		; $5aee
	ld ($cd09),a		; $5af1
	ld a,$1e		; $5af4
	ld ($cbb3),a		; $5af6
	ld ($cbcb),a		; $5af9
	jp incCbc2		; $5afc
	call $5ade		; $5aff
	call decCbb3		; $5b02
	ret nz			; $5b05
	ld hl,$cbb3		; $5b06
	ld (hl),$14		; $5b09
	ld bc,$3d04		; $5b0b
	call $570b		; $5b0e
	jp incCbc2		; $5b11
	call $5ade		; $5b14
	call $645a		; $5b17
	ret nz			; $5b1a
	xor a			; $5b1b
	ld ($cbcb),a		; $5b1c
	dec a			; $5b1f
	ld ($cbba),a		; $5b20
	ld a,$d2		; $5b23
	call playSound		; $5b25
	jp incCbc2		; $5b28
	call $5ade		; $5b2b
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
	ld ($ff00+$4f),a	; $5b46
	ld hl,$8000		; $5b48
	ld bc,$2000		; $5b4b
	call clearMemoryBc		; $5b4e
	xor a			; $5b51
	ld ($ff00+$4f),a	; $5b52
	ld hl,$9c00		; $5b54
	ld bc,$0400		; $5b57
	call clearMemoryBc		; $5b5a
	ld a,$01		; $5b5d
	ld ($ff00+$4f),a	; $5b5f
	ld hl,$9c00		; $5b61
	ld bc,$0400		; $5b64
	call clearMemoryBc		; $5b67
	ld a,$2d		; $5b6a
	call loadGfxHeader		; $5b6c
	ld a,$9c		; $5b6f
	call loadPaletteHeader		; $5b71
	ld a,$04		; $5b74
	call loadGfxRegisterStateIndex		; $5b76
	ld a,$d2		; $5b79
	call playSound		; $5b7b
	jp clearPaletteFadeVariablesAndRefreshPalettes		; $5b7e
	call decCbb3		; $5b81
	ret nz			; $5b84
	ld a,$0a		; $5b85
	ld ($c2ef),a		; $5b87
	call $646a		; $5b8a
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
	ld de,$cbc1		; $5bad
	ld a,(de)		; $5bb0
	rst_jumpTable			; $5bb1
	or (hl)			; $5bb2
	ld e,e			; $5bb3
	ld e,$5d		; $5bb4
	call updateStatusBar		; $5bb6
	call $5bbf		; $5bb9
	jp updateAllObjects		; $5bbc
	ld de,$cbc2		; $5bbf
	ld a,(de)		; $5bc2
	rst_jumpTable			; $5bc3
	ld ($ff00+$5b),a	; $5bc4
	add hl,bc		; $5bc6
	ld e,h			; $5bc7
	ld a,(de)		; $5bc8
	ld e,h			; $5bc9
	inc l			; $5bca
	ld e,h			; $5bcb
	ld b,(hl)		; $5bcc
	ld e,h			; $5bcd
	ld e,d			; $5bce
	ld e,h			; $5bcf
	ld l,c			; $5bd0
	ld e,h			; $5bd1
	ld a,l			; $5bd2
	ld e,h			; $5bd3
	adc a			; $5bd4
	ld e,h			; $5bd5
	and e			; $5bd6
	ld e,h			; $5bd7
	cp b			; $5bd8
	ld e,h			; $5bd9
	cp l			; $5bda
	ld e,h			; $5bdb
	rst_addAToHl			; $5bdc
	ld e,h			; $5bdd
	jp hl			; $5bde
	ld e,h			; $5bdf
	ld a,$01		; $5be0
	ld (de),a		; $5be2
	ld hl,$c6c5		; $5be3
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
	call decCbb3		; $5c09
	ret nz			; $5c0c
	ld hl,$cbb3		; $5c0d
	ld (hl),$1e		; $5c10
	ld a,$f0		; $5c12
	call playSound		; $5c14
	jp incCbc2		; $5c17
	call $5cfb		; $5c1a
	call decCbb3		; $5c1d
	ret nz			; $5c20
	call incCbc2		; $5c21
	ld hl,$cbb3		; $5c24
	ld (hl),$96		; $5c27
	jp $5d0b		; $5c29
	call $5cfb		; $5c2c
	call decCbb3		; $5c2f
	ret nz			; $5c32
	call incCbc2		; $5c33
	ld a,$f1		; $5c36
	call playSound		; $5c38
	ld hl,$cbb3		; $5c3b
	ld (hl),$3c		; $5c3e
	ld bc,$3d0e		; $5c40
	jp showText		; $5c43
	call $645a		; $5c46
	ret nz			; $5c49
	call incCbc2		; $5c4a
	ld a,$21		; $5c4d
	call playSound		; $5c4f
	ld hl,$cbb3		; $5c52
	ld (hl),$3c		; $5c55
	jp $5d0b		; $5c57
	call $5cfb		; $5c5a
	call decCbb3		; $5c5d
	ret nz			; $5c60
	ld hl,$cbb3		; $5c61
	ld (hl),$5a		; $5c64
	jp incCbc2		; $5c66
	call $5cfb		; $5c69
	call decCbb3		; $5c6c
	ret nz			; $5c6f
	call incCbc2		; $5c70
	ld hl,$cbb3		; $5c73
	ld (hl),$3c		; $5c76
	ld a,$f1		; $5c78
	jp playSound		; $5c7a
	call decCbb3		; $5c7d
	ret nz			; $5c80
	call incCbc2		; $5c81
	ld hl,$cbb3		; $5c84
	ld (hl),$3c		; $5c87
	ld bc,$3d0f		; $5c89
	jp showText		; $5c8c
	call $645a		; $5c8f
	ret nz			; $5c92
	call incCbc2		; $5c93
	ld hl,$cbb3		; $5c96
	ld (hl),$2c		; $5c99
	inc hl			; $5c9b
	ld (hl),$01		; $5c9c
	ld b,$03		; $5c9e
	jp $5d12		; $5ca0
	ld hl,$cbb3		; $5ca3
	call decHlRef16WithCap		; $5ca6
	ret nz			; $5ca9
	call incCbc2		; $5caa
	ld hl,$cbb3		; $5cad
	ld (hl),$3c		; $5cb0
	ld bc,$3d10		; $5cb2
	jp showText		; $5cb5
	ld e,$1e		; $5cb8
	jp $5847		; $5cba
	call $5cfb		; $5cbd
	call decCbb3		; $5cc0
	ret nz			; $5cc3
	call incCbc2		; $5cc4
	call $5d0b		; $5cc7
	ld a,$8c		; $5cca
	ld ($cbb3),a		; $5ccc
	ld a,$ff		; $5ccf
	ld bc,$4478		; $5cd1
	jp createEnergySwirlGoingOut		; $5cd4
	call $5cfb		; $5cd7
	call decCbb3		; $5cda
	ret nz			; $5cdd
	call incCbc2		; $5cde
	ld hl,$cbb3		; $5ce1
	ld (hl),$3c		; $5ce4
	jp $5d0b		; $5ce6
	call $5cfb		; $5ce9
	call decCbb3		; $5cec
	ret nz			; $5cef
	call incCbc1		; $5cf0
	inc l			; $5cf3
	xor a			; $5cf4
	ld (hl),a		; $5cf5
	ld a,$03		; $5cf6
	jp fadeoutToWhiteWithDelay		; $5cf8
	ld a,$04		; $5cfb
	call setScreenShakeCounter		; $5cfd
	ld a,(wFrameCounter)		; $5d00
	and $0f			; $5d03
	ld a,$b8		; $5d05
	jp z,playSound		; $5d07
	ret			; $5d0a
	call getFreePartSlot		; $5d0b
	ret nz			; $5d0e
	ld (hl),$48		; $5d0f
	ret			; $5d11
	call getFreeInteractionSlot		; $5d12
	ret nz			; $5d15
	ld (hl),$48		; $5d16
	inc l			; $5d18
	ld (hl),$00		; $5d19
	inc l			; $5d1b
	ld (hl),b		; $5d1c
	ret			; $5d1d
	call updateStatusBar		; $5d1e
	call $5d27		; $5d21
	jp updateAllObjects		; $5d24
	ld de,$cbc2		; $5d27
	ld a,(de)		; $5d2a
	rst_jumpTable			; $5d2b
	ld b,d			; $5d2c
	ld e,l			; $5d2d
	ld a,a			; $5d2e
	ld e,l			; $5d2f
	sub e			; $5d30
	ld e,l			; $5d31
	and d			; $5d32
	ld e,l			; $5d33
	cp l			; $5d34
	ld e,l			; $5d35
.DB $d3				; $5d36
	ld e,l			; $5d37
	rst $20			; $5d38
	ld e,l			; $5d39
	nop			; $5d3a
	ld e,(hl)		; $5d3b
	ld c,$5e		; $5d3c
	dec sp			; $5d3e
	ld e,(hl)		; $5d3f
	ld c,a			; $5d40
	ld e,(hl)		; $5d41
	call $5cfb		; $5d42
	ld a,($c4ab)		; $5d45
	or a			; $5d48
	ret nz			; $5d49
	call incCbc2		; $5d4a
	xor a			; $5d4d
	ld bc,$022b		; $5d4e
	call $63d2		; $5d51
	call refreshObjectGfx		; $5d54
	ld b,$0c		; $5d57
	call getEntryFromObjectTable1		; $5d59
	ld d,h			; $5d5c
	ld e,l			; $5d5d
	call parseGivenObjectData		; $5d5e
	ld a,$04		; $5d61
	ld b,$02		; $5d63
	call $642e		; $5d65
	ld a,$f1		; $5d68
	call playSound		; $5d6a
	ld a,$fa		; $5d6d
	call playSound		; $5d6f
	ld a,$02		; $5d72
	call loadGfxRegisterStateIndex		; $5d74
	ld hl,$cbb3		; $5d77
	ld (hl),$3c		; $5d7a
	jp fadeinFromWhiteToRoom		; $5d7c
	call $6462		; $5d7f
	ret nz			; $5d82
	call incCbc2		; $5d83
	ld a,$3c		; $5d86
	ld ($cbb3),a		; $5d88
	ld a,$64		; $5d8b
	ld bc,$5850		; $5d8d
	jp createEnergySwirlGoingIn		; $5d90
	call decCbb3		; $5d93
	ret nz			; $5d96
	xor a			; $5d97
	ld ($cbb3),a		; $5d98
	dec a			; $5d9b
	ld ($cbba),a		; $5d9c
	jp incCbc2		; $5d9f
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
	call $6462		; $5dbd
	ret nz			; $5dc0
	ld a,$01		; $5dc1
	ld ($cc17),a		; $5dc3
	ld a,$29		; $5dc6
	call playSound		; $5dc8
	ld hl,$cbb3		; $5dcb
	ld (hl),$3c		; $5dce
	jp incCbc2		; $5dd0
	call decCbb3		; $5dd3
	ret nz			; $5dd6
	call incCbc2		; $5dd7
	ld hl,$cbb3		; $5dda
	ld (hl),$2c		; $5ddd
	inc hl			; $5ddf
	ld (hl),$01		; $5de0
	ld b,$00		; $5de2
	jp $5d12		; $5de4
	ld hl,$cbb3		; $5de7
	call decHlRef16WithCap		; $5dea
	ret nz			; $5ded
	ld a,$01		; $5dee
	ld ($cc17),a		; $5df0
	ld hl,$cbb3		; $5df3
	ld (hl),$3c		; $5df6
	ld hl,$cfc0		; $5df8
	ld (hl),$02		; $5dfb
	jp incCbc2		; $5dfd
	ld a,($cfc0)		; $5e00
	cp $09			; $5e03
	ret nz			; $5e05
	call incCbc2		; $5e06
	ld a,$03		; $5e09
	jp fadeoutToWhiteWithDelay		; $5e0b
	ld a,($c4ab)		; $5e0e
	or a			; $5e11
	ret nz			; $5e12
	call incCbc2		; $5e13
	call disableLcd		; $5e16
	call clearScreenVariablesAndWramBank1		; $5e19
	call hideStatusBar		; $5e1c
	ld a,$3c		; $5e1f
	call loadGfxHeader		; $5e21
	ld a,$ad		; $5e24
	call loadPaletteHeader		; $5e26
	ld hl,$cbb3		; $5e29
	ld (hl),$f0		; $5e2c
	ld a,$04		; $5e2e
	call loadGfxRegisterStateIndex		; $5e30
	call $5aa2		; $5e33
	ld a,$03		; $5e36
	jp fadeinFromWhiteWithDelay		; $5e38
	call $5aa2		; $5e3b
	call $6462		; $5e3e
	ret nz			; $5e41
	call incCbc2		; $5e42
	ld hl,$cbb3		; $5e45
	ld (hl),$10		; $5e48
	ld a,$03		; $5e4a
	jp fadeoutToBlackWithDelay		; $5e4c
	call $5aa2		; $5e4f
	call $6462		; $5e52
	ret nz			; $5e55
	ld a,$0a		; $5e56
	ld ($c2ef),a		; $5e58
	call $646a		; $5e5b
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
	ld a,$fb		; $5e7a
	jp playSound		; $5e7c
	call $5e85		; $5e7f
	jp func_3539		; $5e82
	ld de,$cbc1		; $5e85
	ld a,(de)		; $5e88
	rst_jumpTable			; $5e89
	sub d			; $5e8a
	ld e,(hl)		; $5e8b
.DB $f4				; $5e8c
	ld e,(hl)		; $5e8d
	ld l,l			; $5e8e
	ld h,b			; $5e8f
	ld a,($1161)		; $5e90
	jp nz,$1acb		; $5e93
	rst_jumpTable			; $5e96
	sbc l			; $5e97
	ld e,(hl)		; $5e98
	cp h			; $5e99
	ld e,(hl)		; $5e9a
	ret c			; $5e9b
	ld e,(hl)		; $5e9c
	call $6462		; $5e9d
	ret nz			; $5ea0
	call $66dc		; $5ea1
	call incCbc2		; $5ea4
	call clearOam		; $5ea7
	ld hl,$cbb3		; $5eaa
	ld (hl),$b4		; $5ead
	inc hl			; $5eaf
	ld (hl),$00		; $5eb0
	ld hl,$c485		; $5eb2
	set 3,(hl)		; $5eb5
	ld a,$2a		; $5eb7
	jp playSound		; $5eb9
	ld hl,$cbb3		; $5ebc
	call decHlRef16WithCap		; $5ebf
	ret nz			; $5ec2
	call incCbc2		; $5ec3
	ld hl,$cbb3		; $5ec6
	ld (hl),$48		; $5ec9
	inc hl			; $5ecb
	ld (hl),$03		; $5ecc
	ld a,$04		; $5ece
	call loadPaletteHeader		; $5ed0
	ld a,$06		; $5ed3
	jp fadeinFromBlackWithDelay		; $5ed5
	ld hl,$cbb3		; $5ed8
	call decHlRef16WithCap		; $5edb
	ret nz			; $5ede
	call incCbc1		; $5edf
	inc l			; $5ee2
	ld (hl),a		; $5ee3
	ld b,$04		; $5ee4
	call checkIsLinkedGame		; $5ee6
	jr z,_label_03_130	; $5ee9
	ld b,$08		; $5eeb
_label_03_130:
	ld hl,$cbb4		; $5eed
	ld (hl),b		; $5ef0
	jp fadeoutToWhite		; $5ef1
	ld de,$cbc2		; $5ef4
	ld a,(de)		; $5ef7
	rst_jumpTable			; $5ef8
	inc bc			; $5ef9
	ld e,a			; $5efa
	or (hl)			; $5efb
	ld e,a			; $5efc
	bit 3,a			; $5efd
	ld de,$2d60		; $5eff
	ld h,b			; $5f02
	xor a			; $5f03
	ldh (<hOamTail),a	; $5f04
	ld a,($c4ab)		; $5f06
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
	ld hl,$5fa6		; $5f20
	rst_addDoubleIndex			; $5f23
	ld b,(hl)		; $5f24
	inc hl			; $5f25
	ld a,(hl)		; $5f26
	or a			; $5f27
	jr z,_label_03_132	; $5f28
	ld c,a			; $5f2a
	ld a,$00		; $5f2b
	call func_36f6		; $5f2d
	ld b,$2d		; $5f30
	ld a,($cbb4)		; $5f32
	cp $04			; $5f35
	jr nz,_label_03_131	; $5f37
	ld b,UNCMP_GFXH_0f		; $5f39
_label_03_131:
	ld a,b			; $5f3b
	call loadUncompressedGfxHeader		; $5f3c
_label_03_132:
	ld a,($cbb4)		; $5f3f
	sub $04			; $5f42
	add a			; $5f44
	add $85			; $5f45
	call loadGfxHeader		; $5f47
	ld a,$0f		; $5f4a
	call loadPaletteHeader		; $5f4c
	call reloadObjectGfx		; $5f4f
	call checkIsLinkedGame		; $5f52
	jr nz,_label_03_133	; $5f55
	ld a,($cbb4)		; $5f57
	ld b,$10		; $5f5a
	ld c,$00		; $5f5c
	cp $05			; $5f5e
	jr nz,_label_03_134	; $5f60
	ld b,$50		; $5f62
	ld c,$0e		; $5f64
	jr _label_03_134		; $5f66
_label_03_133:
	ld a,($cbb4)		; $5f68
	ld b,$10		; $5f6b
	ld c,$00		; $5f6d
	cp $0b			; $5f6f
	jr nz,_label_03_134	; $5f71
	ld b,$ae		; $5f73
	ld c,$ff		; $5f75
_label_03_134:
	ld a,b			; $5f77
	push bc			; $5f78
	call loadPaletteHeader		; $5f79
	pop bc			; $5f7c
	ld a,c			; $5f7d
	ld ($cd25),a		; $5f7e
	call loadAnimationData		; $5f81
	ld a,$01		; $5f84
	ld ($cd00),a		; $5f86
	xor a			; $5f89
	ldh (<hCameraX),a	; $5f8a
	ld b,$20		; $5f8c
	ld hl,$cfc0		; $5f8e
	call clearMemory		; $5f91
	ld hl,$cbb3		; $5f94
	ld (hl),$f0		; $5f97
	inc l			; $5f99
	ld b,(hl)		; $5f9a
	call $6405		; $5f9b
	ld a,$04		; $5f9e
	call loadGfxRegisterStateIndex		; $5fa0
	jp fadeinFromWhite		; $5fa3
	nop			; $5fa6
	add $01			; $5fa7
	dec hl			; $5fa9
	nop			; $5faa
	or (hl)			; $5fab
	nop			; $5fac
	sub $00			; $5fad
	nop			; $5faf
	ld bc,$002b		; $5fb0
	nop			; $5fb3
	nop			; $5fb4
	nop			; $5fb5
	ld a,($c4ab)		; $5fb6
	or a			; $5fb9
	ret nz			; $5fba
	ld a,($cfdf)		; $5fbb
	or a			; $5fbe
	ret z			; $5fbf
	call incCbc2		; $5fc0
	ld a,$ff		; $5fc3
	ld ($cd25),a		; $5fc5
	jp fadeoutToWhite		; $5fc8
	ld a,($c4ab)		; $5fcb
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
	ld hl,$6009		; $5ffa
	rst_addAToHl			; $5ffd
	ld a,(hl)		; $5ffe
	ld ($c487),a		; $5fff
	ld a,$10		; $6002
	ldh (<hCameraX),a	; $6004
	jp fadeinFromWhite		; $6006
	nop			; $6009
	ret nc			; $600a
	nop			; $600b
	ret nc			; $600c
	nop			; $600d
	ret nc			; $600e
	nop			; $600f
	ret nc			; $6010
	ld a,($c4ab)		; $6011
	or a			; $6014
	ret nz			; $6015
	call decCbb3		; $6016
	ret nz			; $6019
	call incCbc2		; $601a
	call getFreeInteractionSlot		; $601d
	ret nz			; $6020
	ld (hl),$ae		; $6021
	inc l			; $6023
	ld a,($cbb4)		; $6024
	sub $04			; $6027
	ldi (hl),a		; $6029
	ld (hl),$00		; $602a
	ret			; $602c
	ld a,($c4ab)		; $602d
	or a			; $6030
	ret nz			; $6031
	xor a			; $6032
	ldh (<hOamTail),a	; $6033
	ld a,($cfde)		; $6035
	or a			; $6038
	ret z			; $6039
	ld b,$07		; $603a
	call checkIsLinkedGame		; $603c
	jr z,_label_03_135	; $603f
	ld b,$0b		; $6041
_label_03_135:
	ld hl,$cbb4		; $6043
	ld a,(hl)		; $6046
	cp b			; $6047
	jr nc,_label_03_136	; $6048
	inc (hl)		; $604a
	xor a			; $604b
	ld ($cbc2),a		; $604c
	jr _label_03_137		; $604f
_label_03_136:
	call $646a		; $6051
	call enableActiveRing		; $6054
	ld a,$02		; $6057
	ld ($cbc1),a		; $6059
	ld hl,$c6a3		; $605c
	ldd a,(hl)		; $605f
	ld (hl),a		; $6060
	xor a			; $6061
	ld l,$80		; $6062
	ldi (hl),a		; $6064
	ld (hl),a		; $6065
	ld l,$c5		; $6066
	ld (hl),$ff		; $6068
_label_03_137:
	jp fadeoutToWhite		; $606a
	xor a			; $606d
	ldh (<hOamTail),a	; $606e
	ld de,$cbc2		; $6070
	ld a,(de)		; $6073
	rst_jumpTable			; $6074
	add a			; $6075
	ld h,b			; $6076
	cp l			; $6077
	ld h,b			; $6078
	call $0e60		; $6079
	ld h,c			; $607c
	ldi a,(hl)		; $607d
	ld h,c			; $607e
	ld (hl),$61		; $607f
	xor c			; $6081
	ld h,c			; $6082
	cp b			; $6083
	ld h,c			; $6084
	and $61			; $6085
	ld a,($c4ab)		; $6087
	or a			; $608a
	ret nz			; $608b
	call incCbc2		; $608c
	call disableLcd		; $608f
	call clearDynamicInteractions		; $6092
	call clearOam		; $6095
	xor a			; $6098
	ld ($cfde),a		; $6099
	ld a,$95		; $609c
	call loadGfxHeader		; $609e
	ld a,$a0		; $60a1
	call loadPaletteHeader		; $60a3
	ld a,$09		; $60a6
	call loadGfxRegisterStateIndex		; $60a8
	call fadeinFromWhite		; $60ab
	call getFreeInteractionSlot		; $60ae
	ret nz			; $60b1
	ld (hl),$af		; $60b2
	ld l,$4b		; $60b4
	ld (hl),$e8		; $60b6
	inc l			; $60b8
	inc l			; $60b9
	ld (hl),$50		; $60ba
	ret			; $60bc
	ld a,($cfde)		; $60bd
	or a			; $60c0
	ret z			; $60c1
	ld hl,$cbb3		; $60c2
	ld (hl),$e0		; $60c5
	inc hl			; $60c7
	ld (hl),$01		; $60c8
	jp incCbc2		; $60ca
	ld hl,$cbb3		; $60cd
	call decHlRef16WithCap		; $60d0
	ret nz			; $60d3
	call checkIsLinkedGame		; $60d4
	jr nz,_label_03_138	; $60d7
	call $646a		; $60d9
	ld a,$03		; $60dc
	ld ($cbc1),a		; $60de
	ld a,$04		; $60e1
	jp fadeoutToWhiteWithDelay		; $60e3
_label_03_138:
	ld a,$04		; $60e6
	ld ($cbb3),a		; $60e8
	ld a,($c486)		; $60eb
	ldh (<hCameraY),a	; $60ee
	ld a,UNCMP_GFXH_01		; $60f0
	call loadUncompressedGfxHeader		; $60f2
	ld a,$0b		; $60f5
	call loadPaletteHeader		; $60f7
	ld b,$03		; $60fa
_label_03_139:
	call getFreeInteractionSlot		; $60fc
	jr nz,_label_03_140	; $60ff
	ld (hl),$4a		; $6101
	inc l			; $6103
	ld (hl),$09		; $6104
	inc l			; $6106
	dec b			; $6107
	ld (hl),b		; $6108
	jr nz,_label_03_139	; $6109
_label_03_140:
	jp incCbc2		; $610b
	ld a,($c486)		; $610e
	or a			; $6111
	jr nz,_label_03_141	; $6112
	ld a,$78		; $6114
	ld ($cbb3),a		; $6116
	jp incCbc2		; $6119
_label_03_141:
	call decCbb3		; $611c
	ret nz			; $611f
	ld (hl),$04		; $6120
	ld hl,$c486		; $6122
	dec (hl)		; $6125
	ld a,(hl)		; $6126
	ldh (<hCameraY),a	; $6127
	ret			; $6129
	call decCbb3		; $612a
	ret nz			; $612d
	ld a,$ff		; $612e
	ld ($cbba),a		; $6130
	jp incCbc2		; $6133
	ld hl,$cbb3		; $6136
	ld b,$01		; $6139
	call flashScreen		; $613b
	ret z			; $613e
	call disableLcd		; $613f
	ld a,$9a		; $6142
	call loadGfxHeader		; $6144
	ld a,$9f		; $6147
	call loadPaletteHeader		; $6149
	call clearDynamicInteractions		; $614c
	ld b,$03		; $614f
_label_03_142:
	call getFreeInteractionSlot		; $6151
	jr nz,_label_03_143	; $6154
	ld (hl),$cf		; $6156
	inc l			; $6158
	dec b			; $6159
	ld (hl),b		; $615a
	jr nz,_label_03_142	; $615b
_label_03_143:
	ld a,$04		; $615d
	call loadGfxRegisterStateIndex		; $615f
	ld a,$04		; $6162
	call fadeinFromWhiteWithDelay		; $6164
	call incCbc2		; $6167
	ld a,$f0		; $616a
	ld ($cbb3),a		; $616c
	xor a			; $616f
	ldh (<hOamTail),a	; $6170
	ld a,($c486)		; $6172
	cp $60			; $6175
	jr nc,_label_03_144	; $6177
	cpl			; $6179
	inc a			; $617a
	ld b,a			; $617b
	ld a,(wFrameCounter)		; $617c
	and $01			; $617f
	jr nz,_label_03_144	; $6181
	ld c,a			; $6183
	ld hl,$6641		; $6184
	call addSpritesToOam_withOffset		; $6187
_label_03_144:
	ld a,($c486)		; $618a
	cpl			; $618d
	inc a			; $618e
	ld b,$c7		; $618f
	add b			; $6191
	ld b,a			; $6192
	ld c,$38		; $6193
	ld hl,$668a		; $6195
	push bc			; $6198
	call addSpritesToOam_withOffset		; $6199
	pop bc			; $619c
	ld a,($c486)		; $619d
	cp $60			; $61a0
	ret c			; $61a2
	ld hl,$66bf		; $61a3
	jp addSpritesToOam_withOffset		; $61a6
	call $616f		; $61a9
	call $6462		; $61ac
	ret nz			; $61af
	ld a,$04		; $61b0
	ld ($cbb3),a		; $61b2
	jp incCbc2		; $61b5
	ld a,($c486)		; $61b8
	cp $98			; $61bb
	jr nz,_label_03_145	; $61bd
	ld a,$f0		; $61bf
	ld ($cbb3),a		; $61c1
	call incCbc2		; $61c4
	jr _label_03_146		; $61c7
_label_03_145:
	call decCbb3		; $61c9
	jr nz,_label_03_146	; $61cc
	ld (hl),$04		; $61ce
	ld hl,$c486		; $61d0
	inc (hl)		; $61d3
	ld a,(hl)		; $61d4
	ldh (<hCameraY),a	; $61d5
	cp $60			; $61d7
	jr nz,_label_03_146	; $61d9
	call clearDynamicInteractions		; $61db
	ld a,UNCMP_GFXH_2c		; $61de
	call loadUncompressedGfxHeader		; $61e0
_label_03_146:
	jp $616f		; $61e3
	call $616f		; $61e6
	call decCbb3		; $61e9
	ret nz			; $61ec
	call $646a		; $61ed
	ld a,$03		; $61f0
	ld ($cbc1),a		; $61f2
	ld a,$04		; $61f5
	jp fadeoutToWhiteWithDelay		; $61f7
	ld de,$cbc2		; $61fa
	ld a,(de)		; $61fd
	rst_jumpTable			; $61fe
	rla			; $61ff
	ld h,d			; $6200
	ld (hl),b		; $6201
	ld h,d			; $6202
	sbc h			; $6203
	ld h,d			; $6204
	and (hl)		; $6205
	ld h,d			; $6206
	cp l			; $6207
	ld h,d			; $6208
	rla			; $6209
	ld h,e			; $620a
	ld l,$63		; $620b
	ld c,b			; $620d
	ld h,e			; $620e
	ld l,b			; $620f
	ld h,e			; $6210
	sub c			; $6211
	ld h,e			; $6212
	xor a			; $6213
	ld h,e			; $6214
	rst_jumpTable			; $6215
	ld h,e			; $6216
	call checkIsLinkedGame		; $6217
	call nz,$616f		; $621a
	ld a,($c4ab)		; $621d
	or a			; $6220
	ret nz			; $6221
	call disableLcd		; $6222
	call incCbc2		; $6225
	call $66ed		; $6228
	call clearDynamicInteractions		; $622b
	call clearOam		; $622e
	call checkIsLinkedGame		; $6231
	jp z,$6249		; $6234
	ld a,$99		; $6237
	call loadGfxHeader		; $6239
	ld a,$aa		; $623c
	call loadPaletteHeader		; $623e
	ld hl,$5887		; $6241
	call parseGivenObjectData		; $6244
	jr _label_03_147		; $6247
	ld a,$98		; $6249
	call loadGfxHeader		; $624b
	ld a,$a9		; $624e
	call loadPaletteHeader		; $6250
_label_03_147:
	ld a,$04		; $6253
	call loadGfxRegisterStateIndex		; $6255
	xor a			; $6258
	ld hl,$ffa8		; $6259
	ldi (hl),a		; $625c
	ldi (hl),a		; $625d
	ldi (hl),a		; $625e
	ld (hl),a		; $625f
	ld hl,$cbb3		; $6260
	ld (hl),$f0		; $6263
	ld (hl),a		; $6265
	ld a,$fb		; $6266
	call playSound		; $6268
	ld a,$04		; $626b
	jp fadeinFromWhiteWithDelay		; $626d
	ld a,($c4ab)		; $6270
	or a			; $6273
	ret nz			; $6274
	call incCbc2		; $6275
	call checkIsLinkedGame		; $6278
	ret z			; $627b
	ld hl,$cbb4		; $627c
	ld a,(hl)		; $627f
	or a			; $6280
	jr z,_label_03_148	; $6281
	dec (hl)		; $6283
	ret			; $6284
_label_03_148:
	ld a,$aa		; $6285
	call playSound		; $6287
	call getRandomNumber_noPreserveVars		; $628a
	and $03			; $628d
	ld hl,$6298		; $628f
	rst_addAToHl			; $6292
	ld a,(hl)		; $6293
	ld ($cbb4),a		; $6294
	ret			; $6297
	and b			; $6298
	ret z			; $6299
	stop			; $629a
	ld a,($ff00+$cd)	; $629b
	ld a,b			; $629d
	ld h,d			; $629e
	call decCbb3		; $629f
	ret nz			; $62a2
	call incCbc2		; $62a3
	call $6278		; $62a6
	ld hl,$c612		; $62a9
	ldi a,(hl)		; $62ac
	add (hl)		; $62ad
	cp $02			; $62ae
	ret z			; $62b0
	ld a,($c482)		; $62b1
	and $0b			; $62b4
	ret z			; $62b6
	call incCbc2		; $62b7
	jp fadeoutToWhite		; $62ba
	ld a,($c4ab)		; $62bd
	or a			; $62c0
	ret nz			; $62c1
	call incCbc2		; $62c2
	call disableLcd		; $62c5
	call $481b		; $62c8
	ld a,$ff		; $62cb
	ld ($cbba),a		; $62cd
	ld a,($ff00+$70)	; $62d0
	push af			; $62d2
	ld a,$07		; $62d3
	ld ($ff00+$70),a	; $62d5
	ld hl,$d460		; $62d7
	ld de,$d800		; $62da
	ld bc,$1800		; $62dd
_label_03_149:
	ldi a,(hl)		; $62e0
	call copyTextCharacterGfx		; $62e1
	dec b			; $62e4
	jr nz,_label_03_149	; $62e5
	pop af			; $62e7
	ld ($ff00+$70),a	; $62e8
	ld a,$97		; $62ea
	call loadGfxHeader		; $62ec
	ld a,UNCMP_GFXH_2b		; $62ef
	call loadUncompressedGfxHeader		; $62f1
	ld a,$05		; $62f4
	call loadPaletteHeader		; $62f6
	call checkIsLinkedGame		; $62f9
	ld a,$84		; $62fc
	call nz,loadGfxHeader		; $62fe
	call clearDynamicInteractions		; $6301
	call clearOam		; $6304
	ld a,$04		; $6307
	call loadGfxRegisterStateIndex		; $6309
	ld hl,$cbb3		; $630c
	ld (hl),$3c		; $630f
	call fileSelect_redrawDecorations		; $6311
	jp fadeinFromWhite		; $6314
	call fileSelect_redrawDecorations		; $6317
	call $6462		; $631a
	ret nz			; $631d
	ld hl,$cbb3		; $631e
	ld b,$3c		; $6321
	call checkIsLinkedGame		; $6323
	jr z,_label_03_150	; $6326
	ld b,$b4		; $6328
_label_03_150:
	ld (hl),b		; $632a
	jp incCbc2		; $632b
	call fileSelect_redrawDecorations		; $632e
	call decCbb3		; $6331
	ret nz			; $6334
	call checkIsLinkedGame		; $6335
	jr nz,_label_03_151	; $6338
	call getFreeInteractionSlot		; $633a
	jr nz,_label_03_151	; $633d
	ld (hl),$d1		; $633f
	xor a			; $6341
	ld ($cfde),a		; $6342
_label_03_151:
	jp incCbc2		; $6345
	call fileSelect_redrawDecorations		; $6348
	call checkIsLinkedGame		; $634b
	jr z,_label_03_152	; $634e
	ld a,($c482)		; $6350
	and $01			; $6353
	jr nz,_label_03_153	; $6355
	ret			; $6357
_label_03_152:
	ld a,($cfde)		; $6358
	or a			; $635b
	ret z			; $635c
_label_03_153:
	call incCbc2		; $635d
	ld a,$fa		; $6360
	call playSound		; $6362
	jp fadeoutToWhite		; $6365
	call fileSelect_redrawDecorations		; $6368
	ld a,($c4ab)		; $636b
	or a			; $636e
	ret nz			; $636f
	call checkIsLinkedGame		; $6370
	jp nz,resetGame		; $6373
	call disableLcd		; $6376
	call clearOam		; $6379
	call incCbc2		; $637c
	ld a,$82		; $637f
	call loadGfxHeader		; $6381
	ld a,$8f		; $6384
	call loadPaletteHeader		; $6386
	call fadeinFromWhite		; $6389
	ld a,$04		; $638c
	jp loadGfxRegisterStateIndex		; $638e
	call $63a1		; $6391
	ld a,($c4ab)		; $6394
	or a			; $6397
	ret nz			; $6398
	ld hl,$cbb3		; $6399
	ld (hl),$b4		; $639c
	jp incCbc2		; $639e
	ld hl,$4e0c		; $63a1
	ld e,$15		; $63a4
	ld bc,$3038		; $63a6
	xor a			; $63a9
	ldh (<hOamTail),a	; $63aa
	jp addSpritesFromBankToOam_withOffset		; $63ac
	call $63a1		; $63af
	ld hl,$cbb3		; $63b2
	ld a,(hl)		; $63b5
	or a			; $63b6
	jr z,_label_03_154	; $63b7
	dec (hl)		; $63b9
	ret			; $63ba
_label_03_154:
	ld a,($c482)		; $63bb
	and $01			; $63be
	ret z			; $63c0
	call incCbc2		; $63c1
	jp fadeoutToWhite		; $63c4
	call $63a1		; $63c7
	ld a,($c4ab)		; $63ca
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
	call initializeVramMaps		; $63eb
	call loadScreenMusicAndSetRoomPack		; $63ee
	call loadTilesetData		; $63f1
	call loadTilesetGraphics		; $63f4
	call func_131f		; $63f7
	ld a,$01		; $63fa
	ld (wScrollMode),a		; $63fc
	call loadCommonGraphics		; $63ff
	jp clearOam		; $6402

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
	jr z,_label_03_155	; $641f
	cp $06			; $6421
	jr z,_label_03_158	; $6423
	cp $07			; $6425
	jr z,_label_03_159	; $6427
	ret			; $6429
_label_03_155:
	ld a,$04		; $642a
	ld b,$03		; $642c
_label_03_156:
	call $6434		; $642e
	jp reloadObjectGfx		; $6431
	ld hl,$cc07		; $6434
_label_03_157:
	ldi (hl),a		; $6437
	inc a			; $6438
	ld (hl),$01		; $6439
	inc l			; $643b
	dec b			; $643c
	jr nz,_label_03_157	; $643d
	ret			; $643f
_label_03_158:
	ld a,$0f		; $6440
	ld b,$06		; $6442
	jr _label_03_156		; $6444
_label_03_159:
	ld a,$13		; $6446
	ld b,$02		; $6448
	jr _label_03_156		; $644a
	ld ($cc4e),a		; $644c
	call disableLcd		; $644f
	call $63eb		; $6452
	ld a,$02		; $6455
	jp loadGfxRegisterStateIndex		; $6457
	ld a,($cba0)		; $645a
	or a			; $645d
	ret nz			; $645e
	jp decCbb3		; $645f
	ld a,($c4ab)		; $6462
	or a			; $6465
	ret nz			; $6466
	jp decCbb3		; $6467
	ld hl,$cbb3		; $646a
	ld b,$10		; $646d
	jp clearMemory		; $646f
	ld h,$e0		; $6472
	stop			; $6474
	ld (bc),a		; $6475
	ld bc,$18e0		; $6476
	inc b			; $6479
	ld bc,$20e0		; $647a
	ld b,$01		; $647d
	ld ($ff00+$28),a	; $647f
	ld ($f001),sp		; $6481
	ld ($0114),sp		; $6484
	ld a,($ff00+$10)	; $6487
	ld d,$01		; $6489
	ld a,($ff00+$18)	; $648b
	jr $01			; $648d
	ld a,($ff00+$20)	; $648f
	ld a,(de)		; $6491
	ld bc,$28f0		; $6492
	inc e			; $6495
	ld bc,$0800		; $6496
	jr z,_label_03_160	; $6499
	nop			; $649b
_label_03_160:
	stop			; $649c
	ldi a,(hl)		; $649d
	ld bc,$1800		; $649e
	inc l			; $64a1
	ld bc,$2000		; $64a2
	ld l,$01		; $64a5
	nop			; $64a7
	jr z,$30		; $64a8
	ld bc,$0810		; $64aa
	ldd a,(hl)		; $64ad
	ld bc,$1010		; $64ae
	inc a			; $64b1
	ld bc,$1810		; $64b2
	ld a,$01		; $64b5
	stop			; $64b7
	jr nz,_label_03_162	; $64b8
	ld bc,$2810		; $64ba
	ld b,d			; $64bd
	ld bc,$0820		; $64be
	nop			; $64c1
	ld bc,$1020		; $64c2
	ld a,(bc)		; $64c5
	ld bc,$1820		; $64c6
	inc c			; $64c9
	ld bc,$2020		; $64ca
	ld c,$01		; $64cd
	jr nz,_label_03_161	; $64cf
	stop			; $64d1
	ld bc,$0830		; $64d2
	ld e,$01		; $64d5
	jr nc,$10		; $64d7
	jr nz,$01		; $64d9
	jr nc,$18		; $64db
	ldi (hl),a		; $64dd
	ld bc,$2030		; $64de
	inc h			; $64e1
	ld bc,$2830		; $64e2
	ld h,$01		; $64e5
	ld b,b			; $64e7
	ld ($0132),sp		; $64e8
	ld b,b			; $64eb
	stop			; $64ec
	inc (hl)		; $64ed
	ld bc,$1840		; $64ee
	ld (hl),$01		; $64f1
	ld d,b			; $64f3
	ld ($0144),sp		; $64f4
	ld d,b			; $64f7
	stop			; $64f8
_label_03_161:
	ld b,(hl)		; $64f9
_label_03_162:
	ld bc,$1850		; $64fa
	ld c,b			; $64fd
	ld bc,$2040		; $64fe
	jr c,_label_03_163	; $6501
	ld h,b			; $6503
_label_03_163:
	ld ($0100),sp		; $6504
	ld h,b			; $6507
	stop			; $6508
	ld (de),a		; $6509
	ld bc,$e026		; $650a
	ld hl,sp+$02		; $650d
	ld hl,$f0e0		; $650f
	inc b			; $6512
	ld hl,$e8e0		; $6513
	ld b,$21		; $6516
	ld ($ff00+$e0),a	; $6518
	ld ($f021),sp		; $651a
	nop			; $651d
	inc d			; $651e
	ld hl,$f8f0		; $651f
	ld d,$21		; $6522
	ld a,($ff00+$f0)	; $6524
	jr $21			; $6526
	ld a,($ff00+$e8)	; $6528
	ld a,(de)		; $652a
	ld hl,$e0f0		; $652b
	inc e			; $652e
	ld hl,$0000		; $652f
	jr z,$21		; $6532
	nop			; $6534
	ld hl,sp+$2a		; $6535
	ld hl,$f000		; $6537
	inc l			; $653a
	ld hl,$e800		; $653b
	ld l,$21		; $653e
	nop			; $6540
	ld ($ff00+$30),a	; $6541
	ld hl,$0010		; $6543
	ldd a,(hl)		; $6546
	ld hl,$f810		; $6547
_label_03_164:
	inc a			; $654a
	ld hl,$f010		; $654b
	ld a,$21		; $654e
	stop			; $6550
	add sp,$40		; $6551
	ld hl,$e010		; $6553
	ld b,d			; $6556
	ld hl,$0020		; $6557
	nop			; $655a
	ld hl,$f820		; $655b
	ld a,(bc)		; $655e
	ld hl,$f020		; $655f
	inc c			; $6562
	ld hl,$e820		; $6563
_label_03_165:
	ld c,$21		; $6566
	jr nz,_label_03_164	; $6568
_label_03_166:
	stop			; $656a
	ld hl,$0030		; $656b
	ld e,$21		; $656e
	jr nc,_label_03_166	; $6570
	jr nz,$21		; $6572
	jr nc,_label_03_165	; $6574
	ldi (hl),a		; $6576
	ld hl,$e830		; $6577
	inc h			; $657a
	ld hl,$e030		; $657b
	ld h,$21		; $657e
	ld b,b			; $6580
	nop			; $6581
	ldd (hl),a		; $6582
	ld hl,$f840		; $6583
	inc (hl)		; $6586
	ld hl,$f040		; $6587
	ld (hl),$21		; $658a
	ld d,b			; $658c
	nop			; $658d
	ld b,h			; $658e
	ld hl,$f850		; $658f
	ld b,(hl)		; $6592
	ld hl,$f050		; $6593
	ld c,b			; $6596
	ld hl,$e840		; $6597
	jr c,$21		; $659a
	ld h,b			; $659c
	nop			; $659d
	nop			; $659e
	ld hl,$f860		; $659f
	ld (de),a		; $65a2
	ld hl,$e027		; $65a3
	add sp,$00		; $65a6
	ld bc,$f0e0		; $65a8
	ld (bc),a		; $65ab
	ld bc,$f8e0		; $65ac
	inc b			; $65af
	ld bc,$e0f0		; $65b0
	stop			; $65b3
	ld bc,$e8f0		; $65b4
	ld (de),a		; $65b7
	ld bc,$f0f0		; $65b8
	inc d			; $65bb
	ld bc,$e000		; $65bc
	ld l,$01		; $65bf
	nop			; $65c1
	add sp,$30		; $65c2
	ld bc,$e820		; $65c4
	ldd (hl),a		; $65c7
	ld bc,$f020		; $65c8
	inc (hl)		; $65cb
	ld bc,$f820		; $65cc
	ld (hl),$01		; $65cf
	nop			; $65d1
	jr _label_03_167		; $65d2
	ld (bc),a		; $65d4
	nop			; $65d5
	jr nz,_label_03_168	; $65d6
	ld (bc),a		; $65d8
	stop			; $65d9
	jr $3c			; $65da
	ld (bc),a		; $65dc
	stop			; $65dd
	jr nz,_label_03_170	; $65de
	ld (bc),a		; $65e0
	ld h,b			; $65e1
	ld a,($0140)		; $65e2
	ld h,b			; $65e5
	ld (bc),a		; $65e6
	ld b,d			; $65e7
	ld bc,$1960		; $65e8
	ld b,h			; $65eb
	ld bc,$2160		; $65ec
	ld b,(hl)		; $65ef
	inc bc			; $65f0
	ld d,b			; $65f1
	jr _label_03_175		; $65f2
	ld bc,$2050		; $65f4
	ld c,d			; $65f7
	inc bc			; $65f8
	ld b,b			; $65f9
	jr _label_03_177		; $65fa
	inc bc			; $65fc
	ld c,b			; $65fd
	stop			; $65fe
	inc l			; $65ff
	ld bc,$2960		; $6600
	ld d,$04		; $6603
	ld b,b			; $6605
	jr nz,_label_03_171	; $6606
	inc b			; $6608
	ld b,b			; $6609
	jr z,_label_03_172	; $660a
_label_03_167:
	inc b			; $660c
	ld d,b			; $660d
	jr z,_label_03_173	; $660e
	inc b			; $6610
	ld d,b			; $6611
_label_03_168:
	ld e,b			; $6612
	ld e,$04		; $6613
	ld d,b			; $6615
	ld h,b			; $6616
	jr nz,_label_03_169	; $6617
	ld d,b			; $6619
	ld l,b			; $661a
	ldi (hl),a		; $661b
	inc b			; $661c
_label_03_169:
	ld b,b			; $661d
_label_03_170:
	ld h,b			; $661e
	inc h			; $661f
_label_03_171:
	inc b			; $6620
	ld h,b			; $6621
	ld e,b			; $6622
	ld h,$04		; $6623
	ld h,b			; $6625
_label_03_172:
	ld h,b			; $6626
	jr z,_label_03_174	; $6627
	ld h,b			; $6629
	ld l,b			; $662a
	ldi a,(hl)		; $662b
_label_03_173:
	inc b			; $662c
_label_03_174:
	jr $38			; $662d
	ld b,$05		; $662f
	jr _label_03_181		; $6631
	ld ($0805),sp		; $6633
	jr nc,_label_03_176	; $6636
	ld b,$00		; $6638
	jr c,_label_03_177	; $663a
_label_03_175:
	ld b,$00		; $663c
	ld b,b			; $663e
	ld c,$06		; $663f
	ld (de),a		; $6641
_label_03_176:
	stop			; $6642
	ld ($0c00),sp		; $6643
	stop			; $6646
	stop			; $6647
_label_03_177:
	ld (bc),a		; $6648
	inc c			; $6649
	stop			; $664a
	jr _label_03_178		; $664b
	inc c			; $664d
	jr nz,_label_03_179	; $664e
	inc c			; $6650
_label_03_178:
	inc c			; $6651
	jr nz,$10		; $6652
	ld c,$0c		; $6654
	jr nz,_label_03_180	; $6656
_label_03_179:
	stop			; $6658
	inc c			; $6659
	ld sp,$0623		; $665a
	dec c			; $665d
	ld sp,$082b		; $665e
	dec c			; $6661
	ld sp,$063b		; $6662
	dec l			; $6665
	ld sp,$0833		; $6666
	dec l			; $6669
	ld b,c			; $666a
	inc hl			; $666b
	ld b,$4d		; $666c
	ld b,c			; $666e
	dec hl			; $666f
_label_03_180:
	ld ($414d),sp		; $6670
	dec sp			; $6673
	ld b,$6d		; $6674
	ld b,c			; $6676
	inc sp			; $6677
	ld ($2c6d),sp		; $6678
_label_03_181:
	dec e			; $667b
	ld a,(bc)		; $667c
	dec c			; $667d
	inc l			; $667e
	dec h			; $667f
	ld a,(bc)		; $6680
	dec l			; $6681
	ld c,h			; $6682
	ldd a,(hl)		; $6683
	ld a,(bc)		; $6684
	dec c			; $6685
	ld c,h			; $6686
	ld b,d			; $6687
	ld a,(bc)		; $6688
	dec l			; $6689
	dec c			; $668a
	jr c,-$2d		; $668b
	ld (bc),a		; $668d
	inc bc			; $668e
	ldd (hl),a		; $668f
	ld hl,sp+$0c		; $6690
	ld bc,$d8f8		; $6692
	stop			; $6695
	rlca			; $6696
	ld hl,sp-$20		; $6697
	ld (de),a		; $6699
	rlca			; $669a
	ld hl,sp-$18		; $669b
	inc d			; $669d
	rlca			; $669e
	rst $30			; $669f
	rst $30			; $66a0
	ld d,$07		; $66a1
	ldi (hl),a		; $66a3
	ld hl,sp+$1a		; $66a4
	inc bc			; $66a6
	ld a,(de)		; $66a7
	nop			; $66a8
	inc e			; $66a9
	inc bc			; $66aa
	ld de,$1ee2		; $66ab
	nop			; $66ae
	ld de,$20ea		; $66af
	nop			; $66b2
	ld bc,$22ea		; $66b3
	nop			; $66b6
	ld de,$26f2		; $66b7
	nop			; $66ba
	ld bc,$24f2		; $66bb
	nop			; $66be
	rlca			; $66bf
	ld h,b			; $66c0
	ld hl,sp+$00		; $66c1
	ld (bc),a		; $66c3
	ld c,b			; $66c4
.DB $d3				; $66c5
	inc b			; $66c6
	inc bc			; $66c7
	ld b,b			; $66c8
	ld ($ff00+$06),a	; $66c9
	rlca			; $66cb
	ld b,b			; $66cc
	add sp,$08		; $66cd
	rlca			; $66cf
	ld b,b			; $66d0
	ld a,($ff00+$0a)	; $66d1
	rlca			; $66d3
	ld b,d			; $66d4
	ld hl,sp+$0e		; $66d5
	ld bc,$e068		; $66d7
	jr $02			; $66da
	ld hl,$c6a2		; $66dc
	ld (hl),$04		; $66df
	ld l,$80		; $66e1
	ldi a,(hl)		; $66e3
	ld b,(hl)		; $66e4
	ld hl,$cc3b		; $66e5
	ldi (hl),a		; $66e8
	ld (hl),b		; $66e9
	jp disableActiveRing		; $66ea
	ld hl,$c6a3		; $66ed
	ldd a,(hl)		; $66f0
	ld (hl),a		; $66f1
	ld hl,$cc3b		; $66f2
	ldi a,(hl)		; $66f5
	ld b,(hl)		; $66f6
	ld hl,$c680		; $66f7
	ldi (hl),a		; $66fa
	ld (hl),b		; $66fb
	jp enableActiveRing		; $66fc
	ld a,($cc03)		; $66ff
	rst_jumpTable			; $6702
	rrca			; $6703
	ld h,a			; $6704
	ldd (hl),a		; $6705
	ld h,a			; $6706
	add d			; $6707
	ld l,b			; $6708
	call nc,$e368		; $6709
	ld l,c			; $670c
	ld ($066a),sp		; $670d
	stop			; $6710
	ld hl,$cbb3		; $6711
	call clearMemory		; $6714
	call clearWramBank1		; $6717
	xor a			; $671a
	ld ($cca4),a		; $671b
	ld ($cd00),a		; $671e
	ld a,($c48c)		; $6721
	ld ($cbba),a		; $6724
	ld a,$80		; $6727
	ld ($cc02),a		; $6729
	ld a,$01		; $672c
	ld ($cc03),a		; $672e
	ret			; $6731
	call $6b6c		; $6732
	ld a,(wFrameCounter)		; $6735
	and $07			; $6738
	ret nz			; $673a
	ld a,($cbb3)		; $673b
	rst_jumpTable			; $673e
	ld c,e			; $673f
	ld h,a			; $6740
	adc l			; $6741
	ld h,a			; $6742
	sbc (hl)		; $6743
	ld h,a			; $6744
	xor a			; $6745
	ld h,a			; $6746
	jp nz,$d267		; $6747
	ld h,a			; $674a
	call $6815		; $674b
	ld a,$08		; $674e
	ld ($cbb8),a		; $6750
	ld a,$04		; $6753
	ld ($cbb4),a		; $6755
	ld a,$51		; $6758
	call loadGfxHeader		; $675a
	ld a,$54		; $675d
	call loadGfxHeader		; $675f
	ld a,$04		; $6762
	ldh (<hNextLcdInterruptBehaviour),a	; $6764
	call $681a		; $6766
	jp $67f8		; $6769
	ld hl,$677e		; $676c
	ld d,$0f		; $676f
_label_03_182:
	ldi a,(hl)		; $6771
	ld c,a			; $6772
	ld a,$0f		; $6773
	push hl			; $6775
	call setTile		; $6776
	pop hl			; $6779
	dec d			; $677a
	jr nz,_label_03_182	; $677b
	ret			; $677d
	inc b			; $677e
	dec b			; $677f
	ld b,$07		; $6780
	ld ($1514),sp		; $6782
	ld d,$17		; $6785
	jr $24			; $6787
	dec h			; $6789
	ld h,$27		; $678a
	jr z,_label_03_183	; $678c
	or h			; $678e
	swap l			; $678f
	ret nz			; $6791
	ld bc,$4e00		; $6792
	call showText		; $6795
	call $676c		; $6798
	jp $6815		; $679b
	call retIfTextIsActive		; $679e
	ld hl,$7dd9		; $67a1
	call parseGivenObjectData		; $67a4
	ld a,$20		; $67a7
	call playSound		; $67a9
	jp $6815		; $67ac
_label_03_183:
	call $6b77		; $67af
	ld a,(hl)		; $67b2
	cp $10			; $67b3
	jr c,_label_03_184	; $67b5
	call $681a		; $67b7
	jr nz,_label_03_184	; $67ba
	call $6815		; $67bc
_label_03_184:
	jp $67f8		; $67bf
	call $6b77		; $67c2
	ld a,(hl)		; $67c5
	cp $30			; $67c6
	jr c,_label_03_185	; $67c8
	call fadeoutToWhite		; $67ca
	call $6815		; $67cd
	jr _label_03_185		; $67d0
	call $6b77		; $67d2
	ld a,($c4ab)		; $67d5
	or a			; $67d8
	jr nz,_label_03_185	; $67d9
	ld a,$c7		; $67db
	ld ($c488),a		; $67dd
	ld ($c48e),a		; $67e0
	ld a,$03		; $67e3
	ldh (<hNextLcdInterruptBehaviour),a	; $67e5
	ld a,$02		; $67e7
	ld ($cc03),a		; $67e9
	xor a			; $67ec
	ld ($cfc0),a		; $67ed
	ld b,$10		; $67f0
	ld hl,$cbb3		; $67f2
	jp clearMemory		; $67f5
_label_03_185:
	ld a,$40		; $67f8
	ld ($c490),a		; $67fa
	ld a,$47		; $67fd
	ld ($c48f),a		; $67ff
	ld a,$a5		; $6802
	ld ($c489),a		; $6804
	ld a,($cbb8)		; $6807
	ld ($c48e),a		; $680a
	ld ($c488),a		; $680d
	ld ($cbbc),a		; $6810
	jr _label_03_187		; $6813
	ld hl,$cbb3		; $6815
	inc (hl)		; $6818
	ret			; $6819
	ld a,($cbb7)		; $681a
	ld hl,$6844		; $681d
	rst_addAToHl			; $6820
	ld a,(hl)		; $6821
	cp $ff			; $6822
	ret z			; $6824
	ld l,a			; $6825
	ld h,$d0		; $6826
	push hl			; $6828
	ld de,$9c00		; $6829
	ld bc,$0f02		; $682c
	call queueDmaTransfer		; $682f
	pop hl			; $6832
	set 2,h			; $6833
	ld e,$01		; $6835
	call queueDmaTransfer		; $6837
	ld a,$08		; $683a
	ld ($cbb8),a		; $683c
	ld hl,$cbb7		; $683f
	inc (hl)		; $6842
	ret			; $6843
	ret nz			; $6844
	and b			; $6845
	add b			; $6846
	ld h,b			; $6847
	ld b,b			; $6848
	jr nz,_label_03_186	; $6849
_label_03_186:
	rst $38			; $684b
_label_03_187:
	ld a,$02		; $684c
	ld ($ff00+$70),a	; $684e
	ld a,($cbb8)		; $6850
	and $07			; $6853
	ld hl,$d800		; $6855
	rst_addDoubleIndex			; $6858
	ld de,$d9e0		; $6859
	ld b,$10		; $685c
	call copyMemory		; $685e
	ld a,($cbb8)		; $6861
	and $07			; $6864
	ld hl,$d820		; $6866
	rst_addDoubleIndex			; $6869
	ld de,$d9f0		; $686a
	ld b,$10		; $686d
	call copyMemory		; $686f
	ld a,$00		; $6872
	ld ($ff00+$70),a	; $6874
	ld hl,$d9e0		; $6876
	ld de,$94e1		; $6879
	ld bc,$0102		; $687c
	jp queueDmaTransfer		; $687f
	ld a,($cbb3)		; $6882
	rst_jumpTable			; $6885
	cp l			; $6886
	ld l,b			; $6887
	bit 5,b			; $6888
	call z,$cd68		; $688a
	pop bc			; $688d
	ld (bc),a		; $688e
	call clearScreenVariablesAndWramBank1		; $688f
	call $6815		; $6892
	ld bc,$05d4		; $6895
	call $691f		; $6898
	ld hl,$d000		; $689b
	ld (hl),$03		; $689e
	ld l,$0b		; $68a0
	ld (hl),$58		; $68a2
	ld l,$0d		; $68a4
	ld (hl),$70		; $68a6
	ld l,$08		; $68a8
	ld (hl),$02		; $68aa
	xor a			; $68ac
	ld ($cc6a),a		; $68ad
	ld a,$01		; $68b0
	ld ($ccae),a		; $68b2
	call resetCamera		; $68b5
	ld a,$02		; $68b8
	jp $6933		; $68ba
	ld a,($c4ab)		; $68bd
	or a			; $68c0
	ret nz			; $68c1
	call $688c		; $68c2
	ld hl,$7e14		; $68c5
	jp parseGivenObjectData		; $68c8
	ret			; $68cb
	ld a,$03		; $68cc
	call $67e9		; $68ce
	jp fadeoutToWhite		; $68d1
	ld a,($cbb3)		; $68d4
	rst_jumpTable			; $68d7
	ld ($ff00+c),a		; $68d8
	ld l,b			; $68d9
	ld (hl),h		; $68da
	ld l,c			; $68db
	add a			; $68dc
	ld l,c			; $68dd
	sub d			; $68de
	ld l,c			; $68df
	xor l			; $68e0
	ld l,c			; $68e1
	ld a,($c4ab)		; $68e2
	or a			; $68e5
	ret nz			; $68e6
	call disableLcd		; $68e7
	call clearScreenVariablesAndWramBank1		; $68ea
	call $6815		; $68ed
	ld a,$40		; $68f0
	ld ($cbb8),a		; $68f2
	ld ($cbbf),a		; $68f5
	ld a,$1e		; $68f8
	ld ($cbb4),a		; $68fa
	ld a,$01		; $68fd
	ld ($cc4e),a		; $68ff
	ld bc,$00fe		; $6902
	call $691f		; $6905
	call $6943		; $6908
	ld e,$0c		; $690b
	call loadObjectGfxHeaderToSlot4		; $690d
	ld a,$52		; $6910
	call loadGfxHeader		; $6912
	ld hl,$7df0		; $6915
	call parseGivenObjectData		; $6918
	ld a,$11		; $691b
	jr _label_03_189		; $691d
_label_03_188:
	ld a,b			; $691f
	ld ($cc49),a		; $6920
	ld a,c			; $6923
	ld ($cc4c),a		; $6924
	call loadScreenMusicAndSetRoomPack		; $6927
	call loadTilesetData		; $692a
	call loadTilesetGraphics		; $692d
	jp func_131f		; $6930
_label_03_189:
	push af			; $6933
	ld a,$01		; $6934
	ld ($cd00),a		; $6936
	call fadeinFromWhite		; $6939
	call loadCommonGraphics		; $693c
	pop af			; $693f
	jp loadGfxRegisterStateIndex		; $6940
	ld hl,$6953		; $6943
_label_03_190:
	ldi a,(hl)		; $6946
	cp $ff			; $6947
	ret z			; $6949
	ld c,a			; $694a
	ldi a,(hl)		; $694b
	push hl			; $694c
	call setTile		; $694d
	pop hl			; $6950
	jr _label_03_190		; $6951
	dec b			; $6953
	xor l			; $6954
	ld b,$ad		; $6955
	ld ($09ae),sp		; $6957
	xor (hl)		; $695a
	dec d			; $695b
	xor l			; $695c
	ld d,$ad		; $695d
	jr -$52			; $695f
	add hl,de		; $6961
	xor (hl)		; $6962
	dec h			; $6963
	xor l			; $6964
	ld h,$ad		; $6965
	jr z,-$52		; $6967
	add hl,hl		; $6969
	xor (hl)		; $696a
	dec (hl)		; $696b
	xor l			; $696c
	ld (hl),$ad		; $696d
	jr c,_label_03_188	; $696f
	add hl,sp		; $6971
	xor (hl)		; $6972
	rst $38			; $6973
	ld hl,$cbb4		; $6974
	dec (hl)		; $6977
	ret nz			; $6978
	call $6815		; $6979
	xor a			; $697c
	ldh (<hCameraY),a	; $697d
	ldh (<hCameraX),a	; $697f
	ld bc,$4e09		; $6981
	jp showText		; $6984
	call retIfTextIsActive		; $6987
	ld a,$ff		; $698a
	ld ($cfc0),a		; $698c
	jp $6815		; $698f
	ld a,(wFrameCounter)		; $6992
	and $07			; $6995
	ret nz			; $6997
	call $6b77		; $6998
	ld a,(hl)		; $699b
	cp $70			; $699c
	jr c,_label_03_191	; $699e
	call fadeoutToWhite		; $69a0
	ld a,$fb		; $69a3
	call playSound		; $69a5
	call $6815		; $69a8
	jr _label_03_191		; $69ab
	ld a,(wFrameCounter)		; $69ad
	and $07			; $69b0
	ret nz			; $69b2
	call $6b77		; $69b3
	ld a,($c4ab)		; $69b6
	or a			; $69b9
	jr nz,_label_03_191	; $69ba
	ld a,$c7		; $69bc
	ld ($c488),a		; $69be
	ld ($c48e),a		; $69c1
	ld a,$04		; $69c4
	ld ($cc03),a		; $69c6
	ld b,$10		; $69c9
	ld hl,$cbb3		; $69cb
	jp clearMemory		; $69ce
_label_03_191:
	ld a,$a5		; $69d1
	ld ($c489),a		; $69d3
	ld a,($cbb8)		; $69d6
	ld ($c48e),a		; $69d9
	ld ($c488),a		; $69dc
	ld ($cbbc),a		; $69df
	ret			; $69e2
	ld a,($cbb3)		; $69e3
	rst_jumpTable			; $69e6
.DB $ed				; $69e7
	ld l,c			; $69e8
	rst $38			; $69e9
	ld l,c			; $69ea
	nop			; $69eb
	ld l,d			; $69ec
	ld a,($c4ab)		; $69ed
	or a			; $69f0
	ret nz			; $69f1
	call $688c		; $69f2
	xor a			; $69f5
	ld ($cfc0),a		; $69f6
	ld hl,$7e2e		; $69f9
	jp parseGivenObjectData		; $69fc
	ret			; $69ff
	ld a,$05		; $6a00
	call $67e9		; $6a02
	jp fadeoutToWhite		; $6a05
	call $6b6c		; $6a08
	ld a,($cbb3)		; $6a0b
	rst_jumpTable			; $6a0e
	dec d			; $6a0f
	ld l,d			; $6a10
	ld e,d			; $6a11
	ld l,d			; $6a12
	ld (hl),l		; $6a13
	ld l,d			; $6a14
	ld a,($c4ab)		; $6a15
	or a			; $6a18
	ret nz			; $6a19
	call disableLcd		; $6a1a
	call clearScreenVariablesAndWramBank1		; $6a1d
	call $6815		; $6a20
	ld a,$90		; $6a23
	ld ($cbb8),a		; $6a25
	ld ($cbbf),a		; $6a28
	ld a,$10		; $6a2b
	ld ($cbbd),a		; $6a2d
	ld a,$03		; $6a30
	ld ($cc4e),a		; $6a32
	ld bc,$00f2		; $6a35
	call $691f		; $6a38
	ld a,$ff		; $6a3b
	ld ($cd25),a		; $6a3d
	ld e,$00		; $6a40
	call loadObjectGfxHeaderToSlot4		; $6a42
	ld a,$53		; $6a45
	call loadGfxHeader		; $6a47
	ld a,$54		; $6a4a
	call loadGfxHeader		; $6a4c
	ld hl,$7dfa		; $6a4f
	call parseGivenObjectData		; $6a52
	ld a,$12		; $6a55
	jp $6933		; $6a57
	ld a,(wFrameCounter)		; $6a5a
	and $03			; $6a5d
	jr nz,_label_03_192	; $6a5f
	call $6b80		; $6a61
	ld a,(hl)		; $6a64
	cp $09			; $6a65
	jp nc,$6a70		; $6a67
	call $6b30		; $6a6a
	call $6815		; $6a6d
_label_03_192:
	call $69d1		; $6a70
	jr _label_03_194		; $6a73
	ld a,(wFrameCounter)		; $6a75
	and $07			; $6a78
	jr nz,_label_03_192	; $6a7a
	call $6b80		; $6a7c
	ld a,(hl)		; $6a7f
	cp $09			; $6a80
	jr nc,_label_03_192	; $6a82
	call $6b30		; $6a84
	jr nz,_label_03_192	; $6a87
	ld a,$17		; $6a89
	call setGlobalFlag		; $6a8b
	xor a			; $6a8e
	ld (wActiveMusic),a		; $6a8f
	ld hl,$6a98		; $6a92
	jp setWarpDestVariables		; $6a95
	add b			; $6a98
	ld ($ff00+c),a		; $6a99
	rrca			; $6a9a
	ld h,(hl)		; $6a9b
	inc bc			; $6a9c
_label_03_193:
	ld a,$02		; $6a9d
	ld ($ff00+$70),a	; $6a9f
	ld a,($cbbe)		; $6aa1
	dec a			; $6aa4
	and $03			; $6aa5
	ld hl,$6b1a		; $6aa7
	rst_addDoubleIndex			; $6aaa
	ldi a,(hl)		; $6aab
	ld h,(hl)		; $6aac
	ld l,a			; $6aad
	ld a,($cbb8)		; $6aae
	and $07			; $6ab1
	rst_addDoubleIndex			; $6ab3
	ld de,$d9e0		; $6ab4
	call $6b22		; $6ab7
	ld a,$00		; $6aba
	ld ($ff00+$70),a	; $6abc
	ld hl,$d9e0		; $6abe
	ld de,$8ce0		; $6ac1
	ld bc,$0102		; $6ac4
	jp queueDmaTransfer		; $6ac7
_label_03_194:
	ld hl,$cbbd		; $6aca
	dec (hl)		; $6acd
	jr nz,_label_03_193	; $6ace
	ld (hl),$10		; $6ad0
	ld a,$02		; $6ad2
	ld ($ff00+$70),a	; $6ad4
	ld a,($cbbe)		; $6ad6
	ld hl,$6b1a		; $6ad9
	rst_addDoubleIndex			; $6adc
	ldi a,(hl)		; $6add
	ld h,(hl)		; $6ade
	ld l,a			; $6adf
	ld de,$d9c0		; $6ae0
	push hl			; $6ae3
	call $6b22		; $6ae4
	pop hl			; $6ae7
	ld a,($cbb8)		; $6ae8
	and $07			; $6aeb
	rst_addDoubleIndex			; $6aed
	ld de,$d9e0		; $6aee
	call $6b22		; $6af1
	ld a,$00		; $6af4
	ld ($ff00+$70),a	; $6af6
	ld hl,$d9c0		; $6af8
	ld de,$88e1		; $6afb
	ld bc,$0102		; $6afe
	call queueDmaTransfer		; $6b01
	ld hl,$d9e0		; $6b04
	ld de,$8ce0		; $6b07
	ld bc,$0102		; $6b0a
	call queueDmaTransfer		; $6b0d
	ld a,($cbbe)		; $6b10
	inc a			; $6b13
	and $03			; $6b14
	ld ($cbbe),a		; $6b16
	ret			; $6b19
	ld b,b			; $6b1a
	ret c			; $6b1b
	add b			; $6b1c
	ret c			; $6b1d
	ret nz			; $6b1e
	ret c			; $6b1f
	nop			; $6b20
	reti			; $6b21
	ld b,$10		; $6b22
	call copyMemory		; $6b24
	ld bc,$0010		; $6b27
	add hl,bc		; $6b2a
_label_03_195:
	ld b,$10		; $6b2b
	jp copyMemory		; $6b2d
	ld a,($cbb7)		; $6b30
	ld hl,$6b59		; $6b33
	rst_addDoubleIndex			; $6b36
	ldi a,(hl)		; $6b37
	cp $ff			; $6b38
	ret z			; $6b3a
	ld h,(hl)		; $6b3b
_label_03_196:
	ld l,a			; $6b3c
	push hl			; $6b3d
	ld de,$9c00		; $6b3e
	ld bc,$2102		; $6b41
	call queueDmaTransfer		; $6b44
	pop hl			; $6b47
	set 2,h			; $6b48
	ld e,$01		; $6b4a
	call queueDmaTransfer		; $6b4c
	ld a,$10		; $6b4f
	ld ($cbb8),a		; $6b51
	ld hl,$cbb7		; $6b54
	inc (hl)		; $6b57
	ret			; $6b58
	jr nz,_label_03_195	; $6b59
	ld b,b			; $6b5b
	ret nc			; $6b5c
	ld h,b			; $6b5d
	ret nc			; $6b5e
	add b			; $6b5f
	ret nc			; $6b60
	and b			; $6b61
	ret nc			; $6b62
	ret nz			; $6b63
	ret nc			; $6b64
	ld ($ff00+$d0),a	; $6b65
	nop			; $6b67
	pop de			; $6b68
	jr nz,_label_03_196	; $6b69
	rst $38			; $6b6b
	ld hl,$6b72		; $6b6c
	jp addSpritesToOam		; $6b6f
	ld bc,$a610		; $6b72
	ld c,h			; $6b75
	add hl,bc		; $6b76
	ld hl,$cbbf		; $6b77
	inc (hl)		; $6b7a
	ld hl,$cbb8		; $6b7b
	inc (hl)		; $6b7e
	ret			; $6b7f
	ld hl,$cbbf		; $6b80
	dec (hl)		; $6b83
	ld hl,$cbb8		; $6b84
	dec (hl)		; $6b87
	ret			; $6b88
	ld a,($cc03)		; $6b89
	rst_jumpTable			; $6b8c
	sbc c			; $6b8d
	ld l,e			; $6b8e
	jp c,$696b		; $6b8f
	ld l,h			; $6b92
	adc c			; $6b93
	ld l,h			; $6b94
	stop			; $6b95
	ld l,l			; $6b96
	ld b,e			; $6b97
	ld l,l			; $6b98
	ld a,($c4ab)		; $6b99
	or a			; $6b9c
	ret nz			; $6b9d
	call disableLcd		; $6b9e
	call clearScreenVariablesAndWramBank1		; $6ba1
	ld a,$03		; $6ba4
	ld ($cc4e),a		; $6ba6
	ld bc,$0103		; $6ba9
	call $6de4		; $6bac
	ld a,$78		; $6baf
	ld ($cbb4),a		; $6bb1
	ld a,$01		; $6bb4
	ld ($cc03),a		; $6bb6
	xor a			; $6bb9
	ld ($cbb3),a		; $6bba
	ld a,$21		; $6bbd
	ld (wActiveMusic),a		; $6bbf
	call playSound		; $6bc2
	ld a,$b0		; $6bc5
	call playSound		; $6bc7
	ld a,$01		; $6bca
	ld ($cd00),a		; $6bcc
	call fadeinFromWhite		; $6bcf
	call loadCommonGraphics		; $6bd2
	ld a,$02		; $6bd5
	jp loadGfxRegisterStateIndex		; $6bd7
	call $6df8		; $6bda
	ld a,($cbb3)		; $6bdd
	rst_jumpTable			; $6be0
	jp hl			; $6be1
	ld l,e			; $6be2
	inc bc			; $6be3
	ld l,h			; $6be4
	add hl,de		; $6be5
	ld l,h			; $6be6
	ld b,c			; $6be7
	ld l,h			; $6be8
	ld a,($c4ab)		; $6be9
	or a			; $6bec
	ret nz			; $6bed
	call $6ddf		; $6bee
	ret nz			; $6bf1
	ld a,$b0		; $6bf2
	call playSound		; $6bf4
	ld hl,$cbb4		; $6bf7
	ld (hl),$96		; $6bfa
	inc hl			; $6bfc
	ld (hl),$01		; $6bfd
	ld hl,$cbb3		; $6bff
	inc (hl)		; $6c02
	ld bc,$1478		; $6c03
	ld hl,$cbb5		; $6c06
	call $6db1		; $6c09
	call $6ddf		; $6c0c
	ret nz			; $6c0f
	ld a,$81		; $6c10
	ld ($cd02),a		; $6c12
	ld hl,$cbb3		; $6c15
	inc (hl)		; $6c18
	ld a,($cd00)		; $6c19
	and $04			; $6c1c
	ret z			; $6c1e
	ld a,$04		; $6c1f
	ld ($cc4c),a		; $6c21
	ld hl,$4964		; $6c24
	ld e,$01		; $6c27
	call interBankCall		; $6c29
	call loadScreenMusicAndSetRoomPack		; $6c2c
	call loadTilesetData		; $6c2f
	call loadTilesetAndRoomLayout		; $6c32
	call generateVramTilesWithRoomChanges		; $6c35
	ld a,$08		; $6c38
	ld ($cd00),a		; $6c3a
	ld hl,$cbb3		; $6c3d
	inc (hl)		; $6c40
	ld a,($cd00)		; $6c41
	and $01			; $6c44
	ret z			; $6c46
	ld hl,$49a4		; $6c47
	ld e,$01		; $6c4a
	call interBankCall		; $6c4c
	ld hl,$cbb4		; $6c4f
	ld (hl),$96		; $6c52
	inc hl			; $6c54
	ld (hl),$01		; $6c55
	inc hl			; $6c57
	ld (hl),$01		; $6c58
	ld a,$b0		; $6c5a
	call playSound		; $6c5c
	ld hl,$cc03		; $6c5f
	inc (hl)		; $6c62
	ld hl,$cbb3		; $6c63
	ld (hl),$00		; $6c66
	ret			; $6c68
	call $6df8		; $6c69
	ld bc,$1430		; $6c6c
	ld hl,$cbb5		; $6c6f
	call $6db1		; $6c72
	ld bc,$1488		; $6c75
	ld hl,$cbb6		; $6c78
	call $6db1		; $6c7b
	ld hl,$cbb4		; $6c7e
	dec (hl)		; $6c81
	ret nz			; $6c82
	call $6c5f		; $6c83
	jp fastFadeoutToWhite		; $6c86
	ld a,($cbb3)		; $6c89
	rst_jumpTable			; $6c8c
	sub a			; $6c8d
	ld l,h			; $6c8e
	or a			; $6c8f
	ld l,h			; $6c90
	jp z,$e06c		; $6c91
	ld l,h			; $6c94
	cp $6c			; $6c95
	ld a,($c4ab)		; $6c97
	or a			; $6c9a
	ret nz			; $6c9b
	call setScreenShakeCounter		; $6c9c
	call disableLcd		; $6c9f
	call clearScreenVariablesAndWramBank1		; $6ca2
	ld bc,$0015		; $6ca5
	call $6de4		; $6ca8
	ld a,$1e		; $6cab
	ld ($cbb4),a		; $6cad
	ld hl,$cbb3		; $6cb0
	inc (hl)		; $6cb3
	jp $6d9f		; $6cb4
	call $6ddf		; $6cb7
	ret nz			; $6cba
	call $6df8		; $6cbb
	ld hl,$cbb4		; $6cbe
	ld (hl),$78		; $6cc1
	inc hl			; $6cc3
	ld (hl),$01		; $6cc4
	ld hl,$cbb3		; $6cc6
	inc (hl)		; $6cc9
	ld hl,$cbb5		; $6cca
	call $6dcb		; $6ccd
	call $6ddf		; $6cd0
	ret nz			; $6cd3
	call $6df8		; $6cd4
	ld hl,$cbb3		; $6cd7
	inc (hl)		; $6cda
	ld a,$02		; $6cdb
	call fadeoutToWhiteWithDelay		; $6cdd
	ld a,($c4ab)		; $6ce0
	or a			; $6ce3
	ret nz			; $6ce4
	call $6d8b		; $6ce5
	call getFreeInteractionSlot		; $6ce8
	jr nz,_label_03_197	; $6ceb
	ld (hl),$dc		; $6ced
	inc l			; $6cef
	ld (hl),$0e		; $6cf0
_label_03_197:
	ld hl,$cbb3		; $6cf2
	inc (hl)		; $6cf5
	ld hl,$cbb4		; $6cf6
	ld (hl),$78		; $6cf9
	call $6df8		; $6cfb
	ld hl,$cbb5		; $6cfe
	call $6dcb		; $6d01
	call $6ddf		; $6d04
	ret nz			; $6d07
	call $6c5f		; $6d08
	ld a,$02		; $6d0b
	jp fadeoutToWhiteWithDelay		; $6d0d
	ld a,($cbb3)		; $6d10
	rst_jumpTable			; $6d13
	ld e,$6d		; $6d14
	or a			; $6d16
	ld l,h			; $6d17
	jp z,$e06c		; $6d18
	ld l,h			; $6d1b
	cp $6c			; $6d1c
	ld a,($c4ab)		; $6d1e
	or a			; $6d21
	ret nz			; $6d22
	call setScreenShakeCounter		; $6d23
	call disableLcd		; $6d26
	call clearScreenVariablesAndWramBank1		; $6d29
	ld a,$15		; $6d2c
	call unsetGlobalFlag		; $6d2e
	ld bc,$0027		; $6d31
	call $6de4		; $6d34
	ld a,$1e		; $6d37
	ld ($cbb4),a		; $6d39
	ld hl,$cbb3		; $6d3c
	inc (hl)		; $6d3f
	jp $6d9f		; $6d40
	ld a,($cbb3)		; $6d43
	rst_jumpTable			; $6d46
	ld d,c			; $6d47
	ld l,l			; $6d48
	or a			; $6d49
	ld l,h			; $6d4a
	jp z,$e06c		; $6d4b
	ld l,h			; $6d4e
	halt			; $6d4f
	ld l,l			; $6d50
	ld a,($c4ab)		; $6d51
	or a			; $6d54
	ret nz			; $6d55
	call setScreenShakeCounter		; $6d56
	call disableLcd		; $6d59
	call clearScreenVariablesAndWramBank1		; $6d5c
	ld a,$15		; $6d5f
	call unsetGlobalFlag		; $6d61
	ld bc,$0017		; $6d64
	call $6de4		; $6d67
	ld a,$1e		; $6d6a
	ld ($cbb4),a		; $6d6c
	ld hl,$cbb3		; $6d6f
	inc (hl)		; $6d72
	jp $6d9f		; $6d73
	ld hl,$cbb5		; $6d76
	call $6dcb		; $6d79
	call $6ddf		; $6d7c
	ret nz			; $6d7f
	ld hl,$6d86		; $6d80
	jp setWarpDestVariables		; $6d83
	add h			; $6d86
	rst $28			; $6d87
	nop			; $6d88
	ld l,c			; $6d89
	inc bc			; $6d8a
	call disableLcd		; $6d8b
	call clearScreenVariablesAndWramBank1		; $6d8e
	ld a,$15		; $6d91
	call setGlobalFlag		; $6d93
	call loadTilesetData		; $6d96
	call loadTilesetGraphics		; $6d99
	call func_131f		; $6d9c
	ld a,$01		; $6d9f
	ld ($cd00),a		; $6da1
	ld a,$02		; $6da4
	call fadeinFromWhiteWithDelay		; $6da6
	call loadCommonGraphics		; $6da9
	ld a,$02		; $6dac
	jp loadGfxRegisterStateIndex		; $6dae
	dec (hl)		; $6db1
	ret nz			; $6db2
	call getRandomNumber		; $6db3
	and $0f			; $6db6
	add $08			; $6db8
	ld (hl),a		; $6dba
	call getFreePartSlot		; $6dbb
	ret nz			; $6dbe
	ld (hl),$11		; $6dbf
	inc l			; $6dc1
	ld (hl),$01		; $6dc2
	ld l,$cb		; $6dc4
	ld (hl),b		; $6dc6
	ld l,$cd		; $6dc7
	ld (hl),c		; $6dc9
	ret			; $6dca
	dec (hl)		; $6dcb
	ret nz			; $6dcc
	call getRandomNumber		; $6dcd
	and $0f			; $6dd0
	add $08			; $6dd2
	ld (hl),a		; $6dd4
	call getFreePartSlot		; $6dd5
	ret nz			; $6dd8
	ld (hl),$11		; $6dd9
	inc l			; $6ddb
	ld (hl),$02		; $6ddc
	ret			; $6dde
	ld hl,$cbb4		; $6ddf
	dec (hl)		; $6de2
	ret			; $6de3
	ld a,b			; $6de4
	ld ($cc49),a		; $6de5
	ld a,c			; $6de8
	ld ($cc4c),a		; $6de9
	call loadScreenMusicAndSetRoomPack		; $6dec
	call loadTilesetData		; $6def
	call loadTilesetGraphics		; $6df2
	jp func_131f		; $6df5
	ld a,$ff		; $6df8
	jp setScreenShakeCounter		; $6dfa

.include "code/seasons/cutscenes/bank03LinkedGameCutscenes.s"
.include "code/seasons/cutscenes/bank03IntroCutscenes.s"

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
roomLayoutGroupTable: ; $4c4c
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

	.db $01
	3BytePointer roomLayoutGroup4Table
	3BytePointer room0400
	.db $00

	.db $00
	3BytePointer roomLayoutGroup5Table
	3BytePointer room0500
	.db $00

	.db $00
	3BytePointer roomLayoutGroup6Table
	3BytePointer room0600
	.db $00

.include "build/data/tilesets.s"
.include "build/data/tilesetAssignments.s"

initializeAnimations:
	ld a,($cd25)		; $574c
	cp $ff			; $574f
	ret z			; $5751
	call loadAnimationData		; $5752
	call $579a		; $5755
_label_04_183:
	call $5773		; $5758
	jr nz,_label_04_183	; $575b
	ret			; $575d
updateAnimations:
	ld hl,$cd30		; $575e
	res 6,(hl)		; $5761
	ld a,($cd25)		; $5763
	inc a			; $5766
	ret z			; $5767
	ld a,($cd00)		; $5768
	and $01			; $576b
	ret z			; $576d
	call $5773		; $576e
	jr _label_04_184		; $5771
	ld a,($ccfa)		; $5773
	ld b,a			; $5776
	ld a,($ccfb)		; $5777
	cp b			; $577a
	ret z			; $577b
	inc b			; $577c
	ld a,b			; $577d
	and $1f			; $577e
	ld ($ccfa),a		; $5780
	ld hl,$db90		; $5783
	rst_addAToHl			; $5786
	ld a,$02		; $5787
	ld ($ff00+$70),a	; $5789
	ld b,(hl)		; $578b
	xor a			; $578c
	ld ($ff00+$70),a	; $578d
	ld a,b			; $578f
	call $580f		; $5790
	ld hl,$cd30		; $5793
	set 6,(hl)		; $5796
	or h			; $5798
	ret			; $5799
_label_04_184:
	ld hl,$cd31		; $579a
	ld a,($cd30)		; $579d
	bit 0,a			; $57a0
	call nz,$57cf		; $57a2
	ld hl,$cd34		; $57a5
	ld a,($cd30)		; $57a8
	bit 1,a			; $57ab
	call nz,$57cf		; $57ad
	ld hl,$cd37		; $57b0
	ld a,($cd30)		; $57b3
	bit 2,a			; $57b6
	call nz,$57cf		; $57b8
	ld hl,$cd3a		; $57bb
	ld a,($cd30)		; $57be
	bit 3,a			; $57c1
	call nz,$57cf		; $57c3
	ld a,($cd30)		; $57c6
	and $7f			; $57c9
	ld ($cd30),a		; $57cb
	ret			; $57ce
	ld a,($cd30)		; $57cf
	bit 7,a			; $57d2
	jr nz,_label_04_185	; $57d4
	dec (hl)		; $57d6
	ret nz			; $57d7
_label_04_185:
	push hl			; $57d8
	inc hl			; $57d9
	ldi a,(hl)		; $57da
	ld h,(hl)		; $57db
	ld l,a			; $57dc
	ld e,(hl)		; $57dd
	inc hl			; $57de
	ldi a,(hl)		; $57df
	cp $ff			; $57e0
	jr nz,_label_04_186	; $57e2
	ld b,a			; $57e4
	ld c,(hl)		; $57e5
	add hl,bc		; $57e6
	ldi a,(hl)		; $57e7
_label_04_186:
	ld c,l			; $57e8
	ld b,h			; $57e9
	pop hl			; $57ea
	ldi (hl),a		; $57eb
	ld (hl),c		; $57ec
	inc hl			; $57ed
	ld (hl),b		; $57ee
	ld b,e			; $57ef
	ld a,($ccfb)		; $57f0
	inc a			; $57f3
	and $1f			; $57f4
	ld e,a			; $57f6
	ld a,($ccfa)		; $57f7
	cp e			; $57fa
	ret z			; $57fb
	ld a,e			; $57fc
	ld ($ccfb),a		; $57fd
	ld a,$02		; $5800
	ld ($ff00+$70),a	; $5802
	ld a,e			; $5804
	ld hl,$db90		; $5805
	rst_addAToHl			; $5808
	ld (hl),b		; $5809
	xor a			; $580a
	ld ($ff00+$70),a	; $580b
	or h			; $580d
	ret			; $580e
	ld c,$06		; $580f
	call multiplyAByC		; $5811
	ld bc,$5a48		; $5814
	add hl,bc		; $5817
	ldi a,(hl)		; $5818
	ld c,a			; $5819
	ldi a,(hl)		; $581a
	ld d,a			; $581b
	ldi a,(hl)		; $581c
	ld e,a			; $581d
	push de			; $581e
	ldi a,(hl)		; $581f
	ld d,a			; $5820
	ldi a,(hl)		; $5821
	ld e,a			; $5822
	ld b,(hl)		; $5823
	pop hl			; $5824
	jp queueDmaTransfer		; $5825


	.include "data/seasons/uniqueGfxHeaders.s"
	.include "data/seasons/uniqueGfxHeaderPointers.s"

animationGroupTable:
	and $59			; $59b0
.DB $eb				; $59b2
	ld e,c			; $59b3
	ld a,($ff00+$59)	; $59b4
	push af			; $59b6
	ld e,c			; $59b7
_label_04_188:
	ld hl,sp+$59		; $59b8
_label_04_189:
	rst $38			; $59ba
	ld e,c			; $59bb
	inc b			; $59bc
	ld e,d			; $59bd
	and $59			; $59be
	ld c,$5a		; $59c0
	inc de			; $59c2
	ld e,d			; $59c3
	ld d,$5a		; $59c4
	dec e			; $59c6
	ld e,d			; $59c7
	jr nz,_label_04_190	; $59c8
	inc hl			; $59ca
	ld e,d			; $59cb
	ld h,$5a		; $59cc
	and $59			; $59ce
	add hl,hl		; $59d0
	ld e,d			; $59d1
	ld l,$5a		; $59d2
	and $59			; $59d4
	and $59			; $59d6
	and $59			; $59d8
	and $59			; $59da
	and $59			; $59dc
	and $59			; $59de
	inc sp			; $59e0
	ld e,d			; $59e1
	inc a			; $59e2
	ld e,d			; $59e3
	ld b,l			; $59e4
	ld e,d			; $59e5
	add e			; $59e6
	sub h			; $59e7
	ld e,h			; $59e8
	sbc (hl)		; $59e9
	ld e,h			; $59ea
	add e			; $59eb
	sub h			; $59ec
	ld e,h			; $59ed
.DB $e4				; $59ee
	ld e,h			; $59ef
	add e			; $59f0
	sub h			; $59f1
	ld e,h			; $59f2
	xor b			; $59f3
	ld e,h			; $59f4
	add c			; $59f5
	sub h			; $59f6
	ld e,h			; $59f7
	add a			; $59f8
	sub h			; $59f9
	ld e,h			; $59fa
	add $5c			; $59fb
	jp c,$835c		; $59fd
	sub h			; $5a00
	ld e,h			; $5a01
	jp c,$875c		; $5a02
	sub h			; $5a05
	ld e,h			; $5a06
	ret nc			; $5a07
	ld e,h			; $5a08
	cp h			; $5a09
	ld e,h			; $5a0a
	add c			; $5a0b
	sub h			; $5a0c
	ld e,h			; $5a0d
	add e			; $5a0e
	ld hl,sp+$5c		; $5a0f
	ld (bc),a		; $5a11
	ld e,l			; $5a12
	add c			; $5a13
	inc c			; $5a14
	ld e,l			; $5a15
	add a			; $5a16
	sub h			; $5a17
	ld e,h			; $5a18
	xor b			; $5a19
	ld e,h			; $5a1a
	xor $5c			; $5a1b
	add c			; $5a1d
	ld d,$5d		; $5a1e
	add c			; $5a20
	ld a,(de)		; $5a21
	ld e,l			; $5a22
	add c			; $5a23
_label_04_190:
	ld e,$5d		; $5a24
	add c			; $5a26
	inc h			; $5a27
	ld e,l			; $5a28
	add e			; $5a29
	ld l,$5d		; $5a2a
	jr c,_label_04_191	; $5a2c
	add e			; $5a2e
	ld l,$5d		; $5a2f
	ld c,d			; $5a31
	ld e,l			; $5a32
	adc a			; $5a33
	ld e,(hl)		; $5a34
	ld e,l			; $5a35
	ld l,b			; $5a36
	ld e,l			; $5a37
	ld (hl),d		; $5a38
	ld e,l			; $5a39
	add b			; $5a3a
	ld e,l			; $5a3b
	adc a			; $5a3c
	ld e,(hl)		; $5a3d
	ld e,l			; $5a3e
	ld l,b			; $5a3f
	ld e,l			; $5a40
	ld (hl),d		; $5a41
	ld e,l			; $5a42
	adc d			; $5a43
	ld e,l			; $5a44
	add c			; $5a45
	ld d,h			; $5a46
	ld e,l			; $5a47
	jr $65			; $5a48
	ld b,b			; $5a4a
	adc b			; $5a4b
	add c			; $5a4c
	inc bc			; $5a4d
	jr $65			; $5a4e
	add b			; $5a50
	adc b			; $5a51
	add c			; $5a52
	inc bc			; $5a53
	jr $65			; $5a54
	ret nz			; $5a56
	adc b			; $5a57
	add c			; $5a58
	inc bc			; $5a59
	jr _label_04_192		; $5a5a
	nop			; $5a5c
	adc b			; $5a5d
	add c			; $5a5e
	inc bc			; $5a5f
	jr _label_04_193		; $5a60
	ld h,b			; $5a62
	adc b			; $5a63
	pop bc			; $5a64
	ld bc,$6718		; $5a65
	and b			; $5a68
	adc b			; $5a69
	pop bc			; $5a6a
	ld bc,$6718		; $5a6b
	ld ($ff00+$88),a	; $5a6e
	pop bc			; $5a70
	ld bc,$6818		; $5a71
	jr nz,-$78		; $5a74
	pop bc			; $5a76
	ld bc,$6718		; $5a77
	ld b,b			; $5a7a
	sub (hl)		; $5a7b
	ld bc,$1803		; $5a7c
	ld h,a			; $5a7f
	add b			; $5a80
	sub (hl)		; $5a81
	ld bc,$1803		; $5a82
	ld h,a			; $5a85
	ret nz			; $5a86
	sub (hl)		; $5a87
	ld bc,$1803		; $5a88
_label_04_191:
	ld l,b			; $5a8b
	nop			; $5a8c
	sub (hl)		; $5a8d
	ld bc,$1803		; $5a8e
	ld h,a			; $5a91
	ld b,b			; $5a92
	adc b			; $5a93
	pop bc			; $5a94
	inc bc			; $5a95
	jr _label_04_194		; $5a96
	add b			; $5a98
	adc b			; $5a99
	pop bc			; $5a9a
	inc bc			; $5a9b
	jr _label_04_195		; $5a9c
	ret nz			; $5a9e
	adc b			; $5a9f
	pop bc			; $5aa0
	inc bc			; $5aa1
	jr _label_04_196		; $5aa2
	nop			; $5aa4
	adc b			; $5aa5
	pop bc			; $5aa6
	inc bc			; $5aa7
	jr _label_04_197		; $5aa8
	ld b,b			; $5aaa
	adc b			; $5aab
	pop bc			; $5aac
	inc bc			; $5aad
	jr _label_04_198		; $5aae
	add b			; $5ab0
	adc b			; $5ab1
	pop bc			; $5ab2
	inc bc			; $5ab3
	jr _label_04_199		; $5ab4
	ret nz			; $5ab6
	adc b			; $5ab7
	pop bc			; $5ab8
	inc bc			; $5ab9
	jr _label_04_200		; $5aba
	nop			; $5abc
	adc b			; $5abd
	pop bc			; $5abe
	inc bc			; $5abf
	jr _label_04_201		; $5ac0
_label_04_192:
	ld b,b			; $5ac2
	sub (hl)		; $5ac3
	add c			; $5ac4
	ld bc,$6918		; $5ac5
	ld h,b			; $5ac8
_label_04_193:
	sub (hl)		; $5ac9
	add c			; $5aca
	ld bc,$6918		; $5acb
	add b			; $5ace
	sub (hl)		; $5acf
	add c			; $5ad0
	ld bc,$6918		; $5ad1
	and b			; $5ad4
	sub (hl)		; $5ad5
	add c			; $5ad6
	ld bc,$6918		; $5ad7
	ld b,b			; $5ada
	sub (hl)		; $5adb
	ld sp,$1801		; $5adc
	ld l,c			; $5adf
	ld h,b			; $5ae0
	sub (hl)		; $5ae1
	ld sp,$1801		; $5ae2
	ld l,c			; $5ae5
	add b			; $5ae6
	sub (hl)		; $5ae7
	ld sp,$1801		; $5ae8
	ld l,c			; $5aeb
	and b			; $5aec
	sub (hl)		; $5aed
	ld sp,$1801		; $5aee
	ld l,b			; $5af1
	ld b,b			; $5af2
	adc b			; $5af3
	pop bc			; $5af4
	inc bc			; $5af5
	jr _label_04_204		; $5af6
	add b			; $5af8
	adc b			; $5af9
	pop bc			; $5afa
	inc bc			; $5afb
	jr _label_04_205		; $5afc
	ret nz			; $5afe
_label_04_194:
	adc b			; $5aff
	pop bc			; $5b00
	inc bc			; $5b01
	jr _label_04_206		; $5b02
	nop			; $5b04
_label_04_195:
	adc b			; $5b05
	pop bc			; $5b06
	inc bc			; $5b07
	jr _label_04_207		; $5b08
	nop			; $5b0a
	adc b			; $5b0b
_label_04_196:
	pop bc			; $5b0c
	inc bc			; $5b0d
	jr _label_04_208		; $5b0e
_label_04_197:
	ld b,b			; $5b10
	adc b			; $5b11
	pop bc			; $5b12
	inc bc			; $5b13
	jr _label_04_209		; $5b14
_label_04_198:
	add b			; $5b16
	adc b			; $5b17
	pop bc			; $5b18
	inc bc			; $5b19
	jr _label_04_210		; $5b1a
_label_04_199:
	ret nz			; $5b1c
	adc b			; $5b1d
	pop bc			; $5b1e
	inc bc			; $5b1f
	jr _label_04_211		; $5b20
	nop			; $5b22
_label_04_200:
	sub e			; $5b23
	add c			; $5b24
	inc bc			; $5b25
	jr _label_04_212		; $5b26
	ld b,b			; $5b28
	sub e			; $5b29
	add c			; $5b2a
_label_04_201:
	inc bc			; $5b2b
_label_04_202:
	jr _label_04_213		; $5b2c
	add b			; $5b2e
	sub e			; $5b2f
	add c			; $5b30
	inc bc			; $5b31
_label_04_203:
	jr _label_04_214		; $5b32
	ret nz			; $5b34
	sub e			; $5b35
	add c			; $5b36
	inc bc			; $5b37
	jr _label_04_215		; $5b38
	ld ($ff00+$88),a	; $5b3a
	and c			; $5b3c
	inc b			; $5b3d
	jr $6a			; $5b3e
	ld (hl),b		; $5b40
	adc b			; $5b41
	and c			; $5b42
	inc b			; $5b43
	jr _label_04_216		; $5b44
	nop			; $5b46
	adc b			; $5b47
	and c			; $5b48
	inc b			; $5b49
	jr _label_04_217		; $5b4a
	sub b			; $5b4c
	adc b			; $5b4d
	and c			; $5b4e
	inc b			; $5b4f
	jr _label_04_218		; $5b50
	ret nz			; $5b52
	adc b			; $5b53
	add c			; $5b54
	ld bc,$6a18		; $5b55
	ld d,b			; $5b58
	adc b			; $5b59
	add c			; $5b5a
	ld bc,$6a18		; $5b5b
	ld ($ff00+$88),a	; $5b5e
_label_04_204:
	add c			; $5b60
	ld bc,$6b18		; $5b61
	ld (hl),b		; $5b64
	adc b			; $5b65
_label_04_205:
	add c			; $5b66
	ld bc,$6918		; $5b67
	ret nz			; $5b6a
	adc b			; $5b6b
	add c			; $5b6c
_label_04_206:
	inc bc			; $5b6d
	jr $6a			; $5b6e
	ld d,b			; $5b70
	adc b			; $5b71
	add c			; $5b72
	inc bc			; $5b73
	jr $6a			; $5b74
_label_04_207:
	ld ($ff00+$88),a	; $5b76
	add c			; $5b78
	inc bc			; $5b79
	jr _label_04_220		; $5b7a
_label_04_208:
	ld (hl),b		; $5b7c
	adc b			; $5b7d
	add c			; $5b7e
	inc bc			; $5b7f
	jr $64			; $5b80
_label_04_209:
	ld b,b			; $5b82
	adc b			; $5b83
	add c			; $5b84
	rlca			; $5b85
	jr $64			; $5b86
_label_04_210:
	ret nz			; $5b88
	adc b			; $5b89
	add c			; $5b8a
	rlca			; $5b8b
	jr $64			; $5b8c
_label_04_211:
	nop			; $5b8e
	sub b			; $5b8f
	sub c			; $5b90
	nop			; $5b91
	jr $64			; $5b92
_label_04_212:
	stop			; $5b94
	sub b			; $5b95
	sub c			; $5b96
	nop			; $5b97
	jr $64			; $5b98
_label_04_213:
	jr nz,_label_04_202	; $5b9a
	sub c			; $5b9c
	nop			; $5b9d
	jr $64			; $5b9e
_label_04_214:
	jr nc,_label_04_203	; $5ba0
	sub c			; $5ba2
_label_04_215:
	nop			; $5ba3
	jr _label_04_221		; $5ba4
	add b			; $5ba6
	adc l			; $5ba7
	add c			; $5ba8
	ld b,$18		; $5ba9
	ld (hl),d		; $5bab
	add b			; $5bac
	adc l			; $5bad
	add c			; $5bae
	ld b,$18		; $5baf
_label_04_216:
	ld (hl),e		; $5bb1
	add b			; $5bb2
	adc l			; $5bb3
	add c			; $5bb4
	ld b,$18		; $5bb5
_label_04_217:
	ld (hl),h		; $5bb7
	add b			; $5bb8
	adc l			; $5bb9
	add c			; $5bba
_label_04_218:
	ld b,$18		; $5bbb
	ld (hl),c		; $5bbd
	ldh a,(<hFF8D)	; $5bbe
	pop af			; $5bc0
	nop			; $5bc1
	jr _label_04_222		; $5bc2
	ldh a,(<hFF8D)	; $5bc4
	pop af			; $5bc6
_label_04_219:
	nop			; $5bc7
	jr $73			; $5bc8
	ldh a,(<hFF8D)	; $5bca
	pop af			; $5bcc
	nop			; $5bcd
	jr _label_04_223		; $5bce
	ldh a,(<hFF8D)	; $5bd0
	pop af			; $5bd2
	nop			; $5bd3
	jr _label_04_224		; $5bd4
	nop			; $5bd6
	adc a			; $5bd7
	ld bc,$1800		; $5bd8
	ld (hl),e		; $5bdb
	nop			; $5bdc
	adc a			; $5bdd
	ld bc,$1800		; $5bde
	ld (hl),h		; $5be1
	nop			; $5be2
	adc a			; $5be3
	ld bc,$1800		; $5be4
_label_04_220:
	ld (hl),l		; $5be7
	nop			; $5be8
	adc a			; $5be9
	ld bc,$1800		; $5bea
	ld (hl),d		; $5bed
	nop			; $5bee
	adc a			; $5bef
	ld bc,$1804		; $5bf0
	ld (hl),e		; $5bf3
	nop			; $5bf4
	adc a			; $5bf5
	ld bc,$1804		; $5bf6
	ld (hl),h		; $5bf9
	nop			; $5bfa
	adc a			; $5bfb
	ld bc,$1804		; $5bfc
	ld (hl),l		; $5bff
	nop			; $5c00
	adc a			; $5c01
	ld bc,$1804		; $5c02
	ld l,l			; $5c05
	nop			; $5c06
	adc c			; $5c07
	ld bc,$180a		; $5c08
	ld l,l			; $5c0b
	or b			; $5c0c
	adc c			; $5c0d
	ld bc,$180a		; $5c0e
	ld l,(hl)		; $5c11
	ld h,b			; $5c12
	adc c			; $5c13
	ld bc,$180a		; $5c14
_label_04_221:
	ld l,a			; $5c17
	stop			; $5c18
	adc c			; $5c19
	ld bc,$180a		; $5c1a
	ld l,a			; $5c1d
	ret nz			; $5c1e
	adc c			; $5c1f
	or c			; $5c20
	nop			; $5c21
	jr $6f			; $5c22
	ret nc			; $5c24
	adc c			; $5c25
	or c			; $5c26
	nop			; $5c27
	jr $6f			; $5c28
	ld ($ff00+$89),a	; $5c2a
	or c			; $5c2c
	nop			; $5c2d
	jr _label_04_225		; $5c2e
	ld a,($ff00+$89)	; $5c30
	or c			; $5c32
	nop			; $5c33
	jr _label_04_226		; $5c34
_label_04_222:
	nop			; $5c36
	adc c			; $5c37
	pop bc			; $5c38
	ld bc,$7018		; $5c39
	jr nz,_label_04_219	; $5c3c
	pop bc			; $5c3e
	ld bc,$7018		; $5c3f
	ld b,b			; $5c42
	adc c			; $5c43
_label_04_223:
	pop bc			; $5c44
	ld bc,$7018		; $5c45
_label_04_224:
	ld h,b			; $5c48
	adc c			; $5c49
	pop bc			; $5c4a
	ld bc,$7018		; $5c4b
	add b			; $5c4e
	adc c			; $5c4f
	pop hl			; $5c50
	ld bc,$7018		; $5c51
	and b			; $5c54
	adc c			; $5c55
	pop hl			; $5c56
	ld bc,$7018		; $5c57
	ret nz			; $5c5a
	adc c			; $5c5b
	pop hl			; $5c5c
	ld bc,$7018		; $5c5d
	ld ($ff00+$89),a	; $5c60
	pop hl			; $5c62
	ld bc,$7118		; $5c63
	nop			; $5c66
	adc c			; $5c67
	pop hl			; $5c68
	ld bc,$7118		; $5c69
	jr nz,-$77		; $5c6c
	pop hl			; $5c6e
	ld bc,$7118		; $5c6f
	ld b,b			; $5c72
	adc c			; $5c73
	pop hl			; $5c74
	ld bc,$7118		; $5c75
	ld h,b			; $5c78
	adc c			; $5c79
	pop hl			; $5c7a
	ld bc,$7518		; $5c7b
	add b			; $5c7e
	adc l			; $5c7f
	ld bc,$180d		; $5c80
	halt			; $5c83
	add b			; $5c84
	adc l			; $5c85
	ld bc,$180d		; $5c86
	ld (hl),a		; $5c89
	add b			; $5c8a
	adc l			; $5c8b
	ld bc,$180d		; $5c8c
	ld a,b			; $5c8f
	add b			; $5c90
	adc l			; $5c91
	ld bc,$0f0d		; $5c92
	nop			; $5c95
	rrca			; $5c96
	ld bc,$020f		; $5c97
	rrca			; $5c9a
	inc bc			; $5c9b
	rst $38			; $5c9c
	rst $30			; $5c9d
	rrca			; $5c9e
_label_04_225:
	inc b			; $5c9f
	rrca			; $5ca0
	dec b			; $5ca1
	rrca			; $5ca2
	ld b,$0f		; $5ca3
	rlca			; $5ca5
_label_04_226:
	rst $38			; $5ca6
	rst $30			; $5ca7
	ld ($0810),sp		; $5ca8
	ld de,$1208		; $5cab
	ld ($ff13),sp		; $5cae
	rst $30			; $5cb1
	rrca			; $5cb2
	inc d			; $5cb3
	rrca			; $5cb4
	dec d			; $5cb5
	rrca			; $5cb6
	ld d,$0f		; $5cb7
	rla			; $5cb9
	rst $38			; $5cba
	rst $30			; $5cbb
	rrca			; $5cbc
	jr _label_04_227		; $5cbd
	add hl,de		; $5cbf
	rrca			; $5cc0
	ld a,(de)		; $5cc1
	rrca			; $5cc2
	dec de			; $5cc3
	rst $38			; $5cc4
	rst $30			; $5cc5
	rrca			; $5cc6
	.db $08 $0f $09 ; $5cc7
	rrca			; $5cca
	ld a,(bc)		; $5ccb
	rrca			; $5ccc
	dec bc			; $5ccd
_label_04_227:
	rst $38			; $5cce
	rst $30			; $5ccf
	rrca			; $5cd0
	inc c			; $5cd1
	rrca			; $5cd2
	dec c			; $5cd3
	rrca			; $5cd4
	ld c,$0f		; $5cd5
	rrca			; $5cd7
	rst $38			; $5cd8
	rst $30			; $5cd9
	inc b			; $5cda
	inc e			; $5cdb
	inc b			; $5cdc
	dec e			; $5cdd
	inc b			; $5cde
	ld e,$04		; $5cdf
	rra			; $5ce1
	rst $38			; $5ce2
	rst $30			; $5ce3
	ld b,$20		; $5ce4
	ld b,$21		; $5ce6
	ld b,$22		; $5ce8
	ld b,$23		; $5cea
	rst $38			; $5cec
	rst $30			; $5ced
	ld b,$24		; $5cee
	ld b,$25		; $5cf0
	ld b,$26		; $5cf2
	ld b,$27		; $5cf4
	rst $38			; $5cf6
	rst $30			; $5cf7
	rrca			; $5cf8
	jr z,_label_04_228	; $5cf9
	add hl,hl		; $5cfb
	rrca			; $5cfc
	ldi a,(hl)		; $5cfd
	rrca			; $5cfe
	dec hl			; $5cff
	rst $38			; $5d00
	rst $30			; $5d01
	ld ($082c),sp		; $5d02
	dec l			; $5d05
	ld ($082e),sp		; $5d06
	cpl			; $5d09
_label_04_228:
	rst $38			; $5d0a
	rst $30			; $5d0b
	rrca			; $5d0c
	jr nc,_label_04_229	; $5d0d
	ld sp,$320f		; $5d0f
	rrca			; $5d12
	inc sp			; $5d13
	rst $38			; $5d14
	rst $30			; $5d15
	rrca			; $5d16
	inc (hl)		; $5d17
	rst $38			; $5d18
.DB $fd				; $5d19
	rrca			; $5d1a
	dec (hl)		; $5d1b
	rst $38			; $5d1c
.DB $fd				; $5d1d
_label_04_229:
	rrca			; $5d1e
	inc (hl)		; $5d1f
	rrca			; $5d20
	dec (hl)		; $5d21
	rst $38			; $5d22
	ei			; $5d23
	ld (bc),a		; $5d24
	ld (hl),$02		; $5d25
	scf			; $5d27
	ld (bc),a		; $5d28
	jr c,_label_04_230	; $5d29
	add hl,sp		; $5d2b
	rst $38			; $5d2c
_label_04_230:
	rst $30			; $5d2d
	rrca			; $5d2e
	ldd a,(hl)		; $5d2f
	rrca			; $5d30
	dec sp			; $5d31
	rrca			; $5d32
	inc a			; $5d33
	rrca			; $5d34
	dec a			; $5d35
	rst $38			; $5d36
	rst $30			; $5d37
	inc b			; $5d38
	ld a,$04		; $5d39
	ld b,d			; $5d3b
	inc b			; $5d3c
	ccf			; $5d3d
	inc b			; $5d3e
	ld b,e			; $5d3f
	inc b			; $5d40
	ld b,b			; $5d41
	inc b			; $5d42
	ld b,h			; $5d43
	inc b			; $5d44
	ld b,c			; $5d45
	inc b			; $5d46
	ld b,l			; $5d47
	rst $38			; $5d48
	rst $28			; $5d49
	rrca			; $5d4a
	ld b,(hl)		; $5d4b
	rrca			; $5d4c
	ld b,a			; $5d4d
	rrca			; $5d4e
	ld c,b			; $5d4f
	rrca			; $5d50
	ld c,c			; $5d51
	rst $38			; $5d52
	rst $30			; $5d53
	ld e,$5e		; $5d54
	ld e,$5f		; $5d56
	ld e,$60		; $5d58
	ld e,$61		; $5d5a
	rst $38			; $5d5c
	rst $30			; $5d5d
	rrca			; $5d5e
	ld c,d			; $5d5f
	rrca			; $5d60
	ld c,e			; $5d61
	rrca			; $5d62
	ld c,h			; $5d63
	rrca			; $5d64
	ld c,l			; $5d65
	rst $38			; $5d66
	rst $30			; $5d67
	ld ($084e),sp		; $5d68
	ld c,a			; $5d6b
	ld ($0850),sp		; $5d6c
	ld d,c			; $5d6f
	rst $38			; $5d70
	rst $30			; $5d71
	rrca			; $5d72
	ld d,d			; $5d73
	rrca			; $5d74
	ld d,e			; $5d75
	rrca			; $5d76
	ld d,h			; $5d77
	rrca			; $5d78
	ld d,l			; $5d79
	rrca			; $5d7a
	ld d,h			; $5d7b
	rrca			; $5d7c
	ld d,e			; $5d7d
	rst $38			; $5d7e
	di			; $5d7f
	rrca			; $5d80
	ld d,(hl)		; $5d81
	rrca			; $5d82
	ld d,a			; $5d83
	rrca			; $5d84
	ld e,b			; $5d85
	rrca			; $5d86
	ld e,c			; $5d87
	rst $38			; $5d88
	rst $30			; $5d89
	rrca			; $5d8a
	ld e,d			; $5d8b
	rrca			; $5d8c
	ld e,e			; $5d8d
	rrca			; $5d8e
	ld e,h			; $5d8f
	rrca			; $5d90
	ld e,l			; $5d91
	rst $38			; $5d92
	rst $30			; $5d93
applyAllTileSubstitutions:
	call $5fda		; $5d94
	call $5de8		; $5d97
	call $5f53		; $5d9a
	ld a,($cc49)		; $5d9d
	cp $02			; $5da0
	jr z,_label_04_232	; $5da2
	cp $04			; $5da4
	jr nc,_label_04_231	; $5da6
	call $5dbc		; $5da8
	jp $60ab		; $5dab
_label_04_231:
	call $5ebd		; $5dae
	call $5f62		; $5db1
	jp $60ab		; $5db4
_label_04_232:
	ld e,$03		; $5db7
	jp loadObjectGfxHeaderToSlot4		; $5db9
	ld a,($c63a)		; $5dbc
	cp $01			; $5dbf
	ret nz			; $5dc1
	ld e,$06		; $5dc2
	jp loadObjectGfxHeaderToSlot4		; $5dc4
_label_04_233:
	ld a,(de)		; $5dc7
	or a			; $5dc8
	ret z			; $5dc9
	ld b,a			; $5dca
	inc de			; $5dcb
	ld a,(de)		; $5dcc
	inc de			; $5dcd
	call findTileInRoom		; $5dce
	jr nz,_label_04_233	; $5dd1
	ld (hl),b		; $5dd3
	ld c,a			; $5dd4
	ld a,l			; $5dd5
	or a			; $5dd6
	jr z,_label_04_233	; $5dd7
_label_04_234:
	dec l			; $5dd9
	ld a,c			; $5dda
	call backwardsSearch		; $5ddb
	jr nz,_label_04_233	; $5dde
	ld (hl),b		; $5de0
	ld c,a			; $5de1
	ld a,l			; $5de2
	or a			; $5de3
	jr z,_label_04_233	; $5de4
	jr _label_04_234		; $5de6
	call getThisRoomFlags		; $5de8
	ldh (<hFF8B),a	; $5deb
	ld hl,$5e26		; $5ded
	bit 0,a			; $5df0
	call nz,$5e1b		; $5df2
	ld hl,$5e36		; $5df5
	ldh a,(<hFF8B)	; $5df8
	bit 1,a			; $5dfa
	call nz,$5e1b		; $5dfc
	ld hl,$5e46		; $5dff
	ldh a,(<hFF8B)	; $5e02
	bit 2,a			; $5e04
	call nz,$5e1b		; $5e06
	ld hl,$5e56		; $5e09
	ldh a,(<hFF8B)	; $5e0c
	bit 3,a			; $5e0e
	call nz,$5e1b		; $5e10
	ld hl,$5e66		; $5e13
	ldh a,(<hFF8B)	; $5e16
	bit 7,a			; $5e18
	ret z			; $5e1a
	ld a,($cc49)		; $5e1b
	rst_addDoubleIndex			; $5e1e
	ldi a,(hl)		; $5e1f
	ld h,(hl)		; $5e20
	ld l,a			; $5e21
	ld e,l			; $5e22
	ld d,h			; $5e23
	jr _label_04_233		; $5e24
	halt			; $5e26
	ld e,(hl)		; $5e27
	halt			; $5e28
	ld e,(hl)		; $5e29
	halt			; $5e2a
	ld e,(hl)		; $5e2b
	ld (hl),a		; $5e2c
	ld e,(hl)		; $5e2d
	ld (hl),a		; $5e2e
	ld e,(hl)		; $5e2f
	ld (hl),a		; $5e30
	ld e,(hl)		; $5e31
	add b			; $5e32
	ld e,(hl)		; $5e33
	add b			; $5e34
	ld e,(hl)		; $5e35
	add c			; $5e36
	ld e,(hl)		; $5e37
	add c			; $5e38
	ld e,(hl)		; $5e39
	add c			; $5e3a
	ld e,(hl)		; $5e3b
	add d			; $5e3c
	ld e,(hl)		; $5e3d
	add d			; $5e3e
	ld e,(hl)		; $5e3f
	add d			; $5e40
	ld e,(hl)		; $5e41
	adc d			; $5e42
	ld e,(hl)		; $5e43
	adc d			; $5e44
	ld e,(hl)		; $5e45
	adc e			; $5e46
	ld e,(hl)		; $5e47
	adc e			; $5e48
	ld e,(hl)		; $5e49
	adc e			; $5e4a
	ld e,(hl)		; $5e4b
	adc h			; $5e4c
	ld e,(hl)		; $5e4d
	adc h			; $5e4e
	ld e,(hl)		; $5e4f
	adc h			; $5e50
	ld e,(hl)		; $5e51
	sub h			; $5e52
	ld e,(hl)		; $5e53
	sub h			; $5e54
	ld e,(hl)		; $5e55
	sub l			; $5e56
	ld e,(hl)		; $5e57
	sub l			; $5e58
	ld e,(hl)		; $5e59
	sub l			; $5e5a
	ld e,(hl)		; $5e5b
	sub (hl)		; $5e5c
	ld e,(hl)		; $5e5d
	sub (hl)		; $5e5e
	ld e,(hl)		; $5e5f
	sub (hl)		; $5e60
	ld e,(hl)		; $5e61
	sbc (hl)		; $5e62
	ld e,(hl)		; $5e63
	sbc (hl)		; $5e64
	ld e,(hl)		; $5e65
	sbc a			; $5e66
	ld e,(hl)		; $5e67
	xor l			; $5e68
	ld e,(hl)		; $5e69
	xor (hl)		; $5e6a
	ld e,(hl)		; $5e6b
	xor a			; $5e6c
	ld e,(hl)		; $5e6d
	or b			; $5e6e
	ld e,(hl)		; $5e6f
	or b			; $5e70
	ld e,(hl)		; $5e71
	cp h			; $5e72
	ld e,(hl)		; $5e73
	cp h			; $5e74
	ld e,(hl)		; $5e75
	nop			; $5e76
	inc (hl)		; $5e77
	jr nc,_label_04_235	; $5e78
	jr c,-$60		; $5e7a
	ld (hl),b		; $5e7c
	and b			; $5e7d
	ld (hl),h		; $5e7e
	nop			; $5e7f
	nop			; $5e80
	nop			; $5e81
	dec (hl)		; $5e82
	ld sp,$3935		; $5e83
	and b			; $5e86
	ld (hl),c		; $5e87
	and b			; $5e88
	ld (hl),l		; $5e89
	nop			; $5e8a
	nop			; $5e8b
	ld (hl),$32		; $5e8c
	ld (hl),$3a		; $5e8e
	and b			; $5e90
	ld (hl),d		; $5e91
	and b			; $5e92
	halt			; $5e93
	nop			; $5e94
	nop			; $5e95
	scf			; $5e96
	inc sp			; $5e97
	scf			; $5e98
	dec sp			; $5e99
	and b			; $5e9a
	ld (hl),e		; $5e9b
	and b			; $5e9c
	ld (hl),a		; $5e9d
	nop			; $5e9e
	rst $20			; $5e9f
	pop bc			; $5ea0
	ld ($ff00+$c6),a	; $5ea1
	ld ($ff00+$c2),a	; $5ea3
	ld ($ff00+$e3),a	; $5ea5
	and $c5			; $5ea7
	rst $20			; $5ea9
	set 5,b			; $5eaa
	ld ($ff00+c),a		; $5eac
	nop			; $5ead
_label_04_235:
	nop			; $5eae
	nop			; $5eaf
	and b			; $5eb0
	ld e,$44		; $5eb1
	ld b,d			; $5eb3
	ld b,l			; $5eb4
	ld b,e			; $5eb5
	ld b,(hl)		; $5eb6
	ld b,b			; $5eb7
	ld b,a			; $5eb8
	ld b,c			; $5eb9
	ld b,l			; $5eba
	adc l			; $5ebb
	nop			; $5ebc
	ld a,($cc55)		; $5ebd
	inc a			; $5ec0
	ret z			; $5ec1
	ld bc,$cfae		; $5ec2
_label_04_236:
	ld a,(bc)		; $5ec5
	push bc			; $5ec6
	sub $78			; $5ec7
	cp $08			; $5ec9
	call c,$5ed3		; $5ecb
	pop bc			; $5ece
	dec c			; $5ecf
	jr nz,_label_04_236	; $5ed0
	ret			; $5ed2
	ld de,$5f43		; $5ed3
	call addDoubleIndexToDe		; $5ed6
	ld a,(de)		; $5ed9
	ldh (<hFF8B),a	; $5eda
	inc de			; $5edc
	ld a,(de)		; $5edd
	ld e,a			; $5ede
	ld a,($cd00)		; $5edf
	and $08			; $5ee2
	jr z,_label_04_242	; $5ee4
	ld a,($cc48)		; $5ee6
	ld h,a			; $5ee9
	ld a,($cd02)		; $5eea
	xor $02			; $5eed
	ld d,a			; $5eef
	ld a,e			; $5ef0
	and $03			; $5ef1
	cp d			; $5ef3
	ret nz			; $5ef4
	ld a,($cd02)		; $5ef5
	bit 0,a			; $5ef8
	jr nz,_label_04_238	; $5efa
	and $02			; $5efc
	ld l,$0d		; $5efe
	ld a,(hl)		; $5f00
	jr nz,_label_04_237	; $5f01
	and $f0			; $5f03
	swap a			; $5f05
	or $a0			; $5f07
	jr _label_04_240		; $5f09
_label_04_237:
	and $f0			; $5f0b
	swap a			; $5f0d
	jr _label_04_240		; $5f0f
_label_04_238:
	and $02			; $5f11
	ld l,$0b		; $5f13
	ld a,(hl)		; $5f15
	jr nz,_label_04_239	; $5f16
	and $f0			; $5f18
	jr _label_04_240		; $5f1a
_label_04_239:
	and $f0			; $5f1c
	or $0e			; $5f1e
_label_04_240:
	cp c			; $5f20
	jr nz,_label_04_242	; $5f21
	push bc			; $5f23
	ld c,a			; $5f24
	ld a,(bc)		; $5f25
	sub $78			; $5f26
	cp $08			; $5f28
	jr nc,_label_04_241	; $5f2a
	ldh a,(<hFF8B)	; $5f2c
	ld (bc),a		; $5f2e
_label_04_241:
	pop bc			; $5f2f
_label_04_242:
	ld a,e			; $5f30
	bit 7,a			; $5f31
	ret nz			; $5f33
	and $7f			; $5f34
	ld e,a			; $5f36
	call getFreeInteractionSlot		; $5f37
	ret nz			; $5f3a
	ld (hl),$1e		; $5f3b
	inc l			; $5f3d
	ld (hl),e		; $5f3e
	ld l,$4b		; $5f3f
	ld (hl),c		; $5f41
	ret			; $5f42
	and b			; $5f43
	add b			; $5f44
	and b			; $5f45
	add c			; $5f46
	and b			; $5f47
	add d			; $5f48
	and b			; $5f49
	add e			; $5f4a
	ld e,(hl)		; $5f4b
	inc c			; $5f4c
	ld e,l			; $5f4d
	dec c			; $5f4e
	ld e,(hl)		; $5f4f
	ld c,$5d		; $5f50
	rrca			; $5f52
	call getThisRoomFlags		; $5f53
	bit 5,a			; $5f56
	ret z			; $5f58
	call getChestData		; $5f59
	ld d,$cf		; $5f5c
	ld a,$f0		; $5f5e
	ld (de),a		; $5f60
	ret			; $5f61
	ld hl,$5f90		; $5f62
	ld a,($cc49)		; $5f65
	sub $04			; $5f68
	jr z,_label_04_243	; $5f6a
	dec a			; $5f6c
	ret nz			; $5f6d
	ld hl,$5fd1		; $5f6e
_label_04_243:
	ld a,($cc4c)		; $5f71
	ld b,a			; $5f74
	ld a,($cc32)		; $5f75
	ld c,a			; $5f78
	ld d,$cf		; $5f79
_label_04_244:
	ldi a,(hl)		; $5f7b
	or a			; $5f7c
	ret z			; $5f7d
	cp b			; $5f7e
	jr nz,_label_04_245	; $5f7f
	ldi a,(hl)		; $5f81
	and c			; $5f82
	jr z,_label_04_246	; $5f83
	ldi a,(hl)		; $5f85
	ld e,(hl)		; $5f86
	inc hl			; $5f87
	ld (de),a		; $5f88
	jr _label_04_244		; $5f89
_label_04_245:
	inc hl			; $5f8b
_label_04_246:
	inc hl			; $5f8c
	inc hl			; $5f8d
	jr _label_04_244		; $5f8e
	rrca			; $5f90
	ld bc,$330b		; $5f91
	rrca			; $5f94
	ld bc,$745a		; $5f95
	ld l,a			; $5f98
	ld bc,$8c0b		; $5f99
	ld l,a			; $5f9c
	ld bc,$295c		; $5f9d
	ld (hl),b		; $5fa0
	ld (bc),a		; $5fa1
	dec bc			; $5fa2
	jr z,_label_04_249	; $5fa3
	ld (bc),a		; $5fa5
	ld e,e			; $5fa6
	ld d,d			; $5fa7
	ld (hl),b		; $5fa8
	inc b			; $5fa9
	dec bc			; $5faa
	ld e,c			; $5fab
	ld (hl),b		; $5fac
	inc b			; $5fad
	ld e,e			; $5fae
	add h			; $5faf
	halt			; $5fb0
	ld ($170b),sp		; $5fb1
	halt			; $5fb4
	ld ($255d),sp		; $5fb5
	ld a,(hl)		; $5fb8
	stop			; $5fb9
	dec bc			; $5fba
	ld d,(hl)		; $5fbb
	ld a,(hl)		; $5fbc
	stop			; $5fbd
	ld e,h			; $5fbe
	ld h,(hl)		; $5fbf
	and b			; $5fc0
	ld bc,$445e		; $5fc1
	and b			; $5fc4
	ld (bc),a		; $5fc5
	ld e,(hl)		; $5fc6
	scf			; $5fc7
	and b			; $5fc8
	ld bc,$830b		; $5fc9
	and b			; $5fcc
	ld (bc),a		; $5fcd
	dec bc			; $5fce
	ld a,b			; $5fcf
	nop			; $5fd0
	ld a,(hl)		; $5fd1
	ld bc,$2b5c		; $5fd2
	ld a,(hl)		; $5fd5
	ld bc,$780b		; $5fd6
	nop			; $5fd9
	ld a,($cc4c)		; $5fda
	ld b,a			; $5fdd
	call getThisRoomFlags		; $5fde
	ld c,a			; $5fe1
	ld d,$cf		; $5fe2
	ld a,($cc49)		; $5fe4
	ld hl,$6005		; $5fe7
	rst_addDoubleIndex			; $5fea
	ldi a,(hl)		; $5feb
	ld h,(hl)		; $5fec
	ld l,a			; $5fed
_label_04_247:
	ldi a,(hl)		; $5fee
	cp b			; $5fef
	jr nz,_label_04_248	; $5ff0
	ld a,(hl)		; $5ff2
	and c			; $5ff3
	jr z,_label_04_248	; $5ff4
	inc hl			; $5ff6
	ldi a,(hl)		; $5ff7
	ld e,a			; $5ff8
	ldi a,(hl)		; $5ff9
	ld (de),a		; $5ffa
	jr _label_04_247		; $5ffb
_label_04_248:
	ld a,(hl)		; $5ffd
	or a			; $5ffe
	ret z			; $5fff
	inc hl			; $6000
	inc hl			; $6001
	inc hl			; $6002
	jr _label_04_247		; $6003
	dec d			; $6005
	ld h,b			; $6006
	ccf			; $6007
	ld h,b			; $6008
	ld (hl),l		; $6009
	ld h,b			; $600a
	ld (hl),l		; $600b
	ld h,b			; $600c
	ld (hl),l		; $600d
	ld h,b			; $600e
	add e			; $600f
	ld h,b			; $6010
	xor c			; $6011
	ld h,b			; $6012
	xor c			; $6013
	ld h,b			; $6014
_label_04_249:
	sbc d			; $6015
	ld b,b			; $6016
	inc sp			; $6017
	push bc			; $6018
	ld d,d			; $6019
	ld b,b			; $601a
	ld (bc),a		; $601b
	ret nc			; $601c
	ld d,d			; $601d
	ld b,b			; $601e
	ld bc,$526b		; $601f
	ld b,b			; $6022
	inc bc			; $6023
	ld b,l			; $6024
	jp hl			; $6025
	ld bc,$0448		; $6026
	jp hl			; $6029
	ld (bc),a		; $602a
	ld e,b			; $602b
	inc b			; $602c
	ld bc,$6680		; $602d
	inc b			; $6030
	ld bc,$6580		; $6031
	sbc h			; $6034
	ld bc,$6640		; $6035
	inc b			; $6038
	ld bc,$6740		; $6039
	sbc h			; $603c
	nop			; $603d
	nop			; $603e
	ld a,(bc)		; $603f
	add b			; $6040
	ldd (hl),a		; $6041
	pop hl			; $6042
	ld a,(bc)		; $6043
	add b			; $6044
	inc sp			; $6045
	pop hl			; $6046
	ld a,(bc)		; $6047
	add b			; $6048
	inc (hl)		; $6049
	pop hl			; $604a
	ld ($5340),sp		; $604b
	add sp,$12		; $604e
	ld b,b			; $6050
	ld e,b			; $6051
	add sp,$35		; $6052
	ld b,b			; $6054
	ld b,(hl)		; $6055
	add sp,$13		; $6056
	ld bc,$0425		; $6058
	ld b,d			; $605b
	ld bc,$0657		; $605c
	ld b,h			; $605f
	ld bc,$0656		; $6060
	ld c,b			; $6063
	ld bc,$0435		; $6064
	ld d,l			; $6067
	ld bc,fillMemoryBc		; $6068
	ld d,l			; $606b
	ld (bc),a		; $606c
	ld h,d			; $606d
	inc b			; $606e
	ld l,c			; $606f
	jr nz,_label_04_250	; $6070
	pop hl			; $6072
	nop			; $6073
	nop			; $6074
	add hl,sp		; $6075
	add b			; $6076
	rlca			; $6077
	and b			; $6078
	add hl,sp		; $6079
	add b			; $607a
	inc h			; $607b
	add hl,bc		; $607c
	add hl,sp		; $607d
	add b			; $607e
	ldi a,(hl)		; $607f
	add hl,bc		; $6080
	nop			; $6081
	nop			; $6082
	ld a,($ff00+$40)	; $6083
	ld (hl),a		; $6085
	ld l,d			; $6086
	cp h			; $6087
	jr nz,_label_04_251	; $6088
	ld d,e			; $608a
	ld a,$80		; $608b
	ld e,h			; $608d
	dec b			; $608e
	ld (hl),e		; $608f
	add b			; $6090
	ld b,l			; $6091
	and b			; $6092
	ld (hl),e		; $6093
	add b			; $6094
	inc (hl)		; $6095
	ld h,$99		; $6096
	add b			; $6098
	sbc l			; $6099
_label_04_250:
	ld b,h			; $609a
	sbc d			; $609b
	add b			; $609c
	ld h,(hl)		; $609d
	ld b,l			; $609e
	sbc (hl)		; $609f
	add b			; $60a0
	sbc l			; $60a1
	ld b,h			; $60a2
	daa			; $60a3
	add b			; $60a4
	ld d,a			; $60a5
	ld c,a			; $60a6
	nop			; $60a7
	nop			; $60a8
	nop			; $60a9
	nop			; $60aa
	ld a,($cc4c)		; $60ab
	ld hl,$6114		; $60ae
	call findRoomSpecificData		; $60b1
_label_04_251:
	ret nc			; $60b4
	rst_jumpTable			; $60b5
	sub l			; $60b6
	ld h,c			; $60b7
	sbc a			; $60b8
	ld h,c			; $60b9
	dec d			; $60ba
	ld h,d			; $60bb
	jr nc,_label_04_252	; $60bc
	ld d,b			; $60be
	ld h,d			; $60bf
	ld hl,$6862		; $60c0
	ld h,d			; $60c3
	ld e,h			; $60c4
	ld h,d			; $60c5
	adc c			; $60c6
	ld h,c			; $60c7
	ld (hl),a		; $60c8
	ld h,d			; $60c9
	or c			; $60ca
	ld h,e			; $60cb
	ld ($ff00+$62),a	; $60cc
	add h			; $60ce
	ld h,e			; $60cf
	or c			; $60d0
	ld h,e			; $60d1
	or c			; $60d2
	ld h,e			; $60d3
	sub $63			; $60d4
	ld a,($ff00+c)		; $60d6
	ld h,e			; $60d7
	cp $63			; $60d8
	ld a,(bc)		; $60da
	ld h,h			; $60db
	dec l			; $60dc
	ld h,h			; $60dd
	ld c,c			; $60de
	ld h,h			; $60df
	ld e,e			; $60e0
	ld h,h			; $60e1
	ld l,l			; $60e2
	ld h,h			; $60e3
	adc c			; $60e4
	ld h,h			; $60e5
	or d			; $60e6
	ld h,h			; $60e7
	jp nz,$fb64		; $60e8
	ld h,h			; $60eb
	inc b			; $60ec
	ld h,l			; $60ed
	ld hl,$2b64		; $60ee
	ld h,(hl)		; $60f1
	or h			; $60f2
	ld h,c			; $60f3
	di			; $60f4
	ld h,c			; $60f5
	ld d,$65		; $60f6
	ld e,(hl)		; $60f8
	ld h,l			; $60f9
	adc c			; $60fa
	ld h,l			; $60fb
	and a			; $60fc
	ld h,l			; $60fd
	or l			; $60fe
	ld h,l			; $60ff
	jp $d265		; $6100
	ld h,c			; $6103
	ei			; $6104
	ld h,l			; $6105
	rlca			; $6106
	ld h,(hl)		; $6107
	add $61			; $6108
	ld (hl),e		; $610a
	ld h,(hl)		; $610b
	ldd a,(hl)		; $610c
	ld h,(hl)		; $610d
	dec c			; $610e
	ld h,l			; $610f
	ld a,($ff00+c)		; $6110
	ld h,h			; $6111
	jp hl			; $6112
	ld h,h			; $6113
	inc h			; $6114
	ld h,c			; $6115
	ld d,c			; $6116
	ld h,c			; $6117
	ld e,b			; $6118
	ld h,c			; $6119
	ld e,b			; $611a
	ld h,c			; $611b
	ld h,c			; $611c
	ld h,c			; $611d
	ld l,(hl)		; $611e
	ld h,c			; $611f
_label_04_252:
	add a			; $6120
	ld h,c			; $6121
	add a			; $6122
	ld h,c			; $6123
	push bc			; $6124
	nop			; $6125
	reti			; $6126
	ld bc,$1054		; $6127
	ld a,a			; $612a
	ld de,$1262		; $612b
	ld h,b			; $612e
	inc de			; $612f
	ld h,c			; $6130
	inc d			; $6131
	ld (hl),b		; $6132
	dec d			; $6133
	ld (hl),c		; $6134
	ld d,$81		; $6135
	rla			; $6137
	dec c			; $6138
	jr _label_04_253		; $6139
	add hl,de		; $613b
	ld h,e			; $613c
	ld e,$e4		; $613d
	ld h,$f4		; $613f
	rra			; $6141
	ld l,a			; $6142
	jr nz,_label_04_254	; $6143
	ld hl,$22fc		; $6145
	xor $25			; $6148
	ld d,(hl)		; $614a
	jr z,_label_04_255	; $614b
	dec e			; $614d
	or $08			; $614e
	nop			; $6150
	dec (hl)		; $6151
	daa			; $6152
	ld h,h			; $6153
	inc hl			; $6154
	ld (hl),h		; $6155
	inc h			; $6156
	nop			; $6157
_label_04_253:
	and h			; $6158
	add hl,hl		; $6159
	xor e			; $615a
	ldi a,(hl)		; $615b
	or b			; $615c
	inc bc			; $615d
	or l			; $615e
	inc e			; $615f
	nop			; $6160
	ld h,c			; $6161
	ld l,$78		; $6162
	ld (bc),a		; $6164
	ld l,$04		; $6165
	ld h,h			; $6167
	dec b			; $6168
	adc c			; $6169
	ld b,$bb		; $616a
	rlca			; $616c
	nop			; $616d
	dec sp			; $616e
	dec l			; $616f
	ld h,l			; $6170
	add hl,bc		; $6171
	ld h,(hl)		; $6172
	ld a,(bc)		; $6173
	ld h,a			; $6174
	dec bc			; $6175
	ld l,b			; $6176
	inc c			; $6177
	ld l,d			; $6178
	dec c			; $6179
	ld l,e			; $617a
	ld c,$86		; $617b
	rrca			; $617d
	ld a,d			; $617e
	ld a,(de)		; $617f
	ld a,b			; $6180
	dec de			; $6181
	adc (hl)		; $6182
	inc l			; $6183
	sbc (hl)		; $6184
	dec hl			; $6185
	nop			; $6186
_label_04_254:
	nop			; $6187
	ret			; $6188
	ld a,$28		; $6189
	call checkGlobalFlag		; $618b
	ret z			; $618e
	ld hl,$cf33		; $618f
	ld (hl),$f2		; $6192
	ret			; $6194
	ldh a,(<hGameboyType)	; $6195
	rlca			; $6197
_label_04_255:
	ret nc			; $6198
	ld hl,$cf14		; $6199
	ld (hl),$ea		; $619c
	ret			; $619e
	call getThisRoomFlags		; $619f
	bit 7,(hl)		; $61a2
	ret z			; $61a4
	ld hl,$cf14		; $61a5
	ld a,$bf		; $61a8
	ldi (hl),a		; $61aa
	ld (hl),a		; $61ab
	ld l,$24		; $61ac
	ld a,$a9		; $61ae
	ldi (hl),a		; $61b0
	inc a			; $61b1
	ld (hl),a		; $61b2
	ret			; $61b3
	call getThisRoomFlags		; $61b4
	bit 7,(hl)		; $61b7
	ret z			; $61b9
	ld hl,$cf14		; $61ba
	ld a,$ad		; $61bd
	ldi (hl),a		; $61bf
	ld (hl),a		; $61c0
	ld l,$24		; $61c1
	ldi (hl),a		; $61c3
	ld (hl),a		; $61c4
	ret			; $61c5
	call getThisRoomFlags		; $61c6
	and $40			; $61c9
	ret z			; $61cb
	ld hl,$cf36		; $61cc
	ld (hl),$09		; $61cf
	ret			; $61d1
	call getThisRoomFlags		; $61d2
	and $40			; $61d5
	jr z,_label_04_256	; $61d7
	ld hl,$cf77		; $61d9
	ld (hl),$a1		; $61dc
	ret			; $61de
_label_04_256:
	ld hl,$61ee		; $61df
	ld d,$cf		; $61e2
_label_04_257:
	ldi a,(hl)		; $61e4
	or a			; $61e5
	ret z			; $61e6
	ld e,a			; $61e7
	ldi a,(hl)		; $61e8
	ld (de),a		; $61e9
	inc e			; $61ea
	ld (de),a		; $61eb
	jr _label_04_257		; $61ec
	ld h,l			; $61ee
.DB $fd				; $61ef
	ld (hl),l		; $61f0
.DB $fd				; $61f1
	nop			; $61f2
	call getThisRoomFlags		; $61f3
	bit 6,(hl)		; $61f6
	ret z			; $61f8
	bit 5,(hl)		; $61f9
	jr nz,_label_04_258	; $61fb
	ld hl,$cf45		; $61fd
	ld (hl),$f1		; $6200
_label_04_258:
	ld hl,$cf22		; $6202
	ld (hl),$0f		; $6205
	inc l			; $6207
	ld (hl),$11		; $6208
	ld l,$32		; $620a
	ld (hl),$11		; $620c
	inc l			; $620e
	ld (hl),$0f		; $620f
	inc l			; $6211
	ld (hl),$11		; $6212
	ret			; $6214
	call getThisRoomFlags		; $6215
	bit 7,(hl)		; $6218
	ret nz			; $621a
	ld hl,$cf39		; $621b
	ld (hl),$b0		; $621e
	ret			; $6220
	call getThisRoomFlags		; $6221
	bit 7,(hl)		; $6224
	ret z			; $6226
	ld de,$622d		; $6227
	jp $5dc7		; $622a
	add hl,bc		; $622d
	ld ($fa00),sp		; $622e
	ccf			; $6231
	add $e6			; $6232
	rrca			; $6234
	cp $0f			; $6235
	ret nz			; $6237
	ld hl,$624c		; $6238
	call $669d		; $623b
	ld a,$f1		; $623e
	ld hl,$cf25		; $6240
	ld (hl),a		; $6243
	ld l,$27		; $6244
	ld (hl),a		; $6246
	ld l,$32		; $6247
	ld (hl),$a0		; $6249
	ret			; $624b
	inc de			; $624c
	inc bc			; $624d
	ld b,$a0		; $624e
	ld hl,$cf23		; $6250
	ld bc,$0808		; $6253
	ld de,$c8f0		; $6256
	jp $66b7		; $6259
	ld hl,$cf34		; $625c
	ld bc,$0808		; $625f
	ld de,$c8f8		; $6262
	jp $66b7		; $6265
	call getThisRoomFlags		; $6268
	bit 5,(hl)		; $626b
	ret z			; $626d
	ld de,$6274		; $626e
	jp $5dc7		; $6271
	ld a,($ff00+$25)	; $6274
	nop			; $6276
	call getThisRoomFlags		; $6277
	bit 6,(hl)		; $627a
	jr z,_label_04_259	; $627c
	call $63cb		; $627e
	ld hl,$6294		; $6281
	call $6690		; $6284
_label_04_259:
	call getThisRoomFlags		; $6287
	inc l			; $628a
	bit 6,(hl)		; $628b
	ret z			; $628d
	ld hl,$62c8		; $628e
	jp $6690		; $6291
	rst_addAToHl			; $6294
	ld de,$1817		; $6295
	ld hl,$2827		; $6298
	ld sp,$4137		; $629b
	ld b,d			; $629e
	ld b,e			; $629f
	ld b,h			; $62a0
	ld b,l			; $62a1
	ld b,(hl)		; $62a2
	ld b,a			; $62a3
	ld d,c			; $62a4
	ld d,d			; $62a5
	ld d,e			; $62a6
	ld d,l			; $62a7
	ld h,c			; $62a8
	ld h,d			; $62a9
	ld h,h			; $62aa
	ld h,(hl)		; $62ab
	ld h,a			; $62ac
	ld l,b			; $62ad
	ld (hl),c		; $62ae
	ld (hl),d		; $62af
	ld (hl),e		; $62b0
	ld (hl),h		; $62b1
	ld (hl),l		; $62b2
	halt			; $62b3
	ld (hl),a		; $62b4
	add c			; $62b5
	add d			; $62b6
	add e			; $62b7
	add h			; $62b8
	add l			; $62b9
	add (hl)		; $62ba
	add a			; $62bb
	sub c			; $62bc
	sub d			; $62bd
	sub h			; $62be
	sub l			; $62bf
	sub (hl)		; $62c0
	and c			; $62c1
	and d			; $62c2
	and e			; $62c3
	and h			; $62c4
	and l			; $62c5
	and (hl)		; $62c6
	rst $38			; $62c7
	rst_addAToHl			; $62c8
	ld l,l			; $62c9
	ld l,(hl)		; $62ca
	ld a,h			; $62cb
	ld a,l			; $62cc
	ld a,(hl)		; $62cd
	adc d			; $62ce
	adc e			; $62cf
	adc h			; $62d0
	adc l			; $62d1
	adc (hl)		; $62d2
	sbc c			; $62d3
	sbc d			; $62d4
	sbc e			; $62d5
	sbc h			; $62d6
	sbc l			; $62d7
	sbc (hl)		; $62d8
	xor c			; $62d9
	xor d			; $62da
	xor e			; $62db
	xor h			; $62dc
	xor l			; $62dd
	xor (hl)		; $62de
	rst $38			; $62df
	ld a,$65		; $62e0
	call getARoomFlags		; $62e2
	bit 6,(hl)		; $62e5
	jr z,_label_04_260	; $62e7
	ld hl,$630c		; $62e9
	call $6690		; $62ec
_label_04_260:
	ld a,$66		; $62ef
	call getARoomFlags		; $62f1
	bit 6,(hl)		; $62f4
	jr z,_label_04_261	; $62f6
	ld hl,$632d		; $62f8
	call $6690		; $62fb
_label_04_261:
	ld a,$6a		; $62fe
	call getARoomFlags		; $6300
	bit 6,(hl)		; $6303
	ret z			; $6305
	ld hl,$6340		; $6306
	jp $6690		; $6309
	rst_addAToHl			; $630c
	ld bc,$0302		; $630d
	inc b			; $6310
	dec b			; $6311
	ld b,$11		; $6312
	ld (de),a		; $6314
	inc de			; $6315
	inc d			; $6316
	dec d			; $6317
	ld d,$21		; $6318
	ldi (hl),a		; $631a
	inc hl			; $631b
	ld sp,$3332		; $631c
	ld b,c			; $631f
	ld b,d			; $6320
	ld b,e			; $6321
	ld d,c			; $6322
	ld d,d			; $6323
	ld d,e			; $6324
	ld h,c			; $6325
	ld h,d			; $6326
	ld h,e			; $6327
	ld h,h			; $6328
	ld (hl),c		; $6329
	ld (hl),d		; $632a
	ld (hl),e		; $632b
	rst $38			; $632c
	rst_addAToHl			; $632d
	add hl,bc		; $632e
	ld a,(bc)		; $632f
	dec bc			; $6330
	inc c			; $6331
	dec c			; $6332
	ld c,$19		; $6333
	ld a,(de)		; $6335
	dec de			; $6336
	inc e			; $6337
	dec e			; $6338
	ld e,$2a		; $6339
	dec hl			; $633b
	dec l			; $633c
	ld l,$3e		; $633d
	rst $38			; $633f
	rst_addAToHl			; $6340
	dec h			; $6341
	ld h,$27		; $6342
	dec (hl)		; $6344
	ld (hl),$37		; $6345
	jr c,_label_04_262	; $6347
	ld b,l			; $6349
	ld b,(hl)		; $634a
	ld b,a			; $634b
	ld c,b			; $634c
	ld c,c			; $634d
	ld d,l			; $634e
	ld d,(hl)		; $634f
	ld d,a			; $6350
	ld e,b			; $6351
	ld e,c			; $6352
	ld h,(hl)		; $6353
	ld h,a			; $6354
	ld l,b			; $6355
	ld l,c			; $6356
	ld l,d			; $6357
	ld (hl),l		; $6358
	halt			; $6359
	ld (hl),a		; $635a
	ld a,b			; $635b
	ld a,c			; $635c
	ld a,d			; $635d
	add c			; $635e
	add d			; $635f
	add e			; $6360
	add h			; $6361
	add l			; $6362
	add (hl)		; $6363
	add a			; $6364
	adc b			; $6365
	adc c			; $6366
	adc d			; $6367
	adc e			; $6368
	sub c			; $6369
	sub d			; $636a
	sub e			; $636b
	sub h			; $636c
	sub l			; $636d
	sub (hl)		; $636e
	sub a			; $636f
	sbc b			; $6370
	sbc c			; $6371
	sbc d			; $6372
	sbc e			; $6373
	sbc h			; $6374
	sbc l			; $6375
	and c			; $6376
	and d			; $6377
	and e			; $6378
	and h			; $6379
	and l			; $637a
	and (hl)		; $637b
	and a			; $637c
	xor b			; $637d
	xor c			; $637e
	xor d			; $637f
	xor e			; $6380
	xor h			; $6381
_label_04_262:
	xor l			; $6382
	rst $38			; $6383
	ld a,$66		; $6384
	call getARoomFlags		; $6386
	bit 6,(hl)		; $6389
	jr z,_label_04_263	; $638b
	ld hl,$cf00		; $638d
	ld b,$70		; $6390
	call $63a2		; $6392
_label_04_263:
	ld a,$6b		; $6395
	call getARoomFlags		; $6397
	bit 6,(hl)		; $639a
	ret z			; $639c
	ld hl,$cf70		; $639d
	ld b,$00		; $63a0
_label_04_264:
	ld a,(hl)		; $63a2
	sub $61			; $63a3
	cp $05			; $63a5
	jr nc,_label_04_265	; $63a7
	ld (hl),$d7		; $63a9
_label_04_265:
	inc l			; $63ab
	ld a,l			; $63ac
	cp b			; $63ad
	jr nz,_label_04_264	; $63ae
	ret			; $63b0
	call getThisRoomFlags		; $63b1
	bit 6,(hl)		; $63b4
	ret z			; $63b6
	call $63cb		; $63b7
	ld de,$63c0		; $63ba
	jp $5dc7		; $63bd
	rst_addAToHl			; $63c0
	ld h,c			; $63c1
	rst_addAToHl			; $63c2
	ld h,d			; $63c3
	rst_addAToHl			; $63c4
	ld h,e			; $63c5
	rst_addAToHl			; $63c6
	ld h,h			; $63c7
	rst_addAToHl			; $63c8
	ld h,l			; $63c9
	nop			; $63ca
	ld de,$63d1		; $63cb
	jp $5dc7		; $63ce
	push de			; $63d1
	call nc,$67d7		; $63d2
	nop			; $63d5
	call getThisRoomFlags		; $63d6
	bit 7,(hl)		; $63d9
	ret z			; $63db
	ld de,$63ef		; $63dc
	call $5dc7		; $63df
	ld hl,$cf4d		; $63e2
	ld a,$2f		; $63e5
	ld (hl),a		; $63e7
	ld l,$5d		; $63e8
	ld (hl),a		; $63ea
	ld l,$6d		; $63eb
	ld (hl),a		; $63ed
	ret			; $63ee
	adc h			; $63ef
	cpl			; $63f0
	nop			; $63f1
	ld a,($c643)		; $63f2
	bit 6,a			; $63f5
	ret z			; $63f7
	ld hl,$cf34		; $63f8
	ld (hl),$f2		; $63fb
	ret			; $63fd
	ld a,($cc4e)		; $63fe
	cp $03			; $6401
	ret nz			; $6403
	ld hl,$cf47		; $6404
	ld (hl),$ea		; $6407
	ret			; $6409
	ld h,$c8		; $640a
	ld l,$b5		; $640c
	bit 6,(hl)		; $640e
	ret nz			; $6410
	ld hl,$641d		; $6411
	call $669d		; $6414
	ld hl,$cf27		; $6417
	ld (hl),$fd		; $641a
	ret			; $641c
	ld h,$02		; $641d
	inc bc			; $641f
	ld a,($56cd)		; $6420
	add hl,de		; $6423
	bit 6,(hl)		; $6424
	ret nz			; $6426
	ld hl,$cf37		; $6427
	ld (hl),$fa		; $642a
	ret			; $642c
	ld a,$81		; $642d
	call getARoomFlags		; $642f
	bit 7,(hl)		; $6432
	ret nz			; $6434
	ld hl,$6441		; $6435
	call $669d		; $6438
	ld hl,$6445		; $643b
	jp $669d		; $643e
	inc h			; $6441
	ld b,$03		; $6442
.DB $fd				; $6444
	ld b,a			; $6445
	inc b			; $6446
	inc bc			; $6447
.DB $fd				; $6448
	ld a,$81		; $6449
	call getARoomFlags		; $644b
	bit 7,(hl)		; $644e
	ret nz			; $6450
	ld hl,$6457		; $6451
	jp $669d		; $6454
	ld b,b			; $6457
	inc b			; $6458
	rlca			; $6459
.DB $fd				; $645a
	ld a,$81		; $645b
	call getARoomFlags		; $645d
	bit 7,(hl)		; $6460
	ret nz			; $6462
	ld hl,$6469		; $6463
	jp $669d		; $6466
	inc b			; $6469
	inc b			; $646a
	ld b,$fd		; $646b
	ld a,$81		; $646d
	call getARoomFlags		; $646f
	bit 7,(hl)		; $6472
	ret nz			; $6474
	ld hl,$6481		; $6475
	call $669d		; $6478
	ld hl,$6485		; $647b
	jp $669d		; $647e
	nop			; $6481
	inc b			; $6482
	rlca			; $6483
.DB $fd				; $6484
	ld b,h			; $6485
	inc b			; $6486
	inc bc			; $6487
.DB $fd				; $6488
	call getThisRoomFlags		; $6489
	bit 7,(hl)		; $648c
	jr nz,_label_04_266	; $648e
	ld hl,$64a6		; $6490
	jp $669d		; $6493
_label_04_266:
	ld hl,$64ae		; $6496
	ld a,($cc4e)		; $6499
	cp $03			; $649c
	jr z,_label_04_267	; $649e
	ld hl,$64aa		; $64a0
_label_04_267:
	jp $669d		; $64a3
	inc b			; $64a6
	ld bc,$fd03		; $64a7
	inc d			; $64aa
	ld bc,$fa03		; $64ab
	inc d			; $64ae
	ld bc,$dc03		; $64af
	call getThisRoomFlags		; $64b2
	bit 7,(hl)		; $64b5
	ret nz			; $64b7
	ld hl,$64be		; $64b8
	jp $669d		; $64bb
	ld h,d			; $64be
	ld (bc),a		; $64bf
	inc bc			; $64c0
	rst $38			; $64c1
	call getThisRoomFlags		; $64c2
	bit 7,(hl)		; $64c5
	ret nz			; $64c7
	ld hl,$64d9		; $64c8
	call $669d		; $64cb
	ld l,$13		; $64ce
	ld a,$fe		; $64d0
	ld (hl),a		; $64d2
	ld l,$22		; $64d3
	ldi (hl),a		; $64d5
	ldi (hl),a		; $64d6
	ld (hl),a		; $64d7
	ret			; $64d8
	ld (bc),a		; $64d9
	inc bc			; $64da
	inc bc			; $64db
	rst $38			; $64dc
	ret			; $64dd
_label_04_268:
	call getThisRoomFlags		; $64de
	bit 7,(hl)		; $64e1
	ret z			; $64e3
	ld h,b			; $64e4
	ld l,c			; $64e5
	jp $669d		; $64e6
	ld bc,$64ee		; $64e9
	jr _label_04_268		; $64ec
	ld e,c			; $64ee
	ld bc,$6d03		; $64ef
	ld bc,$64f7		; $64f2
	jr _label_04_268		; $64f5
	ld (hl),a		; $64f7
	ld bc,$6d04		; $64f8
	ld bc,$6500		; $64fb
	jr _label_04_268		; $64fe
	inc a			; $6500
	ld b,$01		; $6501
	ld l,d			; $6503
	ld bc,$6509		; $6504
	jr _label_04_268		; $6507
	add d			; $6509
	ld bc,$6d07		; $650a
	ld bc,$6512		; $650d
	jr _label_04_268		; $6510
	dec de			; $6512
	rlca			; $6513
	ld bc,$cd6a		; $6514
	ld d,(hl)		; $6517
	add hl,de		; $6518
	and $c0			; $6519
	ret z			; $651b
	ld de,$6555		; $651c
	ld a,$12		; $651f
	call checkGlobalFlag		; $6521
	jr nz,_label_04_270	; $6524
	ld a,($cc69)		; $6526
	bit 1,a			; $6529
	jr nz,_label_04_269	; $652b
	ld de,$654c		; $652d
	jr _label_04_270		; $6530
_label_04_269:
	ld a,$12		; $6532
	call setGlobalFlag		; $6534
_label_04_270:
	ld hl,$cf36		; $6537
	ld b,$03		; $653a
_label_04_271:
	ld c,$03		; $653c
_label_04_272:
	ld a,(de)		; $653e
	inc de			; $653f
	ldi (hl),a		; $6540
	dec c			; $6541
	jr nz,_label_04_272	; $6542
	ld a,$0d		; $6544
	add l			; $6546
	ld l,a			; $6547
	dec b			; $6548
	jr nz,_label_04_271	; $6549
	ret			; $654b
.DB $fd				; $654c
.DB $fd				; $654d
.DB $fc				; $654e
	ei			; $654f
.DB $fd				; $6550
.DB $fc				; $6551
.DB $fd				; $6552
	ei			; $6553
.DB $fd				; $6554
	xor b			; $6555
.DB $eb				; $6556
	and l			; $6557
	or e			; $6558
	or h			; $6559
	or l			; $655a
	and e			; $655b
	xor $a4			; $655c
	ld hl,$cf44		; $655e
	ld (hl),$9c		; $6561
	call getThisRoomFlags		; $6563
	and $80			; $6566
	jr z,_label_04_273	; $6568
	ld hl,$cf55		; $656a
	ld (hl),$bc		; $656d
	jr _label_04_274		; $656f
_label_04_273:
	ld hl,$cf54		; $6571
	ld (hl),$d6		; $6574
_label_04_274:
	call getThisRoomFlags		; $6576
	and $40			; $6579
	jr z,_label_04_275	; $657b
	ld hl,$cf65		; $657d
	ld (hl),$bc		; $6580
	ret			; $6582
_label_04_275:
	ld hl,$cf64		; $6583
	ld (hl),$d6		; $6586
	ret			; $6588
	call getThisRoomFlags		; $6589
	bit 7,(hl)		; $658c
	ret z			; $658e
	ld hl,$cf03		; $658f
	ld a,$af		; $6592
	ldi (hl),a		; $6594
	ldi (hl),a		; $6595
	ldi (hl),a		; $6596
	ld (hl),a		; $6597
	ld a,$0d		; $6598
	rst_addAToHl			; $659a
	ld a,$af		; $659b
	ldi (hl),a		; $659d
	ldi (hl),a		; $659e
	ldi (hl),a		; $659f
	ld (hl),a		; $65a0
	ret			; $65a1
	ld a,$17		; $65a2
	jp checkGlobalFlag		; $65a4
	call $65a2		; $65a7
	ret z			; $65aa
	ld hl,$65b1		; $65ab
	jp $669d		; $65ae
	ld b,h			; $65b1
	inc b			; $65b2
	dec b			; $65b3
	rrca			; $65b4
	call $65a2		; $65b5
	ret z			; $65b8
	ld hl,$65bf		; $65b9
	jp $669d		; $65bc
	inc b			; $65bf
	inc b			; $65c0
	dec b			; $65c1
	rrca			; $65c2
	call $65a2		; $65c3
	ret z			; $65c6
	ld hl,$65e2		; $65c7
	ld de,$cf23		; $65ca
	ld bc,$0505		; $65cd
_label_04_276:
	push de			; $65d0
	push bc			; $65d1
_label_04_277:
	ldi a,(hl)		; $65d2
	ld (de),a		; $65d3
	inc e			; $65d4
	dec b			; $65d5
	jr nz,_label_04_277	; $65d6
	pop bc			; $65d8
	pop de			; $65d9
	ld a,e			; $65da
	add $10			; $65db
	ld e,a			; $65dd
	dec c			; $65de
	jr nz,_label_04_276	; $65df
	ret			; $65e1
	xor a			; $65e2
	xor a			; $65e3
	xor a			; $65e4
	xor a			; $65e5
	xor a			; $65e6
	xor l			; $65e7
	xor l			; $65e8
	xor (hl)		; $65e9
	xor (hl)		; $65ea
	xor a			; $65eb
	xor l			; $65ec
	xor l			; $65ed
	xor (hl)		; $65ee
	xor (hl)		; $65ef
	xor a			; $65f0
	cp l			; $65f1
	cp l			; $65f2
	cp (hl)			; $65f3
	cp (hl)			; $65f4
	xor a			; $65f5
	cp l			; $65f6
	cp l			; $65f7
	cp (hl)			; $65f8
	cp (hl)			; $65f9
	xor a			; $65fa
	ld a,($c9f9)		; $65fb
	and $04			; $65fe
	ret z			; $6600
	ld hl,$cf43		; $6601
	ld (hl),$e8		; $6604
	ret			; $6606
	xor a			; $6607
	ld ($cc32),a		; $6608
	ld a,($c610)		; $660b
	cp $0c			; $660e
	ret z			; $6610
	call getThisRoomFlags		; $6611
	and $40			; $6614
	jr nz,_label_04_278	; $6616
	ld a,$fd		; $6618
	ld hl,$cf43		; $661a
	ldi (hl),a		; $661d
	ld (hl),a		; $661e
	ld hl,$cf53		; $661f
	ldi (hl),a		; $6622
	ld (hl),a		; $6623
	ret			; $6624
_label_04_278:
	ld a,$b0		; $6625
	ld ($cf66),a		; $6627
	ret			; $662a
	ld a,$16		; $662b
	call checkGlobalFlag		; $662d
	ret z			; $6630
	ld hl,$cf73		; $6631
	ld a,$40		; $6634
	ldi (hl),a		; $6636
	ldi (hl),a		; $6637
	ld (hl),a		; $6638
	ret			; $6639
	ld a,($ccc4)		; $663a
	or a			; $663d
	ret z			; $663e
	dec a			; $663f
	jr z,_label_04_281	; $6640
	dec a			; $6642
	jr z,_label_04_280	; $6643
	dec a			; $6645
	jr z,_label_04_279	; $6646
	xor a			; $6648
	ld ($ccc4),a		; $6649
	ld hl,$6652		; $664c
	jp $669d		; $664f
	nop			; $6652
	dec bc			; $6653
	rrca			; $6654
	xor d			; $6655
_label_04_279:
	ld ($ccc4),a		; $6656
	ld a,$b9		; $6659
	jp loadGfxHeader		; $665b
_label_04_280:
	ld ($ccc4),a		; $665e
	ld hl,$6667		; $6661
	jp $669d		; $6664
	ld de,$0d09		; $6667
	adc h			; $666a
_label_04_281:
	ld ($ccc4),a		; $666b
	ld a,$b8		; $666e
	jp loadGfxHeader		; $6670
	call getThisRoomFlags		; $6673
	and $40			; $6676
	ret z			; $6678
	ld hl,$cf14		; $6679
	ld a,$6d		; $667c
	ldi (hl),a		; $667e
	ldi (hl),a		; $667f
	ld (hl),a		; $6680
	ld a,$6a		; $6681
	ld l,$47		; $6683
	ld (hl),a		; $6685
	ld l,$37		; $6686
	ld (hl),a		; $6688
	ld l,$27		; $6689
	ld (hl),a		; $668b
	ld l,$17		; $668c
	ld (hl),a		; $668e
	ret			; $668f
	ld d,$cf		; $6690
	ldi a,(hl)		; $6692
	ld c,a			; $6693
_label_04_282:
	ldi a,(hl)		; $6694
	cp $ff			; $6695
	ret z			; $6697
	ld e,a			; $6698
	ld a,c			; $6699
	ld (de),a		; $669a
	jr _label_04_282		; $669b
	ldi a,(hl)		; $669d
	ld e,a			; $669e
	ldi a,(hl)		; $669f
	ld b,a			; $66a0
	ldi a,(hl)		; $66a1
	ld c,a			; $66a2
	ldi a,(hl)		; $66a3
	ld d,a			; $66a4
	ld h,$cf		; $66a5
_label_04_283:
	ld a,d			; $66a7
	ld l,e			; $66a8
	push bc			; $66a9
_label_04_284:
	ldi (hl),a		; $66aa
	dec c			; $66ab
	jr nz,_label_04_284	; $66ac
	ld a,e			; $66ae
	add $10			; $66af
	ld e,a			; $66b1
	pop bc			; $66b2
	dec b			; $66b3
	jr nz,_label_04_283	; $66b4
	ret			; $66b6
_label_04_285:
	ld a,(de)		; $66b7
	inc de			; $66b8
	push bc			; $66b9
_label_04_286:
	rrca			; $66ba
	jr nc,_label_04_287	; $66bb
	ld (hl),$a0		; $66bd
_label_04_287:
	inc l			; $66bf
	dec b			; $66c0
	jr nz,_label_04_286	; $66c1
	ld a,l			; $66c3
	add $08			; $66c4
	ld l,a			; $66c6
	pop bc			; $66c7
	dec c			; $66c8
	jr nz,_label_04_285	; $66c9
	ret			; $66cb


.include "code/seasons/roomGfxChanges.s"


;;
; @addr{6ae4}
generateW3VramTilesAndAttributes:
	ld a,$03		; $6ae4
	ld ($ff00+$70),a	; $6ae6
	ld hl,$cf00		; $6ae8
	ld de,$d800		; $6aeb
	ld c,$0b		; $6aee
_label_04_317:
	ld b,$10		; $6af0
_label_04_318:
	push bc			; $6af2
	ldi a,(hl)		; $6af3
	push hl			; $6af4
	call setHlToTileMappingDataPlusATimes8		; $6af5
	push de			; $6af8
	call $6b16		; $6af9
	pop de			; $6afc
	set 2,d			; $6afd
	call $6b16		; $6aff
	res 2,d			; $6b02
	ld a,e			; $6b04
	sub $1f			; $6b05
	ld e,a			; $6b07
	pop hl			; $6b08
	pop bc			; $6b09
	dec b			; $6b0a
	jr nz,_label_04_318	; $6b0b
	ld a,$20		; $6b0d
	call addAToDe		; $6b0f
	dec c			; $6b12
	jr nz,_label_04_317	; $6b13
	ret			; $6b15
	ldi a,(hl)		; $6b16
	ld (de),a		; $6b17
	inc e			; $6b18
	ldi a,(hl)		; $6b19
	ld (de),a		; $6b1a
	ld a,$1f		; $6b1b
	add e			; $6b1d
	ld e,a			; $6b1e
	ldi a,(hl)		; $6b1f
	ld (de),a		; $6b20
	inc e			; $6b21
	ldi a,(hl)		; $6b22
	ld (de),a		; $6b23
	ret			; $6b24
updateChangedTileQueue:
	ld a,($cd00)		; $6b25
	and $0e			; $6b28
	ret nz			; $6b2a
	ld b,$04		; $6b2b
_label_04_319:
	push bc			; $6b2d
	call $6b39		; $6b2e
	pop bc			; $6b31
	dec b			; $6b32
	jr nz,_label_04_319	; $6b33
	xor a			; $6b35
	ld ($ff00+$70),a	; $6b36
	ret			; $6b38
	ld a,($ccf5)		; $6b39
	ld b,a			; $6b3c
	ld a,($ccf6)		; $6b3d
	cp b			; $6b40
	ret z			; $6b41
	inc b			; $6b42
	ld a,b			; $6b43
	and $1f			; $6b44
	ld ($ccf5),a		; $6b46
	ld hl,$dac0		; $6b49
	rst_addDoubleIndex			; $6b4c
	ld a,$02		; $6b4d
	ld ($ff00+$70),a	; $6b4f
	ldi a,(hl)		; $6b51
	ld c,(hl)		; $6b52
	ld b,a			; $6b53
	ld a,c			; $6b54
	ldh (<hFF8C),a	; $6b55
	ld a,($ff00+$70)	; $6b57
	push af			; $6b59
	ld a,$03		; $6b5a
	ld ($ff00+$70),a	; $6b5c
	call $6b7c		; $6b5e
	ld a,b			; $6b61
	call setHlToTileMappingDataPlusATimes8		; $6b62
	push hl			; $6b65
	push de			; $6b66
	call $6b16		; $6b67
	pop de			; $6b6a
	ld a,$04		; $6b6b
	add d			; $6b6d
	ld d,a			; $6b6e
	call $6b16		; $6b6f
	ldh a,(<hFF8C)	; $6b72
	pop hl			; $6b74
	call $6c17		; $6b75
	pop af			; $6b78
	ld ($ff00+$70),a	; $6b79
	ret			; $6b7b
	ld a,c			; $6b7c
	swap a			; $6b7d
	and $0f			; $6b7f
	ld hl,$6b90		; $6b81
	rst_addDoubleIndex			; $6b84
	ldi a,(hl)		; $6b85
	ld h,(hl)		; $6b86
	ld l,a			; $6b87
	ld a,c			; $6b88
	and $0f			; $6b89
	add a			; $6b8b
	rst_addAToHl			; $6b8c
	ld e,l			; $6b8d
	ld d,h			; $6b8e
	ret			; $6b8f
	nop			; $6b90
	ret c			; $6b91
	ld b,b			; $6b92
	ret c			; $6b93
	add b			; $6b94
	ret c			; $6b95
	ret nz			; $6b96
	ret c			; $6b97
	nop			; $6b98
	reti			; $6b99
	ld b,b			; $6b9a
	reti			; $6b9b
	add b			; $6b9c
	reti			; $6b9d
	ret nz			; $6b9e
	reti			; $6b9f
	nop			; $6ba0
	jp c,$da40		; $6ba1
	add b			; $6ba4
	.db $da ; $6ba5
setInterleavedTile_body:
	ld ($ff00+$8b),a ; $6ba6
	ld a,($ff00+$70)	; $6ba8
	push af			; $6baa
	ld a,$03		; $6bab
	ld ($ff00+$70),a	; $6bad
	ldh a,(<hFF8F)	; $6baf
	call setHlToTileMappingDataPlusATimes8		; $6bb1
	ld de,$cec8		; $6bb4
	ld b,$08		; $6bb7
_label_04_320:
	ldi a,(hl)		; $6bb9
	ld (de),a		; $6bba
	inc de			; $6bbb
	dec b			; $6bbc
	jr nz,_label_04_320	; $6bbd
	ldh a,(<hFF8E)	; $6bbf
	call setHlToTileMappingDataPlusATimes8		; $6bc1
	ld de,$cec8		; $6bc4
	ldh a,(<hFF8B)	; $6bc7
	bit 0,a			; $6bc9
	jr nz,_label_04_323	; $6bcb
	bit 1,a			; $6bcd
	jr nz,_label_04_321	; $6bcf
	inc hl			; $6bd1
	inc hl			; $6bd2
	call $6be6		; $6bd3
	jr _label_04_322		; $6bd6
_label_04_321:
	inc de			; $6bd8
	inc de			; $6bd9
	call $6be6		; $6bda
_label_04_322:
	inc hl			; $6bdd
	inc hl			; $6bde
	inc de			; $6bdf
	inc de			; $6be0
	call $6be6		; $6be1
	jr _label_04_326		; $6be4
	ldi a,(hl)		; $6be6
	ld (de),a		; $6be7
	inc de			; $6be8
	ldi a,(hl)		; $6be9
	ld (de),a		; $6bea
	inc de			; $6beb
	ret			; $6bec
_label_04_323:
	bit 1,a			; $6bed
	jr nz,_label_04_324	; $6bef
	inc de			; $6bf1
	call $6c02		; $6bf2
	jr _label_04_325		; $6bf5
_label_04_324:
	inc hl			; $6bf7
	call $6c02		; $6bf8
_label_04_325:
	inc hl			; $6bfb
	inc de			; $6bfc
	call $6c02		; $6bfd
	jr _label_04_326		; $6c00
	ldi a,(hl)		; $6c02
	ld (de),a		; $6c03
	inc de			; $6c04
	inc hl			; $6c05
	inc de			; $6c06
	ldi a,(hl)		; $6c07
	ld (de),a		; $6c08
	inc de			; $6c09
	ret			; $6c0a
_label_04_326:
	ldh a,(<hFF8C)	; $6c0b
	ld hl,$cec8		; $6c0d
	call $6c17		; $6c10
	pop af			; $6c13
	ld ($ff00+$70),a	; $6c14
	ret			; $6c16
	push hl			; $6c17
	call $6c47		; $6c18
	add $20			; $6c1b
	ld c,a			; $6c1d
	ldh a,(<hVBlankFunctionQueueTail)	; $6c1e
	ld l,a			; $6c20
	ld h,$c4		; $6c21
	ld a,(vblankCopyTileFunctionOffset)		; $6c23
	ldi (hl),a		; $6c26
	ld (hl),e		; $6c27
	inc l			; $6c28
	ld (hl),d		; $6c29
	inc l			; $6c2a
	ld e,l			; $6c2b
	ld d,h			; $6c2c
	pop hl			; $6c2d
	ld b,$02		; $6c2e
_label_04_327:
	call $6c40		; $6c30
	ld a,c			; $6c33
	ld (de),a		; $6c34
	inc e			; $6c35
	call $6c40		; $6c36
	dec b			; $6c39
	jr nz,_label_04_327	; $6c3a
	ld a,e			; $6c3c
	ldh (<hVBlankFunctionQueueTail),a	; $6c3d
	ret			; $6c3f
	ldi a,(hl)		; $6c40
	ld (de),a		; $6c41
	inc e			; $6c42
	ldi a,(hl)		; $6c43
	ld (de),a		; $6c44
	inc e			; $6c45
	ret			; $6c46
	ld e,a			; $6c47
	and $f0			; $6c48
	swap a			; $6c4a
	ld d,a			; $6c4c
	ld a,e			; $6c4d
	and $0f			; $6c4e
	add a			; $6c50
	ld e,a			; $6c51
	ld a,($cd09)		; $6c52
	swap a			; $6c55
	add a			; $6c57
	add e			; $6c58
	and $1f			; $6c59
	ld e,a			; $6c5b
	ld a,($cd08)		; $6c5c
	swap a			; $6c5f
	add d			; $6c61
	and $0f			; $6c62
	ld hl,vramBgMapTable		; $6c64
	rst_addDoubleIndex			; $6c67
	ldi a,(hl)		; $6c68
	add e			; $6c69
	ld e,a			; $6c6a
	ld d,(hl)		; $6c6b
	ret			; $6c6c
loadTilesetData_body:
	call $6ce6		; $6c6d
	jr c,_label_04_328	; $6c70
	call $6d17		; $6c72
	jr c,_label_04_328	; $6c75
	ld a,($cc49)		; $6c77
	ld hl,$533c		; $6c7a
	rst_addDoubleIndex			; $6c7d
	ldi a,(hl)		; $6c7e
	ld h,(hl)		; $6c7f
	ld l,a			; $6c80
	ld a,($cc4c)		; $6c81
	rst_addAToHl			; $6c84
	ld a,(hl)		; $6c85
	and $80			; $6c86
	ldh (<hFF8B),a	; $6c88
	ld a,(hl)		; $6c8a
	and $7f			; $6c8b
	call multiplyABy8		; $6c8d
	ld hl,$4c84		; $6c90
	add hl,bc		; $6c93
	ld a,(hl)		; $6c94
	inc a			; $6c95
	jr nz,_label_04_328	; $6c96
	inc hl			; $6c98
	ldi a,(hl)		; $6c99
	ld h,(hl)		; $6c9a
	ld l,a			; $6c9b
	ld a,($cc4e)		; $6c9c
	call multiplyABy8		; $6c9f
	add hl,bc		; $6ca2
_label_04_328:
	ldi a,(hl)		; $6ca3
	ld e,a			; $6ca4
	and $0f			; $6ca5
	cp $0f			; $6ca7
	jr nz,_label_04_329	; $6ca9
	ld a,$ff		; $6cab
_label_04_329:
	ld ($cc55),a		; $6cad
	ld a,e			; $6cb0
	swap a			; $6cb1
	and $0f			; $6cb3
	ld ($cc4f),a		; $6cb5
	ldi a,(hl)		; $6cb8
	ld ($cc50),a		; $6cb9
	ld b,$06		; $6cbc
	ld de,$cd20		; $6cbe
_label_04_330:
	ldi a,(hl)		; $6cc1
	ld (de),a		; $6cc2
	inc e			; $6cc3
	dec b			; $6cc4
	jr nz,_label_04_330	; $6cc5
	ld e,$20		; $6cc7
	ld a,(de)		; $6cc9
	ld b,a			; $6cca
	ldh a,(<hFF8B)	; $6ccb
	or b			; $6ccd
	ld (de),a		; $6cce
	ld a,($cc49)		; $6ccf
	or a			; $6cd2
	ret nz			; $6cd3
	ld a,($cc4c)		; $6cd4
	cp $96			; $6cd7
	ret nz			; $6cd9
	call getThisRoomFlags		; $6cda
	and $80			; $6cdd
	ret nz			; $6cdf
	ld a,$20		; $6ce0
	ld ($cd20),a		; $6ce2
	ret			; $6ce5
	ld a,$15		; $6ce6
	call checkGlobalFlag		; $6ce8
	ret z			; $6ceb
	call $6cff		; $6cec
	ret nc			; $6cef
	ld a,($cc4e)		; $6cf0
	call multiplyABy8		; $6cf3
	ld hl,$52fc		; $6cf6
	add hl,bc		; $6cf9
_label_04_331:
	xor a			; $6cfa
	ldh (<hFF8B),a	; $6cfb
	scf			; $6cfd
	ret			; $6cfe
	ld a,($cc49)		; $6cff
	or a			; $6d02
	ret nz			; $6d03
	ld a,($cc4c)		; $6d04
	cp $14			; $6d07
	jr c,_label_04_332	; $6d09
	sub $04			; $6d0b
	cp $30			; $6d0d
	ret nc			; $6d0f
	and $0f			; $6d10
	cp $04			; $6d12
	ret			; $6d14
_label_04_332:
	xor a			; $6d15
	ret			; $6d16
	ld a,($cc49)		; $6d17
	or a			; $6d1a
	ret nz			; $6d1b
	call $6d36		; $6d1c
	ret nc			; $6d1f
	ld a,$16		; $6d20
	call checkGlobalFlag		; $6d22
	ret z			; $6d25
	ld a,($c610)		; $6d26
	sub $0a			; $6d29
	and $03			; $6d2b
	call multiplyABy8		; $6d2d
	ld hl,$531c		; $6d30
	add hl,bc		; $6d33
	jr _label_04_331		; $6d34
	ld a,($cc4c)		; $6d36
	ld b,$05		; $6d39
	ld hl,$6d49		; $6d3b
_label_04_333:
	cp (hl)			; $6d3e
	jr z,_label_04_334	; $6d3f
	inc hl			; $6d41
	dec b			; $6d42
	jr nz,_label_04_333	; $6d43
	xor a			; $6d45
	ret			; $6d46
_label_04_334:
	scf			; $6d47
	ret			; $6d48
	ld e,e			; $6d49
	ld e,h			; $6d4a
	ld l,e			; $6d4b
	ld l,h			; $6d4c
	ld a,e			; $6d4d

	.include "build/data/warpData.s"


.BANK $05 SLOT 1
.ORG 0

 m_section_force "Bank_5" NAMESPACE bank5

.include "code/bank5.s"
.include "build/data/tileTypeMappings.s"
.include "build/data/cliffTilesTable.s"
.include "code/seasons/subrosiaDanceLink.s"

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


_itemUsageParameterTable:
	.db $00 <wGameKeysPressed       ; ITEMID_NONE
	.db $05 <wGameKeysPressed       ; ITEMID_SHIELD
	.db $03 <wGameKeysJustPressed   ; ITEMID_PUNCH
	.db $23 <wGameKeysJustPressed   ; ITEMID_BOMB
	.db $00 <wGameKeysJustPressed   ; ITEMID_CANE_OF_SOMARIA
	.db $63 <wGameKeysJustPressed   ; ITEMID_SWORD
	.db $02 <wGameKeysJustPressed   ; ITEMID_BOOMERANG
	.db $33 <wGameKeysJustPressed   ; ITEMID_ROD_OF_SEASONS
	.db $53 <wGameKeysJustPressed   ; ITEMID_MAGNET_GLOVES
	.db $00 <wGameKeysJustPressed   ; ITEMID_SWITCH_HOOK_HELPER
	.db $00 <wGameKeysJustPressed   ; ITEMID_SWITCH_HOOK
	.db $00 <wGameKeysJustPressed   ; ITEMID_SWITCH_HOOK_CHAIN
	.db $73 <wGameKeysJustPressed   ; ITEMID_BIGGORON_SWORD
	.db $02 <wGameKeysJustPressed   ; ITEMID_BOMBCHUS
	.db $05 <wGameKeysJustPressed   ; ITEMID_FLUTE
	.db $00 <wGameKeysJustPressed   ; ITEMID_SHOOTER
	.db $00 <wGameKeysJustPressed   ; ITEMID_10
	.db $00 <wGameKeysJustPressed   ; ITEMID_HARP
	.db $00 <wGameKeysJustPressed   ; ITEMID_12
	.db $43 <wGameKeysJustPressed   ; ITEMID_SLINGSHOT
	.db $00 <wGameKeysJustPressed   ; ITEMID_14
	.db $13 <wGameKeysJustPressed   ; ITEMID_SHOVEL
	.db $13 <wGameKeysPressed       ; ITEMID_BRACELET
	.db $01 <wGameKeysJustPressed   ; ITEMID_FEATHER
	.db $00 <wGameKeysJustPressed   ; ITEMID_18
	.db $02 <wGameKeysJustPressed   ; ITEMID_SEED_SATCHEL
	.db $00 <wGameKeysJustPressed   ; ITEMID_DUST
	.db $00 <wGameKeysJustPressed   ; ITEMID_1b
	.db $00 <wGameKeysJustPressed   ; ITEMID_1c
	.db $00 <wGameKeysJustPressed   ; ITEMID_MINECART_COLLISION
	.db $03 <wGameKeysJustPressed   ; ITEMID_FOOLS_ORE
	.db $00 <wGameKeysJustPressed   ; ITEMID_1f


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

specialObjectCode_minecart:
	call $5727		; $5588
	ld e,$04		; $558b
	ld a,(de)		; $558d
	rst_jumpTable			; $558e
	sub e			; $558f
	ld d,l			; $5590
	cp a			; $5591
	ld d,l			; $5592
	ld a,$01		; $5593
	ld (de),a		; $5595
	ld hl,$41b5		; $5596
	ld e,$05		; $5599
	call interBankCall		; $559b
	ld h,d			; $559e
	ld l,$10		; $559f
	ld (hl),$28		; $55a1
	ld l,$08		; $55a3
	ld a,(hl)		; $55a5
	call specialObjectSetAnimation		; $55a6
	ld a,d			; $55a9
	ld ($cc48),a		; $55aa
	call setCameraFocusedObjectToLink		; $55ad
	call clearVar3fForParentItems		; $55b0
	call clearPegasusSeedCounter		; $55b3
	ld hl,$d00e		; $55b6
	xor a			; $55b9
	ldi (hl),a		; $55ba
	ldi (hl),a		; $55bb
	jp objectSetVisiblec2		; $55bc
	ld a,($c4ab)		; $55bf
	or a			; $55c2
	ret nz			; $55c3
	call retIfTextIsActive		; $55c4
	ld a,($cd00)		; $55c7
	and $0e			; $55ca
	ret nz			; $55cc
	ld a,($cca4)		; $55cd
	and $81			; $55d0
	ret nz			; $55d2
	ld hl,$d024		; $55d3
	res 7,(hl)		; $55d6
	xor a			; $55d8
	ld l,$2d		; $55d9
	ldi (hl),a		; $55db
	ld h,d			; $55dc
	ld l,$0b		; $55dd
	ldi a,(hl)		; $55df
	ld b,a			; $55e0
	and $0f			; $55e1
	cp $08			; $55e3
	jr nz,_label_06_159	; $55e5
	inc l			; $55e7
	ldi a,(hl)		; $55e8
	ld c,a			; $55e9
	and $0f			; $55ea
	cp $08			; $55ec
	jr nz,_label_06_159	; $55ee
	call $5656		; $55f0
	jr c,_label_06_161	; $55f3
	ld h,d			; $55f5
	ld l,$08		; $55f6
	ldi a,(hl)		; $55f8
	swap a			; $55f9
	rrca			; $55fb
	cp (hl)			; $55fc
	jr z,_label_06_159	; $55fd
	ldd (hl),a		; $55ff
	ld a,(hl)		; $5600
	call specialObjectSetAnimation		; $5601
_label_06_159:
	ld h,d			; $5604
	ld l,$35		; $5605
	dec (hl)		; $5607
	bit 7,(hl)		; $5608
	jr z,_label_06_160	; $560a
	ld (hl),$1a		; $560c
	ld a,$80		; $560e
	call playSound		; $5610
_label_06_160:
	call objectApplySpeed		; $5613
	jp specialObjectAnimate		; $5616
_label_06_161:
	ld e,$04		; $5619
	ld a,$02		; $561b
	ld (de),a		; $561d
	call clearVar3fForParentItems		; $561e
	ld a,$81		; $5621
	ld ($cc77),a		; $5623
	ld hl,$d009		; $5626
	ld e,$09		; $5629
	ld a,(de)		; $562b
	ld (hl),a		; $562c
	ld l,$0b		; $562d
	ld a,(hl)		; $562f
	add $06			; $5630
	ld (hl),a		; $5632
	ld l,$0f		; $5633
	ld (hl),$fa		; $5635
	ld l,$10		; $5637
	ld (hl),$14		; $5639
	ld l,$14		; $563b
	ld (hl),$40		; $563d
	inc l			; $563f
	ld (hl),$fe		; $5640
	ld l,$1a		; $5642
	set 6,(hl)		; $5644
	ld a,$d0		; $5646
	ld ($cc48),a		; $5648
	call setCameraFocusedObjectToLink		; $564b
	ld b,$16		; $564e
	call objectCreateInteractionWithSubid00		; $5650
	jp objectDelete_useActiveObjectType		; $5653
	call getTileAtPosition		; $5656
	ld e,a			; $5659
	ld c,l			; $565a
	ld h,d			; $565b
	ld l,$08		; $565c
	ld a,(hl)		; $565e
	swap a			; $565f
	ld hl,$56cd		; $5661
	rst_addAToHl			; $5664
_label_06_162:
	ldi a,(hl)		; $5665
	or a			; $5666
	jr z,_label_06_167	; $5667
	cp e			; $5669
	jr z,_label_06_163	; $566a
	ld a,$04		; $566c
	rst_addAToHl			; $566e
	jr _label_06_162		; $566f
_label_06_163:
	ldi a,(hl)		; $5671
	add c			; $5672
	ld c,a			; $5673
	ldh (<hFF8B),a	; $5674
	ld b,$ce		; $5676
	ld a,(bc)		; $5678
	cp $ff			; $5679
	ret z			; $567b
	ld b,$cf		; $567c
	ld a,(bc)		; $567e
	cp $5f			; $567f
	jr z,_label_06_165	; $5681
	ld c,a			; $5683
	ld b,$03		; $5684
_label_06_164:
	ldi a,(hl)		; $5686
	cp c			; $5687
	jr z,_label_06_166	; $5688
	dec b			; $568a
	jr nz,_label_06_164	; $568b
	jr _label_06_167		; $568d
_label_06_165:
	scf			; $568f
	ret			; $5690
_label_06_166:
	ld a,e			; $5691
	sub $59			; $5692
	cp $06			; $5694
	jr c,_label_06_168	; $5696
_label_06_167:
	ld a,$06		; $5698
_label_06_168:
	ld e,$08		; $569a
	rst_jumpTable			; $569c
	xor e			; $569d
	ld d,(hl)		; $569e
	xor e			; $569f
	ld d,(hl)		; $56a0
	or b			; $56a1
	ld d,(hl)		; $56a2
	or b			; $56a3
	ld d,(hl)		; $56a4
	or l			; $56a5
	ld d,(hl)		; $56a6
	cp h			; $56a7
	ld d,(hl)		; $56a8
	pop bc			; $56a9
	ld d,(hl)		; $56aa
	ld a,(de)		; $56ab
	xor $01			; $56ac
	ld (de),a		; $56ae
	ret			; $56af
	ld a,(de)		; $56b0
	xor $03			; $56b1
	ld (de),a		; $56b3
	ret			; $56b4
	ld a,(de)		; $56b5
	and $02			; $56b6
	or $01			; $56b8
	ld (de),a		; $56ba
	ret			; $56bb
	ld a,(de)		; $56bc
	and $02			; $56bd
	ld (de),a		; $56bf
	ret			; $56c0
	call $570d		; $56c1
	jr nc,_label_06_169	; $56c4
	xor a			; $56c6
	ret			; $56c7
_label_06_169:
	ld a,(de)		; $56c8
	xor $02			; $56c9
	ld (de),a		; $56cb
	ret			; $56cc
	ld e,(hl)		; $56cd
	ld a,($ff00+$5e)	; $56ce
	ld e,c			; $56d0
	ld e,h			; $56d1
	ld e,c			; $56d2
	ld bc,$5a5d		; $56d3
	ld e,h			; $56d6
	ld e,h			; $56d7
	rst $38			; $56d8
	ld e,l			; $56d9
	ld e,e			; $56da
	ld e,c			; $56db
	nop			; $56dc
	ld e,l			; $56dd
	ld bc,$5a5d		; $56de
	ld e,h			; $56e1
	ld e,d			; $56e2
	ld a,($ff00+$5e)	; $56e3
	ld e,c			; $56e5
	ld e,h			; $56e6
	ld e,h			; $56e7
	stop			; $56e8
	ld e,(hl)		; $56e9
	ld e,e			; $56ea
	ld e,d			; $56eb
	nop			; $56ec
	ld e,(hl)		; $56ed
	stop			; $56ee
	ld e,(hl)		; $56ef
	ld e,d			; $56f0
	ld e,e			; $56f1
	ld e,d			; $56f2
	rst $38			; $56f3
	ld e,l			; $56f4
	ld e,e			; $56f5
	ld e,c			; $56f6
	ld e,e			; $56f7
	ld bc,$5a5d		; $56f8
	ld e,h			; $56fb
	nop			; $56fc
	ld e,l			; $56fd
	rst $38			; $56fe
	ld e,l			; $56ff
	ld e,e			; $5700
	ld e,c			; $5701
	ld e,e			; $5702
	ld a,($ff00+$5e)	; $5703
	ld e,h			; $5705
	ld e,c			; $5706
	ld e,c			; $5707
	stop			; $5708
	ld e,(hl)		; $5709
	ld e,d			; $570a
	ld e,e			; $570b
	nop			; $570c
	ld a,c			; $570d
	sub $7c			; $570e
	cp $04			; $5710
	ret nc			; $5712
	add $0c			; $5713
	add a			; $5715
	ld b,a			; $5716
	call getFreeInteractionSlot		; $5717
	ret nz			; $571a
	ld (hl),$1e		; $571b
	ld l,$49		; $571d
	ld (hl),b		; $571f
	ld l,$4b		; $5720
	ldh a,(<hFF8B)	; $5722
	ld (hl),a		; $5724
	scf			; $5725
	ret			; $5726
	ld e,$36		; $5727
	ld a,(de)		; $5729
	or a			; $572a
	ret nz			; $572b
	call getFreeItemSlot		; $572c
	ret nz			; $572f
	ld e,$36		; $5730
	ld a,$01		; $5732
	ld (de),a		; $5734
	ldi (hl),a		; $5735
	ld (hl),$1d		; $5736
	ret			; $5738


	.include "data/seasons/specialObjectAnimationData.s"

specialObjectCode_companionCutscene:
	ld hl,$d101		; $69c9
	ld a,(hl)		; $69cc
	sub $0f			; $69cd
	rst_jumpTable			; $69cf
	ret c			; $69d0
	ld l,c			; $69d1
	ld a,(bc)		; $69d2
	ld l,h			; $69d3
	ld h,h			; $69d4
	ld l,e			; $69d5
.DB $f4				; $69d6
	ld l,h			; $69d7
	ld e,$04		; $69d8
	ld a,(de)		; $69da
	ld a,(de)		; $69db
	rst_jumpTable			; $69dc
	pop hl			; $69dd
	ld l,c			; $69de
	dec d			; $69df
	ld l,d			; $69e0
	call $6a07		; $69e1
	ld h,d			; $69e4
	ld l,$02		; $69e5
	ld a,(hl)		; $69e7
	or a			; $69e8
	jr z,_label_06_220	; $69e9
	ld l,$10		; $69eb
	ld (hl),$50		; $69ed
	ld l,$09		; $69ef
	ld (hl),$08		; $69f1
	ld bc,$fe00		; $69f3
	call objectSetSpeedZ		; $69f6
	ld a,$02		; $69f9
	jp specialObjectSetAnimation		; $69fb
_label_06_220:
	xor a			; $69fe
	ld ($cbb5),a		; $69ff
	ld a,$1e		; $6a02
	jp specialObjectSetAnimation		; $6a04
	ld a,$01		; $6a07
_label_06_221:
	ld (de),a		; $6a09
	ld hl,$41b5		; $6a0a
	ld e,$05		; $6a0d
	call interBankCall		; $6a0f
	jp objectSetVisiblec0		; $6a12
	ld e,$02		; $6a15
	ld a,(de)		; $6a17
	rst_jumpTable			; $6a18
	dec e			; $6a19
	ld l,d			; $6a1a
	ld h,l			; $6a1b
	ld l,d			; $6a1c
	ld e,$05		; $6a1d
	ld a,(de)		; $6a1f
	rst_jumpTable			; $6a20
	dec h			; $6a21
	ld l,d			; $6a22
	ld b,h			; $6a23
	ld l,d			; $6a24
	call specialObjectAnimate		; $6a25
	ld h,d			; $6a28
	ld l,$21		; $6a29
	ld a,(hl)		; $6a2b
	or a			; $6a2c
	jr z,_label_06_222	; $6a2d
	ld a,$01		; $6a2f
	ld ($cbb5),a		; $6a31
	ld l,$05		; $6a34
	inc (hl)		; $6a36
_label_06_222:
	ld c,$20		; $6a37
	call objectUpdateSpeedZ_paramC		; $6a39
	ret nz			; $6a3c
	ld h,d			; $6a3d
	ld bc,$ff20		; $6a3e
	jp objectSetSpeedZ		; $6a41
	call specialObjectAnimate		; $6a44
	ld h,d			; $6a47
	ld l,$21		; $6a48
	ld a,(hl)		; $6a4a
	or a			; $6a4b
	ret z			; $6a4c
	ld (hl),$00		; $6a4d
	inc a			; $6a4f
	jr z,_label_06_223	; $6a50
	call getFreeInteractionSlot		; $6a52
	ret nz			; $6a55
	ld (hl),$07		; $6a56
	ld bc,$f812		; $6a58
	jp objectCopyPositionWithOffset		; $6a5b
_label_06_223:
	ld l,$05		; $6a5e
	ld (hl),$00		; $6a60
	jp $69fe		; $6a62
	ld e,$05		; $6a65
	ld a,(de)		; $6a67
	rst_jumpTable			; $6a68
	ld a,a			; $6a69
	ld l,d			; $6a6a
	add d			; $6a6b
	ld l,d			; $6a6c
	or h			; $6a6d
	ld l,d			; $6a6e
	cp l			; $6a6f
	ld l,d			; $6a70
	jp z,$dd6a		; $6a71
	ld l,d			; $6a74
	ld ($126a),a		; $6a75
	ld l,e			; $6a78
	inc h			; $6a79
	ld l,e			; $6a7a
	add hl,sp		; $6a7b
	ld l,e			; $6a7c
	ld e,d			; $6a7d
	ld l,e			; $6a7e
	ld l,$05		; $6a7f
	inc (hl)		; $6a81
	call objectApplySpeed		; $6a82
	ld e,$0d		; $6a85
	ld a,(de)		; $6a87
	bit 7,a			; $6a88
	jr nz,_label_06_224	; $6a8a
	ld hl,$d00d		; $6a8c
	ld b,(hl)		; $6a8f
	add $18			; $6a90
	cp b			; $6a92
	jr c,_label_06_224	; $6a93
	call itemIncState2		; $6a95
	inc (hl)		; $6a98
	inc l			; $6a99
	ld (hl),$3c		; $6a9a
	ld l,$0e		; $6a9c
	xor a			; $6a9e
	ldi (hl),a		; $6a9f
	ld (hl),a		; $6aa0
	jp specialObjectAnimate		; $6aa1
_label_06_224:
	ld c,$40		; $6aa4
	call objectUpdateSpeedZ_paramC		; $6aa6
	ret nz			; $6aa9
	call itemIncState2		; $6aaa
	ld l,$06		; $6aad
	ld (hl),$08		; $6aaf
	jp specialObjectAnimate		; $6ab1
	call itemDecCounter1		; $6ab4
	ret nz			; $6ab7
	dec l			; $6ab8
	dec (hl)		; $6ab9
	jp $69f3		; $6aba
	call itemDecCounter1		; $6abd
	ret nz			; $6ac0
	ld (hl),$5a		; $6ac1
	dec l			; $6ac3
	inc (hl)		; $6ac4
	ld a,$14		; $6ac5
	jp specialObjectSetAnimation		; $6ac7
	call specialObjectAnimate		; $6aca
	call itemDecCounter1		; $6acd
	ret nz			; $6ad0
	ld (hl),$0c		; $6ad1
	dec l			; $6ad3
	inc (hl)		; $6ad4
	ld a,$1f		; $6ad5
	call specialObjectSetAnimation		; $6ad7
	jp $6a52		; $6ada
	call itemDecCounter1		; $6add
	ret nz			; $6ae0
	ld (hl),$3c		; $6ae1
	dec l			; $6ae3
	inc (hl)		; $6ae4
	ld a,$1e		; $6ae5
	jp specialObjectSetAnimation		; $6ae7
	call itemDecCounter1		; $6aea
	ret nz			; $6aed
	ld (hl),$1e		; $6aee
	dec l			; $6af0
	inc (hl)		; $6af1
	ld hl,$c6c5		; $6af2
	ld (hl),$ff		; $6af5
	ld a,$81		; $6af7
	ld ($cc77),a		; $6af9
	ld hl,$d010		; $6afc
	ld (hl),$14		; $6aff
	ld l,$14		; $6b01
	ld (hl),$00		; $6b03
	inc l			; $6b05
	ld (hl),$fe		; $6b06
	ld a,$18		; $6b08
	ld ($d009),a		; $6b0a
	ld a,$53		; $6b0d
	jp playSound		; $6b0f
	call itemDecCounter1		; $6b12
	ret nz			; $6b15
	ld (hl),$14		; $6b16
	dec l			; $6b18
	inc (hl)		; $6b19
	xor a			; $6b1a
	ld hl,$d01a		; $6b1b
	ld (hl),a		; $6b1e
	inc a			; $6b1f
	ld ($cca4),a		; $6b20
	ret			; $6b23
	call itemDecCounter1		; $6b24
	ret nz			; $6b27
	dec l			; $6b28
	inc (hl)		; $6b29
	ld l,$09		; $6b2a
	ld (hl),$18		; $6b2c
	ld a,$1c		; $6b2e
	call specialObjectSetAnimation		; $6b30
	ld bc,$fe00		; $6b33
	jp objectSetSpeedZ		; $6b36
	call objectApplySpeed		; $6b39
	ld e,$0d		; $6b3c
	ld a,(de)		; $6b3e
	sub $10			; $6b3f
	rlca			; $6b41
	jr nc,_label_06_225	; $6b42
	ld hl,$cfdf		; $6b44
	ld (hl),$01		; $6b47
	ret			; $6b49
_label_06_225:
	ld c,$40		; $6b4a
	call objectUpdateSpeedZ_paramC		; $6b4c
	ret nz			; $6b4f
	call itemIncState2		; $6b50
	ld l,$06		; $6b53
	ld (hl),$08		; $6b55
	jp specialObjectAnimate		; $6b57
	call itemDecCounter1		; $6b5a
	ret nz			; $6b5d
	ld l,$05		; $6b5e
	dec (hl)		; $6b60
	jp $6b2e		; $6b61
	ld e,$04		; $6b64
	ld a,(de)		; $6b66
	rst_jumpTable			; $6b67
	ld l,h			; $6b68
	ld l,e			; $6b69
	sub (hl)		; $6b6a
	ld l,e			; $6b6b
	call $6a07		; $6b6c
	ld h,d			; $6b6f
	ld l,$06		; $6b70
	ld (hl),$5a		; $6b72
	ld l,$10		; $6b74
	ld (hl),$37		; $6b76
	ld l,$36		; $6b78
	ld (hl),$05		; $6b7a
	ld l,$09		; $6b7c
	ld (hl),$10		; $6b7e
	ld l,$0e		; $6b80
	ld (hl),$ff		; $6b82
	inc l			; $6b84
	ld (hl),$e0		; $6b85
	call getFreeInteractionSlot		; $6b87
	jr nz,_label_06_226	; $6b8a
	ld (hl),$c0		; $6b8c
	ld l,$57		; $6b8e
	ld (hl),d		; $6b90
_label_06_226:
	ld a,$07		; $6b91
	jp specialObjectSetAnimation		; $6b93
	ld e,$05		; $6b96
	ld a,(de)		; $6b98
	or a			; $6b99
	jr z,_label_06_227	; $6b9a
	call specialObjectAnimate		; $6b9c
	call objectApplySpeed		; $6b9f
_label_06_227:
	ld e,$05		; $6ba2
	ld a,(de)		; $6ba4
	rst_jumpTable			; $6ba5
	or b			; $6ba6
	ld l,e			; $6ba7
	cp d			; $6ba8
	ld l,e			; $6ba9
	add $6b			; $6baa
	sbc $6b			; $6bac
	xor $6b			; $6bae
	call itemDecCounter1		; $6bb0
	ret nz			; $6bb3
	ld (hl),$48		; $6bb4
	ld l,$05		; $6bb6
	inc (hl)		; $6bb8
	ret			; $6bb9
	call itemDecCounter1		; $6bba
	ret nz			; $6bbd
	ld (hl),$06		; $6bbe
	ld l,$05		; $6bc0
	inc (hl)		; $6bc2
	jp $6d89		; $6bc3
	ld h,d			; $6bc6
	ld l,$09		; $6bc7
	ld a,(hl)		; $6bc9
	cp $10			; $6bca
	jr z,_label_06_228	; $6bcc
	ld l,$05		; $6bce
	inc (hl)		; $6bd0
	ret			; $6bd1
_label_06_228:
	ld l,$06		; $6bd2
	dec (hl)		; $6bd4
	ret nz			; $6bd5
	call $6da0		; $6bd6
	ld (hl),$06		; $6bd9
	jp $6d89		; $6bdb
	ld h,d			; $6bde
	ld l,$09		; $6bdf
	ld a,(hl)		; $6be1
	cp $10			; $6be2
	jr nz,_label_06_228	; $6be4
	ld l,$05		; $6be6
	inc (hl)		; $6be8
	ld a,$07		; $6be9
	jp specialObjectSetAnimation		; $6beb
	ld e,$0b		; $6bee
	ld a,(de)		; $6bf0
	cp $b0			; $6bf1
	ret c			; $6bf3
	ld hl,$d101		; $6bf4
	ld b,$3f		; $6bf7
	call clearMemory		; $6bf9
	ld hl,$d101		; $6bfc
	ld (hl),$10		; $6bff
	ld l,$0b		; $6c01
	ld (hl),$e8		; $6c03
	inc l			; $6c05
	inc l			; $6c06
	ld (hl),$28		; $6c07
	ret			; $6c09
	ld e,$04		; $6c0a
	ld a,(de)		; $6c0c
	rst_jumpTable			; $6c0d
	ld (de),a		; $6c0e
	ld l,h			; $6c0f
	ld h,$6c		; $6c10
	call $6a07		; $6c12
	ld h,d			; $6c15
	ld l,$10		; $6c16
	ld (hl),$28		; $6c18
	ld l,$0e		; $6c1a
	ld (hl),$e0		; $6c1c
	inc l			; $6c1e
	ld (hl),$ff		; $6c1f
	ld a,$19		; $6c21
	jp specialObjectSetAnimation		; $6c23
	ld e,$05		; $6c26
	ld a,(de)		; $6c28
	rst_jumpTable			; $6c29
	jr c,$6c		; $6c2a
	ld h,h			; $6c2c
	ld l,h			; $6c2d
	add a			; $6c2e
	ld l,h			; $6c2f
	sub a			; $6c30
	ld l,h			; $6c31
	and e			; $6c32
	ld l,h			; $6c33
	cp d			; $6c34
	ld l,h			; $6c35
	add $6c			; $6c36
	ld h,d			; $6c38
	ld l,$05		; $6c39
	inc (hl)		; $6c3b
	ld l,$07		; $6c3c
	ld a,(hl)		; $6c3e
	cp $02			; $6c3f
	jr nz,_label_06_229	; $6c41
	push af			; $6c43
	ld a,$1a		; $6c44
	call specialObjectSetAnimation		; $6c46
	pop af			; $6c49
_label_06_229:
	ld b,a			; $6c4a
	add a			; $6c4b
	add b			; $6c4c
	ld hl,$6c5b		; $6c4d
	rst_addAToHl			; $6c50
	ldi a,(hl)		; $6c51
	ld e,$09		; $6c52
	ld (de),a		; $6c54
	ld c,(hl)		; $6c55
	inc hl			; $6c56
	ld b,(hl)		; $6c57
	jp objectSetSpeedZ		; $6c58
	inc c			; $6c5b
	ld b,b			; $6c5c
.DB $fd				; $6c5d
	inc c			; $6c5e
	and b			; $6c5f
.DB $fd				; $6c60
	inc de			; $6c61
	add b			; $6c62
	cp $cd			; $6c63
	ld (hl),$2a		; $6c65
	call objectApplySpeed		; $6c67
	ld c,$18		; $6c6a
	call objectUpdateSpeedZ_paramC		; $6c6c
	ret nz			; $6c6f
	ld h,d			; $6c70
	ld l,$07		; $6c71
	inc (hl)		; $6c73
	ld a,(hl)		; $6c74
	ld l,$05		; $6c75
	cp $03			; $6c77
	jr z,_label_06_230	; $6c79
	dec (hl)		; $6c7b
	ld l,$06		; $6c7c
	ld (hl),$08		; $6c7e
	ret			; $6c80
_label_06_230:
	inc (hl)		; $6c81
	ld l,$06		; $6c82
	ld (hl),$06		; $6c84
	ret			; $6c86
	call itemDecCounter1		; $6c87
	ret nz			; $6c8a
	ld l,$05		; $6c8b
	inc (hl)		; $6c8d
	ld l,$06		; $6c8e
	ld (hl),$14		; $6c90
	ld a,$27		; $6c92
	jp specialObjectSetAnimation		; $6c94
	call itemDecCounter1		; $6c97
	ret nz			; $6c9a
	ld l,$05		; $6c9b
	inc (hl)		; $6c9d
	ld l,$06		; $6c9e
	ld (hl),$78		; $6ca0
	ret			; $6ca2
	call specialObjectAnimate		; $6ca3
	call itemDecCounter1		; $6ca6
	ret nz			; $6ca9
	ld l,$05		; $6caa
	inc (hl)		; $6cac
	ld l,$06		; $6cad
	ld (hl),$3c		; $6caf
	ld l,$09		; $6cb1
	ld (hl),$0b		; $6cb3
	ld l,$10		; $6cb5
	ld (hl),$14		; $6cb7
	ret			; $6cb9
	call itemDecCounter1		; $6cba
	ret nz			; $6cbd
	ld l,$05		; $6cbe
	inc (hl)		; $6cc0
	ld a,$26		; $6cc1
	jp specialObjectSetAnimation		; $6cc3
	call specialObjectAnimate		; $6cc6
	call objectApplySpeed		; $6cc9
	ld e,$0d		; $6ccc
	ld a,(de)		; $6cce
	cp $78			; $6ccf
	jr nz,_label_06_231	; $6cd1
	ld a,$05		; $6cd3
	jp specialObjectSetAnimation		; $6cd5
_label_06_231:
	cp $b0			; $6cd8
	ret c			; $6cda
	ld hl,$d101		; $6cdb
	ld b,$3f		; $6cde
	call clearMemory		; $6ce0
	ld hl,$d101		; $6ce3
	ld (hl),$0f		; $6ce6
	inc l			; $6ce8
	ld (hl),$01		; $6ce9
	ld l,$0b		; $6ceb
	ld (hl),$48		; $6ced
	inc l			; $6cef
	inc l			; $6cf0
	ld (hl),$d8		; $6cf1
	ret			; $6cf3
	ld e,$04		; $6cf4
	ld a,(de)		; $6cf6
	ld a,(de)		; $6cf7
	rst_jumpTable			; $6cf8
.DB $fd				; $6cf9
	ld l,h			; $6cfa
	inc h			; $6cfb
	ld l,l			; $6cfc
	call $6a07		; $6cfd
	ld h,d			; $6d00
	ld l,$10		; $6d01
	ld (hl),$32		; $6d03
	ld l,$36		; $6d05
	ld (hl),$04		; $6d07
	ld l,$02		; $6d09
	ld a,(hl)		; $6d0b
	or a			; $6d0c
	ld a,$f0		; $6d0d
	jr z,_label_06_232	; $6d0f
	ld a,d			; $6d11
	ld ($cc48),a		; $6d12
	ld a,$d0		; $6d15
_label_06_232:
	ld l,$0f		; $6d17
	ld (hl),a		; $6d19
	ld l,$09		; $6d1a
	ld (hl),$18		; $6d1c
	ld l,$02		; $6d1e
	ld a,(hl)		; $6d20
	jp $6d78		; $6d21
	ld e,$02		; $6d24
	ld a,(de)		; $6d26
	rst_jumpTable			; $6d27
	ld d,d			; $6d28
	ld l,l			; $6d29
	inc l			; $6d2a
	ld l,l			; $6d2b
	ld e,$05		; $6d2c
	ld a,(de)		; $6d2e
	rst_jumpTable			; $6d2f
	ld (hl),$6d		; $6d30
	ld h,d			; $6d32
	ld l,l			; $6d33
	ld (hl),a		; $6d34
	ld l,l			; $6d35
	ld a,($cfc0)		; $6d36
	or a			; $6d39
	jr z,_label_06_233	; $6d3a
	call itemIncState2		; $6d3c
	ld bc,$ff00		; $6d3f
	call objectSetSpeedZ		; $6d42
	ld l,$09		; $6d45
	ld (hl),$0e		; $6d47
	ld l,$10		; $6d49
	ld (hl),$14		; $6d4b
	ld a,$1b		; $6d4d
	jp specialObjectSetAnimation		; $6d4f
_label_06_233:
	ld h,d			; $6d52
	ld l,$02		; $6d53
	ld a,(hl)		; $6d55
	ld l,$06		; $6d56
	dec (hl)		; $6d58
	call z,$6d78		; $6d59
	call objectApplySpeed		; $6d5c
	jp specialObjectAnimate		; $6d5f
	call objectApplySpeed		; $6d62
	ld c,$20		; $6d65
	call objectUpdateSpeedZAndBounce		; $6d67
	jp nc,$6d74		; $6d6a
	call itemIncState2		; $6d6d
	ld l,$20		; $6d70
	ld (hl),$01		; $6d72
	jp specialObjectAnimate		; $6d74
	ret			; $6d77
	ld hl,$6da8		; $6d78
	rst_addDoubleIndex			; $6d7b
	ldi a,(hl)		; $6d7c
	ld h,(hl)		; $6d7d
	ld l,a			; $6d7e
	call $6da0		; $6d7f
	ld b,a			; $6d82
	rst_addAToHl			; $6d83
	ld a,(hl)		; $6d84
	ld e,$06		; $6d85
	ld (de),a		; $6d87
	ld a,b			; $6d88
	sub $04			; $6d89
	and $07			; $6d8b
	ret nz			; $6d8d
	ld e,$09		; $6d8e
	call convertAngleDeToDirection		; $6d90
	dec a			; $6d93
	and $03			; $6d94
	ld h,d			; $6d96
	ld l,$08		; $6d97
	ld (hl),a		; $6d99
	ld l,$36		; $6d9a
	add (hl)		; $6d9c
	jp specialObjectSetAnimation		; $6d9d
	ld e,$09		; $6da0
	ld a,(de)		; $6da2
	dec a			; $6da3
	and $1f			; $6da4
	ld (de),a		; $6da6
	ret			; $6da7
	xor h			; $6da8
	ld l,l			; $6da9
	call z,$066d		; $6daa
	ld b,$06		; $6dad
	ld b,$07		; $6daf
	ld ($0a09),sp		; $6db1
	dec bc			; $6db4
	ld a,(bc)		; $6db5
	add hl,bc		; $6db6
	ld ($0607),sp		; $6db7
	ld b,$06		; $6dba
	ld b,$06		; $6dbc
	ld b,$06		; $6dbe
	rlca			; $6dc0
	ld ($0a09),sp		; $6dc1
	dec bc			; $6dc4
	ld a,(bc)		; $6dc5
	add hl,bc		; $6dc6
	ld ($0607),sp		; $6dc7
	ld b,$06		; $6dca
	ld (bc),a		; $6dcc
	ld (bc),a		; $6dcd
	ld (bc),a		; $6dce
	ld (bc),a		; $6dcf
	inc b			; $6dd0
	ld b,$08		; $6dd1
	ld a,(bc)		; $6dd3
	dec c			; $6dd4
	ld a,(bc)		; $6dd5
	ld ($0406),sp		; $6dd6
	ld (bc),a		; $6dd9
	ld (bc),a		; $6dda
	ld (bc),a		; $6ddb
	ld (bc),a		; $6ddc
	ld (bc),a		; $6ddd
	ld (bc),a		; $6dde
	ld (bc),a		; $6ddf
	inc b			; $6de0
	ld b,$08		; $6de1
	ld a,(bc)		; $6de3
	dec c			; $6de4
	ld a,(bc)		; $6de5
	ld ($0406),sp		; $6de6
	ld (bc),a		; $6de9
	ld (bc),a		; $6dea
	ld (bc),a		; $6deb
specialObjectCode_linkInCutscene:
	ld e,$02		; $6dec
	ld a,(de)		; $6dee
	rst_jumpTable			; $6def
	ld b,$6e		; $6df0
	ld de,$096f		; $6df2
	ld (hl),c		; $6df5
	or b			; $6df6
	ld (hl),c		; $6df7
	inc c			; $6df8
	ld (hl),d		; $6df9
	sbc a			; $6dfa
	ld (hl),d		; $6dfb
.DB $eb				; $6dfc
	ld (hl),d		; $6dfd
	ld (hl),e		; $6dfe
	ld (hl),e		; $6dff
	adc a			; $6e00
	ld (hl),e		; $6e01
	or l			; $6e02
	ld (hl),e		; $6e03
	ld d,d			; $6e04
	ld (hl),h		; $6e05
	ld e,$04		; $6e06
	ld a,(de)		; $6e08
	rst_jumpTable			; $6e09
	ld c,$6e		; $6e0a
	jr _label_06_236		; $6e0c
	call $7381		; $6e0e
	call objectSetVisible81		; $6e11
	xor a			; $6e14
	call specialObjectSetAnimation		; $6e15
	ld e,$05		; $6e18
	ld a,(de)		; $6e1a
	rst_jumpTable			; $6e1b
	ldi a,(hl)		; $6e1c
	ld l,(hl)		; $6e1d
	ld d,(hl)		; $6e1e
	ld l,(hl)		; $6e1f
	ld l,l			; $6e20
	ld l,(hl)		; $6e21
	add e			; $6e22
	ld l,(hl)		; $6e23
	sbc e			; $6e24
	ld l,(hl)		; $6e25
	xor c			; $6e26
	ld l,(hl)		; $6e27
	ld hl,sp+$6e		; $6e28
	ld a,($cc47)		; $6e2a
	rlca			; $6e2d
	ld a,$00		; $6e2e
	jp c,specialObjectSetAnimation		; $6e30
	ld h,d			; $6e33
	ld l,$0b		; $6e34
	ld a,($cc45)		; $6e36
	bit 7,a			; $6e39
	jr z,_label_06_234	; $6e3b
	inc (hl)		; $6e3d
_label_06_234:
	bit 6,a			; $6e3e
	jr z,_label_06_235	; $6e40
	dec (hl)		; $6e42
_label_06_235:
	ld a,(hl)		; $6e43
	cp $40			; $6e44
	jp nc,specialObjectAnimate		; $6e46
	ld a,$01		; $6e49
	ld ($cbb9),a		; $6e4b
	ld a,$77		; $6e4e
	call playSound		; $6e50
	jp itemIncState2		; $6e53
	ld a,($cbb9)		; $6e56
	cp $02			; $6e59
	ret nz			; $6e5b
	call itemIncState2		; $6e5c
	ld b,$04		; $6e5f
	call func_2d48		; $6e61
	ld a,b			; $6e64
	ld e,$06		; $6e65
	ld (de),a		; $6e67
	ld a,$04		; $6e68
	jp specialObjectSetAnimation		; $6e6a
	call itemDecCounter1		; $6e6d
	jp nz,specialObjectAnimate		; $6e70
	ld l,$10		; $6e73
	ld (hl),$05		; $6e75
	ld b,$05		; $6e77
	call func_2d48		; $6e79
_label_06_236:
	ld a,b			; $6e7c
	ld e,$06		; $6e7d
	ld (de),a		; $6e7f
	jp itemIncState2		; $6e80
	call itemDecCounter1		; $6e83
	jp nz,$6e95		; $6e86
	call itemIncState2		; $6e89
	ld b,$07		; $6e8c
	call func_2d48		; $6e8e
	ld a,b			; $6e91
	ld e,$06		; $6e92
	ld (de),a		; $6e94
	ld hl,$6ee0		; $6e95
	jp $6ec9		; $6e98
	call itemDecCounter1		; $6e9b
	jp nz,$6ec6		; $6e9e
	ld a,$03		; $6ea1
	ld ($cbb9),a		; $6ea3
	call itemIncState2		; $6ea6
	ld a,($cbb9)		; $6ea9
	cp $06			; $6eac
	jr nz,_label_06_238	; $6eae
	ld bc,$8406		; $6eb0
	call objectCreateInteraction		; $6eb3
	jr nz,_label_06_237	; $6eb6
	ld l,$56		; $6eb8
	ld a,$00		; $6eba
	ldi (hl),a		; $6ebc
	ld (hl),d		; $6ebd
_label_06_237:
	call itemIncState2		; $6ebe
	ld a,$05		; $6ec1
	jp specialObjectSetAnimation		; $6ec3
_label_06_238:
	ld hl,$6ee8		; $6ec6
	ld a,($cbb7)		; $6ec9
	ld b,a			; $6ecc
	and $07			; $6ecd
	jr nz,_label_06_239	; $6ecf
	ld a,b			; $6ed1
	and $38			; $6ed2
	swap a			; $6ed4
	rlca			; $6ed6
	rst_addAToHl			; $6ed7
	ld e,$0f		; $6ed8
	ld a,(de)		; $6eda
	add (hl)		; $6edb
	ld (de),a		; $6edc
_label_06_239:
	jp specialObjectAnimate		; $6edd
	rst $38			; $6ee0
	cp $fe			; $6ee1
	rst $38			; $6ee3
	nop			; $6ee4
	ld bc,$0001		; $6ee5
	rst $38			; $6ee8
	rst $38			; $6ee9
	rst $38			; $6eea
	nop			; $6eeb
	ld bc,$0101		; $6eec
	nop			; $6eef
	ld (bc),a		; $6ef0
	inc bc			; $6ef1
	inc b			; $6ef2
	inc bc			; $6ef3
	ld (bc),a		; $6ef4
	nop			; $6ef5
	rst $38			; $6ef6
	nop			; $6ef7
	ld e,$21		; $6ef8
	ld a,(de)		; $6efa
	inc a			; $6efb
	jr nz,_label_06_240	; $6efc
	ld a,$07		; $6efe
	ld ($cbb9),a		; $6f00
	ret			; $6f03
_label_06_240:
	call specialObjectAnimate		; $6f04
	ld a,($cbb7)		; $6f07
	rrca			; $6f0a
	jp nc,objectSetInvisible		; $6f0b
	jp objectSetVisible		; $6f0e
	ld e,$04		; $6f11
	ld a,(de)		; $6f13
	rst_jumpTable			; $6f14
	add hl,de		; $6f15
	ld l,a			; $6f16
	inc e			; $6f17
	ld l,a			; $6f18
	jp $7381		; $6f19
	ld e,$05		; $6f1c
	ld a,(de)		; $6f1e
	rst_jumpTable			; $6f1f
	ld c,h			; $6f20
	ld l,a			; $6f21
	ld a,e			; $6f22
	ld l,a			; $6f23
	adc l			; $6f24
	ld l,a			; $6f25
	and b			; $6f26
	ld l,a			; $6f27
	or (hl)			; $6f28
	ld l,a			; $6f29
	rst_jumpTable			; $6f2a
	ld l,a			; $6f2b
	call nc,$e16f		; $6f2c
	ld l,a			; $6f2f
	or $6f			; $6f30
	rst $38			; $6f32
	ld l,a			; $6f33
	inc de			; $6f34
	ld (hl),b		; $6f35
	rra			; $6f36
	ld (hl),b		; $6f37
	ldd (hl),a		; $6f38
	ld (hl),b		; $6f39
	ld h,c			; $6f3a
	ld (hl),b		; $6f3b
	halt			; $6f3c
	ld (hl),b		; $6f3d
	add d			; $6f3e
	ld (hl),b		; $6f3f
	and b			; $6f40
	ld (hl),b		; $6f41
	or a			; $6f42
	ld (hl),b		; $6f43
	ret z			; $6f44
	ld (hl),b		; $6f45
	push de			; $6f46
	ld (hl),b		; $6f47
.DB $f4				; $6f48
	ld (hl),b		; $6f49
	ld h,b			; $6f4a
	ld (hl),b		; $6f4b
	ld a,($cfd0)		; $6f4c
	or a			; $6f4f
	ret nz			; $6f50
	call itemIncState2		; $6f51
	ld l,$06		; $6f54
	ld (hl),$aa		; $6f56
	ld l,$0b		; $6f58
	ld a,$30		; $6f5a
	ldi (hl),a		; $6f5c
	inc l			; $6f5d
	ld a,$50		; $6f5e
	ld (hl),a		; $6f60
	ld l,$19		; $6f61
	ld h,(hl)		; $6f63
	ld l,$4b		; $6f64
	ld a,$30		; $6f66
	ldi (hl),a		; $6f68
	inc l			; $6f69
	ld a,$60		; $6f6a
	ld (hl),a		; $6f6c
	ld e,$08		; $6f6d
	xor a			; $6f6f
	ld (de),a		; $6f70
_label_06_241:
	ld a,$07		; $6f71
	call specialObjectSetAnimation		; $6f73
	ld a,$08		; $6f76
	jp $71a4		; $6f78
	call itemDecCounter1		; $6f7b
	jr nz,_label_06_242	; $6f7e
	ld (hl),$1e		; $6f80
	call itemIncState2		; $6f82
	jr _label_06_241		; $6f85
_label_06_242:
	call specialObjectAnimate		; $6f87
	jp $719a		; $6f8a
	call itemDecCounter1		; $6f8d
	ret nz			; $6f90
	ld (hl),$28		; $6f91
	ld a,$10		; $6f93
	call specialObjectSetAnimation		; $6f95
	ld a,$0d		; $6f98
	call $71a4		; $6f9a
	jp itemIncState2		; $6f9d
	call itemDecCounter1		; $6fa0
	ret nz			; $6fa3
	ld (hl),$3c		; $6fa4
	call itemIncState2		; $6fa6
	ld bc,$0c17		; $6fa9
	call checkIsLinkedGame		; $6fac
	jr z,_label_06_243	; $6faf
	ld c,$18		; $6fb1
_label_06_243:
	jp showText		; $6fb3
	ld a,($cba0)		; $6fb6
	or a			; $6fb9
	ret nz			; $6fba
	call itemDecCounter1		; $6fbb
	ret nz			; $6fbe
	ld (hl),$96		; $6fbf
	call $6f71		; $6fc1
	jp itemIncState2		; $6fc4
	call itemDecCounter1		; $6fc7
	jr nz,_label_06_242	; $6fca
	ld a,$02		; $6fcc
	ld ($cfd0),a		; $6fce
	jp itemIncState2		; $6fd1
	ld a,($cfd0)		; $6fd4
	cp $03			; $6fd7
	jr nz,_label_06_242	; $6fd9
	call $6f71		; $6fdb
	jp itemIncState2		; $6fde
	ld a,($cfd0)		; $6fe1
	cp $04			; $6fe4
	ret nz			; $6fe6
	call itemIncState2		; $6fe7
	ld l,$06		; $6fea
	ld (hl),$5a		; $6fec
	ld l,$08		; $6fee
	ld (hl),$03		; $6ff0
	xor a			; $6ff2
	jp specialObjectSetAnimation		; $6ff3
	call itemDecCounter1		; $6ff6
	ret nz			; $6ff9
	ld (hl),$12		; $6ffa
	jp itemIncState2		; $6ffc
	call itemDecCounter1		; $6fff
	jr nz,_label_06_244	; $7002
	ld (hl),$46		; $7004
	xor a			; $7006
	call specialObjectSetAnimation		; $7007
	jp itemIncState2		; $700a
_label_06_244:
	ld l,$0d		; $700d
	dec (hl)		; $700f
	jp specialObjectAnimate		; $7010
	call itemDecCounter1		; $7013
	ret nz			; $7016
	ld hl,$cfd0		; $7017
	ld (hl),$05		; $701a
	jp itemIncState2		; $701c
	ld hl,$cfd1		; $701f
	bit 6,(hl)		; $7022
	ret z			; $7024
	ld a,$14		; $7025
	ld e,$06		; $7027
	ld (de),a		; $7029
	ld e,$0d		; $702a
	ld a,(de)		; $702c
	dec e			; $702d
	ld (de),a		; $702e
	jp itemIncState2		; $702f
	call itemDecCounter1		; $7032
	jr nz,_label_06_245	; $7035
	ld h,d			; $7037
	ld l,$10		; $7038
	ld (hl),$50		; $703a
	ld l,$09		; $703c
	ld (hl),$0e		; $703e
	ld l,$0d		; $7040
	ld (hl),$40		; $7042
	ld a,$08		; $7044
	call specialObjectSetAnimation		; $7046
	ld bc,$fe80		; $7049
	call objectSetSpeedZ		; $704c
	jp itemIncState2		; $704f
_label_06_245:
	call getRandomNumber		; $7052
	and $0f			; $7055
	sub $08			; $7057
	ld b,a			; $7059
	ld e,$0c		; $705a
	ld a,(de)		; $705c
	inc e			; $705d
	add b			; $705e
	ld (de),a		; $705f
	ret			; $7060
	call objectApplySpeed		; $7061
	ld c,$20		; $7064
	call objectUpdateSpeedZ_paramC		; $7066
	ret nz			; $7069
	call itemIncState2		; $706a
	ld l,$06		; $706d
	ld (hl),$28		; $706f
	ld a,$14		; $7071
	jp specialObjectSetAnimation		; $7073
	call itemDecCounter1		; $7076
	ret nz			; $7079
	ld a,$07		; $707a
	ld ($cfd0),a		; $707c
	jp itemIncState2		; $707f
	ld a,($cfd0)		; $7082
	cp $09			; $7085
	ret nz			; $7087
	call itemIncState2		; $7088
	ld l,$14		; $708b
	ld (hl),$f0		; $708d
	inc l			; $708f
	ld (hl),$fd		; $7090
	ld l,$08		; $7092
	ld (hl),$02		; $7094
	ld a,$0a		; $7096
	call specialObjectSetAnimation		; $7098
	ld a,$53		; $709b
	jp playSound		; $709d
	call specialObjectAnimate		; $70a0
	ld c,$20		; $70a3
	call objectUpdateSpeedZ_paramC		; $70a5
	ret nz			; $70a8
	call itemIncState2		; $70a9
	ld l,$06		; $70ac
	ld (hl),$1e		; $70ae
	xor a			; $70b0
	ld l,$08		; $70b1
	ld (hl),a		; $70b3
	jp specialObjectSetAnimation		; $70b4
	call itemDecCounter1		; $70b7
	ret nz			; $70ba
	ld (hl),$19		; $70bb
	ld l,$10		; $70bd
	ld (hl),$50		; $70bf
	ld l,$09		; $70c1
	ld (hl),$02		; $70c3
	jp itemIncState2		; $70c5
	call specialObjectAnimate		; $70c8
	call objectApplySpeed		; $70cb
	call itemDecCounter1		; $70ce
	ret nz			; $70d1
	jp $7025		; $70d2
	call itemDecCounter1		; $70d5
	jp nz,$7052		; $70d8
	ld e,$10		; $70db
	ld a,$78		; $70dd
	ld (de),a		; $70df
	ld e,$09		; $70e0
	ld a,$19		; $70e2
	ld (de),a		; $70e4
	ld e,$08		; $70e5
	xor a			; $70e7
	ld (de),a		; $70e8
	ld ($cd00),a		; $70e9
	ld a,$08		; $70ec
	call specialObjectSetAnimation		; $70ee
	jp itemIncState2		; $70f1
	call specialObjectAnimate		; $70f4
	call objectApplySpeed		; $70f7
	call objectApplySpeed		; $70fa
	call objectCheckWithinScreenBoundary		; $70fd
	ret c			; $7100
	ld a,$0a		; $7101
	ld ($cfd0),a		; $7103
	jp itemIncState2		; $7106
	ld e,$04		; $7109
	ld a,(de)		; $710b
	rst_jumpTable			; $710c
	ld de,$1971		; $710d
	ld (hl),c		; $7110
	call $7381		; $7111
	ld a,$09		; $7114
	call specialObjectSetAnimation		; $7116
	ld e,$05		; $7119
	ld a,(de)		; $711b
	rst_jumpTable			; $711c
	dec h			; $711d
	ld (hl),c		; $711e
	ld c,h			; $711f
	ld (hl),c		; $7120
	ld e,b			; $7121
	ld (hl),c		; $7122
	ld l,l			; $7123
	ld (hl),c		; $7124
	ld hl,$cfd0		; $7125
	ld a,(hl)		; $7128
	cp $01			; $7129
	ret nz			; $712b
	call specialObjectAnimate		; $712c
	ld e,$21		; $712f
	ld a,(de)		; $7131
	inc a			; $7132
	ret nz			; $7133
	call itemIncState2		; $7134
	ld l,$14		; $7137
	ld (hl),$f0		; $7139
	inc l			; $713b
	ld (hl),$fd		; $713c
	ld l,$08		; $713e
	ld (hl),$02		; $7140
	ld a,$0a		; $7142
	call specialObjectSetAnimation		; $7144
	ld a,$53		; $7147
	call playSound		; $7149
	call $7178		; $714c
	ret nz			; $714f
	call itemIncState2		; $7150
	ld l,$06		; $7153
	ld (hl),$1e		; $7155
	ret			; $7157
	call itemDecCounter1		; $7158
	ret nz			; $715b
	ld hl,$cfd0		; $715c
	ld (hl),$02		; $715f
	call itemIncState2		; $7161
	ld l,$08		; $7164
	ld (hl),$03		; $7166
	ld a,$00		; $7168
	jp specialObjectSetAnimation		; $716a
	ld a,($cfd0)		; $716d
	cp $03			; $7170
	ret nz			; $7172
	ld a,$00		; $7173
	jp setLinkIDOverride		; $7175
	call specialObjectAnimate		; $7178
	ld c,$20		; $717b
	call objectUpdateSpeedZ_paramC		; $717d
	jr z,_label_06_246	; $7180
	ld h,d			; $7182
	ld l,$15		; $7183
	ld a,(hl)		; $7185
	bit 7,a			; $7186
	ret nz			; $7188
	cp $03			; $7189
	ret c			; $718b
	ld l,$14		; $718c
	xor a			; $718e
	ldi (hl),a		; $718f
	ld a,$03		; $7190
	ld (hl),a		; $7192
	or a			; $7193
	ret			; $7194
_label_06_246:
	ld a,$00		; $7195
	jp specialObjectSetAnimation		; $7197
	push de			; $719a
	ld e,$19		; $719b
	ld a,(de)		; $719d
	ld d,a			; $719e
	call interactionAnimate		; $719f
	pop de			; $71a2
	ret			; $71a3
	ld b,a			; $71a4
	push de			; $71a5
	ld e,$19		; $71a6
	ld a,(de)		; $71a8
	ld d,a			; $71a9
	ld a,b			; $71aa
	call interactionSetAnimation		; $71ab
	pop de			; $71ae
	ret			; $71af
	ld e,$04		; $71b0
	ld a,(de)		; $71b2
	rst_jumpTable			; $71b3
	cp b			; $71b4
	ld (hl),c		; $71b5
	call nz,$cd71		; $71b6
	add c			; $71b9
	ld (hl),e		; $71ba
	ld l,$06		; $71bb
	ld (hl),$a8		; $71bd
	ld a,$0c		; $71bf
	jp specialObjectSetAnimation		; $71c1
	ld e,$05		; $71c4
	ld a,(de)		; $71c6
	rst_jumpTable			; $71c7
	ret nc			; $71c8
	ld (hl),c		; $71c9
	and $71			; $71ca
.DB $f4				; $71cc
	ld (hl),c		; $71cd
	ld (bc),a		; $71ce
	ld (hl),d		; $71cf
	call itemDecCounter1		; $71d0
	jr nz,_label_06_247	; $71d3
	ld a,$80		; $71d5
	ld ($cfc0),a		; $71d7
	call itemIncState2		; $71da
	ld bc,$ff00		; $71dd
	call objectSetSpeedZ		; $71e0
_label_06_247:
	jp specialObjectAnimate		; $71e3
	ld c,$20		; $71e6
	call objectUpdateSpeedZ_paramC		; $71e8
	ret nz			; $71eb
	call itemIncState2		; $71ec
	ld l,$06		; $71ef
	ld (hl),$0a		; $71f1
	ret			; $71f3
	call itemDecCounter1		; $71f4
	ret nz			; $71f7
	ld (hl),$78		; $71f8
	call itemIncState2		; $71fa
	ld a,$0c		; $71fd
	jp specialObjectSetAnimation		; $71ff
	call itemDecCounter1		; $7202
	ret nz			; $7205
	ld a,$01		; $7206
	ld ($cfdf),a		; $7208
	ret			; $720b
	ld e,$04		; $720c
	ld a,(de)		; $720e
	rst_jumpTable			; $720f
	inc d			; $7210
	ld (hl),d		; $7211
	jr z,_label_06_248	; $7212
	call $7381		; $7214
	ld l,$09		; $7217
	ld (hl),$00		; $7219
	ld l,$10		; $721b
	ld (hl),$28		; $721d
	ld l,$06		; $721f
	ld (hl),$80		; $7221
	ld a,$00		; $7223
	jp specialObjectSetAnimation		; $7225
	ld e,$05		; $7228
	ld a,(de)		; $722a
	rst_jumpTable			; $722b
	jr c,$72		; $722c
	ld c,h			; $722e
	ld (hl),d		; $722f
	ld e,d			; $7230
	ld (hl),d		; $7231
	ld h,(hl)		; $7232
	ld (hl),d		; $7233
	ld a,(hl)		; $7234
	ld (hl),d		; $7235
	sub e			; $7236
	ld (hl),d		; $7237
	ld a,($c4ab)		; $7238
	or a			; $723b
	ret nz			; $723c
	call specialObjectAnimate		; $723d
	call objectApplySpeed		; $7240
	call itemDecCounter1		; $7243
	ret nz			; $7246
	ld (hl),$06		; $7247
	jp itemIncState2		; $7249
	call itemDecCounter1		; $724c
	ret nz			; $724f
	ld (hl),$78		; $7250
	call itemIncState2		; $7252
	ld a,$03		; $7255
	jp specialObjectSetAnimation		; $7257
	call itemDecCounter1		; $725a
	ret nz			; $725d
	ld hl,$cfc0		; $725e
	ld (hl),$01		; $7261
	jp itemIncState2		; $7263
	ld a,($cfc0)		; $7266
	cp $02			; $7269
	ret nz			; $726b
	call itemIncState2		; $726c
	ld l,$09		; $726f
	ld (hl),$10		; $7271
	ld bc,$ff00		; $7273
	call objectSetSpeedZ		; $7276
	ld a,$0d		; $7279
	jp specialObjectSetAnimation		; $727b
	call objectApplySpeed		; $727e
	ld c,$20		; $7281
	call objectUpdateSpeedZ_paramC		; $7283
_label_06_248:
	ret nz			; $7286
	call itemIncState2		; $7287
	ld l,$06		; $728a
	ld (hl),$78		; $728c
	ld l,$20		; $728e
	ld (hl),$01		; $7290
	ret			; $7292
	call itemDecCounter1		; $7293
	jp nz,specialObjectAnimate		; $7296
	ld hl,$cfdf		; $7299
	ld (hl),$01		; $729c
	ret			; $729e
	ld e,$04		; $729f
	ld a,(de)		; $72a1
	rst_jumpTable			; $72a2
	and a			; $72a3
	ld (hl),d		; $72a4
	or e			; $72a5
	ld (hl),d		; $72a6
	call $7381		; $72a7
	ld l,$06		; $72aa
	ld (hl),$f0		; $72ac
	ld a,$03		; $72ae
	jp specialObjectSetAnimation		; $72b0
	ld e,$05		; $72b3
	ld a,(de)		; $72b5
	rst_jumpTable			; $72b6
	cp e			; $72b7
	ld (hl),d		; $72b8
	pop hl			; $72b9
	ld (hl),d		; $72ba
	ld a,($c4ab)		; $72bb
	or a			; $72be
	ret nz			; $72bf
	call itemDecCounter1		; $72c0
	ret nz			; $72c3
	ld l,$06		; $72c4
	ld (hl),$3c		; $72c6
	call itemIncState2		; $72c8
	ld hl,$cfc0		; $72cb
	ld (hl),$01		; $72ce
	ld bc,$f804		; $72d0
	ld a,$ff		; $72d3
	call objectCreateExclamationMark		; $72d5
	ld l,$42		; $72d8
	ld (hl),$01		; $72da
	ld a,$0e		; $72dc
	jp specialObjectSetAnimation		; $72de
	call itemDecCounter1		; $72e1
	ret nz			; $72e4
	ld hl,$cfdf		; $72e5
	ld (hl),$01		; $72e8
	ret			; $72ea
	ld e,$04		; $72eb
	ld a,(de)		; $72ed
	rst_jumpTable			; $72ee
	di			; $72ef
	ld (hl),d		; $72f0
	rrca			; $72f1
	ld (hl),e		; $72f2
	call $7381		; $72f3
	call objectSetInvisible		; $72f6
	call $7305		; $72f9
	ld a,$0b		; $72fc
	jr nz,_label_06_249	; $72fe
	ld a,$0f		; $7300
_label_06_249:
	jp specialObjectSetAnimation		; $7302
	ld hl,$c680		; $7305
	ld a,$01		; $7308
	cp (hl)			; $730a
	ret z			; $730b
	inc l			; $730c
	cp (hl)			; $730d
	ret			; $730e
	ld e,$05		; $730f
	ld a,(de)		; $7311
	rst_jumpTable			; $7312
	dec de			; $7313
	ld (hl),e		; $7314
	daa			; $7315
	ld (hl),e		; $7316
	dec sp			; $7317
	ld (hl),e		; $7318
	ld h,e			; $7319
	ld (hl),e		; $731a
	ld a,($cfc0)		; $731b
	cp $01			; $731e
	ret nz			; $7320
	call itemIncState2		; $7321
	jp objectSetVisible		; $7324
	ld a,($cfc0)		; $7327
	cp $07			; $732a
	ret nz			; $732c
	call itemIncState2		; $732d
	call $7305		; $7330
	ld a,$10		; $7333
	jr nz,_label_06_250	; $7335
	inc a			; $7337
_label_06_250:
	jp specialObjectSetAnimation		; $7338
	ld a,($cfc0)		; $733b
	cp $08			; $733e
	ret nz			; $7340
	call itemIncState2		; $7341
	ld l,$06		; $7344
	ld (hl),$68		; $7346
	inc l			; $7348
	ld (hl),$01		; $7349
	ld b,$02		; $734b
_label_06_251:
	call getFreeInteractionSlot		; $734d
	jr nz,_label_06_252	; $7350
	ld (hl),$b7		; $7352
	inc l			; $7354
	ld a,b			; $7355
	dec a			; $7356
	ld (hl),a		; $7357
	call objectCopyPosition		; $7358
	dec b			; $735b
	jr nz,_label_06_251	; $735c
_label_06_252:
	ld a,$12		; $735e
	jp specialObjectSetAnimation		; $7360
	call specialObjectAnimate		; $7363
	ld h,d			; $7366
	ld l,$06		; $7367
	call decHlRef16WithCap		; $7369
	ret nz			; $736c
	ld hl,$cfc0		; $736d
	ld (hl),$09		; $7370
	ret			; $7372
	ld e,$04		; $7373
	ld a,(de)		; $7375
	rst_jumpTable			; $7376
	ld a,e			; $7377
	ld (hl),e		; $7378
	ld ($cd72),a		; $7379
	add c			; $737c
	ld (hl),e		; $737d
	jp $72d0		; $737e
	ld hl,$41b5		; $7381
	ld e,$05		; $7384
	call interBankCall		; $7386
	call objectSetVisiblec1		; $7389
	jp itemIncState		; $738c
	ld e,$04		; $738f
	ld a,(de)		; $7391
	rst_jumpTable			; $7392
	sub a			; $7393
	ld (hl),e		; $7394
	and e			; $7395
	ld (hl),e		; $7396
	call $7381		; $7397
	ld l,$10		; $739a
	ld (hl),$28		; $739c
	ld a,$00		; $739e
	call specialObjectSetAnimation		; $73a0
	call specialObjectAnimate		; $73a3
	call $74ee		; $73a6
	call $7520		; $73a9
	call $7501		; $73ac
	ret nc			; $73af
	ld a,$00		; $73b0
	jp setLinkIDOverride		; $73b2
	ld e,$04		; $73b5
	ld a,(de)		; $73b7
	rst_jumpTable			; $73b8
	cp l			; $73b9
	ld (hl),e		; $73ba
	jp z,$cd73		; $73bb
	add c			; $73be
	ld (hl),e		; $73bf
	push de			; $73c0
	call clearItems		; $73c1
	pop de			; $73c4
	ld a,$13		; $73c5
	jp specialObjectSetAnimation		; $73c7
	ld e,$05		; $73ca
	ld a,(de)		; $73cc
	rst_jumpTable			; $73cd
	call c,$f173		; $73ce
	ld (hl),e		; $73d1
.DB $fc				; $73d2
	ld (hl),e		; $73d3
	ld d,$74		; $73d4
	dec l			; $73d6
	ld (hl),h		; $73d7
	dec sp			; $73d8
	ld (hl),h		; $73d9
	ld d,c			; $73da
	ld (hl),h		; $73db
	ld a,($cfd1)		; $73dc
	or a			; $73df
	ret z			; $73e0
	call itemIncState2		; $73e1
	ld l,$06		; $73e4
	ld (hl),$28		; $73e6
	ld l,$10		; $73e8
	ld (hl),$05		; $73ea
	ld l,$09		; $73ec
	ld (hl),$10		; $73ee
	ret			; $73f0
	call itemDecCounter1		; $73f1
	jp nz,objectApplySpeed		; $73f4
	ld (hl),$19		; $73f7
	jp itemIncState2		; $73f9
	call itemDecCounter1		; $73fc
	ret nz			; $73ff
	call itemIncState2		; $7400
	ld l,$10		; $7403
	ld (hl),$78		; $7405
	ld l,$09		; $7407
	xor a			; $7409
	ld (hl),a		; $740a
	ld l,$0f		; $740b
	ld (hl),$fa		; $740d
_label_06_253:
	ld l,$20		; $740f
	ld (hl),$01		; $7411
	jp specialObjectAnimate		; $7413
	call objectApplySpeed		; $7416
	ld e,$0b		; $7419
	ld a,(de)		; $741b
	cp $10			; $741c
	ret nc			; $741e
	ld a,$82		; $741f
	call playSound		; $7421
	call itemIncState2		; $7424
	ld l,$06		; $7427
	ld (hl),$1e		; $7429
	jr _label_06_253		; $742b
	call itemDecCounter1		; $742d
	jr nz,_label_06_254	; $7430
	call itemIncState2		; $7432
	ld bc,$ff40		; $7435
	jp objectSetSpeedZ		; $7438
	ld c,$10		; $743b
	call objectUpdateSpeedZ_paramC		; $743d
	ret nz			; $7440
	call itemIncState2		; $7441
	jr _label_06_253		; $7444
_label_06_254:
	ld a,(wFrameCounter)		; $7446
	and $03			; $7449
	ret nz			; $744b
	ld a,$04		; $744c
	ld ($cd18),a		; $744e
	ret			; $7451
	ld e,$04		; $7452
	ld a,(de)		; $7454
	rst_jumpTable			; $7455
	ld e,d			; $7456
	ld (hl),h		; $7457
	add (hl)		; $7458
	ld (hl),h		; $7459
	call $7381		; $745a
	call objectSetVisible81		; $745d
	ld l,$06		; $7460
	ld (hl),$2c		; $7462
	inc hl			; $7464
	ld (hl),$01		; $7465
	ld l,$0b		; $7467
	ld (hl),$d0		; $7469
	ld l,$0d		; $746b
	ld (hl),$50		; $746d
	ld a,$08		; $746f
	call specialObjectSetAnimation		; $7471
	xor a			; $7474
	ld ($cbb9),a		; $7475
	ld bc,$8409		; $7478
	call objectCreateInteraction		; $747b
	jr nz,_label_06_255	; $747e
	ld l,$56		; $7480
	ld a,$00		; $7482
	ldi (hl),a		; $7484
	ld (hl),d		; $7485
_label_06_255:
	ld a,(wFrameCounter)		; $7486
	ld ($cbb7),a		; $7489
	ld e,$05		; $748c
	ld a,(de)		; $748e
	rst_jumpTable			; $748f
	sbc b			; $7490
	ld (hl),h		; $7491
	and a			; $7492
	ld (hl),h		; $7493
	or a			; $7494
	ld (hl),h		; $7495
	rst $8			; $7496
	ld (hl),h		; $7497
	call $74e8		; $7498
	ld hl,$d006		; $749b
	call decHlRef16WithCap		; $749e
	ret nz			; $74a1
	ld (hl),$3c		; $74a2
	jp itemIncState2		; $74a4
	call $74e8		; $74a7
	call itemDecCounter1		; $74aa
	ret nz			; $74ad
	call itemIncState2		; $74ae
	ld bc,$0c16		; $74b1
	jp showText		; $74b4
	ld hl,$6ee8		; $74b7
	call $6ec9		; $74ba
	ld a,($cba0)		; $74bd
	or a			; $74c0
	ret nz			; $74c1
	ld a,$06		; $74c2
	ld ($cbb9),a		; $74c4
	ld a,$91		; $74c7
	call playSound		; $74c9
	jp $6eb0		; $74cc
	ld e,$21		; $74cf
	ld a,(de)		; $74d1
	inc a			; $74d2
	jr nz,_label_06_256	; $74d3
	ld a,$07		; $74d5
	ld ($cbb9),a		; $74d7
	ret			; $74da
_label_06_256:
	call specialObjectAnimate		; $74db
	ld a,(wFrameCounter)		; $74de
	rrca			; $74e1
	jp nc,objectSetInvisible		; $74e2
	jp objectSetVisible		; $74e5
	ld hl,$6ef0		; $74e8
	jp $6ec9		; $74eb
	ld e,$03		; $74ee
	ld a,(de)		; $74f0
	ld hl,$751e		; $74f1
	rst_addDoubleIndex			; $74f4
	ld b,(hl)		; $74f5
	inc hl			; $74f6
	ld c,(hl)		; $74f7
	call objectGetRelativeAngle		; $74f8
	ld e,$09		; $74fb
	ld (de),a		; $74fd
	jp objectApplySpeed		; $74fe
	ld e,$03		; $7501
	ld a,(de)		; $7503
	ld bc,$751e		; $7504
	call addDoubleIndexToBc		; $7507
	ld h,d			; $750a
	ld l,$0b		; $750b
	ld a,(bc)		; $750d
	sub (hl)		; $750e
	add $01			; $750f
	cp $03			; $7511
	ret nc			; $7513
	inc bc			; $7514
	ld l,$0d		; $7515
	ld a,(bc)		; $7517
	sub (hl)		; $7518
	add $01			; $7519
	cp $03			; $751b
	ret			; $751d
	ld c,b			; $751e
	ld d,b			; $751f
	ld a,(wFrameCounter)		; $7520
	and $07			; $7523
	ret nz			; $7525
	ld e,$09		; $7526
	ld a,(de)		; $7528
	ld hl,$7532		; $7529
	rst_addAToHl			; $752c
	ld a,(hl)		; $752d
	ld e,$08		; $752e
	ld (de),a		; $7530
	ret			; $7531
	nop			; $7532
	nop			; $7533
	ld bc,$0101		; $7534
	ld bc,$0101		; $7537
	ld bc,$0101		; $753a
	ld bc,$0101		; $753d
	ld bc,$0202		; $7540
	ld (bc),a		; $7543
	inc bc			; $7544
	inc bc			; $7545
	inc bc			; $7546
	inc bc			; $7547
	inc bc			; $7548
	inc bc			; $7549
	inc bc			; $754a
	inc bc			; $754b
	inc bc			; $754c
	inc bc			; $754d
	inc bc			; $754e
	inc bc			; $754f
	inc bc			; $7550
	nop			; $7551

	.include "build/data/signText.s"

_breakableTileCollisionTable:
	.dw _breakableTileCollision0
	.dw _breakableTileCollision1
	.dw _breakableTileCollision2
	.dw _breakableTileCollision3
	.dw _breakableTileCollision4
	.dw _breakableTileCollision5

_breakableTileCollision0:
_breakableTileCollision2:
	.db $f8 $00
	.db $f2 $0d
	.db $c4 $01
	.db $c5 $02
	.db $c6 $03
	.db $c7 $04
	.db $e5 $05
	.db $d8 $06
	.db $c3 $06
	.db $c8 $07
	.db $c9 $08
	.db $c0 $09
	.db $c1 $0a
	.db $c2 $0b
	.db $e2 $0c
	.db $d9 $0e
	.db $da $0f
	.db $db $10
	.db $ca $11
	.db $cb $12
	.db $d7 $13
	.db $e3 $15
	.db $01 $14
	.db $04 $14
	.db $05 $14
	.db $06 $14
	.db $07 $14
	.db $08 $14
	.db $09 $14
	.db $0a $14
	.db $0b $14
	.db $0c $14
	.db $0d $14
	.db $0e $14
	.db $0f $14
	.db $11 $14
	.db $12 $14
	.db $13 $14
	.db $14 $14
	.db $15 $14
	.db $16 $14
	.db $17 $14
	.db $18 $14
	.db $19 $14
	.db $1a $14
	.db $1b $14
	.db $1c $14
	.db $1d $14
	.db $1e $14
	.db $4d $14
	.db $4e $14
	.db $5d $14
	.db $5e $14
	.db $5f $14
	.db $6d $14
	.db $6e $14
	.db $6f $14
	.db $af $14
	.db $bf $14
	.db $00
_breakableTileCollision1:
	.db $f8 $00
	.db $f9 $00
	.db $f2 $0d
	.db $e9 $09
	.db $01 $17
	.db $04 $17
	.db $05 $17
	.db $06 $17
	.db $07 $17
	.db $08 $17
	.db $09 $17
	.db $0a $17
	.db $0b $17
	.db $0c $17
	.db $0d $17
	.db $0e $17
	.db $0f $17
	.db $11 $17
	.db $12 $17
	.db $13 $17
	.db $14 $17
	.db $15 $17
	.db $16 $17
	.db $17 $17
	.db $18 $17
	.db $19 $17
	.db $1a $17
	.db $1b $17
	.db $1c $17
	.db $1d $17
	.db $1e $17
	.db $1f $17
	.db $20 $17
	.db $21 $17
	.db $22 $17
	.db $23 $17
	.db $24 $17
	.db $25 $17
	.db $26 $17
	.db $27 $17
	.db $28 $17
	.db $29 $17
	.db $2a $17
	.db $2b $17
	.db $2c $17
	.db $2d $17
	.db $2e $17
	.db $b8 $18
	.db $b9 $18
	.db $bb $17
	.db $bc $17
	.db $bd $17
	.db $be $17
	.db $bf $17
	.db $2f $16
	.db $00
_breakableTileCollision3:
_breakableTileCollision4:
	.db $f8 $2d
	.db $20 $19
	.db $21 $1a
	.db $22 $1b
	.db $23 $1c
	.db $ef $2e
	.db $11 $1d
	.db $12 $1e
	.db $10 $1f
	.db $13 $20
	.db $1f $21
	.db $30 $22
	.db $31 $23
	.db $32 $24
	.db $33 $25
	.db $38 $26
	.db $39 $27
	.db $3a $28
	.db $3b $29
	.db $16 $2a
	.db $15 $2b
	.db $2b $2c
	.db $2a $2c
	.db $00
_breakableTileCollision5:
	.db $12 $2f
	.db $00

; See ages for documentation on this macro
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

; @addr{76e4}
_breakableTileModes:
	m_BreakableTileData %10010110 %00110000 %0010 $1 $10 $04 ; $00
	m_BreakableTileData %10110111 %10110001 %0110 $1 $00 $04 ; $01
	m_BreakableTileData %10110111 %10110001 %0110 $0 $c0 $e6 ; $02
	m_BreakableTileData %10110111 %10110001 %0110 $0 $c0 $e0 ; $03
	m_BreakableTileData %10110111 %10110001 %0110 $0 $00 $f3 ; $04
	m_BreakableTileData %10110111 %10110001 %0110 $0 $00 $04 ; $05
	m_BreakableTileData %10110110 %10110001 %0110 $4 $01 $04 ; $06
	m_BreakableTileData %11110110 %00110000 %0010 $3 $00 $04 ; $07
	m_BreakableTileData %11110110 %00110000 %1011 $0 $00 $f3 ; $08
	m_BreakableTileData %00100001 %00000000 %0000 $4 $06 $04 ; $09
	m_BreakableTileData %00100001 %00000000 %0000 $0 $c6 $e7 ; $0a
	m_BreakableTileData %00100001 %00000000 %0000 $0 $c6 $e0 ; $0b
	m_BreakableTileData %00110000 %10000000 %0000 $0 $c6 $e8 ; $0c
	m_BreakableTileData %10101101 %00010001 %0000 $7 $0c $04 ; $0d
	m_BreakableTileData %01000000 %10000000 %0111 $4 $19 $04 ; $0e
	m_BreakableTileData %01000000 %10000000 %0111 $0 $19 $f3 ; $0f
	m_BreakableTileData %01110000 %00000000 %1011 $0 $1f $fd ; $10
	m_BreakableTileData %00000000 %00010000 %0000 $7 $1f $04 ; $11
	m_BreakableTileData %00000000 %00010000 %0000 $0 $df $e7 ; $12
	m_BreakableTileData %10000001 %00000000 %0100 $8 $1f $04 ; $13
	m_BreakableTileData %01000000 %00000000 %0000 $9 $0a $e1 ; $14
	m_BreakableTileData %01000000 %00000000 %0000 $0 $ca $e0 ; $15
	m_BreakableTileData %01000000 %00000000 %0000 $0 $0a $e1 ; $16
	m_BreakableTileData %01000000 %00000000 %0000 $a $0a $e1 ; $17
	m_BreakableTileData %01000000 %00000000 %0000 $b $0a $e1 ; $18
	m_BreakableTileData %10110111 %00110001 %0100 $1 $00 $a0 ; $19
	m_BreakableTileData %10110111 %00110001 %0100 $0 $00 $a0 ; $1a
	m_BreakableTileData %10110111 %00110001 %0100 $0 $40 $45 ; $1b
	m_BreakableTileData %10110111 %00110001 %0100 $0 $00 $f3 ; $1c
	m_BreakableTileData %00100101 %00000001 %0000 $0 $06 $a0 ; $1d
	m_BreakableTileData %00100101 %00000001 %0000 $0 $46 $45 ; $1e
	m_BreakableTileData %00100101 %00000001 %0000 $2 $06 $a0 ; $1f
	m_BreakableTileData %00100101 %00000001 %0000 $0 $46 $0d ; $20
	m_BreakableTileData %00110000 %00000000 %0000 $0 $06 $a0 ; $21
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $34 ; $22
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $35 ; $23
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $36 ; $24
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $37 ; $25
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $34 ; $26
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $35 ; $27
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $36 ; $28
	m_BreakableTileData %00110000 %00000000 %0000 $0 $c6 $37 ; $29
	m_BreakableTileData %00111111 %00000000 %0000 $0 $06 $a0 ; $2a
	m_BreakableTileData %00100001 %00000000 %0000 $4 $06 $4c ; $2b
	m_BreakableTileData %00000110 %00000000 %0000 $0 $07 $00 ; $2c
	m_BreakableTileData %10010110 %00110000 %0010 $0 $10 $ef ; $2d
	m_BreakableTileData %01000000 %00000000 %0000 $c $0a $4c ; $2e
	m_BreakableTileData %00110000 %00000000 %0000 $0 $06 $01 ; $2f
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

updateItems:
	ld b,$00		; $485a
	ld a,($cd00)		; $485c
	cp $08			; $485f
	jr z,_label_07_056	; $4861
	ld a,($cca4)		; $4863
	and $90			; $4866
	jr nz,_label_07_056	; $4868
	ld a,($c4ab)		; $486a
	or a			; $486d
	jr nz,_label_07_056	; $486e
	ld a,($cba0)		; $4870
	or a			; $4873
	jr z,_label_07_057	; $4874
_label_07_056:
	inc b			; $4876
_label_07_057:
	ld hl,$cca5		; $4877
	ld a,(hl)		; $487a
	and $fe			; $487b
	or b			; $487d
	ld (hl),a		; $487e
	xor a			; $487f
	ld ($ccf0),a		; $4880
	ld a,$00		; $4883
	ldh (<hActiveObjectType),a	; $4885
	ld d,$d6		; $4887
	ld a,d			; $4889
_label_07_058:
	ldh (<hActiveObject),a	; $488a
	ld e,$00		; $488c
	ld a,(de)		; $488e
	or a			; $488f
	jr z,_label_07_060	; $4890
	ld e,$04		; $4892
	ld a,(de)		; $4894
	or a			; $4895
	jr z,_label_07_059	; $4896
	ld a,($cca5)		; $4898
	or a			; $489b
_label_07_059:
	call z,$48a6		; $489c
_label_07_060:
	inc d			; $489f
	ld a,d			; $48a0
	cp $e0			; $48a1
	jr c,_label_07_058	; $48a3
	ret			; $48a5
	ld e,$01		; $48a6
	ld a,(de)		; $48a8
	rst_jumpTable			; $48a9
	.dw itemCode00 ; 0x00
	.dw itemDelete ; 0x01
	.dw itemCode02 ; 0x02
	.dw itemCode03 ; 0x03
	.dw itemDelete ; 0x04
	.dw itemCode05 ; 0x05
	.dw itemCode06 ; 0x06
	.dw itemCode07 ; 0x07
	.dw itemCode08 ; 0x08
	.dw itemDelete ; 0x09
	.dw itemDelete ; 0x0a
	.dw itemDelete ; 0x0b
	.dw itemCode0c ; 0x0c
	.dw itemCode0d ; 0x0d
	.dw itemDelete ; 0x0e
	.dw itemDelete ; 0x0f
	.dw itemDelete ; 0x10
	.dw itemDelete ; 0x11
	.dw itemDelete ; 0x12
	.dw itemCode13 ; 0x13
	.dw itemDelete ; 0x14
	.dw itemCode15 ; 0x15
	.dw itemCode16 ; 0x16
	.dw itemDelete ; 0x17
	.dw itemDelete ; 0x18
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


updateItemsPost:
	xor a
	ldh (<hActiveObjectType),a	; $4903
	ld d,$d6		; $4905
	ld a,d			; $4907
_label_07_061:
	ldh (<hActiveObject),a	; $4908
	ld e,$00		; $490a
	ld a,(de)		; $490c
	or a			; $490d
	call nz,_updateItemPost		; $490e
	inc d			; $4911
	ld a,d			; $4912
	cp $e0			; $4913
	jr c,_label_07_061	; $4915

itemCodeNilPost:
	ret			; $4917

_updateItemPost:
	ld e,$01		; $4918
	ld a,(de)		; $491a
	rst_jumpTable			; $491b
	.dw itemCode00Post  ; 0x00
	.dw itemCodeNilPost ; 0x01
	.dw itemCode02Post  ; 0x02
	.dw itemCodeNilPost ; 0x03
	.dw itemCode04Post  ; 0x04
	.dw itemCode05Post  ; 0x05
	.dw itemCodeNilPost ; 0x06
	.dw itemCode07Post  ; 0x07
	.dw itemCode08Post  ; 0x08
	.dw itemCodeNilPost ; 0x09
	.dw itemDelete      ; 0x0a
	.dw itemDelete      ; 0x0b
	.dw itemCode0cPost  ; 0x0c
	.dw itemCodeNilPost ; 0x0d
	.dw itemCodeNilPost ; 0x0e
	.dw itemDelete      ; 0x0f
	.dw itemCodeNilPost ; 0x10
	.dw itemCodeNilPost ; 0x11
	.dw itemCodeNilPost ; 0x12
	.dw itemCode13Post  ; 0x13
	.dw itemCodeNilPost ; 0x14
	.dw itemCodeNilPost ; 0x15
	.dw itemCodeNilPost ; 0x16
	.dw itemCodeNilPost ; 0x17
	.dw itemCodeNilPost ; 0x18
	.dw itemCodeNilPost ; 0x19
	.dw itemCodeNilPost ; 0x1a
	.dw itemCodeNilPost ; 0x1b
	.dw itemCodeNilPost ; 0x1c
	.dw itemCode1dPost  ; 0x1d
	.dw itemCode1ePost  ; 0x1e
	.dw itemCodeNilPost ; 0x1f
	.dw itemCodeNilPost ; 0x20
	.dw itemCodeNilPost ; 0x21
	.dw itemCodeNilPost ; 0x22
	.dw itemCodeNilPost ; 0x23
	.dw itemCodeNilPost ; 0x24
	.dw itemCodeNilPost ; 0x25
	.dw itemCodeNilPost ; 0x26
	.dw itemCodeNilPost ; 0x27
	.dw itemCodeNilPost ; 0x28
	.dw itemCodeNilPost ; 0x29
	.dw itemCodeNilPost ; 0x2a
	.dw itemCodeNilPost ; 0x2b

_loadAttributesAndGraphicsAndIncState:
	call itemIncState		; $4974
	ld l,$00		; $4977
	ld (hl),$03		; $4979

_itemLoadAttributesAndGraphics:
	ld e,$01		; $497b
	ld a,(de)		; $497d
	add a			; $497e
	ld hl,itemAttributes		; $497f
	rst_addDoubleIndex			; $4982
	ld e,$24		; $4983
	ldi a,(hl)		; $4985
	ld (de),a		; $4986
	ld e,$26		; $4987
	ld a,(hl)		; $4989
	swap a			; $498a
	and $0f			; $498c
	ld (de),a		; $498e
	inc e			; $498f
	ldi a,(hl)		; $4990
	and $0f			; $4991
	ld (de),a		; $4993
	inc e			; $4994
	ldi a,(hl)		; $4995
	ld (de),a		; $4996
	ld c,a			; $4997
	inc e			; $4998
	ldi a,(hl)		; $4999
	ld (de),a		; $499a
	ld e,$3a		; $499b
	ld a,c			; $499d
	ld (de),a		; $499e
	call $49aa		; $499f
	ld hl,$4422		; $49a2
	ld e,$3f		; $49a5
	jp interBankCall		; $49a7
	ld e,$3c		; $49aa
	ld a,$ff		; $49ac
	ld (de),a		; $49ae
	ret			; $49af

_itemUpdateDamageToApply:
	ld h,d			; $49b0
	ld l,$25		; $49b1
	ld a,(hl)		; $49b3
	ld (hl),$00		; $49b4
	ld l,$29		; $49b6
	add (hl)		; $49b8
	ld (hl),a		; $49b9
	rlca			; $49ba
	ld l,$2a		; $49bb
	ld a,(hl)		; $49bd
	dec a			; $49be
	inc a			; $49bf
	ret			; $49c0

itemAnimate:
	ld h,d			; $49c1
	ld l,$20		; $49c2
	dec (hl)		; $49c4
	ret nz			; $49c5
	ld l,$22		; $49c6
	jr _itemNextAnimationFrame		; $49c8


itemSetAnimation:
	add a			; $49ca
	ld c,a			; $49cb
	ld b,$00		; $49cc
	ld e,$01		; $49ce
	ld a,(de)		; $49d0
	ld hl,$6401		; $49d1
	rst_addDoubleIndex			; $49d4
	ldi a,(hl)		; $49d5
	ld h,(hl)		; $49d6
	ld l,a			; $49d7
	add hl,bc		; $49d8

_itemNextAnimationFrame:
	ldi a,(hl)		; $49d9
	ld h,(hl)		; $49da
	ld l,a			; $49db
	ldi a,(hl)		; $49dc
	cp $ff			; $49dd
	jr nz,_label_07_063	; $49df
	ld b,a			; $49e1
	ld c,(hl)		; $49e2
	add hl,bc		; $49e3
	ldi a,(hl)		; $49e4
_label_07_063:
	ld e,$20		; $49e5
	ld (de),a		; $49e7
	ldi a,(hl)		; $49e8
	ld c,a			; $49e9
	ld b,$00		; $49ea
	inc e			; $49ec
	ldi a,(hl)		; $49ed
	ld (de),a		; $49ee
	inc e			; $49ef
	ld a,l			; $49f0
	ld (de),a		; $49f1
	inc e			; $49f2
	ld a,h			; $49f3
	ld (de),a		; $49f4
	ld e,$01		; $49f5
	ld a,(de)		; $49f7
	ld hl,$6461		; $49f8
	rst_addDoubleIndex			; $49fb
	ldi a,(hl)		; $49fc
	ld h,(hl)		; $49fd
	ld l,a			; $49fe
	add hl,bc		; $49ff

	; Set the address of the oam data
	ld e,$1e		; $4a00
	ldi a,(hl)		; $4a02
	ld (de),a		; $4a03
	inc e			; $4a04
	ldi a,(hl)		; $4a05
	and $3f			; $4a06
	ld (de),a		; $4a08
	ret			; $4a09

_itemTransferKnockbackToLink:
	ld h,d			; $4a0a
	ld l,$2d		; $4a0b
	ld a,(hl)		; $4a0d
	or a			; $4a0e
	ret z			; $4a0f
	ld (hl),$00		; $4a10
	dec l			; $4a12
	ld b,(hl)		; $4a13
	ld hl,$d02d		; $4a14
	cp (hl)			; $4a17
	jr c,_label_07_064	; $4a18
	ld (hl),a		; $4a1a
_label_07_064:
	dec l			; $4a1b
	ld (hl),b		; $4a1c
	ret			; $4a1d

_applyOffsetTableHL:
	ld e,$08		; $4a1e
	ld a,(de)		; $4a20
	ld e,a			; $4a21
	add a			; $4a22
	add e			; $4a23
	rst_addAToHl			; $4a24
	ld e,$0b		; $4a25
	ld a,(de)		; $4a27
	add (hl)		; $4a28
	ld (de),a		; $4a29
	inc hl			; $4a2a
	ld e,$0d		; $4a2b
	ld a,(de)		; $4a2d
	add (hl)		; $4a2e
	ld (de),a		; $4a2f
	inc hl			; $4a30
	ld e,$0f		; $4a31
	ld a,(de)		; $4a33
	add (hl)		; $4a34
	ld (de),a		; $4a35
	ret			; $4a36
	ld h,d			; $4a37
	ld a,($cc50)		; $4a38
	and $20			; $4a3b
	ret z			; $4a3d
	ld e,$0b		; $4a3e
	ld l,$0f		; $4a40
	ld a,(de)		; $4a42
	add (hl)		; $4a43
	ld (de),a		; $4a44
	xor a			; $4a45
	ldd (hl),a		; $4a46
	ld (hl),a		; $4a47
	or d			; $4a48
	ret			; $4a49

_itemUpdateSpeedZAndCheckHazards:
	ld e,$0f		; $4a4a
	ld a,e			; $4a4c
	ldh (<hFF8B),a	; $4a4d
	ld a,(de)		; $4a4f
	rlca			; $4a50
	jr nc,_label_07_065	; $4a51
	rrca			; $4a53
	ldh (<hFF8B),a	; $4a54
	call objectUpdateSpeedZ_paramC		; $4a56
	jr nz,_label_07_066	; $4a59
	ldh (<hFF8B),a	; $4a5b
_label_07_065:
	call objectReplaceWithAnimationIfOnHazard		; $4a5d
	jr nc,_label_07_066	; $4a60
	pop hl			; $4a62
	ld a,$ff		; $4a63
	ret			; $4a65
_label_07_066:
	ldh a,(<hFF8B)	; $4a66
	rlca			; $4a68
	or a			; $4a69
	ret			; $4a6a

_bombPullTowardPoint:
	ld h,d			; $4a6b
	ld l,$0f		; $4a6c
	and $80			; $4a6e
	jr nz,_label_07_067	; $4a70
	ld l,$31		; $4a72
	ld b,(hl)		; $4a74
	ldi (hl),a		; $4a75
	ld c,(hl)		; $4a76
	ldi (hl),a		; $4a77
	or b			; $4a78
	ret z			; $4a79
	push bc			; $4a7a
	call objectCheckContainsPoint		; $4a7b
	pop bc			; $4a7e
	ret c			; $4a7f
	call objectGetRelativeAngle		; $4a80
	ld c,a			; $4a83
	ld b,$0a		; $4a84
	ld e,$09		; $4a86
	call objectApplyGivenSpeed		; $4a88
_label_07_067:
	xor a			; $4a8b
	ret			; $4a8c
	call $4a37		; $4a8d
	jr nz,_label_07_070	; $4a90
	call objectUpdateSpeedZ_paramC		; $4a92
	jr nz,_label_07_068	; $4a95
	call $4b02		; $4a97
	bit 4,(hl)		; $4a9a
	set 4,(hl)		; $4a9c
	scf			; $4a9e
	ret			; $4a9f
_label_07_068:
	ld l,$3b		; $4aa0
	res 4,(hl)		; $4aa2
	or d			; $4aa4
	ret			; $4aa5
_label_07_069:
	ld h,d			; $4aa6
	ld l,$3b		; $4aa7
	bit 4,(hl)		; $4aa9
	set 4,(hl)		; $4aab
	scf			; $4aad
	ret			; $4aae
_label_07_070:
	push bc			; $4aaf
	call $4b02		; $4ab0
	ld l,$15		; $4ab3
	bit 7,(hl)		; $4ab5
	jr z,_label_07_071	; $4ab7
	call objectCheckTileCollision_allowHoles		; $4ab9
	ld h,d			; $4abc
	pop bc			; $4abd
	jr nc,_label_07_072	; $4abe
	ld b,$03		; $4ac0
	jr _label_07_074		; $4ac2
_label_07_071:
	ld l,$0b		; $4ac4
	ldi a,(hl)		; $4ac6
	add $05			; $4ac7
	ld b,a			; $4ac9
	inc l			; $4aca
	ld c,(hl)		; $4acb
	call checkTileCollisionAt_allowHoles		; $4acc
	ld h,d			; $4acf
	pop bc			; $4ad0
	jr c,_label_07_069	; $4ad1
_label_07_072:
	ld l,$3b		; $4ad3
	bit 0,(hl)		; $4ad5
	ld b,$03		; $4ad7
	jr z,_label_07_073	; $4ad9
	ld b,$01		; $4adb
	bit 7,(hl)		; $4add
	jr nz,_label_07_068	; $4adf
_label_07_073:
	ld e,$14		; $4ae1
	ld l,$0a		; $4ae3
	ld a,(de)		; $4ae5
	add (hl)		; $4ae6
	ldi (hl),a		; $4ae7
	inc e			; $4ae8
	ld a,(de)		; $4ae9
	adc (hl)		; $4aea
	ldi (hl),a		; $4aeb
_label_07_074:
	ld l,$14		; $4aec
	ld a,(hl)		; $4aee
	add c			; $4aef
	ldi (hl),a		; $4af0
	ld a,(hl)		; $4af1
	adc $00			; $4af2
	ld (hl),a		; $4af4
	bit 7,a			; $4af5
	jr nz,_label_07_068	; $4af7
	cp b			; $4af9
	jr c,_label_07_068	; $4afa
	ld (hl),b		; $4afc
	dec l			; $4afd
	ld (hl),$00		; $4afe
	jr _label_07_068		; $4b00
	call $4a37		; $4b02
	jr nz,_label_07_075	; $4b05
	ld l,$0f		; $4b07
	bit 7,(hl)		; $4b09
	jr nz,_label_07_076	; $4b0b
_label_07_075:
	call objectCheckIsOverHazard		; $4b0d
	ld h,d			; $4b10
_label_07_076:
	ld b,a			; $4b11
	ld l,$3b		; $4b12
	ld a,(hl)		; $4b14
	ld c,a			; $4b15
	and $b8			; $4b16
	xor $80			; $4b18
	or b			; $4b1a
	ld (hl),a		; $4b1b
	ld a,b			; $4b1c
	xor c			; $4b1d
	rrca			; $4b1e
	jr nc,_label_07_077	; $4b1f
	set 6,(hl)		; $4b21
_label_07_077:
	ret			; $4b23

_itemUpdateThrowingVerticallyAndCheckHazards:
	call $4a8d		; $4b24
	jr c,_label_07_079	; $4b27
	ld a,($cc50)		; $4b29
	and $20			; $4b2c
	jr z,_label_07_078	; $4b2e
	ld b,$04		; $4b30
	bit 2,(hl)		; $4b32
	jr nz,_label_07_081	; $4b34
	ld b,$03		; $4b36
	bit 6,(hl)		; $4b38
	call nz,$4b5f		; $4b3a
_label_07_078:
	xor a			; $4b3d
	ret			; $4b3e
_label_07_079:
	ld a,($cc50)		; $4b3f
	and $20			; $4b42
	jr nz,_label_07_080	; $4b44
	ld h,d			; $4b46
	ld l,$3b		; $4b47
	ld b,$03		; $4b49
	bit 0,(hl)		; $4b4b
	jr nz,_label_07_081	; $4b4d
	ld b,$0f		; $4b4f
	bit 1,(hl)		; $4b51
	jr nz,_label_07_082	; $4b53
	ld b,$04		; $4b55
	bit 2,(hl)		; $4b57
	jr nz,_label_07_081	; $4b59
_label_07_080:
	xor a			; $4b5b
	bit 4,(hl)		; $4b5c
	ret			; $4b5e
_label_07_081:
	call objectCreateInteractionWithSubid00		; $4b5f
	scf			; $4b62
	ret			; $4b63
_label_07_082:
	call objectCreateFallingDownHoleInteraction		; $4b64
	scf			; $4b67
	ret			; $4b68
	ld b,$07		; $4b69
	jp objectCreateInteractionWithSubid00		; $4b6b
	ld a,$01		; $4b6e
	call objectGetRelatedObject1Var		; $4b70
	ld e,$01		; $4b73
	ld a,(de)		; $4b75
	cp (hl)			; $4b76
	ret			; $4b77
	call getTileAtPosition		; $4b78
	jr _label_07_083		; $4b7b

_itemCheckCanPassSolidTile:
	call objectGetTileAtPosition		; $4b7d
_label_07_083:
	ld e,a			; $4b80
	ld a,l			; $4b81
	ld h,d			; $4b82
	ld l,$3c		; $4b83
	cp (hl)			; $4b85
	ldi (hl),a		; $4b86
	jr nz,_label_07_084	; $4b87
	ld a,e			; $4b89
	cp (hl)			; $4b8a
	ret z			; $4b8b
_label_07_084:
	ld (hl),e		; $4b8c
	ld l,$09		; $4b8d
	ld b,(hl)		; $4b8f
	call $4ba7		; $4b90
	jr nc,_label_07_085	; $4b93
	ret z			; $4b95
	ld h,d			; $4b96
	ld l,$3e		; $4b97
	add (hl)		; $4b99
	ld (hl),a		; $4b9a
	and $80			; $4b9b
	ret z			; $4b9d
_label_07_085:
	ld h,d			; $4b9e
	ld l,$3c		; $4b9f
	ld a,$ff		; $4ba1
	ldi (hl),a		; $4ba3
	ld (hl),a		; $4ba4
	or d			; $4ba5
	ret			; $4ba6
	ld hl,$4ca4		; $4ba7
	call findByteInCollisionTable_paramE		; $4baa
	jr c,_label_07_089	; $4bad
	ld a,b			; $4baf
	ld hl,angleTable		; $4bb0
	rst_addAToHl			; $4bb3
	ld a,(hl)		; $4bb4
	push af			; $4bb5
	ld a,($cc4f)		; $4bb6
	ld hl,$4c38		; $4bb9
	rst_addDoubleIndex			; $4bbc
	ldi a,(hl)		; $4bbd
	ld h,(hl)		; $4bbe
	ld l,a			; $4bbf
	pop af			; $4bc0
	srl a			; $4bc1
	jr nc,_label_07_086	; $4bc3
	rst_addAToHl			; $4bc5
	ld a,(hl)		; $4bc6
	push hl			; $4bc7
	rst_addAToHl			; $4bc8
	call lookupKey		; $4bc9
	pop hl			; $4bcc
	jr c,_label_07_088	; $4bcd
	inc hl			; $4bcf
	jr _label_07_087		; $4bd0
_label_07_086:
	rst_addAToHl			; $4bd2
_label_07_087:
	ld a,(hl)		; $4bd3
	rst_addAToHl			; $4bd4
	call lookupKey		; $4bd5
	ret nc			; $4bd8
_label_07_088:
	or a			; $4bd9
	scf			; $4bda
	ret			; $4bdb
_label_07_089:
	xor a			; $4bdc
	scf			; $4bdd
	ret			; $4bde
	ld e,$0f		; $4bdf
	ld a,(de)		; $4be1
	rlca			; $4be2
	ret c			; $4be3
	ld bc,$0500		; $4be4
	call objectGetRelativeTile		; $4be7
	ld hl,$4c23		; $4bea
	call lookupCollisionTable		; $4bed
	ret nc			; $4bf0
	push af			; $4bf1
	rrca			; $4bf2
	rrca			; $4bf3
	ld hl,$4c1b		; $4bf4
	rst_addAToHl			; $4bf7
	ldi a,(hl)		; $4bf8
	ld c,(hl)		; $4bf9
	ld h,d			; $4bfa
	ld l,$0b		; $4bfb
	add (hl)		; $4bfd
	ld b,a			; $4bfe
	ld l,$0d		; $4bff
	ld a,(hl)		; $4c01
	add c			; $4c02
	ld c,a			; $4c03
	call getTileCollisionsAtPosition		; $4c04
	cp $ff			; $4c07
	jr z,_label_07_090	; $4c09
	call checkGivenCollision_allowHoles		; $4c0b
	jr c,_label_07_090	; $4c0e
	pop af			; $4c10
	ld c,a			; $4c11
	ld b,$14		; $4c12
	ld e,$09		; $4c14
	jp objectApplyGivenSpeed		; $4c16
_label_07_090:
	pop af			; $4c19
	ret			; $4c1a
.DB $fd				; $4c1b
	nop			; $4c1c
	nop			; $4c1d
	inc bc			; $4c1e
	rlca			; $4c1f
	nop			; $4c20
	nop			; $4c21
.DB $fd				; $4c22
	scf			; $4c23
	ld c,h			; $4c24
	scf			; $4c25
	ld c,h			; $4c26
	scf			; $4c27
	ld c,h			; $4c28
	scf			; $4c29
	ld c,h			; $4c2a
	cpl			; $4c2b
	ld c,h			; $4c2c
	scf			; $4c2d
	ld c,h			; $4c2e
	ld d,h			; $4c2f
	nop			; $4c30
	ld d,l			; $4c31
	ld ($1056),sp		; $4c32
	ld d,a			; $4c35
	jr _label_07_091		; $4c36
_label_07_091:
	ld b,h			; $4c38
	ld c,h			; $4c39
	ld a,l			; $4c3a
	ld c,h			; $4c3b
	ld a,l			; $4c3c
	ld c,h			; $4c3d
	ld a,l			; $4c3e
	ld c,h			; $4c3f
	add e			; $4c40
	ld c,h			; $4c41
	ld a,l			; $4c42
	ld c,h			; $4c43
	dec b			; $4c44
	ld h,$14		; $4c45
	dec l			; $4c47
	ld bc,$ff54		; $4c48
	rst $8			; $4c4b
	rst $38			; $4c4c
	adc $ff			; $4c4d
	ld e,b			; $4c4f
	rst $38			; $4c50
	call $94ff		; $4c51
	rst $38			; $4c54
	sub l			; $4c55
	rst $38			; $4c56
	ldi a,(hl)		; $4c57
	ld bc,$5400		; $4c58
	ld bc,$01cf		; $4c5b
	adc $01			; $4c5e
	ld e,b			; $4c60
	ld bc,s8ToS16		; $4c61
	sub h			; $4c64
	ld bc,$0195		; $4c65
	ldi a,(hl)		; $4c68
	rst $38			; $4c69
	nop			; $4c6a
	daa			; $4c6b
	ld bc,$0126		; $4c6c
	dec h			; $4c6f
	rst $38			; $4c70
	jr z,-$01		; $4c71
	nop			; $4c73
	daa			; $4c74
	rst $38			; $4c75
	ld h,$ff		; $4c76
	dec h			; $4c78
	ld bc,$0128		; $4c79
	nop			; $4c7c
	dec b			; $4c7d
	inc b			; $4c7e
	inc bc			; $4c7f
	ld (bc),a		; $4c80
	ld bc,$0500		; $4c81
	ld d,$0c		; $4c84
	add hl,de		; $4c86
	ld bc,$01b2		; $4c87
	or b			; $4c8a
	rst $38			; $4c8b
	dec b			; $4c8c
	ld bc,$ff06		; $4c8d
	nop			; $4c90
	or b			; $4c91
	ld bc,$ffb2		; $4c92
	dec b			; $4c95
	rst $38			; $4c96
	ld b,$01		; $4c97
	nop			; $4c99
	or e			; $4c9a
	ld bc,$ffb1		; $4c9b
	nop			; $4c9e
	or c			; $4c9f
	ld bc,$ffb3		; $4ca0
	nop			; $4ca3
	or b			; $4ca4
	ld c,h			; $4ca5
	or b			; $4ca6
	ld c,h			; $4ca7
	or c			; $4ca8
	ld c,h			; $4ca9
	or d			; $4caa
	ld c,h			; $4cab
	or h			; $4cac
	ld c,h			; $4cad
	jp nz,$fd4c		; $4cae
	nop			; $4cb1
	rst $8			; $4cb2
	nop			; $4cb3
	sub b			; $4cb4
	sub c			; $4cb5
	sub d			; $4cb6
	sub e			; $4cb7
	sub h			; $4cb8
	sub l			; $4cb9
	sub (hl)		; $4cba
	sub a			; $4cbb
	sbc b			; $4cbc
	sbc c			; $4cbd
	sbc d			; $4cbe
	sbc e			; $4cbf
	ld a,(bc)		; $4cc0
	dec bc			; $4cc1
	nop			; $4cc2

; ITEMID_EMBER_SEED
; ITEMID_SCENT_SEED
; ITEMID_PEGASUS_SEED
; ITEMID_GALE_SEED
; ITEMID_MYSTERY_SEED
itemCode20:
itemCode21:
itemCode22:
itemCode23:
itemCode24:
	ld e,Item.state		; $4cc3
	ld a,(de)		; $4cc5
	rst_jumpTable			; $4cc6
	.dw @state0
	.dw _seedItemState1
	.dw _seedItemState2
	.dw _seedItemState3

@state0:
	call _itemLoadAttributesAndGraphics		; $4ccf
	xor a			; $4cd2
	call itemSetAnimation		; $4cd3
	call objectSetVisiblec1		; $4cd6
	call itemIncState		; $4cd9
	ld bc,$ffe0		; $4cdc
	call objectSetSpeedZ		; $4cdf
	call itemUpdateAngle		; $4ce2

	ld l,Item.subid		; $4ce5
	ldd a,(hl)		; $4ce7
	or a			; $4ce8
	jr nz,@slingshot	; $4ce9

	; Satchel
	ldi a,(hl) ; [id]
	cp ITEMID_GALE_SEED			; $4cec
	jr nz,++		; $4cee

	; Gale seed
	ld l,Item.zh		; $4cf0
	ld a,(hl)		; $4cf2
	add $f8			; $4cf3
	ld (hl),a		; $4cf5
	ld l,Item.angle		; $4cf6
	ld (hl),$ff		; $4cf8
	ret			; $4cfa
++
	ld a,SPEED_c0		; $4cfb
	jr @setSpeed		; $4cfd

@slingshot:
	ld hl,@slingshotAngleTable-1		; $4cff
	rst_addAToHl			; $4d02
	ld e,Item.angle		; $4d03
	ld a,(de)		; $4d05
	add (hl)		; $4d06
	and $1f			; $4d07
	ld (de),a		; $4d09

	ld hl,wIsSeedShooterInUse		; $4d0a
	inc (hl)		; $4d0d
	ld a,SPEED_300		; $4d0e

@setSpeed:
	ld e,Item.speed		; $4d10
	ld (de),a		; $4d12
	ld hl,@seedPositionOffsets		; $4d13
	call _applyOffsetTableHL		; $4d16

	; If it's a mystery seed, get a random effect
	ld e,Item.id		; $4d19
	ld a,(de)		; $4d1b
	cp ITEMID_MYSTERY_SEED			; $4d1c
	ret nz			; $4d1e

	call getRandomNumber_noPreserveVars		; $4d1f
	and $03			; $4d22
	ld e,Item.var03		; $4d24
	ld (de),a		; $4d26
	add $80|ITEMCOLLISION_EMBER_SEED			; $4d27
	ld e,Item.collisionType		; $4d29
	ld (de),a		; $4d2b
	ret			; $4d2c

@slingshotAngleTable:
	.db $00 $02 $fe

@seedPositionOffsets:
	.db $fc $00 $fe ; DIR_UP
	.db $01 $04 $fe ; DIR_RIGHT
	.db $05 $00 $fe ; DIR_DOWN
	.db $01 $fb $fe ; DIR_LEFT


_seedItemState1:
	call _itemUpdateDamageToApply		; $4d3c
	jr nz,@collisionWithEnemy	; $4d3f

	ld e,Item.subid		; $4d41
	ld a,(de)		; $4d43
	or a			; $4d44
	jr z,@satchelUpdate	; $4d45

@slingshotUpdate:
	call _slingshotCheckCanPassSolidTile		; $4d47
	jr nz,@seedCollidedWithWall	; $4d4a
	call objectCheckWithinScreenBoundary		; $4d4c
	jp c,objectApplySpeed		; $4d4f
	jp _seedItemDelete		; $4d52

@satchelUpdate:
	; Set speed to 0 if landed in water?
	ld h,d			; $4d55
	ld l,Item.var3b		; $4d56
	bit 0,(hl)		; $4d58
	jr z,+			; $4d5a
	ld l,Item.speed		; $4d5c
	ld (hl),SPEED_0		; $4d5e
+
	call objectCheckWithinRoomBoundary		; $4d60
	jp nc,_seedItemDelete		; $4d63

	call objectApplySpeed		; $4d66
	ld c,$1c		; $4d69
	call _itemUpdateThrowingVerticallyAndCheckHazards		; $4d6b
	jp c,_seedItemDelete		; $4d6e
	ret z			; $4d71

; Landed on ground

	ld a,SND_BOMB_LAND		; $4d72
	call playSound		; $4d74
	call itemAnimate		; $4d77
	ld e,Item.id		; $4d7a
	ld a,(de)		; $4d7c
	sub ITEMID_EMBER_SEED			; $4d7d
	rst_jumpTable			; $4d7f
	.dw @emberStandard
	.dw @scentLanded
	.dw _seedItemDelete
	.dw @galeLanded
	.dw @mysteryStandard

@seedCollidedWithWall:
	call itemAnimate		; $4d8a
	ld e,Item.id		; $4d8d
	ld a,(de)		; $4d8f
	sub ITEMID_EMBER_SEED			; $4d90
	rst_jumpTable			; $4d92
	.dw @emberStandard
	.dw @scentOrPegasusCollided
	.dw @scentOrPegasusCollided
	.dw @galeCollidedWithWall
	.dw @mysteryStandard


@collisionWithEnemy:
	call itemAnimate		; $4d9d
	ld e,$24		; $4da0
	xor a			; $4da2
	ld (de),a		; $4da3
	ld e,$01		; $4da4
	ld a,(de)		; $4da6
	sub $20			; $4da7
	rst_jumpTable			; $4da9
	.dw @emberStandard
	.dw @scentOrPegasusCollided
	.dw @scentOrPegasusCollided
	.dw @galeCollidedWithEnemy
	.dw @mysteryCollidedWithEnemy


@emberStandard:
@galeCollidedWithEnemy:
	call @initState3		; $4db4
	jp objectSetVisible82		; $4db7


@scentLanded:
	ld a,$27		; $4dba
	call @loadGfxVarsWithIndex		; $4dbc
	ld a,$02		; $4dbf
	call itemSetState		; $4dc1
	ld l,Item.collisionType		; $4dc4
	res 7,(hl)		; $4dc6
	ld a,$01		; $4dc8
	call itemSetAnimation		; $4dca
	jp objectSetVisible83		; $4dcd


@scentOrPegasusCollided:
	ld e,Item.collisionType		; $4dd0
	xor a			; $4dd2
	ld (de),a		; $4dd3
	jr @initState3		; $4dd4


@galeLanded:
	call @breakTileWithGaleSeed		; $4dd6

	ld a,$25		; $4dd9
	call @loadGfxVarsWithIndex		; $4ddb
	ld a,$02		; $4dde
	call itemSetState		; $4de0

	ld l,Item.collisionType		; $4de3
	xor a			; $4de5
	ldi (hl),a		; $4de6

	; Set collisionRadiusY/X
	inc l			; $4de7
	ld a,$02		; $4de8
	ldi (hl),a		; $4dea
	ld (hl),a		; $4deb

	jp objectSetVisible82		; $4dec


@breakTileWithGaleSeed:
	ld a,BREAKABLETILESOURCE_0d		; $4def
	jp itemTryToBreakTile		; $4df1


@galeCollidedWithWall:
	call @breakTileWithGaleSeed		; $4df4
	ld a,$26		; $4df7
	call @loadGfxVarsWithIndex		; $4df9
	ld a,$03		; $4dfc
	call itemSetState		; $4dfe
	ld l,Item.collisionType		; $4e01
	res 7,(hl)		; $4e03
	jp objectSetVisible82		; $4e05


@mysteryCollidedWithEnemy:
	ld h,d			; $4e08
	ld l,Item.var2a		; $4e09
	bit 6,(hl)		; $4e0b
	jr nz,@mysteryStandard	; $4e0d

	; Change id to be the random type selected
	ld l,Item.var03		; $4e0f
	ldd a,(hl)		; $4e11
	add ITEMID_EMBER_SEED			; $4e12
	dec l			; $4e14
	ld (hl),a		; $4e15
	call _itemLoadAttributesAndGraphics		; $4e16
	xor a			; $4e19
	call itemSetAnimation		; $4e1a
	ld e,$29		; $4e1d
	ld a,$ff		; $4e1f
	ld (de),a		; $4e21
	jp $4d9d		; $4e22

@mysteryStandard:
	ld e,$24		; $4e25
	xor a			; $4e27
	ld (de),a		; $4e28
	call objectSetVisible82		; $4e29

@initState3:
	ld e,Item.state		; $4e2c
	ld a,$03		; $4e2e
	ld (de),a		; $4e30

	ld e,Item.id		; $4e31
	ld a,(de)		; $4e33

;;
; @param	a	Index to use for below table (plus $20, since
;			ITEMID_EMBER_SEED=$20)
; @addr{4e8a}
@loadGfxVarsWithIndex:
	add a			; $4e34
	ld hl,@data-(ITEMID_EMBER_SEED*4)		; $4e35
	rst_addDoubleIndex			; $4e38

	ld e,Item.oamFlagsBackup		; $4e39
	ldi a,(hl)		; $4e3b
	ld (de),a		; $4e3c
	inc e			; $4e3d
	ld (de),a		; $4e3e
	inc e			; $4e3f
	ldi a,(hl)		; $4e40
	ld (de),a		; $4e41
	ldi a,(hl)		; $4e42
	ld e,Item.counter1		; $4e43
	ld (de),a		; $4e45
	ld a,(hl)		; $4e46
	jp playSound		; $4e47

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
; @addr{4e6a}
_seedItemDelete:
	ld e,Item.subid		; $4e6a
	ld a,(de)		; $4e6c
	or a			; $4e6d
	jr z,@delete	; $4e6e

	ld hl,wIsSeedShooterInUse		; $4e70
	ld a,(hl)		; $4e73
	or a			; $4e74
	jr z,@delete	; $4e75
	dec (hl)		; $4e77
@delete:
	jp itemDelete		; $4e78

;;
; State 3: typically occurs when the seed collides with a wall or enemy (instead of the
; ground)
; @addr{4e7b}
_seedItemState3:
	ld e,Item.id		; $4e7b
	ld a,(de)		; $4e7d
	sub ITEMID_EMBER_SEED			; $4e7e
	rst_jumpTable			; $4e80
	.dw _emberSeedBurn
	.dw _seedUpdateAnimation
	.dw _seedUpdateAnimation
	.dw $4f0f
	.dw _seedUpdateAnimation

_emberSeedBurn:
	ld h,d			; $4e8b
	ld l,Item.counter1		; $4e8c
	dec (hl)		; $4e8e
	jr z,@breakTile	; $4e8f

	call itemAnimate		; $4e91
	call _itemUpdateDamageToApply		; $4e94
	ld l,Item.animParameter		; $4e97
	ld b,(hl)		; $4e99
	jr z,+			; $4e9a

	ld l,Item.collisionType		; $4e9c
	ld (hl),$00		; $4e9e
	bit 7,b			; $4ea0
	jr nz,@deleteSelf	; $4ea2
+
	ld l,Item.z		; $4ea4
	ldi a,(hl)		; $4ea6
	or (hl)			; $4ea7
	ld c,$1c		; $4ea8
	jp nz,objectUpdateSpeedZ_paramC		; $4eaa
	bit 6,b			; $4ead
	ret z			; $4eaf

	call objectCheckTileAtPositionIsWater		; $4eb0
	jr c,@deleteSelf	; $4eb3
	ret			; $4eb5

@breakTile:
	ld a,BREAKABLETILESOURCE_0c		; $4eb6
	call itemTryToBreakTile		; $4eb8
@deleteSelf:
	jp _seedItemDelete		; $4ebb


;;
; Generic update function for seed states 2/3
;
; @addr{4f14}
_seedUpdateAnimation:
	ld e,Item.collisionType		; $4ebe
	xor a			; $4ec0
	ld (de),a		; $4ec1
	call itemAnimate		; $4ec2
	ld e,Item.animParameter		; $4ec5
	ld a,(de)		; $4ec7
	rlca			; $4ec8
	ret nc			; $4ec9
	jp _seedItemDelete		; $4eca

;;
; State 2: typically occurs when the seed lands on the ground
; @addr{4ecd}
_seedItemState2:
	ld e,Item.id		; $4ecd
	ld a,(de)		; $4ecf
	sub ITEMID_EMBER_SEED			; $4ed0
	rst_jumpTable			; $4ed2
	.dw _emberSeedBurn
	.dw _scentSeedSmell
	.dw _seedUpdateAnimation
	.dw _galeSeedTryToWarpLink
	.dw _seedUpdateAnimation

;;
; Scent seed in the "smelling" state that attracts enemies
;
; @addr{4edd}
_scentSeedSmell:
	ld h,d			; $4edd
	ld l,$06		; $4ede
	ld a,(wFrameCounter)		; $4ee0
	rrca			; $4ee3
	jr c,_label_07_109	; $4ee4
	dec (hl)		; $4ee6
	jp z,_seedItemDelete		; $4ee7
_label_07_109:
	ld a,(hl)		; $4eea
	cp $1e			; $4eeb
	jr nc,_label_07_110	; $4eed
	ld l,$1a		; $4eef
	ld a,(hl)		; $4ef1
	xor $80			; $4ef2
	ld (hl),a		; $4ef4
_label_07_110:
	ld l,$0b		; $4ef5
	ldi a,(hl)		; $4ef7
	ldh (<hFFB2),a	; $4ef8
	inc l			; $4efa
	ldi a,(hl)		; $4efb
	ldh (<hFFB3),a	; $4efc
	ld a,$ff		; $4efe
	ld ($ccf0),a		; $4f00
	call itemAnimate		; $4f03
	call _bombPullTowardPoint		; $4f06
	jp c,_seedItemDelete		; $4f09
	jp _itemUpdateSpeedZAndCheckHazards		; $4f0c

_galeSeedUpdateAnimationCounter:
	call _galeSeedUpdateAnimation		; $4f0f
	call itemDecCounter1		; $4f12
	jp z,_seedItemDelete		; $4f15
	ld a,(hl)		; $4f18
	cp $14			; $4f19
	ret nc			; $4f1b
	ld l,$1a		; $4f1c
	ld a,(hl)		; $4f1e
	xor $80			; $4f1f
	ld (hl),a		; $4f21
	ret			; $4f22

_galeSeedUpdateAnimation:
	call itemAnimate		; $4f23
	ld e,$06		; $4f26
	ld a,(de)		; $4f28
	and $03			; $4f29
	ret nz			; $4f2b
	ld e,$1b		; $4f2c
	ld a,(de)		; $4f2e
	inc a			; $4f2f
	and $0b			; $4f30
	ld (de),a		; $4f32
	inc e			; $4f33
	ld (de),a		; $4f34
	ret			; $4f35

_galeSeedTryToWarpLink:
	call _galeSeedUpdateAnimation		; $4f36
	ld e,Item.state2		; $4f39
	ld a,(de)		; $4f3b
	rst_jumpTable			; $4f3c
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cc50)		; $4f45
	dec a
	jr nz,$40
	ld a,($cc88)		; $4f4b
	or a			; $4f4e
	jr nz,_galeSeedUpdateAnimationCounter	; $4f4f
	ld a,($cc48)		; $4f51
	rrca			; $4f54
	jr c,_galeSeedUpdateAnimationCounter	; $4f55
	ld a,(wLinkGrabState2)		; $4f57
	and $f0			; $4f5a
	cp $40			; $4f5c
	jr z,_galeSeedUpdateAnimationCounter	; $4f5e
	call checkLinkID0AndControlNormal		; $4f60
	jr nc,_galeSeedUpdateAnimationCounter	; $4f63
	call objectCheckCollidedWithLink		; $4f65
	jr nc,_galeSeedUpdateAnimationCounter	; $4f68
	ld hl,$d000		; $4f6a
	call objectTakePosition		; $4f6d
	ld e,$07		; $4f70
	ld a,$3c		; $4f72
	ld (de),a		; $4f74
	ld e,$05		; $4f75
	ld a,$01		; $4f77
	ld (de),a		; $4f79
	ld ($cc02),a		; $4f7a
	ld ($cca6),a		; $4f7d
	ld ($ccab),a		; $4f80
	ld a,$07		; $4f83
	ld ($cc6a),a		; $4f85
	jp objectSetVisible80		; $4f88

@setSubstate3:
	ld e,$05		; $4f8b
	ld a,$03		; $4f8d
	ld (de),a		; $4f8f
	ret			; $4f90

@substate1:
	ld a,($cc34)		; $4f91
	or a			; $4f94
	jr nz,@setSubstate3	; $4f95
	ld h,d			; $4f97
	ld l,$07		; $4f98
	dec (hl)		; $4f9a
	jr z,+			; $4f9b
	ld a,($cc49)		; $4f9d
	or a			; $4fa0
	jr z,@flickerAndCopyPositionToLink	; $4fa1
	ret			; $4fa3
+
	ld a,$02		; $4fa4
	ld (de),a		; $4fa6

@substate2:
	ld h,d			; $4fa7
	ld l,$0f		; $4fa8
	dec (hl)		; $4faa
	dec (hl)		; $4fab
	bit 7,(hl)		; $4fac
	jr nz,@flickerAndCopyPositionToLink	; $4fae
	ld a,$02		; $4fb0
	ld ($d005),a		; $4fb2
	ld a,$16		; $4fb5
	ld ($cc04),a		; $4fb7
	ld a,$05		; $4fba
	call openMenu		; $4fbc
	jp _seedItemDelete		; $4fbf

@flickerAndCopyPositionToLink:
	ld e,$1a		; $4fc2
	ld a,(de)		; $4fc4
	xor $80			; $4fc5
	ld (de),a		; $4fc7
	xor a			; $4fc8
	ld ($cc78),a		; $4fc9
	ld hl,$d000		; $4fcc
	jp objectCopyPosition		; $4fcf

@substate3:
	call itemDecCounter2		; $4fd2
	jp z,_seedItemDelete		; $4fd5
	ld l,$1a		; $4fd8
	ld a,(hl)		; $4fda
	xor $80			; $4fdb
	ld (hl),a		; $4fdd
	ret			; $4fde

;;
; @param[out]	zflag	z if no collision
; @addr{4fdf}
_slingshotCheckCanPassSolidTile:
	call objectCheckTileCollision_allowHoles		; $4fdf
	jr nc,++		; $4fe2
	call _itemCheckCanPassSolidTile		; $4fe4
	ret			; $4fe7
++
	xor a			; $4fe8
	ret			; $4fe9


; ITEMID_DIMITRI_MOUTH
itemCode2b:
	ld e,$04		; $4fea
	ld a,(de)		; $4fec
	or a			; $4fed
	jr nz,_label_07_116	; $4fee
	call _itemLoadAttributesAndGraphics		; $4ff0
	call itemIncState		; $4ff3
	ld l,$06		; $4ff6
	ld (hl),$0c		; $4ff8
_label_07_116:
	call $5019		; $4ffa
	ld h,d			; $4ffd
	ld l,$2a		; $4ffe
	bit 1,(hl)		; $5000
	jr nz,_label_07_117	; $5002
	ld a,$12		; $5004
	call itemTryToBreakTile		; $5006
	jr c,_label_07_117	; $5009
	call itemDecCounter1		; $500b
	jr z,_label_07_118	; $500e
	ret			; $5010
_label_07_117:
	ld a,$01		; $5011
	ld ($d135),a		; $5013
_label_07_118:
	jp itemDelete		; $5016
	ld a,($d108)		; $5019
	ld hl,$5029		; $501c
	rst_addDoubleIndex			; $501f
	ldi a,(hl)		; $5020
	ld c,(hl)		; $5021
	ld b,a			; $5022
	ld hl,$d10b		; $5023
	jp objectTakePositionWithOffset		; $5026
	or $00			; $5029
	cp $0a			; $502b
	inc b			; $502d
	nop			; $502e
	cp $f6			; $502f

; ITEMID_BOMBCHUS
itemCode0d:
	call $52ac		; $5031
	ld e,$04		; $5034
	ld a,(de)		; $5036
	cp $ff			; $5037
	jp nc,$5402		; $5039
	call objectCheckWithinRoomBoundary		; $503c
	jp nc,itemDelete		; $503f
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $5042
	ld a,($cc50)		; $5045
	and $20			; $5048
	jr nz,_label_07_119	; $504a
	ld c,$20		; $504c
	call _itemUpdateSpeedZAndCheckHazards		; $504e
	ld e,$04		; $5051
	ld a,(de)		; $5053
	rst_jumpTable			; $5054
	ld a,c			; $5055
	ld d,b			; $5056
	xor a			; $5057
	ld d,b			; $5058
	cp b			; $5059
	ld d,b			; $505a
	push bc			; $505b
	ld d,b			; $505c
	ret nc			; $505d
	ld d,b			; $505e
_label_07_119:
	ld e,$32		; $505f
	ld a,(de)		; $5061
	or a			; $5062
	jr nz,_label_07_120	; $5063
	ld c,$18		; $5065
	call _itemUpdateThrowingVerticallyAndCheckHazards		; $5067
	jp c,itemDelete		; $506a
_label_07_120:
	ld e,$04		; $506d
	ld a,(de)		; $506f
	rst_jumpTable			; $5070
	sbc $50			; $5071
.DB $ed				; $5073
	ld d,b			; $5074
.DB $fc				; $5075
	ld d,b			; $5076
	inc b			; $5077
	ld d,c			; $5078
	call _itemLoadAttributesAndGraphics		; $5079
	call decNumBombchus		; $507c
	ld h,d			; $507f
	ld l,$04		; $5080
	inc (hl)		; $5082
	ld l,$30		; $5083
	ld (hl),$d0		; $5085
	ld l,$11		; $5087
	ld (hl),$14		; $5089
	ld l,$06		; $508b
	ld (hl),$10		; $508d
	inc l			; $508f
	ld (hl),$b4		; $5090
	ld l,$26		; $5092
	ld a,$18		; $5094
	ldi (hl),a		; $5096
	ld (hl),a		; $5097
	ld l,$31		; $5098
	ld (hl),$08		; $509a
	ld l,$09		; $509c
	ld a,($d008)		; $509e
	swap a			; $50a1
	rrca			; $50a3
	ld (hl),a		; $50a4
	ld l,$08		; $50a5
	ld (hl),$ff		; $50a7
	call $5220		; $50a9
	jp $526b		; $50ac
	ld h,d			; $50af
	ld l,$0f		; $50b0
	bit 7,(hl)		; $50b2
	jr nz,_label_07_121	; $50b4
	ld l,e			; $50b6
	inc (hl)		; $50b7
	call $52c3		; $50b8
	ret z			; $50bb
_label_07_121:
	call $5117		; $50bc
	call $4bdf		; $50bf
_label_07_122:
	jp itemAnimate		; $50c2
	ld h,d			; $50c5
	ld l,$06		; $50c6
	dec (hl)		; $50c8
	jp nz,$4bdf		; $50c9
	ld (hl),$0a		; $50cc
	ld l,e			; $50ce
	inc (hl)		; $50cf
	call $52b7		; $50d0
	jp c,$52b0		; $50d3
	call $510f		; $50d6
	call $4bdf		; $50d9
	jr _label_07_122		; $50dc
	call $5079		; $50de
	ld e,$09		; $50e1
	ld a,(de)		; $50e3
	bit 3,a			; $50e4
	ret nz			; $50e6
	add $08			; $50e7
	ld (de),a		; $50e9
	jp $5220		; $50ea
	ld e,$10		; $50ed
	ld a,$14		; $50ef
	ld (de),a		; $50f1
	call $52c3		; $50f2
	ret z			; $50f5
	call $5181		; $50f6
_label_07_123:
	jp itemAnimate		; $50f9
	call itemDecCounter1		; $50fc
	ret nz			; $50ff
	ld (hl),$0a		; $5100
	ld l,e			; $5102
	inc (hl)		; $5103
	call $52b7		; $5104
	jp c,$52b0		; $5107
	call $5179		; $510a
	jr _label_07_123		; $510d
	ld a,(wFrameCounter)		; $510f
	and $07			; $5112
	call z,$51fe		; $5114
	call $5122		; $5117
	ld c,$18		; $511a
	call objectUpdateSpeedZ_paramC		; $511c
	jp objectApplySpeed		; $511f
	ld e,$09		; $5122
	call $515a		; $5124
	cp $10			; $5127
	jr z,_label_07_125	; $5129
	cp $15			; $512b
	jr z,_label_07_125	; $512d
	inc a			; $512f
	jr z,_label_07_125	; $5130
	dec a			; $5132
	ld e,$11		; $5133
	ld a,(de)		; $5135
	jr z,_label_07_124	; $5136
	ld e,a			; $5138
	ld hl,$6270		; $5139
	call lookupKey		; $513c
_label_07_124:
	ld h,d			; $513f
	ld l,$10		; $5140
	cp (hl)			; $5142
	ld (hl),a		; $5143
	ret nc			; $5144
	ld l,$14		; $5145
	ld a,$80		; $5147
	ldi (hl),a		; $5149
	ld (hl),$ff		; $514a
	ret			; $514c
_label_07_125:
	ld h,d			; $514d
	ld l,$31		; $514e
	ld a,(hl)		; $5150
	ld l,$09		; $5151
	add (hl)		; $5153
	and $18			; $5154
	ld (hl),a		; $5156
	jp $5220		; $5157
	ld h,d			; $515a
	ld l,$0b		; $515b
	ld b,(hl)		; $515d
	ld l,$0d		; $515e
	ld c,(hl)		; $5160
	ld a,(de)		; $5161
	rrca			; $5162
	rrca			; $5163
	ld hl,$5171		; $5164
	rst_addAToHl			; $5167
	ldi a,(hl)		; $5168
	add b			; $5169
	ld b,a			; $516a
	ld a,(hl)		; $516b
	add c			; $516c
	ld c,a			; $516d
	jp getTileCollisionsAtPosition		; $516e
.DB $fc				; $5171
	nop			; $5172
	ld (bc),a		; $5173
	inc bc			; $5174
	ld b,$00		; $5175
	ld (bc),a		; $5177
.DB $fc				; $5178
	ld a,(wFrameCounter)		; $5179
	and $07			; $517c
	call z,$523b		; $517e
	call $5187		; $5181
	jp objectApplySpeed		; $5184
	ld e,$32		; $5187
	ld a,(de)		; $5189
	or a			; $518a
	jr nz,_label_07_127	; $518b
	ld e,$09		; $518d
	call $515a		; $518f
	ret z			; $5192
	inc a			; $5193
	jr nz,_label_07_126	; $5194
	ld e,$09		; $5196
	ld a,(de)		; $5198
	xor $10			; $5199
	ld (de),a		; $519b
	jp $5220		; $519c
_label_07_126:
	ld h,d			; $519f
	ld l,$09		; $51a0
	ld a,(hl)		; $51a2
	ld (hl),$00		; $51a3
	ld l,$33		; $51a5
	ld (hl),a		; $51a7
	ld l,$32		; $51a8
	ld (hl),$01		; $51aa
	jp $5220		; $51ac
_label_07_127:
	ld e,$33		; $51af
	call $515a		; $51b1
	jr nz,_label_07_129	; $51b4
	ld h,d			; $51b6
	ld l,$09		; $51b7
	ld e,$33		; $51b9
	ld a,(de)		; $51bb
	or a			; $51bc
	jr nz,_label_07_128	; $51bd
	ld a,(hl)		; $51bf
	ld e,$33		; $51c0
	ld (de),a		; $51c2
_label_07_128:
	ld a,(de)		; $51c3
	ld (hl),a		; $51c4
	ld l,$32		; $51c5
	xor a			; $51c7
	ldi (hl),a		; $51c8
	inc l			; $51c9
	ld (hl),a		; $51ca
	ld l,$14		; $51cb
	ldi (hl),a		; $51cd
	ldi (hl),a		; $51ce
	ld l,$08		; $51cf
	ld (hl),$ff		; $51d1
	jp $5220		; $51d3
_label_07_129:
	ld e,$09		; $51d6
	call $515a		; $51d8
	ret z			; $51db
	ld h,d			; $51dc
	ld l,$09		; $51dd
	ld b,(hl)		; $51df
	ld e,$33		; $51e0
	ld a,(de)		; $51e2
	xor $10			; $51e3
	ld (hl),a		; $51e5
	bit 3,a			; $51e6
	jr z,_label_07_130	; $51e8
	bit 3,b			; $51ea
	jr z,_label_07_130	; $51ec
	ld l,$32		; $51ee
	ld (hl),$00		; $51f0
_label_07_130:
	ld a,b			; $51f2
	ld (de),a		; $51f3
	or a			; $51f4
	ld l,$34		; $51f5
	ld (hl),$00		; $51f7
	jr nz,_label_07_132	; $51f9
	inc (hl)		; $51fb
	jr _label_07_132		; $51fc
	ld a,$0b		; $51fe
	call objectGetRelatedObject2Var		; $5200
	ld b,(hl)		; $5203
	ld l,$8d		; $5204
	ld c,(hl)		; $5206
	call objectGetRelativeAngle		; $5207
	ld b,a			; $520a
	add $04			; $520b
	and $18			; $520d
	ld e,$09		; $520f
	ld (de),a		; $5211
	sub b			; $5212
	and $1f			; $5213
	cp $10			; $5215
	ld a,$08		; $5217
	jr nc,_label_07_131	; $5219
	ld a,$f8		; $521b
_label_07_131:
	ld e,$31		; $521d
	ld (de),a		; $521f
_label_07_132:
	ld h,d			; $5220
	ld l,$08		; $5221
	ld e,$09		; $5223
	ld a,(de)		; $5225
	cp (hl)			; $5226
	ret z			; $5227
	ld (hl),a		; $5228
	swap a			; $5229
	rlca			; $522b
	ld l,$34		; $522c
	bit 0,(hl)		; $522e
	jr z,_label_07_133	; $5230
	dec a			; $5232
	ld a,$04		; $5233
	jr z,_label_07_133	; $5235
	inc a			; $5237
_label_07_133:
	jp itemSetAnimation		; $5238
	ld a,$0b		; $523b
	call objectGetRelatedObject2Var		; $523d
	ld b,(hl)		; $5240
	ld l,$8d		; $5241
	ld c,(hl)		; $5243
	call objectGetRelativeAngle		; $5244
	ld b,a			; $5247
	ld e,$09		; $5248
	ld a,(de)		; $524a
	bit 3,a			; $524b
	ld a,b			; $524d
	jr nz,_label_07_134	; $524e
	sub $08			; $5250
	and $1f			; $5252
	cp $10			; $5254
	ld a,$00		; $5256
	jr c,_label_07_135	; $5258
	ld a,$10		; $525a
	jr _label_07_135		; $525c
_label_07_134:
	cp $10			; $525e
	ld a,$08		; $5260
	jr c,_label_07_135	; $5262
	ld a,$18		; $5264
_label_07_135:
	ld e,$09		; $5266
	ld (de),a		; $5268
	jr _label_07_132		; $5269
	ld hl,$d00b		; $526b
	ld b,(hl)		; $526e
	ld l,$0d		; $526f
	ld c,(hl)		; $5271
	ld a,($cc49)		; $5272
	cp $06			; $5275
	ld l,$08		; $5277
	ld a,(hl)		; $5279
	ld hl,$529c		; $527a
	jr c,_label_07_136	; $527d
	ld hl,$52a4		; $527f
_label_07_136:
	rst_addDoubleIndex			; $5282
	ld e,$0b		; $5283
	ldi a,(hl)		; $5285
	add b			; $5286
	ld (de),a		; $5287
	ld e,$0d		; $5288
	ld a,(hl)		; $528a
	add c			; $528b
	ld (de),a		; $528c
	push bc			; $528d
	call objectGetTileCollisions		; $528e
	pop bc			; $5291
	cp $0f			; $5292
	ret nz			; $5294
	ld a,c			; $5295
	ld (de),a		; $5296
	ld e,$0b		; $5297
	ld a,b			; $5299
	ld (de),a		; $529a
	ret			; $529b
.DB $f4				; $529c
	nop			; $529d
	ld (bc),a		; $529e
	inc c			; $529f
	inc c			; $52a0
	nop			; $52a1
	ld (bc),a		; $52a2
.DB $f4				; $52a3
	nop			; $52a4
	nop			; $52a5
	ld (bc),a		; $52a6
	inc c			; $52a7
	nop			; $52a8
	nop			; $52a9
	ld (bc),a		; $52aa
.DB $f4				; $52ab
	call itemDecCounter2		; $52ac
	ret nz			; $52af
	ld e,$07		; $52b0
	xor a			; $52b2
	ld (de),a		; $52b3
	jp $543c		; $52b4
	ld a,$29		; $52b7
	call objectGetRelatedObject2Var		; $52b9
	ld a,(hl)		; $52bc
	or a			; $52bd
	scf			; $52be
	ret z			; $52bf
	jp checkObjectsCollided		; $52c0
	ld e,$30		; $52c3
	ld a,(de)		; $52c5
	ld h,a			; $52c6
	ld l,$80		; $52c7
	ld a,(hl)		; $52c9
	or a			; $52ca
	jr z,_label_07_138	; $52cb
	ld l,$9a		; $52cd
	bit 7,(hl)		; $52cf
	jr z,_label_07_138	; $52d1
	ld l,$81		; $52d3
	ld a,(hl)		; $52d5
	push hl			; $52d6
	ld hl,$532d		; $52d7
	call checkFlag		; $52da
	pop hl			; $52dd
	jr z,_label_07_138	; $52de
	call checkObjectsCollided		; $52e0
	jr nc,_label_07_138	; $52e3
	ld a,h			; $52e5
	ld h,d			; $52e6
	ld l,$19		; $52e7
	ldd (hl),a		; $52e9
	ld (hl),$80		; $52ea
	ld l,$26		; $52ec
	ld a,$06		; $52ee
	ldi (hl),a		; $52f0
	ld (hl),a		; $52f1
	ld l,$06		; $52f2
	ld (hl),$0c		; $52f4
	ld l,$11		; $52f6
	ld (hl),$46		; $52f8
	ld l,$04		; $52fa
	inc (hl)		; $52fc
	ld a,($cc50)		; $52fd
	and $20			; $5300
	jr nz,_label_07_137	; $5302
	call $51fe		; $5304
	xor a			; $5307
	ret			; $5308
_label_07_137:
	call $523b		; $5309
	xor a			; $530c
	ret			; $530d
_label_07_138:
	inc h			; $530e
	ld a,h			; $530f
	cp $e0			; $5310
	jr c,_label_07_139	; $5312
	call $531e		; $5314
	ld a,$d0		; $5317
_label_07_139:
	ld e,$30		; $5319
	ld (de),a		; $531b
	or d			; $531c
	ret			; $531d
	ld e,$26		; $531e
	ld a,(de)		; $5320
	add $10			; $5321
	cp $60			; $5323
	jr c,_label_07_140	; $5325
	ld a,$18		; $5327
_label_07_140:
	ld (de),a		; $5329
	inc e			; $532a
	ld (de),a		; $532b
	ret			; $532c
	nop			; $532d
	ccf			; $532e
	sub a			; $532f
	ld a,l			; $5330
	ccf			; $5331
	jr nc,$37		; $5332
	ld a,h			; $5334
	jp hl			; $5335
	rst $28			; $5336
	ld (bc),a		; $5337
	ld b,b			; $5338
	nop			; $5339
	nop			; $533a
	inc bc			; $533b
	nop			; $533c

; ITEMID_BOMB
itemCode03:
	ld e,$2f		; $533d
	ld a,(de)		; $533f
	bit 5,a			; $5340
	jr nz,_label_07_141	; $5342
	bit 7,a			; $5344
	jp nz,$548d		; $5346
	bit 4,a			; $5349
	jp nz,$542a		; $534b
	ld e,$04		; $534e
	ld a,(de)		; $5350
	rst_jumpTable			; $5351
	ld a,d			; $5352
	ld d,e			; $5353
	ld l,b			; $5354
	ld d,e			; $5355
	ld a,d			; $5356
	ld d,e			; $5357
_label_07_141:
	ld h,d			; $5358
	ld l,$04		; $5359
	ldi a,(hl)		; $535b
	cp $02			; $535c
	jr nz,_label_07_142	; $535e
	bit 1,(hl)		; $5360
	call z,dropLinkHeldItem		; $5362
_label_07_142:
	jp itemDelete		; $5365
	ld c,$20		; $5368
	call $53cd		; $536a
	ret c			; $536d
	call _bombPullTowardPoint		; $536e
	jp c,itemDelete		; $5371
	call $4bdf		; $5374
	jp $5434		; $5377
	ld e,$05		; $537a
	ld a,(de)		; $537c
	rst_jumpTable			; $537d
	add (hl)		; $537e
	ld d,e			; $537f
	sub h			; $5380
	ld d,e			; $5381
	and e			; $5382
	ld d,e			; $5383
	and e			; $5384
	ld d,e			; $5385
	call itemIncState2		; $5386
	ld l,$2f		; $5389
	set 6,(hl)		; $538b
	ld l,$37		; $538d
	res 0,(hl)		; $538f
	call $547c		; $5391
	ld a,$3b		; $5394
	call cpActiveRing		; $5396
	jp z,$548d		; $5399
	call $5434		; $539c
	ret z			; $539f
	jp dropLinkHeldItem		; $53a0
	ld a,$03		; $53a3
	ld (de),a		; $53a5
	call $613a		; $53a6
	ld e,$39		; $53a9
	ld a,(de)		; $53ab
	ld c,a			; $53ac
	call $53cd		; $53ad
	ret c			; $53b0
	jr z,_label_07_143	; $53b1
	call $6220		; $53b3
	jr c,_label_07_144	; $53b6
	call _bombPullTowardPoint		; $53b8
	jp c,itemDelete		; $53bb
_label_07_143:
	jp $5434		; $53be
_label_07_144:
	ld h,d			; $53c1
	ld l,$04		; $53c2
	ld (hl),$01		; $53c4
	ld l,$2f		; $53c6
	res 6,(hl)		; $53c8
	jp $5434		; $53ca
	push bc			; $53cd
	ld a,($cc50)		; $53ce
	and $20			; $53d1
	jr z,_label_07_145	; $53d3
	ld e,$0b		; $53d5
	ld a,(de)		; $53d7
	sub $08			; $53d8
	cp $f0			; $53da
	ccf			; $53dc
	jr c,_label_07_146	; $53dd
_label_07_145:
	call objectCheckWithinRoomBoundary		; $53df
_label_07_146:
	pop bc			; $53e2
	jr nc,_label_07_147	; $53e3
	call _itemUpdateThrowingVerticallyAndCheckHazards		; $53e5
	ret nc			; $53e8
	ld bc,$04ef		; $53e9
	ld a,($cc49)		; $53ec
	cp b			; $53ef
	jr nz,_label_07_147	; $53f0
	ld a,($cc4c)		; $53f2
	cp c			; $53f5
	jr nz,_label_07_147	; $53f6
	ld a,$01		; $53f8
	ld ($cfc0),a		; $53fa
_label_07_147:
	call itemDelete		; $53fd
	scf			; $5400
	ret			; $5401
_label_07_148:
	ld h,d			; $5402
	ld l,$21		; $5403
	ld a,(hl)		; $5405
	bit 7,a			; $5406
	jp nz,itemDelete		; $5408
	ld l,$24		; $540b
	bit 6,a			; $540d
	jr z,_label_07_149	; $540f
	ld (hl),$00		; $5411
_label_07_149:
	ld c,(hl)		; $5413
	ld l,$26		; $5414
	and $1f			; $5416
	ldi (hl),a		; $5418
	ldi (hl),a		; $5419
	bit 7,c			; $541a
	call nz,$5494		; $541c
	ld h,d			; $541f
	ld l,$06		; $5420
	bit 7,(hl)		; $5422
	call z,$54db		; $5424
	jp itemAnimate		; $5427
	ld h,d			; $542a
	ld l,$04		; $542b
	ld a,(hl)		; $542d
	cp $ff			; $542e
	jr nz,_label_07_150	; $5430
	jr _label_07_148		; $5432
	call itemAnimate		; $5434
	ld e,$21		; $5437
	ld a,(de)		; $5439
	or a			; $543a
	ret z			; $543b
_label_07_150:
	ld h,d			; $543c
	ld l,$1b		; $543d
	ld a,$0a		; $543f
	ldi (hl),a		; $5441
	ldi (hl),a		; $5442
	ld (hl),$0c		; $5443
	ld l,$24		; $5445
	set 7,(hl)		; $5447
	ld a,$0c		; $5449
	call cpActiveRing		; $544b
	jr nz,_label_07_151	; $544e
	ld l,$28		; $5450
	dec (hl)		; $5452
	dec (hl)		; $5453
_label_07_151:
	ld l,$04		; $5454
	ld (hl),$ff		; $5456
	ld l,$06		; $5458
	ld (hl),$08		; $545a
	ld l,$2f		; $545c
	ld a,(hl)		; $545e
	or $50			; $545f
	ld (hl),a		; $5461
	ld l,$01		; $5462
	ldd a,(hl)		; $5464
	res 1,(hl)		; $5465
	cp $03			; $5467
	ld a,$01		; $5469
	jr z,_label_07_152	; $546b
	ld a,$06		; $546d
_label_07_152:
	call itemSetAnimation		; $546f
	call objectSetVisible80		; $5472
	ld a,$6f		; $5475
	call playSound		; $5477
	or d			; $547a
	ret			; $547b
	ld h,d			; $547c
	ld l,$37		; $547d
	bit 7,(hl)		; $547f
	ret nz			; $5481
	set 7,(hl)		; $5482
	call decNumBombs		; $5484
	call _itemLoadAttributesAndGraphics		; $5487
	call $4a37		; $548a
	xor a			; $548d
	call itemSetAnimation		; $548e
	jp objectSetVisiblec1		; $5491
	ld h,d			; $5494
	ld l,$37		; $5495
	bit 6,(hl)		; $5497
	ret nz			; $5499
	ld a,($d101)		; $549a
	cp $0a			; $549d
	ret z			; $549f
	ld a,$30		; $54a0
	call cpActiveRing		; $54a2
	ret z			; $54a5
	call checkLinkVulnerable		; $54a6
	ret nc			; $54a9
	ld h,d			; $54aa
	ld l,$26		; $54ab
	ld a,(hl)		; $54ad
	ld c,a			; $54ae
	add a			; $54af
	ld b,a			; $54b0
	ld l,$0f		; $54b1
	ld a,($d00f)		; $54b3
	sub (hl)		; $54b6
	add c			; $54b7
	cp b			; $54b8
	ret nc			; $54b9
	call objectCheckCollidedWithLink_ignoreZ		; $54ba
	ret nc			; $54bd
	call objectGetAngleTowardLink		; $54be
	ld h,d			; $54c1
	ld l,$37		; $54c2
	set 6,(hl)		; $54c4
	ld l,$28		; $54c6
	ld c,(hl)		; $54c8
	ld hl,$d025		; $54c9
	ld (hl),c		; $54cc
	ld l,$2d		; $54cd
	ld (hl),$0c		; $54cf
	dec l			; $54d1
	ldd (hl),a		; $54d2
	ld (hl),$10		; $54d3
	dec l			; $54d5
	ld (hl),$01		; $54d6
	jp linkApplyDamage		; $54d8
	ld a,(hl)		; $54db
	dec (hl)		; $54dc
	ld l,a			; $54dd
	add a			; $54de
	add l			; $54df
	ld hl,$551f		; $54e0
	rst_addAToHl			; $54e3
	ld a,($cc50)		; $54e4
	and $20			; $54e7
	ld e,$0f		; $54e9
	ld a,(de)		; $54eb
	jr nz,_label_07_153	; $54ec
	sub $02			; $54ee
	cp (hl)			; $54f0
	ret c			; $54f1
	xor a			; $54f2
_label_07_153:
	ld c,a			; $54f3
	inc hl			; $54f4
	ldi a,(hl)		; $54f5
	add c			; $54f6
	ld b,a			; $54f7
	ld a,(hl)		; $54f8
	ld c,a			; $54f9
	ld h,d			; $54fa
	ld e,$00		; $54fb
	bit 7,b			; $54fd
	jr z,_label_07_154	; $54ff
	dec e			; $5501
_label_07_154:
	ld l,$0b		; $5502
	ldi a,(hl)		; $5504
	add b			; $5505
	ld b,a			; $5506
	ld a,$00		; $5507
	adc e			; $5509
	ret nz			; $550a
	inc l			; $550b
	ld e,$00		; $550c
	bit 7,c			; $550e
	jr z,_label_07_155	; $5510
	dec e			; $5512
_label_07_155:
	ld a,(hl)		; $5513
	add c			; $5514
	ld c,a			; $5515
	ld a,$00		; $5516
	adc e			; $5518
	ret nz			; $5519
	ld a,$04		; $551a
	jp tryToBreakTile		; $551c
	ld hl,sp-$0d		; $551f
	di			; $5521
	ld hl,sp+$0c		; $5522
	di			; $5524
	ld hl,sp+$0c		; $5525
	inc c			; $5527
	ld hl,sp-$0d		; $5528
	inc c			; $552a
.DB $f4				; $552b
	nop			; $552c
	di			; $552d
.DB $f4				; $552e
	inc c			; $552f
	nop			; $5530
.DB $f4				; $5531
	nop			; $5532
	inc c			; $5533
.DB $f4				; $5534
	di			; $5535
	nop			; $5536
	ld a,($ff00+c)		; $5537
	nop			; $5538
	nop			; $5539

; ITEMID_BOOMERANG
itemCode06:
	ld e,$04		; $553a
	ld a,(de)		; $553c
	rst_jumpTable			; $553d
	ld c,b			; $553e
	ld d,l			; $553f
	sub b			; $5540
	ld d,l			; $5541
	rst $20			; $5542
	ld d,l			; $5543
	ld hl,sp+$55		; $5544
	inc d			; $5546
	ld d,(hl)		; $5547
	call _itemLoadAttributesAndGraphics		; $5548
	ld e,$02		; $554b
	ld a,(de)		; $554d
	add $18			; $554e
	call loadWeaponGfx		; $5550
	call itemIncState		; $5553
	ld bc,$4128		; $5556
	ld l,$02		; $5559
	bit 0,(hl)		; $555b
	jr z,_label_07_156	; $555d
	ld l,$24		; $555f
	ld (hl),$96		; $5561
	ld l,$1b		; $5563
	ld a,$0c		; $5565
	ldi (hl),a		; $5567
	ldi (hl),a		; $5568
	ld bc,$5f78		; $5569
_label_07_156:
	ld l,$10		; $556c
	ld (hl),b		; $556e
	ld l,$06		; $556f
	ld (hl),c		; $5571
	ld c,$ff		; $5572
	ld a,$0d		; $5574
	call cpActiveRing		; $5576
	jr z,_label_07_157	; $5579
	ld a,$29		; $557b
	call cpActiveRing		; $557d
	jr nz,_label_07_158	; $5580
	ld c,$fe		; $5582
_label_07_157:
	ld l,$28		; $5584
	ld a,(hl)		; $5586
	add c			; $5587
	ld (hl),a		; $5588
_label_07_158:
	call objectSetVisible82		; $5589
	xor a			; $558c
	jp itemSetAnimation		; $558d
	call $5638		; $5590
	ld e,$2a		; $5593
	ld a,(de)		; $5595
	or a			; $5596
	jr nz,_label_07_160	; $5597
	call objectCheckTileCollision_allowHoles		; $5599
	jr nc,_label_07_159	; $559c
	call _itemCheckCanPassSolidTile		; $559e
	jr nz,_label_07_162	; $55a1
_label_07_159:
	call objectCheckWithinRoomBoundary		; $55a3
	jr nc,_label_07_160	; $55a6
	ld e,$34		; $55a8
	ld a,(de)		; $55aa
	call objectNudgeAngleTowards		; $55ab
	call itemDecCounter1		; $55ae
	jr nz,_label_07_165	; $55b1
_label_07_160:
	call objectGetAngleTowardLink		; $55b3
	ld c,a			; $55b6
	ld h,d			; $55b7
	ld l,$0b		; $55b8
	ld a,$f0		; $55ba
	cp (hl)			; $55bc
	jr c,_label_07_161	; $55bd
	ld l,$0d		; $55bf
	cp (hl)			; $55c1
	jr c,_label_07_161	; $55c2
	ld l,$09		; $55c4
	ld a,c			; $55c6
	sub (hl)		; $55c7
	add $08			; $55c8
	cp $11			; $55ca
	jr c,_label_07_163	; $55cc
_label_07_161:
	ld l,$09		; $55ce
	ld (hl),c		; $55d0
	jr _label_07_163		; $55d1
_label_07_162:
	call $4b69		; $55d3
	ld h,d			; $55d6
	ld l,$09		; $55d7
	ld a,(hl)		; $55d9
	xor $10			; $55da
	ld (hl),a		; $55dc
_label_07_163:
	ld l,$04		; $55dd
	inc (hl)		; $55df
	ld l,$16		; $55e0
	xor a			; $55e2
	ldi (hl),a		; $55e3
	ld (hl),a		; $55e4
	jr _label_07_165		; $55e5
	call objectGetAngleTowardLink		; $55e7
	call objectNudgeAngleTowards		; $55ea
	ld bc,setTileWithoutGfxReload		; $55ed
	call $5642		; $55f0
	call c,itemIncState		; $55f3
	jr _label_07_164		; $55f6
	call objectGetAngleTowardLink		; $55f8
	ld e,$09		; $55fb
	ld (de),a		; $55fd
	ld bc,$0402		; $55fe
	call $5642		; $5601
	jr nc,_label_07_164	; $5604
	call itemIncState		; $5606
	ld l,$06		; $5609
	ld (hl),$04		; $560b
	ld l,$24		; $560d
	ld (hl),$00		; $560f
	jp objectSetInvisible		; $5611
	call itemDecCounter1		; $5614
	jp z,itemDelete		; $5617
	ld a,($cc48)		; $561a
	ld h,a			; $561d
	ld l,$0b		; $561e
	jp objectTakePosition		; $5620
_label_07_164:
	call $5638		; $5623
_label_07_165:
	call objectApplySpeed		; $5626
	ld h,d			; $5629
	ld l,$21		; $562a
	ld a,(hl)		; $562c
	or a			; $562d
	ld (hl),$00		; $562e
	ld a,$78		; $5630
	call nz,playSound		; $5632
	jp itemAnimate		; $5635
	ld e,$02		; $5638
	ld a,(de)		; $563a
	or a			; $563b
	ret z			; $563c
	ld a,$07		; $563d
	jp itemTryToBreakTile		; $563f
	ld hl,$d00b		; $5642
	ld e,$0b		; $5645
	ld a,(de)		; $5647
	sub (hl)		; $5648
	add c			; $5649
	cp b			; $564a
	ret nc			; $564b
	ld l,$0d		; $564c
	ld e,$0d		; $564e
	ld a,(de)		; $5650
	sub (hl)		; $5651
	add c			; $5652
	cp b			; $5653
	ret			; $5654

; ITEMID_RICKY_TORNADO
itemCode2a:
	ld e,$04		; $5655
	ld a,(de)		; $5657
	rst_jumpTable			; $5658
	ld e,l			; $5659
	ld d,(hl)		; $565a
	sub c			; $565b
	ld d,(hl)		; $565c
	call itemIncState		; $565d
	ld l,$10		; $5660
	ld (hl),$78		; $5662
	ld a,($d108)		; $5664
	ld c,a			; $5667
	swap a			; $5668
	rrca			; $566a
	ld l,$09		; $566b
	ld (hl),a		; $566d
	ld a,c			; $566e
	ld hl,$5689		; $566f
	rst_addDoubleIndex			; $5672
	ldi a,(hl)		; $5673
	ld c,(hl)		; $5674
	ld b,a			; $5675
	ld hl,$d10b		; $5676
	call objectTakePositionWithOffset		; $5679
	sub $02			; $567c
	ld (de),a		; $567e
	call _itemLoadAttributesAndGraphics		; $567f
	xor a			; $5682
	call itemSetAnimation		; $5683
	jp objectSetVisiblec1		; $5686
	ld a,($ff00+$00)	; $5689
	nop			; $568b
	inc c			; $568c
	ld ($0000),sp		; $568d
.DB $f4				; $5690
	call objectApplySpeed		; $5691
	ld a,$01		; $5694
	call itemTryToBreakTile		; $5696
	call objectGetTileCollisions		; $5699
	and $0f			; $569c
	cp $0f			; $569e
	jp z,itemDelete		; $56a0
	jp itemAnimate		; $56a3

; ITEMID_29
itemCode29:
	ld e,$04		; $56a6
	ld a,(de)		; $56a8
	rst_jumpTable			; $56a9
	or b			; $56aa
	ld d,(hl)		; $56ab
	ld ($ff00+$56),a	; $56ac
	ld c,e			; $56ae
	ld e,b			; $56af
	ld a,$01		; $56b0
	ld (de),a		; $56b2
	ld h,d			; $56b3
	ld l,$10		; $56b4
	ld (hl),$0a		; $56b6
	ld l,$0b		; $56b8
	ld a,(hl)		; $56ba
	ld b,a			; $56bb
	ld l,$0d		; $56bc
	ld a,(hl)		; $56be
	ld l,$31		; $56bf
	ldd (hl),a		; $56c1
	ld (hl),b		; $56c2
	call _itemLoadAttributesAndGraphics		; $56c3
	xor a			; $56c6
	call itemSetAnimation		; $56c7
	call objectSetVisiblec3		; $56ca
	ld a,($cc49)		; $56cd
	cp $04			; $56d0
	jr nz,_label_07_166	; $56d2
	ld a,($cc4c)		; $56d4
	cp $94			; $56d7
	jr nz,_label_07_166	; $56d9
	ld e,$03		; $56db
	ld a,$01		; $56dd
	ld (de),a		; $56df
_label_07_166:
	call $56ef		; $56e0
	call $590f		; $56e3
	ld e,$24		; $56e6
	ld a,(de)		; $56e8
	bit 7,a			; $56e9
	ret nz			; $56eb
	jp $5a06		; $56ec
	ld h,d			; $56ef
	ld l,$03		; $56f0
	ld a,(hl)		; $56f2
	or a			; $56f3
	jr nz,_label_07_167	; $56f4
	ld l,$24		; $56f6
	res 7,(hl)		; $56f8
_label_07_167:
	call $5a28		; $56fa
	call $5a5e		; $56fd
	ld a,($cc79)		; $5700
	or a			; $5703
	jp z,$57bd		; $5704
	ld b,$0c		; $5707
	call objectCheckCenteredWithLink		; $5709
	jp nc,$57bd		; $570c
	call objectGetAngleTowardLink		; $570f
	add $04			; $5712
	add a			; $5714
	swap a			; $5715
	and $03			; $5717
	xor $02			; $5719
	ld b,a			; $571b
	ld a,($d008)		; $571c
	cp b			; $571f
	jp nz,$57bd		; $5720
	ld e,$10		; $5723
	ld a,$28		; $5725
	ld (de),a		; $5727
	ld e,$32		; $5728
	ld a,(de)		; $572a
	or a			; $572b
	jr z,_label_07_168	; $572c
	inc e			; $572e
	ld a,(de)		; $572f
	cp $10			; $5730
	jp nc,$57bd		; $5732
	inc e			; $5735
	ld a,(de)		; $5736
	cp $10			; $5737
	jp nc,$57bd		; $5739
	ld e,$32		; $573c
	xor a			; $573e
	ld (de),a		; $573f
_label_07_168:
	ld a,($cc79)		; $5740
	bit 1,a			; $5743
	jr nz,_label_07_170	; $5745
	ld a,($d008)		; $5747
	ld hl,$587b		; $574a
	rst_addDoubleIndex			; $574d
	ld a,($d00b)		; $574e
	add (hl)		; $5751
	ldh (<hFF8D),a	; $5752
	inc hl			; $5754
	ld a,($d00d)		; $5755
	add (hl)		; $5758
	ldh (<hFF8C),a	; $5759
	push bc			; $575b
	call $5842		; $575c
	pop bc			; $575f
	jp c,$5806		; $5760
	bit 0,b			; $5763
	jr nz,_label_07_169	; $5765
	call $588d		; $5767
	ld e,$04		; $576a
	ld a,(de)		; $576c
	cp $01			; $576d
	ret nz			; $576f
	call $5972		; $5770
	call $594e		; $5773
	jp $5883		; $5776
_label_07_169:
	call $5883		; $5779
	ld e,$04		; $577c
	ld a,(de)		; $577e
	cp $01			; $577f
	ret nz			; $5781
	call $5979		; $5782
	call $5966		; $5785
	jp $588d		; $5788
_label_07_170:
	ld a,($d00b)		; $578b
	ldh (<hFF8D),a	; $578e
	ld a,($d00d)		; $5790
	ldh (<hFF8C),a	; $5793
	bit 0,b			; $5795
	jr nz,_label_07_171	; $5797
	call $588d		; $5799
	ld e,$04		; $579c
	ld a,(de)		; $579e
	cp $01			; $579f
	ret nz			; $57a1
	call $5972		; $57a2
	call $594e		; $57a5
	jp $5897		; $57a8
_label_07_171:
	call $5883		; $57ab
	ld e,$04		; $57ae
	ld a,(de)		; $57b0
	cp $01			; $57b1
	ret nz			; $57b3
	call $5979		; $57b4
	call $5966		; $57b7
	jp $58a1		; $57ba
	ld e,$33		; $57bd
	ld a,(de)		; $57bf
	or a			; $57c0
	jr z,_label_07_172	; $57c1
	ld e,$32		; $57c3
	ld a,$01		; $57c5
	ld (de),a		; $57c7
	call $5980		; $57c8
	call $5980		; $57cb
	call $594e		; $57ce
	ld e,$09		; $57d1
	ld a,(de)		; $57d3
	call $58c3		; $57d4
_label_07_172:
	ld e,$34		; $57d7
	ld a,(de)		; $57d9
	or a			; $57da
	jr z,_label_07_173	; $57db
	ld e,$32		; $57dd
	ld a,$01		; $57df
	ld (de),a		; $57e1
	call $598f		; $57e2
	call $598f		; $57e5
	call $5966		; $57e8
	ld e,$09		; $57eb
	ld a,(de)		; $57ed
	call $58c3		; $57ee
_label_07_173:
	call objectCheckIsOnHazard		; $57f1
	jp c,$57f8		; $57f4
	ret			; $57f7
	ldh (<hFF8B),a	; $57f8
	call $5a1f		; $57fa
	ldh a,(<hFF8B)	; $57fd
	dec a			; $57ff
	jp z,objectReplaceWithSplash		; $5800
	jp objectReplaceWithFallingDownHoleInteraction		; $5803
	xor a			; $5806
	ld e,$33		; $5807
	ld (de),a		; $5809
	ld e,$34		; $580a
	ld (de),a		; $580c
	ld a,($cc47)		; $580d
	cp $ff			; $5810
	ret z			; $5812
	ld a,($cc45)		; $5813
	ld b,a			; $5816
	bit 6,b			; $5817
	jr z,_label_07_174	; $5819
	ld a,$00		; $581b
	call $583c		; $581d
	jr _label_07_175		; $5820
_label_07_174:
	bit 7,b			; $5822
	jr z,_label_07_175	; $5824
	ld a,$10		; $5826
	call $583c		; $5828
_label_07_175:
	ld a,($cc45)		; $582b
	ld b,a			; $582e
	bit 4,b			; $582f
	jr z,_label_07_176	; $5831
	ld a,$08		; $5833
	jr _label_07_177		; $5835
_label_07_176:
	bit 5,b			; $5837
	ld a,$18		; $5839
	ret z			; $583b
_label_07_177:
	ld e,$09		; $583c
	ld (de),a		; $583e
	jp $58c3		; $583f
	ldh a,(<hFF8D)	; $5842
	ld b,a			; $5844
	ldh a,(<hFF8C)	; $5845
	ld c,a			; $5847
	jp objectCheckContainsPoint		; $5848
	ld h,d			; $584b
	ld l,$24		; $584c
	set 7,(hl)		; $584e
	ld l,$08		; $5850
	ldi a,(hl)		; $5852
	ld (hl),a		; $5853
	call objectApplySpeed		; $5854
	ld c,$20		; $5857
	call objectUpdateSpeedZ_paramC		; $5859
	ret nz			; $585c
	ld a,$77		; $585d
	call playSound		; $585f
	ld h,d			; $5862
	ld l,$06		; $5863
	dec (hl)		; $5865
	jr z,_label_07_178	; $5866
	ld bc,$ff20		; $5868
	ld l,$14		; $586b
	ld (hl),c		; $586d
	inc l			; $586e
	ld (hl),b		; $586f
	ld l,$10		; $5870
	ld (hl),$14		; $5872
	ret			; $5874
_label_07_178:
	ld a,$01		; $5875
	ld e,$04		; $5877
	ld (de),a		; $5879
	ret			; $587a
	ld a,($ff00+$00)	; $587b
	nop			; $587d
	stop			; $587e
	stop			; $587f
	nop			; $5880
	nop			; $5881
	ld a,($ff00+$06)	; $5882
	nop			; $5884
	ld c,$10		; $5885
	call $58ab		; $5887
	ret z			; $588a
	jr _label_07_181		; $588b
	ld b,$18		; $588d
	ld c,$08		; $588f
	call $58bb		; $5891
	ret z			; $5894
	jr _label_07_181		; $5895
	ld b,$10		; $5897
	ld c,$00		; $5899
	call $58ab		; $589b
	ret z			; $589e
	jr _label_07_181		; $589f
	ld b,$08		; $58a1
	ld c,$18		; $58a3
	call $58bb		; $58a5
	ret z			; $58a8
	jr _label_07_181		; $58a9
	ldh a,(<hFF8D)	; $58ab
	ld l,$0b		; $58ad
	ld e,$33		; $58af
_label_07_179:
	ld h,d			; $58b1
	cp (hl)			; $58b2
	ld a,b			; $58b3
	jr c,_label_07_180	; $58b4
	ld a,c			; $58b6
_label_07_180:
	ld l,$09		; $58b7
	ld (hl),a		; $58b9
	ret			; $58ba
	ldh a,(<hFF8C)	; $58bb
	ld l,$0d		; $58bd
	ld e,$34		; $58bf
	jr _label_07_179		; $58c1
_label_07_181:
	srl a			; $58c3
	ld hl,$58ff		; $58c5
	rst_addAToHl			; $58c8
	call $58ed		; $58c9
	jr c,_label_07_182	; $58cc
	call $58ed		; $58ce
	jr c,_label_07_182	; $58d1
	ld h,d			; $58d3
	ld l,$24		; $58d4
	set 7,(hl)		; $58d6
	call objectApplySpeed		; $58d8
	jr _label_07_184		; $58db
_label_07_182:
	call $59a9		; $58dd
	ld e,$09		; $58e0
	ld a,(de)		; $58e2
	bit 3,a			; $58e3
	ld e,$33		; $58e5
	jr z,_label_07_183	; $58e7
	inc e			; $58e9
_label_07_183:
	xor a			; $58ea
	ld (de),a		; $58eb
	ret			; $58ec
	ld e,$0b		; $58ed
	ld a,(de)		; $58ef
	add (hl)		; $58f0
	inc hl			; $58f1
	ld b,a			; $58f2
	ld e,$0d		; $58f3
	ld a,(de)		; $58f5
	add (hl)		; $58f6
	inc hl			; $58f7
	ld c,a			; $58f8
	push hl			; $58f9
	call checkTileCollisionAt_allowHoles		; $58fa
	pop hl			; $58fd
	ret			; $58fe
	ld hl,sp-$04		; $58ff
	ld hl,sp+$04		; $5901
.DB $fc				; $5903
	ld ($0804),sp		; $5904
	ld ($08fc),sp		; $5907
	inc b			; $590a
.DB $fc				; $590b
	ld hl,sp+$04		; $590c
	ld hl,sp-$33		; $590e
	ldd (hl),a		; $5910
	inc d			; $5911
	ld hl,hazardCollisionTable		; $5912
	call lookupCollisionTable		; $5915
	ret nc			; $5918
	call objectGetPosition		; $5919
	ld a,$05		; $591c
	add b			; $591e
	ld b,a			; $591f
	call checkTileCollisionAt_allowHoles		; $5920
	ret nc			; $5923
	ld b,$14		; $5924
	call $5961		; $5926
	ld e,$09		; $5929
	xor a			; $592b
	ld (de),a		; $592c
	jp objectApplySpeed		; $592d
_label_07_184:
	ld bc,$a8e8		; $5930
	ld e,$08		; $5933
	ld h,d			; $5935
	ld l,$0b		; $5936
	ld a,e			; $5938
	cp (hl)			; $5939
	jr c,_label_07_185	; $593a
	ld (hl),a		; $593c
_label_07_185:
	ld a,b			; $593d
	cp (hl)			; $593e
	jr nc,_label_07_186	; $593f
	ld (hl),a		; $5941
_label_07_186:
	ld l,$0d		; $5942
	ld a,e			; $5944
	cp (hl)			; $5945
	jr c,_label_07_187	; $5946
	ld (hl),a		; $5948
_label_07_187:
	ld a,c			; $5949
	cp (hl)			; $594a
	ret nc			; $594b
	ld (hl),a		; $594c
	ret			; $594d
	ld e,$33		; $594e
_label_07_188:
	ld a,(de)		; $5950
	cp $40			; $5951
	ld b,$78		; $5953
	jr nc,_label_07_189	; $5955
	and $38			; $5957
	swap a			; $5959
	rlca			; $595b
	ld hl,$596a		; $595c
	rst_addAToHl			; $595f
	ld b,(hl)		; $5960
_label_07_189:
	ld a,b			; $5961
	ld e,$10		; $5962
	ld (de),a		; $5964
	ret			; $5965
	ld e,$34		; $5966
	jr _label_07_188		; $5968
	ld a,(bc)		; $596a
	inc d			; $596b
	jr z,_label_07_192	; $596c
	inc a			; $596e
	ld b,(hl)		; $596f
	ld d,b			; $5970
	ld d,b			; $5971
	ld h,d			; $5972
	ld l,$33		; $5973
	inc (hl)		; $5975
	ret nz			; $5976
	dec (hl)		; $5977
	ret			; $5978
	ld h,d			; $5979
	ld l,$34		; $597a
	inc (hl)		; $597c
	ret nz			; $597d
	dec (hl)		; $597e
	ret			; $597f
	ld l,$33		; $5980
_label_07_190:
	ld h,d			; $5982
	ld a,(hl)		; $5983
	cp $40			; $5984
	jr c,_label_07_191	; $5986
	ld a,$40		; $5988
_label_07_191:
	or a			; $598a
	ret z			; $598b
	dec a			; $598c
	ld (hl),a		; $598d
	ret			; $598e
	ld l,$34		; $598f
	jr _label_07_190		; $5991
	ld e,$0b		; $5993
	ld a,(de)		; $5995
	add (hl)		; $5996
	inc hl			; $5997
	ld b,a			; $5998
	ld e,$0d		; $5999
	ld a,(de)		; $599b
	add (hl)		; $599c
	inc hl			; $599d
	ld c,a			; $599e
	push hl			; $599f
_label_07_192:
	call getTileAtPosition		; $59a0
	pop hl			; $59a3
	sub $b0			; $59a4
	cp $04			; $59a6
	ret			; $59a8
	call $59fb		; $59a9
	add a			; $59ac
	ld hl,$58ff		; $59ad
	rst_addDoubleIndex			; $59b0
	call $5993		; $59b1
	ret nc			; $59b4
	call $5993		; $59b5
	ret nc			; $59b8
	add $02			; $59b9
	and $03			; $59bb
	swap a			; $59bd
	rrca			; $59bf
	ld b,a			; $59c0
	ld e,$09		; $59c1
	ld a,(de)		; $59c3
	cp b			; $59c4
	ret nz			; $59c5
	sra a			; $59c6
	ld hl,$59eb		; $59c8
	rst_addAToHl			; $59cb
	ldi a,(hl)		; $59cc
	ld e,$08		; $59cd
	ld (de),a		; $59cf
	ldi a,(hl)		; $59d0
	ld e,$10		; $59d1
	ld (de),a		; $59d3
	ldi a,(hl)		; $59d4
	ld e,$14		; $59d5
	ld (de),a		; $59d7
	inc e			; $59d8
	ld a,(hl)		; $59d9
	ld (de),a		; $59da
	xor a			; $59db
	ld h,d			; $59dc
	ld l,$32		; $59dd
	ldi (hl),a		; $59df
	ldi (hl),a		; $59e0
	ld (hl),a		; $59e1
	ld l,$06		; $59e2
	ld (hl),$02		; $59e4
	ld l,$04		; $59e6
	ld (hl),$02		; $59e8
	ret			; $59ea
	nop			; $59eb
	jr z,_label_07_194	; $59ec
	cp $08			; $59ee
	jr z,_label_07_195	; $59f0
	cp $10			; $59f2
	jr z,_label_07_197	; $59f4
	cp $18			; $59f6
	jr z,_label_07_198	; $59f8
	cp $1e			; $59fa
	add hl,bc		; $59fc
	ld a,(de)		; $59fd
	add $04			; $59fe
	add a			; $5a00
	swap a			; $5a01
	and $03			; $5a03
	ret			; $5a05
	ld hl,$d080		; $5a06
_label_07_193:
	ld a,(hl)		; $5a09
	or a			; $5a0a
	call nz,$5a15		; $5a0b
	inc h			; $5a0e
	ld a,h			; $5a0f
	cp $e0			; $5a10
	jr c,_label_07_193	; $5a12
	ret			; $5a14
	push hl			; $5a15
	ld l,$8f		; $5a16
	bit 7,(hl)		; $5a18
	call z,preventObjectHFromPassingObjectD		; $5a1a
	pop hl			; $5a1d
	ret			; $5a1e
	ld e,$30		; $5a1f
	ld a,(de)		; $5a21
	ld b,a			; $5a22
	inc e			; $5a23
	ld a,(de)		; $5a24
	ld c,a			; $5a25
	jr _label_07_196		; $5a26
	call objectCheckIsOnHazard		; $5a28
	ret c			; $5a2b
	ld e,$0b		; $5a2c
_label_07_194:
	ld a,(de)		; $5a2e
	ld b,a			; $5a2f
	ld e,$0d		; $5a30
_label_07_195:
	ld a,(de)		; $5a32
	ld c,a			; $5a33
_label_07_196:
	ld e,$16		; $5a34
_label_07_197:
	ld a,(de)		; $5a36
	ld l,a			; $5a37
	inc e			; $5a38
	ld a,(de)		; $5a39
_label_07_198:
	ld h,a			; $5a3a
	push bc			; $5a3b
	ld bc,$0004		; $5a3c
	add hl,bc		; $5a3f
	pop bc			; $5a40
	ld a,b			; $5a41
	cp $18			; $5a42
	jr nc,_label_07_199	; $5a44
	ld a,$18		; $5a46
_label_07_199:
	cp $99			; $5a48
	jr c,_label_07_200	; $5a4a
	ld a,$98		; $5a4c
_label_07_200:
	ldi (hl),a		; $5a4e
	ld a,c			; $5a4f
	cp $18			; $5a50
	jr nc,_label_07_201	; $5a52
	ld a,$18		; $5a54
_label_07_201:
	cp $d9			; $5a56
	jr c,_label_07_202	; $5a58
	ld a,$d8		; $5a5a
_label_07_202:
	ld (hl),a		; $5a5c
	ret			; $5a5d
	ld a,($cc77)		; $5a5e
	rlca			; $5a61
	ret c			; $5a62
	ld a,($d004)		; $5a63
	cp $01			; $5a66
	ret nz			; $5a68
	call objectCheckCollidedWithLink_ignoreZ		; $5a69
	ret nc			; $5a6c
	ld a,($d00b)		; $5a6d
	ld b,a			; $5a70
	ld a,($d00d)		; $5a71
	ld c,a			; $5a74
	call objectCheckContainsPoint		; $5a75
	jr c,_label_07_203	; $5a78
	call objectGetAngleTowardLink		; $5a7a
	ld c,a			; $5a7d
	ld b,$78		; $5a7e
	jp updateLinkPositionGivenVelocity		; $5a80
_label_07_203:
	call objectGetAngleTowardLink		; $5a83
	ld c,a			; $5a86
	ld b,$14		; $5a87
	jp updateLinkPositionGivenVelocity		; $5a89

; ITEMID_28
itemCode28:
	ld e,$04		; $5a8c
	ld a,(de)		; $5a8e
	or a			; $5a8f
	jr nz,_label_07_204	; $5a90
	call itemIncState		; $5a92
	ld l,$06		; $5a95
	ld (hl),$14		; $5a97
	call _itemLoadAttributesAndGraphics		; $5a99
	jr _label_07_205		; $5a9c
_label_07_204:
	call $5aab		; $5a9e
	call $5ad4		; $5aa1
	call itemDecCounter1		; $5aa4
	ret nz			; $5aa7
	jp itemDelete		; $5aa8
_label_07_205:
	ld a,($d101)		; $5aab
	cp $0b			; $5aae
	ld hl,$5ad0		; $5ab0
	jr nz,_label_07_206	; $5ab3
	ld a,($d108)		; $5ab5
	add a			; $5ab8
	ld hl,$5ac0		; $5ab9
	rst_addDoubleIndex			; $5abc
_label_07_206:
	jp $5e5a		; $5abd
	stop			; $5ac0
	inc c			; $5ac1
.DB $f4				; $5ac2
	nop			; $5ac3
	inc c			; $5ac4
	ld (de),a		; $5ac5
	cp $08			; $5ac6
	stop			; $5ac8
	inc c			; $5ac9
	ld ($0c00),sp		; $5aca
	ld (de),a		; $5acd
	cp $f8			; $5ace
	jr _label_07_208		; $5ad0
	stop			; $5ad2
	nop			; $5ad3
	ld hl,$5b03		; $5ad4
	ld a,($d101)		; $5ad7
	cp $0b			; $5ada
	jr z,_label_07_207	; $5adc
	ld hl,$5b0c		; $5ade
_label_07_207:
	ld e,$0b		; $5ae1
	ld a,(de)		; $5ae3
	add (hl)		; $5ae4
	ld b,a			; $5ae5
	inc hl			; $5ae6
	ld e,$0d		; $5ae7
	ld a,(de)		; $5ae9
_label_07_208:
	add (hl)		; $5aea
	ld c,a			; $5aeb
	inc hl			; $5aec
	push hl			; $5aed
	ld a,($d101)		; $5aee
	cp $0b			; $5af1
	ld a,$0f		; $5af3
	jr z,_label_07_209	; $5af5
	ld a,$11		; $5af7
_label_07_209:
	call tryToBreakTile		; $5af9
	pop hl			; $5afc
	ld a,(hl)		; $5afd
	cp $ff			; $5afe
	jr nz,_label_07_207	; $5b00
	ret			; $5b02
	ld hl,sp+$08		; $5b03
	ld hl,sp-$08		; $5b05
	ld ($0808),sp		; $5b07
	ld hl,sp-$01		; $5b0a
	nop			; $5b0c
	nop			; $5b0d
	ld a,($ff00+$f0)	; $5b0e
	ld a,($ff00+$00)	; $5b10
	ld a,($ff00+$10)	; $5b12
	nop			; $5b14
	ld a,($ff00+$00)	; $5b15
	stop			; $5b17
	stop			; $5b18
	ld a,($ff00+$10)	; $5b19
	nop			; $5b1b
	stop			; $5b1c
	stop			; $5b1d
	rst $38			; $5b1e

; ITEMID_SHOVEL
itemCode15:
	ld e,$04		; $5b1f
	ld a,(de)		; $5b21
	or a			; $5b22
	jr nz,_label_07_211	; $5b23
	call _itemLoadAttributesAndGraphics		; $5b25
	call itemIncState		; $5b28
	ld l,$06		; $5b2b
	ld (hl),$04		; $5b2d
	ld a,$06		; $5b2f
	call itemTryToBreakTile		; $5b31
	ld a,$50		; $5b34
	jr nc,_label_07_210	; $5b36
	ld a,$01		; $5b38
	call addToGashaMaturity		; $5b3a
	ld a,$a9		; $5b3d
_label_07_210:
	jp playSound		; $5b3f
_label_07_211:
	call itemDecCounter1		; $5b42
	ret nz			; $5b45
	jp itemDelete		; $5b46

; ITEMID_ROD_OF_SEASONS
itemCode07:
	call $4a0a		; $5b49
	ld e,$04		; $5b4c
	ld a,(de)		; $5b4e
	rst_jumpTable			; $5b4f
	ld d,h			; $5b50
	ld e,e			; $5b51
	ld (hl),b		; $5b52
	ld e,e			; $5b53
	ld a,$01		; $5b54
	ld (de),a		; $5b56
	ld h,d			; $5b57
	ld l,$00		; $5b58
	ld (hl),$03		; $5b5a
	ld l,$06		; $5b5c
	ld (hl),$10		; $5b5e
	ld a,$74		; $5b60
	call playSound		; $5b62
	ld a,$1c		; $5b65
	call loadWeaponGfx		; $5b67
	call _itemLoadAttributesAndGraphics		; $5b6a
	jp objectSetVisible82		; $5b6d
	ld h,d			; $5b70
	ld l,$06		; $5b71
	dec (hl)		; $5b73
	ret nz			; $5b74
	ld a,($ccb6)		; $5b75
	cp $08			; $5b78
	ret nz			; $5b7a
	call getFreeInteractionSlot		; $5b7b
	ret nz			; $5b7e
	ld (hl),$15		; $5b7f
	ld e,$09		; $5b81
	ld l,$49		; $5b83
	ld a,(de)		; $5b85
	ldi (hl),a		; $5b86
	jp objectCopyPosition		; $5b87

; ITEMID_MINECART_COLLISION
itemCode1d:
	ld e,$04		; $5b8a
	ld a,(de)		; $5b8c
	or a			; $5b8d
	ret nz			; $5b8e
	call _itemLoadAttributesAndGraphics		; $5b8f
	call itemIncState		; $5b92
	ld l,$00		; $5b95
	set 1,(hl)		; $5b97
	ret			; $5b99

itemCode1dPost:
	ld hl,$d101		; $5b9a
	ld a,(hl)		; $5b9d
	cp $0a			; $5b9e
	jp z,objectTakePosition		; $5ba0
	jp itemDelete		; $5ba3

; ITEMID_SLINGSHOT
itemCode13:
	ld e,$04		; $5ba6
	ld a,(de)		; $5ba8
	or a			; $5ba9
	ret nz			; $5baa
	ld a,$1d		; $5bab
	call loadWeaponGfx		; $5bad
	call $4974		; $5bb0
	ld h,d			; $5bb3
	ld a,($c6b3)		; $5bb4
	or $08			; $5bb7
	ld l,$1b		; $5bb9
	ldi (hl),a		; $5bbb
	ld (hl),a		; $5bbc
	jp objectSetVisible81		; $5bbd
	ret			; $5bc0

; ITEMID_MAGNET_GLOVES
itemCode08:
	ld e,$04		; $5bc1
	ld a,(de)		; $5bc3
	rst_jumpTable			; $5bc4
	ret			; $5bc5
	ld e,e			; $5bc6
	call nc,$3e5b		; $5bc7
	ld e,$cd		; $5bca
	ld e,e			; $5bcc
	ld d,$cd		; $5bcd
	ld (hl),h		; $5bcf
	ld c,c			; $5bd0
	call objectSetVisible81		; $5bd1
	ld a,($cc79)		; $5bd4
	bit 1,a			; $5bd7
	ld a,$0c		; $5bd9
	jr z,_label_07_212	; $5bdb
	inc a			; $5bdd
_label_07_212:
	ld h,d			; $5bde
	ld l,$1b		; $5bdf
	ldi (hl),a		; $5be1
	ld (hl),a		; $5be2
	ret			; $5be3

; ITEMID_FOOLS_ORE
itemCode1e:
	ld e,$04		; $5be4
	ld a,(de)		; $5be6
	rst_jumpTable			; $5be7
.DB $ec				; $5be8
	ld e,e			; $5be9
	ret nz			; $5bea
	ld e,e			; $5beb
	ld a,$1f		; $5bec
	call loadWeaponGfx		; $5bee
	call $4974		; $5bf1
	xor a			; $5bf4
	call itemSetAnimation		; $5bf5
	jp objectSetVisible82		; $5bf8

; ITEMID_BIGGORON_SWORD
itemCode0c:
	ld e,$04		; $5bfb
	ld a,(de)		; $5bfd
	rst_jumpTable			; $5bfe
	inc bc			; $5bff
	ld e,h			; $5c00
	sbc c			; $5c01
	ld e,e			; $5c02
	ld a,$1b		; $5c03
	call loadWeaponGfx		; $5c05
	call $4974		; $5c08
	ld a,$b1		; $5c0b
	call playSound		; $5c0d
	jp objectSetVisible82		; $5c10

; ITEMID_SWORD
itemCode05:
	call $4a0a		; $5c13
	ld e,$04		; $5c16
	ld a,(de)		; $5c18
	rst_jumpTable			; $5c19
	jr nc,$5c		; $5c1a
	adc d			; $5c1c
	ld e,h			; $5c1d
	sub b			; $5c1e
	ld e,h			; $5c1f
	sub a			; $5c20
	ld e,h			; $5c21
	add l			; $5c22
	ld e,h			; $5c23
	and (hl)		; $5c24
	ld e,h			; $5c25
	ld b,(hl)		; $5c26
	ld e,h			; $5c27
	ld (hl),h		; $5c28
	ld (hl),l		; $5c29
	ld a,b			; $5c2a
	ld (hl),h		; $5c2b
	ld (hl),h		; $5c2c
	ld (hl),l		; $5c2d
	ld (hl),h		; $5c2e
	ld (hl),h		; $5c2f
	ld a,$1a		; $5c30
	call loadWeaponGfx		; $5c32
	call getRandomNumber_noPreserveVars		; $5c35
	and $07			; $5c38
	ld hl,$5c28		; $5c3a
	rst_addAToHl			; $5c3d
	ld a,(hl)		; $5c3e
	call playSound		; $5c3f
	ld e,$31		; $5c42
	xor a			; $5c44
	ld (de),a		; $5c45
	call $4974		; $5c46
	ld a,($c6ac)		; $5c49
	ld hl,$5c7d		; $5c4c
	rst_addDoubleIndex			; $5c4f
	ld e,$24		; $5c50
	ldi a,(hl)		; $5c52
	ld (de),a		; $5c53
	ld c,(hl)		; $5c54
	ld e,$31		; $5c55
	ld a,(de)		; $5c57
	or a			; $5c58
	ld a,c			; $5c59
	ld (de),a		; $5c5a
	jr nz,_label_07_213	; $5c5b
	ld a,$3e		; $5c5d
	call cpActiveRing		; $5c5f
	jr nz,_label_07_213	; $5c62
	call getRandomNumber		; $5c64
	or a			; $5c67
	ld c,$ff		; $5c68
	jr nz,_label_07_213	; $5c6a
	ld a,$d2		; $5c6c
	call playSound		; $5c6e
	ld c,$f4		; $5c71
_label_07_213:
	ld e,$3a		; $5c73
	ld a,c			; $5c75
	ld (de),a		; $5c76
	ld e,$04		; $5c77
	ld a,$01		; $5c79
	ld (de),a		; $5c7b
	jp objectSetVisible82		; $5c7c
	add h			; $5c7f
	cp $85			; $5c80
.DB $fd				; $5c82
	add (hl)		; $5c83
	ei			; $5c84
	ld e,$24		; $5c85
	ld a,$88		; $5c87
	ld (de),a		; $5c89
	ld h,d			; $5c8a
	ld l,$1b		; $5c8b
	ldi a,(hl)		; $5c8d
	ld (hl),a		; $5c8e
	ret			; $5c8f
	ld e,$31		; $5c90
	ld a,(de)		; $5c92
	ld e,$3a		; $5c93
	ld (de),a		; $5c95
	ret			; $5c96
	ld h,d			; $5c97
	ld l,$06		; $5c98
	inc (hl)		; $5c9a
	bit 2,(hl)		; $5c9b
	ld l,$1b		; $5c9d
	ldi a,(hl)		; $5c9f
	jr nz,_label_07_214	; $5ca0
	ld a,$0d		; $5ca2
_label_07_214:
	ld (hl),a		; $5ca4
	ret			; $5ca5
	ld a,$08		; $5ca6
	call $5f12		; $5ca8
	jp itemDelete		; $5cab


; ITEMID_NONE
; ITEMID_PUNCH
itemCode00:
itemCode02:
	ld e,$04		; $5cae
	ld a,(de)		; $5cb0
	rst_jumpTable			; $5cb1
	or (hl)			; $5cb2
	ld e,h			; $5cb3
	sbc $5c			; $5cb4
	call _itemLoadAttributesAndGraphics		; $5cb6
	ld c,$a6		; $5cb9
	call itemIncState		; $5cbb
	ld l,$06		; $5cbe
	ld (hl),$04		; $5cc0
	ld l,$02		; $5cc2
	bit 0,(hl)		; $5cc4
	jr z,_label_07_215	; $5cc6
	ld l,$26		; $5cc8
	ld a,$06		; $5cca
	ldi (hl),a		; $5ccc
	ldi (hl),a		; $5ccd
	ld a,(hl)		; $5cce
	add $fd			; $5ccf
	ld (hl),a		; $5cd1
	ld l,$24		; $5cd2
	inc (hl)		; $5cd4
	call $5f09		; $5cd5
	ld c,$6f		; $5cd8
_label_07_215:
	ld a,c			; $5cda
	jp playSound		; $5cdb
	call itemDecCounter1		; $5cde
	jp z,itemDelete		; $5ce1
	ret			; $5ce4

; ITEMID_SWORD_BEAM
itemCode27:
	ld e,$04		; $5ce5
	ld a,(de)		; $5ce7
	rst_jumpTable			; $5ce8
.DB $ed				; $5ce9
	ld e,h			; $5cea
	dec e			; $5ceb
	ld e,l			; $5cec
	ld hl,$5d11		; $5ced
	call _applyOffsetTableHL		; $5cf0
	call _itemLoadAttributesAndGraphics		; $5cf3
	call itemIncState		; $5cf6
	ld l,$10		; $5cf9
	ld (hl),$78		; $5cfb
	ld l,$08		; $5cfd
	ldi a,(hl)		; $5cff
	ld c,a			; $5d00
	swap a			; $5d01
	rrca			; $5d03
	ld (hl),a		; $5d04
	ld a,c			; $5d05
	call itemSetAnimation		; $5d06
	call objectSetVisible81		; $5d09
	ld a,$5d		; $5d0c
	jp playSound		; $5d0e
	push af			; $5d11
.DB $fc				; $5d12
	nop			; $5d13
	nop			; $5d14
	inc c			; $5d15
	nop			; $5d16
	ld a,(bc)		; $5d17
	inc bc			; $5d18
	nop			; $5d19
	nop			; $5d1a
	di			; $5d1b
	nop			; $5d1c
	call _itemUpdateDamageToApply		; $5d1d
	jr nz,_label_07_218	; $5d20
	call objectApplySpeed		; $5d22
	call objectCheckTileCollision_allowHoles		; $5d25
	jr nc,_label_07_216	; $5d28
	call _itemCheckCanPassSolidTile		; $5d2a
	jr nz,_label_07_218	; $5d2d
_label_07_216:
	ld a,(wFrameCounter)		; $5d2f
	and $03			; $5d32
	jr nz,_label_07_217	; $5d34
	ld h,d			; $5d36
	ld l,$1b		; $5d37
	ld a,(hl)		; $5d39
	xor $01			; $5d3a
	ldi (hl),a		; $5d3c
	ldi (hl),a		; $5d3d
_label_07_217:
	call objectCheckWithinScreenBoundary		; $5d3e
	ret c			; $5d41
	jp itemDelete		; $5d42
_label_07_218:
	ld bc,$0781		; $5d45
	call objectCreateInteraction		; $5d48
	jp itemDelete		; $5d4b
	ld l,$21		; $5d4e
	cp $07			; $5d50
	jr z,_label_07_220	; $5d52
	bit 6,(hl)		; $5d54
	jr z,_label_07_220	; $5d56
	res 6,(hl)		; $5d58
	ld a,(hl)		; $5d5a
	and $1f			; $5d5b
	cp $10			; $5d5d
	jr nc,_label_07_219	; $5d5f
	ld a,($d008)		; $5d61
	add a			; $5d64
_label_07_219:
	and $07			; $5d65
	push hl			; $5d67
	call $5f12		; $5d68
	pop hl			; $5d6b
_label_07_220:
	ld c,$10		; $5d6c
	ld a,(hl)		; $5d6e
	and $1f			; $5d6f
	cp c			; $5d71
	jr nc,_label_07_221	; $5d72
	srl a			; $5d74
	ld c,a			; $5d76
	ld a,($d008)		; $5d77
	add a			; $5d7a
	add a			; $5d7b
	add c			; $5d7c
	ld c,$00		; $5d7d
_label_07_221:
	ld hl,$5d92		; $5d7f
	rst_addAToHl			; $5d82
	ld a,(hl)		; $5d83
	and $f0			; $5d84
	swap a			; $5d86
	add c			; $5d88
	ld e,$30		; $5d89
	ld (de),a		; $5d8b
	ld a,(hl)		; $5d8c
	and $07			; $5d8d
	jp itemSetAnimation		; $5d8f
	ld (bc),a		; $5d92
	ld b,c			; $5d93
	add b			; $5d94
	ret nz			; $5d95
	stop			; $5d96
	ld d,c			; $5d97
	sub d			; $5d98
	jp nc,$6526		; $5d99
	and h			; $5d9c
.DB $e4				; $5d9d
	jr nc,_label_07_226	; $5d9e
	or (hl)			; $5da0
	or $00			; $5da1
	ld de,$3322		; $5da3
	ld b,h			; $5da6
	ld d,l			; $5da7
	ld h,(hl)		; $5da8
	ld (hl),a		; $5da9
	ld b,$00		; $5daa
	ld l,$21		; $5dac
	bit 6,(hl)		; $5dae
	jr z,_label_07_222	; $5db0
	res 6,(hl)		; $5db2
	inc b			; $5db4
_label_07_222:
	ld a,(hl)		; $5db5
	and $0e			; $5db6
	rrca			; $5db8
	ld c,a			; $5db9
	ld a,($d008)		; $5dba
	cp $01			; $5dbd
	jr nz,_label_07_223	; $5dbf
	ld a,c			; $5dc1
	jr _label_07_224		; $5dc2
_label_07_223:
	inc a			; $5dc4
	add a			; $5dc5
	sub c			; $5dc6
_label_07_224:
	and $07			; $5dc7
	bit 0,b			; $5dc9
	jr z,_label_07_225	; $5dcb
	push af			; $5dcd
	ld c,a			; $5dce
	ld a,$02		; $5dcf
	call $5f1c		; $5dd1
	pop af			; $5dd4
_label_07_225:
	ld e,$30		; $5dd5
	ld (de),a		; $5dd7
	jp itemSetAnimation		; $5dd8


; ITEMID_MAGNET_GLOVES
itemCode08Post:
	call $4b6e		; $5ddb
	jp nz,itemDelete		; $5dde
	ld hl,$d00b		; $5de1
	call objectTakePosition		; $5de4
	ld a,(wFrameCounter)		; $5de7
	rrca			; $5dea
	rrca			; $5deb
	ld a,($d008)		; $5dec
	adc a			; $5def
	ld e,$30		; $5df0
	ld (de),a		; $5df2
	jp itemSetAnimation		; $5df3


; ITEMID_SLINGSHOT
itemCode13Post:
	call $4b6e		; $5df6
	jp nz,itemDelete		; $5df9
	ld hl,$d00b		; $5dfc
	call objectTakePosition		; $5dff
	ld a,($d008)		; $5e02
	ld e,$30		; $5e05
	ld (de),a		; $5e07
	jp itemSetAnimation		; $5e08


; ITEMID_FOOLS_ORE
itemCode1ePost:
	call $4b6e		; $5e0b
	jp nz,itemDelete		; $5e0e
	ld l,$21		; $5e11
	ld a,(hl)		; $5e13
	and $06			; $5e14
	add a			; $5e16
_label_07_226:
	ld b,a			; $5e17
	ld a,($d008)		; $5e18
	add b			; $5e1b
	ld e,$30		; $5e1c
	ld (de),a		; $5e1e
	ld hl,$5e79		; $5e1f
	jr _label_07_227		; $5e22


; ITEMID_NONE
; ITEMID_PUNCH
itemCode00Post:
itemCode02Post:
	ld a,($d008)		; $5e24
	add $18			; $5e27
	ld hl,$5e79		; $5e29
	jr _label_07_227		; $5e2c


; ITEMID_BIGGORON_SWORD
itemCode0cPost:
	call $4b6e		; $5e2e
	jp nz,itemDelete		; $5e31
	call $5daa		; $5e34
	ld e,$30		; $5e37
	ld a,(de)		; $5e39
	ld hl,$5ee9		; $5e3a
	call $5e58		; $5e3d
	jp $5fb7		; $5e40


; ITEMID_CANE_OF_SOMARIA
; ITEMID_SWORD
; ITEMID_ROD_OF_SEASONS
itemCode04Post:
itemCode05Post:
itemCode07Post:
	call $4b6e		; $5e43
	jp nz,itemDelete		; $5e46
	call $5d4e		; $5e49
	ld e,$30		; $5e4c
	ld a,(de)		; $5e4e
	ld hl,$5e79		; $5e4f
	call $5e58		; $5e52
	jp $5fb7		; $5e55
_label_07_227:
	add a			; $5e58
	rst_addDoubleIndex			; $5e59
	ld e,$26		; $5e5a
	ldi a,(hl)		; $5e5c
	ld (de),a		; $5e5d
	inc e			; $5e5e
	ldi a,(hl)		; $5e5f
	ld (de),a		; $5e60
	ld a,($d00b)		; $5e61
	add (hl)		; $5e64
	ld e,$0b		; $5e65
	ld (de),a		; $5e67
	inc hl			; $5e68
	ld e,$0d		; $5e69
	ld a,($d00d)		; $5e6b
	add (hl)		; $5e6e
	ld (de),a		; $5e6f
	ld a,($d00f)		; $5e70
	ld e,$0f		; $5e73
	sub $02			; $5e75
	ld (de),a		; $5e77
	ret			; $5e78
	add hl,bc		; $5e79
	ld b,$fe		; $5e7a
	stop			; $5e7c
	ld b,$09		; $5e7d
	ld a,($ff00+c)		; $5e7f
	nop			; $5e80
	add hl,bc		; $5e81
	ld b,$00		; $5e82
	pop af			; $5e84
	ld b,$09		; $5e85
	ld a,($ff00+c)		; $5e87
	nop			; $5e88
	rlca			; $5e89
	rlca			; $5e8a
	push af			; $5e8b
	dec c			; $5e8c
	rlca			; $5e8d
	rlca			; $5e8e
	push af			; $5e8f
	dec c			; $5e90
	rlca			; $5e91
	rlca			; $5e92
	ld de,$07f3		; $5e93
	rlca			; $5e96
	push af			; $5e97
	di			; $5e98
	add hl,bc		; $5e99
	ld b,$ef		; $5e9a
.DB $fc				; $5e9c
	ld b,$09		; $5e9d
	ld (bc),a		; $5e9f
	inc de			; $5ea0
	add hl,bc		; $5ea1
	ld b,$15		; $5ea2
	inc bc			; $5ea4
	ld b,$09		; $5ea5
	ld (bc),a		; $5ea7
.DB $ed				; $5ea8
	add hl,bc		; $5ea9
	ld b,$f6		; $5eaa
.DB $fc				; $5eac
	inc b			; $5ead
	add hl,bc		; $5eae
	ld (bc),a		; $5eaf
	inc c			; $5eb0
	add hl,bc		; $5eb1
	ld b,$10		; $5eb2
	inc bc			; $5eb4
	ld b,$09		; $5eb5
	ld (bc),a		; $5eb7
.DB $f4				; $5eb8
	add hl,bc		; $5eb9
	add hl,bc		; $5eba
	rst $28			; $5ebb
.DB $fc				; $5ebc
	add hl,bc		; $5ebd
	add hl,bc		; $5ebe
	ld a,($ff00+c)		; $5ebf
	stop			; $5ec0
	add hl,bc		; $5ec1
	add hl,bc		; $5ec2
	ld (bc),a		; $5ec3
	inc de			; $5ec4
	add hl,bc		; $5ec5
	add hl,bc		; $5ec6
	ld (de),a		; $5ec7
	stop			; $5ec8
	add hl,bc		; $5ec9
	add hl,bc		; $5eca
	dec d			; $5ecb
	inc bc			; $5ecc
	add hl,bc		; $5ecd
	add hl,bc		; $5ece
	ld de,$09f3		; $5ecf
	add hl,bc		; $5ed2
	ld (bc),a		; $5ed3
.DB $ed				; $5ed4
	add hl,bc		; $5ed5
	add hl,bc		; $5ed6
	push af			; $5ed7
	di			; $5ed8
	dec b			; $5ed9
	dec b			; $5eda
.DB $f4				; $5edb
.DB $fd				; $5edc
	dec b			; $5edd
	dec b			; $5ede
	nop			; $5edf
	inc c			; $5ee0
	dec b			; $5ee1
	dec b			; $5ee2
	inc c			; $5ee3
	inc bc			; $5ee4
	dec b			; $5ee5
	dec b			; $5ee6
	nop			; $5ee7
.DB $f4				; $5ee8
	dec bc			; $5ee9
	dec bc			; $5eea
	rst $28			; $5eeb
	cp $09			; $5eec
	inc c			; $5eee
	ld a,($ff00+c)		; $5eef
	stop			; $5ef0
	dec bc			; $5ef1
	dec bc			; $5ef2
	ld (bc),a		; $5ef3
	inc de			; $5ef4
	inc c			; $5ef5
	add hl,bc		; $5ef6
	ld (de),a		; $5ef7
	stop			; $5ef8
	dec bc			; $5ef9
	dec bc			; $5efa
	dec d			; $5efb
	ld bc,$0c09		; $5efc
	ld de,$0bf3		; $5eff
	dec bc			; $5f02
	ld (bc),a		; $5f03
.DB $ed				; $5f04
	inc c			; $5f05
	add hl,bc		; $5f06
	push af			; $5f07
	di			; $5f08
	ld a,($d008)		; $5f09
	add a			; $5f0c
	ld c,a			; $5f0d
	ld a,$03		; $5f0e
	jr _label_07_228		; $5f10
	ld c,a			; $5f12
	ld a,($c6ac)		; $5f13
	cp $01			; $5f16
	jr z,_label_07_228	; $5f18
	ld a,$02		; $5f1a
_label_07_228:
	ld e,a			; $5f1c
	ld a,($d00f)		; $5f1d
	dec a			; $5f20
	cp $f6			; $5f21
	ret c			; $5f23
	ld a,c			; $5f24
	ld hl,$5f79		; $5f25
	rst_addDoubleIndex			; $5f28
	ld a,($d00b)		; $5f29
	add (hl)		; $5f2c
	ld b,a			; $5f2d
	inc hl			; $5f2e
	ld a,($d00d)		; $5f2f
	add (hl)		; $5f32
	ld c,a			; $5f33
	push bc			; $5f34
	ld a,e			; $5f35
	call tryToBreakTile		; $5f36
	ldh a,(<hFF93)	; $5f39
	ld ($ccc7),a		; $5f3b
	ldh a,(<hFF92)	; $5f3e
	ld ($ccc6),a		; $5f40
	pop bc			; $5f43
	ret c			; $5f44
	ld hl,$5f8b		; $5f45
	call findByteInCollisionTable		; $5f48
	jr c,_label_07_229	; $5f4b
	ld a,($d202)		; $5f4d
	or a			; $5f50
	ret z			; $5f51
	call findByteAtHl		; $5f52
	ret c			; $5f55
	ldh a,(<hFF93)	; $5f56
	ld l,a			; $5f58
	ld h,$ce		; $5f59
	ld a,(hl)		; $5f5b
	cp $0f			; $5f5c
	ret nz			; $5f5e
	ld e,$01		; $5f5f
	jr _label_07_230		; $5f61
_label_07_229:
	ld a,$58		; $5f63
	call playSound		; $5f65
	ld e,$80		; $5f68
_label_07_230:
	call getFreeInteractionSlot		; $5f6a
	ret nz			; $5f6d
	ld (hl),$07		; $5f6e
	inc l			; $5f70
	ld (hl),e		; $5f71
	ld l,$4b		; $5f72
	ld (hl),b		; $5f74
	ld l,$4d		; $5f75
	ld (hl),c		; $5f77
	ret			; $5f78
	ld a,($ff00+c)		; $5f79
	nop			; $5f7a
	ld a,($ff00+c)		; $5f7b
	dec c			; $5f7c
	nop			; $5f7d
	dec c			; $5f7e
	dec c			; $5f7f
	dec c			; $5f80
	dec c			; $5f81
	nop			; $5f82
	dec c			; $5f83
	ld a,($ff00+c)		; $5f84
	nop			; $5f85
	ld a,($ff00+c)		; $5f86
	ld a,($ff00+c)		; $5f87
	ld a,($ff00+c)		; $5f88
	nop			; $5f89
	nop			; $5f8a
	sub a			; $5f8b
	ld e,a			; $5f8c
	and e			; $5f8d
	ld e,a			; $5f8e
	and l			; $5f8f
	ld e,a			; $5f90
	and a			; $5f91
	ld e,a			; $5f92
	and a			; $5f93
	ld e,a			; $5f94
	or h			; $5f95
	ld e,a			; $5f96
	pop bc			; $5f97
	jp nz,$cbe2		; $5f98
	nop			; $5f9b
.DB $fd				; $5f9c
	cp $ff			; $5f9d
	reti			; $5f9f
	jp c,$d720		; $5fa0
	nop			; $5fa3
.DB $fd				; $5fa4
	nop			; $5fa5
	nop			; $5fa6
	rra			; $5fa7
	jr nc,_label_07_233	; $5fa8
	ldd (hl),a		; $5faa
	inc sp			; $5fab
	jr c,_label_07_236	; $5fac
	ldd a,(hl)		; $5fae
	dec sp			; $5faf
	nop			; $5fb0
	ld a,(bc)		; $5fb1
	dec bc			; $5fb2
	nop			; $5fb3
	ld (de),a		; $5fb4
	nop			; $5fb5
	nop			; $5fb6
	ld e,$3a		; $5fb7
	ld a,(de)		; $5fb9
	ld b,a			; $5fba
	ld a,($d23a)		; $5fbb
	or a			; $5fbe
	jr nz,_label_07_239	; $5fbf
	ld hl,$6003		; $5fc1
	ld a,($c6c5)		; $5fc4
	ld e,a			; $5fc7
_label_07_231:
	ldi a,(hl)		; $5fc8
	or a			; $5fc9
	jr z,_label_07_232	; $5fca
	cp e			; $5fcc
	jr z,_label_07_238	; $5fcd
	inc hl			; $5fcf
	jr _label_07_231		; $5fd0
_label_07_232:
	ld a,e			; $5fd2
	cp $07			; $5fd3
	jr z,_label_07_234	; $5fd5
	cp $09			; $5fd7
	jr z,_label_07_235	; $5fd9
_label_07_233:
	cp $0a			; $5fdb
	jr z,_label_07_237	; $5fdd
	ld a,b			; $5fdf
	jr _label_07_240		; $5fe0
_label_07_234:
	ld a,b			; $5fe2
	jr _label_07_239		; $5fe3
_label_07_235:
	ld a,b			; $5fe5
	cpl			; $5fe6
_label_07_236:
	inc a			; $5fe7
	sra a			; $5fe8
	cpl			; $5fea
	inc a			; $5feb
	jr _label_07_239		; $5fec
_label_07_237:
	ld a,b			; $5fee
	cpl			; $5fef
	inc a			; $5ff0
	sra a			; $5ff1
	cpl			; $5ff3
	inc a			; $5ff4
	jr _label_07_240		; $5ff5
_label_07_238:
	ld a,(hl)		; $5ff7
_label_07_239:
	add b			; $5ff8
_label_07_240:
	bit 7,a			; $5ff9
	jr nz,_label_07_241	; $5ffb
	ld a,$ff		; $5ffd
_label_07_241:
	ld e,$28		; $5fff
	ld (de),a		; $6001
	ret			; $6002
	ld bc,$02ff		; $6003
	cp $03			; $6006
.DB $fd				; $6008
	inc b			; $6009
	ld bc,$0105		; $600a
	ld b,$01		; $600d
	nop			; $600f
	call getTileMappingData		; $6010
	push bc			; $6013
	ld h,d			; $6014
	ld l,$1b		; $6015
	ld a,$0f		; $6017
	ldi (hl),a		; $6019
	ldi (hl),a		; $601a
	ld (hl),c		; $601b
	ld a,($cec1)		; $601c
	sub c			; $601f
	jr z,_label_07_242	; $6020
	ld a,$01		; $6022
_label_07_242:
	call itemSetAnimation		; $6024
	pop af			; $6027
	and $07			; $6028
	swap a			; $602a
	rrca			; $602c
	ld hl,$de80		; $602d
	rst_addAToHl			; $6030
	push de			; $6031
	ld a,$02		; $6032
	ld ($ff00+$70),a	; $6034
	ld de,$def8		; $6036
	ld b,$08		; $6039
	call copyMemory		; $603b
	ld hl,$ffa5		; $603e
	set 7,(hl)		; $6041
	xor a			; $6043
	ld ($ff00+$70),a	; $6044
	pop de			; $6046
	ret			; $6047

; ITEMID_BRACELET
itemCode16:
	ld e,$04		; $6048
	ld a,(de)		; $604a
	rst_jumpTable			; $604b
	ld d,h			; $604c
	ld h,b			; $604d
	ld l,h			; $604e
	ld h,b			; $604f
	ld l,h			; $6050
	ld h,b			; $6051
	xor (hl)		; $6052
	ld h,b			; $6053
	call _itemLoadAttributesAndGraphics		; $6054
	ld h,d			; $6057
	ld l,$00		; $6058
	set 1,(hl)		; $605a
	ld l,$02		; $605c
	ld a,(hl)		; $605e
	or a			; $605f
	jr z,_label_07_243	; $6060
	ld l,$04		; $6062
	ld (hl),$02		; $6064
	call $6010		; $6066
	jp objectSetVisiblec0		; $6069
	ld h,d			; $606c
	ld l,$05		; $606d
	ld a,(hl)		; $606f
	or a			; $6070
	ret z			; $6071
	ld l,$27		; $6072
	ld a,$06		; $6074
	ldd (hl),a		; $6076
	ldd (hl),a		; $6077
	dec l			; $6078
	set 7,(hl)		; $6079
	jr _label_07_245		; $607b
_label_07_243:
	call $6112		; $607d
	ld a,h			; $6080
	cp $d1			; $6081
	jr z,_label_07_244	; $6083
	ld a,l			; $6085
	cp $40			; $6086
	jr c,_label_07_245	; $6088
_label_07_244:
	ld a,$09		; $608a
	call objectGetRelatedObject2Var		; $608c
	ld e,$09		; $608f
	ld a,(de)		; $6091
	ld (hl),a		; $6092
	ld a,l			; $6093
	add $1d			; $6094
	ld l,a			; $6096
	ld e,$26		; $6097
	ldi a,(hl)		; $6099
	ld (de),a		; $609a
	inc e			; $609b
	ldi a,(hl)		; $609c
	ld (de),a		; $609d
	ld h,d			; $609e
	ld l,$24		; $609f
	set 7,(hl)		; $60a1
_label_07_245:
	call $614f		; $60a3
	ld h,d			; $60a6
	ld l,$04		; $60a7
	ld (hl),$03		; $60a9
	inc l			; $60ab
	ld (hl),$00		; $60ac
	call $6112		; $60ae
	call $61a5		; $60b1
	jr z,_label_07_249	; $60b4
	ld e,$39		; $60b6
	ld a,(de)		; $60b8
	ld c,a			; $60b9
	call $4a8d		; $60ba
	jr nc,_label_07_247	; $60bd
	call $6109		; $60bf
	jr nz,_label_07_249	; $60c2
	jr nc,_label_07_246	; $60c4
	call objectReplaceWithAnimationIfOnHazard		; $60c6
	ret c			; $60c9
_label_07_246:
	call $6220		; $60ca
	jr c,_label_07_248	; $60cd
_label_07_247:
	ld e,$02		; $60cf
	ld a,(de)		; $60d1
	or a			; $60d2
	ret nz			; $60d3
	ld a,$0b		; $60d4
	call objectGetRelatedObject2Var		; $60d6
	jp objectCopyPosition		; $60d9
_label_07_248:
	ld e,$02		; $60dc
	ld a,(de)		; $60de
	cp $d7			; $60df
	jr z,_label_07_250	; $60e1
	ld a,$05		; $60e3
	call objectGetRelatedObject2Var		; $60e5
	ld (hl),$03		; $60e8
	jp itemDelete		; $60ea
_label_07_249:
	ld e,$02		; $60ed
	ld a,(de)		; $60ef
	cp $d7			; $60f0
	jr nz,_label_07_251	; $60f2
_label_07_250:
	call objectCreatePuff		; $60f4
	jp itemDelete		; $60f7
_label_07_251:
	call objectReplaceWithAnimationIfOnHazard		; $60fa
	ret c			; $60fd
	ld hl,$47bb		; $60fe
	ld e,$06		; $6101
	call interBankCall		; $6103
	jp itemDelete		; $6106
	ld e,$02		; $6109
	ld a,(de)		; $610b
	or a			; $610c
	ret z			; $610d
	cp $d7			; $610e
	scf			; $6110
	ret			; $6111
	ld e,$02		; $6112
	ld a,(de)		; $6114
	or a			; $6115
	jr nz,_label_07_253	; $6116
	xor a			; $6118
	call objectGetRelatedObject2Var		; $6119
	bit 0,(hl)		; $611c
	jr z,_label_07_252	; $611e
	ld a,l			; $6120
	add $04			; $6121
	ld l,a			; $6123
	ldi a,(hl)		; $6124
	cp $02			; $6125
	jr nz,_label_07_252	; $6127
	ld a,(hl)		; $6129
	cp $03			; $612a
	ret c			; $612c
_label_07_252:
	pop af			; $612d
	jp itemDelete		; $612e
_label_07_253:
	call objectCheckWithinRoomBoundary		; $6131
	jr nc,_label_07_252	; $6134
	ld h,d			; $6136
	ld l,$05		; $6137
	ret			; $6139
	ld h,d			; $613a
	ld l,$3b		; $613b
	bit 0,(hl)		; $613d
	jr z,_label_07_254	; $613f
	ld l,$10		; $6141
	ld (hl),$00		; $6143
_label_07_254:
	ld l,$37		; $6145
	bit 0,(hl)		; $6147
	call z,$614f		; $6149
	jp $61a5		; $614c
	call $49aa		; $614f
	ld a,($d008)		; $6152
	ld hl,$61a0		; $6155
	rst_addAToHl			; $6158
	ldi a,(hl)		; $6159
	ld c,(hl)		; $615a
	ld h,d			; $615b
	ld l,$0b		; $615c
	add (hl)		; $615e
	ldi (hl),a		; $615f
	inc l			; $6160
	ld a,(hl)		; $6161
	add c			; $6162
	ld (hl),a		; $6163
	ld l,$00		; $6164
	res 1,(hl)		; $6166
	ld l,$37		; $6168
	set 0,(hl)		; $616a
	inc l			; $616c
	ld a,(hl)		; $616d
	and $f0			; $616e
	swap a			; $6170
	add a			; $6172
	ld hl,$6258		; $6173
	rst_addDoubleIndex			; $6176
	ldi a,(hl)		; $6177
	ld e,$39		; $6178
	ld (de),a		; $617a
	ld e,$09		; $617b
	ld a,(de)		; $617d
	rlca			; $617e
	jr c,_label_07_256	; $617f
	ld e,$14		; $6181
	ldi a,(hl)		; $6183
	ld (de),a		; $6184
	inc e			; $6185
	ld a,$ff		; $6186
	ld (de),a		; $6188
	ld a,$12		; $6189
	call cpActiveRing		; $618b
	jr nz,_label_07_255	; $618e
	inc hl			; $6190
_label_07_255:
	ld e,$10		; $6191
	ldi a,(hl)		; $6193
	ld (de),a		; $6194
	ret			; $6195
_label_07_256:
	ld h,d			; $6196
	ld l,$10		; $6197
	xor a			; $6199
	ld (hl),a		; $619a
	ld l,$14		; $619b
	ldi (hl),a		; $619d
	ldi (hl),a		; $619e
	ret			; $619f
	rst $38			; $61a0
	nop			; $61a1
	ld bc,$ff00		; $61a2
	ld e,$38		; $61a5
	ld a,(de)		; $61a7
	cp $40			; $61a8
	jr nc,_label_07_257	; $61aa
	cp $20			; $61ac
	jr nc,_label_07_258	; $61ae
_label_07_257:
	ld e,$09		; $61b0
	ld a,(de)		; $61b2
	cp $ff			; $61b3
	jr z,_label_07_263	; $61b5
	and $18			; $61b7
	rrca			; $61b9
	rrca			; $61ba
	ld hl,$4c1b		; $61bb
	rst_addAToHl			; $61be
	ldi a,(hl)		; $61bf
	ld c,(hl)		; $61c0
	ld h,d			; $61c1
	ld l,$0b		; $61c2
	add (hl)		; $61c4
	cp $b0			; $61c5
	jr nc,_label_07_261	; $61c7
	ld b,a			; $61c9
	ld l,$0d		; $61ca
	ld a,c			; $61cc
	add (hl)		; $61cd
	ld c,a			; $61ce
	call checkTileCollisionAt_allowHoles		; $61cf
	jr nc,_label_07_261	; $61d2
	call $4b78		; $61d4
	jr z,_label_07_261	; $61d7
	jr _label_07_260		; $61d9
_label_07_258:
	ld h,d			; $61db
	ld l,$0b		; $61dc
	ld b,(hl)		; $61de
	ld l,$0d		; $61df
	ld c,(hl)		; $61e1
	ld e,$09		; $61e2
	ld a,(de)		; $61e4
	and $18			; $61e5
	ld hl,$6238		; $61e7
	rst_addAToHl			; $61ea
	ld e,$04		; $61eb
_label_07_259:
	push bc			; $61ed
	ldi a,(hl)		; $61ee
	add b			; $61ef
	ld b,a			; $61f0
	ldi a,(hl)		; $61f1
	add c			; $61f2
	ld c,a			; $61f3
	push hl			; $61f4
	call checkTileCollisionAt_allowHoles		; $61f5
	pop hl			; $61f8
	pop bc			; $61f9
	jr c,_label_07_260	; $61fa
	dec e			; $61fc
	jr nz,_label_07_259	; $61fd
	jr _label_07_261		; $61ff
_label_07_260:
	call $6109		; $6201
	jr nz,_label_07_264	; $6204
	ld e,$09		; $6206
	ld a,$ff		; $6208
	ld (de),a		; $620a
_label_07_261:
	ld a,($cc50)		; $620b
	and $20			; $620e
	jr z,_label_07_262	; $6210
	ld e,$09		; $6212
	ld a,(de)		; $6214
	and $0f			; $6215
	jr z,_label_07_263	; $6217
_label_07_262:
	call objectApplySpeed		; $6219
_label_07_263:
	or d			; $621c
	ret			; $621d
_label_07_264:
	xor a			; $621e
	ret			; $621f
	ld a,$52		; $6220
	call playSound		; $6222
	call objectNegateAndHalveSpeedZ		; $6225
	ret c			; $6228
	ld e,$10		; $6229
	ld a,(de)		; $622b
	ld e,a			; $622c
	ld hl,$6270		; $622d
	call lookupKey		; $6230
	ld e,$10		; $6233
	ld (de),a		; $6235
	or a			; $6236
	ret			; $6237
	nop			; $6238
	nop			; $6239
	ld a,($fafa)		; $623a
	nop			; $623d
	ld a,($0005)		; $623e
	nop			; $6241
	ld a,($0005)		; $6242
	dec b			; $6245
	dec b			; $6246
	dec b			; $6247
	nop			; $6248
	nop			; $6249
_label_07_265:
	dec b			; $624a
	ei			; $624b
	dec b			; $624c
	nop			; $624d
	dec b			; $624e
	dec b			; $624f
	nop			; $6250
	nop			; $6251
	ld a,($00fa)		; $6252
	ld a,($fa06)		; $6255
	inc e			; $6258
	stop			; $6259
	inc a			; $625a
	ld h,h			; $625b
	jr nz,_label_07_266	; $625c
_label_07_266:
	inc d			; $625e
	jr z,_label_07_270	; $625f
	nop			; $6261
	jr z,_label_07_272	; $6262
	jr nz,_label_07_267	; $6264
_label_07_267:
	ld e,$28		; $6266
	jr nz,_label_07_265	; $6268
	ldd (hl),a		; $626a
	inc a			; $626b
	jr nz,_label_07_268	; $626c
_label_07_268:
	inc d			; $626e
	jr z,_label_07_269	; $626f
	nop			; $6271
	ld a,(bc)		; $6272
	dec b			; $6273
	rrca			; $6274
	dec b			; $6275
_label_07_269:
	inc d			; $6276
	ld a,(bc)		; $6277
	add hl,de		; $6278
	ld a,(bc)		; $6279
	ld e,$0f		; $627a
	inc hl			; $627c
	rrca			; $627d
	jr z,_label_07_271	; $627e
	dec l			; $6280
_label_07_270:
	inc d			; $6281
	ldd (hl),a		; $6282
	add hl,de		; $6283
	scf			; $6284
	add hl,de		; $6285
	inc a			; $6286
	ld e,$41		; $6287
	ld e,$46		; $6289
	inc hl			; $628b
	ld c,e			; $628c
	inc hl			; $628d
	ld d,b			; $628e
	jr z,$55		; $628f
	jr z,_label_07_273	; $6291
	dec l			; $6293
_label_07_271:
	ld e,a			; $6294
	dec l			; $6295
	ld h,h			; $6296
	ldd (hl),a		; $6297
	ld l,c			; $6298
	ldd (hl),a		; $6299
	ld l,(hl)		; $629a
	scf			; $629b
	ld (hl),e		; $629c
	scf			; $629d
	ld a,b			; $629e
	inc a			; $629f
_label_07_272:
	nop			; $62a0
	nop			; $62a1

; ITEMID_DUST
itemCode1a:
	ld e,$05		; $62a2
	ld a,(de)		; $62a4
	rst_jumpTable			; $62a5
	xor h			; $62a6
	ld h,d			; $62a7
	cp a			; $62a8
	ld h,d			; $62a9
	rst_addDoubleIndex			; $62aa
	ld h,d			; $62ab
	call _itemLoadAttributesAndGraphics		; $62ac
	call itemIncState2		; $62af
	ld hl,$d00b		; $62b2
	call objectTakePosition		; $62b5
	xor a			; $62b8
	call itemSetAnimation		; $62b9
	jp objectSetVisible80		; $62bc
	call itemAnimate		; $62bf
	call $631b		; $62c2
	ld a,(hl)		; $62c5
	inc a			; $62c6
	and $fb			; $62c7
	xor $60			; $62c9
	ldd (hl),a		; $62cb
	ld (hl),a		; $62cc
	bit 7,b			; $62cd
	ret z			; $62cf
	ld a,$0b		; $62d0
	ldi (hl),a		; $62d2
	ld (hl),a		; $62d3
	ld l,$0e		; $62d4
	xor a			; $62d6
	ldi (hl),a		; $62d7
	ld (hl),a		; $62d8
	call objectSetInvisible		; $62d9
	jp itemIncState2		; $62dc
	call checkPegasusSeedCounter		; $62df
	jp z,itemDelete		; $62e2
	call $632e		; $62e5
	call itemDecCounter1		; $62e8
	bit 0,(hl)		; $62eb
_label_07_273:
	ld l,$30		; $62ed
	jr z,_label_07_274	; $62ef
	ld l,$34		; $62f1
_label_07_274:
	bit 7,(hl)		; $62f3
	jp z,objectSetInvisible		; $62f5
	inc (hl)		; $62f8
	ld a,(hl)		; $62f9
	cp $82			; $62fa
	jr c,_label_07_275	; $62fc
	ld (hl),$80		; $62fe
	inc l			; $6300
	inc (hl)		; $6301
	ld a,(hl)		; $6302
	dec l			; $6303
	cp $03			; $6304
	jr nc,_label_07_276	; $6306
_label_07_275:
	inc l			; $6308
	ldi a,(hl)		; $6309
	inc a			; $630a
	ld c,a			; $630b
	ldi a,(hl)		; $630c
	ld e,$0b		; $630d
	ld (de),a		; $630f
	ldi a,(hl)		; $6310
	ld e,$0d		; $6311
	ld (de),a		; $6313
	ld a,c			; $6314
	call itemSetAnimation		; $6315
	call objectSetVisible80		; $6318
	ld h,d			; $631b
	ld l,$21		; $631c
	ld a,(hl)		; $631e
	ld b,a			; $631f
	and $7f			; $6320
	ld l,$1d		; $6322
	ldd (hl),a		; $6324
	ret			; $6325
_label_07_276:
	xor a			; $6326
	ldi (hl),a		; $6327
	ldi (hl),a		; $6328
	ldi (hl),a		; $6329
	ldi (hl),a		; $632a
	jp objectSetInvisible		; $632b
	ld h,d			; $632e
	ld l,$02		; $632f
	bit 0,(hl)		; $6331
	ret z			; $6333
	ld (hl),$00		; $6334
	ld l,$30		; $6336
	bit 7,(hl)		; $6338
	jr z,_label_07_277	; $633a
	ld l,$34		; $633c
	bit 7,(hl)		; $633e
	ret nz			; $6340
_label_07_277:
	ld a,$80		; $6341
	ldi (hl),a		; $6343
	xor a			; $6344
	ldi (hl),a		; $6345
	ld a,($d00b)		; $6346
	add $05			; $6349
	ldi (hl),a		; $634b
	ld a,($d00d)		; $634c
	ld (hl),a		; $634f
	ret			; $6350

.ends

.include "data/seasons/itemAttributes.s"
.include "data/itemAnimations.s"


 ; This section can't be superfree, since it must be in the same bank as section
 ; "Enemy_Part_Collisions".
 m_section_free "Bank_7_Data" namespace "bank7"

	.include "data/seasons/enemyActiveCollisions.s"
	.include "data/seasons/partActiveCollisions.s"
	.include "data/seasons/objectCollisionTable.s"

.ends


.BANK $08 SLOT 1
.ORG 0

.include "code/seasons/interactionCode/bank08.s"

.BANK $09 SLOT 1
.ORG 0

.include "code/seasons/interactionCode/bank09.s"

.BANK $0a SLOT 1
.ORG 0

.include "code/seasons/interactionCode/bank0a.s"

.BANK $0b SLOT 1
.ORG 0

	.include "code/scripting.s"
	.include "scripts/seasons/scripts.s"


.BANK $0c SLOT 1
.ORG 0

.section Enemy_Code_Bank0c

	.include "code/enemyCommon.s"
	.include "code/seasons/enemyCode/bank0c.s"
	.include "data/seasons/enemyAnimations.s"

.ends

.BANK $0d SLOT 1
.ORG 0

.section Enemy_Code_Bank0d

	.include "code/enemyCommon.s"
	.include "code/seasons/enemyCode/bank0d.s"

objectLoadMovementScript_body:
	ldh a,(<hActiveObjectType)	; $798f
	add $02			; $7991
	ld e,a			; $7993
	ld a,(de)		; $7994
	rst_addDoubleIndex			; $7995
	ldi a,(hl)		; $7996
	ld h,(hl)		; $7997
	ld l,a			; $7998
	ld a,e			; $7999
	add $0e			; $799a
	ld e,a			; $799c
	ldi a,(hl)		; $799d
	ld (de),a		; $799e
	ld a,e			; $799f
	add $f8			; $79a0
	ld e,a			; $79a2
	ldi a,(hl)		; $79a3
	ld (de),a		; $79a4
	ld a,e			; $79a5
	add $28			; $79a6
	ld e,a			; $79a8
	ld a,l			; $79a9
	ld (de),a		; $79aa
	inc e			; $79ab
	ld a,h			; $79ac
	ld (de),a		; $79ad
objectRunMovementScript_body:
	ldh a,(<hActiveObjectType)	; $79ae
	add $30			; $79b0
	ld e,a			; $79b2
	ld a,(de)		; $79b3
	ld l,a			; $79b4
	inc e			; $79b5
	ld a,(de)		; $79b6
	ld h,a			; $79b7
_label_0d_350:
	ldi a,(hl)		; $79b8
	push hl			; $79b9
	rst_jumpTable			; $79ba
	rst_jumpTable			; $79bb
	ld a,c			; $79bc
	call $e379		; $79bd
	ld a,c			; $79c0
	ld sp,hl		; $79c1
	ld a,c			; $79c2
	rrca			; $79c3
	ld a,d			; $79c4
	dec h			; $79c5
	ld a,d			; $79c6
	pop hl			; $79c7
	ldi a,(hl)		; $79c8
	ld h,(hl)		; $79c9
	ld l,a			; $79ca
	jr _label_0d_350		; $79cb
	pop bc			; $79cd
	ld h,d			; $79ce
	ldh a,(<hActiveObjectType)	; $79cf
	add $32			; $79d1
	ld l,a			; $79d3
	ld a,(bc)		; $79d4
	ld (hl),a		; $79d5
	ld a,l			; $79d6
	add $d7			; $79d7
	ld l,a			; $79d9
	ld (hl),$00		; $79da
	add $fb			; $79dc
	ld l,a			; $79de
	ld (hl),$08		; $79df
	jr _label_0d_351		; $79e1
	pop bc			; $79e3
	ld h,d			; $79e4
	ldh a,(<hActiveObjectType)	; $79e5
	add $33			; $79e7
	ld l,a			; $79e9
	ld a,(bc)		; $79ea
	ld (hl),a		; $79eb
	ld a,l			; $79ec
	add $d6			; $79ed
	ld l,a			; $79ef
	ld (hl),$08		; $79f0
	add $fb			; $79f2
	ld l,a			; $79f4
	ld (hl),$09		; $79f5
	jr _label_0d_351		; $79f7
	pop bc			; $79f9
	ld h,d			; $79fa
	ldh a,(<hActiveObjectType)	; $79fb
	add $32			; $79fd
	ld l,a			; $79ff
	ld a,(bc)		; $7a00
	ld (hl),a		; $7a01
	ld a,l			; $7a02
	add $d7			; $7a03
	ld l,a			; $7a05
	ld (hl),$10		; $7a06
	add $fb			; $7a08
	ld l,a			; $7a0a
	ld (hl),$0a		; $7a0b
	jr _label_0d_351		; $7a0d
	pop bc			; $7a0f
	ld h,d			; $7a10
	ldh a,(<hActiveObjectType)	; $7a11
	add $33			; $7a13
	ld l,a			; $7a15
	ld a,(bc)		; $7a16
	ld (hl),a		; $7a17
	ld a,l			; $7a18
	add $d6			; $7a19
	ld l,a			; $7a1b
	ld (hl),$18		; $7a1c
	add $fb			; $7a1e
	ld l,a			; $7a20
	ld (hl),$0b		; $7a21
	jr _label_0d_351		; $7a23
	pop bc			; $7a25
	ld h,d			; $7a26
	ldh a,(<hActiveObjectType)	; $7a27
	add $06			; $7a29
	ld l,a			; $7a2b
	ld a,(bc)		; $7a2c
	ld (hl),a		; $7a2d
	ld a,l			; $7a2e
	add $fe			; $7a2f
	ld l,a			; $7a31
	ld (hl),$0c		; $7a32
_label_0d_351:
	inc bc			; $7a34
	add $2c			; $7a35
	ld l,a			; $7a37
	ld (hl),c		; $7a38
	inc l			; $7a39
	ld (hl),b		; $7a3a
	ret			; $7a3b
	ld h,(hl)		; $7a3c
	ld a,d			; $7a3d
	ld l,a			; $7a3e
	ld a,d			; $7a3f
	ld a,b			; $7a40
	ld a,d			; $7a41
	add c			; $7a42
	ld a,d			; $7a43
	adc d			; $7a44
	ld a,d			; $7a45
	sub e			; $7a46
	ld a,d			; $7a47
	sbc h			; $7a48
	ld a,d			; $7a49
	and l			; $7a4a
	ld a,d			; $7a4b
	xor (hl)		; $7a4c
	ld a,d			; $7a4d
	or a			; $7a4e
	ld a,d			; $7a4f
	ret nz			; $7a50
	ld a,d			; $7a51
	ret			; $7a52
	ld a,d			; $7a53
	sub $7a			; $7a54
.DB $e3				; $7a56
	ld a,d			; $7a57
.DB $ec				; $7a58
	ld a,d			; $7a59
	push af			; $7a5a
	ld a,d			; $7a5b
	ld (bc),a		; $7a5c
	ld a,e			; $7a5d
	dec bc			; $7a5e
	ld a,e			; $7a5f
	inc d			; $7a60
	ld a,e			; $7a61
	dec e			; $7a62
	ld a,e			; $7a63
	ld h,$7b		; $7a64
	inc d			; $7a66
	nop			; $7a67
	ld (bc),a		; $7a68
	ld l,d			; $7a69
	inc b			; $7a6a
	ld c,d			; $7a6b
	nop			; $7a6c
	ld l,b			; $7a6d
	ld a,d			; $7a6e
	inc d			; $7a6f
	nop			; $7a70
	inc b			; $7a71
	sub (hl)		; $7a72
	ld (bc),a		; $7a73
	or (hl)			; $7a74
	nop			; $7a75
	ld (hl),c		; $7a76
	ld a,d			; $7a77
	inc d			; $7a78
	nop			; $7a79
	ld bc,$0328		; $7a7a
	ld e,b			; $7a7d
	nop			; $7a7e
	ld a,d			; $7a7f
	ld a,d			; $7a80
	inc d			; $7a81
	nop			; $7a82
	inc b			; $7a83
	ld d,b			; $7a84
	ld (bc),a		; $7a85
	and b			; $7a86
	nop			; $7a87
	add e			; $7a88
	ld a,d			; $7a89
	inc d			; $7a8a
	nop			; $7a8b
	inc b			; $7a8c
	ld d,b			; $7a8d
	ld (bc),a		; $7a8e
	add b			; $7a8f
	nop			; $7a90
	adc h			; $7a91
	ld a,d			; $7a92
	inc d			; $7a93
	nop			; $7a94
	ld (bc),a		; $7a95
	ld (hl),b		; $7a96
	inc b			; $7a97
	ld b,b			; $7a98
	nop			; $7a99
	sub l			; $7a9a
	ld a,d			; $7a9b
	inc d			; $7a9c
	nop			; $7a9d
	inc b			; $7a9e
	ld b,b			; $7a9f
	ld (bc),a		; $7aa0
	or b			; $7aa1
	nop			; $7aa2
	sbc (hl)		; $7aa3
	ld a,d			; $7aa4
	inc d			; $7aa5
	nop			; $7aa6
	ld bc,$0368		; $7aa7
	sbc b			; $7aaa
	nop			; $7aab
	and a			; $7aac
	ld a,d			; $7aad
	inc d			; $7aae
	ld (bc),a		; $7aaf
	ld bc,$0338		; $7ab0
	adc b			; $7ab3
	nop			; $7ab4
	or b			; $7ab5
	ld a,d			; $7ab6
	inc d			; $7ab7
	ld (bc),a		; $7ab8
	inc bc			; $7ab9
	adc b			; $7aba
	ld bc,$0038		; $7abb
	cp c			; $7abe
	ld a,d			; $7abf
	inc d			; $7ac0
	inc bc			; $7ac1
	inc b			; $7ac2
	ld b,b			; $7ac3
	ld (bc),a		; $7ac4
	sub b			; $7ac5
	nop			; $7ac6
	jp nz,$147a		; $7ac7
	nop			; $7aca
	ld (bc),a		; $7acb
	adc b			; $7acc
	inc bc			; $7acd
	ld l,b			; $7ace
	inc b			; $7acf
	ld a,b			; $7ad0
	ld bc,$0028		; $7ad1
	bit 7,d			; $7ad4
	inc d			; $7ad6
	nop			; $7ad7
	inc b			; $7ad8
	xor b			; $7ad9
	inc bc			; $7ada
	adc b			; $7adb
	ld (bc),a		; $7adc
	ret nz			; $7add
	ld bc,$0038		; $7ade
	ret c			; $7ae1
	ld a,d			; $7ae2
	inc d			; $7ae3
	nop			; $7ae4
	ld (bc),a		; $7ae5
	ld h,b			; $7ae6
	inc b			; $7ae7
	jr nc,_label_0d_352	; $7ae8
_label_0d_352:
	push hl			; $7aea
	ld a,d			; $7aeb
	inc d			; $7aec
	nop			; $7aed
	ld (bc),a		; $7aee
	and b			; $7aef
	inc b			; $7af0
	ld (hl),b		; $7af1
	nop			; $7af2
	xor $7a			; $7af3
	inc d			; $7af5
	ld bc,$8803		; $7af6
	dec b			; $7af9
	ld e,$01		; $7afa
	ld l,b			; $7afc
	dec b			; $7afd
	ld e,$00		; $7afe
	rst $30			; $7b00
	ld a,d			; $7b01
	inc d			; $7b02
	ld (bc),a		; $7b03
	inc bc			; $7b04
	adc b			; $7b05
	ld bc,addAToDe		; $7b06
	inc b			; $7b09
	ld a,e			; $7b0a
	inc d			; $7b0b
	ld (bc),a		; $7b0c
	inc bc			; $7b0d
	adc b			; $7b0e
	ld bc,$0048		; $7b0f
	dec c			; $7b12
	ld a,e			; $7b13
	inc d			; $7b14
	ld (bc),a		; $7b15
	ld bc,$0348		; $7b16
	adc b			; $7b19
	nop			; $7b1a
	ld d,$7b		; $7b1b
	inc d			; $7b1d
	nop			; $7b1e
	ld bc,$0328		; $7b1f
	adc b			; $7b22
	nop			; $7b23
	rra			; $7b24
	ld a,e			; $7b25
	inc d			; $7b26
	nop			; $7b27
	inc bc			; $7b28
	adc b			; $7b29
	ld bc,$0028		; $7b2a
	.db $28 $7b 
	add hl,sp		; $7b2f
	ld a,e			; $7b30
	ld b,(hl)		; $7b31
	ld a,e			; $7b32
	ld c,a			; $7b33
	ld a,e			; $7b34
	ld e,b			; $7b35
	ld a,e			; $7b36
	ld h,l			; $7b37
	ld a,e			; $7b38
	inc d			; $7b39
	ld bc,$5002		; $7b3a
	inc bc			; $7b3d
	adc b			; $7b3e
	inc b			; $7b3f
	jr c,$01		; $7b40
	jr c,_label_0d_353	; $7b42
_label_0d_353:
	dec sp			; $7b44
	ld a,e			; $7b45
	inc d			; $7b46
	nop			; $7b47
	inc bc			; $7b48
	adc b			; $7b49
	ld bc,$0028		; $7b4a
	ld c,b			; $7b4d
	ld a,e			; $7b4e
	inc d			; $7b4f
	ld bc,$2801		; $7b50
	inc bc			; $7b53
	adc b			; $7b54
	nop			; $7b55
	ld d,c			; $7b56
	ld a,e			; $7b57
	inc d			; $7b58
	ld bc,$2801		; $7b59
	ld (bc),a		; $7b5c
	add b			; $7b5d
	inc bc			; $7b5e
	adc b			; $7b5f
	inc b			; $7b60
	ld b,b			; $7b61
	nop			; $7b62
	ld e,d			; $7b63
	ld a,e			; $7b64
	inc d			; $7b65
	nop			; $7b66
	ld bc,$0438		; $7b67
	ld b,b			; $7b6a
	inc bc			; $7b6b
	ld a,b			; $7b6c
	ld (bc),a		; $7b6d
	and b			; $7b6e
	nop			; $7b6f
	ld h,a			; $7b70
	ld a,e			; $7b71

.ends

.BANK $0e SLOT 1
.ORG 0

.section Enemy_Code_Bank0e

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "code/seasons/enemyCode/bank0e.s"

.ends

.BANK $0f SLOT 1
.ORG 0

.section Enemy_Code_Bank0f

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "code/seasons/enemyCode/bank0f.s"
	.include "code/seasons/cutscenes/seasonsFunc_0f_6f75.s"

	.REPT $87
	.db $0f ; emptyfill
	.ENDR

	.include "code/seasons/interactionCode/bank0f.s"

.ends

.BANK $10 SLOT 1
.ORG 0

	.define PART_BANK $10
	.export PART_BANK

 m_section_force "Part_Code" NAMESPACE "partCode"

	.include "code/partCommon.s"
	.include "code/seasons/partCode.s"

.ends


.BANK $11 SLOT 1
.ORG 0

	.include "code/objectLoading.s"

 m_section_free "Objects_2" namespace "objectData"
	.include "objects/seasons/pointers.s"
	.include "objects/seasons/mainData.s"
	.include "objects/seasons/extraData3.s"
.ends


.BANK $12 SLOT 1
.ORG 0

	.define BASE_OAM_DATA_BANK $12
	.export BASE_OAM_DATA_BANK

	.include "data/seasons/specialObjectOamData.s"
	.include "data/itemOamData.s"
	.include "data/seasons/enemyOamData.s"


.BANK $13 SLOT 1
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

	.include "data/seasons/interactionOamData.s"
	.include "data/seasons/partOamData.s"


.BANK $14 SLOT 1
.ORG 0

data_4556:
	.dw $4020
	.dw $4061
	.dw $40ce
	.dw $413f
	.dw $4472
	.dw $43b8
	.dw $4419
	.dw $459d
	.dw $463e
	.dw _data_4556_data9
	.dw $41bc
	.dw $44db
	.dw $4568
	.dw $4239
	.dw $429a
	.dw $4337
	stop			; $4020
	xor e			; $4021
	ld ($ff00+$40),a	; $4022
	ld bc,$eaab		; $4024
	ld b,d			; $4027
	ld bc,$f4ab		; $4028
	ld b,h			; $402b
	ld bc,$feab		; $402c
	ld b,(hl)		; $402f
	ld bc,$1cab		; $4030
	ld c,b			; $4033
	ld bc,$08ab		; $4034
	ld c,h			; $4037
	ld bc,$12ab		; $4038
	ld c,(hl)		; $403b
	ld bc,$27ab		; $403c
	ld d,(hl)		; $403f
	ld bc,$e9d0		; $4040
	ld a,(bc)		; $4043
	nop			; $4044
	ret nc			; $4045
	pop af			; $4046
	ld d,$00		; $4047
	ret nc			; $4049
	ld sp,hl		; $404a
	nop			; $404b
	nop			; $404c
	ret nc			; $404d
	ld bc,$000c		; $404e
	ret nc			; $4051
	add hl,bc		; $4052
	inc h			; $4053
	nop			; $4054
	ret nc			; $4055
	ld de,$000e		; $4056
	ret nc			; $4059
	rla			; $405a
	stop			; $405b
	nop			; $405c
	ret nc			; $405d
	dec e			; $405e
	ld e,$00		; $405f
	dec de			; $4061
	xor b			; $4062
	jp hl			; $4063
	ld c,d			; $4064
	ld bc,$f2a8		; $4065
	ld c,h			; $4068
	ld bc,$fca8		; $4069
	ld c,(hl)		; $406c
	ld bc,$04a8		; $406d
	ld c,h			; $4070
	ld bc,$16a8		; $4071
	ld d,b			; $4074
	ld bc,$20a8		; $4075
	ld d,d			; $4078
	ld bc,$29a8		; $4079
	ld c,(hl)		; $407c
	ld bc,$eeb8		; $407d
	ld l,d			; $4080
	ld bc,$f8b8		; $4081
	ld l,h			; $4084
	ld bc,$01b8		; $4085
	ld l,(hl)		; $4088
	ld bc,loadFile		; $4089
	ld (hl),b		; $408c
	ld bc,$13b8		; $408d
	ld (hl),d		; $4090
	ld bc,$1cb8		; $4091
	ld (hl),h		; $4094
	ld bc,$e0a8		; $4095
	ld b,d			; $4098
	ld bc,$0ea8		; $4099
	ld b,d			; $409c
	ld bc,$dcd0		; $409d
	jr nc,_label_14_000	; $40a0
_label_14_000:
	ret nc			; $40a2
.DB $e4				; $40a3
	jr z,_label_14_001	; $40a4
_label_14_001:
	ret nc			; $40a6
.DB $ec				; $40a7
	inc h			; $40a8
	nop			; $40a9
	ret nc			; $40aa
.DB $f4				; $40ab
	jr z,_label_14_002	; $40ac
_label_14_002:
	ret nc			; $40ae
.DB $fc				; $40af
	inc d			; $40b0
	nop			; $40b1
	ret nc			; $40b2
	inc b			; $40b3
	ld ($e000),sp		; $40b4
	inc b			; $40b7
	ld a,(de)		; $40b8
	nop			; $40b9
	ld ($ff00+$0c),a	; $40ba
	nop			; $40bc
	nop			; $40bd
	ld ($ff00+$14),a	; $40be
	inc d			; $40c0
	nop			; $40c1
	ld ($ff00+$1c),a	; $40c2
	nop			; $40c4
	nop			; $40c5
	ld ($ff00+$23),a	; $40c6
	ld a,(de)		; $40c8
	nop			; $40c9
	ld ($ff00+$2b),a	; $40ca
	inc e			; $40cc
	nop			; $40cd
	inc e			; $40ce
	xor b			; $40cf
	ld ($ff00+$52),a	; $40d0
	ld bc,$e8a8		; $40d2
	ld d,h			; $40d5
	ld bc,$faa8		; $40d6
	ld d,b			; $40d9
	ld bc,$04a8		; $40da
	ld d,(hl)		; $40dd
	ld bc,$0da8		; $40de
	ld c,(hl)		; $40e1
	ld bc,$1ea8		; $40e2
	ld c,h			; $40e5
	ld bc,$28a8		; $40e6
	ld e,b			; $40e9
	ld bc,$eeb8		; $40ea
	ld l,d			; $40ed
	ld bc,$f8b8		; $40ee
	ld l,h			; $40f1
	ld bc,$01b8		; $40f2
	ld l,(hl)		; $40f5
	ld bc,loadFile		; $40f6
	ld (hl),b		; $40f9
	ld bc,$13b8		; $40fa
	ld (hl),d		; $40fd
	ld bc,$1cb8		; $40fe
	ld (hl),h		; $4101
	ld bc,$f1a8		; $4102
	ld c,b			; $4105
	ld bc,$15a8		; $4106
	ld c,b			; $4109
	ld bc,$f4d0		; $410a
	nop			; $410d
	nop			; $410e
	ret nc			; $410f
.DB $fc				; $4110
	jr z,_label_14_003	; $4111
_label_14_003:
	ret nc			; $4113
	inc b			; $4114
	inc c			; $4115
	nop			; $4116
	ret nc			; $4117
	inc c			; $4118
	ld ($d000),sp		; $4119
	inc de			; $411c
	ld a,(de)		; $411d
	nop			; $411e
	add sp,-$17		; $411f
	jr nc,_label_14_004	; $4121
_label_14_004:
	add sp,-$0f		; $4123
	inc (hl)		; $4125
	nop			; $4126
	add sp,-$07		; $4127
	ld h,$00		; $4129
	add sp,$00		; $412b
	nop			; $412d
	nop			; $412e
	add sp,$07		; $412f
	ld a,(de)		; $4131
	nop			; $4132
	add sp,$0f		; $4133
	nop			; $4135
	nop			; $4136
	add sp,$17		; $4137
	inc d			; $4139
	nop			; $413a
	add sp,$1f		; $413b
	nop			; $413d
	nop			; $413e
	rra			; $413f
	call nc,$0ef9		; $4140
	nop			; $4143
	call nc,$1c01		; $4144
	nop			; $4147
	call nc,$2609		; $4148
	nop			; $414b
	call nc,$2611		; $414c
	nop			; $414f
	call nc,$0018		; $4150
	nop			; $4153
	ld b,$f4		; $4154
	ld h,$00		; $4156
	ld b,$fc		; $4158
	ld ($0600),sp		; $415a
	inc b			; $415d
	ldd (hl),a		; $415e
	nop			; $415f
	ld b,$0c		; $4160
	jr z,_label_14_005	; $4162
_label_14_005:
	ld b,$14		; $4164
	inc d			; $4166
	nop			; $4167
	ld b,$1c		; $4168
	nop			; $416a
	nop			; $416b
	call nc,$70f0		; $416c
	ld ($ec06),sp		; $416f
	ld (hl),b		; $4172
	ld ($ecee),sp		; $4173
	ld (hl),d		; $4176
	ld ($f6ee),sp		; $4177
	jr nc,_label_14_006	; $417a
_label_14_006:
	xor $fe			; $417c
	nop			; $417e
	nop			; $417f
	xor $06			; $4180
	jr _label_14_007		; $4182
_label_14_007:
	xor $0e			; $4184
	nop			; $4186
	nop			; $4187
	xor $16			; $4188
	ld b,$00		; $418a
	xor $1e			; $418c
	nop			; $418e
	nop			; $418f
	xor b			; $4190
	inc bc			; $4191
	ld e,d			; $4192
	ld bc,$0ba8		; $4193
	ld d,d			; $4196
	ld bc,$14a8		; $4197
	ld c,(hl)		; $419a
	ld bc,$eeb0		; $419b
	ld e,h			; $419e
	ld bc,$f3a8		; $419f
	ld b,b			; $41a2
	ld bc,$fbb0		; $41a3
	ld h,b			; $41a6
	ld bc,$18b8		; $41a7
	ld l,(hl)		; $41aa
	ld bc,$ffb8		; $41ab
	ld l,(hl)		; $41ae
	ld bc,$f7b8		; $41af
	ld (hl),b		; $41b2
	ld bc,$07b8		; $41b3
	ld h,h			; $41b6
	ld bc,$0fb8		; $41b7
	ld l,b			; $41ba
	ld bc,$b01f		; $41bb
	add sp,$4c		; $41be
	add hl,bc		; $41c0
	or b			; $41c1
	ld a,($ff00+$4e)	; $41c2
	add hl,bc		; $41c4
	or b			; $41c5
	ld hl,sp+$50		; $41c6
	add hl,bc		; $41c8
	or b			; $41c9
	nop			; $41ca
	ld d,d			; $41cb
	add hl,bc		; $41cc
	or b			; $41cd
	ld ($0954),sp		; $41ce
	or b			; $41d1
	stop			; $41d2
	ld d,(hl)		; $41d3
	add hl,bc		; $41d4
	or b			; $41d5
	jr $58			; $41d6
	add hl,bc		; $41d8
	or b			; $41d9
	jr nz,$5a		; $41da
	add hl,bc		; $41dc
	ret nc			; $41dd
	pop hl			; $41de
	jr _label_14_008		; $41df
_label_14_008:
	ret nc			; $41e1
	jp hl			; $41e2
	stop			; $41e3
	nop			; $41e4
	ret nc			; $41e5
	ld a,($ff00+$1a)	; $41e6
	nop			; $41e8
	ret nc			; $41e9
	ld sp,hl		; $41ea
	inc e			; $41eb
	nop			; $41ec
	ret nc			; $41ed
	ld bc,$0022		; $41ee
	ret nc			; $41f1
	add hl,bc		; $41f2
	jr z,_label_14_009	; $41f3
_label_14_009:
	ld ($ff00+$09),a	; $41f5
	nop			; $41f7
	nop			; $41f8
	ld ($ff00+$11),a	; $41f9
	ldi (hl),a		; $41fb
	nop			; $41fc
	ld ($ff00+$19),a	; $41fd
	nop			; $41ff
	nop			; $4200
	ld ($ff00+$21),a	; $4201
	inc d			; $4203
	nop			; $4204
	ld ($ff00+$29),a	; $4205
	nop			; $4207
	nop			; $4208
	ld ($ff00+$31),a	; $4209
	inc l			; $420b
	nop			; $420c
.DB $f4				; $420d
.DB $ed				; $420e
	jr _label_14_010		; $420f
_label_14_010:
.DB $f4				; $4211
	push af			; $4212
	stop			; $4213
	nop			; $4214
.DB $f4				; $4215
.DB $fd				; $4216
	inc d			; $4217
	nop			; $4218
.DB $f4				; $4219
	dec b			; $421a
	ld ($0400),sp		; $421b
	dec b			; $421e
	ld a,(bc)		; $421f
	nop			; $4220
	inc b			; $4221
	dec c			; $4222
	jr z,_label_14_011	; $4223
_label_14_011:
	inc b			; $4225
	dec d			; $4226
	inc d			; $4227
	nop			; $4228
	inc b			; $4229
	dec e			; $422a
	jr z,_label_14_012	; $422b
_label_14_012:
	inc b			; $422d
	dec h			; $422e
	ld b,$00		; $422f
	inc b			; $4231
	dec l			; $4232
	nop			; $4233
	nop			; $4234
	ld ($ff00+$39),a	; $4235
	nop			; $4237
	nop			; $4238
	jr -$54			; $4239
	ld ($ff00+$5a),a	; $423b
	ld bc,$eaac		; $423d
	ld c,(hl)		; $4240
	ld bc,$f5ac		; $4241
	ld d,(hl)		; $4244
	ld bc,$ffac		; $4245
	ld d,h			; $4248
	ld bc,$1eac		; $4249
	ld d,d			; $424c
	ld bc,$29ac		; $424d
	ld c,(hl)		; $4250
	ld bc,$0ab4		; $4251
	ld h,b			; $4254
	ld bc,$14ac		; $4255
	ld b,d			; $4258
	ld bc,$d0d0		; $4259
	ld a,(de)		; $425c
	nop			; $425d
	ret nc			; $425e
	ret c			; $425f
	inc e			; $4260
	nop			; $4261
	ret nc			; $4262
	ld ($ff00+$22),a	; $4263
	nop			; $4265
	ret nc			; $4266
	and $10			; $4267
	nop			; $4269
	ret nc			; $426a
.DB $ec				; $426b
	ld h,$00		; $426c
	ret nc			; $426e
	di			; $426f
	nop			; $4270
	nop			; $4271
	ret nc			; $4272
	ei			; $4273
	inc d			; $4274
	nop			; $4275
	ld ($ff00+$03),a	; $4276
	ld a,(bc)		; $4278
	nop			; $4279
	ld ($ff00+$0b),a	; $427a
	jr z,_label_14_013	; $427c
_label_14_013:
	ld ($ff00+$12),a	; $427e
	ld a,(de)		; $4280
	nop			; $4281
	ld ($ff00+$1b),a	; $4282
	nop			; $4284
	nop			; $4285
	ld ($ff00+$23),a	; $4286
	jr _label_14_014		; $4288
_label_14_014:
	ld ($ff00+$29),a	; $428a
	stop			; $428c
	nop			; $428d
	ld ($ff00+$2f),a	; $428e
	ldd (hl),a		; $4290
	nop			; $4291
	ld ($ff00+$37),a	; $4292
	jr z,_label_14_015	; $4294
_label_14_015:
	ret nc			; $4296
	inc bc			; $4297
	nop			; $4298
	nop			; $4299
	daa			; $429a
	ret nc			; $429b
	call nc,$0024		; $429c
	ret nc			; $429f
	call c,$000e		; $42a0
	ret nc			; $42a3
	ld ($ff00+c),a		; $42a4
	stop			; $42a5
	nop			; $42a6
	ret nc			; $42a7
	add sp,$0c		; $42a8
	nop			; $42aa
	ret nc			; $42ab
	ld a,($ff00+$08)	; $42ac
	nop			; $42ae
	ret nc			; $42af
	ld hl,sp+$22		; $42b0
	nop			; $42b2
	ret nc			; $42b3
	nop			; $42b4
	jr z,_label_14_016	; $42b5
_label_14_016:
	ld ($ff00+$00),a	; $42b7
	jr _label_14_017		; $42b9
_label_14_017:
	ld ($ff00+$0c),a	; $42bb
	jr nc,_label_14_018	; $42bd
_label_14_018:
	ld ($ff00+$06),a	; $42bf
	stop			; $42c1
	nop			; $42c2
	ld ($ff00+$13),a	; $42c3
	nop			; $42c5
	nop			; $42c6
	ld ($ff00+$1b),a	; $42c7
	jr _label_14_019		; $42c9
_label_14_019:
	ld ($ff00+$23),a	; $42cb
	inc e			; $42cd
	nop			; $42ce
	ld ($ff00+$2b),a	; $42cf
	ld h,$00		; $42d1
	ld ($ff00+$33),a	; $42d3
	inc e			; $42d5
	nop			; $42d6
	ld hl,sp-$29		; $42d7
	jr nc,_label_14_020	; $42d9
_label_14_020:
	ld hl,sp-$21		; $42db
	inc e			; $42dd
	nop			; $42de
	ld hl,sp-$19		; $42df
_label_14_021:
	inc h			; $42e1
	nop			; $42e2
	ld hl,sp-$11		; $42e3
	ld c,$00		; $42e5
	ld hl,sp-$0b		; $42e7
	stop			; $42e9
	nop			; $42ea
	ld hl,sp-$05		; $42eb
	inc d			; $42ed
	nop			; $42ee
	ld hl,sp+$01		; $42ef
	stop			; $42f1
	nop			; $42f2
	ld ($1c01),sp		; $42f3
	nop			; $42f6
	ld ($1409),sp		; $42f7
	nop			; $42fa
	ld ($0011),sp		; $42fb
	nop			; $42fe
	ld ($1819),sp		; $42ff
	nop			; $4302
	ld ($1c21),sp		; $4303
	nop			; $4306
	ld ($2629),sp		; $4307
	nop			; $430a
	ld ($1c31),sp		; $430b
	nop			; $430e
	or b			; $430f
	ld ($ff00+$12),a	; $4310
	add hl,bc		; $4312
	or b			; $4313
	add sp,$14		; $4314
	add hl,bc		; $4316
	or b			; $4317
	ld a,($ff00+$16)	; $4318
	add hl,bc		; $431a
	or b			; $431b
	ld hl,sp+$18		; $431c
	add hl,bc		; $431e
	or b			; $431f
	nop			; $4320
	ld a,(de)		; $4321
	add hl,bc		; $4322
	or b			; $4323
	ld ($091c),sp		; $4324
	or b			; $4327
	stop			; $4328
	ld e,$09		; $4329
	or b			; $432b
	jr _label_14_022		; $432c
	add hl,bc		; $432e
	or b			; $432f
	jr nz,$22		; $4330
	add hl,bc		; $4332
	or b			; $4333
	jr z,_label_14_023	; $4334
	add hl,bc		; $4336
	jr nz,_label_14_021	; $4337
	rst_addDoubleIndex			; $4339
	ld d,d			; $433a
	ld bc,$e8b0		; $433b
	ld a,(hl)		; $433e
	ld bc,$f1a8		; $433f
	ld d,d			; $4342
	ld bc,$0ca8		; $4343
	ld d,b			; $4346
	ld bc,$1fa8		; $4347
	ld e,h			; $434a
	ld bc,$29a8		; $434b
_label_14_022:
	ld d,d			; $434e
	ld bc,$feb8		; $434f
	ld l,d			; $4352
	ld bc,$1bb8		; $4353
	ld l,h			; $4356
	ld bc,$faa8		; $4357
_label_14_023:
	ld b,d			; $435a
	ld bc,$04b0		; $435b
	ld h,b			; $435e
	ld bc,$16a8		; $435f
	ld c,b			; $4362
	ld bc,$08b8		; $4363
	ld h,b			; $4366
	ld bc,$d5d0		; $4367
	ld c,$00		; $436a
	ret nc			; $436c
.DB $db				; $436d
	stop			; $436e
	nop			; $436f
	ret nc			; $4370
	pop hl			; $4371
	ldi (hl),a		; $4372
	nop			; $4373
	ret nc			; $4374
	jp hl			; $4375
	inc e			; $4376
	nop			; $4377
	ret nc			; $4378
	pop af			; $4379
	inc h			; $437a
	nop			; $437b
	ret nc			; $437c
	ld sp,hl		; $437d
	ld c,$00		; $437e
	ret nc			; $4380
	rst $38			; $4381
	stop			; $4382
	nop			; $4383
	ld ($ff00+$ff),a	; $4384
	jr nc,_label_14_024	; $4386
_label_14_024:
	ld ($ff00+$06),a	; $4388
	nop			; $438a
	nop			; $438b
	ld ($ff00+$0e),a	; $438c
	jr _label_14_025		; $438e
_label_14_025:
	ld ($ff00+$16),a	; $4390
	nop			; $4392
	nop			; $4393
	ld ($ff00+$1e),a	; $4394
	jr z,_label_14_026	; $4396
_label_14_026:
	ld ($ff00+$26),a	; $4398
	inc b			; $439a
	nop			; $439b
	ld ($ff00+$2e),a	; $439c
	ld c,$00		; $439e
	ld ($ff00+$34),a	; $43a0
	stop			; $43a2
	nop			; $43a3
	cp b			; $43a4
.DB $e3				; $43a5
	ld h,d			; $43a6
	ld bc,$ecb8		; $43a7
	ld l,b			; $43aa
	ld bc,$f6b8		; $43ab
	ld h,h			; $43ae
	ld bc,$11b8		; $43af
	ld h,(hl)		; $43b2
	ld bc,$24b8		; $43b3
	ld l,b			; $43b6
	ld bc,$d818		; $43b7
.DB $ec				; $43ba
	inc d			; $43bb
	nop			; $43bc
	ret c			; $43bd
.DB $f4				; $43be
	inc (hl)		; $43bf
	nop			; $43c0
	ret c			; $43c1
.DB $fc				; $43c2
	inc d			; $43c3
	nop			; $43c4
	ret c			; $43c5
	inc b			; $43c6
	inc e			; $43c7
	nop			; $43c8
	ret c			; $43c9
	inc c			; $43ca
	ld a,(de)		; $43cb
	nop			; $43cc
	ret c			; $43cd
	inc d			; $43ce
	ld b,$00		; $43cf
	ret c			; $43d1
	inc e			; $43d2
	inc e			; $43d3
	nop			; $43d4
	xor b			; $43d5
	ld ($ff00+$38),a	; $43d6
	add hl,bc		; $43d8
	xor b			; $43d9
	add sp,$3a		; $43da
	add hl,bc		; $43dc
	xor b			; $43dd
	ld a,($ff00+$3c)	; $43de
	add hl,bc		; $43e0
	xor b			; $43e1
	ld hl,sp+$3e		; $43e2
	add hl,bc		; $43e4
	or b			; $43e5
	nop			; $43e6
	ld b,b			; $43e7
	add hl,bc		; $43e8
	or b			; $43e9
	ld ($0942),sp		; $43ea
	xor b			; $43ed
	stop			; $43ee
	ld b,h			; $43ef
	add hl,bc		; $43f0
	xor b			; $43f1
	jr $46			; $43f2
	add hl,bc		; $43f4
	xor b			; $43f5
	jr nz,_label_14_027	; $43f6
	add hl,bc		; $43f8
	xor b			; $43f9
	jr z,$4a		; $43fa
	add hl,bc		; $43fc
	ret nz			; $43fd
.DB $ec				; $43fe
	ld a,d			; $43ff
	ld bc,$f4c0		; $4400
	ld l,d			; $4403
	ld bc,$fcb8		; $4404
	ld e,h			; $4407
	ld bc,$04c0		; $4408
	ld (hl),b		; $440b
	ld bc,$0cc0		; $440c
	ld l,(hl)		; $440f
	ld bc,$14c0		; $4410
	ld l,h			; $4413
	ld bc,$1cc0		; $4414
	ld l,b			; $4417
	ld bc,$a816		; $4418
.DB $ec				; $441b
	ld e,d			; $441c
	ld bc,$f4a8		; $441d
	ld e,b			; $4420
	ld bc,$fca8		; $4421
	ld c,h			; $4424
	ld bc,$04a8		; $4425
	ld b,(hl)		; $4428
	ld bc,$0ca8		; $4429
	ld b,(hl)		; $442c
	ld bc,$14a8		; $442d
	ld b,h			; $4430
	ld bc,$1ca8		; $4431
	ld c,(hl)		; $4434
	ld bc,$ecb8		; $4435
	ld l,(hl)		; $4438
	ld bc,$f4b8		; $4439
	ld h,b			; $443c
	ld bc,$fcb8		; $443d
_label_14_027:
	ld h,d			; $4440
	ld bc,$04b8		; $4441
	ld h,d			; $4444
	ld bc,$0cb8		; $4445
	ld h,h			; $4448
	ld bc,$14b8		; $4449
	ld l,b			; $444c
	ld bc,$1cb8		; $444d
	halt			; $4450
	ld bc,$e8d0		; $4451
	ld a,(de)		; $4454
	nop			; $4455
	ret nc			; $4456
	ld a,($ff00+$1c)	; $4457
	nop			; $4459
	ret nc			; $445a
	ld hl,sp+$24		; $445b
	nop			; $445d
	ret nc			; $445e
	nop			; $445f
	ld ($d000),sp		; $4460
	ld ($0026),sp		; $4463
	ret nc			; $4466
	stop			; $4467
	nop			; $4468
	nop			; $4469
	ret nc			; $446a
	jr _label_14_028		; $446b
	nop			; $446d
	ret nc			; $446e
	jr nz,$08		; $446f
	nop			; $4471
	ld a,(de)		; $4472
	ret nc			; $4473
	add sp,$18		; $4474
	nop			; $4476
	ret nc			; $4477
	ld a,($ff00+$34)	; $4478
	nop			; $447a
	ret nc			; $447b
	ld hl,sp+$1a		; $447c
	nop			; $447e
	ret nc			; $447f
	nop			; $4480
_label_14_028:
	nop			; $4481
	nop			; $4482
	ret nc			; $4483
	ld ($0022),sp		; $4484
	ret nc			; $4487
	stop			; $4488
	stop			; $4489
	nop			; $448a
	ret nc			; $448b
	jr _label_14_032		; $448c
	nop			; $448e
	ret nc			; $448f
	jr nz,_label_14_029	; $4490
_label_14_029:
	nop			; $4492
	add sp,-$18		; $4493
	inc d			; $4495
	nop			; $4496
	add sp,-$10		; $4497
	inc (hl)		; $4499
	nop			; $449a
	add sp,-$08		; $449b
	jr _label_14_030		; $449d
_label_14_030:
	add sp,$00		; $449f
	stop			; $44a1
	nop			; $44a2
	add sp,$08		; $44a3
	ldd (hl),a		; $44a5
	nop			; $44a6
	add sp,$10		; $44a7
	jr z,_label_14_031	; $44a9
_label_14_031:
	add sp,$18		; $44ab
	inc d			; $44ad
	nop			; $44ae
	add sp,$20		; $44af
	stop			; $44b1
	nop			; $44b2
	nop			; $44b3
_label_14_032:
.DB $ec				; $44b4
	jr nc,_label_14_033	; $44b5
_label_14_033:
	nop			; $44b7
	di			; $44b8
	nop			; $44b9
	nop			; $44ba
	nop			; $44bb
	ei			; $44bc
	jr _label_14_034		; $44bd
_label_14_034:
	nop			; $44bf
	inc bc			; $44c0
	nop			; $44c1
	nop			; $44c2
	nop			; $44c3
	dec bc			; $44c4
	inc h			; $44c5
	nop			; $44c6
	nop			; $44c7
	inc de			; $44c8
	ld c,$00		; $44c9
	nop			; $44cb
	add hl,de		; $44cc
	stop			; $44cd
	nop			; $44ce
	nop			; $44cf
	rra			; $44d0
	ld h,$00		; $44d1
	nop			; $44d3
	dec h			; $44d4
	nop			; $44d5
	nop			; $44d6
	nop			; $44d7
.DB $e4				; $44d8
	ld (hl),d		; $44d9
	ld ($cc23),sp		; $44da
	add sp,$1c		; $44dd
	nop			; $44df
	call z,$22f0		; $44e0
	nop			; $44e3
	call z,$10f8		; $44e4
	nop			; $44e7
	call z,$0c00		; $44e8
	nop			; $44eb
	call z,$1008		; $44ec
	nop			; $44ef
	call z,$1a10		; $44f0
	nop			; $44f3
	call z,$0018		; $44f4
	nop			; $44f7
	call z,$1620		; $44f8
	nop			; $44fb
.DB $f4				; $44fc
.DB $f4				; $44fd
	inc h			; $44fe
	nop			; $44ff
.DB $f4				; $4500
	inc b			; $4501
	ld e,$00		; $4502
.DB $f4				; $4504
.DB $fc				; $4505
	jr z,_label_14_035	; $4506
_label_14_035:
.DB $f4				; $4508
	inc c			; $4509
	ld ($f400),sp		; $450a
	inc d			; $450d
	ldi (hl),a		; $450e
	nop			; $450f
	inc b			; $4510
	ld ($ff00+c),a		; $4511
	jr _label_14_036		; $4512
_label_14_036:
	inc b			; $4514
	ld a,($ff00+c)		; $4515
	ldi (hl),a		; $4516
	nop			; $4517
	inc b			; $4518
	ld ($0000),a		; $4519
	inc b			; $451c
	ld a,($0010)		; $451d
	inc b			; $4520
	ld (bc),a		; $4521
	inc e			; $4522
	nop			; $4523
	inc b			; $4524
	ld c,$04		; $4525
	nop			; $4527
	inc b			; $4528
	ld d,$16		; $4529
	nop			; $452b
	inc b			; $452c
	ld e,$28		; $452d
	nop			; $452f
	inc b			; $4530
	ld h,$02		; $4531
	nop			; $4533
	call c,$5cde		; $4534
	ld ($e6dc),sp		; $4537
	ld e,(hl)		; $453a
	ld ($eedc),sp		; $453b
	ld h,b			; $453e
	ld ($f6dc),sp		; $453f
	ld h,d			; $4542
	ld ($fedc),sp		; $4543
	ld h,h			; $4546
	ld ($06dc),sp		; $4547
	ld h,(hl)		; $454a
	ld ($0edc),sp		; $454b
	ld l,b			; $454e
_label_14_037:
	ld ($16dc),sp		; $454f
	ld l,d			; $4552
	ld ($1edc),sp		; $4553
	ld l,h			; $4556
	ld ($26dc),sp		; $4557
	ld l,(hl)		; $455a
	ld ($fcb4),sp		; $455b
	nop			; $455e
	nop			; $455f
	or h			; $4560
	inc b			; $4561
	ld (bc),a		; $4562
	nop			; $4563
	or h			; $4564
	inc c			; $4565
	jr z,_label_14_038	; $4566
_label_14_038:
	dec c			; $4568
	cp b			; $4569
.DB $fc				; $456a
	ld a,(de)		; $456b
	nop			; $456c
	cp b			; $456d
	inc b			; $456e
	inc e			; $456f
	nop			; $4570
	cp b			; $4571
	inc c			; $4572
	nop			; $4573
	nop			; $4574
	ret z			; $4575
.DB $dd				; $4576
	ld b,$00		; $4577
	ret z			; $4579
	push hl			; $457a
	ld ($c800),sp		; $457b
.DB $ed				; $457e
	ld (bc),a		; $457f
	nop			; $4580
	ret z			; $4581
	push af			; $4582
	jr z,_label_14_039	; $4583
_label_14_039:
	ret z			; $4585
.DB $fd				; $4586
	inc c			; $4587
	nop			; $4588
	ret z			; $4589
	inc c			; $458a
_label_14_040:
	inc h			; $458b
	nop			; $458c
	ret z			; $458d
	inc d			; $458e
	ld h,$00		; $458f
_label_14_041:
	ret z			; $4591
	inc e			; $4592
	nop			; $4593
	nop			; $4594
	ret z			; $4595
	inc h			; $4596
_label_14_042:
	ld a,(bc)		; $4597
	nop			; $4598
	ret z			; $4599
	inc l			; $459a
	ld a,(bc)		; $459b
	nop			; $459c
	jr z,_label_14_037	; $459d
	ld ($ff00+$c0),a	; $459f
	add hl,bc		; $45a1
	or b			; $45a2
	add sp,-$3e		; $45a3
	add hl,bc		; $45a5
	or b			; $45a6
	ld a,($ff00+$c4)	; $45a7
	add hl,bc		; $45a9
	or b			; $45aa
	ld hl,sp-$3a		; $45ab
	add hl,bc		; $45ad
	or b			; $45ae
	nop			; $45af
	ret z			; $45b0
	add hl,bc		; $45b1
	or b			; $45b2
	ld ($09ca),sp		; $45b3
	or b			; $45b6
	stop			; $45b7
	call z,$b009		; $45b8
	jr _label_14_040		; $45bb
	add hl,bc		; $45bd
	or b			; $45be
	jr nz,_label_14_041	; $45bf
	add hl,bc		; $45c1
	or b			; $45c2
	jr z,_label_14_042	; $45c3
	add hl,bc		; $45c5
	adc $e0			; $45c6
	call nc,$ce09		; $45c8
	add sp,-$2a		; $45cb
	add hl,bc		; $45cd
	adc $f0			; $45ce
	ret c			; $45d0
	add hl,bc		; $45d1
	adc $f8			; $45d2
	jp c,$ce09		; $45d4
	nop			; $45d7
	call c,$ce09		; $45d8
	ld ($09de),sp		; $45db
	adc $10			; $45de
	ld ($ff00+$09),a	; $45e0
	adc $18			; $45e2
	ld ($ff00+c),a		; $45e4
	add hl,bc		; $45e5
	adc $20			; $45e6
.DB $e4				; $45e8
	add hl,bc		; $45e9
	sbc $e0			; $45ea
	and $09			; $45ec
	sbc $e8			; $45ee
	add sp,$09		; $45f0
	sbc $f0			; $45f2
	ld ($de09),a		; $45f4
	ld hl,sp-$14		; $45f7
	add hl,bc		; $45f9
	sbc $00			; $45fa
	xor $09			; $45fc
	sbc $08			; $45fe
	ld a,($ff00+$09)	; $4600
	sbc $10			; $4602
	ld a,($ff00+c)		; $4604
	add hl,bc		; $4605
	sbc $18			; $4606
.DB $f4				; $4608
	add hl,bc		; $4609
	sbc $20			; $460a
	or $09			; $460c
	sbc $28			; $460e
	ld hl,sp+$09		; $4610
	adc $28			; $4612
	ld hl,sp+$09		; $4614
	ld hl,sp-$1b		; $4616
	ld (bc),a		; $4618
	nop			; $4619
	ld hl,sp-$13		; $461a
	stop			; $461c
	nop			; $461d
	ld hl,sp-$0b		; $461e
	ld d,$00		; $4620
	ld hl,sp-$03		; $4622
	ld d,$00		; $4624
	ld ($26fd),sp		; $4626
	nop			; $4629
	ld ($2205),sp		; $462a
	nop			; $462d
	ld ($100d),sp		; $462e
	nop			; $4631
	ld ($1a15),sp		; $4632
	nop			; $4635
	ld ($081d),sp		; $4636
	nop			; $4639
	ld ($1a24),sp		; $463a
	nop			; $463d
	inc h			; $463e
	xor b			; $463f
	ld hl,sp+$50		; $4640
	ld bc,$00a8		; $4642
	ld d,d			; $4645
	ld bc,$08b0		; $4646
	ld a,(hl)		; $4649
	ld bc,$10a8		; $464a
	ld d,b			; $464d
	ld bc,$ecb8		; $464e
	ld l,h			; $4651
	ld bc,$f4b8		; $4652
	ld l,d			; $4655
	ld bc,$fcb8		; $4656
	ld (hl),b		; $4659
	ld bc,$04b8		; $465a
	halt			; $465d
	ld bc,$0cb8		; $465e
	ld h,h			; $4661
	ld bc,$1cb8		; $4662
	ld l,(hl)		; $4665
	ld bc,$14b8		; $4666
	ld l,b			; $4669
	ld bc,$d8d0		; $466a
	ld h,$00		; $466d
	ret nc			; $466f
	ld ($ff00+$08),a	; $4670
	nop			; $4672
	ret nc			; $4673
	add sp,$22		; $4674
	nop			; $4676
	ret nc			; $4677
	ld a,($ff00+$08)	; $4678
	nop			; $467a
	ret nc			; $467b
	ld hl,sp+$24		; $467c
	nop			; $467e
	ret nc			; $467f
	nop			; $4680
	nop			; $4681
	nop			; $4682
	ld ($ff00+$fa),a	; $4683
	ld d,$00		; $4685
	ld ($ff00+$01),a	; $4687
	stop			; $4689
	nop			; $468a
	ld ($ff00+$08),a	; $468b
	ld d,$00		; $468d
	ld ($ff00+$10),a	; $468f
	ld d,$00		; $4691
	ld ($ff00+$18),a	; $4693
	jr nc,_label_14_043	; $4695
_label_14_043:
	ld ($ff00+$20),a	; $4697
	inc c			; $4699
	nop			; $469a
	ld ($ff00+$28),a	; $469b
	ldi (hl),a		; $469d
	nop			; $469e
	ld ($ff00+$30),a	; $469f
	ld ($e000),sp		; $46a1
	scf			; $46a4
	ld a,(de)		; $46a5
	nop			; $46a6
	ld hl,sp-$1d		; $46a7
	inc h			; $46a9
	nop			; $46aa
	ld hl,sp-$0d		; $46ab
	nop			; $46ad
	nop			; $46ae
	ld hl,sp-$15		; $46af
	ld c,$00		; $46b1
	ld hl,sp-$05		; $46b3
	ldi (hl),a		; $46b5
	nop			; $46b6
	ld hl,sp+$03		; $46b7
	stop			; $46b9
	nop			; $46ba
	ld ($0203),sp		; $46bb
	nop			; $46be
	ld ($220b),sp		; $46bf
	nop			; $46c2
	ld ($1c13),sp		; $46c3
	nop			; $46c6
	ld ($2c1b),sp		; $46c7
	nop			; $46ca
	ld ($1a23),sp		; $46cb
	nop			; $46ce
_data_4556_data9:
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
	.db $d4 $dc $16 $00
	.db $d4 $e4 $08 $00
	.db $d4 $ec $24 $00
	.db $d4 $f4 $16 $00
	.db $d4 $fc $10 $00
	.db $d4 $04 $08 $00
	.db $d4 $14 $24 $00
	.db $d4 $1c $2c $00
	.db $d4 $24 $00 $00
	.db $d4 $2c $1a $00
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
	.db $b8 $e0 $fe $09
	.db $b8 $10 $fe $09
	.db $b8 $18 $6c $01

	push af
.DB $e3
	sub (hl)		; $4772
	sbc b			; $4773
	ld a,(bc)		; $4774
	nop			; $4775
.DB $e3				; $4776
	rst $8			; $4777
	rst_addAToHl			; $4778
	jr nc,-$1d	; $4779
	ld (hl),d		; $477b
	rst $20			; $477c
	ld b,(hl)		; $477d
	ld ($30d7),sp		; $477e
.DB $e3				; $4781
	ld (hl),d		; $4782
	rst $20			; $4783
	ld c,b			; $4784
	ld ($d0e0),sp		; $4785
	ld sp,$30d7		; $4788
.DB $e3				; $478b
	ld (hl),d		; $478c
	rst $20			; $478d
	ld l,b			; $478e
	ld ($d4e0),sp		; $478f
	ld sp,$30d7		; $4792
.DB $e3				; $4795
	ld (hl),d		; $4796
	rst $20			; $4797
	ld h,(hl)		; $4798
	ld ($30d7),sp		; $4799
.DB $e3				; $479c
	adc l			; $479d
	ld ($ff00+$6d),a	; $479e
	ld d,l			; $47a0
	nop			; $47a1
	push af			; $47a2
.DB $e3				; $47a3
	sub (hl)		; $47a4
	sbc b			; $47a5
	ld a,(bc)		; $47a6
	nop			; $47a7
.DB $e3				; $47a8
	rst $8			; $47a9
	rst_addAToHl			; $47aa
	jr nc,-$1d		; $47ab
	ld (hl),d		; $47ad
	rst $20			; $47ae
	dec (hl)		; $47af
	ld ($30d7),sp		; $47b0
.DB $e3				; $47b3
	ld (hl),d		; $47b4
	rst $20			; $47b5
	add hl,sp		; $47b6
	ld ($d0e0),sp		; $47b7
	ld sp,$30d7		; $47ba
.DB $e3				; $47bd
	ld (hl),d		; $47be
	rst $20			; $47bf
	ld a,c			; $47c0
	ld ($d4e0),sp		; $47c1
	ld sp,$30d7		; $47c4
.DB $e3				; $47c7
	ld (hl),d		; $47c8
	rst $20			; $47c9
	ld (hl),l		; $47ca
	ld ($30d7),sp		; $47cb
.DB $e3				; $47ce
	adc l			; $47cf
	ld ($ff00+$6d),a	; $47d0
	ld d,l			; $47d2
	nop			; $47d3
	adc $d5			; $47d4
	xor c			; $47d6
	call z,$e302		; $47d7
	sub (hl)		; $47da
_label_14_049:
	ld hl,sp-$7b		; $47db
	ld a,(hl)		; $47dd
	nop			; $47de
	ld c,b			; $47df
	ret z			; $47e0
	or $98			; $47e1
	ld a,(bc)		; $47e3
	ld bc,$d2f6		; $47e4
	or c			; $47e7
	ld b,b			; $47e8
	cp c			; $47e9
	nop			; $47ea
	adc $d5			; $47eb
	xor c			; $47ed
	call z,$e304		; $47ee
	sub (hl)		; $47f1
	ld hl,sp-$7b		; $47f2
	halt			; $47f4
	nop			; $47f5
	ld e,b			; $47f6
	ld a,b			; $47f7
	or $98			; $47f8
	ld a,(bc)		; $47fa
	inc bc			; $47fb
	or $d2			; $47fc
_label_14_050:
	or c			; $47fe
	ld b,b			; $47ff
	nop			; $4800
	add h			; $4801
	ld e,$13		; $4802
	jr nc,_label_14_051	; $4804
_label_14_051:
	add h			; $4806
	dec b			; $4807
	nop			; $4808
	jr _label_14_052		; $4809
.DB $f4				; $480b
	rst $20			; $480c
	inc d			; $480d
	and b			; $480e
	add h			; $480f
	dec b			; $4810
	nop			; $4811
	jr c,_label_14_053	; $4812
.DB $f4				; $4814
	rst $20			; $4815
	inc (hl)		; $4816
	and b			; $4817
	add h			; $4818
	dec b			; $4819
	nop			; $481a
	jr z,$48		; $481b
.DB $f4				; $481d
	rst $20			; $481e
	inc h			; $481f
	and b			; $4820
	add h			; $4821
	dec b			; $4822
	nop			; $4823
	ld c,b			; $4824
	ld c,b			; $4825
.DB $f4				; $4826
	rst $20			; $4827
	ld b,h			; $4828
	and b			; $4829
	add h			; $482a
	ld h,l			; $482b
	nop			; $482c
	nop			; $482d
	nop			; $482e
	nop			; $482f
	adc $8d			; $4830
	ld ($d020),sp		; $4832
	cp l			; $4835
.DB $e4				; $4836
	dec c			; $4837
	sbc b			; $4838
	nop			; $4839
	or $98			; $483a
	ld bc,$98f6		; $483c
	ld (bc),a		; $483f
	or $98			; $4840
	inc bc			; $4842
.DB $e4				; $4843
	rst $38			; $4844
	or c			; $4845
	ld b,b			; $4846
	cp (hl)			; $4847
	nop			; $4848
	adc $d5			; $4849
	inc b			; $484b
	ret nc			; $484c
	ld bc,$d5f3		; $484d
	ld sp,$01cc		; $4850
_label_14_052:
	adc b			; $4853
	ld a,b			; $4854
	ld a,b			; $4855
	rst_addAToHl			; $4856
	inc c			; $4857
	ld ($ff00+c),a		; $4858
	ld a,($ff00+c)		; $4859
	add sp,$6a		; $485a
_label_14_053:
.DB $e3				; $485c
	ld c,l			; $485d
	or c			; $485e
	ld b,b			; $485f
	nop			; $4860
	adc $8e			; $4861
	ld e,h			; $4863
	ld bc,$ebc0		; $4864
	ld d,(hl)		; $4867
	and b			; $4868
	ld ($ff00+$cb),a	; $4869
	ld e,b			; $486b
	adc h			; $486c
_label_14_054:
	ld l,b			; $486d
	and d			; $486e
	ld ($ff00+$fa),a	; $486f
	dec e			; $4871
	adc e			; $4872
	jr z,_label_14_050	; $4873
	ld ($dce0),sp		; $4875
	ld e,b			; $4878
	and e			; $4879
	adc a			; $487a
	ld bc,$0380		; $487b
	ret nc			; $487e
	add b			; $487f
	ld (bc),a		; $4880
	ld ($ff00+$eb),a	; $4881
	ld e,b			; $4883
	or $ac			; $4884
	adc a			; $4886
_label_14_055:
	inc bc			; $4887
	adc e			; $4888
	ld d,b			; $4889
	adc c			; $488a
	jr _label_14_054		; $488b
	ld l,b			; $488d
	ld e,c			; $488e
	pop af			; $488f
	ldh (<hSerialRead),a	; $4890
	ld e,b			; $4892
	sbc b			; $4893
	nop			; $4894
	ld (hl),$be		; $4895
.DB $e4				; $4897
	rst $38			; $4898
	nop			; $4899
	or l			; $489a
	rrca			; $489b
	ret c			; $489c
	ld b,l			; $489d
	adc (hl)		; $489e
	ld e,h			; $489f
	ld (bc),a		; $48a0
	ret nz			; $48a1
.DB $eb				; $48a2
	ld d,(hl)		; $48a3
	adc a			; $48a4
	ld (bc),a		; $48a5
	cp d			; $48a6
	ld hl,sp-$6b		; $48a7
	nop			; $48a9
.DB $fd				; $48aa
	sbc b			; $48ab
	jr z,_label_14_057	; $48ac
_label_14_056:
	xor b			; $48ae
_label_14_057:
	and c			; $48af
	adc a			; $48b0
	inc bc			; $48b1
	adc h			; $48b2
_label_14_058:
	ld b,b			; $48b3
	nop			; $48b4
	pop hl			; $48b5
	pop de			; $48b6
	ld h,e			; $48b7
	ld (bc),a		; $48b8
_label_14_059:
	or $98			; $48b9
	jr nz,_label_14_058	; $48bb
	sbc b			; $48bd
	ld hl,$98f6		; $48be
	jr z,_label_14_059	; $48c1
	sbc b			; $48c3
	ldi (hl),a		; $48c4
	or $98			; $48c5
	add hl,hl		; $48c7
	or $98			; $48c8
	inc hl			; $48ca
	ld ($ff00+$1e),a	; $48cb
	ld e,$8b		; $48cd
	inc d			; $48cf
	xor $09			; $48d0
	or $98			; $48d2
	ldi a,(hl)		; $48d4
	xor d			; $48d5
	or $98			; $48d6
	inc h			; $48d8
	or $5d			; $48d9
	ld (hl),$9e		; $48db
	cp b			; $48dd
	sbc b			; $48de
	inc c			; $48df
	or $8e			; $48e0
	ld a,h			; $48e2
	ld bc,$508b		; $48e3
.DB $ec				; $48e6
	dec d			; $48e7
	pop af			; $48e8
	adc a			; $48e9
	nop			; $48ea
	adc c			; $48eb
	ld ($098c),sp		; $48ec
	pop af			; $48ef
	ret nz			; $48f0
	ld e,c			; $48f1
	ld e,(hl)		; $48f2
	ret nz			; $48f3
	ld e,c			; $48f4
	ld e,(hl)		; $48f5
	adc a			; $48f6
	nop			; $48f7
	adc c			; $48f8
	jr _label_14_055		; $48f9
	add hl,bc		; $48fb
	pop af			; $48fc
	ret nz			; $48fd
	ld e,c			; $48fe
	ld e,(hl)		; $48ff
	adc a			; $4900
	nop			; $4901
	adc c			; $4902
	jr -$74			; $4903
	add hl,bc		; $4905
	pop af			; $4906
	ret nz			; $4907
	ld e,c			; $4908
	ld e,(hl)		; $4909
	ret nz			; $490a
	ld e,c			; $490b
	ld e,(hl)		; $490c
	adc a			; $490d
	nop			; $490e
	adc c			; $490f
	ld ($198c),sp		; $4910
	pop af			; $4913
	ret nz			; $4914
	ld e,c			; $4915
	ld e,(hl)		; $4916
	ret nz			; $4917
	ld e,c			; $4918
	ld e,(hl)		; $4919
	ret nz			; $491a
	ld e,c			; $491b
_label_14_060:
	ld e,(hl)		; $491c
	adc a			; $491d
	nop			; $491e
	adc c			; $491f
	jr _label_14_056		; $4920
	ld de,$eef1		; $4922
	dec d			; $4925
	adc (hl)		; $4926
	ld a,h			; $4927
	nop			; $4928
	or $98			; $4929
	dec c			; $492b
	or $b9			; $492c
	ld e,(hl)		; $492e
	ld d,b			; $492f
	cp l			; $4930
	ld ($ff00+$67),a	; $4931
	ld e,d			; $4933
	sub c			; $4934
	xor d			; $4935
	call z,$f801		; $4936
	ld ($ff00+$21),a	; $4939
_label_14_061:
	ld e,d			; $493b
	and b			; $493c
	ret nz			; $493d
	ld a,(bc)		; $493e
_label_14_062:
	ld e,a			; $493f
	or $98			; $4940
	dec h			; $4942
	or $a9			; $4943
	adc (hl)		; $4945
	ld a,h			; $4946
	ld bc,$1ee0		; $4947
	ld e,$8b		; $494a
	jr z,_label_14_061	; $494c
	ld b,c			; $494e
	pop af			; $494f
	adc e			; $4950
	jr z,_label_14_062	; $4951
	rra			; $4953
	ret nz			; $4954
	ld bc,$e05f		; $4955
	ld h,c			; $4958
	ld e,d			; $4959
	and d			; $495a
	ld ($ff00+$45),a	; $495b
	ld e,d			; $495d
	cp c			; $495e
.DB $d3				; $495f
	rlca			; $4960
	jp $b8cb		; $4961
	push af			; $4964
	ld ($ff00+$5b),a	; $4965
	ld e,d			; $4967
	sub c			; $4968
	jp $00cb		; $4969
	ld hl,sp-$46		; $496c
	sub c			; $496e
	inc b			; $496f
	call z,$000c		; $4970
	ld ($ff00+$39),a	; $4973
	ld e,$d5		; $4975
	ret nz			; $4977
	rst $8			; $4978
	ld bc,$42e0		; $4979
	ld e,$d5		; $497c
	ret nz			; $497e
	rst $8			; $497f
	ld b,$8f		; $4980
	inc bc			; $4982
	ld a,($ff00+c)		; $4983
	sub c			; $4984
	ret nz			; $4985
	rst $8			; $4986
	rlca			; $4987
	sbc b			; $4988
	dec a			; $4989
	inc c			; $498a
	di			; $498b
	adc a			; $498c
	rlca			; $498d
_label_14_063:
	adc c			; $498e
	jr _label_14_060		; $498f
	dec b			; $4991
	adc h			; $4992
	ld e,$91		; $4993
	ret nz			; $4995
	rst $8			; $4996
	ld ($f800),sp		; $4997
	adc b			; $499a
	jr _label_14_065		; $499b
	adc e			; $499d
_label_14_064:
	jr z,_label_14_063	; $499e
	ld de,$edf1		; $49a0
	add hl,sp		; $49a3
	pop af			; $49a4
	xor $11			; $49a5
	pop af			; $49a7
	sbc b			; $49a8
	ld d,b			; $49a9
	dec c			; $49aa
	or $84			; $49ab
	cp d			; $49ad
	ld bc,$1818		; $49ae
	and b			; $49b1
	adc h			; $49b2
	ld d,c			; $49b3
	xor c			; $49b4
_label_14_065:
	nop			; $49b5
	adc a			; $49b6
	ld (bc),a		; $49b7
	and (hl)		; $49b8
	adc a			; $49b9
	inc bc			; $49ba
.DB $f4				; $49bb
	adc a			; $49bc
	ld bc,$8ff4		; $49bd
	ld (bc),a		; $49c0
	and l			; $49c1
	ld ($ff00+$c8),a	; $49c2
	ld e,d			; $49c4
.DB $e3				; $49c5
	ld d,b			; $49c6
	nop			; $49c7
	adc a			; $49c8
	inc bc			; $49c9
	ei			; $49ca
	adc e			; $49cb
_label_14_066:
	inc d			; $49cc
_label_14_067:
	adc c			; $49cd
	jr -$74			; $49ce
	ret nz			; $49d0
	ld a,($008f)		; $49d1
	rst_addAToHl			; $49d4
	sub (hl)		; $49d5
	sub c			; $49d6
	rst_addDoubleIndex			; $49d7
	rst $8			; $49d8
	ld bc,$bd00		; $49d9
	add h			; $49dc
	ld e,l			; $49dd
	rlca			; $49de
	ld l,b			; $49df
	ld e,b			; $49e0
	adc (hl)		; $49e1
	ld a,c			; $49e2
	nop			; $49e3
.DB $e3				; $49e4
	ld l,c			; $49e5
	adc a			; $49e6
	inc b			; $49e7
	rst $30			; $49e8
	sub c			; $49e9
	sbc $cf			; $49ea
	add b			; $49ec
	adc a			; $49ed
	ld (bc),a		; $49ee
	sbc b			; $49ef
	dec sp			; $49f0
	sub c			; $49f1
	rst_addDoubleIndex			; $49f2
	rst $8			; $49f3
	ld bc,$41de		; $49f4
	ld ($40b1),sp		; $49f7
	ld ($ff00+$d1),a	; $49fa
	ld e,d			; $49fc
_label_14_068:
	or $8e			; $49fd
	ld a,d			; $49ff
	ld bc,$508b		; $4a00
	adc c			; $4a03
	ld ($118c),sp		; $4a04
	adc a			; $4a07
	ld bc,$1089		; $4a08
	adc h			; $4a0b
	add hl,hl		; $4a0c
	cp (hl)			; $4a0d
	nop			; $4a0e
	adc b			; $4a0f
	ld (hl),b		; $4a10
	jr _label_14_064		; $4a11
	ld d,b			; $4a13
.DB $e4				; $4a14
	ld hl,$89fa		; $4a15
	ld ($118c),sp		; $4a18
	sub d			; $4a1b
	pop de			; $4a1c
	rst $8			; $4a1d
	stop			; $4a1e
	push af			; $4a1f
	adc h			; $4a20
	dec c			; $4a21
	rst $30			; $4a22
	adc c			; $4a23
	nop			; $4a24
	adc h			; $4a25
	ld ($d192),sp		; $4a26
	rst $8			; $4a29
	ld (bc),a		; $4a2a
	rst $30			; $4a2b
	adc c			; $4a2c
	ld ($138c),sp		; $4a2d
	sub d			; $4a30
	pop de			; $4a31
	rst $8			; $4a32
	ld ($89f7),sp		; $4a33
	nop			; $4a36
	adc h			; $4a37
	ld a,(bc)		; $4a38
	sub d			; $4a39
	pop de			; $4a3a
	rst $8			; $4a3b
	inc b			; $4a3c
	rst $30			; $4a3d
	adc c			; $4a3e
	jr _label_14_067		; $4a3f
	jr nc,_label_14_066	; $4a41
	nop			; $4a43
	adc h			; $4a44
	dec c			; $4a45
	sub d			; $4a46
	pop de			; $4a47
	rst $8			; $4a48
	ld bc,$8900		; $4a49
	ld ($148c),sp		; $4a4c
	sub d			; $4a4f
	pop de			; $4a50
	rst $8			; $4a51
	ld b,b			; $4a52
	push de			; $4a53
	ret nc			; $4a54
	rst $8			; $4a55
	rlca			; $4a56
	adc h			; $4a57
	ld d,$92		; $4a58
	pop de			; $4a5a
	rst $8			; $4a5b
	add b			; $4a5c
	push de			; $4a5d
	ret nc			; $4a5e
	rst $8			; $4a5f
	ld a,(bc)		; $4a60
	ld sp,hl		; $4a61
	adc c			; $4a62
	nop			; $4a63
	adc h			; $4a64
	jr z,-$6f		; $4a65
	ret nc			; $4a67
	rst $8			; $4a68
	dec bc			; $4a69
	or c			; $4a6a
	add b			; $4a6b
	nop			; $4a6c
	adc b			; $4a6d
	ld ($ff00+$80),a	; $4a6e
	or $8b			; $4a70
	jr z,_label_14_068	; $4a72
	nop			; $4a74
	adc a			; $4a75
	ld (bc),a		; $4a76
	adc h			; $4a77
	ld e,b			; $4a78
	adc a			; $4a79
	ld bc,$98f8		; $4a7a
	ld e,$00		; $4a7d
	di			; $4a7f
	sbc b			; $4a80
	ld e,$02		; $4a81
	di			; $4a83
	sbc b			; $4a84
	ld e,$03		; $4a85
	di			; $4a87
	sbc b			; $4a88
	ld e,$04		; $4a89
	di			; $4a8b
	sub c			; $4a8c
	ret nc			; $4a8d
	rst $8			; $4a8e
	dec bc			; $4a8f
	nop			; $4a90
	adc b			; $4a91
	nop			; $4a92
	ld h,b			; $4a93
	adc e			; $4a94
	inc d			; $4a95
	adc c			; $4a96
	stop			; $4a97
	adc h			; $4a98
	add b			; $4a99
	adc a			; $4a9a
	stop			; $4a9b
	ld hl,sp-$68		; $4a9c
	rla			; $4a9e
	ld a,(de)		; $4a9f
	ld hl,sp-$57		; $4aa0
	nop			; $4aa2
	or (hl)			; $4aa3
	ld e,b			; $4aa4
	pop hl			; $4aa5
	push af			; $4aa6
	ld e,d			; $4aa7
	dec c			; $4aa8
	sbc b			; $4aa9
	ld d,l			; $4aaa
	pop hl			; $4aab
	push af			; $4aac
	ld e,d			; $4aad
	dec bc			; $4aae
	ld ($ff00+$44),a	; $4aaf
	ld sp,$f8d1		; $4ab1
	ld ($ff00+$71),a	; $4ab4
	ld sp,$e1d1		; $4ab6
	push af			; $4ab9
	ld e,d			; $4aba
	dec c			; $4abb
	sbc b			; $4abc
	ld d,a			; $4abd
	pop hl			; $4abe
	push af			; $4abf
	ld e,d			; $4ac0
	dec bc			; $4ac1
	ld ($ff00+$0c),a	; $4ac2
	ld e,e			; $4ac4
	or $e0			; $4ac5
	adc l			; $4ac7
	ld h,h			; $4ac8
	di			; $4ac9
.DB $e3				; $4aca
	or h			; $4acb
	ld ($ff00+$44),a	; $4acc
	ld sp,$e3f5		; $4ace
	or h			; $4ad1
	ld ($ff00+$44),a	; $4ad2
	ld sp,$e3f5		; $4ad4
	or h			; $4ad7
	ld ($ff00+$44),a	; $4ad8
	ld sp,$f5d1		; $4ada
	pop hl			; $4add
	ld e,h			; $4ade
	ld sp,$d104		; $4adf
	sbc $0c			; $4ae2
	nop			; $4ae4
	ld hl,sp-$4a		; $4ae5
	ld h,d			; $4ae7
	ld h,d			; $4ae8
	ld b,h			; $4ae9
	cp e			; $4aea
	cp d			; $4aeb
	add b			; $4aec
	rst $38			; $4aed
	sbc b			; $4aee
	ldi a,(hl)		; $4aef
	ld (bc),a		; $4af0
.DB $e4				; $4af1
	ldh a,(<hFF8B)	; $4af2
	jr z,-$13		; $4af4
	ld de,$21ec		; $4af6
	rst $30			; $4af9
	ld ($ff00+$59),a	; $4afa
	ld e,e			; $4afc
	rst $30			; $4afd
	ld ($ff00+$5d),a	; $4afe
	ld e,e			; $4b00
	ld hl,sp-$6a		; $4b01
	stop			; $4b03
	ldh (<hFF8F),a	; $4b04
	ld e,e			; $4b06
	ld ($ff00+$2d),a	; $4b07
_label_14_069:
	ld e,e			; $4b09
	xor $11			; $4b0a
	or $91			; $4b0c
	ld ($00d0),sp		; $4b0e
	ld hl,sp-$68		; $4b11
	ldi a,(hl)		; $4b13
	inc bc			; $4b14
.DB $e4				; $4b15
	ld sp,$7dd7		; $4b16
	add b			; $4b19
	inc bc			; $4b1a
	ret nz			; $4b1b
	or c			; $4b1c
	ld h,d			; $4b1d
	ret nz			; $4b1e
	or c			; $4b1f
	ld h,d			; $4b20
	rst_addAToHl			; $4b21
	add $c0			; $4b22
	or c			; $4b24
	ld h,d			; $4b25
	ret nz			; $4b26
	or c			; $4b27
	ld h,d			; $4b28
_label_14_070:
	ld ($ff00+$64),a	; $4b29
	ld e,e			; $4b2b
.DB $e3				; $4b2c
	ld a,c			; $4b2d
	or $e0			; $4b2e
	or b			; $4b30
	ld e,e			; $4b31
	ld ($ff00+$73),a	; $4b32
	ld e,e			; $4b34
_label_14_071:
.DB $e4				; $4b35
	ld a,($ff00+$f8)	; $4b36
.DB $e3				; $4b38
	ld c,l			; $4b39
	xor e			; $4b3a
	xor a			; $4b3b
	ld hl,sp-$68		; $4b3c
	ldi a,(hl)		; $4b3e
	inc b			; $4b3f
	add b			; $4b40
_label_14_072:
	ld bc,$1096		; $4b41
.DB $e4				; $4b44
	rst $38			; $4b45
	or c			; $4b46
	ld b,b			; $4b47
	cp (hl)			; $4b48
	sub a			; $4b49
	ldi a,(hl)		; $4b4a
	dec b			; $4b4b
	sbc b			; $4b4c
_label_14_073:
	daa			; $4b4d
	ld ($1be0),sp		; $4b4e
	ld e,e			; $4b51
	adc a			; $4b52
	nop			; $4b53
	ld hl,sp-$7c		; $4b54
	ld l,a			; $4b56
_label_14_074:
	ld bc,$3838		; $4b57
.DB $e3				; $4b5a
	ld l,h			; $4b5b
.DB $f4				; $4b5c
	add b			; $4b5d
	rst $38			; $4b5e
	adc e			; $4b5f
	ld d,b			; $4b60
	xor $11			; $4b61
.DB $ed				; $4b63
	add hl,de		; $4b64
.DB $f4				; $4b65
	sub (hl)		; $4b66
	jr _label_14_069		; $4b67
	ld ($ff00+$25),a	; $4b69
	ld e,e			; $4b6b
	sub c			; $4b6c
	ld ($00d0),sp		; $4b6d
_label_14_075:
	rst $28			; $4b70
	add hl,de		; $4b71
.DB $ec				; $4b72
	add hl,de		; $4b73
	push af			; $4b74
	sub (hl)		; $4b75
	ld ($96f5),sp		; $4b76
	jr _label_14_075		; $4b79
	xor c			; $4b7b
	ldh a,(<hGameboyType)	; $4b7c
	stop			; $4b7e
	sbc b			; $4b7f
	daa			; $4b80
	add hl,bc		; $4b81
	xor d			; $4b82
	adc h			; $4b83
	ld sp,$0891		; $4b84
	ret nc			; $4b87
	ld (bc),a		; $4b88
	cp (hl)			; $4b89
	ld ($ff00+$d5),a	; $4b8a
	ld e,e			; $4b8c
	nop			; $4b8d
	or $98			; $4b8e
	ld hl,$7f8e		; $4b90
	ld bc,$508b		; $4b93
	rst $28			; $4b96
	ld de,$6ee3		; $4b97
	adc e			; $4b9a
	jr z,_label_14_070	; $4b9b
	ld de,$508b		; $4b9d
	adc h			; $4ba0
	add hl,bc		; $4ba1
.DB $ec				; $4ba2
	dec d			; $4ba3
.DB $e3				; $4ba4
	ret nc			; $4ba5
	adc c			; $4ba6
	jr _label_14_071		; $4ba7
	dec b			; $4ba9
.DB $e3				; $4baa
	ret nc			; $4bab
	adc c			; $4bac
	ld ($098c),sp		; $4bad
.DB $e3				; $4bb0
	ret nc			; $4bb1
	adc c			; $4bb2
	jr _label_14_072		; $4bb3
	add hl,bc		; $4bb5
.DB $e3				; $4bb6
	ret nc			; $4bb7
	adc c			; $4bb8
	ld ($098c),sp		; $4bb9
.DB $e3				; $4bbc
	ret nc			; $4bbd
	adc c			; $4bbe
	jr _label_14_073		; $4bbf
	dec b			; $4bc1
	xor $15			; $4bc2
.DB $ed				; $4bc4
	add hl,bc		; $4bc5
.DB $e3				; $4bc6
	ld l,(hl)		; $4bc7
	adc e			; $4bc8
	jr z,_label_14_074	; $4bc9
	ld de,$508b		; $4bcb
	adc h			; $4bce
	ld de,$008f		; $4bcf
	sbc b			; $4bd2
	ldi (hl),a		; $4bd3
	adc a			; $4bd4
	ld (bc),a		; $4bd5
	sbc b			; $4bd6
	inc hl			; $4bd7
	cp l			; $4bd8
	sbc $41			; $4bd9
	inc b			; $4bdb
	or c			; $4bdc
	ld b,b			; $4bdd
	adc (hl)		; $4bde
	ld a,a			; $4bdf
	nop			; $4be0
	cp (hl)			; $4be1
	ld h,l			; $4be2
	ld l,h			; $4be3
	sbc b			; $4be4
	ld bc,$b102		; $4be5
	add b			; $4be8
	cp b			; $4be9
	sub c			; $4bea
	ld ($03d0),sp		; $4beb
	add b			; $4bee
	rst $38			; $4bef
	adc e			; $4bf0
	ld d,b			; $4bf1
	rst $28			; $4bf2
	ld hl,$1096		; $4bf3
	or $8b			; $4bf6
	jr z,-$20		; $4bf8
	ld b,l			; $4bfa
	ld e,l			; $4bfb
	adc h			; $4bfc
	ld a,(bc)		; $4bfd
	adc a			; $4bfe
	inc b			; $4bff
	or $8f			; $4c00
	ld (bc),a		; $4c02
	add b			; $4c03
	rst $38			; $4c04
	nop			; $4c05
	sub c			; $4c06
	rst_addDoubleIndex			; $4c07
	rst $8			; $4c08
	nop			; $4c09
	add h			; $4c0a
	ld l,d			; $4c0b
	inc bc			; $4c0c
	nop			; $4c0d
	nop			; $4c0e
	adc a			; $4c0f
	dec b			; $4c10
	sub c			; $4c11
	rst_addDoubleIndex			; $4c12
	rst $8			; $4c13
	ld bc,$98f2		; $4c14
	ld bc,$8f05		; $4c17
	dec b			; $4c1a
.DB $e3				; $4c1b
	jp z,$20e0		; $4c1c
	ld e,l			; $4c1f
	push de			; $4c20
	pop de			; $4c21
	rst $8			; $4c22
	nop			; $4c23
	rst_addAToHl			; $4c24
	ldd (hl),a		; $4c25
	adc a			; $4c26
	ld b,$91		; $4c27
	rst_addDoubleIndex			; $4c29
	rst $8			; $4c2a
	ld (bc),a		; $4c2b
	ld a,($ff00+c)		; $4c2c
	sbc b			; $4c2d
	ld bc,$8f06		; $4c2e
	ld b,$e3		; $4c31
	set 4,b			; $4c33
	add hl,hl		; $4c35
	ld e,l			; $4c36
	push de			; $4c37
	pop de			; $4c38
	rst $8			; $4c39
	nop			; $4c3a
	rst_addAToHl			; $4c3b
	ldd (hl),a		; $4c3c
	adc a			; $4c3d
	inc b			; $4c3e
	sub c			; $4c3f
	rst_addDoubleIndex			; $4c40
	rst $8			; $4c41
	inc bc			; $4c42
	ld a,($ff00+c)		; $4c43
	sbc b			; $4c44
	ld bc,$8f07		; $4c45
	inc b			; $4c48
.DB $e3				; $4c49
	call $32e0		; $4c4a
	ld e,l			; $4c4d
	push de			; $4c4e
	pop de			; $4c4f
	rst $8			; $4c50
	nop			; $4c51
	rst_addAToHl			; $4c52
	ldd (hl),a		; $4c53
	sub c			; $4c54
	rst_addDoubleIndex			; $4c55
	rst $8			; $4c56
	rst $38			; $4c57
	adc a			; $4c58
	ld bc,$0198		; $4c59
	ld (multiplyABy4),sp		; $4c5c
	ld b,c			; $4c5f
	ld h,(hl)		; $4c60
	sbc b			; $4c61
	ld bc,$d509		; $4c62
	and b			; $4c65
	rlc b			; $4c66
	ld h,(hl)		; $4c68
	dec sp			; $4c69
	ld bc,$021e		; $4c6a
	ld (hl),b		; $4c6d
	inc b			; $4c6e
	inc d			; $4c6f
.DB $fd				; $4c70
	and b			; $4c71
	ld (bc),a		; $4c72
	inc b			; $4c73
	dec d			; $4c74
.DB $fd				; $4c75
	and b			; $4c76
	ld (bc),a		; $4c77
	inc b			; $4c78
	ld d,$fd		; $4c79
	and b			; $4c7b
	ld (bc),a		; $4c7c
	ld bc,$021e		; $4c7d
	ld (hl),b		; $4c80
	dec b			; $4c81
	inc bc			; $4c82
	inc d			; $4c83
.DB $fd				; $4c84
	ld bc,$021e		; $4c85
	jp nz,$0307		; $4c88
	inc b			; $4c8b
	cp $00			; $4c8c
	ld bc,$050f		; $4c8e
	inc bc			; $4c91
	inc b			; $4c92
	cp $01			; $4c93
	rrca			; $4c95
	rlca			; $4c96
	inc bc			; $4c97
	inc d			; $4c98
	cp $00			; $4c99
	dec b			; $4c9b
	inc bc			; $4c9c
	inc b			; $4c9d
	rst $38			; $4c9e
	ld bc,$050f		; $4c9f
	inc bc			; $4ca2
	inc d			; $4ca3
	cp $01			; $4ca4
	rrca			; $4ca6
	rlca			; $4ca7
	inc bc			; $4ca8
	inc h			; $4ca9
	cp $00			; $4caa
	dec b			; $4cac
	inc bc			; $4cad
	inc d			; $4cae
	rst $38			; $4caf
	ld bc,$050f		; $4cb0
	inc bc			; $4cb3
	inc h			; $4cb4
	cp $01			; $4cb5
	rrca			; $4cb7
	rlca			; $4cb8
	inc bc			; $4cb9
	inc (hl)		; $4cba
	cp $00			; $4cbb
	dec b			; $4cbd
	inc bc			; $4cbe
	inc h			; $4cbf
	rst $38			; $4cc0
	ld bc,$050f		; $4cc1
	inc bc			; $4cc4
	inc (hl)		; $4cc5
	cp $01			; $4cc6
	rrca			; $4cc8
	rlca			; $4cc9
	inc bc			; $4cca
	ld b,h			; $4ccb
	cp $00			; $4ccc
	dec b			; $4cce
	inc bc			; $4ccf
	inc (hl)		; $4cd0
	rst $38			; $4cd1
	ld bc,$050f		; $4cd2
	inc bc			; $4cd5
	ld b,h			; $4cd6
	cp $01			; $4cd7
	rrca			; $4cd9
	rlca			; $4cda
	inc bc			; $4cdb
	ld d,h			; $4cdc
	cp $00			; $4cdd
	dec b			; $4cdf
	inc bc			; $4ce0
	ld b,h			; $4ce1
	rst $38			; $4ce2
	ld bc,$050f		; $4ce3
	inc bc			; $4ce6
	ld d,h			; $4ce7
	cp $01			; $4ce8
	rrca			; $4cea
	rlca			; $4ceb
	inc bc			; $4cec
	ld h,h			; $4ced
	cp $00			; $4cee
	dec b			; $4cf0
	inc bc			; $4cf1
	ld d,h			; $4cf2
	rst $38			; $4cf3
	ld bc,$050f		; $4cf4
	inc bc			; $4cf7
	ld h,h			; $4cf8
	cp $01			; $4cf9
	rrca			; $4cfb
	rlca			; $4cfc
	inc bc			; $4cfd
	ld (hl),h		; $4cfe
	cp $00			; $4cff
	dec b			; $4d01
	inc bc			; $4d02
	ld h,h			; $4d03
	rst $38			; $4d04
	ld bc,$050f		; $4d05
	inc bc			; $4d08
	ld (hl),h		; $4d09
	cp $01			; $4d0a
	rrca			; $4d0c
	dec b			; $4d0d
	inc bc			; $4d0e
	ld (hl),h		; $4d0f
	rst $38			; $4d10
	ld bc,$013c		; $4d11
	rrca			; $4d14
	rlca			; $4d15
	inc bc			; $4d16
	inc b			; $4d17
	ld a,($0100)		; $4d18
	rrca			; $4d1b
	dec b			; $4d1c
	inc bc			; $4d1d
	inc b			; $4d1e
	ld a,($0f01)		; $4d1f
	rlca			; $4d22
	inc bc			; $4d23
	inc d			; $4d24
	ld a,($0100)		; $4d25
	rrca			; $4d28
	dec b			; $4d29
	inc bc			; $4d2a
	inc d			; $4d2b
	ld a,($0f01)		; $4d2c
	rlca			; $4d2f
	inc bc			; $4d30
	inc h			; $4d31
	ld a,($0100)		; $4d32
	rrca			; $4d35
	dec b			; $4d36
	inc bc			; $4d37
	inc h			; $4d38
	ld a,($0f01)		; $4d39
	rlca			; $4d3c
	inc bc			; $4d3d
	inc (hl)		; $4d3e
	ld a,($0100)		; $4d3f
	rrca			; $4d42
	dec b			; $4d43
	inc bc			; $4d44
	inc (hl)		; $4d45
	ld a,($0f01)		; $4d46
	rlca			; $4d49
	inc bc			; $4d4a
	ld b,h			; $4d4b
	ld a,($0100)		; $4d4c
	rrca			; $4d4f
	dec b			; $4d50
	inc bc			; $4d51
	ld b,h			; $4d52
	ld a,($0f01)		; $4d53
	rlca			; $4d56
	inc bc			; $4d57
	ld d,h			; $4d58
	ld a,($0100)		; $4d59
	rrca			; $4d5c
	dec b			; $4d5d
	inc bc			; $4d5e
	ld d,h			; $4d5f
	ld a,($0f01)		; $4d60
	rlca			; $4d63
	inc bc			; $4d64
	ld h,h			; $4d65
	ld a,($0100)		; $4d66
	rrca			; $4d69
	dec b			; $4d6a
	inc bc			; $4d6b
	ld h,h			; $4d6c
	ld a,($0f01)		; $4d6d
	rlca			; $4d70
	inc bc			; $4d71
	ld (hl),h		; $4d72
	ld a,($0100)		; $4d73
	rrca			; $4d76
	dec b			; $4d77
	inc bc			; $4d78
	ld (hl),h		; $4d79
	ld a,($b401)		; $4d7a
	ld (bc),a		; $4d7d
	pop af			; $4d7e
	nop			; $4d7f
	ld (bc),a		; $4d80
	jp nz,$1401		; $4d81
	inc b			; $4d84
	ld h,d			; $4d85
	ld b,l			; $4d86
	rst $38			; $4d87
	ld (bc),a		; $4d88
	inc b			; $4d89
	ld h,e			; $4d8a
	ld d,h			; $4d8b
	rst $38			; $4d8c
	ld (bc),a		; $4d8d
	inc b			; $4d8e
	ld h,h			; $4d8f
	ld b,(hl)		; $4d90
	rst $38			; $4d91
	ld (bc),a		; $4d92
	ld bc,$0314		; $4d93
	ld h,d			; $4d96
	ld b,l			; $4d97
	inc bc			; $4d98
	ld h,e			; $4d99
	ld d,h			; $4d9a
	inc bc			; $4d9b
	ld h,h			; $4d9c
	ld b,(hl)		; $4d9d
	ld bc,$0414		; $4d9e
	ld (hl),d		; $4da1
	ld b,l			; $4da2
	rst $38			; $4da3
	ld (bc),a		; $4da4
	inc b			; $4da5
	ld (hl),e		; $4da6
	ld d,h			; $4da7
	rst $38			; $4da8
	ld (bc),a		; $4da9
	inc b			; $4daa
	ld (hl),h		; $4dab
	ld b,(hl)		; $4dac
	rst $38			; $4dad
	ld (bc),a		; $4dae
	ld bc,$0314		; $4daf
	ld (hl),d		; $4db2
	ld b,l			; $4db3
	inc bc			; $4db4
	ld (hl),e		; $4db5
	ld d,h			; $4db6
	inc bc			; $4db7
	ld (hl),h		; $4db8
	ld b,(hl)		; $4db9
	ld bc,$000a		; $4dba
	inc b			; $4dbd
	ld (bc),a		; $4dbe
	or (hl)			; $4dbf
	rst $38			; $4dc0
	ld (bc),a		; $4dc1
	inc b			; $4dc2
	inc bc			; $4dc3
	or a			; $4dc4
	rst $38			; $4dc5
	ld (bc),a		; $4dc6
	inc b			; $4dc7
	inc b			; $4dc8
	cp b			; $4dc9
	rst $38			; $4dca
	ld (bc),a		; $4dcb
	ld bc,$0314		; $4dcc
	ld (bc),a		; $4dcf
	or (hl)			; $4dd0
	inc bc			; $4dd1
	inc bc			; $4dd2
	or a			; $4dd3
	inc bc			; $4dd4
	inc b			; $4dd5
	cp b			; $4dd6
	ld bc,$0414		; $4dd7
	ld (de),a		; $4dda
	ld l,e			; $4ddb
	rst $38			; $4ddc
	ld (bc),a		; $4ddd
	inc b			; $4dde
	inc de			; $4ddf
	xor $ff			; $4de0
	ld (bc),a		; $4de2
	inc b			; $4de3
	inc d			; $4de4
	ld l,e			; $4de5
	rst $38			; $4de6
	ld (bc),a		; $4de7
	ld bc,$0314		; $4de8
	ld (de),a		; $4deb
	ld l,e			; $4dec
	inc bc			; $4ded
	inc de			; $4dee
	xor $03			; $4def
	inc d			; $4df1
	ld l,e			; $4df2
	ld bc,$0414		; $4df3
	ldi (hl),a		; $4df6
	ld l,e			; $4df7
	rst $38			; $4df8
	ld (bc),a		; $4df9
	inc b			; $4dfa
	inc hl			; $4dfb
	call z,$02ff		; $4dfc
	inc b			; $4dff
	inc h			; $4e00
	ld l,e			; $4e01
	rst $38			; $4e02
	ld (bc),a		; $4e03
	ld bc,$0314		; $4e04
	ldi (hl),a		; $4e07
	ld l,e			; $4e08
	inc bc			; $4e09
	inc hl			; $4e0a
	call z,$2403		; $4e0b
	ld l,e			; $4e0e
	ld bc,$003c		; $4e0f
	ld bc,$0228		; $4e12
	ld (hl),b		; $4e15
	inc b			; $4e16
	ld b,e			; $4e17
.DB $fd				; $4e18
	dec l			; $4e19
	inc bc			; $4e1a
	inc b			; $4e1b
	ld b,h			; $4e1c
.DB $fd				; $4e1d
	dec l			; $4e1e
	ld bc,$5304		; $4e1f
.DB $fd				; $4e22
	ld l,$03		; $4e23
	inc b			; $4e25
	ld d,h			; $4e26
.DB $fd				; $4e27
	ld l,$01		; $4e28
	ld bc,$0228		; $4e2a
	ld (hl),b		; $4e2d
	inc bc			; $4e2e
	ld b,e			; $4e2f
	dec l			; $4e30
	inc bc			; $4e31
	ld b,h			; $4e32
_label_14_076:
	dec l			; $4e33
	inc bc			; $4e34
	ld d,e			; $4e35
	ld l,$03		; $4e36
	ld d,h			; $4e38
	ld l,$01		; $4e39
	jr z,_label_14_078	; $4e3b
	ld c,l			; $4e3d
_label_14_077:
	nop			; $4e3e
_label_14_078:
	adc b			; $4e3f
	ld c,b			; $4e40
	or b			; $4e41
	or c			; $4e42
	ld b,b			; $4e43
	ld hl,sp-$7f		; $4e44
	inc bc			; $4e46
	adc e			; $4e47
	ld d,b			; $4e48
	rst $28			; $4e49
_label_14_079:
	add hl,sp		; $4e4a
.DB $ec				; $4e4b
	add hl,de		; $4e4c
	add c			; $4e4d
	ld (bc),a		; $4e4e
	adc a			; $4e4f
	ld (bc),a		; $4e50
_label_14_080:
	sbc b			; $4e51
_label_14_081:
	ld h,$00		; $4e52
	ld h,a			; $4e54
	inc hl			; $4e55
	adc e			; $4e56
	ld d,b			; $4e57
	adc a			; $4e58
	ld (bc),a		; $4e59
	add c			; $4e5a
	ld (bc),a		; $4e5b
_label_14_082:
	ld hl,sp-$68		; $4e5c
	ld h,$02		; $4e5e
	ld h,a			; $4e60
	inc hl			; $4e61
.DB $ec				; $4e62
_label_14_083:
	jr nz,_label_14_081	; $4e63
	stop			; $4e65
	ret nz			; $4e66
	add b			; $4e67
	ld h,a			; $4e68
	xor $30			; $4e69
_label_14_084:
	rst $28			; $4e6b
	ld b,b			; $4e6c
	ret nz			; $4e6d
	sub (hl)		; $4e6e
_label_14_085:
	ld h,a			; $4e6f
.DB $ec				; $4e70
	jr nc,_label_14_076	; $4e71
	ld (hl),l		; $4e73
	ld h,a			; $4e74
.DB $ec				; $4e75
	ld b,h			; $4e76
	xor b			; $4e77
	nop			; $4e78
.DB $ec				; $4e79
	jr nz,_label_14_084	; $4e7a
	jr nc,_label_14_077	; $4e7c
_label_14_086:
	sub (hl)		; $4e7e
	ld h,a			; $4e7f
	xor $30			; $4e80
	ret nz			; $4e82
	adc e			; $4e83
	ld h,a			; $4e84
.DB $ed				; $4e85
_label_14_087:
	ld b,b			; $4e86
.DB $ec				; $4e87
	jr nc,_label_14_079	; $4e88
	ld (hl),l		; $4e8a
	ld h,a			; $4e8b
.DB $ec				; $4e8c
_label_14_088:
	jr nc,_label_14_086	; $4e8d
	jr nc,_label_14_080	; $4e8f
	sub (hl)		; $4e91
	ld h,a			; $4e92
.DB $ec				; $4e93
_label_14_089:
	inc h			; $4e94
	xor b			; $4e95
	nop			; $4e96
.DB $ec				; $4e97
	stop			; $4e98
.DB $ed				; $4e99
	jr nc,_label_14_082	; $4e9a
	add b			; $4e9c
	ld h,a			; $4e9d
	xor $30			; $4e9e
	rst $28			; $4ea0
	jr nc,_label_14_083	; $4ea1
	sub (hl)		; $4ea3
	ld h,a			; $4ea4
	rst $28			; $4ea5
	jr nc,_label_14_089	; $4ea6
	ld d,b			; $4ea8
	ret nz			; $4ea9
	ld (hl),l		; $4eaa
_label_14_090:
	ld h,a			; $4eab
.DB $ed				; $4eac
	jr nc,_label_14_085	; $4ead
	add b			; $4eaf
	ld h,a			; $4eb0
	xor $10			; $4eb1
_label_14_091:
.DB $ed				; $4eb3
	ld b,b			; $4eb4
	ret nz			; $4eb5
	add b			; $4eb6
_label_14_092:
	ld h,a			; $4eb7
.DB $ec				; $4eb8
	jr nc,-$40		; $4eb9
	ld (hl),l		; $4ebb
	ld h,a			; $4ebc
.DB $ec				; $4ebd
	inc d			; $4ebe
_label_14_093:
	xor b			; $4ebf
	nop			; $4ec0
.DB $ec				; $4ec1
	jr nc,_label_14_091	; $4ec2
	jr nc,_label_14_087	; $4ec4
	sub (hl)		; $4ec6
	ld h,a			; $4ec7
	xor $50			; $4ec8
.DB $ed				; $4eca
	jr nc,_label_14_088	; $4ecb
	add b			; $4ecd
	ld h,a			; $4ece
.DB $ec				; $4ecf
	jr nc,_label_14_093	; $4ed0
	jr nc,_label_14_089	; $4ed2
	add b			; $4ed4
	ld h,a			; $4ed5
	xor $30			; $4ed6
_label_14_094:
	rst $28			; $4ed8
	jr nc,-$40		; $4ed9
	sub (hl)		; $4edb
	ld h,a			; $4edc
.DB $ec				; $4edd
	ld d,b			; $4ede
	ret nz			; $4edf
	ld (hl),l		; $4ee0
	ld h,a			; $4ee1
.DB $ec				; $4ee2
	inc (hl)		; $4ee3
	xor b			; $4ee4
	nop			; $4ee5
.DB $ec				; $4ee6
	jr nz,_label_14_094	; $4ee7
	jr nc,_label_14_090	; $4ee9
	sub (hl)		; $4eeb
	ld h,a			; $4eec
	xor $30			; $4eed
.DB $ed				; $4eef
	ld b,b			; $4ef0
	ret nz			; $4ef1
_label_14_095:
	add b			; $4ef2
	ld h,a			; $4ef3
.DB $ec				; $4ef4
	jr nc,_label_14_092	; $4ef5
	ld (hl),l		; $4ef7
	ld h,a			; $4ef8
	rst $28			; $4ef9
	ld b,b			; $4efa
	ret nz			; $4efb
	sub (hl)		; $4efc
	ld h,a			; $4efd
	rst $28			; $4efe
	inc (hl)		; $4eff
	ld h,a			; $4f00
	ld l,c			; $4f01
.DB $ec				; $4f02
	jr nz,_label_14_095	; $4f03
	stop			; $4f05
	ret nz			; $4f06
	add b			; $4f07
	ld h,a			; $4f08
	xor $30			; $4f09
	rst $28			; $4f0b
	ld b,b			; $4f0c
	ret nz			; $4f0d
	sub (hl)		; $4f0e
	ld h,a			; $4f0f
.DB $ec				; $4f10
	ld b,b			; $4f11
	xor $10			; $4f12
	ret nz			; $4f14
	sub (hl)		; $4f15
	ld h,a			; $4f16
	rst $28			; $4f17
	inc (hl)		; $4f18
_label_14_096:
	ld h,a			; $4f19
	ld l,c			; $4f1a
	or $ed			; $4f1b
	inc d			; $4f1d
	or $c0			; $4f1e
	ld (hl),l		; $4f20
	ld h,a			; $4f21
	rst $28			; $4f22
	inc d			; $4f23
_label_14_097:
	xor b			; $4f24
	nop			; $4f25
	cp l			; $4f26
_label_14_098:
.DB $e4				; $4f27
	rst $38			; $4f28
.DB $e3				; $4f29
	ld c,l			; $4f2a
_label_14_099:
	ldh (<hIntroInputsEnabled),a	; $4f2b
	ld e,l			; $4f2d
	add c			; $4f2e
	inc bc			; $4f2f
_label_14_100:
	adc e			; $4f30
	jr z,-$6a		; $4f31
	jr _label_14_099		; $4f33
	rst $28			; $4f35
	jr nz,_label_14_097	; $4f36
	jr nz,-$71		; $4f38
	ld (bc),a		; $4f3a
	or $e3			; $4f3b
	adc l			; $4f3d
	add sp,-$3b		; $4f3e
	or c			; $4f40
	ld b,b			; $4f41
	cp (hl)			; $4f42
	nop			; $4f43
	add c			; $4f44
	ld (bc),a		; $4f45
	cp b			; $4f46
	adc e			; $4f47
	ld d,b			; $4f48
	sub (hl)		; $4f49
	stop			; $4f4a
	sbc b			; $4f4b
	ld h,$01		; $4f4c
	add c			; $4f4e
	dec b			; $4f4f
	nop			; $4f50
	xor $40			; $4f51
	ret nz			; $4f53
	dec bc			; $4f54
	ld l,d			; $4f55
_label_14_101:
.DB $ed				; $4f56
	jr nc,_label_14_096	; $4f57
	jr nz,$6a		; $4f59
	xor $18			; $4f5b
	ret nz			; $4f5d
	dec bc			; $4f5e
	ld l,d			; $4f5f
	xor $20			; $4f60
	xor c			; $4f62
_label_14_102:
	nop			; $4f63
.DB $ec				; $4f64
	jr nz,_label_14_098	; $4f65
	cp $69			; $4f67
.DB $ed				; $4f69
	jr nc,-$12		; $4f6a
	stop			; $4f6c
.DB $ed				; $4f6d
	jr nc,_label_14_100	; $4f6e
	jr nz,_label_14_116	; $4f70
	rst $28			; $4f72
	jr nc,_label_14_102	; $4f73
	jr nz,-$11		; $4f75
_label_14_103:
	jr nc,-$40		; $4f77
	inc de			; $4f79
	ld l,d			; $4f7a
	xor $40			; $4f7b
	xor c			; $4f7d
_label_14_104:
	nop			; $4f7e
	adc b			; $4f7f
_label_14_105:
	jr z,-$78		; $4f80
_label_14_106:
	ld ($ff00+$4e),a	; $4f82
	ld e,(hl)		; $4f84
	sub (hl)		; $4f85
	jr _label_14_105		; $4f86
	rst $28			; $4f88
	stop			; $4f89
_label_14_107:
	xor $20			; $4f8a
	ret nz			; $4f8c
_label_14_108:
	dec bc			; $4f8d
	ld l,d			; $4f8e
	xor $10			; $4f8f
_label_14_109:
	rst $28			; $4f91
	jr nc,_label_14_106	; $4f92
	jr nz,_label_14_101	; $4f94
	dec bc			; $4f96
	ld l,d			; $4f97
	rst $28			; $4f98
	jr nc,-$14		; $4f99
	jr nc,_label_14_107	; $4f9b
	jr nz,-$14		; $4f9d
	jr nc,-$40		; $4f9f
_label_14_110:
	cp $69			; $4fa1
_label_14_111:
.DB $ed				; $4fa3
	stop			; $4fa4
	xor $80			; $4fa5
	xor c			; $4fa7
_label_14_112:
	nop			; $4fa8
	adc b			; $4fa9
	ld a,b			; $4faa
	jr c,_label_14_108	; $4fab
	ld c,(hl)		; $4fad
	ld e,(hl)		; $4fae
	sub (hl)		; $4faf
	ld ($edf8),sp		; $4fb0
	jr nc,_label_14_110	; $4fb3
_label_14_113:
	jr nz,_label_14_103	; $4fb5
	cp $69			; $4fb7
	rst $28			; $4fb9
	jr nz,_label_14_112	; $4fba
	jr nc,_label_14_104	; $4fbc
	cp $69			; $4fbe
	ld sp,hl		; $4fc0
.DB $ed				; $4fc1
	jr nc,-$12		; $4fc2
	jr nc,_label_14_113	; $4fc4
	stop			; $4fc6
	xor $40			; $4fc7
	xor c			; $4fc9
	nop			; $4fca
	adc b			; $4fcb
_label_14_114:
	jr c,_label_14_101	; $4fcc
	ld ($ff00+$4e),a	; $4fce
	ld e,(hl)		; $4fd0
	sub (hl)		; $4fd1
	jr _label_14_114		; $4fd2
	rst $28			; $4fd4
	ld d,b			; $4fd5
	sub (hl)		; $4fd6
_label_14_115:
	ld ($96f8),sp		; $4fd7
	jr _label_14_115		; $4fda
_label_14_116:
	rst $28			; $4fdc
	stop			; $4fdd
.DB $ec				; $4fde
_label_14_117:
	stop			; $4fdf
	rst $28			; $4fe0
	jr nz,_label_14_111	; $4fe1
	inc de			; $4fe3
	ld l,d			; $4fe4
	rst $28			; $4fe5
	jr nz,_label_14_109	; $4fe6
	nop			; $4fe8
_label_14_118:
	adc b			; $4fe9
_label_14_119:
	jr c,_label_14_124	; $4fea
	ld ($ff00+$4e),a	; $4fec
	ld e,(hl)		; $4fee
	sub (hl)		; $4fef
	jr _label_14_119		; $4ff0
	rst $28			; $4ff2
_label_14_120:
	stop			; $4ff3
	ret nz			; $4ff4
_label_14_121:
	inc de			; $4ff5
_label_14_122:
	ld l,d			; $4ff6
_label_14_123:
.DB $ec				; $4ff7
	jr nz,_label_14_118	; $4ff8
	stop			; $4ffa
	ret nz			; $4ffb
	inc de			; $4ffc
	ld l,d			; $4ffd
.DB $ed				; $4ffe
	jr nz,-$14		; $4fff
	stop			; $5001
.DB $ed				; $5002
	jr nc,_label_14_120	; $5003
	jr nc,_label_14_122	; $5005
	jr nc,_label_14_121	; $5007
	stop			; $5009
	rst $28			; $500a
	jr nz,-$40		; $500b
	inc de			; $500d
	ld l,d			; $500e
	rst $28			; $500f
	jr nz,-$57		; $5010
	nop			; $5012
	adc b			; $5013
_label_14_124:
	jr c,_label_14_135	; $5014
	ld ($ff00+$4e),a	; $5016
	ld e,(hl)		; $5018
	sub (hl)		; $5019
_label_14_125:
	nop			; $501a
_label_14_126:
	ld hl,sp-$14		; $501b
	jr nz,_label_14_117	; $501d
	cp $69			; $501f
	ei			; $5021
.DB $ed				; $5022
	ld b,b			; $5023
	ret nz			; $5024
	jr nz,_label_14_140	; $5025
	ld hl,sp-$12		; $5027
	jr nz,_label_14_125	; $5029
	jr nz,_label_14_126	; $502b
	stop			; $502d
	ret nz			; $502e
	dec bc			; $502f
	ld l,d			; $5030
_label_14_127:
	rst $28			; $5031
	ld d,b			; $5032
_label_14_128:
	ret nz			; $5033
_label_14_129:
	inc de			; $5034
	ld l,d			; $5035
_label_14_130:
.DB $ec				; $5036
	ld h,b			; $5037
_label_14_131:
	xor c			; $5038
_label_14_132:
	nop			; $5039
	adc b			; $503a
	ld ($e018),sp		; $503b
	ld c,(hl)		; $503e
	ld e,(hl)		; $503f
	sub (hl)		; $5040
	stop			; $5041
	ld hl,sp-$12		; $5042
	jr nc,_label_14_128	; $5044
	jr nz,_label_14_129	; $5046
	jr nz,_label_14_132	; $5048
	jr nz,_label_14_131	; $504a
	jr nz,_label_14_123	; $504c
	nop			; $504e
	adc b			; $504f
	ld ($e038),sp		; $5050
	ld c,(hl)		; $5053
	ld e,(hl)		; $5054
	sub (hl)		; $5055
	ld ($edf8),sp		; $5056
	ld b,b			; $5059
_label_14_133:
	xor $60			; $505a
	ret nz			; $505c
_label_14_134:
	dec bc			; $505d
_label_14_135:
	ld l,d			; $505e
	rst $28			; $505f
	ld h,b			; $5060
	ret nz			; $5061
	inc de			; $5062
_label_14_136:
	ld l,d			; $5063
.DB $ec				; $5064
	ld h,b			; $5065
	ret nz			; $5066
	cp $69			; $5067
.DB $ec				; $5069
	jr nz,-$57		; $506a
	nop			; $506c
	adc b			; $506d
_label_14_137:
	ld ($e088),sp		; $506e
	ld c,(hl)		; $5071
	ld e,(hl)		; $5072
	sub (hl)		; $5073
	jr _label_14_137		; $5074
	xor $60			; $5076
	ret nz			; $5078
_label_14_138:
	dec bc			; $5079
	ld l,d			; $507a
	rst $28			; $507b
	ld (hl),b		; $507c
	ret nz			; $507d
	inc de			; $507e
	ld l,d			; $507f
.DB $ec				; $5080
	ld h,b			; $5081
	ret nz			; $5082
	cp $69			; $5083
.DB $ec				; $5085
	jr nz,_label_14_127	; $5086
	nop			; $5088
	adc b			; $5089
	jr _label_14_124		; $508a
_label_14_139:
	ld ($ff00+$4e),a	; $508c
	ld e,(hl)		; $508e
	sub (hl)		; $508f
	stop			; $5090
_label_14_140:
	ld hl,sp-$12		; $5091
	ld h,b			; $5093
	ret nz			; $5094
	dec bc			; $5095
_label_14_141:
	ld l,d			; $5096
	rst $28			; $5097
	jr nc,_label_14_133	; $5098
	inc de			; $509a
	ld l,d			; $509b
.DB $ec				; $509c
	jr nc,_label_14_139	; $509d
	stop			; $509f
.DB $ec				; $50a0
	jr nc,_label_14_136	; $50a1
	cp $69			; $50a3
.DB $ed				; $50a5
_label_14_142:
	jr nz,_label_14_141	; $50a6
	add b			; $50a8
	xor c			; $50a9
	nop			; $50aa
	adc b			; $50ab
	jr _label_14_130		; $50ac
	ld ($ff00+$4e),a	; $50ae
	ld e,(hl)		; $50b0
	sub (hl)		; $50b1
	stop			; $50b2
	ld hl,sp-$12		; $50b3
_label_14_143:
	jr nc,_label_14_142	; $50b5
	jr nc,_label_14_138	; $50b7
	inc de			; $50b9
	ld l,d			; $50ba
	xor $30			; $50bb
	ret nz			; $50bd
	dec bc			; $50be
	ld l,d			; $50bf
.DB $ed				; $50c0
	jr nc,-$14		; $50c1
	jr nc,-$11		; $50c3
	jr nc,_label_14_143	; $50c5
	ld d,b			; $50c7
	xor c			; $50c8
	nop			; $50c9
	adc b			; $50ca
	ld c,b			; $50cb
	jr c,_label_14_134	; $50cc
	inc bc			; $50ce
	and b			; $50cf
	xor $50			; $50d0
	nop			; $50d2
	adc $a0			; $50d3
	sub c			; $50d5
	xor e			; $50d6
	call z,$f801		; $50d7
.DB $e3				; $50da
	ld c,l			; $50db
	ld hl,sp-$1d		; $50dc
	ld (hl),e		; $50de
	pop hl			; $50df
	or h			; $50e0
	ld h,c			; $50e1
	inc b			; $50e2
	di			; $50e3
.DB $e3				; $50e4
	ld (hl),e		; $50e5
	pop hl			; $50e6
	or h			; $50e7
	ld h,c			; $50e8
	dec b			; $50e9
	pop hl			; $50ea
	or h			; $50eb
	ld h,c			; $50ec
	inc bc			; $50ed
	di			; $50ee
.DB $e3				; $50ef
	ld (hl),e		; $50f0
	pop hl			; $50f1
	or h			; $50f2
	ld h,c			; $50f3
	ld bc,$b4e1		; $50f4
	ld h,c			; $50f7
	rlca			; $50f8
	di			; $50f9
.DB $e3				; $50fa
	ld (hl),e		; $50fb
	pop hl			; $50fc
	or h			; $50fd
	ld h,c			; $50fe
	nop			; $50ff
	pop hl			; $5100
	or h			; $5101
	ld h,c			; $5102
	ld ($e3f3),sp		; $5103
	ld (hl),e		; $5106
	pop hl			; $5107
	or h			; $5108
	ld h,c			; $5109
	ld (bc),a		; $510a
	pop hl			; $510b
	or h			; $510c
	ld h,c			; $510d
	ld b,$f3		; $510e
.DB $e3				; $5110
	ld (hl),e		; $5111
	pop hl			; $5112
	or h			; $5113
	ld h,c			; $5114
	ld bc,$b4e1		; $5115
	ld h,c			; $5118
	dec b			; $5119
	pop hl			; $511a
	or h			; $511b
	ld h,c			; $511c
	inc bc			; $511d
	pop hl			; $511e
	or h			; $511f
	ld h,c			; $5120
	rlca			; $5121
	di			; $5122
.DB $e3				; $5123
	ld (hl),e		; $5124
	pop hl			; $5125
	or h			; $5126
	ld h,c			; $5127
	inc b			; $5128
	pop hl			; $5129
	or h			; $512a
	ld h,c			; $512b
	nop			; $512c
	pop hl			; $512d
	or h			; $512e
	ld h,c			; $512f
	ld (bc),a		; $5130
	pop hl			; $5131
	or h			; $5132
	ld h,c			; $5133
	ld b,$e1		; $5134
	or h			; $5136
	ld h,c			; $5137
	ld ($22e7),sp		; $5138
	rrca			; $513b
	rst $20			; $513c
	inc hl			; $513d
	ld de,$32e7		; $513e
	ld de,$33e7		; $5141
_label_14_144:
	rrca			; $5144
	rst $20			; $5145
	inc (hl)		; $5146
	ld de,$e3f4		; $5147
	ld (hl),e		; $514a
	pop hl			; $514b
	or h			; $514c
	ld h,c			; $514d
	ld bc,$b4e1		; $514e
	ld h,c			; $5151
	dec b			; $5152
	pop hl			; $5153
	or h			; $5154
	ld h,c			; $5155
	inc bc			; $5156
	pop hl			; $5157
	or h			; $5158
	ld h,c			; $5159
	rlca			; $515a
	rst_addAToHl			; $515b
	ld b,$e3		; $515c
	ld h,a			; $515e
_label_14_145:
	sub c			; $515f
	ret nz			; $5160
	rst $8			; $5161
	nop			; $5162
	ld ($ff00+$dc),a	; $5163
	ld h,c			; $5165
.DB $e3				; $5166
	ld (hl),e		; $5167
	pop hl			; $5168
	or h			; $5169
	ld h,c			; $516a
	inc b			; $516b
	pop hl			; $516c
	or h			; $516d
	ld h,c			; $516e
_label_14_146:
	nop			; $516f
	pop hl			; $5170
	or h			; $5171
	ld h,c			; $5172
	ld (bc),a		; $5173
	pop hl			; $5174
	or h			; $5175
	ld h,c			; $5176
	ld b,$e1		; $5177
	or h			; $5179
	ld h,c			; $517a
	ld ($2de4),sp		; $517b
	sub c			; $517e
	xor e			; $517f
	call z,$a000		; $5180
.DB $e3				; $5183
	ld c,l			; $5184
.DB $e4				; $5185
	rst $38			; $5186
	ld ($ff00+c),a		; $5187
	push af			; $5188
	cp e			; $5189
_label_14_147:
	add sp,-$0f		; $518a
	or c			; $518c
	ld b,b			; $518d
	cp h			; $518e
	nop			; $518f
	adc (hl)		; $5190
	ld (hl),a		; $5191
	ld bc,$508b		; $5192
	rst $20			; $5195
	ld d,$a2		; $5196
	rst $20			; $5198
	rla			; $5199
	and d			; $519a
	rst $20			; $519b
	jr -$5e			; $519c
	rst $20			; $519e
	ld h,$a2		; $519f
	rst $20			; $51a1
	daa			; $51a2
_label_14_148:
	and d			; $51a3
_label_14_149:
	rst $20			; $51a4
	jr z,-$5e		; $51a5
	ld ($ff00+$eb),a	; $51a7
	ld h,c			; $51a9
	rst_addAToHl			; $51aa
	ld d,b			; $51ab
	sbc b			; $51ac
	jr c,_label_14_150	; $51ad
	adc (hl)		; $51af
	ld (hl),a		; $51b0
	nop			; $51b1
	adc c			; $51b2
_label_14_150:
	jr _label_14_144		; $51b3
	ld (bc),a		; $51b5
	adc h			; $51b6
	ld d,$d7		; $51b7
	ld b,$89		; $51b9
	stop			; $51bb
	adc a			; $51bc
	ld bc,objectDeleteRelatedObj1AsStaticObject		; $51bd
	sub c			; $51c0
	pop de			; $51c1
	rst $8			; $51c2
	ld bc,$fb00		; $51c3
	adc e			; $51c6
	jr z,_label_14_145	; $51c7
	stop			; $51c9
	adc h			; $51ca
	jr nz,_label_14_149	; $51cb
	ld b,$96		; $51cd
	ld ($408c),sp		; $51cf
	rst_addAToHl			; $51d2
	ld b,$96		; $51d3
	stop			; $51d5
	adc h			; $51d6
	inc d			; $51d7
	or $98			; $51d8
	dec b			; $51da
	nop			; $51db
	adc (hl)		; $51dc
	ld c,a			; $51dd
	nop			; $51de
	or $96			; $51df
	jr _label_14_146		; $51e1
	stop			; $51e3
	di			; $51e4
	sub (hl)		; $51e5
	stop			; $51e6
	adc h			; $51e7
	ld e,b			; $51e8
	cp (hl)			; $51e9
_label_14_151:
	adc (hl)		; $51ea
	ld e,d			; $51eb
	nop			; $51ec
	or (hl)			; $51ed
	ldi (hl),a		; $51ee
	nop			; $51ef
	ld hl,sp-$75		; $51f0
	jr z,_label_14_147	; $51f2
	stop			; $51f4
_label_14_152:
	adc h			; $51f5
	ld a,(bc)		; $51f6
	sub c			; $51f7
	ret nz			; $51f8
	rst $8			; $51f9
	ld bc,$1b8c		; $51fa
	rst_addAToHl			; $51fd
	ld b,$91		; $51fe
	ret nz			; $5200
	rst $8			; $5201
	ld (bc),a		; $5202
	rst_addAToHl			; $5203
	ld l,(hl)		; $5204
	sub c			; $5205
	rst_addDoubleIndex			; $5206
	rst $8			; $5207
	ld bc,$8b00		; $5208
	jr z,_label_14_148	; $520b
	nop			; $520d
	adc h			; $520e
	add b			; $520f
	rst_addAToHl			; $5210
	ld b,$96		; $5211
	jr _label_14_151		; $5213
	ret nz			; $5215
	rst $8			; $5216
	ld (bc),a		; $5217
	adc a			; $5218
	rlca			; $5219
	nop			; $521a
	push de			; $521b
	rrca			; $521c
	ret nc			; $521d
	nop			; $521e
	ld a,($148b)		; $521f
	xor $3c			; $5222
	di			; $5224
	adc (hl)		; $5225
	ld a,b			; $5226
	add b			; $5227
	pop hl			; $5228
.DB $d3				; $5229
	ld h,d			; $522a
	ld e,$f7		; $522b
	ret nz			; $522d
	ld a,(bc)		; $522e
	ld e,a			; $522f
	rst_addAToHl			; $5230
	ld b,$8e		; $5231
	ld a,b			; $5233
	ld bc,$288b		; $5234
	xor $13			; $5237
	adc (hl)		; $5239
	ld a,b			; $523a
	add b			; $523b
	di			; $523c
	adc (hl)		; $523d
	ld a,b			; $523e
	ld bc,$b6f8		; $523f
	jr nc,_label_14_152	; $5242
	ld b,b			; $5244
	nop			; $5245
	cp l			; $5246
	sub c			; $5247
	xor e			; $5248
	call z,$f601		; $5249
.DB $e4				; $524c
	dec l			; $524d
	or $98			; $524e
	dec b			; $5250
	inc b			; $5251
	or $91			; $5252
	ret nz			; $5254
	rst $8			; $5255
	ld bc,$3ed7		; $5256
	sbc b			; $5259
	dec b			; $525a
	dec b			; $525b
	ldh (<hFF8E),a	; $525c
	inc c			; $525e
	or $91			; $525f
	ret nz			; $5261
	rst $8			; $5262
	ld (bc),a		; $5263
	rst_addAToHl			; $5264
	add b			; $5265
.DB $e3				; $5266
	ret z			; $5267
	rst $30			; $5268
	sub c			; $5269
	ret nz			; $526a
	rst $8			; $526b
	inc bc			; $526c
	rst_addAToHl			; $526d
	ld (bc),a		; $526e
.DB $e4				; $526f
	dec l			; $5270
	cp (hl)			; $5271
	jp nc,$bdf6		; $5272
	ldh (<hFF8E),a	; $5275
	inc c			; $5277
	push af			; $5278
.DB $e3				; $5279
	ret z			; $527a
	push af			; $527b
.DB $e3				; $527c
	ret z			; $527d
	push af			; $527e
.DB $e3				; $527f
	ret z			; $5280
	or $91			; $5281
	ret nz			; $5283
	rst $8			; $5284
	inc b			; $5285
	ld ($ff00+$c7),a	; $5286
	ld h,e			; $5288
	push de			; $5289
	ld bc,$00d0		; $528a
	or $e1			; $528d
	pop de			; $528f
	ld h,e			; $5290
	nop			; $5291
.DB $e4				; $5292
	add hl,sp		; $5293
	sub c			; $5294
	ret nz			; $5295
	rst $8			; $5296
	dec b			; $5297
	rst_addAToHl			; $5298
	ld b,d			; $5299
	sbc b			; $529a
	dec b			; $529b
	ld b,$91		; $529c
	ret nz			; $529e
	rst $8			; $529f
	ld b,$d7		; $52a0
	inc h			; $52a2
	sub c			; $52a3
	ret nz			; $52a4
	rst $8			; $52a5
	rlca			; $52a6
	push af			; $52a7
	pop hl			; $52a8
	pop de			; $52a9
	ld h,e			; $52aa
	inc bc			; $52ab
	rst_addAToHl			; $52ac
	ld b,(hl)		; $52ad
	sbc b			; $52ae
	dec b			; $52af
	rlca			; $52b0
	ld ($ff00+$d8),a	; $52b1
	ld h,e			; $52b3
	sub c			; $52b4
	ret nz			; $52b5
	rst $8			; $52b6
	ld ($91f7),sp		; $52b7
	ret nz			; $52ba
	rst $8			; $52bb
	add hl,bc		; $52bc
	pop hl			; $52bd
	pop de			; $52be
	ld h,e			; $52bf
	ld (bc),a		; $52c0
	rst_addAToHl			; $52c1
	ldd (hl),a		; $52c2
	sbc b			; $52c3
	dec b			; $52c4
	ld ($c091),sp		; $52c5
	rst $8			; $52c8
	ld a,(bc)		; $52c9
	or $98			; $52ca
	dec b			; $52cc
	add hl,bc		; $52cd
	di			; $52ce
	pop hl			; $52cf
	pop bc			; $52d0
	ld h,e			; $52d1
	dec h			; $52d2
	or $98			; $52d3
	dec b			; $52d5
	ld a,(bc)		; $52d6
	or $91			; $52d7
	ret nz			; $52d9
	rst $8			; $52da
	dec bc			; $52db
	rst_addAToHl			; $52dc
	ld b,b			; $52dd
.DB $e4				; $52de
	rst $38			; $52df
	or (hl)			; $52e0
	inc hl			; $52e1
	sub c			; $52e2
	xor e			; $52e3
	call z,$be00		; $52e4
	nop			; $52e7
	adc b			; $52e8
	ld b,b			; $52e9
	ld d,b			; $52ea
	adc l			; $52eb
	ld (bc),a		; $52ec
	inc b			; $52ed
	ret nc			; $52ee
	cp l			; $52ef
	ld ($ff00+$39),a	; $52f0
	ld (hl),c		; $52f2
	rst_addAToHl			; $52f3
	add d			; $52f4
.DB $e3				; $52f5
	or h			; $52f6
	ld ($ff00+$44),a	; $52f7
	ld sp,$e3f5		; $52f9
	or h			; $52fc
	ld ($ff00+$44),a	; $52fd
	ld sp,$e3f5		; $52ff
	or h			; $5302
	ld ($ff00+$44),a	; $5303
	ld sp,$f5d1		; $5305
	add h			; $5308
	and $02			; $5309

	.db $38 $50 $e1 $5c $31 $04 $d1 $d3
	.db $00 $eb $cc $e1 $30 $71 $02 $f7
	.db $98 $08 $10 $e4 $fb $f9 $e4 $ff
	.db $be $00


	.include "data/seasons/interactionAnimations.s"


.BANK $15 SLOT 1
.ORG 0

.include "code/serialFunctions.s"


	ld a,($cca2)		; $451e
	inc a			; $4521
	jr nz,_label_15_040	; $4522
	xor a			; $4524
_label_15_038:
	ld e,$7f		; $4525
_label_15_039:
	ld (de),a		; $4527
	ret			; $4528
_label_15_040:
	ld a,($cca3)		; $4529
	swap a			; $452c
	and $03			; $452e
	rst_jumpTable			; $4530
	add hl,sp		; $4531
	ld b,l			; $4532
	ld b,c			; $4533
	ld b,l			; $4534
	dec a			; $4535
	ld b,l			; $4536
	add hl,sp		; $4537
	ld b,l			; $4538
	ld a,$04		; $4539
	jr _label_15_038		; $453b
	ld a,$03		; $453d
	jr _label_15_038		; $453f
	ld a,($cca3)		; $4541
	and $0f			; $4544
	add $6e			; $4546
	ld b,a			; $4548
	call checkGlobalFlag		; $4549
	ld a,$02		; $454c
	jr nz,_label_15_038	; $454e
	ld a,b			; $4550
	sub $0a			; $4551
	call checkGlobalFlag		; $4553
	ld a,$01		; $4556
	jr nz,_label_15_038	; $4558
	ld a,$05		; $455a
	jr _label_15_038		; $455c
	ld a,($cca3)		; $455e
	and $0f			; $4561
	add $0f			; $4563
	ld c,a			; $4565
	ld b,$55		; $4566
	jp showText		; $4568
	call getFreeInteractionSlot		; $456b
	ret nz			; $456e
	ld (hl),$d9		; $456f
	inc l			; $4571
	ld a,($cca3)		; $4572
	and $0f			; $4575
	ld (hl),a		; $4577
	ld l,$4b		; $4578
	ld c,$75		; $457a
	jp setShortPosition_paramC		; $457c
	ld hl,$481b		; $457f
	ld e,$03		; $4582
	jp interBankCall		; $4584
	call objectGetShortPosition		; $4587
	ld c,a			; $458a
	ld a,($cc3d)		; $458b
	and $f0			; $458e
	ld b,a			; $4590
	ld a,($cc3e)		; $4591
	and $f0			; $4594
	swap a			; $4596
	or b			; $4598
	cp c			; $4599
	ret nz			; $459a
	ld e,$49		; $459b
	ld a,(de)		; $459d
	rrca			; $459e
	and $03			; $459f
	ld hl,$45ba		; $45a1
	rst_addAToHl			; $45a4
	ld a,(hl)		; $45a5
	add c			; $45a6
	ld c,a			; $45a7
	and $f0			; $45a8
	or $08			; $45aa
	ld ($cc3d),a		; $45ac
	ld a,c			; $45af
	swap a			; $45b0
	and $f0			; $45b2
	or $08			; $45b4
	ld ($cc3e),a		; $45b6
	ret			; $45b9
	stop			; $45ba
	rst $38			; $45bb
	ld a,($ff00+$01)	; $45bc
	ld e,$7d		; $45be
	ld a,(de)		; $45c0
	ld b,a			; $45c1
	ld a,($ccba)		; $45c2
	and b			; $45c5
	jr z,_label_15_041	; $45c6
	call $45de		; $45c8
	ld a,$01		; $45cb
	jr z,_label_15_042	; $45cd
	xor a			; $45cf
	jr _label_15_042		; $45d0
_label_15_041:
	call $45f6		; $45d2
	ld a,$02		; $45d5
	jr z,_label_15_042	; $45d7
	xor a			; $45d9
_label_15_042:
	ld ($cfc1),a		; $45da
	ret			; $45dd
	ld e,$49		; $45de
	ld a,(de)		; $45e0
	sub $10			; $45e1
	srl a			; $45e3
	ld hl,$45f2		; $45e5
	rst_addAToHl			; $45e8
	ld e,$7e		; $45e9
	ld a,(de)		; $45eb
	ld c,a			; $45ec
	ld b,$cf		; $45ed
	ld a,(bc)		; $45ef
	cp (hl)			; $45f0
	ret			; $45f1
	ld a,b			; $45f2
	ld a,c			; $45f3
	ld a,d			; $45f4
	ld a,e			; $45f5
	ld e,$7e		; $45f6
	ld a,(de)		; $45f8
	ld c,a			; $45f9
	ld b,$ce		; $45fa
	ld a,(bc)		; $45fc
	or a			; $45fd
	ret			; $45fe
	xor a			; $45ff
	ld ($cfc1),a		; $4600
	ld a,($cc48)		; $4603
	rrca			; $4606
	ret nc			; $4607
	call objectCheckCollidedWithLink_ignoreZ		; $4608
	ret nc			; $460b
	ld a,$01		; $460c
	ld ($cfc1),a		; $460e
	ret			; $4611
	ld e,$7e		; $4612
	ld a,(de)		; $4614
	ld c,a			; $4615
	ld b,$cf		; $4616
	ld a,(bc)		; $4618
	cp $5d			; $4619
	ld b,$01		; $461b
	jr z,_label_15_043	; $461d
	cp $5e			; $461f
	jr z,_label_15_043	; $4621
	dec b			; $4623
_label_15_043:
	ld a,b			; $4624
	ld ($cfc1),a		; $4625
	ret			; $4628
	ld a,($cca9)		; $4629
	ld b,a			; $462c
	ld e,$50		; $462d
	ld a,(de)		; $462f
	cp b			; $4630
	ld a,$01		; $4631
	jr z,_label_15_044	; $4633
	dec a			; $4635
_label_15_044:
	ld ($cec0),a		; $4636
	ret			; $4639
	ld a,$04		; $463a
	jp removeRupeeValue		; $463c


interactionLoadTreasureData:
	ld e,$42		; $463f
	ld a,(de)		; $4641
	ld e,$70		; $4642
	ld (de),a		; $4644
	ld hl,treasureObjectData		; $4645
_label_15_045:
	call multiplyABy4		; $4648
	add hl,bc		; $464b
	bit 7,(hl)		; $464c
	jr z,_label_15_046	; $464e
	inc hl			; $4650
	ldi a,(hl)		; $4651
	ld h,(hl)		; $4652
	ld l,a			; $4653
	ld e,$43		; $4654
	ld a,(de)		; $4656
	jr _label_15_045		; $4657
_label_15_046:
	ldi a,(hl)		; $4659
	ld b,a			; $465a
	swap a			; $465b
	and $07			; $465d
	ld e,$71		; $465f
	ld (de),a		; $4661
	ld a,b			; $4662
	and $07			; $4663
	inc e			; $4665
	ld (de),a		; $4666
	ld a,b			; $4667
	and $08			; $4668
	inc e			; $466a
	ld (de),a		; $466b
	ldi a,(hl)		; $466c
	inc e			; $466d
	ld (de),a		; $466e
	ldi a,(hl)		; $466f
	inc e			; $4670
	ld (de),a		; $4671
	ldi a,(hl)		; $4672
	ld e,$42		; $4673
	ld (de),a		; $4675
	ret			; $4676
	call getFreePartSlot		; $4677
	ret nz			; $467a
	ld (hl),$04		; $467b
	jp objectCopyPosition		; $467d
	ld a,($cc55)		; $4680
	ld b,a			; $4683
	inc a			; $4684
	jr nz,_label_15_047	; $4685
	ld hl,$471d		; $4687
	jr _label_15_048		; $468a
_label_15_047:
	ld a,b			; $468c
	ld hl,$4723		; $468d
	rst_addDoubleIndex			; $4690
	ldi a,(hl)		; $4691
	ld h,(hl)		; $4692
	ld l,a			; $4693
_label_15_048:
	ld e,$72		; $4694
	ld a,(de)		; $4696
	rst_addDoubleIndex			; $4697
	ldi a,(hl)		; $4698
	ld h,(hl)		; $4699
	ld l,a			; $469a
	jr _label_15_053		; $469b
	ld e,$58		; $469d
	ld a,(de)		; $469f
	ld l,a			; $46a0
	inc e			; $46a1
	ld a,(de)		; $46a2
	ld h,a			; $46a3
_label_15_049:
	ldi a,(hl)		; $46a4
	push hl			; $46a5
	rst_jumpTable			; $46a6
	cp a			; $46a7
	ld b,(hl)		; $46a8
	jp z,$d646		; $46a9
	ld b,(hl)		; $46ac
.DB $dd				; $46ad
	ld b,(hl)		; $46ae
.DB $e4				; $46af
	ld b,(hl)		; $46b0
.DB $ec				; $46b1
	ld b,(hl)		; $46b2
	cp a			; $46b3
	ld b,(hl)		; $46b4
	cp a			; $46b5
	ld b,(hl)		; $46b6
	ld (bc),a		; $46b7
	ld b,a			; $46b8
	ld b,$47		; $46b9
	ld a,(bc)		; $46bb
	ld b,a			; $46bc
	ld c,$47		; $46bd
	pop hl			; $46bf
	ldi a,(hl)		; $46c0
	ld e,$46		; $46c1
	ld (de),a		; $46c3
	ld e,$45		; $46c4
	xor a			; $46c6
	ld (de),a		; $46c7
	jr _label_15_053		; $46c8
_label_15_050:
	pop hl			; $46ca
	ldi a,(hl)		; $46cb
	ld e,$46		; $46cc
	ld (de),a		; $46ce
	ld e,$45		; $46cf
	ld a,$01		; $46d1
	ld (de),a		; $46d3
	jr _label_15_053		; $46d4
	pop hl			; $46d6
	ldi a,(hl)		; $46d7
	ld e,$49		; $46d8
	ld (de),a		; $46da
	jr _label_15_049		; $46db
	pop hl			; $46dd
	ldi a,(hl)		; $46de
	ld e,$50		; $46df
	ld (de),a		; $46e1
	jr _label_15_049		; $46e2
	pop hl			; $46e4
	ld a,(hl)		; $46e5
	call s8ToS16		; $46e6
	add hl,bc		; $46e9
	jr _label_15_049		; $46ea
	pop hl			; $46ec
	ld a,($ccb0)		; $46ed
	cp d			; $46f0
	jr nz,_label_15_051	; $46f1
	inc hl			; $46f3
	jr _label_15_049		; $46f4
_label_15_051:
	dec hl			; $46f6
	ld a,$01		; $46f7
	ld e,$46		; $46f9
	ld (de),a		; $46fb
	xor a			; $46fc
	ld e,$45		; $46fd
	ld (de),a		; $46ff
	jr _label_15_053		; $4700
	ld a,$00		; $4702
	jr _label_15_052		; $4704
	ld a,$08		; $4706
	jr _label_15_052		; $4708
	ld a,$10		; $470a
	jr _label_15_052		; $470c
	ld a,$18		; $470e
_label_15_052:
	ld e,$49		; $4710
	ld (de),a		; $4712
	jr _label_15_050		; $4713
_label_15_053:
	ld e,$58		; $4715
	ld a,l			; $4717
	ld (de),a		; $4718
	inc e			; $4719
	ld a,h			; $471a
	ld (de),a		; $471b
	ret			; $471c
.DB $d3				; $471d
	ld c,b			; $471e
.DB $ed				; $471f
	ld c,b			; $4720
	rst $30			; $4721
	ld c,b			; $4722
	dec (hl)		; $4723
	ld b,a			; $4724
	dec (hl)		; $4725
	ld b,a			; $4726
	dec (hl)		; $4727
	ld b,a			; $4728
	and c			; $4729
	ld b,a			; $472a
	ret			; $472b
	ld b,a			; $472c
	dec (hl)		; $472d
	ld b,a			; $472e
	rst $20			; $472f
	ld b,a			; $4730
	ld b,c			; $4731
	ld c,b			; $4732
	or a			; $4733
	ld c,b			; $4734
	ld b,e			; $4735
	ld b,a			; $4736
	ld d,c			; $4737
	ld b,a			; $4738
	ld e,a			; $4739
	ld b,a			; $473a
	ld l,l			; $473b
	ld b,a			; $473c
	ld a,l			; $473d
	ld b,a			; $473e
	adc c			; $473f
	ld b,a			; $4740
	sub l			; $4741
	ld b,a			; $4742
	nop			; $4743
	stop			; $4744
	dec bc			; $4745
	ld b,b			; $4746
	nop			; $4747
	stop			; $4748
	add hl,bc		; $4749
	and b			; $474a
	nop			; $474b
	stop			; $474c
	dec bc			; $474d
	and b			; $474e
	inc b			; $474f
	rst $30			; $4750
	nop			; $4751
	stop			; $4752
	ld ($0040),sp		; $4753
	stop			; $4756
	ld a,(bc)		; $4757
	and b			; $4758
	nop			; $4759
	stop			; $475a
	ld ($04a0),sp		; $475b
	rst $30			; $475e
	nop			; $475f
	stop			; $4760
	add hl,bc		; $4761
	ld b,b			; $4762
	nop			; $4763
	stop			; $4764
	dec bc			; $4765
	and b			; $4766
	nop			; $4767
	stop			; $4768
	add hl,bc		; $4769
	and b			; $476a
	inc b			; $476b
	rst $30			; $476c
	inc bc			; $476d
	jr z,_label_15_054	; $476e
_label_15_054:
	jr nz,_label_15_055	; $4770
	ld b,b			; $4772
	nop			; $4773
	jr nz,_label_15_056	; $4774
	ld d,b			; $4776
	nop			; $4777
	jr nz,_label_15_057	; $4778
	ld d,b			; $477a
	inc b			; $477b
	rst $30			; $477c
_label_15_055:
	add hl,bc		; $477d
	ret nz			; $477e
_label_15_056:
	nop			; $477f
	stop			; $4780
	dec bc			; $4781
	ld ($ff00+$00),a	; $4782
	stop			; $4784
_label_15_057:
	add hl,bc		; $4785
	ld ($ff00+$04),a	; $4786
	rst $30			; $4788
	dec bc			; $4789
	ld d,b			; $478a
	nop			; $478b
	stop			; $478c
	add hl,bc		; $478d
	ld ($ff00+$00),a	; $478e
	stop			; $4790
	dec bc			; $4791
	ld ($ff00+$04),a	; $4792
	rst $30			; $4794
	add hl,bc		; $4795
	ld d,b			; $4796
	nop			; $4797
	stop			; $4798
	dec bc			; $4799
	ld ($ff00+$00),a	; $479a
	stop			; $479c
	add hl,bc		; $479d
	ld ($ff00+$04),a	; $479e
	rst $30			; $47a0
	and a			; $47a1
	ld b,a			; $47a2
	or e			; $47a3
	ld b,a			; $47a4
	cp a			; $47a5
	ld b,a			; $47a6
	add hl,bc		; $47a7
	ld b,b			; $47a8
	nop			; $47a9
	jr nz,$0b		; $47aa
	add b			; $47ac
	nop			; $47ad
	jr nz,_label_15_058	; $47ae
	add b			; $47b0
	inc b			; $47b1
	rst $30			; $47b2
	ld a,(bc)		; $47b3
	ld h,b			; $47b4
	nop			; $47b5
	ld ($c008),sp		; $47b6
_label_15_058:
	nop			; $47b9
	ld ($c00a),sp		; $47ba
	inc b			; $47bd
	rst $30			; $47be
	dec bc			; $47bf
	ld h,b			; $47c0
	nop			; $47c1
	jr nz,_label_15_060	; $47c2
	ld h,b			; $47c4
	nop			; $47c5
	jr nz,_label_15_059	; $47c6
	rst $30			; $47c8
	bit 0,a			; $47c9
	inc bc			; $47cb
_label_15_059:
	ld d,b			; $47cc
_label_15_060:
	nop			; $47cd
	inc a			; $47ce
	dec bc			; $47cf
	jr nc,_label_15_061	; $47d0
	jr c,_label_15_063	; $47d2
	jr z,_label_15_064	; $47d4
	jr c,$09		; $47d6
	jr z,_label_15_065	; $47d8
_label_15_061:
	jr c,_label_15_066	; $47da
	jr z,_label_15_062	; $47dc
_label_15_062:
	inc a			; $47de
_label_15_063:
	ld a,(bc)		; $47df
_label_15_064:
	jr _label_15_067		; $47e0
_label_15_065:
	ld ($200a),sp		; $47e2
_label_15_066:
	inc b			; $47e5
	rst $20			; $47e6
	ei			; $47e7
	ld b,a			; $47e8
	dec b			; $47e9
	ld c,b			; $47ea
_label_15_067:
	rrca			; $47eb
	ld c,b			; $47ec
	rrca			; $47ed
	ld c,b			; $47ee
	add hl,de		; $47ef
	ld c,b			; $47f0
	inc hl			; $47f1
	ld c,b			; $47f2
	dec l			; $47f3
	ld c,b			; $47f4
	dec l			; $47f5
	ld c,b			; $47f6
	scf			; $47f7
	ld c,b			; $47f8
	dec sp			; $47f9
	ld c,b			; $47fa
	add hl,bc		; $47fb
	ld h,b			; $47fc
	nop			; $47fd
	stop			; $47fe
	dec bc			; $47ff
	ld h,b			; $4800
	nop			; $4801
	stop			; $4802
	inc b			; $4803
	rst $30			; $4804
	ld a,(bc)		; $4805
	add b			; $4806
	nop			; $4807
	stop			; $4808
	ld ($0080),sp		; $4809
	stop			; $480c
	inc b			; $480d
	rst $30			; $480e
	ld ($0020),sp		; $480f
	stop			; $4812
	ld a,(bc)		; $4813
	jr nz,_label_15_068	; $4814
_label_15_068:
	stop			; $4816
	inc b			; $4817
	rst $30			; $4818
	ld (jpHl),sp		; $4819
	stop			; $481c
	ld a,(bc)		; $481d
	and b			; $481e
	nop			; $481f
	stop			; $4820
	inc b			; $4821
	rst $30			; $4822
	ld ($00c0),sp		; $4823
	stop			; $4826
	ld a,(bc)		; $4827
	ret nz			; $4828
	nop			; $4829
	stop			; $482a
	inc b			; $482b
	rst $30			; $482c
	dec bc			; $482d
	ld h,b			; $482e
	nop			; $482f
	stop			; $4830
	add hl,bc		; $4831
	ld h,b			; $4832
	nop			; $4833
	stop			; $4834
	inc b			; $4835
	rst $30			; $4836
	ld a,(bc)		; $4837
	ld ($ff00+$00),a	; $4838
	stop			; $483a
	ld ($00e0),sp		; $483b
	stop			; $483e
	inc b			; $483f
	rst $30			; $4840
	ld c,l			; $4841
	ld c,b			; $4842
	ld (hl),c		; $4843
	ld c,b			; $4844
	ld a,e			; $4845
	ld c,b			; $4846
	adc a			; $4847
	ld c,b			; $4848
	sbc e			; $4849
	ld c,b			; $484a
	xor l			; $484b
	ld c,b			; $484c
	inc bc			; $484d
	ld d,b			; $484e
	nop			; $484f
	inc a			; $4850
	ld a,(bc)		; $4851
	jr nz,$0b		; $4852
	ld c,b			; $4854
	ld ($0920),sp		; $4855
	jr _label_15_069		; $4858
	ld ($1809),sp		; $485a
	ld ($0018),sp		; $485d
	jr z,_label_15_070	; $4860
	jr $0b			; $4862
_label_15_069:
	jr $08			; $4864
	ld (makeActiveObjectFollowLink),sp		; $4866
	ld a,(bc)		; $4869
	jr nz,_label_15_071	; $486a
_label_15_070:
	ld c,b			; $486c
	ld ($0420),sp		; $486d
	rst_addDoubleIndex			; $4870
	nop			; $4871
	ld ($8009),sp		; $4872
_label_15_071:
	nop			; $4875
	ld ($800b),sp		; $4876
	inc b			; $4879
	rst $30			; $487a
	inc bc			; $487b
	ld d,b			; $487c
	nop			; $487d
	ld ($380b),sp		; $487e
	nop			; $4881
	ld ($3008),sp		; $4882
	nop			; $4885
	ld ($3809),sp		; $4886
	nop			; $4889
	ld ($300a),sp		; $488a
	inc b			; $488d
	rst $28			; $488e
	ld a,(bc)		; $488f
	ld h,b			; $4890
	nop			; $4891
	ld ($8008),sp		; $4892
	nop			; $4895
	ld ($800a),sp		; $4896
	inc b			; $4899
	rst $30			; $489a
	nop			; $489b
	ld ($a00b),sp		; $489c
	nop			; $489f
	ld ($a008),sp		; $48a0
	nop			; $48a3
	ld ($a009),sp		; $48a4
	nop			; $48a7
	ld ($a00a),sp		; $48a8
	inc b			; $48ab
	rst $28			; $48ac
	nop			; $48ad
	ld ($8008),sp		; $48ae
	nop			; $48b1
	ld ($800a),sp		; $48b2
	inc b			; $48b5
	rst $30			; $48b6
	cp a			; $48b7
	ld c,b			; $48b8
	ret			; $48b9
	ld c,b			; $48ba
	cp a			; $48bb
	ld c,b			; $48bc
	ret			; $48bd
	ld c,b			; $48be
	add hl,bc		; $48bf
	ld ($ff00+$00),a	; $48c0
	stop			; $48c2
	dec bc			; $48c3
	ld ($ff00+$00),a	; $48c4
	stop			; $48c6
	inc b			; $48c7
	rst $30			; $48c8
	dec bc			; $48c9
	ld ($ff00+$00),a	; $48ca
	stop			; $48cc
	add hl,bc		; $48cd
	ld ($ff00+$00),a	; $48ce
	stop			; $48d0
	inc b			; $48d1
	rst $30			; $48d2
	inc bc			; $48d3
	ld d,b			; $48d4
	nop			; $48d5
	inc a			; $48d6
	dec bc			; $48d7
	inc e			; $48d8
	nop			; $48d9
	rrca			; $48da
	ld ($0030),sp		; $48db
	rrca			; $48de
	add hl,bc		; $48df
	jr c,_label_15_072	; $48e0
_label_15_072:
	rrca			; $48e2
	ld a,(bc)		; $48e3
	jr nc,_label_15_073	; $48e4
_label_15_073:
	rrca			; $48e6
	dec bc			; $48e7
	inc e			; $48e8
	nop			; $48e9
	inc a			; $48ea
	inc b			; $48eb
	jp hl			; $48ec
	nop			; $48ed
	ld ($4009),sp		; $48ee
	nop			; $48f1
	ld ($400b),sp		; $48f2
	inc b			; $48f5
	rst $30			; $48f6
	nop			; $48f7
	ld ($400b),sp		; $48f8
	nop			; $48fb
	ld ($4009),sp		; $48fc
	inc b			; $48ff
	rst $30			; $4900
	call objectGetPosition		; $4901
	ld a,$ff		; $4904
	jp createEnergySwirlGoingIn		; $4906
	ld a,$01		; $4909
	ld ($cd2d),a		; $490b
	ret			; $490e
	call getFreeInteractionSlot		; $490f
	ld bc,$2c00		; $4912
	ld (hl),$60		; $4915
	inc l			; $4917
	ld (hl),b		; $4918
	inc l			; $4919
	ld (hl),c		; $491a
	ld l,$4b		; $491b
	ld a,($d00b)		; $491d
	ldi (hl),a		; $4920
	inc l			; $4921
	ld a,($d00d)		; $4922
	ld (hl),a		; $4925
	ret			; $4926
	ld ($cbd3),a		; $4927
	ld a,$01		; $492a
	ld ($cca4),a		; $492c
	ld a,$04		; $492f
	jp openMenu		; $4931
	ld a,$02		; $4934
	jp openSecretInputMenu		; $4936
	ld a,$31		; $4939
	call setGlobalFlag		; $493b
	ld bc,$0002		; $493e
	jp secretFunctionCaller		; $4941
	ld e,$44		; $4944
	ld a,$05		; $4946
	ld (de),a		; $4948
	xor a			; $4949
	inc e			; $494a
	ld (de),a		; $494b
	ld b,$03		; $494c
	call secretFunctionCaller		; $494e
	call serialFunc_0c85		; $4951
	ld a,($cba5)		; $4954
	ld e,$79		; $4957
	ld (de),a		; $4959
	ld bc,$300e		; $495a
	or a			; $495d
	jr z,_label_15_074	; $495e
	ld e,$45		; $4960
	ld a,$03		; $4962
	ld (de),a		; $4964
	ld bc,$3028		; $4965
_label_15_074:
	jp showText		; $4968
	ld a,$00		; $496b
	call $498d		; $496d
	jr nz,_label_15_076	; $4970
	ld a,$01		; $4972
	call $498d		; $4974
	jr nz,_label_15_076	; $4977
	ld a,$02		; $4979
	call $498d		; $497b
	jr nz,_label_15_076	; $497e
	ld a,$03		; $4980
_label_15_075:
	ld e,$7b		; $4982
	ld (de),a		; $4984
	ret			; $4985
_label_15_076:
	ld e,$7a		; $4986
	ld (de),a		; $4988
	sub $34			; $4989
	jr _label_15_075		; $498b
	ld c,a			; $498d
	call checkGlobalFlag		; $498e
	jr z,_label_15_077	; $4991
	ld a,c			; $4993
	add $04			; $4994
	ld c,a			; $4996
	call checkGlobalFlag		; $4997
	jr nz,_label_15_077	; $499a
	ld a,c			; $499c
	call setGlobalFlag		; $499d
	ld a,c			; $49a0
	add $30			; $49a1
	ret			; $49a3
_label_15_077:
	xor a			; $49a4
	ret			; $49a5
	ld a,$00		; $49a6
	jr _label_15_078		; $49a8
	ld a,$38		; $49aa
	jr _label_15_078		; $49ac
	ld e,$7a		; $49ae
	ld a,(de)		; $49b0
_label_15_078:
	ld b,a			; $49b1
	ld c,$00		; $49b2
	jp giveRingToLink		; $49b4
	xor a			; $49b7
	ld ($c63e),a		; $49b8
	inc a			; $49bb
	ld ($c614),a		; $49bc
	ld a,$28		; $49bf
	jp setGlobalFlag		; $49c1

	.include "code/seasons/interactionCode/bank15.s"
	.include "data/seasons/partAnimations.s"


.BANK $16 SLOT 1
.ORG 0

	.include "build/data/paletteData.s"
	.include "build/data/tilesetCollisions.s"
	.include "build/data/smallRoomLayoutTables.s"

.BANK $17 SLOT 1
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
.ends

.BANK $18 SLOT 1
.ORG 0

	.include "build/data/largeRoomLayoutTables.s"

	m_GfxDataSimple gfx_animations_1
	m_GfxDataSimple gfx_animations_2
	m_GfxDataSimple gfx_animations_3
	m_GfxDataSimple gfx_063940

	; Compressed graphics file, for some reason doesn't go in gfxDataMain.s.
	m_GfxDataSimple gfx_credits_sprites_2


.BANK $19 SLOT 1
.ORG 0

 m_section_superfree "Tile_mappings"
	.include "build/data/tilesetMappings.s"
.ends


.BANK $1a SLOT 1
.ORG 0
	.include "data/gfxDataBank1a.s"


.BANK $1b SLOT 1
.ORG 0
	.include "data/gfxDataBank1b.s"


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

	; TODO: where does "build/data/largeRoomLayoutTables.s" go?


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
.include "code/seasons/interactionCode/interactionCode11_body.s"

.include "build/data/objectGfxHeaders.s"
.include "build/data/treeGfxHeaders.s"

.include "build/data/enemyData.s"
.include "build/data/partData.s"
.include "build/data/itemData.s"
.include "build/data/interactionData.s"

.include "build/data/treasureCollectionBehaviours.s"
.include "build/data/treasureDisplayData.s"

.ends
