; Main file for Oracle of Ages, US version

.include "include/constants.s"
.include "include/rominfo.s"
.include "include/emptyfill.s"
.include "include/structs.s"
.include "include/wram.s"
.include "include/hram.s"
.include "include/macros.s"
.include "include/script_commands.s"
.include "include/simplescript_commands.s"
.include "include/movementscript_commands.s"

.include "objects/macros.s"
.include "include/gfxDataMacros.s"

.include {"{BUILD_DIR}/textDefines.s"}


.BANK $00 SLOT 0
.ORG 0

	.include "code/bank0.s"


.BANK $01 SLOT 1
.ORG 0

	.include "code/bank1.s"

	.include "code/ages/garbage/bank01End.s"


.BANK $02 SLOT 1
.ORG 0

	.include "code/bank2.s"
	.include "code/roomInitialization.s"

	 m_section_free roomGfxChanges NAMESPACE roomGfxChanges
		.include "code/ages/roomGfxChanges.s"
	.ends

	.include "code/ages/garbage/bank02End.s"


.BANK $03 SLOT 1
.ORG 0

	.include "code/bank3.s"

	; This section could probably be made superfree in Ages, but this isn't the case in Seasons,
	; so let's just play it safe and leave it as "free".
	 m_section_free Bank_3_Cutscenes NAMESPACE bank3Cutscenes
		.include "code/bank3Cutscenes.s"
		.include "code/ages/cutscenes/endgameCutscenes.s"
		.include "code/ages/cutscenes/miscCutscenes.s"
	.ends

	.include "code/ages/garbage/bank03End.s"

.BANK $04 SLOT 1
.ORG 0

	.include "code/bank4.s"

	 m_section_superfree RoomPacksAndMusicAssignments NAMESPACE bank4Data1
		; These 2 includes must be in the same bank
		.include {"{GAME_DATA_DIR}/roomPacks.s"}
		.include {"{GAME_DATA_DIR}/musicAssignments.s"}
	.ends

	 m_section_superfree RoomLayouts NAMESPACE roomLayouts
		.include {"{GAME_DATA_DIR}/roomLayoutGroupTable.s"}
	.ends

	; Must be in the same bank as "Tileset_Loading_2".
	 m_section_free Tileset_Loading_1 NAMESPACE tilesets
		.include {"{GAME_DATA_DIR}/tilesets.s"}
		.include {"{GAME_DATA_DIR}/tilesetAssignments.s"}
	.ends

	 m_section_free animationAndUniqueGfxData NAMESPACE animationAndUniqueGfxData
		.include "code/animations.s"

		.include {"{GAME_DATA_DIR}/uniqueGfxHeaders.s"}
		.include {"{GAME_DATA_DIR}/animationGroups.s"}
		.include {"{GAME_DATA_DIR}/animationGfxHeaders.s"}
		.include {"{GAME_DATA_DIR}/animationData.s"}
	.ends

	 m_section_free roomTileChanges NAMESPACE roomTileChanges
		.include "code/ages/tileSubstitutions.s"
		.include {"{GAME_DATA_DIR}/singleTileChanges.s"}
		.include "code/ages/roomSpecificTileChanges.s"
	.ends

	 m_section_free Tileset_Loading_2 NAMESPACE tilesets
		.include "code/loadTilesToRam.s"
		.include "code/ages/loadTilesetData.s"
	.ends

		; Must be in same bank as "code/bank4.s"
	 m_section_free Warp_Data NAMESPACE bank4
		.include {"{GAME_DATA_DIR}/warpDestinations.s"}
		.include {"{GAME_DATA_DIR}/warpSources.s"}
	.ends

	.include "code/ages/garbage/bank04End.s"


.BANK $05 SLOT 1
.ORG 0

	 m_section_free Bank_5 NAMESPACE bank5
		.include "code/specialObjects.s"

		.include {"{GAME_DATA_DIR}/tile_properties/tileTypeMappings.s"}
		.include {"{GAME_DATA_DIR}/tile_properties/cliffTiles.s"}

		.include "code/ages/garbage/bank05End.s"
	.ends


.BANK $06 SLOT 1
.ORG 0


m_section_free Bank_6 NAMESPACE bank6

	.include "code/interactableTiles.s"
	.include "code/specialObjectAnimationsAndDamage.s"
	.include "code/breakableTiles.s"

	.include "code/parentItemUsage.s"

	.include "object_code/common/itemParents/shieldParent.s"
	.include "object_code/common/itemParents/otherSwordsParent.s"
	.include "object_code/common/itemParents/switchHookParent.s"
	.include "object_code/common/itemParents/caneOfSomariaParent.s"
	.include "object_code/common/itemParents/swordParent.s"
	.include "object_code/common/itemParents/harpFluteParent.s"
	.include "object_code/common/itemParents/seedsParent.s"
	.include "object_code/common/itemParents/shovelParent.s"
	.include "object_code/common/itemParents/boomerangParent.s"
	.include "object_code/common/itemParents/bombsBraceletParent.s"
	.include "object_code/common/itemParents/featherParent.s"
	.include "object_code/common/itemParents/magnetGloveParent.s"

	.include "object_code/common/itemParents/commonCode.s"

	.include {"{GAME_DATA_DIR}/itemUsageTables.s"}

	.include "object_code/common/specialObjects/minecart.s"
	.include "object_code/ages/specialObjects/raft.s"

	.include {"{GAME_DATA_DIR}/specialObjectAnimationData.s"}
	.include "object_code/ages/specialObjects/companionCutscene.s"
	.include "object_code/ages/specialObjects/linkInCutscene.s"
	.include {"{GAME_DATA_DIR}/signText.s"}
	.include {"{GAME_DATA_DIR}/tile_properties/breakableTiles.s"}

;;
specialObjectLoadAnimationFrameToBuffer:
	ld hl,w1Companion.visible
	bit 7,(hl)
	ret z

	ld l,<w1Companion.var32
	ld a,(hl)
	call getSpecialObjectGraphicsFrame
	ret z

	ld a,l
	and $f0
	ld l,a
	ld de,w6SpecialObjectGfxBuffer|(:w6SpecialObjectGfxBuffer)
	jp copy256BytesFromBank


	.include "code/ages/garbage/bank06End.s"

.ends


.BANK $07 SLOT 1
.ORG 0

	 m_section_superfree File_Management namespace fileManagement
		.include "code/fileManagement.s"
	.ends

	 ; This section can't be superfree, since it must be in the same bank as section
	 ; "Bank_7_Data".
	 m_section_free Enemy_Part_Collisions namespace bank7
		.include "code/collisionEffects.s"
	.ends

	 m_section_superfree Item_Code namespace itemCode
		.include "code/updateItems.s"
		.include "object_code/common/items/commonCode1.s"

		.include {"{GAME_DATA_DIR}/tile_properties/conveyorItemTiles.s"}
		.include {"{GAME_DATA_DIR}/tile_properties/itemPassableTiles.s"}

		.include "object_code/common/items/seeds.s"
		.include "object_code/common/items/dimitriMouth.s"
		.include "object_code/common/items/bombchus.s"
		.include "object_code/common/items/bombs.s"
		.include "object_code/common/items/boomerang.s"
		.include "object_code/ages/items/switchHook.s"
		.include "object_code/common/items/rickyTornado.s"
		.include "object_code/common/items/magnetBall.s"
		.include "object_code/ages/items/seedShooter.s"
		.include "object_code/common/items/rickyMooshAttack.s"
		.include "object_code/common/items/shovel.s"
		.include "object_code/ages/items/caneOfSomaria.s"
		.include "object_code/common/items/minecartCollision.s"
		.include "object_code/common/items/slingshot.s"
		.include "object_code/common/items/foolsOre.s"
		.include "object_code/common/items/biggoronSword.s"
		.include "object_code/common/items/sword.s"
		.include "object_code/common/items/punch.s"
		.include "object_code/common/items/swordBeam.s"
		.include "object_code/common/items/postUpdate.s"
		.include "object_code/common/items/commonCode2.s"
		.include "object_code/common/items/bracelet.s"
		.include "object_code/common/items/commonBombAndBraceletCode.s"
		.include "object_code/common/items/dust.s"

		.include {"{GAME_DATA_DIR}/itemAttributes.s"}
		.include "data/itemAnimations.s"
	.ends

	 ; This section can't be superfree, since it must be in the same bank as section
	 ; "Enemy_Part_Collisions".
	 m_section_free Bank_7_Data namespace bank7
		.include {"{GAME_DATA_DIR}/enemyActiveCollisions.s"}
		.include {"{GAME_DATA_DIR}/partActiveCollisions.s"}
		.include {"{GAME_DATA_DIR}/objectCollisionTable.s"}

		.include "code/ages/garbage/bank07End.s"
	.ends


.BANK $08 SLOT 1
.ORG 0

m_section_free Interaction_Code_Group1 NAMESPACE commonInteractions1
	.include "object_code/common/interactions/breakTileDebris.s"
	.include "object_code/common/interactions/fallDownHole.s"
	.include "object_code/common/interactions/farore.s"
	.include "object_code/common/interactions/faroreMakeChest.s"
	.include "object_code/common/interactions/dungeonStuff.s"
	.include "object_code/common/interactions/pushblockTrigger.s"
	.include "object_code/common/interactions/pushblock.s"
	.include "object_code/common/interactions/minecart.s"
	.include "object_code/common/interactions/dungeonKeySprite.s"
	.include "object_code/common/interactions/overworldKeySprite.s"
	.include "object_code/common/interactions/faroresMemory.s"
	.include "object_code/common/interactions/doorController.s"
.ends

m_section_free Ages_Interactions_Bank8 NAMESPACE agesInteractionsBank08
	.include "object_code/ages/interactions/toggleFloor.s"
	.include "object_code/ages/interactions/coloredCube.s"
	.include "object_code/ages/interactions/coloredCubeFlame.s"
	.include "object_code/ages/interactions/minecartGate.s"
	.include "object_code/ages/interactions/specialWarp.s"
	.include "object_code/ages/interactions/dungeonScript.s"
	.include "object_code/ages/interactions/dungeonEvents.s"
	.include "object_code/ages/interactions/floorColorChanger.s"
	.include "object_code/ages/interactions/extendableBridge.s"
	.include "object_code/ages/interactions/triggerTranslator.s"
	.include "object_code/ages/interactions/tileFiller.s"
	.include "object_code/common/interactions/bipin.s"
	.include "object_code/ages/interactions/adlar.s"
	.include "object_code/ages/interactions/librarian.s"
	.include "object_code/common/interactions/blossom.s"
	.include "object_code/ages/interactions/veranCutsceneWallmaster.s"
	.include "object_code/ages/interactions/veranCutsceneFace.s"
	.include "object_code/ages/interactions/oldManWithRupees.s"
	.include "object_code/ages/interactions/playNayruMusic.s"
	.include "object_code/ages/interactions/shootingGallery.s"
	.include "object_code/ages/interactions/impaInCutscene.s"
	.include "object_code/ages/interactions/fakeOctorok.s"
	.include "object_code/ages/interactions/smogBoss.s"
	.include "object_code/ages/interactions/triforceStone.s"
	.include "object_code/common/interactions/child.s"
	.include "object_code/ages/interactions/nayru.s"
	.include "object_code/ages/interactions/ralph.s"
	.include "object_code/ages/interactions/pastGirl.s"
	.include "object_code/ages/interactions/monkey.s"
	.include "object_code/ages/interactions/villager.s"
	.include "object_code/ages/interactions/femaleVillager.s"
	.include "object_code/ages/interactions/boy.s"
	.include "object_code/ages/interactions/oldLady.s"
.ends


.BANK $09 SLOT 1
.ORG 0

m_section_free Interaction_Code_Group2 NAMESPACE commonInteractions2
	.include "object_code/common/interactions/shopkeeper.s"
	.include "object_code/common/interactions/shopItem.s"
	.include "object_code/common/interactions/introSprites1.s"
	.include "object_code/common/interactions/seasonsFairy.s"
	.include "object_code/common/interactions/explosion.s"
.ends

	.include "object_code/common/interactions/treasure.s"

m_section_free Ages_Interactions_Bank9 NAMESPACE agesInteractionsBank09
	.include "object_code/ages/interactions/ghostVeran.s"
	.include "object_code/ages/interactions/boy2.s"
	.include "object_code/ages/interactions/soldier.s"
	.include "object_code/ages/interactions/miscMan.s"
	.include "object_code/ages/interactions/mustacheMan.s"
	.include "object_code/ages/interactions/pastGuy.s"
	.include "object_code/ages/interactions/miscMan2.s"
	.include "object_code/ages/interactions/pastOldLady.s"
	.include "object_code/ages/interactions/tokay.s"
	.include "object_code/ages/interactions/forestFairy.s"
	.include "object_code/ages/interactions/rabbit.s"
	.include "object_code/ages/interactions/bird.s"
	.include "object_code/ages/interactions/ambi.s"
	.include "object_code/ages/interactions/subrosian.s"
	.include "object_code/ages/interactions/impaNpc.s"
	.include "object_code/ages/interactions/dumbellMan.s"
	.include "object_code/ages/interactions/oldMan.s"
	.include "object_code/ages/interactions/mamamuYan.s"
	.include "object_code/ages/interactions/mamamuDog.s"
	.include "object_code/ages/interactions/postman.s"
	.include "object_code/ages/interactions/pickaxeWorker.s"
	.include "object_code/ages/interactions/hardhatWorker.s"
	.include "object_code/ages/interactions/poe.s"
	.include "object_code/ages/interactions/oldZora.s"
	.include "object_code/ages/interactions/toiletHand.s"
	.include "object_code/ages/interactions/maskSalesman.s"
	.include "object_code/ages/interactions/bear.s"
	.include "object_code/ages/interactions/sword.s"
	.include "object_code/common/interactions/syrup.s"
	.include "object_code/ages/interactions/lever.s"
	.include "object_code/ages/interactions/makuConfetti.s"
	.include "object_code/ages/interactions/accessory.s"
	.include "object_code/ages/interactions/raftwreckCutsceneHelper.s"
	.include "object_code/ages/interactions/comedian.s"
	.include "object_code/ages/interactions/goron.s"
.ends


.BANK $0a SLOT 1
.ORG 0

m_section_free Interaction_Code_Group3 NAMESPACE commonInteractions3
	.include "object_code/common/interactions/bombFlower.s"
	.include "object_code/common/interactions/switchTileToggler.s"
	.include "object_code/common/interactions/movingPlatform.s"
	.include "object_code/common/interactions/roller.s"
	.include "object_code/common/interactions/spinner.s"
	.include "object_code/common/interactions/minibossPortal.s"
	.include "object_code/common/interactions/essence.s"
.ends

m_section_free Interaction_Code_Group4 NAMESPACE commonInteractions4
	.include "object_code/common/interactions/vasu.s"
	.include "object_code/common/interactions/bubble.s"
.ends

m_section_free Ages_Interactions_BankA NAMESPACE agesInteractionsBank0a
	.include "object_code/common/interactions/companionSpawner.s"
	.include "object_code/ages/interactions/rosa.s"
	.include "object_code/ages/interactions/rafton.s"
	.include "object_code/ages/interactions/cheval.s"
	.include "object_code/ages/interactions/miscellaneous1.s"
	.include "object_code/ages/interactions/fairyHidingMinigame.s"
	.include "object_code/ages/interactions/possessedNayru.s"
	.include "object_code/ages/interactions/nayruSavedCutscene.s"
	.include "object_code/ages/interactions/wildTokayController.s"
	.include "object_code/ages/interactions/companionScripts.s"
	.include "object_code/ages/interactions/kingMoblinDefeated.s"
	.include "object_code/ages/interactions/ghiniHarassingMoosh.s"
	.include "object_code/ages/interactions/rickysGloveSpawner.s"
	.include "object_code/ages/interactions/introSprite.s"
	.include "object_code/ages/interactions/makuGateOpening.s"
	.include "object_code/ages/interactions/smallKeyOnEnemy.s"
	.include "object_code/ages/interactions/stonePanel.s"
	.include "object_code/ages/interactions/screenDistortion.s"
	.include "object_code/ages/interactions/decoration.s"
	.include "object_code/ages/interactions/tokayShopItem.s"
	.include "object_code/ages/interactions/sarcophagus.s"
	.include "object_code/ages/interactions/bombUpgradeFairy.s"
	.include "object_code/ages/interactions/sparkle.s"
	.include "object_code/ages/interactions/makuFlower.s"
	.include "object_code/ages/interactions/makuTree.s"
	.include "object_code/ages/interactions/makuSprout.s"
	.include "object_code/ages/interactions/remoteMakuCutscene.s"
	.include "object_code/ages/interactions/goronElder.s"
	.include "object_code/ages/interactions/tokayMeat.s"
	.include "object_code/ages/interactions/cloakedTwinrova.s"
	.include "object_code/ages/interactions/octogonSplash.s"
	.include "object_code/ages/interactions/tokayCutsceneEmberSeed.s"
	.include "object_code/ages/interactions/miscPuzzles.s"
	.include "object_code/ages/interactions/fallingRock.s"
	.include "object_code/ages/interactions/twinrova.s"
	.include "object_code/ages/interactions/patch.s"
	.include "object_code/ages/interactions/ball.s"
	.include "object_code/ages/interactions/moblin.s"
	.include "object_code/ages/interactions/97.s"
.ends


.BANK $0b SLOT 1
.ORG 0

m_section_free Interaction_Code_Group5 NAMESPACE commonInteractions5
	.include "object_code/common/interactions/woodenTunnel.s"
	.include "object_code/common/interactions/exclamationMark.s"
	.include "object_code/common/interactions/floatingImage.s"
	.include "object_code/common/interactions/bipinBlossomFamilySpawner.s"
	.include "object_code/common/interactions/gashaSpot.s"
	.include "object_code/common/interactions/kissHeart.s"
	.include "object_code/common/interactions/banana.s"
	.include "object_code/common/interactions/createObjectAtEachTileindex.s"
.ends

m_section_free Interaction_Code_Group6 NAMESPACE commonInteractions6
	.include "object_code/common/interactions/businessScrub.s"
	.include "object_code/common/interactions/cf.s"
	.include "object_code/common/interactions/companionTutorial.s"
	.include "object_code/common/interactions/gameCompleteDialog.s"
	.include "object_code/common/interactions/titlescreenClouds.s"
	.include "object_code/common/interactions/introBird.s"
	.include "object_code/common/interactions/linkShip.s"
.ends

m_section_free Interaction_Code_Group7 NAMESPACE commonInteractions7
	.include "object_code/common/interactions/faroreGiveItem.s"
	.include "object_code/common/interactions/zeldaApproachTrigger.s"
.ends

m_section_free Ages_Interactions_Bank0b NAMESPACE agesInteractionsBank0b
	.include "object_code/ages/interactions/explosionWithDebris.s"
	.include "object_code/ages/interactions/carpenter.s"
	.include "object_code/ages/interactions/raftwreckCutscene.s"
	.include "object_code/ages/interactions/kingZora.s"
	.include "object_code/ages/interactions/tokkey.s"
	.include "object_code/ages/interactions/waterPushblock.s"
	.include "object_code/common/interactions/movingSidescrollPlatform.s"
	.include "object_code/common/interactions/movingSidescrollConveyor.s"
	.include "object_code/ages/interactions/disappearingSidescrollPlatform.s"
	.include "object_code/ages/interactions/circularSidescrollPlatform.s"
	.include "object_code/ages/interactions/touchingBook.s"
	.include "object_code/ages/interactions/makuSeed.s"
	.include "object_code/common/interactions/endgameCutsceneBipsomFamily.s"
	.include "object_code/ages/interactions/a8.s"
	.include "object_code/common/interactions/twinrovaFlame.s"
	.include "object_code/ages/interactions/din.s"
	.include "object_code/ages/interactions/zora.s"
	.include "object_code/ages/interactions/zelda.s"
	.include "object_code/common/interactions/creditsTextHorizontal.s"
	.include "object_code/common/interactions/creditsTextVertical.s"
	.include "object_code/ages/interactions/twinrovaInCutscene.s"
	.include "object_code/ages/interactions/tuniNut.s"
	.include "object_code/ages/interactions/volcanoHandler.s"
	.include "object_code/ages/interactions/harpOfAgesSpawner.s"
	.include "object_code/ages/interactions/bookOfSealsPodium.s"
	.include "object_code/common/interactions/finalDungeonEnergy.s"
	.include "object_code/ages/interactions/vire.s"
	.include "object_code/common/interactions/horonDogCredits.s"
	.include "object_code/ages/interactions/childJabu.s"
	.include "object_code/ages/interactions/humanVeran.s"
	.include "object_code/ages/interactions/twinrova3.s"
	.include "object_code/ages/interactions/pushblockSynchronizer.s"
	.include "object_code/ages/interactions/ambisPalaceButton.s"
	.include "object_code/ages/interactions/symmetryNpc.s"
	.include "object_code/common/interactions/c1.s"
	.include "object_code/ages/interactions/pirateShip.s"
	.include "object_code/ages/interactions/pirateCaptain.s"
	.include "object_code/ages/interactions/pirate.s"
	.include "object_code/ages/interactions/playHarpSong.s"
	.include "object_code/ages/interactions/blackTowerDoorHandler.s"
	.include "object_code/ages/interactions/tingle.s"
	.include "object_code/common/interactions/syrupCucco.s"
	.include "object_code/ages/interactions/troy.s"
	.include "object_code/ages/interactions/linkedGameGhini.s"
	.include "object_code/ages/interactions/plen.s"
	.include "object_code/ages/interactions/masterDiver.s"
	.include "object_code/ages/interactions/greatFairy.s"
	.include "object_code/ages/interactions/dekuScrub.s"
	.include "object_code/ages/interactions/makuSeedAndEssences.s"
	.include "object_code/ages/interactions/leverLavaFiller.s"
	.include "object_code/ages/interactions/slateSlot.s"
.ends

	.include "code/ages/garbage/bank0bEnd.s"


.BANK $0c SLOT 1
.ORG 0

	; TODO: "SIMPLE_SCRIPT_BANK" define should be tied to this section somehow
	 m_section_free Scripts namespace mainScripts
		.include "code/scripting.s"
		.include "scripts/ages/scripts.s"
	.ends


.BANK $0d SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0d NAMESPACE bank0d

	.include "object_code/common/enemies/commonCode.s"

	.include "object_code/common/enemies/riverZora.s"
	.include "object_code/common/enemies/octorok.s"
	.include "object_code/common/enemies/boomerangMoblin.s"
	.include "object_code/common/enemies/leever.s"
	.include "object_code/common/enemies/moblinsAndShroudedStalfos.s"
	.include "object_code/common/enemies/arrowDarknut.s"
	.include "object_code/common/enemies/lynel.s"
	.include "object_code/common/enemies/bladeAndFlameTrap.s"
	.include "object_code/common/enemies/rope.s"
	.include "object_code/common/enemies/gibdo.s"
	.include "object_code/common/enemies/spark.s"
	.include "object_code/common/enemies/whisp.s"
	.include "object_code/common/enemies/spikedBeetle.s"
	.include "object_code/common/enemies/bubble.s"
	.include "object_code/common/enemies/beamos.s"
	.include "object_code/common/enemies/ghini.s"
	.include "object_code/common/enemies/buzzblob.s"
	.include "object_code/common/enemies/sandCrab.s"
	.include "object_code/common/enemies/spinyBeetle.s"
	.include "object_code/common/enemies/armos.s"
	.include "object_code/common/enemies/piranha.s"
	.include "object_code/common/enemies/polsVoice.s"
	.include "object_code/common/enemies/likelike.s"
	.include "object_code/common/enemies/gopongaFlower.s"
	.include "object_code/common/enemies/dekuScrub.s"
	.include "object_code/common/enemies/wallmaster.s"
	.include "object_code/common/enemies/podoboo.s"
	.include "object_code/common/enemies/giantBladeTrap.s"
	.include "object_code/common/enemies/cheepcheep.s"
	.include "object_code/common/enemies/podobooTower.s"
	.include "object_code/common/enemies/thwimp.s"
	.include "object_code/common/enemies/thwomp.s"

	.include "object_code/ages/enemies/veranSpider.s"
	.include "object_code/ages/enemies/eyesoarChild.s"
	.include "object_code/ages/enemies/ironMask.s"
	.include "object_code/ages/enemies/veranChildBee.s"
	.include "object_code/ages/enemies/anglerFishBubble.s"
	.include "object_code/ages/enemies/enableSidescrollDownTransition.s"

.ends

m_section_superfree Enemy_Animations
	.include {"{GAME_DATA_DIR}/enemyAnimations.s"}
.ends


.BANK $0e SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0e NAMESPACE bank0e

	.include "object_code/common/enemies/commonCode.s"

	.include "object_code/common/enemies/tektite.s"
	.include "object_code/common/enemies/stalfos.s"
	.include "object_code/common/enemies/keese.s"
	.include "object_code/common/enemies/babyCucco.s"
	.include "object_code/common/enemies/zol.s"
	.include "object_code/common/enemies/floormaster.s"
	.include "object_code/common/enemies/cucco.s"
	.include "object_code/common/enemies/giantCucco.s"
	.include "object_code/common/enemies/butterfly.s"
	.include "object_code/common/enemies/greatFairy.s"
	.include "object_code/common/enemies/fireKeese.s"
	.include "object_code/common/enemies/waterTektite.s"
	.include "object_code/common/enemies/swordEnemies.s"
	.include "object_code/common/enemies/peahat.s"
	.include "object_code/common/enemies/wizzrobe.s"
	.include "object_code/common/enemies/crows.s"
	.include "object_code/common/enemies/gel.s"
	.include "object_code/common/enemies/pincer.s"
	.include "object_code/common/enemies/ballAndChainSoldier.s"
	.include "object_code/common/enemies/hardhatBeetle.s"
	.include "object_code/ages/enemies/linkMimic.s"
	.include "object_code/common/enemies/armMimic.s"
	.include "object_code/common/enemies/moldorm.s"
	.include "object_code/common/enemies/fireballShooter.s"
	.include "object_code/common/enemies/beetle.s"
	.include "object_code/common/enemies/flyingTile.s"
	.include "object_code/common/enemies/dragonfly.s"
	.include "object_code/common/enemies/bushOrRock.s"
	.include "object_code/common/enemies/itemDropProducer.s"
	.include "object_code/common/enemies/seedsOnTree.s"
	.include "object_code/common/enemies/twinrovaIce.s"
	.include "object_code/common/enemies/twinrovaBat.s"
	.include "object_code/common/enemies/ganonRevivalCutscene.s"

	.include {"{GAME_DATA_DIR}/orbMovementScript.s"}
	.include "code/objectMovementScript.s"

	.include "object_code/ages/enemies/bari.s"
	.include "object_code/ages/enemies/giantGhiniChild.s"
	.include "object_code/ages/enemies/shadowHagBug.s"
	.include "object_code/ages/enemies/colorChangingGel.s"
	.include "object_code/ages/enemies/ambiGuard.s"
	.include "object_code/ages/enemies/candle.s"
	.include "object_code/ages/enemies/kingMoblinMinion.s"
	.include "object_code/ages/enemies/veranPossessionBoss.s"
	.include "object_code/ages/enemies/vineSprout.s"
	.include "object_code/ages/enemies/targetCartCrystal.s"

	.include {"{GAME_DATA_DIR}/movingSidescrollPlatform.s"}

	.include "code/ages/garbage/bank0eEnd.s"

.ends

.BANK $0f SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0f NAMESPACE bank0f

	.include "object_code/common/enemies/commonCode.s"
	.include "object_code/common/enemies/commonBossCode.s"

	.include "object_code/ages/enemies/giantGhini.s"
	.include "object_code/ages/enemies/swoop.s"
	.include "object_code/ages/enemies/subterror.s"
	.include "object_code/ages/enemies/armosWarrior.s"
	.include "object_code/ages/enemies/smasher.s"
	.include "object_code/common/enemies/vire.s"
	.include "object_code/ages/enemies/anglerFish.s"
	.include "object_code/ages/enemies/blueStalfos.s"
	.include "object_code/ages/enemies/pumpkinHead.s"
	.include "object_code/ages/enemies/headThwomp.s"
	.include "object_code/ages/enemies/shadowHag.s"
	.include "object_code/ages/enemies/eyesoar.s"
	.include "object_code/ages/enemies/smog.s"
	.include "object_code/ages/enemies/octogon.s"
	.include "object_code/ages/enemies/plasmarine.s"
	.include "object_code/ages/enemies/kingMoblin.s"

.ends

.BANK $10 SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank10 NAMESPACE bank10

	.include "object_code/common/enemies/commonCode.s"
	.include "object_code/common/enemies/commonBossCode.s"

	.include "object_code/common/enemies/mergedTwinrova.s"
	.include "object_code/common/enemies/twinrova.s"
	.include "object_code/common/enemies/ganon.s"
	.include "object_code/common/enemies/none.s"

	.include "object_code/ages/enemies/veranFinalForm.s"
	.include "object_code/ages/enemies/ramrockArms.s"
	.include "object_code/ages/enemies/veranFairy.s"
	.include "object_code/ages/enemies/ramrock.s"
	.include "object_code/ages/enemies/kingMoblinMinionMain.s"

.ends


.ifdef BUILD_VANILLA
.ifdef REGION_JP
	; 3 garbage bytes, which round out the data following this to start at $6e00
	.db $be $28 $1e
.else
	; Some blank space here ($6e1f-$6eff)
	.ORGA $6f00
.endif
.endif

m_section_free Interaction_Code_Group8 NAMESPACE commonInteractions8
	.include "object_code/common/interactions/eraOrSeasonInfo.s"
	.include "object_code/common/interactions/statueEyeball.s"
	.include "object_code/common/interactions/ringHelpBook.s"
.ends

	.include "code/ages/cutscenes/bank10.s"

m_section_free Ages_Interactions_Bank10 NAMESPACE agesInteractionsBank10
	.include "object_code/ages/interactions/miscellaneous2.s"
	.include "object_code/ages/interactions/timewarp.s"
	.include "object_code/ages/interactions/timeportal.s"
	.include "object_code/common/interactions/nayruRalphCredits.s"
	.include "object_code/ages/interactions/timeportalSpawner.s"
	.include "object_code/ages/interactions/knowItAllBird.s"
	.include "object_code/ages/interactions/raft.s"
.ends


.BANK $11 SLOT 1
.ORG 0

	.define PART_BANK $11
	.export PART_BANK

m_section_free Bank_11 NAMESPACE partCode
	.include "object_code/common/parts/commonCode.s"

	.include "object_code/common/parts/itemDrop.s"
	.include "object_code/common/parts/enemyDestroyed.s"
	.include "object_code/common/parts/orb.s"
	.include "object_code/common/parts/bossDeathExplosion.s"
	.include "object_code/common/parts/switch.s"
	.include "object_code/common/parts/lightableTorch.s"
	.include "object_code/common/parts/shadow.s"
	.include "object_code/common/parts/darkRoomHandler.s"
	.include "object_code/common/parts/button.s"
	.include "object_code/common/parts/movingOrb.s"
	.include "object_code/common/parts/bridgeSpawner.s"
	.include "object_code/common/parts/detectionHelper.s"
	.include "object_code/common/parts/respawnableBush.s"
	.include "object_code/common/parts/seedOnTree.s"
	.include "object_code/common/parts/volcanoRock.s"
	.include "object_code/common/parts/flame.s"
	.include "object_code/common/parts/owlStatue.s"
	.include "object_code/common/parts/itemFromMaple.s"
	.include "object_code/common/parts/gashaTree.s"
	.include "object_code/common/parts/octorokProjectile.s"
	.include "object_code/common/parts/fireProjectiles.s"
	.include "object_code/common/parts/enemyArrow.s"
	.include "object_code/common/parts/lynelBeam.s"
	.include "object_code/common/parts/stalfosBone.s"
	.include "object_code/common/parts/enemySword.s"
	.include "object_code/common/parts/dekuScrubProjectile.s"
	.include "object_code/common/parts/wizzrobeProjectile.s"
	.include "object_code/common/parts/fire.s"
	.include "object_code/common/parts/moblinBoomerang.s"
	.include "object_code/common/parts/cuccoAttacker.s"
	.include "object_code/common/parts/fallingFire.s"
	.include "object_code/common/parts/lighting.s"
	.include "object_code/common/parts/smallFairy.s"
	.include "object_code/common/parts/beam.s"
	.include "object_code/common/parts/spikedBall.s"
	.include "object_code/common/parts/greatFairyHeart.s"
	.include "object_code/common/parts/twinrovaProjectile.s"
	.include "object_code/common/parts/twinrovaFlame.s"
	.include "object_code/common/parts/twinrovaSnowball.s"
	.include "object_code/common/parts/ganonTrident.s"
	.include "object_code/common/parts/51.s"
	.include "object_code/common/parts/52.s"
	.include "object_code/common/parts/blueEnergyBead.s"

	.include "code/updateParts.s"
	.include "data/partCodeTable.s"

	.include "object_code/ages/parts/jabuJabusBubbles.s"
	.include "object_code/ages/parts/grottoCrystal.s"
	.include "object_code/ages/parts/wallArrowShooter.s"
	.include "object_code/ages/parts/sparkle.s"
	.include "object_code/ages/parts/timewarpAnimation.s"
	.include "object_code/ages/parts/donkeyKongFlame.s"
	.include "object_code/ages/parts/veranFairyProjectile.s"
	.include "object_code/ages/parts/seaEffects.s"
	.include "object_code/ages/parts/babyBall.s"
	.include "object_code/ages/parts/subterrorDirt.s"
	.include "object_code/ages/parts/rotatableSeedThing.s"
	.include "object_code/ages/parts/ramrockSeedFormLaser.s"
	.include "object_code/ages/parts/ramrockGloveFormArm.s"
	.include "object_code/ages/parts/candleFlame.s"
	.include "object_code/ages/parts/veranProjectile.s"
	.include "object_code/ages/parts/ball.s"
	.include "object_code/ages/parts/headThwompFireball.s"
	.include "object_code/common/parts/vireProjectile.s"
	.include "object_code/ages/parts/3b.s"
	.include "object_code/ages/parts/headThwompCircularProjectile.s"
	.include "object_code/ages/parts/blueStalfosProjectile.s"
	.include "object_code/ages/parts/3e.s"
	.include "object_code/ages/parts/kingMoblinBomb.s"
	.include "object_code/ages/parts/headThwompBombDropper.s"
	.include "object_code/ages/parts/shadowHagShadow.s"
	.include "object_code/ages/parts/pumpkinHeadProjectile.s"
	.include "object_code/ages/parts/plasmarineProjectile.s"
	.include "object_code/ages/parts/tingleBalloon.s"
	.include "object_code/ages/parts/fallingBoulderSpawner.s"
	.include "object_code/ages/parts/seedShooterEyeStatue.s"
	.include "object_code/ages/parts/bomb.s"
	.include "object_code/ages/parts/octogonDepthCharge.s"
	.include "object_code/ages/parts/bigBangBombSpawner.s"
	.include "object_code/ages/parts/smogProjectile.s"
	.include "object_code/ages/parts/ramrockSeedFormOrb.s"
	.include "object_code/ages/parts/roomOfRitesFallingBoulder.s"
	.include "object_code/ages/parts/octogonBubble.s"
	.include "object_code/ages/parts/veranSpiderweb.s"
	.include "object_code/ages/parts/veranAcidPool.s"
	.include "object_code/ages/parts/veranBeeProjectile.s"
	.include "object_code/ages/parts/blackTowerMovingFlames.s"
	.include "object_code/ages/parts/triforceStone.s"

	.include "code/ages/garbage/bank11End.s"
.ends


.BANK $12 SLOT 1
.ORG 0

	.include "code/objectLoading.s"

m_section_superfree Room_Code namespace roomSpecificCode

	.include "code/ages/roomSpecificCode.s"

.ends

m_section_free Objects_2 namespace objectData

	.include "objects/ages/mainData.s"
	.include "objects/ages/extraData3.s"

.ends

m_section_superfree Underwater_Surface_Data namespace underwaterSurfacing

	.include "code/ages/underwaterSurfacing.s"
	.include "data/ages/underwaterSurfaceData.s"

.ENDS

m_section_free Objects_3 namespace objectData

	.include "objects/ages/extraData4.s"

.ends


.BANK $13 SLOT 1
.ORG 0

	.define BASE_OAM_DATA_BANK $13
	.export BASE_OAM_DATA_BANK

	.include {"{GAME_DATA_DIR}/specialObjectOamData.s"}
	.include "data/itemOamData.s"
	.include {"{GAME_DATA_DIR}/enemyOamData.s"}


.BANK $14 SLOT 1
.ORG 0

m_section_superfree Terrain_Effects NAMESPACE terrainEffects
	.include "data/terrainEffects.s"
.ends

	.include {"{GAME_DATA_DIR}/interactionOamData.s"}
	.include {"{GAME_DATA_DIR}/partOamData.s"}


.BANK $15 SLOT 1
.ORG 0

	.include "scripts/common/scriptHelper.s"

	 m_section_free Object_Pointers namespace objectData

	;;
	getObjectDataAddress:
		ld a,(wActiveGroup)
		ld hl,objectDataGroupTable
		rst_addDoubleIndex
		ldi a,(hl)
		ld h,(hl)
		ld l,a
		ld a,(wActiveRoom)
		ld e,a
		ld d,$00
		add hl,de
		add hl,de
		ldi a,(hl)
		ld d,(hl)
		ld e,a
		ret


		.include "objects/ages/pointers.s"

	.ENDS

	 m_section_free Bank_15_3 NAMESPACE scriptHelp
		.include "scripts/ages/scriptHelper.s"
	.ends


.BANK $16 SLOT 1
.ORG 0

	.include "code/serialFunctions.s"
	.include "code/loadTreasureData.s"

	 m_section_free Bank16 NAMESPACE bank16
		.include {"{GAME_DATA_DIR}/data_4556.s"}
		.include {"{GAME_DATA_DIR}/endgameCutsceneOamData.s"}
	.ends


	.include "code/staticObjects.s"
	.include {"{GAME_DATA_DIR}/staticDungeonObjects.s"}
	.include {"{GAME_DATA_DIR}/chestData.s"}
	.include {"{GAME_DATA_DIR}/treasureObjectData.s"}

m_section_free Bank16_2 NAMESPACE bank16

;;
; Used in the room in present Mermaid's Cave with the changing floor
;
; @param	b	Floor state (0/1)
loadD6ChangingFloorPatternToBigBuffer:
	ld a,b
	add a
	ld hl,@changingFloorData
	rst_addDoubleIndex
	push hl
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld b,$41
	ld hl,wBigBuffer
	call copyMemoryReverse

	pop hl
	inc hl
	inc hl
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld b,$41
	ld hl,wBigBuffer+$80
	call copyMemoryReverse

	ldh a,(<hActiveObject)
	ld d,a
	ret

@changingFloorData:
	.dw @tiles0_bottomHalf
	.dw @tiles0_topHalf

	.dw @tiles1
	.dw @tiles1

@tiles0_bottomHalf:
	.db $a0 $a0 $a0 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4
	.db $00

@tiles0_topHalf:
	.db $a0 $a0 $a0 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $a0 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $a0 $f4 $f4 $f4 $f4 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $a0 $ff
	.db $a0 $a0 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $ff
	.db $f4 $f4 $f4 $f4
	.db $00

@tiles1:
	.db $a0 $a0 $f4 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $a0 $a0 $f4 $f4 $f4 $f4 $f4 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $a0 $a0 $a0 $f4 $f4 $a0 $ff
	.db $a0 $a0 $f4 $a0
	.db $00

.ends

	.include {"{GAME_DATA_DIR}/interactionAnimations.s"}
	.include {"{GAME_DATA_DIR}/partAnimations.s"}


.BANK $17 SLOT 1
.ORG 0

	.include {"{GAME_DATA_DIR}/paletteData.s"}
	.include {"{GAME_DATA_DIR}/tilesetCollisions.s"}
	.include {"{GAME_DATA_DIR}/smallRoomLayoutTables.s"}

	.include "code/ages/garbage/bank17End.s"


.BANK $18 SLOT 1
.ORG 0

m_section_free Tile_Mappings

	tileMappingIndexDataPointer:
		.dw tileMappingIndexData
	tileMappingAttributeDataPointer:
		.dw tileMappingAttributeData

	tileMappingTable:
		.incbin {"{BUILD_DIR}/tileset_layouts/tileMappingTable.bin"}
	tileMappingIndexData:
		.incbin {"{BUILD_DIR}/tileset_layouts/tileMappingIndexData.bin"}
	tileMappingAttributeData:
		.incbin {"{BUILD_DIR}/tileset_layouts/tileMappingAttributeData.bin"}

.ifdef ROM_AGES
	.include "code/ages/garbage/bank18End.s"
.endif

.ends


.BANK $19 SLOT 1
.ORG 0

m_section_free Gfx_19_1 ALIGN $10
	.include {"{GAME_DATA_DIR}/gfxDataBank19_1.s"}
.ends

m_section_superfree Tile_mappings
	.include {"{GAME_DATA_DIR}/tilesetMappings.s"}
.ends

m_section_free Gfx_19_2 ALIGN $10
	.include {"{GAME_DATA_DIR}/gfxDataBank19_2.s"}
.ends


.BANK $1a SLOT 1
.ORG 0


m_section_free Gfx_1a ALIGN $20
	.include "data/gfxDataBank1a.s"
.ends


.BANK $1b SLOT 1
.ORG 0

m_section_free Gfx_1b ALIGN $20
	.include "data/gfxDataBank1b.s"
.ends


.BANK $1c SLOT 1
.ORG 0

	; The first $e characters of gfx_font are blank, so they aren't
	; included in the rom. In order to get the offsets correct, use
	; gfx_font_start as the label instead of gfx_font.

	.define gfx_font_start gfx_font-$e0
	.export gfx_font_start

	m_GfxDataSimple gfx_font_jp ; $70000
	m_GfxDataSimple gfx_font_tradeitems ; $70600
	m_GfxDataSimple gfx_font $e0 ; $70800
	m_GfxDataSimple gfx_font_heartpiece ; $71720

	m_GfxDataSimple map_rings ; $717a0

	.include {"{GAME_DATA_DIR}/largeRoomLayoutTables.s"} ; $719c0
	.include "code/ages/garbage/bank1cEnd.s"

	; "${BUILD_DIR}/textData.s" will determine where this data starts.
	;   Ages:    1d:4000
	;   Seasons: 1c:5c00

	.include {"{BUILD_DIR}/textData.s"}

	.REDEFINE DATA_ADDR TEXT_END_ADDR
	.REDEFINE DATA_BANK TEXT_END_BANK

	.include {"{GAME_DATA_DIR}/roomLayoutData.s"}
	.include {"{GAME_DATA_DIR}/gfxDataMain.s"}



.BANK $3f SLOT 1
.ORG 0

m_section_free Bank3f NAMESPACE bank3f

.define BANK_3f $3f

.include "code/loadGraphics.s"
.include "code/treasureAndDrops.s"
.include "code/textbox.s"

data_5951:
	.db $3c $b4 $3c $50 $78 $b4 $3c $3c
	.db $3c $70 $78 $78


; In Seasons these sprites are located elsewhere

titlescreenMakuSeedSprite:
	.db $13
	.db $48 $90 $62 $06
	.db $42 $8e $68 $06
	.db $51 $7a $56 $04
	.db $50 $82 $74 $04
	.db $58 $7a $6a $07
	.db $58 $82 $6c $07
	.db $58 $8a $6e $07
	.db $54 $8a $54 $03
	.db $54 $82 $52 $03
	.db $54 $7a $50 $03
	.db $64 $7a $70 $03
	.db $64 $82 $72 $03
	.db $64 $8a $70 $23
	.db $40 $86 $66 $06
	.db $40 $7f $64 $06
	.db $41 $70 $60 $06
	.db $55 $76 $5a $06
	.db $44 $68 $5e $26
	.db $74 $00 $46 $02

titlescreenPressStartSprites:
	.db $0a
	.db $80 $2c $38 $00
	.db $80 $34 $3a $00
	.db $80 $3c $3c $00
	.db $80 $44 $3e $00
	.db $80 $4c $3e $00
	.db $80 $5c $3e $00
	.db $80 $64 $40 $00
	.db $80 $6c $42 $00
	.db $80 $74 $3a $00
	.db $80 $7c $40 $00

; Sprites used on the closeup shot of Link on the horse in the intro
linkOnHorseCloseupSprites_2:
	.db $26
	.db $80 $80 $40 $06
	.db $80 $50 $42 $00
	.db $80 $58 $44 $00
	.db $68 $40 $46 $06
	.db $b8 $3d $20 $02
	.db $b8 $45 $22 $02
	.db $b8 $4d $24 $02
	.db $b8 $55 $26 $02
	.db $b8 $5d $28 $02
	.db $90 $28 $2c $02
	.db $90 $30 $2e $02
	.db $80 $30 $2a $02
	.db $20 $78 $48 $05
	.db $58 $68 $00 $02
	.db $58 $70 $02 $02
	.db $68 $68 $04 $02
	.db $48 $70 $06 $02
	.db $5a $40 $08 $01
	.db $5a $48 $0a $01
	.db $5a $50 $0c $01
	.db $38 $88 $0e $04
	.db $30 $78 $10 $04
	.db $30 $80 $12 $04
	.db $40 $80 $14 $04
	.db $50 $76 $16 $04
	.db $50 $7e $18 $04
	.db $41 $62 $1a $03
	.db $80 $28 $1c $02
	.db $a8 $59 $1e $02
	.db $98 $20 $30 $02
	.db $98 $28 $32 $02
	.db $8c $38 $34 $07
	.db $a8 $41 $36 $02
	.db $a8 $49 $38 $02
	.db $a8 $51 $3a $02
	.db $90 $40 $3e $07
	.db $8a $5c $4a $00
	.db $8a $64 $4c $00

; Sprites used to touch up the appearance of the temple in the intro (the scene where
; Link's on a cliff with his horse)
introTempleSprites:
	.db $05
	.db $30 $28 $48 $02
	.db $30 $30 $4a $02
	.db $18 $38 $4c $03
	.db $10 $40 $4e $03
	.db $18 $48 $50 $03


; Used in intro (ages only)
linkOnHorseFacingCameraSprite:
	.db $02
	.db $70 $08 $58 $02
	.db $70 $10 $5a $02



.include {"{GAME_DATA_DIR}/objectGfxHeaders.s"}
.include {"{GAME_DATA_DIR}/treeGfxHeaders.s"}

.include {"{GAME_DATA_DIR}/enemyData.s"}
.include {"{GAME_DATA_DIR}/partData.s"}
.include {"{GAME_DATA_DIR}/itemData.s"}
.include {"{GAME_DATA_DIR}/interactionData.s"}

.include {"{GAME_DATA_DIR}/treasureCollectionBehaviours.s"}
.include {"{GAME_DATA_DIR}/treasureDisplayData.s"}

oamData_714c:
	.db $10
	.db $c8 $38 $2e $0e
	.db $c8 $40 $30 $0e
	.db $c8 $48 $32 $0e
	.db $c8 $60 $34 $0f
	.db $c8 $68 $36 $0f
	.db $c8 $70 $38 $0f
	.db $d8 $78 $06 $2e
	.db $e8 $80 $00 $0d
	.db $e8 $78 $08 $0e
	.db $e0 $90 $00 $0d
	.db $d8 $a0 $00 $0d
	.db $e8 $30 $04 $0e
	.db $d8 $30 $06 $0e
	.db $f8 $28 $02 $0e
	.db $f0 $18 $00 $2d
	.db $e8 $08 $00 $2d

oamData_718d:
	.db $10
	.db $a8 $38 $12 $0a
	.db $b8 $38 $0e $0f
	.db $c8 $38 $0a $0f
	.db $a8 $70 $14 $0a
	.db $b8 $70 $10 $0a
	.db $c8 $70 $0c $0f
	.db $e8 $80 $00 $0d
	.db $d8 $78 $06 $2e
	.db $e8 $78 $08 $0e
	.db $e0 $90 $00 $0d
	.db $d8 $a0 $00 $0d
	.db $f8 $28 $02 $0e
	.db $f0 $18 $00 $2d
	.db $e8 $08 $00 $2d
	.db $d8 $30 $06 $0e
	.db $e8 $30 $08 $2e

oamData_71ce:
	.db $0a
	.db $50 $40 $40 $0b
	.db $50 $48 $42 $0b
	.db $50 $50 $44 $0b
	.db $50 $58 $46 $0b
	.db $50 $60 $48 $0b
	.db $50 $68 $4a $0b
	.db $70 $70 $3c $0c
	.db $60 $70 $3e $2c
	.db $70 $38 $3a $0c
	.db $60 $38 $3e $0c

oamData_71f7:
	.db $0a
	.db $10 $40 $22 $08
	.db $10 $68 $22 $28
	.db $60 $38 $16 $0c
	.db $70 $38 $1a $0c
	.db $60 $70 $18 $0c
	.db $70 $70 $1a $2c
	.db $40 $40 $1c $08
	.db $40 $68 $1e $08
	.db $50 $40 $20 $08
	.db $50 $68 $20 $28

oamData_7220:
	.db $0a
	.db $e0 $48 $24 $0b
	.db $e0 $60 $24 $2b
	.db $e0 $50 $26 $0b
	.db $e0 $58 $26 $2b
	.db $f0 $48 $28 $0b
	.db $f0 $60 $28 $2b
	.db $00 $48 $2a $0b
	.db $00 $60 $2a $2b
	.db $f8 $50 $2c $0b
	.db $f8 $58 $2c $2b

oamData_7249:
	.db $27
	.db $38 $38 $00 $01
	.db $38 $58 $02 $00
	.db $30 $48 $04 $00
	.db $30 $50 $06 $00
	.db $40 $48 $08 $00
	.db $58 $38 $0a $00
	.db $50 $40 $0c $02
	.db $50 $48 $0e $04
	.db $58 $50 $10 $03
	.db $60 $57 $12 $03
	.db $60 $5f $14 $03
	.db $60 $30 $16 $00
	.db $72 $38 $18 $00
	.db $70 $30 $1a $03
	.db $88 $28 $1c $00
	.db $3b $9a $1e $04
	.db $4b $9a $20 $04
	.db $58 $90 $22 $05
	.db $58 $98 $24 $05
	.db $22 $a0 $26 $06
	.db $22 $a8 $28 $06
	.db $32 $a0 $2a $06
	.db $32 $a8 $2c $06
	.db $12 $a0 $2e $06
	.db $12 $a8 $30 $06
	.db $12 $b0 $32 $06
	.db $6c $b0 $34 $03
	.db $70 $c0 $36 $01
	.db $80 $c0 $38 $05
	.db $90 $58 $3a $03
	.db $30 $90 $3c $00
	.db $90 $c0 $3e $05
	.db $90 $78 $40 $05
	.db $80 $70 $42 $05
	.db $80 $78 $44 $05
	.db $80 $88 $46 $05
	.db $90 $80 $48 $05
	.db $48 $50 $4a $02
	.db $60 $40 $4c $00


.include "object_code/ages/interactions/monkeyMain.s"
.include "object_code/ages/interactions/rabbitMain.s"
.include "object_code/ages/interactions/tuniNutMain.s"

.include "code/ages/garbage/bank3fEnd.s"

.ends
