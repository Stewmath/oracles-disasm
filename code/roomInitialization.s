m_section_superfree roomInitialization NAMESPACE roomInitialization

; Most functions in this file are called from the "initializeRoom" function in bank
; 0 (perhaps indirectly).
;
; This code is in different spots in ages and seasons.

;;
; Check the wRememberedCompanion variables to see if a companion is in this room.
loadRememberedCompanion:
	ld hl,wRememberedCompanionId
	ldi a,(hl)
	or a
	ret z

	ld c,a

	; Check [wActiveGroup] == [wRememberedCompanionGroup]
	ld a,(wActiveGroup)
	cp (hl)
	ret nz

	; Check [wActiveRoom] == [wRememberedCompanionRoom]
	inc l
	ld a,(wActiveRoom)
	cp (hl)
	ret nz

	ld a,(w1Companion.enabled)
	or a
	ret nz

	ld a,c

.ifdef ROM_AGES
	cp SPECIALOBJECT_RAFT
	jr z,@raft
.endif

	ld (w1Companion.id),a
	ld a,$01
	ld (w1Companion.enabled),a
	inc l

	; Set Y/X positions to [wRememberedCompanionY/X]
.ifdef ROM_AGES
	ldi a,(hl)
	ld (w1Companion.yh),a
	ldi a,(hl)
	ld (w1Companion.xh),a
.else; ROM_SEASONS
	ldi a,(hl)
	ld (w1Companion.yh),a
	ld (wLastAnimalMountPointY),a
	ldi a,(hl)
	ld (w1Companion.xh),a
	ld (wLastAnimalMountPointX),a
.endif
	ret

.ifdef ROM_AGES
@raft:
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	ret z

	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERAC_RAFT
	inc l
	ld (hl),$02

	; Set Y/X positions
	ld a,(wRememberedCompanionY)
	ld l,Interaction.yh
	ldi (hl),a
	inc l
	ld a,(wRememberedCompanionX)
	ldi (hl),a
	ret
.endif

;;
; Spawn maple if all the conditions meet (enough kills, valid map, etc)
checkAndSpawnMaple:
	xor a
	ld (wIsMaplePresent),a
	ld a,(wcc85)
	or a
	ret nz

.ifdef ROM_AGES
	ld a,(wActiveGroup)
	ld hl,maplePastLocations
	dec a
	jr z,@startCheck

	inc a
	ret nz

.else; ROM_SEASONS

	ld a,(wActiveGroup)
	or a
	ret nz
.endif

	ld a,(w1Companion.enabled)
	or a
	ret nz

	ld a,(wAnimalCompanion)
.ifdef ROM_AGES
	or a
	jr z,+
.endif
	sub SPECIALOBJECT_RICKY
+
	ld hl,maplePresentLocationsTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
@startCheck:
	ld a,(wActiveRoom)
	call checkFlag
	ret nz

	ld a,MAPLES_RING
	call cpActiveRing
	ld e,30
	jr nz,+
	srl e
+
	ld hl,wMapleKillCounter
	ld a,(hl)
	cp e
	ret c

	; Spawn maple
	ld (hl),$00
	ld hl,w1Companion.enabled
	ld a,$01
	ld (wcc85),a ; Prevent enemies & item drops from spawning
	ld (wIsMaplePresent),a
	ldi (hl),a
	ld (hl),$0e
	ld l,<w1Companion.yh
	ld (hl),$18
	ld l,<w1Companion.xh
	ld (hl),$b8
	ret

.include {"{GAME_DATA_DIR}/mapleLocations.s"}


.ifdef ROM_SEASONS

updateRosaDateStatus:
	ld a,GLOBALFLAG_DATING_ROSA
	call checkGlobalFlag
	ret z

	; Left subrosia?
	ld a,(wActiveGroup)
	or a
	jr nz,@stillDating

@unset:
	ld a,GLOBALFLAG_DATING_ROSA
	jp unsetGlobalFlag

@stillDating:
	cp $03
	jr nz,@spawnIfNotHere

	ld a,(wActiveRoom)
	cp $95 ; Don't spawn her in dancing room
	ret z
	cp $ab ; Despawn her in pirate portal room
	jr z,@unset

	; Spawn rosa if she's not already here
@spawnIfNotHere:
	ld hl,w1ReservedInteraction1.id
@nextInteraction:
	ld a,(hl)
	cp INTERAC_ROSA
	ret z

	inc h
	ld a,h
	cp LAST_INTERACTION_INDEX+1
	jr nz,@nextInteraction

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_ROSA
	inc l
	ld (hl),$01 ; [subid] = 1
	ret
.endif

;;
; An indirect way to call a function.
;
; @param	h	Function index
; @param	l	Gets moved to 'c' before calling the function
functionCaller:
	ld c,l
	ld a,h
	rst_jumpTable
	.dw clearEnemiesKilledList
	.dw addRoomToEnemiesKilledList
	.dw markEnemyAsKilledInRoom
	.dw stub_02_77f4
	.dw generateRandomBuffer
	.dw getRandomPositionForEnemy
.ifdef ROM_AGES
	.dw checkSpawnTimeportalInteraction
.endif

;;
; Marks an enemy as killed so it doesn't respawn for a bit.
addRoomToEnemiesKilledList:
	ld hl,wEnemiesKilledList
	ld a,(wActiveRoom)
	ld b,$08
--
	cp (hl)
	jr z,@found
	inc l
	inc l
	dec b
	jr nz,--

	; Room not found: insert it into wEnemiesKilledList
	ld a,(wEnemiesKilledListTail)
	ld b,a
	inc a
	inc a
	and $0f
	ld (wEnemiesKilledListTail),a
	ld a,b
	and $0f
	add <wEnemiesKilledList
	ld l,a
	ld a,(wActiveRoom)
	ldi (hl),a

	xor a
	ld (hl),a
	ld (wEnemyPlacement.killedEnemiesBitset),a
	ret

@found:
	inc l
	ld a,(hl)
	ld (wEnemyPlacement.killedEnemiesBitset),a
	ret

stub_02_77f4:
	ret

;;
; @param	d	Enemy index
markEnemyAsKilledInRoom:
	ld hl,wEnemiesKilledList
	ld b,$08
	ld a,(wActiveRoom)
--
	cp (hl)
	jr z,@foundRoom
	inc l
	inc l
	dec b
	jr nz,--
	ret

@foundRoom:
	inc l
	ld e,Enemy.enabled
	ld a,(de)
	and $70
	swap a
	ld bc,bitTable
	add c
	ld c,a
	ld a,(bc)
	or (hl)
	ld (hl),a
	ret

;;
clearEnemiesKilledList:
	xor a
	ld (wEnemiesKilledListTail),a
	ld hl,wEnemiesKilledList
	ld b,$10
	jp clearMemory

;;
; This places the numbers $00-$ff into w4RandomBuffer in a random order.
generateRandomBuffer:
	push de

	; Insert numbers $00-$ff into w4TileMap
	ld a,:w4RandomBuffer
	ld ($ff00+R_SVBK),a
	ld hl,w4RandomBuffer
	ld b,$00
--
	ld a,b
	ldi (hl),a
	inc b
	jr nz,--

	; Now randomly swap the contents of the buffer 256 times
	ld hl,w4RandomBuffer+$ff
	ld d,h
	call getRandomNumber
	ld e,a
	call @swapDeHlMemory

	ld b,$ff
--
	call getRandomNumber
	ld c,l
	call multiplyAByC
	ld e,h
	ld l,c
	ld h,>w4RandomBuffer
	call @swapDeHlMemory
	dec l
	jr nz,--

	ld a,$01
	ld ($ff00+R_SVBK),a
	pop de
	ret

@swapDeHlMemory:
	ld a,(de)
	ld c,a
	ld a,(hl)
	ld (hl),c
	ld (de),a
	ret

;;
; @param	hFF8B	Flags from object data. (if bit 2 is set, ignore tile solidity.)
; @param[out]	cflag	Set on failure
getRandomPositionForEnemy:
	ld a,$40
	ld (wEnemyPlacement.randomPlacementAttemptCounter),a

@tryAgain:
	ld hl,wEnemyPlacement.randomPlacementAttemptCounter
	dec (hl)
	jr z,@giveUp

	call getCandidatePositionForEnemy
	ld (wEnemyPlacement.enemyPos),a
	ld c,a
	call checkPositionValidForEnemySpawn
	jr c,@tryAgain

	; If the appropriate flag is set, the tile it's placed on doesn't matter.
	ldh a,(<hFF8B)
	and $04
	jr nz,+

	call checkTileValidForEnemySpawn
	jr c,@tryAgain
+
	xor a
	ret

@giveUp:
	scf
	ret

;;
; Checks that the tile at a given position is valid to place an enemy on.
; (Doesn't check that the position is within a valid boundary.)
;
; @param	c	Candidate position to place enemy
; @param[out]	cflag	nc if enemy can be placed here
checkTileValidForEnemySpawn:
	ld b,>wRoomCollisions
	ld a,(bc)
	or a
	jr nz,++

	; If the tile is non-solid, there may still be an exception for it; lookup the
	; list of nonsolid tiles that enemies can't spawn onto.
	ld b,>wRoomLayout
	ld a,(bc)
	ld hl,enemyUnspawnableTilesTable
	call lookupCollisionTable
	ret nc
++
	scf
	ret

;;
; This checks the boundaries of a position to ensure that it's ok to spawn an enemy here.
; (Doesn't check tile solidity, etc.)
;
; If the current screen transition is "scrolling", it checks that the enemy is not too
; close to the edge of the screen that Link is coming in from.
;
; Otherwise, it checks that the position is at least 3 tiles away vertically or
; horizontally.
;
; @param	c	Candidate position to place enemy
; @param[out]	cflag	nc if enemy can be placed here
checkPositionValidForEnemySpawn:
	; Check if this is a standard transition, or a walk-in-from-outside-screen
	; transition
	ld a,(wScrollMode)
	and $08
	jr z,@nonScrollingTransition

	; This is a standard, scrolling screen transition

@scrollingTransition:
	ld a,(wActiveGroup)
	and $04 ; Less than NUM_SMALL_GROUPS
	ld hl,@smallRoom
	jr z,+
	ld hl,@largeRoom
+
	ld a,(wScreenTransitionDirection)
	add a
	rst_addDoubleIndex

	; Check Y is high enough
	ld a,c
	and $f0
	swap a
	cp (hl)
	jr c,@fail

	; Check Y is low enough
	inc hl
	cp (hl)
	jr nc,@fail

	; Check X is high enough
	ld a,c
	and $0f
	inc hl
	cp (hl)
	jr c,@fail

	; Check X is low enough
	inc hl
	cp (hl)
	jr nc,@fail

	xor a
	ret
@fail:
	scf
	ret

; Data format:
;   b0: minimum enemy y-position (inclusive)
;   b1: maximum enemy y-position (exclusive)
;   b2: minimum enemy x-position
;   b3: maximum enemy x-position
@smallRoom:
	.db  $00  SMALL_ROOM_HEIGHT-3  $00  SMALL_ROOM_WIDTH    ;  DIR_UP
	.db  $00  SMALL_ROOM_HEIGHT    $03  SMALL_ROOM_WIDTH    ;  DIR_RIGHT
	.db  $03  SMALL_ROOM_HEIGHT    $00  SMALL_ROOM_WIDTH    ;  DIR_DOWN
	.db  $00  SMALL_ROOM_HEIGHT    $00  SMALL_ROOM_WIDTH-3  ;  DIR_LEFT

@largeRoom:
	.db  $01  LARGE_ROOM_HEIGHT-3  $01  LARGE_ROOM_WIDTH-1  ;  DIR_UP
	.db  $01  LARGE_ROOM_HEIGHT-1  $03  LARGE_ROOM_WIDTH-1  ;  DIR_RIGHT
	.db  $03  LARGE_ROOM_HEIGHT-1  $01  LARGE_ROOM_WIDTH-1  ;  DIR_DOWN
	.db  $01  LARGE_ROOM_HEIGHT-1  $01  LARGE_ROOM_WIDTH-4  ;  DIR_LEFT

	; (Why is the last one -4 instead of -3? Kind of inconsistent.)


@nonScrollingTransition:
	lda DIR_UP
	ld (wScreenTransitionDirection),a

	; Is Link entering from off-screen? If so, treat this the same as a scrolling
	; transition.
	ld a,(wWarpDestPos)
	ld b,a
	cp $f0
	jr nc,@scrollingTransition

	; Otherwise, this is a warp where link just appears at an arbitrary position.

	and $f0
	swap a
	ld h,a ; h = y-position of warp
	ld a,c
	and $f0
	swap a ; a = y-position of candidate position
	sub h
	call @getAbsoluteValue
	cp $03 ; enemy should be at least 3 tiles away
	jr c,++

@success:
	xor a
	ret
++
	ld a,b
	and $0f
	ld h,a ; h = x-position of warp
	ld a,c
	and $0f ; a = x-position of candidate position
	sub h
	call @getAbsoluteValue
	cp $03
	jr nc,@success

	; Failure (enemy can't be placed here)
	scf
	ret

;;
@getAbsoluteValue:
	bit 7,a
	ret z
	cpl
	inc a
	ret


.include {"{GAME_DATA_DIR}/tile_properties/enemyUnspawnableTiles.s"}


;;
; @param[out]	a	Next value from w4RandomBuffer
getNextValueFromRandomBuffer:
	ld hl,wEnemyPlacement.randomBufferIndex
	inc (hl)

	ld a,:w4RandomBuffer
	ld ($ff00+R_SVBK),a
	ld l,(hl)
	ld h,>w4RandomBuffer
	ld h,(hl)

	ld a,$01
	ld ($ff00+R_SVBK),a
	ld a,h
	ret

;;
; Gets a random position within the room's boundaries that does not already have an enemy
; placed on it.
;
; @param[out]	a	Candidate position for an enemy
getCandidatePositionForEnemy:
	ld a,(wActiveGroup)
	and $04 ; Less than NUM_SMALL_GROUPS
	jr nz,@dungeon

@overworld:
	call getNextValueFromRandomBuffer
	cp SMALL_ROOM_HEIGHT<<4
	jr nc,@overworld

	ld b,a
	and $0f
	cp SMALL_ROOM_WIDTH
	jr nc,@overworld

	call checkEnemyPlacedAtPosition
	jr c,@overworld

	ld a,b
	ret

@dungeon:
	call getNextValueFromRandomBuffer
	cp LARGE_ROOM_HEIGHT<<4
	jr nc,@dungeon

	ld b,a
	and $f0
	jr z,@dungeon ; First row not allowed

	cp (LARGE_ROOM_HEIGHT-1)<<4
	jr z,@dungeon ; Last row not allowed

	ld a,b
	and $0f
	jr z,@dungeon ; First column not allowed

	cp LARGE_ROOM_WIDTH-1
	jr nc,@dungeon ; Last column (and higher) not allowed

	; Can't place multiple enemies in the same position
	call checkEnemyPlacedAtPosition
	jr c,@dungeon

	ld a,b
	ret

;;
; @param	b	Position to check
; @param[out]	cflag	c if an enemy has been placed at position 'b'.
checkEnemyPlacedAtPosition:
	ld a,(wEnemyPlacement.numEnemies)
	or a
	ret z

	push bc
	ld c,a
	ld hl,wEnemyPlacement.placedEnemyPositions
--
	ldi a,(hl)
	cp b
	jr z,+

	dec c
	jr nz,--

	pop bc
	xor a
	ret
+
	pop bc
	scf
	ret


.ifdef ROM_AGES

;;
; Checks if the timeportal exists in the current room, and loads the interaction if so.
checkSpawnTimeportalInteraction:
	xor a
	ld (wcddd),a

	; Check [wPortalGroup]=[wActiveGroup], [wPortalRoom]=[wActiveRoom].
	ld hl,wPortalGroup
	ld a,(wActiveGroup)
	cp (hl)
	ret nz
	inc l
	ld a,(wActiveRoom)
	cp (hl)
	ret nz

	inc l
	ld c,(hl) ; hl = wPortalPos
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERAC_TIMEPORTAL
	ld a,$01
	ld (wcddd),a
	ld l,Interaction.yh
	jp setShortPosition_paramC

;;
; Determines the value for wRoomStateModifier. (For seasons, it's just the season; for
; ages, this indicates whether the room is underwater, or whether the room layout has been
; swapped.
calculateRoomStateModifier:
	ld a,(wActiveGroup)
	or a
	jr nz,@standard

	; Group 0: check for animal companion regions
	ld a,(wRoomPack)
	cp $7f
	jr z,@companionRegion

@standard:
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	ld b,$00
	jr z,+
	inc b
+
	call getThisRoomFlags
	and ROOMFLAG_LAYOUTSWAP
	jr z,+
	inc b
+
	ld a,b
	ld (wRoomStateModifier),a
	ret

@companionRegion:
	ld a,(wAnimalCompanion)
	or a
	jr z,@standard

	sub SPECIALOBJECT_RICKY
	ld (wRoomStateModifier),a
	ret

;;
; If there are whirlpools or pollution tiles on the screen, this creates a part of type
; PART_WHIRLPOOL_POLLUTION_EFFECTS, which applies their effects.
createSeaEffectsPartIfApplicable:
	ld a,(wActiveCollisions)
	ld hl,seaEffectTileTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
--
	ldi a,(hl)
	or a
	ret z

	push hl
	call findTileInRoom
	pop hl
	jr nz,--

	call getFreePartSlot
	ret nz

	ld (hl),PART_SEA_EFFECTS
	ret

.include {"{GAME_DATA_DIR}/tile_properties/seaEffectTiles1.s"}

;;
func_02_7a3a:
	ld a,(wcddd)
	or a
	ret z
	dec a
	jr z,+

	ld (wcddd),a
	ret
+
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERAC_TIMEPORTAL
	ld a,(wPortalPos)
	ld l,Interaction.yh
	jp setShortPosition

.endif ; ROM_AGES

.ends
