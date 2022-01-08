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
	ld hl,@tileReplacementDict
	call lookupKey
	ret nc

	ld (bc),a
	ret

@tileReplacementDict:
	.db $c0 $3a ; Rocks
	.db $c3 $3a
	.db $c5 $3a ; Bushes
	.db $c8 $3a
	.db $ce $3a ; Burnable bush
	.db $db $3a ; Switchhook diamond
	.db $f2 $3a ; Sign
	.db $cd $3a ; Dirt
	.db $04 $3a ; Flowers (in some areas)
	.db $00

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
	ld hl,@tileReplacementDict
	call lookupKey
	ret nc

	ld (bc),a
	ret

@tileReplacementDict:
	.db $c5 $3a
	.db $c8 $3a
	.db $04 $3a
	.db $00

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
	ld a,(wActiveCollisions)
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
@bit1:
	.dw @bit1Collisions0
	.dw @bit1Collisions1
	.dw @bit1Collisions2
	.dw @bit1Collisions3
	.dw @bit1Collisions4
	.dw @bit1Collisions5
@bit2:
	.dw @bit2Collisions0
	.dw @bit2Collisions1
	.dw @bit2Collisions2
	.dw @bit2Collisions3
	.dw @bit2Collisions4
	.dw @bit2Collisions5
@bit3:
	.dw @bit3Collisions0
	.dw @bit3Collisions1
	.dw @bit3Collisions2
	.dw @bit3Collisions3
	.dw @bit3Collisions4
	.dw @bit3Collisions5
@bit7:
	.dw @bit7Collisions0
	.dw @bit7Collisions1
	.dw @bit7Collisions2
	.dw @bit7Collisions3
	.dw @bit7Collisions4
	.dw @bit7Collisions5

@bit0Collisions0:
@bit0Collisions4:
@bit0Collisions5:
	.db $00
@bit0Collisions1:
@bit0Collisions2:
	.db $34 $30 ; Bombable walls, key doors (up)
	.db $34 $38
	.db $a0 $70
	.db $a0 $74
	.db $00
@bit0Collisions3:
	.db $00

@bit1Collisions0:
@bit1Collisions4:
@bit1Collisions5:
	.db $00
@bit1Collisions1:
@bit1Collisions2:
	.db $35 $31 ; Bombable walls, key doors (right)
	.db $35 $39
	.db $35 $68
	.db $a0 $71
	.db $a0 $75
@bit1Collisions3:
	.db $00

@bit2Collisions0:
@bit2Collisions5:
@bit2Collisions4:
	.db $00
@bit2Collisions1:
@bit2Collisions2:
	.db $36 $32 ; Bombable walls, key doors (down)
	.db $36 $3a
	.db $a0 $72
	.db $a0 $76
@bit2Collisions3:
	.db $00

@bit3Collisions0:
@bit3Collisions4:
@bit3Collisions5:
	.db $00
@bit3Collisions1:
@bit3Collisions2:
	.db $37 $33 ; Bombable walls, key doors (left)
	.db $37 $3b
	.db $37 $69
	.db $a0 $73
	.db $a0 $77
@bit3Collisions3:
	.db $00

@bit7Collisions0:
	.db $dd $c1 ; Cave door under rock? (Is this a bug?)
	.db $d2 $c2 ; Soil under rock
	.db $d7 $c4 ; Portal under rock
	.db $dc $c6 ; Grave pushed onto land
	.db $d2 $c7 ; Soil under bush
	.db $d7 $c9 ; Soil under bush
	.db $d2 $cb ; Soil under earth
	.db $dc $cf ; Stairs under burnable tree
	.db $dd $d1 ; Bombable cave door
@bit7Collisions1:
	.db $00
@bit7Collisions2:
	.db $a0 $1e ; Keyblock
	.db $44 $42 ; Appearing upward stairs
	.db $45 $43 ; Appearing downward stairs
	.db $46 $40 ; Appearing upward stairs in wall
	.db $47 $41 ; Appearing downward stairs in wall
@bit7Collisions3:
@bit7Collisions4:
@bit7Collisions5:
	.db $00

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
