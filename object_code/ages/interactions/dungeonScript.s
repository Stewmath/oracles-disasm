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
	.dw @dungeona
	.dw @dungeonb
	.dw @dungeonc
	.dw @dungeond

@dungeon0:
@dungeond:
	.dw mainScripts.makuPathScript_spawnChestWhenActiveTriggersEq01
	.dw mainScripts.makuPathScript_spawnDownStairsWhenEnemiesKilled
	.dw mainScripts.makuPathScript_spawn30Rupees
	.dw mainScripts.makuPathScript_keyFallsFromCeilingWhen1TorchLit
	.dw mainScripts.makuPathScript_spawnUpStairsWhen2TorchesLit
@dungeon1:
	.dw mainScripts.dungeonScript_spawnChestOnTriggerBit0
	.dw mainScripts.spiritsGraveScript_spawnBracelet
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.spiritsGraveScript_stairsToBraceletRoom
	.dw mainScripts.spiritsGraveScript_spawnMovingPlatform
@dungeon2:
	.dw mainScripts.wingDungeonScript_spawnFeather
	.dw mainScripts.wingDungeonScript_spawn30Rupees
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.wingDungeonScript_bossDeath
@dungeon3:
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.moonlitGrottoScript_spawnChestWhen2TorchesLit
@dungeon4:
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.skullDungeonScript_spawnChestWhenOrb0Hit
	.dw mainScripts.skullDungeonScript_spawnChestWhenOrb1Hit
@dungeon5:
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.crownDungeonScript_spawnChestWhen3TriggersActive
@dungeon6:
	.dw mainScripts.dungeonScript_minibossDeath
@dungeon7:
	.dw mainScripts.dungeonScript_bossDeath
@dungeon8:
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.ancientTombScript_spawnSouthStairsWhenTrigger0Active
	.dw mainScripts.ancientTombScript_spawnNorthStairsWhenTrigger0Active
	.dw mainScripts.ancientTombScript_retractWallWhenTrigger0Active
	.dw mainScripts.ancientTombScript_spawnDownStairsWhenEnemiesKilled
	.dw mainScripts.ancientTombScript_spawnVerticalBridgeWhenTorchLit
@dungeon9:
@dungeona:
@dungeonb:
	.dw mainScripts.dungeonScript_spawnChestOnTriggerBit0
	.dw mainScripts.herosCaveScript_spawnChestWhen4TriggersActive
	.dw mainScripts.herosCaveScript_spawnBridgeWhenTriggerPressed
	.dw mainScripts.herosCaveScript_spawnNorthStairsWhenEnemiesKilled
@dungeonc:
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.mermaidsCaveScript_spawnBridgeWhenOrbHit
	.dw mainScripts.mermaidsCaveScript_updateTrigger2BasedOnTriggers0And1
