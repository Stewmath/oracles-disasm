snddeStart:

snddeChannel0:
snddeChannel1:
snddeChannel4:
snddeChannel6:
	cmdff


snd97Start:
sounda1Start:
soundadStart:
soundb6Start:

snd97Channel2:
snd97Channel7:
sounda1Channel2:
sounda1Channel7:
soundadChannel2:
soundadChannel7:
soundb6Channel2:
soundb6Channel7:
bank39ChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank39ChannelFallback


.include "audio/sfx/common/fairyCutscene.s"
.include "audio/sfx/common/baseball.s"

.ifdef BUILD_VANILLA
	.dsb 12 $ff
.endif

.include "audio/sfx/common/beam.s"
.include "audio/sfx/common/breakRock.s"
.include "audio/sfx/common/wave.s"
.include "audio/sfx/common/swordObtained.s"
.include "audio/sfx/seasons/magnetGloves.s"
.include "audio/sfx/common/pieceOfPower.s"
.include "audio/sfx/common/linkSwim.s"
.include "audio/sfx/common/poof.s"
.include "audio/sfx/common/bigSword.s"
.include "audio/sfx/seasons/b5.s" ; TODO
.include "audio/sfx/common/rumble.s"
.include "audio/sfx/seasons/frypolarMovement.s"
.include "audio/sfx/common/veranProjectile.s"
.include "audio/sfx/common/shock.s"
.include "audio/sfx/common/beam1.s"
.include "audio/sfx/common/fadeout.s"
.include "audio/sfx/common/pickUp.s"
.include "audio/sfx/common/chicken.s"
.include "audio/sfx/common/makuDisappear.s"
.include "audio/sfx/common/beam2.s"
.include "audio/sfx/seasons/b7.s" ; TODO
.include "audio/sfx/common/veranFairyAttack.s"
.include "audio/sfx/common/rumble2.s"
.include "audio/sfx/common/opening.s"
.include "audio/sfx/common/warpStart.s"
.include "audio/sfx/common/endless.s"
.include "audio/sfx/common/bigExplosion2.s"
.include "audio/sfx/seasons/bd.s" ; TODO
.include "audio/mus/common/mapleGame.s"
.include "audio/mus/common/finalBoss.s"
.include "audio/mus/common/essence.s"

.ifdef BUILD_VANILLA
	.dsb 13 $ff
.endif


.BANK $3a SLOT 1
.ORG 0

mus41Start:
mus42Start:

mus41Channel0:
mus41Channel1:
mus41Channel4:
mus41Channel6:
mus42Channel0:
mus42Channel1:
mus42Channel4:
mus42Channel6:
bank3aChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3aChannelFallback


.include "audio/mus/common/indoors.s"
.include "audio/mus/common/titlescreen.s"
.include "audio/mus/common/miniboss.s"
.include "audio/mus/common/gameover.s"
.include "audio/mus/common/cave.s"
.include "audio/mus/common/getEssence.s"
.include "audio/sfx/common/selectItem.s"
.include "audio/sfx/common/solvePuzzle.s"
.include "audio/sfx/common/getItem.s"
.include "audio/sfx/common/chargeSword.s"
.include "audio/sfx/common/clink.s"
.include "audio/sfx/common/throw.s"
.include "audio/sfx/common/bombLand.s"
.include "audio/sfx/common/jump.s"
.include "audio/sfx/common/damageEnemy.s"
.include "audio/sfx/common/gainHeart.s"
.include "audio/sfx/common/clink2.s"
.include "audio/sfx/common/fallInHole.s"
.include "audio/sfx/common/error.s"
.include "audio/sfx/common/solvePuzzle2.s"
.include "audio/sfx/common/getSeed.s"
.include "audio/sfx/common/damageLink.s"
.include "audio/sfx/common/heartBeep.s"
.include "audio/sfx/common/rupee.s"
.include "audio/sfx/common/gohmaSpawnGel.s"
.include "audio/sfx/seasons/freezeLava.s"
.include "audio/sfx/common/slash.s"
.include "audio/sfx/common/swordSpin.s"
.include "audio/sfx/common/openChest.s"
.include "audio/sfx/common/cutGrass.s"
.include "audio/sfx/common/enterCave.s"
.include "audio/sfx/common/bigExplosion.s"
.include "audio/sfx/common/boomerang.s"
.include "audio/sfx/common/dropEssence.s"
.include "audio/sfx/common/shield.s"
.include "audio/sfx/common/unknown5.s"
.include "audio/sfx/common/swordSlash.s"
.include "audio/sfx/common/killEnemy.s"
.include "audio/sfx/common/openMenu.s"
.include "audio/sfx/common/closeMenu.s"
.include "audio/sfx/common/energyThing.s"
.include "audio/sfx/common/swordBeam.s"
.include "audio/sfx/common/linkDead.s"
.include "audio/sfx/common/linkFall.s"
.include "audio/sfx/common/text.s"
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
.include "audio/sfx/seasons/7d.s" ; TODO
.include "audio/sfx/common/switch.s"
.include "audio/sfx/common/aquamentusHover.s"
.include "audio/sfx/common/unknown4.s"
.include "audio/sfx/common/bossDead.s"
.include "audio/sfx/common/lightning.s"
.include "audio/sfx/seasons/wind.s"
.include "audio/sfx/seasons/d1.s" ; TODO
.include "audio/sfx/common/pirateBell.s"
.include "audio/sfx/seasons/dodongoOpenMouth.s"
.include "audio/sfx/common/magicPowder.s"
.include "audio/sfx/common/menuMove.s"
.include "audio/sfx/common/scentSeed.s"
.include "audio/sfx/seasons/86.s" ; TODO
.include "audio/sfx/common/teleport.s"

soundd4Start:
soundd4Channel2:
	cmdff
soundd4Channel7:
	cmdff

sndd5Start:
sndd5Channel2:
	cmdff

.include "audio/sfx/common/transform.s"
.include "audio/sfx/common/blueStalfosCharge.s"
.include "audio/sfx/seasons/makuTreeSnore.s"
.include "audio/sfx/common/fluteRicky.s"
.include "audio/sfx/common/fluteDimitri.s"
.include "audio/sfx/common/fluteMoosh.s"
.include "audio/mus/common/preCredits.s"
.include "audio/mus/common/twinrova.s"
.include "audio/sfx/common/makuTreePast.s"
.include "audio/sfx/common/restore.s"
.include "audio/sfx/seasons/creepyLaugh.s"
.include "audio/sfx/common/moosh.s"
.include "audio/sfx/common/ding.s"
.include "audio/sfx/common/dekuScrub.s"
.include "audio/sfx/common/floodgates.s"
.include "audio/sfx/common/ricky.s"
.include "audio/sfx/common/circling.s"
.include "audio/sfx/common/dig.s"

.ifdef BUILD_VANILLA
	.dsb 4 $ff
.endif


.BANK $3b SLOT 1
.ORG 0

mus43Start:
mus44Start:
mus45Start:

mus43Channel0:
mus43Channel1:
mus43Channel4:
mus43Channel6:
mus44Channel0:
mus44Channel1:
mus44Channel4:
mus44Channel6:
mus45Channel0:
mus45Channel1:
mus45Channel4:
mus45Channel6:
bank3bChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3bChannelFallback


.include "audio/mus/seasons/horonVillage.s"
.include "audio/mus/common/minigame.s"
.include "audio/mus/common/fileSelect.s"
.include "audio/mus/common/fairyFountain.s"
.include "audio/mus/common/overworld.s"
.include "audio/mus/seasons/hideAndSeek.s"
.include "audio/mus/seasons/sunkenCity.s"
.include "audio/mus/common/essenceRoom.s"
.include "audio/mus/seasons/templeRemains.s"
.include "audio/mus/seasons/unused1.s"
.include "audio/mus/seasons/tarmRuins.s"
.include "audio/mus/seasons/carnival.s"
.include "audio/mus/common/ganon.s"
.include "audio/mus/seasons/samasaDesert.s"
.include "audio/sfx/common/splash.s"
.include "audio/sfx/common/text2.s"
.include "audio/sfx/common/filledHeartContainer.s"
.include "audio/sfx/common/seedShooter.s"
.include "audio/sfx/common/unknown7.s"
.include "audio/sfx/seasons/8e.s" ; TODO
.include "audio/sfx/common/enemyJump.s"
.include "audio/sfx/common/galeSeed.s"

.ifdef BUILD_VANILLA
	.dsb 10 $ff
.endif


.BANK $3c SLOT 1
.ORG 0

bank3cChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3cChannelFallback


.include "audio/mus/seasons/makuTree.s"
.include "audio/mus/seasons/swordAndShieldMaze.s"
.include "audio/mus/seasons/gnarledRootDungeon.s"
.include "audio/mus/seasons/snakesRemains.s"
.include "audio/mus/seasons/herosCave.s"
.include "audio/mus/seasons/explorersCrypt.s"
.include "audio/mus/seasons/unicornsCave.s"
.include "audio/mus/seasons/poisonMothsLair.s"
.include "audio/mus/seasons/dancingDragonDungeon.s"
.include "audio/mus/common/onoxCastle.s"
.include "audio/mus/seasons/subrosianDance.s"
.include "audio/mus/seasons/ancientRuins.s"
.include "audio/mus/common/sadness.s"
.include "audio/mus/common/intro2.s"
.include "audio/sfx/common/goron.s"
.include "audio/sfx/common/ghost.s"
.include "audio/sfx/common/becomeBaby.s"
.include "audio/sfx/common/jingle.s"
.include "audio/sfx/common/strike.s"

.ifdef BUILD_VANILLA
	.dsb 4 $ff
.endif


.BANK $3d SLOT 1
.ORG 0

bank3dChannelFallback:
sound24Channel6:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3dChannelFallback

.include "audio/mus/common/triumphant.s"
.include "audio/mus/common/disaster.s"

sound24Start:
sound24Channel1:
	cmdff
sound24Channel0:
	cmdff
sound24Channel4:
	cmdff

.include "audio/mus/common/pirates.s"
.include "audio/mus/common/finalDungeon.s"
.include "audio/mus/seasons/subrosianShop.s"
.include "audio/mus/common/rosaDate.s"
.include "audio/mus/common/roomOfRites.s"
.include "audio/mus/common/blackTowerEntrance.s"
.include "audio/mus/common/zeldaSaved.s"
.include "audio/mus/common/mapleTheme.s"
.include "audio/mus/common/intro1.s"
.include "audio/mus/common/crazyDance.s"
.include "audio/sfx/seasons/93.s"
.include "audio/sfx/seasons/dodongoEat.s"
.include "audio/sfx/common/compass.s"
.include "audio/sfx/common/land.s"
.include "audio/sfx/common/switchHook.s"

.ifdef BUILD_VANILLA
	.dsb 4 $ff
.endif


.BANK $3e SLOT 1
.ORG 0

sound30Start:
mus37Start:
mus3aStart:
mus3bStart:
mus47Start:
mus48Start:
mus49Start:
mus4bStart:

sound30Channel4:
sound30Channel6:
mus37Channel4:
mus3aChannel6:
mus3bChannel0:
mus3bChannel1:
mus3bChannel4:
mus3bChannel6:
mus47Channel0:
mus47Channel1:
mus47Channel4:
mus47Channel6:
mus48Channel0:
mus48Channel1:
mus48Channel4:
mus48Channel6:
mus49Channel0:
mus49Channel1:
mus49Channel4:
mus49Channel6:
mus4bChannel0:
mus4bChannel1:
mus4bChannel4:
mus4bChannel6:
bank3eChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3eChannelFallback

.include "audio/sfx/seasons/danceMove.s"
.include "audio/sfx/common/dimitri.s"
.include "audio/sfx/common/whistle.s"
.include "audio/sfx/common/goronDanceB.s"

; Undefined sounds
sndd6Start:
sndd7Start:
sndd8Start:
sndd9Start:
snddaStart:
snddbStart:
snddcStart:
sndddStart:

sndd6Channel1:
sndd7Channel1:
sndd8Channel1:
sndd9Channel1:
snddaChannel1:
snddbChannel1:
snddcChannel1:
sndddChannel1:
	cmdff

sndd6Channel0:
sndd7Channel0:
sndd8Channel0:
sndd9Channel0:
snddaChannel0:
snddbChannel0:
snddcChannel0:
sndddChannel0:
	cmdff

sndd6Channel4:
sndd7Channel4:
sndd8Channel4:
sndd9Channel4:
snddaChannel4:
snddbChannel4:
snddcChannel4:
sndddChannel4:
	cmdff

sndd6Channel6:
sndd7Channel6:
sndd8Channel6:
sndd9Channel6:
snddaChannel6:
snddbChannel6:
snddcChannel6:
sndddChannel6:
	cmdff

.include "audio/mus/common/greatMoblin.s"

mus37Channel1:
	cmdff
mus37Channel0:
	cmdff
mus37Channel6:
	cmdff

sound30Channel1:
	cmdff
sound30Channel0:
	cmdff

.include "audio/mus/common/ladxSideview.s"
.include "audio/mus/common/syrup.s"
.include "audio/mus/seasons/songOfStorms.s"
.include "audio/mus/common/goronCave.s"
.include "audio/mus/common/credits2.s"
.include "audio/mus/common/boss.s"

mus3aChannel1:
	cmdff
mus3aChannel0:
	cmdff
mus3aChannel4:
	cmdff

.ifdef BUILD_VANILLA
	.dsb 7 $ff
.endif

.include "audio/mus/seasons/subrosia.s"
.include "audio/mus/common/credits1.s"
.include "audio/mus/seasons/unused2.s"

.ifdef BUILD_VANILLA
	.dsb 10 $ff
.endif

.undefine MUSIC_CHANNEL_FALLBACK
