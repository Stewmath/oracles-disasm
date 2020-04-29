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
