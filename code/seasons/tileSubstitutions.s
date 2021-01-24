; TODO: Synchronize with Ages version of file
applyAllTileSubstitutions:
	call applyRandoTileChanges
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
	ld e,OBJ_GFXH_04-1
	jp loadObjectGfxHeaderToSlot4

loadSubrosiaObjectGfxHeader:
	ld a,(wMinimapGroup)
	cp $01
	ret nz
	ld e,OBJ_GFXH_07-1
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
	.dw @bit0Group0
	.dw @bit0Group1
	.dw @bit0Group2
	.dw @bit0Group3
	.dw @bit0Group4
	.dw @bit0Group5
	.dw @bit0Group6
	.dw @bit0Group7

@bit1:
	.dw @bit1Group0
	.dw @bit1Group1
	.dw @bit1Group2
	.dw @bit1Group3
	.dw @bit1Group4
	.dw @bit1Group5
	.dw @bit1Group6
	.dw @bit1Group7

@bit2:
	.dw @bit2Group0
	.dw @bit2Group1
	.dw @bit2Group2
	.dw @bit2Group3
	.dw @bit2Group4
	.dw @bit2Group5
	.dw @bit2Group6
	.dw @bit2Group7

@bit3:
	.dw @bit3Group0
	.dw @bit3Group1
	.dw @bit3Group2
	.dw @bit3Group3
	.dw @bit3Group4
	.dw @bit3Group5
	.dw @bit3Group6
	.dw @bit3Group7

@bit7:
	.dw @bit7Group0
	.dw @bit7Group1
	.dw @bit7Group2
	.dw @bit7Group3
	.dw @bit7Group4
	.dw @bit7Group5
	.dw @bit7Group6
	.dw @bit7Group7

@bit0Group0:
@bit0Group1:
@bit0Group2:
	.db $00

@bit0Group3:
@bit0Group4:
@bit0Group5:
	.db $34 $30 ; Bombable walls, key doors (up)
	.db $34 $38
	.db $a0 $70
	.db $a0 $74
	.db $00

@bit0Group6:
@bit0Group7:
	.db $00

@bit1Group0:
@bit1Group1:
@bit1Group2:
	.db $00

@bit1Group3:
@bit1Group4:
@bit1Group5:
	.db $35 $31 ; Bombable walls, key doors (right)
	.db $35 $39
	.db $a0 $71
	.db $a0 $75

@bit1Group6:
@bit1Group7:
	.db $00

@bit2Group0:
@bit2Group1:
@bit2Group2:
	.db $00

@bit2Group3:
@bit2Group4:
@bit2Group5:
	.db $36 $32 ; Bombable walls, key doors (down)
	.db $36 $3a
	.db $a0 $72
	.db $a0 $76

@bit2Group6:
@bit2Group7:
	.db $00

@bit3Group0:
@bit3Group1:
@bit3Group2:
	.db $00

@bit3Group3:
@bit3Group4:
@bit3Group5:
	.db $37 $33 ; Bombable walls, key doors (left)
	.db $37 $3b
	.db $a0 $73
	.db $a0 $77

@bit3Group6:
@bit3Group7:
	.db $00

@bit7Group0:
	.db $e7 $c1 ; TODO
	.db $e0 $c6
	.db $e0 $c2
	.db $e0 $e3
	.db $e6 $c5
	.db $e7 $cb
	.db $e8 $e2

@bit7Group1:
	.db $00

@bit7Group2:
	.db $00

@bit7Group3:
	.db $00

@bit7Group4:
@bit7Group5:
	.db $a0 $1e
	.db $44 $42
	.db $45 $43
	.db $46 $40
	.db $47 $41
	.db $45 $8d

@bit7Group6:
@bit7Group7:
	.db $00

.include "code/commonTileSubstitutions.s"
.include "code/rando/tileSubstitutions.s"
