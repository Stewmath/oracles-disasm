dungeonScript_spawnChestOnTriggerBit0:
	checkitemflag
	checkflagset $00 wActiveTriggers
	jump2byte _spawnChestHere


makuPathScript_spawnChestWhenActiveTriggersEq01:
	checkitemflag
	checkmemoryeq wActiveTriggers $01

_spawnChestHere:
	playsound SND_SOLVEPUZZLE
	createpuff
	wait 15
	settilehere TILEINDEX_CHEST
	scriptend

makuPathScript_spawnDownStairsWhenEnemiesKilled:
	checkroomflag80
	wait 30
	checknoenemies
	playsound SND_SOLVEPUZZLE
	orroomflag $80
	createpuff
	wait 15
	settilehere $45
	scriptend

makuPathScript_spawn30Rupees:
	checkitemflag
	spawnitem TREASURE_RUPEES $0c
	scriptend

makuPathScript_keyFallsFromCeilingWhen1TorchLit:
	checkitemflag
	checkmemoryeq wNumTorchesLit $01
	spawnitem TREASURE_SMALL_KEY $01
	scriptend

makuPathScript_spawnUpStairsWhen2TorchesLit:
	checkitemflag
	checkmemoryeq wNumTorchesLit $02
	orroomflag $80
	playsound SND_SOLVEPUZZLE
	createpuff
	wait 15
	settilehere $46
	scriptend


; Spawn the moving platform in the room with 2 buttons when the right one is pressed.
spiritsGraveScript_spawnMovingPlatform:
	checkflagset $01 wActiveTriggers
	setcoords $48 $78
	asm15 objectCreatePuff
	setcoords $58 $78
	asm15 objectCreatePuff
	wait 30
	spawninteraction INTERACID_MOVING_PLATFORM $09 $50 $78
	playsound SND_SOLVEPUZZLE
	scriptend

spiritsGraveScript_spawnBracelet:
	checkitemflag
	spawnitem TREASURE_BRACELET $00
	scriptend


; Create the miniboss portal when it's killed.
dungeonScript_minibossDeath:
	checkroomflag80
	checknoenemies
	orroomflag $80
	wait 20
	spawninteraction INTERACID_MINIBOSS_PORTAL $00 $00 $00


_script4bc8:
	writememory wcbca $00
	scriptend

; Spawn a heart container when the boss is killed.
dungeonScript_bossDeath:
	jumpifroomflagset $80 ++
	checknoenemies
	orroomflag $80
++
	checkitemflag
	setcoords $58 $78

_spawnHeartContainer:
	spawnitem TREASURE_HEART_CONTAINER $00
	jump2byte _script4bc8

wingDungeonScript_bossDeath:
	jumpifroomflagset $80 @spawnHeart
	checknoenemies
	orroomflag $80

	; Create staircase tiles
	setcoords $a8 $48
	createpuff
	settilehere $19
	setcoords $a8 $a8
	createpuff
	settilehere $19

@spawnHeart:
	checkitemflag
	setcoords $98 $78
	jump2byte _spawnHeartContainer


; Spawn stairs to the bracelet room when the two torches are lit.
spiritsGraveScript_stairsToBraceletRoom:
	checkroomflag80
	asm15 scriptHlp.makeTorchesLightable
	checkmemoryeq wNumTorchesLit $02
	orroomflag $80
	playsound SND_SOLVEPUZZLE
	asm15 objectCreatePuff
	settilehere $45
	scriptend


wingDungeonScript_spawnFeather:
	checkitemflag
	spawnitem TREASURE_FEATHER $00
	scriptend

wingDungeonScript_spawn30Rupees:
	checkitemflag
	spawnitem TREASURE_RUPEES $0c
	scriptend

moonlitGrottoScript_spawnChestWhen2TorchesLit:
	checkitemflag
	checkmemoryeq wNumTorchesLit $02
	jump2byte _spawnChestHere


; The room with the moving platform and an orb to hit
skullDungeonScript_spawnChestWhenOrb0Hit:
	checkitemflag
	checkflagset $00 wToggleBlocksState
	jump2byte _spawnChestHere

; The room with an orb that's being blocked by a moldorm
skullDungeonScript_spawnChestWhenOrb1Hit:
	checkitemflag
	checkflagset $01 wToggleBlocksState
	jump2byte _spawnChestHere


; The room with 3 eyeball-statue things that need to be hit with a seed shooter
crownDungeonScript_spawnChestWhen3TriggersActive:
	checkitemflag
	checkmemoryeq wActiveTriggers $07
	jump2byte _spawnChestHere


mermaidsCaveScript_spawnBridgeWhenOrbHit:
	checkroomflag40
	checkflagset $00 wToggleBlocksState
	asm15 scriptHlp.mermaidsCave_spawnBridge_room38
	scriptend

mermaidsCaveScript_updateTrigger2BasedOnTriggers0And1:
	wait 1
	asm15 scriptHlp.setTrigger2IfTriggers0And1Set
	jump2byte mermaidsCaveScript_updateTrigger2BasedOnTriggers0And1


; Creates a stair tile facing south when trigger 0 is activated
ancientTombScript_spawnSouthStairsWhenTrigger0Active:
	checkroomflag40
	checkmemoryeq wActiveTriggers $01
	settilehere $50

_ancientTombScript_finishMakingStairs:
	orroomflag $40
	asm15 objectCreatePuff
	playsound SND_SOLVEPUZZLE
	scriptend

; Creates a stair tile facing north when trigger 0 is activated
ancientTombScript_spawnNorthStairsWhenTrigger0Active:
	checkroomflag40
	checkmemoryeq wActiveTriggers $01
	settilehere $52
	jump2byte _ancientTombScript_finishMakingStairs


ancientTombScript_retractWallWhenTrigger0Active:
	checkroomflag40
	checkmemoryeq wActiveTriggers $01
	disableinput
	wait 30
	asm15 scriptHlp.ancientTomb_startWallRetractionCutscene
	scriptend


ancientTombScript_spawnDownStairsWhenEnemiesKilled:
	checkroomflag80
	wait 30
	checknoenemies
	playsound SND_SOLVEPUZZLE
	asm15 objectCreatePuff
	settilehere $45
	orroomflag $80
	scriptend


ancientTombScript_spawnVerticalBridgeWhenTorchLit:
	checkmemoryeq wNumTorchesLit $01
	settilehere $6a
	playsound SND_SOLVEPUZZLE
	createpuff
	scriptend



herosCaveScript_spawnChestWhen4TriggersActive:
	checkitemflag
	checkmemoryeq wActiveTriggers $0f
	jump2byte _spawnChestHere

herosCaveScript_spawnBridgeWhenTriggerPressed:
	checkroomflag40
	checkflagset $01 wActiveTriggers
	asm15 scriptHlp.herosCave_spawnBridge_roomc9
	scriptend

herosCaveScript_spawnNorthStairsWhenEnemiesKilled:
	checkitemflag
	checknoenemies
	settilehere $52
	playsound SND_SOLVEPUZZLE
	scriptend
