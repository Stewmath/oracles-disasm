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
.ifdef ROM_AGES
	ld hl,w1Link.var2f		; $400e
	ld a,(hl)		; $4011
	and $3f			; $4012
	ld (hl),a		; $4014

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
.ifdef ROM_AGES
	ld (wDisallowMountingCompanion),a		; $404a
.endif

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
.ifdef ROM_AGES
	.dw  specialObjectCode_transformedLink
.else
	.dw specialObjectCode_05_7cda
.endif
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
.ifdef ROM_AGES
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
.endif

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

.ifdef ROM_AGES
	ld (wLinkRaisedFloorOffset),a		; $42c2
.endif
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
.ifdef ROM_AGES
	.dw @tiletype_raisableFloor ; TILETYPE_RAISABLE_FLOOR
	.dw @swimming ; TILETYPE_SEAWATER
	.dw @swimming ; TILETYPE_WHIRLPOOL

@tiletype_raisableFloor:
	ld a,-3		; $42fe
	ld (wLinkRaisedFloorOffset),a		; $4300
.endif

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
.ifdef ROM_AGES
	ld a,(wTilesetFlags)		; $4355
	and TILESETFLAG_UNDERWATER			; $4358
	jr nz,@tileType_normal	; $435a
.endif

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
.ifdef ROM_AGES
	ret			; $4394
.else
	ld a,(wStandingOnTileCounter)		; $433d
	cp $20			; $4340
	jr c,@tileType_ice	; $4342
	ld a,(wActiveTilePos)		; $4344
	ld c,a			; $4347
	ld a,$fd		; $4348
	call setTile		; $434a
.endif

@swimming:
	ld a,(wLinkRidingObject)		; $4395
	or a			; $4398
	jp nz,@tileType_normal		; $4399

	; Run the below code only the moment he gets into the water
	ld a,(wLinkSwimmingState)		; $439c
	or a			; $439f
	ret nz			; $43a0

.ifdef ROM_AGES
	ld a,(w1Link.var2f)		; $43a1
	bit 7,a			; $43a4
	ret nz			; $43a6
.endif

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
.ifdef ROM_AGES
	ld a,(wLinkRidingObject)		; $43b8
	or a			; $43bb
.else
	ld a,(wMagnetGloveState)
	bit 6,a
.endif
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
.ifdef ROM_SEASONS
	cp $d9			; $4493
	ret z			; $4495
	cp $da			; $4496
	ret z			; $4498
.endif
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
.ifdef ROM_AGES
	ld a,(wDisallowMountingCompanion)		; $45a0
	or a			; $45a3
	jr nz,@cantMount	; $45a4

	call checkLinkVulnerableAndIDZero		; $45a6
.else
	call checkLinkID0AndControlNormal		; $4559
.endif
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
.ifdef ROM_AGES
@moosh:
	jr @normalDismount		; $4620
@ricky:
	jr @normalDismount		; $4622
@dimitri:
	jr @normalDismount		; $4624
.else
@moosh:
	ld a,(wEssencesObtained)		; $45d3
	bit 4,a			; $45d6
	jr z,@normalDismount	; $45d8
	jr +		; $45da
@ricky:
	ld a,(wFluteIcon)		; $45dc
	or a			; $45df
	jr z,@normalDismount	; $45e0
	jr +		; $45e2
@dimitri:
	ld a,TREASURE_FLIPPERS		; $45e4
	call checkTreasureObtained		; $45e6
	jr nc,@normalDismount	; $45e9
+
.endif
	; Seasons-only (dismount and don't save companion's position)
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
.ifdef ROM_SEASONS
	ld bc,$0500		; $46b8
	call objectGetRelativeTile		; $46bb
	cp $20			; $46be
	jr nz,+	; $46c0
	ld h,d			; $46c2
	ld l,$0b		; $46c3
	ld a,(wRememberedCompanionY)		; $46c5
	ldi (hl),a		; $46c8
	inc l			; $46c9
	ld a,(wRememberedCompanionX)		; $46ca
	ldi (hl),a		; $46cd
+
.endif
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

.ifdef ROM_AGES
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
.endif

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
.ifdef ROM_AGES
	ld a,(wDisallowMountingCompanion)		; $48c1
	or a			; $48c4
	jr nz,@stopMounting	; $48c5
.endif
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
.ifdef ROM_AGES
	cp TILEINDEX_PUDDLE			; $4924
	jr nz,@label_05_067	; $4926
.else
	cp TILEINDEX_PUDDLE			; $48d5
	jr z,+					; $48d7
	cp TILEINDEX_PUDDLE+1			; $48d9
	jr z,+					; $48db
	cp TILEINDEX_PUDDLE+2			; $48dd
	jr nz,@label_05_067			; $48df
+
.endif

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
.ifdef ROM_AGES
	.dw _warpTransitionA
.else
	.dw _warpTransition7
.endif
	.dw _warpTransition8
	.dw _warpTransition9
	.dw _warpTransitionA
	.dw _warpTransitionB
	.dw _warpTransitionC
	.dw _warpTransitionA
	.dw _warpTransitionE
	.dw _warpTransitionF

;;
; @addr{4a4c}
_warpTransition0:
	call _warpTransition_setLinkFacingDir		; $4a4c
;;
; @addr{4a4f}
_warpTransitionA:
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

.ifdef ROM_AGES
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
.else
@collisions3:
	.db $36 DIR_UP		; $4a4d
@collisions4:
@collisions5:
	.db $44 DIR_LEFT
	.db $45 DIR_RIGHT
@collisions0:
@collisions1:
@collisions2:
	.db $00		; $4a53
.endif

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
.ifdef ROM_SEASONS
	call objectGetTileAtPosition		; $4b63
	cp $07			; $4b66
	jr z,+	; $4b68
.endif
	ld hl,hazardCollisionTable		; $4baa
	call lookupCollisionTable		; $4bad
	jp nc,_warpTransition7@label_4c05		; $4bb0
	jp _initLinkStateAndAnimateStanding		; $4bb3
.ifdef ROM_SEASONS
+
	ld a,(wActiveGroup)		; $4b76
	and $06			; $4b79
	cp $04			; $4b7b
	jp nz,_warpTransition7@label_4c05		; $4b7d
	; group 4/5
	jp seasonsFunc_05_50a5		; $4b80
.endif

.ifdef ROM_SEASONS
_warpTransition6:
	ld e,$05		; $4b83
	ld a,(de)		; $4b85
	rst_jumpTable			; $4b86
	.dw $4b8b
	.dw $4bb5

	ld a,$01		; $4b8b
	ld (de),a		; $4b8d

	ld a,(wcc50)		; $4b8e
	bit 7,a			; $4b91
	jr z,+	; $4b93
	rrca			; $4b95
	and $0f			; $4b96
	ld ($cc6b),a		; $4b98
	ld a,$09		; $4b9b
	jp linkSetState		; $4b9d
+
	ld bc,$fd00		; $4ba0
	call objectSetSpeedZ		; $4ba3
	ld l,$06		; $4ba6
	ld (hl),$78		; $4ba8
	ld l,$0b		; $4baa
	ld a,(hl)		; $4bac
	sub $04			; $4bad
	ld (hl),a		; $4baf
	ld a,$04		; $4bb0
	call specialObjectSetAnimation		; $4bb2

	ld c,$18		; $4bb5
	call objectUpdateSpeedZ_paramC		; $4bb7
	jr z,_label_05_079	; $4bba
	call specialObjectAnimate		; $4bbc
	call $5d53		; $4bbf
	ld e,$10		; $4bc2
	ld a,$14		; $4bc4
	ld (de),a		; $4bc6
	ld a,($cc47)		; $4bc7
	ld e,$09		; $4bca
	ld (de),a		; $4bcc
	call updateLinkDirectionFromAngle		; $4bcd
	jp specialObjectUpdatePosition		; $4bd0
_label_05_079:
	call objectGetTileAtPosition		; $4bd3
	cp $07			; $4bd6
	jp z,seasonsFunc_05_50a5		; $4bd8
	jp _initLinkStateAndAnimateStanding		; $4bdb
.endif


;;
; Used only in Seasons
; @addr{4bb6}
_warpTransition7:
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

.ifdef ROM_AGES
	call itemIncState2		; $4d6c
	call _animateLinkStanding		; $4d6f
	ld a,SND_SPLASH		; $4d72
	jp playSound		; $4d74
.else
	xor a			; $4d94
	ld (wDisabledObjects),a		; $4d95
	ld a,$08		; $4d98
	call setLinkIDOverride		; $4d9a
	ld l,$02		; $4d9d
	ld (hl),$02		; $4d9f
	ret			; $4da1
.endif

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

.ifdef ROM_AGES
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
	ld a,SND_TIMEWARP_COMPLETED		; $4e42
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
	ld a,SND_TIMEWARP_COMPLETED		; $4f01
	call playSound		; $4f03

	ld de,w1Link		; $4f06
	jp objectDelete_de		; $4f09
.endif

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

.ifdef ROM_AGES
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
.endif

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
	ld (wcc52),a		; $5007

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
	ld a,(wcc52)		; $5028
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
.else
	; start CUTSCENE_S_ONOX_FINAL_FORM
	ld a,(wDungeonIndex)		; $4f3c
	cp $09			; $4f3f
	jr nz,+			; $4f41
	ld a,$13		; $4f43
	ld (wCutsceneTrigger),a		; $4f45
	ret			; $4f48
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

.ifdef ROM_AGES
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
.endif

.ifdef ROM_SEASONS
_linkState09:
	call retIfTextIsActive		; $4fc4
	ld e,SpecialObject.state2		; $4fc7
	ld a,(de)		; $4fc9
	rst_jumpTable			; $4fca
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

@substate0:
	call clearAllParentItems		; $4fd9
	xor a			; $4fdc
	ld (wScrollMode),a		; $4fdd
	ld (wUsingShield),a		; $4fe0
	ld bc,$fc00		; $4fe3
	call objectSetSpeedZ		; $4fe6
	ld l,$06		; $4fe9
	ld (hl),$0a		; $4feb
	ld a,(wcc50)		; $4fed
	rrca			; $4ff0
	ld a,$01		; $4ff1
	jr nc,+			; $4ff3
	inc a			; $4ff5
+
	ld l,$05		; $4ff6
	ld (hl),a		; $4ff8
	ld a,$81		; $4ff9
	ld (wLinkInAir),a		; $4ffb
	ret			; $4ffe

@substate1:
	call @seasonsFunc_05_5043		; $4fff
	ret c			; $5002
	ld a,(wDungeonFloor)		; $5003
	inc a			; $5006
	ld (wDungeonFloor),a		; $5007
	call getActiveRoomFromDungeonMapPosition		; $500a
	ld (wWarpDestRoom),a		; $500d
	call objectGetShortPosition		; $5010
	ld (wWarpDestPos),a		; $5013
	ld a,(wActiveGroup)		; $5016
	or $80			; $5019
	ld (wWarpDestGroup),a		; $501b
	ld a,$06		; $501e
	ld (wWarpTransition),a		; $5020
	ld a,$03		; $5023
	ld (wWarpTransition2),a		; $5025
	ret			; $5028
@substate2:
	call @seasonsFunc_05_5043		; $5029
	ret c			; $502c
	ld a,$01		; $502d
	ld (wScrollMode),a		; $502f
	ld l,$05		; $5032
	inc (hl)		; $5034
	ld l,$06		; $5035
	ld (hl),$1e		; $5037
	ld a,$08		; $5039
	call setScreenShakeCounter		; $503b
	ld a,$02		; $503e
	jp specialObjectSetAnimation		; $5040

@seasonsFunc_05_5043:
	ld c,$0c		; $5043
	call objectUpdateSpeedZ_paramC		; $5045
	call specialObjectAnimate		; $5048
	ld h,d			; $504b
	ld l,$06		; $504c
	ld a,(hl)		; $504e
	or a			; $504f
	jr z,+	; $5050
	dec (hl)		; $5052
	jr nz,+	; $5053
	ld a,$04		; $5055
	call specialObjectSetAnimation		; $5057
+
	call objectGetZAboveScreen		; $505a
	ld h,d			; $505d
	ld l,$0f		; $505e
	cp (hl)			; $5060
	ret			; $5061

@substate3:
	call itemDecCounter1		; $5062
	ret nz			; $5065
	dec l			; $5066
	inc (hl)		; $5067
	ld bc,$ff00		; $5068
	jp objectSetSpeedZ		; $506b

@substate4:
	ld c,$20		; $506e
	call objectUpdateSpeedZ_paramC		; $5070
	ret nz			; $5073
	call objectGetTileAtPosition		; $5074
	cp $07			; $5077
	jr z,seasonsFunc_05_50a5	; $5079
	ld h,d			; $507b
	ld l,$05		; $507c
	inc (hl)		; $507e
	inc l			; $507f
	ld (hl),$1e		; $5080
	ld a,$02		; $5082
	call specialObjectSetAnimation		; $5084

@substate5:
	call itemDecCounter1		; $5087
	ret nz			; $508a
-
	xor a			; $508b
	ld (wLinkInAir),a		; $508c
	jp _initLinkStateAndAnimateStanding		; $508f

@substate6:
	call specialObjectAnimate		; $5092
	call _specialObjectUpdateAdjacentWallsBitset		; $5095
	ld c,$20		; $5098
	call objectUpdateSpeedZ_paramC		; $509a
	jp nz,specialObjectUpdatePosition		; $509d
	call updateLinkLocalRespawnPosition		; $50a0
	jr -		; $50a3

seasonsFunc_05_50a5:
	call objectGetShortPosition		; $50a5
	ld c,a			; $50a8
	ld b,$02		; $50a9
-
	ld a,b			; $50ab
	ld hl,seasonsTable_05_50e4		; $50ac
	rst_addAToHl			; $50af
	ld a,c			; $50b0
	add (hl)		; $50b1
	ld h,$ce		; $50b2
	ld l,a			; $50b4
	ld a,(hl)		; $50b5
	or a			; $50b6
	jr z,+	; $50b7
	ld a,b			; $50b9
	inc a			; $50ba
	and $03			; $50bb
	ld b,a			; $50bd
	jr -		; $50be
+
	ld h,d			; $50c0
	ld l,$08		; $50c1
	ld (hl),b		; $50c3
	ld a,b			; $50c4
	swap a			; $50c5
	rrca			; $50c7
	inc l			; $50c8
	ld (hl),a		; $50c9
	ld l,$0f		; $50ca
	ld (hl),$ff		; $50cc
	ld bc,$fd00		; $50ce
	call objectSetSpeedZ		; $50d1
	ld l,$10		; $50d4
	ld (hl),$14		; $50d6
	ld l,$04		; $50d8
	ld (hl),$09		; $50da
	inc l			; $50dc
	ld (hl),$06		; $50dd
	ld a,$04		; $50df
	jp specialObjectSetAnimation		; $50e1

seasonsTable_05_50e4:
	.db $f0 $01 $10 $ff
.endif

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

.ifdef ROM_AGES
	ld a,PALH_7f		; $5240
.else
	ld a,SEASONS_PALH_7f		; $5240
.endif
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

.ifdef ROM_AGES
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
.else
	ld a,$e8		; $51c2
	ld l,SpecialObject.zh		; $51c4
	ld (hl),a		; $51c6
	ld l,SpecialObject.yh		; $51c7
	cpl			; $51c9
	inc a			; $51ca
	add (hl)		; $51cb
	ld (hl),a		; $51cc
	xor a			; $51cd
	ld l,SpecialObject.speedZ		; $51ce
	ldi (hl),a		; $51d0
	ldi (hl),a		; $51d1
	ld l,SpecialObject.direction		; $51d2
	ldi (hl),a		; $51d4
	; angle
	ld (hl),$0c		; $51d5
.endif

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
.ifdef ROM_AGES
	ld l,$18		; $530c
.else
	ld l,$13		; $530c
.endif
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
.ifdef ROM_AGES
	ld (hl),DIR_LEFT		; $5366
.else
	ld (hl),DIR_RIGHT		; $5366
.endif

	; [SpecialObject.angle] = $18
	inc l			; $5368
.ifdef ROM_AGES
	ld (hl),$18		; $5369
.else
	ld (hl),$08		; $5369
.endif

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

.ifdef ROM_AGES
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

.else

_linkState0f:
	ld e,$05		; $52ee
	ld a,(de)		; $52f0
	rst_jumpTable			; $52f1
	cp $52			; $52f2
	ld d,$53		; $52f4
	add hl,hl		; $52f6
	ld d,e			; $52f7
	ld b,h			; $52f8
	ld d,e			; $52f9
	add a			; $52fa
	ld d,e			; $52fb
	sbc c			; $52fc
	ld d,e			; $52fd
	ld h,d			; $52fe
	ld l,e			; $52ff
	inc (hl)		; $5300
	inc l			; $5301
	ld (hl),$10		; $5302
	xor a			; $5304
	ld l,$08		; $5305
	ldi (hl),a		; $5307
	ld (hl),a		; $5308
	call linkCancelAllItemUsageAndClearAdjacentWallsBitset		; $5309
	ld a,$01		; $530c
	ld ($cbca),a		; $530e
	ld a,$10		; $5311
	call specialObjectSetAnimation		; $5313
	call itemDecCounter1		; $5316
	jr nz,_label_05_103	; $5319
	ld (hl),$5a		; $531b
	dec l			; $531d
	inc (hl)		; $531e
	ld l,$10		; $531f
	ld (hl),$14		; $5321
_label_05_103:
	call specialObjectAnimate		; $5323
	jp specialObjectUpdatePositionWithoutTileEdgeAdjust		; $5326
	ld h,d			; $5329
	ld l,$06		; $532a
	ld a,(hl)		; $532c
	or a			; $532d
	jr z,_label_05_104	; $532e
	dec (hl)		; $5330
	ret			; $5331
_label_05_104:
	ld h,d			; $5332
	ld l,$0b		; $5333
	ld a,(hl)		; $5335
	cp $74			; $5336
	jr nc,_label_05_103	; $5338
	ld l,$05		; $533a
	inc (hl)		; $533c
	inc l			; $533d
	ld (hl),$60		; $533e
	ld l,$10		; $5340
	ld (hl),$28		; $5342
	call itemDecCounter1		; $5344
	jr z,_label_05_106	; $5347
	ld a,(hl)		; $5349
	sub $19			; $534a
	jr c,_label_05_105	; $534c
	cp $32			; $534e
	ret nc			; $5350
	and $0f			; $5351
	ret nz			; $5353
	ld a,(hl)		; $5354
	swap a			; $5355
	and $01			; $5357
	add a			; $5359
	inc a			; $535a
	ld l,$08		; $535b
	ld (hl),a		; $535d
	ret			; $535e
_label_05_105:
	inc a			; $535f
	ret nz			; $5360
	ld l,$08		; $5361
	ld (hl),$00		; $5363
	inc l			; $5365
	ld (hl),$10		; $5366
	ld a,$18		; $5368
	ld bc,$f4f8		; $536a
	call objectCreateExclamationMark		; $536d
	ld a,$50		; $5370
	jp playSound		; $5372
_label_05_106:
	ld l,e			; $5375
	inc (hl)		; $5376
	ld bc,$fe80		; $5377
	call objectSetSpeedZ		; $537a
	ld a,$18		; $537d
	call specialObjectSetAnimation		; $537f
	ld a,$53		; $5382
	call playSound		; $5384
	ld c,$18		; $5387
	call objectUpdateSpeedZ_paramC		; $5389
	jr nz,_label_05_103	; $538c
	ld l,$05		; $538e
	inc (hl)		; $5390
	inc l			; $5391
	ld (hl),$f0		; $5392
	ld a,$10		; $5394
	call specialObjectSetAnimation		; $5396
	ld a,(wFrameCounter)		; $5399
	rrca			; $539c
	ret nc			; $539d
	call itemDecCounter1		; $539e
	ret nz			; $53a1
	xor a			; $53a2
	ld ($cbca),a		; $53a3
	jp _initLinkStateAndAnimateStanding		; $53a6

_linkState10:
	ld e,$05		; $53a9
	ld a,(de)		; $53ab
	rst_jumpTable			; $53ac
	or e			; $53ad
	ld d,e			; $53ae
	jp z,$fa53		; $53af
	ld d,e			; $53b2
	ld a,$01		; $53b3
	ld (de),a		; $53b5
	call $4df1		; $53b6
	call resetLinkInvincibility		; $53b9
	ld l,$10		; $53bc
	ld (hl),$14		; $53be
	ld l,$08		; $53c0
	ld (hl),$00		; $53c2
	inc l			; $53c4
	ld (hl),$00		; $53c5
	jp _animateLinkStanding		; $53c7
	call specialObjectAnimate		; $53ca
	ld h,d			; $53cd
	ld a,(wFrameCounter)		; $53ce
	and $07			; $53d1
	jr nz,_label_05_107	; $53d3
	ld l,$10		; $53d5
	ld a,(hl)		; $53d7
	sub $05			; $53d8
	jr z,_label_05_107	; $53da
	ld (hl),a		; $53dc
_label_05_107:
	ld a,($cbb3)		; $53dd
	cp $02			; $53e0
	jp nz,specialObjectUpdatePosition		; $53e2
	ld a,($cc03)		; $53e5
	dec a			; $53e8
	jp nz,_initLinkStateAndAnimateStanding		; $53e9
	ld l,$05		; $53ec
	inc (hl)		; $53ee
	inc l			; $53ef
	ld (hl),$20		; $53f0
	ld l,$09		; $53f2
	ld (hl),$10		; $53f4
	ld l,$10		; $53f6
	ld (hl),$50		; $53f8
	call specialObjectAnimate		; $53fa
	call itemDecCounter1		; $53fd
	jp nz,specialObjectUpdatePosition		; $5400
	ld hl,$cbb3		; $5403
	inc (hl)		; $5406
	ld a,$02		; $5407
	call fadeoutToWhiteWithDelay		; $5409
	jp _initLinkStateAndAnimateStanding		; $540c
.endif

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
.ifdef ROM_AGES
_linkState10:
.endif
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
.ifdef ROM_AGES
	cp SPECIALOBJECTID_RAFT			; $550d
	jr z,++			; $550f
.endif

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
.ifdef ROM_SEASONS
	call seasonsFunc_05_5e74		; $5516
.endif
	call _checkLinkJumpingOffCliff		; $5519
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
.ifdef  ROM_AGES
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
.else
	jr c,@updateDirection	; $5561
.endif
	; Check whether Link is wearing a transformation ring or is a baby
	callab bank6.getTransformedLinkID		; $55c8
	ld a,b			; $55d0
	or a			; $55d1
	jp nz,setLinkIDOverride		; $55d2

.ifdef ROM_AGES
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
.endif
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

.ifdef ROM_AGES
	; Set counter1 to the number of frames to stay in swimmingState2.
	; This is just a period of time during which Link's speed is locked immediately
	; after entering the water.
	ld l,SpecialObject.var2f		; $56b3
	bit 6,(hl)		; $56b5
.endif

	ld l,SpecialObject.counter1		; $56b7
	ld (hl),$0a		; $56b9

.ifdef ROM_AGES
	jr z,+			; $56bb
	ld (hl),$02		; $56bd
+
.endif

	ld a,(wLinkSwimmingState)		; $56bf
	bit 6,a			; $56c2
	jr nz,@drownWithLessInvincibility		; $56c4

.ifdef ROM_AGES
	call _checkSwimmingOverSeawater		; $56c6
	jr z,@drown		; $56c9
.endif

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

.ifdef ROM_AGES
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
.endif

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
.ifdef ROM_AGES
	call _checkSwimmingOverSeawater		; $5725
	jr z,_overworldSwimmingState1@drown		; $5728
.endif

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

.ifdef ROM_AGES
	; Check whether the flippers or the mermaid suit are in use
	ld h,d			; $5743
	ld l,SpecialObject.var2f		; $5744
	bit 6,(hl)		; $5746
	jr z,+			; $5748

	; Mermaid suit movement
	call _linkUpdateVelocity@mermaidSuit		; $574a
	jp specialObjectUpdatePosition		; $574d
+
.endif
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
.ifdef ROM_AGES
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
.endif

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

.ifdef ROM_AGES
	ld hl,w1Link.var2f		; $5887
	bit 6,(hl)		; $588a
	ld a,LINK_ANIM_MODE_SWIM_2D		; $588c
	jr z,++			; $588e

	set 7,(hl)		; $5890
	ld a,LINK_ANIM_MODE_MERMAID		; $5892
	jr ++			; $5894
.else
	ld a,LINK_ANIM_MODE_SWIM_2D		; $57d5
	jr ++			; $57d7
.endif


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

.ifdef ROM_AGES
	; Jump if Link does not have the mermaid suit (only flippers)
	ld l,SpecialObject.var2f		; $58c4
	bit 6,(hl)		; $58c6
	jr z,+			; $58c8

	; Mermaid suit movement
	call _linkUpdateVelocity@mermaidSuit		; $58ca
	jr ++			; $58cd
+
.endif
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
.ifdef ROM_AGES
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
.endif

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

.ifdef ROM_AGES
	; In water

	ld h,d			; $59c4
	ld l,SpecialObject.var2f		; $59c5
	bit 6,(hl)		; $59c7
	jr z,+			; $59c9
	set 7,(hl)		; $59cb
+
.endif
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
.ifdef ROM_AGES
	jr @landedOnGround		; $5c6e
.else
	ld a,(wActiveTileType)		; $5b5d
	cp TILETYPE_SS_LADDER			; $5b60
	jr nz,@notLanded	; $5b62
	ld a,$80 | DIR_DOWN		; $5b64
	ld (wScreenTransitionDirection),a		; $5b66
.endif

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
.ifdef ROM_AGES
	.db $00 $05 $2d $2d $2d $2d $2d $2d
.endif

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

.ifdef ROM_SEASONS
	ld a,(wActiveTileType)		; $5d5c
	sub $08			; $5d5f
	jr nz,+			; $5d61
	dec a			; $5d63
	jr +++			; $5d64
+
.endif

	ld h,d			; $5e6b
	ld l,SpecialObject.yh		; $5e6c
	ld b,(hl)		; $5e6e
	ld l,SpecialObject.xh		; $5e6f
	ld c,(hl)		; $5e71
	call calculateAdjacentWallsBitset		; $5e72

.ifdef ROM_AGES
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
.else
+++
	ld e,SpecialObject.adjacentWallsBitset		; $5e89
	ld (de),a		; $5e8b
	ret			; $5e8c
.endif

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

.ifdef ROM_AGES
	ld a,(wLinkRaisedFloorOffset)		; $5ebb
	or a			; $5ebe
	jr z,+			; $5ebf

	call @checkTileCollisionAt_allowRaisedFl		; $5ec1
	jr ++			; $5ec4
+
.endif
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

.ifdef ROM_AGES
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
.endif

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
.ifdef ROM_AGES
	ldbc $9e, $17		; $5fbb
	ld l,DIR_RIGHT		; $5fbe
.else
	ldbc $82, $14		; $5fbb
	ld l,DIR_LEFT		; $5fbe
.endif
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

.ifdef ROM_SEASONS
;;
; Pushing against tree stump
; @addr{5e74}
seasonsFunc_05_5e74:
	ld a,(wActiveTileType)		; $5e74
	cp TILETYPE_STUMP		; $5e77
	jp z,seasonsFunc_05_5ed3		; $5e79
	ld a,(wActiveGroup)		; $5e7c
	or a			; $5e7f
	ret nz			; $5e80
	ld a,(wLinkAngle)		; $5e81
	and $e7			; $5e84
	ret nz			; $5e86
	call checkLinkPushingAgainstWall		; $5e87
	ret nc			; $5e8a
	ld e,$08		; $5e8b
	ld a,(de)		; $5e8d
	ld hl,seasonsTable_05_5ebf		; $5e8e
	rst_addDoubleIndex			; $5e91
	ldi a,(hl)		; $5e92
	ld b,a			; $5e93
	ld c,(hl)		; $5e94
	call objectGetRelativeTile		; $5e95
	cp $20			; $5e98
	ret nz			; $5e9a
	ld a,$01		; $5e9b
	call _specialObjectSetVar37AndVar38		; $5e9d
	ld e,$08		; $5ea0
	ld a,(de)		; $5ea2
	ld l,a			; $5ea3
	add a			; $5ea4
	add l			; $5ea5
	ld hl,seasonsTable_05_5ec7		; $5ea6
	rst_addAToHl			; $5ea9
	ld e,$10		; $5eaa
	ldi a,(hl)		; $5eac
	ld (de),a		; $5ead
	inc e			; $5eae
	ld (de),a		; $5eaf
	ld e,$14		; $5eb0
	ldi a,(hl)		; $5eb2
	ld (de),a		; $5eb3
	inc e			; $5eb4
	ldi a,(hl)		; $5eb5
	ld (de),a		; $5eb6
	ld a,$81		; $5eb7
	ld (wLinkInAir),a		; $5eb9
	jp linkCancelAllItemUsage		; $5ebc

seasonsTable_05_5ebf:
	.db $f4 $00
	.db $00 $07
	.db $08 $00
	.db $00 $f8

seasonsTable_05_5ec7:
	.db $23 $40 $fe
	.db $14 $60 $fe
	.db $0f $40 $fe
	.db $14 $60 $fe


seasonsFunc_05_5ed3:
	ld a,(wLinkAngle)		; $5ed3
	ld c,a
	and $e7
	jr nz,++	; $5ed9
	ld a,c			; $5edb
	add a			; $5edc
	swap a			; $5edd
	ld hl,seasonsTable_05_5f27		; $5edf
	rst_addDoubleIndex			; $5ee2
	ldi a,(hl)		; $5ee3
	ld c,(hl)		; $5ee4
	ld h,d			; $5ee5
	ld l,$0b		; $5ee6
	add (hl)		; $5ee8
	ld b,a			; $5ee9
	ld l,$0d		; $5eea
	ld a,(hl)		; $5eec
	add c			; $5eed
	ld c,a			; $5eee
	call checkTileCollisionAt_allowHoles		; $5eef
	jr c,++	; $5ef2
	ld a,(wLinkAngle)		; $5ef4
	ld e,$09		; $5ef7
	ld (de),a		; $5ef9
	add a			; $5efa
	swap a			; $5efb
	ld c,a			; $5efd
	add a			; $5efe
	add c			; $5eff
	ld hl,seasonsTable_05_5f2f		; $5f00
	rst_addAToHl			; $5f03
	ld a,(wLinkTurningDisabled)		; $5f04
	or a			; $5f07
	jr nz,+	; $5f08
	ld e,$08		; $5f0a
	ld a,c			; $5f0c
	ld (de),a		; $5f0d
+
	ld e,$10		; $5f0e
	ldi a,(hl)		; $5f10
	ld (de),a		; $5f11
	inc e			; $5f12
	ld (de),a		; $5f13
	ld e,$14		; $5f14
	ldi a,(hl)		; $5f16
	ld (de),a		; $5f17
	inc e			; $5f18
	ldi a,(hl)		; $5f19
	ld (de),a		; $5f1a
	call _label_05_234		; $5f1b
	ld a,$81		; $5f1e
	ld (wLinkInAir),a		; $5f20
	xor a			; $5f23
	ret			; $5f24
++
	or d			; $5f25
	ret			; $5f26

seasonsTable_05_5f27:
	.db $fb $00
	.db $00 $09
	.db $1b $00
	.db $00 $f6

seasonsTable_05_5f2f:
	.db $0f $60 $fe
	.db $14 $60 $fe
	.db $1e $40 $fe
	.db $14 $60 $fe
.endif

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
.ifdef ROM_SEASONS
	ld a,(wActiveTileType)		; $5f89
	cp TILETYPE_STUMP			; $5f8c
	ret z			; $5f8e
.endif

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

.ifdef ROM_SEASONS
	ldh a,(<hFF8B)	; $5fc4
	cp $05			; $5fc6
	jr z,@setSpeed140	; $5fc8
	cp $06			; $5fca
	jr z,@setSpeed140	; $5fcc
.endif

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

.ifdef ROM_AGES
	; Set jumping animation if not underwater
	ld l,SpecialObject.var2f		; $60b4
	bit 7,(hl)		; $60b6
	jr nz,++		; $60b8
.endif

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

.ifdef ROM_SEASONS
	ld a,(wActiveGroup)		; $6083
	or a			; $6086
	jr nz,+			; $6087
	ld bc,$0500		; $6089
	call objectGetRelativeTile		; $608c
	cp $20			; $608f
	jr nz,+			; $6091
	call objectCenterOnTile		; $6093
	ld l,SpecialObject.yh		; $6096
	ld a,(hl)		; $6098
	sub $06			; $6099
	ld (hl),a		; $609b
+
.endif

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

.ifdef ROM_AGES
@collisions1:
@collisions2:
@collisions5:
	.db TILEINDEX_RAISABLE_FLOOR_1 TILEINDEX_RAISABLE_FLOOR_2
@collisions0:
@collisions3:
@collisions4:
	.db $00
.else
@collisions0:
	.db $eb $20
@collisions1:
@collisions2:
@collisions3:
@collisions4:
@collisions5:
	.db $00
.endif

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

.ifdef ROM_AGES
	call checkLinkVulnerableAndIDZero		; $6450
.else
	call checkLinkID0AndControlNormal		; $4559
.endif
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

.ifdef ROM_AGES
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
.endif

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

.ifdef ROM_AGES
	ld bc,TX_070d		; $6638
.else
	ld bc,TX_0709		; $6638
.endif
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
.ifdef ROM_AGES
	ld e,SpecialObject.direction		; $68f8
	ld a,(de)		; $68fa
	bit 7,a			; $68fb
	jr z,+			; $68fd
	and $03			; $68ff
	jr @determineAnimation		; $6901
+
.endif

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

.ifdef ROM_AGES
	ld bc,TX_0711		; $692f
.else
	ld bc,TX_070b		; $692f
.endif
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
.ifdef ROM_AGES
	cp $08			; $699a
.else
	cp $01			; $699a
.endif
	jr nz,@noTradeItem	; $699c

.ifdef ROM_AGES
	ld b,INTERACID_TOUCHING_BOOK		; $699e
.else
	ld b,INTERACID_GHASTLY_DOLL		; $699e
.endif
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

	ld l,SpecialObject.var39		; $6ca2
	ld (hl),$10		; $6ca4
	ld a,(wRickyState)		; $6ca6

.ifdef ROM_AGES
	bit 7,a			; $6d5d
	jr nz,@setAnimation17	; $6d5f

	ld c,$17		; $6d61
	bit 6,a			; $6d63
	jr nz,@canTalkToRicky	; $6d65

	and $20			; $6d67
	jr nz,@setAnimation17	; $6d69

	ld c,$00		; $6d6b
.else
	and $80			; $6ca9
	jr nz,@setAnimation17	; $6cab
.endif

@canTalkToRicky:
	; Ricky not ridable yet, can press A to talk to him
	ld l,SpecialObject.state		; $6d6d
	ld (hl),$0a		; $6d6f
	ld e,SpecialObject.var3d		; $6d71
	call objectAddToAButtonSensitiveObjectList		; $6d73
.ifdef ROM_AGES
	ld a,c			; $6d76
.else
	ld a,$00			; $6d76
.endif
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
.ifdef ROM_SEASONS
	.dw _rickyStateASubstate8
	.dw _rickyStateASubstate9
	.dw _rickyStateASubstateA
	.dw _rickyStateASubstateB
	.dw _rickyStateASubstateC
.endif

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

.ifdef ROM_AGES
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
.else
_rickyStateASubstate2:
	ld a,$01		; $705c
	ld (wDisabledObjects),a		; $705e
	ld a,DIR_UP		; $7061
	ld e,SpecialObject.direction		; $7063
	ld (de),a		; $7065
	ld a,$05		; $7066
	ld e,SpecialObject.var3f		; $7068
	ld (de),a		; $706a
	call _rickyIncVar03		; $706b
.endif

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

.ifdef ROM_AGES
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
.else

_rickyStateASubstate7:
	call _companionSetAnimationToVar3f		; $708d
	call specialObjectAnimate		; $7090
	ld e,$21		; $7093
	ld a,(de)		; $7095
	or a			; $7096
	ld a,$c3		; $7097
	jp z,playSound		; $7099
	ld a,(de)		; $709c
	rlca			; $709d
	ret nc			; $709e
	call _rickySetJumpSpeedForCutsceneAndSetAngle		; $709f
	ld e,$09		; $70a2
	ld a,$10		; $70a4
	ld (de),a		; $70a6
	ret			; $70a7
_rickyStateASubstate3:
	call _companionSetAnimationToVar3f		; $70a8
	ld e,$3e		; $70ab
	ld a,(de)		; $70ad
	and $01			; $70ae
	ret nz			; $70b0
	call _rickyWaitUntilJumpDone		; $70b1
	ret nz			; $70b4
	ld e,$0b		; $70b5
	ld a,(de)		; $70b7
	cp $38			; $70b8
	jr nc,_rickySetJumpSpeedForCutsceneAndSetAngle	; $70ba
	ld e,$3e		; $70bc
	ld a,(de)		; $70be
	or $01			; $70bf
	ld (de),a		; $70c1
	ret			; $70c2
_rickyStateASubstate4:
	call _companionSetAnimationToVar3f		; $70c3
	ld e,$3e		; $70c6
	ld a,(de)		; $70c8
	bit 1,a			; $70c9
	ret nz			; $70cb
	or $02			; $70cc
	ld (de),a		; $70ce
	jp companionDismount		; $70cf
_rickyStateASubstate5:
	call _rickySetJumpSpeedForCutsceneAndSetAngle		; $70d2
	ld e,$09		; $70d5
	ld a,$10		; $70d7
	ld (de),a		; $70d9
	ret			; $70da
_rickyStateASubstate6:
_rickyStateASubstate8:
	call _companionSetAnimationToVar3f		; $70db
	call _rickyWaitUntilJumpDone		; $70de
	ret nz			; $70e1
	call objectCheckWithinScreenBoundary		; $70e2
	jr nc,++	; $70e5
	ld e,$0b		; $70e7
	ld a,(de)		; $70e9
	cp $60			; $70ea
	jr c,+	; $70ec
	ld e,$3e		; $70ee
	ld a,(de)		; $70f0
	or $04			; $70f1
	ld (de),a		; $70f3
+
	call _rickySetJumpSpeedForCutsceneAndSetAngle		; $70f4
	ld e,$09		; $70f7
	ld a,$10		; $70f9
	ld (de),a		; $70fb
	ret			; $70fc
++
	ld a,$01		; $70fd
	ld ($cc6a),a		; $70ff
	xor a			; $7102
	ld ($cca4),a		; $7103
	call itemDelete		; $7106
	jp saveLinkLocalRespawnAndCompanionPosition		; $7109
_rickyStateASubstate9:
	ld a,$80		; $710c
	ld ($cc02),a		; $710e
	ld a,$01		; $7111
	ld e,$08		; $7113
	ld (de),a		; $7115
	call _rickyIncVar03		; $7116
	ld c,$20		; $7119
	call _companionSetAnimation		; $711b
-
	ld bc,$4070		; $711e
	call objectGetRelativeAngle		; $7121
	and $1c			; $7124
	ld e,$09		; $7126
	ld (de),a		; $7128
	ret			; $7129
_rickyStateASubstateA:
	call specialObjectAnimate		; $712a
	call _companionUpdateMovement		; $712d
	ld e,$0d		; $7130
	ld a,(de)		; $7132
	cp $38			; $7133
	jr c,-	; $7135
	ld bc,$2004		; $7137
	call showText		; $713a
.endif

;;
; @addr{71f1}
_rickyIncVar03:
	ld e,SpecialObject.var03		; $71f1
	ld a,(de)		; $71f3
	inc a			; $71f4
	ld (de),a		; $71f5
	ret			; $71f6

;;
; Seasons-only
; @addr{71f7}
_rickyStateASubstateB:
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
; Seasons-only
; @addr{721d}
_rickyStateASubstateC:
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
.ifdef ROM_AGES
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
.else
	and $80			; $730a
	jr nz,@setAnimation	; $730c
	ld l,SpecialObject.state		; $730e
	ld (hl),$0a		; $7310
	ld e,SpecialObject.var3d		; $7312
	call objectAddToAButtonSensitiveObjectList		; $7314
	ld a,$24		; $7317
.endif

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

.ifdef ROM_AGES
	ld a,(wLinkForceState)		; $75fd
	cp LINK_STATE_RESPAWNING			; $7600
	jr nz,++		; $7602
	xor a			; $7604
	ld (wLinkForceState),a		; $7605
	jp _companionGotoHazardHandlingState		; $7608
++
.endif

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

.ifdef ROM_AGES
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
.else
_dimitriStateA:
	call _companionSetAnimationToVar3f		; $7678
	call _companionPreventLinkFromPassing_noExtraChecks		; $767b
	call specialObjectAnimate		; $767e
	ld e,SpecialObject.visible		; $7681
	ld a,$c7		; $7683
	ld (de),a		; $7685
	ld a,(wDimitriState)		; $7686
	and $80			; $7689
	ret z			; $768b

	ld e,SpecialObject.visible		; $768c
	ld a,$c1		; $768e
	ld (de),a		; $7690
	ld a,$ff		; $7691
	ld (wStatusBarNeedsRefresh),a		; $7693
	ld c,$1c		; $7696
	call _companionSetAnimation		; $7698
	jp _companionForceMount		; $769b
.endif

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

.ifdef ROM_AGES
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
.else
	ld a,(wAnimalCompanion)		; $776b
	cp SPECIALOBJECTID_MOOSH			; $776e
	jr nz,@gotoCutsceneStateA	; $7770

	ld a,$20		; $7772
	and (hl)		; $7774
	jr z,+			; $7775

	ld a,(wActiveRoom)		; $7777
	; mt cucco
	cp $2f			; $777a
	jr z,@gotoCutsceneStateA	; $777c
	jr @setAnimation		; $777e
+
	ld a,(wActiveRoom)		; $7780
	; spool swamp
	cp $90			; $7783
	jr nz,@setAnimation	; $7785
.endif

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


.ifdef ROM_AGES
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
.else
_mooshStateA:
	ld e,$03
	ld a,(de)		; $7a46
	rst_jumpTable			; $7a47
        .dw _mooshStateASubstate0
        .dw _mooshStateASubstate1
        .dw _mooshStateASubstate2
        .dw _mooshStateASubstate3
        .dw _mooshStateASubstate4
        .dw _mooshStateASubstate5
        .dw _mooshStateASubstate6
        .dw _mooshStateASubstate7
        .dw _mooshStateASubstate8
        .dw _mooshStateASubstate9
        .dw _mooshStateASubstateA
        .dw _mooshStateASubstateB
        .dw _mooshStateASubstateC

_mooshStateASubstate0:
	ld a,$01		; $7a62
	ld (de),a		; $7a64

	ld a,($c610)		; $7a65
	cp $0d			; $7a68
	jr nz,_label_05_425	; $7a6a
	ld a,($c645)		; $7a6c
	and $20			; $7a6f
	jr nz,_label_05_425	; $7a71
	ld a,$02		; $7a73
	ld (de),a		; $7a75
	ld c,$01		; $7a76
	call $4547		; $7a78
	jr _label_05_426		; $7a7b
_label_05_425:
	ld a,$00		; $7a7d
	ld e,$3f		; $7a7f
	ld (de),a		; $7a81
	call specialObjectSetAnimation		; $7a82
_label_05_426:
	call objectSetVisiblec3		; $7a85
	ld e,$3d		; $7a88
	jp objectAddToAButtonSensitiveObjectList		; $7a8a

_mooshStateASubstate1:
_mooshStateASubstate7:
	call $485a		; $7a8d
	call $7b9e		; $7a90
	ld a,($c645)		; $7a93
	and $80			; $7a96
	jr z,_label_05_427	; $7a98
	jr _label_05_428		; $7a9a
_label_05_427:
	ld e,$3d		; $7a9c
	ld a,(de)		; $7a9e
	or a			; $7a9f
	ret z			; $7aa0
	ld a,$81		; $7aa1
	ld ($cca4),a		; $7aa3
	ret			; $7aa6

_mooshStateASubstate2:
	ld e,$2b		; $7aa7
	ld a,(de)		; $7aa9
	or a			; $7aaa
	ret z			; $7aab
	dec a			; $7aac
	ld (de),a		; $7aad
	ld h,d			; $7aae
	jp $4244		; $7aaf

_mooshStateASubstate3:
	call $485a		; $7ab2
	call specialObjectAnimate		; $7ab5
	call $4917		; $7ab8
	ret nz			; $7abb
	ld c,$10		; $7abc
	jp objectUpdateSpeedZ_paramC		; $7abe

_mooshStateASubstate4:
	call $485a		; $7ac1
	ld c,$10		; $7ac4
	call objectUpdateSpeedZ_paramC		; $7ac6
	ret nz			; $7ac9
	ld e,$3e		; $7aca
	ld a,(de)		; $7acc
	or $40			; $7acd
	ld (de),a		; $7acf
	jp specialObjectAnimate		; $7ad0

_mooshStateASubstate5:
_mooshStateASubstate6:
	call $485a		; $7ad3
	call $7b9e		; $7ad6
	ld a,($c645)		; $7ad9
	and $20			; $7adc
	ret z			; $7ade
	ld a,$ff		; $7adf
	ld ($cbea),a		; $7ae1
_label_05_428:
	ld e,$3d		; $7ae4
	xor a			; $7ae6
	ld (de),a		; $7ae7
	call objectRemoveFromAButtonSensitiveObjectList		; $7ae8
	ld c,$01		; $7aeb
	call $4547		; $7aed
	jp $4948		; $7af0

_mooshStateASubstate8:
	call $485a		; $7af3
	ld e,$3e		; $7af6
	xor a			; $7af8
	ld (de),a		; $7af9
	ld c,$10		; $7afa
	jp objectUpdateSpeedZ_paramC		; $7afc
_label_05_429:
	ld b,$40		; $7aff
	ld c,$70		; $7b01
	call objectGetRelativeAngle		; $7b03
	and $1c			; $7b06
	ld e,$09		; $7b08
	ld (de),a		; $7b0a
	ret			; $7b0b

_mooshStateASubstate9:
	ld c,$10		; $7b0c
	call objectUpdateSpeedZ_paramC		; $7b0e
	call specialObjectAnimate		; $7b11
	call $441e		; $7b14
	ld e,$0d		; $7b17
	ld a,(de)		; $7b19
	cp $38			; $7b1a
	jr c,_label_05_429	; $7b1c
	ld a,$01		; $7b1e
	ld e,$3e		; $7b20
	ld (de),a		; $7b22
	jp $7ba7		; $7b23

_mooshStateASubstateA:
	call $485a		; $7b26
	ld e,$3e		; $7b29
	ld a,(de)		; $7b2b
	and $02			; $7b2c
	ret z			; $7b2e
	ld bc,$220f		; $7b2f
	call showText		; $7b32
	jp $7ba7		; $7b35

_mooshStateASubstateB:
	call retIfTextIsActive		; $7b38
	call $45f5		; $7b3b
	ld a,$18		; $7b3e
	ld ($d009),a		; $7b40
	ld ($cc47),a		; $7b43
	ld a,$32		; $7b46
	ld ($d010),a		; $7b48
	ld bc,$fec0		; $7b4b
	call objectSetSpeedZ		; $7b4e
	ld l,$09		; $7b51
	ld (hl),$18		; $7b53
	ld l,$06		; $7b55
	ld (hl),$1e		; $7b57
	ld c,$0c		; $7b59
	call $4547		; $7b5b
	jp $7ba7		; $7b5e

_mooshStateASubstateC:
	call specialObjectAnimate		; $7b61
	ld e,$15		; $7b64
	ld a,(de)		; $7b66
	or a			; $7b67
	ld c,$10		; $7b68
	call nz,objectUpdateSpeedZ_paramC		; $7b6a
	ld a,($cc77)		; $7b6d
	or a			; $7b70
	ret nz			; $7b71
	call setLinkForceStateToState08		; $7b72
	ld hl,$d00d		; $7b75
	ld e,$0d		; $7b78
	ld a,(de)		; $7b7a
	bit 7,a			; $7b7b
	jr nz,_label_05_430	; $7b7d
	cp (hl)			; $7b7f
	ld a,$01		; $7b80
	jr nc,_label_05_431	; $7b82
_label_05_430:
	ld a,$03		; $7b84
_label_05_431:
	ld l,$08		; $7b86
	ld (hl),a		; $7b88
	call $4917		; $7b89
	ret nz			; $7b8c
	call $441e		; $7b8d
	call objectCheckWithinScreenBoundary		; $7b90
	ret c			; $7b93
	xor a			; $7b94
	ld ($cc40),a		; $7b95
	ld ($cc02),a		; $7b98
	jp itemDelete		; $7b9b
.endif

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
.ifdef ROM_AGES
	jpab bank6.specialObjectCode_raft		; $7c66
.endif

.include "build/data/tileTypeMappings.s"

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

.ifdef ROM_AGES
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
.else
@collisions0Data:
	.db $54 $10
	.db $25 $18
	.db $26 $08
	.db $28 $08
	.db $27 $18
	.db $94 $10
	.db $95 $10
	.db $2a $00
	.db $9a $10
	.db $cc $10
	.db $cd $10
	.db $ce $10
	.db $cf $10
	.db $fe $10
	.db $ff $10
	.db $00

@collisions1Data:
	.db $ea $10
	.db $eb $10
	.db $54 $10
	.db $00

@collisions2Data:
	.db $00			; $7ccc
@collisions3Data:
@collisions4Data:
	.db $b0 $10
	.db $b1 $18
	.db $b2 $00
	.db $b3 $08
	.db $05 $00
	.db $06 $10

@collisions5Data:
	.db $00			; $7cd9
.endif

specialObjectCode_05_7cda:
	ld e,$04		; $7cda
	ld a,(de)		; $7cdc
	rst_jumpTable			; $7cdd
	ld ($0f7c),a		; $7cde
	ld a,l			; $7ce1
	sbc c			; $7ce2
	ld a,l			; $7ce3
	cp $7d			; $7ce4
	rrca			; $7ce6
	ld a,(hl)		; $7ce7
	ld (de),a		; $7ce8
	ld a,(hl)		; $7ce9
	call clearAllParentItems		; $7cea
	call $41b5		; $7ced
	ld h,d			; $7cf0
	ld l,$00		; $7cf1
	ld a,(hl)		; $7cf3
	or $03			; $7cf4
	ld (hl),a		; $7cf6
	ld l,$04		; $7cf7
	ld (hl),$01		; $7cf9
	ld l,$08		; $7cfb
	ld (hl),$02		; $7cfd
	ld l,$0b		; $7cff
	ld (hl),$38		; $7d01
	ld l,$0d		; $7d03
	ld (hl),$68		; $7d05
	ld a,$00		; $7d07
	call specialObjectSetAnimation		; $7d09
	jp objectSetVisiblec1		; $7d0c
	call $7e13		; $7d0f
	ld h,d			; $7d12
	ld a,($cc46)		; $7d13
	ld b,$00		; $7d16
	bit 4,a			; $7d18
	jr nz,_label_05_440	; $7d1a
	inc b			; $7d1c
	bit 5,a			; $7d1d
	jr nz,_label_05_440	; $7d1f
	inc b			; $7d21
	and $01			; $7d22
	jr nz,_label_05_444	; $7d24
	ret			; $7d26
_label_05_440:
	call $7d8f		; $7d27
	ld l,$04		; $7d2a
	inc (hl)		; $7d2c
	ld l,$37		; $7d2d
	ld (hl),$00		; $7d2f
	call objectGetShortPosition		; $7d31
	ld c,a			; $7d34
	ld hl,$7d57		; $7d35
_label_05_441:
	ldi a,(hl)		; $7d38
	cp c			; $7d39
	jr z,_label_05_442	; $7d3a
	inc hl			; $7d3c
	jr _label_05_441		; $7d3d
_label_05_442:
	ld a,($cc46)		; $7d3f
	and $10			; $7d42
	ld a,(hl)		; $7d44
	jr nz,_label_05_443	; $7d45
	swap a			; $7d47
_label_05_443:
	and $0f			; $7d49
	ld e,$08		; $7d4b
	ld (de),a		; $7d4d
	swap a			; $7d4e
	rrca			; $7d50
	inc e			; $7d51
	ld (de),a		; $7d52
	xor a			; $7d53
	jp specialObjectSetAnimation		; $7d54
	ld de,$2121		; $7d57
	jr nz,$31		; $7d5a
	jr nz,_label_05_445	; $7d5c
	jr nz,$51		; $7d5e
	jr nz,_label_05_446	; $7d60
	stop			; $7d62
	ld h,d			; $7d63
	inc de			; $7d64
	ld h,e			; $7d65
	inc de			; $7d66
	ld h,h			; $7d67
	inc de			; $7d68
	ld h,l			; $7d69
	inc de			; $7d6a
	ld h,(hl)		; $7d6b
	inc bc			; $7d6c
	ld d,(hl)		; $7d6d
	ld (bc),a		; $7d6e
	ld b,(hl)		; $7d6f
	ld (bc),a		; $7d70
	ld (hl),$02		; $7d71
	ld h,$02		; $7d73
	ld d,$32		; $7d75
	dec d			; $7d77
	ld sp,$3114		; $7d78
	inc de			; $7d7b
	ld sp,$3112		; $7d7c
_label_05_444:
	call $7d8f		; $7d7f
	ld l,$04		; $7d82
	ld (hl),$03		; $7d84
	ld l,$08		; $7d86
	ld (hl),$00		; $7d88
	ld a,$01		; $7d8a
	jp specialObjectSetAnimation		; $7d8c
	ld a,($cfd8)		; $7d8f
	inc a			; $7d92
	ret nz			; $7d93
	ld a,b			; $7d94
	ld ($cfd8),a		; $7d95
	ret			; $7d98
	call $7e13		; $7d99
	call specialObjectAnimate		; $7d9c
_label_05_445:
	call $7da9		; $7d9f
	ret c			; $7da2
	ld e,$04		; $7da3
	ld a,$01		; $7da5
	ld (de),a		; $7da7
	ret			; $7da8
	ld h,d			; $7da9
	ld e,$0b		; $7daa
	ld l,$38		; $7dac
	ld a,(de)		; $7dae
	ldi (hl),a		; $7daf
	ld e,$0d		; $7db0
	ld a,(de)		; $7db2
	ld (hl),a		; $7db3
	ld a,($cfd3)		; $7db4
	ld e,$10		; $7db7
	ld (de),a		; $7db9
	call objectApplySpeed		; $7dba
	call $7dc2		; $7dbd
	jr _label_05_448		; $7dc0
	ld h,d			; $7dc2
_label_05_446:
	ld l,$0b		; $7dc3
	call $7dcb		; $7dc5
	ld h,d			; $7dc8
	ld l,$0d		; $7dc9
	ld a,$17		; $7dcb
	cp (hl)			; $7dcd
	inc a			; $7dce
	jr nc,_label_05_447	; $7dcf
	ld a,$68		; $7dd1
	cp (hl)			; $7dd3
	ret nc			; $7dd4
_label_05_447:
	ld (hl),a		; $7dd5
	ret			; $7dd6
_label_05_448:
	ld e,$0b		; $7dd7
	ld a,(de)		; $7dd9
	ld b,a			; $7dda
	ld e,$38		; $7ddb
	ld a,(de)		; $7ddd
	sub b			; $7dde
	jr nc,_label_05_449	; $7ddf
	cpl			; $7de1
	inc a			; $7de2
_label_05_449:
	ld c,a			; $7de3
	ld e,$0d		; $7de4
	ld a,(de)		; $7de6
	ld b,a			; $7de7
	ld e,$39		; $7de8
	ld a,(de)		; $7dea
	sub b			; $7deb
	jr nc,_label_05_450	; $7dec
	cpl			; $7dee
	inc a			; $7def
_label_05_450:
	add c			; $7df0
	ret z			; $7df1
	ld b,a			; $7df2
	ld e,$37		; $7df3
	ld a,(de)		; $7df5
	add b			; $7df6
	ld (de),a		; $7df7
	cp $10			; $7df8
	ret c			; $7dfa
	jp objectCenterOnTile		; $7dfb
	call $7e13		; $7dfe
	call specialObjectAnimate		; $7e01
	ld e,$21		; $7e04
	ld a,(de)		; $7e06
	inc a			; $7e07
	ret nz			; $7e08
	ld e,$04		; $7e09
	ld a,$01		; $7e0b
	ld (de),a		; $7e0d
	ret			; $7e0e
	jp specialObjectAnimate		; $7e0f
	ret			; $7e12
	ld a,($cfd0)		; $7e13
	or a			; $7e16
	ret z			; $7e17
	pop hl			; $7e18
	inc a			; $7e19
	ld a,$05		; $7e1a
	ld b,$02		; $7e1c
	jr z,_label_05_451	; $7e1e
	dec a			; $7e20
	ld b,$01		; $7e21
_label_05_451:
	ld e,$04		; $7e23
	ld (de),a		; $7e25
	ld a,b			; $7e26
	call specialObjectSetAnimation		; $7e27
	jp objectSetVisible80		; $7e2a

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

;;
; For each Enemy and each Part, check for collisions with Link and Items.
; @addr{41b9}
checkEnemyAndPartCollisions:
	ld a,($d008)    ; $41b9
	add a           ; $41bc
	add a           ; $41bd
	ld hl,$4219		; $41be
	rst_addAToHl			; $41c1
	ld de,$cc8a		; $41c2
	ld a,($d00b)		; $41c5
	add (hl)		; $41c8
_label_07_011:
	ld (de),a		; $41c9
	inc hl			; $41ca
	inc e			; $41cb
	ld a,($d00d)		; $41cc
	add (hl)		; $41cf
	ld (de),a		; $41d0
	inc hl			; $41d1
	inc e			; $41d2
	ldi a,(hl)		; $41d3
	ld (de),a		; $41d4
	inc e			; $41d5
	ldi a,(hl)		; $41d6
	ld (de),a		; $41d7
	ld a,$80		; $41d8
	ldh (<hActiveObjectType),a	; $41da
	ld d,$d0		; $41dc
	ld a,d			; $41de
_label_07_012:
	ldh (<hActiveObject),a	; $41df
	ld h,d			; $41e1
	ld l,$a4		; $41e2
	bit 7,(hl)		; $41e4
	jr z,_label_07_013	; $41e6
	ld a,(hl)		; $41e8
	ld l,$aa		; $41e9
	bit 7,(hl)		; $41eb
	call z,$4233		; $41ed
_label_07_013:
	inc d			; $41f0
	ld a,d			; $41f1
	cp $e0			; $41f2
	jr c,_label_07_012	; $41f4
	ld a,$c0		; $41f6
	ldh (<hActiveObjectType),a	; $41f8
	ld d,$d0		; $41fa
	ld a,d			; $41fc
_label_07_014:
	ldh (<hActiveObject),a	; $41fd
	ld h,d			; $41ff
	ld l,$e4		; $4200
	bit 7,(hl)		; $4202
	jr z,_label_07_015	; $4204
	ld l,$ea		; $4206
	bit 7,(hl)		; $4208
	jr nz,_label_07_015	; $420a
	inc l			; $420c
	ld a,(hl)		; $420d
	or a			; $420e
	call z,$4229		; $420f
_label_07_015:
	inc d			; $4212
	ld a,d			; $4213
	cp $e0			; $4214
	jr c,_label_07_014	; $4216
	ret			; $4218
	ld sp,hl		; $4219
	ld bc,$0601		; $421a
	nop			; $421d
	ld b,$07		; $421e
	ld bc,$ff06		; $4220
	ld bc,$0006		; $4223
	ld sp,hl		; $4226
	rlca			; $4227
	.db $01

_partCheckCollisions:
	ld e,$e4		; $4229
	ld a,(de)		; $422b
	ld hl,$6940		; $422c
	ld e,$cb		; $422f
	jr ++			; $4231


_enemyCheckCollisions:
	ld hl,$6740		; $4233
	ld e,$8b		; $4236
++
	add a			; $4238
	ld c,a			; $4239
	ld b,$00		; $423a
	add hl,bc		; $423c
	add hl,bc		; $423d
	ld a,l			; $423e
	ldh (<hFF92),a	; $423f
	ld a,h			; $4241
	ldh (<hFF93),a	; $4242
	ld h,d			; $4244
	ld l,e			; $4245
	ldi a,(hl)		; $4246
	ldh (<hFF8F),a	; $4247
	inc l			; $4249
	ldi a,(hl)		; $424a
	ldh (<hFF8E),a	; $424b
	inc l			; $424d
	ld a,(hl)		; $424e
	ldh (<hFF91),a	; $424f
	ld a,l			; $4251
	add $1c			; $4252
	ld l,a			; $4254
	ld a,(hl)		; $4255
	or a			; $4256
	jr nz,_label_07_020	; $4257
	ld h,$d6		; $4259
_label_07_017:
	ld l,$24		; $425b
	ld a,(hl)		; $425d
	bit 7,a			; $425e
	jr z,_label_07_019	; $4260
	and $7f			; $4262
	ldh (<hFF90),a	; $4264
	ld b,a			; $4266
	ld e,h			; $4267
	ldh a,(<hFF92)	; $4268
	ld l,a			; $426a
	ldh a,(<hFF93)	; $426b
	ld h,a			; $426d
	ld a,b			; $426e
	call $4313		; $426f
	ld h,e			; $4272
	jr z,_label_07_019	; $4273
	ld bc,$0e07		; $4275
	ldh a,(<hFF90)	; $4278
	cp $17			; $427a
	jr nz,_label_07_018	; $427c
	ld l,$26		; $427e
	ld a,(hl)		; $4280
	ld c,a			; $4281
	add a			; $4282
	ld b,a			; $4283
_label_07_018:
	ld l,$0f		; $4284
	ldh a,(<hFF91)	; $4286
	sub (hl)		; $4288
	add c			; $4289
	cp b			; $428a
	jr nc,_label_07_019	; $428b
	ld l,$0b		; $428d
	ld b,(hl)		; $428f
	ld l,$0d		; $4290
	ld c,(hl)		; $4292
	ld l,$26		; $4293
	ldh a,(<hActiveObjectType)	; $4295
	add $26			; $4297
	ld e,a			; $4299
	call checkObjectsCollidedFromVariables		; $429a
	jp c,$4329		; $429d
_label_07_019:
	inc h			; $42a0
	ld a,h			; $42a1
	cp $de			; $42a2
	jr c,_label_07_017	; $42a4
_label_07_020:
	call checkLinkVulnerable		; $42a6
	ret nc			; $42a9
	ld l,$0f		; $42aa
	ldh a,(<hFF91)	; $42ac
	sub (hl)		; $42ae
	add $07			; $42af
	cp $0e			; $42b1
	ret nc			; $42b3
	ld a,($cc89)		; $42b4
	or a			; $42b7
	jr z,_label_07_021	; $42b8
	ldh (<hFF90),a	; $42ba
	ldh a,(<hFF92)	; $42bc
	ld l,a			; $42be
	ldh a,(<hFF93)	; $42bf
	ld h,a			; $42c1
	ldh a,(<hFF90)	; $42c2
	call $4313		; $42c4
	jr z,_label_07_021	; $42c7
	ld hl,$cc8a		; $42c9
	ldi a,(hl)		; $42cc
	ld b,a			; $42cd
	ldi a,(hl)		; $42ce
	ld c,a			; $42cf
	ldh a,(<hActiveObjectType)	; $42d0
	add $26			; $42d2
	ld e,a			; $42d4
	call checkObjectsCollidedFromVariables		; $42d5
	ld hl,$d000		; $42d8
	jp c,$4329		; $42db
_label_07_021:
	ldh a,(<hActiveObjectType)	; $42de
	add $2e			; $42e0
	ld e,a			; $42e2
	ld a,(de)		; $42e3
	or a			; $42e4
	ret nz			; $42e5
	ld a,($cc48)		; $42e6
	ld h,a			; $42e9
	ld e,a			; $42ea
	ld l,$24		; $42eb
	ld a,(hl)		; $42ed
	and $7f			; $42ee
	ldh (<hFF90),a	; $42f0
	ldh a,(<hFF92)	; $42f2
	ld l,a			; $42f4
	ldh a,(<hFF93)	; $42f5
	ld h,a			; $42f7
	ldh a,(<hFF90)	; $42f8
	call $4313		; $42fa
	ret z			; $42fd
	ld h,e			; $42fe
	ld l,$0b		; $42ff
	ld b,(hl)		; $4301
	ld l,$0d		; $4302
	ld c,(hl)		; $4304
	ld l,$26		; $4305
	ldh a,(<hActiveObjectType)	; $4307
	add $26			; $4309
	ld e,a			; $430b
	call checkObjectsCollidedFromVariables		; $430c
	jp c,$4329		; $430f
	ret			; $4312
	ld b,a			; $4313
	and $f8			; $4314
	rlca			; $4316
	swap a			; $4317
	ld c,a			; $4319
	ld a,b			; $431a
	and $07			; $431b
	ld b,$00		; $431d
	add hl,bc		; $431f
	ld c,(hl)		; $4320
	ld hl,bitTable		; $4321
	add l			; $4324
	ld l,a			; $4325
	ld a,(hl)		; $4326
	and c			; $4327
	ret			; $4328
	ld a,l			; $4329
	and $c0			; $432a
	ld l,a			; $432c
	push hl			; $432d
	ld a,$d6		; $432e
	cp h			; $4330
	jr nz,_label_07_022	; $4331
	ld a,($d00b)		; $4333
	ld b,a			; $4336
	ld a,($d00d)		; $4337
	jr _label_07_023		; $433a
_label_07_022:
	ldh a,(<hFF8D)	; $433c
	ld b,a			; $433e
	ldh a,(<hFF8C)	; $433f
_label_07_023:
	ld c,a			; $4341
	call objectGetRelativeAngleWithTempVars		; $4342
	ldh (<hFF8A),a	; $4345
	ldh a,(<hActiveObjectType)	; $4347
	add $25			; $4349
	ld e,a			; $434b
	ld a,(de)		; $434c
	add a			; $434d
	call multiplyABy16		; $434e
	ld hl,objectCollisionTable		; $4351
	add hl,bc		; $4354
	pop bc			; $4355
	ldh a,(<hFF90)	; $4356
	rst_addAToHl			; $4358
	ld a,(hl)		; $4359
	rst_jumpTable			; $435a

.DB $db				; $435b
	ld b,e			; $435c
	ld c,$44		; $435d
	ld (de),a		; $435f
	ld b,h			; $4360
	ld d,$44		; $4361
	ld a,(de)		; $4363
	ld b,h			; $4364
	ld l,e			; $4365
	ld b,h			; $4366
	ld (hl),b		; $4367
	ld b,h			; $4368
	ld (hl),l		; $4369
	ld b,h			; $436a
	inc h			; $436b
	ld b,h			; $436c
	jr z,_label_07_024	; $436d
	inc l			; $436f
	ld b,h			; $4370
	jr nc,_label_07_025	; $4371
	ld c,h			; $4373
	ld b,h			; $4374
	ld d,e			; $4375
	ld b,h			; $4376
	ld e,d			; $4377
	ld b,h			; $4378
	ld a,l			; $4379
	ld b,h			; $437a
	add l			; $437b
	ld b,h			; $437c
	and l			; $437d
	ld b,h			; $437e
	ld c,c			; $437f
	ld b,h			; $4380
	ld d,b			; $4381
	ld b,h			; $4382
	ld d,a			; $4383
	ld b,h			; $4384
	adc d			; $4385
	ld b,h			; $4386
	sub d			; $4387
	ld b,h			; $4388
	sbc d			; $4389
	ld b,h			; $438a
	ld a,d			; $438b
	ld b,h			; $438c
	add d			; $438d
	ld b,h			; $438e
	and d			; $438f
	ld b,h			; $4390
	xor d			; $4391
	ld b,h			; $4392
	inc (hl)		; $4393
	ld b,l			; $4394
	or d			; $4395
	ld b,h			; $4396
	or a			; $4397
	ld b,h			; $4398
	cp h			; $4399
	ld b,h			; $439a
	pop bc			; $439b
	ld b,h			; $439c
	jr c,$44		; $439d
	sub $44			; $439f
	ld l,h			; $43a1
	ld b,l			; $43a2
	ld (hl),l		; $43a3
	ld b,l			; $43a4
	adc l			; $43a5
	ld b,l			; $43a6
.DB $e3				; $43a7
	ld b,h			; $43a8
	add sp,$44		; $43a9
	ld sp,hl		; $43ab
	ld b,h			; $43ac
	sbc h			; $43ad
	ld b,l			; $43ae
.DB $ec				; $43af
	ld b,l			; $43b0
	jr nz,$45		; $43b1
_label_07_024:
	dec h			; $43b3
	ld b,l			; $43b4
	ld (bc),a		; $43b5
	ld b,(hl)		; $43b6
_label_07_025:
	add hl,sp		; $43b7
	ld b,l			; $43b8
	ldi a,(hl)		; $43b9
	ld b,l			; $43ba
	cpl			; $43bb
	ld b,l			; $43bc
	ld ($0d46),sp		; $43bd
	ld b,(hl)		; $43c0
	ld (de),a		; $43c1
	ld b,(hl)		; $43c2
	dec de			; $43c3
	ld b,(hl)		; $43c4
	dec hl			; $43c5
	ld b,(hl)		; $43c6
	ccf			; $43c7
	ld b,(hl)		; $43c8
	ld a,e			; $43c9
	ld b,(hl)		; $43ca
	sbc (hl)		; $43cb
	ld b,(hl)		; $43cc
	or l			; $43cd
	ld b,(hl)		; $43ce
	rlca			; $43cf
	ld b,l			; $43d0
	or (hl)			; $43d1
	ld b,(hl)		; $43d2
	call c,$0c43		; $43d3
	ld b,l			; $43d6
	ret nz			; $43d7
	ld b,(hl)		; $43d8
	pop bc			; $43d9
	ld b,(hl)		; $43da
	ret			; $43db
	ldh a,(<hActiveObjectType)	; $43dc
	inc a			; $43de
	ld e,a			; $43df
	ld a,(de)		; $43e0
	ld c,a			; $43e1
	ld hl,$4405		; $43e2
_label_07_026:
	ldi a,(hl)		; $43e5
	or a			; $43e6
	jr z,_label_07_027	; $43e7
	cp c			; $43e9
	ldi a,(hl)		; $43ea
	jr nz,_label_07_026	; $43eb
	ld c,a			; $43ed
	and $7f			; $43ee
	call cpActiveRing		; $43f0
	jr nz,_label_07_027	; $43f3
	bit 7,c			; $43f5
	ld a,$40		; $43f7
	jp z,$46ef		; $43f9
	call $4412		; $43fc
	ld h,b			; $43ff
	ld l,$25		; $4400
	sra (hl)		; $4402
	ret			; $4404
	ld c,$9a		; $4405
	jr $20			; $4407
	add hl,de		; $4409
	rra			; $440a
	add hl,hl		; $440b
	sbc e			; $440c
	nop			; $440d
	ld e,$00		; $440e
	jr _label_07_028		; $4410
_label_07_027:
	ld e,$04		; $4412
	jr _label_07_028		; $4414
	ld e,$08		; $4416
	jr _label_07_028		; $4418
	ld e,$0c		; $441a
_label_07_028:
	call $47c7		; $441c
	ld a,$1c		; $441f
	jp $46ef		; $4421
	ld e,$00		; $4424
	jr _label_07_029		; $4426
	ld e,$04		; $4428
	jr _label_07_029		; $442a
	ld e,$08		; $442c
	jr _label_07_029		; $442e
	call $479f		; $4430
	ret z			; $4433
	ld e,$0c		; $4434
	jr _label_07_029		; $4436
	ld e,$30		; $4438
_label_07_029:
	ldh a,(<hActiveObjectType)	; $443a
	add $3e			; $443c
	ld l,a			; $443e
	ld h,d			; $443f
	ld c,$2a		; $4440
	ld a,(bc)		; $4442
	or (hl)			; $4443
	ld (bc),a		; $4444
	ld a,e			; $4445
	jp $46ef		; $4446
	call $46cf		; $4449
	ld e,$10		; $444c
	jr _label_07_030		; $444e
	call $46cf		; $4450
	ld e,$14		; $4453
	jr _label_07_030		; $4455
	call $46cf		; $4457
	ld e,$18		; $445a
_label_07_030:
	ldh a,(<hActiveObjectType)	; $445c
	add $3e			; $445e
	ld l,a			; $4460
	ld h,d			; $4461
	ld c,$2a		; $4462
	ld a,(bc)		; $4464
	or (hl)			; $4465
	ld (bc),a		; $4466
	ld a,e			; $4467
	jp $46ef		; $4468
	ld hl,$101c		; $446b
	jr _label_07_032		; $446e
	ld hl,$141c		; $4470
	jr _label_07_032		; $4473
	ld hl,$181c		; $4475
	jr _label_07_032		; $4478
	call $46cf		; $447a
	ld hl,$1010		; $447d
	jr _label_07_032		; $4480
	call $46cf		; $4482
	ld hl,setTileInRoomLayoutBuffer		; $4485
	jr _label_07_032		; $4488
	call $46cf		; $448a
	ld hl,$1034		; $448d
	jr _label_07_032		; $4490
	call $46cf		; $4492
	ld hl,$1434		; $4495
	jr _label_07_032		; $4498
	call $46cf		; $449a
	ld hl,$1834		; $449d
	jr _label_07_032		; $44a0
	call $46cf		; $44a2
	ld hl,$1818		; $44a5
	jr _label_07_032		; $44a8
	call $46cf		; $44aa
	ld hl,$1c28		; $44ad
	jr _label_07_032		; $44b0
	ld hl,$0c04		; $44b2
	jr _label_07_032		; $44b5
	ld hl,$2834		; $44b7
	jr _label_07_032		; $44ba
	ld hl,$2034		; $44bc
	jr _label_07_032		; $44bf
	ld h,b			; $44c1
	ld l,$01		; $44c2
	ld a,(hl)		; $44c4
	cp $28			; $44c5
	jr nc,_label_07_031	; $44c7
	ld l,$24		; $44c9
	res 7,(hl)		; $44cb
_label_07_031:
	call $479f		; $44cd
	ret z			; $44d0
	ld hl,$2444		; $44d1
	jr _label_07_032		; $44d4
	ld hl,$1c24		; $44d6
_label_07_032:
	ld a,h			; $44d9
	push hl			; $44da
	call $47c8		; $44db
	pop hl			; $44de
	ld a,l			; $44df
	jp $46ef		; $44e0
	ld hl,$1c34		; $44e3
	jr _label_07_032		; $44e6
	ld h,b			; $44e8
	ld l,$24		; $44e9
	res 7,(hl)		; $44eb
	call $479f		; $44ed
	ret z			; $44f0
	call $46c2		; $44f1
	ld hl,$1c2c		; $44f4
	jr _label_07_032		; $44f7
	ld h,b			; $44f9
	ld l,$24		; $44fa
	res 7,(hl)		; $44fc
	call $479f		; $44fe
	ret z			; $4501
	ld hl,$1c38		; $4502
	jr _label_07_032		; $4505
	ld e,$ad		; $4507
	ld a,(de)		; $4509
	or a			; $450a
	ret nz			; $450b
	ld a,($d001)		; $450c
	or a			; $450f
	ret nz			; $4510
	ld a,($cc88)		; $4511
	or a			; $4514
	ret nz			; $4515
	ld a,$0d		; $4516
	ld ($cc6a),a		; $4518
	ld hl,$2c1c		; $451b
	jr _label_07_032		; $451e
	ld hl,$1c3c		; $4520
	jr _label_07_032		; $4523
	ld hl,$1430		; $4525
	jr _label_07_032		; $4528
	ld hl,$3004		; $452a
	jr _label_07_032		; $452d
	ld hl,$1c44		; $452f
	jr _label_07_032		; $4532
_label_07_033:
	ld hl,$1c1c		; $4534
	jr _label_07_032		; $4537
	ld h,d			; $4539
	ldh a,(<hActiveObjectType)	; $453a
	add $29			; $453c
	ld l,a			; $453e
	ld a,(hl)		; $453f
	or a			; $4540
	jr z,_label_07_033	; $4541
	ld a,l			; $4543
	add $05			; $4544
	ld l,a			; $4546
	xor a			; $4547
	ldd (hl),a		; $4548
	ldd (hl),a		; $4549
	ldh a,(<hFF8A)	; $454a
	xor $10			; $454c
	ld (hl),a		; $454e
	res 3,l			; $454f
	res 7,(hl)		; $4551
	ld a,l			; $4553
	add $e0			; $4554
	ld l,a			; $4556
	ld (hl),$03		; $4557
	inc l			; $4559
	ld (hl),$00		; $455a
	ld h,b			; $455c
	ld l,$2a		; $455d
	set 5,(hl)		; $455f
	ld l,$24		; $4561
	res 7,(hl)		; $4563
	ld l,$18		; $4565
	ldh a,(<hActiveObjectType)	; $4567
	ldi (hl),a		; $4569
	ld (hl),d		; $456a
	ret			; $456b
	ldh a,(<hActiveObjectType)	; $456c
	add $29			; $456e
	ld l,a			; $4570
	ld h,d			; $4571
	ld (hl),$00		; $4572
	ret			; $4574
	ldh a,(<hActiveObjectType)	; $4575
	add $2a			; $4577
	ld e,a			; $4579
	ldh a,(<hFF90)	; $457a
	or $80			; $457c
	ld (de),a		; $457e
	ld a,e			; $457f
	add $ec			; $4580
	ld l,a			; $4582
	ld h,d			; $4583
	ld (hl),c		; $4584
	inc l			; $4585
	ld (hl),b		; $4586
	ld c,$2a		; $4587
	ld a,$01		; $4589
	ld (bc),a		; $458b
	ret			; $458c
	call $4631		; $458d
	ld a,l			; $4590
	add $1b			; $4591
	ld l,a			; $4593
	set 7,(hl)		; $4594
	ld c,$2a		; $4596
	ld a,$02		; $4598
	ld (bc),a		; $459a
	ret			; $459b
	ld h,b			; $459c
	ld l,$24		; $459d
	res 7,(hl)		; $459f
	call $479f		; $45a1
	ret z			; $45a4
	ld h,d			; $45a5
	ld l,$aa		; $45a6
	ld (hl),$9e		; $45a8
	ld l,$ae		; $45aa
	ld (hl),$00		; $45ac
	ld l,$a4		; $45ae
	res 7,(hl)		; $45b0
	ld l,$84		; $45b2
	ld (hl),$05		; $45b4
	ld l,$9a		; $45b6
	ld a,(hl)		; $45b8
	and $c0			; $45b9
	or $02			; $45bb
	ld (hl),a		; $45bd
	ld l,$87		; $45be
	ld (hl),$1e		; $45c0
	ld l,$90		; $45c2
	ld (hl),$05		; $45c4
	ld l,$94		; $45c6
	ld (hl),$00		; $45c8
	inc l			; $45ca
	ld (hl),$fa		; $45cb
	ld l,$8b		; $45cd
	ld c,$0b		; $45cf
	ld a,(bc)		; $45d1
	ldi (hl),a		; $45d2
	inc l			; $45d3
	ld c,$0d		; $45d4
	ld a,(bc)		; $45d6
	ldi (hl),a		; $45d7
	inc l			; $45d8
	ld a,(hl)		; $45d9
	rlca			; $45da
	jr c,_label_07_034	; $45db
	ld (hl),$ff		; $45dd
_label_07_034:
	call getRandomNumber		; $45df
	and $18			; $45e2
	ld e,$89		; $45e4
	ld (de),a		; $45e6
	ld a,$1c		; $45e7
	jp $47c8		; $45e9
	ld h,b			; $45ec
	ld l,$2d		; $45ed
	ld a,d			; $45ef
	cp (hl)			; $45f0
	ret z			; $45f1
	ldd (hl),a		; $45f2
	ld e,$e1		; $45f3
	ld a,(de)		; $45f5
	ldd (hl),a		; $45f6
	dec l			; $45f7
	set 4,(hl)		; $45f8
	ld e,$ea		; $45fa
	ldh a,(<hFF90)	; $45fc
	or $80			; $45fe
	ld (de),a		; $4600
	ret			; $4601
	ld h,b			; $4602
	ld l,$2f		; $4603
	set 5,(hl)		; $4605
	ret			; $4607
	ld a,$34		; $4608
	jp $46ef		; $460a
	ld hl,$3448		; $460d
	jr _label_07_035		; $4610
	ld hl,$384c		; $4612
_label_07_035:
	call $44d9		; $4615
	jp $46cf		; $4618
	call $46c2		; $461b
	ld h,b			; $461e
	ld l,$24		; $461f
	res 7,(hl)		; $4621
	ld hl,$1c2c		; $4623
	call $44d9		; $4626
	jr _label_07_036		; $4629
	ld hl,$1c1c		; $462b
	call $44d9		; $462e
_label_07_036:
	ld h,d			; $4631
	ldh a,(<hActiveObjectType)	; $4632
	add $29			; $4634
	ld l,a			; $4636
	ld (hl),$00		; $4637
	add $fb			; $4639
	ld l,a			; $463b
	res 7,(hl)		; $463c
	ret			; $463e
	ld h,d			; $463f
	ldh a,(<hActiveObjectType)	; $4640
	add $2a			; $4642
	ld l,a			; $4644
	ld (hl),$a0		; $4645
	add $fa			; $4647
	ld l,a			; $4649
	res 7,(hl)		; $464a
	ld a,$1e		; $464c
	call cpActiveRing		; $464e
	ld a,$f8		; $4651
	jr nz,_label_07_037	; $4653
	xor a			; $4655
_label_07_037:
	ld hl,$d025		; $4656
	ld (hl),a		; $4659
	ld l,$2c		; $465a
	ldh a,(<hFF8A)	; $465c
	ld (hl),a		; $465e
	ld l,$2d		; $465f
	ld (hl),$08		; $4661
	ld l,$2b		; $4663
	ld (hl),$0c		; $4665
	ld a,($ccf2)		; $4667
	or a			; $466a
	jr nz,_label_07_038	; $466b
	inc a			; $466d
	ld ($ccf2),a		; $466e
_label_07_038:
	ld h,b			; $4671
	ld l,$24		; $4672
	res 7,(hl)		; $4674
	ld a,$1c		; $4676
	jp $47c8		; $4678
	ldh a,(<hActiveObjectType)	; $467b
	add $2b			; $467d
	ld e,a			; $467f
	ld a,(de)		; $4680
	or a			; $4681
	ret nz			; $4682
	ld a,($cc88)		; $4683
	or a			; $4686
	ret nz			; $4687
	ld a,($d004)		; $4688
	cp $01			; $468b
	ret nz			; $468d
	ld a,e			; $468e
	add $f9			; $468f
	ld e,a			; $4691
	xor a			; $4692
	ld (de),a		; $4693
	ld a,$0c		; $4694
	ld ($cc6a),a		; $4696
	ld a,$1c		; $4699
	jp $46ef		; $469b
	ld h,d			; $469e
	ldh a,(<hActiveObjectType)	; $469f
	add $24			; $46a1
	ld l,a			; $46a3
	res 7,(hl)		; $46a4
	add $e2			; $46a6
	ld l,a			; $46a8
	ld (hl),$60		; $46a9
	add $09			; $46ab
	ld l,a			; $46ad
	ld (hl),$00		; $46ae
	ld a,$1c		; $46b0
	jp $46ef		; $46b2
	ret			; $46b5
	ld a,$02		; $46b6
	call setLinkIDOverride		; $46b8
	ld a,$1c		; $46bb
	jp $46ef		; $46bd
	ret			; $46c0
	ret			; $46c1
	call getFreePartSlot		; $46c2
	ret nz			; $46c5
	ld (hl),$12		; $46c6
	ld l,$d6		; $46c8
	ldh a,(<hActiveObjectType)	; $46ca
	ldi (hl),a		; $46cc
	ld (hl),d		; $46cd
	ret			; $46ce
	call getFreeInteractionSlot		; $46cf
	jr nz,_label_07_039	; $46d2
	ld (hl),$07		; $46d4
	ldh a,(<hFF8F)	; $46d6
	ld l,a			; $46d8
	ldh a,(<hFF8D)	; $46d9
	sub l			; $46db
	sra a			; $46dc
	add l			; $46de
	ld l,$4b		; $46df
	ldi (hl),a		; $46e1
	ldh a,(<hFF8E)	; $46e2
	ld l,a			; $46e4
	ldh a,(<hFF8C)	; $46e5
	sub l			; $46e7
	sra a			; $46e8
	add l			; $46ea
	ld l,$4d		; $46eb
	ld (hl),a		; $46ed
_label_07_039:
	ret			; $46ee
	ld hl,$4747		; $46ef
	rst_addAToHl			; $46f2
	ldh a,(<hActiveObjectType)	; $46f3
	add $29			; $46f5
	ld e,a			; $46f7
	bit 7,(hl)		; $46f8
	jr z,_label_07_041	; $46fa
	ld c,$28		; $46fc
	ld a,(bc)		; $46fe
	ld c,a			; $46ff
	ld a,(de)		; $4700
	add c			; $4701
	jr c,_label_07_040	; $4702
	xor a			; $4704
_label_07_040:
	ld (de),a		; $4705
	jr nz,_label_07_041	; $4706
	ld c,e			; $4708
	ld a,e			; $4709
	add $fb			; $470a
	ld e,a			; $470c
	ld a,(de)		; $470d
	res 7,a			; $470e
	ld (de),a		; $4710
	ld e,c			; $4711
_label_07_041:
	inc e			; $4712
	ldi a,(hl)		; $4713
	ld c,a			; $4714
	bit 6,c			; $4715
	jr z,_label_07_042	; $4717
	ldh a,(<hFF90)	; $4719
	or $80			; $471b
	ld (de),a		; $471d
_label_07_042:
	inc e			; $471e
	ldi a,(hl)		; $471f
	bit 5,c			; $4720
	jr z,_label_07_043	; $4722
	ld (de),a		; $4724
_label_07_043:
	inc e			; $4725
	inc e			; $4726
	bit 4,c			; $4727
	ldi a,(hl)		; $4729
	jr z,_label_07_044	; $472a
	ld (de),a		; $472c
	ldh a,(<hFF8A)	; $472d
	xor $10			; $472f
	dec e			; $4731
	ld (de),a		; $4732
	inc e			; $4733
_label_07_044:
	inc e			; $4734
	ldi a,(hl)		; $4735
	bit 3,c			; $4736
	jr z,_label_07_045	; $4738
	ld (de),a		; $473a
_label_07_045:
	ld a,c			; $473b
	and $07			; $473c
	ret z			; $473e
	ld hl,$4797		; $473f
	rst_addAToHl			; $4742
	ld a,(hl)		; $4743
	jp playSound		; $4744
	pop af			; $4747
	stop			; $4748
	ld ($f100),sp		; $4749
	dec d			; $474c
	dec bc			; $474d
	nop			; $474e
	pop af			; $474f
	ld a,(de)		; $4750
	rrca			; $4751
	nop			; $4752
	pop af			; $4753
	jr nz,_label_07_046	; $4754
_label_07_046:
	nop			; $4756
	ld (hl),b		; $4757
	ld a,($ff00+$08)	; $4758
	nop			; $475a
	ld (hl),b		; $475b
.DB $eb				; $475c
	dec bc			; $475d
	nop			; $475e
	ld (hl),b		; $475f
	and $0f			; $4760
	nop			; $4762
	ld b,b			; $4763
	nop			; $4764
	nop			; $4765
	nop			; $4766
	pop hl			; $4767
	jr nz,_label_07_047	; $4768
_label_07_047:
	nop			; $476a
	add hl,hl		; $476b
	ld a,($ff00+$00)	; $476c
	ld a,b			; $476e
	ld h,b			; $476f
.DB $ec				; $4770
	nop			; $4771
	nop			; $4772
	add sp,-$5a		; $4773
	nop			; $4775
	ld e,d			; $4776
	ld a,($ff00+c)		; $4777
	jr nz,_label_07_048	; $4778
_label_07_048:
	nop			; $477a
	ld h,b			; $477b
.DB $e4				; $477c
	nop			; $477d
	nop			; $477e
	add hl,hl		; $477f
	ld a,($ff00+$00)	; $4780
	ld a,($ff00+$a9)	; $4782
	jr _label_07_049		; $4784
_label_07_049:
	ld a,b			; $4786
.DB $e3				; $4787
	jr nz,_label_07_050	; $4788
_label_07_050:
	nop			; $478a
	ld d,b			; $478b
	nop			; $478c
	nop			; $478d
	nop			; $478e
	ld (hl),b		; $478f
	rst $30			; $4790
	rlca			; $4791
	nop			; $4792
	ld (hl),b		; $4793
	push af			; $4794
	add hl,bc		; $4795
	nop			; $4796
	nop			; $4797
	ld c,(hl)		; $4798
	ld h,e			; $4799
	ld e,b			; $479a
	nop			; $479b
	nop			; $479c
	nop			; $479d
	nop			; $479e
	ld c,$01		; $479f
	ld a,(bc)		; $47a1
	cp $24			; $47a2
	ret nz			; $47a4
	ldh a,(<hActiveObjectType)	; $47a5
	add $3f			; $47a7
	ld e,a			; $47a9
	ld a,(de)		; $47aa
	cpl			; $47ab
	bit 5,a			; $47ac
	ret nz			; $47ae
	ld h,b			; $47af
	ld l,$2a		; $47b0
	ld (hl),$40		; $47b2
	ld l,$24		; $47b4
	res 7,(hl)		; $47b6
	ldh a,(<hActiveObjectType)	; $47b8
	add $2a			; $47ba
	ld e,a			; $47bc
	ld a,$9a		; $47bd
	ld (de),a		; $47bf
	ld a,e			; $47c0
	add $04			; $47c1
	ld e,a			; $47c3
	xor a			; $47c4
	ld (de),a		; $47c5
	ret			; $47c6
	ld a,e			; $47c7
	push af			; $47c8
	ldh a,(<hActiveObjectType)	; $47c9
	add $3e			; $47cb
	ld e,a			; $47cd
	ld a,(de)		; $47ce
	ld ($cec0),a		; $47cf
	pop af			; $47d2
	ld hl,$4816		; $47d3
	rst_addAToHl			; $47d6
	bit 7,(hl)		; $47d7
	jr z,_label_07_051	; $47d9
	ldh a,(<hActiveObjectType)	; $47db
	add $28			; $47dd
	ld e,a			; $47df
	ld a,(de)		; $47e0
	ld c,$25		; $47e1
	ld (bc),a		; $47e3
_label_07_051:
	ldi a,(hl)		; $47e4
	ld e,a			; $47e5
	ld c,$2a		; $47e6
	ld a,(bc)		; $47e8
	ld c,a			; $47e9
	ld a,($cec0)		; $47ea
	or c			; $47ed
	ld c,$2a		; $47ee
	ld (bc),a		; $47f0
	inc c			; $47f1
	ldi a,(hl)		; $47f2
	bit 5,e			; $47f3
	jr z,_label_07_052	; $47f5
	ld (bc),a		; $47f7
_label_07_052:
	inc c			; $47f8
	ldh a,(<hFF8A)	; $47f9
	ld (bc),a		; $47fb
	inc c			; $47fc
	ldi a,(hl)		; $47fd
	bit 4,e			; $47fe
	jr z,_label_07_053	; $4800
	ld (bc),a		; $4802
_label_07_053:
	inc c			; $4803
	ldi a,(hl)		; $4804
	bit 4,e			; $4805
	jr z,_label_07_054	; $4807
	ld (bc),a		; $4809
_label_07_054:
	ld a,e			; $480a
	and $07			; $480b
	ret z			; $480d
	ld hl,$4852		; $480e
	rst_addAToHl			; $4811
	ld a,(hl)		; $4812
	jp playSound		; $4813
	or d			; $4816
	add hl,de		; $4817
	rlca			; $4818
	nop			; $4819
	or d			; $481a
	ldi (hl),a		; $481b
	rrca			; $481c
	nop			; $481d
	or d			; $481e
	ldi a,(hl)		; $481f
	dec d			; $4820
	nop			; $4821
	or d			; $4822
	jr nz,_label_07_055	; $4823
_label_07_055:
	nop			; $4825
	ld sp,$0bf8		; $4826
	nop			; $4829
	ld sp,$13f1		; $482a
	nop			; $482d
	ld sp,$19ea		; $482e
	nop			; $4831
	ld b,b			; $4832
	nop			; $4833
	nop			; $4834
	nop			; $4835
	inc bc			; $4836
	nop			; $4837
	nop			; $4838
	nop			; $4839
	ret nz			; $483a
	nop			; $483b
	nop			; $483c
	nop			; $483d
	inc de			; $483e
	nop			; $483f
	stop			; $4840
	nop			; $4841
	ld h,d			; $4842
.DB $f4				; $4843
	nop			; $4844
	nop			; $4845
	ret nz			; $4846
	nop			; $4847
	nop			; $4848
	nop			; $4849
	ld sp,$06fa		; $484a
	nop			; $484d
	ld sp,$08f8		; $484e
	nop			; $4851
	nop			; $4852
	ld d,d			; $4853
	ld e,a			; $4854
	ld e,b			; $4855
	ld d,d			; $4856
	ld d,d			; $4857
	ld d,d			; $4858
	ld d,d			; $4859

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


	.include "data/seasons/itemAttributes.s"
	.include "data/itemAnimations.s"

.ends


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
