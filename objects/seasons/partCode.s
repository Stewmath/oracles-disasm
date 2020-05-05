; ==============================================================================
; PARTID_HOLES_FLOORTRAP
; Variables:
;   var30 - pointer to tile at part's position
;   $ccbf - set to 1 when button in hallway to D3 miniboss is pressed
; ==============================================================================
partCode0a:
	ld e,Part.subid		; $62cf
	ld a,(de)		; $62d1
	rst_jumpTable			; $62d2
	.dw @subid0
	.dw @subidStub
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
	ld e,Part.state		; $62dd
	ld a,(de)		; $62df
	rst_jumpTable			; $62e0
	.dw @@state0
	.dw @@state1
@@state0:
	call @init_StoreTileAtPartInVar30		; $62e5
	ld l,Part.counter1		; $62e8
	ld (hl),$08		; $62ea
	ret			; $62ec
@@state1:
	; Proceed once button in D3 hallway to miniboss stepped on
	ld a,($ccbf)		; $62ed
	or a			; $62f0
	ret z			; $62f1

	call @breakFloorsAtInterval		; $62f2
	ret nz			; $62f5

	call @spreadVertical		; $62f6
	ret z			; $62f9

	call @spreadHorizontal		; $62fa
	ret z			; $62fd
	jp partDelete		; $62fe

@subidStub:
	jp partDelete		; $6301

@subid2:
@subid3:
	ld e,Part.state		; $6304
	ld a,(de)		; $6306
	rst_jumpTable			; $6307
	.dw @@state0
	.dw @@state1
@@state0:
	call @init_StoreTileAtPartInVar30		; $630c
	ld l,Part.counter1		; $630f
	ld (hl),$20		; $6311
	ret			; $6313
@@state1:
	ld a,($ccbf)		; $6314
	or a			; $6317
	ret z			; $6318
	call @breakFloorsAtInterval		; $6319
	ret nz			; $631c
	call seasonsFunc_10_63ed		; $631d
	ret nz			; $6320
	jp partDelete		; $6321

@subid4:
	ld h,d			; $6324
	ld l,Part.state		; $6325
	ld a,(hl)		; $6327
	or a			; $6328
	jr nz,+			; $6329
	; state 0
	ld (hl),$01		; $632b
	ld l,Part.counter1		; $632d
	ld (hl),$08		; $632f
	inc l			; $6331
	ld (hl),$00		; $6332
	call @@setPositionToCrackTile		; $6334
+
	; state 1
	ld a,$3c		; $6337
	call setScreenShakeCounter		; $6339
	call partCommon_decCounter1IfNonzero		; $633c
	ret nz			; $633f
	ld l,Part.yh		; $6340
	ld c,(hl)		; $6342
	ld a,TILEINDEX_BLANK_HOLE		; $6343
	call breakCrackedFloor		; $6345
@@setPositionToCrackTile:
	ld e,Part.counter2		; $6348
	ld a,(de)		; $634a
	ld hl,@@crackedTileTable		; $634b
	rst_addDoubleIndex			; $634e
	ld a,(hl)		; $634f
	or a			; $6350
	jp z,partDelete		; $6351

	ldi a,(hl)		; $6354
	ld e,Part.counter1		; $6355
	ld (de),a		; $6357

	ld a,(hl)		; $6358
	ld e,Part.yh		; $6359
	ld (de),a		; $635b

	ld h,d			; $635c
	ld l,Part.counter2		; $635d
	inc (hl)		; $635f
	ret			; $6360
@@crackedTileTable:
	; counter1 - position of tile to break
	.db $1e $91
	.db $1e $81
	.db $01 $82
	.db $1d $71
	.db $01 $61
	.db $1d $83
	.db $01 $51
	.db $1d $84
	.db $01 $52
	.db $1d $85
	.db $01 $53
	.db $1d $86
	.db $01 $63
	.db $1d $87
	.db $01 $64
	.db $1d $88
	.db $01 $65
	.db $1d $89
	.db $01 $55
	.db $1d $79
	.db $01 $45
	.db $1d $69
	.db $01 $35
	.db $01 $68
	.db $1c $6a
	.db $01 $25
	.db $01 $58
	.db $1c $6b
	.db $01 $48
	.db $1d $5b
	.db $1e $38
	.db $1e $37
	.db $1e $36
	.db $00

@init_StoreTileAtPartInVar30:
	ld a,$01		; $63a4
	ld (de),a		; $63a6

	ld h,d			; $63a7
	ld l,Part.yh		; $63a8
	ld a,(hl)		; $63aa
	ld c,a			; $63ab

	ld b,>wRoomLayout		; $63ac
	ld a,(bc)		; $63ae

	ld l,Part.var30		; $63af
	ld (hl),a		; $63b1
	ret			; $63b2

@breakFloorsAtInterval:
	call partCommon_decCounter1IfNonzero		; $63b3
	ret nz			; $63b6

	; counter back to $08
	ld (hl),$08		; $63b7
	ld l,Part.var30		; $63b9
	ld a,TILEINDEX_CRACKED_FLOOR		; $63bb
	cp (hl)			; $63bd
	ld a,TILEINDEX_HOLE		; $63be
	jr z,+			; $63c0
	ld a,TILEINDEX_BLANK_HOLE		; $63c2
+
	ld l,Part.yh		; $63c4
	ld c,(hl)		; $63c6
	call breakCrackedFloor		; $63c7

	; proceed to below function
	xor a			; $63ca
	ret			; $63cb

@spreadVertical:
	ld h,$10		; $63cc
	jr @spread			; $63ce
@spreadHorizontal:
	ld h,$01		; $63d0
@spread:
	ld b,>wRoomLayout		; $63d2
	ld e,Part.var30		; $63d4
	ld a,(de)		; $63d6
	ld l,a			; $63d7

	ld e,Part.yh		; $63d8
	ld a,(de)		; $63da
	ld e,a			; $63db

	sub h			; $63dc
	ld c,a			; $63dd
	ld a,(bc)		; $63de
	cp l			; $63df
	jr z,+			; $63e0

	ld a,e			; $63e2
	add h			; $63e3
	ld c,a			; $63e4
	ld a,(bc)		; $63e5
	cp l			; $63e6
	ret nz			; $63e7
+
	ld a,c			; $63e8
	ld e,Part.yh		; $63e9
	ld (de),a		; $63eb
	ret			; $63ec

seasonsFunc_10_63ed:
	ld e,Part.var30		; $63ed
	ld a,(de)		; $63ef
	ld b,a			; $63f0
	ld c,$10		; $63f1
	ld hl,wRoomLayout		; $63f3
--
	ld a,b			; $63f6
	cp (hl)			; $63f7
	jr z,++			; $63f8
	ld a,l			; $63fa
	cp $ae			; $63fb
	ret z			; $63fd
	add c			; $63fe
	cp $f0			; $63ff
	jr nc,+			; $6401
	cp $b0			; $6403
	jr nc,+			; $6405
	ld l,a			; $6407
	jr --			; $6408
+
	ld a,c			; $640a
	cpl			; $640b
	inc a			; $640c
	ld c,a			; $640d
	ld a,l			; $640e
	add c			; $640f
	inc a			; $6410
	ld l,a			; $6411
	jr --			; $6412
++
	ld a,l			; $6414
	ld e,Part.yh		; $6415
	ld (de),a		; $6417
	or d			; $6418
	ret			; $6419


partCode0d:
	jr z,_label_10_257	; $641a
	call objectSetVisible83		; $641c
	ld h,d			; $641f
	ld l,$c6		; $6420
	ld (hl),$2d		; $6422
	ld l,$c2		; $6424
	ld a,(hl)		; $6426
	ld b,a			; $6427
	and $07			; $6428
	ld hl,$ccba		; $642a
	call setFlag		; $642d
	bit 7,b			; $6430
	jr z,_label_10_257	; $6432
	ld e,$c4		; $6434
	ld a,$02		; $6436
	ld (de),a		; $6438
_label_10_257:
	ld e,$c4		; $6439
	ld a,(de)		; $643b
	rst_jumpTable			; $643c
	ld b,e			; $643d
	ld h,h			; $643e
	ld b,a			; $643f
	ld h,h			; $6440
	jr nc,$1e		; $6441
	ld a,$01		; $6443
	ld (de),a		; $6445
	ret			; $6446
	call partCommon_decCounter1IfNonzero		; $6447
	ret nz			; $644a
	ld e,$c2		; $644b
	ld a,(de)		; $644d
	ld hl,$ccba		; $644e
	call unsetFlag		; $6451
	jp objectSetInvisible		; $6454

partCode16:
	jr z,_label_10_259	; $6457
	ld h,d			; $6459
	ld l,$c4		; $645a
	ld (hl),$02		; $645c
	ld l,$c6		; $645e
	ld (hl),$14		; $6460
	ld l,$e4		; $6462
	ld (hl),$00		; $6464
	call getThisRoomFlags		; $6466
	and $c0			; $6469
	cp $80			; $646b
	jr nz,_label_10_258	; $646d
	ld a,($cd00)		; $646f
	and $01			; $6472
	jr z,_label_10_258	; $6474
	ld a,($cc34)		; $6476
	or a			; $6479
	jp nz,$6498		; $647a
	call $6515		; $647d
	inc a			; $6480
	ld ($ccab),a		; $6481
	ld ($cca4),a		; $6484
	ld ($cbca),a		; $6487
	inc a			; $648a
	ld ($cfd0),a		; $648b
	ld a,$08		; $648e
	ld ($cfc0),a		; $6490
_label_10_258:
	ld a,$01		; $6493
	ld ($cc36),a		; $6495
_label_10_259:
	ld hl,$cfd0		; $6498
	ld a,(hl)		; $649b
	inc a			; $649c
	jp z,partDelete		; $649d
	ld e,$c4		; $64a0
	ld a,(de)		; $64a2
	rst_jumpTable			; $64a3
	xor d			; $64a4
	ld h,h			; $64a5
	xor l			; $64a6
	ld h,h			; $64a7
	cp c			; $64a8
	ld h,h			; $64a9
	ld a,$01		; $64aa
	ld (de),a		; $64ac
	ld a,($cc48)		; $64ad
	ld h,a			; $64b0
	ld l,$00		; $64b1
	call preventObjectHFromPassingObjectD		; $64b3
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $64b6
	call $64ad		; $64b9
	ld hl,$cfd0		; $64bc
	ld a,(hl)		; $64bf
	cp $02			; $64c0
	ret z			; $64c2
	ld e,$c5		; $64c3
	ld a,(de)		; $64c5
	or a			; $64c6
	jr nz,_label_10_260	; $64c7
	call partCommon_decCounter1IfNonzero		; $64c9
	ret nz			; $64cc
	ld (hl),$b4		; $64cd
	inc l			; $64cf
	ld (hl),$08		; $64d0
	ld l,$f0		; $64d2
	ld (hl),$08		; $64d4
	ld l,e			; $64d6
	inc (hl)		; $64d7
	ret			; $64d8
_label_10_260:
	call partCommon_decCounter1IfNonzero		; $64d9
	jr nz,_label_10_261	; $64dc
	ld a,($cd00)		; $64de
	and $01			; $64e1
	jr z,_label_10_261	; $64e3
	ld a,($cc34)		; $64e5
	or a			; $64e8
	jp nz,$64fc		; $64e9
	call $6515		; $64ec
	inc a			; $64ef
	ld ($ccab),a		; $64f0
	ld ($cfd0),a		; $64f3
	ld ($cca4),a		; $64f6
	ld ($cbca),a		; $64f9
_label_10_261:
	ldi a,(hl)		; $64fc
	cp $5a			; $64fd
	jr nz,_label_10_262	; $64ff
	ld e,$f0		; $6501
	ld a,$04		; $6503
	ld (de),a		; $6505
_label_10_262:
	dec (hl)		; $6506
	ret nz			; $6507
	ld e,$f0		; $6508
	ld a,(de)		; $650a
	ld (hl),a		; $650b
	ld l,$dc		; $650c
	ld a,(hl)		; $650e
	dec a			; $650f
	xor $01			; $6510
	inc a			; $6512
	ld (hl),a		; $6513
	ret			; $6514
	ld a,($cc48)		; $6515
	ld b,a			; $6518
	ld c,$2b		; $6519
	ld a,$80		; $651b
	ld (bc),a		; $651d
	ld c,$2d		; $651e
	xor a			; $6520
	ld (bc),a		; $6521
	ret			; $6522

partCode24:
	jr z,_label_10_263	; $6523
	ld e,$ea		; $6525
	ld a,(de)		; $6527
	cp $80			; $6528
	jp nz,partDelete		; $652a
_label_10_263:
	ld e,$c2		; $652d
	ld a,(de)		; $652f
	ld e,$c4		; $6530
	rst_jumpTable			; $6532
	add hl,sp		; $6533
	ld h,l			; $6534
	add hl,sp		; $6535
	ld h,l			; $6536
	ld (hl),d		; $6537
	ld h,l			; $6538
	ld a,(de)		; $6539
	or a			; $653a
	jr z,_label_10_266	; $653b
	call partCommon_decCounter1IfNonzero		; $653d
	ret nz			; $6540
	ld l,$c2		; $6541
	bit 0,(hl)		; $6543
	ld l,$cd		; $6545
	ldh a,(<hEnemyTargetX)	; $6547
	jr nz,_label_10_264	; $6549
	cp (hl)			; $654b
	ret c			; $654c
	jr _label_10_265		; $654d
_label_10_264:
	cp (hl)			; $654f
	ret nc			; $6550
_label_10_265:
	call $65b8		; $6551
	ret nc			; $6554
	call getRandomNumber_noPreserveVars		; $6555
	cp $50			; $6558
	ret nc			; $655a
	call $65a6		; $655b
	ret nz			; $655e
	ld l,$c9		; $655f
	ld (hl),$08		; $6561
	ld e,$c2		; $6563
	ld a,(de)		; $6565
	or a			; $6566
	ret z			; $6567
	ld (hl),$18		; $6568
	ret			; $656a
_label_10_266:
	ld h,d			; $656b
	ld l,e			; $656c
	inc (hl)		; $656d
	ld l,$c6		; $656e
	inc (hl)		; $6570
	ret			; $6571
	ld a,(de)		; $6572
	rst_jumpTable			; $6573
	ld a,d			; $6574
	ld h,l			; $6575
	adc b			; $6576
	ld h,l			; $6577
	adc a			; $6578
	ld h,l			; $6579
	ld h,d			; $657a
	ld l,e			; $657b
	inc (hl)		; $657c
	ld l,$c6		; $657d
	ld (hl),$10		; $657f
	ld l,$e4		; $6581
	set 7,(hl)		; $6583
	jp objectSetVisible81		; $6585
	call partCommon_decCounter1IfNonzero		; $6588
	jr nz,_label_10_267	; $658b
	ld l,e			; $658d
	inc (hl)		; $658e
	call $4072		; $658f
	jp c,partDelete		; $6592
_label_10_267:
	call objectApplySpeed		; $6595
	ld a,(wFrameCounter)		; $6598
	and $03			; $659b
	ret nz			; $659d
	ld e,$dc		; $659e
	ld a,(de)		; $65a0
	inc a			; $65a1
	and $07			; $65a2
	ld (de),a		; $65a4
	ret			; $65a5
	call getFreePartSlot		; $65a6
	ret nz			; $65a9
	ld (hl),$24		; $65aa
	inc l			; $65ac
	ld (hl),$02		; $65ad
	call objectCopyPosition		; $65af
	ld l,$d0		; $65b2
	ld (hl),$3c		; $65b4
	xor a			; $65b6
	ret			; $65b7
	ld l,$cb		; $65b8
	ldh a,(<hEnemyTargetY)	; $65ba
	sub (hl)		; $65bc
	add $10			; $65bd
	cp $21			; $65bf
	ret nc			; $65c1
	ld e,$c6		; $65c2
	ld a,$1e		; $65c4
	ld (de),a		; $65c6
	ret			; $65c7

partCode25:
	ld e,$c4		; $65c8
	ld a,(de)		; $65ca
	or a			; $65cb
	jr nz,_label_10_268	; $65cc
	ld h,d			; $65ce
	ld l,e			; $65cf
	inc (hl)		; $65d0
	ld l,$c2		; $65d1
	ld a,(hl)		; $65d3
	swap a			; $65d4
	rrca			; $65d6
	ld l,$c9		; $65d7
	ld (hl),a		; $65d9
_label_10_268:
	call partCommon_decCounter1IfNonzero		; $65da
	ret nz			; $65dd
	ld e,$c2		; $65de
	ld a,(de)		; $65e0
	bit 0,a			; $65e1
	ld e,$cd		; $65e3
	ldh a,(<hEnemyTargetX)	; $65e5
	jr z,_label_10_269	; $65e7
	ld e,$cb		; $65e9
	ldh a,(<hEnemyTargetY)	; $65eb
_label_10_269:
	ld b,a			; $65ed
	ld a,(de)		; $65ee
	sub b			; $65ef
	add $10			; $65f0
	cp $21			; $65f2
	ret nc			; $65f4
	ld e,$c6		; $65f5
	ld a,$21		; $65f7
	ld (de),a		; $65f9
	ld hl,$6661		; $65fa
	jr _label_10_271		; $65fd

partCode2c:
	ld e,$c4		; $65ff
	ld a,(de)		; $6601
	or a			; $6602
	jr nz,_label_10_270	; $6603
	ld h,d			; $6605
	ld l,e			; $6606
	inc (hl)		; $6607
	ld l,$c2		; $6608
	ld a,(hl)		; $660a
	ld b,a			; $660b
	swap a			; $660c
	rrca			; $660e
	ld l,$c9		; $660f
	ld (hl),a		; $6611
	ld a,b			; $6612
	call partSetAnimation		; $6613
	call getRandomNumber_noPreserveVars		; $6616
	and $30			; $6619
	ld e,$c6		; $661b
	ld (de),a		; $661d
	call objectMakeTileSolid		; $661e
	jp objectSetVisible82		; $6621
_label_10_270:
	ldh a,(<hCameraY)	; $6624
	add $80			; $6626
	ld b,a			; $6628
	ld e,$cb		; $6629
	ld a,(de)		; $662b
	cp b			; $662c
	ret nc			; $662d
	ldh a,(<hCameraX)	; $662e
	add $a0			; $6630
	ld b,a			; $6632
	ld e,$cd		; $6633
	ld a,(de)		; $6635
	cp b			; $6636
	ret nc			; $6637
	call partCommon_decCounter1IfNonzero		; $6638
	ret nz			; $663b
	call getRandomNumber_noPreserveVars		; $663c
	and $60			; $663f
	add $20			; $6641
	ld e,$c6		; $6643
	ld (de),a		; $6645
	ld hl,$6669		; $6646
_label_10_271:
	ld e,$c2		; $6649
	ld a,(de)		; $664b
	rst_addDoubleIndex			; $664c
	ldi a,(hl)		; $664d
	ld b,a			; $664e
	ld c,(hl)		; $664f
	call getFreePartSlot		; $6650
	ret nz			; $6653
	ld (hl),$1a		; $6654
	inc l			; $6656
	inc (hl)		; $6657
	call objectCopyPositionWithOffset		; $6658
	ld l,$c9		; $665b
	ld e,l			; $665d
	ld a,(de)		; $665e
	ld (hl),a		; $665f
	ret			; $6660
.DB $fc				; $6661
	nop			; $6662
	nop			; $6663
	inc b			; $6664
	inc b			; $6665
	nop			; $6666
	nop			; $6667
.DB $fc				; $6668
	ld hl,sp+$00		; $6669
	nop			; $666b
	ld ($0008),sp		; $666c
	nop			; $666f
	.db $f8		; $6670

partCode26:
	.db $28		; $6671
	ld a,(bc)		; $6672
	ld e,$ea		; $6673
	ld a,(de)		; $6675
	res 7,a			; $6676
	cp $03			; $6678
	jp nc,$670c		; $667a
	call $66e7		; $667d
	jp c,$670c		; $6680
	ld e,$c4		; $6683
	ld a,(de)		; $6685
	rst_jumpTable			; $6686
	adc l			; $6687
	ld h,(hl)		; $6688
	and h			; $6689
	ld h,(hl)		; $668a
	push de			; $668b
	ld h,(hl)		; $668c
	ld h,d			; $668d
	ld l,e			; $668e
	inc (hl)		; $668f
	ld l,$d0		; $6690
	ld (hl),$46		; $6692
	ld l,$c6		; $6694
	ld (hl),$16		; $6696
	ld l,$c9		; $6698
	ld (hl),$10		; $669a
	ld a,$73		; $669c
	call playSound		; $669e
	jp objectSetVisible82		; $66a1
	call partCommon_decCounter1IfNonzero		; $66a4
	jr nz,_label_10_272	; $66a7
	ld (hl),$10		; $66a9
	ld l,e			; $66ab
	inc (hl)		; $66ac
	jr $26			; $66ad
_label_10_272:
	ld a,(hl)		; $66af
	rrca			; $66b0
	jr nc,_label_10_273	; $66b1
	ld l,$d0		; $66b3
	ld a,(hl)		; $66b5
	cp $78			; $66b6
	jr z,_label_10_273	; $66b8
	add $05			; $66ba
	ld (hl),a		; $66bc
_label_10_273:
	call objectApplySpeed		; $66bd
	call partAnimate		; $66c0
	ld e,$e1		; $66c3
	ld a,(de)		; $66c5
	ld hl,$66d2		; $66c6
	rst_addAToHl			; $66c9
	ld e,$e6		; $66ca
	ld a,(hl)		; $66cc
	ld (de),a		; $66cd
	inc e			; $66ce
	ld a,(hl)		; $66cf
	ld (de),a		; $66d0
	ret			; $66d1
	ld (bc),a		; $66d2
	inc b			; $66d3
	ld b,$cd		; $66d4
	and a			; $66d6
	ld b,b			; $66d7
	jp z,partDelete		; $66d8
	ld a,(hl)		; $66db
	rrca			; $66dc
	jr nc,_label_10_273	; $66dd
	ld l,$d0		; $66df
	ld a,(hl)		; $66e1
	sub $0a			; $66e2
	ld (hl),a		; $66e4
	jr _label_10_273		; $66e5
	ld e,$e6		; $66e7
	ld a,(de)		; $66e9
	add $09			; $66ea
	ld b,a			; $66ec
	ld e,$e7		; $66ed
	ld a,(de)		; $66ef
	add $09			; $66f0
	ld c,a			; $66f2
	ld hl,$dd0b		; $66f3
	ld e,$cb		; $66f6
	ld a,(de)		; $66f8
	sub (hl)		; $66f9
	add b			; $66fa
	sla b			; $66fb
	inc b			; $66fd
	cp b			; $66fe
	ret nc			; $66ff
	ld l,$0d		; $6700
	ld e,$cd		; $6702
	ld a,(de)		; $6704
	sub (hl)		; $6705
	add c			; $6706
	sla c			; $6707
	inc c			; $6709
	cp c			; $670a
	ret			; $670b
	call objectCreatePuff		; $670c
	jp partDelete		; $670f

partCode2b:
	jr z,_label_10_274	; $6712
	ld e,$ea		; $6714
	ld a,(de)		; $6716
	cp $9a			; $6717
	ret nz			; $6719
	ld hl,$cfc0		; $671a
	set 0,(hl)		; $671d
	jp partDelete		; $671f
_label_10_274:
	ld e,$c4		; $6722
	ld a,(de)		; $6724
	or a			; $6725
	ret nz			; $6726
	inc a			; $6727
	ld (de),a		; $6728
	ld h,d			; $6729
	ld l,$e7		; $672a
	ld (hl),$12		; $672c
	ld l,$ff		; $672e
	set 5,(hl)		; $6730
	ret			; $6732

partCode2d:
	jr z,_label_10_275	; $6733
	ld h,d			; $6735
	ld l,$f0		; $6736
	bit 0,(hl)		; $6738
	jp nz,$67cc		; $673a
	inc (hl)		; $673d
	ld l,$e9		; $673e
	ld (hl),$00		; $6740
	ld l,$c6		; $6742
	ld (hl),$41		; $6744
	jp objectSetInvisible		; $6746
_label_10_275:
	ld e,$c2		; $6749
	ld a,(de)		; $674b
	srl a			; $674c
	ld e,$c4		; $674e
	rst_jumpTable			; $6750
	ld d,l			; $6751
	ld h,a			; $6752
	add l			; $6753
	ld h,a			; $6754
	ld a,(de)		; $6755
	or a			; $6756
	jr nz,_label_10_277	; $6757
_label_10_276:
	ld h,d			; $6759
	ld l,e			; $675a
	inc (hl)		; $675b
	ld l,$cb		; $675c
	res 3,(hl)		; $675e
	ld l,$cd		; $6760
	res 3,(hl)		; $6762
	ld a,$16		; $6764
	call checkGlobalFlag		; $6766
	jp nz,partDelete		; $6769
	ld e,$c2		; $676c
	ld a,(de)		; $676e
	call partSetAnimation		; $676f
	jp objectSetVisible82		; $6772
_label_10_277:
	call partAnimate		; $6775
	ld e,$e1		; $6778
	ld a,(de)		; $677a
	or a			; $677b
	ret z			; $677c
	ld bc,$fa13		; $677d
	dec a			; $6780
	jr z,_label_10_279	; $6781
	jr _label_10_278		; $6783
	ld a,(de)		; $6785
	or a			; $6786
	jr z,_label_10_276	; $6787
	call partAnimate		; $6789
	ld e,$e1		; $678c
	ld a,(de)		; $678e
	or a			; $678f
	ret z			; $6790
	ld bc,$faed		; $6791
	dec a			; $6794
	jr z,_label_10_279	; $6795
_label_10_278:
	call getFreePartSlot		; $6797
	ret nz			; $679a
	ld (hl),$3f		; $679b
	inc l			; $679d
	inc (hl)		; $679e
	call objectCopyPositionWithOffset		; $679f
	jr _label_10_280		; $67a2
_label_10_279:
	ld (de),a		; $67a4
	ld a,$81		; $67a5
	call playSound		; $67a7
	call getFreeInteractionSlot		; $67aa
	ret nz			; $67ad
	ld (hl),$05		; $67ae
	ld l,$42		; $67b0
	ld (hl),$80		; $67b2
	jp objectCopyPositionWithOffset		; $67b4
_label_10_280:
	ld e,$c2		; $67b7
	ld a,(de)		; $67b9
	bit 1,a			; $67ba
	ld b,$04		; $67bc
	jr z,_label_10_281	; $67be
	ld b,$12		; $67c0
_label_10_281:
	call getRandomNumber		; $67c2
	and $06			; $67c5
	add b			; $67c7
	ld l,$c9		; $67c8
	ld (hl),a		; $67ca
	ret			; $67cb
	call partCommon_decCounter1IfNonzero		; $67cc
	jp z,partDelete		; $67cf
	ld a,(hl)		; $67d2
	cp $35			; $67d3
	jr z,_label_10_282	; $67d5
	and $0f			; $67d7
	ret nz			; $67d9
	ld a,(hl)		; $67da
	and $f0			; $67db
	swap a			; $67dd
	dec a			; $67df
	ld hl,$67f0		; $67e0
	rst_addDoubleIndex			; $67e3
	ldi a,(hl)		; $67e4
	ld c,(hl)		; $67e5
	ld b,a			; $67e6
	call getFreeInteractionSlot		; $67e7
	ret nz			; $67ea
	ld (hl),$56		; $67eb
	jp objectCopyPositionWithOffset		; $67ed
	ld hl,sp+$04		; $67f0
	ld ($fafe),sp		; $67f2
	ld hl,sp+$02		; $67f5
	inc c			; $67f7
_label_10_282:
	ld e,$cb		; $67f8
	ld a,(de)		; $67fa
	sub $08			; $67fb
	and $f0			; $67fd
	ld b,a			; $67ff
	ld e,$cd		; $6800
	ld a,(de)		; $6802
	sub $08			; $6803
	and $f0			; $6805
	swap a			; $6807
	or b			; $6809
	ld c,a			; $680a
	ld b,$a2		; $680b
	ld e,$c2		; $680d
	ld a,(de)		; $680f
	bit 1,a			; $6810
	jr z,_label_10_283	; $6812
	ld b,$a6		; $6814
_label_10_283:
	push bc			; $6816
	ld a,b			; $6817
	call setTile		; $6818
	pop bc			; $681b
	ld a,b			; $681c
	inc a			; $681d
	inc c			; $681e
	jp setTile		; $681f

partCode2e:
	ld e,$c4		; $6822
	ld a,(de)		; $6824
	or a			; $6825
	jr z,_label_10_285	; $6826
	ld e,$e1		; $6828
	ld a,(de)		; $682a
	or a			; $682b
	jr z,_label_10_284	; $682c
	bit 7,a			; $682e
	jp nz,partDelete		; $6830
	call $6853		; $6833
_label_10_284:
	jp partAnimate		; $6836
_label_10_285:
	ld a,$01		; $6839
	ld (de),a		; $683b
	call objectGetTileAtPosition		; $683c
	cp $f3			; $683f
	jp z,partDelete		; $6841
	ld h,$ce		; $6844
	ld a,(hl)		; $6846
	or a			; $6847
	jp nz,partDelete		; $6848
	ld a,$98		; $684b
	call playSound		; $684d
	jp objectSetVisible83		; $6850
	push af			; $6853
	xor a			; $6854
	ld (de),a		; $6855
	call objectGetTileAtPosition		; $6856
	pop af			; $6859
	ld e,$f0		; $685a
	dec a			; $685c
	jr z,_label_10_286	; $685d
	ld a,(de)		; $685f
	ld (hl),a		; $6860
	ret			; $6861
_label_10_286:
	ld a,(hl)		; $6862
	ld (de),a		; $6863
	ld (hl),$f3		; $6864
	ret			; $6866

partCode2f:
	ld e,$c4		; $6867
	ld a,(de)		; $6869
	or a			; $686a
	ret nz			; $686b
	inc a			; $686c
	ld (de),a		; $686d
	ld e,$cb		; $686e
	ld a,(de)		; $6870
	sub $02			; $6871
	ld (de),a		; $6873
	ld e,$cd		; $6874
	ld a,(de)		; $6876
	add $03			; $6877
	ld (de),a		; $6879
	ret			; $687a

partCode32:
	jr z,_label_10_287	; $687b
	ld e,$c5		; $687d
	ld a,(de)		; $687f
	or a			; $6880
	jr nz,_label_10_288	; $6881
	call $68cc		; $6883
	ld a,$af		; $6886
	jp playSound		; $6888
_label_10_287:
	ld e,$c4		; $688b
	ld a,(de)		; $688d
	rst_jumpTable			; $688e
	sub e			; $688f
	ld l,b			; $6890
	cp l			; $6891
	ld l,b			; $6892
	ld a,$01		; $6893
	ld (de),a		; $6895
	ld e,$c2		; $6896
	ld a,(de)		; $6898
	call partSetAnimation		; $6899
	call getRandomNumber_noPreserveVars		; $689c
	and $03			; $689f
	ld hl,$68b9		; $68a1
	rst_addAToHl			; $68a4
	ld a,(hl)		; $68a5
	ld e,$d0		; $68a6
	ld (de),a		; $68a8
	call getRandomNumber_noPreserveVars		; $68a9
	and $3f			; $68ac
	add $78			; $68ae
	ld h,d			; $68b0
	ld l,$c6		; $68b1
	ldi (hl),a		; $68b3
	ld (hl),$10		; $68b4
	jp objectSetVisible81		; $68b6
	ld a,(bc)		; $68b9
	rrca			; $68ba
	rrca			; $68bb
	inc d			; $68bc
	ld e,$c5		; $68bd
	ld a,(de)		; $68bf
	or a			; $68c0
	jr nz,_label_10_288	; $68c1
	call objectApplySpeed		; $68c3
	call partCommon_decCounter1IfNonzero		; $68c6
	jp nz,$68e0		; $68c9
	ld h,d			; $68cc
	ld l,$c5		; $68cd
	inc (hl)		; $68cf
	ld a,$02		; $68d0
	jp partSetAnimation		; $68d2
_label_10_288:
	call partAnimate		; $68d5
	ld e,$e1		; $68d8
	ld a,(de)		; $68da
	inc a			; $68db
	jp z,partDelete		; $68dc
	ret			; $68df
	ld h,d			; $68e0
	ld l,$c7		; $68e1
	dec (hl)		; $68e3
	ret nz			; $68e4
	ld (hl),$10		; $68e5
	call getRandomNumber		; $68e7
	and $03			; $68ea
	ret nz			; $68ec
	and $01			; $68ed
	jr nz,_label_10_289	; $68ef
	ld a,$ff		; $68f1
_label_10_289:
	ld l,$c9		; $68f3
	add (hl)		; $68f5
	ld (hl),a		; $68f6
	ret			; $68f7

partCode33:
	ld e,$c4		; $68f8
	ld a,(de)		; $68fa
	rst_jumpTable			; $68fb
	ld (bc),a		; $68fc
	ld l,c			; $68fd
	jr c,_label_10_293	; $68fe
	ld c,l			; $6900
	ld l,c			; $6901
	ld h,d			; $6902
	ld l,e			; $6903
	inc (hl)		; $6904
	ld l,$d0		; $6905
	ld (hl),$50		; $6907
	ld b,$00		; $6909
	ld a,($cc45)		; $690b
	and $30			; $690e
	jr z,_label_10_290	; $6910
	ld b,$20		; $6912
	and $20			; $6914
	jr z,_label_10_290	; $6916
	ld b,$e0		; $6918
_label_10_290:
	ld a,($d00d)		; $691a
	add b			; $691d
	ld c,a			; $691e
	sub $08			; $691f
	cp $90			; $6921
	jr c,_label_10_291	; $6923
	ld c,$08		; $6925
	cp $d0			; $6927
	jr nc,_label_10_291	; $6929
	ld c,$98		; $692b
_label_10_291:
	ld b,$a0		; $692d
	call objectGetRelativeAngle		; $692f
	ld e,$c9		; $6932
	ld (de),a		; $6934
	jp objectSetVisible81		; $6935
	call objectApplySpeed		; $6938
	ld e,$cb		; $693b
	ld a,(de)		; $693d
	cp $98			; $693e
	jr c,_label_10_292	; $6940
	ld h,d			; $6942
	ld l,$c4		; $6943
	inc (hl)		; $6945
	ld l,$c6		; $6946
	ld (hl),$78		; $6948
_label_10_292:
	jp partAnimate		; $694a
	call partCommon_decCounter1IfNonzero		; $694d
	jp z,partDelete		; $6950
	jr _label_10_292		; $6953

partCode38:
	ld e,$d7		; $6955
	ld a,(de)		; $6957
	or a			; $6958
	jp z,partDelete		; $6959
	ld e,$c4		; $695c
	ld a,(de)		; $695e
	rst_jumpTable			; $695f
	ld l,b			; $6960
	ld l,c			; $6961
	add b			; $6962
	ld l,c			; $6963
	adc c			; $6964
	ld l,c			; $6965
	or a			; $6966
	ld l,c			; $6967
	ld h,d			; $6968
_label_10_293:
	ld l,e			; $6969
	inc (hl)		; $696a
	ld l,$d0		; $696b
	ld (hl),$50		; $696d
	ld l,$c6		; $696f
	ld (hl),$14		; $6971
	ld a,$08		; $6973
	call objectGetRelatedObject1Var		; $6975
	ld a,(hl)		; $6978
	or a			; $6979
	jp z,objectSetVisible82		; $697a
	jp objectSetVisible81		; $697d
	call partCommon_decCounter1IfNonzero		; $6980
	ret nz			; $6983
	ld l,e			; $6984
	inc (hl)		; $6985
	call objectSetVisible81		; $6986
	ld h,d			; $6989
	ld l,$f0		; $698a
	ld b,(hl)		; $698c
	inc l			; $698d
	ld c,(hl)		; $698e
	call objectGetRelativeAngle		; $698f
	ld e,$c9		; $6992
	ld (de),a		; $6994
	ld h,d			; $6995
	ld l,$f0		; $6996
	ld e,$cb		; $6998
	ld a,(de)		; $699a
	sub (hl)		; $699b
	add $08			; $699c
	cp $11			; $699e
	jr nc,_label_10_294	; $69a0
	ld l,$f1		; $69a2
	ld e,$cd		; $69a4
	ld a,(de)		; $69a6
	sub (hl)		; $69a7
	add $08			; $69a8
	cp $11			; $69aa
	jr nc,_label_10_294	; $69ac
	ld l,$c4		; $69ae
	inc (hl)		; $69b0
_label_10_294:
	call objectApplySpeed		; $69b1
	jp partAnimate		; $69b4
	ld a,$0b		; $69b7
	call objectGetRelatedObject2Var		; $69b9
	push hl			; $69bc
	ld b,(hl)		; $69bd
	ld l,$8d		; $69be
	ld c,(hl)		; $69c0
	call objectGetRelativeAngle		; $69c1
	ld e,$c9		; $69c4
	ld (de),a		; $69c6
	pop hl			; $69c7
	ld e,$cb		; $69c8
	ld a,(de)		; $69ca
	sub (hl)		; $69cb
	add $04			; $69cc
	cp $09			; $69ce
	jr nc,_label_10_294	; $69d0
	ld l,$8d		; $69d2
	ld e,$cd		; $69d4
	ld a,(de)		; $69d6
	sub (hl)		; $69d7
	add $04			; $69d8
	cp $09			; $69da
	jr nc,_label_10_294	; $69dc
	ld a,$18		; $69de
	call objectGetRelatedObject1Var		; $69e0
	xor a			; $69e3
	ldi (hl),a		; $69e4
	ld (hl),a		; $69e5
	jp partDelete		; $69e6

partCode39:
	ld e,$c4		; $69e9
	ld a,(de)		; $69eb
	or a			; $69ec
	jr nz,_label_10_295	; $69ed
	ld h,d			; $69ef
	ld l,e			; $69f0
	inc (hl)		; $69f1
	ld l,$cb		; $69f2
	ld a,(hl)		; $69f4
	sub $1a			; $69f5
	ld (hl),a		; $69f7
	ld l,$c6		; $69f8
	ld (hl),$20		; $69fa
	ld l,$d0		; $69fc
	ld (hl),$3c		; $69fe
	call objectSetVisible80		; $6a00
	ld a,$bf		; $6a03
	jp playSound		; $6a05
_label_10_295:
	ld e,$d7		; $6a08
	ld a,(de)		; $6a0a
	inc a			; $6a0b
	jp z,partDelete		; $6a0c
	call $6a28		; $6a0f
	ret nz			; $6a12
	call $407e		; $6a13
	jp z,partDelete		; $6a16
	ld a,(wFrameCounter)		; $6a19
	rrca			; $6a1c
	jr c,_label_10_296	; $6a1d
	ld e,$dc		; $6a1f
	ld a,(de)		; $6a21
	xor $07			; $6a22
	ld (de),a		; $6a24
_label_10_296:
	jp objectApplySpeed		; $6a25
	ld e,$c6		; $6a28
	ld a,(de)		; $6a2a
	or a			; $6a2b
	ret z			; $6a2c
	ld a,$1a		; $6a2d
	call objectGetRelatedObject1Var		; $6a2f
	bit 7,(hl)		; $6a32
	jp z,partDelete		; $6a34
	call partCommon_decCounter1IfNonzero		; $6a37
	dec a			; $6a3a
	ld b,$01		; $6a3b
	cp $17			; $6a3d
	jr z,_label_10_297	; $6a3f
	or a			; $6a41
	jp nz,partAnimate		; $6a42
	ld h,d			; $6a45
	ld l,$e4		; $6a46
	set 7,(hl)		; $6a48
	call objectGetAngleTowardEnemyTarget		; $6a4a
	ld e,$c9		; $6a4d
	ld (de),a		; $6a4f
	ld a,$be		; $6a50
	call playSound		; $6a52
	ld b,$02		; $6a55
_label_10_297:
	ld a,b			; $6a57
	call partSetAnimation		; $6a58
	or d			; $6a5b
	ret			; $6a5c

partCode3a:
	jr z,_label_10_298	; $6a5d
	ld e,$ea		; $6a5f
	ld a,(de)		; $6a61
	res 7,a			; $6a62
	cp $04			; $6a64
	jp c,partDelete		; $6a66
	jp $6bdd		; $6a69
_label_10_298:
	ld e,$c2		; $6a6c
	ld a,(de)		; $6a6e
	ld e,$c4		; $6a6f
	rst_jumpTable			; $6a71
	ld a,d			; $6a72
	ld l,d			; $6a73
	sbc c			; $6a74
	ld l,d			; $6a75
	call z,$906a		; $6a76
	ld l,e			; $6a79
	ld a,(de)		; $6a7a
	or a			; $6a7b
	jr z,_label_10_300	; $6a7c
_label_10_299:
	call $407e		; $6a7e
	jp z,partDelete		; $6a81
	call objectApplySpeed		; $6a84
	jp partAnimate		; $6a87
_label_10_300:
	call $6be3		; $6a8a
	call objectGetAngleTowardEnemyTarget		; $6a8d
	ld e,$c9		; $6a90
	ld (de),a		; $6a92
	call $6bf0		; $6a93
	jp objectSetVisible80		; $6a96
	ld a,(de)		; $6a99
	or a			; $6a9a
	jr nz,_label_10_299	; $6a9b
	call $6be3		; $6a9d
	call $6bc2		; $6aa0
	ld e,$c3		; $6aa3
	ld a,(de)		; $6aa5
	or a			; $6aa6
	ret nz			; $6aa7
	call objectGetAngleTowardEnemyTarget		; $6aa8
	ld e,$c9		; $6aab
	ld (de),a		; $6aad
	sub $02			; $6aae
	and $1f			; $6ab0
	ld b,a			; $6ab2
	ld e,$01		; $6ab3
	call getFreePartSlot		; $6ab5
	ld (hl),$3a		; $6ab8
	inc l			; $6aba
	ld (hl),e		; $6abb
	inc l			; $6abc
	inc (hl)		; $6abd
	ld l,$c9		; $6abe
	ld (hl),b		; $6ac0
	ld l,$d6		; $6ac1
	ld e,l			; $6ac3
	ld a,(de)		; $6ac4
	ldi (hl),a		; $6ac5
	inc e			; $6ac6
	ld a,(de)		; $6ac7
	ld (hl),a		; $6ac8
	jp objectCopyPosition		; $6ac9
	ld a,(de)		; $6acc
	rst_jumpTable			; $6acd
	sub $6a			; $6ace
	rla			; $6ad0
	ld l,e			; $6ad1
	ld e,c			; $6ad2
	ld l,e			; $6ad3
	ld a,(hl)		; $6ad4
	ld l,d			; $6ad5
	ld h,d			; $6ad6
	ld l,$db		; $6ad7
	ld a,$03		; $6ad9
	ldi (hl),a		; $6adb
	ld (hl),a		; $6adc
	ld l,$c3		; $6add
	ld a,(hl)		; $6adf
	or a			; $6ae0
	jr z,_label_10_301	; $6ae1
	ld l,e			; $6ae3
	ld (hl),$03		; $6ae4
	call $6bf0		; $6ae6
	ld a,$01		; $6ae9
	call partSetAnimation		; $6aeb
	jp objectSetVisible82		; $6aee
_label_10_301:
	call $6be3		; $6af1
	ld l,$f0		; $6af4
	ldh a,(<hEnemyTargetY)	; $6af6
	ldi (hl),a		; $6af8
	ldh a,(<hEnemyTargetX)	; $6af9
	ld (hl),a		; $6afb
	ld a,$29		; $6afc
	call objectGetRelatedObject1Var		; $6afe
	ld a,(hl)		; $6b01
	ld b,$19		; $6b02
	cp $10			; $6b04
	jr nc,_label_10_302	; $6b06
	ld b,$2d		; $6b08
	cp $0a			; $6b0a
	jr nc,_label_10_302	; $6b0c
	ld b,$41		; $6b0e
_label_10_302:
	ld e,$d0		; $6b10
	ld a,b			; $6b12
	ld (de),a		; $6b13
	jp objectSetVisible80		; $6b14
	ld h,d			; $6b17
	ld l,$f0		; $6b18
	ld b,(hl)		; $6b1a
	inc l			; $6b1b
	ld c,(hl)		; $6b1c
	ld l,$cb		; $6b1d
	ldi a,(hl)		; $6b1f
	ldh (<hFF8F),a	; $6b20
	inc l			; $6b22
	ld a,(hl)		; $6b23
	ldh (<hFF8E),a	; $6b24
	sub c			; $6b26
	add $02			; $6b27
	cp $05			; $6b29
	jr nc,_label_10_303	; $6b2b
	ldh a,(<hFF8F)	; $6b2d
	sub b			; $6b2f
	add $02			; $6b30
	cp $05			; $6b32
	jr nc,_label_10_303	; $6b34
	ld bc,$0502		; $6b36
	call objectCreateInteraction		; $6b39
	ret nz			; $6b3c
	ld e,$d8		; $6b3d
	ld a,$40		; $6b3f
	ld (de),a		; $6b41
	inc e			; $6b42
	ld a,h			; $6b43
	ld (de),a		; $6b44
	ld e,$c4		; $6b45
	ld a,$02		; $6b47
	ld (de),a		; $6b49
	jp objectSetInvisible		; $6b4a
_label_10_303:
	call objectGetRelativeAngleWithTempVars		; $6b4d
	ld e,$c9		; $6b50
	ld (de),a		; $6b52
	call objectApplySpeed		; $6b53
	jp partAnimate		; $6b56
	ld a,$21		; $6b59
	call objectGetRelatedObject2Var		; $6b5b
	bit 7,(hl)		; $6b5e
	ret z			; $6b60
	ld b,$05		; $6b61
	call checkBPartSlotsAvailable		; $6b63
	ret nz			; $6b66
	ld c,$05		; $6b67
_label_10_304:
	ld a,c			; $6b69
	dec a			; $6b6a
	ld hl,$6b8b		; $6b6b
	rst_addAToHl			; $6b6e
	ld b,(hl)		; $6b6f
	ld e,$02		; $6b70
	call $6ab5		; $6b72
	dec c			; $6b75
	jr nz,_label_10_304	; $6b76
	ld h,d			; $6b78
	ld l,$c4		; $6b79
	inc (hl)		; $6b7b
	ld l,$c9		; $6b7c
	ld (hl),$1d		; $6b7e
	call $6bf0		; $6b80
	ld a,$01		; $6b83
	call partSetAnimation		; $6b85
	jp objectSetVisible82		; $6b88
	inc bc			; $6b8b
	ld ($130d),sp		; $6b8c
	jr $1a			; $6b8f
	or a			; $6b91
	jr z,_label_10_306	; $6b92
	call partCommon_decCounter1IfNonzero		; $6b94
	jp z,$6bdd		; $6b97
	inc l			; $6b9a
	dec (hl)		; $6b9b
	jr nz,_label_10_305	; $6b9c
	ld (hl),$07		; $6b9e
	call objectGetAngleTowardEnemyTarget		; $6ba0
	call objectNudgeAngleTowards		; $6ba3
_label_10_305:
	call objectApplySpeed		; $6ba6
	jp partAnimate		; $6ba9
_label_10_306:
	call $6be3		; $6bac
	ld l,$c6		; $6baf
	ld (hl),$f0		; $6bb1
	inc l			; $6bb3
	ld (hl),$07		; $6bb4
	ld l,$db		; $6bb6
	ld a,$02		; $6bb8
	ldi (hl),a		; $6bba
	ld (hl),a		; $6bbb
	call objectGetAngleTowardEnemyTarget		; $6bbc
	ld e,$c9		; $6bbf
	ld (de),a		; $6bc1
	ld a,$29		; $6bc2
	call objectGetRelatedObject1Var		; $6bc4
	ld a,(hl)		; $6bc7
	ld b,$1e		; $6bc8
	cp $10			; $6bca
	jr nc,_label_10_307	; $6bcc
	ld b,$2d		; $6bce
	cp $0a			; $6bd0
	jr nc,_label_10_307	; $6bd2
	ld b,$3c		; $6bd4
_label_10_307:
	ld e,$d0		; $6bd6
	ld a,b			; $6bd8
	ld (de),a		; $6bd9
	jp objectSetVisible80		; $6bda
	call objectCreatePuff		; $6bdd
	jp partDelete		; $6be0
	ld h,d			; $6be3
	ld l,e			; $6be4
	inc (hl)		; $6be5
	ld l,$cf		; $6be6
	ld a,(hl)		; $6be8
	ld (hl),$00		; $6be9
	ld l,$cb		; $6beb
	add (hl)		; $6bed
	ld (hl),a		; $6bee
	ret			; $6bef
	ld a,$29		; $6bf0
	call objectGetRelatedObject1Var		; $6bf2
	ld a,(hl)		; $6bf5
	ld b,$3c		; $6bf6
	cp $10			; $6bf8
	jr nc,_label_10_308	; $6bfa
	ld b,$5a		; $6bfc
	cp $0a			; $6bfe
	jr nc,_label_10_308	; $6c00
	ld b,$78		; $6c02
_label_10_308:
	ld e,$d0		; $6c04
	ld a,b			; $6c06
	ld (de),a		; $6c07
	ret			; $6c08

partCode3b:
	ld e,$c4		; $6c09
	ld a,(de)		; $6c0b
	or a			; $6c0c
	jr nz,_label_10_309	; $6c0d
	inc a			; $6c0f
	ld (de),a		; $6c10
_label_10_309:
	ld a,$01		; $6c11
	call objectGetRelatedObject1Var		; $6c13
	ld a,(hl)		; $6c16
	cp $7e			; $6c17
	jp nz,partDelete		; $6c19
	ld l,$a4		; $6c1c
	ld a,(hl)		; $6c1e
	and $80			; $6c1f
	ld b,a			; $6c21
	ld e,$e4		; $6c22
	ld a,(de)		; $6c24
	and $7f			; $6c25
	or b			; $6c27
	ld (de),a		; $6c28
	ld l,$b7		; $6c29
	bit 2,(hl)		; $6c2b
	jr z,_label_10_310	; $6c2d
	res 7,a			; $6c2f
	ld (de),a		; $6c31
_label_10_310:
	ld l,$8b		; $6c32
	ld b,(hl)		; $6c34
	ld l,$8d		; $6c35
	ld c,(hl)		; $6c37
	ld l,$88		; $6c38
	ld a,(hl)		; $6c3a
	cp $04			; $6c3b
	jr c,_label_10_311	; $6c3d
	sub $04			; $6c3f
	add a			; $6c41
	inc a			; $6c42
_label_10_311:
	add a			; $6c43
	ld hl,$6c5b		; $6c44
	rst_addDoubleIndex			; $6c47
	ld e,$cb		; $6c48
	ldi a,(hl)		; $6c4a
	add b			; $6c4b
	ld (de),a		; $6c4c
	ld e,$cd		; $6c4d
	ldi a,(hl)		; $6c4f
	add c			; $6c50
	ld (de),a		; $6c51
	ld e,$e6		; $6c52
	ldi a,(hl)		; $6c54
	ld (de),a		; $6c55
	inc e			; $6c56
	ld a,(hl)		; $6c57
	ld (de),a		; $6c58
	xor a			; $6c59
	ret			; $6c5a
	ld hl,sp+$06		; $6c5b
	ld b,$02		; $6c5d
	ld (bc),a		; $6c5f
	inc c			; $6c60
	ld (bc),a		; $6c61
	ld b,$09		; $6c62
	ld a,($0206)		; $6c64
	ld (bc),a		; $6c67
.DB $f4				; $6c68
	ld (bc),a		; $6c69
	.db $06		; $6c6a

partCode3c:
	.db $1e		; $6c6b
	call nz,$b71a		; $6c6c
	jr z,_label_10_314	; $6c6f
	ld bc,$0104		; $6c71
	call partCommon_decCounter1IfNonzero		; $6c74
	jr z,_label_10_313	; $6c77
	ld a,(hl)		; $6c79
	cp $46			; $6c7a
	jr z,_label_10_312	; $6c7c
	ld bc,$0206		; $6c7e
	cp $28			; $6c81
	jp nz,partAnimate		; $6c83
_label_10_312:
	ld l,$e6		; $6c86
	ld (hl),c		; $6c88
	inc l			; $6c89
	ld (hl),c		; $6c8a
	ld a,b			; $6c8b
	jp partSetAnimation		; $6c8c
_label_10_313:
	pop hl			; $6c8f
	jp partDelete		; $6c90
_label_10_314:
	ld h,d			; $6c93
	ld l,e			; $6c94
	inc (hl)		; $6c95
	ld l,$c6		; $6c96
	ld (hl),$64		; $6c98
	jp objectSetVisible83		; $6c9a

partCode3d:
	ld e,$c4		; $6c9d
	ld a,(de)		; $6c9f
	rst_jumpTable			; $6ca0
	xor c			; $6ca1
	ld l,h			; $6ca2
.DB $d3				; $6ca3
	ld l,h			; $6ca4
	cp $6c			; $6ca5
	inc c			; $6ca7
	ld l,l			; $6ca8
	ld h,d			; $6ca9
	ld l,e			; $6caa
	inc (hl)		; $6cab
	ld e,$c2		; $6cac
	ld a,(de)		; $6cae
	or a			; $6caf
	jr nz,_label_10_315	; $6cb0
	ld l,$d4		; $6cb2
	ld a,$40		; $6cb4
	ldi (hl),a		; $6cb6
	ld (hl),$ff		; $6cb7
	ld l,$d0		; $6cb9
	ld (hl),$3c		; $6cbb
_label_10_315:
	inc e			; $6cbd
	ld a,(de)		; $6cbe
	or a			; $6cbf
	jr z,_label_10_316	; $6cc0
	ld l,$c4		; $6cc2
	inc (hl)		; $6cc4
	ld l,$e4		; $6cc5
	res 7,(hl)		; $6cc7
	ld l,$c6		; $6cc9
	ld (hl),$1e		; $6ccb
	call $6cf4		; $6ccd
_label_10_316:
	jp objectSetVisiblec1		; $6cd0
	call $407e		; $6cd3
	jp z,partDelete		; $6cd6
	call objectApplySpeed		; $6cd9
	ld c,$0e		; $6cdc
	call objectUpdateSpeedZ_paramC		; $6cde
	jr nz,_label_10_317	; $6ce1
	ld l,$c4		; $6ce3
	inc (hl)		; $6ce5
	ld l,$c6		; $6ce6
	ld (hl),$a0		; $6ce8
	ld l,$e6		; $6cea
	ld (hl),$05		; $6cec
	inc l			; $6cee
	ld (hl),$04		; $6cef
	call $6e13		; $6cf1
	ld a,$6f		; $6cf4
	call playSound		; $6cf6
	ld a,$01		; $6cf9
	jp partSetAnimation		; $6cfb
	call partCommon_decCounter1IfNonzero		; $6cfe
	jr nz,_label_10_317	; $6d01
	ld (hl),$14		; $6d03
	ld l,e			; $6d05
	inc (hl)		; $6d06
	ld a,$02		; $6d07
	jp partSetAnimation		; $6d09
	call partCommon_decCounter1IfNonzero		; $6d0c
	jp z,partDelete		; $6d0f
_label_10_317:
	jp partAnimate		; $6d12

partCode3e:
	jr z,_label_10_318	; $6d15
	ld e,$ea		; $6d17
	ld a,(de)		; $6d19
	cp $9a			; $6d1a
	jr nz,_label_10_318	; $6d1c
	ld h,d			; $6d1e
	ld l,$c2		; $6d1f
	ld (hl),$01		; $6d21
	ld l,$e4		; $6d23
	res 7,(hl)		; $6d25
	ld l,$c6		; $6d27
	ld (hl),$96		; $6d29
	ld l,$c4		; $6d2b
	ld a,$03		; $6d2d
	ld (hl),a		; $6d2f
	call partSetAnimation		; $6d30
_label_10_318:
	ld e,$c4		; $6d33
	ld a,(de)		; $6d35
	rst_jumpTable			; $6d36
	ld b,c			; $6d37
	ld l,l			; $6d38
	ld e,a			; $6d39
	ld l,l			; $6d3a
	sbc (hl)		; $6d3b
	ld l,l			; $6d3c
	sub $6d			; $6d3d
	push af			; $6d3f
	ld l,l			; $6d40
	ld h,d			; $6d41
	ld l,e			; $6d42
	inc (hl)		; $6d43
	ld l,$c3		; $6d44
	ld a,(hl)		; $6d46
	or a			; $6d47
	ld a,$1e		; $6d48
	jr nz,_label_10_321	; $6d4a
	ld l,$f0		; $6d4c
	ldh a,(<hEnemyTargetY)	; $6d4e
	ldi (hl),a		; $6d50
	ldh a,(<hEnemyTargetX)	; $6d51
	ld (hl),a		; $6d53
	ld l,$d0		; $6d54
	ld (hl),$50		; $6d56
	ld l,$ff		; $6d58
	set 5,(hl)		; $6d5a
	jp objectSetVisible83		; $6d5c
	ld h,d			; $6d5f
	ld l,$f0		; $6d60
	ld b,(hl)		; $6d62
	inc l			; $6d63
	ld c,(hl)		; $6d64
	ld l,$cb		; $6d65
	ldi a,(hl)		; $6d67
	ldh (<hFF8F),a	; $6d68
	inc l			; $6d6a
	ld a,(hl)		; $6d6b
	ldh (<hFF8E),a	; $6d6c
	sub c			; $6d6e
	inc a			; $6d6f
	cp $03			; $6d70
	jr nc,_label_10_319	; $6d72
	ldh a,(<hFF8F)	; $6d74
	sub b			; $6d76
	inc a			; $6d77
	cp $03			; $6d78
	jr c,_label_10_320	; $6d7a
_label_10_319:
	call objectGetRelativeAngleWithTempVars		; $6d7c
	ld e,$c9		; $6d7f
	ld (de),a		; $6d81
	jp objectApplySpeed		; $6d82
_label_10_320:
	ld a,$a0		; $6d85
_label_10_321:
	ld l,$c6		; $6d87
	ld (hl),a		; $6d89
	ld l,e			; $6d8a
	ld (hl),$03		; $6d8b
	ld l,$e4		; $6d8d
	set 7,(hl)		; $6d8f
	ld a,$ab		; $6d91
	call playSound		; $6d93
	ld a,$01		; $6d96
	call partSetAnimation		; $6d98
	jp objectSetVisible81		; $6d9b
	inc e			; $6d9e
	ld a,(de)		; $6d9f
	rst_jumpTable			; $6da0
	xor c			; $6da1
	ld l,l			; $6da2
	or d			; $6da3
	ld l,l			; $6da4
	cp h			; $6da5
	ld l,l			; $6da6
	call $af6d		; $6da7
	ld (wLinkGrabState2),a		; $6daa
	inc a			; $6dad
	ld (de),a		; $6dae
	jp objectSetVisible81		; $6daf
	call $6e70		; $6db2
	ret z			; $6db5
	call dropLinkHeldItem		; $6db6
	jp partDelete		; $6db9
	call $6e37		; $6dbc
	jp c,partDelete		; $6dbf
	ld e,$cf		; $6dc2
	ld a,(de)		; $6dc4
	or a			; $6dc5
	ret nz			; $6dc6
	ld e,$c5		; $6dc7
	ld a,$03		; $6dc9
	ld (de),a		; $6dcb
	ret			; $6dcc
	ld b,$09		; $6dcd
	call objectCreateInteractionWithSubid00		; $6dcf
	ret nz			; $6dd2
	jp partDelete		; $6dd3
	call $6e70		; $6dd6
	jp nz,partDelete		; $6dd9
	call partCommon_decCounter1IfNonzero		; $6ddc
	jr z,_label_10_322	; $6ddf
	ld e,$c2		; $6de1
	ld a,(de)		; $6de3
	or a			; $6de4
	jp nz,$6e6a		; $6de5
	call partAnimate		; $6de8
	jr _label_10_323		; $6deb
_label_10_322:
	ld l,$c4		; $6ded
	inc (hl)		; $6def
	ld a,$02		; $6df0
	jp partSetAnimation		; $6df2
	ld e,$e1		; $6df5
	ld a,(de)		; $6df7
	inc a			; $6df8
	jp z,partDelete		; $6df9
	call partAnimate		; $6dfc
_label_10_323:
	ld e,$e1		; $6dff
	ld a,(de)		; $6e01
	cp $ff			; $6e02
	ret z			; $6e04
	ld hl,$6e10		; $6e05
	rst_addAToHl			; $6e08
	ld e,$e6		; $6e09
	ld a,(hl)		; $6e0b
	ld (de),a		; $6e0c
	inc e			; $6e0d
	ld (de),a		; $6e0e
	ret			; $6e0f
	ld (bc),a		; $6e10
	inc b			; $6e11
	ld b,$1e		; $6e12
	jp nz,$fe1a		; $6e14
	inc bc			; $6e17
	ret nc			; $6e18
	call getFreePartSlot		; $6e19
	ret nz			; $6e1c
	ld (hl),$3d		; $6e1d
	inc l			; $6e1f
	ld e,l			; $6e20
	ld a,(de)		; $6e21
	inc a			; $6e22
	ld (hl),a		; $6e23
	ld l,$c9		; $6e24
	ld e,l			; $6e26
	ld a,(de)		; $6e27
	ld (hl),a		; $6e28
	ld l,$d0		; $6e29
	ld (hl),$3c		; $6e2b
	ld l,$d4		; $6e2d
	ld a,$c0		; $6e2f
	ldi (hl),a		; $6e31
	ld (hl),$ff		; $6e32
	jp objectCopyPosition		; $6e34
	ld a,$00		; $6e37
	call objectGetRelatedObject1Var		; $6e39
	call checkObjectsCollided		; $6e3c
	ret nc			; $6e3f
	ld l,$82		; $6e40
	ld a,(hl)		; $6e42
	or a			; $6e43
	ret nz			; $6e44
	ld l,$ab		; $6e45
	ld a,(hl)		; $6e47
	or a			; $6e48
	ret nz			; $6e49
	ld (hl),$3c		; $6e4a
	ld l,$b2		; $6e4c
	ld (hl),$1e		; $6e4e
	ld l,$a9		; $6e50
	ld a,(hl)		; $6e52
	sub $06			; $6e53
	ld (hl),a		; $6e55
	jr nc,_label_10_324	; $6e56
	ld (hl),$00		; $6e58
	ld l,$a4		; $6e5a
	res 7,(hl)		; $6e5c
_label_10_324:
	ld a,$63		; $6e5e
	call playSound		; $6e60
	ld a,$83		; $6e63
	call playSound		; $6e65
	scf			; $6e68
	ret			; $6e69
	call objectAddToGrabbableObjectBuffer		; $6e6a
	jp objectPushLinkAwayOnCollision		; $6e6d
	ld a,$01		; $6e70
	call objectGetRelatedObject1Var		; $6e72
	ld a,(hl)		; $6e75
	cp $77			; $6e76
	ret z			; $6e78
	call objectCreatePuff		; $6e79
	or d			; $6e7c
	ret			; $6e7d

partCode3f:
	jr z,_label_10_325	; $6e7e
	ld e,$c2		; $6e80
	ld a,(de)		; $6e82
	or a			; $6e83
	jr nz,_label_10_325	; $6e84
	ld e,$ea		; $6e86
	ld a,(de)		; $6e88
	cp $95			; $6e89
	jr nz,_label_10_325	; $6e8b
	ld h,d			; $6e8d
	call $6fce		; $6e8e
_label_10_325:
	ld e,$c2		; $6e91
	ld a,(de)		; $6e93
	ld e,$c4		; $6e94
	rst_jumpTable			; $6e96
	sbc e			; $6e97
	ld l,(hl)		; $6e98
	ld (hl),c		; $6e99
	ld l,a			; $6e9a
	ld a,(de)		; $6e9b
	rst_jumpTable			; $6e9c
	xor a			; $6e9d
	ld l,(hl)		; $6e9e
	call nz,$c56e		; $6e9f
	ld l,(hl)		; $6ea2
	ld a,(bc)		; $6ea3
	ld l,a			; $6ea4
	ld e,$6f		; $6ea5
	dec h			; $6ea7
	ld l,a			; $6ea8
	dec a			; $6ea9
	ld l,a			; $6eaa
	ld e,a			; $6eab
	ld l,a			; $6eac
	ld h,l			; $6ead
	ld l,a			; $6eae
	ld h,d			; $6eaf
	ld l,e			; $6eb0
	inc (hl)		; $6eb1
	ld l,$c9		; $6eb2
	ld (hl),$10		; $6eb4
	ld l,$d0		; $6eb6
	ld (hl),$32		; $6eb8
	ld l,$d4		; $6eba
	ld (hl),$00		; $6ebc
	inc l			; $6ebe
	ld (hl),$fe		; $6ebf
	jp objectSetVisiblec2		; $6ec1
	ret			; $6ec4
	inc e			; $6ec5
	ld a,(de)		; $6ec6
	rst_jumpTable			; $6ec7
	ret nc			; $6ec8
	ld l,(hl)		; $6ec9
	jp c,$e16e		; $6eca
	ld l,(hl)		; $6ecd
	nop			; $6ece
	ld l,a			; $6ecf
	ld a,$01		; $6ed0
	ld (de),a		; $6ed2
	xor a			; $6ed3
	ld (wLinkGrabState2),a		; $6ed4
	jp objectSetVisiblec1		; $6ed7
_label_10_326:
	call $6fb8		; $6eda
	ret nz			; $6edd
	jp dropLinkHeldItem		; $6ede
	ld e,$cb		; $6ee1
	ld a,(de)		; $6ee3
	cp $30			; $6ee4
	jr nc,_label_10_326	; $6ee6
	ld h,d			; $6ee8
	ld l,$cf		; $6ee9
	ld e,$c2		; $6eeb
	ld a,(de)		; $6eed
	or (hl)			; $6eee
	jr nz,_label_10_326	; $6eef
	ld hl,$dc15		; $6ef1
	sra (hl)		; $6ef4
	dec l			; $6ef6
	rr (hl)			; $6ef7
	ld l,$10		; $6ef9
	ld (hl),$0a		; $6efb
	jp $6fb8		; $6efd
	ld e,$c4		; $6f00
	ld a,$04		; $6f02
	ld (de),a		; $6f04
	call objectSetVisiblec2		; $6f05
	jr _label_10_328		; $6f08
	ld c,$20		; $6f0a
	call objectUpdateSpeedZAndBounce		; $6f0c
	jr c,_label_10_327	; $6f0f
	call z,$6f9b		; $6f11
	jp objectApplySpeed		; $6f14
_label_10_327:
	ld h,d			; $6f17
	ld l,$c4		; $6f18
	inc (hl)		; $6f1a
	call $6f9b		; $6f1b
_label_10_328:
	call $6fb8		; $6f1e
	ret z			; $6f21
	jp objectAddToGrabbableObjectBuffer		; $6f22
	ld h,d			; $6f25
	ld l,$e1		; $6f26
	ld a,(hl)		; $6f28
	inc a			; $6f29
	jp z,partDelete		; $6f2a
	dec a			; $6f2d
	jr z,_label_10_329	; $6f2e
	ld l,$e6		; $6f30
	ldi (hl),a		; $6f32
	ld (hl),a		; $6f33
	call $6fed		; $6f34
	call $7015		; $6f37
_label_10_329:
	jp partAnimate		; $6f3a
	ld bc,$fdc0		; $6f3d
	call objectSetSpeedZ		; $6f40
	ld l,e			; $6f43
	inc (hl)		; $6f44
	ld l,$d0		; $6f45
	ld (hl),$1e		; $6f47
	ld l,$c6		; $6f49
	ld (hl),$07		; $6f4b
	ld a,$0d		; $6f4d
	call objectGetRelatedObject1Var		; $6f4f
	ld a,(hl)		; $6f52
	cp $50			; $6f53
	ld a,$07		; $6f55
	jr c,_label_10_330	; $6f57
	ld a,$19		; $6f59
_label_10_330:
	ld e,$c9		; $6f5b
	ld (de),a		; $6f5d
	ret			; $6f5e
	call partCommon_decCounter1IfNonzero		; $6f5f
	ret nz			; $6f62
	ld l,e			; $6f63
	inc (hl)		; $6f64
	ld c,$20		; $6f65
	call objectUpdateSpeedZAndBounce		; $6f67
	jp nc,objectApplySpeed		; $6f6a
	ld h,d			; $6f6d
	jp $6fce		; $6f6e
	ld a,(de)		; $6f71
	rst_jumpTable			; $6f72
	ld a,c			; $6f73
	ld l,a			; $6f74
	adc d			; $6f75
	ld l,a			; $6f76
	and b			; $6f77
	ld l,a			; $6f78
	ld h,d			; $6f79
	ld l,e			; $6f7a
	inc (hl)		; $6f7b
	ld l,$d0		; $6f7c
	ld (hl),$28		; $6f7e
	ld l,$d4		; $6f80
	ld (hl),$20		; $6f82
	inc l			; $6f84
	ld (hl),$fe		; $6f85
	jp objectSetVisiblec2		; $6f87
	ld c,$20		; $6f8a
	call objectUpdateSpeedZAndBounce		; $6f8c
	jr c,_label_10_331	; $6f8f
	call z,$6f9b		; $6f91
	jp objectApplySpeed		; $6f94
_label_10_331:
	ld h,d			; $6f97
	ld l,$c4		; $6f98
	inc (hl)		; $6f9a
	ld a,$52		; $6f9b
	jp playSound		; $6f9d
	ld h,d			; $6fa0
	ld l,$e1		; $6fa1
	bit 0,(hl)		; $6fa3
	jp z,partAnimate		; $6fa5
	ld (hl),$00		; $6fa8
	ld l,$c7		; $6faa
	inc (hl)		; $6fac
	ld a,(hl)		; $6fad
	cp $04			; $6fae
	jp c,partAnimate		; $6fb0
	ld l,$c2		; $6fb3
	dec (hl)		; $6fb5
	jr _label_10_333		; $6fb6
	ld h,d			; $6fb8
	ld l,$e1		; $6fb9
	bit 0,(hl)		; $6fbb
	jr z,_label_10_332	; $6fbd
	ld (hl),$00		; $6fbf
	ld l,$c7		; $6fc1
	inc (hl)		; $6fc3
	ld a,(hl)		; $6fc4
	cp $08			; $6fc5
	jr nc,_label_10_333	; $6fc7
_label_10_332:
	jp partAnimate		; $6fc9
	or d			; $6fcc
	ret			; $6fcd
_label_10_333:
	ld l,$c4		; $6fce
	ld (hl),$05		; $6fd0
	ld l,$e4		; $6fd2
	res 7,(hl)		; $6fd4
	ld l,$db		; $6fd6
	ld a,$0a		; $6fd8
	ldi (hl),a		; $6fda
	ldi (hl),a		; $6fdb
	ld (hl),$0c		; $6fdc
	ld a,$01		; $6fde
	call partSetAnimation		; $6fe0
	call objectSetVisible82		; $6fe3
	ld a,$6f		; $6fe6
	call playSound		; $6fe8
	xor a			; $6feb
	ret			; $6fec
	ld e,$f0		; $6fed
	ld a,(de)		; $6fef
	or a			; $6ff0
	ret nz			; $6ff1
	call checkLinkVulnerable		; $6ff2
	ret nc			; $6ff5
	call objectCheckCollidedWithLink_ignoreZ		; $6ff6
	ret nc			; $6ff9
	call objectGetAngleTowardEnemyTarget		; $6ffa
	ld hl,$d02d		; $6ffd
	ld (hl),$10		; $7000
	dec l			; $7002
	ldd (hl),a		; $7003
	ld (hl),$14		; $7004
	dec l			; $7006
	ld (hl),$01		; $7007
	ld e,$e8		; $7009
	ld l,$25		; $700b
	ld a,(de)		; $700d
	ld (hl),a		; $700e
	ld e,$f0		; $700f
	ld a,$01		; $7011
	ld (de),a		; $7013
	ret			; $7014
	ld e,$d7		; $7015
	ld a,(de)		; $7017
	or a			; $7018
	ret z			; $7019
	ld a,$24		; $701a
	call objectGetRelatedObject1Var		; $701c
	bit 7,(hl)		; $701f
	ret z			; $7021
	ld l,$ab		; $7022
	ld a,(hl)		; $7024
	or a			; $7025
	ret nz			; $7026
	call checkObjectsCollided		; $7027
	ret nc			; $702a
	ld l,$aa		; $702b
	ld (hl),$97		; $702d
	ld l,$ab		; $702f
	ld (hl),$1e		; $7031
	ld l,$a9		; $7033
	dec (hl)		; $7035
	ret			; $7036

partCode40:
	jp nz,partDelete		; $7037
	ld e,$c4		; $703a
	ld a,(de)		; $703c
	rst_jumpTable			; $703d
	ld b,h			; $703e
	ld (hl),b		; $703f
	ld d,(hl)		; $7040
	ld (hl),b		; $7041
	ld l,d			; $7042
	ld (hl),b		; $7043
	ld h,d			; $7044
	ld l,e			; $7045
	inc (hl)		; $7046
	ld l,$c6		; $7047
	ld (hl),$28		; $7049
	ld l,$d0		; $704b
	ld (hl),$50		; $704d
	ld e,$c2		; $704f
	ld a,(de)		; $7051
	or a			; $7052
	jr z,_label_10_334	; $7053
	ret			; $7055
	call partCommon_decCounter1IfNonzero		; $7056
	ret nz			; $7059
	ld l,e			; $705a
	inc (hl)		; $705b
	ld a,$00		; $705c
	call objectGetRelatedObject1Var		; $705e
	ld bc,$f0f0		; $7061
	call objectTakePositionWithOffset		; $7064
	jp objectSetVisible80		; $7067
	call objectApplySpeed		; $706a
	call $407e		; $706d
	jp z,partDelete		; $7070
	ld a,(wFrameCounter)		; $7073
	xor d			; $7076
	rrca			; $7077
	ret nc			; $7078
	ld e,$dc		; $7079
	ld a,(de)		; $707b
	inc a			; $707c
	and $03			; $707d
	ld (de),a		; $707f
	ret			; $7080
_label_10_334:
	call objectGetAngleTowardEnemyTarget		; $7081
	ld e,$c9		; $7084
	ld (de),a		; $7086
	ld c,$03		; $7087
	call $708e		; $7089
	ld c,$fd		; $708c
	call getFreePartSlot		; $708e
	ret nz			; $7091
	ld (hl),$40		; $7092
	inc l			; $7094
	inc (hl)		; $7095
	call objectCopyPosition		; $7096
	ld l,$c9		; $7099
	ld e,l			; $709b
	ld a,(de)		; $709c
	add c			; $709d
	and $1f			; $709e
	ld (hl),a		; $70a0
	ld l,$d6		; $70a1
	ld e,l			; $70a3
	ld a,(de)		; $70a4
	ldi (hl),a		; $70a5
	ld e,l			; $70a6
	ld a,(de)		; $70a7
	ld (hl),a		; $70a8
	ret			; $70a9

partCode41:
	ld e,$c4		; $70aa
	ld a,(de)		; $70ac
	or a			; $70ad
	jr z,_label_10_335	; $70ae
	call objectApplySpeed		; $70b0
	call objectCheckWithinScreenBoundary		; $70b3
	jp nc,partDelete		; $70b6
	jp partAnimate		; $70b9
_label_10_335:
	ld h,d			; $70bc
	ld l,$c4		; $70bd
	inc (hl)		; $70bf
	ld l,$d0		; $70c0
	ld (hl),$78		; $70c2
	ld l,$cb		; $70c4
	ld a,$04		; $70c6
	add (hl)		; $70c8
	ld (hl),a		; $70c9
	ld l,$c9		; $70ca
	ld a,(hl)		; $70cc
	bit 3,a			; $70cd
	ld e,$cb		; $70cf
	jr z,_label_10_336	; $70d1
	ld e,$cd		; $70d3
_label_10_336:
	swap a			; $70d5
	rlca			; $70d7
	ld b,a			; $70d8
	ld hl,$70f3		; $70d9
	rst_addAToHl			; $70dc
	ld a,(de)		; $70dd
	add (hl)		; $70de
	ld (de),a		; $70df
	ld a,b			; $70e0
	call partSetAnimation		; $70e1
	ld a,$72		; $70e4
	call playSound		; $70e6
	ld e,$c9		; $70e9
	ld a,(de)		; $70eb
	or a			; $70ec
	jp z,objectSetVisible82		; $70ed
	jp objectSetVisible81		; $70f0
	xor $12			; $70f3
	stop			; $70f5
	.db $ee			; $70f6

partCode42:
	.db $28			; $70f7
	add hl,bc		; $70f8
	ld e,$ea		; $70f9
	ld a,(de)		; $70fb
	res 7,a			; $70fc
	cp $04			; $70fe
	jr c,_label_10_338	; $7100
	ld e,$c4		; $7102
	ld a,(de)		; $7104
	or a			; $7105
	jr z,_label_10_339	; $7106
	call $4072		; $7108
	jr z,_label_10_338	; $710b
	ld e,$c2		; $710d
	ld a,(de)		; $710f
	cp $02			; $7110
	jr z,_label_10_337	; $7112
	call partCommon_decCounter1IfNonzero		; $7114
	jr nz,_label_10_337	; $7117
	inc l			; $7119
	ld e,$f0		; $711a
	ld a,(de)		; $711c
	inc a			; $711d
	and $01			; $711e
	ld (de),a		; $7120
	add (hl)		; $7121
	ldd (hl),a		; $7122
	ld (hl),a		; $7123
	ld l,$c9		; $7124
	ld a,(hl)		; $7126
	add $02			; $7127
	and $1f			; $7129
	ld (hl),a		; $712b
_label_10_337:
	call objectApplySpeed		; $712c
	call partAnimate		; $712f
	ld e,$e1		; $7132
	ld a,(de)		; $7134
	inc a			; $7135
	ret nz			; $7136
_label_10_338:
	jp partDelete		; $7137
_label_10_339:
	call $7174		; $713a
	ret nz			; $713d
	call objectSetVisible82		; $713e
	ld h,d			; $7141
	ld l,$c4		; $7142
	inc (hl)		; $7144
	ld e,$c2		; $7145
	ld a,(de)		; $7147
	cp $02			; $7148
	jr nz,_label_10_340	; $714a
	ld l,$cf		; $714c
	ld a,(hl)		; $714e
	ld (hl),$00		; $714f
	ld l,$cb		; $7151
	add (hl)		; $7153
	ld (hl),a		; $7154
	ld l,$d0		; $7155
	ld (hl),$32		; $7157
	ret			; $7159
_label_10_340:
	ld l,$cf		; $715a
	ld a,(hl)		; $715c
	ld (hl),$fa		; $715d
	add $06			; $715f
	ld l,$cb		; $7161
	add (hl)		; $7163
	ld (hl),a		; $7164
	ld l,$d0		; $7165
	ld (hl),$78		; $7167
	ld l,$c6		; $7169
	ld a,$02		; $716b
	ldi (hl),a		; $716d
	ld (hl),a		; $716e
	ld a,$01		; $716f
	jp partSetAnimation		; $7171
	ld e,$c2		; $7174
	ld a,(de)		; $7176
	bit 7,a			; $7177
	jr z,_label_10_343	; $7179
	rrca			; $717b
	ld a,$04		; $717c
	ld bc,$0300		; $717e
	jr nc,_label_10_341	; $7181
	ld a,$03		; $7183
	ld bc,$0503		; $7185
_label_10_341:
	ld e,$c9		; $7188
	ld (de),a		; $718a
	ld e,$c2		; $718b
	xor a			; $718d
	ld (de),a		; $718e
	push bc			; $718f
	call checkBPartSlotsAvailable		; $7190
	pop bc			; $7193
	ret nz			; $7194
	ld a,b			; $7195
	ldh (<hFF8B),a	; $7196
	ld a,c			; $7198
	ld bc,$71fc		; $7199
	call addAToBc		; $719c
_label_10_342:
	push bc			; $719f
	call getFreePartSlot		; $71a0
	ld (hl),$42		; $71a3
	call objectCopyPosition		; $71a5
	pop bc			; $71a8
	ld l,$c9		; $71a9
	ld a,(bc)		; $71ab
	ld (hl),a		; $71ac
	inc bc			; $71ad
	ld hl,$ff8b		; $71ae
	dec (hl)		; $71b1
	jr nz,_label_10_342	; $71b2
	ret			; $71b4
_label_10_343:
	dec a			; $71b5
	jr z,_label_10_344	; $71b6
	xor a			; $71b8
	ret			; $71b9
_label_10_344:
	ld b,$05		; $71ba
	call checkBPartSlotsAvailable		; $71bc
	ret nz			; $71bf
	ld a,$09		; $71c0
	call objectGetRelatedObject1Var		; $71c2
	ld a,(hl)		; $71c5
	add $08			; $71c6
	and $1f			; $71c8
	ld b,a			; $71ca
	ld c,$02		; $71cb
	ld h,d			; $71cd
	ld l,$c9		; $71ce
	sub c			; $71d0
	and $1f			; $71d1
	ld (hl),a		; $71d3
	ld l,$c2		; $71d4
	ld (hl),c		; $71d6
	call $71e2		; $71d7
	ld a,b			; $71da
	add $0c			; $71db
	and $1f			; $71dd
	ld b,a			; $71df
	ld c,$03		; $71e0
_label_10_345:
	push bc			; $71e2
	call getFreePartSlot		; $71e3
	ld (hl),$42		; $71e6
	inc l			; $71e8
	ld (hl),$02		; $71e9
	call objectCopyPosition		; $71eb
	pop bc			; $71ee
	ld l,$c9		; $71ef
	ld (hl),b		; $71f1
	ld a,b			; $71f2
	add $02			; $71f3
	and $1f			; $71f5
	ld b,a			; $71f7
	dec c			; $71f8
	jr nz,_label_10_345	; $71f9
	ret			; $71fb
	inc c			; $71fc
	inc d			; $71fd
	inc e			; $71fe
	ld ($130d),sp		; $71ff
	jr _label_10_346		; $7202

partCode43:
	ld e,$c2		; $7204
	ld a,(de)		; $7206
	ld e,$c4		; $7207
	rst_jumpTable			; $7209
	inc d			; $720a
	ld (hl),d		; $720b
	ld l,a			; $720c
	ld (hl),d		; $720d
	xor (hl)		; $720e
	ld (hl),d		; $720f
	ld sp,hl		; $7210
	ld (hl),d		; $7211
	daa			; $7212
	ld (hl),e		; $7213
	ld a,(de)		; $7214
	or a			; $7215
	jr z,_label_10_348	; $7216
	call partAnimate		; $7218
	call partCommon_decCounter1IfNonzero		; $721b
	jp nz,objectApplyComponentSpeed		; $721e
_label_10_346:
	ld b,$06		; $7221
_label_10_347:
	ld a,b			; $7223
	dec a			; $7224
	ld hl,$7245		; $7225
	rst_addAToHl			; $7228
	ld c,(hl)		; $7229
	call $7236		; $722a
	dec b			; $722d
	jr nz,_label_10_347	; $722e
	call objectCreatePuff		; $7230
	jp partDelete		; $7233
	call getFreePartSlot		; $7236
	ret nz			; $7239
	ld (hl),$43		; $723a
	inc l			; $723c
	ld (hl),$03		; $723d
	ld l,$c9		; $723f
	ld (hl),c		; $7241
	jp objectCopyPosition		; $7242
	inc bc			; $7245
	ld ($130d),sp		; $7246
	jr $1d			; $7249
_label_10_348:
	ld h,d			; $724b
	ld l,e			; $724c
	inc (hl)		; $724d
	ld l,$dd		; $724e
	ld (hl),$06		; $7250
	dec l			; $7252
	ld a,$0a		; $7253
	ldd (hl),a		; $7255
	ld (hl),a		; $7256
	ld l,$cb		; $7257
	ld a,(hl)		; $7259
	add $06			; $725a
	ld (hl),a		; $725c
	ld l,$e6		; $725d
	ld a,$05		; $725f
	ldi (hl),a		; $7261
	ld (hl),a		; $7262
	ld l,$c6		; $7263
	ld (hl),$0c		; $7265
	ld l,$c9		; $7267
	ld (hl),$10		; $7269
	ld b,$50		; $726b
	jr _label_10_349		; $726d
	ld a,(de)		; $726f
	rst_jumpTable			; $7270
	ld (hl),a		; $7271
	ld (hl),d		; $7272
	adc h			; $7273
	ld (hl),d		; $7274
	and l			; $7275
	ld (hl),d		; $7276
	ld h,d			; $7277
	ld l,e			; $7278
	inc (hl)		; $7279
	ld l,$c6		; $727a
	ld (hl),$04		; $727c
	ld l,$e4		; $727e
	res 7,(hl)		; $7280
	ld l,$dd		; $7282
	ld (hl),$06		; $7284
	dec l			; $7286
	ld a,$0a		; $7287
	ldd (hl),a		; $7289
	ld (hl),a		; $728a
	ret			; $728b
	call partCommon_decCounter1IfNonzero		; $728c
	ret nz			; $728f
	ld (hl),$b4		; $7290
	ld l,e			; $7292
	inc (hl)		; $7293
	ld l,$e4		; $7294
	set 7,(hl)		; $7296
	ld b,$3c		; $7298
_label_10_349:
	call $733d		; $729a
	call objectSetVisible81		; $729d
	ld a,$72		; $72a0
	jp playSound		; $72a2
	call partCommon_decCounter1IfNonzero		; $72a5
	jp z,partDelete		; $72a8
	jp partAnimate		; $72ab
	ld a,(de)		; $72ae
	or a			; $72af
	jr z,_label_10_350	; $72b0
	call $407e		; $72b2
	jp z,partDelete		; $72b5
	call objectApplyComponentSpeed		; $72b8
	jp partAnimate		; $72bb
_label_10_350:
	ld b,$02		; $72be
	call checkBPartSlotsAvailable		; $72c0
	ret nz			; $72c3
	ld h,d			; $72c4
	ld l,$c4		; $72c5
	inc (hl)		; $72c7
	ld l,$dd		; $72c8
	ld (hl),$06		; $72ca
	dec l			; $72cc
	ld a,$0a		; $72cd
	ldd (hl),a		; $72cf
	ld (hl),a		; $72d0
	ld l,$c9		; $72d1
	ld (hl),$10		; $72d3
	ld l,$cb		; $72d5
	ld a,(hl)		; $72d7
	add $06			; $72d8
	ld (hl),a		; $72da
	ld b,$3c		; $72db
	call $729a		; $72dd
	ld bc,$0213		; $72e0
	call $72e9		; $72e3
	ld bc,$030d		; $72e6
	call getFreePartSlot		; $72e9
	ld (hl),$43		; $72ec
	inc l			; $72ee
	ld (hl),$04		; $72ef
	inc l			; $72f1
	ld (hl),b		; $72f2
	ld l,$c9		; $72f3
	ld (hl),c		; $72f5
	jp objectCopyPosition		; $72f6
	ld a,(de)		; $72f9
	or a			; $72fa
	jr z,_label_10_351	; $72fb
	call objectApplyComponentSpeed		; $72fd
	ld c,$12		; $7300
	call objectUpdateSpeedZ_paramC		; $7302
	jp nz,partAnimate		; $7305
	jp partDelete		; $7308
_label_10_351:
	ld bc,$ff20		; $730b
	call objectSetSpeedZ		; $730e
	ld l,e			; $7311
	inc (hl)		; $7312
	ld l,$e6		; $7313
	ld (hl),$05		; $7315
	inc l			; $7317
	ld (hl),$02		; $7318
	ld b,$3c		; $731a
	call $733d		; $731c
	call objectSetVisible82		; $731f
	ld a,$01		; $7322
	jp partSetAnimation		; $7324
	ld a,(de)		; $7327
	or a			; $7328
	jp nz,$72b2		; $7329
	ld h,d			; $732c
	ld l,e			; $732d
	inc (hl)		; $732e
	ld b,$3c		; $732f
	call $733d		; $7331
	call objectSetVisible82		; $7334
	ld e,$c3		; $7337
	ld a,(de)		; $7339
	jp partSetAnimation		; $733a
	ld e,$c9		; $733d
	ld a,(de)		; $733f
	ld c,a			; $7340
	call getPositionOffsetForVelocity		; $7341
	ld e,$d0		; $7344
	ldi a,(hl)		; $7346
	ld (de),a		; $7347
	inc e			; $7348
	ldi a,(hl)		; $7349
	ld (de),a		; $734a
	inc e			; $734b
	ldi a,(hl)		; $734c
	ld (de),a		; $734d
	inc e			; $734e
	ldi a,(hl)		; $734f
	ld (de),a		; $7350
	ret			; $7351

partCode44:
	jr z,_label_10_354	; $7352
	ld e,$ea		; $7354
	ld a,(de)		; $7356
	cp $83			; $7357
	jr z,_label_10_353	; $7359
	ld a,$01		; $735b
	call objectGetRelatedObject1Var		; $735d
	ld a,(hl)		; $7360
	cp $7f			; $7361
	jr nz,_label_10_352	; $7363
	ld l,$b6		; $7365
	ld (hl),$01		; $7367
_label_10_352:
	ld a,$13		; $7369
	ld ($cc6a),a		; $736b
	jr _label_10_356		; $736e
_label_10_353:
	ld e,$c4		; $7370
	ld a,$02		; $7372
	ld (de),a		; $7374
	ld e,$c9		; $7375
	ld a,(de)		; $7377
	xor $10			; $7378
	ld (de),a		; $737a
	call $73ae		; $737b
	call objectGetAngleTowardEnemyTarget		; $737e
	ld ($d02c),a		; $7381
	ld a,$18		; $7384
	ld ($d02d),a		; $7386
	ld a,$52		; $7389
	call playSound		; $738b
_label_10_354:
	call $407e		; $738e
	jr z,_label_10_356	; $7391
	ld e,$c4		; $7393
	ld a,(de)		; $7395
	rst_jumpTable			; $7396
	sbc l			; $7397
	ld (hl),e		; $7398
	or (hl)			; $7399
	ld (hl),e		; $739a
	cp h			; $739b
	ld (hl),e		; $739c
	ld a,$01		; $739d
	ld (de),a		; $739f
	call objectSetVisible82		; $73a0
	ld e,$c2		; $73a3
	ld a,(de)		; $73a5
	ld hl,$73de		; $73a6
	rst_addAToHl			; $73a9
	ld e,$c9		; $73aa
	ld a,(hl)		; $73ac
	ld (de),a		; $73ad
	ld c,a			; $73ae
	ld b,$46		; $73af
	ld a,$02		; $73b1
	jp objectSetComponentSpeedByScaledVelocity		; $73b3
_label_10_355:
	call objectApplyComponentSpeed		; $73b6
	jp partAnimate		; $73b9
	ld a,$00		; $73bc
	call objectGetRelatedObject1Var		; $73be
	call checkObjectsCollided		; $73c1
	jr nc,_label_10_355	; $73c4
	ld l,$ae		; $73c6
	ld (hl),$78		; $73c8
	dec l			; $73ca
	ld (hl),$18		; $73cb
	push hl			; $73cd
	call objectGetAngleTowardEnemyTarget		; $73ce
	pop hl			; $73d1
	dec l			; $73d2
	xor $10			; $73d3
	ld (hl),a		; $73d5
	ld a,$4e		; $73d6
	call playSound		; $73d8
_label_10_356:
	jp partDelete		; $73db
	ld (bc),a		; $73de
	inc b			; $73df
	ld b,$08		; $73e0
	ld a,(bc)		; $73e2
	inc c			; $73e3
	ld c,$10		; $73e4
	ld (de),a		; $73e6
	inc d			; $73e7
	ld d,$18		; $73e8
	ld a,(de)		; $73ea
	inc e			; $73eb
	ld e,$00		; $73ec

partCode45:
	jr z,_label_10_357	; $73ee
	dec a			; $73f0
	jr nz,_label_10_358	; $73f1
	ld e,$ea		; $73f3
	ld a,(de)		; $73f5
	cp $80			; $73f6
	jr nz,_label_10_358	; $73f8
_label_10_357:
	ld e,$c2		; $73fa
	ld a,(de)		; $73fc
	or a			; $73fd
	ld e,$c4		; $73fe
	ld a,(de)		; $7400
	jr z,_label_10_360	; $7401
	or a			; $7403
	jr z,_label_10_359	; $7404
	call objectCheckSimpleCollision		; $7406
	jp z,objectApplyComponentSpeed		; $7409
_label_10_358:
	jp partDelete		; $740c
_label_10_359:
	ld h,d			; $740f
	ld l,e			; $7410
	inc (hl)		; $7411
	ld l,$e4		; $7412
	set 7,(hl)		; $7414
	ld a,$0b		; $7416
	call objectGetRelatedObject1Var		; $7418
	ld bc,$0f00		; $741b
	call objectTakePositionWithOffset		; $741e
	xor a			; $7421
	ld (de),a		; $7422
	ld bc,$5010		; $7423
	ld a,$08		; $7426
	call objectSetComponentSpeedByScaledVelocity		; $7428
	jp objectSetVisible82		; $742b
_label_10_360:
	or a			; $742e
	jr nz,_label_10_361	; $742f
	inc a			; $7431
	ld (de),a		; $7432
_label_10_361:
	ld a,$29		; $7433
	call objectGetRelatedObject1Var		; $7435
	ld a,(hl)		; $7438
	or a			; $7439
	jr z,_label_10_358	; $743a
	ld l,$ae		; $743c
	ld a,(hl)		; $743e
	or a			; $743f
	ret nz			; $7440
	call getFreePartSlot		; $7441
	ret nz			; $7444
	ld (hl),$45		; $7445
	inc l			; $7447
	inc (hl)		; $7448
	ld l,$d6		; $7449
	ld e,l			; $744b
	ld a,(de)		; $744c
	ldi (hl),a		; $744d
	ld e,l			; $744e
	ld a,(de)		; $744f
	ld (hl),a		; $7450
	ret			; $7451

partCode46:
	jr nz,_label_10_363	; $7452
	ld e,$c2		; $7454
	ld a,(de)		; $7456
	or a			; $7457
	jr z,_label_10_362	; $7458
	ld e,$c4		; $745a
	ld a,(de)		; $745c
	rst_jumpTable			; $745d
	sub $74			; $745e
.DB $eb				; $7460
	ld (hl),h		; $7461
	ld a,($ff00+c)		; $7462
	ld (hl),h		; $7463
_label_10_362:
	ld a,$29		; $7464
	call objectGetRelatedObject1Var		; $7466
	ld a,(hl)		; $7469
	or a			; $746a
	jr z,_label_10_363	; $746b
	ld l,$84		; $746d
	ld a,(hl)		; $746f
	cp $0a			; $7470
	jr nz,_label_10_363	; $7472
	ld l,$ae		; $7474
	ld a,(hl)		; $7476
	or a			; $7477
	ret nz			; $7478
	ld e,$c4		; $7479
	ld a,(de)		; $747b
	rst_jumpTable			; $747c
	add a			; $747d
	ld (hl),h		; $747e
	adc (hl)		; $747f
	ld (hl),h		; $7480
	sub h			; $7481
	ld (hl),h		; $7482
	or (hl)			; $7483
	ld (hl),h		; $7484
	or (hl)			; $7485
	ld (hl),h		; $7486
	ld h,d			; $7487
	ld l,e			; $7488
	inc (hl)		; $7489
	ld l,$c6		; $748a
	ld (hl),$1e		; $748c
	call partCommon_decCounter1IfNonzero		; $748e
	ret nz			; $7491
	ld l,e			; $7492
	inc (hl)		; $7493
	ld b,$03		; $7494
	call $7517		; $7496
	ret nz			; $7499
	ld a,b			; $749a
	sub $08			; $749b
	and $1f			; $749d
	ld b,a			; $749f
	call $74fd		; $74a0
	call $74fd		; $74a3
	call $74fd		; $74a6
	ld a,$ba		; $74a9
	call playSound		; $74ab
	ld h,d			; $74ae
	ld l,$c4		; $74af
	inc (hl)		; $74b1
	ld l,$c6		; $74b2
	ld (hl),$1e		; $74b4
	call partCommon_decCounter1IfNonzero		; $74b6
	ret nz			; $74b9
	ld l,e			; $74ba
	inc (hl)		; $74bb
	ld b,$02		; $74bc
	call $7517		; $74be
	ret nz			; $74c1
	ld a,b			; $74c2
	sub $06			; $74c3
	and $1f			; $74c5
	ld b,a			; $74c7
	call $74fd		; $74c8
	call $74fd		; $74cb
	ld a,$ba		; $74ce
	call playSound		; $74d0
_label_10_363:
	jp partDelete		; $74d3
	ld h,d			; $74d6
	ld l,e			; $74d7
	inc (hl)		; $74d8
	ld l,$e4		; $74d9
	set 7,(hl)		; $74db
	ld l,$d0		; $74dd
	ld (hl),$64		; $74df
	ld l,$c6		; $74e1
	ld (hl),$08		; $74e3
	call $7524		; $74e5
	call objectSetVisible82		; $74e8
	call partCommon_decCounter1IfNonzero		; $74eb
	jr nz,_label_10_364	; $74ee
	ld l,e			; $74f0
	inc (hl)		; $74f1
	call objectCheckSimpleCollision		; $74f2
	jr nz,_label_10_363	; $74f5
_label_10_364:
	call objectApplySpeed		; $74f7
	jp partAnimate		; $74fa
	call getFreePartSlot		; $74fd
	ret nz			; $7500
	ld (hl),$46		; $7501
	inc l			; $7503
	inc (hl)		; $7504
	ld l,$c9		; $7505
	ld a,b			; $7507
	add $04			; $7508
	and $1f			; $750a
	ld (hl),a		; $750c
	ld b,a			; $750d
	ld l,$d6		; $750e
	ld e,l			; $7510
	ld a,(de)		; $7511
	ldi (hl),a		; $7512
	ld e,l			; $7513
	ld a,(de)		; $7514
	ld (hl),a		; $7515
	ret			; $7516
	call checkBPartSlotsAvailable		; $7517
	ret nz			; $751a
	call $7524		; $751b
	call objectGetAngleTowardEnemyTarget		; $751e
	ld b,a			; $7521
	xor a			; $7522
	ret			; $7523
	ld a,$0b		; $7524
	call objectGetRelatedObject1Var		; $7526
	ld bc,$0a00		; $7529
	call objectTakePositionWithOffset		; $752c
	xor a			; $752f
	ld (de),a		; $7530
	ret			; $7531

partCode47:
	ld e,$c2		; $7532
	ld a,(de)		; $7534
	ld e,$c4		; $7535
	rst_jumpTable			; $7537
	ld b,d			; $7538
	ld (hl),l		; $7539
	ld a,b			; $753a
	ld (hl),l		; $753b
	rst $38			; $753c
	halt			; $753d
	dec l			; $753e
	ld (hl),a		; $753f
	ld b,a			; $7540
	ld (hl),a		; $7541
	ld b,$04		; $7542
	call checkBPartSlotsAvailable		; $7544
	ret nz			; $7547
	ld b,$04		; $7548
	ld e,$d7		; $754a
	ld a,(de)		; $754c
	ld c,a			; $754d
	call $7566		; $754e
	ld (hl),$80		; $7551
	ld c,h			; $7553
	dec b			; $7554
_label_10_365:
	call $7566		; $7555
	ld (hl),$c0		; $7558
	dec b			; $755a
	jr nz,_label_10_365	; $755b
	ld a,$19		; $755d
	call objectGetRelatedObject1Var		; $755f
	ld (hl),c		; $7562
	jp partDelete		; $7563
	call getFreePartSlot		; $7566
	ld (hl),$47		; $7569
	inc l			; $756b
	ld a,$05		; $756c
	sub b			; $756e
	ld (hl),a		; $756f
	call objectCopyPosition		; $7570
	ld l,$d7		; $7573
	ld (hl),c		; $7575
	dec l			; $7576
	ret			; $7577
	ld b,$02		; $7578
	call $777f		; $757a
	ld l,$a9		; $757d
	ld a,(hl)		; $757f
	or a			; $7580
	ld e,$c4		; $7581
	jr z,_label_10_366	; $7583
	ld a,(de)		; $7585
	rst_jumpTable			; $7586
	xor c			; $7587
	ld (hl),l		; $7588
	dec e			; $7589
	halt			; $758a
	ldd (hl),a		; $758b
	halt			; $758c
	ccf			; $758d
	halt			; $758e
	halt			; $758f
	halt			; $7590
	adc h			; $7591
	halt			; $7592
	cp h			; $7593
	halt			; $7594
	rst_jumpTable			; $7595
	halt			; $7596
	ld a,($ff00+$76)	; $7597
_label_10_366:
	ld a,(de)		; $7599
	cp $08			; $759a
	ret z			; $759c
	ld h,d			; $759d
	ld l,$e4		; $759e
	res 7,(hl)		; $75a0
	ld l,$da		; $75a2
	ld a,(hl)		; $75a4
	xor $80			; $75a5
	ld (hl),a		; $75a7
	ret			; $75a8
	inc e			; $75a9
	ld a,(de)		; $75aa
	rst_jumpTable			; $75ab
	or (hl)			; $75ac
	ld (hl),l		; $75ad
	ret c			; $75ae
	ld (hl),l		; $75af
.DB $fd				; $75b0
	ld (hl),l		; $75b1
	dec bc			; $75b2
	halt			; $75b3
	inc e			; $75b4
	halt			; $75b5
	ld h,d			; $75b6
	ld l,e			; $75b7
	inc (hl)		; $75b8
	ld l,$d4		; $75b9
	ld a,$20		; $75bb
	ldi (hl),a		; $75bd
	ld (hl),$ff		; $75be
	ld l,$c9		; $75c0
	ld (hl),$10		; $75c2
	ld l,$d0		; $75c4
	ld (hl),$78		; $75c6
	ld l,$cb		; $75c8
	ld a,$18		; $75ca
	ldi (hl),a		; $75cc
	inc l			; $75cd
	ld (hl),$78		; $75ce
	ld l,$f0		; $75d0
	ldi (hl),a		; $75d2
	ld (hl),$78		; $75d3
	jp objectSetVisible82		; $75d5
	ld c,$0e		; $75d8
	call objectUpdateSpeedZ_paramC		; $75da
	jr z,_label_10_367	; $75dd
	call objectApplySpeed		; $75df
	ld e,$cb		; $75e2
	ld a,(de)		; $75e4
	sub $18			; $75e5
	ld e,$f3		; $75e7
	ld (de),a		; $75e9
	ret			; $75ea
_label_10_367:
	ld l,$c5		; $75eb
	inc (hl)		; $75ed
	inc l			; $75ee
	ld a,$3c		; $75ef
	ld (hl),a		; $75f1
	call setScreenShakeCounter		; $75f2
	ld a,$6f		; $75f5
	call playSound		; $75f7
	jp $776f		; $75fa
	call partCommon_decCounter1IfNonzero		; $75fd
	ret nz			; $7600
	ld l,e			; $7601
	inc (hl)		; $7602
	ld l,$d0		; $7603
	ld a,$80		; $7605
	ldi (hl),a		; $7607
	ld (hl),$ff		; $7608
	ret			; $760a
	call objectApplyComponentSpeed		; $760b
	ld e,$cb		; $760e
	ld a,(de)		; $7610
	cp $18			; $7611
	ret nc			; $7613
	ld e,$c5		; $7614
	ld a,$04		; $7616
	ld (de),a		; $7618
	jp objectSetInvisible		; $7619
	ret			; $761c
	ld h,d			; $761d
	ld l,e			; $761e
	inc (hl)		; $761f
	ld l,$e4		; $7620
	set 7,(hl)		; $7622
	ld l,$c9		; $7624
	ld (hl),$12		; $7626
	ld l,$d4		; $7628
	ld a,$00		; $762a
	ldi (hl),a		; $762c
	ld (hl),$fe		; $762d
	call objectSetVisible82		; $762f
	ld h,d			; $7632
	ld l,$c9		; $7633
	ld a,(hl)		; $7635
	cp $1e			; $7636
	jr nz,_label_10_368	; $7638
	ld l,e			; $763a
	inc (hl)		; $763b
	call objectSetVisible81		; $763c
_label_10_368:
	ld a,(wFrameCounter)		; $763f
	and $0f			; $7642
	ld a,$a4		; $7644
	call z,playSound		; $7646
	ld e,$c9		; $7649
	ld a,(de)		; $764b
	inc a			; $764c
	and $1f			; $764d
	ld (de),a		; $764f
	and $0f			; $7650
	ld hl,$775f		; $7652
	rst_addAToHl			; $7655
	ld e,$f3		; $7656
	ld a,(hl)		; $7658
	ld (de),a		; $7659
	ld bc,$e605		; $765a
_label_10_369:
	ld a,$0b		; $765d
	call objectGetRelatedObject1Var		; $765f
	ldi a,(hl)		; $7662
	add b			; $7663
	ld b,a			; $7664
	ld e,$f0		; $7665
	ld (de),a		; $7667
	inc l			; $7668
	ld a,(hl)		; $7669
	add c			; $766a
	ld c,a			; $766b
	inc e			; $766c
	ld (de),a		; $766d
	ld e,$f3		; $766e
	ld a,(de)		; $7670
	ld e,$c9		; $7671
	jp objectSetPositionInCircleArc		; $7673
	ld a,(wFrameCounter)		; $7676
	and $07			; $7679
	ld a,$a4		; $767b
	call z,playSound		; $767d
	ld e,$c9		; $7680
	ld a,(de)		; $7682
	inc a			; $7683
	and $1f			; $7684
	ld (de),a		; $7686
	ld bc,$e009		; $7687
	jr _label_10_369		; $768a
	call partCommon_decCounter1IfNonzero		; $768c
	jr nz,_label_10_370	; $768f
	ld (hl),$02		; $7691
	ld l,$c9		; $7693
	inc (hl)		; $7695
	ld a,(hl)		; $7696
	cp $15			; $7697
	jr z,_label_10_371	; $7699
	ld c,a			; $769b
	ld b,$5a		; $769c
	ld a,$03		; $769e
	call objectSetComponentSpeedByScaledVelocity		; $76a0
_label_10_370:
	jp objectApplyComponentSpeed		; $76a3
_label_10_371:
	ld l,e			; $76a6
	inc (hl)		; $76a7
	ld l,$c6		; $76a8
	ld a,$3c		; $76aa
	ld (hl),a		; $76ac
	ld l,$e8		; $76ad
	ld (hl),$fc		; $76af
	call setScreenShakeCounter		; $76b1
	call $776f		; $76b4
	ld a,$6f		; $76b7
	jp playSound		; $76b9
	call partCommon_decCounter1IfNonzero		; $76bc
	ret nz			; $76bf
	ld l,e			; $76c0
	inc (hl)		; $76c1
	ld l,$d0		; $76c2
	ld (hl),$1e		; $76c4
	ret			; $76c6
	ld h,d			; $76c7
	ld l,$f0		; $76c8
	ld b,(hl)		; $76ca
	inc l			; $76cb
	ld c,(hl)		; $76cc
	ld l,$cb		; $76cd
	ldi a,(hl)		; $76cf
	ldh (<hFF8F),a	; $76d0
	inc l			; $76d2
	ld a,(hl)		; $76d3
	ldh (<hFF8E),a	; $76d4
	cp c			; $76d6
	jr nz,_label_10_372	; $76d7
	ldh a,(<hFF8F)	; $76d9
	cp b			; $76db
	jr nz,_label_10_372	; $76dc
	ld l,e			; $76de
	inc (hl)		; $76df
	ld l,$e4		; $76e0
	res 7,(hl)		; $76e2
	jp objectSetInvisible		; $76e4
_label_10_372:
	call objectGetRelativeAngleWithTempVars		; $76e7
	ld e,$c9		; $76ea
	ld (de),a		; $76ec
	jp objectApplySpeed		; $76ed
	ld a,$04		; $76f0
	call objectGetRelatedObject1Var		; $76f2
	ld a,(hl)		; $76f5
	cp $0a			; $76f6
	ret nz			; $76f8
	ld e,$c4		; $76f9
	ld a,$01		; $76fb
	ld (de),a		; $76fd
	ret			; $76fe
	ld a,(de)		; $76ff
	or a			; $7700
	jr z,_label_10_374	; $7701
	ld b,$47		; $7703
	call $777f		; $7705
	call $778b		; $7708
	ld a,e			; $770b
	add a			; $770c
	add e			; $770d
	add b			; $770e
	ld e,$cb		; $770f
	ld (de),a		; $7711
	ld a,l			; $7712
	add a			; $7713
	add l			; $7714
	add c			; $7715
	ld e,$cd		; $7716
	ld (de),a		; $7718
_label_10_373:
	ld a,$1a		; $7719
	call objectGetRelatedObject1Var		; $771b
	bit 7,(hl)		; $771e
	jp nz,objectSetVisible82		; $7720
	jp objectSetInvisible		; $7723
_label_10_374:
	inc a			; $7726
	ld (de),a		; $7727
	call partSetAnimation		; $7728
	jr _label_10_373		; $772b
	ld a,(de)		; $772d
	or a			; $772e
	jr z,_label_10_374	; $772f
	ld b,$47		; $7731
	call $777f		; $7733
	call $778b		; $7736
	ld a,e			; $7739
	add a			; $773a
	add b			; $773b
	ld e,$cb		; $773c
	ld (de),a		; $773e
	ld a,l			; $773f
	add a			; $7740
	add c			; $7741
	ld e,$cd		; $7742
	ld (de),a		; $7744
	jr _label_10_373		; $7745
	ld a,(de)		; $7747
	or a			; $7748
	jr z,_label_10_374	; $7749
	ld b,$47		; $774b
	call $777f		; $774d
	call $778b		; $7750
	ld a,e			; $7753
	add b			; $7754
	ld e,$cb		; $7755
	ld (de),a		; $7757
	ld a,l			; $7758
	add c			; $7759
	ld e,$cd		; $775a
	ld (de),a		; $775c
	jr _label_10_373		; $775d
	stop			; $775f
	ld de,$1412		; $7760
	ld d,$1a		; $7763
	ld e,$22		; $7765
	jr z,_label_10_375	; $7767
	ld e,$1a		; $7769
	ld d,$14		; $776b
	ld (de),a		; $776d
	ld de,$a7cd		; $776e
	ld a,$c0		; $7771
	ld (hl),$48		; $7773
	inc l			; $7775
	ld (hl),$02		; $7776
	ld l,$d6		; $7778
	ld a,$c0		; $777a
	ldi (hl),a		; $777c
	ld (hl),d		; $777d
	ret			; $777e
	ld a,$01		; $777f
	call objectGetRelatedObject1Var		; $7781
	ld a,(hl)		; $7784
	cp b			; $7785
	ret z			; $7786
	pop hl			; $7787
	jp partDelete		; $7788
_label_10_375:
	ld a,$30		; $778b
	call objectGetRelatedObject1Var		; $778d
	ld b,(hl)		; $7790
	inc l			; $7791
	ld c,(hl)		; $7792
	ld l,$cb		; $7793
	ldi a,(hl)		; $7795
	sub b			; $7796
	sra a			; $7797
	sra a			; $7799
	ld e,a			; $779b
	inc l			; $779c
	ld a,(hl)		; $779d
	sub c			; $779e
	sra a			; $779f
	sra a			; $77a1
	ld l,a			; $77a3
	ret			; $77a4

partCode48:
	ld e,$c2		; $77a5
	ld a,(de)		; $77a7
	ld e,$c4		; $77a8
	rst_jumpTable			; $77aa
	or a			; $77ab
	ld (hl),a		; $77ac
	sub $77			; $77ad
	ld d,c			; $77af
	ld a,b			; $77b0
	ld (hl),l		; $77b1
	ld a,b			; $77b2
	pop bc			; $77b3
	ld a,b			; $77b4
	pop hl			; $77b5
	ld a,b			; $77b6
	ld a,(de)		; $77b7
	or a			; $77b8
	jr z,_label_10_376	; $77b9
	call partCommon_decCounter1IfNonzero		; $77bb
	jp z,partDelete		; $77be
	ld a,(hl)		; $77c1
	and $0f			; $77c2
	ret nz			; $77c4
	call getFreePartSlot		; $77c5
	ret nz			; $77c8
	ld (hl),$48		; $77c9
	inc l			; $77cb
	inc (hl)		; $77cc
	ret			; $77cd
_label_10_376:
	ld h,d			; $77ce
	ld l,e			; $77cf
	inc (hl)		; $77d0
	ld l,$c6		; $77d1
	ld (hl),$96		; $77d3
	ret			; $77d5
	ld a,(de)		; $77d6
	rst_jumpTable			; $77d7
	sbc $77			; $77d8
	ld c,$78		; $77da
	ld sp,$6278		; $77dc
	ld l,e			; $77df
	inc (hl)		; $77e0
	ld l,$e4		; $77e1
	set 7,(hl)		; $77e3
	ldh a,(<hCameraY)	; $77e5
	ld b,a			; $77e7
	ldh a,(<hCameraX)	; $77e8
	ld c,a			; $77ea
	call getRandomNumber		; $77eb
	ld e,a			; $77ee
	and $07			; $77ef
	swap a			; $77f1
	add $28			; $77f3
	add c			; $77f5
	ld l,$cd		; $77f6
	ld (hl),a		; $77f8
	ld a,e			; $77f9
	and $70			; $77fa
	add $08			; $77fc
	ld e,a			; $77fe
	add b			; $77ff
	ld l,$cb		; $7800
	ld (hl),a		; $7802
	ld a,e			; $7803
	cpl			; $7804
	inc a			; $7805
	sub $07			; $7806
	ld l,$cf		; $7808
	ld (hl),a		; $780a
	jp objectSetVisiblec1		; $780b
	ld c,$20		; $780e
	call objectUpdateSpeedZ_paramC		; $7810
	jr nz,_label_10_377	; $7813
	call objectReplaceWithAnimationIfOnHazard		; $7815
	jp c,partDelete		; $7818
	ld h,d			; $781b
	ld l,$c4		; $781c
	inc (hl)		; $781e
	ld l,$db		; $781f
	ld a,$0b		; $7821
	ldi (hl),a		; $7823
	ldi (hl),a		; $7824
	ld (hl),$02		; $7825
	ld a,$a5		; $7827
	call playSound		; $7829
	ld a,$01		; $782c
	call partSetAnimation		; $782e
	ld e,$e1		; $7831
	ld a,(de)		; $7833
	bit 7,a			; $7834
	jp nz,partDelete		; $7836
	ld hl,$7847		; $7839
	rst_addAToHl			; $783c
	ld e,$e6		; $783d
	ldi a,(hl)		; $783f
	ld (de),a		; $7840
	inc e			; $7841
	ld a,(hl)		; $7842
	ld (de),a		; $7843
_label_10_377:
	jp partAnimate		; $7844
	inc b			; $7847
	add hl,bc		; $7848
	ld b,$0b		; $7849
	add hl,bc		; $784b
	inc c			; $784c
	ld a,(bc)		; $784d
	dec c			; $784e
	dec bc			; $784f
	ld c,$06		; $7850
	ld b,$cd		; $7852
	or b			; $7854
	jr nz,-$40		; $7855
	ld a,$00		; $7857
	call objectGetRelatedObject1Var		; $7859
	call objectTakePosition		; $785c
	ld b,$06		; $785f
_label_10_378:
	call getFreePartSlot		; $7861
	ld (hl),$48		; $7864
	inc l			; $7866
	ld (hl),$03		; $7867
	ld l,$c9		; $7869
	ld (hl),b		; $786b
	call objectCopyPosition		; $786c
	dec b			; $786f
	jr nz,_label_10_378	; $7870
	jp partDelete		; $7872
	ld a,(de)		; $7875
	or a			; $7876
	jr z,_label_10_379	; $7877
	ld c,$18		; $7879
	call objectUpdateSpeedZ_paramC		; $787b
	jp z,partDelete		; $787e
	jp objectApplySpeed		; $7881
_label_10_379:
	ld h,d			; $7884
	ld l,e			; $7885
	inc (hl)		; $7886
	ld l,$e4		; $7887
	set 7,(hl)		; $7889
	ld l,$db		; $788b
	ld a,$0b		; $788d
	ldi (hl),a		; $788f
	ldi (hl),a		; $7890
	ld a,$02		; $7891
	ld (hl),a		; $7893
	ld l,$e6		; $7894
	ldi (hl),a		; $7896
	ld (hl),a		; $7897
	ld l,$e8		; $7898
	ld (hl),$fc		; $789a
	ld l,$d0		; $789c
	ld (hl),$50		; $789e
	ld l,$d4		; $78a0
	ld a,$20		; $78a2
	ldi (hl),a		; $78a4
	ld (hl),$ff		; $78a5
	ld l,$c9		; $78a7
	ld a,(hl)		; $78a9
	dec a			; $78aa
	ld bc,$78bb		; $78ab
	call addAToBc		; $78ae
	ld a,(bc)		; $78b1
	ld (hl),a		; $78b2
	ld a,$02		; $78b3
	call partSetAnimation		; $78b5
	jp objectSetVisible82		; $78b8
	inc b			; $78bb
	ld ($160d),sp		; $78bc
	ld a,(de)		; $78bf
	ld e,$1a		; $78c0
	or a			; $78c2
	jr z,_label_10_380	; $78c3
	call partCommon_decCounter1IfNonzero		; $78c5
	jp z,partDelete		; $78c8
	ld a,(hl)		; $78cb
	and $0f			; $78cc
	ret nz			; $78ce
	call getFreePartSlot		; $78cf
	ret nz			; $78d2
	ld (hl),$48		; $78d3
	inc l			; $78d5
	ld (hl),$05		; $78d6
	ret			; $78d8
_label_10_380:
	ld h,d			; $78d9
	ld l,e			; $78da
	inc (hl)		; $78db
	ld l,$c6		; $78dc
	ld (hl),$61		; $78de
	ret			; $78e0
	ld a,(de)		; $78e1
	rst_jumpTable			; $78e2
	jp hl			; $78e3
	ld a,b			; $78e4
	ld bc,$2d79		; $78e5
	ld a,c			; $78e8
	ld h,d			; $78e9
	ld l,e			; $78ea
	inc (hl)		; $78eb
	ld l,$cb		; $78ec
	ld (hl),$28		; $78ee
	call getRandomNumber_noPreserveVars		; $78f0
	and $7f			; $78f3
	cp $40			; $78f5
	jr c,_label_10_381	; $78f7
	add $20			; $78f9
_label_10_381:
	ld e,$cd		; $78fb
	ld (de),a		; $78fd
	jp objectSetVisible82		; $78fe
	ld h,d			; $7901
	ld l,$d4		; $7902
	ld e,$ca		; $7904
	call add16BitRefs		; $7906
	cp $a0			; $7909
	jr nc,_label_10_382	; $790b
	dec l			; $790d
	ld a,(hl)		; $790e
	add $10			; $790f
	ldi (hl),a		; $7911
	ld a,(hl)		; $7912
	adc $00			; $7913
	ld (hl),a		; $7915
	ret			; $7916
_label_10_382:
	ld h,d			; $7917
	ld l,$c4		; $7918
	inc (hl)		; $791a
	ld l,$db		; $791b
	ld a,$0b		; $791d
	ldi (hl),a		; $791f
	ldi (hl),a		; $7920
	ld (hl),$02		; $7921
	ld a,$a5		; $7923
	call playSound		; $7925
	ld a,$01		; $7928
	call partSetAnimation		; $792a
	ld e,$e1		; $792d
	ld a,(de)		; $792f
	bit 7,a			; $7930
	jp nz,partDelete		; $7932
	jp partAnimate		; $7935

partCode49:
	ld e,$c4		; $7938
	ld a,(de)		; $793a
	rst_jumpTable			; $793b
	ld b,d			; $793c
	ld a,c			; $793d
	ld d,c			; $793e
	ld a,c			; $793f
	ld h,e			; $7940
	ld a,c			; $7941
	ld h,d			; $7942
	ld l,$c4		; $7943
	inc (hl)		; $7945
	ld l,$d0		; $7946
	ld (hl),$6e		; $7948
	ld l,$c6		; $794a
	ld (hl),$3c		; $794c
	jp objectSetVisible81		; $794e
	call partCommon_decCounter1IfNonzero		; $7951
	jr nz,_label_10_383	; $7954
	ld l,e			; $7956
	inc (hl)		; $7957
	ld a,$d3		; $7958
	call playSound		; $795a
	call objectGetAngleTowardEnemyTarget		; $795d
	ld e,$c9		; $7960
	ld (de),a		; $7962
	call $407e		; $7963
	jp z,partDelete		; $7966
	call objectApplySpeed		; $7969
_label_10_383:
	jp partAnimate		; $796c

partCode4a:
	jp nz,partDelete		; $796f
	ld e,$c4		; $7972
	ld a,(de)		; $7974
	rst_jumpTable			; $7975
	ld a,h			; $7976
	ld a,c			; $7977
	adc h			; $7978
	ld a,c			; $7979
	sbc (hl)		; $797a
	ld a,c			; $797b
	ld h,d			; $797c
	ld l,e			; $797d
	inc (hl)		; $797e
	ld l,$d0		; $797f
	ld (hl),$5a		; $7981
	ld l,$e6		; $7983
	ld a,$04		; $7985
	ldi (hl),a		; $7987
	ld (hl),a		; $7988
	jp objectSetVisible81		; $7989
	call $79ab		; $798c
	ld e,$cb		; $798f
	ld a,(de)		; $7991
	cp $88			; $7992
	jr c,_label_10_384	; $7994
	ld e,$c4		; $7996
	ld a,$02		; $7998
	ld (de),a		; $799a
_label_10_384:
	jp partAnimate		; $799b
	call objectApplySpeed		; $799e
	ld e,$cb		; $79a1
	ld a,(de)		; $79a3
	cp $b8			; $79a4
	jr c,_label_10_384	; $79a6
	jp partDelete		; $79a8
	ld e,$f1		; $79ab
	ld a,(de)		; $79ad
	ld c,a			; $79ae
	ld b,$9a		; $79af
	call objectGetRelativeAngle		; $79b1
	ld e,$c9		; $79b4
	ld (de),a		; $79b6
	jp objectApplySpeed		; $79b7

partCode4f:
	jr z,_label_10_386	; $79ba
	ld e,$c4		; $79bc
	ld a,(de)		; $79be
	cp $06			; $79bf
	jr nc,_label_10_386	; $79c1
	ld e,$ea		; $79c3
	ld a,(de)		; $79c5
	res 7,a			; $79c6
	cp $04			; $79c8
	jr c,_label_10_386	; $79ca
	cp $0c			; $79cc
	jp z,$7bc2		; $79ce
	cp $20			; $79d1
	jr nz,_label_10_385	; $79d3
	ld a,$24		; $79d5
	call objectGetRelatedObject2Var		; $79d7
	res 7,(hl)		; $79da
	ld e,$f3		; $79dc
	ld a,$01		; $79de
	ld (de),a		; $79e0
_label_10_385:
	ld h,d			; $79e1
	ld l,$e9		; $79e2
	ld (hl),$40		; $79e4
	ld l,$f2		; $79e6
	ld (hl),$3c		; $79e8
_label_10_386:
	ld e,$c2		; $79ea
	ld a,(de)		; $79ec
	ld e,$c4		; $79ed
	rst_jumpTable			; $79ef
.DB $f4				; $79f0
	ld a,c			; $79f1
	and h			; $79f2
	ld a,e			; $79f3
	ld h,d			; $79f4
	ld l,$f2		; $79f5
	ld a,(hl)		; $79f7
	or a			; $79f8
	jr z,_label_10_387	; $79f9
	dec (hl)		; $79fb
	jr nz,_label_10_387	; $79fc
	ld l,$e4		; $79fe
	set 7,(hl)		; $7a00
_label_10_387:
	ld a,(de)		; $7a02
	rst_jumpTable			; $7a03
	inc d			; $7a04
	ld a,d			; $7a05
	ld a,$7a		; $7a06
	and d			; $7a08
	ld a,d			; $7a09
	and e			; $7a0a
	ld a,d			; $7a0b
	cp c			; $7a0c
	ld a,d			; $7a0d
	dec e			; $7a0e
	ld a,e			; $7a0f
	ld (hl),$7b		; $7a10
	ld l,c			; $7a12
	ld a,e			; $7a13
	call getFreePartSlot		; $7a14
	ret nz			; $7a17
	ld (hl),$07		; $7a18
	inc l			; $7a1a
	ld (hl),$00		; $7a1b
	inc l			; $7a1d
	ld (hl),$08		; $7a1e
	ld l,$d6		; $7a20
	ld a,$c0		; $7a22
	ldi (hl),a		; $7a24
	ld (hl),d		; $7a25
	ld a,$0f		; $7a26
	ld ($cc6a),a		; $7a28
	ld h,d			; $7a2b
	ld l,$c4		; $7a2c
	inc (hl)		; $7a2e
	ld l,$cb		; $7a2f
	ld (hl),$50		; $7a31
	ld l,$cd		; $7a33
	ld (hl),$78		; $7a35
	ld l,$cf		; $7a37
	ld (hl),$fc		; $7a39
	jp objectSetVisible82		; $7a3b
	inc e			; $7a3e
	ld a,(de)		; $7a3f
	rst_jumpTable			; $7a40
	ld b,a			; $7a41
	ld a,d			; $7a42
	ld d,a			; $7a43
	ld a,d			; $7a44
	add d			; $7a45
	ld a,d			; $7a46
	ld a,($d00b)		; $7a47
	cp $78			; $7a4a
	jp nc,partAnimate		; $7a4c
	ld a,$01		; $7a4f
	ld (de),a		; $7a51
	ld a,$8d		; $7a52
	call playSound		; $7a54
	ld b,$04		; $7a57
	call checkBPartSlotsAvailable		; $7a59
	ret nz			; $7a5c
	ld bc,$0404		; $7a5d
_label_10_388:
	call getFreePartSlot		; $7a60
	ld (hl),$4f		; $7a63
	inc l			; $7a65
	inc (hl)		; $7a66
	ld l,$c9		; $7a67
	ld (hl),c		; $7a69
	call objectCopyPosition		; $7a6a
	ld a,c			; $7a6d
	add $08			; $7a6e
	ld c,a			; $7a70
	dec b			; $7a71
	jr nz,_label_10_388	; $7a72
	ld h,d			; $7a74
	ld l,$c5		; $7a75
	inc (hl)		; $7a77
	inc l			; $7a78
	ld (hl),$5a		; $7a79
	ld l,$cf		; $7a7b
	ld (hl),$00		; $7a7d
	jp objectSetInvisible		; $7a7f
	call partCommon_decCounter1IfNonzero		; $7a82
	ret nz			; $7a85
	call getFreeEnemySlot		; $7a86
	ret nz			; $7a89
	ld (hl),$02		; $7a8a
	ld e,$d8		; $7a8c
	ld a,$80		; $7a8e
	ld (de),a		; $7a90
	inc e			; $7a91
	ld a,h			; $7a92
	ld (de),a		; $7a93
	ld l,$96		; $7a94
	ld a,$c0		; $7a96
	ldi (hl),a		; $7a98
	ld (hl),d		; $7a99
	ld h,d			; $7a9a
	ld l,$c4		; $7a9b
	inc (hl)		; $7a9d
	inc l			; $7a9e
	ld (hl),$00		; $7a9f
	ret			; $7aa1
	ret			; $7aa2
	ld h,d			; $7aa3
	ld l,$cf		; $7aa4
	inc (hl)		; $7aa6
	ld a,(hl)		; $7aa7
	cp $fc			; $7aa8
	jr c,_label_10_389	; $7aaa
	ld l,e			; $7aac
	inc (hl)		; $7aad
	ld l,$e4		; $7aae
	set 7,(hl)		; $7ab0
	ld l,$d0		; $7ab2
	ld (hl),$14		; $7ab4
_label_10_389:
	jp partAnimate		; $7ab6
	ld a,$01		; $7ab9
	call objectGetRelatedObject2Var		; $7abb
	ld a,(hl)		; $7abe
	cp $02			; $7abf
	jr nz,_label_10_392	; $7ac1
	call $7bd6		; $7ac3
	ld l,$8b		; $7ac6
	ldi a,(hl)		; $7ac8
	srl a			; $7ac9
	ld b,a			; $7acb
	ld a,($d00b)		; $7acc
	srl a			; $7acf
	add b			; $7ad1
	ld b,a			; $7ad2
	inc l			; $7ad3
	ld a,(hl)		; $7ad4
	srl a			; $7ad5
	ld c,a			; $7ad7
	ld a,($d00d)		; $7ad8
	srl a			; $7adb
	add c			; $7add
	ld c,a			; $7ade
	ld e,$cd		; $7adf
	ld a,(de)		; $7ae1
	ldh (<hFF8E),a	; $7ae2
	ld e,$cb		; $7ae4
	ld a,(de)		; $7ae6
	ldh (<hFF8F),a	; $7ae7
	sub b			; $7ae9
	add $04			; $7aea
	cp $09			; $7aec
	jr nc,_label_10_390	; $7aee
	ldh a,(<hFF8E)	; $7af0
	sub c			; $7af2
	add $04			; $7af3
	cp $09			; $7af5
	jr c,_label_10_389	; $7af7
	ld a,(wFrameCounter)		; $7af9
	and $1f			; $7afc
	jr nz,_label_10_391	; $7afe
_label_10_390:
	call objectGetRelativeAngleWithTempVars		; $7b00
	ld e,$c9		; $7b03
	ld (de),a		; $7b05
_label_10_391:
	call objectApplySpeed		; $7b06
	jr _label_10_389		; $7b09
_label_10_392:
	ld h,d			; $7b0b
	ld l,$c4		; $7b0c
	ld e,l			; $7b0e
	ld (hl),$06		; $7b0f
	inc l			; $7b11
	ld (hl),$00		; $7b12
	ld l,$f2		; $7b14
	ld (hl),$00		; $7b16
	ld l,$e4		; $7b18
	res 7,(hl)		; $7b1a
	ret			; $7b1c
	call $7bd6		; $7b1d
	call partCommon_decCounter1IfNonzero		; $7b20
	jr z,_label_10_393	; $7b23
	call objectCheckTileCollision_allowHoles		; $7b25
	call nc,objectApplySpeed		; $7b28
	jr _label_10_389		; $7b2b
_label_10_393:
	ld l,$c4		; $7b2d
	dec (hl)		; $7b2f
	ld l,$d0		; $7b30
	ld (hl),$14		; $7b32
	jr _label_10_389		; $7b34
	inc e			; $7b36
	ld a,(de)		; $7b37
	rst_jumpTable			; $7b38
	ld b,c			; $7b39
	ld a,e			; $7b3a
	ld c,e			; $7b3b
	ld a,e			; $7b3c
	ld d,a			; $7b3d
	ld a,d			; $7b3e
	ld e,l			; $7b3f
	ld a,e			; $7b40
	ld h,d			; $7b41
	ld l,e			; $7b42
	inc (hl)		; $7b43
	ld l,$e6		; $7b44
	ld a,$10		; $7b46
	ldi (hl),a		; $7b48
	ld (hl),a		; $7b49
	ret			; $7b4a
	call objectCheckCollidedWithLink		; $7b4b
	jr nc,_label_10_394	; $7b4e
	ld e,$c5		; $7b50
	ld a,$02		; $7b52
	ld (de),a		; $7b54
	ld a,$8d		; $7b55
	call playSound		; $7b57
_label_10_394:
	jp partAnimate		; $7b5a
	ld h,d			; $7b5d
	ld l,$c4		; $7b5e
	inc (hl)		; $7b60
	ld l,$c6		; $7b61
	ld a,$3c		; $7b63
	ld (hl),a		; $7b65
	call setScreenShakeCounter		; $7b66
	call partCommon_decCounter1IfNonzero		; $7b69
	ret nz			; $7b6c
	ld a,$0f		; $7b6d
	ld (hl),a		; $7b6f
	call setScreenShakeCounter		; $7b70
_label_10_395:
	call getRandomNumber_noPreserveVars		; $7b73
	and $0f			; $7b76
	cp $0d			; $7b78
	jr nc,_label_10_395	; $7b7a
	inc a			; $7b7c
	ld c,a			; $7b7d
	push bc			; $7b7e
_label_10_396:
	call getRandomNumber_noPreserveVars		; $7b7f
	and $0f			; $7b82
	cp $09			; $7b84
	jr nc,_label_10_396	; $7b86
	pop bc			; $7b88
	inc a			; $7b89
	swap a			; $7b8a
	or c			; $7b8c
	ld c,a			; $7b8d
	ld b,$ce		; $7b8e
	ld a,(bc)		; $7b90
	or a			; $7b91
	jr nz,_label_10_395	; $7b92
	ld a,$48		; $7b94
	call breakCrackedFloor		; $7b96
	ld e,$c7		; $7b99
	ld a,(de)		; $7b9b
	inc a			; $7b9c
	cp $75			; $7b9d
	jp z,partDelete		; $7b9f
	ld (de),a		; $7ba2
	ret			; $7ba3
	ld a,(de)		; $7ba4
	or a			; $7ba5
	jr nz,_label_10_397	; $7ba6
	ld h,d			; $7ba8
	ld l,e			; $7ba9
	inc (hl)		; $7baa
	ld l,$c6		; $7bab
	ld (hl),$5a		; $7bad
	ld l,$d0		; $7baf
	ld (hl),$0f		; $7bb1
_label_10_397:
	call partCommon_decCounter1IfNonzero		; $7bb3
	jp z,partDelete		; $7bb6
	ld l,$da		; $7bb9
	ld a,(hl)		; $7bbb
	xor $80			; $7bbc
	ld (hl),a		; $7bbe
	jp objectApplySpeed		; $7bbf
	ld h,d			; $7bc2
	ld l,$c6		; $7bc3
	ld (hl),$78		; $7bc5
	ld l,$ec		; $7bc7
	ld a,(hl)		; $7bc9
	ld l,$c9		; $7bca
	ld (hl),a		; $7bcc
	ld l,$c4		; $7bcd
	ld (hl),$05		; $7bcf
	ld l,$d0		; $7bd1
	ld (hl),$50		; $7bd3
	ret			; $7bd5
	ld e,$f3		; $7bd6
	ld a,(de)		; $7bd8
	or a			; $7bd9
	ret z			; $7bda
	ld a,($ccf2)		; $7bdb
	or a			; $7bde
	ret nz			; $7bdf
	ld (de),a		; $7be0
	ld a,$29		; $7be1
	call objectGetRelatedObject2Var		; $7be3
	ld a,(hl)		; $7be6
	or a			; $7be7
	ret z			; $7be8
	ld l,$a4		; $7be9
	set 7,(hl)		; $7beb
	ret			; $7bed
