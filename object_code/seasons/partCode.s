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


; ==============================================================================
; PARTID_SLINGSHOT_EYE_STATUE
; ==============================================================================
partCode0d:
	jr z,@normalStatus	; $641a
	call objectSetVisible83		; $641c
	ld h,d			; $641f
	ld l,$c6		; $6420
	ld (hl),$2d		; $6422
	ld l,Part.subid		; $6424
	ld a,(hl)		; $6426
	ld b,a			; $6427
	and $07			; $6428
	ld hl,$ccba		; $642a
	call setFlag		; $642d
	bit 7,b			; $6430
	jr z,@normalStatus	; $6432
	ld e,Part.state		; $6434
	ld a,$02		; $6436
	ld (de),a		; $6438
@normalStatus:
	ld e,Part.state		; $6439
	ld a,(de)		; $643b
	rst_jumpTable			; $643c
	.dw @state0
	.dw @state1
	.dw objectSetVisible83
@state0:
	ld a,$01		; $6443
	ld (de),a		; $6445
	ret			; $6446
@state1:
	call partCommon_decCounter1IfNonzero		; $6447
	ret nz			; $644a
	ld e,Part.subid		; $644b
	ld a,(de)		; $644d
	ld hl,$ccba		; $644e
	call unsetFlag		; $6451
	jp objectSetInvisible		; $6454


partCode16:
	jr z,@normalStatus	; $6457
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
	jr nz,+			; $646d
	ld a,(wScrollMode)		; $646f
	and $01			; $6472
	jr z,+			; $6474
	ld a,(wLinkDeathTrigger)		; $6476
	or a			; $6479
	jp nz,@normalStatus		; $647a
	call _func_6515		; $647d
	inc a			; $6480
	ld (wDisableScreenTransitions),a		; $6481
	ld ($cca4),a		; $6484
	ld ($cbca),a		; $6487
	inc a			; $648a
	ld ($cfd0),a		; $648b
	ld a,$08		; $648e
	ld ($cfc0),a		; $6490
+
	ld a,$01		; $6493
	ld ($cc36),a		; $6495
@normalStatus:
	ld hl,$cfd0		; $6498
	ld a,(hl)		; $649b
	inc a			; $649c
	jp z,partDelete		; $649d
	ld e,$c4		; $64a0
	ld a,(de)		; $64a2
	rst_jumpTable			; $64a3
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01		; $64aa
	ld (de),a		; $64ac
@state1:
	ld a,(wLinkObjectIndex)		; $64ad
	ld h,a			; $64b0
	ld l,$00		; $64b1
	call preventObjectHFromPassingObjectD		; $64b3
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $64b6
@state2:
	call @state1		; $64b9
	ld hl,$cfd0		; $64bc
	ld a,(hl)		; $64bf
	cp $02			; $64c0
	ret z			; $64c2
	ld e,$c5		; $64c3
	ld a,(de)		; $64c5
	or a			; $64c6
	jr nz,+			; $64c7
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
+
	call partCommon_decCounter1IfNonzero		; $64d9
	jr nz,+			; $64dc
	ld a,($cd00)		; $64de
	and $01			; $64e1
	jr z,+			; $64e3
	ld a,($cc34)		; $64e5
	or a			; $64e8
	jp nz,+			; $64e9
	call _func_6515		; $64ec
	inc a			; $64ef
	ld (wDisableScreenTransitions),a		; $64f0
	ld ($cfd0),a		; $64f3
	ld (wDisabledObjects),a		; $64f6
	ld ($cbca),a		; $64f9
+
	ldi a,(hl)		; $64fc
	cp $5a			; $64fd
	jr nz,+			; $64ff
	ld e,$f0		; $6501
	ld a,$04		; $6503
	ld (de),a		; $6505
+
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

_func_6515:
	ld a,(wLinkObjectIndex)		; $6515
	ld b,a			; $6518
	ld c,$2b		; $6519
	ld a,$80		; $651b
	ld (bc),a		; $651d
	ld c,$2d		; $651e
	xor a			; $6520
	ld (bc),a		; $6521
	ret			; $6522


; ==============================================================================
; PARTID_SHOOTING_DRAGON_HEAD
; ==============================================================================
partCode24:
	jr z,@normalStatus	; $6523
	ld e,$ea		; $6525
	ld a,(de)		; $6527
	cp $80			; $6528
	jp nz,partDelete		; $652a
@normalStatus:
	ld e,$c2		; $652d
	ld a,(de)		; $652f
	ld e,$c4		; $6530
	rst_jumpTable			; $6532
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
@subid1:
	ld a,(de)		; $6539
	or a			; $653a
	jr z,@func_656b	; $653b
	call partCommon_decCounter1IfNonzero		; $653d
	ret nz			; $6540
	ld l,$c2		; $6541
	bit 0,(hl)		; $6543
	ld l,$cd		; $6545
	ldh a,(<hEnemyTargetX)	; $6547
	jr nz,@func_654f	; $6549
	cp (hl)			; $654b
	ret c			; $654c
	jr +			; $654d

@func_654f:
	cp (hl)			; $654f
	ret nc			; $6550
+
	call _func_65b8		; $6551
	ret nc			; $6554
	call getRandomNumber_noPreserveVars		; $6555
	cp $50			; $6558
	ret nc			; $655a
	call _func_65a6		; $655b
	ret nz			; $655e
	ld l,$c9		; $655f
	ld (hl),$08		; $6561
	ld e,$c2		; $6563
	ld a,(de)		; $6565
	or a			; $6566
	ret z			; $6567
	ld (hl),$18		; $6568
	ret			; $656a
@func_656b:
	ld h,d			; $656b
	ld l,e			; $656c
	inc (hl)		; $656d
	ld l,$c6		; $656e
	inc (hl)		; $6570
	ret			; $6571
@subid2:
	ld a,(de)		; $6572
	rst_jumpTable			; $6573
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld h,d			; $657a
	ld l,e			; $657b
	inc (hl)		; $657c
	ld l,$c6		; $657d
	ld (hl),$10		; $657f
	ld l,$e4		; $6581
	set 7,(hl)		; $6583
	jp objectSetVisible81		; $6585
@state1:
	call partCommon_decCounter1IfNonzero		; $6588
	jr nz,+			; $658b
	ld l,e			; $658d
	inc (hl)		; $658e
@state2:
	call partCode.partCommon_checkTileCollisionOrOutOfBounds		; $658f
	jp c,partDelete		; $6592
+
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

_func_65a6:
	call getFreePartSlot		; $65a6
	ret nz			; $65a9
	ld (hl),PARTID_SHOOTING_DRAGON_HEAD		; $65aa
	inc l			; $65ac
	ld (hl),$02		; $65ad
	call objectCopyPosition		; $65af
	ld l,$d0		; $65b2
	ld (hl),$3c		; $65b4
	xor a			; $65b6
	ret			; $65b7

_func_65b8:
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


; ==============================================================================
; PARTID_WALL_ARROW_SHOOTER
; ==============================================================================
partCode25:
	ld e,$c4		; $65c8
	ld a,(de)		; $65ca
	or a			; $65cb
	jr nz,+			; $65cc
	ld h,d			; $65ce
	ld l,e			; $65cf
	inc (hl)		; $65d0
	ld l,$c2		; $65d1
	ld a,(hl)		; $65d3
	swap a			; $65d4
	rrca			; $65d6
	ld l,$c9		; $65d7
	ld (hl),a		; $65d9
+
	call partCommon_decCounter1IfNonzero		; $65da
	ret nz			; $65dd
	ld e,$c2		; $65de
	ld a,(de)		; $65e0
	bit 0,a			; $65e1
	ld e,$cd		; $65e3
	ldh a,(<hEnemyTargetX)	; $65e5
	jr z,+			; $65e7
	ld e,$cb		; $65e9
	ldh a,(<hEnemyTargetY)	; $65eb
+
	ld b,a			; $65ed
	ld a,(de)		; $65ee
	sub b			; $65ef
	add $10			; $65f0
	cp $21			; $65f2
	ret nc			; $65f4
	ld e,$c6		; $65f5
	ld a,$21		; $65f7
	ld (de),a		; $65f9
	ld hl,_table_6661		; $65fa
	jr _func_6649		; $65fd


; ==============================================================================
; PARTID_CANNON_ARROW_SHOOTER
; ==============================================================================
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
	ld hl,_table_6669		; $6646

_func_6649:
	ld e,$c2		; $6649
	ld a,(de)		; $664b
	rst_addDoubleIndex			; $664c
	ldi a,(hl)		; $664d
	ld b,a			; $664e
	ld c,(hl)		; $664f
	call getFreePartSlot		; $6650
	ret nz			; $6653
	ld (hl),PARTID_ENEMY_ARROW		; $6654
	inc l			; $6656
	inc (hl)		; $6657
	call objectCopyPositionWithOffset		; $6658
	ld l,$c9		; $665b
	ld e,l			; $665d
	ld a,(de)		; $665e
	ld (hl),a		; $665f
	ret			; $6660

_table_6661:
	.db $fc $00 ; shooting up
	.db $00 $04 ; shooting right
	.db $04 $00 ; shooting down
	.db $00 $fc ; shooting left

_table_6669:
	.db $f8 $00
	.db $00 $08
	.db $08 $00
	.db $00 $f8


; ==============================================================================
; PARTID_WALL_FLAME_SHOOTERS_FLAMES
; ==============================================================================
partCode26:
	jr z,@normalStatus		; $6671
	ld e,$ea		; $6673
	ld a,(de)		; $6675
	res 7,a			; $6676
	cp $03			; $6678
	jp nc,seasonsFunc_10_670c		; $667a
@normalStatus:
	call _func_66e7		; $667d
	jp c,seasonsFunc_10_670c		; $6680
	ld e,$c4		; $6683
	ld a,(de)		; $6685
	rst_jumpTable			; $6686
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
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
@state1:
	call partCommon_decCounter1IfNonzero		; $66a4
	jr nz,+			; $66a7
	ld (hl),$10		; $66a9
	ld l,e			; $66ab
	inc (hl)		; $66ac
	jr $26			; $66ad
+
	ld a,(hl)		; $66af
	rrca			; $66b0
	jr nc,@func_66bd	; $66b1
	ld l,$d0		; $66b3
	ld a,(hl)		; $66b5
	cp $78			; $66b6
	jr z,@func_66bd		; $66b8
	add $05			; $66ba
	ld (hl),a		; $66bc
@func_66bd:
	call objectApplySpeed		; $66bd
	call partAnimate		; $66c0
	ld e,$e1		; $66c3
	ld a,(de)		; $66c5
	ld hl,@table_66d2		; $66c6
	rst_addAToHl			; $66c9
	ld e,$e6		; $66ca
	ld a,(hl)		; $66cc
	ld (de),a		; $66cd
	inc e			; $66ce
	ld a,(hl)		; $66cf
	ld (de),a		; $66d0
	ret			; $66d1
@table_66d2:
	.db $02 $04 $06
@state2:
	call partCode.partCommon_decCounter1IfNonzero		; $66d5
	jp z,partDelete		; $66d8
	ld a,(hl)		; $66db
	rrca			; $66dc
	jr nc,@func_66bd	; $66dd
	ld l,$d0		; $66df
	ld a,(hl)		; $66e1
	sub $0a			; $66e2
	ld (hl),a		; $66e4
	jr @func_66bd		; $66e5

_func_66e7:
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

seasonsFunc_10_670c:
	call objectCreatePuff		; $670c
	jp partDelete		; $670f


; ==============================================================================
; PARTID_BURIED_MOLDORM
; ==============================================================================
partCode2b:
	jr z,@normalStatus	; $6712
	ld e,$ea		; $6714
	ld a,(de)		; $6716
	cp $9a			; $6717
	ret nz			; $6719
	ld hl,$cfc0		; $671a
	set 0,(hl)		; $671d
	jp partDelete		; $671f
@normalStatus:
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


; ==============================================================================
; PARTID_KING_MOBLINS_CANNONS
; ==============================================================================
partCode2d:
	jr z,@normalStatus	; $6733
	ld h,d			; $6735
	ld l,$f0		; $6736
	bit 0,(hl)		; $6738
	jp nz,seasonsFunc_10_67cc		; $673a
	inc (hl)		; $673d
	ld l,$e9		; $673e
	ld (hl),$00		; $6740
	ld l,$c6		; $6742
	ld (hl),$41		; $6744
	jp objectSetInvisible		; $6746
@normalStatus:
	ld e,$c2		; $6749
	ld a,(de)		; $674b
	srl a			; $674c
	ld e,$c4		; $674e
	rst_jumpTable			; $6750
	.dw @subid0
	.dw @subid1
@subid0:
	ld a,(de)		; $6755
	or a			; $6756
	jr nz,@func_6775	; $6757

@func_6759:
	ld h,d			; $6759
	ld l,e			; $675a
	inc (hl)		; $675b
	ld l,$cb		; $675c
	res 3,(hl)		; $675e
	ld l,$cd		; $6760
	res 3,(hl)		; $6762
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED		; $6764
	call checkGlobalFlag		; $6766
	jp nz,partDelete		; $6769
	ld e,$c2		; $676c
	ld a,(de)		; $676e
	call partSetAnimation		; $676f
	jp objectSetVisible82		; $6772
@func_6775:
	call partAnimate		; $6775
	ld e,$e1		; $6778
	ld a,(de)		; $677a
	or a			; $677b
	ret z			; $677c
	ld bc,$fa13		; $677d
	dec a			; $6780
	jr z,_func_67a4	; $6781
	jr _func_6797		; $6783
@subid1:
	ld a,(de)		; $6785
	or a			; $6786
	jr z,@func_6759	; $6787
	call partAnimate		; $6789
	ld e,$e1		; $678c
	ld a,(de)		; $678e
	or a			; $678f
	ret z			; $6790
	ld bc,$faed		; $6791
	dec a			; $6794
	jr z,_func_67a4	; $6795
_func_6797:
	call getFreePartSlot		; $6797
	ret nz			; $679a
	ld (hl),PARTID_KING_MOBLIN_BOMB		; $679b
	inc l			; $679d
	inc (hl)		; $679e
	call objectCopyPositionWithOffset		; $679f
	jr _func_67b7		; $67a2
_func_67a4:
	ld (de),a		; $67a4
	ld a,$81		; $67a5
	call playSound		; $67a7
	call getFreeInteractionSlot		; $67aa
	ret nz			; $67ad
	ld (hl),INTERACID_PUFF		; $67ae
	ld l,$42		; $67b0
	ld (hl),$80		; $67b2
	jp objectCopyPositionWithOffset		; $67b4
_func_67b7:
	ld e,$c2		; $67b7
	ld a,(de)		; $67b9
	bit 1,a			; $67ba
	ld b,$04		; $67bc
	jr z,+			; $67be
	ld b,$12		; $67c0
+
	call getRandomNumber		; $67c2
	and $06			; $67c5
	add b			; $67c7
	ld l,$c9		; $67c8
	ld (hl),a		; $67ca
	ret			; $67cb

seasonsFunc_10_67cc:
	call partCommon_decCounter1IfNonzero		; $67cc
	jp z,partDelete		; $67cf
	ld a,(hl)		; $67d2
	cp $35			; $67d3
	jr z,_func_67f8		; $67d5
	and $0f			; $67d7
	ret nz			; $67d9
	ld a,(hl)		; $67da
	and $f0			; $67db
	swap a			; $67dd
	dec a			; $67df
	ld hl,_table_67f0		; $67e0
	rst_addDoubleIndex			; $67e3
	ldi a,(hl)		; $67e4
	ld c,(hl)		; $67e5
	ld b,a			; $67e6
	call getFreeInteractionSlot		; $67e7
	ret nz			; $67ea
	ld (hl),INTERACID_EXPLOSION		; $67eb
	jp objectCopyPositionWithOffset		; $67ed
_table_67f0:
	.db $f8 $04 $08 $fe
	.db $fa $f8 $02 $0c
_func_67f8:
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
	jr z,+			; $6812
	ld b,$a6		; $6814
+
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
	jr z,++			; $6826
	ld e,$e1		; $6828
	ld a,(de)		; $682a
	or a			; $682b
	jr z,+			; $682c
	bit 7,a			; $682e
	jp nz,partDelete		; $6830
	call _func_6853		; $6833
+
	jp partAnimate		; $6836
++
	ld a,$01		; $6839
	ld (de),a		; $683b
	call objectGetTileAtPosition		; $683c
	cp $f3			; $683f
	jp z,partDelete		; $6841
	ld h,$ce		; $6844
	ld a,(hl)		; $6846
	or a			; $6847
	jp nz,partDelete		; $6848
	ld a,SND_POOF		; $684b
	call playSound		; $684d
	jp objectSetVisible83		; $6850
	
_func_6853:
	push af			; $6853
	xor a			; $6854
	ld (de),a		; $6855
	call objectGetTileAtPosition		; $6856
	pop af			; $6859
	ld e,$f0		; $685a
	dec a			; $685c
	jr z,+			; $685d
	ld a,(de)		; $685f
	ld (hl),a		; $6860
	ret			; $6861
+
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
	jr z,@normalStatus	; $687b
	ld e,$c5		; $687d
	ld a,(de)		; $687f
	or a			; $6880
	jr nz,_func_68d5	; $6881
	call _func_68cc		; $6883
	ld a,$af		; $6886
	jp playSound		; $6888
@normalStatus:
	ld e,$c4		; $688b
	ld a,(de)		; $688d
	rst_jumpTable			; $688e
	.dw @state0
	.dw @state1
@state0:
	ld a,$01		; $6893
	ld (de),a		; $6895
	ld e,$c2		; $6896
	ld a,(de)		; $6898
	call partSetAnimation		; $6899
	call getRandomNumber_noPreserveVars		; $689c
	and $03			; $689f
	ld hl,@table_68b9		; $68a1
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
@table_68b9:
	.db $0a $0f $0f $14
@state1:
	ld e,$c5		; $68bd
	ld a,(de)		; $68bf
	or a			; $68c0
	jr nz,_func_68d5	; $68c1
	call objectApplySpeed		; $68c3
	call partCommon_decCounter1IfNonzero		; $68c6
	jp nz,seasonsFunc_10_68e0		; $68c9

_func_68cc:
	ld h,d			; $68cc
	ld l,$c5		; $68cd
	inc (hl)		; $68cf
	ld a,$02		; $68d0
	jp partSetAnimation		; $68d2

_func_68d5:
	call partAnimate		; $68d5
	ld e,$e1		; $68d8
	ld a,(de)		; $68da
	inc a			; $68db
	jp z,partDelete		; $68dc
	ret			; $68df

seasonsFunc_10_68e0:
	ld h,d			; $68e0
	ld l,$c7		; $68e1
	dec (hl)		; $68e3
	ret nz			; $68e4
	ld (hl),$10		; $68e5
	call getRandomNumber		; $68e7
	and $03			; $68ea
	ret nz			; $68ec
	and $01			; $68ed
	jr nz,+			; $68ef
	ld a,$ff		; $68f1
+
	ld l,$c9		; $68f3
	add (hl)		; $68f5
	ld (hl),a		; $68f6
	ret			; $68f7


partCode33:
	ld e,$c4		; $68f8
	ld a,(de)		; $68fa
	rst_jumpTable			; $68fb
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld h,d			; $6902
	ld l,e			; $6903
	inc (hl)		; $6904
	ld l,$d0		; $6905
	ld (hl),$50		; $6907
	ld b,$00		; $6909
	ld a,($cc45)		; $690b
	and $30			; $690e
	jr z,+			; $6910
	ld b,$20		; $6912
	and $20			; $6914
	jr z,+			; $6916
	ld b,$e0		; $6918
+
	ld a,($d00d)		; $691a
	add b			; $691d
	ld c,a			; $691e
	sub $08			; $691f
	cp $90			; $6921
	jr c,+			; $6923
	ld c,$08		; $6925
	cp $d0			; $6927
	jr nc,+			; $6929
	ld c,$98		; $692b
+
	ld b,$a0		; $692d
	call objectGetRelativeAngle		; $692f
	ld e,$c9		; $6932
	ld (de),a		; $6934
	jp objectSetVisible81		; $6935
@state1:
	call objectApplySpeed		; $6938
	ld e,$cb		; $693b
	ld a,(de)		; $693d
	cp $98			; $693e
	jr c,@animate		; $6940
	ld h,d			; $6942
	ld l,$c4		; $6943
	inc (hl)		; $6945
	ld l,$c6		; $6946
	ld (hl),$78		; $6948
@animate:
	jp partAnimate		; $694a
@state2:
	call partCommon_decCounter1IfNonzero		; $694d
	jp z,partDelete		; $6950
	jr @animate		; $6953


partCode38:
	ld e,$d7		; $6955
	ld a,(de)		; $6957
	or a			; $6958
	jp z,partDelete		; $6959
	ld e,$c4		; $695c
	ld a,(de)		; $695e
	rst_jumpTable			; $695f
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld h,d			; $6968
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
@state1:
	call partCommon_decCounter1IfNonzero		; $6980
	ret nz			; $6983
	ld l,e			; $6984
	inc (hl)		; $6985
	call objectSetVisible81		; $6986
@state2:
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
	jr nc,@applySpeedAndAnimate	; $69a0
	ld l,$f1		; $69a2
	ld e,$cd		; $69a4
	ld a,(de)		; $69a6
	sub (hl)		; $69a7
	add $08			; $69a8
	cp $11			; $69aa
	jr nc,@applySpeedAndAnimate	; $69ac
	ld l,$c4		; $69ae
	inc (hl)		; $69b0
@applySpeedAndAnimate:
	call objectApplySpeed		; $69b1
	jp partAnimate		; $69b4
@state3:
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
	jr nc,@applySpeedAndAnimate	; $69d0
	ld l,$8d		; $69d2
	ld e,$cd		; $69d4
	ld a,(de)		; $69d6
	sub (hl)		; $69d7
	add $04			; $69d8
	cp $09			; $69da
	jr nc,@applySpeedAndAnimate	; $69dc
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
	jr nz,+			; $69ed
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
+
	ld e,$d7		; $6a08
	ld a,(de)		; $6a0a
	inc a			; $6a0b
	jp z,partDelete		; $6a0c
	call _func_6a28		; $6a0f
	ret nz			; $6a12
	call partCode.partCommon_checkOutOfBounds		; $6a13
	jp z,partDelete		; $6a16
	ld a,(wFrameCounter)		; $6a19
	rrca			; $6a1c
	jr c,+			; $6a1d
	ld e,$dc		; $6a1f
	ld a,(de)		; $6a21
	xor $07			; $6a22
	ld (de),a		; $6a24
+
	jp objectApplySpeed		; $6a25

_func_6a28:
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
	jr z,+			; $6a3f
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
+
	ld a,b			; $6a57
	call partSetAnimation		; $6a58
	or d			; $6a5b
	ret			; $6a5c


partCode3a:
	jr z,@normalStatus	; $6a5d
	ld e,$ea		; $6a5f
	ld a,(de)		; $6a61
	res 7,a			; $6a62
	cp $04			; $6a64
	jp c,partDelete		; $6a66
	jp _func_6bdd		; $6a69
@normalStatus:
	ld e,$c2		; $6a6c
	ld a,(de)		; $6a6e
	ld e,$c4		; $6a6f
	rst_jumpTable			; $6a71
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
@subid0:
	ld a,(de)		; $6a7a
	or a			; $6a7b
	jr z,+			; $6a7c
@func_6a7e:
	call partCode.partCommon_checkOutOfBounds		; $6a7e
	jp z,partDelete		; $6a81
	call objectApplySpeed		; $6a84
	jp partAnimate		; $6a87
+
	call _func_6be3		; $6a8a
	call objectGetAngleTowardEnemyTarget		; $6a8d
	ld e,$c9		; $6a90
	ld (de),a		; $6a92
	call _func_6bf0		; $6a93
	jp objectSetVisible80		; $6a96
@subid1:
	ld a,(de)		; $6a99
	or a			; $6a9a
	jr nz,@func_6a7e	; $6a9b
	call _func_6be3		; $6a9d
	call _func_6bc2		; $6aa0
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
@func_6ab5:
	call getFreePartSlot		; $6ab5
	ld (hl),PARTID_3a		; $6ab8
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
@subid2:
	ld a,(de)		; $6acc
	rst_jumpTable			; $6acd
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @func_6a7e
@@state0:
	ld h,d			; $6ad6
	ld l,$db		; $6ad7
	ld a,$03		; $6ad9
	ldi (hl),a		; $6adb
	ld (hl),a		; $6adc
	ld l,$c3		; $6add
	ld a,(hl)		; $6adf
	or a			; $6ae0
	jr z,+			; $6ae1
	ld l,e			; $6ae3
	ld (hl),$03		; $6ae4
	call _func_6bf0		; $6ae6
	ld a,$01		; $6ae9
	call partSetAnimation		; $6aeb
	jp objectSetVisible82		; $6aee
+
	call _func_6be3		; $6af1
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
	jr nc,+			; $6b06
	ld b,$2d		; $6b08
	cp $0a			; $6b0a
	jr nc,+			; $6b0c
	ld b,$41		; $6b0e
+
	ld e,$d0		; $6b10
	ld a,b			; $6b12
	ld (de),a		; $6b13
	jp objectSetVisible80		; $6b14
@@state1:
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
	jr nc,@@func_6b4d	; $6b2b
	ldh a,(<hFF8F)	; $6b2d
	sub b			; $6b2f
	add $02			; $6b30
	cp $05			; $6b32
	jr nc,@@func_6b4d	; $6b34
	ldbc INTERACID_PUFF $02		; $6b36
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
@@func_6b4d:
	call objectGetRelativeAngleWithTempVars		; $6b4d
	ld e,$c9		; $6b50
	ld (de),a		; $6b52
	call objectApplySpeed		; $6b53
	jp partAnimate		; $6b56
@@state2:
	ld a,$21		; $6b59
	call objectGetRelatedObject2Var		; $6b5b
	bit 7,(hl)		; $6b5e
	ret z			; $6b60
	ld b,$05		; $6b61
	call checkBPartSlotsAvailable		; $6b63
	ret nz			; $6b66
	ld c,$05		; $6b67
-
	ld a,c			; $6b69
	dec a			; $6b6a
	ld hl,@@table_6b8b		; $6b6b
	rst_addAToHl			; $6b6e
	ld b,(hl)		; $6b6f
	ld e,$02		; $6b70
	call @func_6ab5		; $6b72
	dec c			; $6b75
	jr nz,-			; $6b76
	ld h,d			; $6b78
	ld l,$c4		; $6b79
	inc (hl)		; $6b7b
	ld l,$c9		; $6b7c
	ld (hl),$1d		; $6b7e
	call _func_6bf0		; $6b80
	ld a,$01		; $6b83
	call partSetAnimation		; $6b85
	jp objectSetVisible82		; $6b88
@@table_6b8b:
	.db $03 $08 $0d $13 $18

@subid3:
	ld a,(de)		; $6b90
	or a			; $6b91
	jr z,++			; $6b92
	call partCommon_decCounter1IfNonzero		; $6b94
	jp z,_func_6bdd		; $6b97
	inc l			; $6b9a
	dec (hl)		; $6b9b
	jr nz,+			; $6b9c
	ld (hl),$07		; $6b9e
	call objectGetAngleTowardEnemyTarget		; $6ba0
	call objectNudgeAngleTowards		; $6ba3
+
	call objectApplySpeed		; $6ba6
	jp partAnimate		; $6ba9
++
	call _func_6be3		; $6bac
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
_func_6bc2:
	ld a,$29		; $6bc2
	call objectGetRelatedObject1Var		; $6bc4
	ld a,(hl)		; $6bc7
	ld b,$1e		; $6bc8
	cp $10			; $6bca
	jr nc,+			; $6bcc
	ld b,$2d		; $6bce
	cp $0a			; $6bd0
	jr nc,+			; $6bd2
	ld b,$3c		; $6bd4
+
	ld e,$d0		; $6bd6
	ld a,b			; $6bd8
	ld (de),a		; $6bd9
	jp objectSetVisible80		; $6bda
_func_6bdd:
	call objectCreatePuff		; $6bdd
	jp partDelete		; $6be0
_func_6be3:
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
_func_6bf0:
	ld a,$29		; $6bf0
	call objectGetRelatedObject1Var		; $6bf2
	ld a,(hl)		; $6bf5
	ld b,$3c		; $6bf6
	cp $10			; $6bf8
	jr nc,+			; $6bfa
	ld b,$5a		; $6bfc
	cp $0a			; $6bfe
	jr nc,+			; $6c00
	ld b,$78		; $6c02
+
	ld e,$d0		; $6c04
	ld a,b			; $6c06
	ld (de),a		; $6c07
	ret			; $6c08


partCode3b:
	ld e,$c4		; $6c09
	ld a,(de)		; $6c0b
	or a			; $6c0c
	jr nz,+			; $6c0d
	inc a			; $6c0f
	ld (de),a		; $6c10
+
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
	jr z,+			; $6c2d
	res 7,a			; $6c2f
	ld (de),a		; $6c31
+
	ld l,$8b		; $6c32
	ld b,(hl)		; $6c34
	ld l,$8d		; $6c35
	ld c,(hl)		; $6c37
	ld l,$88		; $6c38
	ld a,(hl)		; $6c3a
	cp $04			; $6c3b
	jr c,+			; $6c3d
	sub $04			; $6c3f
	add a			; $6c41
	inc a			; $6c42
+
	add a			; $6c43
	ld hl,seasonsTable_10_6c5b		; $6c44
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
seasonsTable_10_6c5b:
	.db $f8 $06
	.db $06 $02
	.db $02 $0c
	.db $02 $06
	.db $09 $fa
	.db $06 $02
	.db $02 $f4
	.db $02 $06


partCode3c:
	ld e,$c4		; $6c6b
	ld a,(de)	; $6c6d
	or a		; $6c6e
	jr z,@state0	; $6c6f
	ld bc,$0104		; $6c71
	call partCommon_decCounter1IfNonzero		; $6c74
	jr z,@delete	; $6c77
	ld a,(hl)		; $6c79
	cp $46			; $6c7a
	jr z,+			; $6c7c
	ld bc,$0206		; $6c7e
	cp $28			; $6c81
	jp nz,partAnimate		; $6c83
+
	ld l,$e6		; $6c86
	ld (hl),c		; $6c88
	inc l			; $6c89
	ld (hl),c		; $6c8a
	ld a,b			; $6c8b
	jp partSetAnimation		; $6c8c
@delete:
	pop hl			; $6c8f
	jp partDelete		; $6c90
@state0:
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
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld h,d			; $6ca9
	ld l,e			; $6caa
	inc (hl)		; $6cab
	ld e,$c2		; $6cac
	ld a,(de)		; $6cae
	or a			; $6caf
	jr nz,+			; $6cb0
	ld l,$d4		; $6cb2
	ld a,$40		; $6cb4
	ldi (hl),a		; $6cb6
	ld (hl),$ff		; $6cb7
	ld l,$d0		; $6cb9
	ld (hl),$3c		; $6cbb
+
	inc e			; $6cbd
	ld a,(de)		; $6cbe
	or a			; $6cbf
	jr z,+			; $6cc0
	ld l,$c4		; $6cc2
	inc (hl)		; $6cc4
	ld l,$e4		; $6cc5
	res 7,(hl)		; $6cc7
	ld l,$c6		; $6cc9
	ld (hl),$1e		; $6ccb
	call @func_6cf4		; $6ccd
+
	jp objectSetVisiblec1		; $6cd0
@state1:
	call partCode.partCommon_checkOutOfBounds		; $6cd3
	jp z,partDelete		; $6cd6
	call objectApplySpeed		; $6cd9
	ld c,$0e		; $6cdc
	call objectUpdateSpeedZ_paramC		; $6cde
	jr nz,@animate	; $6ce1
	ld l,$c4		; $6ce3
	inc (hl)		; $6ce5
	ld l,$c6		; $6ce6
	ld (hl),$a0		; $6ce8
	ld l,$e6		; $6cea
	ld (hl),$05		; $6cec
	inc l			; $6cee
	ld (hl),$04		; $6cef
	call _func_6e13		; $6cf1
@func_6cf4:
	ld a,$6f		; $6cf4
	call playSound		; $6cf6
	ld a,$01		; $6cf9
	jp partSetAnimation		; $6cfb
@state2:
	call partCommon_decCounter1IfNonzero		; $6cfe
	jr nz,@animate	; $6d01
	ld (hl),$14		; $6d03
	ld l,e			; $6d05
	inc (hl)		; $6d06
	ld a,$02		; $6d07
	jp partSetAnimation		; $6d09
@state3:
	call partCommon_decCounter1IfNonzero		; $6d0c
	jp z,partDelete		; $6d0f
@animate:
	jp partAnimate		; $6d12


partCode3e:
	jr z,@normalStatus	; $6d15
	ld e,$ea		; $6d17
	ld a,(de)		; $6d19
	cp $9a			; $6d1a
	jr nz,@normalStatus	; $6d1c
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
@normalStatus:
	ld e,$c4		; $6d33
	ld a,(de)		; $6d35
	rst_jumpTable			; $6d36
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld h,d			; $6d41
	ld l,e			; $6d42
	inc (hl)		; $6d43
	ld l,$c3		; $6d44
	ld a,(hl)		; $6d46
	or a			; $6d47
	ld a,$1e		; $6d48
	jr nz,@func_6d87	; $6d4a
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
@state1:
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
	jr nc,+			; $6d72
	ldh a,(<hFF8F)	; $6d74
	sub b			; $6d76
	inc a			; $6d77
	cp $03			; $6d78
	jr c,++			; $6d7a
+
	call objectGetRelativeAngleWithTempVars		; $6d7c
	ld e,$c9		; $6d7f
	ld (de),a		; $6d81
	jp objectApplySpeed		; $6d82
++
	ld a,$a0		; $6d85
@func_6d87:
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
@state2:
	inc e			; $6d9e
	ld a,(de)		; $6d9f
	rst_jumpTable			; $6da0
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	xor a			; $6da9
	ld (wLinkGrabState2),a		; $6daa
	inc a			; $6dad
	ld (de),a		; $6dae
	jp objectSetVisible81		; $6daf
@substate1:
	call _func_6e70		; $6db2
	ret z			; $6db5
	call dropLinkHeldItem		; $6db6
	jp partDelete		; $6db9
@substate2:
	call _func_6e37		; $6dbc
	jp c,partDelete		; $6dbf
	ld e,$cf		; $6dc2
	ld a,(de)		; $6dc4
	or a			; $6dc5
	ret nz			; $6dc6
	ld e,$c5		; $6dc7
	ld a,$03		; $6dc9
	ld (de),a		; $6dcb
	ret			; $6dcc
@substate3:
	ld b,INTERACID_SNOWDEBRIS		; $6dcd
	call objectCreateInteractionWithSubid00		; $6dcf
	ret nz			; $6dd2
	jp partDelete		; $6dd3
@state3:
	call _func_6e70		; $6dd6
	jp nz,partDelete		; $6dd9
	call partCommon_decCounter1IfNonzero		; $6ddc
	jr z,+			; $6ddf
	ld e,$c2		; $6de1
	ld a,(de)		; $6de3
	or a			; $6de4
	jp nz,seasonsFunc_10_6e6a		; $6de5
	call partAnimate		; $6de8
	jr ++			; $6deb
+
	ld l,$c4		; $6ded
	inc (hl)		; $6def
	ld a,$02		; $6df0
	jp partSetAnimation		; $6df2
@state4:
	ld e,$e1		; $6df5
	ld a,(de)		; $6df7
	inc a			; $6df8
	jp z,partDelete		; $6df9
	call partAnimate		; $6dfc
++
	ld e,$e1		; $6dff
	ld a,(de)		; $6e01
	cp $ff			; $6e02
	ret z			; $6e04
	ld hl,_table_6e10		; $6e05
	rst_addAToHl			; $6e08
	ld e,$e6		; $6e09
	ld a,(hl)		; $6e0b
	ld (de),a		; $6e0c
	inc e			; $6e0d
	ld (de),a		; $6e0e
	ret			; $6e0f
_table_6e10:
	.db $02 $04 $06

_func_6e13:
	ld e,$c2		; $6e13
	ld a,(de)
	cp $03		; $6e16
	ret nc			; $6e18
	call getFreePartSlot		; $6e19
	ret nz			; $6e1c
	ld (hl),PARTID_3d		; $6e1d
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
_func_6e37:
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
	jr nc,+			; $6e56
	ld (hl),$00		; $6e58
	ld l,$a4		; $6e5a
	res 7,(hl)		; $6e5c
+
	ld a,$63		; $6e5e
	call playSound		; $6e60
	ld a,$83		; $6e63
	call playSound		; $6e65
	scf			; $6e68
	ret			; $6e69

seasonsFunc_10_6e6a:
	call objectAddToGrabbableObjectBuffer		; $6e6a
	jp objectPushLinkAwayOnCollision		; $6e6d
_func_6e70:
	ld a,$01		; $6e70
	call objectGetRelatedObject1Var		; $6e72
	ld a,(hl)		; $6e75
	cp $77			; $6e76
	ret z			; $6e78
	call objectCreatePuff		; $6e79
	or d			; $6e7c
	ret			; $6e7d


; ==============================================================================
; PARTID_KING_MOBLIN_BOMB
; ==============================================================================
partCode3f:
	jr z,@normalStatus	; $6e7e
	ld e,$c2		; $6e80
	ld a,(de)		; $6e82
	or a			; $6e83
	jr nz,@normalStatus	; $6e84
	ld e,$ea		; $6e86
	ld a,(de)		; $6e88
	cp $95			; $6e89
	jr nz,@normalStatus	; $6e8b
	ld h,d			; $6e8d
	call _kingMoblinBomb_explode		; $6e8e
@normalStatus:
	ld e,$c2		; $6e91
	ld a,(de)		; $6e93
	ld e,$c4		; $6e94
	rst_jumpTable			; $6e96
	.dw _kingMoblinBomb_subid0
	.dw _kingMoblinBomb_subid1


_kingMoblinBomb_subid0:
	ld a,(de)		; $6e9b
	rst_jumpTable			; $6e9c
	.dw _kingMoblinBomb_state0
	.dw _seasons_kingMoblinBomb_state1
	.dw _kingMoblinBomb_state2
	.dw _kingMoblinBomb_state3
	.dw _kingMoblinBomb_state4
	.dw _kingMoblinBomb_state5
	.dw _kingMoblinBomb_state6
	.dw _kingMoblinBomb_state7
	.dw _kingMoblinBomb_state8


_kingMoblinBomb_state0:
	ld h,d			; $6eaf
	ld l,e			; $6eb0
	inc (hl)		; $6eb1
	
	ld l,Part.angle		; $6eb2
	ld (hl),ANGLE_DOWN		; $6eb4
	
	ld l,Part.speed		; $6eb6
	ld (hl),SPEED_140		; $6eb8
	
	ld l,Part.speedZ	; $6eba
	ld (hl),$00		; $6ebc
	inc l			; $6ebe
	ld (hl),$fe		; $6ebf
	jp objectSetVisiblec2		; $6ec1


_seasons_kingMoblinBomb_state1:
	ret			; $6ec4


; Being held by Link
_kingMoblinBomb_state2:
	inc e			; $71df
	ld a,(de)		; $71e0
	rst_jumpTable			; $71e1
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @atRest

@justGrabbed:
	ld a,$01		; $71ea
	ld (de),a ; [state2] = 1
	xor a			; $71ed
	ld (wLinkGrabState2),a		; $71ee
.ifdef ROM_AGES
	call objectSetVisiblec1		; $71f1
.else
	jp objectSetVisiblec1
.endif

@beingHeld:
	call _common_kingMoblinBomb_state1		; $71f4
	ret nz			; $71f7
	jp dropLinkHeldItem		; $71f8

@released:
	; Drastically reduce speed when Y < $30 (on moblin's platform), Z = 0,
	; and subid = 0.
	ld e,Part.yh		; $71fb
	ld a,(de)		; $71fd
	cp $30			; $71fe
	jr nc,@beingHeld	; $7200

	ld h,d			; $7202
	ld l,Part.zh		; $7203
	ld e,Part.subid		; $7205
	ld a,(de)		; $7207
	or (hl)			; $7208
	jr nz,@beingHeld	; $7209

	; Reduce speed
	ld hl,w1ReservedItemC.speedZ+1		; $720b
	sra (hl)		; $720e
	dec l			; $7210
	rr (hl)			; $7211
	ld l,Item.speed		; $7213
	ld (hl),SPEED_40		; $7215

	jp _common_kingMoblinBomb_state1		; $7217

@atRest:
	ld e,Part.state		; $721a
	ld a,$04		; $721c
	ld (de),a		; $721e

	call objectSetVisiblec2		; $721f
	jr _kingMoblinBomb_state4		; $7222


; Being thrown. (King moblin sets the state to this.)
_kingMoblinBomb_state3:
	ld c,$20		; $6f0a
	call objectUpdateSpeedZAndBounce		; $6f0c
	jr c,@doneBouncing	; $6f0f

	call z,_kingMoblinBomb_playSound		; $6f11
	jp objectApplySpeed		; $6f14

@doneBouncing:
	ld h,d			; $6f17
	ld l,Part.state		; $6f18
	inc (hl)		; $6f1a
	call _kingMoblinBomb_playSound		; $6f1b


; Waiting to be picked up (by link or king moblin)
_kingMoblinBomb_state4:
	call _common_kingMoblinBomb_state1		; $7240
	ret z			; $7243
	jp objectAddToGrabbableObjectBuffer		; $7244


; Exploding
_kingMoblinBomb_state5:
	ld h,d			; $7247
	ld l,Part.animParameter		; $7248
	ld a,(hl)		; $724a
	inc a			; $724b
	jp z,partDelete		; $724c

	dec a			; $724f
	jr z,@animate	; $7250

	ld l,Part.collisionRadiusY		; $7252
	ldi (hl),a		; $7254
	ld (hl),a		; $7255
	call _kingMoblinBomb_checkCollisionWithLink		; $7256
	call _kingMoblinBomb_checkCollisionWithKingMoblin		; $7259
@animate:
	jp partAnimate		; $725c


_kingMoblinBomb_state6:
	ld bc,-$240		; $725f
	call objectSetSpeedZ		; $7262

	ld l,e			; $7265
	inc (hl) ; [state] = 7

	ld l,Part.speed		; $7267
	ld (hl),SPEED_c0		; $7269

	ld l,Part.counter1		; $726b
	ld (hl),$07		; $726d

	; Decide angle to throw at based on king moblin's position
	ld a,Object.xh		; $726f
	call objectGetRelatedObject1Var		; $7271
	ld a,(hl)		; $7274
	cp $50			; $7275
	ld a,$07		; $7277
	jr c,+			; $7279
	ld a,$19		; $727b
+
	ld e,Part.angle		; $727d
	ld (de),a		; $727f
	ret			; $7280


_kingMoblinBomb_state7:
	call partCommon_decCounter1IfNonzero		; $7281
	ret nz			; $7284

	ld l,e			; $7285
	inc (hl) ; [state] = 8


_kingMoblinBomb_state8:
	ld c,$20		; $7287
	call objectUpdateSpeedZAndBounce		; $7289
	jp nc,objectApplySpeed		; $728c

	ld h,d			; $728f
	jp _kingMoblinBomb_explode		; $7290


_kingMoblinBomb_subid1:
	ld a,(de)		; $6f71
	rst_jumpTable			; $6f72
	.dw _kingMoblinBomb_subid1_state0
	.dw _kingMoblinBomb_subid1_state1
	.dw _kingMoblinBomb_subid1_state2

_kingMoblinBomb_subid1_state0:
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


_kingMoblinBomb_subid1_state1:
	ld c,$20		; $6f8a
	call objectUpdateSpeedZAndBounce		; $6f8c
	jr c,@doneBouncing	; $6f8f
	call z,_kingMoblinBomb_playSound		; $6f91
	jp objectApplySpeed		; $6f94
@doneBouncing:
	ld h,d			; $6f97
	ld l,Part.state		; $6f98
	inc (hl)		; $6f9a


_kingMoblinBomb_playSound:
	ld a,SND_BOMB_LAND		; $6f9b
	jp playSound		; $6f9d


_kingMoblinBomb_subid1_state2:
	ld h,d			; $6fa0
	ld l,Part.animParameter		; $6fa1
	bit 0,(hl)		; $6fa3
	jp z,partAnimate		; $6fa5
	ld (hl),$00		; $6fa8
	ld l,Part.counter2		; $6faa
	inc (hl)		; $6fac
	ld a,(hl)		; $6fad
	cp $04			; $6fae
	jp c,partAnimate		; $6fb0
	ld l,Part.subid		; $6fb3
	dec (hl)		; $6fb5
	jr _kingMoblinBomb_explode		; $6fb6


_common_kingMoblinBomb_state1:
	ld h,d			; $6fb8

	ld l,Part.animParameter		; $6fb9
	bit 0,(hl)		; $6fbb
	jr z,@animate			; $6fbd

	ld (hl),$00		; $6fbf
	ld l,Part.counter2		; $6fc1
	inc (hl)		; $6fc3

	ld a,(hl)		; $6fc4
	cp $08			; $6fc5
	jr nc,_kingMoblinBomb_explode	; $6fc7

@animate:
	jp partAnimate		; $6fc9

	; Unused code snippet?
	or d			; $6fcc
	ret			; $6fcd

_kingMoblinBomb_explode:
	ld l,Part.state		; $71c4
	ld (hl),$05		; $71c6

.ifdef ROM_SEASONS
	ld l,Part.collisionType		; $6fd2
	res 7,(hl)		; $6fd4
.endif

	ld l,Part.oamFlagsBackup		; $71c8
	ld a,$0a		; $71ca
	ldi (hl),a		; $71cc
	ldi (hl),a		; $71cd
	ld (hl),$0c ; [oamTileIndexBase]

	ld a,$01		; $71d0
	call partSetAnimation		; $71d2
	call objectSetVisible82		; $71d5
	ld a,SND_EXPLOSION		; $71d8
	call playSound		; $71da
	xor a			; $71dd
	ret			; $71de


;;
; @addr{7293}
_kingMoblinBomb_checkCollisionWithLink:
	ld e,Part.var30		; $7293
	ld a,(de)		; $7295
	or a			; $7296
	ret nz			; $7297

	call checkLinkVulnerable		; $7298
	ret nc			; $729b

	call objectCheckCollidedWithLink_ignoreZ		; $729c
	ret nc			; $729f

	call objectGetAngleTowardEnemyTarget		; $72a0

	ld hl,w1Link.knockbackCounter		; $72a3
	ld (hl),$10		; $72a6
	dec l			; $72a8
	ldd (hl),a ; [w1Link.knockbackAngle]
	ld (hl),20 ; [w1Link.invincibilityCounter]
	dec l			; $72ac
	ld (hl),$01 ; [w1Link.var2a] (TODO: what does this mean?)

	ld e,Part.damage		; $72af
	ld l,<w1Link.damageToApply		; $72b1
	ld a,(de)		; $72b3
	ld (hl),a		; $72b4

	ld e,Part.var30		; $72b5
	ld a,$01		; $72b7
	ld (de),a		; $72b9
	ret			; $72ba


;;
; @addr{72bb}
_kingMoblinBomb_checkCollisionWithKingMoblin:
	ld e,Part.relatedObj1+1		; $72bb
	ld a,(de)		; $72bd
	or a			; $72be
	ret z			; $72bf

	; Check king moblin's collisions are enabled
	ld a,Object.collisionType		; $72c0
	call objectGetRelatedObject1Var		; $72c2
	bit 7,(hl)		; $72c5
	ret z			; $72c7

	ld l,Enemy.invincibilityCounter		; $72c8
	ld a,(hl)		; $72ca
	or a			; $72cb
	ret nz			; $72cc

	call checkObjectsCollided		; $72cd
	ret nc			; $72d0

	ld l,Enemy.var2a		; $72d1
	ld (hl),$80|ITEMCOLLISION_BOMB		; $72d3
	ld l,Enemy.invincibilityCounter		; $72d5
	ld (hl),30		; $72d7

	ld l,Enemy.health		; $72d9
	dec (hl)		; $72db
	ret			; $72dc


; ==============================================================================
; PARTID_AQUAMENTUS_PROJECTILE
; ==============================================================================
partCode40:
	jp nz,partDelete		; $7037
	ld e,$c4		; $703a
	ld a,(de)		; $703c
	rst_jumpTable			; $703d
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
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
	jr z,_func_7081		; $7053
	ret			; $7055
@state1:
	call partCommon_decCounter1IfNonzero		; $7056
	ret nz			; $7059
	ld l,e			; $705a
	inc (hl)		; $705b
	ld a,$00		; $705c
	call objectGetRelatedObject1Var		; $705e
	ld bc,$f0f0		; $7061
	call objectTakePositionWithOffset		; $7064
	jp objectSetVisible80		; $7067
@state2:
	call objectApplySpeed		; $706a
	call partCommon_checkOutOfBounds		; $706d
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
_func_7081:
	call objectGetAngleTowardEnemyTarget		; $7081
	ld e,$c9		; $7084
	ld (de),a		; $7086
	ld c,$03		; $7087
	call _func_708e		; $7089
	ld c,$fd		; $708c
_func_708e:
	call getFreePartSlot		; $708e
	ret nz			; $7091
	ld (hl),PARTID_AQUAMENTUS_PROJECTILE		; $7092
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


; ==============================================================================
; PARTID_DODONGO_FIREBALL
; ==============================================================================
partCode41:
	ld e,$c4		; $70aa
	ld a,(de)		; $70ac
	or a			; $70ad
	jr z,@state0		; $70ae
	call objectApplySpeed		; $70b0
	call objectCheckWithinScreenBoundary		; $70b3
	jp nc,partDelete		; $70b6
	jp partAnimate		; $70b9
@state0:
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
	jr z,+			; $70d1
	ld e,$cd		; $70d3
+
	swap a			; $70d5
	rlca			; $70d7
	ld b,a			; $70d8
	ld hl,_table_70f3		; $70d9
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
_table_70f3:
	.db $ee $12 $10 $ee


; ==============================================================================
; PARTID_MOTHULA_PROJECTILE_2
; ==============================================================================
partCode42:
	jr z,@normalStatus			; $70f7
	ld e,$ea		; $70f9
	ld a,(de)		; $70fb
	res 7,a			; $70fc
	cp $04			; $70fe
	jr c,@delete	; $7100
@normalStatus:
	ld e,$c4		; $7102
	ld a,(de)		; $7104
	or a			; $7105
	jr z,@state0	; $7106
	call partCode.partCommon_checkTileCollisionOrOutOfBounds		; $7108
	jr z,@delete	; $710b
	ld e,$c2		; $710d
	ld a,(de)		; $710f
	cp $02			; $7110
	jr z,+			; $7112
	call partCommon_decCounter1IfNonzero		; $7114
	jr nz,+			; $7117
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
+
	call objectApplySpeed		; $712c
	call partAnimate		; $712f
	ld e,$e1		; $7132
	ld a,(de)		; $7134
	inc a			; $7135
	ret nz			; $7136
@delete:
	jp partDelete		; $7137
@state0:
	call _func_7174		; $713a
	ret nz			; $713d
	call objectSetVisible82		; $713e
	ld h,d			; $7141
	ld l,$c4		; $7142
	inc (hl)		; $7144
	ld e,$c2		; $7145
	ld a,(de)		; $7147
	cp $02			; $7148
	jr nz,+			; $714a
	ld l,$cf		; $714c
	ld a,(hl)		; $714e
	ld (hl),$00		; $714f
	ld l,$cb		; $7151
	add (hl)		; $7153
	ld (hl),a		; $7154
	ld l,$d0		; $7155
	ld (hl),$32		; $7157
	ret			; $7159
+
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
_func_7174:
	ld e,$c2		; $7174
	ld a,(de)		; $7176
	bit 7,a			; $7177
	jr z,_func_71b5	; $7179
	rrca			; $717b
	ld a,$04		; $717c
	ld bc,$0300		; $717e
	jr nc,+			; $7181
	ld a,$03		; $7183
	ld bc,$0503		; $7185
+
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
	ld bc,_table_71fc		; $7199
	call addAToBc		; $719c
-
	push bc			; $719f
	call getFreePartSlot		; $71a0
	ld (hl),PARTID_MOTHULA_PROJECTILE_2		; $71a3
	call objectCopyPosition		; $71a5
	pop bc			; $71a8
	ld l,$c9		; $71a9
	ld a,(bc)		; $71ab
	ld (hl),a		; $71ac
	inc bc			; $71ad
	ld hl,$ff8b		; $71ae
	dec (hl)		; $71b1
	jr nz,-			; $71b2
	ret			; $71b4
_func_71b5:
	dec a			; $71b5
	jr z,+			; $71b6
	xor a			; $71b8
	ret			; $71b9
+
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
	call _func_71e2		; $71d7
	ld a,b			; $71da
	add $0c			; $71db
	and $1f			; $71dd
	ld b,a			; $71df
	ld c,$03		; $71e0

_func_71e2:
	push bc			; $71e2
	call getFreePartSlot		; $71e3
	ld (hl),PARTID_MOTHULA_PROJECTILE_2		; $71e6
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
	jr nz,_func_71e2	; $71f9
	ret			; $71fb
_table_71fc:
	.db $0c $14 $1c $08
	.db $0d $13 $18 $1d


partCode43:
	ld e,$c2		; $7204
	ld a,(de)		; $7206
	ld e,$c4		; $7207
	rst_jumpTable			; $7209
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
@subid0:
	ld a,(de)		; $7214
	or a			; $7215
	jr z,@func_724b		; $7216
	call partAnimate		; $7218
	call partCommon_decCounter1IfNonzero		; $721b
	jp nz,objectApplyComponentSpeed		; $721e
	ld b,$06		; $7221
-
	ld a,b			; $7223
	dec a			; $7224
	ld hl,@table_7245		; $7225
	rst_addAToHl			; $7228
	ld c,(hl)		; $7229
	call @func_7236		; $722a
	dec b			; $722d
	jr nz,-			; $722e
	call objectCreatePuff		; $7230
	jp partDelete		; $7233
@func_7236:
	call getFreePartSlot		; $7236
	ret nz			; $7239
	ld (hl),PARTID_43		; $723a
	inc l			; $723c
	ld (hl),$03		; $723d
	ld l,$c9		; $723f
	ld (hl),c		; $7241
	jp objectCopyPosition		; $7242
@table_7245:
	.db $03 $08 $0d
	.db $13 $18 $1d

@func_724b:
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
	jr @subid1@func_729a		; $726d
@subid1:
	ld a,(de)		; $726f
	rst_jumpTable			; $7270
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
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
@@state1:
	call partCommon_decCounter1IfNonzero		; $728c
	ret nz			; $728f
	ld (hl),$b4		; $7290
	ld l,e			; $7292
	inc (hl)		; $7293
	ld l,$e4		; $7294
	set 7,(hl)		; $7296
	ld b,$3c		; $7298
@@func_729a:
	call _func_733d		; $729a
	call objectSetVisible81		; $729d
	ld a,$72		; $72a0
	jp playSound		; $72a2
@@state2:
	call partCommon_decCounter1IfNonzero		; $72a5
	jp z,partDelete		; $72a8
	jp partAnimate		; $72ab
@subid2:
	ld a,(de)		; $72ae
	or a			; $72af
	jr z,@func_72be	; $72b0

@seasonsFunc_10_72b2:
	call partCommon_checkOutOfBounds	; $72b2
	jp z,partDelete		; $72b5
	call objectApplyComponentSpeed		; $72b8
	jp partAnimate		; $72bb
@func_72be:
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
	call @subid1@func_729a		; $72dd
	ld bc,$0213		; $72e0
	call @func_72e9		; $72e3
	ld bc,$030d		; $72e6
@func_72e9:
	call getFreePartSlot		; $72e9
	ld (hl),PARTID_43		; $72ec
	inc l			; $72ee
	ld (hl),$04		; $72ef
	inc l			; $72f1
	ld (hl),b		; $72f2
	ld l,$c9		; $72f3
	ld (hl),c		; $72f5
	jp objectCopyPosition		; $72f6
@subid3:
	ld a,(de)		; $72f9
	or a			; $72fa
	jr z,+			; $72fb
	call objectApplyComponentSpeed		; $72fd
	ld c,$12		; $7300
	call objectUpdateSpeedZ_paramC		; $7302
	jp nz,partAnimate		; $7305
	jp partDelete		; $7308
+
	ld bc,$ff20		; $730b
	call objectSetSpeedZ		; $730e
	ld l,e			; $7311
	inc (hl)		; $7312
	ld l,$e6		; $7313
	ld (hl),$05		; $7315
	inc l			; $7317
	ld (hl),$02		; $7318
	ld b,$3c		; $731a
	call _func_733d		; $731c
	call objectSetVisible82		; $731f
	ld a,$01		; $7322
	jp partSetAnimation		; $7324
@subid4:
	ld a,(de)		; $7327
	or a			; $7328
	jp nz,@seasonsFunc_10_72b2		; $7329
	ld h,d			; $732c
	ld l,e			; $732d
	inc (hl)		; $732e
	ld b,$3c		; $732f
	call _func_733d		; $7331
	call objectSetVisible82		; $7334
	ld e,$c3		; $7337
	ld a,(de)		; $7339
	jp partSetAnimation		; $733a
_func_733d:
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
	jr z,@normalStatus	; $7352
	ld e,$ea		; $7354
	ld a,(de)		; $7356
	cp $83			; $7357
	jr z,++			; $7359
	ld a,$01		; $735b
	call objectGetRelatedObject1Var		; $735d
	ld a,(hl)		; $7360
	cp $7f			; $7361
	jr nz,+			; $7363
	ld l,$b6		; $7365
	ld (hl),$01		; $7367
+
	ld a,$13		; $7369
	ld ($cc6a),a		; $736b
	jr _func_73db		; $736e
++
	ld e,$c4		; $7370
	ld a,$02		; $7372
	ld (de),a		; $7374
	ld e,$c9		; $7375
	ld a,(de)		; $7377
	xor $10			; $7378
	ld (de),a		; $737a
	call @func_73ae		; $737b
	call objectGetAngleTowardEnemyTarget		; $737e
	ld ($d02c),a		; $7381
	ld a,$18		; $7384
	ld ($d02d),a		; $7386
	ld a,$52		; $7389
	call playSound		; $738b
@normalStatus:
	call partCommon_checkOutOfBounds		; $738e
	jr z,_func_73db	; $7391
	ld e,$c4		; $7393
	ld a,(de)		; $7395
	rst_jumpTable			; $7396
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01		; $739d
	ld (de),a		; $739f
	call objectSetVisible82		; $73a0
	ld e,$c2		; $73a3
	ld a,(de)		; $73a5
	ld hl,_table_73de		; $73a6
	rst_addAToHl			; $73a9
	ld e,$c9		; $73aa
	ld a,(hl)		; $73ac
	ld (de),a		; $73ad
@func_73ae:
	ld c,a			; $73ae
	ld b,$46		; $73af
	ld a,$02		; $73b1
	jp objectSetComponentSpeedByScaledVelocity		; $73b3
@state1:
	call objectApplyComponentSpeed		; $73b6
	jp partAnimate		; $73b9
@state2:
	ld a,$00		; $73bc
	call objectGetRelatedObject1Var		; $73be
	call checkObjectsCollided		; $73c1
	jr nc,@state1	; $73c4
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
_func_73db:
	jp partDelete		; $73db
_table_73de:
	.db $02 $04 $06 $08
	.db $0a $0c $0e $10
	.db $12 $14 $16 $18
	.db $1a $1c $1e $00


partCode45:
	jr z,@normalStatus	; $73ee
	dec a			; $73f0
	jr nz,@delete	; $73f1
	ld e,$ea		; $73f3
	ld a,(de)		; $73f5
	cp $80			; $73f6
	jr nz,@delete	; $73f8
@normalStatus:
	ld e,$c2		; $73fa
	ld a,(de)		; $73fc
	or a			; $73fd
	ld e,$c4		; $73fe
	ld a,(de)		; $7400
	jr z,@func_742e	; $7401
	or a			; $7403
	jr z,+			; $7404
	call objectCheckSimpleCollision		; $7406
	jp z,objectApplyComponentSpeed		; $7409
@delete:
	jp partDelete		; $740c
+
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
@func_742e:
	or a			; $742e
	jr nz,+			; $742f
	inc a			; $7431
	ld (de),a		; $7432
+
	ld a,$29		; $7433
	call objectGetRelatedObject1Var		; $7435
	ld a,(hl)		; $7438
	or a			; $7439
	jr z,@delete	; $743a
	ld l,$ae		; $743c
	ld a,(hl)		; $743e
	or a			; $743f
	ret nz			; $7440
	call getFreePartSlot		; $7441
	ret nz			; $7444
	ld (hl),PARTID_S_45		; $7445
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
	jr nz,@delete	; $7452
	ld e,$c2		; $7454
	ld a,(de)		; $7456
	or a			; $7457
	jr z,@subid0		; $7458
	ld e,$c4		; $745a
	ld a,(de)		; $745c
	rst_jumpTable			; $745d
	.dw @subid1@state0
	.dw @subid1@state1
	.dw @subid1@state2
@subid0:
	ld a,$29		; $7464
	call objectGetRelatedObject1Var		; $7466
	ld a,(hl)		; $7469
	or a			; $746a
	jr z,@delete		; $746b
	ld l,$84		; $746d
	ld a,(hl)		; $746f
	cp $0a			; $7470
	jr nz,@delete		; $7472
	ld l,$ae		; $7474
	ld a,(hl)		; $7476
	or a			; $7477
	ret nz			; $7478
	ld e,$c4		; $7479
	ld a,(de)		; $747b
	rst_jumpTable			; $747c
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
@@state0:
	ld h,d			; $7487
	ld l,e			; $7488
	inc (hl)		; $7489
	ld l,$c6		; $748a
	ld (hl),$1e		; $748c
@@state1:
	call partCommon_decCounter1IfNonzero		; $748e
	ret nz			; $7491
	ld l,e			; $7492
	inc (hl)		; $7493
@@state2:
	ld b,$03		; $7494
	call _func_7517		; $7496
	ret nz			; $7499
	ld a,b			; $749a
	sub $08			; $749b
	and $1f			; $749d
	ld b,a			; $749f
	call _func_74fd		; $74a0
	call _func_74fd		; $74a3
	call _func_74fd		; $74a6
	ld a,$ba		; $74a9
	call playSound		; $74ab
	ld h,d			; $74ae
	ld l,$c4		; $74af
	inc (hl)		; $74b1
	ld l,$c6		; $74b2
	ld (hl),$1e		; $74b4
@@state3:
@@state4:
	call partCommon_decCounter1IfNonzero		; $74b6
	ret nz			; $74b9
	ld l,e			; $74ba
	inc (hl)		; $74bb
	ld b,$02		; $74bc
	call _func_7517		; $74be
	ret nz			; $74c1
	ld a,b			; $74c2
	sub $06			; $74c3
	and $1f			; $74c5
	ld b,a			; $74c7
	call _func_74fd		; $74c8
	call _func_74fd		; $74cb
	ld a,$ba		; $74ce
	call playSound		; $74d0
@delete:
	jp partDelete		; $74d3

@subid1:
@@state0:
	ld h,d			; $74d6
	ld l,e			; $74d7
	inc (hl)		; $74d8
	ld l,$e4		; $74d9
	set 7,(hl)		; $74db
	ld l,$d0		; $74dd
	ld (hl),$64		; $74df
	ld l,$c6		; $74e1
	ld (hl),$08		; $74e3
	call _func_7524		; $74e5
	call objectSetVisible82		; $74e8
@@state1:
	call partCommon_decCounter1IfNonzero		; $74eb
	jr nz,+			; $74ee
	ld l,e			; $74f0
	inc (hl)		; $74f1
@@state2:
	call objectCheckSimpleCollision		; $74f2
	jr nz,@delete	; $74f5
+
	call objectApplySpeed		; $74f7
	jp partAnimate		; $74fa
_func_74fd:
	call getFreePartSlot		; $74fd
	ret nz			; $7500
	ld (hl),PARTID_S_46		; $7501
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
_func_7517:
	call checkBPartSlotsAvailable		; $7517
	ret nz			; $751a
	call _func_7524		; $751b
	call objectGetAngleTowardEnemyTarget		; $751e
	ld b,a			; $7521
	xor a			; $7522
	ret			; $7523
_func_7524:
	ld a,$0b		; $7524
	call objectGetRelatedObject1Var		; $7526
	ld bc,$0a00		; $7529
	call objectTakePositionWithOffset		; $752c
	xor a			; $752f
	ld (de),a		; $7530
	ret			; $7531


; PARTID_47
partCode47:
	ld e,$c2		; $7532
	ld a,(de)		; $7534
	ld e,$c4		; $7535
	rst_jumpTable			; $7537
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
	ld b,$04		; $7542
	call checkBPartSlotsAvailable		; $7544
	ret nz			; $7547
	ld b,$04		; $7548
	ld e,$d7		; $754a
	ld a,(de)		; $754c
	ld c,a			; $754d
	call @func_7566		; $754e
	ld (hl),$80		; $7551
	ld c,h			; $7553
	dec b			; $7554
-
	call @func_7566		; $7555
	ld (hl),$c0		; $7558
	dec b			; $755a
	jr nz,-			; $755b
	ld a,$19		; $755d
	call objectGetRelatedObject1Var		; $755f
	ld (hl),c		; $7562
	jp partDelete		; $7563

@func_7566:
	call getFreePartSlot		; $7566
	ld (hl),PARTID_47		; $7569
	inc l			; $756b
	ld a,$05		; $756c
	sub b			; $756e
	ld (hl),a		; $756f
	call objectCopyPosition		; $7570
	ld l,$d7		; $7573
	ld (hl),c		; $7575
	dec l			; $7576
	ret			; $7577

@subid1:
	ld b,$02		; $7578
	call @func_777f		; $757a
	ld l,$a9		; $757d
	ld a,(hl)		; $757f
	or a			; $7580
	ld e,$c4		; $7581
	jr z,+			; $7583
	ld a,(de)		; $7585
	rst_jumpTable			; $7586
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	.dw @@state5
	.dw @@state6
	.dw @@state7
	.dw @@state8
+
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

@@state0:
	inc e			; $75a9
	ld a,(de)		; $75aa
	rst_jumpTable			; $75ab
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
	.dw @@@substate4

@@@substate0:
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

@@@substate1:
	ld c,$0e		; $75d8
	call objectUpdateSpeedZ_paramC		; $75da
	jr z,+			; $75dd
	call objectApplySpeed		; $75df
	ld e,$cb		; $75e2
	ld a,(de)		; $75e4
	sub $18			; $75e5
	ld e,$f3		; $75e7
	ld (de),a		; $75e9
	ret			; $75ea
+
	ld l,$c5		; $75eb
	inc (hl)		; $75ed
	inc l			; $75ee
	ld a,$3c		; $75ef
	ld (hl),a		; $75f1
	call setScreenShakeCounter		; $75f2
	ld a,$6f		; $75f5
	call playSound		; $75f7
	jp @func_776f		; $75fa

@@@substate2:
	call partCommon_decCounter1IfNonzero		; $75fd
	ret nz			; $7600
	ld l,e			; $7601
	inc (hl)		; $7602
	ld l,$d0		; $7603
	ld a,$80		; $7605
	ldi (hl),a		; $7607
	ld (hl),$ff		; $7608
	ret			; $760a

@@@substate3:
	call objectApplyComponentSpeed		; $760b
	ld e,$cb		; $760e
	ld a,(de)		; $7610
	cp $18			; $7611
	ret nc			; $7613
	ld e,$c5		; $7614
	ld a,$04		; $7616
	ld (de),a		; $7618
	jp objectSetInvisible		; $7619

@@@substate4:
	ret			; $761c

@@state1:
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

@@state2:
	ld h,d			; $7632
	ld l,$c9		; $7633
	ld a,(hl)		; $7635
	cp $1e			; $7636
	jr nz,@@state3	; $7638
	ld l,e			; $763a
	inc (hl)		; $763b
	call objectSetVisible81		; $763c

@@state3:
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
	ld hl,@table_775f		; $7652
	rst_addAToHl			; $7655
	ld e,$f3		; $7656
	ld a,(hl)		; $7658
	ld (de),a		; $7659
	ld bc,$e605		; $765a
-
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

@@state4:
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
	jr -			; $768a

@@state5:
	call partCommon_decCounter1IfNonzero		; $768c
	jr nz,+			; $768f
	ld (hl),$02		; $7691
	ld l,$c9		; $7693
	inc (hl)		; $7695
	ld a,(hl)		; $7696
	cp $15			; $7697
	jr z,++			; $7699
	ld c,a			; $769b
	ld b,$5a		; $769c
	ld a,$03		; $769e
	call objectSetComponentSpeedByScaledVelocity		; $76a0
+
	jp objectApplyComponentSpeed		; $76a3
++
	ld l,e			; $76a6
	inc (hl)		; $76a7
	ld l,$c6		; $76a8
	ld a,$3c		; $76aa
	ld (hl),a		; $76ac
	ld l,$e8		; $76ad
	ld (hl),$fc		; $76af
	call setScreenShakeCounter		; $76b1
	call @func_776f		; $76b4
	ld a,$6f		; $76b7
	jp playSound		; $76b9

@@state6:
	call partCommon_decCounter1IfNonzero		; $76bc
	ret nz			; $76bf
	ld l,e			; $76c0
	inc (hl)		; $76c1
	ld l,$d0		; $76c2
	ld (hl),$1e		; $76c4
	ret			; $76c6

@@state7:
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
	jr nz,+			; $76d7
	ldh a,(<hFF8F)	; $76d9
	cp b			; $76db
	jr nz,+			; $76dc
	ld l,e			; $76de
	inc (hl)		; $76df
	ld l,$e4		; $76e0
	res 7,(hl)		; $76e2
	jp objectSetInvisible		; $76e4
+
	call objectGetRelativeAngleWithTempVars		; $76e7
	ld e,$c9		; $76ea
	ld (de),a		; $76ec
	jp objectApplySpeed		; $76ed

@@state8:
	ld a,$04		; $76f0
	call objectGetRelatedObject1Var		; $76f2
	ld a,(hl)		; $76f5
	cp $0a			; $76f6
	ret nz			; $76f8
	ld e,$c4		; $76f9
	ld a,$01		; $76fb
	ld (de),a		; $76fd
	ret			; $76fe

@subid2:
	ld a,(de)		; $76ff
	or a			; $7700
	jr z,@func_7726			; $7701
	ld b,$47		; $7703
	call @func_777f		; $7705
	call @func_778b		; $7708
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

@func_7719:
	ld a,$1a		; $7719
	call objectGetRelatedObject1Var		; $771b
	bit 7,(hl)		; $771e
	jp nz,objectSetVisible82		; $7720
	jp objectSetInvisible		; $7723

@func_7726:
	inc a			; $7726
	ld (de),a		; $7727
	call partSetAnimation		; $7728
	jr @func_7719			; $772b

@subid3:
	ld a,(de)		; $772d
	or a			; $772e
	jr z,@func_7726	; $772f
	ld b,$47		; $7731
	call @func_777f		; $7733
	call @func_778b		; $7736
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
	jr @func_7719		; $7745

@subid4:
	ld a,(de)		; $7747
	or a			; $7748
	jr z,@func_7726	; $7749
	ld b,$47		; $774b
	call @func_777f		; $774d
	call @func_778b		; $7750
	ld a,e			; $7753
	add b			; $7754
	ld e,$cb		; $7755
	ld (de),a		; $7757
	ld a,l			; $7758
	add c			; $7759
	ld e,$cd		; $775a
	ld (de),a		; $775c
	jr @func_7719		; $775d

@table_775f:
	.db $10 $11 $12 $14 $16 $1a $1e $22
	.db $28 $22 $1e $1a $16 $14 $12 $11

@func_776f:
	call getFreePartSlot		; $776f
	ret nz		; $7772
	ld (hl),PARTID_48		; $7773
	inc l			; $7775
	ld (hl),$02		; $7776
	ld l,$d6		; $7778
	ld a,$c0		; $777a
	ldi (hl),a		; $777c
	ld (hl),d		; $777d
	ret			; $777e

@func_777f:
	ld a,$01		; $777f
	call objectGetRelatedObject1Var		; $7781
	ld a,(hl)		; $7784
	cp b			; $7785
	ret z			; $7786
	pop hl			; $7787
	jp partDelete		; $7788

@func_778b:
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


; PARTID_48
partCode48:
	ld e,$c2		; $77a5
	ld a,(de)		; $77a7
	ld e,$c4		; $77a8
	rst_jumpTable			; $77aa
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5

@subid0:
	ld a,(de)		; $77b7
	or a			; $77b8
	jr z,+			; $77b9
	call partCommon_decCounter1IfNonzero		; $77bb
	jp z,partDelete		; $77be
	ld a,(hl)		; $77c1
	and $0f			; $77c2
	ret nz			; $77c4
	call getFreePartSlot		; $77c5
	ret nz			; $77c8
	ld (hl),PARTID_48		; $77c9
	inc l			; $77cb
	inc (hl)		; $77cc
	ret			; $77cd
+
	ld h,d			; $77ce
	ld l,e			; $77cf
	inc (hl)		; $77d0
	ld l,$c6		; $77d1
	ld (hl),$96		; $77d3
	ret			; $77d5

@subid1:
	ld a,(de)		; $77d6
	rst_jumpTable			; $77d7
	.dw @@state0
	.dw @@state1
	.dw @@state2

@@state0:
	ld h,d		; $77de
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

@@state1:
	ld c,$20		; $780e
	call objectUpdateSpeedZ_paramC		; $7810
	jr nz,+			; $7813
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

@@state2:
	ld e,$e1		; $7831
	ld a,(de)		; $7833
	bit 7,a			; $7834
	jp nz,partDelete		; $7836
	ld hl,@table_7847		; $7839
	rst_addAToHl			; $783c
	ld e,$e6		; $783d
	ldi a,(hl)		; $783f
	ld (de),a		; $7840
	inc e			; $7841
	ld a,(hl)		; $7842
	ld (de),a		; $7843
+
	jp partAnimate		; $7844

@table_7847:
	.db $04 $09 $06 $0b $09
	.db $0c $0a $0d $0b $0e

@subid2:
	ld b,$06		; $7851
	call checkBPartSlotsAvailable		; $7853
	ret nz			; $7856
	ld a,$00		; $7857
	call objectGetRelatedObject1Var		; $7859
	call objectTakePosition		; $785c
	ld b,$06		; $785f
-
	call getFreePartSlot		; $7861
	ld (hl),PARTID_48		; $7864
	inc l			; $7866
	ld (hl),$03		; $7867
	ld l,$c9		; $7869
	ld (hl),b		; $786b
	call objectCopyPosition		; $786c
	dec b			; $786f
	jr nz,-			; $7870
	jp partDelete		; $7872

@subid3:
	ld a,(de)		; $7875
	or a			; $7876
	jr z,+			; $7877
	ld c,$18		; $7879
	call objectUpdateSpeedZ_paramC		; $787b
	jp z,partDelete		; $787e
	jp objectApplySpeed		; $7881
+
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
	ld bc,@table_78bb		; $78ab
	call addAToBc		; $78ae
	ld a,(bc)		; $78b1
	ld (hl),a		; $78b2
	ld a,$02		; $78b3
	call partSetAnimation		; $78b5
	jp objectSetVisible82		; $78b8

@table_78bb:
	.db $04 $08 $0d
	.db $16 $1a $1e

@subid4:
	ld a,(de)		; $78c1
	or a			; $78c2
	jr z,+			; $78c3
	call partCommon_decCounter1IfNonzero		; $78c5
	jp z,partDelete		; $78c8
	ld a,(hl)		; $78cb
	and $0f			; $78cc
	ret nz			; $78ce
	call getFreePartSlot		; $78cf
	ret nz			; $78d2
	ld (hl),PARTID_48		; $78d3
	inc l			; $78d5
	ld (hl),$05		; $78d6
	ret			; $78d8
+
	ld h,d			; $78d9
	ld l,e			; $78da
	inc (hl)		; $78db
	ld l,$c6		; $78dc
	ld (hl),$61		; $78de
	ret			; $78e0

@subid5:
	ld a,(de)		; $78e1
	rst_jumpTable			; $78e2
	.dw @@state0
	.dw @@state1
	.dw @@state2

@@state0:
	ld h,d			; $78e9
	ld l,e			; $78ea
	inc (hl)		; $78eb
	ld l,$cb		; $78ec
	ld (hl),$28		; $78ee
	call getRandomNumber_noPreserveVars		; $78f0
	and $7f			; $78f3
	cp $40			; $78f5
	jr c,+			; $78f7
	add $20			; $78f9
+
	ld e,$cd		; $78fb
	ld (de),a		; $78fd
	jp objectSetVisible82		; $78fe

@@state1:
	ld h,d			; $7901
	ld l,$d4		; $7902
	ld e,$ca		; $7904
	call add16BitRefs		; $7906
	cp $a0			; $7909
	jr nc,+			; $790b
	dec l			; $790d
	ld a,(hl)		; $790e
	add $10			; $790f
	ldi (hl),a		; $7911
	ld a,(hl)		; $7912
	adc $00			; $7913
	ld (hl),a		; $7915
	ret			; $7916
+
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

@@state2:
	ld e,$e1		; $792d
	ld a,(de)		; $792f
	bit 7,a			; $7930
	jp nz,partDelete		; $7932
	jp partAnimate		; $7935


; PARTID_49
partCode49:
	ld e,Part.state		; $7938
	ld a,(de)		; $793a
	rst_jumpTable			; $793b
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d			; $7942
	ld l,Part.state		; $7943
	inc (hl)		; $7945
	ld l,Part.speed		; $7946
	ld (hl),SPEED_2c0		; $7948
	ld l,Part.counter1		; $794a
	ld (hl),$3c		; $794c
	jp objectSetVisible81		; $794e

@state1:
	call partCommon_decCounter1IfNonzero		; $7951
	jr nz,@animate	; $7954
	ld l,e			; $7956
	inc (hl)		; $7957
	ld a,SND_WIND		; $7958
	call playSound		; $795a
	call objectGetAngleTowardEnemyTarget		; $795d
	ld e,Part.angle		; $7960
	ld (de),a		; $7962

@state2:
	call partCode.partCommon_checkOutOfBounds		; $7963
	jp z,partDelete		; $7966
	call objectApplySpeed		; $7969
@animate:
	jp partAnimate		; $796c


partCode4a:
	jp nz,partDelete		; $796f
	ld e,Part.state		; $7972
	ld a,(de)		; $7974
	rst_jumpTable			; $7975
	.dw @state0
	.dw @state1
	.dw @state2
	
@state0:
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
	
@state1:
	call _seasonsFunc_10_79ab		; $798c
	ld e,$cb		; $798f
	ld a,(de)		; $7991
	cp $88			; $7992
	jr c,@animate	; $7994
	ld e,$c4		; $7996
	ld a,$02		; $7998
	ld (de),a		; $799a
@animate:
	jp partAnimate		; $799b
	
@state2:
	call objectApplySpeed		; $799e
	ld e,$cb		; $79a1
	ld a,(de)		; $79a3
	cp $b8			; $79a4
	jr c,@animate	; $79a6
	jp partDelete		; $79a8
	
_seasonsFunc_10_79ab:
	ld e,$f1		; $79ab
	ld a,(de)		; $79ad
	ld c,a			; $79ae
	ld b,$9a		; $79af
	call objectGetRelativeAngle		; $79b1
	ld e,$c9		; $79b4
	ld (de),a		; $79b6
	jp objectApplySpeed		; $79b7


; PARTID_S_4f
partCode4f:
	jr z,@normalStatus	; $79ba
	ld e,Part.state		; $79bc
	ld a,(de)		; $79be
	cp $06			; $79bf
	jr nc,@normalStatus	; $79c1
	ld e,Part.var2a		; $79c3
	ld a,(de)		; $79c5
	res 7,a			; $79c6
	cp $04			; $79c8
	jr c,@normalStatus	; $79ca
	cp $0c			; $79cc
	jp z,_seasonsFunc_10_7bc2		; $79ce
	cp $20			; $79d1
	jr nz,+			; $79d3
	ld a,Object.collisionType		; $79d5
	call objectGetRelatedObject2Var		; $79d7
	res 7,(hl)		; $79da
	ld e,Part.var33		; $79dc
	ld a,$01		; $79de
	ld (de),a		; $79e0
+
	ld h,d			; $79e1
	ld l,Part.health		; $79e2
	ld (hl),$40		; $79e4
	ld l,Part.var32		; $79e6
	ld (hl),$3c		; $79e8

@normalStatus:
	ld e,Part.subid		; $79ea
	ld a,(de)		; $79ec
	ld e,Part.state		; $79ed
	rst_jumpTable			; $79ef
	.dw @subid0
	.dw @subid1
	
@subid0:
	ld h,d			; $79f4
	ld l,Part.var32		; $79f5
	ld a,(hl)		; $79f7
	or a			; $79f8
	jr z,+			; $79f9
	dec (hl)		; $79fb
	jr nz,+			; $79fc
	ld l,Part.collisionType		; $79fe
	set 7,(hl)		; $7a00
+
	ld a,(de)		; $7a02
	rst_jumpTable			; $7a03
	.dw @state0
	.dw @state1
	.dw @stateStub
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7

@state0:
	call getFreePartSlot		; $7a14
	ret nz			; $7a17
	ld (hl),PARTID_SHADOW		; $7a18
	inc l			; $7a1a
	ld (hl),$00		; $7a1b
	inc l			; $7a1d
	ld (hl),$08		; $7a1e
	ld l,Part.relatedObj1		; $7a20
	ld a,$c0		; $7a22
	ldi (hl),a		; $7a24
	ld (hl),d		; $7a25
	ld a,$0f		; $7a26
	ld (wLinkForceState),a		; $7a28
	ld h,d			; $7a2b
	ld l,Part.state		; $7a2c
	inc (hl)		; $7a2e
	ld l,Part.yh		; $7a2f
	ld (hl),$50		; $7a31
	ld l,Part.xh		; $7a33
	ld (hl),$78		; $7a35
	ld l,Part.zh		; $7a37
	ld (hl),$fc		; $7a39
	jp objectSetVisible82		; $7a3b

@state1:
	inc e			; $7a3e
	ld a,(de)		; $7a3f
	rst_jumpTable			; $7a40
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,(w1Link.yh)		; $7a47
	cp $78			; $7a4a
	jp nc,partAnimate		; $7a4c
	ld a,$01		; $7a4f
	ld (de),a		; $7a51
	ld a,SND_TELEPORT		; $7a52
	call playSound		; $7a54

@@substate1:
	ld b,$04		; $7a57
	call checkBPartSlotsAvailable		; $7a59
	ret nz			; $7a5c
	ld bc,$0404		; $7a5d
-
	call getFreePartSlot		; $7a60
	ld (hl),PARTID_S_4f		; $7a63
	inc l			; $7a65
	inc (hl)		; $7a66
	ld l,Part.angle		; $7a67
	ld (hl),c		; $7a69
	call objectCopyPosition		; $7a6a
	ld a,c			; $7a6d
	add $08			; $7a6e
	ld c,a			; $7a70
	dec b			; $7a71
	jr nz,-			; $7a72
	ld h,d			; $7a74
	ld l,Part.state2		; $7a75
	inc (hl)		; $7a77
	; counter1
	inc l			; $7a78
	ld (hl),$5a		; $7a79
	ld l,Part.zh		; $7a7b
	ld (hl),$00		; $7a7d
	jp objectSetInvisible		; $7a7f

@@substate2:
	call partCommon_decCounter1IfNonzero		; $7a82
	ret nz			; $7a85
	call getFreeEnemySlot		; $7a86
	ret nz			; $7a89
	ld (hl),ENEMYID_GENERAL_ONOX		; $7a8a
	ld e,Part.relatedObj2		; $7a8c
	ld a,$80		; $7a8e
	ld (de),a		; $7a90
	inc e			; $7a91
	ld a,h			; $7a92
	ld (de),a		; $7a93

	ld l,Enemy.relatedObj1		; $7a94
	ld a,$c0		; $7a96
	ldi (hl),a		; $7a98
	ld (hl),d		; $7a99

	ld h,d			; $7a9a
	ld l,Part.state		; $7a9b
	inc (hl)		; $7a9d
	; state2
	inc l			; $7a9e
	ld (hl),$00		; $7a9f
	ret			; $7aa1

@stateStub:
	ret			; $7aa2

@state3:
	ld h,d			; $7aa3
	ld l,Part.zh		; $7aa4
	inc (hl)		; $7aa6
	ld a,(hl)		; $7aa7
	cp $fc			; $7aa8
	jr c,@animate	; $7aaa
	ld l,e			; $7aac
	inc (hl)		; $7aad
	ld l,Part.collisionType		; $7aae
	set 7,(hl)		; $7ab0
	ld l,Part.speed		; $7ab2
	ld (hl),SPEED_80		; $7ab4
@animate:
	jp partAnimate		; $7ab6

@state4:
	ld a,$01		; $7ab9
	call objectGetRelatedObject2Var		; $7abb
	ld a,(hl)		; $7abe
	cp $02			; $7abf
	jr nz,+++	; $7ac1
	call _seasonsFunc_10_7bd6		; $7ac3
	ld l,$8b		; $7ac6
	ldi a,(hl)		; $7ac8
	srl a			; $7ac9
	ld b,a			; $7acb
	ld a,(w1Link.yh)		; $7acc
	srl a			; $7acf
	add b			; $7ad1
	ld b,a			; $7ad2
	inc l			; $7ad3
	ld a,(hl)		; $7ad4
	srl a			; $7ad5
	ld c,a			; $7ad7
	ld a,(w1Link.xh)		; $7ad8
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
	jr nc,+			; $7aee
	ldh a,(<hFF8E)	; $7af0
	sub c			; $7af2
	add $04			; $7af3
	cp $09			; $7af5
	jr c,@animate	; $7af7
	ld a,(wFrameCounter)		; $7af9
	and $1f			; $7afc
	jr nz,++	; $7afe
+
	call objectGetRelativeAngleWithTempVars		; $7b00
	ld e,$c9		; $7b03
	ld (de),a		; $7b05
++
	call objectApplySpeed		; $7b06
	jr @animate		; $7b09
+++
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

@state5:
	call _seasonsFunc_10_7bd6		; $7b1d
	call partCommon_decCounter1IfNonzero		; $7b20
	jr z,+			; $7b23
	call objectCheckTileCollision_allowHoles		; $7b25
	call nc,objectApplySpeed		; $7b28
	jr @animate		; $7b2b
+
	ld l,$c4		; $7b2d
	dec (hl)		; $7b2f
	ld l,$d0		; $7b30
	ld (hl),$14		; $7b32
	jr @animate		; $7b34

@state6:
	inc e			; $7b36
	ld a,(de)		; $7b37
	rst_jumpTable			; $7b38
	.dw @@substate0
	.dw @@substate1
	.dw @state1@substate1
	.dw @@substate3

@@substate0:
	ld h,d			; $7b41
	ld l,e			; $7b42
	inc (hl)		; $7b43
	ld l,$e6		; $7b44
	ld a,$10		; $7b46
	ldi (hl),a		; $7b48
	ld (hl),a		; $7b49
	ret			; $7b4a

@@substate1:
	call objectCheckCollidedWithLink		; $7b4b
	jr nc,+			; $7b4e
	ld e,$c5		; $7b50
	ld a,$02		; $7b52
	ld (de),a		; $7b54
	ld a,$8d		; $7b55
	call playSound		; $7b57
+
	jp partAnimate		; $7b5a

@@substate3:
	ld h,d			; $7b5d
	ld l,$c4		; $7b5e
	inc (hl)		; $7b60
	ld l,$c6		; $7b61
	ld a,$3c		; $7b63
	ld (hl),a		; $7b65
	call setScreenShakeCounter		; $7b66

@state7:
	call partCommon_decCounter1IfNonzero		; $7b69
	ret nz			; $7b6c
	ld a,$0f		; $7b6d
	ld (hl),a		; $7b6f
	call setScreenShakeCounter		; $7b70
--
	call getRandomNumber_noPreserveVars		; $7b73
	and $0f			; $7b76
	cp $0d			; $7b78
	jr nc,--		; $7b7a
	inc a			; $7b7c
	ld c,a			; $7b7d
	push bc			; $7b7e
-
	call getRandomNumber_noPreserveVars		; $7b7f
	and $0f			; $7b82
	cp $09			; $7b84
	jr nc,-			; $7b86
	pop bc			; $7b88
	inc a			; $7b89
	swap a			; $7b8a
	or c			; $7b8c
	ld c,a			; $7b8d
	ld b,$ce		; $7b8e
	ld a,(bc)		; $7b90
	or a			; $7b91
	jr nz,--	; $7b92
	ld a,$48		; $7b94
	call breakCrackedFloor		; $7b96
	ld e,$c7		; $7b99
	ld a,(de)		; $7b9b
	inc a			; $7b9c
	cp $75			; $7b9d
	jp z,partDelete		; $7b9f
	ld (de),a		; $7ba2
	ret			; $7ba3
	
@subid1:
	ld a,(de)		; $7ba4
	or a			; $7ba5
	jr nz,+			; $7ba6
	ld h,d			; $7ba8
	ld l,e			; $7ba9
	inc (hl)		; $7baa
	ld l,Part.counter1		; $7bab
	ld (hl),$5a		; $7bad
	ld l,Part.speed		; $7baf
	ld (hl),SPEED_60		; $7bb1
+
	call partCommon_decCounter1IfNonzero		; $7bb3
	jp z,partDelete		; $7bb6
	ld l,Part.visible		; $7bb9
	ld a,(hl)		; $7bbb
	xor $80			; $7bbc
	ld (hl),a		; $7bbe
	jp objectApplySpeed		; $7bbf

_seasonsFunc_10_7bc2:
	ld h,d			; $7bc2
	ld l,Part.counter1		; $7bc3
	ld (hl),$78		; $7bc5
	ld l,Part.knockbackAngle		; $7bc7
	ld a,(hl)		; $7bc9
	ld l,Part.angle		; $7bca
	ld (hl),a		; $7bcc
	ld l,Part.state		; $7bcd
	ld (hl),$05		; $7bcf
	ld l,Part.speed		; $7bd1
	ld (hl),SPEED_200		; $7bd3
	ret			; $7bd5

_seasonsFunc_10_7bd6:
	ld e,Part.var33		; $7bd6
	ld a,(de)		; $7bd8
	or a			; $7bd9
	ret z			; $7bda
	ld a,(wIsLinkBeingShocked)		; $7bdb
	or a			; $7bde
	ret nz			; $7bdf
	ld (de),a		; $7be0
	ld a,Object.health		; $7be1
	call objectGetRelatedObject2Var		; $7be3
	ld a,(hl)		; $7be6
	or a			; $7be7
	ret z			; $7be8
	ld l,Enemy.collisionType		; $7be9
	set 7,(hl)		; $7beb
	ret			; $7bed
