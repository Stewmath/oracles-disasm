; ==============================================================================
; INTERACID_DUNGEON_SCRIPT
; ==============================================================================
D3spawnPitSpreader:
	; Part $0a, subid $00, yh $72
	ld bc,$0072
	jp spawnPitSpreader


D3StatuePuzzleCheck:
	xor a
	ld ($ccba),a
	ld l,$84
	ld h,>wRoomLayout
	ldi a,(hl)
	; blue statue
	cp $2c
	ret nz
	ldi a,(hl)
	cp $2c
	ret nz
	ldi a,(hl)
	cp $2c
	ret nz
	ldi a,(hl)
	; red statue
	cp $2d
	ret nz
	ldi a,(hl)
	cp $2d
	ret nz
	ldi a,(hl)
	cp $2d
	ret nz
	ld a,$01
	ld ($ccba),a
	ret


solvedPuzzleSetRoomFlag07:
	call getThisRoomFlags
	set 7,(hl)
	ld a,SND_SOLVEPUZZLE
	jp playSound


createBridgeSpawner:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_BRIDGE_SPAWNER
	ld l,Part.counter2
	ld (hl),b
	ld l,Part.angle
	ld (hl),c
	ld l,Part.yh
	ld (hl),e
	ret


D4spawnBridgeB2:
	call solvedPuzzleSetRoomFlag07
	ld bc,$0601
	ld e,$59
	jp createBridgeSpawner


D7spawnDarknutBridge:
	ld a,SND_SOLVEPUZZLE
	call playSound
	ld bc,$0801
	ld e,$77
	jp createBridgeSpawner


D8VerticalBridgeUnlockedByOrb:
	call solvedPuzzleSetRoomFlag07
	ld bc,$0c02
	ld e,$3c
	jp createBridgeSpawner


D8VerticalBridgeInLava:
	call solvedPuzzleSetRoomFlag07
	ld bc,$0e00
	ld e,$7b
	jp createBridgeSpawner


D8HorizontalBridgeByMoldorms:
	call solvedPuzzleSetRoomFlag07
	ld bc,$0e03
	ld e,$88
	jp createBridgeSpawner


spawnPitSpreader:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_HOLES_FLOORTRAP
	inc l
	; subid
	ld (hl),b
	ld l,Part.yh
	ld (hl),c
	ret


D3hallToMiniboss_buttonStepped:
	ld a,$01
	ld ($ccbf),a
	ret


D3openEssenceDoorIfBossBeat_body:
	ld a,(wDungeonFlagsAddressH)
	ld b,a
	ld c,<ROOM_SEASONS_453
	ld a,(bc)
	bit 7,a
	ret z
	call getFreeInteractionSlot
	ld (hl),INTERACID_DOOR_CONTROLLER
	ld l,Interaction.angle
	; shutter
	ld (hl),ANGLE_DOWN
	ld l,Interaction.yh
	ld (hl),$07
	ret


D6setFlagBit7InRoomWithLowIndexInAngle:
	ld e,Interaction.angle
	ld a,(de)
	ld l,a
	jr setFlagBit7InRoomLowIndexInL


D6setFlagBit7InFirst4FRoom:
	ld l,<ROOM_SEASONS_4d4
	jr setFlagBit7InRoomLowIndexInL


D6setFlagBit7InLast4FRoom:
	ld l,<ROOM_SEASONS_4d3


setFlagBit7InRoomLowIndexInL:
	ld a,(wDungeonFlagsAddressH)
	ld h,a
	set 7,(hl)
	ret


D6getRandomButtonResult:
	ld b,$00
	ld a,(wActiveTriggers)
	or a
	jr z,+
	ld a,(wFrameCounter)
	and $01
	inc a
	ld b,a
+
	ld a,b
	ld ($cfc1),a
	ret


D6spawnFloorDestroyerAndEscapeBridge:
	call getFreePartSlot
	ret nz

	ld (hl),PARTID_HOLES_FLOORTRAP
	inc l
	ld (hl),$04

	ld bc,$0603
	ld e,$14
	jp createBridgeSpawner


D6spawnChestAfterCrystalTrapRoom_body:
	xor a
	ld ($cfd0),a
	call getThisRoomFlags
	inc hl
	res 5,(hl)
	ret


warpToD7Entrance:
	ld hl,@warpDestVariables
	jp setWarpDestVariables
@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_55b $00 $57 $03


D7randomlyPlaceNonEnemyArmos_body:
	call getRandomNumber
	and $07
	ld hl,@armosPositions
	rst_addAToHl
	ld l,(hl)
	ld h,$cf
	ld (hl),$25
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld h,$df
	ld (hl),$25

	xor a
	ld ($ff00+R_SVBK),a

	call getFreeEnemySlot
	ret nz

	ld (hl),ENEMYID_ARMOS
	inc l
	ld (hl),$00
	ld l,Enemy.yh
	ld (hl),$27
	ld l,Enemy.xh
	ld (hl),$a0
	ret
@armosPositions:
	.db $36 $38 $45 $49
	.db $65 $69 $76 $78


D7MagnetBallRoom_removeChest:
	call objectGetTileAtPosition
	cp TILEINDEX_DUNGEON_a3
	ret z
	ld c,l
	ld a,TILEINDEX_DUNGEON_a3
	call setTile
	jr +


D7MagnetBallRoom_addChest:
	call objectGetTileAtPosition
	cp TILEINDEX_CHEST
	ret z
	cp TILEINDEX_CHEST_OPENED
	ret z
	ld c,l
	ld a,TILEINDEX_CHEST
	call setTile
	ld a,SND_SOLVEPUZZLE
	call playSound
+
	jp objectCreatePuff


D7dropKeyDownAFloor:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),$30
	inc l
	ld (hl),$01
	call objectCopyPosition
	call getThisRoomFlags
	set 6,(hl)
	; room below
	ld l,<ROOM_SEASONS_545
	set 7,(hl)
	ld a,SND_SOLVEPUZZLE
	jp playSound


checkFirstPoeBeaten:
	ld a,<ROOM_SEASONS_556
checkPoeBeaten:
	call getARoomFlags
	bit 6,(hl)
	ld a,$01
	jr nz,+
	dec a
+
	ld ($cfc1),a
	ret


checkSecondPoeBeaten:
	ld a,<ROOM_SEASONS_54e
	jr checkPoeBeaten


D8armosCheckIfWillMove:
	ld a,(wLinkUsingItem1)
	or a
	jr nz,+
	ld a,(wFrameCounter)
	rrca
	ret c

	ld h,d
	ld l,Interaction.direction
	dec (hl)
	ret nz

	call getFreeEnemySlot
	jr nz,+
	ld (hl),ENEMYID_ARMOS
	ld l,Enemy.yh
	ld (hl),$27
	ld l,Enemy.xh
	ld (hl),$a0
	ld a,$45
	ld (wcca2),a
	ld a,SND_SOLVEPUZZLE
	call playSound
	call getThisRoomFlags
	set 7,(hl)
+
	ld e,Interaction.angle
	ld a,$01
	ld (de),a
	ret


D8setSpawnAtLavaHole:
	ld a,TILEINDEX_LAVA_HOLE
	call findTileInRoom
	ld a,l
	ld l,Interaction.yh
	ld h,d
	jp setShortPosition


D8SpawnLimitedFireKeese:
	ld a,(wDisabledObjects)
	or a
	ret nz
	ld b,ENEMYID_FIRE_KEESE
	call countFireKeese
	cp $04
	ret nc
	call getRandomNumber
	cp $40
	ret c
	call getFreeEnemySlot_uncounted
	ret nz
	ld (hl),ENEMYID_FIRE_KEESE
	inc l
	ld (hl),$01
	jp objectCopyPosition


countFireKeese:
	ld c,$00
	ld hl,$d080
-
	ldi a,(hl)
	or a
	jr z,+
	ld a,(hl)
	cp b
	jr nz,+
	inc c
+
	dec l
	inc h
	ld a,h
	cp $e0
	jr c,-
	ld a,c
	or a
	ret


D8checkAllIceBlocksInPlace:
	xor a
	ld ($cfc1),a
	ld h,>wRoomLayout
	ld l,$4d
	ld a,TILEINDEX_PUSHABLE_ICE_BLOCK
	cp (hl)
	ret nz
	ld l,$5d
	cp (hl)
	ret nz
	ld l,$6d
	cp (hl)
	ret nz
	ld a,$01
	ld ($cfc1),a
	ret


D6RandomButtonSpawnRopes:
	ld e,$06
-
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMYID_ROPE
	inc l
	ld (hl),$01
	call @spawnRopeAtRandomPosition
	dec e
	jr nz,-
	ret
@spawnRopeAtRandomPosition:
	call getRandomNumber
	and $07
	inc a
	swap a
	ld b,a
	bit 7,a
	jr nz,@spawnRopeAtRandomPosition
	; b is 1 - 7
	call getRandomNumber
	and $07
	add $03
	; a is 3 - 10
	or b
	ld b,$ce
	ld c,a
	ld a,(bc)
	or a
	jr nz,@spawnRopeAtRandomPosition
	ld l,Enemy.yh
	jp setShortPosition_paramC


toggleBlocksInAngleBitsHit:
	ld e,Interaction.angle
	ld a,(de)
	ld b,a
	ld a,(wToggleBlocksState)
	and b
	cp b
	ld a,$01
	jr z,+
	xor a
+
	ld (wActiveTriggers),a
	ret


createD7Trampoline:
	ld e,Interaction.angle
	ld a,(de)
	ld c,a
	ld b,INTERACID_TRAMPOLINE
	jp objectCreateInteraction


D9forceRoomClearsOnDungeonEntry:
	call getThisRoomFlags
	ld l,<ROOM_SEASONS_593
	res 6,(hl)
	inc l
	res 6,(hl)
	inc l
	res 6,(hl)
	ret


D8createFiresGoingOut:
	ld a,TILEINDEX_UNLIT_TORCH
	call findTileInRoom
	ret nz

	call createLightableTorches
-
	ld a,TILEINDEX_UNLIT_TORCH
	call backwardsSearch
	ret nz
	call createLightableTorches
	jr -


createLightableTorches:
	push hl
	ld c,l
	call getFreePartSlot
	jr nz,+
	ld (hl),PARTID_LIGHTABLE_TORCH
	inc l
	ld (hl),$01
	ld l,Part.counter2
	ld (hl),$30
	ld l,Part.yh
	call setShortPosition_paramC
+
	pop hl
	dec hl
	ret


; ==============================================================================
; INTERACID_MAKU_CUTSCENES
; ==============================================================================
seasonsFunc_15_571a:
	call fadeoutToBlackWithDelay
	jr +

	call fadeinFromBlackWithDelay
+
	ld a,$ff
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	ld a,$01
	ld (wDirtyFadeSprPalettes),a
	ld a,$fe
	ld (wFadeSprPaletteSources),a
	ret

seasonsFunc_15_5735:
	ld c,a
	call checkIsLinkedGame
	jr z,+
	ld a,c
	add $1b
	ld c,a
+
	ld b,<TX_1717
	jp showText

; var3f is $01 if a == var3e else $00
seasonsFunc_15_5744:
	ld a,$10
	jr +
seasonsFunc_15_5748:
	ld a,$08
+
	ld h,d
	ld l,Interaction.var3e
	ld b,(hl)
	and b
	ld l,Interaction.var3f
	ld (hl),$01
	ret nz
	ld (hl),$00
	ret


makuTree_checkGateHit:
	ld a,(w1WeaponItem.id)
	cp ITEMID_SWORD
	ret nz
	ld a,(wcc63)
	or a
	ret nz
	call objectCheckCollidedWithLink_notDead
	ret nc
	ld a,$01
	ld ($cfc0),a
	ret


seasonsFunc_15_576c:
	ld e,Interaction.subid
	ld a,(de)
	cp $04
	ret nz
	call checkIsLinkedGame
	ret z
	; not linked, or not outside d5
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_LINKED_CUTSCENE
	inc l
	ld (hl),$04
	ld l,Interaction.y
	ld (hl),$28
	ld l,Interaction.x
	ld (hl),$58
	ret


; ==============================================================================
; INTERACID_SEASON_SPIRITS_SCRIPTS
; ==============================================================================
seasonsSpirit_createSwirl:
	ld e,Interaction.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Interaction.yh
	ld b,(hl)
	ld l,Interaction.xh
	ld c,(hl)
	ld a,$6e
	jp createEnergySwirlGoingIn


spawnSeasonsSpiritSubId00:
	ld b,$00
	jr +


spawnSeasonsSpiritSubId01:
	ld b,$01
+
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_SEASONS_FAIRY
	ld e,Interaction.var03
	ld a,(de)
	inc l
	ldi (hl),a
	ld (hl),b
	ld l,Interaction.yh
	ld (hl),$18
	ld l,Interaction.xh
	ld (hl),$70
	ld e,Interaction.relatedObj1+1
	ld a,h
	ld (de),a
	ret


seasonsSpirits_checkPostSeasonGetText:
	ld a,(wObtainedSeasons)
	add a
	call getNumSetBits
	ld h,d
	ld l,Interaction.var3f
	ld (hl),$00
	cp $04
	ret nz
	inc (hl)
	ld a,(wActiveRoom)
	cp <ROOM_SEASONS_5f5
	ret z
	inc (hl)
	ret


; ==============================================================================
; INTERACID_MALON
; ==============================================================================
checkTalonReturned:
	ld a,>ROOM_SEASONS_5b6
	ld b,<ROOM_SEASONS_5b6
	call getRoomFlags
	and $40
	ld a,$01
	jr nz,+
	xor a
+
	ld e,Interaction.var3c
	ld (de),a
	ret


; ==============================================================================
; INTERACID_DUNGEON_WISE_OLD_MAN
; ==============================================================================
dungeonWiseOldMan_setLinksInvincibilityCounterTo0:
	xor a
	ld (w1Link.invincibilityCounter),a
	ret


; ==============================================================================
; INTERACID_SOKRA
; ==============================================================================
sokra_alert:
	ld a,$04
	call interactionSetAnimation
	ld b,$f0
	ld c,$fc
	ld a,$40
	jp objectCreateExclamationMark

villageSokra_waitUntilLinkInPosition:
	call objectApplySpeed
	ld c,$10
	call objectCheckLinkWithinDistance
	ret nc
	ld e,$76
	ld a,$01
	ld (de),a
	ret

seasonsFunc_15_5802:
	ld e,$4b
	ld a,(de)
	ld hl,$d00b
	cp (hl)
	jp nz,objectApplySpeed
	ld e,$76
	ld a,$01
	ld (de),a
	ret

seasonsFunc_15_5812:
	ld b,a
	push bc
	call objectApplySpeed
	ld e,$4b
	ld a,(de)
	pop bc
	sub b
	ret nz
	ld e,$76
	ld (de),a
	ret

villageSokra_checkStageInGame:
	ld b,$00
	ld a,(wEssencesObtained)
	bit 1,a
	jr z,+
	inc b
	ld a,GLOBALFLAG_SEASON_ALWAYS_SPRING
	call checkGlobalFlag
	jr z,+
	inc b
+
	ld hl,$cfc0
	ld (hl),b
	ret

suburbsSokra_jumpOffStump:
	call objectApplySpeed
	ld c,$10
	jp objectUpdateSpeedZ_paramC

seasonsFunc_15_5840:
	ld e,$4b
	ld a,(de)
	ld hl,$d00b
	cp (hl)

seasonsFunc_15_5847:
	ld a,ANGLE_DOWN
	jr c,+
	xor a
+
	ld e,Interaction.angle
	ld (de),a
	ret


; ==============================================================================
; INTERACID_BIPIN
; ==============================================================================

;;
; Show some text based on bipin's subid (expected to be 1-9).
bipin_showText_subid1To9:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@textIndices-1
	rst_addAToHl
	ld b,>TX_4300
	ld c,(hl)
	jp showText

@textIndices:
	.db <TX_4302
	.db <TX_4303
	.db <TX_4303
	.db <TX_4304
	.db <TX_4305
	.db <TX_4306
	.db <TX_4307
	.db <TX_4308
	.db <TX_4308


; ==============================================================================
; INTERACID_BLOSSOM
; ==============================================================================

;;
; @param	a	Value to write
setNextChildStage:
	ld hl,wNextChildStage
	ld (hl),a
	ret

;;
; @param	a	Bit to set
setc6e2Bit:
	ld hl,wc6e2
	jp setFlag

;;
; @param	a	Bit to check
checkc6e2BitSet:
	ld hl,wc6e2
	call checkFlag
	ld a,$01
	jr nz,+
	xor a
+
	ld e,Interaction.var3b
	ld (de),a
	ret

;;
; @param	a	Rupee value (see constants/rupeeValues.s)
blossom_checkHasRupees:
	call cpRupeeValue
	ld e,Interaction.var3c
	ld (de),a
	ret

;;
blossom_addValueToChildStatus:
	ld hl,wChildStatus
	add (hl)
	ld (hl),a
	ret

;;
; After naming the child, wChildStatus gets set to a random value from $01-$03.
blossom_decideInitialChildStatus:
	ld hl,wKidName
	ld b,$00
@nextChar:
	ldi a,(hl)
	or a
	jr z,@parsedName
	and $0f
	add b
	ld b,a
	jr @nextChar
@parsedName:
	ld a,b
--
	sub $03
	jr nc,--
	add $04
	ld (wChildStatus),a
	ret

;;
blossom_openNameEntryMenu:
	ld a,$07
	jp openMenu


; ==============================================================================
; INTERACID_S_SUBROSIAN
; ==============================================================================
subrosianFunc_58ac:
	ld hl,$cfde
	jr +
subrosianFunc_58b1:
	ld hl,$cfdc
+
	ld (hl),d
	inc hl
	ld (hl),$58
	ret

subrosian_knockLinkOut:
	ld a,$10
	ld ($cc6b),a
	ld hl,$d008
	ld (hl),$03
	ret

subrosianFunc_58c4:
	ld a,($d00b)
	ld e,$4b
	ld (de),a
	ret

subrosian_setYAboveLink:
	ld a,($d00b)
	sub $08
	ld e,$4b
	ld (de),a
	ret

subrosianFunc_58d4:
	ld e,$4d
	ld a,(de)
	ld b,a
	ld c,$f2
	jr +

subrosianFunc_58dc:
	ld e,$4d
	ld a,(de)
	ld b,a
	ld c,$0e
+
	ld a,($cfc1)
	add c
	sub b
	ld e,$47
	ld (de),a
	ret

subrosian_giveFoolsOre:
	ld a,TREASURE_FOOLS_ORE
	jp giveTreasure


; ==============================================================================

linkedNpc_checkSecretBegun:
	ld a,GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	ld h,d
	ld l,Interaction.var3e
	add (hl)
	call checkGlobalFlag
	ret z
	ld h,d
	ld l,Interaction.var3f
	ld (hl),$01
	ret


;;
linkedNpc_generateSecret:
	ld h,d
	ld l,Interaction.var3e
	ld b,(hl)
	ld a,GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	add b
	call setGlobalFlag
	ld a,$00
	add b
	ld (wShortSecretIndex),a
	ld bc,$0003
	jp secretFunctionCaller


;;
linkedNpc_initHighTextIndex:
	ld c,a
	ld a,>TX_5300
	call interactionSetHighTextIndex
	ld a,c


;;
; Loads a text index for linked npcs. Each linked npc has text indices that they say.
;
; @param	a	Index of text (0-4)
linkedNpc_calcLowTextIndex:
	add <TX_5300
	ld c,a

	; a = [var3e]*6
	ld e,Interaction.var3e
	ld a,(de)
	ld b,a
	add a
	add b
	add a

	add c
	ld e,Interaction.textID
	ld (de),a
	ret


; ==============================================================================
; INTERACID_S_SUBROSIAN (cont.)
; ==============================================================================
subrosian_checkSignsDestroyed:
	ld a,(wTotalSignsDestroyed)
	ld b,a
	or a
	ld c,0
	jr z,+
	inc c
	cp 20
	jr c,+
	inc c
	cp 50
	jr c,+
	inc c
	cp 90
	jr c,+
	inc c
	cp 100
	jr c,+
	inc c
+
	ld a,c
	ld ($cfc0),a
	ld a,b
	call hexToDec
	swap c
	or c
	ld (wTextNumberSubstitution),a
	ld a,b
	ld (wTextNumberSubstitution+1),a
	ret

subrosian_giveSignRing:
	ldbc SIGN_RING $00
	jp giveRingToLink

subrosian_fakeReset:
	; fake reset
	ld a,$09
	jp openMenu

subrosianFunc_5968:
	ld e,$4d
	ld a,(de)
	srl a
	add $10
	ld e,$47
	ld (de),a
	ret


; ==============================================================================
; INTERACID_DATING_ROSA_EVENT
; ==============================================================================
rosa_tradeRibbon:
	ld e,Interaction.var37
	xor a
	ld (de),a
	ld a,TREASURE_RIBBON
	jp loseTreasure

rosa_startDate:
	ld h,d
	ld l,Interaction.subid
	ld (hl),$01
	ld l,Interaction.state
	xor a
	ldi (hl),a
	ld (hl),a
	ld a,MUS_ROSA_DATE
	ld (wActiveMusic),a
	jp playSound


; ==============================================================================
; INTERACID_CHILD
; ==============================================================================

;;
; @param	a	Value to add
child_addValueToChildStatus:
	ld hl,wChildStatus
	add (hl)
	ld (hl),a
	ret

child_checkHasRupees:
	call cpRupeeValue
	ld e,Interaction.var3c
	ld (de),a
	ret

;;
; Stores the response to the "love or courage" question.
child_setStage8ResponseToSelectedTextOption:
	ld hl,wSelectedTextOption
	add (hl)

;;
child_setStage8Response:
	ld (wChildStage8Response),a
	ret

;;
child_playMusic:
	ld a,(wChildStage8Response)
	or a
	jr nz,+
	ld a,MUS_ZELDA_SAVED
	jp playSound
+
	ld a,MUS_PRECREDITS
	jp playSound

;;
child_giveHeartRefill:
	ld c,$40
	jr ++

;;
child_giveOneHeart:
	ld c,$04
++
	ld a,TREASURE_HEART_REFILL
	jp giveTreasure

;;
; @param	a	Rupee value
child_giveRupees:
	ld c,a
	ld a,TREASURE_RUPEES
	jp giveTreasure


; ==============================================================================
; INTERACID_MAYORS_HOUSE_NPC
; INTERACID_S_GORON
; ==============================================================================
getNextRingboxLevel:
	ld a,(wRingBoxLevel)
	dec a
	ld c,$03
	jr z,+
	ld c,$05
+
	ld b,$00
	ld hl,wTextNumberSubstitution
	ld (hl),c
	inc hl
	ld (hl),b
	ret


; ==============================================================================
; INTERACID_PIRATIAN
; INTERACID_PIRATIAN_CAPTAIN
; ==============================================================================
showPiratianTextBasedOnD6Done:
	ld b,a
	ld e,$42
	ld a,(de)
	add a
	add b
	ld hl,@subidTable-2
	rst_addAToHl
	ld b,>TX_3a00
	ld c,(hl)
	jp showText
@subidTable:
	; D6 not done - D6 done
	.db <TX_3a00 <TX_3a01
	.db <TX_3a02 <TX_3a03
	.db <TX_3a04 <TX_3a05
	.db <TX_3a06 <TX_3a07
	.db <TX_3a08 <TX_3a08
	.db <TX_3a09 <TX_3a09

piratian_waitUntilJumpDone:
	ld c,$30
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d
	ld l,Interaction.var3d
	ld (hl),$01
	ret

;;
; @param	b	Tile index
piratian_replaceTileAtPiratian:
	ld b,a
	ld e,$4d
	ld a,(de)
	and $f0
	swap a
	ld c,a
	ld a,b
	jp setTile

headToPirateShip:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP
	call setGlobalFlag
	ld hl,@warpDestVariables
	call setWarpDestVariables
	ld a,$8d
	jp playSound
@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_174 $00 $42 $83

piratesDeparting_spawnPirateFromShip:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PIRATIAN
	inc l
	ld (hl),$0c
	ld l,Interaction.yh
	ld (hl),$28
	ld l,Interaction.xh
	ld (hl),$78
	ret

linkedGame_spawnAmbi:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_S_AMBI
	inc l
	ld (hl),$03
	ld l,Interaction.yh
	ld (hl),$88
	ld l,Interaction.xh
	ld (hl),$50
	ret

piratianCaptain_simulatedInput:
	ld hl,@simulatedInput
	ld a,:@simulatedInput
	jp setSimulatedInputAddress

@simulatedInput:
	dwb 80 BTN_RIGHT
	dwb  4 $00
	dwb 32 BTN_UP
	dwb  8 $00
	.dw $ffff

piratianCaptain_setLinkInvisible:
	ld hl,w1Link.visible
	res 7,(hl)
	ret

piratianCaptain_setInvisible:
	ld h,d
	ld l,Interaction.visible
	res 7,(hl)
	ret

pirateCaptain_freezeLinkForCutscene:
	call setLinkForceStateToState08
	ld hl,$d008
	ld (hl),$01
	ret

seasonsFunc_15_5a70:
	ld e,$4d
	ld a,(de)
	ld hl,$d00d
	sub (hl)
	ld b,a
	add $0c
	cp $18
	ret nc
	ld a,($d00b)
	cp $38
	ret c
	ld a,b
	sub (hl)
	ld a,$01
	jr nc,+
	inc a
+
	ld e,$79
	ld (de),a
	ret

unluckySailor_checkHave777OreChunks:
	xor a
	ld e,$79
	ld (de),a
	ld hl,wNumOreChunks
	ldi a,(hl)
	cp $77
	ret nz
	ld a,(hl)
	cp $07
	ret nz
	ld a,$01
	ld (de),a
	ret

unluckySailor_increaseBombCapacityAndCount:
	ld hl,wMaxBombs
	ld a,(hl)
	add $20
	ldd (hl),a
	ld (hl),a
	jp setStatusBarNeedsRefreshBit1


; ==============================================================================
; INTERACID_S_ZELDA
; ==============================================================================
zelda_checkIfLinkFullyHealed:
	ld hl,wLinkMaxHealth
	ld a,(wLinkHealth)
	cp (hl)
	ret nz
	ld e,$7f
	ld a,$01
	ld (de),a
	ret


; Unused function?
	ld hl,wLinkHealth
	ld a,($cbe4)
	cp (hl)
	ret nz
	ld e,$7f
	ld a,$01
	ld (de),a
	ret


zelda_createExclamationMark:
	ld b,$f8
	ld c,$10
	ld a,$28
	jp objectCreateExclamationMark


resetBit5ofRoomFlags:
	call getThisRoomFlags
	res 5,(hl)
	ret


; ==============================================================================
; INTERACID_DIN_DANCING_EVENT
; ==============================================================================
dinDancing_spinLink:
	ld hl,w1Link.direction
	ld a,(hl)
	xor $02
	add $09
	jp interactionSetAnimation

dinDancingEvent_setTextAdd_0a_ifLinked:
	ld b,a
	ld c,$00
	call checkIsLinkedGame
	jr z,+
	ld c,$0a
+
	ld a,b
	add c
	ld h,d
	ld l,Interaction.textID
	ldi (hl),a
	ld (hl),>TX_0c00
	ret


; ==============================================================================
; INTERACID_BIGGORON
; ==============================================================================
biggoron_loadAnimationData:
	jp loadAnimationData

biggoron_checkSoupGiven:
	ld a,TREASURE_TRADEITEM
	call checkTreasureObtained
	ld h,d
	ld l,Interaction.var3f
	jr nc,+
	cp $05
	jr c,+
	ld (hl),$01
	ret
+
	ld (hl),$00
	ret

biggoron_createSparkleAtLink:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_SPARKLE
	push de
	ld de,w1Link.yh
	call objectCopyPosition_rawAddress
	pop de
	ret
	
	
; ==============================================================================
; INTERACID_HEAD_SMELTER
; ==============================================================================
headSmelter_loseBombFlower:
	ld a,TREASURE_BOMB_FLOWER_LOWER_HALF
	call loseTreasure
	ld a,TREASURE_BOMB_FLOWER
	jp loseTreasure

headSmelter_loadHideFromBombScript:
	ld hl,$cfde
	ld bc,mainScripts.headSmelterAtTempleScript_hideFromBomb
	jr headSmelter_loadScriptIntoWram

headSmelter_loadDanceMovements:
	ld a,$0b
	ld ($cc6a),a
	ld hl,w1Link.yh
	ld a,$68
	sub (hl)
	ld ($cc6c),a
	ld l,<w1Link.direction
	ld (hl),DIR_DOWN
	ld l,<w1Link.angle
	ld (hl),ANGLE_DOWN
	ld hl,$cfde
	ld bc,mainScripts.headSmelterScript_danceMovementText1
	call headSmelter_loadScriptIntoWram
	ld hl,$cfdc
	ld bc,mainScripts.headSmelterScript_danceMovementText2

headSmelter_loadScriptIntoWram:
	ldi a,(hl)
	ld l,(hl)
	ld h,a
	ld (hl),c
	inc l
	ld (hl),b
	ret

headSmelter_throwRedOreIn:
	ld c,$04
	jr ++
	
headSmelter_throwBlueOreIn:
	ld c,$05
++
	ld b,INTERACID_MISC_STATIC_OBJECTS
	jp objectCreateInteraction

headSmelter_smeltingDone:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_BOSS_DEATH_EXPLOSION
	ld l,Part.yh
	ld (hl),$1c
	ld l,Part.xh
	ld (hl),$70
	ret

headSmelter_giveHardOre:
	ld a,TREASURE_RED_ORE
	call loseTreasure
	ld a,TREASURE_BLUE_ORE
	call loseTreasure
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),TREASURE_HARD_ORE
	ld l,Interaction.yh
	ld (hl),$1c
	ld l,Interaction.xh
	ld (hl),$70
	ret

headSmelter_setTiles:
	ld a,$e8
	ld c,$06
	call setTile
	ld a,$e9
	ld c,$07
	call setTile
	ld a,$ea
	ld c,$16
	call setTile
	ld a,$eb
	ld c,$17
	call setTile
	ld a,$70
	jp playSound

headSmelter_resetTiles:
	ld a,$e4
	ld c,$06
	call setTile
	ld a,$e5
	ld c,$07
	call setTile
	ld a,$e6
	ld c,$16
	call setTile
	ld a,$e7
	ld c,$17
	jp setTile
	
headSmelter_disableScreenTransitions:
	ld a,$01
--
	ld (wDisableScreenTransitions),a
	ld (wInShop),a
	ret
	
headSmelter_enableScreenTransitions:
	xor a
	jr --


; ==============================================================================
; INTERACID_SUBROSIAN_AT_D8
; ==============================================================================
subrosianAtD8_spawnitem:
	call refreshObjectGfx
	ldh a,(<hActiveObject)
	ld d,a
	ld b,INTERACID_SUBROSIAN_AT_D8_ITEMS
	jp objectCreateInteractionWithSubid00


; ==============================================================================
; INTERACID_INGO
; ==============================================================================
ingo_animatePlaySound:
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.speedZ
	ld (hl),$00
	inc hl
	ld (hl),$fe
	ld a,SND_JUMP
	jp playSound

ingo_jump:
	ld c,$30
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d
	ld l,Interaction.var3d
	ld (hl),$01
	ret


; ==============================================================================
; INTERACID_BLAINO_SCRIPT
; ==============================================================================
blainoScript_saveVariables:
	ld a,GLOBALFLAG_CHEATED_BLAINO
	call checkGlobalFlag
	ld a,$04
	jr z,+
	ld a,$05
+
	ld e,Interaction.var38
	ld (de),a
	call cpRupeeValue
	ld e,Interaction.var37
	ld (de),a
	ld a,$00
	ld ($cced),a
	xor a
	ld e,Interaction.var31
	ld (de),a
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret

blainoScript_takeRupees:
	ld e,Interaction.var38
	ld a,(de)
	jp removeRupeeValue

blainoScript_adjustRupeesInText:
	ld e,Interaction.var38
	ld a,(de)
	call getRupeeValue
	ld hl,wTextNumberSubstitution
	ld (hl),c
	inc hl
	ld (hl),b
	ret

blainoScript_give30Rupees:
	ld c,RUPEEVAL_030
	ld a,TREASURE_RUPEES
	jp giveTreasure

blainoScript_clearItemsAndPegasusSeeds:
	call clearPegasusSeedCounter
	call clearAllParentItems
	call dropLinkHeldItem
	jp clearItems

blainoScript_setLinkPositionAndState:
	call setLinkForceStateToState08
	ld hl,w1Link.direction
	ld (hl),DIR_LEFT
	ld l,<w1Link.yh
	ld (hl),$40
	ld l,<w1Link.xh
	ld (hl),$60
	xor a
	ld l,<w1Link.zh
	ld (hl),a
	ld (wLinkInAir),a
	ret

blainoScript_spawnBlainoEnemy:
	ld e,Interaction.var39
	ld a,(de)
	ld h,a
	ld l,Interaction.state
	ld (hl),$02
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMYID_BLAINO
	ld l,Enemy.yh
	ld (hl),$40
	ld l,Enemy.xh
	ld (hl),$40
	ld e,$56
	ld a,$80
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

blainoScript_setBlainoPosition:
	push de
	call clearEnemies
	pop de
	ld bc,$4040
	call spawnBlainoAtPosition
	ret nz
	ld l,Interaction.yh
	ld b,(hl)
	ld l,Interaction.xh
	ld c,(hl)
	ld e,Interaction.yh
	ld a,b
	ld (de),a
	ld e,Interaction.xh
	ld a,c
	ld (de),a
	ret

blainoScript_spawnBlaino:
	ld bc,$4050
spawnBlainoAtPosition:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_BLAINO
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c
	ld e,Interaction.var39
	ld a,h
	ld (de),a
	xor a
	ret

putAwayLinksItems:
	ldh (<hFF8B),a
	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
	ld hl,wInventoryB
	ld e,<$cfdf
	ldh a,(<hFF8B)
	and $0f
	call @saveItemToB
	call @storeItemInInventory
	ld l,<wInventoryA
	ldh a,(<hFF8B)
	swap a
	and $0f
	ld e,<$cfde
	call @saveItemToB
	ld a,b
	cp ITEMID_BIGGORON_SWORD
	call nz,@storeItemInInventory
	jp disableActiveRing

@saveItemToB:
	ld b,(hl)
	ld (hl),a
	ret

@storeItemInInventory:
	push de
	ld d,$cf
	ld l,<wInventoryStorage
-
	ld a,(hl)
	or a
	jr z,+
	inc l
	jr -
+
	ld (hl),b
	ld a,l
	ld (de),a
	pop de
	ret


; TODO: This is possibly a function for restoring Link's items after the blaino fight, which may be
; used in the Japanese version only?
seasonsFunc_15_5cf0:
	ld a,($ccec)
	cp $03
	jr z,+
seasonsFunc_15_5cf7:
	push de
	ld a,$ff
	ld ($cbea),a
	ld h,>wc600Block
	ld de,$cfdf
	ld c,$80
	call seasonsFunc_15_5d12
	ld e,$de
	ld c,$81
	call seasonsFunc_15_5d12
	pop de
+
	jp enableActiveRing
seasonsFunc_15_5d12:
	ld a,(de)
	or a
	ret z
	ld l,a
	ld a,(hl)
	ld (hl),$00
	ld l,c
	ldi (hl),a
	cp $0c
	ret nz
	ld (hl),a
	ret


; ==============================================================================
; INTERACID_DANCE_HALL_MINIGAME
; ==============================================================================
seasonsFunc_15_5d20:
	ld a,$01
	ld ($cfd2),a
	ld a,$04
	jr +++

seasonsFunc_15_5d29:
	ld a,$ff
	ld ($cfd2),a
	ld a,$04
	jr +++
	
seasonsFunc_15_5d32:
	ld a,$05
	jr +++

; unknown
	ld a,$03
+++
	ld ($cfd4),a
	ld a,$09
	ld ($cfd1),a
	ld hl,$cfda
	inc (hl)
	ret

seasonsFunc_15_5d45:
	ld e,$54
	ld a,$80
	ld (de),a
	ld a,$fe
	inc e
	ld (de),a
	ld e,$4e
	ld a,$01
	ld (de),a
	ret


; ==============================================================================
; INTERACID_S_MISCELLANEOUS_1
; ==============================================================================
floodgateKeeper_checkStage:
	call getThisRoomFlags
	bit 7,(hl)
	ld a,$03
	jr nz,+
	ld hl,wPresentRoomFlags|<ROOM_SEASONS_081
	bit 7,(hl)
	ld a,$02
	jr nz,+
	call getThisRoomFlags
	bit 5,(hl)
	ld a,$01
	jr nz,+
	dec a
+
	ld ($cfc1),a
	ret

d4Keyhole_setState0eDisableAllSorts:
	ld a,$0e
	ld ($cc6a),a
d4KeyHolw_disableAllSorts:
	ld a,$01
	ld ($cc02),a
	ld ($cca5),a
	ld a,$ff
	ld ($cca4),a
	jp interactionSetAlwaysUpdateBit

floodgate_disableObjectsScreenTransition:
	ld a,$11
	ld (wDisableScreenTransitions),a
	ld (wDisabledObjects),a
	ret

floodgate_enableObjects:
	xor a
	ld (wDisableScreenTransitions),a
	ld (wSwitchState),a
	ret


; ==============================================================================
; INTERACID_ROSA_HIDING
; INTERACID_STRANGE_BROTHERS_HIDING
; ==============================================================================
strangeBrothersFunc_15_5d9a:
	ld h,FIRST_DYNAMIC_ITEM_INDEX
--
	ld l,Item.id
	ld a,(hl)
	sub ITEMID_BOMB
	jr nz,+
	ld l,Item.visible
	ld (hl),a
	ld l,Item.var2f
	set 5,(hl)
+
	inc h
	ld a,h
	cp LAST_DYNAMIC_ITEM_INDEX+1
	jr c,--
	ret

subrosianHiding_store02Intocc9e:
	ld a,$02
	ld ($cc9e),a
	ret

rosaHiding_hidingFinishedSetInitialRoomsFlags:
	ld hl,wPresentRoomFlags|<ROOM_SEASONS_0cb
	set 7,(hl)
	xor a
	ld ($cc9e),a
	ld ($cc9f),a
	ret

strangeBrothersFunc_15_5dc4:
	ld a,$1e
	call addToGashaMaturity
	ld hl,wNumTimesPlayedStrangeBrothersGame
	call incHlRefWithCap
	call getThisRoomFlags
	bit 5,(hl)
	jr nz,strangeBrothersFunc_15_5ddb
	ldbc TREASURE_FEATHER $02
	jr strangeBrothersFunc_15_5e00
	
strangeBrothersFunc_15_5ddb:
	ld a,(wNumTimesPlayedStrangeBrothersGame)
	cp $08
	jr z,strangeBrothersFunc_15_5dee
	call getRandomNumber
	cp $60
	jr nc,strangeBrothersFunc_15_5e13
--
	ldbc TREASURE_GASHA_SEED $02
	jr strangeBrothersFunc_15_5e00
	
strangeBrothersFunc_15_5dee:
	call seasonsFunc_15_5e20
	jr c,--
	ld c,$03
	call createRingTreasure
	call strangeBrothersFunc_15_5e0a
	ld a,GLOBALFLAG_S_14
	jp setGlobalFlag

strangeBrothersFunc_15_5e00:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),b
	inc l
	ld (hl),c
strangeBrothersFunc_15_5e0a:
	ld l,Interaction.yh
	ld (hl),$48
	inc l
	inc l
	ld (hl),$28
	ret

strangeBrothersFunc_15_5e13:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_S_MISCELLANEOUS_1
	inc l
	ld (hl),$09
	inc l
	inc (hl)
	jr strangeBrothersFunc_15_5e0a

seasonsFunc_15_5e20:
	call getRandomNumber
	and $03
	ld c,a
	ld b,$04
-
	push bc
	ld a,c
	ld bc,@table_5e4a
	call addAToBc
	ld a,(bc)
	ld hl,wRingsObtained
	call checkFlag
	jr z,+
	pop bc
	ld a,c
	inc a
	and $03
	ld c,a
	dec b
	jr nz,-
	ld b,$80
	scf
	ret
+
	ld a,(bc)
	pop bc
	ld b,a
	ret

@table_5e4a:
	.db WHIMSICAL_RING, FIST_RING, BLUE_HOLY_RING, GREEN_LUCK_RING

subrosianHiding_createDetectionHelper:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_DETECTION_HELPER
	ld l,Part.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d
	jp objectCopyPosition


; ==============================================================================
; INTERACID_STEALING_FEATHER
; ==============================================================================
stealingFeather_spawnSelfWithSubId0:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_STEALING_FEATHER
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	ld (hl),a
	ret

stealingFeather_putLinkOnGround:
	call setLinkForceStateToState08
	jp putLinkOnGround

stealingFeather_spawnStrangeBrothers:
	ld bc,$30a8
	ld e,$10
	call func_5e82
	ld bc,$34b8
	ld e,$11
func_5e82:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_S_SUBROSIAN
	inc l
	ld (hl),e
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c
	ret


; ==============================================================================
; INTERACID_S_COMPANION_SCRIPTS
; ==============================================================================
seasonsFunc_15_5e91:
	ld hl,w1Companion.speedZ
	ld (hl),$c0
	inc l
	ld (hl),$fe
	ld l,<w1Companion.var3f
	ld (hl),$0b
	ld l,<w1Companion.var03
	ld (hl),$03
	ld l,<w1Companion.oamFlags
	ld (hl),$09
	ret

seasonsFunc_15_5ea6:
	ld hl,w1Companion.var03
	ld (hl),$04
	ld l,<w1Companion.visible
	ld (hl),$c0
	ld l,<w1Companion.var3f
	ld (hl),$19
	ret

seasonsFunc_15_5eb4:
	ld a,$18
	ld (wLinkAngle),a
	ld hl,w1Link.angle
	ld (hl),a
	ld l,<w1Link.speed
	ld (hl),SPEED_140
	ld a,$1d
	ld (w1Companion.var3f),a
	ret

seasonsFunc_15_5ec7:
	ld a,DIR_DOWN
	ld (w1Link.direction),a
	ld hl,w1Companion.direction
	ld (hl),DIR_DOWN
	inc l
	ld (hl),ANGLE_DOWN
	ld l,<w1Companion.var03
	ld (hl),$06
	ld a,$03
	ld (w1Companion.var3f),a
	ret

seasonsFunc_15_5ede:
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECTID_MOOSH
	ld a,$01
	jr z,+
	xor a
+
	ld e,$7b
	ld (de),a
	ret


; ==============================================================================
; INTERACID_SUNKEN_CITY_BULLIES
; ==============================================================================
sunkenCityBullies_lookToLink:
	call objectGetAngleTowardLink
	ld e,$49
	ld (de),a
	call convertAngleDeToDirection
	ld e,$48
	ld (de),a
	jp interactionSetAnimation


; ==============================================================================
; INTERACID_TRAMPOLINE
; ==============================================================================
trampoline_bounce:
	ld a,LINK_STATE_BOUNCING_ON_TRAMPOLINE
	ld (wLinkForceState),a
	ld hl,$d00b
	call objectCopyPosition
	ld a,($d00b)
	swap a
	and $0f
	ldh (<hFF8D),a
	ld a,($d00d)
	swap a
	and $0f
	xor $0f
	ldh (<hFF8C),a
	ld a,(wActiveGroup)
	ld hl,trampoline_group4Warps
	cp $04
	jr z,+
	ld hl,trampoline_group5Warps
+
	ld a,(wActiveRoom)
	ld e,a
-
	ldi a,(hl)
	or a
	jr z,trampoline_couldntFindRoom
	cp e
	jr z,trampoline_foundRoom
	inc hl
	inc hl
	jr -
trampoline_foundRoom:
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	push hl
	ldh a,(<hFF8D)
	rst_addDoubleIndex
	ldh a,(<hFF8C)
	call checkFlag
	ld c,$01
	jr nz,++
	ld c,$00
	ld e,$42
	ld a,(de)
	or a
	jr z,++
	pop hl
	ld bc,$0016
	add hl,bc
	ldh a,(<hFF8D)
	rst_addDoubleIndex
	ldh a,(<hFF8C)
	call checkFlag
	ld c,$80
	jr z,+++
	ld c,$82
	jr +++
++
	pop hl
+++
	ld a,c
	ld ($cc6b),a
	ret
trampoline_couldntFindRoom:
	ld a,$03
	ld ($cc6b),a
	ret

trampoline_group4Warps:
	dbw $3e trampoline_group4Room3e
	dbw $3f trampoline_group4Room3f
	dbw $43 trampoline_group4Room43
	dbw $b4 trampoline_group4Roomb4
	dbw $c1 trampoline_group4Roomc1
	dbw $c2 trampoline_group4Roomc2
	dbw $d3 trampoline_group4Roomd3
	.db $00

trampoline_group5Warps:
	dbw $37 trampoline_group5Room37
	dbw $38 trampoline_group5Room38
	dbw $3a trampoline_group5Room3a
	dbw $45 trampoline_group5Room45
	dbw $49 trampoline_group5Room49
	dbw $4d trampoline_group5Room4d
	.db $00

trampoline_group4Room3e:
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111101111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111110111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111

trampoline_group4Room3f:
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111110111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111

trampoline_group4Room43:
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1110000000001111
	.dw %1110111011101111
	.dw %1110111011101111
	.dw %1110000000001111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111

trampoline_group4Roomb4:
	.dw %1111111111111111
	.dw %1001111111111111
	.dw %1011111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111

trampoline_group4Roomc1:
	.dw %1111111111111111
	.dw %1111111111100011
	.dw %1111111111100011
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111

trampoline_group4Roomc2:
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1001111111001111
	.dw %1001111111001111
	.dw %1111111111111111

trampoline_group4Roomd3:
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111110001100111
	.dw %1111111111111111

trampoline_group5Room37:
	.dw %1111111111111111
	.dw %1111111111110011
	.dw %1111111111110011
	.dw %1111111111110011
	.dw %1111111111110011
	.dw %1111111111110011
	.dw %1111111111111111
	.dw %1111111111110011
	.dw %1111111111110011
	.dw %1111111111110011
	.dw %1111111111111111

trampoline_group5Room38:
	.dw %1111111111111111
	.dw %1111111100011111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1000011111111111
	.dw %1000011111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111

	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1000011111111111
	.dw %1000011111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111

trampoline_group5Room3a:
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111000000011111
	.dw %1111000000011111
	.dw %1111000000011111
	.dw %1111000000011111
	.dw %1111000000011111
	.dw %1111000000011111
	.dw %1111000000011111
	.dw %1111111111111111
	.dw %1111111111111111

	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111000000011111
	.dw %1111000000011111
	.dw %1111000000011111
	.dw %1111000000011111
	.dw %1111000000011111
	.dw %1111000000011111
	.dw %1111000000011111
	.dw %1111111111111111
	.dw %1111111111111111

trampoline_group5Room45:
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111011111111111
	.dw %1111111111111111
	.dw %1000000111111111
	.dw %1001000111111111
	.dw %1000000111111111
	.dw %1000000111111111
	.dw %1000000111111111
	.dw %1000000111111111
	.dw %1111111111111111

trampoline_group5Room49:
	.dw %1111111111111111
	.dw %1000111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111

trampoline_group5Room4d:
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111010001111111
	.dw %1111110001111111
	.dw %1111110001111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111
	.dw %1111111111111111


; ==============================================================================
; INTERACID_MAKU_TREE
; ==============================================================================
makuTree_setMakuMapText:
	ld hl,wMakuMapTextPresent
	ld (hl),a
	ret

makuTree_showTextBasedOnVar:
	ld c,a
	jr +

makuTree_showTextAndSetMapTextBasedOnStage:
	call makuTree_setMapTextBasedOnStage
	jr +

makuTree_showTextAndSetMapText:
	call makuTree_setMapText
	jr +

makuTree_showText:
	call makuTree_add1bToLowTextIfLinked
+
	ld b,>TX_1700
	jp showText

makuTree_setMapTextBasedOnStage:
	ld a,(ws_cc39)
	ld hl,makuTreeTextIndices
	rst_addAToHl
	ld a,(hl)
makuTree_setMapText:
	call makuTree_add1bToLowTextIfLinked
	ld hl,wMakuMapTextPresent
	ld (hl),c
	ret

makuTree_add1bToLowTextIfLinked:
	ld c,a
	call checkIsLinkedGame
	ret z
	ld a,c
	add $1b
	ld c,a
	ret

makuTreeTextIndices:
	.db $03 $05 $08 $0a
	.db $0c $11 $13 $15
	.db $17 $06 $0e $11
	.db $18

makuTree_storeIntoVar37SpawnBubbleIf0:
	cp $00
	jr nz,+
	call makuTree_spawnBubble
	ld a,$00
+
	ld e,Interaction.var37
	ld (de),a
	jp interactionSetAnimation

makuTree_dropGnarledKey:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),TREASURE_GNARLED_KEY
	inc l
	ld (hl),$00
	ld l,Interaction.yh
	ld (hl),$60
	ld a,(w1Link.xh)
	ld b,$50
	cp $64
	jr nc,+
	cp $3c
	jr c,+
	ld b,$40
	cp $50
	jr nc,+
	ld b,$60
+
	ld l,Interaction.xh
	ld (hl),b
	ld a,b
	ld (ws_c6e0),a
	ret

makuTree_spawnBubble:
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMYID_MAKU_TREE_BUBBLE
	inc l
	ld e,Interaction.subid
	ld a,(de)
	ld (hl),a
	ld l,Enemy.relatedObj2
	ld a,$40
	ldi (hl),a
	ld (hl),d
	ld e,Interaction.relatedObj1
	ld a,$80
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld hl,$cfc0
	res 7,(hl)
	ret

makuTree_dropMakuSeed:
	ldbc INTERACID_S_MAKU_SEED $01
	jp objectCreateInteraction

makuTree_OnoxTauntingAfterMakuSeedGet:
	ld a,CUTSCENE_S_ONOX_TAUNTING
	ld (wCutsceneTrigger),a
	ld a,GLOBALFLAG_GOT_MAKU_SEED
	jp setGlobalFlag

makuTree_disableEverythingIfUnlinked:
	call checkIsLinkedGame
	ret nz
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ret

seasonsFunc_15_619a:
	ld a,($cc66)
	or a
	ret nz
	call setLinkForceStateToState08
	ld hl,w1Link.direction
	ld (hl),DIR_UP
	ld l,<w1Link.yh
	ld (hl),$68
	ld l,<w1Link.xh
	ld (hl),$50
	ld l,<w1Link.zh
	ld (hl),$00
	ret


; ==============================================================================
; INTERACID_JEWEL_HELPER
; ==============================================================================
jewelHelper_createPuff:
	ld bc,table_61ca
	call addDoubleIndexToBc
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	ret
table_61ca:
	.db $26 $26
	.db $26 $30
	.db $26 $3a
	.db $30 $26
	.db $30 $30
	.db $30 $3a
	.db $3a $26
	.db $3a $30
	.db $3a $3a

jewelHelper_createMoldorm:
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMYID_MOLDORM
	ld l,Enemy.yh
	ld (hl),$30
	ld l,Enemy.xh
	ld (hl),$30
	ret


; ==============================================================================
; INTERACID_KING_MOBLIN
; ==============================================================================
kingMoblin_func_61eb:
	ld a,$01
	call interactionSetAnimation
	ld h,d
	ld l,Interaction.yh
	ld (hl),$30
	inc l
	inc l
	ld (hl),$78
	ret


; ==============================================================================
; INTERACID_S_MOBLIN
; ==============================================================================
moblin_spawnMaskedMoblin:
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMYID_MASKED_MOBLIN
	inc l
	ld (hl),$01
	jp objectCopyPosition

moblin_spawnSwordMaskedMoblin:
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMYID_SWORD_MASKED_MOBLIN
	jp objectCopyPosition


; ==============================================================================
; INTERACID_S_OLD_MAN_WITH_RUPEES
; ==============================================================================
oldMan_takeRupees:
	ld hl,wNumRupees
	ldi a,(hl)
	or (hl)
	ld e,$7f
	ld (de),a
	ret z
	ld a,$01
	ld (de),a
	ld e,$42
	ld a,(de)
	ld hl,oldMan_rupeeValues
	rst_addAToHl
	ld a,(hl)
	jp removeRupeeValue

oldMan_giveRupees:
	ld e,$42
	ld a,(de)
	ld hl,oldMan_rupeeValues
	rst_addAToHl
	ld c,(hl)
	ld a,$28
	jp giveTreasure

oldMan_rupeeValues:
	.db RUPEEVAL_300
	.db RUPEEVAL_200
	.db RUPEEVAL_100
	.db RUPEEVAL_300
	.db RUPEEVAL_100
	.db RUPEEVAL_200
	.db RUPEEVAL_050
	.db RUPEEVAL_100


; ==============================================================================
; INTERACID_IMPA
; ==============================================================================
impa_checkIf4thEssenceGotten:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	and $08
	ld b,$00
	jr nz,@got4thEssence
	inc b
@got4thEssence:
	ld hl,$cfc0
	ld (hl),b
	ret


; ==============================================================================
; INTERACID_SAMASA_DESERT_GATE
; ==============================================================================
samasaDesertGate_createNext2Puffs:
	call samasaDesertGate_createNextPuff

samasaDesertGate_createNextPuff:
	ld h,d
	ld l,Interaction.var3e
	ld a,(hl)
	inc (hl)
	ld bc,samasaDesertGate_puffLocations
	call addDoubleIndexToBc
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	ret

samasaDesertGate_puffLocations:
	; yh - xh of puffs
	.db $1e $2e
	.db $1e $42
	.db $26 $38
	.db $16 $2e
	.db $16 $42
	.db $0e $38
	.db $1a $38

	.db $1e $3e
	.db $1e $52
	.db $26 $48
	.db $16 $3e
	.db $16 $52
	.db $0e $48
	.db $1a $48

	.db $1e $4e
	.db $1e $62
	.db $26 $58
	.db $16 $4e
	.db $16 $62
	.db $0e $58
	.db $1a $58

	.db $1e $5e
	.db $1e $72
	.db $26 $68
	.db $16 $5e
	.db $16 $72
	.db $0e $68
	.db $1a $68


; ==============================================================================
; INTERACID_SUBROSIAN_SMITHY
; ==============================================================================
subrosianSmith_takeHardOre:
	ld a,TREASURE_HARD_ORE
	call loseTreasure

subrosianSmith_giveUpgradedShield:
	ld a,TREASURE_SHIELD
	call checkTreasureObtained
	jr c,@haveShield
	xor a
@haveShield:
	cp $03
	jr c,+
	ld a,$02
+
	ld c,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),TREASURE_SHIELD
	inc l
	ld (hl),c
	push de
	ld de,$d00b
	call objectCopyPosition_rawAddress
	pop de
	ret


; ==============================================================================
; INTERACID_S_DIN
; ==============================================================================
din_animateAndLookAtLink:
	call objectGetAngleTowardLink
	call convertAngleToDirection
	jp interactionSetAnimation

din_createExclamationMark:
	ld bc,$f300
	jp objectCreateExclamationMark


; interactionCodeaa
seasonsFunc_15_62d9:
	ld b,$f8
	ld c,$f0
	ld a,$40
	jp objectCreateExclamationMark


; ==============================================================================
; INTERACID_MOBLIN_KEEP_SCENES
; ==============================================================================
moblinKeepScene_warpOutOfMoblinKeep:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call setGlobalFlag
	ld a,GLOBALFLAG_DONT_DISPLAY_SEASON_INFO
	call setGlobalFlag
	ld hl,@warpDestVariables
	call setWarpDestVariables
	ld a,$bc
	jp playSound
@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_05b $00 $14 $83

moblinKeepScene_faceLinkUp:
	ld a,DIR_UP
	ld (w1Link.direction),a
	jp setLinkForceStateToState08

moblinKeepScene_putLinkOnGround:
	call setLinkForceStateToState08
	jp putLinkOnGround


; ==============================================================================
; INTERACID_SHIP_PIRATIAN
; INTERACID_SHIP_PIRATIAN_CAPTAIN
; ==============================================================================
shipPiratian_incCbb3:
	ld hl,$cbb3
	inc (hl)
	ret

shipPiratian_setRandomAnimation:
	call getRandomNumber
	and $03
	jp interactionSetAnimation

shipPiratian_linkBoarding:
	call setLinkForceStateToState08
	ld hl,w1Link.direction
	ld (hl),DIR_RIGHT
	ld l,<w1Link.visible
	set 7,(hl)
	ret

shipPiratian_setAnimationIfLinkNear:
	ld c,$10
	call objectCheckLinkWithinDistance
	rrca
	and $03
	jp interactionSetAnimation


; ==============================================================================
; INTERACID_LINKED_CUTSCENE
; ==============================================================================
seasonsFunc_15_632f:
	call darkenRoom
	jr ++

seasonsFunc_15_6334:
	call brightenRoom
++
	xor a
	ld ($c4b2),a
	ld ($c4b4),a
	ld a,$7e
	ld ($c4b1),a
	ld ($c4b3),a
	ret

seasonsFunc_15_6347:
	ld bc,$5838
	jr ++

seasonsFunc_15_634c:
	ld bc,$1850
++
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_LIGHTNING
	inc l
	inc (hl)
	ld l,Part.yh
	ld (hl),b
	ld l,Part.xh
	ld (hl),c
	ret

seasonsFunc_15_635e:
	ld bc,seasonsTable_15_6372
	jr ++

seasonsFunc_15_6363:
	ld bc,seasonsTable_15_6375
++
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_bf
	inc l
	ld a,(bc)
	inc bc
	ld (hl),a
	jr seasonsFunc_15_6396

seasonsTable_15_6372:
	.db $00 $60 $38

seasonsTable_15_6375:
	.db $01 $20 $50

seasonsFunc_15_6378:
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	ld a,INTERACID_b4
	ld (wInteractionIDToLoadExtraGfx),a
	ret

seasonsFunc_15_6383:
	ld bc,seasonsTable_15_63a0
	call seasonsFunc_15_638c
	ld bc,seasonsTable_15_63a3
seasonsFunc_15_638c:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_b4
	inc l
	ld a,(bc)
	inc bc
	ld (hl),a
seasonsFunc_15_6396:
	ld l,Interaction.yh
	ld a,(bc)
	inc bc
	ld (hl),a
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	ret

seasonsTable_15_63a0:
	.db $00 $28 $50

seasonsTable_15_63a3:
	.db $01 $28 $50

seasonsFunc_15_63a6:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_MAKU_CUTSCENES
	inc l
	ld (hl),$09
	ld l,Interaction.yh
	ld (hl),$40
	ld l,Interaction.xh
	ld (hl),$50
	ret


; ==============================================================================
; Generic
; ==============================================================================
faceOppositeDirectionAsLink:
	ld hl,w1Link.direction
	ld a,(hl)
	xor $02
	jp interactionSetAnimation

linkedScript_giveRing:
	ld b,a
	ld c,$00
	jp giveRingToLink

playLinkCutscene2:
	ld a,SPECIALOBJECTID_LINK_CUTSCENE
	call setLinkIDOverride
	ld l,<w1Link.subid
	ld (hl),$08
	ret

forceLinkState8AndSetDirection:
	ld hl,w1Link.direction
	ld (hl),a
	jp setLinkForceStateToState08


; ==============================================================================
; INTERACID_ZELDA_KIDNAPPED_ROOM
; ==============================================================================
zeldaKidnappedRoom_loadImpa:
	ld bc,zeldaKidnapped_impaData
	jr zeldaKidnapped_spawnInteraction
	
zeldaKidnappedRoom_loadZeldaAndMoblins:
	ld bc,zeldaKidnapped_kingMoblinData
	call zeldaKidnapped_spawnInteraction
	
	ld bc,zeldaKidnapped_zeldaData
	call zeldaKidnapped_spawnInteraction
	
	ld bc,zeldaKidnapped_moblinData
	call zeldaKidnapped_spawnInteraction
	call zeldaKidnapped_spawnInteraction
	call zeldaKidnapped_spawnInteraction
	
zeldaKidnapped_spawnInteraction:
	call getFreeInteractionSlot
	ret nz
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	inc bc
	ret

; id - subid - var03 - yh - xh
zeldaKidnapped_kingMoblinData:
	.db INTERACID_KING_MOBLIN, $05 $00 $14 $50

zeldaKidnapped_zeldaData:
	.db INTERACID_S_ZELDA,     $06 $00 $48 $50

zeldaKidnapped_impaData:
	.db INTERACID_ba,          $03 $00 $88 $40

zeldaKidnapped_moblinData:
	.db INTERACID_S_MOBLIN,    $06 $00 $48 $38
	.db INTERACID_S_MOBLIN,    $06 $01 $48 $68
	.db INTERACID_S_MOBLIN,    $05 $02 $28 $30
	.db INTERACID_S_MOBLIN,    $05 $03 $28 $70


linkedFunc_15_6430:
	ld a,(wcce2)
	ld hl,$cbaa
	ldi (hl),a
	ld (hl),$00
	ld a,(wcce3)
	ld hl,wTextNumberSubstitution
	ldi (hl),a
	ld (hl),$00
	ret


; ==============================================================================
; INTERACID_TROY
; ==============================================================================
seasonsFunc_15_6443:
	ld hl,$ccf7
	xor a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld e,$78
	ld (de),a
	ld e,$46
	ld a,$01
	ld (de),a
	jp clearAllItemsAndPutLinkOnGround

seasonsFunc_15_6455:
	ld a,$01
	ld e,$7b
	ld (de),a
	jp objectSetInvisible

seasonsFunc_15_645d:
	xor a
	ld e,$7b
	ld (de),a
	jp objectSetVisible

seasonsFunc_15_6464:
	push de
	call clearEnemies
	call clearItems
	call clearParts
	pop de
	xor a
	ld (wNumEnemies),a
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	call setLinkForceStateToState08
	ld hl,w1Link.direction
	ld (hl),DIR_UP
	ld l,<w1Link.yh
	ld (hl),$88
	ld l,<w1Link.xh
	ld (hl),$78
	ld l,<w1Link.zh
	ld (hl),$00
	ret

createSwirlAtLink:
	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	ld a,$6e
	jp createEnergySwirlGoingIn

troyMinigame_createSparkle:
	ldbc INTERACID_SPARKLE $00
	jp objectCreateInteraction


; ==============================================================================
; INTERACID_S_LINKED_GAME_GHINI
; ==============================================================================
seasonsFunc_15_64a0:
	ld h,d
	ld l,Interaction.var3c
	ld a,(wSelectedTextOption)
	xor $01
	cp (hl)
	ld l,Interaction.var3f
	jr nz,+
	ld (hl),$00
	ret
+
	ld (hl),$01
	ret

linkedGhini_clearAllAndSetInvisible:
	call clearAllItemsAndPutLinkOnGround
	jp objectSetInvisible

linkedGhini_setVisible:
	jp objectSetVisible

linkedGhini_forceLinksPositionAndState:
	call setLinkForceStateToState08
	ld hl,w1Link.direction
	ld (hl),DIR_UP
	ld l,<w1Link.yh
	ld (hl),$5c
	ld l,<w1Link.xh
	ld (hl),$50
	ld l,<w1Link.zh
	ld (hl),$00
	ret


; ==============================================================================
; INTERACID_GOLDEN_CAVE_SUBROSIAN
; ==============================================================================
goldenCaveSubrosian_emptyLinksItemsAndSetPosition:
	call clearAllParentItems
	call dropLinkHeldItem
	call clearItems
	call setLinkForceStateToState08
	ld hl,w1Link.direction
	ld (hl),DIR_UP
	ret

goldenCaveSubrosian_faceLinkUp:
	ld hl,w1Link.direction
	ld (hl),DIR_UP
	ret

seasonsFunc_15_64e9:
	ld h,d
	ld l,Interaction.var39
	ld a,(hl)
	or a
	ret nz
	ld l,Interaction.var38
	ld a,(hl)
	ld b,$00
	cp $03
	jr nc,+
	ld b,$01
+
	ld l,Interaction.var39
	ld (hl),b
	ret

goldenCaveSubrosian_refreshRoom:
	ld b,a
	ld hl,wWarpDestGroup
	ld a,$84
	ldi (hl),a
	ld a,$f0
	ldi (hl),a ; [wWarpDestRoom]
	ld a,$0f
	ldi (hl),a ; [wWarpDestTransition]
	ld a,b
	ldi (hl),a ; [wWarpDestPos]
	ld a,$00
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a
	ret

seasonsFunc_15_6518:
	ld h,d
	ld l,Interaction.var33
	ld (hl),$4c
	ld b,$25
	call getThisRoomFlags
	and $03
	dec a
	jr z,+
	ld b,$27
+
	ld a,b
	ld e,Interaction.var32
	ld (de),a
	ret

seasonsFunc_15_652e:
	xor a
	ld ($cca4),a
	ld ($cc02),a
	call getThisRoomFlags
	and $c0
	ld (hl),a
	ret

seasonsFunc_15_653c:
	ld b,a
	call getThisRoomFlags
	and $c0
	or b
	ld (hl),a
	ret

seasonsFunc_15_6545:
	call getThisRoomFlags
	and $03
	ld e,$7c
	ld (de),a
	ret


; ==============================================================================
; INTERACID_S_MASTER_DIVER
; ==============================================================================
seasonsFunc_15_654e:
	ld hl,wcce1
	xor a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	jp clearAllItemsAndPutLinkOnGround

seasonsFunc_15_6558:
	xor a
	ld ($cfd1),a
	ret

masterDiver_forceLinkState:
	call setLinkForceStateToState08
	ld hl,w1Link.direction
	ld (hl),$00
	ld l,<w1Link.yh
	ld (hl),$60
	ld l,<w1Link.xh
	ld (hl),$50
	ld l,<w1Link.zh
	ld (hl),$00
	ret

masterDiver_checkIfDoneIn30Seconds:
	ld hl,$ccf9
	ldd a,(hl)
	or a
	jr nz,+
	ld a,(hl)
	cp $31
	jr nc,+
	ld a,GLOBALFLAG_SWIMMING_CHALLENGE_SUCCEEDED
	jp setGlobalFlag
+
	ld a,GLOBALFLAG_SWIMMING_CHALLENGE_SUCCEEDED
	jp unsetGlobalFlag

masterDiver_retryChallenge:
	ld hl,@warpDestVariables
	call setWarpDestVariables
	ld a,SND_TELEPORT
	jp playSound
@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_7e8 $00 $06 $83

masterDiver_exitChallenge:
	ld hl,@warpDestVariables
	call setWarpDestVariables
	ld a,SND_TELEPORT
	jp playSound
@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_3b6 $00 $45 $83


; ==============================================================================
; INTERACID_DEKU_SCRUB
; ==============================================================================
dekuScrub_upgradeSatchel:
	ld e,TREASURE_EMBER_SEEDS
-
	ld a,e
	call checkTreasureObtained
	ret nc
	inc e
	ld a,e
	cp TREASURE_MYSTERY_SEEDS+1
	jr c,-
	ld a,(wSeedSatchelLevel)
	ld hl,table_65cf-1
	rst_addAToHl
	ld b,(hl)
	ld hl,wNumEmberSeeds
-
	ld a,b
	cp (hl)
	ret nz
	inc l
	ld a,l
	cp <(wNumMysterySeeds+1)
	jr c,-
	ld h,d
	ld l,Interaction.var38
	ld (hl),$01
	ret
table_65cf:
	.db $20 $50 $99
