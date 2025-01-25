; Scripts for interactions are in this file. You may want to cross-reference with the corresponding
; assembly code to get the full picture (run "git grep INTERAC_X" to search for its code).

.include "scripts/common/commonScripts.s"

; ==================================================================================================
; INTERAC_DUNGEON_SCRIPT
; ==================================================================================================
.include "scripts/seasons/dungeonScripts.s"


; ==================================================================================================
; INTERAC_GNARLED_KEYHOLE
; ==================================================================================================
gnarledKeyholeScript:
	checkcfc0bit 0
	disableinput
	setmusic SNDCTRL_STOPMUSIC
	wait 60
	shakescreen 120
	wait 60
	orroomflag $80
	incstate
	scriptend


; ==================================================================================================
; INTERAC_MAKU_CUTSCENES
; ==================================================================================================
makuTreeScript_remoteCutscene:
	disableinput
	orroomflag $40
makuTreeScript_remoteCutsceneDontSetRoomFlag:
	writememory $cbae, $04
	setmusic MUS_MAKU_TREE
	wait 40
	asm15 hideStatusBar
	asm15 scriptHelp.seasonsFunc_15_571a, $02
	checkpalettefadedone
	spawninteraction INTERAC_MAKU_LEAF, $00, $40, $50
	wait 240
	wait 60
	callscript script4e25
	asm15 showStatusBar
	asm15 clearFadingPalettes
	asm15 fadeinFromWhiteWithDelay, $02
	checkpalettefadedone
	resetmusic
	enableinput
	asm15 scriptHelp.seasonsFunc_15_576c
	scriptend
script4e25:
	jumptable_objectbyte Interaction.subid
	.dw @outsideDungeon1
	.dw @outsideDungeon2
	.dw @outsideDungeon3
	.dw @outsideDungeon4
	.dw @outsideDungeon5
	.dw @outsideDungeon6
	.dw @outsideDungeon7
	.dw @outsideDungeon8
	.dw @outsideWinterTemple
	.dw script4e83
	.dw @outsideDungeon8
@outsideDungeon1:
	asm15 scriptHelp.seasonsFunc_15_5735, <TX_1704
	retscript
@outsideDungeon2:
	asm15 scriptHelp.seasonsFunc_15_5735, <TX_1707
	retscript
@outsideDungeon3:
	asm15 scriptHelp.seasonsFunc_15_5735, <TX_1709 ; / TX_1724
	retscript
@outsideDungeon4:
	asm15 scriptHelp.seasonsFunc_15_5744
	jumpifobjectbyteeq Interaction.var3f, $01, @@dungeon5AfterDungeon4
	asm15 scriptHelp.seasonsFunc_15_5735, <TX_170b
	retscript
@@dungeon5AfterDungeon4:
	asm15 scriptHelp.seasonsFunc_15_5735, <TX_1710
	retscript
@outsideDungeon5:
	asm15 scriptHelp.seasonsFunc_15_5748
	jumpifobjectbyteeq Interaction.var3f, $01, @@dungeon5AfterDungeon4
	asm15 scriptHelp.seasonsFunc_15_5735, <TX_170d
	retscript
@@dungeon5AfterDungeon4:
	asm15 scriptHelp.seasonsFunc_15_5735, <TX_170f
	retscript
@outsideDungeon6:
	asm15 scriptHelp.seasonsFunc_15_5735, <TX_1712
	retscript
@outsideDungeon7:
	asm15 scriptHelp.seasonsFunc_15_5735, <TX_1714
	retscript
@outsideDungeon8:
	asm15 scriptHelp.seasonsFunc_15_5735, <TX_1716
	retscript
@outsideWinterTemple:
	showtext TX_1736
	retscript
script4e83: ; twinrova is behind onox
	showtext TX_5007
	retscript


makuTreeScript_gateHit:
	setcollisionradii $14, $20
@checkLinkHitGateWithSword:
	asm15 scriptHelp.makuTree_checkGateHit
	jumptable_memoryaddress $cfc0
	.dw @checkLinkHitGateWithSword
	.dw @gateHit
@gateHit:
	giveitem ITEM_SWORD, $03
	disableinput
	wait 60
	incstate
	orroomflag $80
	checkobjectbyteeq Interaction.state, $01
	playsound SND_SOLVEPUZZLE
	wait 60
	enableinput
	scriptend
	
	
; ==================================================================================================
; INTERAC_SEASON_SPIRITS_SCRIPTS
; ==================================================================================================
seasonsSpiritsScript_enteringTempleArea:
	loadscript scripts2.seasonsSpirits_enteringTempleCutscene
	
seasonsSpiritsScript_winterTempleOrbBridge:
	loadscript scripts2.seasonsSpirits_createBridgeOnOrbHit
	
seasonsSpiritsScript_spiritStatue:
	jumpifroomflagset $40, seasonsSpiritsScript_seasonsGotten
	jumpifitemobtained TREASURE_ROD_OF_SEASONS, @haveRodOfSeasons
	setcoords $28, $70
	setcollisionradii $04, $10
	makeabuttonsensitive
-
	; no rod of seasons
	checkabutton
	disableinput
	writememory $cfc0, $00
	asm15 scriptHelp.spawnSeasonsSpiritSubId01
	xorcfc0bit 0
	playsound SND_CIRCLING
	checkcfc0bit 1
	wait 40
	showtextlowindex <TX_0811
	wait 8
	xorcfc0bit 2
	wait 30
	enableinput
	scriptjump -
@haveRodOfSeasons:
	setcollisionradii $08, $04
	checkcollidedwithlink_onground
	disableinput
	asm15 scriptHelp.spawnSeasonsSpiritSubId00
	xorcfc0bit 0
	playsound SND_CIRCLING
	checkcfc0bit 1
	callscript seasonsSpiritsScript_showIntroText
	asm15 scriptHelp.seasonsSpirit_createSwirl
	wait 10
	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	wait 20
	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	wait 20
	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	checkpalettefadedone
	xorcfc0bit 2
	wait 20
	asm15 fadeinFromWhiteWithDelay, $04
	checkpalettefadedone
	callscript seasonsSpiritsScript_imbueSeason
	asm15 scriptHelp.seasonsSpirits_checkPostSeasonGetText
	jumptable_objectbyte $7f
	.dw @@notAllSeasonsGotten
	.dw @@allSeasonsGotten_nonAutumnText
	.dw @@allSeasonsGotten_autumnText
@@allSeasonsGotten_nonAutumnText:
	wait 30
	showtextlowindex <TX_080e
	scriptjump @@notAllSeasonsGotten
@@allSeasonsGotten_autumnText:
	wait 30
	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE2
	showtextlowindex <TX_080f
@@notAllSeasonsGotten:
	orroomflag $40
	enableinput
seasonsSpiritsScript_seasonsGotten:
	setcoords $28, $70
	setcollisionradii $04, $10
	makeabuttonsensitive
-
	checkabutton
	disableinput
	writememory $cfc0, $00
	asm15 scriptHelp.spawnSeasonsSpiritSubId01
	xorcfc0bit 0
	playsound SND_CIRCLING
	checkcfc0bit 1
	wait 40
	callscript seasonsSpirits_postSeasonGetText
	wait 8
	xorcfc0bit 2
	wait 30
	enableinput
	scriptjump -

seasonsSpirits_postSeasonGetText:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, seasonsSpirits_lastTextGameFinished
	jumpifobjectbyteeq $7e, $01, seasonsSpirits_lastTextSaveZeldaText
	jumptable_objectbyte $43
	.dw @spring
	.dw @summer
	.dw @autumn
	.dw @winter
@spring:
	showtextlowindex <TX_0809
	retscript
@summer:
	showtextlowindex <TX_0807
	retscript
@autumn:
	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE2
	showtextlowindex <TX_080b
	retscript
@winter:
	showtextlowindex <TX_0805
	retscript

seasonsSpirits_lastTextGameFinished:
	jumptable_objectbyte $43
	.dw @spring
	.dw @summer
	.dw @autumn
	.dw @winter
@spring:
	showtextlowindex <TX_0818
	retscript
@summer:
	showtextlowindex <TX_0819
	retscript
@autumn:
	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE2
	showtextlowindex <TX_081a
	retscript
@winter:
	showtextlowindex <TX_081b
	retscript
	
seasonsSpirits_lastTextSaveZeldaText:
	jumptable_objectbyte $43
	.dw script4f80
	.dw script4f83
	.dw script4f86
	.dw script4f8d
script4f80:
	showtextlowindex <TX_0814
	retscript
script4f83:
	showtextlowindex <TX_0815
	retscript
script4f86:
	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE2
	showtextlowindex <TX_0816
	retscript
script4f8d:
	showtextlowindex <TX_0817
	retscript

seasonsSpiritsScript_showIntroText:
	jumptable_objectbyte $43
	.dw @spring
	.dw @summer
	.dw @autumn
	.dw @winter
@spring:
	showtextlowindex <TX_0808
	retscript
@summer:
	showtextlowindex <TX_0806
	retscript
@autumn:
	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE2
	showtextlowindex <TX_080a
	retscript
@winter:
	showtextlowindex <TX_0804
	retscript

seasonsSpiritsScript_imbueSeason:
	jumptable_objectbyte $43
	.dw @spring
	.dw @summer
	.dw @autumn
	.dw @winter
@spring:
	giveitem TREASURE_ROD_OF_SEASONS, $02
	retscript
@summer:
	giveitem TREASURE_ROD_OF_SEASONS, $03
	retscript
@autumn:
	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE2
	giveitem TREASURE_ROD_OF_SEASONS, $04
	retscript
@winter:
	giveitem TREASURE_ROD_OF_SEASONS, $05
	retscript


; ==================================================================================================
; INTERAC_MAYORS_HOUSE_NPC
; ==================================================================================================
mayorsScript:
	initcollisions
-
	enableinput
	checkabutton
	disableinput
	jumpifroomflagset $20, +
	showtext TX_310b
	wait 20
	giveitem TREASURE_GASHA_SEED, $04
	scriptjump ++
+
; unused?
	showtextlowindex $31
	scriptend
; unused?
	scriptjump -
++
	wait 20
	showtext TX_310c
	scriptjump -


mayorsHouseLadyScript:
	initcollisions
@waitUntilTalkedTo:
	enableinput
	checkabutton
	disableinput
	jumpifglobalflagset GLOBALFLAG_DONE_RUUL_SECRET, @doneSecret
	showtext TX_3102
	jumpiftextoptioneq $00, @answeredYes
	wait 20
	showtext TX_3103
	scriptjump @waitUntilTalkedTo
@wrongSecret:
	wait 20
	showtext TX_3104
	scriptjump @waitUntilTalkedTo
@answeredYes:
	askforsecret RUUL_SECRET
	wait 20
	jumptable_memoryaddress $cca3
	.dw @correctSecret
	.dw @wrongSecret
@correctSecret:
	showtext TX_3105
	wait 20
	jumpifitemobtained TREASURE_RING_BOX, @upgradeRingbox
	showtext TX_3109
	wait 20
	giveitem TREASURE_RING_BOX, $03
	scriptjump @provideReturnSecret
@upgradeRingbox:
	showtext TX_3108
	wait 20
	asm15 scriptHelp.getNextRingboxLevel
	jumpifmemoryeq wTextNumberSubstitution, $05, @upgradeTo5
	giveitem TREASURE_RING_BOX, $01
	scriptjump @provideReturnSecret
@upgradeTo5:
	giveitem TREASURE_RING_BOX, $02
@provideReturnSecret:
	wait 20
@doneSecret:
	generatesecret RUUL_RETURN_SECRET
-
	showtext TX_3106
	wait 20
	jumpiftextoptioneq $01, -
	setglobalflag GLOBALFLAG_DONE_RUUL_SECRET
	showtext TX_3107
	scriptjump @waitUntilTalkedTo

	
; ==================================================================================================
; INTERAC_MRS_RUUL
; ==================================================================================================
mrsRuulScript:
	initcollisions
	jumpifroomflagset $40, @gaveDoll
-
	checkabutton
	showtext TX_0b1a
	jumpiftradeitemeq $02, @hasDoll
	scriptjump -
@hasDoll:
	disableinput
	wait 30
-
	showtext TX_0b1b
	jumpiftextoptioneq $00, @givingDoll
	wait 30
	showtext TX_0b1e
	enableinput
	checkabutton
	disableinput
	scriptjump -
@givingDoll:
	wait 30
	showtext TX_0b1c
	giveitem TREASURE_TRADEITEM, $03
	orroomflag $40
	enableinput
@gaveDoll:
	checkabutton
	showtext TX_0b1d
	scriptjump @gaveDoll
	

; ==================================================================================================
; INTERAC_MR_WRITE
; ==================================================================================================
mrWriteScript:
	setcollisionradii $0a, $06
	makeabuttonsensitive
	jumpifroomflagset $40, @alreadyLitTorch
-
	jumptable_memoryaddress wNumTorchesLit
	.dw @unlitTorch
	.dw @litTorch
@unlitTorch:
	jumpifobjectbyteeq $71, $00, -
	writeobjectbyte $71, $00
	showtext TX_0b00
	scriptjump -
@litTorch:
	disableinput
	wait 40
	showtext TX_0b01
	giveitem TREASURE_TRADEITEM, $00
	orroomflag $40
	enableinput
@alreadyLitTorch:
	checkabutton
	disableinput
	writeobjectbyte $73, $0b
	getrandombits $72, $0f
	addobjectbyte $72, $02
	showloadedtext
	enableinput
	scriptjump @alreadyLitTorch
	
	
; ==================================================================================================
; INTERAC_FICKLE_LADY
; ==================================================================================================
fickleLadyScript_text1:
	rungenericnpc TX_1600
fickleLadyScript_text2:
	rungenericnpc TX_1602
fickleLadyScript_text3:
	rungenericnpc TX_1603
fickleLadyScript_text4:
	rungenericnpc TX_1604
fickleLadyScript_text5:
	rungenericnpc TX_1605
fickleLadyScript_text6:
	rungenericnpc TX_1606
fickleLadyScript_text7:
	rungenericnpc TX_1607
	
	
; ==================================================================================================
; INTERAC_MALON
; ==================================================================================================
malonScript:
	initcollisions
	jumpifroomflagset $40, @gaveCuccodex
-
	checkabutton
	showtext TX_0b12
	jumpiftradeitemeq $00, @haveCuccodex
	scriptjump -
@haveCuccodex:
	disableinput
	wait 30
-
	showtext TX_0b13
	jumpiftextoptioneq $00, @givingCuccodex
	wait 30
	showtext TX_0b16
	enableinput
	checkabutton
	disableinput
	scriptjump -
@givingCuccodex:
	wait 30
	showtext TX_0b14
	giveitem TREASURE_TRADEITEM, $01
	orroomflag $40
	enableinput
@gaveCuccodex:
	asm15 scriptHelp.checkTalonReturned
	jumptable_objectbyte $7c
	.dw @talonNotReturned
	.dw @talonReturned
@talonNotReturned:
	checkabutton
	showtext TX_0b15
	scriptjump @talonNotReturned
@talonReturned:
	spawninteraction INTERAC_TALON, $01, $68, $78
-
	checkabutton
	showtext TX_0b17
	scriptjump -
	
	
; ==================================================================================================
; INTERAC_BATHING_SUBROSIANS
; ==================================================================================================
bathingSubrosianScript_text1:
	writeobjectbyte $5c, $01
	rungenericnpc TX_3e05
	
bathingSubrosianScript_stub:
	wait 240
	scriptjump bathingSubrosianScript_stub
	
bathingSubrosianScript_2:
	writeobjectbyte $5c, $01
-
	wait 240
	scriptjump -

bathingSubrosianScript_text3:
	rungenericnpc TX_3e07
	
	
; ==================================================================================================
; INTERAC_MASTER_DIVERS_SON
; ==================================================================================================
masterDiversSonScript:
	settextid TX_1903
	jumpifglobalflagset GLOBALFLAG_MOBLINS_KEEP_DESTROYED, @commonInit
	settextid TX_1900
@commonInit:
	initcollisions
@commonInitShowText:
	checkabutton
	setdisabledobjectsto11
	cplinkx $49
	setanimationfromobjectbyte $49
	showloadedtext
	enableallobjects
	scriptjump @commonInitShowText
	
masterDiversSonScript_4thEssenceGotten:
	jumpifglobalflagset GLOBALFLAG_MOBLINS_KEEP_DESTROYED, @moblinKeepDestroyed
	initcollisions
-
	settextid TX_1901
	scriptjump masterDiversSonScript@commonInitShowText
@moblinKeepDestroyed:
	setcoords $58, $38
	initcollisions
	settextid TX_1903
	checkabutton
	setdisabledobjectsto11
	cplinkx $49
	setanimationfromobjectbyte $49
	showloadedtext
	enableallobjects
	scriptjump -
	
masterDiversSonScript_8thEssenceGotten:
	settextid TX_1902
	scriptjump masterDiversSonScript@commonInit
	
masterDiversSonScript_ZeldaKidnapped:
	settextid TX_1904
	scriptjump masterDiversSonScript@commonInit
	
masterDiversSonScript_gameFinished:
	settextid TX_1905
	scriptjump masterDiversSonScript@commonInit
	

; ==================================================================================================
; INTERAC_FICKLE_MAN
; ==================================================================================================
ficklManScript_text1:
	rungenericnpc TX_0f00
ficklManScript_text2:
	rungenericnpc TX_0f01
ficklManScript_text3:
	rungenericnpc TX_0f03
ficklManScript_text4:
	rungenericnpc TX_0f02
ficklManScript_text5:
	rungenericnpc TX_0f04
ficklManScript_text6:
	rungenericnpc TX_0f05
ficklManScript_text7:
	rungenericnpc TX_0f06
ficklManScript_text8:
	rungenericnpc TX_0f07
ficklManScript_text9:
	rungenericnpc TX_0f08
ficklManScript_textA:
	writeobjectbyte $5c, $02
	rungenericnpc TX_0e21
	
	
; ==================================================================================================
; INTERAC_DUNGEON_WISE_OLD_MAN
; ==================================================================================================
dungeonWiseOldManScript:
	initcollisions
-
	checkabutton
	showloadedtext
	asm15 scriptHelp.dungeonWiseOldMan_setLinksInvincibilityCounterTo0
	scriptjump -
	

; ==================================================================================================
; INTERAC_TREASURE_HUNTER
; ==================================================================================================
treasureHunterScript_text1:
	rungenericnpc TX_1b00
treasureHunterScript_text2:
	rungenericnpc TX_1b01
treasureHunterScript_text3:
	rungenericnpc TX_1b02
treasureHunterScript_text4:
	rungenericnpc TX_1b03
	
	
; ==================================================================================================
; INTERAC_OLD_LADY_FARMER
; ==================================================================================================
oldLadyFarmerScript_text1:
	rungenericnpc TX_1200
	
oldLadyFarmerScript_text2:
	initcollisions
-
	checkabutton
	setdisabledobjectsto91
	showtext TX_1201
	jumpiftextoptioneq $01, @answeredYes
	wait 30
	showtext TX_1202
	scriptjump @answeredNo
@answeredYes:
	wait 30
	showtext TX_1203
@answeredNo:
	enableallobjects
	scriptjump -
	
oldLadyFarmerScript_text3:
	rungenericnpc TX_1204
	
oldLadyFarmerScript_text4:
	rungenericnpc TX_1205
	
oldLadyFarmerScript_text5:
	rungenericnpc TX_1206
	
oldLadyFarmerScript_text6:
	rungenericnpc TX_1206
	
oldLadyFarmerScript_text7:
	rungenericnpc TX_1208
	

; ==================================================================================================
; INTERAC_FOUNTAIN_OLD_MAN
; ==================================================================================================
fountainOldManScript_text1:
	settextid TX_1000
	jumpifmemoryeq wIsLinkedGame, $01, fountainOldManScript_text2
fountainOldManScript_showText:
	setcollisionradii $03, $0b
	makeabuttonsensitive
-
	checkabutton
	showloadedtext
	scriptjump -
	
fountainOldManScript_text2:
	settextid TX_1001
	scriptjump fountainOldManScript_showText
	
fountainOldManScript_text3:
	settextid TX_1002
	scriptjump fountainOldManScript_showText
	
fountainOldManScript_text4:
	settextid TX_1003
	scriptjump fountainOldManScript_showText
	
fountainOldManScript_text5:
	settextid TX_1004
	scriptjump fountainOldManScript_showText
	
fountainOldManScript_text6:
	settextid TX_1005
	scriptjump fountainOldManScript_showText
	
fountainOldManScript_text7:
	settextid TX_1006
	scriptjump fountainOldManScript_showText
	
fountainOldManScript_text8:
	settextid TX_1007
	scriptjump fountainOldManScript_showText
	
fountainOldManScript_text9:
	settextid TX_1008
	scriptjump fountainOldManScript_showText
	
fountainOldManScript_textA:
	settextid TX_1009
	scriptjump fountainOldManScript_showText
	
	
; ==================================================================================================
; INTERAC_TICK_TOCK
; ==================================================================================================
tickTockScript:
	setcollisionradii $0f, $06
	makeabuttonsensitive
	jumpifroomflagset $40, @gaveEngineGrease
-
	checkabutton
	showtext TX_0b43
	jumpiftradeitemeq $09, @haveEngineGrease
	scriptjump -
@haveEngineGrease:
	disableinput
	wait 30
-
	showtext TX_0b44
	jumpiftextoptioneq $00, @givingEngineGrease
	wait 30
	showtext TX_0b47
	enableinput
	checkabutton
	disableinput
	scriptjump -
@givingEngineGrease:
	wait 30
	showtext TX_0b45
	giveitem TREASURE_TRADEITEM, $0a
	orroomflag $40
	enableinput
@gaveEngineGrease:
	checkabutton
	showtext TX_0b46
	scriptjump @gaveEngineGrease
	
	
; ==================================================================================================
; INTERAC_MITTENS
; ==================================================================================================
mittensScript:
	rungenericnpclowindex <TX_0b34
	
	
; ==================================================================================================
; INTERAC_MITTENS_OWNER
; ==================================================================================================
mittensOwnerScript:
	initcollisions
	jumpifroomflagset $40, @mittensCameDown
-
	checkabutton
	disableinput
	showtextlowindex <TX_0b31
	jumpiftradeitemeq $06, @hasFish
	enableinput
	scriptjump -
@hasFish:
	wait 30
-
	showtextlowindex <TX_0b32
	jumpiftextoptioneq $00, @givingFish
	wait 30
	showtextlowindex <TX_0b37
	enableinput
	checkabutton
	disableinput
	scriptjump -
@givingFish:
	wait 30
	writememory $cfde, $00
	spawninteraction INTERAC_TRADE_ITEM, $06, $44, $68
	showtextlowindex <TX_0b33
	ormemory $cceb, $01
	showtextlowindex <TX_0b34
	setcounter1 $20
	setanimation $02
	writememory $cfde, $40
	showtextlowindex <TX_0b35
	giveitem TREASURE_TRADEITEM, $07
	orroomflag $40
	enableinput
@mittensCameDown:
	checkabutton
	showtextlowindex <TX_0b36
	scriptjump @mittensCameDown


; ==================================================================================================
; INTERAC_SOKRA
; ==================================================================================================
sokraScript_inVillage:
	initcollisions
	jumpifitemobtained TREASURE_ROD_OF_SEASONS, @haveRodOfSeasons
	jumpifroomflagset $40, @alreadyInformed
-
	wait 1
	jumpifobjectbyteeq $77, $01, @canDoEvent
	jumpifobjectbyteeq $71, $00, @sleeping
	writeobjectbyte $71, $00
	showtextlowindex <TX_5202
@sleeping:
	asm15 createSokraSnore
	scriptjump -
@canDoEvent:
	disableinput
	asm15 scriptHelp.sokra_alert
	playsound SND_CLINK
	setcounter1 $40
	setcollisionradii $00, $00
	setanimation $06
	setspeed SPEED_100
	setangle $18
	applyspeed $10
	wait 10
	setangle $10
-
	wait 1
	asm15 scriptHelp.villageSokra_waitUntilLinkInPosition
	jumpifobjectbyteeq $76, $00, -
	wait 20
	writememory $d008, $00
	showtextlowindex <TX_5200
	wait 20
	setangle $00
	setanimation $07
-
	wait 1
	asm15 scriptHelp.seasonsFunc_15_5812, $28
	jumpifobjectbyteeq $76, $01, -
	setangle $08
	applyspeed $10
	orroomflag $40
	setcollisionradii $06, $06
	setanimation $06
	wait 20
	setanimation $04
	wait 30
	enableinput
	wait 30
	setanimation $00
@alreadyInformed:
	wait 1
	asm15 createSokraSnore
	jumpifobjectbyteeq $71, $00, @alreadyInformed
	writeobjectbyte $71, $00
	showtextlowindex <TX_5202
	scriptjump @alreadyInformed
@haveRodOfSeasons:
	setanimation $02
	writeobjectbyte $43, $01
	asm15 scriptHelp.villageSokra_checkStageInGame
	jumptable_memoryaddress $cfc0
	.dw @noEssences
	.dw @firstEssenceGotten
	.dw @ZeldaTaken
@noEssences:
	rungenericnpclowindex <TX_5201
@firstEssenceGotten:
	rungenericnpclowindex <TX_5203
@ZeldaTaken:
	rungenericnpclowindex <TX_520a
	
sokraScript_easternSuburbsPortal:
	jumpifobjectbyteeq $77, $01, @canDoEvent
	wait 1
	asm15 createSokraSnore
	scriptjump sokraScript_easternSuburbsPortal
@canDoEvent:
	disableinput
	asm15 scriptHelp.sokra_alert
	playsound SND_CLINK
	setcounter1 $40
	showtextlowindex <TX_5204
	wait 40
	setanimation $06
	setspeed SPEED_100
	setangle ANGLE_DOWN
-
	wait 1
	asm15 scriptHelp.suburbsSokra_jumpOffStump
	jumpifobjectbyteeq $4f, $00, @moveLeft
	scriptjump -
@moveLeft:
	wait 30
	setangle ANGLE_LEFT
	applyspeed $24
	wait 10
	asm15 scriptHelp.seasonsFunc_15_5840
-
	wait 1
	asm15 scriptHelp.seasonsFunc_15_5802
	jumpifobjectbyteeq $76, $00, -
	wait 20
	writememory $d008, $01
	showtextlowindex <TX_5205
-
	wait 20
	showtextlowindex <TX_5206
	jumpiftextoptioneq $01, -
	wait 20
	showtextlowindex <TX_5207
	setangle $10
	setanimation $06
	setspeed SPEED_100
-
	wait 1
	asm15 scriptHelp.seasonsFunc_15_5812, $88
	jumpifobjectbyteeq $76, $01, -
	enableinput
	orroomflag $40
	scriptend
	
sokraScript_needSummerForD3:
	initcollisions
	settextid TX_5208
	checkabutton
	disableinput
	callscript @displayText
	settextid TX_5209
-
	enableinput
	checkabutton
	disableinput
	callscript @displayText
	scriptjump -
@displayText:
	cplinkx $48
	addobjectbyte $48, $08
	setanimationfromobjectbyte $48
	wait 60
	showloadedtext
	wait 30
	addobjectbyte $48, $f8
	setanimationfromobjectbyte $48
	retscript
	

; ==================================================================================================
; INTERAC_BIPIN
; ==================================================================================================

; Running around when baby just born
bipinScript0:
	setcollisionradii $06, $06
	makeabuttonsensitive
@loop:
	checkabutton
	jumpifmemoryeq wChildStatus, $00, @stillUnnamed
	showtext TX_4301
	scriptjump @loop
@stillUnnamed:
	showtext TX_4300
	scriptjump @loop


; Bipin gives you a random tip
bipinScript1:
	initcollisions
@loop:
	checkabutton
	setdisabledobjectsto91
	setanimation $02
	asm15 scriptHelp.bipin_showText_subid1To9
	wait 30
	callscript bipinSayRandomTip
	enableallobjects
	scriptjump @loop


; Bipin just moved to Labrynna/Holodrum?
bipinScript2:
	initcollisions
@loop:
	checkabutton
	setdisabledobjectsto91
	asm15 scriptHelp.bipin_showText_subid1To9
	enableallobjects
	scriptjump @loop

bipinSayRandomTip:
	; Show a random text index from TX_4309-TX_4310
	writeobjectbyte  Interaction.textID+1, >TX_4300
	getrandombits    Interaction.textID,   $07
	addobjectbyte    Interaction.textID,   <TX_4309
	showloadedtext

	setanimation $03
	retscript


.ifdef ROM_AGES
; "Past" version of Bipin who gives you a gasha seed
bipinScript3:
	loadscript scriptHelp.bipinScript3
.endif


; ==================================================================================================
; INTERAC_BIRD
; ==================================================================================================
knowItAllBirdScript:
	setcollisionradii $08, $08
	makeabuttonsensitive
@loop:
	checkabutton
	setdisabledobjectsto91
	cplinkx Interaction.direction
	writeobjectbyte Interaction.var37, $01 ; Signal to start spazzing out
	showloadedtext
	jumpiftextoptioneq $01, @doneTalking

	wait 30
	addobjectbyte Interaction.textID, $0a
	showloadedtext
	addobjectbyte Interaction.textID, -$0a

@doneTalking:
	enableallobjects
	writeobjectbyte Interaction.var37, $00
	scriptjump @loop


panickingBirdScript:
	setcollisionradii $06, $06
	makeabuttonsensitive
@loop:
	checkabutton
	setdisabledobjectsto11
	cplinkx Interaction.direction
	writeobjectbyte Interaction.var37, $01 ; Signal to start spazzing out
	showtext TX_0503
	writeobjectbyte $77, $00
	enableallobjects
	scriptjump @loop


; ==================================================================================================
; INTERAC_BLOSSOM
; ==================================================================================================

; Blossom asking you to name her child
blossomScript0:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $00
	jumpifobjectbyteeq Interaction.var3b, $01, @nameAlreadyGiven
@loop:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_4400

@askForName:
	asm15 scriptHelp.blossom_openNameEntryMenu
	wait 30
	jumptable_memoryaddress wTextInputResult
	.dw @validName
	.dw @invalidName

@invalidName:
	showtextlowindex <TX_440a
	enableinput
	scriptjump @loop

@validName:
	showtextlowindex <TX_4407
	disableinput
	jumptable_memoryaddress wSelectedTextOption
	.dw @nameConfirmed
	.dw @askForName

@nameConfirmed:
	asm15 scriptHelp.blossom_decideInitialChildStatus
	asm15 scriptHelp.setc6e2Bit, $00
	asm15 scriptHelp.setNextChildStage, $01
	wait 30
	showtextlowindex <TX_4408
	enableinput

@nameAlreadyGiven:
	checkabutton
	showtextlowindex <TX_4409
	scriptjump @nameAlreadyGiven


; Blossom asking for money to see a doctor
blossomScript1:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $01
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyGaveMoney
@loop:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_440b
	jumptable_memoryaddress wSelectedTextOption
	.dw @selectedYes
	.dw @selectedNo
@selectedYes:
	wait 30
	showtextlowindex <TX_440c
	jumptable_memoryaddress wSelectedTextOption
	.dw @give150Rupees
	.dw @give50Rupees
	.dw @give10Rupees
	.dw @give1Rupee

@give150Rupees:
	asm15 scriptHelp.blossom_checkHasRupees, RUPEEVAL_150
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_150
	asm15 scriptHelp.blossom_addValueToChildStatus, $08
	asm15 scriptHelp.setc6e2Bit, $01
	asm15 scriptHelp.setNextChildStage, $02
	enableallobjects
@gave150RupeesLoop:
	showtextlowindex <TX_440d
	checkabutton
	scriptjump @gave150RupeesLoop

@give50Rupees:
	asm15 scriptHelp.blossom_checkHasRupees, RUPEEVAL_050
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_050
	asm15 scriptHelp.blossom_addValueToChildStatus, $05
	asm15 scriptHelp.setc6e2Bit, $01
	asm15 scriptHelp.setNextChildStage, $02
	enableallobjects
@gave50RupeesLoop:
	showtextlowindex <TX_440e
	checkabutton
	scriptjump @gave50RupeesLoop

@give10Rupees:
	asm15 scriptHelp.blossom_checkHasRupees, RUPEEVAL_010
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_010
	asm15 scriptHelp.blossom_addValueToChildStatus, $02
	asm15 scriptHelp.setc6e2Bit, $01
	asm15 scriptHelp.setNextChildStage, $02
	enableallobjects
@gave10RupeesLoop:
	showtextlowindex <TX_440f
	checkabutton
	scriptjump @gave10RupeesLoop

@give1Rupee:
	asm15 scriptHelp.blossom_checkHasRupees, RUPEEVAL_001
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_001
	asm15 scriptHelp.setc6e2Bit, $01
	asm15 scriptHelp.setNextChildStage, $02
	enableallobjects
@gave1RupeeLoop:
	showtextlowindex <TX_4410
	checkabutton
	scriptjump @gave1RupeeLoop

@notEnoughRupees:
	wait 30
	showtextlowindex <TX_4432
	enableallobjects
	scriptjump @loop

@selectedNo:
	wait 30
	showtextlowindex <TX_4411
	enableallobjects
	scriptjump @loop

@alreadyGaveMoney:
	checkabutton
	showtextlowindex <TX_4431
	scriptjump @alreadyGaveMoney


; Blossom tells you that the baby has gotten better
blossomScript2:
	initcollisions
script4e08:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_4412
	asm15 scriptHelp.setNextChildStage, $03
	enableallobjects
	scriptjump script4e08


; Blossom asks you how to get the baby to sleep
blossomScript3:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $02
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyGaveAdvice
	checkabutton

	setdisabledobjectsto91
	showtextlowindex <TX_4413

	asm15 scriptHelp.setc6e2Bit, $02
	asm15 scriptHelp.setNextChildStage, $04

	jumptable_memoryaddress wSelectedTextOption
	.dw @sing
	.dw @play

@sing:
	wait 30
	showtextlowindex <TX_4414
	enableallobjects
	scriptjump @alreadyGaveAdvice
@play:
	wait 30
	showtextlowindex <TX_4415
	asm15 scriptHelp.blossom_addValueToChildStatus, $0a
	enableallobjects

@alreadyGaveAdvice:
	checkabutton
	showtextlowindex <TX_4416
	scriptjump @alreadyGaveAdvice


; Blossom tells you that the child has grown
blossomScript4:
	rungenericnpclowindex <TX_4417


; Blossom says "we meet again" (linked file?)
blossomScript5:
	rungenericnpclowindex <TX_4418


; Blossom asks Link what he was like when he was a kid. (var03 is set to the child's
; current personality.)
blossomScript6:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $03
	jumptable_objectbyte Interaction.var03
	.dw @hyperactive
	.dw @shy
	.dw @curious

@hyperactive:
	jumpifobjectbyteeq Interaction.var3b, $01, @hyperactiveResponseReceived

@hyperactiveLoop1:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_4419
	callscript @askAboutLinksBehaviour
	enableallobjects
	jumpifobjectbyteeq Interaction.var3a, $00, @hyperactiveLoop1

@hyperactiveResponseReceived:
	checkabutton
	showtextlowindex <TX_4422
	scriptjump @hyperactiveResponseReceived


@shy:
	jumpifobjectbyteeq Interaction.var3b, $01, @shyReponseReceived

@shyLoop1:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_441a
	callscript @askAboutLinksBehaviour
	enableallobjects
	jumpifobjectbyteeq Interaction.var3a, $00, @shyLoop1

@shyReponseReceived:
	checkabutton
	showtextlowindex <TX_4423
	scriptjump @shyReponseReceived


@curious:
	jumpifobjectbyteeq Interaction.var3b, $01, @curiousResponseReceived

@curiousLoop1:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_441b
	callscript @askAboutLinksBehaviour
	enableallobjects
	jumpifobjectbyteeq Interaction.var3a, $00, @curiousLoop1

@curiousResponseReceived:
	checkabutton
	showtextlowindex <TX_4424
	scriptjump @curiousResponseReceived


; Blossom asks about how Link was as a child. She asks a few things before giving up.
; If Link said yes to something, var3a will be set to 1, indicating to the script that she
; got a response.
@askAboutLinksBehaviour:
	jumptable_memoryaddress wSelectedTextOption
	.dw @selectedYes_1
	.dw @selectedNo_1

@selectedYes_1:
	wait 30
	showtextlowindex <TX_441c
	asm15 scriptHelp.setc6e2Bit, $03
	writeobjectbyte Interaction.var3a, $01
	asm15 scriptHelp.blossom_addValueToChildStatus, $08
	retscript

@selectedNo_1: ; Quiet, perhaps?
	wait 30
	showtextlowindex <TX_441d
	jumptable_memoryaddress wSelectedTextOption
	.dw @selectedYes_2
	.dw @selectedNo_2

@selectedYes_2:
	wait 30
	showtextlowindex <TX_441e
	asm15 scriptHelp.setc6e2Bit, $03
	writeobjectbyte Interaction.var3a, $01
	asm15 scriptHelp.blossom_addValueToChildStatus, $05
	retscript

@selectedNo_2: ; Were you weird?
	wait 30
	showtextlowindex <TX_441f
	jumptable_memoryaddress wSelectedTextOption
	.dw @selectedYes_3
	.dw @selectedNo_3

@selectedYes_3:
	wait 30
	showtextlowindex <TX_4420
	asm15 scriptHelp.setc6e2Bit, $03
	writeobjectbyte Interaction.var3a, $01
	asm15 scriptHelp.blossom_addValueToChildStatus, $01
	retscript

@selectedNo_3: ; She gives up asking (but she'll ask again next time you talk)
	wait 30
	showtextlowindex <TX_4421
	wait 30
	retscript


; Blossom tells you about how her son's grown?
blossomScript7:
	jumptable_objectbyte Interaction.var03
	.dw @slacker
	.dw @warrior
	.dw @arborist
	.dw @singer
@slacker:
	rungenericnpclowindex <TX_4425
@warrior:
	rungenericnpclowindex <TX_4426
@arborist:
	rungenericnpclowindex <TX_4427
@singer:
	rungenericnpclowindex <TX_4428


; Blossom tells you more specifically about her son's ambitions?
blossomScript8:
	jumptable_objectbyte Interaction.var03
	.dw @slacker
	.dw @warrior
	.dw @arborist
	.dw @singer
@slacker:
	rungenericnpclowindex <TX_4429
@warrior:
	rungenericnpclowindex <TX_442a
@arborist:
	rungenericnpclowindex <TX_442b
@singer:
	rungenericnpclowindex <TX_442c


; Blossom tells you about what her son has accomplished?
blossomScript9:
	jumptable_objectbyte Interaction.var03
	.dw @slacker
	.dw @warrior
	.dw @arborist
	.dw @singer
@slacker:
	rungenericnpclowindex <TX_442d
@warrior:
	rungenericnpclowindex <TX_442e
@arborist:
	rungenericnpclowindex <TX_442f
@singer:
	rungenericnpclowindex <TX_4430


; ==================================================================================================
; INTERAC_FICKLE_GIRL
; ==================================================================================================
sunkenCityFickleGirlScript_text1:
	rungenericnpc TX_1c00

sunkenCityFickleGirlScript_text2:
	initcollisions
-
	checkabutton
	showtext TX_1c01
	checkabutton
	showtext TX_1c02
	scriptjump -

sunkenCityFickleGirlScript_text3:
	rungenericnpc TX_1c03


; ==================================================================================================
; INTERAC_SUBROSIAN
; ==================================================================================================
subrosianScript_smelterByAutumnTemple:
	stopifroomflag80set
	asm15 scriptHelp.subrosianFunc_58ac
	rungenericnpc TX_2705

subrosianScript_smelterText1:
	jumpifglobalflagset GLOBALFLAG_UNBLOCKED_AUTUMN_TEMPLE, @autumnTempleHint
	rungenericnpc TX_2700
@autumnTempleHint:
	rungenericnpc TX_270b
	
subrosianScript_smelterText2:
	rungenericnpc TX_2701

subrosianScript_smelterText3:
	asm15 scriptHelp.subrosianFunc_58ac
	rungenericnpc TX_2702

subrosianScript_smelterText4:
	asm15 scriptHelp.subrosianFunc_58b1
	rungenericnpc TX_2703

subrosianScript_beachText1:
	jumpifglobalflagset GLOBALFLAG_DATING_ROSA, @datingRosa
	jumpifglobalflagset GLOBALFLAG_DATED_ROSA, @datedRosa
	rungenericnpc TX_290c
@datedRosa:
	rungenericnpc TX_2912
@datingRosa:
	settextid TX_2917
	scriptjump subrosian_jump
	
subrosianScript_beachText2:
	jumpifglobalflagset GLOBALFLAG_DATING_ROSA, @datingRosa
	jumpifglobalflagset GLOBALFLAG_DATED_ROSA, @datedRosa
	rungenericnpc TX_290d
@datedRosa:
	rungenericnpc TX_2913
@datingRosa:
	settextid TX_2918
	scriptjump subrosian_jump
	
subrosianScript_beachText3:
	jumpifglobalflagset GLOBALFLAG_DATING_ROSA, @datingRosa
	jumpifglobalflagset GLOBALFLAG_DATED_ROSA, @datedRosa
@datingRosa:
	rungenericnpc TX_290e
@datedRosa:
	rungenericnpc TX_2914
	
subrosianScript_beachText4:
	jumpifglobalflagset GLOBALFLAG_DATING_ROSA, @datingRosa
	jumpifglobalflagset GLOBALFLAG_DATED_ROSA, @datedRosa
@datingRosa:
	rungenericnpc TX_290f
@datedRosa:
	rungenericnpc TX_2915
	
subrosianScript_villageText1:
	jumpifglobalflagset GLOBALFLAG_DATING_ROSA, @datingRosa
	jumpifglobalflagset GLOBALFLAG_DATED_ROSA, @datedRosa
@datingRosa:
	rungenericnpc TX_2910
@datedRosa:
	rungenericnpc TX_2916

subrosianScript_villageText2:
	jumpifglobalflagset GLOBALFLAG_DATING_ROSA, @datingRosa
	rungenericnpc TX_2911
@datingRosa:
	settextid TX_2919
	scriptjump subrosian_jump
	
subrosian_jump:
	initcollisions
-
	checkabutton
	setdisabledobjectsto11
	setzspeed -$01c0
	wait 60
	showloadedtext
	enableallobjects
	scriptjump -
	
subrosianScript_shopkeeper:
	writememory $ccea, $05
	initcollisions
-
	checkabutton
	jumpifmemoryeq $ccea, $00, script5690
	showtext TX_2b0f
	scriptjump -
script5690:
	showtext TX_2b11
-
	checkabutton
	showtext TX_2b11
	scriptjump -
	
subrosianScript_wildsText1:
	jumpifitemobtained TREASURE_FEATHER, @gotFeatherBack
	rungenericnpc TX_2807
@gotFeatherBack:
	rungenericnpc TX_280a

subrosianScript_wildsText2:
	jumpifitemobtained TREASURE_FEATHER, @gotFeatherBack
	rungenericnpc TX_2808
@gotFeatherBack:
	rungenericnpc TX_280b

subrosianScript_wildsText3:
	rungenericnpc TX_2809

subrosianScript_strangeBrother1_stealingFeather:
	stopifroomflag40set
	writeobjectbyte $5c, $02
	callscript subrosianScript_runLeft
	checkcfc0bit 0
	orroomflag $40
	asm15 scriptHelp.subrosianFunc_58c4
	applyspeed $68
	checkcfc0bit 2
	setspeed SPEED_100
	setangle $08
	asm15 scriptHelp.subrosianFunc_58d4
	setanimation $01
	setcounter1 $10
	showtext TX_2800
	wait 30
	xorcfc0bit 3
	setzspeed -$0300
	wait 8
	xorcfc0bit 7
	playsound SND_GETSEED
	checkcfc0bit 4
	updatelinkrespawnposition
	asm15 setDeathRespawnPoint
	setanimation $03
	setspeed SPEED_200
	setangle $18
	asm15 scriptHelp.subrosianFunc_5968
	wait 4
	scriptend
subrosianScript_strangeBrother2_stealingFeather:
	loadscript scripts2.subrosianScript_steaLinksFeather

subrosianScript_runLeft:
	writeobjectbyte $40, $81
	setstate $02
	setcollisionradii $06, $06
	setspeed SPEED_200
	setangleandanimation $18
	retscript

subrosianScript_strangeBrother1_inHouse:
	loadscript scripts2.subrosianScript_inHouseRunFromLink

subrosianScript_strangeBrother2_inHouse:
	jumpifglobalflagset GLOBALFLAG_SAW_STRANGE_BROTHERS_IN_HOUSE, stubScript
	writeobjectbyte $5c, $01
	callscript subrosianScript_runLeft
	checkcfc0bit 0
	setzspeed -$0300
	showtext TX_2802
	xorcfc0bit 1
	setcounter1 $02
	applyspeed $40
	setglobalflag GLOBALFLAG_SAW_STRANGE_BROTHERS_IN_HOUSE
	enableallobjects
	scriptend

subrosianScript_5716:
	writeobjectbyte $5c, $01
	rungenericnpc TX_3e00

subrosianScript_westVolcanoesText1:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, stubScript
	rungenericnpc TX_3e01

subrosianScript_westVolcanoesText2:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, stubScript
	writeobjectbyte $5c, $01
	rungenericnpc TX_3e02

subrosianScript_eastVolcanoesText1:
	rungenericnpc TX_3e03

subrosianScript_eastVolcanoesText2:
	rungenericnpc TX_3e04

subrosianScript_southOfExitToSuburbsPortal:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, stubScript
	writeobjectbyte $5c, $01
	rungenericnpc TX_3e08

subrosianScript_nearExitToTempleRemainsNorthsPortal:
	rungenericnpc TX_3e0a

subrosianScript_wildsNearLockedDoor:
	rungenericnpc TX_3e0b

subrosianScript_boomerangSubrosianFriend:
	writeobjectbyte $5c, $02
	rungenericnpc TX_3e0d

subrosianScript_screenRightOfBoomerangSubrosian:
	writeobjectbyte $5c, $01
	rungenericnpc TX_3e10

subrosianScript_wildsInAreaWithOre:
	writeobjectbyte $5c, $01
	rungenericnpc TX_3e11
	
subrosianScript_wildsOtherSideOfTreesToOre:
	rungenericnpc TX_3e13
	
subrosianScript_wildsNorthOfStrangeBrothersHouse:
	writeobjectbyte $5c, $01
	rungenericnpc TX_3e14
	
subrosianScript_wildsOutsideStrangeBrothersHouse:
	writeobjectbyte $5c, $01
	; Place where roc's feather is gotten
	jumpifmemoryset wSubrosiaRoomFlags+(<ROOM_SEASONS_160), $20, @gotFeatherBack
	rungenericnpc TX_3e29
@gotFeatherBack:
	rungenericnpc TX_3e16
	
subrosianScript_villageSouthOfShop:
	rungenericnpc TX_3e17

subrosianScript_hasLavaPoolInHouse:
	rungenericnpc TX_3e0c

subrosianScript_beachText5:
	rungenericnpc TX_3e19

subrosianScript_goldenByBombFlower:
	writeobjectbyte $5c, $03


; ==================================================================================================

; Used by linked game NPCs that give secrets.
; The npcs set "var3f" to the "secret index" (corresponds to wShortSecretIndex) before
; running this script.
linkedGameNpcScript:
	initcollisions
	asm15 scriptHelp.linkedNpc_checkSecretBegun
	jumpifobjectbyteeq Interaction.var3f, $01, @secretBegun
-
	enableinput
	asm15 scriptHelp.linkedNpc_initHighTextIndex, $00
	checkabutton
	disableinput
	showloadedtext
	wait 20
	jumpiftextoptioneq $00, +
	addobjectbyte Interaction.textID, $04
	showloadedtext
	scriptjump -
+
	addobjectbyte Interaction.textID, $01
@showTextAndSecret:
	showloadedtext
	asm15 scriptHelp.linkedNpc_initHighTextIndex, $05
	wait 20
	jumpiftextoptioneq $01, @showTextAndSecret
	asm15 scriptHelp.linkedNpc_generateSecret
	asm15 scriptHelp.linkedNpc_calcLowTextIndex, <TX_5302
-
	showloadedtext
	wait 20
	jumpiftextoptioneq $01, -
	asm15 scriptHelp.linkedNpc_calcLowTextIndex, <TX_5303
	showloadedtext
	enableinput
@secretBegun:
	checkabutton
	disableinput
	asm15 scriptHelp.linkedNpc_initHighTextIndex, $05
	scriptjump @showTextAndSecret
	

; ==================================================================================================
; INTERAC_SUBROSIAN (cont.)
; ==================================================================================================
subrosianScript_signsGuy:
	initcollisions
	jumpifroomflagset $20, @ringGotten
	asm15 scriptHelp.subrosian_checkSignsDestroyed
	jumptable_memoryaddress $cfc0
	.dw @0signsBroken
	.dw @lessThan20SignsBroken
	.dw @lessThan50SignsBroken
	.dw @lessThan90SignsBroken
	.dw @lessThan100SignsBroken
	.dw @100orMoreSignsBroken
@0signsBroken:
	checkabutton
	showtext TX_3e23
	rungenericnpc TX_3e1b
@lessThan20SignsBroken:
	checkabutton
	showtext TX_3e24
	rungenericnpc TX_3e1c
@lessThan50SignsBroken:
	checkabutton
	showtext TX_3e25
	rungenericnpc TX_3e1d
@lessThan90SignsBroken:
	checkabutton
	showtext TX_3e26
	rungenericnpc TX_3e1e
@lessThan100SignsBroken:
	checkabutton
	showtext TX_3e27
	rungenericnpc TX_3e1f
@100orMoreSignsBroken:
	checkabutton
	disableinput
	showtext TX_3e20
	wait 30
	asm15 scriptHelp.subrosian_fakeReset
	wait 10
	checkpalettefadedone
	showtext TX_3e21
	wait 30
	asm15 scriptHelp.subrosian_giveSignRing
	enableinput
	scriptjump @areYouTreatingSignsProperly
@ringGotten:
	checkabutton
	showtext TX_3e28
@areYouTreatingSignsProperly:
	rungenericnpc TX_3e22


; ==================================================================================================
; INTERAC_ROSA
; ==================================================================================================
rosaScript_goOnDate:
	initcollisions
	jumpifglobalflagset GLOBALFLAG_DATED_ROSA, @datedRosa
	jumpifitemobtained TREASURE_RIBBON, @haveRibbon
	rungenericnpclowindex <TX_2900
@haveRibbon:
	checkabutton
	showtextlowindex <TX_2901
	jumpiftextoptioneq $00, @givingRibbon
	showtextlowindex <TX_2902
	scriptjump @haveRibbon
@givingRibbon:
	disableinput
	setglobalflag GLOBALFLAG_DATED_ROSA
	showtextlowindex <TX_2903
	wait 10
	playsound SND_GETSEED
	asm15 scriptHelp.rosa_tradeRibbon
	setanimation $02
	wait 60
	showtextlowindex <TX_2904
	setglobalflag GLOBALFLAG_DATING_ROSA
	asm15 scriptHelp.rosa_startDate
	enableinput
	scriptend
@datedRosa:
	checkabutton
	showtextlowindex <TX_2905
	jumpiftextoptioneq $00, @acceptDate
	showtextlowindex <TX_2907
	scriptjump @datedRosa
@acceptDate:
	disableinput
	setglobalflag GLOBALFLAG_DATING_ROSA
	showtextlowindex <TX_2906
	asm15 scriptHelp.rosa_startDate
	enableinput
	scriptend


rosaScript_dateEnded:
	setspeed SPEED_100
	movedown $20
	setanimation $00
	wait 30
	showtextlowindex <TX_291a
	setanimation $02
	scriptend


; ==================================================================================================
; INTERAC_SUBROSIAN_WITH_BUCKETS
; ==================================================================================================
bucketSubrosianScript_text1:
	rungenericnpc TX_2706

bucketSubrosianScript_text2:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, stubScript
	rungenericnpc TX_3e06

bucketSubrosianScript_text3:
	writeobjectbyte $5c, $01
	rungenericnpc TX_3e09

bucketSubrosianScript_text4:
	rungenericnpc TX_3e0f

bucketSubrosianScript_text5:
	rungenericnpc TX_3e12

bucketSubrosianScript_text6:
	rungenericnpc TX_3e15


; ==================================================================================================
; INTERAC_CHILD
; ==================================================================================================

; For a summary of the child's behaviour, see:
; http://wiki.zeldahacking.net/oracle/Bipin_and_Blossom's_son

childScript00:
	scriptend

childScript_stage4_hyperactive:
	initcollisions
@loop:
	checkabutton
	showtext TX_4700
	scriptjump @loop

childScript_stage4_shy:
	initcollisions
@loop:
	checkabutton
	showtext TX_4200
	scriptjump @loop

childScript_stage4_curious:
	initcollisions
@loop:
	checkabutton
	showtext TX_4900
	scriptjump @loop


childScript_stage5_hyperactive:
	initcollisions
@loop:
	checkabutton
	showtext TX_4701
	asm15 scriptHelp.setNextChildStage, $06
	scriptjump @loop

childScript_stage5_shy:
	initcollisions
@loop:
	checkabutton
	showtext TX_4201
	asm15 scriptHelp.setNextChildStage, $06
	scriptjump @loop

childScript_stage5_curious:
	initcollisions
@loop:
	checkabutton
	showtext TX_4901
	asm15 scriptHelp.setNextChildStage, $06
	scriptjump @loop


; Stage 6: the child asks a question. The question differs based on his personality, but
; the result is always the same: wChildStatus is incremented by 4 if you answer yes.

childScript_stage6_hyperactive:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $04
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyAnswered
	checkabutton
	disableinput
	showtext TX_4702
	asm15 scriptHelp.setc6e2Bit, $04
	asm15 scriptHelp.setNextChildStage, $07
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredYes
	.dw @answeredNo

@answeredYes:
	wait 30
	showtext TX_4703
	asm15 scriptHelp.child_addValueToChildStatus, $04
	enableinput
	scriptjump @alreadyAnswered

@answeredNo:
	wait 30
	showtext TX_4704
	enableinput

@alreadyAnswered:
	checkabutton
	showtext TX_4705
	scriptjump @alreadyAnswered


childScript_stage6_shy:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $04
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyAnswered
	checkabutton
	disableinput
	showtext TX_4202
	asm15 scriptHelp.setc6e2Bit, $04
	asm15 scriptHelp.setNextChildStage, $07
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredYes
	.dw @answeredNo

@answeredYes:
	wait 30
	showtext TX_4203
	asm15 scriptHelp.child_addValueToChildStatus, $04
	enableinput
	scriptjump @alreadyAnswered

@answeredNo:
	wait 30
	showtext TX_4204
	enableinput

@alreadyAnswered:
	checkabutton
	showtext TX_4205
	scriptjump @alreadyAnswered


childScript_stage6_curious:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $04
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyAnswered
	checkabutton
	disableinput
	showtext TX_4902
	asm15 scriptHelp.setc6e2Bit, $04
	asm15 scriptHelp.setNextChildStage, $07
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredChicken
	.dw @answeredEgg

@answeredChicken:
	wait 30
	showtext TX_4903
	asm15 scriptHelp.child_addValueToChildStatus, $04
	enableinput
	scriptjump @alreadyAnswered

@answeredEgg:
	wait 30
	showtext TX_4904
	enableinput

@alreadyAnswered:
	checkabutton
	showtext TX_4905
	scriptjump @alreadyAnswered


; Stage 7: just says some text.

childScript_stage7_slacker:
	initcollisions
@loop:
	checkabutton
	showtext TX_4b00
	asm15 scriptHelp.setNextChildStage, $08
	scriptjump @loop

childScript_stage7_warrior:
	initcollisions
@loop:
	checkabutton
	showtext TX_4a00
	asm15 scriptHelp.setNextChildStage, $08
	scriptjump @loop

childScript_stage7_arborist:
	initcollisions
@loop:
	checkabutton
	showtext TX_4800
	asm15 scriptHelp.setNextChildStage, $08
	scriptjump @loop

childScript_stage7_singer:
	initcollisions
@loop:
	checkabutton
	showtext TX_4600
	asm15 scriptHelp.setNextChildStage, $08
	scriptjump @loop


; Stage 8: asks a question or makes a request. This affects what he will do in stage 9.

childScript_stage8_slacker:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $05
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyAnswered

@loop:
	checkabutton
	disableinput
	showtext TX_4b01
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredYes
	.dw @answeredNo

@answeredYes:
	wait 30
	showtext TX_4b02
	jumptable_memoryaddress wSelectedTextOption
	.dw @answered100Rupees
	.dw @answered50Rupees
	.dw @answered10Rupees
	.dw @answered0Rupees

@answered100Rupees:
	asm15 scriptHelp.child_checkHasRupees, RUPEEVAL_100
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_100
	asm15 scriptHelp.child_setStage8Response, $00
	asm15 scriptHelp.setc6e2Bit, $05
	asm15 scriptHelp.setNextChildStage, $09
	wait 30
	enableinput
@answered100Loop:
	showtext TX_4b04
	checkabutton
	scriptjump @answered100Loop

@answered50Rupees:
	asm15 scriptHelp.child_checkHasRupees, RUPEEVAL_050
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_050
	asm15 scriptHelp.child_setStage8Response, $01
	asm15 scriptHelp.setc6e2Bit, $05
	asm15 scriptHelp.setNextChildStage, $09
	wait 30
	enableinput
@answered50Loop:
	showtext TX_4b05
	checkabutton
	scriptjump @answered50Loop

@answered10Rupees:
	asm15 scriptHelp.child_checkHasRupees, RUPEEVAL_010
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_010
	asm15 scriptHelp.child_setStage8Response, $02
	asm15 scriptHelp.setc6e2Bit, $05
	asm15 scriptHelp.setNextChildStage, $09
	wait 30
	enableinput
@answered10Loop:
	showtext TX_4b06
	checkabutton
	scriptjump @answered10Loop

@answered0Rupees: ; He takes 1 rupee anyway...
	asm15 scriptHelp.child_checkHasRupees, RUPEEVAL_001
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_001
	asm15 scriptHelp.child_setStage8Response, $03
	asm15 scriptHelp.setc6e2Bit, $05
	asm15 scriptHelp.setNextChildStage, $09
	wait 30
	enableinput
@answered0Loop:
	showtext TX_4b07
	checkabutton
	scriptjump @answered0Loop

@notEnoughRupees:
	wait 30
	showtext TX_4b08
	enableinput
	scriptjump @loop

@answeredNo:
	wait 30
	showtext TX_4b03
	enableinput
	scriptjump @loop

@alreadyAnswered:
	checkabutton
	showtext TX_4b09
	scriptjump @alreadyAnswered


; Asks Link what will make him mightiest.
childScript_stage8_warrior:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $05
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyAnswered
	checkabutton
	disableinput
	showtext TX_4a01
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredDailyTraining
	.dw @answeredNo_1

@answeredNo_1:
	wait 30
	showtext TX_4a02
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredNaturalTalent
	.dw @answeredNo_2

@answeredNo_2:
	wait 30
	showtext TX_4a03
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredCaringHeart
	.dw @answeredNo_3

@answeredNo_3: ; He gives up asking
	asm15 scriptHelp.child_setStage8Response, $03
	asm15 scriptHelp.setc6e2Bit, $05
	asm15 scriptHelp.setNextChildStage, $09
	wait 30
	showtext TX_4a04
	enableinput
	wait 30
	scriptjump @alreadyAnswered

@answeredDailyTraining:
	asm15 scriptHelp.child_setStage8Response, $00
	scriptjump @gaveResponse

@answeredNaturalTalent:
	asm15 scriptHelp.child_setStage8Response, $01
	scriptjump @gaveResponse

@answeredCaringHeart:
	asm15 scriptHelp.child_setStage8Response, $02

@gaveResponse:
	asm15 scriptHelp.setc6e2Bit, $05
	asm15 scriptHelp.setNextChildStage, $09
	wait 30
	showtext TX_4a05
	wait 30
	enableinput

@alreadyAnswered:
	checkabutton
	showtext TX_4a08
	scriptjump @alreadyAnswered


; Gives Link a gasha seed.
childScript_stage8_arborist:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $05
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyGaveSeed

	checkabutton
	disableinput
	showtext TX_4801
	giveitem TREASURE_GASHA_SEED, $03
	asm15 scriptHelp.setc6e2Bit, $05
	asm15 scriptHelp.setNextChildStage, $09
	wait 30
	showtext TX_4802
	wait 30
	enableinput

@alreadyGaveSeed:
	checkabutton
	showtext TX_4803
	scriptjump @alreadyGaveSeed


; Asks link what's more important, love or courage.
childScript_stage8_singer:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $05
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyAnswered

	checkabutton
	disableinput
	showtext TX_4601
	asm15 scriptHelp.child_setStage8ResponseToSelectedTextOption, $00
	asm15 scriptHelp.setc6e2Bit, $05
	asm15 scriptHelp.setNextChildStage, $09
	wait 30
	enableinput
	scriptjump @showResponseText

@alreadyAnswered:
	checkabutton
@showResponseText:
	showtext TX_4602
	scriptjump @alreadyAnswered


; Stage 9: the child gives a reward based on your response in stage 8.

childScript_stage9_slacker:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $06
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyGaveReward
	checkabutton
	disableinput
	showtext TX_4b0a
	asm15 scriptHelp.setc6e2Bit, $06
	wait 30
	jumptable_memoryaddress wChildStage8Response
	.dw @fillSatchel
	.dw @give200Rupees
	.dw @giveGashaSeed
	.dw @give10Bombs

@fillSatchel:
	asm15 refillSeedSatchel
	showtext TX_0052
	scriptjump @justGaveReward

@give200Rupees:
	asm15 scriptHelp.child_giveRupees, RUPEEVAL_200
	showtext TX_0009
	scriptjump @justGaveReward

@giveGashaSeed:
	giveitem TREASURE_GASHA_SEED, $03
	scriptjump @justGaveReward

@give10Bombs:
	giveitem TREASURE_BOMBS, $02

@justGaveReward:
	wait 30
	enableinput
	scriptjump @showTextAfterGiving

@alreadyGaveReward:
	checkabutton
@showTextAfterGiving:
	showtext TX_4b0b
	scriptjump @alreadyGaveReward


childScript_stage9_warrior:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $06
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyGaveReward
	checkabutton
	disableinput
	showtext TX_4a06
	wait 30
	showtext TX_4a07
	asm15 scriptHelp.setc6e2Bit, $06
	wait 30
	jumptable_memoryaddress wChildStage8Response
	.dw @give100Rupees
	.dw @give1Heart
	.dw @restoreHealth
	.dw @give1Rupee

@give100Rupees:
	asm15 scriptHelp.child_giveRupees, RUPEEVAL_100
	showtext TX_0007
	scriptjump @justGaveReward

@give1Heart:
	asm15 scriptHelp.child_giveOneHeart, $01
	showtext TX_0051
	scriptjump @justGaveReward

@restoreHealth:
	asm15 scriptHelp.child_giveHeartRefill
	showtext TX_0053
	scriptjump @justGaveReward

@give1Rupee:
	asm15 scriptHelp.child_giveRupees, RUPEEVAL_001
	showtext TX_0001

@justGaveReward:
	wait 30
	enableinput
	scriptjump @showTextAfterGiving

@alreadyGaveReward:
	checkabutton
@showTextAfterGiving:
	showtext TX_4a08
	scriptjump @alreadyGaveReward


childScript_stage9_arborist:
	initcollisions
@loop:
	checkabutton
	disableinput
	showtext TX_4804
	wait 30
	callscript @showTip
	enableinput
	scriptjump @loop

@showTip:
	writeobjectbyte Interaction.textID+1, >TX_4800
	getrandombits   Interaction.textID,   $07
	addobjectbyte   Interaction.textID,   <TX_4805
	showloadedtext
	retscript


childScript_stage9_singer:
	initcollisions
@loop:
	checkabutton
	disableinput
	showtext TX_4603
	jumptable_memoryaddress wSelectedTextOption
	.dw @selectedYes
	.dw @selectedNo

@selectedYes:
	asm15 scriptHelp.child_playMusic
	asm15 scriptHelp.child_giveHeartRefill
	wait 30
	enableinput

@singingLoop:
	showtext TX_4604
	checkabutton
	scriptjump @singingLoop

@selectedNo:
	wait 30
	showtext TX_4605
	enableinput
	scriptjump @loop


; ==================================================================================================
; INTERAC_GORON
; ==================================================================================================
goronScript_pacingLeftAndRight:
	initcollisions
	setspeed SPEED_080
	writeobjectbyte $76, $03
	setangle ANGLE_LEFT
	setanimationfromangle
	applyspeed $a0
	wait 20
-
	writeobjectbyte $76, $01
	setangle ANGLE_RIGHT
	setanimationfromangle
	applyspeed $e0
	wait 20
	writeobjectbyte $76, $03
	setangle ANGLE_LEFT
	setanimationfromangle
	applyspeed $e0
	wait 20
	scriptjump -

goronScript_text1_biggoronSick:
	rungenericnpclowindex <TX_3701
goronScript_text1_biggoronHealed:
	rungenericnpclowindex <TX_3706

goronScript_text2:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @finishedGame
	rungenericnpclowindex <TX_3702
@finishedGame:
	rungenericnpclowindex <TX_370e

goronScript_text3_biggoronSick:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, goronScript_text3_finishedGame
	rungenericnpclowindex <TX_3703
goronScript_text3_biggoronHealed:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, goronScript_text3_finishedGame
	rungenericnpclowindex <TX_3707
goronScript_text3_finishedGame:
	rungenericnpclowindex <TX_370f

goronScript_text4_biggoronSick:
	rungenericnpclowindex <TX_3704

goronScript_text4_biggoronHealed:
	rungenericnpclowindex <TX_3708

goronScript_text5:
	rungenericnpclowindex <TX_3705

goronScript_upgradeRingBox:
	initcollisions
	jumpifroomflagset $40, @alreadyGivenRingBox
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_3709
	jumpiftextoptioneq $01, @answeredNo
	jumpifitemobtained TREASURE_RING_BOX, @haveRingBox
	wait 30
	showtextlowindex <TX_370d
	enableallobjects
	rungenericnpclowindex <TX_370d
@haveRingBox:
	wait 30
	showtextlowindex <TX_370a
	asm15 scriptHelp.getNextRingboxLevel
	jumpifmemoryeq $cba8, $05, @upgradeTo5
	giveitem TREASURE_RING_BOX, $01
	scriptjump @finishedGivingRingBox
@upgradeTo5:
	giveitem TREASURE_RING_BOX, $02
@finishedGivingRingBox:
	orroomflag $40
	enableallobjects
@alreadyGivenRingBox:
	rungenericnpclowindex <TX_370b
@answeredNo:
	wait 30
	showtextlowindex <TX_370c
	enableallobjects
	rungenericnpclowindex <TX_370c

goronScript_giveSubrosianSecret:
	initcollisions
--
	enableinput
	checkabutton
	disableinput
	showtextlowindex <TX_5330
	wait 20
	jumpiftextoptioneq $00, @answeredYes
	showtextlowindex <TX_5335
	scriptjump --
@answeredYes:
	setglobalflag GLOBALFLAG_BEGAN_ELDER_SECRET
	 ; This should be "generatesecret SUBROSIAN_SECRET" but, for some reason, this is the only opcode in
	 ; seasons where the parameter doesn't have "| $30" applied? This may change the xor cipher,
	 ; but nothing else?
	 ; TODO: figure out what's up (does this cause any problems?)
	.db $86, $08
-
	showtextlowindex <TX_5333
	wait 20
	jumpiftextoptioneq $01, -
	showtextlowindex <TX_5334
	scriptjump --
	

; ==================================================================================================
; INTERAC_MISC_BOY_NPCS
; ==================================================================================================
boyWithDogScript_text1:
	rungenericnpc TX_1500
boyWithDogScript_text2:
	initcollisions
-
	checkabutton
	showtext TX_1501
	checkabutton
	showtext TX_1502
	scriptjump -
boyWithDogScript_text3:
	rungenericnpc TX_1406
boyWithDogScript_text4:
	rungenericnpc TX_1503
boyWithDogScript_text5:
	rungenericnpc TX_1504
boyWithDogScript_text6:
	rungenericnpc TX_1505
boyWithDogScript_text7:
	rungenericnpc TX_1506

horonVillageBoyScript_text1:
	initcollisions
-
	checkabutton
	showtext TX_1400
	checkabutton
	showtext TX_1401
	scriptjump -
horonVillageBoyScript_text2:
	initcollisions
-
	checkabutton
	setdisabledobjectsto91
	showtext TX_1402
	jumpiftextoptioneq $01, @dontKnowAboutOwls
	wait 30
	showtext TX_1403
	scriptjump @knowAboutOwls
@dontKnowAboutOwls:
	wait 30
	showtext TX_1404
@knowAboutOwls:
	enableallobjects
	scriptjump -
horonVillageBoyScript_text3:
	rungenericnpc TX_1405
horonVillageBoyScript_text4:
	rungenericnpc TX_1406
horonVillageBoyScript_text5:
	setanimation $00
	settextid TX_1407
	writeobjectbyte $7b, $00
--
	initcollisions
-
	checkabutton
	asm15 scriptHelp.faceOppositeDirectionAsLink
	showloadedtext
	wait 10
	setanimationfromobjectbyte $7b
	scriptjump -
horonVillageBoyScript_text6:
	setanimation $02
	settextid TX_1408
	writeobjectbyte $7b, $02
	scriptjump --
horonVillageBoyScript_text7:
	initcollisions
-
	checkabutton
	showtext TX_1409
	writeobjectbyte $45, $00
	scriptjump -
	
springBloomBoyScript_text1:
	jumptable_memoryaddress wRoomStateModifier
	.dw @spring
	.dw @summer
	.dw @autumn
@spring:
	rungenericnpc TX_1300
@summer:
	rungenericnpc TX_1301
@autumn:
	rungenericnpc TX_1302
springBloomBoyScript_text2:
	rungenericnpc TX_1303
springBloomBoyScript_text3:
	rungenericnpc TX_1304
	
sunkenCityBoyScript_text1:
	jumpifglobalflagset GLOBALFLAG_MOBLINS_KEEP_DESTROYED, sunkenCityBoyScript_text1_moblinsKeepDestroyed
	rungenericnpc TX_1a00
sunkenCityBoyScript_text2:
	jumpifglobalflagset GLOBALFLAG_MOBLINS_KEEP_DESTROYED, sunkenCityBoyScript_text2_moblinsKeepDestroyed
	scriptjump sunkenCityBoyScript_text3
sunkenCityBoyScript_text2_moblinsKeepDestroyed:
	initcollisions
	checkabutton
	showtext TX_1a02
	checkabutton
	showtext TX_1a01
	scriptjump sunkenCityBoyScript_text2_moblinsKeepDestroyed
sunkenCityBoyScript_text1_moblinsKeepDestroyed:
	rungenericnpc TX_1a02
sunkenCityBoyScript_text3:
	rungenericnpc TX_1a01
sunkenCityBoyScript_text4:
	rungenericnpc TX_1a03


; ==================================================================================================
; INTERAC_PIRATIAN
; INTERAC_PIRATIAN_CAPTAIN
; ==================================================================================================
piratianCaptainScript_inHouse:
	initcollisions
	jumpifobjectbyteeq $7a, $01, @6thEssenceGotten
	checkabutton
	showtextlowindex <TX_3a17
	disableinput
	wait 30
	enableinput
-
	checkabutton
	showtextlowindex <TX_3a18
	scriptjump -
@6thEssenceGotten:
	jumptable_objectbyte $7b
	.dw @noPiratesBell
	.dw @haveRustedPiratesBell
	.dw @haveFixedPiratesBell
@noPiratesBell:
	checkabutton
	showtextlowindex <TX_3a19
	disableinput
	writememory wTalkedToPirationCaptainState, $01
	wait 30
	enableinput
-
	checkabutton
	showtextlowindex <TX_3a1a
	scriptjump -
@haveRustedPiratesBell:
	checkabutton
	showtextlowindex <TX_3a1c
	disableinput
	writememory wTalkedToPirationCaptainState, $02
	wait 30
	enableinput
-
	checkabutton
	showtextlowindex <TX_3a1d
	scriptjump -
@haveFixedPiratesBell:
	checkabutton
	disableinput
	showtextlowindex <TX_3a1e
	wait 30
	showtextlowindex <TX_3a1f
	wait 30
	writememory wTalkedToPirationCaptainState, $02
	jumptable_memoryaddress wIsLinkedGame
	.dw @unlinkedCaptain
	.dw @linkedCaptain
@unlinkedCaptain:
	showtextlowindex <TX_3a14
	wait 30
	xorcfc0bit 0
	setcounter1 $64
	enableinput
	asm15 scriptHelp.headToPirateShip
-
	setcounter1 $ff
	scriptjump -
@linkedCaptain:
	wait 60
	showtextlowindex <TX_3a26
	asm15 scriptHelp.linkedGame_spawnAmbi
	checkcfc0bit 1
	wait 30
	showtextlowindex <TX_3a27
	wait 30
	writeobjectbyte $7c, $01
	setspeed SPEED_100
	asm15 scriptHelp.seasonsFunc_15_5a70
	jumptable_objectbyte $79
	.dw script5d7f
	.dw script5d5f
	.dw script5d6f
script5d5f:
	setanimation $02
	setangle ANGLE_LEFT
	applyspeed $0d
	movedown $21
	setanimation $02
	setangle ANGLE_RIGHT
	applyspeed $0d
	scriptjump ++
script5d6f:
	setanimation $02
	setangle ANGLE_RIGHT
	applyspeed $0d
	movedown $21
	setanimation $02
	setangle ANGLE_LEFT
	applyspeed $0d
	scriptjump ++
script5d7f:
	movedown $21
++
	loadscript scripts2.linkedPirateCaptainScript_sayingByeToAmbi

piratian1FScript_text1BasedOnD6Beaten:
	initcollisions
--
	jumptable_memoryaddress wTalkedToPirationCaptainState
	.dw @noFixedPiratesBell
	.dw @noFixedPiratesBell
	.dw @haveFixedPiratesBell
@noFixedPiratesBell:
	jumpifobjectbyteeq $71, $00, --
	writeobjectbyte $71, $00
	asm15 scriptHelp.showPiratianTextBasedOnD6Done, $00
	wait 1
	scriptjump --
@haveFixedPiratesBell:
	jumpifobjectbyteeq $71, $01, @talkedTo
	jumpifmemoryset $cfc0, $01, @readyToLeave
	scriptjump @haveFixedPiratesBell
@talkedTo:
	writeobjectbyte $71, $00
	asm15 scriptHelp.showPiratianTextBasedOnD6Done, $01
	wait 1
	scriptjump @haveFixedPiratesBell
@readyToLeave:
	callscript piratianScript_jump
-
	setcounter1 $ff
	scriptjump -

piratian1FScript_text2BasedOnD6Beaten:
	initcollisions
--
	jumpifobjectbyteeq $71, $01, @talkedTo
	jumpifmemoryset $cfc0, $01, @readyToLeave
	scriptjump --
@talkedTo:
	setdisabledobjectsto91
	writeobjectbyte $71, $00
	asm15 scriptHelp.showPiratianTextBasedOnD6Done, $00
	wait 1
	enableallobjects
	scriptjump --
@readyToLeave:
	callscript piratianScript_jump
-
	setcounter1 $ff
	scriptjump -

unluckySailorScript:
	initcollisions
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @finishedGame
	jumpifglobalflagset GLOBALFLAG_PIRATES_LEFT_FOR_SHIP, @piratesLeft
-
	checkabutton
	showtextlowindex <TX_3a0a
	scriptjump -
@piratesLeft:
	checkabutton
	showtextlowindex <TX_3a0b
	scriptjump @piratesLeft
@finishedGame:
	jumpifglobalflagset GLOBALFLAG_DONE_PIRATE_SECRET, @finishedPiratesSecret
	jumpifglobalflagset GLOBALFLAG_BEGAN_PIRATE_SECRET, @beganPiratesSecret
--
	checkabutton
	disableinput
	showtextlowindex <TX_3a2c
	jumpiftextoptioneq $00, @knowSecret
	wait 30
	showtextlowindex <TX_3a2d
	enableinput
	scriptjump --
@knowSecret:
	wait 30
	showtextlowindex <TX_3a2e
	askforsecret PIRATE_SECRET
	wait 30
	jumptable_memoryaddress $cca3
	.dw @correctSecret
	.dw @incorrectSecret
@incorrectSecret:
	showtextlowindex <TX_3a2d
	enableinput
	scriptjump --
@beganPiratesSecret:
	checkabutton
	disableinput
@correctSecret:
	setglobalflag GLOBALFLAG_BEGAN_PIRATE_SECRET
	showtextlowindex <TX_3a2f
	wait 30
	asm15 scriptHelp.unluckySailor_checkHave777OreChunks
	jumpifobjectbyteeq $79, $01, @have777OreChunks
-
	showtextlowindex <TX_3a31
	enableinput
	checkabutton
	disableinput
	scriptjump -
@have777OreChunks:
	showtextlowindex <TX_3a32
	asm15 scriptHelp.unluckySailor_increaseBombCapacityAndCount
	giveitem TREASURE_BOMB_UPGRADE, $00
	wait 60
	setglobalflag GLOBALFLAG_DONE_PIRATE_SECRET
--
	generatesecret PIRATE_RETURN_SECRET
-
	showtextlowindex <TX_3a33
	wait 30
	jumpiftextoptioneq $00, @gotSecret
	scriptjump -
@gotSecret:
	showtextlowindex <TX_3a34
	enableinput
@finishedPiratesSecret:
	checkabutton
	disableinput
	scriptjump --

piratian2FScript_textBasedOnD6Beaten:
	initcollisions
	jumpifglobalflagset GLOBALFLAG_PIRATES_LEFT_FOR_SHIP, @piratesLeft
@showGateCombo:
	loadscript scripts2.showSamasaGateCombination
@piratesLeft:
	checkabutton
	showtextlowindex <TX_3a0e
	scriptjump @piratesLeft
	
pirationScript_closeOpenCupboard:
	setspeed SPEED_100
	moveup $07
	asm15 scriptHelp.piratian_replaceTileAtPiratian, $db
	playsound SND_DOORCLOSE
	wait 10
	asm15 scriptHelp.piratian_replaceTileAtPiratian, $d9
	playsound SND_DOORCLOSE
	setanimation $00
	setangle $10
	applyspeed $07
	setspeed SPEED_200
	wait 4
	retscript
	
piratianRoofScript:
	rungenericnpclowindex <TX_3a0f
	
samasaGatePiratianScript:
	initcollisions
	jumptable_memoryaddress wTalkedToPirationCaptainState
	.dw @notTalkedToPirateCaptainAfterD6
	.dw @talkedToPirateCaptainAfterD6
	.dw @talkedToPirateCaptainAfterD6
@notTalkedToPirateCaptainAfterD6:
	checkabutton
	showtextlowindex <TX_3a12
	scriptjump @notTalkedToPirateCaptainAfterD6
@talkedToPirateCaptainAfterD6:
	checkabutton
	showtextlowindex <TX_3a13
	wait 40
	writeobjectbyte $7c, $01
	setspeed SPEED_200
	moveleft $39
	orroomflag $40
	scriptend

piratianCaptainByShipScript:
	loadscript scripts2.piratianCaptain_preCutsceneScene

piratianFromShipScript:
	writeobjectbyte $7c, $01
	asm15 objectSetVisible80
	setspeed SPEED_080
	movedown $03
	wait 20
	applyspeed $03
	wait 20
	setspeed SPEED_100
	applyspeed $0f
	applyspeed $21
	setspeed SPEED_100
	moveleft $41
	wait 4
	setspeed SPEED_080
	moveup $11
	wait 30
	showtextlowindex <TX_3a15
	wait 30
	xorcfc0bit 0
	checkcfc0bit 1
	setcounter1 $40
	setspeed SPEED_100
	moveright $41
	wait 4
	setspeed SPEED_100
	moveup $27
	callscript piratianScript_moveUpPauseThenUp
	scriptend

piratianByCaptainWhenDeparting1Script:
	checkcfc0bit 1
	wait 20
	setcounter1 $6a
	setcounter1 $44
	writeobjectbyte $7c, $01
	asm15 objectSetVisible80
	setspeed SPEED_100
	movedown $0f
	wait 4
	moveright $21
	setspeed SPEED_080
	moveup $03
	wait 20
	applyspeed $03
	wait 20
	scriptend

piratianByCaptainWhenDeparting2Script:
	checkcfc0bit 1
	wait 4
	setcounter1 $6a
	setcounter1 $44
	setcounter1 $32
	setcounter1 $44
	xorcfc0bit 2
	writeobjectbyte $7c, $01
	asm15 objectSetVisible80
	setspeed SPEED_100
	moveright $11
	wait 4
	moveup $0f
	callscript piratianScript_moveUpPauseThenUp
	scriptend
	
piratianScript_moveUpPauseThenUp:
	setspeed SPEED_080
	moveup $03
	wait 20
	applyspeed $03
	wait 20
	retscript

; also used by Din when she's discovered you
piratianScript_jump:
	writeobjectbyte $50, $28
	setzspeed -$0200
	playsound SND_JUMP
-
	asm15 scriptHelp.piratian_waitUntilJumpDone
	wait 1
	jumpifobjectbyteeq $7d, $00, -
	retscript


; ==================================================================================================
; INTERAC_PIRATE_HOUSE_SUBROSIAN
; ==================================================================================================
pirateHouseSubrosianScript_piratesAround:
	rungenericnpc TX_3a10
pirateHouseSubrosianScript_piratesLeft:
	rungenericnpc TX_3a11


; ==================================================================================================
; INTERAC_SYRUP
; ==================================================================================================
syrupScript_notTradedMushroomYet:
	checkabutton
	showtext TX_0b3e
	jumpiftradeitemeq $08, @haveMushroom
	scriptjump syrupScript_notTradedMushroomYet
@haveMushroom:
	setdisabledobjectsto91
	wait 30
-
	showtext TX_0b3f
	jumpiftextoptioneq $00, @tradingMushroom
	wait 30
	showtext TX_0b42
	enableallobjects
	checkabutton
	setdisabledobjectsto91
	scriptjump -
@tradingMushroom:
	wait 30
	disableinput
	giveitem TREASURE_TRADEITEM, $09
	wait 30
	showtext TX_0b40
	orroomflag $40
	enableinput
-
	checkabutton
	showtext TX_0b41
	scriptjump -

syrupScript_spawnShopItems:
	spawninteraction INTERAC_SHOP_ITEM, $0b, $28, $44
	spawninteraction INTERAC_SHOP_ITEM, $07, $28, $4c
	spawninteraction INTERAC_SHOP_ITEM, $08, $28, $74
	scriptend

syrupScript_showWelcomeText:
	showtext TX_0d00
	scriptend

; "We're closed"
syrupScript_showClosedText:
	showtext TX_0d0b
	scriptend

syrupScript_purchaseItem:
.ifdef ROM_AGES
	jumptable_objectbyte Interaction.var37
.else
	jumptable_objectbyte Interaction.var38
.endif
	.dw @buyMagicPotion
	.dw @buyGashaSeed
	.dw @buyMagicPotion
	.dw @buyGashaSeed
	.dw @buyBombchus

@buyMagicPotion:
	showtextnonexitable TX_0d01
	scriptjump @checkAcceptPurchase

@buyGashaSeed:
	showtextnonexitable TX_0d05
	scriptjump @checkAcceptPurchase

@buyBombchus:
	showtextnonexitable TX_0d0a
.ifdef ROM_SEASONS
	scriptjump @checkAcceptPurchase
.endif

@checkAcceptPurchase:
	jumpiftextoptioneq $00, @tryToPurchase

	; Said "no" when asked to purchase
.ifdef ROM_AGES
	writeobjectbyte Interaction.var3a, $ff
.else
	writeobjectbyte Interaction.var3b, $ff
.endif
	writememory wcbad, $03
	writememory wTextIsActive, $01
	scriptend

@tryToPurchase:
.ifdef ROM_AGES
	jumpifmemoryeq wShopHaveEnoughRupees, $00, @enoughRupees
	writeobjectbyte Interaction.var3a, $ff
.else
	jumptable_objectbyte Interaction.var39
	.dw @enoughRupees
	.dw @notEnoughRupees
@notEnoughRupees:
	writeobjectbyte Interaction.var3b, $ff
.endif
	writememory wcbad, $01
	writememory wTextIsActive, $01
	scriptend

@enoughRupees:
.ifdef ROM_AGES
	jumptable_objectbyte Interaction.var38
	.dw @buy
	.dw shopkeeperCantBuy
@buy:
	writeobjectbyte Interaction.var3a, $01
.else
	jumptable_objectbyte Interaction.var3a
	.dw @buy
	.dw @shopkeeperCantBuy
@buy:
	writeobjectbyte Interaction.var3b, $01
.endif
	writememory wcbad, $00
	writememory wTextIsActive, $01
	scriptend
.ifdef ROM_SEASONS
@shopkeeperCantBuy:
	writeobjectbyte Interaction.var3b, $ff
	writememory wcbad, $02
	writememory wTextIsActive, $01
	scriptend
.endif


; ==================================================================================================
; INTERAC_ZELDA
; ==================================================================================================
zeldaScript_ganonBeat:
	setcollisionradii $08, $04
	makeabuttonsensitive
	checkabutton
	setdisabledobjectsto11
	writememory $cc1d, $b0
	writememory wLoadedTreeGfxIndex, $01
	setanimation $06
	setcounter1 $dc
	showtext TX_3d05
	wait 60
	writememory $cc04, $0f
	scriptend

zeldaScript_afterEscapingRoomOfRites:
	loadscript scripts2.zelda_triforceOnHandText

zeldaScript_zeldaKidnapped:
	loadscript scripts2.zelda_kidnapped

script5fe6:
	loadscript scripts2.script_14_49b6

script5fea:
	loadscript scripts2.script_14_49c8

script5fee:
	checkmemoryeq $cfc0, $01
	setanimation $02
	checkmemoryeq $cfc0, $02
	setspeed SPEED_100
	movedown $45
	setanimation $00
	checkmemoryeq $cfc0, $07
	setcoords $8c, $40
	moveup $45
	setanimation $01
	checkmemoryeq $cfc0, $09
	setanimation $02
	checkmemoryeq $cfc0, $0a
	setanimation $01
	checkmemoryeq $cfc0, $0b
	movedown $49
	scriptend

zeldaScript_withAnimalsHopefulText:
	rungenericnpc TX_5010

zeldaScript_blessingBeforeFightingOnox:
	jumpifglobalflagset GLOBALFLAG_TALKED_TO_ZELDA_BEFORE_ONOX_FIGHT, @talkedToZelda
	setdisabledobjectsto11
	setspeed SPEED_100
	setangleandanimation $00
	wait 60
	applyspeed $29
	wait 10
	setspeed SPEED_060
	setangleandanimation $18
	wait 60
	applyspeed $20
	wait 30
	asm15 scriptHelp.forceLinkState8AndSetDirection, DIR_RIGHT
	showtext TX_0607
	asm15 scriptHelp.child_giveHeartRefill
	checkheartdisplayupdated
	wait 30
	setangle $08
	applyspeed $20
	wait 20
	setglobalflag GLOBALFLAG_TALKED_TO_ZELDA_BEFORE_ONOX_FIGHT
	enableinput
@talkedToZelda:
	setcoords $68, $68
	initcollisions
-
	checkabutton
	showtext TX_0608
	asm15 scriptHelp.child_giveHeartRefill
	checkheartdisplayupdated
	scriptjump -

zeldaScript_healLinkIfNeeded:
	initcollisions
	checkabutton
	asm15 scriptHelp.zelda_checkIfLinkFullyHealed
	jumpifobjectbyteeq $7f, $01, @fullyHealedAlready
	showtext TX_050c
	disableinput
	asm15 scriptHelp.child_giveHeartRefill
	checkheartdisplayupdated
	enableinput
	scriptjump @comeBackText
@fullyHealedAlready:
	showtext TX_050d
@comeBackText:
	wait 30
-
	checkabutton
	showtext TX_050e
	scriptjump -


; ==================================================================================================
; INTERAC_TALON
; ==================================================================================================
caveTalonScript:
	writememory $cfde, $00
	writememory $cfdf, $00
	spawninteraction INTERAC_TRADE_ITEM, $08, $68, $48
	initcollisions
-
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_0b38
	jumpiftradeitemeq $07, @haveMegaphone
	wait 30
	showtextlowindex <TX_0b39
	enableallobjects
	scriptjump -
@haveMegaphone:
	wait 30
-
	showtextlowindex <TX_0b3a
	jumpiftextoptioneq $00, @usingMegaphone
	wait 30
	showtextlowindex <TX_0b3c
	enableallobjects
	checkabutton
	setdisabledobjectsto91
	scriptjump -
@usingMegaphone:
	loadscript scripts2.talon_giveMushroomAfterWaking
	
returnedTalonScript:
	rungenericnpclowindex <TX_0b18


; ==================================================================================================
; INTERAC_SYRUP_CUCCO
; ==================================================================================================
syrupCuccoScript_awaitingMushroomText:
	showtext TX_0b3d
	scriptend

syrupCuccoScript_triedToSteal:
	showtext TX_0d09
	scriptend


; ==================================================================================================
; INTERAC_PIRATE_SKULL
; ==================================================================================================
pirateSkullScript_notYetCarried:
	initcollisions
	checkabutton
	jumpifitemobtained TREASURE_PIRATES_BELL, @obtainedPiratesBell
	jumpifroomflagset $40, @canCarrySkull
	showtextlowindex <TX_4d02
	orroomflag $40
	scriptjump @setSubstateff
@canCarrySkull:
	showtextlowindex <TX_4d03
@setSubstateff:
	setsubstate $ff
	scriptend
@obtainedPiratesBell:
	showtextlowindex <TX_4d05
	scriptjump @setSubstateff
	

; ==================================================================================================
; INTERAC_DIN_DANCING_EVENT
; ==================================================================================================
troupeScript1:
	initcollisions
	asm15 scriptHelp.dinDancingEvent_setTextAdd_0a_ifLinked, <TX_0c00
-
	checkabutton
	showloadedtext
	ormemory $cfd3, $01
	scriptjump -

troupeScript2:
	initcollisions
	asm15 scriptHelp.dinDancingEvent_setTextAdd_0a_ifLinked, <TX_0c01
-
	checkabutton
	setdisabledobjectsto11
	cplinkx $48
	setanimationfromobjectbyte $48
	showloadedtext
	ormemory $cfd3, $02
	enableallobjects
	scriptjump -

troupeScript3:
	initcollisions
	asm15 scriptHelp.dinDancingEvent_setTextAdd_0a_ifLinked, <TX_0c02
-
	checkabutton
	showloadedtext
	ormemory $cfd3, $04
	scriptjump -

troupeScript4:
	initcollisions
	asm15 scriptHelp.dinDancingEvent_setTextAdd_0a_ifLinked, <TX_0c03
-
	checkabutton
	showloadedtext
	ormemory $cfd3, $08
	scriptjump -

troupeScript_Impa:
	initcollisions
	asm15 scriptHelp.dinDancingEvent_setTextAdd_0a_ifLinked, <TX_0c04
	checkabutton
	asm15 scriptHelp.dinDancing_spinLink
	showloadedtext
	ormemory $cfd3, $10
	asm15 scriptHelp.dinDancingEvent_setTextAdd_0a_ifLinked, <TX_0c05
-
	checkabutton
	asm15 scriptHelp.dinDancing_spinLink
	showloadedtext
	scriptjump -

troupeScript_stub:
troupeScript_Din:
	setcollisionradii $12, $04
	makeabuttonsensitive
	asm15 scriptHelp.dinDancingEvent_setTextAdd_0a_ifLinked, <TX_0c06
-
	checkabutton
	setanimation $06
	showloadedtext
	ormemory $cfd3, $20
	scriptjump -

troupeScript_startDanceScene:
	setcollisionradii $12, $04
	makeabuttonsensitive
	asm15 scriptHelp.dinDancingEvent_setTextAdd_0a_ifLinked, <TX_0c07
-
	checkabutton
	setdisabledobjectsto11
	setanimation $06
	showloadedtext
	ormemory $cfd3, $40
	orroomflag $40
	scriptjump -

troupeScript_tornadoStart:
	loadscript scripts2.tornadoScript_startDestruction

troupeScript_tornadoEnd:
	loadscript scripts2.tornadoScript_endDestruction

troupeScript_inHoronVillage:
	initcollisions
	settextid TX_3d19
-
	checkabutton
	setdisabledobjectsto11
	cplinkx $48
	setanimationfromobjectbyte $48
	showloadedtext
	wait 8
	writeobjectbyte $48, $01
	setanimationfromobjectbyte $48
	enableallobjects
	scriptjump -


; ==================================================================================================
; INTERAC_DIN_IMPRISONED_EVENT
; ==================================================================================================
dinImprisonedScript_setDinCoords:
	setcoords $53, $82
	scriptend

dinImprisonedScript_OnoxExplainsMotive:
	loadscript scripts2.dinImprisoned_OnoxExplainsMotive

dinImprisonedScript_OnoxSendsTempleDown:
	wait 60
	showtext TX_1e06
	wait 60
	writememory $cfd0, $0f
	scriptend

dinImprisonedScript_OnoxSaysComeIfYouDare:
	loadscript scripts2.dinImprisoned_OnoxSaysComeIfYouDare


; ==================================================================================================
; INTERAC_BIGGORON
; ==================================================================================================
biggoronScript:
	setcollisionradii $22, $20
	makeabuttonsensitive
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @finishedGame
@haventGivenSoup:
	jumpifroomflagset $40, @coldHealed
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
-
	checkabutton
	disableinput
	asm15 scriptHelp.biggoron_loadAnimationData, $0d
	showtextlowindex <TX_0b26
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	jumpiftradeitemeq $04, @haveLavaSoup
	enableinput
	scriptjump -
@haveLavaSoup:
	wait 30
-
	setanimation $02
	asm15 scriptHelp.biggoron_loadAnimationData, $0d
	showtextlowindex <TX_0b27
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	jumpiftextoptioneq $00, @givingSoup
	wait 30
	setanimation $00
	asm15 scriptHelp.biggoron_loadAnimationData, $0d
	showtextlowindex <TX_0b2a
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	enableinput
	checkabutton
	disableinput
	scriptjump -
@givingSoup:
	wait 30
	setanimation $03
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	wait 60
	setanimation $02
	asm15 scriptHelp.biggoron_loadAnimationData, $0c
	wait 60
	asm15 scriptHelp.biggoron_loadAnimationData, $0d
	showtextlowindex <TX_0b28
	disableinput
	giveitem TREASURE_TRADEITEM, $05
	orroomflag $40
@coldHealed:
	disableinput
	setanimation $01
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	enableinput
-
	checkabutton
	disableinput
	asm15 scriptHelp.biggoron_loadAnimationData, $0d
	showtextlowindex <TX_0b29
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	enableinput
	scriptjump -
@finishedGame:
	asm15 scriptHelp.biggoron_checkSoupGiven
	jumpifobjectbyteeq $7f, $00, @haventGivenSoup
	setanimation $01
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	jumpifglobalflagset GLOBALFLAG_DONE_BIGGORON_SECRET, @doneBiggoronSecret
@promptSecret:
	checkabutton
	disableinput
	asm15 scriptHelp.biggoron_loadAnimationData, $0d
	showtextlowindex <TX_0b52
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	jumpiftextoptioneq $00, @biggoronSecretKnown
	wait 30
	asm15 scriptHelp.biggoron_loadAnimationData, $0d
	showtextlowindex <TX_0b53
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	enableinput
	scriptjump @promptSecret
@biggoronSecretKnown:
	wait 30
	asm15 scriptHelp.biggoron_loadAnimationData, $0d
	showtextlowindex <TX_0b54
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	askforsecret BIGGORON_SECRET
	wait 30
	jumptable_memoryaddress $cca3
	.dw @correctSecret
	.dw @incorrectSecret
@incorrectSecret:
	asm15 scriptHelp.biggoron_loadAnimationData, $0d
	showtextlowindex <TX_0b56
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	enableinput
	scriptjump @promptSecret
@correctSecret:
	loadscript scripts2.biggoronScript_giveBiggoronSword
@generateSecret:
	generatesecret BIGGORON_RETURN_SECRET
-
	asm15 scriptHelp.biggoron_loadAnimationData, $0d
	showtextlowindex <TX_0b58
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	wait 30
	jumpiftextoptioneq $00, -
	asm15 scriptHelp.biggoron_loadAnimationData, $0d
	showtextlowindex <TX_0b59
	asm15 scriptHelp.biggoron_loadAnimationData, $0b
	enableinput
@doneBiggoronSecret:
	checkabutton
	disableinput
	scriptjump @generateSecret
	
	
; ==================================================================================================
; INTERAC_HEAD_SMELTER
; ==================================================================================================
headSmelterAtTempleScript:
	initcollisions
-
	checkabutton
	disablemenu
	asm15 scriptHelp.headSmelter_disableScreenTransitions
	jumpifitemobtained TREASURE_BOMB_FLOWER, @haveBombFlower
	showtext TX_2707
	asm15 scriptHelp.headSmelter_enableScreenTransitions
	enablemenu
	scriptjump -
@haveBombFlower:
	loadscript scripts2.headSmelterScript_blowUpRocks
	
headSmelterAtTempleScript_hideFromBomb:
	checkcfc0bit 0
	setstate $04
	setspeed SPEED_200
	moveleft $19
	moveup $11
	checkcfc0bit 1
	setangleandanimation $10
	checkcfc0bit 2
	movedown $21
	scriptend
	
headSmelterAtFurnaceScript:
	jumpifroomflagset $40, @oresAlreadySmelted
	jumpifitemobtained TREASURE_BLUE_ORE, @haveBlueOre
-
	rungenericnpc TX_270a
@haveBlueOre:
	jumpifitemobtained TREASURE_RED_ORE, @haveBothOres
	scriptjump -
@haveBothOres:
	initcollisions
-
	checkabutton
	showtext TX_2a00
	jumpiftextoptioneq $00, @startSmeltingOres
	showtext TX_2a01
	scriptjump -
@startSmeltingOres:
	loadscript scripts2.script_14_4aea
@oresAlreadySmelted:
	rungenericnpc TX_2a05

; coordinate dancing?
script62b1:
	xorcfc0bit 0
	wait 20
	xorcfc0bit 1
	wait 20
	xorcfc0bit 2
	wait 20
	xorcfc0bit 0
	wait 20
	xorcfc0bit 1
	wait 20
	xorcfc0bit 2
	wait 20
	xorcfc0bit 0
	setcounter1 $12
	xorcfc0bit 1
	setcounter1 $12
	xorcfc0bit 2
	setcounter1 $12
	xorcfc0bit 0
	wait 20
	retscript

headSmelterScript_danceMovementText1:
	setspeed SPEED_100
	setstate $04
	moveup $31
	setangleandanimation $10
	setstate $05
	checkcfc0bit 7
	movedown $31
	setstate $01
	rungenericnpc TX_2702

headSmelterScript_danceMovementText2:
	setspeed SPEED_100
	setstate $04
	moveup $11
	moveright $21
	setangleandanimation $10
	setstate $05
	checkcfc0bit 7
	moveleft $21
	movedown $11
	setstate $01
	rungenericnpc TX_2703


; ==================================================================================================
; INTERAC_SUBROSIAN_AT_VOLCANO
; ==================================================================================================
subrosianAtD8Script_tossItemIntoHole:
	callscript @spin2win
	callscript @spin2win
	setspeed SPEED_200
	applyspeed $04
	asm15 scriptHelp.subrosianAtD8_spawnitem
	setangle $18
	applyspeed $04
	scriptend

@spin2win:
	setangleandanimation $00
	wait 4
	setangleandanimation $18
	wait 4
	setangleandanimation $10
	wait 4
	setangleandanimation $08
	wait 4
	retscript

subrosianAtD8Script:
	jumpifroomflagset $80, @alreadyBlewUpVolcano
	orroomflag $80
	disableinput
	playsound SND_SOLVEPUZZLE
	writememory w1Link.direction, $03
	wait 60
	showtext TX_3c01
	enableinput

@alreadyBlewUpVolcano:
	rungenericnpc TX_3c01


; ==================================================================================================
; INTERAC_INGO
; ==================================================================================================
ingoScript_tradingVase:
	initcollisions
	jumpifroomflagset $40, @tradedVase
-
	checkabutton
	setdisabledobjectsto91
	setanimation $05
	showtextlowindex <TX_0b2b
	setanimationfromangle
	jumpiftradeitemeq $05, @haveVase
	enableallobjects
	scriptjump -
@haveVase:
	wait 30
-
	showtextlowindex <TX_0b2c
	jumpiftextoptioneq $00, @tradingVase
	wait 30
	showtextlowindex <TX_0b2f
	enableallobjects
	checkabutton
	setdisabledobjectsto91
	scriptjump -
@tradingVase:
	wait 30
	callscript ingoScript_yahoo
	showtextlowindex <TX_0b51
	wait 30
	showtextlowindex <TX_0b2d
	disableinput
	giveitem TREASURE_TRADEITEM, $06
	spawninteraction INTERAC_MISC_STATIC_OBJECTS, $09, $08, $58
	orroomflag $40
	enableinput
@tradedVase:
	checkabutton
	showtextlowindex $2e
	scriptjump @tradedVase

ingoScript_LinkApproachingVases:
	writeobjectbyte $7e, $01
	setspeed SPEED_200
	moveup $14
	wait 4
	moveleft $11
	writeobjectbyte $7e, $00
	wait 10
	setanimation $05
	showtextlowindex <TX_0b30
	writeobjectbyte $7e, $01
	getrandombits $7f, $01
	jumptable_objectbyte $7f
	.dw @blockEntrance1
	.dw @blockEntrance2
@blockEntrance1:
	moveright $11
	wait 4
	movedown $14
	writeobjectbyte $7e, $00
	enableinput
	scriptend
@blockEntrance2:
	movedown $14
	wait 4
	moveleft $19
	wait 4
	movedown $11
	wait 4
	moveright $19
	wait 4
	moveup $11
	wait 4
	moveright $11
	writeobjectbyte $7e, $00
	enableinput
	scriptend

ingoScript_yahoo:
	asm15 scriptHelp.ingo_animatePlaySound
-
	asm15 scriptHelp.ingo_jump
	wait 1
	jumpifobjectbyteeq $7d, $00, -
	retscript


; ==================================================================================================
; INTERAC_GURU_GURU
; ==================================================================================================
guruGuruScript:
	initcollisions
	jumpifroomflagset $40, @alreadyTradedGrease
-
	checkabutton
	disableinput
	writeobjectbyte $7b, $00
	showtextlowindex <TX_0b48
	jumpiftradeitemeq $0a, @haveGrease
	writeobjectbyte $7b, $01
	enableinput
	scriptjump -
@haveGrease:
	wait 30
-
	showtextlowindex <TX_0b49
	jumpiftextoptioneq $00, @tradingGrease
	wait 30
	showtextlowindex <TX_0b4c
	writeobjectbyte $7b, $01
	enableinput
	checkabutton
	disableinput
	writeobjectbyte $7b, $00
	scriptjump -
@tradingGrease:
	wait 30
	showtextlowindex <TX_0b4a
	disableinput
	cplinkx $48
	addobjectbyte $48, $06
	setanimationfromobjectbyte $48
	giveitem TREASURE_TRADEITEM, $0b
	orroomflag $40
	writeobjectbyte $79, $01
	setcounter1 $32
	writeobjectbyte $7b, $01
	enableinput
@alreadyTradedGrease:
	checkabutton
	disableinput
	writeobjectbyte $7b, $00
	showtextlowindex <TX_0b4b
	writeobjectbyte $7b, $01
	enableinput
	scriptjump @alreadyTradedGrease


; ==================================================================================================
; INTERAC_LOST_WOODS_SWORD
; ==================================================================================================
lostWoodsSwordScript:
	setcollisionradii $0c, $06
	makeabuttonsensitive
	checkabutton
	disableinput
	asm15 objectSetInvisible
	xorcfc0bit 0
	callscript @giveSword
	orroomflag $40
	wait 90
	enableinput
	scriptend
@giveSword:
	jumptable_objectbyte $42
	.dw @giveNobleSword
	.dw @giveMasterSword
@giveNobleSword:
	giveitem TREASURE_SWORD, $01
	giveitem TREASURE_SWORD, $04
	retscript
@giveMasterSword:
	giveitem TREASURE_SWORD, $02
	giveitem TREASURE_SWORD, $05
	retscript


; ==================================================================================================
; INTERAC_BLAINO_SCRIPT
; ==================================================================================================
blainoScript:
	initcollisions
	asm15 scriptHelp.blainoScript_spawnBlaino

@waitUntilSpokenTo:
	asm15 scriptHelp.blainoScript_saveVariables
	asm15 scriptHelp.blainoScript_adjustRupeesInText
	jumpifroomflagset $40, @beatenOnce
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_2300
	jumpiftextoptioneq $00, @acceptedFight
	scriptjump @choseNotToFight

@beatenOnce:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_230a
	jumpiftextoptioneq $00, @acceptedFight
	scriptjump @choseNotToFight

@promptCost:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_2301
	jumpiftextoptioneq $00, @acceptedFight

@choseNotToFight:
	wait 30
	showtextlowindex <TX_2302
	enableallobjects
	scriptjump @promptCost

@acceptedFight:
	wait 30

@checkRupees:
	jumpifobjectbyteeq Interaction.var37, $00, @acceptedWithEnoughRupees

@notEnoughRupees:
	showtextlowindex <TX_2304
	enableallobjects
	checkabutton
	scriptjump @notEnoughRupees

@acceptedWithEnoughRupees:
	disableinput

@rulesExplanation:
	jumpifobjectbyteeq Interaction.var38, $05, @cheatedExplanation
	showtextlowindex <TX_2303
	scriptjump @checkIfUnderstoodRules

@cheatedExplanation:
	showtextlowindex <TX_230d

@checkIfUnderstoodRules:
	jumpiftextoptioneq $00, @beginFight
	wait 30
	scriptjump @rulesExplanation

@beginFight:
	asm15 scriptHelp.blainoScript_takeRupees
	asm15 fadeoutToWhite
	checkpalettefadedone
	setdisabledobjectsto11
	writememory $cced, $01
	asm15 scriptHelp.blainoScript_clearItemsAndPegasusSeeds
	asm15 scriptHelp.blainoScript_setLinkPositionAndState
	asm15 scriptHelp.blainoScript_spawnBlainoEnemy
	asm15 scriptHelp.putAwayLinksItems, $00
	wait 4
	asm15 fadeinFromWhite
	checkpalettefadedone
	showtextlowindex <TX_2305
	playsound SND_DING
	setmusic MUS_MINIBOSS
	enableinput
	scriptend


blainoFightDoneScript:
	disableinput
	wait 20
	playsound SND_DING
	wait 20
	playsound SND_DING
	wait 20
	playsound SND_DING
	wait 90
	asm15 fadeoutToWhite
	checkpalettefadedone
	setdisabledobjectsto11
	asm15 scriptHelp.blainoScript_setBlainoPosition
	asm15 scriptHelp.blainoScript_setLinkPositionAndState
	wait 4
	asm15 fadeinFromWhite
	checkpalettefadedone
	resetmusic
	writeobjectbyte Interaction.pressedAButton, $00
	jumptable_memoryaddress $ccec
	.dw @fightWon
	.dw @fightWon
	.dw @fightLost
	.dw @cheated

@fightWon:
	jumpifroomflagset $40, @give30Rupees
	showtextlowindex <TX_2306
	giveitem TREASURE_RICKY_GLOVES, $00
	orroomflag $40
	enableinput
	scriptjump @finishedTalking

@give30Rupees:
	showtextlowindex <TX_230b
	asm15 scriptHelp.blainoScript_give30Rupees
	enableinput

@finishedTalking:
	checkabutton
	scriptjump blainoScript@waitUntilSpokenTo

@fightLost:
	showtextlowindex <TX_2308
	jumpiftextoptioneq $00, @rematch
	scriptjump @declinedRematch

@cheated:
	setglobalflag GLOBALFLAG_CHEATED_BLAINO

@cheatedText:
	showtextlowindex <TX_2309
	jumpiftextoptioneq $00, @rematch
	scriptjump @declinedRematchAfterCheating

@rematch:
	asm15 scriptHelp.blainoScript_saveVariables
	enableinput
	scriptjump blainoScript@checkRupees

@declinedRematch:
	wait 30
	showtextlowindex <TX_2302
	wait 30
	enableinput
	checkabutton
	disableinput
	scriptjump @fightLost

@declinedRematchAfterCheating:
	wait 30
	showtextlowindex <TX_2302
	wait 30
	enableinput
	checkabutton
	disableinput
	scriptjump @cheatedText


; ==================================================================================================
; INTERAC_LOST_WOODS_DEKU_SCRUB
; ==================================================================================================
lostWoodsDekuScrubScript:
	setcollisionradii $20, $30
	checkcollidedwithlink_onground
	setdisabledobjectsto91
	setcollisionradii $06, $06
	writeobjectbyte $77, $01
	setanimation $01
	checkobjectbyteeq $61, $ff
	writeobjectbyte $77, $02
	jumpiftradeitemeq $0b, @havePhonograph
	showtextlowindex <TX_0b4d
--
	writeobjectbyte $77, $03
	setanimation $03
	checkobjectbyteeq $61, $ff
	writeobjectbyte $77, $00
	enableallobjects
	scriptend
@havePhonograph:
	showtextlowindex <TX_0b4e
	wait 30
	showtextlowindex <TX_0b4f
	jumpiftextoptioneq $00, @playingPhonograph
	scriptjump --
@playingPhonograph:
	wait 30
	writeobjectbyte $77, $04
	setanimation $04
	writeobjectbyte $4f, $ff
	showtextlowindex <TX_0b50
	checkobjectbyteeq $61, $ff
	writeobjectbyte $4f, $00
	scriptjump --


; ==================================================================================================
; INTERAC_LAVA_SOUP_SUBROSIAN
; ==================================================================================================
lavaSoupSubrosianScript:
	initcollisions
	jumpifroomflagset $40, @filledPot
-
	checkabutton
	showtextlowindex <TX_0b1f
	jumpiftradeitemeq $03, @havePot
	scriptjump -
@havePot:
	setdisabledobjectsto91
	wait 30
-
	showtextlowindex <TX_0b20
	jumpiftextoptioneq $00, @fillingPot
	wait 30
	showtextlowindex <TX_0b25
	enableallobjects
	checkabutton
	setdisabledobjectsto91
	scriptjump -
@fillingPot:
	loadscript scripts2.lavaSoupSubrosianScript_fillPot
@filledPot:
	checkabutton
	showtextlowindex <TX_0b24
	scriptjump @filledPot
	
	
; ==================================================================================================
; INTERAC_D8_ARMOS_PATTERN_PUZZLE
; ==================================================================================================
d8ArmosScript_pattern1:
	setspeed SPEED_080
	wait 30
	setangle $00
	applyspeed $40
	setangle $08
	applyspeed $20
	setangle $00
	applyspeed $20
	setangle $18
	applyspeed $60
	setangle $00
	applyspeed $a0
	setangle $08
	applyspeed $20
	setangle $10
	applyspeed $20
	setangle $08
	applyspeed $20
	setangle $00
	applyspeed $20

d8Armos_finishedMoving:
	wait 30
	createpuff
	enableallobjects
	asm15 setCameraFocusedObjectToLink
	setstate $03
	scriptend
	
d8ArmosScript_pattern2:
	setspeed SPEED_080
	wait 30
	setangle $00
	applyspeed $40
	setangle $08
	applyspeed $20
	setangle $00
	applyspeed $60
	setangle $18
	applyspeed $60
	setangle $00
	applyspeed $60
	setangle $08
	applyspeed $40
	scriptjump d8Armos_finishedMoving
	
d8ArmosScript_pattern3:
	setspeed SPEED_080
	wait 30
	setangle $18
	applyspeed $40
	setangle $00
	applyspeed $20
	setangle $08
	applyspeed $60
	setangle $00
	applyspeed $20
	setangle $18
	applyspeed $60
	setangle $00
	applyspeed $a0
	setangle $08
	applyspeed $60
	setangle $00
	applyspeed $20
	setangle $18
	applyspeed $20
	scriptjump d8Armos_finishedMoving
	
d8ArmosScript_pattern4:
	setspeed SPEED_080
	wait 30
	setangle $00
	applyspeed $80
	setangle $18
	applyspeed $20
	setangle $10
	applyspeed $40
	setangle $08
	applyspeed $40
	setangle $00
	applyspeed $20
	setangle $18
	applyspeed $60
	setangle $00
	applyspeed $a0
	setangle $08
	applyspeed $40
	scriptjump d8Armos_finishedMoving

d8ArmosScript_giveKey:
	setcoords $58, $b8
	spawnitem TREASURE_SMALL_KEY, $01
	scriptend


; ==================================================================================================
; INTERAC_DANCE_HALL_MINIGAME
; ==================================================================================================
dancecLeaderScript_promptToStartDancing:
	initcollisions
	jumpifroomflagset $80, @dancedBefore
	checkabutton
	showtext TX_0100
	jumpiftextoptioneq $00, @beginDance
	showtext TX_0103
@dancedBefore:
	checkabutton
	showtext TX_0101
	jumpiftextoptioneq $00, @beginDance
	showtext TX_0103
	scriptjump @dancedBefore
@beginDance:
	loadscript scripts2.danceLeaderScript_moveIntoPosition

danceLeaderScript_promptForTutorial:
	showtext TX_0115
	jumpiftextoptioneq $01, @needTutorial
@danceLeaderScript_readyToDance:
	asm15 fastFadeoutToWhite
	setsubstate $ff
	scriptend
@needTutorial:
	loadscript scripts2.danceLeaderScript_danceTutorial

danceLeaderScript_boomerang:
	giveitem TREASURE_BOOMERANG, $00
	scriptjump danceLeaderScript_itemGiven

danceLeaderScript_giveFlute:
	giveitem TREASURE_FLUTE, $00
	scriptjump danceLeaderScript_itemGiven

danceLeaderScript_gashaSeed:
	giveitem TREASURE_GASHA_SEED, $00
	scriptjump danceLeaderScript_itemGiven

danceLeaderScript_giveOreChunks:
	giveitem TREASURE_ORE_CHUNKS, $00

danceLeaderScript_itemGiven:
	wait 30
	resetmusic
	enableinput
	setsubstate $ff

danceLeaderScript_showLoadedText:
	initcollisions
-
	checkabutton
	showloadedtext
	scriptjump -


; ==================================================================================================
; INTERAC_MISCELLANEOUS_1
; ==================================================================================================
subrosianScript_templeFallenText:
	rungenericnpc TX_3e03

floodgateKeeperScript:
	initcollisions
	asm15 scriptHelp.floodgateKeeper_checkStage
	jumptable_memoryaddress $cfc1
	.dw @noFloodgateKey
	.dw @gotFloodgateKey
	.dw @floodgateKeyUsed
	.dw @bit7OfRoomFlagSet
@noFloodgateKey:
	jumpifroomflagset $20, @noFloodgateKey_body
@noFloodgateKey_body:
	checkabutton
	jumpifitemobtained TREASURE_FLOODGATE_KEY, @gotFloodgateKey
	setanimation $01
	showtext TX_2400
	setanimation $00
	scriptjump @noFloodgateKey_body
@gotFloodgateKey:
	checkabutton
	setanimation $01
	showtext TX_2402
	setanimation $00
	scriptjump @gotFloodgateKey
@floodgateKeyUsed:
	checkabutton
	orroomflag $80
	setanimation $01
	showtext TX_2403
	setanimation $00
	wait 30
@bit7OfRoomFlagSet:
	checkabutton
	setanimation $01
	showtext $2404 ; TODO: why is TX_2404 not defined?
	setanimation $00
	scriptjump @bit7OfRoomFlagSet
	
floodgateKeyScript_keeperNoticesKey:
	showtext TX_2401
	enableinput
	scriptend

floodgateSwitchScript:
	checkmemoryeq wSwitchState, $01
	asm15 scriptHelp.floodgate_disableObjectsScreenTransition
	wait 8
	disableinput
	wait 30
	playsound SND_FLOODGATES
	asm15 objectSetVisible
	wait 60
	asm15 objectSetInvisible
	orroomflag $40
	settilehere $aa
	playsound SNDCTRL_STOPSFX
	playsound SND_SOLVEPUZZLE
	asm15 scriptHelp.floodgate_enableObjects
	enableinput
	scriptend

floodgateKeyholeScript_keyEntered:
	checkcfc0bit 0
	disableinput
	wait 60
	playsound SNDCTRL_STOPMUSIC
	shakescreen 120
	wait 60
	writememory $d008, $01
	orroomflag $80
	spawninteraction INTERAC_MISCELLANEOUS_1, $14, $00, $00
	incstate
	scriptend

d4KeyholeScript_disableThingsAndScreenShake:
	checkcfc0bit 0
	asm15 scriptHelp.d4Keyhole_setState0eDisableAllSorts
	playsound SNDCTRL_STOPMUSIC
	wait 60
	playsound SND_RUMBLE2
	shakescreen 255
	wait 60
	writememory $d008, $02
	orroomflag $80
	scriptend

masterDiverPuzzleScript_solved:
	disableinput
	playsound SND_SOLVEPUZZLE
	settilehere $53
	createpuff
	orroomflag $40
	enableinput
	scriptend

tarmArmosUnlockingStairsScript:
	orroomflag $40
	wait 30
	playsound SND_SOLVEPUZZLE
	wait 20
	setcoords $08, $28
	createpuff
	settilehere TILEINDEX_STAIRS
	settileat $01, $6b
	settileat $03, $45
	scriptend

piratesBellRoomDroppingInScript:
	wait 30
	showtext TX_4d08
	xorcfc0bit 0
	enableinput
	scriptend


; ==================================================================================================
; INTERAC_ROSA_HIDING
; ==================================================================================================
rosaHidingScript_1stScreen:
	jumpifroomflagset $40, @seenRosaOnce
	loadscript scripts2.rosaHidingScript_firstEncounterIntro
@seenRosaOnce:
	loadscript scripts2.rosaHidingScript_secondEncounterOnwardsIntro
rosaHidingScript_afterInitialScreenText:
	xorcfc0bit 0
	asm15 scriptHelp.subrosianHiding_store02Intocc9e
	setsubstate $03
	moveup $30
	enableinput
	scriptend

rosaHidingScript_2ndScreen:
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setsubstate $04
	setspeed SPEED_100
	jumprandom @pattern1, @pattern2
@pattern1:
	loadscript scripts2.rosaHidingScript_2ndScreenPattern1
@pattern2:
	loadscript scripts2.rosaHidingScript_2ndScreenPattern2

rosaHidingScript_3rdScreen:
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setsubstate $04
	setspeed SPEED_100
	jumprandom @pattern1, @pattern2
@pattern1:
	loadscript scripts2.rosaHidingScript_3rdScreenPattern1
@pattern2:
	loadscript scripts2.rosaHidingScript_3rdScreenPattern2
	
rosaHidingScript_4thScreen:
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setsubstate $04
	setspeed SPEED_100
	jumprandom @pattern1, @pattern2
@pattern1:
	loadscript scripts2.rosaHidingScript_4thScreenPattern1
@pattern2:
	loadscript scripts2.rosaHidingScript_4thScreenPattern2
rosaHidingScript_pokeBackOut:
	loadscript scripts2.rosaHidingScript_pokeBackOut_body
	
rosaHidingScript_portalScreen:
	loadscript scripts2.rosaHidingScript_portalScreen_body
	
rosaHidingScript_caught:
	loadscript scripts2.rosaHidingScript_caught_body

rosaHidingScript_lookDownLeftRight:
	wait 30
	setangleandanimation $10
	wait 30
	setangleandanimation $18
	wait 30
	setangleandanimation $08
	wait 30
	retscript
	
rosaHidingScript_lookLeftUpDown:
	wait 30
	setangleandanimation $18
	wait 30
	setangleandanimation $00
	wait 30
	setangleandanimation $10
	wait 30
	retscript
	
rosaHidingScript_lookUpRightLeft:
	wait 30
	setangleandanimation $00
	wait 30
	setangleandanimation $08
	wait 30
	setangleandanimation $18
	wait 30
	retscript
	
rosaHidingScript_lookRightDownUp:
	wait 30
	setangleandanimation $08
	wait 30
	setangleandanimation $10
	wait 30
	setangleandanimation $00
	wait 30
	retscript


; ==================================================================================================
; INTERAC_STRANGE_BROTHERS_HIDING
; ==================================================================================================
strangeBrother1Script_1stScreen:
	jumptable_memoryaddress $cfd0
	.dw @halfChanceWhenFeatherNotGotten
	.dw @otherPattern
@halfChanceWhenFeatherNotGotten:
	setcoords $18, $48
	setangleandanimation $18
	callscript strangeBrother1Script_1stScreenInit
	moveleft $30
	callscript strangeBrotherScript_lookRightLeftUpDown
	movedown $60
	callscript strangeBrotherScript_lookUpDownRightLeft
	movedown $20
	xorcfc0bit 0
	scriptend
@otherPattern:
	setcoords $48, $18
	setangleandanimation $00
	callscript strangeBrother1Script_1stScreenInit
	moveup $30
	callscript strangeBrotherScript_lookDownUpRightLeft
	moveright $30
	movedown $10
	moveright $10
	callscript strangeBrotherScript_lookLeftRightUpDown
	movedown $50
	callscript strangeBrotherScript_lookUpDownRightLeft
	movedown $20
	xorcfc0bit 0
	scriptend
	
strangeBrother1Script_1stScreenInit:
	jumpifglobalflagset GLOBALFLAG_JUST_CAUGHT_BY_STRANGE_BROTHERS, +
strangeBrotherScript_1stScreenInit:
	asm15 scriptHelp.subrosianHiding_store02Intocc9e
	wait 60
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	retscript
+
	disableinput
	showtext TX_2805
	showtext TX_2806
	enableinput
	xorcfc0bit 0
	scriptjump strangeBrotherScript_1stScreenInit
	
toStrangeBrotherScript_1stScreenInit:
	jumpifglobalflagset GLOBALFLAG_JUST_CAUGHT_BY_STRANGE_BROTHERS, @seenBefore
	scriptjump strangeBrotherScript_1stScreenInit
@seenBefore:
	checkcfc0bit 0
	scriptjump strangeBrotherScript_1stScreenInit

strangeBrother1Script_2ndScreen:
	jumptable_memoryaddress $cfd0
	.dw @pattern1
	.dw @pattern2
@pattern1:
	setcoords $28, $78
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $10
	wait 60
	movedown $30
	callscript strangeBrotherScript_lookUpDownRightLeft
	wait 180
	moveleft $30
	moveup $30
	callscript strangeBrotherScript_lookUpDownRightLeft
	moveright $30
	movedown $30
	wait 120
	moveleft $10
	movedown $20
	callscript strangeBrotherScript_lookUpDownRightLeft
	movedown $20
	xorcfc0bit 0
	scriptend
@pattern2:
	setcoords $78, $28
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $18
	wait 60
	moveleft $10
	moveup $30
	setcounter1 $96
	moveright $20
	callscript strangeBrotherScript_lookLeftRightUpDown
	moveup $30
	moveleft $20
	callscript strangeBrotherScript_lookRightLeftUpDown
	wait 120
	moveright $30
	movedown $60
	callscript strangeBrotherScript_lookUpDownRightLeft
	movedown $20
	xorcfc0bit 0
	scriptend
	
strangeBrother1Script_3rdScreen:
	jumptable_memoryaddress $cfd0
	.dw @pattern1
	.dw @pattern2
@pattern1:
	setcoords $38, $78
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $18
	wait 60
	moveleft $60
	callscript strangeBrotherScript_lookRightLeftUpDown
	moveup $20
	callscript strangeBrotherScript_lookDownUpRightLeft
	moveup $10
	moveright $40
	movedown $30
	callscript strangeBrotherScript_lookUpDownRightLeft
	moveleft $40
	movedown $10
	moveleft $30
	xorcfc0bit 0
	scriptend
@pattern2:
	setcoords $38, $48
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $18
	setcounter1 $7a
	setangleandanimation $10
	setcounter1 $3e
	setangleandanimation $08
	setcounter1 $3e
	setangleandanimation $00
	setcounter1 $3e
	moveleft $30
	movedown $10
	moveleft $30
	xorcfc0bit 0
	scriptend
	
strangeBrother1Script_4thScreen:
	jumptable_memoryaddress $cfd0
	.dw @pattern1
	.dw @pattern2
@pattern1:
	setcoords $38, $38
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $18
	wait 60
	moveleft $20
	callscript strangeBrotherScript_lookRightLeftUpDown
	moveup $20
	moveright $30
	moveright $30
	moveup $10
	callscript strangeBrotherScript_lookDownUpRightLeft
	moveup $20
	xorcfc0bit 0
	scriptend
@pattern2:
	setcoords $18, $18
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $10
	wait 60
	movedown $30
	callscript strangeBrotherScript_lookUpDownRightLeft
	moveright $50
	callscript strangeBrotherScript_lookLeftRightUpDown
	moveup $10
	moveright $20
	callscript strangeBrotherScript_lookLeftRightUpDown
	moveup $50
	xorcfc0bit 0
	scriptend
	
strangeBrother1Script_5thScreen:
	jumptable_memoryaddress $cfd0
	.dw @pattern1
	.dw @pattern2
@pattern1:
	setcoords $08, $48
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $08
	wait 60
	moveright $40
	movedown $10
	callscript strangeBrotherScript_lookUpDownRightLeft
	movedown $20
	moveleft $60
	callscript strangeBrotherScript_lookLeftRightUpDown
	moveup $30
	moveright $40
	callscript strangeBrotherScript_lookRightLeftUpDown
	moveup $20
	xorcfc0bit 0
	scriptend
@pattern2:
	setcoords $08, $78
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $18
	wait 60
	movedown $60
	callscript strangeBrotherScript_lookUpDownRightLeft
	moveleft $30
	callscript strangeBrotherScript_lookRightLeftUpDown
	moveup $30
	callscript strangeBrotherScript_lookDownUpRightLeft
	moveright $40
	callscript strangeBrotherScript_lookLeftRightUpDown
	moveup $50
	xorcfc0bit 0
	scriptend
	
strangeBrother1Script_6thScreen:
	jumptable_memoryaddress $cfd0
	.dw @pattern1
	.dw @pattern2
@pattern1:
	setcoords $18, $18
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $10
	wait 60
	movedown $60
	callscript strangeBrotherScript_lookUpDownRightLeft
	moveright $30
	callscript strangeBrotherScript_lookLeftRightUpDown
	moveup $30
	moveleft $10
	moveup $30
	callscript strangeBrotherScript_lookDownUpRightLeft
	moveleft $20
	movedown $80
	xorcfc0bit 0
	scriptend
@pattern2:
	setcoords $18, $18
	asm15 scriptHelp.subrosianHiding_createDetectionHelper
	setangleandanimation $10
	wait 60
	movedown $30
	moveright $30
	callscript strangeBrotherScript_lookLeftRightUpDown
	movedown $30
	callscript strangeBrotherScript_lookUpDownRightLeft
	moveleft $30
	moveup $30
	moveright $30
	movedown $50
	xorcfc0bit 0
	scriptend

strangeBrother1Script_finishedScreen:
	disableinput
	setcoords $48, $18
	setanimation $01
	playsound SND_SOLVEPUZZLE
	checkflagset $00, $cd00
	asm15 scriptHelp.strangeBrothersFunc_15_5d9a
	wait 60
	showtext TX_2803
	xorcfc0bit 0
	movedown $50
	resetmusic
	spawninteraction INTERAC_MISCELLANEOUS_1, $16, $48, $28
	asm15 scriptHelp.strangeBrothersFunc_15_5dc4
	enableinput
	scriptend

strangeBrother2Script_1stScreen:
	jumptable_memoryaddress $cfd0
	.dw @halfChanceWhenFeatherNotGotten
	.dw @otherPattern
@halfChanceWhenFeatherNotGotten:
	setcoords $28, $18
	setangleandanimation $10
	callscript toStrangeBrotherScript_1stScreenInit
	loadscript scripts2.strangeBrother2Script_1stScreenPattern1
@otherPattern:
	setcoords $48, $28
	setangleandanimation $00
	callscript toStrangeBrotherScript_1stScreenInit
	loadscript scripts2.strangeBrother2Script_1stScreenPattern2

strangeBrother2Script_2ndScreen:
	jumptable_memoryaddress $cfd0
	.dw @pattern1
	.dw @pattern2
@pattern1:
	loadscript scripts2.strangeBrother2Script_2ndScreenPattern1
@pattern2:
	loadscript scripts2.strangeBrother2Script_2ndScreenPattern2
	
strangeBrother2Script_3rdScreen:
	jumptable_memoryaddress $cfd0
	.dw @pattern1
	.dw @pattern2
@pattern1:
	loadscript scripts2.strangeBrother2Script_3rdScreenPattern1
@pattern2:
	loadscript scripts2.strangeBrother2Script_3rdScreenPattern2
	
strangeBrother2Script_4thScreen:
	jumptable_memoryaddress $cfd0
	.dw @pattern1
	.dw @pattern2
@pattern1:
	loadscript scripts2.strangeBrother2Script_4thScreenPattern1
@pattern2:
	loadscript scripts2.strangeBrother2Script_4thScreenPattern2
	
strangeBrother2Script_5thScreen:
	jumptable_memoryaddress $cfd0
	.dw @pattern1
	.dw @pattern2
@pattern1:
	loadscript scripts2.strangeBrother2Script_5thScreenPattern1
@pattern2:
	loadscript scripts2.strangeBrother2Script_5thScreenPattern2
	
strangeBrother2Script_6thScreen:
	jumptable_memoryaddress $cfd0
	.dw @pattern1
	.dw @pattern2
@pattern1:
	loadscript scripts2.strangeBrother2Script_6thScreenPattern1
@pattern2:
	loadscript scripts2.strangeBrother2Script_6thScreenPattern2
	
strangeBrother2Script_finishedScreen:
	loadscript scripts2.strangeBrother2Script_finishedScreenPattern2
	
strangeBrotherScript_lookDownUpRightLeft:
	setangleandanimation $10
	wait 30
	setangleandanimation $00
	wait 30
--
	setangleandanimation $08
	wait 30
	setangleandanimation $18
	wait 30
	retscript
	
strangeBrotherScript_lookUpDownRightLeft:
	setangleandanimation $00
	wait 30
	setangleandanimation $10
	wait 30
	scriptjump --
	
strangeBrotherScript_lookRightLeftUpDown:
	setangleandanimation $08
	wait 30
	setangleandanimation $18
	wait 30
--
	setangleandanimation $00
	wait 30
	setangleandanimation $10
	wait 30
	retscript
	
strangeBrotherScript_lookLeftRightUpDown:
	setangleandanimation $18
	wait 30
	setangleandanimation $08
	wait 30
	scriptjump --


; ==================================================================================================
; INTERAC_STEALING_FEATHER
; ==================================================================================================
stealingFeatherScript:
	setcollisionradii $12, $30
	checkcollidedwithlink_onground
	disableinput
	asm15 scriptHelp.stealingFeather_putLinkOnGround
	playsound SND_WHISTLE
	wait 8
	playsound SND_WHISTLE
	wait 30
	writememory $d008, $03
	wait 30
	writememory $d008, $01
	setmusic MUS_HIDE_AND_SEEK
	asm15 scriptHelp.stealingFeather_spawnStrangeBrothers
	xorcfc0bit 0
	wait 20
	writememory $d008, $01
	checkcfc0bit 1
	playsound SND_SCENT_SEED
	asm15 scriptHelp.stealingFeather_spawnSelfWithSubId0
	setspeed SPEED_100
	setangle $04
	incstate
	
	
; ==================================================================================================
; INTERAC_HOLLY
; ==================================================================================================
hollyScript_enteredFromChimney:
	initcollisions
	wait 120
	setzspeed -$0100
	jumpifroomflagset $20, hollyScript_shovelGiven
	scriptjump hollyScript_shovelNotYetGiven
	
hollyScript_enteredNormally:
	initcollisions
	jumpifroomflagset $20, hollyScript_shovelGiven
hollyScript_shovelNotYetGiven:
	checkabutton
	showtext TX_2c00
	disableinput
	giveitem TREASURE_SHOVEL, $00
	enablemenu
hollyScript_shovelGiven:
	enableallobjects
	checkabutton
	setdisabledobjectsto91
	jumpifglobalflagset GLOBALFLAG_ALL_HOLLYS_SNOW_SHOVELLED, @snowAlreadyShovelled
	showtext TX_2c01
	scriptjump hollyScript_shovelGiven
@snowAlreadyShovelled:
	showtext TX_2c02
	scriptjump hollyScript_shovelGiven


; ==================================================================================================
; INTERAC_COMPANION_SCRIPTS
; ==================================================================================================
companionScript_mooshInSpoolSwamp:
	jumpifc6xxset <wMooshState, $02, @talkedToMooshAfterSavingHere
	jumpifc6xxset <wMooshState, $01, @savedMooshHere
	jumpifmemoryset $d13e, $04, +
	scriptjump companionScript_mooshInSpoolSwamp
+
	disablemenu
	writeobjectbyte $5a, $00
-
	jumpifmemoryset $d13e, $20, +
	scriptjump -
+
	checkmemoryeq $d12b, $00
	asm15 scriptHelp.seasonsFunc_15_5e91
	checkmemoryeq $d115, $00
	writememory $d106, $20
	checkmemoryeq $d106, $00
	asm15 scriptHelp.seasonsFunc_15_5ea6
	checkflagset $07, $d121
@savedMooshHere:
	writememory $d103, $05
	writememory $d13f, $03
	enablemenu
	checkmemoryeq $d13d, $01
	disablemenu
	writememory $d13d, $00
	jumpifmemoryeq wIsLinkedGame, $00, @unlinked1
	showtext TX_2214
	scriptjump @talkedToMooshAfterSavingHere
@unlinked1:
	disablemenu
	showtext TX_220a
@talkedToMooshAfterSavingHere:
	disablemenu
	writememory $d13f, $03
	writememory $d103, $06
	ormemory wMooshState, $02
	checkflagset $02, wMooshState
	writememory $d13f, $03
	writememory $d103, $06
	writememory $d13d, $00
	checkmemoryeq $d13d, $01
	disablemenu
	jumpifmemoryeq wIsLinkedGame, $00, @unlinked2
	showtext TX_2215
	writeobjectbyte $44, $02
	showtext TX_003a
	scriptjump +
@unlinked2:
	showtext TX_220d
	writeobjectbyte $44, $02
	showtext TX_006a
+
	showtext TX_2213
	ormemory wMooshState, $20
	checkmemoryeq $cc48, $d1
	showtext TX_2212
	enablemenu
	enableallobjects
	scriptend

companionScript_RickyInNorthHoron:
	checkmemoryeq $d13d, $01
	disablemenu
	setdisabledobjectsto11
	jumpifitemobtained TREASURE_RICKY_GLOVES, @hasRickysGloves
	enablemenu
	jumpifmemoryeq wIsLinkedGame, $00, @unlinked
	jumpifmemoryset wRickyState, $10, @talkedToRickyBefore
	showtext TX_200a
	scriptjump @next
@talkedToRickyBefore:
	showtext TX_200b
	scriptjump @next
@unlinked:
	showtext TX_2000
@next:
	writememory $d13d, $00
	ormemory wRickyState, $10
	enableallobjects
	scriptjump companionScript_RickyInNorthHoron
@hasRickysGloves:
	jumpifmemoryeq wIsLinkedGame, $00, @unlinked2
	jumpifmemoryset wRickyState, $10, @talkedToRickyBefore2
	showtext TX_200a
	scriptjump @next2
@talkedToRickyBefore2:
	showtext TX_200b
	scriptjump @next2
@unlinked2:
	showtext TX_2000
@next2:
	wait 30
	showtext TX_2001
	wait 30
	writememory $d13d, $00
	jumpifmemoryeq wAnimalCompanion, $0b, @RickyIsCompanion
	showtext TX_2002
	writeobjectbyte $44, $02
	scriptjump @last
@RickyIsCompanion:
	jumpifmemoryeq wIsLinkedGame, $00, @unlinked3
	showtext TX_200c
	scriptjump +
@unlinked3:
	showtext TX_2006
+
	writeobjectbyte $44, $02
	showtext TX_0038
	showtext TX_2008
@last:
	writememory $d103, $01
	checkmemoryeq $cc48, $d1
	showtext TX_2005
	enableallobjects
	scriptend

companionScript_RickyLeavingYouInSpoolSwamp:
	disablemenu
	writememory $d13f, $01
	jumpifmemoryset $d13e, $01, +
	scriptjump companionScript_RickyLeavingYouInSpoolSwamp
+
	writememory $d108, $03
	setcounter1 $10
	writememory $d13f, $08
	writememory $d103, $04
-
	jumpifmemoryset $d13e, $02, +
	scriptjump -
+
	asm15 scriptHelp.seasonsFunc_15_5eb4
	enableallobjects
	checkmemoryeq $cc77, $00
	writememory $d008, $01
	setdisabledobjectsto11
	writememory $d103, $05
	setcounter1 $10
	showtext TX_2003
	setdisabledobjectsto11
	asm15 scriptHelp.seasonsFunc_15_5ec7
-
	jumpifmemoryset $d13e, $04, +
	scriptjump -
+
	writememory $d108, $00
	writememory $d13f, $18
	writememory $d103, $07
	setcounter1 $96
	writememory $d108, $02
	writememory $d13f, $03
	writememory $d103, $06
	enablemenu
	scriptend

companionScript_dimitriInSpoolSwamp:
	checkmemoryeq $d13d, $01
	jumpifmemoryset wDimitriState, $08, +
	showtext TX_2103
	writememory $d13d, $00
	scriptjump companionScript_dimitriInSpoolSwamp
+
	disablemenu
	jumpifmemoryeq wIsLinkedGame, $00, @unlinked
	showtext TX_2115
	writeobjectbyte $44, $02
	showtext TX_0039
	scriptjump companionScript_dimitriTutorial
@unlinked:
	showtext TX_210b
	writeobjectbyte $44, $02
	showtext TX_0069
companionScript_dimitriTutorial:
	showtext TX_211f
	writememory $d126, $06
	writememory $d127, $08
	ormemory wDimitriState, $80
	checkmemoryeq $cc48, $d1
	showtext TX_211d
	enableallobjects
	enablemenu
	scriptend

companionScript_dimitriBeingBullied:
	checkmemoryeq $d13d, $01
	jumpifmemoryset wDimitriState, $08, +
	showtext TX_2103
	writememory $d13d, $00
	scriptjump companionScript_dimitriBeingBullied
+
	disablemenu
	showtext TX_2120
	scriptjump companionScript_dimitriTutorial

companionScript_mooshEnteringSunkenCity:
	writememory $d13f, $14
	writememory $d108, $00
	checkpalettefadedone
	disablemenu
	writememory $d103, $09
-
	jumpifmemoryset $d13e, $01, +
	scriptjump -
+
	writememory $d13f, $16
	setcounter1 $20
	writememory $d13f, $14
	setcounter1 $20
	writememory $d13f, $16
	setcounter1 $20
	writememory $d13f, $14
	setcounter1 $20
	writememory $d13f, $16
	setcounter1 $20
	ormemory $d13e, $02
	scriptend

companionScript_mooshInMtCucco:
	checkmemoryeq $d13d, $01
	jumptable_objectbyte $78
	.dw @noSpringBanana
	.dw @hasSpringBanana
@hasSpringBanana:
	showtext TX_2211
	writeobjectbyte $44, $02
	asm15 scriptHelp.seasonsFunc_15_5ede
	jumptable_objectbyte $7b
	.dw @mooshIsNotCompanion
	.dw @mooshIsCompanion
@mooshIsCompanion:
	showtext TX_2219
	scriptjump +
@mooshIsNotCompanion:
	showtext TX_2216
+
	writememory wMooshState, $80
	enableallobjects
	checkmemoryeq $cc48, $d1
	jumptable_objectbyte $7b
	.dw @mooshIsNotCompanion2
	.dw @mooshIsCompanion2
@mooshIsNotCompanion2:
	showtext TX_2212
@mooshIsCompanion2:
	enablemenu
	scriptend
@noSpringBanana:
	showtext TX_2210
	writememory $d13d, $00
	enableallobjects
	enablemenu
	scriptjump companionScript_mooshInMtCucco


; ==================================================================================================
; INTERAC_ANIMAL_MOBLIN_BULLIES
; ==================================================================================================
moblinBulliesScript_dimitriBully1BeforeSaving:
	writememory $ccab, $01
	makeabuttonsensitive
	jumpifc6xxset <wDimitriState, $04, @promptForPayment
	disablemenu
	setdisabledobjectsto11
	writememory $ccab, $00
	callscript moblinBulliesScript_hop
@animalBulliedInitDone:
	jumptable_objectbyte $77
	.dw @animalBulliedInitDone
	.dw @next
@next:
	showtext TX_2100
	ormemory wDimitriState, $01
	setangleandanimation $00
	checkabutton
	showtextnonexitable TX_2104
	jumpiftextoptioneq $00, @paying50Rupees
@notPayingRupees:
	showtext TX_2107
	scriptjump @promptForPayment
@notEnoughRupees:
	showtext TX_211b
@promptForPayment:
	writememory $ccab, $00
	setangleandanimation $00
	jumpifglobalflagset GLOBALFLAG_PAID_50_RUPEES_TO_DIMITRI_BULLIES, @paid50Rupees
	checkabutton
	showtextnonexitable TX_2104
	jumpiftextoptioneq $00, @paying50Rupees
	scriptjump @notPayingRupees
@paying50Rupees:
	jumptable_objectbyte $79
	.dw @notEnoughRupees
	.dw @have50Rupees
@paid50Rupees:
	checkabutton
	showtextnonexitable TX_2106
	scriptjump +
@have50Rupees:
	setglobalflag GLOBALFLAG_PAID_50_RUPEES_TO_DIMITRI_BULLIES
	writeobjectbyte $7a, $0b
	showtextnonexitable TX_2106
+
	jumpiftextoptioneq $00, @paying30MoreRupees
	scriptjump @notPayingRupees
@paying30MoreRupees:
	jumptable_objectbyte $78
	.dw @notEnoughRupees
	.dw @haveTheLastRupees
@haveTheLastRupees:
	writeobjectbyte $7a, $07
	disablemenu
	showtext TX_2108
	setdisabledobjectsto11
	ormemory wDimitriState, $08
	scriptend

moblinBulliesScript_dimitriBully2BeforeSaving:
	makeabuttonsensitive
-
	jumpifc6xxset <wDimitriState, $04, @boughtDimitri
	jumpifc6xxset <wDimitriState, $01, +
	scriptjump -
+
	callscript moblinBulliesScript_hop
-
	jumptable_objectbyte $77
	.dw -
	.dw +
+
	showtext TX_2101
	setdisabledobjectsto11
	ormemory wDimitriState, $02
@boughtDimitri:
	setangleandanimation $18
	checkabutton
	showtext TX_210c
	scriptjump @boughtDimitri
	
moblinBulliesScript_dimitriBully3BeforeSaving:
	makeabuttonsensitive
-
	jumpifc6xxset <wDimitriState, $04, @boughtDimitri
	jumpifc6xxset <wDimitriState, $02, +
	scriptjump -
+
	callscript moblinBulliesScript_hop
-
	jumptable_objectbyte $77
	.dw -
	.dw +
+
	showtext TX_2102
	ormemory wDimitriState, $04
	enablemenu
	enableallobjects
@boughtDimitri:
	setangleandanimation $00
	checkabutton
	showtext TX_210d
	scriptjump @boughtDimitri

moblinBulliesScript_dimitriBully1AfterSaving:
	jumpifc6xxset <wDimitriState, $20, +
	scriptjump moblinBulliesScript_dimitriBully1AfterSaving
+
	movedown $1c
	moveleft $1a
	movedown $18
	moveleft $1c
	movedown $20
	scriptend

moblinBulliesScript_dimitriBully2AfterSaving:
	setangleandanimation $10
	callscript moblinBulliesScript_hop
-
	jumptable_objectbyte $77
	.dw -
	.dw +
+
	showtext TX_2109
	ormemory wDimitriState, $10
-
	jumpifc6xxset <wDimitriState, $20, +
	scriptjump -
+
	movedown $28
	moveleft $28
	movedown $18
	moveleft $19
	movedown $20
	enableallobjects
	enablemenu
	scriptend

moblinBulliesScript_dimitriBully3AfterSaving:
	jumpifc6xxset <wDimitriState, $10, +
	scriptjump moblinBulliesScript_dimitriBully3AfterSaving
+
	setangleandanimation $10
	callscript moblinBulliesScript_hop
-
	jumptable_objectbyte $77
	.dw -
	.dw +
+
	showtext TX_210a
	setdisabledobjectsto11
	ormemory wDimitriState, $20
	movedown $1c
	moveleft $0f
	movedown $18
	moveleft $18
	movedown $20
	scriptend

moblinBulliesScript_mooshBully1:
	jumpifc6xxset <wMooshState, $02, @startFight
	jumpifc6xxset <wMooshState, $01, @waitToStartFight
	setdisabledobjectsto11
	callscript moblinBulliesScript_hop
	jumptable_objectbyte $77
	.dw moblinBulliesScript_dimitriBully1BeforeSaving@animalBulliedInitDone
	.dw +
+
	showtext TX_2200
	ormemory $d13e, $01
	setangleandanimation $00
-
	jumpifmemoryset $d13e, $04, +
	scriptjump -
+
	setcounter1 $20
	showtext TX_2203
	callscript moblinBulliesScript_hop
-
	jumptable_objectbyte $77
	.dw -
	.dw +
+
	showtext TX_2204
	setdisabledobjectsto11
	ormemory $d13e, $10
-
	jumpifmemoryset $d13e, $40, +
	scriptjump -
+
	playsound SND_DOORCLOSE
	setangle $08
	setspeed SPEED_280
	applyspeed $30
	wait 30
	setspeed SPEED_140
	moveleft $30
	showtext TX_2209
	setdisabledobjectsto11
	ormemory wMooshState, $01
	moveright $30
	enableallobjects
@waitToStartFight:
	jumpifc6xxset <wMooshState, $02, @revengeWanted
	scriptjump @waitToStartFight
@startFight:
	setdisabledobjectsto11
	moveleft $30
	callscript moblinBulliesScript_spawnMoblins
	setcounter1 $70
	showtext TX_220e
	scriptjump @moblinsSpawned
@revengeWanted:
	setdisabledobjectsto11
	moveleft $30
	callscript moblinBulliesScript_spawnMoblins
	setcounter1 $70
	showtext TX_220b
@moblinsSpawned:
	jumpifc6xxset <wMooshState, $08, +
	scriptjump @moblinsSpawned
+
	enablemenu
	enableallobjects
	ormemory $d13e, $80
	moveright $30
-
	jumptable_objectbyte $7b
	.dw +
	.dw -
+
	setdisabledobjectsto11
	moveleft $30
	showtext TX_220c
	moveright $30
	enableallobjects
	ormemory wMooshState, $04
	scriptend
	
moblinBulliesScript_spawnMoblins:
	spawninteraction INTERAC_ANIMAL_MOBLIN_BULLIES, $03, $88, $30
	spawninteraction INTERAC_ANIMAL_MOBLIN_BULLIES, $04, $88, $50
	spawninteraction INTERAC_ANIMAL_MOBLIN_BULLIES, $05, $18, $b0
	retscript

moblinBulliesScript_mooshBully2:
	jumpifc6xxset <wMooshState, $01, @scriptEnd
	jumpifmemoryset $d13e, $01, +
	scriptjump moblinBulliesScript_mooshBully2
+
	callscript moblinBulliesScript_hop
-
	jumptable_objectbyte $77
	.dw -
	.dw +
+
	showtext TX_2201
	setdisabledobjectsto11
	ormemory $d13e, $02
	setangleandanimation $18
-
	jumpifmemoryset $d13e, $10, +
	scriptjump -
+
	showtext TX_2205
	setdisabledobjectsto11
	applyspeed $10
	writememory $d12b, $20
	setangle $08
	applyspeed $10
	ormemory $d13e, $20
-
	jumpifmemoryset $d13e, $40, +
	scriptjump -
+
	setspeed SPEED_280
	setangle $04
	applyspeed $20
@scriptEnd:
	scriptend

moblinBulliesScript_mooshBully3:
	jumpifc6xxset <wMooshState, $01, @scriptEnd
	jumpifmemoryset $d13e, $02, +
	scriptjump moblinBulliesScript_mooshBully3
+
	callscript moblinBulliesScript_hop
-
	jumptable_objectbyte $77
	.dw -
	.dw +
+
	showtext TX_2202
	setdisabledobjectsto11
	ormemory $d13e, $04
-
	jumpifmemoryset $d13e, $40, +
	scriptjump -
+
	setspeed SPEED_280
	setangle $18
	applyspeed $20
@scriptEnd:
	scriptend

moblinBulliesScript_maskedMoblin1MovingUp:
	setangle $00
	applyspeed $30
	ormemory wMooshState, $08
moblinBulliesScript_spawnMoblin:
	jumpifmemoryset $d13e, $80, +
	scriptjump moblinBulliesScript_spawnMoblin
+
	spawnenemyhere ENEMY_MASKED_MOBLIN, $00
	scriptend

moblinBulliesScript_maskedMoblin2MovingUp:
	setangle $00
	applyspeed $2f
	scriptjump moblinBulliesScript_spawnMoblin

moblinBulliesScript_maskedMoblinMovingLeft:
	setangle $18
	applyspeed $2f
	scriptjump moblinBulliesScript_spawnMoblin
	
moblinBulliesScript_hop:
	setzspeed -$0300
	wait 8
	retscript


; interacid_75
script6f48:
	setcoords $44, $50
	setcounter1 $c8
	setanimation $01
	setcounter1 $fa
	setcounter1 $60
	setanimation $02
	setcounter1 $de
	setanimation $03
	setcounter1 $7a
	scriptend


; ==================================================================================================
; INTERAC_SUNKEN_CITY_BULLIES
; ==================================================================================================
sunkenCityBulliesScript1_bully1:
	makeabuttonsensitive
	jumpifc6xxset <wDimitriState, $04, @promptForPayment
	disablemenu
	setdisabledobjectsto11
	callscript moblinBulliesScript_hop
-
	jumptable_objectbyte $77
	.dw -
	.dw +
+
	showtextlowindex <TX_210e
	ormemory wDimitriState, $01
@promptForPayment:
	setangleandanimation $00
	checkabutton
	asm15 scriptHelp.sunkenCityBullies_lookToLink
	disablemenu
	showtextlowindex <TX_2111
	setdisabledobjectsto11
	jumptable_objectbyte $78
	.dw @doesntHaveBombs
	.dw @hasBombs
@hasBombs:
	wait 30
	showtextnonexitablelowindex <TX_211c
	jumpiftextoptioneq $00, @givingBombs
@notGivingBombs:
	showtextlowindex <TX_2114
	enablemenu
	enableallobjects
	scriptjump @promptForPayment
@doesntHaveBombs:
	enablemenu
	enableallobjects
	wait 30
	scriptjump @promptForPayment
@givingBombs:
	jumptable_objectbyte $78
	.dw @notGivingBombs
	.dw +
+
	writeobjectbyte $79, $01
	showtextlowindex <TX_2112
	setdisabledobjectsto11
	ormemory wDimitriState, $08
	scriptend

sunkenCityBulliesScript1_bully2:
	makeabuttonsensitive
-
	jumpifc6xxset <wDimitriState, $04, @talkedToBullies
	jumpifc6xxset <wDimitriState, $01, @initialHop
	scriptjump -
@initialHop:
	callscript moblinBulliesScript_hop
-
	jumptable_objectbyte $77
	.dw -
	.dw +
+
	showtextlowindex <TX_210f
	ormemory wDimitriState, $02
@talkedToBullies:
	setangleandanimation $00
	checkabutton
	asm15 scriptHelp.sunkenCityBullies_lookToLink
	showtextlowindex <TX_2116
	scriptjump @talkedToBullies
	
sunkenCityBulliesScript1_bully3:
	makeabuttonsensitive
-
	jumpifc6xxset <wDimitriState, $04, @talkedToBullies
	jumpifc6xxset <wDimitriState, $02, @initialHop
	scriptjump -
@initialHop:
	callscript moblinBulliesScript_hop
-
	jumptable_objectbyte $77
	.dw -
	.dw +
+
	showtextlowindex <TX_2110
	ormemory wDimitriState, $04
	enablemenu
	enableallobjects
@talkedToBullies:
	setangleandanimation $08
	checkabutton
	asm15 scriptHelp.sunkenCityBullies_lookToLink
	showtextlowindex <TX_2117
	scriptjump @talkedToBullies
	
sunkenCityBulliesScript2_bully1:
	jumpifc6xxset <wDimitriState, $10, +
	scriptjump sunkenCityBulliesScript2_bully1
+
	setangle $04
	setanimationfromangle
	applyspeed $f0
	
sunkenCityBulliesScript2_bully2:
	setangleandanimation $10
	callscript moblinBulliesScript_hop
-
	jumpifc6xxset <wDimitriState, $10, +
	scriptjump -
+
	setangle $04
	setanimationfromangle
	applyspeed $f0
	
sunkenCityBulliesScript2_bully3:
	setangleandanimation $10
	callscript moblinBulliesScript_hop
-
	jumptable_objectbyte $77
	.dw -
	.dw +
+
	showtextlowindex <TX_2113
	setdisabledobjectsto11
	ormemory wDimitriState, $10
	setangle $04
	setanimationfromangle
	applyspeed $f0
	scriptend
	
sunkenCityBulliesScript3_bully1:
	makeabuttonsensitive
-
	setangleandanimation $10
	checkabutton
	showtextlowindex <TX_2118
	scriptjump -
	
sunkenCityBulliesScript3_bully2:
	makeabuttonsensitive
-
	setangleandanimation $10
	checkabutton
	showtextlowindex <TX_2119
	scriptjump -
	
sunkenCityBulliesScript3_bully3:
	makeabuttonsensitive
-
	setangleandanimation $00
	checkabutton
	showtextlowindex <TX_211a
	scriptjump -


; ==================================================================================================
; INTERAC_FICKLE_OLD_MAN
; ==================================================================================================
fickleOldManScript_text1:
	rungenericnpc TX_1100
fickleOldManScript_text2:
	rungenericnpc TX_1101
fickleOldManScript_text3:
	rungenericnpc TX_1102
fickleOldManScript_text4:
	rungenericnpc TX_1103
fickleOldManScript_text5:
	rungenericnpc TX_1104
fickleOldManScript_text6:
	rungenericnpc TX_1105


; ==================================================================================================
; INTERAC_SUBROSIAN_SHOP
; ==================================================================================================
subrosianShopScript_ribbon:
	showtextnonexitable TX_2b00
	callscript subrosianShopScript_buyItem
	ormemory wBoughtSubrosianShopItems, $01
	scriptend
	
subrosianShopScript_bombUpgrade:
	showtextnonexitable TX_2b02
	callscript subrosianShopScript_buyItem
	ormemory wBoughtSubrosianShopItems, $04
	showtext TX_2b0d
	setdisabledobjectsto11
	scriptend
	
subrosianShopScript_gashaSeed:
	showtextnonexitable TX_2b04
	callscript subrosianShopScript_buyItem
	ormemory wBoughtSubrosianShopItems, $08
	scriptend
	
subrosianShopScript_pieceOfHeart:
	showtextnonexitable TX_2b01
	callscript subrosianShopScript_buyItem
	ormemory wBoughtSubrosianShopItems, $02
	scriptend
	
subrosianShopScript_ring1:
	showtextnonexitable TX_2b03
	callscript subrosianShopScript_buyItem
	ormemory wBoughtSubrosianShopItems, $10
	scriptend
	
subrosianShopScript_ring2:
	showtextnonexitable TX_2b03
	callscript subrosianShopScript_buyItem
	ormemory wBoughtSubrosianShopItems, $20
	scriptend
	
subrosianShopScript_ring3:
	showtextnonexitable TX_2b03
	callscript subrosianShopScript_buyItem
	ormemory wBoughtSubrosianShopItems, $40
	scriptend
	
subrosianShopScript_ring4:
	showtextnonexitable TX_2b03
	callscript subrosianShopScript_buyItem
	ormemory wBoughtSubrosianShopItems, $80
	scriptend
	
subrosianShopScript_emberSeeds:
	showtextnonexitable TX_2b09
	callscript subrosianShopScript_buyItem
	scriptend
	
subrosianShopScript_shield:
	showtextnonexitable TX_2b05
	callscript subrosianShopScript_buyItem
	scriptend
	
subrosianShopScript_pegasusSeeds:
	showtextnonexitable TX_2b0a
	callscript subrosianShopScript_buyItem
	scriptend
	
subrosianShopScript_heartRefill:
	showtextnonexitable TX_2b06
	callscript subrosianShopScript_buyItem
	scriptend
	
subrosianShopScript_membersCard:
	showtextnonexitable TX_2b10
	callscript subrosianShopScript_buyItem
	scriptend
	
subrosianShopScript_oreChunks:
	showtextnonexitable TX_2b08
	callscript subrosianShopScript_buyItem
	scriptend
	
subrosianShopScript_buyItem:
	jumpiftextoptioneq $00, @buying
	writememory $cba0, $01
	writeobjectbyte $7d, $ff
	scriptend
@buying:
	jumptable_objectbyte $7b
	.dw @notEnoughCurrency
	.dw @enoughCurrency
@notEnoughCurrency:
	playsound SND_ERROR
	showtext TX_2b12
	writeobjectbyte $7d, $ff
	scriptend
@enoughCurrency:
	jumptable_objectbyte $7c
	.dw script7102
script70fb:
	showtext TX_2b0c
	writeobjectbyte $7d, $ff
	scriptend

script7102:
	writememory $cba0, $01
	setdisabledobjectsto11
	writeobjectbyte $7d, $01
	retscript


; ==================================================================================================
; INTERAC_MAKU_TREE
; ==================================================================================================
script710b:
	jumptable_memoryaddress wIsLinkedGame
	.dw unlinked
	.dw linked
unlinked:
	jumptable_memoryaddress $cc39
	.dw stage0
	.dw script71a2
	.dw script71a2
	.dw script71a2
	.dw script71a2
	.dw script71a2 ; finished dungeon 5 after dungeon 4
	.dw script71a2
	.dw script71b1
	.dw script71c8
	.dw script71a2
	.dw script71a2 ; dungeons 1 to 5 except 4
	.dw script71a2 ; as above, but finally did 4
	.dw stageMakuSeedGotten
	.dw script7223 ; highest essence gotten is 8, but wc6e5 is not $09
	.dw stageFinishedGame
linked:
	jumptable_memoryaddress $cc39
	.dw stage0
	.dw script71a2
	.dw script71a2
	.dw script71b1
	.dw script71b1
	.dw script71b1
	.dw script71b1
	.dw script71b1
	.dw script71c8
	.dw script71a2
	.dw script71b1
	.dw script71b1
	.dw stageMakuSeedGotten
	.dw script7223
	.dw stageFinishedGame
stage0:
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $00
	asm15 scriptHelp.makuTree_setMakuMapText, $03
	jumpifroomflagset $40, gnarledKeySpawned@loop
	callscript makuTreeScript_waitForBubblePopped
	disableinput
	jumpifglobalflagset GLOBALFLAG_GNARLED_KEY_GIVEN, givenGnarledKey
	setglobalflag GLOBALFLAG_GNARLED_KEY_GIVEN
	asm15 scriptHelp.makuTree_showText, <TX_1700
	wait 30
longText:
	asm15 scriptHelp.makuTree_showText, <TX_1701
	wait 1
	jumpiftextoptioneq $01, acceptedQuest
	wait 30
	scriptjump longText
acceptedQuest:
	wait 30
givenGnarledKey:
	asm15 scriptHelp.makuTree_showText, <TX_1702
	wait 1
	jumpifroomflagset $80, gnarledKeySpawned
	orroomflag $80
	asm15 scriptHelp.makuTree_dropGnarledKey
gnarledKeySpawned:
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $02
	checkobjectbyteeq Interaction.animParameter, $ff
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $00
	enableinput
@loop:
	callscript makuTreeScript_waitForBubblePopped
	asm15 scriptHelp.makuTree_showTextAndSetMapText, <TX_1703
	callscript script729c
	scriptjump @loop
	
	
script71a2:
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $00
@loop:
	callscript makuTreeScript_waitForBubblePopped
	asm15 scriptHelp.makuTree_showTextAndSetMapTextBasedOnStage
	callscript script729c
	scriptjump @loop

script71b1:
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $04
	setcollisionradii $24, $10
	makeabuttonsensitive
@loop:
	checkabutton
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $01
	asm15 scriptHelp.makuTree_showTextAndSetMapTextBasedOnStage
	wait 1
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $04
	scriptjump @loop

script71c8:
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $04
	checkflagset $00, $cd00
	disableinput
	wait 30
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $01
	asm15 scriptHelp.makuTree_showTextBasedOnVar, <TX_1717 ; take this seed
	wait 1
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $04
	asm15 scriptHelp.makuTree_dropMakuSeed
	setcounter1 $61
	setcounter1 $61
	playsound SND_GETSEED
	giveitem TREASURE_MAKU_SEED, $00
	wait 40
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $01
	asm15 scriptHelp.makuTree_showTextAndSetMapText, <TX_1718 ; you can defeat Onox
	wait 40
	asm15 fadeoutToBlackWithDelay, $01
	asm15 scriptHelp.makuTree_OnoxTauntingAfterMakuSeedGet
	setcounter1 $ff
	scriptend
	
	
stageMakuSeedGotten:
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $04
	asm15 scriptHelp.seasonsFunc_15_619a
	setmusic MUS_MAKU_TREE
	asm15 scriptHelp.makuTree_setMakuMapText, <TX_1718
	setcollisionradii $24, $10
	makeabuttonsensitive
	asm15 scriptHelp.makuTree_disableEverythingIfUnlinked
@loop:
	checkabutton
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $01
	asm15 scriptHelp.makuTree_showTextAndSetMapText, <TX_1718 ; /TX_1733
	wait 1
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $04
	scriptjump @loop

script7223:
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $04
	asm15 scriptHelp.seasonsFunc_15_619a
	setmusic MUS_MAKU_TREE
	asm15 scriptHelp.makuTree_setMakuMapText, <TX_1738
	setcollisionradii $24, $10
	makeabuttonsensitive
@loop:
	checkabutton
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $01
	showtext TX_1738 ; passage at my roots leads to Twinrova
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $04
	scriptjump @loop

stageFinishedGame:
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $00
	asm15 scriptHelp.makuTree_setMakuMapText, <TX_1739
@loop:
	callscript makuTreeScript_waitForBubblePopped
	showtext TX_1739
	callscript script729c
	scriptjump @loop

script7255:
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $00
	checkcfc0bit 7
	playsound SND_POOF
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $03
	scriptend

script7261:
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $04
	checkmemoryeq $cfc0, $02
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $01
	showtext TX_3d07
	wait 1
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $04
	wait 60
	writememory $cfc0, $03
	setcounter1 $ff
	scriptend

makuTreeScript_waitForBubblePopped:
	checkcfc0bit 7
	disablemenu
	writememory wcc95, $80
	playsound SND_POOF
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $03
	checkmemoryeq wcc95, $ff
	setdisabledobjectsto11
	checkobjectbyteeq $61, $ff
	setdisabledobjectsto91
	writememory wcc95, $00
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $01
	enablemenu
	retscript

script729c:
	enableallobjects
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $02
	checkobjectbyteeq Interaction.animParameter, $ff
	asm15 scriptHelp.makuTree_storeIntoVar37SpawnBubbleIf0, $00
	retscript


; ==================================================================================================
; INTERAC_FLOODED_HOUSE_GIRL
; INTERAC_MASTER_DIVERS_WIFE
; INTERAC_MASTER_DIVER
; ==================================================================================================
floodedHouseGirlScript_text1:
	initcollisions
-
	checkabutton
	showtext TX_1d00
	checkabutton
	showtext TX_1d01
	scriptjump -
	
floodedHouseGirlScript_text2:
	rungenericnpc TX_1d02
	
floodedHouseGirlScript_text3:
	rungenericnpc TX_1d03
	
floodedHouseGirlScript_text4:
	rungenericnpc TX_1d04
	
floodedHouseGirlScript_text5:
	rungenericnpc TX_1d05
	
masterDiversWifeScript_text1:
	initcollisions
	jumpifglobalflagset GLOBALFLAG_MOBLINS_KEEP_DESTROYED, masterDiversWifeScript_cityQuietText
	jumpifitemobtained TREASURE_FLIPPERS, masterDiversWifeScript_metMasterDiverText
	rungenericnpc TX_1800
	
masterDiversWifeScript_text2:
	initcollisions
	jumpifglobalflagset GLOBALFLAG_MOBLINS_KEEP_DESTROYED, masterDiversWifeScript_text2_moblinsKeepDestroyed
	scriptjump masterDiversWifeScript_metMasterDiverText
masterDiversWifeScript_text2_moblinsKeepDestroyed:
	checkabutton
	showtext TX_1802
	checkabutton
	showtext TX_1801
	scriptjump masterDiversWifeScript_text2_moblinsKeepDestroyed
masterDiversWifeScript_metMasterDiverText:
	rungenericnpc TX_1801
masterDiversWifeScript_cityQuietText:
	rungenericnpc TX_1802
	
masterDiversWifeScript_text3:
	rungenericnpc TX_1803

masterDiversWifeScript_text4:
	rungenericnpc TX_1804

masterDiversWifeScript_text5:
	rungenericnpc TX_1805

masterDiverScript_text1:
	initcollisions
--
	enableinput
	checkabutton
	disableinput
	jumpifitemobtained TREASURE_FLIPPERS, @gotFlippers
	jumpifitemobtained TREASURE_MASTERS_PLAQUE, @gotMastersPlaque
	showtext TX_3400
	orroomflag $40
	scriptjump --
@gotMastersPlaque:
	jumpifroomflagset $40, @seenIntroText
	showtext TX_3400
	orroomflag $40
	wait 30
@seenIntroText:
	showtext TX_3401
	wait 20
	giveitem TREASURE_FLIPPERS, $00
	wait 20
@gotFlippers:
	showtext TX_3404
	scriptjump --
	
masterDiverScript_text2:
masterDiverScript_text3:
	rungenericnpc TX_3402
	
masterDiverScript_text4:
	rungenericnpc TX_3403
	
masterDiverScript_text5:
	scriptend


; ==================================================================================================
; INTERAC_OLD_MAN_WITH_JEWEL
; ==================================================================================================

oldManWithJewelScript:
	initcollisions
	jumpifroomflagset $40, @alreadyGaveJewel
	jumptable_objectbyte Interaction.var38
	.dw @dontHaveEssences
	.dw @haveEssences

@dontHaveEssences:
	checkabutton
	showtextlowindex <TX_3601
	scriptjump @dontHaveEssences

@haveEssences:
	checkabutton
	showtextlowindex $02
	disableinput
	giveitem TREASURE_ROUND_JEWEL, $00
	orroomflag $40
	enableinput

@alreadyGaveJewel:
	checkabutton
	showtextlowindex <TX_3603
	scriptjump @alreadyGaveJewel


; ==================================================================================================
; INTERAC_JEWEL_HELPER
; ==================================================================================================

jewelHelperScript_insertedJewel:
	wait 60
	showtext TX_3600
	scriptend

jewelHelperScript_insertedAllJewels:
	wait 60
	orroomflag $80
	scriptend

jewelHelperScript_underwaterPyramidJewel:
	stopifitemflagset
	jumptable_memoryaddress wIsLinkedGame
	.dw @unlinked
	.dw @linked
@unlinked:
	spawnitem TREASURE_PYRAMID_JEWEL, $00
-
	jumpifitemobtained TREASURE_PYRAMID_JEWEL, @end
	scriptjump -
@end:
	scriptend
@linked:
	spawnitem TREASURE_RUPEES, RUPEEVAL_100
	scriptend
	
jewelHelperScript_createBridgeToXJewelMoldorm:
	jumpifroomflagset $40, @relightTorch
	checkmemoryeq wNumTorchesLit, $01
	orroomflag $40
	wait 40
	playsound SND_SOLVEPUZZLE
	wait 60
	playsound SND_BIGSWORD
	settileat $76, $a7
	setcounter1 $02
	settileat $66, $a7
	wait 10
	playsound SND_BIGSWORD
	wait 15
	playsound SND_BIGSWORD
	scriptend
@relightTorch:
	settileat $77, TILEINDEX_OVERWORLD_LIT_TORCH
	scriptend
	
jewelHelperScript_XjewelMoldorm:
	loadscript scripts2.jewelHelperScript_jewelMoldorm_body

jewelHelperScript_spoolSwampSquareJewel:
	stopifitemflagset
	jumptable_memoryaddress wIsLinkedGame
	.dw jewelHelperScript_squareJewel
	.dw jewelHelperScript_40Rupees

jewelHelperScript_eyeglassLakeSquareJewel:
	stopifitemflagset
	jumptable_memoryaddress wIsLinkedGame
	.dw jewelHelperScript_40Rupees
	.dw jewelHelperScript_squareJewel

jewelHelperScript_squareJewel:
	writememory $ccbd, TREASURE_SQUARE_JEWEL
	writememory $ccbe, $00
	settileat $57, TILEINDEX_CHEST
	scriptend

jewelHelperScript_40Rupees:
	writememory $ccbd, TREASURE_RUPEES
	writememory $ccbe, RUPEEVAL_040
	settileat $57, TILEINDEX_CHEST
	scriptend

jewelHelperScript_stub:
	scriptend


; ==================================================================================================
; INTERAC_KING_MOBLIN
; ==================================================================================================
script73ab:
	setcollisionradii $11, $0e
	makeabuttonsensitive
-
	checkabutton
	showtext TX_3802
	scriptjump -

script73b5:
	setcollisionradii $0b, $0e
	makeabuttonsensitive
-
	checkabutton
	showtext TX_3803
	scriptjump -

script73bf:
	setcollisionradii $0b, $0e
	makeabuttonsensitive
-
	checkabutton
	showtext TX_3805
	scriptjump -

kingMoblinScript_trapLinkInBombedHouse:
	loadscript scripts2.kingMoblin_trapLinkInBombedHouse

script73cd:
	checkcfc0bit 0
	setspeed SPEED_200
	setanimation $05
	setangle $10
	applyspeed $21
	wait 40
	scriptend

script73d8:
	setspeed SPEED_100
	checkmemoryeq $cfc0, $02
	setangle $00
	applyspeed $25
	checkmemoryeq $cfc0, $05
	setangle $10
	applyspeed $25
	checkmemoryeq $cfc0, $06
	setangle $00
	applyspeed $25
	scriptend


; ==================================================================================================
; INTERAC_MOBLIN
; ==================================================================================================
script73f3:
	rungenericnpc TX_3800

script73f6:
	setcoords $40, $7e
	initcollisions
	setspeed SPEED_080
	setangle $1f
	setanimationfromangle
--
	checkcfc0bit 0
	writeobjectbyte $5a, $82
	applyspeed $10
	wait 20
	xorcfc0bit 1
	setangle $0f
	setanimationfromangle
	xorcfc0bit 0
	wait 10
	xorcfc0bit 2
	xorcfc0bit 1
	applyspeed $30
	wait 20
	xorcfc0bit 3
	xorcfc0bit 2
	wait 20
	setangle $1f
	setanimationfromangle
	applyspeed $20
	setcoords $40, $7e
	scriptjump --

script7421:
	checkcfc0bit 0
	wait 10
	setspeed SPEED_200
	callscript script7430
	wait 4
	setanimation $02
	setangle $10
	applyspeed $1a
	scriptend

script7430:
	jumpifobjectbyteeq $43, $01, script743c
	setanimation $01
	setangle $08
	applyspeed $09
	retscript
script743c:
	setanimation $03
	setangle $18
	applyspeed $09
	retscript

script7443:
	setspeed SPEED_100
	checkmemoryeq $cfc0, $01
	moveleft $29
	setanimation $09
	checkmemoryeq $cfc0, $03
	asm15 scriptHelp.moblin_spawnSwordMaskedMoblin
	wait 1
	scriptend

script7456:
	setspeed SPEED_100
	checkmemoryeq $cfc0, $01
	moveright $29
	setanimation $09
	checkmemoryeq $cfc0, $03
	asm15 scriptHelp.moblin_spawnSwordMaskedMoblin
	wait 1
	scriptend

script7469:
	checkmemoryeq $cfc0, $03
	asm15 scriptHelp.moblin_spawnMaskedMoblin
	wait 1
	scriptend


; ==================================================================================================
; INTERAC_OLD_MAN_WITH_RUPEES
; ==================================================================================================
oldManScript_givesRupees:
	initcollisions
	jumpifroomflagset $40, @alreadyGaveMoney
	checkabutton
	disableinput
	showtextlowindex <TX_1f03
	asm15 scriptHelp.oldMan_giveRupees
	wait 8
	checkrupeedisplayupdated
	orroomflag $40
	enableinput
	
@alreadyGaveMoney:
	checkabutton
	showtextlowindex <TX_1f07
	scriptjump @alreadyGaveMoney
	
oldManScript_takesRupees:
	initcollisions
	jumpifroomflagset $40, @alreadyTookMoney
	checkabutton
	disableinput
	showtextlowindex <TX_1f00
	asm15 scriptHelp.oldMan_takeRupees
	jumpifobjectbyteeq $7f, $00, @linkIsBroke
	wait 8
	checkrupeedisplayupdated
	orroomflag $40
	enableinput

@alreadyTookMoney:
	checkabutton
	showtextlowindex <TX_1f01
	scriptjump @alreadyTookMoney

@linkIsBroke:
	wait 30
	showtextlowindex <TX_1f02
	enableinput
	scriptjump @alreadyTookMoney


; ==================================================================================================
; INTERAC_IMPA
; ==================================================================================================
impaScript_afterOnoxTakesDin:
	initcollisions
	jumpifroomflagset $40, @impaIntroDone
	disableinput
	setspeed SPEED_100
	wait 120
	setangleandanimation $10
	applyspeed $20
	setangleandanimation $08
	setcounter1 $06
	applyspeed $20
	writememory $cfd0, $01
	checkmemoryeq $cfd0, $02
	wait 30
	jumpifmemoryeq wIsLinkedGame, $01, @linkedText
	showtext TX_2500
	scriptjump +
@linkedText:
	showtext TX_2501
+
	setmusic SNDCTRL_FAST_FADEOUT
	setangleandanimation $18
	setcounter1 $06
	applyspeed $30
	setmusic MUS_OVERWORLD
	setangleandanimation $00
	setcounter1 $06
	applyspeed $20
	setanimation $02
	wait 30
	writememory $cfd0, $03
	orroomflag $40
	setglobalflag GLOBALFLAG_INTRO_DONE
	enableinput
@impaIntroDone:
	jumpifglobalflagset GLOBALFLAG_GNARLED_KEY_GIVEN, @messageTakenToMakuTree
	rungenericnpc TX_2503
@messageTakenToMakuTree:
	rungenericnpc TX_2505
	
	
impaScript_after1stEssence:
	jumpifitemobtained TREASURE_ROD_OF_SEASONS, @gotRodOfSeasons
	rungenericnpc TX_2510
@gotRodOfSeasons:
	rungenericnpc TX_2506
	
impaScript_after2ndEssence:
	rungenericnpc TX_2507
	
impaScript_after3rdEssence:
	jumpifitemobtained TREASURE_FLIPPERS, @gotFlippers
	rungenericnpc TX_2508
@gotFlippers:
	rungenericnpc TX_2509
	
impaScript_after4thEssence:
	rungenericnpc TX_250a
	
impaScript_after5thEssence:
	asm15 scriptHelp.impa_checkIf4thEssenceGotten
	jumptable_memoryaddress $cfc0
	.dw @got4thEssence
	.dw impaScript_after3rdEssence@gotFlippers
@got4thEssence:
	rungenericnpc TX_250b
	
impaScript_after6thEssence:
	rungenericnpc TX_250c
	
impaScript_after7thEssence:
	rungenericnpc TX_250d
	
impaScript_after8thEssence:
	rungenericnpc TX_250e
	
impaScript_villagersSeenButNoMakuSeed:
	initcollisions
-
	checkabutton
	asm15 scriptHelp.faceOppositeDirectionAsLink
	showtext TX_0600
	wait 10
	setanimationfromobjectbyte $7b
	scriptjump -
	
impaScript_gotMakuSeedDidntSeeZeldaKidnapped:
	jumpifglobalflagset GLOBALFLAG_TALKED_TO_ZELDA_BEFORE_ONOX_FIGHT, @talkedToZeldaBeforeOnoxFight
	setspeed SPEED_100
	setangleandanimation $00
	wait 60
	applyspeed $29
	wait 10
	setangleandanimation $18
	wait 60
@talkedToZeldaBeforeOnoxFight:
	setcoords $78, $68
	rungenericnpc TX_0609
	
impaScript_askingToSaveZelda:
	loadscript scripts2.impaScript_askedToSaveZeldaButHavent_body
	
impaScript_askedToSaveZeldaButHavent:
	rungenericnpc TX_0502
	
impaScript_afterZeldaKidnapped:
	rungenericnpc TX_250f
	

; ==================================================================================================
; INTERAC_SAMASA_DESERT_GATE
; ==================================================================================================
script7556:
	playsound SND_RUMBLE2
	callscript samasaDesertGateScript_createNext7Puffs
	setcounter1 $23
	callscript samasaDesertGateScript_createNext7Puffs
	setcounter1 $23
	playsound SND_RUMBLE2
	callscript samasaDesertGateScript_createNext7Puffs
	setcounter1 $23
	callscript samasaDesertGateScript_createNext7Puffs
	setcounter1 $ff
	scriptend

samasaDesertGateScript_createNext7Puffs:
	playsound SND_KILLENEMY
	asm15 scriptHelp.samasaDesertGate_createNext2Puffs
	setcounter1 $05
	playsound SND_KILLENEMY
	asm15 scriptHelp.samasaDesertGate_createNextPuff
	setcounter1 $05
	playsound SND_KILLENEMY
	asm15 scriptHelp.samasaDesertGate_createNext2Puffs
	setcounter1 $05
	playsound SND_KILLENEMY
	asm15 scriptHelp.samasaDesertGate_createNext2Puffs
	retscript


; ==================================================================================================
; INTERAC_SUBROSIAN_SMITHY
; ==================================================================================================
subrosianSmithyScript:
	setcollisionradii $12, $06
	makeabuttonsensitive
	jumptable_objectbyte $7f
	.dw @nothingToProvide
	.dw @haveRustyBell
	.dw @haveHardOre
	.dw @finishedGame
	
@nothingToProvide:
	checkabutton
	showtextlowindex <TX_3b00
	scriptjump @nothingToProvide
	
@haveRustyBell:
	checkabutton
	disableinput
	callscript smithyScript_introText
	showtextlowindex <TX_3b03
	jumpiftextoptioneq $00, @please
	; Do it!
	wait 30
	showtextlowindex <TX_3b06
	setanimation $01
	wait 30
	showtextlowindex <TX_3b07
	callscript smithyScript_smithItem
	giveitem TREASURE_PIRATES_BELL, $02
	scriptjump smithyScript_smithingDone
@please:
	wait 30
	showtextlowindex <TX_3b04
	enableinput
-
	checkabutton
	showtextlowindex <TX_3b05
	scriptjump -

@haveHardOre:
	checkabutton
	disableinput
	callscript smithyScript_introText
	jumpifitemobtained TREASURE_SHIELD, @haveShield
	scriptjump @noShield
@haveShield:
	showtextlowindex <TX_3b0a
	jumpiftextoptioneq $00, @makeItFine
	; Do whatever
	wait 30
	showtextlowindex <TX_3b0c
	setanimation $01
	wait 30
	showtextlowindex <TX_3b0d
	callscript smithyScript_smithItem
	asm15 scriptHelp.subrosianSmith_takeHardOre
	scriptjump smithyScript_smithingDone
@makeItFine:
	wait 30
	showtextlowindex <TX_3b0b
	enableinput
@tryAgainLater:
	checkabutton
	showtextlowindex <TX_3b05
	scriptjump @tryAgainLater
@noShield:
	showtextlowindex <TX_3b13
	enableinput
	scriptjump @tryAgainLater
	
@finishedGame:
	jumpifglobalflagset GLOBALFLAG_DONE_SMITH_SECRET, @doneSecret
@notDoneSecret:
	checkabutton
	disableinput
	callscript smithyScript_introText
	jumpifitemobtained TREASURE_SHIELD, @finishedGameHaveShield
	enableinput
-
	showtextlowindex <TX_3b18
	checkabutton
	scriptjump -
@finishedGameHaveShield:
	showtextlowindex <TX_3b0e
	jumpiftextoptioneq $00, @beenToldSecret
	wait 30
	showtextlowindex <TX_3b10
	enableinput
	checkabutton
	disableinput
	scriptjump @finishedGameHaveShield
@beenToldSecret:
	wait 30
	showtextlowindex $0f
	askforsecret SMITH_SECRET
	wait 30
	jumptable_memoryaddress $cca3
	.dw @correctSecret
	.dw @incorrectSecret
@incorrectSecret:
	showtextlowindex <TX_3b11
	enableinput
	scriptjump @notDoneSecret
@correctSecret:
	setglobalflag GLOBALFLAG_BEGAN_SMITH_SECRET
	showtextlowindex <TX_3b12
	callscript smithyScript_smithItem
	asm15 scriptHelp.subrosianSmith_giveUpgradedShield
	setglobalflag GLOBALFLAG_DONE_SMITH_SECRET
	wait 30
@generateReturnSecret:
	generatesecret SMITH_RETURN_SECRET
-
	showtextlowindex <TX_3b16
	wait 30
	jumpiftextoptioneq $00, @gotReturnSecret
	scriptjump -
@gotReturnSecret:
	showtextlowindex <TX_3b17
	enableinput
@doneSecret:
	checkabutton
	disableinput
	scriptjump @generateReturnSecret
	
smithyScript_introText:
	showtextlowindex <TX_3b00
	wait 30
	showtextlowindex <TX_3b01
	setanimation $01
	wait 30
	showtextlowindex <TX_3b02
	setanimation $02
	wait 30
	retscript
	
smithyScript_smithItem:
	asm15 fadeoutToWhite
	checkpalettefadedone
	setcoords $50, $70
	setanimation $01
	wait 60
	asm15 fadeinFromWhite
	checkpalettefadedone
	wait 30
	setspeed SPEED_200
	setanimation $00
	setangle $00
	applyspeed $0d
	wait 4
	setanimation $03
	setangle $18
	applyspeed $21
	wait 4
	setanimation $02
	wait 30
	showtextlowindex <TX_3b08
	retscript
	
smithyScript_smithingDone:
	wait 4
	enableinput
-
	checkabutton
	showtextlowindex <TX_3b09
	scriptjump -
	

; ==================================================================================================
; INTERAC_DIN
; ==================================================================================================
dinScript_subid2Init:
	loadscript scripts2.dinScript_subid2Init_body

dinScript_subid4Init:
	loadscript scripts2.dinScript_subid4Init_body

dinScript_stubInit:
	scriptend

dinScript_subid8Init:
	initcollisions
-
	checkabutton
	disableinput
	wait 10
	writeobjectbyte $78, $01
	asm15 scriptHelp.din_animateAndLookAtLink
	wait 8
	showtext TX_3d18
	enableinput
	writeobjectbyte $78, $00
	setanimation $06
	scriptjump -

dinScript_discoverLinkCollapsed:
	loadscript scripts2.dinScript_discoverLinkCollapsed_body


; interactionCodeaa
script769f:
	checkmemoryeq $cfc0, $01
	setanimation $01
	checkobjectbyteeq $61, $01
	writememory $cfc0, $02
	scriptend

script76ad:
	checkmemoryeq $cfc0, $02
	asm15 scriptHelp.seasonsFunc_15_62d9
	setanimation $03
	scriptend

script76b7:
	checkmemoryeq $cfc0, $03
	setangle $18
	setspeed SPEED_100
	applyspeed $20
	setcounter1 $06
	setanimation $04
	wait 30
	showtext TX_3d0a
	wait 30
	setangle $08
	setanimation $05
	setcounter1 $06
	applyspeed $20
	wait 10
	setanimation $07
	writememory $cfc0, $04
	setcounter1 $80
	scriptend

script76dc:
	checkmemoryeq $cfc0, $05
	setangle $18
	setspeed SPEED_100
	applyspeed $10
	setanimation $0a
	setangle $10
	setcounter1 $06
	applyspeed $10
	setanimation $0b
	setangle $18
	setcounter1 $06
	applyspeed $12
	setanimation $08
	setangle $00
	wait 30
	showtext TX_3d08
	setcounter1 $80
	writememory $cfc0, $06
	scriptend


; ==================================================================================================
; INTERAC_MOBLIN_KEEP_SCENES
; ==================================================================================================
moblinKeepSceneScript_linkSeenOnRightSide:
	setcoords $40, $70
	setcollisionradii $1c, $1c
	checkcollidedwithlink_ignorez
	setdisabledobjectsto91
	asm15 scriptHelp.moblinKeepScene_putLinkOnGround
	jumptable_memoryaddress wIsLinkedGame
	.dw @unlinked
	.dw @linked
@unlinked:
	jumpifroomflagset $40, @beenHereBefore
	showtextlowindex <TX_3f00
	orroomflag $40
	enableallobjects
	scriptend
@beenHereBefore:
	showtextlowindex <TX_3f01
	enableallobjects
	scriptend
@linked:
	jumpifroomflagset $40, @linkedBeenHereBefore
	showtextlowindex <TX_3f02
	orroomflag $40
	enableallobjects
	scriptend
@linkedBeenHereBefore:
	showtextlowindex <TX_3f03
	enableallobjects
	scriptend

moblinKeepSceneScript_settingUpFight:
	setcoords $68, $88
	setcollisionradii $08, $08
	checknotcollidedwithlink_ignorez
	createpuff
	wait 4
	settileat $68, $ac
	playsound SND_DOORCLOSE
	setcoords $40, $50
	setcollisionradii $28, $08
	checkcollidedwithlink_ignorez
	setdisabledobjectsto91
	asm15 scriptHelp.moblinKeepScene_putLinkOnGround
	asm15 scriptHelp.moblinKeepScene_faceLinkUp
	showtextlowindex <TX_3f04
	playsound SND_BOOMERANG
	wait 30
	setmusic MUS_MINIBOSS
	xorcfc0bit 0
	enableallobjects
	checkcfc0bit 0
	setdisabledobjectsto91
	callscript @slowExplosions
	callscript @slowExplosions
	callscript @quickExplosions
	callscript @quickExplosions
	callscript @quickExplosions
	callscript @quickExplosions
	callscript @quickExplosions
	callscript @quickExplosions
	asm15 scriptHelp.moblinKeepScene_warpOutOfMoblinKeep
	scriptend
@slowExplosions:
	playsound SND_BIG_EXPLOSION_2
	asm15 clearFadingPalettes
	wait 8
	playsound SND_BIG_EXPLOSION_2
	asm15 clearPaletteFadeVariablesAndRefreshPalettes
	wait 8
	retscript
@quickExplosions:
	playsound SND_BIG_EXPLOSION_2
	asm15 clearFadingPalettes
	wait 4
	playsound SND_BIG_EXPLOSION_2
	asm15 clearPaletteFadeVariablesAndRefreshPalettes
	wait 4
	retscript

moblinKeepSceneScript_postKeepDestruction:
	stopifroomflag40set
	disableinput
	asm15 setUpCharactersAfterMoblinKeepDestroyed
	showtextlowindex <TX_3f05
	xorcfc0bit 0
	setcounter1 $4b
	orroomflag $40
	enableinput
	scriptend


; interactionCodead
script779e:
	setspeed SPEED_0a0
-
	applyspeed $0e
	setcounter1 $50
	scriptjump -


; ==================================================================================================
; INTERAC_SHIP_PIRATIAN
; INTERAC_SHIP_PIRATIAN_CAPTAIN
; ==================================================================================================
pirateShipLoop:
	wait 30
	scriptjump pirateShipLoop

shipPirationScript_piratianComingDownHandler:
	setstate $03
	setdisabledobjectsto11
	wait 240
	spawninteraction INTERAC_SHIP_PIRATIAN, $02, $98, $78
	checkcfc0bit 0
	xorcfc0bit 0
	wait 240
	writememory wScreenShakeMagnitude, $02
	playsound SND_BIG_EXPLOSION
	wait 60
	setstate $02
	xorcfc0bit 2
	checkcfc0bit 0
	asm15 scriptHelp.shipPiratian_incCbb3
	scriptend

shipPiratianScript_piratianFromAbove:
	setstate $02
	setspeed SPEED_100
	callscript @moveLeftThenUp
	asm15 objectSetVisiblec1
	setzspeed -$01c0
	wait 30
	showtextlowindex <TX_4e01
	callscript @passConvoToPirateCaptain
	showtextlowindex <TX_4e03
	callscript @passConvoToPirateCaptain
	showtextlowindex <TX_4e05
	movedown $30
	moveright $10
	wait 30
	xorcfc0bit 0
	setcoords $f8, $f8
	checkcfc0bit 2
	xorcfc0bit 2
	setangleandanimation $18
	setcoords $98, $78
	callscript @moveLeftThenUp
	setzspeed -$01c0
	wait 30
	showtextlowindex <TX_4e06
	callscript @passConvoToPirateCaptain
	xorcfc0bit 7
	wait 30
	showtextlowindex <TX_4e08
	xorcfc0bit 0
	scriptjump pirateShipLoop
@moveLeftThenUp:
	setangleandanimation $18
	wait 30
	applyspeed $10
	moveup $30
	retscript
@passConvoToPirateCaptain:
	xorcfc0bit 1
	checkcfc0bit 2
	xorcfc0bit 2
	setzspeed -$01c0
	wait 30
	retscript

shipPirationScript_inShipLeavingSubrosia:
	setstate $02
	asm15 scriptHelp.shipPiratian_setRandomAnimation
	checkcfc0bit 1
	setzspeed -$01c0
	setangleandanimation $10
	checkcfc0bit 7
	setzspeed -$01c0
	scriptjump pirateShipLoop

shipPiratianScript_leavingSamasaDesert:
	setcoords $f8, $f8
	checkcfc0bit 0
-
	playsound SND_PIRATE_BELL
	wait 60
	scriptjump -

shipPiratianScript_dizzyPirate1Spawner:
	setstate $02
	setdisabledobjectsto11
	wait 180
	setmusic MUS_PIRATES
	spawninteraction INTERAC_SHIP_PIRATIAN, $0a, $98, $78
	checkcfc0bit 7
	wait 30
	showtextlowindex <TX_4e11
	asm15 scriptHelp.shipPiratian_incCbb3
	scriptend

shipPiratianScript_swapShip:
	setstate $02
	wait 10
	asm15 objectSetInvisible
	setcoords $58, $70
	asm15 setCameraFocusedObject
	setspeed SPEED_040
	moveright $20
-
	moveleft $40
	moveright $40
	playsound SND_WAVE
	scriptjump -

shipPiratianScript_1stDizzyPirateDescending:
	callscript shipPiratian_spinAround
	showtextlowindex <TX_4e0a
	callscript shipPiratian_spinFromDizziness
	callscript shipPiratian_spinFromDizziness
	callscript shipPiratian_spinFromDizziness
	writememory $d008, $03
	callscript shipPiratian_spinFromDizziness
	callscript shipPiratian_spinFromDizziness
	writememory $d008, $00
	wait 30
	showtextlowindex <TX_4e0b
	spawninteraction INTERAC_SHIP_PIRATIAN, $0b, $98, $78
	checkcfc0bit 7
	setzspeed -$01c0
	scriptjump pirateShipLoop

shipPiratian_spinFromDizziness:
	setangle $19
	applyspeed $10
	setangle $04
	applyspeed $10
	setangle $1c
	applyspeed $10
	setangle $00
	applyspeed $10
	retscript

shipPiratian_spinAround:
	setstate $04
	setspeed SPEED_080
	wait 60
	retscript

shipPirationScript_2ndDizzyPirateDescending:
	callscript shipPiratian_spinAround
	showtextlowindex <TX_4e0c
	writememory $d008, $02
	callscript @moveAroundUncontrollably
	callscript @moveAroundUncontrollably
	callscript @moveAroundUncontrollably
	writememory $d008, $01
	callscript @moveAroundUncontrollably
	writememory $d008, $00
	wait 30
	showtextlowindex <TX_4e0d
	spawninteraction INTERAC_SHIP_PIRATIAN, $0c, $98, $78
	checkcfc0bit 7
	setzspeed -$01c0
	scriptjump pirateShipLoop
@moveAroundUncontrollably:
	setangle $07
	applyspeed $0f
	setangle $1b
	applyspeed $10
	setangle $03
	applyspeed $10
	setangle $00
	applyspeed $10
	retscript

shipPirationScript_3rdDizzyPirateDescending:
	callscript shipPiratian_spinAround
	showtextlowindex <TX_4e0e
	writememory $d008, $02
	callscript shipPiratian_spinFromDizziness
	callscript shipPiratian_spinFromDizziness
	callscript shipPiratian_spinFromDizziness
	wait 30
	writememory $d008, $03
	showtextlowindex <TX_4e0f
	spawninteraction INTERAC_SHIP_PIRATIAN_CAPTAIN, $01, $98, $78
	checkcfc0bit 7
	setzspeed -$01c0
	scriptjump pirateShipLoop

shipPiratianScript_dizzyPiratiansAlreadyInside:
	setstate $04
	checkcfc0bit 7
	setzspeed -$01c0
	scriptjump pirateShipLoop

shipPiratianScript_landedInWestCoast_shipTopHalf:
	jumpifroomflagset $40, @landedInWestCoast
	scriptend
@landedInWestCoast:
	rungenericnpclowindex <TX_4e15
	
shipPiratianScript_landedInWestCoast_shipBottomHalf:
	jumpifglobalflagset GLOBALFLAG_PIRATE_SHIP_DOCKED, @alreadyDocked
	scriptend
@alreadyDocked:
	rungenericnpclowindex <TX_4e16

shipPiratianScript_insideDockedShip1:
	rungenericnpclowindex <TX_4e17

shipPiratianScript_insideDockedShip2:
	rungenericnpclowindex <TX_4e18

shipPiratianScript_insideDockedShip3:
	rungenericnpclowindex <TX_4e19

shipPiratianScript_insideDockedShip4:
	rungenericnpclowindex <TX_4e1a

shipPiratianScript_insideDockedShip5:
	rungenericnpclowindex <TX_4e1b

shipPiratianScript_ghostPiratian:
	setstate $02
	asm15 objectSetInvisible
	jumpifglobalflagset GLOBALFLAG_TALKED_WITH_GHOST_PIRATE, stubScript
	setcollisionradii $38, $30
	checkcollidedwithlink_onground
	createpuff
	writeobjectbyte $5c, $02
	initcollisions
	setstate $05
	asm15 interactionSetAlwaysUpdateBit
	checkabutton
	asm15 scriptHelp.shipPiratian_setAnimationIfLinkNear
	showtextlowindex <TX_4d01
	setdisabledobjectsto11
	wait 30
	createpuff
	setglobalflag GLOBALFLAG_TALKED_WITH_GHOST_PIRATE
	enableallobjects
--
	xorcfc0bit 0
	scriptend

shipPiratianScript_NWofGhostPiration:
	setstate $06
	asm15 objectSetInvisible
	setcollisionradii $06, $0a
-
	jumpifglobalflagset GLOBALFLAG_TALKED_WITH_GHOST_PIRATE, stubScript
	checkcollidedwithlink_onground
	showtextlowindex <TX_4d00
	scriptjump --

shipPiratianScript_NEofGhostPiration:
	setstate $06
	asm15 objectSetInvisible
	initcollisions
	scriptjump -

shipPiratianCaptainScript_leavingSubrosia:
	callscript @hop
	showtextlowindex <TX_4e02
	xorcfc0bit 2
	callscript @hop
	showtextlowindex <TX_4e04
	xorcfc0bit 2
	callscript @hop
	showtextlowindex <TX_4e07
	xorcfc0bit 2
	checkcfc0bit 7
	setzspeed -$01c0
	scriptjump pirateShipLoop
@hop:
	checkcfc0bit 1
	xorcfc0bit 1
	setzspeed -$01c0
	wait 30
	retscript

shipPiratianCaptainScript_gettingSick:
	setspeed SPEED_080
	callscript shipPiratian_spinFromDizziness
	callscript shipPiratian_spinFromDizziness
	writememory $d008, $02
	showtextlowindex <TX_4e10
	xorcfc0bit 7
	scriptjump pirateShipLoop

shipPiratianCaptainScript_arrivingInWestCoast:
	jumpifroomflagset $40, @arrived
	asm15 objectSetInvisible
	wait 4
	wait 60
	showtextlowindex <TX_4e12
	wait 60
	spawninteraction INTERAC_SHIP_PIRATIAN_CAPTAIN, $03, $68, $68
	orroomflag $40
	scriptend
@arrived:
	incstate
	setcoords $68, $78
	rungenericnpclowindex <TX_4e14

shipPiratianCaptainScript_inWestCoast:
	setspeed SPEED_100
	setangle $08
	applyspeed $10
	asm15 scriptHelp.shipPiratian_linkBoarding
	setdisabledobjectsto11
	wait 60
	showtextlowindex <TX_4e13
	resetmusic
	enableinput
	incstate
	rungenericnpclowindex <TX_4e14


; ==================================================================================================
; INTERAC_LINKED_CUTSCENE
; ==================================================================================================
linkedCutsceneScript_witches1:
	checkflagset $00, wScrollMode
	disablemenu
	setdisabledobjects $35
	wait 40
	setcoords $58, $38
	asm15 restartSound
	asm15 scriptHelp.seasonsFunc_15_632f
	checkpalettefadedone
	showtextlowindex <TX_5000
	wait 30
	asm15 scriptHelp.seasonsFunc_15_6347
	wait 40
	setmusic MUS_ONOX_CASTLE
	createpuff
	wait 4
	asm15 scriptHelp.seasonsFunc_15_635e
	wait 90
	xorcfc0bit 0
	wait 10
	showtextlowindex <TX_5001
	wait 30
	createpuff
	xorcfc0bit 1
	wait 20
	setmusic SNDCTRL_MEDIUM_FADEOUT
	wait 90
	asm15 scriptHelp.seasonsFunc_15_6334
	checkpalettefadedone
	resetmusic
	setglobalflag GLOBALFLAG_WITCHES_1_SEEN
	enableinput
	scriptend

linkedCutsceneScript_witches2:
	checkflagset $00, wScrollMode
	disablemenu
	setdisabledobjects $35
	setcoords $18, $50
	wait 60
	setmusic SNDCTRL_MEDIUM_FADEOUT
	wait 90
	asm15 scriptHelp.seasonsFunc_15_634c
	wait 40
	createpuff
	wait 4
	asm15 scriptHelp.seasonsFunc_15_6363
	wait 90
	showtextlowindex <TX_5002
	wait 30
	createpuff
	xorcfc0bit 7
	writememory $cfc6, $00
	asm15 scriptHelp.seasonsFunc_15_6378
	wait 1
	asm15 scriptHelp.seasonsFunc_15_6383
	setmusic MUS_DISASTER
	checkcfc0bit 0
	setdisabledobjectsto91
	showtextlowindex <TX_5003
	showtextlowindex <TX_5004
	showtextlowindex <TX_5005
	showtextlowindex <TX_5006
	xorcfc0bit 0
	wait 40
	playsound SND_BEAM2
	checkcfc0bit 0
	wait 60
	asm15 scriptHelp.seasonsFunc_15_63a6
	setglobalflag GLOBALFLAG_WITCHES_2_SEEN
	scriptend

linkedCutsceneScript_zeldaVillagers:
	writememory wDisableWarpTiles, $01
	setcollisionradii $02, $02
	checkcollidedwithlink_onground
	writememory wCutsceneTrigger, CUTSCENE_S_ZELDA_VILLAGERS
	scriptend

linkedCutsceneScript_zeldaKidnapped:
	writememory wCutsceneTrigger, CUTSCENE_S_ZELDA_KIDNAPPED
	scriptend

linkedCutsceneScript_flamesOfDestruction:
	writememory wCutsceneTrigger, CUTSCENE_S_FLAME_OF_DESTRUCTION
	scriptend


; ==================================================================================================
; INTERAC_AMBI
; ==================================================================================================
ambiScript_mrsRuulsHouse:
	initcollisions
--
	checkabutton
	jumpifglobalflagset GLOBALFLAG_TALKED_TO_AMBI, @talkedToAmbi
	setglobalflag GLOBALFLAG_TALKED_TO_AMBI
	showtextlowindex <TX_3a39
	scriptjump --
@talkedToAmbi:
	showtextlowindex <TX_3a36
	scriptjump --
	
ambiScript_outsideSyrupHut:
	initcollisions
--
	checkabutton
	jumpifglobalflagset GLOBALFLAG_TALKED_TO_AMBI, @talkedToAmbi
	setglobalflag GLOBALFLAG_TALKED_TO_AMBI
	showtextlowindex <TX_3a3a
	scriptjump --
@talkedToAmbi:
	showtextlowindex <TX_3a37
	scriptjump --
	
ambiScript_samasaShore:
	initcollisions
--
	checkabutton
	jumpifglobalflagset GLOBALFLAG_TALKED_TO_AMBI, @talkedToAmbi
	setglobalflag GLOBALFLAG_TALKED_TO_AMBI
	showtextlowindex <TX_3a3b
	scriptjump --
@talkedToAmbi:
	showtextlowindex <TX_3a38
	scriptjump --
	
ambiScript_enteringPirateHouseBeforePiratesLeave:
	writeobjectbyte $7f, $01
	setspeed SPEED_080
	moveup $41
	xorcfc0bit 1
	checkcfc0bit 2
	applyspeed $09
	setcounter1 $ff
	scriptend
	
ambiScript_pirateHouseAfterTheyLeft:
	rungenericnpclowindex <TX_3a2b


; ==================================================================================================
; INTERAC_HORON_DOG_CREDITS
; ==================================================================================================
horonDogCreditsScript:
	setspeed SPEED_080
	wait 180
-
	setangle $18
	applyspeed $18
	setcounter1 $06
	setangle $08
	applyspeed $14
	wait 120
	scriptjump -
	
	
; ==================================================================================================
; INTERAC_ba
; ==================================================================================================
zeldaNPCScript_stub:
	scriptend
	
zeldaNPCScript_ba_subid1:
	setcoords $18, $18
	setspeed SPEED_200
	movedown $19
	wait 4
	moveright $1d
	wait 4
	setanimation $00
	wait 4
	showtext TX_500e
	wait 30
	showtext TX_500f
	wait 30
	xorcfc0bit 0
	setspeed SPEED_100
	setangle $18
	applyspeed $11
	setanimation $01
	wait 8
	setanimation $02
	setcounter1 $ff
	scriptend
	
zeldaNPCScript_ba_subid3:
	checkmemoryeq $cfc0, $08
	setspeed SPEED_100
	moveup $31
	checkmemoryeq $cfc0, $0b
	movedown $31
	scriptend
	
	
; ==================================================================================================
; INTERAC_bc
; INTERAC_bd
; INTERAC_be
; ==================================================================================================
zeldaNPCScript_bc_subid1:
	settextid TX_0601
	
zeldaNPCScript_faceLinkShowText:
	initcollisions
-
	checkabutton
	asm15 scriptHelp.faceOppositeDirectionAsLink
	showloadedtext
	wait 10
	setanimationfromobjectbyte $7b
	scriptjump -
	
zeldaNPCScript_bc_subid2:
	settextid TX_0604
	scriptjump zeldaNPCScript_faceLinkShowText
	
zeldaNPCScript_bd_subid1:
	settextid TX_0603
	scriptjump zeldaNPCScript_faceLinkShowText
	
zeldaNPCScript_bd_subid2:
	settextid TX_0606
	scriptjump zeldaNPCScript_faceLinkShowText
	
zeldaNPCScript_be_subid1:
	settextid TX_0602
	scriptjump zeldaNPCScript_faceLinkShowText
	
zeldaNPCScript_be_subid2:
	settextid TX_0605
	scriptjump zeldaNPCScript_faceLinkShowText
	
	
; ==================================================================================================
; INTERAC_MAYORS_HOUSE_UNLINKED_GIRL
; ==================================================================================================
mayorsHouseGirlScript:
	initcollisions
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @finishedGame
	settextid TX_3101
	scriptjump @showLoadedText
@finishedGame:
	settextid TX_310a
@showLoadedText:
	checkabutton
	showloadedtext
	scriptjump @showLoadedText


; ==================================================================================================
; INTERAC_ZELDA_KIDNAPPED_ROOM
; ==================================================================================================
ZeldaBeingKidnappedScript:
	loadscript scripts2.ZeldaBeingKidnappedEvent_body


; ==================================================================================================
; INTERAC_BOOMERANG_SUBROSIAN
; ==================================================================================================
boomerangSubrosianScript:
	rungenericnpc TX_3e18


; ==================================================================================================
; INTERAC_TROY
; ==================================================================================================
troyScript_beginningSecret:
	initcollisions
--
	enableinput
	checkabutton
	disableinput
	showtextlowindex <TX_4c00
	jumpiftextoptioneq $00, @awaitSecret
	scriptjump +
+
	wait 30
	showtextlowindex <TX_4c01
	scriptjump --
@awaitSecret:
	wait 30
	askforsecret CLOCK_SHOP_SECRET
	wait 30
	jumptable_memoryaddress wTextInputResult
	.dw @correct
	.dw @incorrect
@incorrect:
	showtextlowindex <TX_4c02
	scriptjump --
@correct:
	setglobalflag GLOBALFLAG_BEGAN_CLOCK_SHOP_SECRET
	showtextlowindex <TX_4c03
	jumpiftextoptioneq $00, troyScript_acceptedQuest
	scriptjump troyScript_rejectedQuest


troyScript_beganSecret:
	initcollisions
-
	enableinput
	checkabutton
	disableinput
	showtextlowindex <TX_4c0e
	jumpiftextoptioneq $00, troyScript_acceptedQuest
	
troyScript_rejectedQuest:
	wait 30
	showtextlowindex <TX_4c04
	scriptjump -
	
troyScript_acceptedQuest:
	wait 30
	showtextlowindex <TX_4c05
	jumpiftextoptioneq $00, @understoodQuest
	scriptjump troyScript_acceptedQuest
	
@understoodQuest:
	settileat $9d, $ac
	wait 15
	
troyScript_playGame:
	wait 30
	showtextlowindex <TX_4c06
	createpuff
	wait 4
	asm15 scriptHelp.seasonsFunc_15_6455
	setcounter1 $2d
	playsound SND_WHISTLE
	setmusic MUS_MINIBOSS
	writeobjectbyte $71, $00
	asm15 scriptHelp.seasonsFunc_15_6443
	enableinput
	incstate
	scriptend
	
	
troyScript_gameBegun:
	disableinput
	resetmusic
	playsound SND_WHISTLE
	writeobjectbyte Interaction.var31, $00
	asm15 fadeoutToWhite
	checkpalettefadedone
	asm15 scriptHelp.seasonsFunc_15_6464
	wait 30
	asm15 fadeinFromWhite
	checkpalettefadedone
	jumptable_objectbyte Interaction.var3a
	.dw @wonGame
	.dw troyScript_tookTooLong
	
@wonGame:
	showtextlowindex <TX_4c0a
	createpuff
	wait 4
	asm15 scriptHelp.seasonsFunc_15_645d
	setcounter1 $2d
	showtextlowindex <TX_4c0b
	disableinput
	callscript troyScript_postGameEffects
	callscript troyScript_giveReward
	writememory $cbea, $ff
	wait 90
	enableallobjects
	setdisabledobjectsto91
	settileat $9d, TILEINDEX_INDOOR_UPSTAIRCASE
	setcounter1 $2d
	setglobalflag GLOBALFLAG_DONE_CLOCK_SHOP_SECRET

troyScript_generateReturnSecret:
	generatesecret CLOCK_SHOP_RETURN_SECRET
-
	showtextlowindex <TX_4c0c
	wait 30
	jumpiftextoptioneq $00, -
	showtextlowindex <TX_4c0d
	enableinput
	wait 30

troyScript_doneBiggoronSecret:
	checkabutton
	disableinput
	scriptjump troyScript_generateReturnSecret


troyScript_giveReward:
	jumptable_objectbyte Interaction.var03
	.dw @nobleSword
	.dw @masterSword
@nobleSword:
	giveitem TREASURE_SWORD, $01
	giveitem TREASURE_SWORD, $04
	retscript
@masterSword:
	giveitem TREASURE_SWORD, $02
	giveitem TREASURE_SWORD, $05
	retscript
	
	
troyScript_postGameEffects:
	asm15 scriptHelp.troyMinigame_createSparkle
	wait 30
	asm15 scriptHelp.createSwirlAtLink
	wait 10
	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	wait 20
	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	wait 20
	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	checkpalettefadedone
	wait 20
	asm15 fadeinFromWhiteWithDelay, $04
	checkpalettefadedone
	retscript
	
	
troyScript_tookTooLong:
	showtextlowindex <TX_4c08
	createpuff
	wait 4
	asm15 scriptHelp.seasonsFunc_15_645d
	setcounter1 $2d
	showtextlowindex <TX_4c09
	jumpiftextoptioneq $00, troyScript_playGame
	settileat $9d, TILEINDEX_INDOOR_UPSTAIRCASE
	wait 15
	writeobjectbyte Interaction.var31, $00
	scriptjump troyScript_rejectedQuest


troyScript_doneSecret:
	initcollisions
	scriptjump troyScript_doneBiggoronSecret


; ==================================================================================================
; INTERAC_LINKED_GAME_GHINI
; ==================================================================================================
linkedGhiniScript_beginningSecret:
	initcollisions
-
	enableinput
	checkabutton
	disableinput
	showtextlowindex <TX_4c0f
	jumpiftextoptioneq $00, @answeredYes
	scriptjump @answeredNo
@answeredNo:
	wait 30
	showtextlowindex <TX_4c10
	scriptjump -
@answeredYes:
	wait 30
	askforsecret GRAVEYARD_SECRET
	wait 30
	jumptable_memoryaddress $cca3
	.dw @success
	.dw @failed
@failed:
	showtextlowindex <TX_4c12
	scriptjump -
@success:
	setglobalflag GLOBALFLAG_BEGAN_GRAVEYARD_SECRET
	showtextlowindex <TX_4c11
	jumpiftextoptioneq $00, linkedGhiniScript_begunSecret@showExplanation
	scriptjump linkedGhiniScript_begunSecret@shownExit


linkedGhiniScript_begunSecret:
	initcollisions
-
	enableinput
	checkabutton
	disableinput
	showtextlowindex <TX_4c14
	jumpiftextoptioneq $00, @showExplanation
@shownExit:
	wait 30
	showtextlowindex <TX_4c13
	scriptjump -
@showExplanation:
	wait 30
	showtextlowindex <TX_4c15
	jumpiftextoptioneq $00, @understoodExplanation
	scriptjump @showExplanation
@understoodExplanation:
	asm15 fadeoutToWhite
	checkpalettefadedone
	wait 4
	asm15 scriptHelp.linkedGhini_forceLinksPositionAndState
	settileat $61, $a2
	wait 4
	asm15 fadeinFromWhite
	checkpalettefadedone
@startGame:
	wait 30
	showtextlowindex <TX_4c16
	createpuff
	wait 4
	asm15 scriptHelp.linkedGhini_clearAllAndSetInvisible
	setcounter1 $2d
	playsound SND_WHISTLE
	scriptend


linkedGhiniScript_startRound:
	disableinput
	playsound SND_WHISTLE
	wait 30
	createpuff
	wait 4
	asm15 scriptHelp.linkedGhini_setVisible
	setcounter1 $2d
	showtextlowindex <TX_4c17
	asm15 scriptHelp.seasonsFunc_15_64a0
	wait 30
	jumptable_objectbyte $7f
	.dw @successfulRound
	.dw @failedGame
@successfulRound:
	jumptable_objectbyte $7a
	.dw @succeededOnce
	.dw @succeededTwice
	.dw @succeededAll
@succeededOnce:
@succeededTwice:
	playsound SND_GETSEED
	showtextlowindex <TX_4c19
	scriptjump linkedGhiniScript_begunSecret@startGame
@succeededAll:
	playsound SND_GETSEED
	showtextlowindex <TX_4c1a
	wait 30
	giveitem TREASURE_HEART_CONTAINER, $02
	wait 60
	spawninteraction INTERAC_PUFF, $00, $68, $18
	wait 4
	settileat $61, TILEINDEX_INDOOR_UPSTAIRCASE
	setcounter1 $2d
	setglobalflag GLOBALFLAG_DONE_GRAVEYARD_SECRET
@generateSecret:
	generatesecret GRAVEYARD_RETURN_SECRET
-
	showtextlowindex <TX_4c1b
	wait 30
	jumpiftextoptioneq $00, @understoodSecret
	scriptjump -
@understoodSecret:
	showtextlowindex <TX_4c1c
	enableinput
@doneBiggoronSecret:
	checkabutton
	disableinput
	scriptjump @generateSecret
@failedGame:
	playsound SND_ERROR
	showtextlowindex <TX_4c18
	jumpiftextoptioneq $00, linkedGhiniScript_begunSecret@startGame
	spawninteraction INTERAC_PUFF, $00, $68, $18
	wait 4
	settileat $61, TILEINDEX_INDOOR_UPSTAIRCASE
	wait 15
	scriptjump linkedGhiniScript_begunSecret@shownExit


linkedGhiniScript_doneSecret:
	initcollisions
	scriptjump linkedGhiniScript_startRound@doneBiggoronSecret


; ==================================================================================================
; INTERAC_GOLDEN_CAVE_SUBROSIAN
; ==================================================================================================
goldenCaveSubrosianScript_beginningSecret:
	initcollisions
-
	enableinput
	checkabutton
	disableinput
	showtextlowindex <TX_4c1e
	jumpiftextoptioneq $00, @givingSecret
	wait 20
	showtextlowindex <TX_4c1f
	scriptjump -
@failed:
	showtextlowindex <TX_4c20
	scriptjump -
@givingSecret:
	askforsecret SUBROSIAN_SECRET
	wait 20
	jumptable_memoryaddress $cca3
	.dw @success
	.dw @failed
@success:
	orroomflag $80
	showtextlowindex <TX_4c21
	jumpiftextoptioneq $00, @answeredYes
	wait 20
	showtextlowindex <TX_4c22
	scriptjump goldenCaveSubrosianScript_givenSecret
@answeredYes:
	wait 20
	showtextlowindex <TX_4c23
	jumpiftextoptioneq $01, @answeredYes
	wait 20
	showtextlowindex <TX_4c24
	wait 20
	asm15 scriptHelp.seasonsFunc_15_653c, $01
	asm15 scriptHelp.goldenCaveSubrosian_refreshRoom, $87
	scriptend
	
	
goldenCaveSubrosianScript_7d00:
	initcollisions
	setcoords $88, $88
	setangleandanimation $00
	writeobjectbyte $79, $00
	setdisabledobjectsto11
	asm15 scriptHelp.goldenCaveSubrosian_emptyLinksItemsAndSetPosition
	asm15 scriptHelp.seasonsFunc_15_6545
	jumpifobjectbyteeq $7c, $03, script7d19
	asm15 scriptHelp.putAwayLinksItems, TREASURE_BOOMERANG
script7d19:
	checkpalettefadedone
	asm15 scriptHelp.seasonsFunc_15_6518
	writememory $cc02, $01
	wait 20
	showloadedtext
	setspeed SPEED_200
	setangleandanimation $10
	applyspeed $09
	wait 8
	setangleandanimation $18
	applyspeed $09
	wait 8
	setangleandanimation $00
	enableallobjects
script7d32:
	checkabutton
	asm15 scriptHelp.seasonsFunc_15_64e9
	jumptable_objectbyte $79
	.dw script7d40
	.dw script7d6b
	.dw script7d72
	.dw script7d77
script7d40:
	setdisabledobjectsto11
	settextid TX_4c28
script7d44:
	showloadedtext
	jumpiftextoptioneq $01, script7d56
	wait 20
	showtextlowindex <TX_4c3f
	wait 20
	asm15 scriptHelp.goldenCaveSubrosian_refreshRoom, $87
	asm15 scriptHelp.seasonsFunc_15_653c, $03
	scriptend
script7d56:
	wait 20
	showtextlowindex <TX_4c22
	setspeed SPEED_100
	setangleandanimation $00
	applyspeed $10
	wait 8
	wait 8
	setangleandanimation $10
	asm15 scriptHelp.seasonsFunc_15_5cf7
	asm15 scriptHelp.seasonsFunc_15_652e
	rungenericnpclowindex <TX_4c22
script7d6b:
	showtextlowindex <TX_4c29
	writeobjectbyte $79, $00
	scriptjump script7d32
script7d72:
	settextid TX_4c3e
	scriptjump script7d44
script7d77:
	setdisabledobjectsto11
	showtextlowindex <TX_4c2a
	writeobjectbyte $4f, $00
	wait 20
	asm15 scriptHelp.seasonsFunc_15_653c, $02
	asm15 scriptHelp.goldenCaveSubrosian_refreshRoom, $57
	scriptend
	
	
goldenCaveSubrosianScript_7d87:
	initcollisions
	setcoords $48, $78
	setangleandanimation $10
	disableinput
	asm15 scriptHelp.goldenCaveSubrosian_faceLinkUp
	asm15 scriptHelp.seasonsFunc_15_5cf7
	checkpalettefadedone
	showtextlowindex <TX_4c2b
	wait 20
	giveitem TREASURE_BOMBCHUS, $00
	wait 20
--
	generatesecret SUBROSIAN_RETURN_SECRET
-
	showtextlowindex <TX_4c2c
	wait 20
	jumpiftextoptioneq $01, -
	showtextlowindex <TX_4c2d
	asm15 scriptHelp.seasonsFunc_15_652e
	setglobalflag GLOBALFLAG_DONE_SUBROSIAN_SECRET
script7dac:
	initcollisions
	enableinput
	checkabutton
	disableinput
	scriptjump --
	
	
goldenCaveSubrosianScript_givenSecret:
	initcollisions
	enableinput
	checkabutton
	disableinput
	scriptjump goldenCaveSubrosianScript_beginningSecret@success
	
	
; ==================================================================================================
; INTERAC_LINKED_MASTER_DIVER
; ==================================================================================================
masterDiverScript_beginningSecret:
	initcollisions
-
	enableinput
	checkabutton
	disableinput
	showtextlowindex <TX_4c2e
	jumpiftextoptioneq $00, @answeredYes
	scriptjump @answeredNo
@answeredNo:
	wait 30
	showtextlowindex <TX_4c2f
	scriptjump -
@answeredYes:
	wait 30
	askforsecret DIVER_SECRET
	wait 30
	jumptable_memoryaddress $cca3
	.dw @success
	.dw @failed
@failed:
	showtextlowindex <TX_4c30
	scriptjump -
@success:
	setglobalflag GLOBALFLAG_BEGAN_DIVER_SECRET
	showtextlowindex <TX_4c31
	jumpiftextoptioneq $00, masterDiverScript_begunSecret@answeredYes
	scriptjump masterDiverScript_begunSecret@beginningSecret
	
	
masterDiverScript_begunSecret:
	initcollisions
-
	enableinput
	checkabutton
	disableinput
	showtextlowindex <TX_4c3c
	jumpiftextoptioneq $00, @answeredYes
@beginningSecret:
	wait 30
	showtextlowindex <TX_4c32
	scriptjump -
@answeredYes:
	wait 30
	showtextlowindex <TX_4c33
-
	wait 30
	showtextlowindex <TX_4c34
	jumpiftextoptioneq $00, @startingChallenge
	scriptjump -
@startingChallenge:
	spawninteraction INTERAC_PUFF, $00, $58, $88
	wait 4
	settileat $58, TILEINDEX_INDOOR_DOWNSTAIRCASE
	setcounter1 $2d
-
	showtextlowindex <TX_4c35
	enableinput
	checkabutton
	disableinput
	scriptjump -
	
	
masterDiverScript_swimmingChallengeText:
	disableinput
	wait 40
	showtextlowindex <TX_4c36
	asm15 scriptHelp.seasonsFunc_15_654e
	setcounter1 $2d
	playsound SND_WHISTLE
	enableinput
-
	jumpifitemobtained TREASURE_60, @finishedChallenge
	scriptjump -
@finishedChallenge:
	disableinput
	orroomflag $40
	playsound SND_WHISTLE
	asm15 scriptHelp.masterDiver_checkIfDoneIn30Seconds
	asm15 scriptHelp.linkedFunc_15_6430
	wait 30
	jumpifglobalflagset GLOBALFLAG_SWIMMING_CHALLENGE_SUCCEEDED, @finishedInTime
	showtextlowindex <TX_4c37
	jumpiftextoptioneq $00, @retry
	asm15 scriptHelp.masterDiver_exitChallenge
	scriptend
@retry:
	asm15 scriptHelp.seasonsFunc_15_6558
	asm15 scriptHelp.masterDiver_retryChallenge
	scriptend
@finishedInTime:
	showtextlowindex <TX_4c38
	asm15 scriptHelp.masterDiver_exitChallenge
	scriptend
	

masterDiverScript_swimmingChallengeDone:
	disableinput
	initcollisions
	asm15 scriptHelp.masterDiver_forceLinkState
	jumpifglobalflagset GLOBALFLAG_SWIMMING_CHALLENGE_SUCCEEDED, @finishedInTime
	scriptjump @failed
@finishedInTime:
	wait 40
	showtextlowindex <TX_4c39
	asm15 scriptHelp.linkedScript_giveRing, SWIMMERS_RING
	setcounter1 $02
	setglobalflag GLOBALFLAG_DONE_DIVER_SECRET
-
	showtextlowindex <TX_4c3a
	enableinput
@showDoneText:
	checkabutton
	disableinput
	scriptjump -
@failed:
	showtextlowindex <TX_4c30
	enableinput
	checkabutton
	disableinput
	scriptjump @failed
	
	
masterDiverScript_secretDone:
	initcollisions
	scriptjump masterDiverScript_swimmingChallengeDone@showDoneText
	
	
masterDiverScript_spawnFakeStarOre:
	spawnitem TREASURE_60, $01
	scriptend
	
	
; ==================================================================================================
; INTERAC_GREAT_FAIRY
; Temple fairy that awaits a secret
; ==================================================================================================
templeGreatFairyScript_beginningSecret:
	initcollisions
-
	enableinput
	checkabutton
	disableinput
	showtextlowindex <TX_4101
	jumpiftextoptioneq $00, @tellSecret
@failedSecret:
	wait 30
	showtextlowindex <TX_4102
	scriptjump -
@tellSecret:
	askforsecret TEMPLE_SECRET
	wait 30
	jumptable_memoryaddress $cca3
	.dw @success
	.dw @failedSecret
@success:
	showtextlowindex <TX_4103
	wait 30
	asm15 scriptHelp.linkedScript_giveRing, HEART_RING_L1
	wait 30
-
	showtextlowindex <TX_4104
	setglobalflag GLOBALFLAG_DONE_TEMPLE_SECRET
	enableinput
	

templeGreatFairyScript_doneSecret:
	initcollisions
	checkabutton
	scriptjump -


; ==================================================================================================
; INTERAC_DEKU_SCRUB
; ==================================================================================================
dekuScrubScript_notFinishedGame:
	initcollisions
-
	enableinput
	checkabutton
	disableinput
	showtextlowindex <TX_4c48
	wait 20
	jumpiftextoptioneq $00, @refillSatchel
	showtextlowindex <TX_4c41
	scriptjump -
@refillSatchel:
	showtextlowindex <TX_4c49
	asm15 refillSeedSatchel
	wait 20
-
	showtextlowindex <TX_4c4a
	enableinput
	checkabutton
	disableinput
	scriptjump -


dekuScrubScript_beginningSecret:
	initcollisions
-
	enableinput
	checkabutton
	disableinput
	showtextlowindex <TX_4c40
	jumpiftextoptioneq $00, @linkKnowsSong
@failedSecret:
	wait 20
	showtextlowindex <TX_4c41
	scriptjump -
@linkKnowsSong:
	askforsecret DEKU_SECRET
	jumptable_memoryaddress wTextInputResult
	.dw @success
	.dw @failedSecret
@success:
	orroomflag $80
	wait 20
	showtextlowindex <TX_4c42
	wait 20
dekuScrubScript_finishSecret:
	asm15 scriptHelp.dekuScrub_upgradeSatchel
	jumpifobjectbyteeq Interaction.var38, $00, dekuScrubScript_gaveSecret
	showtextlowindex <TX_4c44
	wait 20
	giveitem TREASURE_SATCHEL_UPGRADE, $00
	asm15 refillSeedSatchel
	wait 20
	showtextlowindex <TX_4c45
	wait 20
	setglobalflag GLOBALFLAG_DONE_DEKU_SECRET
	scriptjump dekuScrubScript_giveReturnSecret


dekuScrubScript_doneSecret:
	initcollisions
--
	checkabutton
	disableinput
dekuScrubScript_giveReturnSecret:
	generatesecret DEKU_RETURN_SECRET
	showtextlowindex <TX_4c46
	wait 20
	jumpiftextoptioneq $00, dekuScrubScript_giveReturnSecret
	showtextlowindex <TX_4c47
	enableinput
	scriptjump --


dekuScrubScript_gaveSecret:
	initcollisions
	enableinput
	checkabutton
	disableinput
	showtextlowindex <TX_4c43
	wait 30
	scriptjump dekuScrubScript_finishSecret


; ==================================================================================================
; INTERAC_GOLDEN_BEAST_OLD_MAN
; ==================================================================================================
goldenBeastOldManScript:
	initcollisions
-
	checkabutton
	asm15 seasonsInteractionsBank15.checkGoldenBeastsKilled
	jumptable_memoryaddress $cfc1
	.dw @notSlayed4Beasts
	.dw @slayed4Beasts
@notSlayed4Beasts:
	showtextlowindex <TX_1f04
	scriptjump -
@slayed4Beasts:
	showtextlowindex <TX_1f05
	disableinput
	asm15 seasonsInteractionsBank15.giveRedRing
	wait 20
	showtextlowindex <TX_1f06
	wait 20
	orroomflag $40
	enableinput
	createpuff
	scriptend


; ==================================================================================================
; INTERAC_VIRE
; ==================================================================================================
vireScript:
	wait 30
	showtext TX_2f10
	wait 30
	showtext TX_2f11
	wait 30
	scriptend


; ==================================================================================================
; INTERAC_LINKED_HEROS_CAVE_OLD_MAN
; ==================================================================================================
linkedHerosCaveOldManScript:
	initcollisions
	jumpifroomflagset $80, @puzzleDone
-
	checkabutton
	showtextlowindex <TX_3303
	jumpiftextoptioneq $00, @answeredYes
	showtextlowindex <TX_3305
	scriptjump -
@notEnoughRupees:
	showtextlowindex <TX_3306
	scriptjump -
@answeredYes:
	asm15 seasonsInteractionsBank15.linkedHerosCaveOldMan_takeRupees
	jumptable_memoryaddress $cfd0
	.dw @notEnoughRupees
	.dw @hasEnoughRupees
@hasEnoughRupees:
	disableinput
	asm15 seasonsInteractionsBank15.linkedHerosCaveOldMan_spawnChests
	wait 60
	showtextlowindex <TX_3304
	enableinput
-
	checkabutton
	jumpifroomflagset $80, @puzzleSucceeded
	showtextlowindex <TX_3304
	scriptjump -
@puzzleSucceeded:
	showtextlowindex <TX_3307
@puzzleDone:
	rungenericnpclowindex <TX_3307


; ==================================================================================================
; INTERAC_GET_ROD_OF_SEASONS
; ==================================================================================================
gettingRodOfSeasonsScript:
	loadscript scripts2.gettingRodOfSeasons_body

gettingRodOfSeasonsScript_setCounter1To32:
	setcounter1 $32
	scriptend

