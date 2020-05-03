applyRoomSpecificTileChanges:
	ld a,(wActiveRoom)		; $60ab
	ld hl,roomTileChangerCodeGroupTable		; $60ae
	call findRoomSpecificData		; $60b1
	ret nc			; $60b4
	rst_jumpTable			; $60b5
	.dw tileReplacement_group0Mapc5 ; $00
	.dw tileReplacement_group0Mapd9 ; $01
	.dw tileReplacement_group4Map78 ; $02
	.dw tileReplacement_group2_3Mapb0 ; $03
	.dw tileReplacement_group4Map2e ; $04
	.dw tileReplacement_group4Map64 ; $05
	.dw tileReplacement_group4Map89 ; $06
	.dw tileReplacement_group4Mapbb ; $07
	.dw tileReplacement_group0Mapf6 ; $08
	.dw tileReplacement_group5Map65 ; $09
	.dw tileReplacement_group5Map66 ; $0a
	.dw tileReplacement_group5Map67 ; $0b
	.dw tileReplacement_group5Map68 ; $0c
	.dw tileReplacement_group5Map6a ; $0d
	.dw tileReplacement_group5Map6b ; $0e
	.dw tileReplacement_group5Map86 ; $0f
	.dw tileReplacement_group0Map54 ; $10
	.dw tileReplacement_group0Map7f ; $11
	.dw tileReplacement_group0Map62 ; $12
	.dw tileReplacement_group0Map60 ; $13
	.dw tileReplacement_group0Map61 ; $14
	.dw tileReplacement_group0Map70 ; $15
	.dw tileReplacement_group0Map71 ; $16
	.dw tileReplacement_group0Map81 ; $17
	.dw tileReplacement_group0Map0d ; $18
	.dw tileReplacement_group0Map1d ; $19
	.dw tileReplacement_group5Map7a ; $1a
	.dw tileReplacement_group5Map78 ; $1b
	.dw tileReplacement_group2_3Mapb5 ; $1c
	.dw tileReplacement_group0Map4b ; $1d
	.dw tileReplacement_group0Map63 ; $1e
	.dw tileReplacement_group0Mapf4 ; $1f
	.dw tileReplacement_group0Map6f ; $20
	.dw tileReplacement_group0Map42 ; $21
	.dw tileReplacement_group0Mapfc ; $22
	.dw tileReplacement_group1Map64 ; $23
	.dw tileReplacement_group1Map74 ; $24
	.dw tileReplacement_group0Mapee ; $25
	.dw tileReplacement_group0Mape4 ; $26
	.dw tileReplacement_group1Map35 ; $27
	.dw tileReplacement_group0Map56 ; $28
	.dw tileReplacement_group2_3Mapa4 ; $29
	.dw tileReplacement_group2_3Mapab ; $2a
	.dw tileReplacement_group5Map9e ; $2b
	.dw tileReplacement_group5Map8e ; $2c
	.dw tileReplacement_group5Map3b ; $2d
	.dw tileReplacement_group4Map61 ; $2e

roomTileChangerCodeGroupTable:
	.dw roomTileChangerCodeGroup0Data
	.dw roomTileChangerCodeGroup1Data
	.dw roomTileChangerCodeGroup2Data
	.dw roomTileChangerCodeGroup3Data
	.dw roomTileChangerCodeGroup4Data
	.dw roomTileChangerCodeGroup5Data
	.dw roomTileChangerCodeGroup6Data
	.dw roomTileChangerCodeGroup7Data

roomTileChangerCodeGroup0Data:
	.db $c5 $00
	.db $d9 $01
	.db $54 $10
	.db $7f $11
	.db $62 $12
	.db $60 $13
	.db $61 $14
	.db $70 $15
	.db $71 $16
	.db $81 $17
	.db $0d $18
	.db $1d $19
	.db $63 $1e
	.db $e4 $26
	.db $f4 $1f
	.db $6f $20
	.db $42 $21
	.db $fc $22
	.db $ee $25
	.db $56 $28
	.db $4b $1d
	.db $f6 $08
	.db $00

roomTileChangerCodeGroup1Data:
	.db $35 $27
	.db $64 $23
	.db $74 $24
	.db $00

roomTileChangerCodeGroup2Data:
roomTileChangerCodeGroup3Data:
	.db $a4 $29
	.db $ab $2a
	.db $b0 $03
	.db $b5 $1c
	.db $00

roomTileChangerCodeGroup4Data:
	.db $61 $2e
	.db $78 $02
	.db $2e $04
	.db $64 $05
	.db $89 $06
	.db $bb $07
	.db $00

roomTileChangerCodeGroup5Data:
	.db $3b $2d
	.db $65 $09
	.db $66 $0a
	.db $67 $0b
	.db $68 $0c
	.db $6a $0d
	.db $6b $0e
	.db $86 $0f
	.db $7a $1a
	.db $78 $1b
	.db $8e $2c
	.db $9e $2b
	.db $00

roomTileChangerCodeGroup6Data:
roomTileChangerCodeGroup7Data:
	.db $00			; $6187

	ret			; $6188

; Adds a sign outside couple's house
tileReplacement_group0Mapf6:
	ld a,GLOBALFLAG_FINISHEDGAME		; $6189
	call checkGlobalFlag		; $618b
	ret z			; $618e
	ld hl,wRoomLayout+$33		; $618f
	ld (hl),TILEINDEX_SIGN		; $6192
	ret			; $6194

; Open GBA shop
tileReplacement_group0Mapc5:
	ldh a,(<hGameboyType)	; $6195
	rlca			; $6197
	ret nc			; $6198
	ld hl,wRoomLayout+$14		; $6199
	ld (hl),$ea		; $619c
	ret			; $619e

; Open Maku tree gates
tileReplacement_group0Mapd9:
	call getThisRoomFlags		; $619f
	bit 7,(hl)		; $61a2
	ret z			; $61a4
	ld hl,wRoomLayout+$14		; $61a5
	ld a,$bf		; $61a8
	ldi (hl),a		; $61aa
	ld (hl),a		; $61ab
	ld l,$24		; $61ac
	ld a,$a9		; $61ae
	ldi (hl),a		; $61b0
	inc a			; $61b1
	ld (hl),a		; $61b2
	ret			; $61b3

; Open Tarm gates
tileReplacement_group0Map63:
	call getThisRoomFlags		; $61b4
	bit 7,(hl)		; $61b7
	ret z			; $61b9
	ld hl,wRoomLayout+$14		; $61ba
	ld a,$ad		; $61bd
	ldi (hl),a		; $61bf
	ld (hl),a		; $61c0
	ld l,$24		; $61c1
	ldi (hl),a		; $61c3
	ld (hl),a		; $61c4
	ret			; $61c5

; Mr. Write's house - lit torch
tileReplacement_group2_3Mapa4:
	call getThisRoomFlags		; $61c6
	and $40			; $61c9
	ret z			; $61cb
	ld hl,wRoomLayout+$36		; $61cc
	ld (hl),TILEINDEX_LIT_TORCH		; $61cf
	ret			; $61d1

; Bridge to moldorm guarding jewel
tileReplacement_group0Mape4:
	call getThisRoomFlags		; $61d2
	and $40			; $61d5
	jr z,+			; $61d7
	ld hl,wRoomLayout+$77		; $61d9
	ld (hl),TILEINDEX_OVERWORLD_LIT_TORCH		; $61dc
	ret			; $61de
+
	ld hl,@table_group0Mape4		; $61df
	ld d,$cf		; $61e2
-
	ldi a,(hl)		; $61e4
	or a			; $61e5
	ret z			; $61e6
	ld e,a			; $61e7
	ldi a,(hl)		; $61e8
	ld (de),a		; $61e9
	inc e			; $61ea
	ld (de),a		; $61eb
	jr -			; $61ec
@table_group0Mape4:
	.db $65 TILEINDEX_WATER
	.db $75 TILEINDEX_WATER
	.db $00

; Moldorm guarding jewel
tileReplacement_group0Mapf4:
	call getThisRoomFlags		; $61f3
	bit 6,(hl)		; $61f6
	ret z			; $61f8
	bit 5,(hl)		; $61f9
	jr nz,+			; $61fb
	ld hl,wRoomLayout+$45		; $61fd
	ld (hl),$f1		; $6200
+
	ld hl,wRoomLayout+$22		; $6202
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

; D4 - 1F stairs leading to 2-tile pits to stairs to B1
tileReplacement_group4Map78:
	call getThisRoomFlags		; $6215
	bit 7,(hl)		; $6218
	ret nz			; $621a
	ld hl,wRoomLayout+$39		; $621b
	ld (hl),$b0		; $621e
	ret			; $6220

; D4 - 3-torch room while on minecart
tileReplacement_group4Map64:
	call getThisRoomFlags		; $6221
	bit 7,(hl)		; $6224
	ret z			; $6226
	ld de,@tileReplaceTable		; $6227
	jp replaceTiles		; $622a
@tileReplaceTable:
	.db TILEINDEX_LIT_TORCH TILEINDEX_UNLIT_TORCH
	.db $00

; Member's shop - unlocking chest gambling game
tileReplacement_group2_3Mapb0:
	ld a,(wBoughtShopItems1)			; $6230
	and $0f			; $6233
	cp $0f			; $6235
	ret nz			; $6237

	ld hl,@rect		; $6238
	call fillRectInRoomLayout		; $623b
	ld a,TILEINDEX_CHEST		; $623e
	ld hl,wRoomLayout+$25		; $6240
	ld (hl),a		; $6243
	ld l,$27		; $6244
	ld (hl),a		; $6246
	ld l,$32		; $6247
	ld (hl),TILEINDEX_STANDARD_FLOOR		; $6249
	ret			; $624b
@rect:
	.db $13 $03 $06 TILEINDEX_STANDARD_FLOOR

; D2 - hidden rupee room
tileReplacement_group4Map2e:
	ld hl,wRoomLayout+$23		; $6250
	ld bc,$0808		; $6253
	ld de,wD2RupeeRoomRupees		; $6256
	jp replaceRupeeRoomRupees		; $6259

; D6 - hidden rupee room
tileReplacement_group4Mapbb:
	ld hl,wRoomLayout+$34		; $625c
	ld bc,$0808		; $625f
	ld de,wD6RupeeRoomRupees		; $6262
	jp replaceRupeeRoomRupees		; $6265

; D5 - magnet glove chest
tileReplacement_group4Map89:
	call getThisRoomFlags		; $6268
	bit 5,(hl)		; $626b
	ret z			; $626d
	ld de,@tileReplaceTable		; $626e
	jp replaceTiles		; $6271
@tileReplaceTable:
	.db TILEINDEX_CHEST_OPENED $25
	.db $00

; D8 - top-left screen of huge lava pool room
tileReplacement_group5Map65:
	call getThisRoomFlags		; $6277
	bit 6,(hl)		; $627a
	jr z,+			; $627c
	call d8LavaRoomsReplaceLavaSpewingFace		; $627e
	ld hl,@leftLava		; $6281
	call d8LavaRoomsFillTilesWithLava		; $6284
+
	call getThisRoomFlags		; $6287
	inc l			; $628a
	bit 6,(hl)		; $628b
	ret z			; $628d
	ld hl,@bottomRightLava		; $628e
	jp d8LavaRoomsFillTilesWithLava		; $6291
@leftLava:
	.db $d7
	.db $11                     $17 $18
	.db $21                     $27 $28
	.db $31                     $37
	.db $41 $42 $43 $44 $45 $46 $47
	.db $51 $52 $53     $55
	.db $61 $62     $64     $66 $67 $68
	.db $71 $72 $73 $74 $75 $76 $77
	.db $81 $82 $83 $84 $85 $86 $87
	.db $91 $92     $94 $95 $96
	.db $a1 $a2 $a3 $a4 $a5 $a6
	.db $ff
@bottomRightLava:
	.db $d7
	.db                 $6d $6e
	.db             $7c $7d $7e
	.db     $8a $8b $8c $8d $8e
	.db $99 $9a $9b $9c $9d $9e
	.db $a9 $aa $ab $ac $ad $ae
	.db $ff

; D8 - center-left screen of huge lava pool room
tileReplacement_group5Map67:
	ld a,<ROOM_SEASONS_565		; $62e0
	call getARoomFlags		; $62e2
	bit 6,(hl)		; $62e5
	jr z,+			; $62e7
	ld hl,$630c		; $62e9
	call d8LavaRoomsFillTilesWithLava		; $62ec
+
	ld a,<ROOM_SEASONS_566		; $62ef
	call getARoomFlags		; $62f1
	bit 6,(hl)		; $62f4
	jr z,+			; $62f6
	ld hl,$632d		; $62f8
	call d8LavaRoomsFillTilesWithLava		; $62fb
+
	ld a,<ROOM_SEASONS_56a		; $62fe
	call getARoomFlags		; $6300
	bit 6,(hl)		; $6303
	ret z			; $6305
	ld hl,$6340		; $6306
	jp d8LavaRoomsFillTilesWithLava		; $6309
@topLeftLava:
	.db $d7
	.db $01 $02 $03 $04 $05 $06
	.db $11 $12 $13 $14 $15 $16
	.db $21 $22 $23
	.db $31 $32 $33
	.db $41 $42 $43
	.db $51 $52 $53
	.db $61 $62 $63 $64
	.db $71 $72 $73
	.db $ff
@topRightLava:
	.db $d7
	.db $09 $0a $0b $0c $0d $0e
	.db $19 $1a $1b $1c $1d $1e
	.db     $2a $2b     $2d $2e
	.db                     $3e
	.db $ff
@bottomLava:
	.db $d7
	.db                 $25 $26 $27
	.db                 $35 $36 $37 $38 $39
	.db                 $45 $46 $47 $48 $49
	.db                 $55 $56 $57 $58 $59
	.db                     $66 $67 $68 $69 $6a
	.db                 $75 $76 $77 $78 $79 $7a
	.db $81 $82 $83 $84 $85 $86 $87 $88 $89 $8a $8b
	.db $91 $92 $93 $94 $95 $96 $97 $98 $99 $9a $9b $9c $9d
	.db $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $aa $ab $ac $ad

	.db $ff

; D8 - center-right screen of huge lava pool room
tileReplacement_group5Map68:
	ld a,<ROOM_SEASONS_566		; $6384
	call getARoomFlags		; $6386
	bit 6,(hl)		; $6389
	jr z,+			; $638b
	ld hl,wRoomLayout		; $638d
	ld b,$70		; $6390
	call replaceAllLavaTilesInGivenRange		; $6392
+
	ld a,<ROOM_SEASONS_56b		; $6395
	call getARoomFlags		; $6397
	bit 6,(hl)		; $639a
	ret z			; $639c
	ld hl,wRoomLayout+$70		; $639d
	ld b,$00		; $63a0

; @params	hl	pointer to start of room layout to start replacing lava
; @params	b	YX to stop at
replaceAllLavaTilesInGivenRange:
	ld a,(hl)		; $63a2
	sub TILEINDEX_DUNGEON_LAVA_1			; $63a3
	cp $05			; $63a5
	jr nc,+			; $63a7
	ld (hl),$d7		; $63a9
+
	inc l			; $63ab
	ld a,l			; $63ac
	cp b			; $63ad
	jr nz,replaceAllLavaTilesInGivenRange	; $63ae
	ret			; $63b0

; D8 - top-right, and bottom 2 screens of huge lava pool room
tileReplacement_group5Map66:
tileReplacement_group5Map6a:
tileReplacement_group5Map6b:
	call getThisRoomFlags		; $63b1
	bit 6,(hl)		; $63b4
	ret z			; $63b6
	call d8LavaRoomsReplaceLavaSpewingFace		; $63b7
	ld de,@tileReplaceTable		; $63ba
	jp replaceTiles		; $63bd
@tileReplaceTable:
.REPT 5 INDEX COUNT
	.db $d7 TILEINDEX_DUNGEON_LAVA_1+COUNT
.ENDR
	.db $00

d8LavaRoomsReplaceLavaSpewingFace:
	ld de,@tileReplacetable		; $63cb
	jp replaceTiles		; $63ce
@tileReplacetable:
	.db $d5 $d4 ; shut lava-spewing face
	.db $d7 $67 ; lava waterfall below face
	.db $00

; D8 - ice-block puzzle room, finished puzzle
tileReplacement_group5Map86:
	call getThisRoomFlags		; $63d6
	bit 7,(hl)		; $63d9
	ret z			; $63db
	ld de,@tileReplaceTable		; $63dc
	call replaceTiles		; $63df
	ld hl,wRoomLayout+$4d		; $63e2
	ld a,$2f		; $63e5
	ld (hl),a		; $63e7
	ld l,$5d		; $63e8
	ld (hl),a		; $63ea
	ld l,$6d		; $63eb
	ld (hl),a		; $63ed
	ret			; $63ee
@tileReplaceTable:
	.db $8c $2f
	.db $00

; Ricky screen - replace Ricky with sign
tileReplacement_group0Map54:
	ld a,(wRickyState)		; $63f2
	bit 6,a			; $63f5
	ret z			; $63f7
	ld hl,wRoomLayout+$34		; $63f8
	ld (hl),TILEINDEX_SIGN		; $63fb
	ret			; $63fd

; Holly's house - opening door
tileReplacement_group0Map7f:
	ld a,(wRoomStateModifier)		; $63fe
	cp SEASON_WINTER			; $6401
	ret nz			; $6403
	ld hl,wRoomLayout+$47		; $6404
	ld (hl),$ea		; $6407
	ret			; $6409

; Floodgate-keeper's house - water outside
tileReplacement_group0Map62:
	ld h,>wPastRoomFlags		; $640a
	ld l,<ROOM_SEASONS_2b5		; $640c
	bit 6,(hl)		; $640e
	ret nz			; $6410
	ld hl,@rect		; $6411
	call fillRectInRoomLayout		; $6414
	ld hl,wRoomLayout+$27		; $6417
	ld (hl),TILEINDEX_WATER		; $641a
	ret			; $641c
@rect:
	.db $26 $02 $03 TILEINDEX_PUDDLE

; Inside floodgate-keeper's house
tileReplacement_group2_3Mapb5:
	call getThisRoomFlags	; $6421
	bit 6,(hl)		; $6424
	ret nz			; $6426
	ld hl,wRoomLayout+$37		; $6427
	ld (hl),TILEINDEX_PUDDLE		; $642a
	ret			; $642c

; D3 entrance screen - still flooded
tileReplacement_group0Map60:
	ld a,<ROOM_SEASONS_081		; $642d
	call getARoomFlags		; $642f
	bit 7,(hl)		; $6432
	ret nz			; $6434
	ld hl,@rect1		; $6435
	call fillRectInRoomLayout		; $6438
	ld hl,@rect2		; $643b
	jp fillRectInRoomLayout		; $643e
@rect1:
	.db $24 $06 $03 TILEINDEX_WATER
@rect2:
	.db $47 $04 $03 TILEINDEX_WATER

; Screen right of D3 entrance
tileReplacement_group0Map61:
	ld a,<ROOM_SEASONS_081		; $6449
	call getARoomFlags		; $644b
	bit 7,(hl)		; $644e
	ret nz			; $6450
	ld hl,@rect		; $6451
	jp fillRectInRoomLayout		; $6454
@rect:
	.db $40 $04 $07 TILEINDEX_WATER

; Screen below D3 entrance
tileReplacement_group0Map70:
	ld a,<ROOM_SEASONS_081		; $645b
	call getARoomFlags		; $645d
	bit 7,(hl)		; $6460
	ret nz			; $6462
	ld hl,@rect		; $6463
	jp fillRectInRoomLayout		; $6466
@rect:
	.db $04 $04 $06 TILEINDEX_WATER

; Spool swamp screen with Sokra
tileReplacement_group0Map71:
	ld a,<ROOM_SEASONS_081		; $646d
	call getARoomFlags		; $646f
	bit 7,(hl)		; $6472
	ret nz			; $6474
	ld hl,$6481		; $6475
	call fillRectInRoomLayout		; $6478
	ld hl,$6485		; $647b
	jp fillRectInRoomLayout		; $647e
@rect1:
	.db $00 $04 $07 TILEINDEX_WATER
@rect2:
	.db $44 $04 $03 TILEINDEX_WATER

; Spool swamp screen with keylock
tileReplacement_group0Map81:
	call getThisRoomFlags		; $6489
	bit 7,(hl)		; $648c
	jr nz,+			; $648e
	ld hl,@rect1		; $6490
	jp fillRectInRoomLayout		; $6493
+
	ld hl,@rect3		; $6496
	ld a,(wRoomStateModifier)		; $6499
	cp SEASON_WINTER			; $649c
	jr z,+			; $649e
	ld hl,@rect2		; $64a0
+
	jp fillRectInRoomLayout		; $64a3
@rect1:
	.db $04 $01 $03 TILEINDEX_WATER
@rect2:
	.db $14 $01 $03 TILEINDEX_PUDDLE
@rect3:
	.db $14 $01 $03 $dc

; Screen above D4 entrance
tileReplacement_group0Map0d:
	call getThisRoomFlags		; $64b2
	bit 7,(hl)		; $64b5
	ret nz			; $64b7
	ld hl,@rect		; $64b8
	jp fillRectInRoomLayout		; $64bb
@rect:
	.db $62 $02 $03 TILEINDEX_WATERFALL

; D4 entrance screen
tileReplacement_group0Map1d:
	call getThisRoomFlags		; $64c2
	bit 7,(hl)		; $64c5
	ret nz			; $64c7
	ld hl,@rect		; $64c8
	call fillRectInRoomLayout		; $64cb
	ld l,$13		; $64ce
	ld a,TILEINDEX_WATERFALL_BOTTOM		; $64d0
	ld (hl),a		; $64d2
	ld l,$22		; $64d3
	ldi (hl),a		; $64d5
	ldi (hl),a		; $64d6
	ld (hl),a		; $64d7
	ret			; $64d8
@rect:
	.db $02 $03 $03 TILEINDEX_WATERFALL

	ret			; $64dd

;;
; @param	bc	pointer to table for fillRectInRoomLayout
fillRectIfRoomFlagBit7Set:
	call getThisRoomFlags		; $64de
	bit 7,(hl)		; $64e1
	ret z			; $64e3
	ld h,b			; $64e4
	ld l,c			; $64e5
	jp fillRectInRoomLayout		; $64e6

; D4 B2 room with torches that, when lit, open up a bridge
tileReplacement_group4Map61:
	ld bc,@rect		; $64e9
	jr fillRectIfRoomFlagBit7Set		; $64ec
@rect:
	.db $59 $01 $03 TILEINDEX_HORIZONTAL_BRIDGE

; D7 - screen left of 1st B2 room, with darknuts and unlockable bridge
tileReplacement_group5Map3b:
	ld bc,@rect		; $64f2
	jr fillRectIfRoomFlagBit7Set		; $64f5
@rect:
	.db $77 $01 $04 TILEINDEX_HORIZONTAL_BRIDGE

; D8 - top-right-most room with long bridge unlocked by hitting an orb
tileReplacement_group5Map7a:
	ld bc,@rect		; $64fb
	jr fillRectIfRoomFlagBit7Set		; $64fe
@rect:
	.db $3c $06 $01 TILEINDEX_VERTICAL_BRIDGE

; D8 - HSS-skip bridge
tileReplacement_group5Map78:
	ld bc,@rect		; $6504
	jr fillRectIfRoomFlagBit7Set		; $6507
@rect:
	.db $82 $01 $07 TILEINDEX_HORIZONTAL_BRIDGE

; D8 - 1F bridge that extends into lava
tileReplacement_group5Map8e:
	ld bc,@rect		; $650d
	jr fillRectIfRoomFlagBit7Set		; $6510
@rect:
	.db $1b $07 $01 TILEINDEX_VERTICAL_BRIDGE

; King moblin house
tileReplacement_group0Map6f:
	call getThisRoomFlags	; $6516
	and $c0			; $6519
	ret z			; $651b
	ld de,@ruinedHouse		; $651c
	ld a,GLOBALFLAG_S_12		; $651f
	call checkGlobalFlag		; $6521
	jr nz,++		; $6524
	ld a,(wSeedTreeRefilledBitset)		; $6526
	bit 1,a			; $6529
	jr nz,+			; $652b
	ld de,@destroyedHouse		; $652d
	jr ++			; $6530
+
	ld a,GLOBALFLAG_S_12		; $6532
	call setGlobalFlag		; $6534
++
	ld hl,wRoomLayout+$36		; $6537
	ld b,$03		; $653a
--
	ld c,$03		; $653c
-
	ld a,(de)		; $653e
	inc de			; $653f
	ldi (hl),a		; $6540
	dec c			; $6541
	jr nz,-			; $6542
	ld a,$0d		; $6544
	add l			; $6546
	ld l,a			; $6547
	dec b			; $6548
	jr nz,--		; $6549
	ret			; $654b
@destroyedHouse:
	.db $fd $fd $fc
	.db $fb $fd $fc
	.db $fd $fb $fd
@ruinedHouse:
	.db $a8 $eb $a5
	.db $b3 $b4 $b5
	.db $a3 $ee $a4

; Tarm ruins - statues pushed into water
tileReplacement_group0Map42:
	ld hl,wRoomLayout+$44		; $655e
	ld (hl),$9c		; $6561
	call getThisRoomFlags		; $6563
	and $80			; $6566
	jr z,+			; $6568
	ld hl,wRoomLayout+$55		; $656a
	ld (hl),$bc		; $656d
	jr ++			; $656f
+
	ld hl,wRoomLayout+$54		; $6571
	ld (hl),$d6		; $6574
++
	call getThisRoomFlags		; $6576
	and $40			; $6579
	jr z,+			; $657b
	ld hl,wRoomLayout+$65		; $657d
	ld (hl),$bc		; $6580
	ret			; $6582
+
	ld hl,wRoomLayout+$64		; $6583
	ld (hl),$d6		; $6586
	ret			; $6588

; Pirate door into samasa desert
tileReplacement_group0Mapfc:
	call getThisRoomFlags		; $6589
	bit 7,(hl)		; $658c
	ret z			; $658e
	ld hl,wRoomLayout+$03		; $658f
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

checkPirateShipDocked:
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED		; $65a2
	jp checkGlobalFlag		; $65a4

; Top screen of pirate ship in Subrosia
tileReplacement_group1Map64:
	call checkPirateShipDocked		; $65a7
	ret z			; $65aa
	ld hl,@rect		; $65ab
	jp fillRectInRoomLayout		; $65ae
@rect:
	.db $44 $04 $05 $0f

; Bottom screen of pirate ship in Subrosia
tileReplacement_group1Map74:
	call checkPirateShipDocked		; $65b5
	ret z			; $65b8
	ld hl,@rect		; $65b9
	jp fillRectInRoomLayout		; $65bc
@rect:
	.db $04 $04 $05 $0f

; Pirate ship screen in samasa desert - turns ship into quicksand rect
tileReplacement_group0Mapee:
	call checkPirateShipDocked		; $65c3
	ret z			; $65c6
	ld hl,@sandRect		; $65c7
	ld de,wRoomLayout+$23		; $65ca
	ld bc,$0505		; $65cd
--
	push de			; $65d0
	push bc			; $65d1
-
	ldi a,(hl)		; $65d2
	ld (de),a		; $65d3
	inc e			; $65d4
	dec b			; $65d5
	jr nz,-			; $65d6
	pop bc			; $65d8
	pop de			; $65d9
	ld a,e			; $65da
	add $10			; $65db
	ld e,a			; $65dd
	dec c			; $65de
	jr nz,--		; $65df
	ret			; $65e1
@sandRect:
	.db $af $af $af $af $af
	.db $ad $ad $ae $ae $af
	.db $ad $ad $ae $ae $af
	.db $bd $bd $be $be $af
	.db $bd $bd $be $be $af

; Screen with linked locked doors in Subrosia
tileReplacement_group1Map35:
	ld a,(wGroup4Flags|<ROOM_SEASONS_4f9)		; $65fb
	and $04			; $65fe
	ret z			; $6600
	ld hl,wRoomLayout+$43		; $6601
	ld (hl),TILEINDEX_OPEN_CAVE_DOOR		; $6604
	ret			; $6606

; Big bridge into Natzu
tileReplacement_group0Map56:
	xor a			; $6607
	ld (wSwitchState),a		; $6608
	ld a,(wAnimalCompanion)		; $660b
	cp SPECIALOBJECTID_DIMITRI			; $660e
	ret z			; $6610

	call getThisRoomFlags		; $6611
	and $40			; $6614
	jr nz,+			; $6616
	ld a,TILEINDEX_WATER		; $6618
	ld hl,wRoomLayout+$43		; $661a
	ldi (hl),a		; $661d
	ld (hl),a		; $661e
	ld hl,wRoomLayout+$53		; $661f
	ldi (hl),a		; $6622
	ld (hl),a		; $6623
	ret			; $6624
+
	ld a,$b0		; $6625
	ld (wRoomLayout+$66),a		; $6627
	ret			; $662a

; Moblin keep roof - remove when destroyed
tileReplacement_group0Map4b:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED		; $662b
	call checkGlobalFlag		; $662d
	ret z			; $6630
	ld hl,wRoomLayout+$73		; $6631
	ld a,$40		; $6634
	ldi (hl),a		; $6636
	ldi (hl),a		; $6637
	ld (hl),a		; $6638
	ret			; $6639

;;
; Twinrova/ganon fight - same as ages
tileReplacement_group5Map9e:
	ld a,(wTwinrovaTileReplacementMode)		; $663a
	or a			; $663d
	ret z			; $663e
	dec a			; $663f
	jr z,@val01	; $6640
	dec a			; $6642
	jr z,@fillWithIce	; $6643
	dec a			; $6645
	jr z,@val03	; $6646

	; Fill the room with the seizure tiles?
	xor a			; $6648
	ld (wTwinrovaTileReplacementMode),a		; $6649
	ld hl,@seizureTiles		; $664c
	jp fillRectInRoomLayout		; $664f

@seizureTiles:
	.db $00 LARGE_ROOM_HEIGHT LARGE_ROOM_WIDTH $aa

@val03:
	ld (wTwinrovaTileReplacementMode),a		; $6656
	ld a,$b9		; $6659
	jp loadGfxHeader		; $665b

@fillWithIce:
	ld (wTwinrovaTileReplacementMode),a		; $665e
	ld hl,@iceTiles		; $6661
	jp fillRectInRoomLayout		; $6664

@iceTiles:
	.db $11 LARGE_ROOM_HEIGHT-2 LARGE_ROOM_WIDTH-2 $8c

@val01:
	ld (wTwinrovaTileReplacementMode),a		; $666b
	ld a,$b8		; $666e
	jp loadGfxHeader		; $6670

; Down horon village stairs leading to Subrosia portal
tileReplacement_group2_3Mapab:
	call getThisRoomFlags		; $6673
	and $40			; $6676
	ret z			; $6678
	ld hl,wRoomLayout+$14		; $6679
	ld a,TILEINDEX_HORIZONTAL_BRIDGE		; $667c
	ldi (hl),a		; $667e
	ldi (hl),a		; $667f
	ld (hl),a		; $6680
	ld a,TILEINDEX_VERTICAL_BRIDGE		; $6681
	ld l,$47		; $6683
	ld (hl),a		; $6685
	ld l,$37		; $6686
	ld (hl),a		; $6688
	ld l,$27		; $6689
	ld (hl),a		; $668b
	ld l,$17		; $668c
	ld (hl),a		; $668e
	ret			; $668f

;;
; @param	hl	pointer to data structure
;			* starts with tile to replace with
;			* fills every YX specified until $ff found
d8LavaRoomsFillTilesWithLava:
	ld d,$cf		; $6690
	ldi a,(hl)		; $6692
	ld c,a			; $6693
-
	ldi a,(hl)		; $6694
	cp $ff			; $6695
	ret z			; $6697
	ld e,a			; $6698
	ld a,c			; $6699
	ld (de),a		; $669a
	jr -			; $669b
