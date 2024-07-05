; Scripts for interactions are in this file. You may want to cross-reference with the corresponding
; assembly code to get the full picture (run "git grep INTERAC_X" to search for its code).

stubScript:
	scriptend

genericNpcScript:
	initcollisions
--
	checkabutton
	showloadedtext
	scriptjump --


; ==================================================================================================
; INTERAC_FARORE
; ==================================================================================================

faroreScript:
	jumptable_memoryaddress wIsLinkedGame
	.dw faroreUnlinked
	.dw faroreLinked

; When talking to farore in a completed unlinked game, you can tell her secrets, but all
; she'll do is direct you to the person you're supposed to tell them to.
faroreUnlinked:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @finishedGame
	rungenericnpclowindex <TX_5501

@finishedGame:
	initcollisions
@npcLoop:
	enableinput
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_5502
	jumpiftextoptioneq $00, @askForPassword

@offerOtherGameSecret:
	showtextlowindex <TX_5519
	jumpiftextoptioneq $00, @sayOtherGameSecret
	showtextlowindex <TX_5505
	scriptjump @npcLoop

@sayOtherGameSecret:
	asm15 scriptHelp.faroreGenerateGameTransferSecret
	showtextlowindex <TX_551a
	scriptjump @npcLoop

@askForPassword:
	askforsecret $ff
	asm15 scriptHelp.faroreCheckSecretValidity
	jumptable_objectbyte Interaction.var3f
	.dw @offerOtherGameSecret
	.dw @offerOtherGameSecret
	.dw @offerOtherGameSecret
	.dw @secretOK
	.dw @wrongGame
	.dw @offerOtherGameSecret

@wrongGame: ; A Seasons secret was given in Ages.
	showtextlowindex <TX_550b
	scriptjump @offerOtherGameSecret

@secretOK: ; The secret is fine, but you're supposed to tell it to someone else.
	asm15 scriptHelp.faroreShowTextForSecretHint
	wait 30
	showtextlowindex <TX_5504
	scriptjump @offerOtherGameSecret


; When talking to Farore in a linked game, you can tell her secrets and she'll respond by
; giving you an item if it's correct.
faroreLinked:
	initcollisions
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_5506
	scriptjump ++
@npcLoop:
	enableinput
	checkabutton
	disableinput
	jumpifglobalflagset GLOBALFLAG_SECRET_CHEST_WAITING, @waitForLinkToOpenChest
++
	showtextlowindex <TX_5507 ; Do you know a secret?
	jumpiftextoptioneq $00, @showPasswordScreen
	showtextlowindex <TX_5508 ; Come back anytime
	scriptjump @npcLoop

@showPasswordScreen:
	askforsecret $ff
	asm15 scriptHelp.faroreCheckSecretValidity
	jumptable_objectbyte Interaction.var3f
	.dw @script4667
	.dw @secretOK
	.dw @alreadyToldSecret
	.dw @script4667
	.dw @wrongGame
	.dw @secretNotActive

@script4667:
	showtextlowindex <TX_5505
	scriptjump @npcLoop

@secretOK:
	asm15 scriptHelp.faroreSpawnSecretChest
	checkcfc0bit 1
	xorcfc0bit 1
	enableinput
	scriptjump @npcLoop

@alreadyToldSecret: ; The secret has already been told to farore
	showtextlowindex <TX_550c
	scriptjump @npcLoop

@wrongGame: ; A secret for Seasons was told in Ages, or vice versa
	showtextlowindex <TX_550b
	scriptjump @npcLoop

@secretNotActive: ; Need to talk to the corresponding npc before you can tell the secret
	showtextlowindex <TX_551c
	scriptjump @npcLoop

@waitForLinkToOpenChest: ; A chest exists already, waiting for Link to open it
	showtextlowindex <TX_550a
	scriptjump @npcLoop


; ==================================================================================================
; INTERAC_DUNGEON_STUFF
; ==================================================================================================

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
	incstate
	scriptend

setRoomFlagBit7WhenNoEnemiesScript:
	stopifroomflag80set
	checknoenemies
	orroomflag $80
	scriptend


; ==================================================================================================
; INTERAC_FARORES_MEMORY
; ==================================================================================================
faroresMemoryScript:
	initcollisions
--
	enableinput
	checkabutton
	setdisabledobjectsto91
	showtext TX_551b
	jumpiftextoptioneq $00, @openSecretList
	wait 8
	scriptjump --

@openSecretList:
	asm15 openMenu, $0a
	wait 8
	scriptjump --


; ==================================================
; INTERAC_DOOR_CONTROLLER.
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
;   angle: the type and direction of door (see interactions.s)
;   speed: for subids $14-$17, this is the number of torches that must be lit.
;   var3d: Bitmask to check on wActiveTriggers (value of "X" parameter converted to
;          a bitmask)
;   var3e: Short-form position of the tile the door is on (value of "Y" parameter)
;   var3f: Value of "X" parameter (a number from 0-7 corresponding to a switch; see
;          var3d)


doorController_updateRespawnWhenLinkNotTouching:
	checknotcollidedwithlink_ignorez
	asm15 scriptHelp.doorController_updateLinkRespawn
	retscript


; Subid $00: door just opens.
doorOpenerScript:
	incstate
	scriptend


; Subids $04-$07:
;   Door is controlled by a bit in "wActiveTriggers" (uses the bitmask in var3d).

; Subid $04
doorController_controlledByTriggers_up:
	setcollisionradii $0a, $08
	setangle $10
	scriptjump doorController_controlledByTriggers

; Subid $05
doorController_controlledByTriggers_right:
	setcollisionradii $08, $0a
	setangle $12
	scriptjump doorController_controlledByTriggers

; Subid $06
doorController_controlledByTriggers_down:
	setcollisionradii $0a, $08
	setangle $14
	scriptjump doorController_controlledByTriggers

; Subid $07
doorController_controlledByTriggers_left:
	setcollisionradii $08, $0a
	setangle $16

doorController_controlledByTriggers:
	callscript doorController_updateRespawnWhenLinkNotTouching
@loop:
	asm15 scriptHelp.doorController_decideActionBasedOnTriggers
	jumptable_memoryaddress wTmpcfc0.normal.doorControllerState
	.dw @loop
	.dw @open
	.dw @close
@open:
	playsound SND_SOLVEPUZZLE
	setstate $02
	scriptjump @loop
@close:
	setstate $03
	scriptjump @loop


; Subids $08-$0b:
;   Door shuts itself until [wNumEnemies] == 0.

doorController_shutUntilEnemiesDead:
	callscript doorController_updateRespawnWhenLinkNotTouching
	jumpifnoenemies @end
	setstate $03
	checknoenemies
	playsound SND_SOLVEPUZZLE
	wait 8
	incstate
@end:
	scriptend

doorController_open:
	setstate $02
	scriptend

; Subid $08
doorController_shutUntilEnemiesDead_up:
	setcollisionradii $0a, $08
	setangle $10
	jumpifnoenemies doorController_open
	scriptjump doorController_shutUntilEnemiesDead

; Subid $09
doorController_shutUntilEnemiesDead_right:
	setcollisionradii $08, $0a
	setangle $12
	jumpifnoenemies doorController_open
	scriptjump doorController_shutUntilEnemiesDead

; Subid $0a
doorController_shutUntilEnemiesDead_down:
	setcollisionradii $0a, $08
	setangle $14
	jumpifnoenemies doorController_open
	scriptjump doorController_shutUntilEnemiesDead

; Subid $0b
doorController_shutUntilEnemiesDead_left:
	setcollisionradii $08, $0a
	setangle $16
	jumpifnoenemies doorController_open
	scriptjump doorController_shutUntilEnemiesDead

doorController_openOnMinecartCollision:
	asm15 scriptHelp.doorController_checkMinecartCollidedWithDoor
	jumptable_memoryaddress wTmpcfc0.normal.doorControllerState
	.dw doorController_openOnMinecartCollision
	.dw @incState

@incState:
	incstate

doorController_closeDoorWhenLinkNotTouching:
	callscript doorController_updateRespawnWhenLinkNotTouching
	setstate $03
	scriptend

doorController_minecart:
	asm15 scriptHelp.doorController_checkTileIsMinecartTrack
	jumptable_memoryaddress wTmpcfc0.normal.doorControllerState
	.dw doorController_openOnMinecartCollision ; Not minecart track (door is closed)
	.dw doorController_closeDoorWhenLinkNotTouching ; Minecart track (door is open)


; Subids $0c-$0f:
;   Minecart door; opens when a minecart collides with it

; Subid $0c
doorController_minecartDoor_up:
	setcollisionradii $10, $08
	setangle $18
	scriptjump doorController_minecart

; Subid $0d
doorController_minecartDoor_right:
	setcollisionradii $08, $0e
	setangle $1a
	scriptjump doorController_minecart

; Subid $0e
doorController_minecartDoor_down:
	setcollisionradii $0f, $08
	setangle $1c
	scriptjump doorController_minecart

; Subid $0f
doorController_minecartDoor_left:
	setcollisionradii $08, $0f
	setangle $1e
	scriptjump doorController_minecart


; Subids $10-$13:
;   Door which automatically closes when Link walks out of that tile.
;   When Link transitions onto a shutter door tile, the game automatically removes that
;   tile and replaces it with an interaction of this type.

doorController_closeDoorWhenLinkNotTouchingAndFlipcfc0:
	callscript doorController_updateRespawnWhenLinkNotTouching
	setstate $03
	xorcfc0bit 0
	scriptend

; Subid $10
doorController_closeAfterLinkEnters_up:
	setcollisionradii $0c, $08
	setangle $10
	scriptjump doorController_closeDoorWhenLinkNotTouchingAndFlipcfc0

; Subid $11
doorController_closeAfterLinkEnters_right:
	setcollisionradii $08, $0c
	setangle $12
	scriptjump doorController_closeDoorWhenLinkNotTouchingAndFlipcfc0

; Subid $12
doorController_closeAfterLinkEnters_down:
	setcollisionradii $0c, $08
	setangle $14
	scriptjump doorController_closeDoorWhenLinkNotTouchingAndFlipcfc0

; Subid $13
doorController_closeAfterLinkEnters_left:
	setcollisionradii $08, $0c
	setangle $16
	scriptjump doorController_closeDoorWhenLinkNotTouchingAndFlipcfc0


; Subids $14-$17:
;   Door opens when a number of torches are lit.

doorController_shutUntilTorchesLit:
	callscript doorController_updateRespawnWhenLinkNotTouching
	setstate $03
@loop:
	asm15 scriptHelp.doorController_checkEnoughTorchesLit
	jumptable_memoryaddress wTmpcec0
	.dw @loop
	.dw @torchesLit

@torchesLit:
	wait 30
	playsound SND_SOLVEPUZZLE
	incstate
	scriptend

; Subid $14
doorController_openWhenTorchesLit_up_2Torches:
	setcollisionradii $0a, $08
	setangle $10
	setspeed $02
	scriptjump doorController_shutUntilTorchesLit

; Subid $15
doorController_openWhenTorchesLit_left_2Torches:
	setcollisionradii $08, $0a
	setangle $16
	setspeed $02
	scriptjump doorController_shutUntilTorchesLit

.ifdef ROM_AGES
; Subid $16
doorController_openWhenTorchesLit_down_1Torch:
	setcollisionradii $0a, $08
	setangle $14
	setspeed $01
	scriptjump doorController_shutUntilTorchesLit

; Subid $17
doorController_openWhenTorchesLit_left_1Torch:
	setcollisionradii $08, $0a
	setangle $16
	setspeed $01
	scriptjump doorController_shutUntilTorchesLit
.endif


; ==================================================================================================
; INTERAC_SHOPKEEPER
; ==================================================================================================

.ifdef ROM_SEASONS
shopkeeperScript_blockLinkAccess:
	setspeed SPEED_200
	setdisabledobjectsto11
	playsound SND_CLINK
	movedown $10
	setangleandanimation $08
	jumptable_objectbyte Interaction.var3e
	.dw @noMembersCard
	.dw @membersCard

@membersCard:
	showtextlowindex <TX_0e0c
	writeobjectbyte $7d, $01
	scriptjump +

@noMembersCard:
	showtextlowindex <TX_0e01
+
	moveup $10
	setangleandanimation $08
	enableallobjects
	scriptend
.endif

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
	.dw @buyUpgradeableItem
	.dw @buy3Hearts
	.dw @buyHiddenShopGashaSeed1
	.dw @buyL1Shield
	.dw @buy10Bombs
	.dw @buyHiddenShopOtherItem
	.dw @buyHiddenShopGashaSeed2
	.dw @buyUpgradeableItem
	.dw @buyUpgradeableItem
	.dw @buyUpgradeableItem
	.dw @buyUpgradeableItem
	.dw @buyUpgradeableItem
	.dw @buyUpgradeableItem
	.dw @buyStrangeFlute
	.dw @buyAdvanceShopGashaSeed
	.dw @buyAdvanceShopGbaRing
	.dw @buyAdvanceShopRing
	.dw @buyL2Shield
	.dw @buyL3Shield
	.dw @buyNormalShopGashaSeed
.ifdef ROM_AGES
	.dw @buyUpgradeableItem
	.dw @buyHiddenShopHeartPiece
.endif

; Ring box upgrade (ages) or satchel upgrade (seasons)
@buyUpgradeableItem:
.ifdef ROM_AGES
	jumpifitemobtained TREASURE_RING_BOX, @haveUpgradeableItem

	; No ring box, can't buy
	showtextlowindex <TX_0e0b
	writeobjectbyte Interaction.var3a, $ff
	scriptend
.endif

@haveUpgradeableItem:
.ifdef ROM_AGES
	showtextnonexitablelowindex <TX_0e09
.else; ROM_SEASONS
	showtextnonexitablelowindex <TX_0e1c
.endif
	callscript shopkeeperConfirmPurchase
	ormemory wBoughtShopItems1, $01
	scriptend

@buy3Hearts:
	showtextnonexitablelowindex <TX_0e02
	callscript shopkeeperConfirmPurchase
	scriptend

@buyL1Shield:
	showtextnonexitablelowindex <TX_0e03
	callscript shopkeeperConfirmPurchase
	scriptend

@buy10Bombs:
	showtextnonexitablelowindex <TX_0e04
	callscript shopkeeperConfirmPurchase
	scriptend

@buyHiddenShopGashaSeed1:
	showtextnonexitablelowindex <TX_0e1d
	callscript shopkeeperConfirmPurchase
	ormemory wBoughtShopItems1, $02
	scriptend

; A ring (ages) or treasure map (seasons)
@buyHiddenShopOtherItem:
.ifdef ROM_AGES
	showtextnonexitablelowindex <TX_0e25
	callscript shopkeeperConfirmPurchase
	ormemory wBoughtShopItems1, $08
	scriptend
.else; ROM_SEASONS
	showtextnonexitablelowindex <TX_0e1e
	callscript shopkeeperConfirmPurchase
	ormemory wBoughtShopItems1, $08
	showtextlowindex <TX_0e27
	scriptend
.endif

@buyHiddenShopGashaSeed2:
	showtextnonexitablelowindex <TX_0e1d
	callscript shopkeeperConfirmPurchase
	ormemory wBoughtShopItems1, $04
	scriptend

@buyStrangeFlute:
	showtextnonexitablelowindex <TX_0e1b
	callscript shopkeeperConfirmPurchase
.ifdef ROM_SEASONS
	ormemory wRickyState, $20
.endif
	scriptend

@buyAdvanceShopGashaSeed:
	showtextnonexitablelowindex <TX_0e1d
	callscript shopkeeperConfirmPurchase
	ormemory wBoughtShopItems2, $01
	scriptend

@buyAdvanceShopGbaRing:
	showtextnonexitablelowindex <TX_0e23
	callscript shopkeeperConfirmPurchase
	ormemory wBoughtShopItems2, $02
	scriptend

@buyAdvanceShopRing:
	showtextnonexitablelowindex <TX_0e25
	callscript shopkeeperConfirmPurchase
	ormemory wBoughtShopItems2, $04
	scriptend

@buyL2Shield:
	showtextnonexitablelowindex <TX_0e29
	callscript shopkeeperConfirmPurchase
	scriptend

@buyL3Shield:
	showtextnonexitablelowindex <TX_0e2a
	callscript shopkeeperConfirmPurchase
	scriptend

@buyNormalShopGashaSeed:
	showtextnonexitablelowindex <TX_0e1d
	callscript shopkeeperConfirmPurchase
	ormemory wBoughtShopItems1, $20
	scriptend

.ifdef ROM_AGES
@buyHiddenShopHeartPiece:
	showtextnonexitablelowindex <TX_0e01
	callscript shopkeeperConfirmPurchase
	ormemory wBoughtShopItems2, $40
	scriptend
.endif

shopkeeperConfirmPurchase:
	jumpiftextoptioneq $00, @answeredYes

	; Answered no
	writememory wcbad, $03
	writememory wTextIsActive, $01
	writeobjectbyte Interaction.var3a, $ff
	scriptend

@answeredYes:
	jumpifmemoryeq wShopHaveEnoughRupees, $00, shopkeeperAttemptToPurchaseItem
	showtextlowindex <TX_0e06


shopkeeperCancelPurchase:
	writeobjectbyte Interaction.var3a, $ff
	enableallobjects
	scriptend


shopkeeperNotEnoughRupeesToReplayChestGame:
	callscript shopkeeperReturnToDeskAfterChestGame

shopkeeperNotEnoughRupees:
	showtextlowindex <TX_0e06
	scriptjump shopkeeperCancelPurchase


shopkeeperAttemptToPurchaseItem:
	jumptable_objectbyte Interaction.var38
	.dw @canBuy
	.dw shopkeeperCantBuy

@canBuy:
	writememory wTextIsActive, $01
	writeobjectbyte Interaction.var3a, $01
	disablemenu
	retscript


; Can't buy an item because Link already has it
shopkeeperCantBuy:
	writememory wcbad, $02
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
	enableallobjects
	scriptend

; Shopkeeper prevents Link from stealing something (hidden shop)
shopkeeperSubid1Script_stopLink:
	setspeed SPEED_200
	moveup $10
	showtextlowindex <TX_0e07
	setdisabledobjectsto11
	movedown $10
	setangleandanimation $08
	enableallobjects
	scriptend

.ifdef ROM_AGES
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
	enableallobjects
	scriptend
.endif


; Prompt to play the chest-choosing minigame
shopkeeperChestGameScript:
	jumpifc6xxset <wBoughtShopItems1, $80, @notFirstTime

	showtextlowindex <TX_0e0d
	ormemory wBoughtShopItems1, $80
	scriptjump ++

@notFirstTime:
	showtextlowindex <TX_0e0e
++
	setdisabledobjectsto11
	jumpiftextoptioneq $00, @answeredYes

	; Answered no
	showtextlowindex <TX_0e11
	enableallobjects
	scriptend

@answeredYes:
	jumpifmemoryeq wShootingGalleryccd5, $01, shopkeeperNotEnoughRupees
	asm15 scriptHelp.shopkeeper_take10Rupees
	setspeed SPEED_200
	setcollisionradii $06, $06
	moveup    $08
	moveright $19
	moveup    $1a
	moveright $11
	movedown  $08
	scriptjump ++

@playAgain:
	asm15 scriptHelp.shopkeeper_take10Rupees
++
	setangleandanimation $08
	writeobjectbyte Interaction.substate, $02 ; Signal to close whichever chest he faces
	writeobjectbyte Interaction.state,  $05
	wait 60

	setangleandanimation $18
	wait 60

	setangleandanimation $10
	writeobjectbyte Interaction.var3c, $00 ; Initialize to round 0
	showtextlowindex <TX_0e10

	enableallobjects
	ormemory wInShop, $80
	writeobjectbyte Interaction.substate, $00
	writeobjectbyte Interaction.state,  $05
	; Script will stop here since state has been changed.


; Opened the incorrect chest in the chest minigame.
shopkeeperScript_openedWrongChest:
	setdisabledobjectsto11
	showtextlowindex <TX_0e17
	jumpiftextoptioneq $01, @selectedNo

	; Selected "Yes" to play again
	jumpifmemoryeq wShopHaveEnoughRupees, $01, shopkeeperNotEnoughRupeesToReplayChestGame
	scriptjump shopkeeperChestGameScript@playAgain

@selectedNo:
	callscript shopkeeperReturnToDeskAfterChestGame
	enableallobjects
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
	writeobjectbyte Interaction.substate, $02 ; Signal to close whichever chest he faces
	writeobjectbyte Interaction.state,  $05
	wait 60

	setangleandanimation $18
	wait 60

	setangleandanimation $10
	showtextlowindex <TX_0e18
	enableallobjects
	scriptend

@round3:
	showtextlowindex <TX_0e12
	jumpiftextoptioneq $00, @nextRound

	; Selected no; get round 3 prize
	showtextlowindex <TX_0e14
	writeobjectbyte Interaction.var3f, $03 ; Tier 3 ring
	callscript shopkeeperReturnToDeskAfterChestGame
	enableallobjects
	scriptend

@round4:
	showtextlowindex <TX_0e15
	jumpiftextoptioneq $00, @nextRound

	; Selected no; get round 4 prize
	showtextlowindex <TX_0e14
	writeobjectbyte Interaction.var3f, $02 ; Tier 2 ring
	callscript shopkeeperReturnToDeskAfterChestGame
	enableallobjects
	scriptend

@round5:
	; Get round 5 prize
	showtextlowindex <TX_0e16
	writeobjectbyte Interaction.var3f, $01 ; Tier 1 ring
	callscript shopkeeperReturnToDeskAfterChestGame
	enableallobjects
	scriptend


; Linked talked to the shopkeep in the middle of the chest game.
shopkeeperScript_talkDuringChestGame:
	showtextlowindex <TX_0e1a
	writeobjectbyte Interaction.substate, $01
	writeobjectbyte Interaction.state,  $05
	; Script stops here since state has been changed.


shopkeeperReturnToDeskAfterChestGame:
	moveup   $08
	moveleft $11
	movedown $1a
	moveleft $19
	movedown $08
	setangleandanimation $08
	setcollisionradii $06, $14
	retscript


; Seasons - Shop not open until Link gets sword
shopkeeperScript_notOpenYet:
	showtextlowindex <TX_0e28
	scriptend


.ifdef ROM_SEASONS
; ==================================================================================================
; INTERAC_BOMB_FLOWER
; ==================================================================================================

; bomb flower placed on rocks blocking temple of autumn
bombflower_unblockAutumnTemple:
	wait 60
	incstate
	wait 10
	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	wait 20
	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	shakescreen 120
	asm15 scriptHelp.createBossDeathExplosion
	wait 20
	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	checkpalettefadedone
	setdisabledobjectsto11
	settilehere TILEINDEX_DUG_HOLE
	settileat $32, TILEINDEX_DUG_HOLE
	settileat $34, TILEINDEX_DUG_HOLE
	incstate
	wait 60
	asm15 fadeinFromWhite
	checkpalettefadedone
	orroomflag $80
	setglobalflag GLOBALFLAG_UNBLOCKED_AUTUMN_TEMPLE
	playsound SND_SOLVEPUZZLE
	xorcfc0bit 0
	scriptend

.endif ; ROM_SEASONS


; ==================================================================================================
; INTERAC_SPINNER
; ==================================================================================================

spinnerScript_initialization:
	setcollisionradii $09, $09

spinnerScript_waitForLinkAfterDelay:
	wait 30

spinnerScript_waitForLink:
	checkcollidedwithlink_onground
	ormemory wcc95, $80 ; Signal that Link's in a spinner?
	asm15 dropLinkHeldItem
	setanimationfromangle
	incstate
	; Script stops here since we changed to state 2 (which reloads the script)


; ==================================================================================================
; INTERAC_ESSENCE
; ==================================================================================================
essenceScript_essenceGetCutscene:
	playsound MUS_ESSENCE
	asm15 scriptHelp.essence_createEnergySwirl
	wait 180
	wait 180
	playsound SND_FADEOUT
	wait 20
	playsound SND_FADEOUT
	wait 20
	playsound SND_FADEOUT
	wait 40
	playsound SND_FADEOUT
	asm15 scriptHelp.essence_stopEnergySwirl
	scriptend


; ==================================================================================================
; INTERAC_VASU
; ==================================================================================================

vasuScript:
	setcollisionradii $12, $06
	makeabuttonsensitive

@npcLoop:
	enableinput
	checkabutton
	disableinput
	jumpifglobalflagset GLOBALFLAG_OBTAINED_RING_BOX, @alreadyGaveRingBox
	jumpifmemoryeq wIsLinkedGame, $00, @firstTime
	jumpifmemoryset wObtainedRingBox, $01, @linkedGameFirstTime
	scriptjump @firstTime

@linkedGameFirstTime:
	showtextlowindex <TX_303e
	jumpifobjectbyteeq Interaction.var36, $01, ++ ; Check TREASURE_RING_BOX

	; Give ring box in linked game
	showtextlowindex <TX_303b
	asm15 scriptHelp.vasu_giveRingBox
	wait 1
++
	setdisabledobjectsto11
	checktext
	scriptjump @justGaveRingBox

@firstTime:
	showtextnonexitablelowindex <TX_3000
@giveExplanation:
	jumpiftextoptioneq $00, @explanationDone
	showtextnonexitablelowindex <TX_303a
	scriptjump @giveExplanation
@explanationDone:
	jumpifobjectbyteeq Interaction.var36, $01, ++ ; Check TREASURE_RING_BOX

	; Give ring box in unlinked game
	showtextlowindex <TX_303b
	asm15 scriptHelp.vasu_giveRingBox
	wait 1
	setdisabledobjectsto11
	checktext
++
	; Give friendship ring
	showtextlowindex <TX_303f
	asm15 scriptHelp.vasu_giveFriendshipRing
	wait 1
	setdisabledobjectsto11
	checktext

	; Force Link to appraise it
	showtextlowindex <TX_3033
	asm15 scriptHelp.vasu_openRingMenu, $00
	wait 10

	; Open ring list
	showtextlowindex <TX_3013
	asm15 scriptHelp.vasu_openRingMenu, $01
	wait 10
	showtextlowindex <TX_3008

@justGaveRingBox:
	setglobalflag GLOBALFLAG_OBTAINED_RING_BOX
	ormemory wObtainedRingBox, $01
	enableinput
	scriptjump @npcLoop


@alreadyGaveRingBox:
	; Check whether to give special rings
	asm15 scriptHelp.vasu_checkEarnedSpecialRing
	jumptable_objectbyte Interaction.var3b
	.dw @giveSlayersRing
	.dw @giveWealthRing
	.dw @giveVictoryRing
	.dw @noSpecialRing

@giveSlayersRing:
	showtextlowindex <TX_3036
	scriptjump @giveSpecialRing

@giveWealthRing:
	showtextlowindex <TX_3037
	scriptjump @giveSpecialRing

@giveVictoryRing:
	showtextlowindex <TX_3039
@giveSpecialRing:
	checktext
	asm15 scriptHelp.vasu_giveRingInVar3a
	scriptjump @npcLoop


; Just show normal welcome text
@noSpecialRing:
	showtextnonexitablelowindex <TX_3003
	jumpiftextoptioneq $00, @appraise
	jumpiftextoptioneq $01, @list

	; Selected "Quit"
	enableinput
	showtextlowindex <TX_3008
	scriptjump @npcLoop

@appraise:
	jumpifobjectbyteeq Interaction.var37, $00, @noUnappraisedRings
	asm15 scriptHelp.vasu_openRingMenu, $00
	scriptjump @exitedRingMenu

@list:
	jumpifobjectbyteeq Interaction.var38, $00, @noAppraisedRings
	asm15 scriptHelp.vasu_openRingMenu, $01

@exitedRingMenu:
	wait 10
	jumpifglobalflagset GLOBALFLAG_APPRAISED_HUNDREDTH_RING, @giveHundredthRing

	showtextlowindex <TX_3008
	enableinput
	scriptjump @npcLoop

@giveHundredthRing:
	showtextlowindex <TX_3038
	checktext
	unsetglobalflag GLOBALFLAG_APPRAISED_HUNDREDTH_RING
	asm15 scriptHelp.vasu_giveHundredthRing
	scriptjump @npcLoop


@noUnappraisedRings:
	showtextlowindex <TX_3014
	scriptjump @npcLoop

@noAppraisedRings:
	showtextlowindex <TX_3015
	scriptjump @npcLoop


; Red snake before beating unlinked game
redSnakeScript_preLinked:
	showtextnonexitablelowindex <TX_3009
	jumpiftextoptioneq $00, redSnake_explain

	writememory wTextIsActive, $01
	enableinput
	scriptend

redSnake_explain:
	wait 30
	showtextnonexitablelowindex <TX_300a
	jumpiftextoptioneq $01, @explainBox

@explainAppraisal:
	showtextnonexitablelowindex <TX_300b
	scriptjump ++

@explainBox:
	showtextnonexitablelowindex <TX_300c
++
	jumpiftextoptioneq $00, redSnake_explain
	writememory wTextIsActive, $01
	scriptend


; Blue snake before beating unlinked game
blueSnakeScript_preLinked:
	showtextnonexitablelowindex <TX_301f
	jumpiftextoptioneq $01, blueSnakeScript_doNotRemoveCable
	scriptjump blueSnake_linkOrFortune

; Blue snake after beating linked game
blueSnakeScript_linked:
	showtextnonexitablelowindex <TX_3024
	jumpiftextoptioneq $02, blueSnakeScript_doNotRemoveCable

blueSnake_linkOrFortune:
	setdisabledobjectsto11
	asm15 scriptHelp.blueSnake_linkOrFortune
	wait 1
	scriptend

blueSnakeScript_doNotRemoveCable:
	showtextlowindex <TX_302e
	scriptend
blueSnakeExitScript_cableNotConnected:
	showtextlowindex <TX_300f
	scriptend
blueSnakeExitScript_linkFailed:
	showtextlowindex <TX_3031
	scriptend
blueSnakeExitScript_noValidFile:
	showtextlowindex <TX_302a
	scriptend


; Red snake after beating linked game
redSnakeScript_linked:
	showtextnonexitablelowindex <TX_3018
	jumpiftextoptioneq $02, @quit
	jumpiftextoptioneq $00, @tellSecretToSnake

	; Generate a secret
	asm15 scriptHelp.redSnake_generateRingSecret
@tellSecretToLink:
	showtextnonexitablelowindex <TX_301d
	jumpiftextoptioneq $00, @tellSecretToLink
	scriptjump @quit

@tellSecretToSnake:
	asm15 scriptHelp.redSnake_openSecretInputMenu
	wait 1
	jumpifmemoryeq wTextInputResult, $00, @toldValidSecret

	; Told invalid secret
	showtextlowindex <TX_301e
	scriptend

@quit:
	showtextlowindex <TX_3010
	scriptend

@toldValidSecret:
	showtextlowindex <TX_3027
	scriptend


blueSnakeScript_successfulFortune:
	setdisabledobjectsto11
	showtextlowindex <TX_3023
	asm15 scriptHelp.vasu_giveRingInVar3a
	wait 1
	checktext
	enableallobjects
	scriptend

blueSnakeScript_successfulRingTransfer:
	showtextlowindex <TX_3027
	scriptend


; ==================================================================================================
; INTERAC_GAME_COMPLETE_DIALOG
; ==================================================================================================
gameCompleteDialogScript:
	wait 30
	showtext TX_550d
	jumpiftextoptioneq $00, @dontSave

	; Save
	asm15 scriptHelp.gameCompleteDialog_markGameAsComplete
	asm15 saveFile
	wait 30
	scriptjump ++

@dontSave:
	wait 30
	showtext TX_550e
	jumpiftextoptioneq $00, gameCompleteDialogScript
++
	writememory wTmpcfc0.genericCutscene.cfde, $01
	scriptend


; ==================================================================================================
; INTERAC_RING_HELP_BOOK
; ==================================================================================================

ringHelpBookSubid1Reset:
	writememory wTextIsActive, $01

ringHelpBookSubid1Script:
	checkabutton
	showtextnonexitablelowindex <TX_3019
	jumpiftextoptioneq $01, ringHelpBookSubid1Reset
	showtextlowindex <TX_301a
	scriptjump ringHelpBookSubid1Script


ringHelpBookSubid0Reset:
	writememory wTextIsActive, $01

ringHelpBookSubid0Script:
	checkabutton
	showtextnonexitablelowindex <TX_3020
	jumpiftextoptioneq $01, ringHelpBookSubid0Reset

@showAgain:
	showtextnonexitablelowindex <TX_3025
	jumpiftextoptioneq $01, @option1
@option0:
	jumpiftextoptioneq $02, ringHelpBookSubid0Reset
	showtextnonexitablelowindex <TX_303d
	jumpiftextoptioneq $01, ringHelpBookSubid0Reset
	scriptjump @showAgain
@option1:
	showtextnonexitablelowindex <TX_3026
	jumpiftextoptioneq $01, ringHelpBookSubid0Reset
	scriptjump @showAgain
