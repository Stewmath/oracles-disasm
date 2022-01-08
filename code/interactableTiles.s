;;
; @param[out]	cflag	Set if Link interacted with a tile that should disable some of his
;			code? (Opened a chest, read a sign, opened an overworld keyhole)
interactWithTileBeforeLink:
	; Make sure Link isn't holding anything?
	ld a,(wLinkGrabState)
	or a
	ret nz

	call specialObjectGetTileInFront

	; Store tile index in hFF8B
	ld e,a
	ldh (<hFF8B),a
	; Store tile position in hFF8D
	ld a,c
	ldh (<hFF8D),a

	; Check how to behave next to the tile.
	; Note: The function that's called must set or unset the carry flag on returning.
	; Setting it disables some of Link's per-frame update code?
	ld hl,interactableTilesTable
	call lookupCollisionTable_paramE
	jp nc,resetPushingAgainstTileCounter
	ld b,a
	and $0f
	rst_jumpTable
	.dw nextToPushableBlock
	.dw nextToKeyBlock
	.dw nextToKeyDoor
	.dw nextToTileWithInfoText
	.dw nextToChestTile
	.dw nextToSignTile
	.dw nextToOverworldKeyhole
	.dw nextToSubrosiaKeydoor
	.dw nextToGhiniSpawner

;;
nextToChestTile:
	; This will return if Link isn't facing the tile or hasn't pressed A.
	call checkFacingBottomOfTileAndPressedA
	jr z,++

	; Show this text if he's facing the wrong way.
	ld bc,TX_510d
	call showText
	scf
	ret
++
	; Jump if you're not in the shop?
	ld a,(wInShop)
	or a
	jr z,++

	; If in the chest minigame, check some things...
	ld a,(wcca1)
	or a
	jr nz,++

	ld a,(wcca2)
	or a
	ret nz
++
	; Store chest position in $cca2
	ld a,c
	ld (wcca2),a

	ld a,TILEINDEX_CHEST_OPENED
	call setTile

	ld a,SND_OPENCHEST
	call playSound

	ld a,(wInShop)
	or a
	ret nz

	ld a,(wcca1)
	or a
	scf
	ret nz

	ld hl,w1ReservedInteraction0
	ld b,$40
	call clearMemory

	; Check for overridden chest contents?
	ld a,(wChestContentsOverride)
	or a
	jr z,+

	ld b,a
	ld a,(wChestContentsOverride+1)
	ld c,a
	jr ++
+
	call getChestData
++
	ld a,b
	or a
	jr z,+++

	; Disable a bunch of stuff while opening the chest
	ld a,$83
	ld (wDisabledObjects),a
	ld (wDisableLinkCollisionsAndMenu),a

	; Initialize w1ReservedInteraction0 to be a treasure object
	ld hl,w1ReservedInteraction0.enabled
	ld a,$81
	ldi (hl),a
	ld (hl),INTERACID_TREASURE

	; Write contents to Interaction.subid, Interaction.var03
	inc l
	ld (hl),b
	inc l
	ld (hl),c

	; Set the interaction's position variables
	ld l,Interaction.yh
	ld a,(wcca2)
	ld b,a
	and $f0
	ldi (hl),a
	inc l
	ld a,b
	swap a
	and $f0
	or $08
	ld (hl),a
+++
	call getThisRoomFlags
	set ROOMFLAG_BIT_ITEM,(hl)
	xor a
	ld (wChestContentsOverride),a
	ld (wChestContentsOverride+1),a
	scf
	ret

;;
nextToSignTile:
	; This will return if Link isn't facing the tile or hasn't pressed A.
	call checkFacingBottomOfTileAndPressedA

	; Show this text if he's not facing the right way.
	ld bc,TX_510e
	jr nz,@showText

	; Retrieve the text to show.
	ld a,(wActiveGroup)
	ld hl,signTextGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wActiveRoom)
	ld b,a
	ldh a,(<hFF8D)
	ld c,a
@next:
	ldi a,(hl)
	or a
	jr z,@noMatch

	; Compare position
	cp c
	jr z,+

	inc hl
	inc hl
	jr @next
+
	; Compare room index
	ldi a,(hl)
	cp b
	jr z,+

	inc hl
	jr @next
+
	; Match found
	ld c,(hl)
	ld b,>TX_2e00
	call showText
	scf
	ret

	; When there's no match, show some default text
@noMatch:
	ld bc,TX_0901
@showText:
	call showText
	scf
	ret

;;
; Returns from the caller of the function if Link isn't facing a wall or pressing A.
; @param[out] zflag Set if the wall Link is facing is above him.
checkFacingBottomOfTileAndPressedA:
	ld a,(wGameKeysJustPressed)
	and BTN_A
	jr z,++

;;
; Returns from the caller of the function if Link isn't facing a wall.
; @param[out] zflag Set if the wall Link is facing is above him.
checkFacingBottomOfTile:
	ld a,(w1Link.direction)
	ld hl,@data
	rst_addAToHl
	ld a,(w1Link.adjacentWallsBitset)
	and (hl)
	cp (hl)
	jr nz,++
	cp $c0
	ret

@data:
	.db $c0 $03 $30 $0c

++
	pop af
	xor a
	ret

;;
; Deals with pushing blocks, pots, etc.
nextToPushableBlock:
.ifdef ROM_AGES
	; No pushing underwater
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	ret nz
.endif

	; Check that he's actually pushing and wait for counters
	call specialObjectCheckPushingAgainstTile
	jp z,resetPushingAgainstTileCounter
	call decPushingAgainstTileCounter
	ret nz

	; Bit 6 of parameter: if set, power bracelet is required
	bit 6,b
	jr z,+

	ld a,TREASURE_BRACELET
	call checkTreasureObtained
	ld a,$03
	jp nc,showInfoTextForTile
+
	; Bit 7 of parameter: if unset, the block can only be pushed one way (bits 4-5)
	bit 7,b
	jr nz,++

	ld a,b
	swap a
	and $03
	ld l,a
	ld a,(wLinkPushingDirection)
	cp l
	jr nz,@end
++
	; Check whether there is room on the next tile for it to be pushed there
	call checkTileAfterNext
	jr nc,@end

.ifdef ROM_AGES
	ldh a,(<hFF8B)
	cp TILEINDEX_SOMARIA_BLOCK
	jr z,@somariaBlock
.endif

	; Used w1ReservedInteraction1 for the block pushing animation.
	ld hl,w1ReservedInteraction1.enabled
	ld a,(hl)
	or a
	jr nz,@end

	; Mark w1ReservedInteraction1 as in use
	ld (hl),$01

	; Set id
	inc l
	ld (hl),INTERACID_PUSHBLOCK

	; Set angle
	ld a,(wLinkPushingDirection)
	swap a
	rrca
	ld l,Interaction.angle
	ld (hl),a

	; Set position (apparently this needs to go into Interaction.var30 as well)
	ldh a,(<hFF8D)
	ld l,Interaction.var30
	ld (hl),a
	ld l,Interaction.yh
	call setShortPosition

	; Tweak the alignment?
	ld l,Interaction.yh
	dec (hl)
	dec (hl)

.ifdef ROM_AGES
	; If the tile being pushed is a grave hiding a door, disable link's movement
	; temporarily
	ldh a,(<hFF8B)
	cp TILEINDEX_GRAVE_HIDING_DOOR
	jr nz,@end
	ld a,(wTilesetFlags)
	and TILESETFLAG_OUTDOORS
	jr z,@end

	; Note: this assumes that TILESETFLAG_OUTDOORS == 1.
	ld (wDisabledObjects),a
.endif

@end:
	xor a
	jp resetPushingAgainstTileCounter

.ifdef ROM_AGES
	; For the somaria block, use its dedicated object to move it around.
@somariaBlock:
	ld c,ITEMID_18
	call findItemWithID
	jr nz,@end

	ld l,Item.var2f
	set 0,(hl)
	ld a,(wLinkPushingDirection)
	ld l,Item.direction
	ld (hl),a
	jr @end
.endif

;;
nextToKeyBlock:
	call specialObjectCheckPushingAgainstTile
	jp z,resetPushingAgainstTileCounter

	call decPushingAgainstTileCounter
	ret nz

	call checkAndDecKeyCount
	; Show text if # keys was zero
	ld a,$02
	jp z,showInfoTextForTile

	call createKeySpriteInteraction

	ld a,TILEINDEX_STANDARD_FLOOR
	call setTile

	ld a,SND_OPENCHEST
	call playSound

	; Set bit 7 of the room flags to remember the keyblock has been opened
	call getThisRoomFlags
	set ROOMFLAG_BIT_KEYBLOCK,(hl)

	; Create a "puff" at the keyblock's former position
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERACID_PUFF
	ld l,Interaction.yh
	ldh a,(<hFF8D)
	call setShortPosition
++
	xor a
	jr resetPushingAgainstTileCounter

;;
nextToKeyDoor:
	call specialObjectCheckPushingAgainstTile
	jr z,resetPushingAgainstTileCounter

	call decPushingAgainstTileCounter
	jr z,+
	dec (hl)
	ret nz
+
	call checkAndDecKeyCount
	jr z,@noKey

	; Check if w1ReservedInteraction0 is in use, and postpone the door opening if so.
	ld hl,w1ReservedInteraction0.enabled
	ld a,(hl)
	or a
	jr nz,++

	; Create the key sprite
	call createKeySpriteInteraction

	; Create the door opener
	ld hl,w1ReservedInteraction0.enabled
	ld (hl),$01
	inc l
	ld (hl),INTERACID_DOOR_CONTROLLER

	; Copy position to Interaction.yh
	ldh a,(<hFF8D)
	ld l,Interaction.yh
	ld (hl),a

	; Calculate the "angle" the door should open in
	ld l,Interaction.angle
	ld a,b
	swap a
	and $0f
	add a
	ld (hl),a

	; Set the room flags for both this room, and the room on the other side of the
	; door, to remember that it's been unlocked
	push de
	add a
	call setRoomFlagsForUnlockedKeyDoor
	pop de
++
	xor a
	jr resetPushingAgainstTileCounter

	; If you don't have a key, show a message
@noKey:
	ld a,b
	cp $40

	; a = $01 for small key door
	ld a,$01
	jp nc,showInfoTextForTile

	; a = $00 for boss key door
	xor a
	jp showInfoTextForTile

;;
; Sets wPushingAgainstTileCounter to 20 frames.
resetPushingAgainstTileCounter:
	ld a,20
	ld (wPushingAgainstTileCounter),a
	ret

;;
; @param[out] zflag Set if the counter has reached zero.
decPushingAgainstTileCounter:
	ld hl,wPushingAgainstTileCounter
	dec (hl)
	ret

;;
nextToOverworldKeyhole:
	call getThisRoomFlags
	and $80
	ret nz

	call specialObjectCheckPushingAgainstTile
	jr z,resetPushingAgainstTileCounter

	; This will return if Link isn't facing a wall.
	call checkFacingBottomOfTile
	jr z,+

	xor a
	ret
+
	call decPushingAgainstTileCounter
	jr z,+
	dec (hl)
	ret nz
+
	ld a,(wActiveRoom)
	ld hl,@roomsWithKeyholesTable
	call findRoomSpecificData
	ld b,a
	jr nc,jumpToShowInfoText

	; Check that you have the required key
	call checkTreasureObtained
	jr nc,jumpToShowInfoText

	; Play sound effect
	ld a,SND_OPENCHEST
	call playSound

	; Remember that the keyhole has been opened
	call getThisRoomFlags
	set 7,(hl)

	; Trigger the associated cutscene
	ld hl,$cfc0
	set 0,(hl)

	; Create the key sprite
	call createKeySpriteInteraction

	; Increment id to change it to INTERACID_OVERWORLD_KEY_SPRITE
	ld l,Interaction.id
	inc (hl)

	ld a,b
	sub TREASURE_FIRST_KEY
	ld l,Interaction.subid
	ldi (hl),a
	ld (hl),a

	; Disable movement, menus
	ld a,$81
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	scf
	ret


.ifdef ROM_AGES

@roomsWithKeyholesTable:
	.dw @group0
	.dw @group1
	.dw @group2
	.dw @group3
	.dw @group4
	.dw @group5

; Data format:
; b0: room index
; b1: Item needed to unlock the room (see constants/treasure.s)
@group0:
	.db <ROOM_AGES_05c TREASURE_GRAVEYARD_KEY
	.db <ROOM_AGES_00a TREASURE_CROWN_KEY
	.db <ROOM_AGES_0a5 TREASURE_LIBRARY_KEY ; unused since the present library doesn't have a keyhole
	.db $00
@group1:
	.db <ROOM_AGES_10e TREASURE_OLD_MERMAID_KEY
	.db <ROOM_AGES_1a5 TREASURE_LIBRARY_KEY
	.db $00
@group3:
	.db <ROOM_AGES_30f TREASURE_MERMAID_KEY
	.db $00

@group2:
@group4:
@group5:
	.db $00

.else; ROM_SEASONS

@roomsWithKeyholesTable:
	.dw @group0

@group0:
	.db <ROOM_SEASONS_096 TREASURE_GNARLED_KEY
	.db <ROOM_SEASONS_081 TREASURE_FLOODGATE_KEY
	.db <ROOM_SEASONS_00d TREASURE_DRAGON_KEY
	.db $00

.endif ; ROM_SEASONS


jumpToShowInfoText:
	ld a,$08
	jp showInfoTextForTile

;;
createKeySpriteInteraction:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_DUNGEON_KEY_SPRITE
	inc l

	; Store tile index in subid
	ldh a,(<hFF8B)
	ld (hl),a

	ldh a,(<hFF8D)
	ld l,Interaction.yh
	jp setShortPosition

;;
nextToSubrosiaKeydoor:
.ifdef ROM_SEASONS
	call specialObjectCheckPushingAgainstTile
	jp z,resetPushingAgainstTileCounter
	call checkFacingBottomOfTile
	jr z,+
	xor a
	ret
+
	call decPushingAgainstTileCounter
	jr z,+
	dec (hl)
	ret nz
+
	ld a,GLOBALFLAG_DATING_ROSA
	call checkGlobalFlag
	jr z,jumpToShowInfoText

	ld a,SND_OPENCHEST
	call playSound

	call getThisRoomFlags
	set 6,(hl)

	ld a,TILEINDEX_OPEN_CAVE_DOOR
	call setTile

	call createKeySpriteInteraction
.endif
	; Stub in ages
	scf
	ret

;;
; From seasons: when next to certain tombstones, ghinis spawn
nextToGhiniSpawner:
	; No enemies allowed while maple is on the screen
	ld a,(wIsMaplePresent)
	or a
	ret nz

	call specialObjectCheckPushingAgainstTile
	jp z,resetPushingAgainstTileCounter

	call decPushingAgainstTileCounter
	ret nz

	; Change the tile index so it won't keep making ghosts
	ldh a,(<hFF8D)
	ld l,a
	ld h,>wRoomLayout
	ld (hl),$00

	; Get long-form position in bc
	call convertShortToLongPosition

	; Create the ghini
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMYID_GHINI

	; Set subid to $01 to tell it to do a slow spawn, instead of being active right
	; away
	inc l
	inc (hl)

	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c
	ret

;;
; Deals with showing text when pushing against certain tiles, ie. cracked walls, keyholes
nextToTileWithInfoText:
	call specialObjectCheckPushingAgainstTile
	jp z,resetPushingAgainstTileCounter

	call decPushingAgainstTileCounter
	ret nz

	call resetPushingAgainstTileCounter
	ld a,b
	swap a
	and $0f
	rst_jumpTable
	.dw @pot
	.dw @crackedBlock
	.dw @crackedWall
	.dw @unlitTorch
	.dw @rock

@pot:
	; Only show the text if you don't have the power bracelet
	ld a,TREASURE_BRACELET
	call checkTreasureObtained
	ccf
	ret nc
	ld a,$03
	jr showInfoTextForTile

@crackedBlock:
	ld a,$05
	jr showInfoTextForTile

@crackedWall:
	ld a,$06
	jr showInfoTextForTile

@unlitTorch:
	ld a,$07
	jr showInfoTextForTile

@rock:
	ld a,$04
	jr showInfoTextForTile

;;
; Shows text for pressing against a tile, if it has not been shown once on the current
; screen already.
; @param a Index for the table below this function
showInfoTextForTile:
	ld hl,@data
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	call resetPushingAgainstTileCounter

	ld hl,wInformativeTextsShown
	ld a,(hl)
	and b
	ret nz

	ld a,(hl)
	or b
	ld (hl),a

	ld b,>TX_5100
	call showText
	scf
	ret

@data:
	.db $04 <TX_5100 ; Key door
	.db $02 <TX_5101 ; Boss key door
	.db $04 <TX_5102 ; Keyblock
	.db $08 <TX_5103 ; Pot
	.db $20 <TX_5104 ; Rock?
	.db $10 <TX_5105 ; Cracked block
	.db $20 <TX_5106 ; Cracked wall
	.db $20 <TX_5108 ; Unlit torch
	.db $20 <TX_5109 ; Keyhole for a dungeon entrance
	.db $40 <TX_510a ; Roller from Seasons

;;
; @param d Special object (Link)
; @param[out] zflag Set if the object is pushing against the tile.
specialObjectCheckPushingAgainstTile:
	ld a,(wLinkPushingDirection)
	rlca
	jr c,++

	; Check link isn't moving diagonally
	ld a,(wLinkAngle)
	and $07
	jr nz,++

	call @func_433f
	jr nc,++

	or d
	ret
++
	xor a
	ret

;;
; @param[out] cflag Unset if the object is in one of the corners of its current tile?
@func_433f:
	ld h,d
	ld l,SpecialObject.yh

	call @func
	ret c

	ld l,SpecialObject.xh
@func:
	ld a,(hl)
	and $0f
	sub $03
	cp $0b
	ret

;;
; Checks if you have the appropriate key for a door (small key or boss key) and decrements
; the number of keys if applicable.
;
; @param	b	Parameter from interactableTilesTable. Will be $40 or above if the
;			door is a boss key door.
; @param[out]	zflag	Set if you have no keys, or don't have the boss key
checkAndDecKeyCount:
.ifdef ROM_SEASONS
	ld a,GLOBALFLAG_DATING_ROSA
	call checkGlobalFlag
	ret nz
.endif

	ld a,(wDungeonIndex)
	cp $ff
	ret z

	ld a,b
	cp $40
	ld h,>wDungeonSmallKeys
	ld a,(wDungeonIndex)
	jr nc,@bossKeyDoor

	; Small key door

	add <wDungeonSmallKeys
	ld l,a
	ld a,(hl)
	or a
	ret z
	dec (hl)

	; Mark displayed key count as needing to be updated
	ld hl,wStatusBarNeedsRefresh
	set 4,(hl)

	or h
	ret

@bossKeyDoor:
	ld l,<wDungeonBossKeys
	jp checkFlag

;;
; Gets the tile in front of the object. This takes the object's position and adds
; a certain value to it depending on its facing direction, then reads from wRoomLayout.
;
; @param	d	Special object (Link)
; @param[out]	a	The tile index in front of the object
; @param[out]	bc	The position of the tile in front
specialObjectGetTileInFront:
	ld e,SpecialObject.direction
	ld a,(de)
	ld hl,nextTileOffsets
	rst_addDoubleIndex

;;
; @param	hl	Address to get offsets to add to Y, X
specialObjectGetTileAtOffset:
	ld e,SpecialObject.yh
	ld a,(de)
	add (hl)
	and $f0
	ld c,a

	inc hl
	ld e,SpecialObject.xh
	ld a,(de)
	add (hl)
	swap a
	and $0f
	or c
	ld c,a

	ld b,>wRoomLayout
	ld a,(bc)
	ret

; Offsets to get the position of the tile link is standing directly against
nextTileOffsets:
	.db $fc $00 ; DIR_UP
	.db $00 $07 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT

;;
; Checks the collisions on the tile after the next one.
; This is used to determine whether a pushable block has room to be pushed.
;
; @param[out]	cflag	Set if there is no obstruction (tile is not solid)
checkTileAfterNext:
	ld a,(wLinkPushingDirection)
	ld hl,@offsets
	rst_addDoubleIndex
	call specialObjectGetTileAtOffset
	ld b,>wRoomCollisions
	ld a,(bc)
	and $0f
	ret nz

	scf
	ret

@offsets:
	.db $ec $00
	.db $00 $14
	.db $18 $00
	.db $00 $eb


; The following is a table indicating what should happen when Link is standing right in
; front of a tile of a particular type
;
; Data format:
; b0: tile index
; b1:
;    Second digit: How to behave when Link is next to this kind of tile
;        0: Pushable tile
;           First digit:
;             bit 3 (7): Set if it's pushable in all directions. Otherwise, Bits 0-1 (4-5)
;                        are the direction it can be pushed in.
;             bit 2 (6): Set if the power bracelet is needed to push it.
;        1: Keyblock
;        2: Key door
;           First digit is 0-3 indicating direction, or 4-7 for boss key doors
;        3: Should show text when pushing against the tile.
;           First digit is an index for which text to show.
;        4: Chest (handle opening)
;        5: Sign (handle reading)
;        6: Overworld keyhole (ie. Yoll Graveyard, Crown Dungeon)
;        7: Does nothing?
;        8: Spawns a ghini when approached. Used in the graveyard in Seasons, but not in
;           Ages.


.ifdef ROM_AGES

interactableTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5


@collisions0:
@collisions4:
	.db $d3 $80
	.db $f1 $04
	.db $f2 $05
	.db $d8 $80
	.db $d9 $80
	.db $ec $06
	.db $da $80
	.db $00

@collisions1:
	.db $ae $06

@collisions2:
@collisions5:
	.db $18 $00
	.db $19 $10
	.db $1a $20
	.db $1b $30
	.db $1c $80
	.db $2a $80
	.db $2c $80
	.db $2d $80
	.db $2e $80
	.db $10 $c0
	.db $11 $c0
	.db $12 $c0
	.db $13 $c0
	.db $25 $80
	.db $07 $80
	.db $1e $01
	.db $70 $02
	.db $71 $12
	.db $72 $22
	.db $73 $32
	.db $74 $42
	.db $75 $52
	.db $76 $62
	.db $77 $72
	.db $1f $13
	.db $30 $23
	.db $31 $23
	.db $32 $23
	.db $33 $23
	.db $08 $33
	.db $f1 $04
	.db $f2 $05
@collisions3:
	.db $da $80
	.db $00

.else; ROM_SEASONS

interactableTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
	.db $d6 $80
	.db $c0 $03
	.db $c1 $03
	.db $c2 $03
	.db $96 $43
	.db $f1 $04
	.db $f2 $05
	.db $ec $06
	.db $d5 $08
	.db $00

@collisions1:
	.db $f1 $04
	.db $f2 $05
	.db $ec $07
@collisions2:
	.db $00

@collisions3:
@collisions4:
	.db $18 $00
	.db $19 $10
	.db $1a $20
	.db $1b $30
	.db $1c $80
	.db $2a $80
	.db $2c $80
	.db $2d $80
	.db $10 $c0
	.db $11 $c0
	.db $12 $c0
	.db $13 $c0
	.db $25 $80
	.db $2f $80
	.db $1e $01
	.db $70 $02
	.db $71 $12
	.db $72 $22
	.db $73 $32
	.db $74 $42
	.db $75 $52
	.db $76 $62
	.db $77 $72
	.db $1f $13
	.db $30 $23
	.db $31 $23
	.db $32 $23
	.db $33 $23
	.db $08 $33
	.db $f1 $04
	.db $f2 $05
@collisions5:
	.db $00

.endif
