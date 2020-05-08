interactionCoded8:
	ld e,$44		; $65d2
	ld a,(de)		; $65d4
	rst_jumpTable			; $65d5
	jp c,$f865		; $65d6
	ld h,l			; $65d9
	call checkIsLinkedGame		; $65da
	jp z,interactionDelete		; $65dd
	ld a,$18		; $65e0
	call checkGlobalFlag		; $65e2
	jp z,interactionDelete		; $65e5
	call interactionInitGraphics		; $65e8
	call interactionIncState		; $65eb
	ld l,$7e		; $65ee
	ld (hl),$01		; $65f0
	ld hl,$5779		; $65f2
	call interactionSetScript		; $65f5
	call interactionRunScript		; $65f8
	jp interactionAnimateAsNpc		; $65fb

interactionCodedb:
	ld e,$44		; $65fe
	ld a,(de)		; $6600
	rst_jumpTable			; $6601
	ld b,$66		; $6602
	ld e,h			; $6604
	ld h,(hl)		; $6605
	ld a,$01		; $6606
	ld (de),a		; $6608
	call checkIsLinkedGame		; $6609
	jp z,interactionDelete		; $660c
	call $662f		; $660f
	jp z,interactionDelete		; $6612
	ld e,$42		; $6615
	ld a,(de)		; $6617
	ld hl,$662c		; $6618
	rst_addAToHl			; $661b
	ld a,(hl)		; $661c
	ld e,$7e		; $661d
	ld (de),a		; $661f
	ld hl,$5779		; $6620
	call interactionSetScript		; $6623
	call interactionInitGraphics		; $6626
	jp objectSetVisiblec2		; $6629
	dec b			; $662c
	ld b,$09		; $662d
	ld e,$42		; $662f
	ld a,(de)		; $6631
	rst_jumpTable			; $6632
	add hl,sp		; $6633
	ld h,(hl)		; $6634
	ccf			; $6635
	ld h,(hl)		; $6636
	ld c,c			; $6637
	ld h,(hl)		; $6638
	ld a,$2d		; $6639
	call checkGlobalFlag		; $663b
	ret			; $663e
	ld a,$00		; $663f
	ld b,$81		; $6641
	call getRoomFlags		; $6643
	bit 7,a			; $6646
	ret			; $6648
	ld a,$40		; $6649
	call checkTreasureObtained		; $664b
	jr nc,_label_15_268	; $664e
	call getHighestSetBit		; $6650
	cp $01			; $6653
	jr c,_label_15_268	; $6655
	or $01			; $6657
	ret			; $6659
_label_15_268:
	xor a			; $665a
	ret			; $665b
	call interactionRunScript		; $665c
	ld e,$42		; $665f
	ld a,(de)		; $6661
	or a			; $6662
	jp z,npcFaceLinkAndAnimate		; $6663
	jp interactionAnimateAsNpc		; $6666

interactionCodedc:
	ld e,$42		; $6669
	ld a,(de)		; $666b
	rst_jumpTable			; $666c
.DB $dd				; $666d
	ld h,(hl)		; $666e
	ld e,l			; $666f
	ld h,a			; $6670
	and (hl)		; $6671
	ld h,a			; $6672
.DB $db				; $6673
	ld h,a			; $6674
	pop af			; $6675
	ld h,a			; $6676
	ld d,a			; $6677
	ld l,b			; $6678
	or e			; $6679
	ld l,b			; $667a
	call c,$8668		; $667b
	ld l,c			; $667e
	ld a,(bc)		; $667f
	ld l,d			; $6680
	jr z,_label_15_270	; $6681
	jr nc,$6a		; $6683
	scf			; $6685
	ld l,d			; $6686
	ld l,c			; $6687
	ld l,d			; $6688
	ld a,d			; $6689
	ld l,d			; $668a
	adc l			; $668b
	ld h,(hl)		; $668c
	call interactionDeleteAndRetIfEnabled02		; $668d
	call getThisRoomFlags		; $6690
	and $20			; $6693
	jp nz,interactionDelete		; $6695
	ld e,$4d		; $6698
	ld a,(de)		; $669a
	ld b,a			; $669b
	ld a,($ccba)		; $669c
	cp b			; $669f
	jr nz,_label_15_269	; $66a0
	ld e,$4b		; $66a2
	ld a,(de)		; $66a4
	ld c,a			; $66a5
	ld b,$cf		; $66a6
	ld a,(bc)		; $66a8
	cp $f1			; $66a9
	ret z			; $66ab
	ld a,$f1		; $66ac
	call setTile		; $66ae
	call $66d2		; $66b1
	ld a,$4d		; $66b4
	jp playSound		; $66b6
_label_15_269:
	ld e,$4b		; $66b9
	ld a,(de)		; $66bb
	ld c,a			; $66bc
	ld b,$cf		; $66bd
	ld a,(bc)		; $66bf
	cp $f1			; $66c0
	ret nz			; $66c2
	ld a,$03		; $66c3
	ld ($ff00+$70),a	; $66c5
	ld b,$df		; $66c7
	ld a,(bc)		; $66c9
	ld l,a			; $66ca
	xor a			; $66cb
	ld ($ff00+$70),a	; $66cc
	ld a,l			; $66ce
	call setTile		; $66cf
	call getFreeInteractionSlot		; $66d2
	ret nz			; $66d5
	ld (hl),$05		; $66d6
	ld l,$4b		; $66d8
	jp setShortPosition_paramC		; $66da
	ld e,$44		; $66dd
	ld a,(de)		; $66df
	rst_jumpTable			; $66e0
	.dw interactionIncState
	.dw $66ed
	.dw $66fa
	.dw $6716
	.dw $671f
	.dw $6739
_label_15_270:
	ld a,($ccba)		; $66ed
	or a			; $66f0
	ret z			; $66f1
	ld a,$01		; $66f2
	ld e,$46		; $66f4
	ld (de),a		; $66f6
	jp interactionIncState		; $66f7
	call interactionDecCounter1		; $66fa
	ret nz			; $66fd
	ld l,$45		; $66fe
	ld a,(hl)		; $6700
	cp $03			; $6701
	jr z,_label_15_271	; $6703
	inc (hl)		; $6705
	ld hl,$675a		; $6706
	rst_addAToHl			; $6709
	ld a,(hl)		; $670a
	ld b,$6d		; $670b
	jr _label_15_272		; $670d
_label_15_271:
	call interactionIncState		; $670f
	ld l,$46		; $6712
	ld (hl),$43		; $6714
	call interactionDecCounter1		; $6716
	ret nz			; $6719
	ld (hl),$01		; $671a
	jp interactionIncState		; $671c
	call interactionDecCounter1		; $671f
	ret nz			; $6722
	ld l,$45		; $6723
	ld a,(hl)		; $6725
	or a			; $6726
	jp z,interactionIncState		; $6727
	dec (hl)		; $672a
	ld a,(hl)		; $672b
	ld hl,$675a		; $672c
	rst_addAToHl			; $672f
	ld a,(hl)		; $6730
	ld b,$fd		; $6731
	call $6744		; $6733
	ld (hl),$1e		; $6736
	ret			; $6738
	ld a,($ccba)		; $6739
	or a			; $673c
	ret nz			; $673d
	ld a,$01		; $673e
	ld e,$44		; $6740
	ld (de),a		; $6742
	ret			; $6743
_label_15_272:
	ld c,a			; $6744
	ld a,b			; $6745
	call setTile		; $6746
	call getFreeInteractionSlot		; $6749
	ret nz			; $674c
	ld (hl),$05		; $674d
	ld l,$4b		; $674f
	call setShortPosition_paramC		; $6751
	ld h,d			; $6754
	ld l,$46		; $6755
	ld (hl),$0f		; $6757
	ret			; $6759
	ld h,l			; $675a
	ld h,h			; $675b
	ld h,e			; $675c
	ld e,$44		; $675d
	ld a,(de)		; $675f
	rst_jumpTable			; $6760
	ld h,a			; $6761
	ld h,a			; $6762
	ld (hl),h		; $6763
	ld h,a			; $6764
	add e			; $6765
	ld h,a			; $6766
	ld a,$01		; $6767
	ld (de),a		; $6769
	call checkIsLinkedGame		; $676a
	jp z,interactionDelete		; $676d
	ld ($ccaa),a		; $6770
	ret			; $6773
	call returnIfScrollMode01Unset		; $6774
	ld a,($ccb3)		; $6777
	ld b,a			; $677a
	ld a,($cca8)		; $677b
	cp b			; $677e
	ret z			; $677f
	jp interactionIncState		; $6780
	call objectGetTileAtPosition		; $6783
	ld b,a			; $6786
	ld a,($ccb4)		; $6787
	cp b			; $678a
	ret nz			; $678b
	call checkLinkID0AndControlNormal		; $678c
	ret nc			; $678f
	ld hl,$cc63		; $6790
	ld (hl),$85		; $6793
	inc l			; $6795
	ld (hl),$30		; $6796
	inc l			; $6798
	ld (hl),$93		; $6799
	inc l			; $679b
	ld (hl),$ff		; $679c
	ld a,$01		; $679e
	ld ($cc67),a		; $67a0
	jp interactionDelete		; $67a3
	ld e,$44		; $67a6
	ld a,(de)		; $67a8
	rst_jumpTable			; $67a9
	ld h,a			; $67aa
	ld h,a			; $67ab
	xor (hl)		; $67ac
	ld h,a			; $67ad
	ld a,$01		; $67ae
	ld ($ccaa),a		; $67b0
	call objectGetTileAtPosition		; $67b3
	ld b,a			; $67b6
	ld a,($ccb4)		; $67b7
	cp b			; $67ba
	ret nz			; $67bb
	ld a,($cc77)		; $67bc
	or a			; $67bf
	ret nz			; $67c0
	call seasonsFunc_3e8f		; $67c1
	ld a,$05		; $67c4
	ld ($cc63),a		; $67c6
	ld a,$09		; $67c9
	ld ($cc65),a		; $67cb
	ld a,$00		; $67ce
	ld ($cd00),a		; $67d0
	ld a,$0a		; $67d3
	ld ($cc6a),a		; $67d5
	jp interactionDelete		; $67d8
	ld h,d			; $67db
	ld l,$4b		; $67dc
	ld a,($ccba)		; $67de
	and (hl)		; $67e1
	cp (hl)			; $67e2
	ld hl,$ccba		; $67e3
	jr nz,_label_15_273	; $67e6
	set 7,(hl)		; $67e8
	ret			; $67ea
_label_15_273:
	ld hl,$ccba		; $67eb
	res 7,(hl)		; $67ee
	ret			; $67f0
	ld e,$44		; $67f1
	ld a,(de)		; $67f3
	rst_jumpTable			; $67f4
.DB $fd				; $67f5
	ld h,a			; $67f6
	dec h			; $67f7
	ld l,b			; $67f8
	dec (hl)		; $67f9
	ld l,b			; $67fa
	ld b,h			; $67fb
	ld l,b			; $67fc
	ld e,$4d		; $67fd
	ld a,(de)		; $67ff
	ld e,$70		; $6800
	ld (de),a		; $6802
	ld b,a			; $6803
	call getThisRoomFlags		; $6804
	and $20			; $6807
	jr z,_label_15_274	; $6809
	call $681b		; $680b
	jp interactionDelete		; $680e
_label_15_274:
	ld e,$4b		; $6811
	ld a,(de)		; $6813
	ld c,a			; $6814
	call objectSetShortPosition		; $6815
	jp interactionIncState		; $6818
	ld e,$70		; $681b
	ld a,(de)		; $681d
	ld hl,$c647		; $681e
	cp (hl)			; $6821
	ret c			; $6822
	ld (hl),a		; $6823
	ret			; $6824
	call getThisRoomFlags		; $6825
	and $20			; $6828
	ret z			; $682a
	call $681b		; $682b
	call interactionIncState		; $682e
	ld l,$46		; $6831
	ld (hl),$28		; $6833
	call retIfTextIsActive		; $6835
	call interactionDecCounter1		; $6838
	ret nz			; $683b
	ld (hl),$1e		; $683c
	call objectCreatePuff		; $683e
	jp interactionIncState		; $6841
	call interactionDecCounter1		; $6844
	ret nz			; $6847
	ld a,$4d		; $6848
	call playSound		; $684a
	ld bc,$7e02		; $684d
	call objectCreateInteraction		; $6850
	ret nz			; $6853
	jp interactionDelete		; $6854
	ld e,$44		; $6857
	ld a,(de)		; $6859
	rst_jumpTable			; $685a
	ld h,l			; $685b
	ld l,b			; $685c
	ld l,b			; $685d
	ld l,b			; $685e
	ld a,e			; $685f
	ld l,b			; $6860
	sub b			; $6861
	ld l,b			; $6862
	sbc c			; $6863
	ld l,b			; $6864
	ld a,$01		; $6865
	ld (de),a		; $6867
	ld a,($ccba)		; $6868
	cp $1f			; $686b
	ret nz			; $686d
	ld h,d			; $686e
	ld a,$0f		; $686f
	ld l,$46		; $6871
	ld (hl),$0f		; $6873
	inc l			; $6875
	ld (hl),$73		; $6876
	jp interactionIncState		; $6878
	call interactionDecCounter1		; $687b
	ret nz			; $687e
	inc l			; $687f
	ld a,(hl)		; $6880
	ld b,$6d		; $6881
	call $6744		; $6883
	ld a,c			; $6886
	cp $7d			; $6887
	jp z,interactionIncState		; $6889
	ld l,$47		; $688c
	inc (hl)		; $688e
	ret			; $688f
	ld a,($ccba)		; $6890
	cp $1f			; $6893
	ret z			; $6895
	jp interactionIncState		; $6896
	call interactionDecCounter1		; $6899
	ret nz			; $689c
	inc l			; $689d
	ld a,(hl)		; $689e
	ld b,$f4		; $689f
	call $6744		; $68a1
	ld a,c			; $68a4
	cp $73			; $68a5
	jr z,_label_15_275	; $68a7
	ld l,$47		; $68a9
	dec (hl)		; $68ab
	ret			; $68ac
_label_15_275:
	ld h,d			; $68ad
	ld l,$44		; $68ae
	ld (hl),$01		; $68b0
	ret			; $68b2
	ld e,$44		; $68b3
	ld a,(de)		; $68b5
	or a			; $68b6
	jr nz,_label_15_276	; $68b7
	call getThisRoomFlags		; $68b9
	and $20			; $68bc
	jp nz,interactionDelete		; $68be
	call interactionIncState		; $68c1
_label_15_276:
	ld a,($cc31)		; $68c4
	bit 6,a			; $68c7
	ret z			; $68c9
	call getFreeInteractionSlot		; $68ca
	ret nz			; $68cd
	ld (hl),$60		; $68ce
	inc l			; $68d0
	ld (hl),$30		; $68d1
	inc l			; $68d3
	ld (hl),$01		; $68d4
	call objectCopyPosition		; $68d6
	jp interactionDelete		; $68d9
	ld e,$44		; $68dc
	ld a,(de)		; $68de
	rst_jumpTable			; $68df
	ld ($ed68),a		; $68e0
	ld l,b			; $68e3
	ld ($4a69),sp		; $68e4
	ld l,c			; $68e7
	ld (hl),b		; $68e8
	ld l,c			; $68e9
	ld a,$01		; $68ea
	ld (de),a		; $68ec
	ld e,$70		; $68ed
	ld a,(de)		; $68ef
	ld b,a			; $68f0
	ld a,($ccba)		; $68f1
	cp b			; $68f4
	ret z			; $68f5
	ld (de),a		; $68f6
	ld ($ccc8),a		; $68f7
	ld c,a			; $68fa
	ld a,b			; $68fb
	cpl			; $68fc
	and c			; $68fd
	call getHighestSetBit		; $68fe
	ld h,d			; $6901
	ld l,$71		; $6902
	ld (hl),a		; $6904
	jp interactionIncState		; $6905
	ld b,$04		; $6908
_label_15_277:
	call $6923		; $690a
	call getFreeInteractionSlot		; $690d
	ret nz			; $6910
	ld (hl),$05		; $6911
	ld l,$4b		; $6913
	call setShortPosition_paramC		; $6915
	dec b			; $6918
	jr nz,_label_15_277	; $6919
	call interactionIncState		; $691b
	ld l,$46		; $691e
	ld (hl),$1e		; $6920
	ret			; $6922
	ld a,b			; $6923
	dec a			; $6924
	ld hl,$692b		; $6925
	rst_addAToHl			; $6928
	ld c,(hl)		; $6929
	ret			; $692a
	ldi (hl),a		; $692b
	inc l			; $692c
	add d			; $692d
	adc h			; $692e
	ld e,$71		; $692f
	ld a,(de)		; $6931
	ld hl,$693a		; $6932
	rst_addDoubleIndex			; $6935
	ldi a,(hl)		; $6936
	ld e,(hl)		; $6937
	ld d,a			; $6938
	ret			; $6939
	inc d			; $693a
	nop			; $693b
	ld (de),a		; $693c
	nop			; $693d
	ld hl,$3c01		; $693e
	nop			; $6941
	dec c			; $6942
	ld bc,$001c		; $6943
	inc hl			; $6946
	nop			; $6947
	ld sp,$cd02		; $6948
	add a			; $694b
	inc hl			; $694c
	ret nz			; $694d
	ld a,$01		; $694e
	ld ($cc17),a		; $6950
	call $692f		; $6953
	ld b,$04		; $6956
_label_15_278:
	call $6923		; $6958
	call getFreeEnemySlot		; $695b
	ret nz			; $695e
	ld (hl),d		; $695f
	inc l			; $6960
	ld (hl),e		; $6961
	ld l,$8b		; $6962
	call setShortPosition_paramC		; $6964
	dec b			; $6967
	jr nz,_label_15_278	; $6968
	ldh a,(<hActiveObject)	; $696a
	ld d,a			; $696c
	jp interactionIncState		; $696d
	ld a,($cc30)		; $6970
	or a			; $6973
	ret nz			; $6974
	ld a,($ccba)		; $6975
	inc a			; $6978
	jp z,interactionDelete		; $6979
	xor a			; $697c
	ld ($ccc8),a		; $697d
	ld e,$44		; $6980
	ld a,$01		; $6982
	ld (de),a		; $6984
	ret			; $6985
	ld e,$44		; $6986
	ld a,(de)		; $6988
	rst_jumpTable			; $6989
	adc (hl)		; $698a
	ld l,c			; $698b
	sub c			; $698c
	ld l,c			; $698d
	ld a,$01		; $698e
	ld (de),a		; $6990
	ld a,($ccbc)		; $6991
	or a			; $6994
	ret z			; $6995
	ld b,a			; $6996
	ld e,$47		; $6997
	ld a,(de)		; $6999
	ld hl,$6a02		; $699a
	rst_addAToHl			; $699d
	ld a,(hl)		; $699e
	cp b			; $699f
	jr nz,_label_15_279	; $69a0
	ld a,(de)		; $69a2
	inc a			; $69a3
	ld (de),a		; $69a4
	jr _label_15_280		; $69a5
_label_15_279:
	ld e,$70		; $69a7
	ld a,$01		; $69a9
	ld (de),a		; $69ab
_label_15_280:
	ld bc,$2809		; $69ac
	ld e,$70		; $69af
	ld a,(de)		; $69b1
	or a			; $69b2
	jr nz,_label_15_281	; $69b3
	ld bc,$280d		; $69b5
	ld e,$47		; $69b8
	ld a,(de)		; $69ba
	cp $08			; $69bb
	jr c,_label_15_283	; $69bd
	call getThisRoomFlags		; $69bf
	bit 5,a			; $69c2
	jr nz,_label_15_283	; $69c4
	set 7,(hl)		; $69c6
	call $6a18		; $69c8
	ld a,$4f		; $69cb
	call setTile		; $69cd
	ld a,$4d		; $69d0
	ld bc,$280d		; $69d2
	jr _label_15_282		; $69d5
_label_15_281:
	ld a,$5a		; $69d7
_label_15_282:
	call playSound		; $69d9
_label_15_283:
	call getFreeInteractionSlot		; $69dc
	ret nz			; $69df
	ld (hl),$60		; $69e0
	inc l			; $69e2
	ld (hl),b		; $69e3
	inc l			; $69e4
	ld (hl),c		; $69e5
	ld l,$4b		; $69e6
	ld a,($ccbc)		; $69e8
	ld b,a			; $69eb
	and $f0			; $69ec
	ldi (hl),a		; $69ee
	inc l			; $69ef
	ld a,b			; $69f0
	swap a			; $69f1
	and $f0			; $69f3
	or $08			; $69f5
	ld (hl),a		; $69f7
	ld a,$81		; $69f8
	ld ($cca4),a		; $69fa
	xor a			; $69fd
	ld ($ccbc),a		; $69fe
	ret			; $6a01
	ld h,(hl)		; $6a02
	ld e,e			; $6a03
	ld b,e			; $6a04
	dec sp			; $6a05
	ld e,c			; $6a06
	inc hl			; $6a07
	ld (hl),e		; $6a08
	dec (hl)		; $6a09
	call getThisRoomFlags		; $6a0a
	and $80			; $6a0d
	jp z,interactionDelete		; $6a0f
	call $6a18		; $6a12
	jp interactionDelete		; $6a15
	call getFreeInteractionSlot		; $6a18
	ret nz			; $6a1b
	ld (hl),$e1		; $6a1c
	inc l			; $6a1e
	ld (hl),$01		; $6a1f
	ld c,$57		; $6a21
	ld l,$4b		; $6a23
	jp setShortPosition_paramC		; $6a25
	ld hl,$c904		; $6a28
	set 4,(hl)		; $6a2b
	jp interactionDelete		; $6a2d
	xor a			; $6a30
	ld ($cc31),a		; $6a31
	jp interactionDelete		; $6a34
	call checkInteractionState		; $6a37
	jr nz,_label_15_284	; $6a3a
	call objectGetTileAtPosition		; $6a3c
	ld a,($cca8)		; $6a3f
	cp l			; $6a42
	jp nz,interactionDelete		; $6a43
	call interactionIncState		; $6a46
	call interactionSetAlwaysUpdateBit		; $6a49
	ld a,$81		; $6a4c
	ld ($cca4),a		; $6a4e
	ld ($cc02),a		; $6a51
_label_15_284:
	ld a,($c4ab)		; $6a54
	or a			; $6a57
	ret nz			; $6a58
	ld bc,$0202		; $6a59
	call showText		; $6a5c
	xor a			; $6a5f
	ld ($cca4),a		; $6a60
	ld ($cc02),a		; $6a63
	jp interactionDelete		; $6a66
	ld a,($cc66)		; $6a69
	cp $22			; $6a6c
	jr nz,_label_15_285	; $6a6e
	xor a			; $6a70
	ld ($cc66),a		; $6a71
	call initializeDungeonStuff		; $6a74
_label_15_285:
	jp interactionDelete		; $6a77
	ld a,($cd00)		; $6a7a
	and $01			; $6a7d
	ret z			; $6a7f
	ld hl,$cf79		; $6a80
_label_15_286:
	ld a,(hl)		; $6a83
	cp $fe			; $6a84
	jr z,_label_15_287	; $6a86
	cp $ff			; $6a88
	jr nz,_label_15_288	; $6a8a
_label_15_287:
	ld (hl),$7b		; $6a8c
_label_15_288:
	dec l			; $6a8e
	jr nz,_label_15_286	; $6a8f
	jp interactionDelete		; $6a91

interactionCodedd:
	ld e,$44		; $6a94
	ld a,(de)		; $6a96
	or a			; $6a97
	jr z,_label_15_289	; $6a98
	call interactionRunScript		; $6a9a
	jp c,interactionDelete		; $6a9d
	jp npcFaceLinkAndAnimate		; $6aa0
_label_15_289:
	call getThisRoomFlags		; $6aa3
	and $40			; $6aa6
	jp nz,interactionDelete		; $6aa8
	call interactionIncState		; $6aab
	call interactionInitGraphics		; $6aae
	call objectSetVisible82		; $6ab1
	ld a,$1f		; $6ab4
	call interactionSetHighTextIndex		; $6ab6
	ld hl,$7f0a		; $6ab9
	jp interactionSetScript		; $6abc

seasonsFunc_15_6abf:
	xor a			; $6abf
	ld hl,$cba8		; $6ac0
	ldi (hl),a		; $6ac3
	ldd (hl),a		; $6ac4
	ld a,($c6c9)		; $6ac5
	and $0f			; $6ac8
	call getNumSetBits		; $6aca
	ld (hl),a		; $6acd
	cp $04			; $6ace
	ld a,$01		; $6ad0
	jr z,_label_15_290	; $6ad2
	dec a			; $6ad4
_label_15_290:
	ld ($cfc1),a		; $6ad5
	ret			; $6ad8

seasonsFunc_15_6ad9:
	ld bc,$0700		; $6ad9
	jp giveRingToLink		; $6adc

interactionCodede:
	ld e,$42		; $6adf
	ld a,(de)		; $6ae1
	rst_jumpTable			; $6ae2
	push af			; $6ae3
	ld l,d			; $6ae4
	dec l			; $6ae5
	ld l,h			; $6ae6
	dec l			; $6ae7
	ld l,h			; $6ae8
	dec l			; $6ae9
	ld l,h			; $6aea
	dec l			; $6aeb
	ld l,h			; $6aec
	dec l			; $6aed
	ld l,h			; $6aee
	dec l			; $6aef
	ld l,h			; $6af0
	dec l			; $6af1
	ld l,h			; $6af2
	dec l			; $6af3
	ld l,h			; $6af4
	ld e,$44		; $6af5
	ld a,(de)		; $6af7
	rst_jumpTable			; $6af8
	ld bc,$326b		; $6af9
	ld l,e			; $6afc
	ld b,h			; $6afd
	ld l,e			; $6afe
	ld l,d			; $6aff
	ld l,e			; $6b00
	ld a,$01		; $6b01
	ld (de),a		; $6b03
	call interactionInitGraphics		; $6b04
	ld a,($d00b)		; $6b07
	sub $0e			; $6b0a
	ld e,$4b		; $6b0c
	ld (de),a		; $6b0e
	ld a,($d00d)		; $6b0f
	ld e,$4d		; $6b12
	ld (de),a		; $6b14
	call setLinkForceStateToState08		; $6b15
	ld a,$f1		; $6b18
	call playSound		; $6b1a
	ld a,$77		; $6b1d
	call playSound		; $6b1f
	ld b,$84		; $6b22
	call objectCreateInteractionWithSubid00		; $6b24
	ret nz			; $6b27
	ld l,$46		; $6b28
	ld e,l			; $6b2a
	ld a,$78		; $6b2b
	ld (hl),a		; $6b2d
	ld (de),a		; $6b2e
	jp objectSetVisible82		; $6b2f
	ld a,$0f		; $6b32
	ld ($cc6b),a		; $6b34
	call interactionDecCounter1		; $6b37
	ret nz			; $6b3a
	ld (hl),$40		; $6b3b
	ld l,$50		; $6b3d
	ld (hl),$14		; $6b3f
	jp interactionIncState		; $6b41
	call objectApplySpeed		; $6b44
	call $6c94		; $6b47
	call interactionDecCounter1		; $6b4a
	ret nz			; $6b4d
	ld (hl),$78		; $6b4e
	ld a,$10		; $6b50
	ld ($cc6b),a		; $6b52
	ld l,$4b		; $6b55
	ld (hl),$28		; $6b57
	ld l,$4d		; $6b59
	ld (hl),$50		; $6b5b
	ld a,$8a		; $6b5d
	call playSound		; $6b5f
	ld a,$03		; $6b62
	call fadeinFromWhiteWithDelay		; $6b64
	jp interactionIncState		; $6b67
	call $6c94		; $6b6a
	call $6ccb		; $6b6d
	ld e,$45		; $6b70
	ld a,(de)		; $6b72
	rst_jumpTable			; $6b73
	adc b			; $6b74
	ld l,e			; $6b75
	sub h			; $6b76
	ld l,e			; $6b77
.DB $d3				; $6b78
	ld l,e			; $6b79
	and $6b			; $6b7a
	di			; $6b7c
	ld l,e			; $6b7d
	and $6b			; $6b7e
	di			; $6b80
	ld l,e			; $6b81
	and $6b			; $6b82
	rlca			; $6b84
	ld l,h			; $6b85
	jr $6c			; $6b86
	call interactionDecCounter1		; $6b88
	ret nz			; $6b8b
	ld (hl),$14		; $6b8c
	inc l			; $6b8e
	ld (hl),$08		; $6b8f
	jp interactionIncState2		; $6b91
	call interactionDecCounter1		; $6b94
	ret nz			; $6b97
	ld (hl),$14		; $6b98
	inc l			; $6b9a
	dec (hl)		; $6b9b
	ld b,(hl)		; $6b9c
	call getFreeInteractionSlot		; $6b9d
	ret nz			; $6ba0
	ld (hl),$de		; $6ba1
	call objectCopyPosition		; $6ba3
	ld a,b			; $6ba6
	ld bc,$6bc3		; $6ba7
	call addDoubleIndexToBc		; $6baa
	ld a,(bc)		; $6bad
	ld l,$42		; $6bae
	ld (hl),a		; $6bb0
	ld l,$49		; $6bb1
	inc bc			; $6bb3
	ld a,(bc)		; $6bb4
	ld (hl),a		; $6bb5
	ld e,$47		; $6bb6
	ld a,(de)		; $6bb8
	or a			; $6bb9
	ret nz			; $6bba
	call interactionIncState2		; $6bbb
	ld l,$46		; $6bbe
	ld (hl),$78		; $6bc0
	ret			; $6bc2
	ld ($071a),sp		; $6bc3
	ld d,$06		; $6bc6
	ld (de),a		; $6bc8
	dec b			; $6bc9
	ld c,$04		; $6bca
	ld a,(bc)		; $6bcc
	inc bc			; $6bcd
	ld b,$02		; $6bce
	ld (bc),a		; $6bd0
	ld bc,$cd1e		; $6bd1
	add a			; $6bd4
	inc hl			; $6bd5
	ret nz			; $6bd6
	ld (hl),$3c		; $6bd7
	ld a,$01		; $6bd9
	ld ($cfc0),a		; $6bdb
	ld a,$20		; $6bde
	ld ($cfc1),a		; $6be0
	jp interactionIncState2		; $6be3
	ld a,(wFrameCounter)		; $6be6
	and $03			; $6be9
	jr nz,_label_15_291	; $6beb
	ld hl,$cfc1		; $6bed
	dec (hl)		; $6bf0
	jr _label_15_291		; $6bf1
	ld a,(wFrameCounter)		; $6bf3
	and $03			; $6bf6
	jr nz,_label_15_291	; $6bf8
	ld hl,$cfc1		; $6bfa
	inc (hl)		; $6bfd
_label_15_291:
	call interactionDecCounter1		; $6bfe
	ret nz			; $6c01
	ld (hl),$3c		; $6c02
	jp interactionIncState2		; $6c04
	ld hl,$cfc1		; $6c07
	inc (hl)		; $6c0a
	ld a,$b4		; $6c0b
	call playSound		; $6c0d
	ld a,$04		; $6c10
	call fadeoutToWhiteWithDelay		; $6c12
	jp interactionIncState2		; $6c15
	ld hl,$cfc1		; $6c18
	inc (hl)		; $6c1b
	ld a,($c4ab)		; $6c1c
	or a			; $6c1f
	ret nz			; $6c20
	ld hl,$cbb3		; $6c21
	inc (hl)		; $6c24
	ld a,$08		; $6c25
	call fadeinFromWhiteWithDelay		; $6c27
	jp interactionDelete		; $6c2a
	ld e,$44		; $6c2d
	ld a,(de)		; $6c2f
	rst_jumpTable			; $6c30
	add hl,sp		; $6c31
	ld l,h			; $6c32
	ld e,h			; $6c33
	ld l,h			; $6c34
	ld h,(hl)		; $6c35
	ld l,h			; $6c36
	ld l,(hl)		; $6c37
	ld l,h			; $6c38
	ld a,$01		; $6c39
	ld (de),a		; $6c3b
	ld h,d			; $6c3c
	ld l,$46		; $6c3d
	ld (hl),$10		; $6c3f
	ld l,$50		; $6c41
	ld (hl),$50		; $6c43
	ld a,$98		; $6c45
	call playSound		; $6c47
	call objectCenterOnTile		; $6c4a
	ld l,$4d		; $6c4d
	ld a,(hl)		; $6c4f
	sub $08			; $6c50
	ldi (hl),a		; $6c52
	xor a			; $6c53
	ldi (hl),a		; $6c54
	ld (hl),a		; $6c55
	call interactionInitGraphics		; $6c56
	jp objectSetVisible80		; $6c59
	call objectApplySpeed		; $6c5c
	call interactionDecCounter1		; $6c5f
	ret nz			; $6c62
	jp interactionIncState		; $6c63
	ld a,($cfc0)		; $6c66
	or a			; $6c69
	ret z			; $6c6a
	jp interactionIncState		; $6c6b
	call objectCheckWithinScreenBoundary		; $6c6e
	jp nc,interactionDelete		; $6c71
	ld a,(wFrameCounter)		; $6c74
	rrca			; $6c77
	ret c			; $6c78
	ld h,d			; $6c79
	ld l,$49		; $6c7a
	inc (hl)		; $6c7c
	ld a,(hl)		; $6c7d
	and $1f			; $6c7e
	ld (hl),a		; $6c80
	ld e,l			; $6c81
	or a			; $6c82
	call z,$6c8f		; $6c83
	ld bc,$2850		; $6c86
	ld a,($cfc1)		; $6c89
	jp objectSetPositionInCircleArc		; $6c8c
	ld a,$c9		; $6c8f
	jp playSound		; $6c91
	ld a,(wFrameCounter)		; $6c94
	and $07			; $6c97
	ret nz			; $6c99
	ld bc,$8403		; $6c9a
	call objectCreateInteraction		; $6c9d
	ret nz			; $6ca0
	ld a,(wFrameCounter)		; $6ca1
	and $38			; $6ca4
	swap a			; $6ca6
	rlca			; $6ca8
	ld bc,$6cbb		; $6ca9
	call addDoubleIndexToBc		; $6cac
	ld l,$4b		; $6caf
	ld a,(bc)		; $6cb1
	add (hl)		; $6cb2
	ld (hl),a		; $6cb3
	inc bc			; $6cb4
	ld l,$4d		; $6cb5
	ld a,(bc)		; $6cb7
	add (hl)		; $6cb8
	ld (hl),a		; $6cb9
	ret			; $6cba
	stop			; $6cbb
	ld (bc),a		; $6cbc
	stop			; $6cbd
	cp $08			; $6cbe
	dec b			; $6cc0
	ld ($0cfb),sp		; $6cc1
	ld ($f80c),sp		; $6cc4
	ld b,$0b		; $6cc7
	ld b,$f5		; $6cc9
	ld a,(wFrameCounter)		; $6ccb
	and $07			; $6cce
	ret nz			; $6cd0
	ld a,(wFrameCounter)		; $6cd1
	and $38			; $6cd4
	swap a			; $6cd6
	rlca			; $6cd8
	ld hl,$6ce2		; $6cd9
	rst_addAToHl			; $6cdc
	ld e,$4f		; $6cdd
	ld a,(hl)		; $6cdf
	ld (de),a		; $6ce0
	ret			; $6ce1
	rst $38			; $6ce2
	cp $ff			; $6ce3
	nop			; $6ce5
	ld bc,$0102		; $6ce6
	nop			; $6ce9

interactionCodedf:
	ld e,$44		; $6cea
	ld a,(de)		; $6cec
	rst_jumpTable			; $6ced
	ld a,($ff00+c)		; $6cee
	ld l,h			; $6cef
	rrca			; $6cf0
	ld l,l			; $6cf1
	ld a,$01		; $6cf2
	ld (de),a		; $6cf4
	call interactionInitGraphics		; $6cf5
	ld h,d			; $6cf8
	ld l,$50		; $6cf9
	ld (hl),$14		; $6cfb
	ld l,$49		; $6cfd
	ld (hl),$18		; $6cff
	ld l,$46		; $6d01
	ld (hl),$3c		; $6d03
	ld l,$42		; $6d05
	ld a,(hl)		; $6d07
	or a			; $6d08
	jp z,objectSetVisiblec2		; $6d09
	jp objectSetVisiblec0		; $6d0c
	ld e,$45		; $6d0f
	ld a,(de)		; $6d11
	rst_jumpTable			; $6d12
	ld hl,$286d		; $6d13
	ld l,l			; $6d16
	ld b,d			; $6d17
	ld l,l			; $6d18
	ld d,a			; $6d19
	ld l,l			; $6d1a
	and a			; $6d1b
	ld l,l			; $6d1c
	cp (hl)			; $6d1d
	ld l,l			; $6d1e
	call z,$cd6d		; $6d1f
	add a			; $6d22
	inc hl			; $6d23
	ret nz			; $6d24
	call interactionIncState2		; $6d25
	call interactionAnimate		; $6d28
	call objectApplySpeed		; $6d2b
	cp $68			; $6d2e
	ret nz			; $6d30
	call interactionIncState2		; $6d31
	ld l,$46		; $6d34
	ld (hl),$b4		; $6d36
	ld l,$42		; $6d38
	ld a,(hl)		; $6d3a
	or a			; $6d3b
	ret nz			; $6d3c
	ld a,$05		; $6d3d
	jp interactionSetAnimation		; $6d3f
	call interactionDecCounter1		; $6d42
	ret nz			; $6d45
	ld hl,$cfd0		; $6d46
	ld (hl),$01		; $6d49
	call interactionIncState2		; $6d4b
	ld l,$46		; $6d4e
	ld (hl),$04		; $6d50
	inc l			; $6d52
	ld (hl),$01		; $6d53
	jr _label_15_294		; $6d55
	ld h,d			; $6d57
	ld l,$46		; $6d58
	call decHlRef16WithCap		; $6d5a
	jr nz,_label_15_293	; $6d5d
	call interactionIncState2		; $6d5f
	ld l,$46		; $6d62
	ld (hl),$64		; $6d64
	ld b,$14		; $6d66
	ld c,$04		; $6d68
	ld l,$42		; $6d6a
	ld a,(hl)		; $6d6c
	or a			; $6d6d
	jr z,_label_15_292	; $6d6e
	ld b,$3c		; $6d70
	ld c,$02		; $6d72
_label_15_292:
	ld l,$50		; $6d74
	ld (hl),b		; $6d76
	ld a,c			; $6d77
	call interactionSetAnimation		; $6d78
	ld hl,$cfd0		; $6d7b
	ld (hl),$02		; $6d7e
	ret			; $6d80
_label_15_293:
	ld l,$42		; $6d81
	ld a,(hl)		; $6d83
	or a			; $6d84
	call z,interactionAnimate		; $6d85
	ld l,$77		; $6d88
	dec (hl)		; $6d8a
	ret nz			; $6d8b
	ld l,$48		; $6d8c
	ld a,(hl)		; $6d8e
	xor $01			; $6d8f
	ld (hl),a		; $6d91
	ld e,$42		; $6d92
	ld a,(de)		; $6d94
	add a			; $6d95
	add (hl)		; $6d96
	call interactionSetAnimation		; $6d97
_label_15_294:
	call getRandomNumber_noPreserveVars		; $6d9a
	and $03			; $6d9d
	swap a			; $6d9f
	add $20			; $6da1
	ld e,$77		; $6da3
	ld (de),a		; $6da5
	ret			; $6da6
	call interactionDecCounter1		; $6da7
	ret nz			; $6daa
	ld b,$78		; $6dab
	ld e,$42		; $6dad
	ld a,(de)		; $6daf
	or a			; $6db0
	jr nz,_label_15_295	; $6db1
	ld b,$a0		; $6db3
_label_15_295:
	ld (hl),b		; $6db5
	ld hl,$cfd0		; $6db6
	ld (hl),$03		; $6db9
	jp interactionIncState2		; $6dbb
	call interactionDecCounter1		; $6dbe
	ret nz			; $6dc1
	ld (hl),$3c		; $6dc2
	ld hl,$cfd0		; $6dc4
	ld (hl),$04		; $6dc7
	jp interactionIncState2		; $6dc9
	call interactionAnimate		; $6dcc
	call objectApplySpeed		; $6dcf
	call interactionDecCounter1		; $6dd2
	ret nz			; $6dd5
	ld hl,$cfdf		; $6dd6
	ld (hl),$01		; $6dd9
	ret			; $6ddb

interactionCodee1:
	ld e,$44		; $6ddc
	ld a,(de)		; $6dde
	rst_jumpTable			; $6ddf
	and $6d			; $6de0
	rst $28			; $6de2
	ld l,l			; $6de3
	cp b			; $6de4
	dec h			; $6de5
	ld a,$01		; $6de6
	ld (de),a		; $6de8
	call interactionInitGraphics		; $6de9
	call interactionSetAlwaysUpdateBit		; $6dec
	ld a,($cc49)		; $6def
	or a			; $6df2
	jr nz,_label_15_296	; $6df3
	call objectGetTileAtPosition		; $6df5
	cp $e6			; $6df8
	ret nz			; $6dfa
_label_15_296:
	call $6e06		; $6dfb
	ld a,$02		; $6dfe
	ld e,$44		; $6e00
	ld (de),a		; $6e02
	jp objectSetVisible83		; $6e03
	ld e,$42		; $6e06
	ld a,(de)		; $6e08
	or a			; $6e09
	ret nz			; $6e0a
	call getThisRoomFlags		; $6e0b
	ld a,($cc49)		; $6e0e
	cp $02			; $6e11
	jr c,_label_15_297	; $6e13
	cp $03			; $6e15
	ret nz			; $6e17
	ld a,($cc4c)		; $6e18
	cp $a8			; $6e1b
	ld hl,$c704		; $6e1d
	jr z,_label_15_297	; $6e20
	ld hl,$c7f7		; $6e22
_label_15_297:
	set 3,(hl)		; $6e25
	ret			; $6e27

interactionCodee3:
	ld e,$44		; $6e28
	ld a,(de)		; $6e2a
	rst_jumpTable			; $6e2b
	jr nc,_label_15_300	; $6e2c
	ld d,d			; $6e2e
	ld l,(hl)		; $6e2f
	ld a,$01		; $6e30
	ld (de),a		; $6e32
	call interactionInitGraphics		; $6e33
	call interactionSetAlwaysUpdateBit		; $6e36
	ld bc,$fe00		; $6e39
	call objectSetSpeedZ		; $6e3c
	ld hl,$7f29		; $6e3f
	call interactionSetScript		; $6e42
	ld a,$bb		; $6e45
	call playSound		; $6e47
	ld a,$00		; $6e4a
	call interactionSetAnimation		; $6e4c
	jp interactionAnimateAsNpc		; $6e4f
	ld e,$45		; $6e52
	ld a,(de)		; $6e54
	rst_jumpTable			; $6e55
	ld e,(hl)		; $6e56
	ld l,(hl)		; $6e57
	ld a,(hl)		; $6e58
	ld l,(hl)		; $6e59
	sbc h			; $6e5a
	ld l,(hl)		; $6e5b
	cp h			; $6e5c
	ld l,(hl)		; $6e5d
	call $6ede		; $6e5e
	ld e,$4f		; $6e61
	ld a,(de)		; $6e63
	cp $e0			; $6e64
	jr c,_label_15_298	; $6e66
	jp interactionAnimateAsNpc		; $6e68
_label_15_298:
	call interactionIncState2		; $6e6b
	ld a,$39		; $6e6e
	ld (wActiveMusic),a		; $6e70
	call playSound		; $6e73
	ld a,$01		; $6e76
	call interactionSetAnimation		; $6e78
	jp interactionAnimateAsNpc		; $6e7b
	ld hl,$71ce		; $6e7e
	ld e,$0a		; $6e81
	call interBankCall		; $6e83
	call interactionRunScript		; $6e86
	jr c,_label_15_299	; $6e89
	jp interactionAnimateAsNpc		; $6e8b
_label_15_299:
	call interactionIncState2		; $6e8e
	ld a,$74		; $6e91
	call playSound		; $6e93
	ld bc,$fc00		; $6e96
	call objectSetSpeedZ		; $6e99
_label_15_300:
	call $6ede		; $6e9c
	ld e,$4f		; $6e9f
	ld a,(de)		; $6ea1
	cp $b0			; $6ea2
	jr c,_label_15_301	; $6ea4
	jp interactionAnimateAsNpc		; $6ea6
_label_15_301:
	ld a,($cc62)		; $6ea9
	ld (wActiveMusic),a		; $6eac
	call playSound		; $6eaf
	xor a			; $6eb2
	ld ($cc02),a		; $6eb3
	ld ($cca4),a		; $6eb6
	call interactionIncState2		; $6eb9
	call getFreeInteractionSlot		; $6ebc
	ret nz			; $6ebf
	ld (hl),$90		; $6ec0
	inc l			; $6ec2
	ld (hl),$07		; $6ec3
	ld l,$4b		; $6ec5
	ld (hl),$7c		; $6ec7
	ld l,$4d		; $6ec9
	ld (hl),$78		; $6ecb
	call getFreeInteractionSlot		; $6ecd
	jr nz,_label_15_302	; $6ed0
	ld (hl),$05		; $6ed2
	ld a,$78		; $6ed4
	ld l,$4b		; $6ed6
	ldi (hl),a		; $6ed8
	inc l			; $6ed9
	ld (hl),a		; $6eda
_label_15_302:
	jp interactionDelete		; $6edb
	ldh a,(<hActiveObjectType)	; $6ede
	add $0e			; $6ee0
	ld l,a			; $6ee2
	add $06			; $6ee3
	ld e,a			; $6ee5
	ld h,d			; $6ee6
	jp objectApplyComponentSpeed@addSpeedComponent		; $6ee7

interactionCodee4:
	call checkInteractionState		; $6eea
	jr z,_label_15_303	; $6eed
	call interactionRunScript		; $6eef
	jp c,interactionDelete		; $6ef2
	jp npcFaceLinkAndAnimate		; $6ef5
_label_15_303:
	call getThisRoomFlags		; $6ef8
	and $40			; $6efb
	jp nz,interactionDelete		; $6efd
	call interactionIncState		; $6f00
	call interactionInitGraphics		; $6f03
	call objectSetVisible82		; $6f06
	ld a,$33		; $6f09
	call interactionSetHighTextIndex		; $6f0b
	ld hl,$7f33		; $6f0e
	jp interactionSetScript		; $6f11

seasonsFunc_15_6f14:
	ld a,$01		; $6f14
	ld ($ccbb),a		; $6f16
	dec a			; $6f19
	ld ($ccbc),a		; $6f1a
	ld b,$08		; $6f1d
_label_15_304:
	call $6f39		; $6f1f
	call getFreeInteractionSlot		; $6f22
	jr nz,_label_15_305	; $6f25
	ld (hl),$05		; $6f27
	ld l,$4b		; $6f29
	call setShortPosition_paramC		; $6f2b
_label_15_305:
	push bc			; $6f2e
	ld a,$f1		; $6f2f
	call setTile		; $6f31
	pop bc			; $6f34
	dec b			; $6f35
	jr nz,_label_15_304	; $6f36
	ret			; $6f38
	ld a,b			; $6f39
	dec a			; $6f3a
	ld hl,$6f41		; $6f3b
	rst_addAToHl			; $6f3e
	ld c,(hl)		; $6f3f
	ret			; $6f40
	inc hl			; $6f41
	dec (hl)		; $6f42
	dec sp			; $6f43
	ld b,e			; $6f44
	ld e,c			; $6f45
	ld e,e			; $6f46
	ld h,(hl)		; $6f47
	ld (hl),e		; $6f48

seasonsFunc_15_6f49:
	xor a			; $6f49
	ld ($cfd0),a		; $6f4a
	ld a,$08		; $6f4d
	call cpRupeeValue		; $6f4f
	ret nz			; $6f52
	ld a,$08		; $6f53
	call removeRupeeValue		; $6f55
	ld a,$01		; $6f58
	ld ($cfd0),a		; $6f5a
	ret			; $6f5d


; ==============================================================================
; INTERACID_GET_ROD_OF_SEASONS
;
; Variables:
;   var03:    Index of a seasons' sparkle from 0 to 3
;   var3b:    Initial time for each seasons' sparkle to start dropping sparkles
;   $cceb:    Set to 1 when Rod disappears, to remove its aura, and continue cutscene
; ==============================================================================
interactionCodee6:
	ld e,Interaction.state		; $6f5e
	ld a,(de)		; $6f60
	rst_jumpTable			; $6f61
	.dw _interactionCodee6_state0
	.dw _interactionCodee6_state1

_interactionCodee6_state0:
	ld a,$01		; $6f66
	ld (de),a		; $6f68

	call interactionInitGraphics		; $6f69
	ld e,Interaction.subid		; $6f6c
	ld a,(de)		; $6f6e
	rst_jumpTable			; $6f6f
	.dw @subid0
	.dw @sparkles
	.dw @rodOfSeasons
	.dw @rodOfSeasonsAura

@subid0:
	call getThisRoomFlags		; $6f78
	bit 5,(hl)		; $6f7b
	jp nz,interactionDelete		; $6f7d
	xor a			; $6f80
	ld ($cceb),a		; $6f81
	ld hl,gettingRodOfSeasons		; $6f84
	jp interactionSetScript		; $6f87

@sparkles:
	ld e,Interaction.var03		; $6f8a
	ld a,(de)		; $6f8c
	rlca			; $6f8d
	ld hl,@sparklesData		; $6f8e
	rst_addDoubleIndex			; $6f91

	ldi a,(hl)		; $6f92
	ld e,Interaction.angle		; $6f93
	ld (de),a		; $6f95

	ldi a,(hl)		; $6f96
	ld e,Interaction.oamFlags		; $6f97
	ld (de),a		; $6f99

	ldi a,(hl)		; $6f9a
	ld e,Interaction.var3b		; $6f9b
	ld (de),a		; $6f9d

	ldi a,(hl)		; $6f9e
	ld e,Interaction.speed		; $6f9f
	ld (de),a		; $6fa1

	ld h,d			; $6fa2
	ld l,Interaction.counter1		; $6fa3
	ld (hl),$3c		; $6fa5

	ld l,Interaction.counter2		; $6fa7
	ld (hl),$5a		; $6fa9
	jp objectSetVisible80		; $6fab
@sparklesData:
	; angle - oamFlags - var3b(time to start pulsing) - speed
	.db $03 $00 $08 SPEED_180
	.db $0b $02 $0c SPEED_100
	.db $15 $03 $10 SPEED_100
	.db $1d $01 $14 SPEED_180

@rodOfSeasons:
	ld a,$04		; $6fbe
	call objectSetCollideRadius		; $6fc0
	ld h,d			; $6fc3
	ld l,Interaction.zh		; $6fc4
	ld (hl),$f0		; $6fc6

	ld l,Interaction.counter1		; $6fc8
	ld (hl),$00		; $6fca

	ld l,Interaction.counter2		; $6fcc
	ld (hl),$30		; $6fce

	ldbc INTERACID_GET_ROD_OF_SEASONS 03		; $6fd0
	call objectCreateInteraction		; $6fd3
	ret nz			; $6fd6

	ld l,Interaction.relatedObj1		; $6fd7
	ldh a,(<hActiveObjectType)	; $6fd9
	ldi (hl),a		; $6fdb
	ldh a,(<hActiveObject)	; $6fdc
	ld (hl),a		; $6fde

	jp objectSetVisible81		; $6fdf

@rodOfSeasonsAura:
	call interactionSetAlwaysUpdateBit		; $6fe2
	jp objectSetVisible82		; $6fe5

_interactionCodee6_state1:
	ld e,Interaction.subid		; $6fe8
	ld a,(de)		; $6fea
	rst_jumpTable			; $6feb
	.dw @subid0
	.dw @sparkles
	.dw @rodOfSeasons
	.dw @rodOfSeasonsAura

@subid0:
	call interactionRunScript		; $6ff4
	jp c,interactionDelete		; $6ff7
	ret			; $6ffa

@sparkles:
	call interactionAnimate		; $6ffb
	ld e,Interaction.state2		; $6ffe
	ld a,(de)		; $7000
	rst_jumpTable			; $7001
	.dw @@waitToMove
	.dw @@move

@@waitToMove:
	call interactionDecCounter2		; $7006
	ret nz			; $7009
	call interactionIncState2		; $700a

@@move:
	call dropSparkles		; $700d
	call objectApplySpeed		; $7010
	call interactionDecCounter1		; $7013
	jp z,interactionDelete		; $7016
	ret			; $7019

@rodOfSeasons:
	ld e,Interaction.state2		; $701a
	ld a,(de)		; $701c
	rst_jumpTable			; $701d
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6

@@substate0:
	ld a,(wFrameCounter)		; $702c
	and $03			; $702f
	ret nz			; $7031

	ld h,d			; $7032
	ld l,Interaction.counter1		; $7033
	inc (hl)		; $7035
	ld a,(hl)		; $7036
	and $0f			; $7037
	ld hl,@@seasonsTable_15_705f		; $7039
	rst_addAToHl			; $703c
	ld a,(hl)		; $703d
	add $f0			; $703e
	ld e,Interaction.zh		; $7040
	ld (de),a		; $7042
	ld h,d			; $7043
	ld l,Interaction.counter2		; $7044
	dec (hl)		; $7046
	ret nz			; $7047

	call clearAllParentItems		; $7048

	ld hl,w1Link.direction		; $704b
	ld (hl),DIR_UP		; $704e

	call objectGetAngleTowardLink		; $7050
	ld h,d			; $7053
	ld l,Interaction.angle		; $7054
	ld (hl),a		; $7056

	ld l,Interaction.speed		; $7057
	ld (hl),SPEED_80		; $7059

	ld l,Interaction.state2		; $705b
	inc (hl)		; $705d
	ret			; $705e

@@seasonsTable_15_705f:
	.db $00 $00 $ff $ff
	.db $ff $fe $fe $fe
	.db $fe $fe $fe $ff
	.db $ff $ff $ff $00

@@substate1:
	call objectGetAngleTowardLink		; $706f
	ld e,Interaction.angle		; $7072
	ld (de),a		; $7074
	call objectApplySpeed		; $7075
	call objectCheckCollidedWithLink_ignoreZ		; $7078
	ret nc			; $707b

	ld e,Interaction.collisionRadiusX		; $707c
	ld a,$06		; $707e
	ld (de),a		; $7080
	jp interactionIncState2		; $7081

@@substate2:
	ld c,$08		; $7084
	call objectUpdateSpeedZ_paramC		; $7086
	jr z,+			; $7089
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $708b
	ret nc			; $708e
+
	ld h,d			; $708f
	ld l,Interaction.counter2		; $7090
	ld (hl),$1e		; $7092
	jp interactionIncState2		; $7094

@@substate3:
	call interactionDecCounter2		; $7097
	ret nz			; $709a

	ld a,$04		; $709b
	ld (wLinkForceState),a		; $709d
	xor a			; $70a0
	ld (wcc50),a		; $70a1

	call interactionIncState2		; $70a4
	ld a,(w1Link.yh)		; $70a7
	sub $0e			; $70aa
	ld l,Interaction.yh		; $70ac
	ldi (hl),a		; $70ae

	inc l			; $70af
	ld a,(w1Link.xh)		; $70b0
	sub $04			; $70b3
	ldi (hl),a		; $70b5

	; zh/speed
	inc l			; $70b6
	xor a			; $70b7
	ldi (hl),a		; $70b8
	ld (hl),a		; $70b9

	ld b,>TX_0071		; $70ba
	ld c,<TX_0071		; $70bc
	call showText		; $70be

	call getThisRoomFlags		; $70c1
	set 5,(hl)		; $70c4

	ld a,MUS_ESSENCE		; $70c6
	call playSound		; $70c8

	ld c,$07		; $70cb
	ld a,TREASURE_ROD_OF_SEASONS		; $70cd
	call giveTreasure		; $70cf

	jp darkenRoom		; $70d2

@@substate4:
	call retIfTextIsActive		; $70d5
	call interactionIncState2		; $70d8
	ld hl,setCounter1To32		; $70db
	jp interactionSetScript		; $70de

@@substate5:
	call interactionRunScript		; $70e1
	ret nc			; $70e4

	call interactionIncState2		; $70e5
	ld l,Interaction.counter2		; $70e8
	ld (hl),$14		; $70ea
	jp brightenRoom		; $70ec

@@substate6:
	ld a,(wPaletteThread_mode)		; $70ef
	or a			; $70f2
	ret nz			; $70f3

	call interactionDecCounter2		; $70f4
	ret nz			; $70f7
	ld a,$01		; $70f8
	ld ($cceb),a		; $70fa
	jp interactionDelete		; $70fd

@rodOfSeasonsAura:
	ld a,($cceb)		; $7100
	or a			; $7103
	jp nz,interactionDelete		; $7104

	ld a,$00		; $7107
	call objectGetRelatedObject1Var		; $7109
	call objectTakePosition		; $710c
	call interactionAnimate		; $710f
	ld h,d			; $7112
	ld l,Interaction.animParameter		; $7113
	ld a,(hl)		; $7115
	or a			; $7116
	ret z			; $7117
	ld (hl),$00		; $7118
	ld l,Interaction.visible		; $711a
	ld a,$80		; $711c
	xor (hl)		; $711e
	ld (hl),a		; $711f
	ret			; $7120

dropSparkles:
	ld h,d			; $7121
	ld l,Interaction.var3b		; $7122
	dec (hl)		; $7124
	ret nz			; $7125

	ld l,Interaction.var3b		; $7126
	ld (hl),$10		; $7128
	ldbc INTERACID_SPARKLE, $01		; $712a
	jp objectCreateInteraction		; $712d


forceLinksDirection:
	ld hl,w1Link.direction		; $7130
	ld (hl),a		; $7133
	ld a,$80		; $7134
	jp setLinkForceStateToState08_withParam		; $7136


spawnRodOfSeasonsSparkles:
	ld bc,@spawnCoordinates		; $7139
	xor a			; $713c
-
	ldh (<hFF8B),a		; $713d
	call getFreeInteractionSlot		; $713f
	ret nz			; $7142

	; spawn subid $01 (the sparkles for each season)
	ld (hl),INTERACID_GET_ROD_OF_SEASONS		; $7143
	inc l			; $7145
	ld (hl),$01		; $7146
	inc l			; $7148

	; var03 = 0 to 3
	ldh a,(<hFF8B)		; $7149
	ld (hl),a		; $714b

	; yx from table below
	ld l,Interaction.yh		; $714c
	ld a,(bc)		; $714e
	ld (hl),a		; $714f
	inc bc			; $7150
	ld l,Interaction.xh		; $7151
	ld a,(bc)		; $7153
	ld (hl),a		; $7154

	inc bc			; $7155
	ldh a,(<hFF8B)		; $7156
	inc a			; $7158

	cp $04			; $7159
	jr nz,-			; $715b
	ret			; $715d

@spawnCoordinates:
	.db $78 $18
	.db $08 $18
	.db $08 $88
	.db $78 $88


interactionCodee7:
	ld e,$44		; $7166
	ld a,(de)		; $7168
	rst_jumpTable			; $7169
	ld l,(hl)		; $716a
	ld (hl),c		; $716b
	adc c			; $716c
	ld (hl),c		; $716d
	ld a,$01		; $716e
	ld (de),a		; $7170
	call interactionInitGraphics		; $7171
	ld a,$36		; $7174
	call interactionSetHighTextIndex		; $7176
	ld e,$7e		; $7179
	ld a,$00		; $717b
	ld (de),a		; $717d
	ld hl,$5779		; $717e
	call interactionSetScript		; $7181
	ld a,$02		; $7184
	call interactionSetAnimation		; $7186
	call interactionRunScript		; $7189
	jp npcFaceLinkAndAnimate		; $718c
