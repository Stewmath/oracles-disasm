; Scripts for interactions are in this file. You may want to cross-reference with the
; corresponding code for the script to get the full picture (search for INTERACID_X in
; main.s to find the code).

stubScript:
	scriptend

genericNpcScript:
	initcollisions
--
	checkabutton
	showloadedtext
	jump2byte --


; ==============================================================================
; INTERACID_FARORE
; ==============================================================================

faroreScript:
	jumptable_memoryaddress wIsLinkedGame
	.dw _faroreUnlinked
	.dw _faroreLinked

; When talking to farore in a completed unlinked game, you can tell her secrets, but all
; she'll do is direct you to the person you're supposed to tell them to.
_faroreUnlinked:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME @finishedGame
	rungenericnpclowindex <TX_5501

@finishedGame:
	initcollisions
@npcLoop:
	enableinput
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_5502
	jumpiftextoptioneq $00 @askForPassword

@offerHolodrumSecret:
	showtextlowindex <TX_5519
	jumpiftextoptioneq $00 @sayHolodrumSecret
	showtextlowindex <TX_5505
	jump2byte @npcLoop

@sayHolodrumSecret:
	asm15 scriptHlp.faroreGenerateGameTransferSecret
	showtextlowindex <TX_551a
	jump2byte @npcLoop

@askForPassword:
	askforsecret $ff
	asm15 scriptHlp.faroreCheckSecretValidity
	jumptable_objectbyte Interaction.var3f
	.dw @offerHolodrumSecret
	.dw @offerHolodrumSecret
	.dw @offerHolodrumSecret
	.dw @secretOK
	.dw @wrongGame
	.dw @offerHolodrumSecret

@wrongGame: ; A Seasons secret was given in Ages.
	showtextlowindex <TX_550b
	jump2byte @offerHolodrumSecret

@secretOK: ; The secret is fine, but you're supposed to tell it to someone else.
	asm15 scriptHlp.faroreShowTextForSecretHint
	wait 30
	showtextlowindex <TX_5504
	jump2byte @offerHolodrumSecret


; When talking to Farore in a linked game, you can tell her secrets and she'll respond by
; giving you an item if it's correct.
_faroreLinked:
	initcollisions
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_5506
	jump2byte ++
@npcLoop:
	enableinput
	checkabutton
	disableinput
	jumpifglobalflagset GLOBALFLAG_SECRET_CHEST_WAITING @waitForLinkToOpenChest
++
	showtextlowindex <TX_5507 ; Do you know a secret?
	jumpiftextoptioneq $00 @showPasswordScreen
	showtextlowindex <TX_5508 ; Come back anytime
	jump2byte @npcLoop

@showPasswordScreen:
	askforsecret $ff
	asm15 scriptHlp.faroreCheckSecretValidity
	jumptable_objectbyte $7f
	.dw @script4667
	.dw @secretOK
	.dw @alreadyToldSecret
	.dw @script4667
	.dw @wrongGame
	.dw @secretNotActive

@script4667:
	showtextlowindex <TX_5505
	jump2byte @npcLoop

@secretOK:
	asm15 scriptHlp.faroreSpawnSecretChest
	checkcfc0bit 1
	xorcfc0bit 1
	enableinput
	jump2byte @npcLoop

@alreadyToldSecret: ; The secret has already been told to farore
	showtextlowindex <TX_550c
	jump2byte @npcLoop

@wrongGame: ; A secret for Seasons was told in Ages
	showtextlowindex <TX_550b
	jump2byte @npcLoop

@secretNotActive: ; Need to talk to the corresponding npc before you can tell the secret
	showtextlowindex <TX_551c
	jump2byte @npcLoop

@waitForLinkToOpenChest: ; A chest exists already, waiting for Link to open it
	showtextlowindex <TX_550a
	jump2byte @npcLoop


; ==============================================================================
; INTERACID_DUNGEON_STUFF
; ==============================================================================

dropSmallKeyWhenNoEnemiesScript:
	stopifitemflagset ; Stop if already got the key
	checknoenemies
	spawnitem TREASURE_SMALL_KEY, $01
	scriptend

createChestWhenNoEnemiesScript:
	stopifitemflagset ; Stop if already opened the chest
	setcollisionradii $04, $06
	checknoenemies
	playsound SND_SOLVEPUZZLE
	createpuff
	wait 30
	settilehere TILEINDEX_CHEST
	setstate $ff
	scriptend

setRoomFlagBit7WhenNoEnemiesScript:
	stopifroomflag80set
	checknoenemies
	orroomflag $80
	scriptend


; ==============================================================================
; INTERACID_FARORES_MEMORY
; ==============================================================================
faroresMemoryScript:
	initcollisions
--
	enableinput
	checkabutton
	setdisabledobjectsto91
	showtext TX_551b
	jumpiftextoptioneq $00 @openSecretList
	wait 8
	jump2byte --

@openSecretList:
	asm15 openMenu $0a
	wait 8
	jump2byte --


; ==================================================
; INTERACID_DOOR_CONTROLLER.
; ==================================================
;
; Door opener/closer scripts.
;
; States:
;   $01: does nothing except run the script
;   $02: opens the door
;   $03: closes the door
;
; Variables:
;   angle: the type and direction of door (see interactionTypes.s)
;   speed: for subids $14-$17, this is the number of torches that must be lit.
;   var3d: Bitmask to check on wActiveTriggers (value of "X" parameter converted to
;          a bitmask)
;   var3e: Short-form position of the tile the door is on (value of "Y" parameter)
;   var3f: Value of "X" parameter (a number from 0-7 corresponding to a switch; see
;          var3d)


_doorController_updateRespawnWhenLinkNotTouching:
	checknotcollidedwithlink_ignorez
	asm15 scriptHlp.doorController_updateLinkRespawn
	retscript


; Subid $00: door just opens.
doorOpenerScript:
	setstate $ff
	scriptend


; Subids $04-$07:
;   Door is controlled by a bit in "wActiveTriggers" (uses the bitmask in var3d).

; Subid $04
doorController_controlledByTriggers_up:
	setcollisionradii $0a $08
	setangle $10
	jump2byte _doorController_controlledByTriggers

; Subid $05
doorController_controlledByTriggers_right:
	setcollisionradii $08 $0a
	setangle $12
	jump2byte _doorController_controlledByTriggers

; Subid $06
doorController_controlledByTriggers_down:
	setcollisionradii $0a $08
	setangle $14
	jump2byte _doorController_controlledByTriggers

; Subid $07
doorController_controlledByTriggers_left:
	setcollisionradii $08 $0a
	setangle $16

_doorController_controlledByTriggers:
	callscript _doorController_updateRespawnWhenLinkNotTouching
@loop:
	asm15 scriptHlp.doorController_decideActionBasedOnTriggers
	jumptable_memoryaddress $cfc1
	.dw @loop
	.dw @open
	.dw @close
@open:
	playsound SND_SOLVEPUZZLE
	setstate $02
	jump2byte @loop
@close:
	setstate $03
	jump2byte @loop


; Subids $08-$0b:
;   Door shuts itself until [wNumEnemies] == 0.

_doorController_shutUntilEnemiesDead:
	callscript _doorController_updateRespawnWhenLinkNotTouching
	jumpifnoenemies @end
	setstate $03
	checknoenemies
	playsound SND_SOLVEPUZZLE
	wait 8
	setstate $ff
@end:
	scriptend

_doorController_open:
	setstate $02
	scriptend

; Subid $08
doorController_shutUntilEnemiesDead_up:
	setcollisionradii $0a $08
	setangle $10
	jumpifnoenemies _doorController_open
	jump2byte _doorController_shutUntilEnemiesDead

; Subid $09
doorController_shutUntilEnemiesDead_right:
	setcollisionradii $08 $0a
	setangle $12
	jumpifnoenemies _doorController_open
	jump2byte _doorController_shutUntilEnemiesDead

; Subid $0a
doorController_shutUntilEnemiesDead_down:
	setcollisionradii $0a $08
	setangle $14
	jumpifnoenemies _doorController_open
	jump2byte _doorController_shutUntilEnemiesDead

; Subid $0b
doorController_shutUntilEnemiesDead_left:
	setcollisionradii $08 $0a
	setangle $16
	jumpifnoenemies _doorController_open
	jump2byte _doorController_shutUntilEnemiesDead

_doorController_openOnMinecartCollision:
	asm15 scriptHlp.doorController_checkMinecartCollidedWithDoor
	jumptable_memoryaddress $cfc1
	.dw _doorController_openOnMinecartCollision
	.dw @incState

@incState:
	setstate $ff

_doorController_closeDoorWhenLinkNotTouching:
	callscript _doorController_updateRespawnWhenLinkNotTouching
	setstate $03
	scriptend

_doorController_minecart:
	asm15 scriptHlp.doorController_checkTileIsMinecartTrack
	jumptable_memoryaddress $cfc1
	.dw _doorController_openOnMinecartCollision ; Not minecart track (door is closed)
	.dw _doorController_closeDoorWhenLinkNotTouching ; Minecart track (door is open)


; Subids $08-$0f:
;   Minecart door; opens when a minecart collides with it

; Subid $0c
doorController_minecartDoor_up:
	setcollisionradii $10 $08
	setangle $18
	jump2byte _doorController_minecart

; Subid $0d
doorController_minecartDoor_right:
	setcollisionradii $08 $0e
	setangle $1a
	jump2byte _doorController_minecart

; Subid $0e
doorController_minecartDoor_down:
	setcollisionradii $0f $08
	setangle $1c
	jump2byte _doorController_minecart

; Subid $0f
doorController_minecartDoor_left:
	setcollisionradii $08 $0f
	setangle $1e
	jump2byte _doorController_minecart


; Subids $10-$13:
;   Door which automatically closes when Link walks out of that tile.
;   When Link transitions onto a shutter door tile, the game automatically removes that
;   tile and replaces it with an interaction of this type.

_doorController_closeDoorWhenLinkNotTouchingAndFlipcfc0:
	callscript _doorController_updateRespawnWhenLinkNotTouching
	setstate $03
	xorcfc0bit 0
	scriptend

; Subid $10
doorController_closeAfterLinkEnters_up:
	setcollisionradii $0c $08
	setangle $10
	jump2byte _doorController_closeDoorWhenLinkNotTouchingAndFlipcfc0

; Subid $11
doorController_closeAfterLinkEnters_right:
	setcollisionradii $08 $0c
	setangle $12
	jump2byte _doorController_closeDoorWhenLinkNotTouchingAndFlipcfc0

; Subid $12
doorController_closeAfterLinkEnters_down:
	setcollisionradii $0c $08
	setangle $14
	jump2byte _doorController_closeDoorWhenLinkNotTouchingAndFlipcfc0

; Subid $13
doorController_closeAfterLinkEnters_left:
	setcollisionradii $08 $0c
	setangle $16
	jump2byte _doorController_closeDoorWhenLinkNotTouchingAndFlipcfc0


; Subids $14-$17:
;   Door opens when a number of torches are lit.

_doorController_shutUntilTorchesLit:
	callscript _doorController_updateRespawnWhenLinkNotTouching
	setstate $03
@loop:
	asm15 scriptHlp.doorController_checkEnoughTorchesLit
	jumptable_memoryaddress $cec0
	.dw @loop
	.dw @torchesLit

@torchesLit:
	wait 30
	playsound SND_SOLVEPUZZLE
	setstate $ff
	scriptend

; Subid $14
doorController_openWhenTorchesLit_up_2Torches:
	setcollisionradii $0a $08
	setangle $10
	setspeed $02
	jump2byte _doorController_shutUntilTorchesLit

; Subid $15
doorController_openWhenTorchesLit_left_2Torches:
	setcollisionradii $08 $0a
	setangle $16
	setspeed $02
	jump2byte _doorController_shutUntilTorchesLit

; Subid $16
doorController_openWhenTorchesLit_down_1Torch:
	setcollisionradii $0a $08
	setangle $14
	setspeed $01
	jump2byte _doorController_shutUntilTorchesLit

; Subid $17
doorController_openWhenTorchesLit_left_1Torch:
	setcollisionradii $08 $0a
	setangle $16
	setspeed $01
	jump2byte _doorController_shutUntilTorchesLit



; ==============================================================================
; INTERACID_SHOPKEEPER
; ==============================================================================

shopkeeperScript_lynnaShopWelcome:
	showtextlowindex <TX_0e00
	scriptend

shopkeeperScript_advanceShopWelcome:
	showtextlowindex <TX_0e20
	scriptend

shopkeeperScript_boughtEverything:
	showtextlowindex <TX_0e26
	scriptend

shopkeeperScript_purchaseItem:
	jumptable_objectbyte Interaction.var37
	.dw @buyRingBoxUpgrade
	.dw @buy3Hearts
	.dw @buyHiddenShopGashaSeed1
	.dw @buyL1Shield
	.dw @buy10Bombs
	.dw @buyHiddenShopRing
	.dw @buyHiddenShopGashaSeed2
	.dw @buyRingBoxUpgrade
	.dw @buyRingBoxUpgrade
	.dw @buyRingBoxUpgrade
	.dw @buyRingBoxUpgrade
	.dw @buyRingBoxUpgrade
	.dw @buyRingBoxUpgrade
	.dw @buyStrangeFlute
	.dw @buyAdvanceShopGashaSeed
	.dw @buyAdvanceShopGbaRing
	.dw @buyAdvanceShopRing
	.dw @buyL2Shield
	.dw @buyL3Shield
	.dw @buyNormalShopGashaSeed
	.dw @buyRingBoxUpgrade
	.dw @buyHiddenShopHeartPiece

@buyRingBoxUpgrade:
	jumpifitemobtained TREASURE_RING_BOX, @haveRingBox

	; No ring box, can't buy
	showtextlowindex <TX_0e0b
	writeobjectbyte Interaction.var3a, $ff
	scriptend

@haveRingBox:
	showtextnonexitablelowindex <TX_0e09
	callscript _shopkeeperConfirmPurchase
	ormemory wBoughtShopItems1, $01
	scriptend

@buy3Hearts:
	showtextnonexitablelowindex <TX_0e02
	callscript _shopkeeperConfirmPurchase
	scriptend

@buyL1Shield:
	showtextnonexitablelowindex <TX_0e03
	callscript _shopkeeperConfirmPurchase
	scriptend

@buy10Bombs:
	showtextnonexitablelowindex <TX_0e04
	callscript _shopkeeperConfirmPurchase
	scriptend

@buyHiddenShopGashaSeed1:
	showtextnonexitablelowindex <TX_0e1d
	callscript _shopkeeperConfirmPurchase
	ormemory wBoughtShopItems1, $02
	scriptend

@buyHiddenShopRing:
	showtextnonexitablelowindex <TX_0e25
	callscript _shopkeeperConfirmPurchase
	ormemory wBoughtShopItems1, $08
	scriptend

@buyHiddenShopGashaSeed2:
	showtextnonexitablelowindex <TX_0e1d
	callscript _shopkeeperConfirmPurchase
	ormemory wBoughtShopItems1, $04
	scriptend

@buyStrangeFlute:
	showtextnonexitablelowindex <TX_0e1b
	callscript _shopkeeperConfirmPurchase
	scriptend

@buyAdvanceShopGashaSeed:
	showtextnonexitablelowindex <TX_0e1d
	callscript _shopkeeperConfirmPurchase
	ormemory wBoughtShopItems2, $01
	scriptend

@buyAdvanceShopGbaRing:
	showtextnonexitablelowindex <TX_0e23
	callscript _shopkeeperConfirmPurchase
	ormemory wBoughtShopItems2, $02
	scriptend

@buyAdvanceShopRing:
	showtextnonexitablelowindex <TX_0e25
	callscript _shopkeeperConfirmPurchase
	ormemory wBoughtShopItems2, $04
	scriptend

@buyL2Shield:
	showtextnonexitablelowindex <TX_0e29
	callscript _shopkeeperConfirmPurchase
	scriptend

@buyL3Shield:
	showtextnonexitablelowindex <TX_0e2a
	callscript _shopkeeperConfirmPurchase
	scriptend

@buyNormalShopGashaSeed:
	showtextnonexitablelowindex <TX_0e1d
	callscript _shopkeeperConfirmPurchase
	ormemory wBoughtShopItems1, $20
	scriptend

@buyHiddenShopHeartPiece:
	showtextnonexitablelowindex <TX_0e01
	callscript _shopkeeperConfirmPurchase
	ormemory wBoughtShopItems2, $40
	scriptend

_shopkeeperConfirmPurchase:
	jumpiftextoptioneq $00 @answeredYes

	; Answered no
	writememory $cbad, $03
	writememory wTextIsActive, $01
	writeobjectbyte Interaction.var3a, $ff
	scriptend

@answeredYes:
	jumpifmemoryeq wShopHaveEnoughRupees, $00, _shopkeeperAttemptToPurchaseItem
	showtextlowindex <TX_0e06


_shopkeeperCancelPurchase:
	writeobjectbyte Interaction.var3a, $ff
	setdisabledobjectsto00
	scriptend


_shopkeeperNotEnoughRupeesToReplayChestGame:
	callscript _shopkeeperReturnToDeskAfterChestGame

_shopkeeperNotEnoughRupees:
	showtextlowindex <TX_0e06
	jump2byte _shopkeeperCancelPurchase


_shopkeeperAttemptToPurchaseItem:
	jumptable_objectbyte Interaction.var38
	.dw @canBuy
	.dw _shopkeeperCantBuy

@canBuy:
	writememory wTextIsActive, $01
	writeobjectbyte Interaction.var3a, $01
	disablemenu
	retscript


; Can't buy an item because Link already has it
_shopkeeperCantBuy:
	writememory $cbad $02
	writememory wTextIsActive, $01
	writeobjectbyte Interaction.var3a, $ff
	scriptend


; Advance shop shopkeeper prevents Link from stealing something
shopkeeperSubid2Script_stopLink:
	setspeed SPEED_200
	playsound SND_CLINK
	movedown $10
	moveright $18
	showtextlowindex <TX_0e07
	moveleft $18
	moveup $10
	setangleandanimation $08
	setdisabledobjectsto00
	scriptend

; Lynna city downstairs shopkeeper prevents Link from stealing something
shopkeeperSubid1Script_stopLink:
	setspeed SPEED_200
	moveup $10
	showtextlowindex <TX_0e07
	setdisabledobjectsto11
	movedown $10
	setangleandanimation $08
	setdisabledobjectsto00
	scriptend

; Lynna city shopkeeper prevents Link from stealing something
shopkeeperSubid0Script_stopLink:
	setspeed SPEED_200
	playsound SND_CLINK
	movedown $08
	moveleft $18
	showtextlowindex <TX_0e07
	moveright $18
	moveup $08
	setangleandanimation $18
	setdisabledobjectsto00
	scriptend


; Prompt to play the chest-choosing minigame
shopkeeperChestGameScript:
	jumpifc6xxset <wBoughtShopItems1, $80, @notFirstTime

	showtextlowindex <TX_0e0d
	ormemory wBoughtShopItems1, $80
	jump2byte ++

@notFirstTime:
	showtextlowindex <TX_0e0e
++
	setdisabledobjectsto11
	jumpiftextoptioneq $00 @answeredYes

	; Answered no
	showtextlowindex <TX_0e11
	setdisabledobjectsto00
	scriptend

@answeredYes:
	jumpifmemoryeq $ccd5 $01 _shopkeeperNotEnoughRupees
	asm15 scriptHlp.shopkeeper_take10Rupees
	setspeed SPEED_200
	setcollisionradii $06 $06
	moveup    $08
	moveright $19
	moveup    $1a
	moveright $11
	movedown  $08
	jump2byte ++

@playAgain:
	asm15 scriptHlp.shopkeeper_take10Rupees
++
	setangleandanimation $08
	writeobjectbyte Interaction.state2, $02 ; Signal to close whichever chest he faces
	writeobjectbyte Interaction.state,  $05
	wait 60

	setangleandanimation $18
	wait 60

	setangleandanimation $10
	writeobjectbyte Interaction.var3c, $00 ; Initialize to round 0
	showtextlowindex <TX_1e10

	setdisabledobjectsto00
	ormemory wInShop, $80
	writeobjectbyte Interaction.state2, $00
	writeobjectbyte Interaction.state,  $05
	; Script will stop here since state has been changed.


; Opened the incorrect chest in the chest minigame.
shopkeeperScript_openedWrongChest:
	setdisabledobjectsto11
	showtextlowindex <TX_0e17
	jumpiftextoptioneq $01 @selectedNo

	; Selected "Yes" to play again
	jumpifmemoryeq wShopHaveEnoughRupees, $01, _shopkeeperNotEnoughRupeesToReplayChestGame
	jump2byte shopkeeperChestGameScript@playAgain

@selectedNo:
	callscript _shopkeeperReturnToDeskAfterChestGame
	setdisabledobjectsto00
	scriptend


; Opened the correct chest in the chest minigame.
shopkeeperScript_openedCorrectChest:
	setdisabledobjectsto11
	jumptable_objectbyte Interaction.var3c
	.dw @nextRound
	.dw @nextRound
	.dw @nextRound
	.dw @round3
	.dw @round4
	.dw @round5

@nextRound:
	showtextlowindex <TX_0e13
	setangleandanimation $08
	writeobjectbyte Interaction.state2, $02 ; Signal to close whichever chest he faces
	writeobjectbyte Interaction.state,  $05
	wait 60

	setangleandanimation $18
	wait 60

	setangleandanimation $10
	showtextlowindex <TX_0e18
	setdisabledobjectsto00
	scriptend

@round3:
	showtextlowindex <TX_0e12
	jumpiftextoptioneq $00, @nextRound

	; Selected no; get round 3 prize
	showtextlowindex <TX_0e14
	writeobjectbyte Interaction.var3f, $03 ; Tier 3 ring
	callscript _shopkeeperReturnToDeskAfterChestGame
	setdisabledobjectsto00
	scriptend

@round4:
	showtextlowindex <TX_0e15
	jumpiftextoptioneq $00, @nextRound

	; Selected no; get round 4 prize
	showtextlowindex <TX_0e14
	writeobjectbyte Interaction.var3f, $02 ; Tier 2 ring
	callscript _shopkeeperReturnToDeskAfterChestGame
	setdisabledobjectsto00
	scriptend

@round5:
	; Get round 5 prize
	showtextlowindex <TX_0e16
	writeobjectbyte Interaction.var3f, $01 ; Tier 1 ring
	callscript _shopkeeperReturnToDeskAfterChestGame
	setdisabledobjectsto00
	scriptend


; Linked talked to the shopkeep in the middle of the chest game.
shopkeeperScript_talkDuringChestGame:
	showtextlowindex <TX_0e1a
	writeobjectbyte Interaction.state2, $01
	writeobjectbyte Interaction.state,  $05
	; Script stops here since state has been changed.


_shopkeeperReturnToDeskAfterChestGame:
	moveup   $08
	moveleft $11
	movedown $1a
	moveleft $19
	movedown $08
	setangleandanimation $08
	setcollisionradii $06, $14
	retscript


script49b5:
	showtextlowindex $28
	scriptend
script49b8:
	setcollisionradii $09 $09
script49bb:
	wait 30
script49bc:
	checkcollidedwithlink_onground
	ormemory $cc95 $80
	asm15 dropLinkHeldItem
	setanimationfromangle
	setstate $ff
script49c8:
	playsound $06
	asm15 $4248
	wait 180
	wait 180
	playsound $b4
	wait 20
	playsound $b4
	wait 20
	playsound $b4
	wait 40
	playsound $b4
	asm15 $4250
	scriptend
script49de:
	setcollisionradii $12 $06
	makeabuttonsensitive
script49e2:
	enableinput
	checkabutton
	disableinput
	jumpifglobalflagset $08 script4a40
	jumpifmemoryeq $cc01 $00 script4a08
	jumpifmemoryset $c615 $01 script49f7
	jump2byte script4a08
script49f7:
	showtextlowindex $3e
	jumpifobjectbyteeq $76 $01 script4a04
	showtextlowindex $3b
	asm15 $4256
	wait 1
script4a04:
	setdisabledobjectsto11
	checktext
	jump2byte script4a37
script4a08:
	showtextnonexitablelowindex $00
script4a0a:
	jumpiftextoptioneq $00 script4a12
	showtextnonexitablelowindex $3a
	jump2byte script4a0a
script4a12:
	jumpifobjectbyteeq $76 $01 script4a1f
	showtextlowindex $3b
	asm15 $4256
	wait 1
	setdisabledobjectsto11
	checktext
script4a1f:
	showtextlowindex $3f
	asm15 $42ed
	wait 1
	setdisabledobjectsto11
	checktext
	showtextlowindex $33
	asm15 $426e $00
	wait 10
	showtextlowindex $13
	asm15 $426e $01
	wait 10
	showtextlowindex $08
script4a37:
	setglobalflag $08
	ormemory $c615 $01
	enableinput
	jump2byte script49e2
script4a40:
	asm15 $42b2
	jumptable_objectbyte $7b
	.dw script4a4d
	.dw script4a51
	.dw script4a55
	.dw script4a5d
script4a4d:
	showtextlowindex $36
	jump2byte script4a57
script4a51:
	showtextlowindex $37
	jump2byte script4a57
script4a55:
	showtextlowindex $39
script4a57:
	checktext
	asm15 $42f5
	jump2byte script49e2
script4a5d:
	showtextnonexitablelowindex $03
	jumpiftextoptioneq $00 script4a6c
	jumpiftextoptioneq $01 script4a77
	enableinput
	showtextlowindex $08
	jump2byte script49e2
script4a6c:
	jumpifobjectbyteeq $77 $00 script4a94
	asm15 $426e $00
	jump2byte script4a80
script4a77:
	jumpifobjectbyteeq $78 $00 script4a98
	asm15 $426e $01
script4a80:
	wait 10
	jumpifglobalflagset $09 script4a8a
	showtextlowindex $08
	enableinput
	jump2byte script49e2
script4a8a:
	showtextlowindex $38
	checktext
	setglobalflag $89
	asm15 $42f1
	jump2byte script49e2
script4a94:
	showtextlowindex $14
	jump2byte script49e2
script4a98:
	showtextlowindex $15
	jump2byte script49e2
script4a9c:
	showtextnonexitablelowindex $09
	jumpiftextoptioneq $00 script4aa8
	writememory $cba0 $01
	enableinput
	scriptend
script4aa8:
	wait 30
	showtextnonexitablelowindex $0a
	jumpiftextoptioneq $01 script4ab3
	showtextnonexitablelowindex $0b
	jump2byte script4ab5
script4ab3:
	showtextnonexitablelowindex $0c
script4ab5:
	jumpiftextoptioneq $00 script4aa8
	writememory $cba0 $01
	scriptend
script4abe:
	showtextnonexitablelowindex $1f
	jumpiftextoptioneq $01 script4ad2
	jump2byte script4acc
script4ac6:
	showtextnonexitablelowindex $24
	jumpiftextoptioneq $02 script4ad2
script4acc:
	setdisabledobjectsto11
	asm15 $428b
	wait 1
	scriptend
script4ad2:
	showtextlowindex $2e
	scriptend
script4ad5:
	showtextlowindex $0f
	scriptend
script4ad8:
	showtextlowindex $31
	scriptend
script4adb:
	showtextlowindex $2a
	scriptend
script4ade:
	showtextnonexitablelowindex $18
	jumpiftextoptioneq $02 script4b00
	jumpiftextoptioneq $00 script4af3
	asm15 $4280
script4aeb:
	showtextnonexitablelowindex $1d
	jumpiftextoptioneq $00 script4aeb
	jump2byte script4b00
script4af3:
	asm15 $427b
	wait 1
	jumpifmemoryeq $cc89 $00 script4b03
	showtextlowindex $1e
	scriptend
script4b00:
	showtextlowindex $10
	scriptend
script4b03:
	showtextlowindex $27
	scriptend
script4b06:
	setdisabledobjectsto11
	showtextlowindex $23
	asm15 $42f5
	wait 1
	checktext
	setdisabledobjectsto00
	scriptend
script4b10:
	showtextlowindex $27
	scriptend
script4b13:
	wait 30
	showtext $550d
	jumpiftextoptioneq $00 script4b24
	asm15 $42fe
	asm15 saveFile
	wait 30
	jump2byte script4b2c
script4b24:
	wait 30
	showtext $550e
	jumpiftextoptioneq $00 script4b13
script4b2c:
	writememory $cfde $01
	scriptend
script4b31:
	writememory $cba0 $01
script4b35:
	checkabutton
	showtextnonexitablelowindex $19
	jumpiftextoptioneq $01 script4b31
	showtextlowindex $1a
	jump2byte script4b35
script4b40:
	writememory $cba0 $01
script4b44:
	checkabutton
	showtextnonexitablelowindex $20
	jumpiftextoptioneq $01 script4b40
script4b4b:
	showtextnonexitablelowindex $25
	jumpiftextoptioneq $01 script4b5d
	jumpiftextoptioneq $02 script4b40
	showtextnonexitablelowindex $3d
	jumpiftextoptioneq $01 script4b40
	jump2byte script4b4b
script4b5d:
	showtextnonexitablelowindex $26
	jumpiftextoptioneq $01 script4b40
	jump2byte script4b4b


.include "scripts/dungeonScripts.s"


; ==============================================================================
; INTERACID_BIPIN
; ==============================================================================

; Running around when baby just born
bipinScript0:
	setcollisionradii $06 $06
	makeabuttonsensitive
@loop:
	checkabutton
	jumpifmemoryeq wChildStatus $00 @stillUnnamed
	showtext TX_4301
	jump2byte @loop
@stillUnnamed:
	showtext TX_4300
	jump2byte @loop


; Bipin gives you a random tip
bipinScript1:
	initcollisions
@loop:
	checkabutton
	setdisabledobjectsto91
	setanimation $02
	asm15 scriptHlp.bipin_showText_subid1To9
	wait 30
	callscript _bipinSayRandomTip
	setdisabledobjectsto00
	jump2byte @loop


; Bipin just moved to Labrynna/Holodrum?
bipinScript2:
	initcollisions
@loop:
	checkabutton
	setdisabledobjectsto91
	asm15 scriptHlp.bipin_showText_subid1To9
	setdisabledobjectsto00
	jump2byte @loop

_bipinSayRandomTip:
	; Show a random text index from TX_4309-TX_4310
	writeobjectbyte  Interaction.textID+1, >TX_4300
	getrandombits    Interaction.textID,   $07
	addobjectbyte    Interaction.textID,   <TX_4309
	showloadedtext

	setanimation $03
	retscript


; "Past" version of Bipin who gives you a gasha seed
bipinScript3:
	loadscript scriptHlp.bipinScript3


; ==============================================================================
; INTERACID_ADLAR
; ==============================================================================
adlarScript:
	initcollisions
	jumptable_objectbyte Interaction.var38
	.dw @firstMeeting
	.dw @nayruPossessed
	.dw @queenPosessed
	.dw @queenMissing
	.dw @queenBackToNormal

@firstMeeting:
	checkabutton
	showtext TX_3710
	orroomflag $40
@nayruPossessed:
	checkabutton
	showtext TX_3711
	jump2byte @nayruPossessed

@queenPosessed:
	checkabutton
	showtext TX_3712
	jump2byte @queenPosessed

@queenMissing:
	checkabutton
	showtext TX_3716
	jump2byte @queenMissing

@queenBackToNormal:
	checkabutton
	showtext TX_3713
	jump2byte @queenBackToNormal


; ==============================================================================
; INTERACID_LIBRARIAN
; ==============================================================================
librarianScript:
	makeabuttonsensitive
@loop:
	checkabutton
	showloadedtext
	jump2byte @loop


; ==============================================================================
; INTERACID_BLOSSOM
; ==============================================================================

; Blossom asking you to name her child
blossomScript0:
	initcollisions
	asm15 scriptHlp.checkc6e2BitSet $00
	jumpifobjectbyteeq Interaction.var3b $01 @nameAlreadyGiven
@loop:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_4400

@askForName:
	asm15 scriptHlp.blossom_openNameEntryMenu
	wait 30
	jumptable_memoryaddress wTextInputResult
	.dw @validName
	.dw @invalidName

@invalidName:
	showtextlowindex <TX_440a
	enableinput
	jump2byte @loop

@validName:
	showtextlowindex <TX_4407
	disableinput
	jumptable_memoryaddress wSelectedTextOption
	.dw @nameConfirmed
	.dw @askForName

@nameConfirmed:
	asm15 scriptHlp.blossom_decideInitialChildStatus
	asm15 scriptHlp.setc6e2Bit $00
	asm15 scriptHlp.setNextChildStage $01
	wait 30
	showtextlowindex <TX_4408
	enableinput

@nameAlreadyGiven:
	checkabutton
	showtextlowindex <TX_4409
	jump2byte @nameAlreadyGiven


; Blossom asking for money to see a doctor
blossomScript1:
	initcollisions
	asm15 scriptHlp.checkc6e2BitSet $01
	jumpifobjectbyteeq Interaction.var3b $01 @alreadyGaveMoney
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
	asm15 scriptHlp.blossom_checkHasRupees RUPEEVAL_150
	jumpifobjectbyteeq Interaction.var3c $01 @notEnoughRupees
	asm15 removeRupeeValue RUPEEVAL_150
	asm15 scriptHlp.blossom_addValueToChildStatus $08
	asm15 scriptHlp.setc6e2Bit $01
	asm15 scriptHlp.setNextChildStage $02
	setdisabledobjectsto00
@gave150RupeesLoop:
	showtextlowindex <TX_440d
	checkabutton
	jump2byte @gave150RupeesLoop

@give50Rupees:
	asm15 scriptHlp.blossom_checkHasRupees RUPEEVAL_050
	jumpifobjectbyteeq Interaction.var3c $01 @notEnoughRupees
	asm15 removeRupeeValue RUPEEVAL_050
	asm15 scriptHlp.blossom_addValueToChildStatus $05
	asm15 scriptHlp.setc6e2Bit $01
	asm15 scriptHlp.setNextChildStage $02
	setdisabledobjectsto00
@gave50RupeesLoop:
	showtextlowindex <TX_440e
	checkabutton
	jump2byte @gave50RupeesLoop

@give10Rupees:
	asm15 scriptHlp.blossom_checkHasRupees RUPEEVAL_010
	jumpifobjectbyteeq Interaction.var3c $01 @notEnoughRupees
	asm15 removeRupeeValue RUPEEVAL_010
	asm15 scriptHlp.blossom_addValueToChildStatus $02
	asm15 scriptHlp.setc6e2Bit $01
	asm15 scriptHlp.setNextChildStage $02
	setdisabledobjectsto00
@gave10RupeesLoop:
	showtextlowindex <TX_440f
	checkabutton
	jump2byte @gave10RupeesLoop

@give1Rupee:
	asm15 scriptHlp.blossom_checkHasRupees RUPEEVAL_001
	jumpifobjectbyteeq Interaction.var3c $01 @notEnoughRupees
	asm15 removeRupeeValue RUPEEVAL_001
	asm15 scriptHlp.setc6e2Bit $01
	asm15 scriptHlp.setNextChildStage $02
	setdisabledobjectsto00
@gave1RupeeLoop:
	showtextlowindex <TX_4410
	checkabutton
	jump2byte @gave1RupeeLoop

@notEnoughRupees:
	wait 30
	showtextlowindex <TX_4432
	setdisabledobjectsto00
	jump2byte @loop

@selectedNo:
	wait 30
	showtextlowindex <TX_4411
	setdisabledobjectsto00
	jump2byte @loop

@alreadyGaveMoney:
	checkabutton
	showtextlowindex <TX_4431
	jump2byte @alreadyGaveMoney


; Blossom tells you that the baby has gotten better
blossomScript2:
	initcollisions
script4e08:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_4412
	asm15 scriptHlp.setNextChildStage $03
	setdisabledobjectsto00
	jump2byte script4e08


; Blossom asks you how to get the baby to sleep
blossomScript3:
	initcollisions
	asm15 scriptHlp.checkc6e2BitSet $02
	jumpifobjectbyteeq Interaction.var3b $01 @alreadyGaveAdvice
	checkabutton

	setdisabledobjectsto91
	showtextlowindex <TX_4413

	asm15 scriptHlp.setc6e2Bit $02
	asm15 scriptHlp.setNextChildStage $04

	jumptable_memoryaddress wSelectedTextOption
	.dw @sing
	.dw @play

@sing:
	wait 30
	showtextlowindex <TX_4414
	setdisabledobjectsto00
	jump2byte @alreadyGaveAdvice
@play:
	wait 30
	showtextlowindex <TX_4415
	asm15 scriptHlp.blossom_addValueToChildStatus $0a
	setdisabledobjectsto00

@alreadyGaveAdvice:
	checkabutton
	showtextlowindex <TX_4416
	jump2byte @alreadyGaveAdvice


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
	asm15 scriptHlp.checkc6e2BitSet $03
	jumptable_objectbyte Interaction.var03
	.dw @hyperactive
	.dw @shy
	.dw @curious

@hyperactive:
	jumpifobjectbyteeq Interaction.var3b $01 @hyperactiveResponseReceived

@hyperactiveLoop1:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_4419
	callscript @askAboutLinksBehaviour
	setdisabledobjectsto00
	jumpifobjectbyteeq Interaction.var3a $00 @hyperactiveLoop1

@hyperactiveResponseReceived:
	checkabutton
	showtextlowindex <TX_4422
	jump2byte @hyperactiveResponseReceived


@shy:
	jumpifobjectbyteeq Interaction.var3b $01 @shyReponseReceived

@shyLoop1:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_441a
	callscript @askAboutLinksBehaviour
	setdisabledobjectsto00
	jumpifobjectbyteeq Interaction.var3a $00 @shyLoop1

@shyReponseReceived:
	checkabutton
	showtextlowindex <TX_4423
	jump2byte @shyReponseReceived


@curious:
	jumpifobjectbyteeq Interaction.var3b $01 @curiousResponseReceived

@curiousLoop1:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_441b
	callscript @askAboutLinksBehaviour
	setdisabledobjectsto00
	jumpifobjectbyteeq Interaction.var3a $00 @curiousLoop1

@curiousResponseReceived:
	checkabutton
	showtextlowindex <TX_4424
	jump2byte @curiousResponseReceived


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
	asm15 scriptHlp.setc6e2Bit $03
	writeobjectbyte Interaction.var3a $01
	asm15 scriptHlp.blossom_addValueToChildStatus $08
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
	asm15 scriptHlp.setc6e2Bit $03
	writeobjectbyte Interaction.var3a $01
	asm15 scriptHlp.blossom_addValueToChildStatus $05
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
	asm15 scriptHlp.setc6e2Bit $03
	writeobjectbyte Interaction.var3a $01
	asm15 scriptHlp.blossom_addValueToChildStatus $01
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
	loadscript scriptHlp.veranFaceCutsceneScript


; ==============================================================================
; INTERACID_OLD_MAN_WITH_RUPEES
; ==============================================================================

oldManScript_givesRupees:
	initcollisions
	jumpifroomflagset $40 @alreadyGaveMoney
	checkabutton
	disableinput
	showtextlowindex <TX_3318
	asm15 scriptHlp.oldMan_giveRupees
	wait 8
	checkrupeedisplayupdated
	orroomflag $40
	enableinput

@alreadyGaveMoney:
	checkabutton
	showtextlowindex <TX_3319
	jump2byte @alreadyGaveMoney


oldManScript_takesRupees:
	initcollisions
	jumpifroomflagset $40 @alreadyTookMoney
	checkabutton
	disableinput
	showtextlowindex <TX_3315
	asm15 scriptHlp.oldMan_takeRupees
	jumpifobjectbyteeq Interaction.var3f $00 @linkIsBroke
	wait 8
	checkrupeedisplayupdated
	orroomflag $40
	enableinput

@alreadyTookMoney:
	checkabutton
	showtextlowindex <TX_3316
	jump2byte @alreadyTookMoney

@linkIsBroke:
	wait 30
	showtextlowindex <TX_3317
	enableinput
	jump2byte @alreadyTookMoney


; ==============================================================================
; INTERACID_SHOOTING_GALLERY
; ==============================================================================

shootingGalleryScript_humanNpc:
	setcollisionradii $06 $16
	makeabuttonsensitive

@loop:
	checkabutton
	disableinput
	showtext TX_0800
	wait 30
	jumpiftextoptioneq $00 @repliedYes

@repliedNo:
	showtext TX_0802
	enableinput
	wait 30
	writeobjectbyte Interaction.var31 $00
	jump2byte @loop

@tryAgain:
	disableinput
	showtext TX_081a
	wait 30
	jumpiftextoptioneq $00 @repliedYes
	jump2byte @repliedNo

@repliedYes:
	asm15 scriptHlp.shootingGallery_checkLinkHasRupees RUPEEVAL_10
	jumpifmemoryset $cddb $80 @enoughRupees

@notEnoughRupees:
	showtext TX_0803
	enableinput
	checkabutton
	jump2byte @notEnoughRupees

@enoughRupees:
	asm15 removeRupeeValue RUPEEVAL_10
	showtext TX_0801
	wait 30
	jumpiftextoptioneq $00 @beginGame

@giveExplanation:
	showtext TX_0804
	wait 30
	jumpiftextoptioneq $00 @beginGame
	jump2byte @giveExplanation

@beginGame:
	showtext TX_0805

_shootingGallery_fadeIntoGameWithSword:
	wait 40
	asm15 fadeoutToWhite
	checkpalettefadedone

	asm15 scriptHlp.shootingGallery_equipSword
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 scriptHlp.shootingGallery_initLinkPosition
	asm15 scriptHlp.shootingGallery_setEntranceTiles $02
	wait 20
	asm15 fadeinFromWhite
	checkpalettefadedone

_shootingGallery_beginGame:
	setmusic MUS_MINIGAME
	wait 40
	wait 30
	asm15 scriptHlp.shootingGallery_beginGame
	setdisabledobjectsto00
	scriptend



shootingGalleryScript_goronNpc:
	setcollisionradii $06 $16
	makeabuttonsensitive

@loop:
	checkabutton
	jumpifmemoryeq wShootingGallery.disableGoronNpcs $01 @loop

	disableinput
	jumpifroomflagset $20 @normalGame

; playing for lava juice

	showtext TX_24d4
	wait 30
	jumpiftextoptioneq $00 @answeredYes

	; Answered no
	showtext TX_24d5
	enableinput
	wait 30
	writeobjectbyte Interaction.var31 $00
	jump2byte @loop

@normalGame:
	showtext TX_24cf
	wait 30
	jumpiftextoptioneq $00 @answeredYes

@answeredNo:
	showtext TX_24d0
	enableinput
	wait 30
	writeobjectbyte $71 $00
	jump2byte @loop

@tryAgain:
	disableinput
	showtext TX_24df
	wait 30
	jumpiftextoptioneq $00 @answeredYes
	jump2byte @answeredNo

@answeredYes:
	asm15 scriptHlp.shootingGallery_checkLinkHasRupees RUPEEVAL_20
	jumpifmemoryset $cddb $80 @enoughRupees

@notEnoughRupees:
	showtext TX_24d2
	enableinput
	checkabutton
	jump2byte @notEnoughRupees

@enoughRupees:
	disableinput
	asm15 removeRupeeValue RUPEEVAL_20
	showtext TX_24d1
	wait 30
	jumpiftextoptioneq $00 @beginGame

@giveExplanation:
	showtext TX_24d3
	wait 30
	jumpiftextoptioneq $00 @beginGame
	jump2byte @giveExplanation

@beginGame:
	showtext TX_24d6
	jump2byte _shootingGallery_fadeIntoGameWithSword



shootingGalleryScript_goronElderNpc:
	initcollisions
	jumpifglobalflagset GLOBALFLAG_76 @tellSecret
	jumpifglobalflagset GLOBALFLAG_6c @alreadyGaveSecret

@loop:
	checkabutton
	jumpifmemoryeq wShootingGallery.disableGoronNpcs $01 @loop
	disableinput
	showtext TX_3130
	wait 30
	jumpiftextoptioneq $00 @askForSecret
	showtext TX_3131
	enableinput
	jump2byte @loop

@askForSecret:
	askforsecret $08
	wait 30
	jumpifmemoryeq wTextInputResult $00 @validSecret
	showtext TX_3133
	enableinput
	jump2byte @loop

@validSecret:
	setglobalflag GLOBALFLAG_6c
	showtext TX_3132
	jump2byte @askedToTakeTest

@alreadyGaveSecret:
	checkabutton
	jumpifmemoryeq wShootingGallery.disableGoronNpcs $01 @alreadyGaveSecret
	disableinput
	showtext TX_313c
	jump2byte @askedToTakeTest

@tellSecret:
	checkabutton
	jumpifmemoryeq wShootingGallery.disableGoronNpcs $01 @tellSecret
	generatesecret $08
	showtext TX_313e
	jump2byte @tellSecret

; Parse the response to the goron asking you to take the test
@askedToTakeTest:
	wait 30
	jumpiftextoptioneq $00 @acceptedTest
	showtext TX_3134
	enableinput
	jump2byte @alreadyGaveSecret

@acceptedTest:
	showtext TX_3135
	wait 30
	jumpiftextoptioneq $00 @beginGame

@giveExplanation:
	showtext TX_3136
	wait 30
	jumpiftextoptioneq $01 @giveExplanation

@beginGame:
	showtext TX_3137
	wait 40
	asm15 fadeoutToWhite
	checkpalettefadedone
	asm15 scriptHlp.shootingGallery_equipBiggoronSword
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 scriptHlp.shootingGallery_initLinkPosition
	asm15 scriptHlp.shootingGallery_setEntranceTiles $02
	wait 20
	asm15 fadeinFromWhite
	checkpalettefadedone
	jump2byte _shootingGallery_beginGame


shootingGalleryScript_hit1Blue:
	showtext TX_0807
	jump2byte _shootingGallery_printTotalPoints
shootingGalleryScript_hit1Fairy:
	showtext TX_0808
	jump2byte _shootingGallery_printTotalPoints
shootingGalleryScript_hit1Red:
	showtext TX_0809
	jump2byte _shootingGallery_printTotalPoints
shootingGalleryScript_hit1Imp:
	showtext TX_080a
	jump2byte _shootingGallery_printTotalPoints
shootingGalleryScript_hit2Blue:
	showtext TX_080b
	jump2byte _shootingGallery_printTotalPoints
shootingGalleryScript_hit2Red:
	showtext TX_080c
	jump2byte _shootingGallery_printTotalPoints
shootingGalleryScript_hit1Blue1Fairy:
	showtext TX_080e
	jump2byte _shootingGallery_printTotalPoints
shootingGalleryScript_hit1Red1Blue:
	showtext TX_080d
	jump2byte _shootingGallery_printTotalPoints
shootingGalleryScript_hit1Blue1Imp:
	showtext TX_080f
	jump2byte _shootingGallery_printTotalPoints
shootingGalleryScript_hit1Red1Fairy:
	showtext TX_0810
	jump2byte _shootingGallery_printTotalPoints
shootingGalleryScript_hit1Fairy1Imp:
	showtext TX_0811
	jump2byte _shootingGallery_printTotalPoints
shootingGalleryScript_hit1Red1Imp:
	showtext TX_0812
	jump2byte _shootingGallery_printTotalPoints
shootingGalleryScript_hitNothing:
	showtext TX_0806
	jump2byte _shootingGallery_printTotalPoints
shootingGalleryScript_strike:
	showtext TX_081c

_shootingGallery_printTotalPoints:
	wait 15
	jumpifobjectbyteeq Interaction.var3f, 10, @gameDone ; Is this the 10th round?

	showtext TX_0813
	setdisabledobjectsto00
	scriptend

@gameDone:
	jumpifobjectbyteeq Interaction.subid, $01, @goronGallery

	showtext TX_0814
	setdisabledobjectsto00
	scriptend

@goronGallery:
	showtext TX_24d7
	setdisabledobjectsto00
	scriptend



shootingGalleryScript_humanNpc_gameDone:
	loadscript scriptHlp.shootingGalleryScript_humanNpc_gameDone

shootingGalleryScript_goronNpc_gameDone:
	loadscript scriptHlp.shootingGalleryScript_goronNpc_gameDone

shootingGalleryScript_goronElderNpc_gameDone:
	disableinput
	wait 40
	asm15 fadeoutToWhite
	checkpalettefadedone
	asm15 scriptHlp.shootingGallery_restoreEquips
	asm15 scriptHlp.shootingGallery_setEntranceTiles $00
	asm15 scriptHlp.shootingGallery_removeAllTargets
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 scriptHlp.shootingGallery_initLinkPositionAfterBiggoronGame

	wait 20
	asm15 fadeinFromWhite
	checkpalettefadedone
	resetmusic
	wait 40

	asm15 scriptHlp.shootingGallery_cpScore $08
	jumpifmemoryset $cddb $80 @giveBiggoronSword

	; Not enough points
	showtext TX_3138
	wait 30
	jumpiftextoptioneq $00 @end2
	showtext TX_3139
	enableinput

; If you talk to him, he asks if you want to play again
@npcLoop:
	checkabutton
	jumpifmemoryeq wShootingGallery.disableGoronNpcs $01 shootingGalleryScript_goronElderNpc@alreadyGaveSecret
	disableinput
	showtext TX_313c
	wait 30
	jumpiftextoptioneq $00 @playAgain
	showtext TX_3134
	enableinput
	jump2byte @npcLoop

@playAgain:
	showtext TX_3135
	wait 30
	jumpiftextoptioneq $00 @end1

@giveExplanation:
	showtext TX_3136
	wait 30
	jumpiftextoptioneq $01 @giveExplanation
@end1:
	scriptend

@giveBiggoronSword:
	showtext TX_313a
	wait 30
	giveitem TREASURE_BIGGORON_SWORD $00
	wait 30
	setglobalflag GLOBALFLAG_76
	generatesecret $08
	showtext TX_313b
	enableinput
	jump2byte shootingGalleryScript_goronElderNpc@tellSecret
@end2:
	scriptend



; Performs a "cutscene" sometimes used when Link gets an item, where an "energy swirl"
; goes toward him and the screen flashes white.
scriptFunc_doEnergySwirlCutscene:
	asm15 scriptHlp.createSparkle
	wait 30
	asm15 scriptHlp.func_50e4
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

_jumpAndWaitUntilLanded:
	asm15 scriptHlp.beginJump
@stillInAir:
	asm15 scriptHlp.updateGravity
	jumpifmemoryset $cddb, $80, @landed
	jump2byte @stillInAir
@landed:
	retscript


; Subid 0: wait for signal from $cfd0 (link has approached?), then move toward Link.
impaScript0:
	checkmemoryeq $cfd0 $01
	wait 210
	showtextdifferentforlinked TX_0102 TX_0103
	wait 30
	setspeed SPEED_080
	movedown $20
	orroomflag $40
	scriptend

impaScript_moveAwayFromRock:
	checkmemoryeq $cfd0 $03
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
	writememory $cfd0 $04
	scriptend

impaScript_waitForRockToBeMoved:
	rungenericnpc TX_010b

impaScript_rockJustMoved:
	loadscript scriptHlp.impaScript_rockJustMoved

; Impa reveals that she's under veran's control
impaScript_revealPosession:
	setanimation $02
	checkmemoryeq $cfd0 $0d
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
	writememory $cfd0 $0e ; Signal for the animals to freak out?
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

	writememory $cfd0 $0f ; Signal for the animals to run away?
	scriptend


; Subid 1: talking to Impa after nayru is kidnapped
impaScript1:
	wait 120
	setanimation $02
	asm15 scriptHlp.impa_restoreNormalSpriteSheet
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
	showtextdifferentforlinked TX_0112 TX_0113
	wait 30
	setanimation $01
	showtextdifferentforlinked TX_0115 TX_0116
	wait 30
	jumpifmemoryeq wIsLinkedGame $01 @linked

@unlinked:
	giveitem TREASURE_SWORD $00
	jump2byte ++
@linked:
	giveitem TREASURE_SHIELD $00

++
	wait 30
	asm15 scriptHlp.forceLinkDirection DIR_LEFT
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
	addobjectbyte Interaction.var38 $1e
	addobjectbyte Interaction.state2 $01
	checkmemoryeq $cfc0 $05
	setanimation $08
	checkobjectbyteeq Interaction.animParameter $01
	writememory $cfc0 $06
	scriptend

; Subid 3: saved Zelda cutscene?
impaScript3:
	checkmemoryeq $cfc0 $05
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
	writememory $cfc0 $06
	scriptend

impaScript4:
	loadscript scriptHlp.impaScript4

impaScript5:
	loadscript scriptHlp.impaScript5

; Subid 6: ?
impaScript6:
	checkpalettefadedone
	wait 60
	setspeed SPEED_080
	movedown $61
	setspeed SPEED_0c0
	checkmemoryeq $cfd1 $01
	wait 8
	movedown $2b
	scriptend

impaScript7:
	loadscript scriptHlp.impaScript7

; Subid 8: ?
impaScript8:
	checkcfc0bit 0
	wait 30
	asm15 scriptHlp.createExclamationMark 30
	checkcfc0bit 3
	setspeed SPEED_200
	setanimation $03
	setangle $13
	applyspeed $31
	xorcfc0bit 4
	scriptend

; Subid 9: Tells you that Zelda's been kidnapped by twinrova
impaScript9:
	checkmemoryeq $cfd0 $11
	playsound SNDCTRL_STOPMUSIC
	showtext TX_0130

	writeobjectbyte Interaction.var38 $01
	wait 60

	setspeed SPEED_180
	moveleft $30
	wait 4
	setanimation $02
	wait 8
	callscript _jumpAndWaitUntilLanded

	wait 10
	asm15 scriptHlp.forceLinkDirection DIR_UP
	wait 10
	asm15 scriptHlp.impa_showZeldaKidnappedTextNonExitable
	writememory $cfd0 $12
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
	jump2byte @npcLoop

@alreadyExplained:
	jumpifitemobtained TREASURE_FAIRY_POWDER, @applyFairyPowder
	showtextlowindex <TX_4107
	jump2byte @npcLoop

@applyFairyPowder:
	setdisabledobjectsto11
	disablemenu
	showtextlowindex <TX_4108
	asm15 scriptHlp.greatFairyOctorok_createMagicPowderAnimation
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
	jump2byte @loop

childScript_stage4_shy:
	initcollisions
@loop:
	checkabutton
	showtext TX_4200
	jump2byte @loop

childScript_stage4_curious:
	initcollisions
@loop:
	checkabutton
	showtext TX_4900
	jump2byte @loop


childScript_stage5_hyperactive:
	initcollisions
@loop:
	checkabutton
	showtext TX_4701
	asm15 scriptHlp.setNextChildStage $06
	jump2byte @loop

childScript_stage5_shy:
	initcollisions
@loop:
	checkabutton
	showtext TX_4201
	asm15 scriptHlp.setNextChildStage $06
	jump2byte @loop

childScript_stage5_curious:
	initcollisions
@loop:
	checkabutton
	showtext TX_4901
	asm15 scriptHlp.setNextChildStage $06
	jump2byte @loop


; Stage 6: the child asks a question. The question differs based on his personality, but
; the result is always the same: wChildStatus is incremented by 4 if you answer yes.

childScript_stage6_hyperactive:
	initcollisions
	asm15 scriptHlp.checkc6e2BitSet $04
	jumpifobjectbyteeq Interaction.var3b $01 @alreadyAnswered
	checkabutton
	disableinput
	showtext TX_4702
	asm15 scriptHlp.setc6e2Bit $04
	asm15 scriptHlp.setNextChildStage $07
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredYes
	.dw @answeredNo

@answeredYes:
	wait 30
	showtext TX_4703
	asm15 scriptHlp.child_addValueToChildStatus $04
	enableinput
	jump2byte @alreadyAnswered

@answeredNo:
	wait 30
	showtext TX_4704
	enableinput

@alreadyAnswered:
	checkabutton
	showtext TX_4705
	jump2byte @alreadyAnswered


childScript_stage6_shy:
	initcollisions
	asm15 scriptHlp.checkc6e2BitSet $04
	jumpifobjectbyteeq Interaction.var3b $01 @alreadyAnswered
	checkabutton
	disableinput
	showtext TX_4202
	asm15 scriptHlp.setc6e2Bit $04
	asm15 scriptHlp.setNextChildStage $07
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredYes
	.dw @answeredNo

@answeredYes:
	wait 30
	showtext TX_4203
	asm15 scriptHlp.child_addValueToChildStatus $04
	enableinput
	jump2byte @alreadyAnswered

@answeredNo:
	wait 30
	showtext TX_4204
	enableinput

@alreadyAnswered:
	checkabutton
	showtext TX_4205
	jump2byte @alreadyAnswered


childScript_stage6_curious:
	initcollisions
	asm15 scriptHlp.checkc6e2BitSet $04
	jumpifobjectbyteeq Interaction.var3b $01 @alreadyAnswered
	checkabutton
	disableinput
	showtext TX_4902
	asm15 scriptHlp.setc6e2Bit $04
	asm15 scriptHlp.setNextChildStage $07
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredChicken
	.dw @answeredEgg

@answeredChicken:
	wait 30
	showtext TX_4903
	asm15 scriptHlp.child_addValueToChildStatus $04
	enableinput
	jump2byte @alreadyAnswered

@answeredEgg:
	wait 30
	showtext TX_4904
	enableinput

@alreadyAnswered:
	checkabutton
	showtext TX_4905
	jump2byte @alreadyAnswered


; Stage 7: just says some text.

childScript_stage7_slacker:
	initcollisions
@loop:
	checkabutton
	showtext TX_4b00
	asm15 scriptHlp.setNextChildStage $08
	jump2byte @loop

childScript_stage7_warrior:
	initcollisions
@loop:
	checkabutton
	showtext TX_4a00
	asm15 scriptHlp.setNextChildStage $08
	jump2byte @loop

childScript_stage7_arborist:
	initcollisions
@loop:
	checkabutton
	showtext TX_4800
	asm15 scriptHlp.setNextChildStage $08
	jump2byte @loop

childScript_stage7_singer:
	initcollisions
@loop:
	checkabutton
	showtext TX_4600
	asm15 scriptHlp.setNextChildStage $08
	jump2byte @loop


; Stage 8: asks a question or makes a request. This affects what he will do in stage 9.

childScript_stage8_slacker:
	initcollisions
	asm15 scriptHlp.checkc6e2BitSet $05
	jumpifobjectbyteeq Interaction.var3b $01 @alreadyAnswered

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
	asm15 scriptHlp.child_checkHasRupees RUPEEVAL_100
	jumpifobjectbyteeq Interaction.var3c $01 @notEnoughRupees
	asm15 removeRupeeValue RUPEEVAL_100
	asm15 scriptHlp.child_setStage8Response $00
	asm15 scriptHlp.setc6e2Bit $05
	asm15 scriptHlp.setNextChildStage $09
	wait 30
	enableinput
@answered100Loop:
	showtext TX_4b04
	checkabutton
	jump2byte @answered100Loop

@answered50Rupees:
	asm15 scriptHlp.child_checkHasRupees RUPEEVAL_050
	jumpifobjectbyteeq Interaction.var3c $01 @notEnoughRupees
	asm15 removeRupeeValue RUPEEVAL_050
	asm15 scriptHlp.child_setStage8Response $01
	asm15 scriptHlp.setc6e2Bit $05
	asm15 scriptHlp.setNextChildStage $09
	wait 30
	enableinput
@answered50Loop:
	showtext TX_4b05
	checkabutton
	jump2byte @answered50Loop

@answered10Rupees:
	asm15 scriptHlp.child_checkHasRupees RUPEEVAL_010
	jumpifobjectbyteeq Interaction.var3c $01 @notEnoughRupees
	asm15 removeRupeeValue RUPEEVAL_010
	asm15 scriptHlp.child_setStage8Response $02
	asm15 scriptHlp.setc6e2Bit $05
	asm15 scriptHlp.setNextChildStage $09
	wait 30
	enableinput
@answered10Loop:
	showtext TX_4b06
	checkabutton
	jump2byte @answered10Loop

@answered0Rupees: ; He takes 1 rupee anyway...
	asm15 scriptHlp.child_checkHasRupees RUPEEVAL_001
	jumpifobjectbyteeq Interaction.var3c $01 @notEnoughRupees
	asm15 removeRupeeValue RUPEEVAL_001
	asm15 scriptHlp.child_setStage8Response $03
	asm15 scriptHlp.setc6e2Bit $05
	asm15 scriptHlp.setNextChildStage $09
	wait 30
	enableinput
@answered0Loop:
	showtext TX_4b07
	checkabutton
	jump2byte @answered0Loop

@notEnoughRupees:
	wait 30
	showtext TX_4b08
	enableinput
	jump2byte @loop

@answeredNo:
	wait 30
	showtext TX_4b03
	enableinput
	jump2byte @loop

@alreadyAnswered:
	checkabutton
	showtext TX_4b09
	jump2byte @alreadyAnswered


; Asks Link what will make him mightiest.
childScript_stage8_warrior:
	initcollisions
	asm15 scriptHlp.checkc6e2BitSet $05
	jumpifobjectbyteeq Interaction.var3b $01 @alreadyAnswered
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
	asm15 scriptHlp.child_setStage8Response $03
	asm15 scriptHlp.setc6e2Bit $05
	asm15 scriptHlp.setNextChildStage $09
	wait 30
	showtext TX_4a04
	enableinput
	wait 30
	jump2byte @alreadyAnswered

@answeredDailyTraining:
	asm15 scriptHlp.child_setStage8Response $00
	jump2byte @gaveResponse

@answeredNaturalTalent:
	asm15 scriptHlp.child_setStage8Response $01
	jump2byte @gaveResponse

@answeredCaringHeart:
	asm15 scriptHlp.child_setStage8Response $02

@gaveResponse:
	asm15 scriptHlp.setc6e2Bit $05
	asm15 scriptHlp.setNextChildStage $09
	wait 30
	showtext TX_4a05
	wait 30
	enableinput

@alreadyAnswered:
	checkabutton
	showtext TX_4a08
	jump2byte @alreadyAnswered


; Gives Link a gasha seed.
childScript_stage8_arborist:
	initcollisions
	asm15 scriptHlp.checkc6e2BitSet $05
	jumpifobjectbyteeq Interaction.var3b $01 @alreadyGaveSeed

	checkabutton
	disableinput
	showtext TX_4801
	giveitem TREASURE_GASHA_SEED $03
	asm15 scriptHlp.setc6e2Bit $05
	asm15 scriptHlp.setNextChildStage $09
	wait 30
	showtext TX_4802
	wait 30
	enableinput

@alreadyGaveSeed:
	checkabutton
	showtext TX_4803
	jump2byte @alreadyGaveSeed


; Asks link what's more important, love or courage.
childScript_stage8_singer:
	initcollisions
	asm15 scriptHlp.checkc6e2BitSet $05
	jumpifobjectbyteeq Interaction.var3b $01 @alreadyAnswered

	checkabutton
	disableinput
	showtext TX_4601
	asm15 scriptHlp.child_setStage8ResponseToSelectedTextOption $00
	asm15 scriptHlp.setc6e2Bit $05
	asm15 scriptHlp.setNextChildStage $09
	wait 30
	enableinput
	jump2byte @showResponseText

@alreadyAnswered:
	checkabutton
@showResponseText:
	showtext TX_4602
	jump2byte @alreadyAnswered


; Stage 9: the child gives a reward based on your response in stage 8.

childScript_stage9_slacker:
	initcollisions
	asm15 scriptHlp.checkc6e2BitSet $06
	jumpifobjectbyteeq Interaction.var3b $01 @alreadyGaveReward
	checkabutton
	disableinput
	showtext TX_4b0a
	asm15 scriptHlp.setc6e2Bit $06
	wait 30
	jumptable_memoryaddress wChildStage8Response
	.dw @fillSatchel
	.dw @give200Rupees
	.dw @giveGashaSeed
	.dw @give10Bombs

@fillSatchel:
	asm15 refillSeedSatchel
	showtext TX_0052
	jump2byte @justGaveReward

@give200Rupees:
	asm15 scriptHlp.child_giveRupees RUPEEVAL_200
	showtext TX_0009
	jump2byte @justGaveReward

@giveGashaSeed:
	giveitem TREASURE_GASHA_SEED $03
	jump2byte @justGaveReward

@give10Bombs:
	giveitem TREASURE_BOMBS $02

@justGaveReward:
	wait 30
	enableinput
	jump2byte @showTextAfterGiving

@alreadyGaveReward:
	checkabutton
@showTextAfterGiving:
	showtext TX_4b0b
	jump2byte @alreadyGaveReward


childScript_stage9_warrior:
	initcollisions
	asm15 scriptHlp.checkc6e2BitSet $06
	jumpifobjectbyteeq Interaction.var3b $01 @alreadyGaveReward
	checkabutton
	disableinput
	showtext TX_4a06
	wait 30
	showtext TX_4a07
	asm15 scriptHlp.setc6e2Bit $06
	wait 30
	jumptable_memoryaddress wChildStage8Response
	.dw @give100Rupees
	.dw @give1Heart
	.dw @restoreHealth
	.dw @give1Rupee

@give100Rupees:
	asm15 scriptHlp.child_giveRupees RUPEEVAL_100
	showtext TX_0007
	jump2byte @justGaveReward

@give1Heart:
	asm15 scriptHlp.child_giveOneHeart $01
	showtext TX_0051
	jump2byte @justGaveReward

@restoreHealth:
	asm15 scriptHlp.child_giveHeartRefill
	showtext TX_0053
	jump2byte @justGaveReward

@give1Rupee:
	asm15 scriptHlp.child_giveRupees RUPEEVAL_001
	showtext TX_0001

@justGaveReward:
	wait 30
	enableinput
	jump2byte @showTextAfterGiving

@alreadyGaveReward:
	checkabutton
@showTextAfterGiving:
	showtext TX_4a08
	jump2byte @alreadyGaveReward


childScript_stage9_arborist:
	initcollisions
@loop:
	checkabutton
	disableinput
	showtext TX_4804
	wait 30
	callscript @showTip
	enableinput
	jump2byte @loop

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
	asm15 scriptHlp.child_playMusic
	asm15 scriptHlp.child_giveHeartRefill
	wait 30
	enableinput

@singingLoop:
	showtext TX_4604
	checkabutton
	jump2byte @singingLoop

@selectedNo:
	wait 30
	showtext TX_4605
	enableinput
	jump2byte @loop


; ==============================================================================
; INTERACID_NAYRU
; ==============================================================================

; Subid $00: Cutscene at the beginning of game (talking to Link, then gets posessed)
nayruScript00_part1:
	setanimation $02
	checkmemoryeq $cfd0 $0a

	; Moving toward Link
	wait 10
	setspeed SPEED_040
	movedown $20
	wait 30

	showtext TX_1d00
	wait 30

	writememory   $cfd0 $0b
	checkmemoryeq $cfd0 $0c
	asm15 scriptHlp.setLinkAnimation, LINK_ANIM_MODE_NONE
	wait 40

	showtext TX_1d22
	wait 30

	writememory   $cfd0 $0d
	checkmemoryeq $cfd0 $0f

	setanimation  $02
	checkmemoryeq $cfd0 $13

	; Backing away from Veran
	setspeed SPEED_040
	setangle $00
	applyspeed $20
	checkmemoryeq $cfd0 $15
	wait 120

	writememory $cfd0 $16
	wait 30

	; Moving forward again
	setangle $10
	setspeed SPEED_020
	applyspeed $81
	setcoords $28 $78
	wait 210

	; Fully posessed
	setanimation $05
	writeobjectbyte Interaction.oamFlags, $06
	playsound SND_SWORD_OBTAINED
	wait 60

	setanimation $02
	writememory $cfd0 $17
	orroomflag $40
	scriptend

; Part 2: after jumping up the cliff, she goes to the past
nayruScript00_part2:
	setanimation $02
	checkmemoryeq $cfd0 $1c
	wait 40

	showtext TX_5605
	wait 60

	setspeed SPEED_100
	moveup $11
	writeobjectbyte Interaction.var3d, $01 ; Signal to make her transparent
	playsound SND_WARP_START
	wait 120

	writememory $cfd0 $1d
	scriptend


nayruScript01:
	loadscript scriptHlp.nayruScript01


; Subid $02: Nayru on maku tree screen after being saved
nayruScript02_part1:
	checkmemoryeq $cfd0 $01
	asm15 objectSetVisiblec2
	checkpalettefadedone
	wait 30
	setanimation $02
	wait 90
	showtext TX_1d06
	wait 30
	writememory $cfd0 $02
	scriptend

nayruScript02_part2:
	loadscript scriptHlp.nayruScript02_part2

nayruScript02_part3:
	wait 1
	asm15 scriptHlp.turnToFaceSomethingAtInterval, $03
	jumpifmemoryeq $cfd0, $09, @sayGoodbye
	jump2byte nayruScript02_part3

@sayGoodbye:
	wait 60
	setanimation $02
	checkmemoryeq $cfd0 $0a
	wait 60

	asm15 scriptHlp.forceLinkDirection, DIR_UP
	wait 40

	showtext TX_1d08
	wait 20

	setspeed SPEED_0c0
	moveright $14
	wait 8

	movedown $4c
	asm15 scriptHlp.forceLinkDirection DIR_DOWN

	writememory $cfd0 $0b
	scriptend


nayruScript03:
	loadscript scriptHlp.nayruScript03


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
	checkmemoryeq $cfd0 $06
	moveup $10
	wait 180
	writememory $cfd0 $07
	scriptend

nayruScript04_part2:
	checkmemoryeq $cfd0 $0f
	setanimation $01
	wait 20
	showtext TX_1d0d
	wait 120
	writememory $cfd0 $10
	scriptend

nayruScript05:
	checkmemoryeq $cfc0 $01
	asm15 objectSetVisible82
	checkpalettefadedone
	wait 60
	setanimation $02
	checkmemoryeq $cfc0 $05
	setanimation $03
	scriptend

nayruScript07:
	loadscript scriptHlp.nayruScript07

; Subid $08: Cutscene after saving Zelda?
nayruScript08:
	checkmemoryeq $cfc0 $03
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
	writememory $cfc0 $04
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
	showtext $1d13
	xorcfc0bit 4
	wait 30
	setspeed SPEED_100
	moveup $41
	scriptend

; Subid $0b: Cutscene where Ralph's heritage is revealed (linked?)
nayruScript0a:
	checkmemoryeq $cfd0 $01
	setanimation $00
	checkmemoryeq $cfd0 $02
	setanimation $01
	checkmemoryeq $cfd0 $03
	setanimation $02
	checkmemoryeq $cfd0 $05
	setanimation $00
	checkmemoryeq $cfd0 $06

	setspeed SPEED_100
	moveup $11
	setanimation $01
	writememory w1Link.direction DIR_LEFT
	showtext TX_1d12

	wait 8
	writememory $cfd0 $07
	checkmemoryeq $cfd0 $08

	writememory w1Link.direction DIR_UP
	moveup $11
	moveright $11
	moveup $41
	scriptend

nayruScript10:
	loadscript scriptHlp.nayruScript10

nayruScript11:
	loadscript scriptHlp.nayruScript11

nayruScript13:
	loadscript scriptHlp.nayruScript13


; ==============================================================================
; INTERACID_RALPH
; ==============================================================================

; Cutscene where Nayru gets posessed
ralphSubid00Script:
	wait 30
	callscript _jumpAndWaitUntilLanded
	wait 30
	showtext TX_2a00
	wait 30

	writememory   $cfd0 $0a
	checkmemoryeq $cfd0 $0b ; Wait for nayru's text to finish

	asm15 scriptHlp.setLinkAnimation $01
	callscript _jumpAndWaitUntilLanded
	wait 10

	showtext TX_2a22
	wait 30

	writememory   $cfd0 $0c
	checkmemoryeq $cfd0 $0f ; Wait for impa's part of the cutscene to start?

	setanimation $02
	writeobjectbyte Interaction.direction, DIR_DOWN
	checkmemoryeq $cfd0 $11

	setspeed SPEED_180
	playsound SND_UNKNOWN5
	movedown $16
	playsound SND_UNKNOWN5

@faceVeranGhost:
	wait 1
	asm15 scriptHlp.turnToFaceSomething
	jumpifmemoryeq $cfd0, $15, @faceUp
	jump2byte @faceVeranGhost

@faceUp:
	setanimation $00
	wait 220

	; Back away from posessed nayru slowly
	setspeed SPEED_020
	setangle $10
	applyspeed $81

	checkmemoryeq $cfd0 $17 ; Wait for posession to finish
	wait 120

	; Move toward Nayru
	setspeed SPEED_100
	moveleft $10
	wait 6
	asm15 scriptHlp.createLinkedSwordAnimation
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

	writememory   $cfd0 $18
	checkmemoryeq $cfd2 $ff ; Wait for signal to turn left

	setanimation  $03
	checkmemoryeq $cfd0 $1b
	wait 20

	; Move toward cliff
	setspeed SPEED_100
	moveup $30
	wait 6
	moveleft $31

	writememory   $cfd0 $1c
	checkmemoryeq $cfd0 $1d

	wait 120
	scriptend


ralphSubid02Script:
	loadscript scriptHlp.ralphSubid02Script


; Cutscene outside Ambi's palace before getting mystery seeds
ralphSubid01Script:
	setmusic MUS_RALPH
	setspeed SPEED_200
	setanimation $03
	wait 40
	moveleft $1d

	writeobjectbyte Interaction.var3f, $01
	wait 40
	callscript _jumpAndWaitUntilLanded
	wait 40
	showtext TX_2a08
	wait 40

	writeobjectbyte $7f $00
	setspeed SPEED_200
	moveleft $45
	writememory $cfc0 $01
	resetmusic
	scriptend


ralphSubid03Script:
	loadscript scriptHlp.ralphSubid03Script


; Cutscene on maku tree screen after saving Nayru
ralphSubid04Script_part1:
	checkmemoryeq $cfd0 $01
	asm15 objectSetVisiblec2
	writeobjectbyte Interaction.animCounter, $7f
	checkpalettefadedone
	wait 30
	setanimation $01
	scriptend

ralphSubid04Script_part2:
	checkmemoryeq $cfd0 $04
	setspeed SPEED_100
	movedown $13
	wait 6

	moveright $0a
	asm15 scriptHlp.forceLinkDirection, DIR_LEFT
	wait 30

	showtext TX_2a0e
	wait 30

	asm15 scriptHlp.forceLinkDirection, DIR_UP
	setanimation $00
	writememory $cfd0 $05
	scriptend

ralphSubid04Script_part3:
	wait 1
	asm15 scriptHlp.turnToFaceSomethingAtInterval, $03
	jumpifmemoryeq $cfd0 $09 @twinrovaGone
	jump2byte ralphSubid04Script_part3

@twinrovaGone:
	wait 60
	resetmusic
	wait 60

	setanimation $01
	asm15 scriptHlp.forceLinkDirection, DIR_LEFT
	wait 20

	showtextdifferentforlinked TX_2a0f, TX_2a10
	wait 20
	setspeed SPEED_200
	movedown $18

	asm15 scriptHlp.forceLinkDirection, DIR_DOWN
	writememory $cfd0 $0a
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
	asm15 scriptHlp.forceLinkDirection, DIR_RIGHT
	wait 10

	showtext TX_2a11
	wait 20

	writememory   $cfd0 $03
	checkmemoryeq $cfd0 $04
	wait 50

	setspeed SPEED_100
	moveleft $10
	wait 6
	movedown $28
	wait 60

	writememory $cfd0 $05
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

	writememory $cfd0 $06
	checkobjectbyteeq Interaction.var3e, $01
	wait 10

	showtext TX_2a13
	wait 60

	writememory $cfd0 $09
	scriptend

ralphSubid06Script_part2:
	checkpalettefadedone
	wait 60

	setanimation $01
	wait 10
	asm15 scriptHlp.forceLinkDirection, DIR_LEFT
	wait 10
	showtext TX_2a14
	wait 60

	jumpifmemoryeq wIsLinkedGame, $01, @linked
	wait 20

	setanimation $00
	asm15 scriptHlp.forceLinkDirection, DIR_UP
	wait 20
	writememory   $cfd0 $0c
	checkmemoryeq $cfd0 $0d

	showtext TX_2a15
	wait 10

	writememory   $cfd0 $0e
	checkmemoryeq $cfd0 $0f
	wait 10

	setanimation $03
	asm15 scriptHlp.forceLinkDirection, DIR_LEFT
	scriptend

@linked:
	writememory $cfd0 $11
	scriptend


; Cutscene postgame where they warp to the maku tree, Ralph notices the statue
ralphSubid07Script:
	checkmemoryeq $cfc0 $01

	asm15 objectSetVisible82
	checkmemoryeq $cfc0 $02

	wait 40
	setanimation $00
	wait 20

	asm15 scriptHlp.ralph_createExclamationMarkShiftedRight, $28
	wait 60

	writememory $cfc0 $03
	setspeed SPEED_180
	setangle $05
	applyspeed $1e
	wait 60

	setanimation $02
	wait 30

	addobjectbyte     Interaction.state2 $01
	checkobjectbyteeq Interaction.var3e  $01
	wait 60

	writememory $cfc0 $05
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
	asm15 scriptHlp.ralph_faceLinkAndCreateExclamationMark
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
	asm15 scriptHlp.ralph_createExclamationMarkShiftedRight, $1e
	wait 30

	writememory $cfd0 $01
	setspeed SPEED_100
	moveup $29
	checkobjectbyteeq Interaction.state2, $03
	wait 8

	showtext TX_2a19
	wait 8

	movedown $29
	writememory $cfd0 $02
	setanimation $03
	wait 45

	setanimation $02
	wait 30
	writememory $cfd0 $03
	setspeed SPEED_180
	movedown $29
	wait 30

	writememory $cfd0 $04
	scriptend


ralphSubid0bScript:
	loadscript scriptHlp.ralphSubid0bScript

ralphSubid10Script:
	loadscript scriptHlp.ralphSubid10Script

ralphSubid0cScript:
	loadscript scriptHlp.ralphSubid0cScript


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
	asm15 scriptHlp.ralph_flickerVisibility
	asm15 scriptHlp.ralph_decVar3f
	jumpifmemoryset $cddb $80 @done
	jump2byte @flickerVisibility

@done:
	setglobalflag GLOBALFLAG_RALPH_ENTERED_PORTAL
	asm15 scriptHlp.ralph_restoreMusic
	enableinput
	scriptend


; Cutscene with Nayru and Ralph when Link exits the black tower
ralphSubid0eScript:
	checkpalettefadedone
	wait 70

	setspeed SPEED_100
	moveup $50
	checkmemoryeq wTmpcbb5, $01

	moveup $10
	showtext TX_2a1f

	writememory   $cbb5 $02
	checkmemoryeq $cbb5 $03

	movedown $40
	writeobjectbyte Interaction.yh $08
	writeobjectbyte Interaction.xh $80

	checkmemoryeq $cbb5 $05
	checkpalettefadedone

	movedown $70
	checkmemoryeq $cbb5 $07
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
	asm15 scriptHlp.turnToFaceLink
	wait 6

	showtext TX_2a21
	wait 6

	writeobjectbyte Interaction.var39, $00 ; Enable animations
	setanimation $03
	enableinput
	jump2byte @npcLoop


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
	ormemory $cfde $08 ; Signal that this animal's been talked to

	cplinkx Interaction.direction
	setanimationfromobjectbyte Interaction.direction

	showtextlowindex <TX_5704
	wait 20
	setanimation $02
	jump2byte @npcLoop

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
	jump2byte @waitUntilLanded
@landed:
	asm15 scriptHlp.monkey_decideTextIndex
	showloadedtext
	jump2byte @npcLoop


monkeySubid5Script_bowtieMonkey:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @finishedGame
	rungenericnpclowindex <TX_5707
@finishedGame:
	rungenericnpclowindex <TX_570c


monkeySubid7Script_0:
	initcollisions
@npcLoop:
	checkabutton
	asm15 scriptHlp.monkey_turnToFaceLink
	showtextlowindex <TX_5715
	asm15 scriptHlp.monkey_setAnimationFromVar3a
	jump2byte @npcLoop


monkeySubid7Script_1:
	initcollisions
@npcLoop:
	checkabutton
	asm15 scriptHlp.monkey_turnToFaceLink
	showtextlowindex <TX_5716
	asm15 scriptHlp.monkey_setAnimationFromVar3a
	jump2byte @npcLoop


monkeySubid7Script_2:
	initcollisions
@npcLoop:
	checkabutton
	asm15 scriptHlp.monkey_turnToFaceLink
	showtextlowindex <TX_5719
	asm15 scriptHlp.monkey_setAnimationFromVar3a
	jump2byte @npcLoop


monkeySubid7Script_3:
	initcollisions
@npcLoop:
	checkabutton
	asm15 scriptHlp.monkey_turnToFaceLink
	showtextlowindex <TX_571a
	asm15 scriptHlp.monkey_setAnimationFromVar3a
	jump2byte @npcLoop


; ==============================================================================
; INTERACID_VILLAGER
; ==============================================================================

villagerSubid01Script:
	initcollisions
	settextid TX_1440
	jump2byte _villagerFaceDownAfterTalkedTo


; Construction worker blocking path to upper part of black tower
villagerSubid02Script_part1:
	setcollisionradii $06, $06
	settextid TX_1441

_villagerFaceDownAfterTalkedTo:
	checkabutton
	asm15 scriptHlp.turnToFaceLink
	showloadedtext
	wait 10
	setanimation $02
	jump2byte _villagerFaceDownAfterTalkedTo


; Construction worker moves toward Link to prevent him from passing
villagerSubid02Script_part2:
	disableinput
	setspeed SPEED_100
	jumpifobjectbyteeq Interaction.direction, $00, @moveRight

	moveleft $10
	jump2byte ++
@moveRight:
	moveright $10
++
	asm15 scriptHlp.villager_setLinkYToVar39
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

_villagerThrowBallAnimation:
	asm15 scriptHlp.loadNextAnimationFrameAndMore, $01
	wait 30
	jump2byte villagerSubid09Script

script5bbf: ; Unused
	scriptend


; Villager being restored from stone, resumes playing catch
villagerSubid0bScript:
	checkmemoryeq $cfd1 $02
	wait 10

	; Run off screen to get ball
	setspeed SPEED_180
	moveleft $2c
	asm15 scriptHlp.villager_createBallAccessory
	wait 30

	; Run back on screen
	setanimation $0b
	setangle $08
	applyspeed $2c

	; Wait a bit with no animations
	writeobjectbyte Interaction.var39 $01
	wait 90

	; Throw the ball
	writeobjectbyte Interaction.var3b $01
	asm15 scriptHlp.villager_createBall
	jump2byte _villagerThrowBallAnimation


; Cutscene when you first enter the past
villagerSubid0dScript:
	jumpifglobalflagset GLOBALFLAG_ENTER_PAST_CUTSCENE_DONE, stubScript
	setdisabledobjectsto11
	wait 100
	disableinput
	wait 40

	callscript _jumpAndWaitUntilLanded
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
	jump2byte @npcLoop


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
	asm15 scriptHlp.turnToFaceLink
	ormemory $cfde, $04
	showtext TX_2510
	wait 10
	setanimation $00
	jump2byte @npcLoop


; Kid turning to stone cutscene
boySubid01Script:
	setspeed SPEED_100
	moveleft $50
	wait 8
	moveright $50
	wait 8
	moveleft $30

	asm15 scriptHlp.createExclamationMark, $3c
	wait 50

	writememory $cfd1 $01
	wait 90

	writememory $cfd1 $02
	setspeed SPEED_040
	applyspeed $40
	wait 30

	writememory $cfd1 $03

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
	checkmemoryeq $cfd1, $02

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

	writememory $cfd1 $03

_boyShakeWithFearThenRun:
	writeobjectbyte Interaction.var39, $01 ; Disable animations
	writeobjectbyte Interaction.var38, 120 ; Wait 2 seconds

@shake:
	asm15 scriptHlp.oscillateXRandomly
	addobjectbyte Interaction.var38, -1
	jumpifobjectbyteeq Interaction.var38, $00, @runAway
	wait 1
	jump2byte @shake

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

	writememory   $cfd1 $01
	checkmemoryeq $cfd1 $03

	jump2byte _boyShakeWithFearThenRun


; Cutscene where kid is restored from stone
boySubid05Script:
	wait 30
	setspeed SPEED_180
	moveleft $0a

_boyRunAroundHouse:
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
	jump2byte _boyRunAroundHouse


; Cutscene where kid sees his dad turn to stone
boySubid06Script:
	wait 30
	jumpifobjectbyteeq Interaction.var38, $00, @stopPlayingCatch
	asm15 scriptHlp.loadNextAnimationFrameAndMore, $02
	wait 90
	setanimation $03
	jump2byte boySubid06Script

@stopPlayingCatch:
	writememory $cfd1 $01
	asm15 scriptHlp.loadNextAnimationFrameAndMore, $03
	wait 90

	asm15 scriptHlp.boy_createLightning, $00
	wait 20

	asm15 scriptHlp.boy_createLightning, $01
	wait 20

	asm15 fadeoutToWhite
	checkpalettefadedone
	wait 10

	writememory $cfd1 $02
	setanimation $03
	asm15 fadeinFromWhite

	checkpalettefadedone
	wait 30

	asm15 scriptHlp.createExclamationMark $28
	wait 40

	addobjectbyte Interaction.state2, $01 ; Enable normal animations
	setspeed SPEED_180
	moveleft $21
	wait 30

	writememory $cfdf $ff
	scriptend


; Depressed kid in trade sequence
boySubid07Script:
	loadscript scriptHlp.boySubid07Script


; Cutscene?
boySubid0aScript:
	checkmemoryeq $cfd1 $02
	setanimation $01
	wait 30
	showtext TX_251b
	wait 30
	writememory $cfd1 $03
	scriptend


; NPC in eyeglasses library present
boySubid0bScript:
	initcollisions
@npcLoop:
	checkabutton
	turntofacelink
	showloadedtext
	setanimation $00
	jump2byte @npcLoop


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
	asm15 scriptHlp.loadNextAnimationFrameAndMore $02
	wait 90
	jump2byte @playCatchLoop


; Kid with grandma who's either stone or was restored from stone
boySubid0dScript:
	rungenericnpc TX_251c


; NPC playing catch with dad, or standing next to his stone dad
boySubid0eScript:
	initcollisions
	jump2byte boySubid0cScript@playCatch


; Cutscene where kid runs away?
boySubid0fScript:
	checkcfc0bit 0
	wait 60
	asm15 scriptHlp.createExclamationMark, $1e
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
	checkmemoryeq $cfd1 $03
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
	jump2byte _boyRunAroundHouse


; ==============================================================================
; INTERACID_VERAN_GHOST
; ==============================================================================

ghostVeranSubid0Script_part1:
	loadscript scriptHlp.ghostVeranSubid0Script_part1

ghostVeranSubid1Script_part2:
	setcoords $24 $78
	wait 30
	setangle $00
	setspeed SPEED_040
	applyspeed $45
	checkmemoryeq $cfd2 $ff
	wait 60
	setangle $10
	setspeed SPEED_080
	applyspeed $23
	wait 10
	writememory $cfd0 $1a
	scriptend

; Cutscene just before fighting posessed Ambi
ghostVeranSubid1Script:
	checkmemoryeq $cc93 $00
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
	writememory   $cfd1, $02
	checkmemoryeq $cfd1, $03
	jump2byte _boyShakeWithFearThenRun


; ==============================================================================
; INTERACID_SOLDIER
; ==============================================================================

soldierSubid00Script:
	jumpifglobalflagset $0b script5df5
	rungenericnpc $5900
script5df5:
	rungenericnpc $5901

soldierSubid01Script:
	jumpifglobalflagset $0b script5dff
	rungenericnpc $5902
script5dff:
	rungenericnpc $5901


; Left palace guard
soldierSubid02Script:
	loadscript scriptHlp.soldierSubid02Script


soldierSubid03Script:
	jumpifobjectbyteeq $4b $28 script5e1e
	checkmemoryeq $d00b $60
	setspeed SPEED_100
	jumpifobjectbyteeq $4d $48 script5e1a
	setangle $08
	jump2byte script5e1c
script5e1a:
	setangle $18
script5e1c:
	applyspeed $10
script5e1e:
	scriptend


; Guard who gives bombs to Link
soldierSubid04Script:
	checkmemoryeq $cfd1 $02
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
	asm15 scriptHlp.forceLinkDirection, $03
	wait 60
	setspeed SPEED_080
	setangle $08
	applyspeed $15
	wait 60
	setangle $18
	applyspeed $15
	wait 30
	giveitem $0302
	setdisabledobjectsto11
	wait 30
	asm15 scriptHlp.forceLinkDirection $00
	setspeed SPEED_100
	moveup $31
	wait 6
	setanimation $02
	wait 30
	showtext $1304
	wait 30
	writememory $cfd1 $03
	checkmemoryeq $cfd1 $04
	playsound $fb
	wait 180
	showtext $1305
	wait 40
	movedown $21
	wait 4
	moveright $11
	wait 4
	movedown $11
	wait 60
	showtext $5907
	writememory $cfd1 $05
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
	asm15 scriptHlp.soldierGiveMysterySeeds
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

	writememory   $cfd1 $01
	checkmemoryeq $cfd1 $03

	; Escort Link out of screen
	setspeed SPEED_100
	moveleft $18
	setanimation $00
	wait 30
	showtext TX_5906
	wait 30
	setanimation $02
	wait 30
	showtext $590c
	wait 30
	writememory $cd00 $00
	asm15 scriptHlp.soldierSetSimulatedInputToEscortLink, $01
	setdisabledobjectsto00
	movedown $34

	writememory $cfd1, $04
	setglobalflag GLOBALFLAG_0b
	scriptend


; Guard just after Link is escorted out of the palace
soldierSubid07Script:
	wait 60
	showtext TX_5908
	wait 30
	writememory wUseSimulatedInput, $00
	asm15 scriptHlp.soldierUpdateMinimap
	enableinput
	rungenericnpc TX_5909


; Right palace guard
soldierSubid09Script:
	jumpifglobalflagset GLOBALFLAG_0b, @gotBombs
	rungenericnpc TX_5903
@gotBombs:
	rungenericnpc TX_5909


soldierSubid0aScript:
	loadscript scriptHlp.soldierSubid0aScript


soldierSubid0cScript:
	initcollisions
script5f13:
	checkabutton
	asm15 $5a37
	showloadedtext
	jump2byte script5f13


; Friendly soldier after finishing game. Behaviour depends on var3b, in turn set by var03.
soldierSubid0dScript:
	asm15 scriptHlp.soldierSetSpeed80AndVar3fTo01
	asm15 scriptHlp.soldierSetTextToShow
	initcollisions
	jumptable_objectbyte Interaction.var3b
	.dw @mode0_genericNpc
	.dw @mode1_moveClockwise
	.dw @mode2_moveCounterClockwise
	.dw @mode3_moveVertically

@mode0_genericNpc:
	checkabutton
	showloadedtext
	jump2byte @mode0_genericNpc

@mode1_moveClockwise:
	checkmemoryeq $cde0 $00
	asm15 objectUnmarkSolidPosition
@mode1Loop:
	asm15 scriptHlp.hardhatWorker_setPatrolDirection $02
	asm15 scriptHlp.hardhatWorker_setPatrolCounter $60
	callscript @moveForVar3cFrames
	asm15 scriptHlp.hardhatWorker_setPatrolDirection $03
	asm15 scriptHlp.hardhatWorker_setPatrolCounter $60
	callscript @moveForVar3cFrames
	asm15 scriptHlp.hardhatWorker_setPatrolDirection $00
	asm15 scriptHlp.hardhatWorker_setPatrolCounter $60
	callscript @moveForVar3cFrames
	asm15 scriptHlp.hardhatWorker_setPatrolDirection $01
	asm15 scriptHlp.hardhatWorker_setPatrolCounter $60
	callscript @moveForVar3cFrames
	jump2byte @mode1Loop

@mode2_moveCounterClockwise:
	checkmemoryeq $cde0 $00
	asm15 objectUnmarkSolidPosition
@mode2Loop:
	asm15 scriptHlp.hardhatWorker_setPatrolDirection $02
	asm15 scriptHlp.hardhatWorker_setPatrolCounter $80
	callscript @moveForVar3cFrames
	asm15 scriptHlp.hardhatWorker_setPatrolDirection $01
	asm15 scriptHlp.hardhatWorker_setPatrolCounter $20
	callscript @moveForVar3cFrames
	asm15 scriptHlp.hardhatWorker_setPatrolDirection $00
	asm15 scriptHlp.hardhatWorker_setPatrolCounter $80
	callscript @moveForVar3cFrames
	asm15 scriptHlp.hardhatWorker_setPatrolDirection $03
	asm15 scriptHlp.hardhatWorker_setPatrolCounter $20
	callscript @moveForVar3cFrames
	jump2byte @mode2Loop

@mode3_moveVertically:
	checkmemoryeq $cde0 $00
	asm15 objectUnmarkSolidPosition
@mode3Loop:
	asm15 scriptHlp.hardhatWorker_setPatrolDirection $02
	asm15 scriptHlp.hardhatWorker_setPatrolCounter $c0
	callscript @moveForVar3cFrames
	asm15 scriptHlp.hardhatWorker_setPatrolDirection $00
	asm15 scriptHlp.hardhatWorker_setPatrolCounter $c0
	callscript @moveForVar3cFrames
	jump2byte @mode3Loop

@moveForVar3cFrames:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @@turnToLinkAndShowText
	asm15 scriptHlp.hardhatWorker_decPatrolCounter
	jumpifmemoryset $cddb, $80, @@wait20Frames
	asm15 objectApplySpeed
	jump2byte @moveForVar3cFrames

@@wait20Frames:
	wait 20
	retscript

@@turnToLinkAndShowText:
	disableinput
	writeobjectbyte, Interaction.pressedAButton, $00
	asm15 scriptHlp.turnToFaceLink
	showloadedtext
	wait 30
	asm15 scriptHlp.hardhatWorker_updatePatrolAnimation
	enableinput
	jump2byte @moveForVar3cFrames


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
	checkmemoryeq $cfd1, $02
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
	checkmemoryeq $cfd1, $04
	asm15 objectSetVisible82
	wait 240
	writememory $cfdf, $ff
	callscript _jumpAndWaitUntilLanded
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

_tokayThiefCommon:
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
	asm15 scriptHlp.tokayMakeLinkJump
	setanimation $00
	playsound SND_STRIKE
	writememory $cfd1, $01
	jump2byte _tokayThiefCommon


; Subid $05: NPC who trades meat for stink bag
tokayCookScript:
	loadscript scriptHlp.tokayCookScript


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

	asm15 scriptHlp.tokayGiveItemToLink
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
	asm15 objectUpdateSpeedZ $20
	jumpifobjectbyteeq Interaction.zh, $00, @landed
	wait 1
	jump2byte @jumping

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
	jump2byte @dontHaveBracelet

@waitForLinkToTalk:
	asm15 scriptHlp.tokayGame_determinePrizeAndCheckRupees
	checkabutton
	showtextlowindex <TX_0a10
	disableinput
	wait 10
	asm15 scriptHlp.tokayGame_createAccessoryForPrize, $06
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
	jump2byte @waitForLinkToTalk

@startGame:
	jumpifobjectbyteeq Interaction.var3d, $00, @takeRupees

@notEnoughRupees:
	settextid TX_0a1b
	jump2byte @selectedNo

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
	asm15 scriptHlp.tokayGame_resetRoomFlag40
	disableinput

	jumpifmemoryeq $cfde, $ff, @failedGame

	; Won game
	wait 30
	asm15 scriptHlp.tokayGame_givePrizeToLink
	wait 30
	jump2byte @enableInput

@failedGame:
	; Ask to play again
	asm15 scriptHlp.tokayGame_checkRupees
	showtextlowindex <TX_0a19
	jumpiftextoptioneq $01, @enableInput
	jumpifobjectbyteeq Interaction.var3d, $01, @notEnoughRupees
	asm15 removeRupeeValue RUPEEVAL_10
	jump2byte @beginGame

@enableInput:
	enableinput
	jump2byte @askToPlay


; Subid $0e: Shopkeeper (trades items)
tokayShopkeeperScript:
	makeabuttonsensitive
@npcLoop:
	checkabutton

	; Check that at least one shop item exists
	asm15 scriptHlp.tokayFindShopItem
	jumpifobjectbyteeq Interaction.var3f, $00, @noItemsAvailable

	; At least one item available
	showtextlowindex <TX_0a37
	jump2byte @npcLoop

@noItemsAvailable:
	showtextlowindex <TX_0a38
	jump2byte @npcLoop


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
	asm15 scriptHlp.tokayTurnToFaceLink
	showtextlowindex <TX_0a1f

	asm15 scriptHlp.tokayCheckHaveEmberSeeds
	jumpifobjectbyteeq Interaction.var3f, $00, @npcLoop

	showtextlowindex <TX_0a20
	jumptable_memoryaddress wSelectedTextOption
	.dw @selectedYes
	.dw @selectedNo

@selectedNo:
	showtextlowindex <TX_0a22
	jump2byte @npcLoop

; Agreed to trade ember seeds
@selectedYes:
	showtextlowindex <TX_0a23
	asm15 scriptHlp.tokayDecNumEmberSeeds
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
	jumpifmemoryset w1Companion.var3e $01, @script61e9
	jump2byte tokayWithDimitri2Script

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
	asm15 scriptHlp.tokayTurnToFaceLink
	showtextlowindex <TX_0a1e
	writeobjectbyte Interaction.pressedAButton, $00
	jump2byte @faceUp
@didntPressA:
	jumpifmemoryset w1Companion.var3e, $04, @beginCutscene
	jump2byte @npcLoop

; Face down, wait for signal to run away
@beginCutscene:
	setangleandanimation $10
@wait:
	jumpifmemoryset w1Companion.var3e, $08, @runAway
	wait 1
	jump2byte @wait

@runAway:
	moveleft $20
	ormemory wDimitriState, $02
	setdisabledobjectsto00
	scriptend


; Subid $11: Past NPC looking after scent seedling
tokayAtSeedlingPlotScript:
	makeabuttonsensitive
@npcLoop:
	setangleandanimation $10
	checkabutton
	asm15 scriptHlp.tokayTurnToFaceLink
	jumpifroomflagset $80, @alreadyPlantedSeedling
	jumpifitemobtained TREASURE_SCENT_SEEDLING, @plantSeedling
	showtextlowindex <TX_0a40
	jump2byte @npcLoop

@plantSeedling:
	disableinput
	showtextlowindex <TX_0a40
	wait 30

	showtextlowindex <TX_0a41

	asm15 scriptHlp.tokayFlipDirection
	setspeed SPEED_100
	applyspeed $10

	asm15 scriptHlp.tokayFlipDirection
	asm15 scriptHlp.tokayPlantScentSeedling
	spawninteraction INTERACID_SCENT_SEEDLING, $04, $38, $48
	playsound SND_GETSEED
	wait 120

	asm15 scriptHlp.tokayTurnToFaceLink
	showtextlowindex <TX_0a42

	enableinput
	jump2byte @npcLoop

@alreadyPlantedSeedling:
	jumpifitemobtained TREASURE_SCENT_SEEDS, @gotScentSeeds
	showtextlowindex <TX_0a43
	jump2byte @npcLoop

@gotScentSeeds:
	showtextlowindex <TX_0a44
	jump2byte @npcLoop


; Subid $19: Present NPC in charge of the wild tokay museum
tokayGameManagerScript_present:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @askForSecret
	rungenericnpclowindex <TX_0a67

@askForSecret:
	initcollisions

	; Check if we're loading the room just after ending the minigame
	jumpifroomflagset $40, @endingMinigame

	; Check if the secret quest has been completed
	jumpifglobalflagset GLOBALFLAG_73, @alreadyGotBombUpgrade

	; Check if the secret has been told to the tokay (but game hasn't been finished
	; yet)
	jumpifglobalflagset GLOBALFLAG_69, @npcLoop_waitingForLinkToPlayMinigame


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
	jump2byte @npcLoop_waitingForSecret

@enterSecret:
	askforsecret $05
	wait 20
	jumpifmemoryeq wTextInputResult, $00, @validSecret

	; No valid secret entered
	showtextlowindex <TX_0a48
	enableinput
	jump2byte @npcLoop_waitingForSecret

@validSecret:
	setglobalflag GLOBALFLAG_69
	showtextlowindex <TX_0a47
	jump2byte @promptToPlayMinigame


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
	jump2byte @npcLoop_waitingForLinkToPlayMinigame

@promptRules:
	wait 20
	showtextlowindex <TX_0a4a
	wait 2
	jumpiftextoptioneq $00 @beginGame

@explainRules:
	wait 20
	showtextlowindex <TX_0a4b
	wait 20
	jumpiftextoptioneq $01 @explainRules

@beginGame:
	wait 20
	showtextlowindex <TX_0a4c
	wait 40
	scriptend


; Just finished a minigame.
@endingMinigame:
	asm15 scriptHlp.tokayGame_resetRoomFlag40
	disableinput
	jumpifmemoryeq $cfde, $ff, @failedGame

	; Won the minigame
	showtextlowindex <TX_0a4f
	wait 30

	asm15 scriptHlp.tokayGiveBombUpgrade
	giveitem TREASURE_BOMB_UPGRADE, $00
	wait 30

	setglobalflag GLOBALFLAG_73
	generatesecret $05
	showtextlowindex <TX_0a50
	enableinput

@alreadyGotBombUpgrade:
	checkabutton
	generatesecret $05
	showtextlowindex <TX_0a53
	jump2byte @alreadyGotBombUpgrade

@failedGame:
	showtextlowindex <TX_0a4d
	wait 20
	jumpiftextoptioneq $00, @beginGame
	showtextlowindex <TX_0a4e
	enableinput
	jump2byte @npcLoop_waitingForLinkToPlayMinigame


; Subid $1d: NPC holding shield upgrade
tokayWithShieldUpgradeScript:
	loadscript scriptHlp.tokayWithShieldUpgradeScript


; Subid $1e: Present NPC who talks to you after climbing down vine
tokayExplainingVinesScript:
	loadscript scriptHlp.tokayExplainingVinesScript

; ==============================================================================
; INTERACID_FOREST_FAIRY
; ==============================================================================

; NPC for first fairy on "main" forest screen, after being found
forestFairyScript_firstDiscovered:
	makeabuttonsensitive
@npcLoop:
	checkabutton
	showtext TX_1108
	jump2byte @npcLoop

; NPC for second fairy on "main" forest screen, after being found
forestFairyScript_secondDiscovered:
	makeabuttonsensitive
@npcLoop:
	checkabutton
	showtext TX_1109
	jump2byte @npcLoop

; Subids $05-$0a
forestFairyScript_genericNpc:
	setcollisionradii $04 $04
	makeabuttonsensitive
@npcLoop:
	checkabutton
	showloadedtext
	jump2byte @npcLoop


; Subid $0b: NPC in unlinked game who takes a secret
forestFairyScript_heartContainerSecret:
	setcollisionradii $04, $04
	makeabuttonsensitive
@npcLoop:
	checkabutton
	disableinput
	jumpifglobalflagset GLOBALFLAG_6f, @alreadyGaveSecret
	showtext TX_1148
	wait 30
	jumpiftextoptioneq $00, @askForSecret
	showtext TX_1149
	jump2byte @enableInput

@askForSecret:
	askforsecret $01
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @gaveValidSecret
	showtext TX_114b
	jump2byte @enableInput

@gaveValidSecret:
	setglobalflag GLOBALFLAG_65
	showtext $114a
	wait 30

	giveitem TREASURE_HEART_CONTAINER, $02
	wait 30

	generatesecret $01
	setglobalflag GLOBALFLAG_6f
	showtext TX_114c
	jump2byte @enableInput

@alreadyGaveSecret:
	generatesecret $01
	showtext TX_114d

@enableInput:
	enableinput
	jump2byte @npcLoop


; ==============================================================================
; INTERACID_RABBIT
; ==============================================================================

; Subid 0: Listening to Nayru at the start of the game
rabbitScript_listeningToNayruGameStart:
	initcollisions
@npcLoop:
	checkabutton
	asm15 scriptHlp.turnToFaceLink
	ormemory $cfde, $02
	showtext TX_5705
	wait 10
	setanimation $00
	jump2byte @npcLoop


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
	ormemory $cfde, $01
	showtext TX_3214

	writeobjectbyte Interaction.var37, $00 ; Stop hopping
	writeobjectbyte Interaction.zh, $00
	wait 10

	setdisabledobjectsto00
	setanimation $01
	asm15 interactionUnsetAlwaysUpdateBit
	jump2byte @npcLoop


; Subid 4: Bird with Impa when Zelda gets kidnapped
birdScript_zeldaKidnapped:
	initcollisions
	jumpifglobalflagset GLOBALFLAG_ZELDA_SAVED_FROM_VIRE, @zeldaSaved

@npcLoop:
	checkabutton
	setanimation $02
	showtext TX_3216
	setanimation $00
	jump2byte @npcLoop

@zeldaSaved:
	checkmemoryeq $cfd0, $05
	setanimation $02
	wait 30
	showtext TX_3217

	setanimation $00
	writememory $cfd0, $06
	checkmemoryeq $cfd0, $07

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
	checkmemoryeq $cfd1, $01
	wait 30

	showtext TX_1301
	wait 30

	setanimation $03
	wait 20
	showtext TX_1302

	writememory $cfd1, $02
	wait 10

	setanimation $02
	checkmemoryeq $cfd1, $06
	wait 150

	setspeed SPEED_080
	moveup $60

	writememory $cfd1, $07
	scriptend

; Cutscene after escaping black tower (part 1)
ambiSubid01Script_part1:
	checkmemoryeq $cfd0, $07
	playsound SNDCTRL_STOPMUSIC
	showtext TX_130e

	playsound MUS_PRECREDITS
	wait 10

	writememory $cfd0 $08
	checkmemoryeq $cfd0 $09
	showtext TX_130f

	wait 60
	writememory $cfd0 $0a
	scriptend


; Cutscene after escaping black tower (part 2, unlinked only)
ambiSubid01Script_part2:
	checkmemoryeq $cfd0, $0c
	showtext TX_1310
	wait 30

	writememory $cfd0, $0d
	checkobjectbyteeq Interaction.var3e, $01
	wait 10

	showtext TX_1311
	wait 120

	writememory $cfd0, $0f
	scriptend


; Credits cutscene where Ambi observes construction of Link statue
ambiSubid02Script:
	wait 180
	asm15 fadeoutToWhite
	checkpalettefadedone

	writememory $cfc0, $01
	wait 30

	asm15 fadeinFromWhite
	setspeed SPEED_040
	setangle $10
	checkmemoryeq $cfc0 $04
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

	writememory   $cfc0, $01
	checkmemoryeq $cfc0, $02

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
	asm15 scriptHlp.ambiFlickerVisibility
	asm15 scriptHlp.ambiDecVar3f
	jumpifmemoryset $cddb, $80, @beginRising
	jump2byte @flickerLoop

@beginRising:
	playsound SND_SWORDSPIN
@risingLoop:
	asm15 scriptHlp.ambiRiseUntilOffScreen
	jumpifmemoryset $cddb, $10, @doneRising
	asm15 scriptHlp.ambiFlickerVisibility
	jump2byte @risingLoop

@doneRising:
	xorcfc0bit 3
	scriptend


; Cutscene just before fighting posessed Ambi
ambiSubid06Script:
	disableinput
	checkcfc0bit 0
	spawnenemyhere ENEMYID_VERAN_POSESSION_BOSS, $01
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
	asm15 scriptHlp.checkIsLinkedGameForScript
	jumpifmemoryset $cddb, $80, stubScript
	rungenericnpclowindex <TX_1c14

subrosianAtGoronDanceScript_redNpc:
	asm15 scriptHlp.checkIsLinkedGameForScript
	jumpifmemoryset $cddb, $80, stubScript
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
	jump2byte @npcLoop

; ==============================================================================
; INTERACID_DUMBBELL_MAN
; ==============================================================================
dumbbellManScript:
	loadscript scriptHlp.dumbbellManScript


; ==============================================================================
; INTERACID_OLD_MAN
; ==============================================================================
oldManScript_givesShieldUpgrade:
	loadscript scriptHlp.oldManScript_givesShieldUpgrade

oldManScript_givesBookOfSeals:
	loadscript scriptHlp.oldManScript_givesBookOfSeals

oldManScript_givesFairyPowder:
	loadscript scriptHlp.oldManScript_givesFairyPowder

oldManScript_generic:
	makeabuttonsensitive
@npcLoop:
	checkabutton
	turntofacelink
	showloadedtext
	asm15 scriptHlp.oldManSetAnimationToVar38
	jump2byte @npcLoop

; ==============================================================================
; INTERACID_MAMAMU_YAN
; ==============================================================================
mamamuYanScript:
	loadscript scriptHlp.mamamuYanScript

; ==============================================================================
; INTERACID_MAMAMU_DOG
; ==============================================================================
dogInMamamusHouseScript:
	asm15 scriptHlp.mamamuDog_setCounterRandomly
@loop:
	asm15 scriptHlp.mamamuDog_decCounter
	jumpifmemoryset $cddb, $80, @counterHit0
	asm15 scriptHlp.mamamuDog_updateSpeedZ
	asm15 scriptHlp.mamamuDog_checkReverseDirection
	jump2byte @loop

@counterHit0:
	asm15 scriptHlp.mamamuDog_setZPositionTo0
	asm15 scriptHlp.mamamuDog_reverseDirection
	wait 180
	asm15 scriptHlp.mamamuDog_reverseDirection
	jump2byte dogInMamamusHouseScript

; ==============================================================================
; INTERACID_POSTMAN
; ==============================================================================
postmanScript:
	loadscript scriptHlp.postmanScript


; ==============================================================================
; INTERACID_PICKAXE_WORKER
; ==============================================================================

; Worker below Maku Tree screen in past
pickaxeWorkerSubid00Script:
	initcollisions
@npcLoop:
	asm15 interactionSetAnimation $02
	checkabutton
	asm15 interactionSetAnimation $03
	showtextlowindex <TX_1b00
	jump2byte @npcLoop


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
	asm15 scriptHlp.pickaxeWorker_setRandomDelay

	setanimation $05
	setanimation $06
	setangle $00
	applyspeed $10
	wait 8
	asm15 scriptHlp.pickaxeWorker_setRandomDelay

	setanimation $05
	jump2byte @loop


pickaxeWorkerSubid02Script_part1:
	setanimation $04
	addobjectbyte Interaction.animCounter, $08
	setspeed SPEED_080
@loop:
	setanimation $06
	setangle $00
	applyspeed $10
	wait 8
	asm15 scriptHlp.pickaxeWorker_setRandomDelay

	setanimation $04
	setanimation $06
	setangle $10
	applyspeed $10
	wait 8
	asm15 scriptHlp.pickaxeWorker_setRandomDelay

	setanimation $04
	jump2byte @loop

pickaxeWorkerSubid01Script_part2:
	loadscript scriptHlp.pickaxeWorkerSubid01Script_part2

pickaxeWorkerSubid01Script_part3:
	writeobjectbyte Interaction.var3f, $01
	checkpalettefadedone
	wait 60

	writememory $cfc0, $07
	wait 90

	writeobjectbyte Interaction.var3f, $00
	setangle $18
	applyspeed $40
	wait 120

	writememory $cfdf, $ff
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
	checkmemoryeq $cfc0, $04
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
	asm15 scriptHlp.pickaxeWorker_setAnimationFromVar03
	initcollisions
@npcLoop:
	checkabutton
	asm15 scriptHlp.pickaxeWorker_chooseRandomBlackTowerText
	showloadedtext
	jump2byte @npcLoop


; ==============================================================================
; INTERACID_HARDHAT_WORKER
; ==============================================================================

; NPC who gives you the shovel. If var03 is nonzero, he's just a generic guy.
hardhatWorkerSubid00Script:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	asm15 scriptHlp.turnToFaceLink
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
	jump2byte @enableInput

@doesntGiveShovel:
	showtextlowindex <TX_1000

@enableInput:
	setanimation $04
	enableinput
	jump2byte @npcLoop


; Generic NPC.
hardhatWorkerSubid01Script:
	jumptable_objectbyte Interaction.var03
	.dw @var03_00
	.dw @var03_01

@var03_00:
	asm15 scriptHlp.hardhatWorker_checkBlackTowerProgressIs00
	jumpifmemoryset $cddb, $80, ++
	scriptend
++
	rungenericnpclowindex <TX_1007

@var03_01:
	asm15 scriptHlp.hardhatWorker_checkBlackTowerProgressIs01
	jumpifmemoryset $cddb, $80, ++
	scriptend
++
	rungenericnpclowindex <TX_1008


hardhatWorkerSubid02Script:
	loadscript scriptHlp.hardhatWorkerSubid02Script


hardhatWorkerSubid03Script:
	loadscript scriptHlp.hardhatWorkerSubid03Script


; The object moves for [var3c] frames, and its direction is stored in [var3e]. When
; [var3c] hits 0, this returns. The object can also be talked to by Link while doing this.
scriptFunc_patrol:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	asm15 scriptHlp.hardhatWorker_decPatrolCounter
	jumpifmemoryset $cddb, $80, @doneMoving
	asm15 objectApplySpeed
	jump2byte scriptFunc_patrol

@doneMoving:
	wait 20
	retscript

@pressedA:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	asm15 scriptHlp.turnToFaceLink
	showloadedtext
	wait 30

	asm15 scriptHlp.hardhatWorker_updatePatrolAnimation
	enableinput
	jump2byte scriptFunc_patrol


; ==============================================================================
; INTERACID_POE
; ==============================================================================
poeScript:
	loadscript scriptHlp.poeScript

; ==============================================================================
; INTERACID_OLD_ZORA
; ==============================================================================
oldZoraScript:
	loadscript scriptHlp.oldZoraScript

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
	asm15 scriptHlp.toiletHand_checkLinkIsClose
	jumpifmemoryset $cddb, $10, @waitForLinkToApproach

	callscript @retreatAndReturnFromToilet
@waitForLinkToRetreat:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	asm15 scriptHlp.toiletHand_checkLinkIsClose
	jumpifmemoryset $cddb, $10, @linkRetreated
	jump2byte @waitForLinkToRetreat

@linkRetreated:
	callscript @retreatIntoToilet
	jump2byte @npcLoop

@waitForLinkToReapproach:
	asm15 scriptHlp.toiletHand_checkLinkIsClose
	jumpifmemoryset $cddb, $10, ++
	jump2byte @waitForLinkToReapproach
++
	jump2byte @npcLoop

@pressedA:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	jumpifroomflagset $20, @alreadyGaveStinkBag
	showtextlowindex <TX_0b07
	jumpiftradeitemeq $02, @promptForTrade

	; Don't have correct trade item
	callscript @retreatIntoToiletAfterDelay
	enableinput
	jump2byte @waitForLinkToReapproach

@promptForTrade:
	wait 30
	showtextlowindex <TX_0b08
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

	; Declined trade
	showtextlowindex <TX_0b0a
	callscript @retreatIntoToiletAfterDelay
	enableinput
	jump2byte @waitForLinkToReapproach

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
	jump2byte @waitForLinkToReapproach

@alreadyGaveStinkBag:
	showtextlowindex <TX_0b09
	callscript @retreatIntoToiletAfterDelay
	enableinput
	jump2byte @waitForLinkToReapproach


; Script functions

@retreatAndReturnFromToiletAfterDelay:
	wait 30
@retreatAndReturnFromToilet:
	writeobjectbyte Interaction.pressedAButton, $00
	asm15 objectSetVisible
	asm15 scriptHlp.toiletHand_disappear
	checkobjectbyteeq Interaction.animParameter, $ff
	asm15 scriptHlp.toiletHand_comeOutOfToilet
	retscript


@retreatIntoToiletAfterDelay:
	wait 30
@retreatIntoToilet:
	asm15 scriptHlp.toiletHand_retreatIntoToilet

_toiletHandScriptFunc_waitUntilFullyRetreated:
	checkobjectbyteeq Interaction.animParameter, $ff
	asm15 objectSetInvisible
	retscript


; Script runs when Link drops an object in a hole. var38 is set to an index based on which
; item it was.
toiletHandScript_reactToObjectInHole:
	asm15 scriptHlp.toiletHand_checkVisibility

	; This is weird. Did they mean to check bit 7? That would check visibility.
	; Instead this checks his draw priority (bits 0-2).
	jumpifmemoryset $cddb, $07, @retreatIntoToilet

	wait 90
	jump2byte @react

@retreatIntoToilet:
	asm15 scriptHlp.toiletHand_retreatIntoToiletIfNotAlready
	callscript _toiletHandScriptFunc_waitUntilFullyRetreated
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
	loadscript scriptHlp.maskSalesmanScript


; ==============================================================================
; INTERACID_BEAR
; ==============================================================================

; Bear listening to Nayru at start of game.
bearSubid00Script_part1:
	initcollisions
	jumpifroomflagset $80, @alreadyMovedDown

@npcLoop:
	checkabutton
	ormemory $cfde, $10
	jumpifmemoryeq $cfde, $1f, @moveDown
	showtext TX_5702
	jump2byte @npcLoop

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
	setdisabledobjectsto00

@justSitAndListen:
	showtext TX_5703

@alreadyMovedDown:
	checkabutton
	jump2byte @justSitAndListen

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
	jump2byte @npcLoop


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
	jumptable_objectbyte Interaction.var37
	.dw @buyMagicPotion
	.dw @buyGashaSeed
	.dw @buyMagicPotion
	.dw @buyGashaSeed
	.dw @buyBombchus

@buyMagicPotion:
	showtextnonexitable TX_0d01
	jump2byte @checkAcceptPurchase

@buyGashaSeed:
	showtextnonexitable TX_0d05
	jump2byte @checkAcceptPurchase

@buyBombchus:
	showtextnonexitable TX_0d0a

@checkAcceptPurchase:
	jumpiftextoptioneq $00, @tryToPurchase

	; Said "no" when asked to purchase
	writeobjectbyte Interaction.var3a, $ff
	writememory wcbad, $03
	writememory wTextIsActive, $01
	scriptend

@tryToPurchase:
	jumpifmemoryeq wShopHaveEnoughRupees, $00, @enoughRupees
	writeobjectbyte Interaction.var3a, $ff
	writememory $cbad, $01
	writememory $cba0, $01
	scriptend

@enoughRupees:
	jumptable_objectbyte Interaction.var38
	.dw @buy
	.dw _shopkeeperCantBuy
@buy:
	writeobjectbyte Interaction.var3a, $01
	writememory wcbad $00
	writememory wTextIsActive, $01
	scriptend


; ==============================================================================
; INTERACID_COMEDIAN
; ==============================================================================
comedianScript:
	loadscript scriptHlp.comedianScript


; ==============================================================================
; INTERACID_GORON
; ==============================================================================
script67c8:
	setcollisionradii $0a $0c
	makeabuttonsensitive
script67cc:
	checkabutton
	disableinput
	asm15 scriptHlp.goron_checkInPresent
	jumpifmemoryset $cddb $80 script67df
	jumpifitemobtained $44 script67ee
	jumpifitemobtained $59 script67f9
script67df:
	jumpifitemobtained $5b script67ee
	asm15 $6398 $00
	wait 30
	jumpiftextoptioneq $00 script6809
	jump2byte script6801
script67ee:
	asm15 $6398 $01
	wait 30
	jumpiftextoptioneq $00 script6809
	jump2byte script6801
script67f9:
	showtext $2419
	wait 30
	jumpiftextoptioneq $00 script6809
script6801:
	asm15 $6398 $03
	wait 1
	enableinput
	jump2byte script67cc
script6809:
	callscript script68d8
	jumpifmemoryset $cddb $80 script681a
script6812:
	asm15 $6398 $09
	enableinput
	checkabutton
	jump2byte script6812
script681a:
	disableinput
	callscript script68eb
	asm15 $6398 $02
	wait 30
	jumpiftextoptioneq $00 script6848
script6827:
	asm15 $6398 $04
	wait 30
	playsound $cd
	setanimation $03
	wait 30
	asm15 $6398 $05
	wait 30
	playsound $c8
	setanimation $06
	wait 30
	asm15 $6398 $06
	wait 30
	setanimation $02
	jumpiftextoptioneq $00 script6848
	jump2byte script6827
script6848:
	asm15 scriptHlp.goron_checkInPresent
	jumpifmemoryset $cddb $80 script6859
	jumpifitemobtained $44 script6872
	jumpifitemobtained $59 script685d
script6859:
	jumpifitemobtained $5b script6872
script685d:
	asm15 scriptHlp.goron_checkInPresent
	jumpifmemoryset $cddb $80 script686c
	writememory $cfdd $02
	jump2byte script687b
script686c:
	writememory $cfdd $03
	jump2byte script687b
script6872:
	asm15 $6398 $0b
	wait 30
	callscript script6899
	wait 30
script687b:
	asm15 $6398 $07
	wait 40
	asm15 fadeoutToWhite
	checkpalettefadedone
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 $6331
	wait 40
	asm15 fadeinFromWhite
	checkpalettefadedone
	asm15 restartSound
	wait 40
	asm15 $6398 $08
	wait 40
	scriptend
script6899:
	asm15 scriptHlp.goron_checkInPresent
	jumpifmemoryset $cddb $80 script68ab
	jumptable_memoryaddress wSelectedTextOption
	.dw script68b4
	.dw script68bd
	.dw script68c6
script68ab:
	jumptable_memoryaddress wSelectedTextOption
	.dw script68bd
	.dw script68c6
	.dw script68cf
script68b4:
	writememory $cfdd $00
	asm15 $6398 $0c
	retscript
script68bd:
	writememory $cfdd $01
	asm15 $6398 $0d
	retscript
script68c6:
	writememory $cfdd $02
	asm15 $6398 $0e
	retscript
script68cf:
	writememory $cfdd $03
	asm15 $6398 $0f
	retscript
script68d8:
	asm15 scriptHlp.goron_checkInPresent
	jumpifmemoryset $cddb $80 script68e6
	asm15 scriptHlp.shootingGallery_checkLinkHasRupees $05
	retscript
script68e6:
	asm15 scriptHlp.shootingGallery_checkLinkHasRupees $04
	retscript
script68eb:
	asm15 scriptHlp.goron_checkInPresent
	jumpifmemoryset $cddb $80 script68f9
	asm15 removeRupeeValue $05
	retscript
script68f9:
	asm15 removeRupeeValue $04
	retscript
script68fe:
	callscript script6959
	wait 30
	jumptable_memoryaddress $cfdb
	.dw script690d
	.dw script690d
	.dw script6913
	.dw script6919
script690d:
	asm15 $6398 $16
	wait 30
	scriptend
script6913:
	asm15 $6398 $17
	wait 30
	scriptend
script6919:
	resetmusic
	asm15 $6398 $18
	wait 30
	asm15 $6398 $15
	wait 30
	jumpiftextoptioneq $00 script6934
	asm15 $6398 $03
	wait 1
	asm15 $62ef
	enableinput
	jump2byte script67cc
script6934:
	callscript script68d8
	jumpifmemoryset $cddb $80 script6946
script693d:
	asm15 $6398 $09
	wait 1
	enableinput
	checkabutton
	jump2byte script693d
script6946:
	asm15 restartSound
	callscript script68eb
	asm15 $6398 $07
	wait 30
	asm15 $6398 $08
	asm15 $630a
	scriptend
script6959:
	jumptable_memoryaddress $cfd1
	.dw script6962
	.dw script6966
	.dw script696a
script6962:
	showtext $313f
	retscript
script6966:
	showtext $3140
	retscript
script696a:
	showtext $3141
	retscript
script696e:
	wait 30
	resetmusic
	asm15 scriptHlp.goron_checkInPresent
	jumpifmemoryset $cddb $80 script6982
	jumpifitemobtained $44 script69ac
	jumpifitemobtained $59 script699a
script6982:
	jumpifitemobtained $5b script69ac
	asm15 $6398 $10
	wait 30
	giveitem $5b00
	wait 30
	asm15 $6398 $11
	wait 30
	asm15 $62ef
	enableinput
	jump2byte script67cc
script699a:
	showtext $241a
	wait 30
	giveitem $4400
	wait 30
	showtext $241b
	wait 30
	asm15 $62ef
	enableinput
	jump2byte script67cc
script69ac:
	asm15 $635b
	jumpifmemoryset $cddb $80 script69c0
	asm15 $6398 $13
	wait 1
	callscript script69d4
	wait 30
	jump2byte script69c9
script69c0:
	asm15 $6398 $12
	wait 1
	callscript script69f3
	wait 30
script69c9:
	asm15 $6398 $14
	wait 30
	asm15 $62ef
	enableinput
	jump2byte script67cc
script69d4:
	jumptable_memoryaddress $cfdd
	.dw script69df
	.dw script69df
	.dw script69e3
	.dw script69eb
script69df:
	giveitem $3400
	retscript
script69e3:
	asm15 $511f $0b
	showtext $0006
	retscript
script69eb:
	asm15 $511f $07
	showtext $0005
	retscript
script69f3:
	jumptable_memoryaddress $cfdd
	.dw script69fe
	.dw script69fe
	.dw script6a02
	.dw script6a06
script69fe:
	asm15 $6370
	retscript
script6a02:
	giveitem $3400
	retscript
script6a06:
	asm15 $511f $0c
	showtext $0007
	retscript


goron_subid01Script:
	initcollisions
@npcLoop:
	checkabutton
	callscript @showText
	jump2byte @npcLoop

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
	asm15 scriptHlp.goron_decideTextToShow_differentForLinkedInPast, <TX_2440
	retscript
@val01:
	asm15 scriptHlp.goron_decideTextToShow_differentForLinkedInPast, <TX_2441
	retscript
@val02:
	asm15 scriptHlp.goron_decideTextToShow_differentForLinkedInPast, <TX_2442
	retscript
@val03:
	asm15 scriptHlp.goron_decideTextToShow_differentForLinkedInPast, <TX_2443
	retscript
@val04:
	asm15 scriptHlp.goron_decideTextToShow_differentForLinkedInPast, <TX_2444
	retscript
@val05:
	asm15 scriptHlp.goron_decideTextToShow_differentForLinkedInPast, <TX_2445
	retscript
@val06:
	asm15 scriptHlp.goron_decideTextToShow_differentForLinkedInPast, <TX_2446
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
	asm15 scriptHlp.checkEssenceObtained, $04
	jumpifmemoryset $cddb, CPU_ZFLAG, stubScript

_goron_moveBackAndForth:
	asm15 scriptHlp.goron_beginWalkingLeft
	initcollisions

_goron_moveBackAndForthLoop:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	asm15 scriptHlp.goron_decMovementCounter
	jumpifmemoryset $cddb, CPU_ZFLAG, @turnAround
	asm15 objectApplySpeed
	jump2byte _goron_moveBackAndForthLoop

@turnAround:
	asm15 scriptHlp.goron_reverseWalkingDirection
	jump2byte _goron_moveBackAndForthLoop

@pressedA:
	jumpifobjectbyteeq Interaction.subid, $0d, script70b0
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	asm15 scriptHlp.turnToFaceLink
	asm15 scriptHlp.goron_showTextForGoronWorriedAboutElder
	wait 30
	asm15 scriptHlp.goron_refreshWalkingAnimation
	enableinput
	jump2byte _goron_moveBackAndForthLoop


goron_subid05Script_A:
	; Delete self if beaten d5
	asm15 scriptHlp.checkEssenceObtained, $04
	jumpifmemoryset $cddb, CPU_ZFLAG, stubScript
	jump2byte ++

goron_subid05Script_B:
	; Delete self if not beaten d5
	asm15 scriptHlp.checkEssenceNotObtained, $04
	jumpifmemoryset $cddb, CPU_ZFLAG, stubScript
++
	initcollisions

; Below napping code is used by other subids as well.

; Decide whether goron should be napping or not, enter appropriate loop.
_goron_chooseNappingLoop:
	asm15 scriptHlp.goron_checkShouldBeNapping
	jumpifmemoryset $cddb, CPU_CFLAG, _goron_beginNappingLoop
	jump2byte _goron_beginNotNappingLoop


; Goron naps until Link approaches.
_goron_beginNappingLoop:
	asm15 scriptHlp.goron_setAnimation, $04 ; Nap animation

_goron_nappingLoop:
	asm15 scriptHlp.goron_checkShouldBeNapping
	jumpifmemoryset $cddb, CPU_CFLAG, ++
	jump2byte _goron_beginNotNappingLoop
++
	wait 1
	jump2byte _goron_nappingLoop


; Goron is standing up until Link walks away.
_goron_beginNotNappingLoop:
	asm15 scriptHlp.goron_faceDown

_goron_notNappingLoop:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	asm15 scriptHlp.goron_checkShouldBeNapping
	jumpifmemoryset $cddb, CPU_CFLAG, ++
	jump2byte _goron_notNappingLoop
++
	jump2byte _goron_beginNappingLoop

@pressedA:
	jumpifobjectbyteeq Interaction.subid, $07, _goron_subid07_pressedAFromNappingLoop
	jumpifobjectbyteeq Interaction.subid, $08, _goron_subid08_pressedAFromNappingLoop
	jumpifobjectbyteeq Interaction.subid, $0a, script6eb0
	jumpifobjectbyteeq Interaction.subid, $0b, script6f0d
	jumpifobjectbyteeq Interaction.subid, $0e, script70c9

	; Subid $05?
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	asm15 scriptHlp.goron_showTextForSubid05
	wait 1
	enableinput
	jump2byte _goron_notNappingLoop


; Goron who's trying to break the elder out of rock (one on the left)
goron_subid06Script_A:
	; Delete self if beaten d5
	asm15 scriptHlp.checkEssenceObtained, $04
	jumpifmemoryset $cddb, CPU_ZFLAG, stubScript

	initcollisions
	jumpifglobalflagset GLOBALFLAG_2f, @alreadySavedElder

@doRockPunchingAnimation:
	asm15 scriptHlp.goron_setAnimation, $08
@checkCreateRockDebris:
	jumpifobjectbyteeq Interaction.animParameter, $01, @createDebrisToLeft
	jumpifobjectbyteeq Interaction.animParameter, $02, @createDebrisToRight
@checkEvents:
	jumpifmemoryeq $cfdd, $01, @beginBombFlowerCutscene ; Check bomb flower cutscene started?
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	wait 1
	jump2byte @checkCreateRockDebris

@createDebrisToLeft:
	asm15 scriptHlp.goron_createRockDebrisToLeft
	jump2byte @checkEvents
@createDebrisToRight:
	asm15 scriptHlp.goron_createRockDebrisToRight
	jump2byte @checkEvents

@pressedA:
	disableinput
	asm15 scriptHlp.goron_faceDown
	writeobjectbyte Interaction.pressedAButton, $00
	showtext TX_247b
	wait 30
	enableinput
	jump2byte @doRockPunchingAnimation

@beginSavedElderLoop:
	asm15 scriptHlp.goron_faceDown

@alreadySavedElder:
	asm15 scriptHlp.checkEssenceNotObtained, $04
	jumpifmemoryset $cddb, CPU_ZFLAG, @npcLoop
	setcoords $88, $28 ; After beating d5, change position
@npcLoop:
	checkabutton
	showtext TX_247c
	jump2byte @npcLoop

@beginBombFlowerCutscene:
	asm15 scriptHlp.goron_setAnimation, $00
@waitBeforeFacingDown:
	jumpifmemoryeq $cfc0, $01, @beginSavedElderLoop
	wait 1
	jump2byte @waitBeforeFacingDown


; Goron who's trying to break the elder out of rock (one on the right)
goron_subid06Script_B:
	; Delete self if beaten d5
	asm15 scriptHlp.checkEssenceObtained, $04
	jumpifmemoryset $cddb, CPU_ZFLAG, stubScript

	initcollisions
	jumpifglobalflagset GLOBALFLAG_2f, @alreadySavedElder

@doRockPunchingAnimation:
	asm15 scriptHlp.goron_setAnimation, $08
@checkCreateRockDebris:
	jumpifobjectbyteeq Interaction.animParameter, $01, @createDebrisToLeft
	jumpifobjectbyteeq Interaction.animParameter, $02, @createDebrisToRight
@checkEvents:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	asm15 scriptHlp.goron_checkLinkApproachedWithBombFlower
	jumpifmemoryset $cddb, CPU_CFLAG, @beginBombFlowerCutscene
	jump2byte @checkCreateRockDebris

@createDebrisToLeft:
	asm15 scriptHlp.goron_createRockDebrisToLeft
	jump2byte @checkEvents
@createDebrisToRight:
	asm15 scriptHlp.goron_createRockDebrisToRight
	jump2byte @checkEvents


@beginBombFlowerCutscene:
	disableinput
	asm15 scriptHlp.goron_putLinkInState08
	asm15 scriptHlp.forceLinkDirection, $03
	asm15 scriptHlp.goron_setSpeedToMoveDown

; Move down toward Link
@moveDownLoop:
	asm15 objectApplySpeed
	asm15 scriptHlp.goron_cpLinkY
	jumpifmemoryset $cddb, CPU_ZFLAG, @beginMovingRight
	jump2byte @moveDownLoop

; Move right toward Link
@beginMovingRight:
	setanimation $01
	setangle $08
@moveRightLoop:
	asm15 objectApplySpeed
	asm15 scriptHlp.goron_checkReachedLinkHorizontally
	jumpifmemoryset $cddb, CPU_ZFLAG, @script6be1
	jump2byte @moveRightLoop

; Exclamation mark, ask Link to use bomb
@script6be1:
	wait 30
	asm15 scriptHlp.createExclamationMark, 40
	wait 60
	showtext TX_247e
	wait 30
	jumpiftextoptioneq $00, @giveBomb

@insistOnBomb:
	showtext TX_247f
	wait 30
	jumpiftextoptioneq $00, @giveBomb
	jump2byte @insistOnBomb

@giveBomb:
	showtext TX_2480
	wait 30
	writeobjectbyte Interaction.speed, SPEED_100
	setanimation $03
	setangle $18

; Move back to rock
@moveLeftLoop:
	asm15 objectApplySpeed
	asm15 scriptHlp.goron_cpXTo48
	jumpifmemoryset $cddb, CPU_ZFLAG, @beginMovingUp
	jump2byte @moveLeftLoop

@beginMovingUp:
	setanimation $00
	setangle $00
@moveUpLoop:
	asm15 objectApplySpeed
	asm15 scriptHlp.goron_cpYTo60
	jumpifmemoryset $cddb, CPU_ZFLAG, @placeBomb
	jump2byte @moveUpLoop

@placeBomb:
	writememory $cfdd, $01
	asm15 scriptHlp.goron_setAnimation, $03
	wait 20

	asm15 scriptHlp.goron_createBombFlowerSprite
	wait 50

	asm15 scriptHlp.goron_deleteTreasure
	asm15 scriptHlp.goron_createExplosionIndex, $00
	wait 22

	writeobjectbyte Interaction.var3a, $01
	writeobjectbyte Interaction.var3b, $ff
	asm15 scriptHlp.goron_initCountersForBombFlowerExplosion

@explosionLoop1:
	asm15 scriptHlp.goron_countdownToNextExplosionGroup
	asm15 scriptHlp.goron_countdownToPlayRockSoundAndShakeScreen
	asm15 scriptHlp.goron_decMovementCounter
	jumpifmemoryset $cddb, CPU_ZFLAG, @fadeToWhite
	jump2byte @explosionLoop1

@fadeToWhite:
	playsound SND_BIG_EXPLOSION
	asm15 fadeoutToWhiteWithDelay, $04

@explosionLoop2:
	asm15 scriptHlp.goron_countdownToNextExplosionGroup
	asm15 scriptHlp.goron_countdownToPlayRockSoundAndShakeScreen
	jumpifmemoryeq wPaletteThread_mode, $00, @screenFullyWhite
	wait 1
	jump2byte @explosionLoop2

@screenFullyWhite:
	wait 30
	writememory $cfde, $00
	spawninteraction INTERACID_GORON_ELDER, $00, $50, $38
	writememory $cfc0, $01
	asm15 scriptHlp.goron_faceDown
	asm15 scriptHlp.goron_clearRockBarrier
	wait 10

	asm15 fadeinFromWhite
	checkpalettefadedone

	asm15 scriptHlp.goron_createFallingRockSpawner
	wait 75

	writememory $cfdf, $01 ; Signal to stop falling rock spawner
	jump2byte @savedElderLoop


; Pressed A while trying to break down the rock
@pressedA:
	disableinput
	asm15 scriptHlp.goron_faceDown
	writeobjectbyte Interaction.pressedAButton, $00
	showtext TX_247d
	wait 30
	enableinput
	jump2byte @doRockPunchingAnimation


@alreadySavedElder:
	spawninteraction INTERACID_GORON_ELDER, $00, $50, $38
@savedElderLoop:
	checkabutton
	showtext TX_2481
	jump2byte @savedElderLoop



; Goron trying to break wall down to get at treasure.
; Bit 6 of room flags is set after giving the goron ember seeds/bombs.
; Bit 7 is set once he's finished breaking the wall down.
goron_subid07Script:
	initcollisions
	jumpifroomflagset $80, @brokeDownWall
	jumpifroomflagset $40, @alreadyGaveEmberSeedsAndBombs

	asm15 scriptHlp.goron_clearRefillBit
	jump2byte @doRockPunchingAnimation

@alreadyGaveEmberSeedsAndBombs:
	asm15 scriptHlp.goron_checkEnoughTimePassed
	jumpifmemoryset $cddb, CPU_ZFLAG, @justBrokeDownWall

@doRockPunchingAnimation:
	asm15 scriptHlp.goron_setAnimation, $08

@checkCreateRockDebris:
	jumpifobjectbyteeq Interaction.animParameter, $01, @createDebrisToLeft
	jumpifobjectbyteeq Interaction.animParameter, $02, @createDebrisToRight
@checkEvents:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	wait 1
	jump2byte @checkCreateRockDebris

@createDebrisToLeft:
	asm15 scriptHlp.goron_createRockDebrisToLeft
	jump2byte @checkEvents
@createDebrisToRight:
	asm15 scriptHlp.goron_createRockDebrisToRight
	jump2byte @checkEvents

@pressedA:
	disableinput
	asm15 scriptHlp.goron_faceDown
	writeobjectbyte Interaction.pressedAButton, $00
	jumpifroomflagset $40, @comeBackLaterText
	showtext TX_2472
	wait 30
	jumpiftextoptioneq $00, @tryGiveEmberSeedsAndBombs
	showtext TX_2473
	jump2byte @enableInput

@tryGiveEmberSeedsAndBombs:
	asm15 scriptHlp.goron_tryTakeEmberSeedsAndBombs
	jumpifmemoryset $cddb, $80, @gaveEmberSeedsAndBombs

	; Not enough bombs/seeds
	showtext TX_2474
	jump2byte @enableInput

@gaveEmberSeedsAndBombs:
	playsound SND_GETSEED
	showtext TX_2475
	orroomflag $40
@enableInput:
	wait 30
	enableinput
	jump2byte @doRockPunchingAnimation
@comeBackLaterText:
	showtext TX_2476
	jump2byte @enableInput


@justBrokeDownWall:
	orroomflag $80
@brokeDownWall:
	setcoords $38, $58
	jump2byte _goron_beginNappingLoop


_goron_subid07_pressedAFromNappingLoop:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	jumpifroomflagset ROOMFLAG_ITEM, @alreadyGotItem
	jumpifmemoryeq $cfc0, $01, @alreadyGotItem

; Ask Link which chest he wants
	setspeed SPEED_100
	showtext TX_2477
	wait 30
	jumpiftextoptioneq $00, @leftChest
	
; Right chest
	asm15 scriptHlp.goron_setAnimation $00
	setangle $00
	applyspeed $11
	asm15 scriptHlp.goron_setAnimation $03
	setanimation $03
	setangle $18
	jump2byte @moveBack

@leftChest:
	asm15 scriptHlp.goron_setAnimation $00
	setangle $00
	applyspeed $11
	asm15 scriptHlp.goron_setAnimation $01
	setanimation $01
	setangle $08

@moveBack:
	applyspeed $11
	writememory $cfc0 $01
	enableinput
	jump2byte _goron_beginNotNappingLoop

@alreadyGotItem:
	showtext TX_2478
	wait 30
	enableinput
	jump2byte _goron_notNappingLoop


; Goron guarding the staircase until you get brother's emblem (both eras)
goron_subid08Script:
	initcollisions
	jumpifroomflagset $80, @moved
	jump2byte _goron_beginNappingLoop
@moved:
	setcoords $58, $78
	jump2byte _goron_beginNappingLoop

_goron_subid08_pressedAFromNappingLoop:
	loadscript scriptHlp.goron_subid08_pressedAScript


goron_subid09Script_A:
	initcollisions
@npcLoop:
	jumpifobjectbyteeq Interaction.pressedAButton, $01, @pressedA
	jumpifmemoryeq $cfdb, $01, @saidYes
	wait 1
	jump2byte @npcLoop

@pressedA:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00

	; Ask to play the gam
	showtext TX_24a8
	wait 30
	jumpiftextoptioneq $00, @saidYes
	showtext TX_24a9
	enableinput
	jump2byte @npcLoop

@saidYes:
	asm15 scriptHlp.shootingGallery_checkLinkHasRupees, RUPEEVAL_10
	jumpifmemoryset $cddb, CPU_ZFLAG, @enoughRupees

@notEnoughRupeesLoop:
	showtext TX_24aa
	enableinput
	checkabutton
	jump2byte @notEnoughRupeesLoop

@enoughRupees:
	asm15 removeRupeeValue, RUPEEVAL_10
	showtext TX_24ab
	wait 30
	showtext TX_24ac
	wait 30
	asm15 $6698
	wait 90

	asm15 fadeoutToWhite
	checkpalettefadedone

	asm15 scriptHlp.goron_deleteCrystalsForTargetCarts
	asm15 scriptHlp.goron_deleteTreasure
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 scriptHlp.goron_setLinkPositionToTargetCartPlatform
	asm15 scriptHlp.goron_configureInventoryForTargetCarts

	spawninteraction INTERACID_MINECART, $00, $78, $38
	wait 20

	asm15 $6839
	wait 20
	asm15 fadeinFromWhite
	checkpalettefadedone
	wait 40
	setmusic $02
	showtext TX_24ad
	wait 30
	asm15 $679e
	setdisabledobjectsto00
	jump2byte @npcLoop

script6de5:
	initcollisions
	jumpifroomflagset $80 script6dfc
script6dea:
	jumpifobjectbyteeq $71 $01 script6df2
	wait 1
	jump2byte script6dea
script6df2:
	disableinput
	writeobjectbyte $71 $00
	showtext $24ae
	enableinput
	jump2byte script6dea
script6dfc:
	asm15 $67bd
	jumpifmemoryset $cddb $80 script6e07
	jump2byte script6e0a
script6e07:
	wait 1
	jump2byte script6dfc
script6e0a:
	asm15 $67bd
	jumpifmemoryset $cddb $80 script6e15
	jump2byte script6e0a
script6e15:
	disableinput
	asm15 scriptHlp.forceLinkDirectionAndPutOnGround $03
	writememory $ccd5 $01
	wait 40
	asm15 $67ae
	asm15 $67cc
	showtext $24af
	wait 30
	asm15 fadeoutToWhite
	checkpalettefadedone
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 $633f
	asm15 scriptHlp.goron_restoreInventoryAfterTargetCarts
	asm15 scriptHlp.goron_deleteMinecartAndClearStaticObjects
	wait 40
	asm15 fadeinFromWhite
	checkpalettefadedone
	resetmusic
	wait 40
	asm15 $67da
	jumpifmemoryset $cddb $80 script6e59
	asm15 $67e2
	jumpifmemoryset $cddb $10 script6e8c
	showtext $24b2
	wait 30
	jump2byte script6e97
script6e59:
	showtext $24b0
	wait 30
	callscript script6e63
	wait 30
	jump2byte script6e97
script6e63:
	jumptable_memoryaddress $cfd6
	.dw script6e70
	.dw script6e74
	.dw script6e7c
	.dw script6e84
	.dw script6e88
script6e70:
	giveitem $5e00
	retscript
script6e74:
	asm15 $511f $0b
	showtext $0006
	retscript
script6e7c:
	asm15 $511f $0c
	showtext $0007
	retscript
script6e84:
	giveitem $3400
	retscript
script6e88:
	giveitem $0602
	retscript
script6e8c:
	showtext $24b1
	asm15 $511f $05
	showtext $0004
	wait 30
script6e97:
	showtext $24b3
	wait 30
	jumpiftextoptioneq $00 script6ea7
	jump2byte script6ea1
script6ea1:
	showtext $24b4
	enableinput
	jump2byte script6dea
script6ea7:
	writememory $cfdb $01
	jump2byte script6dea
script6ead:
	initcollisions
	jump2byte _goron_beginNappingLoop
script6eb0:
	disableinput
	writeobjectbyte $71 $00
	jumpifobjectbyteeq $7c $01 script6eff
	showtext $24c4
	wait 30
	jumpifroomflagset $40 script6f04
	asm15 $686d
	jumptable_objectbyte $7e
	.dw script6ecc
	.dw script6ef5
	.dw script6efa
script6ecc:
	showtext $24c6
	wait 30
	showtext $24c7
	wait 30
	showtext $24c8
	wait 30
	jumpiftextoptioneq $00 script6ee1
	showtext $24cb
	jump2byte goron_enableInputAndResumeNappingLoop
script6ee1:
	asm15 loseTreasure $5a
	showtext $24c9
	giveitem $5900
	orroomflag $40
	showtext $24ca
	writeobjectbyte $7c $01
	jump2byte goron_enableInputAndResumeNappingLoop
script6ef5:
	showtext $24cd
	jump2byte goron_enableInputAndResumeNappingLoop
script6efa:
	showtext $24ce
	jump2byte goron_enableInputAndResumeNappingLoop
script6eff:
	showtext $24cc
	jump2byte goron_enableInputAndResumeNappingLoop
script6f04:
	showtext $24c5
goron_enableInputAndResumeNappingLoop:
	enableinput
	jump2byte _goron_chooseNappingLoop
script6f0a:
	initcollisions
	jump2byte _goron_beginNappingLoop
script6f0d:
	disableinput
	writeobjectbyte $71 $00
	jumpifroomflagset $40 script6f42
	showtext $24b5
	wait 30
	jumpifitemobtained $5d script6f22
	showtext $24b6
	jump2byte goron_enableInputAndResumeNappingLoop
script6f22:
	showtext $24b7
	wait 30
	jumpiftextoptioneq $00 script6f2f
	showtext $24b8
	jump2byte goron_enableInputAndResumeNappingLoop
script6f2f:
	asm15 loseTreasure $5d
	orroomflag $40
	showtext $24b9
	wait 30
	jumpiftextoptioneq $00 script6f62
	showtext $24ba
	jump2byte goron_enableInputAndResumeNappingLoop
script6f42:
	showtext $24bf
	wait 30
	jumpiftextoptioneq $00 script6f4f
script6f4a:
	showtext $24c0
	jump2byte goron_enableInputAndResumeNappingLoop
script6f4f:
	asm15 scriptHlp.shootingGallery_checkLinkHasRupees $04
	jumpifmemoryset $cddb $80 script6f5e
script6f59:
	showtext $24c1
	jump2byte goron_enableInputAndResumeNappingLoop
script6f5e:
	asm15 removeRupeeValue $04
script6f62:
	showtext $24bb
	wait 30
	jumpiftextoptioneq $00 script6f74
script6f6a:
	showtext $24bd
	wait 30
	jumpiftextoptioneq $00 script6f74
	jump2byte script6f6a
script6f74:
	showtext $24bc
	wait 30
	asm15 $66f2
	wait 60
	showtext $24be
	wait 30
	asm15 fadeoutToWhite
	checkpalettefadedone
	asm15 $68e3
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 $6346
	asm15 scriptHlp.goron_deleteTreasure
	asm15 $6a6a $04
	wait 8
	callscript script7052
	wait 24
	asm15 fadeinFromWhite
	checkpalettefadedone
	setmusic $02
	wait 40
	playsound $cc
	wait 60
	writememory $cfc0 $00
	asm15 $690a
	enableinput
script6fac:
	jumpifmemoryeq $cfc0 $01 script6fe2
	asm15 $68fe
	jumpifmemoryset $cddb $80 script6fbd
	jump2byte script6fac
script6fbd:
	asm15 $67c5
	jumpifmemoryset $cddb $80 script6fc8
	jump2byte script6fbd
script6fc8:
	disableinput
	writeobjectbyte $71 $00
	playsound $65
	asm15 scriptHlp.forceLinkDirectionAndPutOnGround $02
	wait 2
	writememory $cc50 $02
	wait 80
	showtext $24e1
	callscript script702b
	jump2byte script700f
script6fe2:
	asm15 $67c5
	jumpifmemoryset $cddb $80 script6fed
	jump2byte script6fe2
script6fed:
	disableinput
	playsound $cc
	writeobjectbyte $71 $00
	wait 60
	asm15 scriptHlp.forceLinkDirectionAndPutOnGround $02
	wait 2
	playsound $ab
	writememory $cc50 $08
	wait 60
	showtext $24e0
	callscript script702b
	showtext $24c3
	wait 30
	callscript script706a
	wait 30
script700f:
	showtext $24c2
	wait 30
	jumpiftextoptioneq $00 script7019
	jump2byte script6f4a
script7019:
	asm15 scriptHlp.shootingGallery_checkLinkHasRupees $04
	jumpifmemoryset $cddb $80 script7025
	jump2byte script6f59
script7025:
	asm15 removeRupeeValue $04
	jump2byte script6f74
script702b:
	wait 30
	asm15 fadeoutToWhite
	checkpalettefadedone
	asm15 $68f0
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 $6346
	asm15 clearParts
	asm15 $6a6a $00
	wait 8
	asm15 $69c8
	wait 8
	asm15 $69cf
	wait 24
	asm15 fadeinFromWhite
	checkpalettefadedone
	resetmusic
	wait 40
	retscript
script7052:
	getrandombits $7d $01
	jumpifobjectbyteeq $7d $01 script7062
	asm15 $69ac
	wait 8
	asm15 $69b3
	retscript
script7062:
	asm15 $69ba
	wait 8
	asm15 $69c1
	retscript
script706a:
	jumptable_memoryaddress $cfd6
	.dw script7079
	.dw script707d
	.dw script7085
	.dw script708d
	.dw script7091
	.dw script7095
script7079:
	giveitem $4500
	retscript
script707d:
	asm15 $511f $0c
	showtext $0007
	retscript
script7085:
	asm15 $511f $07
	showtext $0005
	retscript
script708d:
	giveitem $3400
	retscript
script7091:
	giveitem $2d14
	retscript
script7095:
	giveitem $2d15
	retscript
script7099:
	asm15 $6423
	jumpifobjectbyteeq $72 $ff stubScript
	initcollisions
script70a2:
	checkabutton
	showloadedtext
	jump2byte script70a2
script70a6:
	asm15 $6423
	jumpifobjectbyteeq $72 $ff stubScript
	jump2byte _goron_moveBackAndForth
script70b0:
	disableinput
	writeobjectbyte $71 $00
	asm15 scriptHlp.turnToFaceLink
	showloadedtext
	asm15 $6556
	enableinput
	jump2byte _goron_moveBackAndForthLoop
script70be:
	asm15 $6423
	jumpifobjectbyteeq $72 $ff stubScript
	initcollisions
	jump2byte _goron_beginNappingLoop
script70c9:
	disableinput
	writeobjectbyte $71 $00
	showloadedtext
	enableinput
	jump2byte _goron_notNappingLoop
script70d1:
	initcollisions
	writeobjectbyte $5c $00
script70d5:
	checkabutton
	disableinput
	asm15 $6888
	wait 1
	enableinput
	jump2byte script70d5
script70de:
	initcollisions
	checkabutton
	disableinput
	asm15 scriptHlp.turnToFaceLink
	showtextlowindex $10
	wait 30
	setspeed SPEED_020
	moveright $30
	wait 20
	writeobjectbyte $7e $09
	wait 20
	writeobjectbyte $7e $f7
	writeobjectbyte $48 $01
	setanimation $03
	wait 30
	showtextlowindex $11
	wait 30
	writeobjectbyte $7e $ff
	giveitem $1501
	wait 30
	orroomflag $40
	enableinput
	jump2byte script7109
script7108:
	initcollisions
script7109:
	checkabutton
	showtextlowindex $12
	jump2byte script7109
script710e:
	asm15 $5180
	jumpifmemoryset $cddb $80 stubScript
	rungenericnpclowindex $13
script7119:
	initcollisions
	jumptable_objectbyte $78
	.dw script7126
	.dw script7133
	.dw script713f
	.dw script7169
	.dw script716e
script7126:
	settextid $2700
script7129:
	checkabutton
	asm15 scriptHlp.turnToFaceLink
script712d:
	showloadedtext
	enableinput
	setanimation $02
	jump2byte script7129
script7133:
	checkabutton
	callscript script717f
	showtextlowindex $00
	wait 20
	settextid $2701
	jump2byte script712d
script713f:
	checkabutton
	callscript script717f
	wait 20
	asm15 scriptHlp.createExclamationMark $3c
	wait 30
	showtextlowindex $02
	wait 30
script714c:
	showtextlowindex $03
	jumpiftextoptioneq $00 script715e
	wait 20
	showtextlowindex $04
	enableinput
	setanimation $02
	checkabutton
	callscript script717f
	jump2byte script714c
script715e:
	asm15 loseTreasure $52
	wait 20
	showtextlowindex $05
	wait 20
	setglobalflag $15
	enableinput
script7169:
	settextid $2706
	jump2byte script7129
script716e:
	disableinput
	wait 100
	writeobjectbyte $60 $7f
	showtextlowindex $07
	wait 30
	setspeed SPEED_100
	moveright $40
	setglobalflag $26
	enableinput
	scriptend
script717f:
	disableinput
	asm15 scriptHlp.turnToFaceLink
	writeobjectbyte $60 $7f
	retscript
script7187:
	loadscript scriptHlp.script15_6b3d
script718b:
	initcollisions
	setcollisionradii $0c $06
	jumpifitemobtained $52 script719b
script7193:
	checkabutton
	showtextlowindex $0c
	asm15 $6b7f
	jump2byte script7193
script719b:
	checkabutton
	showtextlowindex $0d
	asm15 $6b7f
	jump2byte script719b
script71a3:
	scriptend
script71a4:
	jumpifroomflagset $40 script71c7
	asm15 $6bc0
	jumpifmemoryset $cddb $80 script71c7
	setcollisionradii $04 $18
	checkcollidedwithlink_ignorez
	disableinput
	asm15 $517a
	wait 40
	spawninteraction $3701 $50 $b0
	checkmemoryeq $cfc0 $01
	wait 40
	orroomflag $40
	enableinput
script71c7:
	scriptend
script71c8:
	loadscript scriptHlp.script15_6be7
script71cc:
	asm15 restartSound
	wait 120
	playsound $21
	writeobjectbyte $78 $04
script71d5:
	asm15 darkenRoom
	checkpalettefadedone
	wait 8
	asm15 brightenRoom
	checkpalettefadedone
	wait 8
	addobjectbyte $78 $ff
	jumpifobjectbyteeq $78 $00 script71e9
	jump2byte script71d5
script71e9:
	wait 30
	writememory $cfd1 $02
	wait 90
	writeobjectbyte $78 $0a
script71f2:
	asm15 darkenRoom_variant $04
	checkpalettefadedone
	wait 4
	asm15 brightenRoomWithSpeed $04
	checkpalettefadedone
	wait 4
	addobjectbyte $78 $ff
	jumpifobjectbyteeq $78 $00 script7208
	jump2byte script71f2
script7208:
	asm15 darkenRoom_variant $02
	checkpalettefadedone
	scriptend
script720e:
	setcollisionradii $02 $02
script7211:
	asm15 $6bc8
	wait 1
	jumpifobjectbyteeq $78 $00 script7211
	disableinput
	asm15 objectSetInvisible
	writeobjectbyte $45 $01
	jumptable_objectbyte $43
	.dw script7229
	.dw script7231
	.dw script723a
script7229:
	asm15 $6be1
	giveitem $0304
	wait 30
	scriptend
script7231:
	giveitem $5200
	writememory $cc24 $00
	wait 30
	scriptend
script723a:
	giveitem $2e00
	wait 30
	scriptend
simpleScript723f:
	ss_settile $68 $9e
	ss_setcounter1 $28
	ss_playsound $70
	ss_setinterleavedtile $43 $fa $1d $3
	ss_setinterleavedtile $45 $fa $1d $1
	ss_setinterleavedtile $53 $f4 $1e $3
	ss_setinterleavedtile $55 $f4 $1e $1
	ss_setcounter1 $28
	ss_playsound $70
	ss_settile $43 $1d
	ss_settile $45 $1d
	ss_settile $53 $1e
	ss_settile $55 $1e
	ss_setcounter1 $28
	ss_playsound $70
	ss_settile $44 $1d
	ss_settile $54 $1e
	ss_setcounter1 $28
	ss_playsound $4d
	ss_end
script7279:
	checkmemoryeq $cfc0 $01
	setanimation $04
	checkmemoryeq $cfc0 $03
	wait 60
	writememory $cfc0 $04
	setspeed SPEED_040
	setangle $10
	scriptend
script728d:
	loadscript scriptHlp.script15_6cd7
script7291:
	loadscript scriptHlp.script15_6d03
script7295:
	loadscript scriptHlp.script15_6d14
script7299:
	asm15 $6d38
	wait 30
	setanimation $03
	wait 16
	setanimation $02
	wait 16
	showtext $5608
	asm15 $6d27
	wait 12
	showtext $5609
	wait 8
	writeobjectbyte $77 $01
	checkobjectbyteeq $77 $00
	scriptend
script72b8:
	asm15 playSound $98
	applyspeed $1e
	wait 30
	showtext $560a
	wait 15
	writeobjectbyte $49 $10
	applyspeed $14
	wait 8
	scriptend
script72ca:
	wait 30
	spawninteraction $6e01 $b0 $78
	checkmemoryeq $cfd0 $02
	wait 30
	setanimation $02
	showtext $1d04
	writememory $cfd0 $01
	checkmemoryeq $cfd0 $02
	wait 60
	applyspeed $1e
	checkmemoryeq $cfd0 $06
	setanimation $03
	wait 8
	showtext $1d05
	wait 30
	writememory $cfd0 $01
	checkmemoryeq $cfd0 $02
	setanimation $02
	wait 60
	setanimation $0b
	asm15 $6d45
	wait 60
	scriptend
script7302:
	wait 30
	showtext $1308
	asm15 playSound $1f
	setanimation $04
	applyspeed $30
	writememory $cfd0 $02
	checkmemoryeq $cfd0 $01
	asm15 $6d5e $00
	wait 20
	showtext $1309
	writememory $cfd0 $02
	spawninteraction $6e02 $00 $34
	scriptend
script7328:
	wait 60
	setanimation $04
	wait 30
	showtext $560d
	writememory $cfd0 $02
	wait 15
	asm15 $6d51 $00
	asm15 $6d51 $01
	asm15 $6d51 $02
	asm15 $6d51 $03
	asm15 $6d51 $04
	asm15 $6d51 $05
	checkmemoryeq $cfd0 $08
	wait 30
	spawninteraction $6e03 $b0 $78
	checkmemoryeq $cfd0 $03
	setanimation $06
	checkmemoryeq $cfd0 $04
	setanimation $07
	checkmemoryeq $cfd0 $05
	setanimation $04
	checkmemoryeq $cfd0 $01
	wait 30
	writememory $d008 $02
	asm15 $6d5e $01
	wait 1
	asm15 $6d5e $01
	wait 15
	showtext $130a
	wait 15
	writememory $cfd0 $02
script7383:
	wait 240
	jump2byte script7383
script7386:
	showtext $2a0c
	writememory $cfd0 $03
	setanimation $10
	applyspeed $10
	asm15 $6d6e $00
	applyspeed $08
	writememory $cfd0 $04
	asm15 $6d6e $01
	applyspeed $13
	writememory $d008 $03
	writememory $cfd0 $05
	applyspeed $10
	setanimation $11
	writememory $d008 $00
	wait 16
	writememory $cfd0 $06
	wait 2
	showtext $2a0d
	jump2byte script7383
script73be:
	applyspeed $10
	asm15 $6d6e $04
	applyspeed $20
	asm15 $6d6e $02
	applyspeed $42
	asm15 $6d6e $03
	applyspeed $15
	setanimation $0e
script73d4:
	checkmemoryeq $cfd0 $03
	setanimation $0e
	checkmemoryeq $cfd0 $04
	asm15 $6d9e
	checkmemoryeq $cfd0 $05
	asm15 $6d84
	checkmemoryeq $cfd0 $01
	checkmemoryeq $cfd0 $02
script73f0:
	applyspeed $08
	wait 30
	jump2byte script73f0
script73f5:
	wait 45
	applyspeed $10
	asm15 $6d6e $03
	applyspeed $20
	asm15 $6d6e $02
	applyspeed $42
	asm15 $6d6e $04
	applyspeed $15
	setanimation $0e
	jump2byte script73d4
script740f:
	wait 90
	applyspeed $10
	asm15 $6d6e $04
	applyspeed $20
	asm15 $6d6e $02
	applyspeed $23
	asm15 $6d6e $03
	applyspeed $0a
	jump2byte script73d4
script7426:
	wait 135
	applyspeed $10
	asm15 $6d6e $03
	applyspeed $20
	asm15 $6d6e $02
	applyspeed $23
	asm15 $6d6e $04
	applyspeed $0a
	jump2byte script73d4
script743e:
	wait 180
	applyspeed $10
	asm15 $6d6e $04
	applyspeed $12
	asm15 $6d6e $02
	applyspeed $0f
	jump2byte script73d4
script744f:
	wait 225
	applyspeed $10
	asm15 $6d6e $03
	applyspeed $12
	asm15 $6d6e $02
	applyspeed $0f
	writememory $cfd0 $08
	jump2byte script73d4
script7465:
	jumpifmemoryset $d13e $02 script746d
	jump2byte script7465
script746d:
	writeobjectbyte $7a $3c
	callscript script74d6
	showtext $2200
	ormemory $d13e $04
script747a:
	jumpifmemoryset $d13e $10 script7482
	jump2byte script747a
script7482:
	checkmemoryeq $cdd1 $00
	playsound $c8
	wait 20
	playsound $c8
	wait 20
	playsound $c8
	asm15 $6dcc
	writememory $d103 $02
	checkmemoryeq $d13d $01
	writeobjectbyte $7a $3c
	callscript script74d6
	showtext $2201
	writememory $d103 $03
	asm15 $6db6
	setdisabledobjectsto11
	asm15 $6dbe
	wait 60
	jumpifmemoryeq $cc01 $00 script74c1
	jumpifmemoryeq $c610 $0d script74bc
	jump2byte script74c1
script74bc:
	showtext $2204
	jump2byte script74c4
script74c1:
	showtext $2203
script74c4:
	ormemory wMooshState $20
	setdisabledobjectsto00
	checkmemoryeq $cc2c $d1
	showtext $2205
	writememory $cc91 $00
	enablemenu
	scriptend
script74d6:
	jumpifobjectbyteeq $7a $00 script74de
	wait 1
	jump2byte script74d6
script74de:
	retscript
script74df:
	loadscript scriptHlp.script15_6e73
script74e3:
	loadscript scriptHlp.script15_6e01
script74e7:
	checkmemoryeq $cc2c $d0
	checkmemoryeq $cc5c $00
	writememory $cbc3 $00
	disablemenu
	setdisabledobjectsto11
	turntofacelink
	showtext $2104
	writememory $d103 $03
	writememory $cc91 $00
	scriptend
script7502:
	loadscript scriptHlp.script15_6e4b
script7506:
	loadscript scriptHlp.script15_6eef
script750a:
	loadscript scriptHlp.script15_6eb6
script750e:
	loadscript scriptHlp.script15_6df0
script7512:
	wait 70
	showtext $2f1b
	wait 1
	writememory $cfd0 $01
	setanimation $00
script751e:
	applyspeed $40
	scriptend
script7521:
	checkmemoryeq $cfd0 $01
	setanimation $02
	jump2byte script751e
script7529:
	wait 30
	applyspeed $10
	wait 20
	setspeed SPEED_100
	applyspeed $18
	checkmemoryeq $cfd0 $02
	asm15 $6f13 $02
	applyspeed $30
	scriptend
script753c:
	wait 60
	applyspeed $10
	wait 20
	setspeed SPEED_100
	applyspeed $10
	checkmemoryeq $cfd0 $02
	asm15 $6f13 $01
	applyspeed $18
	scriptend
script754f:
	wait 90
	applyspeed $10
	wait 20
	setspeed SPEED_100
	applyspeed $18
	asm15 $6f13 $03
	applyspeed $18
	setanimation $04
	checkmemoryeq $cfd0 $02
	asm15 $6f13 $01
	applyspeed $18
	asm15 $6f13 $02
	applyspeed $20
	scriptend
script7570:
	wait 120
	applyspeed $10
	wait 20
	setspeed SPEED_100
	applyspeed $28
	wait 60
	showtext $3128
	giveitem $4900
	wait 30
	showtext $3129
	writememory $cfd0 $02
	asm15 $6f13 $02
	applyspeed $30
	asm15 $6f27
	scriptend
script7591:
	setdisabledobjectsto11
	asm15 $6f32
script7595:
	jumpifobjectbyteeq $50 $00 script759d
	wait 1
	jump2byte script7595
script759d:
	showtext $1204
	ormemory $d13e $01
script75a4:
	jumpifmemoryset $d13e $10 script75ac
	jump2byte script75a4
script75ac:
	setdisabledobjectsto00
	spawnenemyhere $1700
	scriptend
script75b1:
	jumpifmemoryset $d13e $01 script75b9
	jump2byte script75b1
script75b9:
	asm15 $6f32
script75bc:
	jumpifobjectbyteeq $50 $00 script75c4
	wait 1
	jump2byte script75bc
script75c4:
	showtext $1205
	ormemory $d13e $02
script75cb:
	jumpifmemoryset $d13e $08 script75d3
	jump2byte script75cb
script75d3:
	asm15 $6f32
script75d6:
	jumpifobjectbyteeq $50 $00 script75de
	wait 1
	jump2byte script75d6
script75de:
	showtext $1207
	playsound $c8
	setmusic $2d
	ormemory $d13e $10
	spawnenemyhere $1700
	scriptend
script75ed:
	jumpifmemoryset $d13e $04 script75f5
	jump2byte script75ed
script75f5:
	asm15 $6f32
script75f8:
	jumpifobjectbyteeq $50 $00 script7600
	wait 1
	jump2byte script75f8
script7600:
	showtext $1206
	ormemory $d13e $08
script7607:
	jumpifmemoryset $d13e $10 script760f
	jump2byte script7607
script760f:
	spawnenemyhere $1700
	scriptend
script7613:
	enableinput
	wait 1
	checktext
	checkabutton
	disableinput
	jumptable_objectbyte $42
	.dw script7628
	.dw script766c
	.dw script76b4
	.dw script76c4
	.dw script76dc
	.dw script76dc
	.dw script76dc
script7628:
	jumpifobjectbyteeq $79 $00 script7649
	showtextlowindex $2b
	jumptable_memoryaddress wSelectedTextOption
	.dw script7636
	.dw script76d4
script7636:
	jumpifobjectbyteeq $78 $00 script7645
	asm15 $6f8e
	asm15 $6f75
	setglobalflag $36
	enableinput
	scriptend
script7645:
	showtextlowindex $2e
	jump2byte script7613
script7649:
	jumpifobjectbyteeq $7a $00 script765c
	showtextlowindex $2c
	jumptable_memoryaddress wSelectedTextOption
	.dw script7657
	.dw script76d4
script7657:
	asm15 $6f3d
	jump2byte script7613
script765c:
	showtextlowindex $27
	jumptable_memoryaddress wSelectedTextOption
	.dw script7665
	.dw script76d8
script7665:
	showtextlowindex $28
	asm15 $6f4d
	jump2byte script7613
script766c:
	jumpifobjectbyteeq $79 $00 script7691
	showtextlowindex $32
	jumptable_memoryaddress wSelectedTextOption
	.dw script767a
	.dw script76d4
script767a:
	jumpifobjectbyteeq $78 $00 script768d
	asm15 $6f8a
	asm15 $6f71
	setglobalflag $37
	wait 1
	checktext
	showtextlowindex $3b
	enableinput
	scriptend
script768d:
	showtextlowindex $34
	jump2byte script7613
script7691:
	jumpifobjectbyteeq $7a $00 script76a4
	showtextlowindex $33
	jumptable_memoryaddress wSelectedTextOption
	.dw script769f
	.dw script76d4
script769f:
	asm15 $6f43
	jump2byte script7613
script76a4:
	showtextlowindex $30
	jumptable_memoryaddress wSelectedTextOption
	.dw script76ad
	.dw script76d8
script76ad:
	showtextlowindex $28
	asm15 $6f49
	jump2byte script7613
script76b4:
	showtextlowindex $36
	jumptable_memoryaddress wSelectedTextOption
	.dw script76bd
	.dw script76d8
script76bd:
	showtextlowindex $28
	asm15 $6f49
	jump2byte script7613
script76c4:
	showtextlowindex $35
	jumptable_memoryaddress wSelectedTextOption
	.dw script76cd
	.dw script76d8
script76cd:
	showtextlowindex $28
	asm15 $6f4d
	jump2byte script7613
script76d4:
	showtextlowindex $2d
	jump2byte script7613
script76d8:
	showtextlowindex $29
	jump2byte script7613
script76dc:
	showtextlowindex $39
	jumptable_memoryaddress wSelectedTextOption
	.dw script76e5
	.dw script76d4
script76e5:
	jumpifobjectbyteeq $7d $00 script76ee
	showtextlowindex $3a
	jump2byte script7613
script76ee:
	jumpifobjectbyteeq $78 $00 script76fb
	asm15 $6f8a
	asm15 $6f64
	enableinput
	scriptend
script76fb:
	showtextlowindex $34
	jump2byte script7613
script76ff:
	loadscript scriptHlp.script15_6ff7
script7703:
	loadscript scriptHlp.script15_7139
script7707:
	loadscript scriptHlp.script15_71bd
script770b:
	loadscript scriptHlp.script15_71ef
script770f:
	jumpifmemoryeq $cfd0 $03 script771d
	checkmemoryeq $cfd0 $01
	checkpalettefadedone
	setanimation $01
	scriptend
script771d:
	checkpalettefadedone
	wait 40
	setanimation $04
	showtextlowindex $53
	wait 30
	writememory $cfd0 $04
	checkmemoryeq $cfd0 $05
	setanimation $00
	checkmemoryeq $cfd0 $06
	setanimation $03
	checkmemoryeq $cfd0 $07
	setanimation $02
	checkmemoryeq $cfd0 $0b
	wait 80
	asm15 scriptHlp.forceLinkDirection $00
	wait 40
	jumpifmemoryeq $cc01 $00 script774f
	showtextlowindex $57
	jump2byte script7751
script774f:
	showtextlowindex $54
script7751:
	wait 80
	setanimation $00
	wait 40
	setcollisionradii $08 $08
	makeabuttonsensitive
script775a:
	showtextlowindex $55
	wait 20
	setanimation $04
	wait 20
	showtextlowindex $56
	writememory $c6e6 $56
	wait 20
	setanimation $00
	writememory $cfd0 $63
	enableinput
	checkabutton
	disableinput
	jump2byte script775a
script7772:
	checkmemoryeq $cfc0 $06
	wait 20
	setanimation $02
	scriptend
script777a:
	checkmemoryeq $cfc0 $01
	setanimation $03
	checkmemoryeq $cfc0 $02
	showtextlowindex $52
	wait 60
	writememory $cfc0 $03
	checkmemoryeq $cfc0 $08
	wait 150
	setanimation $02
	scriptend
script7794:
	loadscript scriptHlp.script15_7287
script7798:
	loadscript scriptHlp.script15_72a4
script779c:
	jumpifmemoryeq $cc01 $01 script77a4
	rungenericnpclowindex $5c
script77a4:
	rungenericnpclowindex $60
script77a6:
	loadscript scriptHlp.script15_72d0
script77aa:
	jumpifglobalflagset $12 script77d1
	spawninteraction $6b04 $40 $50
	setanimation $02
	setcollisionradii $08 $08
	checkmemoryeq $cfc0 $09
	wait 2
script77be:
	jumptable_memoryaddress $cdd1
	.dw script77ce
	.dw script77c7
	.dw script77be
script77c7:
	setanimation $01
	wait 90
	setanimation $00
	wait 60
	checknoenemies
script77ce:
	setanimation $01
	wait 90
script77d1:
	setanimation $00
	setcollisionradii $08 $08
	makeabuttonsensitive
script77d7:
	checkabutton
	showtextlowindex $d5
	jump2byte script77d7
script77dc:
	disableinput
	writememory $cbae $04
	setmusic $1e
	wait 40
	writememory $cbe7 $77
	asm15 hideStatusBar
	asm15 $7318 $02
	checkpalettefadedone
	jumpifobjectbyteeq $42 $01 script77fe
	spawninteraction $6200 $00 $00
	wait 240
	wait 180
	jump2byte script7805
script77fe:
	spawninteraction $6201 $00 $00
	wait 240
	wait 60
script7805:
	asm15 $7082 $00
	wait 1
	asm15 showStatusBar
	asm15 clearFadingPalettes
	asm15 $7333
	asm15 fadeinFromWhiteWithDelay $02
	checkpalettefadedone
	resetmusic
	orroomflag $40
	asm15 incMakuTreeState
	jumpifobjectbyteeq $43 $07 script7826
	enableinput
	scriptend
script7826:
	spawninteraction $6603 $58 $a8
	scriptend
script782c:
	loadscript scriptHlp.script15_7355
script7830:
	loadscript scriptHlp.script15_7397
script7834:
	loadscript scriptHlp.script15_73ac
script7838:
	loadscript scriptHlp.script15_73c9
script783c:
	checkcfc0bit 0
	setmusic $f0
	wait 60
	asm15 $73d5
	wait 30
	asm15 $73d9
	wait 30
	asm15 $73dd
	wait 30
	settilehere $ee
script784e:
	wait 45
	resetmusic
	playsound $4d
	enableinput
	scriptend
script7856:
	checkcfc0bit 0
	setmusic $f0
	wait 60
	playsound $70
	settilehere $af
	jump2byte script784e
script7860:
	checkcfc0bit 0
	setmusic $f0
	wait 60
	playsound $70
	settileat $22 $ee
	settileat $23 $ef
	jump2byte script784e
script786e:
	loadscript scriptHlp.script15_742b
script7872:
	loadscript scriptHlp.script15_746b
script7876:
	loadscript scriptHlp.script15_747b
script787a:
	loadscript scriptHlp.script15_7490
script787e:
	loadscript scriptHlp.script15_7501
script7882:
	loadscript scriptHlp.script15_7541
script7886:
	initcollisions
script7887:
	checkabutton
	showtext $5811
	jump2byte script7887
script788d:
	moveup $14
	wait 8
	moveright $32
	wait 1
	setanimation $03
	wait 30
	scriptend
script7897:
	loadscript scriptHlp.script15_7567
script789b:
	wait 8
	setanimation $06
script789e:
	checkabutton
	showtext $580b
	jump2byte script789e
script78a4:
	wait 30
	asm15 fadeoutToWhiteWithDelay $02
	wait 1
	setanimation $02
	asm15 $74d4
	wait 3
	asm15 fadeinFromWhiteWithDelay $02
	wait 30
	asm15 $74b0
	showtext $580d
	setanimation $04
	writememory $cfd3 $01
	wait 60
	asm15 $74f1
	wait 4
	showtext $580e
	callscript script78d5
	wait 60
	showtext $580f
	asm15 $74b7
	scriptend
script78d5:
	jumptable_memoryaddress $cfd0
	.dw script78dc
	.dw script78e0
script78dc:
	giveitem $4c01
	retscript
script78e0:
	jumptable_memoryaddress $cfd1
	.dw script78ef
	.dw script78e7
script78e7:
	giveitem $0501
	giveitem $0504
	jump2byte script78f5
script78ef:
	giveitem $0502
	giveitem $0505
script78f5:
	asm15 loseTreasure $41
	retscript
script78fa:
	asm15 $74d4
	asm15 $74f1
	asm15 fadeinFromWhiteWithDelay $04
	wait 120
	asm15 $74b0
	showtext $580c
	asm15 $74b7
	setanimation $02
	scriptend
script7911:
	initcollisions
script7912:
	checkabutton
	showtext $580f
	jump2byte script7912
script7918:
	setanimation $03
	checkmemoryeq $cfc0 $01
	writeobjectbyte $7f $01
	callscript _jumpAndWaitUntilLanded
	writeobjectbyte $7f $00
	writememory $cfc0 $02
	checkmemoryeq $cfc0 $05
script792f:
	writeobjectbyte $7f $01
	callscript _jumpAndWaitUntilLanded
	writeobjectbyte $7f $00
	jumpifmemoryeq $cfc0 $06 script7941
	wait 30
	jump2byte script792f
script7941:
	asm15 scriptHlp.turnToFaceLink
	asm15 $51a6 $01
	checkmemoryeq $ccd4 $02
	asm15 $51ab $01
	checkmemoryeq $cfc0 $09
	asm15 $7592
	wait 1
	scriptend
script7959:
	setanimation $01
	checkmemoryeq $cfc0 $03
	writeobjectbyte $7f $01
	callscript _jumpAndWaitUntilLanded
	writeobjectbyte $7f $00
	writememory $cfc0 $04
	checkmemoryeq $cfc0 $05
	wait 30
	jump2byte script792f
script7973:
	loadscript scriptHlp.script15_75b3
script7977:
	makeabuttonsensitive
script7978:
	setanimation $02
	checkabutton
	jumpifobjectbyteeq $7f $00 script7982
	jump2byte script7abe
script7982:
	jumpifmemoryeq $cfd0 $01 script79b6
	showtextlowindex $0c
	jump2byte script7978
script798c:
	makeabuttonsensitive
script798d:
	setanimation $02
	checkabutton
	jumpifobjectbyteeq $7f $00 script7997
	jump2byte script7abe
script7997:
	jumpifmemoryeq $cfd0 $01 script79b6
	showtextlowindex $0d
	jump2byte script798d
script79a1:
	makeabuttonsensitive
script79a2:
	setanimation $02
	checkabutton
	jumpifobjectbyteeq $7f $00 script79ac
	jump2byte script7abe
script79ac:
	jumpifmemoryeq $cfd0 $01 script79b6
	showtextlowindex $0e
	jump2byte script79a2
script79b6:
	disableinput
	showtextlowindex $0f
	setanimation $03
	writeobjectbyte $44 $02
	scriptend
script79bf:
	disableinput
	callscript script7aa6
	showtextlowindex $0a
	writememory $cfd0 $02
	checkmemoryeq $cfd0 $03
	setanimation $04
	checkmemoryeq $cfd0 $07
	setanimation $05
	checkmemoryeq $cfd0 $08
	callscript script7aa6
	showtextlowindex $0b
	writememory $cfd0 $09
	checkmemoryeq $cfd0 $0a
	setanimation $04
	wait 10
	writememory $cfd0 $0b
	setspeed SPEED_100
	writeobjectbyte $49 $10
	applyspeed $30
	scriptend
script79f5:
	checkmemoryeq $cfd0 $02
	callscript script7aa6
	showtextlowindex $11
	writememory $cfd0 $03
	setspeed SPEED_100
	movedown $10
	moveleft $30
	wait 90
	asm15 $759b $52
	moveleft $10
	wait 90
	asm15 $759b $51
	moveleft $10
	wait 90
	asm15 $759b $50
	moveright $50
	moveup $10
	writememory $cfd0 $07
	setanimation $03
	callscript script7aa6
	wait 10
	showtextlowindex $12
	writememory $cfd0 $08
	checkmemoryeq $cfd0 $09
	showtextlowindex $11
	writememory $cfd0 $0a
	wait 90
	movedown $30
	scriptend
script7a3d:
	callscript script7a74
	setspeed SPEED_100
	movedown $10
	moveleft $20
	callscript script7a82
	moveright $40
	moveup $10
	setanimation $02
	callscript script7a93
	wait 180
	movedown $40
	scriptend
script7a56:
	callscript script7a74
	setspeed SPEED_100
	movedown $28
	moveleft $10
	callscript script7a82
	moveright $30
	moveup $28
	setanimation $02
	callscript script7a93
	wait 180
	wait 90
	movedown $50
	setdisabledobjectsto00
	setglobalflag $25
	enablemenu
	scriptend
script7a74:
	checkmemoryeq $cfd0 $02
	setzspeed -$0200
	wait 20
	retscript
script7a7d:
	checkmemoryeq $cfd0 $03
	retscript
script7a82:
	checkmemoryeq $cfd0 $04
	moveleft $10
	checkmemoryeq $cfd0 $05
	moveleft $10
	checkmemoryeq $cfd0 $06
	retscript
script7a93:
	setzspeed -$0200
	wait 20
	retscript
script7a98:
	checkmemoryeq $cfd0 $09
	setzspeed -$0200
	wait 20
	retscript
script7aa1:
	checkmemoryeq $cfd0 $0a
	retscript
script7aa6:
	setzspeed -$0200
	playsound $53
	wait 20
	retscript
script7aad:
	initcollisions
script7aae:
	setanimation $00
	checkabutton
	turntofacelink
	jumpifglobalflagset $30 script7aba
	showtextlowindex $13
	jump2byte script7aae
script7aba:
	showtextlowindex $14
	jump2byte script7aae
script7abe:
	turntofacelink
	showtextlowindex $10
	setanimation $02
	checkabutton
	jump2byte script7abe
script7ac6:
	loadscript scriptHlp.script15_75e7
script7aca:
	checkabutton
	showtextnonexitable $3408
	jumpiftextoptioneq $00 script7adf
	orroomflag $40
script7ad4:
	showtext $340a
script7ad7:
	checkabutton
	showtextnonexitable $3409
	jumpiftextoptioneq $01 script7ad4
script7adf:
	disableinput
	showtext $340b
	giveitem $4600
	wait 60
	showtext $340c
	enableinput
script7aeb:
	checkabutton
	showtext $340c
	jump2byte script7aeb
script7af1:
	checkabutton
	showtext $340d
	asm15 setGlobalFlag $31
script7af9:
	checkabutton
	showtext $340e
	jump2byte script7af9
script7aff:
	checkabutton
	showtext $340f
	jump2byte script7aff
script7b05:
	checkabutton
	disableinput
	jumpifglobalflagset $6e script7b3d
	showtext $3435
	wait 30
	jumpiftextoptioneq $00 script7b18
	showtext $3436
	jump2byte script7b42
script7b18:
	askforsecret $00
	wait 30
	jumpifmemoryeq $cc89 $00 script7b26
	showtext $3438
	jump2byte script7b42
script7b26:
	setglobalflag $64
	showtext $3437
	wait 30
	callscript scriptFunc_doEnergySwirlCutscene
	wait 30
	callscript script7b45
	wait 30
	generatesecret $00
	setglobalflag $6e
	showtext $3439
	jump2byte script7b42
script7b3d:
	generatesecret $00
	showtext $343a
script7b42:
	enableinput
	jump2byte script7b05
script7b45:
	jumptable_objectbyte $43
	.dw script7b52
	.dw script7b4b
script7b4b:
	giveitem $0501
	giveitem $0504
	retscript
script7b52:
	giveitem $0502
	giveitem $0505
	retscript
script7b59:
	checkabutton
	showtext $3400
	jump2byte script7b59
script7b5f:
	checkabutton
	showtext $3401
	jumpiftextoptioneq $01 script7b5f
	disableinput
	wait 8
	spawninteraction $9c02 $34 $78
	asm15 loseTreasure $2f
	asm15 playSound $00
	wait 30
	showtext $3402
	wait 8
	asm15 playSound $00
	showtext $3403
	wait 60
	showtext $3404
	asm15 setGlobalFlag $27
	enableinput
script7b8b:
	checkabutton
	showtext $3405
	jump2byte script7b8b
script7b91:
	checkabutton
	showtext $3406
	jump2byte script7b91
script7b97:
	checkabutton
	showtext $3407
	jump2byte script7b97
script7b9d:
	initcollisions
	setcollisionradii $14 $06
	jumpifroomflagset $40 script7bae
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $00
	disableinput
	xorcfc0bit 0
	enableinput
	rungenericnpclowindex $01
script7bae:
	rungenericnpclowindex $04
script7bb0:
	disableinput
	loadscript scriptHlp.script15_766e
script7bb5:
	moveright $20
	wait 15
	moveleft $20
	wait 15
	asm15 $7654
	moveright $20
	wait 15
	asm15 $7654
	moveleft $20
	wait 15
	retscript
script7bc8:
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
script7bdd:
	setanimation $05
	setcollisionradii $08 $04
	makeabuttonsensitive
	checkabutton
	setdisabledobjectsto11
	setanimation $06
	wait 220
	showtext $3d05
	wait 60
	writememory wCutsceneTrigger $0f
	scriptend
script7bf2:
	wait 60
	setanimation $03
	wait 30
	setanimation $01
	wait 30
	asm15 $76de
	setanimation $02
	wait 20
	asm15 $76e6
	wait 8
	movedown $11
	moveright $17
script7c07:
	wait 30
	xorcfc0bit 7
	scriptend
script7c0a:
	wait 60
	setanimation $01
	wait 30
	setanimation $03
	wait 30
	asm15 $76de
	setanimation $02
	wait 20
	asm15 $76e6
	wait 8
	moveup $11
	moveleft $17
	jump2byte script7c07
script7c21:
	initcollisions
script7c22:
	checkabutton
	turntofacelink
	showloadedtext
	setanimation $00
	jump2byte script7c22
script7c29:
	asm15 $7700
	jumptable_memoryaddress $cfc1
	.dw script7c29
	.dw script7c33
script7c33:
	disableinput
	asm15 $76ec
	wait 30
	setspeed SPEED_100
	setangle $18
	asm15 $76f4
	wait 1
	moveup $20
	wait 30
	showtext $3430
	wait 30
	giveitem $4e00
	movedown $80
	enableinput
	scriptend
script7c4e:
	initcollisions
	jumpifitemobtained $4e script7c56
	rungenericnpc $3431
script7c56:
	checkabutton
	disableinput
	showtext $3431
	wait 30
	asm15 $771a
	wait 60
	showtext $3432
	wait 30
	setstate $ff
	setspeed SPEED_200
	asm15 $770e
	jumptable_memoryaddress $cfc1
	.dw script7c72
	.dw script7c7b
script7c72:
	moveleft $18
	asm15 $7727
	moveup $30
	jump2byte script7c82
script7c7b:
	movedown $10
	asm15 $772b
	moveright $40
script7c82:
	orroomflag $40
	enableinput
	scriptend
script7c86:
	setanimation $05
	setcollisionradii $08 $04
	makeabuttonsensitive
	checkabutton
	setdisabledobjectsto11
	setanimation $06
	wait 220
	showtext $3d05
	wait 60
	writememory wCutsceneTrigger $0f
	scriptend
script7c9b:
	loadscript scriptHlp.script15_775b
script7c9f:
	loadscript scriptHlp.script15_7781
script7ca3:
	loadscript scriptHlp.script15_7793
script7ca7:
	checkmemoryeq $cfd0 $01
	setanimation $03
	applyspeed $11
	checkmemoryeq $cfd0 $02
	setanimation $03
	checkmemoryeq $cfd0 $03
	setanimation $02
	checkmemoryeq $cfd0 $05
	setanimation $03
	checkmemoryeq $cfd0 $07
	writememory $d008 $01
	showtext $0607
	wait 30
	writememory $cfd0 $08
	wait 45
	writememory $d008 $01
	moveup $11
	writememory $d008 $00
	moveleft $11
	moveup $41
	scriptend
script7ce2:
	loadscript scriptHlp.script15_77b3
script7ce6:
	checkmemoryeq $cfd0 $01
	setspeed SPEED_100
	moveup $24
	moveleft $08
	setanimation $00
	writememory $cfd0 $02
	checkmemoryeq $cfd0 $03
	setanimation $01
	writememory $cfd0 $04
	checkmemoryeq $cfd0 $06
	setanimation $00
	checkmemoryeq $cfd0 $08
	moveup $38
	wait 30
	movedown $08
	wait 30
	showtext $0608
	moveup $48
	enableinput
	scriptend
script7d17:
	checkcfc0bit 0
	asm15 scriptHlp.createExclamationMark $1e
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
	asm15 scriptHlp.createExclamationMark $1e
	scriptend
script7d34:
	loadscript scriptHlp.script15_77de
script7d38:
	checkabutton
	jumpifitemobtained $55 script7d41
	showtextlowindex $11
	jump2byte script7d38
script7d41:
	showtextlowindex $12
	jumpiftextoptioneq $01 script7d38
	orroomflag $40
	scriptend
script7d4a:
	showtext $2f27
	wait 4
	applyspeed $19
	wait 16
	orroomflag $40
	resetmusic
	scriptend
script7d57:
	setangle $10
	applyspeed $21
	wait 8
	showtext $2f28
	wait 8
	asm15 $77e6
	setangle $00
	applyspeed $21
	orroomflag $40
	scriptend
script7d6a:
	settileat $34 $01
	asm15 playSound $70
	wait 30
	showtext $2f29
	wait 4
	applyspeed $11
	orroomflag $40
	scriptend
script7d7b:
	setspeed SPEED_080
	wait 180
script7d7e:
	setangle $18
	applyspeed $18
	wait 6
	setangle $08
	applyspeed $14
	wait 120
	jump2byte script7d7e
script7d8b:
	rungenericnpc $5711
script7d8e:
	jump2byte script7d8b
script7d90:
	wait 240
	setanimation $01
	wait 30
	showtext $5601
	wait 30
	setanimation $00
	wait 60
	writememory $cfd1 $02
	wait 180
	scriptend
script7da1:
	rungenericnpclowindex $0c
script7da3:
	rungenericnpclowindex $19
script7da5:
	rungenericnpclowindex $23
script7da7:
	loadscript scriptHlp.script15_78df
script7dab:
	loadscript scriptHlp.script15_7849
script7daf:
	rungenericnpclowindex $18
script7db1:
	jumpifglobalflagset $29 script7dbd
	rungenericnpclowindex $20
script7db7:
	jumpifglobalflagset $29 script7dbd
	rungenericnpclowindex $21
script7dbd:
	rungenericnpclowindex $22
script7dbf:
	rungenericnpclowindex $2c
script7dc1:
	loadscript scriptHlp.script15_7948
script7dc5:
	rungenericnpc $3608
script7dc8:
	rungenericnpc $3609
script7dcb:
	rungenericnpc $360a
script7dce:
	rungenericnpc $360b
script7dd1:
	initcollisions
	jumpifitemobtained $4f script7dd9
	rungenericnpc $360d
script7dd9:
	checkabutton
	disableinput
	playsound $f0
script7ddd:
	orroomflag $80
	spawninteraction $8006 $52 $6a
	playsound $6c
	wait 60
	playsound $b0
	shakescreen 160
	wait 120
	setcoords $58 $58
	asm15 $7972
	wait 60
	playsound $4d
	resetmusic
	asm15 loseTreasure $4f
	enableinput
	scriptend
script7dfd:
	enableinput
script7dfe:
	checkabutton
	jumpifitemobtained $54 script7e35
	jumpifglobalflagset $1b script7e0d
	setglobalflag $1b
	showtextnonexitablelowindex $00
	jump2byte script7e0f
script7e0d:
	showtextnonexitablelowindex $01
script7e0f:
	setdisabledobjectsto11
	jumptable_memoryaddress wSelectedTextOption
	.dw script7e1b
	.dw script7e17
script7e17:
	showtextlowindex $03
	jump2byte script7e49
script7e1b:
	disableinput
	showtextlowindex $02
	checktext
	giveitem $5400
	wait 1
	checktext
	showtextlowindex $04
	callscript script7ebc
	wait 60
	writememory $d103 $02
	setdisabledobjectsto11
	writememory $d104 $0a
	jump2byte script7dfe
script7e35:
	disableinput
	jumpifobjectbyteeq $7e $00 script7e47
	jumptable_objectbyte $7d
	.dw script7e50
	.dw script7e88
	.dw script7eae
script7e43:
	showtextlowindex $08
	jump2byte script7e49
script7e47:
	showtextlowindex $04
script7e49:
	checktext
	callscript script7ebc
	setdisabledobjectsto00
	jump2byte script7dfd
script7e50:
	jumpifglobalflagset $46 script7e43
	showtextnonexitablelowindex $06
	jumptable_memoryaddress wSelectedTextOption
	.dw script7e61
	.dw script7e5d
script7e5d:
	showtextlowindex $03
	jump2byte script7e49
script7e61:
	setglobalflag $46
	showtextlowindex $07
script7e65:
	writeobjectbyte $7f $01
	setanimation $03
	showtextlowindex $0c
	checktext
script7e6d:
	jumpifobjectbyteeq $7f $00 script7e75
	wait 1
	jump2byte script7e6d
script7e75:
	asm15 $7990
	wait 120
	giveitem $1904
	checktext
	asm15 refillSeedSatchel
	jumpifobjectbyteeq $7d $02 script7eae
	setdisabledobjectsto00
	jump2byte script7dfd
script7e88:
	jumpifglobalflagset $14 script7e8e
	jump2byte script7e50
script7e8e:
	showtextlowindex $09
	jumptable_memoryaddress wSelectedTextOption
	.dw script7e9b
	.dw script7e97
script7e97:
	showtextlowindex $0a
	jump2byte script7e49
script7e9b:
	askforsecret $07
	wait 30
	jumpifmemoryeq $cc89 $00 script7ea8
	showtextlowindex $0d
	jump2byte script7e49
script7ea8:
	showtextlowindex $0e
	setglobalflag $6b
	jump2byte script7e65
script7eae:
	jumpifglobalflagset $14 script7eb4
	jump2byte script7e43
script7eb4:
	generatesecret $07
	setglobalflag $75
	showtextlowindex $0f
	jump2byte script7e49
script7ebc:
	writeobjectbyte $7f $01
	setanimation $03
	showtextlowindex $05
	checktext
script7ec4:
	jumpifobjectbyteeq $7f $00 script7ecc
	wait 1
	jump2byte script7ec4
script7ecc:
	retscript
script7ecd:
	showtext $0d09
	scriptend
script7ed1:
	loadscript scriptHlp.script15_79b2
script7ed5:
	loadscript scriptHlp.script15_7a38


; Used by linked game NPCs that give secrets.
; The npcs set "var3f" to the "secret index" (corresponds to wShortSecretIndex) before
; running this script.
linkedGameNpcScript:
	asm15 scriptHlp.linkedNpc_checkShouldSpawn
	jumpifmemoryset $cddb, $80, stubScript

	initcollisions
	asm15 scriptHlp.linkedNpc_initHighTextIndex

@offerSecret:
	asm15 scriptHlp.linkedNpc_calcLowTextIndex, $00
	checkabutton
	disableinput
	showloadedtext
	wait 20
	jumpiftextoptioneq $00, @answeredYes

	; Answered no
	addobjectbyte Interaction.textID, $01
	showloadedtext
	enableinput
	jump2byte @offerSecret

@answeredYes:
	asm15 scriptHlp.linkedNpc_checkHasExtraTextBox
	jumpifmemoryset $cddb, $80, @generateSecret

@showExtraText: ; Only some NPCs have this extra text box
	asm15 scriptHlp.linkedNpc_calcLowTextIndex, $02
	showloadedtext
	wait 20
	jumpiftextoptioneq $01, @showExtraText

@generateSecret:
	asm15 scriptHlp.linkedNpc_generateSecret
	asm15 scriptHlp.linkedNpc_calcLowTextIndex, $03

@tellSecret:
	showloadedtext
	wait 20
	jumpiftextoptioneq $01, @tellSecret

	asm15 scriptHlp.linkedNpc_calcLowTextIndex, $04
	showloadedtext
	enableinput
	asm15 scriptHlp.linkedNpc_checkHasExtraTextBox
	jumpifmemoryset $cddb, $80, @offerSecret

	checkabutton
	disableinput
	jump2byte @answeredYes


script7f2c:
	loadscript scriptHlp.script15_7acc
script7f30:
	asm15 scriptHlp.linkedNpc_checkShouldSpawn
	jumpifmemoryset $cddb $80 stubScript
	asm15 objectSetInvisible
	writeobjectbyte $7e $01
script7f3f:
	asm15 $7b14
	jumpifmemoryset $cddb $80 script7f4b
	wait 1
	jump2byte script7f3f
script7f4b:
	playsound $73
	createpuff
	wait 32
	setmusic $0f
	asm15 objectSetVisible
	writeobjectbyte $7e $00
	jump2byte linkedGameNpcScript

script7f5a:
	rungenericnpc $5111
script7f5d:
	asm15 $7b2f
	enableinput
	scriptend
script7f62:
	checkcfc0bit 0
	setmusic $f0
	wait 60
	asm15 $7b73
	wait 45
	asm15 $7bb1
	wait 60
	resetmusic
	playsound $4d
	enableinput
	scriptend
script7f75:
	setcollisionradii $08 $08
	makeabuttonsensitive
script7f79:
	checkabutton
	setdisabledobjectsto91
	cplinkx $48
	writeobjectbyte $77 $01
	showloadedtext
	jumpiftextoptioneq $01 script7f8d
	wait 30
	addobjectbyte $72 $0a
	showloadedtext
	addobjectbyte $72 $f6
script7f8d:
	setdisabledobjectsto00
	writeobjectbyte $77 $00
	jump2byte script7f79

