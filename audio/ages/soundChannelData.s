snddeStart:

snddeChannel0:
snddeChannel1:
snddeChannel4:
snddeChannel6:
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

snd97Start:
snd97Channel2:
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

sndd5Start:
sndd5Channel2:
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
mus37Start:
mus3aStart:
mus3bStart:
sound3dStart:
mus41Start:
mus42Start:
mus43Start:
mus44Start:
mus45Start:
mus47Start:
mus48Start:
mus49Start:
mus4bStart:
sndd6Start:
sndd7Start:
sndd8Start:
sndd9Start:
snddaStart:
snddbStart:
snddcStart:
sndddStart:

mus37Channel1:
mus3aChannel1:
mus3bChannel1:
sound3dChannel1:
mus41Channel1:
mus42Channel1:
mus43Channel1:
mus44Channel1:
mus45Channel1:
mus47Channel1:
mus48Channel1:
mus49Channel1:
mus4bChannel1:
sndd6Channel1:
sndd7Channel1:
sndd8Channel1:
sndd9Channel1:
snddaChannel1:
snddbChannel1:
snddcChannel1:
sndddChannel1:
	cmdff

mus37Channel0:
mus3aChannel0:
mus3bChannel0:
sound3dChannel0:
mus41Channel0:
mus42Channel0:
mus43Channel0:
mus44Channel0:
mus45Channel0:
mus47Channel0:
mus48Channel0:
mus49Channel0:
mus4bChannel0:
sndd6Channel0:
sndd7Channel0:
sndd8Channel0:
sndd9Channel0:
snddaChannel0:
snddbChannel0:
snddcChannel0:
sndddChannel0:
	cmdff

mus37Channel4:
mus3aChannel4:
mus3bChannel4:
sound3dChannel4:
mus41Channel4:
mus42Channel4:
mus43Channel4:
mus44Channel4:
mus45Channel4:
mus47Channel4:
mus48Channel4:
mus49Channel4:
mus4bChannel4:
sndd6Channel4:
sndd7Channel4:
sndd8Channel4:
sndd9Channel4:
snddaChannel4:
snddbChannel4:
snddcChannel4:
sndddChannel4:
	cmdff

mus37Channel6:
mus3aChannel6:
mus3bChannel6:
sound3dChannel6:
mus41Channel6:
mus42Channel6:
mus43Channel6:
mus44Channel6:
mus45Channel6:
mus47Channel6:
mus48Channel6:
mus49Channel6:
mus4bChannel6:
sndd6Channel6:
sndd7Channel6:
sndd8Channel6:
sndd9Channel6:
snddaChannel6:
snddbChannel6:
snddcChannel6:
sndddChannel6:
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
