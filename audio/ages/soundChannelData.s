m_section_superfree AudioData1

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


.include "audio/common/sfx/baseball.s"

.ifdef BUILD_VANILLA
	.dsb 11 $ff
.endif

.include "audio/ages/sfx/monkey.s"
.include "audio/common/sfx/beam.s"
.include "audio/common/sfx/wave.s"
.include "audio/common/sfx/swordObtained.s"
.include "audio/common/sfx/pieceOfPower.s"
.include "audio/common/sfx/linkSwim.s"

snd97Start:
snd97Channel2:
	cmdff

.include "audio/common/sfx/poof.s"
.include "audio/common/sfx/bigSword.s"
.include "audio/common/sfx/rumble.s"
.include "audio/common/sfx/veranProjectile.s"
.include "audio/common/sfx/shock.s"
.include "audio/common/sfx/beam1.s"
.include "audio/common/sfx/fadeout.s"
.include "audio/common/sfx/pickUp.s"
.include "audio/common/sfx/chicken.s"
.include "audio/common/sfx/makuDisappear.s"
.include "audio/common/sfx/beam2.s"

sndb7Start:
sndb7Channel2:
	cmdff
sndb7Channel7:
	cmdff

.include "audio/common/sfx/veranFairyAttack.s"
.include "audio/common/sfx/rumble2.s"
.include "audio/common/sfx/warpStart.s"
.include "audio/common/sfx/endless.s"
.include "audio/common/sfx/bigExplosion2.s"

sndbdStart:
sndbdChannel2:
	cmdff

.include "audio/common/mus/mapleGame.s"
.include "audio/common/mus/finalBoss.s"
.include "audio/common/mus/essence.s"
.include "audio/ages/sfx/echoes.s"
.include "audio/ages/mus/underwater.s"
.include "audio/ages/mus/makuTree.s"

.ifdef BUILD_VANILLA
	.dsb 162 $ff
.endif

.ends


.BANK $3a SLOT 1
.ORG 0

m_section_superfree AudioData2

bank3aChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3aChannelFallback


.include "audio/common/mus/indoors.s"
.include "audio/common/mus/titlescreen.s"
.include "audio/common/mus/miniboss.s"
.include "audio/common/mus/gameover.s"
.include "audio/common/mus/cave.s"
.include "audio/common/mus/getEssence.s"
.include "audio/common/sfx/swordSlash.s"
.include "audio/common/sfx/killEnemy.s"
.include "audio/common/sfx/openMenu.s"
.include "audio/common/sfx/closeMenu.s"
.include "audio/common/sfx/energyThing.s"
.include "audio/common/sfx/swordBeam.s"
.include "audio/common/sfx/linkDead.s"
.include "audio/common/sfx/linkFall.s"
.include "audio/common/sfx/bossDamage.s"
.include "audio/common/sfx/explosion.s"
.include "audio/common/sfx/doorClose.s"
.include "audio/common/sfx/moveBlock.s"
.include "audio/common/sfx/lightTorch.s"
.include "audio/common/sfx/unknown3.s"
.include "audio/common/sfx/minecart.s"
.include "audio/common/sfx/strongPound.s"
.include "audio/common/sfx/roller.s"
.include "audio/common/sfx/mysterySeed.s"
.include "audio/common/sfx/switch.s"
.include "audio/common/sfx/aquamentusHover.s"
.include "audio/common/sfx/unknown4.s"
.include "audio/common/sfx/bossDead.s"
.include "audio/common/sfx/lightning.s"
.include "audio/ages/sfx/wind.s"
.include "audio/common/sfx/pirateBell.s"
.include "audio/common/sfx/magicPowder.s"
.include "audio/common/sfx/menuMove.s"
.include "audio/common/sfx/scentSeed.s"

snd86Start:
snd86Channel2:
	cmdff

.include "audio/common/sfx/teleport.s"

sndd5Start:
sndd5Channel2:
	cmdff
	cmdff

.include "audio/common/sfx/transform.s"
.include "audio/common/sfx/blueStalfosCharge.s"

snd92Start:
snd92Channel2:
	cmdff

.include "audio/common/sfx/fluteRicky.s"
.include "audio/common/sfx/fluteDimitri.s"
.include "audio/common/sfx/fluteMoosh.s"
.include "audio/common/mus/preCredits.s"
.include "audio/common/mus/twinrova.s"
.include "audio/common/sfx/makuTreePast.s"
.include "audio/common/sfx/restore.s"

sndcfStart:
sndcfChannel2:
	cmdff

.include "audio/common/sfx/moosh.s"
.include "audio/common/sfx/ding.s"
.include "audio/common/sfx/dekuScrub.s"
.include "audio/common/sfx/floodgates.s"
.include "audio/common/sfx/ricky.s"
.include "audio/common/sfx/circling.s"
.include "audio/common/sfx/dig.s"

snd7aStart:
snd7aChannel2:
	cmdff
	cmdff

.include "audio/ages/sfx/switch2.s"
.include "audio/ages/sfx/openGate.s"
.include "audio/ages/sfx/moveBlock2.s"
.include "audio/ages/sfx/tokay.s"
.include "audio/ages/sfx/tingle.s"
.include "audio/common/sfx/dimitri.s"
.include "audio/common/sfx/whistle.s"
.include "audio/common/sfx/goronDanceB.s"
.include "audio/common/sfx/getSeed.s"
.include "audio/common/sfx/slash.s"
.include "audio/common/sfx/shield.s"
.include "audio/common/sfx/unknown5.s"
.include "audio/ages/sfx/timewarpInitiated.s"
.include "audio/ages/sfx/timewarpCompleted.s"
.include "audio/common/sfx/goron.s"
.include "audio/common/sfx/ghost.s"
.include "audio/common/sfx/becomeBaby.s"
.include "audio/common/sfx/jingle.s"
.include "audio/common/sfx/strike.s"

.ifdef BUILD_VANILLA
	.db $ff $ff
.endif

.ends


.BANK $3b SLOT 1
.ORG 0

m_section_superfree AudioData3

bank3bChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3bChannelFallback


.include "audio/common/mus/minigame.s"
.include "audio/common/mus/fileSelect.s"
.include "audio/common/mus/fairyFountain.s"
.include "audio/common/mus/overworld.s"
.include "audio/common/mus/essenceRoom.s"
.include "audio/common/mus/ganon.s"
.include "audio/ages/mus/overworldPast.s"
.include "audio/ages/mus/nayru.s"
.include "audio/ages/mus/crescent.s"
.include "audio/ages/mus/lynnaCity.s"
.include "audio/ages/mus/lynnaVillage.s"
.include "audio/ages/mus/makuPath.s"
.include "audio/ages/mus/symmetryPresent.s"
.include "audio/common/sfx/splash.s"
.include "audio/common/sfx/text2.s"
.include "audio/common/sfx/filledHeartContainer.s"
.include "audio/common/sfx/seedShooter.s"
.include "audio/common/sfx/unknown7.s"
.include "audio/common/sfx/enemyJump.s"
.include "audio/common/sfx/galeSeed.s"

sndcaStart:
sndcaChannel2:
	cmdff
sndcaChannel7:
	cmdff

.include "audio/common/sfx/selectItem.s"
.include "audio/common/sfx/solvePuzzle.s"
.include "audio/common/sfx/getItem.s"

.ifdef BUILD_VANILLA
	.dsb 152 $ff
.endif

.ends


.BANK $3c SLOT 1
.ORG 0

m_section_superfree AudioData4

bank3cChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3cChannelFallback


.include "audio/ages/mus/moonlitGrotto.s"
.include "audio/common/mus/onoxCastle.s"
.include "audio/common/mus/sadness.s"
.include "audio/common/mus/intro2.s"
.include "audio/ages/mus/ambiPalace.s"
.include "audio/ages/mus/tokayHouse.s"
.include "audio/ages/mus/mermaidsCave.s"
.include "audio/ages/mus/skullDungeon.s"
.include "audio/ages/mus/blackTower.s"
.include "audio/ages/mus/fairyForest.s"
.include "audio/ages/mus/ralph.s"
.include "audio/ages/mus/spiritsGrave.s"
.include "audio/ages/mus/wingDungeon.s"
.include "audio/ages/mus/crownDungeon.s"
.include "audio/ages/mus/jabuJabusBelly.s"
.include "audio/common/sfx/damageEnemy.s"
.include "audio/common/sfx/chargeSword.s"
.include "audio/common/sfx/clink.s"
.include "audio/common/sfx/throw.s"
.include "audio/common/sfx/bombLand.s"
.include "audio/common/sfx/jump.s"
.include "audio/common/sfx/gainHeart.s"
.include "audio/common/sfx/breakRock.s"
.include "audio/common/sfx/fairyCutscene.s"
.include "audio/ages/sfx/currents.s"
.include "audio/ages/sfx/ages.s"

.ifdef BUILD_VANILLA
	.dsb 678 $ff
.endif

.ends


.BANK $3d SLOT 1
.ORG 0

m_section_superfree AudioData5

bank3dChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3dChannelFallback


.include "audio/common/mus/triumphant.s"
.include "audio/common/mus/disaster.s"
.include "audio/common/mus/pirates.s"
.include "audio/common/mus/finalDungeon.s"
.include "audio/common/mus/rosaDate.s"
.include "audio/common/mus/roomOfRites.s"
.include "audio/common/mus/blackTowerEntrance.s"
.include "audio/common/mus/zeldaSaved.s"
.include "audio/common/mus/mapleTheme.s"
.include "audio/common/mus/intro1.s"
.include "audio/common/mus/crazyDance.s"
.include "audio/ages/mus/ancientTomb.s"

snd93Start:
snd93Channel2:
	cmdff

snd94Start:
snd94Channel2:
	cmdff

.include "audio/common/sfx/compass.s"
.include "audio/common/sfx/land.s"
.include "audio/common/sfx/switchHook.s"
.include "audio/common/sfx/opening.s"
.include "audio/common/sfx/clink2.s"
.include "audio/common/sfx/fallInHole.s"
.include "audio/common/sfx/error.s"
.include "audio/common/sfx/solvePuzzle2.s"
.include "audio/common/sfx/damageLink.s"
.include "audio/common/sfx/gohmaSpawnGel.s"

.ifdef BUILD_VANILLA
	.dsb 93 $ff
.endif

.ends


.BANK $3e SLOT 1
.ORG 0

m_section_superfree AudioData6

bank3eChannelFallback:
	cmdff

.redefine MUSIC_CHANNEL_FALLBACK bank3eChannelFallback


; Undefined sounds
mus37Start:
mus3aStart:
mus3bStart:
mus3dStart:
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
mus3dChannel1:
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
mus3dChannel0:
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
mus3dChannel4:
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
mus3dChannel6:
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


.include "audio/common/mus/greatMoblin.s"
.include "audio/common/mus/ladxSideview.s"
.include "audio/common/mus/syrup.s"
.include "audio/common/mus/goronCave.s"
.include "audio/common/mus/credits2.s"
.include "audio/common/mus/boss.s"
.include "audio/common/mus/credits1.s"
.include "audio/ages/mus/symmetryPast.s"
.include "audio/ages/mus/zoraVillage.s"
.include "audio/common/sfx/heartBeep.s"
.include "audio/common/sfx/rupee.s"
.include "audio/common/sfx/swordSpin.s"
.include "audio/common/sfx/openChest.s"
.include "audio/common/sfx/cutGrass.s"
.include "audio/common/sfx/enterCave.s"
.include "audio/common/sfx/bigExplosion.s"
.include "audio/common/sfx/boomerang.s"
.include "audio/common/sfx/dropEssence.s"
.include "audio/common/sfx/text.s"

.ifdef BUILD_VANILLA
	.dsb 3 $ff
.endif

.ends


.undefine MUSIC_CHANNEL_FALLBACK
