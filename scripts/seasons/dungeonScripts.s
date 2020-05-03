dungeonScript_minibossDeath:
	stopifroomflag80set
	checknoenemies
	orroomflag $80
	wait 20
	spawninteraction INTERACID_MINIBOSS_PORTAL $00, $00, $00
dungeonScriptEnableLinkAndMenu:
	writememory wDisableLinkCollisionsAndMenu, $00
dungeonScript_end:
	scriptend


dungeonScript_checkActiveTriggersEq01:
	stopifitemflagset
	checkmemoryeq wActiveTriggers, $01


spawnChestAfterPuff:
	playsound SND_SOLVEPUZZLE
	createpuff
	wait 15
	settilehere TILEINDEX_CHEST
	scriptend


dungeonScript_bossDeath:
	jumpifroomflagset $80, _spawnHeartContainerCenterOfRoom
	checknoenemies
	orroomflag $80
_spawnHeartContainerCenterOfRoom:
	stopifitemflagset
	setcoords $58, $78
	spawnitem TREASURE_HEART_CONTAINER $00
	writememory wDisableLinkCollisionsAndMenu, $00
	scriptend


snakesRemainsScript_timerForChestDisappearing:
	stopifitemflagset
	wait 240
	wait 240
	wait 240
	wait 240
	wait 240
	wait 240
	wait 240
	stopifitemflagset
	playsound SND_POOF
	createpuff
	settilehere TILEINDEX_STANDARD_FLOOR
	scriptend


snakesRemainsScript_bossDeath:
	jumpifroomflagset $80, _snakesRemains_coordsForHeartContainer
	checknoenemies
	orroomflag $80
_snakesRemains_coordsForHeartContainer:
	stopifitemflagset
	setcoords $88, $78
_spawnHeartContainerAtCustomPosition:
	spawnitem TREASURE_HEART_CONTAINER $00
	writememory wDisableLinkCollisionsAndMenu, $00
	scriptend


poisonMothsLairScript_hallwayTrapRoom:
	asm15 scriptHlp.D3spawnPitSpreader
	checkmemoryeq wActiveTriggers, $01
	asm15 scriptHlp.D3hallToMiniboss_buttonStepped
	scriptend


poisonMothsLairScript_checkStatuePuzzle:
	asm15 scriptHlp.D3StatuePuzzleCheck
	wait 1
	jump2byte poisonMothsLairScript_checkStatuePuzzle


poisonMothsLairScript_minibossDeath:
	stopifroomflag80set
	checknoenemies
	orroomflag $80
	wait 20
	createpuff
	settilehere TILEINDEX_INDOOR_UPSTAIRCASE
	spawninteraction INTERACID_MINIBOSS_PORTAL $00, $00, $00
	jump2byte dungeonScriptEnableLinkAndMenu


poisonMothsLairScript_bossDeath:
	jumpifroomflagset $80, _poisonMothsLair_coordsForHeartContainer
	checknoenemies
	wait 60
	createpuff
	settilehere $45
_poisonMothsLair_coordsForHeartContainer:
	stopifitemflagset
	setcoords $20, $78
	jump2byte _spawnHeartContainerAtCustomPosition


poisonMothsLairScript_openEssenceDoorIfBossBeat:
	asm15 scriptHlp.D3openEssenceDoorIfBossBeat_body
	scriptend


dancingDragonScript_spawnStairsToB1:
	stopifroomflag80set
	checknoenemies
	orroomflag $80
	spawninteraction INTERACID_PUFF $00, $38, $98
	wait 8
	settilehere TILEINDEX_SOUTH_STAIRS
	playsound SND_SOLVEPUZZLE
	scriptend


dancingDragonScript_torchesHallway:
	jumpifroomflagset $80, @spawnChest
	checkmemoryeq wNumTorchesLit, $03
	orroomflag $80
	wait 8
@spawnChest:
	stopifitemflagset
	jump2byte spawnChestAfterPuff


dancingDragonScript_spawnBossKey:
	stopifitemflagset
	spawnitem TREASURE_BOSS_KEY $02
	scriptend


dancingDragonScript_pushingPotsRoom:
	stopifitemflagset
	checkmemoryeq wActiveTriggers, $ff
	spawnitem TREASURE_SMALL_KEY $01
	scriptend


dancingDragonScript_bridgeInB2:
	stopifroomflag80set
	checkmemoryeq wNumTorchesLit, $02
	asm15 scriptHlp.D4spawnBridgeB2
	scriptend


unicornsCaveScript_spawnBossKey:
	stopifitemflagset
	spawnitem TREASURE_BOSS_KEY $00
	scriptend


unicornsCaveScript_dropMagnetBallAfterDarknutKill:
	stopifroomflag80set
	wait 30
	checknoenemies
	orroomflag $80
	scriptend


dungeonScript_spawnKeyOnMagnetBallToButton:
	stopifitemflagset
	checkmemoryeq wActiveTriggers, $01
	spawnitem TREASURE_SMALL_KEY $01
	scriptend


ancientRuinsScript_spawnStaircaseUp1FTopLeftRoom:
	stopifroomflag80set
	checkflagset $00, wToggleBlocksState
	setangle <ROOM_SEASONS_5bc
_createWallUpStaircaseAndSetOtherRoomFlag:
	; angle is the low index of the other room
	asm15 scriptHlp.D6setFlagBit7InRoomWithLowIndexInAngle
	playsound SND_SOLVEPUZZLE
	orroomflag $80
	createpuff
	wait 8
	settilehere TILEINDEX_INDOOR_WALL_UPSTAIRCASE
	scriptend


ancientRuinsScript_spawnStaircaseUp1FTopMiddleRoom:
	stopifroomflag80set
	checkmemoryeq wActiveTriggers, $01
	setangle <ROOM_SEASONS_5be
	jump2byte _createWallUpStaircaseAndSetOtherRoomFlag


; ???
script4c50:
	setangle $02
_loopCheckToggleBlocks:
	asm15 scriptHlp.toggleBlocksInAngleBitsHit
	wait 8
	jump2byte _loopCheckToggleBlocks


ancientRuinsScript_5TorchesMovingPlatformsRoom:
	stopifroomflag80set
	checkmemoryeq wNumTorchesLit, $05
	setcounter1 $2d
	setangle <ROOM_SEASONS_5c4
	jump2byte _createWallUpStaircaseAndSetOtherRoomFlag


ancientRuinsScript_roomWithJustRopesSpawningButton:
	checkmemoryeq wActiveTriggers, $01
	asm15 scriptHlp.D6RandomButtonSpawnRopes
	scriptend


ancientRuinsScript_UShapePitToMagicBoomerangOrb:
	setangle $04
	jump2byte _loopCheckToggleBlocks


ancientRuinsScript_randomButtonRoom:
	asm15 scriptHlp.D6getRandomButtonResult
	jumptable_memoryaddress $cfc1
	.dw ancientRuinsScript_randomButtonRoom
	.dw @success
	.dw @failed
@success:
	playsound SND_SOLVEPUZZLE
	createpuff
	wait 30
	settilehere TILEINDEX_INDOOR_UPSTAIRCASE
	asm15 scriptHlp.D6setFlagBit7InFirst4FRoom
	scriptend
@failed:
	wait 60
	playsound SND_ERROR
	wait 60
	asm15 scriptHlp.D6RandomButtonSpawnRopes
	wait 60
	checknoenemies
	jump2byte ancientRuinsScript_randomButtonRoom


ancientRuinsScript_4F3OrbsRoom:
	setangle $38
	jump2byte _loopCheckToggleBlocks


ancientRuinsScript_spawnStairsLeadingToBoss:
	stopifroomflag80set
	checkflagset $06, wToggleBlocksState
	asm15 scriptHlp.D6setFlagBit7InLast4FRoom
	orroomflag $80
	playsound SND_SOLVEPUZZLE
	createpuff
	wait 30
	settilehere TILEINDEX_INDOOR_DOWNSTAIRCASE
	scriptend


ancientRuinsScript_spawnHeartContainerAndStairsUp:
	jumpifroomflagset $80, _spawnHeartContainerCenterOfRoom
	checknoenemies
	orroomflag $80
	setcoords $08, $78
	createpuff
	wait 30
	settilehere TILEINDEX_INDOOR_WALL_UPSTAIRCASE
	jump2byte _spawnHeartContainerCenterOfRoom


ancientRuinsScript_1FTopRightTrapButtonRoom:
	checkmemoryeq wActiveTriggers, $01
	asm15 scriptHlp.D6spawnFloorDestroyerAndEscapeBridge
	stopifroomflag80set
	orroomflag $80
	scriptend


ancientRuinsScript_crystalTrapRoom:
	stopifitemflagset
	spawnitem TREASURE_RUPEES $0a
@waitUntilRupeeGotten:
	jumpifroomflagset $20, @rupeeGotten
	wait 8
	jump2byte @waitUntilRupeeGotten
@rupeeGotten:
	loadscript script_14_4801


ancientRuinsScript_spawnChestAfterCrystalTrapRoom:
	asm15 scriptHlp.D6spawnChestAfterCrystalTrapRoom_body
	scriptend


explorersCryptScript_dropKeyDownAFloor:
	stopifroomflag40set
	checkmemoryeq wActiveTriggers, $01
	asm15 scriptHlp.D7dropKeyDownAFloor
	scriptend


explorersCryptScript_keyDroppedFromAbove:
	stopifitemflagset
	jumpifroomflagset $80, @keyDroppedFromAbove
	scriptend
@keyDroppedFromAbove:
	spawnitem TREASURE_SMALL_KEY $01
	scriptend


explorersCryptScript_4OrbTrampoline:
	setangle $01
explorersCryptScript_roomLeftOfRandomArmosRoom:
	jumpifroomflagset $40, _D7createTrampoline
	checkmemoryeq wActiveTriggers, $01
	jump2byte _D7buttonPressed
explorersCryptScript_magunesuTrampoline:
	asm15 interactionSetAlwaysUpdateBit
	jumpifroomflagset $40, _D7createTrampoline
	checknoenemies
_D7buttonPressed:
	orroomflag $40
	playsound SND_SOLVEPUZZLE
_D7createTrampoline:
	wait 8
	createpuff
	wait 15
	asm15 scriptHlp.createD7Trampoline
	scriptend


; ???
script4d05:
	stopifitemflagset
	jumpifroomflagset $40, spawnChestAfterPuff
	checkmemoryeq wActiveTriggers, $01
	orroomflag $40
	jump2byte spawnChestAfterPuff


explorersCryptScript_randomlyPlaceNonEnemyArmos:
	asm15 scriptHlp.D7randomlyPlaceNonEnemyArmos_body
	scriptend


dungeonScript_checkIfMagnetBallOnButton:
	stopifitemflagset
	jumptable_memoryaddress wActiveTriggers
	.dw @unpressed
	.dw @pressed
@unpressed:
	asm15 scriptHlp.D7MagnetBallRoom_removeChest
	jump2byte dungeonScript_checkIfMagnetBallOnButton
@pressed:
	asm15 scriptHlp.D7MagnetBallRoom_addChest
	jump2byte dungeonScript_checkIfMagnetBallOnButton


explorersCryptScript_1stPoeSisterRoom:
	loadscript explorersCrypt_firstPoeSister


explorersCryptScript_2ndPoeSisterRoom:
	loadscript explorersCrypt_secondPoeSister


explorersCryptScript_4FiresRoom_1:
	stopifroomflag40set
	asm15 scriptHlp.checkFirstPoeBeaten
	jumptable_memoryaddress $cfc1
	.dw @notBeaten
	.dw poeBeaten
@notBeaten:
	loadscript explorersCrypt_firesGoingOut_1
poeBeaten:
	playsound SND_SOLVEPUZZLE
	orroomflag $40
	scriptend


explorersCryptScript_4FiresRoom_2:
	stopifroomflag40set
	asm15 scriptHlp.checkSecondPoeBeaten
	jumptable_memoryaddress $cfc1
	.dw @notBeaten
	.dw poeBeaten
@notBeaten:
	loadscript explorersCrypt_firesGoingOut_2


explorersCryptScript_darknutBridge:
	stopifroomflag80set
	checknoenemies
	orroomflag $80
	asm15 scriptHlp.D7spawnDarknutBridge
	scriptend


swordAndShieldMazeScript_verticalBridgeUnlockedByOrb:
	stopifroomflag80set
	checkmemoryeq wToggleBlocksState, $01
	asm15 scriptHlp.D8VerticalBridgeUnlockedByOrb
	scriptend


swordAndShieldMazeScript_verticalBridgeInLava:
	stopifroomflag80set
	checkmemoryeq wActiveTriggers, $01
	asm15 scriptHlp.D8VerticalBridgeInLava
	scriptend


swordAndShieldMazeScript_armosBlockingStairs:
	stopifroomflag80set
	writeobjectbyte Interaction.direction, $96
@checkIfWillMove:
	asm15 scriptHlp.D8armosCheckIfWillMove
	jumptable_objectbyte $49
	.dw @checkIfWillMove
	.dw stubScript


swordAndShieldMazeScript_7torchesAfterMiniboss:
	asm15 scriptHlp.D8createFiresGoingOut, $a0
	stopifroomflag80set
	checkmemoryeq wNumTorchesLit, $07
_puzzelSolvedSpawnUpStaircase:
	orroomflag $80
	createpuff
	wait 30
	settilehere TILEINDEX_INDOOR_UPSTAIRCASE
	playsound SND_SOLVEPUZZLE
	scriptend


swordAndShieldMazeScript_spawnFireKeeseAtLavaHoles:
	stopifroomflag40set
	asm15 scriptHlp.D8setSpawnAtLavaHole
@loop:
	wait 240
	asm15 scriptHlp.D8SpawnLimitedFireKeese
	jump2byte @loop


swordAndShieldMazeScript_pushableIceBlocks:
	stopifroomflag80set
@waitUntilIceBlocksInPlace:
	wait 8
	asm15 scriptHlp.D8checkAllIceBlocksInPlace
	jumptable_memoryaddress $cfc1
	.dw @waitUntilIceBlocksInPlace
	.dw @success
@success:
	orroomflag $80
	playsound SND_SOLVEPUZZLE
	createpuff
	wait 20
	settilehere TILEINDEX_INDOOR_DOWNSTAIRCASE
	scriptend


swordAndShieldMazeScript_horizontalBridgeByMoldorms:
	stopifroomflag80set
	checkmemoryeq wActiveTriggers, $01
	asm15 scriptHlp.D8HorizontalBridgeByMoldorms
	scriptend


swordAndShieldMazeScript_tripleEyesByMiniboss:
	stopifroomflag80set
	checkmemoryeq wActiveTriggers, $07
	jump2byte _puzzelSolvedSpawnUpStaircase


swordAndShieldMazeScript_tripleEyesNearStart:
	stopifitemflagset
	checkmemoryeq wActiveTriggers, $07
	jump2byte spawnChestAfterPuff


onoxsCastleScript_setFlagOnAllEnemiesDefeated:
	stopifroomflag40set
	checknoenemies
	orroomflag $40
	playsound SND_SOLVEPUZZLE
	scriptend


onoxsCastleScript_resetRoomFlagsOnDungeonStart:
	asm15 scriptHlp.D9forceRoomClearsOnDungeonEntry
	scriptend


herosCaveScript_spawnChestOnTorchLit:
	stopifitemflagset
	checkmemoryeq wNumTorchesLit, $01
	jump2byte spawnChestAfterPuff


herosCaveScript_spawnChestOn2TorchesLit:
	stopifitemflagset
	checkmemoryeq wNumTorchesLit, $02
	jump2byte spawnChestAfterPuff


herosCaveScript_check6OrbsHit:
	setangle $3f
	jump2byte _loopCheckToggleBlocks


herosCaveScript_allButtonsPressedAndEnemiesDefeated:
	stopifitemflagset
	checkmemoryeq wActiveTriggers, $ff
	wait 60
	checknoenemies
	spawnitem TREASURE_SMALL_KEY $01
	scriptend
