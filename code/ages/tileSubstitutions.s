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
