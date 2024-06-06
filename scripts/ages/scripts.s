; Scripts for interactions are in this file. You may want to cross-reference with the corresponding
; assembly code to get the full picture (run "git grep INTERACID_X" to search for its code).

.include "scripts/common/commonScripts.s"

; ==============================================================================
; INTERACID_DUNGEON_SCRIPT
; ==============================================================================
.include "scripts/ages/dungeonScripts.s"


; ==============================================================================
; INTERACID_BIPIN
; ==============================================================================

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


; ==============================================================================
; INTERACID_ADLAR
; ==============================================================================
adlarScript:
	initcollisions
	jumptable_objectbyte Interaction.var38
	.dw @firstMeeting
	.dw @nayruPossessed
	.dw @queenPossessed
	.dw @queenMissing
	.dw @queenBackToNormal

@firstMeeting:
	checkabutton
	showtext TX_3710
	orroomflag $40
@nayruPossessed:
	checkabutton
	showtext TX_3711
	scriptjump @nayruPossessed

@queenPossessed:
	checkabutton
	showtext TX_3712
	scriptjump @queenPossessed

@queenMissing:
	checkabutton
	showtext TX_3716
	scriptjump @queenMissing

@queenBackToNormal:
	checkabutton
	showtext TX_3713
	scriptjump @queenBackToNormal


; ==============================================================================
; INTERACID_LIBRARIAN
; ==============================================================================
librarianScript:
	makeabuttonsensitive
@loop:
	checkabutton
	showloadedtext
	scriptjump @loop


; ==============================================================================
; INTERACID_BLOSSOM
; ==============================================================================

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
.ifdef REGION_JP
	enableallobjects
.else
	enableinput
.endif
	scriptjump @loop

@validName:
	showtextlowindex <TX_4407
.ifndef REGION_JP
	disableinput
.endif
	jumptable_memoryaddress wSelectedTextOption
	.dw @nameConfirmed
	.dw @askForName

@nameConfirmed:
	asm15 scriptHelp.blossom_decideInitialChildStatus
	asm15 scriptHelp.setc6e2Bit, $00
	asm15 scriptHelp.setNextChildStage, $01
	wait 30
	showtextlowindex <TX_4408
.ifdef REGION_JP
	enableallobjects
.else
	enableinput
.endif

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




; ==============================================================================
; INTERACID_VERAN_CUTSCENE_FACE
; ==============================================================================
veranFaceCutsceneScript:
	loadscript scriptHelp.veranFaceCutsceneScript


; ==============================================================================
; INTERACID_OLD_MAN_WITH_RUPEES
; ==============================================================================

oldManScript_givesRupees:
	initcollisions
	jumpifroomflagset $40, @alreadyGaveMoney
	checkabutton
	disableinput
	showtextlowindex <TX_3318
	asm15 scriptHelp.oldMan_giveRupees
	wait 8
	checkrupeedisplayupdated
	orroomflag $40
	enableinput

@alreadyGaveMoney:
	checkabutton
	showtextlowindex <TX_3319
	scriptjump @alreadyGaveMoney


oldManScript_takesRupees:
	initcollisions
	jumpifroomflagset $40, @alreadyTookMoney
	checkabutton
	disableinput
	showtextlowindex <TX_3315
	asm15 scriptHelp.oldMan_takeRupees
	jumpifobjectbyteeq Interaction.var3f, $00, @linkIsBroke
	wait 8
	checkrupeedisplayupdated
	orroomflag $40
	enableinput

@alreadyTookMoney:
	checkabutton
	showtextlowindex <TX_3316
	scriptjump @alreadyTookMoney

@linkIsBroke:
	wait 30
	showtextlowindex <TX_3317
	enableinput
	scriptjump @alreadyTookMoney


; ==============================================================================
; INTERACID_SHOOTING_GALLERY
; ==============================================================================

shootingGalleryScript_humanNpc:
	setcollisionradii $06, $16
	makeabuttonsensitive

@loop:
	checkabutton
	disableinput
	showtext TX_0800
	wait 30
	jumpiftextoptioneq $00, @repliedYes

@repliedNo:
	showtext TX_0802
	enableinput
	wait 30
	writeobjectbyte Interaction.var31, $00
	scriptjump @loop

@tryAgain:
	disableinput
	showtext TX_081a
	wait 30
	jumpiftextoptioneq $00, @repliedYes
	scriptjump @repliedNo

@repliedYes:
	asm15 scriptHelp.shootingGallery_checkLinkHasRupees, RUPEEVAL_10
	jumpifmemoryset wcddb, $80, @enoughRupees

@notEnoughRupees:
	showtext TX_0803
	enableinput
	checkabutton
	scriptjump @notEnoughRupees

@enoughRupees:
	asm15 removeRupeeValue, RUPEEVAL_10
	showtext TX_0801
	wait 30
	jumpiftextoptioneq $00, @beginGame

@giveExplanation:
	showtext TX_0804
	wait 30
	jumpiftextoptioneq $00, @beginGame
	scriptjump @giveExplanation

@beginGame:
	showtext TX_0805

shootingGallery_fadeIntoGameWithSword:
	wait 40
	asm15 fadeoutToWhite
	checkpalettefadedone

	asm15 scriptHelp.shootingGallery_equipSword
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 scriptHelp.shootingGallery_initLinkPosition
	asm15 scriptHelp.shootingGallery_setEntranceTiles, $02
	wait 20
	asm15 fadeinFromWhite
	checkpalettefadedone

shootingGallery_beginGame:
	setmusic MUS_MINIGAME
	wait 40
	wait 30
	asm15 scriptHelp.shootingGallery_beginGame
	enableallobjects
	scriptend



shootingGalleryScript_goronNpc:
	setcollisionradii $06, $16
	makeabuttonsensitive

@loop:
	checkabutton
	jumpifmemoryeq wTmpcfc0.shootingGallery.disableGoronNpcs, $01, @loop

	disableinput
	jumpifroomflagset $20, @normalGame

; playing for lava juice

	showtext TX_24d4
	wait 30
	jumpiftextoptioneq $00, @answeredYes

	; Answered no
	showtext TX_24d5
	enableinput
	wait 30
	writeobjectbyte Interaction.var31, $00
	scriptjump @loop

@normalGame:
	showtext TX_24cf
	wait 30
	jumpiftextoptioneq $00, @answeredYes

@answeredNo:
	showtext TX_24d0
	enableinput
	wait 30
	writeobjectbyte Interaction.var31, $00
	scriptjump @loop

@tryAgain:
	disableinput
	showtext TX_24df
	wait 30
	jumpiftextoptioneq $00, @answeredYes
	scriptjump @answeredNo

@answeredYes:
	asm15 scriptHelp.shootingGallery_checkLinkHasRupees, RUPEEVAL_20
	jumpifmemoryset wcddb, $80, @enoughRupees

@notEnoughRupees:
	showtext TX_24d2
	enableinput
	checkabutton
	scriptjump @notEnoughRupees

@enoughRupees:
	disableinput
	asm15 removeRupeeValue, RUPEEVAL_20
	showtext TX_24d1
	wait 30
	jumpiftextoptioneq $00, @beginGame

@giveExplanation:
	showtext TX_24d3
	wait 30
	jumpiftextoptioneq $00, @beginGame
	scriptjump @giveExplanation

@beginGame:
	showtext TX_24d6
	scriptjump shootingGallery_fadeIntoGameWithSword



shootingGalleryScript_goronElderNpc:
	initcollisions
	jumpifglobalflagset GLOBALFLAG_DONE_ELDER_SECRET, @tellSecret
	jumpifglobalflagset GLOBALFLAG_BEGAN_ELDER_SECRET, @alreadyGaveSecret

@loop:
	checkabutton
	jumpifmemoryeq wTmpcfc0.shootingGallery.disableGoronNpcs, $01, @loop
	disableinput
	showtext TX_3130
	wait 30
	jumpiftextoptioneq $00, @askForSecret
	showtext TX_3131
	enableinput
	scriptjump @loop

@askForSecret:
	askforsecret ELDER_SECRET
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @validSecret
	showtext TX_3133
	enableinput
	scriptjump @loop

@validSecret:
	setglobalflag GLOBALFLAG_BEGAN_ELDER_SECRET
	showtext TX_3132
	scriptjump @askedToTakeTest

@alreadyGaveSecret:
	checkabutton
	jumpifmemoryeq wTmpcfc0.shootingGallery.disableGoronNpcs, $01, @alreadyGaveSecret
	disableinput
	showtext TX_313c
	scriptjump @askedToTakeTest

@tellSecret:
	checkabutton
	jumpifmemoryeq wTmpcfc0.shootingGallery.disableGoronNpcs, $01, @tellSecret
	generatesecret ELDER_RETURN_SECRET
	showtext TX_313e
	scriptjump @tellSecret

; Parse the response to the goron asking you to take the test
@askedToTakeTest:
	wait 30
	jumpiftextoptioneq $00, @acceptedTest
	showtext TX_3134
	enableinput
	scriptjump @alreadyGaveSecret

@acceptedTest:
	showtext TX_3135
	wait 30
	jumpiftextoptioneq $00, @beginGame

@giveExplanation:
	showtext TX_3136
	wait 30
	jumpiftextoptioneq $01, @giveExplanation

@beginGame:
	showtext TX_3137
	wait 40
	asm15 fadeoutToWhite
	checkpalettefadedone
	asm15 scriptHelp.shootingGallery_equipBiggoronSword
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 scriptHelp.shootingGallery_initLinkPosition
	asm15 scriptHelp.shootingGallery_setEntranceTiles, $02
	wait 20
	asm15 fadeinFromWhite
	checkpalettefadedone
	scriptjump shootingGallery_beginGame


shootingGalleryScript_hit1Blue:
	showtext TX_0807
	scriptjump shootingGallery_printTotalPoints
shootingGalleryScript_hit1Fairy:
	showtext TX_0808
	scriptjump shootingGallery_printTotalPoints
shootingGalleryScript_hit1Red:
	showtext TX_0809
	scriptjump shootingGallery_printTotalPoints
shootingGalleryScript_hit1Imp:
	showtext TX_080a
	scriptjump shootingGallery_printTotalPoints
shootingGalleryScript_hit2Blue:
	showtext TX_080b
	scriptjump shootingGallery_printTotalPoints
shootingGalleryScript_hit2Red:
	showtext TX_080c
	scriptjump shootingGallery_printTotalPoints
shootingGalleryScript_hit1Blue1Fairy:
	showtext TX_080e
	scriptjump shootingGallery_printTotalPoints
shootingGalleryScript_hit1Red1Blue:
	showtext TX_080d
	scriptjump shootingGallery_printTotalPoints
shootingGalleryScript_hit1Blue1Imp:
	showtext TX_080f
	scriptjump shootingGallery_printTotalPoints
shootingGalleryScript_hit1Red1Fairy:
	showtext TX_0810
	scriptjump shootingGallery_printTotalPoints
shootingGalleryScript_hit1Fairy1Imp:
	showtext TX_0811
	scriptjump shootingGallery_printTotalPoints
shootingGalleryScript_hit1Red1Imp:
	showtext TX_0812
	scriptjump shootingGallery_printTotalPoints
shootingGalleryScript_hitNothing:
	showtext TX_0806
	scriptjump shootingGallery_printTotalPoints
shootingGalleryScript_strike:
	showtext TX_081c

shootingGallery_printTotalPoints:
	wait 15
	jumpifobjectbyteeq Interaction.var3f, 10, @gameDone ; Is this the 10th round?

	showtext TX_0813
	enableallobjects
	scriptend

@gameDone:
	jumpifobjectbyteeq Interaction.subid, $01, @goronGallery

	showtext TX_0814
	enableallobjects
	scriptend

@goronGallery:
	showtext TX_24d7
	enableallobjects
	scriptend



shootingGalleryScript_humanNpc_gameDone:
	loadscript scriptHelp.shootingGalleryScript_humanNpc_gameDone

shootingGalleryScript_goronNpc_gameDone:
	loadscript scriptHelp.shootingGalleryScript_goronNpc_gameDone

shootingGalleryScript_goronElderNpc_gameDone:
	disableinput
	wait 40
	asm15 fadeoutToWhite
	checkpalettefadedone
	asm15 scriptHelp.shootingGallery_restoreEquips
	asm15 scriptHelp.shootingGallery_setEntranceTiles, $00
	asm15 scriptHelp.shootingGallery_removeAllTargets
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 scriptHelp.shootingGallery_initLinkPositionAfterBiggoronGame

	wait 20
	asm15 fadeinFromWhite
	checkpalettefadedone
	resetmusic
	wait 40

	asm15 scriptHelp.shootingGallery_cpScore, $08
	jumpifmemoryset wcddb, $80, @giveBiggoronSword

	; Not enough points
	showtext TX_3138
	wait 30
	jumpiftextoptioneq $00, @end2
	showtext TX_3139
	enableinput

.ifdef REGION_JP
	scriptjump shootingGalleryScript_goronElderNpc@alreadyGaveSecret
.else

; If you talk to him, he asks if you want to play again
@npcLoop:
	checkabutton
	jumpifmemoryeq wTmpcfc0.shootingGallery.disableGoronNpcs, $01, shootingGalleryScript_goronElderNpc@alreadyGaveSecret
	disableinput
	showtext TX_313c
	wait 30
	jumpiftextoptioneq $00, @playAgain
	showtext TX_3134
	enableinput
	scriptjump @npcLoop

@playAgain:
	showtext TX_3135
	wait 30
	jumpiftextoptioneq $00, @end1

@giveExplanation:
	showtext TX_3136
	wait 30
	jumpiftextoptioneq $01, @giveExplanation
@end1:
	scriptend

.endif ; REGION_US, REGION_EU


@giveBiggoronSword:
	showtext TX_313a
	wait 30
	giveitem TREASURE_BIGGORON_SWORD, $00
	wait 30
	setglobalflag GLOBALFLAG_DONE_ELDER_SECRET
	generatesecret ELDER_RETURN_SECRET
	showtext TX_313b
	enableinput
	scriptjump shootingGalleryScript_goronElderNpc@tellSecret
@end2:
	scriptend



; Performs a "cutscene" sometimes used when Link gets an item, where an "energy swirl"
; goes toward him and the screen flashes white.
scriptFunc_doEnergySwirlCutscene:
	asm15 scriptHelp.createSparkle
	wait 30
	asm15 scriptHelp.func_50e4
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


; ==============================================================================
; INTERACID_IMPA_IN_CUTSCENE
; ==============================================================================

jumpAndWaitUntilLanded:
	asm15 scriptHelp.beginJump
@stillInAir:
	asm15 scriptHelp.updateGravity
	jumpifmemoryset wcddb, $80, @landed
	scriptjump @stillInAir
@landed:
	retscript


; Subid 0: wait for signal from wTmpcfc0.genericCutscene.cfd0 (link has approached?), then move toward Link.
impaScript0:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $01
	wait 210
	showtextdifferentforlinked TX_0102, TX_0103
	wait 30
	setspeed SPEED_080
	movedown $20
	orroomflag $40
	scriptend

impaScript_moveAwayFromRock:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $03
	setanimation $02
	wait 10
	showtext TX_0106
	wait 30
	setanimation $01
	setangle $18
	setspeed SPEED_080
	applyspeed $21
	wait 30
	showtext TX_0107
	wait 30
	applyspeed $21
	wait 30
	showtext TX_0108
	wait 30
	writememory wTmpcfc0.genericCutscene.cfd0, $04
	scriptend

impaScript_waitForRockToBeMoved:
	rungenericnpc TX_010b

impaScript_rockJustMoved:
	loadscript scriptHelp.impaScript_rockJustMoved

; Impa reveals that she's under veran's control
impaScript_revealPossession:
	setanimation $02
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $0d
	wait 30
	playsound SNDCTRL_FAST_FADEOUT
	wait 30

	setspeed SPEED_100
	moveright $20
	wait 8
	moveup $10
	wait 30

	playsound MUS_LADX_SIDEVIEW
	setanimation $04
	wait 240

	showtext TX_5600
	writememory wTmpcfc0.genericCutscene.cfd0, $0e ; Signal for the animals to freak out?
	wait 60

	setanimation $00
	wait 60
	showtext TX_5606
	wait 10

	; Start spinning down-left
	setanimation $07
	setangle $16
	setspeed SPEED_080
	applyspeed $48

	writememory wTmpcfc0.genericCutscene.cfd0, $0f ; Signal for the animals to run away?
	scriptend


; Subid 1: talking to Impa after nayru is kidnapped
impaScript1:
	wait 120
	setanimation $02
	asm15 scriptHelp.impa_restoreNormalSpriteSheet
	wait 60
	setanimation $03
	wait 50
	setanimation $01
	wait 30
	setanimation $03
	wait 10
	setanimation $01
	wait 60
	showtext TX_0110
	wait 30
	setanimation $03
	wait 30
	showtextdifferentforlinked TX_0112, TX_0113
	wait 30
	setanimation $01
	showtextdifferentforlinked TX_0115, TX_0116
	wait 30
	jumpifmemoryeq wIsLinkedGame, $01, @linked

@unlinked:
	giveitem TREASURE_SWORD, $00
	scriptjump ++
@linked:
	giveitem TREASURE_SHIELD, $00

++
	wait 30
	asm15 scriptHelp.forceLinkDirection, DIR_LEFT
	wait 30
	showtext TX_0117
	wait 30
	setspeed SPEED_100
	moveright $41
	wait 8
	movedown $21
	wait 30
	resetmusic
	wait 30
	enableinput
	setglobalflag GLOBALFLAG_INTRO_DONE
	scriptend


; Subid 2: credits cutscene
impaScript2:
	checkpalettefadedone
	wait 90
	setspeed SPEED_200
	moveup $20
	addobjectbyte Interaction.var38, $1e
	addobjectbyte Interaction.substate, $01
	checkmemoryeq wTmpcfc0.genericCutscene.state, $05
	setanimation $08
	checkobjectbyteeq Interaction.animParameter, $01
	writememory wTmpcfc0.genericCutscene.state, $06
	scriptend

; Subid 3: saved Zelda cutscene?
impaScript3:
	checkmemoryeq wTmpcfc0.genericCutscene.state, $05
	setspeed SPEED_100
	moveleft $10
	setanimation $02
	wait 6
	movedown $10
	setanimation $03
	wait 6
	moveleft $12
	setanimation $00
	wait 30
	showtext TX_3d08
	wait 128
	writememory wTmpcfc0.genericCutscene.state, $06
	scriptend

impaScript4:
	loadscript scriptHelp.impaScript4

impaScript5:
	loadscript scriptHelp.impaScript5

; Subid 6: ?
impaScript6:
	checkpalettefadedone
	wait 60
	setspeed SPEED_080
	movedown $61
	setspeed SPEED_0c0
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $01
	wait 8
	movedown $2b
	scriptend

impaScript7:
	loadscript scriptHelp.impaScript7

; Subid 8: ?
impaScript8:
	checkcfc0bit 0
	wait 30
	asm15 scriptHelp.createExclamationMark, 30
	checkcfc0bit 3
	setspeed SPEED_200
	setanimation $03
	setangle $13
	applyspeed $31
	xorcfc0bit 4
	scriptend

; Subid 9: Tells you that Zelda's been kidnapped by twinrova
impaScript9:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $11
	playsound SNDCTRL_STOPMUSIC
	showtext TX_0130

	writeobjectbyte Interaction.var38, $01
	wait 60

	setspeed SPEED_180
	moveleft $30
	wait 4
	setanimation $02
	wait 8
	callscript jumpAndWaitUntilLanded

	wait 10
	asm15 scriptHelp.forceLinkDirection, DIR_UP
	wait 10
	asm15 scriptHelp.impa_showZeldaKidnappedTextNonExitable
	writememory wTmpcfc0.genericCutscene.cfd0, $12
	scriptend



; ==============================================================================
; INTERACID_FAKE_OCTOROK
; ==============================================================================
impaOctorokScript:
	scriptend

; Script for great fairy disguised as an octorok
greatFairyOctorokScript:
	initcollisions

@npcLoop:
	checkabutton
	jumpifglobalflagset GLOBALFLAG_TALKED_TO_OCTOROK_FAIRY, @alreadyExplained
	showtextlowindex <TX_4106
	setglobalflag GLOBALFLAG_TALKED_TO_OCTOROK_FAIRY
	scriptjump @npcLoop

@alreadyExplained:
	jumpifitemobtained TREASURE_FAIRY_POWDER, @applyFairyPowder
	showtextlowindex <TX_4107
	scriptjump @npcLoop

@applyFairyPowder:
	setdisabledobjectsto11
	disablemenu
	showtextlowindex <TX_4108
	asm15 scriptHelp.greatFairyOctorok_createMagicPowderAnimation
	wait 60
	scriptend


; ==============================================================================
; INTERACID_CHILD
; ==============================================================================

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


; ==============================================================================
; INTERACID_NAYRU
; ==============================================================================

; Subid $00: Cutscene at the beginning of game (talking to Link, then gets possessed)
nayruScript00_part1:
	setanimation $02
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $0a

	; Moving toward Link
	wait 10
	setspeed SPEED_040
	movedown $20
	wait 30

	showtext TX_1d00
	wait 30

	writememory   wTmpcfc0.genericCutscene.cfd0, $0b
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $0c
	asm15 scriptHelp.setLinkAnimation, LINK_ANIM_MODE_NONE
	wait 40

	showtext TX_1d22
	wait 30

	writememory   wTmpcfc0.genericCutscene.cfd0, $0d
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $0f

	setanimation  $02
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $13

	; Backing away from Veran
	setspeed SPEED_040
	setangle $00
	applyspeed $20
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $15
	wait 120

	writememory wTmpcfc0.genericCutscene.cfd0, $16
	wait 30

	; Moving forward again
	setangle $10
	setspeed SPEED_020
	applyspeed $81
	setcoords $28, $78
	wait 210

	; Fully possessed
	setanimation $05
	writeobjectbyte Interaction.oamFlags, $06
	playsound SND_SWORD_OBTAINED
	wait 60

	setanimation $02
	writememory wTmpcfc0.genericCutscene.cfd0, $17
	orroomflag $40
	scriptend

; Part 2: after jumping up the cliff, she goes to the past
nayruScript00_part2:
	setanimation $02
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $1c
	wait 40

	showtext TX_5605
	wait 60

	setspeed SPEED_100
	moveup $11
	writeobjectbyte Interaction.var3d, $01 ; Signal to make her transparent
	playsound SND_WARP_START
	wait 120

	writememory wTmpcfc0.genericCutscene.cfd0, $1d
	scriptend


nayruScript01:
	loadscript scriptHelp.nayruScript01


; Subid $02: Nayru on maku tree screen after being saved
nayruScript02_part1:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $01
	asm15 objectSetVisiblec2
	checkpalettefadedone
	wait 30
	setanimation $02
	wait 90
	showtext TX_1d06
	wait 30
	writememory wTmpcfc0.genericCutscene.cfd0, $02
	scriptend

nayruScript02_part2:
	loadscript scriptHelp.nayruScript02_part2

nayruScript02_part3:
	wait 1
	asm15 scriptHelp.turnToFaceSomethingAtInterval, $03
	jumpifmemoryeq wTmpcfc0.genericCutscene.cfd0, $09, @sayGoodbye
	scriptjump nayruScript02_part3

@sayGoodbye:
	wait 60
	setanimation $02
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $0a
	wait 60

	asm15 scriptHelp.forceLinkDirection, DIR_UP
	wait 40

	showtext TX_1d08
	wait 20

	setspeed SPEED_0c0
	moveright $14
	wait 8

	movedown $4c
	asm15 scriptHelp.forceLinkDirection, DIR_DOWN

	writememory wTmpcfc0.genericCutscene.cfd0, $0b
	scriptend


nayruScript03:
	loadscript scriptHelp.nayruScript03


; Subid $04: Cutscene at end of game with Ambi and her guards
nayruScript04_part1:
	checkpalettefadedone
	wait 30
	setspeed SPEED_100
	moveup $19
	setspeed SPEED_080
	moveup $21
	setspeed SPEED_100
	moveup $1a
	wait 4
	moveleft $11
	wait 4
	setanimation $00
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $06
	moveup $10
	wait 180
	writememory wTmpcfc0.genericCutscene.cfd0, $07
	scriptend

nayruScript04_part2:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $0f
	setanimation $01
	wait 20
	showtext TX_1d0d
	wait 120
	writememory wTmpcfc0.genericCutscene.cfd0, $10
	scriptend

nayruScript05:
	checkmemoryeq wTmpcfc0.genericCutscene.state, $01
	asm15 objectSetVisible82
	checkpalettefadedone
	wait 60
	setanimation $02
	checkmemoryeq wTmpcfc0.genericCutscene.state, $05
	setanimation $03
	scriptend

nayruScript07:
	loadscript scriptHelp.nayruScript07

; Subid $08: Cutscene after saving Zelda?
nayruScript08:
	checkmemoryeq wTmpcfc0.genericCutscene.state, $03
	setangle $18
	setspeed SPEED_100
	applyspeed $20
	wait 6
	setanimation $00
	wait 30
	showtext TX_3d0a
	wait 30
	setanimation $01
	wait 6
	moveright $20
	wait 10
	setanimation $03
	writememory wTmpcfc0.genericCutscene.state, $04
	wait 128
	scriptend

; Subid $09: Cutscene where Ralph's heritage is revealed (unlinked?)
nayruScript09:
	wait 10
	setspeed SPEED_100
	movedown $39
	checkcfc0bit 1
	setspeed SPEED_080
	movedown $11
	showtext TX_1d12
	wait 16
	xorcfc0bit 2
	checkcfc0bit 3
	wait 8
	showtext TX_1d13
	xorcfc0bit 4
	wait 30
	setspeed SPEED_100
	moveup $41
	scriptend

; Subid $0b: Cutscene where Ralph's heritage is revealed (linked?)
nayruScript0a:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $01
	setanimation $00
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $02
	setanimation $01
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $03
	setanimation $02
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $05
	setanimation $00
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $06

	setspeed SPEED_100
	moveup $11
	setanimation $01
	writememory w1Link.direction, DIR_LEFT
	showtext TX_1d12

	wait 8
	writememory wTmpcfc0.genericCutscene.cfd0, $07
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $08

	writememory w1Link.direction, DIR_UP
	moveup $11
	moveright $11
	moveup $41
	scriptend

nayruScript10:
	loadscript scriptHelp.nayruScript10

nayruScript11:
	loadscript scriptHelp.nayruScript11

nayruScript13:
	loadscript scriptHelp.nayruScript13


; ==============================================================================
; INTERACID_RALPH
; ==============================================================================

; Cutscene where Nayru gets possessed
ralphSubid00Script:
	wait 30
	callscript jumpAndWaitUntilLanded
	wait 30
	showtext TX_2a00
	wait 30

	writememory   wTmpcfc0.genericCutscene.cfd0, $0a
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $0b ; Wait for nayru's text to finish

	asm15 scriptHelp.setLinkAnimation, $01
	callscript jumpAndWaitUntilLanded
	wait 10

	showtext TX_2a22
	wait 30

	writememory   wTmpcfc0.genericCutscene.cfd0, $0c
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $0f ; Wait for impa's part of the cutscene to start?

	setanimation $02
	writeobjectbyte Interaction.direction, DIR_DOWN
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $11

	setspeed SPEED_180
	playsound SND_UNKNOWN5
	movedown $16
	playsound SND_UNKNOWN5

@faceVeranGhost:
	wait 1
	asm15 scriptHelp.turnToFaceSomething
	jumpifmemoryeq wTmpcfc0.genericCutscene.cfd0, $15, @faceUp
	scriptjump @faceVeranGhost

@faceUp:
	setanimation $00
	wait 220

	; Back away from possessed nayru slowly
	setspeed SPEED_020
	setangle $10
	applyspeed $81

	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $17 ; Wait for possession to finish
	wait 120

	; Move toward Nayru
	setspeed SPEED_100
	moveleft $10
	wait 6
	asm15 scriptHelp.ralph_createLinkedSwordAnimation
	moveup $18
	wait 30

	; Swing sword
	setanimation $04
	playsound SND_SWORDSLASH

	wait 60
	showtext TX_2a01
	wait 30
	showtext TX_5603
	wait 60

	; Back away again
	setanimation $00
	writeobjectbyte Interaction.var3f, $ff
	writememory wInteractionIDToLoadExtraGfx, INTERACID_IMPA_IN_CUTSCENE
	writememory wLoadedTreeGfxIndex, $01
	setspeed SPEED_020
	setangle $10
	applyspeed $81
	wait 30

	showtext TX_5604
	wait 60

	writememory   wTmpcfc0.genericCutscene.cfd0, $18
	checkmemoryeq wTmpcfc0.genericCutscene.cfd2, $ff ; Wait for signal to turn left

	setanimation  $03
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $1b
	wait 20

	; Move toward cliff
	setspeed SPEED_100
	moveup $30
	wait 6
	moveleft $31

	writememory   wTmpcfc0.genericCutscene.cfd0, $1c
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $1d

	wait 120
	scriptend


ralphSubid02Script:
	loadscript scriptHelp.ralphSubid02Script


; Cutscene outside Ambi's palace before getting mystery seeds
ralphSubid01Script:
	setmusic MUS_RALPH
	setspeed SPEED_200
	setanimation $03
	wait 40
	moveleft $1d

	writeobjectbyte Interaction.var3f, $01
	wait 40
	callscript jumpAndWaitUntilLanded
	wait 40
	showtext TX_2a08
	wait 40

	writeobjectbyte Interaction.var3f, $00
	setspeed SPEED_200
	moveleft $45
	writememory wTmpcfc0.genericCutscene.state, $01
	resetmusic
	scriptend


ralphSubid03Script:
	loadscript scriptHelp.ralphSubid03Script


; Cutscene on maku tree screen after saving Nayru
ralphSubid04Script_part1:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $01
	asm15 objectSetVisiblec2
	writeobjectbyte Interaction.animCounter, $7f
	checkpalettefadedone
	wait 30
	setanimation $01
	scriptend

ralphSubid04Script_part2:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $04
	setspeed SPEED_100
	movedown $13
	wait 6

	moveright $0a
	asm15 scriptHelp.forceLinkDirection, DIR_LEFT
	wait 30

	showtext TX_2a0e
	wait 30

	asm15 scriptHelp.forceLinkDirection, DIR_UP
	setanimation $00
	writememory wTmpcfc0.genericCutscene.cfd0, $05
	scriptend

ralphSubid04Script_part3:
	wait 1
	asm15 scriptHelp.turnToFaceSomethingAtInterval, $03
	jumpifmemoryeq wTmpcfc0.genericCutscene.cfd0, $09, @twinrovaGone
	scriptjump ralphSubid04Script_part3

@twinrovaGone:
	wait 60
	resetmusic
	wait 60

	setanimation $01
	asm15 scriptHelp.forceLinkDirection, DIR_LEFT
	wait 20

	showtextdifferentforlinked TX_2a0f, TX_2a10
	wait 20
	setspeed SPEED_200
	movedown $18

	asm15 scriptHelp.forceLinkDirection, DIR_DOWN
	writememory wTmpcfc0.genericCutscene.cfd0, $0a
	scriptend


; Cutscene in black tower where Nayru/Ralph meet you to try to escape
ralphSubid05Script:
	wait 7
	setanimation $03
	setspeed SPEED_080
	setangle $08
	applyspeed $20

	checkobjectbyteeq Interaction.var3e, $01
	wait 10
	moveleft $10
	asm15 scriptHelp.forceLinkDirection, DIR_RIGHT
	wait 10

	showtext TX_2a11
	wait 20

	writememory   wTmpcfc0.genericCutscene.cfd0, $03
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $04
	wait 50

	setspeed SPEED_100
	moveleft $10
	wait 6
	movedown $28
	wait 60

	writememory wTmpcfc0.genericCutscene.cfd0, $05
	scriptend


; Cutscene at end of game with Ambi and her guards
ralphSubid06Script_part1:
	checkpalettefadedone
	wait 30

	setspeed SPEED_100
	moveup $37
	setspeed SPEED_080
	moveup $21
	wait 20
	setspeed SPEED_200
	moveup $15
	wait 30

	showtext TX_2a12
	wait 30

	writememory wTmpcfc0.genericCutscene.cfd0, $06
	checkobjectbyteeq Interaction.var3e, $01
	wait 10

	showtext TX_2a13
	wait 60

	writememory wTmpcfc0.genericCutscene.cfd0, $09
	scriptend

ralphSubid06Script_part2:
	checkpalettefadedone
	wait 60

	setanimation $01
	wait 10
	asm15 scriptHelp.forceLinkDirection, DIR_LEFT
	wait 10
	showtext TX_2a14
	wait 60

	jumpifmemoryeq wIsLinkedGame, $01, @linked
	wait 20

	setanimation $00
	asm15 scriptHelp.forceLinkDirection, DIR_UP
	wait 20
	writememory   wTmpcfc0.genericCutscene.cfd0, $0c
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $0d

	showtext TX_2a15
	wait 10

	writememory   wTmpcfc0.genericCutscene.cfd0, $0e
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $0f
	wait 10

	setanimation $03
	asm15 scriptHelp.forceLinkDirection, DIR_LEFT
	scriptend

@linked:
	writememory wTmpcfc0.genericCutscene.cfd0, $11
	scriptend


; Cutscene postgame where they warp to the maku tree, Ralph notices the statue
ralphSubid07Script:
	checkmemoryeq wTmpcfc0.genericCutscene.state, $01

	asm15 objectSetVisible82
	checkmemoryeq wTmpcfc0.genericCutscene.state, $02

	wait 40
	setanimation $00
	wait 20

	asm15 scriptHelp.ralph_createExclamationMarkShiftedRight, $28
	wait 60

	writememory wTmpcfc0.genericCutscene.state, $03
	setspeed SPEED_180
	setangle $05
	applyspeed $1e
	wait 60

	setanimation $02
	wait 30

	addobjectbyte     Interaction.substate, $01
	checkobjectbyteeq Interaction.var3e,  $01
	wait 60

	writememory wTmpcfc0.genericCutscene.state, $05
	scriptend


; Cutscene in credits where Ralph is training with his sword
ralphSubid08Script:
	checkpalettefadedone
	wait 73
	setanimation $07
	wait 45
	setanimation $03
	wait 90
	setanimation $05
	wait 20
	setanimation $06
	wait 170
	setanimation $0b
	wait 40
	scriptend


; Cutscene where Ralph charges in to Ambi's palace
ralphSubid09Script:
	wait 30
	asm15 scriptHelp.ralph_faceLinkAndCreateExclamationMark
	wait 30

	showtext TX_2a16
	wait 15
	showtext TX_2a17
	wait 30
	showtext TX_2a18

	moveup $28
	asm15 setGlobalFlag, GLOBALFLAG_RALPH_ENTERED_AMBIS_PALACE
	resetmusic
	scriptend


; Cutscene where Ralph's about to charge into the black tower
ralphSubid0aScript_unlinked:
	wait 8
	showtext TX_2a19
	wait 16

	writememory w1Link.direction, DIR_DOWN
	movedown $18
	asm15 setGlobalFlag, GLOBALFLAG_RALPH_ENTERED_BLACK_TOWER
	scriptend

ralphSubid0aScript_linked:
	asm15 scriptHelp.ralph_createExclamationMarkShiftedRight, $1e
	wait 30

	writememory wTmpcfc0.genericCutscene.cfd0, $01
	setspeed SPEED_100
	moveup $29
	checkobjectbyteeq Interaction.substate, $03
	wait 8

	showtext TX_2a19
	wait 8

	movedown $29
	writememory wTmpcfc0.genericCutscene.cfd0, $02
	setanimation $03
	wait 45

	setanimation $02
	wait 30
	writememory wTmpcfc0.genericCutscene.cfd0, $03
	setspeed SPEED_180
	movedown $29
	wait 30

	writememory wTmpcfc0.genericCutscene.cfd0, $04
	scriptend


ralphSubid0bScript:
	loadscript scriptHelp.ralphSubid0bScript

ralphSubid10Script:
	loadscript scriptHelp.ralphSubid10Script

ralphSubid0cScript:
	loadscript scriptHelp.ralphSubid0cScript


; Cutscene where Ralph goes back in time
ralphSubid0dScript:
	jumpifglobalflagset GLOBALFLAG_RALPH_ENTERED_PORTAL, stubScript
	disableinput
	wait 40

	showtext TX_2a1e
	wait 30

	setanimation $01
	setspeed SPEED_100
	setangle $08
	applyspeed $11

	setanimation $09
	writeobjectbyte Interaction.var3f, $2d
	playsound SND_MYSTERY_SEED

@flickerVisibility:
	asm15 scriptHelp.ralph_flickerVisibility
	asm15 scriptHelp.ralph_decVar3f
	jumpifmemoryset wcddb, $80, @done
	scriptjump @flickerVisibility

@done:
	setglobalflag GLOBALFLAG_RALPH_ENTERED_PORTAL
	asm15 scriptHelp.ralph_restoreMusic
	enableinput
	scriptend


; Cutscene with Nayru and Ralph when Link exits the black tower
ralphSubid0eScript:
	checkpalettefadedone
	wait 70

	setspeed SPEED_100
	moveup $50
	checkmemoryeq wGenericCutscene.cbb5, $01

	moveup $10
	showtext TX_2a1f

	writememory   wGenericCutscene.cbb5, $02
	checkmemoryeq wGenericCutscene.cbb5, $03

	movedown $40
	writeobjectbyte Interaction.yh, $08
	writeobjectbyte Interaction.xh, $80

	checkmemoryeq wGenericCutscene.cbb5, $05
	checkpalettefadedone

	movedown $70
	checkmemoryeq wGenericCutscene.cbb5, $07
	wait 20

	setspeed SPEED_200
	movedown $18
	scriptend


; NPC after finishing the game
ralphSubid11Script:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	wait 20

	writeobjectbyte Interaction.var39, $01 ; Disable animations
	asm15 scriptHelp.turnToFaceLink
	wait 6

	showtext TX_2a21
	wait 6

	writeobjectbyte Interaction.var39, $00 ; Enable animations
	setanimation $03
	enableinput
	scriptjump @npcLoop


ralphSubid12Script:
	rungenericnpc TX_2a23


; ==============================================================================
; INTERACID_PAST_GIRL
; ==============================================================================

pastGirlScript_earlyGame:
	rungenericnpclowindex <TX_1a00

pastGirlScript_afterNayruSaved:
	rungenericnpclowindex <TX_1a03

pastGirlScript_afterd7:
	rungenericnpclowindex <TX_1a04

pastGirlScript_afterGotMakuSeed:
	jumpifmemoryeq wIsLinkedGame, $01, @linked
	rungenericnpclowindex <TX_1a05
@linked:
	rungenericnpclowindex <TX_1a08

pastGirlScript_twinrovaKidnappedZelda:
	rungenericnpclowindex <TX_1a09

pastGirlScript_gameFinished:
	rungenericnpclowindex <TX_1a07


; ==============================================================================
; INTERACID_MONKEY
; ==============================================================================

; Listening to Nayru sing at beginning of game
monkeySubid0Script:
	initcollisions
@npcLoop:
	checkabutton
	ormemory wTmpcfc0.genericCutscene.cfde, $08 ; Signal that this animal's been talked to

	cplinkx Interaction.direction
	setanimationfromobjectbyte Interaction.direction

	showtextlowindex <TX_5704
	wait 20
	setanimation $02
	scriptjump @npcLoop

monkeySubid2Script:
	rungenericnpclowindex <TX_5700

monkeySubid3Script:
	rungenericnpclowindex <TX_5701


monkeySubid5Script:
	initcollisions
@npcLoop:
	enableinput
	checkabutton
	disableinput
@waitUntilLanded:
	jumpifobjectbyteeq Interaction.zh, $00, @landed
	wait 1
	scriptjump @waitUntilLanded
@landed:
	asm15 scriptHelp.monkey_decideTextIndex
	showloadedtext
	scriptjump @npcLoop


monkeySubid5Script_bowtieMonkey:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @finishedGame
	rungenericnpclowindex <TX_5707
@finishedGame:
	rungenericnpclowindex <TX_570c


monkeySubid7Script_0:
	initcollisions
@npcLoop:
	checkabutton
	asm15 scriptHelp.monkey_turnToFaceLink
	showtextlowindex <TX_5715
	asm15 scriptHelp.monkey_setAnimationFromVar3a
	scriptjump @npcLoop


monkeySubid7Script_1:
	initcollisions
@npcLoop:
	checkabutton
	asm15 scriptHelp.monkey_turnToFaceLink
	showtextlowindex <TX_5716
	asm15 scriptHelp.monkey_setAnimationFromVar3a
	scriptjump @npcLoop


monkeySubid7Script_2:
	initcollisions
@npcLoop:
	checkabutton
	asm15 scriptHelp.monkey_turnToFaceLink
	showtextlowindex <TX_5719
	asm15 scriptHelp.monkey_setAnimationFromVar3a
	scriptjump @npcLoop


monkeySubid7Script_3:
	initcollisions
@npcLoop:
	checkabutton
	asm15 scriptHelp.monkey_turnToFaceLink
	showtextlowindex <TX_571a
	asm15 scriptHelp.monkey_setAnimationFromVar3a
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_VILLAGER
; ==============================================================================

villagerSubid01Script:
	initcollisions
	settextid TX_1440
	scriptjump villagerFaceDownAfterTalkedTo


; Construction worker blocking path to upper part of black tower
villagerSubid02Script_part1:
	setcollisionradii $06, $06
	settextid TX_1441

villagerFaceDownAfterTalkedTo:
	checkabutton
	asm15 scriptHelp.turnToFaceLink
	showloadedtext
	wait 10
	setanimation $02
	scriptjump villagerFaceDownAfterTalkedTo


; Construction worker moves toward Link to prevent him from passing
villagerSubid02Script_part2:
	disableinput
	setspeed SPEED_100
	jumpifobjectbyteeq Interaction.direction, $00, @moveRight

	moveleft $10
	scriptjump ++
@moveRight:
	moveright $10
++
	asm15 scriptHelp.villager_setLinkYToVar39
	wait 10
	enableinput
	scriptend


; Guy in front of present maku tree screen
villagerSubid03Script_befored3:
	rungenericnpc TX_1420

villagerSubid03Script_afterd3:
	rungenericnpc TX_1421

villagerSubid03Script_afterNayruSaved:
	rungenericnpc TX_1422

villagerSubid03Script_afterd7:
	rungenericnpc TX_1423

villagerSubid03Script_afterGotMakuSeed:
	rungenericnpc TX_1424

villagerSubid03Script_postGame:
	rungenericnpc TX_1425


; "Sidekick" to the comedian guy, or the guy in front of Lynna shop
villagerSubid4And5Script_befored3:
	rungenericnpc TX_1430

villagerSubid4And5Script_afterd3:
	rungenericnpc TX_1431

villagerSubid4And5Script_afterGotMakuSeed:
	rungenericnpc TX_1434

villagerSubid4And5Script_postGame:
	rungenericnpc TX_1435


; Villager in front of past maku tree screen, or near ambi's palace
villagerSubid6And7Script_befored2:
	rungenericnpc TX_1400

villagerSubid6And7Script_afterd2:
	rungenericnpc TX_1401

villagerSubid6And7Script_afterd4:
	rungenericnpc TX_1402

villagerSubid6And7Script_afterNayruSaved:
	jumpifmemoryeq wIsLinkedGame, $01, @linked
	rungenericnpc TX_1403
@linked:
	rungenericnpc TX_1408

villagerSubid6And7Script_afterd7:
	rungenericnpc TX_1404

villagerSubid6And7Script_afterGotMakuSeed:
	rungenericnpc TX_1405

villagerSubid6And7Script_twinrovaKidnappedZelda:
	rungenericnpc TX_1406

villagerSubid6And7Script_postGame:
	rungenericnpc TX_1407


; Villager outside house hear black tower (only appears after d7)
villagerSubid08Script_afterd7:
	rungenericnpc TX_1414

villagerSubid08Script_afterGotMakuSeed:
	rungenericnpc TX_1415

villagerSubid08Script_twinrovaKidnappedZelda:
	rungenericnpc TX_1418

villagerSubid08Script_postGame:
	rungenericnpc TX_1417


; Villager playing catch with son
villagerSubid0cScript:
	initcollisions

villagerSubid09Script:
	wait 60
	setanimation $01
	wait 30

villagerThrowBallAnimation:
	asm15 scriptHelp.loadNextAnimationFrameAndMore, $01
	wait 30
	scriptjump villagerSubid09Script

script5bbf: ; Unused
	scriptend


; Villager being restored from stone, resumes playing catch
villagerSubid0bScript:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $02
	wait 10

	; Run off screen to get ball
	setspeed SPEED_180
	moveleft $2c
	asm15 scriptHelp.villager_createBallAccessory
	wait 30

	; Run back on screen
	setanimation $0b
	setangle $08
	applyspeed $2c

	; Wait a bit with no animations
	writeobjectbyte Interaction.var39, $01
	wait 90

	; Throw the ball
	writeobjectbyte Interaction.var3b, $01
	asm15 scriptHelp.villager_createBall
	scriptjump villagerThrowBallAnimation


; Cutscene when you first enter the past
villagerSubid0dScript:
	jumpifglobalflagset GLOBALFLAG_ENTER_PAST_CUTSCENE_DONE, stubScript
	setdisabledobjectsto11
	wait 100
	disableinput
	wait 40

	callscript jumpAndWaitUntilLanded
	wait 30

	showtext TX_1622
	wait 30

	setspeed   SPEED_100
	movedown   $11
	moveright  $11
	movedown   $09
	setspeed   SPEED_080
	applyspeed $21
	setspeed   SPEED_100
	applyspeed $39

	setglobalflag GLOBALFLAG_ENTER_PAST_CUTSCENE_DONE
	enableinput
	scriptend


; ==============================================================================
; INTERACID_FEMALE_VILLAGER
; ==============================================================================

; Cutscene where guy is struck by lightning in intro
villagerGalSubid00Script:
	wait 90
	setspeed SPEED_100
	setanimation $00
	wait 30
	moveup $80
	scriptend


; NPC in eyeglasses library (present)
villagerGalSubid07Script:
	initcollisions
@npcLoop:
	checkabutton
	turntofacelink
	showloadedtext
	setanimation $00
	scriptjump @npcLoop


; Present NPC near black tower / outside shop
villagerGalSubid1And2Script_befored3:
	rungenericnpc TX_1520

villagerGalSubid1And2Script_afterd3:
	rungenericnpc TX_1521

villagerGalSubid1And2Script_afterNayruSaved:
	rungenericnpc TX_1522

villagerGalSubid1And2Script_afterd7:
	rungenericnpc TX_1523

villagerGalSubid1And2Script_afterGotMakuSeed:
	rungenericnpc TX_1524

villagerGalSubid1And2Script_postGame:
	rungenericnpc TX_1525


; Past NPC south of shooting gallery screen / just outside black tower
villagerGalSubid3And4Script_befored2:
	rungenericnpc TX_1500

villagerGalSubid3And4Script_afterd2:
	rungenericnpc TX_1501

villagerGalSubid3And4Script_afterd4:
	rungenericnpc TX_1502

villagerGalSubid3And4Script_afterNayruSaved:
	rungenericnpc TX_1503

villagerGalSubid3And4Script_afterd7:
	rungenericnpc TX_1504

villagerGalSubid3And4Script_afterGotMakuSeed:
	rungenericnpc TX_1505

villagerGalSubid3And4Script_twinrovaKidnappedZelda:
	rungenericnpc TX_1508

villagerGalSubid3And4Script_postGame:
	rungenericnpc TX_1507


; Past villager
villagerGalSubid05Script_befored2:
	rungenericnpc TX_1510

villagerGalSubid05Script_afterd2:
	rungenericnpc TX_1511

villagerGalSubid05Script_afterd4:
	rungenericnpc TX_1512

villagerGalSubid05Script_afterNayruSaved:
	rungenericnpc TX_1513

villagerGalSubid05Script_afterd7:
	rungenericnpc TX_1515

villagerGalSubid05Script_twinrovaKidnappedZelda:
	rungenericnpc TX_1518


; ==============================================================================
; INTERACID_BOY
; ==============================================================================

; Watching Nayru sing in intro
boySubid00Script:
	initcollisions
@npcLoop:
	checkabutton
	asm15 scriptHelp.turnToFaceLink
	ormemory wTmpcfc0.genericCutscene.cfde, $04
	showtext TX_2510
	wait 10
	setanimation $00
	scriptjump @npcLoop


; Kid turning to stone cutscene
boySubid01Script:
	setspeed SPEED_100
	moveleft $50
	wait 8
	moveright $50
	wait 8
	moveleft $30

	asm15 scriptHelp.createExclamationMark, $3c
	wait 50

	writememory wTmpcfc0.genericCutscene.cfd1, $01
	wait 90

	writememory wTmpcfc0.genericCutscene.cfd1, $02
	setspeed SPEED_040
	applyspeed $40
	wait 30

	writememory wTmpcfc0.genericCutscene.cfd1, $03

boyStubScript:
	scriptend


; Kid outside shop
boySubid02Script_afterGotSeedSatchel:
	rungenericnpc TX_2500

boySubid02Script_afterd3:
	rungenericnpc TX_2501

boySubid02Script_afterNayruSaved:
	rungenericnpc TX_2502

boySubid02Script_afterd7:
	rungenericnpc TX_2503

boySubid02Script_afterGotMakuSeed:
	rungenericnpc TX_2504

boySubid02Script_postGame:
	rungenericnpc TX_2505


; Cutscene where kids talk about how they're scared of a ghost (red kid)
boySubid03Script:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $02

	writeobjectbyte Interaction.var39, $01 ; Disable animations
	wait 32

	showtext TX_2512 ; Besides...
	wait 30

	setanimation $03
	wait 32

	showtext TX_2513 ; It might come out...
	wait 30

	setanimation $00
	wait 32

	showtext TX_2514 ; The GhoOost
	wait 60

	writememory wTmpcfc0.genericCutscene.cfd1, $03

boyShakeWithFearThenRun:
	writeobjectbyte Interaction.var39, $01 ; Disable animations
	writeobjectbyte Interaction.var38, 120 ; Wait 2 seconds

@shake:
	asm15 scriptHelp.oscillateXRandomly
	addobjectbyte Interaction.var38, -1
	jumpifobjectbyteeq Interaction.var38, $00, @runAway
	wait 1
	scriptjump @shake

@runAway:
	playsound SND_THROW
	writeobjectbyte Interaction.var39, $00 ; Enable animations
	setspeed SPEED_200
	moveright $38
	scriptend


; Cutscene where kids talk about how they're scared of a ghost (green kid)
boySubid04Script:
	wait 30
	showtext TX_2511
	wait 30

	writememory   wTmpcfc0.genericCutscene.cfd1, $01
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $03

	scriptjump boyShakeWithFearThenRun


; Cutscene where kid is restored from stone
boySubid05Script:
	wait 30
	setspeed SPEED_180
	moveleft $0a

boyRunAroundHouse:
	wait 3
	moveup $21
	wait 3
	moveright $20
	wait 3
	movedown $36
	wait 3
	moveright $16
	wait 3
	moveup $16
	wait 3
	moveleft $35
	scriptjump boyRunAroundHouse


; Cutscene where kid sees his dad turn to stone
boySubid06Script:
	wait 30
	jumpifobjectbyteeq Interaction.var38, $00, @stopPlayingCatch
	asm15 scriptHelp.loadNextAnimationFrameAndMore, $02
	wait 90
	setanimation $03
	scriptjump boySubid06Script

@stopPlayingCatch:
	writememory wTmpcfc0.genericCutscene.cfd1, $01
	asm15 scriptHelp.loadNextAnimationFrameAndMore, $03
	wait 90

	asm15 scriptHelp.boy_createLightning, $00
	wait 20

	asm15 scriptHelp.boy_createLightning, $01
	wait 20

	asm15 fadeoutToWhite
	checkpalettefadedone
	wait 10

	writememory wTmpcfc0.genericCutscene.cfd1, $02
	setanimation $03
	asm15 fadeinFromWhite

	checkpalettefadedone
	wait 30

	asm15 scriptHelp.createExclamationMark, $28
	wait 40

	addobjectbyte Interaction.substate, $01 ; Enable normal animations
	setspeed SPEED_180
	moveleft $21
	wait 30

	writememory wTmpcfc0.genericCutscene.cfdf, $ff
	scriptend


; Depressed kid in trade sequence
boySubid07Script:
	loadscript scriptHelp.boySubid07Script


; Cutscene?
boySubid0aScript:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $02
	setanimation $01
	wait 30
	showtext TX_251b
	wait 30
	writememory wTmpcfc0.genericCutscene.cfd1, $03
	scriptend


; NPC in eyeglasses library present
boySubid0bScript:
	initcollisions
@npcLoop:
	checkabutton
	turntofacelink
	showloadedtext
	setanimation $00
	scriptjump @npcLoop


; Cutscene where kid's dad gets restored from stone
boySubid0cScript:
	setspeed SPEED_200
	moveright $19
	wait 8

	setanimation $03
	writeobjectbyte Interaction.var39, $01 ; Disable normal animations
	wait 37

@playCatchLoop:
	setanimation $03
@playCatch:
	wait 30
	asm15 scriptHelp.loadNextAnimationFrameAndMore, $02
	wait 90
	scriptjump @playCatchLoop


; Kid with grandma who's either stone or was restored from stone
boySubid0dScript:
	rungenericnpc TX_251c


; NPC playing catch with dad, or standing next to his stone dad
boySubid0eScript:
	initcollisions
	scriptjump boySubid0cScript@playCatch


; Cutscene where kid runs away?
boySubid0fScript:
	checkcfc0bit 0
	wait 60
	asm15 scriptHelp.createExclamationMark, $1e
	checkcfc0bit 2
	setspeed SPEED_200
	setanimation $01
	setangle $0c
	applyspeed $31
	scriptend


; ==============================================================================
; INTERACID_OLD_LADY
; ==============================================================================

; NPC with a son that is stone for part of the game
oldLadySubid0Script:
	jumpifglobalflagset GLOBALFLAG_SAVED_NAYRU, @notStone
	rungenericnpc TX_3800
@notStone:
	rungenericnpc TX_3801

; Cutscene where her grandson gets turned to stone
oldLadySubid1Script:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $03
	setspeed SPEED_280
	movedown $0e
	wait 4
	moveleft $0d
	wait 16
	scriptend


; NPC in present, screen left from bipin&blossom's house
oldLadySubid2Script:
	rungenericnpc TX_1809


; Cutscene where her grandson is restored from stone
oldLadySubid3Script:
	setspeed SPEED_180
	moveleft $16
	scriptjump boyRunAroundHouse


; ==============================================================================
; INTERACID_VERAN_GHOST
; ==============================================================================

ghostVeranSubid0Script_part1:
	loadscript scriptHelp.ghostVeranSubid0Script_part1

ghostVeranSubid1Script_part2:
	setcoords $24, $78
	wait 30
	setangle $00
	setspeed SPEED_040
	applyspeed $45
	checkmemoryeq wTmpcfc0.genericCutscene.cfd2, $ff
	wait 60
	setangle $10
	setspeed SPEED_080
	applyspeed $23
	wait 10
	writememory wTmpcfc0.genericCutscene.cfd0, $1a
	scriptend

; Cutscene just before fighting possessed Ambi
ghostVeranSubid1Script:
	checkmemoryeq wcc93, $00
	wait 8
	showtext TX_1315
	wait 8
	applyspeed $0c
	xorcfc0bit 0
	scriptend


; ==============================================================================
; INTERACID_BOY_2
; ==============================================================================

boy2Subid0Script:
	rungenericnpclowindex <TX_2910

boy2Subid1Script:
	rungenericnpclowindex <TX_2903

; Cutscene about ghost near spirit's grave
boy2Subid2Script:
	wait 30
	showtextlowindex <TX_2911
	writememory   wTmpcfc0.genericCutscene.cfd1, $02
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $03
	scriptjump boyShakeWithFearThenRun


; ==============================================================================
; INTERACID_SOLDIER
; ==============================================================================

soldierSubid00Script:
	jumpifglobalflagset $0b, script5df5
	rungenericnpc TX_5900
script5df5:
	rungenericnpc TX_5901

soldierSubid01Script:
	jumpifglobalflagset $0b, script5dff
	rungenericnpc TX_5902
script5dff:
	rungenericnpc TX_5901


; Left palace guard
soldierSubid02Script:
	loadscript scriptHelp.soldierSubid02Script


soldierSubid03Script:
	jumpifobjectbyteeq Interaction.yh, $28, script5e1e
	checkmemoryeq w1Link.yh, $60
	setspeed SPEED_100
	jumpifobjectbyteeq Interaction.xh, $48, script5e1a
	setangle $08
	scriptjump script5e1c
script5e1a:
	setangle $18
script5e1c:
	applyspeed $10
script5e1e:
	scriptend


; Guard who gives bombs to Link
soldierSubid04Script:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $02
	setanimation $01
	wait 30
	setspeed SPEED_100
	moveup $21
	wait 6
	moveright $11
	wait 6
	moveup $34
	wait 180
	movedown $34
	wait 6
	moveleft $11
	wait 6
	movedown $21
	wait 60
	showtext TX_1303
	wait 30
	movedown $31
	wait 6
	setanimation $01
	asm15 scriptHelp.forceLinkDirection, $03
	wait 60
	setspeed SPEED_080
	setangle $08
	applyspeed $15
	wait 60
	setangle $18
	applyspeed $15
	wait 30
	giveitem TREASURE_OBJECT_BOMBS_02
	setdisabledobjectsto11
	wait 30
	asm15 scriptHelp.forceLinkDirection, $00
	setspeed SPEED_100
	moveup $31
	wait 6
	setanimation $02
	wait 30
	showtext TX_1304
	wait 30
	writememory wTmpcfc0.genericCutscene.cfd1, $03
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $04
	playsound SNDCTRL_MEDIUM_FADEOUT
	wait 180
	showtext TX_1305
	wait 40
	movedown $21
	wait 4
	moveright $11
	wait 4
	movedown $11
	wait 60
	showtext TX_5907
	writememory wTmpcfc0.genericCutscene.cfd1, $05
	scriptend


; Guard escorting Link in intermediate screens (just moves straight up)
soldierSubid05Script:
	moveup $84
	scriptend


; Guard in cutscene who takes mystery seeds from Link
soldierSubid06Script:
	setspeed SPEED_100
	moveup $10
	wait 60
	moveright $18
	wait 30
	setanimation $03
	wait 60

	showtext TX_5905
	wait 30
	showtext TX_1300
	wait 30

	; Take mystery seeds from Link, give them to Ambi
	moveleft $18
	wait 8
	setanimation $02
	wait 40
	writememory wNumMysterySeeds, $00
	asm15 scriptHelp.soldierGiveMysterySeeds
	wait 20
	setanimation $00
	wait 10
	moveup $24
	wait 40
	playsound SND_GETSEED
	wait 20

	setspeed SPEED_080
	setangle $10
	applyspeed $48
	setanimation $03
	setangle $08
	applyspeed $30

	writememory   wTmpcfc0.genericCutscene.cfd1, $01
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $03

	; Escort Link out of screen
	setspeed SPEED_100
	moveleft $18
	setanimation $00
	wait 30
	showtext TX_5906
	wait 30
	setanimation $02
	wait 30
	showtext TX_590c
	wait 30
	writememory wScrollMode, $00
	asm15 scriptHelp.soldierSetSimulatedInputToEscortLink, $01
	enableallobjects
	movedown $34

	writememory wTmpcfc0.genericCutscene.cfd1, $04
	setglobalflag GLOBALFLAG_0b
	scriptend


; Guard just after Link is escorted out of the palace
soldierSubid07Script:
	wait 60
	showtext TX_5908
	wait 30
	writememory wUseSimulatedInput, $00
	asm15 scriptHelp.soldierUpdateMinimap
	enableinput
	rungenericnpc TX_5909


; Right palace guard
soldierSubid09Script:
	jumpifglobalflagset GLOBALFLAG_0b, @gotBombs
	rungenericnpc TX_5903
@gotBombs:
	rungenericnpc TX_5909


soldierSubid0aScript:
	loadscript scriptHelp.soldierSubid0aScript


soldierSubid0cScript:
	initcollisions
@loop:
	checkabutton
	asm15 scriptHelp.soldierGetRandomVar32Val
	showloadedtext
	scriptjump @loop


; Friendly soldier after finishing game. Behaviour depends on var3b, in turn set by var03.
soldierSubid0dScript:
	asm15 scriptHelp.soldierSetSpeed80AndVar3fTo01
	asm15 scriptHelp.soldierSetTextToShow
	initcollisions
	jumptable_objectbyte Interaction.var3b
	.dw @mode0_genericNpc
	.dw @mode1_moveClockwise
	.dw @mode2_moveCounterClockwise
	.dw @mode3_moveVertically

@mode0_genericNpc:
	checkabutton
	showloadedtext
	scriptjump @mode0_genericNpc

@mode1_moveClockwise:
	checkmemoryeq wcde0, $00
	asm15 objectUnmarkSolidPosition
@mode1Loop:
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $02
	asm15 scriptHelp.hardhatWorker_setPatrolCounter, $60
	callscript @moveForVar3cFrames
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $03
	asm15 scriptHelp.hardhatWorker_setPatrolCounter, $60
	callscript @moveForVar3cFrames
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $00
	asm15 scriptHelp.hardhatWorker_setPatrolCounter, $60
	callscript @moveForVar3cFrames
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $01
	asm15 scriptHelp.hardhatWorker_setPatrolCounter, $60
	callscript @moveForVar3cFrames
	scriptjump @mode1Loop

@mode2_moveCounterClockwise:
	checkmemoryeq wcde0, $00
	asm15 objectUnmarkSolidPosition
@mode2Loop:
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $02
	asm15 scriptHelp.hardhatWorker_setPatrolCounter, $80
	callscript @moveForVar3cFrames
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $01
	asm15 scriptHelp.hardhatWorker_setPatrolCounter, $20
	callscript @moveForVar3cFrames
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $00
	asm15 scriptHelp.hardhatWorker_setPatrolCounter, $80
	callscript @moveForVar3cFrames
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $03
	asm15 scriptHelp.hardhatWorker_setPatrolCounter, $20
	callscript @moveForVar3cFrames
	scriptjump @mode2Loop

@mode3_moveVertically:
	checkmemoryeq wcde0, $00
	asm15 objectUnmarkSolidPosition
@mode3Loop:
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $02
	asm15 scriptHelp.hardhatWorker_setPatrolCounter, $c0
	callscript @moveForVar3cFrames
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $00
	asm15 scriptHelp.hardhatWorker_setPatrolCounter, $c0
	callscript @moveForVar3cFrames
	scriptjump @mode3Loop

@moveForVar3cFrames:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @@turnToLinkAndShowText
	asm15 scriptHelp.hardhatWorker_decPatrolCounter
	jumpifmemoryset wcddb, $80, @@wait20Frames
	asm15 objectApplySpeed
	scriptjump @moveForVar3cFrames

@@wait20Frames:
	wait 20
	retscript

@@turnToLinkAndShowText:
	disableinput
	writeobjectbyte, Interaction.pressedAButton, $00
	asm15 scriptHelp.turnToFaceLink
	showloadedtext
	wait 30
	asm15 scriptHelp.hardhatWorker_updatePatrolAnimation
	enableinput
	scriptjump @moveForVar3cFrames


; ==============================================================================
; INTERACID_MISC_MAN
; ==============================================================================

manOutsideD2Script:
	rungenericnpclowindex <TX_2606

lynnaManScript_befored3:
	rungenericnpclowindex <TX_2600

lynnaManScript_afterd3:
	rungenericnpclowindex <TX_2601

lynnaManScript_afterNayruSaved:
	rungenericnpclowindex <TX_2602

lynnaManScript_afterd7:
	rungenericnpclowindex <TX_2603

lynnaManScript_afterGotMakuSeed:
	rungenericnpclowindex <TX_2604

lynnaManScript_postGame:
	rungenericnpclowindex <TX_2605


; ==============================================================================
; INTERACID_MUSTACHE_MAN
; ==============================================================================
mustacheManScript:
	jumpifglobalflagset GLOBALFLAG_0b, ++
	rungenericnpclowindex <TX_0f00
++
	rungenericnpclowindex <TX_0f01


; ==============================================================================
; INTERACID_PAST_GUY
; ==============================================================================

; Guy who wants to find something Ambi desires
pastGuySubid0Script:
	jumpifglobalflagset GLOBALFLAG_0b, +
	rungenericnpclowindex <TX_1710
+
	rungenericnpclowindex <TX_1711


; Some NPC (same guy, but different locations for different game stages)
pastGuySubid1And2Script_befored4:
	rungenericnpclowindex <TX_1701

pastGuySubid1And2Script_afterd4:
	rungenericnpclowindex <TX_1702

pastGuySubid1And2Script_afterNayruSaved:
	rungenericnpclowindex <TX_1703

pastGuySubid1And2Script_afterd7:
	rungenericnpclowindex <TX_1704

pastGuySubid1And2Script_afterGotMakuSeed:
	rungenericnpclowindex <TX_1707


; Guy in a cutscene (turning to stone?)
pastGuySubid3Script:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $02
	writeobjectbyte Interaction.oamFlags, $06
	scriptend

; Guy watching family play catch (or is stone)
pastGuySubid6Script:
	writeobjectbyte Interaction.oamFlags, $02
	rungenericnpclowindex <TX_1712


; ==============================================================================
; INTERACID_MISC_MAN_2
; ==============================================================================

pastHobo2Script:
	jumpifglobalflagset GLOBALFLAG_0b, +
	rungenericnpc TX_1620
+
	rungenericnpc TX_1621


; NPC in start-of-game cutscene who turns into an old man (this is the "old man" part)
npcTurnedToOldManCutsceneScript:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $04
	asm15 objectSetVisible82
	wait 240
	writememory wTmpcfc0.genericCutscene.cfdf, $ff
	callscript jumpAndWaitUntilLanded
	scriptend


; Bearded NPC in Lynna City
lynnaMan2Script_befored3:
	rungenericnpc TX_1610
lynnaMan2Script_afterd3:
	rungenericnpc TX_1611
lynnaMan2Script_afterNayruSaved:
	rungenericnpc TX_1612
lynnaMan2Script_afterd7:
	rungenericnpc TX_1613
lynnaMan2Script_afterGotMakuSeed:
	rungenericnpc TX_1614
lynnaMan2Script_postGame:
	rungenericnpc TX_1615


; Bearded hobo in the past, outside shooting gallery
pastHoboScript_befored2:
	rungenericnpc TX_1600

pastHoboScript_afterd2:
	jumpifmemoryeq wIsLinkedGame, $01, +
	rungenericnpc TX_1601
+
	rungenericnpc TX_1608

pastHoboScript_afterd4:
	rungenericnpc TX_1602

pastHoboScript_afterSavedNayru:
	rungenericnpc TX_1604

pastHoboScript_afterGotMakuSeed:
	rungenericnpc TX_1605

pastHoboScript_twinrovaKidnappedZelda:
	rungenericnpc TX_1609

pastHoboScript_postGame:
	jumpifmemoryeq wIsLinkedGame, $01, +
	rungenericnpc TX_1607
+
	rungenericnpc TX_160a


; ==============================================================================
; INTERACID_PAST_OLD_LADY
; ==============================================================================
;
; Lady whose husband was sent to work on black tower
pastOldLadySubid0Script:
	rungenericnpclowindex <TX_180a

pastOldLadySubid1Script_befored2:
	rungenericnpclowindex <TX_1800

pastOldLadySubid1Script_afterd2:
	rungenericnpclowindex <TX_1801

pastOldLadySubid1Script_afterd4:
	rungenericnpclowindex <TX_1802

pastOldLadySubid1Script_afterSavedNayru:
	rungenericnpclowindex <TX_1803


; ==============================================================================
; INTERACID_TOKAY
; ==============================================================================

; Script for tokay thieves (except for one "main" thief, see below).
; Subids $00,$01,$03,$04.
tokayThiefScript:
	wait 240
	setanimation $00

tokayThiefCommon:
	setangle $10
	setspeed SPEED_200
	applyspeed $10
	wait 30

	setangle $08
	setspeed SPEED_080
	applyspeed $20

	; Set var39 to nonzero to prevent updating animations
	writeobjectbyte Interaction.var39, $01
	wait 60

	writeobjectbyte Interaction.var39, $00
	applyspeed $20

	writeobjectbyte Interaction.var39, $01
	wait 60

	scriptend

; Subid $02: Script for "main" tokay thief.
tokayMainThiefScript:
	disablemenu
	wait 240
	asm15 scriptHelp.tokayMakeLinkJump
	setanimation $00
	playsound SND_STRIKE
	writememory wTmpcfc0.genericCutscene.cfd1, $01
	scriptjump tokayThiefCommon


; Subid $05: NPC who trades meat for stink bag
tokayCookScript:
	loadscript scriptHelp.tokayCookScript


; Subid $06-$0a: NPC who holds something (ie. shovel or harp, but not shield upgrade).
tokayHoldingItemScript:
	jumptable_objectbyte Interaction.var3c
	.dw @holdingItem
	.dw @returnedItem
	.dw @linkGotAllItems

@holdingItem:
	initcollisions
	checkabutton
	disableinput
	showloadedtext
	wait 30
	setanimation $02

	; Set var3b as a signal to face Link instead of always facing down
	writeobjectbyte Interaction.var3b, $01

	asm15 scriptHelp.tokayGiveItemToLink
	wait 30
	showtextlowindex <TX_0a0c
	orroomflag $40
	enableinput

@returnedItem:
	rungenericnpclowindex <TX_0a0c

@linkGotAllItems:
	rungenericnpclowindex <TX_0a0d


; Subid $0b: Linked game cutscene where tokay runs away from Rosa
tokayRunningFromRosaScript:
	checkmemoryeq w1Link.yh, $50
	disableinput
	wait 30
	showtextlowindex <TX_0a0e
	setspeed SPEED_180
	moveup $11
	wait 30
	setanimation $02
	wait 30
	setzspeed -$01c0
	playsound SND_JUMP

@jumping:
	asm15 objectUpdateSpeedZ, $20
	jumpifobjectbyteeq Interaction.zh, $00, @landed
	wait 1
	scriptjump @jumping

@landed:
	wait 20
	showtextlowindex <TX_0a0f
	wait 30

	moveup $39
	wait 6

	moveleft $2b
	enableinput
	orroomflag $80
	scriptend


; Subid $0d: Past NPC in charge of wild tokay game
tokayGameManagerScript_past:
	initcollisions
	jumpifroomflagset $40, @endingGame ; Check if a game is just ending

@askToPlay:
	jumpifitemobtained TREASURE_BRACELET, @waitForLinkToTalk

@dontHaveBracelet:
	checkabutton
	showtextlowindex <TX_0a1c
	scriptjump @dontHaveBracelet

@waitForLinkToTalk:
	asm15 scriptHelp.tokayGame_determinePrizeAndCheckRupees
	checkabutton
	showtextlowindex <TX_0a10
	disableinput
	wait 10
	asm15 scriptHelp.tokayGame_createAccessoryForPrize, $06
	writeobjectbyte Interaction.animCounter, $7f
	playsound SND_GETSEED
	wait 40

	; Set text based on whether we're playing for the scent seedling.
	settextid TX_0a13
	jumpifmemoryeq wWildTokayGameLevel, $00, +	
	settextid TX_0a11
+
	showloadedtext
	jumpiftextoptioneq $00, @startGame
	settextid TX_0a1a

@selectedNo:
	wait 20
	setanimation $02
	writeobjectbyte Interaction.var3b, $01
	showloadedtext
	enableinput
	scriptjump @waitForLinkToTalk

@startGame:
	jumpifobjectbyteeq Interaction.var3d, $00, @takeRupees

@notEnoughRupees:
	settextid TX_0a1b
	scriptjump @selectedNo

@takeRupees:
	asm15 removeRupeeValue, RUPEEVAL_10
	wait 20
	setanimation $02
	writeobjectbyte Interaction.var3b, $01
	showtextlowindex <TX_0a14
	jumpiftextoptioneq $00, @beginGame

@sayRules:
	wait 20
	showtextlowindex <TX_0a26
	jumpiftextoptioneq $01, @sayRules

@beginGame:
	wait 20
	showtextlowindex <TX_0a15
	wait 20
	scriptend


; Room is being loaded just after a game has ended. Decide what to do based on whether
; Link won the game.
@endingGame:
	asm15 scriptHelp.tokayGame_resetRoomFlag40
	disableinput

	jumpifmemoryeq wTmpcfc0.wildTokay.cfde, $ff, @failedGame

	; Won game
	wait 30
	asm15 scriptHelp.tokayGame_givePrizeToLink
	wait 30
	scriptjump @enableInput

@failedGame:
	; Ask to play again
	asm15 scriptHelp.tokayGame_checkRupees
	showtextlowindex <TX_0a19
	jumpiftextoptioneq $01, @enableInput
	jumpifobjectbyteeq Interaction.var3d, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_10
	scriptjump @beginGame

@enableInput:
	enableinput
	scriptjump @askToPlay


; Subid $0e: Shopkeeper (trades items)
tokayShopkeeperScript:
	makeabuttonsensitive
@npcLoop:
	checkabutton

	; Check that at least one shop item exists
	asm15 scriptHelp.tokayFindShopItem
	jumpifobjectbyteeq Interaction.var3f, $00, @noItemsAvailable

	; At least one item available
	showtextlowindex <TX_0a37
	scriptjump @npcLoop

@noItemsAvailable:
	showtextlowindex <TX_0a38
	scriptjump @npcLoop


; Subid $0f: Tokay who tries to eat Dimitri
tokayWithDimitri1Script:
	disableinput
	jumpifmemoryset wDimitriState, $01, @beginNpcLoop

	setangleandanimation $10
	showtextlowindex <TX_0a1d
	ormemory w1Companion.var3e, $01

@beginNpcLoop:
	makeabuttonsensitive
@npcLoop:
	setangleandanimation $08
	enableinput
	checkabutton
	disableinput
	asm15 scriptHelp.tokayTurnToFaceLink
	showtextlowindex <TX_0a1f

	asm15 scriptHelp.tokayCheckHaveEmberSeeds
	jumpifobjectbyteeq Interaction.var3f, $00, @npcLoop

	showtextlowindex <TX_0a20
	jumptable_memoryaddress wSelectedTextOption
	.dw @selectedYes
	.dw @selectedNo

@selectedNo:
	showtextlowindex <TX_0a22
	scriptjump @npcLoop

; Agreed to trade ember seeds
@selectedYes:
	showtextlowindex <TX_0a23
	asm15 scriptHelp.tokayDecNumEmberSeeds
	ormemory w1Companion.var3e, $04
	spawninteraction INTERACID_TOKAY_CUTSCENE_EMBER_SEED, $00, $48, $18
	spawninteraction INTERACID_TOKAY_CUTSCENE_EMBER_SEED, $00, $58, $38
	wait 30

	showtextlowindex <TX_0a24
	wait 60

	showtextlowindex <TX_0a25
	ormemory w1Companion.var3e, $08
	moveleft $10
	enablemenu
	scriptend


tokayWithDimitri2Script:
	jumpifmemoryset wDimitriState, $01, @beginNpcLoop
	jumpifmemoryset w1Companion.var3e, $01, @script61e9
	scriptjump tokayWithDimitri2Script

@script61e9:
	disableinput
	wait 30
	setangleandanimation $10
	showtextlowindex <TX_0a1e
	ormemory w1Companion.var3e, $02
	enableinput

@beginNpcLoop:
	makeabuttonsensitive
@faceUp:
	setangleandanimation $00
@npcLoop:
	jumpifobjectbyteeq Interaction.pressedAButton, $00, @didntPressA

	; Pressed A next to tokay
	asm15 scriptHelp.tokayTurnToFaceLink
	showtextlowindex <TX_0a1e
	writeobjectbyte Interaction.pressedAButton, $00
	scriptjump @faceUp
@didntPressA:
	jumpifmemoryset w1Companion.var3e, $04, @beginCutscene
	scriptjump @npcLoop

; Face down, wait for signal to run away
@beginCutscene:
	setangleandanimation $10
@wait:
	jumpifmemoryset w1Companion.var3e, $08, @runAway
	wait 1
	scriptjump @wait

@runAway:
	moveleft $20
	ormemory wDimitriState, $02
	enableallobjects
	scriptend


; Subid $11: Past NPC looking after scent seedling
tokayAtSeedlingPlotScript:
	makeabuttonsensitive
@npcLoop:
	setangleandanimation $10
	checkabutton
	asm15 scriptHelp.tokayTurnToFaceLink
	jumpifroomflagset $80, @alreadyPlantedSeedling
	jumpifitemobtained TREASURE_SCENT_SEEDLING, @plantSeedling
	showtextlowindex <TX_0a40
	scriptjump @npcLoop

@plantSeedling:
	disableinput
	showtextlowindex <TX_0a40
	wait 30

	showtextlowindex <TX_0a41

	asm15 scriptHelp.tokayFlipDirection
	setspeed SPEED_100
	applyspeed $10

	asm15 scriptHelp.tokayFlipDirection
	asm15 scriptHelp.tokayPlantScentSeedling
	spawninteraction INTERACID_DECORATION, $04, $38, $48
	playsound SND_GETSEED
	wait 120

	asm15 scriptHelp.tokayTurnToFaceLink
	showtextlowindex <TX_0a42

	enableinput
	scriptjump @npcLoop

@alreadyPlantedSeedling:
	jumpifitemobtained TREASURE_SCENT_SEEDS, @gotScentSeeds
	showtextlowindex <TX_0a43
	scriptjump @npcLoop

@gotScentSeeds:
	showtextlowindex <TX_0a44
	scriptjump @npcLoop


; Subid $19: Present NPC in charge of the wild tokay museum
tokayGameManagerScript_present:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @askForSecret
	rungenericnpclowindex <TX_0a67

@askForSecret:
	initcollisions

	; Check if we're loading the room just after ending the minigame
	jumpifroomflagset $40, @endingMinigame

	; Check if the secret quest has been completed
	jumpifglobalflagset GLOBALFLAG_DONE_TOKAY_SECRET, @alreadyGotBombUpgrade

	; Check if the secret has been told to the tokay (but game hasn't been finished
	; yet)
	jumpifglobalflagset GLOBALFLAG_BEGAN_TOKAY_SECRET, @npcLoop_waitingForLinkToPlayMinigame


; Waiting for Link to tell the secret
@npcLoop_waitingForSecret:
	checkabutton
	disableinput
	showtextlowindex <TX_0a45
	wait 20

	jumpiftextoptioneq $00, @enterSecret
	wait 30

	; Declined to tell secret
	showtextlowindex <TX_0a46
	enableinput
	scriptjump @npcLoop_waitingForSecret

@enterSecret:
	askforsecret TOKAY_SECRET
	wait 20
	jumpifmemoryeq wTextInputResult, $00, @validSecret

	; No valid secret entered
	showtextlowindex <TX_0a48
	enableinput
	scriptjump @npcLoop_waitingForSecret

@validSecret:
	setglobalflag GLOBALFLAG_BEGAN_TOKAY_SECRET
	showtextlowindex <TX_0a47
	scriptjump @promptToPlayMinigame


; The secret has been entered, but Link still needs to complete the minigame.
@npcLoop_waitingForLinkToPlayMinigame:
	checkabutton
	disableinput
	showtextlowindex <TX_0a51

@promptToPlayMinigame:
	wait 2
	jumpiftextoptioneq $00, @promptRules
	wait 20

	; Declined to play minigame
	showtextlowindex <TX_0a52
	enableinput
	scriptjump @npcLoop_waitingForLinkToPlayMinigame

@promptRules:
	wait 20
	showtextlowindex <TX_0a4a
	wait 2
	jumpiftextoptioneq $00, @beginGame

@explainRules:
	wait 20
	showtextlowindex <TX_0a4b
	wait 20
	jumpiftextoptioneq $01, @explainRules

@beginGame:
	wait 20
	showtextlowindex <TX_0a4c
	wait 40
	scriptend


; Just finished a minigame.
@endingMinigame:
	asm15 scriptHelp.tokayGame_resetRoomFlag40
	disableinput
	jumpifmemoryeq wTmpcfc0.wildTokay.cfde, $ff, @failedGame

	; Won the minigame
	showtextlowindex <TX_0a4f
	wait 30

	asm15 scriptHelp.tokayGiveBombUpgrade
	giveitem TREASURE_BOMB_UPGRADE, $00
	wait 30

	setglobalflag GLOBALFLAG_DONE_TOKAY_SECRET
	generatesecret TOKAY_RETURN_SECRET
	showtextlowindex <TX_0a50
	enableinput

@alreadyGotBombUpgrade:
	checkabutton
	generatesecret TOKAY_RETURN_SECRET
	showtextlowindex <TX_0a53
	scriptjump @alreadyGotBombUpgrade

@failedGame:
	showtextlowindex <TX_0a4d
	wait 20
	jumpiftextoptioneq $00, @beginGame
	showtextlowindex <TX_0a4e
	enableinput
	scriptjump @npcLoop_waitingForLinkToPlayMinigame


; Subid $1d: NPC holding shield upgrade
tokayWithShieldUpgradeScript:
	loadscript scriptHelp.tokayWithShieldUpgradeScript


; Subid $1e: Present NPC who talks to you after climbing down vine
tokayExplainingVinesScript:
	loadscript scriptHelp.tokayExplainingVinesScript


; ==============================================================================
; INTERACID_FOREST_FAIRY
; ==============================================================================

; NPC for first fairy on "main" forest screen, after being found
forestFairyScript_firstDiscovered:
	makeabuttonsensitive
@npcLoop:
	checkabutton
	showtext TX_1108
	scriptjump @npcLoop

; NPC for second fairy on "main" forest screen, after being found
forestFairyScript_secondDiscovered:
	makeabuttonsensitive
@npcLoop:
	checkabutton
	showtext TX_1109
	scriptjump @npcLoop

; Subids $05-$0a
forestFairyScript_genericNpc:
	setcollisionradii $04, $04
	makeabuttonsensitive
@npcLoop:
	checkabutton
	showloadedtext
	scriptjump @npcLoop


; Subid $0b: NPC in unlinked game who takes a secret
forestFairyScript_heartContainerSecret:
	setcollisionradii $04, $04
	makeabuttonsensitive
@npcLoop:
	checkabutton
	disableinput
	jumpifglobalflagset GLOBALFLAG_DONE_FAIRY_SECRET, @alreadyGaveSecret
	showtext TX_1148
	wait 30
	jumpiftextoptioneq $00, @askForSecret
	showtext TX_1149
	scriptjump @enableInput

@askForSecret:
	askforsecret FAIRY_SECRET
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @gaveValidSecret
	showtext TX_114b
	scriptjump @enableInput

@gaveValidSecret:
	setglobalflag GLOBALFLAG_BEGAN_FAIRY_SECRET
	showtext TX_114a
	wait 30

	giveitem TREASURE_HEART_CONTAINER, $02
	wait 30

	generatesecret FAIRY_RETURN_SECRET
	setglobalflag GLOBALFLAG_DONE_FAIRY_SECRET
	showtext TX_114c
	scriptjump @enableInput

@alreadyGaveSecret:
	; BUG: JP version doesn't show the correct secret when asking the 2nd time onward?
.ifdef ENABLE_US_BUGFIXES
	generatesecret FAIRY_RETURN_SECRET
.endif
	showtext TX_114d

@enableInput:
	enableinput
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_RABBIT
; ==============================================================================

; Subid 0: Listening to Nayru at the start of the game
rabbitScript_listeningToNayruGameStart:
	initcollisions
@npcLoop:
	checkabutton
	asm15 scriptHelp.turnToFaceLink
	ormemory wTmpcfc0.genericCutscene.cfde, $02
	showtext TX_5705
	wait 10
	setanimation $00
	scriptjump @npcLoop


; Subid 4: Watching other rabbits getting restored from stone
rabbitSubid4Script:
	wait 30
	setanimation $02
	wait 90
	setanimation $03
	scriptend

rabbitScript_waitingForNayru1:
	rungenericnpc TX_5717
rabbitScript_waitingForNayru2:
	rungenericnpc TX_5718


; ==============================================================================
; INTERACID_BIRD
; ==============================================================================

; Subid 0: Listening to Nayru at the start of the game
birdScript_listeningToNayruGameStart:
	initcollisions
@npcLoop:
	checkabutton
	setdisabledobjectsto11
	asm15 interactionSetAlwaysUpdateBit
	writeobjectbyte Interaction.var37, $01 ; Signal to start hopping
	cplinkx $48
	addobjectbyte Interaction.direction, $02
	setanimationfromobjectbyte Interaction.direction
	ormemory wTmpcfc0.genericCutscene.cfde, $01
	showtext TX_3214

	writeobjectbyte Interaction.var37, $00 ; Stop hopping
	writeobjectbyte Interaction.zh, $00
	wait 10

	enableallobjects
	setanimation $01
	asm15 interactionUnsetAlwaysUpdateBit
	scriptjump @npcLoop


; Subid 4: Bird with Impa when Zelda gets kidnapped
birdScript_zeldaKidnapped:
	initcollisions
	jumpifglobalflagset GLOBALFLAG_ZELDA_SAVED_FROM_VIRE, @zeldaSaved

@npcLoop:
	checkabutton
	setanimation $02
	showtext TX_3216
	setanimation $00
	scriptjump @npcLoop

@zeldaSaved:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $05
	setanimation $02
	wait 30
	showtext TX_3217

	setanimation $00
	writememory wTmpcfc0.genericCutscene.cfd0, $06
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $07

	setanimation $02
	setspeed SPEED_100
	setangle $18
	applyspeed $10

	setangle $00
	applyspeed $60
	scriptend


; ==============================================================================
; INTERACID_AMBI
; ==============================================================================

; Cutscene where you give mystery seeds to Ambi
ambiSubid00Script:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $01
	wait 30

	showtext TX_1301
	wait 30

	setanimation $03
	wait 20
	showtext TX_1302

	writememory wTmpcfc0.genericCutscene.cfd1, $02
	wait 10

	setanimation $02
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $06
	wait 150

	setspeed SPEED_080
	moveup $60

	writememory wTmpcfc0.genericCutscene.cfd1, $07
	scriptend

; Cutscene after escaping black tower (part 1)
ambiSubid01Script_part1:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $07
	playsound SNDCTRL_STOPMUSIC
	showtext TX_130e

	playsound MUS_PRECREDITS
	wait 10

	writememory wTmpcfc0.genericCutscene.cfd0, $08
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $09
	showtext TX_130f

	wait 60
	writememory wTmpcfc0.genericCutscene.cfd0, $0a
	scriptend


; Cutscene after escaping black tower (part 2, unlinked only)
ambiSubid01Script_part2:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $0c
	showtext TX_1310
	wait 30

	writememory wTmpcfc0.genericCutscene.cfd0, $0d
	checkobjectbyteeq Interaction.var3e, $01
	wait 10

	showtext TX_1311
	wait 120

	writememory wTmpcfc0.genericCutscene.cfd0, $0f
	scriptend


; Credits cutscene where Ambi observes construction of Link statue
ambiSubid02Script:
	wait 180
	asm15 fadeoutToWhite
	checkpalettefadedone

	writememory wTmpcfc0.genericCutscene.state, $01
	wait 30

	asm15 fadeinFromWhite
	setspeed SPEED_040
	setangle $10
	checkmemoryeq wTmpcfc0.genericCutscene.state, $04
	scriptend


; Cutscene where Ambi does evil stuff atop black tower (after d7)
ambiSubid03Script:
	wait 60

	setspeed SPEED_080
	movedown $64
	setspeed SPEED_040
	movedown $40
	setspeed SPEED_080
	movedown $2c

	wait 60
	setanimation $0a
	showtext TX_130b
	wait 20

	writememory   wTmpcfc0.genericCutscene.state, $01
	checkmemoryeq wTmpcfc0.genericCutscene.state, $02

	wait 30
	showtext TX_130c
	writememory wCutsceneTrigger, CUTSCENE_TURN_TO_STONE
	scriptend


; Same cutscene as subid $03, but second part
ambiSubid04Script:
	setanimation $0a
	checkpalettefadedone
	wait 60

	showtext TX_130d
	wait 6

	orroomflag $40
	scriptend


; Cutscene where Ralph confronts Ambi
ambiSubid05Script:
	setspeed SPEED_080
	setangle $10
	checkcfc0bit 0
	wait 8

	; Approaching Ralph
	applyspeed $11
	wait 20
	applyspeed $11
	wait 20
	applyspeed $11

	; Wait for next part of cutscene
	checkcfc0bit 2

	; Become transparent
	writeobjectbyte Interaction.var3f, $2d
	playsound SNDCTRL_MEDIUM_FADEOUT
	playsound SND_TELEPORT
@flickerLoop:
	asm15 scriptHelp.ambiFlickerVisibility
	asm15 scriptHelp.ambiDecVar3f
	jumpifmemoryset wcddb, $80, @beginRising
	scriptjump @flickerLoop

@beginRising:
	playsound SND_SWORDSPIN
@risingLoop:
	asm15 scriptHelp.ambiRiseUntilOffScreen
	jumpifmemoryset wcddb, $10, @doneRising
	asm15 scriptHelp.ambiFlickerVisibility
	scriptjump @risingLoop

@doneRising:
	xorcfc0bit 3
	scriptend


; Cutscene just before fighting possessed Ambi
ambiSubid06Script:
	disableinput
	checkcfc0bit 0
	spawnenemyhere ENEMYID_VERAN_POSSESSION_BOSS, $01
	wait 1
	enableinput
	scriptend


; Cutscene where Ambi regains control of herself
ambiSubid07Script:
	showtext TX_1318
	wait 16
	showtext TX_1319

	writememory wLinkForceState, LINK_STATE_AMBI_UNPOSSESSED_CUTSCENE
	setspeed SPEED_180
	movedown $3c
	spawninteraction INTERACID_GHOST_VERAN, $02, $00, $28
	scriptend


; Cutscene after d3 where you're told Ambi's tower will soon be complete
ambiSubid08Script:
	checkpalettefadedone
	wait 60
	showtext TX_1316
	wait 60

	asm15 fadeoutToWhite
	checkpalettefadedone
	scriptend


; NPC after Zelda is kidnapped
ambiSubid0aScript:
	rungenericnpc TX_131a


; ==============================================================================
; INTERACID_SUBROSIAN
; ==============================================================================

subrosianInVillageScript_afterGotMakuSeed:
	rungenericnpclowindex <TX_1c05

; This might be unused, since the postgame never happens when linked?
subrosianInVillageScript_postGame:
	rungenericnpclowindex <TX_1c07

subrosianAtGoronDanceScript_greenNpc:
	asm15 scriptHelp.checkIsLinkedGameForScript
	jumpifmemoryset wcddb, $80, stubScript
	rungenericnpclowindex <TX_1c14

subrosianAtGoronDanceScript_redNpc:
	asm15 scriptHelp.checkIsLinkedGameForScript
	jumpifmemoryset wcddb, $80, stubScript
	writeobjectbyte Interaction.oamFlags, $02
	rungenericnpclowindex <TX_1c15


; ==============================================================================
; INTERACID_IMPA_NPC
; ==============================================================================
impaNpcScript_lookingAtPassage:
	initcollisions
@npcLoop:
	checkabutton
	turntofacelink
	writeobjectbyte Interaction.direction, $ff
	showloadedtext
	setanimation $00
	scriptjump @npcLoop

; ==============================================================================
; INTERACID_DUMBBELL_MAN
; ==============================================================================
dumbbellManScript:
	loadscript scriptHelp.dumbbellManScript


; ==============================================================================
; INTERACID_OLD_MAN
; ==============================================================================
oldManScript_givesShieldUpgrade:
	loadscript scriptHelp.oldManScript_givesShieldUpgrade

oldManScript_givesBookOfSeals:
	loadscript scriptHelp.oldManScript_givesBookOfSeals

oldManScript_givesFairyPowder:
	loadscript scriptHelp.oldManScript_givesFairyPowder

oldManScript_generic:
	makeabuttonsensitive
@npcLoop:
	checkabutton
	turntofacelink
	showloadedtext
	asm15 scriptHelp.oldManSetAnimationToVar38
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_MAMAMU_YAN
; ==============================================================================
mamamuYanScript:
	loadscript scriptHelp.mamamuYanScript


; ==============================================================================
; INTERACID_MAMAMU_DOG
; ==============================================================================
dogInMamamusHouseScript:
	asm15 scriptHelp.mamamuDog_setCounterRandomly
@loop:
	asm15 scriptHelp.mamamuDog_decCounter
	jumpifmemoryset wcddb, $80, @counterHit0
	asm15 scriptHelp.mamamuDog_updateSpeedZ
	asm15 scriptHelp.mamamuDog_checkReverseDirection
	scriptjump @loop

@counterHit0:
	asm15 scriptHelp.mamamuDog_setZPositionTo0
	asm15 scriptHelp.mamamuDog_reverseDirection
	wait 180
	asm15 scriptHelp.mamamuDog_reverseDirection
	scriptjump dogInMamamusHouseScript


; ==============================================================================
; INTERACID_POSTMAN
; ==============================================================================
postmanScript:
	loadscript scriptHelp.postmanScript


; ==============================================================================
; INTERACID_PICKAXE_WORKER
; ==============================================================================

; Worker below Maku Tree screen in past
pickaxeWorkerSubid00Script:
	initcollisions
@npcLoop:
	asm15 interactionSetAnimation, $02
	checkabutton
	asm15 interactionSetAnimation, $03
	showtextlowindex <TX_1b00
	scriptjump @npcLoop


; Credits cutscene guy making Link statue? (subids $01 and $02)
pickaxeWorkerSubid01Script_part1:
	setanimation $05
	addobjectbyte Interaction.animCounter, $08
	setspeed SPEED_080
@loop:
	setanimation $06
	setangle $10
	applyspeed $10
	wait 8
	asm15 scriptHelp.pickaxeWorker_setRandomDelay

	setanimation $05
	setanimation $06
	setangle $00
	applyspeed $10
	wait 8
	asm15 scriptHelp.pickaxeWorker_setRandomDelay

	setanimation $05
	scriptjump @loop


pickaxeWorkerSubid02Script_part1:
	setanimation $04
	addobjectbyte Interaction.animCounter, $08
	setspeed SPEED_080
@loop:
	setanimation $06
	setangle $00
	applyspeed $10
	wait 8
	asm15 scriptHelp.pickaxeWorker_setRandomDelay

	setanimation $04
	setanimation $06
	setangle $10
	applyspeed $10
	wait 8
	asm15 scriptHelp.pickaxeWorker_setRandomDelay

	setanimation $04
	scriptjump @loop

pickaxeWorkerSubid01Script_part2:
	loadscript scriptHelp.pickaxeWorkerSubid01Script_part2

pickaxeWorkerSubid01Script_part3:
	writeobjectbyte Interaction.var3f, $01
	checkpalettefadedone
	wait 60

	writememory wTmpcfc0.genericCutscene.state, $07
	wait 90

	writeobjectbyte Interaction.var3f, $00
	setangle $18
	applyspeed $40
	wait 120

	writememory wTmpcfc0.genericCutscene.cfdf, $ff
	scriptend

pickaxeWorkerSubid02Script_part2:
	setcoords $55, $62
	setanimation $07
	asm15 objectSetVisible83
	wait 60

	setspeed SPEED_040
	setangle $00
	applyspeed $14
	wait 10

	setangle $18
	applyspeed $30

	writeobjectbyte Interaction.var3f, $01
	checkmemoryeq wTmpcfc0.genericCutscene.state, $04
	setangle $10
	scriptend

pickaxeWorkerSubid02Script_part3:
	writeobjectbyte Interaction.var3f, $01
	checkpalettefadedone
	wait 150

	writeobjectbyte Interaction.var3f, $00
	setangle $18
	applyspeed $60
	scriptend


; Worker in black tower.
pickaxeWorkerSubid03Script:
	asm15 scriptHelp.pickaxeWorker_setAnimationFromVar03
	initcollisions
@npcLoop:
	checkabutton
	asm15 scriptHelp.pickaxeWorker_chooseRandomBlackTowerText
	showloadedtext
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_HARDHAT_WORKER
; ==============================================================================

; NPC who gives you the shovel. If var03 is nonzero, he's just a generic guy.
hardhatWorkerSubid00Script:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	asm15 scriptHelp.turnToFaceLink
	jumptable_objectbyte Interaction.var03
	.dw @givesShovel
	.dw @doesntGiveShovel

@givesShovel:
	jumpifroomflagset $20, @alreadyGaveShovel
	showtextlowindex <TX_1001
	wait 30
	giveitem TREASURE_SHOVEL, $00
	wait 30

@alreadyGaveShovel:
	showtextlowindex <TX_1002
	scriptjump @enableInput

@doesntGiveShovel:
	showtextlowindex <TX_1000

@enableInput:
	setanimation $04
	enableinput
	scriptjump @npcLoop


; Generic NPC.
hardhatWorkerSubid01Script:
	jumptable_objectbyte Interaction.var03
	.dw @var03_00
	.dw @var03_01

@var03_00:
	asm15 scriptHelp.hardhatWorker_checkBlackTowerProgressIs00
	jumpifmemoryset wcddb, $80, ++
	scriptend
++
	rungenericnpclowindex <TX_1007

@var03_01:
	asm15 scriptHelp.hardhatWorker_checkBlackTowerProgressIs01
	jumpifmemoryset wcddb, $80, ++
	scriptend
++
	rungenericnpclowindex <TX_1008


hardhatWorkerSubid02Script:
	loadscript scriptHelp.hardhatWorkerSubid02Script


hardhatWorkerSubid03Script:
	loadscript scriptHelp.hardhatWorkerSubid03Script


; The object moves for [var3c] frames, and its direction is stored in [var3e]. When
; [var3c] hits 0, this returns. The object can also be talked to by Link while doing this.
hardhatWorkerFunc_patrol:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	asm15 scriptHelp.hardhatWorker_decPatrolCounter
	jumpifmemoryset wcddb, $80, @doneMoving
	asm15 objectApplySpeed
	scriptjump hardhatWorkerFunc_patrol

@doneMoving:
	wait 20
	retscript

@pressedA:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	asm15 scriptHelp.turnToFaceLink
	showloadedtext
	wait 30

	asm15 scriptHelp.hardhatWorker_updatePatrolAnimation
	enableinput
	scriptjump hardhatWorkerFunc_patrol


; ==============================================================================
; INTERACID_POE
; ==============================================================================
poeScript:
	loadscript scriptHelp.poeScript


; ==============================================================================
; INTERACID_OLD_ZORA
; ==============================================================================
oldZoraScript:
	loadscript scriptHelp.oldZoraScript


; ==============================================================================
; INTERACID_TOILET_HAND
; ==============================================================================
toiletHandScript:
	asm15 objectSetInvisible
	initcollisions

@npcLoop:
	writeobjectbyte Interaction.pressedAButton, $00

@waitForLinkToApproach:
	wait 1
	asm15 scriptHelp.toiletHand_checkLinkIsClose
	jumpifmemoryset wcddb, $10, @waitForLinkToApproach

	callscript @retreatAndReturnFromToilet
@waitForLinkToRetreat:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	asm15 scriptHelp.toiletHand_checkLinkIsClose
	jumpifmemoryset wcddb, $10, @linkRetreated
	scriptjump @waitForLinkToRetreat

@linkRetreated:
	callscript @retreatIntoToilet
	scriptjump @npcLoop

@waitForLinkToReapproach:
	asm15 scriptHelp.toiletHand_checkLinkIsClose
	jumpifmemoryset wcddb, $10, ++
	scriptjump @waitForLinkToReapproach
++
	scriptjump @npcLoop

@pressedA:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	jumpifroomflagset $20, @alreadyGaveStinkBag
	showtextlowindex <TX_0b07
	jumpiftradeitemeq TRADEITEM_STATIONERY, @promptForTrade

	; Don't have correct trade item
	callscript @retreatIntoToiletAfterDelay
	enableinput
	scriptjump @waitForLinkToReapproach

@promptForTrade:
	wait 30
	showtextlowindex <TX_0b08
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

	; Declined trade
	showtextlowindex <TX_0b0a
	callscript @retreatIntoToiletAfterDelay
	enableinput
	scriptjump @waitForLinkToReapproach

@acceptedTrade:
	showtextlowindex <TX_0b09
	callscript @retreatIntoToiletAfterDelay
	wait 30

	showtextlowindex <TX_0b0b
	callscript @retreatAndReturnFromToiletAfterDelay
	wait 30
	showtextlowindex <TX_0b0c
	wait 30

	giveitem TREASURE_TRADEITEM, $02
	callscript @retreatIntoToiletAfterDelay
	enableinput
	scriptjump @waitForLinkToReapproach

@alreadyGaveStinkBag:
	showtextlowindex <TX_0b09
	callscript @retreatIntoToiletAfterDelay
	enableinput
	scriptjump @waitForLinkToReapproach


; Script functions

@retreatAndReturnFromToiletAfterDelay:
	wait 30
@retreatAndReturnFromToilet:
	writeobjectbyte Interaction.pressedAButton, $00
	asm15 objectSetVisible
	asm15 scriptHelp.toiletHand_disappear
	checkobjectbyteeq Interaction.animParameter, $ff
	asm15 scriptHelp.toiletHand_comeOutOfToilet
	retscript


@retreatIntoToiletAfterDelay:
	wait 30
@retreatIntoToilet:
	asm15 scriptHelp.toiletHand_retreatIntoToilet

toiletHandScriptFunc_waitUntilFullyRetreated:
	checkobjectbyteeq Interaction.animParameter, $ff
	asm15 objectSetInvisible
	retscript


; Script runs when Link drops an object in a hole. var38 is set to an index based on which
; item it was.
toiletHandScript_reactToObjectInHole:
	asm15 scriptHelp.toiletHand_checkVisibility

	; This is weird. Did they mean to check bit 7? That would check visibility.
	; Instead this checks his draw priority (bits 0-2).
	jumpifmemoryset wcddb, $07, @retreatIntoToilet

	wait 90
	scriptjump @react

@retreatIntoToilet:
	asm15 scriptHelp.toiletHand_retreatIntoToiletIfNotAlready
	callscript toiletHandScriptFunc_waitUntilFullyRetreated
	wait 45

@react:
	jumptable_objectbyte Interaction.var38
	.dw @bomb
	.dw @bombchu
	.dw @somaria
	.dw @emberSeed
	.dw @scentSeed
	.dw @galeSeed
	.dw @mysterySeed
	.dw @pot

@bombchu:
	showtextlowindex <TX_0b26
	wait 30
@bomb:
	asm15 setScreenShakeCounter, 60
	asm15 playSound, SND_EXPLOSION
	wait 60
	showtextlowindex <TX_0b25
	scriptend
@somaria:
	showtextlowindex <TX_0b27
	scriptend
@emberSeed:
	showtextlowindex <TX_0b28
	scriptend
@scentSeed:
	showtextlowindex <TX_0b29
	scriptend
@galeSeed:
	showtextlowindex <TX_0b2a
	scriptend
@mysterySeed:
	showtextlowindex <TX_0b2b
	scriptend
@pot:
	showtextlowindex <TX_0b0a
	scriptend


; ==============================================================================
; INTERACID_MASK_SALESMAN
; ==============================================================================
maskSalesmanScript:
	loadscript scriptHelp.maskSalesmanScript


; ==============================================================================
; INTERACID_BEAR
; ==============================================================================

; Bear listening to Nayru at start of game.
bearSubid00Script_part1:
	initcollisions
	jumpifroomflagset $80, @alreadyMovedDown

@npcLoop:
	checkabutton
	ormemory wTmpcfc0.genericCutscene.cfde, $10
	jumpifmemoryeq wTmpcfc0.genericCutscene.cfde, $1f, @moveDown
	showtext TX_5702
	scriptjump @npcLoop

@moveDown:
	setdisabledobjectsto11
	setanimation $01
	wait 20
	setangle $00
	setspeed SPEED_080
	applyspeed $20
	wait 20
	setanimation $00
	wait 30
	orroomflag $80
	enableallobjects

@justSitAndListen:
	showtext TX_5703

@alreadyMovedDown:
	checkabutton
	scriptjump @justSitAndListen

bearSubid00Script_part2:
	wait 120
	showtext TX_5706
	wait 30
	writememory wCutsceneTrigger, CUTSCENE_NAYRU_SINGING
	scriptend


; NPC bear.
bearSubid02Script:
	initcollisions
@npcLoop:
	checkabutton
	showloadedtext
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_SYRUP
; ==============================================================================

syrupScript_spawnShopItems:
	spawninteraction INTERACID_SHOP_ITEM, $0b, $28, $44
	spawninteraction INTERACID_SHOP_ITEM, $07, $28, $4c
	spawninteraction INTERACID_SHOP_ITEM, $08, $28, $74
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


; ==============================================================================
; INTERACID_COMEDIAN
; ==============================================================================
comedianScript:
	loadscript scriptHelp.comedianScript


; ==============================================================================
; INTERACID_GORON
; ==============================================================================

; Graceful goron.
goron_subid00Script:
	setcollisionradii $0a, $0c
	makeabuttonsensitive

goron_subid00_npcLoop:
	checkabutton
	disableinput
	asm15 scriptHelp.goron_checkInPresent
	jumpifmemoryset wcddb, CPU_ZFLAG, @present

@past:
	; Only check these in the past
	jumpifitemobtained TREASURE_MERMAID_KEY, @danceForGenericItem
	jumpifitemobtained TREASURE_GORON_LETTER, @danceForOldMermaidKey

@present:
	; Check this in past and present
	jumpifitemobtained TREASURE_BROTHER_EMBLEM, @danceForGenericItem

	; Dance for brother emblem
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2400
	wait 30
	jumpiftextoptioneq $00, @acceptedDance
	scriptjump @declinedDance

@danceForGenericItem:
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2401
	wait 30
	jumpiftextoptioneq $00, @acceptedDance
	scriptjump @declinedDance

@danceForOldMermaidKey:
	showtext TX_2419
	wait 30
	jumpiftextoptioneq $00, @acceptedDance

@declinedDance:
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2403
	wait 1
	enableinput
	scriptjump goron_subid00_npcLoop

@acceptedDance:
	callscript goronDanceFunc_checkLinkHasEnoughRupees
	jumpifmemoryset wcddb, CPU_ZFLAG, @enoughRupees

@notEnoughRupeesLoop:
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2409
	enableinput
	checkabutton
	scriptjump @notEnoughRupeesLoop

@enoughRupees:
	disableinput
	callscript goronDanceFunc_takeRupeesFromLink

	; Ask whether to explain the rules
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2402
	wait 30
	jumpiftextoptioneq $00, goronDance_begin

@giveExplanation:
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2404
	wait 30

	playsound SND_GORON_DANCE_B
	setanimation $03
	wait 30

	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2405
	wait 30

	playsound SND_DING
	setanimation $06
	wait 30

	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2406
	wait 30

	setanimation $02
	jumpiftextoptioneq $00, goronDance_begin
	scriptjump @giveExplanation


goronDance_begin:
	asm15 scriptHelp.goron_checkInPresent
	jumpifmemoryset wcddb, CPU_ZFLAG, @present

@past:
	; Only check these in the past
	jumpifitemobtained TREASURE_MERMAID_KEY, @selectDifficulty
	jumpifitemobtained TREASURE_GORON_LETTER, @lowestDanceLevel

@present:
	; Check this in past and present
	jumpifitemobtained TREASURE_BROTHER_EMBLEM, @selectDifficulty

@lowestDanceLevel:
	asm15 scriptHelp.goron_checkInPresent
	jumpifmemoryset wcddb, CPU_ZFLAG, ++

	; Past
	writememory wTmpcfc0.goronDance.danceLevel, $02
	scriptjump @beginDance
++
	; Present
	writememory wTmpcfc0.goronDance.danceLevel, $03
	scriptjump @beginDance

@selectDifficulty:
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_240b
	wait 30
	callscript goronDance_setDifficultyFromSelectedOption
	wait 30

@beginDance:
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2407
	wait 40
	asm15 fadeoutToWhite
	checkpalettefadedone

	asm15 clearAllItemsAndPutLinkOnGround
	asm15 scriptHelp.goronDance_initLinkPosition
	wait 40

	asm15 fadeinFromWhite
	checkpalettefadedone

	asm15 restartSound
	wait 40

	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2408
	wait 40
	scriptend


goronDance_setDifficultyFromSelectedOption:
	asm15 scriptHelp.goron_checkInPresent
	jumpifmemoryset wcddb, $80, @present

@past:
	jumptable_memoryaddress wSelectedTextOption
	.dw @platinum
	.dw @gold
	.dw @silver
@present:
	jumptable_memoryaddress wSelectedTextOption
	.dw @gold
	.dw @silver
	.dw @bronze

@platinum:
	writememory wTmpcfc0.goronDance.danceLevel, $00
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_240c
	retscript
@gold:
	writememory wTmpcfc0.goronDance.danceLevel, $01
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_240d
	retscript
@silver:
	writememory wTmpcfc0.goronDance.danceLevel, $02
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_240e
	retscript
@bronze:
	writememory wTmpcfc0.goronDance.danceLevel, $03
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_240f
	retscript


goronDanceFunc_checkLinkHasEnoughRupees:
	asm15 scriptHelp.goron_checkInPresent
	jumpifmemoryset wcddb, CPU_ZFLAG, @present
@past:
	asm15 scriptHelp.shootingGallery_checkLinkHasRupees, RUPEEVAL_20
	retscript
@present:
	asm15 scriptHelp.shootingGallery_checkLinkHasRupees, RUPEEVAL_10
	retscript


goronDanceFunc_takeRupeesFromLink:
	asm15 scriptHelp.goron_checkInPresent
	jumpifmemoryset wcddb, CPU_ZFLAG, @present
@past:
	asm15 removeRupeeValue, RUPEEVAL_20
	retscript
@present:
	asm15 removeRupeeValue, RUPEEVAL_10
	retscript


; Script run when a round in the goron dance minigame is failed.
goronDanceScript_failedRound:
	callscript @showFailureText
	wait 30
	jumptable_memoryaddress wTmpcfc0.goronDance.numFailedRounds
	.dw @firstFailure
	.dw @firstFailure
	.dw @secondFailure
	.dw @thirdFailure

@firstFailure:
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2416
	wait 30
	scriptend

@secondFailure:
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2417
	wait 30
	scriptend

; Stop the presses, minigame's over
@thirdFailure:
	resetmusic

	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2418
	wait 30

	; Ask to try again
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2415
	wait 30
	jumpiftextoptioneq $00, @tryAgain

	; Not trying again
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2403
	wait 1
	asm15 scriptHelp.goronDance_clearVariables
	enableinput
	scriptjump goron_subid00_npcLoop

@tryAgain:
	callscript goronDanceFunc_checkLinkHasEnoughRupees
	jumpifmemoryset wcddb, CPU_ZFLAG, @enoughRupees

@notEnoughRupeesLoop:
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2409
	wait 1
	enableinput
	checkabutton
	scriptjump @notEnoughRupeesLoop

@enoughRupees:
	asm15 restartSound
	callscript goronDanceFunc_takeRupeesFromLink
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2407
	wait 30
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2408
	asm15 scriptHelp.goronDance_restartGame
	scriptend

@showFailureText:
	jumptable_memoryaddress wTmpcfc0.goronDance.failureType
	.dw @tooEarly
	.dw @tooLate
	.dw @wrongMove
@tooEarly:
	showtext TX_313f
	retscript
@tooLate:
	showtext TX_3140
	retscript
@wrongMove:
	showtext TX_3141
	retscript


; Script run when the goron dance is successfully completed.
goronDanceScript_givePrize:
	wait 30
	resetmusic
	asm15 scriptHelp.goron_checkInPresent
	jumpifmemoryset wcddb, CPU_ZFLAG, @present

@past:
	; Only check these in the past
	jumpifitemobtained TREASURE_MERMAID_KEY, @giveGenericPrize
	jumpifitemobtained TREASURE_GORON_LETTER, @giveOldMermaidKey

@present:
	; Check this in past and present
	jumpifitemobtained TREASURE_BROTHER_EMBLEM, @giveGenericPrize

	; Give brother emblem
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2410
	wait 30
	giveitem TREASURE_BROTHER_EMBLEM, $00
	wait 30
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2411
	wait 30
	asm15 scriptHelp.goronDance_clearVariables
	enableinput
	scriptjump goron_subid00_npcLoop

@giveOldMermaidKey:
	showtext TX_241a
	wait 30
	giveitem TREASURE_OBJECT_MERMAID_KEY_00
	wait 30
	showtext TX_241b
	wait 30
	asm15 scriptHelp.goronDance_clearVariables
	enableinput
	scriptjump goron_subid00_npcLoop

@giveGenericPrize:
	asm15 scriptHelp.goronDance_checkNumFailedRounds
	jumpifmemoryset wcddb, CPU_ZFLAG, @perfectGame

	; Failed at least one round
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2413
	wait 1
	callscript goronDance_giveRewardForImperfectGame
	wait 30
	scriptjump @cleanup

@perfectGame:
	; Failed no rounds
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2412
	wait 1
	callscript goronDance_giveRewardForPerfectGame
	wait 30

@cleanup:
	asm15 scriptHelp.goron_showText_differentForPresent, <TX_2414
	wait 30
	asm15 scriptHelp.goronDance_clearVariables
	enableinput
	scriptjump goron_subid00_npcLoop


goronDance_giveRewardForImperfectGame:
	jumptable_memoryaddress wTmpcfc0.goronDance.danceLevel
	.dw @platinumOrGold
	.dw @platinumOrGold
	.dw @silver
	.dw @bronze

@platinumOrGold:
	giveitem TREASURE_GASHA_SEED, $00
	retscript
@silver:
	asm15 scriptHelp.giveRupees, RUPEEVAL_050
	showtext TX_0006
	retscript
@bronze:
	asm15 scriptHelp.giveRupees, RUPEEVAL_030
	showtext TX_0005
	retscript


goronDance_giveRewardForPerfectGame:
	jumptable_memoryaddress wTmpcfc0.goronDance.danceLevel
	.dw @platinumOrGold
	.dw @platinumOrGold
	.dw @silver
	.dw @bronze

@platinumOrGold:
	asm15 scriptHelp.goronDance_giveRandomRingPrize
	retscript
@silver:
	giveitem TREASURE_GASHA_SEED, $00
	retscript
@bronze:
	asm15 scriptHelp.giveRupees, RUPEEVAL_100
	showtext TX_0007
	retscript


goron_subid01Script:
	initcollisions
@npcLoop:
	checkabutton
	callscript @showText
	scriptjump @npcLoop

@showText:
	jumptable_objectbyte Interaction.var03
	.dw @val00
	.dw @val01
	.dw @val02
	.dw @val03
	.dw @val04
	.dw @val05
	.dw @val06
@val00:
	asm15 scriptHelp.goron_decideTextToShow_differentForLinkedInPast, <TX_2440
	retscript
@val01:
	asm15 scriptHelp.goron_decideTextToShow_differentForLinkedInPast, <TX_2441
	retscript
@val02:
	asm15 scriptHelp.goron_decideTextToShow_differentForLinkedInPast, <TX_2442
	retscript
@val03:
	asm15 scriptHelp.goron_decideTextToShow_differentForLinkedInPast, <TX_2443
	retscript
@val04:
	asm15 scriptHelp.goron_decideTextToShow_differentForLinkedInPast, <TX_2444
	retscript
@val05:
	asm15 scriptHelp.goron_decideTextToShow_differentForLinkedInPast, <TX_2445
	retscript
@val06:
	asm15 scriptHelp.goron_decideTextToShow_differentForLinkedInPast, <TX_2446
	retscript


; Cutscene where goron appears after beating d5; the guy who digs a new tunnel.
goron_subid03Script:
	disableinput
	setcoords $58, $a8
	playsound SND_EXPLOSION

	asm15 setScreenShakeCounter, $06
	wait 20
	asm15 setScreenShakeCounter, $06
	wait 20
	asm15 setScreenShakeCounter, $06
	wait 60

	setspeed SPEED_200
	moveleft $11
	setanimation $00
	wait 30
	showtext TX_2470
	wait 30
	showtext TX_2471
	wait 30
	moveright $11
	enableinput
	scriptend


; Goron pacing back and forth, worried about elder
goron_subid04Script:
	; Delete self if beaten d5
	asm15 scriptHelp.checkEssenceObtained, $04
	jumpifmemoryset wcddb, CPU_ZFLAG, stubScript

goron_moveBackAndForth:
	asm15 scriptHelp.goron_beginWalkingLeft
	initcollisions

goron_moveBackAndForthLoop:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	asm15 scriptHelp.goron_decMovementCounter
	jumpifmemoryset wcddb, CPU_ZFLAG, @turnAround
	asm15 objectApplySpeed
	scriptjump goron_moveBackAndForthLoop

@turnAround:
	asm15 scriptHelp.goron_reverseWalkingDirection
	scriptjump goron_moveBackAndForthLoop

@pressedA:
	jumpifobjectbyteeq Interaction.subid, $0d, goron_subid0d_pressedAFromMoveBackAndForthLoop

	; Subid $04
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	asm15 scriptHelp.turnToFaceLink
	asm15 scriptHelp.goron_showTextForGoronWorriedAboutElder
	wait 30
	asm15 scriptHelp.goron_refreshWalkingAnimation
	enableinput
	scriptjump goron_moveBackAndForthLoop


goron_subid05Script_A:
	; Delete self if beaten d5
	asm15 scriptHelp.checkEssenceObtained, $04
	jumpifmemoryset wcddb, CPU_ZFLAG, stubScript
	scriptjump ++

goron_subid05Script_B:
	; Delete self if not beaten d5
	asm15 scriptHelp.checkEssenceNotObtained, $04
	jumpifmemoryset wcddb, CPU_ZFLAG, stubScript
++
	initcollisions

; Below napping code is used by other subids as well.

; Decide whether goron should be napping or not, enter appropriate loop.
goron_chooseNappingLoop:
	asm15 scriptHelp.goron_checkShouldBeNapping
	jumpifmemoryset wcddb, CPU_CFLAG, goron_beginNappingLoop
	scriptjump goron_beginNotNappingLoop


; Goron naps until Link approaches.
goron_beginNappingLoop:
	asm15 scriptHelp.goron_setAnimation, $04 ; Nap animation

goron_nappingLoop:
	asm15 scriptHelp.goron_checkShouldBeNapping
	jumpifmemoryset wcddb, CPU_CFLAG, ++
	scriptjump goron_beginNotNappingLoop
++
	wait 1
	scriptjump goron_nappingLoop


; Goron is standing up until Link walks away.
goron_beginNotNappingLoop:
	asm15 scriptHelp.goron_faceDown

goron_notNappingLoop:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	asm15 scriptHelp.goron_checkShouldBeNapping
	jumpifmemoryset wcddb, CPU_CFLAG, ++
	scriptjump goron_notNappingLoop
++
	scriptjump goron_beginNappingLoop

@pressedA:
	jumpifobjectbyteeq Interaction.subid, $07, goron_subid07_pressedAFromNappingLoop
	jumpifobjectbyteeq Interaction.subid, $08, goron_subid08_pressedAFromNappingLoop
	jumpifobjectbyteeq Interaction.subid, $0a, goron_subid0a_pressedAFromNappingLoop
	jumpifobjectbyteeq Interaction.subid, $0b, goron_subid0b_pressedAFromNappingLoop
	jumpifobjectbyteeq Interaction.subid, $0e, goron_subid0e_pressedAFromNappingLoop

	; Subid $05?
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	asm15 scriptHelp.goron_showTextForSubid05
	wait 1
	enableinput
	scriptjump goron_notNappingLoop


; Goron who's trying to break the elder out of rock (one on the left)
goron_subid06Script_A:
	; Delete self if beaten d5
	asm15 scriptHelp.checkEssenceObtained, $04
	jumpifmemoryset wcddb, CPU_ZFLAG, stubScript

	initcollisions
	jumpifglobalflagset GLOBALFLAG_SAVED_GORON_ELDER, @alreadySavedElder

@doRockPunchingAnimation:
	asm15 scriptHelp.goron_setAnimation, $08
@checkCreateRockDebris:
	jumpifobjectbyteeq Interaction.animParameter, $01, @createDebrisToLeft
	jumpifobjectbyteeq Interaction.animParameter, $02, @createDebrisToRight
@checkEvents:
	; Check bomb flower cutscene started?
	jumpifmemoryeq wTmpcfc0.goronCutscenes.elderVar_cfdd, $01, @beginBombFlowerCutscene
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	wait 1
	scriptjump @checkCreateRockDebris

@createDebrisToLeft:
	asm15 scriptHelp.goron_createRockDebrisToLeft
	scriptjump @checkEvents
@createDebrisToRight:
	asm15 scriptHelp.goron_createRockDebrisToRight
	scriptjump @checkEvents

@pressedA:
	disableinput
	asm15 scriptHelp.goron_faceDown
	writeobjectbyte Interaction.pressedAButton, $00
	showtext TX_247b
	wait 30
	enableinput
	scriptjump @doRockPunchingAnimation

@beginSavedElderLoop:
	asm15 scriptHelp.goron_faceDown

@alreadySavedElder:
	asm15 scriptHelp.checkEssenceNotObtained, $04
	jumpifmemoryset wcddb, CPU_ZFLAG, @npcLoop
	setcoords $88, $28 ; After beating d5, change position
@npcLoop:
	checkabutton
	showtext TX_247c
	scriptjump @npcLoop

@beginBombFlowerCutscene:
	asm15 scriptHelp.goron_setAnimation, $00
@waitBeforeFacingDown:
	jumpifmemoryeq wTmpcfc0.genericCutscene.state, $01, @beginSavedElderLoop
	wait 1
	scriptjump @waitBeforeFacingDown


; Goron who's trying to break the elder out of rock (one on the right)
goron_subid06Script_B:
	; Delete self if beaten d5
	asm15 scriptHelp.checkEssenceObtained, $04
	jumpifmemoryset wcddb, CPU_ZFLAG, stubScript

	initcollisions
	jumpifglobalflagset GLOBALFLAG_SAVED_GORON_ELDER, @alreadySavedElder

@doRockPunchingAnimation:
	asm15 scriptHelp.goron_setAnimation, $08
@checkCreateRockDebris:
	jumpifobjectbyteeq Interaction.animParameter, $01, @createDebrisToLeft
	jumpifobjectbyteeq Interaction.animParameter, $02, @createDebrisToRight
@checkEvents:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	asm15 scriptHelp.goron_checkLinkApproachedWithBombFlower
	jumpifmemoryset wcddb, CPU_CFLAG, @beginBombFlowerCutscene
	scriptjump @checkCreateRockDebris

@createDebrisToLeft:
	asm15 scriptHelp.goron_createRockDebrisToLeft
	scriptjump @checkEvents
@createDebrisToRight:
	asm15 scriptHelp.goron_createRockDebrisToRight
	scriptjump @checkEvents


@beginBombFlowerCutscene:
	disableinput
	asm15 scriptHelp.goron_putLinkInState08
	asm15 scriptHelp.forceLinkDirection, $03
	asm15 scriptHelp.goron_setSpeedToMoveDown

; Move down toward Link
@moveDownLoop:
	asm15 objectApplySpeed
	asm15 scriptHelp.goron_cpLinkY
	jumpifmemoryset wcddb, CPU_ZFLAG, @beginMovingRight
	scriptjump @moveDownLoop

; Move right toward Link
@beginMovingRight:
	setanimation $01
	setangle $08
@moveRightLoop:
	asm15 objectApplySpeed
	asm15 scriptHelp.goron_checkReachedLinkHorizontally
	jumpifmemoryset wcddb, CPU_ZFLAG, @script6be1
	scriptjump @moveRightLoop

; Exclamation mark, ask Link to use bomb
@script6be1:
	wait 30
	asm15 scriptHelp.createExclamationMark, 40
	wait 60
	showtext TX_247e
	wait 30
	jumpiftextoptioneq $00, @giveBomb

@insistOnBomb:
	showtext TX_247f
	wait 30
	jumpiftextoptioneq $00, @giveBomb
	scriptjump @insistOnBomb

@giveBomb:
	showtext TX_2480
	wait 30
	writeobjectbyte Interaction.speed, SPEED_100
	setanimation $03
	setangle $18

; Move back to rock
@moveLeftLoop:
	asm15 objectApplySpeed
	asm15 scriptHelp.goron_cpXTo48
	jumpifmemoryset wcddb, CPU_ZFLAG, @beginMovingUp
	scriptjump @moveLeftLoop

@beginMovingUp:
	setanimation $00
	setangle $00
@moveUpLoop:
	asm15 objectApplySpeed
	asm15 scriptHelp.goron_cpYTo60
	jumpifmemoryset wcddb, CPU_ZFLAG, @placeBomb
	scriptjump @moveUpLoop

@placeBomb:
	writememory wTmpcfc0.goronCutscenes.elderVar_cfdd, $01
	asm15 scriptHelp.goron_setAnimation, $03
	wait 20

	asm15 scriptHelp.goron_createBombFlowerSprite
	wait 50

	asm15 scriptHelp.goron_deleteTreasure
	asm15 scriptHelp.goron_createExplosionIndex, $00
	wait 22

	writeobjectbyte Interaction.var3a, $01
	writeobjectbyte Interaction.var3b, $ff
	asm15 scriptHelp.goron_initCountersForBombFlowerExplosion

@explosionLoop1:
	asm15 scriptHelp.goron_countdownToNextExplosionGroup
	asm15 scriptHelp.goron_countdownToPlayRockSoundAndShakeScreen
	asm15 scriptHelp.goron_decMovementCounter
	jumpifmemoryset wcddb, CPU_ZFLAG, @fadeToWhite
	scriptjump @explosionLoop1

@fadeToWhite:
	playsound SND_BIG_EXPLOSION
	asm15 fadeoutToWhiteWithDelay, $04

@explosionLoop2:
	asm15 scriptHelp.goron_countdownToNextExplosionGroup
	asm15 scriptHelp.goron_countdownToPlayRockSoundAndShakeScreen
	jumpifmemoryeq wPaletteThread_mode, $00, @screenFullyWhite
	wait 1
	scriptjump @explosionLoop2

@screenFullyWhite:
	wait 30
	writememory wTmpcfc0.genericCutscene.cfde, $00
	spawninteraction INTERACID_GORON_ELDER, $00, $50, $38
	writememory wTmpcfc0.genericCutscene.state, $01
	asm15 scriptHelp.goron_faceDown
	asm15 scriptHelp.goron_clearRockBarrier
	wait 10

	asm15 fadeinFromWhite
	checkpalettefadedone

	asm15 scriptHelp.goron_createFallingRockSpawner
	wait 75

	writememory wTmpcfc0.genericCutscene.cfdf, $01 ; Signal to stop falling rock spawner
	scriptjump @savedElderLoop


; Pressed A while trying to break down the rock
@pressedA:
	disableinput
	asm15 scriptHelp.goron_faceDown
	writeobjectbyte Interaction.pressedAButton, $00
	showtext TX_247d
	wait 30
	enableinput
	scriptjump @doRockPunchingAnimation


@alreadySavedElder:
	spawninteraction INTERACID_GORON_ELDER, $00, $50, $38
@savedElderLoop:
	checkabutton
	showtext TX_2481
	scriptjump @savedElderLoop



; Goron trying to break wall down to get at treasure.
; Bit 6 of room flags is set after giving the goron ember seeds/bombs.
; Bit 7 is set once he's finished breaking the wall down.
goron_subid07Script:
	initcollisions
	jumpifroomflagset $80, @brokeDownWall
	jumpifroomflagset $40, @alreadyGaveEmberSeedsAndBombs

	asm15 scriptHelp.goron_clearRefillBit
	scriptjump @doRockPunchingAnimation

@alreadyGaveEmberSeedsAndBombs:
	asm15 scriptHelp.goron_checkEnoughTimePassed
	jumpifmemoryset wcddb, CPU_ZFLAG, @justBrokeDownWall

@doRockPunchingAnimation:
	asm15 scriptHelp.goron_setAnimation, $08

@checkCreateRockDebris:
	jumpifobjectbyteeq Interaction.animParameter, $01, @createDebrisToLeft
	jumpifobjectbyteeq Interaction.animParameter, $02, @createDebrisToRight
@checkEvents:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	wait 1
	scriptjump @checkCreateRockDebris

@createDebrisToLeft:
	asm15 scriptHelp.goron_createRockDebrisToLeft
	scriptjump @checkEvents
@createDebrisToRight:
	asm15 scriptHelp.goron_createRockDebrisToRight
	scriptjump @checkEvents

@pressedA:
	disableinput
	asm15 scriptHelp.goron_faceDown
	writeobjectbyte Interaction.pressedAButton, $00
	jumpifroomflagset $40, @comeBackLaterText
	showtext TX_2472
	wait 30
	jumpiftextoptioneq $00, @tryGiveEmberSeedsAndBombs
	showtext TX_2473
	scriptjump @enableInput

@tryGiveEmberSeedsAndBombs:
	asm15 scriptHelp.goron_tryTakeEmberSeedsAndBombs
	jumpifmemoryset wcddb, $80, @gaveEmberSeedsAndBombs

	; Not enough bombs/seeds
	showtext TX_2474
	scriptjump @enableInput

@gaveEmberSeedsAndBombs:
	playsound SND_GETSEED
	showtext TX_2475
	orroomflag $40
@enableInput:
	wait 30
	enableinput
	scriptjump @doRockPunchingAnimation
@comeBackLaterText:
	showtext TX_2476
	scriptjump @enableInput


@justBrokeDownWall:
	orroomflag $80
@brokeDownWall:
	setcoords $38, $58
	scriptjump goron_beginNappingLoop


goron_subid07_pressedAFromNappingLoop:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	jumpifroomflagset ROOMFLAG_ITEM, @alreadyGotItem
	jumpifmemoryeq wTmpcfc0.genericCutscene.state, $01, @alreadyGotItem

; Ask Link which chest he wants
	setspeed SPEED_100
	showtext TX_2477
	wait 30
	jumpiftextoptioneq $00, @leftChest
	
; Right chest
	asm15 scriptHelp.goron_setAnimation, $00
	setangle $00
	applyspeed $11
	asm15 scriptHelp.goron_setAnimation, $03
	setanimation $03
	setangle $18
	scriptjump @moveBack

@leftChest:
	asm15 scriptHelp.goron_setAnimation, $00
	setangle $00
	applyspeed $11
	asm15 scriptHelp.goron_setAnimation, $01
	setanimation $01
	setangle $08

@moveBack:
	applyspeed $11
	writememory wTmpcfc0.genericCutscene.state, $01
	enableinput
	scriptjump goron_beginNotNappingLoop

@alreadyGotItem:
	showtext TX_2478
	wait 30
	enableinput
	scriptjump goron_notNappingLoop


; Goron guarding the staircase until you get brother's emblem (both eras)
goron_subid08Script:
	initcollisions
	jumpifroomflagset $80, @moved
	scriptjump goron_beginNappingLoop
@moved:
	setcoords $58, $78
	scriptjump goron_beginNappingLoop

goron_subid08_pressedAFromNappingLoop:
	loadscript scriptHelp.goron_subid08_pressedAScript


; Goron running target carts (guy on the left)
goron_subid09Script_A:
	initcollisions
@npcLoop:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	jumpifmemoryeq wTmpcfc0.targetCarts.beginGameTrigger, $01, @beginGame
	wait 1
	scriptjump @npcLoop

@pressedA:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00

	; Ask to play the game
	showtext TX_24a8
	wait 30
	jumpiftextoptioneq $00, @beginGame
	showtext TX_24a9
	enableinput
	scriptjump @npcLoop

@beginGame:
	asm15 scriptHelp.shootingGallery_checkLinkHasRupees, RUPEEVAL_10
	jumpifmemoryset wcddb, CPU_ZFLAG, @enoughRupees

@notEnoughRupeesLoop:
	showtext TX_24aa
	enableinput
	checkabutton
	scriptjump @notEnoughRupeesLoop

@enoughRupees:
	asm15 removeRupeeValue, RUPEEVAL_10
	showtext TX_24ab
	wait 30
	showtext TX_24ac
	wait 30
	asm15 scriptHelp.goron_targetCarts_spawnPrize
	wait 90

	asm15 fadeoutToWhite
	checkpalettefadedone

	asm15 scriptHelp.goron_targetCarts_deleteCrystals
	asm15 scriptHelp.goron_deleteTreasure
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 scriptHelp.goron_targetCarts_setLinkPositionToCartPlatform
	asm15 scriptHelp.goron_targetCarts_configureInventory

	spawninteraction INTERACID_MINECART, $00, $78, $38
	wait 20

	asm15 scriptHelp.goron_targetCarts_loadCrystals
	wait 20

	asm15 fadeinFromWhite
	checkpalettefadedone
	wait 40

	setmusic MUS_MINIGAME
	showtext TX_24ad
	wait 30

	asm15 scriptHelp.goron_targetCarts_beginGame
	enableallobjects
	scriptjump @npcLoop


; Goron running target carts (guy on the right)
goron_subid09Script_B:
	initcollisions
	jumpifroomflagset $80, @endingGame

@npcLoop:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	wait 1
	scriptjump @npcLoop
@pressedA:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	showtext TX_24ae
	enableinput
	scriptjump @npcLoop


@endingGame:
	; Wait for Link to jump out of cart
	asm15 scriptHelp.goron_checkLinkNotInAir
	jumpifmemoryset wcddb, CPU_ZFLAG, ++
	scriptjump @linkInAir
++
	wait 1
	scriptjump @endingGame

@linkInAir:
	; Waitfor Link to land on the ground
	asm15 scriptHelp.goron_checkLinkNotInAir
	jumpifmemoryset wcddb, CPU_ZFLAG, @linkLanded
	scriptjump @linkInAir

@linkLanded:
	disableinput
	asm15 scriptHelp.setLinkToState08AndSetDirection, DIR_LEFT
	writememory wShopHaveEnoughRupees, $01
	wait 40

	asm15 scriptHelp.goron_targetCarts_endGame
	asm15 scriptHelp.goron_targetCarts_setupNumTargetsHitText
	showtext TX_24af

	wait 30
	asm15 fadeoutToWhite
	checkpalettefadedone

	asm15 clearAllItemsAndPutLinkOnGround
	asm15 scriptHelp.goron_targetCarts_setLinkPositionAfterGame
	asm15 scriptHelp.goron_targetCarts_restoreInventory
	asm15 scriptHelp.goron_targetCarts_deleteMinecartAndClearStaticObjects
	wait 40

	asm15 fadeinFromWhite
	checkpalettefadedone

	resetmusic
	wait 40

	asm15 scriptHelp.goron_targetCarts_checkHitAllTargets
	jumpifmemoryset wcddb, CPU_ZFLAG, @hitAllTargets
	asm15 scriptHelp.goron_targetCarts_checkHit9OrMoreTargets
	jumpifmemoryset wcddb, CPU_CFLAG, @hit9OrMoreTargets
	showtext TX_24b2
	wait 30
	scriptjump @askToTryAgain

@hitAllTargets:
	showtext TX_24b0
	wait 30
	callscript @givePrize
	wait 30
	scriptjump @askToTryAgain

@givePrize:
	jumptable_memoryaddress wTmpcfc0.targetCarts.prizeIndex
	.dw @rockBrisket
	.dw @fiftyRupees
	.dw @hundredRupees
	.dw @gashaSeed
	.dw @boomerang

@rockBrisket:
	giveitem TREASURE_ROCK_BRISKET, $00
	retscript
@fiftyRupees:
	asm15 scriptHelp.giveRupees, RUPEEVAL_050
	showtext TX_0006
	retscript
@hundredRupees:
	asm15 scriptHelp.giveRupees, RUPEEVAL_100
	showtext TX_0007
	retscript
@gashaSeed:
	giveitem TREASURE_GASHA_SEED, $00
	retscript
@boomerang:
	giveitem TREASURE_BOOMERANG, $02
	retscript

; Pity prize
@hit9OrMoreTargets:
	showtext TX_24b1
	asm15 scriptHelp.giveRupees, RUPEEVAL_20
	showtext TX_0004
	wait 30

@askToTryAgain:
	showtext TX_24b3
	wait 30
	jumpiftextoptioneq $00, @selectedYes
	scriptjump @selectedNo
@selectedNo:
	showtext TX_24b4
	enableinput
	scriptjump @npcLoop
@selectedYes:
	writememory wTmpcfc0.targetCarts.beginGameTrigger, $01
	scriptjump @npcLoop


; Goron who gives you letter of introduction
goron_subid0aScript:
	initcollisions
	scriptjump goron_beginNappingLoop

goron_subid0a_pressedAFromNappingLoop:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	jumpifobjectbyteeq Interaction.var3c, $01, @justGaveIntroduction

	showtext TX_24c4
	wait 30

	jumpifroomflagset $40, @alreadyGaveIntroduction
	asm15 scriptHelp.goron_checkGracefulGoronQuestStatus
	jumptable_objectbyte Interaction.var3e
	.dw @haveLavaJuiceAndMermaidKey
	.dw @noMermaidKey
	.dw @noLavaJuice

@haveLavaJuiceAndMermaidKey:
	showtext TX_24c6
	wait 30
	showtext TX_24c7
	wait 30
	showtext TX_24c8
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

	; Rejected trade of juice for letter
	showtext TX_24cb
	scriptjump goron_enableInputAndResumeNappingLoop

@acceptedTrade:
	asm15 loseTreasure, $5a
	showtext TX_24c9
	giveitem TREASURE_GORON_LETTER, $00
	orroomflag $40
	showtext TX_24ca
	writeobjectbyte Interaction.var3c, $01
	scriptjump goron_enableInputAndResumeNappingLoop

@noMermaidKey:
	showtext TX_24cd
	scriptjump goron_enableInputAndResumeNappingLoop

@noLavaJuice:
	showtext TX_24ce
	scriptjump goron_enableInputAndResumeNappingLoop

@justGaveIntroduction:
	showtext TX_24cc
	scriptjump goron_enableInputAndResumeNappingLoop

@alreadyGaveIntroduction:
	showtext TX_24c5
	; Fall through

goron_enableInputAndResumeNappingLoop:
	enableinput
	scriptjump goron_chooseNappingLoop


; Goron running the big bang game
goron_subid0bScript:
	initcollisions
	scriptjump goron_beginNappingLoop

goron_subid0b_pressedAFromNappingLoop:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	jumpifroomflagset $40, @alreadyGaveGoronade

	showtext TX_24b5
	wait 30
	jumpifitemobtained TREASURE_GORONADE, @promptToGiveGoronade

	showtext TX_24b6
	scriptjump goron_enableInputAndResumeNappingLoop

@promptToGiveGoronade:
	showtext TX_24b7
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

	; Rejected trade
	showtext TX_24b8
	scriptjump goron_enableInputAndResumeNappingLoop

@acceptedTrade:
	asm15 loseTreasure, TREASURE_GORONADE
	orroomflag $40

	; Ask to begin game
	showtext TX_24b9
	wait 30
	jumpiftextoptioneq $00, @promptToExplain

	; Don't begin game
	showtext TX_24ba
	scriptjump goron_enableInputAndResumeNappingLoop


@alreadyGaveGoronade:
	showtext TX_24bf
	wait 30
	jumpiftextoptioneq $00, @takeRupees
@selectedNo:
	showtext TX_24c0
	scriptjump goron_enableInputAndResumeNappingLoop


@takeRupees:
	asm15 scriptHelp.shootingGallery_checkLinkHasRupees, RUPEEVAL_10
	jumpifmemoryset wcddb, CPU_ZFLAG, @enoughRupees

@notEnoughRupees:
	showtext TX_24c1
	scriptjump goron_enableInputAndResumeNappingLoop

@enoughRupees:
	asm15 removeRupeeValue, RUPEEVAL_10


@promptToExplain:
	showtext TX_24bb
	wait 30
	jumpiftextoptioneq $00, @beginGame

@giveExplanation:
	showtext TX_24bd
	wait 30
	jumpiftextoptioneq $00, @beginGame
	scriptjump @giveExplanation

@beginGame:
	showtext TX_24bc
	wait 30
	asm15 scriptHelp.goron_bigBang_spawnPrize
	wait 60

	showtext TX_24be
	wait 30
	asm15 fadeoutToWhite
	checkpalettefadedone

	asm15 scriptHelp.goron_bigBang_hideSelf
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 scriptHelp.goron_bigBang_initLinkPosition
	asm15 scriptHelp.goron_deleteTreasure
	asm15 scriptHelp.goron_bigBang_blockOrRestoreExit, $04

	wait 8
	callscript goron_bigBang_loadMinigameLayout
	wait 24
	asm15 fadeinFromWhite
	checkpalettefadedone

	setmusic MUS_MINIGAME
	wait 40
	playsound SND_WHISTLE
	wait 60

	writememory wTmpcfc0.bigBangGame.gameStatus, $00
	asm15 scriptHelp.goron_bigBang_createBombSpawner
	enableinput

@waitForGameToFinish:
	jumpifmemoryeq wTmpcfc0.bigBangGame.gameStatus, $01, @wonGame
	asm15 scriptHelp.goron_bigBang_checkLinkHitByBomb
	jumpifmemoryset wcddb, CPU_ZFLAG, @hitByBomb
	scriptjump @waitForGameToFinish

@hitByBomb:
	; Link was hit by a bomb; wait for him to land.
	asm15 scriptHelp.goron_checkLinkInAir
	jumpifmemoryset wcddb, CPU_ZFLAG, @lostGame
	scriptjump @hitByBomb

@lostGame:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	playsound SND_LINK_FALL

	asm15 scriptHelp.setLinkToState08AndSetDirection, DIR_DOWN
	wait 2
	writememory wcc50, LINK_ANIM_MODE_COLLAPSED
	wait 80

	showtext TX_24e1
	callscript goron_bigBang_loadNormalRoomLayout
	scriptjump @askToPlayAgain

@wonGame:
	; Wait for Link to land on ground
	asm15 scriptHelp.goron_checkLinkInAir
	jumpifmemoryset wcddb, $80, ++
	scriptjump @wonGame
++
	disableinput
	playsound SND_WHISTLE
	writeobjectbyte Interaction.pressedAButton, $00
	wait 60

	asm15 scriptHelp.setLinkToState08AndSetDirection, DIR_DOWN
	wait 2
	playsound SND_SWORD_OBTAINED

	writememory wcc50, LINK_ANIM_MODE_DANCELEFT
	wait 60

	showtext TX_24e0
	callscript goron_bigBang_loadNormalRoomLayout

	showtext TX_24c3
	wait 30
	callscript goron_bigBang_givePrize
	wait 30

@askToPlayAgain:
	showtext TX_24c2
	wait 30
	jumpiftextoptioneq $00, @selectedYes
	scriptjump @selectedNo

@selectedYes:
	asm15 scriptHelp.shootingGallery_checkLinkHasRupees, RUPEEVAL_10
	jumpifmemoryset wcddb, CPU_ZFLAG, @takeRupees_2
	scriptjump @notEnoughRupees

@takeRupees_2:
	asm15 removeRupeeValue, RUPEEVAL_10
	scriptjump @beginGame


goron_bigBang_loadNormalRoomLayout:
	wait 30
	asm15 fadeoutToWhite
	checkpalettefadedone

	asm15 scriptHelp.goron_bigBang_unhideSelf
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 scriptHelp.goron_bigBang_initLinkPosition
	asm15 clearParts

	asm15 scriptHelp.goron_bigBang_blockOrRestoreExit, $00
	wait 8
	asm15 scriptHelp.goron_bigBang_loadNormalRoomLayout_topHalf
	wait 8
	asm15 scriptHelp.goron_bigBang_loadNormalRoomLayout_bottomHalf
	wait 24

	asm15 fadeinFromWhite
	checkpalettefadedone

	resetmusic
	wait 40
	retscript


goron_bigBang_loadMinigameLayout:
	getrandombits Interaction.var3d, $01
	jumpifobjectbyteeq Interaction.var3d, $01, @layout2

@layout1:
	asm15 scriptHelp.goron_bigBang_loadMinigameLayout1_topHalf
	wait 8
	asm15 scriptHelp.goron_bigBang_loadMinigameLayout1_bottomHalf
	retscript

@layout2:
	asm15 scriptHelp.goron_bigBang_loadMinigameLayout2_topHalf
	wait 8
	asm15 scriptHelp.goron_bigBang_loadMinigameLayout2_bottomHalf
	retscript

goron_bigBang_givePrize:
	jumptable_memoryaddress wTmpcfc0.bigBangGame.prizeIndex
	.dw @mermaidKey
	.dw @hundredRupees
	.dw @thirtyRupees
	.dw @gashaSeed
	.dw @tossRing
	.dw @quicksandRing

@mermaidKey:
	giveitem TREASURE_OLD_MERMAID_KEY, $00
	retscript

@hundredRupees:
	asm15 scriptHelp.giveRupees, RUPEEVAL_100
	showtext TX_0007
	retscript

@thirtyRupees:
	asm15 scriptHelp.giveRupees, RUPEEVAL_30
	showtext TX_0005
	retscript

@gashaSeed:
	giveitem TREASURE_GASHA_SEED, $00
	retscript

@tossRing:
	giveitem TREASURE_RING, $14
	retscript

@quicksandRing:
	giveitem TREASURE_RING, $15
	retscript


; Generic npc; text changes based on game state.
goron_subid0cScript:
	asm15 scriptHelp.goron_determineTextForGenericNpc
	jumpifobjectbyteeq Interaction.textID, $ff, stubScript
	initcollisions
@npcLoop:
	checkabutton
	showloadedtext
	scriptjump @npcLoop


; Generic npc like subid $0c, but moving left and right.
goron_subid0dScript:
	asm15 scriptHelp.goron_determineTextForGenericNpc
	jumpifobjectbyteeq Interaction.textID, $ff, stubScript
	scriptjump goron_moveBackAndForth

goron_subid0d_pressedAFromMoveBackAndForthLoop:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	asm15 scriptHelp.turnToFaceLink
	showloadedtext
	asm15 scriptHelp.goron_refreshWalkingAnimation
	enableinput
	scriptjump goron_moveBackAndForthLoop


; Generic npc like subid $0c, but naps when Link isn't near.
goron_subid0eScript:
	asm15 scriptHelp.goron_determineTextForGenericNpc
	jumpifobjectbyteeq Interaction.textID, $ff, stubScript
	initcollisions
	scriptjump goron_beginNappingLoop

goron_subid0e_pressedAFromNappingLoop:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	showloadedtext
	enableinput
	scriptjump goron_notNappingLoop


; Clairvoyant goron who gives you tips (doesn't exist in JP version)
; TODO: Wrap the label in an ifdef for JP region
goron_subid10Script:
.ifndef REGION_JP
	initcollisions
	writeobjectbyte Interaction.oamFlags, $00
@npcLoop:
	checkabutton
	disableinput
	asm15 scriptHelp.goron_showTextForClairvoyantGoron
	wait 1
	enableinput
	scriptjump @npcLoop
.endif


; ==============================================================================
; INTERACID_ROSA
; ==============================================================================

; Gives you the shovel on tokay island, linked only
rosa_subid00Script:
	initcollisions
	checkabutton
	disableinput
	asm15 scriptHelp.turnToFaceLink
	showtextlowindex <TX_1c10
	wait 30

	setspeed SPEED_020
	moveright $30
	wait 20

	writeobjectbyte Interaction.var3e, $09
	wait 20

	writeobjectbyte Interaction.var3e, $f7     ; Relative position of shovel
	writeobjectbyte Interaction.direction, $01 ; Signal for shovel to change draw priority
	setanimation DIR_LEFT
	wait 30

	showtextlowindex <TX_1c11
	wait 30

	writeobjectbyte Interaction.var3e, $ff ; Signal for shovel to delete itself
	giveitem TREASURE_SHOVEL, $01
	wait 30

	orroomflag $40
	enableinput
	scriptjump rosa_subid00Script_alreadyGaveShovel@npcLoop

rosa_subid00Script_alreadyGaveShovel:
	initcollisions
@npcLoop:
	checkabutton
	showtextlowindex <TX_1c12
	scriptjump @npcLoop


; Rosa at goron dance, linked only
rosa_subid01Script:
	asm15 scriptHelp.checkIsLinkedGameForScript
	jumpifmemoryset wcddb, CPU_ZFLAG, stubScript
	rungenericnpclowindex <TX_1c13


; ==============================================================================
; INTERACID_RAFTON
; ==============================================================================

; Rafton in left part of house
rafton_subid00Script:
	initcollisions
	jumptable_objectbyte Interaction.var38
	.dw @behaviour_befored2
	.dw @behaviour_afterd2
	.dw @behaviour_afterGotChevalRope
	.dw @behaviour_afterGaveChevalRope
	.dw @behaviour_afterGotIslandChart

@behaviour_befored2:
	settextid TX_2700

@genericNpcLoop:
	checkabutton
	asm15 scriptHelp.turnToFaceLink

@showLoadedTextInGenericNpcLoop:
	showloadedtext
	enableinput
	setanimation DIR_DOWN
	scriptjump @genericNpcLoop


@behaviour_afterd2:
	checkabutton

	callscript @faceLinkAndFreezeAnimation
	showtextlowindex <TX_2700
	wait 20

	settextid TX_2701
	scriptjump @showLoadedTextInGenericNpcLoop


@behaviour_afterGotChevalRope:
	checkabutton

	callscript @faceLinkAndFreezeAnimation
	wait 20

	asm15 scriptHelp.createExclamationMark, 60
	wait 30

	showtextlowindex <TX_2702
	wait 30

@askToGiveRope:
	showtextlowindex <TX_2703
	jumpiftextoptioneq $00, @giveRopeToRafton

	; Refused request
	wait 20
	showtextlowindex <TX_2704
	enableinput
	setanimation DIR_DOWN
	checkabutton

	callscript @faceLinkAndFreezeAnimation
	scriptjump @askToGiveRope

@giveRopeToRafton:
	asm15 loseTreasure, TREASURE_CHEVAL_ROPE
	wait 20
	showtextlowindex <TX_2705
	wait 20
	setglobalflag GLOBALFLAG_GAVE_ROPE_TO_RAFTON
	enableinput


@behaviour_afterGaveChevalRope:
	settextid TX_2706
	scriptjump @genericNpcLoop


@behaviour_afterGotIslandChart:
	disableinput
	wait 100

	writeobjectbyte Interaction.animCounter, $7f
	showtextlowindex <TX_2707
	wait 30

	setspeed SPEED_100
	moveright $40

	setglobalflag GLOBALFLAG_RAFTON_CHANGED_ROOMS
	enableinput
	scriptend


@faceLinkAndFreezeAnimation:
	disableinput
	asm15 scriptHelp.turnToFaceLink
	writeobjectbyte Interaction.animCounter, $7f
	retscript


rafton_subid01Script:
	loadscript scriptHelp.rafton_subid01Script


; ==============================================================================
; INTERACID_CHEVAL
; ==============================================================================
cheval_subid00Script:
	initcollisions
	setcollisionradii $0c, $06
	jumpifitemobtained TREASURE_CHEVAL_ROPE, @gotChevalRope

@dontHaveChevalRope:
	checkabutton
	showtextlowindex <TX_270c
	asm15 scriptHelp.cheval_setTalkedGlobalflag
	scriptjump @dontHaveChevalRope

@gotChevalRope:
	checkabutton
	showtextlowindex <TX_270d
	asm15 scriptHelp.cheval_setTalkedGlobalflag
	scriptjump @gotChevalRope


; ==============================================================================
; INTERACID_MISCELLANEOUS_1
; ==============================================================================

; Unused?
script71a3:
	scriptend


; Script for cutscene with Ralph outside Ambi's palace, before getting mystery seeds
interaction6b_subid02Script:
	jumpifroomflagset $40, interaction6b_stubScript

	asm15 scriptHelp.interaction6b_checkGotBombsFromAmbi
	jumpifmemoryset wcddb, CPU_ZFLAG, interaction6b_stubScript

	setcollisionradii $04, $18
	checkcollidedwithlink_ignorez

	disableinput
	asm15 scriptHelp.setLinkToState08
	wait 40

	spawninteraction INTERACID_RALPH, $01, $50, $b0
	checkmemoryeq wTmpcfc0.genericCutscene.state, $01
	wait 40

	orroomflag $40
	enableinput


interaction6b_stubScript:
	scriptend


interaction6b_subid04Script:
	loadscript scriptHelp.interaction6b_subid04Script


; Cutscene in intro where lightning strikes a guy
interaction6b_subid05Script:
	asm15 restartSound
	wait 120
	playsound MUS_DISASTER
	writeobjectbyte Interaction.var38, $04

@darkenAndBrightenLoop:
	asm15 darkenRoom
	checkpalettefadedone
	wait 8
	asm15 brightenRoom
	checkpalettefadedone
	wait 8

	addobjectbyte Interaction.var38, -1
	jumpifobjectbyteeq Interaction.var38, $00, ++
	scriptjump @darkenAndBrightenLoop
++
	wait 30
	writememory wTmpcfc0.introCutscene.cfd1, $02
	wait 90
	writeobjectbyte Interaction.var38, $0a

@fastDarkenAndBrightenLoop:
	asm15 darkenRoomWithSpeed, $04
	checkpalettefadedone
	wait 4
	asm15 brightenRoomWithSpeed, $04
	checkpalettefadedone
	wait 4
	addobjectbyte Interaction.var38, -1
	jumpifobjectbyteeq Interaction.var38, $00, ++
	scriptjump @fastDarkenAndBrightenLoop
++
	asm15 darkenRoomWithSpeed, $02
	checkpalettefadedone
	scriptend


; Actually subids $0a-$0c
interaction6b_subid0aScript:
	setcollisionradii $02, $02
@waitForLinkToGrab:
	asm15 scriptHelp.interaction6b_checkLinkCanCollect
	wait 1
	jumpifobjectbyteeq Interaction.var38, $00, @waitForLinkToGrab
	disableinput
	asm15 objectSetInvisible
	writeobjectbyte Interaction.substate, $01
	jumptable_objectbyte Interaction.var03
	.dw @bombs
	.dw @chevalRope
	.dw @flippers

@bombs:
	asm15 scriptHelp.interaction6b_refillBombs
	giveitem TREASURE_BOMBS, $04
	wait 30
	scriptend

@chevalRope:
	giveitem TREASURE_CHEVAL_ROPE, $00
	writememory wRememberedCompanionId, $00
	wait 30
	scriptend

@flippers:
	giveitem TREASURE_FLIPPERS, $00
	wait 30
	scriptend


; Cutscene where the bridge to Nuun highlands extends out.
; This uses an alternate "scripting language", which only contains one additional opcode
; for "interleaved" tiles...
interaction6b_bridgeToNuunSimpleScript:
	ss_settile $68, $9e
	ss_wait 40

	ss_playsound SND_DOORCLOSE
	ss_setinterleavedtile $43, $fa, $1d, $3
	ss_setinterleavedtile $45, $fa, $1d, $1
	ss_setinterleavedtile $53, $f4, $1e, $3
	ss_setinterleavedtile $55, $f4, $1e, $1
	ss_wait 40

	ss_playsound SND_DOORCLOSE
	ss_settile $43, $1d
	ss_settile $45, $1d
	ss_settile $53, $1e
	ss_settile $55, $1e
	ss_wait 40

	ss_playsound SND_DOORCLOSE
	ss_settile $44, $1d
	ss_settile $54, $1e
	ss_wait 40
	ss_playsound SND_SOLVEPUZZLE
	ss_end


; Unfinished stone statue of Link in credits cutscene
interaction6b_subid10Script:
	checkmemoryeq wTmpcfc0.genericCutscene.state, $01

	setanimation $04
	checkmemoryeq wTmpcfc0.genericCutscene.state, $03

	wait 60
	writememory   wTmpcfc0.genericCutscene.state, $04
	setspeed SPEED_040
	setangle $10
	scriptend


; ==============================================================================
; INTERACID_FAIRY_HIDING_MINIGAME
; ==============================================================================
fairyHidingMinigame_subid00Script:
	loadscript scriptHelp.fairyHidingMinigame_subid00Script

fairyHidingMinigame_subid01Script:
	loadscript scriptHelp.fairyHidingMinigame_subid01Script

fairyHidingMinigame_subid02Script:
	loadscript scriptHelp.fairyHidingMinigame_subid02Script


; ==============================================================================
; INTERACID_POSSESSED_NAYRU
; ==============================================================================
possessedNayru_beginFightScript:
	asm15 scriptHelp.possessedNayru_makeExclamationMark
	wait 30

	setanimation $03
	wait 16
	setanimation $02
	wait 16

	showtext TX_5608
	asm15 scriptHelp.possessedNayru_moveLinkForward
	wait 12

	showtext TX_5609
	wait 8

	writeobjectbyte   Interaction.var37, $01 ; Signal for ghost to appear
	checkobjectbyteeq Interaction.var37, $00
	scriptend

; Ghost taunting Link just before fight starts
possessedNayru_veranGhostScript:
	asm15 playSound, SND_POOF
	applyspeed $1e
	wait 30

	showtext TX_560a
	wait 15

	writeobjectbyte Interaction.angle, ANGLE_DOWN
	applyspeed $14
	wait 8
	scriptend


; ==============================================================================
; INTERACID_NAYRU_SAVED_CUTSCENE
; ==============================================================================

; Nayru waking up after being freed from possession
interaction6e_subid00Script:
	wait 30
	spawninteraction INTERACID_NAYRU_SAVED_CUTSCENE, $01, $b0, $78
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $02
	wait 30

	setanimation $02
	showtext TX_1d04

	writememory   wTmpcfc0.genericCutscene.cfd0, $01
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $02
	wait 60

	applyspeed $1e
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $06

	setanimation $03
	wait 8
	showtext TX_1d05
	wait 30
	writememory   wTmpcfc0.genericCutscene.cfd0, $01
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $02

	setanimation $02
	wait 60

	setanimation $0b
	asm15 scriptHelp.nayruSavedCutscene_createEnergySwirl
	wait 60
	scriptend


; Queen Ambi (before being possessed)
interaction6e_subid01Script_part1:
	wait 30
	showtext TX_1308

	asm15 playSound, MUS_SADNESS
	setanimation $04
	applyspeed $30

	writememory   wTmpcfc0.genericCutscene.cfd0, $02
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $01
	asm15 scriptHelp.nayruSavedCutscene_setSpeedZIndex, $00
	wait 20

	showtext TX_1309
	writememory   wTmpcfc0.genericCutscene.cfd0, $02
	spawninteraction INTERACID_NAYRU_SAVED_CUTSCENE, $02, $00, $34 ; Spawn ghost veran
	scriptend


; Queen Ambi (after being possessed)
interaction6e_subid01Script_part2:
	wait 60
	setanimation $04
	wait 30

	showtext TX_560d
	writememory wTmpcfc0.genericCutscene.cfd0, $02
	wait 15

	asm15 scriptHelp.nayruSavedCutscene_spawnGuardIndex, $00
	asm15 scriptHelp.nayruSavedCutscene_spawnGuardIndex, $01
	asm15 scriptHelp.nayruSavedCutscene_spawnGuardIndex, $02
	asm15 scriptHelp.nayruSavedCutscene_spawnGuardIndex, $03
	asm15 scriptHelp.nayruSavedCutscene_spawnGuardIndex, $04
	asm15 scriptHelp.nayruSavedCutscene_spawnGuardIndex, $05

	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $08
	wait 30

	spawninteraction INTERACID_NAYRU_SAVED_CUTSCENE, $03, $b0, $78 ; Spawn ralph

	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $03
	setanimation $06
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $04
	setanimation $07
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $05
	setanimation $04

	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $01
	wait 30

	writememory w1Link.direction, DIR_DOWN

	asm15 scriptHelp.nayruSavedCutscene_setSpeedZIndex, $01
	wait 1
	asm15 scriptHelp.nayruSavedCutscene_setSpeedZIndex, $01
	wait 15

	showtext TX_130a
	wait 15
	writememory wTmpcfc0.genericCutscene.cfd0, $02

interaction6e_waitForever:
	wait 240
	scriptjump interaction6e_waitForever


; Ralph
interaction6e_subid03Script:
	showtext TX_2a0c

	writememory wTmpcfc0.genericCutscene.cfd0, $03
	setanimation $10
	applyspeed $10

	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $00
	applyspeed $08

	writememory wTmpcfc0.genericCutscene.cfd0, $04
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $01
	applyspeed $13

	writememory w1Link.direction, DIR_LEFT
	writememory wTmpcfc0.genericCutscene.cfd0, $05
	applyspeed $10

	setanimation $11
	writememory w1Link.direction, DIR_UP
	wait 16

	writememory wTmpcfc0.genericCutscene.cfd0, $06
	wait 2

	showtext TX_2a0d
	scriptjump interaction6e_waitForever


; Guards that run into the room
interaction6e_guard0Script:
	applyspeed $10
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $04
	applyspeed $20
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $02
	applyspeed $42
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $03
	applyspeed $15
	setanimation $0e

interaction6e_guardCommon:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $03

	setanimation $0e
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $04

	asm15 scriptHelp.nayruSavedCutscene_loadGuardAnimation
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $05

	asm15 scriptHelp.nayruSavedCutscene_loadGuardAngleToMoveTowardCenter
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $01
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $02

@moveForward:
	applyspeed $08
	wait 30
	scriptjump @moveForward


interaction6e_guard1Script:
	wait 45
	applyspeed $10
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $03
	applyspeed $20
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $02
	applyspeed $42
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $04
	applyspeed $15
	setanimation $0e
	scriptjump interaction6e_guardCommon

interaction6e_guard2Script:
	wait 90
	applyspeed $10
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $04
	applyspeed $20
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $02
	applyspeed $23
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $03
	applyspeed $0a
	scriptjump interaction6e_guardCommon

interaction6e_guard3Script:
	wait 135
	applyspeed $10
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $03
	applyspeed $20
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $02
	applyspeed $23
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $04
	applyspeed $0a
	scriptjump interaction6e_guardCommon

interaction6e_guard4Script:
	wait 180
	applyspeed $10
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $04
	applyspeed $12
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $02
	applyspeed $0f
	scriptjump interaction6e_guardCommon

interaction6e_guard5Script:
	wait 225
	applyspeed $10
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $03
	applyspeed $12
	asm15 scriptHelp.nayruSavedCutscene_loadAngleAndAnimationPreset, $02
	applyspeed $0f
	writememory wTmpcfc0.genericCutscene.cfd0, $08
	scriptjump interaction6e_guardCommon


; ==============================================================================
; INTERACID_COMPANION_SCRIPTS
; ==============================================================================

; Moosh script while being attacked by ghosts
companionScript_subid00Script:

@wait1:
	jumpifmemoryset w1Companion.var3e, $02, ++
	scriptjump @wait1
++
	writeobjectbyte Interaction.var3a, 60
	callscript @delayFrames
	showtext TX_2200
	ormemory w1Companion.var3e, $04

@wait2:
	jumpifmemoryset w1Companion.var3e, $10, ++
	scriptjump @wait2
++
	checkmemoryeq wNumEnemies, $00

	playsound SND_DING
	wait 20
	playsound SND_DING
	wait 20
	playsound SND_DING

	asm15 scriptHelp.companionScript_restoreMusic
	writememory   w1Companion.var03, $02
	checkmemoryeq w1Companion.var3d, $01

	writeobjectbyte Interaction.var3a, 60
	callscript @delayFrames
	showtext TX_2201

	writememory w1Companion.var03, $03
	asm15 scriptHelp.companionScript_makeExclamationMark
	setdisabledobjectsto11
	asm15 scriptHelp.companionScript_writeAngleTowardLinkToCompanionVar3f
	wait 60

	jumpifmemoryeq wIsLinkedGame, $00, @meetingMooshFirstTime
	jumpifmemoryeq wAnimalCompanion, SPECIALOBJECTID_MOOSH, @meetingMooshAgain
	scriptjump @meetingMooshFirstTime

@meetingMooshAgain:
	showtext TX_2204
	scriptjump ++

@meetingMooshFirstTime:
	showtext TX_2203
++
	ormemory wMooshState, $20
	enableallobjects
	checkmemoryeq wLinkObjectIndex, >w1Companion

	showtext TX_2205
	writememory wDisableScreenTransitions, $00
	enablemenu
	scriptend

@delayFrames:
	jumpifobjectbyteeq Interaction.var3a, $00, ++
	wait 1
	scriptjump @delayFrames
++
	retscript

companionScript_subid03Script:
	loadscript scriptHelp.companionScript_subid03Script_body

companionScript_subid07Script:
	loadscript scriptHelp.companionScript_subid07Script_body


; Dimitri script where he leaves Link after bringing him to the mainland
companionScript_subid06Script:
	checkmemoryeq wLinkObjectIndex, >w1Link
	checkmemoryeq wLinkInAir, $00 ; Wait for Link to dismount

	writememory wUseSimulatedInput, $00
	disablemenu
	setdisabledobjectsto11
	turntofacelink
	showtext TX_2104

	; Dimitri state $0a, with var03 = $03, triggers his "leaving" cutscene
	writememory w1Companion.var03, $03

.ifdef ENABLE_US_BUGFIXES
	; This looks like it's supposed to be part of the bugfix for the softlock caused by screen
	; transitioning after dismounting Dimitri. But this line of code runs too early, rendering
	; that fix useless?
	writememory wDisableScreenTransitions, $00
.endif
	scriptend

companionScript_subid08Script:
	loadscript scriptHelp.companionScript_subid08Script_body

companionScript_subid09Script:
	loadscript scriptHelp.companionScript_subid09Script_body

companionScript_subid0aScript:
	loadscript scriptHelp.companionScript_subid0aScript_body

companionScript_subid0bScript:
	loadscript scriptHelp.companionScript_subid0bScript_body


; ==============================================================================
; INTERACID_KING_MOBLIN_DEFEATED
; ==============================================================================

; Subid 0: King moblin / "parent" for other subids
kingMoblinDefeated_kingScript:
	wait 70
	showtext TX_2f1b
	wait 1
	writememory wTmpcfc0.genericCutscene.cfd0, $01
	setanimation $00
kingMoblinMoveDown:
	applyspeed $40
	scriptend

; Subid 1: Normal moblin following him
kingMoblinDefeated_helperMoblinScript:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $01
	setanimation $02
	scriptjump kingMoblinMoveDown

; Subid 2: Gorons who approach afterward
kingMoblinDefeated_goron0:
	wait 30
	applyspeed $10
	wait 20
	setspeed SPEED_100
	applyspeed $18
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $02
	asm15 scriptHelp.kingMoblinDefeated_setGoronDirection, $02
	applyspeed $30
	scriptend

kingMoblinDefeated_goron1:
	wait 60
	applyspeed $10
	wait 20
	setspeed SPEED_100
	applyspeed $10
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $02
	asm15 scriptHelp.kingMoblinDefeated_setGoronDirection, $01
	applyspeed $18
	scriptend

kingMoblinDefeated_goron2:
	wait 90
	applyspeed $10
	wait 20
	setspeed SPEED_100
	applyspeed $18
	asm15 scriptHelp.kingMoblinDefeated_setGoronDirection, $03
	applyspeed $18
	setanimation $04
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $02
	asm15 scriptHelp.kingMoblinDefeated_setGoronDirection, $01
	applyspeed $18
	asm15 scriptHelp.kingMoblinDefeated_setGoronDirection, $02
	applyspeed $20
	scriptend

kingMoblinDefeated_goron3:
	wait 120
	applyspeed $10
	wait 20
	setspeed SPEED_100
	applyspeed $28
	wait 60

	showtext TX_3128
	giveitem TREASURE_BOMB_FLOWER, $00
	wait 30

	showtext TX_3129
	writememory wTmpcfc0.genericCutscene.cfd0, $02
	asm15 scriptHelp.kingMoblinDefeated_setGoronDirection, $02
	applyspeed $30
	asm15 scriptHelp.kingMoblinDefeated_spawnInteraction8a
	scriptend


; ==============================================================================
; INTERACID_GHINI_HARASSING_MOOSH
; ==============================================================================

ghiniHarassingMoosh_subid00Script:
	setdisabledobjectsto11

	asm15 scriptHelp.ghiniHarassingMoosh_beginCircularMovement
@waitUntilStopped:
	jumpifobjectbyteeq Interaction.speed, $00, ++
	wait 1
	scriptjump @waitUntilStopped
++
	showtext TX_1204
	ormemory w1Companion.var3e, $01

@waitUntilCutsceneDone:
	jumpifmemoryset w1Companion.var3e, $10, ++
	scriptjump @waitUntilCutsceneDone
++
	enableallobjects
	spawnenemyhere ENEMYID_GHINI, $00
	scriptend


ghiniHarassingMoosh_subid01Script:
	jumpifmemoryset w1Companion.var3e, $01, ++
	scriptjump ghiniHarassingMoosh_subid01Script
++
	asm15 scriptHelp.ghiniHarassingMoosh_beginCircularMovement
@waitUntilStopped:
	jumpifobjectbyteeq Interaction.speed, $00, ++
	wait 1
	scriptjump @waitUntilStopped
++
	showtext TX_1205
	ormemory w1Companion.var3e, $02

@wait2:
	jumpifmemoryset w1Companion.var3e, $08, ++
	scriptjump @wait2
++
	asm15 scriptHelp.ghiniHarassingMoosh_beginCircularMovement

@waitUntilStopped2:
	jumpifobjectbyteeq Interaction.speed, $00, ++
	wait 1
	scriptjump @waitUntilStopped2
++
	showtext TX_1207
	playsound SND_DING
	setmusic MUS_MINIBOSS
	ormemory w1Companion.var3e, $10
	spawnenemyhere ENEMYID_GHINI, $00
	scriptend


ghiniHarassingMoosh_subid02Script:
	jumpifmemoryset w1Companion.var3e, $04, ++
	scriptjump ghiniHarassingMoosh_subid02Script
++
	asm15 scriptHelp.ghiniHarassingMoosh_beginCircularMovement
@waitUntilStopped:
	jumpifobjectbyteeq Interaction.speed, $00, ++
	wait 1
	scriptjump @waitUntilStopped
++
	showtext TX_1206
	ormemory w1Companion.var3e, $08
@wait:
	jumpifmemoryset w1Companion.var3e, $10, ++
	scriptjump @wait
++
	spawnenemyhere ENEMYID_GHINI, $00
	scriptend


; ==============================================================================
; INTERACID_TOKAY_SHOP_ITEM
; ==============================================================================
tokayShopItemScript:
	enableinput
	wait 1
	checktext
	checkabutton
	disableinput
	jumptable_objectbyte Interaction.subid
	.dw @selectedFeather
	.dw @selectedBracelet
	.dw @selectedShovelReplacingFeather
	.dw @selectedShovelReplacingBracelet
	.dw @selectedShield
	.dw @selectedShield
	.dw @selectedShield

@selectedFeather:
	jumpifobjectbyteeq Interaction.var39, $00, @offerGetFeatherForShovel
	showtextlowindex <TX_0a2b
	jumptable_memoryaddress wSelectedTextOption
	.dw @buyFeather
	.dw @declineTrade1

@buyFeather:
	jumpifobjectbyteeq Interaction.var38, $00, @notEnoughSeedsForFeather
	asm15 scriptHelp.tokayShopItem_lose10MysterySeeds
	asm15 scriptHelp.tokayShopItem_giveFeatherToLink
	setglobalflag GLOBALFLAG_BOUGHT_FEATHER_FROM_TOKAY
	enableinput
	scriptend
@notEnoughSeedsForFeather:
	showtextlowindex <TX_0a2e
	scriptjump tokayShopItemScript

@offerGetFeatherForShovel:
	jumpifobjectbyteeq Interaction.var3a, $00, @offerReturnBracelet
	showtextlowindex <TX_0a2c
	jumptable_memoryaddress wSelectedTextOption
	.dw @getFeatherForShovel
	.dw @declineTrade1

@getFeatherForShovel:
	asm15 scriptHelp.tokayShopItem_giveFeatherAndLoseShovel
	scriptjump tokayShopItemScript

@offerReturnBracelet:
	showtextlowindex <TX_0a27
	jumptable_memoryaddress wSelectedTextOption
	.dw @returnBracelet
	.dw @declineTrade2

@returnBracelet:
	showtextlowindex <TX_0a28
	asm15 scriptHelp.tokayShopItem_giveShovelAndLoseBracelet
	scriptjump tokayShopItemScript


@selectedBracelet:
	jumpifobjectbyteeq Interaction.var39, $00, @offerGetBraceletForShovel
	showtextlowindex <TX_0a32
	jumptable_memoryaddress wSelectedTextOption
	.dw @buyBracelet
	.dw @declineTrade1

@buyBracelet:
	jumpifobjectbyteeq Interaction.var38, $00, @notEnoughSeedsForBracelet
	asm15 scriptHelp.tokayShopItem_lose10ScentSeeds
	asm15 scriptHelp.tokayShopItem_giveBraceletToLink
	setglobalflag GLOBALFLAG_BOUGHT_BRACELET_FROM_TOKAY
	wait 1
	checktext
	showtextlowindex <TX_0a3b
	enableinput
	scriptend
@notEnoughSeedsForBracelet:
	showtextlowindex <TX_0a34
	scriptjump tokayShopItemScript

@offerGetBraceletForShovel:
	jumpifobjectbyteeq Interaction.var3a, $00, @offerReturnFeather
	showtextlowindex <TX_0a33
	jumptable_memoryaddress wSelectedTextOption
	.dw @getBraceletForShovel
	.dw @declineTrade1

@getBraceletForShovel:
	asm15 scriptHelp.tokayShopItem_giveBraceletAndLoseShovel
	scriptjump tokayShopItemScript

@offerReturnFeather:
	showtextlowindex <TX_0a30
	jumptable_memoryaddress wSelectedTextOption
	.dw @returnFeather
	.dw @declineTrade2

@returnFeather:
	showtextlowindex <TX_0a28
	asm15 scriptHelp.tokayShopItem_giveShovelAndLoseFeather
	scriptjump tokayShopItemScript


@selectedShovelReplacingFeather:
	showtextlowindex <TX_0a36
	jumptable_memoryaddress wSelectedTextOption
	.dw @getShovelForFeather
	.dw @declineTrade2

@getShovelForFeather:
	showtextlowindex <TX_0a28
	asm15 scriptHelp.tokayShopItem_giveShovelAndLoseFeather
	scriptjump tokayShopItemScript


@selectedShovelReplacingBracelet:
	showtextlowindex <TX_0a35
	jumptable_memoryaddress wSelectedTextOption
	.dw @getShovelForBracelet
	.dw @declineTrade2

@getShovelForBracelet:
	showtextlowindex <TX_0a28
	asm15 scriptHelp.tokayShopItem_giveShovelAndLoseBracelet
	scriptjump tokayShopItemScript


@declineTrade1:
	showtextlowindex <TX_0a2d
	scriptjump tokayShopItemScript

@declineTrade2:
	showtextlowindex <TX_0a29
	scriptjump tokayShopItemScript


@selectedShield:
	showtextlowindex <TX_0a39
	jumptable_memoryaddress wSelectedTextOption
	.dw @buyShield
	.dw @declineTrade1

@buyShield:
	jumpifobjectbyteeq Interaction.var3d, $00, @getShield

	; Already have shield
	showtextlowindex <TX_0a3a
	scriptjump tokayShopItemScript

@getShield:
	jumpifobjectbyteeq Interaction.var38, $00, @notEnoughSeedsForShield
	asm15 scriptHelp.tokayShopItem_lose10ScentSeeds
	asm15 scriptHelp.tokayShopItem_giveShieldToLink
	enableinput
	scriptend
@notEnoughSeedsForShield:
	showtextlowindex <TX_0a34
	scriptjump tokayShopItemScript


; ==============================================================================
; INTERACID_BOMB_UPGRADE_FAIRY
; ==============================================================================
bombUpgradeFairyScript:
	loadscript scriptHelp.bombUpgradeFairyScript_body


; ==============================================================================
; INTERACID_MAKU_TREE
; ==============================================================================

makuTree_subid00Script:
	loadscript scriptHelp.makuTree_subid00Script_body

makuTree_subid01Script:
	loadscript scriptHelp.makuTree_subid01Script_body

makuTree_subid02Script:
	loadscript scriptHelp.makuTree_subid02Script_body


; Cutscene after saving Nayru where Twinrova reveals themselves
makuTree_subid03Script:
	jumpifmemoryeq wTmpcfc0.genericCutscene.cfd0, $03, ++
	checkmemoryeq  wTmpcfc0.genericCutscene.cfd0, $01
	checkpalettefadedone
	setanimation $01
	scriptend
++
	checkpalettefadedone
	wait 40

	setanimation $04
	showtextlowindex <TX_0553
	wait 30

	writememory   wTmpcfc0.genericCutscene.cfd0, $04
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $05

	setanimation $00
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $06

	setanimation $03
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $07

	setanimation $02
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $0b

	wait 80
	asm15 scriptHelp.forceLinkDirection, DIR_UP
	wait 40

	jumpifmemoryeq wIsLinkedGame, $00, @unlinked

	; linked
	showtextlowindex <TX_0557
	scriptjump ++
@unlinked:
	showtextlowindex <TX_0554
++
	wait 80
	setanimation $00
	wait 40
	setcollisionradii $08, $08
	makeabuttonsensitive

@npcLoop:
	showtextlowindex <TX_0555
	wait 20
	setanimation $04
	wait 20
	showtextlowindex <TX_0556
	writememory wMakuMapTextPresent, <TX_0556
	wait 20
	setanimation $00
	writememory wTmpcfc0.genericCutscene.cfd0, $63
	enableinput
	checkabutton
	disableinput
	scriptjump @npcLoop


makuTree_subid04Script:
	checkmemoryeq wTmpcfc0.genericCutscene.state, $06
	wait 20
	setanimation $02
	scriptend


; Credits cutscene?
makuTree_subid05Script:
	checkmemoryeq wTmpcfc0.genericCutscene.state, $01
	setanimation $03
	checkmemoryeq wTmpcfc0.genericCutscene.state, $02
	showtextlowindex <TX_0552
	wait 60
	writememory   wTmpcfc0.genericCutscene.state, $03
	checkmemoryeq wTmpcfc0.genericCutscene.state, $08
	wait 150
	setanimation $02
	scriptend


makuTree_subid06Script_part1:
	loadscript scriptHelp.makuTree_subid06Script_part1_body

makuTree_subid06Script_part2:
	loadscript scriptHelp.makuTree_subid06Script_part2_body

makuTree_subid06Script_part3:
	jumpifmemoryeq wIsLinkedGame, $01, @linked
	rungenericnpclowindex <TX_055c
@linked:
	rungenericnpclowindex <TX_0560


; ==============================================================================
; INTERACID_MAKU_SPROUT
; ==============================================================================

makuSprout_subid00Script:
	loadscript scriptHelp.makuSprout_subid00Script_body


; Script where moblins are attacking Maku Sprout
makuSprout_subid01Script:
	jumpifglobalflagset GLOBALFLAG_MAKU_TREE_SAVED, @alreadySaved

	; Maku tree not saved yet. Spawn the moblins attacking her
	spawninteraction INTERACID_MISCELLANEOUS_1, $04, $40, $50
	setanimation $02
	setcollisionradii $08, $08
	checkmemoryeq wTmpcfc0.genericCutscene.state, $09
	wait 2

@waitForEnemiesToDie:
	jumptable_memoryaddress wNumEnemies
	.dw @allEnemiesDead
	.dw @oneEnemyDead
	.dw @waitForEnemiesToDie

@oneEnemyDead:
	setanimation $01
	wait 90
	setanimation $00
	wait 60
	checknoenemies

@allEnemiesDead:
	setanimation $01
	wait 90

@alreadySaved:
	setanimation $00
	setcollisionradii $08, $08
	makeabuttonsensitive
@npcLoop:
	checkabutton
	showtextlowindex <TX_05d5
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_REMOTE_MAKU_CUTSCENE
; ==============================================================================
remoteMakuCutsceneScript:
	disableinput
	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE1
	setmusic MUS_MAKU_TREE
	wait 40

	writememory wDontUpdateStatusBar, $77
	asm15 hideStatusBar
	asm15 scriptHelp.remoteMakuCutscene_fadeoutToBlackWithDelay, $02
	checkpalettefadedone

	jumpifobjectbyteeq Interaction.subid, $01, @past

@present:
	spawninteraction INTERACID_MAKU_CONFETTI, $00, $00, $00
	wait 240
	wait 180
	scriptjump ++
@past:
	spawninteraction INTERACID_MAKU_CONFETTI, $01, $00, $00
	wait 240
	wait 60
++
	asm15 scriptHelp.makuTree_showTextWithOffsetAndUpdateMapText, $00
	wait 1
	asm15 showStatusBar
	asm15 clearFadingPalettes
	asm15 scriptHelp.remoteMakuCutscene_checkinitUnderwaterWaves
	asm15 fadeinFromWhiteWithDelay, $02
	checkpalettefadedone

	resetmusic
	orroomflag $40
	asm15 incMakuTreeState
	jumpifobjectbyteeq Interaction.var03, $07, @spawnGoronAfterCrownDungeon
	enableinput
	scriptend

@spawnGoronAfterCrownDungeon:
	spawninteraction INTERACID_GORON, $03, $58, $a8
	scriptend


; ==============================================================================
; INTERACID_GORON_ELDER
; ==============================================================================
goronElderScript_subid00:
	loadscript scriptHelp.goronElderScript_subid00_body

goronElderScript_subid01:
	loadscript scriptHelp.goronElderScript_subid01_body


; ==============================================================================
; INTERACID_CLOAKED_TWINROVA
; ==============================================================================
cloakedTwinrova_subid00Script:
	loadscript scriptHelp.cloakedTwinrova_subid00Script_body

cloakedTwinrova_subid02Script:
	loadscript scriptHelp.cloakedTwinrova_subid02Script_body


; ==============================================================================
; INTERACID_MISC_PUZZLES
; ==============================================================================

; Subid $11
miscPuzzles_crownDungeonOpeningScript:
	checkcfc0bit 0
	setmusic SNDCTRL_STOPMUSIC
	wait 60
	asm15 scriptHelp.miscPuzzles_drawCrownDungeonOpeningFrame1
	wait 30
	asm15 scriptHelp.miscPuzzles_drawCrownDungeonOpeningFrame2
	wait 30
	asm15 scriptHelp.miscPuzzles_drawCrownDungeonOpeningFrame3
	wait 30
	settilehere TILEINDEX_DUNGEON_DOOR_1

miscPuzzles_justOpenedKeyDoor:
	wait 45
	resetmusic
	playsound SND_SOLVEPUZZLE
	enableinput
	scriptend


; Subid $12
miscPuzzles_mermaidsCaveDungeonOpeningScript:
	checkcfc0bit 0
	setmusic SNDCTRL_STOPMUSIC
	wait 60
	playsound SND_DOORCLOSE
	settilehere TILEINDEX_INDOOR_DOOR
	scriptjump miscPuzzles_justOpenedKeyDoor


; Subid $13
miscPuzzles_eyeglassLibraryOpeningScript:
	checkcfc0bit 0
	setmusic SNDCTRL_STOPMUSIC
	wait 60
	playsound SND_DOORCLOSE
	settileat $22, TILEINDEX_DUNGEON_DOOR_1
	settileat $23, TILEINDEX_DUNGEON_DOOR_2
	scriptjump miscPuzzles_justOpenedKeyDoor


; ==============================================================================
; INTERACID_TWINROVA
; ==============================================================================
twinrova_subid00Script:
	loadscript scriptHelp.twinrova_subid00Script_body

twinrova_subid02Script:
	loadscript scriptHelp.twinrova_subid02Script_body

twinrova_subid04Script:
	loadscript scriptHelp.twinrova_subid04Script_body

twinrova_subid06Script:
	loadscript scriptHelp.twinrova_subid06Script_body


; ==============================================================================
; INTERACID_PATCH
; ==============================================================================

patch_upstairsRepairTuniNutScript:
	loadscript scriptHelp.patch_upstairsRepairTuniNutScript


patch_upstairsRepairSwordScript:
	loadscript scriptHelp.patch_upstairsRepairSwordScript_body


patch_upstairsRepairedEverythingScript:
	initcollisions
@npcLoop:
	checkabutton
	showtext TX_5811
	scriptjump @npcLoop


patch_upstairsMoveToStaircaseScript:
	moveup $14
	wait 8
	moveright $32
	wait 1
	setanimation DIR_LEFT
	wait 30
	scriptend


patch_downstairsScript:
	loadscript scriptHelp.patch_downstairsScript_body


patch_duringMinigameScript:
	wait 8
	setanimation $06
@npcLoop:
	checkabutton
	showtext TX_580b
	scriptjump @npcLoop


patch_linkWonMinigameScript:
	wait 30
	asm15 fadeoutToWhiteWithDelay, $02
	wait 1

	setanimation DIR_DOWN
	asm15 scriptHelp.patch_moveLinkPositionAtMinigameEnd
	wait 3
	asm15 fadeinFromWhiteWithDelay, $02
	wait 30

	asm15 scriptHelp.patch_updateTextSubstitution
	showtext TX_580d
	setanimation $04
	writememory wTmpcfc0.patchMinigame.wonMinigame, $01
	wait 60

	asm15 scriptHelp.patch_turnToFaceLink
	wait 4
	showtext TX_580e
	callscript patch_giveRepairedItem
	wait 60

	showtext TX_580f
	asm15 scriptHelp.patch_restoreControlAndStairs
	scriptend


patch_giveRepairedItem:
	jumptable_memoryaddress wTmpcfc0.patchMinigame.fixingSword
	.dw @tuniNut
	.dw @sword

@tuniNut:
	giveitem TREASURE_OBJECT_TUNI_NUT_01
	retscript

@sword:
	jumptable_memoryaddress wTmpcfc0.patchMinigame.swordLevel
	.dw @level3
	.dw @level2
@level2:
	giveitem TREASURE_OBJECT_SWORD_01
	giveitem TREASURE_OBJECT_SWORD_04
	scriptjump @loseTradeItem
@level3:
	giveitem TREASURE_OBJECT_SWORD_02
	giveitem TREASURE_OBJECT_SWORD_05

@loseTradeItem:
	asm15 loseTreasure, TREASURE_TRADEITEM
	retscript


patch_linkFailedMinigameScript:
	asm15 scriptHelp.patch_moveLinkPositionAtMinigameEnd
	asm15 scriptHelp.patch_turnToFaceLink
	asm15 fadeinFromWhiteWithDelay, $04
	wait 120
	asm15 scriptHelp.patch_updateTextSubstitution
	showtext TX_580c
	asm15 scriptHelp.patch_restoreControlAndStairs
	setanimation $02
	scriptend

patch_downstairsAfterBeatingMinigameScript:
	initcollisions
@npcLoop:
	checkabutton
	showtext TX_580f
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_MOBLIN
; ==============================================================================

moblin_subid00Script:
	setanimation DIR_LEFT
	checkmemoryeq wTmpcfc0.genericCutscene.state, $01

	writeobjectbyte Interaction.var3f, $01
	callscript jumpAndWaitUntilLanded
	writeobjectbyte Interaction.var3f, $00

	writememory   wTmpcfc0.genericCutscene.state, $02
	checkmemoryeq wTmpcfc0.genericCutscene.state, $05

moblin_jumpUntilLinkApproaches:
	writeobjectbyte Interaction.var3f, $01
	callscript jumpAndWaitUntilLanded
	writeobjectbyte Interaction.var3f, $00

	jumpifmemoryeq wTmpcfc0.genericCutscene.state, $06, @linkApproached
	wait 30
	scriptjump moblin_jumpUntilLinkApproaches

@linkApproached:
	asm15 scriptHelp.turnToFaceLink
	asm15 scriptHelp.addToccd4, $01
	checkmemoryeq wccd4, $02
	asm15 scriptHelp.addTocfc0, $01
	checkmemoryeq wTmpcfc0.genericCutscene.state, $09
	asm15 scriptHelp.moblin_spawnEnemyHere
	wait 1
	scriptend


moblin_subid01Script:
	setanimation DIR_RIGHT
	checkmemoryeq wTmpcfc0.genericCutscene.state, $03

	writeobjectbyte Interaction.var3f, $01
	callscript jumpAndWaitUntilLanded
	writeobjectbyte Interaction.var3f, $00

	writememory   wTmpcfc0.genericCutscene.state, $04
	checkmemoryeq wTmpcfc0.genericCutscene.state, $05
	wait 30
	scriptjump moblin_jumpUntilLinkApproaches


; ==============================================================================
; INTERACID_CARPENTER
; ==============================================================================

carpenter_subid00Script:
	loadscript scriptHelp.carpenter_subid00Script_body


; Carpenter #1 to be sought out
carpenter_subid02Script:
	makeabuttonsensitive
@npcLoop:
	setanimation DIR_DOWN
	checkabutton
	jumpifobjectbyteeq Interaction.var3f, $00, @hasntReturnedToBossYet
	scriptjump carpenter_talkedWhileWithBoss
@hasntReturnedToBossYet
	jumpifmemoryeq wTmpcfc0.carpenterSearch.cfd0, $01, carpenter_convincedToReturn
	showtextlowindex <TX_230c
	scriptjump @npcLoop


; Carpenter #2 to be sought out
carpenter_subid03Script:
	makeabuttonsensitive
@npcLoop:
	setanimation DIR_DOWN
	checkabutton
	jumpifobjectbyteeq Interaction.var3f, $00, @hasntReturnedToBossYet
	scriptjump carpenter_talkedWhileWithBoss
@hasntReturnedToBossYet
	jumpifmemoryeq wTmpcfc0.carpenterSearch.cfd0, $01, carpenter_convincedToReturn
	showtextlowindex <TX_230d
	scriptjump @npcLoop


; Carpenter #3 to be sought out
carpenter_subid04Script:
	makeabuttonsensitive
@npcLoop:
	setanimation DIR_DOWN
	checkabutton
	jumpifobjectbyteeq Interaction.var3f, $00, @hasntReturnedToBossYet
	scriptjump carpenter_talkedWhileWithBoss
@hasntReturnedToBossYet
	jumpifmemoryeq wTmpcfc0.carpenterSearch.cfd0, $01, carpenter_convincedToReturn
	showtextlowindex <TX_230e
	scriptjump @npcLoop


; The carpenter shows text then returns to the boss
carpenter_convincedToReturn:
	disableinput
	showtextlowindex <TX_230f
	setanimation DIR_LEFT
	writeobjectbyte Interaction.state, $02 ; Signal to jump away
	scriptend


; The boss carpenter in the cutscene where they build the bridge
carpenter_subid05Script:
	disableinput
	callscript carpenter_jump
	showtextlowindex <TX_230a

	writememory   wTmpcfc0.carpenterSearch.cfd0, $02
	checkmemoryeq wTmpcfc0.carpenterSearch.cfd0, $03

	setanimation $04
	checkmemoryeq wTmpcfc0.carpenterSearch.cfd0, $07

	setanimation $05
	checkmemoryeq wTmpcfc0.carpenterSearch.cfd0, $08

	callscript carpenter_jump
	showtextlowindex <TX_230b
	writememory wTmpcfc0.carpenterSearch.cfd0, $09
	checkmemoryeq wTmpcfc0.carpenterSearch.cfd0, $0a

	setanimation $04
	wait 10

	writememory wTmpcfc0.carpenterSearch.cfd0, $0b
	setspeed SPEED_100
	writeobjectbyte Interaction.angle, ANGLE_DOWN
	applyspeed $30
	scriptend


; Carpenter #1 in the cutscene where they build the bridge
carpenter_subid06Script:
	checkmemoryeq wTmpcfc0.carpenterSearch.cfd0, $02
	callscript carpenter_jump
	showtextlowindex <TX_2311

	writememory wTmpcfc0.carpenterSearch.cfd0, $03
	setspeed SPEED_100
	movedown $10
	moveleft $30
	wait 90

	asm15 scriptHelp.carpenter_buildBridgeColumn, $52
	moveleft $10
	wait 90

	asm15 scriptHelp.carpenter_buildBridgeColumn, $51
	moveleft $10
	wait 90

	asm15 scriptHelp.carpenter_buildBridgeColumn, $50
	moveright $50
	moveup $10

	writememory wTmpcfc0.carpenterSearch.cfd0, $07
	setanimation DIR_LEFT
	callscript carpenter_jump
	wait 10
	showtextlowindex <TX_2312

	writememory   wTmpcfc0.carpenterSearch.cfd0, $08
	checkmemoryeq wTmpcfc0.carpenterSearch.cfd0, $09

	showtextlowindex <TX_2311
	writememory   wTmpcfc0.carpenterSearch.cfd0, $0a
	wait 90
	movedown $30
	scriptend

; Carpenter #2 in the cutscene where they build the bridge
carpenter_subid07Script:
	callscript carpenter_jumpOnCutsceneStart
	setspeed SPEED_100
	movedown $10
	moveleft $20
	callscript carpenter_followBridgeProgress
	moveright $40
	moveup $10
	setanimation DIR_DOWN
	callscript carpenter_jump_nosound
	wait 180
	movedown $40
	scriptend

; Carpenter #3 in the cutscene where they build the bridge
carpenter_subid08Script:
	callscript carpenter_jumpOnCutsceneStart
	setspeed SPEED_100
	movedown $28
	moveleft $10
	callscript carpenter_followBridgeProgress
	moveright $30
	moveup $28
	setanimation DIR_DOWN
	callscript carpenter_jump_nosound
	wait 180
	wait 90
	movedown $50
	enableallobjects
	setglobalflag GLOBALFLAG_SYMMETRY_BRIDGE_BUILT
	enablemenu
	scriptend


carpenter_jumpOnCutsceneStart:
	checkmemoryeq wTmpcfc0.carpenterSearch.cfd0, $02
	setzspeed -$0200
	wait 20
	retscript


; Unused
carpenter_script7a7d:
	checkmemoryeq wTmpcfc0.carpenterSearch.cfd0, $03
	retscript


carpenter_followBridgeProgress:
	checkmemoryeq wTmpcfc0.carpenterSearch.cfd0, $04
	moveleft $10
	checkmemoryeq wTmpcfc0.carpenterSearch.cfd0, $05
	moveleft $10
	checkmemoryeq wTmpcfc0.carpenterSearch.cfd0, $06
	retscript


carpenter_jump_nosound:
	setzspeed -$0200
	wait 20
	retscript


; Unused
carpenter_script7a98:
	checkmemoryeq wTmpcfc0.carpenterSearch.cfd0, $09
	setzspeed -$0200
	wait 20
	retscript


; Unused
carpenter_script7aa1:
	checkmemoryeq wTmpcfc0.carpenterSearch.cfd0, $0a
	retscript


carpenter_jump:
	setzspeed -$0200
	playsound SND_JUMP
	wait 20
	retscript


; Carpenter in Eyeglasses Library
carpenter_subid09Script:
	initcollisions
@npcLoop:
	setanimation DIR_UP
	checkabutton
	turntofacelink
	jumpifglobalflagset GLOBALFLAG_WATER_POLLUTION_FIXED, ++

	showtextlowindex <TX_2313
	scriptjump @npcLoop
++
	showtextlowindex <TX_2314
	scriptjump @npcLoop


; Talked to one of the workers after they've returned
carpenter_talkedWhileWithBoss:
	turntofacelink
	showtextlowindex <TX_2310
	setanimation $02
	checkabutton
	scriptjump carpenter_talkedWhileWithBoss



; ==============================================================================
; INTERACID_RAFTWRECK_CUTSCENE
; ==============================================================================
raftwreckCutsceneScript:
	loadscript scriptHelp.raftwreckCutsceneScript_body


; ==============================================================================
; INTERACID_KING_ZORA
; ==============================================================================

kingZoraScript_present_firstTime:
	checkabutton
	showtextnonexitable TX_3408
	jumpiftextoptioneq $00, kingZoraScript_present_justAcceptedTask
	orroomflag $40

kingZoraScript_present_refusedTask:
	showtext TX_340a

kingZoraScript_present_giveKey:
	checkabutton
	showtextnonexitable TX_3409
	jumpiftextoptioneq $01, kingZoraScript_present_refusedTask

kingZoraScript_present_justAcceptedTask:
	disableinput
	showtext TX_340b
	giveitem TREASURE_OBJECT_LIBRARY_KEY_00
	wait 60
	showtext TX_340c
	enableinput

kingZoraScript_present_acceptedTask:
	checkabutton
	showtext TX_340c
	scriptjump kingZoraScript_present_acceptedTask


kingZoraScript_present_justCleanedWater:
	checkabutton
	showtext TX_340d
	asm15 setGlobalFlag, GLOBALFLAG_GOT_PERMISSION_TO_ENTER_JABU

kingZoraScript_present_cleanedWater:
	checkabutton
	showtext TX_340e
	scriptjump kingZoraScript_present_cleanedWater


kingZoraScript_present_afterD7:
	checkabutton
	showtext TX_340f
	scriptjump kingZoraScript_present_afterD7


; Accepts a secret for the sword upgrade
kingZoraScript_present_postGame:
	checkabutton
	disableinput
	jumpifglobalflagset GLOBALFLAG_DONE_KING_ZORA_SECRET, @alreadyGotUpgrade

	showtext TX_3435
	wait 30
	jumpiftextoptioneq $00, @askForSecret
	showtext TX_3436
	scriptjump @loop

@askForSecret:
	askforsecret KING_ZORA_SECRET
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @gaveCorrectSecret
	showtext TX_3438
	scriptjump @loop

@gaveCorrectSecret:
	setglobalflag GLOBALFLAG_BEGAN_KING_ZORA_SECRET
	showtext TX_3437
	wait 30
	callscript scriptFunc_doEnergySwirlCutscene
	wait 30
	callscript @giveSwordUpgrade
	wait 30
	generatesecret KING_ZORA_RETURN_SECRET
	setglobalflag GLOBALFLAG_DONE_KING_ZORA_SECRET
	showtext TX_3439
	scriptjump @loop

@alreadyGotUpgrade:
	; BUG: JP version doesn't show the correct secret when asking the 2nd time onward?
.ifdef ENABLE_US_BUGFIXES
	generatesecret KING_ZORA_RETURN_SECRET
.endif
	showtext TX_343a
@loop:
	enableinput
	scriptjump kingZoraScript_present_postGame

@giveSwordUpgrade:
	jumptable_objectbyte Interaction.var03
	.dw @giveLevel3
	.dw @giveLevel2

@giveLevel2:
	giveitem TREASURE_OBJECT_SWORD_01
	giveitem TREASURE_OBJECT_SWORD_04
	retscript

@giveLevel3:
	giveitem TREASURE_OBJECT_SWORD_02
	giveitem TREASURE_OBJECT_SWORD_05
	retscript


kingZoraScript_past_dontHavePotion:
	checkabutton
	showtext TX_3400
	scriptjump kingZoraScript_past_dontHavePotion


kingZoraScript_past_havePotion:
	checkabutton
	showtext TX_3401
	jumpiftextoptioneq $01, kingZoraScript_past_havePotion

	disableinput
	wait 8
	spawninteraction INTERACID_KING_ZORA, $02, $34, $78
	asm15 loseTreasure, TREASURE_POTION
	asm15 playSound, SND_NONE
	wait 30

	showtext TX_3402
	wait 8

	asm15 playSound, SND_NONE
	showtext TX_3403
	wait 60

	showtext TX_3404
	asm15 setGlobalFlag, GLOBALFLAG_KING_ZORA_CURED
	enableinput

kingZoraScript_past_justCured:
	checkabutton
	showtext TX_3405
	scriptjump kingZoraScript_past_justCured


kingZoraScript_past_cleanedWater:
	checkabutton
	showtext TX_3406
	scriptjump kingZoraScript_past_cleanedWater


kingZoraScript_past_afterD7:
	checkabutton
	showtext TX_3407
	scriptjump kingZoraScript_past_afterD7



; ==============================================================================
; INTERACID_TOKKEY
; ==============================================================================
tokkeyScript:
	initcollisions
	setcollisionradii $14, $06
	jumpifroomflagset $40, tokkeyScript_alreadyTaughtTune

	; Haven't taught the tune yet
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_2c00
	disableinput
	xorcfc0bit 0
	enableinput
	rungenericnpclowindex <TX_2c01

tokkeyScript_alreadyTaughtTune:
	rungenericnpclowindex <TX_2c04


tokkeyScript_justHeardTune:
	disableinput
	loadscript scriptHelp.tokkayScript_justHeardTune_body


tokkeyScriptFunc_runAcrossDesk:
	moveright $20
	wait 15

	moveleft $20
	wait 15

	asm15 scriptHelp.tokkey_jump
	moveright $20
	wait 15

	asm15 scriptHelp.tokkey_jump
	moveleft $20
	wait 15
	retscript


tokkeyScriptFunc_hopAcrossDesk:
	moveleft $10
	setanimation $02
	wait 15
	moveleft $10
	setanimation $02
	wait 15
	moveright $10
	setanimation $02
	wait 15
	moveright $10
	setanimation $02
	wait 15
	retscript


; ==============================================================================
; INTERACID_DIN
; ==============================================================================
; Unused? (Identical to "zeldaSubid00Script")
dinScript:
	setanimation $05
	setcollisionradii $08, $04
	makeabuttonsensitive
	checkabutton
	setdisabledobjectsto11
	setanimation $06
	wait 220
	showtext TX_3d05
	wait 60
	writememory wCutsceneTrigger, CUTSCENE_ROOM_OF_RITES_COLLAPSE
	scriptend


; ==============================================================================
; INTERACID_ZORA
; ==============================================================================

zoraSubid0cScript:
	wait 60
	setanimation $03
	wait 30
	setanimation $01
	wait 30
	asm15 scriptHelp.zora_createExclamationMark
	setanimation $02
	wait 20
	asm15 scriptHelp.zora_beginJump
	wait 8
	movedown $11
	moveright $17

zoraScript_end:
	wait 30
	xorcfc0bit 7
	scriptend

zoraSubid0dScript:
	wait 60
	setanimation $01
	wait 30
	setanimation $03
	wait 30
	asm15 scriptHelp.zora_createExclamationMark
	setanimation $02
	wait 20
	asm15 scriptHelp.zora_beginJump
	wait 8
	moveup $11
	moveleft $17
	scriptjump zoraScript_end


; Zora studying in library
zoraSubid0eScript:
	initcollisions
@loop:
	checkabutton
	turntofacelink
	showloadedtext
	setanimation $00
	scriptjump @loop


; Gives zora scale to Link
zoraSubid10Script:
	asm15 scriptHelp.zora_waitForLinkToMoveDown
	jumptable_memoryaddress wTmpcfc0.genericCutscene.cfc1
	.dw zoraSubid10Script
	.dw @linkMovedDown

@linkMovedDown:
	disableinput
	asm15 scriptHelp.zora_makeLinkFaceDown
	wait 30

	setspeed SPEED_100
	setangle $18
	asm15 scriptHelp.zora_moveToLinksXPosition
	wait 1

	moveup $20
	wait 30
	showtext TX_3430
	wait 30

	giveitem TREASURE_OBJECT_ZORA_SCALE_00
	movedown $80
	enableinput
	scriptend


; Guarding entrance to sea of storms
zoraSubid11And12Script:
	initcollisions
	jumpifitemobtained TREASURE_ZORA_SCALE, @gotScale
	rungenericnpc TX_3431

@gotScale:
	checkabutton
	disableinput
	showtext TX_3431
	wait 30
	asm15 scriptHelp.zora_createExclamationMarkToTheRight
	wait 60
	showtext TX_3432
	wait 30
	incstate
	setspeed SPEED_200
	asm15 scriptHelp.zora_checkIsLinkedGame
	jumptable_memoryaddress wTmpcfc0.genericCutscene.cfc1
	.dw @unlinked
	.dw @linked

@unlinked:
	moveleft $18
	asm15 scriptHelp.zora_setLinkDirectionUp
	moveup $30
	scriptjump @end

@linked:
	movedown $10
	asm15 scriptHelp.zora_setLinkDirectionRight
	moveright $40
@end:
	orroomflag $40
	enableinput
	scriptend


; ==============================================================================
; INTERACID_ZELDA
; ==============================================================================

; In room of rites, waiting to be rescued by talking to her
zeldaSubid00Script:
	setanimation $05
	setcollisionradii $08, $04
	makeabuttonsensitive
	checkabutton

	setdisabledobjectsto11
	setanimation $06
	wait 220
	showtext TX_3d05
	wait 60
	writememory wCutsceneTrigger, CUTSCENE_ROOM_OF_RITES_COLLAPSE
	scriptend


zeldaSubid01Script:
	loadscript scriptHelp.zeldaSubid01Script_body


zeldaSubid02Script:
	loadscript scriptHelp.zeldaSubid02Script_body


zeldaSubid03Script:
	loadscript scriptHelp.zeldaSubid03Script_body


zeldaSubid04Script:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $01
	setanimation $03
	applyspeed $11
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $02

	setanimation $03
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $03

	setanimation $02
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $05

	setanimation $03
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $07

	writememory w1Link.direction, DIR_RIGHT
	showtext TX_0607
	wait 30

	writememory wTmpcfc0.genericCutscene.cfd0, $08
	wait 45

	writememory w1Link.direction, DIR_RIGHT
	moveup $11

	writememory w1Link.direction, DIR_UP
	moveleft $11
	moveup $41
	scriptend


zeldaSubid05Script:
	loadscript scriptHelp.zeldaSubid05Script_body


zeldaSubid06Script:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $01

	setspeed SPEED_100
	moveup $24
	moveleft $08
	setanimation $00
	writememory wTmpcfc0.genericCutscene.cfd0, $02
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $03

	setanimation $01
	writememory wTmpcfc0.genericCutscene.cfd0, $04
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $06

	setanimation $00
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $08

	moveup $38
	wait 30
	movedown $08
	wait 30

	showtext TX_0608

	moveup $48
	enableinput
	scriptend


zeldaSubid09Script:
	checkcfc0bit 0
	asm15 scriptHelp.createExclamationMark, 30
	wait 120

	xorcfc0bit 1
	checkcfc0bit 5

	setspeed SPEED_080
	setangle $00
	applyspeed $31
	checkcfc0bit 6

	setanimation $03
	wait 15

	setanimation $01
	wait 15

	setanimation $02
	checkcfc0bit 7

	asm15 scriptHelp.createExclamationMark, 30
	scriptend


; ==============================================================================$08
; INTERACID_TWINROVA_IN_CUTSCENE
; ==============================================================================$08
twinrovaInCutsceneScript:
	loadscript scriptHelp.twinrovaInCutsceneScript_body


; ==============================================================================
; INTERACID_BOOK_OF_SEALS_PODIUM
; ==============================================================================
bookOfSealsPodiumScript:
	checkabutton
	jumpifitemobtained TREASURE_BOOK_OF_SEALS, @askToPlaceBook
	showtextlowindex <TX_1211
	scriptjump bookOfSealsPodiumScript

@askToPlaceBook:
	showtextlowindex <TX_1212
	jumpiftextoptioneq $01, bookOfSealsPodiumScript
	orroomflag $40
	scriptend


; ==============================================================================
; INTERACID_VIRE
; ==============================================================================

; Vire at black tower entrance
vireSubid0Script:
	showtext TX_2f27
	wait 4
	applyspeed $19
	wait 16
	orroomflag $40
	resetmusic
	scriptend

; Vire in donkey kong minigame (lower level)
vireSubid1Script:
	setangle $10
	applyspeed $21
	wait 8
	showtext TX_2f28
	wait 8
	asm15 scriptHelp.vire_activateMusic
	setangle $00
	applyspeed $21
	orroomflag $40
	scriptend

; Vire in donkey kong minigame (upper level); after being beaten
vireSubid2Script:
	settileat $34, $01
	asm15 playSound, SND_DOORCLOSE
	wait 30
	showtext TX_2f29
	wait 4
	applyspeed $11
	orroomflag $40
	scriptend


; ==============================================================================
; INTERACID_HORON_DOG
; ==============================================================================
horonDogScript:
	setspeed SPEED_080
	wait 180
@loop:
	setangle $18
	applyspeed $18
	wait 6
	setangle $08
	applyspeed $14
	wait 120
	scriptjump @loop


; ==============================================================================
; INTERACID_CHILD_JABU
; ==============================================================================
childJabuScript:
	rungenericnpc TX_5711

; Unused?
script7d8e:
	scriptjump childJabuScript


; ==============================================================================
; INTERACID_HUMAN_VERAN
; ==============================================================================
humanVeranScript:
	wait 240
	setanimation $01
	wait 30
	showtext TX_5601
	wait 30
	setanimation $00
	wait 60
	writememory wTmpcfc0.genericCutscene.cfd1, $02
	wait 180
	scriptend


; ==============================================================================
; INTERACID_SYMMETRY_NPC
; ==============================================================================

symmetryNpcSubid0And1Script:
	rungenericnpclowindex <TX_2d0c

symmetryNpcSubid2And3Script:
	rungenericnpclowindex <TX_2d19

symmetryNpcSubid4And5Script:
	rungenericnpclowindex <TX_2d23

symmetryNpcSubid6And7Script:
	loadscript scriptHelp.symmetryNpcSubid6And7Script

symmetryNpcSubid8And9Script:
	loadscript scriptHelp.symmetryNpcSubid8And9Script

symmetryNpcSubid8And9Script_afterTuniNutRestored:
	rungenericnpclowindex <TX_2d18

symmetryNpcSubidAScript:
	jumpifglobalflagset GLOBALFLAG_TUNI_NUT_PLACED, symmetryNpcSubidAOrBScript_afterTuniNutRestored
	rungenericnpclowindex <TX_2d20

symmetryNpcSubidBScript:
	jumpifglobalflagset GLOBALFLAG_TUNI_NUT_PLACED, symmetryNpcSubidAOrBScript_afterTuniNutRestored
	rungenericnpclowindex <TX_2d21

symmetryNpcSubidAOrBScript_afterTuniNutRestored:
	rungenericnpclowindex <TX_2d22

symmetryNpcSubidCScript:
	rungenericnpclowindex <TX_2d2c


; ==============================================================================
; INTERACID_PIRATE_CAPTAIN
; ==============================================================================
pirateCaptainScript:
	loadscript scriptHelp.pirateCaptainScript


; ==============================================================================
; INTERACID_PIRATE
; ==============================================================================
pirateSubid0Script:
	rungenericnpc TX_3608
pirateSubid1Script:
	rungenericnpc TX_3609
pirateSubid2Script:
	rungenericnpc TX_360a
pirateSubid3Script:
	rungenericnpc TX_360b

pirateSubid4Script:
	initcollisions
	jumpifitemobtained TREASURE_TOKAY_EYEBALL, @haveEyeball
	rungenericnpc TX_360d

@haveEyeball:
	checkabutton
	disableinput
	playsound SNDCTRL_STOPMUSIC

pirateSubid4Script_insertEyeball:
	orroomflag ROOMFLAG_80
	spawninteraction INTERACID_DECORATION, $06, $52, $6a
	playsound SND_OPENCHEST
	wait 60
	playsound SND_OPENING
	shakescreen 160
	wait 120
	setcoords $58, $58
	asm15 scriptHelp.pirate_openEyeballCave
	wait 60
	playsound SND_SOLVEPUZZLE
	resetmusic
	asm15 loseTreasure, TREASURE_TOKAY_EYEBALL
	enableinput
	scriptend


; ==============================================================================
; INTERACID_TINGLE
; ==============================================================================
tingleScript:
.ifndef REGION_JP
	enableinput
.endif
@loop:
	checkabutton
	jumpifitemobtained TREASURE_ISLAND_CHART, @alreadyGotChart
	jumpifglobalflagset GLOBALFLAG_MET_TINGLE, @notFirstMeeting

	; First meeting
	setglobalflag GLOBALFLAG_MET_TINGLE
	showtextnonexitablelowindex <TX_1e00
	scriptjump @respondToBeFriend

@notFirstMeeting:
	showtextnonexitablelowindex <TX_1e01

@respondToBeFriend:
	setdisabledobjectsto11
	jumptable_memoryaddress wSelectedTextOption
	.dw @willBeFriend
	.dw @wontBeFriend

@wontBeFriend:
	showtextlowindex <TX_1e03
	scriptjump @endConversation

@willBeFriend:
	disableinput
	showtextlowindex <TX_1e02
	checktext
	giveitem TREASURE_OBJECT_ISLAND_CHART_00
	wait 1
	checktext
	showtextlowindex <TX_1e04
	callscript @koolooLimpah
	wait 60

	; Tell Ricky to go away?
	writememory w1Companion.var03, $02
	setdisabledobjectsto11
	writememory w1Companion.state, $0a

	scriptjump @loop

@alreadyGotChart:
.ifdef REGION_JP
	setdisabledobjectsto11
.else
	disableinput
.endif
	jumpifobjectbyteeq Interaction.var3e, $00, @notEnoughSeedTypes
	jumptable_objectbyte Interaction.var3d
	.dw @haveLevel1Satchel
	.dw @haveLevel2Satchel
	.dw @haveLevel3Satchel

@alreadyGotSatchelUpgrade:
	showtextlowindex <TX_1e08
	scriptjump @endConversation

@notEnoughSeedTypes:
	showtextlowindex <TX_1e04

@endConversation:
	checktext
	callscript @koolooLimpah
	enableallobjects
	scriptjump tingleScript

@haveLevel1Satchel:
	jumpifglobalflagset GLOBALFLAG_GOT_SATCHEL_UPGRADE, @alreadyGotSatchelUpgrade
	showtextnonexitablelowindex <TX_1e06
	jumptable_memoryaddress wSelectedTextOption
	.dw @acceptUpgrade
	.dw @dontAcceptUpgrade

@dontAcceptUpgrade:
	showtextlowindex <TX_1e03
	scriptjump @endConversation

@acceptUpgrade:
	setglobalflag GLOBALFLAG_GOT_SATCHEL_UPGRADE
	showtextlowindex <TX_1e07

@giveSatchelUpgrade:
	writeobjectbyte Interaction.var3f, $01
	setanimation $03
	showtextlowindex <TX_1e0c
	checktext
@waitForAnimation:
	jumpifobjectbyteeq Interaction.var3f, $00, ++
	wait 1
	scriptjump @waitForAnimation
++
	asm15 scriptHelp.tingle_createGlowAroundLink
	wait 120
	giveitem TREASURE_OBJECT_SEED_SATCHEL_UPGRADE
	checktext
	asm15 refillSeedSatchel
	jumpifobjectbyteeq Interaction.var3d, $02, @haveLevel3Satchel
	enableallobjects
	scriptjump tingleScript


@haveLevel2Satchel:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @postgame
	scriptjump @haveLevel1Satchel

@postgame:
	showtextlowindex <TX_1e09
	jumptable_memoryaddress wSelectedTextOption
	.dw @enterSecret
	.dw @dontEnterSecret

@dontEnterSecret:
	showtextlowindex <TX_1e0a
	scriptjump @endConversation

@enterSecret:
	askforsecret TINGLE_SECRET
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @validSecret
	showtextlowindex <TX_1e0d
	scriptjump @endConversation

@validSecret:
	showtextlowindex <TX_1e0e
	setglobalflag GLOBALFLAG_BEGAN_TINGLE_SECRET
	scriptjump @giveSatchelUpgrade


@haveLevel3Satchel:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @showReturnSecret
	scriptjump @alreadyGotSatchelUpgrade

@showReturnSecret:
	generatesecret TINGLE_RETURN_SECRET
	setglobalflag GLOBALFLAG_DONE_TINGLE_SECRET
	showtextlowindex <TX_1e0f
	scriptjump @endConversation


@koolooLimpah:
	writeobjectbyte Interaction.var3f, $01
	setanimation $03
	showtextlowindex <TX_1e05
	checktext
@waitUntilKoolooLimpahAnimationDone:
	jumpifobjectbyteeq Interaction.var3f, $00, ++
	wait 1
	scriptjump @waitUntilKoolooLimpahAnimationDone
++
	retscript


; ==============================================================================
; INTERACID_SYRUP_CUCCO
; ==============================================================================
syrupCuccoScript_awaitingMushroomText:
syrupCuccoScript_triedToSteal:
	showtext TX_0d09
	scriptend


; ==============================================================================
; INTERACID_TROY
; ==============================================================================

troySubid0Script:
	loadscript scriptHelp.troySubid0Script

troySubid1Script:
	loadscript scriptHelp.troySubid1Script


; ==============================================================================

; Used by linked game NPCs that give secrets.
; The npcs set "var3f" to the "secret index" (corresponds to wShortSecretIndex) before
; running this script.
linkedGameNpcScript:
	asm15 scriptHelp.linkedNpc_checkShouldSpawn
	jumpifmemoryset wcddb, $80, stubScript

	initcollisions
	asm15 scriptHelp.linkedNpc_initHighTextIndex

@offerSecret:
	asm15 scriptHelp.linkedNpc_calcLowTextIndex, $00
	checkabutton
	disableinput
	showloadedtext
	wait 20
	jumpiftextoptioneq $00, @answeredYes

	; Answered no
	addobjectbyte Interaction.textID, $01
	showloadedtext
	enableinput
	scriptjump @offerSecret

@answeredYes:
	asm15 scriptHelp.linkedNpc_checkHasExtraTextBox
	jumpifmemoryset wcddb, $80, @generateSecret

@showExtraText: ; Only some NPCs have this extra text box
	asm15 scriptHelp.linkedNpc_calcLowTextIndex, $02
	showloadedtext
	wait 20
	jumpiftextoptioneq $01, @showExtraText

@generateSecret:
	asm15 scriptHelp.linkedNpc_generateSecret
	asm15 scriptHelp.linkedNpc_calcLowTextIndex, $03

@tellSecret:
	showloadedtext
	wait 20
	jumpiftextoptioneq $01, @tellSecret

	asm15 scriptHelp.linkedNpc_calcLowTextIndex, $04
	showloadedtext
	enableinput
	asm15 scriptHelp.linkedNpc_checkHasExtraTextBox
	jumpifmemoryset wcddb, $80, @offerSecret

	checkabutton
	disableinput
	scriptjump @answeredYes


; ==============================================================================
; INTERACID_PLEN
; ==============================================================================
plenSubid0Script:
	loadscript scriptHelp.plenSubid0Script


; ==============================================================================
; INTERACID_GREAT_FAIRY
; ==============================================================================
greatFairySubid0Script:
	asm15 scriptHelp.linkedNpc_checkShouldSpawn
	jumpifmemoryset wcddb, $80, stubScript
	asm15 objectSetInvisible
	writeobjectbyte Interaction.var3e, $01

@waitLoop:
	asm15 scriptHelp.greatFairy_checkScreenIsScrolling
	jumpifmemoryset wcddb, $80, @spawnIn
	wait 1
	scriptjump @waitLoop

@spawnIn:
	playsound SND_KILLENEMY ; Why?
	createpuff
	wait 32
	setmusic MUS_FAIRY_FOUNTAIN
	asm15 objectSetVisible
	writeobjectbyte Interaction.var3e, $00
	scriptjump linkedGameNpcScript


; ==============================================================================
; INTERACID_SLATE_SLOT
; ==============================================================================
slateSlotScript:
	rungenericnpc TX_5111

slateSlotScript_placeSlate:
	asm15 scriptHelp.slateSlot_placeSlate
	enableinput
	scriptend


; ==============================================================================
; INTERACID_MISCELLANEOUS_2
; ==============================================================================

; Graveyard gate opening cutscene
interactiondcSubid01Script:
	checkcfc0bit 0
	setmusic SNDCTRL_STOPMUSIC
	wait 60
	asm15 scriptHelp.interactiondc_removeGraveyardGateTiles1
	wait 45
	asm15 scriptHelp.interactiondc_removeGraveyardGateTiles2
	wait 60
	resetmusic
	playsound SND_SOLVEPUZZLE
	enableinput
	scriptend


; ==============================================================================
; INTERACID_KNOW_IT_ALL_BIRD
; ==============================================================================
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
