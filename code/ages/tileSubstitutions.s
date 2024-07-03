;;
applyAllTileSubstitutions:
	call replacePollutionWithWaterIfPollutionFixed
	call applySingleTileChanges
	call applyStandardTileSubstitutions
	call replaceOpenedChest
	ld a,(wActiveGroup)
	and $06
	cp NUM_SMALL_GROUPS
	jr nz,+

	call replaceShutterForLinkEntering
	call replaceSwitchTiles
	call replaceToggleBlocks
	call replaceJabuTilesIfUnderwater
+
	call applyRoomSpecificTileChanges
	ld a,(wActiveGroup)
	cp $02
	ret nc

	; In the overworld

	call replaceBreakableTileOverPortal
	call replaceBreakableTileOverLinkTimeWarpingIn
	ld a,(wLinkTimeWarpTile)
	or a
	ret z

	; If link was sent back from trying to travel through time, clear the
	; breakable tile at his position (if it exists) so he can safely
	; return.

	ld c,a
	dec c
	ld b,>wRoomLayout
	ld a,(bc)
	ld e,a
	ld hl,timewarpReturnTileReplacementDict
	call lookupKey
	ret nc

	ld (bc),a
	ret

.include {"{GAME_DATA_DIR}/tileProperties/timewarpReturnTileReplacement.s"}

;;
replaceBreakableTileOverPortal:
	ld hl,wPortalGroup
	ld a,(wActiveGroup)
	cp (hl)
	ret nz

	inc l
	ld a,(wActiveRoom)
	cp (hl)
	ret nz

	inc l
	ld c,(hl)
removeBreakableTileForTimeWarp:
	ld b,>wRoomLayout
	ld a,(bc)
	ld e,a
	ld hl,timewarpEntryTileReplacementDict
	call lookupKey
	ret nc

	ld (bc),a
	ret

.include {"{GAME_DATA_DIR}/tileProperties/timewarpEntryTileReplacement.s"}

;;
replaceBreakableTileOverLinkTimeWarpingIn:
	ld a,(wWarpTransition)
	and $0f
	cp TRANSITION_DEST_TIMEWARP
	ret nz

	ld a,(wWarpDestPos)
	ld c,a
	jr removeBreakableTileForTimeWarp

;;
replacePollutionWithWaterIfPollutionFixed:
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ret z

	ld a,(wTilesetFlags)
	bit TILESETFLAG_BIT_OUTDOORS,a
	ret z

	ld de,@aboveWaterReplacement
	and TILESETFLAG_UNDERWATER
	jr z,+
	ld de,@belowWaterReplacement
+
	jr replaceTiles

@aboveWaterReplacement:
	.db $fc $eb
	.db $00
@belowWaterReplacement:
	.db $3b $eb
	.db $00

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
--
	dec l
	ld a,c
	call backwardsSearch
	jr nz,replaceTiles

	ld (hl),b
	ld c,a
	ld a,l
	or a
	jr z,replaceTiles
	jr --

;;
; Substitutes various tiles when particular room flag bits (0-3, 7) are set.
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
	ld a,(wActiveCollisions)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,l
	ld d,h
	jr replaceTiles


.include {"{GAME_DATA_DIR}/tileProperties/standardTileSubstitutions.s"}

;;
; Updates the toggleable blocks to the correct state when loading a room.
replaceToggleBlocks:
	call checkDungeonUsesToggleBlocks
	ret z

	callab roomGfxChanges.func_02_7a77
	ld de,@state1
	ld a,(wToggleBlocksState)
	or a
	jr nz,+
	ld de,@state2
+
	jp replaceTiles

@state1:
	.db $0f $29
	.db $28 $0e
	.db $00
@state2:
	.db $0e $28
	.db $29 $0f
	.db $00

;;
; Does the necessary tile changes if underwater in jabu-jabu.
replaceJabuTilesIfUnderwater:
	ld a,(wDungeonIndex)
	cp $07
	ret nz

	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	ret nz

	; Only substitute tiles if on the first non-underwater floor
	ld a,(wDungeonFloor)
	ld b,a
	ld a,(wJabuWaterLevel)
	and $07
	cp b
	ret nz

	ld de,@data1
	call replaceTiles
	ld de,@data2
	jp replaceTiles

@data1:
	.db $fa $f3 ; holes -> shallow water
	.db $fa $f4
	.db $fa $f5
	.db $fa $f6
	.db $fa $f7
	.db $00

@data2:
	.db $fc $48 ; floor-transfer holes -> deep water
	.db $fc $49
	.db $fc $4a
	.db $fc $4b
	.db $00

.include "code/commonTileSubstitutions.s"
