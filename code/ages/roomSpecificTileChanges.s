;;
applyRoomSpecificTileChanges:
	ld a,(wActiveRoom)
	ld hl,roomTileChangerCodeGroupTable
	call findRoomSpecificData
	ret nc
	rst_jumpTable
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
roomTileChangerCodeGroup1Data:
	.db $38 $09
	.db $27 $28
	.db $8c $2c
	.db $58 $34
	.db $00
roomTileChangerCodeGroup2Data:
	.db $f7 $15
	.db $90 $2b
	.db $9e $2f
	.db $7e $02
	.db $00
roomTileChangerCodeGroup3Data:
	.db $00
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
roomTileChangerCodeGroup6Data:
	.db $00
roomTileChangerCodeGroup7Data:
	.db $4a $11
	.db $00

;;
; Opens advance shop
tileReplacement_group1Map58:
	ldh a,(<hGameboyType)
	rlca
	ret nc
	ld hl,wRoomLayout + $35
	ld (hl),$de
	ret

;;
; Twinrova/ganon fight
tileReplacement_group5Mapf5:
	ld a,(wTwinrovaTileReplacementMode)
	or a
	ret z
	dec a
	jr z,@val01
	dec a
	jr z,@fillWithIce
	dec a
	jr z,@val03

	; Fill the room with the seizure tiles?
	xor a
	ld (wTwinrovaTileReplacementMode),a
	ld hl,@seizureTiles
	jp fillRectInRoomLayout

@seizureTiles:
	.db $00, LARGE_ROOM_HEIGHT, LARGE_ROOM_WIDTH, $aa

@val03:
	ld (wTwinrovaTileReplacementMode),a
	ld a,GFXH_b9
	jp loadGfxHeader

@fillWithIce:
	ld (wTwinrovaTileReplacementMode),a
	ld hl,@iceTiles
	jp fillRectInRoomLayout

@iceTiles:
	.db $11, LARGE_ROOM_HEIGHT-2, LARGE_ROOM_WIDTH-2, $8a

@val01:
	ld (wTwinrovaTileReplacementMode),a
	ld a,GFXH_b8
	jp loadGfxHeader

;;
; Dungeon 1 in the room where torches light up to make stairs appear
tileReplacement_group4Map1b:
	call getThisRoomFlags
	and $80
	ret z

	ld hl,wRoomLayout + $1a
	ld a,TILEINDEX_LIT_TORCH
	ldi (hl),a
	inc l
	ld (hl),a

	; The programmers forgot a "ret" here! This causes a bug where chests
	; are inserted into dungeon 1 after buying everything from the secret
	; shop.

;;
; Secret shop: replace item area with blank floor and 2 chests, if you've
; already bought everything.
tileReplacement_group2Map7e:
	ld a,(wBoughtShopItems1)
	and $0f
	cp $0f
	ret nz

	ld hl,@data
	call fillRectInRoomLayout
	ld a,TILEINDEX_CHEST
	ld hl,wRoomLayout + $25
	ld (hl),a
	ld l,$27
	ld (hl),a
	ld l,$32
	ld (hl),$a0
	ret

@data:
	.db $13 $03 $06 $a0

;;
; Hero's cave: make a bridge appear
tileReplacement_group4Mapc9:
	call getThisRoomFlags
	and ROOMFLAG_40
	ret z

	ld hl,wRoomLayout + $27
	ld a,$6d
	jp set4Bytes

;;
; Hero's cave: make a bridge appear, make another disappear if a switch is set
tileReplacement_group4Mapc7:
	ld hl,wSwitchState
	bit 0,(hl)
	ret nz

	ld hl,wRoomLayout + $27
	ld a,$6d
	call set4Bytes
	ld a,$f4
	ld l,$3d
	ld (hl),a
	ld l,$4d
	ld (hl),a
	ld l,$5d
	ld (hl),a
	ld l,$6d
	ld (hl),a
	ret

;;
; D3, left of miniboss: deal with bridges
tileReplacement_group4Map4c:
	ld hl,wSwitchState
	bit 0,(hl)
	ret nz

	ld hl,wRoomLayout + $43
	ld a,$6a
	ld (hl),a
	ld l,$53
	ld (hl),a
	ld l,$63
	ld (hl),a
	ld l,$76
	ld a,$f4
	jp set4Bytes

;;
; D3, left, down from miniboss: deal with bridges
tileReplacement_group4Map4e:
	ld hl,wSwitchState
	bit 1,(hl)
	ret z

	ld hl,wRoomLayout + $36
	ld a,$6d
	call set4Bytes
	ld a,$f4
	ld l,$42
	ld (hl),a
	ld l,$52
	ld (hl),a
	ld l,$62
	ld (hl),a
	ld l,$4c
	ld (hl),a
	ld l,$5c
	ld (hl),a
	ld l,$6c
	ld (hl),a
	ret

;;
; D3, right of seed shooter room: set torch lit
tileReplacement_group4Map59:
	call getThisRoomFlags
	and $80
	ret z

	ld de,@replacementTiles
	jp replaceTiles

@replacementTiles:
	.db $09 $08 ; Replace unlit torch with lit
	.db $00

;;
; D3, upper spinner room: remove spinner if crystals broken (doesn't remove
; interaction itself)
tileReplacement_group4Map60:
	ld a,GLOBALFLAG_D3_CRYSTALS
	call checkGlobalFlag
	ret z

	ld hl,@rect
	call fillRectInRoomLayout
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	ld a,TILEINDEX_CHEST_OPENED
	jr nz,+
	inc a
+
	ld hl,wRoomLayout + $57
	ld (hl),a
	ld l,$34
	ld (hl),$1d
	ld l,$3a
	ld (hl),$1d
	ld l,$74
	ld (hl),$1d
	ld l,$7a
	ld (hl),$1d
	ret
@rect:
	.db $34 $05 $07 $a0

;;
; D3, lower spinner room: add spinner if crystals broken (doesn't add
; interaction itself)
tileReplacement_group4Map52:
	ld a,GLOBALFLAG_D3_CRYSTALS
	call checkGlobalFlag
	ret z

	; Load the room above instead of this room
	ld a,$60
	ld (wLoadingRoom),a
	callab loadRoomLayout
	ret

;;
; Maku tree present
tileReplacement_group0Map38:
	ld a,GLOBALFLAG_MAKU_TREE_SAVED
	call checkGlobalFlag
	ret z
	jr +
;;
; Maku tree past
tileReplacement_group1Map38:
	call getThisRoomFlags
	bit 7,(hl)
	ret z
+
	; Clear barrier
	ld hl,wRoomLayout + $73
	ld a,$f9
	jp set4Bytes

;;
; Present: Screen below maku tree
tileReplacement_group0Map48:
	ld a,GLOBALFLAG_MAKU_TREE_SAVED
	call checkGlobalFlag
	ret z

	; Clear barrier
	ld hl,wRoomLayout + $03
	ld a,$3a
	jp set4Bytes

;;
; D6 before boss room: create bridge
tileReplacement_group5Map38:
	call getThisRoomFlags
	and ROOMFLAG_40
	ret z

	ld a,$6a
	ld hl,wRoomLayout + $39
	ld (hl),a
	ld l,$49
	ld (hl),a
	ld l,$59
	ld (hl),a
	ld l,$69
	ld (hl),a
	ret

;;
; D6 present: screen with retracting wall
tileReplacement_group5Map25:
	call getThisRoomFlags
	and $40
	ret nz

	ld hl,d6RetractingWallRectPresent
	call fillRectInRoomLayout
	jr ++

d6RetractingWallRectPresent:
	.db $17 $09 $04 $a6
d6RetractingWallRectPast:
	.db $17 $09 $04 $a7

;;
; D6 past: screen with retracting walls
tileReplacement_group5Map43:
	call getThisRoomFlags
	and $40
	jr nz,@pastRetracted

	ld hl,d6RetractingWallRectPast
	call fillRectInRoomLayout
++
	ld hl,@wallEdge1
	call fillRectInRoomLayout
	ld hl,@wallEdge2
	jp fillRectInRoomLayout

@wallEdge1:
	.db $1b $09 $01 $b3

@wallEdge2:
	.db $16 $09 $01 $b1

; Light the torches.
@pastRetracted:
	ld de,@tilesToReplace
	jp replaceTiles

@tilesToReplace:
	.db $09 $08 ; Replace unlit torch with lit
	.db $00

;;
; D8: room with retracting wall
tileReplacement_group5Map95:
	call getThisRoomFlags
	and $40
	ret nz

	ld hl,wRoomLayout + $4d
	ld (hl),$b4
	inc l
	ld (hl),$b2
	ld hl,@wallInterior
	call fillRectInRoomLayout
	ld hl,@wallEdge
	jp fillRectInRoomLayout

@wallInterior:
	.db $5e $05 $01 $a7
@wallEdge:
	.db $5d $05 $01 $b1

;;
; Past: cave with goron elder
; Gets rid of a boulder and creates a shortcut
tileReplacement_group5Mapc3:
	call @func_04_672e
	call getThisRoomFlags
	and ROOMFLAG_40
	ret z

	ld bc,@boulderReplacementTiles
	ld hl,wRoomLayout + $31
	call @locFunc
	ld l,$41
	call @locFunc
	ld l,$51
@locFunc:
	ld a,$05
--
	ldh (<hFF8D),a
	ld a,(bc)
	inc bc
	ldi (hl),a
	ldh a,(<hFF8D)
	dec a
	jr nz,--
	ret

@boulderReplacementTiles:
	.db $a2 $a1 $a2 $a1 $a2
	.db $a1 $a2 $a1 $a2 $a1
	.db $a2 $a1 $a2 $a1 $a2


;;
; If d5 is beaten, remove a wall to make the area easier to traverse. (This
; does not remove the boulder)
@func_04_672e:
	ld a,$04
	ld hl,wEssencesObtained
	call checkFlag
	ret z

	ld hl,@newTiles
	ld bc,wRoomLayout + $06
	ld a,$04
---
	ldh (<hFF8D),a
	ld a,$04
--
	ldh (<hFF8C),a
	ldi a,(hl)
	or a
	jr z,+
	ld (bc),a
+
	inc bc
	ldh a,(<hFF8C)
	dec a
	jr nz,--

	ld a,$0c
	call addAToBc
	ldh a,(<hFF8D)
	dec a
	jr nz,---
	ret

; 4x4 grid of new tiles to insert ($00 means unchanged).
@newTiles:
	.db $b0 $b0 $b0 $b0
	.db $ef $00 $00 $ef
	.db $ef $00 $00 $ef
	.db $b4 $b2 $b2 $b2

;;
; Past: cave in goron mountain with 2 chests
tileReplacement_group2Mapf7:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_ITEM,(hl)
	jr z,++

	ld a,TILEINDEX_CHEST_OPENED
	ld c,$14
	call setTile
	ld a,TILEINDEX_CHEST_OPENED
	ld c,$16
	jp setTile
++
	ld a,(hl)
	and $c0
	cp $c0
	ret z

	bit 6,(hl)
	jr z,+

	ld a,(wSeedTreeRefilledBitset)
	bit 0,a
	ret nz
+
	ld hl,@wallInsertion
	ld bc,wRoomLayout + $03
	ld a,$04
---
	ldh (<hFF8D),a
	ld a,$05
--
	ldh (<hFF8C),a
	ldi a,(hl)
	ld (bc),a
	inc bc
	ldh a,(<hFF8C)
	dec a
	jr nz,--

	ld a,$0b
	call addAToBc
	ldh a,(<hFF8D)
	dec a
	jr nz,---
	ret

@wallInsertion:
	.db $b9 $a7 $a7 $a7 $b8
	.db $b1 $a7 $a7 $a7 $b3
	.db $b1 $a7 $a7 $a7 $b3
	.db $b6 $b0 $b0 $b0 $b7

;;
; D7: 1st platform on floor 1
tileReplacement_group5Map4c:
	ld a,(wJabuWaterLevel)
	and $07
	ret z

	ld hl,@rect
	call fillRectInRoomLayout

	; Staircase going down
	ld l,$57
	ld (hl),$45
	ret

@rect:
	.db $35 $05 $05 $a2

;;
; D7: 2nd platform on floor 1
tileReplacement_group5Map4d:
	ld a,(wJabuWaterLevel)
	and $07
	ret z

	ld hl,@rect
	jp fillRectInRoomLayout

@rect:
	.db $12 $05 $05 $a2

;;
; D7: Used in room $55c and $571. Makes the 1st platform appear if the water
; level is correct.
tileReplacement_group5Map5c:
	ld a,(wDungeonFloor)
	ld b,a
	ld a,(wJabuWaterLevel)
	and $07
	cp b
	ret nz

	ld de,@platformRect
	jp drawRectInRoomLayout

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
tileReplacement_group5Map5d:
	ld a,(wDungeonFloor)
	ld b,a
	ld a,(wJabuWaterLevel)
	and $07
	cp b
	ret nz

	ld de,@platformRect
	jp drawRectInRoomLayout

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
tileReplacement_group7Map4a:
	call getThisRoomFlags
	and $80
	ret z

	ld hl,@ladderRect
	jp fillRectInRoomLayout

@ladderRect:
	.db $0d $0a $01 $18

;;
; Graveyard: Clear the fence if opened
tileReplacement_group0Map5c:
	call getThisRoomFlags
	and $80
	ret z

	ld hl,wRoomLayout + $34
	ld a,$3a
	ld (hl),a
	ld l,$43
	jp set3Bytes

;;
; Present forest above d2: clear rubble
tileReplacement_group0Map73:
	call getThisRoomFlags
	and $80
	ret z

	ld hl,wRoomLayout + $73
	ld (hl),$3a
	inc l
	ld (hl),$10
	inc l
	ld (hl),$11
	inc l
	ld (hl),$12
	inc l
	ld (hl),$3a
	ret

;;
; Present Tokay: remove scent tree if not planted
tileReplacement_group0Mapac:
	call getThisRoomFlags
	and $80
	ret nz

	ld hl,wRoomLayout + $33
	ld a,$af
	ldi (hl),a
	ld (hl),a
	ld l,$43
	ldi (hl),a
	ld (hl),a
	ret

;;
; Rolling ridge present screen with vine
tileReplacement_group0Map2c:
	ld bc,$0017
	call getVinePosition
	jp nz,setTileToWitheredVine
	ld l,$06
	ld de,@vineEdgeReplacements
	jp replaceVineTiles

@vineEdgeReplacements:
	.db $5d $60
	.db $00

;;
; Rolling ridge present, above the screen with a vine
tileReplacement_group0Map1c:
	ld bc,$0017
	call getVinePosition
	ret nz
	ld l,$66
	ld de,@vineEdgeReplacements
	jp replaceVineTiles

@vineEdgeReplacements:
	.db $5b $45
	.db $4d $55
	.db $00

;;
; Tokay island present, D3 entrance screen (has a vine)
tileReplacement_group0Mapba:
	ld bc,$0218
	call getVinePosition
	jp nz,setTileToWitheredVine
	ld l,$07
	ld de,@vineEdgeReplacements
	call replaceVineTiles
	ld a,$8b
	ld (wRoomLayout+$18),a
	ret

@vineEdgeReplacements:
	.db $61 $60
	.db $00

;;
; Tokay island present, above D3 entrance screen
tileReplacement_group0Mapaa:
	ld bc,$0218
	call getVinePosition
	ret nz

	ld l,$77
	ld de,@vineEdgeReplacements
	jp replaceVineTiles

@vineEdgeReplacements:
	.db $46 $45
	.db $00

;;
; Tokay island present, 2nd vine screen
tileReplacement_group0Mapcc:
	ld bc,$0311
	call getVinePosition
	jp nz,setTileToWitheredVine

	ld l,$00
	ld de,@vineEdgeReplacements
	jp replaceVineTiles

@vineEdgeReplacements:
	.db $61 $5d
	.db $00

;;
; Tokay island present, above 2nd vine screen
tileReplacement_group0Mapbc:
	ld bc,$0311
	call getVinePosition
	ret nz

	ld l,$70
	ld de,@vineEdgeReplacements
	jp replaceVineTiles

@vineEdgeReplacements:
	.db $46 $5c
	.db $00

;;
; Tokay island present, 3rd vine screen
tileReplacement_group0Mapda:
	ld bc,$0418
	call getVinePosition
	jp nz,setTileToWitheredVine

	ld l,$07
	ld de,@vineEdgeReplacements
	jp replaceVineTiles

@vineEdgeReplacements:
	.db $61 $60
	.db $00

;;
; Tokay island present, above 3rd vine screen
tileReplacement_group0Mapca:
	ld bc,$0418
	call getVinePosition
	ret nz

	ld l,$77
	ld de,@videEdgeReplacements
	jp replaceVineTiles

@videEdgeReplacements:
	.db $46 $45
	.db $00

;;
; Talus Peaks Present, has 2 vines
tileReplacement_group0Map61:
	ld bc,$0122
	call getVinePosition
	jr z,@vine1

	ld bc,$0127
	call getVinePosition
	jp nz,setTileToWitheredVine
@vine2:
	ld hl,wRoomLayout + $06
	ld (hl),$4d
	inc l
	ld (hl),$d5
	inc l
	ld (hl),$55
	ld l,$16
	ld (hl),$5d
	inc l
	ld (hl),$d6
	inc l
	ld (hl),$60
	ld l,$27
	ld (hl),$8d
	ret
@vine1:
	ld hl,wRoomLayout + $01
	ld (hl),$56
	inc l
	ld (hl),$d5
	inc l
	ld (hl),$4d
	ld l,$11
	ld (hl),$61
	inc l
	ld (hl),$d6
	inc l
	ld (hl),$5d
	ld l,$22
	ld (hl),$8d
	ret

;;
; Screen above talus peaks vines
tileReplacement_group0Map51:
	ld bc,$0122
	call getVinePosition
	jr z,@vines1

	ld bc,$0127
	call getVinePosition
	ret nz
@vines2:
	ld hl,wRoomLayout + $76
	ld (hl),$5b
	inc l
	ld (hl),$d4
	inc l
	ld (hl),$45
	ret
@vines1:
	ld hl,wRoomLayout + $71
	ld (hl),$46
	inc l
	ld (hl),$d4
	inc l
	ld (hl),$5c
	ret

;;
; Replaces tiles that should be turned into vines.
; @param de Data structure with values to replace the sides of the vine with.
; Format: left byte, right byte, repeat, $00 to end
; @param l Top-left of where to apply the data at de.
replaceVineTiles:
	ld h,>wRoomLayout
--
	ld a,(de)
	or a
	jr z,++

	ld a,(de)
	inc de
	ldi (hl),a
	inc l
	ld a,(de)
	inc de
	ldi (hl),a
	ld a,$0d
	rst_addAToHl
	jr --
++
	ld de,@vineReplacements
	call replaceTiles

	; Find the vine base
	ld a,$d6
	call findTileInRoom
	ret nz

	; Set the tile below that to $8d which completes the vine base
	ld a,l
	add $10
	ld l,a
	ld (hl),$8d
	ret

@vineReplacements:
	.db $d4 $05 ; Top of cliff -> top of vine
	.db $d5 $8e ; Body
	.db $d6 $8f ; Bottom
	.db $00


;;
; Retrieve a position from [hl], set the tile at that position to a withered
; vine.
setTileToWitheredVine:
	ld l,(hl)
	ld h,>wRoomLayout
	ld a,(hl)
	push hl
	call retrieveTileCollisionValue
	pop hl
	or a
	ret nz
	ld (hl),$8c
	ret

;;
; Get the position of vine B and compare with C.
getVinePosition:
	ld a,b
	ld hl,wVinePositions
	rst_addAToHl
	ld a,(hl)
	cp c
	ret

;;
initializeVinePositions:
	ld hl,wVinePositions
	ld de,@defaultVinePositions
	ld b,$06
	jp copyMemoryReverse

@defaultVinePositions:
	.include "build/data/defaultVinePositions.s"

;;
; Present, bridge to nuun highlands
tileReplacement_group0Map54:
	xor a
	ld (wSwitchState),a
	call getThisRoomFlags
	and $40
	ret z

	ld a,$1d
	ld hl,wRoomLayout + $43
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld a,$1e
	ld l,$53
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld a,$9e
	ld (wRoomLayout+$68),a
	ret

;;
; Present, right side of bridge to symmetry city
tileReplacement_group0Map25:
	ld a,GLOBALFLAG_SYMMETRY_BRIDGE_BUILT
	call checkGlobalFlag
	ret z

	ld a,$1d
	ld hl,wRoomLayout + $50
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld a,$1e
	ld hl,wRoomLayout+$60
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ret

;;
; Present overworld, impa's house
tileReplacement_group0Map3a:
	ld a,GLOBALFLAG_INTRO_DONE
	call checkGlobalFlag
	ret z

	; Open door
	ld a,$ee
	ld (wRoomLayout+$23),a
	ret

;;
; Present, screen right of d5 where a cave opens up
tileReplacement_group0Map0b:
	ld hl,wPresentRoomFlags+$0a
	bit ROOMFLAG_BIT_40,(hl)
	ret z

	ld hl,wRoomLayout+$43
	ld (hl),$dd
	ret

;;
; Present cave with goron elder.
; Removes boulders after dungeon 4 is beaten.
tileReplacement_group5Mapb9:
	; Must have beaten dungeon 4
	ld a,$03
	ld hl,wEssencesObtained
	call checkFlag
	ret z

	ld bc,@replacementTiles
	ld hl,wRoomLayout+$41
	call @locFunc
	ld l,$51
@locFunc:
	ld a,$05
--
	ldh (<hFF8D),a
	ld a,(bc)
	inc bc
	ldi (hl),a
	ldh a,(<hFF8D)
	dec a
	jr nz,--
	ret

@replacementTiles:
	.db $a1 $a1 $a1 $ef $a1
	.db $a2 $ef $a2 $a2 $a2

;;
; Past overworld, Ambi's Palace secret passage
tileReplacement_group1Map27:
	call getThisRoomFlags
	ld l,$15
	bit 7,(hl)
	jr z,+

	ld de,$3343
	call @locFunc
+
	ld l,$17
	bit 7,(hl)
	jr z,+

	ld de,$3424
	call @locFunc
+
	ld l,$35
	bit 7,(hl)
	jr z,+

	ld de,$3545
	call @locFunc
+
	ld l,$37
	bit 7,(hl)
	ret z

	ld de,$3626
@locFunc:
	ld b,>wRoomLayout
	ld c,d
	ld a,$3a
	ld (bc),a
	ld c,e
	ld a,$02
	ld (bc),a
	ret

;;
; Present cave on the way to rolling ridge
; Has a bridge
tileReplacement_group5Mapc2:
	call getThisRoomFlags
	and $80
	ret z

	ld hl,wRoomLayout+$56
	ld a,$6d

;;
; Sets 4 bytes at hl to the value of a.
set4Bytes:
	ldi (hl),a
set3Bytes:
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ret

;;
; Past cave on the way to the d6 area
; Has a bridge
tileReplacement_group5Mape3:
	call getThisRoomFlags
	and $80
	ret z

	ld hl,wRoomLayout+$26
	ld a,$6d
	jr set3Bytes

;;
; Underwater, entrance to Jabu
tileReplacement_group2Map90:
	call getThisRoomFlags
	and $02
	ret z

	ld de,@rect
	jp drawRectInRoomLayout

@rect:
	.db $42 $02 $06
	.db $dd $de $df $ed $ee $ef
	.db $b9 $ba $bb $bc $bd $be

;;
; Past, area beneath the entrance to d8 maze
tileReplacement_group1Map8c:
	call getThisRoomFlags
	and $80
	ret z

	ld hl,wRoomLayout+$04
	ld (hl),$30
	inc l
	ld (hl),$32
	ld a,$3a
	ld l,$14
	ldi (hl),a
	ld (hl),a
	ld l,$34
	ld (hl),$02
	inc l
	ld (hl),$3a
	ret

;;
; Present, shortcut cave for tingle
tileReplacement_group2Map9e:
	xor a
	ld (wToggleBlocksState),a
	call getThisRoomFlags
	and $40
	ret z

	ld hl,wRoomLayout+$13
	ld a,$6d
	call set3Bytes
	inc l
	jp set3Bytes

;;
; Present, on top of maku tree (left end)
tileReplacement_group0Mape0:
	ld a,(wEssencesObtained)
	bit 4,a
	ld l,$46
	call nz,setTileToDoor
	ld c,$1b
;;
createInteraction90:
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERACID_MISC_PUZZLES
	inc l
	ld (hl),c
	ret

;;
; Present, on top of maku tree (middle)
tileReplacement_group0Mape1:
	ld c,$1c
	call createInteraction90
	ld a,(wEssencesObtained)
	rrca
	ld l,$26
	call c,setTileToDoor
	rrca
	ret nc

	ld l,$53
	jr setTileToDoor

;;
; Present, on top of maku tree (right)
tileReplacement_group0Mape2:
	ld c,$1d
	call createInteraction90
	ld a,(wEssencesObtained)
	bit 2,a
	ret z

	ld l,$54

;;
setTileToDoor:
	ld h,>wRoomLayout
	ld (hl),$dd
	ret

;;
; Black Tower, room with 3 doors
tileReplacement_group4Mapea:
	call getThisRoomFlags
	and $40
	ret z

	ld a,$a3
	ld hl,wRoomLayout+$33
	call set3Bytes
	ld l,$39
	call set3Bytes
	ld a,$b7
	ld l,$43
	call set3Bytes
	ld l,$49
	call set3Bytes
	ld a,$88
	ld l,$53
	call set3Bytes
	ld l,$59
	jp set3Bytes

;;
; Present, room where you find ricky's gloves
tileReplacement_group0Map98:
	ld a,(wRickyState)
	bit 5,a
	jr nz,@removeDirt

	and $01
	jr z,@removeDirt

	ld a,TREASURE_RICKY_GLOVES
	call checkTreasureObtained
	ret nc

@removeDirt:
	ld a,$3a
	ld (wRoomLayout+$24),a
	ret

;;
; Present overworld, black tower entrance
tileReplacement_group0Map76:
	call checkIsLinkedGame
	ret z

	call getBlackTowerProgress
	dec a
	ret nz

	ld hl,wRoomLayout+$54
	ld a,$a7
	ldi (hl),a
	ld (hl),a
	ret

;;
; Present library
tileReplacement_group0Mapa5:
	ld a,(wPastRoomFlags+$a5)
	bit 7,a
	ret z

	ld hl,wRoomLayout+$22
	ld (hl),$ee
	inc l
	ld (hl),$ef
	ret

;;
; Leftover function from Seasons (d8LavaRoomsFillTilesWithLava). Can be used for other tiles, not
; just lava
func_04_6ba8:
	ld d,>wRoomLayout
	ldi a,(hl)
	ld c,a
--
	ldi a,(hl)
	cp $ff
	ret z

	ld e,a
	ld a,c
	ld (de),a
	jr --

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
; Like fillRect, but reads a series of bytes for the tile values instead of
; just one.
drawRectInRoomLayout:
	ld a,(de)
	inc de
	ld h,>wRoomLayout
	ld l,a
	ldh (<hFF8B),a
	ld a,(de)
	inc de
	ld c,a
	ld a,(de)
	inc de
	ldh (<hFF8D),a
---
	ldh a,(<hFF8D)
	ld b,a
--
	ld a,(de)
	inc de
	ldi (hl),a
	dec b
	jr nz,--

	ldh a,(<hFF8B)
	add $10
	ldh (<hFF8B),a
	ld l,a
	dec c
	jr nz,---
	ret
