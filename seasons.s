; Main file for Oracle of Seasons, US version

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
.include "include/musicMacros.s"

.include {"{BUILD_DIR}/textDefines.s"}


.BANK $00 SLOT 0
.ORG 0

	.include "code/bank0.s"


.BANK $01 SLOT 1
.ORG 0

	.include "code/bank1.s"


.BANK $02 SLOT 1
.ORG 0

	.include "code/bank2.s"


.BANK $03 SLOT 1
.ORG 0

	.include "code/bank3.s"

	; Note: There appears to be exactly one function call (in seasons) that performs a call from
	; this section to code in the "bank3.s" include above. For this reason we can't make this
	; section "superfree".
	 m_section_free Bank_3_Cutscenes NAMESPACE bank3Cutscenes
		.include "code/bank3Cutscenes.s"
		.include "code/seasons/cutscenes/endgameCutscenes.s"
		.include "code/seasons/cutscenes/pirateShipDeparting.s"
		.include "code/seasons/cutscenes/volcanoErupting.s"
		.include "code/seasons/cutscenes/linkedGameCutscenes.s"
		.include "code/seasons/cutscenes/introCutscenes.s"
	.ends


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
		.include "code/seasons/tileSubstitutions.s"
		.include {"{GAME_DATA_DIR}/singleTileChanges.s"}
		.include "code/seasons/roomSpecificTileChanges.s"
	.ends

	; The 2 sections to follow must be in the same bank. (Namespaces only differ because the
	; roomGfxChanges file is in a different bank in Ages.)
	 m_section_free roomGfxChanges NAMESPACE roomGfxChanges
		.include "code/seasons/roomGfxChanges.s"
	.ends
	 m_section_free Tileset_Loading_2 NAMESPACE tilesets
		.include "code/loadTilesToRam.s"
		.include "code/seasons/loadTilesetData.s"
	.ends

	; Must be in same bank as "code/bank4.s"
	 m_section_free Warp_Data NAMESPACE bank4
		.include {"{GAME_DATA_DIR}/warpDestinations.s"}
		.include {"{GAME_DATA_DIR}/warpSources.s"}
	.ends


.BANK $05 SLOT 1
.ORG 0

	 m_section_free Bank_5 NAMESPACE bank5
		.include "code/specialObjects.s"

		.include {"{GAME_DATA_DIR}/tile_properties/tileTypeMappings.s"}
		.include {"{GAME_DATA_DIR}/tile_properties/cliffTiles.s"}

		.include "object_code/seasons/specialObjects/subrosiaDanceLink.s"
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

	.include {"{GAME_DATA_DIR}/specialObjectAnimationData.s"}
	.include "object_code/seasons/specialObjects/companionCutscene.s"
	.include "object_code/seasons/specialObjects/linkInCutscene.s"
	.include {"{GAME_DATA_DIR}/signText.s"}
	.include {"{GAME_DATA_DIR}/tile_properties/breakableTiles.s"}

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
		.include "object_code/common/items/rickyTornado.s"
		.include "object_code/common/items/magnetBall.s"
		.include "object_code/common/items/rickyMooshAttack.s"
		.include "object_code/common/items/shovel.s"
		.include "object_code/seasons/items/rodOfSeasons.s"
		.include "object_code/common/items/minecartCollision.s"
		.include "object_code/common/items/slingshot.s"
		.include "object_code/seasons/items/magnetGloves.s"
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
	.ends


.BANK $08 SLOT 1
.ORG 0

m_section_free Interaction_Code_Group1 NAMESPACE commonInteractions1
	.include "object_code/common/interactions/breakTileDebris.s"
	.include "object_code/common/interactions/fallDownHole.s"
	.include "object_code/common/interactions/farore.s"
	.include "object_code/common/interactions/dungeonStuff.s"
	.include "object_code/common/interactions/pushblockTrigger.s"
	.include "object_code/common/interactions/pushblock.s"
	.include "object_code/common/interactions/minecart.s"
	.include "object_code/common/interactions/dungeonKeySprite.s"
	.include "object_code/common/interactions/overworldKeySprite.s"
	.include "object_code/common/interactions/faroresMemory.s"
	.include "object_code/seasons/interactions/rupeeRoomRupees.s" ; Unique to Seasons
	.include "object_code/common/interactions/doorController.s"
.ends

m_section_free Interaction_Code_Group2 NAMESPACE commonInteractions2
	.include "object_code/common/interactions/shopkeeper.s"
	.include "object_code/common/interactions/shopItem.s"
	.include "object_code/common/interactions/introSprites1.s"
	.include "object_code/common/interactions/seasonsFairy.s"
	.include "object_code/common/interactions/explosion.s"
.ends

m_section_free Seasons_Interactions_Bank08 NAMESPACE seasonsInteractionsBank08
	.include "object_code/seasons/interactions/usedRodOfSeasons.s"
	.include "object_code/seasons/interactions/specialWarp.s"
	.include "object_code/seasons/interactions/dungeonScript.s"
	.include "object_code/seasons/interactions/gnarledKeyhole.s"
	.include "object_code/seasons/interactions/makuCutscenes.s"
	.include "object_code/seasons/interactions/seasonSpiritsScripts.s"
	.include "object_code/seasons/interactions/miscNpcs.s"
	.include "object_code/seasons/interactions/mittensAndOwner.s"
	.include "object_code/seasons/interactions/sokra.s"
	.include "object_code/common/interactions/bipin.s"
	.include "object_code/seasons/interactions/bird.s"
	.include "object_code/common/interactions/blossom.s"
	.include "object_code/seasons/interactions/fickleGirl.s"
	.include "object_code/seasons/interactions/subrosian.s"
	.include "object_code/seasons/interactions/datingRosaEvent.s"
	.include "object_code/seasons/interactions/subrosianWithBuckets.s"
	.include "object_code/seasons/interactions/subrosianSmiths.s"
	.include "object_code/common/interactions/child.s"
	.include "object_code/seasons/interactions/goron.s"
	.include "object_code/seasons/interactions/miscBoyNpcs.s"
	.include "object_code/seasons/interactions/piratian.s"
	.include "object_code/seasons/interactions/pirateHouseSubrosian.s"
	.include "object_code/common/interactions/syrup.s"
	.include "object_code/seasons/interactions/zelda.s"
	.include "object_code/seasons/interactions/talon.s"
	.include "object_code/seasons/interactions/makuLeaf.s"
	.include "object_code/common/interactions/syrupCucco.s"
	.include "object_code/seasons/interactions/d1RisingStones.s"
	.include "object_code/seasons/interactions/miscStatusObjects.s"
	.include "object_code/seasons/interactions/pirateSkull.s"
	.include "object_code/seasons/interactions/dinDancingEvent.s"
	.include "object_code/seasons/interactions/dinImprisonedEvent.s"
	.include "object_code/seasons/interactions/smallVolcano.s"
	.include "object_code/seasons/interactions/biggoron.s"
	.include "object_code/seasons/interactions/headSmelter.s"
	.include "object_code/seasons/interactions/subrosianAtD8Items.s"
	.include "object_code/seasons/interactions/subrosianAtD8.s"
	.include "object_code/seasons/interactions/ingo.s"
	.include "object_code/seasons/interactions/guruguru.s"
	.include "object_code/seasons/interactions/lostWoodsSword.s"
	.include "object_code/seasons/interactions/blainoScript.s"
	.include "object_code/seasons/interactions/lostWoodsDekuScrub.s"
	.include "object_code/seasons/interactions/lavaSoupSubrosian.s"
	.include "object_code/seasons/interactions/tradeItem.s"
.ends


.BANK $09 SLOT 1
.ORG 0

	.include "object_code/common/interactions/treasure.s"

m_section_free Interaction_Code_Group3 NAMESPACE commonInteractions3
	.include "object_code/common/interactions/bombFlower.s"
	.include "object_code/common/interactions/switchTileToggler.s"
	.include "object_code/common/interactions/movingPlatform.s"
	.include "object_code/common/interactions/roller.s"
	.include "object_code/common/interactions/spinner.s"
	.include "object_code/common/interactions/minibossPortal.s"
	.include "object_code/common/interactions/essence.s"
.ends

m_section_free Seasons_Interactions_Bank09 NAMESPACE seasonsInteractionsBank09
	.include "object_code/seasons/interactions/quicksand.s"
	.include "object_code/common/interactions/companionSpawner.s"
	.include "object_code/seasons/interactions/unicornsCave4ChestPuzzle.s"
	.include "object_code/seasons/interactions/unicornsCaveReverseMovingArmos.s"
	.include "object_code/seasons/interactions/unicornsCaveFallingMagnetBall.s"
	.include "object_code/seasons/interactions/65.s"
	.include "object_code/seasons/interactions/explorersCrypt4ArmosButtonPuzzle.s"
	.include "object_code/seasons/interactions/swordShieldMazeArmosPatternPuzzle.s"
	.include "object_code/seasons/interactions/swordShieldMazeGrabbableIce.s"
	.include "object_code/seasons/interactions/swordShieldMazeFreezingLavaEvent.s"
	.include "object_code/seasons/interactions/danceHallMinigame.s"
	.include "object_code/seasons/interactions/miscellaneous1.s"
	.include "object_code/seasons/interactions/subrosiansHiding.s"
	.include "object_code/seasons/interactions/stealingFeather.s"
	.include "object_code/seasons/interactions/holly.s"
	.include "object_code/seasons/interactions/companionScripts.s"
	.include "object_code/seasons/interactions/blaino.s"
	.include "object_code/seasons/interactions/animalMoblinBullies.s"
	.include "object_code/seasons/interactions/74.s"
	.include "object_code/seasons/interactions/75.s"
	.include "object_code/seasons/interactions/sunkenCityBullies.s"
	.include "object_code/seasons/interactions/77.s"
	.include "object_code/seasons/interactions/magnetSpinner.s"
	.include "object_code/seasons/interactions/trampoline.s"
	.include "object_code/seasons/interactions/fickleOldMan.s"
	.include "object_code/seasons/interactions/subrosianShop.s"
	.include "object_code/seasons/interactions/horonDog.s"
	.include "object_code/seasons/interactions/ballThrownToDog.s"
	.include "object_code/seasons/interactions/sparkle.s"
	.include "object_code/seasons/interactions/introSceneMusic.s"
	.include "object_code/seasons/interactions/templeSinkingExplosion.s"
	.include "object_code/seasons/interactions/makuTree.s"
	.include "object_code/seasons/interactions/88.s"
.ends


.BANK $0a SLOT 1
.ORG 0

m_section_free Interaction_Code_Group4 NAMESPACE commonInteractions4
	.include "object_code/common/interactions/vasu.s"
	.include "object_code/common/interactions/bubble.s"
.ends

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

m_section_free Seasons_Interactions_Bank0a NAMESPACE seasonsInteractionsBank0a
	.include "object_code/seasons/interactions/sunkenCityNpcs.s"
	.include "object_code/seasons/interactions/flyingRooster.s"
	.include "object_code/seasons/interactions/8e.s"
	.include "object_code/seasons/interactions/oldManWithJewel.s"
	.include "object_code/seasons/interactions/jewelHelper.s"
	.include "object_code/seasons/interactions/jewel.s"
	.include "object_code/seasons/interactions/makuSeed.s"
	.include "object_code/seasons/interactions/ghastlyDoll.s"
	.include "object_code/seasons/interactions/kingMoblin.s"
	.include "object_code/seasons/interactions/moblin.s"
	.include "object_code/seasons/interactions/97.s"
	.include "object_code/seasons/interactions/oldManWithRupees.s"
	.include "object_code/seasons/interactions/9a.s"
	.include "object_code/seasons/interactions/9b.s"
	.include "object_code/seasons/interactions/springBloomFlower.s"
	.include "object_code/seasons/interactions/impa.s"
	.include "object_code/seasons/interactions/samasaDesertGate.s"
	.include "object_code/common/interactions/movingSidescrollPlatform.s"
	.include "object_code/common/interactions/movingSidescrollConveyor.s"
	.include "object_code/seasons/interactions/disappearingSidescrollPlatform.s"
	.include "object_code/seasons/interactions/subrosianSmithy.s"
	.include "object_code/seasons/interactions/din.s"
	.include "object_code/seasons/interactions/dinsCrystalFading.s"
	.include "object_code/common/interactions/endgameCutsceneBipsomFamily.s"
	.include "object_code/seasons/interactions/a8.s"
	.include "object_code/seasons/interactions/a9.s"
	.include "object_code/seasons/interactions/aa.s"
	.include "object_code/seasons/interactions/moblinKeepScenes.s"
	.include "object_code/seasons/interactions/ad.s"
	.include "object_code/common/interactions/creditsTextHorizontal.s"
	.include "object_code/common/interactions/creditsTextVertical.s"
	.include "object_code/common/interactions/twinrovaFlame.s"
	.include "object_code/seasons/interactions/shipPiratian.s"
	.include "object_code/seasons/interactions/linkedCutscene.s"
	.include "object_code/seasons/interactions/b4.s"
	.include "object_code/common/interactions/finalDungeonEnergy.s"
	.include "object_code/seasons/interactions/ambi.s"
	.include "object_code/common/interactions/horonDogCredits.s"
	.include "object_code/seasons/interactions/ba.s"
	.include "object_code/seasons/interactions/bb.s"
	.include "object_code/seasons/interactions/bc_bd_be.s"
	.include "object_code/seasons/interactions/bf.s"
	.include "object_code/common/interactions/c1.s"
	.include "object_code/seasons/interactions/mayorsHouseUnlinkedGirl.s"
	.include "object_code/seasons/interactions/zeldaKidnappedRoom.s"
	.include "object_code/seasons/interactions/zeldaVillagersRoom.s"
	.include "object_code/seasons/interactions/d4HolesFloortrapRoom.s"
	.include "object_code/seasons/interactions/herosCaveSwordChest.s"
.ends


.BANK $0b SLOT 1
.ORG 0

	 m_section_free Scripts namespace mainScripts
		.include "code/scripting.s"
		.include "scripts/seasons/scripts.s"
	.ends


.BANK $0c SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0c NAMESPACE bank0c

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

	.include "object_code/seasons/enemies/rollingSpikeTrap.s"
	.include "object_code/seasons/enemies/pokey.s"
	.include "object_code/seasons/enemies/ironMask.s"
.ends

m_section_superfree Enemy_Animations
	.include {"{GAME_DATA_DIR}/enemyAnimations.s"}
.ends

.BANK $0d SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0d NAMESPACE bank0d

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

	.include "object_code/seasons/enemies/magunesu.s"
	.include "object_code/seasons/enemies/unusedTemplate.s"
	.include "object_code/seasons/enemies/gohmaGel.s"
	.include "object_code/seasons/enemies/mothulaChild.s"
	.include "object_code/seasons/enemies/blaino.s"
	.include "object_code/seasons/enemies/miniDigdogger.s"
	.include "object_code/seasons/enemies/makuTreeBubble.s"
	.include "object_code/seasons/enemies/sandPuff.s"
	.include "object_code/seasons/enemies/wallFlameShooter.s"
	.include "object_code/seasons/enemies/blainosGloves.s"

	.include "code/objectMovementScript.s"
	.include {"{GAME_DATA_DIR}/movingSidescrollPlatform.s"}

.ends


.BANK $0e SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0e NAMESPACE bank0e

	.include "object_code/common/enemies/commonCode.s"
	.include "object_code/common/enemies/commonBossCode.s"

	.include "object_code/seasons/enemies/brotherGoriyas.s"
	.include "object_code/seasons/enemies/facade.s"
	.include "object_code/seasons/enemies/omuai.s"
	.include "object_code/seasons/enemies/agunima.s"
	.include "object_code/seasons/enemies/syger.s"
	.include "object_code/common/enemies/vire.s"
	.include "object_code/seasons/enemies/poeSister2.s"
	.include "object_code/seasons/enemies/poeSister1.s"
	.include "object_code/seasons/enemies/frypolar.s"
	.include "object_code/seasons/enemies/aquamentus.s"
	.include "object_code/seasons/enemies/dodongo.s"
	.include "object_code/seasons/enemies/mothula.s"
	.include "object_code/seasons/enemies/gohma.s"
	.include "object_code/seasons/enemies/digdogger.s"
	.include "object_code/seasons/enemies/manhandla.s"
	.include "object_code/seasons/enemies/medusaHead.s"

.ends

.BANK $0f SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0f NAMESPACE bank0f

	.include "object_code/common/enemies/commonCode.s"
	.include "object_code/common/enemies/commonBossCode.s"

	.include "object_code/common/enemies/mergedTwinrova.s"
	.include "object_code/common/enemies/twinrova.s"
	.include "object_code/common/enemies/ganon.s"
	.include "object_code/common/enemies/none.s"

	.include "object_code/seasons/enemies/generalOnox.s"
	.include "object_code/seasons/enemies/dragonOnox.s"
	.include "object_code/seasons/enemies/gleeok.s"
	.include "object_code/seasons/enemies/kingMoblin.s"

	.include "code/seasons/cutscenes/transitionToDragonOnox.s"

.ends

.ifdef BUILD_VANILLA
	.REPT $87
	.db $0f ; emptyfill (TODO: replace this with ORGA, update md5 for emptyfill-0)
	.ENDR
.endif

m_section_free Interaction_Code_Group6 NAMESPACE commonInteractions6
	.include "object_code/common/interactions/businessScrub.s"
	.include "object_code/common/interactions/cf.s"
	.include "object_code/common/interactions/companionTutorial.s"
	.include "object_code/common/interactions/gameCompleteDialog.s"
	.include "object_code/common/interactions/titlescreenClouds.s"
	.include "object_code/common/interactions/introBird.s"
	.include "object_code/common/interactions/linkShip.s"
.ends

m_section_free Seasons_Interactions_Bank0f NAMESPACE seasonsInteractionsBank0f
	.include "object_code/seasons/interactions/boomerangSubrosian.s"
	.include "object_code/seasons/interactions/boomerang.s"
	.include "object_code/seasons/interactions/troy.s"
	.include "object_code/seasons/interactions/linkedGameGhini.s"
	.include "object_code/seasons/interactions/goldenCaveSubrosian.s"
	.include "object_code/seasons/interactions/linkedMasterDiver.s"
	.include "object_code/seasons/interactions/greatFairy.s"
	.include "object_code/seasons/interactions/dekuScrub.s"
	.include "object_code/seasons/interactions/d7.s"
.ends


.BANK $10 SLOT 1
.ORG 0

	.define PART_BANK $10
	.export PART_BANK

m_section_free Part_Code NAMESPACE partCode
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
.ends

	.include "code/roomInitialization.s"

m_section_free Part_Code_2 NAMESPACE partCode
	.include "code/updateParts.s"
	.include "data/partCodeTable.s"

	.include "object_code/seasons/parts/holesFloortrap.s"
	.include "object_code/seasons/parts/slingshotEyeStatue.s"
	.include "object_code/seasons/parts/16.s"
	.include "object_code/seasons/parts/shootingDragonHead.s"
	.include "object_code/seasons/parts/arrowShooter.s"
	.include "object_code/seasons/parts/wallFlameShooterFlames.s"
	.include "object_code/seasons/parts/buriedMoldorm.s"
	.include "object_code/seasons/parts/kingMoblinsCannons.s"
	.include "object_code/seasons/parts/2e.s"
	.include "object_code/seasons/parts/2f.s"
	.include "object_code/seasons/parts/poppableBubble.s"
	.include "object_code/seasons/parts/33.s"
	.include "object_code/seasons/parts/38.s"
	.include "object_code/seasons/parts/39.s"
	.include "object_code/common/parts/vireProjectile.s"
	.include "object_code/seasons/parts/3b.s"
	.include "object_code/seasons/parts/poeSisterFlame.s"
	.include "object_code/seasons/parts/3d.s"
	.include "object_code/seasons/parts/3e.s"
	.include "object_code/seasons/parts/kingMoblinBomb.s"
	.include "object_code/seasons/parts/aquamentusProjectile.s"
	.include "object_code/seasons/parts/dodongoFireball.s"
	.include "object_code/seasons/parts/mothulaProjectile2.s"
	.include "object_code/seasons/parts/43.s"
	.include "object_code/seasons/parts/44.s"
	.include "object_code/seasons/parts/45.s"
	.include "object_code/seasons/parts/46.s"
	.include "object_code/seasons/parts/47.s"
	.include "object_code/seasons/parts/48.s"
	.include "object_code/seasons/parts/49.s"
	.include "object_code/seasons/parts/4a.s"
	.include "object_code/seasons/parts/dinCrystal.s"
.ends


.BANK $11 SLOT 1
.ORG 0

	.include "code/objectLoading.s"

m_section_free Objects_2 namespace objectData
	.include "objects/seasons/pointers.s"
	.include "objects/seasons/mainData.s"
	.include "objects/seasons/extraData3.s"
.ends


.BANK $12 SLOT 1
.ORG 0

	.define BASE_OAM_DATA_BANK $12
	.export BASE_OAM_DATA_BANK

	.include {"{GAME_DATA_DIR}/specialObjectOamData.s"}
	.include "data/itemOamData.s"
	.include {"{GAME_DATA_DIR}/enemyOamData.s"}


.BANK $13 SLOT 1
.ORG 0

m_section_superfree Terrain_Effects NAMESPACE terrainEffects
	.include "data/terrainEffects.s"
.ends

	.include {"{GAME_DATA_DIR}/interactionOamData.s"}
	.include {"{GAME_DATA_DIR}/partOamData.s"}


.BANK $14 SLOT 1
.ORG 0

	.include {"{GAME_DATA_DIR}/data_4556.s"}

	; TODO: "SIMPLE_SCRIPT_BANK" define should be tied to this section somehow
	 m_section_free Scripts2 NAMESPACE scripts2
		.include "scripts/seasons/scripts2.s"
	.ends

	.include {"{GAME_DATA_DIR}/interactionAnimations.s"}


.BANK $15 SLOT 1
.ORG 0

	.include "code/serialFunctions.s"

	.include "scripts/common/scriptHelper.s"

m_section_free Interaction_Code_Group7 NAMESPACE commonInteractions7
	.include "object_code/common/interactions/faroreGiveItem.s"
	.include "object_code/common/interactions/zeldaApproachTrigger.s"
.ends

m_section_free Interaction_Code_Group8 NAMESPACE commonInteractions8
	.include "object_code/common/interactions/eraOrSeasonInfo.s"
	.include "object_code/common/interactions/statueEyeball.s"
	.include "object_code/common/interactions/ringHelpBook.s"
.ends


oamData_15_4da3:
	.db $1a
	.db $40 $d0 $00 $02
	.db $50 $e8 $02 $02
	.db $f8 $50 $08 $06
	.db $f8 $58 $0a $06
	.db $f8 $60 $0c $06
	.db $f8 $68 $0e $06
	.db $40 $10 $10 $07
	.db $50 $18 $12 $07
	.db $50 $28 $14 $07
	.db $50 $30 $16 $07
	.db $50 $38 $1e $00
	.db $40 $20 $18 $07
	.db $38 $28 $1a $07
	.db $28 $2b $1c $07
	.db $40 $38 $20 $07
	.db $30 $38 $22 $00
	.db $30 $30 $24 $07
	.db $10 $28 $26 $01
	.db $10 $30 $28 $01
	.db $10 $38 $2a $01
	.db $10 $40 $2c $01
	.db $00 $40 $2e $01
	.db $2b $02 $30 $02
	.db $30 $50 $32 $00
	.db $30 $58 $34 $00
	.db $1d $55 $36 $00


oamData_15_4e0c:
	.db $0a
	.db $46 $4a $88 $03
	.db $46 $52 $8a $03
	.db $49 $4c $80 $02
	.db $49 $54 $82 $02
	.db $47 $42 $84 $03
	.db $47 $4a $86 $03
	.db $39 $4e $90 $03
	.db $43 $59 $8c $03
	.db $39 $46 $8e $03
	.db $3b $3c $92 $03


	.include "code/staticObjects.s"
	.include {"{GAME_DATA_DIR}/staticDungeonObjects.s"}
	.include {"{GAME_DATA_DIR}/chestData.s"}
	.include {"{GAME_DATA_DIR}/treasureObjectData.s"}

	m_section_free Bank_15_3 NAMESPACE scriptHelp
		.include "scripts/seasons/scriptHelper.s"
	.ends

m_section_free Seasons_Interactions_Bank15 NAMESPACE seasonsInteractionsBank15
	.include "object_code/seasons/interactions/linkedFountainLady.s"
	.include "object_code/seasons/interactions/linkedSecredGivers.s"
	.include "object_code/seasons/interactions/miscPuzzles.s"
	.include "object_code/seasons/interactions/goldenBeastOldMan.s"
	.include "object_code/seasons/interactions/makuSeedAndEssences.s"
	.include "object_code/common/interactions/nayruRalphCredits.s"
	.include "object_code/seasons/interactions/portalSpawner.s"
	.include "object_code/seasons/interactions/vire.s"
	.include "object_code/seasons/interactions/linkedHerosCaveOldMan.s"
	.include "object_code/seasons/interactions/getRodOfSeasons.s"
	.include "object_code/seasons/interactions/loneZora.s"
.ends

	.include {"{GAME_DATA_DIR}/partAnimations.s"}


.BANK $16 SLOT 1
.ORG 0

	.include {"{GAME_DATA_DIR}/paletteData.s"}
	.include {"{GAME_DATA_DIR}/tilesetCollisions.s"}
	.include {"{GAME_DATA_DIR}/smallRoomLayoutTables.s"}


.BANK $17 SLOT 1
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
.ends

.BANK $18 SLOT 1
.ORG 0

	.include {"{GAME_DATA_DIR}/largeRoomLayoutTables.s"}

	m_GfxDataSimple gfx_animations_1
	m_GfxDataSimple gfx_animations_2
	m_GfxDataSimple gfx_animations_3
	m_GfxDataSimple gfx_063940

	; Compressed graphics file, for some reason doesn't go in gfxDataMain.s.
	m_GfxDataSimple spr_credits_sprites_2


.BANK $19 SLOT 1
.ORG 0

m_section_superfree Tile_mappings
	.include {"{GAME_DATA_DIR}/tilesetMappings.s"}
.ends


.BANK $1a SLOT 1
.ORG 0
	.include "data/gfxDataBank1a.s"


.BANK $1b SLOT 1
.ORG 0
	.include "data/gfxDataBank1b.s"


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
	.include "object_code/common/interactions/faroreMakeChest.s"

	.include {"{GAME_DATA_DIR}/objectGfxHeaders.s"}
	.include {"{GAME_DATA_DIR}/treeGfxHeaders.s"}

	.include {"{GAME_DATA_DIR}/enemyData.s"}
	.include {"{GAME_DATA_DIR}/partData.s"}
	.include {"{GAME_DATA_DIR}/itemData.s"}
	.include {"{GAME_DATA_DIR}/interactionData.s"}

	.include {"{GAME_DATA_DIR}/treasureCollectionBehaviours.s"}
	.include {"{GAME_DATA_DIR}/treasureDisplayData.s"}

.ends
