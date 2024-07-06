applyRoomSpecificTileChanges:
	ld a,(wActiveRoom)
	ld hl,roomTileChangerCodeGroupTable
	call findRoomSpecificData
	ret nc
	rst_jumpTable
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
	.db $00

	ret

; Adds a sign outside couple's house
tileReplacement_group0Mapf6:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ret z
	ld hl,wRoomLayout+$33
	ld (hl),TILEINDEX_SIGN
	ret

; Open GBA shop
tileReplacement_group0Mapc5:
	ldh a,(<hGameboyType)
	rlca
	ret nc
	ld hl,wRoomLayout+$14
	ld (hl),$ea
	ret

; Open Maku tree gates
tileReplacement_group0Mapd9:
	call getThisRoomFlags
	bit 7,(hl)
	ret z
	ld hl,wRoomLayout+$14
	ld a,$bf
	ldi (hl),a
	ld (hl),a
	ld l,$24
	ld a,$a9
	ldi (hl),a
	inc a
	ld (hl),a
	ret

; Open Tarm gates
tileReplacement_group0Map63:
	call getThisRoomFlags
	bit 7,(hl)
	ret z
	ld hl,wRoomLayout+$14
	ld a,$ad
	ldi (hl),a
	ld (hl),a
	ld l,$24
	ldi (hl),a
	ld (hl),a
	ret

; Mr. Write's house - lit torch
tileReplacement_group2_3Mapa4:
	call getThisRoomFlags
	and $40
	ret z
	ld hl,wRoomLayout+$36
	ld (hl),TILEINDEX_LIT_TORCH
	ret

; Bridge to moldorm guarding jewel
tileReplacement_group0Mape4:
	call getThisRoomFlags
	and $40
	jr z,+
	ld hl,wRoomLayout+$77
	ld (hl),TILEINDEX_OVERWORLD_LIT_TORCH
	ret
+
	ld hl,@table_group0Mape4
	ld d,$cf
-
	ldi a,(hl)
	or a
	ret z
	ld e,a
	ldi a,(hl)
	ld (de),a
	inc e
	ld (de),a
	jr -
@table_group0Mape4:
	.db $65 TILEINDEX_WATER
	.db $75 TILEINDEX_WATER
	.db $00

; Moldorm guarding jewel
tileReplacement_group0Mapf4:
	call getThisRoomFlags
	bit 6,(hl)
	ret z
	bit 5,(hl)
	jr nz,+
	ld hl,wRoomLayout+$45
	ld (hl),$f1
+
	ld hl,wRoomLayout+$22
	ld (hl),$0f
	inc l
	ld (hl),$11
	ld l,$32
	ld (hl),$11
	inc l
	ld (hl),$0f
	inc l
	ld (hl),$11
	ret

; D4 - 1F stairs leading to 2-tile pits to stairs to B1
tileReplacement_group4Map78:
	call getThisRoomFlags
	bit 7,(hl)
	ret nz
	ld hl,wRoomLayout+$39
	ld (hl),$b0
	ret

; D4 - 3-torch room while on minecart
tileReplacement_group4Map64:
	call getThisRoomFlags
	bit 7,(hl)
	ret z
	ld de,@tileReplaceTable
	jp replaceTiles
@tileReplaceTable:
	.db TILEINDEX_LIT_TORCH TILEINDEX_UNLIT_TORCH
	.db $00

; Member's shop - unlocking chest gambling game
tileReplacement_group2_3Mapb0:
	ld a,(wBoughtShopItems1)
	and $0f
	cp $0f
	ret nz

	ld hl,@rect
	call fillRectInRoomLayout
	ld a,TILEINDEX_CHEST
	ld hl,wRoomLayout+$25
	ld (hl),a
	ld l,$27
	ld (hl),a
	ld l,$32
	ld (hl),TILEINDEX_STANDARD_FLOOR
	ret
@rect:
	.db $13 $03 $06 TILEINDEX_STANDARD_FLOOR

; D2 - hidden rupee room
tileReplacement_group4Map2e:
	ld hl,wRoomLayout+$23
	ld bc,$0808
	ld de,wD2RupeeRoomRupees
	jp replaceRupeeRoomRupees

; D6 - hidden rupee room
tileReplacement_group4Mapbb:
	ld hl,wRoomLayout+$34
	ld bc,$0808
	ld de,wD6RupeeRoomRupees
	jp replaceRupeeRoomRupees

; D5 - magnet glove chest
tileReplacement_group4Map89:
	call getThisRoomFlags
	bit 5,(hl)
	ret z
	ld de,@tileReplaceTable
	jp replaceTiles
@tileReplaceTable:
	.db TILEINDEX_CHEST_OPENED $25
	.db $00

; D8 - top-left screen of huge lava pool room
tileReplacement_group5Map65:
	call getThisRoomFlags
	bit 6,(hl)
	jr z,+
	call d8LavaRoomsReplaceLavaSpewingFace
	ld hl,@leftLava
	call d8LavaRoomsFillTilesWithLava
+
	call getThisRoomFlags
	inc l
	bit 6,(hl)
	ret z
	ld hl,@bottomRightLava
	jp d8LavaRoomsFillTilesWithLava
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
	ld a,<ROOM_SEASONS_565
	call getARoomFlags
	bit 6,(hl)
	jr z,+
	ld hl,@topLeftLava
	call d8LavaRoomsFillTilesWithLava
+
	ld a,<ROOM_SEASONS_566
	call getARoomFlags
	bit 6,(hl)
	jr z,+
	ld hl,@topRightLava
	call d8LavaRoomsFillTilesWithLava
+
	ld a,<ROOM_SEASONS_56a
	call getARoomFlags
	bit 6,(hl)
	ret z
	ld hl,@bottomLava
	jp d8LavaRoomsFillTilesWithLava
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
	ld a,<ROOM_SEASONS_566
	call getARoomFlags
	bit 6,(hl)
	jr z,+
	ld hl,wRoomLayout
	ld b,$70
	call replaceAllLavaTilesInGivenRange
+
	ld a,<ROOM_SEASONS_56b
	call getARoomFlags
	bit 6,(hl)
	ret z
	ld hl,wRoomLayout+$70
	ld b,$00

; @params	hl	pointer to start of room layout to start replacing lava
; @params	b	YX to stop at
replaceAllLavaTilesInGivenRange:
	ld a,(hl)
	sub TILEINDEX_DUNGEON_LAVA_1
	cp $05
	jr nc,+
	ld (hl),$d7
+
	inc l
	ld a,l
	cp b
	jr nz,replaceAllLavaTilesInGivenRange
	ret

; D8 - top-right, and bottom 2 screens of huge lava pool room
tileReplacement_group5Map66:
tileReplacement_group5Map6a:
tileReplacement_group5Map6b:
	call getThisRoomFlags
	bit 6,(hl)
	ret z
	call d8LavaRoomsReplaceLavaSpewingFace
	ld de,@tileReplaceTable
	jp replaceTiles
@tileReplaceTable:
.REPT 5 INDEX COUNT
	.db $d7 TILEINDEX_DUNGEON_LAVA_1+COUNT
.ENDR
	.db $00

d8LavaRoomsReplaceLavaSpewingFace:
	ld de,@tileReplacetable
	jp replaceTiles
@tileReplacetable:
	.db $d5 $d4 ; shut lava-spewing face
	.db $d7 $67 ; lava waterfall below face
	.db $00

; D8 - ice-block puzzle room, finished puzzle
tileReplacement_group5Map86:
	call getThisRoomFlags
	bit 7,(hl)
	ret z
	ld de,@tileReplaceTable
	call replaceTiles
	ld hl,wRoomLayout+$4d
	ld a,$2f
	ld (hl),a
	ld l,$5d
	ld (hl),a
	ld l,$6d
	ld (hl),a
	ret
@tileReplaceTable:
	.db $8c $2f
	.db $00

; Ricky screen - replace Ricky with sign
tileReplacement_group0Map54:
	ld a,(wRickyState)
	bit 6,a
	ret z
	ld hl,wRoomLayout+$34
	ld (hl),TILEINDEX_SIGN
	ret

; Holly's house - opening door
tileReplacement_group0Map7f:
	ld a,(wRoomStateModifier)
	cp SEASON_WINTER
	ret nz
	ld hl,wRoomLayout+$47
	ld (hl),$ea
	ret

; Floodgate-keeper's house - water outside
tileReplacement_group0Map62:
	ld h,>wSubrosiaRoomFlags
	ld l,<ROOM_SEASONS_2b5
	bit 6,(hl)
	ret nz
	ld hl,@rect
	call fillRectInRoomLayout
	ld hl,wRoomLayout+$27
	ld (hl),TILEINDEX_WATER
	ret
@rect:
	.db $26 $02 $03 TILEINDEX_PUDDLE

; Inside floodgate-keeper's house
tileReplacement_group2_3Mapb5:
	call getThisRoomFlags
	bit 6,(hl)
	ret nz
	ld hl,wRoomLayout+$37
	ld (hl),TILEINDEX_PUDDLE
	ret

; D3 entrance screen - still flooded
tileReplacement_group0Map60:
	ld a,<ROOM_SEASONS_081
	call getARoomFlags
	bit 7,(hl)
	ret nz
	ld hl,@rect1
	call fillRectInRoomLayout
	ld hl,@rect2
	jp fillRectInRoomLayout
@rect1:
	.db $24 $06 $03 TILEINDEX_WATER
@rect2:
	.db $47 $04 $03 TILEINDEX_WATER

; Screen right of D3 entrance
tileReplacement_group0Map61:
	ld a,<ROOM_SEASONS_081
	call getARoomFlags
	bit 7,(hl)
	ret nz
	ld hl,@rect
	jp fillRectInRoomLayout
@rect:
	.db $40 $04 $07 TILEINDEX_WATER

; Screen below D3 entrance
tileReplacement_group0Map70:
	ld a,<ROOM_SEASONS_081
	call getARoomFlags
	bit 7,(hl)
	ret nz
	ld hl,@rect
	jp fillRectInRoomLayout
@rect:
	.db $04 $04 $06 TILEINDEX_WATER

; Spool swamp screen with Sokra
tileReplacement_group0Map71:
	ld a,<ROOM_SEASONS_081
	call getARoomFlags
	bit 7,(hl)
	ret nz
	ld hl,@rect1
	call fillRectInRoomLayout
	ld hl,@rect2
	jp fillRectInRoomLayout
@rect1:
	.db $00 $04 $07 TILEINDEX_WATER
@rect2:
	.db $44 $04 $03 TILEINDEX_WATER

; Spool swamp screen with keylock
tileReplacement_group0Map81:
	call getThisRoomFlags
	bit 7,(hl)
	jr nz,+
	ld hl,@rect1
	jp fillRectInRoomLayout
+
	ld hl,@rect3
	ld a,(wRoomStateModifier)
	cp SEASON_WINTER
	jr z,+
	ld hl,@rect2
+
	jp fillRectInRoomLayout
@rect1:
	.db $04 $01 $03 TILEINDEX_WATER
@rect2:
	.db $14 $01 $03 TILEINDEX_PUDDLE
@rect3:
	.db $14 $01 $03 $dc

; Screen above D4 entrance
tileReplacement_group0Map0d:
	call getThisRoomFlags
	bit 7,(hl)
	ret nz
	ld hl,@rect
	jp fillRectInRoomLayout
@rect:
	.db $62 $02 $03 TILEINDEX_WATERFALL

; D4 entrance screen
tileReplacement_group0Map1d:
	call getThisRoomFlags
	bit 7,(hl)
	ret nz
	ld hl,@rect
	call fillRectInRoomLayout
	ld l,$13
	ld a,TILEINDEX_WATERFALL_BOTTOM
	ld (hl),a
	ld l,$22
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ret
@rect:
	.db $02 $03 $03 TILEINDEX_WATERFALL

	ret

;;
; @param	bc	pointer to table for fillRectInRoomLayout
fillRectIfRoomFlagBit7Set:
	call getThisRoomFlags
	bit 7,(hl)
	ret z
	ld h,b
	ld l,c
	jp fillRectInRoomLayout

; D4 B2 room with torches that, when lit, open up a bridge
tileReplacement_group4Map61:
	ld bc,@rect
	jr fillRectIfRoomFlagBit7Set
@rect:
	.db $59 $01 $03 TILEINDEX_HORIZONTAL_BRIDGE

; D7 - screen left of 1st B2 room, with darknuts and unlockable bridge
tileReplacement_group5Map3b:
	ld bc,@rect
	jr fillRectIfRoomFlagBit7Set
@rect:
	.db $77 $01 $04 TILEINDEX_HORIZONTAL_BRIDGE

; D8 - top-right-most room with long bridge unlocked by hitting an orb
tileReplacement_group5Map7a:
	ld bc,@rect
	jr fillRectIfRoomFlagBit7Set
@rect:
	.db $3c $06 $01 TILEINDEX_VERTICAL_BRIDGE

; D8 - HSS-skip bridge
tileReplacement_group5Map78:
	ld bc,@rect
	jr fillRectIfRoomFlagBit7Set
@rect:
	.db $82 $01 $07 TILEINDEX_HORIZONTAL_BRIDGE

; D8 - 1F bridge that extends into lava
tileReplacement_group5Map8e:
	ld bc,@rect
	jr fillRectIfRoomFlagBit7Set
@rect:
	.db $1b $07 $01 TILEINDEX_VERTICAL_BRIDGE

; King moblin house
tileReplacement_group0Map6f:
	call getThisRoomFlags
	and $c0
	ret z
	ld de,@ruinedHouse
	ld a,GLOBALFLAG_DESTROYED_MOBLIN_HOUSE_REPAIRED
	call checkGlobalFlag
	jr nz,++
	ld a,(wSeedTreeRefilledBitset)
	bit 1,a
	jr nz,+
	ld de,@destroyedHouse
	jr ++
+
	ld a,GLOBALFLAG_DESTROYED_MOBLIN_HOUSE_REPAIRED
	call setGlobalFlag
++
	ld hl,wRoomLayout+$36
	ld b,$03
--
	ld c,$03
-
	ld a,(de)
	inc de
	ldi (hl),a
	dec c
	jr nz,-
	ld a,$0d
	add l
	ld l,a
	dec b
	jr nz,--
	ret
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
	ld hl,wRoomLayout+$44
	ld (hl),$9c
	call getThisRoomFlags
	and $80
	jr z,+
	ld hl,wRoomLayout+$55
	ld (hl),$bc
	jr ++
+
	ld hl,wRoomLayout+$54
	ld (hl),$d6
++
	call getThisRoomFlags
	and $40
	jr z,+
	ld hl,wRoomLayout+$65
	ld (hl),$bc
	ret
+
	ld hl,wRoomLayout+$64
	ld (hl),$d6
	ret

; Pirate door into samasa desert
tileReplacement_group0Mapfc:
	call getThisRoomFlags
	bit 7,(hl)
	ret z
	ld hl,wRoomLayout+$03
	ld a,$af
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld a,$0d
	rst_addAToHl
	ld a,$af
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ret

checkPirateShipDocked:
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	jp checkGlobalFlag

; Top screen of pirate ship in Subrosia
tileReplacement_group1Map64:
	call checkPirateShipDocked
	ret z
	ld hl,@rect
	jp fillRectInRoomLayout
@rect:
	.db $44 $04 $05 $0f

; Bottom screen of pirate ship in Subrosia
tileReplacement_group1Map74:
	call checkPirateShipDocked
	ret z
	ld hl,@rect
	jp fillRectInRoomLayout
@rect:
	.db $04 $04 $05 $0f

; Pirate ship screen in samasa desert - turns ship into quicksand rect
tileReplacement_group0Mapee:
	call checkPirateShipDocked
	ret z
	ld hl,@sandRect
	ld de,wRoomLayout+$23
	ld bc,$0505
--
	push de
	push bc
-
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,-
	pop bc
	pop de
	ld a,e
	add $10
	ld e,a
	dec c
	jr nz,--
	ret
@sandRect:
	.db $af $af $af $af $af
	.db $ad $ad $ae $ae $af
	.db $ad $ad $ae $ae $af
	.db $bd $bd $be $be $af
	.db $bd $bd $be $be $af

; Screen with linked locked doors in Subrosia
tileReplacement_group1Map35:
	ld a,(wGroup4RoomFlags|<ROOM_SEASONS_4f9)
	and $04
	ret z
	ld hl,wRoomLayout+$43
	ld (hl),TILEINDEX_OPEN_CAVE_DOOR
	ret

; Big bridge into Natzu
tileReplacement_group0Map56:
	xor a
	ld (wSwitchState),a
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECT_DIMITRI
	ret z

	call getThisRoomFlags
	and $40
	jr nz,+
	ld a,TILEINDEX_WATER
	ld hl,wRoomLayout+$43
	ldi (hl),a
	ld (hl),a
	ld hl,wRoomLayout+$53
	ldi (hl),a
	ld (hl),a
	ret
+
	ld a,$b0
	ld (wRoomLayout+$66),a
	ret

; Moblin keep roof - remove when destroyed
tileReplacement_group0Map4b:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	ret z
	ld hl,wRoomLayout+$73
	ld a,$40
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ret

;;
; Twinrova/ganon fight - same as ages
tileReplacement_group5Map9e:
	ld a,(wTwinrovaTileReplacementMode)
	or a
	ret z
	dec a
	jr z,@fillWithLava
	dec a
	jr z,@fillWithIce
	dec a
	jr z,@normalLayout

	; Fill the room with the seizure tiles?
	xor a
	ld (wTwinrovaTileReplacementMode),a
	ld hl,@seizureTiles
	jp fillRectInRoomLayout

@seizureTiles:
	.db $00, LARGE_ROOM_HEIGHT, LARGE_ROOM_WIDTH, $aa

@normalLayout:
	ld (wTwinrovaTileReplacementMode),a
	ld a,GFXH_TWINROVA_NORMAL_LAYOUT
	jp loadGfxHeader

@fillWithIce:
	ld (wTwinrovaTileReplacementMode),a
	ld hl,@iceTiles
	jp fillRectInRoomLayout

@iceTiles:
	.db $11, LARGE_ROOM_HEIGHT-2, LARGE_ROOM_WIDTH-2, $8c

@fillWithLava:
	ld (wTwinrovaTileReplacementMode),a
	ld a,GFXH_TWINROVA_LAVA_LAYOUT
	jp loadGfxHeader

; Down horon village stairs leading to Subrosia portal
tileReplacement_group2_3Mapab:
	call getThisRoomFlags
	and $40
	ret z
	ld hl,wRoomLayout+$14
	ld a,TILEINDEX_HORIZONTAL_BRIDGE
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld a,TILEINDEX_VERTICAL_BRIDGE
	ld l,$47
	ld (hl),a
	ld l,$37
	ld (hl),a
	ld l,$27
	ld (hl),a
	ld l,$17
	ld (hl),a
	ret

;;
; @param	hl	pointer to data structure
;			* starts with tile to replace with
;			* fills every YX specified until $ff found
d8LavaRoomsFillTilesWithLava:
	ld d,$cf
	ldi a,(hl)
	ld c,a
-
	ldi a,(hl)
	cp $ff
	ret z
	ld e,a
	ld a,c
	ld (de),a
	jr -

;;
; Fills a square in wRoomLayout using the data at hl.
; Data format:
; - Top-left position (YX)
; - Height
; - Width
; - Tile value
fillRectInRoomLayout:
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld d,a
	ld h,>wRoomLayout
--
	ld a,d
	ld l,e
	push bc
-
	ldi (hl),a
	dec c
	jr nz,-
	ld a,e
	add $10
	ld e,a
	pop bc
	dec b
	jr nz,--
	ret

;;
; @param	bc	$0808
; @param	de	$c8f0 - d2 rupee room, $c8f8 - d6 rupee room
; @param	hl	top-left tile of rupees
replaceRupeeRoomRupees:
	ld a,(de)
	inc de
	push bc
-
	rrca
	jr nc,+
	ld (hl),TILEINDEX_STANDARD_FLOOR
+
	inc l
	dec b
	jr nz,-
	ld a,l
	add $08
	ld l,a
	pop bc
	dec c
	jr nz,replaceRupeeRoomRupees
	ret
