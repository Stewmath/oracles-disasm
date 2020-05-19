;;
; @addr{5fef}
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
; @addr{6046}
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
_removeBreakableTileForTimeWarp:
	ld b,>wRoomLayout
	ld a,(bc)
	ld e,a
	ld hl,@tileReplacementDict
	call lookupKey
	ret nc

	ld (bc),a
	ret

; @addr{6063}
@tileReplacementDict:
	.db $c5 $3a
	.db $c8 $3a
	.db $04 $3a
	.db $00

;;
; @addr{606a}
replaceBreakableTileOverLinkTimeWarpingIn:
	ld a,(wWarpTransition)
	and $0f
	cp TRANSITION_DEST_TIMEWARP
	ret nz

	ld a,(wWarpDestPos)
	ld c,a
	jr _removeBreakableTileForTimeWarp

;;
; @addr{6078}
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

; @addr{6090}
@aboveWaterReplacement:
	.db $fc $eb
	.db $00
; @addr{6093}
@belowWaterReplacement:
	.db $3b $eb
	.db $00

;;
; @param de Structure for tiles to replace
; (format: tile to replace with, tile to replace, repeat, $00 to end)
; @addr{6096}
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
; @addr{60b7}
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

; @addr{60f5}
@bit0:
	.dw @bit0Collisions0
	.dw @bit0Collisions1
	.dw @bit0Collisions2
	.dw @bit0Collisions3
	.dw @bit0Collisions4
	.dw @bit0Collisions5
; @addr{6101}
@bit1:
	.dw @bit1Collisions0
	.dw @bit1Collisions1
	.dw @bit1Collisions2
	.dw @bit1Collisions3
	.dw @bit1Collisions4
	.dw @bit1Collisions5
; @addr{610d}
@bit2:
	.dw @bit2Collisions0
	.dw @bit2Collisions1
	.dw @bit2Collisions2
	.dw @bit2Collisions3
	.dw @bit2Collisions4
	.dw @bit2Collisions5
; @addr{6119}
@bit3:
	.dw @bit3Collisions0
	.dw @bit3Collisions1
	.dw @bit3Collisions2
	.dw @bit3Collisions3
	.dw @bit3Collisions4
	.dw @bit3Collisions5
; @addr{6125}
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
; @addr{617c}
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

; @addr{6197}
@state1:
	.db $0f $29
	.db $28 $0e
	.db $00
; @addr{619c}
@state2:
	.db $0e $28
	.db $29 $0f
	.db $00

;;
; Does the necessary tile changes if underwater in jabu-jabu.
; @addr{61a1}
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

; @addr{61c4}
@data1:
	.db $fa $f3 ; holes -> shallow water
	.db $fa $f4
	.db $fa $f5
	.db $fa $f6
	.db $fa $f7
	.db $00

; @addr{61cf}
@data2:
	.db $fc $48 ; floor-transfer holes -> deep water
	.db $fc $49
	.db $fc $4a
	.db $fc $4b
	.db $00

;;
; Replaces a shutter link is about to walk on to with empty floor.
; @addr{61d8}
replaceShutterForLinkEntering:
	ldbc >wRoomLayout, (LARGE_ROOM_HEIGHT-1)<<4 + (LARGE_ROOM_WIDTH-1)
--
	ld a,(bc)
	push bc
	sub $78
	cp $08
	call c,@temporarilyOpenDoor
	pop bc
	dec c
	jr nz,--
	ret

; Replaces a door at position bc with empty floor, and adds an interaction to
; re-close it when link moves away (for minecart doors only)
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
	ld a,(wScreenTransitionDirection)
	xor $02
	ld d,a
	ld a,e
	and $03
	cp d
	ret nz

	ld a,(wScreenTransitionDirection)
	bit 0,a
	jr nz,@horizontal
; vertical
	and $02
	ld l,<w1Link.xh
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
	ld l,<w1Link.yh
	ld a,(hl)
	jr nz,@left
@right:
	and $f0
	jr @doReplacement
@left:
	and $f0
	or $0e

@doReplacement:
	; Only replace if link is standing on the tile.
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
	; If bit 7 is set, don't add an auto-shutter interaction.
	ld a,e
	bit 7,a
	ret nz

	and $7f
	ld e,a

	; If not in a dungeon, don't add an auto-shutter.
	ld a,(wTilesetFlags)
	bit TILESETFLAG_BIT_DUNGEON,a
	ret z

	call getFreeInteractionSlot
	ret nz

	ld (hl),$1e
	inc l
	ld (hl),e
	ld l,Interaction.yh
	ld (hl),c
	ret

; Data format:
; Byte 1 - tile to replace shutter with
; Byte 2 - bit 7: don't auto-close, bits 0-6: low byte of interaction id
; @addr{625f}
@shutterData:
	.db $a0 $80 ; Normal shutters
	.db $a0 $81
	.db $a0 $82
	.db $a0 $83
	.db $5e $0c ; Minecart shutters
	.db $5d $0d
	.db $5e $0e
	.db $5d $0f

;;
; @addr{626f}
replaceOpenedChest:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_ITEM,a
	ret z

	call getChestData
	ld d,>wRoomLayout
	ld a,TILEINDEX_CHEST_OPENED
	ld (de),a
	ret

;;
; Replaces switch tiles and whatever they control if the switch is set.
; Groups 4 and 5 only.
; @addr{627e}
replaceSwitchTiles:
	ld hl,@group4SwitchData
	ld a,(wActiveGroup)
	sub NUM_SMALL_GROUPS
	jr z,+

	dec a
	ret nz

	ld hl,@group5SwitchData
+
	ld a,(wActiveRoom)
	ld b,a
	ld a,(wSwitchState)
	ld c,a
	ld d,>wRoomLayout
@next:
	ldi a,(hl)
	or a
	ret z

	; Check room
	cp b
	jr nz,@skip3Bytes

	; Check if corresponding bit of wSwitchState is set
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

; Data format:
; Room, Switch bit, new tile index, position of tile to replace

; @addr{62ac}
@group4SwitchData:
	.db $2f $02 $0b $79
	.db $2f $02 $5a $6c
	.db $3b $20 $af $79
	.db $4c $01 $0b $38
	.db $4e $02 $0b $68
	.db $53 $04 $0b $6a
	.db $72 $01 $af $8d
	.db $89 $04 $0b $62
	.db $89 $04 $5d $67
	.db $8f $08 $0b $81
	.db $8f $08 $5e $52
	.db $c7 $01 $0b $68
	.db $00

; @addr{62dd}
@group5SwitchData:
	.db $00

;;
; @addr{62de}
applySingleTileChanges:
	ld a,(wActiveRoom)
	ld b,a
	call getThisRoomFlags
	ld c,a
	ld d,>wRoomLayout
	ld a,(wActiveGroup)
	ld hl,singleTileChangeGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
@next:
	; Check room
	ldi a,(hl)
	cp b
	jr nz,@notMatch

	ld a,(hl)
	cp $f0
	jr z,@unlinkedOnly

	cp $f1
	jr z,@linkedOnly

	cp $f2
	jr z,@finishedGameOnly

	ld a,(hl)
	and c
	jr z,@notMatch

@match:
	inc hl
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld (de),a
	jr @next

@notMatch:
	ld a,(hl)
	or a
	ret z

	inc hl
	inc hl
	inc hl
	jr @next

@unlinkedOnly:
	call checkIsLinkedGame
	jr nz,@notMatch
	jr @match

@linkedOnly:
	call checkIsLinkedGame
	jr z,@notMatch
	jr @match

@finishedGameOnly:
	ld a,GLOBALFLAG_FINISHEDGAME
	push hl
	call checkGlobalFlag
	pop hl
	ret z
	jr @match
