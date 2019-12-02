;;
; @param[out]	cflag	Set if Link interacted with a tile that should disable some of his
;			code? (Opened a chest, read a sign, opened an overworld keyhole)
; @addr{4000}
interactWithTileBeforeLink:
	; Make sure Link isn't holding anything?
	ld a,(wLinkGrabState)		; $4000
	or a			; $4003
	ret nz			; $4004

	call _specialObjectGetTileInFront		; $4005

	; Store tile index in hFF8B
	ld e,a			; $4008
	ldh (<hFF8B),a	; $4009
	; Store tile position in hFF8D
	ld a,c			; $400b
	ldh (<hFF8D),a	; $400c

	; Check how to behave next to the tile.
	; Note: The function that's called must set or unset the carry flag on returning.
	; Setting it disables some of Link's per-frame update code?
	ld hl,interactableTilesTable		; $400e
	call lookupCollisionTable_paramE		; $4011
	jp nc,_resetPushingAgainstTileCounter		; $4014
	ld b,a			; $4017
	and $0f			; $4018
	rst_jumpTable			; $401a
	.dw _nextToPushableBlock
	.dw _nextToKeyBlock
	.dw _nextToKeyDoor
	.dw _nextToTileWithInfoText
	.dw _nextToChestTile
	.dw _nextToSignTile
	.dw _nextToOverworldKeyhole
	.dw _nextToSubrosiaKeydoor
	.dw _nextToGhiniSpawner

;;
; @addr{402d}
_nextToChestTile:
	; This will return if Link isn't facing the tile or hasn't pressed A.
	call _checkFacingBottomOfTileAndPressedA		; $402d
	jr z,++			; $4030

	; Show this text if he's facing the wrong way.
	ld bc,TX_510d		; $4032
	call showText		; $4035
	scf			; $4038
	ret			; $4039
++
	; Jump if you're not in the shop?
	ld a,(wInShop)		; $403a
	or a			; $403d
	jr z,++			; $403e

	; If in the chest minigame, check some things...
	ld a,(wcca1)		; $4040
	or a			; $4043
	jr nz,++		; $4044

	ld a,(wcca2)		; $4046
	or a			; $4049
	ret nz			; $404a
++
	; Store chest position in $cca2
	ld a,c			; $404b
	ld (wcca2),a		; $404c

	ld a,TILEINDEX_CHEST_OPENED		; $404f
	call setTile		; $4051

	ld a,SND_OPENCHEST		; $4054
	call playSound		; $4056

	ld a,(wInShop)		; $4059
	or a			; $405c
	ret nz			; $405d

	ld a,(wcca1)		; $405e
	or a			; $4061
	scf			; $4062
	ret nz			; $4063

	ld hl,w1ReservedInteraction0		; $4064
	ld b,$40		; $4067
	call clearMemory		; $4069

	; Check for overridden chest contents?
	ld a,(wChestContentsOverride)		; $406c
	or a			; $406f
	jr z,+			; $4070

	ld b,a			; $4072
	ld a,(wChestContentsOverride+1)		; $4073
	ld c,a			; $4076
	jr ++			; $4077
+
	call getChestData		; $4079
++
	ld a,b			; $407c
	or a			; $407d
	jr z,+++		; $407e

	; Disable a bunch of stuff while opening the chest
	ld a,$83		; $4080
	ld (wDisabledObjects),a		; $4082
	ld (wDisableLinkCollisionsAndMenu),a		; $4085

	; Initialize w1ReservedInteraction0 to be a treasure object
	ld hl,w1ReservedInteraction0.enabled		; $4088
	ld a,$81		; $408b
	ldi (hl),a		; $408d
	ld (hl),INTERACID_TREASURE		; $408e

	; Write contents to Interaction.subid, Interaction.var03
	inc l			; $4090
	ld (hl),b		; $4091
	inc l			; $4092
	ld (hl),c		; $4093

	; Set the interaction's position variables
	ld l,Interaction.yh		; $4094
	ld a,(wcca2)		; $4096
	ld b,a			; $4099
	and $f0			; $409a
	ldi (hl),a		; $409c
	inc l			; $409d
	ld a,b			; $409e
	swap a			; $409f
	and $f0			; $40a1
	or $08			; $40a3
	ld (hl),a		; $40a5
+++
	call getThisRoomFlags		; $40a6
	set ROOMFLAG_BIT_ITEM,(hl)		; $40a9
	xor a			; $40ab
	ld (wChestContentsOverride),a		; $40ac
	ld (wChestContentsOverride+1),a		; $40af
	scf			; $40b2
	ret			; $40b3

;;
; @addr{40b4}
_nextToSignTile:
	; This will return if Link isn't facing the tile or hasn't pressed A.
	call _checkFacingBottomOfTileAndPressedA		; $40b4

	; Show this text if he's not facing the right way.
	ld bc,TX_510e		; $40b7
	jr nz,@showText		; $40ba

	; Retrieve the text to show.
	ld a,(wActiveGroup)		; $40bc
	ld hl,signTextGroupTable		; $40bf
	rst_addDoubleIndex			; $40c2
	ldi a,(hl)		; $40c3
	ld h,(hl)		; $40c4
	ld l,a			; $40c5
	ld a,(wActiveRoom)		; $40c6
	ld b,a			; $40c9
	ldh a,(<hFF8D)	; $40ca
	ld c,a			; $40cc
@next:
	ldi a,(hl)		; $40cd
	or a			; $40ce
	jr z,@noMatch		; $40cf

	; Compare position
	cp c			; $40d1
	jr z,+			; $40d2

	inc hl			; $40d4
	inc hl			; $40d5
	jr @next		; $40d6
+
	; Compare room index
	ldi a,(hl)		; $40d8
	cp b			; $40d9
	jr z,+			; $40da

	inc hl			; $40dc
	jr @next		; $40dd
+
	; Match found
	ld c,(hl)		; $40df
	ld b,>TX_2e00		; $40e0
	call showText		; $40e2
	scf			; $40e5
	ret			; $40e6

	; When there's no match, show some default text
@noMatch:
	ld bc,TX_0901		; $40e7
@showText:
	call showText		; $40ea
	scf			; $40ed
	ret			; $40ee

;;
; Returns from the caller of the function if Link isn't facing a wall or pressing A.
; @param[out] zflag Set if the wall Link is facing is above him.
; @addr{40ef}
_checkFacingBottomOfTileAndPressedA:
	ld a,(wGameKeysJustPressed)		; $40ef
	and BTN_A			; $40f2
	jr z,++			; $40f4

;;
; Returns from the caller of the function if Link isn't facing a wall.
; @param[out] zflag Set if the wall Link is facing is above him.
; @addr{40f6}
_checkFacingBottomOfTile:
	ld a,(w1Link.direction)		; $40f6
	ld hl,@data		; $40f9
	rst_addAToHl			; $40fc
	ld a,(w1Link.adjacentWallsBitset)		; $40fd
	and (hl)		; $4100
	cp (hl)			; $4101
	jr nz,++		; $4102
	cp $c0			; $4104
	ret			; $4106

@data:
	.db $c0 $03 $30 $0c

++
	pop af			; $410b
	xor a			; $410c
	ret			; $410d

;;
; Deals with pushing blocks, pots, etc.
; @addr{410e}
_nextToPushableBlock:
.ifdef ROM_AGES
	; No pushing underwater
	ld a,(wAreaFlags)		; $410e
	and AREAFLAG_UNDERWATER			; $4111
	ret nz			; $4113
.endif

	; Check that he's actually pushing and wait for counters
	call _specialObjectCheckPushingAgainstTile		; $4114
	jp z,_resetPushingAgainstTileCounter		; $4117
	call _decPushingAgainstTileCounter		; $411a
	ret nz			; $411d

	; Bit 6 of parameter: if set, power bracelet is required
	bit 6,b			; $411e
	jr z,+			; $4120

	ld a,TREASURE_BRACELET		; $4122
	call checkTreasureObtained		; $4124
	ld a,$03		; $4127
	jp nc,showInfoTextForTile		; $4129
+
	; Bit 7 of parameter: if unset, the block can only be pushed one way (bits 4-5)
	bit 7,b			; $412c
	jr nz,++		; $412e

	ld a,b			; $4130
	swap a			; $4131
	and $03			; $4133
	ld l,a			; $4135
	ld a,(wLinkPushingDirection)		; $4136
	cp l			; $4139
	jr nz,@end		; $413a
++
	; Check whether there is room on the next tile for it to be pushed there
	call _checkTileAfterNext		; $413c
	jr nc,@end		; $413f

.ifdef ROM_AGES
	ldh a,(<hFF8B)	; $4141
	cp TILEINDEX_SOMARIA_BLOCK			; $4143
	jr z,@somariaBlock	; $4145
.endif

	; Used w1ReservedInteraction1 for the block pushing animation.
	ld hl,w1ReservedInteraction1.enabled		; $4147
	ld a,(hl)		; $414a
	or a			; $414b
	jr nz,@end		; $414c

	; Mark w1ReservedInteraction1 as in use
	ld (hl),$01		; $414e

	; Set id
	inc l			; $4150
	ld (hl),INTERACID_PUSHBLOCK		; $4151

	; Set angle
	ld a,(wLinkPushingDirection)		; $4153
	swap a			; $4156
	rrca			; $4158
	ld l,Interaction.angle		; $4159
	ld (hl),a		; $415b

	; Set position (apparently this needs to go into Interaction.var30 as well)
	ldh a,(<hFF8D)	; $415c
	ld l,Interaction.var30		; $415e
	ld (hl),a		; $4160
	ld l,Interaction.yh		; $4161
	call setShortPosition		; $4163

	; Tweak the alignment?
	ld l,Interaction.yh		; $4166
	dec (hl)		; $4168
	dec (hl)		; $4169

.ifdef ROM_AGES
	; If the tile being pushed is a grave hiding a door, disable link's movement
	; temporarily
	ldh a,(<hFF8B)	; $416a
	cp TILEINDEX_GRAVE_HIDING_DOOR			; $416c
	jr nz,@end		; $416e
	ld a,(wAreaFlags)		; $4170
	and AREAFLAG_OUTDOORS			; $4173
	jr z,@end			; $4175

	; Note: this assumes that AREAFLAG_OUTDOORS == 1.
	ld (wDisabledObjects),a		; $4177
.endif

@end:
	xor a			; $417a
	jp _resetPushingAgainstTileCounter		; $417b

.ifdef ROM_AGES
	; For the somaria block, use its dedicated object to move it around.
@somariaBlock:
	ld c,ITEMID_18		; $417e
	call findItemWithID		; $4180
	jr nz,@end		; $4183

	ld l,Item.var2f		; $4185
	set 0,(hl)		; $4187
	ld a,(wLinkPushingDirection)		; $4189
	ld l,Item.direction		; $418c
	ld (hl),a		; $418e
	jr @end			; $418f
.endif

;;
; @addr{4191}
_nextToKeyBlock:
	call _specialObjectCheckPushingAgainstTile		; $4191
	jp z,_resetPushingAgainstTileCounter		; $4194

	call _decPushingAgainstTileCounter		; $4197
	ret nz			; $419a

	call _checkAndDecKeyCount		; $419b
	; Show text if # keys was zero
	ld a,$02		; $419e
	jp z,showInfoTextForTile		; $41a0

	call _createKeySpriteInteraction		; $41a3

	ld a,TILEINDEX_STANDARD_FLOOR		; $41a6
	call setTile		; $41a8

	ld a,SND_OPENCHEST		; $41ab
	call playSound		; $41ad

	; Set bit 7 of the room flags to remember the keyblock has been opened
	call getThisRoomFlags		; $41b0
	set ROOMFLAG_BIT_KEYBLOCK,(hl)		; $41b3

	; Create a "puff" at the keyblock's former position
	call getFreeInteractionSlot		; $41b5
	jr nz,++		; $41b8
	ld (hl),INTERACID_PUFF		; $41ba
	ld l,Interaction.yh		; $41bc
	ldh a,(<hFF8D)	; $41be
	call setShortPosition		; $41c0
++
	xor a			; $41c3
	jr _resetPushingAgainstTileCounter		; $41c4

;;
; @addr{41c6}
_nextToKeyDoor:
	call _specialObjectCheckPushingAgainstTile		; $41c6
	jr z,_resetPushingAgainstTileCounter	; $41c9

	call _decPushingAgainstTileCounter		; $41cb
	jr z,+			; $41ce
	dec (hl)		; $41d0
	ret nz			; $41d1
+
	call _checkAndDecKeyCount		; $41d2
	jr z,@noKey		; $41d5

	; Check if w1ReservedInteraction0 is in use, and postpone the door opening if so.
	ld hl,w1ReservedInteraction0.enabled		; $41d7
	ld a,(hl)		; $41da
	or a			; $41db
	jr nz,++		; $41dc

	; Create the key sprite
	call _createKeySpriteInteraction		; $41de

	; Create the door opener
	ld hl,w1ReservedInteraction0.enabled		; $41e1
	ld (hl),$01		; $41e4
	inc l			; $41e6
	ld (hl),INTERACID_DOOR_CONTROLLER		; $41e7

	; Copy position to Interaction.yh
	ldh a,(<hFF8D)	; $41e9
	ld l,Interaction.yh		; $41eb
	ld (hl),a		; $41ed

	; Calculate the "angle" the door should open in
	ld l,Interaction.angle		; $41ee
	ld a,b			; $41f0
	swap a			; $41f1
	and $0f			; $41f3
	add a			; $41f5
	ld (hl),a		; $41f6

	; Set the room flags for both this room, and the room on the other side of the
	; door, to remember that it's been unlocked
	push de			; $41f7
	add a			; $41f8
	call setRoomFlagsForUnlockedKeyDoor		; $41f9
	pop de			; $41fc
++
	xor a			; $41fd
	jr _resetPushingAgainstTileCounter		; $41fe

	; If you don't have a key, show a message
@noKey:
	ld a,b			; $4200
	cp $40			; $4201

	; a = $01 for small key door
	ld a,$01		; $4203
	jp nc,showInfoTextForTile		; $4205

	; a = $00 for boss key door
	xor a			; $4208
	jp showInfoTextForTile		; $4209

;;
; Sets wPushingAgainstTileCounter to 20 frames.
; @addr{420c}
_resetPushingAgainstTileCounter:
	ld a,20			; $420c
	ld (wPushingAgainstTileCounter),a		; $420e
	ret			; $4211

;;
; @param[out] zflag Set if the counter has reached zero.
; @addr{4212}
_decPushingAgainstTileCounter:
	ld hl,wPushingAgainstTileCounter		; $4212
	dec (hl)		; $4215
	ret			; $4216

;;
; @addr{4217}
_nextToOverworldKeyhole:
	call getThisRoomFlags		; $4217
	and $80			; $421a
	ret nz			; $421c

	call _specialObjectCheckPushingAgainstTile		; $421d
	jr z,_resetPushingAgainstTileCounter	; $4220

	; This will return if Link isn't facing a wall.
	call _checkFacingBottomOfTile		; $4222
	jr z,+			; $4225

	xor a			; $4227
	ret			; $4228
+
	call _decPushingAgainstTileCounter		; $4229
	jr z,+			; $422c
	dec (hl)		; $422e
	ret nz			; $422f
+
	ld a,(wActiveRoom)		; $4230
	ld hl,@roomsWithKeyholesTable		; $4233
	call findRoomSpecificData		; $4236
	ld b,a			; $4239
	jr nc,_jumpToShowInfoText	; $423a

	; Check that you have the required key
	call checkTreasureObtained		; $423c
	jr nc,_jumpToShowInfoText	; $423f

	; Play sound effect
	ld a,SND_OPENCHEST		; $4241
	call playSound		; $4243

	; Remember that the keyhole has been opened
	call getThisRoomFlags		; $4246
	set 7,(hl)		; $4249

	; Trigger the associated cutscene
	ld hl,$cfc0		; $424b
	set 0,(hl)		; $424e

	; Create the key sprite
	call _createKeySpriteInteraction		; $4250

	; Increment id to change it to INTERACID_OVERWORLD_KEY_SPRITE
	ld l,Interaction.id		; $4253
	inc (hl)		; $4255

	ld a,b			; $4256
	sub TREASURE_FIRST_KEY			; $4257
	ld l,Interaction.subid		; $4259
	ldi (hl),a		; $425b
	ld (hl),a		; $425c

	; Disable movement, menus
	ld a,$81		; $425d
	ld (wDisabledObjects),a		; $425f
	ld (wMenuDisabled),a		; $4262
	scf			; $4265
	ret			; $4266


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
	.db <ROOM_05c TREASURE_GRAVEYARD_KEY
	.db <ROOM_00a TREASURE_CROWN_KEY
	.db <ROOM_0a5 TREASURE_LIBRARY_KEY ; unused since the present library doesn't have a keyhole
	.db $00
@group1:
	.db <ROOM_10e TREASURE_MERMAID_KEY
	.db <ROOM_1a5 TREASURE_LIBRARY_KEY
	.db $00
@group3:
	.db <ROOM_30f TREASURE_OLD_MERMAID_KEY
	.db $00

@group2:
@group4:
@group5:
	.db $00

.else; ROM_SEASONS

@roomsWithKeyholesTable:
	.dw @group0

@group0:
        .db <ROOM_096 TREASURE_GNARLED_KEY
	.db <ROOM_081 TREASURE_FLOODGATE_KEY
	.db <ROOM_00d TREASURE_DRAGON_KEY
	.db $00

.endif ; ROM_SEASONS


_jumpToShowInfoText:
	ld a,$08		; $4283
	jp showInfoTextForTile		; $4285

;;
; @addr{4288}
_createKeySpriteInteraction:
	call getFreeInteractionSlot		; $4288
	ret nz			; $428b
	ld (hl),INTERACID_DUNGEON_KEY_SPRITE		; $428c
	inc l			; $428e

	; Store tile index in subid
	ldh a,(<hFF8B)	; $428f
	ld (hl),a		; $4291

	ldh a,(<hFF8D)	; $4292
	ld l,Interaction.yh		; $4294
	jp setShortPosition		; $4296

;;
; @addr{4299}
_nextToSubrosiaKeydoor:
.ifdef ROM_SEASONS
	call _specialObjectCheckPushingAgainstTile		; $4257
	jp z,_resetPushingAgainstTileCounter		; $425a
	call _checkFacingBottomOfTile		; $425d
	jr z,+			; $4260
	xor a			; $4262
	ret			; $4263
+
	call _decPushingAgainstTileCounter		; $4264
	jr z,+			; $4267
	dec (hl)		; $4269
	ret nz			; $426a
+
	ld a,GLOBALFLAG_DATING_ROSA		; $426b
	call checkGlobalFlag		; $426d
	jr z,_jumpToShowInfoText	; $4270

	ld a,SND_OPENCHEST		; $4272
	call playSound		; $4274

	call getThisRoomFlags		; $4277
	set 6,(hl)		; $427a

	ld a,TILEINDEX_OPEN_CAVE_DOOR		; $427c
	call setTile		; $427e

	call _createKeySpriteInteraction		; $4281
.endif
	; Stub in ages
	scf
	ret

;;
; From seasons: when next to certain tombstones, ghinis spawn
; @addr{429b}
_nextToGhiniSpawner:
	; No enemies allowed while maple is on the screen
	ld a,(wIsMaplePresent)		; $429b
	or a			; $429e
	ret nz			; $429f

	call _specialObjectCheckPushingAgainstTile		; $42a0
	jp z,_resetPushingAgainstTileCounter		; $42a3

	call _decPushingAgainstTileCounter		; $42a6
	ret nz			; $42a9

	; Change the tile index so it won't keep making ghosts
	ldh a,(<hFF8D)	; $42aa
	ld l,a			; $42ac
	ld h,>wRoomLayout		; $42ad
	ld (hl),$00		; $42af

	; Get long-form position in bc
	call convertShortToLongPosition		; $42b1

	; Create the ghini
	call getFreeEnemySlot		; $42b4
	ret nz			; $42b7
	ld (hl),ENEMYID_GHINI		; $42b8

	; Set subid to $01 to tell it to do a slow spawn, instead of being active right
	; away
	inc l			; $42ba
	inc (hl)		; $42bb

	ld l,Enemy.yh		; $42bc
	ld (hl),b		; $42be
	ld l,Enemy.xh		; $42bf
	ld (hl),c		; $42c1
	ret			; $42c2

;;
; Deals with showing text when pushing against certain tiles, ie. cracked walls, keyholes
; @addr{42c3}
_nextToTileWithInfoText:
	call _specialObjectCheckPushingAgainstTile		; $42c3
	jp z,_resetPushingAgainstTileCounter		; $42c6

	call _decPushingAgainstTileCounter		; $42c9
	ret nz			; $42cc

	call _resetPushingAgainstTileCounter		; $42cd
	ld a,b			; $42d0
	swap a			; $42d1
	and $0f			; $42d3
	rst_jumpTable			; $42d5
	.dw @pot
	.dw @crackedBlock
	.dw @crackedWall
	.dw @unlitTorch
	.dw @rock

@pot:
	; Only show the text if you don't have the power bracelet
	ld a,TREASURE_BRACELET		; $42e0
	call checkTreasureObtained		; $42e2
	ccf			; $42e5
	ret nc			; $42e6
	ld a,$03		; $42e7
	jr showInfoTextForTile		; $42e9

@crackedBlock:
	ld a,$05		; $42eb
	jr showInfoTextForTile		; $42ed

@crackedWall:
	ld a,$06		; $42ef
	jr showInfoTextForTile		; $42f1

@unlitTorch:
	ld a,$07		; $42f3
	jr showInfoTextForTile		; $42f5

@rock:
	ld a,$04		; $42f7
	jr showInfoTextForTile		; $42f9

;;
; Shows text for pressing against a tile, if it has not been shown once on the current
; screen already.
; @param a Index for the table below this function
; @addr{42fb}
showInfoTextForTile:
	ld hl,@data		; $42fb
	rst_addDoubleIndex			; $42fe
	ldi a,(hl)		; $42ff
	ld b,a			; $4300
	ld c,(hl)		; $4301
	call _resetPushingAgainstTileCounter		; $4302

	ld hl,wInformativeTextsShown		; $4305
	ld a,(hl)		; $4308
	and b			; $4309
	ret nz			; $430a

	ld a,(hl)		; $430b
	or b			; $430c
	ld (hl),a		; $430d

	ld b,>TX_5100		; $430e
	call showText		; $4310
	scf			; $4313
	ret			; $4314

; @addr{4315}
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
; @addr{4329}
_specialObjectCheckPushingAgainstTile:
	ld a,(wLinkPushingDirection)		; $4329
	rlca			; $432c
	jr c,++			; $432d

	; Check link isn't moving diagonally
	ld a,(wLinkAngle)		; $432f
	and $07			; $4332
	jr nz,++		; $4334

	call @func_433f		; $4336
	jr nc,++		; $4339

	or d			; $433b
	ret			; $433c
++
	xor a			; $433d
	ret			; $433e

;;
; @param[out] cflag Unset if the object is in one of the corners of its current tile?
; @addr{433f}
@func_433f:
	ld h,d			; $433f
	ld l,SpecialObject.yh		; $4340

	call @func		; $4342
	ret c			; $4345

	ld l,SpecialObject.xh		; $4346
@func:
	ld a,(hl)		; $4348
	and $0f			; $4349
	sub $03			; $434b
	cp $0b			; $434d
	ret			; $434f

;;
; Checks if you have the appropriate key for a door (small key or boss key) and decrements
; the number of keys if applicable.
;
; @param	b	Parameter from interactableTilesTable. Will be $40 or above if the
;			door is a boss key door.
; @param[out]	zflag	Set if you have no keys, or don't have the boss key
; @addr{4350}
_checkAndDecKeyCount:
.ifdef ROM_SEASONS
	ld a,GLOBALFLAG_DATING_ROSA
	call checkGlobalFlag
	ret nz
.endif

	ld a,(wDungeonIndex)		; $4350
	cp $ff			; $4353
	ret z			; $4355

	ld a,b			; $4356
	cp $40			; $4357
	ld h,>wDungeonSmallKeys		; $4359
	ld a,(wDungeonIndex)		; $435b
	jr nc,@bossKeyDoor		; $435e

	; Small key door

	add <wDungeonSmallKeys			; $4360
	ld l,a			; $4362
	ld a,(hl)		; $4363
	or a			; $4364
	ret z			; $4365
	dec (hl)		; $4366

	; Mark displayed key count as needing to be updated
	ld hl,wStatusBarNeedsRefresh		; $4367
	set 4,(hl)		; $436a

	or h			; $436c
	ret			; $436d

@bossKeyDoor:
	ld l,<wDungeonBossKeys		; $436e
	jp checkFlag		; $4370

;;
; Gets the tile in front of the object. This takes the object's position and adds
; a certain value to it depending on its facing direction, then reads from wRoomLayout.
;
; @param	d	Special object (Link)
; @param[out]	a	The tile index in front of the object
; @param[out]	bc	The position of the tile in front
; @addr{4373}
_specialObjectGetTileInFront:
	ld e,SpecialObject.direction		; $4373
	ld a,(de)		; $4375
	ld hl,_nextTileOffsets		; $4376
	rst_addDoubleIndex			; $4379

;;
; @param	hl	Address to get offsets to add to Y, X
; @addr{437a}
_specialObjectGetTileAtOffset:
	ld e,SpecialObject.yh		; $437a
	ld a,(de)		; $437c
	add (hl)		; $437d
	and $f0			; $437e
	ld c,a			; $4380

	inc hl			; $4381
	ld e,SpecialObject.xh		; $4382
	ld a,(de)		; $4384
	add (hl)		; $4385
	swap a			; $4386
	and $0f			; $4388
	or c			; $438a
	ld c,a			; $438b

	ld b,>wRoomLayout		; $438c
	ld a,(bc)		; $438e
	ret			; $438f

; Offsets to get the position of the tile link is standing directly against
_nextTileOffsets:
	.db $fc $00 ; DIR_UP
	.db $00 $07 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT

;;
; Checks the collisions on the tile after the next one.
; This is used to determine whether a pushable block has room to be pushed.
;
; @param[out]	cflag	Set if there is no obstruction (tile is not solid)
; @addr{4398}
_checkTileAfterNext:
	ld a,(wLinkPushingDirection)		; $4398
	ld hl,@offsets		; $439b
	rst_addDoubleIndex			; $439e
	call _specialObjectGetTileAtOffset		; $439f
	ld b,>wRoomCollisions		; $43a2
	ld a,(bc)		; $43a4
	and $0f			; $43a5
	ret nz			; $43a7

	scf			; $43a8
	ret			; $43a9

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

; @addr{43b2}
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

; @addr{43a3}
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
