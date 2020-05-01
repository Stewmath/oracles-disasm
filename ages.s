; Main file for Oracle of Ages, US version

.include "include/rominfo.s"
.include "include/emptyfill.s"
.include "include/constants.s"
.include "include/structs.s"
.include "include/wram.s"
.include "include/hram.s"
.include "include/macros.s"
.include "include/script_commands.s"
.include "include/simplescript_commands.s"
.include "include/movementscript_commands.s"

.include "objects/macros.s"
.include "include/gfxDataMacros.s"

.include "build/textDefines.s"


.BANK $00 SLOT 0
.ORG 0

	.include "code/bank0.s"

.BANK $01 SLOT 1
.ORG 0

	.include "code/bank1.s"


.BANK $02 SLOT 1
.ORG 0

	.include "code/bank2.s"


.BANK $03 SLOT 1
.ORG 0

	.include "code/bank3.s"
	.include "code/ages/cutscenes/miscCutscenes.s"
.ifdef BUILD_VANILLA
	.include "code/ages/garbage/bank3end.s"
.endif

.BANK $04 SLOT 1
.ORG 0

.include "code/bank4.s"


; These 2 includes must be in the same bank
.include "build/data/roomPacks.s"
.include "build/data/musicAssignments.s"
.include "build/data/roomLayoutGroupTable.s"
.include "build/data/tilesets.s"
.include "build/data/tilesetAssignments.s"

.include "code/animations.s"

.include "build/data/uniqueGfxHeaders.s"
.include "build/data/uniqueGfxHeaderPointers.s"
.include "build/data/animationGroups.s"
.include "build/data/animationGfxHeaders.s"
.include "build/data/animationData.s"

;;
; @addr{5fef}
applyAllTileSubstitutions:
	call replacePollutionWithWaterIfPollutionFixed		; $5fef
	call applySingleTileChanges		; $5ff2
	call applyStandardTileSubstitutions		; $5ff5
	call replaceOpenedChest		; $5ff8
	ld a,(wActiveGroup)		; $5ffb
	and $06			; $5ffe
	cp NUM_SMALL_GROUPS		; $6000
	jr nz,+			; $6002

	call replaceShutterForLinkEntering		; $6004
	call replaceSwitchTiles		; $6007
	call replaceToggleBlocks		; $600a
	call replaceJabuTilesIfUnderwater		; $600d
+
	call applyRoomSpecificTileChanges		; $6010
	ld a,(wActiveGroup)		; $6013
	cp $02			; $6016
	ret nc			; $6018

	; In the overworld

	call replaceBreakableTileOverPortal		; $6019
	call replaceBreakableTileOverLinkTimeWarpingIn		; $601c
	ld a,(wLinkTimeWarpTile)		; $601f
	or a			; $6022
	ret z			; $6023

	; If link was sent back from trying to travel through time, clear the
	; breakable tile at his position (if it exists) so he can safely
	; return.

	ld c,a			; $6024
	dec c			; $6025
	ld b,>wRoomLayout		; $6026
	ld a,(bc)		; $6028
	ld e,a			; $6029
	ld hl,@tileReplacementDict		; $602a
	call lookupKey		; $602d
	ret nc			; $6030

	ld (bc),a		; $6031
	ret			; $6032

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
	ld hl,wPortalGroup		; $6046
	ld a,(wActiveGroup)		; $6049
	cp (hl)			; $604c
	ret nz			; $604d

	inc l			; $604e
	ld a,(wActiveRoom)		; $604f
	cp (hl)			; $6052
	ret nz			; $6053

	inc l			; $6054
	ld c,(hl)		; $6055
_removeBreakableTileForTimeWarp:
	ld b,>wRoomLayout		; $6056
	ld a,(bc)		; $6058
	ld e,a			; $6059
	ld hl,@tileReplacementDict		; $605a
	call lookupKey		; $605d
	ret nc			; $6060

	ld (bc),a		; $6061
	ret			; $6062

; @addr{6063}
@tileReplacementDict:
	.db $c5 $3a
	.db $c8 $3a
	.db $04 $3a
	.db $00

;;
; @addr{606a}
replaceBreakableTileOverLinkTimeWarpingIn:
	ld a,(wWarpTransition)		; $606a
	and $0f			; $606d
	cp TRANSITION_DEST_TIMEWARP		; $606f
	ret nz			; $6071

	ld a,(wWarpDestPos)		; $6072
	ld c,a			; $6075
	jr _removeBreakableTileForTimeWarp		; $6076

;;
; @addr{6078}
replacePollutionWithWaterIfPollutionFixed:
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $6078
	call checkGlobalFlag		; $607a
	ret z			; $607d

	ld a,(wTilesetFlags)		; $607e
	bit TILESETFLAG_BIT_OUTDOORS,a			; $6081
	ret z			; $6083

	ld de,@aboveWaterReplacement		; $6084
	and TILESETFLAG_UNDERWATER		; $6087
	jr z,+			; $6089
	ld de,@belowWaterReplacement		; $608b
+
	jr replaceTiles		; $608e

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
	ld a,(de)		; $6096
	or a			; $6097
	ret z			; $6098

	ld b,a			; $6099
	inc de			; $609a
	ld a,(de)		; $609b
	inc de			; $609c
	call findTileInRoom		; $609d
	jr nz,replaceTiles	; $60a0

	ld (hl),b		; $60a2
	ld c,a			; $60a3
	ld a,l			; $60a4
	or a			; $60a5
	jr z,replaceTiles	; $60a6
--
	dec l			; $60a8
	ld a,c			; $60a9
	call backwardsSearch		; $60aa
	jr nz,replaceTiles	; $60ad

	ld (hl),b		; $60af
	ld c,a			; $60b0
	ld a,l			; $60b1
	or a			; $60b2
	jr z,replaceTiles	; $60b3
	jr --			; $60b5

;;
; Substitutes various tiles when particular room flag bits (0-3, 7) are set.
; @addr{60b7}
applyStandardTileSubstitutions:
	call getThisRoomFlags		; $60b7
	ldh (<hFF8B),a	; $60ba
	ld hl,@bit0		; $60bc
	bit 0,a			; $60bf
	call nz,@locFunc		; $60c1

	ld hl,@bit1		; $60c4
	ldh a,(<hFF8B)	; $60c7
	bit 1,a			; $60c9
	call nz,@locFunc		; $60cb

	ld hl,@bit2		; $60ce
	ldh a,(<hFF8B)	; $60d1
	bit 2,a			; $60d3
	call nz,@locFunc		; $60d5

	ld hl,@bit3		; $60d8
	ldh a,(<hFF8B)	; $60db
	bit 3,a			; $60dd
	call nz,@locFunc		; $60df

	ld hl,@bit7		; $60e2
	ldh a,(<hFF8B)	; $60e5
	bit 7,a			; $60e7
	ret z			; $60e9
@locFunc:
	ld a,(wActiveCollisions)		; $60ea
	rst_addDoubleIndex			; $60ed
	ldi a,(hl)		; $60ee
	ld h,(hl)		; $60ef
	ld l,a			; $60f0
	ld e,l			; $60f1
	ld d,h			; $60f2
	jr replaceTiles			; $60f3

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
	call checkDungeonUsesToggleBlocks		; $617c
	ret z			; $617f

	callab roomGfxChanges.func_02_7a77		; $6180
	ld de,@state1		; $6188
	ld a,(wToggleBlocksState)		; $618b
	or a			; $618e
	jr nz,+			; $618f
	ld de,@state2		; $6191
+
	jp replaceTiles		; $6194

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
	ld a,(wDungeonIndex)		; $61a1
	cp $07			; $61a4
	ret nz			; $61a6

	ld a,(wTilesetFlags)		; $61a7
	and TILESETFLAG_SIDESCROLL			; $61aa
	ret nz			; $61ac

	; Only substitute tiles if on the first non-underwater floor
	ld a,(wDungeonFloor)		; $61ad
	ld b,a			; $61b0
	ld a,(wJabuWaterLevel)		; $61b1
	and $07			; $61b4
	cp b			; $61b6
	ret nz			; $61b7

	ld de,@data1		; $61b8
	call replaceTiles		; $61bb
	ld de,@data2		; $61be
	jp replaceTiles		; $61c1

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
	ldbc >wRoomLayout, (LARGE_ROOM_HEIGHT-1)<<4 + (LARGE_ROOM_WIDTH-1)	; $61d8
--
	ld a,(bc)		; $61db
	push bc			; $61dc
	sub $78			; $61dd
	cp $08			; $61df
	call c,@temporarilyOpenDoor		; $61e1
	pop bc			; $61e4
	dec c			; $61e5
	jr nz,--		; $61e6
	ret			; $61e8

; Replaces a door at position bc with empty floor, and adds an interaction to
; re-close it when link moves away (for minecart doors only)
@temporarilyOpenDoor:
	ld de,@shutterData		; $61e9
	call addDoubleIndexToDe		; $61ec
	ld a,(de)		; $61ef
	ldh (<hFF8B),a	; $61f0
	inc de			; $61f2
	ld a,(de)		; $61f3
	ld e,a			; $61f4
	ld a,(wScrollMode)		; $61f5
	and $08			; $61f8
	jr z,@doneReplacement	; $61fa

	ld a,(wLinkObjectIndex)		; $61fc
	ld h,a			; $61ff
	ld a,(wScreenTransitionDirection)		; $6200
	xor $02			; $6203
	ld d,a			; $6205
	ld a,e			; $6206
	and $03			; $6207
	cp d			; $6209
	ret nz			; $620a

	ld a,(wScreenTransitionDirection)		; $620b
	bit 0,a			; $620e
	jr nz,@horizontal			; $6210
; vertical
	and $02			; $6212
	ld l,<w1Link.xh		; $6214
	ld a,(hl)		; $6216
	jr nz,@down		; $6217
@up:
	and $f0			; $6219
	swap a			; $621b
	or $a0			; $621d
	jr @doReplacement		; $621f
@down:
	and $f0			; $6221
	swap a			; $6223
	jr @doReplacement		; $6225

@horizontal:
	and $02			; $6227
	ld l,<w1Link.yh		; $6229
	ld a,(hl)		; $622b
	jr nz,@left	; $622c
@right:
	and $f0			; $622e
	jr @doReplacement		; $6230
@left:
	and $f0			; $6232
	or $0e			; $6234

@doReplacement:
	; Only replace if link is standing on the tile.
	cp c			; $6236
	jr nz,@doneReplacement	; $6237

	push bc			; $6239
	ld c,a			; $623a
	ld a,(bc)		; $623b
	sub $78			; $623c
	cp $08			; $623e
	jr nc,+			; $6240

	ldh a,(<hFF8B)	; $6242
	ld (bc),a		; $6244
+
	pop bc			; $6245

@doneReplacement:
	; If bit 7 is set, don't add an auto-shutter interaction.
	ld a,e			; $6246
	bit 7,a			; $6247
	ret nz			; $6249

	and $7f			; $624a
	ld e,a			; $624c

	; If not in a dungeon, don't add an auto-shutter.
	ld a,(wTilesetFlags)		; $624d
	bit TILESETFLAG_BIT_DUNGEON,a			; $6250
	ret z			; $6252

	call getFreeInteractionSlot		; $6253
	ret nz			; $6256

	ld (hl),$1e		; $6257
	inc l			; $6259
	ld (hl),e		; $625a
	ld l,Interaction.yh		; $625b
	ld (hl),c		; $625d
	ret			; $625e

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
	call getThisRoomFlags		; $626f
	bit ROOMFLAG_BIT_ITEM,a			; $6272
	ret z			; $6274

	call getChestData		; $6275
	ld d,>wRoomLayout		; $6278
	ld a,TILEINDEX_CHEST_OPENED	; $627a
	ld (de),a		; $627c
	ret			; $627d

;;
; Replaces switch tiles and whatever they control if the switch is set.
; Groups 4 and 5 only.
; @addr{627e}
replaceSwitchTiles:
	ld hl,@group4SwitchData		; $627e
	ld a,(wActiveGroup)		; $6281
	sub NUM_SMALL_GROUPS			; $6284
	jr z,+			; $6286

	dec a			; $6288
	ret nz			; $6289

	ld hl,@group5SwitchData		; $628a
+
	ld a,(wActiveRoom)		; $628d
	ld b,a			; $6290
	ld a,(wSwitchState)		; $6291
	ld c,a			; $6294
	ld d,>wRoomLayout		; $6295
@next:
	ldi a,(hl)		; $6297
	or a			; $6298
	ret z			; $6299

	; Check room
	cp b			; $629a
	jr nz,@skip3Bytes	; $629b

	; Check if corresponding bit of wSwitchState is set
	ldi a,(hl)		; $629d
	and c			; $629e
	jr z,@skip2Bytes	; $629f

	ldi a,(hl)		; $62a1
	ld e,(hl)		; $62a2
	inc hl			; $62a3
	ld (de),a		; $62a4
	jr @next		; $62a5

@skip3Bytes:
	inc hl			; $62a7
@skip2Bytes:
	inc hl			; $62a8
	inc hl			; $62a9
	jr @next		; $62aa

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
	ld a,(wActiveRoom)		; $62de
	ld b,a			; $62e1
	call getThisRoomFlags		; $62e2
	ld c,a			; $62e5
	ld d,>wRoomLayout		; $62e6
	ld a,(wActiveGroup)		; $62e8
	ld hl,singleTileChangeGroupTable		; $62eb
	rst_addDoubleIndex			; $62ee
	ldi a,(hl)		; $62ef
	ld h,(hl)		; $62f0
	ld l,a			; $62f1
@next:
	; Check room
	ldi a,(hl)		; $62f2
	cp b			; $62f3
	jr nz,@notMatch		; $62f4

	ld a,(hl)		; $62f6
	cp $f0			; $62f7
	jr z,@unlinkedOnly	; $62f9

	cp $f1			; $62fb
	jr z,@linkedOnly	; $62fd

	cp $f2			; $62ff
	jr z,@finishedGameOnly	; $6301

	ld a,(hl)		; $6303
	and c			; $6304
	jr z,@notMatch		; $6305

@match:
	inc hl			; $6307
	ldi a,(hl)		; $6308
	ld e,a			; $6309
	ldi a,(hl)		; $630a
	ld (de),a		; $630b
	jr @next		; $630c

@notMatch:
	ld a,(hl)		; $630e
	or a			; $630f
	ret z			; $6310

	inc hl			; $6311
	inc hl			; $6312
	inc hl			; $6313
	jr @next		; $6314

@unlinkedOnly:
	call checkIsLinkedGame		; $6316
	jr nz,@notMatch		; $6319
	jr @match			; $631b

@linkedOnly:
	call checkIsLinkedGame		; $631d
	jr z,@notMatch		; $6320
	jr @match			; $6322

@finishedGameOnly:
	ld a,GLOBALFLAG_FINISHEDGAME		; $6324
	push hl			; $6326
	call checkGlobalFlag		; $6327
	pop hl			; $632a
	ret z			; $632b
	jr @match		; $632c

.include "build/data/singleTileChanges.s"
.include "code/ages/roomSpecificTileChanges.s"

;;
; Unused?
; @addr{6ba8}
func_04_6ba8:
	ld d,>wRoomLayout		; $6ba8
	ldi a,(hl)		; $6baa
	ld c,a			; $6bab
--
	ldi a,(hl)		; $6bac
	cp $ff			; $6bad
	ret z			; $6baf

	ld e,a			; $6bb0
	ld a,c			; $6bb1
	ld (de),a		; $6bb2
	jr --			; $6bb3

;;
; Fills a square in wRoomLayout using the data at hl.
; Data format:
; - Top-left position (YX)
; - Height
; - Width
; - Tile value
; @addr{6bb5}
fillRectInRoomLayout:
	ldi a,(hl)		; $6bb5
	ld e,a			; $6bb6
	ldi a,(hl)		; $6bb7
	ld b,a			; $6bb8
	ldi a,(hl)		; $6bb9
	ld c,a			; $6bba
	ldi a,(hl)		; $6bbb
	ld d,a			; $6bbc
	ld h,>wRoomLayout		; $6bbd
--
	ld a,d			; $6bbf
	ld l,e			; $6bc0
	push bc			; $6bc1
-
	ldi (hl),a		; $6bc2
	dec c			; $6bc3
	jr nz,-			; $6bc4

	ld a,e			; $6bc6
	add $10			; $6bc7
	ld e,a			; $6bc9
	pop bc			; $6bca
	dec b			; $6bcb
	jr nz,--		; $6bcc
	ret			; $6bce

;;
; Like fillRect, but reads a series of bytes for the tile values instead of
; just one.
; @addr{6bcf}
drawRectInRoomLayout:
	ld a,(de)		; $6bcf
	inc de			; $6bd0
	ld h,>wRoomLayout		; $6bd1
	ld l,a			; $6bd3
	ldh (<hFF8B),a	; $6bd4
	ld a,(de)		; $6bd6
	inc de			; $6bd7
	ld c,a			; $6bd8
	ld a,(de)		; $6bd9
	inc de			; $6bda
	ldh (<hFF8D),a	; $6bdb
---
	ldh a,(<hFF8D)	; $6bdd
	ld b,a			; $6bdf
--
	ld a,(de)		; $6be0
	inc de			; $6be1
	ldi (hl),a		; $6be2
	dec b			; $6be3
	jr nz,--		; $6be4

	ldh a,(<hFF8B)	; $6be6
	add $10			; $6be8
	ldh (<hFF8B),a	; $6bea
	ld l,a			; $6bec
	dec c			; $6bed
	jr nz,---		; $6bee
	ret			; $6bf0

;;
; Generate the buffers at w3VramTiles and w3VramAttributes based on the tiles
; loaded in wRoomLayout.
; @addr{6bf1}
generateW3VramTilesAndAttributes:
	ld a,:w3VramTiles		; $6bf1
	ld ($ff00+R_SVBK),a	; $6bf3
	ld hl,wRoomLayout		; $6bf5
	ld de,w3VramTiles		; $6bf8
	ld c,$0b		; $6bfb
---
	ld b,$10		; $6bfd
--
	push bc			; $6bff
	ldi a,(hl)		; $6c00
	push hl			; $6c01
	call setHlToTileMappingDataPlusATimes8		; $6c02
	push de			; $6c05
	call write4BytesToVramLayout		; $6c06
	pop de			; $6c09
	set 2,d			; $6c0a
	call write4BytesToVramLayout		; $6c0c
	res 2,d			; $6c0f
	ld a,e			; $6c11
	sub $1f			; $6c12
	ld e,a			; $6c14
	pop hl			; $6c15
	pop bc			; $6c16
	dec b			; $6c17
	jr nz,--		; $6c18

	ld a,$20		; $6c1a
	call addAToDe		; $6c1c
	dec c			; $6c1f
	jr nz,---		; $6c20
	ret			; $6c22

;;
; Take 4 bytes from hl, write 2 to de, write the next 2 $20 bytes later.
; @addr{6c23}
write4BytesToVramLayout:
	ldi a,(hl)		; $6c23
	ld (de),a		; $6c24
	inc e			; $6c25
	ldi a,(hl)		; $6c26
	ld (de),a		; $6c27
	ld a,$1f		; $6c28
	add e			; $6c2a
	ld e,a			; $6c2b
	ldi a,(hl)		; $6c2c
	ld (de),a		; $6c2d
	inc e			; $6c2e
	ldi a,(hl)		; $6c2f
	ld (de),a		; $6c30
	ret			; $6c31

;;
; This updates up to 4 entries in w2ChangedTileQueue by writing a command to the vblank
; queue.
;
; @addr{6c32}
updateChangedTileQueue:
	ld a,(wScrollMode)		; $6c32
	and $0e			; $6c35
	ret nz			; $6c37

	; Update up to 4 tiles per frame
	ld b,$04		; $6c38
--
	push bc			; $6c3a
	call @handleSingleEntry		; $6c3b
	pop bc			; $6c3e
	dec b			; $6c3f
	jr nz,--		; $6c40

	xor a			; $6c42
	ld ($ff00+R_SVBK),a	; $6c43
	ret			; $6c45

;;
; @addr{6c46}
@handleSingleEntry:
	ld a,(wChangedTileQueueHead)		; $6c46
	ld b,a			; $6c49
	ld a,(wChangedTileQueueTail)		; $6c4a
	cp b			; $6c4d
	ret z			; $6c4e

	inc b			; $6c4f
	ld a,b			; $6c50
	and $1f			; $6c51
	ld (wChangedTileQueueHead),a		; $6c53
	ld hl,w2ChangedTileQueue		; $6c56
	rst_addDoubleIndex			; $6c59

	ld a,:w2ChangedTileQueue		; $6c5a
	ld ($ff00+R_SVBK),a	; $6c5c

	; b = New value of tile
	; c = position of tile
	ldi a,(hl)		; $6c5e
	ld c,(hl)		; $6c5f
	ld b,a			; $6c60

	ld a,c			; $6c61
	ldh (<hFF8C),a	; $6c62

	ld a,($ff00+R_SVBK)	; $6c64
	push af			; $6c66
	ld a,:w3VramTiles		; $6c67
	ld ($ff00+R_SVBK),a	; $6c69
	call getVramSubtileAddressOfTile		; $6c6b

	ld a,b			; $6c6e
	call setHlToTileMappingDataPlusATimes8		; $6c6f
	push hl			; $6c72

	; Write tile data
	push de			; $6c73
	call write4BytesToVramLayout		; $6c74
	pop de			; $6c77

	; Write mapping data
	ld a,$04		; $6c78
	add d			; $6c7a
	ld d,a			; $6c7b
	call write4BytesToVramLayout		; $6c7c

	ldh a,(<hFF8C)	; $6c7f
	pop hl			; $6c81
	call queueTileWriteAtVBlank		; $6c82

	pop af			; $6c85
	ld ($ff00+R_SVBK),a	; $6c86
	ret			; $6c88

;;
; @param	c	Tile index
; @param[out]	de	Address of tile c's top-left subtile in w3VramTiles
; @addr{6c89}
getVramSubtileAddressOfTile:
	ld a,c			; $6c89
	swap a			; $6c8a
	and $0f			; $6c8c
	ld hl,@addresses	; $6c8e
	rst_addDoubleIndex			; $6c91
	ldi a,(hl)		; $6c92
	ld h,(hl)		; $6c93
	ld l,a			; $6c94

	ld a,c			; $6c95
	and $0f			; $6c96
	add a			; $6c98
	rst_addAToHl			; $6c99
	ld e,l			; $6c9a
	ld d,h			; $6c9b
	ret			; $6c9c

@addresses:
	.dw w3VramTiles+$000
	.dw w3VramTiles+$040
	.dw w3VramTiles+$080
	.dw w3VramTiles+$0c0
	.dw w3VramTiles+$100
	.dw w3VramTiles+$140
	.dw w3VramTiles+$180
	.dw w3VramTiles+$1c0
	.dw w3VramTiles+$200
	.dw w3VramTiles+$240
	.dw w3VramTiles+$280

;;
; Called from "setInterleavedTile" in bank 0.
;
; Mixes two tiles together by using some subtiles from one, and some subtiles from the
; other. Used for example by shutter doors, which would combine the door and floor tiles
; for the partway-closed part of the animation.
;
; Tile 2 uses its tiles from the same "half" that tile 1 uses. For example, if tile 1 was
; placed on the right side, both tiles would use the right halves of their subtiles.
;
; @param	a	0: Top is tile 2, bottom is tile 1
;			1: Left is tile 1, right is tile 2
;			2: Top is tile 1, bottom is tile 2
;			3: Left is tile 2, right is tile 1
; @param	hFF8C	Position of tile to change
; @param	hFF8F	Tile index 1
; @param	hFF8E	Tile index 2
; @addr{6cb3}
setInterleavedTile_body:
	ldh (<hFF8B),a	; $6cb3

	ld a,($ff00+R_SVBK)	; $6cb5
	push af			; $6cb7
	ld a,:w3TileMappingData		; $6cb8
	ld ($ff00+R_SVBK),a	; $6cba

	ldh a,(<hFF8F)	; $6cbc
	call setHlToTileMappingDataPlusATimes8		; $6cbe
	ld de,$cec8		; $6cc1
	ld b,$08		; $6cc4
-
	ldi a,(hl)		; $6cc6
	ld (de),a		; $6cc7
	inc de			; $6cc8
	dec b			; $6cc9
	jr nz,-			; $6cca

	ldh a,(<hFF8E)	; $6ccc
	call setHlToTileMappingDataPlusATimes8		; $6cce
	ld de,$cec8		; $6cd1
	ldh a,(<hFF8B)	; $6cd4
	bit 0,a			; $6cd6
	jr nz,@interleaveDiagonally		; $6cd8

	bit 1,a			; $6cda
	jr nz,+			; $6cdc

	inc hl			; $6cde
	inc hl			; $6cdf
	call @copy2Bytes		; $6ce0
	jr ++			; $6ce3
+
	inc de			; $6ce5
	inc de			; $6ce6
	call @copy2Bytes		; $6ce7
++
	inc hl			; $6cea
	inc hl			; $6ceb
	inc de			; $6cec
	inc de			; $6ced
	call @copy2Bytes		; $6cee
	jr @queueWrite			; $6cf1

@copy2Bytes:
	ldi a,(hl)		; $6cf3
	ld (de),a		; $6cf4
	inc de			; $6cf5
	ldi a,(hl)		; $6cf6
	ld (de),a		; $6cf7
	inc de			; $6cf8
	ret			; $6cf9

@interleaveDiagonally:
	bit 1,a			; $6cfa
	jr nz,+			; $6cfc

	inc de			; $6cfe
	call @copy2BytesSeparated		; $6cff
	jr ++			; $6d02
+
	inc hl			; $6d04
	call @copy2BytesSeparated		; $6d05
++
	inc hl			; $6d08
	inc de			; $6d09
	call @copy2BytesSeparated		; $6d0a
	jr @queueWrite			; $6d0d

;;
; @addr{6d0f}
@copy2BytesSeparated:
	ldi a,(hl)		; $6d0f
	ld (de),a		; $6d10
	inc de			; $6d11
	inc hl			; $6d12
	inc de			; $6d13
	ldi a,(hl)		; $6d14
	ld (de),a		; $6d15
	inc de			; $6d16
	ret			; $6d17

;;
; @param	hFF8C	The position of the tile to refresh
; @param	$cec8	The data to write for that tile
; @addr{6d18}
@queueWrite:
	ldh a,(<hFF8C)	; $6d18
	ld hl,$cec8		; $6d1a
	call queueTileWriteAtVBlank		; $6d1d
	pop af			; $6d20
	ld ($ff00+R_SVBK),a	; $6d21
	ret			; $6d23

;;
; Set wram bank to 3 (or wherever hl is pointing to) before calling this.
;
; @param	a	Tile position
; @param	hl	Pointer to 8 bytes of tile data (usually somewhere in
;			w3TileMappingData)
; @addr{6d24}
queueTileWriteAtVBlank:
	push hl			; $6d24
	call @getTilePositionInVram		; $6d25
	add $20			; $6d28
	ld c,a			; $6d2a

	; Add a command to the vblank queue.
	ldh a,(<hVBlankFunctionQueueTail)	; $6d2b
	ld l,a			; $6d2d
	ld h,>wVBlankFunctionQueue
	ld a,(vblankCopyTileFunctionOffset)		; $6d30
	ldi (hl),a		; $6d33
	ld (hl),e		; $6d34
	inc l			; $6d35
	ld (hl),d		; $6d36
	inc l			; $6d37

	ld e,l			; $6d38
	ld d,h			; $6d39
	pop hl			; $6d3a
	ld b,$02		; $6d3b
--
	; Write 2 bytes to the command
	call @copy2Bytes		; $6d3d

	; Then give it the address for the lower half of the tile
	ld a,c			; $6d40
	ld (de),a		; $6d41
	inc e			; $6d42

	; Then write the next 2 bytes
	call @copy2Bytes		; $6d43
	dec b			; $6d46
	jr nz,--		; $6d47

	; Update the tail of the vblank queue
	ld a,e			; $6d49
	ldh (<hVBlankFunctionQueueTail),a	; $6d4a
	ret			; $6d4c

;;
; @addr{6d4d}
@copy2Bytes:
	ldi a,(hl)		; $6d4d
	ld (de),a		; $6d4e
	inc e			; $6d4f
	ldi a,(hl)		; $6d50
	ld (de),a		; $6d51
	inc e			; $6d52
	ret			; $6d53

;;
; @param	a	Tile position
; @param[out]	a	Same as 'e'
; @param[out]	de	Somewhere in the vram bg map
; @addr{6d54}
@getTilePositionInVram:
	ld e,a			; $6d54
	and $f0			; $6d55
	swap a			; $6d57
	ld d,a			; $6d59
	ld a,e			; $6d5a
	and $0f			; $6d5b
	add a			; $6d5d
	ld e,a			; $6d5e
	ld a,(wScreenOffsetX)		; $6d5f
	swap a			; $6d62
	add a			; $6d64
	add e			; $6d65
	and $1f			; $6d66
	ld e,a			; $6d68
	ld a,(wScreenOffsetY)		; $6d69
	swap a			; $6d6c
	add d			; $6d6e
	and $0f			; $6d6f
	ld hl,vramBgMapTable		; $6d71
	rst_addDoubleIndex			; $6d74
	ldi a,(hl)		; $6d75
	add e			; $6d76
	ld e,a			; $6d77
	ld d,(hl)		; $6d78
	ret			; $6d79

;;
; Called from loadTilesetData in bank 0.
;
; @addr{6d7a}
loadTilesetData_body:
	call getAdjustedRoomGroup		; $6d7a
	ld hl,roomTilesetsGroupTable
	rst_addDoubleIndex			; $6d80
	ldi a,(hl)		; $6d81
	ld h,(hl)		; $6d82
	ld l,a			; $6d83
	ld a,(wActiveRoom)		; $6d84
	rst_addAToHl			; $6d87
	ld a,(hl)		; $6d88
	ldh (<hFF8D),a	; $6d89
	call @func_6d94		; $6d8b
	call func_6de7		; $6d8e
	ret nc			; $6d91
	ldh a,(<hFF8D)	; $6d92
@func_6d94:
	and $80			; $6d94
	ldh (<hFF8B),a	; $6d96
	ldh a,(<hFF8D)	; $6d98
	and $7f			; $6d9a
	call multiplyABy8		; $6d9c
	ld hl,tilesetData
	add hl,bc		; $6da2
	ldi a,(hl)		; $6da3
	ld e,a			; $6da4
	ldi a,(hl)		; $6da5
	ld (wTilesetFlags),a		; $6da6
	bit TILESETFLAG_BIT_DUNGEON,a			; $6da9
	jr z,+

	ld a,e			; $6dad
	and $0f			; $6dae
	ld (wDungeonIndex),a		; $6db0
	jr ++
+
	ld a,$ff		; $6db5
	ld (wDungeonIndex),a		; $6db7
++
	ld a,e			; $6dba
	swap a			; $6dbb
	and $07			; $6dbd
	ld (wActiveCollisions),a		; $6dbf

	ld b,$06		; $6dc2
	ld de,wTilesetUniqueGfx		; $6dc4
@copyloop:
	ldi a,(hl)		; $6dc7
	ld (de),a		; $6dc8
	inc e			; $6dc9
	dec b			; $6dca
	jr nz,@copyloop

	ld e,wTilesetUniqueGfx&$ff
	ld a,(de)		; $6dcf
	ld b,a			; $6dd0
	ldh a,(<hFF8B)	; $6dd1
	or b			; $6dd3
	ld (de),a		; $6dd4
	ret			; $6dd5

;;
; Returns the group to load the room layout from, accounting for bit 0 of the room flag
; which tells it to use the underwater group
;
; @param[out]	a,b	The corrected group number
; @addr{6dd6}
getAdjustedRoomGroup:
	ld a,(wActiveGroup)		; $6dd6
	ld b,a			; $6dd9
	cp $02			; $6dda
	ret nc			; $6ddc
	call getThisRoomFlags		; $6ddd
	rrca			; $6de0
	jr nc,+
	set 1,b			; $6de3
+
	ld a,b			; $6de5
	ret			; $6de6

;;
; Modifies hFF8D to indicate changes to a room (ie. jabu flooding)?
; @addr{6de7}
func_6de7:
	call @func_04_6e0d		; $6de7
	ret c			; $6dea

	call @checkJabuFlooded		; $6deb
	ret c			; $6dee

	ld a,(wActiveGroup)		; $6def
	or a			; $6df2
	jr nz,@xor		; $6df3

	ld a,(wLoadingRoomPack)		; $6df5
	cp $7f			; $6df8
	jr nz,@xor		; $6dfa

	ld a,(wAnimalCompanion)		; $6dfc
	sub SPECIALOBJECTID_RICKY			; $6dff
	jr z,@xor		; $6e01

	ld b,a			; $6e03
	ldh a,(<hFF8D)	; $6e04
	add b			; $6e06
	ldh (<hFF8D),a	; $6e07
	scf			; $6e09
	ret			; $6e0a
@xor:
	xor a			; $6e0b
	ret			; $6e0c

;;
; @addr{6e0d}
@func_04_6e0d:
	ld a,(wActiveGroup)		; $6e0d
	or a			; $6e10
	ret nz			; $6e11

	ld a,(wActiveRoom)		; $6e12
	cp $38			; $6e15
	jr nz,+			; $6e17

	ld a,($c848)		; $6e19
	and $01			; $6e1c
	ret z			; $6e1e

	ld hl,hFF8D		; $6e1f
	inc (hl)		; $6e22
	inc (hl)		; $6e23
	scf			; $6e24
	ret			; $6e25
+
	xor a			; $6e26
	ret			; $6e27

;;
; @param[out]	cflag	Set if the current room is flooded in jabu-jabu?
; @addr{6e28}
@checkJabuFlooded:

.ifdef ROM_AGES
	ld a,(wDungeonIndex)		; $6e28
	cp $07			; $6e2b
	jr nz,++		; $6e2d

	ld a,(wTilesetFlags)		; $6e2f
	and TILESETFLAG_SIDESCROLL			; $6e32
	jr nz,++		; $6e34

	ld a,$11		; $6e36
	ld (wDungeonFirstLayout),a		; $6e38
	callab bank1.findActiveRoomInDungeonLayoutWithPointlessBankSwitch		; $6e3b
	ld a,(wJabuWaterLevel)		; $6e43
	and $07			; $6e46
	ld hl,@data		; $6e48
	rst_addAToHl			; $6e4b
	ld a,(wDungeonFloor)		; $6e4c
	ld bc,bitTable		; $6e4f
	add c			; $6e52
	ld c,a			; $6e53
	ld a,(bc)		; $6e54
	and (hl)		; $6e55
	ret z			; $6e56

	ldh a,(<hFF8D)	; $6e57
	inc a			; $6e59
	ldh (<hFF8D),a	; $6e5a
	scf			; $6e5c
	ret			; $6e5d
++
	xor a			; $6e5e
	ret			; $6e5f

; @addr{6e60}
@data:
	.db $00 $01 $03

.endif

;;
; Ages only: For tiles 0x40-0x7f, in the past, replace blue palettes (6) with red palettes (0). This
; is done so that tilesets can reuse attribute data for both the past and present tilesets.
;
; This is annoying so it's disabled in the hack-base branch, which separates all tileset data
; anyway.
;
; @addr{6e63}
setPastCliffPalettesToRed:
	ld a,(wActiveCollisions)		; $6e63
	or a			; $6e66
	jr nz,@done		; $6e68

	ld a,(wTilesetFlags)		; $6e6a
	and TILESETFLAG_PAST			; $6e6d
	jr z,@done		; $6e6e

	ld a,(wActiveRoom)		; $6e70
	cp <ROOM_AGES_138			; $6e73
	ret z			; $6e75

	; Replace all attributes that have palette "6" with palette "0"
	ld a,:w3TileMappingData		; $6e76
	ld ($ff00+R_SVBK),a	; $6e78
	ld hl,w3TileMappingData + $204		; $6e7a
	ld d,$06		; $6e7d
---
	ld b,$04		; $6e7f
--
	ld a,(hl)		; $6e81
	and $07			; $6e82
	cp d			; $6e84
	jr nz,+			; $6e85

	ld a,(hl)		; $6e87
	and $f8			; $6e88
	ld (hl),a		; $6e8a
+
	inc hl			; $6e8b
	dec b			; $6e8c
	jr nz,--		; $6e8d

	ld a,$04		; $6e8f
	rst_addAToHl			; $6e91
	ld a,h			; $6e92
	cp $d4			; $6e93
	jr c,---		; $6e95
@done:
	xor a			; $6e97
	ld ($ff00+R_SVBK),a	; $6e98
	ret			; $6e9a

;;
; @addr{6e9b}
func_04_6e9b:
	ld a,$02		; $6e9b
	ld ($ff00+R_SVBK),a	; $6e9d
	ld hl,wRoomLayout		; $6e9f
	ld de,$d000		; $6ea2
	ld b,$c0		; $6ea5
	call copyMemory		; $6ea7
	ld hl,wRoomCollisions		; $6eaa
	ld de,$d100		; $6ead
	ld b,$c0		; $6eb0
	call copyMemory		; $6eb2
	ld hl,$df00		; $6eb5
	ld de,$d200		; $6eb8
	ld b,$c0		; $6ebb
--
	ld a,$03		; $6ebd
	ld ($ff00+R_SVBK),a	; $6ebf
	ldi a,(hl)		; $6ec1
	ld c,a			; $6ec2
	ld a,$02		; $6ec3
	ld ($ff00+R_SVBK),a	; $6ec5
	ld a,c			; $6ec7
	ld (de),a		; $6ec8
	inc de			; $6ec9
	dec b			; $6eca
	jr nz,--		; $6ecb

	xor a			; $6ecd
	ld ($ff00+R_SVBK),a	; $6ece
	ret			; $6ed0

;;
; @addr{6ed1}
func_04_6ed1:
	ld a,$02		; $6ed1
	ld ($ff00+R_SVBK),a	; $6ed3
	ld hl,wRoomLayout		; $6ed5
	ld de,$d000		; $6ed8
	ld b,$c0		; $6edb
	call copyMemoryReverse		; $6edd
	ld hl,wRoomCollisions		; $6ee0
	ld de,$d100		; $6ee3
	ld b,$c0		; $6ee6
	call copyMemoryReverse		; $6ee8
	ld hl,$df00		; $6eeb
	ld de,$d200		; $6eee
	ld b,$c0		; $6ef1
--
	ld a,$02		; $6ef3
	ld ($ff00+R_SVBK),a	; $6ef5
	ld a,(de)		; $6ef7
	inc de			; $6ef8
	ld c,a			; $6ef9
	ld a,$03		; $6efa
	ld ($ff00+R_SVBK),a	; $6efc
	ld a,c			; $6efe
	ldi (hl),a		; $6eff
	dec b			; $6f00
	jr nz,--		; $6f01

	xor a			; $6f03
	ld ($ff00+R_SVBK),a	; $6f04
	ret			; $6f06

;;
; @addr{6f07}
func_04_6f07:
	ld hl,$d800		; $6f07
	ld de,$dc00		; $6f0a
	ld bc,$0200		; $6f0d
	call @locFunc		; $6f10
	ld hl,$dc00		; $6f13
	ld de,$de00		; $6f16
	ld bc,$0200		; $6f19
@locFunc:
	ld a,$03		; $6f1c
	ld ($ff00+R_SVBK),a	; $6f1e
	ldi a,(hl)		; $6f20
	ldh (<hFF8B),a	; $6f21
	ld a,$06		; $6f23
	ld ($ff00+R_SVBK),a	; $6f25
	ldh a,(<hFF8B)	; $6f27
	ld (de),a		; $6f29
	inc de			; $6f2a
	dec bc			; $6f2b
	ld a,b			; $6f2c
	or c			; $6f2d
	jr nz,@locFunc		; $6f2e
	ret			; $6f30

;;
; @addr{6f31}
func_04_6f31:
	ld hl,$dc00		; $6f31
	ld de,$d800		; $6f34
	ld bc,$0200		; $6f37
	call @locFunc		; $6f3a
	ld hl,$de00		; $6f3d
	ld de,$dc00		; $6f40
	ld bc,$0200		; $6f43
@locFunc:
	ld a,$06		; $6f46
	ld ($ff00+R_SVBK),a	; $6f48
	ldi a,(hl)		; $6f4a
	ldh (<hFF8B),a	; $6f4b
	ld a,$03		; $6f4d
	ld ($ff00+R_SVBK),a	; $6f4f
	ldh a,(<hFF8B)	; $6f51
	ld (de),a		; $6f53
	inc de			; $6f54
	dec bc			; $6f55
	ld a,b			; $6f56
	or c			; $6f57
	jr nz,@locFunc	; $6f58
	ret			; $6f5a

; .ORGA $6f5b

.include "build/data/warpData.s"


.ifdef BUILD_VANILLA

; Garbage data? Looks like a partial repeat of the last warp.
; @addr{7ede}
unknownData7ede:
	.db $ef $44 $43 $ff ; $7ede

.endif


.BANK $05 SLOT 1
.ORG 0

 m_section_force "Bank_5" NAMESPACE bank5

.include "code/bank5.s"
.include "build/data/tileTypeMappings.s"
.include "build/data/cliffTilesTable.s"

.ifdef BUILD_VANILLA

; Garbage data

	.db $52 $06
	.db $53 $06
	.db $48 $02
	.db $49 $02
	.db $4a $02
	.db $4b $02
	.db $4d $03
	.db $54 $09
	.db $55 $0a
	.db $56 $0b
	.db $57 $0c
	.db $60 $0d
	.db $8a $0f
	.db $00

	.db $16 $10
	.db $18 $10
	.db $17 $90
	.db $19 $90
	.db $f4 $01
	.db $0f $01
	.db $0c $01
	.db $1a $30
	.db $1b $20
	.db $1c $20
	.db $1d $20
	.db $1e $20
	.db $1f $20
	.db $20 $40
	.db $22 $40
	.db $02 $00
	.db $00

	.db $7d $7d
	.db $8c $7d
	.db $8c $7d
	.db $9c $7d
	.db $7d $7d
	.db $8c $7d
	.db $05 $10
	.db $06 $10
	.db $07 $10
	.db $0a $18
	.db $0b $08
	.db $64 $10
	.db $ff $10
	.db $00

	.db $b0 $10
	.db $b1 $18
	.db $b2 $00
	.db $b3 $08
	.db $c1 $10
	.db $c2 $18
	.db $c3 $00
	.db $c4 $08
	.db $00

.endif

.ends


.BANK $06 SLOT 1
.ORG 0


 m_section_superfree "Bank_6" NAMESPACE bank6

	.include "code/interactableTiles.s"
	.include "code/specialObjectAnimationsAndDamage.s"
	.include "code/breakableTiles.s"

	.include "code/items/parentItemUsage.s"

	.include "code/items/shieldParent.s"
	.include "code/items/otherSwordsParent.s"
	.include "code/items/switchHookParent.s"
	.include "code/items/caneOfSomariaParent.s"
	.include "code/items/swordParent.s"
	.include "code/items/harpFluteParent.s"
	.include "code/items/seedsParent.s"
	.include "code/items/shovelParent.s"
	.include "code/items/boomerangParent.s"
	.include "code/items/bombsBraceletParent.s"
	.include "code/items/featherParent.s"
	.include "code/items/magnetGloveParent.s"

	.include "code/items/parentItemCommon.s"


; Following table affects how an item can be used (ie. how it interacts with other items
; being used).
;
; Data format:
;  b0: bits 4-7: Priority (higher value = higher precedence)
;                Gets written to high nibble of Item.enabled
;      bits 0-3: Determines what "parent item" slot to use when the button is pressed.
;                0: Item is unusable.
;                1: Uses w1ParentItem3 or 4.
;                2: Uses w1ParentItem3 or 4, but only one instance of the item may exist
;                   at once. (boomerang, seed satchel)
;                3: Uses w1ParentItem2. If an object is already there, it gets
;                   overwritten if this object's priority is high enough.
;                   (sword, cane, bombs, etc)
;                4: Same as 2, but the item can't be used if w1ParentItem2 is in use (Link
;                   is holding a sword or something)
;                5: Uses w1ParentItem5 (only if not already in use). (shield, flute, harp)
;                6-7: invalid
;  b1: Byte to check input against when the item is first used
;
; @addr{55be}
_itemUsageParameterTable:
	.db $00 <wGameKeysPressed	; ITEMID_NONE
	.db $05 <wGameKeysPressed	; ITEMID_SHIELD
	.db $03 <wGameKeysJustPressed	; ITEMID_PUNCH
	.db $23 <wGameKeysJustPressed	; ITEMID_BOMB
	.db $03 <wGameKeysJustPressed	; ITEMID_CANE_OF_SOMARIA
	.db $63 <wGameKeysJustPressed	; ITEMID_SWORD
	.db $02 <wGameKeysJustPressed	; ITEMID_BOOMERANG
	.db $00 <wGameKeysJustPressed	; ITEMID_ROD_OF_SEASONS
	.db $00 <wGameKeysJustPressed	; ITEMID_MAGNET_GLOVES
	.db $00 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK_HELPER
	.db $73 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK
	.db $00 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK_CHAIN
	.db $73 <wGameKeysJustPressed	; ITEMID_BIGGORON_SWORD
	.db $02 <wGameKeysJustPressed	; ITEMID_BOMBCHUS
	.db $05 <wGameKeysJustPressed	; ITEMID_FLUTE
	.db $43 <wGameKeysJustPressed	; ITEMID_SHOOTER
	.db $00 <wGameKeysJustPressed	; ITEMID_10
	.db $05 <wGameKeysJustPressed	; ITEMID_HARP
	.db $00 <wGameKeysJustPressed	; ITEMID_12
	.db $00 <wGameKeysJustPressed	; ITEMID_SLINGSHOT
	.db $00 <wGameKeysJustPressed	; ITEMID_14
	.db $13 <wGameKeysJustPressed	; ITEMID_SHOVEL
	.db $13 <wGameKeysPressed	; ITEMID_BRACELET
	.db $01 <wGameKeysJustPressed	; ITEMID_FEATHER
	.db $00 <wGameKeysJustPressed	; ITEMID_18
	.db $02 <wGameKeysJustPressed	; ITEMID_SEED_SATCHEL
	.db $00 <wGameKeysJustPressed	; ITEMID_DUST
	.db $00 <wGameKeysJustPressed	; ITEMID_1b
	.db $00 <wGameKeysJustPressed	; ITEMID_1c
	.db $00 <wGameKeysJustPressed	; ITEMID_MINECART_COLLISION
	.db $00 <wGameKeysJustPressed	; ITEMID_FOOLS_ORE
	.db $00 <wGameKeysJustPressed	; ITEMID_1f



; Data format:
;  b0: bit 7:    If set, the corresponding bit in wLinkUsingItem1 will be set.
;      bits 4-6: Value for bits 0-2 of Item.var3f
;      bits 0-3: Determines parent item's relatedObj2?
;                A value of $6 refers to w1WeaponItem.
;  b1: Animation to set Link to? (see constants/linkAnimations.s)
;
; @addr{55fe}
_linkItemAnimationTable:
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_NONE
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_SHIELD
	.db $d6  LINK_ANIM_MODE_21	; ITEMID_PUNCH
	.db $30  LINK_ANIM_MODE_LIFT	; ITEMID_BOMB
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_CANE_OF_SOMARIA
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_SWORD
	.db $b0  LINK_ANIM_MODE_21	; ITEMID_BOOMERANG
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_ROD_OF_SEASONS
	.db $60  LINK_ANIM_MODE_NONE	; ITEMID_MAGNET_GLOVES
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_HELPER
	.db $f6  LINK_ANIM_MODE_21	; ITEMID_SWITCH_HOOK
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_CHAIN
	.db $f6  LINK_ANIM_MODE_23	; ITEMID_BIGGORON_SWORD
	.db $30  LINK_ANIM_MODE_21	; ITEMID_BOMBCHUS
	.db $70  LINK_ANIM_MODE_FLUTE	; ITEMID_FLUTE
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SHOOTER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_10
	.db $70  LINK_ANIM_MODE_HARP_2	; ITEMID_HARP
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_12
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SLINGSHOT
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_14
	.db $b0  LINK_ANIM_MODE_DIG_2	; ITEMID_SHOVEL
	.db $40  LINK_ANIM_MODE_LIFT_3	; ITEMID_BRACELET
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_FEATHER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_18
	.db $a0  LINK_ANIM_MODE_21	; ITEMID_SEED_SATCHEL
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_DUST
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1b
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1c
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_MINECART_COLLISION
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_FOOLS_ORE
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1f

	.include "code/specialObjects/minecart.s"
	.include "code/specialObjects/raft.s"

	.include "build/data/specialObjectAnimationData.s"
	.include "code/ages/cutscenes/companionCutscenes.s"
	.include "code/ages/cutscenes/linkCutscenes.s"
	.include "build/data/signText.s"
	.include "build/data/breakableTileCollisionTable.s"

;;
; @addr{79dc}
specialObjectLoadAnimationFrameToBuffer:
	ld hl,w1Companion.visible		; $79dc
	bit 7,(hl)		; $79df
	ret z			; $79e1

	ld l,<w1Companion.var32		; $79e2
	ld a,(hl)		; $79e4
	call _getSpecialObjectGraphicsFrame		; $79e5
	ret z			; $79e8

	ld a,l			; $79e9
	and $f0			; $79ea
	ld l,a			; $79ec
	ld de,w6SpecialObjectGfxBuffer|(:w6SpecialObjectGfxBuffer)		; $79ed
	jp copy256BytesFromBank		; $79f0


	; Garbage data/code

.ifdef BUILD_VANILLA

	m_BreakableTileData %00000000 %00010000 %0000 $0 $df $37 ; $2f
	m_BreakableTileData %00110000 %00000000 %0000 $0 $06 $01 ; $30
	m_BreakableTileData %00100101 %00000001 %0000 $0 $06 $01 ; $31
	m_BreakableTileData %00111110 %10000000 %1011 $0 $1f $00 ; $32


_fake_specialObjectLoadAnimationFrameToBuffer:
	ld hl,w1Companion.visible		; $7a07
	bit 7,(hl)		; $7a0a
	ret z			; $7a0c

	ld l,<w1Companion.var32		; $7a0d
	ld a,(hl)		; $7a0f
	call $4524		; $7a10
	ret z			; $7a13

	ld a,l			; $7a14
	and $f0			; $7a15
	ld l,a			; $7a17
	ld de,w6SpecialObjectGfxBuffer|(:w6SpecialObjectGfxBuffer)		; $7a18
	jp $3f17		; $7a1b


	ld a,(hl)		; $7a1e
	ret z			; $7a1f

	ld l,<w1Companion.var32		; $7a20
	ld a,(hl)		; $7a22
	call $4524		; $7a23
	ret z			; $7a26

	ld a,l			; $7a27
	and $f0			; $7a28
	ld l,a			; $7a2a
	ld de,w6SpecialObjectGfxBuffer|(:w6SpecialObjectGfxBuffer)		; $7a2b
	jp $3f31		; $7a2e
.endif

.ends

.BANK $07 SLOT 1
.ORG 0

.include "code/fileManagement.s"

 ; This section can't be superfree, since it must be in the same bank as section
 ; "Bank_7_Data".
 m_section_free "Enemy_Part_Collisions" namespace "bank7"
	.include "code/collisionEffects.s"
.ends


 m_section_superfree "Item_Code" namespace "itemCode"
.include "code/updateItems.s"

	.include "build/data/itemConveyorTilesTable.s"
	.include "build/data/itemPassableCliffTilesTable.s"
	.include "build/data/itemPassableTilesTable.s"
	.include "code/itemCodes.s"
	.include "build/data/itemAttributes.s"
	.include "data/itemAnimations.s"
.ends


 ; This section can't be superfree, since it must be in the same bank as section
 ; "Enemy_Part_Collisions".
 m_section_free "Bank_7_Data" namespace "bank7"

	.include "build/data/enemyActiveCollisions.s"
	.include "build/data/partActiveCollisions.s"
	.include "build/data/objectCollisionTable.s"

	; Garbage data follows (repeats of object collision table)

.ifdef BUILD_VANILLA
	; 0x72
	.db                     $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; 0x73
	.db $03 $00 $00 $07 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; 0x74
	.db $02 $17 $16 $16 $15 $15 $15 $16 $1b $15 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; 0x75
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $2a $2a $2a $2a $2a $00

	; 0x76
	.db $02 $1f $1f $1f $1c $1c $1c $1c $1c $1c $00 $1c $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $1c $1c $1c $20 $20 $20 $20 $20 $20 $00

	; 0x77
	.db $3b $00 $00 $1e $1c $1c $1c $1c $1c $00 $00 $00 $1c $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; 0x78
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $1c $00 $00 $00 $00 $00 $00 $00 $00

	; 0x79
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $31 $31 $31 $31 $31 $00

	; 0x7a
	.db $02 $00 $00 $1e $00 $1c $1c $00 $1c $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; 0x7b
	.db $03 $00 $06 $06 $16 $16 $16 $16 $16 $16 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $2d $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; 0x7c
	.db $3d $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

.endif

.ends


.BANK $08 SLOT 1
.ORG 0


 m_section_force Interaction_Code_Bank08 NAMESPACE interactionBank08

	.include "code/ages/interactionCode/bank08.s"

.ends


.BANK $09 SLOT 1
.ORG 0

 m_section_force Interaction_Code_Bank09 NAMESPACE interactionBank09

	.include "code/ages/interactionCode/bank09.s"

.ends


.BANK $0a SLOT 1
.ORG 0


 m_section_force Interaction_Code_Bank0a NAMESPACE interactionBank0a

	.include "code/ages/interactionCode/bank0a.s"

.ends


.BANK $0b SLOT 1
.ORG 0


 m_section_force Interaction_Code_Bank0b NAMESPACE interactionBank0b

	.include "code/ages/interactionCode/bank0b.s"

.ifdef BUILD_VANILLA

; Garbage function here (partial repeat of the above function)

;;
; @addr{7fa1}
func_7fa1:
	call $258f		; $7fa1
	ret nc			; $7fa4
	jp $3b5c		; $7fa5

.endif

.ends


.BANK $0c SLOT 1
.ORG 0

	.include "code/scripting.s"
	.include "scripts/ages/scripts.s"


.BANK $0d SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0d NAMESPACE bank0d

	.include "code/enemyCommon.s"
	.include "code/ages/enemyCode/bank0d.s"

.ends

 m_section_superfree Enemy_Animations
	.include "build/data/enemyAnimations.s"
.ends


.BANK $0e SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0e NAMESPACE bank0e

	.include "code/enemyCommon.s"
	.include "code/ages/enemyCode/bank0e.s"
	.include "build/data/movingSidescrollPlatform.s"

; Garbage repeated data
.ifdef BUILD_VANILLA

_fake1:
	.db $00
	.dw $7f71

_fake2:
	.db SPEED_80
	.db $00
@@loop:
	ms_left  $30
	ms_wait  30
	ms_right $a0
	ms_wait  30
	ms_loop  @@loop
.endif

.ends

.BANK $0f SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0f NAMESPACE bank0f

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "code/ages/enemyCode/bank0f.s"

.ends

.BANK $10 SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank10 NAMESPACE bank10

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "code/ages/enemyCode/bank10.s"

.ends


; Some blank space here ($6e1f-$6eff)

.ORGA $6f00

 m_section_force Interaction_Code_Bank10 NAMESPACE interactionBank10

	.include "code/ages/interactionCode/bank10.s"

.ends


.BANK $11 SLOT 1
.ORG 0

	.define PART_BANK $11
	.export PART_BANK

 m_section_force "Bank_11" NAMESPACE "partCode"

	.include "code/partCommon.s"
	.include "code/ages/partCode.s"

.ifdef BUILD_VANILLA

; Garbage function follows (partial repeat of the last function)

;;
; @addr{7f64}
func_11_7f64:
	call $20ef		; $7f64
	ld h,$cf		; $7f67
	ld (hl),$00		; $7f69
	ld a,$98		; $7f6b
	call $0510		; $7f6d
	jp $1eaf		; $7f70

.endif

.ends


.BANK $12 SLOT 1
.ORG 0

	.include "code/objectLoading.s"

 m_section_superfree "Room_Code" namespace "roomSpecificCode"

	.include "code/ages/roomSpecificCode.s"

.ends

 m_section_free "Objects_2" namespace "objectData"

	.include "objects/ages/mainData.s"
	.include "objects/ages/extraData3.s"

.ends

 m_section_superfree "Underwater Surface Data"

	.include "code/ages/underwaterSurface.s"

.ENDS

 m_section_free "Objects_3" namespace "objectData"

	.include "objects/ages/extraData4.s"

.ends


.BANK $13 SLOT 1
.ORG 0

	.define BASE_OAM_DATA_BANK $13
	.export BASE_OAM_DATA_BANK

	.include "build/data/specialObjectOamData.s"
	.include "data/itemOamData.s"
	.include "build/data/enemyOamData.s"

.BANK $14 SLOT 1
.ORG 0

 m_section_superfree "Terrain_Effects" NAMESPACE "terrainEffects"

; @addr{4000}
shadowAnimation:
	.db $01
	.db $13 $04 $20 $08

; @addr{4005}
greenGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $08
	.db $11 $07 $24 $08

; @addr{400e}
blueGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $09
	.db $11 $07 $24 $09

; @addr{4017}
_puddleAnimationFrame0:
	.db $02
	.db $16 $03 $22 $08
	.db $16 $05 $22 $28

; @addr{4020}
orangeGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $0b
	.db $11 $07 $24 $0b

; @addr{4029}
greenGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $28
	.db $11 $07 $24 $28

; @addr{4032}
blueGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $29
	.db $11 $07 $24 $29

; @addr{403b}
_puddleAnimationFrame1:
	.db $02
	.db $16 $02 $22 $08
	.db $16 $06 $22 $28

; @addr{4044}
orangeGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $2b
	.db $11 $07 $24 $2b

; @addr{404d}
_puddleAnimationFrame2:
	.db $02
	.db $17 $01 $22 $08
	.db $17 $07 $22 $28

; @addr{4056}
_puddleAnimationFrame3:
	.db $02
	.db $18 $00 $22 $08
	.db $18 $08 $22 $28

; @addr{405f}
puddleAnimationFrames:
	.dw _puddleAnimationFrame0
	.dw _puddleAnimationFrame1
	.dw _puddleAnimationFrame2
	.dw _puddleAnimationFrame3

.ends

.include "build/data/interactionOamData.s"
.include "build/data/partOamData.s"


.include "code/ages/bank15.s"


.BANK $16 SLOT 1
.ORG 0

.include "code/serialFunctions.s"

 m_section_force Bank16 NAMESPACE bank16

;;
; @param	d	Interaction index (should be of type INTERACID_TREASURE)
; @addr{451e}
interactionLoadTreasureData:
	ld e,Interaction.subid	; $451e
	ld a,(de)		; $4520
	ld e,Interaction.var30		; $4521
	ld (de),a		; $4523
	ld hl,treasureObjectData		; $4524
--
	call multiplyABy4		; $4527
	add hl,bc		; $452a
	bit 7,(hl)		; $452b
	jr z,+			; $452d

	inc hl			; $452f
	ldi a,(hl)		; $4530
	ld h,(hl)		; $4531
	ld l,a			; $4532
	ld e,Interaction.var03		; $4533
	ld a,(de)		; $4535
	jr --			; $4536
+
	; var31 = spawn mode
	ldi a,(hl)		; $4538
	ld b,a			; $4539
	swap a			; $453a
	and $07			; $453c
	ld e,Interaction.var31		; $453e
	ld (de),a		; $4540

	; var32 = collect mode
	ld a,b			; $4541
	and $07			; $4542
	inc e			; $4544
	ld (de),a		; $4545

	; var33 = ?
	ld a,b			; $4546
	and $08			; $4547
	inc e			; $4549
	ld (de),a		; $454a

	; var34 = parameter (value of 'c' for "giveTreasure")
	ldi a,(hl)		; $454b
	inc e			; $454c
	ld (de),a		; $454d

	; var35 = low text ID
	ldi a,(hl)		; $454e
	inc e			; $454f
	ld (de),a		; $4550

	; subid = graphics to use
	ldi a,(hl)		; $4551
	ld e,Interaction.subid		; $4552
	ld (de),a		; $4554
	ret			; $4555


.include "build/data/data_4556.s"

; Used in CUTSCENE_BLACK_TOWER_ESCAPE
; @addr{4d05}
oamData_4d05:
	.db $26
	.db $e0 $10 $02 $01
	.db $e0 $18 $04 $01
	.db $e0 $20 $06 $01
	.db $e0 $28 $08 $01
	.db $f0 $08 $14 $01
	.db $f0 $10 $16 $01
	.db $f0 $18 $18 $01
	.db $f0 $20 $1a $01
	.db $f0 $28 $1c $01
	.db $00 $08 $28 $01
	.db $00 $10 $2a $01
	.db $00 $18 $2c $01
	.db $00 $20 $2e $01
	.db $00 $28 $30 $01
	.db $10 $08 $3a $01
	.db $10 $10 $3c $01
	.db $10 $18 $3e $01
	.db $10 $20 $40 $01
	.db $10 $28 $42 $01
	.db $20 $08 $00 $01
	.db $20 $10 $0a $01
	.db $20 $18 $0c $01
	.db $20 $20 $0e $01
	.db $20 $28 $10 $01
	.db $30 $08 $1e $01
	.db $30 $10 $20 $01
	.db $30 $18 $22 $01
	.db $30 $20 $24 $01
	.db $30 $28 $26 $01
	.db $40 $08 $32 $01
	.db $40 $10 $34 $01
	.db $40 $18 $36 $01
	.db $50 $08 $44 $01
	.db $50 $10 $46 $01
	.db $50 $18 $48 $01
	.db $40 $20 $38 $01
	.db $60 $08 $00 $01
	.db $60 $10 $12 $01

; Used by CUTSCENE_BLACK_TOWER_ESCAPE
; @addr{4d9e}
oamData_4d9e:
	.db $26
	.db $e0 $f8 $02 $21
	.db $e0 $f0 $04 $21
	.db $e0 $e8 $06 $21
	.db $e0 $e0 $08 $21
	.db $f0 $00 $14 $21
	.db $f0 $f8 $16 $21
	.db $f0 $f0 $18 $21
	.db $f0 $e8 $1a $21
	.db $f0 $e0 $1c $21
	.db $00 $00 $28 $21
	.db $00 $f8 $2a $21
	.db $00 $f0 $2c $21
	.db $00 $e8 $2e $21
	.db $00 $e0 $30 $21
	.db $10 $00 $3a $21
	.db $10 $f8 $3c $21
	.db $10 $f0 $3e $21
	.db $10 $e8 $40 $21
	.db $10 $e0 $42 $21
	.db $20 $00 $00 $21
	.db $20 $f8 $0a $21
	.db $20 $f0 $0c $21
	.db $20 $e8 $0e $21
	.db $20 $e0 $10 $21
	.db $30 $00 $1e $21
	.db $30 $f8 $20 $21
	.db $30 $f0 $22 $21
	.db $30 $e8 $24 $21
	.db $30 $e0 $26 $21
	.db $40 $00 $32 $21
	.db $40 $f8 $34 $21
	.db $40 $f0 $36 $21
	.db $50 $00 $44 $21
	.db $50 $f8 $46 $21
	.db $50 $f0 $48 $21
	.db $40 $e8 $38 $21
	.db $60 $00 $00 $21
	.db $60 $f8 $12 $21

; @addr{4e37}
_oamData_4e37:
	.db $28
	.db $44 $21 $00 $00
	.db $44 $29 $02 $00
	.db $54 $29 $04 $00
	.db $34 $1b $06 $00
	.db $50 $d9 $08 $00
	.db $08 $e0 $0a $00
	.db $30 $d8 $0c $01
	.db $20 $d1 $0e $00
	.db $fb $ee $10 $02
	.db $fb $f6 $12 $02
	.db $0b $e6 $14 $02
	.db $0b $ee $16 $02
	.db $1b $e6 $18 $02
	.db $1b $ee $1a $02
	.db $00 $48 $1c $01
	.db $58 $40 $1e $00
	.db $10 $58 $22 $01
	.db $00 $50 $20 $01
	.db $38 $50 $24 $01
	.db $28 $50 $26 $03
	.db $28 $58 $28 $03
	.db $16 $4a $2a $04
	.db $16 $52 $2c $04
	.db $e8 $d0 $2e $01
	.db $f8 $d0 $30 $04
	.db $f8 $d8 $32 $04
	.db $00 $da $34 $02
	.db $e8 $e5 $36 $01
	.db $20 $0f $38 $04
	.db $20 $20 $3a $04
	.db $db $38 $40 $07
	.db $db $40 $42 $07
	.db $e8 $35 $44 $07
	.db $e8 $3d $46 $07
	.db $fc $30 $48 $07
	.db $f8 $38 $4a $07
	.db $00 $40 $4c $07
	.db $18 $38 $4e $07
	.db $10 $40 $50 $07
	.db $20 $40 $52 $07

; @addr{4ed8}
_oamData_4ed8:
	.db $12
	.db $10 $08 $00 $0c
	.db $10 $10 $02 $0c
	.db $10 $18 $04 $0c
	.db $20 $08 $0c $0c
	.db $20 $10 $0e $0c
	.db $20 $18 $10 $0c
	.db $31 $23 $06 $0d
	.db $31 $2b $08 $0d
	.db $31 $3b $06 $2d
	.db $31 $33 $08 $2d
	.db $41 $23 $06 $4d
	.db $41 $2b $08 $4d
	.db $41 $3b $06 $6d
	.db $41 $33 $08 $6d
	.db $2c $1d $0a $0d
	.db $2c $25 $0a $2d
	.db $4c $3a $0a $0d
	.db $4c $42 $0a $2d

; @addr{4f21}
_oamData_4f21:
	.db $0d
	.db $38 $d3 $02 $03
	.db $32 $f8 $0c $01
	.db $f8 $d8 $10 $07
	.db $f8 $e0 $12 $07
	.db $f8 $e8 $14 $07
	.db $f7 $f7 $16 $07
	.db $22 $f8 $1a $03
	.db $1a $00 $1c $03
	.db $11 $e2 $1e $00
	.db $11 $ea $20 $00
	.db $01 $ea $22 $00
	.db $11 $f2 $26 $00
	.db $01 $f2 $24 $00

; @addr{4f56}
_oamData_4f56:
	.db $07
	.db $60 $f8 $00 $02
	.db $48 $d3 $04 $03
	.db $40 $e0 $06 $07
	.db $40 $e8 $08 $07
	.db $40 $f0 $0a $07
	.db $42 $f8 $0e $01
	.db $68 $e0 $18 $02

; @addr{4f73}
_oamData_4f73:
	.db $1e
	.db $e8 $e8 $00 $06
	.db $e8 $f0 $02 $06
	.db $f8 $e0 $04 $06
	.db $00 $d8 $06 $06
	.db $08 $e8 $08 $06
	.db $08 $f0 $0a $06
	.db $f8 $f6 $0c $06
	.db $10 $e0 $0e $06
	.db $18 $e8 $10 $07
	.db $18 $da $12 $04
	.db $18 $e2 $14 $04
	.db $08 $d0 $16 $06
	.db $40 $d8 $18 $06
	.db $30 $f8 $1a $04
	.db $28 $d3 $1c $00
	.db $f0 $f8 $1e $00
	.db $48 $f8 $20 $04
	.db $36 $f5 $22 $04
	.db $58 $00 $24 $05
	.db $3b $18 $26 $05
	.db $3b $20 $28 $05
	.db $38 $3c $2a $03
	.db $14 $38 $2c $05
	.db $28 $48 $2e $00
	.db $30 $51 $30 $00
	.db $30 $60 $32 $00
	.db $28 $68 $34 $04
	.db $f8 $40 $36 $00
	.db $00 $48 $38 $00
	.db $00 $50 $3a $05

; @addr{4fec}
_oamData_4fec:
	.db $0a
	.db $48 $4d $88 $05
	.db $48 $55 $8a $05
	.db $47 $45 $84 $03
	.db $47 $4d $86 $03
	.db $39 $4e $90 $03
	.db $43 $59 $8c $03
	.db $39 $46 $8e $03
	.db $3b $3c $92 $03
	.db $49 $4c $80 $02
	.db $49 $54 $82 $02

.ends


.include "code/staticObjects.s"
.include "build/data/staticDungeonObjects.s"
.include "build/data/chestData.s"

 m_section_force Bank16_2 NAMESPACE bank16

.include "build/data/treasureObjectData.s"

;;
; Used in the room in present Mermaid's Cave with the changing floor
;
; @param	b	Floor state (0/1)
; @addr{5766}
loadD6ChangingFloorPatternToBigBuffer:
	ld a,b			; $5766
	add a			; $5767
	ld hl,@changingFloorData		; $5768
	rst_addDoubleIndex			; $576b
	push hl			; $576c
	ldi a,(hl)		; $576d
	ld d,(hl)		; $576e
	ld e,a			; $576f
	ld b,$41		; $5770
	ld hl,wBigBuffer		; $5772
	call copyMemoryReverse		; $5775

	pop hl			; $5778
	inc hl			; $5779
	inc hl			; $577a
	ldi a,(hl)		; $577b
	ld d,(hl)		; $577c
	ld e,a			; $577d
	ld b,$41		; $577e
	ld hl,wBigBuffer+$80		; $5780
	call copyMemoryReverse		; $5783

	ldh a,(<hActiveObject)	; $5786
	ld d,a			; $5788
	ret			; $5789

@changingFloorData:
	.dw @tiles0_bottomHalf
	.dw @tiles0_topHalf

	.dw @tiles1
	.dw @tiles1

@tiles0_bottomHalf:
	.db $a0 $a0 $a0 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4
	.db $00

@tiles0_topHalf:
	.db $a0 $a0 $a0 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $a0 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $a0 $f4 $f4 $f4 $f4 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $a0 $ff
	.db $a0 $a0 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $ff
	.db $f4 $f4 $f4 $f4
	.db $00

@tiles1:
	.db $a0 $a0 $f4 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $a0 $a0 $f4 $f4 $f4 $f4 $f4 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $a0 $a0 $a0 $f4 $f4 $a0 $ff
	.db $a0 $a0 $f4 $a0
	.db $00

.ends

.include "build/data/interactionAnimations.s"
.include "build/data/partAnimations.s"

.BANK $17 SLOT 1 ; Seasons: should be bank $16
.ORG 0

	.include "build/data/paletteData.s"
	.include "build/data/tilesetCollisions.s"
	.include "build/data/smallRoomLayoutTables.s"


.ifdef ROM_AGES
.ifdef BUILD_VANILLA

	; Leftovers from seasons. No clue what it actually is though.
	; @addr{6ee3}

	.db     $dc $56 $57 $cc $dc $dc $57
	.db $cc $47 $dc $57 $46 $47 $47 $dc
	.db $6b $30 $7b $22 $31 $6b $22 $7b
	.db $46 $47 $34 $34 $34 $34 $24 $25
	.db $cc $cc $6b $6b $4a $4b $3a $3b
	.db $67 $67 $77 $77 $76 $66 $67 $70
	.db $66 $76 $70 $67 $77 $71 $62 $62
	.db $71 $77 $62 $62 $21 $21 $31 $30
	.db $21 $21 $30 $31 $27 $26 $37 $36
	.db $2d $2c $3d $3c $2b $2a $3b $3a
	.db $44 $44 $54 $54 $45 $45 $55 $55
	.db $4c $4d $5c $5d $2e $2f $2e $2f
	.db $2f $2e $2f $2e $53 $53 $53 $53
	.db $6e $6c $67 $70 $6c $6e $70 $67
	.db $76 $76 $76 $76 $72 $73 $64 $65
	.db $60 $68 $70 $78 $4a $4b $80 $80
	.db $5a $5b $80 $80 $2e $2e $3e $3e
	.db $71 $71 $61 $61 $71 $71 $53 $53
	.db $74 $75 $63 $63 $71 $71 $62 $62
	.db $cc $cc $2a $2b $5c $5c $5c $5c
	.db $68 $6f $7e $5f $6f $6e $4f $4e
	.db $7d $7c $4c $4d $6e $6f $4e $4f
	.db $3c $3d $3e $3f $5e $5e $65 $66
	.db $65 $66 $5e $5e $5c $5c $6c $6c
	.db $64 $6f $7e $7f $34 $35 $36 $37
	.db $35 $34 $37 $36 $38 $39 $3a $3b
	.db $39 $38 $3b $3a $0b $0b $0b $0b
	.db $6f $7c $52 $51 $7d $7c $55 $56
	.db $7d $7c $7c $7d $6e $6f $51 $52
	.db $40 $41 $43 $44 $42 $74 $45 $75
	.db $46 $47 $49 $4a $48 $50 $4b $59
	.db $74 $42 $75 $45 $41 $40 $44 $43
	.db $50 $48 $59 $4b $47 $46 $4a $49
	.db $78 $69 $7a $7b $69 $78 $7b $7a
	.db $6f $57 $5f $7e $58 $7c $53 $56
	.db $7d $67 $55 $54 $31 $32 $33 $33
	.db $32 $31 $33 $33 $03 $07 $12 $07
	.db $06 $19 $11 $02 $79 $78 $7b $7a
	.db $77 $76 $7a $7b $76 $77 $7b $7a
	.db $78 $79 $7a $7b $5e $5e $5e $5e
	.db $6f $64 $7f $7e $6f $6e $5f $7e
	.db $6e $6f $7e $5f $71 $71 $71 $71
	.db $72 $72 $72 $72 $73 $73 $73 $73
	.db $5d $5d $6d $6d $18 $11 $15 $16
	.db $11 $18 $17 $15 $33 $83 $8e $8f
	.db $83 $33 $8e $8f $18 $18 $07 $03
	.db $6f $6e $52 $51 $18 $19 $15 $11
	.db $19 $18 $11 $15 $38 $38 $38 $38
	.db $39 $39 $39 $39 $3a $3a $3a $3a
	.db $3b $3b $3b $3b $39 $3a $3b $3b
	.db $3a $39 $3b $3b $da $0d $0d $db
	.db $fc $fc $fc $fc $ed $ed $ed $ed
	.db $ec $ec $ec $ec $80 $a3 $a3 $1f
	.db $80 $a3 $1f $80 $0b $0c $1c $1d
	.db $0c $0b $1d $1c $0c $0c $1d $1d
	.db $1b $1b $1b $1b $9a $9a $9a $9a
	.db $98 $98 $9b $9b $99 $98 $9a $ed
	.db $98 $98 $ed $ed $98 $99 $ed $9a
	.db $9a $ed $9a $ed $ed $9a $ed $9a
	.db $9a $ed $9c $9b $ed $ed $9b $9b
	.db $ed $9a $9b $9c $5f $5e $cb $cc
	.db $aa $aa $aa $aa $05 $c4 $25 $c4
	.db $a8 $a8 $a8 $a8 $c7 $c6 $d7 $d6
	.db $c4 $05 $c4 $25 $46 $30 $46 $2a
	.db $31 $32 $2b $2b $33 $46 $2c $46
	.db $44 $45 $46 $20 $45 $45 $21 $22
	.db $45 $44 $23 $46 $d5 $d5 $78 $78
	.db $e4 $e5 $b2 $b3 $e5 $e4 $b2 $b3
	.db $e7 $e6 $f7 $f6 $49 $49 $49 $49
	.db $46 $3a $54 $55 $3b $3b $55 $55
	.db $3c $46 $55 $54 $46 $30 $46 $40
	.db $31 $32 $41 $42 $33 $46 $43 $46
	.db $46 $30 $46 $60 $31 $32 $61 $62
	.db $33 $46 $63 $46 $dd $b0 $d8 $c0
	.db $b1 $d9 $c1 $de $07 $06 $17 $16
	.db $e1 $d9 $d9 $de $46 $30 $46 $2d
	.db $31 $32 $2e $2e $33 $46 $2f $46
	.db $46 $50 $54 $55 $51 $52 $55 $55
	.db $53 $46 $55 $54 $46 $70 $54 $55
	.db $71 $72 $55 $55 $73 $46 $55 $54
	.db $26 $27 $d8 $d9 $28 $28 $dd $de
	.db $de $d0 $d9 $e0 $d1 $dd $e1 $d8
	.db $f1 $f2 $f3 $f4 $27 $26 $dc $dd
	.db $de $e0 $dd $dc $46 $3d $54 $55
	.db $3e $3e $55 $55 $3f $46 $55 $54
	.db $64 $6d $74 $7d $6d $64 $7d $74
	.db $35 $36 $37 $38 $e5 $e5 $b2 $24
	.db $e5 $e5 $04 $b3 $47 $65 $57 $75
	.db $6f $48 $7f $58 $47 $48 $47 $48
	.db $5f $5e $5a $5a $4a $4a $4f $4e
	.db $4b $5b $5c $5d $4a $4d $5a $5d
	.db $47 $49 $47 $49 $d8 $d9 $dd $de
	.db $dd $de $d8 $d9 $d9 $d8 $de $dd
	.db $de $dd $d9 $d8 $de $d9 $dc $de
	.db $c2 $34 $d2 $d3 $14 $c3 $d2 $d3
	.db $e2 $e3 $de $dd $a9 $a9 $a9 $a9
	.db $5f $5b $4f $5b $4b $5e $4b $4e
	.db $4c $4d $4b $5b $4c $4a $5c $5a
	.db $47 $49 $57 $59 $4b $5e $5c $5a
	.db $5f $5b $5a $5d $49 $48 $49 $48
	.db $49 $65 $59 $75 $6f $49 $7f $59
	.db $6a $69 $02 $02 $6a $6c $01 $7b
	.db $13 $7a $00 $02 $6a $7c $01 $7b
	.db $6b $7b $7b $6b $7b $6b $6b $7b
	.db $7a $69 $6b $7a $6a $69 $69 $6a
	.db $6c $6b $69 $7c $6b $6c $7c $69
	.db $03 $6b $13 $7b $13 $6b $13 $7b
	.db $02 $01 $7a $13 $5c $5d $57 $58
	.db $7a $7b $69 $7a $02 $02 $69 $6a
	.db $01 $6b $69 $6c $00 $02 $13 $7a
	.db $6c $69 $7b $01 $6b $13 $7b $13
	.db $7b $7a $7a $6a $6a $7c $6c $7b
	.db $7c $69 $7b $6c $13 $6b $12 $7b
	.db $6a $7a $7a $6b $7a $13 $02 $01
	.db $b4 $b5 $c4 $a8 $b5 $b6 $a8 $c6
	.db $b7 $4c $c7 $4b $4d $b7 $5b $c7
	.db $b6 $b5 $c6 $a8 $b5 $b4 $a8 $c4
	.db $c4 $a8 $d4 $d5 $a8 $d6 $d5 $d5
	.db $dc $77 $dd $56 $77 $d8 $56 $de
	.db $dd $44 $50 $51 $d8 $d9 $dc $47
	.db $dc $dd $48 $48 $de $d8 $46 $d9
	.db $dd $de $d8 $5b $dd $60 $d9 $70
	.db $de $63 $d8 $73 $d9 $dd $d8 $5e
	.db $de $d9 $5f $5f $d8 $de $5e $de
	.db $d8 $de $5b $d9 $60 $d9 $70 $dd
	.db $63 $de $73 $dc $ac $ac $ac $ac
	.db $ad $ad $ad $ad $4c $4a $4b $4e
	.db $4b $5b $4b $5b $4a $4d $4f $5b
	.db $d7 $5c $d5 $d5 $5d $d7 $d5 $d5
	.db $d6 $a8 $d5 $d5 $a8 $c4 $d5 $d4
	.db $96 $97 $a6 $a7 $ab $ab $ab $ab
	.db $be $be $a0 $a1 $ed $ed $17 $16
	.db $80 $80 $17 $16 $ea $ea $fa $fa
	.db $e5 $e5 $83 $83 $9d $9d $c8 $c8
	.db $b8 $b8 $c8 $c8 $8c $8e $8d $8f
	.db $f3 $f4 $f1 $f2 $f1 $f2 $f1 $f2
	.db $df $df $f0 $f0 $df $df $df $df
	.db $07 $01 $c4 $17 $01 $07 $16 $c4
	.db $04 $04 $fd $fd $fd $fd $14 $14
	.db $05 $17 $c4 $16 $16 $05 $17 $c4
	.db $02 $01 $09 $13 $01 $02 $13 $09
	.db $0a $1a $1a $0a $06 $19 $07 $11
	.db $19 $06 $11 $07 $05 $05 $c4 $c4
	.db $b4 $b1 $c0 $c1 $b2 $b7 $c2 $c3
	.db $9e $9f $ae $af $d0 $d1 $e0 $e1
	.db $d2 $d3 $e2 $e3 $61 $62 $71 $72
	.db $62 $61 $72 $71 $02 $11 $69 $6a
	.db $11 $02 $69 $6a $6a $69 $02 $11
	.db $6a $69 $11 $02 $d9 $dd $df $df
	.db $16 $92 $17 $93 $92 $17 $93 $16
	.db $66 $76 $5c $5d $d9 $d8 $df $df
	.db $76 $66 $5d $5c $dd $b5 $c7 $c5
	.db $b6 $de $c6 $c7 $d4 $d5 $e4 $e5
	.db $d6 $d7 $e6 $e7 $09 $13 $02 $01
	.db $94 $95 $a4 $a5 $99 $98 $9c $9b
	.db $99 $99 $9c $9c $98 $99 $9b $9c
	.db $9a $9a $9c $9c $99 $99 $9a $9a
	.db $eb $eb $fb $fb $90 $90 $91 $91
	.db $45 $45 $52 $4c $4f $4e $4d $4b
	.db $53 $54 $56 $57 $54 $53 $57 $56
	.db $69 $6a $7b $81 $6a $69 $81 $7b
	.db $7b $81 $79 $7a $81 $81 $7a $7a
	.db $81 $7b $7a $79 $55 $55 $58 $58
	.db $54 $60 $5d $70 $65 $54 $75 $5d
	.db $5d $79 $58 $57 $56 $59 $57 $57
	.db $59 $59 $57 $57 $59 $56 $57 $57
	.db $5d $50 $5d $5a $4d $4e $dd $de
	.db $4f $5d $55 $5d $6f $7c $6f $7c
	.db $55 $5d $55 $5d $51 $4c $5b $5c
	.db $5d $55 $5d $55 $4d $4e $d8 $d9
	.db $dc $52 $dd $55 $56 $5d $81 $5d
	.db $6f $6c $6f $6c $7c $7c $06 $03
	.db $d9 $de $59 $59 $d9 $55 $59 $6a
	.db $81 $5d $57 $58 $5d $56 $5d $69
	.db $52 $5f $55 $dd $5e $55 $de $55
	.db $69 $5d $79 $5d $6f $66 $7f $76
	.db $5e $5f $dd $de $5e $5f $d8 $d9
	.db $19 $4e $02 $5e $4e $19 $5e $02
	.db $78 $48 $57 $58 $4d $4d $5d $5d
	.db $4c $4b $5c $5b $50 $66 $60 $51
	.db $67 $68 $52 $53 $68 $67 $53 $52
	.db $66 $50 $51 $60 $63 $62 $74 $75
	.db $61 $60 $76 $70 $55 $54 $65 $64
	.db $6a $6b $6a $7b $75 $5a $57 $56
	.db $79 $79 $56 $56 $5a $75 $56 $57
	.db $6b $6a $7b $6a $bb $bc $58 $73
	.db $bb $bc $72 $71 $bb $bc $70 $70
	.db $bb $bc $71 $72 $bb $bc $73 $58
	.db $59 $51 $6a $5d $63 $62 $5c $5b
	.db $4a $4b $5b $5b $62 $63 $5b $5c
	.db $51 $59 $5d $6a $dd $b5 $c4 $c5
	.db $7a $6b $6a $7b $53 $52 $55 $54
	.db $52 $53 $54 $55 $6b $7a $7b $6a
	.db $f6 $f6 $f7 $f7 $61 $60 $6a $7b
	.db $60 $60 $65 $5a $60 $60 $69 $69
	.db $60 $60 $5a $65 $60 $61 $7b $7a
	.db $6a $5e $6e $cc $5f $6a $cb $6f
	.db $50 $50 $4c $4d $83 $83 $e8 $e9
	.db $d2 $d3 $94 $95 $d5 $d4 $d6 $d7
	.db $d4 $d5 $d7 $d6 $83 $d7 $83 $83
	.db $d7 $83 $83 $83 $83 $83 $83 $d5
	.db $d6 $d6 $d4 $d4 $83 $83 $d5 $83
	.db $d6 $d6 $83 $83 $d8 $d9 $d8 $d9
	.db $da $db $d8 $d9 $dc $dd $d8 $d9
	.db $50 $51 $52 $53 $f2 $f2 $02 $02
	.db $f3 $f3 $03 $03 $1a $1b $1c $1d
	.db $16 $17 $18 $19 $24 $25 $26 $27
	.db $20 $21 $22 $23 $90 $91 $90 $91
	.db $92 $93 $92 $93 $08 $09 $08 $09
	.db $d1 $d1 $82 $82 $0c $0d $0e $0f
	.db $82 $82 $0e $0f $0f $0e $0e $0f
	.db $45 $46 $46 $45 $47 $48 $49 $4a
	.db $4b $4c $4d $4e $8e $8f $9e $9f
	.db $96 $97 $98 $99 $04 $05 $98 $99
	.db $f4 $f5 $98 $99 $98 $99 $98 $99
	.db $a3 $a2 $a7 $a6 $a1 $a0 $a5 $a4
	.db $a0 $a1 $a4 $a5 $a2 $a3 $a6 $a7
	.db $a9 $a8 $ae $bc $a8 $a9 $bc $bd
	.db $a8 $a9 $bc $be $12 $13 $ae $bc
	.db $12 $13 $bc $bd $13 $12 $bc $be
	.db $a8 $a9 $b8 $b9 $12 $13 $14 $15
	.db $a8 $a8 $be $be $12 $12 $be $be
	.db $f0 $f1 $00 $01 $aa $ab $ba $bb
	.db $ba $bb $aa $ab $28 $29 $2a $2b
	.db $be $ac $ae $bc $ad $ae $bd $af
	.db $be $ac $ae $be $ac $ac $bc $be
	.db $ad $ad $be $bd $ad $ae $be $be
	.db $be $ad $bc $bd $ac $be $bc $bd
	.db $be $be $bc $bd $b2 $41 $ac $ad
	.db $40 $41 $ac $ad $b0 $f7 $ac $ad
	.db $f6 $f7 $ac $ad $96 $97 $54 $54
	.db $be $ac $b9 $b8 $ad $ac $b8 $b9
	.db $ad $bf $b8 $b9 $be $bf $b8 $b8
	.db $be $bf $14 $14 $be $ac $15 $14
	.db $ad $ac $14 $15 $ad $bf $14 $15
	.db $ea $eb $fa $fb $55 $eb $fa $fb
	.db $8c $8d $9c $9d $83 $83 $9c $9d
	.db $b4 $b5 $c4 $c5 $b5 $b4 $c5 $c4
	.db $58 $59 $56 $57 $59 $58 $57 $56
	.db $b2 $b3 $e2 $c7 $b2 $b3 $c6 $e3
	.db $b2 $b3 $c6 $c7 $b2 $b3 $e2 $e3
	.db $e0 $b7 $e2 $c7 $b7 $b6 $c7 $c6
	.db $b6 $b7 $c6 $c7 $b6 $e1 $c6 $e3
	.db $e0 $e1 $c2 $c3 $e0 $e1 $e2 $e3
	.db $e0 $b7 $c6 $c7 $b6 $e1 $c6 $c7
	.db $1e $1f $10 $11 $2c $2d $2e $2f
	.db $30 $31 $34 $35 $32 $33 $36 $37
	.db $42 $43 $44 $35 $0e $0e $0e $0e
	.db $28 $28 $28 $28 $4c $6c $0c $2c
	.db $0c $0c $0c $0c $08 $28 $08 $28
	.db $28 $28 $08 $28 $2d $2d $0d $2d
	.db $0d $0d $0d $2d $0c $2c $0c $2c
	.db $0e $2e $0e $2e $0a $0a $0a $0a
	.db $2a $0a $2a $0a $0f $0f $0f $0f
	.db $0d $0d $0d $0d $0b $0b $0b $0b
	.db $2b $2b $2b $2b $4b $4b $4b $4b
	.db $0b $2b $0b $2b $6b $6b $2b $2b
	.db $4b $6b $4b $6b $4b $4b $0b $0b
	.db $0c $0a $0c $0a $0a $0c $0a $0c
	.db $4c $4c $4c $4c $0a $2a $4a $6a
	.db $2c $2c $2c $2c $2c $0c $2c $0c
	.db $08 $08 $0c $2c $0c $2c $08 $08
	.db $2c $08 $2c $08 $08 $2c $08 $2c
	.db $0d $2d $0d $2d $6d $6d $2d $2d
	.db $4d $6d $4d $6d $4d $4d $0d $0d
	.db $2d $2d $6d $6d $0d $0d $4d $4d
	.db $6d $2d $2d $6d $0d $4d $4d $0d
	.db $2d $0a $0a $0a $0a $2a $0a $2a
	.db $2a $2d $2a $2a $0a $0a $4a $4a
	.db $2a $2a $6a $6a $4a $4a $2d $4a
	.db $4a $6a $4a $6a $6a $6a $6a $2d
	.db $0a $6a $0a $2a $4e $6e $4e $6e
	.db $08 $08 $08 $08 $0e $0e $0c $0e
	.db $0e $0e $0e $0c $0c $0c $0e $0e
	.db $0c $0c $0e $0c $0c $0e $0c $0e
	.db $0e $0c $0e $0c $0e $0e $0c $0c
	.db $0e $0c $0c $0c $0c $0c $0c $0e
	.db $0c $0e $0c $0c $0c $0e $0e $0e
	.db $0e $0c $0e $0e $0d $2d $4d $6d
	.db $0e $2e $4e $6e $6b $6b $6b $6b
	.db $08 $08 $0e $0e $0e $08 $0e $08
	.db $4e $4e $08 $08 $08 $2e $08 $2e
	.db $0b $0c $0b $0c $2c $2c $2b $2b
	.db $4b $4c $4b $4c $0c $0c $0b $0b
	.db $0e $0e $0e $0d $0e $0e $0d $2d
	.db $0e $0e $2d $0e $0e $0d $0c $0c
	.db $2d $0e $2c $2c $2c $2c $08 $08
	.db $08 $08 $2c $2c $0f $2f $0f $2f
	.db $4a $4a $4a $4a $2a $2a $2a $2a
	.db $4e $6e $0e $2e $2b $0c $2b $0c
	.db $0e $2a $0e $0a $0a $2e $2a $2e
	.db $0e $2a $0e $0e $0a $2e $0e $2e
	.db $0a $2a $0e $0e $0a $2a $2a $0a
	.db $4d $4d $4d $4d $2d $2d $2d $2d
	.db $0e $6e $0e $2e $0c $2c $4c $6c
	.db $08 $08 $0c $0c $0c $08 $0c $08
	.db $4c $4c $08 $08 $0d $2e $0d $0e
	.db $0e $2d $2e $2d $0d $2e $0d $0d
	.db $0e $2d $0d $2d $0e $2e $0d $0d
	.db $0e $2e $2e $0e $2c $2c $0c $0c
	.db $0c $0c $2c $2c $0d $0d $0c $0d
	.db $0d $0d $0d $0c $0c $0c $0d $0d
	.db $0c $0c $0d $0c $0c $0d $0c $0d
	.db $0d $0c $0d $0c $0d $0d $0c $0c
	.db $0d $0c $0c $0c $0c $0c $0c $0d
	.db $0c $0d $0c $0c $0c $0d $0d $0d
	.db $0d $0c $0d $0d $08 $08 $0b $2b
	.db $0b $2b $08 $08 $2b $08 $2b $08
	.db $08 $2b $08 $2b $0b $2b $4b $6b
	.db $2d $0c $0c $0c $2c $2d $2c $2c
	.db $0c $0c $4c $4c $2c $2c $6c $6c
	.db $4c $4c $2d $4c $4c $6c $4c $6c
	.db $6c $6c $6c $2d $0d $6d $0d $2d
	.db $4b $6b $0b $2b $0b $0b $0d $0d
	.db $08 $08 $0b $0b $0b $08 $0b $08
	.db $4b $4b $08 $08 $0e $4d $0c $0c
	.db $0c $2c $0c $0c $68 $68 $0c $0c
	.db $0c $68 $0c $68 $4c $4c $68 $68
	.db $68 $6c $68 $6c $0c $28 $0c $28
	.db $0c $0c $0c $08 $0c $0c $08 $08
	.db $0c $2c $28 $2c $0c $48 $0c $0c
	.db $0c $28 $08 $28 $08 $2c $08 $08
	.db $2d $2d $4d $4d $0d $2d $4d $4d
	.db $0d $0d $4d $6d $68 $2c $0c $2c
	.db $0d $2d $0d $0d $0d $0e $0d $0e
	.db $0e $0d $0e $0d $0d $0e $0d $0d
	.db $0e $0d $0d $0d $0e $0e $0d $0d
	.db $08 $08 $0e $2e $0e $2e $08 $08
	.db $2e $2e $2e $2e $2e $08 $2e $08
	.db $0f $2f $4f $6f $0d $2c $0d $0c
	.db $0c $2d $2c $2d $0d $2c $0d $0d
	.db $0c $2d $0d $2d $0c $2c $0d $0d
	.db $0c $2c $2c $0c $0b $0b $0c $0b
	.db $0b $0b $0b $0c $0c $0c $0b $0c
	.db $0c $0b $0c $0b $0b $0b $0c $0c
	.db $0b $0c $0c $0c $0c $0c $0c $0b
	.db $0b $28 $0b $2b $2b $0b $2b $0b
	.db $28 $2b $2b $2b $2f $6f $0f $4f
	.db $0b $2b $0c $2c $4c $6c $4b $6b
	.db $0e $0e $0e $2e $0e $2e $2e $2e
	.db $0d $2d $08 $08 $2d $0c $2d $0c
	.db $0c $0c $0e $2e $0c $0c $2e $2e
	.db $4b $6b $4b $68 $6b $4b $6b $4b
	.db $6b $6b $68 $6b $2f $2f $2f $2f
	.db $4b $0c $4b $0c $08 $28 $0e $2e
	.db $28 $28 $0e $2e $2c $0f $2c $0f
	.db $0f $2c $0f $2c $4a $2a $4a $2a
	.db $0a $0a $0c $0c $2a $2a $2c $2c
	.db $0b $0b $0f $0f $2f $0f $0f $2f
	.db $2b $0b $0b $0b $0a $2a $0c $0c
	.db $0b $0b $0a $2a $0c $0c $6b $4b
	.db $2d $2d $2c $2d $4d $4c $4d $4d
	.db $6c $6d $6d $6d $0c $0c $4f $4f
	.db $0f $0f $0c $0c $0c $0c $0f $4f
	.db $0c $0c $4f $2f $4f $0f $0c $0c
	.db $0f $6f $0c $0c $0b $2c $0b $0b
	.db $2c $2b $0b $2b $4b $0b $4b $0b
	.db $2b $4b $2b $4b $0c $4b $0c $4b
	.db $0b $2b $0b $4b $2b $2b $4b $4b
	.db $2b $2b $4b $2b $4b $0b $0b $0b
	.db $6c $2c $2c $0c $08 $08 $08 $28
	.db $2d $0d $2d $0d $0c $0d $0d $0c
	.db $2e $0e $2e $0e $0e $2d $2d $2d
	.db $2e $2d $2e $2d $0d $0c $0c $0d
	.db $28 $28 $0d $0d $0d $28 $0d $28
	.db $4d $4d $28 $28 $28 $6d $28 $6d
	.db $8d $8d $8d $8d $2d $2c $0d $2c
	.db $2c $4b $2c $4b $0c $0c $0c $0a
	.db $0c $2c $0a $2c $0c $0c $0a $0a
	.db $2c $2c $0c $2c $0c $0c $0c $2c
	.db $4e $4e $4e $4e $08 $08 $2e $0e
	.db $6e $4e $08 $08 $0b $0b $4b $4b
	.db $0c $0b $2c $2c $2b $2b $2c $2b
	.db $2c $2e $2e $2e $0b $0f $0b $0f
	.db $0f $2b $0f $2b $0b $0b $0b $0f
	.db $2b $2b $0f $2b $0b $0c $0b $0b
	.db $2b $2b $2b $0b $2b $0b $4b $4b
	.db $0c $0c $4b $6b $0b $2c $0b $0c
	.db $2c $2b $0c $2b $0b $0a $0b $0c
	.db $0a $2b $0c $2b $0a $2a $0a $0a
	.db $0a $2a $4a $4a $4a $4a $0a $0a
	.db $0a $0a $4a $6a $2a $2a $4a $4a
	.db $0a $6a $6a $0a $2a $2a $2a $0a
	.db $2a $2c $2a $2c $2a $2a $0c $0c
	.db $0c $0c $2a $2c $0a $0b $0b $0b
	.db $0b $0b $0f $0b $2b $2b $2b $0f
	.db $0c $0b $2a $2c $0b $2b $0f $0f
	.db $0f $2b $2b $2b $0c $0a $0c $0c
	.db $2a $2c $0c $2c $0c $0b $0c $0c
	.db $0c $4a $0c $2c $6a $2c $0c $2c
	.db $0f $2f $0f $0f $0f $0f $2f $0f
	.db $2f $2f $2f $0f $2b $0a $2b $2b
	.db $0d $0d $0a $0d $0f $0e $0f $0f
	.db $0e $0e $0f $0e $2f $2f $0f $0f
	.db $0a $0a $0d $0c $0e $0e $0e $0f
	.db $0e $0f $0f $0f $0d $2d $0c $0c
	.db $0a $0a $0d $0d $0a $0d $2a $0d
	.db $0b $0a $0a $2a $2a $2a $0a $0a
	.db $0f $08 $0b $0a $0c $0b $0d $0d
	.db $0a $0a $2a $0a $0a $0c $0c $0c
	.db $0c $2a $0c $0c $0e $0a $0e $0a
	.db $0a $0c $0d $0c $0c $0a $0c $0d
	.db $0a $2a $0d $0d $0a $0d $0a $0d
	.db $2a $0d $2a $0d $0e $0c $0d $0c
	.db $0c $0d $0c $0e $0a $0d $0a $0a
	.db $0d $0d $0a $0a $0c $0e $0d $0e
	.db $0e $0e $0a $0a $0e $2a $0a $0a
	.db $0c $0d $0e $0e $0c $0b $0e $0e
	.db $0a $08 $0a $0a $08 $2a $0a $2a
	.db $0a $0a $0a $08 $0a $2a $08 $2a
	.db $0d $0d $2d $0d $2d $2d $2d $0d
	.db $2c $2d $0c $0d $0c $2d $0d $0d
	.db $4c $0c $4c $0c $4c $2d $4c $0d
	.db $0d $2c $0d $2c $0d $2d $0a $0a
	.db $0c $08 $08 $28 $08 $28 $0c $2c
	.db $4c $08 $0c $08 $08 $2c $28 $2c
	.db $28 $28 $0c $0c $28 $08 $2c $08
	.db $28 $28 $08 $0c $0c $08 $4c $08
	.db $0c $08 $0c $0c $28 $2c $2c $2c
	.db $0c $0c $2c $0c $08 $28 $0c $0c
	.db $08 $2c $0c $2c $0c $08 $0c $2c
	.db $0c $2c $08 $28 $68 $2c $2c $2c
	.db $0c $0c $08 $28 $2c $08 $4c $08
	.db $08 $0c $08 $2c $2c $0c $4c $4c
	.db $0c $0c $4c $6c $8c $0c $8c $0c
	.db $0f $0f $0f $0d $0f $0f $0d $0d
	.db $0b $0a $0c $0c $0a $2b $0c $0c
	.db $0f $0d $0f $0d $0d $2f $0d $2f
	.db $0f $2f $0d $2f $0f $2f $2f $2f
	.db $0d $8c $0d $8c $0f $0f $0f $2f
	.db $0e $2e $0c $2e $0a $2a $0c $2c
	.db $08 $28 $08 $08 $0d $2d $0a $2a
	.db $0a $0a $0a $2a $0c $2c $2c $2c
	.db $2a $0a $2a $2a $0a $6a $0a $0a
	.db $4a $0a $0a $0a $0e $0e $2e $2e
	.db $2c $0c $0f $0f $0a $0a $0e $0e
	.db $2a $2a $2e $2e $0d $2d $0c $0d
	.db $0c $2d $0d $0c $2c $0c $0c $0c
	.db $0b $2b $0c $0c $8c $8c $0d $8c
	.db $2e $2e $0e $2e $2e $2e $2e $0e
	.db $0b $0b $0b $0a $2b $2b $2a $2b
	.db $2e $0e $0e $2e $2b $2c $2c $2c
	.db $0c $0d $0b $0b $0d $0d $0b $0b
	.db $0d $2c $0b $0b $0c $2c $0f $0f
	.db $0e $2e $0e $0e $0e $0e $4e $4e
	.db $0d $0d $0e $2e $2d $0d $2d $2d
	.db $0d $0b $0b $0b $2a $0b $2b $2b
	.db $0b $0b $0b $2b $0b $2d $0b $2b
	.db $0d $0d $0d $0b $0b $0b $0a $0a
	.db $2b $2b $2a $2a $2d $2d $0b $2d
	.db $0b $0b $0a $0b $2b $0b $2b $2b
	.db $0b $0b $2b $2b $2b $2b $2b $2a
	.db $2d $0d $2b $2d $0b $0a $0b $0b
	.db $0a $0a $0b $0b $0a $0f $0a $0a
	.db $0f $0f $0a $0a $2f $2f $2a $2a
	.db $2f $2a $2a $2a $2a $2a $2b $2b
	.db $28 $08 $28 $08 $0a $2b $2c $2c
	.db $0a $2b $0c $2c $28 $28 $2c $2c
	.db $28 $2c $28 $2c $0c $2c $08 $2c
	.db $2b $2c $4b $2c $0c $2c $2b $2c
	.db $2b $2c $2b $2c $6b $2c $2c $2c
	.db $0c $4b $0c $0c $0c $0c $4b $4b
	.db $2b $0c $2c $0c $0c $8c $8c $8c
	.db $8c $ac $8c $ac $ac $0c $ac $ac
	.db $0c $8c $0c $0c $8c $8c $0c $2c
	.db $ac $ac $0c $2c $ac $0c $2c $0c
	.db $0b $2d $0b $0b $6c $4c $2c $6c
	.db $4c $4c $4c $0c $0d $2b $2b $2b
	.db $2c $2c $2c $0c $0c $0c $28 $28
	.db $08 $2c $68 $08 $2f $0f $2f $2f
	.db $0d $2d $2d $0d $68 $2c $0c $6c
	.db $2d $0d $0d $2d $0d $0d $2d $2d
	.db $0f $2f $0c $0c $0c $0f $0f $0f
	.db $0f $0c $0f $0f $2e $0e $2e $2e
	.db $2b $0b $0d $2d $0b $0b $0d $2d
	.db $0d $0d $2b $0b $0d $2d $0b $0b
	.db $eb $8b $eb $8b $8b $8b $8b $8b
	.db $ab $ab $ab $8b $8b $8b $2d $2d
	.db $8b $8b $0d $0d $8b $8b $0d $2d
	.db $ab $8b $0d $2d $0c $0c $0f $0f
	.db $2d $28 $2d $2d $08 $0d $0d $0d
	.db $0f $2f $2f $0f $28 $2c $0c $2c
	.db $0d $0d $0e $0e $0d $2c $0e $0e
	.db $0c $2c $0c $08 $0c $2a $0c $0a
	.db $0a $2c $0a $2c $0a $2c $2c $2c
	.db $2a $2a $0a $2a $0a $2a $0a $2c
	.db $0a $2a $0c $0a $0b $0d $0b $0d
	.db $0d $0b $0d $0b $2d $2d $0b $0b
	.db $0b $0d $0b $0b $8d $ad $8d $ad
	.db $ad $ad $ad $ad $2d $2d $2a $2a
	.db $0d $0d $2b $2b $4c $4c $28 $0c
	.db $08 $4c $68 $08 $08 $0c $08 $0c
	.db $28 $28 $2c $28 $6c $2c $4c $6c
	.db $68 $0c $2c $0c $28 $08 $08 $0c
	.db $6c $4c $2c $08 $0c $4c $4c $4c
	.db $6c $08 $08 $68 $28 $0b $28 $0b
	.db $0b $0c $0d $0c $0b $0b $0b $0d
	.db $0b $0b $2d $0b $2d $0b $2d $0b
	.db $0d $2d $2d $2d $2c $0c $6c $4c
	.db $4c $4c $0c $0c $28 $28 $2c $08
	.db $08 $28 $08 $0c $08 $2c $2c $2c
	.db $08 $68 $0c $2c $08 $28 $2c $2c
	.db $4c $4c $28 $28 $4c $4c $08 $28
	.db $0c $2e $0c $2e $0b $0d $2d $0d
	.db $0d $0b $0d $0d $2c $2c $2c $2d
	.db $08 $08 $28 $28 $08 $28 $28 $28
	.db $08 $08 $28 $08 $0b $28 $0b $28
	.db $28 $08 $08 $08 $2c $2c $0c $08
	.db $0b $0b $08 $08 $0b $08 $08 $28
	.db $28 $08 $28 $28 $08 $08 $08 $0b
	.db $08 $28 $0b $28 $0c $0d $08 $0d
	.db $2d $0c $2d $08 $28 $28 $08 $08
	.db $08 $08 $08 $0c $0e $0e $2e $0e
	.db $2e $2f $2e $2e $0f $0e $0e $0e
	.db $0b $0d $0d $0d $2e $0e $0e $0e
	.db $2e $2e $0e $0e $09 $09 $09 $09
	.db $0f $0f $0b $0b $0f $0f $2f $2f
	.db $6f $6f $0f $6f $6f $4f $6f $4f
	.db $4f $4f $4f $0f $8e $8e $8e $8e
	.db $8c $8c $8c $8c $2a $0a $0a $0a
	.db $0a $0a $2a $2a $ac $ac $ac $ac

.endif
.endif

.BANK $18 SLOT 1 ; Seasons: should be bank $17
.ORG 0

 m_section_superfree Tile_Mappings

	tileMappingIndexDataPointer:
		.dw tileMappingIndexData
	tileMappingAttributeDataPointer:
		.dw tileMappingAttributeData

	tileMappingTable:
		.incbin "build/tileset_layouts/tileMappingTable.bin"
	tileMappingIndexData:
		.incbin "build/tileset_layouts/tileMappingIndexData.bin"
	tileMappingAttributeData:
		.incbin "build/tileset_layouts/tileMappingAttributeData.bin"

.ifdef ROM_AGES
.ifdef BUILD_VANILLA
	; Leftovers from seasons
	; @addr{799e}
	.incbin "build/gfx/gfx_credits_sprites_2.cmp" SKIP 1+$1e
.endif
.endif

.ends


.BANK $19 SLOT 1
.ORG 0

 m_section_superfree "Gfx_19_1" ALIGN $10
	.include "data/ages/gfxDataBank19_1.s"
.ends

 m_section_superfree "Tile_mappings"
	.include "build/data/tilesetMappings.s"
.ends

 m_section_superfree "Gfx_19_2" ALIGN $10
	.include "data/ages/gfxDataBank19_2.s"
.ends


.BANK $1a SLOT 1
.ORG 0


 m_section_free "Gfx_1a" ALIGN $20
	.include "data/gfxDataBank1a.s"
.ends


.BANK $1b SLOT 1
.ORG 0

 m_section_free "Gfx_1b" ALIGN $20
	.include "data/gfxDataBank1b.s"
.ends


.BANK $1c SLOT 1
.ORG 0

	; The first $e characters of gfx_font are blank, so they aren't
	; included in the rom. In order to get the offsets correct, use
	; gfx_font_start as the label instead of gfx_font.

	.define gfx_font_start gfx_font-$e0
	.export gfx_font_start

	m_GfxDataSimple gfx_font_jp ; $70000
	m_GfxDataSimple gfx_font_tradeitems ; $70600
	m_GfxDataSimple gfx_font $e0 ; $70800
	m_GfxDataSimple gfx_font_heartpiece ; $71720

	m_GfxDataSimple map_rings ; $717a0

	.include "build/data/largeRoomLayoutTables.s" ; $719c0

.ifdef ROM_AGES
.ifdef BUILD_VANILLA

	; Leftovers from seasons - part of its text dictionary
	; $73dc0

	.db $62 $65 $66 $6f $72 $65 $00 $53
	.db $70 $69 $72 $69 $74 $00 $57 $65
	.db $27 $72 $65 $20 $00 $48 $6d $6d
	.db $2e $2e $2e $00 $61 $6c $77 $61
	.db $79 $73 $00 $65 $72 $68 $61 $70
	.db $73 $00 $20 $63 $61 $6e $20 $00
	.db $43 $6c $69 $6d $62 $20 $61 $74
	.db $6f $70 $20 $61 $01 $00 $70 $6f
	.db $77 $65 $72 $00 $20 $79 $6f $75
	.db $2e $00 $54 $68 $69 $73 $20 $00
	.db $20 $79 $6f $75 $21 $00 $20 $74
	.db $6f $20 $73 $65 $65 $00 $63 $6f
	.db $75 $72 $61 $67 $65 $00 $77 $61
	.db $6e $74 $20 $74 $6f $00 $20 $74
	.db $68 $61 $6e $6b $73 $00 $75 $73
	.db $68 $72 $6f $6f $6d $00 $20 $4c
	.db $65 $76 $65 $6c $20 $00 $41 $64
	.db $76 $61 $6e $63 $65 $00 $74 $65
	.db $6c $6c $20 $6d $65 $00 $72 $69
	.db $6e $63 $65 $73 $73 $00 $20 $4f
	.db $72 $61 $63 $6c $65 $00 $59 $6f
	.db $75 $27 $6c $6c $20 $00 $61 $6e
	.db $79 $74 $69 $6d $65 $00 $53 $6e
	.db $61 $6b $65 $09 $00 $00 $20 $69
	.db $73 $20 $61 $00 $57 $68 $61 $74
	.db $20 $00 $20 $6d $6f $72 $65 $00
	.db $20 $74 $68 $65 $6d $00 $20 $73
	.db $6f $6d $65 $00 $73 $73 $65 $6e
	.db $63 $65 $00 $63 $68 $61 $6e $67
	.db $65 $00 $72 $65 $74 $75 $72 $6e
	.db $00 $20 $49 $74 $27 $73 $01 $00
	.db $61 $6b $65 $20 $69 $74 $00 $20
	.db $64 $61 $6e $63 $65 $00 $65 $6e
	.db $6f $75 $67 $68 $00 $68 $69 $64
	.db $64 $65 $6e $00 $6f $72 $74 $75
	.db $6e $65 $00 $09 $01 $42 $6f $6d
	.db $62 $00 $09 $00 $21 $0c $18 $01
	.db $00 $74 $68 $69 $6e $67 $00 $74
	.db $68 $69 $73 $20 $00 $73 $20 $6f
	.db $66 $01 $00 $54 $68 $65 $6e $20
	.db $00 $20 $68 $65 $72 $6f $00 $72
	.db $69 $6e $67 $20 $00 $61 $74 $75
	.db $72 $65 $00 $20 $67 $65 $74 $20
	.db $00 $20 $61 $72 $65 $01 $00 $66
	.db $72 $6f $6d $20 $00 $46 $65 $72
	.db $74 $69 $6c $65 $20 $53 $6f $69
	.db $6c $00 $4b $6e $6f $77 $2d $49
	.db $74 $2d $41 $6c $6c $01 $00 $4d
	.db $61 $67 $69 $63 $20 $50 $6f $74
	.db $69 $6f $6e $00 $61 $68 $2c $20
	.db $68 $61 $68 $2c $20 $68 $61 $68
	.db $00 $65 $67 $65 $6e $64 $61 $72
	.db $79 $00 $79 $6f $75 $72 $73 $65
	.db $6c $66 $00 $73 $74 $72 $65 $6e
	.db $67 $74 $68 $00 $70 $72 $65 $63
	.db $69 $6f $75 $73 $00 $20 $79 $6f
	.db $75 $27 $6c $6c $01 $00 $42 $77
	.db $65 $65 $2d $68 $65 $65 $00 $66
	.db $69 $6e $69 $73 $68 $65 $64 $00
	.db $09 $01 $47 $61 $73 $68 $61 $01
	.db $00 $09 $03 $48 $6f $72 $6f $6e
	.db $01 $00 $54 $68 $61 $74 $20 $00
	.db $20 $67 $6f $6f $64 $00 $20 $68
	.db $61 $73 $01 $00 $20 $69 $74 $20
	.db $74 $6f $00 $65 $61 $74 $68 $65
	.db $72 $00 $73 $68 $6f $75 $6c $64
	.db $00 $6d $61 $73 $74 $65 $72 $00
	.db $20 $6d $75 $73 $74 $20 $00 $54
	.db $68 $61 $6e $6b $73 $00 $62 $65
	.db $61 $73 $74 $73 $00 $63 $61 $6c
	.db $6c $65 $64 $00 $62 $65 $74 $74
	.db $65 $72 $00 $74 $72 $61 $76 $65

.endif
.endif

; "build/textData.s" will determine where this data starts.
;   Ages:    1d:4000
;   Seasons: 1c:5c00

	.include "build/textData.s"

	.REDEFINE DATA_ADDR TEXT_END_ADDR
	.REDEFINE DATA_BANK TEXT_END_BANK

	.include "build/data/roomLayoutData.s"
	.include "build/data/gfxDataMain.s"



.BANK $3f SLOT 1
.ORG 0

 m_section_force Bank3f NAMESPACE bank3f

.define BANK_3f $3f

.include "code/loadGraphics.s"
.include "code/treasureAndDrops.s"
.include "code/textbox.s"

; @addr{5951}
data_5951:
	.db $3c $b4 $3c $50 $78 $b4 $3c $3c
	.db $3c $70 $78 $78

.ifdef ROM_AGES

; In Seasons these sprites are located elsewhere

titlescreenMakuSeedSprite:
	.db $13
	.db $48 $90 $62 $06
	.db $42 $8e $68 $06
	.db $51 $7a $56 $04
	.db $50 $82 $74 $04
	.db $58 $7a $6a $07
	.db $58 $82 $6c $07
	.db $58 $8a $6e $07
	.db $54 $8a $54 $03
	.db $54 $82 $52 $03
	.db $54 $7a $50 $03
	.db $64 $7a $70 $03
	.db $64 $82 $72 $03
	.db $64 $8a $70 $23
	.db $40 $86 $66 $06
	.db $40 $7f $64 $06
	.db $41 $70 $60 $06
	.db $55 $76 $5a $06
	.db $44 $68 $5e $26
	.db $74 $00 $46 $02

titlescreenPressStartSprites:
	.db $0a
	.db $80 $2c $38 $00
	.db $80 $34 $3a $00
	.db $80 $3c $3c $00
	.db $80 $44 $3e $00
	.db $80 $4c $3e $00
	.db $80 $5c $3e $00
	.db $80 $64 $40 $00
	.db $80 $6c $42 $00
	.db $80 $74 $3a $00
	.db $80 $7c $40 $00

; Sprites used on the closeup shot of Link on the horse in the intro
linkOnHorseCloseupSprites_2:
	.db $26
	.db $80 $80 $40 $06
	.db $80 $50 $42 $00
	.db $80 $58 $44 $00
	.db $68 $40 $46 $06
	.db $b8 $3d $20 $02
	.db $b8 $45 $22 $02
	.db $b8 $4d $24 $02
	.db $b8 $55 $26 $02
	.db $b8 $5d $28 $02
	.db $90 $28 $2c $02
	.db $90 $30 $2e $02
	.db $80 $30 $2a $02
	.db $20 $78 $48 $05
	.db $58 $68 $00 $02
	.db $58 $70 $02 $02
	.db $68 $68 $04 $02
	.db $48 $70 $06 $02
	.db $5a $40 $08 $01
	.db $5a $48 $0a $01
	.db $5a $50 $0c $01
	.db $38 $88 $0e $04
	.db $30 $78 $10 $04
	.db $30 $80 $12 $04
	.db $40 $80 $14 $04
	.db $50 $76 $16 $04
	.db $50 $7e $18 $04
	.db $41 $62 $1a $03
	.db $80 $28 $1c $02
	.db $a8 $59 $1e $02
	.db $98 $20 $30 $02
	.db $98 $28 $32 $02
	.db $8c $38 $34 $07
	.db $a8 $41 $36 $02
	.db $a8 $49 $38 $02
	.db $a8 $51 $3a $02
	.db $90 $40 $3e $07
	.db $8a $5c $4a $00
	.db $8a $64 $4c $00

; Sprites used to touch up the appearance of the temple in the intro (the scene where
; Link's on a cliff with his horse)
introTempleSprites:
	.db $05
	.db $30 $28 $48 $02
	.db $30 $30 $4a $02
	.db $18 $38 $4c $03
	.db $10 $40 $4e $03
	.db $18 $48 $50 $03


; Used in intro (ages only)
linkOnHorseFacingCameraSprite:
	.db $02
	.db $70 $08 $58 $02
	.db $70 $10 $5a $02

.endif ; ROM_AGES


.include "build/data/objectGfxHeaders.s"
.include "build/data/treeGfxHeaders.s"

.include "build/data/enemyData.s"
.include "build/data/partData.s"
.include "build/data/itemData.s"
.include "build/data/interactionData.s"

.include "build/data/treasureCollectionBehaviours.s"
.include "build/data/treasureDisplayData.s"

; @addr{714c}
oamData_714c:
	.db $10
	.db $c8 $38 $2e $0e
	.db $c8 $40 $30 $0e
	.db $c8 $48 $32 $0e
	.db $c8 $60 $34 $0f
	.db $c8 $68 $36 $0f
	.db $c8 $70 $38 $0f
	.db $d8 $78 $06 $2e
	.db $e8 $80 $00 $0d
	.db $e8 $78 $08 $0e
	.db $e0 $90 $00 $0d
	.db $d8 $a0 $00 $0d
	.db $e8 $30 $04 $0e
	.db $d8 $30 $06 $0e
	.db $f8 $28 $02 $0e
	.db $f0 $18 $00 $2d
	.db $e8 $08 $00 $2d

; @addr{718d}
oamData_718d:
	.db $10
	.db $a8 $38 $12 $0a
	.db $b8 $38 $0e $0f
	.db $c8 $38 $0a $0f
	.db $a8 $70 $14 $0a
	.db $b8 $70 $10 $0a
	.db $c8 $70 $0c $0f
	.db $e8 $80 $00 $0d
	.db $d8 $78 $06 $2e
	.db $e8 $78 $08 $0e
	.db $e0 $90 $00 $0d
	.db $d8 $a0 $00 $0d
	.db $f8 $28 $02 $0e
	.db $f0 $18 $00 $2d
	.db $e8 $08 $00 $2d
	.db $d8 $30 $06 $0e
	.db $e8 $30 $08 $2e

; @addr{71ce}
oamData_71ce:
	.db $0a
	.db $50 $40 $40 $0b
	.db $50 $48 $42 $0b
	.db $50 $50 $44 $0b
	.db $50 $58 $46 $0b
	.db $50 $60 $48 $0b
	.db $50 $68 $4a $0b
	.db $70 $70 $3c $0c
	.db $60 $70 $3e $2c
	.db $70 $38 $3a $0c
	.db $60 $38 $3e $0c

; @addr{71f7}
oamData_71f7:
	.db $0a
	.db $10 $40 $22 $08
	.db $10 $68 $22 $28
	.db $60 $38 $16 $0c
	.db $70 $38 $1a $0c
	.db $60 $70 $18 $0c
	.db $70 $70 $1a $2c
	.db $40 $40 $1c $08
	.db $40 $68 $1e $08
	.db $50 $40 $20 $08
	.db $50 $68 $20 $28

; @addr{7220}
oamData_7220:
	.db $0a
	.db $e0 $48 $24 $0b
	.db $e0 $60 $24 $2b
	.db $e0 $50 $26 $0b
	.db $e0 $58 $26 $2b
	.db $f0 $48 $28 $0b
	.db $f0 $60 $28 $2b
	.db $00 $48 $2a $0b
	.db $00 $60 $2a $2b
	.db $f8 $50 $2c $0b
	.db $f8 $58 $2c $2b

; @addr{7249}
oamData_7249:
	.db $27
	.db $38 $38 $00 $01
	.db $38 $58 $02 $00
	.db $30 $48 $04 $00
	.db $30 $50 $06 $00
	.db $40 $48 $08 $00
	.db $58 $38 $0a $00
	.db $50 $40 $0c $02
	.db $50 $48 $0e $04
	.db $58 $50 $10 $03
	.db $60 $57 $12 $03
	.db $60 $5f $14 $03
	.db $60 $30 $16 $00
	.db $72 $38 $18 $00
	.db $70 $30 $1a $03
	.db $88 $28 $1c $00
	.db $3b $9a $1e $04
	.db $4b $9a $20 $04
	.db $58 $90 $22 $05
	.db $58 $98 $24 $05
	.db $22 $a0 $26 $06
	.db $22 $a8 $28 $06
	.db $32 $a0 $2a $06
	.db $32 $a8 $2c $06
	.db $12 $a0 $2e $06
	.db $12 $a8 $30 $06
	.db $12 $b0 $32 $06
	.db $6c $b0 $34 $03
	.db $70 $c0 $36 $01
	.db $80 $c0 $38 $05
	.db $90 $58 $3a $03
	.db $30 $90 $3c $00
	.db $90 $c0 $3e $05
	.db $90 $78 $40 $05
	.db $80 $70 $42 $05
	.db $80 $78 $44 $05
	.db $80 $88 $46 $05
	.db $90 $80 $48 $05
	.db $48 $50 $4a $02
	.db $60 $40 $4c $00


.include "code/ages/interactionCode/bank3f.s"

.ifdef BUILD_VANILLA

; Garbage functions appear to follow (corrupted repeats of the above functions).

;;
; @addr{7ca7}
func_7ca7:
	jr -$30			; $7ca7
	call $2118		; $7ca9
	jp $2422		; $7cac

;;
; @addr{7caf}
func_7caf:
	ld c,$20		; $7caf
	call $1f83		; $7cb1
	ret nz			; $7cb4

	ld a,$77		; $7cb5
	call $0cb1		; $7cb7
	ld e,$46		; $7cba
	ld a,$5a		; $7cbc
	ld (de),a		; $7cbe
	ld a,$5b		; $7cbf
	call $0cb1		; $7cc1
	jp $2422		; $7cc4

;;
; @addr{7cc7}
func_7cc7:
	call $2409		; $7cc7
	ret nz			; $7cca
	call $33a2		; $7ccb
	jp $2422		; $7cce

;;
; @addr{7cd1}
func_7cd1:
	ld a,(wPaletteThread_mode)		; $7cd1
	or a			; $7cd4
	ret nz			; $7cd5
	ld a,$29		; $7cd6
	call $324b		; $7cd8
	ld a,$4c		; $7cdb
	call $1761		; $7cdd
	call $7cf8		; $7ce0
	xor a			; $7ce3
	ld (wDisabledObjects),a		; $7ce4
	ld (wMenuDisabled),a		; $7ce7
	ld hl,$cfc0		; $7cea
	set 0,(hl)		; $7ced
	ld a,(wActiveMusic)		; $7cef
	call $0cb1		; $7cf2
	jp $7bf2		; $7cf5

;;
; @addr{7cf8}
func_7cf8:
	ld hl,$c702		; $7cf8
	call $7d00		; $7cfb
	ld l,$12		; $7cfe
	set 0,(hl)		; $7d00
	inc l			; $7d02
	set 0,(hl)		; $7d03
	inc l			; $7d05
	set 0,(hl)		; $7d06
	inc l			; $7d08
	ret			; $7d09

.endif

.ends
