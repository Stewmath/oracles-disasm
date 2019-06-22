; Most functions in this file are called from the "initializeRoom" function in bank
; 0 (perhaps indirectly).
;
; This code is in different spots in ages and seasons.

;;
; Check the wRememberedCompanion variables to see if a companion is in this room.
; @addr{768a}
loadRememberedCompanion:
	ld hl,wRememberedCompanionId		; $768a
	ldi a,(hl)		; $768d
	or a			; $768e
	ret z			; $768f

	ld c,a			; $7690

	; Check [wActiveGroup] == [wRememberedCompanionGroup]
	ld a,(wActiveGroup)		; $7691
	cp (hl)			; $7694
	ret nz			; $7695

	; Check [wActiveRoom] == [wRememberedCompanionRoom]
	inc l			; $7696
	ld a,(wActiveRoom)		; $7697
	cp (hl)			; $769a
	ret nz			; $769b

	ld a,(w1Companion.enabled)		; $769c
	or a			; $769f
	ret nz			; $76a0

	ld a,c			; $76a1

.ifdef ROM_AGES
	cp SPECIALOBJECTID_RAFT			; $76a2
	jr z,@raft		; $76a4
.endif

	ld (w1Companion.id),a		; $76a6
	ld a,$01		; $76a9
	ld (w1Companion.enabled),a		; $76ab
	inc l			; $76ae

	; Set Y/X positions to [wRememberedCompanionY/X]
.ifdef ROM_AGES
	ldi a,(hl)		; $76af
	ld (w1Companion.yh),a		; $76b0
	ldi a,(hl)		; $76b3
	ld (w1Companion.xh),a		; $76b4
.else; ROM_SEASONS
	ldi a,(hl)
	ld (w1Companion.yh),a
	ld (wLastAnimalMountPointY),a
	ldi a,(hl)
	ld (w1Companion.xh),a
	ld (wLastAnimalMountPointX),a
.endif
	ret			; $76b7

.ifdef ROM_AGES
@raft:
	ld a,(wAreaFlags)		; $76b8
	and AREAFLAG_PAST			; $76bb
	ret z			; $76bd

	call getFreeInteractionSlot		; $76be
	ret nz			; $76c1

	ld (hl),INTERACID_RAFT		; $76c2
	inc l			; $76c4
	ld (hl),$02		; $76c5

	; Set Y/X positions
	ld a,(wRememberedCompanionY)		; $76c7
	ld l,Interaction.yh		; $76ca
	ldi (hl),a		; $76cc
	inc l			; $76cd
	ld a,(wRememberedCompanionX)		; $76ce
	ldi (hl),a		; $76d1
	ret			; $76d2
.endif

;;
; Spawn maple if all the conditions meet (enough kills, valid map, etc)
; @addr{76d3}
checkAndSpawnMaple:
	xor a			; $76d3
	ld (wIsMaplePresent),a		; $76d4
	ld a,(wcc85)		; $76d7
	or a			; $76da
	ret nz			; $76db

.ifdef ROM_AGES
	ld a,(wActiveGroup)		; $76dc
	ld hl,maplePastLocations	; $76df
	dec a			; $76e2
	jr z,@startCheck	; $76e3

	inc a			; $76e5
	ret nz			; $76e6

.else; ROM_SEASONS

	ld a,(wActiveGroup)
	or a
	ret nz
.endif

	ld a,(w1Companion.enabled)		; $76e7
	or a			; $76ea
	ret nz			; $76eb

	ld a,(wAnimalCompanion)		; $76ec
.ifdef ROM_AGES
	or a			; $76ef
	jr z,+			; $76f0
.endif
	sub SPECIALOBJECTID_RICKY			; $76f2
+
	ld hl,maplePresentLocationsTable	; $76f4
	rst_addDoubleIndex			; $76f7
	ldi a,(hl)		; $76f8
	ld h,(hl)		; $76f9
	ld l,a			; $76fa
@startCheck:
	ld a,(wActiveRoom)		; $76fb
	call checkFlag		; $76fe
	ret nz			; $7701

	ld a,MAPLES_RING		; $7702
	call cpActiveRing		; $7704
	ld e,30			; $7707
	jr nz,+			; $7709
	srl e			; $770b
+
	ld hl,wMapleKillCounter		; $770d
	ld a,(hl)		; $7710
	cp e			; $7711
	ret c			; $7712

	; Spawn maple
	ld (hl),$00		; $7713
	ld hl,w1Companion.enabled	; $7715
	ld a,$01		; $7718
	ld (wcc85),a		; $771a
	ld (wIsMaplePresent),a		; $771d
	ldi (hl),a		; $7720
	ld (hl),$0e		; $7721
	ld l,<w1Companion.yh		; $7723
	ld (hl),$18		; $7725
	ld l,<w1Companion.xh		; $7727
	ld (hl),$b8		; $7729
	ret			; $772b

.include "build/data/mapleLocations.s"


.ifdef ROM_SEASONS

updateRosaDateStatus:
	ld a,GLOBALFLAG_DATING_ROSA		; $5f86
	call checkGlobalFlag		; $5f88
	ret z			; $5f8b

	; Left subrosia?
	ld a,(wActiveGroup)		; $5f8c
	or a			; $5f8f
	jr nz,@stillDating		; $5f90

@unset:
	ld a,GLOBALFLAG_DATING_ROSA		; $5f92
	jp unsetGlobalFlag		; $5f94

@stillDating:
	cp $03			; $5f97
	jr nz,@spawnIfNotHere	; $5f99

	ld a,(wActiveRoom)		; $5f9b
	cp $95 ; Don't spawn her in dancing room
	ret z			; $5fa0
	cp $ab ; Despawn her in pirate portal room
	jr z,@unset	; $5fa3

	; Spawn rosa if she's not already here
@spawnIfNotHere:
	ld hl,w1ReservedInteraction1.id		; $5fa5
@nextInteraction:
	ld a,(hl)		; $5fa8
	cp INTERACID_ROSA			; $5fa9
	ret z			; $5fab

	inc h			; $5fac
	ld a,h			; $5fad
	cp LAST_INTERACTION_INDEX+1			; $5fae
	jr nz,@nextInteraction	; $5fb0

	call getFreeInteractionSlot		; $5fb2
	ret nz			; $5fb5
	ld (hl),INTERACID_ROSA		; $5fb6
	inc l			; $5fb8
	ld (hl),$01 ; [subid] = 1
	ret			; $5fbb
.endif

;;
; An indirect way to call a function.
;
; @param	h	Function index
; @param	l	Gets moved to 'c' before calling the function
; @addr{77b2}
functionCaller:
	ld c,l			; $77b2
	ld a,h			; $77b3
	rst_jumpTable			; $77b4
	.dw _clearEnemiesKilledList
	.dw _addRoomToEnemiesKilledList
	.dw _markEnemyAsKilledInRoom
	.dw _stub_02_77f4
	.dw generateRandomBuffer
	.dw _getRandomPositionForEnemy
.ifdef ROM_AGES
	.dw _checkSpawnTimeportalInteraction
.endif

;;
; Marks an enemy as killed so it doesn't respawn for a bit.
; @addr{77c3}
_addRoomToEnemiesKilledList:
	ld hl,wEnemiesKilledList		; $77c3
	ld a,(wActiveRoom)		; $77c6
	ld b,$08		; $77c9
--
	cp (hl)			; $77cb
	jr z,@found		; $77cc
	inc l			; $77ce
	inc l			; $77cf
	dec b			; $77d0
	jr nz,--		; $77d1

	; Room not found: insert it into wEnemiesKilledList
	ld a,(wEnemiesKilledListTail)		; $77d3
	ld b,a			; $77d6
	inc a			; $77d7
	inc a			; $77d8
	and $0f			; $77d9
	ld (wEnemiesKilledListTail),a		; $77db
	ld a,b			; $77de
	and $0f			; $77df
	add <wEnemiesKilledList			; $77e1
	ld l,a			; $77e3
	ld a,(wActiveRoom)		; $77e4
	ldi (hl),a		; $77e7

	xor a			; $77e8
	ld (hl),a		; $77e9
	ld (wEnemyPlacement.killedEnemiesBitset),a		; $77ea
	ret			; $77ed

@found:
	inc l			; $77ee
	ld a,(hl)		; $77ef
	ld (wEnemyPlacement.killedEnemiesBitset),a		; $77f0
	ret			; $77f3

_stub_02_77f4:
	ret			; $77f4

;;
; @param	d	Enemy index
; @addr{77f5}
_markEnemyAsKilledInRoom:
	ld hl,wEnemiesKilledList		; $77f5
	ld b,$08		; $77f8
	ld a,(wActiveRoom)		; $77fa
--
	cp (hl)			; $77fd
	jr z,@foundRoom			; $77fe
	inc l			; $7800
	inc l			; $7801
	dec b			; $7802
	jr nz,--		; $7803
	ret			; $7805

@foundRoom:
	inc l			; $7806
	ld e,Enemy.enabled		; $7807
	ld a,(de)		; $7809
	and $70			; $780a
	swap a			; $780c
	ld bc,bitTable		; $780e
	add c			; $7811
	ld c,a			; $7812
	ld a,(bc)		; $7813
	or (hl)			; $7814
	ld (hl),a		; $7815
	ret			; $7816

;;
; @addr{7817}
_clearEnemiesKilledList:
	xor a			; $7817
	ld (wEnemiesKilledListTail),a		; $7818
	ld hl,wEnemiesKilledList		; $781b
	ld b,$10		; $781e
	jp clearMemory		; $7820

;;
; This places the numbers $00-$ff into w4RandomBuffer in a random order.
; @addr{7823}
generateRandomBuffer:
	push de			; $7823

	; Insert numbers $00-$ff into w4TileMap
	ld a,:w4RandomBuffer		; $7824
	ld ($ff00+R_SVBK),a	; $7826
	ld hl,w4RandomBuffer		; $7828
	ld b,$00		; $782b
--
	ld a,b			; $782d
	ldi (hl),a		; $782e
	inc b			; $782f
	jr nz,--		; $7830

	; Now randomly swap the contents of the buffer 256 times
	ld hl,w4RandomBuffer+$ff		; $7832
	ld d,h			; $7835
	call getRandomNumber		; $7836
	ld e,a			; $7839
	call @swapDeHlMemory		; $783a

	ld b,$ff		; $783d
--
	call getRandomNumber		; $783f
	ld c,l			; $7842
	call multiplyAByC		; $7843
	ld e,h			; $7846
	ld l,c			; $7847
	ld h,>w4RandomBuffer		; $7848
	call @swapDeHlMemory		; $784a
	dec l			; $784d
	jr nz,--		; $784e

	ld a,$01		; $7850
	ld ($ff00+R_SVBK),a	; $7852
	pop de			; $7854
	ret			; $7855

@swapDeHlMemory:
	ld a,(de)		; $7856
	ld c,a			; $7857
	ld a,(hl)		; $7858
	ld (hl),c		; $7859
	ld (de),a		; $785a
	ret			; $785b

;;
; @param	hFF8B	Flags from object data. (if bit 2 is set, ignore tile solidity.)
; @param[out]	cflag	Set on failure
; @addr{785c}
_getRandomPositionForEnemy:
	ld a,$40		; $785c
	ld (wEnemyPlacement.randomPlacementAttemptCounter),a		; $785e

@tryAgain:
	ld hl,wEnemyPlacement.randomPlacementAttemptCounter		; $7861
	dec (hl)		; $7864
	jr z,@giveUp			; $7865

	call _getCandidatePositionForEnemy		; $7867
	ld (wEnemyPlacement.enemyPos),a		; $786a
	ld c,a			; $786d
	call _checkPositionValidForEnemySpawn		; $786e
	jr c,@tryAgain		; $7871

	; If the appropriate flag is set, the tile it's placed on doesn't matter.
	ldh a,(<hFF8B)	; $7873
	and $04			; $7875
	jr nz,+			; $7877

	call _checkTileValidForEnemySpawn		; $7879
	jr c,@tryAgain			; $787c
+
	xor a			; $787e
	ret			; $787f

@giveUp:
	scf			; $7880
	ret			; $7881

;;
; Checks that the tile at a given position is valid to place an enemy on.
; (Doesn't check that the position is within a valid boundary.)
;
; @param	c	Candidate position to place enemy
; @param[out]	cflag	nc if enemy can be placed here
; @addr{7882}
_checkTileValidForEnemySpawn:
	ld b,>wRoomCollisions		; $7882
	ld a,(bc)		; $7884
	or a			; $7885
	jr nz,++		; $7886

	; If the tile is non-solid, there may still be an exception for it; lookup the
	; list of nonsolid tiles that enemies can't spawn onto.
	ld b,>wRoomLayout		; $7888
	ld a,(bc)		; $788a
	ld hl,enemyUnspawnableTilesTable		; $788b
	call lookupCollisionTable		; $788e
	ret nc			; $7891
++
	scf			; $7892
	ret			; $7893

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
; @addr{7894}
_checkPositionValidForEnemySpawn:
	; Check if this is a standard transition, or a walk-in-from-outside-screen
	; transition
	ld a,(wScrollMode)		; $7894
	and $08			; $7897
	jr z,@nonScrollingTransition		; $7899

	; This is a standard, scrolling screen transition

@scrollingTransition:
	ld a,(wActiveGroup)		; $789b
	and $04			; $789e
	ld hl,@smallRoom		; $78a0
	jr z,+			; $78a3
	ld hl,@largeRoom		; $78a5
+
	ld a,(wScreenTransitionDirection)		; $78a8
	add a			; $78ab
	rst_addDoubleIndex			; $78ac

	; Check Y is high enough
	ld a,c			; $78ad
	and $f0			; $78ae
	swap a			; $78b0
	cp (hl)			; $78b2
	jr c,@fail	; $78b3

	; Check Y is low enough
	inc hl			; $78b5
	cp (hl)			; $78b6
	jr nc,@fail	; $78b7

	; Check X is high enough
	ld a,c			; $78b9
	and $0f			; $78ba
	inc hl			; $78bc
	cp (hl)			; $78bd
	jr c,@fail	; $78be

	; Check X is low enough
	inc hl			; $78c0
	cp (hl)			; $78c1
	jr nc,@fail			; $78c2

	xor a			; $78c4
	ret			; $78c5
@fail:
	scf			; $78c6
	ret			; $78c7

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
	lda DIR_UP			; $78e8
	ld (wScreenTransitionDirection),a		; $78e9

	; Is Link entering from off-screen? If so, treat this the same as a scrolling
	; transition.
	ld a,(wWarpDestPos)		; $78ec
	ld b,a			; $78ef
	cp $f0			; $78f0
	jr nc,@scrollingTransition	; $78f2

	; Otherwise, this is a warp where link just appears at an arbitrary position.

	and $f0			; $78f4
	swap a			; $78f6
	ld h,a ; h = y-position of warp
	ld a,c			; $78f9
	and $f0			; $78fa
	swap a ; a = y-position of candidate position
	sub h			; $78fe
	call @getAbsoluteValue		; $78ff
	cp $03 ; enemy should be at least 3 tiles away
	jr c,++			; $7904

@success:
	xor a			; $7906
	ret			; $7907
++
	ld a,b			; $7908
	and $0f			; $7909
	ld h,a ; h = x-position of warp
	ld a,c			; $790c
	and $0f ; a = x-position of candidate position
	sub h			; $790f
	call @getAbsoluteValue		; $7910
	cp $03			; $7913
	jr nc,@success		; $7915

	; Failure (enemy can't be placed here)
	scf			; $7917
	ret			; $7918

;;
; @addr{7919}
@getAbsoluteValue:
	bit 7,a			; $7919
	ret z			; $791b
	cpl			; $791c
	inc a			; $791d
	ret			; $791e


; This lists the tiles that an enemy can't spawn on (despite being non-solid).
;   b0: tile index
;   b1: unused?

.ifdef ROM_AGES

; @addr{791f}
enemyUnspawnableTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
@collisions4:
	.db $f3 $01
	.db $fd $01
	.db $e9 $01
	.db $00

@collisions1:
@collisions2:
@collisions5:
	.db $f3 $01
	.db $f4 $01
	.db $f5 $01
	.db $f6 $01
	.db $f7 $01
	.db $fd $01
	.db $59 $01
	.db $5a $01
	.db $5b $01
	.db $5c $01
	.db $5d $01
	.db $5e $01
	.db $5f $01
	.db $44 $01
	.db $45 $01
	.db $3c $01
	.db $3d $01
	.db $3e $01
	.db $3f $01

@collisions3:
	.db $00


.else; ROM_SEASONS


enemyUnspawnableTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
@collisions1:
	.db $f3 $01
	.db $fd $01
	.db $00
@collisions2:
@collisions3:
@collisions4:
	.db $f3 $01
	.db $f4 $01
	.db $f5 $01
	.db $f6 $01
	.db $f7 $01
	.db $fd $01
	.db $d0 $01
	.db $59 $01
	.db $5a $01
	.db $5b $01
	.db $5c $01
	.db $5d $01
	.db $5e $01
	.db $5f $01
	.db $44 $01
	.db $45 $01

@collisions5:
	.db $00

.endif


;;
; @param[out]	a	Next value from w4RandomBuffer
; @addr{7959}
_getNextValueFromRandomBuffer:
	ld hl,wEnemyPlacement.randomBufferIndex		; $7959
	inc (hl)		; $795c

	ld a,:w4TileMap		; $795d
	ld ($ff00+R_SVBK),a	; $795f
	ld l,(hl)		; $7961
	ld h,>w4RandomBuffer		; $7962
	ld h,(hl)		; $7964

	ld a,$01		; $7965
	ld ($ff00+R_SVBK),a	; $7967
	ld a,h			; $7969
	ret			; $796a

;;
; Gets a random position within the room's boundaries that does not already have an enemy
; placed on it.
;
; @param[out]	a	Candidate position for an enemy
; @addr{796b}
_getCandidatePositionForEnemy:
	ld a,(wActiveGroup)		; $796b
	and $04			; $796e
	jr nz,@dungeon		; $7970

@overworld:
	call _getNextValueFromRandomBuffer		; $7972
	cp SMALL_ROOM_HEIGHT<<4			; $7975
	jr nc,@overworld	; $7977

	ld b,a			; $7979
	and $0f			; $797a
	cp SMALL_ROOM_WIDTH			; $797c
	jr nc,@overworld	; $797e

	call _checkEnemyPlacedAtPosition		; $7980
	jr c,@overworld		; $7983

	ld a,b			; $7985
	ret			; $7986

@dungeon:
	call _getNextValueFromRandomBuffer		; $7987
	cp $b0			; $798a
	jr nc,@dungeon	; $798c

	ld b,a			; $798e
	and $f0			; $798f
	jr z,@dungeon ; First row not allowed

	cp (LARGE_ROOM_HEIGHT-1)<<4			; $7993
	jr z,@dungeon ; Last row not allowed

	ld a,b			; $7997
	and $0f			; $7998
	jr z,@dungeon ; First column not allowed

	cp LARGE_ROOM_WIDTH-1			; $799c
	jr nc,@dungeon ; Last column (and higher) not allowed

	; Can't place multiple enemies in the same position
	call _checkEnemyPlacedAtPosition		; $79a0
	jr c,@dungeon	; $79a3

	ld a,b			; $79a5
	ret			; $79a6

;;
; @param	b	Position to check
; @param[out]	cflag	Set if an enemy has been placed at position 'b'.
; @addr{79a7}
_checkEnemyPlacedAtPosition:
	ld a,(wEnemyPlacement.numEnemies)		; $79a7
	or a			; $79aa
	ret z			; $79ab

	push bc			; $79ac
	ld c,a			; $79ad
	ld hl,wEnemyPlacement.placedEnemyPositions		; $79ae
--
	ldi a,(hl)		; $79b1
	cp b			; $79b2
	jr z,+			; $79b3

	dec c			; $79b5
	jr nz,--		; $79b6

	pop bc			; $79b8
	xor a			; $79b9
	ret			; $79ba
+
	pop bc			; $79bb
	scf			; $79bc
	ret			; $79bd


.ifdef ROM_AGES

;;
; Checks if the timeportal exists in the current room, and loads the interaction if so.
; @addr{79be}
_checkSpawnTimeportalInteraction:
	xor a			; $79be
	ld ($cddd),a		; $79bf

	; Check [wPortalGroup]=[wActiveGroup], [wPortalRoom]=[wActiveRoom].
	ld hl,wPortalGroup		; $79c2
	ld a,(wActiveGroup)		; $79c5
	cp (hl)			; $79c8
	ret nz			; $79c9
	inc l			; $79ca
	ld a,(wActiveRoom)		; $79cb
	cp (hl)			; $79ce
	ret nz			; $79cf

	inc l			; $79d0
	ld c,(hl) ; hl = wPortalPos
	call getFreeInteractionSlot		; $79d2
	ret nz			; $79d5

	ld (hl),INTERACID_TIMEPORTAL		; $79d6
	ld a,$01		; $79d8
	ld ($cddd),a		; $79da
	ld l,Interaction.yh		; $79dd
	jp setShortPosition_paramC		; $79df

;;
; Determines the value for wRoomStateModifier. (For seasons, it's just the season; for
; ages, this indicates whether the room is underwater, or whether the room layout has been
; swapped.
;
; @addr{79e2}
calculateRoomStateModifier:
	ld a,(wActiveGroup)		; $79e2
	or a			; $79e5
	jr nz,@standard		; $79e6

	; Group 0: check for animal companion regions
	ld a,(wRoomPack)		; $79e8
	cp $7f			; $79eb
	jr z,@companionRegion	; $79ed

@standard:
	ld a,(wAreaFlags)		; $79ef
	and AREAFLAG_UNDERWATER			; $79f2
	ld b,$00		; $79f4
	jr z,+			; $79f6
	inc b			; $79f8
+
	call getThisRoomFlags		; $79f9
	and ROOMFLAG_LAYOUTSWAP			; $79fc
	jr z,+			; $79fe
	inc b			; $7a00
+
	ld a,b			; $7a01
	ld (wRoomStateModifier),a		; $7a02
	ret			; $7a05

@companionRegion:
	ld a,(wAnimalCompanion)		; $7a06
	or a			; $7a09
	jr z,@standard		; $7a0a

	sub SPECIALOBJECTID_RICKY			; $7a0c
	ld (wRoomStateModifier),a		; $7a0e
	ret			; $7a11

;;
; If there are whirlpools or pollution tiles on the screen, this creates a part of type
; PARTID_WHIRLPOOL_POLLUTION_EFFECTS, which applies their effects.
;
; @addr{7a12}
createSeaEffectsPartIfApplicable:
	ld a,(wActiveCollisions)		; $7a12
	ld hl,@table		; $7a15
	rst_addAToHl			; $7a18
	ld a,(hl)		; $7a19
	rst_addAToHl			; $7a1a
--
	ldi a,(hl)		; $7a1b
	or a			; $7a1c
	ret z			; $7a1d

	push hl			; $7a1e
	call findTileInRoom		; $7a1f
	pop hl			; $7a22
	jr nz,--		; $7a23

	call getFreePartSlot		; $7a25
	ret nz			; $7a28

	ld (hl),PARTID_SEA_EFFECTS		; $7a29
	ret			; $7a2b

@table:
	.db @data0-CADDR
	.db @data1-CADDR
	.db @data1-CADDR
	.db @data2-CADDR
	.db @data0-CADDR
	.db @data1-CADDR

; Outside, underwater collisions
@data0:
	.db $eb ; Pollution tile
	.db $e9 ; Whirlpool tile
	.db $00

; Dungeon & Indoor collisions
@data1:
	.db $3c $3d $3e $3f ; All whirlpool tiles?

; Sidescrolling collisions
@data2:
	.db $00


;;
; @addr{7a3a}
func_02_7a3a:
	ld a,($cddd)		; $7a3a
	or a			; $7a3d
	ret z			; $7a3e
	dec a			; $7a3f
	jr z,+			; $7a40

	ld ($cddd),a		; $7a42
	ret			; $7a45
+
	call getFreeInteractionSlot		; $7a46
	ret nz			; $7a49

	ld (hl),INTERACID_TIMEPORTAL		; $7a4a
	ld a,(wPortalPos)		; $7a4c
	ld l,Interaction.yh		; $7a4f
	jp setShortPosition		; $7a51

.endif ; ROM_AGES
