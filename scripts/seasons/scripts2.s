; This is somewhat similar to the ages "scriptHelper" file, which contain extra scripts. HOWEVER,
; there is an important difference: because this is not located in bank 15, the "asm15" opcode does
; not work here.
;
; For consistency's sake, any code that works with the "asm15" opcode is put into the "scriptHelp"
; namespace. Since it doesn't work here, this is put into the "scripts2" namespace instead.
;
; In ages, essentially, this file and the "scriptHelper" file are the same file.

; ==================================================================================================
; INTERAC_DUNGEON_SCRIPT
; ==================================================================================================
explorersCrypt_firesGoingOut_1:
	delay 5
	playsound SND_GHOST
	showtext TX_0a00
	playsound SND_CREEPY_LAUGH

	setcounter1 $30
	playsound SND_LIGHTTORCH
	settileat $46, TILEINDEX_UNLIT_TORCH

	setcounter1 $30
	playsound SND_LIGHTTORCH
	settileat $48, TILEINDEX_UNLIT_TORCH
	asm15 darkenRoomLightly

	setcounter1 $30
	playsound SND_LIGHTTORCH
	settileat $68, TILEINDEX_UNLIT_TORCH
	asm15 darkenRoom

	setcounter1 $30
	playsound SND_LIGHTTORCH
	settileat $66, TILEINDEX_UNLIT_TORCH

	setcounter1 $30
	playsound SND_TELEPORT
	asm15 scriptHelp.warpToD7Entrance
	scriptend


explorersCrypt_firesGoingOut_2:
	delay 5
	playsound SND_GHOST
	showtext TX_0a00
	playsound SND_CREEPY_LAUGH

	setcounter1 $30
	playsound SND_LIGHTTORCH
	settileat $35, TILEINDEX_UNLIT_TORCH

	setcounter1 $30
	playsound SND_LIGHTTORCH
	settileat $39, TILEINDEX_UNLIT_TORCH
	asm15 darkenRoomLightly

	setcounter1 $30
	playsound SND_LIGHTTORCH
	settileat $79, TILEINDEX_UNLIT_TORCH
	asm15 darkenRoom

	setcounter1 $30
	playsound SND_LIGHTTORCH
	settileat $75, TILEINDEX_UNLIT_TORCH

	setcounter1 $30
	playsound SND_TELEPORT
	asm15 scriptHelp.warpToD7Entrance
	scriptend


explorersCrypt_firstPoeSister:
	stopifroomflag40set
	checkmemoryeq wNumTorchesLit, $02

	playsound SND_GHOST
	delay 8
	spawnenemy ENEMY_POE_SISTER_1, $00, $48, $c8
	delay 6
	showtext TX_0a01
	delay 6

	checknoenemies
	orroomflag $40
	enableallobjects
	scriptend


explorersCrypt_secondPoeSister:
	stopifroomflag40set
	checkmemoryeq wNumTorchesLit, $04

	playsound SND_GHOST
	delay 8
	spawnenemy ENEMY_POE_SISTER_2, $00, $58, $78
	delay 6
	showtext TX_0a03
	delay 6

	checknoenemies
	orroomflag $40
	scriptend


startCrystalTrapRoomSequence:
	spawninteraction INTERAC_DOOR_CONTROLLER, $13, $30, $00
	spawninteraction INTERAC_PUFF, $00, $18, $48
	delay 4
	settileat $14, TILEINDEX_STANDARD_FLOOR
	spawninteraction INTERAC_PUFF, $00, $38, $48
	delay 4
	settileat $34, TILEINDEX_STANDARD_FLOOR
	spawninteraction INTERAC_PUFF, $00, $28, $48
	delay 4
	settileat $24, TILEINDEX_STANDARD_FLOOR
	spawninteraction INTERAC_PUFF, $00, $48, $48
	delay 4
	settileat $44, TILEINDEX_STANDARD_FLOOR
	spawninteraction INTERAC_D6_CRYSTAL_TRAP_ROOM, $00, $00, $00
	scriptend


; ==================================================================================================
; INTERAC_SEASON_SPIRITS_SCRIPTS
; ==================================================================================================
seasonsSpirits_enteringTempleCutscene:
	stopifroomflag40set
	setcollisionradii $08, $20
	checkcollidedwithlink_onground
	disableinput
	setmusic $0d
	showtextlowindex <TX_0800
	delay 6
	showtextlowindex <TX_0801
	delay 6
	showtextlowindex <TX_0802
	delay 6
	showtextlowindex <TX_0803
	resetmusic
	orroomflag $40
	enableinput
	scriptend


seasonsSpirits_createBridgeOnOrbHit:
	stopifroomflag40set
	checkmemoryeq w1Link.state, LINK_STATE_NORMAL
	delay 3
	checkmemoryeq wToggleBlocksState, $01
	setcoords $78, $78
	setcounter1 $0c
	createpuff
	delay 2
	settilehere TILEINDEX_VERTICAL_BRIDGE
	playsound SND_SOLVEPUZZLE
	orroomflag $40
	scriptend


; ==================================================================================================
; INTERAC_SUBROSIAN
; ==================================================================================================
subrosianScript_steaLinksFeather:
	stopifroomflag40set
	writeobjectbyte Interaction.oamFlags, $01
	callscript mainScripts.subrosianScript_runLeft
	checkcfc0bit 0
	asm15 scriptHelp.subrosian_setYAboveLink
	applyspeed $68
	checkcfc0bit 2
	asm15 objectSetVisiblec1
	setspeed $28
	setangle ANGLE_RIGHT
	asm15 scriptHelp.subrosianFunc_58dc
	checkcfc0bit 3
	setanimation $01
	setstate $03
	checkcollidedwithlink_onground
	setstate $02
	asm15 scriptHelp.subrosian_giveFoolsOre
	delay 6
	xorcfc0bit 4
	setanimation $03
	setspeed $50
	setangle ANGLE_LEFT
	asm15 scriptHelp.subrosianFunc_5968
	delay 1
	asm15 scriptHelp.subrosian_knockLinkOut
	showtext TX_0036
	enableinput
	resetmusic
	scriptend


subrosianScript_inHouseRunFromLink:
	jumpifglobalflagset GLOBALFLAG_SAW_STRANGE_BROTHERS_IN_HOUSE, mainScripts.stubScript
	writeobjectbyte Interaction.oamFlags, $02
	callscript mainScripts.subrosianScript_runLeft
	setanimation $02
	setdisabledobjectsto11
	delay 8
	setzspeed -$300
	showtext TX_2801
	xorcfc0bit 0
	checkcfc0bit 1
	setanimation $03
	applyspeed $40
	scriptend


; ==================================================================================================
; INTERAC_PIRATIAN_CAPTAIN
; ==================================================================================================
linkedPirateCaptainScript_sayingByeToAmbi:
	asm15 scriptHelp.forceLinkState8AndSetDirection, DIR_DOWN
	delay 6
	showtextlowindex <TX_3a20
	delay 6
	showtextlowindex <TX_3a21
	delay 6
	showtextlowindex <TX_3a28
	delay 6
	showtextlowindex <TX_3a22
	delay 6
	showtextlowindex <TX_3a29
	delay 6
	showtextlowindex <TX_3a23
	asm15 objectSetVisible81
	setspeed SPEED_80
	movedown $09
	delay 6
	showtextlowindex <TX_3a2a
	xorcfc0bit 2
	delay 6
	showtextlowindex <TX_3a24
	delay 6
	scriptjump mainScripts.piratianCaptainScript_inHouse@unlinkedCaptain

showSamasaGateCombination:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_3a0c
	delay 6
	writeobjectbyte Interaction.var3c, $01
	setspeed SPEED_200
	moveup $15
	delay 1
	setanimation $00
	setangle ANGLE_RIGHT
	applyspeed $09
	delay 1
	callscript mainScripts.pirationScript_closeOpenCupboard
	callscript mainScripts.pirationScript_closeOpenCupboard
	setanimation $00
	setangle ANGLE_LEFT
	applyspeed $09
	delay 1
	callscript mainScripts.pirationScript_closeOpenCupboard
	setanimation $00
	setangle ANGLE_LEFT
	applyspeed $09
	delay 1
	callscript mainScripts.pirationScript_closeOpenCupboard
	callscript mainScripts.pirationScript_closeOpenCupboard
	setanimation $00
	setangle ANGLE_RIGHT
	applyspeed $19
	delay 1
	callscript mainScripts.pirationScript_closeOpenCupboard
	callscript mainScripts.pirationScript_closeOpenCupboard
	callscript mainScripts.pirationScript_closeOpenCupboard
	setanimation $00
	setangle ANGLE_LEFT
	applyspeed $11
	delay 1
	movedown $15
	writeobjectbyte Interaction.var3c, $00
	delay 6
	showtextlowindex <TX_3a0d
	delay 6
	enableallobjects
	scriptjump mainScripts.piratian2FScript_textBasedOnD6Beaten@showGateCombo

piratianCaptain_preCutsceneScene:
	disableinput
	asm15 scriptHelp.pirateCaptain_freezeLinkForCutscene
	writememory wDisableWarpTiles, $01
	delay 8
	asm15 scriptHelp.piratesDeparting_spawnPirateFromShip
	checkcfc0bit 0
	callscript mainScripts.piratianScript_jump
	delay 6
	showtextlowindex <TX_3a25
	delay 6
	xorcfc0bit 1
	writeobjectbyte Interaction.var3c, $01
	asm15 objectSetVisible81
	setspeed SPEED_100
	moveright $41
	delay 1
	setspeed SPEED_100
	moveup $1f
	callscript mainScripts.piratianScript_moveUpPauseThenUp
	asm15 scriptHelp.piratianCaptain_setInvisible
	checkcfc0bit 2
	asm15 scriptHelp.piratianCaptain_simulatedInput
	enableallobjects
	checkflagset $07, $cbc3
	setdisabledobjectsto91
	delay 5
	asm15 scriptHelp.piratianCaptain_setLinkInvisible
	writememory $cbc3, $00
	delay 8
	setdisabledobjectsto11
	writememory wCutsceneTrigger, CUTSCENE_S_PIRATES_DEPART
	scriptend


; ==================================================================================================
; INTERAC_ZELDA
; ==================================================================================================
zelda_triforceOnHandText:
	asm15 objectSetInvisible
	checkmemoryeq $cfc0, $01
	asm15 objectSetVisible
	checkmemoryeq $cfc0, $06
	setanimation $03
	delay 2
	writememory $cfc0, $07
	showtext TX_3d0c ; triforce on your hand
	delay 3
	setanimation $07
	setangle ANGLE_LEFT
	setspeed SPEED_20
	applyspeed $1e
	writememory $cfc0, $08
	scriptend

zelda_kidnapped:
	delay 8
	setcoords $18, $18
	setspeed SPEED_100
	movedown $11
	delay 1
	moveright $39
	delay 1
	movedown $11
	delay 1
	showtext TX_500d ; Zelda! No!
	delay 6
	spawninteraction INTERAC_ba, $01, $18, $18
	checkcfc0bit 0
	applyspeed $51
	xorcfc0bit 1
	scriptend

script_14_49b6:
	setanimation $02
	checkcfc0bit 6
	setanimation $03
	delay 4
	setanimation $01
	delay 4
	setanimation $02
	checkcfc0bit 5
	asm15 scriptHelp.zelda_createExclamationMark
	playsound SND_CLINK
	scriptend

script_14_49c8:
	setanimation $03
	delay 11
	setspeed SPEED_80
	setangle ANGLE_LEFT
	applyspeed $c0
	delay 10
	setanimation $00
	setcounter1 $96
	writememory $cfdf, $01
	scriptend


; ==================================================================================================
; INTERAC_TALON
; ==================================================================================================
talon_giveMushroomAfterWaking:
	disableinput
	spawninteraction INTERAC_TRADE_ITEM, $07, $68, $58
	writeobjectbyte Interaction.var39, $00
	playsound $69
	setanimation $04
	delay 7
	writememory $cfde, $80
	setanimation $02
	showtextlowindex <TX_0b3b
	writememory $cfdf, $01
	giveitem TREASURE_TRADEITEM, $08
	orroomflag $40
	asm15 scriptHelp.resetBit5ofRoomFlags
	delay 6
	writeobjectbyte Interaction.var3a, $01
	setspeed SPEED_200
	setangle ANGLE_RIGHT
	applyspeed $11
	setanimation $01
	setangle ANGLE_DOWN
	applyspeed $29
	enableinput
	scriptend


; ==================================================================================================
; INTERAC_DIN_DANCING_EVENT
; ==================================================================================================
tornadoScript_startDestruction:
	setcoords $70, $18
	setspeed $50
	setmusic $21
	delay 10
	setangle $08
	applyspeed $11
	ormemory $cfd1, $10
	delay 5
	applyspeed $0d
	delay 7
	setangle $00
	applyspeed $08
	ormemory $cfd1, $02
	delay 7
	setangle $08
	applyspeed $13
	ormemory $cfd1, $08
	delay 7
	setangle $00
	applyspeed $0a
	ormemory $cfd1, $04
	delay 7
	setangle $18
	applyspeed $30
	setangle $00
	applyspeed $0d
	ormemory $cfd1, $01
	scriptend

tornadoScript_endDestruction:
	setangle $08
	applyspeed $14
	ormemory $cfd1, $40
	checkmemoryeq $cfd0, $07
	applyspeed $16
	ormemory $cfd1, $80
	checkmemoryeq $cfd0, $0a
	delay 9
	setangle $00
	applyspeed $28
	writememory $cfd0, $0b
	orroomflag $80
	scriptend


; ==================================================================================================
; INTERAC_DIN_IMPRISONED_EVENT
; ==================================================================================================
dinImprisoned_OnoxExplainsMotive:
	setcoords $e0, $80
	delay 6
	setspeed SPEED_100
	setangle ANGLE_UP
	setanimation $02
	applyspeed $58
	setanimation $01
	delay 8
	showtext TX_1e00
	delay 3
	showtext TX_1e02
	delay 3
	showtext TX_1e03
	delay 3
	showtext TX_1e04
	delay 3
	writememory $cfd0, $0b
	scriptend

dinImprisoned_OnoxSaysComeIfYouDare:
	setcoords $00, $60
	setspeed $14
	setangle $10
	applyspeed $80
	setanimation $10
	delay 8
	showtext TX_171a
	delay 8
	xorcfc0bit 1
	scriptend


; ==================================================================================================
; INTERAC_BIGGORON
; ==================================================================================================
biggoronScript_giveBiggoronSword:
	setglobalflag GLOBALFLAG_BEGAN_BIGGORON_SECRET
	asm15 scriptHelp.biggoron_loadAnimationData, $0d
	showtextlowindex <TX_0b55
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	asm15 fadeoutToWhite
	checkpalettefadedone
	delay 8
	asm15 fadeinFromWhite
	checkpalettefadedone
	asm15 scriptHelp.biggoron_loadAnimationData, $0d
	showtextlowindex <TX_0b57
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	asm15 scriptHelp.biggoron_createSparkleAtLink
	delay 6
	asm15 scriptHelp.createSwirlAtLink
	delay 3
	playsound $b4
	asm15 fadeoutToWhite
	delay 5
	playsound $b4
	asm15 fadeoutToWhite
	delay 5
	playsound $b4
	asm15 fadeoutToWhite
	checkpalettefadedone
	delay 5
	asm15 fadeinFromWhiteWithDelay, $04
	checkpalettefadedone
	giveitem TREASURE_BIGGORON_SWORD, $00
	delay 8
	setglobalflag GLOBALFLAG_DONE_BIGGORON_SECRET
	scriptjump mainScripts.biggoronScript@generateSecret


; ==================================================================================================
; INTERAC_HEAD_SMELTER
; ==================================================================================================
script_14_4aea:
	disablemenu
	setdisabledobjectsto11
	incstate
	showtext TX_2a02
	setmusic $f0
	setspeed $28
	moveright $11
	moveup $21
	delay 7
	asm15 scriptHelp.headSmelter_throwRedOreIn
	delay 7
	asm15 scriptHelp.headSmelter_throwBlueOreIn
	delay 8
	setangleandanimation $10
	asm15 scriptHelp.headSmelter_setTiles
	asm15 scriptHelp.headSmelter_loadDanceMovements
	movedown $11
	delay 6
	writememory $d008, $00
	delay 8
	showtext TX_2a03
	setmusic $31
	setcounter1 $7d
	setstate $03
	callscript mainScripts.script62b1
	callscript mainScripts.script62b1
	setcounter1 $c6
	callscript mainScripts.script62b1
	callscript mainScripts.script62b1
	asm15 scriptHelp.headSmelter_smeltingDone
	playsound $79
	delay 6
	asm15 scriptHelp.headSmelter_resetTiles
	asm15 scriptHelp.headSmelter_giveHardOre
	setmusic $f0
	delay 8
	playsound $4d
	xorcfc0bit 3
	xorcfc0bit 7
	delay 8
	showtext TX_2a04
	setstate $01
	setangleandanimation $10
	resetmusic
	orroomflag $40
	enableinput
	rungenericnpc TX_2a05

headSmelterScript_blowUpRocks:
	showtext TX_2708
	asm15 scriptHelp.headSmelter_loseBombFlower
	setanimation $00
	delay 8
	spawninteraction INTERAC_BOMB_FLOWER, $01, $38, $38
	playsound $6c
	delay 4
	incstate
	setspeed $50
	movedown $11
	moveright $19
	delay 4
	setangleandanimation $18
	checkcfc0bit 0
	asm15 scriptHelp.headSmelter_loadHideFromBombScript
	writememory $d008, $00
	moveleft $19
	moveup $19
	delay 5
	setangleandanimation $08
	delay 5
	setangleandanimation $18
	delay 5
	xorcfc0bit 1
	delay 0
	setangleandanimation $10
	showtext TX_2709
	xorcfc0bit 2
	applyspeed $31
	writememory $d008, $02
	enableinput
	asm15 scriptHelp.headSmelter_enableScreenTransitions
	scriptend


; ==================================================================================================
; INTERAC_LAVA_SOUP_SUBROSIAN
; ==================================================================================================
lavaSoupSubrosianScript_fillPot:
	delay 6
	showtextlowindex <TX_0b21
	writeobjectbyte Interaction.var3f, $01
	setspeed $50
	moveleft $11
	playsound $6e
	setspeed $28
	applyspeed $11
	setspeed $50
	applyspeed $09
	moveup $15
	playsound $d0
	setangle $18
	applyspeed $05
	playsound $d0
	setangle $08
	applyspeed $09
	playsound $d0
	setangle $18
	applyspeed $09
	playsound $d0
	setangle $08
	applyspeed $09
	playsound $d0
	setangle $18
	applyspeed $05
	movedown $15
	moveright $09
	playsound $6e
	setspeed $28
	applyspeed $11
	setspeed $50
	applyspeed $11
	setanimation $00
	showtextlowindex <TX_0b22
	setanimation $02
	showtextlowindex <TX_0b23
	disableinput
	giveitem TREASURE_TRADEITEM, $04
	orroomflag $40
	writeobjectbyte Interaction.var3f, $00
	enableinput
	scriptjump mainScripts.lavaSoupSubrosianScript@filledPot


; ==================================================================================================
; INTERAC_DANCE_HALL_MINIGAME
; ==================================================================================================
danceLeaderScript_moveIntoPosition:
	showtext TX_0102
	orroomflag $80
	setdisabledobjectsto91
	writememory $d008, $03
	incstate
	setspeed $50
	moveleft $21
	setangleandanimation $10
	delay 6
	setspeed $28
	asm15 scriptHelp.seasonsFunc_15_5d45
	applyspeed $0a
	setanimation $04
	delay 6
	setanimation $02
	incstate
	scriptend

danceLeaderScript_danceTutorial:
	writememory $cfdf, $00
	spawninteraction INTERAC_DANCE_HALL_MINIGAME, $03, $00, $00
	setanimation $05
	writememory $cfdf, $01
	delay 2
	showtext TX_0105
	setanimation $05
	playsound $ca
	asm15 scriptHelp.seasonsFunc_15_5d20
	checkmemoryeq $cfd1, $00
	setcounter1 $32
	setanimation $06
	writememory $cfdf, $02
	delay 2
	showtext TX_0106
	setanimation $06
	playsound $cb
	asm15 scriptHelp.seasonsFunc_15_5d29
	checkmemoryeq $cfd1, $00
	setcounter1 $32
	setanimation $04
	writememory $cfdf, $03
	delay 2
	showtext TX_0107
	setanimation $04
	playsound $cd
	asm15 scriptHelp.seasonsFunc_15_5d32
	checkmemoryeq $cfd1, $00
	setcounter1 $32
	writememory $cfdf, $ff
	setanimation $01
	showtext TX_0108
	jumpiftextoptioneq $01, mainScripts.danceLeaderScript_promptForTutorial@needTutorial
	showtext TX_0109
	checkmemoryeq $cba0, $00
	scriptjump mainScripts.danceLeaderScript_promptForTutorial@danceLeaderScript_readyToDance


; ==================================================================================================
; INTERAC_MISCELLANEOUS_1
; ==================================================================================================
simpleScript_unblockingD3Dam:
	ss_wait $1e
	ss_playsound $70
	ss_setinterleavedtile $14, $fd, $a0, $02
	ss_setinterleavedtile $15, $fd, $a0, $02
	ss_setinterleavedtile $16, $fd, $a0, $02
	ss_wait $1e

	ss_playsound $70
	ss_setrowoftiles $03, $14, $fd
	ss_wait $1e

	ss_playsound $c2
	ss_setrowofinterleavedtiles $03, $04, $fe, $00
	ss_wait $0f

	ss_setrowoftiles $03, $04, $fe
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $14, $fe, $00
	ss_setrowoftiles $03, $04, $ff
	ss_wait $0f

	ss_setrowoftiles $03, $14, $fe
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $24, $fe, $00
	ss_setrowoftiles $03, $14, $ff
	ss_wait $0f

	ss_setrowoftiles $03, $24, $fe
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $34, $fe, $00
	ss_setrowoftiles $03, $24, $ff
	ss_wait $0f

	ss_setrowoftiles $03, $34, $fe
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $44, $fe, $00
	ss_setrowoftiles $03, $34, $ff
	ss_wait $0f

	ss_setrowoftiles $03, $44, $fe
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $54, $fe, $00
	ss_setrowoftiles $03, $44, $ff
	ss_wait $0f

	ss_setrowoftiles $03, $54, $fe
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $64, $fe, $00
	ss_setrowoftiles $03, $54, $ff
	ss_wait $0f

	ss_setrowoftiles $03, $64, $fe
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $74, $fe, $00
	ss_setrowoftiles $03, $64, $ff
	ss_wait $0f

	ss_setrowoftiles $03, $74, $fe
	ss_wait $0f

	ss_setrowoftiles $03, $74, $ff
	ss_wait $3c
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $04, $fa, $00
	ss_wait $0f

	ss_setrowoftiles $03, $04, $fa
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $14, $fa, $00
	ss_wait $0f

	ss_setrowoftiles $03, $14, $fa
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $24, $fa, $00
	ss_wait $0f

	ss_setrowoftiles $03, $24, $fa
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $34, $fa, $00
	ss_wait $0f

	ss_setrowoftiles $03, $34, $fa
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $44, $fa, $00
	ss_wait $0f

	ss_setrowoftiles $03, $44, $fa
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $54, $fa, $00
	ss_wait $0f

	ss_setrowoftiles $03, $54, $fa
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $64, $fa, $00
	ss_wait $0f

	ss_setrowoftiles $03, $64, $fa
	ss_wait $0f

	ss_setrowofinterleavedtiles $03, $74, $fa, $00
	ss_wait $0f

	ss_setrowoftiles $03, $74, $fa
	ss_wait $b4

	ss_playsound $f1
	ss_end

simpleScript_waterfallEmptyingAboveD4:
	ss_playsound $c2
	ss_wait $14
	ss_setinterleavedtile $62, $45, $ff, $02
	ss_setinterleavedtile $63, $54, $ff, $02
	ss_setinterleavedtile $64, $46, $ff, $02
	ss_wait $14

	ss_settile $62, $45
	ss_settile $63, $54
	ss_settile $64, $46
	ss_wait $14

	ss_setinterleavedtile $72, $45, $ff, $02
	ss_setinterleavedtile $73, $54, $ff, $02
	ss_setinterleavedtile $74, $46, $ff, $02
	ss_wait $14

	ss_settile $72, $45
	ss_settile $73, $54
	ss_settile $74, $46
	ss_wait $0a
	ss_end

simpleScript_waterfallEmptyingAtD4:
	ss_setinterleavedtile $02, $b6, $ff, $02
	ss_setinterleavedtile $03, $b7, $ff, $02
	ss_setinterleavedtile $04, $b8, $ff, $02
	ss_wait $14

	ss_settile $02, $b6
	ss_settile $03, $b7
	ss_settile $04, $b8
	ss_wait $14

	ss_setinterleavedtile $12, $6b, $ff, $02
	ss_setinterleavedtile $13, $ee, $ff, $02
	ss_setinterleavedtile $14, $6b, $ff, $02
	ss_wait $14

	ss_settile $12, $6b
	ss_settile $13, $ee
	ss_settile $14, $6b
	ss_wait $14

	ss_setinterleavedtile $22, $6b, $ff, $02
	ss_setinterleavedtile $23, $cc, $ff, $02
	ss_setinterleavedtile $24, $6b, $ff, $02
	ss_wait $14

	ss_settile $22, $6b
	ss_settile $23, $cc
	ss_settile $24, $6b
	ss_wait $3c
	ss_end

simpleScript_creatingBridgeToNatzu:
	ss_wait $28
	ss_playsound $70
	ss_setinterleavedtile $43, $fd, $2d, $03
	ss_setinterleavedtile $44, $fd, $2d, $01
	ss_setinterleavedtile $53, $fd, $2e, $03
	ss_setinterleavedtile $54, $fd, $2e, $01
	ss_wait $28

	ss_playsound $70
	ss_settile $43, $2d
	ss_settile $44, $2d
	ss_settile $53, $2e
	ss_settile $54, $2e
	ss_wait $28

	ss_playsound $4d
	ss_end


; ==================================================================================================
; INTERAC_ROSA_HIDING
; ==================================================================================================
rosaHidingScript_firstEncounterIntro:
	setcoords $48, $b0
	orroomflag $40
	delay 8
	setsubstate $03
	setspeed $50
	moveleft $39
	moveup $19
	setsubstate $02
	setanimation $02
	showtext TX_2600
	scriptjump mainScripts.rosaHidingScript_afterInitialScreenText

rosaHidingScript_secondEncounterOnwardsIntro:
	setspeed $50
	setanimation $02
	setsubstate $02
	delay 8
	showtext TX_2602
	scriptjump mainScripts.rosaHidingScript_afterInitialScreenText

rosaHidingScript_2ndScreenPattern1:
	moveup $20
	moveright $10
	callscript mainScripts.rosaHidingScript_lookLeftUpDown
	movedown $30
	moveleft $40
	callscript mainScripts.rosaHidingScript_lookRightDownUp
	moveup $30
	callscript mainScripts.rosaHidingScript_lookDownLeftRight
	moveup $44
	xorcfc0bit 0
	scriptend

rosaHidingScript_2ndScreenPattern2:
	moveup $20
	moveleft $30
	callscript mainScripts.rosaHidingScript_lookRightDownUp
	movedown $30
	callscript mainScripts.rosaHidingScript_lookUpRightLeft
	moveright $40
	moveup $30
	callscript mainScripts.rosaHidingScript_lookDownLeftRight
	moveup $30
	moveleft $30
	callscript mainScripts.rosaHidingScript_lookRightDownUp
	moveup $24
	xorcfc0bit 0
	scriptend

rosaHidingScript_3rdScreenPattern1:
	moveup $10
	moveright $30
	callscript mainScripts.rosaHidingScript_lookLeftUpDown
	movedown $30
	moveleft $30
	callscript mainScripts.rosaHidingScript_lookRightDownUp
	moveleft $30
	moveup $50
	callscript mainScripts.rosaHidingScript_lookDownLeftRight
	moveright $30
	callscript mainScripts.rosaHidingScript_lookLeftUpDown
	movedown $10
	moveright $40
	callscript mainScripts.rosaHidingScript_lookLeftUpDown
	moveup $30
	callscript mainScripts.rosaHidingScript_lookDownLeftRight
	moveup $14
	xorcfc0bit 0
	scriptend

rosaHidingScript_3rdScreenPattern2:
	moveup $30
	moveleft $30
	callscript mainScripts.rosaHidingScript_lookRightDownUp
	movedown $50
	moveright $30
	callscript mainScripts.rosaHidingScript_lookLeftUpDown
	moveup $30
	moveright $30
	callscript mainScripts.rosaHidingScript_lookLeftUpDown
	movedown $30
	moveleft $30
	callscript mainScripts.rosaHidingScript_lookRightDownUp
	moveup $50
	callscript mainScripts.rosaHidingScript_lookDownLeftRight
	moveup $34
	xorcfc0bit 0
	scriptend

rosaHidingScript_4thScreenPattern1:
	moveup $20
	moveleft $30
	callscript mainScripts.rosaHidingScript_lookRightDownUp
	movedown $30
	moveright $40
	callscript mainScripts.rosaHidingScript_lookLeftUpDown
	moveup $30
	callscript mainScripts.rosaHidingScript_lookDownLeftRight
	moveleft $40
	callscript mainScripts.rosaHidingScript_lookRightDownUp
	moveleft $34
	scriptjump mainScripts.rosaHidingScript_pokeBackOut

rosaHidingScript_4thScreenPattern2:
	moveup $20
	moveright $10
	callscript mainScripts.rosaHidingScript_lookLeftUpDown
	movedown $30
	moveleft $40
	callscript mainScripts.rosaHidingScript_lookRightDownUp
	moveup $40
	movedown $10
	callscript mainScripts.rosaHidingScript_lookRightDownUp
	moveleft $34
	scriptjump mainScripts.rosaHidingScript_pokeBackOut

rosaHidingScript_pokeBackOut_body:
	delay 6
	moveright $14
	delay 6
	callscript mainScripts.rosaHidingScript_lookDownLeftRight
	moveleft $14
	xorcfc0bit 0
	scriptend

rosaHidingScript_portalScreen_body:
	disableinput
	resetmusic
	playsound $4d
	asm15 scriptHelp.rosaHiding_hidingFinishedSetInitialRoomsFlags
	setsubstate $03
	setspeed $28
	setangleandanimation $18
	delay 6
	moveleft $20
	moveup $20
	setanimation $02
	delay 6
	playsound $8d
	settilehere $c5
	orroomflag $40
	enableinput
	scriptend

rosaHidingScript_caught_body:
	setsubstate $02
	setdisabledobjectsto91
	setspeed $50
	setangleandanimation $10
	showtext TX_2601
	setsubstate $05
	scriptend


; ==================================================================================================
; INTERAC_STRANGE_BROTHERS_HIDING
; ==================================================================================================
strangeBrother2Script_1stScreenPattern1:
	movedown $40
	callscript mainScripts.strangeBrotherScript_lookUpDownRightLeft
	moveright $30
	callscript mainScripts.strangeBrotherScript_lookLeftRightUpDown
	movedown $18
	callscript mainScripts.strangeBrotherScript_lookUpDownRightLeft
	movedown $20
	xorcfc0bit 1
	scriptend

strangeBrother2Script_1stScreenPattern2:
	moveup $20
	callscript mainScripts.strangeBrotherScript_lookDownUpRightLeft
	moveright $30
	movedown $10
	moveright $30
	callscript mainScripts.strangeBrotherScript_lookLeftRightUpDown
	moveleft $30
	movedown $20
	moveleft $30
	callscript mainScripts.strangeBrotherScript_lookRightLeftUpDown
	movedown $40
	xorcfc0bit 1
	scriptend

strangeBrother2Script_2ndScreenPattern1:
	setcoords $28, $88
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $18
	delay 8
	moveleft $10
	movedown $20
	callscript mainScripts.strangeBrotherScript_lookUpDownRightLeft
	movedown $10
	moveleft $30
	movedown $20
	callscript mainScripts.strangeBrotherScript_lookUpDownRightLeft
	moveleft $30
	moveup $30
	moveright $20
	moveup $30
	callscript mainScripts.strangeBrotherScript_lookDownUpRightLeft
	moveright $10
	movedown $80
	xorcfc0bit 1
	scriptend

strangeBrother2Script_2ndScreenPattern2:
	setcoords $78, $38
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $08
	delay 8
	moveright $30
	moveup $20
	callscript mainScripts.strangeBrotherScript_lookDownUpRightLeft
	moveleft $20
	moveup $30
	callscript mainScripts.strangeBrotherScript_lookDownUpRightLeft
	delay 9
	moveright $30
	movedown $30
	moveleft $10
	movedown $40
	xorcfc0bit 1
	scriptend

strangeBrother2Script_3rdScreenPattern1:
	setcoords $38, $88
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $18
	delay 8
	moveleft $50
	setangleandanimation $08
	delay 8
	setangleandanimation $18
	delay 11
	moveleft $10
	moveup $10
	moveleft $20
	callscript mainScripts.strangeBrotherScript_lookRightLeftUpDown
	moveleft $20
	xorcfc0bit 1
	scriptend

strangeBrother2Script_3rdScreenPattern2:
	setcoords $38, $28
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $18
	delay 8
	moveleft $10
	callscript mainScripts.strangeBrotherScript_lookRightLeftUpDown
	moveup $20
	moveleft $10
	callscript mainScripts.strangeBrotherScript_lookRightLeftUpDown
	moveright $20
	moveup $10
	moveright $30
	movedown $30
	moveleft $30
	moveup $10
	moveleft $20
	callscript mainScripts.strangeBrotherScript_lookRightLeftUpDown
	moveleft $20
	xorcfc0bit 1
	scriptend

strangeBrother2Script_4thScreenPattern1:
	setcoords $38, $48
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $00
	delay 8
	moveup $20
	callscript mainScripts.strangeBrotherScript_lookDownUpRightLeft
	delay 11
	moveright $40
	callscript mainScripts.strangeBrotherScript_lookLeftRightUpDown
	delay 8
	movedown $20
	moveleft $20
	movedown $10
	callscript mainScripts.strangeBrotherScript_lookUpDownRightLeft
	moveleft $50
	callscript mainScripts.strangeBrotherScript_lookRightLeftUpDown
	moveup $60
	xorcfc0bit 1
	scriptend

strangeBrother2Script_4thScreenPattern2:
	setcoords $08, $18
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $10
	delay 8
	movedown $30
	moveright $20
	moveup $20
	moveleft $20
	moveup $20
	xorcfc0bit 1
	scriptend

strangeBrother2Script_5thScreenPattern1:
	setcoords $08, $38
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $08
	delay 8
	moveright $40
	movedown $60
	callscript mainScripts.strangeBrotherScript_lookUpDownRightLeft
	moveleft $60
	callscript mainScripts.strangeBrotherScript_lookRightLeftUpDown
	moveup $60
	callscript mainScripts.strangeBrotherScript_lookDownUpRightLeft
	moveup $20
	xorcfc0bit 1
	scriptend

strangeBrother2Script_5thScreenPattern2:
	setcoords $08, $88
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $18
	delay 8
	movedown $60
	callscript mainScripts.strangeBrotherScript_lookUpDownRightLeft
	moveleft $70
	callscript mainScripts.strangeBrotherScript_lookRightLeftUpDown
	moveup $60
	callscript mainScripts.strangeBrotherScript_lookDownUpRightLeft
	moveup $20
	xorcfc0bit 1
	scriptend

strangeBrother2Script_6thScreenPattern1:
	setcoords $18, $88
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $10
	delay 8
	movedown $60
	callscript mainScripts.strangeBrotherScript_lookUpDownRightLeft
	moveleft $30
	callscript mainScripts.strangeBrotherScript_lookRightLeftUpDown
	moveup $30
	moveright $10
	moveup $30
	callscript mainScripts.strangeBrotherScript_lookDownUpRightLeft
	moveright $20
	movedown $80
	xorcfc0bit 1
	scriptend

strangeBrother2Script_6thScreenPattern2:
	setcoords $18, $88
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $10
	delay 8
	movedown $30
	moveleft $30
	callscript mainScripts.strangeBrotherScript_lookRightLeftUpDown
	movedown $30
	callscript mainScripts.strangeBrotherScript_lookUpDownRightLeft
	moveright $30
	moveup $30
	moveleft $30
	movedown $50
	xorcfc0bit 1
	scriptend

strangeBrother2Script_finishedScreenPattern2:
	setcoords $48, $38
	setanimation $03
	checkcfc0bit 0
	movedown $50
	scriptend


; ==================================================================================================
; INTERAC_JEWEL_HELPER
; ==================================================================================================
jewelHelperScript_jewelMoldorm_body:
	stopifroomflag40set
	checkcfc0bit 0
	writememory $ccab, $01
	delay 8
	playsound $4d
	delay 8
	playsound $73
	asm15 scriptHelp.jewelHelper_createPuff, $04
	delay 3
	playsound $73
	asm15 scriptHelp.jewelHelper_createPuff, $05
	asm15 scriptHelp.jewelHelper_createPuff, $03
	delay 3
	playsound $73
	asm15 scriptHelp.jewelHelper_createPuff, $01
	asm15 scriptHelp.jewelHelper_createPuff, $07
	delay 3
	playsound $73
	asm15 scriptHelp.jewelHelper_createPuff, $00
	asm15 scriptHelp.jewelHelper_createPuff, $08
	delay 3
	playsound $73
	asm15 scriptHelp.jewelHelper_createPuff, $02
	asm15 scriptHelp.jewelHelper_createPuff, $06
	delay 3
	playsound $73
	asm15 scriptHelp.jewelHelper_createPuff, $01
	asm15 scriptHelp.jewelHelper_createPuff, $05
	asm15 scriptHelp.jewelHelper_createPuff, $03
	asm15 scriptHelp.jewelHelper_createPuff, $07
	delay 3
	playsound $73
	asm15 scriptHelp.jewelHelper_createPuff, $04
	asm15 scriptHelp.jewelHelper_createPuff, $00
	asm15 scriptHelp.jewelHelper_createPuff, $02
	asm15 scriptHelp.jewelHelper_createPuff, $06
	asm15 scriptHelp.jewelHelper_createPuff, $08
	settileat $22, $0f
	settileat $23, $11
	settileat $32, $11
	settileat $33, $0f
	settileat $34, $11
	delay 4
	playsound $73
	asm15 scriptHelp.jewelHelper_createPuff, $01
	asm15 scriptHelp.jewelHelper_createPuff, $05
	asm15 scriptHelp.jewelHelper_createPuff, $03
	asm15 scriptHelp.jewelHelper_createPuff, $07
	setcounter1 $06
	playsound $67
	writememory $cfc0, $00
	asm15 scriptHelp.jewelHelper_createMoldorm
	playsound $73
	asm15 scriptHelp.jewelHelper_createPuff, $04
	asm15 scriptHelp.jewelHelper_createPuff, $00
	asm15 scriptHelp.jewelHelper_createPuff, $02
	asm15 scriptHelp.jewelHelper_createPuff, $06
	asm15 scriptHelp.jewelHelper_createPuff, $08
	setmusic $2d
	writememory $ccab, $00
	checkcfc0bit 0
	playsound $4d
	resetmusic
	createpuff
	delay 5
	disablemenu
	settilehere $f1
	orroomflag $40
	enablemenu
	scriptend


; ==================================================================================================
; INTERAC_KING_MOBLIN
; ==================================================================================================
kingMoblin_trapLinkInBombedHouse:
	writeobjectbyte Interaction.var37, $01
	setspeed $50
	settileat $16, $a2
	settileat $17, $a2
	settileat $18, $a2
	settileat $26, $a2
	settileat $27, $a2
	settileat $28, $a2
	asm15 scriptHelp.kingMoblin_func_61eb
	setcounter1 $50
	showtext TX_3804
	writeobjectbyte Interaction.var37, $00
	setangle $18
	setanimation $02
	applyspeed $16
	setcounter1 $06
	setangle $10
	setanimation $01
	applyspeed $30
	writememory $cfd1, $01
	scriptend


; ==================================================================================================
; INTERAC_IMPA
; ==================================================================================================
impaScript_askedToSaveZeldaButHavent_body:
	delay 11
	setspeed $28
	setangleandanimation $10
	applyspeed $20
	setcounter1 $06
	setangleandanimation $08
	applyspeed $40
	setcounter1 $06
	setangleandanimation $10
	applyspeed $14
	delay 6
	showtext TX_0500
	writeobjectbyte Interaction.zh, $00
	delay 6
	setangleandanimation $18
	applyspeed $10
	delay 3
	setangleandanimation $10
	applyspeed $58
	enableinput
	writeobjectbyte Interaction.visible, $00
	setglobalflag GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA
	scriptend


; ==================================================================================================
; INTERAC_DIN
; ==================================================================================================
dinScript_subid2Init_body:
	delay 8
	setspeed $28
	setangleandanimation $10
	applyspeed $0a
	writememory $cfc0, $01
	applyspeed $1b
	setcounter1 $06
	writememory $cfc0, $02
	setcounter1 $6e
	writememory $cfdf, $01
	scriptend

dinScript_subid4Init_body:
	setspeed $28
	setangleandanimation $00
	applyspeed $80
	setcounter1 $06
	setangleandanimation $18
	checkmemoryeq $cfc0, $02
	setanimation $07
	scriptend

dinScript_discoverLinkCollapsed_body:
	checkmemoryeq $d00f, $00
	delay 10
	setspeed $14
	movedown $3c
	delay 3
	writeobjectbyte Interaction.var38, $80
	asm15 scriptHelp.din_createExclamationMark, $1e
	delay 7
	callscript mainScripts.piratianScript_jump
	setcounter1 $06
	writeobjectbyte Interaction.var38, $01
	setspeed $28
	movedown $13
	writeobjectbyte Interaction.var38, $80
	delay 3
	writeobjectbyte Interaction.var38, $01
	delay 8
	setglobalflag GLOBALFLAG_SEASON_ALWAYS_SPRING
	orroomflag $40
	scriptend


; ==================================================================================================
; INTERAC_ZELDA_KIDNAPPED_ROOM
; ==================================================================================================
ZeldaBeingKidnappedEvent_body:
	disableinput
	writememory $ccab, $01
	delay 6
	setmusic $2d
	delay 6
	showtext TX_0504
	delay 6
	writememory $cfc0, $01
	setcounter1 $3e
	showtext TX_0505
	asm15 restartSound
	delay 6
	writememory $cfc0, $02
	setcounter1 $80
	playsound $c8
	delay 7
	writememory $cfc0, $03
	setcounter1 $02
	setmusic $2d
	enableinput
	checknoenemies
	delay 6
	disableinput
	asm15 restartSound
	delay 5
	playsound $c8
	delay 5
	playsound $c8
	delay 5
	playsound $c8
	delay 6
	writememory $cfc0, $04
	asm15 scriptHelp.playLinkCutscene2
	checkmemoryeq $d001, $00
	delay 6
	asm15 scriptHelp.forceLinkState8AndSetDirection, DIR_UP
	setmusic $39
	writememory $cfc0, $05
	setcounter1 $42
	showtext TX_0506
	writememory $cfc0, $06
	setcounter1 $24
	writememory $cfc0, $07
	delay 5
	asm15 scriptHelp.forceLinkState8AndSetDirection, DIR_LEFT
	setcounter1 $46
	showtext TX_0507
	asm15 scriptHelp.zeldaKidnappedRoom_loadImpa
	writememory $cfc0, $08
	delay 7
	writememory $cfc0, $09
	asm15 scriptHelp.forceLinkState8AndSetDirection, DIR_DOWN
	setcounter1 $32
	showtext TX_0508
	writememory $cfc0, $0a
	delay 6
	showtext TX_0509
	delay 3
	asm15 scriptHelp.linkedScript_giveRing, BLUE_JOY_RING
	delay 6
	showtext TX_050a
	delay 6
	writememory $cfc0, $0b
	setcounter1 $40
	resetmusic
	setglobalflag GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	writememory $ccab, $0
	enableinput
	scriptend


; ==================================================================================================
; INTERAC_GET_ROD_OF_SEASONS
; ==================================================================================================
gettingRodOfSeasons_body:
	setcoords $40, $50
	setcollisionradii $02, $04
	checkcollidedwithlink_onground
	disableinput
	asm15 seasonsInteractionsBank15.spawnRodOfSeasonsSparkles
	setcounter1 $82

	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	delay 5

	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	delay 5

	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	checkpalettefadedone
	delay 5

	spawninteraction INTERAC_GET_ROD_OF_SEASONS, $02, $38, $50
	asm15 fadeinFromWhiteWithDelay, $04
	checkpalettefadedone
	checkflagset $00, $cceb
	asm15 seasonsInteractionsBank15.forceLinksDirection, DIR_DOWN
	delay $07

	showtext TX_0810
	setmusic SNDCTRL_MEDIUM_FADEOUT
	delay $09

	resetmusic
	enableinput
	scriptend
