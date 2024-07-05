; ==================================================================================================
; INTERAC_DUNGEON_SCRIPT
; ==================================================================================================
interactionCode20:
	call interactionDeleteAndRetIfEnabled02
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a
	xor a
	ld ($cfc1),a
	ld ($cfc2),a

	ld a,(wDungeonIndex)
	cp $ff
	jp z,interactionDelete

	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,Interaction.subid
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionRunScript

@state2:
	call objectPreventLinkFromPassing

@state1:
	call interactionRunScript
	ret nc
	jp interactionDelete

@scriptTable:
	.dw @dungeon0
	.dw @dungeon1
	.dw @dungeon2
	.dw @dungeon3
	.dw @dungeon4
	.dw @dungeon5
	.dw @dungeon6
	.dw @dungeon7
	.dw @dungeon8
	.dw @dungeon9
	.dw @dungeonA
	.dw @dungeonB

@dungeon0:
	.dw mainScripts.dungeonScript_end
	.dw mainScripts.dungeonScript_checkActiveTriggersEq01

@dungeon1:
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_checkActiveTriggersEq01
	.dw mainScripts.dungeonScript_checkActiveTriggersEq01
	.dw mainScripts.dungeonScript_bossDeath

@dungeon2:
	.dw mainScripts.snakesRemainsScript_timerForChestDisappearing
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.snakesRemainsScript_bossDeath

@dungeon3:
	.dw mainScripts.poisonMothsLairScript_hallwayTrapRoom
	.dw mainScripts.poisonMothsLairScript_checkStatuePuzzle
	.dw mainScripts.poisonMothsLairScript_minibossDeath
	.dw mainScripts.poisonMothsLairScript_bossDeath
	.dw mainScripts.poisonMothsLairScript_openEssenceDoorIfBossBeat

@dungeon4:
	.dw mainScripts.dancingDragonScript_spawnStairsToB1
	.dw mainScripts.dancingDragonScript_torchesHallway
	.dw mainScripts.dancingDragonScript_torchesHallway
	.dw mainScripts.dancingDragonScript_spawnBossKey
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dancingDragonScript_pushingPotsRoom
	.dw mainScripts.dancingDragonScript_bridgeInB2

@dungeon5:
	.dw mainScripts.unicornsCaveScript_spawnBossKey
	.dw mainScripts.unicornsCaveScript_dropMagnetBallAfterDarknutKill
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath

@dungeon6:
	.dw mainScripts.dungeonScript_spawnKeyOnMagnetBallToButton
	.dw mainScripts.ancientRuinsScript_spawnStaircaseUp1FTopLeftRoom
	.dw mainScripts.ancientRuinsScript_spawnStaircaseUp1FTopMiddleRoom
	.dw mainScripts.ancientRuinsScript_4c50
	.dw mainScripts.ancientRuinsScript_5TorchesMovingPlatformsRoom
	.dw mainScripts.ancientRuinsScript_roomWithJustRopesSpawningButton
	.dw mainScripts.ancientRuinsScript_UShapePitToMagicBoomerangOrb
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.ancientRuinsScript_randomButtonRoom
	.dw mainScripts.ancientRuinsScript_4F3OrbsRoom
	.dw mainScripts.ancientRuinsScript_spawnStairsLeadingToBoss
	.dw mainScripts.ancientRuinsScript_spawnHeartContainerAndStairsUp
	.dw mainScripts.ancientRuinsScript_1FTopRightTrapButtonRoom
	.dw mainScripts.ancientRuinsScript_crystalTrapRoom
	.dw mainScripts.ancientRuinsScript_spawnChestAfterCrystalTrapRoom

@dungeon7:
	.dw mainScripts.explorersCryptScript_4OrbTrampoline
	.dw mainScripts.explorersCryptScript_magunesuTrampoline
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.explorersCryptScript_4d05
	.dw mainScripts.explorersCryptScript_randomlyPlaceNonEnemyArmos
	.dw mainScripts.dungeonScript_checkIfMagnetBallOnButton
	.dw mainScripts.explorersCryptScript_1stPoeSisterRoom
	.dw mainScripts.explorersCryptScript_2ndPoeSisterRoom
	.dw mainScripts.explorersCryptScript_4FiresRoom_1
	.dw mainScripts.explorersCryptScript_4FiresRoom_2
	.dw mainScripts.explorersCryptScript_darknutBridge
	.dw mainScripts.explorersCryptScript_roomLeftOfRandomArmosRoom
	.dw mainScripts.explorersCryptScript_dropKeyDownAFloor
	.dw mainScripts.explorersCryptScript_keyDroppedFromAbove

@dungeon8:
	.dw mainScripts.swordAndShieldMazeScript_verticalBridgeUnlockedByOrb
	.dw mainScripts.swordAndShieldMazeScript_verticalBridgeInLava
	.dw mainScripts.swordAndShieldMazeScript_armosBlockingStairs
	.dw mainScripts.dungeonScript_spawnKeyOnMagnetBallToButton
	.dw mainScripts.swordAndShieldMazeScript_7torchesAfterMiniboss
	.dw mainScripts.swordAndShieldMazeScript_spawnFireKeeseAtLavaHoles
	.dw mainScripts.swordAndShieldMazeScript_pushableIceBlocks
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.swordAndShieldMazeScript_horizontalBridgeByMoldorms
	.dw mainScripts.swordAndShieldMazeScript_tripleEyesByMiniboss
	.dw mainScripts.swordAndShieldMazeScript_tripleEyesNearStart

@dungeon9:
	.dw mainScripts.onoxsCastleScript_setFlagOnAllEnemiesDefeated
	.dw mainScripts.onoxsCastleScript_resetRoomFlagsOnDungeonStart

@dungeonA:
@dungeonB:
	.dw mainScripts.dungeonScript_spawnKeyOnMagnetBallToButton
	.dw mainScripts.dungeonScript_checkActiveTriggersEq01
	.dw mainScripts.herosCaveScript_spawnChestOnTorchLit
	.dw mainScripts.dungeonScript_checkIfMagnetBallOnButton
	.dw mainScripts.herosCaveScript_check6OrbsHit
	.dw mainScripts.herosCaveScript_allButtonsPressedAndEnemiesDefeated
	.dw mainScripts.herosCaveScript_spawnChestOn2TorchesLit
