applyAllTileSubstitutions:
	call applySingleTileChanges
	call applyStandardTileSubstitutions
	call replaceOpenedChest
	ld a,(wActiveGroup)
	cp $02
	jr z,++
	cp NUM_SMALL_GROUPS
	jr nc,+
	; groups 0,1,3
	call loadSubrosiaObjectGfxHeader
	jp applyRoomSpecificTileChanges
+
	; groups 4,5,6,7
	call replaceShutterForLinkEntering
	call replaceSwitchTiles
	jp applyRoomSpecificTileChanges
++
	; group 2
	ld e,OBJGFXH_04-1
	jp loadObjectGfxHeaderToSlot4

loadSubrosiaObjectGfxHeader:
	ld a,(wMinimapGroup)
	cp $01
	ret nz
	ld e,OBJGFXH_07-1
	jp loadObjectGfxHeaderToSlot4

;;
; @param de Structure for tiles to replace
; (format: tile to replace with, tile to replace, repeat, $00 to end)
replaceTiles:
	ld a,(de)
	or a
	ret z
	ld b,a
	inc de
	ld a,(de)
	inc de
	call findTileInRoom
	jr nz,replaceTiles
	ld (hl),b
	ld c,a
	ld a,l
	or a
	jr z,replaceTiles
-
	dec l
	ld a,c
	call backwardsSearch
	jr nz,replaceTiles
	ld (hl),b
	ld c,a
	ld a,l
	or a
	jr z,replaceTiles
	jr -

applyStandardTileSubstitutions:
	call getThisRoomFlags
	ldh (<hFF8B),a
	ld hl,@bit0
	bit 0,a
	call nz,@locFunc

	ld hl,@bit1
	ldh a,(<hFF8B)
	bit 1,a
	call nz,@locFunc

	ld hl,@bit2
	ldh a,(<hFF8B)
	bit 2,a
	call nz,@locFunc

	ld hl,@bit3
	ldh a,(<hFF8B)
	bit 3,a
	call nz,@locFunc

	ld hl,@bit7
	ldh a,(<hFF8B)
	bit 7,a
	ret z
@locFunc:
	ld a,(wActiveGroup)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,l
	ld d,h
	jr replaceTiles

@bit0:
	.dw @bit0Collisions0
	.dw @bit0Collisions1
	.dw @bit0Collisions2
	.dw @bit0Collisions3
	.dw @bit0Collisions4
	.dw @bit0Collisions5
	.dw @bit0Collisions6
	.dw @bit0Collisions7

@bit1:
	.dw @bit1Collisions0
	.dw @bit1Collisions1
	.dw @bit1Collisions2
	.dw @bit1Collisions3
	.dw @bit1Collisions4
	.dw @bit1Collisions5
	.dw @bit1Collisions6
	.dw @bit1Collisions7

@bit2:
	.dw @bit2Collisions0
	.dw @bit2Collisions1
	.dw @bit2Collisions2
	.dw @bit2Collisions3
	.dw @bit2Collisions4
	.dw @bit2Collisions5
	.dw @bit2Collisions6
	.dw @bit2Collisions7

@bit3:
	.dw @bit3Collisions0
	.dw @bit3Collisions1
	.dw @bit3Collisions2
	.dw @bit3Collisions3
	.dw @bit3Collisions4
	.dw @bit3Collisions5
	.dw @bit3Collisions6
	.dw @bit3Collisions7

@bit7:
	.dw @bit7Collisions0
	.dw @bit7Collisions1
	.dw @bit7Collisions2
	.dw @bit7Collisions3
	.dw @bit7Collisions4
	.dw @bit7Collisions5
	.dw @bit7Collisions6
	.dw @bit7Collisions7

@bit0Collisions0:
@bit0Collisions1:
@bit0Collisions2:
	.db $00

@bit0Collisions3:
@bit0Collisions4:
@bit0Collisions5:
	.db $34 $30
	.db $34 $38
	.db $a0 $70
	.db $a0 $74
	.db $00

@bit0Collisions6:
@bit0Collisions7:
	.db $00

@bit1Collisions0:
@bit1Collisions1:
@bit1Collisions2:
	.db $00

@bit1Collisions3:
@bit1Collisions4:
@bit1Collisions5:
	.db $35 $31
	.db $35 $39
	.db $a0 $71
	.db $a0 $75

@bit1Collisions6:
@bit1Collisions7:
	.db $00

@bit2Collisions0:
@bit2Collisions1:
@bit2Collisions2:
	.db $00

@bit2Collisions3:
@bit2Collisions4:
@bit2Collisions5:
	.db $36 $32
	.db $36 $3a
	.db $a0 $72
	.db $a0 $76

@bit2Collisions6:
@bit2Collisions7:
	.db $00

@bit3Collisions0:
@bit3Collisions1:
@bit3Collisions2:
	.db $00

@bit3Collisions3:
@bit3Collisions4:
@bit3Collisions5:
	.db $37 $33
	.db $37 $3b
	.db $a0 $73
	.db $a0 $77

@bit3Collisions6:
@bit3Collisions7:
	.db $00

@bit7Collisions0:
	.db $e7 $c1
	.db $e0 $c6
	.db $e0 $c2
	.db $e0 $e3
	.db $e6 $c5
	.db $e7 $cb
	.db $e8 $e2

@bit7Collisions1:
	.db $00

@bit7Collisions2:
	.db $00

@bit7Collisions3:
	.db $00

@bit7Collisions4:
@bit7Collisions5:
	.db $a0 $1e
	.db $44 $42
	.db $45 $43
	.db $46 $40
	.db $47 $41
	.db $45 $8d

@bit7Collisions6:
@bit7Collisions7:
	.db $00

replaceShutterForLinkEntering:
	ld a,(wDungeonIndex)
	inc a
	ret z
	ld bc,wRoomLayout+$ae
-
	ld a,(bc)
	push bc
	sub $78
	cp $08
	call c,@temporarilyOpenDoor
	pop bc
	dec c
	jr nz,-
	ret

@temporarilyOpenDoor:
	ld de,@shutterData
	call addDoubleIndexToDe
	ld a,(de)
	ldh (<hFF8B),a
	inc de
	ld a,(de)
	ld e,a
	ld a,(wScrollMode)
	and $08
	jr z,@doneReplacement

	ld a,(wLinkObjectIndex)
	ld h,a
	ld a,($cd02)
	xor $02
	ld d,a
	ld a,e
	and $03
	cp d
	ret nz
	ld a,($cd02)
	bit 0,a
	jr nz,@horizontal

	and $02
	ld l,$0d
	ld a,(hl)
	jr nz,@down
@up:
	and $f0
	swap a
	or $a0
	jr @doReplacement
@down:
	and $f0
	swap a
	jr @doReplacement
@horizontal:
	and $02
	ld l,$0b
	ld a,(hl)
	jr nz,@left
@right:
	and $f0
	jr @doReplacement
@left:
	and $f0
	or $0e

@doReplacement:
	cp c
	jr nz,@doneReplacement

	push bc
	ld c,a
	ld a,(bc)
	sub $78
	cp $08
	jr nc,+

	ldh a,(<hFF8B)
	ld (bc),a
+
	pop bc

@doneReplacement:
	ld a,e
	bit 7,a
	ret nz
	and $7f
	ld e,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),$1e
	inc l
	ld (hl),e
	ld l,$4b
	ld (hl),c
	ret

@shutterData:
	.db $a0 $80
	.db $a0 $81
	.db $a0 $82
	.db $a0 $83
	.db $5e $0c
	.db $5d $0d
	.db $5e $0e
	.db $5d $0f

replaceOpenedChest:
	call getThisRoomFlags
	bit 5,a
	ret z
	call getChestData
	ld d,$cf
	ld a,$f0
	ld (de),a
	ret

replaceSwitchTiles:
	ld hl,@group4SwitchData
	ld a,($cc49)
	sub $04
	jr z,+

	dec a
	ret nz

	ld hl,@group5SwitchData
+
	ld a,($cc4c)
	ld b,a
	ld a,($cc32)
	ld c,a
	ld d,$cf
@next:
	ldi a,(hl)
	or a
	ret z
	cp b
	jr nz,@skip3Bytes

	ldi a,(hl)
	and c
	jr z,@skip2Bytes

	ldi a,(hl)
	ld e,(hl)
	inc hl
	ld (de),a
	jr @next
@skip3Bytes:
	inc hl
@skip2Bytes:
	inc hl
	inc hl
	jr @next

@group4SwitchData:
	.db $0f $01 $0b $33
	.db $0f $01 $5a $74
	.db $6f $01 $0b $8c
	.db $6f $01 $5c $29
	.db $70 $02 $0b $28
	.db $70 $02 $5b $52
	.db $70 $04 $0b $59
	.db $70 $04 $5b $84
	.db $76 $08 $0b $17
	.db $76 $08 $5d $25
	.db $7e $10 $0b $56
	.db $7e $10 $5c $66
	.db $a0 $01 $5e $44
	.db $a0 $02 $5e $37
	.db $a0 $01 $0b $83
	.db $a0 $02 $0b $78
	.db $00

@group5SwitchData:
	.db $7e $01 $5c $2b
	.db $7e $01 $0b $78
	.db $00

applySingleTileChanges:
	ld a,($cc4c)
	ld b,a
	call getThisRoomFlags
	ld c,a
	ld d,$cf
	ld a,($cc49)
	ld hl,singleTileChangeGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
@next:
	ldi a,(hl)
	cp b
	jr nz,@match
	ld a,(hl)
	and c
	jr z,@match
	inc hl
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld (de),a
	jr @next

@match:
	ld a,(hl)
	or a
	ret z
	inc hl
	inc hl
	inc hl
	jr @next
