sounddeStart:

sounddeChannel0:
sounddeChannel1:
sounddeChannel4:
sounddeChannel6:
	cmdff


bank39ChannelFallback:
	cmdff
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank39ChannelFallback


.include "audio/sfx/common/baseball.s"

.ifdef BUILD_VANILLA
	.dsb 11 $ff
.endif

.include "audio/sfx/ages/monkey.s"
.include "audio/sfx/common/beam.s"
.include "audio/sfx/common/wave.s"
.include "audio/sfx/common/swordObtained.s"
.include "audio/sfx/common/pieceOfPower.s"
.include "audio/sfx/common/linkSwim.s"

sound97Start:
sound97Channel2:
	cmdff

.include "audio/sfx/common/poof.s"
.include "audio/sfx/common/bigSword.s"
.include "audio/sfx/common/rumble.s"
.include "audio/sfx/common/veranProjectile.s"
.include "audio/sfx/common/shock.s"
.include "audio/sfx/common/beam1.s"
.include "audio/sfx/common/fadeout.s"
.include "audio/sfx/common/pickUp.s"
.include "audio/sfx/common/chicken.s"
.include "audio/sfx/common/makuDisappear.s"
.include "audio/sfx/common/beam2.s"

soundb7Start:
soundb7Channel2:
	cmdff
soundb7Channel7:
	cmdff

.include "audio/sfx/common/veranFairyAttack.s"
.include "audio/sfx/common/rumble2.s"
.include "audio/sfx/common/warpStart.s"
.include "audio/sfx/common/endless.s"
.include "audio/sfx/common/bigExplosion2.s"

soundbdStart:
soundbdChannel2:
	cmdff

.include "audio/mus/common/mapleGame.s"
.include "audio/mus/common/finalBoss.s"
.include "audio/mus/common/essence.s"
.include "audio/sfx/ages/echoes.s"
.include "audio/mus/ages/underwater.s"
.include "audio/mus/ages/makuTree.s"

.ifdef BUILD_VANILLA
	.dsb 162 $ff
.endif


.BANK $3a SLOT 1
.ORG 0

bank3aChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3aChannelFallback


.include "audio/mus/common/indoors.s"
.include "audio/mus/common/titlescreen.s"
.include "audio/mus/common/miniboss.s"
.include "audio/mus/common/gameover.s"
.include "audio/mus/common/cave.s"
.include "audio/mus/common/getEssence.s"
.include "audio/sfx/common/swordSlash.s"
.include "audio/sfx/common/killEnemy.s"
.include "audio/sfx/common/openMenu.s"
.include "audio/sfx/common/closeMenu.s"
.include "audio/sfx/common/energyThing.s"
.include "audio/sfx/common/swordBeam.s"
.include "audio/sfx/common/linkDead.s"
.include "audio/sfx/common/linkFall.s"
.include "audio/sfx/common/bossDamage.s"
.include "audio/sfx/common/explosion.s"
.include "audio/sfx/common/doorClose.s"
.include "audio/sfx/common/moveBlock.s"
.include "audio/sfx/common/lightTorch.s"
.include "audio/sfx/common/unknown3.s"
.include "audio/sfx/common/minecart.s"
.include "audio/sfx/common/strongPound.s"
.include "audio/sfx/common/roller.s"
.include "audio/sfx/common/mysterySeed.s"
.include "audio/sfx/common/switch.s"
.include "audio/sfx/common/aquamentusHover.s"
.include "audio/sfx/common/unknown4.s"
.include "audio/sfx/common/bossDead.s"
.include "audio/sfx/common/lightning.s"
.include "audio/sfx/ages/wind.s"
.include "audio/sfx/common/pirateBell.s"
.include "audio/sfx/common/magicPowder.s"
.include "audio/sfx/common/menuMove.s"
.include "audio/sfx/common/scentSeed.s"

sound86Start:
sound86Channel2:
	cmdff

.include "audio/sfx/common/teleport.s"

soundd5Start:
soundd5Channel2:
	cmdff
	cmdff

.include "audio/sfx/common/transform.s"
.include "audio/sfx/common/blueStalfosCharge.s"

sound92Start:
sound92Channel2:
	cmdff

.include "audio/sfx/common/fluteRicky.s"
.include "audio/sfx/common/fluteDimitri.s"
.include "audio/sfx/common/fluteMoosh.s"
.include "audio/mus/common/preCredits.s"
.include "audio/mus/common/twinrova.s"
.include "audio/sfx/common/makuTreePast.s"
.include "audio/sfx/common/restore.s"

soundcfStart:
soundcfChannel2:
	cmdff

.include "audio/sfx/common/moosh.s"
.include "audio/sfx/common/ding.s"
.include "audio/sfx/common/dekuScrub.s"
.include "audio/sfx/common/floodgates.s"
.include "audio/sfx/common/ricky.s"
.include "audio/sfx/common/circling.s"
.include "audio/sfx/common/dig.s"

sound7aStart:
sound7aChannel2:
	cmdff
	cmdff

.include "audio/sfx/ages/switch2.s"
.include "audio/sfx/ages/openGate.s"
.include "audio/sfx/ages/moveBlock2.s"
.include "audio/sfx/ages/tokay.s"
.include "audio/sfx/ages/tingle.s"
.include "audio/sfx/common/dimitri.s"
.include "audio/sfx/common/whistle.s"
.include "audio/sfx/common/goronDanceB.s"
.include "audio/sfx/common/getSeed.s"
.include "audio/sfx/common/slash.s"
.include "audio/sfx/common/shield.s"
.include "audio/sfx/common/unknown5.s"
.include "audio/sfx/ages/timewarpInitiated.s"
.include "audio/sfx/ages/timewarpCompleted.s"
.include "audio/sfx/common/goron.s"
.include "audio/sfx/common/ghost.s"
.include "audio/sfx/common/becomeBaby.s"
.include "audio/sfx/common/jingle.s"
.include "audio/sfx/common/strike.s"

.ifdef BUILD_VANILLA
	.db $ff $ff
.endif


.BANK $3b SLOT 1
.ORG 0

bank3bChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3bChannelFallback


.include "audio/mus/common/minigame.s"
.include "audio/mus/common/fileSelect.s"
.include "audio/mus/common/fairyFountain.s"
.include "audio/mus/common/overworld.s"
.include "audio/mus/common/essenceRoom.s"
.include "audio/mus/common/ganon.s"
.include "audio/mus/ages/overworldPast.s"
.include "audio/mus/ages/nayru.s"
.include "audio/mus/ages/crescent.s"
.include "audio/mus/ages/lynnaCity.s"
.include "audio/mus/ages/lynnaVillage.s"
.include "audio/mus/ages/makuPath.s"
.include "audio/mus/ages/symmetryPresent.s"
.include "audio/sfx/common/splash.s"
.include "audio/sfx/common/text2.s"
.include "audio/sfx/common/filledHeartContainer.s"
.include "audio/sfx/common/seedShooter.s"
.include "audio/sfx/common/unknown7.s"
.include "audio/sfx/common/enemyJump.s"
.include "audio/sfx/common/galeSeed.s"

soundcaStart:
soundcaChannel2:
	cmdff
soundcaChannel7:
	cmdff

.include "audio/sfx/common/selectItem.s"
.include "audio/sfx/common/solvePuzzle.s"
.include "audio/sfx/common/getItem.s"

.ifdef BUILD_VANILLA
	.dsb 152 $ff
.endif


.BANK $3c SLOT 1
.ORG 0

bank3cChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3cChannelFallback


.include "audio/mus/ages/moonlitGrotto.s"
.include "audio/mus/common/onoxCastle.s"
.include "audio/mus/common/sadness.s"
.include "audio/mus/common/intro2.s"
.include "audio/mus/ages/ambiPalace.s"
.include "audio/mus/ages/tokayHouse.s"
.include "audio/mus/ages/mermaidsCave.s"
.include "audio/mus/ages/skullDungeon.s"
.include "audio/mus/ages/blackTower.s"
.include "audio/mus/ages/fairyForest.s"
.include "audio/mus/ages/ralph.s"
.include "audio/mus/ages/spiritsGrave.s"
.include "audio/mus/ages/wingDungeon.s"
.include "audio/mus/ages/crownDungeon.s"
.include "audio/mus/ages/jabuJabusBelly.s"
.include "audio/sfx/common/damageEnemy.s"
.include "audio/sfx/common/chargeSword.s"
.include "audio/sfx/common/clink.s"
.include "audio/sfx/common/throw.s"
.include "audio/sfx/common/bombLand.s"
.include "audio/sfx/common/jump.s"
.include "audio/sfx/common/gainHeart.s"
.include "audio/sfx/common/breakRock.s"
.include "audio/sfx/common/fairyCutscene.s"
.include "audio/sfx/ages/currents.s"
.include "audio/sfx/ages/ages.s"

.ifdef BUILD_VANILLA
	.dsb 678 $ff
.endif


.BANK $3d SLOT 1
.ORG 0

bank3dChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3dChannelFallback


.include "audio/mus/common/triumphant.s"
.include "audio/mus/common/disaster.s"
.include "audio/mus/common/pirates.s"
.include "audio/mus/common/finalDungeon.s"
.include "audio/mus/common/rosaDate.s"
.include "audio/mus/common/roomOfRites.s"
.include "audio/mus/common/blackTowerEntrance.s"
.include "audio/mus/common/zeldaSaved.s"
.include "audio/mus/common/mapleTheme.s"
.include "audio/mus/common/intro1.s"
.include "audio/mus/common/crazyDance.s"
.include "audio/mus/ages/ancientTomb.s"

sound93Start:
sound93Channel2:
	cmdff

sound94Start:
sound94Channel2:
	cmdff

.include "audio/sfx/common/compass.s"
.include "audio/sfx/common/land.s"
.include "audio/sfx/common/switchHook.s"
.include "audio/sfx/common/opening.s"
.include "audio/sfx/common/clink2.s"
.include "audio/sfx/common/fallInHole.s"
.include "audio/sfx/common/error.s"
.include "audio/sfx/common/solvePuzzle2.s"
.include "audio/sfx/common/damageLink.s"
.include "audio/sfx/common/gohmaSpawnGel.s"

.ifdef BUILD_VANILLA
	.dsb 93 $ff
.endif


.BANK $3e SLOT 1
.ORG 0

bank3eChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3eChannelFallback


; Undefined sounds
sound37Start:
sound3aStart:
sound3bStart:
sound3dStart:
sound41Start:
sound42Start:
sound43Start:
sound44Start:
sound45Start:
sound47Start:
sound48Start:
sound49Start:
sound4bStart:
soundd6Start:
soundd7Start:
soundd8Start:
soundd9Start:
sounddaStart:
sounddbStart:
sounddcStart:
soundddStart:

sound37Channel1:
sound3aChannel1:
sound3bChannel1:
sound3dChannel1:
sound41Channel1:
sound42Channel1:
sound43Channel1:
sound44Channel1:
sound45Channel1:
sound47Channel1:
sound48Channel1:
sound49Channel1:
sound4bChannel1:
soundd6Channel1:
soundd7Channel1:
soundd8Channel1:
soundd9Channel1:
sounddaChannel1:
sounddbChannel1:
sounddcChannel1:
soundddChannel1:
	cmdff

sound37Channel0:
sound3aChannel0:
sound3bChannel0:
sound3dChannel0:
sound41Channel0:
sound42Channel0:
sound43Channel0:
sound44Channel0:
sound45Channel0:
sound47Channel0:
sound48Channel0:
sound49Channel0:
sound4bChannel0:
soundd6Channel0:
soundd7Channel0:
soundd8Channel0:
soundd9Channel0:
sounddaChannel0:
sounddbChannel0:
sounddcChannel0:
soundddChannel0:
	cmdff

sound37Channel4:
sound3aChannel4:
sound3bChannel4:
sound3dChannel4:
sound41Channel4:
sound42Channel4:
sound43Channel4:
sound44Channel4:
sound45Channel4:
sound47Channel4:
sound48Channel4:
sound49Channel4:
sound4bChannel4:
soundd6Channel4:
soundd7Channel4:
soundd8Channel4:
soundd9Channel4:
sounddaChannel4:
sounddbChannel4:
sounddcChannel4:
soundddChannel4:
	cmdff

sound37Channel6:
sound3aChannel6:
sound3bChannel6:
sound3dChannel6:
sound41Channel6:
sound42Channel6:
sound43Channel6:
sound44Channel6:
sound45Channel6:
sound47Channel6:
sound48Channel6:
sound49Channel6:
sound4bChannel6:
soundd6Channel6:
soundd7Channel6:
soundd8Channel6:
soundd9Channel6:
sounddaChannel6:
sounddbChannel6:
sounddcChannel6:
soundddChannel6:
	cmdff

.ifdef BUILD_VANILLA
	.dsb 4 $ff
.endif


.include "audio/mus/common/greatMoblin.s"
.include "audio/mus/common/ladxSideview.s"
.include "audio/mus/common/syrup.s"
.include "audio/mus/common/goronCave.s"
.include "audio/mus/common/credits2.s"
.include "audio/mus/common/boss.s"
.include "audio/mus/common/credits1.s"
.include "audio/mus/ages/symmetryPast.s"
.include "audio/mus/ages/zoraVillage.s"
.include "audio/sfx/common/heartBeep.s"
.include "audio/sfx/common/rupee.s"
.include "audio/sfx/common/swordSpin.s"
.include "audio/sfx/common/openChest.s"
.include "audio/sfx/common/cutGrass.s"
.include "audio/sfx/common/enterCave.s"
.include "audio/sfx/common/bigExplosion.s"
.include "audio/sfx/common/boomerang.s"
.include "audio/sfx/common/dropEssence.s"
.include "audio/sfx/common/text.s"

.ifdef BUILD_VANILLA
	.dsb 3 $ff
.endif

.undefine MUSIC_CHANNEL_FALLBACK
