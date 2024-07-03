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
		.include {"{GAME_DATA_DIR}/warpData.s"}
	.ends


.BANK $05 SLOT 1
.ORG 0

	 m_section_free Bank_5 NAMESPACE bank5
		.include "code/bank5.s"

		.include {"{GAME_DATA_DIR}/tile_properties/tileTypeMappings.s"}
		.include {"{GAME_DATA_DIR}/tile_properties/cliffTiles.s"}

		.include "code/seasons/subrosiaDanceLink.s"
	.ends

.BANK $06 SLOT 1
.ORG 0

 m_section_free Bank_6 NAMESPACE bank6

	.include "code/interactableTiles.s"
	.include "code/specialObjectAnimationsAndDamage.s"
	.include "code/breakableTiles.s"

	.include "code/items/parentItemUsage.s"

	.include "code/items/shieldParent.s"
	.include "code/items/otherSwordsParent.s"
	.include "code/items/switchHookParent.s"
	.include "code/items/caneOfSomariaParent.s"
	.include "code/items/swordParent.s"
	.include "code/items/harpFluteParent.s"
	.include "code/items/seedsParent.s"
	.include "code/items/shovelParent.s"
	.include "code/items/boomerangParent.s"
	.include "code/items/bombsBraceletParent.s"
	.include "code/items/featherParent.s"
	.include "code/items/magnetGloveParent.s"

	.include "code/items/parentItemCommon.s"
	.include {"{GAME_DATA_DIR}/itemUsageTables.s"}

	.include "object_code/common/specialObjects/minecart.s"

	.include {"{GAME_DATA_DIR}/specialObjectAnimationData.s"}
	.include "code/seasons/cutscenes/companionCutscenes.s"
	.include "code/seasons/cutscenes/linkCutscenes.s"
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

		.include {"{GAME_DATA_DIR}/tile_properties/conveyorItemTiles.s"}
		.include {"{GAME_DATA_DIR}/tile_properties/itemPassableTiles.s"}
		.include "code/itemCodes.s"
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
	.include "object_code/common/interactionCode/breakTileDebris.s"
	.include "object_code/common/interactionCode/fallDownHole.s"
	.include "object_code/common/interactionCode/farore.s"
	.include "object_code/common/interactionCode/dungeonStuff.s"
	.include "object_code/common/interactionCode/pushblockTrigger.s"
	.include "object_code/common/interactionCode/pushblock.s"
	.include "object_code/common/interactionCode/minecart.s"
	.include "object_code/common/interactionCode/dungeonKeySprite.s"
	.include "object_code/common/interactionCode/overworldKeySprite.s"
	.include "object_code/common/interactionCode/faroresMemory.s"
	.include "object_code/seasons/interactionCode/rupeeRoomRupees.s" ; Unique to Seasons
	.include "object_code/common/interactionCode/doorController.s"
.ends

 m_section_free Interaction_Code_Group2 NAMESPACE commonInteractions2
	.include "object_code/common/interactionCode/shopkeeper.s"
	.include "object_code/common/interactionCode/shopItem.s"
	.include "object_code/common/interactionCode/introSprites1.s"
	.include "object_code/common/interactionCode/seasonsFairy.s"
	.include "object_code/common/interactionCode/explosion.s"
.ends

 m_section_free Seasons_Interactions_Bank08 NAMESPACE seasonsInteractionsBank08
	.include "object_code/seasons/interactionCode/usedRodOfSeasons.s"
	.include "object_code/seasons/interactionCode/specialWarp.s"
	.include "object_code/seasons/interactionCode/dungeonScript.s"
	.include "object_code/seasons/interactionCode/gnarledKeyhole.s"
	.include "object_code/seasons/interactionCode/makuCutscenes.s"
	.include "object_code/seasons/interactionCode/seasonSpiritsScripts.s"
	.include "object_code/seasons/interactionCode/miscNpcs.s"
	.include "object_code/seasons/interactionCode/mittensAndOwner.s"
	.include "object_code/seasons/interactionCode/sokra.s"
	.include "object_code/seasons/interactionCode/bipin.s"
	.include "object_code/seasons/interactionCode/bird.s"
	.include "object_code/seasons/interactionCode/blossom.s"
	.include "object_code/seasons/interactionCode/fickleGirl.s"
	.include "object_code/seasons/interactionCode/subrosian.s"
	.include "object_code/seasons/interactionCode/datingRosaEvent.s"
	.include "object_code/seasons/interactionCode/subrosianWithBuckets.s"
	.include "object_code/seasons/interactionCode/subrosianSmiths.s"
	.include "object_code/seasons/interactionCode/child.s"
	.include "object_code/seasons/interactionCode/goron.s"
	.include "object_code/seasons/interactionCode/miscBoyNpcs.s"
	.include "object_code/seasons/interactionCode/piratian.s"
	.include "object_code/seasons/interactionCode/pirateHouseSubrosian.s"
	.include "object_code/seasons/interactionCode/syrup.s"
	.include "object_code/seasons/interactionCode/zelda.s"
	.include "object_code/seasons/interactionCode/talon.s"
	.include "object_code/seasons/interactionCode/makuLeaf.s"
	.include "object_code/seasons/interactionCode/syrupCucco.s"
	.include "object_code/seasons/interactionCode/d1RisingStones.s"
	.include "object_code/seasons/interactionCode/miscStatusObjects.s"
	.include "object_code/seasons/interactionCode/pirateSkull.s"
	.include "object_code/seasons/interactionCode/dinDancingEvent.s"
	.include "object_code/seasons/interactionCode/dinImprisonedEvent.s"
	.include "object_code/seasons/interactionCode/smallVolcano.s"
	.include "object_code/seasons/interactionCode/biggoron.s"
	.include "object_code/seasons/interactionCode/headSmelter.s"
	.include "object_code/seasons/interactionCode/subrosianAtD8Items.s"
	.include "object_code/seasons/interactionCode/subrosianAtD8.s"
	.include "object_code/seasons/interactionCode/ingo.s"
	.include "object_code/seasons/interactionCode/guruguru.s"
	.include "object_code/seasons/interactionCode/lostWoodsSword.s"
	.include "object_code/seasons/interactionCode/blainoScript.s"
	.include "object_code/seasons/interactionCode/lostWoodsDekuScrub.s"
	.include "object_code/seasons/interactionCode/lavaSoupSubrosian.s"
	.include "object_code/seasons/interactionCode/tradeItem.s"
.ends


.BANK $09 SLOT 1
.ORG 0

	.include "object_code/common/interactionCode/treasure.s"

 m_section_free Interaction_Code_Group3 NAMESPACE commonInteractions3
	.include "object_code/common/interactionCode/bombFlower.s"
	.include "object_code/common/interactionCode/switchTileToggler.s"
	.include "object_code/common/interactionCode/movingPlatform.s"
	.include "object_code/common/interactionCode/roller.s"
	.include "object_code/common/interactionCode/spinner.s"
	.include "object_code/common/interactionCode/minibossPortal.s"
	.include "object_code/common/interactionCode/essence.s"
.ends

 m_section_free Seasons_Interactions_Bank09 NAMESPACE seasonsInteractionsBank09
	.include "object_code/seasons/interactionCode/quicksand.s"
	.include "object_code/seasons/interactionCode/unicornsCave4ChestPuzzle.s"
	.include "object_code/seasons/interactionCode/unicornsCaveReverseMovingArmos.s"
	.include "object_code/seasons/interactionCode/unicornsCaveFallingMagnetBall.s"
	.include "object_code/seasons/interactionCode/65.s"
	.include "object_code/seasons/interactionCode/explorersCrypt4ArmosButtonPuzzle.s"
	.include "object_code/seasons/interactionCode/swordShieldMazeArmosPatternPuzzle.s"
	.include "object_code/seasons/interactionCode/swordShieldMazeGrabbableIce.s"
	.include "object_code/seasons/interactionCode/swordShieldMazeFreezingLavaEvent.s"
	.include "object_code/seasons/interactionCode/danceHallMinigame.s"
	.include "object_code/seasons/interactionCode/miscellaneous1.s"
	.include "object_code/seasons/interactionCode/subrosiansHiding.s"
	.include "object_code/seasons/interactionCode/stealingFeather.s"
	.include "object_code/seasons/interactionCode/holly.s"
	.include "object_code/seasons/interactionCode/companionScripts.s"
	.include "object_code/seasons/interactionCode/blaino.s"
	.include "object_code/seasons/interactionCode/animalMoblinBullies.s"
	.include "object_code/seasons/interactionCode/74.s"
	.include "object_code/seasons/interactionCode/75.s"
	.include "object_code/seasons/interactionCode/sunkenCityBullies.s"
	.include "object_code/seasons/interactionCode/77.s"
	.include "object_code/seasons/interactionCode/magnetSpinner.s"
	.include "object_code/seasons/interactionCode/trampoline.s"
	.include "object_code/seasons/interactionCode/fickleOldMan.s"
	.include "object_code/seasons/interactionCode/subrosianShop.s"
	.include "object_code/seasons/interactionCode/dogPlayingWithBoy.s"
	.include "object_code/seasons/interactionCode/ballThrownToDog.s"
	.include "object_code/seasons/interactionCode/sparkle.s"
	.include "object_code/seasons/interactionCode/introSceneMusic.s"
	.include "object_code/seasons/interactionCode/templeSinkingExplosion.s"
	.include "object_code/seasons/interactionCode/makuTree.s"
.ends


.BANK $0a SLOT 1
.ORG 0

 m_section_free Interaction_Code_Group4 NAMESPACE commonInteractions4
	.include "object_code/common/interactionCode/vasu.s"
	.include "object_code/common/interactionCode/bubble.s"
.ends

 m_section_free Interaction_Code_Group5 NAMESPACE commonInteractions5
	.include "object_code/common/interactionCode/woodenTunnel.s"
	.include "object_code/common/interactionCode/exclamationMark.s"
	.include "object_code/common/interactionCode/floatingImage.s"
	.include "object_code/common/interactionCode/bipinBlossomFamilySpawner.s"
	.include "object_code/common/interactionCode/gashaSpot.s"
	.include "object_code/common/interactionCode/kissHeart.s"
	.include "object_code/common/interactionCode/banana.s"
	.include "object_code/common/interactionCode/createObjectAtEachTileindex.s"
.ends

 m_section_free Seasons_Interactions_Bank0a NAMESPACE seasonsInteractionsBank0a
	.include "object_code/seasons/interactionCode/sunkenCityNpcs.s"
	.include "object_code/seasons/interactionCode/flyingRooster.s"
	.include "object_code/seasons/interactionCode/8e.s"
	.include "object_code/seasons/interactionCode/oldManWithJewel.s"
	.include "object_code/seasons/interactionCode/jewelHelper.s"
	.include "object_code/seasons/interactionCode/jewel.s"
	.include "object_code/seasons/interactionCode/makuSeed.s"
	.include "object_code/seasons/interactionCode/ghastlyDoll.s"
	.include "object_code/seasons/interactionCode/kingMoblin.s"
	.include "object_code/seasons/interactionCode/moblin.s"
	.include "object_code/seasons/interactionCode/97.s"
	.include "object_code/seasons/interactionCode/oldManWithRupees.s"
	.include "object_code/seasons/interactionCode/9a.s"
	.include "object_code/seasons/interactionCode/9b.s"
	.include "object_code/seasons/interactionCode/springBloomFlower.s"
	.include "object_code/seasons/interactionCode/impa.s"
	.include "object_code/seasons/interactionCode/samasaDesertGate.s"
	.include "object_code/seasons/interactionCode/movingSidescrollPlatform.s"
	.include "object_code/seasons/interactionCode/movingSidescrollConveyor.s"
	.include "object_code/seasons/interactionCode/disappearingSidescrollPlatform.s"
	.include "object_code/seasons/interactionCode/subrosianSmithy.s"
	.include "object_code/seasons/interactionCode/din.s"
	.include "object_code/seasons/interactionCode/dinsCrystalFading.s"
	.include "object_code/seasons/interactionCode/endgameCutsceneBipsomFamily.s"
	.include "object_code/seasons/interactionCode/a8.s"
	.include "object_code/seasons/interactionCode/a9.s"
	.include "object_code/seasons/interactionCode/aa.s"
	.include "object_code/seasons/interactionCode/moblinKeepScenes.s"
	.include "object_code/seasons/interactionCode/ad.s"
	.include "object_code/seasons/interactionCode/creditsTextHorizontal.s"
	.include "object_code/seasons/interactionCode/af.s"
	.include "object_code/seasons/interactionCode/twinrovaFlame.s"
	.include "object_code/seasons/interactionCode/shipPiratian.s"
	.include "object_code/seasons/interactionCode/linkedCutscene.s"
	.include "object_code/seasons/interactionCode/b4.s"
	.include "object_code/seasons/interactionCode/b5.s"
	.include "object_code/seasons/interactionCode/ambi.s"
	.include "object_code/seasons/interactionCode/b9.s"
	.include "object_code/seasons/interactionCode/ba.s"
	.include "object_code/seasons/interactionCode/bb.s"
	.include "object_code/seasons/interactionCode/bc_bd_be.s"
	.include "object_code/seasons/interactionCode/bf.s"
	.include "object_code/seasons/interactionCode/c1.s"
	.include "object_code/seasons/interactionCode/mayorsHouseUnlinkedGirl.s"
	.include "object_code/seasons/interactionCode/zeldaKidnappedRoom.s"
	.include "object_code/seasons/interactionCode/zeldaVillagersRoom.s"
	.include "object_code/seasons/interactionCode/d4HolesFloortrapRoom.s"
	.include "object_code/seasons/interactionCode/herosCaveSwordChest.s"
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

	.include "code/enemyCommon.s"

	.include "object_code/common/enemyCode/riverZora.s"
	.include "object_code/common/enemyCode/octorok.s"
	.include "object_code/common/enemyCode/boomerangMoblin.s"
	.include "object_code/common/enemyCode/leever.s"
	.include "object_code/common/enemyCode/moblinsAndShroudedStalfos.s"
	.include "object_code/common/enemyCode/arrowDarknut.s"
	.include "object_code/common/enemyCode/lynel.s"
	.include "object_code/common/enemyCode/bladeAndFlameTrap.s"
	.include "object_code/common/enemyCode/rope.s"
	.include "object_code/common/enemyCode/gibdo.s"
	.include "object_code/common/enemyCode/spark.s"
	.include "object_code/common/enemyCode/whisp.s"
	.include "object_code/common/enemyCode/spikedBeetle.s"
	.include "object_code/common/enemyCode/bubble.s"
	.include "object_code/common/enemyCode/beamos.s"
	.include "object_code/common/enemyCode/ghini.s"
	.include "object_code/common/enemyCode/buzzblob.s"
	.include "object_code/common/enemyCode/sandCrab.s"
	.include "object_code/common/enemyCode/spinyBeetle.s"
	.include "object_code/common/enemyCode/armos.s"
	.include "object_code/common/enemyCode/piranha.s"
	.include "object_code/common/enemyCode/polsVoice.s"
	.include "object_code/common/enemyCode/likelike.s"
	.include "object_code/common/enemyCode/gopongaFlower.s"
	.include "object_code/common/enemyCode/dekuScrub.s"
	.include "object_code/common/enemyCode/wallmaster.s"
	.include "object_code/common/enemyCode/podoboo.s"
	.include "object_code/common/enemyCode/giantBladeTrap.s"
	.include "object_code/common/enemyCode/cheepcheep.s"
	.include "object_code/common/enemyCode/podobooTower.s"
	.include "object_code/common/enemyCode/thwimp.s"
	.include "object_code/common/enemyCode/thwomp.s"

	.include "object_code/seasons/enemyCode/rollingSpikeTrap.s"
	.include "object_code/seasons/enemyCode/pokey.s"
	.include "object_code/seasons/enemyCode/ironMask.s"
.ends

m_section_superfree Enemy_Animations
	.include {"{GAME_DATA_DIR}/enemyAnimations.s"}
.ends

.BANK $0d SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0d NAMESPACE bank0d

	.include "code/enemyCommon.s"

	.include "object_code/common/enemyCode/tektite.s"
	.include "object_code/common/enemyCode/stalfos.s"
	.include "object_code/common/enemyCode/keese.s"
	.include "object_code/common/enemyCode/babyCucco.s"
	.include "object_code/common/enemyCode/zol.s"
	.include "object_code/common/enemyCode/floormaster.s"
	.include "object_code/common/enemyCode/cucco.s"
	.include "object_code/common/enemyCode/giantCucco.s"
	.include "object_code/common/enemyCode/butterfly.s"
	.include "object_code/common/enemyCode/greatFairy.s"
	.include "object_code/common/enemyCode/fireKeese.s"
	.include "object_code/common/enemyCode/waterTektite.s"
	.include "object_code/common/enemyCode/swordMoblinsAndShroudedStalfos.s"
	.include "object_code/common/enemyCode/swordDarknut.s"
	.include "object_code/common/enemyCode/peahat.s"
	.include "object_code/common/enemyCode/wizzrobe.s"
	.include "object_code/common/enemyCode/crows.s"
	.include "object_code/common/enemyCode/gel.s"
	.include "object_code/common/enemyCode/pincer.s"
	.include "object_code/common/enemyCode/ballAndChainSoldier.s"
	.include "object_code/common/enemyCode/hardhatBeetle.s"
	.include "object_code/common/enemyCode/armMimic.s"
	.include "object_code/common/enemyCode/moldorm.s"
	.include "object_code/common/enemyCode/fireballShooter.s"
	.include "object_code/common/enemyCode/beetle.s"
	.include "object_code/common/enemyCode/flyingTile.s"
	.include "object_code/common/enemyCode/dragonfly.s"
	.include "object_code/common/enemyCode/bushOrRock.s"
	.include "object_code/common/enemyCode/itemDropProducer.s"
	.include "object_code/common/enemyCode/seedsOnTree.s"
	.include "object_code/common/enemyCode/twinrovaIce.s"
	.include "object_code/common/enemyCode/twinrovaBat.s"
	.include "object_code/common/enemyCode/ganonRevivalCutscene.s"

	.include {"{GAME_DATA_DIR}/orbMovementScript.s"}

	.include "object_code/seasons/enemyCode/magunesu.s"
	.include "object_code/seasons/enemyCode/unusedTemplate.s"
	.include "object_code/seasons/enemyCode/gohmaGel.s"
	.include "object_code/seasons/enemyCode/mothulaChild.s"
	.include "object_code/seasons/enemyCode/blaino.s"
	.include "object_code/seasons/enemyCode/miniDigdogger.s"
	.include "object_code/seasons/enemyCode/makuTreeBubble.s"
	.include "object_code/seasons/enemyCode/sandPuff.s"
	.include "object_code/seasons/enemyCode/wallFlameShooter.s"
	.include "object_code/seasons/enemyCode/blainosGloves.s"

	.include "code/objectMovementScript.s"
	.include {"{GAME_DATA_DIR}/movingSidescrollPlatform.s"}

.ends


.BANK $0e SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0e NAMESPACE bank0e

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"

	.include "object_code/seasons/enemyCode/brotherGoriyas.s"
	.include "object_code/seasons/enemyCode/facade.s"
	.include "object_code/seasons/enemyCode/omuai.s"
	.include "object_code/seasons/enemyCode/agunima.s"
	.include "object_code/seasons/enemyCode/syger.s"
	.include "object_code/seasons/enemyCode/vire.s"
	.include "object_code/seasons/enemyCode/poeSister2.s"
	.include "object_code/seasons/enemyCode/poeSister1.s"
	.include "object_code/seasons/enemyCode/frypolar.s"
	.include "object_code/seasons/enemyCode/aquamentus.s"
	.include "object_code/seasons/enemyCode/dodongo.s"
	.include "object_code/seasons/enemyCode/mothula.s"
	.include "object_code/seasons/enemyCode/gohma.s"
	.include "object_code/seasons/enemyCode/digdogger.s"
	.include "object_code/seasons/enemyCode/manhandla.s"
	.include "object_code/seasons/enemyCode/medusaHead.s"

.ends

.BANK $0f SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0f NAMESPACE bank0f

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"

	.include "object_code/common/enemyCode/mergedTwinrova.s"
	.include "object_code/common/enemyCode/twinrova.s"
	.include "object_code/common/enemyCode/ganon.s"
	.include "object_code/common/enemyCode/none.s"

	.include "object_code/seasons/enemyCode/generalOnox.s"
	.include "object_code/seasons/enemyCode/dragonOnox.s"
	.include "object_code/seasons/enemyCode/gleeok.s"
	.include "object_code/seasons/enemyCode/kingMoblin.s"

	.include "code/seasons/cutscenes/transitionToDragonOnox.s"

.ends

.ifdef BUILD_VANILLA
	.REPT $87
	.db $0f ; emptyfill (TODO: replace this with ORGA, update md5 for emptyfill-0)
	.ENDR
.endif

 m_section_free Interaction_Code_Group6 NAMESPACE commonInteractions6
	.include "object_code/common/interactionCode/businessScrub.s"
	.include "object_code/common/interactionCode/cf.s"
	.include "object_code/common/interactionCode/companionTutorial.s"
	.include "object_code/common/interactionCode/gameCompleteDialog.s"
	.include "object_code/common/interactionCode/titlescreenClouds.s"
	.include "object_code/common/interactionCode/introBird.s"
	.include "object_code/common/interactionCode/linkShip.s"
.ends

 m_section_free Seasons_Interactions_Bank0f NAMESPACE seasonsInteractionsBank0f
	.include "object_code/seasons/interactionCode/boomerangSubrosian.s"
	.include "object_code/seasons/interactionCode/boomerang.s"
	.include "object_code/seasons/interactionCode/troy.s"
	.include "object_code/seasons/interactionCode/linkedGameGhini.s"
	.include "object_code/seasons/interactionCode/goldenCaveSubrosian.s"
	.include "object_code/seasons/interactionCode/linkedMasterDiver.s"
	.include "object_code/seasons/interactionCode/greatFairy.s"
	.include "object_code/seasons/interactionCode/dekuScrub.s"
	.include "object_code/seasons/interactionCode/d7.s"
.ends


.BANK $10 SLOT 1
.ORG 0

	.define PART_BANK $10
	.export PART_BANK

 m_section_free Part_Code NAMESPACE partCode
	.include "code/partCommon.s"

	.include "object_code/common/partCode/itemDrop.s"
	.include "object_code/common/partCode/enemyDestroyed.s"
	.include "object_code/common/partCode/orb.s"
	.include "object_code/common/partCode/bossDeathExplosion.s"
	.include "object_code/common/partCode/switch.s"
	.include "object_code/common/partCode/lightableTorch.s"
	.include "object_code/common/partCode/shadow.s"
	.include "object_code/common/partCode/darkRoomHandler.s"
	.include "object_code/common/partCode/button.s"
	.include "object_code/common/partCode/movingOrb.s"
	.include "object_code/common/partCode/bridgeSpawner.s"
	.include "object_code/common/partCode/detectionHelper.s"
	.include "object_code/common/partCode/respawnableBush.s"
	.include "object_code/common/partCode/seedOnTree.s"
	.include "object_code/common/partCode/volcanoRock.s"
	.include "object_code/common/partCode/flame.s"
	.include "object_code/common/partCode/owlStatue.s"
	.include "object_code/common/partCode/itemFromMaple.s"
	.include "object_code/common/partCode/gashaTree.s"
	.include "object_code/common/partCode/octorokProjectile.s"
	.include "object_code/common/partCode/fireProjectiles.s"
	.include "object_code/common/partCode/enemyArrow.s"
	.include "object_code/common/partCode/lynelBeam.s"
	.include "object_code/common/partCode/stalfosBone.s"
	.include "object_code/common/partCode/enemySword.s"
	.include "object_code/common/partCode/dekuScrubProjectile.s"
	.include "object_code/common/partCode/wizzrobeProjectile.s"
	.include "object_code/common/partCode/fire.s"
	.include "object_code/common/partCode/moblinBoomerang.s"
	.include "object_code/common/partCode/cuccoAttacker.s"
	.include "object_code/common/partCode/fallingFire.s"
	.include "object_code/common/partCode/lighting.s"
	.include "object_code/common/partCode/smallFairy.s"
	.include "object_code/common/partCode/beam.s"
	.include "object_code/common/partCode/spikedBall.s"
	.include "object_code/common/partCode/greatFairyHeart.s"
	.include "object_code/common/partCode/twinrovaProjectile.s"
	.include "object_code/common/partCode/twinrovaFlame.s"
	.include "object_code/common/partCode/twinrovaSnowball.s"
	.include "object_code/common/partCode/ganonTrident.s"
	.include "object_code/common/partCode/51.s"
	.include "object_code/common/partCode/52.s"
	.include "object_code/common/partCode/blueEnergyBead.s"
.ends

	.include "code/roomInitialization.s"

 m_section_free Part_Code_2 NAMESPACE partCode
	.include "object_code/common/partCode.s" ; Note: closes and opens a new section (seasons only)
	.include "data/partCodeTable.s"

	.include "object_code/seasons/partCode/holesFloortrap.s"
	.include "object_code/seasons/partCode/slingshotEyeStatue.s"
	.include "object_code/seasons/partCode/16.s"
	.include "object_code/seasons/partCode/shootingDragonHead.s"
	.include "object_code/seasons/partCode/arrowShooter.s"
	.include "object_code/seasons/partCode/wallFlameShooterFlames.s"
	.include "object_code/seasons/partCode/buriedMoldorm.s"
	.include "object_code/seasons/partCode/kingMoblinsCannons.s"
	.include "object_code/seasons/partCode/2e.s"
	.include "object_code/seasons/partCode/2f.s"
	.include "object_code/seasons/partCode/poppableBubble.s"
	.include "object_code/seasons/partCode/33.s"
	.include "object_code/seasons/partCode/38.s"
	.include "object_code/seasons/partCode/39.s"
	.include "object_code/seasons/partCode/3a.s"
	.include "object_code/seasons/partCode/3b.s"
	.include "object_code/seasons/partCode/3c.s"
	.include "object_code/seasons/partCode/3d.s"
	.include "object_code/seasons/partCode/3e.s"
	.include "object_code/seasons/partCode/kingMoblinBomb.s"
	.include "object_code/seasons/partCode/aquamentusProjectile.s"
	.include "object_code/seasons/partCode/dodongoFireball.s"
	.include "object_code/seasons/partCode/mothulaProjectile2.s"
	.include "object_code/seasons/partCode/43.s"
	.include "object_code/seasons/partCode/44.s"
	.include "object_code/seasons/partCode/45.s"
	.include "object_code/seasons/partCode/46.s"
	.include "object_code/seasons/partCode/47.s"
	.include "object_code/seasons/partCode/48.s"
	.include "object_code/seasons/partCode/49.s"
	.include "object_code/seasons/partCode/4a.s"
	.include "object_code/seasons/partCode/dinCrystal.s"
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
	.include "object_code/common/interactionCode/faroreGiveItem.s"
	.include "object_code/common/interactionCode/zeldaApproachTrigger.s"
.ends

 m_section_free Interaction_Code_Group8 NAMESPACE commonInteractions8
	.include "object_code/common/interactionCode/eraOrSeasonInfo.s"
	.include "object_code/common/interactionCode/statueEyeball.s"
	.include "object_code/common/interactionCode/ringHelpBook.s"
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
	.include "object_code/seasons/interactionCode/linkedFountainLady.s"
	.include "object_code/seasons/interactionCode/linkedSecredGivers.s"
	.include "object_code/seasons/interactionCode/miscPuzzles.s"
	.include "object_code/seasons/interactionCode/goldenBeastOldMan.s"
	.include "object_code/seasons/interactionCode/makuSeedAndEssences.s"
	.include "object_code/seasons/interactionCode/nayruRalphCredits.s"
	.include "object_code/seasons/interactionCode/portalSpawner.s"
	.include "object_code/seasons/interactionCode/vire.s"
	.include "object_code/seasons/interactionCode/linkedHerosCaveOldMan.s"
	.include "object_code/seasons/interactionCode/getRodOfSeasons.s"
	.include "object_code/seasons/interactionCode/loneZora.s"
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
	.include "object_code/common/interactionCode/faroreMakeChest.s"

	.include {"{GAME_DATA_DIR}/objectGfxHeaders.s"}
	.include {"{GAME_DATA_DIR}/treeGfxHeaders.s"}

	.include {"{GAME_DATA_DIR}/enemyData.s"}
	.include {"{GAME_DATA_DIR}/partData.s"}
	.include {"{GAME_DATA_DIR}/itemData.s"}
	.include {"{GAME_DATA_DIR}/interactionData.s"}

	.include {"{GAME_DATA_DIR}/treasureCollectionBehaviours.s"}
	.include {"{GAME_DATA_DIR}/treasureDisplayData.s"}

.ends
