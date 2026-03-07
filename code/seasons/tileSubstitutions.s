; TODO: Synchronize with Ages version of file
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
	ld hl,standardTileSubstitutions@bit0
	bit 0,a
	call nz,@locFunc

	ld hl,standardTileSubstitutions@bit1
	ldh a,(<hFF8B)
	bit 1,a
	call nz,@locFunc

	ld hl,standardTileSubstitutions@bit2
	ldh a,(<hFF8B)
	bit 2,a
	call nz,@locFunc

	ld hl,standardTileSubstitutions@bit3
	ldh a,(<hFF8B)
	bit 3,a
	call nz,@locFunc

	ld hl,standardTileSubstitutions@bit7
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


.include {"{GAME_DATA_DIR}/tile_properties/standardTileSubstitutions.s"}
.include "code/commonTileSubstitutions.s"
